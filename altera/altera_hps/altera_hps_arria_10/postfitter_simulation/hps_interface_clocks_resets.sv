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


module twentynm_hps_interface_clocks_resets #(
	parameter s2f_user0_clk_freq = 100,
	parameter s2f_user1_clk_freq = 100
)(
	output wire  s2f_user0_clk,
	output wire  s2f_user1_clk,
	output wire  s2f_user2_clk,
	output wire  s2f_user3_clk,
	output wire  s2f_pending_rst_req,
	output wire  s2f_user4_clk,
	output wire  s2f_fpga_scanman_tck,
	input  wire  usermode,
	input  wire  f2s_cold_rst_req_n,
	input  wire  f2s_dbg_rst_req_n,
	input  wire  f2s_free_clk,
	input  wire  f2s_pending_rst_ack,
	input  wire  f2s_warm_rst_req_n,
	input  wire  ptp_ref_clk
);

	altera_avalon_clock_source #(
		.CLOCK_RATE(s2f_user0_clk_freq),
		.CLOCK_UNIT(1000000)
	) s2f_user0_clock (
		.clk(s2f_user0_clk)
	);
	
	altera_avalon_clock_source #(
		.CLOCK_RATE(s2f_user1_clk_freq),
		.CLOCK_UNIT(1000000)
	) s2f_user1_clock (
		.clk(s2f_user1_clk)
	);
	
	altera_avalon_reset_source #(
		.ASSERT_HIGH_RESET(0),
		.INITIAL_RESET_CYCLES(0)
	) s2f_cold_reset (
		.clk(1'b0),
		.reset(s2f_user4_clk)
	);
	
	altera_avalon_reset_source #(
		.ASSERT_HIGH_RESET(0),
		.INITIAL_RESET_CYCLES(0)
	) s2f_reset (
		.clk(1'b0),
		.reset(s2f_user3_clk)
	);
	
	s2f_warm_reset_handshake_bfm s2f_warm_reset_handshake (
		.sig_h2f_pending_rst_req_n(s2f_pending_rst_req),
		.sig_f2h_pending_rst_ack(f2s_pending_rst_ack)
	);
	
	f2h_cold_reset_req_bfm f2h_cold_reset_req (
		.sig_f2h_cold_rst_req_n(f2s_cold_rst_req_n)
	);
	
	f2h_debug_reset_req_bfm f2h_debug_reset_req (
		.sig_f2h_dbg_rst_req_n(f2s_dbg_rst_req_n)
	);
	
	f2h_warm_reset_req_bfm f2h_warm_reset_req (
		.sig_f2h_warm_rst_req_n(f2s_warm_rst_req_n)
	);
	
endmodule
