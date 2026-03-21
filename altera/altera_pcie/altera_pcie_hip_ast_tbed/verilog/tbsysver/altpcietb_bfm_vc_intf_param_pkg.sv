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
package altpcietb_bfm_vc_intf_param_pkg ;

   typedef enum bit [2:0]
                {
                 Hdr_3DW_NoD = 3'b000,   // 3DW Header, without Data Payload
                 Hdr_4DW_NoD = 3'b001,   // 4DW Header, without Data Payload
                 Hdr_3DW_WiD = 3'b010,   // 3DW Header, with Data Payload
                 Hdr_4DW_WiD = 3'b011,   // 4DW Header, with Data Payload
                 TLP_Prefix  = 3'b100    // TLP Prefix
                 } tlp_fmt_type ;

   typedef enum bit [4:0]
                {
                 MemReq      = 5'b00000, // Memory Request
                 MemReqLk    = 5'b00001, // Memory Request-Locked
                 IOReq       = 5'b00010, // I/O Request
                 Cfg0        = 5'b00100, // Config Type 0 Request
                 Cfg1        = 5'b00101, // Config Type 0 Request
                 MsgToRC     = 5'b10000, // Msg Routed to Root Complex
                 MsgByAddr   = 5'b10001, // Msg Routed by Address
                 MsgByID     = 5'b10010, // Msg Routed by ID
                 MsgFrRC     = 5'b10011, // Msg Broadcast from Root Complex
                 MsgLocal    = 5'b10100, // Msg Local - Terminate at Receiver
                 MsgGaToRC   = 5'b10101, // Msg Gathered and Routed to Root Complex
                 Cpl         = 5'b01010, // Completion
                 CplLk       = 5'b01011, // Completion-Locked
                 FetchAdd    = 5'b01100, // Fetch and Add AtomicOp Request
                 Swap        = 5'b01101, // Unconditional Swap AtomicOp Request
                 CAS         = 5'b01110  // Compare and Swap AtomicOp Request
                 } tlp_type_type ;

   typedef enum bit [2:0]
                {
                 CplSts_SC   = 3'b000,   // Successful Completion
                 CplSts_UR   = 3'b001,   // Unsupported Request
                 CplSts_CRS  = 3'b010,   // Configuration Request Retry Status
                 CplSts_CA   = 3'b100    // Completer Abort
                 } tlp_cpl_status_type ;

   typedef struct packed {
      tlp_fmt_type  tlp_fmt ;
      tlp_type_type tlp_type ;
      bit         tlp_rsvd_dw0_by1_bi7 ;
      bit [2:0]   tlp_tc ;
      bit         tlp_rsvd_dw0_by1_bi3 ;
      bit         tlp_attr2 ;
      bit         tlp_rsvd_dw0_by1_bi1 ;
      bit         tlp_th ;
      bit         tlp_td ;
      bit         tlp_ep ;
      bit [1:0]   tlp_attr10 ;
      bit [1:0]   tlp_at ;
      bit [9:0]   tlp_length_dw ;
   } altpcietb_tlp_dw0_fields ;

   typedef union  packed {
      altpcietb_tlp_dw0_fields field ;
      bit [31:0]  dw ;
   } altpcietb_tlp_dw0_union ;

   typedef struct packed {
      bit [15:0]  tlp_reqid ;
      bit [7:0]   tlp_tag ;
      bit [3:0]   tlp_lbe ;
      bit [3:0]   tlp_fbe ;
   } altpcietb_tlp_dw1_req_fields ;

   typedef struct packed {
      bit [15:0]  tlp_cplid ;
      tlp_cpl_status_type tlp_status;
      bit         tlp_bcm ;
      bit [11:0]  tlp_byte_count ;
   } altpcietb_tlp_dw1_cpl_fields ;

   typedef union  packed {
      altpcietb_tlp_dw1_cpl_fields cpl_field ;
      altpcietb_tlp_dw1_req_fields req_field ;
      bit [31:0]  dw ;
   } altpcietb_tlp_dw1_union ;

   typedef struct packed {
      bit [31:0]  tlp_cpl_not_there ;
      bit [15:0]  tlp_reqid ;
      bit [7:0]   tlp_tag ;
      bit         tlp_rsvd_dw2_by3_bi7 ;
      bit [6:0]   tlp_lower_addr ;
   }  altpcietb_tlp_dw23_cpl_fields ;

   typedef union  packed {
      altpcietb_tlp_dw23_cpl_fields cpl_field ;
      bit [63:0]  tlp_addr ;
   } altpcietb_tlp_dw23_union ;

   typedef struct {
      altpcietb_tlp_dw0_union dw0 ;
      altpcietb_tlp_dw1_union dw1 ;
      altpcietb_tlp_dw23_union dw23 ;
      bit [31:0]  data [1024] ;
      byte        start_dw ; // For logging purposes only
      time        sop_time ;
      time        eop_time ;
   } altpcietb_tlp_struct ;

   function bit tlp_has_4dw_header(altpcietb_tlp_struct tlp) ;
      if ( (tlp.dw0.field.tlp_fmt == Hdr_4DW_NoD) ||
           (tlp.dw0.field.tlp_fmt == Hdr_4DW_WiD) )
        return 1'b1 ;
      else
        return 1'b0 ;
   endfunction : tlp_has_4dw_header

   function bit tlp_has_data(altpcietb_tlp_struct tlp) ;
      if ( (tlp.dw0.field.tlp_fmt == Hdr_4DW_WiD) ||
           (tlp.dw0.field.tlp_fmt == Hdr_3DW_WiD) )
        return 1'b1 ;
      else
        return 1'b0 ;
   endfunction : tlp_has_data

   // Provide these functions for code that does not want to deal with classes/objects
   function shortint tlp_req_expected_cpl_bytes(altpcietb_tlp_struct tlp) ;
      static shortint bytelen ;
      if (tlp_has_data(tlp))
        begin
           // Generally Non-Posted Requests with data, expect no data on return unless
           // It is an AtomicOP
           if ( (tlp.dw0.field.tlp_type == FetchAdd) || (tlp.dw0.field.tlp_type == Swap) )
             begin
                // FetchAdd and Swap will return with as many bytes as sent
                bytelen = tlp.dw0.field.tlp_length_dw*4 ;
             end
           else
             begin
                if (tlp.dw0.field.tlp_type == CAS)
                  begin
                     // CAS will return with half as many bytes as sent
                     bytelen = tlp.dw0.field.tlp_length_dw*2 ;
                  end
                else
                  begin
                     // Not AtomicOP, will have 0 bytes returned
                     bytelen = 0 ;
                  end
             end // else: !if( (tlp.dw0.field.tlp_type == FetchAdd) || (tlp.dw0.field.tlp_type == Swap) )
        end
      else
        begin
           // TLP has no data, Simple Memory, I/O or Cfg request
           // so figure out expected bytes simply from request fields
           // Start with the number of dwords and multiply by 4
           bytelen = tlp.dw0.field.tlp_length_dw*4 ;
           // now adjust per the Byte enable fields
           if (tlp.dw0.field.tlp_length_dw == 1)
             begin
                // 1 Dword, length based on FBE only
                casex(tlp.dw1.req_field.tlp_fbe)
                  4'b1xx1 : bytelen = 4 ;
                  4'b01x1 : bytelen = 3 ;
                  4'b1x10 : bytelen = 3 ;
                  4'b0011 : bytelen = 2 ;
                  4'b0110 : bytelen = 2 ;
                  4'b1100 : bytelen = 2 ;
                  4'b0001 : bytelen = 1 ;
                  4'b0010 : bytelen = 1 ;
                  4'b0100 : bytelen = 1 ;
                  4'b1000 : bytelen = 1 ;
                  4'b0000 : bytelen = 1 ; // Odd but per the PCIe spec
                endcase // casex (tlp.dw1.req_field.tlp_fbe)
             end // if (tlp.dw0.field.tlp_length_dw == 1)
           else
             begin
                // Multi-Dword
                // Adjust based on first enabled byte
                casex (tlp.dw1.req_field.tlp_fbe)
                  4'bxxx1 : bytelen = bytelen ;
                  4'bxx10 : bytelen = bytelen-1 ;
                  4'bx100 : bytelen = bytelen-2 ;
                  4'b1000 : bytelen = bytelen-3 ;
                endcase // casex (tlp.dw1.req_field.tlp_fbe)
                // Adjust based on last enabled byte
                casex (tlp.dw1.req_field.tlp_lbe)
                  4'b1xxx : bytelen = bytelen ;
                  4'b01xx : bytelen = bytelen-1 ;
                  4'b001x : bytelen = bytelen-2 ;
                  4'b0001 : bytelen = bytelen-3 ;
                endcase // casex (tlp.dw1.req_field.tlp_lbe)
             end
        end
      return (bytelen) ;
   endfunction : tlp_req_expected_cpl_bytes

   function bit tlp_skip_dw_for_align(altpcietb_tlp_struct tlp) ;
      begin
         if (tlp_has_4dw_header(tlp))
           begin
              // 4DW Header, if DW address is odd we need to skip DW
              //   Okay to use "tlp_addr" from union even on completions, since it is lower_addr
              return (tlp.dw23.tlp_addr[2]) ;
           end
         else
           begin
              // 3DW Header, if DW address is even we need to skip DW
              //   Okay to use "tlp_addr" from union even on completions, since it is lower_addr
              return (!tlp.dw23.tlp_addr[2]) ;
           end // else: !if(tlp_has_4dw_header(tlp))
      end
   endfunction : tlp_skip_dw_for_align

   function bit tlp_is_request(altpcietb_tlp_struct tlp) ;
      case(tlp.dw0.field.tlp_type)
        MemReq      : return(1'b1) ;
        MemReqLk    : return(1'b1) ;
        IOReq       : return(1'b1) ;
        Cfg0        : return(1'b1) ;
        Cfg1        : return(1'b1) ;
        MsgToRC     : return(1'b1) ;
        MsgByAddr   : return(1'b1) ;
        MsgByID     : return(1'b1) ;
        MsgFrRC     : return(1'b1) ;
        MsgLocal    : return(1'b1) ;
        MsgGaToRC   : return(1'b1) ;
        Cpl         : return(1'b0) ;
        CplLk       : return(1'b0) ;
        FetchAdd    : return(1'b1) ;
        Swap        : return(1'b1) ;
        CAS         : return(1'b1) ;
        default     : return(1'b0) ;
      endcase // case (tlp.dw0.field.tlp_type)
   endfunction : tlp_is_request

   function bit tlp_is_non_posted_request(altpcietb_tlp_struct tlp) ;
      case(tlp.dw0.field.tlp_type)
        MemReq, MemReqLk :
          if (tlp_has_data(tlp))
            return(1'b0) ;
          else
            return(1'b1) ;
        IOReq       : return(1'b1) ;
        Cfg0        : return(1'b1) ;
        Cfg1        : return(1'b1) ;
        MsgToRC     : return(1'b0) ;
        MsgByAddr   : return(1'b0) ;
        MsgByID     : return(1'b0) ;
        MsgFrRC     : return(1'b0) ;
        MsgLocal    : return(1'b0) ;
        MsgGaToRC   : return(1'b0) ;
        Cpl         : return(1'b0) ;
        CplLk       : return(1'b0) ;
        FetchAdd    : return(1'b1) ;
        Swap        : return(1'b1) ;
        CAS         : return(1'b1) ;
        default     : return(1'b0) ;
      endcase // case (tlp.dw0.field.tlp_type)
   endfunction : tlp_is_non_posted_request

   function bit tlp_is_completion(altpcietb_tlp_struct tlp) ;
      case(tlp.dw0.field.tlp_type)
        MemReq      : return(1'b0) ;
        MemReqLk    : return(1'b0) ;
        IOReq       : return(1'b0) ;
        Cfg0        : return(1'b0) ;
        Cfg1        : return(1'b0) ;
        MsgToRC     : return(1'b0) ;
        MsgByAddr   : return(1'b0) ;
        MsgByID     : return(1'b0) ;
        MsgFrRC     : return(1'b0) ;
        MsgLocal    : return(1'b0) ;
        MsgGaToRC   : return(1'b0) ;
        Cpl         : return(1'b1) ;
        CplLk       : return(1'b1) ;
        FetchAdd    : return(1'b0) ;
        Swap        : return(1'b0) ;
        CAS         : return(1'b0) ;
        default     : return(1'b0) ;
      endcase // case (tlp.dw0.field.tlp_type)
   endfunction : tlp_is_completion

   function reg [48:1] tlp_menomic(altpcietb_tlp_struct tlp) ;
      case(tlp.dw0.field.tlp_type)
        MemReq :
          if (tlp_has_data(tlp))
            return(" MemWr") ;
          else
            return(" MemRd") ;
        MemReqLk :
          if (tlp_has_data(tlp))
            return(" MLkWr") ;
          else
            return(" MLkRd") ;
        IOReq       :
          if (tlp_has_data(tlp))
            return("  IOWr") ;
          else
            return("  IORd") ;
        Cfg0        :
          if (tlp_has_data(tlp))
            return("CfgWr0") ;
          else
            return("CfgRd0") ;
        Cfg1        :
          if (tlp_has_data(tlp))
            return("CfgWr1") ;
          else
            return("CfgRd1") ;
        MsgToRC, MsgByAddr, MsgByID, MsgFrRC, MsgLocal, MsgGaToRC   :
          if (tlp_has_data(tlp))
            return("   Msg") ;
          else
            return("  MsgD") ;
        Cpl         :
          if (tlp_has_data(tlp))
            return("  CplD") ;
          else
            return("   Cpl") ;
        CplLk, Cpl         :
          if (tlp_has_data(tlp))
            return("CplLkD") ;
          else
            return(" CplLk") ;
        FetchAdd    : return("FchAdd") ;
        Swap        : return("  Swap") ;
        CAS         : return("   CAS") ;
        default     : return("Unknwn") ;
      endcase // case (tlp.dw0.field.tlp_type)
   endfunction : tlp_menomic

   function string tlp_tag_str(altpcietb_tlp_struct tlp) ;
      if (tlp_is_non_posted_request(tlp))
        begin
           return($sformatf("(%2x)",tlp.dw1.req_field.tlp_tag)) ;
        end
      else
        begin
           if(tlp_is_completion(tlp))
             begin
                return($sformatf("(%2x)",tlp.dw23.cpl_field.tlp_tag)) ;
             end
           else
             begin
                return("    ");
             end
        end // else: !if(tlp_is_non_posted_request(tlp))
   endfunction : tlp_tag_str

   function string tlp_completion_status_str(altpcietb_tlp_struct tlp) ;
      case (tlp.dw1.cpl_field.tlp_status)
        CplSts_SC  : return ("(SC)    ") ;
        CplSts_UR  : return ("(UR)    ") ;
        CplSts_CRS : return ("(CRS)   ") ;
        CplSts_CA  : return ("(CA)    ") ;
        default    : return ("(Unk)   ") ;
      endcase // case (tlp.dw1.cpl_field.tlp_status)
   endfunction : tlp_completion_status_str

   function string tlp_header_str(altpcietb_tlp_struct tlp) ;
      string dw0, dw1, dw2, dw3 ;
      dw0 = $sformatf("%08x",tlp.dw0.dw) ;
      dw1 = $sformatf("%08x",tlp.dw1.dw) ;
      if (tlp_is_request(tlp))
        begin
           // Always align addresses to the right most DW display
           // Might need to handle some messages differently here
           if (tlp_has_4dw_header(tlp))
             begin
                dw2 = $sformatf("%08x",tlp.dw23.tlp_addr[63:32]) ;
             end
           else
             begin
                dw2 = "        " ;
             end
           dw3 = $sformatf("%08x",tlp.dw23.tlp_addr[31:0]) ;
        end
      else
        begin
           dw2 = $sformatf("%08x",tlp.dw23.tlp_addr[31:0]) ;
           if (tlp_is_completion(tlp))
             begin
                // Use DW3 space to display completion status
                dw3 = $sformatf("%8s",tlp_completion_status_str(tlp)) ;
             end
           else
             begin
                dw3 = "        " ;
             end
        end // else: !if(tlp_is_request(tlp))
      return({dw0," ",dw1," ",dw2," ",dw3});
   endfunction : tlp_header_str

   function string tlp_data_str(altpcietb_tlp_struct tlp,int startdw);
      string dw0, dw1, dw2, dw3 ;
      if ( (tlp_has_data(tlp)) && (tlp.dw0.field.tlp_length_dw >= (startdw + 1)) )
        begin
           dw0 = $sformatf("%08x",tlp.data[startdw+0]);
           if (tlp.dw0.field.tlp_length_dw >= (startdw + 2))
             begin
                dw1 = $sformatf("%08x",tlp.data[startdw+1]);
                if (tlp.dw0.field.tlp_length_dw >= (startdw + 3))
                  begin
                     dw2 = $sformatf("%08x",tlp.data[startdw+2]);
                     if (tlp.dw0.field.tlp_length_dw >= (startdw + 4))
                       begin
                          dw3 = $sformatf("%08x",tlp.data[startdw+3]);
                       end
                     else
                       begin
                          dw3 = "        " ;
                       end
                  end // if (tlp.dw0.field.tlp_length_dw >= (startdw + 3))
                else
                  begin
                     dw2 = "        " ;
                     dw3 = "        " ;
                  end // else: !if(tlp.dw0.field.tlp_length_dw >= (startdw + 3))
             end // if (tlp.dw0.field.tlp_length_dw >= (startdw + 2))
           else
             begin
                dw1 = "        " ;
                dw2 = "        " ;
                dw3 = "        " ;
             end // else: !if(tlp.dw0.field.tlp_length_dw >= (startdw + 2))
        end // if (tlp.dw0.field.tlp_length_dw >= (startdw + 1))
      else
        begin
           dw0 = "        " ;
           dw1 = "        " ;
           dw2 = "        " ;
           dw3 = "        " ;
        end // else: !if(tlp.dw0.field.tlp_length_dw >= (startdw + 1))
      return({dw0," ",dw1," ",dw2," ",dw3});
   endfunction : tlp_data_str

   function void dump_tlp(integer fh,string dir,altpcietb_tlp_struct tlp) ;
      $fdisplay(fh,"| %11d %2s%1x| %6s %4s | %4d | %35s | %35s |",
                ($time/1000),
                dir,
                tlp.start_dw,
                tlp_menomic(tlp),
                tlp_tag_str(tlp),
                tlp.dw0.field.tlp_length_dw*4,
                tlp_header_str(tlp),
                tlp_data_str(tlp,0)) ;
      if (tlp_has_data(tlp))
        begin
           for (int i = 4 ; i < tlp.dw0.field.tlp_length_dw ; i = i + 4)
             begin
                $fdisplay(fh,"|                |             |      |                                     | %35s |",
                          tlp_data_str(tlp,i)) ;
             end
        end
   endfunction : dump_tlp

   function integer open_tlp_file(string fn = "altpcietb_rp_bfm_tlp.log",bit full_data_disp = 1'b0 ) ;
      int fh ;
      fh = $fopen(fn,"w") ;
      if (fh)
        begin
           $fdisplay(fh,"%s","+----------------+-------------+------+-------------------------------------+-------------------------------------+");
           $fdisplay(fh,"%s","|       Time     |   TLP Type  | Leng |             TLP Header              |              TLP Data               |");

           $fdisplay(fh,"%s","|       (ns)     |      (tag)  | (B)  |             (completion status)     |                                     |");
           $fdisplay(fh,"%s","+----------------+-------------+------+-------------------------------------+-------------------------------------+");
        end
      return(fh);
   endfunction : open_tlp_file

   function void close_tlp_file(integer fh) ;
      $fclose(fh) ;
   endfunction : close_tlp_file

   function string space_to_underscore(string space) ;
      automatic string uscore = space ;

      foreach (uscore[i])
        begin
           if (uscore[i] == " ")
             uscore[i] = "_" ;
        end
      return uscore ;
   endfunction : space_to_underscore


   /*
class tlp_log ;
   integer                tlplog_file = 0;
   bit                    full_data_disp = 1'b0 ;

   function new (string fn = "altpcietb_rp_bfm_tlp.log",bit full_data_disp = 1'b0 ) ;
      tlplog_file = $fopen(fn,"w") ;
      if (!tlplog_file) void'(ebfm_display(EBFM_MSG_ERROR_FATAL,"Could not open tlplog file"));
      this.full_data_disp = full_data_disp ;
   endfunction : new

   function void close ;
      $fclose(tlplog_file);
      tlplog_file = 0 ;
   endfunction : close

   function void fdisplay(string str)
     if (tlplog_file)
       $fdisplay(tlplog_file,str) ;
   endfunction fdisplay ;

   function void disp_all_data ;
      return(full_data_disp);
   endfunction : disp_all_data ;

class pcie_tlp ;
   altpcietb_tlp_struct : tlp ;

   function void fdisplay ;
      string              str ;
      str = $swrite("") ;

endclass : pcie_tlp
    */

endpackage : altpcietb_bfm_vc_intf_param_pkg


