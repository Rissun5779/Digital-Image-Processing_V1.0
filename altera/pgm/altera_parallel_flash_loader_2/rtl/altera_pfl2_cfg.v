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


////////////////////////////////////////////////////////////////////
//
//   ALT_PFL_CFG3
//
//  (c) Altera Corporation, 2007
//
//
//
////////////////////////////////////////////////////////////////////

//************************************************************
// Description:
//
// This module contains the PFL configuration block
//************************************************************

// synthesis VERILOG_INPUT_VERSION VERILOG_2001

module altera_pfl2_cfg (
	clk,
	nreset,
	flash_addr,
	flash_data_in,
	flash_data_out,
	flash_select,
	flash_read,
	flash_write,
	flash_clk,
	flash_nadv,
	flash_rdy,
	flash_nreset,
	flash_data_highz,
	
	flash_access_request,
	flash_access_granted,

	avst_data,
	avst_clk,
	avst_valid,
	avst_ready,
	fpga_nconfig,
	fpga_conf_done,
	fpga_nstatus,

	pfl_nreconfigure,
	pfl_reset_watchdog,
	pfl_watchdog_error,

	enable_configuration,
	enable_nconfig,
	
	page_sel
)/* synthesis altera_attribute = "SUPPRESS_DA_RULE_INTERNAL=s102"*/;
	parameter FLASH_DATA_WIDTH                  = 16;
	parameter FLASH_ADDR_WIDTH                  = 25;
	parameter SAFE_MODE_HALT                    = 0;
	parameter SAFE_MODE_RETRY                   = 0;
	parameter SAFE_MODE_REVERT	                = 1;
	parameter SAFE_MODE_REVERT_ADDR             = 'hABCDEF;
	parameter FLASH_OPTIONS_ADDR                = 'h1FE000;
	parameter CONF_DATA_WIDTH                   = 16;
	parameter ACCESS_CLK_DIVISOR                = 10;
	parameter PAGE_ACCESS_CLK_DIVISOR           = 3;
	parameter NORMAL_MODE                       = 1;
	parameter BURST_MODE                        = 0;
	parameter PAGE_MODE                         = 0;
	parameter MT28EW_PAGE_MODE                  = 0;
	parameter BURST_MODE_SPANSION               = 0;
	parameter BURST_MODE_INTEL                  = 0;
	parameter BURST_MODE_NUMONYX                = 0;
	parameter CONF_WAIT_TIMER_WIDTH             = 16;
	parameter BURST_MODE_LATENCY_COUNT          = 4;
	parameter PFL_RSU_WATCHDOG_ENABLED          = 1;	
	parameter RSU_WATCHDOG_COUNTER              = 100000000;
	parameter FLASH_BURST_EXTRA_CYCLE           = 0;
    parameter READY_SYNC_STAGES	                 = 2;
	// Play around with the DATA WIDTH
	localparam FPGA_DATA_WIDTH					= (CONF_DATA_WIDTH == 1) ? 8 : CONF_DATA_WIDTH;

	input		clk;
	input		nreset;

	output	[FLASH_ADDR_WIDTH-1:0] flash_addr;
	input	[FLASH_DATA_WIDTH-1:0] flash_data_in;
	output	[FLASH_DATA_WIDTH-1:0] flash_data_out;
	output	flash_select;
	output	flash_read;
	output	flash_write;
	output	flash_clk;
	output	flash_nadv;
	input	flash_rdy;
	output	flash_nreset;
	output	flash_data_highz;
	output	flash_access_request;
	input	flash_access_granted;
	
	output	[FPGA_DATA_WIDTH-1:0] 	avst_data;
	output 	avst_clk;
	output 	avst_valid;
	input 	avst_ready;
	output	fpga_nconfig;
	input	fpga_conf_done;
	input	fpga_nstatus;

	input	pfl_nreconfigure;
	input	pfl_reset_watchdog;
	output	pfl_watchdog_error;
	
	input	[2:0] page_sel;
	
	// RSU
	input	enable_configuration;
	input	enable_nconfig;

	// Control <--> Flash
	wire		[FLASH_ADDR_WIDTH-1:0] flash_addr_control;
	wire		[FLASH_ADDR_WIDTH-1:0] flash_stop_addr;

	wire		flash_addr_sload;
	wire		flash_done;
	
	wire		[7:0] fpga_flags;

	// Interface between FLASH and CONTROL
	wire request_flash_data;
	wire [FLASH_DATA_WIDTH-1:0] flash_to_control_data;
	wire flash_to_control_data_ready;
	wire read_flash_data;
	
	// Interface between CONTROL and data adapter
	wire [FLASH_DATA_WIDTH-1:0] controller_avalon_source_data;
	wire controller_avalon_source_valid;
	wire controller_avalon_source_ready;

	// Interface between data adapter and timing adapter
	wire [FPGA_DATA_WIDTH-1:0] data_format_adapter_out_data;
	wire data_format_adapter_out_valid;
	wire data_format_adapter_out_ready;
    
	// Interface between timing adapter and ready synchronizer
	wire [FPGA_DATA_WIDTH-1:0] timing_adapter_out_data;
	wire timing_adapter_out_valid;
	wire timing_adapter_out_ready;
    
    
	wire nreset_sync;
	altera_pfl2_reset altera_pfl2_reset
	(
		.clk(clk),
		.nreset_in(nreset),
		.nreset_out(nreset_sync)
	);
	
	generate
        // when the burst mode is selected
		if (BURST_MODE==1) begin
			altera_pfl2_cfg_cfi_intel_burst altera_pfl2_cfg_cfi_intel_burst (
				.clk(clk),
				.nreset(nreset_sync),

				// Flash pins
				.flash_select(flash_select),
				.flash_read(flash_read),
				.flash_write(flash_write),
				.flash_data_in(flash_data_in),
				.flash_data_out(flash_data_out),
				.flash_addr(flash_addr),
				.flash_nadv(flash_nadv),
				.flash_clk(flash_clk),
				.flash_rdy(flash_rdy),
				.flash_nreset(flash_nreset),
				.flash_data_highz(flash_data_highz),

				// Controller address
				.addr_in(flash_addr_control),
				.stop_addr_in(flash_stop_addr),
				.addr_sload(flash_addr_sload),
				.done(flash_done),
				
				// Controller data
				.data_request(request_flash_data),
				.data_ready(flash_to_control_data_ready),
				.data(flash_to_control_data),
				.addr_cnt_en(read_flash_data),

				// Access control
				.flash_access_request(flash_access_request),
				.flash_access_granted(flash_access_granted)
			);
			defparam altera_pfl2_cfg_cfi_intel_burst.FLASH_DATA_WIDTH = FLASH_DATA_WIDTH;
			defparam altera_pfl2_cfg_cfi_intel_burst.FLASH_ADDR_WIDTH = FLASH_ADDR_WIDTH;
			defparam altera_pfl2_cfg_cfi_intel_burst.ACCESS_CLK_DIVISOR = ACCESS_CLK_DIVISOR;
			defparam altera_pfl2_cfg_cfi_intel_burst.BURST_MODE_SPANSION = BURST_MODE_SPANSION;
			defparam altera_pfl2_cfg_cfi_intel_burst.BURST_MODE_NUMONYX = BURST_MODE_NUMONYX;
			defparam altera_pfl2_cfg_cfi_intel_burst.FLASH_BURST_EXTRA_CYCLE = FLASH_BURST_EXTRA_CYCLE;
			defparam altera_pfl2_cfg_cfi_intel_burst.BURST_MODE_LATENCY_COUNT = BURST_MODE_LATENCY_COUNT;
		end
        //when the spansion page mode or mt28ew page mode is selected
		else if (PAGE_MODE == 1 || MT28EW_PAGE_MODE == 1) begin
				altera_pfl2_cfg_cfi_spansion_page altera_pfl2_cfg_cfi_spansion_page (
				.clk(clk),
				.nreset(nreset_sync),

				// Flash pins
				.flash_select(flash_select),
				.flash_read(flash_read),
				.flash_write(flash_write),
				.flash_data_in(flash_data_in),
				.flash_data_out(flash_data_out),
				.flash_addr(flash_addr),
				.flash_nadv(flash_nadv),
				.flash_clk(flash_clk),
				.flash_rdy(flash_rdy),
				.flash_nreset(flash_nreset),
				.flash_data_highz(flash_data_highz),

				// Controller address
				.addr_in(flash_addr_control),
				.stop_addr_in(flash_stop_addr),
				.addr_sload(flash_addr_sload),
				.done(flash_done),
				
				// Controller data
				.data_request(request_flash_data),
				.data_ready(flash_to_control_data_ready),
				.data(flash_to_control_data),
				.addr_cnt_en(read_flash_data),

				// Access control
				.flash_access_request(flash_access_request),
				.flash_access_granted(flash_access_granted)
			);
			defparam altera_pfl2_cfg_cfi_spansion_page.FLASH_DATA_WIDTH			= FLASH_DATA_WIDTH;
			defparam altera_pfl2_cfg_cfi_spansion_page.FLASH_ADDR_WIDTH			= FLASH_ADDR_WIDTH;
			defparam altera_pfl2_cfg_cfi_spansion_page.ACCESS_CLK_DIVISOR		= ACCESS_CLK_DIVISOR;
			defparam altera_pfl2_cfg_cfi_spansion_page.PAGE_ACCESS_CLK_DIVISOR	= PAGE_ACCESS_CLK_DIVISOR;		
			defparam altera_pfl2_cfg_cfi_spansion_page.MT28EW_PAGE_MODE			= MT28EW_PAGE_MODE;	
		end 
        //when normal read is selected
		else begin
			altera_pfl2_cfg_cfi_normal_read altera_pfl2_cfg_cfi_normal_read (
				.clk(clk),
				.nreset(nreset_sync),

				// Flash pins
				.flash_select(flash_select),
				.flash_read(flash_read),
				.flash_write(flash_write),
				.flash_data_in(flash_data_in),
				.flash_data_out(flash_data_out),
				.flash_addr(flash_addr),
				.flash_nadv(flash_nadv),
				.flash_clk(flash_clk),
				.flash_rdy(flash_rdy),
				.flash_nreset(flash_nreset),
				.flash_data_highz(flash_data_highz),

				// Controller address
				.addr_in(flash_addr_control),
				.stop_addr_in(flash_stop_addr),
				.addr_sload(flash_addr_sload),
				.done(flash_done),
				
				// Controller data
				.data_request(request_flash_data),
				.data_ready(flash_to_control_data_ready),
				.data(flash_to_control_data),
				.addr_cnt_en(read_flash_data),

				// Access control
				.flash_access_request(flash_access_request),
				.flash_access_granted(flash_access_granted)
			);
			defparam altera_pfl2_cfg_cfi_normal_read.FLASH_DATA_WIDTH	= FLASH_DATA_WIDTH;
			defparam altera_pfl2_cfg_cfi_normal_read.FLASH_ADDR_WIDTH	= FLASH_ADDR_WIDTH;
			defparam altera_pfl2_cfg_cfi_normal_read.ACCESS_CLK_DIVISOR	= ACCESS_CLK_DIVISOR;
		end
	endgenerate
	
    wire reset_adapter;
    wire reset_wire;
    // reset avst module when nreset is low or controller enter error state
    assign reset_adapter = nreset_sync && reset_wire;
	altera_pfl2_cfg_controller altera_pfl2_cfg_controller (
		.clk(clk),
		.nreset(nreset_sync),
        .reset_adapter(reset_wire),
		// Flash reader block address pins
		.flash_stop_addr(flash_stop_addr),
		.flash_addr_out(flash_addr_control),
		.flash_addr_sload(flash_addr_sload),
		.flash_done(flash_done),

		// Flash reader block data pins
		.flash_data_request(request_flash_data),
		.flash_data_ready(flash_to_control_data_ready),
		.flash_data(flash_to_control_data),
		.flash_addr_cnt_en(read_flash_data),
		
		// Avst 
		.avst_data(controller_avalon_source_data),
		.avst_valid(controller_avalon_source_valid),
		.avst_clk(avst_clk),
		.avst_ready(controller_avalon_source_ready),
	
		// State control pins from FPGA configuration block
		.enable_configuration(enable_configuration),
		.enable_nconfig(enable_nconfig),
		
		// External control pins
		.fpga_nstatus(fpga_nstatus),
		.fpga_nconfig(fpga_nconfig),
		.fpga_condone(fpga_conf_done),
		.pfl_nreconfigure(pfl_nreconfigure),
		.page_sel(page_sel),
		//.ready(control_ready),
		//.enable_decompressor(enable_decompressor),

		// RSU watchdog timed out
		.watchdog_timed_out(pfl_watchdog_error)
	);
		defparam altera_pfl2_cfg_controller.CONF_DATA_WIDTH 			= FPGA_DATA_WIDTH;
		defparam altera_pfl2_cfg_controller.FLASH_DATA_WIDTH 			= FLASH_DATA_WIDTH;
		defparam altera_pfl2_cfg_controller.FLASH_ADDR_WIDTH 			= FLASH_ADDR_WIDTH;
		defparam altera_pfl2_cfg_controller.SAFE_MODE_HALT 			= SAFE_MODE_HALT;
		defparam altera_pfl2_cfg_controller.SAFE_MODE_RETRY 			= SAFE_MODE_RETRY;
		defparam altera_pfl2_cfg_controller.SAFE_MODE_REVERT 			= SAFE_MODE_REVERT;
		defparam altera_pfl2_cfg_controller.SAFE_MODE_REVERT_ADDR 	= SAFE_MODE_REVERT_ADDR;
		defparam altera_pfl2_cfg_controller.FLASH_OPTIONS_ADDR 		= FLASH_OPTIONS_ADDR;
		defparam altera_pfl2_cfg_controller.CONF_WAIT_TIMER_WIDTH	= CONF_WAIT_TIMER_WIDTH;
	

	generate	
		if (PFL_RSU_WATCHDOG_ENABLED == 1) begin
			altera_pfl2_cfg_rsu_wd altera_pfl2_cfg_rsu_wd(
				.clk(clk),
				.nreset(nreset_sync),
				.fpga_conf_done(fpga_conf_done),
				.fpga_nstatus(fpga_nstatus),
				.pfl_nreconfigure(pfl_nreconfigure),
				.watchdog_reset(pfl_reset_watchdog),
				.watchdog_timed_out(pfl_watchdog_error)
			);
				defparam altera_pfl2_cfg_rsu_wd.RSU_WATCHDOG_COUNTER = RSU_WATCHDOG_COUNTER;
		end
		else begin
			assign pfl_watchdog_error = 1'b0;
		end
	endgenerate
	
	altera_pfl2_data_format_adapter data_format_adapter_0 (
	.clk       (clk),                                     //   clk.clk
	.reset_n   (reset_adapter),             // reset.reset_n
	.in_data   (controller_avalon_source_data),  //    in.data
	.in_valid  (controller_avalon_source_valid), //      .valid
	.in_ready  (controller_avalon_source_ready), //      .ready
	.out_data  (data_format_adapter_out_data),              //   out.data
	.out_valid (data_format_adapter_out_valid),             //      .valid
	.out_ready (data_format_adapter_out_ready)              //      .ready
	);
		
	altera_pfl2_timing_adapter timing_adapter_0 (
	.clk       (clk),                         //   clk.clk
	.reset_n   (reset_adapter), // reset.reset_n
	.in_data   (data_format_adapter_out_data),  //    in.data
	.in_valid  (data_format_adapter_out_valid), //      .valid
	.in_ready  (data_format_adapter_out_ready), //      .ready
	.out_data  (timing_adapter_out_data),       //   out.data
	.out_valid (timing_adapter_out_valid),      //      .valid
	.out_ready (timing_adapter_out_ready)       //      .ready
	);

    altera_pfl2_cfg_ready_synchronizer ready_synchronizer (
	.clk       (clk),                         //   clk.clk
	.reset_n   (reset_adapter), // reset.reset_n
	.in_data   (timing_adapter_out_data),  //    in.data
	.in_valid  (timing_adapter_out_valid), //      .valid
	.in_ready  (timing_adapter_out_ready), //      .ready
	.out_data  (avst_data),       //   out.data
	.out_valid (avst_valid),      //      .valid
	.out_ready (avst_ready)       //      .ready
	);
	
    defparam ready_synchronizer.DATA_WIDTH = FPGA_DATA_WIDTH;
    defparam ready_synchronizer.STAGES = READY_SYNC_STAGES;
endmodule
