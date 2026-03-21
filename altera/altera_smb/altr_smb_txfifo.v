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


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module altr_smb_txfifo #(
    parameter DEVICE_FAMILY	= "CYCLONE V",
    parameter MEMORY_TYPE	= "RAM_BLOCK_TYPE=MLAB"
)(
    input           	clk,
    input           	rst_n,
    input wire		wr_to_txfifo,
    input wire [8:0]	wrdata_to_txfifo,
    input wire		rd_from_txfifo,
    input wire          sclr,
    output wire		txfifo_empty,
    output wire		txfifo_full,
    output wire [8:0]	rddata_from_txfifo

);
    
reg [8:0]   tx_data_reg;
reg	    txfifo_full_reg;
			
assign rddata_from_txfifo   = (rd_from_txfifo && ~txfifo_empty) ? tx_data_reg : {9{1'b0}};
assign txfifo_full          = txfifo_full_reg;
assign txfifo_empty         = ~txfifo_full;
			
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
	tx_data_reg     <= {9{1'b0}};
    end
    else begin
        if (sclr) begin
	    tx_data_reg	<= {9{1'b0}};
	end
	else if (wr_to_txfifo && ~txfifo_full) begin
	    tx_data_reg	<= wrdata_to_txfifo;
	end
    end
end
			
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        txfifo_full_reg	<= 1'b0;
    end
    else begin
        if (sclr) begin
	    txfifo_full_reg	<= 1'b0;
        end
        else if (wr_to_txfifo) begin
	    txfifo_full_reg	<= 1'b1;
        end
        else if (rd_from_txfifo) begin
	    txfifo_full_reg	<= 1'b0;
        end
    end
end
	
endmodule
