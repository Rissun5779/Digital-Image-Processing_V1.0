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


// (C) 32'hFFFF_FFFF01-32'hFFFF_FFFF13 Altera Corporation. All rights reserved.
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

// $Revision: #1 $
// $Date: 05/22/2013
// $Author: Viet Nga Dao $

module altera_eth_fifo(
    
    in_clk, //dc fifo
    in_reset_n, // dc fifo

	 xgmii_clk,
	 xgmii_clk_reset_n,
    // sink
    in_data,
    in_valid,
    in_ready,
    in_startofpacket,
    in_endofpacket,
    in_empty,
    in_error,
    in_channel,

    // source
    out_data,
    out_valid,
    out_ready,
    out_startofpacket,
    out_endofpacket,
    out_empty,
    out_error,
    out_channel,

    // in csr
    in_csr_address,
    in_csr_write,
    in_csr_read,
    in_csr_readdata,
    in_csr_writedata,

    // out csr
    out_csr_address,
    out_csr_write,
    out_csr_read,
    out_csr_readdata,
    out_csr_writedata,

    // streaming in status
    almost_full_valid, // dc fifo
    almost_full_data,

    // streaming out status
    almost_empty_valid,
    almost_empty_data, //dc fifo

    //dc fifo (internal, experimental interface) space available st source
    space_avail_data

);
   parameter FIFO_OPTIONS  = 1;    // 1-SC FIFO, 2- DC FIFO, 3- SC-DC FIFO
   parameter TX_RX_FIFO     =0;    //0 - TX, 1-RX  which only useful for option SC-DC FIFO
	 parameter SYMBOLS_PER_BEAT  = 1;
    parameter BITS_PER_SYMBOL   = 8;

    parameter CHANNEL_WIDTH     = 0;
    parameter ERROR_WIDTH       = 1;
    parameter USE_PACKETS       = 1;

	 // ---------------------------------------------------------------------
    // SC FIFO Parameters
    // ---------------------------------------------------------------------
   
    parameter SC_FIFO_DEPTH        = 16;
    parameter SC_USE_FILL_LEVEL    = 0;
    parameter SC_USE_STORE_FORWARD = 0;
    parameter SC_USE_ALMOST_FULL_IF = 0;
    parameter SC_USE_ALMOST_EMPTY_IF = 0;
	
    parameter SC_EMPTY_LATENCY     = 3;
    parameter SC_USE_MEMORY_BLOCKS = 1;


   // ---------------------------------------------------------------------
    // DC FIFO Parameters

    parameter DC_FIFO_DEPTH        = 16;
    parameter DC_USE_IN_FILL_LEVEL   = 0;
    parameter DC_USE_OUT_FILL_LEVEL  = 0;
    parameter DC_WR_SYNC_DEPTH       = 2;
    parameter DC_RD_SYNC_DEPTH       = 2;
    parameter DC_STREAM_ALMOST_FULL  = 0;
    parameter DC_STREAM_ALMOST_EMPTY = 0;
	
    // experimental, internal parameter
    parameter DC_USE_SPACE_AVAIL_IF  = 0;

    
	 localparam DATA_WIDTH  = SYMBOLS_PER_BEAT * BITS_PER_SYMBOL;
    localparam EMPTY_WIDTH = log2ceil(SYMBOLS_PER_BEAT);
	 localparam ADDR_WIDTH   = log2ceil(DC_FIFO_DEPTH);
	 // ---------------------------------------------------------------------
    // Input/Output Signals
    // ---------------------------------------------------------------------
    
	 	 input in_clk;
		 input in_reset_n;
	 
    input xgmii_clk;
    input xgmii_clk_reset_n;

    input [DATA_WIDTH - 1 : 0] in_data;
    input in_valid;
    input in_startofpacket;
    input in_endofpacket;
    input [EMPTY_WIDTH - 1 : 0] in_empty;
    input [ERROR_WIDTH - 1 : 0] in_error;
    input [CHANNEL_WIDTH - 1: 0] in_channel;
    output in_ready;

    output [DATA_WIDTH - 1 : 0] out_data;
    output out_valid;
    output out_startofpacket;
    output out_endofpacket;
    output [EMPTY_WIDTH - 1 : 0] out_empty;
    output [ERROR_WIDTH - 1 : 0] out_error;
    output [CHANNEL_WIDTH - 1: 0] out_channel;
    input out_ready;

    input in_csr_address;
    input in_csr_read;
    input in_csr_write;
    input [31 : 0] in_csr_writedata;
    output [31 : 0] in_csr_readdata;

    input [2:0] out_csr_address;
    input out_csr_read;
    input out_csr_write;
    input [31 : 0] out_csr_writedata;
    output [31 : 0] out_csr_readdata;

    output almost_full_valid;
    output almost_full_data;
    output almost_empty_valid;
    output almost_empty_data;

    output [ADDR_WIDTH : 0] space_avail_data;
	 
	 
	 
	 wire  [DATA_WIDTH - 1 : 0] out_data_dc;
    wire out_valid_dc;
    wire out_startofpacket_dc;
    wire out_endofpacket_dc;
    wire [EMPTY_WIDTH - 1 : 0] out_empty_dc;
    wire [ERROR_WIDTH - 1 : 0] out_error_dc;
    wire [CHANNEL_WIDTH - 1: 0] out_channel_dc;
    wire out_ready_dc;
	 
	 wire  [DATA_WIDTH - 1 : 0] out_data_sc;
    wire out_valid_sc;
    wire out_startofpacket_sc;
    wire out_endofpacket_sc;
    wire [EMPTY_WIDTH - 1 : 0] out_empty_sc;
    wire [ERROR_WIDTH - 1 : 0] out_error_sc;
    wire [CHANNEL_WIDTH - 1: 0] out_channel_sc;
    wire out_ready_sc;
	 
	 
	 generate 
	 
     if (FIFO_OPTIONS == 1) begin
    
	 altera_avalon_sc_fifo #(
  
    .SYMBOLS_PER_BEAT (SYMBOLS_PER_BEAT)  ,
    .BITS_PER_SYMBOL (BITS_PER_SYMBOL)    ,
    .FIFO_DEPTH      (SC_FIFO_DEPTH)   ,
    .CHANNEL_WIDTH   (CHANNEL_WIDTH)  ,
    .ERROR_WIDTH     (ERROR_WIDTH)   ,
    .USE_PACKETS     (USE_PACKETS)   ,
    .USE_FILL_LEVEL  (SC_USE_FILL_LEVEL)   ,
    .USE_STORE_FORWARD (SC_USE_STORE_FORWARD) ,
    .USE_ALMOST_FULL_IF (SC_USE_ALMOST_FULL_IF) ,
    .USE_ALMOST_EMPTY_IF (SC_USE_ALMOST_EMPTY_IF) ,
    .EMPTY_LATENCY   (SC_EMPTY_LATENCY)  ,
    .USE_MEMORY_BLOCKS (SC_USE_MEMORY_BLOCKS)

  
  ) altera_avalon_sc_fifo_inst (
    .clk		(xgmii_clk),
    .reset	(~xgmii_clk_reset_n),


    // sink
    .in_data		(in_data),
    .in_valid		(in_valid),
    .in_ready		(in_ready),
    .in_startofpacket(in_startofpacket),
    .in_endofpacket(in_endofpacket),
    .in_empty(in_empty),
    .in_error(in_error),
    .in_channel(in_channel),

    // source
    .out_data(out_data),
    .out_valid(out_valid),
    .out_ready(out_ready),
    .out_startofpacket(out_startofpacket),
    .out_endofpacket(out_endofpacket),
    .out_empty(out_empty),
    .out_error(out_error),
    .out_channel(out_channel),


    // out csr
    .csr_address(out_csr_address),
    .csr_write(out_csr_write),
    .csr_read(out_csr_read),
    .csr_readdata(out_csr_readdata),
    .csr_writedata(out_csr_writedata),

    // streaming in status
    .almost_full_data(almost_full_data),

    // streaming out status

    .almost_empty_data(almost_empty_data)


	 
	 );
		 
	 end
	 
	 
	 else if (FIFO_OPTIONS == 2) begin
	  
	 altera_avalon_dc_fifo #(
  
    .SYMBOLS_PER_BEAT (SYMBOLS_PER_BEAT)  ,
    .BITS_PER_SYMBOL (BITS_PER_SYMBOL)    ,
    .FIFO_DEPTH      (DC_FIFO_DEPTH)   ,
    .CHANNEL_WIDTH   (CHANNEL_WIDTH)  ,
    .ERROR_WIDTH     (ERROR_WIDTH)   ,
    .USE_PACKETS     (USE_PACKETS)   ,
   
	 .USE_IN_FILL_LEVEL  (DC_USE_IN_FILL_LEVEL)   ,
	 .USE_OUT_FILL_LEVEL  (DC_USE_OUT_FILL_LEVEL)   ,
    .WR_SYNC_DEPTH (DC_WR_SYNC_DEPTH) ,
    .RD_SYNC_DEPTH (DC_RD_SYNC_DEPTH) ,
    .STREAM_ALMOST_FULL   (DC_STREAM_ALMOST_FULL)  ,
    .STREAM_ALMOST_EMPTY (DC_STREAM_ALMOST_EMPTY),
	 .USE_SPACE_AVAIL_IF  (DC_USE_SPACE_AVAIL_IF)   
  ) altera_avalon_dc_fifo_inst (	 
	 .in_clk			(in_clk),
    .in_reset_n	(in_reset_n),

    .out_clk		(xgmii_clk),
    .out_reset_n	(xgmii_clk_reset_n),

    // sink
    .in_data		(in_data),
    .in_valid		(in_valid),
    .in_ready		(in_ready),
    .in_startofpacket(in_startofpacket),
    .in_endofpacket(in_endofpacket),
    .in_empty(in_empty),
    .in_error(in_error),
    .in_channel(in_channel),

    // source
    .out_data(out_data),
    .out_valid(out_valid),
    .out_ready(out_ready),
    .out_startofpacket(out_startofpacket),
    .out_endofpacket(out_endofpacket),
    .out_empty(out_empty),
    .out_error(out_error),
    .out_channel(out_channel),

    // in csr
    .in_csr_address(in_csr_address),
    .in_csr_write(in_csr_write),
    .in_csr_read(in_csr_read),
    .in_csr_readdata(in_csr_readdata),
    .in_csr_writedata(in_csr_writedata),
	 
    // out csr
    .out_csr_address(out_csr_address[0]),
    .out_csr_write(out_csr_write),
    .out_csr_read(out_csr_read),
    .out_csr_readdata(out_csr_readdata),
    .out_csr_writedata(out_csr_writedata),

    // streaming in status
    .almost_full_valid(almost_full_valid),
    .almost_full_data(almost_full_data),

    // streaming out status
    .almost_empty_valid(almost_empty_valid),
    .almost_empty_data(almost_empty_data),

    // (internal, experimental interface) space available st source
    .space_avail_data(space_avail_data)
	 );
		 
	 end
	 
	 	 
	else if (FIFO_OPTIONS == 3 & TX_RX_FIFO == 0) begin

	 altera_avalon_dc_fifo #(
  
    .SYMBOLS_PER_BEAT (SYMBOLS_PER_BEAT)  ,
    .BITS_PER_SYMBOL (BITS_PER_SYMBOL)    ,
    .FIFO_DEPTH      (DC_FIFO_DEPTH)   ,
    .CHANNEL_WIDTH   (CHANNEL_WIDTH)  ,
    .ERROR_WIDTH     (ERROR_WIDTH)   ,
    .USE_PACKETS     (USE_PACKETS)   ,   
	 .USE_IN_FILL_LEVEL  (DC_USE_IN_FILL_LEVEL)   ,
	 .USE_OUT_FILL_LEVEL  (DC_USE_OUT_FILL_LEVEL)   ,
    .WR_SYNC_DEPTH (DC_WR_SYNC_DEPTH) ,
    .RD_SYNC_DEPTH (DC_RD_SYNC_DEPTH) ,
    .STREAM_ALMOST_FULL   (DC_STREAM_ALMOST_FULL)  ,
    .STREAM_ALMOST_EMPTY (DC_STREAM_ALMOST_EMPTY),
	 .USE_SPACE_AVAIL_IF  (DC_USE_SPACE_AVAIL_IF)  
  ) altera_avalon_dc_fifo_inst (	 
	 .in_clk			(in_clk),
    .in_reset_n	(in_reset_n),

    .out_clk		(xgmii_clk),
    .out_reset_n	(xgmii_clk_reset_n),

    // sink
    .in_data		(in_data),
    .in_valid		(in_valid),
    .in_ready		(in_ready),
    .in_startofpacket(in_startofpacket),
    .in_endofpacket(in_endofpacket),
    .in_empty(in_empty),
    .in_error(in_error),
    .in_channel(in_channel),

    // source
    .out_data(out_data_dc),
    .out_valid(out_valid_dc),
    .out_ready(out_ready_dc),
    .out_startofpacket(out_startofpacket_dc),
    .out_endofpacket(out_endofpacket_dc),
    .out_empty(out_empty_dc),
    .out_error(out_error_dc),
    .out_channel(out_channel_dc),

    // in csr
    .in_csr_address(in_csr_address),
    .in_csr_write(in_csr_write),
    .in_csr_read(in_csr_read),
    .in_csr_readdata(in_csr_readdata),
    .in_csr_writedata(in_csr_writedata),
	 
    // out csr
    .out_csr_address(),
    .out_csr_write(),
    .out_csr_read(),
    .out_csr_readdata(),
    .out_csr_writedata(),

    // streaming in status
    .almost_full_valid(almost_full_valid),
    .almost_full_data(almost_full_data),

    // streaming out status
    .almost_empty_valid(almost_empty_valid),
    .almost_empty_data(almost_empty_data),

    // (internal, experimental interface) space available st source
    .space_avail_data(space_avail_data)
	 );
	 
	 
	 altera_avalon_sc_fifo #(
  
    .SYMBOLS_PER_BEAT (SYMBOLS_PER_BEAT)  ,
    .BITS_PER_SYMBOL (BITS_PER_SYMBOL)    ,
    .FIFO_DEPTH      (SC_FIFO_DEPTH)   ,
    .CHANNEL_WIDTH   (CHANNEL_WIDTH)  ,
    .ERROR_WIDTH     (ERROR_WIDTH)   ,
    .USE_PACKETS     (USE_PACKETS)   ,
    .USE_FILL_LEVEL  (SC_USE_FILL_LEVEL)   ,
    .USE_STORE_FORWARD (SC_USE_STORE_FORWARD) ,
    .USE_ALMOST_FULL_IF (SC_USE_ALMOST_FULL_IF) ,
    .USE_ALMOST_EMPTY_IF (SC_USE_ALMOST_EMPTY_IF) ,
    .EMPTY_LATENCY   (SC_EMPTY_LATENCY)  ,
    .USE_MEMORY_BLOCKS (SC_USE_MEMORY_BLOCKS)
  ) altera_avalon_sc_fifo_inst (
   
	.clk		(xgmii_clk),
    .reset	(~xgmii_clk_reset_n),

    // sink
    .in_data		(out_data_dc),
    .in_valid		(out_valid_dc),
    .in_ready		(out_ready_dc),
    .in_startofpacket(out_startofpacket_dc),
    .in_endofpacket(out_endofpacket_dc),
    .in_empty(out_empty_dc),
    .in_error(out_error_dc),
    .in_channel(out_channel_dc),

    // source
    .out_data(out_data),
    .out_valid(out_valid),
    .out_ready(out_ready),
    .out_startofpacket(out_startofpacket),
    .out_endofpacket(out_endofpacket),
    .out_empty(out_empty),
    .out_error(out_error),
    .out_channel(out_channel),


    // out csr
    .csr_address(out_csr_address),
    .csr_write(out_csr_write),
    .csr_read(out_csr_read),
    .csr_readdata(out_csr_readdata),
    .csr_writedata(out_csr_writedata),

    // streaming in status
    .almost_full_data(almost_full_data),

    // streaming out status

    .almost_empty_data(almost_empty_data)


	 
	 );
		 
		 
	 end
	 
  else if (FIFO_OPTIONS == 3 & TX_RX_FIFO == 1) begin

	 altera_avalon_dc_fifo #(
  
    .SYMBOLS_PER_BEAT (SYMBOLS_PER_BEAT)  ,
    .BITS_PER_SYMBOL (BITS_PER_SYMBOL)    ,
    .FIFO_DEPTH      (DC_FIFO_DEPTH)   ,
    .CHANNEL_WIDTH   (CHANNEL_WIDTH)  ,
    .ERROR_WIDTH     (ERROR_WIDTH)   ,
    .USE_PACKETS     (USE_PACKETS)   ,   
	 .USE_IN_FILL_LEVEL  (DC_USE_IN_FILL_LEVEL)   ,
	 .USE_OUT_FILL_LEVEL  (DC_USE_OUT_FILL_LEVEL)   ,
    .WR_SYNC_DEPTH (DC_WR_SYNC_DEPTH) ,
    .RD_SYNC_DEPTH (DC_RD_SYNC_DEPTH) ,
    .STREAM_ALMOST_FULL   (DC_STREAM_ALMOST_FULL)  ,
    .STREAM_ALMOST_EMPTY (DC_STREAM_ALMOST_EMPTY),
	 .USE_SPACE_AVAIL_IF  (DC_USE_SPACE_AVAIL_IF)  
  ) altera_avalon_dc_fifo_inst (	 
	 .in_clk			(in_clk),
    .in_reset_n	(in_reset_n),

    .out_clk		(xgmii_clk),
    .out_reset_n	(xgmii_clk_reset_n),

    // sink
    .in_data		(out_data_sc),
    .in_valid		(out_valid_sc),
    .in_ready		(out_ready_sc),
    .in_startofpacket(out_startofpacket_sc),
    .in_endofpacket(out_endofpacket_sc),
    .in_empty(out_empty_sc),
    .in_error(out_error_sc),
    .in_channel(out_channel_sc),

    // source
    .out_data(out_data),
    .out_valid(out_valid),
    .out_ready(out_ready),
    .out_startofpacket(out_startofpacket),
    .out_endofpacket(out_endofpacket),
    .out_empty(out_empty),
    .out_error(out_error),
    .out_channel(out_channel),

    // in csr
    .in_csr_address(in_csr_address),
    .in_csr_write(in_csr_write),
    .in_csr_read(in_csr_read),
    .in_csr_readdata(in_csr_readdata),
    .in_csr_writedata(in_csr_writedata),
	 
    // out csr
    .out_csr_address(),
    .out_csr_write(),
    .out_csr_read(),
    .out_csr_readdata(),
    .out_csr_writedata(),

    // streaming in status
    .almost_full_valid(almost_full_valid),
    .almost_full_data(almost_full_data),

    // streaming out status
    .almost_empty_valid(almost_empty_valid),
    .almost_empty_data(almost_empty_data),

    // (internal, experimental interface) space available st source
    .space_avail_data(space_avail_data)
	 );
	 
	 
	 altera_avalon_sc_fifo #(
  
    .SYMBOLS_PER_BEAT (SYMBOLS_PER_BEAT)  ,
    .BITS_PER_SYMBOL (BITS_PER_SYMBOL)    ,
    .FIFO_DEPTH      (SC_FIFO_DEPTH)   ,
    .CHANNEL_WIDTH   (CHANNEL_WIDTH)  ,
    .ERROR_WIDTH     (ERROR_WIDTH)   ,
    .USE_PACKETS     (USE_PACKETS)   ,
    .USE_FILL_LEVEL  (SC_USE_FILL_LEVEL)   ,
    .USE_STORE_FORWARD (SC_USE_STORE_FORWARD) ,
    .USE_ALMOST_FULL_IF (SC_USE_ALMOST_FULL_IF) ,
    .USE_ALMOST_EMPTY_IF (SC_USE_ALMOST_EMPTY_IF) ,
    .EMPTY_LATENCY   (SC_EMPTY_LATENCY)  ,
    .USE_MEMORY_BLOCKS (SC_USE_MEMORY_BLOCKS)
  ) altera_avalon_sc_fifo_inst (
   
	.clk		(xgmii_clk),
    .reset	(~xgmii_clk_reset_n),

    // sink
    .in_data		(in_data),
    .in_valid		(in_valid),
    .in_ready		(in_ready),
    .in_startofpacket(in_startofpacket),
    .in_endofpacket(in_endofpacket),
    .in_empty(in_empty),
    .in_error(in_error),
    .in_channel(in_channel),

    // source
    .out_data(out_data_sc),
    .out_valid(out_valid_sc),
    .out_ready(out_ready_sc),
    .out_startofpacket(out_startofpacket_sc),
    .out_endofpacket(out_endofpacket_sc),
    .out_empty(out_empty_sc),
    .out_error(out_error_sc),
    .out_channel(out_channel_sc),


    // out csr
    .csr_address(out_csr_address),
    .csr_write(out_csr_write),
    .csr_read(out_csr_read),
    .csr_readdata(out_csr_readdata),
    .csr_writedata(out_csr_writedata),

    // streaming in status
    .almost_full_data(almost_full_data),

    // streaming out status

    .almost_empty_data(almost_empty_data)


	 
	 );
		 
		 
	 end 
	 
	 
	 endgenerate

	


	 
	 
	  // --------------------------------------------------
    // Calculates the log2ceil of the input value
    // --------------------------------------------------
    function integer log2ceil;
        input integer val;
        integer i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction
	 
	 
endmodule
