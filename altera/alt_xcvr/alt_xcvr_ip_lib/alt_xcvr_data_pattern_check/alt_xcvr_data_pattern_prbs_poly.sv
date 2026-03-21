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
// Filename    : alt_xcvr_data_pattern_prbs_poly.sv
//
// Description : The prbs polynomial module of Data Pattern Checker and Generator. For further 
// information, please see the FD
//
// Supported Patterns - PRBS 7, 9, 10, 15, 23, 31
// Supported Data widths = Up to 128 bits
//
// Authors     : Baturay Turkmen
// Date        : Jul, 115, 2015
//
//
// Copyright (c) Altera Corporation 1997-2013
// All rights reserved
//
//-------------------------------------------------------------------

module alt_xcvr_data_pattern_prbs_poly #( 
  parameter DATA_WIDTH         = 16,                       //1-128
  parameter PATTERN_ADDR_WIDTH = 4,                        //4-32
  parameter PRBS7              = 1,                        //{0 1}
  parameter PRBS9              = 1,                        //{0 1}
  parameter PRBS10             = 1,                        //{0 1}
  parameter PRBS15             = 1,                        //{0 1}
  parameter PRBS23             = 1,                        //{0 1}
  parameter PRBS31             = 1,                        //{0 1}
  parameter PRBS_TYPE          = "gen"                     //{"gen"  "check"}
 )
 (
  input                           clk,
  input                           reset,
  input                           is_locked,
  input  [DATA_WIDTH-1:0]         prbs_seed,        // for checker, this is data_in
  input                           pattern_change,  
  input  [PATTERN_ADDR_WIDTH-1:0] pattern,
  output [DATA_WIDTH-1:0]         prbs_out
 );

 reg [127:0]           prbs7_next, prbs9_next, prbs10_next, prbs15_next, prbs23_next, prbs31_next;
 reg [DATA_WIDTH-1:0]  prbs7_next_reg, prbs9_next_reg, prbs10_next_reg, prbs15_next_reg, prbs23_next_reg, prbs31_next_reg;


//mux to choose the correct prbs pattern to be outputted
 assign prbs_out =    (PRBS7  && pattern[2:0] == 3'b001)  ? prbs7_next_reg    :       //prbs7  or inverted prbs7
							 (PRBS9  && pattern[2:0] == 3'b010)  ? prbs9_next_reg    :       //prbs9  or inverted prbs9
							 (PRBS10 && pattern[2:0] == 3'b011)  ? prbs10_next_reg   :       //prbs10 or inverted prbs10 
							 (PRBS15 && pattern[2:0] == 3'b100)  ? prbs15_next_reg   :       //prbs15 or inverted prbs15
							 (PRBS23 && pattern[2:0] == 3'b101)  ? prbs23_next_reg   :       //prbs23 or inverted prbs23
							 (PRBS31 && pattern[2:0] == 3'b110)  ? prbs31_next_reg   :       //prbs31 or inverted prbs31
							                                       prbs7_next_reg    ;  
 
 always@(posedge clk or posedge reset) begin
   if(reset) begin
	  prbs7_next_reg       <= {DATA_WIDTH{1'b0}};
	  prbs9_next_reg       <= {DATA_WIDTH{1'b0}};
	  prbs10_next_reg      <= {DATA_WIDTH{1'b0}};
	  prbs15_next_reg      <= {DATA_WIDTH{1'b0}};
	  prbs23_next_reg      <= {DATA_WIDTH{1'b0}};
	  prbs31_next_reg      <= {DATA_WIDTH{1'b0}};
	end else if (pattern_change) begin
	  prbs7_next_reg       <= prbs_seed;
	  prbs9_next_reg       <= prbs_seed;
	  prbs10_next_reg      <= prbs_seed;
	  prbs15_next_reg      <= prbs_seed;
	  prbs23_next_reg      <= prbs_seed;
	  prbs31_next_reg      <= prbs_seed;
	end else begin
	  prbs7_next_reg       <= prbs7_next[DATA_WIDTH-1:0];
	  prbs9_next_reg       <= prbs9_next[DATA_WIDTH-1:0];
	  prbs10_next_reg      <= prbs10_next[DATA_WIDTH-1:0];
	  prbs15_next_reg      <= prbs15_next[DATA_WIDTH-1:0];
	  prbs23_next_reg      <= prbs23_next[DATA_WIDTH-1:0];
	  prbs31_next_reg      <= prbs31_next[DATA_WIDTH-1:0];
	end
 end
 
 
//------------------------------------------------------------------- 
//prbs7
//-------------------------------------------------------------------
generate
if (PRBS7) begin: generate_prbs7 
 localparam prbs7_width  = 6;
 localparam prbs7_poly   = 5;
 
 integer      i7;
 reg  [127:0] prbs7_curr;
 wire [127:0] prbs7_value;
 wire [6:0]   prbs7_dw;
 wire [DATA_WIDTH-1:0] prbs7_in;
 
 assign prbs7_in    =   ((PRBS_TYPE == "check") && (~is_locked)) ? prbs_seed : prbs7_next_reg;
 assign prbs7_dw    =   (prbs7_width[6:0] <= (DATA_WIDTH[6:0]-1'b1)) ? (DATA_WIDTH[6:0]-1'b1) : prbs7_width[6:0];
 assign prbs7_value =   (prbs7_width[6:0] <= (DATA_WIDTH[6:0]-1'b1)) ?  prbs7_in : (prbs7_in << (prbs7_width[6:0] - DATA_WIDTH[6:0] + 1'b1)) ;
 						 
 always@(*) begin 
  //reverse the bits
  for(i7=0; i7<=127; i7=i7+1) begin
	 if (i7 <= prbs7_width)
	   prbs7_curr[i7] = prbs7_value[prbs7_dw-i7];
	 else
	   prbs7_curr[i7] = 1'b0;
  end

  //Create the prbs sequence in parallel
  for(i7=0; i7<=127; i7=i7+1) begin
    if(i7<=prbs7_poly) begin
      prbs7_next[i7] = prbs7_curr[prbs7_poly-i7] ^ prbs7_curr[prbs7_width-i7];
    end else if(i7<=prbs7_width)  begin
      prbs7_next[i7] = prbs7_curr[prbs7_width-i7] ^ prbs7_next[i7-(prbs7_poly+1'b1)];
    end else if (i7<DATA_WIDTH)  begin
      prbs7_next[i7] = prbs7_next[i7-(prbs7_poly+1'b1)] ^ prbs7_next[i7-(prbs7_width+1'b1)];
    end else
		prbs7_next[i7] = 1'b0;
  end
 end
end else begin : generate_no_prbs7
  always@(*) begin
   prbs7_next = 128'b0;
  end
end 
endgenerate

//------------------------------------------------------------------- 
//prbs9
//-------------------------------------------------------------------

generate
if (PRBS9) begin: generate_prbs9 
 localparam prbs9_width  = 8;
 localparam prbs9_poly   = 4;
 
 integer i9;
 reg [127:0]  prbs9_curr;
 wire [127:0] prbs9_value;
 wire [6:0]   prbs9_dw;
 wire [DATA_WIDTH-1:0] prbs9_in;
 
 assign prbs9_in    =   ((PRBS_TYPE == "check") && (~is_locked)) ? prbs_seed : prbs9_next_reg;
 assign prbs9_dw  =     (prbs9_width[6:0] <= (DATA_WIDTH[6:0]-1'b1)) ? (DATA_WIDTH[6:0]-1'b1) : prbs9_width[6:0];
 assign prbs9_value =   (prbs9_width[6:0] <= (DATA_WIDTH[6:0]-1'b1)) ?  prbs9_in : (prbs9_in << (prbs9_width[6:0] - DATA_WIDTH[6:0] + 1'b1)) ;
 
 always@(*) begin 
  //reverse the bits
  for(i9=0; i9<=127; i9=i9+1) begin
	 if (i9 <= prbs9_width)
	   prbs9_curr[i9] = prbs9_value[prbs9_dw-i9];
	 else
	   prbs9_curr[i9] = 1'b0;
  end

  //Create the prbs sequence in parallel
  for(i9=0; i9<=127; i9=i9+1) begin
    if(i9<=prbs9_poly) begin
      prbs9_next[i9] = prbs9_curr[prbs9_poly-i9] ^ prbs9_curr[prbs9_width-i9];
    end else if(i9<=prbs9_width)  begin
      prbs9_next[i9] = prbs9_curr[prbs9_width-i9] ^ prbs9_next[i9-(prbs9_poly+1'b1)];
    end else if (i9<DATA_WIDTH)  begin
      prbs9_next[i9] = prbs9_next[i9-(prbs9_poly+1'b1)] ^ prbs9_next[i9-(prbs9_width+1'b1)];
    end else
		prbs9_next[i9] = 1'b0;
  end
 end
end else begin : generate_no_prbs9
  always@(*) begin
   prbs9_next = 128'b0;
  end
end 
endgenerate


//------------------------------------------------------------------- 
//prbs10
//-------------------------------------------------------------------
generate
if (PRBS10) begin: generate_prbs10 
 localparam prbs10_width = 9;
 localparam prbs10_poly  = 6;

 integer i10;
 reg  [127:0]  prbs10_curr; 
 wire [127:0] prbs10_value;
 wire [6:0]   prbs10_dw;
 wire [DATA_WIDTH-1:0] prbs10_in;
 
 assign prbs10_in    =   ((PRBS_TYPE == "check") && (~is_locked)) ? prbs_seed : prbs10_next_reg; 
 assign prbs10_dw  =     (prbs10_width[6:0] <= (DATA_WIDTH[6:0]-1'b1)) ? (DATA_WIDTH[6:0]-1'b1) : prbs10_width[6:0];
 assign prbs10_value =   (prbs10_width[6:0] <= (DATA_WIDTH[6:0]-1'b1)) ?  prbs10_in : (prbs10_in << (prbs10_width[6:0] - DATA_WIDTH[6:0] + 1'b1)) ;
  
 always@(*) begin 
  //reverse the bits
  for(i10=0; i10<=127; i10=i10+1) begin
	 if (i10 <= prbs10_width)
	   prbs10_curr[i10] = prbs10_value[prbs10_dw-i10];
	 else
	   prbs10_curr[i10] = 1'b0;
  end

  //Create the prbs sequence in parallel
  for(i10=0; i10<=127; i10=i10+1) begin
    if(i10<=prbs10_poly) begin
      prbs10_next[i10] = prbs10_curr[prbs10_poly-i10] ^ prbs10_curr[prbs10_width-i10];
    end else if(i10<=prbs10_width)  begin
      prbs10_next[i10] = prbs10_curr[prbs10_width-i10] ^ prbs10_next[i10-(prbs10_poly+1'b1)];
    end else if (i10<DATA_WIDTH)  begin
      prbs10_next[i10] = prbs10_next[i10-(prbs10_poly+1'b1)] ^ prbs10_next[i10-(prbs10_width+1'b1)];
    end else
		prbs10_next[i10] = 1'b0;
  end
 end
end else begin : generate_no_prbs10
  always@(*) begin
   prbs10_next = 128'b0;
  end
end 
endgenerate



//------------------------------------------------------------------- 
//prbs15
//-------------------------------------------------------------------
generate
if (PRBS15) begin: generate_prbs15 
 localparam prbs15_width = 14;
 localparam prbs15_poly  = 13;

 integer i15;
 reg [127:0]  prbs15_curr; 
 wire [127:0] prbs15_value;
 wire [6:0]   prbs15_dw;
 wire [DATA_WIDTH-1:0] prbs15_in;
 
 assign prbs15_in    =   ((PRBS_TYPE == "check") && (~is_locked)) ? prbs_seed : prbs15_next_reg; 
 assign prbs15_dw  =     (prbs15_width[6:0] <= (DATA_WIDTH[6:0]-1'b1)) ? (DATA_WIDTH[6:0]-1'b1) : prbs15_width[6:0];
 assign prbs15_value =   (prbs15_width[6:0] <= (DATA_WIDTH[6:0]-1'b1)) ?  prbs15_in : (prbs15_in << (prbs15_width[6:0] - DATA_WIDTH[6:0] + 1'b1)) ;
 
 always@(*) begin 
  //reverse the bits
  for(i15=0; i15<=127; i15=i15+1) begin
	 if (i15 <= prbs15_width)
	   prbs15_curr[i15] = prbs15_value[prbs15_dw-i15];
	 else
	   prbs15_curr[i15] = 1'b0;
  end

  //Create the prbs sequence in parallel
  for(i15=0; i15<=127; i15=i15+1) begin
    if(i15<=prbs15_poly) begin
      prbs15_next[i15] = prbs15_curr[prbs15_poly-i15] ^ prbs15_curr[prbs15_width-i15];
    end else if(i15<=prbs15_width)  begin
      prbs15_next[i15] = prbs15_curr[prbs15_width-i15] ^ prbs15_next[i15-(prbs15_poly+1'b1)];
    end else if (i15<DATA_WIDTH)  begin
      prbs15_next[i15] = prbs15_next[i15-(prbs15_poly+1'b1)] ^ prbs15_next[i15-(prbs15_width+1'b1)];
    end else
		prbs15_next[i15] = 1'b0;
  end
 end
end else begin : generate_no_prbs15
  always@(*) begin
   prbs15_next = 128'b0;
  end
end 
endgenerate


//------------------------------------------------------------------- 
//prbs23
//-------------------------------------------------------------------
generate
if (PRBS23) begin: generate_prbs23 
 localparam prbs23_width = 22;
 localparam prbs23_poly  = 17;

 integer i23;
 reg [127:0]  prbs23_curr;  
 wire [127:0] prbs23_value;
 wire [6:0]   prbs23_dw;
 wire [DATA_WIDTH-1:0] prbs23_in;
 
 assign prbs23_in    =   ((PRBS_TYPE == "check") && (~is_locked)) ? prbs_seed : prbs23_next_reg;  
 assign prbs23_dw  =     (prbs23_width[6:0] <= (DATA_WIDTH[6:0]-1'b1)) ? (DATA_WIDTH[6:0]-1'b1) : prbs23_width[6:0];
 assign prbs23_value =   (prbs23_width[6:0] <= (DATA_WIDTH[6:0]-1'b1)) ?  prbs23_in : (prbs23_in << (prbs23_width[6:0] - DATA_WIDTH[6:0] + 1'b1)) ;
 
 always@(*) begin 
  //reverse the bits
  for(i23=0; i23<=127; i23=i23+1) begin
	 if (i23 <= prbs23_width)
	   prbs23_curr[i23] = prbs23_value[prbs23_dw-i23];
	 else
	   prbs23_curr[i23] = 1'b0;
  end

  //Create the prbs sequence in parallel
  for(i23=0; i23<=127; i23=i23+1) begin
    if(i23<=prbs23_poly) begin
      prbs23_next[i23] = prbs23_curr[prbs23_poly-i23] ^ prbs23_curr[prbs23_width-i23];
    end else if(i23<=prbs23_width)  begin
      prbs23_next[i23] = prbs23_curr[prbs23_width-i23] ^ prbs23_next[i23-(prbs23_poly+1'b1)];
    end else if (i23<DATA_WIDTH)  begin
      prbs23_next[i23] = prbs23_next[i23-(prbs23_poly+1'b1)] ^ prbs23_next[i23-(prbs23_width+1'b1)];
    end else
		prbs23_next[i23] = 1'b0;
  end
 end
end else begin : generate_no_prbs23
  always@(*) begin
   prbs23_next = 128'b0;
  end
end 
endgenerate


//------------------------------------------------------------------- 
//prbs31
//-------------------------------------------------------------------
generate
if (PRBS31) begin: generate_prbs31 
 localparam prbs31_width = 30;
 localparam prbs31_poly  = 27;
 
 integer i31;
 reg [127:0]  prbs31_curr;  
 wire [127:0] prbs31_value;
 wire [6:0]   prbs31_dw;
 wire [DATA_WIDTH-1:0] prbs31_in;
 
 assign prbs31_in    =   ((PRBS_TYPE == "check") && (~is_locked)) ? prbs_seed : prbs31_next_reg;  
 assign prbs31_dw  =     (prbs31_width[6:0] <= (DATA_WIDTH[6:0]-1'b1)) ? (DATA_WIDTH[6:0]-1'b1) : prbs31_width[6:0];
 assign prbs31_value =   (prbs31_width[6:0] <= (DATA_WIDTH[6:0]-1'b1)) ?  prbs31_in : (prbs31_in << (prbs31_width[6:0] - DATA_WIDTH[6:0] + 1'b1)) ;
  
 always@(*) begin 
  //reverse the bits
  for(i31=0; i31<=127; i31=i31+1) begin
	 if (i31 <= prbs31_width)
	   prbs31_curr[i31] = prbs31_value[prbs31_dw-i31];
	 else
	   prbs31_curr[i31] = 1'b0;
  end

  //Create the prbs sequence in parallel
  for(i31=0; i31<=127; i31=i31+1) begin
    if(i31<=prbs31_poly) begin
      prbs31_next[i31] = prbs31_curr[prbs31_poly-i31] ^ prbs31_curr[prbs31_width-i31];
    end else if(i31<=prbs31_width)  begin
      prbs31_next[i31] = prbs31_curr[prbs31_width-i31] ^ prbs31_next[i31-(prbs31_poly+1'b1)];
    end else if (i31<DATA_WIDTH)  begin
      prbs31_next[i31] = prbs31_next[i31-(prbs31_poly+1'b1)] ^ prbs31_next[i31-(prbs31_width+1'b1)];
    end else
		prbs31_next[i31] = 1'b0;
  end
 end
end else begin : generate_no_prbs31
  always@(*) begin
   prbs31_next = 128'b0;
  end
end 
endgenerate

endmodule
 
