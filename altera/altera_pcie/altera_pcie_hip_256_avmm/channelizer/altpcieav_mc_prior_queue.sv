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

  module altpcieav_mc_prior_queue # (
      parameter NUMBER_OF_CHANNELS                        = 4,
      parameter NUM_ID_PER_CHANNEL              = 8,
      parameter PRIORITY_WEIGHT                 = 4,  /// every 4, 8 or 0 for infinite
      parameter SRIOV_EN           = 1,
      parameter DESC_WIDTH         = 161  /// 160 + priority bit
   )

      (
    input logic                                  Clk_i,
    input logic                                  Rstn_i,

     /// Prior Queue input
     input    logic  [157:0]                     SubDesc_i,
     input    logic  [1:0]                       SubDescWrReq_i,
     output   logic  [DESC_WIDTH-2:0]            DmaRxData_o,
     output   logic                              DmaRxValid_o,
     input    logic                              DmaRxReady_i,

     input    logic  [31:0]                      DmaTxData_i,
     input    logic                              DmaTxValid_i,

     output   logic  [31:0]                      DmaTxData_o,
     output   logic  [7:0]                       DmaTxValid_o,


  // Purg request
     input logic                                 PurgeReq_i,
     input logic   [2:0]                         PurgeChannelID_i,
     input logic   [7:0]                         PurgeID_i,

     /// Purge Status
     output  logic                               PriorQueuePurged_o,
     output  logic                               PriorQueuePurgeErr_o,
     output  logic                               PriorQueuePurgedActive_o,

     input   logic                               PurgeStatusReq_i,
     input   logic  [7:0]                        PurgeStatus_i,
     output  logic                               PurgeStatusAck_o


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

   localparam CHAN_DESC_ID_WIDTH = clogb2(NUM_ID_PER_CHANNEL) ;
   localparam PRIOR_CNTR_WIDTH   = clogb2(PRIORITY_WEIGHT);


    logic                                        queue0_rdreq;
    logic            [8:0]                       queue0_usedw;
    logic                                        queue0_empty;
    logic            [157:0]                     queue0_dataout;

    logic                                        queue1_rdreq;
    logic            [8:0]                       queue1_usedw;
    logic                                        queue1_empty;
    logic            [157:0]                     queue1_dataout;
    logic            [PRIOR_CNTR_WIDTH-1:0]      prior_cntr;
    logic            [6:0]                       prior_queue_nxt_state;
    logic            [6:0]                       prior_queue_state;

    logic            [63:0]                      src_address_0;
    logic            [63:0]                      dest_address_0;
    logic            [17:0]                      dw_count_0;
    logic            [7:0]                       desc_id_0;
    logic                                        last_sub_desc_0;
    logic            [7:0]                       orig_desc_id_0;
    logic            [7:0]                       function_id_0;
    logic            [63:0]                      src_address_1;
    logic            [63:0]                      dest_address_1;
    logic            [17:0]                      dw_count_1;
    logic            [7:0]                       desc_id_1;
    logic                                        last_sub_desc_1;
    logic            [7:0]                       orig_desc_id_1;
    logic            [7:0]                       function_id_1;

    logic            [4:0]                       orig_desc_id_reg;
    logic                                        last_sub_desc_reg ;
    logic                                        status_valid_reg;
    logic            [7:0]                       status_data_reg;  
    logic            [7:0]                       func_data_reg;
    logic            [3:0]                       status_counter[31:0];
    logic            [31:0]                      last_completion_pending;
    logic            [31:0]                      orig_desc_release;
    logic            [7:0]                       orig_desc_released_id;
    logic            [31:0]                       released_desc_out;
    logic            [2:0]                       released_desc_connt;
    logic                                        release_pending_reg;
    logic            [31:0]                      status_received;
    logic                                        purge_req_reg;
    logic                                        purge_request_rise;
    logic            [7:0]                       purge_id_reg;
    logic            [2:0]                       purge_channel_reg;
    logic                                        purge_active_sreg;
    logic                                        purge_done;
    logic            [9:0]                       purge_prior_state;
    logic            [9:0]                       purge_prior_nxt_state;
    logic                                        latch_fifo_count0;
    logic                                        purge_fifo_rdreq0;
    logic                                        purge_fifo_wrreq0;
    logic                                        purge_match_found0;
    logic                                        latch_fifo_count1;
    logic                                        purge_fifo_rdreq1;
    logic                                        purge_fifo_wrreq1;
    logic                                        purge_match_found1;
    logic                                        match_found_sreg;
    logic                                        match_found_sreg2;
    logic                                        match_found_rise;
    logic            [2:0]                       fifo_line_counter;
    logic            [157:0]                     prior_queue_0_in;
    logic            [157:0]                     prior_queue_1_in;
    logic                                        queue0_load;
    logic                                        queue1_load;
    logic                                        queue0_send;
    logic                                        queue1_send;
    logic                                        purge_ack_reg;
    logic                                        priority_infinit;
    logic            [31:0]                      desc_release_fifo_in;  
    logic            [7:0]                       SRIOVTxValid_o;
    logic            [7:0]                       MoverTxValid_o;        
    logic            [31:0]                      sucess_status;                      
    logic            [CHAN_DESC_ID_WIDTH-1:0]      released_desc_id;         
    logic            [7:0]                       released_func_id;


localparam  PRIOR_QUEUE_IDLE              = 6'h01;
localparam  PRIOR_QUEUE0_READ             = 6'h02;
localparam  PRIOR_QUEUE0_LOAD             = 6'h04;
localparam  PRIOR_QUEUE0_SEND             = 6'h08;
localparam  PRIOR_QUEUE1_READ             = 6'h02;
localparam  PRIOR_QUEUE1_LOAD             = 6'h04;
localparam  PRIOR_QUEUE1_SEND             = 6'h08;

localparam PURGE_PRIOR_IDLE               = 10'h001;
localparam PURGE_PRIOR_WAIT               = 10'h002;
localparam PURGE_PRIOR_LATCH_FIFO_COUNT0  = 10'h004;
localparam PURGE_PRIOR_CHECK_ID0          = 10'h008;
localparam PURGE_PRIOR_STORE0             = 10'h010;
localparam PURGE_PRIOR_SUCCESS0           = 10'h020;
localparam PURGE_PRIOR_LATCH_FIFO_COUNT1  = 10'h040;
localparam PURGE_PRIOR_CHECK_ID1          = 10'h080;
localparam PURGE_PRIOR_STORE1             = 10'h100;
localparam PURGE_PRIOR_SUCCESS1           = 10'h200;


assign priority_infinit = (PRIORITY_WEIGHT == 0)? 1'b1 : 1'b0;

   /// Priority Queue 0 instantiation
        scfifo  mc_prior_queue_0 (
                                .rdreq (queue0_rdreq),
                                .clock (Clk_i),
                                .wrreq (SubDescWrReq_i[0] | purge_fifo_wrreq0),
                                .data (prior_queue_0_in),
                                .usedw (queue0_usedw),
                                .empty (queue0_empty),
                                .q (queue0_dataout),
                                .full (),
                                .aclr (~Rstn_i),
                                .almost_empty (),
                                .almost_full (),
                                .sclr ()
                                );
        defparam
                mc_prior_queue_0.add_ram_output_register = "ON",
                mc_prior_queue_0.intended_device_family = "Stratix V",
                mc_prior_queue_0.lpm_numwords = 512,
                mc_prior_queue_0.lpm_showahead = "OFF",
                mc_prior_queue_0.lpm_type = "scfifo",
                mc_prior_queue_0.lpm_width = 158,
                mc_prior_queue_0.lpm_widthu = 9,
                mc_prior_queue_0.overflow_checking = "ON",
                mc_prior_queue_0.underflow_checking = "ON",
                mc_prior_queue_0.use_eab = "ON";

assign prior_queue_0_in = purge_fifo_wrreq0? queue0_dataout: SubDesc_i;

 /// Priority Queue 1 instantiation
        scfifo  mc_prior_queue_1 (
                                .rdreq (queue1_rdreq),
                                .clock (Clk_i),
                                .wrreq (SubDescWrReq_i[1] |purge_fifo_wrreq1 ),
                                .data (prior_queue_1_in),
                                .usedw (queue1_usedw),
                                .empty (queue1_empty),
                                .q (queue1_dataout),
                                .full (),
                                .aclr (~Rstn_i),
                                .almost_empty (),
                                .almost_full (),
                                .sclr ()
                                );
        defparam
                mc_prior_queue_1.add_ram_output_register = "ON",
                mc_prior_queue_1.intended_device_family = "Stratix V",
                mc_prior_queue_1.lpm_numwords = 512,
                mc_prior_queue_1.lpm_showahead = "OFF",
                mc_prior_queue_1.lpm_type = "scfifo",
                mc_prior_queue_1.lpm_width = 158,
                mc_prior_queue_1.lpm_widthu = 9,
                mc_prior_queue_1.overflow_checking = "ON",
                mc_prior_queue_1.underflow_checking = "ON",
                mc_prior_queue_1.use_eab = "ON";


assign prior_queue_1_in = purge_fifo_wrreq1? queue1_dataout: SubDesc_i;

/// Schedule to transmit Weighted priority Queues
 always_ff @ (posedge Clk_i or negedge Rstn_i)
  begin
   if(~Rstn_i)
     prior_cntr <= 0;
   else 
     prior_cntr <= prior_cntr + 1'b1;
  end
     

/// state machine to schedule sending the descriptors

  always_ff @ (posedge Clk_i or negedge Rstn_i)
     begin
       if(~Rstn_i)
           prior_queue_state <= PRIOR_QUEUE_IDLE;
         else
            prior_queue_state <= prior_queue_nxt_state;
     end

 always_comb
  begin
    case(prior_queue_state)
      PRIOR_QUEUE_IDLE :
        if((~queue0_empty & ~purge_active_sreg) & (prior_cntr != 0 | priority_infinit))
          prior_queue_nxt_state <= PRIOR_QUEUE0_READ;
        else if(~queue1_empty & ~purge_active_sreg)
          prior_queue_nxt_state <= PRIOR_QUEUE1_READ;
        else
          prior_queue_nxt_state <= PRIOR_QUEUE_IDLE;

      PRIOR_QUEUE0_READ:
           prior_queue_nxt_state <= PRIOR_QUEUE0_LOAD;

     PRIOR_QUEUE0_LOAD:
       if(DmaRxReady_i)
           prior_queue_nxt_state <= PRIOR_QUEUE0_SEND;
       else
           prior_queue_nxt_state <= PRIOR_QUEUE0_LOAD;

     PRIOR_QUEUE0_SEND:
       prior_queue_nxt_state <= PRIOR_QUEUE_IDLE;

     PRIOR_QUEUE1_READ:
           prior_queue_nxt_state <= PRIOR_QUEUE1_LOAD;

     PRIOR_QUEUE1_LOAD:
       if(DmaRxReady_i)
           prior_queue_nxt_state <= PRIOR_QUEUE1_SEND;
       else
           prior_queue_nxt_state <= PRIOR_QUEUE1_LOAD;

     PRIOR_QUEUE1_SEND:
       prior_queue_nxt_state <= PRIOR_QUEUE_IDLE;

   default:
         prior_queue_nxt_state <= PRIOR_QUEUE_IDLE;

  endcase
end

assign queue0_rdreq = prior_queue_state == PRIOR_QUEUE0_READ;
assign queue0_load  = prior_queue_state == PRIOR_QUEUE0_LOAD;
assign queue0_send  = prior_queue_state == PRIOR_QUEUE0_SEND;
assign queue1_rdreq = prior_queue_state == PRIOR_QUEUE1_READ;
assign queue1_load  = prior_queue_state == PRIOR_QUEUE1_LOAD;
assign queue1_send  = prior_queue_state == PRIOR_QUEUE1_SEND;

/// output descripter registers

assign src_address_0    = queue0_dataout[63:0];
assign dest_address_0   = queue0_dataout[127:64];
assign dw_count_0[17:0] =  {8'h0,queue0_dataout[137:128]};
assign desc_id_0[7:0]   = queue0_dataout[145:138];
assign last_sub_desc_0  = queue0_dataout[149];
assign orig_desc_id_0   = queue0_dataout[148:141];
assign function_id_0    = queue0_dataout[157:150];


assign src_address_1  = queue1_dataout[63:0];
assign dest_address_1 = queue1_dataout[127:64];
assign dw_count_1[17:0] =  {8'h0,queue1_dataout[137:128]};
assign desc_id_1[7:0]   = queue1_dataout[145:138];
assign last_sub_desc_1  = queue1_dataout[149];
assign orig_desc_id_1   = queue1_dataout[148:141];
assign function_id_1    = queue1_dataout[157:150];


 always_ff @ (posedge Clk_i)
     begin
        if(queue0_load)
          begin
            DmaRxData_o <= {function_id_0,6'h0 ,desc_id_0[7:0], dw_count_0[17:0], dest_address_0, src_address_0};
            orig_desc_id_reg[4:0] <=  orig_desc_id_0[4:0];
            last_sub_desc_reg    <=  last_sub_desc_0;
          end
        else if(queue1_load)
          begin
            DmaRxData_o <=  {function_id_1, 6'h0 ,desc_id_1[7:0], dw_count_1[17:0], dest_address_1, src_address_1};
            orig_desc_id_reg[4:0] <=  orig_desc_id_1[4:0];
            last_sub_desc_reg    <=  last_sub_desc_1;
          end
     end


 assign DmaRxValid_o = queue0_send | queue1_send;

/// Counters to keep track of completion

always_ff @ (posedge Clk_i or negedge Rstn_i)   /// flag indicates that all sub desc for an original desc have been sent
   begin
         if(~Rstn_i)
           begin
             status_valid_reg <= 1'b0;
             status_data_reg  <= 8'h0;   
           end
         else
           begin
             status_valid_reg <= DmaTxValid_i;
             status_data_reg  <= DmaTxData_i[7:0];   
           end
 end


always_ff @ (posedge Clk_i or negedge Rstn_i)   /// flag indicates that all sub desc for an original desc have been sent
   begin
         if(~Rstn_i)
           begin
             func_data_reg <= 8'h0;
           end
         else
           begin
             func_data_reg <= (SRIOV_EN==1)? DmaTxData_i[31:24] : 8'h0; 
           end
 end


/// There are 32 status counters, each keeps count for one origninal descriptor ID
/// when a sub descripor is sent with matched id, the assiciated counter increments
/// each done status with matched id, the counter decrements

generate
 genvar j;
 for(j=0; j < 32; j=j+1)
 begin: completion_status_counter

 always_ff @ (posedge Clk_i or negedge Rstn_i)
   begin
         if(~Rstn_i)
            status_counter[j] <= 4'h0;
     else if((orig_desc_id_reg[4:0] == j & DmaRxValid_o) & ~(DmaTxData_i[7:3] == j & DmaTxValid_i))
       status_counter[j] <= status_counter[j] + 1'b1;
     else if((DmaTxData_i[7:3] == j & DmaTxValid_i) & ~(orig_desc_id_reg[4:0] == j & DmaRxValid_o))
        status_counter[j] <= status_counter[j] - 1'b1;
     else if(orig_desc_release[j])
       status_counter[j] <= 4'h0;
   end

 always_ff @ (posedge Clk_i or negedge Rstn_i)   /// flag indicates that all sub desc for an original desc have been sent
   begin
         if(~Rstn_i)
            last_completion_pending[j] <= 1'b0;
         else if(orig_desc_id_reg[4:0] == j & DmaRxValid_o & last_sub_desc_reg )
            last_completion_pending[j] <= 1'b1;
         else if(orig_desc_release[j])
             last_completion_pending[j] <= 1'b0;
   end

   assign status_received[j] = status_data_reg[7:3] == j & status_valid_reg;
   assign orig_desc_release[j] = status_received[j] & last_completion_pending[j] & status_counter[j] == 0;
  end
endgenerate

assign desc_release = (|orig_desc_release[31:0] & status_valid_reg) | purge_ack_reg;
/// decoding the original desc status from the desc id from data mover

assign orig_desc_released_id[7:0] = {3'h0,status_data_reg[7:3]};
assign sucess_status =     {func_data_reg[7:0], 15'h0,1'b1, orig_desc_released_id[7:0]};
assign desc_release_fifo_in = purge_ack_reg? {24'h0,PurgeStatus_i} : sucess_status;

// write the orig release id to the Queue
     altpcie_fifo
   #(
    .FIFO_DEPTH(6),
    .DATA_WIDTH(32)
    )
 release_desc_queue
(
      .clk(Clk_i),
      .rstn(Rstn_i),
      .srst(1'b0),
      .wrreq(desc_release),
      .rdreq(release_pending_reg),
      .data(desc_release_fifo_in),
      .q(released_desc_out),
      .fifo_count(released_desc_connt)
);


/// generate the status update to external controller
always_ff @ (posedge Clk_i or negedge Rstn_i)   /// generate a pulse if the fifo is not empty
   begin
         if(~Rstn_i)
             release_pending_reg <= 1'b0;
         else if(release_pending_reg)
              release_pending_reg <= 1'b0;
        else if(released_desc_connt != 0)
              release_pending_reg <= 1'b1;
 end
 
  assign released_func_id = released_desc_out[31:24];
  assign released_desc_id =  released_desc_out[CHAN_DESC_ID_WIDTH-1:0];
  
 

   assign  DmaTxData_o = {released_func_id[7:0],16'h1,{(8-CHAN_DESC_ID_WIDTH){1'b0}},released_desc_id};  

   /// demuxing the status
 generate if(NUMBER_OF_CHANNELS == 2)
     begin
       assign MoverTxValid_o[0] = ~released_desc_out[7] & release_pending_reg;
       assign MoverTxValid_o[1] =  released_desc_out[7] & release_pending_reg;
       assign MoverTxValid_o[2] = 1'b0;
       assign MoverTxValid_o[3] = 1'b0;
       assign MoverTxValid_o[4] = 1'b0;
       assign MoverTxValid_o[5] = 1'b0;
       assign MoverTxValid_o[6] = 1'b0;
       assign MoverTxValid_o[7] = 1'b0;
     end
  endgenerate

 generate if(NUMBER_OF_CHANNELS == 4)
     begin
       assign MoverTxValid_o[0] =  released_desc_out[7:6] == 2'b00 & release_pending_reg;
       assign MoverTxValid_o[1] =  released_desc_out[7:6] == 2'b01 & release_pending_reg;
       assign MoverTxValid_o[2] =  released_desc_out[7:6] == 2'b10 & release_pending_reg;
       assign MoverTxValid_o[3] =  released_desc_out[7:6] == 2'b11 & release_pending_reg;
       assign MoverTxValid_o[4] = 1'b0;
       assign MoverTxValid_o[5] = 1'b0;
       assign MoverTxValid_o[6] = 1'b0;
       assign MoverTxValid_o[7] = 1'b0;
     end
  endgenerate

    generate if(NUMBER_OF_CHANNELS == 8)
     begin
       assign MoverTxValid_o[0] =  released_desc_out[7:5] == 3'b000 & release_pending_reg;
       assign MoverTxValid_o[1] =  released_desc_out[7:5] == 3'b001 & release_pending_reg;
       assign MoverTxValid_o[2] =  released_desc_out[7:5] == 3'b010 & release_pending_reg;
       assign MoverTxValid_o[3] =  released_desc_out[7:5] == 3'b011 & release_pending_reg;
       assign MoverTxValid_o[4] =  released_desc_out[7:5] == 3'b100 & release_pending_reg;
       assign MoverTxValid_o[5] =  released_desc_out[7:5] == 3'b101 & release_pending_reg;
       assign MoverTxValid_o[6] =  released_desc_out[7:5] == 3'b110 & release_pending_reg;
       assign MoverTxValid_o[7] =  released_desc_out[7:5] == 3'b111 & release_pending_reg;
     end
  endgenerate

// SRIOV Status valid

 generate if(NUMBER_OF_CHANNELS == 2)
     begin
       assign SRIOVTxValid_o[0] =  released_func_id == 8'd128 & release_pending_reg;
       assign SRIOVTxValid_o[1] =  released_func_id == 8'd129 & release_pending_reg;
       assign SRIOVTxValid_o[2] = 1'b0;
       assign SRIOVTxValid_o[3] = 1'b0;
       assign SRIOVTxValid_o[4] = 1'b0;
       assign SRIOVTxValid_o[5] = 1'b0;
       assign SRIOVTxValid_o[6] = 1'b0;
       assign SRIOVTxValid_o[7] = 1'b0;
     end
  endgenerate

 generate if(NUMBER_OF_CHANNELS == 4)
     begin
       assign SRIOVTxValid_o[0] =  released_func_id == 8'd128 & release_pending_reg;
       assign SRIOVTxValid_o[1] =  released_func_id == 8'd129 & release_pending_reg;
       assign SRIOVTxValid_o[2] =  released_func_id == 8'd130 & release_pending_reg;
       assign SRIOVTxValid_o[3] =  released_func_id == 8'd131 & release_pending_reg;
       assign SRIOVTxValid_o[4] = 1'b0;
       assign SRIOVTxValid_o[5] = 1'b0;
       assign SRIOVTxValid_o[6] = 1'b0;
       assign SRIOVTxValid_o[7] = 1'b0;
     end
  endgenerate

    generate if(NUMBER_OF_CHANNELS == 8)
     begin
       assign SRIOVTxValid_o[0] =  released_func_id == 8'd128 & release_pending_reg; 
       assign SRIOVTxValid_o[1] =  released_func_id == 8'd129 & release_pending_reg; 
       assign SRIOVTxValid_o[2] =  released_func_id == 8'd130 & release_pending_reg; 
       assign SRIOVTxValid_o[3] =  released_func_id == 8'd131 & release_pending_reg; 
       assign SRIOVTxValid_o[4] =  released_func_id == 8'd132 & release_pending_reg;   
       assign SRIOVTxValid_o[5] =  released_func_id == 8'd133 & release_pending_reg;   
       assign SRIOVTxValid_o[6] =  released_func_id == 8'd134 & release_pending_reg;   
       assign SRIOVTxValid_o[7] =  released_func_id == 8'd135 & release_pending_reg;   
     end
  endgenerate
   
assign DmaTxValid_o[7:0] = SRIOV_EN? SRIOVTxValid_o[7:0] : MoverTxValid_o[7:0];

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
         begin
           purge_id_reg      <=  8'h0;
           purge_channel_reg <= 3'h0;
         end
       else if(purge_request_rise)
         begin
           purge_id_reg       <=  PurgeID_i;
           purge_channel_reg  <=  PurgeChannelID_i;
         end
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

assign PriorQueuePurgedActive_o = purge_active_sreg;

  always_ff @ (posedge Clk_i or negedge Rstn_i)
     begin
       if(~Rstn_i)
           purge_prior_state <= PURGE_PRIOR_IDLE;
         else
            purge_prior_state <= purge_prior_nxt_state;
     end

 always_comb
  begin
    case(purge_prior_state)
      PURGE_PRIOR_IDLE :
        if(purge_request_rise)
          purge_prior_nxt_state <= PURGE_PRIOR_WAIT;
        else
          purge_prior_nxt_state <= PURGE_PRIOR_IDLE;

      PURGE_PRIOR_WAIT:
        if(prior_queue_state == PRIOR_QUEUE_IDLE)
          purge_prior_nxt_state <= PURGE_PRIOR_LATCH_FIFO_COUNT0;
        else
           purge_prior_nxt_state <= PURGE_PRIOR_WAIT;

      PURGE_PRIOR_LATCH_FIFO_COUNT0:
        purge_prior_nxt_state <= PURGE_PRIOR_CHECK_ID0;

      PURGE_PRIOR_CHECK_ID0:
        if((orig_desc_id_0[CHAN_DESC_ID_WIDTH-1:0] != purge_id_reg[CHAN_DESC_ID_WIDTH-1:0]) && (orig_desc_id_0[CHAN_DESC_ID_WIDTH+2:CHAN_DESC_ID_WIDTH] != purge_channel_reg[2:0] ))    // no match, recycle
          purge_prior_nxt_state <= PURGE_PRIOR_STORE0;
        else  // match found
          purge_prior_nxt_state <= PURGE_PRIOR_SUCCESS0;

      PURGE_PRIOR_STORE0:
        if(fifo_line_counter == 3'h0)
          purge_prior_nxt_state <= PURGE_PRIOR_LATCH_FIFO_COUNT1;
        else
         purge_prior_nxt_state <= PURGE_PRIOR_CHECK_ID0;

     PURGE_PRIOR_SUCCESS0:
       if(fifo_line_counter == 3'h0)
           purge_prior_nxt_state <= PURGE_PRIOR_LATCH_FIFO_COUNT1;
       else
            purge_prior_nxt_state <= PURGE_PRIOR_CHECK_ID0;

      PURGE_PRIOR_LATCH_FIFO_COUNT1:
        purge_prior_nxt_state <= PURGE_PRIOR_CHECK_ID1;

      PURGE_PRIOR_CHECK_ID1:
        if(orig_desc_id_1 != purge_id_reg[7:0])    // no match, recycle
          purge_prior_nxt_state <= PURGE_PRIOR_STORE1;
        else  // match found
          purge_prior_nxt_state <= PURGE_PRIOR_SUCCESS1;

       PURGE_PRIOR_STORE1:
        if(fifo_line_counter == 3'h0)
          purge_prior_nxt_state <= PURGE_PRIOR_IDLE;
        else
         purge_prior_nxt_state <= PURGE_PRIOR_CHECK_ID1;

       PURGE_PRIOR_SUCCESS1:
         if(fifo_line_counter == 3'h0)
           purge_prior_nxt_state <= PURGE_PRIOR_IDLE;
         else
            purge_prior_nxt_state <= PURGE_PRIOR_CHECK_ID1;

     default:
       purge_prior_nxt_state <= PURGE_PRIOR_IDLE;
  endcase
end

assign latch_fifo_count0 = (purge_prior_state == PURGE_PRIOR_LATCH_FIFO_COUNT0);
assign purge_fifo_rdreq0 = (purge_prior_state == PURGE_PRIOR_CHECK_ID0);
assign purge_fifo_wrreq0 = (purge_prior_state == PURGE_PRIOR_STORE0);
assign purge_match_found0 = (purge_prior_state == PURGE_PRIOR_SUCCESS0);

assign latch_fifo_count1  = (purge_prior_state == PURGE_PRIOR_LATCH_FIFO_COUNT1);
assign purge_fifo_rdreq1  = (purge_prior_state == PURGE_PRIOR_CHECK_ID1);
assign purge_fifo_wrreq1  = (purge_prior_state == PURGE_PRIOR_STORE1);
assign purge_match_found1 = (purge_prior_state == PURGE_PRIOR_SUCCESS1);

/// latching the fifo count and count down as it searches trhough the FIFO

  always_ff @ (posedge Clk_i or negedge Rstn_i)
     begin
       if(~Rstn_i)
                     fifo_line_counter <= 3'h0;
         else if(latch_fifo_count0 | latch_fifo_count1)
           fifo_line_counter <= latch_fifo_count0? queue0_usedw:queue1_usedw;
         else if(purge_fifo_rdreq0 | purge_fifo_rdreq1)
           fifo_line_counter <= fifo_line_counter - 1;
     end

// Matching found SREG
  always_ff @ (posedge Clk_i or negedge Rstn_i)
     begin
       if(~Rstn_i)
                     match_found_sreg <= 3'h0;
         else if(purge_match_found0 | purge_match_found1)
           match_found_sreg <= 1'b1;
         else if(purge_done)
           match_found_sreg <= 1'b0;
     end

  always_ff @ (posedge Clk_i)
                     match_found_sreg2 <= match_found_sreg;


assign purge_done =  (purge_prior_state == PURGE_PRIOR_STORE1) & (fifo_line_counter == 3'h0) | (purge_prior_state == PURGE_PRIOR_SUCCESS1) & (fifo_line_counter == 3'h0);
assign match_found_rise = ~match_found_sreg2 & match_found_sreg;

assign PriorQueuePurged_o   =  match_found_rise;
assign PriorQueuePurgeErr_o = purge_done & ~match_found_sreg;

/// External Status Request

  always_ff @ (posedge Clk_i or negedge Rstn_i)
     begin
         if(~Rstn_i)
                       purge_ack_reg <= 3'h0;
         else if(PurgeStatusReq_i & ~DmaTxValid_i)   // only ack when there no comming status update from data mover
           purge_ack_reg <= 1'b1;
         else if(purge_ack_reg)  // self reset
           purge_ack_reg <= 1'b0;
     end

 endmodule
