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



///////////////////////////////////////////////////////////////////////////////
// Top-level wrapper of 20nm PHYLite component.
//
///////////////////////////////////////////////////////////////////////////////

module phylite_agent #(
	parameter PHYLITE_NUM_GROUPS                  = 1,
	parameter PHYLITE_USE_DYNAMIC_RECONFIGURATION = 1,
	parameter AGENT_INDEX                         = 0,
	parameter AGENT_PIN_TYPE                      = "BIDIR",
	parameter AGENT_PIN_WIDTH                     = 9,
	parameter AGENT_DDR_SDR_MODE                  = "DDR",
	parameter AGENT_STROBE_CONFIG                 = "SINGLE_ENDED",
	parameter AGENT_DATA_CONFIG                   = "SGL_ENDED",
	parameter AGENT_READ_LATENCY                  = 4,
	parameter AGENT_CAPTURE_PHASE_SHIFT           = 0,
	parameter AGENT_WRITE_LATENCY                 = 0,
	parameter AGENT_USE_OUTPUT_STROBE             = 1,
	parameter AGENT_USE_SEPARATE_STROBES          = 0,
	parameter AGENT_SWAP_CAPTURE_STROBE_POLARITY  = 0,
	parameter AGENT_OUTPUT_STROBE_PHASE           = 0,
	parameter AGENT_USE_INTERNAL_CAPTURE_STROBE   = 0,
	parameter AGENT_DATA_IN_DELAY_PS              = 0,
	parameter AGENT_DATA_OUT_DELAY_PS             = 0,
	parameter AGENT_STROBE_OUT_DELAY_PS           = 0
	) (

	// PHYLite DUT I/O Interface
	input  [AGENT_PIN_WIDTH - 1 : 0] data_in,
	input  [AGENT_PIN_WIDTH - 1 : 0] data_in_n,
	input                            strobe_in,
	input                            strobe_in_n,

	output [AGENT_PIN_WIDTH - 1 : 0] data_out,
	output [AGENT_PIN_WIDTH - 1 : 0] data_out_n,
	output                           strobe_out,
	output                           strobe_out_n,

	inout  [AGENT_PIN_WIDTH - 1 : 0] data_io,
	inout  [AGENT_PIN_WIDTH - 1 : 0] data_io_n,
	inout                            strobe_io,
	inout                            strobe_io_n,

	// ADDR/CMD Interface Daisy Chain
	input  [PHYLITE_NUM_GROUPS + 3 - 1 : 0] mem_cmd_in,
	input                                   mem_cmd_clk_in,
	output [PHYLITE_NUM_GROUPS + 3 - 1 : 0] mem_cmd_out,
	output                                  mem_cmd_clk_out,

	// Side Interface Daisy Chain
	input  [PHYLITE_NUM_GROUPS - 1 : 0] agent_select_in,
	input                               side_write_in,
	input                               side_read_in,
	input                        [95:0] side_write_data_in,
	output                       [95:0] side_read_data_out,
	output                              side_readdata_valid_out,
	input                         [3:0] side_readaddr_in,

	output [PHYLITE_NUM_GROUPS - 1 : 0] agent_select_out,
	output                              side_write_out,
	output                              side_read_out,
	output                       [95:0] side_write_data_out,
	input                        [95:0] side_read_data_in,
	input                               side_readdata_valid_in,
	output                        [3:0] side_readaddr_out

	);
	timeunit 1ps;
	timeprecision 1ps;

	////////////////////////////////////////////////////////////////////////////
	// Local Parameters
	////////////////////////////////////////////////////////////////////////////
	localparam FIFO_DEPTH = 8;
	localparam FIFO_ADDR_WIDTH = 3;

	////////////////////////////////////////////////////////////////////////////
	// Wire Declarations
	////////////////////////////////////////////////////////////////////////////
	// Clocks
	wire mem_clk;

	// Internal Input Strobe/Data
	wire strobe_gen;
	wire strobe_gen_n;
	wire input_strobe;
	wire input_strobe_n;
	wire [AGENT_PIN_WIDTH - 1 : 0] input_data;
	wire [AGENT_PIN_WIDTH - 1 : 0] input_data_d;
	wire internal_capture_clk;

	// ADDR/CMD Signals
	wire mem_rst_n;
	wire mem_rd;
	wire mem_wr;
	wire mem_sel;

	// Internal Command Signals
	reg mem_rd_delayed;
	reg mem_rd_r;

	// FIFO Test Memory
	reg [2 * AGENT_PIN_WIDTH - 1 : 0] fifo [ 0 : FIFO_DEPTH - 1];
	reg [FIFO_ADDR_WIDTH - 1 : 0] rdadd;    
	reg [2 * AGENT_PIN_WIDTH - 1 : 0] read_data;
	wire [AGENT_PIN_WIDTH -1 : 0] read_data_ddio;
	wire rdena;
	wire output_enable;
	wire output_enable_d;
	wire output_enable_extended;
	reg wrena; 
	reg [FIFO_ADDR_WIDTH - 1 : 0] wradd;    
	reg [FIFO_ADDR_WIDTH - 1 : 0] s_wradd;  
	reg [2 * AGENT_PIN_WIDTH - 1 : 0] capture_reg;
	reg [AGENT_PIN_WIDTH - 1 : 0] capture_reg_tmp;

	// Side Channel
	wire        side_sel;
	wire [95:0] side_read_data;
	wire        side_readdata_valid;
	wire        side_read;
	wire        side_write;

	////////////////////////////////////////////////////////////////////////////
	// Dynamic Reconfiguration
	////////////////////////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////////////////////////
	// Assignments and Tie-offs
	////////////////////////////////////////////////////////////////////////////
	// Clocks
	assign mem_clk        = mem_cmd_clk_in;

	// ADDR/CMD Daisy Chain
	assign mem_cmd_out     = mem_cmd_in    ;
	assign mem_cmd_clk_out = mem_cmd_clk_in;

	// Side Channel Daisy Chain
	assign side_sel = agent_select_in[AGENT_INDEX];

	assign agent_select_out       = agent_select_in      ;
	assign side_write_out         = side_write_in        ;
	assign side_read_out          = side_read_in         ;
	assign side_write_data_out    = side_write_data_in   ;
	assign side_readaddr_out      = side_readaddr_in     ;

	assign side_read_data_out      = side_sel ? side_read_data      : side_read_data_in     ;
	assign side_readdata_valid_out = side_sel ? side_readdata_valid : side_readdata_valid_in;

	assign side_read  = side_read_in & side_sel;
	assign side_write = side_write_in & side_sel;

	// ADDR/CMD Signals
	assign mem_rst_n = mem_cmd_in[0];
	assign mem_rd    = mem_cmd_in[1] & mem_sel;
	assign mem_wr    = mem_cmd_in[2] & mem_sel;
	assign mem_sel   = mem_cmd_in[AGENT_INDEX + 3];

	////////////////////////////////////////////////////////////////////////////
	// Read Logic
	////////////////////////////////////////////////////////////////////////////

	// Read Latency
	generate
		if (AGENT_READ_LATENCY == 0) begin
			always @(*) begin
				mem_rd_delayed = mem_rd;
			end
		end else if (AGENT_READ_LATENCY == 1) begin
			always @(posedge mem_clk or negedge mem_rst_n) begin
				if (!mem_rst_n) begin
					mem_rd_delayed <= 1'b0;
				end else begin
					mem_rd_delayed <= mem_rd;
				end
			end
		end else begin
			reg [AGENT_READ_LATENCY-1:0] mem_rd_sr;
			always @(posedge mem_clk or negedge mem_rst_n) begin
				if (!mem_rst_n) begin
					mem_rd_sr <= {AGENT_READ_LATENCY{1'b0}};
				end else begin
					mem_rd_sr <= {mem_rd_sr[AGENT_READ_LATENCY-2:0],mem_rd};
				end
			end
			always @(*) begin
				mem_rd_delayed = mem_rd_sr[AGENT_READ_LATENCY-1];
			end
		end
	endgenerate

	// internal read lines up to mem_clk
	always @ (posedge mem_clk or negedge mem_rst_n) begin
		if (!mem_rst_n) begin
			mem_rd_r = 0;
		end else begin
			mem_rd_r <= mem_rd_delayed;
		end
	end

	assign rdena = mem_rd_r;

	// added 1/2 clock cycle of preamble for read
	assign strobe_gen   = (AGENT_USE_INTERNAL_CAPTURE_STROBE == 1) ? 1'b0 : ((AGENT_USE_SEPARATE_STROBES == 1) ?  mem_clk : ((mem_rd_r) ?  mem_clk : ((~mem_rd_r&mem_rd_delayed) ? 1'b0 : 1'bz)));
	assign strobe_gen_n = (AGENT_USE_INTERNAL_CAPTURE_STROBE == 1) ? 1'b0 : ((AGENT_USE_SEPARATE_STROBES == 1) ? ~mem_clk: ((mem_rd_r) ? ~mem_clk : ((~mem_rd_r&mem_rd_delayed) ? 1'b1 : 1'bz)));
	assign strobe_out   = (AGENT_SWAP_CAPTURE_STROBE_POLARITY == 1) ? strobe_gen_n : strobe_gen  ;
	assign strobe_out_n = (AGENT_SWAP_CAPTURE_STROBE_POLARITY == 1) ? strobe_gen   : strobe_gen_n;

	assign strobe_io   = (AGENT_USE_INTERNAL_CAPTURE_STROBE == 1) ? 1'bz : strobe_out  ;
	assign strobe_io_n = (AGENT_USE_INTERNAL_CAPTURE_STROBE == 1) ? 1'bz : strobe_out_n;

	always @ (posedge mem_clk or negedge mem_rst_n) begin
		if(~mem_rst_n) begin
			rdadd <= 0;
		end else begin
			if(rdena) begin
				rdadd <= rdadd + 1'b1;
			end
		end
	end

	assign read_data = (side_read) ? fifo[side_readaddr_in] : 
        	           ((mem_rd_r) ? fifo[rdadd] : {{2*AGENT_PIN_WIDTH}{1'bz}});
	assign read_data_ddio = mem_clk ? read_data[AGENT_PIN_WIDTH - 1 : 0] : read_data[2 * AGENT_PIN_WIDTH - 1 : AGENT_PIN_WIDTH];

	assign output_enable = rdena;
	assign #AGENT_DATA_OUT_DELAY_PS output_enable_d = output_enable;
	assign output_enable_extended = output_enable | output_enable_d;
	assign #AGENT_DATA_OUT_DELAY_PS data_out = (output_enable_extended === 1'b1) ? read_data_ddio : {{AGENT_PIN_WIDTH}{1'bz}};
	assign #AGENT_DATA_OUT_DELAY_PS data_out_n = (AGENT_DATA_CONFIG != "SGL_ENDED") ? ((output_enable_extended === 1'b1) ? ~read_data_ddio : {{AGENT_PIN_WIDTH}{1'bz}}) : {{AGENT_PIN_WIDTH}{1'bz}};

	assign data_io = (output_enable_extended === 1'b1) ? data_out : {{AGENT_PIN_WIDTH}{1'bz}};
	assign data_io_n = (AGENT_DATA_CONFIG != "SGL_ENDED") ? ~data_io : {{AGENT_PIN_WIDTH}{1'bz}};

	assign side_read_data = read_data;
	assign side_readdata_valid = side_read;

	////////////////////////////////////////////////////////////////////////////
	// Write Logic
	////////////////////////////////////////////////////////////////////////////


	// Input Strobe - if test group does not use an output strobe, use the memory clock
	assign internal_capture_clk = mem_clk; // avoid race conditions on initial capture posedge by using small delay
	assign input_strobe   = (AGENT_USE_OUTPUT_STROBE == 0) ?  internal_capture_clk : (((AGENT_PIN_TYPE == "BIDIR") && (AGENT_USE_SEPARATE_STROBES == 0)) ? strobe_io : strobe_in);
	assign input_strobe_n = (AGENT_USE_OUTPUT_STROBE == 0) ? ~internal_capture_clk : ((AGENT_STROBE_CONFIG == "DIFFERENTIAL" || AGENT_STROBE_CONFIG == "COMPLEMENTARY") ? (((AGENT_PIN_TYPE == "BIDIR") && (AGENT_USE_SEPARATE_STROBES == 0)) ? strobe_io_n : strobe_in_n) : ~input_strobe);

	assign input_data = (AGENT_PIN_TYPE == "BIDIR") ? ((AGENT_DATA_CONFIG == "SGL_ENDED") ? data_io : ~data_io_n) : (AGENT_DATA_CONFIG == "SGL_ENDED") ? data_in : ~data_in_n;
	assign #AGENT_DATA_IN_DELAY_PS input_data_d = input_data;

	// Write Latency
	generate
		if (AGENT_WRITE_LATENCY == 0) begin
			always @ (posedge mem_clk or negedge mem_rst_n) begin
				if(!mem_rst_n) begin
					wrena <= 0;
				end else begin
					wrena <= mem_wr;
				end
			end
		end else begin
			reg [AGENT_WRITE_LATENCY:0] wrena_sr; // delay of extra cycle always exists (see 0 case above)
			always @ (posedge mem_clk or negedge mem_rst_n) begin
				if(!mem_rst_n) begin
					wrena_sr <= {AGENT_WRITE_LATENCY{1'b0}};
				end else begin
					wrena_sr <= {wrena_sr[AGENT_WRITE_LATENCY-1:0],mem_wr};
				end
			end
			always @(*) begin
				wrena = wrena_sr[AGENT_WRITE_LATENCY];
			end
		end
	endgenerate

	// DDIO Capture Reg
	genvar i;
	generate
	begin : creg
		for(i = 0; i < AGENT_PIN_WIDTH; i = i + 1) begin
			always @(posedge input_strobe) begin
				capture_reg_tmp[i] = input_data_d[i];
			end
			always @(posedge input_strobe_n) begin
                if(input_strobe_n == 1) begin
				    capture_reg[i] = capture_reg_tmp[i];
				    capture_reg[i + AGENT_PIN_WIDTH] = input_data_d[i];
                end    
			end
		end
	end
	endgenerate

	// Write FIFO
	always @ (posedge mem_clk or negedge mem_rst_n) begin
		if(~mem_rst_n) begin
			wradd <= 0;
		end
		else begin
			if(wrena) begin
				wradd <= wradd + 1'b1;
				fifo[wradd] <= capture_reg;
			end
		end
	end

	// Side write FIFO
	always @ (posedge mem_clk or negedge mem_rst_n) begin
		if(!mem_rst_n) begin
			s_wradd <= 0;
		end else begin
			if(side_write) begin
				s_wradd <= s_wradd + 1'b1;
				fifo[s_wradd] <= {side_write_data_in[AGENT_PIN_WIDTH + 48 - 1 : 48], side_write_data_in[AGENT_PIN_WIDTH - 1 : 0]};
			end
		end
	end

endmodule
