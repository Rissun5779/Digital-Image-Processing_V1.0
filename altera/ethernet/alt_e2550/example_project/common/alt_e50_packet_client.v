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

module alt_e50_packet_client #(
	parameter WORDS = 2,
	parameter WIDTH = 64,
	parameter STATUS_ADDR_PREFIX = 6'b0001_00, //0x1000-0x13ff
	parameter SIM_NO_TEMP_SENSE  = 1'b1,
	parameter DEVICE_FAMILY = "Arria 10"
)(
	input arst,
	
	// TX to Ethernet
	input clk_tx,
	output tx_valid,
	input tx_ack,
	output [WIDTH*WORDS-1:0] tx_data,
	output tx_start,
	output tx_end,
	output [3:0] tx_empty,

	input  tx_lanes_stable,

	// RX from Ethernet
	input clk_rx,
	input rx_valid,
	input [WIDTH*WORDS-1:0] rx_data,
	input rx_start,
	input rx_end,
	input [3:0] rx_empty,
	input [5:0] rx_error,

	input rx_block_lock,
	input rx_am_lock,
	input rx_pcs_ready,
	
	// status register bus
	input clk_status,
	input [15:0] status_addr,
	input status_read,
	input status_write,
	input [31:0] status_writedata,
	output reg [31:0] status_readdata,
	output reg status_readdata_valid
	
);

///////////////////////////////////////////////////////////////
// Packet generator
///////////////////////////////////////////////////////////////

reg rst_tx_r;
reg rst_tx_s;
always @(posedge clk_tx) begin
    rst_tx_r <= arst;
    rst_tx_s <= rst_tx_r;
end

wire gen_enable;
avalon_generator pg (
	.clk(clk_tx),
	.data(tx_data),
	.data_valid(tx_valid),
	.empty(tx_empty),
	.enable(gen_enable),
	.eop(tx_end),
	.read_data(tx_ack),
	.sop(tx_start),
	.srst(rst_tx_s)
);

///////////////////////////////////////////////////////////////
// Packet checker
///////////////////////////////////////////////////////////////

//////////////////////////////////////////
// Temperature probe
//////////////////////////////////////////

wire [7:0] degrees_f;

generate
    if (SIM_NO_TEMP_SENSE) begin
        assign degrees_f = 8'd100;
    end
    else if(DEVICE_FAMILY == "Arria 10") begin
        alt_aeuex_a10_temp_sense ts (
            .degrees_c(),
            .degrees_f(degrees_f)
        );
    end
    else begin
        alt_aeuex_temp_sense ts (
            .clk(clk_status), 
            .arst(1'b0),
            .degrees_c(),
            .degrees_f(degrees_f),
            .degrees_f_bcd(),
            .fresh_sample(),
            .failed_sample()
        );
		defparam ts .DEVICE_FAMILY = DEVICE_FAMILY;
    end
endgenerate

////////////////////////////////////////////
// Control port
////////////////////////////////////////////

reg status_addr_sel_r = 0;
reg [5:0] status_addr_r = 0;

reg status_read_r = 0, status_write_r = 0;
reg [31:0] status_writedata_r = 0;
reg [31:0] scratch = 0;
reg [31:0] tx_ctrl = 0;
assign gen_enable = tx_ctrl[0];
wire [31:0] rx_status = {{29{1'b0}}, rx_block_lock, rx_am_lock, rx_pcs_ready};

reg reset_cnt = 1'b0;

reg [31:0] tx_pkt_cnt;
reg reset_tx_cnt_r;
reg reset_tx_cnt_s;
always @(posedge clk_tx) begin
   reset_tx_cnt_r <= reset_cnt;
   reset_tx_cnt_s <= reset_tx_cnt_r;
end

always @(posedge clk_tx) begin
   if (reset_tx_cnt_s) begin
      tx_pkt_cnt <= 'h0;
   end else if (tx_valid & tx_end & tx_ack) begin
      tx_pkt_cnt <= tx_pkt_cnt + 32'h1;
   end
end

reg [31:0] rx_pkt_cnt;
reg [31:0] rx_err_cnt;

reg reset_rx_cnt_r;
reg reset_rx_cnt_s;
always @(posedge clk_rx) begin
   reset_rx_cnt_r <= reset_cnt;
   reset_rx_cnt_s <= reset_rx_cnt_r;
end

always @(posedge clk_rx) begin
   if (reset_rx_cnt_s) begin
      rx_pkt_cnt <= 'h0;
   end else if (rx_valid & rx_end) begin
      rx_pkt_cnt <= rx_pkt_cnt + 32'h1;
   end
end

always @(posedge clk_rx) begin
   if (reset_rx_cnt_s) begin
      rx_err_cnt <= 'h0;
   end else if (rx_valid & rx_end & rx_error[1]) begin
      rx_err_cnt <= rx_err_cnt + 32'h1;
   end
end

initial status_readdata = 0;
initial status_readdata_valid = 0;

always @(posedge clk_status) begin
	status_addr_r <= status_addr[5:0];
	status_addr_sel_r <= (status_addr[15:6] == {STATUS_ADDR_PREFIX[5:0], 4'b0});
	
	status_read_r <= status_read;
	status_write_r <= status_write;
	status_writedata_r <= status_writedata;	
	status_readdata_valid <= 1'b0;

	if (status_read_r) begin
		if (status_addr_sel_r) begin
			status_readdata_valid <= 1'b1;
			case (status_addr_r)
				6'h0 : status_readdata <= scratch;
				6'h1 : status_readdata <= "CLNT";
                6'h2 : status_readdata <= tx_ctrl;
                6'h3 : status_readdata <= rx_status;
                6'h4 : status_readdata <= tx_pkt_cnt;
                6'h5 : status_readdata <= rx_pkt_cnt;
                6'h6 : status_readdata <= rx_err_cnt;
                6'h7 : status_readdata <= {{31{1'b0}}, reset_cnt};
                //6'h7 : status_readdata <= {24'h0, degrees_f};
				default : status_readdata <= 32'h123;
			endcase		
		end
		else begin
			// this read is not for my address prefix - ignore it.
		end
	end	
	
	if (status_write_r) begin
		if (status_addr_sel_r) begin
			case (status_addr_r)
				6'h0 : scratch <= status_writedata_r;						
				6'h2 : tx_ctrl <= status_writedata_r;						
				6'h7 : reset_cnt <= status_writedata_r[0];						
			endcase
		end
	end				
end

endmodule
