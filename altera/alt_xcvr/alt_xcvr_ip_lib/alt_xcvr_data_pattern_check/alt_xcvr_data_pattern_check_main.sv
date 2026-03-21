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
// Filename    : alt_xcvr_data_pattern_check_main.sv
//
// Description : The main module of Data Pattern Checker. For further 
// information, please see the FD
//
// Supported Patterns - PRBS 7, 9, 10, 15, 23, 31, Inverted PRBS patterns
// 							walking_pattern, counter

// Supported Data widths = Up to 128 bits
//
// Authors     : Baturay Turkmen
// Date        : June, 20, 2015
//
//
// Copyright (c) Altera Corporation 1997-2013
// All rights reserved
//
//-------------------------------------------------------------------

module alt_xcvr_data_pattern_check_main #(
  parameter DATA_WIDTH           = 16,        //1-128
  parameter CHANNELS             = 1,         //1-96
  parameter NUM_MATCHES_FOR_LOCK = 16,        //4-64
  parameter UNLOCK               = 0,         //{0 1}
  parameter ERROR_WIDTH          = 8,         //4-32
  parameter PATTERN_ADDR_WIDTH   = 4,         //4-32
  
  parameter PRBS7                = 1,         //{0 1}
  parameter PRBS9                = 1,         //{0 1}
  parameter PRBS10               = 1,         //{0 1}
  parameter PRBS15               = 1,         //{0 1}
  parameter PRBS23               = 1,         //{0 1}
  parameter PRBS31               = 1,         //{0 1}
  parameter WALKING              = 1,         //{0 1}
  parameter COUNTER              = 1,         //{0 1}
  parameter INVERTED_PRBS        = 1,         //{0 1}
  parameter EXTERNAL             = 1          //{0 1}
) 
(
  input                           clk,
  input                           reset,
  input                           enable,
  input  [DATA_WIDTH-1:0]         ext_data_pattern,
  input  [PATTERN_ADDR_WIDTH-1:0] pattern,
  input  [DATA_WIDTH-1:0]         data_in,
  
  output                          error_flag,
  output                          is_data_locked,
  output [ERROR_WIDTH-1:0]        num_accumulated_error,
  output [ERROR_WIDTH-1:0]        num_dealignment
);


//STATES OF THE CHECKER
localparam LOCKED     = 1'b1;
localparam NOT_LOCKED = 1'b0;

//pattern regs
reg [PATTERN_ADDR_WIDTH-1:0] pattern_reg;	
reg [PATTERN_ADDR_WIDTH-1:0] pattern_prev;	
reg [DATA_WIDTH-1:0]         ext_data_pattern_reg;
reg [DATA_WIDTH-1:0]         data_in_reg;

//wires for the pattern generators
wire [DATA_WIDTH-1:0]   prbs_invert;
wire [DATA_WIDTH-1:0]   counter_curr;
wire [DATA_WIDTH-1:0]   walking_curr;
wire [DATA_WIDTH-1:0]   reset_seed;

//regs for the next expected pattern
reg  [DATA_WIDTH-1:0]   prbs_next;

reg  [DATA_WIDTH-1:0]   counter_next;
reg  [DATA_WIDTH-1:0]   walking_next;

reg  [DATA_WIDTH-1:0]   expected_data;
wire [DATA_WIDTH-1:0]   expected_data_next;
wire                    pattern_change;

//a counter for counting consecutive matches
reg  [7:0]              num_matches;
reg  [7:0]              num_unmatches;
reg                     state;
reg                     error;
reg  [ERROR_WIDTH-1:0]  num_accumulated_error_reg;
reg  [ERROR_WIDTH-1:0]  num_dealignment_reg;


//Check to see if the polynomial is PRBS
//TODO: in the future, the patterns could be expanded, in which case this check will have to be updated based upon the decode logic
wire prbs_poly_selected;
wire walking_selected;
wire disable_zero_pat;
assign walking_selected   = (pattern_reg == 4'b0111);
assign prbs_poly_selected = (|pattern_reg[2:0]) && (!(&pattern_reg[2:0]));
assign disable_zero_pat   = (walking_selected | prbs_poly_selected);


assign pattern_change = pattern_reg != pattern_prev;
assign is_data_locked = state;
assign error_flag     = error;

//Mux the next correct data pattern
assign expected_data_next = (WALKING       && (pattern_reg == 4'b0111))   ? walking_next                         : 
                            (COUNTER       && (pattern_reg == 4'b1000))   ? counter_next                         :
			    (EXTERNAL      && (pattern_reg == 4'b0000))   ? ext_data_pattern_reg                 :
			    (INVERTED_PRBS && (pattern_reg[3] == 1'b1))   ? (~(prbs_next[DATA_WIDTH-1:0]))       :
			    (prbs_next[DATA_WIDTH-1:0])          ;   
																	  
assign num_accumulated_error = num_accumulated_error_reg;
assign num_dealignment       = num_dealignment_reg;																	  
																	  
//When enable is low, recycle the valid counter, expected next pattern, and the error
always@(posedge clk or posedge reset) begin
  if(reset == 1'b1) begin
    num_matches               <= 8'b0;
	 num_unmatches             <= 8'b0;
    expected_data             <= {DATA_WIDTH{1'b0}};
    error                     <= 1'b0;
	 state                     <= NOT_LOCKED;
	 ext_data_pattern_reg      <= {DATA_WIDTH{1'b0}};
	 pattern_reg               <= 4'b1111;
	 pattern_prev              <= 4'b0000;
	 data_in_reg               <= {DATA_WIDTH{1'b0}};
	 num_accumulated_error_reg <= 8'b0;
	 num_dealignment_reg       <= 8'b0;
  end else if (pattern_change) begin
    num_matches               <= 8'b0;
	 num_unmatches             <= 8'b0;
    expected_data             <= expected_data_next;
    error                     <= 1'b0;
	 state                     <= NOT_LOCKED;
	 pattern_reg               <= pattern;
	 pattern_prev              <= pattern;
	 data_in_reg               <= data_in;
	 ext_data_pattern_reg      <= ext_data_pattern;
	 num_accumulated_error_reg <= 8'b0;
	 num_dealignment_reg       <= 8'b0; 
	 
  end else if(enable == 1'b0) begin
    num_matches               <= num_matches;
	 num_unmatches             <= num_unmatches;
    error                     <= error;
    expected_data             <= expected_data;
	 state                     <= state;
	 pattern_reg               <= pattern_reg;
	 pattern_prev              <= pattern_prev;
	 data_in_reg               <= data_in_reg;
	 ext_data_pattern_reg      <= ext_data_pattern_reg;
	 
  end else begin
    expected_data             <= expected_data_next;
	 pattern_reg               <= pattern;
	 pattern_prev              <= pattern_reg;
	 data_in_reg               <= data_in;
	 ext_data_pattern_reg      <= ext_data_pattern;

    //If we have predicted NUMBER_MATCHES_FOR_LOCK consecutive patterns, then assert errors when the data_in is different
    //than that expected result
    if(num_matches == NUM_MATCHES_FOR_LOCK) begin
		state         <= LOCKED;
      error         <= (expected_data != data_in_reg);
		if ((expected_data != data_in_reg) && !(&num_accumulated_error_reg)) begin
			num_accumulated_error_reg <= num_accumulated_error_reg + 1'b1;
		end

    //If valid is not high. ie. we have not predicted NUMBER_MATCHES_FOR_LOCK consecutive patterns, then if the predicted value
    //is the same as the data valud increment the valid counter.
    end else if(((expected_data == data_in_reg) && ((disable_zero_pat && data_in_reg != {DATA_WIDTH{1'b0}}) || (!disable_zero_pat))) && (state == NOT_LOCKED)) begin
      num_matches   <= num_matches + 1'b1;
		
	 end else begin
		num_matches   <= 8'b0;
	 end	
	 
	 //If the checker is in the locked state and the UNLOCK feature is on, and checker encounter NUMBER_MATCHES_FOR_LOCK consecutive
	 //errors, the checker goes back to not_locked state, and the number of dealignments is incremented by 1 
    if((num_unmatches == NUM_MATCHES_FOR_LOCK) && (state == LOCKED) && UNLOCK) begin
      num_matches   <= 8'b0;	
		num_unmatches <= 8'b0;	
		state         <= NOT_LOCKED;
		error         <= 1'b1;
		if (!(&num_dealignment_reg))
			num_dealignment_reg <= num_dealignment_reg +1'b1;
	
	 //If the checker is in the locked state and the UNLOCK feature is on, it counts the number of consecutive errors
    end else if((expected_data != data_in_reg) && (state == LOCKED)  && UNLOCK) begin
      num_unmatches <= num_unmatches + 1'b1;
		
    end else begin
		num_unmatches <= 8'b0;
    end
  end
end


//prbs7  = 1 + x^6 + x^7
//prbs9  = 1 + x^5 + x^9
//prbs10 = 1 + X^7 + X^10
//prbs15 = 1 + x^14 + x^15
//prbs23 = 1 + x^18 + x^23
//prbs31 = 1 + x^28 + x^31
wire [DATA_WIDTH-1:0] prbs_in;
assign prbs_in = (INVERTED_PRBS && pattern[3]) ? (~data_in) : data_in;


//prbs poly module designed for checker module, it outputs the next expected value according to the input data.
alt_xcvr_data_pattern_prbs_poly #( 
  .DATA_WIDTH         (DATA_WIDTH),
  .PATTERN_ADDR_WIDTH (PATTERN_ADDR_WIDTH),
  .PRBS7              (PRBS7),
  .PRBS9              (PRBS9),
  .PRBS10             (PRBS10),
  .PRBS15             (PRBS15),
  .PRBS23             (PRBS23),
  .PRBS31             (PRBS31),
  .PRBS_TYPE          ("check")  
 ) alt_xcvr_data_pattern_gen_prbs_poly
 (
  .clk                (clk),
  .reset              (reset),
  .pattern_change     (pattern_change),
  .prbs_seed          (prbs_in),
  .is_locked          (is_data_locked),
  .pattern            (pattern_reg),
 
  .prbs_out           (prbs_next)
 );
	
	
//COUNTER MODULE, counts from 0 to up to 2^DATA_WIDTH-1, then goes back to zero.
generate
if (COUNTER) begin: generate_counter 
	//Increment the counter
	wire [DATA_WIDTH-1:0]        counter_curr;
	assign counter_curr = (is_data_locked) ? expected_data[DATA_WIDTH-1:0] : data_in_reg[DATA_WIDTH-1:0];
	always@(*) begin 
		counter_next = counter_curr + 1'b1;
	end
end else begin: genere_no_counter
  always@(*) begin
      counter_next = {DATA_WIDTH{1'b0}}; 
  end			
end
endgenerate	


//WALKING PATTERN MODULE, walks the inputted pattern by shifting left by 1 every cycler
generate
if (WALKING) begin: generate_walking 
	//Shift the walking pattern
	wire [DATA_WIDTH-1:0]        walking_curr;
	assign  walking_curr = (is_data_locked) ? expected_data[DATA_WIDTH-1:0] : data_in_reg[DATA_WIDTH-1:0];
	always@(*) begin 
		walking_next[DATA_WIDTH-1:1] = walking_curr[DATA_WIDTH-2:0];
		walking_next[0]              = walking_curr[DATA_WIDTH-1];
	end
end else begin: genere_no_walking
  always@(*) begin
      walking_next = {DATA_WIDTH{1'b0}}; 
  end			
end
endgenerate	


endmodule
