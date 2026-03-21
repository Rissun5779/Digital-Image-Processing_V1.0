// (C) 2001-2018 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



`timescale 1 ps / 1 ps
//-----------------------------------------------------------------------------
// Title         : PCI Express BFM Root Port Avalon-ST Monitor
// Project       : PCI Express MegaCore function
//-----------------------------------------------------------------------------
// File          : altpcietb_bfm_ast_monitor.v
// Author        : Altera Corporation
//-----------------------------------------------------------------------------
// Description :
// This entity extracts TLP's from an Avalon-ST interface and puts them in a
// TLP Data Structure which it handshakes out to some other processor.
//-----------------------------------------------------------------------------

module altpcietb_bfm_ast_monitor #
  (
   parameter AST_WIDTH = 256,
   parameter AST_SOP_WIDTH = 1,
   parameter AST_MTY_WIDTH = 2,
   parameter PACKED_MODE = 0,
   parameter [96:1] INTERFACE_LABEL = "Generic     "
   )
   (
    input logic                       clk_in,
    input logic                       rstn,
    // Avalon-ST interface
    input logic                       st_valid,
    input logic [(AST_WIDTH-1):0]     st_data,
    input logic [(AST_SOP_WIDTH-1):0] st_sop,
    input logic [(AST_SOP_WIDTH-1):0] st_eop,
    input logic [(AST_MTY_WIDTH-1):0] st_empty,
    // Packet Interface
    output                            altpcietb_bfm_vc_intf_param_pkg::altpcietb_tlp_struct tlp ,
    output bit                        tlp_valid ,
    input bit                         tlp_ack
    ) ;

`include "altpcietb_g3bfm_constants.v"
`include "altpcietb_g3bfm_log.v"
`include "altpcietb_g3bfm_shmem.v"
`include "altpcietb_g3bfm_req_intf.v"

   import altpcietb_bfm_vc_intf_param_pkg::* ;

   // latched versions of the signals so that are stable while we might be handshaking with the
   // TLP consumers (sim delta problems)
   logic [(AST_WIDTH-1):0]            st_data_l;
   logic [(AST_SOP_WIDTH-1):0]        st_sop_l;
   logic [(AST_SOP_WIDTH-1):0]        st_eop_l;
   logic [(AST_MTY_WIDTH-1):0]        st_empty_l;
   int                                st_time_ns_l;
   // Housekeeping Variables
   int                                st_curr_dw ;
   bit                                eop_is_asserted ;
   int                                num_empty_qw ;
   bit                                cycle_in_pkt;

   // Return the correct SOP based on:
   //    * Parameterized Data Width
   //    * Parameterized SOP Width
   //    * Current DWord
   function bit get_correct_sop(int curr_dw) ;
      case (AST_SOP_WIDTH)
        1: return (st_sop_l[0]) ; // Only one SOP matters
        2:
          begin
             if (AST_WIDTH == 128)
               return (st_sop_l[curr_dw >> 1]) ; // 128b (4DW) intf, 2 EOP => One SOP for each 2DW
             else
               return (st_sop_l[curr_dw >> 2]) ; // 256b (8DW) intf, 2 EOP => Two SOP for each 4DW
          end
        4:
          begin
             return (st_sop_l[curr_dw >> 1]) ; // 256b (8DW) intf, 4 EOP => One SOP for each 2DW
          end
      endcase
   endfunction : get_correct_sop

  // Return the correct EOP based on:
   //    * Parameterized Data Width
   //    * Parameterized EOP Width (same as SOP width)
   //    * Current DWord
   function bit get_correct_eop(int curr_dw) ;
      case (AST_SOP_WIDTH)
        1: return (st_eop_l[0]) ; // Only one EOP matters
        2:
          begin
             if (AST_WIDTH == 128)
               return (st_eop_l[curr_dw >> 1]) ; // 128b (4DW) intf, 2 EOP => One EOP for each 2DW
             else
               return (st_eop_l[curr_dw >> 2]) ; // 256b (8DW) intf, 2 EOP => Two EOP for each 4DW
          end
        4:
          begin
             return (st_eop_l[curr_dw >> 1]) ; // 256b (8DW) intf, 4 EOP => One EOP for each 2DW
          end
      endcase
   endfunction : get_correct_eop

   // Return the number of empty quadwords in this cycle based on:
   //    * Parameterized Data Width
   //    * Parameterized EOP Width (same as SOP width)
   //    * Current DWord, which must be within Qword(s) that has EOP set
   function int get_empty_qw(int curr_dw) ;
      case (AST_WIDTH)
        64: return(0) ;  // 64b (1QW) intf, so no possible empty QWords
        128:
          begin
             if (AST_SOP_WIDTH == 2)
               return(0) ; // 128b (2QW) intf, 2 EOP => SOP/EOP for each QWord, so no possible empty QWords
             else
               return(st_empty_l[0]) ; // 128b (2QW) intf, 1 EOP => One Empty bit
          end
        256:
          begin
             case (AST_SOP_WIDTH)
               4: return(0) ;  // 256b (4QW) intf, 4 EOP => SOP/EOP for each QWord, so no possible empty QWords
               2: return(st_empty_l[curr_dw >> 1]) ; // 256b (4QW) intf, 2 EOP => One Empty bit/half
               1: return(st_empty_l) ; // 256b (4QW) intf, 4 EOP => Two Empty bits for whole interface
             endcase
          end
      endcase
   endfunction : get_empty_qw

   task next_valid_data ;
      do @(posedge clk_in) ;
      while (st_valid !== 1'b1) ;
      st_sop_l = st_sop ;
      st_eop_l = st_eop ;
      st_data_l = st_data ;
      st_empty_l = st_empty ;
      st_time_ns_l = $time/1000 ;
   endtask : next_valid_data

   task extract_header ;
      tlp.sop_time = $time ;
      // When entering st_curr_dw should be pointing at st_data DW that has DW0 of the header,
      // and corresponding SOP should already have been found to be assserted.
      // Simply extract first two DW's of header...
      tlp.start_dw = st_curr_dw ;
      tlp.dw0.dw = st_data_l[(((st_curr_dw+1)*32)-1)-:32] ;
      st_curr_dw++ ;
      tlp.dw1.dw = st_data_l[(((st_curr_dw+1)*32)-1)-:32] ;
      st_curr_dw++ ;
      // Reset eop flag
      eop_is_asserted = 1'b0 ;
      // Now we need to check if we hit the end of the cycle
      if (st_curr_dw*32 >= AST_WIDTH)
        begin
           // wait for next clock edge with valid asserted
           next_valid_data() ;
           st_curr_dw = 0 ;
        end
      // Now check and see what type of header we have to deal with...
      if (tlp_has_4dw_header(tlp))
        begin
           tlp.dw23.tlp_addr[63:32] = st_data_l[(((st_curr_dw+1)*32)-1)-:32] ;
           st_curr_dw++ ;
        end
      // Check EOP before we possibly increment out of this QuadWord
      eop_is_asserted = get_correct_eop(st_curr_dw) ;
      if (eop_is_asserted)
        begin
           tlp.eop_time = $time ;
           num_empty_qw = get_empty_qw(st_curr_dw) ;
        end
      // Extract last DW of header and increment
      tlp.dw23.tlp_addr[31:0] = st_data_l[(((st_curr_dw+1)*32)-1)-:32] ;
      st_curr_dw++ ;
   endtask : extract_header

   task extract_data ;
      int data_dw ;
      begin
         data_dw = 0 ;
         if ( (PACKED_MODE == 0) && (tlp_skip_dw_for_align(tlp)) )
           begin
              st_curr_dw++ ;
           end
         do
           begin : st_data_loop
              while ((st_curr_dw*32) < AST_WIDTH)
                begin
                   // Might come in with EOP already asserted and num_empty already set
                   // But that would mean we are in same QW as last part of header
                   // Check EOP before we possibly increment out of this QuadWord
                   eop_is_asserted = get_correct_eop(st_curr_dw) ;
                   if (eop_is_asserted)
                     begin
                        tlp.eop_time = $time ;
                        num_empty_qw = get_empty_qw(st_curr_dw) ;
                     end
                   // Now increment
                   tlp.data[data_dw] = st_data_l[(((st_curr_dw+1)*32)-1)-:32];
                   data_dw++ ;
                   st_curr_dw++ ;
                   // If we have incremented out of area covered by EOP and EOP was asserted, break
                   if ( ( (st_curr_dw % ((AST_WIDTH/32)/AST_SOP_WIDTH)) == 0) && (eop_is_asserted) )
                     break ; // Break out of loop
                end
              if (eop_is_asserted)
                begin
                   // Backup up the DW Length if empty
                   // Note the DW Length still might be padded by 1, TLP decoder
                   // needs to figure that out
                   data_dw = data_dw - (num_empty_qw * 2) ;
                end // if (eop_is_asserted)
              else
                begin
                   // Wait for next valid cycle
                   next_valid_data();
                   st_curr_dw = 0 ;
                end // else: (!eop_is_asserted)
           end // block: st_data_loop
         while (!eop_is_asserted) ;
      end
   endtask : extract_data

   task find_valid_sop_next_cycle ;
      begin
         next_valid_data();
         st_curr_dw = 8 ; // Flag that we didn't find anything
         for (int i = 0 ; i < AST_SOP_WIDTH ; i++)
           begin
              if (st_sop_l[i] == 1'b1)
                begin
                   // Give the right Starting DW
                   case (i)
                     0 : st_curr_dw = 0 ; // If sop[0], dw always 0
                     1 :
                       if (AST_WIDTH == 128)
                         st_curr_dw = 2 ;  // sop[1], 128b width so dw = 2
                       else
                         // 256b
                         if (AST_SOP_WIDTH == 2)
                           st_curr_dw = 4 ; // sop[1], 256b width, 2 sop, so dw = 4
                         else
                           st_curr_dw = 2 ; // sop[1], 256b width, 4 sop, so dw = 2
                     2 : st_curr_dw = 4 ; // sop[2], 256b width, 4 sop, so dw = 4
                     3 : st_curr_dw = 6 ; // sop[3], 256b width, 4 sop, so dw = 6
                   endcase // case (i)
                   break ;  // Break out of the loop since we found something
                end // if (st_sop_l[i] == 1'b1)
           end // for (int i = 0 ; i < AST_SOP_WIDTH ; i++)
         if (st_curr_dw*32 >= AST_WIDTH )
           begin
              void'(ebfm_display(EBFM_MSG_ERROR_FATAL,
                                 {INTERFACE_LABEL,
                                  " From Idle Avalon ST Valid asserted, but no SOP at all. SOP:",
                                  himage1(st_sop_l)})) ;
           end
      end
   endtask : find_valid_sop_next_cycle

   function bit is_valid_sop_this_cycle ;
      // If only one SOP we are done
      if ( (AST_SOP_WIDTH == 1) || ( (st_curr_dw*32) >= AST_WIDTH))
        begin
           st_curr_dw = 0 ;  // For next cycle
           return(1'b0) ;
        end
      else
        begin
           if (AST_SOP_WIDTH == 2)
             begin
                if (AST_WIDTH == 128)
                  begin
                     if (st_curr_dw <= 2)
                       begin
                          st_curr_dw = 2 ;  // Adjust to possible SOP
                          // 128b, 2 SOP, ended in first 2DW, check next SOP
                          if (st_sop_l[(st_curr_dw >> 1)])
                            begin
                               return (1'b1) ;
                            end
                          else
                            begin
                               st_curr_dw = 0 ;  // For next cycle
                               return(1'b0) ;
                            end
                       end
                     else
                       begin
                          // 128b, 2 SOP, ended in last 2DW, nothing
                          st_curr_dw = 0 ;  // For next cycle
                          return(0) ;
                       end
                  end // if (AST_WIDTH == 128)
                else
                  begin
                     // 256b width, 2SOP
                     if (st_curr_dw <= 4)
                       begin
                          st_curr_dw = 4 ; // Adjust to possible SOP
                          // 256b, 2 SOP, ended in first 4DW, check next SOP
                          if (st_sop_l[(st_curr_dw >> 2)])
                            begin
                               return (1'b1) ;
                            end
                          else
                            begin
                               st_curr_dw = 0 ;  // For next cycle
                               return(1'b0) ;
                            end
                       end // if (st_curr_dw <= 4)
                     else
                       begin
                          // 256b, 2 SOP, ended in last 4DW, nothing
                          st_curr_dw = 0 ;  // For next cycle
                          return(0) ;
                       end // else: !if(st_curr_dw <= 4)
                  end // else: !if(AST_WIDTH == 128)
             end // if (AST_SOP_WIDTH == 2)
           else
             begin
                // 4 SOP, must be 256b
                // roundup curr_dw to next SOP boundary
                // If last SOP ended on odd boundary, need to skip one
                st_curr_dw = st_curr_dw + (st_curr_dw % 2) ;
                for (int i = (st_curr_dw >> 1) ; i < AST_SOP_WIDTH ; i++ )
                  begin
                     if (st_sop_l[i] == 1'b1) return(1'b1) ;
                     st_curr_dw = st_curr_dw + 2 ;
                  end
                // If we come out of above loop with st_curr_dw less than max,
                // we found SOP and returned out of loop
                st_curr_dw = 0 ; // For next cycle
                return (1'b0) ;
             end // else: !if(AST_SOP_WIDTH == 2)
        end // else: !if( (AST_SOP_WIDTH == 1) || ( (st_curr_dw*32) >= AST_WIDTH))
   endfunction : is_valid_sop_this_cycle

   task st_monitor ;
      begin
         // Initial idle state, wait for something to show up
         find_valid_sop_next_cycle() ;
         // Now start a loop forever checking for data
         forever
           begin : st_main_process
              // When we get here from the start, or from completion of previous TLP extraction,
              // st_valid is asserted and st_curr_dw should be pointing to an SOP QWord
              if (get_correct_sop(st_curr_dw) == 1'b0)
                begin
                   void'(ebfm_display(EBFM_MSG_ERROR_FATAL,
                                      {INTERFACE_LABEL,
                                       " From Idle Avalon ST Valid asserted, but no SOP.  SOP:",
                                       himage1(st_sop_l),
                                       " EOP: ",himage1(st_eop_l),
                                       " Curr DW: ",dimage1(st_curr_dw)})) ;
                end

              // Extract the header we just found
              extract_header() ;
              if (tlp_has_data(tlp))
                begin
                   extract_data() ;
                end // if (tlp_has_data(tlp))
              else
                begin
                   if (!eop_is_asserted)
                     begin
                        void'(ebfm_display
                              (EBFM_MSG_ERROR_FATAL,
                               {INTERFACE_LABEL,
                                " Avalon ST Header only TLP did not have EOP asserted on last QW of header."})) ;
                     end
                end // else: !if(tlp_has_data(tlp))
              // Check ourselves when we are here, just after header and data extraction,
              // the last DW should have EOP asserted
              if (!get_correct_eop((st_curr_dw-1)))
                begin
                   void'(ebfm_display(EBFM_MSG_ERROR_CONTINUE,"Not just past EOP after header/data extraction.")) ;
                   void'(ebfm_display(EBFM_MSG_ERROR_FATAL,
                                      {"Curr DW: ",dimage1(st_curr_dw),
                                       ", SOP: ",himage1(st_sop_l),
                                       ", EOP: ",himage1(st_eop_l),
                                       ", MTY: ",himage1(st_empty_l)
                                       }));
                end
              // Now handshake with the packet processor
              tlp_valid <= 1'b1 ;
              wait (tlp_ack == 1'b1) ;
              tlp_valid <= 1'b0;
              wait (tlp_ack == 1'b0) ;
              // Now find the next SOP, first see if anything in rest of current cycle
              if (!is_valid_sop_this_cycle())
                begin
                   // No SOP found, now we wait for next one
                   find_valid_sop_next_cycle() ;
                end
           end // block: st_main_process
      end
   endtask : st_monitor

   // This flag checker uses the live signals since it doesn't handshake with anything else
   // Best to use the live signals to do a real check
   // It also runs independently of the other tasks
   task st_flag_check ;
      bit        in_pkt ;
      forever
        begin
           do @(posedge clk_in) ;
           while (st_valid !== 1'b1) ;
           if ( (cycle_in_pkt == 1'b0) &&
                (st_sop == {AST_SOP_WIDTH{1'b0}}) &&
                (st_eop == {AST_SOP_WIDTH{1'b0}}) )
             begin
                void'(ebfm_display
                      (EBFM_MSG_ERROR_FATAL,
                       {INTERFACE_LABEL,
                        " VALID with no corresponding SOP.",
                        ", in_pkt: ",himage1(cycle_in_pkt),
                        ", SOP: ",himage1(st_sop),
                        ", EOP: ",himage1(st_eop),
                        ", MTY: ",himage1(st_empty)
                        })) ;
             end // if ( (cycle_in_pkt == 1'b0) &&...
           else
             begin
                in_pkt = cycle_in_pkt ;
                for (int i = 0 ; i < AST_SOP_WIDTH ; i++)
                  begin
                     casex ({st_eop[i],st_sop[i],in_pkt})
                       3'b000 :
                         begin
                            // Assume activity elsewhere in cycle
                            // (Check above catches no activity case)
                            in_pkt = 1'b0;
                         end // case: 3'b000
                       3'b001 :
                         begin
                            // normal mid packet
                            in_pkt = 1'b1 ;
                         end
                       3'b010 :
                         begin
                            // normal packet starting
                            in_pkt = 1'b1 ;
                         end
                       3'b011 :
                         begin
                            void'(ebfm_display
                                  (EBFM_MSG_ERROR_FATAL,
                                   {INTERFACE_LABEL,
                                    " SOP asserted in middle of packet.",
                                    " SOP/EOP bit: ",dimage1(i),
                                    ", in_pkt: ",himage1(cycle_in_pkt),
                                    ", SOP: ",himage1(st_sop),
                                    ", EOP: ",himage1(st_eop),
                                    ", MTY: ",himage1(st_empty)
                                    })) ;
                            in_pkt = 1'b0;
                         end // case: 3'b011
                       3'b100 :
                         begin
                            void'(ebfm_display
                                  (EBFM_MSG_ERROR_FATAL,
                                   {INTERFACE_LABEL,
                                    " EOP with no corresponding SOP.",
                                    " SOP/EOP bit: ",dimage1(i),
                                    ", in_pkt: ",himage1(cycle_in_pkt),
                                    ", SOP: ",himage1(st_sop),
                                    ", EOP: ",himage1(st_eop),
                                    ", MTY: ",himage1(st_empty)
                                    })) ;
                            in_pkt = 1'b0;
                         end // case: 3'b100
                       3'b101 :
                         begin
                            // normal packet ending
                            in_pkt = 1'b0 ;
                         end
                       3'b110 :
                         begin
                            if ( (AST_WIDTH / AST_SOP_WIDTH) < 128 )
                              begin
                                 void'(ebfm_display
                                       (EBFM_MSG_ERROR_FATAL,
                                        {INTERFACE_LABEL,
                                         " Can't Assert SOP/EOP in same ",dimage1(3),
                                         "b data segment.",
                                         " SOP/EOP bit: ",dimage1(i),
                                         ", in_pkt: ",himage1(cycle_in_pkt),
                                         ", SOP: ",himage1(st_sop),
                                         ", EOP: ",himage1(st_eop),
                                         ", MTY: ",himage1(st_empty)
                                         })) ;
                                 in_pkt = 1'b0;
                              end // if ( (AST_WIDTH / AST_SOP_WIDTH) < 128 )
                            else
                              begin
                                 // Normal to start end in same segment
                                 in_pkt = 1'b0 ;
                              end // else: !if( (AST_WIDTH / AST_SOP_WIDTH) < 128 )
                         end // case: 3'b110
                       3'b111 :
                         begin
                            void'(ebfm_display
                                  (EBFM_MSG_ERROR_FATAL,
                                   {INTERFACE_LABEL,
                                    " SOP asserted in middle of packet.",
                                    " SOP/EOP bit: ",dimage1(i),
                                    ", in_pkt: ",himage1(cycle_in_pkt),
                                    ", SOP: ",himage1(st_sop),
                                    ", EOP: ",himage1(st_eop),
                                    ", MTY: ",himage1(st_empty)
                                    })) ;
                            in_pkt = 1'b0;
                         end // case: 3'b111
                     endcase // casex (st_eop[i],st_sop[i],in_pkt)
                     // Check the empty flag on non-EOP cycles, if greater than 64b per EOP
                     // Length checking in the main monitor will check empty on regular EOPs
                     if ( (AST_WIDTH / AST_SOP_WIDTH) > 64)
                       begin
                          if (st_eop[i] == 1'b0)
                            begin
                               // No EOP, Empty must be 0
                               if ((AST_WIDTH / AST_SOP_WIDTH) == 128)
                                 begin
                                    // 128b/EOP Empty bit num == EOP bit num
                                    if (st_empty[i] == 1'b1)
                                      begin
                                         void'(ebfm_display
                                               (EBFM_MSG_ERROR_FATAL,
                                                {INTERFACE_LABEL,
                                                 " Empty bit non-zero in non-EOP segment.",
                                                 " SOP/EOP bit: ",dimage1(i),
                                                 ", in_pkt: ",himage1(cycle_in_pkt),
                                                 ", SOP: ",himage1(st_sop),
                                                 ", EOP: ",himage1(st_eop),
                                                 ", MTY: ",himage1(st_empty)
                                                 })) ;
                                      end // if (st_empty == 1'b1)
                                 end // if ((AST_WIDTH / AST_SOP_WIDTH) == 128)
                               else
                                 begin
                                    // 256b/EOP Empty bit num0 == EOP bit_num * 2
                                    if (st_empty[(i*2)+1+:2] != 2'b00)
                                      begin
                                         void'(ebfm_display
                                               (EBFM_MSG_ERROR_FATAL,
                                                {INTERFACE_LABEL,
                                                 " Empty bits non-zero in non-EOP segment.",
                                                 " SOP/EOP bit: ",dimage1(i),
                                                 ", in_pkt: ",himage1(cycle_in_pkt),
                                                 ", SOP: ",himage1(st_sop),
                                                 ", EOP: ",himage1(st_eop),
                                                 ", MTY: ",himage1(st_empty)
                                                 })) ;
                                      end // if (st_empty[(i*2)+1:(i*2)] != 1'b00)
                                 end // else: !if((AST_WIDTH / AST_SOP_WIDTH) == 128)
                            end // if (st_eop[i] == 1'b0)
                       end // if ( (AST_WIDTH / AST_SOP_WIDTH) > 64)
                  end // for (int i = 0 ; i < AST_SOP_WIDTH ; i++)
                cycle_in_pkt = in_pkt ;
             end // else: !if( (cycle_in_pkt == 1'b0) &&...
        end // forever begin
   endtask : st_flag_check

   initial
     begin
        forever
          begin : no_reset
             // Packet interface reset
             tlp_valid      <= 1'b0 ;
             cycle_in_pkt   <= 1'b0 ;
             wait (rstn == 1'b1) ; // Wait for reset to clear
             fork
                st_monitor() ;  // Task to collect TLP's from Rx ST interface
                st_flag_check() ;  // Task to check the SOP/EOP/Empty Flags
                begin : tx_st_reset_wait
                   wait (rstn != 1'b1) ;
                   void'(ebfm_display(EBFM_MSG_INFO,
                                      {INTERFACE_LABEL," Avalon ST Monitor Processes Being Reset."})) ;
                end
             join_any       // Should be the reset_wait triggering
             disable fork ; // Kill the other forks that are doing stuff, then we will start over
          end // block: no_reset
     end // initial begin

endmodule : altpcietb_bfm_ast_monitor

