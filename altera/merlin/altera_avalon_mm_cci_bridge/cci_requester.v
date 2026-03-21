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


 
module cci_requester #(
	parameter PEND_REQS = 32,
	parameter PEND_REQS_LOG2 = 5
	)(
	input clk,
	input reset_n,
	input [17:0] rx_c0_header,
	input [511:0] rx_c0_data,
	input rx_c0_rdvalid,
	input rx_c0_wrvalid,
	output reg [60:0] tx_c0_header,
	output reg tx_c0_rdvalid,
	input tx_c0_almostfull,
	input [17:0] rx_c1_header,
	input rx_c1_wrvalid,
	output reg [60:0] tx_c1_header,
	output reg [511:0] tx_c1_data,
	output reg tx_c1_wrvalid,
	input tx_c1_almostfull,
	input [31:0] avmm_address,
	input [63:0] avmm_byteenable,
	input avmm_write,
	input [511:0] avmm_writedata,
	input avmm_read,
	output avmm_waitrequest,
	input [PEND_REQS_LOG2-1-1:0] read_tag,
	input read_tag_ready,
	output read_tag_valid,
	input [PEND_REQS_LOG2-1-1:0] write_tag,
	input write_tag_ready,
	output write_tag_valid
	);


// These are reserved command encodings specified in CCI
localparam WR_THRU   = 4'h1;
localparam WR_LINE   = 4'h2;
localparam RD_LINE   = 4'h4;
localparam WR_FENCE  = 4'h5;

wire [(PEND_REQS_LOG2+64+32+512)-1:0] fifo_in;
wire [(PEND_REQS_LOG2+64+32+512)-1:0] fifo_out;

wire cam_match;

reg [(PEND_REQS_LOG2+64+32+512)-1:0] buffer_r0;
reg [(PEND_REQS_LOG2+64+32+512)-1:0] buffer_r1;
reg valid_r0;
reg valid_r1;
reg valid_r2;
reg stall;

reg [PEND_REQS_LOG2-1:0] stall_addr;
wire [PEND_REQS_LOG2-1:0] cam_match_addr;

wire fifo_wr;
wire fifo_rd;
wire fifo_full;
wire fifo_empty;
reg  [PEND_REQS_LOG2-1:0]  waddr = 4'b0;
reg  [31:0] wdata = 32'b0;
reg         wena = 1'b0;
wire [31:0] lookup_data;
wire fast_stop,stop_n;
wire [PEND_REQS_LOG2-1:0] tag;
reg [PEND_REQS-1:0] in_use;
reg full_write_r0,full_write_r1;
reg [63:0] byteenable_save;
reg rmw_save;
reg rmw_hold;
reg rmw_start1;
reg rmw_start2;
reg [511:0] rmw_buffer1;
reg [511:0] rmw_buffer2;
reg [511:0] rmw_buffer3;
reg [PEND_REQS_LOG2-1:0] rmw_line1;
reg [PEND_REQS_LOG2-1:0] rmw_line2;
reg [PEND_REQS_LOG2-1:0] rmw_line3;
reg [31:0] rmw_address3;
reg in_use_stop;

reg pipe_01_eq;
reg pipe_02_eq;

wire [(64+32+512)-1:0] rmw_ram;

assign tag = (avmm_write) ? {1'b1,write_tag}:{1'b0,read_tag};

assign fifo_in          = {tag,avmm_byteenable,avmm_address,avmm_writedata};
assign fifo_wr          = (avmm_write | avmm_read) & ~avmm_waitrequest;
assign fifo_rd          = (~fifo_empty & ~(tx_c1_almostfull | tx_c0_almostfull) & stop_n);
assign fast_stop        = cam_match && ~stall && valid_r1 && in_use_stop;
assign stop_n           = ~fast_stop && ~stall && ~rmw_hold;
assign avmm_waitrequest = fifo_full | (avmm_write && ~write_tag_ready) | (avmm_read && ~read_tag_ready);
assign read_tag_valid   = avmm_read  && ~avmm_waitrequest;
assign write_tag_valid  = avmm_write && ~avmm_waitrequest;




always @(posedge clk or negedge reset_n) begin
	if (~reset_n) begin
		stall         <= 1'b0;
		wena          <= 1'b0;
		in_use        <= 'h0;
		tx_c0_rdvalid <= 1'b0;
		tx_c1_wrvalid <= 1'b0;
		valid_r0      <= 1'b0;
		valid_r1      <= 1'b0;
		valid_r2      <= 1'b0;
		full_write_r0 <= 1'b0;
		full_write_r1 <= 1'b0;
		rmw_save      <= 1'b0;
		rmw_hold      <= 1'b0;
		rmw_start1    <= 1'b0;
		rmw_start2    <= 1'b0;
		pipe_01_eq    <= 1'b0;
		pipe_02_eq    <= 1'b0;
		in_use_stop   <= 1'b0;
	end else begin
		rmw_save      <= 1'b0;
		rmw_hold      <= 1'b0;
		rmw_start1    <= 1'b0;
		rmw_start2    <= 1'b0;
		wena          <= 1'b0;
		wdata         <= 'h0;
		tx_c0_header  <= 'h0;
		tx_c0_rdvalid <= 1'b0;
		tx_c1_header  <= 'h0;
		tx_c1_data    <= 'h0;
		tx_c1_wrvalid <= 1'b0;
		pipe_01_eq    <= 1'b0;
		pipe_02_eq    <= 1'b0;

		

		if (stop_n) begin
		
			if (fifo_out[607:544] == {64{1'b1}}) full_write_r0 <= 1'b1;
			else full_write_r0 <= 1'b0;
		
			buffer_r0     <= fifo_out;
			buffer_r1     <= buffer_r0;
			valid_r0      <= fifo_rd;
			valid_r1      <= valid_r0;
			valid_r2      <= valid_r1;
			full_write_r1 <= full_write_r0;
		end
		
		if (rx_c0_rdvalid && ~rx_c0_header[12] && (rx_c0_header[PEND_REQS_LOG2-1:0] == buffer_r0[PEND_REQS_LOG2+607:608])) in_use_stop <= 1'b0;
		else if (rx_c0_wrvalid && (rx_c0_header[PEND_REQS_LOG2-1:0] == buffer_r0[PEND_REQS_LOG2+607:608])) in_use_stop <= 1'b0;
		else if (rx_c1_wrvalid && (rx_c1_header[PEND_REQS_LOG2-1:0] == buffer_r0[PEND_REQS_LOG2+607:608])) in_use_stop <= 1'b0;
		else in_use_stop <= in_use[buffer_r0[PEND_REQS_LOG2+607:608]];
		
		if (rx_c0_rdvalid & ~rx_c0_header[12]) in_use[rx_c0_header[PEND_REQS_LOG2-1:0]] <= 0;
		if (rx_c0_wrvalid)                     in_use[rx_c0_header[PEND_REQS_LOG2-1:0]] <= 0;
		if (rx_c1_wrvalid)                     in_use[rx_c1_header[PEND_REQS_LOG2-1:0]] <= 0;
		
		

		if ((fifo_out[543:512] == buffer_r0[543:512]) && ~stall) pipe_01_eq    <= 1'b1;
		if ((fifo_out[543:512] == buffer_r1[543:512]) && ~stall) pipe_02_eq    <= 1'b1;
		
		if (pipe_01_eq && valid_r0 && valid_r1 && ~stall) begin
			stall      <= 1'b1;
			stall_addr <= buffer_r1[PEND_REQS_LOG2+607:608];
		end
		if (pipe_02_eq && valid_r0 && valid_r2 && ~stall) begin
			stall      <= 1'b1;
			stall_addr <= buffer_r1[PEND_REQS_LOG2+607:608];
		end
		
		if (fast_stop) begin 
			stall      <= 1'b1;
			stall_addr <= cam_match_addr;
		end
		
		
		
		if ((stall == 1'b1) && (in_use[stall_addr] == 1'b0)) begin
			stall <= 1'b0;
			wena  <= 1'b1;
			wdata <= buffer_r1[543:512];
			waddr <= stall_addr;
		end
		
		if (stop_n && valid_r1) begin
			wena  <= 1'b1;
			wdata <= buffer_r1[543:512];
			waddr <= buffer_r1[PEND_REQS_LOG2+607:608];
			in_use[buffer_r1[PEND_REQS_LOG2+607:608]] <= 1'b1;
			
			byteenable_save <= buffer_r1[607:544];
			
			// CCI Type
			tx_c0_rdvalid <= ~buffer_r1[(PEND_REQS_LOG2+64+32+512)-1];
			tx_c1_wrvalid <=  buffer_r1[(PEND_REQS_LOG2+64+32+512)-1];
			
			// Read Header Info
			tx_c0_header[PEND_REQS_LOG2-1:0]  <= buffer_r1[PEND_REQS_LOG2+607:608];
			tx_c0_header[45:14]  <= buffer_r1[543:512];
			tx_c0_header[55:52]  <= RD_LINE;
			
			// Write Header Info
			tx_c1_header[PEND_REQS_LOG2-1:0]  <= buffer_r1[PEND_REQS_LOG2+607:608];
			tx_c1_header[45:14]  <= buffer_r1[543:512];
			tx_c1_header[55:52]  <= WR_LINE;
			
			// Data
			tx_c1_data    <= buffer_r1[511:0];
			
			if (~full_write_r1 && buffer_r1[(PEND_REQS_LOG2+64+32+512)-1]) begin
				tx_c0_rdvalid    <= 1'b1;
				tx_c1_wrvalid    <= 1'b0;
				tx_c0_header[12] <= 1'b1; // mark as special read
				rmw_save         <= 1'b1;
			end
			
		end
		
		if (rx_c0_rdvalid & ~rx_c0_header[12]) in_use[rx_c0_header[PEND_REQS_LOG2-1:0]] <= 0;
		if (rx_c0_wrvalid)                     in_use[rx_c0_header[PEND_REQS_LOG2-1:0]] <= 0;
		if (rx_c1_wrvalid)                     in_use[rx_c1_header[PEND_REQS_LOG2-1:0]] <= 0;
		if (rx_c0_rdvalid && rx_c0_header[12]) rmw_start1  <= 1'b1;
		
		rmw_buffer1  <= rx_c0_data;
		rmw_buffer2  <= rmw_buffer1;
		rmw_line1    <= rx_c0_header[PEND_REQS_LOG2-1:0];
		rmw_line2    <= rmw_line1;
		rmw_line3    <= rmw_line2;
		rmw_address3 <= rmw_ram[543:512];
		rmw_start2   <= rmw_start1;
		rmw_hold     <= rmw_start2;
		
		if (rmw_hold) begin
			// Write Header Info
			tx_c1_header[PEND_REQS_LOG2-1:0]  <= rmw_line3;
			tx_c1_header[45:14]               <= rmw_address3;
			tx_c1_header[55:52]               <= WR_LINE;
			// Data
			tx_c1_data                        <= rmw_buffer3;
			tx_c1_wrvalid                     <= 1'b1;
		end
	end
end

genvar i;
generate
    for (i = 0; i < 64; i = i + 1) begin: rmw_coalesce
        always @(posedge clk) begin
			if (rmw_ram[544+i]) begin
				rmw_buffer3[((i+1)*8)-1:i*8] <= rmw_ram[((i+1)*8)-1:i*8];
			end else begin
				rmw_buffer3[((i+1)*8)-1:i*8] <= rmw_buffer2[((i+1)*8)-1:i*8];
			end
		end
    end
endgenerate



altsyncram	ram_inst (
				.address_a (tx_c0_header[PEND_REQS_LOG2-2:0]),
				.address_b (rx_c0_header[PEND_REQS_LOG2-2:0]),
				.clock0 (clk),
				.data_a ({byteenable_save,tx_c0_header[45:14],tx_c1_data}),
				.wren_a (rmw_save),
				.q_b (rmw_ram),
				.aclr0 (1'b0),
				.aclr1 (1'b0),
				.addressstall_a (1'b0),
				.addressstall_b (1'b0),
				.byteena_a (1'b1),
				.byteena_b (1'b1),
				.clock1 (1'b1),
				.clocken0 (1'b1),
				.clocken1 (1'b1),
				.clocken2 (1'b1),
				.clocken3 (1'b1),
				.data_b ({608{1'b1}}),
				.eccstatus (),
				.q_a (),
				.rden_a (1'b1),
				.rden_b (1'b1),
				.wren_b (1'b0));
	defparam
		ram_inst.address_aclr_b = "NONE",
		ram_inst.address_reg_b = "CLOCK0",
		ram_inst.clock_enable_input_a = "BYPASS",
		ram_inst.clock_enable_input_b = "BYPASS",
		ram_inst.clock_enable_output_b = "BYPASS",
		ram_inst.intended_device_family = "Cyclone IV GX",
		ram_inst.lpm_type = "altsyncram",
		ram_inst.numwords_a = PEND_REQS/2,
		ram_inst.numwords_b = PEND_REQS/2,
		ram_inst.operation_mode = "DUAL_PORT",
		ram_inst.outdata_aclr_b = "NONE",
		ram_inst.outdata_reg_b = "CLOCK0",
		ram_inst.power_up_uninitialized = "FALSE",
		ram_inst.read_during_write_mode_mixed_ports = "DONT_CARE",
		ram_inst.widthad_a = PEND_REQS_LOG2-1,
		ram_inst.widthad_b = PEND_REQS_LOG2-1,
		ram_inst.width_a = 64+32+512,
		ram_inst.width_b = 64+32+512,
		ram_inst.width_byteena_a = 1;


assign lookup_data = fifo_out[543:512];

	parallel_match #(
		.DATA_WIDTH(32),
		.ADDR_1HOT(PEND_REQS),
		.ADDR_WIDTH(PEND_REQS_LOG2)
	) parallel_match_inst (
		.clk(clk),
		.rst(reset_n),
		
		//program port
		.waddr(waddr),
		.wdata(wdata),
		.wcare(32'h0),
		.wena(wena),
		
		// lookup
		.lookup_data(lookup_data),
		.lookup_data_valid(fifo_rd),
		.lookup_ena(stop_n),
		// response
		.match(cam_match),
		.match_addr(cam_match_addr)
	);


scfifo	scfifo_component (
			.clock (clk),
			.data  (fifo_in),
			.rdreq (fifo_rd),
			.wrreq (fifo_wr),
			.empty (fifo_empty),
			.full  (fifo_full),
			.q     (fifo_out),
			.usedw (),
			.aclr  (~reset_n),
			.almost_empty (),
			.almost_full (),
			.sclr (~reset_n));
defparam
	scfifo_component.add_ram_output_register = "OFF",
	scfifo_component.intended_device_family = "Cyclone IV GX",
	scfifo_component.lpm_numwords = 8,
	scfifo_component.lpm_showahead = "ON",
	scfifo_component.lpm_type = "scfifo",
	scfifo_component.lpm_width  = PEND_REQS_LOG2 + 64 + 32 + 512,
	scfifo_component.lpm_widthu = 3,
	scfifo_component.overflow_checking = "ON",
	scfifo_component.underflow_checking = "ON",
	scfifo_component.use_eab = "ON";



endmodule

