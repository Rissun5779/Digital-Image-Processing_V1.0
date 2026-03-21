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
// Title         : PCI Express BFM Root Port Avalon-ST Parameterized VC Interface
// Project       : PCI Express MegaCore function
//-----------------------------------------------------------------------------
// File          : altpcietb_bfm_vc_intf_param.v
// Author        : Altera Corporation
//-----------------------------------------------------------------------------
// Description :
// This entity interfaces between the root port transaction list processor
// and the root port module single VC interface. It handles the following basic
// functions:
// * Formating Tx Descriptors
// * Retrieving Tx Data as needed from the shared memory
// * Decoding Rx Descriptors
// * Storing Rx Data as needed to the shared memory
//-----------------------------------------------------------------------------

module altpcietb_bfm_vc_intf_tx_driver #
  (
   parameter AST_WIDTH = 256,
   parameter AST_SOP_WIDTH = 1,
   parameter AST_MTY_WIDTH = 2,
   parameter PACKED_MODE = 0,
   parameter [96:1] INTERFACE_LABEL = "Generic     "
   )
   (
    input logic                        clk_in,
    input logic                        rstn,
    // Tx Avalon-ST Interface
    output logic                       tx_st_valid,
    input logic                        tx_st_ready,
    output logic [(AST_WIDTH-1):0]     tx_st_data,
    output logic [(AST_SOP_WIDTH-1):0] tx_st_sop,
    output logic [(AST_SOP_WIDTH-1):0] tx_st_eop,
    output logic [(AST_MTY_WIDTH-1):0] tx_st_empty, // Needs correct mapping, see below
    output logic                       tx_err, // not currently used
    // Tx Packet Interface
    input                              altpcietb_bfm_vc_intf_param_pkg::altpcietb_tlp_struct tx_tlp ,
    input bit                          tx_tlp_valid ,
    output bit                         tx_tlp_ack
    ) ;

`include "altpcietb_g3bfm_constants.v"
`include "altpcietb_g3bfm_log.v"
`include "altpcietb_g3bfm_shmem.v"
`include "altpcietb_g3bfm_req_intf.v"

   import altpcietb_bfm_vc_intf_param_pkg::* ;

   // Registers for Tx Avalon-ST inputs and outputs just like real application
   // Behavioral code "behind" these registers
   // Most straightforward way to gaurantee ready/valid latency
   logic tx_st_valid_m1 ;
   logic tx_st_ready_r1 ;
   logic [(AST_WIDTH-1):0] tx_st_data_m1 ;
   logic [(AST_SOP_WIDTH-1):0] tx_st_sop_m1 ;
   logic [(AST_SOP_WIDTH-1):0] tx_st_eop_m1 ;
   logic [(AST_MTY_WIDTH-1):0] tx_st_empty_m1 ;
   logic                       tx_err_m1 ;// not currently used

   // Housekeeping Variables
   int                         tx_st_curr_dw ;
   int                         block_more_tlp ;
   altpcietb_tlp_struct tx_tlp_curr ;

   // now create the Avalon-ST TX interface registers
   always @(posedge clk_in or negedge rstn)
     begin : tx_st_regs
        if (rstn != 1'b1)
          begin
             tx_st_valid    <= 1'b0 ;
             tx_st_ready_r1 <= 1'b0 ;
             tx_st_data     <= '0 ;
             tx_st_sop      <= '0 ;
             tx_st_eop      <= '0 ;
             tx_st_empty    <= '0 ;
             tx_err         <= 1'b0 ;
          end
        else
          begin
             tx_st_valid    <= tx_st_valid_m1 ;
             tx_st_ready_r1 <= tx_st_ready ;
             tx_st_data     <= tx_st_data_m1  ;
             tx_st_sop      <= tx_st_sop_m1 ;
             tx_st_eop      <= tx_st_eop_m1 ;
             tx_st_empty    <= tx_st_empty_m1 ;
             tx_err         <= tx_err_m1 ;
          end
     end // block: tx_st_regs

   // Empty Mapping
   // 256b
   //   1 SOP
   //      empty[1:0]
   //        00 - No empty QW
   //        01 - QW3 (DW7:6) are empty
   //        10 - QW3:2 (DW7:4) are empty
   //        11 - QW3:1 (DW7:2) are empty
   //   2 SOP (For this case, only 0 or 1 is calculated
   //          based on what next_dw is)
   //      empty[1]   - QW3 (DW7:6) are empty
   //      empty[0]   - QW1 (DW3:2) are empty
   //   4 SOP
   //      not used
   // 128b
   //   1 SOP
   //      empty[1]   - Not Used
   //      empty[0]   - QW1 (DW3:2) are empty
   //   2 SOP
   //      empty[1:0] - not used
   //  64b
   //   1 SOP
   //      empty[1:0] - not used

   // Indicate how many valid empty bits there are for this transfer
   function int num_valid_empty_bits ;
      case (AST_WIDTH)
        256 :
          case (AST_SOP_WIDTH)
            1: return (2) ;
            2: return (1) ;
            4: return (0) ;
          endcase // case (AST_SOP_WIDTH)
        128 :
          if (AST_SOP_WIDTH == 1)
            return (1) ;
          else
            return (0) ;
        64 : return (0) ;
      endcase // case (AST_WIDTH)
   endfunction : num_valid_empty_bits

   // Calculate the empty value for the two bit empty case
   function bit[1:0] twobit_empty(int curr_dw) ;
     // curr_dw is the last valid dword
     case (curr_dw)
       0: return(2'b11) ;
       1: return(2'b11) ;
       2: return(2'b10) ;
       3: return(2'b10) ;
       4: return(2'b01) ;
       5: return(2'b01) ;
       6: return(2'b00) ;
       7: return(2'b00) ;
       default : return (2'b00) ;
     endcase // case (next_dw)
   endfunction : twobit_empty

   // Calculate the empty value for the one bit empty case
   function bit onebit_empty(int curr_dw) ;
     // curr_dw is the last valid dword
     case (curr_dw)
       0: return(1'b1) ;
       1: return(1'b1) ;
       2: return(1'b0) ;
       3: return(1'b0) ;
       4: return(1'b1) ;
       5: return(1'b1) ;
       6: return(1'b0) ;
       7: return(1'b0) ;
       default : return (2'b00) ;
     endcase // case (next_dw)
   endfunction : onebit_empty

   // Return the correct SOP/EOP bit number based on:
   //    * Parameterized Data Width
   //    * Parameterized SOP/EOP Width (EOP width same as SOP width)
   //    * Current DWord
   function int sop_eop_bit_num(int curr_dw) ;
      case (AST_SOP_WIDTH)
        1: return (0) ; // Only one EOP
        2:
          begin
             if (AST_WIDTH == 128)
               return (curr_dw >> 1) ; // 128b (4DW) intf, 2 EOP => One EOP for each 2DW
             else
               return (curr_dw >> 2) ; // 256b (8DW) intf, 2 EOP => Two EOP for each 4DW
          end
        4:
          begin
             return (curr_dw >> 1) ; // 256b (8DW) intf, 4 EOP => One EOP for each 2DW
          end
      endcase
   endfunction : sop_eop_bit_num

   task wait_ready_cycle ;
     begin
        do begin
           @(posedge clk_in) ;
           tx_st_valid_m1 = 1'b0 ;
           tx_st_sop_m1   = '0 ;
           tx_st_eop_m1   = '0 ;
           tx_st_empty_m1 = '0 ;
           tx_st_data_m1  = '0 ;
        end while (tx_st_ready_r1 != 1'b1) ;
     end // task wait_ready_cycle
   endtask : wait_ready_cycle

   task assert_eop_empty ;
      begin
         tx_st_eop_m1[sop_eop_bit_num(tx_st_curr_dw)] = 1'b1 ; // Assert Correct EOP bit
         case (num_valid_empty_bits())
           2: tx_st_empty_m1 = twobit_empty(tx_st_curr_dw) ;
           1: tx_st_empty_m1[tx_st_curr_dw >> 2] = onebit_empty(tx_st_curr_dw) ;
           0: tx_st_empty_m1 = 2'b00 ; // Not valid, zero out
         endcase
      end
   endtask : assert_eop_empty

   task deassert_sop_eop_empty ;
      begin
         tx_st_eop_m1[sop_eop_bit_num(tx_st_curr_dw)] = 1'b0 ; // DeAssert Correct EOP bit
         tx_st_sop_m1[sop_eop_bit_num(tx_st_curr_dw)] = 1'b0 ; // DeAssert Correct SOP bit
         case (num_valid_empty_bits())
           2: tx_st_empty_m1 = 2'b00 ;
           1: tx_st_empty_m1[tx_st_curr_dw >> 2] = 1'b0 ;
           0: tx_st_empty_m1 = 2'b00 ; // Not valid, zero out
         endcase
      end
   endtask : deassert_sop_eop_empty

   task get_next_tlp ;
      begin
         wait (tx_tlp_valid == 1'b1) ;
         // Latch current TLP and ACK it
         tx_tlp_curr = tx_tlp ;
         tx_tlp_ack <= 1'b1 ;
         wait (tx_tlp_valid == 1'b0) ;
         tx_tlp_ack   <= 1'b0 ;
      end
   endtask : get_next_tlp

   task apply_header ;
      begin
         // We can apply the SOP and the first 2 DW's directly
         tx_st_valid_m1 = 1'b1 ;
         tx_st_sop_m1[sop_eop_bit_num(tx_st_curr_dw)] = 1'b1 ;
         tx_st_data_m1[(((tx_st_curr_dw+1)*32)-1)-:32] = tx_tlp_curr.dw0.dw ;
         tx_st_curr_dw++ ;
         tx_st_data_m1[(((tx_st_curr_dw+1)*32)-1)-:32] = tx_tlp_curr.dw1.dw ;
         tx_st_curr_dw++ ;
         // If this is a cfg0 we need to block other stuff from same cycle
         if (tx_tlp_curr.dw0.field.tlp_type == Cfg0)
           begin
              block_more_tlp <= 1'b1 ;
           end
         // Now we need to check and see if we hit the end of the current cycle
         if (tx_st_curr_dw*32 >= AST_WIDTH)
           begin
              // Wait for another ready cycle
              wait_ready_cycle();
              tx_st_curr_dw = 0 ;
           end
         // Reapply valid in case deasserted by lack of ready
         tx_st_valid_m1 = 1'b1 ;
         // Now decide if we have a 4DW header
         if (tlp_has_4dw_header(tx_tlp_curr))
           begin
              tx_st_data_m1[(((tx_st_curr_dw+1)*32)-1)-:32] = tx_tlp_curr.dw23.tlp_addr[63:32] ;
              tx_st_curr_dw++ ;
           end
         // Before we possibly increment into next QW, Check if we will be having any data
         if (!tlp_has_data(tx_tlp_curr))
           begin
              // No data, assert the correct EOP
              assert_eop_empty() ;
           end
         tx_st_data_m1[(((tx_st_curr_dw+1)*32)-1)-:32] = tx_tlp_curr.dw23.tlp_addr[31:0] ;
         tx_st_curr_dw++ ;
      end
   endtask : apply_header

   task apply_data ;
      begin
         // If it had been a 4DW Header we might have rolled over the cycle
         if (tx_st_curr_dw*32 >= AST_WIDTH)
           begin
              // Wait for another ready cycle
              wait_ready_cycle();
              tx_st_curr_dw = 0 ;
              // Reapply valid in case deasserted by lack of ready
              tx_st_valid_m1 = 1'b1 ;
           end
         // Now check if we have to skip for alignment
         if ( (PACKED_MODE == 0) && (tlp_skip_dw_for_align(tx_tlp_curr)) )
           begin
              tx_st_data_m1[(((tx_st_curr_dw+1)*32)-1)-:32] = tx_tlp_curr.data[0] ; // Duplicate
//              tx_st_data_m1[(((tx_st_curr_dw+1)*32)-1)-:32] = 32'hA5A5A5A5 ; // Marker
              tx_st_curr_dw++ ;
              // If this rolls us over end of cycle, main data loop will handle
           end // if ( (PACKED_MODE == 0) && (tlp_skip_dw_for_align(tx_tlp_curr)) )
         // We are now ready to go with the data
         for (int i = 0 ; i < tx_tlp_curr.dw0.field.tlp_length_dw ; i++)
           begin
              // Did we roll over the end of cycle already??
              if (tx_st_curr_dw*32 >= AST_WIDTH)
                begin
                   // Wait for another ready cycle
                   wait_ready_cycle();
                   tx_st_curr_dw = 0 ;
                   // Reapply valid in case deasserted by lack of ready
                   tx_st_valid_m1 = 1'b1 ;
                end
              tx_st_data_m1[(((tx_st_curr_dw+1)*32)-1)-:32] = tx_tlp_curr.data[i] ;
              // If this is the last DWord, must assert correct EOP before we increment
              if (i == (tx_tlp_curr.dw0.field.tlp_length_dw-1))
                begin
                   // Assert correct EOP and Empty flags
                   assert_eop_empty() ;
                end
              tx_st_curr_dw++ ;
           end // for (int i = 0 ; i < tx_tlp_curr.dw0.field.tlp_length_dw ; i++)
      end
   endtask : apply_data

   function bit possible_to_start_another_tlp(int curr_dw) ;
      case (AST_SOP_WIDTH)
        1: return(1'b0);  // Only 1 SOP, so no
        2:
          begin
             if (AST_WIDTH == 128)
               begin
                  if (curr_dw <= 2)
                    return (1'b1) ; // 128b width, 2 SOP, curr_dw <= 2, YES (curr_dw should be exactly 2)
                  else
                    return (1'b0) ; // 128b width, 2 SOP, curr_dw > 2, NO
               end
             else
               begin
                  if (curr_dw <= 4)
                    return (1'b1) ; // 256b width, 2 SOP, curr_dw <= 4, YES (curr_dw should be exactly 4)
                  else
                    return (1'b0) ; // 256b width, 2 SOP, curr_dw > 4, NO
               end // else: !if(AST_WIDTH == 128)
          end // case: 2
        4:
          begin
             if (curr_dw <= 6)
               return (1'b1) ; // 256b width, 4 SOP, curr_dw <= 6, YES (curr_dw should be exactly 2, 4, 6)
             else
               return (1'b0) ; // 256b width, 4 SOP, curr_dw > 6, NO
          end
      endcase // case (AST_SOP_WIDTH)
   endfunction : possible_to_start_another_tlp

   function int calc_new_curr_dw_for_new_sop(int curr_dw) ;
      case (AST_SOP_WIDTH)
        2:
          begin
             if (AST_WIDTH == 128)
               begin
                  if (curr_dw <= 2)
                    return (2) ; // 128b width, 2 SOP, curr_dw <= 2, YES (curr_dw should be exactly 2)
                  else
                    return (4) ; // 128b width, 2 SOP, curr_dw > 2, NO (shouldn't get here!!!!)
               end
             else
               begin
                  if (curr_dw <= 4)
                    return (4) ; // 256b width, 2 SOP, curr_dw <= 4, YES (curr_dw should be exactly 4)
                  else
                    return (8) ; // 256b width, 2 SOP, curr_dw > 4, NO (shouldn't get here!!!!)
               end // else: !if(AST_WIDTH == 128)
          end // case: 2
        4:
          begin
             case (curr_dw)
               0: return(8) ;  // Shouldn't get here
               1: return(2) ;  // 256b width, 4 SOP, curr_dw <= 6, YES (curr_dw should be exactly 2, 4, 6)
               2: return(2) ;  // 256b width, 4 SOP, curr_dw <= 6, YES (curr_dw should be exactly 2, 4, 6)
               3: return(4) ;  // 256b width, 4 SOP, curr_dw <= 6, YES (curr_dw should be exactly 2, 4, 6)
               4: return(4) ;  // 256b width, 4 SOP, curr_dw <= 6, YES (curr_dw should be exactly 2, 4, 6)
               5: return(6) ;  // 256b width, 4 SOP, curr_dw <= 6, YES (curr_dw should be exactly 2, 4, 6)
               6: return(6) ;  // 256b width, 4 SOP, curr_dw <= 6, YES (curr_dw should be exactly 2, 4, 6)
               default : return (8); // Shouldn't get here
             endcase // case (curr_dw)
          end
      endcase // case (AST_SOP_WIDTH)
   endfunction : calc_new_curr_dw_for_new_sop

   task tx_st_driver ;
      begin
         // wait for something to do
         get_next_tlp() ;
         // wait to be ready to send it
         wait_ready_cycle();
         tx_st_curr_dw = 0 ;
         // Now go into loop sending things
         forever
           // Main Tx Avalon-ST Process
           begin : tx_st_main_process
              // When we get here should have TLP ready to go, ready cycle, curr_st_dw pointing to correct
              // location to start the TLP
              //
              // Apply the header to the interface
              apply_header();
              // Is there any data to send?
              if (tlp_has_data(tx_tlp_curr))
                begin
                   // Apply data
                   apply_data() ;
                end
              // Are we at an SOP boundary, if not pad out
              while ( (tx_st_curr_dw % ((AST_WIDTH / 32) / AST_SOP_WIDTH)) > 0)
                begin
                   tx_st_data_m1[(((tx_st_curr_dw+1)*32)-1)-:32] = 32'h00000000 ;
                   tx_st_curr_dw++ ;
                end
              // Can we start a new TLP now? Are we a multiple SOP case and is there room? Did a previous
              // Type0 already occur? Is the another TLP besides a Cfg Type0?
              // Cfg Type0 have to be applied by themselves
              if ( (possible_to_start_another_tlp(tx_st_curr_dw)) && (block_more_tlp == 1'b1) &&
                   (tx_tlp_valid == 1'b1) && (tx_tlp.dw0.field.tlp_type != Cfg0) )
                begin
                   // Multiple SOP case, room to start another, and one is ready to go
                   // Adjust curr_dw so valid for another start
                   tx_st_curr_dw = calc_new_curr_dw_for_new_sop(tx_st_curr_dw) ;
                   get_next_tlp() ;
                   // Fallout to top of loop and start applying the header
                end
              else
                begin
                   // Clear out rest of cycle if needed
                   while ( (tx_st_curr_dw * 32) < AST_WIDTH )
                     begin
                        tx_st_data_m1[(((tx_st_curr_dw+1)*32)-1)-:32] = 32'h00000000 ;
                        if ( (tx_st_curr_dw % ((AST_WIDTH / 32) / AST_SOP_WIDTH) ) == 0)
                          begin
                             deassert_sop_eop_empty;
                          end
                        tx_st_curr_dw++ ;
                     end
                   // Can't start a new TLP now, wait for at least next cycle
                   wait_ready_cycle();
                   block_more_tlp = 1'b0 ;
                   tx_st_curr_dw = 0 ;
                   if (tx_tlp_valid != 1'b1)
                     begin
                        // wait for something to do
                        get_next_tlp() ;
                        // wait to be ready to send it
                        wait_ready_cycle();
                     end
                   else
                     begin
                        // We have TLP and we are ready to go cyclewise already
                        get_next_tlp() ;
                     end
                end // else: !if( (possible_to_start_another_tlp(tx_st_curr_dw)) && (tx_tlp_valid == 1'b1) )
           end // block: tx_st_main_process
      end
   endtask : tx_st_driver

   initial
     begin
        forever
          begin : no_reset
             // Clear Packet Interface after reset
             tx_tlp_ack   <= 1'b0 ;
             // Tx ST signals
             tx_st_valid_m1    = 1'b0 ;
             tx_st_data_m1     = '0 ;
             tx_st_sop_m1      = '0 ;
             tx_st_eop_m1      = '0 ;
             tx_st_empty_m1    = '0 ;
             tx_err_m1         = 1'b0 ;   // not otherwise used
             // Clear housekeeping
             block_more_tlp = 1'b0 ;
             wait (rstn == 1'b1) ; // Wait for reset to clear
             fork
                tx_st_driver() ;   // Task to drive TLP's on to Tx ST interface
                begin : tx_st_reset_wait
                   wait (rstn != 1'b1) ;
                   void'(ebfm_display(EBFM_MSG_INFO,{INTERFACE_LABEL,"Avalon-ST Processes Being Reset."})) ;
                end
             join_any       // Should be the reset_wait triggering
             disable fork ; // Kill the other forks that are doing stuff, then we will start over
          end // block: no_reset
     end // initial begin

endmodule : altpcietb_bfm_vc_intf_tx_driver
