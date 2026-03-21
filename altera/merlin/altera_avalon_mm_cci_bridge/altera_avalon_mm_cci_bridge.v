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


 
module altera_avalon_mm_cci_bridge #(
	parameter PEND_REQS = 32,
	parameter PEND_REQS_LOG2 = 5
	)(
	input clk,
	input reset_n,
	input InitDone,
	input wire [17:0] rx_c0_header,
	input wire [511:0] rx_c0_data,
	input wire rx_c0_rdvalid,
	input wire rx_c0_wrvalid,
	input wire rx_c0_cfgvalid,
	input wire rx_c0_ugvalid,
	input wire rx_c0_irvalid,
	input wire rx_c1_irvalid,
	output wire tx_c1_irvalid,
	output wire [60:0] tx_c0_header,
	output wire tx_c0_rdvalid,
	input wire tx_c0_almostfull,
	input wire [17:0] rx_c1_header,
	input wire rx_c1_wrvalid,
	output wire [60:0] tx_c1_header,
	output wire [511:0] tx_c1_data,
	output wire tx_c1_wrvalid,
	input wire tx_c1_almostfull,
	input wire [31:0] avmm_address,
	input wire [63:0] avmm_byteenable,
	input wire avmm_write,
	input wire [511:0] avmm_writedata,
	input wire avmm_read,
	output wire [511:0] avmm_readdata,
	output wire avmm_readdatavalid,
	output wire avmm_waitrequest,
	output write_pending,
	output reg [31:0] cciconfig_address,
	output reg cciconfig_write,
	output reg [31:0] cciconfig_writedata,
	input wire cciconfig_waitrequest
	);


	wire [PEND_REQS_LOG2-2:0] read_tag;
	wire read_tag_ready;
	wire read_tag_valid;
	wire [PEND_REQS_LOG2-2:0] write_tag;
	wire write_tag_ready;
	wire write_tag_valid;
	
	assign tx_c1_irvalid = 1'b0;

	cci_requester #(
		.PEND_REQS(PEND_REQS),
		.PEND_REQS_LOG2(PEND_REQS_LOG2)
	) cci_requester_inst (
		.clk(clk),
		.reset_n(reset_n),
		.rx_c0_header(rx_c0_header),
		.rx_c0_data(rx_c0_data),
		.rx_c0_rdvalid(rx_c0_rdvalid),
		.rx_c0_wrvalid(rx_c0_wrvalid),
		.tx_c0_header(tx_c0_header),
		.tx_c0_rdvalid(tx_c0_rdvalid),
		.tx_c0_almostfull(tx_c0_almostfull),
		.rx_c1_header(rx_c1_header),
		.rx_c1_wrvalid(rx_c1_wrvalid),
		.tx_c1_header(tx_c1_header),
		.tx_c1_data(tx_c1_data),
		.tx_c1_wrvalid(tx_c1_wrvalid),
		.tx_c1_almostfull(tx_c1_almostfull),
		.avmm_address(avmm_address),
		.avmm_byteenable(avmm_byteenable),
		.avmm_write(avmm_write),
		.avmm_writedata(avmm_writedata),
		.avmm_read(avmm_read),
		.avmm_waitrequest(avmm_waitrequest),
		.read_tag(read_tag),
		.read_tag_ready(read_tag_ready),
		.read_tag_valid(read_tag_valid),
		.write_tag(write_tag),
		.write_tag_ready(write_tag_ready),
		.write_tag_valid(write_tag_valid)
	);


	read_granter #(
		.PEND_REQS(PEND_REQS/2),
		.PEND_REQS_LOG2(PEND_REQS_LOG2-1)
	) read_granter_inst (
		.clk(clk),
		.reset_n(reset_n),
		.avmm_readdata(avmm_readdata),
		.avmm_readdatavalid(avmm_readdatavalid),
		.rx_c0_rdvalid(rx_c0_rdvalid),
		.rx_c0_header(rx_c0_header),
		.rx_c0_data(rx_c0_data),
		.read_tag(read_tag),
		.read_tag_ready(read_tag_ready),
		.read_tag_valid(read_tag_valid)
	);
	
	write_granter #(
		.PEND_REQS(PEND_REQS/2),
		.PEND_REQS_LOG2(PEND_REQS_LOG2-1)
	) write_granter_inst (
		.clk(clk),
		.reset_n(reset_n),
		.rx_c0_header(rx_c0_header),
		.rx_c0_wrvalid(rx_c0_wrvalid),
		.rx_c1_header(rx_c1_header),
		.rx_c1_wrvalid(rx_c1_wrvalid),
		.write_tag(write_tag),
		.write_tag_ready(write_tag_ready),
		.write_tag_valid(write_tag_valid),
		.write_pending(write_pending)
	);

	// Clocked process to handle CCI Config Writes to AFU CSR
	always @(posedge clk or negedge reset_n) begin
		if (reset_n == 1'b0) cciconfig_write <= 1'b0; // make sure control signals are reset
		else begin
			cciconfig_write     <= 1'b0;
			// Fairly straight foward 1-clock register stage
			// CCI CfgWrites map directly to Avalon-MM easily
			cciconfig_address   <= rx_c0_header[11:0];
			cciconfig_write     <= rx_c0_cfgvalid;
			cciconfig_writedata <= rx_c0_data[31:0];
			
			if (cciconfig_waitrequest && cciconfig_write) begin
				cciconfig_address   <= cciconfig_address;
				cciconfig_write     <= cciconfig_write;
				cciconfig_writedata <= cciconfig_writedata;
			end

		end
	end


endmodule
