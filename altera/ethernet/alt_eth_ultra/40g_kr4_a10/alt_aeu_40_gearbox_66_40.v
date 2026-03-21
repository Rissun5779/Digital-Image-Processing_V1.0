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


// $Id: $
// $Revision: $
// $Date: $
// $Author: $
//-----------------------------------------------------------------------------

`timescale 1 ps / 1 ps
// altera message_off 10230

// 66 in 40 out 
// baeckler - 07-21-2010
// modified for A10 FEC ktaylor 04/2014

module alt_aeu_40_gearbox_66_40 (
	input clk,
	input sclr,			// fixes the state, not the data for min fanout
    input ena,
	input [65:0] din,     // lsbit first
	output reg din_rd_en, // reads from input
	output [39:0] dout
);

reg [5:0] gbstate = 0 /* synthesis preserve */;
reg [103:0] stor = 0 /* synthesis preserve */;
assign dout = stor[39:0];
reg [65:0] din_r = 0;

always @(posedge clk) if (ena) begin
	din_r <= din[65:0];
	
	gbstate <= (sclr | gbstate[5]) ? 6'h0 : (gbstate + 1'b1);
	   
	if (gbstate[5]) begin 
		stor <= {40'h0,stor[103:40]};    // holding 0	
	end    
	else begin	
		case (gbstate[4:0])
			5'h0 : begin stor[65:0] <= din[65:0];  end   // holding 26
			5'h1 : begin stor[91:26] <= din[65:0]; stor[25:0] <= stor[65:40];   end   // holding 52
			5'h2 : begin stor <= {40'h0,stor[103:40]};  end   // holding 12
			5'h3 : begin stor[77:12] <= din[65:0]; stor[11:0] <= stor[51:40];   end   // holding 38
			5'h4 : begin stor[103:38] <= din[65:0]; stor[37:0] <= stor[77:40];   end   // holding 64
			5'h5 : begin stor <= {40'h0,stor[103:40]};  end   // holding 24
			5'h6 : begin stor[89:24] <= din[65:0]; stor[23:0] <= stor[63:40];   end   // holding 50
			5'h7 : begin stor <= {40'h0,stor[103:40]};  end   // holding 10
			5'h8 : begin stor[75:10] <= din[65:0]; stor[9:0] <= stor[49:40];   end   // holding 36
			5'h9 : begin stor[101:36] <= din[65:0]; stor[35:0] <= stor[75:40];   end   // holding 62
			5'ha : begin stor <= {40'h0,stor[103:40]};  end   // holding 22
			5'hb : begin stor[87:22] <= din[65:0]; stor[21:0] <= stor[61:40];   end   // holding 48
			5'hc : begin stor <= {40'h0,stor[103:40]};  end   // holding 8
			5'hd : begin stor[73:8] <= din[65:0]; stor[7:0] <= stor[47:40];   end   // holding 34
			5'he : begin stor[99:34] <= din[65:0]; stor[33:0] <= stor[73:40];   end   // holding 60
			5'hf : begin stor <= {40'h0,stor[103:40]};  end   // holding 20
			5'h10 : begin stor[85:20] <= din[65:0]; stor[19:0] <= stor[59:40];   end   // holding 46
			5'h11 : begin stor <= {40'h0,stor[103:40]};  end   // holding 6
			5'h12 : begin stor[71:6] <= din[65:0]; stor[5:0] <= stor[45:40];   end   // holding 32
			5'h13 : begin stor[97:32] <= din[65:0]; stor[31:0] <= stor[71:40];   end   // holding 58
			5'h14 : begin stor <= {40'h0,stor[103:40]};  end   // holding 18
			5'h15 : begin stor[83:18] <= din[65:0]; stor[17:0] <= stor[57:40];   end   // holding 44
			5'h16 : begin stor <= {40'h0,stor[103:40]};  end   // holding 4
			5'h17 : begin stor[69:4] <= din[65:0]; stor[3:0] <= stor[43:40];   end   // holding 30
			5'h18 : begin stor[95:30] <= din[65:0]; stor[29:0] <= stor[69:40];   end   // holding 56
			5'h19 : begin stor <= {40'h0,stor[103:40]};  end   // holding 16
			5'h1a : begin stor[81:16] <= din[65:0]; stor[15:0] <= stor[55:40];   end   // holding 42
			5'h1b : begin stor <= {40'h0,stor[103:40]};  end   // holding 2
			5'h1c : begin stor[67:2] <= din[65:0]; stor[1:0] <= stor[41:40];   end   // holding 28
			5'h1d : begin stor[93:28] <= din[65:0]; stor[27:0] <= stor[67:40];   end   // holding 54
			5'h1e : begin stor <= {40'h0,stor[103:40]};  end   // holding 14
			5'h1f : begin stor[79:14] <= din[65:0]; stor[13:0] <= stor[53:40];   end   // holding 40
		endcase
	end
end

// this is the pattern as corresponding to the states
// wire [32:0] in_pattern = 33'b010110101101011010110101101011011;

// this is adjusted for latency
wire [32:0] in_pattern = 33'b101011010110101101011010110101101;

always @(posedge clk) if(ena|sclr) begin
	if (sclr) din_rd_en <= 1'b0;
	else din_rd_en <= (64'h0 | in_pattern) >> gbstate;
end

//wire [32:0] in_pattern2 = 33'b110101101011010110101101011010110;
//
//always @(posedge clk) begin
//	if (sclr) din_pre_ack <= 1'b0;
//	else din_pre_ack <= (64'h0 | in_pattern2) >> gbstate;
//end
//
//wire [32:0] in_pattern3 = 33'b011010110101101011010110101101011;
//
//always @(posedge clk) begin
//	if (sclr) din_pre2_ack <= 1'b0;
//	else din_pre2_ack <= (64'h0 | in_pattern3) >> gbstate;
//end


endmodule
