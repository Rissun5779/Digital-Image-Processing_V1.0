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


// (C) 2001-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.

//-------------------------------------------------------------------
// Filename    : alt_xcvr_data_pattern_gen_top.sv
//
// Description : The top module of Data Pattern Generator. For further 
// information, please see the FD
//
// Supported Patterns - PRBS 7, 9, 10, 15, 23, 31, Inverted PRBS patterns
// 							walking_pattern, counter

// Supported Data widths = Up to 128 bits
//
// Authors     : Baturay Turkmen
// Date        : June, 19, 2015
//
//
// Copyright (c) Altera Corporation 1997-2013
// All rights reserved
//
//-------------------------------------------------------------------

module alt_xcvr_data_pattern_gen_top #(
  parameter DATA_WIDTH           = 16,                 //1-128   
  parameter CHANNELS             = 1,                  //1-96
  parameter NUM_MATCHES_FOR_LOCK = 16,                 //4-64
  parameter UNLOCK               = 0,                  //{0 1}
  parameter ERROR_WIDTH          = 8,                  //4-32
  parameter PATTERN_ADDR_WIDTH   = 4,                  //4-32
  parameter AVMM_EN              = 0,                  //{0 1}
  
  parameter PRBS7                = 1,                  //{0 1}
  parameter PRBS9                = 1,                  //{0 1}
  parameter PRBS10               = 1,                  //{0 1}
  parameter PRBS15               = 1,                  //{0 1}
  parameter PRBS23               = 1,                  //{0 1}
  parameter PRBS31               = 1,                  //{0 1}
  parameter WALKING              = 1,                  //{0 1}
  parameter COUNTER              = 1,                  //{0 1}
  parameter EXTERNAL             = 1,                  //{0 1}
  parameter INVERTED_PRBS        = 1,                  //{0 1}
  parameter PRBS_SEED_VAL        = 1,                  // upto 128 bits
  parameter IS_PRBS              = 1                   //{0 1}
 )
(
  input  [CHANNELS-1:0]                           clk,
  input  [CHANNELS-1:0]                           reset,
  input  [CHANNELS-1:0]                           enable,
  input  [(CHANNELS * PATTERN_ADDR_WIDTH)-1:0]    pattern,
  input  [(CHANNELS * DATA_WIDTH)-1:0]	           prbs_seed,
  input  [(CHANNELS * DATA_WIDTH)-1:0]            ext_data_pattern,
  input  [CHANNELS-1:0]                           insert_error,
  
  output [(CHANNELS * DATA_WIDTH)-1:0]            data_out,
  
  
  //avmm inputs
  
  input [CHANNELS-1:0]                            avmm_clk,
  input [CHANNELS-1:0]                            avmm_reset,
  input [(CHANNELS * PATTERN_ADDR_WIDTH)-1:0]     avmm_address,
  input [(CHANNELS * 32)-1:0]                     avmm_writedata,
  input [CHANNELS-1:0]                            avmm_write,
  input [CHANNELS-1:0]                            avmm_read,
  
  //avmm outputs
  
  output [(CHANNELS * 32)-1:0]                    avmm_readdata,
  output [CHANNELS-1:0]                           avmm_waitrequest
  
);

 wire [DATA_WIDTH-1:0]  data_out_w        [CHANNELS-1:0];
 wire [31:0]            avmm_readdata_w   [CHANNELS-1:0];
 
 wire [(CHANNELS * DATA_WIDTH)-1:0]	  prbs_seed_w;

 localparam  MAX_CONVERSION_SIZE_DATA_GEN = 128;
 localparam  MAX_STRING_CHARS_DATA_GEN  = 64;
 function automatic [MAX_CONVERSION_SIZE_DATA_GEN-1:0] hexstr_2_bin_data_gen;
   input [MAX_STRING_CHARS_DATA_GEN*8-1:0] instring;

   integer this_char;
   integer i;
   begin
     // Initialize accumulator
     hexstr_2_bin_data_gen = {MAX_CONVERSION_SIZE_DATA_GEN{1'b0}};
     for(i=MAX_STRING_CHARS_DATA_GEN-1;i>=0;i=i-1) begin
       this_char = instring[i*8+:8];
       // Add value of this digit
       if(this_char >= 48 && this_char <= 57)
         hexstr_2_bin_data_gen = (hexstr_2_bin_data_gen * 16) + (this_char - 48);
       if(this_char >= 65 && this_char <= 70)
         hexstr_2_bin_data_gen = (hexstr_2_bin_data_gen * 16) + (this_char - 65 + 10);       
       if(this_char >= 97 && this_char <= 102)
         hexstr_2_bin_data_gen = (hexstr_2_bin_data_gen * 16) + (this_char - 97 + 10);
     end
   end
 endfunction

generate
  if(EXTERNAL && IS_PRBS) begin
    assign prbs_seed_w = prbs_seed;
  end else begin
    // String to binary conversions
    localparam  [127:0] temp_lcl_prbs_seed        = hexstr_2_bin_data_gen(PRBS_SEED_VAL);
    localparam  [DATA_WIDTH-1:0]  lcl_prbs_seed   = temp_lcl_prbs_seed [DATA_WIDTH-1:0]; 
    assign prbs_seed_w = {(CHANNELS){lcl_prbs_seed}};
  end
endgenerate
//generates CHANNELS number of checker modules seperately, with unique independent inputs including clock and reset  
genvar i;
generate 
	for(i=0;i<CHANNELS;i=i+1) begin: patternGenerator
	  
		alt_xcvr_data_pattern_gen #(
			.DATA_WIDTH         (DATA_WIDTH),
			.PATTERN_ADDR_WIDTH (PATTERN_ADDR_WIDTH),
			.AVMM_EN(AVMM_EN),
			.PRBS7              (PRBS7),
			.PRBS9              (PRBS9),
			.PRBS10             (PRBS10),
			.PRBS15             (PRBS15),
			.PRBS23             (PRBS23),
			.PRBS31             (PRBS31),
			.COUNTER            (COUNTER),
			.WALKING            (WALKING),
			.INVERTED_PRBS      (INVERTED_PRBS),
			.EXTERNAL           (EXTERNAL)
		) alt_xcvr_data_pattern_gen_inst (
			.clk                (clk[i]),
			.reset              (reset[i]),
			.enable             (enable[i]),
			.pattern            (pattern[(PATTERN_ADDR_WIDTH * (i+1) - 1):(PATTERN_ADDR_WIDTH * i)]),
			.prbs_seed          (prbs_seed_w[(DATA_WIDTH * (i +1) - 1):(DATA_WIDTH * i)]),
			.ext_data_pattern   (ext_data_pattern[(DATA_WIDTH * i + DATA_WIDTH-1):(DATA_WIDTH * i)]),
			.insert_error       (insert_error[i]),
			
			.data_out           (data_out_w[i]),
			
			//avm inputs/outputs
			
			.avmm_clk           (avmm_clk[i]),
			.avmm_reset         (avmm_reset[i]),
			.avmm_address       (avmm_address[(PATTERN_ADDR_WIDTH*(i+1)-1):(PATTERN_ADDR_WIDTH*i)]),
			.avmm_writedata     (avmm_writedata[(32*(i+1)-1):(32*i)]),
			.avmm_write         (avmm_write[i]),
			.avmm_read          (avmm_read[i]),
			
			.avmm_readdata      (avmm_readdata_w[i]),
			.avmm_waitrequest   (avmm_waitrequest[i])
			
		); 

	assign data_out       [(DATA_WIDTH*(i+1)-1):(DATA_WIDTH*i)] = data_out_w[i];
	assign avmm_readdata  [(32*(i+1)-1):(32*i)]                 = avmm_readdata_w[i];

	end

endgenerate

endmodule
