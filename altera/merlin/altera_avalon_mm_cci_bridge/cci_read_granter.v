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


 
module read_granter #(
	parameter PEND_REQS = 16,
	parameter PEND_REQS_LOG2 = 4
	)(
	input clk,
	input reset_n,
	output reg [511:0] avmm_readdata,
	output reg avmm_readdatavalid,
	input rx_c0_rdvalid,
	input [17:0] rx_c0_header,
	input [511:0] rx_c0_data,
	output [PEND_REQS_LOG2-1:0] read_tag,
	output read_tag_ready,
	input read_tag_valid
	);


// These are reserved command encodings specified in CCI
localparam WR_THRU   = 4'h1;
localparam WR_LINE   = 4'h2;
localparam RD_LINE   = 4'h4;
localparam WR_FENCE  = 4'h5;

// The read/writes pointers for the reorder buffer
reg [PEND_REQS_LOG2-1:0] next_to_issue_index;
reg [PEND_REQS_LOG2-1:0] next_to_clear_index;
reg [PEND_REQS_LOG2:0]   total_issued_index;

// Backpressure is decided based on the amount of issued reads and the CCI almost full flag (in the case of reads)
// the most significant bit of total_issued_index is considered a "FULL" flag for the reorder buffer
// In the case of writes the bridge doesn't throttle writes, just the CCI almostfull flag on channel 1 pushes back
assign read_tag_ready = ~total_issued_index[PEND_REQS_LOG2];
						  
// Re-order Buffer Description
// define a memory with a depth of 2**PEND_REQS_LOG2 for storage of 512-bit cachelines
// specify to the mapper that read during write behavior is not important
(* ramstyle="no_rw_check" *) reg [512 - 1 : 0] mem [(2**PEND_REQS_LOG2) - 1 : 0];

// define a control bit for each cacheline in the storage element
reg [(2**PEND_REQS_LOG2)-1:0] mem_valid = 'b0;

// Always provide the "next" cacheline expected to be returned for a read request
always @(*) avmm_readdata = mem[next_to_clear_index];

// When a cacheline read is returned back from CCI
// take the data and write it to the reorder buffer at the address
// specified in the MData field of the CCI header
always @(posedge clk) begin
	if (rx_c0_rdvalid && ~rx_c0_header[12]) mem[rx_c0_header[PEND_REQS_LOG2-1:0]] <= rx_c0_data;
end

// This clocked process handles Read Requests
always @(posedge clk or negedge reset_n) begin
	// on reset initialize all control signals (reorder buffer indices and valids)
	if (reset_n == 1'b0) begin
		next_to_issue_index <= 'h0;
		next_to_clear_index <= 'h0;
		total_issued_index  <= 'h0;
		mem_valid           <= 'h0;
		avmm_readdatavalid  <= 'b0;
	end
	else begin
		// set valid to the "next" reorder buffer valid unless otherwise specified
		avmm_readdatavalid  <= mem_valid[next_to_clear_index];
		
		// When a cacheline read is returned
		if (avmm_readdatavalid) begin
			// increment to the next cacheline to clear in the reorder buffer
			next_to_clear_index <= next_to_clear_index + {{PEND_REQS_LOG2-1{1'b0}},1'b1};
			// decrement the total pending counter
			total_issued_index  <= total_issued_index  - {{PEND_REQS_LOG2{1'b0}},1'b1};
			// place the cacheline valid signal low
			mem_valid[next_to_clear_index] <= 1'b0;
			// current line is processed, observe next line for the next clock cycle
			avmm_readdatavalid  <= mem_valid[next_to_clear_index + {{PEND_REQS_LOG2-1{1'b0}},1'b1}];
		end

		// On a read request we only process the read if CCI isn't indicating backpressure
		// and if we have room in our reorder buffer, otherwise we backpressure the Avalon-MM IF
		// the most significant bit of total_issued_index is considered a "FULL" flag for the reorder buffer
		if (read_tag_valid && ~total_issued_index[PEND_REQS_LOG2]) begin
			
			// increment the "next free resource" pointer, the current one is being taken
			next_to_issue_index <= next_to_issue_index + {{PEND_REQS_LOG2-1{1'b0}},1'b1};
			
			// we are taking a resource, increment the total pending index
			// UNLESS a resource is being freed on this clock cycle, if that
			// is the case then keep the total pending index unchanged
			if (~avmm_readdatavalid) total_issued_index  <= total_issued_index  + {{PEND_REQS_LOG2{1'b0}},1'b1};
			else total_issued_index  <= total_issued_index;
		
		end
		
		// As read cachelines are being returned on CCI use the Mdata to "validate"
		// the specific cacheline that was returned on the interface
		if (rx_c0_rdvalid && ~rx_c0_header[12]) mem_valid[rx_c0_header[PEND_REQS_LOG2-1:0]] <= 1'b1;
	end
end

assign read_tag = next_to_issue_index;

endmodule
