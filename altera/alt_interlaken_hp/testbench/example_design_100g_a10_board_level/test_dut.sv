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


`timescale 1 ns / 1 ps

module test_dut #(
  parameter W_BUNDLE_TO_XCVR   = 70,
  parameter W_BUNDLE_FROM_XCVR = 46,
  parameter NUM_SIXPACKS       = 2,
  parameter RX_PKTMOD_ONLY     = 1,
  parameter TX_PKTMOD_ONLY     = 1,
  parameter RXFIFO_ADDR_WIDTH  = 12,
  parameter CNTR_BITS          = 20,
  parameter NUM_LANES          = 12,
  parameter CALENDAR_PAGES     = 1,
  parameter LOG_CALENDAR_PAGES = 1,
  parameter INCLUDE_TEMP_SENSE = 1'b1,
  parameter BYPASS_LOOSEFIFO   = 0,
  parameter METALEN            = 64,
  parameter SCRAM_CONST        = 58'hdeadbeef123,
  parameter MM_CLK_KHZ         = 20'd100000,
  parameter MM_CLK_MHZ         = 28'd100000000,
  parameter INTERNAL_WORDS     = 8,
  parameter LOG_INTE_WORDS     = (INTERNAL_WORDS == 8) ? 4 : 3,
  parameter RT_BUFFER_SIZE     = 15000
)(
  input                                 tx_usr_clk,
  input                                 rx_usr_clk,
  input                                 reset_n,
  input                                 pll_ref_clk,
  input  [NUM_LANES-1:0]                rx_pin,
  output [NUM_LANES-1:0]                tx_pin,
  output [NUM_LANES-1:0]                sync_locked,
  output [NUM_LANES-1:0]                word_locked,
  output                                rx_lanes_aligned,
  output                                tx_lanes_aligned,

  input  [INTERNAL_WORDS-1:0][63:0]     itx_din_words,
  input  [LOG_INTE_WORDS-1:0]           itx_num_valid,
  input  [7:0]                          itx_chan,
  input                                 itx_sop,
  input  [3:0]                          itx_eopbits,
  input                                 itx_sob,
  input                                 itx_eob,
  input  [CALENDAR_PAGES*16-1:0]        itx_calendar,

  input  [3:0]                          burst_max_in,
  input  [3:0]                          burst_short_in,
  input  [3:0]                          burst_min_in,
  output                                itx_ready,
  output                                itx_hungry,
  output                                itx_overflow,
  output                                itx_underflow,
  output                                crc24_err,
  output [NUM_LANES-1:0]                crc32_err,
  output                                clk_tx_common,
  output                                srst_tx_common,
  output                                clk_rx_common,
  output                                srst_rx_common,
  output                                tx_mac_srst,
  output                                rx_mac_srst,
  output                                tx_usr_srst,
  output                                rx_usr_srst,

  output [7:0][63:0]                    irx_dout_words,
  output [3:0]                          irx_num_valid0,
  output [3:0]                          irx_num_valid1,
  output [1:0]                          irx_sop,
  output [1:0]                          irx_sob,
  output                                irx_eob,
  output [7:0]                          irx_chan,
  output [3:0]                          irx_eopbits,

  output [CALENDAR_PAGES*16-1:0]        irx_calendar,

  output                                irx_overflow,
  output                                rdc_overflow,
  output                                rg_overflow,
  output [RXFIFO_ADDR_WIDTH-1:0]        rxfifo_fill_level,

  output                                tx_fc_clk,
  output                                tx_fc_data,
  output                                tx_fc_sync,

  input                                 rx_fc_clk,
  input                                 rx_fc_data,
  input                                 rx_fc_sync,

  input                                 mm_clk,
  input                                 mm_read,
  input                                 mm_write,
  input  [15:0]                         mm_addr,
  output [31:0]                         mm_rdata,
  output                                mm_rdata_valid,
  input  [31:0]                         mm_wdata,


  output                                sop_cntr_inc,
  output                                eop_cntr_inc,

  input    [W_BUNDLE_TO_XCVR*(NUM_LANES+NUM_SIXPACKS)-1:0] reconfig_to_xcvr,
  output [W_BUNDLE_FROM_XCVR*(NUM_LANES+NUM_SIXPACKS)-1:0] reconfig_from_xcvr
);

  wire                                  rx_rt_req;
  wire                                  rx_rt_interrupt;
  wire   [1:0]                          rx_rt_int_cause;

  wire                                  rx_rt_event_on;
  wire   [3:0]                          oob_rx_cal;
  wire                                  oob_rx_valid;
  wire                                  oob_rx_cal_valid;

  wire                                  tx_rt_req = oob_rx_cal_valid & oob_rx_cal[0];
  wire                                  cal_load_ack; //Last cycle that value will be sent.

  wire                                  rx_force_crc24_err;
  wire                                  tx_force_crc24_err;
  wire                                  rx_rt_reset;

  reg   [2:0]                           rx_calendar_latch;
  reg                                   rx_rt_req_latch;
  reg                                   rx_rt_req_latch_r;

  wire [15:0]                           cfg_ignore_errtimer;
  wire [15:0]                           cfg_err_timeout;
  wire  [4:0]                           cfg_max_reterr;

  wire                                  tx_rt_enable;
  wire                                  rx_rt_enable;
  wire                                  rx_rt_maxout_option;

  wire        tx_pll_powerdown; //to atxpll 
  wire        pll_locked;       //to from atxpll 

  wire        atxpll_serial_clk;
  wire [NUM_LANES-1:0] tx_serial_clk;

  assign    tx_serial_clk = {NUM_LANES{atxpll_serial_clk}}; 
  
    ilk_top #(
       .CALENDAR_PAGES     (CALENDAR_PAGES),
       .LOG_CALENDAR_PAGES (LOG_CALENDAR_PAGES),
       .CNTR_BITS          (CNTR_BITS),
       .NUM_LANES          (NUM_LANES),
       .RX_PKTMOD_ONLY     (RX_PKTMOD_ONLY),
       .TX_PKTMOD_ONLY     (TX_PKTMOD_ONLY)
     ) dut (
    .tx_usr_clk          (tx_usr_clk),             //  input
    .rx_usr_clk          (rx_usr_clk),             //  input
    .reset_n             (reset_n),                //  input
    .pll_ref_clk         (pll_ref_clk),            //  input
    .rx_pin              (rx_pin),                 //  input  [NUM_LANES-1:0]
    .tx_pin              (tx_pin),                 //  output [NUM_LANES-1:0]
    .sync_locked         (sync_locked),            //  output [NUM_LANES-1:0]
    .word_locked         (word_locked),            //  output [NUM_LANES-1:0]
    .rx_lanes_aligned    (rx_lanes_aligned),       //  output
    .tx_lanes_aligned    (tx_lanes_aligned),       //  output

    .itx_din_words       (itx_din_words),          //  input  [64*INTERNAL_WORDS-1:0]
    .itx_num_valid       ({itx_num_valid, 4'b0}),   //  input  [3:0]
    .itx_chan            (itx_chan),               //  input  [7:0]
    .itx_sop             ({itx_sop,1'b0}),         //  input
    .itx_eopbits         (itx_eopbits),            //  input  [3:0]
    .itx_sob             ({itx_sob,1'b0}),                //  input
    .itx_eob             (itx_eob),                //  input
    .itx_calendar        (itx_calendar),           //  input  [CALENDAR_PAGES*16-1:0]

    .burst_max_in        (burst_max_in),           //  input  [3:0]
    .burst_short_in      (burst_short_in),         //  input  [3:0]
    .burst_min_in        (burst_min_in),           //  input  [3:0]
    .itx_ready           (itx_ready),              //  output
    .itx_hungry          (itx_hungry),             //  output
    .itx_overflow        (itx_overflow),           //  output
    .itx_underflow       (itx_underflow),          //  output
    .crc24_err           (crc24_err),              //  output
    .crc32_err           (crc32_err),              //  output [NUM_LANES-1:0]
    .clk_tx_common       (clk_tx_common),          //  output
    .srst_tx_common      (srst_tx_common),         //  output
    .clk_rx_common       (clk_rx_common),          //  output
    .srst_rx_common      (srst_rx_common),         //  output
    .tx_mac_srst         (tx_mac_srst),            //  output
    .rx_mac_srst         (rx_mac_srst),            //  output
    .tx_usr_srst         (tx_usr_srst),            //  output
    .rx_usr_srst         (rx_usr_srst),            //  output

    .irx_dout_words      (irx_dout_words),         //  output [64*INTERNAL_WORDS-1:0]
    .irx_num_valid       ({irx_num_valid0,irx_num_valid1}),         //  output [3:0]
    .irx_sop             (irx_sop),                //  output [1:0]
    .irx_sob             (irx_sob),                //  output [1:0]
    .irx_eob             (irx_eob),                //  output
    .irx_chan            (irx_chan),               //  output [7:0]
    .irx_eopbits         (irx_eopbits),            //  output [3:0]

    .irx_calendar        (irx_calendar),           //  output [CALENDAR_PAGES*16-1:0]
    .irx_overflow        (irx_overflow),           //  output
    .rdc_overflow        (rdc_overflow),           //  output
    .rg_overflow         (rg_overflow),            //  output
    .rxfifo_fill_level   (rxfifo_fill_level),      //  output [RXFIFO_ADDR_WIDTH-1:0]

    .mm_clk              (mm_clk),                 //  input
    .mm_read             (mm_read),                //  input
    .mm_write            (mm_write),               //  input
    .mm_addr             (mm_addr),                //  input  [15:0]
    .mm_rdata            (mm_rdata),               //  output [31:0]
    .mm_rdata_valid      (mm_rdata_valid),         //  output
    .mm_wdata            (mm_wdata),               //  input  [31:0]

    .sop_cntr_inc        (sop_cntr_inc),           //  output
    .eop_cntr_inc        (eop_cntr_inc),           //  output
    .tx_pll_powerdown    (tx_pll_powerdown),
    .tx_pll_locked       (pll_locked),
    .tx_serial_clk       (tx_serial_clk),
    
    .reconfig_clk        (mm_clk), 
    .reconfig_reset      (!reset_n), 
    .reconfig_write      (1'b0), 
    .reconfig_read       (1'b0), 
    .reconfig_address    (14'b0), 
    .reconfig_writedata  ('b0) 
  );

   always @ (posedge rx_usr_clk or posedge rx_usr_srst)
       if (rx_usr_srst) begin
         rx_calendar_latch <= 11'h0;
         rx_rt_req_latch   <= 1'b0;
         rx_rt_req_latch_r <= 1'b0;
       end else begin
         rx_rt_req_latch_r <= rx_rt_req_latch;

         if (rx_rt_req & !rx_rt_req_latch) rx_rt_req_latch <= 1'b1;
         else if (rx_rt_req_latch & cal_load_ack) rx_rt_req_latch <= 1'b0;

         if (cal_load_ack)
           rx_calendar_latch <= rx_calendar_latch + 1'b1;
       end

  //alt_interlaken_hp_oob_flow_tx #(
  ilk_oob_flow_tx #(
    .CAL_BITS(4),  // must be at least 2 no more than 256
    .NUM_LANES(8)
  ) oob_tx (
    .double_fc_clk  (tx_usr_clk),
    .double_fc_arst (tx_usr_srst),

    .calendar       ({rx_calendar_latch,rx_rt_req_latch}),
    .lane_status    (),
    .link_status    (1'b0),
    .ena_status     (1'b0),

    .fc_clk         (tx_fc_clk),
    .fc_data        (tx_fc_data),
    .fc_sync        (tx_fc_sync)
  );

  ilk_oob_flow_rx #(
    .CAL_BITS  (4),
    .NUM_LANES (8)
  ) oob_rx (
    .sys_clk         (rx_usr_clk),
    .sys_arst        (rx_usr_srst),

    .fc_clk          (rx_fc_clk),
    .fc_data         (rx_fc_data),
    .fc_sync         (rx_fc_sync),

    .lane_status     (),
    .link_status     (),
    .calendar        (oob_rx_cal),

    .status_update   (oob_rx_valid),
    .status_error    (),
    .calendar_update (oob_rx_cal_valid),
    .calendar_error  ()
  );

//ATXPLL instance  xN non-bonding
  atxpll inst_atxpll (
   .pll_refclk0     (pll_ref_clk),     
   .pll_powerdown   (tx_pll_powerdown), 
   .mcgb_rst        (tx_pll_powerdown), 

   .pll_locked      (pll_locked),    
   .tx_serial_clk   (), 
   .mcgb_serial_clk (atxpll_serial_clk), 
   .pll_cal_busy    ()                 
  ); 


endmodule
