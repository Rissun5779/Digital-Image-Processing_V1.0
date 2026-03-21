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


// (C) 2001-2016 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// Shut off MOSI output IO buffer in the last 8 bits of read transaction
// Instantiates Altera GPIO megafunction

module spi_mosi_oe (
   input  wire          spi_clk,
   input  wire          mgmt_clk,
   input  wire          rst,
   input  wire          spi_mosi_buf,
   output wire          spi_mosi
);

   parameter SPI_WIDTH = 24;     // number of serial bits in each transaction = number of spi_clk

   wire        mosi_msb;
   wire        oe;
   reg  [4:0]  cnt_negedge;
   reg  [4:0]  cnt_posedge;
   reg         read_en;

	assign mosi_msb = (cnt_posedge == 5'h1)? spi_mosi_buf : 1'b0;
   assign oe = (read_en && (cnt_negedge >= SPI_WIDTH - 5'h8))? 1'b0 : 1'b1;  //last 8 bits are data from SPI slave
	
	always @(negedge spi_clk or posedge rst) begin
	   if (rst) begin
	      cnt_negedge <= 5'h0;
	   end else begin
	      cnt_negedge <= cnt_negedge + 5'h1;
		end
	end

	always @(posedge spi_clk or posedge rst) begin
	   if (rst)
	      cnt_posedge <= 5'h0;
	   else
	      cnt_posedge <= cnt_posedge + 5'h1;
	end
	
	always @(negedge spi_clk or posedge rst) begin
	   if (rst)
	      read_en <= 1'b0;
	   else if (mosi_msb == 1'b1)
		   read_en <= 1'b1;
		else
		   read_en <= read_en;
	end

	//Altera GPIO megafunction - Output IO buffer 
	se_outbuf_1bit u_spi_mosi (
	   .din            (spi_mosi_buf),
	   .oe             (oe),           //output buffer enable
		.pad_out        (spi_mosi)
	);
	
endmodule 
