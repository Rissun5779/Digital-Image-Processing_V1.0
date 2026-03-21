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

module test_agent #(
   parameter NUM_LANES          = 12,
   parameter SIM_FAKE_JTAG      = 1'b0,   // emulate PC host a little bit
   parameter RXFIFO_ADDR_WIDTH  = 12,
   parameter INTERNAL_WORDS     =  8,
   parameter LOG_INTE_WORDS     = (INTERNAL_WORDS == 8) ? 4 : 3,
   parameter CALENDAR_PAGES     =  1,
   parameter TX_PKTMOD_ONLY     = 1,
   parameter USR_CLK_FREQ       = "300.0 MHz"
)(
   // clock & reset misc
   input                          usr_clk,
   input                          usr_rst_n,
   input                          reconfig_done_d,
   input                          sys_pll_locked,
   output reg                     pll_srv_rst,
   output reg                     sys_pll_rst_en,
   output reg                     sys_pll_rst_req,

   // Host interface
   input                          mm_clk,                  // always running system clock
   input                          mm_rst,
   input                   [15:0] mm_address,
   input                          mm_write,
   input                   [31:0] mm_writedata,
   input                          mm_read,
   output reg              [31:0] mm_readdata,
   output reg                     mm_readdatavalid,
   input          [NUM_LANES-1:0] sync_locked,
   input          [NUM_LANES-1:0] word_locked,
   input                          rx_lanes_aligned,
   input                          tx_lanes_aligned,

   output [64*INTERNAL_WORDS-1:0] itx_din_words,
   output    [LOG_INTE_WORDS-1:0] itx_num_valid,
   output                   [7:0] itx_chan,
   output                         itx_sop,
   output                   [3:0] itx_eopbits,
   output                         itx_sob,
   output                         itx_eob,
   output [CALENDAR_PAGES*16-1:0] itx_calendar,
   input                          itx_ready,
   input                          itx_hungry,
   input                          itx_overflow,
   input                          itx_underflow,
   input                          crc24_err,
   input          [NUM_LANES-1:0] crc32_err,
   input                          clk_tx_common,
   input                          srst_tx_common,
   input                          clk_rx_common,
   input                          srst_rx_common,
   input                          tx_mac_srst,
   input                          rx_mac_srst,
   input                          tx_usr_srst,
   input                          rx_usr_srst,

   input  [64*INTERNAL_WORDS-1:0] irx_dout_words,
   input     [LOG_INTE_WORDS-1:0] irx_num_valid0,
   input     [LOG_INTE_WORDS-1:0] irx_num_valid1, //useless
   input                    [1:0] irx_sop,
   input                    [1:0] irx_sob,
   input                          irx_eob,
   input                    [7:0] irx_chan,
   input                    [3:0] irx_eopbits,
   input  [CALENDAR_PAGES*16-1:0] irx_calendar,
   input                          irx_overflow,
   input                          rdc_overflow,
   input                          rg_overflow,
   input  [RXFIFO_ADDR_WIDTH-1:0] rxfifo_fill_level,

   input                          sop_cntr_inc,
   input                          eop_cntr_inc
);


   wire [NUM_LANES*8-1:0] crc32_err_cnt;
   wire            [15:0] crc24_err_cnt;


   wire                   send_data;
   wire            [31:0] sop_cntr;
   wire            [31:0] eop_cntr;
   wire            [31:0] err_cnt;
   wire             [3:0] checker_errors;

   wire        [16*8-1:0] crc32_err_cnt_ext;
   wire [NUM_LANES*8-1:0] crc32_err_cnt_s;
   wire   [NUM_LANES-1:0] word_locked_s;
   wire   [NUM_LANES-1:0] sync_locked_s;
   wire            [15:0] crc24_err_cnt_s;
   wire            [31:0] sop_cntr_s;
   wire            [31:0] eop_cntr_s;
   wire            [31:0] err_cnt_s;
   reg              [3:0] checker_errors_s;
   wire                   rx_lanes_aligned_s;
   wire                   latency_ready_s;
   wire                   perf_meas_ready_s;
   wire            [31:0] ch_cnt_s;

   reg                    send_data_mm_clk;
   reg                    error_clear;
   reg                    perf_meas_rdone_s;
   reg                    start_ch_wr_s;
   reg              [7:0] ch_cnt_id_s;
   reg              [7:0] start_channel_s;
   reg              [7:0] num_channels_s;
   reg                    err_read_s;

   wire                   start_ch_wr;
   wire             [7:0] start_channel;
   wire             [7:0] num_channels;
   wire                   err_read;

   wire            [31:0] tx_sop_cnt;
   wire            [31:0] tx_eop_cnt;

   reg                    itx_overflow_sticky;
   reg                    itx_underflow_sticky;
   reg                    irx_overflow_sticky;
   reg                    rdc_overflow_sticky;
   reg                    read_err_flag;
   reg                    read_err_flag_q;

   reg                    itx_overflow_mm_clk;
   reg                    itx_underflow_mm_clk;
   reg                    irx_overflow_mm_clk;
   reg                    rdc_overflow_mm_clk;

   reg                    gaps_en;


   assign itx_calendar = 256'h0101_0202_0303_0404_0505_0606_0707_0808_1011_2223_3435_4647_5859_6a6b_7c7d_8e8f;

   ilk_status_sync #(.WIDTH (NUM_LANES*8))  ss1 (.clk (mm_clk), .din (crc32_err_cnt),     .dout (crc32_err_cnt_s)   );
   ilk_status_sync #(.WIDTH (NUM_LANES)  )  ss2 (.clk (mm_clk), .din (word_locked),       .dout (word_locked_s)     );
   ilk_status_sync #(.WIDTH (NUM_LANES)  )  ss3 (.clk (mm_clk), .din (sync_locked),       .dout (sync_locked_s)     );
   ilk_status_sync #(.WIDTH (16)         )  ss4 (.clk (mm_clk), .din (crc24_err_cnt),     .dout (crc24_err_cnt_s)   );
   ilk_status_sync #(.WIDTH (32)         )  ss5 (.clk (mm_clk), .din (sop_cntr),          .dout (sop_cntr_s)        );
   ilk_status_sync #(.WIDTH (32)         )  ss6 (.clk (mm_clk), .din (eop_cntr),          .dout (eop_cntr_s)        );
   ilk_status_sync #(.WIDTH (32)         )  ss7 (.clk (mm_clk), .din (err_cnt),           .dout (err_cnt_s)         );
   ilk_status_sync #(.WIDTH (4)          )  ss8 (.clk (mm_clk), .din (checker_errors),    .dout (checker_errors_s)  );
   ilk_status_sync #(.WIDTH (1)          )  ss9 (.clk (mm_clk), .din (rx_lanes_aligned),  .dout (rx_lanes_aligned_s));

   ilk_status_sync #(.WIDTH (1)          ) ss21 (.clk (usr_clk), .din (send_data_mm_clk), .dout (send_data)         );
   ilk_status_sync #(.WIDTH (1)          ) ss24 (.clk (usr_clk), .din (start_ch_wr_s),    .dout (start_ch_wr)       );
   ilk_status_sync #(.WIDTH (1)          ) ss29 (.clk (usr_clk), .din (err_read_s),       .dout (err_read)          );
   
   //////////////////////////////////////////////
   // ILK TX MAC PACKETS GENERATOR
   //////////////////////////////////////////////

   ilk_pkt_gen #(
      .INTERNAL_WORDS (INTERNAL_WORDS),
	  .TX_PKTMOD_ONLY     (TX_PKTMOD_ONLY),
      .CALENDAR_PAGES (CALENDAR_PAGES)
   ) ilk_pkt_gen_inst (
      .clk                (usr_clk),
      .rx_lanes_aligned   (rx_lanes_aligned),
      .itx_ready          (itx_ready),
      .send_data          (send_data),
      .reconfig_done      (reconfig_done_d),
      .tx_usr_srst        (tx_usr_srst),
	  .tx_data            (itx_din_words),
	  .tx_valid           (itx_num_valid),
	  .tx_chan            (itx_chan),
	  .tx_sop             (itx_sop),
	  .tx_eopbits         (itx_eopbits),
	  .tx_sob             (itx_sob),
      .tx_eob             (itx_eob),	  
      .tx_sop_cnt         (tx_sop_cnt),
      .tx_eop_cnt         (tx_eop_cnt)

   );

   //////////////////////////////////////////////
   // ILK RX MAC PACKETS CHECKER
   //////////////////////////////////////////////

   ilk_pkt_checker #(
      .SIM_FAKE_JTAG  (SIM_FAKE_JTAG),
      .INTERNAL_WORDS (INTERNAL_WORDS),
	  .TX_PKTMOD_ONLY     (TX_PKTMOD_ONLY),
      .NUM_LANES      (NUM_LANES),
	  .CALENDAR_PAGES (CALENDAR_PAGES)
   ) ilk_pkt_checker_inst (
      .clk                  (usr_clk),
      .clk_rx_common        (clk_rx_common),
      .clk_tx_common        (clk_tx_common),
      .srst_rx_common       (srst_rx_common),
      .srst_tx_common       (srst_tx_common),
      .tx_usr_srst          (tx_usr_srst),
      .rx_usr_srst          (rx_usr_srst),
      .error_clear          (error_clear),
      .rx_lanes_aligned     (rx_lanes_aligned),
      .rx_data              (irx_dout_words),
      .rx_valid             (irx_num_valid0),
      .rx_sop               (irx_sop[1]),
      .rx_sob               (irx_sob[1]),
      .rx_chan              (irx_chan),
      .rx_eopbits           (irx_eopbits),
	  .rx_calendar          (irx_calendar),
      .rx_crc32_err            ({crc32_err & {NUM_LANES{rx_lanes_aligned}}}),
      .rx_crc24_err            (crc24_err & rx_lanes_aligned),
      .sop_cntr_inc         (sop_cntr_inc),
      .eop_cntr_inc         (eop_cntr_inc),
      .itx_overflow         (itx_overflow),
      .itx_underflow        (itx_underflow),
      .irx_overflow         (irx_overflow),
      .rdc_overflow         (rdc_overflow),
      .sop_cntr             (sop_cntr),
      .eop_cntr             (eop_cntr),
      .crc32_err_cnt        (crc32_err_cnt),
      .crc24_err_cnt        (crc24_err_cnt),
      .checker_errors       (checker_errors),
      .err_cnt              (err_cnt),
      .err_read             (err_read),
      .itx_overflow_sticky  (),
      .itx_underflow_sticky (),
      .irx_overflow_sticky  (),
      .rdc_overflow_sticky  ()
   );

   always @(posedge mm_clk or posedge mm_rst) begin
      if (mm_rst) begin
            itx_overflow_sticky <= 1'b0;
            itx_underflow_sticky <= 1'b0;
            irx_overflow_sticky <= 1'b0;
            rdc_overflow_sticky <= 1'b0;
            read_err_flag       <= 1'b0;
            read_err_flag_q     <= 1'b0;
      end else begin
         if (mm_read && (mm_address[7:0] == 8'hb)) begin
            read_err_flag       <= 1'b1;
         end else if (mm_readdatavalid) begin
            read_err_flag       <= 1'b0;
         end
         read_err_flag_q        <= read_err_flag;

         if (itx_overflow_mm_clk) begin
            itx_overflow_sticky <= 1'b1;
         end
         else if (~read_err_flag & read_err_flag_q) begin
            itx_overflow_sticky <= 1'b0;
         end
   
         if (itx_underflow_mm_clk) begin
            itx_underflow_sticky <= 1'b1;
         end
         else if (~read_err_flag & read_err_flag_q) begin
            itx_underflow_sticky <= 1'b0;
         end
   
         if (irx_overflow_mm_clk) begin
            irx_overflow_sticky <= 1'b1;
         end
         else if (~read_err_flag & read_err_flag_q) begin
            irx_overflow_sticky <= 1'b0;
         end
   
         if (rdc_overflow_mm_clk) begin
            rdc_overflow_sticky <= 1'b1;
         end
         else if (~read_err_flag & read_err_flag_q) begin
            rdc_overflow_sticky <= 1'b0;
         end
      end
   end

   assign crc32_err_cnt_ext = {(16*8){1'b0}} | crc32_err_cnt_s;

   // Testbench Registers
   always @(posedge mm_clk) begin
      mm_readdatavalid <= 1'b0;
      if (mm_read) begin
         mm_readdata      <= 32'h0;
         mm_readdatavalid <= 1'b1;
         case (mm_address[7:0])
            8'h0    : mm_readdata <= 32'h12345678;
            8'h2    : mm_readdata <= 32'h0 | {gaps_en, sys_pll_rst_en, sys_pll_rst_req};

            8'h3    : mm_readdata <= 32'h0 | rx_lanes_aligned_s;
            8'h4    : mm_readdata <= 32'h0 | word_locked_s;
            8'h5    : mm_readdata <= 32'h0 | sync_locked_s;

            8'h6    : mm_readdata <= 32'h0 | crc32_err_cnt_ext[31:0];
            8'h7    : mm_readdata <= 32'h0 | crc32_err_cnt_ext[63:32];
            8'h8    : mm_readdata <= 32'h0 | crc32_err_cnt_ext[95:64];
            8'h9    : mm_readdata <= 32'h0 | crc32_err_cnt_ext[127:96];

            8'ha    : mm_readdata <= 32'h0 | crc24_err_cnt_s;
            8'hb    : mm_readdata <= 32'h0 | {rdc_overflow_sticky,
                                              irx_overflow_sticky,
                                              itx_overflow_sticky,
                                              itx_underflow_sticky};
            8'hc    : mm_readdata <= 32'h0 | sop_cntr_s;
            8'hd    : mm_readdata <= 32'h0 | eop_cntr_s;
            8'he    : mm_readdata <= 32'h0 | err_cnt_s;  // Actual data error counter
            8'hf    : mm_readdata <= 32'h0 | send_data_mm_clk;
            8'h10   : mm_readdata <= 32'h0 | checker_errors_s;
            8'h11   : mm_readdata <= 32'h0 | sys_pll_locked;
            8'h14   : mm_readdata <= 32'h0 | tx_sop_cnt;
            8'h15   : mm_readdata <= 32'h0 | tx_eop_cnt;
            8'h37   : mm_readdata <= 32'h0 | start_channel_s;
            8'h38   : mm_readdata <= 32'h0 | num_channels_s;
            8'h41   : mm_readdata <= 32'h0 | ch_cnt_s;

            default : mm_readdata <= 32'hDEAD_BEEF;
         endcase
      end
   end

   initial begin
      pll_srv_rst        = 1'b0;
      sys_pll_rst_en     = 1'b0;
      sys_pll_rst_req    = 1'b0;
      gaps_en            = 1'b0;
      send_data_mm_clk   = 1'b0;
      perf_meas_rdone_s  = 1'b0;
      start_channel_s    = 8'h0;
      num_channels_s     = 8'hFF;
   end

   always @(posedge mm_clk or posedge mm_rst) begin
      if (mm_rst) begin
         pll_srv_rst        <= 1'b0;
         sys_pll_rst_en     <= 1'b0;
         sys_pll_rst_req    <= 1'b0;
         gaps_en            <= 1'b0;
         send_data_mm_clk   <= 1'b0;
         perf_meas_rdone_s  <= 1'b0;
         start_channel_s    <= 8'h0;
         num_channels_s     <= 8'hFF;
      end
      else if (mm_write) begin
         case (mm_address[7:0])
            8'h1  : pll_srv_rst        <= mm_writedata[0];
            8'h2  : sys_pll_rst_req    <= mm_writedata[0];
            8'h3  : sys_pll_rst_en     <= mm_writedata[0];
            8'he  : error_clear        <= mm_writedata[0];
            8'hf  : send_data_mm_clk   <= mm_writedata[0];
            8'h37 : start_channel_s    <= mm_writedata[7:0];  // fix start channel
            8'h38 : num_channels_s     <= mm_writedata[7:0];  // fix number of  channel
         endcase
      end
   end

   always @(posedge mm_clk) begin
      if (mm_write && mm_address[7:0] == 6'h37) begin
         start_ch_wr_s <= 1'b1;
      end
      else begin
         start_ch_wr_s <= 1'b0;
      end
   end

   always @(posedge mm_clk) begin
      if (mm_readdatavalid && mm_address[7:0] == 6'h10) begin
         err_read_s <= 1'b1;
      end
      else begin
         err_read_s <= 1'b0;
      end
   end

   one_shot itx_overflow_one_shot  (.clk(mm_clk), .rst_n(usr_rst_n), .din(itx_overflow),  .dout(itx_overflow_mm_clk) );
   one_shot itx_underflow_one_shot (.clk(mm_clk), .rst_n(usr_rst_n), .din(itx_underflow), .dout(itx_underflow_mm_clk));
   one_shot irx_overflow_one_shot  (.clk(mm_clk), .rst_n(usr_rst_n), .din(irx_overflow),  .dout(irx_overflow_mm_clk) );
   one_shot rdc_overflow_one_shot  (.clk(mm_clk), .rst_n(usr_rst_n), .din(rdc_overflow),  .dout(rdc_overflow_mm_clk) );

endmodule
