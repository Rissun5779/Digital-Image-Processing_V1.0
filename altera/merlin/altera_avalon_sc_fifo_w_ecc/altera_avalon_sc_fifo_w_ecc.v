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


// -----------------------------------------------------------
// Legal Notice: (C)2007 Altera Corporation. All rights reserved.  Your
// use of Altera Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions, and any
// output files any of the foregoing (including device programming or
// simulation files), and any associated documentation or information are
// expressly subject to the terms and conditions of the Altera Program
// License Subscription Agreement or other applicable license agreement,
// including, without limitation, that your use is for the sole purpose
// of programming logic devices manufactured by Altera and sold by Altera
// or its authorized distributors.  Please refer to the applicable
// agreement for further details.
//
// Description: Single clock Avalon-ST FIFO.
// -----------------------------------------------------------

`timescale 1 ns / 1 ns

//altera message_off 10036
module altera_avalon_sc_fifo_w_ecc
#(
    // --------------------------------------------------
    // Parameters
    // --------------------------------------------------
    parameter SYMBOLS_PER_BEAT  = 1,
    parameter BITS_PER_SYMBOL   = 8,
    parameter FIFO_DEPTH        = 16,
    parameter CHANNEL_WIDTH     = 0,
    parameter ERROR_WIDTH       = 0,
    parameter USE_PACKETS       = 0,
    parameter USE_FILL_LEVEL    = 0,
    parameter USE_STORE_FORWARD = 0,
    parameter USE_ALMOST_FULL_IF = 0,
    parameter USE_ALMOST_EMPTY_IF = 0,

    // --------------------------------------------------
    // Empty latency is defined as the number of cycles
    // required for a write to deassert the empty flag.
    // For example, a latency of 1 means that the empty
    // flag is deasserted on the cycle after a write.
    //
    // Another way to think of it is the latency for a
    // write to propagate to the output. 
    // 
    // An empty latency of 0 implies lookahead, which is
    // only implemented for the register-based FIFO.
    // --------------------------------------------------
    parameter EMPTY_LATENCY     = 3,
    parameter USE_MEMORY_BLOCKS = 1,
    //--------------------------------------------------
    // Parameters for ECC protection to enable ECC 
    // encoding/decoding soft logic or enable in M20Ks 
    // for SV, A10 device families
    //--------------------------------------------------
    parameter ECC_ENABLE = 0,

    // --------------------------------------------------
    // Internal Parameters
    // --------------------------------------------------
    parameter DATA_WIDTH  = SYMBOLS_PER_BEAT * BITS_PER_SYMBOL,
    parameter EMPTY_WIDTH = log2ceil(SYMBOLS_PER_BEAT)
)
(
    // --------------------------------------------------
    // Ports
    // --------------------------------------------------
    input                       clk,
    input                       reset,

    input [DATA_WIDTH-1: 0]     in_data,
    input                       in_valid,
    input                       in_startofpacket,
    input                       in_endofpacket,
    input [((EMPTY_WIDTH>0) ? (EMPTY_WIDTH-1):0) : 0]     in_empty,
    input [((ERROR_WIDTH>0) ? (ERROR_WIDTH-1):0) : 0]     in_error,
    input [((CHANNEL_WIDTH>0) ? (CHANNEL_WIDTH-1):0): 0]  in_channel,
    output                      in_ready,

    output [DATA_WIDTH-1 : 0]   out_data,
    output                      out_valid,
    output                      out_startofpacket,
    output                      out_endofpacket,
    output [((EMPTY_WIDTH>0) ? (EMPTY_WIDTH-1):0) : 0]    out_empty,
    output [((ERROR_WIDTH>0) ? (ERROR_WIDTH-1):0) : 0]    out_error,
    output [((CHANNEL_WIDTH>0) ? (CHANNEL_WIDTH-1):0): 0] out_channel,
    input                       out_ready,

    input [(USE_STORE_FORWARD ? 2 : 1) : 0]   csr_address,
    input                       csr_write,
    input                       csr_read,
    input  [31 : 0]             csr_writedata,
    output [31 : 0]             csr_readdata,

    output  wire                almost_full_data,
    output  wire                almost_empty_data
);

  // Local Parameters (Condense to reduce redundant logic)
  localparam NUM_ECC = (DATA_WIDTH%32 > 0 )? DATA_WIDTH/32 +1  : DATA_WIDTH/32 ;
  localparam D_WIDTH = (ECC_ENABLE) ? (NUM_ECC * 39) : DATA_WIDTH;	

  // Wire Instances 
  wire [D_WIDTH-1 :0] snk_fifo_data, src_fifo_data;
  wire ecc_error; 

  // ECC generate Block Instances
  generate if (ECC_ENABLE) begin : ecc_on

    altera_avalon_ecc_encoder #(
      .DATA_WIDTH(DATA_WIDTH)
    ) ecc_enc (
      .in_data(in_data), 
      .out_data(snk_fifo_data)
    );

    altera_avalon_ecc_decoder #(
      .DATA_WIDTH(DATA_WIDTH)
    ) ecc_dec (
      .in_data(src_fifo_data),
      .out_data(out_data), 
      .ecc_error(ecc_error)
    );

  end else begin : ecc_off
    assign snk_fifo_data = in_data;
    assign out_data = src_fifo_data;
    assign ecc_error = 1'b0;
  end 
  endgenerate
  
  // For ECC Error Status
  wire [ ((ERROR_WIDTH>0) ?  (ERROR_WIDTH-1) : 0 ) :0 ] out_error_fifo;
  generate if (ERROR_WIDTH > 2) begin
    assign out_error[ERROR_WIDTH -1] = out_error_fifo[ERROR_WIDTH-1] | ecc_error;
    assign out_error[ERROR_WIDTH -2 : 0] = out_error_fifo[ERROR_WIDTH-2 :0];
  end else begin 
    assign out_error = out_error_fifo[0] | ecc_error;
  end 
  endgenerate

  altera_avalon_sc_fifo
  #(
    .SYMBOLS_PER_BEAT    (SYMBOLS_PER_BEAT),
    .BITS_PER_SYMBOL     (BITS_PER_SYMBOL), 
    .FIFO_DEPTH          (FIFO_DEPTH),
    .DATA_WIDTH          (D_WIDTH),
    .CHANNEL_WIDTH       (CHANNEL_WIDTH),
    .ERROR_WIDTH         (ERROR_WIDTH),
    .USE_PACKETS         (USE_PACKETS),
    .USE_FILL_LEVEL      (USE_FILL_LEVEL),
    .USE_STORE_FORWARD   (USE_STORE_FORWARD),
    .USE_ALMOST_FULL_IF  (USE_ALMOST_FULL_IF),
    .USE_ALMOST_EMPTY_IF (USE_ALMOST_EMPTY_IF),
    .EMPTY_LATENCY       (EMPTY_LATENCY),
    .USE_MEMORY_BLOCKS   (USE_MEMORY_BLOCKS),
    .EMPTY_WIDTH         (EMPTY_WIDTH)
  ) scfifo (
    .clk             (clk),
    .reset           (reset),
    .in_data         (snk_fifo_data),
    .in_valid        (in_valid),
    .in_ready        (in_ready),     
    .out_data        (src_fifo_data),
    .out_valid       (out_valid),
    .out_ready       (out_ready),
    .csr_address     (csr_address),                     
    .csr_read        (csr_read),                         
    .csr_write       (csr_write),                        
    .csr_readdata     (csr_readdata),                            
    .csr_writedata    (csr_writedata), 
    .almost_full_data (almost_full_data),                          
    .almost_empty_data (almost_empty_data),                          
    .in_startofpacket  (in_startofpacket),                         
    .in_endofpacket    (in_endofpacket),                         
    .out_startofpacket (out_startofpacket),                           
    .out_endofpacket   (out_endofpacket),                           
    .in_empty          (in_empty),                         
    .out_empty         (out_empty),                           
    .in_error        (in_error),  
    .out_error       (out_error_fifo),                       
    .in_channel      (in_channel),                         
    .out_channel      (out_channel)                             
  );

    // --------------------------------------------------
    // Calculates the log2ceil of the input value
    // --------------------------------------------------
    function integer log2ceil;
        input integer val;
        reg[31:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i[30:0] << 1;
            end
        end
    endfunction

endmodule
