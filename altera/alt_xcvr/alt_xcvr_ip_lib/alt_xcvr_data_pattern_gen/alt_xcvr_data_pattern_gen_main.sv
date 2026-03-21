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
// Filename    : alt_xcvr_data_pattern_gen_main.sv
//
// Description : The main module of Data Pattern Generator. For further 
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

module alt_xcvr_data_pattern_gen_main #(
  parameter DATA_WIDTH           = 16,                 //1-128   
  parameter CHANNELS             = 1,                  //1-96
  parameter NUM_MATCHES_FOR_LOCK = 16,                 //4-64
  parameter UNLOCK               = 0,                  //{0 1}
  parameter ERROR_WIDTH          = 8,                  //4-32
  parameter PATTERN_ADDR_WIDTH   = 4,                  //4-32
  
  parameter PRBS7                = 1,                  //{0 1}
  parameter PRBS9                = 1,                  //{0 1}
  parameter PRBS10               = 1,                  //{0 1}
  parameter PRBS15               = 1,                  //{0 1}
  parameter PRBS23               = 1,                  //{0 1}
  parameter PRBS31               = 1,                  //{0 1}
  parameter WALKING              = 1,                  //{0 1}
  parameter COUNTER              = 1,                  //{0 1}
  parameter INVERTED_PRBS        = 1,                  //{0 1}
  parameter EXTERNAL             = 1                   //{0 1}
  ) 
(
  input                            clk,
  input                            reset,
  input                       	  enable,
  input  [PATTERN_ADDR_WIDTH-1:0]  pattern,
  input 	[DATA_WIDTH-1:0]			  prbs_seed,
  input  [DATA_WIDTH-1:0]          ext_data_pattern,
  input                            insert_error,
  
  output [DATA_WIDTH-1:0]          data_out
);

//pattern regs
reg  [PATTERN_ADDR_WIDTH-1:0] pattern_reg;
reg  [PATTERN_ADDR_WIDTH-1:0] pattern_prev;		
reg  [DATA_WIDTH-1:0]			prbs_seed_reg;
reg  [DATA_WIDTH-1:0]         ext_data_pattern_reg;
reg                           insert_error_reg;	

							 
//wires for the pattern generators
wire [DATA_WIDTH-1:0]        prbs_invert;
wire [DATA_WIDTH-1:0]        dout;
wire [DATA_WIDTH-1:0]        reset_seed;
wire                         pattern_change;

//regs for the pattern generators
reg  [DATA_WIDTH-1:0]        prbs_next;
reg  [DATA_WIDTH-1:0]        prbs_next_reg;


reg  [DATA_WIDTH-1:0]        counter_next;
reg  [DATA_WIDTH-1:0]        walking_next;
reg  [DATA_WIDTH-1:0]        data_value;
wire [DATA_WIDTH-1:0]        data_value_inv;
wire [DATA_WIDTH-1:0]        data_value_next;



//Determine the reset values and the next data pattern.
//    walking_pattern resets to ext_data_pattern
//    counter reesets to 16'd0
//    prbs resets to prbs_seed

assign reset_seed      = (COUNTER  && (pattern_reg == 4'b1000))   ? {DATA_WIDTH{1'b0}}      : //COUNTER
                         (WALKING  && (pattern_reg == 4'b0111))   ? ext_data_pattern_reg    : //WALKING_PATTERN
								 (EXTERNAL && (pattern_reg == 4'b0000))   ? ext_data_pattern_reg    : //EXTERNAL_DATA_PATTERN
								                                            prbs_seed_reg           ; //PRBS
   
//Mux the next correct data pattern
assign data_value_next = (WALKING       && (pattern_reg == 4'b0111))   ? walking_next                       : //walking_pattern
                         (COUNTER       && (pattern_reg == 4'b1000))   ? counter_next                       : //counter
								 (EXTERNAL      && (pattern_reg == 4'b0000))   ? ext_data_pattern_reg               :  //ext_data_pattern
								 (INVERTED_PRBS && (pattern_reg[3] == 1'b1))   ? (~(prbs_next_reg[DATA_WIDTH-1:0])) : //inverted prbs
								                                                 (prbs_next_reg[DATA_WIDTH-1:0])    ; //prbs

//output the data
assign data_out        = data_value;
assign pattern_change  = pattern_reg != pattern_prev;
 

												
//On reset, reset the data_value to the reset value based upon the selected data patern
//When enable is high, allow the data pattern to progress, else recycle
always@(posedge clk or posedge reset) begin
  prbs_seed_reg          <= prbs_seed;
  if (reset == 1'b1) begin
    data_value             <= {DATA_WIDTH{1'b0}};
	 pattern_reg            <= 4'b1111;
    pattern_prev           <= 4'b0000;
 	 insert_error_reg       <= 1'b0;
	 ext_data_pattern_reg   <= {DATA_WIDTH{1'b0}};
	 prbs_next_reg          <= {DATA_WIDTH{1'b0}};
	 
	 
  end else if (pattern_change)  begin
	 data_value             <= reset_seed;
	 pattern_reg            <= pattern;
    pattern_prev           <= pattern;	 
	 insert_error_reg       <= insert_error;

	 ext_data_pattern_reg   <= ext_data_pattern;
	 prbs_next_reg          <= prbs_seed_reg;

  end else begin
    if(enable == 1'b1) begin
      data_value           <= {data_value_next[DATA_WIDTH-1:1], data_value_next[0] ^ insert_error_reg}; //insert the error
		pattern_reg          <= pattern;
      pattern_prev         <= pattern_reg;
		insert_error_reg     <= insert_error;
	   ext_data_pattern_reg <= ext_data_pattern;
		prbs_next_reg        <= prbs_next;

    end else begin
      data_value           <= data_value;
		pattern_reg          <= pattern_reg;
		pattern_prev         <= pattern_prev;
		insert_error_reg     <= insert_error_reg;
	   ext_data_pattern_reg <= ext_data_pattern_reg;
		prbs_next_reg        <= prbs_next_reg;
    end
  end
		
end		



//prbs7  = 1 + x^6 + x^7
//prbs9  = 1 + x^5 + x^9
//prbs10 = 1 + X^7 + X^10
//prbs15 = 1 + x^14 + x^15
//prbs23 = 1 + x^18 + x^23
//prbs31 = 1 + x^28 + x^31


//prbs poly module designed for generator module, it outputs the next expected value according to the input data.
alt_xcvr_data_pattern_prbs_poly #( 
  .DATA_WIDTH         (DATA_WIDTH),
  .PATTERN_ADDR_WIDTH (PATTERN_ADDR_WIDTH),
  .PRBS7              (PRBS7),
  .PRBS9              (PRBS9),
  .PRBS10             (PRBS10),
  .PRBS15             (PRBS15),
  .PRBS23             (PRBS23),
  .PRBS31             (PRBS31),
  .PRBS_TYPE          ("gen") 
 ) alt_xcvr_data_pattern_gen_prbs_poly
 (
  .clk                (clk),
  .reset              (reset),
  .pattern_change     (pattern_change),
  .is_locked          (1'b1),
  .prbs_seed          (prbs_seed_reg),
  .pattern            (pattern_reg),
 
  .prbs_out           (prbs_next)
 );


//COUNTER MODULE, counts from 0 to up to 2^DATA_WIDTH-1, then goes back to zero. 
generate
if (COUNTER) begin: generate_counter 
	//Increment the counter
	wire [DATA_WIDTH-1:0]        counter_curr;
	assign counter_curr = data_value;
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
	assign walking_curr = data_value;
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
