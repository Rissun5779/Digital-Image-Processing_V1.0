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


// $Id: //acds/main/ip/ethernet/alt_eth_ultra_100g/rtl/pma/s5_32bit_fivepack.v#3 $
// $Revision: #3 $
// $Date: 2013/10/29 $
// $Author: adubey $
//-----------------------------------------------------------------------------
// custodio - 01-20-2014

`timescale 1 ps / 1 ps

module a10_32bit_tenpack #(
        parameter PHY_REFCLK = 1
        )(
        input pll_refclk,
        
        input pll_pd,
        input rst_txa,
        input rst_txd,
        input rst_rxa,
        input rst_rxd,

        output [9:0] tx_clkout,
        output [9:0] rx_clkout,
        input clk_tx_common,
        input clk_rx_common,
                        
        output [9:0] tx_pin,
        input [9:0] rx_pin,

        input [10*32-1:0] tx_din,
        output [10*32-1:0] rx_dout,
        
        input [9:0] tx_valid,
        input [9:0] rx_ready,
        input [9:0] rx_fifo_aclr,
        input [9:0] rx_bitslip,
        output [9:0] rx_valid,
        output [9:0] rx_datalocked,
        input  [9:0] rx_seriallpbken,
                                
        output [9:0] tx_full,
        output [9:0] tx_pfull,
        output [9:0] tx_empty,
        output [9:0] tx_pempty,
        output [9:0] rx_full,
        output [9:0] rx_pfull,
        output [9:0] rx_empty,
        output [9:0] rx_pempty,
        output tx_cal_busy,
        output rx_cal_busy,  
        
        input  wire [0:0]   reconfig_clk,            // reconfig_clk.clk
        input  wire [0:0]   reconfig_reset,          // reconfig_reset.reset
        input  wire [0:0]   reconfig_write,          // reconfig_avmm.write
        input  wire [0:0]   reconfig_read,           // .read
        input  wire [13:0]  reconfig_address,        // .address
        input  wire [31:0]  reconfig_writedata,      // .writedata
        output wire [31:0]  reconfig_readdata,       // .readdata
        output wire [0:0]   reconfig_waitrequest,    // .waitrequest
        
        input [9:0] tx_serial_clk,

        input set_lock_data,
        input set_lock_ref      
);

wire rx_cdr_refclk = pll_refclk;
wire [9:0] txcalbusy;
wire [9:0] rxcalbusy;   
assign tx_cal_busy = |txcalbusy;
assign rx_cal_busy = |rxcalbusy;   

`define ALTERA_ETH_100G_NATIVE_PORT_MAPPING  (                               \
                .tx_analogreset({10{rst_txa}} ) ,\
                .tx_digitalreset({10{rst_txd}}) ,\
                .rx_analogreset({10{rst_rxa}}) ,\
                .rx_digitalreset({10{rst_rxd}}) ,\
                .tx_cal_busy(txcalbusy) ,\
                .rx_cal_busy(rxcalbusy) ,\
                .tx_serial_clk0(tx_serial_clk ) ,\
                .rx_cdr_refclk0(rx_cdr_refclk ) ,\
                .tx_serial_data(tx_pin[9:0]   ) ,\
                .rx_serial_data(rx_pin[9:0]   ) ,\
                .rx_seriallpbken(rx_seriallpbken[9:0]) ,\
                .rx_set_locktoref({10{set_lock_ref}}) ,\
                .rx_set_locktodata({10{set_lock_data}}) ,\
                .rx_is_lockedtoref() ,\
                .rx_is_lockedtodata(rx_datalocked[9:0]) ,\
                .tx_coreclkin({10{clk_tx_common}}) ,\
                .rx_coreclkin({10{clk_rx_common}}) ,\
                .tx_clkout(tx_clkout[9:0]) ,\
                .rx_clkout(rx_clkout[9:0]) ,\
                .rx_bitslip(rx_bitslip[9:0]) ,\
                .tx_enh_data_valid(tx_valid[9:0]) ,\
                .tx_enh_fifo_full(tx_full[9:0]) ,\
                .tx_enh_fifo_pfull(tx_pfull[9:0]) ,\
                .tx_enh_fifo_empty(tx_empty[9:0]) ,\
                .tx_enh_fifo_pempty(tx_pempty[9:0]) ,\
                .rx_enh_fifo_rd_en(rx_ready[9:0]) ,\
                .rx_enh_data_valid(rx_valid[9:0]) ,\
                .rx_enh_fifo_full(rx_full[9:0]) ,\
                .rx_enh_fifo_pfull(rx_pfull[9:0]) ,\
                .rx_enh_fifo_empty(rx_empty[9:0]) ,\
                .rx_enh_fifo_pempty(rx_pempty[9:0]) ,\
                .rx_enh_fifo_align_clr(rx_fifo_aclr[9:0]) ,\
                .reconfig_clk(reconfig_clk) ,\
                .reconfig_reset(reconfig_reset) ,\
                .reconfig_write(reconfig_write) ,\
                .reconfig_read(reconfig_read) ,\
                .reconfig_address(reconfig_address) ,\
                .reconfig_writedata(reconfig_writedata) ,\
                .reconfig_readdata(reconfig_readdata) ,\
                .reconfig_waitrequest(reconfig_waitrequest) ,\
                .tx_parallel_data(tx_din) ,\
                .unused_tx_parallel_data(960'b0) ,\
                .rx_parallel_data(rx_dout) ,\
                .unused_rx_parallel_data() \
        );

generate 
   if (PHY_REFCLK==1) begin : GX_A10_644
      gx_a10_100g_644 gx_a10_100g_644_inst         
      `ALTERA_ETH_100G_NATIVE_PORT_MAPPING
   end
   else begin : GX_A10_322
      gx_a10_100g_322 gx_a10_100g_322_inst         
      `ALTERA_ETH_100G_NATIVE_PORT_MAPPING
   end     
endgenerate
endmodule
