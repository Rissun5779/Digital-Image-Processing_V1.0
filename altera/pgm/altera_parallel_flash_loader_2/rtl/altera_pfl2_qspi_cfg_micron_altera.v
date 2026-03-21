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
// This module contains the PFL (Quad IO Flash -- Micron / Numonyx / Altera) Configuration Flash block
//************************************************************

module altera_pfl2_qspi_cfg_micron_altera
(
	// FPGA IOs
	nreset,
	clk,
	
	// QPFL IOs
	flash_sck,
	flash_ncs,
	flash_io0_out,
	flash_io0_in,
	flash_io1_out,
	flash_io1_in,
	flash_io2_in,
	flash_io2_out,
	flash_io3_in,
	flash_io3_out,
	flash_highz_io0,
	flash_highz_io1,
	flash_highz_io2,
	flash_highz_io3,
	
	addr_in,
	stop_addr_in,
	addr_sload,
	addr_cnt_en,
	done,
	
	data_request,
	data_ready,
	data,
	
	flash_access_request,
	flash_access_granted
);

	// parameter
	parameter EXTRA_ADDR_BYTE = 0;
	parameter FLASH_ADDR_WIDTH = 22;
	parameter FLASH_BURST_EXTRA_CYCLE = 1;
	parameter FLASH_MFC = "ALTERA";
	parameter N_FLASH = 4;
	parameter QSPI_DATA_DELAY = 0;
	parameter QSPI_DATA_DELAY_COUNT = 1;
	// die size is 256Mb, 	log2(256Mb / 8), EXTRA_ADDR_BYTE must equal 1 ,only 255Mb and above have multi die
	parameter QSPI_DIE_BOUNDARY_ADDR = 25;	
	// local parameter
	localparam	CFG_ADDR_BIT = (EXTRA_ADDR_BYTE == 1) ? 32 : 24;
	localparam 	DATA_WIDTH = N_FLASH * 4;
	localparam	REAL_ADDR_INDEX = (N_FLASH == 8) ? 3 :
											(N_FLASH == 4) ? 2 :
											(N_FLASH == 2) ? 1 : 0;
	localparam	REAL_ADDR_WIDTH = FLASH_ADDR_WIDTH - REAL_ADDR_INDEX;	
	localparam	UNUSED_ADDR_WIDTH = (EXTRA_ADDR_BYTE == 1) ? 32 - REAL_ADDR_WIDTH : 24 - REAL_ADDR_WIDTH;
	localparam	QSPI_TRANSACTION_NUM = (EXTRA_ADDR_BYTE == 1) ? 10 : 6;
	localparam	QSPI_TRANSACTION_WIDTH = (EXTRA_ADDR_BYTE == 1) ? 4 : 3;
	
	// Addressing is a bit tricky
	// Standardize the flow
	// Control Block always give BYTE addressing so it does not need to know the number of flash attached
	localparam	ADDR_CYCLE_COUNT = (EXTRA_ADDR_BYTE == 1)? 8 : 6;
	localparam	DUMMY_CYCLE_COUNT = 10;
	localparam 	ADDR_PLUS_DUMMY_CYCLE_COUNT = ADDR_CYCLE_COUNT + DUMMY_CYCLE_COUNT - 2;
	localparam	[4:0] ADDR_PLUS_DUMMY_DONE_CYCLE = ADDR_PLUS_DUMMY_CYCLE_COUNT[4:0];
	localparam	FAKE_ADDR_INDEX = (N_FLASH == 8) ? 2 :
											(N_FLASH == 4) ? 1 :
											(N_FLASH == 2) ? 0 : -1;
	localparam	FAKE_END_ADDR_INDEX = (N_FLASH == 8) ? 2 :
													(N_FLASH == 4) ? 1 : 0;
	localparam	FAKE_EXTRA_BIT = (N_FLASH == 1) ? 1 : 0;
	localparam	IO0_ZERO_COUNT = 16 - ADDR_CYCLE_COUNT;
		
	// STATE machine
	reg [3:0] current_state /* synthesis altera_attribute = "-name SUPPRESS_REG_MINIMIZATION_MSG ON" */;
	reg [3:0] next_state;
	localparam BURST_SAME                   = 4'd0;
	localparam BURST_INIT                   = 4'd1;
	localparam BURST_WAIT                   = 4'd2;
	localparam BURST_SETUP                  = 4'd3;
	localparam BURST_LOADING                = 4'd4;
	localparam BURST_TRANSACTION            = 4'd5;
	localparam BURST_CHECK_STOP             = 4'd6;
	localparam BURST_INC_TCOUNTER           = 4'd7;
	localparam BURST_RESET                  = 4'd8;
	localparam BURST_DUMMY                  = 4'd9;
	localparam BURST_READ                   = 4'd10;
	localparam BURST_READ_HIGH              = 4'd11;

	// Port Declaration
	// FPGA IOs
	input clk;
	input nreset;
	
	// QPFL IOs
	input	[N_FLASH-1:0] flash_io0_in;
	input	[N_FLASH-1:0] flash_io1_in;
	input	[N_FLASH-1:0] flash_io2_in;
	input	[N_FLASH-1:0] flash_io3_in;
	output	[N_FLASH-1:0] flash_sck;
	output	[N_FLASH-1:0] flash_ncs;
	output	[N_FLASH-1:0] flash_io0_out;
	output	[N_FLASH-1:0] flash_io1_out;
	output	[N_FLASH-1:0] flash_io2_out;
	output	[N_FLASH-1:0] flash_io3_out;
	
	output 	flash_highz_io0;
	output 	flash_highz_io1;
	output 	flash_highz_io2;
	output 	flash_highz_io3;
    
	// From Controller
	input	[FLASH_ADDR_WIDTH-1:0] addr_in;
	input	[FLASH_ADDR_WIDTH-1:0] stop_addr_in;
	input	addr_cnt_en;
	input	addr_sload;
	output	done;
	reg		done;

	input	data_request;
	output	[DATA_WIDTH-1:0]data;
	output	data_ready;
	
	input	flash_access_granted;
	output	flash_access_request;
	
	wire [15:0] pfl_io0 [0:QSPI_TRANSACTION_NUM-1];
	wire [ADDR_CYCLE_COUNT-1:0] pfl_io13[1:3];
	wire [8:0] pfl_control [0:QSPI_TRANSACTION_NUM-1];
    
	reg  [CFG_ADDR_BIT-1:0] read_address;
    
	wire [DATA_WIDTH-1:0] flash_data;
	wire [DATA_WIDTH-1:0] flash_data_stage [-1:QSPI_DATA_DELAY_COUNT-1];
    
	wire [FLASH_ADDR_WIDTH-FAKE_ADDR_INDEX-1:0] fake_addr_in;
	wire [FLASH_ADDR_WIDTH-FAKE_ADDR_INDEX-1:0] fake_addr_stop;
	wire  [FLASH_ADDR_WIDTH-FAKE_ADDR_INDEX-1:0] addr_counter_q;
    
	wire [QSPI_DATA_DELAY_COUNT-1:-1] data_ready_stage;
	wire [QSPI_DATA_DELAY_COUNT-1:-1] data_read_stage;
    
	wire [QSPI_TRANSACTION_WIDTH-1:0] tcount_q;
	wire [QSPI_TRANSACTION_WIDTH-1:0] reset_tcount_value;
	
	wire [4:0] cfg_count_q;
	wire [3:0] io_reg_sout;
	wire alt_pfl_data_read;
	wire counter_almost_done_wire;
	wire counter_done;
	wire data_ready_wire;
	wire en_cfg_counter;
	wire enable_shift;
	wire flash_data_read;
	wire flash_read_sck;		// Running at PFL speed
	wire sload_cfg_counter;
	wire new_die_addr;
	reg [15:0] pfl_io;
	reg [4:0] counter_data;
	reg addr_done;
	reg addr_latched;
	reg counter_almost_done;
	reg data_auto_ignore;
	reg flash_ncs_cfg;	
	reg flash_sck_cfg;		// Running at Half of the PFL speed
	reg granted;
	reg highz = 1'b0;
	reg ncs;
	reg request;
	reg scking;
	reg shiftin;
	reg transaction_done;
    
	assign 	flash_highz_io0 = highz;
	assign 	flash_highz_io1 = highz;
	assign 	flash_highz_io2 = highz;
	assign 	flash_highz_io3 = highz;
	
	// check for the die first address
	// ignore if the first die address is address latched from controller
	// addr_counter_q need to convert to byte addressing
	generate
	if (EXTRA_ADDR_BYTE == 1) begin
		if (FLASH_BURST_EXTRA_CYCLE > 0) begin
			assign new_die_addr = (addr_counter_q[FLASH_ADDR_WIDTH-FAKE_ADDR_INDEX-1:1] == read_address || current_state != BURST_READ_HIGH) ? 1'b0 :
								(addr_counter_q[QSPI_DIE_BOUNDARY_ADDR : 0] == {(QSPI_DIE_BOUNDARY_ADDR + 1){1'b0}}) ? 1'b1:1'b0;
		end
		else begin
			assign new_die_addr = (addr_counter_q[FLASH_ADDR_WIDTH-FAKE_ADDR_INDEX-1:1] == read_address || current_state != BURST_READ) ? 1'b0 :
								(addr_counter_q[QSPI_DIE_BOUNDARY_ADDR : 0] == {(QSPI_DIE_BOUNDARY_ADDR + 1){1'b0}}) ? 1'b1:1'b0;
		end
	end
	else begin
		assign new_die_addr = 1'b0;
	end
	endgenerate

	// By default make them to output mode due to
	// 	pin 0 as output pin
	// 	pin 2 as Write Protect
	// 	pin 3 as Hold Pin
	//		pin 1 in FLASH (for instruction that PFL issue) is HIGHZ (means for PFL it is don't care)	
	always @ (posedge clk or negedge nreset) begin
		if (~nreset) begin
			highz = 1'b0;
		end
		else if (current_state == BURST_WAIT || new_die_addr) begin
			highz = 1'b0;								// Another purpose is to serve as highz-delaying to avoid post-read-contention (one clock later to prevent board delay)
		end
		else if (current_state == BURST_TRANSACTION && counter_almost_done_wire && transaction_done) begin
			highz = 1'b1;								// About to received data; we need to look ahead instead (one clock earlier now to prevent board delay) of depending READ state machine to avoid pre-read-contention
		end
		else begin
			highz = highz;
		end
	end

	// Defining constant
	// Two flow
	// 1. 3 Byte Addressing
	//			 WE (8) >>>> Setup Dummy Clock (16) >>>> READ OPCODE 8 --> ADDR (6+(10)) ------> 7 Transaction
	// 2. 4 Byte Addressing
	//			 WE (8) >>>> Upper Addr(8) >>>> WE (8) >>>> Setup Dummy Clock (16)  
	//				>>>> READ OPCODE 8 --> ADDR (6+(10)) ------> 11 Transaction
	//
	// Control Bit
	// 1. NCS high or low
	// 2. Clock Needed?
	// 3. Shift-in
	// 4. 5 Bits Counter
	// 5. Stop? -->  Total of 9 bit
	generate
	if (EXTRA_ADDR_BYTE == 1) begin
		// Control
		assign pfl_control[0] = {1'b0, 5'd6, 								1'b1, 1'b1, 1'b0}; // Write Enable
		assign pfl_control[1] = {1'b0, 5'd31, 								1'b1, 1'b0, 1'b1}; // NCS HIGH
		assign pfl_control[2] = {1'b0, 5'd6, 								1'b1, 1'b1, 1'b0}; // Upper Addressing
		assign pfl_control[3] = {1'b0, 5'd31, 								1'b1, 1'b0, 1'b1}; // NCS HIGH
		assign pfl_control[4] = {1'b0, 5'd6, 								1'b1, 1'b1, 1'b0}; // Write Enable
		assign pfl_control[5] = {1'b0, 5'd31, 								1'b1, 1'b0, 1'b1}; // NCS HIGH
		assign pfl_control[6] = {1'b0, 5'd14, 								1'b1, 1'b1, 1'b0}; // Setup Dummy Clock
		assign pfl_control[7] = {1'b0, 5'd31, 								1'b1, 1'b0, 1'b1}; // NCS HIGH
		assign pfl_control[8] = {1'b0, 5'd6, 								1'b1, 1'b1, 1'b0}; // READ OPCODE
		assign pfl_control[9] = {1'b1, ADDR_PLUS_DUMMY_DONE_CYCLE, 	1'b0, 1'b1, 1'b0}; // ADDR
		// IO (Before Addr)
		// IO-0
		assign pfl_io0[0] = 16'b0000_0110_1111_1111; // Write Enable
		assign pfl_io0[1] = 16'b1111_1111_1111_1111; // NCS HIGH
		assign pfl_io0[2] = 16'b1011_0111_1111_1111; // Upper Address
		assign pfl_io0[3] = 16'b1111_1111_1111_1111; // NCS HIGH
		assign pfl_io0[4] = 16'b0000_0110_1111_1111; // Write Enable
		assign pfl_io0[5] = 16'b1111_1111_1111_1111; // NCS HIGH
		assign pfl_io0[6] = 16'b1000_0001_1111_1011; // Setup Dummy Clock
		assign pfl_io0[7] = 16'b1111_1111_1111_1111; // NCS HIGH
		assign pfl_io0[8] = 16'b1110_1011_1111_1111; // READ OPCODE
		// IO-Addr
		assign pfl_io0[9] = {read_address[28], read_address[24], read_address[20], read_address[16], read_address[12], read_address[8], read_address[4], read_address[0], {(IO0_ZERO_COUNT){1'b0}}};
		assign pfl_io13[1] = {read_address[29], read_address[25], read_address[21], read_address[17], read_address[13], read_address[9], read_address[5], read_address[1]};
		assign pfl_io13[2] = {read_address[30], read_address[26], read_address[22], read_address[18], read_address[14], read_address[10], read_address[6], read_address[2]};
		assign pfl_io13[3] = {read_address[31], read_address[27], read_address[23], read_address[19], read_address[15], read_address[11], read_address[7], read_address[3]};
		
		//reset tcount when it is a new die address
		assign reset_tcount_value = 'h8;
	end
	else begin
		// Control
		assign pfl_control[0] = {1'b0, 5'd6, 								1'b1, 1'b1, 1'b0}; // Write Enable
		assign pfl_control[1] = {1'b0, 5'd31, 								1'b1, 1'b0, 1'b1}; // NCS HIGH
		assign pfl_control[2] = {1'b0, 5'd14, 								1'b1, 1'b1, 1'b0}; // Setup Dummy Clock
		assign pfl_control[3] = {1'b0, 5'd31, 								1'b1, 1'b0, 1'b1}; // NCS HIGH
		assign pfl_control[4] = {1'b0, 5'd6, 								1'b1, 1'b1, 1'b0}; // READ OPCODE
		assign pfl_control[5] = {1'b1, ADDR_PLUS_DUMMY_DONE_CYCLE, 	1'b0, 1'b1, 1'b0}; // ADDR
				// IO (Before Addr)
		// IO-0
		assign pfl_io0[0] = 16'b0000_0110_1111_1111; // Write Enable
		assign pfl_io0[1] = 16'b1111_1111_1111_1111; // NCS HIGH
		assign pfl_io0[2] = 16'b1000_0001_1111_1011; // Setup Dummy Clock
		assign pfl_io0[3] = 16'b1111_1111_1111_1111; // NCS HIGH
		assign pfl_io0[4] = 16'b1110_1011_1111_1111; // READ OPCODE
		// IO-Addr
		assign pfl_io0[5] = {read_address[20], read_address[16], read_address[12], read_address[8], read_address[4], read_address[0], {(IO0_ZERO_COUNT){1'b0}}};
		assign pfl_io13[1] = {read_address[21], read_address[17], read_address[13], read_address[9], read_address[5], read_address[1]};
		assign pfl_io13[2] = {read_address[22], read_address[18], read_address[14], read_address[10], read_address[6], read_address[2]};
		assign pfl_io13[3] = {read_address[23], read_address[19], read_address[15], read_address[11], read_address[7], read_address[3]};

	end
	endgenerate
	generate
	if (EXTRA_ADDR_BYTE == 1) begin
		lpm_counter tcounter (
		.clock(clk),
		.sclr(current_state == BURST_INIT || current_state == BURST_WAIT),
		.sload(new_die_addr),
		.data(reset_tcount_value),
		.cnt_en(current_state == BURST_INC_TCOUNTER),
		.q(tcount_q)
		);
		defparam
			tcounter.lpm_type = "LPM_COUNTER",
			tcounter.lpm_direction= "UP",
			tcounter.lpm_width = QSPI_TRANSACTION_WIDTH;
	end
	else begin
		lpm_counter tcounter (
		.clock(clk),
		.sclr(current_state == BURST_INIT || current_state == BURST_WAIT),
		.cnt_en(current_state == BURST_INC_TCOUNTER),
		.q(tcount_q)
		);
		defparam
			tcounter.lpm_type = "LPM_COUNTER",
			tcounter.lpm_direction= "UP",
			tcounter.lpm_width = QSPI_TRANSACTION_WIDTH;
	end
	endgenerate

	always @ (posedge clk) begin
		// pull ncs HIGH one clock earlier to prevent board delay + hold time that causing contention
		// with HIGHZ now delay until WAIT state, we have two clock cycle margin
		// hold time is 8ns + board delay
		// Even we run PFL at 150Mhz, two clock cycle should still be more than enough
		if (~data_request || current_state == BURST_INIT || current_state == BURST_WAIT || new_die_addr) begin
			ncs = 1'b1;
			scking = 1'b0;
			shiftin = 1'b1;
			counter_data = 5'd6;
			pfl_io = 16'hFFFF;
		end
		else if (current_state == BURST_SETUP) begin
			ncs = pfl_control[tcount_q][0];
			scking = pfl_control[tcount_q][1];
			shiftin = pfl_control[tcount_q][2];
			counter_data = pfl_control[tcount_q][7:3];
			pfl_io = pfl_io0[tcount_q];
		end
	end
	always @ (posedge clk) begin
		if (current_state == BURST_INIT || current_state == BURST_WAIT) begin
			transaction_done = 1'b0;
		end
		else if (current_state == BURST_SETUP) begin
			transaction_done = pfl_control[tcount_q][8];
		end
		else if (current_state == BURST_RESET) begin
			transaction_done = 1'b0;
		end
	end
	
	assign fake_addr_in = {addr_in[FLASH_ADDR_WIDTH-1:FAKE_END_ADDR_INDEX], {(FAKE_EXTRA_BIT){1'b0}}};
	assign fake_addr_stop = {stop_addr_in[FLASH_ADDR_WIDTH-1:FAKE_END_ADDR_INDEX], {(FAKE_EXTRA_BIT){1'b0}}};
	
    //try bypass pfl data
    assign data = flash_data;
	assign data_ready = data_ready_wire & ~data_auto_ignore;
	assign alt_pfl_data_read = addr_cnt_en;
    //what is the use of pfl data delay
	// Stage 1
	/*assign flash_data_stage[-1] = flash_data;
	assign data_ready_stage[-1] = data_ready_wire & ~data_auto_ignore;
	assign alt_pfl_data_read = data_read_stage[-1];
	genvar i;
	generate
		for (i = 0; i < QSPI_DATA_DELAY_COUNT; i = i + 1) begin : QSPI_DATA_LOOP
			altera_pfl2_data alt_pfl_data1
			(
				.clk(clk),
				.data_request(data_request),
				.data_in(flash_data_stage[i-1]),
				.data_in_ready(data_ready_stage[i-1]),
				.data_in_read(data_read_stage[i-1]),
			
				.data_out(flash_data_stage[i]),
				.data_out_ready(data_ready_stage[i]),
				.data_out_read(data_read_stage[i])
			);
			defparam
				alt_pfl_data1.DATA_WIDTH = DATA_WIDTH,
				alt_pfl_data1.DELAY = QSPI_DATA_DELAY - ((i * QSPI_DATA_DELAY)/QSPI_DATA_DELAY_COUNT);
		end
	endgenerate
	// Stage 2
	altera_pfl2_data alt_pfl_data2
	(
		.clk(clk),
		.data_request(data_request),
		.data_in(flash_data_stage[QSPI_DATA_DELAY_COUNT-1]),
		.data_in_ready(data_ready_stage[QSPI_DATA_DELAY_COUNT-1]),
		.data_in_read(data_read_stage[QSPI_DATA_DELAY_COUNT-1]),
	
		.data_out(data),
		.data_out_ready(data_ready),
		.data_out_read(addr_cnt_en)
	);
	defparam
		alt_pfl_data2.DATA_WIDTH = DATA_WIDTH;
	*/			
	// Connection with outside world
	assign flash_ncs = {(N_FLASH){ncs}};
	assign flash_sck = {(N_FLASH){(flash_sck_cfg | flash_read_sck) & data_request}};

	assign flash_io0_out = {(N_FLASH){io_reg_sout[0]}};
	assign flash_io1_out = {(N_FLASH){io_reg_sout[1]}};
	assign flash_io2_out = {(N_FLASH){io_reg_sout[2]}};
	assign flash_io3_out = {(N_FLASH){io_reg_sout[3]}};
	
	assign enable_shift = scking? flash_sck_cfg : 1'b1;
	lpm_shiftreg io_reg (
		.clock(clk),
		.enable((current_state == BURST_LOADING || (current_state == BURST_TRANSACTION && enable_shift))),
		.load(current_state == BURST_LOADING),
		.data(pfl_io),
		.shiftin(shiftin),
		.shiftout(io_reg_sout[0])
	);
	defparam
		io_reg.lpm_type = "LPM_SHIFTREG",
		io_reg.lpm_width = 16,
		io_reg.lpm_direction = "LEFT";

	// Preload IO_1_OUT with 0 and IO_23_OUT with 1 during BURST_INIT state
	// This is to prevent NCS=0 and IO_23_OUT=0 since IO_23 is Write Protect and Hold pins
	// HIGHZ in IO_23 become more complicated, which does not only depend on the READ state machine anymore to avoid pre-post-read-contention
	generate
        genvar i;
		for(i = 1; i < 4; i=i+1) begin: IO_LOOP
			lpm_shiftreg io_reg (
				.clock(clk),
				.enable((current_state == BURST_LOADING || current_state == BURST_INIT || (current_state == BURST_TRANSACTION && enable_shift))),
				.load(current_state == BURST_LOADING || current_state == BURST_INIT),
				.data(transaction_done? pfl_io13[i] : {(ADDR_CYCLE_COUNT){1'b1}}),
				.shiftin(transaction_done? 1'b0 : 1'b1),
				.shiftout(io_reg_sout[i])
			);
			defparam
				io_reg.lpm_type = "LPM_SHIFTREG",
				io_reg.lpm_width = ADDR_CYCLE_COUNT,
				io_reg.lpm_direction = "LEFT";
		end
	endgenerate
	
	always @(posedge clk) begin
		if (addr_sload)
			read_address = {{(UNUSED_ADDR_WIDTH){1'b0}}, addr_in[FLASH_ADDR_WIDTH-1:REAL_ADDR_INDEX]}; 
		else if (new_die_addr)
			read_address = {{(UNUSED_ADDR_WIDTH){1'b0}}, addr_counter_q[FLASH_ADDR_WIDTH-FAKE_ADDR_INDEX-1:1]};
	end

	assign sload_cfg_counter = (current_state == BURST_LOADING);
	assign en_cfg_counter = (current_state == BURST_TRANSACTION)? enable_shift : 1'b0;
	// LPM counter
	lpm_counter cfg_counter (
		.clock(clk),
		.sload(sload_cfg_counter),
		.data(counter_data),
		.cnt_en(en_cfg_counter),
		.q(cfg_count_q)
	);
	defparam
	cfg_counter.lpm_type = "LPM_COUNTER",
	cfg_counter.lpm_direction= "DOWN",
	cfg_counter.lpm_width = 5;
	
	assign counter_done = counter_almost_done & enable_shift;
	assign counter_almost_done_wire = (cfg_count_q == 5'd0) & enable_shift;
	always @ (posedge clk) begin
		if (sload_cfg_counter)
			counter_almost_done = 1'b0;
		else if (counter_almost_done_wire)
			counter_almost_done = 1'b1;
	end
		
	lpm_counter addr_counter
	(
		.clock(clk),
		.sload(addr_sload),
		.data(fake_addr_in),
		.cnt_en(alt_pfl_data_read & ~addr_latched),
		.q(addr_counter_q)
	);
	defparam addr_counter.lpm_width=FLASH_ADDR_WIDTH-FAKE_ADDR_INDEX;

	always @ (posedge clk or negedge nreset) begin
		if (~nreset)
			addr_latched = 0;
		else if (addr_sload)
			addr_latched = 1;
		else if (current_state == BURST_RESET)
			addr_latched = 0;
	end

	always @ (posedge clk or negedge nreset) begin
		if (~nreset)
			addr_done = 0;
		else if (addr_sload)
			addr_done = 0;
		else if (addr_counter_q == fake_addr_stop)	
			addr_done = 1;
	end
	always @ (posedge clk or negedge nreset) begin
		done = addr_done;
	end

	assign flash_access_request = request;
	always @ (posedge clk or negedge nreset)
	begin
		if (~nreset) begin
			granted = 0;
			request = 0;
		end
		else begin
			request = data_request;
			if (data_request && ~granted)
				granted = flash_access_granted;
			else if (~data_request)
				granted = 0;
		end
	end

	assign flash_data_read = alt_pfl_data_read || (data_ready_wire & data_auto_ignore);
	generate
		if (FLASH_BURST_EXTRA_CYCLE > 0)
			assign data_ready_wire = current_state == BURST_READ_HIGH;
		else
			assign data_ready_wire = current_state == BURST_READ;
	endgenerate
	always @ (posedge clk) begin
		if (current_state == BURST_TRANSACTION & scking)
			flash_sck_cfg = ~flash_sck_cfg;
		else
			flash_sck_cfg = 1'b0;
	end
	
	generate
	if (FLASH_BURST_EXTRA_CYCLE > 0) begin
		assign flash_read_sck = current_state == BURST_READ_HIGH;
	end
	else begin
		assign flash_read_sck = flash_data_read & ~clk;
	end
	endgenerate
	
	generate
	if (N_FLASH == 8) begin // Need special case of N_FLASH == 8 for address that does not align to 64 bit
		reg unalign_data;
		always @ (posedge clk) begin
			if (addr_sload)
				unalign_data = addr_in[2];
		end
		always @ (posedge clk) begin
			if (current_state == BURST_CHECK_STOP)
				data_auto_ignore = unalign_data;
			else if (~data_request || data_ready_wire)
				data_auto_ignore = 1'b0;
			else
				data_auto_ignore = data_auto_ignore;
		end
	end
	else begin
		always @ (posedge clk) begin
			data_auto_ignore = 1'b0;
		end
	end
	endgenerate
	
	generate
	if (N_FLASH == 8) begin
		assign flash_data = {flash_io0_in[7], flash_io1_in[7], flash_io2_in[7], flash_io3_in[7],
									flash_io0_in[6], flash_io1_in[6], flash_io2_in[6], flash_io3_in[6],
									flash_io0_in[5], flash_io1_in[5], flash_io2_in[5], flash_io3_in[5],
									flash_io0_in[4], flash_io1_in[4], flash_io2_in[4], flash_io3_in[4],
									flash_io0_in[3], flash_io1_in[3], flash_io2_in[3], flash_io3_in[3],
									flash_io0_in[2], flash_io1_in[2], flash_io2_in[2], flash_io3_in[2],
									flash_io0_in[1], flash_io1_in[1], flash_io2_in[1], flash_io3_in[1],
									flash_io0_in[0], flash_io1_in[0], flash_io2_in[0], flash_io3_in[0]};
	end
	else if (N_FLASH == 4) begin
		assign flash_data = {flash_io0_in[3], flash_io1_in[3], flash_io2_in[3], flash_io3_in[3],
									flash_io0_in[2], flash_io1_in[2], flash_io2_in[2], flash_io3_in[2],
									flash_io0_in[1], flash_io1_in[1], flash_io2_in[1], flash_io3_in[1],
									flash_io0_in[0], flash_io1_in[0], flash_io2_in[0], flash_io3_in[0]};
	end
	else if (N_FLASH == 2) begin
		assign flash_data = {flash_io0_in[1], flash_io1_in[1], flash_io2_in[1], flash_io3_in[1],
									flash_io0_in[0], flash_io1_in[0], flash_io2_in[0], flash_io3_in[0]};
	end
	else begin
		assign flash_data = {flash_io0_in[0], flash_io1_in[0], flash_io2_in[0], flash_io3_in[0]};
	end
	endgenerate

	always @ (nreset, current_state, addr_latched, counter_done,
					granted, data_request, transaction_done,
					flash_data_read, new_die_addr)
	begin
		case (current_state)
			BURST_INIT:				//
				next_state = BURST_WAIT;
			BURST_WAIT:				//
				if(addr_latched & granted & data_request)
					next_state = BURST_SETUP;
				else
					next_state = BURST_SAME;
			BURST_SETUP:			// Copy 
				next_state = BURST_LOADING;
			BURST_LOADING:			// LOAD
				next_state = BURST_TRANSACTION;
			BURST_TRANSACTION:
				if (counter_done)
					next_state = BURST_CHECK_STOP;
				else
					next_state = BURST_SAME;
			BURST_CHECK_STOP: 	// 
				if (transaction_done)
					next_state = BURST_RESET;
				else
					next_state = BURST_INC_TCOUNTER;
			BURST_INC_TCOUNTER:
				next_state = BURST_SETUP;
			BURST_RESET:
				next_state = BURST_DUMMY;
			BURST_DUMMY:
				next_state = BURST_READ;
			BURST_READ:				// Data Ready
				if (addr_latched | ~granted)
					next_state = BURST_WAIT;
				else if (FLASH_BURST_EXTRA_CYCLE > 0)
					next_state = BURST_READ_HIGH;
				else if (new_die_addr)
					next_state = BURST_SETUP;
				else if (flash_data_read)
					next_state = BURST_READ;
				else
					next_state = BURST_SAME;
			BURST_READ_HIGH:		// 10
				if (addr_latched | ~granted)
					next_state = BURST_WAIT;
				else if (new_die_addr)
					next_state = BURST_SETUP;
				else if (flash_data_read)
					next_state = BURST_READ;
				else
					next_state = BURST_SAME;
			default:
				next_state = BURST_INIT;
		endcase
	end

	always @ (posedge clk or negedge nreset) begin
		if (~nreset)
			current_state = BURST_INIT;
		else begin
			if (~data_request)
				current_state = BURST_INIT;
			else if (next_state != BURST_SAME)
				current_state = next_state;
			else
				current_state = current_state;
		end
	end

endmodule
