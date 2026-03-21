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



//============================================================================
// This confidential and proprietary software may be used only as authorized
// by a licensing agreement from ALTERA 
// copyright notice must be reproduced on all authorized copies.
//============================================================================


//============================================================================
// synchronizer bundle - based on synchronizer -
// ip/altera/primitives/altera_std_synchronizer/altera_std_synchronizer_nocut.v
// provides WIDTH on option on top of what is provided by _synchronizer_nocut
// Uderlying resync does not set false path on resync input flop
//============================================================================
`timescale 1 ps / 1 ps
module alt_eth_resync_nocut (
         clk,
         reset,
         d,
         q
            );
   parameter WIDTH = 1;
   parameter SYNC_CHAIN_LENGTH= 3;  // This value must be >= 2 !  
   parameter INIT_VALUE= 0;   
   
   input clk;
   input reset;
   input [WIDTH-1:0] d;
   output [WIDTH-1:0] q;
   
   generate
      genvar i;
      for (i=0; i<WIDTH; i=i+1)
    begin : sync
       altera_std_synchronizer_nocut #(
                    .depth(SYNC_CHAIN_LENGTH),
                    .rst_value(INIT_VALUE)
                    )  synchronizer_nocut_inst  (
                    .clk(clk), 
                    .reset_n(~reset), 
                    .din (d[i]), 
                    .dout(q[i])
                );
    end
   endgenerate
   
endmodule 

