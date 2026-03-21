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
//   ALT_PFL_CFG3_CONTROL
//
//  (c) Altera Corporation, 2007
//
//
//
////////////////////////////////////////////////////////////////////

//************************************************************
// Description:
//
// This module contains the PFL configuration controller block
// This module only specially handle AvST
//************************************************************

//Verilog HDL assignment warning at altera_pfl2_cfg_controller.v: truncated value with size <> to match size of target <>
// altera message_off 10230
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
module altera_pfl2_cfg_controller (
	clk,
	nreset,
    reset_adapter,
    

	// Flash reader block address pins
	flash_stop_addr,
	flash_addr_out,
	flash_addr_sload,
	flash_addr_cnt_en,
	flash_done,
	
	// Flash reader block data pins
	flash_data_request,
	flash_data_ready,
	flash_data,
	
	// Avst 
	avst_data,
	avst_valid,
	avst_clk,
	avst_ready,
	
	// PGM allow configuration
	enable_configuration,
	enable_nconfig,
	
	// External control pins
	fpga_nstatus,
	fpga_condone,
	fpga_nconfig,
	pfl_nreconfigure,
	page_sel,
	
	// RSU watchdog timed out
	watchdog_timed_out
	
);
    parameter ALWAYS_USE_BYTE_ADDR						= 0;
    parameter CONF_DATA_WIDTH							= 16;
    parameter CONF_WAIT_TIMER_WIDTH						= 16;
    parameter FLASH_ADDR_WIDTH 							= 25;
    parameter FLASH_DATA_WIDTH 							= 16;
    parameter FLASH_OPTIONS_ADDR 						= 'h1FE000;
    parameter FLASH_START_INDEX 						= (ALWAYS_USE_BYTE_ADDR == 1) ? 0 : 
                                                            ((FLASH_DATA_WIDTH == 32) ? 2 : (FLASH_DATA_WIDTH == 16) ? 1 : 0);
    parameter FLASH_BYTE_ADDR_WIDTH 	                = FLASH_ADDR_WIDTH + FLASH_START_INDEX;
    parameter SAFE_MODE_HALT 							= 0;
    parameter SAFE_MODE_RETRY 							= 0;
    parameter SAFE_MODE_REVERT 							= 1;
    parameter SAFE_MODE_REVERT_ADDR 					= 'hABCDEF;
    parameter VERSION_OFFSET 			                = 'h80;
    
    localparam PACKET_WIDTH								= (FLASH_DATA_WIDTH == 32)? 14 : 
                                                            (FLASH_DATA_WIDTH == 16)? 15 : 16;
    localparam COUNTER_WIDTH							= (CONF_WAIT_TIMER_WIDTH > PACKET_WIDTH)? CONF_WAIT_TIMER_WIDTH : PACKET_WIDTH;
    localparam EXTRA_PACKET_WIDTH						= (COUNTER_WIDTH - PACKET_WIDTH);
    localparam EXTRA_TIMER_WIDTH						= (COUNTER_WIDTH - CONF_WAIT_TIMER_WIDTH);
    localparam [2:0] READ_OPTION_INDEX					= (FLASH_DATA_WIDTH == 32)? 3'd01 : 
                                                            (FLASH_DATA_WIDTH == 16)? 3'd3 : 3'd7;
    localparam [1:0] READ_HEADER_INDEX					= (FLASH_DATA_WIDTH == 32)? 2'd0 : 
                                                            (FLASH_DATA_WIDTH == 16)? 2'd1 : 2'd03;
    localparam [COUNTER_WIDTH-1:0] NCONFIG_TIMER		= {{(COUNTER_WIDTH-10){1'b0}}, 10'h3FF}; 	// This is for CFG_NCONFIG, CFG_NSTATUS_WAIT
    localparam [COUNTER_WIDTH-1:0] SMALLEST_TIMER	    = {{(COUNTER_WIDTH-16){1'b0}}, 16'hFFFF};	// This is for CFG_USERMODE_CONFIRM
    localparam [COUNTER_WIDTH-1:0] LARGEST_TIMER		= (EXTRA_TIMER_WIDTH == 0) ? {(CONF_WAIT_TIMER_WIDTH){1'b1}} :		// This is for CFG_NSTATUS, CFG_USERMODE_WAIT
                                                            {{(EXTRA_TIMER_WIDTH){1'b0}}, {(CONF_WAIT_TIMER_WIDTH){1'b1}}}; 				
    
    input 	clk;
    input 	nreset;
    output  reset_adapter;
	
	// We still need to remain this start and stop addr in nature of byte size
	// This is because the data stored in our POF file is in byte unit
	// Flash reader block address pins
    output 	[FLASH_ADDR_WIDTH-1:0] flash_addr_out;
    output 	[FLASH_ADDR_WIDTH-1:0] flash_stop_addr;
	
    input	flash_done;
    output	flash_addr_cnt_en;
    output	flash_addr_sload;
	
	// Flash reader block data pins
    input   [FLASH_DATA_WIDTH-1:0] flash_data;
    input	flash_data_ready;
    output	flash_data_request;

	
	// Avst 
	output	[FLASH_DATA_WIDTH-1:0] avst_data;
	output avst_valid;
	output avst_clk;
	input avst_ready;
	
	// PGM allow configuration
    input	enable_configuration;
    input	enable_nconfig;
	
	// External control pins
    input	[2:0] page_sel;
    input 	fpga_condone;
    input	fpga_nstatus;
    input	pfl_nreconfigure;
    output	fpga_nconfig;


	// RSU
    input	watchdog_timed_out;
	
	// State Machine
	reg [5:0] current_state /* synthesis altera_attribute = "-name SUPPRESS_REG_MINIMIZATION_MSG ON" */;
	reg [5:0] next_state;
	parameter CFG_SAME                      = 6'd0;
	parameter CFG_POWERUP                   = 6'd1;
	parameter CFG_INIT                      = 6'd2;
	// assert NCONFIG
	parameter CFG_PRE_NCONFIG               = 6'd3;
	parameter CFG_LOAD_NCONFIG              = 6'd4;
	parameter CFG_NCONFIG                   = 6'd5;
	parameter CFG_RECONFIG_WAIT             = 6'd6;
	// make sure NSTATUS is stable (low) for one period
	parameter CFG_PRE_NCONFIG_WAIT          = 6'd40;
	parameter CFG_LOAD_NCONFIG_WAIT         = 6'd41;
	parameter CFG_NCONFIG_WAIT              = 6'd42;
	// make sure NSTATUS goes high within one period
	parameter CFG_PRE_NSTATUS               = 6'd7;
	parameter CFG_LOAD_NSTATUS              = 6'd8;
	parameter CFG_NSTATUS                   = 6'd9;
	// make sure NSTATUS is stable (high) for one period
	parameter CFG_PRE_NSTATUS_WAIT          = 6'd10;
	parameter CFG_LOAD_NSTATUS_WAIT         = 6'd11;
	parameter CFG_NSTATUS_WAIT              = 6'd12;
	// make sure CONDONE goes high within one period
	parameter CFG_PRE_USERMODE_WAIT         = 6'd13;
	parameter CFG_LOAD_USERMODE_WAIT        = 6'd14;
	parameter CFG_USERMODE_WAIT             = 6'd15;
	// make sure CONDONE is stable for one period
	parameter CFG_PRE_USERMODE_CONFIRM      = 6'd16;
	parameter CFG_LOAD_USERMODE_CONFIRM     = 6'd17;
	parameter CFG_USERMODE_CONFIRM          = 6'd18;
	// stop
	parameter CFG_USERMODE                  = 6'd19;
	// read version
	parameter CFG_PRE_VERSION               = 6'd20;
	parameter CFG_LOAD_VERSION              = 6'd21;
	parameter CFG_VERSION                   = 6'd22;
	parameter CFG_VERSION_DUMMY             = 6'd23;
	// read option
	parameter CFG_PRE_OPTION                = 6'd24;
	parameter CFG_LOAD_OPTION               = 6'd25;
	parameter CFG_OPTION                    = 6'd26;
	parameter CFG_OPTION_DUMMY              = 6'd27;
	// read header
	parameter CFG_PRE_HEADER                = 6'd28;
	parameter CFG_LOAD_HEADER               = 6'd29;
	parameter CFG_HEADER                    = 6'd30;
	parameter CFG_HEADER_DUMMY              = 6'd31;
	// read data
	parameter CFG_PRE_DATA                  = 6'd32;
	parameter CFG_LOAD_DATA                 = 6'd33;
	parameter CFG_DATA                      = 6'd34;
	parameter CFG_DATA_DUMMY                = 6'd35;
	// Error handling
	parameter CFG_ERROR                     = 6'd36;
	parameter CFG_REVERT                    = 6'd37;
	parameter CFG_HALT                      = 6'd38;
	parameter CFG_RECONFIG                  = 6'd39;
    
    
    wire [COUNTER_WIDTH-1:0] counter_q;
    wire [COUNTER_WIDTH-1:0] header_packet_length;
    wire [COUNTER_WIDTH-1:0] header_packet_minus_two_length_wire;
    reg  [COUNTER_WIDTH-1:0] counter_data;
    reg  [COUNTER_WIDTH-1:0] header_packet_minus_two_length;
    
    wire [FLASH_BYTE_ADDR_WIDTH-1:0] option_addr_v5;
    wire [FLASH_BYTE_ADDR_WIDTH-1:0] page_end_addr;
    wire [FLASH_BYTE_ADDR_WIDTH-1:0] page_start_addr;
    reg  [FLASH_BYTE_ADDR_WIDTH-1:0] flash_byte_addr_out;
    

    wire counter_cnt_en;
    wire counter_done_almost_done;
    wire data_block_complete;
    wire enable_configuration_sync;
    wire enable_nconfig_sync;
    wire fpga_nconfig_signal;
    wire fpga_nstatus_sync;
    wire fpga_condone_sync;
    wire page_done_bit;
    wire pfl_nreconfigure_sync;
    wire pof_packetized;
    wire read_counter_almost_done;
    wire virtual_version3;
    
    reg	[31:0] header_bits;
    reg	[63:0] option_bits;
    reg [2:0] page_sel_latch;
    reg [2:0] option_bit_counter;
    reg [1:0] header_bit_counter;
    reg cntl_req_conv;
    reg counter_done;	
    reg	dummy_byte;
    reg one_transaction_package = 1'b0;
    reg read_counter_done;
    reg reconfigure;
    reg revert;
    reg sload_counter;
    reg version5;
    wire fpga_read_data;
    
	// Options bits definition and information extracted from Options bits
    // each page holds 64 bits as compare to older version (32bits only)
    // Because in AVST PFL we want to know the exact end address, rather than block address
    // first 32bits:    [31:11] This is 21 bits addressible start address
    //                          In PFL we will append 13 bits (our start page always has 8K boundary check). 
    //                          Making total of 34bits of address which is 32GB (large enough for future expansion)
    //                  [10:1] This is reserved
    //                  [0] valid or done bit
    // second 32bits:   [64:32] This is 32 bits addressible end address
    //                          In PFL we will append 2 bits (starting 28nm, device is 32 data-width, making it word-aligned make sense)
    //                          Making total of 34bits, which is same as start address resolution
	assign	page_end_addr 	= {(option_bits[FLASH_BYTE_ADDR_WIDTH + 30 :32] + 1'd1), 2'b00};   //-2 +32
	assign	page_start_addr = {option_bits[FLASH_BYTE_ADDR_WIDTH - 4 : 11], 13'b0}; // -13 -2 + 11
	assign	page_done_bit = option_bits[0];

	// Header bits definition and information extracted from Header bits
	always @ (posedge clk) begin
		if (current_state == CFG_HEADER_DUMMY) begin
			dummy_byte <= (FLASH_DATA_WIDTH == 8) && header_packet_length[0];
		end
	end
	generate
		if (EXTRA_PACKET_WIDTH == 0 && FLASH_DATA_WIDTH == 8) begin
			assign header_packet_length = header_bits[31:16];
		end
		else if (FLASH_DATA_WIDTH == 8) begin
			assign header_packet_length = {{(EXTRA_PACKET_WIDTH){1'b0}}, header_bits[31:16]};
		end
		else if (EXTRA_PACKET_WIDTH == 0 && FLASH_DATA_WIDTH == 16) begin
			assign header_packet_length = header_bits[31:17];
		end
		else if (FLASH_DATA_WIDTH == 16) begin
			assign header_packet_length = {{(EXTRA_PACKET_WIDTH){1'b0}}, header_bits[31:17]};
		end
		else if (EXTRA_PACKET_WIDTH == 0 && FLASH_DATA_WIDTH == 32) begin
			assign header_packet_length = header_bits[31:18];
		end
		else begin
			assign header_packet_length = {{(EXTRA_PACKET_WIDTH){1'b0}}, header_bits[31:18]};
		end
	endgenerate
	
	// Conversion from byte information to flash_data_width
	assign option_addr_v5 = FLASH_OPTIONS_ADDR[FLASH_BYTE_ADDR_WIDTH-1:0] | {page_sel_latch,3'b0};
	always @ (posedge clk) begin
		if (current_state == CFG_PRE_VERSION) 							// Read Version
			flash_byte_addr_out <= FLASH_OPTIONS_ADDR[FLASH_BYTE_ADDR_WIDTH-1:0] | VERSION_OFFSET[FLASH_BYTE_ADDR_WIDTH-1:0];
		else if (current_state == CFG_PRE_OPTION)						// Read Option Bits (Older version)
			flash_byte_addr_out <= option_addr_v5;
		else if (current_state == CFG_PRE_HEADER & revert)			// Revert Addr		
			flash_byte_addr_out <= SAFE_MODE_REVERT_ADDR[FLASH_BYTE_ADDR_WIDTH-1:0];
		else if (current_state == CFG_PRE_HEADER)						// Read Package
			flash_byte_addr_out <= page_start_addr;
	end
	assign flash_addr_out = flash_byte_addr_out[FLASH_BYTE_ADDR_WIDTH-1:FLASH_START_INDEX];
	assign flash_stop_addr = page_end_addr[FLASH_BYTE_ADDR_WIDTH-1:FLASH_START_INDEX];	

	// Make connection TO Flash module
	assign flash_addr_sload = current_state == CFG_LOAD_VERSION ||
										current_state == CFG_LOAD_OPTION ||
										current_state == CFG_LOAD_HEADER;

	
	// Make connection TO CONV
	assign flash_data_request = current_state == CFG_VERSION || current_state == CFG_OPTION ||
										current_state == CFG_HEADER || current_state == CFG_HEADER_DUMMY || 
										current_state == CFG_PRE_DATA || current_state == CFG_LOAD_DATA || 
										current_state == CFG_DATA || current_state == CFG_DATA_DUMMY;

	assign flash_addr_cnt_en = ((current_state == CFG_OPTION || current_state == CFG_HEADER || (current_state == CFG_DATA_DUMMY & dummy_byte)) & flash_data_ready) ||
									(current_state == CFG_DATA & fpga_read_data);


	// AvST connection
	assign avst_data = flash_data;
	assign avst_clk = clk;
	assign avst_valid = (flash_data_ready & current_state == CFG_DATA);
	assign fpga_read_data = (avst_ready & flash_data_ready);
		
    assign reset_adapter = ~(current_state == CFG_POWERUP ||
                            current_state == CFG_ERROR ||
                            current_state == CFG_RECONFIG
                            );
	
	// This is to get the version of POF
	
	always @(posedge clk)
	begin
		if (current_state == CFG_VERSION && flash_data_ready) begin
			version5 <= (flash_data[7:0] == 8'h05) ? 1'b1 : 1'b0;
		end
	end
    
			
	// Handling the reconfiguration (Either from Error or PFL nreconfigure)
	always @ (posedge clk) begin
		if (current_state == CFG_RECONFIG)
			page_sel_latch <= page_sel;
		else if (current_state == CFG_PRE_VERSION & ~reconfigure)
			page_sel_latch <= page_sel;
	end
	
	always @ (negedge nreset or posedge clk) begin
		if (~nreset)
			reconfigure <= 1'b0;
		else begin
			if (current_state == CFG_PRE_VERSION)
				reconfigure <= 1'b0;
			else if (~pfl_nreconfigure_sync)
				reconfigure <= 1'b1;
		end
	end
	
	always @ (negedge nreset or posedge clk) begin
		if (~nreset)
			revert <= 1'b0;
		else begin
			if (current_state == CFG_REVERT)
				 revert <= 1'b1;
			else if (current_state == CFG_RECONFIG)
				revert <= 1'b0;
		end
	end
	initial begin
		reconfigure = 1'b0;
		revert = 1'b0;
		dummy_byte = 1'b0;
	end
	// for AVst, make sure the flash input must be 8 ,16 ,32
	generate
		if (FLASH_DATA_WIDTH == 8) begin
			always @(posedge clk) begin
				if (current_state == CFG_OPTION & flash_data_ready) begin
					if (option_bit_counter == 3'd7)
						option_bits[63:56] <= flash_data;
					else if (option_bit_counter == 3'd6)
						option_bits[55:48] <= flash_data;
					else if (option_bit_counter == 3'd5)
						option_bits[47:40] <= flash_data;
					else if (option_bit_counter == 3'd4)
						option_bits[39:32] <= flash_data;
                    else if (option_bit_counter == 3'd3)
						option_bits[31:24] <= flash_data;
					else if (option_bit_counter == 3'd2)
						option_bits[23:16] <= flash_data;
					else if (option_bit_counter == 3'd1)
						option_bits[15:8] <= flash_data;
					else
						option_bits[7:0] <= flash_data;
				end
			end
			
			always @(posedge clk) begin
				if (current_state == CFG_HEADER & flash_data_ready) begin
					if (header_bit_counter == 2'b11)
						header_bits[31:24] <= flash_data;
					else if (header_bit_counter == 2'b10)
						header_bits[23:16] <= flash_data;
					else if (header_bit_counter == 2'b01)
						header_bits[15:8] <= flash_data;
					else
						header_bits[7:0] <= flash_data;	
				end
			end
		end
		else if (FLASH_DATA_WIDTH == 16) begin
			always @(posedge clk) begin
				if ((current_state == CFG_PRE_OPTION )) begin
					option_bits[63:0] <= 64'h0;
				end
                else if ((current_state == CFG_OPTION ) & flash_data_ready) begin
					//option_bits[63:0] <= {option_bits[15:0], flash_data};	
                    if (option_bit_counter == 3'd3)
						option_bits[63:48] <= flash_data;
					else if (option_bit_counter == 3'd2)
						option_bits[47:32] <= flash_data;
					else if (option_bit_counter == 3'd1)
						option_bits[31:16] <= flash_data;
					else
						option_bits[15:0] <= flash_data;	
				end
			end
			
			always @(posedge clk) begin
				if ((current_state == CFG_HEADER) & flash_data_ready) begin
					if (header_bit_counter == 2'b01)
						header_bits[31:16] <= flash_data;
					else
						header_bits[15:0] <= flash_data;		
				end
			end
		end
		else begin
			always @(posedge clk) begin
				if ((current_state == CFG_OPTION) & flash_data_ready) begin
					if (option_bit_counter == 3'd1)
						option_bits[63:32] <= flash_data;
					else
						option_bits[31:0] <= flash_data;
                  end
			end
			
			always @(posedge clk) begin
				if ((current_state == CFG_HEADER ) & flash_data_ready)
					header_bits <= flash_data;
			end
		end
	endgenerate

	// READ counter - 14 or 15 bits counter
	assign counter_cnt_en = (current_state == CFG_NCONFIG || current_state == CFG_NSTATUS || current_state == CFG_NCONFIG_WAIT ||
									current_state == CFG_NSTATUS_WAIT || current_state == CFG_USERMODE_WAIT ||
									current_state == CFG_USERMODE_CONFIRM || 
									(current_state == CFG_DATA )&& fpga_read_data);
	
	assign header_packet_minus_two_length_wire = header_packet_length - {{(COUNTER_WIDTH-2){1'b0}}, 2'b10};
	always @ (posedge clk) begin
		if (current_state == CFG_HEADER_DUMMY) begin
			header_packet_minus_two_length <= header_packet_minus_two_length_wire;
			one_transaction_package <= header_packet_length == {{(COUNTER_WIDTH-1){1'b0}}, 1'b1};
		end
	end
	
	always @ (posedge clk) begin
		if (current_state == CFG_PRE_NCONFIG || current_state == CFG_PRE_NSTATUS_WAIT || current_state == CFG_PRE_NCONFIG_WAIT)
			counter_data <= NCONFIG_TIMER;
		else if (current_state == CFG_PRE_USERMODE_CONFIRM)
			counter_data <= SMALLEST_TIMER;
		else if (current_state == CFG_PRE_NSTATUS || current_state == CFG_PRE_USERMODE_WAIT)
			counter_data <= LARGEST_TIMER;
		else if (current_state == CFG_PRE_DATA)
			counter_data <= header_packet_minus_two_length;
	end
	
	always @ (posedge clk) begin
		sload_counter <= current_state == CFG_PRE_NCONFIG || current_state == CFG_PRE_NCONFIG_WAIT || current_state == CFG_PRE_NSTATUS_WAIT || 
								current_state == CFG_PRE_USERMODE_CONFIRM || current_state == CFG_PRE_NSTATUS || 
								current_state == CFG_PRE_USERMODE_WAIT || current_state == CFG_PRE_DATA;
	end

	lpm_counter counter(
		.clock(clk),
		.cnt_en(counter_cnt_en),
		.sload(sload_counter),
		.data(counter_data),
		.q(counter_q)
	);
	defparam counter.lpm_width=COUNTER_WIDTH;
	defparam counter.lpm_direction="DOWN";
	assign read_counter_almost_done = (counter_q == {(COUNTER_WIDTH){1'b0}}) & fpga_read_data;
	assign counter_done_almost_done = (counter_q == {(COUNTER_WIDTH){1'b0}});

	always @ (posedge clk) begin
		if (sload_counter)			//data counter
			read_counter_done <= 1'b0;
		else if (read_counter_almost_done)
			read_counter_done <= 1'b1;
	end
	always @ (posedge clk) begin
		if (sload_counter)			//counter used by state machine
			counter_done <= 1'b0;
		else
			counter_done <= counter_done_almost_done;
	end
	
	// OPTION
	always @ (posedge clk) begin
		if (current_state == CFG_PRE_OPTION)
			option_bit_counter <= 3'b00;
		else if (current_state == CFG_OPTION & flash_data_ready)
		   option_bit_counter <= option_bit_counter + 3'b01;
	end
	// HEADER
	always @ (posedge clk) begin
		if (current_state == CFG_PRE_HEADER || current_state == CFG_HEADER_DUMMY)
			header_bit_counter <= 2'b00;
		else if (current_state == CFG_HEADER & flash_data_ready)
		   header_bit_counter <= header_bit_counter + 2'b01;
	end
	// Packetize
	assign	pof_packetized = version5;  //version 5 is pof packetize
	assign	data_block_complete = pof_packetized & (read_counter_done | one_transaction_package) & fpga_read_data;
	// syncing to avoid glitch
	altera_pfl2_glitch nstatus_sync (.clk(clk), .data_in(fpga_nstatus), .data_out(fpga_nstatus_sync)); defparam nstatus_sync.INIT = 1;
	altera_pfl2_glitch condone_sync (.clk(clk), .data_in(fpga_condone), .data_out(fpga_condone_sync)); defparam condone_sync.INIT = 1;
	altera_pfl2_glitch enable_sync (.clk(clk), .data_in(enable_configuration), .data_out(enable_configuration_sync)); defparam enable_sync.INIT = 0;
	altera_pfl2_glitch nreconfigure_sync (.clk(clk), .data_in(pfl_nreconfigure), .data_out(pfl_nreconfigure_sync)); defparam nreconfigure_sync.INIT = 1;
	altera_pfl2_glitch nconfig_sync (.clk(clk), .data_in(enable_nconfig), .data_out(enable_nconfig_sync)); defparam nconfig_sync.INIT = 0;
	
	assign fpga_nconfig_signal = ~(current_state == CFG_NCONFIG || current_state == CFG_PRE_NCONFIG_WAIT || 
								current_state == CFG_LOAD_NCONFIG_WAIT || current_state == CFG_NCONFIG_WAIT ||
									enable_nconfig_sync);	//add in nconfig wait states
	opndrn nconfig_opndrn (
		.in(fpga_nconfig_signal),
		.out(fpga_nconfig)
	);

	always @(*)
	begin
		case (current_state)
			CFG_POWERUP :
				if (fpga_nstatus_sync)
					next_state = CFG_INIT;
				else
					next_state = CFG_SAME;
			CFG_INIT :		//make sure fpga does not in user mode
				if (fpga_condone_sync)
					next_state = CFG_PRE_USERMODE_CONFIRM;
				else if (fpga_nstatus_sync)
					next_state = CFG_PRE_NSTATUS_WAIT;
				else
					next_state = CFG_PRE_NCONFIG;
			CFG_PRE_NCONFIG:
				next_state = CFG_LOAD_NCONFIG;
			CFG_LOAD_NCONFIG:
				next_state = CFG_NCONFIG;
			CFG_NCONFIG:
				if (~fpga_nstatus_sync)				//wait fpga_nstatus goes low
					next_state = CFG_PRE_NCONFIG_WAIT;
				else
					next_state = CFG_SAME;
			CFG_PRE_NCONFIG_WAIT:
				next_state = CFG_LOAD_NCONFIG_WAIT;
			CFG_LOAD_NCONFIG_WAIT:
				next_state = CFG_NCONFIG_WAIT;
			CFG_NCONFIG_WAIT:
				 if (counter_done)				// pull nconfig high after some time
					next_state = CFG_RECONFIG_WAIT;
				else
					next_state = CFG_SAME;
			CFG_RECONFIG_WAIT:
				if (pfl_nreconfigure_sync)
					next_state = CFG_PRE_NSTATUS;
				else
					next_state = CFG_SAME;
			CFG_PRE_NSTATUS:
				next_state = CFG_LOAD_NSTATUS;
			CFG_LOAD_NSTATUS:
				next_state = CFG_NSTATUS;
			CFG_NSTATUS:
				if (fpga_nstatus_sync)
					next_state = CFG_PRE_NSTATUS_WAIT;				// nCONFIG high to nSTATUS high
				else if (counter_done) 								// Error where nstatus fail to go high in certain time
					next_state = CFG_ERROR;
				else
					next_state = CFG_SAME;
			CFG_PRE_NSTATUS_WAIT:
				next_state = CFG_LOAD_NSTATUS_WAIT;
			CFG_LOAD_NSTATUS_WAIT:
				next_state = CFG_NSTATUS_WAIT;
			CFG_NSTATUS_WAIT:
				if (~fpga_nstatus_sync)								// Error where nstatus is not stable for a defined period
					next_state = CFG_ERROR;						
				else if (counter_done)
					next_state = CFG_PRE_VERSION;
				else
					next_state = CFG_SAME;
			CFG_PRE_USERMODE_WAIT:
				next_state = CFG_LOAD_USERMODE_WAIT;
			CFG_LOAD_USERMODE_WAIT:
				next_state = CFG_USERMODE_WAIT;
			CFG_USERMODE_WAIT:										// All data being sent, waiting condone to go high
				if (fpga_condone_sync)							
					next_state = CFG_PRE_USERMODE_CONFIRM;
				else if (~fpga_nstatus_sync)						// nstatus asserted
					next_state = CFG_ERROR;
				else if (counter_done)								// condone fail to go high
					next_state = CFG_ERROR;
				else 
					next_state = CFG_SAME;
			CFG_PRE_USERMODE_CONFIRM:
				next_state = CFG_LOAD_USERMODE_CONFIRM;
			CFG_LOAD_USERMODE_CONFIRM:
				next_state = CFG_USERMODE_CONFIRM;
			CFG_USERMODE_CONFIRM:
				if (~fpga_condone_sync | ~fpga_nstatus_sync)  // condone and nstatus fail to stay high for a defined period
					next_state = CFG_ERROR;					//to make sure condone and nstatus are stable
				else if (counter_done)
					next_state = CFG_USERMODE;
				else 
					next_state = CFG_SAME;
			CFG_USERMODE:
				if (~fpga_condone_sync | watchdog_timed_out)
					next_state = CFG_ERROR;
				else
					next_state = CFG_SAME;
			CFG_PRE_VERSION:
				next_state = CFG_LOAD_VERSION;
			CFG_LOAD_VERSION:
				next_state = CFG_VERSION;
			CFG_VERSION:
				if (flash_data_ready)
					next_state = CFG_VERSION_DUMMY;
				else 
					next_state = CFG_SAME;
			CFG_VERSION_DUMMY:
				if (~version5)
					next_state = CFG_ERROR;
				else if (revert)
					next_state = CFG_PRE_HEADER;
				else
					next_state = CFG_PRE_OPTION;
			CFG_PRE_OPTION:
				next_state = CFG_LOAD_OPTION;
			CFG_LOAD_OPTION:
				next_state = CFG_OPTION;
			CFG_OPTION:
				if (option_bit_counter == READ_OPTION_INDEX & flash_data_ready)
					next_state = CFG_OPTION_DUMMY;
				else
					next_state = CFG_SAME;
			CFG_OPTION_DUMMY:
				if (page_done_bit)
					next_state = CFG_ERROR;
				else
					next_state = CFG_PRE_HEADER;
			CFG_PRE_HEADER:
				next_state = CFG_LOAD_HEADER;
			CFG_LOAD_HEADER:
				next_state = CFG_HEADER;
			CFG_HEADER:
				if (flash_done)
					next_state = CFG_PRE_USERMODE_WAIT;
				else if (header_bit_counter == READ_HEADER_INDEX & flash_data_ready)
					next_state = CFG_HEADER_DUMMY;
				else 
					next_state = CFG_SAME;
			CFG_HEADER_DUMMY:
				next_state = CFG_PRE_DATA;
			CFG_PRE_DATA:
				next_state = CFG_LOAD_DATA;
			CFG_LOAD_DATA:
				next_state = CFG_DATA;
			CFG_DATA:
				if (fpga_condone_sync)
					next_state = CFG_PRE_USERMODE_CONFIRM;
				else if (~fpga_nstatus_sync)
					next_state = CFG_ERROR;
				else if (flash_done)
					next_state = CFG_PRE_USERMODE_WAIT;
				else if (data_block_complete)
					next_state = CFG_DATA_DUMMY;
				else
					next_state = CFG_SAME;
			CFG_DATA_DUMMY:
				if (flash_done)
					next_state = CFG_PRE_USERMODE_WAIT;
				else if (~dummy_byte | flash_data_ready)
					next_state = CFG_HEADER;
				else
					next_state = CFG_SAME;
			CFG_ERROR:
				if (SAFE_MODE_REVERT == 1)
					next_state = CFG_REVERT;
				else if (SAFE_MODE_HALT == 1)
					next_state = CFG_HALT;
				else
					next_state = CFG_INIT;
			CFG_REVERT:
				next_state = CFG_PRE_NCONFIG;
			CFG_HALT:
				next_state = CFG_SAME;
			CFG_RECONFIG:
				next_state = CFG_PRE_NCONFIG;
			default:
				next_state = CFG_POWERUP;
		endcase
	end
	
	initial begin
		current_state = CFG_POWERUP;
		next_state = CFG_POWERUP; 
	end
			
	always @(negedge nreset or posedge clk)
	begin
		if(~nreset) begin
			current_state <= CFG_POWERUP;
		end
		else begin
			if (~enable_configuration_sync)
				current_state <= CFG_POWERUP;
			else if (~reconfigure & ~pfl_nreconfigure_sync)
				current_state <= CFG_RECONFIG;
			else if (next_state != CFG_SAME)
				current_state <= next_state;
			else
				current_state <= current_state;
		end
	end
	
endmodule
