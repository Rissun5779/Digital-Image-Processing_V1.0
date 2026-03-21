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


// *********************************************************************
// Description
// 
// Top-level module for DisplayPort Example Design 
// DisplayPort Receiver + DisplayPort Transmitter. 
// The DisplayPort received image clock is recovered and used for the DisplayPort output. 
// Support for HBR2 (RX and TX) and all resolutions from 1080p up to 4K @ 60 Hz (600 MHz)
//
// *********************************************************************

module mst_sv_dp_demo(
  clk100,
  clk50,
  resetn,
  RX_SENSE_P,
  RX_SENSE_N,
  TX_HPD,
  AUX_TX_DRV_IN,
  AUX_RX_DRV_IN,
  rx_serial_data,
  user_pb,
  RX_CAD,
  RX_ENA,
  TX_ENA,
  RX_HPD,
  AUX_TX_DRV_OUT,
  AUX_TX_DRV_OE,
  AUX_RX_DRV_OUT,
  AUX_RX_DRV_OE,
  mem_reset_n,
  SCL_CTL,
  SDA_CTL,
  tx_serial_data,
  user_led
);


input wire  clk100;
input wire  clk50;
input wire  resetn;
input wire  RX_SENSE_P;
input wire  RX_SENSE_N;
input wire  TX_HPD;
input wire  AUX_TX_DRV_IN;
input wire  AUX_RX_DRV_IN;
input wire  [3:0] rx_serial_data;
input wire  [0:0] user_pb;
output wire RX_CAD;
output wire RX_ENA;
output wire TX_ENA;
output wire RX_HPD;
output wire AUX_TX_DRV_OUT;
output wire AUX_TX_DRV_OE;
output wire AUX_RX_DRV_OUT;
output wire AUX_RX_DRV_OE;
output wire mem_reset_n;
inout wire  SCL_CTL;
inout wire  SDA_CTL;
output wire [3:0] tx_serial_data;
output wire [7:0] user_led;

assign RX_CAD = 1'b0;
assign RX_ENA = 1'b1;
assign TX_ENA = 1'b1;
assign mem_reset_n = 1'b0;

wire clk_50 = clk50;
wire clk_100 = clk100;
wire clk_135;
wire clk_16;
wire clk_vid;
wire reset_in;
wire reset;
wire reset_n;
wire video_pll_locked;
wire xcvr_pll_locked;
wire clk_cntrl;

assign reset_in = ~resetn;
assign reset = ~video_pll_locked | ~xcvr_pll_locked;
assign reset_n = ~reset;

sv_xcvr_pll sv_xcvr_pll_i
(
  .rst        (reset_in),
  .refclk     (clk_50),
  .outclk_0   (clk_135),
  .locked     (xcvr_pll_locked)
);

video_pll_sv video_pll_i
(
  .rst        (reset_in),
  .refclk     (clk_100),
  .outclk_0   (clk_vid),
  .outclk_1   (clk_16),
  .outclk_2   (clk_cntrl),
  .locked     (video_pll_locked)
);

reg clk_cal;
always @ (posedge clk100)
  clk_cal <= ~clk_cal;

// ----------------------
// Clock recovery modules
// ----------------------

wire rx_link_clk_gxb;
wire rx_link_clk;
// rx_link_clk needs to be forced to be a Global clock
rx_clk_buf rx_clk_buf_i
(
  .inclk   (rx_link_clk_gxb),
  .outclk  (rx_link_clk)
);
wire clk0_rec;
wire clk1_rec;
wire clk2_rec;
wire clk3_rec;
wire [95:0] vid0_data;
wire [3:0] vid0_valid;
wire vid0_lock;
wire vid0_sof,vid0_eof;
wire vid0_sol,vid0_eol;

wire [95:0] vid1_data;
wire [3:0] vid1_valid;
wire vid1_lock;
wire vid1_sof,vid1_eof;
wire vid1_sol,vid1_eol;

wire [95:0] vid2_data;
wire [3:0] vid2_valid;
wire vid2_lock;
wire vid2_sof,vid2_eof;
wire vid2_sol,vid2_eol;

wire [95:0] vid3_data;
wire [3:0] vid3_valid;
wire vid3_lock;
wire vid3_sof,vid3_eof;
wire vid3_sol,vid3_eol;

wire [95:0] wid0_data;
wire wid0_h,wid0_v,wid0_de;
wire [95:0] wid1_data;
wire wid1_h,wid1_v,wid1_de;
wire [95:0] wid2_data;
wire wid2_h,wid2_v,wid2_de;
wire [95:0] wid3_data;
wire wid3_h,wid3_v,wid3_de;
wire  [216:0] rx0_msa;
wire  [216:0] rx1_msa;
wire  [216:0] rx2_msa;
wire  [216:0] rx3_msa;
wire [1:0] rx_link_rate;

bitec_clkrec bitec_clkrec_0
(
  .areset       (reset),
  .clk          (clk_cntrl),
  .vidin_clk    (clk_vid),
  .vidin_data   (vid0_data),
  .vidin_valid  (vid0_valid[0]),
  .vidin_locked (vid0_lock),
  .vidin_sof    (vid0_sof),
  .vidin_eof    (vid0_eof),
  .vidin_sol    (vid0_sol),
  .vidin_eol    (vid0_eol),

  .rx_link_clk  (rx_link_clk),
  .rx_link_rate (rx_link_rate),
  .rx_msa       (rx0_msa),
  
  .rec_clk      (clk0_rec),
  
  .vidout       (wid0_data),
  .hsync        (wid0_h),
  .vsync        (wid0_v),
  .de           (wid0_de)
);
  defparam bitec_clkrec_0.BPP = 24;
  defparam bitec_clkrec_0.CLK_PERIOD_NS = 17;
  defparam bitec_clkrec_0.DEVICE_FAMILY = "Stratix V";
  defparam bitec_clkrec_0.FIXED_NVID = 0;
  defparam bitec_clkrec_0.PIXELS_PER_CLOCK = 4;
  defparam bitec_clkrec_0.SYMBOLS_PER_CLOCK = 2;

bitec_clkrec bitec_clkrec_1
(
  .areset       (reset),
  .clk          (clk_cntrl),
  .vidin_clk    (clk_vid),
  .vidin_data   (vid1_data),
  .vidin_valid  (vid1_valid[0]),
  .vidin_locked (vid1_lock),
  .vidin_sof    (vid1_sof),
  .vidin_eof    (vid1_eof),
  .vidin_sol    (vid1_sol),
  .vidin_eol    (vid1_eol),

  .rx_link_clk  (rx_link_clk),
  .rx_link_rate (rx_link_rate),
  .rx_msa       (rx1_msa),

  .rec_clk      (clk1_rec),

  .vidout       (wid1_data),
  .hsync        (wid1_h),
  .vsync        (wid1_v),
  .de           (wid1_de)
);
  defparam bitec_clkrec_1.BPP = 24;
  defparam bitec_clkrec_1.CLK_PERIOD_NS = 17;
  defparam bitec_clkrec_1.DEVICE_FAMILY = "Stratix V";
  defparam bitec_clkrec_1.FIXED_NVID = 0;
  defparam bitec_clkrec_1.PIXELS_PER_CLOCK = 4;
  defparam bitec_clkrec_1.SYMBOLS_PER_CLOCK = 2;

bitec_clkrec bitec_clkrec_2
(
  .areset       (reset),
  .clk          (clk_cntrl),
  .vidin_clk    (clk_vid),
  .vidin_data   (vid2_data),
  .vidin_valid  (vid2_valid[0]),
  .vidin_locked (vid2_lock),
  .vidin_sof    (vid2_sof),
  .vidin_eof    (vid2_eof),
  .vidin_sol    (vid2_sol),
  .vidin_eol    (vid2_eol),

  .rx_link_clk  (rx_link_clk),
  .rx_link_rate (rx_link_rate),
  .rx_msa       (rx2_msa),

  .rec_clk      (clk2_rec),

  .vidout       (wid2_data),
  .hsync        (wid2_h),
  .vsync        (wid2_v),
  .de           (wid2_de)
);
  defparam bitec_clkrec_2.BPP = 24;
  defparam bitec_clkrec_2.CLK_PERIOD_NS = 17;
  defparam bitec_clkrec_2.DEVICE_FAMILY = "Stratix V";
  defparam bitec_clkrec_2.FIXED_NVID = 0;
  defparam bitec_clkrec_2.PIXELS_PER_CLOCK = 4;
  defparam bitec_clkrec_2.SYMBOLS_PER_CLOCK = 2;

bitec_clkrec bitec_clkrec_3
(
  .areset       (reset),
  .clk          (clk_cntrl),
  .vidin_clk    (clk_vid),
  .vidin_data   (vid3_data),
  .vidin_valid  (vid3_valid[0]),
  .vidin_locked (vid3_lock),
  .vidin_sof    (vid3_sof),
  .vidin_eof    (vid3_eof),
  .vidin_sol    (vid3_sol),
  .vidin_eol    (vid3_eol),

  .rx_link_clk  (rx_link_clk),
  .rx_link_rate (rx_link_rate),
  .rx_msa       (rx3_msa),

  .rec_clk      (clk3_rec),

  .vidout       (wid3_data),
  .hsync        (wid3_h),
  .vsync        (wid3_v),
  .de           (wid3_de)
);
  defparam bitec_clkrec_3.BPP = 24;
  defparam bitec_clkrec_3.CLK_PERIOD_NS = 17;
  defparam bitec_clkrec_3.DEVICE_FAMILY = "Stratix V";
  defparam bitec_clkrec_3.FIXED_NVID = 0;
  defparam bitec_clkrec_3.PIXELS_PER_CLOCK = 4;
  defparam bitec_clkrec_3.SYMBOLS_PER_CLOCK = 2;

// ----------------------
// DisplayPort subsystem
// ----------------------
wire [91:0] from_gxb_rx;
wire [4:0] from_gxb_tx;
wire [0:0] from_rx_reconfig;
wire [0:0] from_tx_reconfig;
wire [20:0] to_gxb_rx;
wire [79:0] to_gxb_tx;
wire [8:0] to_rx_reconfig;
wire [19:0] to_tx_reconfig;
wire [4:0] rx_lane_count;
wire rx0_stream_out_valid;
wire rx1_stream_out_valid;
wire rx2_stream_out_valid;
wire rx3_stream_out_valid;
wire  tx_cal_busy;
wire  rx_cal_busy;
wire [7:0] dp_rx_reconfig_link_rate_8bits;
wire [7:0] dp_tx_reconfig_link_rate_8bits;

control control_i
(
  .clk_100_clk                      (clk_100),
  .clk_16_clk                       (clk_16),
  .resetn_reset_n                   (reset_n),
  .dp_clk_cal_clk     				(clk_cal),
  .dp_xcvr_mgmt_clk_clk 			(clk100),
  .pio_0_external_connection_export (~user_pb[0]),

  .oc_i2c_master_0_conduit_start_scl_pad_io (SCL_CTL),
  .oc_i2c_master_0_conduit_start_sda_pad_io (SDA_CTL),
  
  // DisplayPort RX side
  .dp_rx_aux_rx_aux_in       			(AUX_RX_DRV_IN),
  .dp_rx_aux_rx_aux_out      			(AUX_RX_DRV_OUT),
  .dp_rx_aux_rx_aux_oe       			(AUX_RX_DRV_OE),
  .dp_rx_aux_rx_hpd          			(RX_HPD),
  .dp_rx_aux_rx_cable_detect 			(~RX_SENSE_P),
  .dp_rx_aux_rx_pwr_detect   			(RX_SENSE_N),
  .dp_rx_xcvr_interface_rx_analogreset         (to_gxb_rx[7:4]),		//dp_rx_gxb_conduit_to_gxb_rx
  .dp_rx_xcvr_interface_rx_digitalreset		(to_gxb_rx[3:0]),
  .dp_rx_xcvr_interface_rx_set_locktoref		(to_gxb_rx[12:9]),
  .dp_rx_xcvr_interface_rx_set_locktodata		(to_gxb_rx[16:13]),
  .dp_rx_xcvr_interface_rx_bitslip             (to_gxb_rx[20:17]),
  .dp_rx_xcvr_interface_rx_parallel_data		(from_gxb_rx[79:0]),		//dp_rx_gxb_conduit_from_gxb_rx
  .dp_rx_xcvr_interface_rx_std_clkout		(from_gxb_rx[91:88]),
  .dp_rx_xcvr_interface_rx_is_lockedtoref		(from_gxb_rx[83:80]),
  .dp_rx_xcvr_interface_rx_is_lockedtodata		(from_gxb_rx[87:84]),
  .dp_rx_xcvr_interface_rx_cal_busy            ({4{rx_cal_busy}}),		//dp_rx_reconfig_conduit_from_rx_reconfig
  .dp_rx_reconfig_rx_reconfig_busy             (from_rx_reconfig),
  .dp_rx_reconfig_rx_link_rate                 (to_rx_reconfig[2:1]),		//dp_rx_reconfig_conduit_to_rx_reconfig
  .dp_rx_reconfig_rx_link_rate_8bits           (dp_rx_reconfig_link_rate_8bits),
  .dp_rx_reconfig_rx_reconfig_req              (to_rx_reconfig[0]),
  .dp_rx_reconfig_rx_reconfig_ack              (1'b1),
  // RX Stream0
  .dp_rx_vid_clk_clk    			(clk_vid),
  .dp_rx_video_out_rx_vid_data   			(vid0_data),
  .dp_rx_video_out_rx_vid_sol    			(vid0_sol),
  .dp_rx_video_out_rx_vid_eol    			(vid0_eol),
  .dp_rx_video_out_rx_vid_sof    			(vid0_sof),
  .dp_rx_video_out_rx_vid_eof    			(vid0_eof),
  .dp_rx_video_out_rx_vid_locked 			(vid0_lock),
  .dp_rx_video_out_rx_vid_valid  			(vid0_valid),
  .dp_rx_stream_rx_stream_valid    			(rx0_stream_out_valid),
  .dp_rx_msa_conduit_rx_msa         (rx0_msa),
  // RX Stream1
  .dp_rx1_vid_clk_clk               (clk_vid),
  .dp_rx1_video_out_rx1_vid_data            (vid1_data),
  .dp_rx1_video_out_rx1_vid_sol             (vid1_sol),
  .dp_rx1_video_out_rx1_vid_eol             (vid1_eol),
  .dp_rx1_video_out_rx1_vid_sof             (vid1_sof),
  .dp_rx1_video_out_rx1_vid_eof             (vid1_eof),
  .dp_rx1_video_out_rx1_vid_locked          (vid1_lock),
  .dp_rx1_video_out_rx1_vid_valid           (vid1_valid),
  .dp_rx1_stream_rx1_stream_valid              (rx1_stream_out_valid),
  .dp_rx1_msa_conduit_rx1_msa        (rx1_msa),
  // RX Stream2
  .dp_rx2_vid_clk_clk               (clk_vid),
  .dp_rx2_video_out_rx2_vid_data            (vid2_data),
  .dp_rx2_video_out_rx2_vid_sol             (vid2_sol),
  .dp_rx2_video_out_rx2_vid_eol             (vid2_eol),
  .dp_rx2_video_out_rx2_vid_sof             (vid2_sof),
  .dp_rx2_video_out_rx2_vid_eof             (vid2_eof),
  .dp_rx2_video_out_rx2_vid_locked          (vid2_lock),
  .dp_rx2_video_out_rx2_vid_valid           (vid2_valid),
  .dp_rx2_stream_rx2_stream_valid              (rx2_stream_out_valid),
  .dp_rx2_msa_conduit_rx2_msa        (rx2_msa),
  // RX Stream3
  .dp_rx3_vid_clk_clk               (clk_vid),
  .dp_rx3_video_out_rx3_vid_data            (vid3_data),
  .dp_rx3_video_out_rx3_vid_sol             (vid3_sol),
  .dp_rx3_video_out_rx3_vid_eol             (vid3_eol),
  .dp_rx3_video_out_rx3_vid_sof             (vid3_sof),
  .dp_rx3_video_out_rx3_vid_eof             (vid3_eof),
  .dp_rx3_video_out_rx3_vid_locked          (vid3_lock),
  .dp_rx3_video_out_rx3_vid_valid           (vid3_valid),
  .dp_rx3_stream_rx3_stream_valid              (rx3_stream_out_valid),
  .dp_rx3_msa_conduit_rx3_msa        (rx3_msa),

  .dp_rx_params_rx_lane_count     			(rx_lane_count),

  // DisplayPort TX side
  .dp_tx_aux_tx_aux_in       			(AUX_TX_DRV_IN),
  .dp_tx_aux_tx_aux_out      			(AUX_TX_DRV_OUT),
  .dp_tx_aux_tx_aux_oe       			(AUX_TX_DRV_OE),
  .dp_tx_aux_tx_hpd          			(TX_HPD),
  .dp_tx_xcvr_interface_tx_parallel_data 		(to_gxb_tx[79:0]),		//dp_tx_gxb_conduit_to_gxb_tx
  .dp_tx_xcvr_interface_tx_std_clkout              (from_gxb_tx[4:1]),		//dp_tx_gxb_conduit_from_gxb_tx
  .dp_tx_xcvr_interface_tx_pll_locked              (from_gxb_tx[0]),
  .dp_tx_xcvr_interface_tx_cal_busy                ({4{tx_cal_busy}}),		//dp_tx_reconfig_conduit_from_tx_reconfig
  .dp_tx_reconfig_tx_link_rate                     (to_tx_reconfig[3:2]),		//dp_tx_reconfig_conduit_to_tx_reconfig
  .dp_tx_reconfig_tx_link_rate_8bits               (dp_tx_reconfig_link_rate_8bits),
  .dp_tx_reconfig_tx_reconfig_req                  (to_tx_reconfig[1]),
  .dp_tx_analog_reconfig_tx_vod                    (to_tx_reconfig[11:4]),
  .dp_tx_analog_reconfig_tx_emp                    (to_tx_reconfig[19:12]),
  .dp_tx_analog_reconfig_tx_analog_reconfig_req	(to_tx_reconfig[0]),
  .dp_tx_reconfig_tx_reconfig_ack                  (1'b1),
  .dp_tx_reconfig_tx_reconfig_busy                 (from_tx_reconfig),
  .dp_tx_analog_reconfig_tx_analog_reconfig_ack 	(1'b1),
  .dp_tx_analog_reconfig_tx_analog_reconfig_busy	(from_tx_reconfig),
  // TX Stream0
  .dp_tx_vid_clk_clk      			(clk0_rec),
  .dp_tx_video_in_tx_vid_data     			(wid0_data),
  .dp_tx_video_in_tx_vid_v_sync            ({wid0_v,wid0_v,wid0_v,wid0_v}),
  .dp_tx_video_in_tx_vid_h_sync            ({wid0_h,wid0_h,wid0_h,wid0_h}),
  .dp_tx_video_in_tx_vid_de       			({wid0_de,wid0_de,wid0_de,wid0_de}),
  // TX Stream1
  .dp_tx1_vid_clk_clk               (clk1_rec),
  .dp_tx1_video_in_tx1_vid_data             (wid1_data),
  .dp_tx1_video_in_tx1_vid_v_sync           ({wid1_v,wid1_v,wid1_v,wid1_v}),
  .dp_tx1_video_in_tx1_vid_h_sync           ({wid1_h,wid1_h,wid1_h,wid1_h}),
  .dp_tx1_video_in_tx1_vid_de               ({wid1_de,wid1_de,wid1_de,wid1_de}),
  // TX Stream2
  .dp_tx2_vid_clk_clk               (clk2_rec),
  .dp_tx2_video_in_tx2_vid_data             (wid2_data),
  .dp_tx2_video_in_tx2_vid_v_sync           ({wid2_v,wid2_v,wid2_v,wid2_v}),
  .dp_tx2_video_in_tx2_vid_h_sync           ({wid2_h,wid2_h,wid2_h,wid2_h}),
  .dp_tx2_video_in_tx2_vid_de               ({wid2_de,wid2_de,wid2_de,wid2_de}),
  // TX Stream3
  .dp_tx3_vid_clk_clk               (clk3_rec),
  .dp_tx3_video_in_tx3_vid_data             (wid3_data),
  .dp_tx3_video_in_tx3_vid_v_sync           ({wid3_v,wid3_v,wid3_v,wid3_v}),
  .dp_tx3_video_in_tx3_vid_h_sync           ({wid3_h,wid3_h,wid3_h,wid3_h}),
  .dp_tx3_video_in_tx3_vid_de               ({wid3_de,wid3_de,wid3_de,wid3_de})
);

assign rx_link_clk_gxb = from_gxb_rx[88];
assign rx_link_rate = to_rx_reconfig[2:1];

// -------------------------------
// XCVR reconfiguration and reset
// -------------------------------

wire [6:0] cfg_mgmt_addr;
wire [31:0] cfg_mgmt_rdata;
wire [31:0] cfg_mgmt_wdata;
wire cfg_mgmt_write;
wire cfg_mgmt_read;
wire cfg_mgmt_waitreq;
wire [183:0] reconfig_from_gxb_rx;
wire [229:0] reconfig_from_gxb_tx;
wire [279:0] reconfig_to_gxb_rx;
wire [349:0] reconfig_to_gxb_tx;
wire  reconfig_busy;

gxb_reconfig  gxb_reconfig_i
(
  .mgmt_clk_clk       (clk_100),
  .mgmt_rst_reset     (reset),
  
  .reconfig_mgmt_read         (cfg_mgmt_read),
  .reconfig_mgmt_write        (cfg_mgmt_write),
  .reconfig_mgmt_address      (cfg_mgmt_addr),
  .reconfig_mgmt_writedata    (cfg_mgmt_wdata),
  .reconfig_mgmt_waitrequest  (cfg_mgmt_waitreq),
  .reconfig_mgmt_readdata     (cfg_mgmt_rdata),
  
  .ch0_3_from_xcvr    (reconfig_from_gxb_rx),
  .ch0_3_to_xcvr      (reconfig_to_gxb_rx),
  .ch4_8_from_xcvr    (reconfig_from_gxb_tx),
  .ch4_8_to_xcvr      (reconfig_to_gxb_tx),
  
  .reconfig_busy    (reconfig_busy),
  .tx_cal_busy      (tx_cal_busy),
  .rx_cal_busy      (rx_cal_busy)
);

wire [3:0] rx_anares;
wire [3:0] rx_digres;
wire tx_xcvr_reset;

bitec_reconfig_alt_sv bitec_reconfig_alt_sv_i
(
  .clk                    (clk_100),
  .reset                  (reset),

  .mgmt_waitrequest       (cfg_mgmt_waitreq),
  .mgmt_write             (cfg_mgmt_write),
  .mgmt_read              (cfg_mgmt_read),
  .mgmt_address           (cfg_mgmt_addr),
  .mgmt_writedata         (cfg_mgmt_wdata),
  .mgmt_readdata          (cfg_mgmt_rdata),
  .reconfig_busy          (reconfig_busy),
  .rx_cal_busy            (rx_cal_busy),
  .tx_cal_busy            (tx_cal_busy),

  .rx_link_rate           (dp_rx_reconfig_link_rate_8bits),
  .rx_link_rate_strobe    (to_rx_reconfig[0]),
  .rx_xcvr_busy           (from_rx_reconfig),

  .tx_link_rate           (dp_tx_reconfig_link_rate_8bits),
  .tx_vod                 (to_tx_reconfig[11:4]),
  .tx_emp                 (to_tx_reconfig[19:12]),
  .tx_link_rate_strobe    (to_tx_reconfig[1]),
//.tx_vodemp_strobe       (to_tx_reconfig[0]),
  .tx_vodemp_strobe       (1'b0), // VOD/EMP adaptation provided by the SN75DP130 equaliser
  .tx_hdmi_en             (1'b0),
  .tx_xcvr_busy           (from_tx_reconfig),
  .tx_xcvr_reset          (tx_xcvr_reset),
  
  .rx_analogreset_in      (to_gxb_rx[7:4]),
  .rx_digitalreset_in     (to_gxb_rx[3:0]),
  .rx_analogreset         (rx_anares),
  .rx_digitalreset        (rx_digres)
);
  defparam  bitec_reconfig_alt_sv_i.HDMI_CLKX2 = 1;
  defparam  bitec_reconfig_alt_sv_i.RX_LANES = 4;
  defparam  bitec_reconfig_alt_sv_i.TX_LANES = 4;

wire [3:0] tx_analogreset;
wire [3:0] tx_digitalreset;
wire tx_pll_locked;
wire [3:0] tx_cal_busy_gxb;
wire tx_pll_powerdown;

gxb_reset gxb_reset_i
(
  .clock          (clk_100),
  .reset          (tx_xcvr_reset | reset),
  .pll_locked     (tx_pll_locked),
  .pll_select     (1'b0),
  .tx_cal_busy    (tx_cal_busy_gxb),
  .pll_powerdown  (tx_pll_powerdown),
  .tx_analogreset (tx_analogreset),
  .tx_digitalreset(tx_digitalreset)
);

// -------------------------------
// XCVR instantiations
// -------------------------------

wire [3:0] rx_coreclkin = from_gxb_rx[91:88];

gxb_rx gxb_rx_i
(
  .rx_cdr_refclk      (clk_135),
  .rx_analogreset     (rx_anares),
  .rx_digitalreset    (rx_digres),
  .rx_serial_data     (rx_serial_data),
  .rx_set_locktodata  (to_gxb_rx[16:13]),
  .rx_set_locktoref   (to_gxb_rx[12:9]),
  .rx_std_bitslip     (to_gxb_rx[20:17]),
  .rx_std_coreclkin   (rx_coreclkin),
  .rx_std_polinv      (4'b1111),

  .reconfig_from_xcvr (reconfig_from_gxb_rx),
  .reconfig_to_xcvr   (reconfig_to_gxb_rx),
  
  .rx_is_lockedtoref  (from_gxb_rx[83:80]),
  .rx_is_lockedtodata (from_gxb_rx[87:84]),
  .rx_parallel_data   (from_gxb_rx[79:0]),
  .rx_std_clkout      (from_gxb_rx[91:88])
);

wire [3:0] tx_coreclkin = {from_gxb_tx[1],from_gxb_tx[1],from_gxb_tx[1],from_gxb_tx[1]};

gxb_tx gxb_tx_i
(
  .tx_pll_refclk        (clk_135),
  .pll_powerdown        (tx_pll_powerdown),
  .tx_analogreset       (tx_analogreset),
  .tx_digitalreset      (tx_digitalreset),
  
  .reconfig_to_xcvr     (reconfig_to_gxb_tx),
  .reconfig_from_xcvr   (reconfig_from_gxb_tx),

  .tx_parallel_data     (to_gxb_tx[79:0]),
  .tx_std_coreclkin     (tx_coreclkin),
  .tx_std_polinv        (4'b0000),
  
  .pll_locked           (tx_pll_locked),
  .tx_cal_busy          (tx_cal_busy_gxb),
  .tx_serial_data       (tx_serial_data),
  .tx_std_clkout        (from_gxb_tx[4:1])
);

assign  from_gxb_tx[0] = tx_pll_locked;


// -------------------------------
// LED Indication
// -------------------------------
assign user_led[0] =  ~vid0_lock;
assign user_led[5:1] =  ~(rx_lane_count);
assign user_led[7:6] =  ~(rx_link_rate);

endmodule
