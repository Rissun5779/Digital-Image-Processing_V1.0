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


module hdmi_rx_top #(
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
   	
   input  wire [2:0]                              rx_serial_data,
   output wire                                    gxb_rx_ready,
     
   input  wire [209:0]                            reconfig_to_rx,
   output wire [137:0]                            reconfig_from_rx,
   input  wire                                    reconfig_busy,
   output wire [8:0]                              reconfig_mgmt_address,
   output wire                                    reconfig_mgmt_read,
   input  wire [31:0]                             reconfig_mgmt_readdata,
   input  wire                                    reconfig_mgmt_waitrequest,
   output wire                                    reconfig_mgmt_write,
   output wire [31:0]                             reconfig_mgmt_writedata,   
     
   output wire                                    audio_de,
   output wire [255:0]                            audio_data,
   output wire [47:0]                             audio_info_ai,   
   output wire [19:0]                             audio_N,
   output wire [19:0]                             audio_CTS,
   output wire [164:0]                            audio_metadata,
   output wire [4:0]                              audio_format,
   output wire [5:0]                              gcp,
   output wire [111:0]                            info_avi,
   output wire [60 :0]                            info_vsi,
   output wire [2:0]                              locked,
   output wire [71:0]                             aux_data,
   output wire                                    aux_sop,
   output wire                                    aux_eop,
   output wire                                    aux_valid,
   output wire [71:0]                             aux_pkt_data,
   output wire [5:0]                              aux_pkt_addr,
   output wire                                    aux_pkt_wr,
   output wire                                    aux_error,
   output wire [SYMBOLS_PER_CLOCK*48-1:0]         vid_data,
   output wire [SYMBOLS_PER_CLOCK-1:0]            vid_vsync,
   output wire [SYMBOLS_PER_CLOCK-1:0]            vid_hsync,
   output wire [SYMBOLS_PER_CLOCK-1:0]            vid_de,
   output wire                                    vid_lock,
   input  wire                                    in_5v_power,
   input  wire                                    in_hpd,
   output wire                                    mode,
   output wire [SYMBOLS_PER_CLOCK*6-1:0]          ctrl,
     
   //inout  wire                                    hdmi_rx_i2c_sda,
   //inout  wire                                    hdmi_rx_i2c_scl,
   //input  wire                                    i2c_clk,
   //output wire [7:0]                              scdc_i2c_rdata,
   //input  wire                                    scdc_i2c_w,
   //input  wire                                    scdc_i2c_r,
   //input  wire [7:0]                              scdc_i2c_addr,
   //input  wire [7:0]                              scdc_i2c_wdata,
	
   output wire                                    os,
   output wire [23:0]                             measure,
   output wire                                    measure_valid
);


//
// Rx Native PHY Transceiver
//
wire [2:0]                        rx_analogreset;
wire [2:0]                        rx_digitalreset;
wire [3:0]                        rx_busy;
wire [2:0]                        rx_set_locktoref;
wire [2:0]                        rx_freqlocked;
wire [2:0]                        rx_is_lockedtoref;
wire [3*SYMBOLS_PER_CLOCK*10-1:0] rx_data;
wire [2:0]                        rx_clk;
wire                              hdmi_rx_clk;

gxb_rx u_gxb_rx (
   /* I */ .rx_cdr_refclk ({hdmi_clk_in, hdmi_rx_clk}),
   /* O */ .reconfig_to_xcvr (reconfig_to_rx),
   /* I */ .rx_analogreset (rx_analogreset),
   /* I */ .rx_digitalreset (rx_digitalreset),
   /* I */ .rx_serial_data (rx_serial_data),
   /* I */ .rx_std_coreclkin (rx_clk),
   /* O */ .reconfig_from_xcvr (reconfig_from_rx),
   /* O */ .rx_cal_busy (rx_busy[2:0]),
   /* I */ .rx_set_locktoref (rx_set_locktoref),
   /* I */ .rx_set_locktodata (3'b000),
   /* O */ .rx_is_lockedtodata (rx_freqlocked[2:0]),
   /* O */ .rx_is_lockedtoref (rx_is_lockedtoref[2:0]),
   /* O */ .rx_parallel_data (rx_data),
   /* O */ .rx_std_clkout (rx_clk)
);

//
// Rx Transceiver Reset Controller
//
wire       reset_xcvr;
wire [2:0] rx_datalock;
wire [2:0] rx_reset_is_lockedtodata;
assign rx_reset_is_lockedtodata = &rx_set_locktoref ? rx_is_lockedtoref : rx_freqlocked;

gxb_rx_reset u_gxb_rx_reset (
   /* I */ .clock (mgmt_clk),
   /* I */ .reset (reset_xcvr),
   /* I */ .rx_cal_busy (rx_busy),
   /* I */ .rx_is_lockedtodata (rx_reset_is_lockedtodata),
   /* O */ .rx_analogreset (rx_analogreset),
   /* O */ .rx_digitalreset (rx_digitalreset),
   /* O */ .rx_ready (rx_datalock),
   /* I */ .rx_manual (3'b000) 
);

assign gxb_rx_ready = &rx_datalock;
   
//
// HDMI Rx core
//
wire [2:0] rx_core_ready;
wire       ls_clk;
wire       vid_clk;
wire       reset_core;
   
assign rx_core_ready = rx_datalock & {3{~reset_core}};

mr_hdmi_rx_core_top #(
   .SUPPORT_AUDIO (SUPPORT_AUDIO),
   .SUPPORT_AUXILIARY (SUPPORT_AUXILIARY),
   .SUPPORT_DEEP_COLOR (SUPPORT_DEEP_COLOR),
   .SYMBOLS_PER_CLOCK (SYMBOLS_PER_CLOCK)
) u_hdmi_rx (
   /* I */ .reset (mgmt_clk_reset),
   /* I */ .rx_clk (rx_clk),
   /* I */ .ls_clk (ls_clk),
   /* I */ .vid_clk (vid_clk),
   /* I */ .os (os),
   /* I */ .rx_parallel_data (rx_data),
   /* I */ .rx_datalock (rx_core_ready),
   /* O */ .aux_data (aux_data),
   /* O */ .aux_valid (aux_valid),
   /* O */ .aux_sop (aux_sop),
   /* O */ .aux_eop (aux_eop),
   /* O */ .audio_CTS (audio_CTS),
   /* O */ .audio_N (audio_N),	
   /* O */ .audio_data (audio_data),     
   /* O */ .audio_de (audio_de),
   /* O */ .audio_metadata (audio_metadata),
   /* O */ .audio_format (audio_format),   
   /* O */ .aux_pkt_addr (aux_pkt_addr),
   /* O */ .aux_pkt_data (aux_pkt_data),
   /* O */ .aux_pkt_wr (aux_pkt_wr),
   /* O */ .aux_error (aux_error),
   /* O */ .gcp (gcp),
   /* O */ .audio_info_ai (audio_info_ai),
   /* O */ .info_avi (info_avi),
   /* O */ .info_vsi (info_vsi),
   /* O */ .locked (locked),
   /* O */ .vid_data (vid_data),
   /* O */ .vid_de (vid_de),
   /* O */ .vid_hsync (vid_hsync),
   /* O */ .vid_vsync (vid_vsync),
   /* O */ .vid_lock (vid_lock),
   /* I */ .in_5v_power (in_5v_power), 
   /* I */ .in_hpd (in_hpd), 
   /* O */ .mode (mode),
   /* O */ .ctrl (ctrl)	     
   /* I */ //.scdc_i2c_clk (i2c_clk),
   /* I */ //.scdc_i2c_addr (scdc_i2c_addr),
   /* O */ //.scdc_i2c_rdata (scdc_i2c_rdata),
   /* I */ //.scdc_i2c_wdata (scdc_i2c_wdata),
   /* I */ //.scdc_i2c_r (scdc_i2c_r),
   /* I */ //.scdc_i2c_w (scdc_i2c_w),
   /* O */ //.TMDS_Bit_clock_Ratio (TMDS_Bit_clock_Ratio)
);

//
// GPLL to generate HDMI clocks
//
wire        reset_pll;
wire [63:0] reconfig_to_pll;
wire [63:0] reconfig_from_pll;
pll_hdmi u_pll_hdmi (   
   /* I */ .refclk (hdmi_clk_in),
   /* I */ .rst (reset_pll), 
   /* O */ .outclk_0 (hdmi_rx_clk),
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
wire        reset_pll_reconfig;
wire        pll_reconfig_waitrequest;
wire [5:0]  pll_reconfig_address;
wire        pll_reconfig_write;
wire [31:0] pll_reconfig_writedata;

pll_reconfig u_pll_reconfig (
   /* I */ .mgmt_clk (mgmt_clk),
   /* I */ .mgmt_reset (mgmt_clk_reset | reset_pll_reconfig),
   /* O */ .mgmt_waitrequest (pll_reconfig_waitrequest),
   /* I */ .mgmt_read (1'b0),
   /* I */ .mgmt_write (pll_reconfig_write),
   /* O */ .mgmt_readdata (),
   /* I */ .mgmt_address (pll_reconfig_address),
   /* I */ .mgmt_writedata (pll_reconfig_writedata),
   /* O */ .reconfig_to_pll (reconfig_to_pll),
   /* I */ .reconfig_from_pll (reconfig_from_pll)
);

wire [3:0] bpc;
wire [3:0] bpc_sync;
assign bpc = gcp[3:0];
clock_crosser #(.W(4)) cc_bpc (.in(bpc), .out(bpc_sync), .in_clk(ls_clk),.out_clk(mgmt_clk),.in_reset(0),.out_reset(0));

//
// RX reconfig management
//
mr_reconfig_mgmt_av #(
   .CONFIG_TYPE (0),
   .RX_STARTING_LOGICAL (0),
   .RX_DEFAULT_RANGE (1),
   .PLL_DEFAULT_RANGE (3),
   .CYC_MEASURE_CLK_IN_10_MSEC (24'd750000)
) reconfig_mgmt_inst (
   /* I */ .sys_clk (mgmt_clk),
   /* I */ .sys_clk_rst (mgmt_clk_reset),
   /* I */ .refclock (hdmi_clk_in),
   /* I */ .rx_ready (gxb_rx_ready),
   /* I */ .tx_ready (1'b1),
   /* I */ .rx_locked (locked),
   /* I */ .bpc (bpc_sync),	
   /* I */ .pll_locked (gpll_locked),
   /* O */ .reset_xcvr (reset_xcvr),
   /* O */ .reset_core (reset_core),
   /* O */ .reset_pll_reconfig (reset_pll_reconfig),
   /* O */ .reset_pll (reset_pll),
   /* O */ .rx_set_locktoref (rx_set_locktoref),  
   /* I */ .xcvr_reconfig_busy (reconfig_busy),
   /* O */ .xcvr_reconfig_address (reconfig_mgmt_address),
   /* O */ .xcvr_reconfig_read (reconfig_mgmt_read),
   /* I */ .xcvr_reconfig_readdata (reconfig_mgmt_readdata),
   /* I */ .xcvr_reconfig_waitrequest (reconfig_mgmt_waitrequest),
   /* O */ .xcvr_reconfig_write (reconfig_mgmt_write),
   /* O */ .xcvr_reconfig_writedata (reconfig_mgmt_writedata),
   /* I */ .pll_reconfig_waitrequest (pll_reconfig_waitrequest),
   /* O */ .pll_reconfig_address (pll_reconfig_address),
   /* O */ .pll_reconfig_write (pll_reconfig_write),
   /* O */ .pll_reconfig_writedata (pll_reconfig_writedata),
   /* I */ //.tmds_bit_clock_ratio (TMDS_Bit_clock_Ratio),
   /* O */ .measure (measure),
   /* O */ .measure_valid (measure_valid)
);
   
assign os = &rx_set_locktoref;

endmodule
