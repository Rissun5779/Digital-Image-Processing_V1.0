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




// synthesis translate_off
`timescale 1ns / 1ns
// synthesis translate_on
`default_nettype none


//-----------------------------------------------------------------------------
// CRC module for data[15:0] ,   crc[15:0]=1+x^2+x^15+x^16;
//-----------------------------------------------------------------------------

module autotest_crc(
  // Outputs
  crc_out,
  // Inputs
  reset, clk, d, crc_en, sclr
);
parameter PIXELS_PER_CLOCK = 1;
// Inputs and Outputs
input wire [16*PIXELS_PER_CLOCK-1: 0] d;
input wire clk;
input wire reset;
input wire  [PIXELS_PER_CLOCK-1:0] crc_en;
output wire [15: 0] crc_out;
input wire sclr;

function [15:0] f;
input [15:0] b, d;
      begin
        f[15] = b[ 0] ^ b[ 1] ^ b[ 2] ^ b[ 3] ^ b[ 4] ^ b[ 5] ^ b[ 6] ^ b[ 7] ^ b[ 8] ^ b[ 9] ^ b[10] ^ b[11] ^ b[12] ^ b[14] ^ b[15] ^ d[ 0] ^ d[ 1] ^ d[ 2] ^ d[ 3] ^ d[ 4] ^ d[ 5] ^ d[ 6] ^ d[ 7] ^ d[ 8] ^ d[ 9] ^ d[10] ^ d[11] ^ d[12] ^ d[14] ^ d[15];
        f[14] = b[12] ^ b[13] ^ d[12] ^ d[13];
        f[13] = b[11] ^ b[12] ^ d[11] ^ d[12];
        f[12] = b[10] ^ b[11] ^ d[10] ^ d[11];
        f[11] = b[ 9] ^ b[10] ^ d[ 9] ^ d[10];
        f[10] = b[ 8] ^ b[ 9] ^ d[ 8] ^ d[ 9];
        f[ 9] = b[ 7] ^ b[ 8] ^ d[ 7] ^ d[ 8];
        f[ 8] = b[ 6] ^ b[ 7] ^ d[ 6] ^ d[ 7];
        f[ 7] = b[ 5] ^ b[ 6] ^ d[ 5] ^ d[ 6];
        f[ 6] = b[ 4] ^ b[ 5] ^ d[ 4] ^ d[ 5];
        f[ 5] = b[ 3] ^ b[ 4] ^ d[ 3] ^ d[ 4];
        f[ 4] = b[ 2] ^ b[ 3] ^ d[ 2] ^ d[ 3];
        f[ 3] = b[ 1] ^ b[ 2] ^ b[15] ^ d[ 1] ^ d[ 2] ^ d[15];
        f[ 2] = b[ 0] ^ b[ 1] ^ b[14] ^ d[ 0] ^ d[ 1] ^ d[14];
        f[ 1] = b[ 1] ^ b[ 2] ^ b[ 3] ^ b[ 4] ^ b[ 5] ^ b[ 6] ^ b[ 7] ^ b[ 8] ^ b[ 9] ^ b[10] ^ b[11] ^ b[12] ^ b[13] ^ b[14] ^ d[ 1] ^ d[ 2] ^ d[ 3] ^ d[ 4] ^ d[ 5] ^ d[ 6] ^ d[ 7] ^ d[ 8] ^ d[ 9] ^ d[10] ^ d[11] ^ d[12] ^ d[13] ^ d[14];
        f[ 0] = b[ 0] ^ b[ 1] ^ b[ 2] ^ b[ 3] ^ b[ 4] ^ b[ 5] ^ b[ 6] ^ b[ 7] ^ b[ 8] ^ b[ 9] ^ b[10] ^ b[11] ^ b[12] ^ b[13] ^ b[15] ^d[ 0] ^ d[ 1] ^ d[ 2] ^ d[ 3] ^ d[ 4] ^ d[ 5] ^ d[ 6] ^ d[ 7] ^ d[ 8] ^ d[ 9] ^ d[10] ^ d[11] ^ d[12] ^ d[13] ^ d[15];
     end
endfunction

// Internal Signals
reg [ 15: 0] b;


// Internal Assignments
assign crc_out = b;
integer i;
// Define LFSR
always @(posedge clk or posedge reset)
  begin
    if (reset)
    begin
      b = 16'd0;
    end
    else
    if (sclr)
    begin
      b = 16'd0;
    end
	 else
    begin
      for(i=0;i<PIXELS_PER_CLOCK;i=i+1)
        b = (crc_en[i]) ? f(b, d[16*i +: 16]) : b;
   end
end
endmodule // crc
`default_nettype wire
