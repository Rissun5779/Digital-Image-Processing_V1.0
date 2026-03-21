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
module altr_smb_rxfifo #(
	parameter SMB_PEC_EN	= 1,
	parameter DEVICE_FAMILY	= "CYCLONE V",
	parameter MEMORY_TYPE	= "RAM_BLOCK_TYPE=MLAB"
)(
    input           		clk,
    input           		rst_n,
	input	wire			wr_to_rxfifo,
	input	wire	[7:0]	wrdata_to_rxfifo,
	input	wire			rd_from_rxfifo,
    input   wire            sclr,
	output	wire 			rxfifo_empty,
	output	wire 			rxfifo_full,
	output	wire	[7:0]	rddata_from_rxfifo
	

);
	reg [7:0] rx_data_reg;
	reg		  rxfifo_full_reg;
	
	assign rddata_from_rxfifo = (rd_from_rxfifo && ~rxfifo_empty) ? rx_data_reg : {8{1'b0}};
	assign rxfifo_full  = rxfifo_full_reg;
	assign rxfifo_empty = ~rxfifo_full;
	
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			rx_data_reg		<= {8{1'b0}};
		end
		else begin
			if (sclr) begin
				rx_data_reg		<= {8{1'b0}};
			end
			else if (wr_to_rxfifo && ~rxfifo_full) begin
				rx_data_reg		<= wrdata_to_rxfifo;
			end
		end
	end
	
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			rxfifo_full_reg	<= 1'b0;
		end
		else begin
                        if (sclr) begin
				rxfifo_full_reg		<= 1'b0;
                        end
			else if (wr_to_rxfifo && ~rxfifo_full) begin
				rxfifo_full_reg		<= 1'b1;
			end
			else if (rd_from_rxfifo) begin
				rxfifo_full_reg		<= 1'b0;
			end
		end
	end
	
	/*	comment out sc fifo because we are implementing with register for now
	altr_smb_sc_fifo #(
		.DEVICE_FAMILY	(DEVICE_FAMILY),
		.MEMORY_TYPE	(MEMORY_TYPE),
		.DEPTH		  	(8),
		.WIDTH		  	(8),
		.WIDTHU			(3)
	) fifo (
		.clock	(clk),
		.data	(wrdata_to_rxfifo),
		.rdreq	(rd_from_rxfifo && ~rxfifo_empty),		
		.wrreq	(wr_to_rxfifo && ~rxfifo_full),		
                .sclr   (sclr),
		.empty	(rxfifo_empty),				                            
		.full	(rxfifo_full),
		.q		(rddata_from_rxfifo)
	);
	*/
	
endmodule
