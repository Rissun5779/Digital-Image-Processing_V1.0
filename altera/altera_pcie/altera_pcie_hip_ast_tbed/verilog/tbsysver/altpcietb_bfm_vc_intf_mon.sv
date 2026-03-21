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


module altpcietb_bfm_vc_intf_mon #
  (
   parameter AST_WIDTH = 256,
   parameter AST_SOP_WIDTH = 1,
   parameter AST_MTY_WIDTH = 2,
   parameter PACKED_MODE = 0,
   parameter DOWNSTREAM_FACING = 1, // Downstream_Facing = 1 means RP, Switch Downstrean
   parameter [72:1] INTERFACE_LABEL = "Generic   "
   )
   (
    input logic                       clk_in,
    input logic                       rstn,
    // Rx Avalon-ST interface
    input logic                       rx_st_valid,
    input logic [(AST_WIDTH-1):0]     rx_st_data,
    input logic [(AST_SOP_WIDTH-1):0] rx_st_sop,
    input logic [(AST_SOP_WIDTH-1):0] rx_st_eop,
    input logic [(AST_MTY_WIDTH-1):0] rx_st_empty,
    // Tx Avalon-ST Interface
    input logic                       tx_st_valid,
    input logic [(AST_WIDTH-1):0]     tx_st_data,
    input logic [(AST_SOP_WIDTH-1):0] tx_st_sop,
    input logic [(AST_SOP_WIDTH-1):0] tx_st_eop,
    input logic [(AST_MTY_WIDTH-1):0] tx_st_empty,
    // Rx TLP's for Snooping by others
    output                            altpcietb_bfm_vc_intf_param_pkg::altpcietb_tlp_struct rx_tlp_snoop ,
    output bit                        rx_tlp_valid_snoop ,
    output bit                        rx_tlp_ack_snoop ,
    // Tx TLP's for Snooping by others
    output                            altpcietb_bfm_vc_intf_param_pkg::altpcietb_tlp_struct tx_tlp_snoop ,
    output bit                        tx_tlp_valid_snoop ,
    output bit                        tx_tlp_ack_snoop
    );

   import altpcietb_bfm_vc_intf_param_pkg::* ;

   // TLP passing signals between interface monitors and loggers
   altpcietb_tlp_struct rx_tlp ;
   bit    rx_tlp_valid ;
   bit    rx_tlp_ack ;
   altpcietb_tlp_struct tx_tlp ;
   bit    tx_tlp_valid ;
   bit    tx_tlp_ack ;

   // Some mnemoics
   string tx_dir = DOWNSTREAM_FACING ? "Dn" : "Up" ;
   string rx_dir = DOWNSTREAM_FACING ? "Up" : "Dn" ;

   // Default PlusArg Values
   const string pa_name_plus_arg_help_disable = "Altera_PCIe_BFM_Plus_Arg_Help_Disable" ;
   const string pa_name_tlp_log_enable = "Altera_PCIe_BFM_TLP_Log_Enable" ;
   const string pa_name_tlp_log_fn = "Altera_PCIe_BFM_TLP_Log_Filename" ;
   const bit    default_tlp_log_enable = 0 ;
   const string default_tlp_log_fn = {"altpcietb_bfm_vc_intf_mon_",
                                      space_to_underscore(string'(INTERFACE_LABEL)),"_tlp.log"};

   // Resolved PluArg Values
   bit          tlp_log_enable = default_tlp_log_enable ;
   string       tlp_log_fn = default_tlp_log_fn ;

   // TLP Log File Handle
   int          tlp_log_fh;

   // Display Help for all of the plus args
   function void display_plus_arg_help ;
      begin
         if (!$test$plusargs(pa_name_plus_arg_help_disable))
           begin
              $display("Altera PCIe BFM Internal Monitor Simulator Plus Arg options") ;
              $display("-----------------------------------------------------------") ;
              $display("PlusArg Name: %s=0|1",pa_name_tlp_log_enable);
              $display("           0: Disables logging of individual TLPs.");
              $display("           1: Enables logging of individual TLPs to specified file.");
              $display("     Default: %b",default_tlp_log_enable);
              $display("     Current: %b",tlp_log_enable);
              $display("");
              $display("PlusArg Name: %s=<filename>",pa_name_tlp_log_fn);
              $display("  <filename>: Any valid system filename for the TLP Log file.");
              $display("     Default: %s",default_tlp_log_fn);
              $display("     Current: %s",tlp_log_fn);
              $display("");
              $display("PlusArg Name: %s",pa_name_plus_arg_help_disable);
              $display("            : Specifying this Plus Arg disables display of this Plus Arg help text.");
              $display("");
           end
      end
   endfunction : display_plus_arg_help


   // Open and Close tlp log file
   initial
     begin
        void'($value$plusargs({pa_name_tlp_log_fn,"=%s"},tlp_log_fn)) ;
        void'($value$plusargs({pa_name_tlp_log_enable,"=%b"},tlp_log_enable)) ;
        if (tlp_log_enable)
          begin
             tlp_log_fh = open_tlp_file(tlp_log_fn) ;
             if (!tlp_log_fh) begin
                $display("Could not open tlp dump file for writing");
             end
          end
        // Wait till after all the other displays
        # 100ns display_plus_arg_help();
     end
   final
     if (tlp_log_fh) close_tlp_file(tlp_log_fh) ;

   // Assign the snoop outputs
   assign rx_tlp_snoop = rx_tlp ;
   assign rx_tlp_valid_snoop = rx_tlp_valid ;
   assign rx_tlp_ack_snoop = rx_tlp_ack ;
   assign tx_tlp_snoop = tx_tlp ;
   assign tx_tlp_valid_snoop = tx_tlp_valid ;
   assign tx_tlp_ack_snoop = tx_tlp_ack ;


   // Sub-module to Monitor the Rx Interface
   altpcietb_bfm_ast_monitor
     #(
       .AST_WIDTH(AST_WIDTH),
       .AST_SOP_WIDTH(AST_SOP_WIDTH),
       .AST_MTY_WIDTH(AST_MTY_WIDTH),
       .PACKED_MODE(PACKED_MODE),
       .INTERFACE_LABEL({INTERFACE_LABEL," Rx"})
       )
   i_rx_mon
     (
      .clk_in(clk_in),
      .rstn(rstn),
      // Rx Avalon-ST interface
      .st_valid(rx_st_valid),
      .st_data(rx_st_data),
      .st_sop(rx_st_sop),
      .st_eop(rx_st_eop),
      .st_empty(rx_st_empty),
      // Packet Interface
      .tlp(rx_tlp),
      .tlp_valid(rx_tlp_valid),
      .tlp_ack(rx_tlp_ack)
      ) ;

   // Sub-module to Monitor the Tx Interface
   altpcietb_bfm_ast_monitor
     #(
       .AST_WIDTH(256),
       .AST_SOP_WIDTH(2),
       .AST_MTY_WIDTH(2),
       .PACKED_MODE(0),
       .INTERFACE_LABEL({INTERFACE_LABEL," Rx"})
       )
   i_tx_mon
     (
      .clk_in(clk_in),
      .rstn(rstn),
      // Tx Avalon-ST interface
      .st_valid(tx_st_valid),
      .st_data(tx_st_data),
      .st_sop(tx_st_sop),
      .st_eop(tx_st_eop),
      .st_empty(tx_st_empty),
      // Packet Interface
      .tlp(tx_tlp),
      .tlp_valid(tx_tlp_valid),
      .tlp_ack(tx_tlp_ack)
      ) ;

   // Main Rx TLP Logging Loop
   always
     begin
        rx_tlp_ack <= 1'b0 ;
        wait (rx_tlp_valid == 1'b1) ;
        rx_tlp_ack <= 1'b1 ;
        if (tlp_log_fh) dump_tlp(tlp_log_fh,rx_dir,rx_tlp);
        wait (rx_tlp_valid == 1'b0) ;
     end

   // Main Tx TLP Logging Loop
   always
     begin
        tx_tlp_ack <= 1'b0 ;
        wait (tx_tlp_valid == 1'b1) ;
        tx_tlp_ack <= 1'b1 ;
        if (tlp_log_fh) dump_tlp(tlp_log_fh,tx_dir,tx_tlp);
        wait (tx_tlp_valid == 1'b0) ;
     end

endmodule : altpcietb_bfm_vc_intf_mon
