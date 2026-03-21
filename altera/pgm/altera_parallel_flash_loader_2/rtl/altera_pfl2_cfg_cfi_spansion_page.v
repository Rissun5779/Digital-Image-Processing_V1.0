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
//   ALT_PFL_CFG_FLASH_SPANSION_PAGE
//
//  (c) Altera Corporation, 2007
//
//
//
////////////////////////////////////////////////////////////////////

//************************************************************
// Description:
//
// This module contains the PFL configuration CFI flash reader block
//************************************************************

// synthesis VERILOG_INPUT_VERSION VERILOG_2001

module altera_pfl2_cfg_cfi_spansion_page (
	clk,
	nreset,

	// Flash pins
	flash_select,
	flash_read,
	flash_write,
	flash_data_in,
	flash_data_out,
	flash_addr,
	flash_clk,
	flash_nadv,
	flash_rdy,
	flash_nreset,
	flash_data_highz,

	// Controller address
	addr_in,
	stop_addr_in,
	addr_sload,
	addr_cnt_en,
	done,
	
	// Controller data
	data_request,
	data_ready,
	data,

	// Access control
	flash_access_request,
	flash_access_granted
);
	
    parameter ACCESS_CLK_DIVISOR = 10;
    parameter ACCESS_CLK_DIVISOR_WIDTH = log2(ACCESS_CLK_DIVISOR);
    parameter FLASH_ADDR_WIDTH = 25;
    parameter FLASH_DATA_WIDTH = 16;
    parameter MT28EW_PAGE_MODE = 0;
    parameter FLASH_ADDR_WIDTH_INDEX = (FLASH_DATA_WIDTH == 32 && MT28EW_PAGE_MODE == 0) ? FLASH_ADDR_WIDTH +1 : FLASH_ADDR_WIDTH;
    parameter FLASH_DATA_WIDTH_INDEX = (FLASH_DATA_WIDTH == 32 && MT28EW_PAGE_MODE == 0) ? 16 : FLASH_DATA_WIDTH;
    parameter PAGE_ACCESS_CLK_DIVISOR = 3;
    
    input	clk;
    input	nreset;

    input 	[FLASH_DATA_WIDTH-1:0] flash_data_in;
    output 	[FLASH_DATA_WIDTH-1:0] flash_data_out;
    output	[FLASH_ADDR_WIDTH-1:0] flash_addr;
    input	flash_rdy;
    output	flash_clk;
    output	flash_data_highz;
    output	flash_nadv;
    output	flash_nreset;
    output 	flash_read;
    output 	flash_select;
    output 	flash_write;
	
    input 	[FLASH_ADDR_WIDTH_INDEX-1:0] addr_in;
    input	[FLASH_ADDR_WIDTH_INDEX-1:0] stop_addr_in;
    input	addr_cnt_en;
    input	addr_sload;
    output	done;
	
    input	data_request;
    output	[FLASH_DATA_WIDTH_INDEX-1:0] data;
    output	data_ready;
	
    input	flash_access_granted;
    output	flash_access_request;
	
    // State Machine
    reg [1:0] current_state, next_state;
    parameter CFG_SAME = 0;
    parameter CFG_INIT = 1;
    parameter CFG_ACCESS_CLK = 2;			// access counter = 100ns
    parameter CFG_PAGE_ACCESS_CLK = 3;		// access counter = 25ns
    
    wire [ACCESS_CLK_DIVISOR_WIDTH-1:0] access_counter_q;
    wire [FLASH_ADDR_WIDTH-1:0] addr_counter_q;
    
    wire access_counter_out;
    wire new_page;
    
    reg access_counter_done;
    reg flash_addr_done;
    reg granted;
    reg request;
    
    assign flash_write = 0;
    assign flash_data_highz = 1;
    assign flash_clk = 0;
    assign flash_nadv = 0;
    assign flash_nreset = 1;

    assign flash_select = granted;
    assign flash_read = granted;
    assign data = flash_data_in;
    assign flash_data_out = {FLASH_DATA_WIDTH{1'bX}};
	
	assign flash_access_request = request;
	always @(posedge clk or negedge nreset)
	begin
		request = data_request;
		if (~nreset)
			granted = 0;
		else if (data_request && ~granted)
			granted = flash_access_granted;
		else if (~data_request)
			granted = 0;
	end

	lpm_counter addr_counter (
		.clock(clk),
		.cnt_en(addr_cnt_en),
		.sload(addr_sload),
		.data(addr_in),
		.q(addr_counter_q)
	);
	defparam addr_counter.lpm_width=FLASH_ADDR_WIDTH;
	
	assign flash_addr = addr_counter_q;		

	always @ (posedge clk or negedge nreset) begin
		if (~nreset)
			flash_addr_done = 0;
		else if (addr_sload)
			flash_addr_done = 0;
		else if (addr_counter_q == stop_addr_in)	
			flash_addr_done = 1;
		else
			flash_addr_done = 0;
	end
	assign done = flash_addr_done;

	generate
        if (MT28EW_PAGE_MODE == 1) begin 	//page mode for MT28EW
            if(FLASH_DATA_WIDTH == 8) begin
                assign new_page = addr_counter_q[4:0] == 5'h1F && addr_cnt_en;
            end
            else begin
                assign new_page = addr_counter_q[3:0] == 4'hF && addr_cnt_en;
            end
        end
        else begin 	//page mode for 29GL
            if(FLASH_DATA_WIDTH == 8) begin
                assign new_page = addr_counter_q[3:0] == 4'hF && addr_cnt_en;
            end
            else begin
                assign new_page = addr_counter_q[2:0] == 3'h7 && addr_cnt_en;
            end
        end
    endgenerate
	
	assign access_counter_out = (current_state == CFG_ACCESS_CLK) ? access_counter_q == ACCESS_CLK_DIVISOR[ACCESS_CLK_DIVISOR_WIDTH-1:0] :
									access_counter_q == PAGE_ACCESS_CLK_DIVISOR[ACCESS_CLK_DIVISOR_WIDTH-1:0];

	always @(nreset, new_page, access_counter_out, current_state, addr_sload, addr_cnt_en)
	begin
		if (~nreset) begin
			next_state = CFG_INIT;
		end
		else if (new_page || addr_sload)
		begin
			next_state = CFG_ACCESS_CLK;
		end
		else begin
			case (current_state)
			CFG_INIT:
				next_state = CFG_ACCESS_CLK;
			CFG_ACCESS_CLK:				
				if (addr_cnt_en) 
					next_state = CFG_PAGE_ACCESS_CLK;
				else
					next_state = CFG_SAME;			
			CFG_PAGE_ACCESS_CLK:
				next_state = CFG_SAME;	
			default:
				next_state = CFG_ACCESS_CLK;
			endcase
		end
	end
	
	always @(negedge nreset or posedge clk)
	begin			
		if (~nreset) 
			current_state = CFG_INIT;
		else begin
			if(next_state != CFG_SAME)
				current_state = next_state;
		end
	end
	
	lpm_counter access_counter (
		.clock(clk),
		.sclr(addr_sload || addr_cnt_en || new_page || ~granted),
		.cnt_en(~access_counter_out),
		.q(access_counter_q)
	);
	defparam access_counter.lpm_width=ACCESS_CLK_DIVISOR_WIDTH;
		
	always @ (posedge clk or negedge nreset) 
	begin
		if (~nreset)
			access_counter_done = 0;
		else if (addr_sload || addr_cnt_en)
			access_counter_done = 0;
		else
			access_counter_done = access_counter_out;
	end	
	
	assign data_ready = access_counter_done;
    
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

