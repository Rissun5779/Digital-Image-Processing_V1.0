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
// Author         : $Author: Marco $ @ bitec-dsp.com
// Department     : 
// Date           : $Date: 2016-05-16 17:02:22 +0300 (Mon, 16 May 2016) $
// Revision       : $Revision: 2260 $
// URL            : $URL: svn://nas-bitec-fi/dp/trunk/demo/bitec_reconfig_alt_a10.v $
// *********************************************************************
// Description
// 
// This module implements Altera RX/TX transceivers reconfiguration
// for Altera Arria 10 GX ES2, rev.D1 and ES3:
// - single 135MHz clock input for 1620,2700,5400 and 8100 Mbps
// - Duplex mode used if both RX and TX are present
// - TXPLL is a regular FPLL (not an ATXPLL)
// - FPLL "embedded debug features" must be enabled
// - XCVR "embedded debug features" must be enabled
//
// Supported link rates:
//  0 1.62G   RBR
//  1 2.7G    HBR
//  2 5.4G    HBR2
//  3 6.75G
//  4 8.1G    HBR3
//
// *********************************************************************

// synthesis translate_off
`timescale 1ns / 1ns
// synthesis translate_on
`default_nettype none

module bitec_reconfig_alt_a10 
#(
  parameter [3:0] TX_LANES = 4,
  parameter [3:0] RX_LANES = 4,
  parameter [2:0] TX_RATES_NUM = 3, // Number of TX link rates (0: no TX support, 1: up to RBR, 2: up to HBR, etc.)
  parameter [2:0] RX_RATES_NUM = 3, // Number of RX link rates (0: no TX support, 1: up to RBR, 2: up to HBR, etc.)
  parameter A10_ES2 = 0             // 1 = 10AX115S2F45I2SGE2 device (ES2 silicon) 0 = any other device silicon
)
(
  input  wire clk,                        // The same clock driving the reconfig controllers
  input  wire reset,                      // The same reset driving the reconfig controllers

  input  wire [7:0] rx_link_rate,         // Link rate in multiples of 270 Mbps
  input  wire [(RX_LANES*2)-1:0] rx_vod,  // Voltage swing level, 0 to 3
  input  wire [(RX_LANES*2)-1:0] rx_emp,  // Pre-emphasis level, 0 to 3
  input  wire rx_link_rate_strobe,        // Assert for at least 1 clk cycle when a new rx_link_rate must be used
  input  wire rx_vodemp_strobe,           // Assert for at least 1 clk cycle when new VOD/EMP values must be used
  output wire rx_xcvr_busy,               // Asserted during RX reconfig and calibration time
  output reg rx_xcvr_reset,
  
  input  wire [7:0] tx_link_rate,         // Link rate in multiples of 270 Mbps
  input  wire [(TX_LANES*2)-1:0] tx_vod,  // Voltage swing level, 0 to 3
  input  wire [(TX_LANES*2)-1:0] tx_emp,  // Pre-emphasis level, 0 to 3
  input  wire tx_link_rate_strobe,        // Assert for at least 1 clk cycle when a new tx_link_rate must be used
  input  wire tx_vodemp_strobe,           // Assert for at least 1 clk cycle when new VOD/EMP values must be used
  output wire tx_xcvr_busy,               // Asserted during TX reconfig and calibration time
  output reg tx_xcvr_reset,              // Asserted when the TX XCVR must be reset

  // XCVR reconfig controller interface
  input  wire rx_analogreset_ack,
  output wire [1:0] rx_mgmt_chnum,
  output wire [9:0] rx_mgmt_address,
  output wire [31:0] rx_mgmt_writedata,
  input  wire [31:0] rx_mgmt_readdata,
  output wire rx_mgmt_write,
  output wire rx_mgmt_read,
  input  wire rx_mgmt_waitrequest,

  input  wire tx_analogreset_ack,
  output wire [1:0] tx_mgmt_chnum,
  output wire [9:0] tx_mgmt_address,
  output wire [31:0] tx_mgmt_writedata,
  input  wire [31:0] tx_mgmt_readdata,
  output wire tx_mgmt_write,
  output wire tx_mgmt_read,
  input  wire tx_mgmt_waitrequest,

  // TX PLL reconfig controller interface
  output wire [9:0] txpll_mgmt_address,
  output wire [31:0] txpll_mgmt_writedata,
  input  wire [31:0] txpll_mgmt_readdata,
  output wire txpll_mgmt_write,
  output wire txpll_mgmt_read,
  input  wire txpll_mgmt_waitrequest,

  input  wire rx_xcvr_cal_busy,
  input  wire tx_xcvr_cal_busy,
  input  wire tx_pll_cal_busy
);

// main FSM states
localparam  FSM_CNF_TXPLL1              = 6'd0,
            FSM_CNF_TXPLL2              = 6'd1,
            FSM_CAL_TXPLL1              = 6'd2,
            FSM_CAL_TXPLL2              = 6'd3,
            FSM_CAL_TXPLL3              = 6'd4,
            FSM_CAL_TXPLL4              = 6'd5,
            FSM_MEM_TXPLL1              = 6'd6,
            FSM_MEM_TXPLL2              = 6'd7,
            FSM_CNF_RXGXB1              = 6'd8,
            FSM_CNF_RXGXB2              = 6'd9,
            FSM_CNF_RXGXB3              = 6'd10,
            FSM_CNF_RXGXB_NEXTLANE      = 6'd11,
            FSM_CAL_RXGXB1              = 6'd12,
            FSM_CAL_RXGXB2              = 6'd13,
            FSM_CAL_RXGXB3              = 6'd14,
            FSM_CAL_RXGXB4              = 6'd15,
            FSM_CAL_RXGXB5              = 6'd16,
            FSM_MEM_RXGXB               = 6'd17,
            FSM_CAL_RXGXB_NEXTLANE      = 6'd18,
            FSM_IDLE                    = 6'd19,
            FSM_START_RX_LINKRATE       = 6'd20,
            FSM_START_RX_ANALOG         = 6'd21,
            FSM_START_TX_LINKRATE       = 6'd22,
            FSM_START_TX_ANALOG         = 6'd23,
            FSM_FEAT_RECONFIG           = 6'd24,
            FSM_WAIT_FOR_BUSY_LOW       = 6'd25,
            FSM_NEXT_RX_LRATE_FEATURE   = 6'd26,
            FSM_NEXT_RX_ANALOG_FEATURE  = 6'd27,
            FSM_NEXT_TX_LRATE_FEATURE   = 6'd28,
            FSM_NEXT_TX_ANALOG_FEATURE  = 6'd29,
            FSM_END_RECONFIG            = 6'd30,
            FSM_NEXT_LANE               = 6'd31,
            FSM_END                     = 6'd32;

// Feature index
localparam  FEAT_RX_GAIN1   = 5'd0,
            FEAT_RX_GAIN2   = 5'd1,
            FEAT_RX_GAIN3   = 5'd2,
            FEAT_RX_GAIN4   = 5'd3,
            FEAT_RX_REFCLK1 = 5'd4,
            FEAT_RX_REFCLK2 = 5'd5,
            FEAT_RX_REFCLK3 = 5'd6,
            FEAT_RX_REFCLK4 = 5'd7,
            FEAT_RX_REFCLK5 = 5'd8,
            FEAT_TX_VOD     = 5'd9,
            FEAT_TX_EMP1    = 5'd10,
            FEAT_TX_EMP2    = 5'd11,
            FEAT_TX_EMP3    = 5'd12,
            FEAT_TX_EMP4    = 5'd13,
            FEAT_TX_REFCLK1 = 5'd14,
            FEAT_TX_REFCLK2 = 5'd15,
            FEAT_TX_REFCLK3 = 5'd16;

// XCVR Reconfiguration controller register addresses
localparam  ADDR_CALIB                                  = 10'h100,
            ADDR_PRE_EMP_SWITCHING_CTRL_1ST_POST_TAP    = 10'h105,
            ADDR_PRE_EMP_SWITCHING_CTRL_2ND_POST_TAP    = 10'h106,
            ADDR_PRE_EMP_SWITCHING_CTRL_PRE_TAP_1T      = 10'h107,
            ADDR_PRE_EMP_SWITCHING_CTRL_PRE_TAP_2T      = 10'h108,
            ADDR_VOD_OUTPUT_SWING_CTRL                  = 10'h109,
            ADDR_DCGAIN1                                = 10'h11A,
            ADDR_DCGAIN2                                = 10'h11C,
            ADDR_L_PFD_COUNTER                          = 10'h13a,
            ADDR_L_PD_COUNTER                           = 10'h13a,
            ADDR_M_COUNTER                              = 10'h13b,
            ADDR_PPM_SEL                                = 10'h00e,
            ADDR_VGA                                    = 10'h160,
            ADDR_CP_CALIB                               = 10'h166,
            ADDR_ACGAIN                                 = 10'h167;

// XCVR Reconfiguration controller register masks
localparam  MASK_CALIB                                  = 32'h0000_0006,
            MASK_PRE_EMP_SWITCHING_CTRL_1ST_POST_TAP    = 32'h0000_005f,
            MASK_PRE_EMP_SWITCHING_CTRL_2ND_POST_TAP    = 32'h0000_002f,
            MASK_PRE_EMP_SWITCHING_CTRL_PRE_TAP_1T      = 32'h0000_003f,
            MASK_PRE_EMP_SWITCHING_CTRL_PRE_TAP_2T      = 32'h0000_0017,
            MASK_VOD_OUTPUT_SWING_CTRL                  = 32'h0000_001f,
            MASK_DCGAIN1                                = 32'h0000_00ff,
            MASK_DCGAIN2                                = 32'h0000_000f,
            MASK_L_PFD_COUNTER                          = 32'h0000_0007,
            MASK_L_PD_COUNTER                           = 32'h0000_0038,
            MASK_M_COUNTER                              = 32'h0000_00ff,
            MASK_PPM_SEL                                = 32'h0000_00fc,
            MASK_VGA                                    = 10'h0000_000e,
            MASK_CP_CALIB                               = 32'h0000_0080,
            MASK_ACGAIN                                 = 32'h0000_003e;

// TXPLL Reconfiguration controller register addresses
localparam  ADDR_TXPLL_CALIB                           = 10'h100,  
            ADDR_TXPLL_M_CNT                           = 10'h12b,
            ADDR_TXPLL_L_CNT                           = 10'h12c;

// TXPLL Reconfiguration controller register masks
localparam  MASK_TXPLL_CALIB                           = 32'h0000_0002,
            MASK_TXPLL_M_CNT                           = 32'h0000_00ff,
            MASK_TXPLL_L_CNT                           = 32'h0000_0006;

// RXGXB linkrate-dependent register values
wire [2:0] COUNTER_L_PFD [4:0];
wire [2:0] COUNTER_L_PD [4:0];
wire [7:0] COUNTER_M [4:0];
wire [5:0] PPM_SEL [4:0];
assign COUNTER_L_PFD[0] = A10_ES2 ? 3'h3  : 3'h3;  // 1.62G
assign COUNTER_L_PFD[1] = A10_ES2 ? 3'h3  : 3'h3;  // 2.7G
assign COUNTER_L_PFD[2] = A10_ES2 ? 3'h4  : 3'h3;  // 5.4G
assign COUNTER_L_PFD[3] = A10_ES2 ? 3'h4  : 3'h3;  // 6.75G
assign COUNTER_L_PFD[4] = A10_ES2 ? 3'h3  : 3'h3;  // 8.1G
assign COUNTER_L_PD[0]  = A10_ES2 ? 3'h5  : 3'h5;  // 1.62G
assign COUNTER_L_PD[1]  = A10_ES2 ? 3'h4  : 3'h4;  // 2.7G
assign COUNTER_L_PD[2]  = A10_ES2 ? 3'h4  : 3'h3;  // 5.4G
assign COUNTER_L_PD[3]  = A10_ES2 ? 3'h4  : 3'h3;  // 6.75G
assign COUNTER_L_PD[4]  = A10_ES2 ? 3'h3  : 3'h3;  // 8.1G
assign COUNTER_M[0]     = A10_ES2 ? 8'h18 : 8'h18; // 1.62G
assign COUNTER_M[1]     = A10_ES2 ? 8'h14 : 8'h14; // 2.7G
assign COUNTER_M[2]     = A10_ES2 ? 8'h14 : 8'h14; // 5.4G
assign COUNTER_M[3]     = A10_ES2 ? 8'h19 : 8'h19; // 6.75G
assign COUNTER_M[4]     = A10_ES2 ? 8'h1e : 8'h1e; // 8.1G
assign PPM_SEL[0]       = 6'h21; // 1.62G
assign PPM_SEL[1]       = 6'h21; // 2.7G
assign PPM_SEL[2]       = 6'h21; // 5.4G
assign PPM_SEL[3]       = 6'h21; // 6.75G
assign PPM_SEL[4]       = 6'h21; // 8.1G

// TXPLL linkrate-dependent register values
wire [1:0] L_COUNTER_FPLL [4:0];
wire [7:0] M_COUNTER_FPLL [4:0];
assign L_COUNTER_FPLL[0] = A10_ES2 ? 2'h3  : 2'h2;  // 1.62G
assign L_COUNTER_FPLL[1] = A10_ES2 ? 2'h2  : 2'h2;  // 2.7G
assign L_COUNTER_FPLL[2] = A10_ES2 ? 2'h1  : 2'h1;  // 5.4G
assign L_COUNTER_FPLL[3] = A10_ES2 ? 2'h1  : 2'h0;  // 6.75G
assign L_COUNTER_FPLL[4] = A10_ES2 ? 2'h0  : 2'h0;  // 8.1G
assign M_COUNTER_FPLL[0] = A10_ES2 ? 8'h30 : 8'h18; // 1.62G
assign M_COUNTER_FPLL[1] = A10_ES2 ? 8'h28 : 8'h28; // 2.7G
assign M_COUNTER_FPLL[2] = A10_ES2 ? 8'h28 : 8'h28; // 5.4G
assign M_COUNTER_FPLL[3] = A10_ES2 ? 8'h32 : 8'h19; // 6.75G
assign M_COUNTER_FPLL[4] = A10_ES2 ? 8'h1e : 8'h1e; // 8.1G

reg [5:0] fsm_state; // Main FSM state
reg [4:0] feature_idx; // Feature index

// Synchronize asynchronous rx_analogreset_ack
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON; -name SDC_STATEMENT \"set_false_path -to [get_keepers {*bitec_reconfig_alt_a10:*|rx_reset_ack_r}]\" "} *) reg rx_reset_ack_r /* synopsys translate_off */ = 1'b1 /* synopsys translate_on */;
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON"} *) reg rx_reset_ack_rr /* synopsys translate_off */ = 1'b1 /* synopsys translate_on */;
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON"} *) reg rx_reset_ack_rrr /* synopsys translate_off */ = 1'b1 /* synopsys translate_on */;
always @(posedge clk or posedge reset)
  if (reset) 
    {rx_reset_ack_r, rx_reset_ack_rr, rx_reset_ack_rrr} <= 3'b000;
  else
    {rx_reset_ack_r, rx_reset_ack_rr, rx_reset_ack_rrr} <= {rx_analogreset_ack, rx_reset_ack_r, rx_reset_ack_rr};

// Synchronize asynchronous tx_analogreset_ack
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON; -name SDC_STATEMENT \"set_false_path -to [get_keepers {*bitec_reconfig_alt_a10:*|tx_reset_ack_r}]\" "} *) reg tx_reset_ack_r /* synopsys translate_off */ = 1'b1 /* synopsys translate_on */;
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON"} *) reg tx_reset_ack_rr /* synopsys translate_off */ = 1'b1 /* synopsys translate_on */;
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON"} *) reg tx_reset_ack_rrr /* synopsys translate_off */ = 1'b1 /* synopsys translate_on */;
always @(posedge clk or posedge reset)
  if (reset) 
    {tx_reset_ack_r, tx_reset_ack_rr, tx_reset_ack_rrr} <= 3'b000;
  else
    {tx_reset_ack_r, tx_reset_ack_rr, tx_reset_ack_rrr} <= {tx_analogreset_ack, tx_reset_ack_r, tx_reset_ack_rr};

// VOD & EMP mapped to the TX XCVR
wire [TX_LANES*5-1:0] tx_vod_mapped;
wire [TX_LANES*6-1:0] tx_emp_mapped;   

// Generate mapping tables for each lane
generate 
begin      
  genvar tx_lane;
  for (tx_lane=0; tx_lane < TX_LANES; tx_lane = tx_lane + 1) 
  begin:txlane
    tx_analog_mappings tx_analog_mappings_i
    (
      .vod                  (tx_vod[(tx_lane*2) +:2]), 
      .pree                 (tx_emp[(tx_lane*2) +:2]),
      .out_vod              (tx_vod_mapped[(tx_lane*5) +:5]), 
      .out_pree_post_tap1   (tx_emp_mapped[(tx_lane*6) +:6])
    );
  end // for
end 
endgenerate

// Gains required by the RX XCVR
// DC gain: 12 bits
// AC gain: 5 bits
// VGA:     3 bits
wire [RX_LANES*20-1:0] rx_gains_mapped;

// Generate mapping tables for each RX lane
wire [2:0] rx_mapped_linkrate;
generate 
begin      
  genvar rx_lane;
  for (rx_lane=0; rx_lane < RX_LANES; rx_lane = rx_lane + 1) 
  begin:rxlane
    rx_analog_mappings rx_analog_mappings_i
    (
      .linkrate  (rx_mapped_linkrate),
      .vod       (rx_vod[(rx_lane*2) +:2]), 
      .pree      (rx_emp[(rx_lane*2) +:2]),
      .out_dc    (rx_gains_mapped[rx_lane*20   +:12]), 
      .out_ac    (rx_gains_mapped[rx_lane*20+12 +:5]),
      .out_vga   (rx_gains_mapped[rx_lane*20+17 +:3])
    );
  end // for
end 
endgenerate


//-------------------
// Changes detection
//-------------------

reg [2:0] rx_link_rate_strobe_d,tx_link_rate_strobe_d,tx_vodemp_strobe_d,rx_vodemp_strobe_d;
reg rx_new_linkrate; // Asserted when rx_link_rate_strobe is detected
reg tx_new_linkrate; // Asserted when tx_link_rate_strobe is detected
reg tx_new_analog;   // Asserted when tx_vodemp_strobe is detected
reg rx_new_analog;   // Asserted when rx_vodemp_strobe is detected

always @ (posedge clk or posedge reset) 
begin
  if(reset) 
  begin
    rx_link_rate_strobe_d <= 3'h0;
    tx_link_rate_strobe_d <= 3'h0;
    tx_vodemp_strobe_d <= 3'h0;
    rx_vodemp_strobe_d <= 3'h0;
    rx_xcvr_reset <= 1'b0;
    tx_xcvr_reset <= 1'b0;
    rx_new_linkrate <= 1'b0;
    tx_new_linkrate <= 1'b0;
    tx_new_analog <= 1'b0;
    rx_new_analog <= 1'b0;
  end
  else
  begin
    rx_link_rate_strobe_d <= {rx_link_rate_strobe_d[1:0],rx_link_rate_strobe};
    tx_link_rate_strobe_d <= {tx_link_rate_strobe_d[1:0],tx_link_rate_strobe};
    tx_vodemp_strobe_d <= {tx_vodemp_strobe_d[1:0],tx_vodemp_strobe};
    rx_vodemp_strobe_d <= {rx_vodemp_strobe_d[1:0],rx_vodemp_strobe};
    rx_xcvr_reset <= (fsm_state == FSM_END) ? 1'b0 : (rx_new_linkrate ?  1'b1 : rx_xcvr_reset);
    tx_xcvr_reset <= (fsm_state == FSM_END) ? 1'b0 : (tx_new_linkrate ?  1'b1 : (tx_new_analog ? 1'b1 : tx_xcvr_reset));
    rx_new_linkrate <= rx_new_linkrate ? ~(fsm_state == FSM_START_RX_LINKRATE) : (~rx_link_rate_strobe_d[2] & rx_link_rate_strobe_d[1]);
    tx_new_linkrate <= tx_new_linkrate ? ~(fsm_state == FSM_START_TX_LINKRATE) : (~tx_link_rate_strobe_d[2] & tx_link_rate_strobe_d[1]);
    tx_new_analog <= tx_new_analog ? ~(fsm_state == FSM_START_TX_ANALOG) : (~tx_vodemp_strobe_d[2] & tx_vodemp_strobe_d[1]);
    rx_new_analog <= rx_new_analog ? ~(fsm_state == FSM_START_RX_ANALOG) : (~rx_vodemp_strobe_d[2] & rx_vodemp_strobe_d[1]);
  end
end

//----------
// Main FSM
//----------

reg [TX_LANES*5-1:0] tx_vod_mem;
reg [TX_LANES*6-1:0] tx_emp_mem;
reg [RX_LANES*20-1:0] rx_gains_mem;
reg [2:0] tx_link_rate_mem;
reg [2:0] rx_link_rate_mem;
reg [1:0] lane_idx; // Configured lane index (0-3)
reg [2:0] write_cnt; // Write operations counter

reg rcnf_reconfig;      // Asserted to start a XCVR single item reconfig with the values defined below
reg [9:0] rcnf_address; // Reconfiguration address
reg [31:0] rcnf_data;   // Reconfiguration data value
reg [31:0] rcnf_mask;   // Reconfiguration data mask
reg rcnf_req_cbus;      // Asserted to request access to Altera internal config bus
reg rcnf_rel_cbus;      // Asserted to release Altera internal config bus
reg rcnf_wcalib;        // Asserted to wait for calibration completion
reg rcnf_scalib;        // Asserted to save linkrate related calibration results
reg rcnf_lcalib;        // Asserted to load back linkrate related calibration results
wire rcnf_busy;

reg rx_lrate_busy;  // Asserted when RX linkrate changes are being performed
reg tx_lrate_busy;  // Asserted when TX linkrate changes are being performed
reg tx_analog_busy; // Asserted when TX analog changes are being performed
reg rx_analog_busy; // Asserted when RX analog changes are being performed
wire rx_cal_busy;
wire tx_cal_busy;

assign rx_cal_busy = rx_xcvr_cal_busy;
assign tx_cal_busy = tx_pll_cal_busy | tx_xcvr_cal_busy;
assign rx_xcvr_busy = rx_lrate_busy | rx_cal_busy | rx_analog_busy;
assign tx_xcvr_busy = tx_lrate_busy | tx_cal_busy | tx_analog_busy;

always @ (posedge clk or posedge reset) 
begin
  if(reset) 
  begin
    fsm_state <= FSM_CNF_TXPLL1;
    tx_vod_mem <= 0;
    tx_emp_mem <= 0;
    rx_gains_mem <= 0;
    tx_link_rate_mem <= 3'h0;
    rx_link_rate_mem <= 3'h0;
    
    rcnf_req_cbus <= 1'b0;
    rcnf_rel_cbus <= 1'b0;
    rcnf_wcalib <= 1'b0;
    rcnf_scalib <= 1'b0;
    rcnf_lcalib <= 1'b0;
    rcnf_reconfig <= 1'b0;
    rcnf_address <= 10'h0;
    rcnf_data <= 32'h0;
    rcnf_mask <= 32'h0;

    feature_idx <= FEAT_RX_REFCLK1;
    write_cnt <= 3'h0;
    lane_idx <= 2'h0;
    rx_lrate_busy <= 1'b0;
    tx_lrate_busy <= 1'b0;
    tx_analog_busy <= 1'b0;
    rx_analog_busy <= 1'b0;
  end
  else
  begin
  
    rcnf_req_cbus <= 1'b0;
    rcnf_rel_cbus <= 1'b0;
    rcnf_wcalib <= 1'b0;
    rcnf_scalib <= 1'b0;
    rcnf_lcalib <= 1'b0;
    rcnf_reconfig <= 1'b0;

    case(fsm_state)
    
      FSM_CNF_TXPLL1: // Set the TXPLL to tx_link_rate_mem link rate
        if(tx_link_rate_mem < TX_RATES_NUM[1:0])
        begin
          if(~rx_cal_busy & ~tx_cal_busy)
          begin
            tx_lrate_busy <= 1'b1;
            rcnf_address <= ADDR_TXPLL_M_CNT;
            rcnf_mask <= MASK_TXPLL_M_CNT;
            rcnf_data <= {24'd0,M_COUNTER_FPLL[tx_link_rate_mem]};
            rcnf_reconfig <= 1'b1;
            fsm_state <= FSM_CNF_TXPLL2;
          end
        end
        else
        begin
          tx_lrate_busy <= 1'b0;
          fsm_state <= FSM_CNF_RXGXB1;
        end
      
      FSM_CNF_TXPLL2: // Set the TXPLL to tx_link_rate_mem link rate
        if(!rcnf_busy) 
        begin
          rcnf_address <= ADDR_TXPLL_L_CNT;
          rcnf_mask <= MASK_TXPLL_L_CNT;
          rcnf_data <= {29'd0,L_COUNTER_FPLL[tx_link_rate_mem],1'b0};
          rcnf_reconfig <= 1'b1;
          fsm_state <= FSM_CAL_TXPLL1;
        end

      FSM_CAL_TXPLL1: // Get access to TXPLL config bus
        if(!rcnf_busy) 
        begin
          rcnf_req_cbus <= 1'b1;
          fsm_state <= FSM_CAL_TXPLL2;
        end

      FSM_CAL_TXPLL2: // Calibrate TXPLL
        if(!rcnf_busy) 
        begin
          rcnf_address <= ADDR_TXPLL_CALIB;
          rcnf_mask <= MASK_TXPLL_CALIB;
          rcnf_data <= 32'h2;
          rcnf_reconfig <= 1'b1;
          fsm_state <= FSM_CAL_TXPLL3;
        end

      FSM_CAL_TXPLL3: // Release TXPLL config bus
        if(!rcnf_busy) 
        begin
          rcnf_rel_cbus <= 1'b1;
          fsm_state <= FSM_CAL_TXPLL4;
        end

      FSM_CAL_TXPLL4: // Wait for TXPLL calibration end
        if(!rcnf_busy) 
        begin
          rcnf_wcalib <= 1'b1;
          fsm_state <= FSM_MEM_TXPLL1;
        end

      FSM_MEM_TXPLL1: // Store TXPLL link rate related calibration results
        if(!rcnf_busy) 
        begin
          rcnf_scalib <= 1'b1;
          fsm_state <= FSM_MEM_TXPLL2;
        end

      FSM_MEM_TXPLL2: // Goto next link rate
        if(!rcnf_busy) 
        begin
          tx_link_rate_mem <= tx_link_rate_mem + 1'd1;
          fsm_state <= FSM_CNF_TXPLL1;
        end

      FSM_CNF_RXGXB1: // Set the RXGXB to rx_link_rate_mem link rate
        if(rx_link_rate_mem < RX_RATES_NUM)
        begin
          if(~rx_cal_busy & ~tx_cal_busy)
          begin
            rx_lrate_busy <= 1'b1;
            rcnf_address <= ADDR_L_PFD_COUNTER;
            rcnf_mask <= MASK_L_PFD_COUNTER;
            rcnf_data <= {29'd0,COUNTER_L_PFD[rx_link_rate_mem]};
            rcnf_reconfig <= 1'b1;
            fsm_state <= FSM_CNF_RXGXB2;
          end
        end
        else
        begin
          rx_lrate_busy <= 1'b0;
          fsm_state <= FSM_IDLE;
        end

      FSM_CNF_RXGXB2: // Set the RXGXB to rx_link_rate_mem link rate
        if(!rcnf_busy) 
        begin
          rcnf_address <= ADDR_L_PD_COUNTER;
          rcnf_mask <= MASK_L_PD_COUNTER;
          rcnf_data <= {26'd0,COUNTER_L_PD[rx_link_rate_mem],3'd0};
          rcnf_reconfig <= 1'b1;
          fsm_state <= FSM_CNF_RXGXB3;
        end

      FSM_CNF_RXGXB3: // Set the RXGXB to rx_link_rate_mem link rate
        if(!rcnf_busy) 
        begin
          rcnf_address <= ADDR_M_COUNTER;
          rcnf_mask <= MASK_M_COUNTER;
          rcnf_data <= {24'd0,COUNTER_M[rx_link_rate_mem]};
          rcnf_reconfig <= 1'b1;
          fsm_state <= FSM_CNF_RXGXB_NEXTLANE;
        end
        
      FSM_CNF_RXGXB_NEXTLANE:
        if(!rcnf_busy) 
        begin
          if(lane_idx + 1'd1 < RX_LANES)
          begin
            // Configure next RX lane
            lane_idx <= lane_idx + 2'd1;
            fsm_state <= FSM_CNF_RXGXB1;
          end
          else
          begin
            lane_idx <= 2'd0;
            fsm_state <= FSM_CAL_RXGXB1;
          end
        end      

      FSM_CAL_RXGXB1: // Get access to RXGXB config bus
        if(!rcnf_busy) 
        begin
          rcnf_req_cbus <= 1'b1;
          fsm_state <= FSM_CAL_RXGXB2;
        end

      FSM_CAL_RXGXB2: // Calibrate RXGXB
        if(!rcnf_busy) 
        begin
          rcnf_address <= ADDR_CALIB;
          rcnf_mask <= MASK_CALIB;
          rcnf_data <= 32'h6; // Recalibrate CDR and offset cancellation
          rcnf_reconfig <= 1'b1;
          fsm_state <= FSM_CAL_RXGXB3;
        end

      FSM_CAL_RXGXB3: // To indicate the cal code that this is a new chgpmp current request and to calibrate based off of that initial value
        if(!rcnf_busy) 
        begin
          rcnf_address <= ADDR_CP_CALIB;
          rcnf_mask <= MASK_CP_CALIB;
          rcnf_data <= {24'd0,1'd0,7'd0};
          rcnf_reconfig <= 1'b1;
          fsm_state <= FSM_CAL_RXGXB4;
        end

      FSM_CAL_RXGXB4: // Release RXGXB config bus
        if(!rcnf_busy) 
        begin
          rcnf_rel_cbus <= 1'b1;
          fsm_state <= FSM_CAL_RXGXB5;
        end

      FSM_CAL_RXGXB5: // Wait for RXGXB calibration end
        if(!rcnf_busy) 
        begin
          rcnf_wcalib <= 1'b1;
          fsm_state <= FSM_MEM_RXGXB;
        end

      FSM_MEM_RXGXB: // Store RXGXB link rate related calibration results
        if(!rcnf_busy) 
        begin
          rcnf_scalib <= 1'b1;
          fsm_state <= FSM_CAL_RXGXB_NEXTLANE;
        end

      FSM_CAL_RXGXB_NEXTLANE:
        if(!rcnf_busy) 
        begin
          if(lane_idx + 1'd1 < RX_LANES)
          begin
            // Calibrate next RX lane
            lane_idx <= lane_idx + 2'd1;
            fsm_state <= FSM_CAL_RXGXB1;
          end
          else
          begin
            // Goto next link rate
            lane_idx <= 2'd0;
            rx_link_rate_mem <= rx_link_rate_mem + 1'd1;
            fsm_state <= FSM_CNF_RXGXB1;
          end
        end      

      FSM_IDLE: 
      begin
        write_cnt <= 3'h0;
        lane_idx <= 2'h0;

        if(~rx_xcvr_busy & ~tx_xcvr_busy)
        begin
          // Start a reconfig if either RX or TX requests it
          // (RX has precedence, do not serve RX and TX at the same time)
          if(rx_new_linkrate & rx_reset_ack_rrr)
          begin
            rx_lrate_busy  <= 1'b1;
            fsm_state <= FSM_START_RX_LINKRATE;
            if(rx_link_rate == 8'h06)
              rx_link_rate_mem <= 3'd0; // RBR
            else if(rx_link_rate == 8'h0a)
              rx_link_rate_mem <= 3'd1; // HBR
            else if(rx_link_rate == 8'h14)
              rx_link_rate_mem <= 3'd2; // HBR2
            else if(rx_link_rate == 8'h19)
              rx_link_rate_mem <= 3'd3; // 6.75G
            else if(rx_link_rate == 8'h1e)
              rx_link_rate_mem <= 3'd4; // HBR3
            else
            begin
              // Unsupported link rate
              rx_lrate_busy  <= 1'b0;
              fsm_state <= FSM_IDLE;
            end
          end
          else if(rx_new_analog & rx_reset_ack_rrr)
          begin
            rx_gains_mem <= rx_gains_mapped;
            rx_analog_busy  <= 1'b1;
            rcnf_req_cbus <= 1'b1; // For RX analog reconfiguration, request the control bus
            fsm_state <= FSM_START_RX_ANALOG;
          end
          else if(tx_new_linkrate & tx_reset_ack_rrr)
          begin
            tx_lrate_busy  <= 1'b1;
            fsm_state <= FSM_START_TX_LINKRATE;
            if(tx_link_rate == 8'h06)
              tx_link_rate_mem <= 3'd0; // RBR
            else if(tx_link_rate == 8'h0a)
              tx_link_rate_mem <= 3'd1; // HBR
            else if(tx_link_rate == 8'h14)
              tx_link_rate_mem <= 3'd2; // HBR2
            else if(tx_link_rate == 8'h19)
              tx_link_rate_mem <= 3'd3; // 6.75G
            else if(tx_link_rate == 8'h1e)
              tx_link_rate_mem <= 3'd4; // HBR3
            else
            begin
              // Unsupported link rate
              tx_lrate_busy  <= 1'b0;
              fsm_state <= FSM_IDLE;
            end
          end
          else if(tx_new_analog & tx_reset_ack_rrr)
          begin
            tx_vod_mem <= tx_vod_mapped;
            tx_emp_mem <= tx_emp_mapped;
            tx_analog_busy  <= 1'b1;
            rcnf_req_cbus <= 1'b1; // For TX analog reconfiguration, request the control bus
            fsm_state <= FSM_START_TX_ANALOG;
          end
        end
      end

      FSM_START_RX_LINKRATE: // Start RX linkrate reconfig
      begin
        feature_idx <= FEAT_RX_REFCLK1; // Start programming from this feature
        if(!rcnf_busy) 
          fsm_state <= FSM_FEAT_RECONFIG;
      end

      FSM_START_RX_ANALOG: // Start RX analog reconfig
      begin
        feature_idx <= FEAT_RX_GAIN1; // Start programming from this feature
        if(!rcnf_busy) 
          fsm_state <= FSM_FEAT_RECONFIG;
      end
      
      FSM_START_TX_LINKRATE: // Start TX linkrate reconfig
      begin
        feature_idx <= FEAT_TX_REFCLK1; // Start programming from this feature
        if(!rcnf_busy) 
          fsm_state <= FSM_FEAT_RECONFIG;
      end
        
      FSM_START_TX_ANALOG: // Start TX analog reconfig
      begin
        feature_idx <= FEAT_TX_VOD; // Start programming from this feature
        if(!rcnf_busy) 
          fsm_state <= FSM_FEAT_RECONFIG;
      end
        
      FSM_FEAT_RECONFIG: // Reconfigure a single feature
      begin
        // Setup the registers feeding the low-level FSM based on feature_idx

        rcnf_reconfig <= 1'b1;
        write_cnt <= write_cnt + 1'd1;
        fsm_state <= FSM_WAIT_FOR_BUSY_LOW;
        
        case(feature_idx)
          FEAT_RX_GAIN1: // RX GAIN
          begin
            rcnf_address <= ADDR_DCGAIN1;
            rcnf_mask <= MASK_DCGAIN1;
            rcnf_data <= {24'd0,rx_gains_mem[20*lane_idx +:8]};
          end
          FEAT_RX_GAIN2: // RX GAIN
          begin
            rcnf_address <= ADDR_DCGAIN2;
            rcnf_mask <= MASK_DCGAIN2;
            rcnf_data <= {28'd0,rx_gains_mem[20*lane_idx+8 +:4]};
          end
          FEAT_RX_GAIN3: // RX GAIN
          begin
            rcnf_address <= ADDR_VGA;
            rcnf_mask <= MASK_VGA;
            rcnf_data <= {28'd0,rx_gains_mem[20*lane_idx+17 +:3],1'b0};
          end
          FEAT_RX_GAIN4: // RX GAIN
          begin
            rcnf_address <= ADDR_ACGAIN;
            rcnf_mask <= MASK_ACGAIN;
            rcnf_data <= {26'd0,rx_gains_mem[20*lane_idx+12 +:5],1'b0};
          end
          
          FEAT_RX_REFCLK1: // RX GXB
          begin
            rcnf_address <= ADDR_L_PFD_COUNTER;
            rcnf_mask <= MASK_L_PFD_COUNTER;
            rcnf_data <= {29'd0,COUNTER_L_PFD[rx_link_rate_mem]};
          end
          FEAT_RX_REFCLK2: // RX GXB
          begin
            rcnf_address <= ADDR_L_PD_COUNTER;
            rcnf_mask <= MASK_L_PD_COUNTER;
            rcnf_data <= {26'd0,COUNTER_L_PD[rx_link_rate_mem],3'd0};
          end
          FEAT_RX_REFCLK3: // RX GXB
          begin
            rcnf_address <= ADDR_M_COUNTER;
            rcnf_mask <= MASK_M_COUNTER;
            rcnf_data <= {24'd0,COUNTER_M[rx_link_rate_mem]};
          end
          FEAT_RX_REFCLK4: // RX GXB
          begin
            rcnf_address <= ADDR_PPM_SEL;
            rcnf_mask <= MASK_PPM_SEL;
            rcnf_data <= {24'd0,PPM_SEL[rx_link_rate_mem],2'd0};
          end
	  FEAT_RX_REFCLK5: // RX GXB
          begin
            rcnf_reconfig <= 1'b0;
            rcnf_lcalib <= 1'b1; // Re-load calibration results
          end
          
          FEAT_TX_VOD: // TX analog PMA
          begin
            rcnf_address        <= ADDR_VOD_OUTPUT_SWING_CTRL;
            rcnf_mask           <= MASK_VOD_OUTPUT_SWING_CTRL;
            rcnf_data           <= {27'd0,tx_vod_mem[5*lane_idx +:5]};
          end
          FEAT_TX_EMP1: // TX analog PMA
          begin
            rcnf_address        <= ADDR_PRE_EMP_SWITCHING_CTRL_1ST_POST_TAP;
            rcnf_mask           <= MASK_PRE_EMP_SWITCHING_CTRL_1ST_POST_TAP;
            rcnf_data           <= {25'd0,tx_emp_mem[6*lane_idx+5],1'b0,tx_emp_mem[6*lane_idx +:5]};
          end
          FEAT_TX_EMP2: // TX analog PMA
          begin
            rcnf_address        <= ADDR_PRE_EMP_SWITCHING_CTRL_2ND_POST_TAP;
            rcnf_mask           <= MASK_PRE_EMP_SWITCHING_CTRL_2ND_POST_TAP;
            rcnf_data           <= {26'd0,1'b1,1'b0,4'd0};
          end
          FEAT_TX_EMP3: // TX analog PMA
          begin
            rcnf_address        <= ADDR_PRE_EMP_SWITCHING_CTRL_PRE_TAP_1T;
            rcnf_mask           <= MASK_PRE_EMP_SWITCHING_CTRL_PRE_TAP_1T;
            rcnf_data           <= {26'd0,1'b1,5'd0};
          end
          FEAT_TX_EMP4: // TX analog PMA
          begin
            rcnf_address        <= ADDR_PRE_EMP_SWITCHING_CTRL_PRE_TAP_2T;
            rcnf_mask           <= MASK_PRE_EMP_SWITCHING_CTRL_PRE_TAP_2T;
            rcnf_data           <= {27'd0,1'b1,1'b0,3'd0};
          end

          FEAT_TX_REFCLK1: // TXPLL
          begin
            rcnf_address        <= ADDR_TXPLL_M_CNT;
            rcnf_mask           <= MASK_TXPLL_M_CNT;
            rcnf_data           <= {24'd0,M_COUNTER_FPLL[tx_link_rate_mem]};
          end
          FEAT_TX_REFCLK2: // TXPLL
          begin
            rcnf_address        <= ADDR_TXPLL_L_CNT;
            rcnf_mask           <= MASK_TXPLL_L_CNT;
            rcnf_data           <= {29'd0,L_COUNTER_FPLL[tx_link_rate_mem],1'b0};
          end
          FEAT_TX_REFCLK3: // TXPLL
          begin
            rcnf_reconfig <= 1'b0;
            rcnf_lcalib <= 1'b1; // Re-load calibration results
          end

        endcase

      end

      FSM_WAIT_FOR_BUSY_LOW:
        if(!rcnf_busy) 
        begin
          if(rx_lrate_busy)
            fsm_state <= FSM_NEXT_RX_LRATE_FEATURE;
          else if(rx_analog_busy)
            fsm_state <= FSM_NEXT_RX_ANALOG_FEATURE;
          else if(tx_lrate_busy)
            fsm_state <= FSM_NEXT_TX_LRATE_FEATURE;
          else
            fsm_state <= FSM_NEXT_TX_ANALOG_FEATURE;
        end
    
      FSM_NEXT_RX_LRATE_FEATURE:
        if(write_cnt == 3'd5)
          fsm_state <= FSM_END_RECONFIG;
        else
        begin
          // Next feature
          feature_idx <= feature_idx + 4'd1;
          fsm_state <= FSM_FEAT_RECONFIG;
        end
      
      FSM_NEXT_RX_ANALOG_FEATURE:
        if(write_cnt == 3'd4)
          fsm_state <= FSM_END_RECONFIG;
        else
        begin
          // Next feature
          feature_idx <= feature_idx + 4'd1;
          fsm_state <= FSM_FEAT_RECONFIG;
        end
      
      FSM_NEXT_TX_LRATE_FEATURE:
      begin
        if(write_cnt == 3'd3) 
          fsm_state <= FSM_END_RECONFIG;
        else
        begin
          // Next feature
          feature_idx <= feature_idx + 4'd1;
          fsm_state <= FSM_FEAT_RECONFIG;
        end
      end
     
      FSM_NEXT_TX_ANALOG_FEATURE:
      begin
        if(write_cnt == 3'd5) 
          fsm_state <= FSM_END_RECONFIG;
        else
        begin
          // Next feature
          feature_idx <= feature_idx + 4'd1;
          fsm_state <= FSM_FEAT_RECONFIG;
        end
      end
     
      FSM_END_RECONFIG:
        if(!rcnf_busy) 
          fsm_state <= FSM_NEXT_LANE;

      FSM_NEXT_LANE: // Reconfigure the features for all the lanes
      begin
        if((rx_lrate_busy  & (lane_idx + 1 < RX_LANES)) |
           (rx_analog_busy & (lane_idx + 1 < RX_LANES)) |
           (tx_analog_busy & (lane_idx + 1 < TX_LANES)))
        begin
          // Go to next lane
          lane_idx <= lane_idx + 2'd1;
          write_cnt <= 3'd0;

          if(rx_lrate_busy)
            fsm_state <= FSM_START_RX_LINKRATE;
          else if(rx_analog_busy)
          begin
            rcnf_req_cbus <= 1'b1;
            fsm_state <= FSM_START_RX_ANALOG;
          end
          else
          begin
            rcnf_req_cbus <= 1'b1;
            fsm_state <= FSM_START_TX_ANALOG;
          end
        end
        else
          fsm_state <= FSM_END;        
      end
      
      FSM_END:
      begin
        rx_lrate_busy <= 1'b0;
        tx_lrate_busy <= 1'b0;
        rx_analog_busy <= 1'b0;
        tx_analog_busy <= 1'b0;
        fsm_state <= FSM_IDLE;
      end
    
      default:
        fsm_state <= FSM_END;
        
    endcase
    
  end // if(reset)
end // always

assign rx_mapped_linkrate = rx_link_rate_mem;
// Instantiate the Avalon MM Master connected to the XCVR Reconfiguration Controller

wire rx_rcnf_busy, tx_rcnf_busy;

//RX
bitec_reconfig_avalon_mm_master 
#(
  .XCVR (1) 
)
bitec_reconfig_avalon_mm_master_rx
(
  .clk          (clk),
  .reset        (reset),

  .rcnf_req_cbus      (rcnf_req_cbus),
  .rcnf_rel_cbus      (rcnf_rel_cbus),
  .rcnf_wcalib        (rcnf_wcalib),
  .rcnf_scalib        (rcnf_scalib),
  .rcnf_lcalib        (rcnf_lcalib),
  .rcnf_reconfig      (rcnf_reconfig),
  .rcnf_en            (rx_lrate_busy | rx_analog_busy),
  
  .rcnf_logical_ch    (lane_idx),
  .rcnf_address       (rcnf_address),
  .rcnf_data          (rcnf_data),
  .rcnf_mask          (rcnf_mask),
  .rcnf_linkrate      (rx_link_rate_mem),
  .rcnf_busy          (rx_rcnf_busy),

  .mgmt_chnum         (rx_mgmt_chnum),
  .mgmt_address       (rx_mgmt_address), 
  .mgmt_writedata     (rx_mgmt_writedata),    
  .mgmt_readdata      (rx_mgmt_readdata),    
  .mgmt_write         (rx_mgmt_write),      
  .mgmt_read          (rx_mgmt_read),      
  .mgmt_waitrequest   (rx_mgmt_waitrequest),
  .cal_busy           (rx_xcvr_cal_busy)
);

// TX
bitec_reconfig_avalon_mm_master 
#(
  .XCVR (1) 
)
bitec_reconfig_avalon_mm_master_tx
(
  .clk          (clk),
  .reset        (reset),

  .rcnf_req_cbus      (rcnf_req_cbus),
  .rcnf_rel_cbus      (rcnf_rel_cbus),
  .rcnf_wcalib        (rcnf_wcalib),
  .rcnf_scalib        (rcnf_scalib),
  .rcnf_lcalib        (rcnf_lcalib),
  .rcnf_reconfig      (rcnf_reconfig),
  .rcnf_en            (tx_analog_busy),
  
  .rcnf_logical_ch    (lane_idx),
  .rcnf_address       (rcnf_address),
  .rcnf_data          (rcnf_data),
  .rcnf_mask          (rcnf_mask),
  .rcnf_linkrate      (tx_link_rate_mem),
  .rcnf_busy          (tx_rcnf_busy),

  .mgmt_chnum         (tx_mgmt_chnum),
  .mgmt_address       (tx_mgmt_address), 
  .mgmt_writedata     (tx_mgmt_writedata),    
  .mgmt_readdata      (tx_mgmt_readdata),    
  .mgmt_write         (tx_mgmt_write),      
  .mgmt_read          (tx_mgmt_read),      
  .mgmt_waitrequest   (tx_mgmt_waitrequest),
  .cal_busy           (tx_xcvr_cal_busy)
);

// Instantiate the Avalon MM Master connected to the TX PLL Reconfiguration Controller

wire txpll_rcnf_busy;
bitec_reconfig_avalon_mm_master 
#(
  .XCVR (0) 
)
bitec_reconfig_avalon_mm_master_txpll
(
  .clk          (clk),
  .reset        (reset),

  .rcnf_req_cbus      (rcnf_req_cbus),
  .rcnf_rel_cbus      (rcnf_rel_cbus),
  .rcnf_wcalib        (rcnf_wcalib),
  .rcnf_scalib        (rcnf_scalib),
  .rcnf_lcalib        (rcnf_lcalib),
  .rcnf_reconfig      (rcnf_reconfig),
  .rcnf_en            (tx_lrate_busy),
  
  .rcnf_logical_ch    (2'b00),
  .rcnf_address       (rcnf_address),
  .rcnf_data          (rcnf_data),
  .rcnf_mask          (rcnf_mask),
  .rcnf_linkrate      (tx_link_rate_mem),
  .rcnf_busy          (txpll_rcnf_busy),

  .mgmt_chnum         (),
  .mgmt_address       (txpll_mgmt_address), 
  .mgmt_writedata     (txpll_mgmt_writedata),    
  .mgmt_readdata      (txpll_mgmt_readdata),    
  .mgmt_write         (txpll_mgmt_write),      
  .mgmt_read          (txpll_mgmt_read),      
  .mgmt_waitrequest   (txpll_mgmt_waitrequest),
  .cal_busy           (tx_pll_cal_busy)
);

assign rcnf_busy = tx_lrate_busy ? txpll_rcnf_busy : (rx_rcnf_busy | tx_rcnf_busy);

endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//----------------------------------------------
// Avalon MM Master for driving the Reconfiguration
// (XCVR or TXPLL) management interface
//----------------------------------------------

module bitec_reconfig_avalon_mm_master 
#(
  parameter XCVR = 1  // Usage: 0 = TXPLL, 1 = XCVR 
)
(

  input wire clk,
  input wire reset,

  // Command strobes
  input wire rcnf_req_cbus,               // Assert for 1 clk cycle to get access to internal config bus
  input wire rcnf_rel_cbus,               // Assert for 1 clk cycle to release internal config bus
  input wire rcnf_wcalib,                 // Assert for 1 clk cycle to wait for calibration end
  input wire rcnf_scalib,                 // Assert for 1 clk cycle to save linkrate related calibration results
  input wire rcnf_lcalib,                 // Assert for 1 clk cycle to load back linkrate related calibration results
  input wire rcnf_reconfig,               // Assert for 1 clk cycle to reconfig a single register
  input wire rcnf_en,                     // Must be asserted for command strobes to be accepted

  // Command parameters  
  input wire [1:0] rcnf_logical_ch,       // Logical channel number
  input wire [9:0] rcnf_address,          // Register address
  input wire [31:0] rcnf_data,            // Value of data to write
  input wire [31:0] rcnf_mask,            // Mask for data to write (bits at 1 get written)
  input wire [2:0] rcnf_linkrate,         // Link rate: 0 = RBR .... 4 = HBR3
  output wire rcnf_busy,                  // Asserted while operation is taking place

  // Reconfig management interface
  output reg [1:0] mgmt_chnum,
  output reg [9:0] mgmt_address,
  output reg [31:0] mgmt_writedata,
  input wire [31:0] mgmt_readdata,
  output reg mgmt_write,
  output reg mgmt_read,
  input  wire mgmt_waitrequest,
  input  wire cal_busy
);

// XCVR Reconfiguration controller register addresses
localparam ADDR_XCVR_BUS_ARB                = 10'h000,
           ADDR_XCVR_CDR_VCO_SPEED_FIX_7_6  = 10'h132,
           ADDR_XCVR_CHGPMP_PD_UP           = 10'h133,
           ADDR_XCVR_CDR_VCO_SPEED_FIX_4    = 10'h134,
           ADDR_XCVR_LF_PD_PFD              = 10'h135,  //VCO_SPEED_FIX_5
           ADDR_XCVR_CDR_VCO_SPEED_FIX      = 10'h136,  //VCO_SPEED_FIX_3_0
           ADDR_XCVR_CDR_VCO_SPEED          = 10'h137,
           ADDR_XCVR_CHGPMP_PD_DN           = 10'h139,
           ADDR_XCVR_CAL_BUSY               = 10'h281;

// TXPLL Reconfiguration controller register masks
localparam  MASK_XCVR_LF_PD_PFD             = 32'h0000_004f,
            MASK_XCVR_CDR_VCO_SPEED_FIX_7_6 = 32'h0000_00F7,
            MASK_XCVR_CDR_VCO_SPEED_FIX_4   = 32'h0000_00F7,
            MASK_XCVR_CDR_VCO_SPEED_FIX     = 32'h0000_000f,
            MASK_XCVR_CDR_VCO_SPEED         = 32'h0000_007c,
            MASK_XCVR_CHGPMP_PD_UP          = 32'h0000_00E0,
            MASK_XCVR_CHGPMP_PD_DN          = 32'h0000_00BF;

// TXPLL Reconfiguration controller register addresses
localparam ADDR_TXPLL_BUS_ARB           = 10'h000,
           ADDR_TXPLL_VCO_BAND1         = 10'h10A,
           ADDR_TXPLL_VCO_BAND2         = 10'h10B,
           ADDR_TXPLL_VCO_BAND3         = 10'h142,
           ADDR_TXPLL_VCO_BAND4         = 10'h123,
           ADDR_TXPLL_VCO_BAND5         = 10'h124,
           ADDR_TXPLL_VCO_BAND6         = 10'h125,
           ADDR_TXPLL_VCO_BAND7         = 10'h126,
           ADDR_TXPLL_CAL_BUSY          = 10'h280;

// TXPLL Reconfiguration controller register masks
localparam  MASK_TXPLL_VCO_BAND1        = 32'h0000_001f,
            MASK_TXPLL_VCO_BAND2        = 32'h0000_00f8,
            MASK_TXPLL_VCO_BAND3        = 32'h0000_0030,
            MASK_TXPLL_VCO_BAND4        = 32'h0000_001f,
            MASK_TXPLL_VCO_BAND5        = 32'h0000_00f8,
            MASK_TXPLL_VCO_BAND6        = 32'h0000_001f,
            MASK_TXPLL_VCO_BAND7        = 32'h0000_003e;

// State variables
localparam  FSM_IDLE       = 6'd0,
            FSM_REQBUS_RD  = 6'd1,
            FSM_REQBUS_WR  = 6'd2,
            FSM_RELBUS_RD  = 6'd3,
            FSM_RELBUS_WR  = 6'd4,
            FSM_WCAL_RD    = 6'd5,
            FSM_WCAL_TST   = 6'd6,
            FSM_SCAL_RD1   = 6'd7,
            FSM_SCAL_RD2   = 6'd8,
            FSM_SCAL_RD3   = 6'd9,
            FSM_SCAL_RD4   = 6'd10,
            FSM_SCAL_RD5   = 6'd11,
            FSM_SCAL_RD6   = 6'd12,
            FSM_SCAL_RD7   = 6'd13,
            FSM_SCAL_RD8   = 6'd14,
            FSM_SCAL_RD9   = 6'd15,
            FSM_SCAL_RD10  = 6'd16,
            FSM_SCAL_RD11  = 6'd17,
            FSM_SCAL_RD12  = 6'd18,
            FSM_SCAL_RD13  = 6'd19,
            FSM_SCAL_RD14  = 6'd20,
            FSM_LCAL_RD1   = 6'd21,
            FSM_LCAL_WR1   = 6'd22,
            FSM_LCAL_RD2   = 6'd23,
            FSM_LCAL_WR2   = 6'd24,
            FSM_LCAL_RD3   = 6'd25,
            FSM_LCAL_WR3   = 6'd26,
            FSM_LCAL_RD4   = 6'd27,
            FSM_LCAL_WR4   = 6'd28,
            FSM_LCAL_RD5   = 6'd29,
            FSM_LCAL_WR5   = 6'd30,
            FSM_LCAL_RD6   = 6'd31,
            FSM_LCAL_WR6   = 6'd32,
            FSM_LCAL_RD7   = 6'd33,
            FSM_LCAL_WR7   = 6'd34,
            FSM_LCAL_RD8   = 6'd35,
            FSM_LCAL_WR8   = 6'd36,
            FSM_LCAL_RD9   = 6'd37,
            FSM_LCAL_WR9   = 6'd38,
            FSM_LCAL_RD10  = 6'd39,
            FSM_LCAL_WR10  = 6'd40,
            FSM_LCAL_RD11  = 6'd41,
            FSM_LCAL_WR11  = 6'd42,
            FSM_LCAL_RD12  = 6'd43,
            FSM_LCAL_WR12  = 6'd44,
            FSM_LCAL_RD13  = 6'd45,
            FSM_LCAL_WR13  = 6'd46,
            FSM_LCAL_RD14  = 6'd47,
            FSM_LCAL_WR14  = 6'd48,
            FSM_READ       = 6'd49,
            FSM_WRITE      = 6'd50,
            FSM_END        = 6'd51;

localparam CALIB_RATES = 5; // 5 link rates
localparam CALIB_LANES = XCVR ? 4 : 1; // max 4 lanes
localparam CALIB_VALUES = XCVR ? 7 : 7; // number of calib result registers to store
localparam CALIB_RES_SIZE = CALIB_RATES * CALIB_LANES * CALIB_VALUES;

reg [5:0] state;
reg [7:0] calib_res [CALIB_RES_SIZE-1:0];

always @ (posedge clk or posedge reset) 
  if(reset) 
  begin
    state <= FSM_IDLE;
    mgmt_chnum  <= 2'd0;
    mgmt_address  <= 10'd0;
    mgmt_write <= 1'b0;
    mgmt_read <= 1'b0;
    mgmt_writedata <= 32'd0;
  end
  else
  begin
  
    mgmt_write <= 1'b0;  
    mgmt_read <= 1'b0;

    case (state)
      FSM_IDLE:
        if(rcnf_en)
        begin
          if(rcnf_req_cbus)
            state <= FSM_REQBUS_RD;
          if(rcnf_reconfig)
            state <= FSM_READ;
          if(rcnf_rel_cbus)
            state <= FSM_RELBUS_RD;
          if(rcnf_wcalib)
            state <= FSM_WCAL_RD;
          if(rcnf_scalib)
            state <= XCVR ? FSM_SCAL_RD8 : FSM_SCAL_RD1;
          if(rcnf_lcalib)
            state <= XCVR ? FSM_LCAL_RD8 : FSM_LCAL_RD1;
        end
      
      FSM_REQBUS_RD: // Grab AVMM control (read)
        begin
          if(mgmt_read & !mgmt_waitrequest) 
            state <= FSM_REQBUS_WR;
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= XCVR ? ADDR_XCVR_BUS_ARB : ADDR_TXPLL_BUS_ARB;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_REQBUS_WR: // Grab AVMM control (modify-write)
        begin
          if(mgmt_write & !mgmt_waitrequest) 
            state <= FSM_IDLE;
          else
          begin
            mgmt_writedata  <= (mgmt_readdata & ~32'h0000_0001) | 32'h0000_0000;
            mgmt_write      <= 1'b1;  
          end
        end
    
      FSM_RELBUS_RD: // Release AVMM control (read)
        begin
          if(mgmt_read & !mgmt_waitrequest) 
            state <= FSM_RELBUS_WR;
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= XCVR ? ADDR_XCVR_BUS_ARB : ADDR_TXPLL_BUS_ARB;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_RELBUS_WR: // Release AVMM control (modify-write)
        begin
          if(mgmt_write & !mgmt_waitrequest) 
            state <= FSM_IDLE;
          else
          begin
            mgmt_writedata  <= (mgmt_readdata & ~32'h0000_0001) | 32'h0000_0001;
            mgmt_write      <= 1'b1;  
          end
        end

      FSM_WCAL_RD: // Read calibration status
        if(~cal_busy)
          state <= FSM_IDLE; // rx_cal_busy or pll_cal_busy is 0
        else
          state <= FSM_WCAL_RD; // Still calibrating
      
      FSM_SCAL_RD1: // Read TXPLL calibration results
        begin
          if(mgmt_read & !mgmt_waitrequest) 
          begin
            calib_res[rcnf_linkrate*CALIB_VALUES+0] <= (mgmt_readdata[7:0] & MASK_TXPLL_VCO_BAND1[7:0]);
            state <= FSM_SCAL_RD2;
          end
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_TXPLL_VCO_BAND1;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_SCAL_RD2:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
          begin
            calib_res[rcnf_linkrate*CALIB_VALUES+1] <= (mgmt_readdata[7:0] & MASK_TXPLL_VCO_BAND2[7:0]);
            state <= FSM_SCAL_RD3;
          end
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_TXPLL_VCO_BAND2;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_SCAL_RD3:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
          begin
            calib_res[rcnf_linkrate*CALIB_VALUES+2] <= (mgmt_readdata[7:0] & MASK_TXPLL_VCO_BAND3[7:0]);
            state <= FSM_SCAL_RD4;
          end
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_TXPLL_VCO_BAND3;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_SCAL_RD4:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
          begin
            calib_res[rcnf_linkrate*CALIB_VALUES+3] <= (mgmt_readdata[7:0] & MASK_TXPLL_VCO_BAND4[7:0]);
            state <= FSM_SCAL_RD5;
          end
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_TXPLL_VCO_BAND4;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_SCAL_RD5:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
          begin
            calib_res[rcnf_linkrate*CALIB_VALUES+4] <= (mgmt_readdata[7:0] & MASK_TXPLL_VCO_BAND5[7:0]);
            state <= FSM_SCAL_RD6;
          end
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_TXPLL_VCO_BAND5;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_SCAL_RD6:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
          begin
            calib_res[rcnf_linkrate*CALIB_VALUES+5] <= (mgmt_readdata[7:0] & MASK_TXPLL_VCO_BAND6[7:0]);
            state <= FSM_SCAL_RD7;
          end
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_TXPLL_VCO_BAND6;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_SCAL_RD7:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
          begin
            calib_res[rcnf_linkrate*CALIB_VALUES+6] <= (mgmt_readdata[7:0] & MASK_TXPLL_VCO_BAND7[7:0]);
            state <= FSM_IDLE;
          end
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_TXPLL_VCO_BAND7;
            mgmt_read      <= 1'b1;  
          end
        end
		
      FSM_SCAL_RD8: // Read XCVR calibration results
        begin
          if(mgmt_read & !mgmt_waitrequest) 
          begin
            calib_res[rcnf_linkrate*CALIB_VALUES+rcnf_logical_ch*CALIB_RATES*CALIB_VALUES+0] <= (mgmt_readdata[7:0] & MASK_XCVR_CDR_VCO_SPEED[7:0]);
            state <= FSM_SCAL_RD9;
          end
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_XCVR_CDR_VCO_SPEED;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_SCAL_RD9:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
          begin
            calib_res[rcnf_linkrate*CALIB_VALUES+rcnf_logical_ch*CALIB_RATES*CALIB_VALUES+1] <= (mgmt_readdata[7:0] & MASK_XCVR_CDR_VCO_SPEED_FIX[7:0]);
            state <= FSM_SCAL_RD10;
          end
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_XCVR_CDR_VCO_SPEED_FIX;
            mgmt_read      <= 1'b1;  
          end
        end

      FSM_SCAL_RD10:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
          begin
            calib_res[rcnf_linkrate*CALIB_VALUES+rcnf_logical_ch*CALIB_RATES*CALIB_VALUES+2] <= (mgmt_readdata[7:0] & MASK_XCVR_CHGPMP_PD_UP[7:0]);
            state <= FSM_SCAL_RD11;
          end
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_XCVR_CHGPMP_PD_UP;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_SCAL_RD11:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
          begin
            calib_res[rcnf_linkrate*CALIB_VALUES+rcnf_logical_ch*CALIB_RATES*CALIB_VALUES+3] <= (mgmt_readdata[7:0] & MASK_XCVR_CHGPMP_PD_DN[7:0]);
            state <= FSM_SCAL_RD12;
          end
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_XCVR_CHGPMP_PD_DN;
            mgmt_read      <= 1'b1;  
          end
        end

      FSM_SCAL_RD12:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
          begin
            calib_res[rcnf_linkrate*CALIB_VALUES+rcnf_logical_ch*CALIB_RATES*CALIB_VALUES+4] <= (mgmt_readdata[7:0] & MASK_XCVR_LF_PD_PFD[7:0]);
            state <= FSM_SCAL_RD13;
          end
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_XCVR_LF_PD_PFD;
            mgmt_read      <= 1'b1;  
          end
        end

      
      FSM_SCAL_RD13:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
          begin
            calib_res[rcnf_linkrate*CALIB_VALUES+rcnf_logical_ch*CALIB_RATES*CALIB_VALUES+5] <= (mgmt_readdata[7:0] & MASK_XCVR_CDR_VCO_SPEED_FIX_7_6[7:0]);
            state <= FSM_SCAL_RD14;
          end
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_XCVR_CDR_VCO_SPEED_FIX_7_6;
            mgmt_read      <= 1'b1;  
          end
        end

      FSM_SCAL_RD14:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
          begin
            calib_res[rcnf_linkrate*CALIB_VALUES+rcnf_logical_ch*CALIB_RATES*CALIB_VALUES+6] <= (mgmt_readdata[7:0] & MASK_XCVR_CDR_VCO_SPEED_FIX_4[7:0]);
            state <= FSM_IDLE;
          end
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_XCVR_CDR_VCO_SPEED_FIX_4;
            mgmt_read      <= 1'b1;  
          end
        end
        
      FSM_LCAL_RD1: // Load back TXPLL calibration results
        begin
          if(mgmt_read & !mgmt_waitrequest) 
            state <= FSM_LCAL_WR1;
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_TXPLL_VCO_BAND1;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_LCAL_WR1:
        begin
          if(mgmt_write & !mgmt_waitrequest) 
            state <= FSM_LCAL_RD2;
          else
          begin
            mgmt_writedata  <= (mgmt_readdata & ~MASK_TXPLL_VCO_BAND1) | calib_res[rcnf_linkrate*CALIB_VALUES+0];
            mgmt_write      <= 1'b1;  
          end
        end

      FSM_LCAL_RD2:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
            state <= FSM_LCAL_WR2;
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_TXPLL_VCO_BAND2;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_LCAL_WR2:
        begin
          if(mgmt_write & !mgmt_waitrequest) 
            state <= FSM_LCAL_RD3;
          else
          begin
            mgmt_writedata  <= (mgmt_readdata & ~MASK_TXPLL_VCO_BAND2) | calib_res[rcnf_linkrate*CALIB_VALUES+1];
            mgmt_write      <= 1'b1;  
          end
        end

      FSM_LCAL_RD3:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
            state <= FSM_LCAL_WR3;
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_TXPLL_VCO_BAND3;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_LCAL_WR3:
        begin
          if(mgmt_write & !mgmt_waitrequest) 
            state <= FSM_LCAL_RD4;
          else
          begin
            mgmt_writedata  <= (mgmt_readdata & ~MASK_TXPLL_VCO_BAND3) | calib_res[rcnf_linkrate*CALIB_VALUES+2];
            mgmt_write      <= 1'b1;  
          end
        end

      FSM_LCAL_RD4:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
            state <= FSM_LCAL_WR4;
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_TXPLL_VCO_BAND4;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_LCAL_WR4:
        begin
          if(mgmt_write & !mgmt_waitrequest) 
            state <= FSM_LCAL_RD5;
          else
          begin
            mgmt_writedata  <= (mgmt_readdata & ~MASK_TXPLL_VCO_BAND4) | calib_res[rcnf_linkrate*CALIB_VALUES+3];
            mgmt_write      <= 1'b1;  
          end
        end

      FSM_LCAL_RD5:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
            state <= FSM_LCAL_WR5;
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_TXPLL_VCO_BAND5;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_LCAL_WR5:
        begin
          if(mgmt_write & !mgmt_waitrequest) 
            state <= FSM_LCAL_RD6;
          else
          begin
            mgmt_writedata  <= (mgmt_readdata & ~MASK_TXPLL_VCO_BAND5) | calib_res[rcnf_linkrate*CALIB_VALUES+4];
            mgmt_write      <= 1'b1;  
          end
        end

      FSM_LCAL_RD6:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
            state <= FSM_LCAL_WR6;
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_TXPLL_VCO_BAND6;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_LCAL_WR6:
        begin
          if(mgmt_write & !mgmt_waitrequest) 
            state <= FSM_LCAL_RD7;
          else
          begin
            mgmt_writedata  <= (mgmt_readdata & ~MASK_TXPLL_VCO_BAND6) | calib_res[rcnf_linkrate*CALIB_VALUES+5];
            mgmt_write      <= 1'b1;  
          end
        end

      FSM_LCAL_RD7:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
            state <= FSM_LCAL_WR7;
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_TXPLL_VCO_BAND7;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_LCAL_WR7:
        begin
          if(mgmt_write & !mgmt_waitrequest) 
            state <= FSM_IDLE;
          else
          begin
            mgmt_writedata  <= (mgmt_readdata & ~MASK_TXPLL_VCO_BAND7) | calib_res[rcnf_linkrate*CALIB_VALUES+6];
            mgmt_write      <= 1'b1;  
          end
        end

      FSM_LCAL_RD8: // Load back GXB calibration results
        begin
          if(mgmt_read & !mgmt_waitrequest) 
            state <= FSM_LCAL_WR8;
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_XCVR_CDR_VCO_SPEED;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_LCAL_WR8:
        begin
          if(mgmt_write & !mgmt_waitrequest) 
            state <= FSM_LCAL_RD9;
          else
          begin
            mgmt_writedata  <= (mgmt_readdata & ~MASK_XCVR_CDR_VCO_SPEED) | calib_res[rcnf_linkrate*CALIB_VALUES+0];
            mgmt_write      <= 1'b1;  
          end
        end

      FSM_LCAL_RD9:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
            state <= FSM_LCAL_WR9;
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_XCVR_CDR_VCO_SPEED_FIX;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_LCAL_WR9:
        begin
          if(mgmt_write & !mgmt_waitrequest) 
            state <= FSM_LCAL_RD10;
          else
          begin
            mgmt_writedata  <= (mgmt_readdata & ~MASK_XCVR_CDR_VCO_SPEED_FIX) | calib_res[rcnf_linkrate*CALIB_VALUES+1];
            mgmt_write      <= 1'b1;  
          end
        end

      FSM_LCAL_RD10:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
            state <= FSM_LCAL_WR10;
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_XCVR_CHGPMP_PD_UP;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_LCAL_WR10:
        begin
          if(mgmt_write & !mgmt_waitrequest) 
            state <= FSM_LCAL_RD11;
          else
          begin
            mgmt_writedata  <= (mgmt_readdata & ~MASK_XCVR_CHGPMP_PD_UP) | calib_res[rcnf_linkrate*CALIB_VALUES+2];
            mgmt_write      <= 1'b1;  
          end
        end

      FSM_LCAL_RD11:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
            state <= FSM_LCAL_WR11;
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_XCVR_CHGPMP_PD_DN;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_LCAL_WR11:
        begin
          if(mgmt_write & !mgmt_waitrequest) 
            state <= FSM_LCAL_RD12;
          else
          begin
            mgmt_writedata  <= (mgmt_readdata & ~MASK_XCVR_CHGPMP_PD_DN) | calib_res[rcnf_linkrate*CALIB_VALUES+3];
            mgmt_write      <= 1'b1;  
          end
        end

      FSM_LCAL_RD12:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
            state <= FSM_LCAL_WR12;
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_XCVR_LF_PD_PFD;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_LCAL_WR12:
        begin
          if(mgmt_write & !mgmt_waitrequest) 
            state <= FSM_LCAL_RD13;
          else
          begin
            mgmt_writedata  <= (mgmt_readdata & ~MASK_XCVR_LF_PD_PFD) | calib_res[rcnf_linkrate*CALIB_VALUES+4];
            mgmt_write      <= 1'b1;  
          end
        end

      FSM_LCAL_RD13:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
            state <= FSM_LCAL_WR13;
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_XCVR_CDR_VCO_SPEED_FIX_7_6;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_LCAL_WR13:
        begin
          if(mgmt_write & !mgmt_waitrequest) 
            state <= FSM_LCAL_RD14;
          else
          begin
            mgmt_writedata  <= (mgmt_readdata & ~MASK_XCVR_CDR_VCO_SPEED_FIX_7_6) | calib_res[rcnf_linkrate*CALIB_VALUES+5];
            mgmt_write      <= 1'b1;  
          end
        end

      FSM_LCAL_RD14:
        begin
          if(mgmt_read & !mgmt_waitrequest) 
            state <= FSM_LCAL_WR14;
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= ADDR_XCVR_CDR_VCO_SPEED_FIX_4;
            mgmt_read      <= 1'b1;  
          end
        end
      
      FSM_LCAL_WR14:
        begin
          if(mgmt_write & !mgmt_waitrequest) 
            state <= FSM_IDLE;
          else
          begin
            mgmt_writedata  <= (mgmt_readdata & ~MASK_XCVR_CDR_VCO_SPEED_FIX_4) | calib_res[rcnf_linkrate*CALIB_VALUES+6];
            mgmt_write      <= 1'b1;  
          end
        end

      FSM_READ: // Single register read
        begin
          if(mgmt_read & !mgmt_waitrequest) 
            state <= FSM_WRITE;
          else
          begin
            mgmt_chnum     <= rcnf_logical_ch;
            mgmt_address   <= rcnf_address;
            mgmt_read      <= 1'b1;  
          end
        end

      FSM_WRITE: // Single register modify-write
        begin
          if(mgmt_write & !mgmt_waitrequest) 
            state <= FSM_IDLE;
          else
          begin
            mgmt_writedata  <= (mgmt_readdata & ~rcnf_mask) | rcnf_data;
            mgmt_write      <= 1'b1;  
          end
        end
      endcase
      
    end

assign rcnf_busy = (state != FSM_IDLE) | rcnf_req_cbus | rcnf_rel_cbus | rcnf_reconfig | rcnf_wcalib | rcnf_scalib | rcnf_lcalib;

endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//----------------------------------------------
// Map DisplayPort Voltage swing / Pre-emphasis
// to TX VOD / EMP settings
// for Arria 10 GX
//
// 1st pre-tap always supposed set to 0
// 2nd pre-tap always supposed set to 0
// 2nd post-tap always supposed set to 0
//----------------------------------------------

module tx_analog_mappings 
(
  input  wire [1:0]   vod,  
  input  wire [1:0]   pree, 
  output reg  [4:0]   out_vod, 
  output reg  [5:0]   out_pree_post_tap1 // bit5 is polarity, 1=neg 0=pos
);

always @(*)
  case (vod)
    2'b00 :  // 400mv
    begin
      case(pree) 
        2'b00 : // (0db)
        begin
          out_vod = 5'd12;     
          out_pree_post_tap1 = {1'b1,5'd0};
        end
        2'b01 : // (3.5db)
        begin
          out_vod = 5'd17;     
          out_pree_post_tap1 = {1'b1,5'd5};
        end
        2'b10 : // (6db)
        begin
          out_vod = 5'd23;     
          out_pree_post_tap1 = {1'b1,5'd11};
        end
        2'b11 : // (9db)
        begin
          out_vod = 5'd31;     
          out_pree_post_tap1 = {1'b1,5'd19};
        end
      endcase
    end
    2'b01 : // 600mv
    begin
      case(pree) 
        2'b00 : // (0db)
        begin
          out_vod = 5'd17;     
          out_pree_post_tap1 = {1'b1,5'd0};
        end
        2'b01 : // (3.5db)
        begin
          out_vod = 5'd25;     
          out_pree_post_tap1 = {1'b1,5'd8};
        end
        2'b10 : // (6db)
        begin
          out_vod = 5'd31;     
          out_pree_post_tap1 = {1'b1,5'd15};
        end
        2'b11 : // unused
        begin
          out_vod = 5'd31;     
          out_pree_post_tap1 = {1'b1,5'd15};
        end
      endcase
    end
    2'b10 : // 800mv
    begin
      case(pree) 
        2'b00 : // (0db)
        begin
          out_vod = 5'd23;     
          out_pree_post_tap1 = {1'b1,5'd0};
        end
        2'b01 : // (3.5db)
        begin
          out_vod = 5'd31;     
          out_pree_post_tap1 = {1'b1,5'd10}; 
        end
        2'b10 : // unused
        begin
          out_vod = 5'd31;     
          out_pree_post_tap1 = {1'b1,5'd10}; 
        end
        2'b11 : // unused
        begin
          out_vod = 5'd31;     
          out_pree_post_tap1 = {1'b1,5'd10}; 
        end
      endcase
    end
    2'b11 : // 1200mv
    begin
      case(pree) 
        2'b00 : // (0db)
        begin
          out_vod = 5'd31;     
          out_pree_post_tap1 = {1'b1,5'd0};
        end
        2'b01 : // 
        begin
          out_vod = 5'd31;     
          out_pree_post_tap1 = {1'b1,5'd0}; 
        end
        2'b10 : // unused
        begin
          out_vod = 5'd31;     
          out_pree_post_tap1 = {1'b1,5'd0}; 
        end
        2'b11 : // unused
        begin
          out_vod = 5'd31;     
          out_pree_post_tap1 = {1'b1,5'd0}; 
        end
      endcase
    end
  endcase

endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------
// Map DisplayPort Link rate / Voltage swing / Pre-emphasis
// to RX AC, DC and VGA gain settings
// for Arria 10 GX
//-----------------------------------------------------------

module rx_analog_mappings 
(
  input wire [2:0] linkrate, // 0 = RBR... 4 = HBR3
  input wire [1:0] vod,  
  input wire [1:0] pree, 
  output reg [11:0] out_dc, 
  output reg [4:0] out_ac, 
  output reg [2:0] out_vga 
);

always @(*)
  case (linkrate)
    3'd1 :  // 2.7G
    begin
      out_dc = 12'd0;
      out_ac = 5'd2;
      out_vga = 3'd7;
    end
    3'd2 :  // 5.4G
    begin
      out_dc = 12'd0;
      out_ac = 5'd10;
      out_vga = 3'd7;
    end
    3'd3 :  // 6.75G
    begin
      out_dc = 12'd0;
      out_ac = 5'd12;
      out_vga = 3'd7;
    end
    3'd4 :  // 8.1G
    begin
      out_dc = 12'd0;
      out_ac = 5'd15;
      out_vga = 3'd7;
    end
    default :  // 1.62G
    begin
      out_dc = 12'd0;
      out_ac = 5'd6;
      out_vga = 3'd7;
    end
  endcase

endmodule
`default_nettype wire
