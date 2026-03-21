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



// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module altera_pcie_sriov_dma_desc_ctl

#(  parameter FUNC_NUM     = 0,
    parameter SRIOV_EN     = 1,
    parameter USER_STATUS  = 1,
    parameter READ_CONTROL = 1,
    parameter DMA_WIDTH    = 128,
    parameter CHANNELIZER_ENABLE = 0
  )
 (
      input logic                                  Clk_i,
      input logic                                  Rstn_i,

      // AVMM Register Slave Port (Write only): Program DT base addresses and EPLAST to Descriptor Controller Registers
      input  logic                                  DCSChipSelect_i,
      input  logic                                  DCSWrite_i,
      input  logic  [4:0]                           DCSAddress_i,
      input  logic  [31:0]                          DCSWriteData_i,
      input  logic  [3:0]                           DCSByteEnable_i,
      output logic                                  DCSWaitRequest_o,


      // AVMM Register Master Port (Write only): Update DMA status into Descriptor Instruction Table

      output   logic [63:0]                         DCMAddress_o,
      output                                        DCMWrite_o,
      output   logic [31:0]                         DCMWriteData_o,
      output                                        DCMRead_o,
      output   logic [3:0]                          DCMByteEnable_o,
      input    logic                                DCMWaitRequest_i,
      input    logic [31:0]                         DCMReadData_i,
      input    logic                                DCMReadDataValid_i,

      /// DT 256-bit slave interface (Write only): DMA-Read returns Descritor Entries to be stored in  dt_fifo

      input  logic                                  DTSChipSelect_i,
      input  logic                                  DTSWrite_i,
      input  logic  [4:0]                           DTSBurstCount_i,
      input  logic  [7:0]                           DTSAddress_i,
      input  logic  [DMA_WIDTH-1:0]                 DTSWriteData_i,
      output logic                                  DTSWaitRequest_o,

      /// DMA programming interface
      output   logic  [167+CHANNELIZER_ENABLE:0]                       DmaTxData_o,
      output   logic                                DmaTxValid_o,
      input    logic                                DmaTxReady_i,

     // DMA Status Interface
      input   logic  [31:0]                         DmaRxData_i,
      input   logic                                 DmaRxValid_i,

    // Send Status to user Interface when done => Function[7:0], Start_addr[63:0], dw_len[17:0]
      output   logic  [95:0]                        DCTxUserData_o,
      output   logic                                DCTxUserValid_o,
      input    logic                                DCTxUserReady_i,

      /// Exclusive Descriptor Fetch AST when Descriptor Table is in the host side

      output   logic  [167+CHANNELIZER_ENABLE:0]                       WrDescTxData_o,
      output   logic                                WrDescTxReq_o,
      input    logic                                WrDescTxAck_i,
      output   logic                                WrDescTxAck_o,
      input    logic                                WrDescTxReq_i,
      input    logic [167+CHANNELIZER_ENABLE:0]                        WrDescTxData_i
 );

 localparam      DTS_IDLE          = 3'h1;
 localparam      DTS_BURST         = 3'h2;
 localparam      DTS_WAIT          = 3'h4;


 localparam       DTM_IDLE         = 2'h1;
 localparam       DTM_WR           = 2'h2;

 localparam       DMA_TX_IDLE     = 6'h01;
 localparam       DMA_TX_FIFO_RD  = 6'h02;
 localparam       DMA_TX_WAIT     = 6'h04;
 localparam       DMA_TX_PROGRAM  = 6'h08;
 localparam       DMA_TX_DT_SEND  = 6'h10;
 localparam       DMA_WRDESC_SEND = 6'h20;

 localparam       MAX_DESC_ENTRY  = 128;

 logic      [7:0]    addr_decode;
 logic               dt_low_src_addr_wen;
 logic               dt_hi_src_addr_wen;
 logic               dt_low_dest_addr_wen;
 logic               dt_hi_dest_addr_wen;
 logic               ep_last_pntr_wen;
 logic      [31:0]   dt_low_src_addr_reg;
 logic      [31:0]   dt_hi_src_addr_reg;
 logic      [31:0]   dt_low_dest_addr_reg;
 logic      [31:0]   dt_hi_dest_addr_reg;
 logic      [31:0]   ep_last_pntr_reg;
 logic      [63:0]   dt_header_base;
 logic      [63:0]   dt_desc_base;
 logic      [ 7:0]   dt_func_no;
 logic               register_access_sreg;
 logic               register_access;
 logic               register_access_reg;
 logic               register_access_rise;
 logic               register_ready_reg;
 logic               dt_fifo_ok;
 logic     [7:0]     dt_fifo_count;
 logic     [2:0]     dts_state;
 logic     [2:0]     dts_nxt_state;
 logic     [4:0]     burst_counter;
 logic               dts_idle;
 logic               dts_ready;
 logic               dt_fifo_wrreq;
 logic               dt_fifo_wrreq_reg;
 logic               dt_fifo_wrreq_reg1;
 logic               dt_fifo_rdreq;
 logic               dt_fifo_empty;
 logic     [159:0]   dt_fifo_data_in;
 logic     [159:0]   dt_fifo_dataq;
 logic     [5:0]     dma_tx_state;
 logic     [5:0]     dma_tx_nxt_state;
 logic               fetch_desc_pending_sreg;
 logic     [167:0]   dt_tx_data;
 logic               desc_fetch_send;
 logic     [7:0]     current_desc_id;
 logic     [7:0]     prev_desc_id_reg;
 logic     [7:0]     sent_dt_size;
 logic     [63:0]    current_dt_address_reg;
 logic               ep_last_fifo_wrreq;
 logic               ep_last_fifo_rdreq;
 logic     [7:0]     ep_last_from_dma;
 logic     [7:0]     ep_last_to_rc;
 logic     [6:0]     ep_last_fifo_count;
 logic     [127:0]   pending_desc_update_array;
 logic     [127:0]   ep_last_fifo_wrreq_array;
 logic     [1:0]     dtm_state;
 logic     [1:0]     dtm_nxt_state;
 logic               is_rd_controller;
 logic               current_desc_poimter_127_flag_reg;
 logic     [63:0]    ep_last_update_address_reg;

 logic     [7:0]     pending_desc_id_reg;
 logic               pending_desc_id_stored;
 logic               pending_desc_id_wen;
 logic     [7:0]     true_desc_id;
 logic               ep_last_pntr_not_from_pending_wen;
 logic               ep_last_pntr_from_pending_wen;
 logic [167:0]       WrDescTxData;

//=========================
// SRIOV signals
 logic               dma_tx_wait_state;
 logic     [1:0]     user_state;
 logic     [1:0]     user_nxt_state;
 logic    [63:0]     start_fpga_addr;
 logic    [17:0]     len_from_dma;
 logic    [81:0]     org_len_addr_r[MAX_DESC_ENTRY]; //83 bits: Original len[17:0], and address[63:0] of this descriptor entry
 logic    [81:0]     matched_len_addr;
 logic    [82:0]     saved_dma_status;
 logic    [ 7:0]     cur_desc_id;
 logic               dma_done_status;
 logic     [127:0]   ep_last_fifo_wrreq_array_reg;

 logic    [82:0]     user_status_q;
 logic               user_status_rdreq;
 logic [6:0]         user_status_fifo_count;
 logic               user_status_fifo_wrreq;
 logic               dma_done_status_reg;
 logic               DCTxUserReady;

// 128 bit interface signals
 logic  [255:0]      DTSWriteData;
 logic  [127:0]      DTSWriteData_reg;
 logic               readvalid_128;

 integer     k, j;
 /// decoding the address


 generate if (READ_CONTROL == 0)
  begin
   assign is_rd_controller = 1'b0;
  end
  else
  begin
   assign is_rd_controller = 1'b1;
end
 endgenerate

 always_comb
  begin
  case (DCSAddress_i)
     5'h00 : addr_decode[7:0] = 8'b0000_0001;
     5'h04 : addr_decode[7:0] = 8'b0000_0010;
     5'h08 : addr_decode[7:0] = 8'b0000_0100;
     5'h0C : addr_decode[7:0] = 8'b0000_1000;
     5'h10 : addr_decode[7:0] = 8'b0001_0000;
     5'h14 : addr_decode[7:0] = 8'b0010_0000;
     5'h18 : addr_decode[7:0] = 8'b0100_0000;
     5'h1C : addr_decode[7:0] = 8'b1000_0000;
     default:addr_decode[7:0] = 8'b0000_0001;
    endcase
  end

assign dt_low_src_addr_wen                = addr_decode[0] & DCSWrite_i & DCSChipSelect_i & register_ready_reg;
assign dt_hi_src_addr_wen                 = addr_decode[1] & DCSWrite_i & DCSChipSelect_i & register_ready_reg;
assign dt_low_dest_addr_wen               = addr_decode[2] & DCSWrite_i & DCSChipSelect_i & register_ready_reg;
assign dt_hi_dest_addr_wen                = addr_decode[3] & DCSWrite_i & DCSChipSelect_i & register_ready_reg;
assign ep_last_pntr_wen                   = ep_last_pntr_not_from_pending_wen | ep_last_pntr_from_pending_wen;

assign ep_last_pntr_not_from_pending_wen  = addr_decode[4] & DCSWrite_i & DCSChipSelect_i & register_ready_reg & ~current_desc_poimter_127_flag_reg;
assign pending_desc_id_wen                = addr_decode[4] & DCSWrite_i & DCSChipSelect_i & register_ready_reg & current_desc_poimter_127_flag_reg;

assign ep_last_pntr_from_pending_wen      = (~current_desc_poimter_127_flag_reg & pending_desc_id_stored) & ~ep_last_pntr_not_from_pending_wen;


assign true_desc_id          = (ep_last_pntr_not_from_pending_wen)? DCSWriteData_i[7:0] : pending_desc_id_reg;

/// Register definition

/// DT source address reg
always_ff @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      dt_low_src_addr_reg <= 32'h0;
    else if(dt_low_src_addr_wen)
      dt_low_src_addr_reg <= DCSWriteData_i;
  end

always_ff @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      dt_hi_src_addr_reg <= 32'h0;
    else if(dt_hi_src_addr_wen)
      dt_hi_src_addr_reg <= DCSWriteData_i;
  end

/// DT Dest address

always_ff @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      dt_low_dest_addr_reg <= 32'h0;
    else if(dt_low_dest_addr_wen)
      dt_low_dest_addr_reg <= DCSWriteData_i;
  end

always_ff @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      dt_hi_dest_addr_reg <= 32'h0;
    else if(dt_hi_dest_addr_wen)
      dt_hi_dest_addr_reg <= DCSWriteData_i;
  end

/// EP last pointer (Index)

always_ff @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      ep_last_pntr_reg <= 32'h0;
    else if(ep_last_pntr_wen)
      ep_last_pntr_reg <= true_desc_id;
  end

always_ff @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      pending_desc_id_reg <= 8'h0;
    else if(pending_desc_id_wen)
      pending_desc_id_reg <= DCSWriteData_i[7:0];
  end

always_ff @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      pending_desc_id_stored <= 1'b0;
    else if(pending_desc_id_wen)
      pending_desc_id_stored <= 1'b1;
    else if (ep_last_pntr_from_pending_wen)
      pending_desc_id_stored <= 1'b0;
  end

assign dt_func_no           = FUNC_NUM;
assign dt_header_base[63:0] = {dt_hi_src_addr_reg, dt_low_src_addr_reg};
assign dt_desc_base[63:0]   = {dt_header_base + 10'h200};

assign register_access = ( DCSWrite_i & DCSChipSelect_i); // & ~current_desc_poimter_127_flag_reg;  // block the write if the current pointer is 127 until it is used

always_ff @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      register_access_reg <= 1'b0;
    else
      register_access_reg <= register_access;
  end

  assign register_access_rise = ~register_access_reg & register_access;

  assign register_ready_reg = register_access_rise;

  assign DCSWaitRequest_o = ~register_ready_reg;

//// The Descriptor Data Table Interface  256-bit Interface

/// Tx control state machine

assign dt_fifo_ok = dt_fifo_count <= 250;

  always @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      burst_counter <= 5'h0;
    else if(dts_idle)
      burst_counter <= DTSBurstCount_i[4:0];
    else if(dts_ready &  DTSWrite_i & DTSChipSelect_i)
      burst_counter <= burst_counter - 1'b1;
  end



always_ff @(posedge Clk_i or negedge Rstn_i)  // state machine registers
  begin
    if(~Rstn_i)
      dts_state <= DTS_IDLE;
    else
      dts_state <= dts_nxt_state;
  end

// state machine next state gen
always_comb
  begin
    case(dts_state)
      DTS_IDLE :
        if(DTSChipSelect_i & DTSWrite_i & dt_fifo_ok)
          dts_nxt_state <= DTS_BURST;
        else
           dts_nxt_state <= DTS_IDLE;

     DTS_BURST:
       if(burst_counter == 1)
         dts_nxt_state <= DTS_IDLE;
       else if(~dt_fifo_ok)
         dts_nxt_state <= DTS_WAIT;
       else
         dts_nxt_state <= DTS_BURST;

     DTS_WAIT:
       if(dt_fifo_ok)
          dts_nxt_state <= DTS_BURST;
       else
         dts_nxt_state <= DTS_WAIT;

    default:
         dts_nxt_state <= DTS_IDLE;

    endcase
end

always_ff @(posedge Clk_i or negedge Rstn_i) begin
   if(~Rstn_i) begin
      readvalid_128 <= 1'b1;
   end
   else if ((dt_fifo_wrreq == 1'b1) && (DMA_WIDTH !=256)) begin
      readvalid_128 <= ~readvalid_128;
   end
end

always_ff @(posedge Clk_i or negedge Rstn_i) begin
   if(~Rstn_i) begin
      DTSWriteData_reg <= 128'h0;
   end
   else begin
      DTSWriteData_reg <=  DTSWriteData_i[127:0];
   end
end

 generate if (DMA_WIDTH == 256) begin
    assign DTSWriteData = DTSWriteData_i ;
 end else begin
    assign DTSWriteData = {DTSWriteData_i, DTSWriteData_reg};
 end
 endgenerate

assign dts_idle =  dts_state[0];
assign dts_ready =  dts_state[1];
assign DTSWaitRequest_o = ~dts_ready;
assign dt_fifo_wrreq = dts_ready &  DTSWrite_i & DTSChipSelect_i ;

//=====================================
// Fix timing on dt_fifo write paths
//=====================================
always_ff @(posedge Clk_i)
  begin
    if(~Rstn_i) begin
      dt_fifo_wrreq_reg <= 1'b0;
      dt_fifo_wrreq_reg1 <= 1'b0;
    end else begin
      dt_fifo_wrreq_reg <= (DMA_WIDTH == 256) ? dt_fifo_wrreq : (dt_fifo_wrreq & readvalid_128);
      dt_fifo_wrreq_reg1 <= dt_fifo_wrreq_reg;
      dt_fifo_data_in   <= DTSWriteData[159:0];
    end
  end


/// DT fifo

  scfifo  dt_fifo (
        .rdreq (dt_fifo_rdreq),
        .clock (Clk_i),
        .wrreq ((DMA_WIDTH == 256) ? dt_fifo_wrreq_reg : dt_fifo_wrreq_reg1),
        .data (dt_fifo_data_in[159:0]),
        .usedw (dt_fifo_count),
        .empty (dt_fifo_empty),
        .q (dt_fifo_dataq),
        .full (),
        .aclr (~Rstn_i),
        .almost_empty (),
        .almost_full (),
        .sclr ()
        );
  defparam
    dt_fifo.add_ram_output_register = "ON",
    dt_fifo.intended_device_family = "Stratix V",
    dt_fifo.lpm_numwords = 256,
    dt_fifo.lpm_showahead = "OFF",
    dt_fifo.lpm_type = "scfifo",
    dt_fifo.lpm_width = 160,
    dt_fifo.lpm_widthu = 8,
    dt_fifo.overflow_checking = "ON",
    dt_fifo.underflow_checking = "ON",
    dt_fifo.use_eab = "ON";


/// state machine to send descriptors to controller to transfer DMA data
// Descriptor TX

always_ff @(posedge Clk_i or negedge Rstn_i)  // state machine registers
  begin
    if(~Rstn_i)
      dma_tx_state <= DMA_TX_IDLE;
    else
      dma_tx_state <= dma_tx_nxt_state;
  end

/*

always_comb
  begin
    case(dma_tx_state)
      DMA_TX_IDLE :
        if(fetch_desc_pending_sreg & DmaTxReady_i)
           dma_tx_nxt_state <= DMA_TX_DT_SEND;  /// send the desc fetch instruction
        else if(~dt_fifo_empty & DmaTxReady_i)
          dma_tx_nxt_state <= DMA_TX_FIFO_RD;
        else
           dma_tx_nxt_state <= DMA_TX_IDLE;

      DMA_TX_FIFO_RD:
        dma_tx_nxt_state <= DMA_TX_WAIT;

      DMA_TX_WAIT:
        dma_tx_nxt_state <= DMA_TX_PROGRAM;

      DMA_TX_PROGRAM:
        dma_tx_nxt_state <= DMA_TX_IDLE;

      DMA_TX_DT_SEND:
         dma_tx_nxt_state <= DMA_TX_IDLE;

      default:
        dma_tx_nxt_state <= DMA_TX_IDLE;

  endcase
end

*/

always_comb
  begin
    case(dma_tx_state)
      DMA_TX_IDLE :
        if(WrDescTxReq_i)
           dma_tx_nxt_state <= DMA_WRDESC_SEND;
        else if(fetch_desc_pending_sreg & is_rd_controller)
           dma_tx_nxt_state <= DMA_TX_DT_SEND;  /// send the desc fetch instruction
        else if(~dt_fifo_empty )
          dma_tx_nxt_state <= DMA_TX_FIFO_RD;
        else
           dma_tx_nxt_state <= DMA_TX_IDLE;

      DMA_TX_FIFO_RD: //[1]
        dma_tx_nxt_state <= DMA_TX_WAIT;

      DMA_TX_WAIT:  //[2]
        dma_tx_nxt_state <= DMA_TX_PROGRAM;

      DMA_TX_PROGRAM: //[3]
        if (DmaTxReady_i) dma_tx_nxt_state <= DMA_TX_IDLE;
        else              dma_tx_nxt_state <= dma_tx_state;

      DMA_TX_DT_SEND: //[4]
        if (DmaTxReady_i) dma_tx_nxt_state <= DMA_TX_IDLE;
        else              dma_tx_nxt_state <= dma_tx_state;

      DMA_WRDESC_SEND: //[5]
        if (DmaTxReady_i) dma_tx_nxt_state <= DMA_TX_IDLE;
        else              dma_tx_nxt_state <= dma_tx_state;

      default:
        dma_tx_nxt_state <= DMA_TX_IDLE;

  endcase
end

assign dt_fifo_rdreq    = dma_tx_state[1];
assign desc_fetch_send  =  dma_tx_state[4] & DmaTxReady_i;
assign dma_tx_wait_state = dma_tx_state[2];

generate if( READ_CONTROL == 1) /// READ combines both DESC + DATA to same port
 begin
   assign DmaTxValid_o  =   dma_tx_state[3] |  dma_tx_state[4] | dma_tx_state[5];
   assign DmaTxData_o   =   dma_tx_state[4] ?  {1'b0,dt_tx_data} : dma_tx_state[5]? {1'b0,WrDescTxData} : {1'b0,dt_func_no, dt_fifo_dataq};
   assign WrDescTxReq_o = 1'b0;
   assign WrDescTxAck_o =  dma_tx_state[5];

    //==================================
    // Register WrDescTxData_i
    //==================================
    always_ff @(posedge Clk_i)
      begin
      if (WrDescTxReq_i)
        WrDescTxData <=  WrDescTxData_i;
    end

 end
else   /// WRITE only fetch real data
 begin
    assign DmaTxValid_o  =   dma_tx_state[3];
    assign DmaTxData_o   =  {1'b0,dt_func_no, dt_fifo_dataq};
 end
endgenerate

generate if( READ_CONTROL == 0)  /// Write control
  begin
   assign WrDescTxData_o        = {1'b0,dt_tx_data};
   assign WrDescTxReq_o         = fetch_desc_pending_sreg;
   assign WrDescTxAck_o         = 1'b0;
  end
endgenerate

/////////////////////////////////////////////////////////////////
/// fetching descriptor logic
/////////////////////////////////////////////////////////////////

/// desc fetch pending reg

generate if(READ_CONTROL == 1)
  begin
   always_ff @(posedge Clk_i or negedge Rstn_i)  // state machine registers
     begin
       if(~Rstn_i)
         fetch_desc_pending_sreg <= 1'b0;
     else if(ep_last_pntr_wen)
         fetch_desc_pending_sreg <= 1'b1;
       else if(desc_fetch_send)
         fetch_desc_pending_sreg <= 1'b0;
     end
  end
else
  begin
   always_ff @(posedge Clk_i or negedge Rstn_i)  // state machine registers
     begin
       if(~Rstn_i)
         fetch_desc_pending_sreg <= 1'b0;
       else if(ep_last_pntr_wen)
         fetch_desc_pending_sreg <= 1'b1;
       else if(WrDescTxAck_i)  // send write descriptor
         fetch_desc_pending_sreg <= 1'b0;
     end
  end
endgenerate


/// Store the last desc ID being fetch

generate if(READ_CONTROL == 1)
  begin
     always_ff @(posedge Clk_i or negedge Rstn_i)  // state machine registers
       begin
         if(~Rstn_i)
           prev_desc_id_reg <= 8'hFF;
         else if(desc_fetch_send)
           prev_desc_id_reg <= (current_desc_id == 127)? 8'hFF : current_desc_id;
       end
  end
else
  begin
     always_ff @(posedge Clk_i or negedge Rstn_i)  // state machine registers
       begin
         if(~Rstn_i)
           prev_desc_id_reg <= 8'hFF;
         else if(WrDescTxAck_i)
           prev_desc_id_reg <= (current_desc_id == 127)? 8'hFF : current_desc_id;
       end
  end
endgenerate


/// calculate the DT size

assign current_desc_id[7:0] = ep_last_pntr_reg[7:0];

assign sent_dt_size[7:0] =  current_desc_id[7:0] - prev_desc_id_reg[7:0];  /// software ensures no roll over

// assign sent_dt_size[7:0] =  8'h8;

/// update the current DT address



generate if(READ_CONTROL == 1)
  begin

     always_ff @(posedge Clk_i or negedge Rstn_i)  // state machine registers
       begin
         if(~Rstn_i)
           current_desc_poimter_127_flag_reg <= 1'b0;
         else if(ep_last_pntr_wen & true_desc_id[7:0] == 127)
           current_desc_poimter_127_flag_reg <= 1'b1;
         else if(desc_fetch_send & current_desc_id == 127 )
            current_desc_poimter_127_flag_reg <= 1'b0;
       end



     always_ff @(posedge Clk_i or negedge Rstn_i)  // state machine registers
       begin
         if(~Rstn_i)
           current_dt_address_reg <= 64'h0;
         else if(dt_low_dest_addr_wen) /// when dest address is written, the src address reg has valid DT base address
           current_dt_address_reg <= dt_desc_base[63:0];
         else if(desc_fetch_send)
           current_dt_address_reg <= (current_desc_id == 127)? dt_desc_base[63:0] : (current_dt_address_reg + {sent_dt_size[7:0], 5'h0});  // size in 8-dw (256-bit)
       end
  end
else
  begin

     always_ff @(posedge Clk_i or negedge Rstn_i)  // state machine registers
       begin
         if(~Rstn_i)
           current_desc_poimter_127_flag_reg <= 1'b0;
         else if(ep_last_pntr_wen & true_desc_id[7:0]  == 127)
           current_desc_poimter_127_flag_reg <= 1'b1;
         else if(WrDescTxAck_i & current_desc_id == 127 )
           current_desc_poimter_127_flag_reg <= 1'b0;
       end


     always_ff @(posedge Clk_i or negedge Rstn_i)  // state machine registers
       begin
         if(~Rstn_i)
           current_dt_address_reg <= 64'h0;
         else if(dt_low_dest_addr_wen) /// when dest address is written, the src address reg has valid DT base address
           current_dt_address_reg <= dt_desc_base[63:0];
         else if(WrDescTxAck_i)
           current_dt_address_reg <= (current_desc_id == 127)? dt_desc_base[63:0] : (current_dt_address_reg + {sent_dt_size[7:0], 5'h0});  // size in 8-dw (256-bit)
       end
  end

endgenerate


/// assemble the DT fetch instruction
generate begin
  if (SRIOV_EN) begin
    assign dt_tx_data[167:0] = { dt_func_no, 6'h0, 8'd128,     // func_no, DID =>     Desc fetch, use ID 128 (127-0) used for  DMA data
                               7'h0, sent_dt_size[7:0], 3'b000 , // size in DW , sent_dt_size in 256-bit
                               dt_hi_dest_addr_reg[31:0], dt_low_dest_addr_reg[31:0],
                               current_dt_address_reg[63:0]};
  end else begin
    assign dt_tx_data[159:0] = {   6'h0, 8'd128,                // Reserved, ID                     /// Desc fetch, use ID 128 (127-0) used for  DMA data
                               7'h0, sent_dt_size[7:0], 3'b000 , // size in DW , sent_dt_size in 256-bit
                               dt_hi_dest_addr_reg[31:0], dt_low_dest_addr_reg[31:0],
                               current_dt_address_reg[63:0]};
    assign dt_tx_data[167:160] = 8'h0;  // function number = 0
  end
end
endgenerate


/// Queue to handle EP last update to software
/// Out of order is handled in software
     altpcie_fifo
   #(
    .FIFO_DEPTH(64),
    .DATA_WIDTH(8)
    )
 ep_last_fifo
(
      .clk(Clk_i),
      .rstn(Rstn_i),
      .srst(1'b0),
      .wrreq(ep_last_fifo_wrreq),
      .rdreq(ep_last_fifo_rdreq),
      .data(ep_last_from_dma),
      .q(ep_last_to_rc),
      .fifo_count(ep_last_fifo_count)
);

 generate
  genvar i;
   begin
    for(i=0; i< 128; i=i+1)
      begin: ep_last_status_flag
        always_ff @(posedge Clk_i or negedge Rstn_i)  // state machine registers
          begin
            if(~Rstn_i)
              pending_desc_update_array[i] <= 1'b0;
            else if(DCSWriteData_i[7:0] == i & ep_last_pntr_not_from_pending_wen)
              pending_desc_update_array[i] <= 1'b1;
            else if(DCSWriteData_i[7:0] == i & pending_desc_id_wen)
              pending_desc_update_array[i] <= 1'b1;
            else if(ep_last_fifo_wrreq_array[i])
              pending_desc_update_array[i] <= 1'b0;
          end

    //===================================================================================
    // DMA is finished and returns status to DC.
    // Check that the DID is matched with the pending bits, and func_num is also matched
    // before sending status to Host and FPGA user logic
    //
        //assign ep_last_fifo_wrreq_array[i] = DmaRxValid_i & ~DmaRxData_i[7] & pending_desc_update_array[i] & DmaRxData_i[6:0] == i;
          assign ep_last_fifo_wrreq_array[i] = DmaRxValid_i & ~DmaRxData_i[7] & pending_desc_update_array[i] & (DmaRxData_i[6:0] == i) & (DmaRxData_i[31:24] == dt_func_no);

          always_ff @(posedge Clk_i or negedge Rstn_i)
            begin
              if(~Rstn_i)
                ep_last_fifo_wrreq_array_reg[i] <= 1'b0;
              else
                ep_last_fifo_wrreq_array_reg[i] <= ep_last_fifo_wrreq_array[i];
            end // always
      end // for
   end
 endgenerate

//=========================================
// Register ep_last_fifo_wrreg for timing
//=========================================
 always @(posedge Clk_i)  // state machine registers
  begin
    if(~Rstn_i) begin
      ep_last_fifo_wrreq <= 1'b0;
    end else begin
      ep_last_fifo_wrreq    <= |ep_last_fifo_wrreq_array[127:0];
      ep_last_from_dma[7:0] <= DmaRxData_i[7:0]; // Descriptor ID
    end
  end


/// DT update EP last logic


// Avalon Master Port  DTM

always_ff @(posedge Clk_i or negedge Rstn_i)  // state machine registers
  begin
    if(~Rstn_i)
      dtm_state <= DTM_IDLE;
    else
      dtm_state <= dtm_nxt_state;
  end


always_comb
  begin
    case(dtm_state)
      DTM_IDLE :
        if(ep_last_fifo_count != 0)
           dtm_nxt_state <= DTM_WR;  /// send the desc fetch instruction
        else
           dtm_nxt_state <= DTM_IDLE;

      DTM_WR:
        if(~DCMWaitRequest_i)
          dtm_nxt_state <= DTM_IDLE;
        else
          dtm_nxt_state <= DTM_WR;

      default:
        dtm_nxt_state <= DTM_IDLE;
    endcase
 end

assign   ep_last_fifo_rdreq   = dtm_state[1] & ~DCMWaitRequest_i;
assign   DCMWrite_o           = dtm_state[1];
assign   DCMRead_o            = 1'b0;
assign   DCMWriteData_o[31:0]      = 32'h1;
assign   DCMByteEnable_o[3:0] = 4'hF;

always_ff @(posedge Clk_i or negedge Rstn_i)  // state machine registers
  begin
    if(~Rstn_i)
      ep_last_update_address_reg <= 64'h0;
    else
      ep_last_update_address_reg <= {dt_hi_src_addr_reg, dt_low_src_addr_reg[31:0]} + {ep_last_to_rc[6:0], 2'b00};
  end

generate begin
  if (SRIOV_EN) begin // Borrow the top 8 bits for function number
    assign   DCMAddress_o[63:0]   = {dt_func_no, ep_last_update_address_reg[55:0]};
  end else begin
    assign   DCMAddress_o[63:0]   = ep_last_update_address_reg;
  end
end
endgenerate

//===================================================================================
// Save FPGA address and length field to return to user later on
// when Descriptor entries are written into dt_fifo
// Move this logic after dt_fifo for timing

assign len_from_dma    = dt_fifo_dataq[145:128];
assign cur_desc_id     = dt_fifo_dataq[153:146];

generate if (READ_CONTROL == 0) begin
  assign start_fpga_addr = dt_fifo_dataq[ 63: 0]; // DMA-Write: Source address
end else begin
  assign start_fpga_addr = dt_fifo_dataq[127:64]; // DMA-Read: Destination address
end
endgenerate

// Save the starting address and length when sending Descriptor Instruction to DMA engine
 generate
  //genvar i;
   begin
    for(i=0; i< MAX_DESC_ENTRY; i=i+1)
      begin: user_status_flag

      always @(posedge Clk_i)
         begin
           if(~Rstn_i)
              org_len_addr_r[i] <=  82'h0;
           else if((cur_desc_id[6:0] == i) & dma_tx_wait_state)
              org_len_addr_r[i] <= {len_from_dma, start_fpga_addr};
         end

      end //for..128
   end
 endgenerate

   //=======================================================================
   // After receiving DMA status from DMA Data Mover
   // Retrieve matched len and DMA Address of current entry from the two dimentional arrays
   //=======================================================================
   always @(*) begin
            matched_len_addr = 82'h0;
            for (k=0; k< MAX_DESC_ENTRY; k= k+1)  // entries
              for (j=0; j< 82; j= j+1) // datawidth
                matched_len_addr[j] = matched_len_addr[j] | ((ep_last_fifo_wrreq_array_reg[k]== 1'b1) && org_len_addr_r[k][j]);
   end

   // PIPE line one cycle for timing
   assign dma_done_status = DmaRxData_i[8] & !DmaRxData_i[18]; // DMA_status[8] = 1 Completion, --DMA_Status[18] = desc_error

///===========================================================
/// Queue to handle EP last update to software
/// This FIFO is needed to save length and starting address to user logic
/// Out of order is handled in software
 generate if (USER_STATUS)
 begin

// Saved DMA status in dma_status_fifo to be send to user => Register for timing
   always @(posedge Clk_i) begin
    if(~Rstn_i)
        user_status_fifo_wrreq <= 1'b0;
    else begin
        user_status_fifo_wrreq <=  |ep_last_fifo_wrreq_array_reg[127:0];
        dma_done_status_reg    <=   dma_done_status;
        saved_dma_status       <= { dma_done_status_reg, matched_len_addr }; //[81:0] = {len, addr}
    end
   end

     altpcie_fifo
   #(
    .FIFO_DEPTH(64),
    .DATA_WIDTH(83)
    )
      dma_status_fifo
      (
      .clk(Clk_i),
      .rstn(Rstn_i),
      .srst(1'b0),
      .wrreq(user_status_fifo_wrreq),
      .rdreq(user_status_rdreq),
      .data(saved_dma_status),
      .q(user_status_q),
      .fifo_count(user_status_fifo_count)
      );
 end else begin
    assign user_status_q = 83'h0;
    assign user_status_fifo_count = 7'h0;
 end
 endgenerate

//============================================================
/// State to update user_status (DCTxUser*)

always @(posedge Clk_i)  // state machine registers
  begin
    if(~Rstn_i)
      user_state <= DTM_IDLE;
    else
      user_state <= user_nxt_state;
  end


always_comb
  begin
    case(user_state)
      DTM_IDLE :
        if(user_status_fifo_count!= 0)
           user_nxt_state <= DTM_WR;  /// send the desc fetch instruction
        else
           user_nxt_state <= DTM_IDLE;

      DTM_WR:
        if(DCTxUserReady)
          user_nxt_state <= DTM_IDLE;
        else
            user_nxt_state <= DTM_WR;

      default:
        user_nxt_state <= DTM_IDLE;
    endcase
 end

assign   user_status_rdreq = user_state[1] & DCTxUserReady;
//===================================================================================
// User Status = {func_no[7:0], len[17:0], addr[63:0]} extracted from dma_status_fifo
// [95:88] = Descriptor Function Number
// [87:83] = Reserved 5 bits
// [82]    = Done Status => 1= success, 0 = Fail
// [81:64] = Original length for this entry
// [63:0]  = FPGA DMA address
//===================================================================================

 generate if (USER_STATUS == 1)
  begin
      assign  DCTxUserReady     =  DCTxUserReady_i;
      assign  DCTxUserValid_o   =  user_status_rdreq;
      assign  DCTxUserData_o    =  {dt_func_no, 5'h0, user_status_q[82:0]};
  end else begin
      assign  DCTxUserReady     =  1'b1;
      assign  DCTxUserValid_o   =  1'b0;
      assign  DCTxUserData_o    =  96'h0;
  end
 endgenerate

endmodule
