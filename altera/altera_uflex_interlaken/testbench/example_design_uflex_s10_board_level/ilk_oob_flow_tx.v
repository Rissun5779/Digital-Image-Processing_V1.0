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


`timescale 1 ps / 1 ps
// baeckler - 04-08-2009

module ilk_oob_flow_tx #(
	parameter CAL_BITS = 16,  // must be at least 2 no more than 256
	parameter NUM_LANES = 8
)(
	input double_fc_clk,
	input double_fc_arst,

	input [CAL_BITS-1:0] calendar, // bit 0 <=> chan 0
	input [NUM_LANES-1:0] lane_status, // bit 0 <=> lane 0
	input link_status,
	input ena_status,  // request alternating stat/cal as opposed to cal only

	output reg fc_clk,
	output reg fc_data,
	output reg fc_sync
);

// NOTE: this is not a rigorous mathematical definition of LOG2(v).
// This function computes the number of bits required to represent "v".
// So log2(256) will be  9 rather than 8 (256 = 9'b1_0000_0000).

function integer log2;
  input integer val;
  begin
	 log2 = 0;
	 while (val > 0) begin
	    val = val >> 1;
		log2 = log2 + 1;
	 end
  end
endfunction

localparam STATUS_BITS = NUM_LANES + 1;
localparam LOG_CAL_BITS = log2(CAL_BITS);
localparam LOG_STATUS_BITS = log2(STATUS_BITS);

////////////////////////////////////////////////////
// move the FC_CLK signal out of phase for capture
// and at half-rate
////////////////////////////////////////////////////
always @(negedge double_fc_clk or posedge double_fc_arst) begin
	if (double_fc_arst) fc_clk <= 1'b0;
	else fc_clk <= ~fc_clk;
end

////////////////////////////////////////////////////
// calendar recycling register
////////////////////////////////////////////////////

// bit 0 reflects channel 0, to be transmitted first
reg [CAL_BITS-1:0] cal_sr;
reg [LOG_CAL_BITS-1:0] cal_position;
reg cal_zero,cal_last;
wire cal_shift, cal_load;

always @(posedge double_fc_clk or posedge double_fc_arst) begin
	if (double_fc_arst) begin
		cal_sr <= {CAL_BITS{1'b0}};
		cal_position <= {LOG_CAL_BITS{1'b0}};
		cal_zero <= 1'b1;
		cal_last <= 1'b0;
	end
	else begin
		if (cal_shift) begin
			cal_sr <= {cal_sr[0],cal_sr[CAL_BITS-1:1]};
			if (cal_position == CAL_BITS-1) begin
				cal_position <= {LOG_CAL_BITS{1'b0}};
				cal_zero <= 1'b1;
			end
			else begin
				cal_position <= cal_position + 1'b1;
				cal_zero <= 1'b0;
			end

			// identify the last bit of the calendar stream
			// also required to insert CRC after 64 bits
			// of calendar info.
			cal_last <= 1'b0;
			if (cal_position == CAL_BITS-2 ||
				(CAL_BITS > 64) && cal_position == (64-2) ||
				(CAL_BITS > 128) && cal_position == (128-2) ||
				(CAL_BITS > 192) && cal_position == (192-2))
			begin
				cal_last <= 1'b1;
			end
		end

		if (cal_load & cal_zero) cal_sr <= calendar;
	end
end

////////////////////////////////////////////////////
// stat message recycling register
////////////////////////////////////////////////////

// bit 0 reflects link stat, to be transmitted first
// bit 1 reflects lane 0
// ... lane n
reg [STATUS_BITS-1:0] stat_sr;
reg [LOG_STATUS_BITS-1:0] stat_position;
reg stat_zero,stat_last;
wire stat_shift, stat_load;

always @(posedge double_fc_clk or posedge double_fc_arst) begin
	if (double_fc_arst) begin
		stat_sr <= {STATUS_BITS{1'b0}};
		stat_position <= {LOG_STATUS_BITS{1'b0}};
		stat_zero <= 1'b1;
		stat_last <= 1'b0;
	end
	else begin
		if (stat_shift) begin
			stat_sr <= {stat_sr[0],stat_sr[STATUS_BITS-1:1]};

			if (stat_position == STATUS_BITS-1) begin
				stat_position <= 0;
				stat_zero <= 1'b1;
			end
			else begin
				stat_position <= stat_position + 1'b1;
				stat_zero <= 1'b0;
			end
			stat_last <= (stat_position == STATUS_BITS-2);
		end

		if (stat_load & stat_zero) stat_sr <= {lane_status,link_status};
	end
end

////////////////////////////////////////////////////
// CRC register
////////////////////////////////////////////////////

reg [3:0] crc_reg;
wire crc_evolve, crc_shift;
wire crc_din; // data bit to evolve with

always @(posedge double_fc_clk or posedge double_fc_arst) begin
	if (double_fc_arst) begin
		crc_reg <= 4'hf;
	end
	else begin
		if (crc_evolve) begin
			crc_reg[3] <= crc_reg[2];
			crc_reg[2] <= crc_reg[1];
			crc_reg[1] <= crc_reg[0] ^ crc_reg[3] ^ crc_din;
			crc_reg[0] <= crc_reg[3] ^ crc_din;
		end
		if (crc_shift) begin
			// shift in 1's so we can not bother with reset
			crc_reg <= {crc_reg[2:0],1'b1};
		end
	end
end

////////////////////////////////////////////////////
// Output selection
////////////////////////////////////////////////////

reg fc_data_w, fc_sync_w;
reg [1:0] tx_source;
always @(*) begin
	case (tx_source)
		2'b00 :  begin
				// send calendar data, sync on position 0
				fc_data_w = cal_sr[0];
				fc_sync_w = cal_zero;
			end
		2'b01 :	begin
				// send CRC (inverted), hold sync
				fc_data_w = !crc_reg[3];
				fc_sync_w = fc_sync;
			end
		2'b10 :	begin
				// send stat, sync = 1
				fc_data_w = stat_sr[0];
				fc_sync_w = 1'b1;
			end
		2'b11 : begin
				// send zeros, sync = 1
				fc_data_w = 1'b0;
				fc_sync_w = 1'b1;
			end
	endcase
end

assign crc_din = fc_data_w;

always @(posedge double_fc_clk or posedge double_fc_arst) begin
	if (double_fc_arst) begin
		fc_data <= 1'b0;
		fc_sync <= 1'b0;
	end
	else begin
		fc_data <= fc_data_w;
		fc_sync <= fc_sync_w;
	end
end

////////////////////////////////////////////////////
// control signals
////////////////////////////////////////////////////

// calendar and stat bits require CRC evolution
assign crc_evolve = !tx_source[0];

// when the CRC isn't evolving shift it out
assign crc_shift = !crc_evolve;

// when data is headed out, advance to the next bit
assign cal_shift = (tx_source == 2'b00);
assign stat_shift = (tx_source == 2'b10);

// when not sending a stream you can have permission to update it
assign stat_load = (tx_source != 2'b10);
assign cal_load = (tx_source != 2'b00);

////////////////////////////////////////////////////
// Control state machine
////////////////////////////////////////////////////

// keep track of alternating calendar vs. stat messages
reg just_sent_stat;
always @(posedge double_fc_clk or posedge double_fc_arst) begin
	if (double_fc_arst) just_sent_stat <= 1'b0;
	else begin
		if (tx_source == 2'b10) just_sent_stat <= 1'b1;
		if (tx_source == 2'b00) just_sent_stat <= 1'b0;
	end
end

localparam
	ST_CAL = 4'h0,
	ST_CRC3 = 4'h1,
	ST_CRC2 = 4'h2,
	ST_CRC1 = 4'h3,
	ST_CRC0 = 4'h4,
	ST_PREAMBLE7 = 4'h5,
	ST_PREAMBLE6 = 4'h6,
	ST_PREAMBLE5 = 4'h7,
	ST_PREAMBLE4 = 4'h8,
	ST_PREAMBLE3 = 4'h9,
	ST_PREAMBLE2 = 4'ha,
	ST_PREAMBLE1 = 4'hb,
	ST_PREAMBLE0 = 4'hc,
	ST_STATUS = 4'hd;

reg [3:0] state /* synthesis preserve */;
reg [3:0] next_state;

always @(*) begin
	next_state = state;
	tx_source = 2'b11; // default to sending preamble
	case (state)
		ST_CAL : begin
			tx_source = 2'b00;
			if (cal_last) next_state = ST_CRC3;
		end
		ST_CRC3 : begin
			tx_source = 2'b01;
			next_state = ST_CRC2;
		end
		ST_CRC2 : begin
			tx_source = 2'b01;
			next_state = ST_CRC1;
		end
		ST_CRC1 : begin
			tx_source = 2'b01;
			next_state = ST_CRC0;
		end
		ST_CRC0 : begin
			tx_source = 2'b01;
			if (!just_sent_stat & ena_status & cal_zero)
				next_state = ST_PREAMBLE7;
			else
				next_state = ST_CAL;
		end
		ST_PREAMBLE7 : next_state = ST_PREAMBLE6;
		ST_PREAMBLE6 : next_state = ST_PREAMBLE5;
		ST_PREAMBLE5 : next_state = ST_PREAMBLE4;
		ST_PREAMBLE4 : next_state = ST_PREAMBLE3;
		ST_PREAMBLE3 : next_state = ST_PREAMBLE2;
		ST_PREAMBLE2 : next_state = ST_PREAMBLE1;
		ST_PREAMBLE1 : next_state = ST_PREAMBLE0;
		ST_PREAMBLE0 : next_state = ST_STATUS;
		ST_STATUS : begin
			tx_source = 2'b10;
			if (stat_last) next_state = ST_CRC3;
		end
		default : begin
			next_state = state;
			tx_source = 2'b11; // default to sending preamble
		end
	endcase
end

always @(posedge double_fc_clk or posedge double_fc_arst) begin
	if (double_fc_arst) state <= ST_CAL;
	else state <= next_state;
end

endmodule
