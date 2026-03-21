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


module hdmi_tx_top #(
   parameter SUPPORT_DEEP_COLOR  = 0,
   parameter SUPPORT_AUXILIARY   = 1,
   parameter SYMBOLS_PER_CLOCK   = 4,
   parameter SUPPORT_AUDIO       = 0
) (
   input  wire                                    mgmt_clk,
   input  wire                                    mgmt_clk_reset,   
   input  wire                                    hdmi_clk_in,
   output wire                                    ls_clk_out,
   output wire                                    vid_clk_out,
   output wire                                    gpll_locked,   

   input  wire                                    reset_xcvr,
   input  wire                                    reset_pll,
   input  wire                                    reset_pll_reconfig,

   output wire [3:0]                              tx_serial_data,
   output wire                                    txpll_locked,
   output wire                                    gxb_tx_ready,

   input  wire [349:0]                            reconfig_to_tx,
   output wire [229:0]                            reconfig_from_tx,
   
   output wire                                    pll_reconfig_waitrequest,
   input  wire                                    pll_reconfig_write,
   input  wire                                    pll_reconfig_read,
   input  wire [5:0]                              pll_reconfig_address,
   input  wire [31:0]                             pll_reconfig_writedata,
   output wire [31:0]                             pll_reconfig_readdata,
   
   input  wire os,
   input  wire                                    mode,
   input  wire [6*SYMBOLS_PER_CLOCK-1:0]          ctrl,
   //input  wire                                    audio_clk,
   input  wire                                    audio_de,
   input  wire                                    audio_mute,
   input  wire [21:0]                             audio_CTS,
   input  wire [255:0]                            audio_data,   
   input  wire [48:0]                             audio_info_ai,
   input  wire [21:0]                             audio_N,
   input  wire [165:0]                            audio_metadata,
   input  wire [4:0]                              audio_format,
   input  wire [5:0]                              gcp,
   input  wire [112:0]                            info_avi,
   input  wire [61:0]                             info_vsi,
   output wire                                    aux_ready,
   input  wire [71:0]                             aux_data,
   input  wire                                    aux_sop,
   input  wire                                    aux_eop,
   input  wire                                    aux_valid,
   input  wire [48*SYMBOLS_PER_CLOCK-1:0]         vid_data,
   input  wire [1*SYMBOLS_PER_CLOCK-1:0]          vid_vsync, 
   input  wire [1*SYMBOLS_PER_CLOCK-1:0]          vid_hsync,
   input  wire [1*SYMBOLS_PER_CLOCK-1:0]          vid_de,
   input  wire                                    Scrambler_Enable,   
   input  wire                                    TMDS_Bit_clock_Ratio
);

//
// Tx Native PHY Transceiver
//
wire                              pll_powerdown;
wire                              tx_pll_refclk;
wire                              tx_plllocked;
wire [3:0]                        tx_analogreset;
wire [3:0]                        tx_digitalreset;
wire [4*SYMBOLS_PER_CLOCK*10-1:0] tx_parallel_data;
wire [3:0]                        tx_std_coreclkin;
wire [3:0]                        tx_cal_busy;
wire [3:0]                        tx_clk;

assign tx_std_coreclkin = {tx_clk[0], tx_clk[0], tx_clk[0], tx_clk[0]};

gxb_tx u_gxb_tx (
   /* I */ .pll_powerdown (pll_powerdown),
   /* I */ .tx_pll_refclk (tx_pll_refclk), 
   /* I */ .reconfig_to_xcvr (reconfig_to_tx),
   /* I */ .tx_analogreset (tx_analogreset),
   /* I */ .tx_digitalreset (tx_digitalreset),
   /* O */ .tx_parallel_data (tx_parallel_data),
   /* I */ .tx_std_coreclkin (tx_std_coreclkin),
   /* O */ .pll_locked (tx_plllocked),
   /* O */ .reconfig_from_xcvr (reconfig_from_tx),
   /* O */ .tx_cal_busy (tx_cal_busy),
   /* I */ .tx_serial_data (tx_serial_data),
   /* O */ .tx_std_clkout (tx_clk)
);

//
// Tx Transceiver Reset Controller
//
wire [3:0] tx_ready;
gxb_tx_reset u_gxb_tx_reset (
   /* I */ .clock (mgmt_clk),
   /* I */ .reset (mgmt_clk_reset),
   /* O */ .tx_ready (tx_ready),
   /* I */ .pll_locked (tx_plllocked),
   /* I */ .pll_select (1'b0), 
   /* I */ .tx_cal_busy (tx_cal_busy),
   /* O */ .pll_powerdown (pll_powerdown),
   /* O */ .tx_analogreset (tx_analogreset),
   /* O */ .tx_digitalreset (tx_digitalreset),
   /* I */ .tx_manual (4'b0000) 
);

assign gxb_tx_ready = &tx_ready;
assign txpll_locked = tx_plllocked;

//
// HDMI Tx core
//
wire vid_clk;
wire ls_clk;

mr_hdmi_tx_core_top #(
   .SUPPORT_AUDIO (SUPPORT_AUDIO),
   .SUPPORT_AUXILIARY (SUPPORT_AUXILIARY),
   .SUPPORT_DEEP_COLOR (SUPPORT_DEEP_COLOR),
   .SYMBOLS_PER_CLOCK (SYMBOLS_PER_CLOCK)
) u_hdmi_tx (
   /* I */ .reset (mgmt_clk_reset | ~(&tx_ready && tx_plllocked && gpll_locked)),
   /* I */ .vid_clk (vid_clk), 
   /* I */ .ls_clk (ls_clk),
   /* I */ .tx_clk (tx_clk[0]),
   /* I */ .os (os),
   /* I */ .mode (mode),
   /* I */ .ctrl (ctrl),					
   /* I */ .audio_clk (ls_clk),
   /* I */ .audio_de (audio_de),
   /* I */ .audio_mute (audio_mute),
   /* I */ .aux_data (aux_data),
   /* I */ .aux_valid (aux_valid),
   /* O */ .aux_ready (aux_ready),         
   /* I */ .aux_sop (aux_sop),
   /* I */ .aux_eop (aux_eop),
   /* I */ .audio_CTS (audio_CTS),
   /* I */ .audio_data (audio_data),
   /* I */ .audio_info_ai (audio_info_ai),
   /* I */ .audio_N (audio_N),
   /* I */ .audio_metadata (audio_metadata),
   /* I */ .audio_format (audio_format),
   /* I */ .gcp (gcp),
   /* I */ .info_avi (info_avi),
   /* I */ .info_vsi (info_vsi),
   /* I */ .vid_data (vid_data), 
   /* I */ .vid_de (vid_de), 
   /* I */ .vid_hsync (vid_hsync),
   /* I */ .vid_vsync (vid_vsync),
   /* I */ .Scrambler_Enable (Scrambler_Enable),
   /* I */ .TMDS_Bit_clock_Ratio (TMDS_Bit_clock_Ratio),
   /* O */ .tx_parallel_data (tx_parallel_data)
);

//
// GPLL to generate HDMI clocks
//
wire [63:0] reconfig_to_pll;
wire [63:0] reconfig_from_pll;
pll_hdmi u_pll_hdmi (   
   /* I */ .refclk (hdmi_clk_in),
   /* I */ .rst (reset_pll), 
   /* O */ .outclk_0 (tx_pll_refclk),
   /* O */ .outclk_1 (ls_clk),
   /* O */ .outclk_2 (vid_clk),
   /* O */ .locked (gpll_locked),
   /* I */ .reconfig_to_pll (reconfig_to_pll),
   /* O */ .reconfig_from_pll (reconfig_from_pll)
);

assign ls_clk_out = ls_clk;
assign vid_clk_out = vid_clk;
   
//
// PLL reconfig controller
//
pll_reconfig u_pll_reconfig (
   /* I */ .mgmt_clk (mgmt_clk),
   /* I */ .mgmt_reset (reset_pll_reconfig),
   /* O */ .mgmt_waitrequest (pll_reconfig_waitrequest),
   /* I */ .mgmt_read (pll_reconfig_read),
   /* I */ .mgmt_write (pll_reconfig_write),
   /* O */ .mgmt_readdata (pll_reconfig_readdata),
   /* I */ .mgmt_address (pll_reconfig_address),
   /* I */ .mgmt_writedata (pll_reconfig_writedata),
   /* O */ .reconfig_to_pll (reconfig_to_pll),
   /* I */ .reconfig_from_pll (reconfig_from_pll)
);

endmodule
