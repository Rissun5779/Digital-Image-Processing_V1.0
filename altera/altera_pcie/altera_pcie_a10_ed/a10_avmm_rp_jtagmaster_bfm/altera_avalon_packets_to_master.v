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


// --------------------------------------------------------------------------------
//| Avalon ST Packets to MM Master Transaction Component
//
// --------------------------------------------------------------------------------
//
`timescale 1ns / 100ps
//
// --------------------------------------------------------------------------------
//| Fast Transaction Master
//
// --------------------------------------------------------------------------------
//
module altera_avalon_packets_to_master (
    // Interface: clk
      input wire             clk,
      input wire             reset_n,
      // Interface: ST in
      output wire         in_ready,
      input  wire         in_valid,
      input  wire [ 7: 0] in_data,
      input  wire         in_startofpacket,
      input  wire         in_endofpacket,

      // Interface: ST out 
      input  wire         out_ready,
      output wire         out_valid,
      output wire [ 7: 0] out_data,
      output wire         out_startofpacket,
      output wire         out_endofpacket,

      // Interface: MM out
      output wire [31: 0] address,
      input  wire [31: 0] readdata,
      output wire         read,
      output wire         write,
      output wire [ 3: 0] byteenable,
      output wire [31: 0] writedata,
      input  wire         waitrequest,
      input  wire         readdatavalid
);

        pcie_example_design_master_0 master_0 (
                .clk_clk              (clk),           //   input,   width = 1,          clk.clk
                .clk_reset_reset      (~reset_n),      //   input,   width = 1,    clk_reset.reset
                .master_address       (address),       //  output,  width = 32,       master.address
                .master_readdata      (readdata),      //   input,  width = 32,             .readdata
                .master_read          (read),          //  output,   width = 1,             .read
                .master_write         (write),         //  output,   width = 1,             .write
                .master_writedata     (writedata),     //  output,  width = 32,             .writedata
                .master_waitrequest   (waitrequest),   //   input,   width = 1,             .waitrequest
                .master_readdatavalid (readdatavalid), //   input,   width = 1,             .readdatavalid
                .master_byteenable    (byteenable),    //  output,   width = 4,             .byteenable
                .master_reset_reset   ()               //  output,   width = 1, master_reset.reset
        );

endmodule
