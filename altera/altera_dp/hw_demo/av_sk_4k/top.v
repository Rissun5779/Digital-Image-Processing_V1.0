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

module top(
  clk100,
  resetn,
  RX_SENSE_P,
  RX_SENSE_N,
  TX_HPD,
  refclk2_qr1_p,
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
input wire  resetn;
input wire  RX_SENSE_P;
input wire  RX_SENSE_N;
input wire  TX_HPD;
input wire  refclk2_qr1_p;
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

wire clk_100 = clk100;
wire clk_125 = refclk2_qr1_p;
wire clk_135;
wire clk_16;
wire clk_vid;
wire reset_in;
wire reset;
wire reset_n;
wire video_pll_locked;
wire clk_cntrl;

assign reset_in = ~resetn;
assign reset = ~video_pll_locked;
assign reset_n = ~reset;

video_pll_av video_pll_i
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
// Clock recovery module
// ----------------------

wire clk_rec;
wire [191:0] vid_data;
wire [3:0] vid_valid;
wire vid_lock;
wire vid_sof,vid_eof;
wire vid_sol,vid_eol;
wire wid_reset;
wire [191:0] wid_data;
wire wid_h,wid_v,wid_de;
wire rx_link_clk;
wire [1:0] rx_link_rate;
wire  [216:0] rx_msa;

pll_135 pll_135_i
(
	.refclk(clk_125),
	.rst(reset_in),
	.outclk_0(clk_135)
);

bitec_clkrec bitec_clkrec_i
(
  .areset       (reset),
  .clk          (clk_cntrl),

  .vidin_clk    (clk_vid),
  .vidin_data   (vid_data),
  .vidin_valid  (vid_valid[0]),
  .vidin_locked (vid_lock),
  .vidin_sof    (vid_sof),
  .vidin_eof    (vid_eof),
  .vidin_sol    (vid_sol),
  .vidin_eol    (vid_eol),

  .rx_link_clk  (rx_link_clk),
  .rx_link_rate (rx_link_rate),
  .rx_msa       (rx_msa),
  
  .rec_clk      (clk_rec),
  
  .reset_out    (wid_reset),
  .vidout       (wid_data),
  .hsync        (wid_h),
  .vsync        (wid_v),
  .de           (wid_de)
);
  defparam bitec_clkrec_i.BPP = 48;
  defparam bitec_clkrec_i.CLK_PERIOD_NS = 17;
  defparam bitec_clkrec_i.DEVICE_FAMILY = "Arria V";
  defparam bitec_clkrec_i.FIXED_NVID = 0;
  defparam bitec_clkrec_i.PIXELS_PER_CLOCK = 4;
  defparam bitec_clkrec_i.SYMBOLS_PER_CLOCK = 4;

wire clk_audio;
wire audio_valid;
wire audio_mute;
wire [32*8-1:0] audio_data;
wire [31:0] audio_data_ch0;

// ----------------------
// DisplayPort subsystem
// ----------------------

wire [171:0] from_gxb_rx;
wire [4:0] from_gxb_tx;
wire [0:0] from_rx_reconfig;
wire [0:0] from_tx_reconfig;
wire [20:0] to_gxb_rx;
wire [164:0] to_gxb_tx;
wire [2:0] to_rx_reconfig;
wire [19:0] to_tx_reconfig;
wire [4:0] rx_lane_count;
wire rx0_stream_out_valid;
wire  tx_cal_busy;
wire  rx_cal_busy;
wire [7:0] dp_rx_reconfig_link_rate_8bits;
wire [7:0] dp_tx_reconfig_link_rate_8bits;

control control_i
(
  .clk_100_clk                			(clk_100),
  .clk_16_clk                 			(clk_16),
  .resetn_reset_n             			(reset_n),
  .dp_clk_cal_clk     				(clk_cal),
  .dp_xcvr_mgmt_clk_clk 			(clk100),
  .pio_0_external_connection_export   		(~user_pb[0]),

  .oc_i2c_master_0_conduit_start_scl_pad_io 	(SCL_CTL),
  .oc_i2c_master_0_conduit_start_sda_pad_io 	(SDA_CTL),
  
  // DisplayPort RX side

  .dp_rx_aux_rx_aux_in       			(AUX_RX_DRV_IN),
  .dp_rx_aux_rx_aux_out      			(AUX_RX_DRV_OUT),
  .dp_rx_aux_rx_aux_oe       			(AUX_RX_DRV_OE),
  .dp_rx_aux_rx_hpd          			(RX_HPD),
  .dp_rx_aux_rx_cable_detect 			(~RX_SENSE_P),
  .dp_rx_aux_rx_pwr_detect   			(RX_SENSE_N),
  .dp_rx_xcvr_interface_rx_analogreset		(to_gxb_rx[7:4]),		//dp_rx_gxb_conduit_to_gxb_rx
  .dp_rx_xcvr_interface_rx_digitalreset		(to_gxb_rx[3:0]),
  .dp_rx_xcvr_interface_rx_set_locktoref		(to_gxb_rx[12:9]),
  .dp_rx_xcvr_interface_rx_set_locktodata		(to_gxb_rx[16:13]),
  .dp_rx_xcvr_interface_rx_bitslip			(to_gxb_rx[20:17]),
  .dp_rx_xcvr_interface_rx_parallel_data		(from_gxb_rx[159:0]),		//dp_rx_gxb_conduit_from_gxb_rx
  .dp_rx_xcvr_interface_rx_std_clkout		(from_gxb_rx[171:168]),
  .dp_rx_xcvr_interface_rx_is_lockedtoref		(from_gxb_rx[163:160]),
  .dp_rx_xcvr_interface_rx_is_lockedtodata		(from_gxb_rx[167:164]),
  .dp_rx_xcvr_interface_rx_cal_busy		({4{rx_cal_busy}}),		//dp_rx_reconfig_conduit_from_rx_reconfig
  .dp_rx_reconfig_rx_reconfig_busy			(from_rx_reconfig),
  .dp_rx_reconfig_rx_link_rate			(to_rx_reconfig[2:1]),		//dp_rx_reconfig_conduit_to_rx_reconfig
  .dp_rx_reconfig_rx_link_rate_8bits   (dp_rx_reconfig_link_rate_8bits),
  .dp_rx_reconfig_rx_reconfig_req			(to_rx_reconfig[0]),
  .dp_rx_reconfig_rx_reconfig_ack 			(1'b1),
  .dp_rx_vid_clk_clk    			(clk_vid),
  .dp_rx_video_out_rx_vid_data   			(vid_data),
  .dp_rx_video_out_rx_vid_sol    			(vid_sol),
  .dp_rx_video_out_rx_vid_eol    			(vid_eol),
  .dp_rx_video_out_rx_vid_sof    			(vid_sof),
  .dp_rx_video_out_rx_vid_eof    			(vid_eof),
  .dp_rx_video_out_rx_vid_locked 			(vid_lock),
  .dp_rx_video_out_rx_vid_valid  			(vid_valid),
  .dp_rx_stream_rx_stream_valid    			(rx0_stream_out_valid),
  .dp_rx_msa_conduit_rx_msa  			(rx_msa),
  .dp_rx_params_rx_lane_count     			(rx_lane_count),

  .dp_rx_ss_clk_clk           (clk_audio),
  .dp_rx_audio_rx_audio_valid         (audio_valid),
  .dp_rx_audio_rx_audio_mute          (audio_mute),
  .dp_rx_audio_rx_audio_infoframe     (),
  .dp_rx_audio_rx_audio_lpcm_data     (audio_data),

  // DisplayPort TX side
  
  .dp_tx_aux_tx_aux_in       			(AUX_TX_DRV_IN),
  .dp_tx_aux_tx_aux_out      			(AUX_TX_DRV_OUT),
  .dp_tx_aux_tx_aux_oe       			(AUX_TX_DRV_OE),
  .dp_tx_aux_tx_hpd          			(TX_HPD),
  .dp_tx_xcvr_interface_tx_parallel_data 		(to_gxb_tx[159:0]),		//dp_tx_gxb_conduit_to_gxb_tx
  .dp_tx_xcvr_interface_tx_std_clkout 		(from_gxb_tx[4:1]),		//dp_tx_gxb_conduit_from_gxb_tx
  .dp_tx_xcvr_interface_tx_pll_locked		(from_gxb_tx[0]),
  .dp_tx_xcvr_interface_tx_cal_busy		({4{tx_cal_busy}}),		//dp_tx_reconfig_conduit_from_tx_reconfig
  .dp_tx_reconfig_tx_link_rate			(to_tx_reconfig[3:2]),		//dp_tx_reconfig_conduit_to_tx_reconfig
  .dp_tx_reconfig_tx_link_rate_8bits   (dp_tx_reconfig_link_rate_8bits),
  .dp_tx_reconfig_tx_reconfig_req			(to_tx_reconfig[1]),
  .dp_tx_analog_reconfig_tx_vod			(to_tx_reconfig[11:4]),
  .dp_tx_analog_reconfig_tx_emp			(to_tx_reconfig[19:12]),
  .dp_tx_analog_reconfig_tx_analog_reconfig_req	(to_tx_reconfig[0]),
  .dp_tx_reconfig_tx_reconfig_ack 			(1'b1),
  .dp_tx_reconfig_tx_reconfig_busy			(from_tx_reconfig),
  .dp_tx_analog_reconfig_tx_analog_reconfig_ack 	(1'b1),
  .dp_tx_analog_reconfig_tx_analog_reconfig_busy	(from_tx_reconfig),
  .dp_tx_vid_clk_clk      			(clk_rec),
  .dp_tx_video_in_tx_vid_data     			(wid_data),
  .dp_tx_video_in_tx_vid_v_sync    			({wid_v,wid_v,wid_v,wid_v}),
  .dp_tx_video_in_tx_vid_h_sync    			({wid_h,wid_h,wid_h,wid_h}),
  .dp_tx_video_in_tx_vid_de       			({wid_de,wid_de,wid_de,wid_de}),
  .dp_tx_ss_clk_clk         (),
  .dp_tx_ss_ready          (),
  .dp_tx_ss_valid          (1'b0),
  .dp_tx_ss_data           (128'd0),
  .dp_tx_ss_startofpacket  (1'b0),
  .dp_tx_ss_endofpacket    (1'b0),

  .dp_tx_audio_clk_clk     (clk_audio),
  .dp_tx_audio_tx_audio_valid       (audio_valid),
  .dp_tx_audio_tx_audio_mute        (audio_mute),
  .dp_tx_audio_tx_audio_lpcm_data   (audio_data)
);

assign rx_link_clk = from_gxb_rx[168];
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
  .cal_busy_in        (1'b0),
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

bitec_reconfig_alt_av bitec_reconfig_alt_av_i
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
  .tx_vodemp_strobe       (to_tx_reconfig[0]),
  .tx_hdmi_en             (1'b0),
  .tx_xcvr_busy           (from_tx_reconfig),
  .tx_xcvr_reset          (tx_xcvr_reset),
  
  .rx_analogreset_in      (to_gxb_rx[7:4]),
  .rx_digitalreset_in     (to_gxb_rx[3:0]),
  .rx_analogreset         (rx_anares),
  .rx_digitalreset        (rx_digres)
);
  defparam  bitec_reconfig_alt_av_i.HDMI_CLKX2 = 1;
  defparam  bitec_reconfig_alt_av_i.RX_LANES = 4;
  defparam  bitec_reconfig_alt_av_i.TX_LANES = 4;

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

wire [3:0] rx_coreclkin = from_gxb_rx[171:168];

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
  
  .rx_is_lockedtoref  (from_gxb_rx[163:160]),
  .rx_is_lockedtodata (from_gxb_rx[167:164]),
  .rx_parallel_data   (from_gxb_rx[159:0]),
  .rx_std_clkout      (from_gxb_rx[171:168])
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

  .tx_parallel_data     (to_gxb_tx[159:0]),
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
assign user_led[0] =  ~vid_lock;
assign user_led[5:1] =  ~(rx_lane_count);
assign user_led[7:6] =  ~(rx_link_rate);


endmodule
