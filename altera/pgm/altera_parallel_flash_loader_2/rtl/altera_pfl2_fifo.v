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
//   ALT_PFL_FIFO
//
//  (c) Altera Corporation, 2012
//
//
//
////////////////////////////////////////////////////////////////////

//************************************************************
// Description:
//
// This module contains the PFL fifo
//************************************************************

// synthesis VERILOG_INPUT_VERSION VERILOG_2001

module altera_pfl2_fifo
(
	clock,
	// clear
	aclr,
	sclr,
	// writing data
	full,
	wrreq,
	data,
	// reading data
	empty,
	rdreq,
	q
);

    parameter ALWAYS_INCREASE_POINTER = "OFF";
    parameter LOOKAHEAD     = "ON";
    parameter NUMWORDS      = 4;
    parameter WIDTH         = 8;
    localparam INT_NUMWORDS = (NUMWORDS < 2) ? 2 : NUMWORDS;
    localparam DATA_COUNTER_WIDTH = log2(INT_NUMWORDS);
    localparam [DATA_COUNTER_WIDTH-1:0] INTERNAL_NUMWORDS = INT_NUMWORDS[DATA_COUNTER_WIDTH-1:0];
    localparam POINTER_WIDTH = log2(INT_NUMWORDS-1);
	
    input clock;
    
	// clear
    input aclr;
    input sclr;
    
	// writing data
    input [WIDTH-1:0] data;
    input wrreq;
    output full;
	
	// reading data
    input rdreq;
    output [WIDTH-1:0] q;
    output empty;
	
    wire [WIDTH-1:0] q_wire;
    reg [WIDTH-1:0] data_array [0:NUMWORDS-1];
    wire [POINTER_WIDTH-1:0] write_pointer_q;
    wire [POINTER_WIDTH-1:0] read_pointer_q;
    wire [DATA_COUNTER_WIDTH-1:0] data_counter_q;
    
    wire data_counter_en;
    wire data_counter_read_en;
    wire data_counter_write_en;
    wire read_pointer_en;
    wire write_pointer_en;
    
    assign full = (data_counter_q == INTERNAL_NUMWORDS);
    assign empty = (data_counter_q == {(DATA_COUNTER_WIDTH){1'b0}});
    assign read_pointer_en = (rdreq & ~empty);
    assign write_pointer_en = (wrreq & ~full);
		
	generate
	if (ALWAYS_INCREASE_POINTER == "ON") begin
		// write pointer
		lpm_counter write_pointer (
			.clock(clock),
			.cnt_en(write_pointer_en),
			.sclr(sclr),
			.aclr(aclr),
			.q(write_pointer_q)
		);
		defparam
			write_pointer.lpm_type = "LPM_COUNTER",
			write_pointer.lpm_width = POINTER_WIDTH;
	
		// read pointer
		lpm_counter read_pointer (
			.clock(clock),
			.cnt_en(read_pointer_en),
			.sclr(sclr),
			.aclr(aclr),
			.q(read_pointer_q)
		);
		defparam
			read_pointer.lpm_type = "LPM_COUNTER",
			read_pointer.lpm_width = POINTER_WIDTH;
	end
	else begin
		wire down_wirte_point_en = (rdreq & (data_counter_q == {{(DATA_COUNTER_WIDTH-1){1'b0}}, 1'b1}) & ~wrreq);
		lpm_counter write_pointer (
			.clock(clock),
			.cnt_en(write_pointer_en | down_wirte_point_en),
			.sclr(sclr),
			.aclr(aclr),
			.q(write_pointer_q),
			.updown(~down_wirte_point_en)
		);
		defparam
			write_pointer.lpm_type = "LPM_COUNTER",
			write_pointer.lpm_width = POINTER_WIDTH;
			
		// read pointer
		lpm_counter read_pointer (
			.clock(clock),
			.cnt_en(read_pointer_en & ~down_wirte_point_en),
			.sclr(sclr),
			.aclr(aclr),
			.q(read_pointer_q)
		);
		defparam
			read_pointer.lpm_type = "LPM_COUNTER",
			read_pointer.lpm_width = POINTER_WIDTH;
	end
	endgenerate
	
	always @ (posedge clock) begin
		if (write_pointer_en)
			data_array[write_pointer_q] = data;
	end
    
    generate
	if (LOOKAHEAD == "ON") begin
		assign q_wire = data_array[read_pointer_q];
	end
	else begin
		reg [WIDTH-1:0] q_wire_reg;
		always @ (posedge clock) begin
			if (read_pointer_en)
				q_wire_reg = data_array[read_pointer_q];
		end
        assign q_wire = q_wire_reg;
	end
	endgenerate
    
    assign  q = q_wire;
   
	// data_counter
	assign data_counter_write_en = (wrreq & ~rdreq & ~full);
	assign data_counter_read_en = (~wrreq & rdreq & ~empty);
	assign data_counter_en = data_counter_write_en | data_counter_read_en;
	lpm_counter data_counter (
		.clock(clock),
		.cnt_en(data_counter_en),
		.sclr(sclr),
		.aclr(aclr),
		.q(data_counter_q),
		.updown(data_counter_write_en)
	);
	defparam
	data_counter.lpm_type = "LPM_COUNTER",
	data_counter.lpm_width = DATA_COUNTER_WIDTH;
	
	function integer log2;
		input integer value_in;
		integer value;
		begin
		    value = value_in;
		    for (log2=0; value>0; log2=log2+1) 
		            value = value >> 1;
		end
	endfunction
endmodule
