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


module av_sk_demo
(
   input           clkin_50_bot,
   input           clk_in_ddr_100,
   input           cpu_resetn,
   //input           clkin_ch0,
   //input           TMDS_RX_CLK_P,     
   input   [3:0]   rx_serial_data, 
   output  [3:0]   tx_serial_data, 
   inout           hdmi_rx_i2c_sda,
   input           hdmi_rx_i2c_scl,
   inout           hdmi_rx_hpd_n,
   input           hdmi_rx_5v_n,
   output          mem_ck,
   output          mem_ck_n,
   output          mem_cke,
   output          mem_cs_n,
   output          mem_ras_n,
   output          mem_cas_n,
   output          mem_we_n,
   output          mem_reset_n,
   output          mem_odt,
   output  [12:0]  mem_a,
   output  [2:0]   mem_ba,
   output  [3:0]   mem_dm,
   inout   [31:0]  mem_dq,
   inout   [3:0]   mem_dqs,
   inout   [3:0]   mem_dqs_n,
   input           oct_rzqin,
   output  [7:0]   user_led,
   input   [2:0]   user_pb,
   input   [3:0]   user_dipsw	
);

localparam SYMBOLS_PER_CLOCK = 2;
   
wire mgmt_clk;
wire mgmt_clk_reset_sync;
wire clk75;
wire clk100;
wire clk150;
wire reset;
wire i2c_clk;
wire hdmi_clk_in;
wire rx_gpll_locked;   
wire tx_gpll_locked;
wire rx_hdmi_locked;
wire tx_pll_locked;
wire rx_ready;   
wire tx_ready;
wire [2:0] hdmi_rx_locked;
wire rx_os;
wire tx_os;
wire hdmi_rx_hpd_n_tmp;

assign reset = ~cpu_resetn;
assign i2c_clk = clk100;
assign hdmi_clk_in = rx_serial_data[0];

assign rx_hdmi_locked = &hdmi_rx_locked;
assign user_led[0] = ~rx_gpll_locked; // PCIE_LED_G2 (F17)
assign user_led[1] = ~rx_ready;       // PCIE_LED_X8 (G15)
assign user_led[2] = ~rx_hdmi_locked; // PCIE_LED_X4 (G16)
assign user_led[3] = ~rx_os;          // PCIE_LED_X1 (G17)
assign user_led[4] = ~tx_gpll_locked; // USER_LED3 (D16)
assign user_led[5] = ~tx_ready;       // USER_LED2 (C13)
assign user_led[6] = ~tx_pll_locked;  // USER_LED1 (C14)
assign user_led[7] = ~tx_os;          // USER_LED0 (C16)
//assign clkout_sma = clk100;

//assign hdmi_rx_eq_boost1 = 1'b0;
//assign hdmi_rx_pre = 1'b0;
assign hdmi_rx_hpd_n_tmp = user_pb[0] & cpu_resetn;

//
// Generate 75MHz for system (CPU/reconfig) controllers
// Generate 150MHz for VIP pipeline
// 
wire pll_refclk;
wire vid_clk;
wire ddrref_clk;

assign pll_refclk = clkin_50_bot;
pll_sys_50 u_pll_sys (
   /* I */ .refclk   (pll_refclk),
   /* I */ .rst      (reset),
   /* O */ .outclk_0 (clk75),
   /* O */ .outclk_1 (clk150),
   /* O */ .outclk_2 (clk100),
   /* O */ .locked   ()
);

assign ddrref_clk = clk_in_ddr_100; // use a separate clock input for DDR3 refclk
assign vid_clk    = clk150;         // video pipeline clock
assign mgmt_clk   = clk75;          // xcvr reset/reconfig mgmt/cpu clock

//
// Transceiver Reconfig Controller 
// shared between RX and TX transceivers
//
wire         reconfig_busy;
wire [137:0] reconfig_from_rx;
wire [229:0] reconfig_from_tx;
wire [209:0] reconfig_to_rx;
wire [349:0] reconfig_to_tx;
wire [6:0]   xcvr_rcfg_reconfig_mgmt_address;
wire         xcvr_rcfg_reconfig_mgmt_read;
wire [31:0]  xcvr_rcfg_reconfig_mgmt_readdata;
wire         xcvr_rcfg_reconfig_mgmt_waitrequest;
wire         xcvr_rcfg_reconfig_mgmt_write;
wire [31:0]  xcvr_rcfg_reconfig_mgmt_writedata;

gxb_reconfig u_gxb_reconfig (
   /* O */ .reconfig_busy (reconfig_busy),
   /* I */ .reconfig_mgmt_address (xcvr_rcfg_reconfig_mgmt_address),
   /* I */ .reconfig_mgmt_read (xcvr_rcfg_reconfig_mgmt_read),
   /* O */ .reconfig_mgmt_readdata (xcvr_rcfg_reconfig_mgmt_readdata),
   /* O */ .reconfig_mgmt_waitrequest (xcvr_rcfg_reconfig_mgmt_waitrequest),
   /* I */ .reconfig_mgmt_write (xcvr_rcfg_reconfig_mgmt_write), 
   /* I */ .reconfig_mgmt_writedata (xcvr_rcfg_reconfig_mgmt_writedata),
   /* O */ .reconfig_mif_address (),
   /* O */ .reconfig_mif_read (),
   /* I */ .reconfig_mif_readdata (16'd0),
   /* I */ .reconfig_mif_waitrequest (1'd0),
   /* I */ .mgmt_clk_clk (mgmt_clk),
   /* I */ .mgmt_rst_reset (reset), 
   /* I */ .ch0_2_from_xcvr (reconfig_from_rx),
   /* I */ .ch3_7_from_xcvr (reconfig_from_tx),
   /* O */ .ch0_2_to_xcvr (reconfig_to_rx),
   /* O */ .ch3_7_to_xcvr (reconfig_to_tx)
);

//
// Generate system reset upon power up
//
reg [23:0] count = 24'd0;
wire sys_init;
always @ (posedge mgmt_clk)
begin
    if (count < 24'd1000000) begin
        count <= count + 24'd1;
    end
end

assign sys_init = count > 24'd5 && count < 24'd10;

//
// RX Dislay Data Channel (DDC) 
// I2C slave and EDID components
//
wire        i2c_clk_reset_sync;
wire [7:0]  edid_rdata;
wire        edid_w;
wire        edid_r;
wire [31:0] edid_addr;
wire [31:0] edid_wdata;
wire        edid_sda_oe;
wire        i2c_sda_in;
   
reg edid_rdvalid;
always @(posedge i2c_clk)
   edid_rdvalid <= edid_r;
	
i2cslave_to_avlmm_bridge #(
   .I2C_SLAVE_ADDRESS (10'b0001010000),
   .BYTE_ADDRESSING (1),
   .ADDRESS_STEALING (0),
   .READ_ONLY (0)
) u_i2cslave_edid (
   .clk (i2c_clk),
   .rst_n (~i2c_clk_reset_sync),
   .address (edid_addr),
   .read (edid_r),
   .readdata ({24'd0, edid_rdata}),
   .readdatavalid (edid_rdvalid),
   .waitrequest (1'b0),
   .write (edid_w),
   .byteenable (),
   .writedata (edid_wdata),
   .i2c_data_in (i2c_sda_in),
   .i2c_clk_in (hdmi_rx_i2c_scl),
   .i2c_data_oe (edid_sda_oe),
   .i2c_clk_oe ()	    
);
   
output_buf_i2c u_i2c_buf (
   /* I */ .datain (1'b0),
   /* B */ .dataio (hdmi_rx_i2c_sda), 
   /* I */ .oe (edid_sda_oe),
   /* O */ .dataout (i2c_sda_in)
);

output_buf_i2c u_rx_hpd_buf (
   /* I */ .datain (1'b0),
   /* B */ .dataio (hdmi_rx_hpd_n), 
   /* I */ .oe (hdmi_rx_hpd_n_tmp),
   /* O */ .dataout ()
);

hdmi_rx_edid_ram u_edid_ram (
   /* I */ .wren (edid_w),
   /* I */ .clock (i2c_clk),
   /* I */ .address (edid_addr[7:0]),
   /* I */ .data (edid_wdata[7:0]),
   /* O */ .q (edid_rdata)
);

//
// HDMI RX video path and transceiver/PLL control
//
wire [8:0]                             reconfig_mgmt_address;
wire                                   reconfig_mgmt_read;
wire [31:0]                            reconfig_mgmt_readdata;
wire                                   reconfig_mgmt_waitrequest;
wire                                   reconfig_mgmt_write;
wire [31:0]                            reconfig_mgmt_writedata;
wire [SYMBOLS_PER_CLOCK*48-1:0]        hdmi_rx_data;
wire [SYMBOLS_PER_CLOCK-1:0]           hdmi_rx_vsync;
wire [SYMBOLS_PER_CLOCK-1:0]           hdmi_rx_hsync;
wire [SYMBOLS_PER_CLOCK-1:0]           hdmi_rx_de;
wire [SYMBOLS_PER_CLOCK*48-1:0]        hdmi_tx_data;
wire [SYMBOLS_PER_CLOCK-1:0]           hdmi_tx_vsync;
wire [SYMBOLS_PER_CLOCK-1:0]           hdmi_tx_hsync;
wire [SYMBOLS_PER_CLOCK-1:0]           hdmi_tx_de;
wire                                   hdmi_rx_vid_clk;
wire                                   hdmi_rx_ls_clk;
wire [23:0]                            measure;
wire                                   measure_valid;
wire [1:0]                             rx_bpc;
wire                                   rx_audio_de;
wire                                   tx_audio_de;
wire [255:0]                           rx_audio_data;
wire [255:0]                           tx_audio_data;
wire [47:0]                            rx_audio_info_ai;
wire [47:0]                            tx_audio_info_ai;
wire [19:0]                            rx_audio_N;
wire [19:0]                            tx_audio_N;
wire [19:0]                            rx_audio_CTS;
wire [19:0]                            tx_audio_CTS;
wire [164:0]                           rx_audio_metadata;
wire [164:0]                           tx_audio_metadata;
wire [4:0]                             rx_audio_format;
wire [4:0]                             tx_audio_format;
wire [111:0]                           rx_info_avi;
wire [60:0]                            rx_info_vsi;
wire [111:0]                           tx_info_avi;
wire [60:0]                            tx_info_vsi;
//wire                                   TMDS_Bit_clock_Ratio;
wire [5:0]                             rx_gcp;
wire [5:0]                             tx_gcp; 
wire [71:0]                            rx_aux_data;
wire                                   rx_aux_valid;
wire                                   rx_aux_sop;
wire                                   rx_aux_eop;
  
hdmi_rx_top #(
   .SUPPORT_DEEP_COLOR (1),
   .SUPPORT_AUXILIARY (1),
   .SYMBOLS_PER_CLOCK (SYMBOLS_PER_CLOCK),
   .SUPPORT_AUDIO (1)
) u_hdmi_rx_top (
   /* I */ .mgmt_clk (mgmt_clk),
   /* I */ .mgmt_clk_reset (mgmt_clk_reset_sync | sys_init),	 
   /* I */ .hdmi_clk_in (hdmi_clk_in),
   /* O */ .ls_clk_out (hdmi_rx_ls_clk),
   /* O */ .vid_clk_out (hdmi_rx_vid_clk),
   /* O */ .gpll_locked (rx_gpll_locked),
   /* I */ .rx_serial_data (rx_serial_data[3:1]),
   /* O */ .gxb_rx_ready (rx_ready), 
   /* I */ .reconfig_from_rx (reconfig_from_rx),
   /* O */ .reconfig_to_rx (reconfig_to_rx),
   /* I */ .reconfig_busy (reconfig_busy),
   /* O */ .reconfig_mgmt_address (reconfig_mgmt_address),
   /* O */ .reconfig_mgmt_read (reconfig_mgmt_read),
   /* I */ .reconfig_mgmt_readdata (reconfig_mgmt_readdata),
   /* I */ .reconfig_mgmt_waitrequest (reconfig_mgmt_waitrequest),
   /* O */ .reconfig_mgmt_write (reconfig_mgmt_write),
   /* O */ .reconfig_mgmt_writedata (reconfig_mgmt_writedata), 		 
   /* O */ //.TMDS_Bit_clock_Ratio (TMDS_Bit_clock_Ratio),    	
   /* O */ .aux_data (rx_aux_data),
   /* O */ .aux_valid (rx_aux_valid),
   /* O */ .aux_sop (rx_aux_sop),
   /* O */ .aux_eop (rx_aux_eop),
   /* O */ .audio_CTS (rx_audio_CTS), 
   /* O */ .audio_N (rx_audio_N), 
   /* O */ .audio_data (rx_audio_data),
   /* O */ .audio_info_ai (rx_audio_info_ai),		 
   /* O */ .audio_de (rx_audio_de),
   /* O */ .audio_metadata (rx_audio_metadata),
   /* O */ .audio_format (rx_audio_format),
   /* O */ .aux_pkt_addr (),
   /* O */ .aux_pkt_data (),
   /* O */ .aux_pkt_wr (),
   /* O */ .aux_error (),
   /* O */ .gcp (rx_gcp[5:0]),
   /* O */ .info_avi (rx_info_avi),
   /* O */ .info_vsi (rx_info_vsi),
   /* O */ .locked (hdmi_rx_locked),
   /* O */ .vid_data (hdmi_rx_data),
   /* O */ .vid_de (hdmi_rx_de),
   /* O */ .vid_hsync (hdmi_rx_hsync),
   /* O */ .vid_vsync (hdmi_rx_vsync),
   /* O */ .vid_lock (),
   /* I */ .in_5v_power ({~hdmi_rx_5v_n}), // Connect to +5v of HDMI connector
   /* I */ .in_hpd (hdmi_rx_hpd_n_tmp), // Connect to RX HPD of HDMI connector
   /* O */ .mode (),
   /* O */ .ctrl (),
   //.hdmi_rx_i2c_sda (hdmi_rx_i2c_sda),
   //.hdmi_rx_i2c_scl (hdmi_rx_i2c_scl),
   /* I */ //.i2c_clk (i2c_clk),			 
   /* I */ //.scdc_i2c_addr (scdc_addr),
   /* O */ //.scdc_i2c_rdata (scdc_rdata),
   /* I */ //.scdc_i2c_wdata (scdc_wdata),
   /* I */ //.scdc_i2c_r (scdc_r),
   /* I */ //.scdc_i2c_w (scdc_w),
   /* O */ .os (rx_os), // indicate whether rx is operating in LTD/LTR mode
   /* O */ .measure (measure), // clock frequency of RX TMDS clock
   /* O */ .measure_valid (measure_valid)
);

//
// Qsys system for TX reconfig & I2C master (TX DDC)
// Stakeholder for VIP passthrough system
//
wire        hdmi_tx_vid_clk;
wire        hdmi_tx_ls_clk;    
wire [5:0]  tx_gpll_reconfig_mgmt_address;
wire        tx_gpll_reconfig_mgmt_waitrequest;
wire        tx_gpll_reconfig_mgmt_write;
wire [31:0] tx_gpll_reconfig_mgmt_writedata;
wire        tx_gpll_reconfig_mgmt_read;
wire [31:0] tx_gpll_reconfig_mgmt_readdata;
wire [95:0] cvo_data_map;
wire [47:0] cvo_data;
wire [1:0]  cvo_datavalid;
wire [1:0]  cvo_hsync;
wire [1:0]  cvo_vsync;
wire        tx_rst_core;
wire        tx_rst_pll;
wire        tx_rst_xcvr;
wire        wd_reset;
wire [1:0]  cpu_bpc_sync;

clock_crosser #(.W(2)) cc_bpc (.in(rx_gcp[1:0]), .out(cpu_bpc_sync), .in_clk(hdmi_rx_ls_clk),.out_clk(mgmt_clk),.in_reset(0),.out_reset(0));

wire [47:0] video_in_vid_data;
assign video_in_vid_data = {hdmi_rx_data[95:88],hdmi_rx_data[79:72],hdmi_rx_data[63:56],
                            hdmi_rx_data[47:40],hdmi_rx_data[31:24],hdmi_rx_data[15:8]};

qsys_vip_passthrough u_qsys_vip_passthrough (
   .cpu_clk (mgmt_clk),
   .cpu_clk_reset_n (cpu_resetn & ~wd_reset & ~sys_init),
   .rx_rcfg_mgmt_translator_avalon_anti_master_address (reconfig_mgmt_address),
   .rx_rcfg_mgmt_translator_avalon_anti_master_waitrequest (reconfig_mgmt_waitrequest),
   .rx_rcfg_mgmt_translator_avalon_anti_master_read (reconfig_mgmt_read),
   .rx_rcfg_mgmt_translator_avalon_anti_master_readdata (reconfig_mgmt_readdata),
   .rx_rcfg_mgmt_translator_avalon_anti_master_write (reconfig_mgmt_write),
   .rx_rcfg_mgmt_translator_avalon_anti_master_writedata (reconfig_mgmt_writedata),
   .xcvr_rcfg_translator_avalon_anti_slave_waitrequest (xcvr_rcfg_reconfig_mgmt_waitrequest),
   .xcvr_rcfg_translator_avalon_anti_slave_writedata (xcvr_rcfg_reconfig_mgmt_writedata),
   .xcvr_rcfg_translator_avalon_anti_slave_address (xcvr_rcfg_reconfig_mgmt_address),
   .xcvr_rcfg_translator_avalon_anti_slave_write (xcvr_rcfg_reconfig_mgmt_write),
   .xcvr_rcfg_translator_avalon_anti_slave_read (xcvr_rcfg_reconfig_mgmt_read),
   .xcvr_rcfg_translator_avalon_anti_slave_readdata (xcvr_rcfg_reconfig_mgmt_readdata),
   .tx_gpll_rcfg_mgmt_translator_avalon_anti_slave_waitrequest (tx_gpll_reconfig_mgmt_waitrequest),
   .tx_gpll_rcfg_mgmt_translator_avalon_anti_slave_writedata (tx_gpll_reconfig_mgmt_writedata),
   .tx_gpll_rcfg_mgmt_translator_avalon_anti_slave_address (tx_gpll_reconfig_mgmt_address),
   .tx_gpll_rcfg_mgmt_translator_avalon_anti_slave_write (tx_gpll_reconfig_mgmt_write),
   .tx_gpll_rcfg_mgmt_translator_avalon_anti_slave_read (tx_gpll_reconfig_mgmt_read),
   .tx_gpll_rcfg_mgmt_translator_avalon_anti_slave_readdata (tx_gpll_reconfig_mgmt_readdata),
   .measure_pio_external_connection_export (measure),
   .measure_valid_pio_external_connection_export (measure_valid & (&rx_hdmi_locked)),
   .tx_os_pio_external_connection_export (tx_os),
   .tx_rst_core_pio_external_connection_export (tx_rst_core),
   .tx_rst_xcvr_pio_external_connection_export (tx_rst_xcvr),
   .tx_rst_pll_pio_external_connection_export (tx_rst_pll),
   .wd_timer_resetrequest_reset (wd_reset),
   .cvi_video_in_vid_clk (hdmi_rx_vid_clk),
   .cvi_video_in_vid_data (video_in_vid_data),
   .cvi_video_in_vid_de (hdmi_rx_de),
   .cvi_video_in_vid_datavalid (&hdmi_rx_locked),
   .cvi_video_in_vid_locked (&hdmi_rx_locked),
   .cvi_video_in_vid_f (2'b00),
   .cvi_video_in_vid_v_sync (hdmi_rx_vsync),
   .cvi_video_in_vid_h_sync (hdmi_rx_hsync),
   .cvi_video_in_vid_color_encoding (1'b0),
   .cvi_video_in_vid_bit_width (1'b0),
   .cvi_video_in_overflow (),
   .cvo_video_out_vid_clk (hdmi_tx_vid_clk),
   .cvo_video_out_vid_data (cvo_data),
   .cvo_video_out_underflow (),
   .cvo_video_out_vid_mode_change (),
   .cvo_video_out_vid_std (),
   .cvo_video_out_vid_datavalid (cvo_datavalid),
   .cvo_video_out_vid_v_sync (cvo_vsync),
   .cvo_video_out_vid_h_sync (cvo_hsync),
   .cvo_video_out_vid_f (),
   .cvo_video_out_vid_h (),
   .cvo_video_out_vid_v (),
   .memory_mem_a (mem_a),
   .memory_mem_ba (mem_ba),
   .memory_mem_ck (mem_ck),
   .memory_mem_ck_n (mem_ck_n),
   .memory_mem_cke (mem_cke),
   .memory_mem_cs_n (mem_cs_n),
   .memory_mem_dm (mem_dm),
   .memory_mem_ras_n (mem_ras_n),
   .memory_mem_cas_n (mem_cas_n),
   .memory_mem_we_n (mem_we_n),
   .memory_mem_reset_n (mem_reset_n),
   .memory_mem_dq (mem_dq),
   .memory_mem_dqs (mem_dqs),
   .memory_mem_dqs_n (mem_dqs_n),
   .memory_mem_odt (mem_odt),
   .oct_rzqin (oct_rzqin),
   .ddr3_soft_reset_reset_n (1'b1),
   .ddr3_status_local_init_done (),
   .ddr3_status_local_cal_success (),
   .ddr3_status_local_cal_fail (),
   .ddr_clk (ddrref_clk),
   .ddr_clk_reset_n (cpu_resetn),
   //.vid_clk_pll_ref_clk (clk100),
   //.vid_clk_pll_reset (~cpu_resetn),
   .vid_clk (vid_clk),
   .vid_clk_reset_n (cpu_resetn),	
   .bpc_pio_external_connection_export (cpu_bpc_sync)
);

//
// HDMI video/audio/aux/infoframes bypass fifos
//									  
wire        vid_bp_ff_wrreq;
wire        vid_bp_ff_rdreq;
wire        vid_bp_ff_full;
wire        vid_bp_ff_mt;
wire [95:0] buffer_tx_data;
wire [1:0]  buffer_tx_de;
wire [1:0]  buffer_tx_hsync;
wire [1:0]  buffer_tx_vsync;
  
assign vid_bp_ff_wrreq = ~vid_bp_ff_full;
assign vid_bp_ff_rdreq = ~vid_bp_ff_mt;

dcfifo u_vid_bypass_fifo (
   /* I */ .rdclk (hdmi_tx_vid_clk),
   /* I */ .wrclk (hdmi_rx_vid_clk),
   /* I */ .wrreq (vid_bp_ff_wrreq),
   /* I */ .aclr (reset | ~&hdmi_rx_locked),
   /* I */ .data ({hdmi_rx_de, hdmi_rx_hsync, hdmi_rx_vsync, hdmi_rx_data}),
   /* I */ .rdreq (vid_bp_ff_rdreq),
   /* O */ .wrfull (vid_bp_ff_full),
   /* O */ .q ({buffer_tx_de, buffer_tx_hsync, buffer_tx_vsync, buffer_tx_data}),
   /* O */ .rdempty (vid_bp_ff_mt));
defparam
   u_vid_bypass_fifo.acf_disable_embedded_timing_constraint = "true",
   u_vid_bypass_fifo.intended_device_family = "Arria V",
   u_vid_bypass_fifo.lpm_numwords = 32,
   u_vid_bypass_fifo.lpm_showahead = "OFF",
   u_vid_bypass_fifo.lpm_type = "dcfifo",
   u_vid_bypass_fifo.lpm_width = 102,
   u_vid_bypass_fifo.lpm_widthu = 5,
   u_vid_bypass_fifo.overflow_checking = "OFF",
   u_vid_bypass_fifo.rdsync_delaypipe = 4,
   u_vid_bypass_fifo.read_aclr_synch = "ON",
   u_vid_bypass_fifo.underflow_checking = "OFF",
   u_vid_bypass_fifo.use_eab = "ON",
   u_vid_bypass_fifo.write_aclr_synch = "ON",
   u_vid_bypass_fifo.wrsync_delaypipe = 4;

wire aud_bp_ff_wrreq;
wire aud_bp_ff_rdreq;
wire aud_bp_ff_full;
wire aud_bp_ff_mt;
  
assign aud_bp_ff_wrreq = ~aud_bp_ff_full;
assign aud_bp_ff_rdreq = ~aud_bp_ff_mt;
 
dcfifo u_aud_bypass_fifo (
   /* I */ .rdclk (hdmi_tx_ls_clk),
   /* I */ .wrclk (hdmi_rx_ls_clk),
   /* I */ .wrreq (aud_bp_ff_wrreq),
   /* I */ .aclr (reset | ~&hdmi_rx_locked),
   /* I */ .data ({rx_audio_format, rx_audio_metadata, rx_audio_info_ai, rx_audio_CTS, rx_audio_N, rx_audio_de, rx_audio_data}),
   /* I */ .rdreq (aud_bp_ff_rdreq),
   /* O */ .wrfull (aud_bp_ff_full),
   /* O */ .q ({tx_audio_format, tx_audio_metadata, tx_audio_info_ai, tx_audio_CTS, tx_audio_N, tx_audio_de, tx_audio_data}),
   /* O */ .rdempty (aud_bp_ff_mt));
defparam
   u_aud_bypass_fifo.acf_disable_embedded_timing_constraint = "true",
   u_aud_bypass_fifo.intended_device_family = "Arria V",
   u_aud_bypass_fifo.lpm_numwords = 32,
   u_aud_bypass_fifo.lpm_showahead = "OFF",
   u_aud_bypass_fifo.lpm_type = "dcfifo",
   u_aud_bypass_fifo.lpm_width = (5+ 165 + 48 + 20 + 20 + 1 + 256),
   u_aud_bypass_fifo.lpm_widthu = 5,
   u_aud_bypass_fifo.overflow_checking = "OFF",
   u_aud_bypass_fifo.rdsync_delaypipe = 4,
   u_aud_bypass_fifo.read_aclr_synch = "ON",
   u_aud_bypass_fifo.underflow_checking = "OFF",
   u_aud_bypass_fifo.use_eab = "ON",
   u_aud_bypass_fifo.write_aclr_synch = "ON",
   u_aud_bypass_fifo.wrsync_delaypipe = 4;

wire if_bp_ff_wrreq;
wire if_bp_ff_rdreq;
wire if_bp_ff_full;
wire if_bp_ff_mt;
  
assign if_bp_ff_wrreq = ~if_bp_ff_full;
assign if_bp_ff_rdreq = ~if_bp_ff_mt;

dcfifo u_if_passthru_fifo (
   /* I */ .rdclk (hdmi_tx_ls_clk),
   /* I */ .wrclk (hdmi_rx_ls_clk),
   /* I */ .wrreq (if_bp_ff_wrreq),
   /* I */ .aclr (reset | ~&hdmi_rx_locked),
   /* I */ .data ({rx_gcp, rx_info_avi, rx_info_vsi}),
   /* I */ .rdreq (if_bp_ff_rdreq),
   /* O */ .wrfull (if_bp_ff_full),
   /* O */ .q ({tx_gcp, tx_info_avi, tx_info_vsi}),
   /* O */ .rdempty (if_bp_ff_mt));
defparam
   u_if_passthru_fifo.acf_disable_embedded_timing_constraint = "true",
   u_if_passthru_fifo.intended_device_family = "Arria V",
   u_if_passthru_fifo.lpm_numwords = 32,
   u_if_passthru_fifo.lpm_showahead = "OFF",
   u_if_passthru_fifo.lpm_type = "dcfifo",
   u_if_passthru_fifo.lpm_width = 179,
   u_if_passthru_fifo.lpm_widthu = 5,
   u_if_passthru_fifo.overflow_checking = "OFF",
   u_if_passthru_fifo.rdsync_delaypipe = 4,
   u_if_passthru_fifo.read_aclr_synch = "ON",
   u_if_passthru_fifo.underflow_checking = "OFF",
   u_if_passthru_fifo.use_eab = "ON",
   u_if_passthru_fifo.write_aclr_synch = "ON",
   u_if_passthru_fifo.wrsync_delaypipe = 4;

wire [71:0] tx_aux_data;
wire        tx_aux_valid;
wire        tx_aux_sop;
wire        tx_aux_eop;
wire aux_bp_ff_wrreq;
wire aux_bp_ff_rdreq;
wire aux_bp_ff_full;
wire aux_bp_ff_mt;
wire tx_aux_ready;

assign aux_bp_ff_wrreq = rx_aux_valid & ~aux_bp_ff_full;
assign aux_bp_ff_rdreq = tx_aux_ready & ~aux_bp_ff_mt;
//assign tx_aux_valid = ~aux_bp_ff_mt;

reg aux_bp_ff_valid;
wire hdmi_tx_ls_clk_reset_sync;
always @ (posedge hdmi_tx_ls_clk or posedge hdmi_tx_ls_clk_reset_sync)
begin   
   if (hdmi_tx_ls_clk_reset_sync) begin
      aux_bp_ff_valid <= 1'b0;
   end else begin
        if      (tx_aux_ready & ~aux_bp_ff_mt)    aux_bp_ff_valid <= 1'b1; // 1 clock cycle delay of the read will be the valid for the data
        else if (~tx_aux_ready & aux_bp_ff_valid) aux_bp_ff_valid <= 1'b1; // need to hold the valid until the ready asserted so that data can be read by AV ST MUX
        else                                      aux_bp_ff_valid <= 1'b0;
   end
end

assign tx_aux_valid = aux_bp_ff_valid;

dcfifo u_aux_passthru_fifo (
   /* I */ .rdclk (hdmi_tx_ls_clk),
   /* I */ .wrclk (hdmi_rx_ls_clk),
   /* I */ .wrreq (aux_bp_ff_wrreq),
   /* I */ .aclr (reset | ~&hdmi_rx_locked),
   /* I */ .data ({rx_aux_eop, rx_aux_sop, rx_aux_data}),
   /* I */ .rdreq (aux_bp_ff_rdreq),
   /* O */ .wrfull (aux_bp_ff_full),
   /* O */ .q ({tx_aux_eop, tx_aux_sop, tx_aux_data}),
   /* O */ .rdempty (aux_bp_ff_mt));
defparam
   u_aux_passthru_fifo.acf_disable_embedded_timing_constraint = "true",
   u_aux_passthru_fifo.intended_device_family = "Arria V",
   u_aux_passthru_fifo.lpm_numwords = 32,
   u_aux_passthru_fifo.lpm_showahead = "OFF",
   u_aux_passthru_fifo.lpm_type = "dcfifo",
   u_aux_passthru_fifo.lpm_width = 74,
   u_aux_passthru_fifo.lpm_widthu = 5,
   u_aux_passthru_fifo.overflow_checking = "OFF",
   u_aux_passthru_fifo.rdsync_delaypipe = 4,
   u_aux_passthru_fifo.read_aclr_synch = "ON",
   u_aux_passthru_fifo.underflow_checking = "OFF",
   u_aux_passthru_fifo.use_eab = "ON",
   u_aux_passthru_fifo.write_aclr_synch = "ON",
   u_aux_passthru_fifo.wrsync_delaypipe = 4;

//
// Example of external filtering of audio sample, timestamp on the auxiliary data port which is loopback from the sink.
// (Workaround) Filter the audio infoframe on the auxiliary data port as well when msb of audio_info_ai is 0.
//

wire block_ext_aud_related_packet;
wire block_ext_aud_sample;
wire block_ext_aud_timestamp;
wire block_ext_aud_infoframe;
wire ext_aud_sample;
wire ext_aud_timestamp;
wire ext_aud_infoframe;
wire ext_aux_block;
wire tx_aux_ready_int;
reg do_ext_aux_block;

assign block_ext_aud_sample = 1'b1;
assign block_ext_aud_timestamp = 1'b1;
assign block_ext_aud_infoframe = ~user_pb[2];
assign ext_aud_sample = tx_aux_sop & (tx_aux_data[7:0] == 8'h02) & tx_aux_valid;
assign ext_aud_timestamp = tx_aux_sop & (tx_aux_data[7:0] == 8'h01) & tx_aux_valid;
assign ext_aud_infoframe = tx_aux_sop & (tx_aux_data[7:0] == 8'h84) & tx_aux_valid;
assign block_ext_aud_related_packet = (block_ext_aud_sample & ext_aud_sample) | 
                                      (block_ext_aud_timestamp & ext_aud_timestamp) |
                                      (block_ext_aud_infoframe & ext_aud_infoframe);

always @ (posedge hdmi_tx_ls_clk or posedge hdmi_tx_ls_clk_reset_sync)	
   if (hdmi_tx_ls_clk_reset_sync)
      do_ext_aux_block <= 1'b0;
   else
      do_ext_aux_block <= do_ext_aux_block ? ~(tx_aux_eop & tx_aux_valid) : block_ext_aud_related_packet;
	
assign ext_aux_block = block_ext_aud_related_packet | do_ext_aux_block; 
assign tx_aux_ready = tx_aux_ready_int | ext_aux_block;

//
// HDMI TX video path and transceiver/PLL control
//   
assign cvo_data_map = {cvo_data[47:40], 8'b0, 
                       cvo_data[39:32], 8'b0,
                       cvo_data[31:24], 8'b0,
                       cvo_data[23:16], 8'b0, 
                       cvo_data[15:8],  8'b0,
                       cvo_data[7:0],   8'b0};

assign hdmi_tx_data  = user_dipsw[0] ? buffer_tx_data  : cvo_data_map;
assign hdmi_tx_de    = user_dipsw[0] ? buffer_tx_de    : cvo_datavalid;
assign hdmi_tx_hsync = user_dipsw[0] ? buffer_tx_hsync : cvo_hsync;
assign hdmi_tx_vsync = user_dipsw[0] ? buffer_tx_vsync : cvo_vsync;

hdmi_tx_top #(
   .SUPPORT_DEEP_COLOR (1),
   .SUPPORT_AUXILIARY (1),
   .SYMBOLS_PER_CLOCK (SYMBOLS_PER_CLOCK),
   .SUPPORT_AUDIO (1)
) u_hdmi_tx_top (
   /* I */ .mgmt_clk (mgmt_clk),
   /* I */ .mgmt_clk_reset (mgmt_clk_reset_sync | ~&hdmi_rx_locked),
   /* I */ .hdmi_clk_in (hdmi_clk_in),
   /* O */ .vid_clk_out (hdmi_tx_vid_clk),
   /* O */ .ls_clk_out (hdmi_tx_ls_clk),		 
   /* O */ .gpll_locked (tx_gpll_locked),
   /* O */ .txpll_locked (tx_pll_locked),
   /* O */ .gxb_tx_ready (tx_ready),
   /* I */ .reconfig_to_tx (reconfig_to_tx),
   /* O */ .reconfig_from_tx (reconfig_from_tx),			   
   /* I */ .reset_xcvr (tx_rst_xcvr),  
   /* I */ .reset_pll (tx_rst_pll),  
   /* I */ .reset_pll_reconfig (sys_init | wd_reset), 
   /* O */ .tx_serial_data ({tx_serial_data[0], tx_serial_data[1], tx_serial_data[2], tx_serial_data[3]}),
   /* O */ .pll_reconfig_waitrequest (tx_gpll_reconfig_mgmt_waitrequest),
   /* I */ .pll_reconfig_write (tx_gpll_reconfig_mgmt_write),
   /* I */ .pll_reconfig_address (tx_gpll_reconfig_mgmt_address),
   /* I */ .pll_reconfig_writedata (tx_gpll_reconfig_mgmt_writedata),
   /* I */ .pll_reconfig_read (tx_gpll_reconfig_mgmt_read),
   /* O */ .pll_reconfig_readdata (tx_gpll_reconfig_mgmt_readdata),
   /* I */ .os (tx_os),
   /* I */ .mode (user_pb[1]), 
   /* I */ .ctrl ({SYMBOLS_PER_CLOCK{6'd0}}),					
   /* I */ //.audio_clk (),
   /* I */ .audio_de (tx_audio_de),
   /* I */ .audio_mute (1'b0),
   /* I */ .aux_data (tx_aux_data),
   /* I */ .aux_valid (tx_aux_valid & ~ext_aux_block),
   /* O */ .aux_ready (tx_aux_ready_int),         
   /* I */ .aux_sop (tx_aux_sop),
   /* I */ .aux_eop (tx_aux_eop),
   /* I */ .audio_CTS (tx_audio_CTS),
   /* I */ .audio_data (tx_audio_data), 
   /* I */ .audio_info_ai ({~user_pb[2], tx_audio_info_ai}), 
   /* I */ .audio_N (tx_audio_N), 
   /* I */ .audio_metadata ({~user_pb[2], tx_audio_metadata}), 
   /* I */ .audio_format (tx_audio_format), 
   /* I */ .gcp (tx_gcp[5:0]), 
           // Press user_pb[2], you will no longer see infoframes in the transmitted signal
           // Release user_pb[2], you will see continuous infoframes in the transmitted signal 
   /* I */ .info_avi ({~user_pb[2], tx_info_avi}),  
   /* I */ .info_vsi ({~user_pb[2], tx_info_vsi}), 
   /* I */ .vid_data (hdmi_tx_data), 
   /* I */ .vid_de (hdmi_tx_de), 
   /* I */ .vid_hsync (hdmi_tx_hsync), 
   /* I */ .vid_vsync (hdmi_tx_vsync), 
   /* I */ .Scrambler_Enable (1'b0), 
   /* I */ .TMDS_Bit_clock_Ratio (1'b0)
);

//
// Reset synchronizers
//  									 
altera_reset_controller #(
   .NUM_RESET_INPUTS          (1),
   .SYNC_DEPTH                (3),
   .RESET_REQ_WAIT_TIME       (1),
   .MIN_RST_ASSERTION_TIME    (3),
   .RESET_REQ_EARLY_DSRT_TIME (1)
) u_mgmt_clk_reset_sync (
   /* I */ .reset_in0 (reset),
   /* I */ .clk (mgmt_clk),
   /* O */ .reset_out (mgmt_clk_reset_sync)
);

altera_reset_controller #(
   .NUM_RESET_INPUTS          (1),
   .SYNC_DEPTH                (3),
   .RESET_REQ_WAIT_TIME       (1),
   .MIN_RST_ASSERTION_TIME    (3),
   .RESET_REQ_EARLY_DSRT_TIME (1)
) u_i2c_clk_reset_sync (
   /* I */ .reset_in0 (reset),
   /* I */ .clk (i2c_clk),
   /* O */ .reset_out (i2c_clk_reset_sync)
);

altera_reset_controller #(
   .NUM_RESET_INPUTS          (1),
   .SYNC_DEPTH                (3),
   .RESET_REQ_WAIT_TIME       (1),
   .MIN_RST_ASSERTION_TIME    (3),
   .RESET_REQ_EARLY_DSRT_TIME (1)
) u_hdmi_tx_ls_clk_reset_sync (
   /* I */ .reset_in0 (reset),
   /* I */ .clk (hdmi_tx_ls_clk),
   /* O */ .reset_out (hdmi_tx_ls_clk_reset_sync)
);

endmodule
