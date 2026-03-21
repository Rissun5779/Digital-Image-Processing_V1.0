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

module altpcieav_fifo_rd
  # (
  parameter TXS_MODE = 0,      // 0 = Regular mode, 1 = Txs slave port
  parameter DMA_WIDTH = 256,    // Supported modes: 128-bit, 256-bit
  parameter DMA_BRST_CNT_W = 5, // 6 for 128-bit, 5 for 256-bit
  parameter DMA_BE_WIDTH = 32,  // 16 bytes for 128-bit, 32 bytes for 256-bit
  parameter RXDATA_WIDTH = 160, // Usually 160 bits, but may be extended to 168 to support SR-IOV function fields
  parameter INTENDED_DEVICE_FAMILY = "Stratix V"
  )
  (
  // Clock and reset
  input Clk_i,
  input Rstn_i,

  // ---------------------------------------------------------
  // Avalon-MM Slaves (Interface with DMA Masters)

  // DMA Read FIFO slave
  input                       avmm_rd_dma_slave_write_i,
  input                       avmm_rd_dma_slave_chip_select_i,
  input [63:0]                avmm_rd_dma_slave_address_i,
  input [DMA_WIDTH-1:0]       avmm_rd_dma_slave_write_data_i,
  input [DMA_BRST_CNT_W-1:0]  avmm_rd_dma_slave_burst_count_i,
  input [DMA_BE_WIDTH-1:0]    avmm_rd_dma_slave_byte_enable_i,
  output                      avmm_rd_dma_slave_wait_request_o,


  // ---------------------------------------------------------
  // Avalon-ST Descriptor Interfaces (Interface with DMA Data Mover)

  // DMA Read descriptor interface
  output [RXDATA_WIDTH-1:0]                   ast_rd_dma_desc_tx_data_o,
  output                                      ast_rd_dma_desc_tx_valid_o,
  input                                       ast_rd_dma_desc_tx_ready_i,

  input [31:0]                                ast_rd_dma_desc_rx_data_i,
  input                                       ast_rd_dma_desc_rx_valid_i,

  // ---------------------------------------------------------
  // Avalon-ST Interfaces (Interface with controller and FIFO)

  output [31:0]                              ast_rd_fifo_ctrl_tx_data_cpl_ctrl_o,
  output                                     ast_rd_fifo_ctrl_tx_valid_cpl_ctrl_o,

  // Data Source Interface
  input  logic                               ast_rd_fifo_data_tx_ready_i,
  output logic  [DMA_WIDTH+8-1:0]            ast_rd_fifo_data_tx_data_w_dword_valid_o,
  output logic                               ast_rd_fifo_data_tx_valid_o,

  // Descriptor Information
  input [RXDATA_WIDTH-1:0]                   ast_rd_fifo_desc_rx_data_i,
  input                                      ast_rd_fifo_desc_rx_valid_i,
  output                                     ast_rd_fifo_desc_rx_ready_o
 );

 //define the clogb2 constant function
   function integer clogb2;
      input [31:0] depth;
      begin
         depth = depth - 1 ;
         for (clogb2 = 0; depth > 0; clogb2 = clogb2 + 1)
           depth = depth >> 1 ;
      end
   endfunction // clogb2

  localparam DESC_IDLE        = 3'h1;
  localparam DESC_STORE_SEND  = 3'h2;
  localparam DESC_SEND_WAIT   = 3'h4;
  localparam HOL_CNTR_WIDTH   = (TXS_MODE == 0? 2: 5);
  localparam SLICE_DW         = (DMA_WIDTH == 256? 8: 4);
  localparam SLICE_DW_WIDTH   = clogb2(SLICE_DW);
  localparam NUM_SLICES_WIDTH = 11-SLICE_DW_WIDTH+1;
  localparam NUM_TXS_BUCKET_SHIFT = 4;
  localparam NUM_FIFO_MODE_BUCKET_SHIFT = 7;
  localparam NUM_TOTAL_BUFFER_SHIFT = (TXS_MODE == 0? NUM_FIFO_MODE_BUCKET_SHIFT : NUM_TXS_BUCKET_SHIFT)
                                      + (DMA_WIDTH == 256 ? 0: 1);
  localparam TXS_BUCKET_BYTE_SIZE = 512;
  localparam FIFO_MODE_BUCKET_BYTE_SIZE = 4096;
  localparam BUCKET_BYTE_SIZE = (TXS_MODE == 0? FIFO_MODE_BUCKET_BYTE_SIZE : TXS_BUCKET_BYTE_SIZE);

  // Descriptor Formulation Side
  reg [RXDATA_WIDTH-1:0] gen_desc_reg;   //TODO
  reg [RXDATA_WIDTH-1:0] desc_reg;       //TODO
  wire [RXDATA_WIDTH-1:0] desc_to_use;   //TODO
  reg [2:0] desc_sm;                     //TODO
  reg [2:0] desc_sm_next_state;          //TODO
  reg [4:0] desc_id_cntr;
  reg [5:0] outstanding_desc_cntr;
  wire up_outstanding_desc;              //TODO
  wire down_outstanding_desc;            //TODO
  wire [5:0] max_outstanding_desc;       //TODO
  wire [4:0] last_desc_id;               //TODO
  wire [63:0] remapped_address;
  wire desc_done;
  reg [31:0] desc_cpl_status_reg;
  reg [HOL_CNTR_WIDTH-1:0]  hol_cntr;
  reg [HOL_CNTR_WIDTH-1:0]  current_processing;
  reg [4:0]  current_cntr;
  reg desc_send_st_reg;
  reg desc_send_st_rr;
  reg [RXDATA_WIDTH-1:0] desc_to_use_reg;
  reg [RXDATA_WIDTH-1:0] desc_to_use_rr;
  reg [4:0] desc_id_cntr_reg;
  reg [4:0] desc_id_cntr_rr;
  reg [NUM_SLICES_WIDTH-1:0] num_slices;
  reg [10:0] new_length;
  reg [2:0] dw_wasted;
  reg cpl_buffer_wrena;
  reg [63:0] cpl_buffer_addr;
  reg [DMA_BRST_CNT_W-1:0] cpl_burst_counter;
  reg [DMA_WIDTH-1:0] cpl_buffer_data;
  reg [64+8+NUM_SLICES_WIDTH-1:0] hol_table_entry_reg;
  wire [64+8+NUM_SLICES_WIDTH-1:0] id_address_len_table_q;
  wire latch_counters;
  wire desc_idle_st      = (desc_sm == DESC_IDLE);
  wire desc_send_st      = (desc_sm == DESC_STORE_SEND);
  wire desc_send_wait_st = (desc_sm == DESC_SEND_WAIT);

  assign ast_rd_fifo_desc_rx_ready_o = (((desc_idle_st & outstanding_desc_cntr > 6'h0) | (desc_send_st & outstanding_desc_cntr > 6'h1)) & ast_rd_dma_desc_tx_ready_i);
  assign max_outstanding_desc = (TXS_MODE == 0? 6'h4: 6'd32);
  assign last_desc_id = (TXS_MODE == 0? 5'h3: 5'd31);
  assign down_outstanding_desc = desc_send_st;
  assign up_outstanding_desc = desc_done;

  always @(posedge Clk_i, negedge Rstn_i)
  begin
    if(~Rstn_i)
      desc_reg <= {RXDATA_WIDTH{1'b0}};
    else if (ast_rd_fifo_desc_rx_valid_i & ast_rd_fifo_desc_rx_ready_o)
      desc_reg <= ast_rd_fifo_desc_rx_data_i;
    else
      desc_reg <= desc_reg;
  end

  assign desc_to_use = (TXS_MODE == 0 ? desc_reg : gen_desc_reg);

  always @(posedge Clk_i, negedge Rstn_i)
  begin
    if(~Rstn_i)
      desc_id_cntr <= 5'h0;
    else if(desc_send_st & desc_id_cntr < last_desc_id)
      desc_id_cntr <= desc_id_cntr + 1'b1;
    else if (desc_send_st) // desc_id_cntr must be equal or greater than last_desc_id due to conditional ordering checking
      desc_id_cntr <= 5'h0;
    else
      desc_id_cntr <= desc_id_cntr;
  end

  always @(posedge Clk_i, negedge Rstn_i)
  begin
    if(~Rstn_i)
      outstanding_desc_cntr <= max_outstanding_desc;
    else if(up_outstanding_desc & ~down_outstanding_desc)
      outstanding_desc_cntr <= outstanding_desc_cntr + 1'b1;
    else if(~up_outstanding_desc & down_outstanding_desc)
      outstanding_desc_cntr <= outstanding_desc_cntr - 1'b1;
    else
      outstanding_desc_cntr <= outstanding_desc_cntr;
  end

 always @ (posedge Clk_i, negedge Rstn_i)
     begin
     if(~Rstn_i)
       desc_sm <= DESC_IDLE;
     else
       desc_sm <= desc_sm_next_state;
     end

  always @*
    begin
      case(desc_sm)
        DESC_IDLE:
        if (ast_rd_fifo_desc_rx_ready_o & ast_rd_fifo_desc_rx_valid_i & outstanding_desc_cntr > 6'h0 & ast_rd_dma_desc_tx_ready_i)
          desc_sm_next_state <= DESC_STORE_SEND;
        else if (ast_rd_fifo_desc_rx_ready_o & ast_rd_fifo_desc_rx_valid_i)
          desc_sm_next_state <= DESC_SEND_WAIT;
        else
          desc_sm_next_state <= DESC_IDLE;
        DESC_STORE_SEND:
        if (ast_rd_fifo_desc_rx_ready_o & ast_rd_fifo_desc_rx_valid_i & outstanding_desc_cntr > 6'h1 & ast_rd_dma_desc_tx_ready_i)
          desc_sm_next_state <= DESC_STORE_SEND;
        else if (ast_rd_fifo_desc_rx_ready_o & ast_rd_fifo_desc_rx_valid_i)
          desc_sm_next_state <= DESC_SEND_WAIT;
        else
          desc_sm_next_state <= DESC_IDLE;
        DESC_SEND_WAIT:
        if (outstanding_desc_cntr > 6'h0 & ast_rd_dma_desc_tx_ready_i)
          desc_sm_next_state <= DESC_STORE_SEND;
        else
          desc_sm_next_state <= DESC_SEND_WAIT;
      endcase
    end

    assign   remapped_address = {{(64 - clogb2(BUCKET_BYTE_SIZE) - 5){1'b0}}, desc_id_cntr, {clogb2(BUCKET_BYTE_SIZE){1'b0}}};

    assign   ast_rd_dma_desc_tx_data_o  = {desc_to_use[RXDATA_WIDTH-1:154], 3'h0, desc_id_cntr[4:0], desc_to_use[145:128], remapped_address, desc_to_use[63:0]};
    assign   ast_rd_dma_desc_tx_valid_o = (desc_sm == DESC_STORE_SEND);

  localparam CB_ID_ADDR_LEN_TABLE_DEPTH = 32;
  localparam ID_ADDR_LEN_TABLE_ADDR_WIDTH = clogb2(CB_ID_ADDR_LEN_TABLE_DEPTH);

  altsyncram
  #(
     .intended_device_family(INTENDED_DEVICE_FAMILY),
     .operation_mode("DUAL_PORT"),
     .width_a(64+8+NUM_SLICES_WIDTH),
     .widthad_a(ID_ADDR_LEN_TABLE_ADDR_WIDTH),
     .numwords_a(CB_ID_ADDR_LEN_TABLE_DEPTH),
     .width_b(64+8+NUM_SLICES_WIDTH),
     .widthad_b(ID_ADDR_LEN_TABLE_ADDR_WIDTH),
     .numwords_b(CB_ID_ADDR_LEN_TABLE_DEPTH),
     .lpm_type("altsyncram"),
     .width_byteena_a(1),
     .outdata_reg_b("UNREGISTERED"),
     .indata_aclr_a("NONE"),
     .wrcontrol_aclr_a("NONE"),
     .address_aclr_a("NONE"),
     .address_reg_b("CLOCK0"),
     .address_aclr_b("NONE"),
     .outdata_aclr_b("NONE"),
     .power_up_uninitialized("FALSE"),
     .ram_block_type("AUTO"),
     .read_during_write_mode_mixed_ports("DONT_CARE")
  )   id_address_len_table
  (
      .wren_a          (desc_send_st_rr),                                             //TODO
      .clock0          (Clk_i),                                                       //TODO
      .address_a       (desc_id_cntr_rr),                                             //TODO
      .address_b       (hol_cntr),                                                    //TODO
      .data_a          ({desc_to_use_rr[153:146],desc_to_use_rr[128:65],num_slices}), //TODO
      .q_b             (id_address_len_table_q),                                      //TODO
      .aclr0           (),
      .aclr1           (),
      .addressstall_a  (),
      .addressstall_b  (),
      .byteena_a       (),
      .byteena_b       (),
      .clocken0        (),
      .data_b          (),
      .q_a             (),
      .rden_b          (),
      .wren_b          ()
   );


  always @ *
   begin
    case({{(3-SLICE_DW_WIDTH){1'b0}}, desc_to_use[66+SLICE_DW_WIDTH-1:66], 2'b0})
      5'h0:  dw_wasted = 3'd0;
      5'h4:  dw_wasted = 3'd1;
      5'h8:  dw_wasted = 3'd2;
      5'hC:  dw_wasted = 3'd3;
      5'h10: dw_wasted = 3'd4;
      5'h14: dw_wasted = 3'd5;
      5'h18: dw_wasted = 3'd6;
      5'h1C: dw_wasted = 3'd7;
    endcase
  end

  always @ (posedge Clk_i, negedge Rstn_i)
    begin
      if (~Rstn_i)
      begin
        desc_send_st_reg <= 1'b0;
        desc_send_st_rr  <= 1'b0;
        desc_to_use_reg  <= {{RXDATA_WIDTH}{1'b0}};
        desc_to_use_rr   <= {{RXDATA_WIDTH}{1'b0}};
        desc_id_cntr_reg <= 5'h0;
        desc_id_cntr_rr  <= 5'h0;
      end
      else

      begin
        desc_send_st_reg <= desc_send_st;
        desc_send_st_rr  <= desc_send_st_reg;
        desc_to_use_reg  <= desc_to_use;
        desc_to_use_rr   <= desc_to_use_reg;
        desc_id_cntr_reg <= desc_id_cntr;
        desc_id_cntr_rr  <= desc_id_cntr_reg;
      end
   end

  always @ (posedge Clk_i, negedge Rstn_i)
    begin
      if (~Rstn_i)
      begin
        new_length <= 11'h0;
      end
      else
      begin
        new_length <= (desc_to_use[138:128] + dw_wasted);
      end
   end

  always @ (posedge Clk_i, negedge Rstn_i)
    begin
      if (~Rstn_i)
      begin
        num_slices <= {NUM_SLICES_WIDTH{1'b0}};
      end
      else
      begin
        num_slices <= new_length[10:SLICE_DW_WIDTH] + (new_length[SLICE_DW_WIDTH-1:0] != 0);
      end
   end

  // Completion Buffer side
  localparam CB_RX_CPL_BUFFER_DEPTH = 512;
  localparam RXCPL_BUFF_ADDR_WIDTH = clogb2(CB_RX_CPL_BUFFER_DEPTH);

  reg [RXCPL_BUFF_ADDR_WIDTH-1:0] cpl_buffer_rdaddr;
  wire [DMA_WIDTH+DMA_WIDTH/32-1:0] cpl_buffer_q;

  altsyncram
  #(
     .intended_device_family(INTENDED_DEVICE_FAMILY),
     .operation_mode("DUAL_PORT"),
     .width_a(DMA_WIDTH+DMA_WIDTH/32),
     .widthad_a(RXCPL_BUFF_ADDR_WIDTH),
     .numwords_a(CB_RX_CPL_BUFFER_DEPTH),
     .width_b(DMA_WIDTH+DMA_WIDTH/32),
     .widthad_b(RXCPL_BUFF_ADDR_WIDTH),
     .numwords_b(CB_RX_CPL_BUFFER_DEPTH),
     .lpm_type("altsyncram"),
     .width_byteena_a(1),
     .outdata_reg_b("UNREGISTERED"),
     .indata_aclr_a("NONE"),
     .wrcontrol_aclr_a("NONE"),
     .address_aclr_a("NONE"),
     .address_reg_b("CLOCK0"),
     .address_aclr_b("NONE"),
     .outdata_aclr_b("NONE"),
     .power_up_uninitialized("FALSE"),
     .ram_block_type("AUTO"),
     .read_during_write_mode_mixed_ports("DONT_CARE")
  )   cpl_buffer
  (
      .wren_a          (cpl_buffer_wrena),      //TODO
      .clocken1        (),
      .clock0          (Clk_i),                 //TODO
      .clock1          (),
      .address_a       (cpl_buffer_addr),       //TODO
      .address_b       (cpl_buffer_rdaddr),
      .data_a          (cpl_buffer_data),       //TODO
      .q_b             (cpl_buffer_q),
      .aclr0           (),
      .aclr1           (),
      .addressstall_a  (),
      .addressstall_b  (),
      .byteena_a       (),
      .byteena_b       (),
      .clocken0        (),
      .data_b          (),
      .q_a             (),
      .rden_b          (),
      .wren_b          ()
   );

  assign avmm_rd_dma_slave_wait_request_o = 1'b0; // RAM always ready to take data
  assign latch_counters = ((~cpl_buffer_wrena & avmm_rd_dma_slave_write_i & cpl_burst_counter == 0) | (cpl_burst_counter == 1 & cpl_buffer_wrena)) & avmm_rd_dma_slave_write_i & avmm_rd_dma_slave_chip_select_i;

  always @(posedge Clk_i, negedge Rstn_i)
  begin
    if(~Rstn_i)
      cpl_buffer_wrena <= 1'b0;
    else
      cpl_buffer_wrena <= avmm_rd_dma_slave_write_i & avmm_rd_dma_slave_chip_select_i;
  end

  always @(posedge Clk_i, negedge Rstn_i)
  begin
    if(~Rstn_i)
      cpl_buffer_data <= {(DMA_WIDTH){1'b0}};
    else
      cpl_buffer_data <= avmm_rd_dma_slave_write_data_i;
  end

  always @(posedge Clk_i, negedge Rstn_i)
  begin
    if(~Rstn_i)
      cpl_buffer_addr <= 64'h0;
    else if (latch_counters)
      cpl_buffer_addr <= (avmm_rd_dma_slave_address_i >> (DMA_WIDTH == 128? 4 : 5)); // Convert byte address to slice
    else if(cpl_buffer_wrena)
      cpl_buffer_addr <= cpl_buffer_addr + 1'b1;
    else
      cpl_buffer_addr <= cpl_buffer_addr;
  end

  always @(posedge Clk_i, negedge Rstn_i)
  begin
    if(~Rstn_i)
      cpl_burst_counter <= {DMA_BRST_CNT_W{1'b0}};
    else if(latch_counters)
      cpl_burst_counter <= avmm_rd_dma_slave_burst_count_i;
    else if(cpl_buffer_wrena)
      cpl_burst_counter <= cpl_burst_counter - 1'b1;
    else
      cpl_burst_counter <= cpl_burst_counter;
  end

  always @(posedge Clk_i, negedge Rstn_i)
    begin
      if(~Rstn_i)
        hol_table_entry_reg <= 79'h0;
      else
        hol_table_entry_reg <= id_address_len_table_q;
    end

  generate
    genvar i;
    for (i=0; i < 32; i=i+1)
      begin : desc_cpl_status_register
        always @(posedge Clk_i, negedge Rstn_i)
          begin
            if(~Rstn_i)
              desc_cpl_status_reg[i] <= 1'b0;
            else if(i == ast_rd_dma_desc_rx_data_i[7:0] & ast_rd_dma_desc_rx_data_i[8] & ast_rd_dma_desc_rx_valid_i)
              desc_cpl_status_reg[i] <= 1'b1;
            else if(desc_done & current_processing == i) // TODO
              desc_cpl_status_reg[i] <= 1'b0;
            else
              desc_cpl_status_reg[i] <= desc_cpl_status_reg[i];
          end
      end
   endgenerate

   reg [2:0] fifo_ast_sm;
   reg [2:0] fifo_ast_sm_next_state;

   localparam FIFO_AST_IDLE = 3'h1;
   localparam FIFO_AST_WAIT = 3'h2;
   localparam FIFO_AST_SEND = 3'h4;
   reg        two_or_more_burst_count_flag;
   reg [NUM_SLICES_WIDTH-1:0]  fifo_ast_slices_left;
   reg [7:0]  fifo_ast_table_id;
   reg        latched_address;

   wire fifo_ast_idle_st = (fifo_ast_sm == FIFO_AST_IDLE);
   wire fifo_ast_wait_st = (fifo_ast_sm == FIFO_AST_WAIT);
   wire fifo_ast_send_st = (fifo_ast_sm == FIFO_AST_SEND);
   wire [7:0]  table_id          = id_address_len_table_q[NUM_SLICES_WIDTH+7+64:NUM_SLICES_WIDTH+64];
   wire [63:0] table_addr        = id_address_len_table_q[NUM_SLICES_WIDTH+63:NUM_SLICES_WIDTH];
   wire [NUM_SLICES_WIDTH-1:0]  table_burst_count = id_address_len_table_q[NUM_SLICES_WIDTH-1:0];

   assign desc_done = (fifo_ast_send_st & fifo_ast_slices_left == 1);
   assign ast_rd_fifo_data_tx_data_w_dword_valid_o  = cpl_buffer_q;
   assign ast_rd_fifo_data_tx_valid_o               = (fifo_ast_send_st);
   assign ast_rd_fifo_ctrl_tx_data_cpl_ctrl_o[7:0]  = fifo_ast_table_id;
   assign ast_rd_fifo_ctrl_tx_data_cpl_ctrl_o[31:9] = 23'h0;
   assign ast_rd_fifo_ctrl_tx_data_cpl_ctrl_o[8]    = 1'b1;
   assign ast_rd_fifo_ctrl_tx_valid_cpl_ctrl_o      = (fifo_ast_send_st & (fifo_ast_slices_left == 1));

   always @(posedge Clk_i, negedge Rstn_i)
    begin
      if(~Rstn_i)
        fifo_ast_slices_left <= {NUM_SLICES_WIDTH{1'b0}};
      else if (fifo_ast_idle_st & desc_cpl_status_reg[hol_cntr])
        fifo_ast_slices_left <= table_burst_count;
      else if (fifo_ast_send_st & desc_cpl_status_reg[hol_cntr] & ast_rd_fifo_data_tx_ready_i & fifo_ast_slices_left == 1 & two_or_more_burst_count_flag)
        fifo_ast_slices_left <= table_burst_count;
      else if (fifo_ast_send_st)
        fifo_ast_slices_left <= fifo_ast_slices_left - 1;
      else
        fifo_ast_slices_left <= fifo_ast_slices_left;
    end

   always @(posedge Clk_i, negedge Rstn_i)
    begin
      if(~Rstn_i)
        two_or_more_burst_count_flag <= 1'b0;
      else if (fifo_ast_idle_st & desc_cpl_status_reg[hol_cntr] & table_burst_count > 1)
        two_or_more_burst_count_flag <= 1'b1;
      else if (fifo_ast_send_st & desc_cpl_status_reg[hol_cntr] & fifo_ast_slices_left == 1 & two_or_more_burst_count_flag & table_burst_count > 1)
        two_or_more_burst_count_flag <= 1'b1;
      else if((~two_or_more_burst_count_flag | ~desc_cpl_status_reg[hol_cntr]) & fifo_ast_slices_left == 1 & fifo_ast_send_st)
        two_or_more_burst_count_flag <= 1'b0;
      else
        two_or_more_burst_count_flag <= two_or_more_burst_count_flag;
    end

    // Assume fifo_ast interface has ready latency of 3

   always @(posedge Clk_i, negedge Rstn_i)
    begin
      if(~Rstn_i)
        cpl_buffer_rdaddr <= {RXCPL_BUFF_ADDR_WIDTH{1'b0}};
      else if (fifo_ast_idle_st & desc_cpl_status_reg[hol_cntr])
        cpl_buffer_rdaddr <= {{(RXCPL_BUFF_ADDR_WIDTH-HOL_CNTR_WIDTH){1'b0}}, hol_cntr} << NUM_TOTAL_BUFFER_SHIFT;
      else if ((fifo_ast_send_st & fifo_ast_slices_left == 2) & two_or_more_burst_count_flag)  // Always update the address, will check if its ready at slices_left == 1
        cpl_buffer_rdaddr <= {{(RXCPL_BUFF_ADDR_WIDTH-HOL_CNTR_WIDTH){1'b0}}, hol_cntr} << NUM_TOTAL_BUFFER_SHIFT;
      else if (fifo_ast_send_st | (fifo_ast_wait_st & ast_rd_fifo_data_tx_ready_i))
        cpl_buffer_rdaddr <= cpl_buffer_rdaddr + 1;
      else
        cpl_buffer_rdaddr <= cpl_buffer_rdaddr;
    end

   always @(posedge Clk_i, negedge Rstn_i)
    begin
      if(~Rstn_i)
        fifo_ast_table_id <= 8'h0;
      else if (fifo_ast_idle_st & desc_cpl_status_reg[hol_cntr])
        fifo_ast_table_id <= table_id;
      else if (fifo_ast_send_st & desc_cpl_status_reg[hol_cntr] & fifo_ast_slices_left == 1 & two_or_more_burst_count_flag)
        fifo_ast_table_id <= table_id;
      else
        fifo_ast_table_id <= fifo_ast_table_id;
    end

   always @(posedge Clk_i, negedge Rstn_i)
    begin
      if(~Rstn_i)
        fifo_ast_sm <= FIFO_AST_IDLE;
      else
        fifo_ast_sm <= fifo_ast_sm_next_state;
    end

   always @*
     begin
       case(fifo_ast_sm)
         FIFO_AST_IDLE:
           if(desc_cpl_status_reg[hol_cntr])
             fifo_ast_sm_next_state <= FIFO_AST_WAIT;
           else
             fifo_ast_sm_next_state <= FIFO_AST_IDLE;
         FIFO_AST_WAIT:
           if(ast_rd_fifo_data_tx_ready_i)
             fifo_ast_sm_next_state <= FIFO_AST_SEND;
           else
             fifo_ast_sm_next_state <= FIFO_AST_WAIT;
         FIFO_AST_SEND:
           if(~ast_rd_fifo_data_tx_ready_i & fifo_ast_slices_left != 2) // Ready latency of 3 guarantees slices==1 will always be ready
             fifo_ast_sm_next_state <= FIFO_AST_WAIT;
           else if((~two_or_more_burst_count_flag | ~desc_cpl_status_reg[hol_cntr]) & fifo_ast_slices_left == 1)
             fifo_ast_sm_next_state <= FIFO_AST_IDLE;
           else
             fifo_ast_sm_next_state <= FIFO_AST_SEND;
       endcase
     end

  // Completion Control
  always @(posedge Clk_i, negedge Rstn_i)
    begin
      if(~Rstn_i)
        current_processing <= {HOL_CNTR_WIDTH{1'b0}};
      else if (fifo_ast_idle_st & desc_cpl_status_reg[hol_cntr])
        current_processing <= hol_cntr;
      else if (fifo_ast_send_st & desc_cpl_status_reg[hol_cntr] & fifo_ast_slices_left == 1 & two_or_more_burst_count_flag)
        current_processing <= hol_cntr;
      else
        current_processing <= current_processing;
    end

  always @(posedge Clk_i, negedge Rstn_i)
    begin
      if(~Rstn_i)
        hol_cntr <= {HOL_CNTR_WIDTH{1'b0}};
      else if (fifo_ast_idle_st & desc_cpl_status_reg[hol_cntr])
        hol_cntr <= hol_cntr+1;
      else if (fifo_ast_send_st & desc_cpl_status_reg[hol_cntr] & fifo_ast_slices_left == 1 & two_or_more_burst_count_flag)
        hol_cntr <= hol_cntr+1;
      else
        hol_cntr <= hol_cntr;
    end

endmodule
