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

module cf_calc #(
   parameter TIME_OF_DAY_FORMAT  = 2 //0 = 96b timestamp, 1 = 64b timestamp, 2= both 96b+64b timestamp
) (

   //clock & reset
   input clk,
   input rst_n,
   
   //asymmetry value from the CSR
   input [18:0] asymmetry_reg,
   
   //contol bus from the subblock tod_calc
   input       ctrl_tod_to_cf_valid,
   input [5:0] ctrl_tod_to_cf,
   
   //Ingress ToD - ToDi
   input [95:0] todi_extractor_to_calc, 
   input        non_empty_todi_fifo_extractor_to_calc,
   output       pop_todi_fifo_calc_to_extractor,

   //Ingress CF
   input [63:0] cf_extractor_to_calc,
   input        non_empty_cf_fifo_extractor_to_calc,
   output       pop_cf_fifo_calc_to_extractor,

   //push the ingress CF into a FIFO
   //for later use by the subblock chka_calc
   output        push_cfp_fifo_for_chka,
   
   //Ingress ToD - fully calcuated 
   //from the subblock tod_calc
   input        push_tod_fifo_calc_to_inserter,
   input [95:0] tod_calc_to_inserter_96,
   input [63:0] tod_calc_to_inserter_64,

   //Outputs to the inserter, Chka subblock
   output        push_cf_fifo_calc_to_inserter,
   output [63:0] cf_calc_to_inserter,

   //control bus to the subblock chka_calc
   output        ctrl_cf_to_chka_valid,
   output [3:0]  ctrl_cf_to_chka

);

    //useful local params 
    //localparam NSECOND_OVERFLOW_THRESHOLD    = 48'h3B9ACA00_0000;
    localparam NSECOND_OVERFLOW_THRESHOLD    = 32'h3B9ACA00;
    localparam CF_CALC_LATENCY = 8;
   
/*

CF update happens in 4 flavours:

Just asymmetry: CF' = CF +/- asym
ToD  insertion: CF' = CF +/- ToDe[15:0]
Residence update: CF' = CF +/-asym+ToDe-ToDi - 64b
Residence update: CF' = CF +/-asym+ToDe-ToDi - 96b

*/

//All the changes are to fix the static timing path from the CSR
//to avoid exception handling

reg [18:0] asymmetry_reg_ip;
 
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
              asymmetry_reg_ip <= 'd0;
            end
         else
            begin
              asymmetry_reg_ip <= asymmetry_reg;
            end
      end

wire asymmetry_en;
wire asymmetry_dir; //direction - positive or negative
wire [16:0] asymmetry_delay;

assign asymmetry_en = asymmetry_reg_ip[18];
assign asymmetry_dir = asymmetry_reg_ip[17];
assign asymmetry_delay = asymmetry_reg_ip[16:0];

//convert asymmetry into 2's complement number
//fractional value is taken as all 0s for now
wire [63:0] asymmetry_64 = {31'd0, asymmetry_delay, 16'd0};
reg [31:0] asymmetry_2s_complement_lwr_0; //static - just one register is good enough
reg asymmetry_2s_complement_lwr_carry_0; //static - just one register is good enough
reg [31:0] asymmetry_2s_complement_upr_0;
wire [63:0] asymmetry_ip;

reg [63:0] asymmetry_2s_complement;

//assign asymmetry_2s_complement = (asymmetry_dir) ? (~asymmetry_64+1) : asymmetry_64;

  //get 2s complement in 2 clocks. 
  //it is a static path - no systematic pipelining is required.
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
              asymmetry_2s_complement_lwr_0 <= 'd0;
              asymmetry_2s_complement_lwr_carry_0 <= 'd0;
              asymmetry_2s_complement_upr_0 <= 'd0;
              asymmetry_2s_complement <= 'd0;
            end
         else
            begin
              {asymmetry_2s_complement_lwr_carry_0, asymmetry_2s_complement_lwr_0} <= {1'b0, ~asymmetry_64[31:0]}+33'd1;
              asymmetry_2s_complement_upr_0 <= ~asymmetry_64[63:32] + {31'd0, asymmetry_2s_complement_lwr_carry_0};
              asymmetry_2s_complement <= (asymmetry_dir) ? {asymmetry_2s_complement_upr_0, asymmetry_2s_complement_lwr_0} : asymmetry_64;
            end
      end

//split the control signals
wire asymmetry_update_per_packet = ctrl_tod_to_cf[5] & ctrl_tod_to_cf_valid & asymmetry_en; 
wire insert_ts = ctrl_tod_to_cf[4] & ctrl_tod_to_cf_valid;//involves cf update 
wire ts_format = ctrl_tod_to_cf[3] & ctrl_tod_to_cf_valid;//0:v2 96b; 1:v1 64b
wire cf_update = ctrl_tod_to_cf[2] & ctrl_tod_to_cf_valid;
wire cf_format = ~ctrl_tod_to_cf[1] & ctrl_tod_to_cf_valid; //0:64b; 1:96b
wire chka_update = ctrl_tod_to_cf[0] & ctrl_tod_to_cf_valid; //to pass to the subblock chka_calc

//final asymmetry value prepared at the input stage
assign asymmetry_ip = (asymmetry_update_per_packet) ? asymmetry_2s_complement : 64'd0;

//prepare the control signals for passing them to the subblock chka_calc
//insert happens both in 1588 v1 and 1588 v2.
//In some cases, the asymmetry updates the CF in 1588 v2 taking the fractional ns from the 96b ToD
//but, the real ToD is not inserted in the packet - rather just reported for 2-step or T3
//Hence, the following real insert conditions are arrived at.
wire chka_insert_ts = (insert_ts & ts_format) | (insert_ts & ~ts_format & cf_update);
wire chka_ts_format = ts_format;
wire chka_cf_update = cf_update | asymmetry_update_per_packet;

wire [3:0] ctrl_pass_to_chka = {chka_insert_ts, chka_ts_format, chka_cf_update, chka_update};

   //'cf_extractor_to_calc' is directly connected to the CF fifo in the block 1588_calc
   assign push_cfp_fifo_for_chka = chka_cf_update & chka_update;


//Issue the pops in the 1st stage itself
//the subblock tod_calc latency is such that 
//the cf and the tod from the packet must already be in their respective fifos
//assume the combinational read FIFO
assign pop_todi_fifo_calc_to_extractor = (cf_update & ~insert_ts);
assign pop_cf_fifo_calc_to_extractor = chka_cf_update;

//prepare ToDe - take 64b for 64b case and 48b (32b ns and 16b fns) for 96b case
//tode_96 is not required because the full 64b in ns is already available from tod_calc
wire [63:0] tode_64;

//assign tode_64 = (cf_format) ? {16'd0, tod_calc_to_inserter_64[47:0]} : tod_calc_to_inserter_64;
//Keep all 0s for tode when todi is given in 96b format for later calculation
assign tode_64 = (insert_ts & cf_update) ? {48'd0, tod_calc_to_inserter_96[15:0]} : //consider only the fns in the CF
                 ((cf_update & cf_format) | (asymmetry_update_per_packet & ~cf_update)) ? 64'd0: //tode is readied latter
                 tod_calc_to_inserter_64;


//convert seconds to nanoseconds
reg [31:0] tode_0_s_to_ns;
reg [31:0] tode_0_s_to_ns_0;
reg [45:0] tod_calc_to_inserter_96_0; //[47:46] will always be 0 in 96b format

   always @(*)
      begin
         case (tod_calc_to_inserter_96[49:48]) //indicates the lower 2b for the seconds in 96b format
            2'b00: tode_0_s_to_ns = 0 * NSECOND_OVERFLOW_THRESHOLD;
            2'b01: tode_0_s_to_ns = 1 * NSECOND_OVERFLOW_THRESHOLD;
            2'b10: tode_0_s_to_ns = 2 * NSECOND_OVERFLOW_THRESHOLD;
            2'b11: tode_0_s_to_ns = 3 * NSECOND_OVERFLOW_THRESHOLD;
         endcase
      end


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
reg [CF_CALC_LATENCY-1 :0] pipe_vld_chka;
reg [CF_CALC_LATENCY-1 :0] pipe_vld_cf;
reg [3:0] ctrl_bus [0: CF_CALC_LATENCY-1];
integer i;

   //always @(posedge clk or negedge rst_n)
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
               pipe_vld_chka <='d0;
               pipe_vld_cf <='d0;
               for (i=0; i<CF_CALC_LATENCY; i=i+1)
                  ctrl_bus[i] <= 4'd0;
            end
         else
            begin
               pipe_vld_chka <= {pipe_vld_chka[CF_CALC_LATENCY-2 :0], ctrl_tod_to_cf_valid};
               pipe_vld_cf <= {pipe_vld_cf[CF_CALC_LATENCY-2 :0], (cf_update | asymmetry_update_per_packet)};
               //ctrl_bus <= {ctrl_bus [CF_CALC_LATENCY-2 :0], ctrl_pass_to_chka};
               //ctrl_bus[0: CF_CALC_LATENCY-1] <= {ctrl_pass_to_chka, ctrl_bus [0: CF_CALC_LATENCY-2]};
               for (i=1; i<CF_CALC_LATENCY; i=i+1)
                  begin
                     ctrl_bus[i] <= ctrl_bus[i-1];
                  end
               ctrl_bus[0] <= ctrl_pass_to_chka;
               
            end
      end

//Input stage

reg [63:0] tode_0;
reg [63:0] asymmetry_0;
reg [63:0] cf_0;
//todi_0 is 0 if just asymmetry or (tode & cf update); todi_0 is valid if (cf_update & no tode update)
reg [95:0] todi_0; //unprepared for calculations
reg todi_ctrl_0;
reg cf_format_0;
//reg [47:0] tode_64_f96b_0; //upper 16b are not useful for 96b format

   //always @(posedge clk or negedge rst_n)
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
               tode_0 <= 64'd0;
               asymmetry_0 <= 64'd0;
               cf_0 <= 64'd0;
               todi_0 <= 96'd0;
               todi_ctrl_0 <= 1'b0;
               cf_format_0 <= 1'b0;
               tode_0_s_to_ns_0 <= 'd0;
               tod_calc_to_inserter_96_0 <= 'd0;
               //tode_64_f96b_0 <= 48'd0; 
            end
         else
            begin
               tode_0 <= tode_64;
               asymmetry_0 <= asymmetry_ip; 
               cf_0 <= cf_extractor_to_calc;
               todi_0 <= todi_extractor_to_calc; 
               todi_ctrl_0 <= (cf_update & ~insert_ts) ? 1'b1: 1'b0; 
               cf_format_0 <= cf_format; 
               //timing changes
               tode_0_s_to_ns_0 <= tode_0_s_to_ns;
               tod_calc_to_inserter_96_0 <= tod_calc_to_inserter_96[45:0];
               //tode_64_f96b_0 <= tod_calc_to_inserter_64[47:0]; 
               //tode_64_f96b_0 <= {tode_0_s, tod_calc_to_inserter_96[15:0]}; 
            end
      end

//1st stage

wire [31:0] tode_1_s; //tode_0 in nanoseconds for 96b case
assign tode_1_s = {2'd0,tod_calc_to_inserter_96_0[45:16]} + tode_0_s_to_ns_0;

reg [24:0] tode_asymmetry_1_lwr;
reg [24:0] tode_asymmetry_1_mdl;
reg [15:0] tode_asymmetry_1_upr;

//todi_1 contains the full value if 64b calc format. 
//If 96b format, determine the value to be added in this stage - add in the next stage
//todi_1 is 0 if just asymmetry or (tode & cf update); todi_1 is valid if (cf_update & no tode update)
//prepare the todi_1 for 64b, 96b
reg todi_ctrl_1;
reg [63:0] todi_1;
reg cf_format_1;
reg [63:0] cf_1;
reg [47:0] tode_64_f96b_1; //upper 16b are not useful for 96b format

reg [23:0] todi_1_2s_compl_lwr;
reg todi_1_2s_compl_lwr_carry;
reg [23:0] todi_1_2s_compl_upr;

wire [23:0] todi_1_2s_compl_combo_lwr;
wire todi_1_2s_compl_combo_lwr_carry;
wire [23:0] todi_1_2s_compl_combo_upr;

wire [31:0] todi_0_s; //todi_0 in nanoseconds for 96b case

//convert seconds to nanoseconds
reg [31:0] todi_0_s_to_ns;

   always @(*)
      begin
         case (todi_0[49:48]) //indicates the lower 2b for the seconds in 96b format
            2'b00: todi_0_s_to_ns = 0 * NSECOND_OVERFLOW_THRESHOLD;
            2'b01: todi_0_s_to_ns = 1 * NSECOND_OVERFLOW_THRESHOLD;
            2'b10: todi_0_s_to_ns = 2 * NSECOND_OVERFLOW_THRESHOLD;
            2'b11: todi_0_s_to_ns = 3 * NSECOND_OVERFLOW_THRESHOLD;
         endcase
      end

assign todi_0_s = {2'd0,todi_0[45:16]} + todi_0_s_to_ns;
//for better timing
assign {todi_1_2s_compl_combo_lwr_carry, todi_1_2s_compl_combo_lwr} = {1'b0, ~{todi_0_s[7:0], todi_0[15:0]}} + 25'd1;
assign todi_1_2s_compl_combo_upr = ~todi_0_s[31:8];

   //always @(posedge clk or negedge rst_n)
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
               tode_asymmetry_1_lwr <= 25'd0;
               tode_asymmetry_1_mdl <= 25'd0;
               tode_asymmetry_1_upr <= 16'd0;
               todi_1 <= 64'd0;
               todi_ctrl_1 <= 1'b0; 
               cf_format_1 <= 1'b0; 
               cf_1 <= 64'd0;
               tode_64_f96b_1 <= 48'd0;
               todi_1_2s_compl_lwr <= 'd0; 
               todi_1_2s_compl_lwr_carry <= 'd0; 
               todi_1_2s_compl_upr <= 'd0; 
            end
         else
            begin
               tode_asymmetry_1_lwr <= tode_0[23:0] + asymmetry_0[23:0];
               tode_asymmetry_1_mdl <= tode_0[47:24] + asymmetry_0[47:24];
               tode_asymmetry_1_upr <= tode_0[63:48] + asymmetry_0[63:48];
               if (todi_ctrl_0) //todi is considered
                  begin
                  if (cf_format_0) //96b calculation
                     begin
                        todi_1 [15:0] <= todi_0[15:0]; //fractional nano-seconds go as is
                        //todi_1 [47:16] <= {2'd0,todi_0[29:0]} + todi_0_s_to_ns; //timing seems to be an issue for todi_2
                        todi_1 [47:16] <= todi_0_s;
                        todi_1 [63:48] <= 16'd0; //in 96b mode, we take only the lsb 48b into consideration
                     end
                  else //64b calculation
                     begin
                        todi_1 <= todi_0[63:0]; //upper 32 bits are not useful any time
                     end
                  end
               else //asymmetry case
                  begin
                     todi_1 <= 64'd0; //todi is not considered
                  end
               todi_ctrl_1 <= todi_ctrl_0; 
               cf_format_1 <= cf_format_0; 
               cf_1 <= cf_0;
               tode_64_f96b_1 <= {tode_1_s, tod_calc_to_inserter_96_0[15:0]}; 
               //tode_64_f96b_1 <= tode_64_f96b_0; //timing change as above
               //changes for better timing
               todi_1_2s_compl_lwr <= todi_1_2s_compl_combo_lwr; //need not be in cf_format_0 condition.
               todi_1_2s_compl_lwr_carry <= todi_1_2s_compl_combo_lwr_carry; //need not be in cf_format_0 condition.
               todi_1_2s_compl_upr <= todi_1_2s_compl_combo_upr; //need not be in cf_format_0 condition.
            end
      end

//2nd stage

reg [23:0] tode_asymmetry_2_lwr;
reg [24:0] tode_asymmetry_2_mdl;
reg [15:0] tode_asymmetry_2_upr;
reg [63:0] cf_2;
//get 2's complement of todi_2 and calculate (tode-todi) according to 
//96b format (only the lsb 48b are considered) 
//or keep todi as is,in 64b format (entire 64b considered), as tode is already added to the asymmetry
reg [63:0] todi_2;
reg todi_carry_2;

//For timing reasons, this 2's complement is taken from the register 'todi_1_2s_compl' at stage[1]
//wire [24:0] todi_2s_compl;

//assign todi_2s_compl = ~todi_1[23:0];

reg todi_ctrl_2; 
reg cf_format_2; 


   //always @(posedge clk or negedge rst_n)
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
               tode_asymmetry_2_lwr <= 24'd0;
               tode_asymmetry_2_mdl <= 25'd0;
               tode_asymmetry_2_upr <= 16'd0;
               todi_2 <= 64'd0;
               cf_2 <= 64'd0;
               todi_carry_2 <= 1'b0;
               todi_ctrl_2 <= 'b0; 
               cf_format_2 <= 'b0; 
            end
         else
            begin
               tode_asymmetry_2_lwr <= tode_asymmetry_1_lwr[23:0]; //addition complete
               tode_asymmetry_2_mdl <= tode_asymmetry_1_mdl[23:0] + tode_asymmetry_1_lwr[24]; 
               tode_asymmetry_2_upr <= tode_asymmetry_1_upr + tode_asymmetry_1_mdl[24]; //above carry to be added still
               if (todi_ctrl_1 & cf_format_1) //96b
                  begin
                     //todi_2 <= {16'd0,todi_2s_compl};
                     //{todi_carry_2, todi_2[23:0]} <= todi_2s_compl[23:0] + tode_64_f96b_1[23:0]; //Timing change
                     //todi_2[47:24] <= todi_2s_compl[47:24] + tode_64_f96b_1[47:24]; //Timing change
                     {todi_carry_2, todi_2[23:0]} <= {1'b0, todi_1_2s_compl_lwr} + {1'b0, tode_64_f96b_1[23:0]};
                     todi_2[47:24] <= todi_1_2s_compl_upr + tode_64_f96b_1[47:24] + {23'd0, todi_1_2s_compl_lwr_carry};
                     todi_2[63:48] <= 16'd0;
                  end
               else
                  begin
                     //64b or no todi asymmetry case
                     //same as todi for the other 2 cases in stage 1
                     {todi_carry_2, todi_2[23:0]} <= {1'b0, ~todi_1[23:0]} + 25'd1; //carry to be added in the next stage
                     todi_2[63:24] <= ~todi_1[63:24]; 
                  end
               cf_2 <= cf_1;
               todi_ctrl_2 <= todi_ctrl_1; 
               cf_format_2 <= cf_format_1; 
            end
      end

//2A stage for avoding the timing issue found very late due to A10 I2

reg [23:0] tode_asymmetry_2a_lwr;
reg [24:0] tode_asymmetry_2a_mdl;
reg [15:0] tode_asymmetry_2a_upr;
reg [63:0] cf_2a;
reg [63:0] todi_2a;
reg todi_carry_2a;
reg todi_ctrl_2a; 
reg cf_format_2a; 

wire[24:0] sum_96b_64b_2a; //if 96b, only 24b to be considered. Otherwise, complete 25b considered
reg[24:0] sum_96b_64b_2a_reg; //if 96b, only 24b to be considered. Otherwise, complete 25b considered
assign sum_96b_64b_2a = todi_2[47:24] + {23'd0, todi_carry_2};

   //always @(posedge clk or negedge rst_n)
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
               tode_asymmetry_2a_lwr <= 24'd0;
               tode_asymmetry_2a_mdl <= 25'd0;
               tode_asymmetry_2a_upr <= 16'd0;
               todi_2a <= 64'd0;
               cf_2a <= 64'd0;
               //todi_carry_2a <= 1'b0;
               //todi_ctrl_2a <= 'b0; 
               //cf_format_2a <= 'b0; 
               sum_96b_64b_2a_reg <= 25'd0;
            end
         else
            begin
               tode_asymmetry_2a_lwr <= tode_asymmetry_2_lwr;
               tode_asymmetry_2a_mdl <= tode_asymmetry_2_mdl;
               tode_asymmetry_2a_upr <= tode_asymmetry_2_upr;
               todi_2a <= todi_2;
               cf_2a <= cf_2;
               //todi_carry_2a <= ;
               //todi_ctrl_2a <= ; 
               //cf_format_2a <= ; 
               if (todi_ctrl_2 & cf_format_2) //96b format
                  begin
                     sum_96b_64b_2a_reg <= {1'b0, sum_96b_64b_2a[23:0]}; //carry should be ignored for 96b
                  end
               else
                  begin
                     sum_96b_64b_2a_reg <= sum_96b_64b_2a;
                  end
            end
      end

//3rd stage - tode and asymmetry are fully added here.
//i.e., tode_asymmetry_3 contains fully added value.

reg [23:0] tode_asymmetry_3_lwr;
reg [23:0] tode_asymmetry_3_mdl;
reg [15:0] tode_asymmetry_3_upr;
//addition of cf & todi 1st step in 3rd stage
reg [24:0] cf_todi_lwr_0_3; 
reg [24:0] cf_todi_mdl_0_3; 
reg [15:0] cf_todi_upr_0_3; 

//wire[24:0] sum_96b_64b_2; //if 96b, only 24b to be considered. Otherwise, complete 25b considered
//assign sum_96b_64b_2 = todi_2[47:24] + {23'd0, todi_carry_2};

   //always @(posedge clk or negedge rst_n)
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
               tode_asymmetry_3_lwr <= 24'd0;
               tode_asymmetry_3_mdl <= 24'd0;
               tode_asymmetry_3_upr <= 16'd0;
               cf_todi_lwr_0_3 <= 25'd0;
               cf_todi_mdl_0_3 <= 25'd0;
               cf_todi_upr_0_3 <= 16'd0;
            end
         else
            begin
               tode_asymmetry_3_lwr <= tode_asymmetry_2a_lwr[23:0]; //addition already completed
               tode_asymmetry_3_mdl <= tode_asymmetry_2a_mdl[23:0]; //addition complete
               tode_asymmetry_3_upr <= tode_asymmetry_2a_upr + tode_asymmetry_2a_mdl[24]; //addition complete, ignore carry out of [63]
 
               cf_todi_lwr_0_3 <= cf_2a[23:0] + todi_2a[23:0];
               //Timing is not met here and hence the above stage
               //cf_todi_mdl_0_3 <= cf_2[47:24] + 
               //                  ((todi_ctrl_2 & cf_format_2) ? {1'b0, sum_96b_64b_2[23:0]} : sum_96b_64b_2); //carry addition is still remaining
               cf_todi_mdl_0_3 <= cf_2a[47:24] + sum_96b_64b_2a_reg;
               cf_todi_upr_0_3 <= cf_2a[63:48] + todi_2a[63:48]; //carry addition is still remaining
            end
      end

//4th stage - tode_asymmetry & cf_todi can be added for the lsb 24 bits.

reg [24:0] tode_asymmetry_cf_todi_lwr_0_4;
reg [24:0] tode_asymmetry_cf_todi_mdl_0_4;
reg [15:0] tode_asymmetry_cf_todi_upr_0_4;


   //always @(posedge clk or negedge rst_n)
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
               tode_asymmetry_cf_todi_lwr_0_4 <= 25'd0;
               tode_asymmetry_cf_todi_mdl_0_4 <= 25'd0;
               tode_asymmetry_cf_todi_upr_0_4 <= 16'd0;
            end
         else
            begin
               tode_asymmetry_cf_todi_lwr_0_4 <= tode_asymmetry_3_lwr + cf_todi_lwr_0_3[23:0];
               tode_asymmetry_cf_todi_mdl_0_4 <= tode_asymmetry_3_mdl + cf_todi_mdl_0_3[23:0] + {23'd0, cf_todi_lwr_0_3[24]}; //carry addtion is remaining
               tode_asymmetry_cf_todi_upr_0_4 <= tode_asymmetry_3_upr + cf_todi_upr_0_3 + {15'd0, cf_todi_mdl_0_3[24]}; //carry addtion is remaining
            end
      end

//5th stage - tode_asymmetry & cf_todi can be added for the middle 24 bits.

reg [23:0] tode_asymmetry_cf_todi_lwr_1_5;
reg [24:0] tode_asymmetry_cf_todi_mdl_1_5;
reg [15:0] tode_asymmetry_cf_todi_upr_1_5;


   //always @(posedge clk or negedge rst_n)
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
               tode_asymmetry_cf_todi_lwr_1_5 <= 24'd0;
               tode_asymmetry_cf_todi_mdl_1_5 <= 25'd0;
               tode_asymmetry_cf_todi_upr_1_5 <= 16'd0;
            end
         else
            begin
               tode_asymmetry_cf_todi_lwr_1_5 <= tode_asymmetry_cf_todi_lwr_0_4[23:0]; //fully done
               tode_asymmetry_cf_todi_mdl_1_5 <= tode_asymmetry_cf_todi_mdl_0_4[23:0] + {23'd0, tode_asymmetry_cf_todi_lwr_0_4[24]}; //fully done 
               tode_asymmetry_cf_todi_upr_1_5 <= tode_asymmetry_cf_todi_upr_0_4[15:0] + {15'd0, tode_asymmetry_cf_todi_mdl_0_4[24]}; //carry addtion is remaining
            end
      end

//6th stage - tode_asymmetry & cf_todi can be added for the upr 16 bits.

reg [23:0] tode_asymmetry_cf_todi_lwr_2_6;
reg [23:0] tode_asymmetry_cf_todi_mdl_2_6;
reg [15:0] tode_asymmetry_cf_todi_upr_2_6;


   //always @(posedge clk or negedge rst_n)
   always @(posedge clk)
      begin
         if(rst_n == 1'b0)
            begin
               tode_asymmetry_cf_todi_lwr_2_6 <= 24'd0;
               tode_asymmetry_cf_todi_mdl_2_6 <= 24'd0;
               tode_asymmetry_cf_todi_upr_2_6 <= 16'd0;
            end
         else
            begin
               tode_asymmetry_cf_todi_lwr_2_6 <= tode_asymmetry_cf_todi_lwr_1_5; //fully done
               tode_asymmetry_cf_todi_mdl_2_6 <= tode_asymmetry_cf_todi_mdl_1_5[23:0]; //fully done 
               tode_asymmetry_cf_todi_upr_2_6 <= tode_asymmetry_cf_todi_upr_1_5[15:0] + {15'd0, tode_asymmetry_cf_todi_mdl_1_5[24]}; //fully done
            end
      end


//Outputs assignments
assign ctrl_cf_to_chka_valid = pipe_vld_chka[CF_CALC_LATENCY-1]; //6th stage
assign ctrl_cf_to_chka = ctrl_bus[CF_CALC_LATENCY-1]; //6th stage

assign push_cf_fifo_calc_to_inserter = pipe_vld_cf[CF_CALC_LATENCY-1]; //6th stage
assign cf_calc_to_inserter = {tode_asymmetry_cf_todi_upr_2_6, tode_asymmetry_cf_todi_mdl_2_6, tode_asymmetry_cf_todi_lwr_2_6};

endmodule
