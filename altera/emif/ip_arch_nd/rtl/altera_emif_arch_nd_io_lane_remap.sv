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
// This module instantiates one lane withina a tile
// This file remaps the parameter to uniquify the names for easy reading
// at the top level
//
///////////////////////////////////////////////////////////////////////////////

module altera_emif_arch_nd_io_lane_remap (
   input  [1:0] phy_clk,
   input  [7:0] phy_clk_phs,
   input        reset_n,
   input        pll_locked,
   input        dll_ref_clk,
   output [5:0] ioereg_locked,

   input  [47:0] oe_from_core,
   input  [95:0] data_from_core,
   output [95:0] data_to_core,
   input  [15:0] mrnk_read_core,
   input  [15:0] mrnk_write_core,
   input   [3:0] rdata_en_full_core,
   output  [3:0] rdata_valid_core,

   input         core2dbc_rd_data_rdy,
   input         core2dbc_wr_data_vld0,
   input         core2dbc_wr_data_vld1,
   input  [12:0] core2dbc_wr_ecc_info,
   output        dbc2core_rd_data_vld0,
   output        dbc2core_rd_data_vld1,
   output        dbc2core_rd_type,
   output [11:0] dbc2core_wb_pointer,
   output        dbc2core_wr_data_rdy,

   input  [95:0] ac_hmc,
   output  [5:0] afi_rlat_core,
   output  [5:0] afi_wlat_core,
   input  [17:0] cfg_dbc,
   input  [50:0] ctl2dbc0,
   input  [50:0] ctl2dbc1,
   output [22:0] dbc2ctl,

   input  [54:0] cal_avl_in,
   output [31:0] cal_avl_readdata_out,
   output [54:0] cal_avl_out,
   input  [31:0] cal_avl_readdata_in,

   input [1:0]   dqs_in,
   input [1:0]   broadcast_in_bot,
   input [1:0]   broadcast_in_top,
   output [1:0]  broadcast_out_bot,
   output [1:0]  broadcast_out_top,

   input  [11:0] data_in,
   output [11:0] data_out,
   output [11:0] data_oe,
   output [11:0] oct_enable,

   input   [2:0] core_dll,
   output [12:0] dll_core,

   input    sync_clk_bot_in,
   output   sync_clk_bot_out,
   input    sync_clk_top_in,
   output   sync_clk_top_out,
   input    sync_data_bot_in,
   output   sync_data_bot_out,
   input    sync_data_top_in,
   output   sync_data_top_out,

    output [11:0] emif_phy_out_a,
    output [11:0] emif_phy_out_b,

   output [1:0]   dft_phy_clk
);

parameter pipe_latency = 8'd0;
parameter pin_0_output_phase = 13'd0;
parameter pin_1_output_phase = 13'd0;
parameter pin_2_output_phase = 13'd0;
parameter pin_3_output_phase = 13'd0;
parameter pin_4_output_phase = 13'd0;
parameter pin_5_output_phase = 13'd0;
parameter pin_6_output_phase = 13'd0;
parameter pin_7_output_phase = 13'd0;
parameter pin_8_output_phase = 13'd0;
parameter pin_9_output_phase = 13'd0;
parameter pin_10_output_phase = 13'd0;
parameter pin_11_output_phase = 13'd0;
parameter dqs_lgc_phase_shift_b = 13'd0;
parameter dqs_lgc_phase_shift_a = 13'd0;
parameter oct_size = 4'd0;
parameter rd_valid_delay = 7'd0;
parameter dqs_enable_delay = 6'd0;
parameter avl_base_addr = 9'd0;
parameter a_filter_code = "freq_16ghz";
parameter a_couple_enable = "couple_en";
parameter mode_rate_in = "in_rate_1_4";
parameter mode_rate_out = 1;
parameter phy_clk_sel = 0;
parameter pair_0_ddr4_mode = "ddr3_idle";
parameter pair_1_ddr4_mode = "ddr3_idle";
parameter pair_2_ddr4_mode = "ddr3_idle";
parameter pair_3_ddr4_mode = "ddr3_idle";
parameter pair_4_ddr4_mode = "ddr3_idle";
parameter pair_5_ddr4_mode = "ddr3_idle";
parameter pin_0_initial_out = "initial_out_z";
parameter pin_0_oct_mode = "static_off";
parameter pin_0_mode_ddr = "mode_ddr";
parameter pin_0_dqs_mode = "dqs_sampler_a";
parameter pin_0_data_in_mode = "ca";
parameter pin_1_initial_out = "initial_out_z";
parameter pin_1_oct_mode = "static_off";
parameter pin_1_mode_ddr = "mode_ddr";
parameter pin_1_dqs_mode = "dqs_sampler_a";
parameter pin_1_data_in_mode = "ca";
parameter pin_2_initial_out = "initial_out_z";
parameter pin_2_oct_mode = "static_off";
parameter pin_2_mode_ddr = "mode_ddr";
parameter pin_2_dqs_mode = "dqs_sampler_a";
parameter pin_2_data_in_mode = "ca";
parameter pin_3_initial_out = "initial_out_z";
parameter pin_3_oct_mode = "static_off";
parameter pin_3_mode_ddr = "mode_ddr";
parameter pin_3_dqs_mode = "dqs_sampler_a";
parameter pin_3_data_in_mode = "ca";
parameter pin_4_initial_out = "initial_out_z";
parameter pin_4_oct_mode = "static_off";
parameter pin_4_mode_ddr = "mode_ddr";
parameter pin_4_dqs_mode = "dqs_sampler_a";
parameter pin_4_data_in_mode = "ca";
parameter pin_5_initial_out = "initial_out_z";
parameter pin_5_oct_mode = "static_off";
parameter pin_5_mode_ddr = "mode_ddr";
parameter pin_5_dqs_mode = "dqs_sampler_a";
parameter pin_5_data_in_mode = "ca";
parameter pin_6_initial_out = "initial_out_z";
parameter pin_6_oct_mode = "static_off";
parameter pin_6_mode_ddr = "mode_ddr";
parameter pin_6_dqs_mode = "dqs_sampler_a";
parameter pin_6_data_in_mode = "ca";
parameter pin_7_initial_out = "initial_out_z";
parameter pin_7_oct_mode = "static_off";
parameter pin_7_mode_ddr = "mode_ddr";
parameter pin_7_dqs_mode = "dqs_sampler_a";
parameter pin_7_data_in_mode = "ca";
parameter pin_8_initial_out = "initial_out_z";
parameter pin_8_oct_mode = "static_off";
parameter pin_8_mode_ddr = "mode_ddr";
parameter pin_8_dqs_mode = "dqs_sampler_a";
parameter pin_8_data_in_mode = "ca";
parameter pin_9_initial_out = "initial_out_z";
parameter pin_9_oct_mode = "static_off";
parameter pin_9_mode_ddr = "mode_ddr";
parameter pin_9_dqs_mode = "dqs_sampler_a";
parameter pin_9_data_in_mode = "ca";
parameter pin_10_initial_out = "initial_out_z";
parameter pin_10_oct_mode = "static_off";
parameter pin_10_mode_ddr = "mode_ddr";
parameter pin_10_dqs_mode = "dqs_sampler_a";
parameter pin_10_data_in_mode = "ca";
parameter pin_11_initial_out = "initial_out_z";
parameter pin_11_oct_mode = "static_off";
parameter pin_11_mode_ddr = "mode_ddr";
parameter pin_11_dqs_mode = "dqs_sampler_a";
parameter pin_11_data_in_mode = "ca";
parameter db_hmc_or_core = "core";
parameter db_dbi_sel = "db_dbi_sel_uint0";
parameter db_dbi_wr_en = "false";
parameter db_dbi_rd_en = "false";
parameter avl_ena = "false";
parameter db_boardcast_en = "false";
parameter db_pipeline = "pipeline_one_cycle";
parameter db_rwlat_mode = "avl_vlu";
parameter db_ptr_pipeline_depth = "db_ptr_pipeline_depth_uint0";
parameter db_preamble_mode = "preamble_one_cycle";
parameter db_reset_auto_release = "auto_release";
parameter db_data_alignment_mode = "align_disable";
parameter db_db2core_registered = "registered";
parameter dbc_core_clk_sel = "dbc_core_clk_sel_uint0";
parameter db_core_or_hmc2db_registered = "false";
parameter db_seq_rd_en_full_pipeline = "db_seq_rd_en_full_pipeline_uint0";
parameter db_pin_0_mode = "gpio_mode";
parameter db_pin_1_mode = "gpio_mode";
parameter db_pin_2_mode = "gpio_mode";
parameter db_pin_3_mode = "gpio_mode";
parameter db_pin_4_mode = "gpio_mode";
parameter db_pin_5_mode = "gpio_mode";
parameter db_pin_6_mode = "gpio_mode";
parameter db_pin_7_mode = "gpio_mode";
parameter db_pin_8_mode = "gpio_mode";
parameter db_pin_9_mode = "gpio_mode";
parameter db_pin_10_mode = "gpio_mode";
parameter db_pin_11_mode = "gpio_mode";
parameter dll_rst_en = "dll_rst_dis";
parameter dll_en = "dll_en";
parameter dll_core_updnen = "core_updn_en";
parameter dll_ctlsel = "ctl_static";
parameter hps_ctrl_en = "true";
parameter dqs_lgc_enable_toggler = "preamble_track_dqs_enable";
parameter dqs_lgc_dqs_b_interp_en = "dqsb_constant";
parameter dqs_lgc_dqs_a_interp_en = "dqsa_diff_in_1";
parameter dqs_lgc_pack_mode = "packed";
parameter dqs_lgc_pst_preamble_mode = "ddr4_preamble";
parameter dqs_lgc_pst_en_shrink = "shrink_0_0";
parameter vfifo_burst_length = "vburst_length_2";
parameter dqs_lgc_broadcast_enable = "disable_broadcast";
parameter dqs_lgc_burst_length = "burst_length_8";
parameter dqs_lgc_ddr4_search = "ddr4_search";
parameter silicon_rev                            = "";
parameter db_afi_wlat_vlu                        = "";
parameter db_afi_rlat_vlu                        = "";
parameter dbc_wb_reserved_entry                  = "";
parameter dll_ctl_static                         = "";
parameter dqs_lgc_pvt_input_delay_a              = "";
parameter dqs_lgc_pvt_input_delay_b              = "";
parameter dqs_lgc_count_threshold                = "";
parameter pingpong_primary                       = "";
parameter pingpong_secondary                     = "";
parameter fast_interpolator_sim = 0;

localparam l_mode_rate_out = (mode_rate_out == 1) ? "out_rate_full" :
                            ((mode_rate_out == 2) ? "out_rate_1_2" :
                            ((mode_rate_out == 4) ? "out_rate_1_4" :
                                                    "out_rate_1_8")); 
localparam l_phy_clk_sel = (phy_clk_sel == 0) ? "phy_clk_sel_uint0" :
                                                "phy_clk_sel_uint1"; 
localparam l_pair_0_ddr4_mode = (pair_0_ddr4_mode == "ddr4_idle") ? "pair0_ddr4_idle" :
                                                                    "pair0_ddr3_idle"; 
localparam l_pair_1_ddr4_mode = (pair_1_ddr4_mode == "ddr4_idle") ? "pair1_ddr4_idle" :
                                                                    "pair1_ddr3_idle"; 
localparam l_pair_2_ddr4_mode = (pair_2_ddr4_mode == "ddr4_idle") ? "pair2_ddr4_idle" :
                                                                    "pair2_ddr3_idle"; 
localparam l_pair_3_ddr4_mode = (pair_3_ddr4_mode == "ddr4_idle") ? "pair3_ddr4_idle" :
                                                                    "pair3_ddr3_idle"; 
localparam l_pair_4_ddr4_mode = (pair_4_ddr4_mode == "ddr4_idle") ? "pair4_ddr4_idle" :
                                                                    "pair4_ddr3_idle"; 
localparam l_pair_5_ddr4_mode = (pair_5_ddr4_mode == "ddr4_idle") ? "pair5_ddr4_idle" :
                                                                    "pair5_ddr3_idle"; 
localparam l_pin_0_initial_out = (pin_0_initial_out == "initial_out_z") ? "pin0_initial_out_z" :
                                ((pin_0_initial_out == "initial_out_0") ? "pin0_initial_out_0" :
                                ((pin_0_initial_out == "initial_out_1") ? "pin0_initial_out_1" :
                                                                          "pin0_initial_out_x")); 
localparam l_pin_0_oct_mode = (pin_0_oct_mode == "static_off") ? "pin0_static_off" :
                             ((pin_0_oct_mode == "static_on") ? "pin0_static_on" :
                                                                "pin0_dynamic"); 
localparam l_pin_0_mode_ddr = (pin_0_mode_ddr == "mode_sdr") ? "pin0_mode_sdr" :
                                                               "pin0_mode_ddr"; 
localparam l_pin_0_dqs_mode = (pin_0_dqs_mode == "dqs_sampler_a") ? "pin0_dqs_sampler_a" :
                             ((pin_0_dqs_mode == "dqs_sampler_b") ? "pin0_dqs_sampler_b" :
                                                                    "pin0_dqs_sampler_b_a_rise"); 
localparam l_pin_0_data_in_mode = (pin_0_data_in_mode == "ca") ? "pin0_ca" :
                                 ((pin_0_data_in_mode == "clock") ? "pin0_clock" :
                                 ((pin_0_data_in_mode == "dq") ? "pin0_dq" :
                                 ((pin_0_data_in_mode == "dqs") ? "pin0_dqs" :
                                 ((pin_0_data_in_mode == "dpa_slave") ? "pin0_dpa_slave" :
                                 ((pin_0_data_in_mode == "dpa_master") ? "pin0_dpa_master" :
                                 ((pin_0_data_in_mode == "dq_xor_a_loopback") ? "pin0_dq_xor_a_loopback" :
                                 ((pin_0_data_in_mode == "dq_xor_b_loopback") ? "pin0_dq_xor_b_loopback" :
                                                                                "pin0_dqs_xor_loopback"))))))); 
localparam l_pin_1_initial_out = (pin_1_initial_out == "initial_out_z") ? "pin1_initial_out_z" :
                                ((pin_1_initial_out == "initial_out_0") ? "pin1_initial_out_0" :
                                ((pin_1_initial_out == "initial_out_1") ? "pin1_initial_out_1" :
                                                                          "pin1_initial_out_x")); 
localparam l_pin_1_oct_mode = (pin_1_oct_mode == "static_off") ? "pin1_static_off" :
                             ((pin_1_oct_mode == "static_on") ? "pin1_static_on" :
                                                                "pin1_dynamic"); 
localparam l_pin_1_mode_ddr = (pin_1_mode_ddr == "mode_sdr") ? "pin1_mode_sdr" :
                                                               "pin1_mode_ddr"; 
localparam l_pin_1_dqs_mode = (pin_1_dqs_mode == "dqs_sampler_a") ? "pin1_dqs_sampler_a" :
                             ((pin_1_dqs_mode == "dqs_sampler_b") ? "pin1_dqs_sampler_b" :
                                                                    "pin1_dqs_sampler_b_a_rise"); 
localparam l_pin_1_data_in_mode = (pin_1_data_in_mode == "ca") ? "pin1_ca" :
                                 ((pin_1_data_in_mode == "clock") ? "pin1_clock" :
                                 ((pin_1_data_in_mode == "dq") ? "pin1_dq" :
                                 ((pin_1_data_in_mode == "dqs") ? "pin1_dqs" :
                                 ((pin_1_data_in_mode == "dpa_slave") ? "pin1_dpa_slave" :
                                 ((pin_1_data_in_mode == "dpa_master") ? "pin1_dpa_master" :
                                 ((pin_1_data_in_mode == "dq_xor_a_loopback") ? "pin1_dq_xor_a_loopback" :
                                 ((pin_1_data_in_mode == "dq_xor_b_loopback") ? "pin1_dq_xor_b_loopback" :
                                                                                "pin1_dqs_xor_loopback"))))))); 
localparam l_pin_2_initial_out = (pin_2_initial_out == "initial_out_z") ? "pin2_initial_out_z" :
                                ((pin_2_initial_out == "initial_out_0") ? "pin2_initial_out_0" :
                                ((pin_2_initial_out == "initial_out_1") ? "pin2_initial_out_1" :
                                                                          "pin2_initial_out_x")); 
localparam l_pin_2_oct_mode = (pin_2_oct_mode == "static_off") ? "pin2_static_off" :
                             ((pin_2_oct_mode == "static_on") ? "pin2_static_on" :
                                                                "pin2_dynamic"); 
localparam l_pin_2_mode_ddr = (pin_2_mode_ddr == "mode_sdr") ? "pin2_mode_sdr" :
                                                               "pin2_mode_ddr"; 
localparam l_pin_2_dqs_mode = (pin_2_dqs_mode == "dqs_sampler_a") ? "pin2_dqs_sampler_a" :
                             ((pin_2_dqs_mode == "dqs_sampler_b") ? "pin2_dqs_sampler_b" :
                                                                    "pin2_dqs_sampler_b_a_rise"); 
localparam l_pin_2_data_in_mode = (pin_2_data_in_mode == "ca") ? "pin2_ca" :
                                 ((pin_2_data_in_mode == "clock") ? "pin2_clock" :
                                 ((pin_2_data_in_mode == "dq") ? "pin2_dq" :
                                 ((pin_2_data_in_mode == "dqs") ? "pin2_dqs" :
                                 ((pin_2_data_in_mode == "dpa_slave") ? "pin2_dpa_slave" :
                                 ((pin_2_data_in_mode == "dpa_master") ? "pin2_dpa_master" :
                                 ((pin_2_data_in_mode == "dq_xor_a_loopback") ? "pin2_dq_xor_a_loopback" :
                                 ((pin_2_data_in_mode == "dq_xor_b_loopback") ? "pin2_dq_xor_b_loopback" :
                                                                                "pin2_dqs_xor_loopback"))))))); 
localparam l_pin_3_initial_out = (pin_3_initial_out == "initial_out_z") ? "pin3_initial_out_z" :
                                ((pin_3_initial_out == "initial_out_0") ? "pin3_initial_out_0" :
                                ((pin_3_initial_out == "initial_out_1") ? "pin3_initial_out_1" :
                                                                          "pin3_initial_out_x")); 
localparam l_pin_3_oct_mode = (pin_3_oct_mode == "static_off") ? "pin3_static_off" :
                             ((pin_3_oct_mode == "static_on") ? "pin3_static_on" :
                                                                "pin3_dynamic"); 
localparam l_pin_3_mode_ddr = (pin_3_mode_ddr == "mode_sdr") ? "pin3_mode_sdr" :
                                                               "pin3_mode_ddr"; 
localparam l_pin_3_dqs_mode = (pin_3_dqs_mode == "dqs_sampler_a") ? "pin3_dqs_sampler_a" :
                             ((pin_3_dqs_mode == "dqs_sampler_b") ? "pin3_dqs_sampler_b" :
                                                                    "pin3_dqs_sampler_b_a_rise"); 
localparam l_pin_3_data_in_mode = (pin_3_data_in_mode == "ca") ? "pin3_ca" :
                                 ((pin_3_data_in_mode == "clock") ? "pin3_clock" :
                                 ((pin_3_data_in_mode == "dq") ? "pin3_dq" :
                                 ((pin_3_data_in_mode == "dqs") ? "pin3_dqs" :
                                 ((pin_3_data_in_mode == "dpa_slave") ? "pin3_dpa_slave" :
                                 ((pin_3_data_in_mode == "dpa_master") ? "pin3_dpa_master" :
                                 ((pin_3_data_in_mode == "dq_xor_a_loopback") ? "pin3_dq_xor_a_loopback" :
                                 ((pin_3_data_in_mode == "dq_xor_b_loopback") ? "pin3_dq_xor_b_loopback" :
                                                                                "pin3_dqs_xor_loopback"))))))); 
localparam l_pin_4_initial_out = (pin_4_initial_out == "initial_out_z") ? "pin4_initial_out_z" :
                                ((pin_4_initial_out == "initial_out_0") ? "pin4_initial_out_0" :
                                ((pin_4_initial_out == "initial_out_1") ? "pin4_initial_out_1" :
                                                                          "pin4_initial_out_x")); 
localparam l_pin_4_oct_mode = (pin_4_oct_mode == "static_off") ? "pin4_static_off" :
                             ((pin_4_oct_mode == "static_on") ? "pin4_static_on" :
                                                                "pin4_dynamic"); 
localparam l_pin_4_mode_ddr = (pin_4_mode_ddr == "mode_sdr") ? "pin4_mode_sdr" :
                                                               "pin4_mode_ddr"; 
localparam l_pin_4_dqs_mode = (pin_4_dqs_mode == "dqs_sampler_a") ? "pin4_dqs_sampler_a" :
                             ((pin_4_dqs_mode == "dqs_sampler_b") ? "pin4_dqs_sampler_b" :
                                                                    "pin4_dqs_sampler_b_a_rise"); 
localparam l_pin_4_data_in_mode = (pin_4_data_in_mode == "ca") ? "pin4_ca" :
                                 ((pin_4_data_in_mode == "clock") ? "pin4_clock" :
                                 ((pin_4_data_in_mode == "dq") ? "pin4_dq" :
                                 ((pin_4_data_in_mode == "dqs") ? "pin4_dqs" :
                                 ((pin_4_data_in_mode == "dpa_slave") ? "pin4_dpa_slave" :
                                 ((pin_4_data_in_mode == "dpa_master") ? "pin4_dpa_master" :
                                 ((pin_4_data_in_mode == "dq_xor_a_loopback") ? "pin4_dq_xor_a_loopback" :
                                 ((pin_4_data_in_mode == "dq_xor_b_loopback") ? "pin4_dq_xor_b_loopback" :
                                                                                "pin4_dqs_xor_loopback"))))))); 
localparam l_pin_5_initial_out = (pin_5_initial_out == "initial_out_z") ? "pin5_initial_out_z" :
                                ((pin_5_initial_out == "initial_out_0") ? "pin5_initial_out_0" :
                                ((pin_5_initial_out == "initial_out_1") ? "pin5_initial_out_1" :
                                                                          "pin5_initial_out_x")); 
localparam l_pin_5_oct_mode = (pin_5_oct_mode == "static_off") ? "pin5_static_off" :
                             ((pin_5_oct_mode == "static_on") ? "pin5_static_on" :
                                                                "pin5_dynamic"); 
localparam l_pin_5_mode_ddr = (pin_5_mode_ddr == "mode_sdr") ? "pin5_mode_sdr" :
                                                               "pin5_mode_ddr"; 
localparam l_pin_5_dqs_mode = (pin_5_dqs_mode == "dqs_sampler_a") ? "pin5_dqs_sampler_a" :
                             ((pin_5_dqs_mode == "dqs_sampler_b") ? "pin5_dqs_sampler_b" :
                                                                    "pin5_dqs_sampler_b_a_rise"); 
localparam l_pin_5_data_in_mode = (pin_5_data_in_mode == "ca") ? "pin5_ca" :
                                 ((pin_5_data_in_mode == "clock") ? "pin5_clock" :
                                 ((pin_5_data_in_mode == "dq") ? "pin5_dq" :
                                 ((pin_5_data_in_mode == "dqs") ? "pin5_dqs" :
                                 ((pin_5_data_in_mode == "dpa_slave") ? "pin5_dpa_slave" :
                                 ((pin_5_data_in_mode == "dpa_master") ? "pin5_dpa_master" :
                                 ((pin_5_data_in_mode == "dq_xor_a_loopback") ? "pin5_dq_xor_a_loopback" :
                                 ((pin_5_data_in_mode == "dq_xor_b_loopback") ? "pin5_dq_xor_b_loopback" :
                                                                                "pin5_dqs_xor_loopback"))))))); 
localparam l_pin_6_initial_out = (pin_6_initial_out == "initial_out_z") ? "pin6_initial_out_z" :
                                ((pin_6_initial_out == "initial_out_0") ? "pin6_initial_out_0" :
                                ((pin_6_initial_out == "initial_out_1") ? "pin6_initial_out_1" :
                                                                          "pin6_initial_out_x")); 
localparam l_pin_6_oct_mode = (pin_6_oct_mode == "static_off") ? "pin6_static_off" :
                             ((pin_6_oct_mode == "static_on") ? "pin6_static_on" :
                                                                "pin6_dynamic"); 
localparam l_pin_6_mode_ddr = (pin_6_mode_ddr == "mode_sdr") ? "pin6_mode_sdr" :
                                                               "pin6_mode_ddr"; 
localparam l_pin_6_dqs_mode = (pin_6_dqs_mode == "dqs_sampler_a") ? "pin6_dqs_sampler_a" :
                             ((pin_6_dqs_mode == "dqs_sampler_b") ? "pin6_dqs_sampler_b" :
                                                                    "pin6_dqs_sampler_b_a_rise"); 
localparam l_pin_6_data_in_mode = (pin_6_data_in_mode == "ca") ? "pin6_ca" :
                                 ((pin_6_data_in_mode == "clock") ? "pin6_clock" :
                                 ((pin_6_data_in_mode == "dq") ? "pin6_dq" :
                                 ((pin_6_data_in_mode == "dqs") ? "pin6_dqs" :
                                 ((pin_6_data_in_mode == "dpa_slave") ? "pin6_dpa_slave" :
                                 ((pin_6_data_in_mode == "dpa_master") ? "pin6_dpa_master" :
                                 ((pin_6_data_in_mode == "dq_xor_a_loopback") ? "pin6_dq_xor_a_loopback" :
                                 ((pin_6_data_in_mode == "dq_xor_b_loopback") ? "pin6_dq_xor_b_loopback" :
                                                                                "pin6_dqs_xor_loopback"))))))); 
localparam l_pin_7_initial_out = (pin_7_initial_out == "initial_out_z") ? "pin7_initial_out_z" :
                                ((pin_7_initial_out == "initial_out_0") ? "pin7_initial_out_0" :
                                ((pin_7_initial_out == "initial_out_1") ? "pin7_initial_out_1" :
                                                                          "pin7_initial_out_x")); 
localparam l_pin_7_oct_mode = (pin_7_oct_mode == "static_off") ? "pin7_static_off" :
                             ((pin_7_oct_mode == "static_on") ? "pin7_static_on" :
                                                                "pin7_dynamic"); 
localparam l_pin_7_mode_ddr = (pin_7_mode_ddr == "mode_sdr") ? "pin7_mode_sdr" :
                                                               "pin7_mode_ddr"; 
localparam l_pin_7_dqs_mode = (pin_7_dqs_mode == "dqs_sampler_a") ? "pin7_dqs_sampler_a" :
                             ((pin_7_dqs_mode == "dqs_sampler_b") ? "pin7_dqs_sampler_b" :
                                                                    "pin7_dqs_sampler_b_a_rise"); 
localparam l_pin_7_data_in_mode = (pin_7_data_in_mode == "ca") ? "pin7_ca" :
                                 ((pin_7_data_in_mode == "clock") ? "pin7_clock" :
                                 ((pin_7_data_in_mode == "dq") ? "pin7_dq" :
                                 ((pin_7_data_in_mode == "dqs") ? "pin7_dqs" :
                                 ((pin_7_data_in_mode == "dpa_slave") ? "pin7_dpa_slave" :
                                 ((pin_7_data_in_mode == "dpa_master") ? "pin7_dpa_master" :
                                 ((pin_7_data_in_mode == "dq_xor_a_loopback") ? "pin7_dq_xor_a_loopback" :
                                 ((pin_7_data_in_mode == "dq_xor_b_loopback") ? "pin7_dq_xor_b_loopback" :
                                                                                "pin7_dqs_xor_loopback"))))))); 
localparam l_pin_8_initial_out = (pin_8_initial_out == "initial_out_z") ? "pin8_initial_out_z" :
                                ((pin_8_initial_out == "initial_out_0") ? "pin8_initial_out_0" :
                                ((pin_8_initial_out == "initial_out_1") ? "pin8_initial_out_1" :
                                                                          "pin8_initial_out_x")); 
localparam l_pin_8_oct_mode = (pin_8_oct_mode == "static_off") ? "pin8_static_off" :
                             ((pin_8_oct_mode == "static_on") ? "pin8_static_on" :
                                                                "pin8_dynamic"); 
localparam l_pin_8_mode_ddr = (pin_8_mode_ddr == "mode_sdr") ? "pin8_mode_sdr" :
                                                               "pin8_mode_ddr"; 
localparam l_pin_8_dqs_mode = (pin_8_dqs_mode == "dqs_sampler_a") ? "pin8_dqs_sampler_a" :
                             ((pin_8_dqs_mode == "dqs_sampler_b") ? "pin8_dqs_sampler_b" :
                                                                    "pin8_dqs_sampler_b_a_rise"); 
localparam l_pin_8_data_in_mode = (pin_8_data_in_mode == "ca") ? "pin8_ca" :
                                 ((pin_8_data_in_mode == "clock") ? "pin8_clock" :
                                 ((pin_8_data_in_mode == "dq") ? "pin8_dq" :
                                 ((pin_8_data_in_mode == "dqs") ? "pin8_dqs" :
                                 ((pin_8_data_in_mode == "dpa_slave") ? "pin8_dpa_slave" :
                                 ((pin_8_data_in_mode == "dpa_master") ? "pin8_dpa_master" :
                                 ((pin_8_data_in_mode == "dq_xor_a_loopback") ? "pin8_dq_xor_a_loopback" :
                                 ((pin_8_data_in_mode == "dq_xor_b_loopback") ? "pin8_dq_xor_b_loopback" :
                                                                                "pin8_dqs_xor_loopback"))))))); 
localparam l_pin_9_initial_out = (pin_9_initial_out == "initial_out_z") ? "pin9_initial_out_z" :
                                ((pin_9_initial_out == "initial_out_0") ? "pin9_initial_out_0" :
                                ((pin_9_initial_out == "initial_out_1") ? "pin9_initial_out_1" :
                                                                          "pin9_initial_out_x")); 
localparam l_pin_9_oct_mode = (pin_9_oct_mode == "static_off") ? "pin9_static_off" :
                             ((pin_9_oct_mode == "static_on") ? "pin9_static_on" :
                                                                "pin9_dynamic"); 
localparam l_pin_9_mode_ddr = (pin_9_mode_ddr == "mode_sdr") ? "pin9_mode_sdr" :
                                                               "pin9_mode_ddr"; 
localparam l_pin_9_dqs_mode = (pin_9_dqs_mode == "dqs_sampler_a") ? "pin9_dqs_sampler_a" :
                             ((pin_9_dqs_mode == "dqs_sampler_b") ? "pin9_dqs_sampler_b" :
                                                                    "pin9_dqs_sampler_b_a_rise"); 
localparam l_pin_9_data_in_mode = (pin_9_data_in_mode == "ca") ? "pin9_ca" :
                                 ((pin_9_data_in_mode == "clock") ? "pin9_clock" :
                                 ((pin_9_data_in_mode == "dq") ? "pin9_dq" :
                                 ((pin_9_data_in_mode == "dqs") ? "pin9_dqs" :
                                 ((pin_9_data_in_mode == "dpa_slave") ? "pin9_dpa_slave" :
                                 ((pin_9_data_in_mode == "dpa_master") ? "pin9_dpa_master" :
                                 ((pin_9_data_in_mode == "dq_xor_a_loopback") ? "pin9_dq_xor_a_loopback" :
                                 ((pin_9_data_in_mode == "dq_xor_b_loopback") ? "pin9_dq_xor_b_loopback" :
                                                                                "pin9_dqs_xor_loopback"))))))); 
localparam l_pin_10_initial_out = (pin_10_initial_out == "initial_out_z") ? "pin10_initial_out_z" :
                                 ((pin_10_initial_out == "initial_out_0") ? "pin10_initial_out_0" :
                                 ((pin_10_initial_out == "initial_out_1") ? "pin10_initial_out_1" :
                                                                            "pin10_initial_out_x")); 
localparam l_pin_10_oct_mode = (pin_10_oct_mode == "static_off") ? "pin10_static_off" :
                              ((pin_10_oct_mode == "static_on") ? "pin10_static_on" :
                                                                  "pin10_dynamic"); 
localparam l_pin_10_mode_ddr = (pin_10_mode_ddr == "mode_sdr") ? "pin10_mode_sdr" :
                                                                 "pin10_mode_ddr"; 
localparam l_pin_10_dqs_mode = (pin_10_dqs_mode == "dqs_sampler_a") ? "pin10_dqs_sampler_a" :
                              ((pin_10_dqs_mode == "dqs_sampler_b") ? "pin10_dqs_sampler_b" :
                                                                      "pin10_dqs_sampler_b_a_rise"); 
localparam l_pin_10_data_in_mode = (pin_10_data_in_mode == "ca") ? "pin10_ca" :
                                  ((pin_10_data_in_mode == "clock") ? "pin10_clock" :
                                  ((pin_10_data_in_mode == "dq") ? "pin10_dq" :
                                  ((pin_10_data_in_mode == "dqs") ? "pin10_dqs" :
                                  ((pin_10_data_in_mode == "dpa_slave") ? "pin10_dpa_slave" :
                                  ((pin_10_data_in_mode == "dpa_master") ? "pin10_dpa_master" :
                                  ((pin_10_data_in_mode == "dq_xor_a_loopback") ? "pin10_dq_xor_a_loopback" :
                                  ((pin_10_data_in_mode == "dq_xor_b_loopback") ? "pin10_dq_xor_b_loopback" :
                                                                                  "pin10_dqs_xor_loopback"))))))); 
localparam l_pin_11_initial_out = (pin_11_initial_out == "initial_out_z") ? "pin11_initial_out_z" :
                                 ((pin_11_initial_out == "initial_out_0") ? "pin11_initial_out_0" :
                                 ((pin_11_initial_out == "initial_out_1") ? "pin11_initial_out_1" :
                                                                            "pin11_initial_out_x")); 
localparam l_pin_11_oct_mode = (pin_11_oct_mode == "static_off") ? "pin11_static_off" :
                              ((pin_11_oct_mode == "static_on") ? "pin11_static_on" :
                                                                  "pin11_dynamic"); 
localparam l_pin_11_mode_ddr = (pin_11_mode_ddr == "mode_sdr") ? "pin11_mode_sdr" :
                                                                 "pin11_mode_ddr"; 
localparam l_pin_11_dqs_mode = (pin_11_dqs_mode == "dqs_sampler_a") ? "pin11_dqs_sampler_a" :
                              ((pin_11_dqs_mode == "dqs_sampler_b") ? "pin11_dqs_sampler_b" :
                                                                      "pin11_dqs_sampler_b_a_rise"); 
localparam l_pin_11_data_in_mode = (pin_11_data_in_mode == "ca") ? "pin11_ca" :
                                  ((pin_11_data_in_mode == "clock") ? "pin11_clock" :
                                  ((pin_11_data_in_mode == "dq") ? "pin11_dq" :
                                  ((pin_11_data_in_mode == "dqs") ? "pin11_dqs" :
                                  ((pin_11_data_in_mode == "dpa_slave") ? "pin11_dpa_slave" :
                                  ((pin_11_data_in_mode == "dpa_master") ? "pin11_dpa_master" :
                                  ((pin_11_data_in_mode == "dq_xor_a_loopback") ? "pin11_dq_xor_a_loopback" :
                                  ((pin_11_data_in_mode == "dq_xor_b_loopback") ? "pin11_dq_xor_b_loopback" :
                                                                                  "pin11_dqs_xor_loopback"))))))); 

localparam l_db_pin_0_mode = (db_pin_0_mode == "ac_ddr4_hmc") ? "pin0_ac_ddr4_hmc" :
                            ((db_pin_0_mode == "dq_wdb_ddr4_mode") ? "pin0_dq_wdb_ddr4_mode" :
                            ((db_pin_0_mode == "dm_wdb_ddr4_mode") ? "pin0_dm_wdb_ddr4_mode" :
                            ((db_pin_0_mode == "dbi_wdb_ddr4_mode") ? "pin0_dbi_wdb_ddr4_mode" :
                            ((db_pin_0_mode == "clk_wdb_ddr4_mode") ? "pin0_clk_wdb_ddr4_mode" :
                            ((db_pin_0_mode == "clkb_wdb_ddr4_mode") ? "pin0_clkb_wdb_ddr4_mode" :
                            ((db_pin_0_mode == "dqs_wdb_ddr4_mode") ? "pin0_dqs_wdb_ddr4_mode" :
                            ((db_pin_0_mode == "dqsb_wdb_ddr4_mode") ? "pin0_dqsb_wdb_ddr4_mode" :
                            ((db_pin_0_mode == "ac_hmc") ? "pin0_ac_hmc" :
                            ((db_pin_0_mode == "dq_wdb_mode") ? "pin0_dq_wdb_mode" :
                            ((db_pin_0_mode == "dm_wdb_mode") ? "pin0_dm_wdb_mode" :
                            ((db_pin_0_mode == "dbi_wdb_mode") ? "pin0_dbi_wdb_mode" :
                            ((db_pin_0_mode == "clk_wdb_mode") ? "pin0_clk_wdb_mode" :
                            ((db_pin_0_mode == "clkb_wdb_mode") ? "pin0_clkb_wdb_mode" :
                            ((db_pin_0_mode == "dqs_wdb_mode") ? "pin0_dqs_wdb_mode" :
                            ((db_pin_0_mode == "dqsb_wdb_mode") ? "pin0_dqsb_wdb_mode" :
                            ((db_pin_0_mode == "ac_core") ? "pin0_ac_core" :
                            ((db_pin_0_mode == "dq_mode") ? "pin0_dq_mode" :
                            ((db_pin_0_mode == "dm_mode") ? "pin0_dm_mode" :
                            ((db_pin_0_mode == "dbi_mode") ? "pin0_dbi_mode" :
                            ((db_pin_0_mode == "clk_mode") ? "pin0_clk_mode" :
                            ((db_pin_0_mode == "clkb_mode") ? "pin0_clkb_mode" :
                            ((db_pin_0_mode == "dqs_mode") ? "pin0_dqs_mode" :
                            ((db_pin_0_mode == "dqsb_mode") ? "pin0_dqsb_mode" :
                            ((db_pin_0_mode == "dqs_ddr4_mode") ? "pin0_dqs_ddr4_mode" :
                            ((db_pin_0_mode == "dqsb_ddr4_mode") ? "pin0_dqsb_ddr4_mode" :
                            ((db_pin_0_mode == "rdq_mode") ? "pin0_rdq_mode" :
                            ((db_pin_0_mode == "rdqs_mode") ? "pin0_rdqs_mode" :
                                                             "pin0_gpio_mode"))))))))))))))))))))))))))); 

localparam l_db_pin_1_mode = (db_pin_1_mode == "ac_ddr4_hmc") ? "pin1_ac_ddr4_hmc" :
                            ((db_pin_1_mode == "dq_wdb_ddr4_mode") ? "pin1_dq_wdb_ddr4_mode" :
                            ((db_pin_1_mode == "dm_wdb_ddr4_mode") ? "pin1_dm_wdb_ddr4_mode" :
                            ((db_pin_1_mode == "dbi_wdb_ddr4_mode") ? "pin1_dbi_wdb_ddr4_mode" :
                            ((db_pin_1_mode == "clk_wdb_ddr4_mode") ? "pin1_clk_wdb_ddr4_mode" :
                            ((db_pin_1_mode == "clkb_wdb_ddr4_mode") ? "pin1_clkb_wdb_ddr4_mode" :
                            ((db_pin_1_mode == "dqs_wdb_ddr4_mode") ? "pin1_dqs_wdb_ddr4_mode" :
                            ((db_pin_1_mode == "dqsb_wdb_ddr4_mode") ? "pin1_dqsb_wdb_ddr4_mode" :
                            ((db_pin_1_mode == "ac_hmc") ? "pin1_ac_hmc" :
                            ((db_pin_1_mode == "dq_wdb_mode") ? "pin1_dq_wdb_mode" :
                            ((db_pin_1_mode == "dm_wdb_mode") ? "pin1_dm_wdb_mode" :
                            ((db_pin_1_mode == "dbi_wdb_mode") ? "pin1_dbi_wdb_mode" :
                            ((db_pin_1_mode == "clk_wdb_mode") ? "pin1_clk_wdb_mode" :
                            ((db_pin_1_mode == "clkb_wdb_mode") ? "pin1_clkb_wdb_mode" :
                            ((db_pin_1_mode == "dqs_wdb_mode") ? "pin1_dqs_wdb_mode" :
                            ((db_pin_1_mode == "dqsb_wdb_mode") ? "pin1_dqsb_wdb_mode" :
                            ((db_pin_1_mode == "ac_core") ? "pin1_ac_core" :
                            ((db_pin_1_mode == "dq_mode") ? "pin1_dq_mode" :
                            ((db_pin_1_mode == "dm_mode") ? "pin1_dm_mode" :
                            ((db_pin_1_mode == "dbi_mode") ? "pin1_dbi_mode" :
                            ((db_pin_1_mode == "clk_mode") ? "pin1_clk_mode" :
                            ((db_pin_1_mode == "clkb_mode") ? "pin1_clkb_mode" :
                            ((db_pin_1_mode == "dqs_mode") ? "pin1_dqs_mode" :
                            ((db_pin_1_mode == "dqsb_mode") ? "pin1_dqsb_mode" :
                            ((db_pin_1_mode == "dqs_ddr4_mode") ? "pin1_dqs_ddr4_mode" :
                            ((db_pin_1_mode == "dqsb_ddr4_mode") ? "pin1_dqsb_ddr4_mode" :
                            ((db_pin_1_mode == "rdq_mode") ? "pin1_rdq_mode" :
                            ((db_pin_1_mode == "rdqs_mode") ? "pin1_rdqs_mode" :
                                                                 "pin1_gpio_mode"))))))))))))))))))))))))))); 

localparam l_db_pin_2_mode = (db_pin_2_mode == "ac_ddr4_hmc") ? "pin2_ac_ddr4_hmc" :
                            ((db_pin_2_mode == "dq_wdb_ddr4_mode") ? "pin2_dq_wdb_ddr4_mode" :
                            ((db_pin_2_mode == "dm_wdb_ddr4_mode") ? "pin2_dm_wdb_ddr4_mode" :
                            ((db_pin_2_mode == "dbi_wdb_ddr4_mode") ? "pin2_dbi_wdb_ddr4_mode" :
                            ((db_pin_2_mode == "clk_wdb_ddr4_mode") ? "pin2_clk_wdb_ddr4_mode" :
                            ((db_pin_2_mode == "clkb_wdb_ddr4_mode") ? "pin2_clkb_wdb_ddr4_mode" :
                            ((db_pin_2_mode == "dqs_wdb_ddr4_mode") ? "pin2_dqs_wdb_ddr4_mode" :
                            ((db_pin_2_mode == "dqsb_wdb_ddr4_mode") ? "pin2_dqsb_wdb_ddr4_mode" :
                            ((db_pin_2_mode == "ac_hmc") ? "pin2_ac_hmc" :
                            ((db_pin_2_mode == "dq_wdb_mode") ? "pin2_dq_wdb_mode" :
                            ((db_pin_2_mode == "dm_wdb_mode") ? "pin2_dm_wdb_mode" :
                            ((db_pin_2_mode == "dbi_wdb_mode") ? "pin2_dbi_wdb_mode" :
                            ((db_pin_2_mode == "clk_wdb_mode") ? "pin2_clk_wdb_mode" :
                            ((db_pin_2_mode == "clkb_wdb_mode") ? "pin2_clkb_wdb_mode" :
                            ((db_pin_2_mode == "dqs_wdb_mode") ? "pin2_dqs_wdb_mode" :
                            ((db_pin_2_mode == "dqsb_wdb_mode") ? "pin2_dqsb_wdb_mode" :
                            ((db_pin_2_mode == "ac_core") ? "pin2_ac_core" :
                            ((db_pin_2_mode == "dq_mode") ? "pin2_dq_mode" :
                            ((db_pin_2_mode == "dm_mode") ? "pin2_dm_mode" :
                            ((db_pin_2_mode == "dbi_mode") ? "pin2_dbi_mode" :
                            ((db_pin_2_mode == "clk_mode") ? "pin2_clk_mode" :
                            ((db_pin_2_mode == "clkb_mode") ? "pin2_clkb_mode" :
                            ((db_pin_2_mode == "dqs_mode") ? "pin2_dqs_mode" :
                            ((db_pin_2_mode == "dqsb_mode") ? "pin2_dqsb_mode" :
                            ((db_pin_2_mode == "dqs_ddr4_mode") ? "pin2_dqs_ddr4_mode" :
                            ((db_pin_2_mode == "dqsb_ddr4_mode") ? "pin2_dqsb_ddr4_mode" :
                            ((db_pin_2_mode == "rdq_mode") ? "pin2_rdq_mode" :
                            ((db_pin_2_mode == "rdqs_mode") ? "pin2_rdqs_mode" :
                                                                 "pin2_gpio_mode"))))))))))))))))))))))))))); 

localparam l_db_pin_3_mode = (db_pin_3_mode == "ac_ddr4_hmc") ? "pin3_ac_ddr4_hmc" :
                            ((db_pin_3_mode == "dq_wdb_ddr4_mode") ? "pin3_dq_wdb_ddr4_mode" :
                            ((db_pin_3_mode == "dm_wdb_ddr4_mode") ? "pin3_dm_wdb_ddr4_mode" :
                            ((db_pin_3_mode == "dbi_wdb_ddr4_mode") ? "pin3_dbi_wdb_ddr4_mode" :
                            ((db_pin_3_mode == "clk_wdb_ddr4_mode") ? "pin3_clk_wdb_ddr4_mode" :
                            ((db_pin_3_mode == "clkb_wdb_ddr4_mode") ? "pin3_clkb_wdb_ddr4_mode" :
                            ((db_pin_3_mode == "dqs_wdb_ddr4_mode") ? "pin3_dqs_wdb_ddr4_mode" :
                            ((db_pin_3_mode == "dqsb_wdb_ddr4_mode") ? "pin3_dqsb_wdb_ddr4_mode" :
                            ((db_pin_3_mode == "ac_hmc") ? "pin3_ac_hmc" :
                            ((db_pin_3_mode == "dq_wdb_mode") ? "pin3_dq_wdb_mode" :
                            ((db_pin_3_mode == "dm_wdb_mode") ? "pin3_dm_wdb_mode" :
                            ((db_pin_3_mode == "dbi_wdb_mode") ? "pin3_dbi_wdb_mode" :
                            ((db_pin_3_mode == "clk_wdb_mode") ? "pin3_clk_wdb_mode" :
                            ((db_pin_3_mode == "clkb_wdb_mode") ? "pin3_clkb_wdb_mode" :
                            ((db_pin_3_mode == "dqs_wdb_mode") ? "pin3_dqs_wdb_mode" :
                            ((db_pin_3_mode == "dqsb_wdb_mode") ? "pin3_dqsb_wdb_mode" :
                            ((db_pin_3_mode == "ac_core") ? "pin3_ac_core" :
                            ((db_pin_3_mode == "dq_mode") ? "pin3_dq_mode" :
                            ((db_pin_3_mode == "dm_mode") ? "pin3_dm_mode" :
                            ((db_pin_3_mode == "dbi_mode") ? "pin3_dbi_mode" :
                            ((db_pin_3_mode == "clk_mode") ? "pin3_clk_mode" :
                            ((db_pin_3_mode == "clkb_mode") ? "pin3_clkb_mode" :
                            ((db_pin_3_mode == "dqs_mode") ? "pin3_dqs_mode" :
                            ((db_pin_3_mode == "dqsb_mode") ? "pin3_dqsb_mode" :
                            ((db_pin_3_mode == "dqs_ddr4_mode") ? "pin3_dqs_ddr4_mode" :
                            ((db_pin_3_mode == "dqsb_ddr4_mode") ? "pin3_dqsb_ddr4_mode" :
                            ((db_pin_3_mode == "rdq_mode") ? "pin3_rdq_mode" :
                            ((db_pin_3_mode == "rdqs_mode") ? "pin3_rdqs_mode" :
                                                                 "pin3_gpio_mode"))))))))))))))))))))))))))); 

localparam l_db_pin_4_mode = (db_pin_4_mode == "ac_ddr4_hmc") ? "pin4_ac_ddr4_hmc" :
                            ((db_pin_4_mode == "dq_wdb_ddr4_mode") ? "pin4_dq_wdb_ddr4_mode" :
                            ((db_pin_4_mode == "dm_wdb_ddr4_mode") ? "pin4_dm_wdb_ddr4_mode" :
                            ((db_pin_4_mode == "dbi_wdb_ddr4_mode") ? "pin4_dbi_wdb_ddr4_mode" :
                            ((db_pin_4_mode == "clk_wdb_ddr4_mode") ? "pin4_clk_wdb_ddr4_mode" :
                            ((db_pin_4_mode == "clkb_wdb_ddr4_mode") ? "pin4_clkb_wdb_ddr4_mode" :
                            ((db_pin_4_mode == "dqs_wdb_ddr4_mode") ? "pin4_dqs_wdb_ddr4_mode" :
                            ((db_pin_4_mode == "dqsb_wdb_ddr4_mode") ? "pin4_dqsb_wdb_ddr4_mode" :
                            ((db_pin_4_mode == "ac_hmc") ? "pin4_ac_hmc" :
                            ((db_pin_4_mode == "dq_wdb_mode") ? "pin4_dq_wdb_mode" :
                            ((db_pin_4_mode == "dm_wdb_mode") ? "pin4_dm_wdb_mode" :
                            ((db_pin_4_mode == "dbi_wdb_mode") ? "pin4_dbi_wdb_mode" :
                            ((db_pin_4_mode == "clk_wdb_mode") ? "pin4_clk_wdb_mode" :
                            ((db_pin_4_mode == "clkb_wdb_mode") ? "pin4_clkb_wdb_mode" :
                            ((db_pin_4_mode == "dqs_wdb_mode") ? "pin4_dqs_wdb_mode" :
                            ((db_pin_4_mode == "dqsb_wdb_mode") ? "pin4_dqsb_wdb_mode" :
                            ((db_pin_4_mode == "ac_core") ? "pin4_ac_core" :
                            ((db_pin_4_mode == "dq_mode") ? "pin4_dq_mode" :
                            ((db_pin_4_mode == "dm_mode") ? "pin4_dm_mode" :
                            ((db_pin_4_mode == "dbi_mode") ? "pin4_dbi_mode" :
                            ((db_pin_4_mode == "clk_mode") ? "pin4_clk_mode" :
                            ((db_pin_4_mode == "clkb_mode") ? "pin4_clkb_mode" :
                            ((db_pin_4_mode == "dqs_mode") ? "pin4_dqs_mode" :
                            ((db_pin_4_mode == "dqsb_mode") ? "pin4_dqsb_mode" :
                            ((db_pin_4_mode == "dqs_ddr4_mode") ? "pin4_dqs_ddr4_mode" :
                            ((db_pin_4_mode == "dqsb_ddr4_mode") ? "pin4_dqsb_ddr4_mode" :
                            ((db_pin_4_mode == "rdq_mode") ? "pin4_rdq_mode" :
                            ((db_pin_4_mode == "rdqs_mode") ? "pin4_rdqs_mode" :
                                                                 "pin4_gpio_mode"))))))))))))))))))))))))))); 

localparam l_db_pin_5_mode = (db_pin_5_mode == "ac_ddr4_hmc") ? "pin5_ac_ddr4_hmc" :
                            ((db_pin_5_mode == "dq_wdb_ddr4_mode") ? "pin5_dq_wdb_ddr4_mode" :
                            ((db_pin_5_mode == "dm_wdb_ddr4_mode") ? "pin5_dm_wdb_ddr4_mode" :
                            ((db_pin_5_mode == "dbi_wdb_ddr4_mode") ? "pin5_dbi_wdb_ddr4_mode" :
                            ((db_pin_5_mode == "clk_wdb_ddr4_mode") ? "pin5_clk_wdb_ddr4_mode" :
                            ((db_pin_5_mode == "clkb_wdb_ddr4_mode") ? "pin5_clkb_wdb_ddr4_mode" :
                            ((db_pin_5_mode == "dqs_wdb_ddr4_mode") ? "pin5_dqs_wdb_ddr4_mode" :
                            ((db_pin_5_mode == "dqsb_wdb_ddr4_mode") ? "pin5_dqsb_wdb_ddr4_mode" :
                            ((db_pin_5_mode == "ac_hmc") ? "pin5_ac_hmc" :
                            ((db_pin_5_mode == "dq_wdb_mode") ? "pin5_dq_wdb_mode" :
                            ((db_pin_5_mode == "dm_wdb_mode") ? "pin5_dm_wdb_mode" :
                            ((db_pin_5_mode == "dbi_wdb_mode") ? "pin5_dbi_wdb_mode" :
                            ((db_pin_5_mode == "clk_wdb_mode") ? "pin5_clk_wdb_mode" :
                            ((db_pin_5_mode == "clkb_wdb_mode") ? "pin5_clkb_wdb_mode" :
                            ((db_pin_5_mode == "dqs_wdb_mode") ? "pin5_dqs_wdb_mode" :
                            ((db_pin_5_mode == "dqsb_wdb_mode") ? "pin5_dqsb_wdb_mode" :
                            ((db_pin_5_mode == "ac_core") ? "pin5_ac_core" :
                            ((db_pin_5_mode == "dq_mode") ? "pin5_dq_mode" :
                            ((db_pin_5_mode == "dm_mode") ? "pin5_dm_mode" :
                            ((db_pin_5_mode == "dbi_mode") ? "pin5_dbi_mode" :
                            ((db_pin_5_mode == "clk_mode") ? "pin5_clk_mode" :
                            ((db_pin_5_mode == "clkb_mode") ? "pin5_clkb_mode" :
                            ((db_pin_5_mode == "dqs_mode") ? "pin5_dqs_mode" :
                            ((db_pin_5_mode == "dqsb_mode") ? "pin5_dqsb_mode" :
                            ((db_pin_5_mode == "dqs_ddr4_mode") ? "pin5_dqs_ddr4_mode" :
                            ((db_pin_5_mode == "dqsb_ddr4_mode") ? "pin5_dqsb_ddr4_mode" :
                            ((db_pin_5_mode == "rdq_mode") ? "pin5_rdq_mode" :
                            ((db_pin_5_mode == "rdqs_mode") ? "pin5_rdqs_mode" :
                                                                 "pin5_gpio_mode"))))))))))))))))))))))))))); 

localparam l_db_pin_6_mode = (db_pin_6_mode == "ac_ddr4_hmc") ? "pin6_ac_ddr4_hmc" :
                            ((db_pin_6_mode == "dq_wdb_ddr4_mode") ? "pin6_dq_wdb_ddr4_mode" :
                            ((db_pin_6_mode == "dm_wdb_ddr4_mode") ? "pin6_dm_wdb_ddr4_mode" :
                            ((db_pin_6_mode == "dbi_wdb_ddr4_mode") ? "pin6_dbi_wdb_ddr4_mode" :
                            ((db_pin_6_mode == "clk_wdb_ddr4_mode") ? "pin6_clk_wdb_ddr4_mode" :
                            ((db_pin_6_mode == "clkb_wdb_ddr4_mode") ? "pin6_clkb_wdb_ddr4_mode" :
                            ((db_pin_6_mode == "dqs_wdb_ddr4_mode") ? "pin6_dqs_wdb_ddr4_mode" :
                            ((db_pin_6_mode == "dqsb_wdb_ddr4_mode") ? "pin6_dqsb_wdb_ddr4_mode" :
                            ((db_pin_6_mode == "ac_hmc") ? "pin6_ac_hmc" :
                            ((db_pin_6_mode == "dq_wdb_mode") ? "pin6_dq_wdb_mode" :
                            ((db_pin_6_mode == "dm_wdb_mode") ? "pin6_dm_wdb_mode" :
                            ((db_pin_6_mode == "dbi_wdb_mode") ? "pin6_dbi_wdb_mode" :
                            ((db_pin_6_mode == "clk_wdb_mode") ? "pin6_clk_wdb_mode" :
                            ((db_pin_6_mode == "clkb_wdb_mode") ? "pin6_clkb_wdb_mode" :
                            ((db_pin_6_mode == "dqs_wdb_mode") ? "pin6_dqs_wdb_mode" :
                            ((db_pin_6_mode == "dqsb_wdb_mode") ? "pin6_dqsb_wdb_mode" :
                            ((db_pin_6_mode == "ac_core") ? "pin6_ac_core" :
                            ((db_pin_6_mode == "dq_mode") ? "pin6_dq_mode" :
                            ((db_pin_6_mode == "dm_mode") ? "pin6_dm_mode" :
                            ((db_pin_6_mode == "dbi_mode") ? "pin6_dbi_mode" :
                            ((db_pin_6_mode == "clk_mode") ? "pin6_clk_mode" :
                            ((db_pin_6_mode == "clkb_mode") ? "pin6_clkb_mode" :
                            ((db_pin_6_mode == "dqs_mode") ? "pin6_dqs_mode" :
                            ((db_pin_6_mode == "dqsb_mode") ? "pin6_dqsb_mode" :
                            ((db_pin_6_mode == "dqs_ddr4_mode") ? "pin6_dqs_ddr4_mode" :
                            ((db_pin_6_mode == "dqsb_ddr4_mode") ? "pin6_dqsb_ddr4_mode" :
                            ((db_pin_6_mode == "rdq_mode") ? "pin6_rdq_mode" :
                            ((db_pin_6_mode == "rdqs_mode") ? "pin6_rdqs_mode" :
                                                                 "pin6_gpio_mode"))))))))))))))))))))))))))); 

localparam l_db_pin_7_mode = (db_pin_7_mode == "ac_ddr4_hmc") ? "pin7_ac_ddr4_hmc" :
                            ((db_pin_7_mode == "dq_wdb_ddr4_mode") ? "pin7_dq_wdb_ddr4_mode" :
                            ((db_pin_7_mode == "dm_wdb_ddr4_mode") ? "pin7_dm_wdb_ddr4_mode" :
                            ((db_pin_7_mode == "dbi_wdb_ddr4_mode") ? "pin7_dbi_wdb_ddr4_mode" :
                            ((db_pin_7_mode == "clk_wdb_ddr4_mode") ? "pin7_clk_wdb_ddr4_mode" :
                            ((db_pin_7_mode == "clkb_wdb_ddr4_mode") ? "pin7_clkb_wdb_ddr4_mode" :
                            ((db_pin_7_mode == "dqs_wdb_ddr4_mode") ? "pin7_dqs_wdb_ddr4_mode" :
                            ((db_pin_7_mode == "dqsb_wdb_ddr4_mode") ? "pin7_dqsb_wdb_ddr4_mode" :
                            ((db_pin_7_mode == "ac_hmc") ? "pin7_ac_hmc" :
                            ((db_pin_7_mode == "dq_wdb_mode") ? "pin7_dq_wdb_mode" :
                            ((db_pin_7_mode == "dm_wdb_mode") ? "pin7_dm_wdb_mode" :
                            ((db_pin_7_mode == "dbi_wdb_mode") ? "pin7_dbi_wdb_mode" :
                            ((db_pin_7_mode == "clk_wdb_mode") ? "pin7_clk_wdb_mode" :
                            ((db_pin_7_mode == "clkb_wdb_mode") ? "pin7_clkb_wdb_mode" :
                            ((db_pin_7_mode == "dqs_wdb_mode") ? "pin7_dqs_wdb_mode" :
                            ((db_pin_7_mode == "dqsb_wdb_mode") ? "pin7_dqsb_wdb_mode" :
                            ((db_pin_7_mode == "ac_core") ? "pin7_ac_core" :
                            ((db_pin_7_mode == "dq_mode") ? "pin7_dq_mode" :
                            ((db_pin_7_mode == "dm_mode") ? "pin7_dm_mode" :
                            ((db_pin_7_mode == "dbi_mode") ? "pin7_dbi_mode" :
                            ((db_pin_7_mode == "clk_mode") ? "pin7_clk_mode" :
                            ((db_pin_7_mode == "clkb_mode") ? "pin7_clkb_mode" :
                            ((db_pin_7_mode == "dqs_mode") ? "pin7_dqs_mode" :
                            ((db_pin_7_mode == "dqsb_mode") ? "pin7_dqsb_mode" :
                            ((db_pin_7_mode == "dqs_ddr4_mode") ? "pin7_dqs_ddr4_mode" :
                            ((db_pin_7_mode == "dqsb_ddr4_mode") ? "pin7_dqsb_ddr4_mode" :
                            ((db_pin_7_mode == "rdq_mode") ? "pin7_rdq_mode" :
                            ((db_pin_7_mode == "rdqs_mode") ? "pin7_rdqs_mode" :
                                                                 "pin7_gpio_mode"))))))))))))))))))))))))))); 

localparam l_db_pin_8_mode = (db_pin_8_mode == "ac_ddr4_hmc") ? "pin8_ac_ddr4_hmc" :
                            ((db_pin_8_mode == "dq_wdb_ddr4_mode") ? "pin8_dq_wdb_ddr4_mode" :
                            ((db_pin_8_mode == "dm_wdb_ddr4_mode") ? "pin8_dm_wdb_ddr4_mode" :
                            ((db_pin_8_mode == "dbi_wdb_ddr4_mode") ? "pin8_dbi_wdb_ddr4_mode" :
                            ((db_pin_8_mode == "clk_wdb_ddr4_mode") ? "pin8_clk_wdb_ddr4_mode" :
                            ((db_pin_8_mode == "clkb_wdb_ddr4_mode") ? "pin8_clkb_wdb_ddr4_mode" :
                            ((db_pin_8_mode == "dqs_wdb_ddr4_mode") ? "pin8_dqs_wdb_ddr4_mode" :
                            ((db_pin_8_mode == "dqsb_wdb_ddr4_mode") ? "pin8_dqsb_wdb_ddr4_mode" :
                            ((db_pin_8_mode == "ac_hmc") ? "pin8_ac_hmc" :
                            ((db_pin_8_mode == "dq_wdb_mode") ? "pin8_dq_wdb_mode" :
                            ((db_pin_8_mode == "dm_wdb_mode") ? "pin8_dm_wdb_mode" :
                            ((db_pin_8_mode == "dbi_wdb_mode") ? "pin8_dbi_wdb_mode" :
                            ((db_pin_8_mode == "clk_wdb_mode") ? "pin8_clk_wdb_mode" :
                            ((db_pin_8_mode == "clkb_wdb_mode") ? "pin8_clkb_wdb_mode" :
                            ((db_pin_8_mode == "dqs_wdb_mode") ? "pin8_dqs_wdb_mode" :
                            ((db_pin_8_mode == "dqsb_wdb_mode") ? "pin8_dqsb_wdb_mode" :
                            ((db_pin_8_mode == "ac_core") ? "pin8_ac_core" :
                            ((db_pin_8_mode == "dq_mode") ? "pin8_dq_mode" :
                            ((db_pin_8_mode == "dm_mode") ? "pin8_dm_mode" :
                            ((db_pin_8_mode == "dbi_mode") ? "pin8_dbi_mode" :
                            ((db_pin_8_mode == "clk_mode") ? "pin8_clk_mode" :
                            ((db_pin_8_mode == "clkb_mode") ? "pin8_clkb_mode" :
                            ((db_pin_8_mode == "dqs_mode") ? "pin8_dqs_mode" :
                            ((db_pin_8_mode == "dqsb_mode") ? "pin8_dqsb_mode" :
                            ((db_pin_8_mode == "dqs_ddr4_mode") ? "pin8_dqs_ddr4_mode" :
                            ((db_pin_8_mode == "dqsb_ddr4_mode") ? "pin8_dqsb_ddr4_mode" :
                            ((db_pin_8_mode == "rdq_mode") ? "pin8_rdq_mode" :
                            ((db_pin_8_mode == "rdqs_mode") ? "pin8_rdqs_mode" :
                                                                 "pin8_gpio_mode"))))))))))))))))))))))))))); 

localparam l_db_pin_9_mode = (db_pin_9_mode == "ac_ddr4_hmc") ? "pin9_ac_ddr4_hmc" :
                            ((db_pin_9_mode == "dq_wdb_ddr4_mode") ? "pin9_dq_wdb_ddr4_mode" :
                            ((db_pin_9_mode == "dm_wdb_ddr4_mode") ? "pin9_dm_wdb_ddr4_mode" :
                            ((db_pin_9_mode == "dbi_wdb_ddr4_mode") ? "pin9_dbi_wdb_ddr4_mode" :
                            ((db_pin_9_mode == "clk_wdb_ddr4_mode") ? "pin9_clk_wdb_ddr4_mode" :
                            ((db_pin_9_mode == "clkb_wdb_ddr4_mode") ? "pin9_clkb_wdb_ddr4_mode" :
                            ((db_pin_9_mode == "dqs_wdb_ddr4_mode") ? "pin9_dqs_wdb_ddr4_mode" :
                            ((db_pin_9_mode == "dqsb_wdb_ddr4_mode") ? "pin9_dqsb_wdb_ddr4_mode" :
                            ((db_pin_9_mode == "ac_hmc") ? "pin9_ac_hmc" :
                            ((db_pin_9_mode == "dq_wdb_mode") ? "pin9_dq_wdb_mode" :
                            ((db_pin_9_mode == "dm_wdb_mode") ? "pin9_dm_wdb_mode" :
                            ((db_pin_9_mode == "dbi_wdb_mode") ? "pin9_dbi_wdb_mode" :
                            ((db_pin_9_mode == "clk_wdb_mode") ? "pin9_clk_wdb_mode" :
                            ((db_pin_9_mode == "clkb_wdb_mode") ? "pin9_clkb_wdb_mode" :
                            ((db_pin_9_mode == "dqs_wdb_mode") ? "pin9_dqs_wdb_mode" :
                            ((db_pin_9_mode == "dqsb_wdb_mode") ? "pin9_dqsb_wdb_mode" :
                            ((db_pin_9_mode == "ac_core") ? "pin9_ac_core" :
                            ((db_pin_9_mode == "dq_mode") ? "pin9_dq_mode" :
                            ((db_pin_9_mode == "dm_mode") ? "pin9_dm_mode" :
                            ((db_pin_9_mode == "dbi_mode") ? "pin9_dbi_mode" :
                            ((db_pin_9_mode == "clk_mode") ? "pin9_clk_mode" :
                            ((db_pin_9_mode == "clkb_mode") ? "pin9_clkb_mode" :
                            ((db_pin_9_mode == "dqs_mode") ? "pin9_dqs_mode" :
                            ((db_pin_9_mode == "dqsb_mode") ? "pin9_dqsb_mode" :
                            ((db_pin_9_mode == "dqs_ddr4_mode") ? "pin9_dqs_ddr4_mode" :
                            ((db_pin_9_mode == "dqsb_ddr4_mode") ? "pin9_dqsb_ddr4_mode" :
                            ((db_pin_9_mode == "rdq_mode") ? "pin9_rdq_mode" :
                            ((db_pin_9_mode == "rdqs_mode") ? "pin9_rdqs_mode" :
                                                                 "pin9_gpio_mode"))))))))))))))))))))))))))); 

localparam l_db_pin_10_mode = (db_pin_10_mode == "ac_ddr4_hmc") ? "pin10_ac_ddr4_hmc" :
                             ((db_pin_10_mode == "dq_wdb_ddr4_mode") ? "pin10_dq_wdb_ddr4_mode" :
                             ((db_pin_10_mode == "dm_wdb_ddr4_mode") ? "pin10_dm_wdb_ddr4_mode" :
                             ((db_pin_10_mode == "dbi_wdb_ddr4_mode") ? "pin10_dbi_wdb_ddr4_mode" :
                             ((db_pin_10_mode == "clk_wdb_ddr4_mode") ? "pin10_clk_wdb_ddr4_mode" :
                             ((db_pin_10_mode == "clkb_wdb_ddr4_mode") ? "pin10_clkb_wdb_ddr4_mode" :
                             ((db_pin_10_mode == "dqs_wdb_ddr4_mode") ? "pin10_dqs_wdb_ddr4_mode" :
                             ((db_pin_10_mode == "dqsb_wdb_ddr4_mode") ? "pin10_dqsb_wdb_ddr4_mode" :
                             ((db_pin_10_mode == "ac_hmc") ? "pin10_ac_hmc" :
                             ((db_pin_10_mode == "dq_wdb_mode") ? "pin10_dq_wdb_mode" :
                             ((db_pin_10_mode == "dm_wdb_mode") ? "pin10_dm_wdb_mode" :
                             ((db_pin_10_mode == "dbi_wdb_mode") ? "pin10_dbi_wdb_mode" :
                             ((db_pin_10_mode == "clk_wdb_mode") ? "pin10_clk_wdb_mode" :
                             ((db_pin_10_mode == "clkb_wdb_mode") ? "pin10_clkb_wdb_mode" :
                             ((db_pin_10_mode == "dqs_wdb_mode") ? "pin10_dqs_wdb_mode" :
                             ((db_pin_10_mode == "dqsb_wdb_mode") ? "pin10_dqsb_wdb_mode" :
                             ((db_pin_10_mode == "ac_core") ? "pin10_ac_core" :
                             ((db_pin_10_mode == "dq_mode") ? "pin10_dq_mode" :
                             ((db_pin_10_mode == "dm_mode") ? "pin10_dm_mode" :
                             ((db_pin_10_mode == "dbi_mode") ? "pin10_dbi_mode" :
                             ((db_pin_10_mode == "clk_mode") ? "pin10_clk_mode" :
                             ((db_pin_10_mode == "clkb_mode") ? "pin10_clkb_mode" :
                             ((db_pin_10_mode == "dqs_mode") ? "pin10_dqs_mode" :
                             ((db_pin_10_mode == "dqsb_mode") ? "pin10_dqsb_mode" :
                             ((db_pin_10_mode == "dqs_ddr4_mode") ? "pin10_dqs_ddr4_mode" :
                             ((db_pin_10_mode == "dqsb_ddr4_mode") ? "pin10_dqsb_ddr4_mode" :
                             ((db_pin_10_mode == "rdq_mode") ? "pin10_rdq_mode" :
                             ((db_pin_10_mode == "rdqs_mode") ? "pin10_rdqs_mode" :
                                                                   "pin10_gpio_mode"))))))))))))))))))))))))))); 

localparam l_db_pin_11_mode = (db_pin_11_mode == "ac_ddr4_hmc") ? "pin11_ac_ddr4_hmc" :
                             ((db_pin_11_mode == "dq_wdb_ddr4_mode") ? "pin11_dq_wdb_ddr4_mode" :
                             ((db_pin_11_mode == "dm_wdb_ddr4_mode") ? "pin11_dm_wdb_ddr4_mode" :
                             ((db_pin_11_mode == "dbi_wdb_ddr4_mode") ? "pin11_dbi_wdb_ddr4_mode" :
                             ((db_pin_11_mode == "clk_wdb_ddr4_mode") ? "pin11_clk_wdb_ddr4_mode" :
                             ((db_pin_11_mode == "clkb_wdb_ddr4_mode") ? "pin11_clkb_wdb_ddr4_mode" :
                             ((db_pin_11_mode == "dqs_wdb_ddr4_mode") ? "pin11_dqs_wdb_ddr4_mode" :
                             ((db_pin_11_mode == "dqsb_wdb_ddr4_mode") ? "pin11_dqsb_wdb_ddr4_mode" :
                             ((db_pin_11_mode == "ac_hmc") ? "pin11_ac_hmc" :
                             ((db_pin_11_mode == "dq_wdb_mode") ? "pin11_dq_wdb_mode" :
                             ((db_pin_11_mode == "dm_wdb_mode") ? "pin11_dm_wdb_mode" :
                             ((db_pin_11_mode == "dbi_wdb_mode") ? "pin11_dbi_wdb_mode" :
                             ((db_pin_11_mode == "clk_wdb_mode") ? "pin11_clk_wdb_mode" :
                             ((db_pin_11_mode == "clkb_wdb_mode") ? "pin11_clkb_wdb_mode" :
                             ((db_pin_11_mode == "dqs_wdb_mode") ? "pin11_dqs_wdb_mode" :
                             ((db_pin_11_mode == "dqsb_wdb_mode") ? "pin11_dqsb_wdb_mode" :
                             ((db_pin_11_mode == "ac_core") ? "pin11_ac_core" :
                             ((db_pin_11_mode == "dq_mode") ? "pin11_dq_mode" :
                             ((db_pin_11_mode == "dm_mode") ? "pin11_dm_mode" :
                             ((db_pin_11_mode == "dbi_mode") ? "pin11_dbi_mode" :
                             ((db_pin_11_mode == "clk_mode") ? "pin11_clk_mode" :
                             ((db_pin_11_mode == "clkb_mode") ? "pin11_clkb_mode" :
                             ((db_pin_11_mode == "dqs_mode") ? "pin11_dqs_mode" :
                             ((db_pin_11_mode == "dqsb_mode") ? "pin11_dqsb_mode" :
                             ((db_pin_11_mode == "dqs_ddr4_mode") ? "pin11_dqs_ddr4_mode" :
                             ((db_pin_11_mode == "dqsb_ddr4_mode") ? "pin11_dqsb_ddr4_mode" :
                             ((db_pin_11_mode == "rdq_mode") ? "pin11_rdq_mode" :
                             ((db_pin_11_mode == "rdqs_mode") ? "pin11_rdqs_mode" :
                                                                   "pin11_gpio_mode"))))))))))))))))))))))))))); 

   fourteennm_io_12_lane #(
// synthesis translate_off
      .fast_interpolator_sim         (fast_interpolator_sim),
// synthesis translate_on
      .pipe_latency                  (pipe_latency),
      .pin_0_output_phase            (pin_0_output_phase),
      .pin_1_output_phase            (pin_1_output_phase),
      .pin_2_output_phase            (pin_2_output_phase),
      .pin_3_output_phase            (pin_3_output_phase),
      .pin_4_output_phase            (pin_4_output_phase),
      .pin_5_output_phase            (pin_5_output_phase),
      .pin_6_output_phase            (pin_6_output_phase),
      .pin_7_output_phase            (pin_7_output_phase),
      .pin_8_output_phase            (pin_8_output_phase),
      .pin_9_output_phase            (pin_9_output_phase),
      .pin_10_output_phase           (pin_10_output_phase),
      .pin_11_output_phase           (pin_11_output_phase),
      .dqs_lgc_phase_shift_b         (dqs_lgc_phase_shift_b),
      .dqs_lgc_phase_shift_a         (dqs_lgc_phase_shift_a),
      .oct_size                      (oct_size),
      .rd_valid_delay                (rd_valid_delay),
      .dqs_enable_delay              (dqs_enable_delay),
      .avl_base_addr                 (avl_base_addr),
      .a_filter_code                 (a_filter_code),
      .a_couple_enable               (a_couple_enable),
      .mode_rate_in                  (mode_rate_in),
      .mode_rate_out                 (l_mode_rate_out),
      .phy_clk_sel                   (l_phy_clk_sel),
      .pair_0_ddr4_mode              (l_pair_0_ddr4_mode),
      .pair_1_ddr4_mode              (l_pair_1_ddr4_mode),
      .pair_2_ddr4_mode              (l_pair_2_ddr4_mode),
      .pair_3_ddr4_mode              (l_pair_3_ddr4_mode),
      .pair_4_ddr4_mode              (l_pair_4_ddr4_mode),
      .pair_5_ddr4_mode              (l_pair_5_ddr4_mode),
      .pin_0_initial_out             (l_pin_0_initial_out),
      .pin_0_oct_mode                (l_pin_0_oct_mode),
      .pin_0_mode_ddr                (l_pin_0_mode_ddr),
      .pin_0_dqs_mode                (l_pin_0_dqs_mode),
      .pin_0_data_in_mode            (l_pin_0_data_in_mode),
      .pin_1_initial_out             (l_pin_1_initial_out),
      .pin_1_oct_mode                (l_pin_1_oct_mode),
      .pin_1_mode_ddr                (l_pin_1_mode_ddr),
      .pin_1_dqs_mode                (l_pin_1_dqs_mode),
      .pin_1_data_in_mode            (l_pin_1_data_in_mode),
      .pin_2_initial_out             (l_pin_2_initial_out),
      .pin_2_oct_mode                (l_pin_2_oct_mode),
      .pin_2_mode_ddr                (l_pin_2_mode_ddr),
      .pin_2_dqs_mode                (l_pin_2_dqs_mode),
      .pin_2_data_in_mode            (l_pin_2_data_in_mode),
      .pin_3_initial_out             (l_pin_3_initial_out),
      .pin_3_oct_mode                (l_pin_3_oct_mode),
      .pin_3_mode_ddr                (l_pin_3_mode_ddr),
      .pin_3_dqs_mode                (l_pin_3_dqs_mode),
      .pin_3_data_in_mode            (l_pin_3_data_in_mode),
      .pin_4_initial_out             (l_pin_4_initial_out),
      .pin_4_oct_mode                (l_pin_4_oct_mode),
      .pin_4_mode_ddr                (l_pin_4_mode_ddr),
      .pin_4_dqs_mode                (l_pin_4_dqs_mode),
      .pin_4_data_in_mode            (l_pin_4_data_in_mode),
      .pin_5_initial_out             (l_pin_5_initial_out),
      .pin_5_oct_mode                (l_pin_5_oct_mode),
      .pin_5_mode_ddr                (l_pin_5_mode_ddr),
      .pin_5_dqs_mode                (l_pin_5_dqs_mode),
      .pin_5_data_in_mode            (l_pin_5_data_in_mode),
      .pin_6_initial_out             (l_pin_6_initial_out),
      .pin_6_oct_mode                (l_pin_6_oct_mode),
      .pin_6_mode_ddr                (l_pin_6_mode_ddr),
      .pin_6_dqs_mode                (l_pin_6_dqs_mode),
      .pin_6_data_in_mode            (l_pin_6_data_in_mode),
      .pin_7_initial_out             (l_pin_7_initial_out),
      .pin_7_oct_mode                (l_pin_7_oct_mode),
      .pin_7_mode_ddr                (l_pin_7_mode_ddr),
      .pin_7_dqs_mode                (l_pin_7_dqs_mode),
      .pin_7_data_in_mode            (l_pin_7_data_in_mode),
      .pin_8_initial_out             (l_pin_8_initial_out),
      .pin_8_oct_mode                (l_pin_8_oct_mode),
      .pin_8_mode_ddr                (l_pin_8_mode_ddr),
      .pin_8_dqs_mode                (l_pin_8_dqs_mode),
      .pin_8_data_in_mode            (l_pin_8_data_in_mode),
      .pin_9_initial_out             (l_pin_9_initial_out),
      .pin_9_oct_mode                (l_pin_9_oct_mode),
      .pin_9_mode_ddr                (l_pin_9_mode_ddr),
      .pin_9_dqs_mode                (l_pin_9_dqs_mode),
      .pin_9_data_in_mode            (l_pin_9_data_in_mode),
      .pin_10_initial_out            (l_pin_10_initial_out),
      .pin_10_oct_mode               (l_pin_10_oct_mode),
      .pin_10_mode_ddr               (l_pin_10_mode_ddr),
      .pin_10_dqs_mode               (l_pin_10_dqs_mode),
      .pin_10_data_in_mode           (l_pin_10_data_in_mode),
      .pin_11_initial_out            (l_pin_11_initial_out),
      .pin_11_oct_mode               (l_pin_11_oct_mode),
      .pin_11_mode_ddr               (l_pin_11_mode_ddr),
      .pin_11_dqs_mode               (l_pin_11_dqs_mode),
      .pin_11_data_in_mode           (l_pin_11_data_in_mode),
      .db_hmc_or_core                (db_hmc_or_core),
      .db_dbi_sel                    (db_dbi_sel),
      .db_dbi_wr_en                  (db_dbi_wr_en),
      .db_dbi_rd_en                  (db_dbi_rd_en),
      .avl_ena                       (avl_ena),
      .db_boardcast_en               (db_boardcast_en),
      .db_pipeline                   (db_pipeline),
      .db_rwlat_mode                 (db_rwlat_mode),
      .db_ptr_pipeline_depth         (db_ptr_pipeline_depth),
      .db_preamble_mode              (db_preamble_mode),
      .db_reset_auto_release         (db_reset_auto_release),
      .db_data_alignment_mode        (db_data_alignment_mode),
      .db_db2core_registered         (db_db2core_registered),
      .dbc_core_clk_sel              (dbc_core_clk_sel),
      .db_core_or_hmc2db_registered  (db_core_or_hmc2db_registered),
      .db_seq_rd_en_full_pipeline    (db_seq_rd_en_full_pipeline),
      .db_pin_0_mode                 (l_db_pin_0_mode),
      .db_pin_1_mode                 (l_db_pin_1_mode),
      .db_pin_2_mode                 (l_db_pin_2_mode),
      .db_pin_3_mode                 (l_db_pin_3_mode),
      .db_pin_4_mode                 (l_db_pin_4_mode),
      .db_pin_5_mode                 (l_db_pin_5_mode),
      .db_pin_6_mode                 (l_db_pin_6_mode),
      .db_pin_7_mode                 (l_db_pin_7_mode),
      .db_pin_8_mode                 (l_db_pin_8_mode),
      .db_pin_9_mode                 (l_db_pin_9_mode),
      .db_pin_10_mode                (l_db_pin_10_mode),
      .db_pin_11_mode                (l_db_pin_11_mode),
      .dll_rst_en                    (dll_rst_en),
      .dll_en                        (dll_en),
      .dll_core_updnen               (dll_core_updnen),
      .dll_ctlsel                    (dll_ctlsel),
      .db_afi_wlat_vlu               (db_afi_wlat_vlu),
      .db_afi_rlat_vlu               (db_afi_rlat_vlu),
      .dbc_wb_reserved_entry         (dbc_wb_reserved_entry),
      .dll_ctl_static                (dll_ctl_static),
      .dqs_lgc_pvt_input_delay_a     (dqs_lgc_pvt_input_delay_a),
      .dqs_lgc_pvt_input_delay_b     (dqs_lgc_pvt_input_delay_b),
      .dqs_lgc_count_threshold       (dqs_lgc_count_threshold),
      .pingpong_primary              (pingpong_primary),
      .pingpong_secondary            (pingpong_secondary),
      .hps_ctrl_en                   (hps_ctrl_en),
      .dqs_lgc_enable_toggler        (dqs_lgc_enable_toggler),
      .dqs_lgc_dqs_b_interp_en       (dqs_lgc_dqs_b_interp_en),
      .dqs_lgc_dqs_a_interp_en       (dqs_lgc_dqs_a_interp_en),
      .dqs_lgc_pack_mode             (dqs_lgc_pack_mode),
      .dqs_lgc_pst_preamble_mode     (dqs_lgc_pst_preamble_mode),
      .dqs_lgc_pst_en_shrink         (dqs_lgc_pst_en_shrink),
      .vfifo_burst_length            (vfifo_burst_length),
      .dqs_lgc_broadcast_enable      (dqs_lgc_broadcast_enable),
      .dqs_lgc_burst_length          (dqs_lgc_burst_length),
      .dqs_lgc_ddr4_search           (dqs_lgc_ddr4_search)
   ) lane_inst (
      .phy_clk                       (phy_clk),
      .phy_clk_phs                   (phy_clk_phs),
      .reset_n                       (reset_n),
      .pll_locked                    (pll_locked),
      .dll_ref_clk                   (dll_ref_clk),
      .ioereg_locked                 (ioereg_locked),

      .oe_from_core                  (oe_from_core),
      .data_from_core                (data_from_core),
      .data_to_core                  (data_to_core),
      .mrnk_read_core                (mrnk_read_core),
      .mrnk_write_core               (mrnk_write_core),
      .rdata_en_full_core            (rdata_en_full_core),
      .rdata_valid_core              (rdata_valid_core),

      .core2dbc_rd_data_rdy          (core2dbc_rd_data_rdy),
      .core2dbc_wr_data_vld0         (core2dbc_wr_data_vld0),
      .core2dbc_wr_data_vld1         (core2dbc_wr_data_vld1),
      .core2dbc_wr_ecc_info          (core2dbc_wr_ecc_info),
      .dbc2core_rd_data_vld0         (dbc2core_rd_data_vld0),
      .dbc2core_rd_data_vld1         (dbc2core_rd_data_vld1),
      .dbc2core_rd_type              (dbc2core_rd_type),
      .dbc2core_wb_pointer           (dbc2core_wb_pointer),
      .dbc2core_wr_data_rdy          (dbc2core_wr_data_rdy),

      .ac_hmc                        (ac_hmc),
      .afi_rlat_core                 (afi_rlat_core),
      .afi_wlat_core                 (afi_wlat_core),
      .cfg_dbc                       (cfg_dbc),
      .ctl2dbc0                      (ctl2dbc0),
      .ctl2dbc1                      (ctl2dbc1),
      .dbc2ctl                       (dbc2ctl),

      .cal_avl_in                    (cal_avl_in),
      .cal_avl_readdata_out          (cal_avl_readdata_out),
      .cal_avl_out                   (cal_avl_out),
      .cal_avl_readdata_in           (cal_avl_readdata_in),

      .dqs_in                        (dqs_in),
      .broadcast_in_bot              (broadcast_in_bot),
      .broadcast_in_top              (broadcast_in_top),
      .broadcast_out_bot             (broadcast_out_bot),
      .broadcast_out_top             (broadcast_out_top),

      .data_in                       (data_in),
      .data_out                      (data_out),
      .data_oe                       (data_oe),
      .oct_enable                    (oct_enable),

      .core_dll                      (core_dll),
      .dll_core                      (dll_core),

      .sync_clk_bot_in               (sync_clk_bot_in),
      .sync_clk_bot_out              (sync_clk_bot_out),
      .sync_clk_top_in               (sync_clk_top_in),
      .sync_clk_top_out              (sync_clk_top_out),
      .sync_data_bot_in              (sync_data_bot_in),
      .sync_data_bot_out             (sync_data_bot_out),
      .sync_data_top_in              (sync_data_top_in),
      .sync_data_top_out             (sync_data_top_out),

      .emif_phy_out_a                (emif_phy_out_a),
      .emif_phy_out_b                (emif_phy_out_b),

      .dft_phy_clk                   (dft_phy_clk)
   );
endmodule
