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


// (C) 2001-2014 Altera Corporation. All rights reserved.
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


// (C) 2001-2014 Altera Corporation. All rights reserved.
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


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module altpcieav_mc_frag # (
   parameter NUM_ID_PER_CHANNEL              = 8,   // 16 for 2 channels, 8 for 4 channels, 4 for 8 channels
   parameter MAX_DESC_SIZE                   = 4096,
   parameter CHANNEL_ID                      = 0,
   parameter DESC_WIDTH                      = 161,  /// 160 + priority bit
   parameter SRIOV_EN                        = 1
   
   ) (
   input logic                                  Clk_i,
   input logic                                  Rstn_i,

     // Descriptor Interface
   input   logic  [DESC_WIDTH-1:0]              DescInstr_i,
   input   logic                                DescInstrValid_i,
   output  logic                                DescInstrReady_o,

   // Multichannel Arbitration
   output  logic  [1:0]                         PriorQueueReq_o,
   input   logic  [1:0]                         PriorQueueGrant_i,

   /// Prior Queue I
   output logic  [157:0]                       SubDesc_o,
   output logic  [1:0]                         SubDescWrReq_o,

   // Purg request
   input logic                                  PurgeReq_i,
   input logic   [7:0]                          PurgeID_i,
   input logic   [2:0]                          PurgeChannelID_i,

   /// Purge Status

   output  logic                                  FragQueuePurged_o,
   output  logic                                  FragQueuePurgeErr_o,
   output  logic                                  FragQueuePurgedActive_o

);

  localparam  MC_FRAG_IDLE                = 6'h01;
  localparam  MC_FRAG_PIPE                = 6'h02;
  localparam  MC_FRAG_REQ_QUEUE_0         = 6'h04;
  localparam  MC_FRAG_REQ_QUEUE_1         = 6'h08;
  localparam  MC_FRAG_SEND_QUEUE_0        = 6'h10;
  localparam  MC_FRAG_SEND_QUEUE_1        = 6'h20;

  localparam PURGE_FRAG_IDLE              = 6'h01;
  localparam PURGE_FRAG_WAIT              = 6'h02;
  localparam PURGE_FRAG_LATCH_FIFO_COUNT  = 6'h04;
  localparam PURGE_FRAG_CHECK_ID          = 6'h08;
  localparam PURGE_FRAG_STORE             = 6'h10;
  localparam PURGE_FRAG_SUCCESS           = 6'h20;


      //define the clogb2 constant function
   function integer clogb2;
      input [31:0] depth;
      begin
         depth = depth - 1 ;
         for (clogb2 = 0; depth > 0; clogb2 = clogb2 + 1)
           depth = depth >> 1 ;
      end
   endfunction // clogb2

   localparam CHAN_DESC_ID_WIDTH = clogb2(NUM_ID_PER_CHANNEL) ;

  logic    [DESC_WIDTH-1:0]                desc_instr_out;
  logic    [2:0]                           desc_instr_count;
  logic    [7:0]                           orig_desc_id_reg;
  logic                                    desc_priority_reg;
  logic    [63:0]                          cur_src_addr_reg;
  logic    [63:0]                          cur_dest_addr_reg;
  logic    [63:0]                          dest_addr_adder_out;
  logic    [63:0]                          cur_src_addr_adder_out;
  logic    [12:0]                          remain_dw_cntr;
  logic                                    pop_desc_instr;
  logic                                    send_desc;
  logic   [12:0]                           bytes_to_4KB;
  logic   [10:0]                           dw_to_4KB;
  logic                                    sub_desc_size_sel;
  logic                                    to_4KB_sel;
  logic                                    remain_dw_sel;
  logic                                    last_fragment_reg;
  logic   [9:0]                            sent_dw_size;
  logic   [5:0]                            mc_frag_state;
  logic   [5:0]                            mc_frag_nxt_state;
  logic                                    mc_frag_idle_state;
  logic   [3:0]                            sub_desc_id_cntr;
  logic   [157:0]                          sub_desc;
  logic   [1:0]                            priority_queue_wrreq;
  logic                                    mc_desc_queue_empty;
  logic   [3:0]                            sub_desc_id;
  logic   [2:0]                            channel_id;
  logic                                    purge_req_reg;
  logic                                    purge_request_rise;
  logic   [7:0]                            purge_id_reg;
  logic                                    purge_active_sreg;
  logic                                    purge_done;
  logic   [5:0]                            purge_frag_state;
  logic   [5:0]                            purge_frag_nxt_state;
  logic                                    latch_fifo_count;
  logic                                    purge_fifo_rdreq;
  logic                                    purge_fifo_wrreq;
  logic                                    purge_match_found;
  logic   [2:0]                            fifo_line_counter;
  logic   [DESC_WIDTH-1:0]                 desc_instr_in;
  logic   [7:0]                            function_id_reg;

 assign channel_id = (CHANNEL_ID == 0)? 3'h0 :
                     (CHANNEL_ID == 1)? 3'h1 :
                     (CHANNEL_ID == 2)? 3'h2 :
                     (CHANNEL_ID == 3)? 3'h3 :
                     (CHANNEL_ID == 4)? 3'h4 :
                     (CHANNEL_ID == 5)? 3'h5 :
                     (CHANNEL_ID == 6)? 3'h6 :
                     (CHANNEL_ID == 7)? 3'h7 : 3'h0;

    /// Instantiate the shalow FIFO for descriptor

assign desc_instr_in = purge_active_sreg? desc_instr_out : DescInstr_i;

     altpcie_fifo
   #(
    .FIFO_DEPTH(6),
    .DATA_WIDTH(DESC_WIDTH)
    )
 mc_desc_queue
(
      .clk(Clk_i),
      .rstn(Rstn_i),
      .srst(1'b0),
      .wrreq(DescInstrValid_i | purge_fifo_wrreq),
      .rdreq(pop_desc_instr | purge_fifo_rdreq),
      .data(desc_instr_in),
      .q(desc_instr_out),
      .fifo_count(desc_instr_count)
);

 assign mc_desc_queue_empty = (desc_instr_count == 0);
 always_ff @ (posedge Clk_i or negedge Rstn_i)
     begin
       if(~Rstn_i)
         begin
            orig_desc_id_reg     <= 8'h0;
            function_id_reg      <= 8'h0;
            desc_priority_reg    <= 1'b0;
         end

      else if(pop_desc_instr)
        begin
            orig_desc_id_reg     <= desc_instr_out[153:146];
            function_id_reg      <= desc_instr_out[167:160];
            desc_priority_reg    <= (SRIOV_EN==1)? desc_instr_out[168] : desc_instr_out[160];
        end
    end

assign DescInstrReady_o = (desc_instr_count <= 4) & ~purge_active_sreg;

/// Source address Counter
 always_ff @ (posedge Clk_i)
     begin
       if(~Rstn_i)
           cur_src_addr_reg <= 64'h0;
       else if(pop_desc_instr)   /// load the output reg
           cur_src_addr_reg <= desc_instr_out[63:0];
       else if(send_desc)
           cur_src_addr_reg <= cur_src_addr_adder_out;
     end

        lpm_add_sub     LPM_SRC_ADD_SUB_component (
                                .clken (1'b1),
                                .clock (Clk_i),
                                .dataa (cur_src_addr_reg),
                                .datab ({52'h0,sent_dw_size, 2'b00}),
                                .result (cur_src_addr_adder_out),
                                // synopsys translate_off
                                .aclr (),
                                .add_sub (),
                                .cin (),
                                .cout (),
                                .overflow ()
                                // synopsys translate_on
                                );
        defparam
                LPM_SRC_ADD_SUB_component.lpm_direction = "ADD",
                LPM_SRC_ADD_SUB_component.lpm_hint = "ONE_INPUT_IS_CONSTANT=NO,CIN_USED=NO",
                LPM_SRC_ADD_SUB_component.lpm_pipeline = 2,
                LPM_SRC_ADD_SUB_component.lpm_representation = "UNSIGNED",
                LPM_SRC_ADD_SUB_component.lpm_type = "LPM_ADD_SUB",
                LPM_SRC_ADD_SUB_component.lpm_width = 64;

/// Destination Address Counter
always_ff @ (posedge Clk_i)
     begin
       if(~Rstn_i)
           cur_dest_addr_reg <= 64'h0;
       else if(pop_desc_instr)   /// load the output reg
           cur_dest_addr_reg <= desc_instr_out[127:64];
       else if(send_desc)
           cur_dest_addr_reg <= dest_addr_adder_out;
     end

        lpm_add_sub     LPM_DEST_ADD_SUB_component (
                                .clken (1'b1),
                                .clock (Clk_i),
                                .dataa (cur_dest_addr_reg),
                                .datab ({52'h0,sent_dw_size, 2'b00}),
                                .result (dest_addr_adder_out)
                                // synopsys translate_off
                                ,
                                .aclr (),
                                .add_sub (),
                                .cin (),
                                .cout (),
                                .overflow ()
                                // synopsys translate_on
                                );
        defparam
                LPM_DEST_ADD_SUB_component.lpm_direction = "ADD",
                LPM_DEST_ADD_SUB_component.lpm_hint = "ONE_INPUT_IS_CONSTANT=NO,CIN_USED=NO",
                LPM_DEST_ADD_SUB_component.lpm_pipeline = 2,
                LPM_DEST_ADD_SUB_component.lpm_representation = "UNSIGNED",
                LPM_DEST_ADD_SUB_component.lpm_type = "LPM_ADD_SUB",
                LPM_DEST_ADD_SUB_component.lpm_width = 64;

/// remaining DW counter
 always_ff @ (posedge Clk_i)
     begin
        if(pop_desc_instr)   /// load the output reg
           remain_dw_cntr <= desc_instr_out[140:128];
       else if(send_desc)
           remain_dw_cntr <= remain_dw_cntr[12:0] - sent_dw_size[9:0];
     end


//// Selecting the nunmber of DW to send
assign bytes_to_4KB = (cur_src_addr_reg[11:0] == 12'h0)? 13'h1000 : (13'h1000 - cur_src_addr_reg[11:0]);
assign dw_to_4KB    = bytes_to_4KB[12:2];

 assign  to_4KB_sel = (dw_to_4KB <= 128) & (remain_dw_cntr > dw_to_4KB);
 assign  remain_dw_sel = (remain_dw_cntr <= 128) & (remain_dw_cntr <= dw_to_4KB);

  always_ff @ (posedge Clk_i)
            last_fragment_reg <= remain_dw_sel;

 assign sub_desc_size_sel = {to_4KB_sel, remain_dw_sel};


   // mux logic
  always @(sub_desc_size_sel, remain_dw_cntr, dw_to_4KB)
    begin
      case(sub_desc_size_sel)
        2'b01   :    sent_dw_size   = remain_dw_cntr[9:0];
        2'b10   :    sent_dw_size   = dw_to_4KB[9:0];
        default :    sent_dw_size   = 10'd128;
      endcase
    end



/// state machine to fragment the descriptor and send to priority queue

  always_ff @ (posedge Clk_i or negedge Rstn_i)
     begin
       if(~Rstn_i)
           mc_frag_state <= MC_FRAG_IDLE;
         else
            mc_frag_state <= mc_frag_nxt_state;
     end

 always_comb
  begin
    case(mc_frag_state)
      MC_FRAG_IDLE :
        if(~mc_desc_queue_empty)
          mc_frag_nxt_state <= MC_FRAG_PIPE;
        else
          mc_frag_nxt_state <= MC_FRAG_IDLE;

      MC_FRAG_PIPE:
        if(desc_priority_reg == 1'b0)
          mc_frag_nxt_state <= MC_FRAG_REQ_QUEUE_0;
        else
           mc_frag_nxt_state <= MC_FRAG_REQ_QUEUE_1;

     MC_FRAG_REQ_QUEUE_0:
       if(PriorQueueGrant_i[0])
           mc_frag_nxt_state <= MC_FRAG_SEND_QUEUE_0;
       else
           mc_frag_nxt_state <= MC_FRAG_REQ_QUEUE_0;

     MC_FRAG_REQ_QUEUE_1:
       if(PriorQueueGrant_i[1])
           mc_frag_nxt_state <= MC_FRAG_SEND_QUEUE_1;
       else
           mc_frag_nxt_state <= MC_FRAG_REQ_QUEUE_1;

    MC_FRAG_SEND_QUEUE_0:
      if(last_fragment_reg)
         mc_frag_nxt_state <= MC_FRAG_IDLE;
      else
         mc_frag_nxt_state <= MC_FRAG_REQ_QUEUE_0;

    MC_FRAG_SEND_QUEUE_1:
      if(last_fragment_reg)
         mc_frag_nxt_state <= MC_FRAG_IDLE;
      else
         mc_frag_nxt_state <= MC_FRAG_REQ_QUEUE_1;

   default:
        mc_frag_nxt_state <= MC_FRAG_IDLE;

  endcase
end

assign  mc_frag_idle_state = mc_frag_state[0];
assign  pop_desc_instr = ~mc_desc_queue_empty &  mc_frag_idle_state;
assign  PriorQueueReq_o[0] = (mc_frag_state == MC_FRAG_REQ_QUEUE_0);
assign  PriorQueueReq_o[1] = (mc_frag_state == MC_FRAG_REQ_QUEUE_1);
assign  send_desc =|mc_frag_state[5:4];

/// Sub desc ID counter
// each sub ID sends 512B of data
// 4KB paypoad max, so there are max 8 sub ID per original ID
 always_ff @ (posedge Clk_i)
     begin
      if(pop_desc_instr)   /// load the output reg
           sub_desc_id_cntr[2:0] <= 0;
       else if(send_desc)
           sub_desc_id_cntr <= sub_desc_id_cntr + 1;
     end

/// forming sub descriptors
//                                 149                                                     [148:141]                           [140:138]                    [137:128]                127:64             63:0

assign sub_desc[157:0]    = {function_id_reg, last_fragment_reg, {(5-CHAN_DESC_ID_WIDTH){1'b0}}, channel_id[2:0],orig_desc_id_reg[CHAN_DESC_ID_WIDTH-1:0],sub_desc_id_cntr[2:0], sent_dw_size[9:0] ,cur_dest_addr_reg, cur_src_addr_reg};
assign priority_queue_wrreq[0] =  (mc_frag_state == MC_FRAG_SEND_QUEUE_0);
assign priority_queue_wrreq[1] =  (mc_frag_state == MC_FRAG_SEND_QUEUE_1);


 always_ff @ (posedge Clk_i or negedge Rstn_i)
     begin
       if(~Rstn_i)
         begin
           SubDesc_o      <=  158'h0;
        end
       else if(send_desc)
         begin
           SubDesc_o           <=  sub_desc;
         end
     end

always_ff @ (posedge Clk_i or negedge Rstn_i)
     begin
       if(~Rstn_i)
         begin
           SubDescWrReq_o[1:0] <= 2'b00;
        end
       else 
         begin
           SubDescWrReq_o[1:0] <=  priority_queue_wrreq[1:0];
         end
     end

// Purging descriptor logic
always_ff @ (posedge Clk_i or negedge Rstn_i)
     begin
       if(~Rstn_i)
           purge_req_reg      <=  1'b0;
       else
           purge_req_reg       <=  PurgeReq_i;
     end

assign purge_request_rise = ~purge_req_reg & PurgeReq_i;

 always_ff @ (posedge Clk_i or negedge Rstn_i)
     begin
       if(~Rstn_i)
           purge_id_reg      <=  8'h0;
       else if(purge_request_rise)
           purge_id_reg       <=  PurgeID_i;
     end

always_ff @ (posedge Clk_i or negedge Rstn_i)
     begin
       if(~Rstn_i)
          purge_active_sreg      <=  1'b0;
       else if(purge_request_rise)
           purge_active_sreg       <=  1'b1;
       else if(purge_done)
           purge_active_sreg      <= 1'b0;
       end

assign FragQueuePurgedActive_o = purge_active_sreg;

  always_ff @ (posedge Clk_i or negedge Rstn_i)
     begin
       if(~Rstn_i)
           purge_frag_state <= PURGE_FRAG_IDLE;
         else
            purge_frag_state <= purge_frag_nxt_state;
     end


 always_comb
  begin
    case(purge_frag_state)
      PURGE_FRAG_IDLE :
        if(purge_request_rise & PurgeChannelID_i == channel_id)
          purge_frag_nxt_state <= PURGE_FRAG_WAIT;
        else
          purge_frag_nxt_state <= PURGE_FRAG_IDLE;

      PURGE_FRAG_WAIT:
        if(mc_frag_idle_state)
          purge_frag_nxt_state <= PURGE_FRAG_LATCH_FIFO_COUNT;
        else
           purge_frag_nxt_state <= PURGE_FRAG_WAIT;

      PURGE_FRAG_LATCH_FIFO_COUNT:
        purge_frag_nxt_state <= PURGE_FRAG_CHECK_ID;

      PURGE_FRAG_CHECK_ID:
        if(desc_instr_out[153:146] != purge_id_reg[7:0])    // no match, recycle
          purge_frag_nxt_state <= PURGE_FRAG_STORE;
        else  // match found
          purge_frag_nxt_state <= PURGE_FRAG_SUCCESS;

      PURGE_FRAG_STORE:
        if(fifo_line_counter == 3'h0)
          purge_frag_nxt_state <= PURGE_FRAG_IDLE;
        else
         purge_frag_nxt_state <= PURGE_FRAG_CHECK_ID;

     PURGE_FRAG_SUCCESS:
          purge_frag_nxt_state <= PURGE_FRAG_IDLE;

     default:
       purge_frag_nxt_state <= PURGE_FRAG_IDLE;
  endcase
end

assign latch_fifo_count = (purge_frag_state == PURGE_FRAG_LATCH_FIFO_COUNT);
assign purge_fifo_rdreq = (purge_frag_state == PURGE_FRAG_CHECK_ID);
assign purge_fifo_wrreq = (purge_frag_state == PURGE_FRAG_STORE);
assign purge_match_found = (purge_frag_state == PURGE_FRAG_SUCCESS);
assign purge_done =  (purge_frag_state == PURGE_FRAG_STORE) & (fifo_line_counter == 3'h0) | purge_match_found;

/// latching the fifo count and count down as it searches trhough the FIFO

  always_ff @ (posedge Clk_i or negedge Rstn_i)
     begin
       if(~Rstn_i)
                     fifo_line_counter <= 3'h0;
         else if(latch_fifo_count)
           fifo_line_counter <= desc_instr_count;
         else if(purge_fifo_rdreq)
           fifo_line_counter <= fifo_line_counter - 1;
     end

assign FragQueuePurged_o   =  purge_match_found;
assign FragQueuePurgeErr_o = (purge_frag_state == PURGE_FRAG_STORE) & (fifo_line_counter == 3'h0);

endmodule
