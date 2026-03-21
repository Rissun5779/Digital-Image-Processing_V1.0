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
// baeckler - 05-22-2012

module s5_32bit_fivepack #(
	parameter REF_FREQ = "644.53125 MHz",
	parameter DATA_RATE = "10312.5 Mbps",
	parameter PLL_OUT_FREQ = "5156.25 MHz" // CAREFUL!! : this is MHz, not MBPS, typically 1/2 data rate    
)(
	input pll_refclk,
	
	input pll_pd,
	input rst_txa,
	input rst_txd,
	input rst_rxa,
	input rst_rxd,
	output tx_pll_locked,

	output [4:0] tx_clkout,
	output [4:0] rx_clkout,
	input clk_tx_common,
	input clk_rx_common,
			
	output [4:0] tx_pin,
	input [4:0] rx_pin,

	input [5*32-1:0] tx_din,
	output [5*32-1:0] rx_dout,
	
	input [4:0] tx_valid,
	input [4:0] rx_ready,
	input [4:0] rx_fifo_aclr,
	input [4:0] rx_bitslip,
	output [4:0] rx_valid,
	output [4:0] rx_datalocked,
	input  [4:0] rx_seriallpbken,
				
	output [4:0] tx_full,
	output [4:0] tx_pfull,
	output [4:0] tx_empty,
	output [4:0] tx_pempty,
	output [4:0] rx_full,
	output [4:0] rx_pfull,
	output [4:0] rx_empty,
	output [4:0] rx_pempty,

	input set_lock_data,
	input set_lock_ref,	
        input [70*5-1:0]  reconfig_to_xcvr,  
        output [46*5-1:0] reconfig_from_xcvr
);

wire tx_pll_outclk;

wire [4:0] tx_pma_clkout;
wire [4:0] rx_pma_clkout;

wire ext_pll_clk = tx_pll_outclk;
wire rx_cdr_refclk = pll_refclk;

// 3 on the bottom
wire [80*3-1:0] tx_pma_parallel_data_bt;
wire [80*3-1:0] rx_pma_parallel_data_bt;
wire [64*3-1:0] tx_parallel_data_bt;
wire [64*3-1:0] rx_parallel_data_bt;
wire [70*3-1:0] reconfig_to_xcvr_bt;  
wire [46*3-1:0] reconfig_from_xcvr_bt;

// 2 on the top
wire [80*2-1:0] tx_pma_parallel_data_tp;
wire [80*2-1:0] rx_pma_parallel_data_tp;
wire [64*2-1:0] tx_parallel_data_tp;
wire [64*2-1:0] rx_parallel_data_tp;
wire [70*2-1:0] reconfig_to_xcvr_tp;  
wire [46*2-1:0] reconfig_from_xcvr_tp;

assign {reconfig_to_xcvr_tp, reconfig_to_xcvr_bt} = reconfig_to_xcvr;
assign reconfig_from_xcvr = {reconfig_from_xcvr_tp, reconfig_from_xcvr_bt};
		
s5_32bit_trip_raw bt (
	.pll_powerdown({3{pll_pd}}),            
	.tx_analogreset({3{rst_txa}}),           
	.tx_digitalreset({3{rst_txd}}),          
	.tx_pma_clkout(tx_pma_clkout[2:0]),       
	.tx_serial_data(tx_pin[2:0]),           
	.tx_pma_parallel_data(tx_pma_parallel_data_bt),     
	.ext_pll_clk({3{ext_pll_clk}}),              
	.rx_analogreset({3{rst_rxa}}),           
	.rx_digitalreset({3{rst_rxd}}),          
	.rx_cdr_refclk(rx_cdr_refclk),            
	.rx_pma_clkout(rx_pma_clkout[2:0]),            
	.rx_serial_data(rx_pin[2:0]),           
	.rx_pma_parallel_data(rx_pma_parallel_data_bt),     
	.rx_set_locktodata({3{set_lock_data}}),        
	.rx_set_locktoref({3{set_lock_ref}}),         
	.rx_is_lockedtoref(),        
	.rx_is_lockedtodata(rx_datalocked[2:0]),
	
	.tx_parallel_data(tx_parallel_data_bt),         
	.rx_parallel_data(rx_parallel_data_bt),         
	
	.tx_10g_coreclkin({3{clk_tx_common}}),         
	.rx_10g_coreclkin({3{clk_rx_common}}),         
	
	.tx_10g_clkout(tx_clkout[2:0]),            
	.rx_10g_clkout(rx_clkout[2:0]),            
	.tx_10g_data_valid(tx_valid[2:0]),        
	
	.tx_10g_fifo_full(tx_full[2:0]),         
	.tx_10g_fifo_pfull(tx_pfull[2:0]),        
	.tx_10g_fifo_empty(tx_empty[2:0]),        
	.tx_10g_fifo_pempty(tx_pempty[2:0]),       
	.rx_10g_fifo_full(rx_full[2:0]),         
	.rx_10g_fifo_pfull(rx_pfull[2:0]),        
	.rx_10g_fifo_empty(rx_empty[2:0]),        
	.rx_10g_fifo_pempty(rx_pempty[2:0]),       
	
	.rx_10g_fifo_rd_en(rx_ready[2:0]),        
	.rx_10g_fifo_align_clr(rx_fifo_aclr[2:0]),    
	.rx_10g_bitslip(rx_bitslip[2:0]),           
	.rx_10g_data_valid(rx_valid[2:0]),        
	.tx_cal_busy(),              
	.rx_cal_busy(),              
	.rx_seriallpbken(rx_seriallpbken[2:0]),
	.rx_10g_clk33out(),   
	.reconfig_to_xcvr(reconfig_to_xcvr_bt),         
	.reconfig_from_xcvr(reconfig_from_xcvr_bt)        
);
defparam bt .REF_FREQ = REF_FREQ;
defparam bt .DATA_RATE = DATA_RATE;
defparam bt .NUMC = 3;

s5_32bit_trip_raw tp (
	.pll_powerdown({2{pll_pd}}),            
	.tx_analogreset({2{rst_txa}}),           
	.tx_digitalreset({2{rst_txd}}),          
	.tx_pma_clkout(tx_pma_clkout[4:3]),       
	.tx_serial_data(tx_pin[4:3]),           
	.tx_pma_parallel_data(tx_pma_parallel_data_tp),     
	.ext_pll_clk({2{ext_pll_clk}}),              
	.rx_analogreset({2{rst_rxa}}),           
	.rx_digitalreset({2{rst_rxd}}),          
	.rx_cdr_refclk(rx_cdr_refclk),            
	.rx_pma_clkout(rx_pma_clkout[4:3]),            
	.rx_serial_data(rx_pin[4:3]),           
	.rx_pma_parallel_data(rx_pma_parallel_data_tp),     
	.rx_set_locktodata({2{set_lock_data}}),        
	.rx_set_locktoref({2{set_lock_ref}}),         
	.rx_is_lockedtoref(),        
	.rx_is_lockedtodata(rx_datalocked[4:3]),
	
	.tx_parallel_data(tx_parallel_data_tp),         
	.rx_parallel_data(rx_parallel_data_tp),         
	
	.tx_10g_coreclkin({2{clk_tx_common}}),         
	.rx_10g_coreclkin({2{clk_rx_common}}),         
	
	.tx_10g_clkout(tx_clkout[4:3]),            
	.rx_10g_clkout(rx_clkout[4:3]),            
	.tx_10g_data_valid(tx_valid[4:3]),        
	
	.tx_10g_fifo_full(tx_full[4:3]),         
	.tx_10g_fifo_pfull(tx_pfull[4:3]),        
	.tx_10g_fifo_empty(tx_empty[4:3]),        
	.tx_10g_fifo_pempty(tx_pempty[4:3]),       
	.rx_10g_fifo_full(rx_full[4:3]),         
	.rx_10g_fifo_pfull(rx_pfull[4:3]),        
	.rx_10g_fifo_empty(rx_empty[4:3]),        
	.rx_10g_fifo_pempty(rx_pempty[4:3]),       
	
	.rx_10g_fifo_rd_en(rx_ready[4:3]),        
	.rx_10g_fifo_align_clr(rx_fifo_aclr[4:3]),    
	.rx_10g_bitslip(rx_bitslip[4:3]),           
	.rx_10g_data_valid(rx_valid[4:3]),        
	.tx_cal_busy(),              
	.rx_cal_busy(),              
	.rx_seriallpbken(rx_seriallpbken[4:3]),
	.rx_10g_clk33out(),   
	.reconfig_to_xcvr(reconfig_to_xcvr_tp),         
	.reconfig_from_xcvr(reconfig_from_xcvr_tp)        
);
defparam tp .REF_FREQ = REF_FREQ;
defparam tp .DATA_RATE = DATA_RATE;
defparam tp .NUMC = 2;

/*
sv_xcvr_plls #(
	.plls                                 (1),
	.pll_type                             ("ATX"),
	.pll_reconfig                         (0),
	.refclks                              (1),
	.reference_clock_frequency            (REF_FREQ),
	.reference_clock_select               ("0"),
	.output_clock_datarate                (DATA_RATE),
	.output_clock_frequency               ("0 ps"),
	.feedback_clk                         ("internal"),
	.sim_additional_refclk_cycles_to_lock (0),
	.duty_cycle                           (50),
	.phase_shift                          ("0 ps"),
	.enable_hclk                          ("0"),
	.enable_avmm                          (1), 
	.use_generic_pll                      (0), // 1 works better in sim
	.att_mode                             (0),
	.enable_mux                           (1)
) bar_inst (
	.rst                ({pll_pd}),    //      pll_powerdown.pll_powerdown
	.refclk             ({pll_refclk}),       //         pll_refclk.pll_refclk
	.fbclk              (1'b0),        //          pll_fbclk.pll_fbclk
	.outclk             (tx_pll_outclk),    //         pll_clkout.pll_clkout
	.locked             (tx_pll_locked),    //         pll_locked.pll_locked
	.reconfig_to_xcvr   (),   //   reconfig_to_xcvr.reconfig_to_xcvr
	.reconfig_from_xcvr (), // reconfig_from_xcvr.reconfig_from_xcvr
	.pll_fb_sw          (1'b0),               //        (terminated)
	.fboutclk           (),                   //        (terminated)
	.hclk               ()                    //        (terminated)
);
*/

		stratixv_atx_pll#(
			.sel_buf8g("enable_buf8g"),
			.output_clock_frequency(PLL_OUT_FREQ), 
			.refclk_sel("refclk"), 
			.reference_clock_frequency(REF_FREQ)
		) tx_plls (

			.avmmclk(1'b0),
			.avmmread(0),
			.avmmrstn(0),
			.avmmwrite(0),
			.iqclklc(0),
			.pldclklc(),
			.pllfbswblc(0),
			.pllfbswtlc(0),
			.avmmaddress(11'b00000000000),
			.avmmbyteen(2'b00),
			.avmmwritedata(16'b0000000000000000),
			.ch0rcsrlc(32'b00000000000000000000000000000000),
			.ch1rcsrlc(32'b00000000000000000000000000000000),
			.ch2rcsrlc(32'b00000000000000000000000000000000),
			.blockselect(),
		  
			.refclklc        (pll_refclk),
			
			// should have one more inverter
			.cmurstn        (!pll_pd),  // main reset
			.cmurstnlpf     (!pll_pd), // center the feedback
			
			.clk010g        (tx_pll_outclk),
			.pfdmodelockcmu (tx_pll_locked),
			.frefcmu        (),
			.clklowcmu      ()
		);
	


// get the proper 32 bits out of the 80
genvar i;
generate
	for (i=0; i<3; i=i+1) begin : wb
		assign tx_parallel_data_bt[64*i+31:64*i] = tx_din[(i+1)*32-1:i*32];
		assign rx_dout[(i+1)*32-1:i*32] = rx_parallel_data_bt[64*i+31:64*i];
	end	
endgenerate

generate
	for (i=0; i<2; i=i+1) begin : wt
		assign tx_parallel_data_tp[64*i+31:64*i] = tx_din[(i+1+3)*32-1:(i+3)*32];		
		assign rx_dout[(i+1+3)*32-1:(i+3)*32] = rx_parallel_data_tp[64*i+31:64*i];			
	end	
endgenerate

endmodule
