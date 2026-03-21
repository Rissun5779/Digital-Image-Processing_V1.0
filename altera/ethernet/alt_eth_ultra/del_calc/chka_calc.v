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


`timescale 1ps/1ps

module chka_calc #(
   parameter TIME_OF_DAY_FORMAT  = 2 //0 = 96b timestamp, 1 = 64b timestamp, 2= both 96b+64b timestamp
) (

   //clock & reset
   input clk,
   input rst_n,
   
   //control bus from the subblock cf_calc
   input        ctrl_cf_to_chka_valid,
   input [3:0]  ctrl_cf_to_chka,

   
   //ToD' from tod_calc
   input [79:0] tod_fifo_for_chka, 
   input        non_empty_tod_fifo_for_chka,
   output       pop_tod_fifo_for_chka,

   //Packet ToD - ToDp
   input [95:0] todp_extractor_to_calc, 
   input        non_empty_todp_fifo_extractor_to_calc,
   output       pop_todp_fifo_calc_to_extractor,

   //Packet CF
   input [63:0] cfp_fifo_for_chka,
   input        non_empty_cfp_fifo_for_chka,
   output       pop_cfp_fifo_for_chka,

   //inputs from the cf_calc subblock - CF'
   input        push_cf_fifo_calc_to_inserter,
   input [63:0] cf_calc_to_inserter,

   //Packet chka 
   input [16:0] chka_extractor_to_calc, 
   input        non_empty_chka_fifo_extractor_to_calc,
   output       pop_chka_fifo_calc_to_extractor,

   //outputs to the inserter - CHKA'
   output        push_chka_fifo_calc_to_inserter,
   output [15:0] chka_calc_to_inserter


);

    //useful local params 
    localparam CHKA_CALC_LATENCY = 8;
  
/*

Key formulae::
for even offset
   ChkA’ = ( CF + ToD + ChkA) + ~( CF’ + ToD’)
for odd offset,
   B2’B1’ = ( CF + ToD + B2B1) + ~(CF’+ToD’)
   ChkA’ = {B1’,B2’}

*/
 
/*

The checksum update can happen as follows. In all the cases, 
-Chka to be considered for the final calculation of Chka'.
 -v2: CF update due to asymmetry alone - CF & CF' to be considered
 -v2: CF update due to Todi and/or asymmetry - CF & CF' to be considered
 -v2: CF, ToDe update due to Tode insert - ToD', ToD, CF & CF' to be considered
 -v1: ToDe update due to Tode insert - ToD', ToD, to be considered - No CF in 1588 v1

*/

/*

control definitions
ctrl[3] - timestamp insert - so pop tod' & todp
ctrl[2] - timestamp format - 0:v2, 1:v1
ctrl[1] - cf update - so pop cfp and use received cf'
ctrl[0] - chka update is required - chka only if 1'b1

Note: if 1588 v1, the cf update ctrl[1] is expected to be 0.

*/

//split the controls
wire tod_pop = ctrl_cf_to_chka_valid & ctrl_cf_to_chka[3];
wire ptp_v1_v2 = ctrl_cf_to_chka_valid & ctrl_cf_to_chka[2];//1-v1, 0-v2
wire cf_pop = ctrl_cf_to_chka_valid & ctrl_cf_to_chka[1];
wire chka_update_en = ctrl_cf_to_chka_valid & ctrl_cf_to_chka[0];

/*
//template
   //always @(posedge clk or negedge rst_n)
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
            end
         else
            begin
            end
      end
*/

//Pipeline the 96/64b valid and control bus
//Need to take care that the last valid is gated with the incoming packet CHKA say for jumbo
reg [CHKA_CALC_LATENCY-1 :0] pipe_vld;
reg hold_pipe_5;

   //always @(posedge clk or negedge rst_n)
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
               pipe_vld <='d0;
            end
         else
            begin
               if (hold_pipe_5)
                  //not holding the whole pipe - just stage[5] for the chka to allow operations
                  //till stage[5] and beyond stage[5] but holding stage[5] to get chka from the long packet.
                  //Because chka is tapped right at the input where 1588_calc/tod_calc starts its operation,
                  //another chka operation for the next packet is unlikely to come, thus holding the pipe
                  //before stage[5] is irrelevant.
                  //the holding pipe case can only occur only when chka is separated far from tod/cf
                  //for example in jumbo packets
                  //also taken care of not holding the previous packet's chka 
                  //while waiting for the current packet
                  begin
                     //pipe_vld[4:0] <= {pipe_vld[3 :0], (chka_update_en & push_cf_fifo_calc_to_inserter)};
                     pipe_vld[4:0] <= {pipe_vld[3 :0], chka_update_en}; //for v1, there is no CF update
                     pipe_vld[5] <= pipe_vld[5];
                     pipe_vld[CHKA_CALC_LATENCY-1:6] <= {pipe_vld[CHKA_CALC_LATENCY-2: 6], 1'b0};
                  end
               else
                  begin
                     //pipe_vld <= {pipe_vld[CHKA_CALC_LATENCY-2 :0], (chka_update_en & push_cf_fifo_calc_to_inserter)};
                     pipe_vld <= {pipe_vld[CHKA_CALC_LATENCY-2 :0], chka_update_en}; //for v1, there is no CF update
                  end
            end
      end

//Input stage
wire [16:0] cf_calc_to_inserter_lwr_ip;
wire [16:0] cf_calc_to_inserter_upr_ip;

wire [63:0] cf_calc_to_inserter_n;
assign cf_calc_to_inserter_n = ~cf_calc_to_inserter;

assign cf_calc_to_inserter_lwr_ip = cf_calc_to_inserter_n[31:16] + cf_calc_to_inserter_n[15:0];
assign cf_calc_to_inserter_upr_ip = cf_calc_to_inserter_n[63:48] + cf_calc_to_inserter_n[47:32];

//Issue pop to the ToD' fifo, ToDp fifo, CFp fifo as necessary
//we need to wait for only chka'
assign pop_tod_fifo_for_chka = chka_update_en & tod_pop; //ToD'
assign pop_todp_fifo_calc_to_extractor = chka_update_en & tod_pop; //ToDp
assign pop_cfp_fifo_for_chka = chka_update_en & cf_pop; //CFp

wire pop_chka_later;
assign pop_chka_later = chka_update_en;

   //stage0 - CF' sum initiated
reg [16:0] cf_calc_to_inserter_lwr_ip_r;
reg [16:0] cf_calc_to_inserter_upr_ip_r;

reg [79:0] tod_0; //to be inserted
reg [79:0] todp_0; //from the packet
reg [63:0] cfp_0; //from the packet
reg pop_chka_later_0;

   //always @(posedge clk or negedge rst_n)
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
               cf_calc_to_inserter_lwr_ip_r <= 'd0;
               cf_calc_to_inserter_upr_ip_r <= 'd0;
               tod_0 <= 'd0;
               todp_0 <= 'd0;
               cfp_0 <= 'd0;
               pop_chka_later_0 <= 'd0;
            end
         else
            begin
               if(chka_update_en) //this condition may be redundant as the enable flows through the pipe
                  begin
                     cf_calc_to_inserter_lwr_ip_r <= (cf_pop) ? cf_calc_to_inserter_lwr_ip : 'd0;
                     cf_calc_to_inserter_upr_ip_r <= (cf_pop) ? cf_calc_to_inserter_upr_ip : 'd0;
                  end
               //register the fifo outputs before use
               //0 addition does not make any difference in checksum calculation
               //hence, inserting 0s for the irrelevant bits in 1588 v1
               tod_0 <= (~pop_tod_fifo_for_chka) ? 'd0: (ptp_v1_v2) ? 
                        ~{16'd0, tod_fifo_for_chka[63:0]} : ~tod_fifo_for_chka;
               todp_0 <= (~pop_todp_fifo_calc_to_extractor) ? 'd0: (ptp_v1_v2) ? 
                         {16'd0, todp_extractor_to_calc[79:16]} : todp_extractor_to_calc[95:16]; //fractional ns accounted in cf
               cfp_0 <= (pop_cfp_fifo_for_chka) ? cfp_fifo_for_chka :'d0;
               pop_chka_later_0 <= pop_chka_later;
            end
      end

   //stage1 - CF' sum completed except for carry
   //tod', todp and cfp sum initiated
reg [17:0] cf_1;
reg [16:0] tod_lwr_1;
reg [17:0] tod_upr_1;
reg [16:0] todp_lwr_1;
reg [17:0] todp_upr_1;
reg [16:0] cfp_lwr_1;
reg [16:0] cfp_upr_1;
reg pop_chka_later_1;

   //always @(posedge clk or negedge rst_n)
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
               cf_1 <= 'd0;
               tod_lwr_1 <= 'd0;
               tod_upr_1 <= 'd0;
               todp_lwr_1 <= 'd0;
               todp_upr_1 <= 'd0;
               cfp_lwr_1 <= 'd0;
               cfp_upr_1 <= 'd0;
               pop_chka_later_1 <= 'd0;
            end
         else
            begin
               cf_1 <= cf_calc_to_inserter_upr_ip_r + cf_calc_to_inserter_lwr_ip_r;
               tod_lwr_1 <= tod_0[31:16] + tod_0[15:0];
               tod_upr_1 <= tod_0[79:64] + tod_0[63:48] + tod_0[47:32];
               todp_lwr_1 <= todp_0[31:16] + todp_0[15:0];
               todp_upr_1 <= todp_0[79:64] + todp_0[63:48] + todp_0[47:32];
               cfp_lwr_1 <= cfp_0[31:16] + cfp_0[15:0];
               cfp_upr_1 <= cfp_0[63:48] + cfp_0[47:32];
               pop_chka_later_1 <= pop_chka_later_0;
            end
      end

   //stage2 - CF' sum completed 
   //tod', todp and cfp sum completed except for carry
reg [16:0] cf_2;
reg [18:0] tod_2;
reg [18:0] todp_2;
reg [17:0] cfp_2;
reg pop_chka_later_2;

   //always @(posedge clk or negedge rst_n)
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
               cf_2 <= 'd0;
               tod_2 <= 'd0;
               todp_2 <= 'd0;
               cfp_2 <= 'd0;
               pop_chka_later_2 <= 'd0;
            end
         else
            begin
               cf_2 <= cf_1[15:0] + cf_1[17:16];
               tod_2 <= tod_upr_1 + tod_lwr_1;
               todp_2 <= todp_upr_1 + todp_lwr_1;
               cfp_2 <= cfp_upr_1 + cfp_lwr_1;
               pop_chka_later_2 <= pop_chka_later_1;
            end
      end

   //stage3 - CF' + ToD' sum initiated
   //todp and cfp sum completed except for carry
reg [19:0] cf_tod_0_3;
reg [19:0] cfp_todp_0_3;
reg pop_chka_later_3;

   //always @(posedge clk or negedge rst_n)
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
               cf_tod_0_3 <= 'd0;
               cfp_todp_0_3 <= 'd0;
               pop_chka_later_3 <= 'd0;
            end
         else
            begin
               cf_tod_0_3 <= cf_2 + tod_2;
               cfp_todp_0_3 <= cfp_2 + todp_2;
               pop_chka_later_3 <= pop_chka_later_2;
            end
      end


/*

Key formulae::
for even offset
   ChkA’ = ( CF + ToD + ChkA) + ~( CF’ + ToD’)
for odd offset,
   B2’B1’ = ( CF + ToD + B2B1) + ~(CF’+ToD’)
   ChkA’ = {B1’,B2’}

*/


   //stage4 - CF' + ToD' sum with carry & complement it
   //todp and cfp sum with carry
reg [16:0] cf_tod_compl_1_4;
reg [16:0] cfp_todp_1_4;
reg pop_chka_later_4;

   //always @(posedge clk or negedge rst_n)
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
               cf_tod_compl_1_4 <= 'd0;
               cfp_todp_1_4 <= 'd0;
               pop_chka_later_4 <= 'd0;
            end
         else
            begin
               //cf_tod_compl_1_4 <= ~({1'b0, cf_tod_0_3[15:0]} + {13'd0, cf_tod_0_3[19:16]});
               cf_tod_compl_1_4 <= {1'b0, cf_tod_0_3[15:0]} + {13'd0, cf_tod_0_3[19:16]};
               cfp_todp_1_4 <= cfp_todp_0_3[15:0] + cfp_todp_0_3[19:16];
               pop_chka_later_4 <= pop_chka_later_3;
            end
      end

   //stage5 - CF' + ToD' sum with carry & complement +
   //todp and cfp sum with carry
reg [17:0] cf_tod_compl_cfp_todp_2_5;
reg [15:0] chka_0_5;
reg swap_chka_0_5;
//reg hold_pipe_5;

assign pop_chka_fifo_calc_to_extractor = ((pop_chka_later_4 & non_empty_chka_fifo_extractor_to_calc) | //immediate pop
                                         (hold_pipe_5 & non_empty_chka_fifo_extractor_to_calc)); //pop in case of long packets such as jumbo

   //always @(posedge clk or negedge rst_n)
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
               cf_tod_compl_cfp_todp_2_5 <= 'd0;
               chka_0_5 <= 'd0;
               swap_chka_0_5 <= 1'b0;
               hold_pipe_5 <= 1'b0;
            end
         else
            begin
               cf_tod_compl_cfp_todp_2_5 <= (hold_pipe_5) ? cf_tod_compl_cfp_todp_2_5 : 
                                            {1'b0, cf_tod_compl_1_4} + {1'b0, cfp_todp_1_4}; //if not, the complement might be sign extended.
               //whenever pop happens
               if (pop_chka_fifo_calc_to_extractor)
                  begin
                     chka_0_5 <= chka_extractor_to_calc[16] ? {chka_extractor_to_calc[7:0], chka_extractor_to_calc[15:8]} : chka_extractor_to_calc[15:0];
                     swap_chka_0_5 <= chka_extractor_to_calc[16];
                  end
               if (pop_chka_later_4 & ~non_empty_chka_fifo_extractor_to_calc)
                  begin
                     hold_pipe_5 <= 1'b1;
                  end
               else if (pop_chka_fifo_calc_to_extractor)
                  begin
                     hold_pipe_5 <= 1'b0;
                  end
            end
      end

   //stage6 - the final operation

reg [17:0] cf_tod_compl_cfp_todp_chka_0_6;
reg swap_chka_1_6;

   //always @(posedge clk or negedge rst_n)
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
               cf_tod_compl_cfp_todp_chka_0_6 <= 'd0;
               swap_chka_1_6 <= 1'b0;
            end
         else
            begin
               //reduce cf_tod_compl_cfp_todp_2_5 to 15 bit and add. Ideally 16b is good enough
               //for example,5'b1f = 4'bf+4'bf+1
               cf_tod_compl_cfp_todp_chka_0_6 <= cf_tod_compl_cfp_todp_2_5[17:16] + cf_tod_compl_cfp_todp_2_5[15:0] + chka_0_5;
               swap_chka_1_6 <= swap_chka_0_5;
            end
      end

   //stage7 - get the correctly swapped 16b chka

reg [16:0] final_chka;
reg swap_chka_1_7;

wire [16:0] final_chka_sum = cf_tod_compl_cfp_todp_chka_0_6[15:0] + cf_tod_compl_cfp_todp_chka_0_6[17:16];

   //always @(posedge clk or negedge rst_n)
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
               final_chka <= 'd0;
               swap_chka_1_7 <= 1'b0;
            end
         else
            begin
               //final_chka <= (swap_chka_1_6) ? {final_chka_sum[7:0], final_chka_sum[15:8]} : final_chka_sum;
               final_chka <= final_chka_sum;
               swap_chka_1_7 <= swap_chka_1_6;
            end
      end

//final outputs

wire [15:0] final_chka_val = final_chka[16] + final_chka[15:0];
wire [15:0] final_chka_val_swap = (swap_chka_1_7) ? {final_chka_val[7:0], final_chka_val[15:8]} : final_chka_val;

assign push_chka_fifo_calc_to_inserter = pipe_vld[CHKA_CALC_LATENCY-1];
//assign chka_calc_to_inserter = final_chka;
assign chka_calc_to_inserter = final_chka_val_swap;

endmodule
