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

module altpcieav_fifo_wr
  # (
  parameter TXS_MODE = 0,      // 0 = Regular mode, 1 = Txs slave port
  parameter DMA_WIDTH = 256,    // Supported modes: 128-bit, 256-bit
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
  input                       avmm_wr_dma_slave_chip_select_i,
  input  [63:0]               avmm_wr_dma_slave_address_i,
  input  [DMA_BRST_CNT_W-1:0] avmm_wr_dma_slave_burst_count_i,
  output                      avmm_wr_dma_slave_wait_request_o,
  output                      avmm_wr_dma_slave_read_data_valid_o,
  output [DMA_WIDTH-1:0]      avmm_wr_dma_slave_read_data_o,

  // ---------------------------------------------------------
  // Avalon-ST Descriptor Interfaces (Interface with DMA Data Mover)

  // DMA Write descriptor interface
  output [RXDATA_WIDTH-1:0]                   ast_wr_dma_desc_tx_data_o,
  output                                      ast_wr_dma_desc_tx_valid_o,
  input                                       ast_wr_dma_desc_tx_ready_i,

  input [31:0]                                ast_wr_dma_desc_rx_data_i,
  input                                       ast_wr_dma_desc_rx_valid_i,

  // ---------------------------------------------------------
  // Avalon-ST Interfaces (Interface with controller and FIFO)

  // Desc Status
  output [31:0]                              ast_wr_fifo_ctrl_tx_desc_status_data_o,
  output                                     ast_wr_fifo_ctrl_tx_desc_status_valid_o,

  // Data Sink Interface
  output logic                               ast_wr_fifo_data_rx_ready_o,
  input  logic  [DMA_WIDTH-1:0]              ast_wr_fifo_data_rx_data_i,
  input  logic                               ast_wr_fifo_data_rx_valid_i,

  // Descriptor Information
  input [RXDATA_WIDTH-1:0]                   ast_wr_fifo_desc_rx_data_i,
  input                                      ast_wr_fifo_desc_rx_valid_i,
  output                                     ast_wr_fifo_desc_rx_ready_o

 );
 localparam INPUT_DESC_READY = 2'b1;
 localparam INPUT_DESC_BUSY = 2'h2;

 reg  [1:0] input_desc_sm;
 reg  [1:0] input_desc_next_state;
 reg  [1:0] desc_ready_counter;
 reg        desc_valid_output;
 reg [RXDATA_WIDTH-1:0] input_desc_reg;
 reg [RXDATA_WIDTH-1:0] generated_desc_reg;

 reg [5:0] cmd_burst_cntr_reg;

 always @(posedge Clk_i, negedge Rstn_i)
  begin
    if(~Rstn_i)
      input_desc_sm <= INPUT_DESC_READY;
    else
      input_desc_sm <= input_desc_next_state;
  end

  always @(posedge Clk_i, negedge Rstn_i)
    begin
      if(~Rstn_i)
        desc_ready_counter <= 2'b0;
      else if (~ast_wr_dma_desc_tx_ready_i & desc_ready_counter != 2'h2)
        desc_ready_counter <= desc_ready_counter + 2'b1;
      else if (~ast_wr_dma_desc_tx_ready_i)
        desc_ready_counter <= desc_ready_counter;
      else
        desc_ready_counter <= 2'b0;
     end

  always @(posedge Clk_i, negedge Rstn_i)
    begin
      if(~Rstn_i)
      begin
        input_desc_reg <= 160'b0;
        desc_valid_output <= 1'b0;
      end
      else if (ast_wr_fifo_desc_rx_valid_i & ast_wr_fifo_desc_rx_ready_o)
      begin
        input_desc_reg <= ast_wr_fifo_desc_rx_data_i;
        desc_valid_output <= 1'b1;
      end
      else
      begin
        input_desc_reg <= 160'b0;
        desc_valid_output <= 1'b0;
      end
    end

    assign ast_wr_dma_desc_tx_data_o = (TXS_MODE == 0)  ? input_desc_reg : generated_desc_reg; // TODO TXS
    assign ast_wr_dma_desc_tx_valid_o = (TXS_MODE == 0) ? desc_valid_output : 1'b0; // TODO TXS

  always @*
    begin
      case (input_desc_sm)
        INPUT_DESC_READY:
          if(desc_ready_counter != 2'b1)
            input_desc_next_state <= INPUT_DESC_READY;
          else
            input_desc_next_state <= INPUT_DESC_BUSY;
        INPUT_DESC_BUSY:
          if(desc_ready_counter == 2'b0)
            input_desc_next_state <= INPUT_DESC_READY;
          else
            input_desc_next_state <= INPUT_DESC_BUSY;
        default:
            input_desc_next_state <= INPUT_DESC_READY;
      endcase
     end

  assign ast_wr_fifo_desc_rx_ready_o = (input_desc_sm[0] == 1'b1);

  // ---------------------------
  // Data Fifo

  reg [DMA_WIDTH-1:0]  data_stream_fifo_wdata_reg;
  wire                 data_stream_fifo_rdreq;
  wire                 data_stream_fifo_wrreq;
  reg                  data_stream_fifo_wrreq_reg;
  wire                 data_stream_fifo_empty;
  wire [DMA_WIDTH-1:0] data_stream_fifo_q;
  wire [8:0]           data_stream_fifo_count;

  scfifo data_stream_fifo(
   .aclr(~Rstn_i),
   .clock(Clk_i),
   .data(data_stream_fifo_wdata_reg),
   .rdreq(data_stream_fifo_rdreq),
   .sclr(1'b0),
   .wrreq(data_stream_fifo_wrreq_reg),
   .empty(data_stream_fifo_empty),
   .full(),
   .q(data_stream_fifo_q),
   .usedw(data_stream_fifo_count),
   .almost_empty(),
   .almost_full()
   );

   defparam
      data_stream_fifo.add_ram_output_register = "OFF",
      data_stream_fifo.intended_device_family = "Stratix V",
//    data_stream_fifo.lpm_hint = "RAM_BLOCK_TYPE=M20K",
      data_stream_fifo.lpm_hint = "unused",
      data_stream_fifo.lpm_numwords = 512,
      data_stream_fifo.lpm_showahead = "OFF",
      data_stream_fifo.lpm_type = "scfifo",
      data_stream_fifo.lpm_width = DMA_WIDTH,
      data_stream_fifo.lpm_widthu = 9,
      data_stream_fifo.overflow_checking = "ON",
      data_stream_fifo.underflow_checking = "ON",
      data_stream_fifo.use_eab = "ON";


      assign ast_wr_fifo_data_rx_ready_o = (data_stream_fifo_count < 10'h1FC);
      assign data_stream_fifo_wrreq = (ast_wr_fifo_data_rx_valid_i);

    always @(posedge Clk_i, negedge Rstn_i)
      begin
        if(~Rstn_i)
        begin
          data_stream_fifo_wrreq_reg <= 1'b0;
          data_stream_fifo_wdata_reg <= (DMA_WIDTH == 256) ? 256'b0 : 128'b0;
        end
        else
        begin
          data_stream_fifo_wrreq_reg <= ast_wr_fifo_data_rx_valid_i; // Source is responsible to deassert valid after 3 cycles
          data_stream_fifo_wdata_reg <= ast_wr_fifo_data_rx_data_i;
        end
      end

  assign ast_wr_fifo_ctrl_tx_desc_status_data_o  = ast_wr_dma_desc_rx_data_i;
  assign ast_wr_fifo_ctrl_tx_desc_status_valid_o = ast_wr_dma_desc_rx_valid_i;

  // ------------------------------
  // AST-AVMM
  wire wr_ast_avmm_cmd_fifo_rdreq;
  reg  wr_ast_avmm_cmd_fifo_wrreq_reg;
  reg  [5:0] wr_ast_avmm_cmd_fifo_datain_reg;
  wire [1:0] wr_ast_avmm_cmd_fifo_usedw;
  wire wr_ast_avmm_cmd_fifo_empty;
  wire [5:0] wr_ast_avmm_cmd_fifo_q;
  wire wr_ast_avmm_cmd_fifo_full;
  wire wr_ast_avmm_cmd_fifo_ok;

  reg [1:0] wr_ast_avmm_sm;
  reg[1:0] wr_ast_avmm_next_state;

  reg [3:0] wr_ast_fifo_sm;
  reg [3:0] wr_ast_fifo_next_state;

  assign wr_ast_avmm_cmd_fifo_ok = (wr_ast_avmm_cmd_fifo_usedw <= 3);

  altpcie_fifo
   #(
    .FIFO_DEPTH(4),
    .DATA_WIDTH(6)
    )
   wr_ast_avmm_cmd_fifo
   (
      .clk(Clk_i),
      .rstn(Rstn_i),
      .srst(1'b0),
      .wrreq(wr_ast_avmm_cmd_fifo_wrreq_reg),
      .rdreq(wr_ast_avmm_cmd_fifo_rdreq),
      .data(wr_ast_avmm_cmd_fifo_datain_reg),
      .q(wr_ast_avmm_cmd_fifo_q),
      .fifo_count(wr_ast_avmm_cmd_fifo_usedw)
  );

  assign wr_ast_avmm_cmd_fifo_empty = (wr_ast_avmm_cmd_fifo_usedw == 2'b0);

  always @(posedge Clk_i, negedge Rstn_i)
    begin
      if(~Rstn_i)
       wr_ast_avmm_cmd_fifo_datain_reg <=  6'h0;
      else
       wr_ast_avmm_cmd_fifo_datain_reg <=  (DMA_WIDTH == 256) ? {1'b0, avmm_wr_dma_slave_burst_count_i} : avmm_wr_dma_slave_burst_count_i;
    end

  always @(posedge Clk_i, negedge Rstn_i)
    begin
      if(~Rstn_i)
       wr_ast_avmm_cmd_fifo_wrreq_reg <= 1'b0;
      else if (wr_ast_avmm_sm[1] == 1'b1 & avmm_wr_dma_slave_read_i ) // wait request guaranteed to be low during this state
       wr_ast_avmm_cmd_fifo_wrreq_reg <= 1'b1;
      else
       wr_ast_avmm_cmd_fifo_wrreq_reg <= 1'b0;
    end

  assign avmm_wr_dma_slave_wait_request_o = (wr_ast_avmm_sm[1] == 1'b1) ? 1'b0 : 1'b1;

  localparam WR_AST_AVMM_IDLE        = 2'h1;
  localparam WR_AST_AVMM_RD_HEADER    = 2'h2;

  always @ (posedge Clk_i, negedge Rstn_i)
    begin
      if(~Rstn_i)
        wr_ast_avmm_sm <= WR_AST_AVMM_IDLE;
      else
        wr_ast_avmm_sm <= wr_ast_avmm_next_state;
    end

  always @*
    begin
      case(wr_ast_avmm_sm)
        WR_AST_AVMM_IDLE :
          if (avmm_wr_dma_slave_chip_select_i & avmm_wr_dma_slave_read_i & wr_ast_avmm_cmd_fifo_ok)
            wr_ast_avmm_next_state <= WR_AST_AVMM_RD_HEADER;
          else
            wr_ast_avmm_next_state <= WR_AST_AVMM_IDLE;
        WR_AST_AVMM_RD_HEADER :
          if (avmm_wr_dma_slave_chip_select_i & avmm_wr_dma_slave_read_i & wr_ast_avmm_cmd_fifo_ok)
            wr_ast_avmm_next_state <= WR_AST_AVMM_RD_HEADER;
          else
            wr_ast_avmm_next_state <= WR_AST_AVMM_IDLE;
      endcase
   end

   localparam WR_AST_FIFO_IDLE        = 4'h1;
   localparam WR_AST_FIFO_RD_CMD      = 4'h2;
   localparam WR_AST_FIFO_RD_PIPE     = 4'h4;
   localparam WR_AST_FIFO_RD_WAIT     = 4'h8;


   wire wr_ast_fifo_idle_st = wr_ast_fifo_sm[0];
   wire wr_ast_fifo_rd_cmd_st = wr_ast_fifo_sm[1];
   wire wr_ast_fifo_rd_pipe_st = wr_ast_fifo_sm[2];
   wire wr_ast_fifo_rd_wait_st = wr_ast_fifo_sm[3];
   wire wr_ast_fifo_rd_cmd_continue = (cmd_burst_cntr_reg == 6'b1 & ~wr_ast_avmm_cmd_fifo_empty);

   assign wr_ast_avmm_cmd_fifo_rdreq = (wr_ast_fifo_rd_cmd_st | (wr_ast_fifo_rd_cmd_continue & wr_ast_fifo_rd_pipe_st));
   always @ (posedge Clk_i, negedge Rstn_i)
     begin
     if(~Rstn_i)
       wr_ast_fifo_sm <= WR_AST_FIFO_IDLE;
     else
       wr_ast_fifo_sm <= wr_ast_fifo_next_state;
   end

 always @*
   begin
     case(wr_ast_fifo_sm)
        WR_AST_FIFO_IDLE:
          if(~wr_ast_avmm_cmd_fifo_empty)
            wr_ast_fifo_next_state <= WR_AST_FIFO_RD_CMD;
          else
            wr_ast_fifo_next_state <= WR_AST_FIFO_IDLE;
        WR_AST_FIFO_RD_CMD:
          // Read command out
          if (~data_stream_fifo_empty)
            wr_ast_fifo_next_state <= WR_AST_FIFO_RD_PIPE;
          else
            wr_ast_fifo_next_state <= WR_AST_FIFO_RD_WAIT;
        WR_AST_FIFO_RD_PIPE:
          if (cmd_burst_cntr_reg != 6'h1 & (data_stream_fifo_count > 9'h1 | data_stream_fifo_wrreq_reg))
            wr_ast_fifo_next_state <= WR_AST_FIFO_RD_PIPE;
          else if (cmd_burst_cntr_reg != 6'h1) // Only 1, shouldn't be 0 (since was non-empty in previous state)
            wr_ast_fifo_next_state <= WR_AST_FIFO_RD_WAIT;
          else if (~data_stream_fifo_empty & wr_ast_fifo_rd_cmd_continue)
            wr_ast_fifo_next_state <= WR_AST_FIFO_RD_PIPE;
          else if (data_stream_fifo_empty & wr_ast_fifo_rd_cmd_continue)
            wr_ast_fifo_next_state <= WR_AST_FIFO_RD_WAIT;
          else
            wr_ast_fifo_next_state <= WR_AST_FIFO_IDLE;
        WR_AST_FIFO_RD_WAIT:
          if (~data_stream_fifo_empty)
            wr_ast_fifo_next_state <= WR_AST_FIFO_RD_PIPE;
          else
            wr_ast_fifo_next_state <= WR_AST_FIFO_RD_WAIT;
     endcase
  end

  assign avmm_wr_dma_slave_read_data_o       = data_stream_fifo_q;
  assign avmm_wr_dma_slave_read_data_valid_o = wr_ast_fifo_rd_pipe_st;
  assign data_stream_fifo_rdreq              =
        (~data_stream_fifo_empty
         & (
              (wr_ast_fifo_rd_cmd_st) | (wr_ast_fifo_rd_wait_st) |
              (wr_ast_fifo_rd_pipe_st &
                ( (cmd_burst_cntr_reg != 6'h1 & (data_stream_fifo_count > 9'h1 | data_stream_fifo_wrreq_reg)) |
                 wr_ast_fifo_rd_cmd_continue
                )
              )
           )
       );

  always @ (posedge Clk_i, negedge Rstn_i)
    begin
    if(~Rstn_i)
      cmd_burst_cntr_reg <= 6'h0;
    else if (wr_ast_fifo_rd_cmd_st | wr_ast_fifo_rd_cmd_continue)
      cmd_burst_cntr_reg <= wr_ast_avmm_cmd_fifo_q;
    else if (wr_ast_fifo_rd_pipe_st & cmd_burst_cntr_reg > 6'h0)
      cmd_burst_cntr_reg <= cmd_burst_cntr_reg - 6'h1;
    else if (wr_ast_fifo_rd_wait_st)
      cmd_burst_cntr_reg <= cmd_burst_cntr_reg;
    else
      cmd_burst_cntr_reg <= 6'h0;
    end

endmodule
