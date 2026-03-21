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


//************************************************************
// Description:
//
// This module contains the PFL (Quad IO Flash) Configuration block
//************************************************************

// synthesis VERILOG_INPUT_VERSION VERILOG_2001

module altera_pfl2_qspi_cfg (

	clk,
	nreset,

	flash_sck,
	flash_ncs,
	flash_io0_out,
	flash_io0_in,
	flash_io1_out,
	flash_io1_in,
	flash_io2_out,
	flash_io2_in,
	flash_io3_out,
	flash_io3_in,
	flash_highz_io0,
	flash_highz_io1,
	flash_highz_io2,
	flash_highz_io3,

	fpga_conf_done,
	fpga_nstatus,
    
    //AvST interface
    avst_data,
    avst_valid,
    avst_ready,
    avst_clk,
    
	fpga_nconfig,
	pfl_nreconfigure,
	pfl_reset_watchdog,
	pfl_watchdog_error,
	
	enable_configuration,
	enable_nconfig,
	page_sel,
	
	// Access control
	flash_access_request,
	flash_access_granted
);
	parameter N_FLASH                   = 4;
	parameter ADDR_WIDTH                = 24;
	parameter SAFE_MODE_HALT 		    = 0;
	parameter SAFE_MODE_RETRY 		    = 0;
	parameter SAFE_MODE_REVERT 			= 1;
	parameter SAFE_MODE_REVERT_ADDR     = 'hABCDEF;
	parameter FLASH_OPTIONS_ADDR 	    = 'h1FE000;
	parameter CONF_DATA_WIDTH 		    = 8;
	parameter CONF_WAIT_TIMER_WIDTH     = 16;
	parameter EXTRA_ADDR_BYTE		    = 0;
	parameter FLASH_MFC			        = "ALTERA";
	parameter QFLASH_FAST_SPEED			= 0;
	parameter FLASH_STATIC_WAIT_WIDTH	= 15;
	parameter PFL_RSU_WATCHDOG_ENABLED	= 0;
	parameter RSU_WATCHDOG_COUNTER		= 100000000;
	parameter FLASH_BURST_EXTRA_CYCLE	= 0;
	parameter QSPI_DATA_DELAY		    = 0;
	parameter QSPI_DATA_DELAY_COUNT		= 1;
    parameter READY_SYNC_STAGES	        = 2;
	// Play around with the DATA WIDTH
	localparam FLASH_DATA_WIDTH         = (N_FLASH == 1)? 8 : (N_FLASH * 4);
    //If only 1 spi flash is selected, the flash width will be converted to 8 using up converter
    localparam QSPI_DATA_WIDTH          = (N_FLASH == 1)? 4 : (N_FLASH * 4);
	localparam FPGA_DATA_WIDTH 			= (CONF_DATA_WIDTH == 1)? 8 : CONF_DATA_WIDTH;
    
	
	input		clk;
	input		nreset;

	output	[N_FLASH-1:0] flash_sck;
	output	[N_FLASH-1:0] flash_ncs;
	output	[N_FLASH-1:0] flash_io0_out;
	input 	[N_FLASH-1:0] flash_io0_in;
	output 	[N_FLASH-1:0] flash_io1_out;
	input 	[N_FLASH-1:0] flash_io1_in;
	output 	[N_FLASH-1:0] flash_io2_out;
	input 	[N_FLASH-1:0] flash_io2_in;
	output 	[N_FLASH-1:0] flash_io3_out;
	input 	[N_FLASH-1:0] flash_io3_in;
	output 	flash_access_request;
	input 	flash_access_granted;
	output	flash_highz_io0;
	output	flash_highz_io1;
	output	flash_highz_io2;
	output	flash_highz_io3;
	
    //AvST interface
    output 	[CONF_DATA_WIDTH-1:0]avst_data;
    output 	avst_valid;
    input   avst_ready;
    output 	avst_clk;

	output	fpga_nconfig;
	input   fpga_conf_done;
	input   fpga_nstatus;

	input   pfl_nreconfigure;	
	input   enable_configuration;
	input 	enable_nconfig;
	input   [2:0] page_sel;

	// RSU
	input 	pfl_reset_watchdog;
	output 	pfl_watchdog_error;
	
	// Control <--> Flash
	wire 	[ADDR_WIDTH-1:0] flash_addr_control;
	wire 	[ADDR_WIDTH-1:0] flash_stop_addr;
	
	wire	flash_addr_sload;
	wire	flash_done;
	wire	[7:0] fpga_flags;
	
	// Interface between FLASH and up conveter
	wire    conv_request_flash_data;
	wire    [QSPI_DATA_WIDTH-1:0] flash_to_conv_data;
	wire    flash_to_conv_data_ready;
	wire    conv_data_read;
	
    // Interface between up conveter and control
	wire    control_request_flash_data;
	wire    [FLASH_DATA_WIDTH-1:0] conv_to_control_data;
	wire    conv_to_control_data_ready;
	wire    control_read_flash_data;
    
	// Interface between CONTROL and data adapter
	wire    [FLASH_DATA_WIDTH-1:0] controller_avalon_source_data;
	wire    controller_avalon_source_valid;
	wire    controller_avalon_source_ready;

	// Interface between data adapter and timing adapter
	wire     [FPGA_DATA_WIDTH-1:0] data_format_adapter_out_data;
	wire     data_format_adapter_out_valid;
	wire    data_format_adapter_out_ready;
    
	// Interface between timing adapter and ready synchronizer
	wire    [FPGA_DATA_WIDTH-1:0] timing_adapter_out_data;
	wire    timing_adapter_out_valid;
	wire    timing_adapter_out_ready;
    
	wire     nreset_sync;
	altera_pfl2_reset altera_pfl2_reset
	(
		.clk(clk),
		.nreset_in(nreset),
		.nreset_out(nreset_sync)
	);
	
	generate
	if (FLASH_MFC == "Altera EPCQ" || FLASH_MFC == "Micron") begin
		altera_pfl2_qspi_cfg_micron_altera altera_pfl2_qspi_cfg_micron_altera (
			.clk(clk),
			.nreset(nreset_sync),

			// Flash pins
			.flash_sck(flash_sck),
			.flash_ncs(flash_ncs),
			.flash_io0_out(flash_io0_out),
			.flash_io0_in(flash_io0_in),
			.flash_io1_out(flash_io1_out),
			.flash_io1_in(flash_io1_in),
			.flash_io2_out(flash_io2_out),
			.flash_io2_in(flash_io2_in),
			.flash_io3_out(flash_io3_out),
			.flash_io3_in(flash_io3_in),
			.flash_highz_io0(flash_highz_io0),
			.flash_highz_io1(flash_highz_io1),
			.flash_highz_io2(flash_highz_io2),
			.flash_highz_io3(flash_highz_io3),

			// Controller address
			.addr_in(flash_addr_control),
			.stop_addr_in(flash_stop_addr),
			.addr_sload(flash_addr_sload),
			.done(flash_done),
			
			// Controller data
			.data_request(conv_request_flash_data),
			.data_ready(flash_to_conv_data_ready),
			.data(flash_to_conv_data),
			.addr_cnt_en(conv_data_read),

			// Access control
			.flash_access_request(flash_access_request),
			.flash_access_granted(flash_access_granted)
		);
			defparam altera_pfl2_qspi_cfg_micron_altera.N_FLASH 		            = N_FLASH;
			defparam altera_pfl2_qspi_cfg_micron_altera.FLASH_ADDR_WIDTH 			= ADDR_WIDTH;
			defparam altera_pfl2_qspi_cfg_micron_altera.EXTRA_ADDR_BYTE  			= EXTRA_ADDR_BYTE;
			defparam altera_pfl2_qspi_cfg_micron_altera.FLASH_MFC		  	        = FLASH_MFC;
			defparam altera_pfl2_qspi_cfg_micron_altera.FLASH_BURST_EXTRA_CYCLE	    = FLASH_BURST_EXTRA_CYCLE;
			defparam altera_pfl2_qspi_cfg_micron_altera.QSPI_DATA_DELAY				= QSPI_DATA_DELAY;
			defparam altera_pfl2_qspi_cfg_micron_altera.QSPI_DATA_DELAY_COUNT		= QSPI_DATA_DELAY_COUNT;
	end
	else if (FLASH_MFC == "Macronix") begin
		altera_pfl2_qspi_cfg_macronix altera_pfl2_qspi_cfg_macronix (
			.clk(clk),
			.nreset(nreset_sync),

			// Flash pins
			.flash_sck(flash_sck),
			.flash_ncs(flash_ncs),
			.flash_io0_out(flash_io0_out),
			.flash_io0_in(flash_io0_in),
			.flash_io1_out(flash_io1_out),
			.flash_io1_in(flash_io1_in),
			.flash_io2_out(flash_io2_out),
			.flash_io2_in(flash_io2_in),
			.flash_io3_out(flash_io3_out),
			.flash_io3_in(flash_io3_in),
			.flash_highz_io0(flash_highz_io0),
			.flash_highz_io1(flash_highz_io1),
			.flash_highz_io2(flash_highz_io2),
			.flash_highz_io3(flash_highz_io3),

			// Controller address
			.addr_in(flash_addr_control),
			.stop_addr_in(flash_stop_addr),
			.addr_sload(flash_addr_sload),
			.done(flash_done),
			
			// Controller data
			.data_request(conv_request_flash_data),
			.data_ready(flash_to_conv_data_ready),
			.data(flash_to_conv_data),
			.addr_cnt_en(conv_data_read),

			// Access control
			.flash_access_request(flash_access_request),
			.flash_access_granted(flash_access_granted)
		);
			defparam altera_pfl2_qspi_cfg_macronix.N_FLASH 						= N_FLASH;
			defparam altera_pfl2_qspi_cfg_macronix.FLASH_ADDR_WIDTH 			= ADDR_WIDTH;
			defparam altera_pfl2_qspi_cfg_macronix.EXTRA_ADDR_BYTE  			= EXTRA_ADDR_BYTE;
			defparam altera_pfl2_qspi_cfg_macronix.FLASH_MFC		  				= FLASH_MFC;
			defparam altera_pfl2_qspi_cfg_macronix.FLASH_BURST_EXTRA_CYCLE	= FLASH_BURST_EXTRA_CYCLE;
			defparam altera_pfl2_qspi_cfg_macronix.QFLASH_FAST_SPEED			= QFLASH_FAST_SPEED;
			defparam altera_pfl2_qspi_cfg_macronix.FLASH_STATIC_WAIT_WIDTH	= FLASH_STATIC_WAIT_WIDTH;
			defparam altera_pfl2_qspi_cfg_macronix.QSPI_DATA_DELAY				= QSPI_DATA_DELAY;
			defparam altera_pfl2_qspi_cfg_macronix.QSPI_DATA_DELAY_COUNT		= QSPI_DATA_DELAY_COUNT;
	end
	else begin
        //For spansion, windbond and atmel for now
		altera_pfl2_qspi_cfg_others altera_pfl2_qspi_cfg_others (
			.clk(clk),
			.nreset(nreset_sync),

			// Flash pins
			.flash_sck(flash_sck),
			.flash_ncs(flash_ncs),
			.flash_io0_out(flash_io0_out),
			.flash_io0_in(flash_io0_in),
			.flash_io1_out(flash_io1_out),
			.flash_io1_in(flash_io1_in),
			.flash_io2_out(flash_io2_out),
			.flash_io2_in(flash_io2_in),
			.flash_io3_out(flash_io3_out),
			.flash_io3_in(flash_io3_in),
			.flash_highz_io0(flash_highz_io0),
			.flash_highz_io1(flash_highz_io1),
			.flash_highz_io2(flash_highz_io2),
			.flash_highz_io3(flash_highz_io3),

			// Controller address
			.addr_in(flash_addr_control),
			.stop_addr_in(flash_stop_addr),
			.addr_sload(flash_addr_sload),
			.done(flash_done),
			
			// Controller data
			.data_request(conv_request_flash_data),
			.data_ready(flash_to_conv_data_ready),
			.data(flash_to_conv_data),
			.addr_cnt_en(conv_data_read),

			// Access control
			.flash_access_request(flash_access_request),
			.flash_access_granted(flash_access_granted)
		);
			defparam altera_pfl2_qspi_cfg_others.N_FLASH 	        = N_FLASH;
			defparam altera_pfl2_qspi_cfg_others.FLASH_ADDR_WIDTH 	= ADDR_WIDTH;
			defparam altera_pfl2_qspi_cfg_others.EXTRA_ADDR_BYTE  	= EXTRA_ADDR_BYTE;
			defparam altera_pfl2_qspi_cfg_others.FLASH_MFC		    = FLASH_MFC;
	end
	endgenerate
    
    generate
    		if (N_FLASH == 1) begin
			altera_pfl2_up_converter altera_pfl2_up_converter(
				.clk(clk),
				.nreset(nreset),
				
				// Interface with flash
				.data_in(flash_to_conv_data),
				.flash_data_request(conv_request_flash_data),
				.flash_data_ready(flash_to_conv_data_ready),
				.flash_data_read(conv_data_read),
			
				// Interface with controller 
				.data_out(conv_to_control_data),
				.data_request(control_request_flash_data),
				.data_ready(conv_to_control_data_ready),
				.data_read(control_read_flash_data)
			);
			defparam
				altera_pfl2_up_converter.DATA_IN_WIDTH = 4,
				altera_pfl2_up_converter.DATA_OUT_WIDTH = 8;
            end
            else begin
                assign conv_to_control_data = flash_to_conv_data;
                assign conv_to_control_data_ready = flash_to_conv_data_ready;
                assign conv_request_flash_data = control_request_flash_data;
                assign conv_data_read = control_read_flash_data;
            end
    endgenerate
    
    wire reset_wire;
    wire reset_adapter;
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
		.flash_data_request(control_request_flash_data),
		.flash_data_ready(conv_to_control_data_ready),
		.flash_data(conv_to_control_data),
		.flash_addr_cnt_en(control_read_flash_data),
		
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
				
		// RSU watchdog timed out
		.watchdog_timed_out(pfl_watchdog_error)
	);
		defparam altera_pfl2_cfg_controller.CONF_DATA_WIDTH = FPGA_DATA_WIDTH;
		defparam altera_pfl2_cfg_controller.FLASH_DATA_WIDTH = FLASH_DATA_WIDTH;
		defparam altera_pfl2_cfg_controller.FLASH_ADDR_WIDTH = ADDR_WIDTH;
		defparam altera_pfl2_cfg_controller.SAFE_MODE_HALT = SAFE_MODE_HALT;
		defparam altera_pfl2_cfg_controller.SAFE_MODE_RETRY = SAFE_MODE_RETRY;
		defparam altera_pfl2_cfg_controller.SAFE_MODE_REVERT = SAFE_MODE_REVERT;
		defparam altera_pfl2_cfg_controller.SAFE_MODE_REVERT_ADDR = SAFE_MODE_REVERT_ADDR;
		defparam altera_pfl2_cfg_controller.FLASH_OPTIONS_ADDR = FLASH_OPTIONS_ADDR;
		defparam altera_pfl2_cfg_controller.ALWAYS_USE_BYTE_ADDR = 1;
		defparam altera_pfl2_cfg_controller.CONF_WAIT_TIMER_WIDTH = CONF_WAIT_TIMER_WIDTH;
		
	generate
		if (PFL_RSU_WATCHDOG_ENABLED == 1)begin
			alt_pfl_cfg_rsu_wd alt_pfl_cfg_rsu_wd(
				.clk(clk),
				.nreset(nreset_sync),
				.fpga_conf_done(fpga_conf_done),
				.fpga_nstatus(fpga_nstatus),
				.pfl_nreconfigure(pfl_nreconfigure),
				.watchdog_reset(pfl_reset_watchdog),
				.watchdog_timed_out(pfl_watchdog_error)
			);
				defparam alt_pfl_cfg_rsu_wd.RSU_WATCHDOG_COUNTER = RSU_WATCHDOG_COUNTER;
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
