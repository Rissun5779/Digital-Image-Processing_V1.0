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
module altpcie_sc_dprio_top #(
   parameter use_config_bypass_hwtcl = 0,
   parameter cseb_autonomous_hwtcl   = 0, //1: use CSEB during Autonomous mode
   parameter default_speed = 2'b11
)
(

   // altpcie_dprio_access
   input   wire            pld_clk,
   input   wire            pld_reset_n,
   input   wire            reconfig_clk,
   input   wire            reconfig_reset_n,
   input   wire            test_sim,

   output  wire            hip_reconfig_clk/*synthesis noprune*/,
   output  wire            hip_reconfig_reset_n/*synthesis noprune*/,
   output  wire            hip_reconfig_write/*synthesis noprune*/,
   output  wire    [15:0]  hip_reconfig_writedata/*synthesis noprune*/,
   output  wire    [1:0]   hip_reconfig_byteen/*synthesis noprune*/,
   output  wire    [9:0]   hip_reconfig_address/*synthesis noprune*/,
   output  wire            hip_reconfig_read/*synthesis noprune*/,
   input   wire    [15:0]  hip_reconfig_readdata/*synthesis noprune*/,


   // altpcie_speed_change_seq
   input   wire    [4:0]   ltssm,
   input   wire            app_speed_chg_en_i,
   input   wire            app_cseb_switch_i,
   output  wire            test_in_9_o,
   output  wire            hold_ltssm_rec_o,

   // Target link speed
   input [1:0]             current_speed_i,
   input [3 : 0]           tl_cfg_add_i,
   input [31 : 0]          tl_cfg_ctl_i,
   input [12:0]            cfglink2csrpld_i

);

   localparam [10:0] RSTN_CNT_MAXSIM   = 11'h20;
   localparam [10:0] RSTN_CNT_MAX      = 11'h100;

   reg                     app_rstn, rec_rstn;
   reg     [ 10: 0]        rsnt_cntn, rsnt_cntn2;

   wire                    app_dprio_done;   //1 = Indicate DPRIO rd/wr process is done
   wire [1:0]              app_target_link_speed;
   wire                    test_mode;        //1: test_mode is active, 0: Normal mode
   wire                    dprio_mux_sel;
   wire                    start_speed_chg;
   wire                    start_switch, link_l0;
   wire                    sc_retry_enable;
   wire                    dbg_switch_en;
   wire                    app_cseb_bit5_val;

   //###############################################
   // Reset deboucing
   //###############################################
   // pld_clk domain
   always @(posedge pld_clk or negedge pld_reset_n) begin
      if (pld_reset_n == 1'b0) begin
         app_rstn <= 1'b0;
         rsnt_cntn <= 11'h0;
      end else begin
         if ((test_sim == 1'b1) && (rsnt_cntn >= RSTN_CNT_MAXSIM) ) begin
            app_rstn <= 1'b1;
         end else if (rsnt_cntn == RSTN_CNT_MAX) begin
            app_rstn <= 1'b1;
         end else begin
            rsnt_cntn <= rsnt_cntn + 11'h1;
         end
      end
   end

   // reconfig_clk domain
   always @(posedge reconfig_clk or negedge reconfig_reset_n) begin
      if (reconfig_reset_n == 1'b0) begin
         rec_rstn <= 1'b0;
         rsnt_cntn2 <= 11'h0;
      end else begin
         if ((test_sim == 1'b1) && (rsnt_cntn2 >= RSTN_CNT_MAXSIM) ) begin
            rec_rstn <= 1'b1;
         end else if (rsnt_cntn2 == RSTN_CNT_MAX) begin
            rec_rstn <= 1'b1;
         end else begin
            rsnt_cntn2 <= rsnt_cntn2 + 11'h1;
         end
      end
   end


   //###############################################
   altpcie_sc_dprio_seq #(
      .use_config_bypass_hwtcl ( use_config_bypass_hwtcl),
      .cseb_autonomous_hwtcl   ( cseb_autonomous_hwtcl  ),
      .default_speed           ( default_speed )

   ) altpcie_sc_dprio_seq (
         .pld_clk                 ( pld_clk                 ),
         .pld_reset_n                       ( app_rstn                ),
         .reconfig_clk                      ( reconfig_clk                         ),
         .reconfig_reset_n                       ( rec_rstn                             ),
         .hip_reconfig_clk        ( hip_reconfig_clk        ),
         .hip_reconfig_reset_n    ( hip_reconfig_reset_n    ),
         .hip_reconfig_write      ( hip_reconfig_write      ),
         .hip_reconfig_writedata  ( hip_reconfig_writedata  ),
         .hip_reconfig_byteen     ( hip_reconfig_byteen     ),
         .hip_reconfig_address    ( hip_reconfig_address    ),
         .hip_reconfig_read       ( hip_reconfig_read       ),
         .hip_reconfig_readdata   ( hip_reconfig_readdata   ),
         .link_l0_i               ( link_l0                 ),
         .tl_cfg_add_i            ( tl_cfg_add_i            ),
         .tl_cfg_ctl_i            ( tl_cfg_ctl_i            ),
         .cfglink2csrpld_i        ( cfglink2csrpld_i        ),
         .start_switch_i          ( start_switch            ),
         .app_target_link_speed_o ( app_target_link_speed   ),
         .app_dprio_done_o        ( app_dprio_done          ),
         .app_cseb_bit5_val_o     ( app_cseb_bit5_val       ),
         .test_mode_i             ( test_mode               )
   );


   altpcie_sc_ctrl #(
      .use_config_bypass_hwtcl ( use_config_bypass_hwtcl ),
      .cseb_autonomous_hwtcl   ( cseb_autonomous_hwtcl   ),
      .default_speed           ( default_speed )
   ) altpcie_sc_ctrl (
         .clk                    ( pld_clk              ),
         .reset_n                ( app_rstn             ),
         .ltssm                  ( ltssm                ),
         .app_dprio_done_i       ( app_dprio_done       ),
         .test_mode_i            ( test_mode            ),
         .test_sim_i             ( test_sim             ),
         .start_speed_chg_i      ( start_speed_chg      ),
         .sc_retry_enable_i      ( sc_retry_enable      ),
         .dprio_mux_sel_i        ( dprio_mux_sel        ),
         .app_speed_chg_en_i     ( app_speed_chg_en_i   ),
         .app_cseb_switch_i      ( app_cseb_switch_i    ),
         .app_target_link_speed_i( app_target_link_speed),
         .current_speed_i        ( current_speed_i      ),
         .dbg_switch_en_i        ( dbg_switch_en        ),
         .app_cseb_bit5_val_i    ( app_cseb_bit5_val    ),
         .test_in_9_o            ( test_in_9_o          ),
         .hold_ltssm_rec_o       ( hold_ltssm_rec_o     ),
         .link_l0_o              ( link_l0              ),
         .start_switch_o         ( start_switch         )
   );

   //###############################################
   // Signal probes for debugging
   //###############################################

   lpm_constant #(
      .lpm_cvalue (1'b1),
      .lpm_hint   ("ENABLE_RUNTIME_MOD=YES, INSTANCE_NAME=TEST_MODE"),
      .lpm_type   ("LPM_CONSTANT"),
      .lpm_width  (1)
   ) test_mode_const ( .result(test_mode) );

   lpm_constant #(
      .lpm_cvalue (1'b0),
      .lpm_hint   ("ENABLE_RUNTIME_MOD=YES, INSTANCE_NAME=MUX_SEL"),
      .lpm_type   ("LPM_CONSTANT"),
      .lpm_width  (1)
   ) mux_sel_const ( .result(dprio_mux_sel) );

   lpm_constant #(
      .lpm_cvalue (1'b0),
      .lpm_hint   ("ENABLE_RUNTIME_MOD=YES, INSTANCE_NAME=SPEED_CHG_EN"),
      .lpm_type   ("LPM_CONSTANT"),
      .lpm_width  (1)
   ) start_speed_chg_const ( .result(start_speed_chg) );

   lpm_constant #(
      .lpm_cvalue (1'b1),
      .lpm_hint   ("ENABLE_RUNTIME_MOD=YES, INSTANCE_NAME=SC_RETRY"),
      .lpm_type   ("LPM_CONSTANT"),
      .lpm_width  (1)
   ) start_sc_retry_const ( .result(sc_retry_enable) );

//==================================================
// Constant signals to debug CSEB to AVST switching
   lpm_constant #(
      .lpm_cvalue (1'b0),
      .lpm_hint   ("ENABLE_RUNTIME_MOD=YES, INSTANCE_NAME=DBG_SWITCH"),
      .lpm_type   ("LPM_CONSTANT"),
      .lpm_width  (1)
   ) dbg_switch_const ( .result(dbg_switch_en) );


endmodule
