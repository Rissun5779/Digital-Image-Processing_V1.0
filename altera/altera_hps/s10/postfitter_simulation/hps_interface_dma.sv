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


module twentynm_hps_interface_dma (
	input  wire	fpga0_dma_req,
	input  wire	fpga0_dma_single,
	output wire	fpga0_dma_peri_ack,
	input  wire	fpga1_dma_req,
	input  wire	fpga1_dma_single,
	output wire	fpga1_dma_peri_ack,
	input  wire	fpga2_dma_req,
	input  wire	fpga2_dma_single,
	output wire	fpga2_dma_peri_ack,
	input  wire	fpga3_dma_req,
	input  wire	fpga3_dma_single,
	output wire	fpga3_dma_peri_ack,
	input  wire	fpga4_dma_req,
	input  wire	fpga4_dma_single,
	output wire	fpga4_dma_peri_ack,
	input  wire	fpga5_dma_req,
	input  wire	fpga5_dma_single,
	output wire	fpga5_dma_peri_ack,
	input  wire	fpga6_dma_req,
	input  wire	fpga6_dma_single,
	output wire	fpga6_dma_peri_ack,
	input  wire	fpga7_dma_req,
	input  wire	fpga7_dma_single,
	output wire	fpga7_dma_peri_ack
);

	dma_channel0_bfm f2h_dma_req0 (
		.sig_channel0_req(fpga0_dma_req),
		.sig_channel0_single(fpga0_dma_single),
		.sig_channel0_xx_ack(fpga0_dma_peri_ack)
	);
	
	dma_channel1_bfm f2h_dma_req1 (
		.sig_channel1_req(fpga1_dma_req),
		.sig_channel1_single(fpga1_dma_single),
		.sig_channel1_xx_ack(fpga1_dma_peri_ack)
	);
	
	dma_channel2_bfm f2h_dma_req2 (
		.sig_channel2_req(fpga2_dma_req),
		.sig_channel2_single(fpga2_dma_single),
		.sig_channel2_xx_ack(fpga2_dma_peri_ack)
	);
	
	dma_channel3_bfm f2h_dma_req3 (
		.sig_channel3_req(fpga3_dma_req),
		.sig_channel3_single(fpga3_dma_single),
		.sig_channel3_xx_ack(fpga3_dma_peri_ack)
	);
	
	dma_channel4_bfm f2h_dma_req4 (
		.sig_channel4_req(fpga4_dma_req),
		.sig_channel4_single(fpga4_dma_single),
		.sig_channel4_xx_ack(fpga4_dma_peri_ack)
	);
	
	dma_channel5_bfm f2h_dma_req5 (
		.sig_channel5_req(fpga5_dma_req),
		.sig_channel5_single(fpga5_dma_single),
		.sig_channel5_xx_ack(fpga5_dma_peri_ack)
	);
	
	dma_channel6_bfm f2h_dma_req6 (
		.sig_channel6_req(fpga6_dma_req),
		.sig_channel6_single(fpga6_dma_single),
		.sig_channel6_xx_ack(fpga6_dma_peri_ack)
	);
	
	dma_channel7_bfm f2h_dma_req7 (
		.sig_channel7_req(fpga7_dma_req),
		.sig_channel7_single(fpga7_dma_single),
		.sig_channel7_xx_ack(fpga7_dma_peri_ack)
	);
	
endmodule
