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
// The DisplayPort received image clock is recovered and output
// from the DisplayPort Transmitter. 
// Support for HBR (RX and TX) and all resolutions up to 1920 x 1200 (154 MHz)
//
// *********************************************************************

module cv_dp_demo
(
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
  mem_reset_n,
  RX_CAD,
  RX_ENA,
  TX_ENA,
  RX_HPD,
  AUX_TX_DRV_OUT,
  AUX_TX_DRV_OE,
  AUX_RX_DRV_OUT,
  AUX_RX_DRV_OE,
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
output wire mem_reset_n;
output wire RX_CAD;
output wire RX_ENA;
output wire TX_ENA;
output wire RX_HPD;
output wire AUX_TX_DRV_OUT;
output wire AUX_TX_DRV_OE;
output wire AUX_RX_DRV_OUT;
output wire AUX_RX_DRV_OE;
inout wire  SCL_CTL;
inout wire  SDA_CTL;
output wire [3:0] tx_serial_data;
output wire [7:0] user_led;

assign RX_CAD = 1'b0;
assign RX_ENA = 1'b1;
assign TX_ENA = 1'b1;
assign mem_reset_n = 1'b0;

wire clk_100 = clk100;
wire clk_135;
wire clk_16;
wire clk_vid;
wire clk_cntrl;
wire reset_in;
wire reset;
wire reset_n;
wire video_pll_locked;

assign reset_in = ~resetn;
assign reset = ~video_pll_locked;
assign reset_n = ~reset;

video_pll_cv video_pll_i
(
  .rst        (reset_in),
  .refclk     (clk_100),
  .outclk_0   (clk_vid),
  .outclk_1   (clk_16),
  .outclk_2   (clk_cntrl),
  .locked     (video_pll_locked)
);

xcvr_pll_cv xcvr_pll_i
(
  .refclk     (refclk2_qr1_p),
  .rst        (reset_in),
  .outclk_0   (clk_135),
  .locked     ()
);

reg clk_cal;
always @ (posedge clk100)
  clk_cal <= ~clk_cal;

// ----------------------
// Clock recovery module
// ----------------------

wire clk_rec;
wire [47:0] vid_data;
wire vid_valid;
wire vid_lock;
wire vid_sof,vid_eof;
wire vid_sol,vid_eol;
wire wid_reset;
wire [47:0] wid_data;
wire wid_h,wid_v,wid_de;
wire [3:0] rx_link_clk;
wire [1:0] rx_link_rate;
wire  [216:0] rx_msa;

bitec_clkrec bitec_clkrec_i
(
  .areset       (reset),
  .clk          (clk_cntrl),

  .vidin_clk    (clk_vid),
  .vidin_data   (vid_data),
  .vidin_valid  (vid_valid),
  .vidin_locked (vid_lock),
  .vidin_sof    (vid_sof),
  .vidin_eof    (vid_eof),
  .vidin_sol    (vid_sol),
  .vidin_eol    (vid_eol),

  .rx_link_clk  (rx_link_clk[0]),
  .rx_link_rate (rx_link_rate),
  .rx_msa       (rx_msa),
  
  .rec_clk      (clk_rec),
  
  .reset_out    (wid_reset),
  .vidout       (wid_data),
  .hsync        (wid_h),
  .vsync        (wid_v),
  .de           (wid_de)
);
  defparam bitec_clkrec_i.CLK_PERIOD_NS = 17;
  defparam bitec_clkrec_i.DEVICE_FAMILY = "Cyclone V";
  defparam bitec_clkrec_i.SYMBOLS_PER_CLOCK = 2;
  defparam  bitec_clkrec_i.BPP = 48;
  defparam  bitec_clkrec_i.FIXED_NVID = 0;
  defparam  bitec_clkrec_i.PIXELS_PER_CLOCK = 1;

// ----------------------
// DisplayPort subsystem
// ----------------------
wire rx_stream_out_valid;
wire [3:0] rx_set_locktodata;
wire [3:0] rx_set_locktoref;
wire [3:0] rx_std_bitslip;
wire [3:0] rx_is_lockedtoref;
wire [3:0] rx_is_lockedtodata;
wire [79:0] rx_parallel_data;
wire [79:0] tx_parallel_data;
wire tx_pll_locked;
wire [3:0] tx_std_clkout;

wire rx_reconfig_req;
wire rx_reconfig_ack;
wire rx_reconfig_busy;
wire [1:0] tx_link_rate;
wire [7:0] tx_link_rate_8bits;
wire [7:0] rx_link_rate_8bits;
wire tx_reconfig_req;
wire tx_reconfig_ack;
wire tx_reconfig_busy;
wire tx_analog_reconfig_req;
wire tx_analog_reconfig_ack;
wire tx_analog_reconfig_busy;
wire [7:0] tx_analog_reconfig_vod;
wire [7:0] tx_analog_reconfig_emp;
wire  rx_cal_busy_to_dp;
wire  tx_cal_busy_to_dp;
wire [3:0] rx_anares;
wire [3:0] rx_digres;
wire [4:0] rx_lane_count;

control control_i
(
  .clk_100_clk                (clk_100),
  .clk_16_clk                 (clk_16),
  .resetn_reset_n             (reset_n),
  .dp_clk_cal_clk     (clk_cal),
  
  .pio_0_external_connection_export   (~user_pb[0]),

  .oc_i2c_master_0_conduit_start_scl_pad_io (SCL_CTL),
  .oc_i2c_master_0_conduit_start_sda_pad_io (SDA_CTL),
  
  // DisplayPort RX side

  .dp_rx_aux_rx_aux_in       (AUX_RX_DRV_IN),
  .dp_rx_aux_rx_aux_out      (AUX_RX_DRV_OUT),
  .dp_rx_aux_rx_aux_oe       (AUX_RX_DRV_OE),
  .dp_rx_aux_rx_hpd          (RX_HPD),
  .dp_rx_aux_rx_cable_detect (~RX_SENSE_P),
  .dp_rx_aux_rx_pwr_detect   (RX_SENSE_N),

  .dp_rx_reconfig_conduit_rx_link_rate  (rx_link_rate),
  .dp_rx_reconfig_conduit_rx_link_rate_8bits  (rx_link_rate_8bits),
  .dp_rx_reconfig_conduit_rx_reconfig_req  (rx_reconfig_req),
  .dp_rx_reconfig_conduit_rx_reconfig_ack  (rx_reconfig_ack),
  .dp_rx_reconfig_conduit_rx_reconfig_busy  (rx_reconfig_busy),
  .dp_rx_gxb_conduit_rx_parallel_data  (rx_parallel_data),
  .dp_rx_gxb_conduit_rx_std_clkout  (rx_link_clk),
  .dp_rx_gxb_conduit_rx_is_lockedtoref  (rx_is_lockedtoref),
  .dp_rx_gxb_conduit_rx_is_lockedtodata  (rx_is_lockedtodata),
  .dp_rx_gxb_conduit_rx_bitslip  (rx_std_bitslip),
  .dp_rx_gxb_conduit_rx_cal_busy  ({rx_cal_busy_to_dp, rx_cal_busy_to_dp, rx_cal_busy_to_dp, rx_cal_busy_to_dp}),
  .dp_rx_gxb_conduit_rx_analogreset  (rx_anares),
  .dp_rx_gxb_conduit_rx_digitalreset  (rx_digres),
  .dp_rx_gxb_conduit_rx_set_locktoref  (rx_set_locktoref),
  .dp_rx_gxb_conduit_rx_set_locktodata  (rx_set_locktodata),
  .dp_rx_params_rx_lane_count     (rx_lane_count),

  .dp_rx_video_clk_clk    (clk_vid),
  .dp_rx_video_out_im_rx_vid_data   (vid_data),
  .dp_rx_video_out_im_rx_vid_sol    (vid_sol),
  .dp_rx_video_out_im_rx_vid_eol    (vid_eol),
  .dp_rx_video_out_im_rx_vid_sof    (vid_sof),
  .dp_rx_video_out_im_rx_vid_eof    (vid_eof),
  .dp_rx_video_out_im_rx_vid_locked (vid_lock),
  .dp_rx_video_out_im_rx_vid_valid  (vid_valid),

  .dp_rx_stream_out_1_valid    (rx_stream_out_valid),
  .dp_rx_msa_conduit_rx_msa  (rx_msa),

  // DisplayPort TX side
  
  .dp_tx_aux_tx_aux_in       (AUX_TX_DRV_IN),
  .dp_tx_aux_tx_aux_out      (AUX_TX_DRV_OUT),
  .dp_tx_aux_tx_aux_oe       (AUX_TX_DRV_OE),
  .dp_tx_aux_tx_hpd          (TX_HPD),

  .dp_tx_analog_reconfig_conduit_tx_analog_reconfig_req   (tx_analog_reconfig_req),
  .dp_tx_analog_reconfig_conduit_tx_analog_reconfig_ack   (tx_analog_reconfig_ack),
  .dp_tx_analog_reconfig_conduit_tx_analog_reconfig_busy   (tx_analog_reconfig_busy),
  .dp_tx_analog_reconfig_conduit_tx_vod   (tx_analog_reconfig_vod),
  .dp_tx_analog_reconfig_conduit_tx_emp   (tx_analog_reconfig_emp),
  .dp_tx_reconfig_conduit_tx_link_rate   (tx_link_rate),
  .dp_tx_reconfig_conduit_tx_link_rate_8bits   (tx_link_rate_8bits),
  .dp_tx_reconfig_conduit_tx_reconfig_req   (tx_reconfig_req),
  .dp_tx_reconfig_conduit_tx_reconfig_ack   (tx_reconfig_ack),
  .dp_tx_reconfig_conduit_tx_reconfig_busy   (tx_reconfig_busy),
  .dp_tx_gxb_conduit_tx_parallel_data   (tx_parallel_data),
  .dp_tx_gxb_conduit_tx_pll_powerdown   (),
  .dp_tx_gxb_conduit_tx_analogreset   (),
  .dp_tx_gxb_conduit_tx_digitalreset   (),
  .dp_tx_gxb_conduit_tx_cal_busy   ({tx_cal_busy_to_dp, tx_cal_busy_to_dp, tx_cal_busy_to_dp, tx_cal_busy_to_dp}),
  .dp_tx_gxb_conduit_tx_std_clkout   (tx_std_clkout),
  .dp_tx_gxb_conduit_tx_pll_locked   (tx_pll_locked),
  
  .dp_tx_video_clk_clk      (clk_rec),
  .dp_tx_video_in_tx_vid_data     (wid_data),
  .dp_tx_video_in_tx_vid_v_sync    (wid_v),
  .dp_tx_video_in_tx_vid_h_sync    (wid_h),
  .dp_tx_video_in_tx_vid_de       (wid_de)
);

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
wire  tx_cal_busy;
wire  rx_cal_busy;

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

assign rx_cal_busy_to_dp = reconfig_busy | rx_cal_busy;
assign tx_cal_busy_to_dp = reconfig_busy | tx_cal_busy;

// Instantiate the reconfig management FSM
reconfig_mgmt_hw_ctrl #(
  .DEVICE_FAMILY("Cyclone V"),
  .RX_LANES(4),
  .TX_LANES(4),
  .TX_PLLS(4)
) mgmt (
  .clk(clk_100),
  .reset(reset),

  .rx_reconfig_req(rx_reconfig_req),
  .rx_link_rate(rx_link_rate),
  .rx_reconfig_ack(rx_reconfig_ack),
  .rx_reconfig_busy(rx_reconfig_busy),

  .tx_reconfig_req(tx_reconfig_req),
  .tx_link_rate(tx_link_rate),
  .tx_reconfig_ack(tx_reconfig_ack),
  .tx_reconfig_busy(tx_reconfig_busy),

  .tx_analog_reconfig_req(tx_analog_reconfig_req),
  .vod(tx_analog_reconfig_vod),
  .emp(tx_analog_reconfig_emp),
  .tx_analog_reconfig_ack(tx_analog_reconfig_ack),
  .tx_analog_reconfig_busy(tx_analog_reconfig_busy),

  .mgmt_address(cfg_mgmt_addr),
  .mgmt_writedata(cfg_mgmt_wdata),
  .mgmt_write(cfg_mgmt_write),
  .mgmt_waitrequest(cfg_mgmt_waitreq),
  .reconfig_busy(reconfig_busy)
    );

wire [3:0] tx_analogreset;
wire [3:0] tx_digitalreset;

wire [3:0] tx_cal_busy_gxb;
wire tx_pll_powerdown;

gxb_reset gxb_reset_i
(
  .clock          (clk_100),
  .reset          (reset),
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

gxb_rx gxb_rx_i
(
  .rx_cdr_refclk      (clk_135),
  .rx_analogreset     (rx_anares),
  .rx_digitalreset    (rx_digres),
  .rx_serial_data     (rx_serial_data),
  .rx_set_locktodata  (rx_set_locktodata),
  .rx_set_locktoref   (rx_set_locktoref),
  .rx_std_bitslip     (rx_std_bitslip),
  .rx_std_coreclkin   (rx_link_clk),
  .rx_std_polinv      (4'b1111),

  .reconfig_from_xcvr (reconfig_from_gxb_rx),
  .reconfig_to_xcvr   (reconfig_to_gxb_rx),
  
  .rx_is_lockedtoref  (rx_is_lockedtoref),
  .rx_is_lockedtodata (rx_is_lockedtodata),
  .rx_parallel_data   (rx_parallel_data),
  .rx_std_clkout      (rx_link_clk)
);

wire [3:0] tx_coreclkin = {tx_std_clkout[0],tx_std_clkout[0],tx_std_clkout[0],tx_std_clkout[0]};

gxb_tx gxb_tx_i
(
  .tx_pll_refclk        (clk_135),
  .pll_powerdown        (tx_pll_powerdown),
  .tx_analogreset       (tx_analogreset),
  .tx_digitalreset      (tx_digitalreset),
  
  .reconfig_to_xcvr     (reconfig_to_gxb_tx),
  .reconfig_from_xcvr   (reconfig_from_gxb_tx),

  .tx_parallel_data     (tx_parallel_data),
  .tx_std_coreclkin     (tx_coreclkin),
  .tx_std_polinv        (4'b0000),
  
  .pll_locked           (tx_pll_locked),
  .tx_cal_busy          (tx_cal_busy_gxb),
  .tx_serial_data       (tx_serial_data),
  .tx_std_clkout        (tx_std_clkout)
);

assign user_led[0] =  ~vid_lock;
assign user_led[5:1] =  ~(rx_lane_count);
assign user_led[7:6] =  ~(rx_link_rate);



endmodule
