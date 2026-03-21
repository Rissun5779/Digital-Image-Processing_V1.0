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


// top level file for example design

`timescale 1ns/1ps

module test_infra #(
   parameter NUM_LANES          = 12,
   parameter CNTR_BITS          =   20,   // regulate reset delay, 6 for sim, 20 for hardware
   parameter W_BUNDLE_TO_XCVR   = 70,
   parameter W_BUNDLE_FROM_XCVR = 46,
   parameter NUM_SIXPACKS       = 2,
   parameter USR_CLK_FREQ       = "300.0 MHz",
   parameter MM_CLK_FREQ        = "100.0 MHz",
   parameter USE_RECO_CTRL      = 0
)(
   input                  clk50,

   input                  usr_pb_reset_n,

   output                 mm_clk_alive,
   output                 mm_clk,
   output reg             reconfig_reset,
   output                 usr_clk,
   output                 usr_rst,

   output                 reconfig_done_d,
   output                 sys_pll_locked,
   input                  pll_srv_rst,
   input                  sys_pll_rst_en,
   input                  sys_pll_rst_req,

   output   [W_BUNDLE_TO_XCVR*(NUM_LANES+NUM_SIXPACKS)-1:0] reconfig_to_xcvr,
   input  [W_BUNDLE_FROM_XCVR*(NUM_LANES+NUM_SIXPACKS)-1:0] reconfig_from_xcvr,

   input  [31:0]          jtag_mm_address,
   input                  jtag_mm_write,
   input  [31:0]          jtag_mm_writedata,
   output reg             jtag_mm_waitrequest,
   input                  jtag_mm_read,
   output reg [31:0]      jtag_mm_readdata,
   output reg             jtag_mm_readdatavalid,

   output [15:0]          core_mm_address,
   output                 core_mm_write,
   output [31:0]          core_mm_writedata,
   output                 core_mm_read,
   input  [31:0]          core_mm_readdata,
   input                  core_mm_readdatavalid,

   output [15:0]          test_mm_address,
   output                 test_mm_write,
   output [31:0]          test_mm_writedata,
   output                 test_mm_read,
   input  [31:0]          test_mm_readdata,
   input                  test_mm_readdatavalid
);
   wire                   ilk_core_reset_srv;
   reg                    reconfig_busy_r1;
   reg                    reconfig_done;

   wire                   reconfig_busy;
   wire                   clk_sys_ready;

   reg                    sys_pll_rst;
   reg  [5:0]             pll_rst_cnt = 6'b0;

   wire [6:0]             rcfg_mm_address;
   wire                   rcfg_mm_read;
   wire [31:0]            rcfg_mm_readdata;
   wire                   rcfg_mm_readdatavalid;
   reg                    rcfg_mm_readdatavalid_q;
   wire                   rcfg_mm_waitrequest;
   wire                   rcfg_mm_write;
   wire [31:0]            rcfg_mm_writedata;

   wire                   test_sel;
   wire                   core_sel;
   wire                   rcfg_sel;

   wire                   core_mm_readdatavalid_dly;
   wire                   test_mm_readdatavalid_dly;

   // *******************************************************************
   //                           Main Service PLL
   // *******************************************************************

   wire mm_clk_alive_locked;

   assign mm_clk_alive = clk50;
   assign mm_clk_alive_locked = usr_pb_reset_n;
 
   wire   mm_clk_alive_ready;

   ilk_reset_delay #(
      .CNTR_BITS (CNTR_BITS)
   ) rdy_srv (
      .clk       (mm_clk_alive),
      .ready_in  (mm_clk_alive_locked),
      .ready_out (mm_clk_alive_ready)
   );

     // System Reset
   always @(posedge mm_clk_alive or negedge mm_clk_alive_locked) begin
      if (!mm_clk_alive_locked) begin
         reconfig_reset <= 1'b1;
      end
      else if (!mm_clk_alive_ready) begin
         reconfig_reset <= 1'b1;
      end
      else begin
         reconfig_reset <= 1'b0;
      end
   end

   assign reconfig_done_d       = clk_sys_ready;
   assign ilk_core_reset_srv    = (sys_pll_locked && !clk_sys_ready);
   assign rcfg_mm_waitrequest   = 1'b0;
   assign rcfg_mm_readdata      = 32'h0;
   assign rcfg_mm_readdatavalid = 1'b0;
   assign reconfig_to_xcvr      = {(W_BUNDLE_TO_XCVR*(NUM_LANES+NUM_SIXPACKS)){1'b0}};


   always @(posedge mm_clk_alive or negedge mm_clk_alive_locked) begin
      if (!mm_clk_alive_locked) begin
         rcfg_mm_readdatavalid_q      <= 1'b0;
      end else begin
         rcfg_mm_readdatavalid_q      <= rcfg_mm_readdatavalid;
      end
   end

   // *******************************************************************
   //                         System clock and reset
   // *******************************************************************

   // System clock PLL

   altera_pll #(
      .reference_clock_frequency ("50.0 MHz"),
      .operation_mode            ("direct"),
      .number_of_clocks          (2),

      .output_clock_frequency0   (MM_CLK_FREQ),
      .phase_shift0              ("0 ps"),
      .duty_cycle0               (50),

      .output_clock_frequency1   (USR_CLK_FREQ),
      .phase_shift1              ("0 ps"),
      .duty_cycle1               (50)
   ) sys_pll (
      .outclk   ({usr_clk, mm_clk}),
      .locked   (sys_pll_locked),
      .fboutclk (),
      .fbclk    (1'b0),
      .rst      (sys_pll_rst),
      .refclk   (clk50)
   );
 
   always @(posedge mm_clk_alive) begin
      if (sys_pll_rst_en == 1'b1) begin
         if (&pll_rst_cnt == 1'b1) begin
            sys_pll_rst <= 1'b0;
            if (sys_pll_rst_req == 1'b0) begin
               pll_rst_cnt <= 0;
            end
            else begin
               pll_rst_cnt <= pll_rst_cnt;
            end
         end
         else begin
            if (sys_pll_rst_req == 1'b1 || sys_pll_rst == 1'b1) begin
               sys_pll_rst <= 1'b1;
               pll_rst_cnt <= pll_rst_cnt + 1'b1;
            end
         end
      end
      else begin
         sys_pll_rst <= 1'b0;
         pll_rst_cnt <= 6'h0;
      end
   end

   // System Reset generator
   ilk_reset_delay #(
      .CNTR_BITS (CNTR_BITS)
   ) rdy_sys (
      .clk       (usr_clk),
      .ready_in  (sys_pll_locked),
      .ready_out (clk_sys_ready)
   );

   // Safely cross to ilk core clock domain
   ilk_status_sync #(.WIDTH (1)) ss_ilk_rst (.clk(usr_clk),.din(ilk_core_reset_srv),.dout(usr_rst));

   // *******************************************************************
   //                         Address decoding
   // *******************************************************************
   assign test_sel =  jtag_mm_address[15] && ~jtag_mm_address[14];
   assign core_sel = ~jtag_mm_address[15] &&  jtag_mm_address[14];
   assign rcfg_sel = ~jtag_mm_address[15] && ~jtag_mm_address[14];

   assign core_mm_address   = jtag_mm_address[17:2];
   assign core_mm_write     = core_sel & jtag_mm_write;
   assign core_mm_writedata = jtag_mm_writedata;
   assign core_mm_read      = core_sel & jtag_mm_read;

   assign test_mm_address   = jtag_mm_address[17:2];
   assign test_mm_write     = test_sel & jtag_mm_write;
   assign test_mm_writedata = jtag_mm_writedata;
   assign test_mm_read      = test_sel & jtag_mm_read;

   assign rcfg_mm_address   = jtag_mm_address[17:2];
   assign rcfg_mm_write     = rcfg_sel & jtag_mm_write;
   assign rcfg_mm_writedata = jtag_mm_writedata;
   assign rcfg_mm_read      = rcfg_sel & jtag_mm_read;

   ilk_status_sync #(.WIDTH (1)) ss_hw_test_vld (.clk (mm_clk_alive), .din (test_mm_readdatavalid), .dout (test_mm_readdatavalid_dly));
   ilk_status_sync #(.WIDTH (1)) ss_core_vld    (.clk (mm_clk_alive), .din (core_mm_readdatavalid), .dout (core_mm_readdatavalid_dly));

   always @(*) begin
      if (test_sel) begin
         jtag_mm_readdata      <= test_mm_readdata;
         jtag_mm_waitrequest   <= 1'b0;
         jtag_mm_readdatavalid <= test_mm_readdatavalid_dly;
      end
      else if (core_sel) begin
         jtag_mm_readdata      <= core_mm_readdata;
         jtag_mm_waitrequest   <= 1'b0;
         jtag_mm_readdatavalid <= core_mm_readdatavalid_dly;
      end
      else begin
         if (USE_RECO_CTRL) begin
            jtag_mm_readdata      <= rcfg_mm_readdata;
            jtag_mm_waitrequest   <= rcfg_mm_waitrequest;
            jtag_mm_readdatavalid <= rcfg_mm_readdatavalid_q;
         end
         else begin
            jtag_mm_readdata      <= 32'h0;
            jtag_mm_waitrequest   <= 1'b0;
            jtag_mm_readdatavalid <= 1'b0;
         end
      end
   end

endmodule
