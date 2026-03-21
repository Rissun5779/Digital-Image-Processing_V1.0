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


// $Id: //acds/main/ip/ethernet/alt_eth_ultra_100g/rtl/pma/e100_io_frame_32.v#3 $
// $Revision: #3 $
// $Date: 2013/09/17 $
// $Author: jilee $
//-----------------------------------------------------------------------------

module caui4_e100_pma #(
        parameter PHY_REFCLK = 1,
        parameter RST_CNTR = 16   // nominal 16/20  or 6 for fast simulation of reset seq
)(
        input pll_refclk,
        output [3:0] tx_pin,
        input [3:0] rx_pin,
        input tx_pll_locked,
        // status and control
        input status_clk,
        input sys_rst,
        output [3:0] freq_lock,
        output txa_online,
        input [3:0] sloop,
                                
        // data stream to TX pins
        input din_clk,
        input din_clk_ready,
        input [4*64-1:0] din, // lsbit first serial streams
        input din_valid,
        output tx_online,
        output [3:0] clk_tx_io,
    
        // data stream from RX pins
        input dout_clk,
        input dout_clk_ready,
        input [3:0] rx_bitslip,
        output [4*64-1:0] dout, // lsbit first serial streams
        output rx_online,
	    output wire rx_aclr_pcs_ready,
        output [3:0] clk_rx_recovered,
        output [3:0] rx_pma_iq_clkout,
        output [3:0] rx_pma_div_clkout,
        output [3:0] rx_lockedtodata,
        
        input  wire [0:0]   reconfig_clk,               // reconfig_clk.clk
        input  wire [0:0]   reconfig_reset,             // reconfig_reset.reset
        input  wire [0:0]   reconfig_write,             // reconfig_avmm.write
        input  wire [0:0]   reconfig_read,              // .read
        input  wire [11:0]  reconfig_address,           // .address
        input  wire [31:0]  reconfig_writedata,         // .writedata
        output wire [31:0]  reconfig_readdata,          // .readdata
        output wire [0:0]   reconfig_waitrequest,       // .waitrequest
        input       [9:0]   tx_serial_clk
        
);

// status and resets
wire pll_powerdown;
wire tx_analogreset;
wire tx_digitalreset;
wire rx_analogreset;
wire rx_digitalreset;

wire cal_busy;   
wire [3:0] tx_cal_busy;
wire [3:0] rx_cal_busy;   
   
wire [3:0] tx_pma_clkout;
wire [3:0] rx_pma_clkout;

`define ALTERA_ETH_CAUI4_NATIVE_PORT_MAPPING  (                               \
                .tx_analogreset({4{tx_analogreset}}), \
                .tx_digitalreset({4{tx_digitalreset}}), \
                .rx_analogreset({4{rx_analogreset}}), \
                .rx_digitalreset({4{rx_digitalreset}}), \
                .tx_cal_busy(tx_cal_busy), \
                .rx_cal_busy(rx_cal_busy), \
                .tx_serial_clk0(tx_serial_clk), \
                .rx_cdr_refclk0(pll_refclk), \
                .tx_serial_data(tx_pin[3:0]), \
                .rx_serial_data(rx_pin[3:0]), \
                .rx_is_lockedtoref(freq_lock), \
                .rx_is_lockedtodata(rx_lockedtodata[3:0]), \
                .rx_bitslip(rx_bitslip[3:0]), \
                .tx_coreclkin(clk_tx_io[3:0]), \
                .rx_coreclkin(clk_rx_recovered[3:0]), \
                .tx_clkout(clk_tx_io[3:0]), \
                .rx_clkout(clk_rx_recovered[3:0]), \
                .tx_pma_clkout(tx_pma_clkout[3:0]), \
                .rx_pma_clkout(rx_pma_clkout[3:0]), \
                .rx_pma_div_clkout (rx_pma_div_clkout[3:0]), \
                .rx_pma_iqtxrx_clkout(rx_pma_iq_clkout[3:0]), \
                .tx_enh_data_valid(4'b1111), \
                .reconfig_clk(reconfig_clk), \
                .reconfig_reset(reconfig_reset), \
                .reconfig_write(reconfig_write), \
                .reconfig_read(reconfig_read), \
                .reconfig_address(reconfig_address), \
                .reconfig_writedata(reconfig_writedata), \
                .reconfig_readdata(reconfig_readdata), \
                .reconfig_waitrequest(reconfig_waitrequest), \
                .tx_parallel_data(din[4*64-1:0]), \
                .unused_tx_parallel_data(256'h0), \
                .rx_parallel_data(dout[4*64-1:0]), \
                .rx_seriallpbken(sloop), \
                .unused_rx_parallel_data()  \
        );

generate 
   if (PHY_REFCLK==1) begin : GT_A10_644
      caui4_xcvr_644 caui4_xcvr_644_inst           
      `ALTERA_ETH_CAUI4_NATIVE_PORT_MAPPING
   end
   else begin : GT_A10_322
      caui4_xcvr_322 caui4_xcvr_322_inst           
      `ALTERA_ETH_CAUI4_NATIVE_PORT_MAPPING
   end     
endgenerate
////////////////////////////////////////////
// reset control
assign cal_busy = |{tx_cal_busy,rx_cal_busy};
   
wire rd0_ready;
reset_delay rd0 (
        .clk(status_clk),
        .ready_in(!sys_rst & (!cal_busy)),
        .ready_out(rd0_ready)
);
defparam rd0 .CNTR_BITS = RST_CNTR;
assign pll_powerdown = (!rd0_ready) & (!cal_busy);

wire rd1_ready;
reset_delay rd1 (
        .clk(status_clk),
        .ready_in(rd0_ready & (&tx_pll_locked)),
        .ready_out(rd1_ready)
);
defparam rd1 .CNTR_BITS = RST_CNTR;
assign tx_analogreset = !rd1_ready & (!cal_busy); //no analog reset when cal_busy
assign txa_online = !tx_analogreset;

wire rd2_ready;
reset_delay rd2 (
        .clk(status_clk),
        .ready_in(rd1_ready),
        .ready_out(rd2_ready)
);
defparam rd2 .CNTR_BITS = RST_CNTR;
assign rx_analogreset = (!rd2_ready) & (!cal_busy); //no analog reset when cal_busy

wire rd3_ready;
reset_delay rd3 (
        .clk(status_clk),
        .ready_in(rd2_ready & din_clk_ready),
        .ready_out(rd3_ready)
);
defparam rd3 .CNTR_BITS = RST_CNTR;
assign tx_digitalreset = !rd3_ready;

wire rd4_ready;
reset_delay rd4 (
        .clk(status_clk),
        .ready_in(rd3_ready & (&rx_lockedtodata) & dout_clk_ready),
        .ready_out(rd4_ready)
);
defparam rd4 .CNTR_BITS = RST_CNTR;
assign rx_digitalreset = !rd4_ready;

sync_regs sr0 (
        .clk(din_clk),
        .din(!tx_digitalreset),
        .dout(tx_online)
);
defparam sr0 .WIDTH = 1;

sync_regs sr1 (
        .clk(dout_clk),
        .din(!rx_digitalreset),
        .dout(rx_online)
);
defparam sr1 .WIDTH = 1;
   
aclr_filter f1(   // synchronizing deassertion
        .clk(dout_clk),
        .aclr(rx_digitalreset),
        .aclr_sync(rx_aclr_pcs_ready)
);

endmodule
    
    
