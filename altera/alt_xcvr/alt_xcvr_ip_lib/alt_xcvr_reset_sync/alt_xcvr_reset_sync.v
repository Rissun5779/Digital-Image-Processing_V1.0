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


//  Author: Jakob R. Jones
//
//  File Name: alt_xcvr_reset_sync.v
//
//  Description:  
//
//  A simple reset controller. The parameters specify the clock domain's
//  clock frequency and the desired reset period specified in nanoseconds.
//  The reset_req input signal is active high. The reset active high output
//  will remain asserted while reset_req is asserted and will not deassert
//  until the specified reset period has expired.
//  It is advisable to set the power up state of the count register to 0.
//
//  Revision History: 
//
//
//  Special notes:
//

module  alt_xcvr_reset_sync   #(  parameter   CLKS_PER_SEC    =25000000,
                    parameter   RESET_PER_NS    =1000000)   (
    input           clk,
    input           reset_req,  // asynchronous reset request
    output  wire    reset,      // synchronous reset out
    output  reg     reset_n     // synchronous reset_n out
);

localparam  MAX_CNT = CLKS_PER_SEC / (1000000000 / RESET_PER_NS);
localparam  CNT_WIDTH = clogb2(MAX_CNT);

reg [CNT_WIDTH - 1:0]   count = {CNT_WIDTH{1'b0}};
wire                    count_lim;
reg [1:0]               reset_req_r = {2'b00};
wire                    reset_n_int;


// Internal reset generation
// Asynchronous reset, Synchronous clear
assign  reset_n_int = reset_req_r[1];
always @(posedge clk or posedge reset_req)
  if(reset_req)       reset_req_r <= 2'b00;
  else                reset_req_r <= {reset_req_r[0],~reset_req};


// Reset counter
assign  count_lim = (count == MAX_CNT);
always @(posedge clk or negedge reset_n_int)
  if(!reset_n_int)    count   <= {CNT_WIDTH{1'b0}};
  else if(!count_lim) count   <= count + 1'b1;
    

// External reset generation
assign  reset = ~reset_n;
always @(posedge clk or negedge reset_n_int)
  if(!reset_n_int)    reset_n <= 1'b0;
  else                reset_n <= count_lim;


//constant log base 2 function for determining necessary counter size
function integer clogb2;
    input [31:0] depth;
    begin
        for(clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
    end
endfunction

endmodule
    
    
