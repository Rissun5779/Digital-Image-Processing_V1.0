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


///////////////////////////////////////////////////////////////////////////////
// Simulation model of the DDR3 LRDIMM memory buffer
//
///////////////////////////////////////////////////////////////////////////////
module altera_emif_ddr3_model_lrdimm_chip
    #(

   parameter MEM_DEPTH_IDX                      = -1,
   parameter MEM_WIDTH_IDX                      = 0,
   parameter PORT_MEM_CS_N_WIDTH                = 1,
   parameter PORT_MEM_DQS_WIDTH                 = 1,
   parameter PORT_MEM_DQS_N_WIDTH               = 1,
   parameter PORT_MEM_DQ_WIDTH                  = 1,
   parameter PORT_MEM_RM_WIDTH                  = 1,
   parameter MEM_CLK_FREQUENCY                  = 0
  )  (

   inout          [PORT_MEM_DQ_WIDTH-1:0]       DQ,
   inout          [PORT_MEM_DQS_WIDTH-1:0]      DQS_p,
   inout          [PORT_MEM_DQS_N_WIDTH-1:0]    DQS_n,
   input          [15:0]                        DA,
   input          [2:0]                         DBA,
   input                                        DRAS_n,
   input                                        DCAS_n,
   input                                        DWE_n,
   input          [7:0]                         DCS_n,
   input          [2:0]                         DCKE,
   input          [1:0]                         DODT,
   input                                        CLK_p,
   input                                        CLK_n,
   input                                        PAR_IN,
   output                                       ERR_n,

   inout          [PORT_MEM_DQ_WIDTH-1:0]       MDQ,
   inout          [PORT_MEM_DQS_WIDTH-1:0]      MDQS_p,
   inout          [PORT_MEM_DQS_N_WIDTH-1:0]    MDQS_n,
   output         [3:0]                         Y_p,
   output         [3:0]                         Y_n,

   output logic   [15:0]                        QAA,
   output logic   [2:0]                         QABA,
   output logic                                 QARAS_n,
   output logic                                 QACAS_n,
   output logic                                 QAWE_n,
   output logic   [3:0]                         QACS_n,
   output logic   [3:0]                         QACKE,
   output         [1:0]                         QAODT,

   output logic   [15:0]                        QBA,
   output logic   [2:0]                         QBBA,
   output logic                                 QBRAS_n,
   output logic                                 QBCAS_n,
   output logic                                 QBWE_n,
   output logic   [3:0]                         QBCS_n,
   output logic   [3:0]                         QBCKE,
   output         [1:0]                         QBODT,

   input                                        RESET_n,
   output                                       QRST_n

   );
   timeunit 1ps;
   timeprecision 1ps;

   localparam  L_NUM_BANKS                      = 8;
   localparam  L_NUM_LOGICAL_RANKS              = 4;

   localparam  ST_CMD_ACTIVATE                  = 32'd1;
   localparam  ST_CMD_READ                      = 32'd2;
   localparam  ST_CMD_WRITE                     = 32'd3;
   localparam  ST_CMD_PRECHARGE_SINGLE          = 32'd4;
   localparam  ST_CMD_PRECHARGE_ALL             = 32'd5;
   localparam  ST_CMD_REFRESH                   = 32'd6;
   localparam  ST_CMD_ZQ_CAL                    = 32'd7;
   localparam  ST_CMD_SOFT_CKE                  = 32'd8;
   localparam  ST_CMD_RESERVED                  = 32'd9;
   localparam  ST_CMD_ENTER_SELF_REFRESH        = 32'd10;
   localparam  ST_CMD_EXIT_SELF_REFRESH         = 32'd11;
   localparam  ST_CMD_MODE_REGISTER_SET         = 32'd12;
   localparam  ST_CMD_NOP                       = 32'd13;
   localparam  ST_CMD_DESELECT                  = 32'd14;
   localparam  ST_CMD_ERROR                     = 32'd0;

   localparam DELAY = (1000000/(MEM_CLK_FREQUENCY ));

   /* Registers and Interconnect *******************************************/
   genvar                                      lane;

   wire                 [ 3: 0]                w_cfg_addr;
   wire                 [ 3: 0]                w_cfg_data;
   wire                                        cw_soft_cke_en;
   wire                                        cw_rank1_5_swap_en;
   wire                                        cw_numcs;
   wire                                        cw_bcast_precharge;
   wire                                        cw_bcast_refresh;
   wire                                        cw_bcast_mrs;
   wire                                        cw_cke_2_4;                 
   wire                 [ 3: 0]                cw_clk_enable;
   wire                                        cw_clk_override;
   wire                                        cw_addr_mirror_enable;
   wire                                        cw_addr_inversion_enable;

   reg                 [23: 0]                 rm_bits[L_NUM_LOGICAL_RANKS-1:0][L_NUM_BANKS-1:0];
   reg                 [ 3: 0]                 logical_rank;

   reg                                         clk;
   reg                                         clk_dly;
   reg                 [ 3: 0]                 control_word[15:0];

   reg                                         cke_prev;
   reg                 [15: 0]                 r_qaa;
   reg                 [ 2: 0]                 r_qaba;
   reg                                         r_qaras_n;
   reg                                         r_qacas_n;
   reg                                         r_qawe_n;
   reg                 [15: 0]                 r_qba;
   reg                 [ 2: 0]                 r_qbba;
   reg                                         r_qbras_n;
   reg                                         r_qbcas_n;
   reg                                         r_qbwe_n;
   reg                 [ 7: 0]                 r_qcs_n;
   reg                 [ 7: 0]                 r_qcke;
   reg                 [ 3: 0]                 r_qodt;
   reg                 [15: 0]                 r_qaa_dly;
   reg                 [ 2: 0]                 r_qaba_dly;
   reg                                         r_qaras_n_dly;
   reg                                         r_qacas_n_dly;
   reg                                         r_qawe_n_dly;
   reg                 [15: 0]                 r_qba_dly;
   reg                 [ 2: 0]                 r_qbba_dly;
   reg                                         r_qbras_n_dly;
   reg                                         r_qbcas_n_dly;
   reg                                         r_qbwe_n_dly;
   reg                [ 7: 0]                  r_qcs_n_dly;
   reg                [ 7: 0]                  r_qcke_dly;
   reg                [ 3: 0]                  r_qodt_dly;

   reg                                         r_parity;
   reg                [ 4: 0]                  r_parity_err_shreg;
   reg                                         r_mrs_command;
   reg                [ 7: 0]                  prev_rank;

   reg                 [15: 0]                 r_da_snoop;
   reg                 [ 2: 0]                 r_dba_snoop;

   integer                                     cmd_state;
   integer                                     cycle_count;
   integer                                     prev_wr_cycle;
   integer                                     prev_rd_cycle;
   integer                                     prev_bl;
   integer                                     burst_otf;
   integer                                     mem_cl;
   integer                                     mem_cwl;


   /* Internal Assignments *************************************************/
   assign w_cfg_addr[0]            =            DA[0];
   assign w_cfg_addr[1]            =            DA[1];
   assign w_cfg_addr[2]            =            DA[2];
   assign w_cfg_addr[3]            =            DBA[2];

   assign w_cfg_data[0]            =            DA[3];
   assign w_cfg_data[1]            =            DA[4];
   assign w_cfg_data[2]            =            DBA[0];
   assign w_cfg_data[3]            =            DBA[1];

   assign cw_rank1_5_swap_en       =           ((control_word[2] & 4'b0010) == 4'b0010) ? 1'b1 : 1'b0;
   assign cw_numcs                 =           ((control_word[13] & 4'b1100) == 4'b1000) ? 1'b1 : 1'b0;

   assign cw_addr_inversion_enable =           ((control_word[0] & 4'b0001) == 4'b0000) ? 1'b1 : 1'b0;

   assign cw_addr_mirror_enable    =            ((control_word[14] & 4'b0001) == 4'b0001) ? 1'b1 : 1'b0; 
   assign cw_clk_enable[3:0]       =            (~control_word[0]) | {4{cw_clk_override}};

   assign cw_soft_cke_en           =            ((control_word[6] & 4'b1011) == 4'b0010) ? 1'b1 : 1'b0;
   assign cw_cke_2_4               =            ((control_word[6] & 4'b0001) == 4'b0000) ? 1'b1 : 1'b0;

   assign cw_clk_override          =            ((control_word[9] & 4'b0010) == 4'b0000) ? 1'b1 : 1'b0;

   assign cw_bcast_precharge       =            ((control_word[14] & 4'b0010) == 4'b0000) ? 1'b1 : 1'b0;
   assign cw_bcast_refresh         =            ((control_word[14] & 4'b0010) == 4'b0000) ? 1'b1 : 1'b0;
   assign cw_bcast_mrs             =            ((control_word[14] & 4'b0100) == 4'b0000) ? 1'b1 : 1'b0;


   /* Output Assignments ***************************************************/
   assign Y_p[0]                   =            cw_clk_enable[0] & clk_dly;
   assign Y_n[0]                   =            (~cw_clk_enable[0]) | (~clk_dly);

   assign Y_p[1]                   =            cw_clk_enable[1] & clk_dly;
   assign Y_n[1]                   =            (~cw_clk_enable[1]) | (~clk_dly);

   assign Y_p[2]                   =            cw_clk_enable[2] & clk_dly;
   assign Y_n[2]                   =            (~cw_clk_enable[2]) | (~clk_dly);

   assign Y_p[3]                   =            cw_clk_enable[3] & clk_dly;
   assign Y_n[3]                   =            (~cw_clk_enable[3]) | (~clk_dly);

   assign QAA[15:0]     = r_qaa_dly[15:0];
   assign QABA[2:0]     = r_qaba_dly[2:0];
   assign QBA[15:0]     = r_qba_dly[15:0];
   assign QBBA[2:0]     = r_qbba_dly[2:0];
   assign QARAS_n       = r_qaras_n_dly;
   assign QACAS_n       = r_qacas_n_dly;
   assign QAWE_n        = r_qawe_n_dly;
   assign QACS_n[ 3: 0] = r_qcs_n_dly[ 3: 0];
   assign QACKE[ 3: 0]  = r_qcke_dly[ 3: 0];
   assign QAODT[ 1: 0]  = 2'b11;

   assign QBRAS_n       = r_qbras_n_dly;
   assign QBCAS_n       = r_qbcas_n_dly;
   assign QBWE_n        = r_qbwe_n_dly;
   assign QBCS_n[ 3: 0] = r_qcs_n_dly[ 7: 4];
   assign QBCKE[ 3: 0]  = r_qcke_dly[ 7: 4];
   assign QBODT[ 1: 0]  = 2'b11;

   assign ERR_n         = r_parity_err_shreg[4];
   assign QRST_n        = RESET_n;
   /* Processes ****************************************************************/
   initial begin
      clk               =    1'b0;
      clk_dly           =    1'b0;
   end

   always @(CLK_p or CLK_n) begin

      case ({CLK_p, CLK_n, clk})
         3'b000: clk      =    1'b0;
         3'b001: clk      =    1'b1;
         3'b010: clk      =    1'b0;
         3'b011: clk      =    1'b0;
         3'b100: clk      =    1'b1;
         3'b101: clk      =    1'b1;
         3'b110: clk      =    1'b0;
         3'b111: clk      =    1'b1;
         default:clk      =    clk;
      endcase

   end

   always @(clk)
   begin
      clk_dly <= #DELAY clk;
   end

   always @(*)
   begin
      r_qaa_dly[15:0] <= #DELAY r_qaa[15:0];
      r_qaba_dly[2:0] <= #DELAY r_qaba[2:0];
      r_qba_dly[15:0] <= #DELAY r_qba[15:0];
      r_qbba_dly[2:0] <= #DELAY r_qbba[2:0];

      r_qaras_n_dly   <= #DELAY r_qaras_n;
      r_qacas_n_dly   <= #DELAY r_qacas_n;
      r_qawe_n_dly    <= #DELAY r_qawe_n;
      r_qbras_n_dly   <= #DELAY r_qbras_n;
      r_qbcas_n_dly   <= #DELAY r_qbcas_n;
      r_qbwe_n_dly    <= #DELAY r_qbwe_n;
      r_qcs_n_dly[7:0]<= #DELAY r_qcs_n[7:0];
      r_qcke_dly[7:0] <= #DELAY r_qcke[7:0];
   end

   integer lr_ctr;
   integer lr_bank_ctr;
   initial begin
      for (lr_ctr = 0; lr_ctr <= L_NUM_LOGICAL_RANKS; lr_ctr = lr_ctr + 1) begin
         for (lr_bank_ctr = 0; lr_bank_ctr < L_NUM_BANKS; lr_bank_ctr = lr_bank_ctr + 1) begin
            rm_bits[lr_ctr][lr_bank_ctr] <= {24{1'b0}};
         end
      end
   end

   initial begin
      control_word[ 0]    =    4'bxxxx;
      control_word[ 1]    =    4'bxxxx;
      control_word[ 2]    =    4'bxxxx;
      control_word[ 3]    =    4'bxxxx;
      control_word[ 4]    =    4'bxxxx;
      control_word[ 5]    =    4'bxxxx;
      control_word[ 6]    =    4'bxxxx;
      control_word[ 7]    =    4'bxxxx;
      control_word[ 8]    =    4'bxxxx;
      control_word[ 9]    =    4'bxxxx;
      control_word[10]    =    4'bxxxx;
      control_word[11]    =    4'bxxxx;
      control_word[12]    =    4'bxxxx;
      control_word[13]    =    4'bxxxx;
      control_word[14]    =    4'bxxxx;
      control_word[15]    =    4'bxxxx;
   end

   integer ctrl_word_ctr;
   always @(posedge clk or negedge RESET_n) begin
      if (RESET_n == 1'b0) begin
         for (ctrl_word_ctr = 0; ctrl_word_ctr < 16; ctrl_word_ctr = ctrl_word_ctr + 1) begin
            control_word[ctrl_word_ctr] <= 4'b0000;
         end
      end
      else if (DCS_n[1:0] === 2'b00) begin
         if (DCS_n[3:2] === 2'b00) begin
            ctrl_word_ctr = 4;
         end
         else begin
            ctrl_word_ctr = 2;
         end
         for (ctrl_word_ctr = ctrl_word_ctr; ctrl_word_ctr < PORT_MEM_CS_N_WIDTH; ctrl_word_ctr = ctrl_word_ctr + 1) begin
            if (DCS_n[ctrl_word_ctr] === 1'b0) begin
               $display("[%0t] Illegal CS combination to LRDIMM chip: CS[%d] is asserted in programming mode",
                         $time, ctrl_word_ctr);
               $finish;
            end
         end

         if (control_word[7] == 4'b0000) begin
            control_word[w_cfg_addr] <= w_cfg_data[3:0];
         end
         if (w_cfg_addr != 4'd7) begin
            $display("[%0t] [DW=%0d%0d]:  LRDIMM F%0dRC%0d => %0H",
            $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX, control_word[7], w_cfg_addr, w_cfg_data);
         end
         else begin
            control_word[7] <= w_cfg_data[3:0];
         end
      end
   end

   always @(posedge clk or negedge RESET_n) begin
      if (RESET_n == 1'b0) begin
         r_parity <= 1'b1;
         r_parity_err_shreg <= {5{1'b1}};
      end
      else begin

         r_parity_err_shreg[4:1] <= r_parity_err_shreg[3:0];
         if ((DCS_n[1:0] != 2'b00) && ((&DCS_n[7:0]) == 1'b0)) begin
            r_parity_err_shreg[1:0] <= {2{r_parity == PAR_IN}};
         end
         else begin
            r_parity_err_shreg[0] <= 1'b1;
         end

         casex (control_word[11])
            4'b00xx: begin
                        r_parity_err_shreg <= '1;
                     end
            4'b01xx: r_parity <= ^{DA[15: 0], DBA[2: 0], DRAS_n, DCAS_n, DWE_n};
            4'b10xx: r_parity <= ^{DA[15: 0], DBA[2: 0], DRAS_n, DCAS_n, DWE_n, DCS_n[PORT_MEM_CS_N_WIDTH+1:PORT_MEM_CS_N_WIDTH]};
            4'b11xx: r_parity <= 1'bx;
            default: r_parity <= 1'b0;
         endcase


      end
   end

   always @(posedge clk) begin
      cke_prev <= DCKE[0];
      r_mrs_command <= 1'b0;


      if (DCS_n[1:0] === 2'b00) begin
         r_qaa[15:0]   <=     'b0;
         r_qaba[2:0]   <=     'b0;
         r_qba[15:0]   <=     'b0;
         r_qbba[2:0]   <=     'b0;

         r_qaras_n     <=     1'b1;
         r_qacas_n     <=     1'b1;
         r_qawe_n      <=     1'b1;

         r_qbras_n     <=     1'b1;
         r_qbcas_n     <=     1'b1;
         r_qbwe_n      <=     1'b1;

         r_da_snoop[15:0]  <= 'b0;
         r_dba_snoop[2:0]  <= 'b0;

         cycle_count   <=     0;
         prev_wr_cycle <=     0;
         prev_rd_cycle <=     0;
         prev_bl       <=     0;
         burst_otf     <=     0;
         mem_cl        <=     0;
         mem_cwl       <=     0;
         prev_rank     <=     {8{1'b1}};
      end
      else begin
         cycle_count <= cycle_count + 1;

         if ((cw_addr_mirror_enable == 1'b1) && ((logical_rank_decode(DCS_n[7:0]) & 4'b1001)==4'b1001)) begin
            r_da_snoop[ 0]   <=    DA[ 0];
            r_da_snoop[ 1]   <=    DA[ 1];
            r_da_snoop[ 2]   <=    DA[ 2];
            r_da_snoop[ 3]   <=    DA[ 4];
            r_da_snoop[ 4]   <=    DA[ 3];
            r_da_snoop[ 5]   <=    DA[ 6];
            r_da_snoop[ 6]   <=    DA[ 5];
            r_da_snoop[ 7]   <=    DA[ 8];
            r_da_snoop[ 8]   <=    DA[ 7];
            r_da_snoop[ 9]   <=    DA[ 9];
            r_da_snoop[10]   <=    DA[10];
            r_da_snoop[11]   <=    DA[11];
            r_da_snoop[12]   <=    DA[12];
            r_da_snoop[13]   <=    DA[13];
            r_da_snoop[14]   <=    DA[14];
            r_da_snoop[15]   <=    DA[15];
            r_dba_snoop[0]   <=    DBA[1];
            r_dba_snoop[1]   <=    DBA[0];
            r_dba_snoop[2]   <=    DBA[2];

         end
         else begin

            r_da_snoop[15:0]  <=   DA[15:0];
            r_dba_snoop[2:0]  <=   DBA[2:0];

         end

         r_qaa[15:0]  <=   DA[15:0];
         r_qaba[2:0]  <=   DBA[2:0];
         r_qba[15:0]  <=   DA[15:0];
         r_qbba[2:0]  <=   DBA[2:0];

         r_qaras_n       <=   DRAS_n;
         r_qacas_n       <=   DCAS_n;
         r_qawe_n        <=   DWE_n;

         r_qbras_n       <=   DRAS_n;
         r_qbcas_n       <=   DCAS_n;
         r_qbwe_n        <=   DWE_n;

      end

      if (cw_soft_cke_en == 1'b0) begin

         casex (control_word[6])
            4'b0x00: begin
               r_qcke[0]   <=    DCKE[0];
               r_qcke[1]   <=    DCKE[1];
               r_qcke[2]   <=    DCKE[0];
               r_qcke[3]   <=    DCKE[1];
               r_qcke[4]   <=    DCKE[0];
               r_qcke[5]   <=    DCKE[1];
               r_qcke[6]   <=    DCKE[0];
               r_qcke[7]   <=    DCKE[1];
            end

            4'b0x01: begin
               r_qcke[0]   <=    DCKE[0];
               r_qcke[1]   <=    DCKE[1];
               r_qcke[2]   <=    DCKE[2];
               r_qcke[3]   <=    DODT[1];
               r_qcke[4]   <=    DCKE[0];
               r_qcke[5]   <=    DCKE[1];
               r_qcke[6]   <=    DCKE[2];
               r_qcke[7]   <=    DODT[1];
            end

            4'b1xxx: begin
               if ((control_word[6] & 4'b0011) !== 4'b0000) begin
                  $display("[%0t] LRDIMM Error in %m: CKE Configuration Mismatch", $time);
                  $finish;
               end
               r_qcke[0]    <=    DCKE[0] | DCKE[1];
               r_qcke[1]    <=    1'bz;
               r_qcke[2]    <=    1'bz;
               r_qcke[3]    <=    1'bz;
               r_qcke[4]    <=    DCKE[0] | DCKE[1];
               r_qcke[5]    <=    1'bz;
               r_qcke[6]    <=    1'bz;
               r_qcke[7]    <=    1'bz;
            end

         endcase

      end

      casex ({DRAS_n, DCAS_n, DWE_n})
         3'b011: begin
            cmd_state       <=    ST_CMD_ACTIVATE;
            logical_rank = logical_rank_decode(DCS_n[7:0]);

            if (logical_rank[3] == 1'b1) begin
               rm_bits[logical_rank[2:0]][DBA[2:0]]     <=    {DCS_n[7:0], DA[15:0]};
               $display("[%0t] LRDIMM RM Bit storage - Input CS Pattern = %h, logical_rank = %d, bank address = %d",
                         $time, DCS_n[7:0], logical_rank[2:0], DBA[2:0]);
            end
            else
            begin
               $display("[%0t] LRDIMM RM Bit Storage - Couldn't map CS pattern %h to a logical rank",
                          $time, DCS_n[7:0]);
            end

            r_qcs_n[7:0]    <=    cs_decode({DCS_n[7:0], DA[15:0]});
         end

         3'b101: begin
            cmd_state       <=    ST_CMD_READ;

            logical_rank    =     logical_rank_decode(DCS_n[7:0]);

            if (logical_rank[3] == 1'b0) begin
               r_qcs_n[7:0] <=    {8{1'b1}};
            end
            else begin

               $display("[%0t] LRDIMM Read CS pattern: %h (logical rank = %d, bank = %d)",
               $time, cs_decode(rm_bits[logical_rank[2:0]][DBA[2:0]]),
               logical_rank[2:0], DBA[2:0]);
               r_qcs_n[7:0] <=    cs_decode(rm_bits[logical_rank[2:0]][DBA[2:0]]);
               prev_rd_cycle <=   cycle_count;
               prev_rank <=       cs_decode(rm_bits[logical_rank[2:0]][DBA[2:0]]);

               if (burst_otf == 1) begin
                    prev_bl <= ((DA[12] == 1'b1) ? 8 : 4);
               end

               if (cs_decode(rm_bits[logical_rank[2:0]][DBA[2:0]]) != prev_rank) begin
                  if ((cycle_count - prev_rd_cycle) < (prev_bl/2 + 2)) begin
                     $display("[%0t] LRDIMM TRDRD violated: %d < %d", $time,
                                 (cycle_count - prev_rd_cycle), (prev_bl/2 + 2));
                  end
                  else begin
                     $display("[%0t] LRDIMM TRDRD = %d cycles", $time, cycle_count - prev_rd_cycle);
                  end

                  if ((cycle_count - prev_wr_cycle) < (prev_bl/2 + 2 + (mem_cl - mem_cwl))) begin
                     $display("[%0t] LRDIMM TWRRD violated: %d < %d", $time,
                                 (cycle_count - prev_wr_cycle), (prev_bl/2 + 2 + (mem_cl - mem_cwl)));
                  end
                  else begin
                        $display("[%0t] LRDIMM TWRRD = %d cycles", $time, cycle_count - prev_wr_cycle);
                  end

               end
            end
         end

         3'b100: begin
            cmd_state <= ST_CMD_WRITE;

            logical_rank = logical_rank_decode(DCS_n[7:0]);
            if (logical_rank[3] == 1'b0) begin
               r_qcs_n[7:0] <= {8{1'b1}};
            end
            else begin
               $display("[%0t] LRDIMM Write CS pattern: %h (logical rank = %d, bank = %d)",
               $time, cs_decode(rm_bits[logical_rank[2:0]][DBA[2:0]]),
               logical_rank[2:0], DBA[2:0]);
               r_qcs_n[7:0] <= cs_decode(rm_bits[logical_rank[2:0]][DBA[2:0]]);
               prev_wr_cycle <= cycle_count;
               prev_rank <= cs_decode(rm_bits[logical_rank[2:0]][DBA[2:0]]);
               if (burst_otf == 1) begin
                  prev_bl <= ((DA[12] == 1'b1) ? 8 : 4);
               end

               if (cs_decode(rm_bits[logical_rank[2:0]][DBA[2:0]]) != prev_rank) begin
                  if ((cycle_count - prev_wr_cycle) < (prev_bl/2 + 2)) begin
                     $display("[%0t] LRDIMM TWRWR violated: %d < %d", $time,
                                 (cycle_count - prev_wr_cycle), (prev_bl/2 + 2));
                  end
                  else begin
                     $display("[%0t] LRDIMM TWRWR = %d cycles", $time, cycle_count - prev_wr_cycle);
                  end

                  if ((cycle_count - prev_rd_cycle) < (prev_bl/2 + 4 + (mem_cl - mem_cwl))) begin
                     $display("[%0t] LRDIMM TRDWR violated: %d < %d", $time,
                                  (cycle_count - prev_rd_cycle), (prev_bl/2 + 4 + (mem_cl - mem_cwl)));
                  end
                  else begin
                     $display("[%0t] LRDIMM TRDWR = %d cycles", $time, cycle_count - prev_rd_cycle);
                  end
               end

            end
         end

         3'b010: begin
            if (DA[10] === 1'b0) begin
               cmd_state <= ST_CMD_PRECHARGE_SINGLE;
            end
            else if (DA[10] === 1'b1) begin
               cmd_state <= ST_CMD_PRECHARGE_ALL;
            end
            else begin
               cmd_state <= ST_CMD_ERROR;
            end

            if (cw_bcast_precharge == 1'b1) begin
               r_qcs_n[7:0] <= broadcast_decode(DCS_n[7:0]);
            end
            else begin
               r_qcs_n[7:0] <= cs_decode({DCS_n[7:0], DA[15:0]});
            end
         end

         3'b001: begin
            if ((cke_prev === 1'b1) && (DCKE[0] === 1'b0)) begin
               cmd_state <= ST_CMD_ENTER_SELF_REFRESH;

               r_qcs_n[7:0] <= broadcast_decode(DCS_n[7:0]);

            end
            else if (DCKE[0] === 1'b1) begin
               cmd_state <= ST_CMD_REFRESH;

               if (cw_bcast_refresh == 1'b1) begin
                  r_qcs_n[7:0] <= broadcast_decode(DCS_n[7:0]);
               end
               else begin
                  logical_rank = logical_rank_decode(DCS_n[7:0]);
                  if (logical_rank[3] == 1'b0) begin
                     r_qcs_n[7:0] <= {8{1'b1}};
                     $display("[%0t] LRDIMM Invalid CS input %h in refresh command @ %f",
                     $time, DCS_n[7:0], $realtime);
                  end
                  else begin
                     r_qcs_n[7:0] <= cs_decode(rm_bits[logical_rank[2:0]][DBA[2:0]]);
                  end
               end
            end
            else begin
                cmd_state <= ST_CMD_ERROR;
            end
         end

         3'b110: begin
            if ((DA[15:13] === 3'b000) || (cw_soft_cke_en === 1'b0))
            begin
               cmd_state <= ST_CMD_ZQ_CAL;
               r_qcs_n[7:0] <= (DCS_n[7:0]);
            end
            else if ((DA[15:13] === 3'b001) && (cw_soft_cke_en === 1'b1)) begin
               cmd_state <= ST_CMD_SOFT_CKE;
               r_qcke[7:0] <= {2{DA[3:0]}};

               r_qcs_n[7:0] <= 8'b1111_1111;

               r_qaa[15:0]  <= 'b0;
               r_qaba[2:0]  <= 'b0;
               r_qaras_n    <= 'b1;
               r_qacas_n    <= 'b1;
               r_qawe_n     <= 'b1;

               r_qba[15:0]  <= 'b0;
               r_qbba[2:0]  <= 'b0;
               r_qbras_n    <= 'b1;
               r_qbcas_n    <= 'b1;
               r_qbwe_n     <= 'b1;

            end
            else if ((DA[15:14] !== 2'b00) && (cw_soft_cke_en === 1'b1)) begin
               cmd_state <= ST_CMD_RESERVED;
               r_qcs_n[7:0] <= 8'b1111_1111;

               r_qaa[15:0]  <= 'b0;
               r_qaba[2:0]  <= 'b0;
               r_qaras_n    <= 'b1;
               r_qacas_n    <= 'b1;
               r_qawe_n     <= 'b1;

               r_qba[15:0]  <= 'b0;
               r_qbba[2:0]  <= 'b0;
               r_qbras_n    <= 'b1;
               r_qbcas_n    <= 'b1;
               r_qbwe_n     <= 'b1;
            end
            else begin
               cmd_state <= ST_CMD_ERROR;
            end
         end

         3'b000: begin
            cmd_state <= ST_CMD_MODE_REGISTER_SET;
            if (cw_bcast_mrs == 1'b1) begin
               r_qcs_n[7:0] <= broadcast_decode(DCS_n[7:0]);
            end
            else begin
               r_qcs_n[7:0] <= cs_decode({DCS_n[7:0], DA[15:0]});
            end

            r_mrs_command <= 1'b1;

            if (DBA[1:0] == 2'b00) begin
               case (DA[1:0])
                  2'b00: prev_bl = 8;
                  2'b10: prev_bl = 4;
                  2'b01: burst_otf = 1;
                  default: begin
                     $display("[%0t]:  LRDIMM Invalid Burst mode %d specified!", $time, DA[1:0]);
                  end
               endcase
               $display("[%0t]:  LRDIMM MB set burst mode to %s", $time,
                         ((burst_otf == 1) ? "OTF" : ((prev_bl == 4) ? "BL4" : "BL8") ));

               case ({DA[6], DA[5], DA[4], DA[2]})
                  4'b0001: mem_cl = 12;
                  4'b0010: mem_cl = 5;
                  4'b0011: mem_cl = 13;

                  4'b0100: mem_cl = 6;
                  4'b0101: mem_cl = 14;
                  4'b0110: mem_cl = 7;
                  4'b0111: mem_cl = 15;

                  4'b1000: mem_cl = 8;
                  4'b1001: mem_cl = 16;
                  4'b1010: mem_cl = 9;

                  4'b1100: mem_cl = 10;
                  4'b1110: mem_cl = 11;

                  default: begin
                        $display("[%0t]:  LRDIMM Invalid CAS Latency %d specified!", $time, {DA[6], DA[5], DA[4], DA[2]});
                  end
               endcase
               $display("[%0t]:  LRDIMM MB set CAS latency to %d", $time, mem_cl);
            end
            else if (DBA[1:0] == 2'b10) begin
               case (DA[5:3])
                  3'b000: mem_cwl = 5;
                  3'b001: mem_cwl = 6;
                  3'b010: mem_cwl = 7;
                  3'b011: mem_cwl = 8;
                  3'b100: mem_cwl = 9;
                  3'b101: mem_cwl = 10;
                  3'b110: mem_cwl = 11;
                  3'b111: mem_cwl = 12;
               endcase
               $display("[%0t]:  LRDIMM MB set CAS Write latency to %d", $time, mem_cwl);
            end
         end

         3'b111: begin
            cmd_state <= ST_CMD_NOP;
            r_qaa[15:0]  <= 'b0;
            r_qaba[2:0]  <= 'b0;
            r_qaras_n    <= 'b1;
            r_qacas_n    <= 'b1;
            r_qawe_n     <= 'b1;

            r_qba[15:0]  <= 'b0;
            r_qbba[2:0]  <= 'b0;
            r_qbras_n    <= 'b1;
            r_qbcas_n    <= 'b1;
            r_qbwe_n     <= 'b1;

            r_qcs_n      <= {8{1'b1}};
         end

         3'bxxx: begin
            cmd_state <= ST_CMD_DESELECT;
            r_qaa[15:0]  <= 'b0;
            r_qaba[2:0]  <= 'b0;
            r_qaras_n    <= 'b1;
            r_qacas_n    <= 'b1;
            r_qawe_n     <= 'b1;

            r_qba[15:0]  <= 'b0;
            r_qbba[2:0]  <= 'b0;
            r_qbras_n    <= 'b1;
            r_qbcas_n    <= 'b1;
            r_qbwe_n     <= 'b1;

            r_qcs_n      <= {8{1'b1}};
         end

         default:
         begin
            cmd_state <= ST_CMD_ERROR;
         end

      endcase
   end

   reg [8*10-1:0] cmd_state_text;
   always @(cmd_state) begin

      casex(cmd_state)
         ST_CMD_ACTIVATE             : cmd_state_text <= "ACTIVATE  ";
         ST_CMD_READ                 : cmd_state_text <= "READ      ";
         ST_CMD_WRITE                : cmd_state_text <= "WRITE     ";
         ST_CMD_PRECHARGE_SINGLE     : cmd_state_text <= "PRCHRG_One";
         ST_CMD_PRECHARGE_ALL        : cmd_state_text <= "PRCHRG_All";
         ST_CMD_REFRESH              : cmd_state_text <= "REFRESH   ";
         ST_CMD_ZQ_CAL               : cmd_state_text <= "ZQ_CAL    ";
         ST_CMD_SOFT_CKE             : cmd_state_text <= "SOFT_CKE  ";
         ST_CMD_RESERVED             : cmd_state_text <= "RESERVED  ";
         ST_CMD_ENTER_SELF_REFRESH   : cmd_state_text <= "ENTR_SelfR";
         ST_CMD_EXIT_SELF_REFRESH    : cmd_state_text <= "EXIT_SelfR";
         ST_CMD_MODE_REGISTER_SET    : cmd_state_text <= "MRS_SET   ";
         ST_CMD_NOP                  : cmd_state_text <= "NOP       ";
         ST_CMD_DESELECT             : cmd_state_text <= "DESELECT  ";
         ST_CMD_ERROR                : cmd_state_text <= "ERROR     ";
      endcase

   end

   generate

      for (lane = 0; lane < PORT_MEM_DQ_WIDTH; lane = lane + 1) begin : gen_dq_delay
         altera_emif_ddrx_model_bidir_delay
         #(
            .DELAY                         (DELAY)

         ) inst_dq_bidir_dly (

            .porta                         (MDQ[lane]),
            .portb                         (DQ[lane])

         );
      end

      for (lane = 0; lane < PORT_MEM_DQS_WIDTH; lane = lane + 1) begin : gen_dqs_delay
         altera_emif_ddrx_model_bidir_delay
         #(
            .DELAY                         (DELAY)

         ) inst_dqs_p_bidir_dly (

            .porta                         (MDQS_p[lane]),
            .portb                         (DQS_p[lane])

         );

         altera_emif_ddrx_model_bidir_delay
         #(
            .DELAY                         (DELAY)
         ) inst_dqs_n_bidir_dly (
            .porta                         (MDQS_n[lane]),
            .portb                         (DQS_n[lane])
           );
      end

   endgenerate


   function [7:0] broadcast_decode;

      input [7:0] chip_sel;
      integer rm;
      begin
         case (control_word[13])
            4'b00_00: broadcast_decode = {8{chip_sel[0]}};

            4'b00_01: broadcast_decode = {2{2'b11, {2{chip_sel[0]}}}};

            4'b00_10: broadcast_decode = {2{3'b111, chip_sel[0]}};

            4'b00_11: broadcast_decode = {7'b111_1111, chip_sel[0]};


            4'b01_00: broadcast_decode = {4{chip_sel[1:0]}};

            4'b01_01: broadcast_decode = {4{chip_sel[1:0]}};

            4'b01_10: broadcast_decode = {4{chip_sel[1:0]}};

            4'b10_00: broadcast_decode = {2{chip_sel[3:0]}};

            4'b10_01: broadcast_decode = {2{chip_sel[3:0]}};

            4'b11_00: broadcast_decode = chip_sel[7:0];

            default: broadcast_decode = 8'b1111_1111;

         endcase
      end

   endfunction

   function [7:0] cs_decode;

      input [23:0] ics_iaddr;
      begin

         casex ({cw_rank1_5_swap_en, cw_numcs, control_word[15],
            ics_iaddr[17], ics_iaddr[16], ics_iaddr[19], ics_iaddr[18],
            ics_iaddr[15], ics_iaddr[14]})
            12'b0_x_0000_1011_xx: cs_decode = 8'b1110_1110; 
            12'b0_x_0000_0111_xx: cs_decode = 8'b1101_1101; 
            12'b0_x_0000_1110_xx: cs_decode = 8'b1011_1011; 
            12'b0_x_0000_1101_xx: cs_decode = 8'b0111_0111; 
            12'b0_x_0000_1111_xx: cs_decode = 8'b1111_1111;
            12'b0_x_0000_0011_xx: cs_decode = 8'b1111_1111; 

            12'b0_0_0001_10xx_x0: cs_decode = 8'b1110_1110; 
            12'b0_0_0001_10xx_x1: cs_decode = 8'b1011_1011; 
            12'b0_0_0001_01xx_x0: cs_decode = 8'b1101_1101; 
            12'b0_0_0001_01xx_x1: cs_decode = 8'b0111_0111; 

            12'b0_1_0001_1011_x0: cs_decode = 8'b1111_1110; 
            12'b0_1_0001_1011_x1: cs_decode = 8'b1110_1111; 
            12'b0_1_0001_0111_x0: cs_decode = 8'b1111_1101; 
            12'b0_1_0001_0111_x1: cs_decode = 8'b1101_1111; 
            12'b0_1_0001_1110_x0: cs_decode = 8'b1111_1011; 
            12'b0_1_0001_1110_x1: cs_decode = 8'b1011_1111; 
            12'b0_1_0001_1101_x0: cs_decode = 8'b1111_0111; 
            12'b0_1_0001_1101_x1: cs_decode = 8'b0111_1111; 

            12'b0_x_0001_1111_xx: cs_decode = 8'b1111_1111;
            12'b0_x_0001_00xx_xx: cs_decode = 8'b1111_1111; 

            12'b0_0_0010_10xx_0x: cs_decode = 8'b1110_1110; 
            12'b0_0_0010_10xx_1x: cs_decode = 8'b1011_1011; 
            12'b0_0_0010_01xx_0x: cs_decode = 8'b1101_1101; 
            12'b0_0_0010_01xx_1x: cs_decode = 8'b0111_0111; 

            12'b0_1_0010_1011_0x: cs_decode = 8'b1111_1110; 
            12'b0_1_0010_1011_1x: cs_decode = 8'b1110_1111; 
            12'b0_1_0010_0111_0x: cs_decode = 8'b1111_1101; 
            12'b0_1_0010_0111_1x: cs_decode = 8'b1101_1111; 
            12'b0_1_0010_1110_0x: cs_decode = 8'b1111_1011; 
            12'b0_1_0010_1110_1x: cs_decode = 8'b1011_1111; 
            12'b0_1_0010_1101_0x: cs_decode = 8'b1111_0111; 
            12'b0_1_0010_1101_1x: cs_decode = 8'b0111_1111; 

            12'b0_x_0010_1111_xx: cs_decode = 8'b1111_1111;
            12'b0_x_0010_00xx_xx: cs_decode = 8'b1111_1111; 


            12'b0_0_0011_10x0_xx: cs_decode = 8'b1110_1110; 
            12'b0_0_0011_10x1_xx: cs_decode = 8'b1011_1011; 
            12'b0_0_0011_01x0_xx: cs_decode = 8'b1101_1101; 
            12'b0_0_0011_01x1_xx: cs_decode = 8'b0111_0111; 


            12'b0_x_0011_111x_xx: cs_decode = 8'b1111_1111;
            12'b0_x_0011_00xx_xx: cs_decode = 8'b1111_1111; 

            12'b0_0_0101_10xx_00: cs_decode = 8'b1111_1110; 
            12'b0_0_0101_10xx_01: cs_decode = 8'b1111_1011; 
            12'b0_0_0101_10xx_10: cs_decode = 8'b1110_1111; 
            12'b0_0_0101_10xx_11: cs_decode = 8'b1011_1111; 
            12'b0_0_0101_01xx_00: cs_decode = 8'b1111_1101; 
            12'b0_0_0101_01xx_01: cs_decode = 8'b1111_0111; 
            12'b0_0_0101_01xx_10: cs_decode = 8'b1101_1111; 
            12'b0_0_0101_01xx_11: cs_decode = 8'b0111_1111; 
            12'b0_x_0101_11xx_xx: cs_decode = 8'b1111_1111;
            12'b0_x_0101_00xx_xx: cs_decode = 8'b1111_1111; 

            12'b0_0_0101_10x0_0x: cs_decode = 8'b1111_1110; 
            12'b0_0_0101_10x0_1x: cs_decode = 8'b1111_1011; 
            12'b0_0_0101_10x1_0x: cs_decode = 8'b1110_1111; 
            12'b0_0_0101_10x1_1x: cs_decode = 8'b1011_1111; 
            12'b0_0_0101_01x0_0x: cs_decode = 8'b1111_1101; 
            12'b0_0_0101_01x0_1x: cs_decode = 8'b1111_0111; 
            12'b0_0_0101_01x1_0x: cs_decode = 8'b1101_1111; 
            12'b0_0_0101_01x1_1x: cs_decode = 8'b0111_1111; 
            12'b0_x_0101_11xx_xx: cs_decode = 8'b1111_1111;
            12'b0_x_0101_00xx_xx: cs_decode = 8'b1111_1111; 

            12'b0_0_0111_1000_xx: cs_decode = 8'b1111_1110; 
            12'b0_0_0111_1001_xx: cs_decode = 8'b1111_1011; 
            12'b0_0_0111_1010_xx: cs_decode = 8'b1110_1111; 
            12'b0_0_0111_1011_xx: cs_decode = 8'b1011_1111; 
            12'b0_0_0111_0100_xx: cs_decode = 8'b1111_1101; 
            12'b0_0_0111_0101_xx: cs_decode = 8'b1111_0111; 
            12'b0_0_0111_0110_xx: cs_decode = 8'b1101_1111; 
            12'b0_0_0111_0111_xx: cs_decode = 8'b0111_1111; 
            12'b0_x_0111_11xx_xx: cs_decode = 8'b1111_1111;
            12'b0_x_0111_00xx_xx: cs_decode = 8'b1111_1111; 


            12'b1_x_0000_1011_xx: cs_decode = 8'b1110_1110; 
            12'b1_x_0000_0111_xx: cs_decode = 8'b1101_1101; 
            12'b1_x_0000_1110_xx: cs_decode = 8'b1011_1011; 
            12'b1_x_0000_1101_xx: cs_decode = 8'b0111_0111; 
            12'b1_x_0000_1111_xx: cs_decode = 8'b1111_1111;
            12'b1_x_0000_0011_xx: cs_decode = 8'b1111_1111; 

            12'b1_0_0001_10xx_x0: cs_decode = 8'b1110_1110; 
            12'b1_0_0001_10xx_x1: cs_decode = 8'b1011_1011; 
            12'b1_0_0001_01xx_x0: cs_decode = 8'b1101_1101; 
            12'b1_0_0001_01xx_x1: cs_decode = 8'b0111_0111; 

            12'b1_1_0001_1011_x0: cs_decode = 8'b1111_1110; 
            12'b1_1_0001_1011_x1: cs_decode = 8'b1110_1111; 
            12'b1_1_0001_0111_x0: cs_decode = 8'b1101_1111; 
            12'b1_1_0001_0111_x1: cs_decode = 8'b1111_1101; 
            12'b1_1_0001_1110_x0: cs_decode = 8'b1111_1011; 
            12'b1_1_0001_1110_x1: cs_decode = 8'b1011_1111; 
            12'b1_1_0001_1101_x0: cs_decode = 8'b1111_0111; 
            12'b1_1_0001_1101_x1: cs_decode = 8'b0111_1111; 

            12'b1_x_0001_1111_xx: cs_decode = 8'b1111_1111;
            12'b1_x_0001_00xx_xx: cs_decode = 8'b1111_1111; 

            12'b1_0_0010_10xx_0x: cs_decode = 8'b1110_1110; 
            12'b1_0_0010_10xx_1x: cs_decode = 8'b1011_1011; 
            12'b1_0_0010_01xx_0x: cs_decode = 8'b1101_1101; 
            12'b1_0_0010_01xx_1x: cs_decode = 8'b0111_0111; 

            12'b1_1_0010_1011_0x: cs_decode = 8'b1111_1110; 
            12'b1_1_0010_1011_1x: cs_decode = 8'b1110_1111; 
            12'b1_1_0010_0111_0x: cs_decode = 8'b1101_1111; 
            12'b1_1_0010_0111_1x: cs_decode = 8'b1111_1101; 
            12'b1_1_0010_1110_0x: cs_decode = 8'b1111_1011; 
            12'b1_1_0010_1110_1x: cs_decode = 8'b1011_1111; 
            12'b1_1_0010_1101_0x: cs_decode = 8'b1111_0111; 
            12'b1_1_0010_1101_1x: cs_decode = 8'b0111_1111; 

            12'b1_x_0010_1111_xx: cs_decode = 8'b1111_1111;
            12'b1_x_0010_00xx_xx: cs_decode = 8'b1111_1111; 


            12'b1_0_0011_10x0_xx: cs_decode = 8'b1110_1110; 
            12'b1_0_0011_10x1_xx: cs_decode = 8'b1011_1011; 
            12'b1_0_0011_01x0_xx: cs_decode = 8'b1101_1101; 
            12'b1_0_0011_01x1_xx: cs_decode = 8'b0111_0111; 


            12'b1_x_0011_111x_xx: cs_decode = 8'b1111_1111;
            12'b1_x_0011_00xx_xx: cs_decode = 8'b1111_1111; 

            12'b1_0_0101_10xx_00: cs_decode = 8'b1111_1110; 
            12'b1_0_0101_10xx_01: cs_decode = 8'b1111_1011; 
            12'b1_0_0101_10xx_10: cs_decode = 8'b1110_1111; 
            12'b1_0_0101_10xx_11: cs_decode = 8'b1011_1111; 
            12'b1_0_0101_01xx_00: cs_decode = 8'b1101_1111; 
            12'b1_0_0101_01xx_01: cs_decode = 8'b1111_0111; 
            12'b1_0_0101_01xx_10: cs_decode = 8'b1111_1101; 
            12'b1_0_0101_01xx_11: cs_decode = 8'b0111_1111; 
            12'b1_x_0101_11xx_xx: cs_decode = 8'b1111_1111;
            12'b1_x_0101_00xx_xx: cs_decode = 8'b1111_1111; 

            12'b1_0_0101_10x0_0x: cs_decode = 8'b1111_1110; 
            12'b1_0_0101_10x0_1x: cs_decode = 8'b1111_1011; 
            12'b1_0_0101_10x1_0x: cs_decode = 8'b1110_1111; 
            12'b1_0_0101_10x1_1x: cs_decode = 8'b1011_1111; 
            12'b1_0_0101_01x0_0x: cs_decode = 8'b1101_1111; 
            12'b1_0_0101_01x0_1x: cs_decode = 8'b1111_0111; 
            12'b1_0_0101_01x1_0x: cs_decode = 8'b1111_1101; 
            12'b1_0_0101_01x1_1x: cs_decode = 8'b0111_1111; 
            12'b1_x_0101_11xx_xx: cs_decode = 8'b1111_1111;
            12'b1_x_0101_00xx_xx: cs_decode = 8'b1111_1111; 

            12'b1_0_0111_1000_xx: cs_decode = 8'b1111_1110; 
            12'b1_0_0111_1001_xx: cs_decode = 8'b1111_1011; 
            12'b1_0_0111_1010_xx: cs_decode = 8'b1110_1111; 
            12'b1_0_0111_1011_xx: cs_decode = 8'b1011_1111; 
            12'b1_0_0111_0100_xx: cs_decode = 8'b1101_1111; 
            12'b1_0_0111_0101_xx: cs_decode = 8'b1111_0111; 
            12'b1_0_0111_0110_xx: cs_decode = 8'b1111_1101; 
            12'b1_0_0111_0111_xx: cs_decode = 8'b0111_1111; 
            12'b1_x_0111_11xx_xx: cs_decode = 8'b1111_1111;
            12'b1_x_0111_00xx_xx: cs_decode = 8'b1111_1111; 

            default: cs_decode = 8'b1111_1111;
         endcase
      end

   endfunction

   function [3:0] logical_rank_decode;

      input [7: 0] ics;
      begin
         casex ({control_word[13], ics[7:0]})
            12'b00xx_xxxx_xxx0: logical_rank_decode = 4'b0000;

           12'b01xx_xxxx_xx10: logical_rank_decode = 4'b1000;
           12'b01xx_xxxx_xx01: logical_rank_decode = 4'b1001;

           12'b10xx_xxxx_1110: logical_rank_decode = 4'b1000;
           12'b10xx_xxxx_1101: logical_rank_decode = 4'b1001;
           12'b10xx_xxxx_1011: logical_rank_decode = 4'b1010;
           12'b10xx_xxxx_0111: logical_rank_decode = 4'b1011;

           12'b11xx_1111_1110: logical_rank_decode = 4'b1000;
           12'b11xx_1111_1101: logical_rank_decode = 4'b1001;
           12'b11xx_1111_1011: logical_rank_decode = 4'b1010;
           12'b11xx_1111_0111: logical_rank_decode = 4'b1011;
           12'b11xx_1110_1111: logical_rank_decode = 4'b1100;
           12'b11xx_1101_1111: logical_rank_decode = 4'b1101;
           12'b11xx_1011_1111: logical_rank_decode = 4'b1110;
           12'b11xx_0111_1111: logical_rank_decode = 4'b1111;

            default:            logical_rank_decode = 4'b0000;
         endcase
      end

   endfunction


endmodule
