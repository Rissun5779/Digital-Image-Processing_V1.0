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
//
//
// Bitec DisplayPort IP Core
// 
//
// All rights reserved. Property of Bitec.
// Restricted rights to use, duplicate or disclose this code are
// granted through contract.
// 
// (C) Copyright Bitec 2010,2011,2012,2013,2014
//     All rights reserved
//
// *********************************************************************
// Author         : $Author: Marco $ @ bitec-dsp.com
// Department     : 
// Date           : $Date: 2014-11-21 15:32:16 +0200 (Fri, 21 Nov 2014) $
// Revision       : $Revision: 1501 $
// URL            : $URL: svn://nas-bitec-fi/dp/trunk/demo/bitec_reconfig_alt_av.v $
// *********************************************************************
// Description
// 
// This module implements Altera RX/TX transceivers reconfiguration
// for Altera Arria V GX:
// - single 135MHz clock input for 1620,2700 and 5400 Gbps
// - TX bonded
// - Logical channels ordering:
//       index                         description
//   0 to RX_LANES-1                   RX channels
//   RX_LANES to RX_LANES+TX_LANES-1   TX channels
//   RX_LANES+TX_LANES                 TX (single) PLL
// - for HDMI, the GXB refclk used must be pix_clk or pix_clkx2
//   according to GXB data rate, symbols/clock and HDMI_CLKX2 used
//
// *********************************************************************

// synthesis translate_off
`timescale 1ns / 1ns
// synthesis translate_on
`default_nettype none

module bitec_reconfig_alt_av 
#(
  parameter [3:0] TX_LANES = 4,
  parameter [3:0] RX_LANES = 4,
  parameter HDMI_CLKX2 = 1                // 0 = GXB_data_rate = GXB_clk_ref X 1,   1 = GXB_data_rate = GXB_clk_ref X 2
)
(
  input  wire clk,                        // The same clock driving the reconfig controller
  input  wire reset,                      // The same reset driving the reconfig controller

  input  wire [7:0] rx_link_rate,         // Link rate in multiples of 270 Mbps
  input  wire rx_link_rate_strobe,        // Assert for at least 1 clk cycle when a new rx_link_rate must be used
  output wire rx_xcvr_busy,               // Asserted during RX reconfig and calibration time

  input  wire [7:0] tx_link_rate,         // Link rate in multiples of 270 Mbps
  input  wire [(TX_LANES*2)-1:0] tx_vod,  // Voltage swing level, 0 to 3
  input  wire [(TX_LANES*2)-1:0] tx_emp,  // Pre-emphasis level, 0 to 3
  input  wire tx_link_rate_strobe,        // Assert for at least 1 clk cycle when a new tx_link_rate must be used
  input  wire tx_vodemp_strobe,           // Assert for at least 1 clk cycle when new VOD/EMP values must be used
  input  wire tx_hdmi_en,                 // Assert/deassert for at least 63 clk cycles to enable/disable HDMI TX configuration
  output wire tx_xcvr_busy,               // Asserted during TX reconfig and calibration time
  output wire tx_xcvr_reset,              // Asserted when the TX XCVR must be reset

  // RX XCVR resets
  input wire [3:0] rx_analogreset_in,
  input wire [3:0] rx_digitalreset_in,
  output wire [3:0] rx_analogreset,
  output wire [3:0] rx_digitalreset,
  
  // Reconfig controller interface
  output wire [6:0] mgmt_address,
  output wire[31:0] mgmt_writedata,
  input  wire [31:0] mgmt_readdata,
  output wire mgmt_write,
  output wire mgmt_read,
  input  wire mgmt_waitrequest,
  output wire mgmt_rst_reset,
  input  wire reconfig_busy,
  input  wire rx_cal_busy,
  input  wire tx_cal_busy
);

assign mgmt_read = 1'b0;

// main FSM states
localparam  FSM_IDLE = 0,
            FSM_START_RX_LINKRATE = 1,
            FSM_START_TX_LINKRATE = 2,
            FSM_START_TX_ANALOG = 3,
            FSM_START_TX_HDMI = 4,
            FSM_FEAT_RECONFIG = 5,
            FSM_WAIT_FOR_BUSY_HIGH = 6,
            FSM_WAIT_FOR_BUSY_LOW = 7,
            FSM_NEXT_LANE = 8,
            FSM_NEXT_RX_LRATE_FEATURE = 9,
            FSM_NEXT_TX_LRATE_FEATURE = 10,
            FSM_NEXT_TX_ANALOG_FEATURE = 11,
            FSM_NEXT_HDMI_FEATURE = 12,
            FSM_END_RECONFIG = 13;

// Feature (our internal!) index
localparam  FEAT_RX_REFCLK1 = 4'd0,
            FEAT_RX_REFCLK2 = 4'd1,
            FEAT_RX_REFCLK3 = 4'd2,
            FEAT_TX_VOD = 4'd3,
            FEAT_TX_EMP = 4'd4,
            FEAT_TX_REFCLK1 = 4'd5,
            FEAT_TX_REFCLK2 = 4'd6,
            FEAT_TX_REFCLK3 = 4'd7,
            FEAT_TX_REFCLK4 = 4'd8,
            FEAT_TX_REFCLK5 = 4'd9;

// Reconfiguration controller register addresses
localparam  PMA_CHANNEL_REG     = 7'h08,
            STREAM_CHANNEL_REG  = 7'h38,
            PLL_CHANNEL_REG     = 7'h40;

// Reconfiguration controller register offsets
localparam  REFCLK_FEATURE_OFFS  = 16'h0,
            VOD_FEATURE_OFFS     = 16'h0,
            EMP_FEATURE_OFFS     = 16'h2;

// RX Reconfiguration bitmasks
localparam AC_GAIN_0 = 16'h0000,
           AC_GAIN_1 = 16'h4000,
           AC_GAIN_2 = 16'hC000;
localparam HALF_BW = 16'h1000,
           FULL_BW = 16'h0000;
localparam CDR_BW_LOW = 16'h8490,
           CDR_BW_MED = 16'h8450,
           CDR_BW_HI = 16'h8410;

reg [3:0] fsm_state; // Main FSM state

// VOD & EMP mapped to the XCVR
wire [(TX_LANES*6)-1:0] vod_mapped;
wire [(TX_LANES*5)-1:0] emp_mapped;   

// Generate mapping tables for each lane
generate 
begin      
  genvar tx_lane;
  for (tx_lane=0; tx_lane < TX_LANES; tx_lane = tx_lane + 1) 
  begin:lane
    dp_analog_mappings 
    #(
      .DEVICE_FAMILY  ("Arria V")
    )
    dp_analog_mappings_i
    (
      .in_vod   (tx_vod[(tx_lane*2) +: 2]), 
      .in_emp   (tx_emp[(tx_lane*2) +: 2]),
      .out_vod  (vod_mapped[(tx_lane*6) +: 6]), 
      .out_emp  (emp_mapped[(tx_lane*5) +: 5])
    );
  end // for
end // generate
endgenerate

//-------------------
// Changes detection
//-------------------

reg [2:0] rx_link_rate_strobe_d,tx_link_rate_strobe_d,tx_vodemp_strobe_d,tx_hdmi_en_d;
reg [5:0] hdmi_en_cnt;
reg rx_new_linkrate; // Asserted when RX linkrate changes are detected
reg tx_new_linkrate; // Asserted when TX linkrate changes are detected
reg tx_new_analog;   // Asserted when TX VOD/EMP changes are detected
reg tx_hdmi_enable;  // Asserted when TX HDMI activation is detected
reg tx_hdmi_enabled; // Asserted when TX HDMI mode is active

assign mgmt_rst_reset = rx_new_linkrate;

always @ (posedge clk or posedge reset) 
begin
  if(reset) 
  begin
    rx_link_rate_strobe_d <= 3'h0;
    tx_link_rate_strobe_d <= 3'h0;
    tx_vodemp_strobe_d <= 3'h0;
    tx_hdmi_en_d <= 3'h0;
    rx_new_linkrate <= 1'b0;
    tx_new_linkrate <= 1'b0;
    tx_new_analog <= 1'b0;
    tx_hdmi_enable <= 1'b0;
    tx_hdmi_enabled <= 1'b0;
    hdmi_en_cnt <= 6'd0;
  end
  else
  begin
    rx_link_rate_strobe_d <= {rx_link_rate_strobe_d[1:0],rx_link_rate_strobe};
    tx_link_rate_strobe_d <= {tx_link_rate_strobe_d[1:0],tx_link_rate_strobe};
    tx_vodemp_strobe_d <= {tx_vodemp_strobe_d[1:0],tx_vodemp_strobe};
    tx_hdmi_en_d <= {tx_hdmi_en_d[1:0],tx_hdmi_en};
    
    rx_new_linkrate <= rx_new_linkrate ? ~(fsm_state == FSM_START_RX_LINKRATE) : (~rx_link_rate_strobe_d[2] & rx_link_rate_strobe_d[1]);
    tx_new_linkrate <= tx_new_linkrate ? ~(fsm_state == FSM_START_TX_LINKRATE) : (~tx_link_rate_strobe_d[2] & tx_link_rate_strobe_d[1]);
    tx_new_analog <= tx_new_analog ? ~(fsm_state == FSM_START_TX_ANALOG) : (~tx_vodemp_strobe_d[2] & tx_vodemp_strobe_d[1]);
    tx_hdmi_enable <= 1'b0;

    // If tx_hdmi_en is asserted for 63 or more cycles, set the TX for HDMI
    // If tx_hdmi_en is deasserted for 63 or more cycles allow DP TX reconfig
    if(tx_hdmi_en_d[2] == tx_hdmi_en_d[1])
    begin
      // tx_hdmi_en stable
      if(hdmi_en_cnt == 6'd62)
      begin
        // tx_hdmi_en has been 63 cycles stable
        if(tx_hdmi_en_d[2] & ~tx_hdmi_enabled)
        begin
          // hdmi is being enabled
          tx_hdmi_enable <= 1'b1;
          tx_hdmi_enabled <= 1'b1;
        end
        else if(~tx_hdmi_en_d[2] & tx_hdmi_enabled)
        begin
          // hdmi is being disabled
          tx_hdmi_enabled <= 1'b0;
        end
      end
      if(hdmi_en_cnt < 6'd63)
        hdmi_en_cnt <= hdmi_en_cnt + 6'd1;
    end
    else
      hdmi_en_cnt <= 6'd0; // tx_hdmi_en unstable
  
    if(tx_hdmi_enabled)
    begin
      // Prevent TX reconfig
      tx_new_linkrate <= 1'b0;
      tx_new_analog <= 1'b0;
    end

  end
end

//----------
// Main FSM
//----------

reg [3:0] feature_idx; // Feature index
reg [(TX_LANES*6)-1:0] vod_mem;
reg [(TX_LANES*5)-1:0] emp_mem;
reg [1:0] tx_link_rate_mem;
reg [1:0] rx_link_rate_mem;
reg [1:0] lane_idx; // Configured lane index (0-3)
reg [5:0] write_cnt; // Write operations counter

reg start_single_reconfig;      // Asserted to start a single item reconfig with the values defined below
reg [6:0] rcnf_address;         // Logical channel address
reg [3:0] rcnf_logical_ch;      // Logical channel number
reg [15:0] rcnf_feature_offset; // Feature offset value
reg [15:0] rcnf_data;           // Data offset value

reg rx_lrate_busy;  // Asserted when RX linkrate changes are being performed
reg tx_lrate_busy;  // Asserted when TX linkrate changes are being performed
reg tx_analog_busy; // Asserted when TX analog changes are being performed
reg tx_hdmi_busy;   // Asserted when TX hdmi changes are being performed

assign rx_xcvr_busy = rx_lrate_busy | rx_cal_busy;
assign tx_xcvr_busy = tx_lrate_busy | tx_cal_busy | tx_analog_busy | tx_hdmi_busy;
assign tx_xcvr_reset = tx_lrate_busy | tx_cal_busy | tx_hdmi_busy; // Do not reset XCVR for analog reconfiguration

always @ (posedge clk or posedge reset) 
begin
  if(reset) 
  begin
    fsm_state <= FSM_IDLE;
    vod_mem <= 0;
    emp_mem <= 0;
    tx_link_rate_mem <= 2'h0;
    rx_link_rate_mem <= 2'h0;
    
    start_single_reconfig <= 1'h0;
    rcnf_address <= 7'h0;
    rcnf_logical_ch <= 4'h0;
    rcnf_feature_offset <= 16'h0;
    rcnf_data <= 16'h0;

    feature_idx <= FEAT_RX_REFCLK1;
    write_cnt <= 6'h0;
    lane_idx <= 2'h0;
    rx_lrate_busy <= 1'b0;
    tx_lrate_busy <= 1'b0;
    tx_analog_busy <= 1'b0;
    tx_hdmi_busy <= 1'b0;
  end
  else
  begin
  
    start_single_reconfig <= 1'b0;

    case(fsm_state)
    
      FSM_IDLE: 
      begin
        write_cnt <= 6'h0;
        lane_idx <= 2'h0;

        if(~rx_xcvr_busy & ~tx_xcvr_busy)
        begin
          // Start a reconfig if either RX or TX requests it
          // (RX has precedence, do not serve RX and TX at the same time)
          if(rx_new_linkrate)
          begin
            rx_lrate_busy  <= 1'b1;
            fsm_state <= FSM_START_RX_LINKRATE;
            if(rx_link_rate == 8'h06)
              rx_link_rate_mem <= 2'b00; // RBR
            else if(rx_link_rate == 8'h0a)
              rx_link_rate_mem <= 2'b01; // HBR
            else if(rx_link_rate == 8'h14)
              rx_link_rate_mem <= 2'b10; // HBR2
            else
            begin
              // Unsupported link rate
              rx_lrate_busy  <= 1'b0;
              fsm_state <= FSM_IDLE;
            end
          end
          else if(tx_new_linkrate)
          begin
            tx_lrate_busy  <= 1'b1;
            fsm_state <= FSM_START_TX_LINKRATE;
            if(tx_link_rate == 8'h06)
              tx_link_rate_mem <= 2'b00; // RBR
            else if(tx_link_rate == 8'h0a)
              tx_link_rate_mem <= 2'b01; // HBR
            else if(tx_link_rate == 8'h14)
              tx_link_rate_mem <= 2'b10; // HBR2
            else
            begin
              // Unsupported link rate
              tx_lrate_busy  <= 1'b0;
              fsm_state <= FSM_IDLE;
            end
          end
          else if(tx_new_analog)
          begin
            vod_mem <= vod_mapped;
            emp_mem <= emp_mapped;
            tx_analog_busy  <= 1'b1;
            fsm_state <= FSM_START_TX_ANALOG;
          end
          else if(tx_hdmi_enable)
          begin
            tx_hdmi_busy  <= 1'b1;
            fsm_state <= FSM_START_TX_HDMI;
          end
        end
      end

      FSM_START_RX_LINKRATE: // Start RX linkrate reconfig
      begin
        rcnf_logical_ch <= 4'h0; // RX logical channels start from zero
        feature_idx <= FEAT_RX_REFCLK1; // Start programming from this feature
        fsm_state <= FSM_FEAT_RECONFIG;
      end

      FSM_START_TX_LINKRATE: // Start TX linkrate reconfig
      begin
        rcnf_logical_ch <= RX_LANES; // TX logical channels follow RX ones
        feature_idx <= FEAT_TX_REFCLK1; // Start programming from this feature
        fsm_state <= FSM_FEAT_RECONFIG;
      end
        
      FSM_START_TX_ANALOG: // Start TX analog reconfig
      begin
        rcnf_logical_ch <= RX_LANES; // TX logical channels follow RX ones
        feature_idx <= FEAT_TX_VOD; // Start programming from this feature
        fsm_state <= FSM_FEAT_RECONFIG;
      end
        
      FSM_START_TX_HDMI: // Start TX HDMI reconfig
      begin
        rcnf_logical_ch <= RX_LANES; // TX logical channels follow RX ones
        feature_idx <= FEAT_TX_VOD; // Start programming from this feature
        fsm_state <= FSM_FEAT_RECONFIG;
      end
        
      FSM_FEAT_RECONFIG: // Reconfigure a single feature
      if(~mgmt_waitrequest) // mgmt_waitrequest maybe still be asserted during calibration
      begin
        // Setup the registers feeding the low-level FSM based on the channel and feature_idx
        // The order is RX channels, TX Analog parameters, TX channels, TX PLLs

        start_single_reconfig <= 1'b1;
        write_cnt <= write_cnt + 6'h01;
        fsm_state <= FSM_WAIT_FOR_BUSY_HIGH;
        
        case(feature_idx)
          FEAT_RX_REFCLK1: // This uses "RX channel" logical channels
          begin
            rcnf_address        <= STREAM_CHANNEL_REG;
            rcnf_feature_offset <= 16'h000E;
            if(rx_link_rate_mem == 0)
              rcnf_data <= 16'h2580;
            else if(rx_link_rate_mem == 1)
              rcnf_data <= 16'h1540;
            else
              rcnf_data <= 16'h1500;
          end
          FEAT_RX_REFCLK2: // This uses "RX channel" logical channels
          begin
            rcnf_address        <= STREAM_CHANNEL_REG;
            rcnf_feature_offset <= 16'h0010;
            if(rx_link_rate_mem == 0)
              rcnf_data <= CDR_BW_HI;
            else if(rx_link_rate_mem == 1)
              rcnf_data <= CDR_BW_MED;
            else
              rcnf_data <= CDR_BW_MED;
          end
          FEAT_RX_REFCLK3: // This uses "RX channel" logical channels
          begin
            rcnf_address        <= STREAM_CHANNEL_REG;
            rcnf_feature_offset <= 16'h0012;
            if(rx_link_rate_mem == 0)
              rcnf_data <= AC_GAIN_0 | HALF_BW | 16'h0100;
            else if(rx_link_rate_mem == 1)
              rcnf_data <= AC_GAIN_0 | HALF_BW | 16'h0100;
            else
              rcnf_data <= AC_GAIN_0 | FULL_BW | 16'h0100;
          end
          
          FEAT_TX_VOD: // This uses "TX channel" logical channels
          begin
            rcnf_address        <= PMA_CHANNEL_REG;
            rcnf_feature_offset <= VOD_FEATURE_OFFS;
            if(tx_hdmi_busy)
              rcnf_data           <= {10'h0,6'd20};  // 400mv
            else
              rcnf_data           <= {10'h0,vod_mem[6*(rcnf_logical_ch - RX_LANES) +: 6]};
          end
          FEAT_TX_EMP: // This uses "TX channel" logical channels
          begin
            rcnf_address        <= PMA_CHANNEL_REG;
            rcnf_feature_offset <= EMP_FEATURE_OFFS;
            if(tx_hdmi_busy)
              rcnf_data           <= {11'h0,5'h0};  // 0db
            else
              rcnf_data           <= {11'h0,emp_mem[5*(rcnf_logical_ch - RX_LANES) +: 5]};
          end

          FEAT_TX_REFCLK1: // This uses "TX channel" logical channels
          begin
            rcnf_address        <= STREAM_CHANNEL_REG;
            rcnf_feature_offset <= 16'h0002;
            if(tx_hdmi_busy)
              rcnf_data <= 16'h012C;
            else if(tx_link_rate_mem == 2'b00)
              rcnf_data <= 16'h012C;
            else if(tx_link_rate_mem == 2'b01)
              rcnf_data <= 16'h012C;
            else
              rcnf_data <= 16'h03AC;
          end
          FEAT_TX_REFCLK2: // This uses "TX PLL" logical channels
          begin
            if(rcnf_logical_ch != (RX_LANES + TX_LANES))
            begin
              // For bonded TX, skip lanes 1, 2 and 3 (only PLL for lane 0 exists)
              start_single_reconfig <= 1'b0;
              fsm_state <= FSM_NEXT_LANE;
            end
            else
            begin
              rcnf_address        <= STREAM_CHANNEL_REG;
              rcnf_feature_offset <= 16'h000E;
              if(tx_hdmi_busy)
                rcnf_data <= (HDMI_CLKX2 == 0) ? 16'h0D01 : 16'h1501;
              else if(tx_link_rate_mem == 2'b00)
                rcnf_data <= 16'h6601;
              else if(tx_link_rate_mem == 2'b01)
                rcnf_data <= 16'h1501;
              else
                rcnf_data <= 16'h1C01;
            end
          end
          FEAT_TX_REFCLK3: // This uses "TX PLL" logical channels
          begin
            if(rcnf_logical_ch != (RX_LANES + TX_LANES))
            begin
              // For bonded TX, skip lanes 1, 2 and 3 (only PLL for lane 0 exists)
              start_single_reconfig <= 1'b0;
              fsm_state <= FSM_NEXT_LANE;
            end
            else
            begin
              rcnf_address        <= STREAM_CHANNEL_REG;
              rcnf_feature_offset <= 16'h0010;
              if(tx_hdmi_busy)
                rcnf_data <= 16'h8450;
              else if(tx_link_rate_mem == 2'b00)
                rcnf_data <= 16'h8360;
              else if(tx_link_rate_mem == 2'b01)
                rcnf_data <= 16'h8450;
              else
                rcnf_data <= 16'h8450;
            end
          end
          FEAT_TX_REFCLK4: // This uses "TX PLL" logical channels
          begin
            if(rcnf_logical_ch != (RX_LANES + TX_LANES))
            begin
              // For bonded TX, skip lanes 1, 2 and 3 (only PLL for lane 0 exists)
              start_single_reconfig <= 1'b0;
              fsm_state <= FSM_NEXT_LANE;
            end
            else
            begin
              rcnf_address        <= STREAM_CHANNEL_REG;
              rcnf_feature_offset <= 16'h0011;
              if(tx_hdmi_busy)
                rcnf_data <= (HDMI_CLKX2 == 0) ? 16'h4021 : 16'h4001;
              else
                rcnf_data <= 16'h4021;
            end
          end
          FEAT_TX_REFCLK5: // This uses "TX PLL" logical channels
          begin
            if(rcnf_logical_ch != (RX_LANES + TX_LANES))
            begin
              // For bonded TX, skip lanes 1, 2 and 3 (only PLL for lane 0 exists)
              start_single_reconfig <= 1'b0;
              fsm_state <= FSM_NEXT_LANE;
            end
            else
            begin
              rcnf_address        <= PLL_CHANNEL_REG;
              rcnf_feature_offset <= REFCLK_FEATURE_OFFS;
              if(tx_hdmi_busy)
                rcnf_data <= 16'h0001; // Use reference clock input #1
              else
                rcnf_data <= 16'h0000; // Use reference clock input #0
            end
          end

        endcase

      end

      FSM_WAIT_FOR_BUSY_HIGH:
        if(reconfig_busy) 
          fsm_state <= FSM_WAIT_FOR_BUSY_LOW;
    
      FSM_WAIT_FOR_BUSY_LOW:
        if(!reconfig_busy) 
          fsm_state <= FSM_NEXT_LANE;
    
      FSM_NEXT_LANE: // Reconfigure the feature for all the lanes
      begin
        if((rx_lrate_busy  & (lane_idx + 1 < RX_LANES)) |
           (tx_lrate_busy  & (lane_idx + 1 < TX_LANES)) |
           (tx_analog_busy & (lane_idx + 1 < TX_LANES)) |
           (tx_hdmi_busy   & (lane_idx + 1 < TX_LANES)))
        begin
          // Go to next lane
          lane_idx <= lane_idx + 2'd1;
          rcnf_logical_ch <= rcnf_logical_ch + 4'd1;
          fsm_state <= FSM_FEAT_RECONFIG;
        end
        else if(rx_lrate_busy)
          fsm_state <= FSM_NEXT_RX_LRATE_FEATURE;
        else if(tx_lrate_busy)
          fsm_state <= FSM_NEXT_TX_LRATE_FEATURE;
        else if(tx_hdmi_busy)
          fsm_state <= FSM_NEXT_HDMI_FEATURE;
        else
          fsm_state <= FSM_NEXT_TX_ANALOG_FEATURE;
      end
      
      FSM_NEXT_RX_LRATE_FEATURE:
      begin
        if(write_cnt == 3*RX_LANES) 
          fsm_state <= FSM_END_RECONFIG;
        else
        begin
          // Next feature
          feature_idx <= feature_idx + 4'd1;
          rcnf_logical_ch <= 4'h0; // Always reconfig RX channel (logical channels start from zero)
          lane_idx <= 2'd0;
          fsm_state <= FSM_FEAT_RECONFIG;
        end
      end
      
      FSM_NEXT_TX_LRATE_FEATURE:
      begin
        if(write_cnt == 5*TX_LANES) 
          fsm_state <= FSM_END_RECONFIG;
        else
        begin
          // Next feature
          feature_idx <= feature_idx + 4'd1;
          if(write_cnt < 1*TX_LANES) 
            rcnf_logical_ch <= RX_LANES; // Now reconfig TX channel (TX logical channels follow RX ones)
          else
            rcnf_logical_ch <= RX_LANES + TX_LANES; // Now reconfig TX PLL (logical channels start from RX_LANES + TX_LANES)
          lane_idx <= 2'd0;
          fsm_state <= FSM_FEAT_RECONFIG;
        end
      end
     
      FSM_NEXT_TX_ANALOG_FEATURE:
      begin
        if(write_cnt == 2*TX_LANES) 
          fsm_state <= FSM_END_RECONFIG;
        else
        begin
          // Next feature
          feature_idx <= feature_idx + 4'd1;
          rcnf_logical_ch <= RX_LANES; // Always reconfigure TX channel (TX logical channels follow RX ones)
          lane_idx <= 2'd0;
          fsm_state <= FSM_FEAT_RECONFIG;
        end
      end
     
      FSM_NEXT_HDMI_FEATURE:
      begin
        if(write_cnt == 7*TX_LANES) 
          fsm_state <= FSM_END_RECONFIG;
        else
        begin
          // Next feature
          feature_idx <= feature_idx + 4'd1;
          if(write_cnt < 3*TX_LANES) 
            rcnf_logical_ch <= RX_LANES; // Now reconfig TX channel (TX logical channels follow RX ones)
          else
            rcnf_logical_ch <= RX_LANES + TX_LANES; // Now reconfig TX PLL (logical channels start from RX_LANES + TX_LANES)
          lane_idx <= 2'd0;
          fsm_state <= FSM_FEAT_RECONFIG;
        end
      end
     
      FSM_END_RECONFIG:
      begin
        rx_lrate_busy <= 1'b0;
        tx_lrate_busy <= 1'b0;
        tx_analog_busy <= 1'b0;
        tx_hdmi_busy <= 1'b0;
        fsm_state <= FSM_IDLE;
      end
    
    endcase
    
  end // if(reset)
end // always

// Keep the RX under reset during reconfiguration
assign rx_analogreset  = rx_xcvr_busy ? 4'b1111 : rx_analogreset_in;
assign rx_digitalreset = rx_xcvr_busy ? 4'b1111 : rx_digitalreset_in;

// Instantiate the Avalon MM Master connected to the Reconfiguration Controller
bitec_reconfig_avalon_mm_master bitec_reconfig_avalon_mm_master_i
(
  .clk          (clk),
  .reset        (reset),

  .rcnf_reconfig        (start_single_reconfig),
  .rcnf_address         (rcnf_address),
  .rcnf_logical_ch      (rcnf_logical_ch),
  .rcnf_feature_offset  (rcnf_feature_offset),
  .rcnf_data            ({16'd0,rcnf_data}),

  .mgmt_address       (mgmt_address), 
  .mgmt_writedata     (mgmt_writedata),    
  .mgmt_write         (mgmt_write),      
  .mgmt_waitrequest   (mgmt_waitrequest),
  .reconfig_busy      (reconfig_busy)   
);


endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//----------------------------------------------
// Avalon MM Master for driving the
// Reconfiguration Controller management interface
//----------------------------------------------

module bitec_reconfig_avalon_mm_master 
(

  input wire clk,
  input wire reset,

  input wire rcnf_reconfig,               // Assert for 1 clk cycle to trigger reconfig
  input wire [6:0] rcnf_address,          // Logical channel address
  input wire [3:0] rcnf_logical_ch,       // Logical channel number
  input wire [15:0] rcnf_feature_offset,  // Feature offset value
  input wire [31:0] rcnf_data,            // Data offset value

  // Reconfig controller interface
  output reg [6:0] mgmt_address,
  output reg [31:0] mgmt_writedata,
  output reg mgmt_write,
  input  wire mgmt_waitrequest,
  input  wire reconfig_busy
);

// State variables
localparam  IDLE = 0,
            WRITE_CH = 1,
            WRITE_MIF_MODE_1 = 2,
            WRITE_FEATURE_OFFSET = 3,
            WRITE_DATA_VALUE = 4,
            WRITE_DATA = 5,
            END_RECONFIG = 6;

localparam MIF_MODE_1_VAL = 32'b0000_0000_0000_0100;

reg [2:0] state;
wire [6:0] cs_address = rcnf_address + 7'h2;
wire [6:0] feature_offset_address = rcnf_address + 7'h3;
wire [6:0] data_address = rcnf_address + 7'h4;
wire rcnf_mif_mode_1 = (rcnf_address == 7'h38) ? 1'b1 : 1'b0; // 1 = MIF Mode 1 used (for Streamer Registers)    

always @ (posedge clk or posedge reset) 
begin
  if(reset) 
  begin
    state <= IDLE;
    mgmt_address  <= 7'h0;
    mgmt_write <= 1'h0;
    mgmt_writedata <= 32'h0;
  end
  else
    case (state)
      IDLE:
      begin
        mgmt_write <= 1'b0;  
        if (rcnf_reconfig && !reconfig_busy) 
          state <= WRITE_CH;
      end
      
      WRITE_CH: 
        if (!mgmt_waitrequest) 
        begin
          mgmt_address   <= rcnf_address;
          mgmt_writedata <= {28'h0,rcnf_logical_ch};  
          mgmt_write     <= 1'b1;  
          if (rcnf_mif_mode_1)
            state <= WRITE_MIF_MODE_1;
          else
            state <= WRITE_FEATURE_OFFSET;
        end
        
      WRITE_MIF_MODE_1: 
        if (!mgmt_waitrequest) 
        begin
          mgmt_address   <= cs_address;
          mgmt_writedata <= MIF_MODE_1_VAL;  
          mgmt_write     <= 1'b1;  
          state <= WRITE_FEATURE_OFFSET;
        end

      WRITE_FEATURE_OFFSET:
        if (!mgmt_waitrequest) 
        begin
          mgmt_address   <= feature_offset_address;
          mgmt_writedata <= {16'h0,rcnf_feature_offset};  
          mgmt_write     <= 1'b1;  
          state <= WRITE_DATA_VALUE;
        end
    
      WRITE_DATA_VALUE:
        if (!mgmt_waitrequest) 
        begin
          mgmt_address   <= data_address;
          mgmt_writedata <= rcnf_data;  
          mgmt_write     <= 1'b1;  
          state <= WRITE_DATA;
        end
    
      WRITE_DATA:
        if (!mgmt_waitrequest) 
        begin
          mgmt_address   <= cs_address;
          mgmt_writedata <= rcnf_mif_mode_1 ? (MIF_MODE_1_VAL | 32'h1) : 32'h1; 
          mgmt_write     <= 1'b1;  
          state <= END_RECONFIG;
        end
    
      END_RECONFIG:
        begin
          mgmt_write <= 1'b0;  
          state <= IDLE;
        end
      endcase
  end
endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//----------------------------------------------
// Map DisplayPort Voltage swing / Pre-emphasis
// to transceiver VOD / EMP settings
//----------------------------------------------

module dp_analog_mappings 
#(
  parameter DEVICE_FAMILY = "Stratix V"
)
(
  input  wire [1:0]   in_vod,  
  input  wire [1:0]   in_emp, 
  output reg  [5:0]   out_vod, 
  output reg  [4:0]   out_emp
);

  // Settings are based on family
  generate begin
    case (DEVICE_FAMILY)
      "Stratix V":
      begin : sv
        always @(*)
          case (in_vod)
            2'b00 :
            begin
              out_vod = 6'd20;      //400mv
              case(in_emp) 
                2'b00 : out_emp = 5'h0; // (0db)
                2'b01 : out_emp = 5'h6; // (3.5db)
                2'b10 : out_emp = 5'h9; // (6.1db)
                2'b11 : out_emp = 5'hb; // (9.5db)
              endcase
            end
            2'b01 :
            begin
              out_vod = 6'd30;      //600mv
              case(in_emp) 
                2'b00 : out_emp = 5'h0; // (0db)
                2'b01 : out_emp = 5'h9; // (3.5db)
                2'b10 : out_emp = 5'he; // (6.1db)
                2'b11 : out_emp = 5'he; // Unused
              endcase
            end
            2'b10 :
            begin
              out_vod = 6'd40;      //800mv
              case(in_emp) 
                2'b00 : out_emp = 5'h0; // (0db)
                2'b01 : out_emp = 5'hc; // (3.4db)
                2'b10 : out_emp = 5'hc; // Unused
                2'b11 : out_emp = 5'hc; // Unused
              endcase
            end
            2'b11 :
            begin
              out_vod = 6'd60;      //1200mv
              case(in_emp) 
                2'b00 : out_emp = 5'h0; // (0db)
                2'b01 : out_emp = 5'h0; // Unused
                2'b10 : out_emp = 5'h0; // Unused
                2'b11 : out_emp = 5'h0; // Unused
              endcase
            end
          endcase
      end // Stratix V

      "Arria V":
      begin : av
        always @(*)
          case (in_vod)
            2'b00 :
            begin
              out_vod = 6'd20;      //400mv
              case(in_emp) 
                2'b00 : out_emp = 5'h0; // (0db)
                2'b01 : out_emp = 5'h4; // (3.31db)
                2'b10 : out_emp = 5'h7; // (5.99db)
                2'b11 : out_emp = 5'ha; // (9.04db)
              endcase
            end
            2'b01 :
            begin
              out_vod = 6'd30;      //600mv
              case(in_emp) 
                2'b00 : out_emp = 5'h0; // (0db)
                2'b01 : out_emp = 5'h6; // (3.11db)
                2'b10 : out_emp = 5'hb; // (6.09db)
                2'b11 : out_emp = 5'hb; // Unused
              endcase
            end
            2'b10 :
            begin
              out_vod = 6'd40;      //800mv
              case(in_emp) 
                2'b00 : out_emp = 5'h0; // (0db)
                2'b01 : out_emp = 5'h9; // (3.38db)
                2'b10 : out_emp = 5'h9; // Unused
                2'b11 : out_emp = 5'h9; // Unused
              endcase
            end
            2'b11 :
            begin
              out_vod = 6'd60;      //1200mv
              case(in_emp) 
                2'b00 : out_emp = 5'h0; // (0db)
                2'b01 : out_emp = 5'h0; // Unused
                2'b10 : out_emp = 5'h0; // Unused
                2'b11 : out_emp = 5'h0; // Unused
              endcase
            end
          endcase
      end // End Arria V

      "Arria V GZ":
      begin : avgz
        // AV GZ uses same settings as SV
        always @(*)
          case (in_vod)
            2'b00 :
            begin
              out_vod = 6'd20;      //400mv
              case(in_emp) 
                2'b00 : out_emp = 5'h0; // (0db)
                2'b01 : out_emp = 5'h6; // (3.5db)
                2'b10 : out_emp = 5'h9; // (6.1db)
                2'b11 : out_emp = 5'hb; // (9.5db)
              endcase
            end
            2'b01 :
            begin
              out_vod = 6'd30;      //600mv
              case(in_emp) 
                2'b00 : out_emp = 5'h0; // (0db)
                2'b01 : out_emp = 5'h9; // (3.5db)
                2'b10 : out_emp = 5'he; // (6.1db)
                2'b11 : out_emp = 5'he; // Unused
              endcase
            end
            2'b10 :
            begin
              out_vod = 6'd40;      //800mv
              case(in_emp) 
                2'b00 : out_emp = 5'h0; // (0db)
                2'b01 : out_emp = 5'hc; // (3.4db)
                2'b10 : out_emp = 5'hc; // Unused
                2'b11 : out_emp = 5'hc; // Unused
              endcase
            end
            2'b11 :
            begin
              out_vod = 6'd60;      //1200mv
              case(in_emp) 
                2'b00 : out_emp = 5'h0; // (0db)
                2'b01 : out_emp = 5'h0; // Unused
                2'b10 : out_emp = 5'h0; // Unused
                2'b11 : out_emp = 5'h0; // Unused
              endcase
            end
          endcase
      end // End Arria V GZ

      "Cyclone V":
      begin : cv
        // Need to look up values, using Cyclone V values for
        // now
        always @(*)
          case (in_vod)
            2'b00 :
            begin
              out_vod = 6'd20;      //400mv
              case(in_emp) 
                2'b00 : out_emp = 5'h0; // (0db)
                2'b01 : out_emp = 5'h4; // (3.31db)
                2'b10 : out_emp = 5'h7; // (5.99db)
                2'b11 : out_emp = 5'ha; // (9.04db)
              endcase
            end
            2'b01 :
            begin
              out_vod = 6'd30;      //600mv
              case(in_emp) 
                2'b00 : out_emp = 5'h0; // (0db)
                2'b01 : out_emp = 5'h6; // (3.11db)
                2'b10 : out_emp = 5'hb; // (6.09db)
                2'b11 : out_emp = 5'hb; // Unused
              endcase
            end
            2'b10 :
            begin
              out_vod = 6'd40;      //800mv
              case(in_emp) 
                2'b00 : out_emp = 5'h0; // (0db)
                2'b01 : out_emp = 5'h9; // (3.38db)
                2'b10 : out_emp = 5'h9; // Unused
                2'b11 : out_emp = 5'h9; // Unused
              endcase
            end
            2'b11 :
            begin
              out_vod = 6'd60;      //1200mv
              case(in_emp) 
                2'b00 : out_emp = 5'h0; // (0db)
                2'b01 : out_emp = 5'h0; // Unused
                2'b10 : out_emp = 5'h0; // Unused
                2'b11 : out_emp = 5'h0; // Unused
              endcase
            end
          endcase
      end // End Cyclone V
    endcase
  end // generate
  endgenerate

endmodule

// synthesis translate_off

module bitec_reconfig_tb();

localparam TX_LANES=4, RX_LANES=4;

reg clk,reset;
reg rx_link_rate_strobe,tx_link_rate_strobe,tx_vodemp_strobe,tx_hdmi_en;

wire [6:0] mgmt_address;
wire [31:0] mgmt_writedata;
wire mgmt_write;
wire mgmt_waitrequest;
wire reconfig_busy;

always
begin
  #50 clk <= 0;
  #50 clk <= 1;
end

bitec_reconfig_alt_av 
#(
  .TX_LANES   (TX_LANES),
  .RX_LANES   (RX_LANES)
)
dut
(
  .clk      (clk),                
  .reset    (reset),               

  .rx_link_rate         (2'b01),  
  .rx_link_rate_strobe  (rx_link_rate_strobe),
  .rx_xcvr_busy         (),    

  .tx_link_rate         (8'h14),  
  .tx_vod               (8'b00000000), 
  .tx_emp               (8'b10101010), 
  .tx_link_rate_strobe  (tx_link_rate_strobe),
  .tx_vodemp_strobe     (tx_vodemp_strobe),
  .tx_hdmi_en           (tx_hdmi_en),
  .tx_xcvr_busy         (),    
  .tx_xcvr_reset        (),

  .mgmt_address         (mgmt_address),
  .mgmt_writedata       (mgmt_writedata),
  .mgmt_readdata        (0),
  .mgmt_write           (mgmt_write),
  .mgmt_read            (),
  .mgmt_waitrequest     (mgmt_waitrequest),
  .reconfig_busy        (reconfig_busy),
  .rx_cal_busy          (0),
  .tx_cal_busy          (0)
);

// Instantiate model of reconfig controller
reconfig_model reconfig_model_i 
(
  .clk              (clk),
  .reset            (reset),
  .mgmt_address     (mgmt_address),    
  .mgmt_writedata   (mgmt_writedata),  
  .mgmt_write       (mgmt_write),        
  .mgmt_waitrequest (mgmt_waitrequest),    
  .reconfig_busy    (reconfig_busy)
);

initial
begin

  #1
  
  rx_link_rate_strobe = 0;
  tx_link_rate_strobe = 0;
  tx_vodemp_strobe = 0;
  tx_hdmi_en = 0;
  
  reset = 1;
  #100
  reset = 0;

  #500
  tx_link_rate_strobe = 1;
  #100
  tx_link_rate_strobe = 0;
  #12000
  rx_link_rate_strobe = 1;
  #100
  rx_link_rate_strobe = 0;
  #12000
  tx_vodemp_strobe = 1;
  #100
  tx_vodemp_strobe = 0;
  
  #12000
  tx_hdmi_en = 1;
  #100
  tx_hdmi_en = 0;
  #100
  tx_hdmi_en = 1;
  #600
  tx_hdmi_en = 0;
  #800
  tx_hdmi_en = 1;
  #800
  tx_hdmi_en = 0;
  #800
  tx_hdmi_en = 1;

  #7000
  tx_link_rate_strobe = 1;
  #100
  tx_link_rate_strobe = 0;
  
end

endmodule

// *********************************************************************
// This is a simple behavioral model of the reconfig controller used 
// for simulation testing.
// *********************************************************************
module reconfig_model 
(
  input wire clk,
  input wire reset,

  input wire [6:0] mgmt_address,
  input wire [31:0] mgmt_writedata,
  input wire mgmt_write,        
  output reg mgmt_waitrequest,    
  output reg reconfig_busy
);

// State variables
localparam  IDLE = 0, WRITE = 1, START_BUSY = 2, END_BUSY = 3;

reg [1:0] state;
integer writes;

always @ (posedge clk or posedge reset) begin : STATE_REG
  if (reset) begin

    state <= IDLE;

    // Initialize the outputs to 0
    mgmt_waitrequest  <= 1'b0;
    reconfig_busy     <= 1'b0;
    writes        <= 0;
  end
  else
    case (state)
    IDLE:
      begin
        mgmt_waitrequest  <= 1'b0;
        reconfig_busy     <= 1'b0;
        writes        <= 0;

        // When we see a write increment the write counter and move to WRITE state
        if (mgmt_write)
        begin
          writes      <= writes + 1;
          state     <= WRITE;
        end
      end

    WRITE: 
      // Wait for 4 writes and then set the busy flag
      if (mgmt_write)
      begin
        if (writes < 3) writes <= writes + 1;
        else      state  <= START_BUSY;
      end

    START_BUSY:
      begin
        reconfig_busy <= 1'b1;  
        state     <= END_BUSY;
      end

    END_BUSY:
      begin
        reconfig_busy <= 1'b0;  
        state     <= IDLE;
      end
    endcase
end
endmodule

// synthesis translate_on


`default_nettype wire
