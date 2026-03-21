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

module altpcieav_fifo_mode
  # (
  parameter TXS_MODE = 0,      // 0 = Regular mode, 1 = Txs slave port
  parameter DMA_WIDTH = 256,   // Supported modes: 128-bit, 256-bit
  parameter DMA_BRST_CNT_W = 5, // 6 for 128-bit, 5 for 256-bit
  parameter DMA_BE_WIDTH = 32,  // 16 bytes for 128-bit, 32 bytes for 256-bit
  parameter RXDATA_WIDTH = 160 // Usually 160 bits, but may be extended to 168 to support SR-IOV function fields
  )
  (
  // Clock and reset
  input Clk_i,
  input Rstn_i,

  // ---------------------------------------------------------
  // Avalon-MM Slaves (Interface with DMA Masters)

  // DMA Write FIFO slave
  input                       avmm_wr_dma_slave_read_i,
  input  [63:0]               avmm_wr_dma_slave_address_i,
  input  [DMA_BRST_CNT_W-1:0] avmm_wr_dma_slave_burst_count_i,
  input                       avmm_wr_dma_slave_chip_select_i,
  output                      avmm_wr_dma_slave_wait_request_o,
  output                      avmm_wr_dma_slave_read_data_valid_o,
  output [DMA_WIDTH-1:0]      avmm_wr_dma_slave_read_data_o,

  // DMA Read FIFO slave
  input                       avmm_rd_dma_slave_chip_select_i,
  input                       avmm_rd_dma_slave_write_i,
  input [63:0]                avmm_rd_dma_slave_address_i,
  input [DMA_WIDTH-1:0]       avmm_rd_dma_slave_write_data_i,
  input [DMA_BRST_CNT_W-1:0]  avmm_rd_dma_slave_burst_count_i,
  input [DMA_BE_WIDTH-1:0]    avmm_rd_dma_slave_byte_enable_i,
  output                      avmm_rd_dma_slave_wait_request_o,

  // ---------------------------------------------------------
  // Avalon-ST Descriptor Interfaces (Interface with DMA Data Mover)

  // DMA Write descriptor interface
  output [RXDATA_WIDTH-1:0]                   ast_wr_dma_desc_tx_data_o,
  output                                      ast_wr_dma_desc_tx_valid_o,
  input                                       ast_wr_dma_desc_tx_ready_i,

  input [31:0]                                ast_wr_dma_desc_rx_data_i,
  input                                       ast_wr_dma_desc_rx_valid_i,

  // DMA Read descriptor interface
  output [RXDATA_WIDTH-1:0]                   ast_rd_dma_desc_tx_data_o,
  output                                      ast_rd_dma_desc_tx_valid_o,
  input                                       ast_rd_dma_desc_tx_ready_i,

  input [31:0]                                ast_rd_dma_desc_rx_data_i,
  input                                       ast_rd_dma_desc_rx_valid_i,

  // ---------------------------------------------------------
  // Avalon-ST Interfaces (Interface with controller and FIFO)

  // Desc Status
  output [31:0]                              ast_wr_fifo_ctrl_tx_desc_status_data_o,
  output                                     ast_wr_fifo_ctrl_tx_desc_status_valid_o,

  output [31:0]                              ast_rd_fifo_ctrl_tx_data_cpl_ctrl_o,
  output                                     ast_rd_fifo_ctrl_tx_valid_cpl_ctrl_o,

  // Data Source/Sink Interface
  output                                     ast_wr_fifo_data_rx_ready_o,
  input  [DMA_WIDTH-1:0]                     ast_wr_fifo_data_rx_data_i,
  input                                      ast_wr_fifo_data_rx_valid_i,

  input                                      ast_rd_fifo_data_tx_ready_i,
  output [DMA_WIDTH+8-1:0]                   ast_rd_fifo_data_tx_data_w_dword_valid_o,
  output                                     ast_rd_fifo_data_tx_valid_o,

  // Descriptor Information
  input [RXDATA_WIDTH-1:0]                   ast_wr_fifo_desc_rx_data_i,
  input                                      ast_wr_fifo_desc_rx_valid_i,
  output                                     ast_wr_fifo_desc_rx_ready_o,

  input [RXDATA_WIDTH-1:0]                   ast_rd_fifo_desc_rx_data_i,
  input                                      ast_rd_fifo_desc_rx_valid_i,
  output                                     ast_rd_fifo_desc_rx_ready_o,

  // ---------------------------------
  // Optional TXS interface

  // Txs
  input                                      avmm_tx_slave_read_i,
  input                                      avmm_tx_slave_write_i,
  input  [63:0]                              avmm_tx_slave_address_i,
  input  [DMA_BRST_CNT_W-1:0]                avmm_tx_slave_burst_count_i,
  output                                     avmm_tx_slave_wait_request_o,
  output                                     avmm_tx_slave_read_data_valid_o,
  output [DMA_WIDTH-1:0]                     avmm_tx_slave_read_data_o,
  input  [DMA_WIDTH-1:0]                     avmm_tx_slave_write_data_i,
  input  [DMA_BE_WIDTH-1:0]                  avmm_tx_slave_byte_enable_i
 );

altpcieav_fifo_rd # (
  .TXS_MODE(TXS_MODE),
  .DMA_WIDTH(DMA_WIDTH),
  .DMA_BRST_CNT_W(DMA_BRST_CNT_W),
  .DMA_BE_WIDTH(DMA_BE_WIDTH),
  .RXDATA_WIDTH(RXDATA_WIDTH)
  ) fifo_rd (
     .Clk_i(Clk_i),
     .Rstn_i(Rstn_i),
     .avmm_rd_dma_slave_write_i(avmm_rd_dma_slave_write_i),
     .avmm_rd_dma_slave_address_i(avmm_rd_dma_slave_address_i),
     .avmm_rd_dma_slave_write_data_i(avmm_rd_dma_slave_write_data_i),
     .avmm_rd_dma_slave_burst_count_i(avmm_rd_dma_slave_burst_count_i),
     .avmm_rd_dma_slave_byte_enable_i(avmm_rd_dma_slave_byte_enable_i),
     .avmm_rd_dma_slave_chip_select_i(avmm_rd_dma_slave_chip_select_i),
     .avmm_rd_dma_slave_wait_request_o(avmm_rd_dma_slave_wait_request_o),
     .ast_rd_dma_desc_tx_data_o(ast_rd_dma_desc_tx_data_o),
     .ast_rd_dma_desc_tx_valid_o(ast_rd_dma_desc_tx_valid_o),
     .ast_rd_dma_desc_tx_ready_i(ast_rd_dma_desc_tx_ready_i),
     .ast_rd_dma_desc_rx_data_i(ast_rd_dma_desc_rx_data_i),
     .ast_rd_dma_desc_rx_valid_i(ast_rd_dma_desc_rx_valid_i),
     .ast_rd_fifo_ctrl_tx_data_cpl_ctrl_o(ast_rd_fifo_ctrl_tx_data_cpl_ctrl_o),
     .ast_rd_fifo_ctrl_tx_valid_cpl_ctrl_o(ast_rd_fifo_ctrl_tx_valid_cpl_ctrl_o),
     .ast_rd_fifo_data_tx_ready_i(ast_rd_fifo_data_tx_ready_i),
     .ast_rd_fifo_data_tx_data_w_dword_valid_o(ast_rd_fifo_data_tx_data_w_dword_valid_o),
     .ast_rd_fifo_data_tx_valid_o(ast_rd_fifo_data_tx_valid_o),
     .ast_rd_fifo_desc_rx_data_i(ast_rd_fifo_desc_rx_data_i),
     .ast_rd_fifo_desc_rx_valid_i(ast_rd_fifo_desc_rx_valid_i),
     .ast_rd_fifo_desc_rx_ready_o(ast_rd_fifo_desc_rx_ready_o)
    );

altpcieav_fifo_wr # (
  .TXS_MODE(TXS_MODE),
  .DMA_WIDTH(DMA_WIDTH),
  .DMA_BRST_CNT_W(DMA_BRST_CNT_W),
  .DMA_BE_WIDTH(DMA_BE_WIDTH),
  .RXDATA_WIDTH(RXDATA_WIDTH)
  ) fifo_wr (
     .Clk_i(Clk_i),
     .Rstn_i(Rstn_i),
     .avmm_wr_dma_slave_read_i(avmm_wr_dma_slave_read_i),
     .avmm_wr_dma_slave_address_i(avmm_wr_dma_slave_address_i),
     .avmm_wr_dma_slave_burst_count_i(avmm_wr_dma_slave_burst_count_i),
     .avmm_wr_dma_slave_wait_request_o(avmm_wr_dma_slave_wait_request_o),
     .avmm_wr_dma_slave_read_data_valid_o(avmm_wr_dma_slave_read_data_valid_o),
     .avmm_wr_dma_slave_read_data_o(avmm_wr_dma_slave_read_data_o),
     .avmm_wr_dma_slave_chip_select_i(avmm_wr_dma_slave_chip_select_i),
     .ast_wr_dma_desc_tx_data_o(ast_wr_dma_desc_tx_data_o),
     .ast_wr_dma_desc_tx_valid_o(ast_wr_dma_desc_tx_valid_o),
     .ast_wr_dma_desc_tx_ready_i(ast_wr_dma_desc_tx_ready_i),
     .ast_wr_dma_desc_rx_data_i(ast_wr_dma_desc_rx_data_i),
     .ast_wr_dma_desc_rx_valid_i(ast_wr_dma_desc_rx_valid_i),
     .ast_wr_fifo_ctrl_tx_desc_status_data_o(ast_wr_fifo_ctrl_tx_desc_status_data_o),
     .ast_wr_fifo_ctrl_tx_desc_status_valid_o(ast_wr_fifo_ctrl_tx_desc_status_valid_o),
     .ast_wr_fifo_data_rx_ready_o(ast_wr_fifo_data_rx_ready_o),
     .ast_wr_fifo_data_rx_data_i(ast_wr_fifo_data_rx_data_i),
     .ast_wr_fifo_data_rx_valid_i(ast_wr_fifo_data_rx_valid_i),
     .ast_wr_fifo_desc_rx_data_i(ast_wr_fifo_desc_rx_data_i),
     .ast_wr_fifo_desc_rx_valid_i(ast_wr_fifo_desc_rx_valid_i),
     .ast_wr_fifo_desc_rx_ready_o(ast_wr_fifo_desc_rx_ready_o)
);

endmodule
