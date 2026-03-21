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


module mr_reconfig_mgmt_av #(
    parameter [1:0]  CONFIG_TYPE                 = 2,
    parameter [3:0]  RX_STARTING_LOGICAL         = 0,
    parameter [3:0]  TX_STARTING_LOGICAL         = 3,
    parameter [3:0]  TX_PLL_STARTING_LOGICAL     = 7,
    parameter [3:0]  RX_DEFAULT_RANGE            = 3,
    parameter [3:0]  TX_DEFAULT_RANGE            = 2,
    parameter [3:0]  TX_PLL_DEFAULT_RANGE        = 2,
    parameter [3:0]  PLL_DEFAULT_RANGE           = 3,
    parameter [23:0] CYC_MEASURE_CLK_IN_10_MSEC  = 24'h0F4240		    
) (
    input  wire        sys_clk,
    input  wire        sys_clk_rst,
    input  wire        refclock,
    input  wire        rx_ready,
    input  wire        tx_ready,    
    input  wire [2:0]  rx_locked,
    input  wire [3:0]  bpc,
    input  wire        pll_locked,
    output wire        reset_xcvr,
    output wire        reset_core,
    output wire        reset_pll_reconfig,
    output wire        reset_pll,   
    output wire [2:0]  rx_set_locktoref,
    input  wire        xcvr_reconfig_busy,
    output wire [8:0] xcvr_reconfig_address, // 9 bits
    output wire        xcvr_reconfig_read,
    input  wire [31:0] xcvr_reconfig_readdata,
    input  wire        xcvr_reconfig_waitrequest,
    output wire        xcvr_reconfig_write,
    output wire [31:0] xcvr_reconfig_writedata,
    input  wire        pll_reconfig_waitrequest,    
    output wire [5:0]  pll_reconfig_address, // 8 bits
    output wire        pll_reconfig_write,
    output wire [31:0] pll_reconfig_writedata,
    input  wire        tmds_bit_clock_ratio,
    output wire [23:0] measure,
    output wire        measure_valid
);

wire        enable;
wire [8:0]  xcvr_reconfig_address_used;
wire [5:0]  pll_reconfig_address_used;

// Address space map
assign xcvr_reconfig_address = xcvr_reconfig_address_used;
assign pll_reconfig_address = pll_reconfig_address_used;

mr_rate_detect #(
    .CYC_MEASURE_CLK_IN_10_MSEC (CYC_MEASURE_CLK_IN_10_MSEC)
) u_rate_detect (
    .refclock (refclock), 
    .measure_clk (sys_clk),
    .reset (sys_clk_rst),
    .enable (enable),    
    .refclock_measure (measure),
    .valid (measure_valid)
);

wire        tmds_bit_clock_ratio_sync;
wire [23:0] measure_for_compare;
altera_std_synchronizer #(.depth(3)) u_tmds_bit_clock_ratio_sync (.clk(sys_clk),.reset_n(1'b1),.din(tmds_bit_clock_ratio),.dout(tmds_bit_clock_ratio_sync));

assign measure_for_compare = tmds_bit_clock_ratio_sync ? {measure[21:0], 2'b00} : measure;

wire       oversampled;
wire       xcvr_reconfig_done;
wire [3:0] rx_range;
wire       rx_range_valid;
wire [1:0] rx_m_sel;
wire [3:0] rx_m;
wire [1:0] rx_lpfd;
wire [1:0] rx_lpd;
wire [1:0] rx_pfd_bwctrl;
wire [1:0] rx_pd_bwctrl;
wire [2:0] rx_isel;
wire [2:0] rx_icp_high;
wire [1:0] rx_sel_ppm;
wire       rx_sel_halfbw;
wire       clr_compare_valid;

mr_rx_compare_av #(
    .RX_DEFAULT_RANGE (RX_DEFAULT_RANGE)
) u_rx_compare (
    .clock (sys_clk),
    .reset (sys_clk_rst),
    .clr_valid (clr_compare_valid),
    .measure (measure_for_compare),
    .measure_valid (measure_valid),
    .range (rx_range),
    .range_valid (rx_range_valid),
    .oversampled (oversampled),
    .m_sel (rx_m_sel),
    .m (rx_m),
    .lpfd (rx_lpfd),
    .lpd (rx_lpd),
    .pfd_bwctrl (rx_pfd_bwctrl),
    .pd_bwctrl (rx_pd_bwctrl),
    .isel (rx_isel),
    .icp_high (rx_icp_high),
    .sel_ppm (rx_sel_ppm),
    .sel_halfbw (rx_sel_halfbw)			    
);

//wire [3:0] tx_range;
//wire       tx_range_valid;
//wire [2:0] tx_slew;
//mr_tx_compare_av #(
//    .TX_DEFAULT_RANGE (TX_DEFAULT_RANGE)
//) tx_compare_inst (
//    .clock (sys_clk),
//    .reset (sys_clk_rst),
//    .clr_valid (clr_compare_valid),
//    .measure (measure),
//    .measure_valid (measure_valid),
//    .range (tx_range),
//    .range_valid (tx_range_valid),
//    .slew (tx_slew)			    
//);

//wire [3:0] tx_pll_range;
//wire       tx_pll_range_valid;
//wire [1:0] tx_pll_lpfd;
//wire [2:0] tx_pll_isel;
//wire [1:0] tx_pll_pfd_bwctrl;
//wire [2:0] tx_pll_icp_high;
//wire [2:0] tx_pll_rgla_isel;
//wire       tx_pll_pcie_mode_sel;
//mr_tx_pll_compare_av #(
//    .TX_PLL_DEFAULT_RANGE (TX_PLL_DEFAULT_RANGE)
//) tx_pll_compare_inst (
//    .clock (sys_clk),
//    .reset (sys_clk_rst),
//    .clr_valid (clr_compare_valid),
//    .measure (measure),
//    .measure_valid (measure_valid),
//    .range (tx_pll_range),
//    .range_valid (tx_pll_range_valid),
//    .lpfd (tx_pll_lpfd),
//    .isel (tx_pll_isel),
//    .pfd_bwctrl (tx_pll_pfd_bwctrl),
//    .icp_high (tx_pll_icp_high),
//    .rgla_isel (tx_pll_rgla_isel),
//    .pcie_mode_sel (tx_pll_pcie_mode_sel)			    
//);

wire        pll_reconfig_done;
wire [3:0]  pll_range;
wire        pll_range_valid;
wire [17:0] pll_m;
wire [17:0] pll_n;
wire [22:0] pll_c0;
wire [22:0] pll_c1;
wire [22:0] pll_c2;
wire [1:0]  pll_cp;
wire [6:0]  pll_bw;
wire [3:0]  bpc_for_pll;
mr_pll_compare #(
    .PLL_DEFAULT_RANGE (PLL_DEFAULT_RANGE)
) u_pll_compare (
    .clock (sys_clk),
    .reset (sys_clk_rst),
    .clr_valid (clr_compare_valid),
    .measure (measure_for_compare),
    .measure_valid (measure_valid),
    .range (pll_range),
    .range_valid (pll_range_valid),
    .m (pll_m),
    .n (pll_n),
    .c0 (pll_c0),
    .c1 (pll_c1),
    .c2 (pll_c2),
    .cp (pll_cp),
    .bw (pll_bw),
    .bpc (bpc_for_pll)
);

wire [1:0]  intf;           // 3: RX, 2: TX, 1: TXPLL 0: invalid
wire [2:0]  num_exec;       // number of offset registers for each interface
wire [31:0] readdata_r;     // delayed version of readdata
wire [4:0]  offset;         // offset register value
wire [31:0] overriden_data; // the overriden data that to be written back to the register
mr_xcvr_offset_av u_xcvr_offset (
   .clock (sys_clk),
   .reset (sys_clk_rst),
   .intf (intf),
   .num_exec (num_exec),
   .readdata_r (readdata_r),
   .rx_m (rx_m),
   .rx_lpfd (rx_lpfd),
   .rx_lpd (rx_lpd),
   .rx_pfd_bwctrl (rx_pfd_bwctrl),
   .rx_pd_bwctrl (rx_pd_bwctrl),
   .rx_isel (rx_isel),
   .rx_icp_high (rx_icp_high),
   .rx_sel_ppm (rx_sel_ppm),
   .rx_sel_halfbw (rx_sel_halfbw),
   .rx_m_sel (rx_m_sel),
   //.tx_slew (tx_slew),
   //.tx_pll_lpfd (tx_pll_lpfd),
   //.tx_pll_isel (tx_pll_isel),
   //.tx_pll_pfd_bwctrl (tx_pll_pfd_bwctrl),
   //.tx_pll_icp_high (tx_pll_icp_high),
   //.tx_pll_rgla_isel (tx_pll_rgla_isel),
   //.tx_pll_pcie_mode_sel (tx_pll_pcie_mode_sel),
   .offset_out (offset),
   .overriden_data_out (overriden_data)
);

mr_reconfig_fsm #(
    .CONFIG_TYPE (CONFIG_TYPE),
    .RX_STARTING_LOGICAL (RX_STARTING_LOGICAL),
    .TX_STARTING_LOGICAL (TX_STARTING_LOGICAL),
    .TX_PLL_STARTING_LOGICAL (TX_PLL_STARTING_LOGICAL)	      
) u_reconfig_fsm (
    .sys_clk (sys_clk),	     
    .sys_clk_rst (sys_clk_rst),
    .enable (enable),   
    .clr_compare_valid (clr_compare_valid),
    .bpc_out (bpc_for_pll),	 
    .rx_range (rx_range),
    .rx_range_valid (rx_range_valid), 
    .oversampled (oversampled),   
    .tx_range (0),
    .tx_range_valid (0),    
    .tx_pll_range (0),
    .tx_pll_range_valid (0),
    .intf_out (intf),
    .num_exec_out (num_exec),
    .readdata_r_out (readdata_r),
    .offset (offset),
    .overriden_data (overriden_data),
    .pll_range (pll_range),
    .pll_range_valid (pll_range_valid),
    .pll_m (pll_m),
    .pll_n (pll_n),
    .pll_c0 (pll_c0),
    .pll_c1 (pll_c1),
    .pll_c2 (pll_c2),
    .pll_cp (pll_cp),
    .pll_bw (pll_bw),
    .rx_ready (rx_ready),
    .tx_ready (tx_ready),
    .pll_locked (pll_locked),	    
    .reset_xcvr (reset_xcvr),
    .reset_core (reset_core),
    .reset_pll_reconfig (reset_pll_reconfig),
    .reset_pll (reset_pll),		     
    .rx_set_locktoref (rx_set_locktoref),       
    .rx_locked (rx_locked),
    .bpc (bpc),	 
    .tmds_bit_clock_ratio (tmds_bit_clock_ratio_sync),	 
    .xcvr_reconfig_done (xcvr_reconfig_done), 
    .pll_reconfig_done (pll_reconfig_done),			      
    .xcvr_reconfig_busy (xcvr_reconfig_busy),
    .xcvr_reconfig_address (xcvr_reconfig_address_used),
    .xcvr_reconfig_read (xcvr_reconfig_read),
    .xcvr_reconfig_readdata (xcvr_reconfig_readdata),
    .xcvr_reconfig_waitrequest (xcvr_reconfig_waitrequest),
    .xcvr_reconfig_write (xcvr_reconfig_write),
    .xcvr_reconfig_writedata (xcvr_reconfig_writedata),
    .pll_reconfig_waitrequest (pll_reconfig_waitrequest),	    
    .pll_reconfig_address (pll_reconfig_address_used),
    .pll_reconfig_write (pll_reconfig_write),
    .pll_reconfig_writedata (pll_reconfig_writedata)
);
		 
endmodule
