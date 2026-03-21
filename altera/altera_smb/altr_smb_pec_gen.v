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


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module altr_smb_pec_gen (
		input  wire			clk,
		input  wire			rst_n,
		input  wire	[7:0]	data_in,
		input  wire			update_crc,
		input  wire			verify_crc,
		input  wire			flush_crc,
		input  wire [7:0]	crc_code_in,
		output wire [7:0]	crc_code_out,
		output wire			pec_mismatch
);
  
  wire	[7:0] 	crc_code_gen;
  reg	[7:0] 	pec_reg;
  
  always @(posedge clk or negedge rst_n) begin
	  if (~rst_n) begin
		  pec_reg		<= {8{1'b0}};
	  end
	  else if (flush_crc) begin
		  pec_reg		<= {8{1'b0}};
	  end 
	  else begin
		  pec_reg		<= crc_code_gen;
	  end
  end
  
  assign crc_code_out = pec_reg;
  assign crc_code_gen = (update_crc) ? next_crc_code(data_in, pec_reg) : pec_reg;
  
  // polynomial: (0 1 2 8)
  // data width: 8
  // convention: the first serial bit is D[7]
  
  function [7:0] next_crc_code;

    input [7:0] Data;
    input [7:0] crc;
    reg [7:0] d;
    reg [7:0] c;
    reg [7:0] newcrc;
  begin
    d = Data;
    c = crc;

    newcrc[0] = d[7] ^ d[6] ^ d[0] ^ c[0] ^ c[6] ^ c[7];
    newcrc[1] = d[6] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[6];
    newcrc[2] = d[6] ^ d[2] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[2] ^ c[6];
    newcrc[3] = d[7] ^ d[3] ^ d[2] ^ d[1] ^ c[1] ^ c[2] ^ c[3] ^ c[7];
    newcrc[4] = d[4] ^ d[3] ^ d[2] ^ c[2] ^ c[3] ^ c[4];
    newcrc[5] = d[5] ^ d[4] ^ d[3] ^ c[3] ^ c[4] ^ c[5];
    newcrc[6] = d[6] ^ d[5] ^ d[4] ^ c[4] ^ c[5] ^ c[6];
    newcrc[7] = d[7] ^ d[6] ^ d[5] ^ c[5] ^ c[6] ^ c[7];
    next_crc_code = newcrc;
  end
  endfunction
  
  // PEC verification code
  assign pec_mismatch = (verify_crc) ? (pec_reg != 0) : 1'b0;
  
endmodule
