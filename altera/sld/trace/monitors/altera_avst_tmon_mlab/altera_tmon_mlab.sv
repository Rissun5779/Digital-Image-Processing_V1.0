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


// This is a version of a performance monitor that uses an MLAB
// to reduce the number of logic bits needed to implement the registers.
// This demo version has 8 registers, 4 that increment, 4 that add.
//
//
//
module altera_tmon_mlab #(
   parameter
   BC_W            = 5   
   ) (
   //the avalon data interface
   input             avs_clock,
   input             avs_reset,
   input             avs_read,
   input       [2:0] avs_address,
   output reg        avs_waitrequest,
   output reg [31:0] avs_readdata,

   //the avalon config interface (read only)
   input       [2:0] ctl_address,
   output     [31:0] ctl_readdata,

   //the monitor interface
   input             if_clock,
   input             if_reset,
   input             if_read,
   input             if_write,
   input  [BC_W-1:0] if_burstcount,
   input             if_waitrequest,
   input             if_readdatavalid
   );

localparam   MANUFACTURER_ID = 16'h03,
             REVISION_NUM    = 16'h01;

assign ctl_readdata = {MANUFACTURER_ID, REVISION_NUM};

wire  [3:0] inc, add;
wire        togl_to_accum;
wire        togl_return;
wire  [2:0] count_sel;
wire [31:0] countdata;

altera_count_processor #(
   .BC_W       (5)
   ) count (
   .if_clock         (if_clock),
   .if_reset         (if_reset),
   .if_read          (if_read),
   .if_write         (if_write),
   .if_burstcount    (if_burstcount),
   .if_waitrequest   (if_waitrequest),
   .if_readdatavalid (if_readdatavalid),
   .inc_out          (inc),
   .add_out          (add) 
);

altera_avmm_togl avmm (
   .avs_clock       (avs_clock),
   .avs_reset       (avs_reset),
   .avs_read        (avs_read),
   .avs_address     (avs_address),
   .avs_waitrequest (avs_waitrequest),
   .avs_readdata    (avs_readdata),
   .toglout         (togl_to_accum),
   .address         (count_sel),
   .toglin          (togl_return),
   .count_data      (countdata)
   );
altera_mlab_accumulator accum (
   .clk         (if_clock),
   .reset       (if_reset),
   .add         (add),
   .inc         (inc),
   .addend0     (8'h0),
   .addend1     (8'h0),
   .addend2     (8'h0),
   .addend3     (8'h0),
   .as_rdreq_t  (togl_to_accum),
   .rdack_t     (togl_return),
   .as_raddr    (count_sel),
   .rdata       (countdata)
   );

endmodule
   

