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

module altpcieav_mc_intf
  #(
     parameter NUMBER_OF_CHANNELS = 4,
     parameter PRIORITY_WEIGHT    = 4,  /// every 4, 8 or 0 for infinite
     parameter SRIOV_EN           = 0,
     parameter DESC_WIDTH         = 161  /// 160 + priority bit
   )

   (
         input logic                                  Clk_i,
         input logic                                  Rstn_i,

      // Descriptor Interface to controllers 0
         input   logic  [DESC_WIDTH-1:0]              DescInstr0_i,
         input   logic                                DescInstrValid0_i,
         output  logic                                DescInstrReady0_o,

              // Descriptor Interface to controllers 0
        input   logic  [DESC_WIDTH-1:0]              DescInstr1_i,
        input   logic                                DescInstrValid1_i,
        output  logic                                DescInstrReady1_o,

     // Descriptor Interface to controllers 0
        input   logic  [DESC_WIDTH-1:0]              DescInstr2_i,
        input   logic                                DescInstrValid2_i,
        output  logic                                DescInstrReady2_o,

     // Descriptor Interface to controllers 0
        input   logic  [DESC_WIDTH-1:0]              DescInstr3_i,
        input   logic                                DescInstrValid3_i,
        output  logic                                DescInstrReady3_o,

     // Descriptor Interface to controllers 0
        input   logic  [DESC_WIDTH-1:0]              DescInstr4_i,
        input   logic                                DescInstrValid4_i,
        output  logic                                DescInstrReady4_o,

     // Descriptor Interface to controllers 0
        input   logic  [DESC_WIDTH-1:0]              DescInstr5_i,
        input   logic                                DescInstrValid5_i,
        output  logic                                DescInstrReady5_o,

     // Descriptor Interface to controllers 0
        input   logic  [DESC_WIDTH-1:0]              DescInstr6_i,
        input   logic                                DescInstrValid6_i,
        output  logic                                DescInstrReady6_o,

     // Descriptor Interface to controllers 0
        input   logic  [DESC_WIDTH-1:0]              DescInstr7_i,
        input   logic                                DescInstrValid7_i,
        output  logic                                DescInstrReady7_o,



       /// Data Mover Interface
         output   logic  [DESC_WIDTH-2:0]             DmaRxData_o,
         output   logic                               DmaRxValid_o,
         input    logic                               DmaRxReady_i,
         input    logic  [31:0]                       DmaTxData_i,
         input    logic                               DmaTxValid_i,

         output   logic  [31:0]                       DmaTxData0_o,
         output   logic  [31:0]                       DmaTxData1_o,
         output   logic  [31:0]                       DmaTxData2_o,
         output   logic  [31:0]                       DmaTxData3_o,
         output   logic  [31:0]                       DmaTxData4_o,
         output   logic  [31:0]                       DmaTxData5_o,
         output   logic  [31:0]                       DmaTxData6_o,
         output   logic  [31:0]                       DmaTxData7_o,
         output   logic                               DmaTxValid0_o,
         output   logic                               DmaTxValid1_o,
         output   logic                               DmaTxValid2_o,
         output   logic                               DmaTxValid3_o,
         output   logic                               DmaTxValid4_o,
         output   logic                               DmaTxValid5_o,
         output   logic                               DmaTxValid6_o,
         output   logic                               DmaTxValid7_o,
     /// CRA slave
         input                                        MCSlaveChipSelect_i,
         input                                        MCSlaveWrite_i,
         input   logic   [13:0]                       MCSlaveAddress_i,
         input   logic   [31:0]                       MCSlaveWriteData_i,
         output                                       MCSlaveWaitRequest_o


   );

         logic                                        prior_queue_req0;
         logic                                        prior_queeu_grant0;
         logic          [157:0]                       sub_desc0;
         logic          [1:0]                         sub_desc_wrreq0;
         logic                                        purge_req;
         logic          [7:0]                         purge_req_id;
         logic                                        frag_purge_sucess0;
         logic                                        frag_purge_not_found0;
         logic                                        frag_purge_active0;

         logic                                        prior_queue_req1;
         logic                                        prior_queeu_grant1;
         logic          [157:0]                       sub_desc1;
         logic          [1:0]                         sub_desc_wrreq1;
         logic                                        frag_purge_sucess1;
         logic                                        frag_purge_not_found1;
         logic                                        frag_purge_active1;

         logic                                        prior_queue_req2;
         logic                                        prior_queeu_grant2;
         logic          [157:0]                       sub_desc2;
         logic          [1:0]                         sub_desc_wrreq2;
         logic                                        frag_purge_sucess2;
         logic                                        frag_purge_not_found2;
         logic                                        frag_purge_active2;

         logic                                        prior_queue_req3;
         logic                                        prior_queeu_grant3;
         logic          [157:0]                       sub_desc3;
         logic          [1:0]                         sub_desc_wrreq3;
         logic                                        frag_purge_sucess3;
         logic                                        frag_purge_not_found3;
         logic                                        frag_purge_active3;

         logic                                        prior_queue_req4;
         logic                                        prior_queeu_grant4;
         logic          [157:0]                       sub_desc4;
         logic          [1:0]                         sub_desc_wrreq4;
         logic                                        frag_purge_sucess4;
         logic                                        frag_purge_not_found4;
         logic                                        frag_purge_active4;

         logic                                        prior_queue_req5;
         logic                                        prior_queeu_grant5;
         logic          [157:0]                       sub_desc5;
         logic          [1:0]                         sub_desc_wrreq5;
         logic                                        frag_purge_sucess5;
         logic                                        frag_purge_not_found5;
         logic                                        frag_purge_active5;

         logic                                        prior_queue_req6;
         logic                                        prior_queeu_grant6;
         logic          [157:0]                       sub_desc6;
         logic          [1:0]                         sub_desc_wrreq6;
         logic                                        frag_purge_sucess6;
         logic                                        frag_purge_not_found6;
         logic                                        frag_purge_active6;

         logic                                        prior_queue_req7;
         logic                                        prior_queeu_grant7;
         logic          [157:0]                       sub_desc7;
         logic          [1:0]                         sub_desc_wrreq7;
         logic                                        frag_purge_sucess7;
         logic                                        frag_purge_not_found7;
         logic                                        frag_purge_active7;


         logic       [157:0]                          sub_desc;
         logic       [1:0]                            sub_desc_wrreq;
         logic                                        purge_request;
         logic       [7:0]                            purge_id;
         logic                                        prior_purge_success;
         logic                                        prior_purge_error;
         logic                                        frag_purge_error;
         logic                                        prior_purge_active;

         logic                                        frag_purge_success;
         logic                                        frag_purge_not_found;
         logic                                        frag_purge_active;

         logic                                        purge_status_req;
         logic       [10:0]                           purge_status;
         logic                                        purge_ack;
         logic        [31:0]                          dma_tx_data_out;
         logic       [7:0]                            dma_tx_data_valid;
         logic       [7:0]                            prior_queeu_grant;    
         

localparam NUM_ID_PER_CHANNEL = (NUMBER_OF_CHANNELS == 8)? 4 : (NUMBER_OF_CHANNELS == 2)? 16 : 8;                       

generate if (NUMBER_OF_CHANNELS >= 2)
  begin

altpcieav_mc_frag
#(
   .NUM_ID_PER_CHANNEL(NUM_ID_PER_CHANNEL),
   .CHANNEL_ID(0),
   .DESC_WIDTH(DESC_WIDTH)

  )
 mc_frag_sort0
 (
.Clk_i(Clk_i),
.Rstn_i(Rstn_i),
.DescInstr_i(DescInstr0_i ),
.DescInstrValid_i(DescInstrValid0_i ),
.DescInstrReady_o(DescInstrReady0_o ),
.PriorQueueReq_o(prior_queue_req0),
.PriorQueueGrant_i(prior_queeu_grant0),
.SubDesc_o(sub_desc0),
.SubDescWrReq_o(sub_desc_wrreq0),
.PurgeReq_i(purge_req),
.PurgeID_i(purge_req_id),
.FragQueuePurged_o(frag_purge_sucess0),
.FragQueuePurgeErr_o(frag_purge_not_found0),
.FragQueuePurgedActive_o(frag_purge_active0)
);


altpcieav_mc_frag
#(
    .NUM_ID_PER_CHANNEL(NUM_ID_PER_CHANNEL),
    .CHANNEL_ID(1),
    .DESC_WIDTH(DESC_WIDTH)

  )
 mc_frag_sort1
 (
.Clk_i(Clk_i),
.Rstn_i(Rstn_i),
.DescInstr_i(DescInstr1_i ),
.DescInstrValid_i(DescInstrValid1_i ),
.DescInstrReady_o(DescInstrReady1_o ),
.PriorQueueReq_o(prior_queue_req1),
.PriorQueueGrant_i(prior_queeu_grant1),
.SubDesc_o(sub_desc1),
.SubDescWrReq_o(sub_desc_wrreq1),
.PurgeReq_i(purge_req),
.PurgeID_i(purge_req_id),
.FragQueuePurged_o(frag_purge_sucess1),
.FragQueuePurgeErr_o(frag_purge_not_found1),
.FragQueuePurgedActive_o(frag_purge_active1)
);


  end
endgenerate


generate if(NUMBER_OF_CHANNELS >= 4)
begin
        altpcieav_mc_frag
#(
   .NUM_ID_PER_CHANNEL(NUM_ID_PER_CHANNEL),
   .CHANNEL_ID(2),
   .DESC_WIDTH(DESC_WIDTH)

  )
 mc_frag_sort2
 (
.Clk_i(Clk_i),
.Rstn_i(Rstn_i),
.DescInstr_i(DescInstr2_i ),
.DescInstrValid_i(DescInstrValid2_i ),
.DescInstrReady_o(DescInstrReady2_o ),
.PriorQueueReq_o(prior_queue_req2),
.PriorQueueGrant_i(prior_queeu_grant2),
.SubDesc_o(sub_desc2),
.SubDescWrReq_o(sub_desc_wrreq2),
.PurgeReq_i(purge_req),
.PurgeID_i(purge_req_id),
.FragQueuePurged_o(frag_purge_sucess2),
.FragQueuePurgeErr_o(frag_purge_not_found2),
.FragQueuePurgedActive_o(frag_purge_active2)
);


altpcieav_mc_frag
#(
   .NUM_ID_PER_CHANNEL(NUM_ID_PER_CHANNEL),
   .CHANNEL_ID(3),
   .DESC_WIDTH(DESC_WIDTH)

  )
 mc_frag_sort3
 (
.Clk_i(Clk_i),
.Rstn_i(Rstn_i),
.DescInstr_i(DescInstr3_i ),
.DescInstrValid_i(DescInstrValid3_i ),
.DescInstrReady_o(DescInstrReady3_o ),
.PriorQueueReq_o(prior_queue_req3),
.PriorQueueGrant_i(prior_queeu_grant3),
.SubDesc_o(sub_desc3),
.SubDescWrReq_o(sub_desc_wrreq3),
.PurgeReq_i(purge_req),
.PurgeID_i(purge_req_id),
.FragQueuePurged_o(frag_purge_sucess3),
.FragQueuePurgeErr_o(frag_purge_not_found3),
.FragQueuePurgedActive_o(frag_purge_active3)
);
end
endgenerate

generate if(NUMBER_OF_CHANNELS == 8)
begin
        altpcieav_mc_frag
#(
   .NUM_ID_PER_CHANNEL(NUM_ID_PER_CHANNEL),
   .CHANNEL_ID(4),
   .DESC_WIDTH(DESC_WIDTH)

  )
 mc_frag_sort4
 (
.Clk_i(Clk_i),
.Rstn_i(Rstn_i),
.DescInstr_i(DescInstr4_i ),
.DescInstrValid_i(DescInstrValid4_i ),
.DescInstrReady_o(DescInstrReady4_o ),
.PriorQueueReq_o(prior_queue_req4),
.PriorQueueGrant_i(prior_queeu_grant4),
.SubDesc_o(sub_desc4),
.SubDescWrReq_o(sub_desc_wrreq4),
.PurgeReq_i(purge_req),
.PurgeID_i(purge_req_id),
.FragQueuePurged_o(frag_purge_sucess4),
.FragQueuePurgeErr_o(frag_purge_not_found4),
.FragQueuePurgedActive_o(frag_purge_active4)
);


altpcieav_mc_frag
#(
     .NUM_ID_PER_CHANNEL(NUM_ID_PER_CHANNEL),   // 16 for 2 channels, 8 for 4 channels, 4 for 8 channels
     .CHANNEL_ID(5),
     .DESC_WIDTH(DESC_WIDTH)

  )
 mc_frag_sort5
 (
.Clk_i(Clk_i),
.Rstn_i(Rstn_i),
.DescInstr_i(DescInstr5_i ),
.DescInstrValid_i(DescInstrValid5_i ),
.DescInstrReady_o(DescInstrReady5_o ),
.PriorQueueReq_o(prior_queue_req5),
.PriorQueueGrant_i(prior_queeu_grant5),
.SubDesc_o(sub_desc5),
.SubDescWrReq_o(sub_desc_wrreq5),
.PurgeReq_i(purge_req),
.PurgeID_i(purge_req_id),
.FragQueuePurged_o(frag_purge_sucess5),
.FragQueuePurgeErr_o(frag_purge_not_found5),
.FragQueuePurgedActive_o(frag_purge_active5)
);


altpcieav_mc_frag
#(
   .NUM_ID_PER_CHANNEL(NUM_ID_PER_CHANNEL),
   .CHANNEL_ID(6),
   .DESC_WIDTH(DESC_WIDTH)

  )
 mc_frag_sort6
 (
.Clk_i(Clk_i),
.Rstn_i(Rstn_i),
.DescInstr_i(DescInstr6_i ),
.DescInstrValid_i(DescInstrValid6_i ),
.DescInstrReady_o(DescInstrReady6_o ),
.PriorQueueReq_o(prior_queue_req6),
.PriorQueueGrant_i(prior_queeu_grant6),
.SubDesc_o(sub_desc6),
.SubDescWrReq_o(sub_desc_wrreq6),
.PurgeReq_i(purge_req),
.PurgeID_i(purge_req_id),
.FragQueuePurged_o(frag_purge_sucess6),
.FragQueuePurgeErr_o(frag_purge_not_found6),
.FragQueuePurgedActive_o(frag_purge_active6)
);


altpcieav_mc_frag
#(
   .NUM_ID_PER_CHANNEL(NUM_ID_PER_CHANNEL),
   .CHANNEL_ID(7),
   .DESC_WIDTH(DESC_WIDTH)

  )
 mc_frag_sort7
 (
.Clk_i(Clk_i),
.Rstn_i(Rstn_i),
.DescInstr_i(DescInstr7_i ),
.DescInstrValid_i(DescInstrValid7_i ),
.DescInstrReady_o(DescInstrReady7_o ),
.PriorQueueReq_o(prior_queue_req7),
.PriorQueueGrant_i(prior_queeu_grant7),
.SubDesc_o(sub_desc7),
.SubDescWrReq_o(sub_desc_wrreq7),
.PurgeReq_i(purge_req),
.PurgeID_i(purge_req_id),
.FragQueuePurged_o(frag_purge_sucess7),
.FragQueuePurgeErr_o(frag_purge_not_found7),
.FragQueuePurgedActive_o(frag_purge_active7)
);
end
endgenerate

generate if(NUMBER_OF_CHANNELS == 2)
  begin

assign DescInstrReady2_o = 1'b0;
assign prior_queue_req2  = 1'b0;
assign sub_desc2         = 150'h0;
assign sub_desc_wrreq2   = 2'b00;
assign frag_purge_sucess2 = 1'b0;
assign frag_purge_not_found2 = 1'b0;
assign frag_purge_active2 = 1'b0;

assign DescInstrReady3_o = 1'b0;
assign prior_queue_req3  = 1'b0;
assign sub_desc3         = 150'h0;
assign sub_desc_wrreq3   = 2'b00;
assign frag_purge_sucess3 = 1'b0;
assign frag_purge_not_found3 = 1'b0;
assign frag_purge_active3 = 1'b0;

assign DescInstrReady4_o = 1'b0;
assign prior_queue_req4  = 1'b0;
assign sub_desc4         = 150'h0;
assign sub_desc_wrreq4   = 2'b00;
assign frag_purge_sucess4 = 1'b0;
assign frag_purge_not_found4 = 1'b0;
assign frag_purge_active4 = 1'b0;

assign DescInstrReady5_o = 1'b0;
assign prior_queue_req5  = 1'b0;
assign sub_desc5         = 150'h0;
assign sub_desc_wrreq5   = 2'b00;
assign frag_purge_sucess5 = 1'b0;
assign frag_purge_not_found5 = 1'b0;
assign frag_purge_active5 = 1'b0;

assign DescInstrReady6_o = 1'b0;
assign prior_queue_req6  = 1'b0;
assign sub_desc6         = 150'h0;
assign sub_desc_wrreq6   = 2'b00;
assign frag_purge_sucess6 = 1'b0;
assign frag_purge_not_found6 = 1'b0;
assign frag_purge_active6 = 1'b0;

assign DescInstrReady7_o = 1'b0;
assign prior_queue_req7  = 1'b0;
assign sub_desc7         = 150'h0;
assign sub_desc_wrreq7   = 2'b00;
assign frag_purge_sucess7 = 1'b0;
assign frag_purge_not_found7 = 1'b0;
assign frag_purge_active7 = 1'b0;
  end
endgenerate

generate if(NUMBER_OF_CHANNELS == 4)
  begin
assign DescInstrReady4_o = 1'b0;
assign prior_queue_req4  = 1'b0;
assign sub_desc4         = 150'h0;
assign sub_desc_wrreq4   = 2'b00;
assign frag_purge_sucess4 = 1'b0;
assign frag_purge_not_found4 = 1'b0;
assign frag_purge_active4 = 1'b0;

assign DescInstrReady5_o = 1'b0;
assign prior_queue_req5  = 1'b0;
assign sub_desc5         = 150'h0;
assign sub_desc_wrreq5   = 2'b00;
assign frag_purge_sucess5 = 1'b0;
assign frag_purge_not_found5 = 1'b0;
assign frag_purge_active5 = 1'b0;

assign DescInstrReady6_o = 1'b0;
assign prior_queue_req6  = 1'b0;
assign sub_desc6         = 150'h0;
assign sub_desc_wrreq6   = 2'b00;
assign frag_purge_sucess6 = 1'b0;
assign frag_purge_not_found6 = 1'b0;
assign frag_purge_active6 = 1'b0;

assign DescInstrReady7_o = 1'b0;
assign prior_queue_req7  = 1'b0;
assign sub_desc7         = 150'h0;
assign sub_desc_wrreq7   = 2'b00;
assign frag_purge_sucess7 = 1'b0;
assign frag_purge_not_found7 = 1'b0;
assign frag_purge_active7 = 1'b0;
  end
endgenerate



/// Arbiter
altpcieav_mc_arb
 #(
   .NUMBER_OF_CHANNELS(NUMBER_OF_CHANNELS)
   )
arbiter
(
   .Clk_i(Clk_i),
   .Rstn_i(Rstn_i),
   .PriorQueueReq0_i(prior_queue_req0),
   .PriorQueueReq1_i(prior_queue_req1),
   .PriorQueueReq2_i(prior_queue_req2),
   .PriorQueueReq3_i(prior_queue_req3),
   .PriorQueueReq4_i(prior_queue_req4),
   .PriorQueueReq5_i(prior_queue_req5),
   .PriorQueueReq6_i(prior_queue_req6),
   .PriorQueueReq7_i(prior_queue_req7),
   .PriorQueueGrant0_o(prior_queeu_grant0),
   .PriorQueueGrant1_o(prior_queeu_grant1),
   .PriorQueueGrant2_o(prior_queeu_grant2),
   .PriorQueueGrant3_o(prior_queeu_grant3),
   .PriorQueueGrant4_o(prior_queeu_grant4),
   .PriorQueueGrant5_o(prior_queeu_grant5),
   .PriorQueueGrant6_o(prior_queeu_grant6),
   .PriorQueueGrant7_o(prior_queeu_grant7)
);

assign prior_queeu_grant = {prior_queeu_grant7, prior_queeu_grant6, prior_queeu_grant5, prior_queeu_grant4,
                            prior_queeu_grant3, prior_queeu_grant2, prior_queeu_grant1, prior_queeu_grant0};

/// Priority Queues

 always_comb
  begin
    case(prior_queeu_grant)
      8'b0000_0010 : sub_desc <=  sub_desc1;
      8'b0000_0100 : sub_desc <=  sub_desc2;
      8'b0000_1000 : sub_desc <=  sub_desc3;
      8'b0001_0000 : sub_desc <=  sub_desc4;
      8'b0010_0000 : sub_desc <=  sub_desc5;
      8'b0100_0000 : sub_desc <=  sub_desc6;
      8'b1000_0000 : sub_desc <=  sub_desc7;
      default:       sub_desc <=  sub_desc0;
    endcase
  end

 assign sub_desc_wrreq[0] = sub_desc_wrreq0[0] | sub_desc_wrreq1[0] | sub_desc_wrreq2[0] | sub_desc_wrreq3[0] |
                            sub_desc_wrreq4[0] | sub_desc_wrreq5[0] | sub_desc_wrreq6[0] | sub_desc_wrreq7[0];

assign sub_desc_wrreq[1] = sub_desc_wrreq0[1] | sub_desc_wrreq1[1] | sub_desc_wrreq2[1] | sub_desc_wrreq3[1] |
                            sub_desc_wrreq4[1] | sub_desc_wrreq5[1] | sub_desc_wrreq6[1] | sub_desc_wrreq7[1];

 altpcieav_mc_prior_queue
 # (
       .NUMBER_OF_CHANNELS(NUMBER_OF_CHANNELS),
       .PRIORITY_WEIGHT(PRIORITY_WEIGHT),
       .DESC_WIDTH(DESC_WIDTH)
   )
 priority_queues
   (
       .Clk_i(Clk_i),
       .Rstn_i(Rstn_i),
       .SubDesc_i(sub_desc),
       .SubDescWrReq_i(sub_desc_wrreq),
       .DmaRxData_o(DmaRxData_o),
       .DmaRxValid_o(DmaRxValid_o),
       .DmaRxReady_i(DmaRxReady_i),
       .DmaTxData_i(DmaTxData_i),
       .DmaTxValid_i(DmaTxValid_i),
       .DmaTxData_o(dma_tx_data_out),
       .DmaTxValid_o(dma_tx_data_valid[7:0]),
       .PurgeReq_i(purge_request),
       .PurgeID_i(purge_id),
       .PriorQueuePurged_o(prior_purge_success),
       .PriorQueuePurgeErr_o(prior_purge_error),
       .PriorQueuePurgedActive_o(prior_purge_active)
   );


/// CRA slave

assign frag_purge_success =  frag_purge_sucess0 | frag_purge_sucess1 | frag_purge_sucess2 | frag_purge_sucess3 |
                             frag_purge_sucess4 | frag_purge_sucess5 | frag_purge_sucess6 | frag_purge_sucess7 ;

assign frag_purge_not_found =  frag_purge_not_found0 | frag_purge_not_found1 | frag_purge_not_found2 | frag_purge_not_found3 |
                             frag_purge_not_found4 | frag_purge_not_found5 | frag_purge_not_found6 | frag_purge_not_found7 ;

assign frag_purge_active =  frag_purge_active0 | frag_purge_active1 | frag_purge_active2 | frag_purge_active3 |
                             frag_purge_active4 | frag_purge_active5 | frag_purge_active6 | frag_purge_active7 ;

altpcieav_mc_reg_slave cra_slave
(
   .Clk_i(Clk_i),
   .Rstn_i(Rstn_i),
   .MCSlaveChipSelect_i(MCSlaveChipSelect_i),
   .MCSlaveWrite_i(MCSlaveWrite_i),
   .MCSlaveAddress_i(MCSlaveAddress_i),
   .MCSlaveWriteData_i(MCSlaveWriteData_i),
   .MCSlaveWaitRequest_o(MCSlaveWaitRequest_o),
   .PurgeReq_o(purge_request),
   .PurgeID_o(purge_id),
   .PriorQueuePurged_i(prior_purge_success),
   .FragQueuePurged_i(frag_purge_success),
   .PriorQueuePurgeErr_i(prior_purge_error),
   .FragQueuePurgeErr_i(frag_purge_error),
   .FragQueuePurgedActive_i(frag_purge_active),
   .PriorQueuePurgedActive_i(prior_purge_active),
   .PurgeStatusReq_o(purge_status_req),
   .PurgeStatus_o(purge_status),
   .PurgeStatusAck_i(purge_ack)             );

/// status report
assign DmaTxValid0_o = dma_tx_data_valid[0];
assign DmaTxValid1_o = dma_tx_data_valid[1];
assign DmaTxValid2_o = dma_tx_data_valid[2];
assign DmaTxValid3_o = dma_tx_data_valid[3];
assign DmaTxValid4_o = dma_tx_data_valid[4];
assign DmaTxValid5_o = dma_tx_data_valid[5];
assign DmaTxValid6_o = dma_tx_data_valid[6];
assign DmaTxValid7_o = dma_tx_data_valid[7];


 assign DmaTxData0_o =  dma_tx_data_out;
 assign DmaTxData1_o =  dma_tx_data_out;
 assign DmaTxData2_o =  dma_tx_data_out;
 assign DmaTxData3_o =  dma_tx_data_out;
 assign DmaTxData4_o =  dma_tx_data_out;
 assign DmaTxData5_o =  dma_tx_data_out;
 assign DmaTxData6_o =  dma_tx_data_out;
 assign DmaTxData7_o =  dma_tx_data_out;


endmodule


