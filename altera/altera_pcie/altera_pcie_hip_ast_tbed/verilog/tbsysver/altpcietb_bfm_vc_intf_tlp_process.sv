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
// Title         : PCI Express BFM Root Port VC Interface TLP Processor
// Project       : PCI Express MegaCore function
//-----------------------------------------------------------------------------
// File          : altpcietb_bfm_vc_intf_tlp_process.v
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

module altpcietb_bfm_vc_intf_tlp_process
  #(
    parameter VC_NUM = 0
    )
   (
    // Interface to the module that deals with the interface to RP Core
    input        altpcietb_bfm_vc_intf_param_pkg::altpcietb_tlp_struct rx_tlp_snoop,
    input logic  rx_tlp_valid_snoop,
    input logic  rx_tlp_ack_snoop,
    output       altpcietb_bfm_vc_intf_param_pkg::altpcietb_tlp_struct tx_tlp,
    output logic tx_tlp_valid,
    input logic  tx_tlp_ack
    ) ;

`include "altpcietb_g3bfm_constants.v"
`include "altpcietb_g3bfm_log.v"
`include "altpcietb_g3bfm_shmem.v"
`include "altpcietb_g3bfm_req_intf.v"

   import altpcietb_bfm_vc_intf_param_pkg::* ;

   //TODO   $timeformat(-9,3,"ns",16) ;

   // Open and Close the local detailed log
   int           fh = 0 ;
   string        dump_fn = "altpcietb_bfm_vc_intf_tlp_process_dump.log" ;
   initial
     begin
        fh = $fopen(dump_fn,"w") ;
        if (!fh) begin
           $display("Could not open %s file for writing.",dump_fn);
        end
     end
   final
     if (fh) $fclose(fh) ;


   // Local variables used by Rx TLP Processor



   // Local variables used by Tx TLP Generator
   int           tx_lcladdr_v;
   bit           req_ack_cleared_v = 1'b1;
   bit [127:0]   req_desc_v;
   bit           req_valid_v;
   bit [31:0]    imm_data_v;
   bit           imm_valid_v;
   int           orig_lcladdr;
   int           debug_ack_loop_count ; // Only for internal debugging purposes


   // Data structures used for communication between Tx and Rx side
   typedef struct {
      shortint    expected_bytes ;
      shortint    received_bytes ;
      bit         completion_expected ;
   } completion_track_struct ;
   // Array to track what should be coming back
   completion_track_struct cpl_exp[EBFM_NUM_TAG];

   // Data structure used for communication between Rx and Tx side
   typedef struct {
      bit [63:0]  request_addr ;
      bit [12:0]  request_len_bytes ;
      bit [15:0]  requester_id ;
      bit [7:0]   requester_tag ;
      bit [2:0]   requester_tc ;
      tlp_cpl_status_type status ;
      bit [(SHMEM_ADDR_WIDTH-1):0] curr_addr ;
      bit [12:0]                   remaining_bytes ;
   } pending_memreq_struct ;
   pending_memreq_struct pending_reads  [$] ;  // Queue of pending reads


   // Signals for tx arbiter
   altpcietb_tlp_struct            req_tlp ;
   bit                             req_tlp_valid ;
   bit                             req_tlp_ack ;
   int                             consec_cpl_count = 0 ;
   const int                       max_consec_cpl = 4 ;



   // Main task to deal with received completions
   task process_completion(altpcietb_tlp_struct rx_tlp_snoop) ;
      int lcladdr ;
      shortint rx_bytes ;
      shortint startbyte ;
      shortint endbyte ;
      if (fh) $fdisplay(fh,"%t Processing Completion",$time) ;

      // Check if this completion is expected
      if (!cpl_exp[rx_tlp_snoop.dw23.cpl_field.tlp_tag].completion_expected)
        begin
           void'(ebfm_display(EBFM_MSG_ERROR_FATAL,
                              {"Root Port VC", dimage1(VC_NUM),
                               " Received unexpected completion TLP, Fmt/Type: ",
                               himage2(rx_tlp_snoop.dw0[31:24]),
                               " Tag: ", himage2(rx_tlp_snoop.dw23.cpl_field.tlp_tag)}));
        end
      if (tlp_has_data(rx_tlp_snoop))
        begin
           if (cpl_exp[rx_tlp_snoop.dw23.cpl_field.tlp_tag].expected_bytes == 0)
             begin
                void'(ebfm_display(EBFM_MSG_ERROR_FATAL,
                                   {"Root Port VC", dimage1(VC_NUM),
                                    " Received completion with data, when no data expected. FMT/Type:",
                                    himage2(rx_tlp_snoop.dw0[31:24]),
                                    " Tag: ", himage2(rx_tlp_snoop.dw23.cpl_field.tlp_tag),
                                    " DW Len: ", dimage4(rx_tlp_snoop.dw0.field.tlp_length_dw) }));
             end
           if (cpl_exp[rx_tlp_snoop.dw23.cpl_field.tlp_tag].expected_bytes !=
               (cpl_exp[rx_tlp_snoop.dw23.cpl_field.tlp_tag].received_bytes +
                rx_tlp_snoop.dw1.cpl_field.tlp_byte_count) )
             begin
                void'(ebfm_display
                      (EBFM_MSG_ERROR_FATAL,
                       {"Root Port VC", dimage1(VC_NUM),
                        " Recevied completion with unexpected byte count. FMT/Type:",
                        himage2(rx_tlp_snoop.dw0[31:24]),
                        " Tag: ",
                        himage2(rx_tlp_snoop.dw23.cpl_field.tlp_tag),
                        " Expected Bytes:",
                        dimage4(cpl_exp[rx_tlp_snoop.dw23.cpl_field.tlp_tag].expected_bytes),
                        " Previously Received Bytes:",
                        dimage4(cpl_exp[rx_tlp_snoop.dw23.cpl_field.tlp_tag].received_bytes),
                        " Remaining Byte Count in TLP:",
                        dimage4(rx_tlp_snoop.dw1.cpl_field.tlp_byte_count) }));
             end
           // Completion looks to be as expected
           lcladdr = vc_intf_get_lcl_addr(rx_tlp_snoop.dw23.cpl_field.tlp_tag) ;
           // increment address by any previously received bytes
           if (fh) $fdisplay(fh,"%t Initial Lcl Addr: %8x, Previous Received Bytes: %6d",$time,
                    lcladdr, cpl_exp[rx_tlp_snoop.dw23.cpl_field.tlp_tag].received_bytes) ;
           lcladdr = lcladdr + cpl_exp[rx_tlp_snoop.dw23.cpl_field.tlp_tag].received_bytes ;
           if (fh) $fdisplay(fh,"%t New Lcl Addr: %8x",$time,
                    lcladdr) ;
           rx_bytes = 0 ;
           for (int i = 0 ; i < rx_tlp_snoop.dw0.field.tlp_length_dw ; i++)
             begin
                if (i == 0)
                  begin
                     startbyte = rx_tlp_snoop.dw23.cpl_field.tlp_lower_addr[1:0] ;
                  end
                else
                  begin
                     startbyte = 0 ;
                  end
                if (i == (rx_tlp_snoop.dw0.field.tlp_length_dw-1))
                  begin
                     if ((rx_bytes + 4) > rx_tlp_snoop.dw1.cpl_field.tlp_byte_count)
                       endbyte = rx_tlp_snoop.dw1.cpl_field.tlp_byte_count - rx_bytes ;
                     else
                       endbyte = 3 ;
                  end
                else
                  begin
                     endbyte = 3 ;
                  end // else: !if(i == (rx_tlp_snoop.dw0.field.tlp_length_dw-1))
                if (fh) $fdisplay(fh,"%t Writing DWORD: %8x, to Shmem_addr: %8x, StartByte: %d, EndByte: %d",$time,
                         rx_tlp_snoop.data[i],
                         lcladdr,
                         startbyte,
                         endbyte) ;

                for (int j = startbyte ; j <= endbyte ; j++)
                  begin
                     shmem_write((lcladdr+rx_bytes),rx_tlp_snoop.data[i][((j+1)*8)-1-:8],1);
                     rx_bytes = rx_bytes + 1 ;
                  end
             end // for (int i = 0 ; i < rx_tlp_snoop.dw0.field.tlp_length_dw ; i++)
           cpl_exp[rx_tlp_snoop.dw23.cpl_field.tlp_tag].received_bytes
             = cpl_exp[rx_tlp_snoop.dw23.cpl_field.tlp_tag].received_bytes + rx_bytes ;
        end // if (tlp_has_data(rx_tlp_snoop))
      // Have we received all data, or was it a non-successful completion?
      if ( (cpl_exp[rx_tlp_snoop.dw23.cpl_field.tlp_tag].expected_bytes <=
            cpl_exp[rx_tlp_snoop.dw23.cpl_field.tlp_tag].received_bytes ) ||
           ( rx_tlp_snoop.dw1.cpl_field.tlp_status != CplSts_SC) )
        begin
           if (fh) $fdisplay(fh,"%t Reporting Completion Tag: %2x, Sts: %1x",$time,
                    rx_tlp_snoop.dw23.cpl_field.tlp_tag,
                    rx_tlp_snoop.dw1.cpl_field.tlp_status) ;
           // Report completion to the requester
           vc_intf_rpt_compl(rx_tlp_snoop.dw23.cpl_field.tlp_tag,rx_tlp_snoop.dw1.cpl_field.tlp_status) ;
           // Clear out that we expect it
           cpl_exp[rx_tlp_snoop.dw23.cpl_field.tlp_tag].completion_expected = 1'b0 ;
           cpl_exp[rx_tlp_snoop.dw23.cpl_field.tlp_tag].expected_bytes = 0;
           cpl_exp[rx_tlp_snoop.dw23.cpl_field.tlp_tag].received_bytes = 0 ;
        end // if ( (cpl_exp[rx_tlp_snoop.dw23.cpl_field.tlp_tag].expected_bytes <=...
      else
        begin
           if (fh) $fdisplay(fh,"%t NOT!!!! Reporting Completion for Tag: %2x, Sts: %1x, Exp Bytes: %d, Rcvd Bytes %d",$time,
                    rx_tlp_snoop.dw23.cpl_field.tlp_tag,
                    rx_tlp_snoop.dw1.cpl_field.tlp_status,
                    cpl_exp[rx_tlp_snoop.dw23.cpl_field.tlp_tag].expected_bytes,
                    cpl_exp[rx_tlp_snoop.dw23.cpl_field.tlp_tag].received_bytes) ;
        end
   endtask : process_completion

   // Process Memory Write
   task process_memory_write(altpcietb_tlp_struct rx_tlp_snoop) ;
      int lcladdr ;
      lcladdr = rx_tlp_snoop.dw23.tlp_addr[(SHMEM_ADDR_WIDTH-1):0] ;
      if (fh) $fdisplay(fh,"%t Processing %s TLP, DW Length: %d, TLP Address: %8x_%8x, LclAddr: %6x",$time,
                tlp_menomic(rx_tlp_snoop),
                rx_tlp_snoop.dw0.field.tlp_length_dw,
                rx_tlp_snoop.dw23.tlp_addr[63:32],
                rx_tlp_snoop.dw23.tlp_addr[31:0],
                lcladdr
                );
      // Simple loop to write the data
      for (int i = 0 ; i < rx_tlp_snoop.dw0.field.tlp_length_dw ; i++)
        begin
           for (int j = 0 ; j < 4 ; j++)
             begin
                if (i == 0)
                  begin
                     if (rx_tlp_snoop.dw1.req_field.tlp_fbe[0] == 1'b1)
                       begin
                          shmem_write(lcladdr,rx_tlp_snoop.data[i][((j+1)*8)-1-:8],1) ;
                       end
                  end
                else
                  begin
                     if (i == (rx_tlp_snoop.dw0.field.tlp_length_dw-1))
                       begin
                          if (rx_tlp_snoop.dw1.req_field.tlp_lbe[0] == 1'b1)
                            begin
                               shmem_write(lcladdr,rx_tlp_snoop.data[i][((j+1)*8)-1-:8],1) ;
                            end
                       end
                     else
                       begin
                          shmem_write(lcladdr,rx_tlp_snoop.data[i][((j+1)*8)-1-:8],1) ;
                       end
                  end // else: !if(i = 0)
                lcladdr++ ;
             end // for (int j = 0 ; i < 4 ; j++)
        end // for (int i = 0 ; i < rx_tlp_snoop.dw0.field.tlp_length_dw ; i++)
   endtask : process_memory_write


   task process_memory_req(altpcietb_tlp_struct rx_tlp_snoop) ;
      pending_memreq_struct pending_req ;
      pending_req.request_addr = rx_tlp_snoop.dw23.tlp_addr ;
      pending_req.requester_id = rx_tlp_snoop.dw1.req_field.tlp_reqid ;
      pending_req.requester_tag = rx_tlp_snoop.dw1.req_field.tlp_tag ;
      pending_req.requester_tc = rx_tlp_snoop.dw0.field.tlp_tc ;
      // adjust address based on FBE
      casex (rx_tlp_snoop.dw1.req_field.tlp_fbe)
        4'bxxx1 : pending_req.request_addr = pending_req.request_addr ;
        4'bxx10 : pending_req.request_addr = pending_req.request_addr+1 ;
        4'bx100 : pending_req.request_addr = pending_req.request_addr+2 ;
        4'b1000 : pending_req.request_addr = pending_req.request_addr+3 ;
      endcase // casex (rx_tlp_snoop.dw1.req_field.fbe)
      pending_req.request_len_bytes = tlp_req_expected_cpl_bytes(rx_tlp_snoop) ;
      // Now some checking on the address and length
      if ( (pending_req.request_addr >= (1 << SHMEM_ADDR_WIDTH)) ||
           ( (pending_req.request_addr + pending_req.request_len_bytes) >= (1 << SHMEM_ADDR_WIDTH)) )
        begin
           // Access beyond end memory
           pending_req.status = CplSts_CA ;
           void'(ebfm_display(EBFM_MSG_WARNING,
                              {"Received",tlp_menomic(rx_tlp_snoop),
                               " with addr 0x",himage8(rx_tlp_snoop.dw23.tlp_addr[63:32]),
                               "_",himage8(rx_tlp_snoop.dw23.tlp_addr[31:0]),
                               " Byte Len: ",pending_req.request_len_bytes
                               } )) ;
           void'(ebfm_display(EBFM_MSG_WARNING,
                                   {"Requesting access beyond end of RC memory."
                                    } )) ;
           void'(ebfm_display(EBFM_MSG_WARNING,
                              {"Returning CA Status."} )) ;
        end
      else
        begin
           if (pending_req.request_len_bytes > req_intf_ep_max_rd_req_size(0))
             begin
                // Access beyond end memory
                pending_req.status = CplSts_CA ;
                void'(ebfm_display(EBFM_MSG_WARNING,
                                   {"Received",tlp_menomic(rx_tlp_snoop),
                                    " with DW Length 0x",himage4(rx_tlp_snoop.dw0.field.tlp_length_dw),
                                    " FBE 0x",himage8(rx_tlp_snoop.dw1.req_field.tlp_fbe),
                                    " LBE 0x",himage8(rx_tlp_snoop.dw1.req_field.tlp_lbe)
                                    } )) ;
                void'(ebfm_display(EBFM_MSG_WARNING,
                                   {"Requesting more bytes ",dimage4(pending_req.request_len_bytes),
                                    " than Max Read Request Size ",dimage4(req_intf_ep_max_rd_req_size(0)),
                                    "."
                                    } )) ;
                void'(ebfm_display(EBFM_MSG_WARNING,
                                   {"Returning CA Status."} )) ;
             end // if (pending_req.request_len_bytes > req_intf_ep_max_rd_req_size(0))
           else
             if ((pending_req.request_addr[11:0] + pending_req.request_len_bytes) > 4096)
               begin
                  pending_req.status = CplSts_CA ;
                  void'(ebfm_display(EBFM_MSG_WARNING,
                                     {"Received",tlp_menomic(rx_tlp_snoop),
                                      " with addr 0x",himage8(rx_tlp_snoop.dw23.tlp_addr[63:32]),
                                      "_",himage8(rx_tlp_snoop.dw23.tlp_addr[31:0]),
                                      " Byte Len: ",pending_req.request_len_bytes
                                      } )) ;
                  void'(ebfm_display(EBFM_MSG_WARNING,
                                     {"Requesting access across 4KB Boundary."
                                      } )) ;
                  void'(ebfm_display(EBFM_MSG_WARNING,
                                     {"Returning CA Status."} )) ;
               end // if ((pending_req.request_addr[11:0] + pending_req.request_len_bytes) > 4096)
             else
               begin
                  // Looks okay
                  pending_req.status = CplSts_SC ;
                  pending_req.curr_addr = pending_req.request_addr[(SHMEM_ADDR_WIDTH-1):0];
                  pending_req.remaining_bytes = pending_req.request_len_bytes ;
               end // else: !if((pending_req.request_addr[11:0] + pending_req.request_len_bytes) > 4096)
        end // else: !if( (pending_req.request_addr >= (1 << SHMEM_ADDR_WIDTH)) ||...
      if (tlp_is_non_posted_request(rx_tlp_snoop))
        // If read request, push on Queue for Tx side
        pending_reads.push_back(pending_req) ;
      else
        // If write request, handle now
        process_memory_write(rx_tlp_snoop) ;
   endtask : process_memory_req


   // Main TLP Receiver Loop
   always
     begin
        wait (rx_tlp_ack_snoop == 1'b0) ;
        wait ( (rx_tlp_valid_snoop == 1'b1) && (rx_tlp_ack_snoop == 1'b1) ) ;
        if (tlp_is_completion(rx_tlp_snoop))
          begin
             // Process the received completion
             process_completion(rx_tlp_snoop) ;
          end
        else
          begin
             if (  (rx_tlp_snoop.dw0.field.tlp_type == MemReq) )
               begin
                  process_memory_req(rx_tlp_snoop) ;
               end
             else
               begin
                  void'(ebfm_display(EBFM_MSG_ERROR_FATAL,
                                     {"Received TLP we can't process,",
                                      " TLP Type:",tlp_menomic(rx_tlp_snoop)} )) ;
               end
          end
     end

   // Determine a legal, possibly random byte length for this operation
   function shortint pick_cpl_byte_length
     (
      pending_memreq_struct pndg_rd ,
      shortint max_payload_bytes ,
      shortint may_break_rcb ,
      shortint must_break_rcb
      ) ;
      shortint act_must_break_rcb ;
      // Figure out if we have to break
      if (pndg_rd.remaining_bytes > max_payload_bytes)
        begin
           // We will have to break, figure largest must break

        end
   endfunction : pick_cpl_byte_length


   // Completion Generator
   function altpcietb_tlp_struct cpl_tlp ;
      int req_num ;
      int ending_addr ;
      pending_memreq_struct pndg_rd ;
      int rand_max_payload ;
      begin
         // Pick a random one to do some out of orderness
         if (pending_reads.size() > 1)
           begin
              randcase
                300 : req_num = 0 ;
                150 : req_num = 1 ;
                50  :
                  if (pending_reads.size() >= 3)
                    req_num = 2 ;
                  else
                    req_num = pending_reads.size()-1 ;
                40  :
                  if (pending_reads.size() >= 4)
                    req_num = 3 ;
                  else
                    req_num = pending_reads.size()-1 ;
                30  :
                  if (pending_reads.size() >= 5)
                    req_num = 4 ;
                  else
                    req_num = pending_reads.size()-1 ;
                20  :
                  if (pending_reads.size() >= 6)
                    req_num = 5 ;
                  else
                    req_num = pending_reads.size()-1 ;
                10  :
                  if (pending_reads.size() >= 7)
                    req_num = 6 ;
                  else
                    req_num = pending_reads.size()-1 ;
              endcase // randcase
           end
         else
           begin
              req_num = 0 ;
           end
         // Don't Pop unless we are done
         pndg_rd = pending_reads[req_num] ;
         if (req_num > 0)
           if (fh) $fdisplay(fh,"######## Processing out of order read, req_num: %4d, tag: %02x",req_num,pndg_rd.requester_tag) ;
         cpl_tlp.dw0.field.tlp_type = Cpl ;
         cpl_tlp.dw0.field.tlp_tc = pndg_rd.requester_tc ;
         cpl_tlp.dw0.field.tlp_rsvd_dw0_by1_bi7 = 1'b0 ;
         cpl_tlp.dw0.field.tlp_attr2 = 1'b0 ;
         cpl_tlp.dw0.field.tlp_rsvd_dw0_by1_bi1 = 1'b0 ;
         cpl_tlp.dw0.field.tlp_th = 1'b0 ;
         cpl_tlp.dw0.field.tlp_td = 1'b0 ;
         cpl_tlp.dw0.field.tlp_ep = 1'b0 ;
         cpl_tlp.dw0.field.tlp_attr10 = 2'b00 ;
         cpl_tlp.dw0.field.tlp_at = 2'b00 ;
         // Figure out length for this TLP
         if ( pndg_rd.status != CplSts_SC )
           begin
              cpl_tlp.dw0.field.tlp_fmt = Hdr_3DW_NoD ;
              cpl_tlp.dw0.field.tlp_length_dw = 0 ;
           end
         else
           begin
              cpl_tlp.dw0.field.tlp_fmt = Hdr_3DW_WiD ;
              if (fh) $fdisplay(fh,"%t Creating Completion Tag: %2x Pndg Read Addr: %8x Bytes: %d",$time,pndg_rd.requester_tag,pndg_rd.curr_addr,pndg_rd.remaining_bytes) ;
              if (fh) $fdisplay(fh,"%t Creating Completion Tag: %2x Page Offset + Length: %d",$time,pndg_rd.requester_tag,(pndg_rd.curr_addr[11:0]+pndg_rd.remaining_bytes) ) ;
              ending_addr = (pndg_rd.remaining_bytes + pndg_rd.curr_addr) ;
              if (fh) $fdisplay(fh,"%t Creating Completion Tag: %2x Init ending Addr: %8x",$time,pndg_rd.requester_tag,ending_addr) ;
              // Pick a random max payload to use this time....
              randcase
                100 : rand_max_payload = 64 ;  // High weight for min....
                50 : rand_max_payload = 128 ;  // Half as often for 128
                10 :
                  if (req_intf_max_payload_size(0) >= 192)
                    rand_max_payload = 192 ;
                  else
                    rand_max_payload = req_intf_max_payload_size(0) ;
                50 :
                  if (req_intf_max_payload_size(0) >= 256)
                    rand_max_payload = 256 ;
                  else
                    rand_max_payload = req_intf_max_payload_size(0) ;
                10 :
                  if (req_intf_max_payload_size(0) >= 512)
                    rand_max_payload = 512 ;
                  else
                    rand_max_payload = req_intf_max_payload_size(0) ;
                10 :
                  if (req_intf_max_payload_size(0) >= 1024)
                    rand_max_payload = 1024 ;
                  else
                    rand_max_payload = req_intf_max_payload_size(0) ;
                10 :
                  if (req_intf_max_payload_size(0) >= 2048)
                    rand_max_payload = 2048 ;
                  else
                    rand_max_payload = req_intf_max_payload_size(0) ;
                10 :
                  if (req_intf_max_payload_size(0) >= 4096)
                    rand_max_payload = 4096 ;
                  else
                    rand_max_payload = req_intf_max_payload_size(0) ;
              endcase // randcase
              // now break at an RCB that is less than then selected max payload size
              if ( (pndg_rd.remaining_bytes + pndg_rd.curr_addr[1:0]) > rand_max_payload )
                begin
                   // Beyond Max Payload Size, need to break at a 64B RCB
                   // Switch end address to an RCB
                   if (fh) $fdisplay(fh,"%t Creating Completion Tag: %2x Have to chop at RCB, MPS: %4d, remaining bytes: %d, addr: %4x",$time,pndg_rd.requester_tag,rand_max_payload, pndg_rd.remaining_bytes,pndg_rd.curr_addr[15:0]) ;
                   ending_addr[5:0] = 6'b000000 ;
                   if (fh) $fdisplay(fh,"%t Creating Completion Tag: %2x RCB ending Addr: %8x",$time,pndg_rd.requester_tag,ending_addr) ;
                   while ( (ending_addr - pndg_rd.curr_addr) > rand_max_payload )
                     begin
                        // Keep backing up end_addr until done
                        ending_addr = ending_addr - 64 ;
                        if (fh) $fdisplay(fh,"%t Creating Completion Tag: %2x Backed up ending Addr: %8x",$time,pndg_rd.requester_tag,ending_addr) ;
                     end
                end // if ( (pndg_rd.remaining_bytes + pndg_rd.curr_addr[1:0]) > req_intf_max_payload_size() )
              if (fh) $fdisplay(fh,"%t Creating Completion Tag: %2x Final ending Addr: %8x",$time,pndg_rd.requester_tag,ending_addr) ;
              cpl_tlp.dw0.field.tlp_length_dw = (ending_addr - pndg_rd.curr_addr + pndg_rd.curr_addr[1:0]) / 4 ;
              if (fh) $fdisplay(fh,"%t Creating Completion Tag: %2x Final DW Length: %8x",$time,pndg_rd.requester_tag,cpl_tlp.dw0.field.tlp_length_dw) ;
           end
         cpl_tlp.dw1.cpl_field.tlp_cplid = 16'h0000 ;  // TODO Shouldn't hard code this!!!!
         cpl_tlp.dw1.cpl_field.tlp_status = pndg_rd.status  ;
         cpl_tlp.dw1.cpl_field.tlp_byte_count = pndg_rd.remaining_bytes ;
         cpl_tlp.dw23.cpl_field.tlp_cpl_not_there = 32'h00000000 ;
         cpl_tlp.dw23.cpl_field.tlp_reqid = pndg_rd.requester_id ;
         cpl_tlp.dw23.cpl_field.tlp_tag = pndg_rd.requester_tag ;
         cpl_tlp.dw23.cpl_field.tlp_rsvd_dw2_by3_bi7 = 1'b0 ;
         cpl_tlp.dw23.cpl_field.tlp_lower_addr = pndg_rd.curr_addr[5:0] ;
         for (int i = 0 ; i < cpl_tlp.dw0.field.tlp_length_dw ; i++)
           begin
              cpl_tlp.data[i] = 32'h00000000 ;
              for (int j = pndg_rd.curr_addr[1:0] ; j < 4 ; j++)
                begin
                   cpl_tlp.data[i][((j+1)*8)-1-:8] = shmem_read(pndg_rd.curr_addr,1) ;
                   pndg_rd.curr_addr++ ;
                   pndg_rd.remaining_bytes-- ;
                end
           end
         if (pndg_rd.remaining_bytes == 0)
           begin
              // Nothing left, delete from queue
              pending_reads.delete(req_num) ;
           end
         else
           begin
              // More to do, update queue
              pending_reads[req_num] = pndg_rd ;
           end
      end
   endfunction : cpl_tlp


   // Request TLP Generator
   always
     begin
        req_tlp_valid <= 1'b0 ;
        // Clear any previous acknowledgement if needed
        if (req_ack_cleared_v == 1'b0)
          begin
             if (fh) $fdisplay(fh,"%t    Clearing Req_Intf ACK up top: %1x",$time,req_ack_cleared_v) ;
             // Try to clear with no further time delays
             req_ack_cleared_v = vc_intf_clr_ack(VC_NUM);
             if (fh) $fdisplay(fh,"%t            Req_Intf ACK Cleared: %1x",$time,req_ack_cleared_v) ;
             debug_ack_loop_count = 0 ;
             while(req_ack_cleared_v == 1'b0) begin
                #1000 req_ack_cleared_v = vc_intf_clr_ack(VC_NUM);
                debug_ack_loop_count++ ;
             end
             if (fh) $fdisplay(fh,"%t            Req_Intf ACK Cleared after %d attempts",
                               $time,debug_ack_loop_count) ;

          end

        // Using the old request routines get a valid request
        if (fh) $fdisplay(fh,"%t Waiting for next Tx TLP",$time) ;
        do begin
           # 1000 vc_intf_get_req(VC_NUM, req_valid_v, req_desc_v, tx_lcladdr_v, imm_valid_v, imm_data_v);
        end while (req_valid_v != 1'b1) ;
        if (fh) $fdisplay(fh,"%t Got new tx request. 1st Dword from shmem, %08x",
                          $time, shmem_read(tx_lcladdr_v,4) ) ;

        // Now copy the request into new TLP format
        req_tlp.dw0.dw = req_desc_v[127:96] ;
        req_tlp.dw1.dw = req_desc_v[95:64] ;
        if (tlp_has_4dw_header(req_tlp))
          begin
             req_tlp.dw23.tlp_addr[63:0] = req_desc_v[63:0] ;
          end
        else
          begin
             req_tlp.dw23.tlp_addr[63:32] = 32'h00000000 ;
             req_tlp.dw23.tlp_addr[31:0]  = req_desc_v[63:32] ;
          end

        // If it is non-posted we must track for the completion
        if (tlp_is_non_posted_request(req_tlp))
          begin
             if (fh) $fdisplay(fh,"%t Starting next Non-Posted Tx TLP: %s, Tag: %2x, ReqID: %4x, LBE: %1x, FBE: %1x, ADDR: %16x",
                               $time,
                               tlp_menomic(req_tlp),
                               req_tlp.dw1.req_field.tlp_tag,
                               req_tlp.dw1.req_field.tlp_reqid,
                               req_tlp.dw1.req_field.tlp_lbe,
                               req_tlp.dw1.req_field.tlp_fbe,
                               req_tlp.dw23.tlp_addr
                               ) ;
             cpl_exp[req_tlp.dw1.req_field.tlp_tag].completion_expected = 1'b1 ;
             cpl_exp[req_tlp.dw1.req_field.tlp_tag].expected_bytes = tlp_req_expected_cpl_bytes(req_tlp) ;
             cpl_exp[req_tlp.dw1.req_field.tlp_tag].received_bytes = 0 ;
          end
        else
          begin
             if (fh) $fdisplay(fh,"%t Starting next Posted Tx TLP: %s LBE: %1x, FBE: %1x, ADDR: %16x",
                               $time,
                               tlp_menomic(req_tlp),
                               req_tlp.dw1.req_field.tlp_lbe,
                               req_tlp.dw1.req_field.tlp_fbe,
                               req_tlp.dw23.tlp_addr) ;
          end

        // Now setup the data as needed
        if (tlp_has_data(req_tlp))
          begin
             if (fh) $fdisplay(fh,"%t TLP Has Data! DW Len: %4d, Imm Flag: %1x, Imm Data: 0x%08x, Lcl Addr: 0x%08x",
                               $time,req_tlp.dw0.field.tlp_length_dw,
                               imm_valid_v,imm_data_v,tx_lcladdr_v,) ;
             if (imm_valid_v == 1'b1)
               begin
                  req_tlp.data[0] = imm_data_v ;
               end
             else
               begin
                  // DWord loop of filling data
                  for (int i = 0 ; i < req_tlp.dw0.field.tlp_length_dw ; i++)
                    begin
                       if (i == 0)
                         begin
                            orig_lcladdr = tx_lcladdr_v ;
                            // Handle contiguous non-enabled bytes at the start
                            if (req_tlp.dw1.req_field.tlp_fbe[2:0] == 3'b000)
                              begin
                                 req_tlp.data[i][23:0] = 24'h000000 ;
                              end
                            else
                              begin
                                 if (req_tlp.dw1.req_field.tlp_fbe[1:0] == 2'b00)
                                   begin
                                      req_tlp.data[i][15:0] = 16'h0000 ;
                                   end
                                 else
                                   begin
                                      if (req_tlp.dw1.req_field.tlp_fbe[0] == 1'b0)
                                        begin
                                           req_tlp.data[i][7:0] = 8'h00 ;
                                        end
                                      else
                                        begin
                                           req_tlp.data[i][7:0] = shmem_read(tx_lcladdr_v,1) ;
                                           tx_lcladdr_v++ ;
                                        end
                                      req_tlp.data[i][15:8] = shmem_read(tx_lcladdr_v,1) ;
                                      tx_lcladdr_v++ ;
                                   end
                                 req_tlp.data[i][23:16] = shmem_read(tx_lcladdr_v,1) ;
                                 tx_lcladdr_v++ ;
                              end // else: !if(req_tlp.dw1.req_field.tlp_fbe[2:0] == 3'b000)
                            req_tlp.data[i][31:24] = shmem_read(tx_lcladdr_v,1) ;
                            tx_lcladdr_v++ ;
                            if (fh) $fdisplay(fh,"%t 1st DWord of data: %08x, shmem data (rev): %08x",
                                              $time,
                                              req_tlp.data[i],
                                              shmem_read(orig_lcladdr,4)
                                              ) ;
                         end // if (i == 0)
                       else
                         begin
                            if (i == (req_tlp.dw0.field.tlp_length_dw - 1))
                              begin
                                 // Handle contiguous non-enabled bytes at the end
                                 req_tlp.data[i][7:0] = shmem_read(tx_lcladdr_v,1) ;
                                 tx_lcladdr_v++ ;
                                 if (req_tlp.dw1.req_field.tlp_lbe[3:1] == 3'b000)
                                   begin
                                      req_tlp.data[i][31:8] = 24'h000000 ;
                                   end
                                 else
                                   begin
                                      req_tlp.data[i][15:8] = shmem_read(tx_lcladdr_v,1) ;
                                      tx_lcladdr_v++ ;
                                      if (req_tlp.dw1.req_field.tlp_lbe[3:2] == 2'b00)
                                        begin
                                           req_tlp.data[i][31:16] = 16'h0000 ;
                                        end
                                      else
                                        begin
                                           req_tlp.data[i][23:16] = shmem_read(tx_lcladdr_v,1) ;
                                           tx_lcladdr_v++ ;
                                           if (req_tlp.dw1.req_field.tlp_lbe[3] == 1'b0)
                                             begin
                                                req_tlp.data[i][31:8] = 8'h00 ;
                                             end
                                           else
                                             begin
                                                req_tlp.data[i][31:24] = shmem_read(tx_lcladdr_v,1) ;
                                                tx_lcladdr_v++ ;
                                             end
                                        end
                                   end // else: !if(req_tlp.dw1.req_field.tlp_lbe[3:1] == 3'b000)
                              end // if (i == (req_tlp.dw0.field.tlp_length_dw - 1))
                            else
                              begin
                                 req_tlp.data[i][7:0] = shmem_read(tx_lcladdr_v,1) ;
                                 tx_lcladdr_v++ ;
                                 req_tlp.data[i][15:8] = shmem_read(tx_lcladdr_v,1) ;
                                 tx_lcladdr_v++ ;
                                 req_tlp.data[i][23:16] = shmem_read(tx_lcladdr_v,1) ;
                                 tx_lcladdr_v++ ;
                                 req_tlp.data[i][31:24] = shmem_read(tx_lcladdr_v,1) ;
                                 tx_lcladdr_v++ ;
                              end // else: !if(i == (req_tlp.dw0.field.tlp_length_dw - 1))
                         end // else: !if(i == 0)
                    end // for (int i = 0 ; i < req_tlp.dw0.field.tlp_length_dw ; i++)
               end // else: !if(imm_valid_v == 1'b1)
          end // if (tlp_has_data(req_tlp))

        if (fh) $fdisplay(fh,"%t Setting  Req_Intf ACK",$time) ;
        vc_intf_set_ack(VC_NUM);
        if (fh) $fdisplay(fh,"%t Clearing Req_Intf ACK after set: %1x",$time,req_ack_cleared_v) ;
        req_ack_cleared_v = vc_intf_clr_ack(VC_NUM);
        if (fh) $fdisplay(fh,"%t            ACK Cleared: %1x",$time,req_ack_cleared_v) ;

        // Now make a request to the Tx arbiter to transmit it
        wait (req_tlp_ack == 1'b0) ;
        req_tlp_valid <= 1'b1 ;
        wait (req_tlp_ack == 1'b1) ;
     end


   initial
     begin
        tx_tlp_valid <= 1'b0;
     end

   // Tx Arbiter that selects between completions and new requests
   always
     begin
        // Wait for something to do
        wait ( (pending_reads.size() > 0) || (req_tlp_valid == 1'b1) ) ;
        // Give priority to pending reads, so we keep hardware busy, but not too many in a row while a new
        // request is pending
        if ( (pending_reads.size() > 0) &&
             ( (req_tlp_valid == 1'b0) ||
               (consec_cpl_count < max_consec_cpl) ) )
          begin
             tx_tlp = cpl_tlp() ;
             if (req_tlp_valid == 1'b1)
               consec_cpl_count++ ;
          end
        else
          begin
             if (req_tlp_valid == 1'b1)
               begin
                  tx_tlp = req_tlp ;
                  consec_cpl_count = 0 ;
                  // Ack the Tx Request generator
                  req_tlp_ack <= 1'b1;
                  wait (req_tlp_valid == 1'b0);
                  req_tlp_ack <= 1'b0 ;
               end
          end

        // Ready to give it to vc_intf for transmission
        tx_tlp_valid <= 1'b1;
        wait (tx_tlp_ack == 1'b1) ;
        tx_tlp_valid <= 1'b0;
        wait (tx_tlp_ack == 1'b0) ;
        // Done with that one!
     end // always begin

endmodule : altpcietb_bfm_vc_intf_tlp_process
