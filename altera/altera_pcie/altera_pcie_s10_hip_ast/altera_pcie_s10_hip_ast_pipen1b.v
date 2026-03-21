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


// (C) 2001-2016 Altera Corporation. All rights reserved.
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


// synthesis translate_off
`timescale 1ns / 1ps
`define ALTERA_RTL_MODE
`define ALTERA_SIMPLE_MEM
`define SIM_ONLY_ACDS
// synthesis translate_on

// turn off superfluous verilog processor warnings
// altera message_level Level1

module altera_pcie_s10_hip_ast_pipen1b # (
      parameter            adp_bypass                                                                                           =    "false"                                  ,
      parameter            aux_cfg_vf_en                                                                                        =    "true"                                   ,
      parameter            aux_warm_reset_ctl                                                                                   =    "true"                                   ,
      parameter            cfg_blk_crs_en                                                                                       =    "false"                                  ,
      parameter  [8:0]     cfg_dbi_pf0_table_size                                                                               =    9'b100000110                             ,
      parameter  [8:0]     cfg_dbi_pf1_start_addr                                                                               =    9'b101000000                             ,
      parameter  [8:0]     cfg_dbi_pf1_tablesize                                                                                =    9'b010101100                             ,
      parameter  [17:0]    cfg_g3_pset_coeff_0                                                                                  =    18'b010000101111000000                   ,
      parameter  [17:0]    cfg_g3_pset_coeff_1                                                                                  =    18'b001011110100000000                   ,
      parameter  [17:0]    cfg_g3_pset_coeff_10                                                                                 =    18'b010111101000000000                   ,
      parameter  [17:0]    cfg_g3_pset_coeff_2                                                                                  =    18'b001101110010000000                   ,
      parameter  [17:0]    cfg_g3_pset_coeff_3                                                                                  =    18'b001000110111000000                   ,
      parameter  [17:0]    cfg_g3_pset_coeff_4                                                                                  =    18'b000000111111000000                   ,
      parameter  [17:0]    cfg_g3_pset_coeff_5                                                                                  =    18'b000000111000000111                   ,
      parameter  [17:0]    cfg_g3_pset_coeff_6                                                                                  =    18'b000000110111001000                   ,
      parameter  [17:0]    cfg_g3_pset_coeff_7                                                                                  =    18'b001101101011000111                   ,
      parameter  [17:0]    cfg_g3_pset_coeff_8                                                                                  =    18'b001000101111001000                   ,
      parameter  [17:0]    cfg_g3_pset_coeff_9                                                                                  =    18'b000000110100001011                   ,
      parameter  [7:0]     cfg_vf_num_pf0                                                                                       =    8'b01000000                              ,
      parameter  [7:0]     cfg_vf_num_pf1                                                                                       =    8'b01000000                              ,
      parameter  [4:0]     cfg_vf_table_size                                                                                    =    5'b01010                                 ,
      parameter            clkmod_gen3_hclk_div_sel                                                                             =    "hclk_div1"                              ,
      parameter            clkmod_gen3_hclk_source_sel                                                                          =    "hclk_1"                                 ,
      parameter            clkmod_hip_clk_dis                                                                                   =    "false"                                  ,
      parameter            clkmod_pclk_sel                                                                                      =    "pclk_ch7"                               ,
      parameter            clkmod_pld_clk_out_sel                                                                               =    "div1"                                   ,
      parameter            clkmod_pld_clk_out_sel_2x                                                                            =    "aib2x_div1"                             ,
      parameter            clock_ctl_rsvd_3                                                                                     =    "false"                                  ,
      parameter            clock_ctl_rsvd_5                                                                                     =    "false"                                  ,
      parameter            clrhip_not_rst_sticky                                                                                =    "false"                                  ,
      parameter            crs_override                                                                                         =    "false"                                  ,
      parameter            crs_override_value                                                                                   =    "true"                                   ,
      parameter            cvp_blocking_dis                                                                                     =    "false"                                  ,
      parameter            cvp_clk_sel                                                                                          =    "false"                                  ,
      parameter            cvp_data_compressed                                                                                  =    "false"                                  ,
      parameter            cvp_data_encrypted                                                                                   =    "false"                                  ,
      parameter            cvp_extra                                                                                            =    "false"                                  ,
      parameter            cvp_hard_reset_bypass                                                                                =    "false"                                  ,
      parameter            cvp_hip_clk_sel_default                                                                              =    "false"                                  ,
      parameter  [2:0]     cvp_intf_reset_ctl                                                                                   =    3'b010                                   ,
      parameter            cvp_irq_en                                                                                           =    "false"                                  ,
      parameter  [31:0]    cvp_jtag0                                                                                            =    32'b00000000000000000000000000000000     ,
      parameter  [31:0]    cvp_jtag1                                                                                            =    32'b00000000000000000000000000000000     ,
      parameter  [31:0]    cvp_jtag2                                                                                            =    32'b00000000000000000000000000000000     ,
      parameter  [31:0]    cvp_jtag3                                                                                            =    32'b00000000000000000000000000000000     ,
      parameter            cvp_mode_default                                                                                     =    "false"                                  ,
      parameter            cvp_mode_gating_dis                                                                                  =    "false"                                  ,
      parameter            cvp_rate_sel                                                                                         =    "false"                                  ,
      parameter  [15:0]    cvp_user_id                                                                                          =    16'b0000000000000000                     ,
      parameter  [15:0]    cvp_vsec_id                                                                                          =    16'b0001000101110010                     ,
      parameter  [3:0]     cvp_vsec_rev                                                                                         =    4'b0000                                  ,
      parameter            cvp_warm_rst_ready_force_bit0                                                                        =    "false"                                  ,
      parameter            cvp_warm_rst_ready_force_bit1                                                                        =    "true"                                   ,
      parameter            cvp_warm_rst_req_ena                                                                                 =    "disable"                                ,
      parameter  [2:0]     cvp_write_mask_ctl                                                                                   =    3'b011                                   ,
      parameter            device_type                                                                                          =    "dev_nep"                                ,
      parameter            ecc_chk_val                                                                                          =    "true"                                   ,
      parameter            ecc_gen_val                                                                                          =    "false"                                  ,
      parameter  [11:0]    eco_flops                                                                                            =    12'b000000000000                         ,
      parameter            eqctrl_adp_ctle                                                                                      =    "false"                                  ,
      parameter            eqctrl_ctle_val                                                                                      =    "ctle_val_0"                             ,
      parameter            eqctrl_dir_mode_en                                                                                   =    "false"                                  ,
      parameter            eqctrl_fom_mode_en                                                                                   =    "false"                                  ,
      parameter            eqctrl_legacy_mode_en                                                                                =    "false"                                  ,
      parameter  [3:0]     eqctrl_num_fom_cycles                                                                                =    4'b0000                                  ,
      parameter            eqctrl_use_dsp_rxpreset                                                                              =    "false"                                  ,
      parameter            func_mode                                                                                            =    "disable"                                ,
      parameter  [7:0]     gpio_irq                                                                                             =    8'b00000000                              ,
      parameter  [15:0]    hip_pcs_chnl_en                                                                                      =    16'b1111111111111111                     ,
      parameter            hrc_chnl_cal_done_active                                                                             =    "chnl_cal_done_0_to_15"                  ,
      parameter  [15:0]    hrc_chnl_en                                                                                          =    16'b1111111111111111                     ,
      parameter  [15:0]    hrc_chnl_txpll_master_cgb_rst_en                                                                     =    16'b0000000010000000                     ,
      parameter  [15:0]    hrc_chnl_txpll_rst_en                                                                                =    16'b0000000110000000                     ,
      parameter            hrc_en_pcs_fifo_err                                                                                  =    "false"                                  ,
      parameter            hrc_force_inactive_rst                                                                               =    "false"                                  ,
      parameter            hrc_fref_clk_active                                                                                  =    "fref_clk_sel_0"                         ,
      parameter            hrc_mask_tx_pll_lock_active                                                                          =    "mask_tx_pll_lock_34"                    ,
      parameter            hrc_pll_cal_done_active                                                                              =    "pll_cal_done_34"                        ,
      parameter            hrc_pll_perst_en                                                                                     =    "disable"                                ,
      parameter            hrc_pma_perst_en                                                                                     =    "level"                                  ,
      parameter  [19:0]    hrc_rstctl_1ms                                                                                       =    20'b00000000000000000000                 ,
      parameter  [19:0]    hrc_rstctl_1us                                                                                       =    20'b00000000000000000000                 ,
      parameter            hrc_rstctl_timer_type_a                                                                              =    "fref_cyc_a"                             ,
      parameter            hrc_rstctl_timer_type_f                                                                              =    "fref_cyc_f"                             ,
      parameter            hrc_rstctl_timer_type_g                                                                              =    "fref_cyc_g"                             ,
      parameter            hrc_rstctl_timer_type_h                                                                              =    "fref_cyc_h"                             ,
      parameter            hrc_rstctl_timer_type_i                                                                              =    "micro_sec_i"                            ,
      parameter            hrc_rstctl_timer_type_j                                                                              =    "fref_cyc_j"                             ,
      parameter  [7:0]     hrc_rstctl_timer_value_a                                                                             =    8'b00001010                              ,
      parameter  [7:0]     hrc_rstctl_timer_value_f                                                                             =    8'b00001010                              ,
      parameter  [7:0]     hrc_rstctl_timer_value_g                                                                             =    8'b00001010                              ,
      parameter  [7:0]     hrc_rstctl_timer_value_h                                                                             =    8'b00000100                              ,
      parameter  [7:0]     hrc_rstctl_timer_value_i                                                                             =    8'b00010100                              ,
      parameter  [7:0]     hrc_rstctl_timer_value_j                                                                             =    8'b00010100                              ,
      parameter            hrc_rx_pcs_rst_n_active                                                                              =    "rx_pcs_rst_0_to_15"                     ,
      parameter            hrc_rx_pll_lock_active                                                                               =    "rx_pll_lock_0_to_15"                    ,
      parameter            hrc_rx_pma_rstb_active                                                                               =    "rx_pma_rstb_0_to_15"                    ,
      parameter            hrc_soft_rstctrl_clr                                                                                 =    "false"                                  ,
      parameter            hrc_soft_rstctrl_en                                                                                  =    "disable"                                ,
      parameter            hrc_tx_lc_pll_rstb_active                                                                            =    "tx_lc_pll_rstb_78"                      ,
      parameter            hrc_tx_lcff_pll_lock_active                                                                          =    "tx_lcff_pll_lock_78"                    ,
      parameter            hrc_tx_pcs_rst_n_active                                                                              =    "tx_pcs_rst_0_to_15"                     ,
      parameter  [5:0]     irq_misc_ctrl                                                                                        =    6'b000000                                ,
      parameter  [5:0]     k_phy_misc_ctrl_rsvd_0_5                                                                             =    6'b000000                                ,
      parameter  [2:0]     k_phy_misc_ctrl_rsvd_13_15                                                                           =    3'b000                                   ,
      parameter  [7:0]     pf0_ack_n_fts                                                                                        =    8'b11111111                              ,
      parameter  [4:0]     pf0_adv_err_int_msg_num                                                                              =    5'b00000                                 ,
      parameter  [23:0]    pf0_aer_cap_aer_ext_cap_hdr_off_addr_byte2                                                           =    24'b000000000000000100000010             ,
      parameter  [23:0]    pf0_aer_cap_aer_ext_cap_hdr_off_addr_byte3                                                           =    24'b000000000000000100000011             ,
      parameter  [23:0]    pf0_aer_cap_root_err_status_off_addr_byte0                                                           =    24'b000000000000000100110000             ,
      parameter  [3:0]     pf0_aer_cap_version                                                                                  =    4'b0010                                  ,
      parameter  [11:0]    pf0_aer_next_offset                                                                                  =    12'b000101001000                         ,
      parameter  [23:0]    pf0_ari_cap_ari_base_addr_byte2                                                                      =    24'b000000000000000101111010             ,
      parameter  [23:0]    pf0_ari_cap_ari_base_addr_byte3                                                                      =    24'b000000000000000101111011             ,
      parameter  [3:0]     pf0_ari_cap_version                                                                                  =    4'b0001                                  ,
      parameter  [11:0]    pf0_ari_next_offset                                                                                  =    12'b000110011000                         ,
      parameter  [23:0]    pf0_ats_cap_ats_cap_hdr_reg_addr_byte2                                                               =    24'b000000000000001010000110             ,
      parameter  [23:0]    pf0_ats_cap_ats_cap_hdr_reg_addr_byte3                                                               =    24'b000000000000001010000111             ,
      parameter  [23:0]    pf0_ats_cap_ats_capabilities_ctrl_reg_addr_byte0                                                     =    24'b000000000000001010001000             ,
      parameter  [3:0]     pf0_ats_cap_version                                                                                  =    4'b0001                                  ,
      parameter            pf0_ats_capabilities_ctrl_reg_rsvdp_7                                                                =    "false"                                  ,
      parameter  [11:0]    pf0_ats_next_offset                                                                                  =    12'b000000000000                         ,
      parameter            pf0_auto_lane_flip_ctrl_en                                                                           =    "enable"                                 ,
      parameter  [9:0]     pf0_aux_clk_freq                                                                                     =    10'b0000001010                           ,
      parameter  [5:0]     pf0_aux_clk_freq_off_rsvdp_10                                                                        =    6'b000000                                ,
      parameter  [2:0]     pf0_aux_curr                                                                                         =    3'b111                                   ,
      parameter            pf0_bar0_mem_io                                                                                      =    "pf0_bar0_mem"                           ,
      parameter            pf0_bar0_prefetch                                                                                    =    "false"                                  ,
      parameter  [3:0]     pf0_bar0_start                                                                                       =    4'b0000                                  ,
      parameter            pf0_bar0_type                                                                                        =    "pf0_bar0_mem32"                         ,
      parameter            pf0_bar1_mem_io                                                                                      =    "pf0_bar1_mem"                           ,
      parameter            pf0_bar1_prefetch                                                                                    =    "false"                                  ,
      parameter  [3:0]     pf0_bar1_start                                                                                       =    4'b0000                                  ,
      parameter            pf0_bar1_type                                                                                        =    "pf0_bar1_mem32"                         ,
      parameter            pf0_bar2_mem_io                                                                                      =    "pf0_bar2_mem"                           ,
      parameter            pf0_bar2_prefetch                                                                                    =    "false"                                  ,
      parameter  [3:0]     pf0_bar2_start                                                                                       =    4'b0000                                  ,
      parameter            pf0_bar2_type                                                                                        =    "pf0_bar2_mem32"                         ,
      parameter            pf0_bar3_mem_io                                                                                      =    "pf0_bar3_mem"                           ,
      parameter            pf0_bar3_prefetch                                                                                    =    "false"                                  ,
      parameter  [3:0]     pf0_bar3_start                                                                                       =    4'b0000                                  ,
      parameter            pf0_bar3_type                                                                                        =    "pf0_bar3_mem32"                         ,
      parameter            pf0_bar4_mem_io                                                                                      =    "pf0_bar4_mem"                           ,
      parameter            pf0_bar4_prefetch                                                                                    =    "false"                                  ,
      parameter  [3:0]     pf0_bar4_start                                                                                       =    4'b0000                                  ,
      parameter            pf0_bar4_type                                                                                        =    "pf0_bar4_mem32"                         ,
      parameter            pf0_bar5_mem_io                                                                                      =    "pf0_bar5_mem"                           ,
      parameter            pf0_bar5_prefetch                                                                                    =    "false"                                  ,
      parameter  [3:0]     pf0_bar5_start                                                                                       =    4'b0000                                  ,
      parameter            pf0_bar5_type                                                                                        =    "pf0_bar5_mem32"                         ,
      parameter  [7:0]     pf0_base_class_code                                                                                  =    8'b00000000                              ,
      parameter            pf0_cap_id_nxt_ptr_reg_rsvdp_20                                                                      =    "false"                                  ,
      parameter  [7:0]     pf0_cap_pointer                                                                                      =    8'b01000000                              ,
      parameter  [31:0]    pf0_cardbus_cis_pointer                                                                              =    32'b00000000000000000000000000000000     ,
      parameter  [7:0]     pf0_common_clk_n_fts                                                                                 =    8'b11111111                              ,
      parameter            pf0_con_status_reg_rsvdp_2                                                                           =    "false"                                  ,
      parameter  [3:0]     pf0_con_status_reg_rsvdp_4                                                                           =    4'b0000                                  ,
      parameter            pf0_config_phy_tx_change                                                                             =    "pf0_full_swing"                         ,
      parameter            pf0_config_tx_comp_rx                                                                                =    "false"                                  ,
      parameter            pf0_cross_link_active                                                                                =    "false"                                  ,
      parameter            pf0_cross_link_en                                                                                    =    "false"                                  ,
      parameter            pf0_d1_support                                                                                       =    "pf0_d1_not_supported"                   ,
      parameter            pf0_d2_support                                                                                       =    "pf0_d2_not_supported"                   ,
      parameter  [7:0]     pf0_dbi_reserved_0                                                                                   =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_1                                                                                   =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_10                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_11                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_12                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_13                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_14                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_15                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_16                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_17                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_18                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_19                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_2                                                                                   =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_20                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_21                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_22                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_23                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_24                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_25                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_26                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_27                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_28                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_29                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_3                                                                                   =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_30                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_31                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_32                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_33                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_34                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_35                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_36                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_37                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_38                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_39                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_4                                                                                   =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_40                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_41                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_42                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_43                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_44                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_45                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_46                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_47                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_48                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_49                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_5                                                                                   =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_50                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_51                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_52                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_53                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_54                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_55                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_56                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_57                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_6                                                                                   =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_7                                                                                   =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_8                                                                                   =    8'b00000000                              ,
      parameter  [7:0]     pf0_dbi_reserved_9                                                                                   =    8'b00000000                              ,
      parameter            pf0_dbi_ro_wr_en                                                                                     =    "enable"                                 ,
      parameter  [2:0]     pf0_device_capabilities_reg_rsvdp_12                                                                 =    3'b000                                   ,
      parameter  [3:0]     pf0_device_capabilities_reg_rsvdp_16                                                                 =    4'b0000                                  ,
      parameter  [2:0]     pf0_device_capabilities_reg_rsvdp_29                                                                 =    3'b000                                   ,
      parameter            pf0_direct_speed_change                                                                              =    "pf0_auto_speed_chg"                     ,
      parameter            pf0_disable_fc_wd_timer                                                                              =    "enable"                                 ,
      parameter            pf0_disable_scrambler_gen_3                                                                          =    "enable"                                 ,
      parameter            pf0_dll_link_en                                                                                      =    "enable"                                 ,
      parameter            pf0_dsi                                                                                              =    "pf0_not_required"                       ,
      parameter  [2:0]     pf0_dsp_rx_preset_hint0                                                                              =    3'b111                                   ,
      parameter  [2:0]     pf0_dsp_rx_preset_hint1                                                                              =    3'b111                                   ,
      parameter  [2:0]     pf0_dsp_rx_preset_hint10                                                                             =    3'b111                                   ,
      parameter  [2:0]     pf0_dsp_rx_preset_hint11                                                                             =    3'b111                                   ,
      parameter  [2:0]     pf0_dsp_rx_preset_hint12                                                                             =    3'b111                                   ,
      parameter  [2:0]     pf0_dsp_rx_preset_hint13                                                                             =    3'b111                                   ,
      parameter  [2:0]     pf0_dsp_rx_preset_hint14                                                                             =    3'b111                                   ,
      parameter  [2:0]     pf0_dsp_rx_preset_hint15                                                                             =    3'b111                                   ,
      parameter  [2:0]     pf0_dsp_rx_preset_hint2                                                                              =    3'b111                                   ,
      parameter  [2:0]     pf0_dsp_rx_preset_hint3                                                                              =    3'b111                                   ,
      parameter  [2:0]     pf0_dsp_rx_preset_hint4                                                                              =    3'b111                                   ,
      parameter  [2:0]     pf0_dsp_rx_preset_hint5                                                                              =    3'b111                                   ,
      parameter  [2:0]     pf0_dsp_rx_preset_hint6                                                                              =    3'b111                                   ,
      parameter  [2:0]     pf0_dsp_rx_preset_hint7                                                                              =    3'b111                                   ,
      parameter  [2:0]     pf0_dsp_rx_preset_hint8                                                                              =    3'b111                                   ,
      parameter  [2:0]     pf0_dsp_rx_preset_hint9                                                                              =    3'b111                                   ,
      parameter  [3:0]     pf0_dsp_tx_preset0                                                                                   =    4'b1111                                  ,
      parameter  [3:0]     pf0_dsp_tx_preset1                                                                                   =    4'b1111                                  ,
      parameter  [3:0]     pf0_dsp_tx_preset10                                                                                  =    4'b1111                                  ,
      parameter  [3:0]     pf0_dsp_tx_preset11                                                                                  =    4'b1111                                  ,
      parameter  [3:0]     pf0_dsp_tx_preset12                                                                                  =    4'b1111                                  ,
      parameter  [3:0]     pf0_dsp_tx_preset13                                                                                  =    4'b1111                                  ,
      parameter  [3:0]     pf0_dsp_tx_preset14                                                                                  =    4'b1111                                  ,
      parameter  [3:0]     pf0_dsp_tx_preset15                                                                                  =    4'b1111                                  ,
      parameter  [3:0]     pf0_dsp_tx_preset2                                                                                   =    4'b1111                                  ,
      parameter  [3:0]     pf0_dsp_tx_preset3                                                                                   =    4'b1111                                  ,
      parameter  [3:0]     pf0_dsp_tx_preset4                                                                                   =    4'b1111                                  ,
      parameter  [3:0]     pf0_dsp_tx_preset5                                                                                   =    4'b1111                                  ,
      parameter  [3:0]     pf0_dsp_tx_preset6                                                                                   =    4'b1111                                  ,
      parameter  [3:0]     pf0_dsp_tx_preset7                                                                                   =    4'b1111                                  ,
      parameter  [3:0]     pf0_dsp_tx_preset8                                                                                   =    4'b1111                                  ,
      parameter  [3:0]     pf0_dsp_tx_preset9                                                                                   =    4'b1111                                  ,
      parameter  [3:0]     pf0_eidle_timer                                                                                      =    4'b0000                                  ,
      parameter            pf0_eq_eieos_cnt                                                                                     =    "enable"                                 ,
      parameter            pf0_eq_phase_2_3                                                                                     =    "enable"                                 ,
      parameter            pf0_eq_redo                                                                                          =    "enable"                                 ,
      parameter  [9:0]     pf0_exp_rom_bar_mask_reg_rsvdp_1                                                                     =    10'b0000000000                           ,
      parameter  [6:0]     pf0_exp_rom_base_addr_reg_rsvdp_1                                                                    =    7'b0000000                               ,
      parameter            pf0_fast_link_mode                                                                                   =    "false"                                  ,
      parameter  [7:0]     pf0_fast_training_seq                                                                                =    8'b11111111                              ,
      parameter            pf0_forward_user_vsec                                                                                =    "false"                                  ,
      parameter            pf0_gen1_ei_inference                                                                                =    "pf0_use_rx_eidle"                       ,
      parameter  [1:0]     pf0_gen2_ctrl_off_rsvdp_22                                                                           =    2'b00                                    ,
      parameter            pf0_gen3_dc_balance_disable                                                                          =    "enable"                                 ,
      parameter            pf0_gen3_dllp_xmt_delay_disable                                                                      =    "enable"                                 ,
      parameter  [5:0]     pf0_gen3_eq_control_off_rsvdp_26                                                                     =    6'b000000                                ,
      parameter  [1:0]     pf0_gen3_eq_control_off_rsvdp_6                                                                      =    2'b00                                    ,
      parameter            pf0_gen3_eq_eval_2ms_disable                                                                         =    "pf0_abort"                              ,
      parameter            pf0_gen3_eq_fb_mode                                                                                  =    "pf0_dir_chg"                            ,
      parameter  [5:0]     pf0_gen3_eq_fb_mode_dir_change_off_rsvdp_18                                                          =    6'b000000                                ,
      parameter  [3:0]     pf0_gen3_eq_fmdc_max_post_cusror_delta                                                               =    4'b0010                                  ,
      parameter  [3:0]     pf0_gen3_eq_fmdc_max_pre_cusror_delta                                                                =    4'b0010                                  ,
      parameter  [4:0]     pf0_gen3_eq_fmdc_n_evals                                                                             =    5'b00100                                 ,
      parameter  [4:0]     pf0_gen3_eq_fmdc_t_min_phase23                                                                       =    5'b00010                                 ,
      parameter            pf0_gen3_eq_fom_inc_initial_eval                                                                     =    "pf0_ignore_init_fom"                    ,
      parameter  [5:0]     pf0_gen3_eq_local_fs                                                                                 =    6'b111111                                ,
      parameter  [3:0]     pf0_gen3_eq_local_fs_lf_off_rsvdp_12                                                                 =    4'b0000                                  ,
      parameter  [5:0]     pf0_gen3_eq_local_lf                                                                                 =    6'b010000                                ,
      parameter            pf0_gen3_eq_phase23_exit_mode                                                                        =    "pf0_next_rec_speed"                     ,
      parameter            pf0_gen3_eq_pset_req_as_coef                                                                         =    "false"                                  ,
      parameter  [15:0]    pf0_gen3_eq_pset_req_vec                                                                             =    16'b0000000010000000                     ,
      parameter            pf0_gen3_equalization_disable                                                                        =    "enable"                                 ,
      parameter  [6:0]     pf0_gen3_related_off_rsvdp_1                                                                         =    7'b0000000                               ,
      parameter  [2:0]     pf0_gen3_related_off_rsvdp_13                                                                        =    3'b000                                   ,
      parameter  [4:0]     pf0_gen3_related_off_rsvdp_19                                                                        =    5'b00000                                 ,
      parameter            pf0_gen3_zrxdc_noncompl                                                                              =    "pf0_non_compliant"                      ,
      parameter            pf0_global_inval_spprtd                                                                              =    "false"                                  ,
      parameter  [6:0]     pf0_header_type                                                                                      =    7'b0000000                               ,
      parameter            pf0_int_pin                                                                                          =    "pf0_inta"                               ,
      parameter  [4:0]     pf0_invalidate_q_depth                                                                               =    5'b00000                                 ,
      parameter            pf0_lane_equalization_control01_reg_rsvdp_15                                                         =    "false"                                  ,
      parameter            pf0_lane_equalization_control01_reg_rsvdp_23                                                         =    "false"                                  ,
      parameter            pf0_lane_equalization_control01_reg_rsvdp_31                                                         =    "false"                                  ,
      parameter            pf0_lane_equalization_control01_reg_rsvdp_7                                                          =    "false"                                  ,
      parameter            pf0_lane_equalization_control1011_reg_rsvdp_15                                                       =    "false"                                  ,
      parameter            pf0_lane_equalization_control1011_reg_rsvdp_23                                                       =    "false"                                  ,
      parameter            pf0_lane_equalization_control1011_reg_rsvdp_31                                                       =    "false"                                  ,
      parameter            pf0_lane_equalization_control1011_reg_rsvdp_7                                                        =    "false"                                  ,
      parameter            pf0_lane_equalization_control1213_reg_rsvdp_15                                                       =    "false"                                  ,
      parameter            pf0_lane_equalization_control1213_reg_rsvdp_23                                                       =    "false"                                  ,
      parameter            pf0_lane_equalization_control1213_reg_rsvdp_31                                                       =    "false"                                  ,
      parameter            pf0_lane_equalization_control1213_reg_rsvdp_7                                                        =    "false"                                  ,
      parameter            pf0_lane_equalization_control1415_reg_rsvdp_15                                                       =    "false"                                  ,
      parameter            pf0_lane_equalization_control1415_reg_rsvdp_23                                                       =    "false"                                  ,
      parameter            pf0_lane_equalization_control1415_reg_rsvdp_31                                                       =    "false"                                  ,
      parameter            pf0_lane_equalization_control1415_reg_rsvdp_7                                                        =    "false"                                  ,
      parameter            pf0_lane_equalization_control23_reg_rsvdp_15                                                         =    "false"                                  ,
      parameter            pf0_lane_equalization_control23_reg_rsvdp_23                                                         =    "false"                                  ,
      parameter            pf0_lane_equalization_control23_reg_rsvdp_31                                                         =    "false"                                  ,
      parameter            pf0_lane_equalization_control23_reg_rsvdp_7                                                          =    "false"                                  ,
      parameter            pf0_lane_equalization_control45_reg_rsvdp_15                                                         =    "false"                                  ,
      parameter            pf0_lane_equalization_control45_reg_rsvdp_23                                                         =    "false"                                  ,
      parameter            pf0_lane_equalization_control45_reg_rsvdp_31                                                         =    "false"                                  ,
      parameter            pf0_lane_equalization_control45_reg_rsvdp_7                                                          =    "false"                                  ,
      parameter            pf0_lane_equalization_control67_reg_rsvdp_15                                                         =    "false"                                  ,
      parameter            pf0_lane_equalization_control67_reg_rsvdp_23                                                         =    "false"                                  ,
      parameter            pf0_lane_equalization_control67_reg_rsvdp_31                                                         =    "false"                                  ,
      parameter            pf0_lane_equalization_control67_reg_rsvdp_7                                                          =    "false"                                  ,
      parameter            pf0_lane_equalization_control89_reg_rsvdp_15                                                         =    "false"                                  ,
      parameter            pf0_lane_equalization_control89_reg_rsvdp_23                                                         =    "false"                                  ,
      parameter            pf0_lane_equalization_control89_reg_rsvdp_31                                                         =    "false"                                  ,
      parameter            pf0_lane_equalization_control89_reg_rsvdp_7                                                          =    "false"                                  ,
      parameter            pf0_link_capabilities_reg_rsvdp_23                                                                   =    "false"                                  ,
      parameter            pf0_link_capable                                                                                     =    "pf0_conn_x1"                            ,
      parameter  [3:0]     pf0_link_control_link_status_reg_rsvdp_12                                                            =    4'b0000                                  ,
      parameter            pf0_link_control_link_status_reg_rsvdp_2                                                             =    "false"                                  ,
      parameter  [1:0]     pf0_link_control_link_status_reg_rsvdp_25                                                            =    2'b00                                    ,
      parameter            pf0_link_control_link_status_reg_rsvdp_9                                                             =    "false"                                  ,
      parameter            pf0_link_disable                                                                                     =    "false"                                  ,
      parameter  [7:0]     pf0_link_num                                                                                         =    8'b00000100                              ,
      parameter            pf0_loopback_enable                                                                                  =    "false"                                  ,
      parameter  [15:0]    pf0_mask_radm_1                                                                                      =    16'b0010000000001000                     ,
      parameter  [31:0]    pf0_mask_radm_2                                                                                      =    32'b00000000000000000000000000000011     ,
      parameter            pf0_max_func_num                                                                                     =    "pf0_one_function"                       ,
      parameter  [6:0]     pf0_misc_control_1_off_rsvdp_1                                                                       =    7'b0000000                               ,
      parameter  [23:0]    pf0_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte1                                                  =    24'b000000000000000001010001             ,
      parameter  [23:0]    pf0_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte2                                                  =    24'b000000000000000001010010             ,
      parameter  [23:0]    pf0_msix_cap_msix_pba_offset_reg_addr_byte0                                                          =    24'b000000000000000010111000             ,
      parameter  [23:0]    pf0_msix_cap_msix_pba_offset_reg_addr_byte1                                                          =    24'b000000000000000010111001             ,
      parameter  [23:0]    pf0_msix_cap_msix_pba_offset_reg_addr_byte2                                                          =    24'b000000000000000010111010             ,
      parameter  [23:0]    pf0_msix_cap_msix_pba_offset_reg_addr_byte3                                                          =    24'b000000000000000010111011             ,
      parameter  [23:0]    pf0_msix_cap_msix_table_offset_reg_addr_byte0                                                        =    24'b000000000000000010110100             ,
      parameter  [23:0]    pf0_msix_cap_msix_table_offset_reg_addr_byte1                                                        =    24'b000000000000000010110101             ,
      parameter  [23:0]    pf0_msix_cap_msix_table_offset_reg_addr_byte2                                                        =    24'b000000000000000010110110             ,
      parameter  [23:0]    pf0_msix_cap_msix_table_offset_reg_addr_byte3                                                        =    24'b000000000000000010110111             ,
      parameter  [23:0]    pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte1                                                =    24'b000000000000000010110001             ,
      parameter  [23:0]    pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte2                                                =    24'b000000000000000010110010             ,
      parameter  [23:0]    pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte3                                                =    24'b000000000000000010110011             ,
      parameter  [23:0]    pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte2                                     =    24'b001000000000000010110010             ,
      parameter  [23:0]    pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte3                                     =    24'b001000000000000010110011             ,
      parameter            pf0_multi_func                                                                                       =    "true"                                   ,
      parameter            pf0_no_soft_rst                                                                                      =    "pf0_internally_reset"                   ,
      parameter  [4:0]     pf0_num_of_lanes                                                                                     =    5'b10000                                 ,
      parameter            pf0_page_aligned_req                                                                                 =    "true"                                   ,
      parameter            pf0_pci_msi_64_bit_addr_cap                                                                          =    "true"                                   ,
      parameter  [7:0]     pf0_pci_msi_cap_next_offset                                                                          =    8'b01110000                              ,
      parameter            pf0_pci_msi_enable                                                                                   =    "false"                                  ,
      parameter            pf0_pci_msi_multiple_msg_cap                                                                         =    "pf0_msi_vec_32"                         ,
      parameter  [2:0]     pf0_pci_msi_multiple_msg_en                                                                          =    3'b000                                   ,
      parameter  [2:0]     pf0_pci_msix_bir                                                                                     =    3'b000                                   ,
      parameter  [2:0]     pf0_pci_msix_cap_id_next_ctrl_reg_rsvdp_27                                                           =    3'b000                                   ,
      parameter  [2:0]     pf0_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                                     =    3'b000                                   ,
      parameter  [7:0]     pf0_pci_msix_cap_next_offset                                                                         =    8'b00000000                              ,
      parameter            pf0_pci_msix_enable                                                                                  =    "false"                                  ,
      parameter            pf0_pci_msix_enable_vfcomm_cs2                                                                       =    "false"                                  ,
      parameter            pf0_pci_msix_function_mask                                                                           =    "false"                                  ,
      parameter            pf0_pci_msix_function_mask_vfcomm_cs2                                                                =    "false"                                  ,
      parameter  [2:0]     pf0_pci_msix_pba                                                                                     =    3'b000                                   ,
      parameter  [28:0]    pf0_pci_msix_pba_offset                                                                              =    29'b00000000000000000000000000000        ,
      parameter  [28:0]    pf0_pci_msix_table_offset                                                                            =    29'b00000000000000000000000000000        ,
      parameter  [10:0]    pf0_pci_msix_table_size                                                                              =    11'b00011111111                          ,
      parameter  [10:0]    pf0_pci_msix_table_size_vfcomm_cs2                                                                   =    11'b00000000000                          ,
      parameter            pf0_pci_type0_bar0_enabled                                                                           =    "enable"                                 ,
      parameter  [30:0]    pf0_pci_type0_bar0_mask_31_1                                                                         =    31'b1111111111111111111111111111111      ,
      parameter  [6:0]     pf0_pci_type0_bar1_dummy_mask_7_1                                                                    =    7'b1111111                               ,
      parameter            pf0_pci_type0_bar1_enabled                                                                           =    "enable"                                 ,
      parameter            pf0_pci_type0_bar1_enabled_or_mask64lsb                                                              =    "disable"                                ,
      parameter  [30:0]    pf0_pci_type0_bar1_mask_31_1                                                                         =    31'b1111111111111111111111111111111      ,
      parameter            pf0_pci_type0_bar2_enabled                                                                           =    "enable"                                 ,
      parameter  [30:0]    pf0_pci_type0_bar2_mask_31_1                                                                         =    31'b1111111111111111111111111111111      ,
      parameter  [6:0]     pf0_pci_type0_bar3_dummy_mask_7_1                                                                    =    7'b1111111                               ,
      parameter            pf0_pci_type0_bar3_enabled                                                                           =    "enable"                                 ,
      parameter            pf0_pci_type0_bar3_enabled_or_mask64lsb                                                              =    "disable"                                ,
      parameter  [30:0]    pf0_pci_type0_bar3_mask_31_1                                                                         =    31'b1111111111111111111111111111111      ,
      parameter            pf0_pci_type0_bar4_enabled                                                                           =    "enable"                                 ,
      parameter  [30:0]    pf0_pci_type0_bar4_mask_31_1                                                                         =    31'b1111111111111111111111111111111      ,
      parameter  [6:0]     pf0_pci_type0_bar5_dummy_mask_7_1                                                                    =    7'b1111111                               ,
      parameter            pf0_pci_type0_bar5_enabled                                                                           =    "enable"                                 ,
      parameter            pf0_pci_type0_bar5_enabled_or_mask64lsb                                                              =    "disable"                                ,
      parameter  [30:0]    pf0_pci_type0_bar5_mask_31_1                                                                         =    31'b1111111111111111111111111111111      ,
      parameter  [15:0]    pf0_pci_type0_device_id                                                                              =    16'b1010101111001101                     ,
      parameter  [15:0]    pf0_pci_type0_vendor_id                                                                              =    16'b0001011011000011                     ,
      parameter            pf0_pcie_cap_active_state_link_pm_control                                                            =    "pf0_aspm_dis"                           ,
      parameter            pf0_pcie_cap_active_state_link_pm_support                                                            =    "pf0_no_aspm"                            ,
      parameter            pf0_pcie_cap_aspm_opt_compliance                                                                     =    "true"                                   ,
      parameter            pf0_pcie_cap_attention_indicator                                                                     =    "false"                                  ,
      parameter            pf0_pcie_cap_attention_indicator_button                                                              =    "false"                                  ,
      parameter            pf0_pcie_cap_aux_power_pm_en                                                                         =    "false"                                  ,
      parameter            pf0_pcie_cap_clock_power_man                                                                         =    "pf0_refclk_remove_not_ok"               ,
      parameter            pf0_pcie_cap_common_clk_config                                                                       =    "false"                                  ,
      parameter            pf0_pcie_cap_crs_sw_visibility                                                                       =    "false"                                  ,
      parameter  [23:0]    pf0_pcie_cap_device_capabilities_reg_addr_byte0                                                      =    24'b000000000000000001110100             ,
      parameter  [23:0]    pf0_pcie_cap_device_capabilities_reg_addr_byte1                                                      =    24'b000000000000000001110101             ,
      parameter  [23:0]    pf0_pcie_cap_device_capabilities_reg_addr_byte2                                                      =    24'b000000000000000001110110             ,
      parameter  [23:0]    pf0_pcie_cap_device_control_device_status_addr_byte1                                                 =    24'b000000000000000001111001             ,
      parameter            pf0_pcie_cap_dll_active                                                                              =    "false"                                  ,
      parameter            pf0_pcie_cap_dll_active_rep_cap                                                                      =    "false"                                  ,
      parameter            pf0_pcie_cap_electromech_interlock                                                                   =    "false"                                  ,
      parameter            pf0_pcie_cap_en_clk_power_man                                                                        =    "pf0_clkreq_dis"                         ,
      parameter            pf0_pcie_cap_en_no_snoop                                                                             =    "false"                                  ,
      parameter            pf0_pcie_cap_enter_compliance                                                                        =    "false"                                  ,
      parameter  [2:0]     pf0_pcie_cap_ep_l0s_accpt_latency                                                                    =    3'b000                                   ,
      parameter  [2:0]     pf0_pcie_cap_ep_l1_accpt_latency                                                                     =    3'b000                                   ,
      parameter            pf0_pcie_cap_ext_tag_en                                                                              =    "false"                                  ,
      parameter            pf0_pcie_cap_ext_tag_supp                                                                            =    "pf0_supported"                          ,
      parameter            pf0_pcie_cap_extended_synch                                                                          =    "false"                                  ,
      parameter            pf0_pcie_cap_flr_cap                                                                                 =    "pf0_capable"                            ,
      parameter            pf0_pcie_cap_hot_plug_capable                                                                        =    "false"                                  ,
      parameter            pf0_pcie_cap_hot_plug_surprise                                                                       =    "false"                                  ,
      parameter            pf0_pcie_cap_hw_auto_speed_disable                                                                   =    "false"                                  ,
      parameter            pf0_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvd                                                  =    "false"                                  ,
      parameter            pf0_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvdp_31                                              =    "false"                                  ,
      parameter            pf0_pcie_cap_initiate_flr                                                                            =    "false"                                  ,
      parameter  [2:0]     pf0_pcie_cap_l0s_exit_latency_commclk_dis                                                            =    3'b111                                   ,
      parameter  [2:0]     pf0_pcie_cap_l0s_exit_latency_commclk_ena_cs2                                                        =    3'b111                                   ,
      parameter  [2:0]     pf0_pcie_cap_l1_exit_latency_commclk_dis                                                             =    3'b111                                   ,
      parameter  [2:0]     pf0_pcie_cap_l1_exit_latency_commclk_ena_cs2                                                         =    3'b111                                   ,
      parameter            pf0_pcie_cap_link_auto_bw_int_en                                                                     =    "false"                                  ,
      parameter            pf0_pcie_cap_link_auto_bw_status                                                                     =    "false"                                  ,
      parameter            pf0_pcie_cap_link_bw_man_int_en                                                                      =    "false"                                  ,
      parameter            pf0_pcie_cap_link_bw_man_status                                                                      =    "false"                                  ,
      parameter            pf0_pcie_cap_link_bw_not_cap                                                                         =    "false"                                  ,
      parameter  [23:0]    pf0_pcie_cap_link_capabilities_reg_addr_byte0                                                        =    24'b000000000000000001111100             ,
      parameter  [23:0]    pf0_pcie_cap_link_capabilities_reg_addr_byte1                                                        =    24'b000000000000000001111101             ,
      parameter  [23:0]    pf0_pcie_cap_link_capabilities_reg_addr_byte2                                                        =    24'b000000000000000001111110             ,
      parameter  [23:0]    pf0_pcie_cap_link_capabilities_reg_addr_byte3                                                        =    24'b000000000000000001111111             ,
      parameter  [23:0]    pf0_pcie_cap_link_control2_link_status2_reg_addr_byte0                                               =    24'b010000000000000010100000             ,
      parameter  [23:0]    pf0_pcie_cap_link_control_link_status_reg_addr_byte0                                                 =    24'b010000000000000010000000             ,
      parameter  [23:0]    pf0_pcie_cap_link_control_link_status_reg_addr_byte1                                                 =    24'b010000000000000010000001             ,
      parameter  [23:0]    pf0_pcie_cap_link_control_link_status_reg_addr_byte2                                                 =    24'b010000000000000010000010             ,
      parameter            pf0_pcie_cap_link_disable                                                                            =    "false"                                  ,
      parameter            pf0_pcie_cap_link_training                                                                           =    "false"                                  ,
      parameter            pf0_pcie_cap_max_link_speed                                                                          =    "pf0_max_8gts"                           ,
      parameter            pf0_pcie_cap_max_link_width                                                                          =    "pf0_x16"                                ,
      parameter            pf0_pcie_cap_max_payload_size                                                                        =    "pf0_payload_1024"                       ,
      parameter  [2:0]     pf0_pcie_cap_max_read_req_size                                                                       =    3'b000                                   ,
      parameter            pf0_pcie_cap_mrl_sensor                                                                              =    "false"                                  ,
      parameter            pf0_pcie_cap_nego_link_width                                                                         =    "false"                                  ,
      parameter  [7:0]     pf0_pcie_cap_next_ptr                                                                                =    8'b10110000                              ,
      parameter            pf0_pcie_cap_no_cmd_cpl_support                                                                      =    "false"                                  ,
      parameter  [23:0]    pf0_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte1                                   =    24'b000000000000000001110001             ,
      parameter  [23:0]    pf0_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte3                                   =    24'b000000000000000001110011             ,
      parameter            pf0_pcie_cap_phantom_func_en                                                                         =    "false"                                  ,
      parameter  [1:0]     pf0_pcie_cap_phantom_func_support                                                                    =    2'b00                                    ,
      parameter  [12:0]    pf0_pcie_cap_phy_slot_num                                                                            =    13'b0000000000000                        ,
      parameter  [7:0]     pf0_pcie_cap_port_num                                                                                =    8'b00000000                              ,
      parameter            pf0_pcie_cap_power_controller                                                                        =    "false"                                  ,
      parameter            pf0_pcie_cap_power_indicator                                                                         =    "false"                                  ,
      parameter            pf0_pcie_cap_rcb                                                                                     =    "pf0_rcb_64"                             ,
      parameter            pf0_pcie_cap_retrain_link                                                                            =    "false"                                  ,
      parameter            pf0_pcie_cap_role_based_err_report                                                                   =    "false"                                  ,
      parameter  [23:0]    pf0_pcie_cap_root_control_root_capabilities_reg_addr_byte2                                           =    24'b000000000000000010001110             ,
      parameter            pf0_pcie_cap_sel_deemphasis                                                                          =    "pf0_minus_6db"                          ,
      parameter  [23:0]    pf0_pcie_cap_shadow_link_capabilities_reg_addr_byte0                                                 =    24'b001000000000000001111100             ,
      parameter  [23:0]    pf0_pcie_cap_shadow_link_capabilities_reg_addr_byte1                                                 =    24'b001000000000000001111101             ,
      parameter  [23:0]    pf0_pcie_cap_slot_capabilities_reg_addr_byte0                                                        =    24'b000000000000000010000100             ,
      parameter  [23:0]    pf0_pcie_cap_slot_capabilities_reg_addr_byte1                                                        =    24'b000000000000000010000101             ,
      parameter  [23:0]    pf0_pcie_cap_slot_capabilities_reg_addr_byte2                                                        =    24'b000000000000000010000110             ,
      parameter  [23:0]    pf0_pcie_cap_slot_capabilities_reg_addr_byte3                                                        =    24'b000000000000000010000111             ,
      parameter            pf0_pcie_cap_slot_clk_config                                                                         =    "false"                                  ,
      parameter  [1:0]     pf0_pcie_cap_slot_power_limit_scale                                                                  =    2'b00                                    ,
      parameter  [7:0]     pf0_pcie_cap_slot_power_limit_value                                                                  =    8'b00000000                              ,
      parameter            pf0_pcie_cap_surprise_down_err_rep_cap                                                               =    "false"                                  ,
      parameter            pf0_pcie_cap_target_link_speed                                                                       =    "pf0_trgt_gen3"                          ,
      parameter            pf0_pcie_cap_tx_margin                                                                               =    "false"                                  ,
      parameter  [4:0]     pf0_pcie_int_msg_num                                                                                 =    5'b00000                                 ,
      parameter            pf0_pcie_slot_imp                                                                                    =    "pf0_not_implemented"                    ,
      parameter            pf0_pipe_loopback                                                                                    =    "disable"                                ,
      parameter  [3:0]     pf0_pipe_loopback_control_off_rsvdp_27                                                               =    4'b0000                                  ,
      parameter  [23:0]    pf0_pm_cap_cap_id_nxt_ptr_reg_addr_byte1                                                             =    24'b000000000000000001000001             ,
      parameter  [23:0]    pf0_pm_cap_cap_id_nxt_ptr_reg_addr_byte2                                                             =    24'b000000000000000001000010             ,
      parameter  [23:0]    pf0_pm_cap_cap_id_nxt_ptr_reg_addr_byte3                                                             =    24'b000000000000000001000011             ,
      parameter  [23:0]    pf0_pm_cap_con_status_reg_addr_byte0                                                                 =    24'b000000000000000001000100             ,
      parameter  [7:0]     pf0_pm_next_pointer                                                                                  =    8'b01010000                              ,
      parameter  [2:0]     pf0_pm_spec_ver                                                                                      =    3'b011                                   ,
      parameter            pf0_pme_clk                                                                                          =    "false"                                  ,
      parameter  [4:0]     pf0_pme_support                                                                                      =    5'b11011                                 ,
      parameter            pf0_port_link_ctrl_off_rsvdp_4                                                                       =    "false"                                  ,
      parameter  [23:0]    pf0_port_logic_ack_f_aspm_ctrl_off_addr_byte1                                                        =    24'b000000000000011100001101             ,
      parameter  [23:0]    pf0_port_logic_ack_f_aspm_ctrl_off_addr_byte2                                                        =    24'b000000000000011100001110             ,
      parameter  [23:0]    pf0_port_logic_aux_clk_freq_off_addr_byte0                                                           =    24'b000000000000101101000000             ,
      parameter  [23:0]    pf0_port_logic_aux_clk_freq_off_addr_byte1                                                           =    24'b000000000000101101000001             ,
      parameter  [23:0]    pf0_port_logic_filter_mask_2_off_addr_byte0                                                          =    24'b000000000000011100100000             ,
      parameter  [23:0]    pf0_port_logic_filter_mask_2_off_addr_byte1                                                          =    24'b000000000000011100100001             ,
      parameter  [23:0]    pf0_port_logic_filter_mask_2_off_addr_byte2                                                          =    24'b000000000000011100100010             ,
      parameter  [23:0]    pf0_port_logic_filter_mask_2_off_addr_byte3                                                          =    24'b000000000000011100100011             ,
      parameter  [23:0]    pf0_port_logic_gen2_ctrl_off_addr_byte0                                                              =    24'b000000000000100000001100             ,
      parameter  [23:0]    pf0_port_logic_gen2_ctrl_off_addr_byte1                                                              =    24'b000000000000100000001101             ,
      parameter  [23:0]    pf0_port_logic_gen2_ctrl_off_addr_byte2                                                              =    24'b010000000000100000001110             ,
      parameter  [23:0]    pf0_port_logic_gen3_eq_control_off_addr_byte0                                                        =    24'b000000000000100010101000             ,
      parameter  [23:0]    pf0_port_logic_gen3_eq_control_off_addr_byte1                                                        =    24'b000000000000100010101001             ,
      parameter  [23:0]    pf0_port_logic_gen3_eq_control_off_addr_byte2                                                        =    24'b000000000000100010101010             ,
      parameter  [23:0]    pf0_port_logic_gen3_eq_control_off_addr_byte3                                                        =    24'b000000000000100010101011             ,
      parameter  [23:0]    pf0_port_logic_gen3_eq_fb_mode_dir_change_off_addr_byte0                                             =    24'b000000000000100010101100             ,
      parameter  [23:0]    pf0_port_logic_gen3_eq_fb_mode_dir_change_off_addr_byte1                                             =    24'b000000000000100010101101             ,
      parameter  [23:0]    pf0_port_logic_gen3_eq_fb_mode_dir_change_off_addr_byte2                                             =    24'b000000000000100010101110             ,
      parameter  [23:0]    pf0_port_logic_gen3_eq_local_fs_lf_off_addr_byte0                                                    =    24'b000000000000100010010100             ,
      parameter  [23:0]    pf0_port_logic_gen3_eq_local_fs_lf_off_addr_byte1                                                    =    24'b000000000000100010010101             ,
      parameter  [23:0]    pf0_port_logic_gen3_related_off_addr_byte0                                                           =    24'b000000000000100010010000             ,
      parameter  [23:0]    pf0_port_logic_gen3_related_off_addr_byte1                                                           =    24'b000000000000100010010001             ,
      parameter  [23:0]    pf0_port_logic_gen3_related_off_addr_byte2                                                           =    24'b000000000000100010010010             ,
      parameter  [23:0]    pf0_port_logic_misc_control_1_off_addr_byte0                                                         =    24'b000000000000100010111100             ,
      parameter  [23:0]    pf0_port_logic_pipe_loopback_control_off_addr_byte3                                                  =    24'b000000000000100010111011             ,
      parameter  [23:0]    pf0_port_logic_port_force_off_addr_byte0                                                             =    24'b000000000000011100001000             ,
      parameter  [23:0]    pf0_port_logic_port_link_ctrl_off_addr_byte0                                                         =    24'b000000000000011100010000             ,
      parameter  [23:0]    pf0_port_logic_port_link_ctrl_off_addr_byte2                                                         =    24'b000000000000011100010010             ,
      parameter  [23:0]    pf0_port_logic_queue_status_off_addr_byte2                                                           =    24'b000000000000011100111110             ,
      parameter  [23:0]    pf0_port_logic_queue_status_off_addr_byte3                                                           =    24'b000000000000011100111111             ,
      parameter  [23:0]    pf0_port_logic_symbol_timer_filter_1_off_addr_byte0                                                  =    24'b000000000000011100011100             ,
      parameter  [23:0]    pf0_port_logic_symbol_timer_filter_1_off_addr_byte1                                                  =    24'b000000000000011100011101             ,
      parameter  [23:0]    pf0_port_logic_symbol_timer_filter_1_off_addr_byte2                                                  =    24'b000000000000011100011110             ,
      parameter  [23:0]    pf0_port_logic_symbol_timer_filter_1_off_addr_byte3                                                  =    24'b000000000000011100011111             ,
      parameter  [23:0]    pf0_port_logic_timer_ctrl_max_func_num_off_addr_byte0                                                =    24'b000000000000011100011000             ,
      parameter  [23:0]    pf0_port_logic_vc0_cpl_rx_q_ctrl_off_addr_byte0                                                      =    24'b000000000000011101010000             ,
      parameter  [23:0]    pf0_port_logic_vc0_cpl_rx_q_ctrl_off_addr_byte1                                                      =    24'b000000000000011101010001             ,
      parameter  [23:0]    pf0_port_logic_vc0_cpl_rx_q_ctrl_off_addr_byte2                                                      =    24'b000000000000011101010010             ,
      parameter  [23:0]    pf0_port_logic_vc0_np_rx_q_ctrl_off_addr_byte0                                                       =    24'b000000000000011101001100             ,
      parameter  [23:0]    pf0_port_logic_vc0_np_rx_q_ctrl_off_addr_byte1                                                       =    24'b000000000000011101001101             ,
      parameter  [23:0]    pf0_port_logic_vc0_np_rx_q_ctrl_off_addr_byte2                                                       =    24'b000000000000011101001110             ,
      parameter  [23:0]    pf0_port_logic_vc0_p_rx_q_ctrl_off_addr_byte0                                                        =    24'b000000000000011101001000             ,
      parameter  [23:0]    pf0_port_logic_vc0_p_rx_q_ctrl_off_addr_byte1                                                        =    24'b000000000000011101001001             ,
      parameter  [23:0]    pf0_port_logic_vc0_p_rx_q_ctrl_off_addr_byte2                                                        =    24'b000000000000011101001010             ,
      parameter  [1:0]     pf0_power_state                                                                                      =    2'b00                                    ,
      parameter            pf0_pre_det_lane                                                                                     =    "pf0_det_all_lanes"                      ,
      parameter  [7:0]     pf0_program_interface                                                                                =    8'b00000000                              ,
      parameter  [1:0]     pf0_queue_status_off_rsvdp_29                                                                        =    2'b00                                    ,
      parameter            pf0_reserved4                                                                                        =    "false"                                  ,
      parameter            pf0_reserved6                                                                                        =    "false"                                  ,
      parameter            pf0_reserved8                                                                                        =    "false"                                  ,
      parameter  [23:0]    pf0_reserved_0_addr                                                                                  =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_10_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_11_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_12_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_13_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_14_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_15_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_16_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_17_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_18_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_19_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_1_addr                                                                                  =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_20_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_21_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_22_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_23_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_24_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_25_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_26_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_27_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_28_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_29_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_2_addr                                                                                  =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_30_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_31_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_32_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_33_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_34_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_35_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_36_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_37_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_38_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_39_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_3_addr                                                                                  =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_40_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_41_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_42_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_43_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_44_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_45_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_46_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_47_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_48_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_49_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_4_addr                                                                                  =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_50_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_51_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_52_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_53_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_54_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_55_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_56_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_57_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_5_addr                                                                                  =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_6_addr                                                                                  =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_7_addr                                                                                  =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_8_addr                                                                                  =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_reserved_9_addr                                                                                  =    24'b000000000000000000000000             ,
      parameter            pf0_reset_assert                                                                                     =    "false"                                  ,
      parameter  [7:0]     pf0_revision_id                                                                                      =    8'b00000001                              ,
      parameter            pf0_rom_bar_enable                                                                                   =    "disable"                                ,
      parameter            pf0_rom_bar_enabled                                                                                  =    "enable"                                 ,
      parameter  [20:0]    pf0_rom_mask                                                                                         =    21'b000001111111111111111                ,
      parameter  [6:0]     pf0_root_control_root_capabilities_reg_rsvdp_17                                                      =    7'b0000000                               ,
      parameter  [2:0]     pf0_root_err_status_off_rsvdp_7                                                                      =    3'b000                                   ,
      parameter  [9:0]     pf0_rp_exp_rom_bar_mask_reg_rp_rom_rsvdp_1                                                           =    10'b0000000000                           ,
      parameter            pf0_rp_rom_bar_enabled                                                                               =    "enable"                                 ,
      parameter  [20:0]    pf0_rp_rom_mask                                                                                      =    21'b000000000000000000000                ,
      parameter            pf0_rxeq_ph01_en                                                                                     =    "enable"                                 ,
      parameter  [2:0]     pf0_rxstatus_value                                                                                   =    3'b000                                   ,
      parameter            pf0_scramble_disable                                                                                 =    "false"                                  ,
      parameter            pf0_sel_deemphasis                                                                                   =    "pf0_minus_3db_ctl"                      ,
      parameter            pf0_shadow_link_capabilities_reg_shadow_rsvdp_23                                                     =    "false"                                  ,
      parameter  [1:0]     pf0_shadow_pcie_cap_active_state_link_pm_support                                                     =    2'b00                                    ,
      parameter            pf0_shadow_pcie_cap_aspm_opt_compliance                                                              =    "false"                                  ,
      parameter            pf0_shadow_pcie_cap_clock_power_man                                                                  =    "false"                                  ,
      parameter            pf0_shadow_pcie_cap_dll_active_rep_cap                                                               =    "false"                                  ,
      parameter            pf0_shadow_pcie_cap_link_bw_not_cap                                                                  =    "false"                                  ,
      parameter  [1:0]     pf0_shadow_pcie_cap_max_link_width                                                                   =    2'b00                                    ,
      parameter            pf0_shadow_pcie_cap_surprise_down_err_rep_cap                                                        =    "false"                                  ,
      parameter  [15:0]    pf0_shadow_sriov_vf_stride_ari_cs2                                                                   =    16'b0000000000000010                     ,
      parameter  [10:0]    pf0_skp_int_val                                                                                      =    11'b01010000000                          ,
      parameter  [23:0]    pf0_sn_cap_ser_num_reg_dw_1_addr_byte0                                                               =    24'b000000000000000101101100             ,
      parameter  [23:0]    pf0_sn_cap_ser_num_reg_dw_1_addr_byte1                                                               =    24'b000000000000000101101101             ,
      parameter  [23:0]    pf0_sn_cap_ser_num_reg_dw_1_addr_byte2                                                               =    24'b000000000000000101101110             ,
      parameter  [23:0]    pf0_sn_cap_ser_num_reg_dw_1_addr_byte3                                                               =    24'b000000000000000101101111             ,
      parameter  [23:0]    pf0_sn_cap_ser_num_reg_dw_2_addr_byte0                                                               =    24'b000000000000000101110000             ,
      parameter  [23:0]    pf0_sn_cap_ser_num_reg_dw_2_addr_byte1                                                               =    24'b000000000000000101110001             ,
      parameter  [23:0]    pf0_sn_cap_ser_num_reg_dw_2_addr_byte2                                                               =    24'b000000000000000101110010             ,
      parameter  [23:0]    pf0_sn_cap_ser_num_reg_dw_2_addr_byte3                                                               =    24'b000000000000000101110011             ,
      parameter  [23:0]    pf0_sn_cap_sn_base_addr_byte2                                                                        =    24'b000000000000000101101010             ,
      parameter  [23:0]    pf0_sn_cap_sn_base_addr_byte3                                                                        =    24'b000000000000000101101011             ,
      parameter  [3:0]     pf0_sn_cap_version                                                                                   =    4'b0001                                  ,
      parameter  [11:0]    pf0_sn_next_offset                                                                                   =    12'b000101111000                         ,
      parameter  [31:0]    pf0_sn_ser_num_reg_1_dw                                                                              =    32'b00000000000000000000000000000000     ,
      parameter  [31:0]    pf0_sn_ser_num_reg_2_dw                                                                              =    32'b00000000000000000000000000000000     ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control01_reg_addr_byte0                                             =    24'b000000000000000110010100             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control01_reg_addr_byte1                                             =    24'b000000000000000110010101             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control01_reg_addr_byte2                                             =    24'b000000000000000110010110             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control01_reg_addr_byte3                                             =    24'b000000000000000110010111             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte0                                           =    24'b000000000000000110101000             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte1                                           =    24'b000000000000000110101001             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte2                                           =    24'b000000000000000110101010             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte3                                           =    24'b000000000000000110101011             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte0                                           =    24'b000000000000000110101100             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte1                                           =    24'b000000000000000110101101             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte2                                           =    24'b000000000000000110101110             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte3                                           =    24'b000000000000000110101111             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte0                                           =    24'b000000000000000110110000             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte1                                           =    24'b000000000000000110110001             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte2                                           =    24'b000000000000000110110010             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte3                                           =    24'b000000000000000110110011             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control23_reg_addr_byte0                                             =    24'b000000000000000110011000             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control23_reg_addr_byte1                                             =    24'b000000000000000110011001             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control23_reg_addr_byte2                                             =    24'b000000000000000110011010             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control23_reg_addr_byte3                                             =    24'b000000000000000110011011             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control45_reg_addr_byte0                                             =    24'b000000000000000110011100             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control45_reg_addr_byte1                                             =    24'b000000000000000110011101             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control45_reg_addr_byte2                                             =    24'b000000000000000110011110             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control45_reg_addr_byte3                                             =    24'b000000000000000110011111             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control67_reg_addr_byte0                                             =    24'b000000000000000110100000             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control67_reg_addr_byte1                                             =    24'b000000000000000110100001             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control67_reg_addr_byte2                                             =    24'b000000000000000110100010             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control67_reg_addr_byte3                                             =    24'b000000000000000110100011             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control89_reg_addr_byte0                                             =    24'b000000000000000110100100             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control89_reg_addr_byte1                                             =    24'b000000000000000110100101             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control89_reg_addr_byte2                                             =    24'b000000000000000110100110             ,
      parameter  [23:0]    pf0_spcie_cap_lane_equalization_control89_reg_addr_byte3                                             =    24'b000000000000000110100111             ,
      parameter  [23:0]    pf0_spcie_cap_spcie_cap_header_reg_addr_byte2                                                        =    24'b000000000000000110001010             ,
      parameter  [23:0]    pf0_spcie_cap_spcie_cap_header_reg_addr_byte3                                                        =    24'b000000000000000110001011             ,
      parameter  [3:0]     pf0_spcie_cap_version                                                                                =    4'b0001                                  ,
      parameter  [11:0]    pf0_spcie_next_offset                                                                                =    12'b000111001000                         ,
      parameter  [23:0]    pf0_sriov_cap_shadow_sriov_initial_vfs_addr_byte0                                                    =    24'b001000000000000111000100             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_sriov_initial_vfs_addr_byte1                                                    =    24'b001000000000000111000101             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte0                                             =    24'b001000000000000111001100             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte1                                             =    24'b001000000000000111001101             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte2                                             =    24'b001000000000000111001110             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte3                                             =    24'b001000000000000111001111             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte0                                                          =    24'b001000000000000111011100             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte1                                                          =    24'b001000000000000111011101             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte2                                                          =    24'b001000000000000111011110             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte3                                                          =    24'b001000000000000111011111             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte0                                                          =    24'b001000000000000111100000             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte1                                                          =    24'b001000000000000111100001             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte2                                                          =    24'b001000000000000111100010             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte3                                                          =    24'b001000000000000111100011             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte0                                                          =    24'b001000000000000111100100             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte1                                                          =    24'b001000000000000111100101             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte2                                                          =    24'b001000000000000111100110             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte3                                                          =    24'b001000000000000111100111             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte0                                                          =    24'b001000000000000111101000             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte1                                                          =    24'b001000000000000111101001             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte2                                                          =    24'b001000000000000111101010             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte3                                                          =    24'b001000000000000111101011             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte0                                                          =    24'b001000000000000111101100             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte1                                                          =    24'b001000000000000111101101             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte2                                                          =    24'b001000000000000111101110             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte3                                                          =    24'b001000000000000111101111             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte0                                                          =    24'b001000000000000111110000             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte1                                                          =    24'b001000000000000111110001             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte2                                                          =    24'b001000000000000111110010             ,
      parameter  [23:0]    pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte3                                                          =    24'b001000000000000111110011             ,
      parameter  [23:0]    pf0_sriov_cap_sriov_bar1_enable_reg_addr_byte0                                                       =    24'b001000000000000111100000             ,
      parameter  [23:0]    pf0_sriov_cap_sriov_bar3_enable_reg_addr_byte0                                                       =    24'b001000000000000111101000             ,
      parameter  [23:0]    pf0_sriov_cap_sriov_bar5_enable_reg_addr_byte0                                                       =    24'b001000000000000111110000             ,
      parameter  [23:0]    pf0_sriov_cap_sriov_base_reg_addr_byte2                                                              =    24'b000000000000000110111010             ,
      parameter  [23:0]    pf0_sriov_cap_sriov_base_reg_addr_byte3                                                              =    24'b000000000000000110111011             ,
      parameter  [23:0]    pf0_sriov_cap_sriov_initial_vfs_addr_byte0                                                           =    24'b000000000000000111000100             ,
      parameter  [23:0]    pf0_sriov_cap_sriov_initial_vfs_addr_byte1                                                           =    24'b000000000000000111000101             ,
      parameter  [23:0]    pf0_sriov_cap_sriov_vf_offset_position_addr_byte0                                                    =    24'b000000000000000111001100             ,
      parameter  [23:0]    pf0_sriov_cap_sriov_vf_offset_position_addr_byte1                                                    =    24'b000000000000000111001101             ,
      parameter  [23:0]    pf0_sriov_cap_sriov_vf_offset_position_addr_byte2                                                    =    24'b000000000000000111001110             ,
      parameter  [23:0]    pf0_sriov_cap_sriov_vf_offset_position_addr_byte3                                                    =    24'b000000000000000111001111             ,
      parameter  [23:0]    pf0_sriov_cap_sup_page_sizes_reg_addr_byte0                                                          =    24'b000000000000000111010100             ,
      parameter  [23:0]    pf0_sriov_cap_sup_page_sizes_reg_addr_byte1                                                          =    24'b000000000000000111010101             ,
      parameter  [23:0]    pf0_sriov_cap_sup_page_sizes_reg_addr_byte2                                                          =    24'b000000000000000111010110             ,
      parameter  [23:0]    pf0_sriov_cap_sup_page_sizes_reg_addr_byte3                                                          =    24'b000000000000000111010111             ,
      parameter  [3:0]     pf0_sriov_cap_version                                                                                =    4'b0001                                  ,
      parameter  [23:0]    pf0_sriov_cap_vf_bar0_reg_addr_byte0                                                                 =    24'b000000000000000111011100             ,
      parameter  [23:0]    pf0_sriov_cap_vf_bar1_reg_addr_byte0                                                                 =    24'b000000000000000111100000             ,
      parameter  [23:0]    pf0_sriov_cap_vf_bar2_reg_addr_byte0                                                                 =    24'b000000000000000111100100             ,
      parameter  [23:0]    pf0_sriov_cap_vf_bar3_reg_addr_byte0                                                                 =    24'b000000000000000111101000             ,
      parameter  [23:0]    pf0_sriov_cap_vf_bar4_reg_addr_byte0                                                                 =    24'b000000000000000111101100             ,
      parameter  [23:0]    pf0_sriov_cap_vf_bar5_reg_addr_byte0                                                                 =    24'b000000000000000111110000             ,
      parameter  [23:0]    pf0_sriov_cap_vf_device_id_reg_addr_byte2                                                            =    24'b000000000000000111010010             ,
      parameter  [23:0]    pf0_sriov_cap_vf_device_id_reg_addr_byte3                                                            =    24'b000000000000000111010011             ,
      parameter  [15:0]    pf0_sriov_initial_vfs_ari_cs2                                                                        =    16'b0000000001000000                     ,
      parameter  [15:0]    pf0_sriov_initial_vfs_nonari                                                                         =    16'b0000000001000000                     ,
      parameter  [11:0]    pf0_sriov_next_offset                                                                                =    12'b001001111000                         ,
      parameter  [31:0]    pf0_sriov_sup_page_size                                                                              =    32'b00000000000000000000010101010011     ,
      parameter  [31:0]    pf0_sriov_vf_bar0_mask                                                                               =    32'b00000000000000000000000000000000     ,
      parameter            pf0_sriov_vf_bar0_prefetch                                                                           =    "false"                                  ,
      parameter  [3:0]     pf0_sriov_vf_bar0_start                                                                              =    4'b0000                                  ,
      parameter            pf0_sriov_vf_bar0_type                                                                               =    "pf0_sriov_vf_bar0_mem32"                ,
      parameter  [6:0]     pf0_sriov_vf_bar1_dummy_mask_7_1                                                                     =    7'b1111111                               ,
      parameter            pf0_sriov_vf_bar1_enabled                                                                            =    "enable"                                 ,
      parameter  [31:0]    pf0_sriov_vf_bar1_mask                                                                               =    32'b00000000000000000000000000000000     ,
      parameter            pf0_sriov_vf_bar1_prefetch                                                                           =    "false"                                  ,
      parameter  [3:0]     pf0_sriov_vf_bar1_start                                                                              =    4'b0000                                  ,
      parameter            pf0_sriov_vf_bar1_type                                                                               =    "pf0_sriov_vf_bar1_mem32"                ,
      parameter  [31:0]    pf0_sriov_vf_bar2_mask                                                                               =    32'b00000000000000000000000000000000     ,
      parameter            pf0_sriov_vf_bar2_prefetch                                                                           =    "false"                                  ,
      parameter  [3:0]     pf0_sriov_vf_bar2_start                                                                              =    4'b0000                                  ,
      parameter            pf0_sriov_vf_bar2_type                                                                               =    "pf0_sriov_vf_bar2_mem32"                ,
      parameter  [6:0]     pf0_sriov_vf_bar3_dummy_mask_7_1                                                                     =    7'b1111111                               ,
      parameter            pf0_sriov_vf_bar3_enabled                                                                            =    "enable"                                 ,
      parameter  [31:0]    pf0_sriov_vf_bar3_mask                                                                               =    32'b00000000000000000000000000000000     ,
      parameter            pf0_sriov_vf_bar3_prefetch                                                                           =    "false"                                  ,
      parameter  [3:0]     pf0_sriov_vf_bar3_start                                                                              =    4'b0000                                  ,
      parameter            pf0_sriov_vf_bar3_type                                                                               =    "pf0_sriov_vf_bar3_mem32"                ,
      parameter  [31:0]    pf0_sriov_vf_bar4_mask                                                                               =    32'b00000000000000000000000000000000     ,
      parameter            pf0_sriov_vf_bar4_prefetch                                                                           =    "false"                                  ,
      parameter  [3:0]     pf0_sriov_vf_bar4_start                                                                              =    4'b0000                                  ,
      parameter            pf0_sriov_vf_bar4_type                                                                               =    "pf0_sriov_vf_bar4_mem32"                ,
      parameter  [6:0]     pf0_sriov_vf_bar5_dummy_mask_7_1                                                                     =    7'b1111111                               ,
      parameter            pf0_sriov_vf_bar5_enabled                                                                            =    "enable"                                 ,
      parameter  [31:0]    pf0_sriov_vf_bar5_mask                                                                               =    32'b00000000000000000000000000000000     ,
      parameter            pf0_sriov_vf_bar5_prefetch                                                                           =    "false"                                  ,
      parameter  [3:0]     pf0_sriov_vf_bar5_start                                                                              =    4'b0000                                  ,
      parameter            pf0_sriov_vf_bar5_type                                                                               =    "pf0_sriov_vf_bar5_mem32"                ,
      parameter  [15:0]    pf0_sriov_vf_device_id                                                                               =    16'b1010101111001101                     ,
      parameter  [15:0]    pf0_sriov_vf_offset_ari_cs2                                                                          =    16'b0000000000000010                     ,
      parameter  [15:0]    pf0_sriov_vf_offset_nonari                                                                           =    16'b0000000100000000                     ,
      parameter  [15:0]    pf0_sriov_vf_stride_nonari                                                                           =    16'b0000000100000000                     ,
      parameter  [7:0]     pf0_subclass_code                                                                                    =    8'b00000000                              ,
      parameter  [15:0]    pf0_subsys_dev_id                                                                                    =    16'b0000000000000000                     ,
      parameter  [15:0]    pf0_subsys_vendor_id                                                                                 =    16'b0000000000000000                     ,
      parameter  [12:0]    pf0_timer_mod_flow_control                                                                           =    13'b0000000000000                        ,
      parameter            pf0_timer_mod_flow_control_en                                                                        =    "disable"                                ,
      parameter  [23:0]    pf0_tph_cap_tph_ext_cap_hdr_reg_addr_byte2                                                           =    24'b000000000000000111111010             ,
      parameter  [23:0]    pf0_tph_cap_tph_ext_cap_hdr_reg_addr_byte3                                                           =    24'b000000000000000111111011             ,
      parameter  [23:0]    pf0_tph_cap_tph_req_cap_reg_addr_byte0                                                               =    24'b000000000000000111111100             ,
      parameter  [23:0]    pf0_tph_cap_tph_req_cap_reg_addr_byte1                                                               =    24'b000000000000000111111101             ,
      parameter  [23:0]    pf0_tph_cap_tph_req_cap_reg_addr_byte2                                                               =    24'b000000000000000111111110             ,
      parameter  [23:0]    pf0_tph_cap_tph_req_cap_reg_addr_byte3                                                               =    24'b000000000000000111111111             ,
      parameter  [23:0]    pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte0                                                    =    24'b001000000000000111111100             ,
      parameter  [23:0]    pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte1                                                    =    24'b001000000000000111111101             ,
      parameter  [23:0]    pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte2                                                    =    24'b001000000000000111111110             ,
      parameter  [23:0]    pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte3                                                    =    24'b001000000000000111111111             ,
      parameter            pf0_tph_req_cap_int_vec                                                                              =    "disable"                                ,
      parameter            pf0_tph_req_cap_int_vec_vfcomm_cs2                                                                   =    "disable"                                ,
      parameter  [4:0]     pf0_tph_req_cap_reg_rsvdp_11                                                                         =    5'b00000                                 ,
      parameter  [4:0]     pf0_tph_req_cap_reg_rsvdp_27                                                                         =    5'b00000                                 ,
      parameter  [4:0]     pf0_tph_req_cap_reg_rsvdp_3                                                                          =    5'b00000                                 ,
      parameter  [4:0]     pf0_tph_req_cap_reg_vfcomm_cs2_rsvdp_11_vfcomm_cs2                                                   =    5'b00000                                 ,
      parameter  [4:0]     pf0_tph_req_cap_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                                                   =    5'b00000                                 ,
      parameter  [4:0]     pf0_tph_req_cap_reg_vfcomm_cs2_rsvdp_3_vfcomm_cs2                                                    =    5'b00000                                 ,
      parameter            pf0_tph_req_cap_st_table_loc_0                                                                       =    "pf0_not_in_tph_struct"                  ,
      parameter            pf0_tph_req_cap_st_table_loc_0_vfcomm_cs2                                                            =    "pf0_not_in_tph_struct_vf"               ,
      parameter            pf0_tph_req_cap_st_table_loc_1                                                                       =    "pf0_not_in_msix_table"                  ,
      parameter            pf0_tph_req_cap_st_table_loc_1_vfcomm_cs2                                                            =    "pf0_not_in_msix_table_vf"               ,
      parameter  [10:0]    pf0_tph_req_cap_st_table_size                                                                        =    11'b00000000001                          ,
      parameter  [10:0]    pf0_tph_req_cap_st_table_size_vfcomm_cs2                                                             =    11'b00000000001                          ,
      parameter  [3:0]     pf0_tph_req_cap_ver                                                                                  =    4'b0001                                  ,
      parameter            pf0_tph_req_device_spec                                                                              =    "disable"                                ,
      parameter            pf0_tph_req_device_spec_vfcomm_cs2                                                                   =    "disable"                                ,
      parameter            pf0_tph_req_extended_tph                                                                             =    "disable"                                ,
      parameter            pf0_tph_req_extended_tph_vfcomm_cs2                                                                  =    "disable"                                ,
      parameter  [11:0]    pf0_tph_req_next_ptr                                                                                 =    12'b001011011000                         ,
      parameter            pf0_tph_req_no_st_mode                                                                               =    "false"                                  ,
      parameter            pf0_tph_req_no_st_mode_vfcomm_cs2                                                                    =    "false"                                  ,
      parameter  [23:0]    pf0_type0_hdr_bar0_mask_reg_addr_byte0                                                               =    24'b001000000000000000010000             ,
      parameter  [23:0]    pf0_type0_hdr_bar0_mask_reg_addr_byte1                                                               =    24'b001000000000000000010001             ,
      parameter  [23:0]    pf0_type0_hdr_bar0_mask_reg_addr_byte2                                                               =    24'b001000000000000000010010             ,
      parameter  [23:0]    pf0_type0_hdr_bar0_mask_reg_addr_byte3                                                               =    24'b001000000000000000010011             ,
      parameter  [23:0]    pf0_type0_hdr_bar0_reg_addr_byte0                                                                    =    24'b000000000000000000010000             ,
      parameter  [23:0]    pf0_type0_hdr_bar1_enable_reg_addr_byte0                                                             =    24'b001000000000000000010100             ,
      parameter  [23:0]    pf0_type0_hdr_bar1_mask_reg_addr_byte0                                                               =    24'b001000000000000000010100             ,
      parameter  [23:0]    pf0_type0_hdr_bar1_mask_reg_addr_byte1                                                               =    24'b001000000000000000010101             ,
      parameter  [23:0]    pf0_type0_hdr_bar1_mask_reg_addr_byte2                                                               =    24'b001000000000000000010110             ,
      parameter  [23:0]    pf0_type0_hdr_bar1_mask_reg_addr_byte3                                                               =    24'b001000000000000000010111             ,
      parameter  [23:0]    pf0_type0_hdr_bar1_reg_addr_byte0                                                                    =    24'b000000000000000000010100             ,
      parameter  [23:0]    pf0_type0_hdr_bar2_mask_reg_addr_byte0                                                               =    24'b001000000000000000011000             ,
      parameter  [23:0]    pf0_type0_hdr_bar2_mask_reg_addr_byte1                                                               =    24'b001000000000000000011001             ,
      parameter  [23:0]    pf0_type0_hdr_bar2_mask_reg_addr_byte2                                                               =    24'b001000000000000000011010             ,
      parameter  [23:0]    pf0_type0_hdr_bar2_mask_reg_addr_byte3                                                               =    24'b001000000000000000011011             ,
      parameter  [23:0]    pf0_type0_hdr_bar2_reg_addr_byte0                                                                    =    24'b000000000000000000011000             ,
      parameter  [23:0]    pf0_type0_hdr_bar3_enable_reg_addr_byte0                                                             =    24'b001000000000000000011100             ,
      parameter  [23:0]    pf0_type0_hdr_bar3_mask_reg_addr_byte0                                                               =    24'b001000000000000000011100             ,
      parameter  [23:0]    pf0_type0_hdr_bar3_mask_reg_addr_byte1                                                               =    24'b001000000000000000011101             ,
      parameter  [23:0]    pf0_type0_hdr_bar3_mask_reg_addr_byte2                                                               =    24'b001000000000000000011110             ,
      parameter  [23:0]    pf0_type0_hdr_bar3_mask_reg_addr_byte3                                                               =    24'b001000000000000000011111             ,
      parameter  [23:0]    pf0_type0_hdr_bar3_reg_addr_byte0                                                                    =    24'b000000000000000000011100             ,
      parameter  [23:0]    pf0_type0_hdr_bar4_mask_reg_addr_byte0                                                               =    24'b001000000000000000100000             ,
      parameter  [23:0]    pf0_type0_hdr_bar4_mask_reg_addr_byte1                                                               =    24'b001000000000000000100001             ,
      parameter  [23:0]    pf0_type0_hdr_bar4_mask_reg_addr_byte2                                                               =    24'b001000000000000000100010             ,
      parameter  [23:0]    pf0_type0_hdr_bar4_mask_reg_addr_byte3                                                               =    24'b001000000000000000100011             ,
      parameter  [23:0]    pf0_type0_hdr_bar4_reg_addr_byte0                                                                    =    24'b000000000000000000100000             ,
      parameter  [23:0]    pf0_type0_hdr_bar5_enable_reg_addr_byte0                                                             =    24'b001000000000000000100100             ,
      parameter  [23:0]    pf0_type0_hdr_bar5_mask_reg_addr_byte0                                                               =    24'b001000000000000000100100             ,
      parameter  [23:0]    pf0_type0_hdr_bar5_mask_reg_addr_byte1                                                               =    24'b001000000000000000100101             ,
      parameter  [23:0]    pf0_type0_hdr_bar5_mask_reg_addr_byte2                                                               =    24'b001000000000000000100110             ,
      parameter  [23:0]    pf0_type0_hdr_bar5_mask_reg_addr_byte3                                                               =    24'b001000000000000000100111             ,
      parameter  [23:0]    pf0_type0_hdr_bar5_reg_addr_byte0                                                                    =    24'b000000000000000000100100             ,
      parameter  [23:0]    pf0_type0_hdr_bist_header_type_latency_cache_line_size_reg_addr_byte2                                =    24'b000000000000000000001110             ,
      parameter  [23:0]    pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte0                                                         =    24'b000000000000000000101000             ,
      parameter  [23:0]    pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte1                                                         =    24'b000000000000000000101001             ,
      parameter  [23:0]    pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte2                                                         =    24'b000000000000000000101010             ,
      parameter  [23:0]    pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte3                                                         =    24'b000000000000000000101011             ,
      parameter  [23:0]    pf0_type0_hdr_class_code_revision_id_addr_byte0                                                      =    24'b000000000000000000001000             ,
      parameter  [23:0]    pf0_type0_hdr_class_code_revision_id_addr_byte1                                                      =    24'b000000000000000000001001             ,
      parameter  [23:0]    pf0_type0_hdr_class_code_revision_id_addr_byte2                                                      =    24'b000000000000000000001010             ,
      parameter  [23:0]    pf0_type0_hdr_class_code_revision_id_addr_byte3                                                      =    24'b000000000000000000001011             ,
      parameter  [23:0]    pf0_type0_hdr_device_id_vendor_id_reg_addr_byte0                                                     =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf0_type0_hdr_device_id_vendor_id_reg_addr_byte1                                                     =    24'b000000000000000000000001             ,
      parameter  [23:0]    pf0_type0_hdr_device_id_vendor_id_reg_addr_byte2                                                     =    24'b000000000000000000000010             ,
      parameter  [23:0]    pf0_type0_hdr_device_id_vendor_id_reg_addr_byte3                                                     =    24'b000000000000000000000011             ,
      parameter  [23:0]    pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte0                                                        =    24'b001000000000000000110000             ,
      parameter  [23:0]    pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte1                                                        =    24'b001000000000000000110001             ,
      parameter  [23:0]    pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte2                                                        =    24'b001000000000000000110010             ,
      parameter  [23:0]    pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte3                                                        =    24'b001000000000000000110011             ,
      parameter  [23:0]    pf0_type0_hdr_exp_rom_base_addr_reg_addr_byte0                                                       =    24'b000000000000000000110000             ,
      parameter  [23:0]    pf0_type0_hdr_max_latency_min_grant_interrupt_pin_interrupt_line_reg_addr_byte1                      =    24'b000000000000000000111101             ,
      parameter  [23:0]    pf0_type0_hdr_pci_cap_ptr_reg_addr_byte0                                                             =    24'b000000000000000000110100             ,
      parameter  [23:0]    pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte0                                                     =    24'b001000000000000000111000             ,
      parameter  [23:0]    pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte1                                                     =    24'b001000000000000000111001             ,
      parameter  [23:0]    pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte2                                                     =    24'b001000000000000000111010             ,
      parameter  [23:0]    pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte3                                                     =    24'b001000000000000000111011             ,
      parameter  [23:0]    pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte0                                        =    24'b000000000000000000101100             ,
      parameter  [23:0]    pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte1                                        =    24'b000000000000000000101101             ,
      parameter  [23:0]    pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte2                                        =    24'b000000000000000000101110             ,
      parameter  [23:0]    pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte3                                        =    24'b000000000000000000101111             ,
      parameter  [2:0]     pf0_usp_rx_preset_hint0                                                                              =    3'b111                                   ,
      parameter  [2:0]     pf0_usp_rx_preset_hint1                                                                              =    3'b111                                   ,
      parameter  [2:0]     pf0_usp_rx_preset_hint10                                                                             =    3'b111                                   ,
      parameter  [2:0]     pf0_usp_rx_preset_hint11                                                                             =    3'b111                                   ,
      parameter  [2:0]     pf0_usp_rx_preset_hint12                                                                             =    3'b111                                   ,
      parameter  [2:0]     pf0_usp_rx_preset_hint13                                                                             =    3'b111                                   ,
      parameter  [2:0]     pf0_usp_rx_preset_hint14                                                                             =    3'b111                                   ,
      parameter  [2:0]     pf0_usp_rx_preset_hint15                                                                             =    3'b111                                   ,
      parameter  [2:0]     pf0_usp_rx_preset_hint2                                                                              =    3'b111                                   ,
      parameter  [2:0]     pf0_usp_rx_preset_hint3                                                                              =    3'b111                                   ,
      parameter  [2:0]     pf0_usp_rx_preset_hint4                                                                              =    3'b111                                   ,
      parameter  [2:0]     pf0_usp_rx_preset_hint5                                                                              =    3'b111                                   ,
      parameter  [2:0]     pf0_usp_rx_preset_hint6                                                                              =    3'b111                                   ,
      parameter  [2:0]     pf0_usp_rx_preset_hint7                                                                              =    3'b111                                   ,
      parameter  [2:0]     pf0_usp_rx_preset_hint8                                                                              =    3'b111                                   ,
      parameter  [2:0]     pf0_usp_rx_preset_hint9                                                                              =    3'b111                                   ,
      parameter  [3:0]     pf0_usp_tx_preset0                                                                                   =    4'b1111                                  ,
      parameter  [3:0]     pf0_usp_tx_preset1                                                                                   =    4'b1111                                  ,
      parameter  [3:0]     pf0_usp_tx_preset10                                                                                  =    4'b1111                                  ,
      parameter  [3:0]     pf0_usp_tx_preset11                                                                                  =    4'b1111                                  ,
      parameter  [3:0]     pf0_usp_tx_preset12                                                                                  =    4'b1111                                  ,
      parameter  [3:0]     pf0_usp_tx_preset13                                                                                  =    4'b1111                                  ,
      parameter  [3:0]     pf0_usp_tx_preset14                                                                                  =    4'b1111                                  ,
      parameter  [3:0]     pf0_usp_tx_preset15                                                                                  =    4'b1111                                  ,
      parameter  [3:0]     pf0_usp_tx_preset2                                                                                   =    4'b1111                                  ,
      parameter  [3:0]     pf0_usp_tx_preset3                                                                                   =    4'b1111                                  ,
      parameter  [3:0]     pf0_usp_tx_preset4                                                                                   =    4'b1111                                  ,
      parameter  [3:0]     pf0_usp_tx_preset5                                                                                   =    4'b1111                                  ,
      parameter  [3:0]     pf0_usp_tx_preset6                                                                                   =    4'b1111                                  ,
      parameter  [3:0]     pf0_usp_tx_preset7                                                                                   =    4'b1111                                  ,
      parameter  [3:0]     pf0_usp_tx_preset8                                                                                   =    4'b1111                                  ,
      parameter  [3:0]     pf0_usp_tx_preset9                                                                                   =    4'b1111                                  ,
      parameter  [11:0]    pf0_vc0_cpl_data_credit                                                                              =    12'b000000000000                         ,
      parameter  [7:0]     pf0_vc0_cpl_header_credit                                                                            =    8'b00000000                              ,
      parameter  [2:0]     pf0_vc0_cpl_tlp_q_mode                                                                               =    3'b001                                   ,
      parameter  [11:0]    pf0_vc0_np_data_credit                                                                               =    12'b000011100110                         ,
      parameter  [7:0]     pf0_vc0_np_header_credit                                                                             =    8'b01110011                              ,
      parameter  [2:0]     pf0_vc0_np_tlp_q_mode                                                                                =    3'b001                                   ,
      parameter  [11:0]    pf0_vc0_p_data_credit                                                                                =    12'b001011101110                         ,
      parameter  [7:0]     pf0_vc0_p_header_credit                                                                              =    8'b01111111                              ,
      parameter  [2:0]     pf0_vc0_p_tlp_q_mode                                                                                 =    3'b001                                   ,
      parameter  [23:0]    pf0_vc_cap_vc_base_addr_byte2                                                                        =    24'b000000000000000101001010             ,
      parameter  [23:0]    pf0_vc_cap_vc_base_addr_byte3                                                                        =    24'b000000000000000101001011             ,
      parameter  [3:0]     pf0_vc_cap_version                                                                                   =    4'b0001                                  ,
      parameter  [11:0]    pf0_vc_next_offset                                                                                   =    12'b000101101000                         ,
      parameter            pf0_vendor_specific_dllp_req                                                                         =    "false"                                  ,
      parameter            pf0_vf_bar0_reg_rsvdp_0                                                                              =    "false"                                  ,
      parameter            pf0_vf_bar1_reg_rsvdp_0                                                                              =    "false"                                  ,
      parameter            pf0_vf_bar2_reg_rsvdp_0                                                                              =    "false"                                  ,
      parameter            pf0_vf_bar3_reg_rsvdp_0                                                                              =    "false"                                  ,
      parameter            pf0_vf_bar4_reg_rsvdp_0                                                                              =    "false"                                  ,
      parameter            pf0_vf_bar5_reg_rsvdp_0                                                                              =    "false"                                  ,
      parameter            pf0_vf_forward_user_vsec                                                                             =    "false"                                  ,
      parameter  [23:0]    pf1_aer_cap_aer_ext_cap_hdr_off_addr_byte2                                                           =    24'b000000000001000100000010             ,
      parameter  [23:0]    pf1_aer_cap_aer_ext_cap_hdr_off_addr_byte3                                                           =    24'b000000000001000100000011             ,
      parameter  [3:0]     pf1_aer_cap_version                                                                                  =    4'b0010                                  ,
      parameter  [11:0]    pf1_aer_next_offset                                                                                  =    12'b000101001000                         ,
      parameter  [23:0]    pf1_ari_cap_ari_base_addr_byte2                                                                      =    24'b000000000001000101111010             ,
      parameter  [23:0]    pf1_ari_cap_ari_base_addr_byte3                                                                      =    24'b000000000001000101111011             ,
      parameter  [3:0]     pf1_ari_cap_version                                                                                  =    4'b0001                                  ,
      parameter  [11:0]    pf1_ari_next_offset                                                                                  =    12'b000110011000                         ,
      parameter  [23:0]    pf1_ats_cap_ats_cap_hdr_reg_addr_byte2                                                               =    24'b000000000001001010000110             ,
      parameter  [23:0]    pf1_ats_cap_ats_cap_hdr_reg_addr_byte3                                                               =    24'b000000000001001010000111             ,
      parameter  [23:0]    pf1_ats_cap_ats_capabilities_ctrl_reg_addr_byte0                                                     =    24'b000000000001001010001000             ,
      parameter  [3:0]     pf1_ats_cap_version                                                                                  =    4'b0001                                  ,
      parameter            pf1_ats_capabilities_ctrl_reg_rsvdp_7                                                                =    "false"                                  ,
      parameter  [11:0]    pf1_ats_next_offset                                                                                  =    12'b000000000000                         ,
      parameter  [2:0]     pf1_aux_curr                                                                                         =    3'b111                                   ,
      parameter            pf1_bar0_mem_io                                                                                      =    "pf1_bar0_mem"                           ,
      parameter            pf1_bar0_prefetch                                                                                    =    "false"                                  ,
      parameter  [3:0]     pf1_bar0_start                                                                                       =    4'b0000                                  ,
      parameter            pf1_bar0_type                                                                                        =    "pf1_bar0_mem32"                         ,
      parameter            pf1_bar1_mem_io                                                                                      =    "pf1_bar1_mem"                           ,
      parameter            pf1_bar1_prefetch                                                                                    =    "false"                                  ,
      parameter  [3:0]     pf1_bar1_start                                                                                       =    4'b0000                                  ,
      parameter            pf1_bar1_type                                                                                        =    "pf1_bar1_mem32"                         ,
      parameter            pf1_bar2_mem_io                                                                                      =    "pf1_bar2_mem"                           ,
      parameter            pf1_bar2_prefetch                                                                                    =    "false"                                  ,
      parameter  [3:0]     pf1_bar2_start                                                                                       =    4'b0000                                  ,
      parameter            pf1_bar2_type                                                                                        =    "pf1_bar2_mem32"                         ,
      parameter            pf1_bar3_mem_io                                                                                      =    "pf1_bar3_mem"                           ,
      parameter            pf1_bar3_prefetch                                                                                    =    "false"                                  ,
      parameter  [3:0]     pf1_bar3_start                                                                                       =    4'b0000                                  ,
      parameter            pf1_bar3_type                                                                                        =    "pf1_bar3_mem32"                         ,
      parameter            pf1_bar4_mem_io                                                                                      =    "pf1_bar4_mem"                           ,
      parameter            pf1_bar4_prefetch                                                                                    =    "false"                                  ,
      parameter  [3:0]     pf1_bar4_start                                                                                       =    4'b0000                                  ,
      parameter            pf1_bar4_type                                                                                        =    "pf1_bar4_mem32"                         ,
      parameter            pf1_bar5_mem_io                                                                                      =    "pf1_bar5_mem"                           ,
      parameter            pf1_bar5_prefetch                                                                                    =    "false"                                  ,
      parameter  [3:0]     pf1_bar5_start                                                                                       =    4'b0000                                  ,
      parameter            pf1_bar5_type                                                                                        =    "pf1_bar5_mem32"                         ,
      parameter  [7:0]     pf1_base_class_code                                                                                  =    8'b00000000                              ,
      parameter            pf1_cap_id_nxt_ptr_reg_rsvdp_20                                                                      =    "false"                                  ,
      parameter  [7:0]     pf1_cap_pointer                                                                                      =    8'b01000000                              ,
      parameter  [31:0]    pf1_cardbus_cis_pointer                                                                              =    32'b00000000000000000000000000000000     ,
      parameter            pf1_con_status_reg_rsvdp_2                                                                           =    "false"                                  ,
      parameter  [3:0]     pf1_con_status_reg_rsvdp_4                                                                           =    4'b0000                                  ,
      parameter            pf1_d1_support                                                                                       =    "pf1_d1_not_supported"                   ,
      parameter            pf1_d2_support                                                                                       =    "pf1_d2_not_supported"                   ,
      parameter  [7:0]     pf1_dbi_reserved_0                                                                                   =    8'b00000000                              ,
      parameter  [7:0]     pf1_dbi_reserved_1                                                                                   =    8'b00000000                              ,
      parameter  [7:0]     pf1_dbi_reserved_10                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf1_dbi_reserved_11                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf1_dbi_reserved_12                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf1_dbi_reserved_13                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf1_dbi_reserved_14                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf1_dbi_reserved_15                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf1_dbi_reserved_16                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf1_dbi_reserved_17                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf1_dbi_reserved_18                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf1_dbi_reserved_19                                                                                  =    8'b00000000                              ,
      parameter  [7:0]     pf1_dbi_reserved_2                                                                                   =    8'b00000000                              ,
      parameter  [7:0]     pf1_dbi_reserved_3                                                                                   =    8'b00000000                              ,
      parameter  [7:0]     pf1_dbi_reserved_4                                                                                   =    8'b00000000                              ,
      parameter  [7:0]     pf1_dbi_reserved_5                                                                                   =    8'b00000000                              ,
      parameter  [7:0]     pf1_dbi_reserved_6                                                                                   =    8'b00000000                              ,
      parameter  [7:0]     pf1_dbi_reserved_7                                                                                   =    8'b00000000                              ,
      parameter  [7:0]     pf1_dbi_reserved_8                                                                                   =    8'b00000000                              ,
      parameter  [7:0]     pf1_dbi_reserved_9                                                                                   =    8'b00000000                              ,
      parameter  [2:0]     pf1_device_capabilities_reg_rsvdp_12                                                                 =    3'b000                                   ,
      parameter  [3:0]     pf1_device_capabilities_reg_rsvdp_16                                                                 =    4'b0000                                  ,
      parameter  [2:0]     pf1_device_capabilities_reg_rsvdp_29                                                                 =    3'b000                                   ,
      parameter            pf1_dsi                                                                                              =    "pf1_not_required"                       ,
      parameter  [9:0]     pf1_exp_rom_bar_mask_reg_rsvdp_1                                                                     =    10'b0000000000                           ,
      parameter  [6:0]     pf1_exp_rom_base_addr_reg_rsvdp_1                                                                    =    7'b0000000                               ,
      parameter            pf1_forward_user_vsec                                                                                =    "false"                                  ,
      parameter            pf1_global_inval_spprtd                                                                              =    "false"                                  ,
      parameter  [6:0]     pf1_header_type                                                                                      =    7'b0000000                               ,
      parameter            pf1_int_pin                                                                                          =    "pf1_inta"                               ,
      parameter  [4:0]     pf1_invalidate_q_depth                                                                               =    5'b00000                                 ,
      parameter            pf1_link_capabilities_reg_rsvdp_23                                                                   =    "false"                                  ,
      parameter  [3:0]     pf1_link_control_link_status_reg_rsvdp_12                                                            =    4'b0000                                  ,
      parameter            pf1_link_control_link_status_reg_rsvdp_2                                                             =    "false"                                  ,
      parameter  [1:0]     pf1_link_control_link_status_reg_rsvdp_25                                                            =    2'b00                                    ,
      parameter            pf1_link_control_link_status_reg_rsvdp_9                                                             =    "false"                                  ,
      parameter  [23:0]    pf1_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte1                                                  =    24'b000000000001000001010001             ,
      parameter  [23:0]    pf1_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte2                                                  =    24'b000000000001000001010010             ,
      parameter  [23:0]    pf1_msix_cap_msix_pba_offset_reg_addr_byte0                                                          =    24'b000000000001000010111000             ,
      parameter  [23:0]    pf1_msix_cap_msix_pba_offset_reg_addr_byte1                                                          =    24'b000000000001000010111001             ,
      parameter  [23:0]    pf1_msix_cap_msix_pba_offset_reg_addr_byte2                                                          =    24'b000000000001000010111010             ,
      parameter  [23:0]    pf1_msix_cap_msix_pba_offset_reg_addr_byte3                                                          =    24'b000000000001000010111011             ,
      parameter  [23:0]    pf1_msix_cap_msix_table_offset_reg_addr_byte0                                                        =    24'b000000000001000010110100             ,
      parameter  [23:0]    pf1_msix_cap_msix_table_offset_reg_addr_byte1                                                        =    24'b000000000001000010110101             ,
      parameter  [23:0]    pf1_msix_cap_msix_table_offset_reg_addr_byte2                                                        =    24'b000000000001000010110110             ,
      parameter  [23:0]    pf1_msix_cap_msix_table_offset_reg_addr_byte3                                                        =    24'b000000000001000010110111             ,
      parameter  [23:0]    pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte1                                                =    24'b000000000001000010110001             ,
      parameter  [23:0]    pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte2                                                =    24'b000000000001000010110010             ,
      parameter  [23:0]    pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte3                                                =    24'b000000000001000010110011             ,
      parameter  [23:0]    pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte2                                     =    24'b001000000001000010110010             ,
      parameter  [23:0]    pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte3                                     =    24'b001000000001000010110011             ,
      parameter            pf1_multi_func                                                                                       =    "true"                                   ,
      parameter            pf1_no_soft_rst                                                                                      =    "pf1_internally_reset"                   ,
      parameter            pf1_page_aligned_req                                                                                 =    "true"                                   ,
      parameter            pf1_pci_msi_64_bit_addr_cap                                                                          =    "true"                                   ,
      parameter  [7:0]     pf1_pci_msi_cap_next_offset                                                                          =    8'b01110000                              ,
      parameter            pf1_pci_msi_enable                                                                                   =    "false"                                  ,
      parameter            pf1_pci_msi_multiple_msg_cap                                                                         =    "pf1_msi_vec_32_pf1"                     ,
      parameter  [2:0]     pf1_pci_msi_multiple_msg_en                                                                          =    3'b000                                   ,
      parameter  [2:0]     pf1_pci_msix_bir                                                                                     =    3'b000                                   ,
      parameter  [2:0]     pf1_pci_msix_cap_id_next_ctrl_reg_rsvdp_27                                                           =    3'b000                                   ,
      parameter  [2:0]     pf1_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                                     =    3'b000                                   ,
      parameter  [7:0]     pf1_pci_msix_cap_next_offset                                                                         =    8'b00000000                              ,
      parameter            pf1_pci_msix_enable                                                                                  =    "false"                                  ,
      parameter            pf1_pci_msix_enable_vfcomm_cs2                                                                       =    "false"                                  ,
      parameter            pf1_pci_msix_function_mask                                                                           =    "false"                                  ,
      parameter            pf1_pci_msix_function_mask_vfcomm_cs2                                                                =    "false"                                  ,
      parameter  [2:0]     pf1_pci_msix_pba                                                                                     =    3'b000                                   ,
      parameter  [28:0]    pf1_pci_msix_pba_offset                                                                              =    29'b00000000000000000000000000000        ,
      parameter  [28:0]    pf1_pci_msix_table_offset                                                                            =    29'b00000000000000000000000000000        ,
      parameter  [10:0]    pf1_pci_msix_table_size                                                                              =    11'b00011111111                          ,
      parameter  [10:0]    pf1_pci_msix_table_size_vfcomm_cs2                                                                   =    11'b00000000000                          ,
      parameter            pf1_pci_type0_bar0_enabled                                                                           =    "enable"                                 ,
      parameter  [30:0]    pf1_pci_type0_bar0_mask_31_1                                                                         =    31'b1111111111111111111111111111111      ,
      parameter  [6:0]     pf1_pci_type0_bar1_dummy_mask_7_1                                                                    =    7'b1111111                               ,
      parameter            pf1_pci_type0_bar1_enabled                                                                           =    "enable"                                 ,
      parameter            pf1_pci_type0_bar1_enabled_or_mask64lsb                                                              =    "disable"                                ,
      parameter  [30:0]    pf1_pci_type0_bar1_mask_31_1                                                                         =    31'b1111111111111111111111111111111      ,
      parameter            pf1_pci_type0_bar2_enabled                                                                           =    "enable"                                 ,
      parameter  [30:0]    pf1_pci_type0_bar2_mask_31_1                                                                         =    31'b1111111111111111111111111111111      ,
      parameter  [6:0]     pf1_pci_type0_bar3_dummy_mask_7_1                                                                    =    7'b1111111                               ,
      parameter            pf1_pci_type0_bar3_enabled                                                                           =    "enable"                                 ,
      parameter            pf1_pci_type0_bar3_enabled_or_mask64lsb                                                              =    "disable"                                ,
      parameter  [30:0]    pf1_pci_type0_bar3_mask_31_1                                                                         =    31'b1111111111111111111111111111111      ,
      parameter            pf1_pci_type0_bar4_enabled                                                                           =    "enable"                                 ,
      parameter  [30:0]    pf1_pci_type0_bar4_mask_31_1                                                                         =    31'b1111111111111111111111111111111      ,
      parameter  [6:0]     pf1_pci_type0_bar5_dummy_mask_7_1                                                                    =    7'b1111111                               ,
      parameter            pf1_pci_type0_bar5_enabled                                                                           =    "enable"                                 ,
      parameter            pf1_pci_type0_bar5_enabled_or_mask64lsb                                                              =    "disable"                                ,
      parameter  [30:0]    pf1_pci_type0_bar5_mask_31_1                                                                         =    31'b1111111111111111111111111111111      ,
      parameter  [15:0]    pf1_pci_type0_device_id                                                                              =    16'b1010101111001101                     ,
      parameter  [15:0]    pf1_pci_type0_vendor_id                                                                              =    16'b0001011011000011                     ,
      parameter            pf1_pcie_cap_active_state_link_pm_control                                                            =    "pf1_aspm_dis"                           ,
      parameter            pf1_pcie_cap_active_state_link_pm_support                                                            =    "pf1_no_aspm"                            ,
      parameter            pf1_pcie_cap_aspm_opt_compliance                                                                     =    "true"                                   ,
      parameter            pf1_pcie_cap_aux_power_pm_en                                                                         =    "false"                                  ,
      parameter            pf1_pcie_cap_clock_power_man                                                                         =    "pf1_refclk_remove_not_ok"               ,
      parameter            pf1_pcie_cap_common_clk_config                                                                       =    "false"                                  ,
      parameter  [23:0]    pf1_pcie_cap_device_capabilities_reg_addr_byte0                                                      =    24'b000000000001000001110100             ,
      parameter  [23:0]    pf1_pcie_cap_device_capabilities_reg_addr_byte1                                                      =    24'b000000000001000001110101             ,
      parameter  [23:0]    pf1_pcie_cap_device_capabilities_reg_addr_byte2                                                      =    24'b000000000001000001110110             ,
      parameter  [23:0]    pf1_pcie_cap_device_control_device_status_addr_byte1                                                 =    24'b000000000001000001111001             ,
      parameter            pf1_pcie_cap_dll_active                                                                              =    "false"                                  ,
      parameter            pf1_pcie_cap_dll_active_rep_cap                                                                      =    "false"                                  ,
      parameter            pf1_pcie_cap_en_clk_power_man                                                                        =    "pf1_clkreq_dis"                         ,
      parameter            pf1_pcie_cap_en_no_snoop                                                                             =    "false"                                  ,
      parameter            pf1_pcie_cap_enter_compliance                                                                        =    "false"                                  ,
      parameter  [2:0]     pf1_pcie_cap_ep_l0s_accpt_latency                                                                    =    3'b000                                   ,
      parameter  [2:0]     pf1_pcie_cap_ep_l1_accpt_latency                                                                     =    3'b000                                   ,
      parameter            pf1_pcie_cap_ext_tag_en                                                                              =    "false"                                  ,
      parameter            pf1_pcie_cap_ext_tag_supp                                                                            =    "pf1_supported"                          ,
      parameter            pf1_pcie_cap_extended_synch                                                                          =    "false"                                  ,
      parameter            pf1_pcie_cap_flr_cap                                                                                 =    "pf1_capable"                            ,
      parameter            pf1_pcie_cap_hw_auto_speed_disable                                                                   =    "false"                                  ,
      parameter            pf1_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvd                                                  =    "false"                                  ,
      parameter            pf1_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvdp_31                                              =    "false"                                  ,
      parameter            pf1_pcie_cap_initiate_flr                                                                            =    "false"                                  ,
      parameter  [2:0]     pf1_pcie_cap_l0s_exit_latency_commclk_dis                                                            =    3'b111                                   ,
      parameter  [2:0]     pf1_pcie_cap_l0s_exit_latency_commclk_ena_cs2                                                        =    3'b111                                   ,
      parameter  [2:0]     pf1_pcie_cap_l1_exit_latency_commclk_dis                                                             =    3'b111                                   ,
      parameter  [2:0]     pf1_pcie_cap_l1_exit_latency_commclk_ena_cs2                                                         =    3'b111                                   ,
      parameter            pf1_pcie_cap_link_auto_bw_int_en                                                                     =    "false"                                  ,
      parameter            pf1_pcie_cap_link_auto_bw_status                                                                     =    "false"                                  ,
      parameter            pf1_pcie_cap_link_bw_man_int_en                                                                      =    "false"                                  ,
      parameter            pf1_pcie_cap_link_bw_man_status                                                                      =    "false"                                  ,
      parameter            pf1_pcie_cap_link_bw_not_cap                                                                         =    "false"                                  ,
      parameter  [23:0]    pf1_pcie_cap_link_capabilities_reg_addr_byte0                                                        =    24'b000000000001000001111100             ,
      parameter  [23:0]    pf1_pcie_cap_link_capabilities_reg_addr_byte1                                                        =    24'b000000000001000001111101             ,
      parameter  [23:0]    pf1_pcie_cap_link_capabilities_reg_addr_byte2                                                        =    24'b000000000001000001111110             ,
      parameter  [23:0]    pf1_pcie_cap_link_capabilities_reg_addr_byte3                                                        =    24'b000000000001000001111111             ,
      parameter  [23:0]    pf1_pcie_cap_link_control2_link_status2_reg_addr_byte0                                               =    24'b010000000001000010100000             ,
      parameter  [23:0]    pf1_pcie_cap_link_control_link_status_reg_addr_byte0                                                 =    24'b010000000001000010000000             ,
      parameter  [23:0]    pf1_pcie_cap_link_control_link_status_reg_addr_byte1                                                 =    24'b010000000001000010000001             ,
      parameter  [23:0]    pf1_pcie_cap_link_control_link_status_reg_addr_byte2                                                 =    24'b010000000001000010000010             ,
      parameter            pf1_pcie_cap_link_disable                                                                            =    "false"                                  ,
      parameter            pf1_pcie_cap_link_training                                                                           =    "false"                                  ,
      parameter            pf1_pcie_cap_max_link_speed                                                                          =    "pf1_max_8gts"                           ,
      parameter            pf1_pcie_cap_max_link_width                                                                          =    "pf1_x16"                                ,
      parameter            pf1_pcie_cap_max_payload_size                                                                        =    "pf1_payload_1024"                       ,
      parameter  [2:0]     pf1_pcie_cap_max_read_req_size                                                                       =    3'b000                                   ,
      parameter            pf1_pcie_cap_nego_link_width                                                                         =    "false"                                  ,
      parameter  [7:0]     pf1_pcie_cap_next_ptr                                                                                =    8'b10110000                              ,
      parameter  [23:0]    pf1_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte1                                   =    24'b000000000001000001110001             ,
      parameter  [23:0]    pf1_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte3                                   =    24'b000000000001000001110011             ,
      parameter            pf1_pcie_cap_phantom_func_en                                                                         =    "false"                                  ,
      parameter  [1:0]     pf1_pcie_cap_phantom_func_support                                                                    =    2'b00                                    ,
      parameter  [7:0]     pf1_pcie_cap_port_num                                                                                =    8'b00000000                              ,
      parameter            pf1_pcie_cap_rcb                                                                                     =    "pf1_rcb_64"                             ,
      parameter            pf1_pcie_cap_retrain_link                                                                            =    "false"                                  ,
      parameter            pf1_pcie_cap_role_based_err_report                                                                   =    "false"                                  ,
      parameter            pf1_pcie_cap_sel_deemphasis                                                                          =    "pf1_minus_6db"                          ,
      parameter  [23:0]    pf1_pcie_cap_shadow_link_capabilities_reg_addr_byte0                                                 =    24'b001000000001000001111100             ,
      parameter  [23:0]    pf1_pcie_cap_shadow_link_capabilities_reg_addr_byte1                                                 =    24'b001000000001000001111101             ,
      parameter            pf1_pcie_cap_slot_clk_config                                                                         =    "false"                                  ,
      parameter            pf1_pcie_cap_surprise_down_err_rep_cap                                                               =    "false"                                  ,
      parameter            pf1_pcie_cap_target_link_speed                                                                       =    "pf1_trgt_gen3"                          ,
      parameter            pf1_pcie_cap_tx_margin                                                                               =    "false"                                  ,
      parameter  [4:0]     pf1_pcie_int_msg_num                                                                                 =    5'b00000                                 ,
      parameter            pf1_pcie_slot_imp                                                                                    =    "pf1_not_implemented"                    ,
      parameter  [23:0]    pf1_pm_cap_cap_id_nxt_ptr_reg_addr_byte1                                                             =    24'b000000000001000001000001             ,
      parameter  [23:0]    pf1_pm_cap_cap_id_nxt_ptr_reg_addr_byte2                                                             =    24'b000000000001000001000010             ,
      parameter  [23:0]    pf1_pm_cap_cap_id_nxt_ptr_reg_addr_byte3                                                             =    24'b000000000001000001000011             ,
      parameter  [23:0]    pf1_pm_cap_con_status_reg_addr_byte0                                                                 =    24'b000000000001000001000100             ,
      parameter  [7:0]     pf1_pm_next_pointer                                                                                  =    8'b01010000                              ,
      parameter  [2:0]     pf1_pm_spec_ver                                                                                      =    3'b011                                   ,
      parameter            pf1_pme_clk                                                                                          =    "false"                                  ,
      parameter  [4:0]     pf1_pme_support                                                                                      =    5'b11011                                 ,
      parameter  [1:0]     pf1_power_state                                                                                      =    2'b00                                    ,
      parameter  [7:0]     pf1_program_interface                                                                                =    8'b00000000                              ,
      parameter  [23:0]    pf1_reserved_0_addr                                                                                  =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf1_reserved_10_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf1_reserved_11_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf1_reserved_12_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf1_reserved_13_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf1_reserved_14_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf1_reserved_15_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf1_reserved_16_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf1_reserved_17_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf1_reserved_18_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf1_reserved_19_addr                                                                                 =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf1_reserved_1_addr                                                                                  =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf1_reserved_2_addr                                                                                  =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf1_reserved_3_addr                                                                                  =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf1_reserved_4_addr                                                                                  =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf1_reserved_5_addr                                                                                  =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf1_reserved_6_addr                                                                                  =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf1_reserved_7_addr                                                                                  =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf1_reserved_8_addr                                                                                  =    24'b000000000000000000000000             ,
      parameter  [23:0]    pf1_reserved_9_addr                                                                                  =    24'b000000000000000000000000             ,
      parameter  [7:0]     pf1_revision_id                                                                                      =    8'b00000001                              ,
      parameter            pf1_rom_bar_enable                                                                                   =    "disable"                                ,
      parameter            pf1_rom_bar_enabled                                                                                  =    "enable"                                 ,
      parameter  [20:0]    pf1_rom_mask                                                                                         =    21'b000001111111111111111                ,
      parameter            pf1_shadow_link_capabilities_reg_shadow_rsvdp_23                                                     =    "false"                                  ,
      parameter  [1:0]     pf1_shadow_pcie_cap_active_state_link_pm_support                                                     =    2'b00                                    ,
      parameter            pf1_shadow_pcie_cap_aspm_opt_compliance                                                              =    "false"                                  ,
      parameter            pf1_shadow_pcie_cap_clock_power_man                                                                  =    "false"                                  ,
      parameter            pf1_shadow_pcie_cap_dll_active_rep_cap                                                               =    "false"                                  ,
      parameter            pf1_shadow_pcie_cap_link_bw_not_cap                                                                  =    "false"                                  ,
      parameter  [1:0]     pf1_shadow_pcie_cap_max_link_width                                                                   =    2'b00                                    ,
      parameter            pf1_shadow_pcie_cap_surprise_down_err_rep_cap                                                        =    "false"                                  ,
      parameter  [15:0]    pf1_shadow_sriov_vf_stride_ari_cs2                                                                   =    16'b0000000000000010                     ,
      parameter  [23:0]    pf1_sn_cap_ser_num_reg_dw_1_addr_byte0                                                               =    24'b000000000001000101101100             ,
      parameter  [23:0]    pf1_sn_cap_ser_num_reg_dw_1_addr_byte1                                                               =    24'b000000000001000101101101             ,
      parameter  [23:0]    pf1_sn_cap_ser_num_reg_dw_1_addr_byte2                                                               =    24'b000000000001000101101110             ,
      parameter  [23:0]    pf1_sn_cap_ser_num_reg_dw_1_addr_byte3                                                               =    24'b000000000001000101101111             ,
      parameter  [23:0]    pf1_sn_cap_ser_num_reg_dw_2_addr_byte0                                                               =    24'b000000000001000101110000             ,
      parameter  [23:0]    pf1_sn_cap_ser_num_reg_dw_2_addr_byte1                                                               =    24'b000000000001000101110001             ,
      parameter  [23:0]    pf1_sn_cap_ser_num_reg_dw_2_addr_byte2                                                               =    24'b000000000001000101110010             ,
      parameter  [23:0]    pf1_sn_cap_ser_num_reg_dw_2_addr_byte3                                                               =    24'b000000000001000101110011             ,
      parameter  [23:0]    pf1_sn_cap_sn_base_addr_byte2                                                                        =    24'b000000000001000101101010             ,
      parameter  [23:0]    pf1_sn_cap_sn_base_addr_byte3                                                                        =    24'b000000000001000101101011             ,
      parameter  [3:0]     pf1_sn_cap_version                                                                                   =    4'b0001                                  ,
      parameter  [11:0]    pf1_sn_next_offset                                                                                   =    12'b000101111000                         ,
      parameter  [31:0]    pf1_sn_ser_num_reg_1_dw                                                                              =    32'b00000000000000000000000000000000     ,
      parameter  [31:0]    pf1_sn_ser_num_reg_2_dw                                                                              =    32'b00000000000000000000000000000000     ,
      parameter  [23:0]    pf1_sriov_cap_shadow_sriov_initial_vfs_addr_byte0                                                    =    24'b001000000001000111000100             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_sriov_initial_vfs_addr_byte1                                                    =    24'b001000000001000111000101             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte0                                             =    24'b001000000001000111001100             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte1                                             =    24'b001000000001000111001101             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte2                                             =    24'b001000000001000111001110             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte3                                             =    24'b001000000001000111001111             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte0                                                          =    24'b001000000001000111011100             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte1                                                          =    24'b001000000001000111011101             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte2                                                          =    24'b001000000001000111011110             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte3                                                          =    24'b001000000001000111011111             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte0                                                          =    24'b001000000001000111100000             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte1                                                          =    24'b001000000001000111100001             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte2                                                          =    24'b001000000001000111100010             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte3                                                          =    24'b001000000001000111100011             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte0                                                          =    24'b001000000001000111100100             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte1                                                          =    24'b001000000001000111100101             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte2                                                          =    24'b001000000001000111100110             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte3                                                          =    24'b001000000001000111100111             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte0                                                          =    24'b001000000001000111101000             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte1                                                          =    24'b001000000001000111101001             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte2                                                          =    24'b001000000001000111101010             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte3                                                          =    24'b001000000001000111101011             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte0                                                          =    24'b001000000001000111101100             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte1                                                          =    24'b001000000001000111101101             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte2                                                          =    24'b001000000001000111101110             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte3                                                          =    24'b001000000001000111101111             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte0                                                          =    24'b001000000001000111110000             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte1                                                          =    24'b001000000001000111110001             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte2                                                          =    24'b001000000001000111110010             ,
      parameter  [23:0]    pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte3                                                          =    24'b001000000001000111110011             ,
      parameter  [23:0]    pf1_sriov_cap_sriov_bar1_enable_reg_addr_byte0                                                       =    24'b001000000001000111100000             ,
      parameter  [23:0]    pf1_sriov_cap_sriov_bar3_enable_reg_addr_byte0                                                       =    24'b001000000001000111101000             ,
      parameter  [23:0]    pf1_sriov_cap_sriov_bar5_enable_reg_addr_byte0                                                       =    24'b001000000001000111110000             ,
      parameter  [23:0]    pf1_sriov_cap_sriov_base_reg_addr_byte2                                                              =    24'b000000000001000110111010             ,
      parameter  [23:0]    pf1_sriov_cap_sriov_base_reg_addr_byte3                                                              =    24'b000000000001000110111011             ,
      parameter  [23:0]    pf1_sriov_cap_sriov_initial_vfs_addr_byte0                                                           =    24'b000000000001000111000100             ,
      parameter  [23:0]    pf1_sriov_cap_sriov_initial_vfs_addr_byte1                                                           =    24'b000000000001000111000101             ,
      parameter  [23:0]    pf1_sriov_cap_sriov_vf_offset_position_addr_byte0                                                    =    24'b000000000001000111001100             ,
      parameter  [23:0]    pf1_sriov_cap_sriov_vf_offset_position_addr_byte1                                                    =    24'b000000000001000111001101             ,
      parameter  [23:0]    pf1_sriov_cap_sriov_vf_offset_position_addr_byte2                                                    =    24'b000000000001000111001110             ,
      parameter  [23:0]    pf1_sriov_cap_sriov_vf_offset_position_addr_byte3                                                    =    24'b000000000001000111001111             ,
      parameter  [23:0]    pf1_sriov_cap_sup_page_sizes_reg_addr_byte0                                                          =    24'b000000000001000111010100             ,
      parameter  [23:0]    pf1_sriov_cap_sup_page_sizes_reg_addr_byte1                                                          =    24'b000000000001000111010101             ,
      parameter  [23:0]    pf1_sriov_cap_sup_page_sizes_reg_addr_byte2                                                          =    24'b000000000001000111010110             ,
      parameter  [23:0]    pf1_sriov_cap_sup_page_sizes_reg_addr_byte3                                                          =    24'b000000000001000111010111             ,
      parameter  [3:0]     pf1_sriov_cap_version                                                                                =    4'b0001                                  ,
      parameter  [23:0]    pf1_sriov_cap_vf_bar0_reg_addr_byte0                                                                 =    24'b000000000001000111011100             ,
      parameter  [23:0]    pf1_sriov_cap_vf_bar1_reg_addr_byte0                                                                 =    24'b000000000001000111100000             ,
      parameter  [23:0]    pf1_sriov_cap_vf_bar2_reg_addr_byte0                                                                 =    24'b000000000001000111100100             ,
      parameter  [23:0]    pf1_sriov_cap_vf_bar3_reg_addr_byte0                                                                 =    24'b000000000001000111101000             ,
      parameter  [23:0]    pf1_sriov_cap_vf_bar4_reg_addr_byte0                                                                 =    24'b000000000001000111101100             ,
      parameter  [23:0]    pf1_sriov_cap_vf_bar5_reg_addr_byte0                                                                 =    24'b000000000001000111110000             ,
      parameter  [23:0]    pf1_sriov_cap_vf_device_id_reg_addr_byte2                                                            =    24'b000000000001000111010010             ,
      parameter  [23:0]    pf1_sriov_cap_vf_device_id_reg_addr_byte3                                                            =    24'b000000000001000111010011             ,
      parameter  [15:0]    pf1_sriov_initial_vfs_ari_cs2                                                                        =    16'b0000000001000000                     ,
      parameter  [15:0]    pf1_sriov_initial_vfs_nonari                                                                         =    16'b0000000001000000                     ,
      parameter  [11:0]    pf1_sriov_next_offset                                                                                =    12'b001001111000                         ,
      parameter  [31:0]    pf1_sriov_sup_page_size                                                                              =    32'b00000000000000000000010101010011     ,
      parameter  [31:0]    pf1_sriov_vf_bar0_mask                                                                               =    32'b00000000000000000000000000000000     ,
      parameter            pf1_sriov_vf_bar0_prefetch                                                                           =    "false"                                  ,
      parameter  [3:0]     pf1_sriov_vf_bar0_start                                                                              =    4'b0000                                  ,
      parameter            pf1_sriov_vf_bar0_type                                                                               =    "pf1_sriov_vf_bar0_mem32"                ,
      parameter  [6:0]     pf1_sriov_vf_bar1_dummy_mask_7_1                                                                     =    7'b1111111                               ,
      parameter            pf1_sriov_vf_bar1_enabled                                                                            =    "enable"                                 ,
      parameter  [31:0]    pf1_sriov_vf_bar1_mask                                                                               =    32'b00000000000000000000000000000000     ,
      parameter            pf1_sriov_vf_bar1_prefetch                                                                           =    "false"                                  ,
      parameter  [3:0]     pf1_sriov_vf_bar1_start                                                                              =    4'b0000                                  ,
      parameter            pf1_sriov_vf_bar1_type                                                                               =    "pf1_sriov_vf_bar1_mem32"                ,
      parameter  [31:0]    pf1_sriov_vf_bar2_mask                                                                               =    32'b00000000000000000000000000000000     ,
      parameter            pf1_sriov_vf_bar2_prefetch                                                                           =    "false"                                  ,
      parameter  [3:0]     pf1_sriov_vf_bar2_start                                                                              =    4'b0000                                  ,
      parameter            pf1_sriov_vf_bar2_type                                                                               =    "pf1_sriov_vf_bar2_mem32"                ,
      parameter  [6:0]     pf1_sriov_vf_bar3_dummy_mask_7_1                                                                     =    7'b1111111                               ,
      parameter            pf1_sriov_vf_bar3_enabled                                                                            =    "enable"                                 ,
      parameter  [31:0]    pf1_sriov_vf_bar3_mask                                                                               =    32'b00000000000000000000000000000000     ,
      parameter            pf1_sriov_vf_bar3_prefetch                                                                           =    "false"                                  ,
      parameter  [3:0]     pf1_sriov_vf_bar3_start                                                                              =    4'b0000                                  ,
      parameter            pf1_sriov_vf_bar3_type                                                                               =    "pf1_sriov_vf_bar3_mem32"                ,
      parameter  [31:0]    pf1_sriov_vf_bar4_mask                                                                               =    32'b00000000000000000000000000000000     ,
      parameter            pf1_sriov_vf_bar4_prefetch                                                                           =    "false"                                  ,
      parameter  [3:0]     pf1_sriov_vf_bar4_start                                                                              =    4'b0000                                  ,
      parameter            pf1_sriov_vf_bar4_type                                                                               =    "pf1_sriov_vf_bar4_mem32"                ,
      parameter  [6:0]     pf1_sriov_vf_bar5_dummy_mask_7_1                                                                     =    7'b1111111                               ,
      parameter            pf1_sriov_vf_bar5_enabled                                                                            =    "enable"                                 ,
      parameter  [31:0]    pf1_sriov_vf_bar5_mask                                                                               =    32'b00000000000000000000000000000000     ,
      parameter            pf1_sriov_vf_bar5_prefetch                                                                           =    "false"                                  ,
      parameter  [3:0]     pf1_sriov_vf_bar5_start                                                                              =    4'b0000                                  ,
      parameter            pf1_sriov_vf_bar5_type                                                                               =    "pf1_sriov_vf_bar5_mem32"                ,
      parameter  [15:0]    pf1_sriov_vf_device_id                                                                               =    16'b1010101111001101                     ,
      parameter  [15:0]    pf1_sriov_vf_offset_ari_cs2                                                                          =    16'b0000000000000010                     ,
      parameter  [15:0]    pf1_sriov_vf_offset_position_nonari                                                                  =    16'b0000000100000000                     ,
      parameter  [15:0]    pf1_sriov_vf_stride_nonari                                                                           =    16'b0000000100000000                     ,
      parameter  [7:0]     pf1_subclass_code                                                                                    =    8'b00000000                              ,
      parameter  [15:0]    pf1_subsys_dev_id                                                                                    =    16'b0000000000000000                     ,
      parameter  [15:0]    pf1_subsys_vendor_id                                                                                 =    16'b0000000000000000                     ,
      parameter  [23:0]    pf1_tph_cap_tph_ext_cap_hdr_reg_addr_byte2                                                           =    24'b000000000001000111111010             ,
      parameter  [23:0]    pf1_tph_cap_tph_ext_cap_hdr_reg_addr_byte3                                                           =    24'b000000000001000111111011             ,
      parameter  [23:0]    pf1_tph_cap_tph_req_cap_reg_addr_byte0                                                               =    24'b000000000001000111111100             ,
      parameter  [23:0]    pf1_tph_cap_tph_req_cap_reg_addr_byte1                                                               =    24'b000000000001000111111101             ,
      parameter  [23:0]    pf1_tph_cap_tph_req_cap_reg_addr_byte2                                                               =    24'b000000000001000111111110             ,
      parameter  [23:0]    pf1_tph_cap_tph_req_cap_reg_addr_byte3                                                               =    24'b000000000001000111111111             ,
      parameter  [23:0]    pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte0                                                    =    24'b001000000001000111111100             ,
      parameter  [23:0]    pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte1                                                    =    24'b001000000001000111111101             ,
      parameter  [23:0]    pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte2                                                    =    24'b001000000001000111111110             ,
      parameter  [23:0]    pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte3                                                    =    24'b001000000001000111111111             ,
      parameter            pf1_tph_req_cap_int_vec                                                                              =    "disable"                                ,
      parameter            pf1_tph_req_cap_int_vec_vfcomm_cs2                                                                   =    "disable"                                ,
      parameter  [4:0]     pf1_tph_req_cap_reg_rsvdp_11                                                                         =    5'b00000                                 ,
      parameter  [4:0]     pf1_tph_req_cap_reg_rsvdp_27                                                                         =    5'b00000                                 ,
      parameter  [4:0]     pf1_tph_req_cap_reg_rsvdp_3                                                                          =    5'b00000                                 ,
      parameter  [4:0]     pf1_tph_req_cap_reg_vfcomm_cs2_rsvdp_11_vfcomm_cs2                                                   =    5'b00000                                 ,
      parameter  [4:0]     pf1_tph_req_cap_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                                                   =    5'b00000                                 ,
      parameter  [4:0]     pf1_tph_req_cap_reg_vfcomm_cs2_rsvdp_3_vfcomm_cs2                                                    =    5'b00000                                 ,
      parameter            pf1_tph_req_cap_st_table_loc_0                                                                       =    "pf1_not_in_tph_struct"                  ,
      parameter            pf1_tph_req_cap_st_table_loc_0_vfcomm_cs2                                                            =    "pf1_not_in_tph_struct_vf"               ,
      parameter            pf1_tph_req_cap_st_table_loc_1                                                                       =    "pf1_not_in_msix_table"                  ,
      parameter            pf1_tph_req_cap_st_table_loc_1_vfcomm_cs2                                                            =    "pf1_not_in_msix_table_vf"               ,
      parameter  [10:0]    pf1_tph_req_cap_st_table_size                                                                        =    11'b00000000001                          ,
      parameter  [10:0]    pf1_tph_req_cap_st_table_size_vfcomm_cs2                                                             =    11'b00000000001                          ,
      parameter  [3:0]     pf1_tph_req_cap_ver                                                                                  =    4'b0001                                  ,
      parameter            pf1_tph_req_device_spec                                                                              =    "disable"                                ,
      parameter            pf1_tph_req_device_spec_vfcomm_cs2                                                                   =    "disable"                                ,
      parameter            pf1_tph_req_extended_tph                                                                             =    "disable"                                ,
      parameter            pf1_tph_req_extended_tph_vfcomm_cs2                                                                  =    "disable"                                ,
      parameter  [11:0]    pf1_tph_req_next_ptr                                                                                 =    12'b001011011000                         ,
      parameter            pf1_tph_req_no_st_mode                                                                               =    "false"                                  ,
      parameter            pf1_tph_req_no_st_mode_vfcomm_cs2                                                                    =    "false"                                  ,
      parameter  [23:0]    pf1_type0_hdr_bar0_mask_reg_addr_byte0                                                               =    24'b001000000001000000010000             ,
      parameter  [23:0]    pf1_type0_hdr_bar0_mask_reg_addr_byte1                                                               =    24'b001000000001000000010001             ,
      parameter  [23:0]    pf1_type0_hdr_bar0_mask_reg_addr_byte2                                                               =    24'b001000000001000000010010             ,
      parameter  [23:0]    pf1_type0_hdr_bar0_mask_reg_addr_byte3                                                               =    24'b001000000001000000010011             ,
      parameter  [23:0]    pf1_type0_hdr_bar0_reg_addr_byte0                                                                    =    24'b000000000001000000010000             ,
      parameter  [23:0]    pf1_type0_hdr_bar1_enable_reg_addr_byte0                                                             =    24'b001000000001000000010100             ,
      parameter  [23:0]    pf1_type0_hdr_bar1_mask_reg_addr_byte0                                                               =    24'b001000000001000000010100             ,
      parameter  [23:0]    pf1_type0_hdr_bar1_mask_reg_addr_byte1                                                               =    24'b001000000001000000010101             ,
      parameter  [23:0]    pf1_type0_hdr_bar1_mask_reg_addr_byte2                                                               =    24'b001000000001000000010110             ,
      parameter  [23:0]    pf1_type0_hdr_bar1_mask_reg_addr_byte3                                                               =    24'b001000000001000000010111             ,
      parameter  [23:0]    pf1_type0_hdr_bar1_reg_addr_byte0                                                                    =    24'b000000000001000000010100             ,
      parameter  [23:0]    pf1_type0_hdr_bar2_mask_reg_addr_byte0                                                               =    24'b001000000001000000011000             ,
      parameter  [23:0]    pf1_type0_hdr_bar2_mask_reg_addr_byte1                                                               =    24'b001000000001000000011001             ,
      parameter  [23:0]    pf1_type0_hdr_bar2_mask_reg_addr_byte2                                                               =    24'b001000000001000000011010             ,
      parameter  [23:0]    pf1_type0_hdr_bar2_mask_reg_addr_byte3                                                               =    24'b001000000001000000011011             ,
      parameter  [23:0]    pf1_type0_hdr_bar2_reg_addr_byte0                                                                    =    24'b000000000001000000011000             ,
      parameter  [23:0]    pf1_type0_hdr_bar3_enable_reg_addr_byte0                                                             =    24'b001000000001000000011100             ,
      parameter  [23:0]    pf1_type0_hdr_bar3_mask_reg_addr_byte0                                                               =    24'b001000000001000000011100             ,
      parameter  [23:0]    pf1_type0_hdr_bar3_mask_reg_addr_byte1                                                               =    24'b001000000001000000011101             ,
      parameter  [23:0]    pf1_type0_hdr_bar3_mask_reg_addr_byte2                                                               =    24'b001000000001000000011110             ,
      parameter  [23:0]    pf1_type0_hdr_bar3_mask_reg_addr_byte3                                                               =    24'b001000000001000000011111             ,
      parameter  [23:0]    pf1_type0_hdr_bar3_reg_addr_byte0                                                                    =    24'b000000000001000000011100             ,
      parameter  [23:0]    pf1_type0_hdr_bar4_mask_reg_addr_byte0                                                               =    24'b001000000001000000100000             ,
      parameter  [23:0]    pf1_type0_hdr_bar4_mask_reg_addr_byte1                                                               =    24'b001000000001000000100001             ,
      parameter  [23:0]    pf1_type0_hdr_bar4_mask_reg_addr_byte2                                                               =    24'b001000000001000000100010             ,
      parameter  [23:0]    pf1_type0_hdr_bar4_mask_reg_addr_byte3                                                               =    24'b001000000001000000100011             ,
      parameter  [23:0]    pf1_type0_hdr_bar4_reg_addr_byte0                                                                    =    24'b000000000001000000100000             ,
      parameter  [23:0]    pf1_type0_hdr_bar5_enable_reg_addr_byte0                                                             =    24'b001000000001000000100100             ,
      parameter  [23:0]    pf1_type0_hdr_bar5_mask_reg_addr_byte0                                                               =    24'b001000000001000000100100             ,
      parameter  [23:0]    pf1_type0_hdr_bar5_mask_reg_addr_byte1                                                               =    24'b001000000001000000100101             ,
      parameter  [23:0]    pf1_type0_hdr_bar5_mask_reg_addr_byte2                                                               =    24'b001000000001000000100110             ,
      parameter  [23:0]    pf1_type0_hdr_bar5_mask_reg_addr_byte3                                                               =    24'b001000000001000000100111             ,
      parameter  [23:0]    pf1_type0_hdr_bar5_reg_addr_byte0                                                                    =    24'b000000000001000000100100             ,
      parameter  [23:0]    pf1_type0_hdr_bist_header_type_latency_cache_line_size_reg_addr_byte2                                =    24'b000000000001000000001110             ,
      parameter  [23:0]    pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte0                                                         =    24'b000000000001000000101000             ,
      parameter  [23:0]    pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte1                                                         =    24'b000000000001000000101001             ,
      parameter  [23:0]    pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte2                                                         =    24'b000000000001000000101010             ,
      parameter  [23:0]    pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte3                                                         =    24'b000000000001000000101011             ,
      parameter  [23:0]    pf1_type0_hdr_class_code_revision_id_addr_byte0                                                      =    24'b000000000001000000001000             ,
      parameter  [23:0]    pf1_type0_hdr_class_code_revision_id_addr_byte1                                                      =    24'b000000000001000000001001             ,
      parameter  [23:0]    pf1_type0_hdr_class_code_revision_id_addr_byte2                                                      =    24'b000000000001000000001010             ,
      parameter  [23:0]    pf1_type0_hdr_class_code_revision_id_addr_byte3                                                      =    24'b000000000001000000001011             ,
      parameter  [23:0]    pf1_type0_hdr_device_id_vendor_id_reg_addr_byte0                                                     =    24'b000000000001000000000000             ,
      parameter  [23:0]    pf1_type0_hdr_device_id_vendor_id_reg_addr_byte1                                                     =    24'b000000000001000000000001             ,
      parameter  [23:0]    pf1_type0_hdr_device_id_vendor_id_reg_addr_byte2                                                     =    24'b000000000001000000000010             ,
      parameter  [23:0]    pf1_type0_hdr_device_id_vendor_id_reg_addr_byte3                                                     =    24'b000000000001000000000011             ,
      parameter  [23:0]    pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte0                                                        =    24'b001000000001000000110000             ,
      parameter  [23:0]    pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte1                                                        =    24'b001000000001000000110001             ,
      parameter  [23:0]    pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte2                                                        =    24'b001000000001000000110010             ,
      parameter  [23:0]    pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte3                                                        =    24'b001000000001000000110011             ,
      parameter  [23:0]    pf1_type0_hdr_exp_rom_base_addr_reg_addr_byte0                                                       =    24'b000000000001000000110000             ,
      parameter  [23:0]    pf1_type0_hdr_max_latency_min_grant_interrupt_pin_interrupt_line_reg_addr_byte1                      =    24'b000000000001000000111101             ,
      parameter  [23:0]    pf1_type0_hdr_pci_cap_ptr_reg_addr_byte0                                                             =    24'b000000000001000000110100             ,
      parameter  [23:0]    pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte0                                        =    24'b000000000001000000101100             ,
      parameter  [23:0]    pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte1                                        =    24'b000000000001000000101101             ,
      parameter  [23:0]    pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte2                                        =    24'b000000000001000000101110             ,
      parameter  [23:0]    pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte3                                        =    24'b000000000001000000101111             ,
      parameter            pf1_vf_bar0_reg_rsvdp_0                                                                              =    "false"                                  ,
      parameter            pf1_vf_bar1_reg_rsvdp_0                                                                              =    "false"                                  ,
      parameter            pf1_vf_bar2_reg_rsvdp_0                                                                              =    "false"                                  ,
      parameter            pf1_vf_bar3_reg_rsvdp_0                                                                              =    "false"                                  ,
      parameter            pf1_vf_bar4_reg_rsvdp_0                                                                              =    "false"                                  ,
      parameter            pf1_vf_bar5_reg_rsvdp_0                                                                              =    "false"                                  ,
      parameter            pf1_vf_forward_user_vsec                                                                             =    "false"                                  ,
      parameter  [25:0]    pipe_ctrl                                                                                            =    26'b00010000000010101000101010           ,
      parameter            pld_aib_loopback_en                                                                                  =    "false"                                  ,
      parameter            pld_aux_gate_en                                                                                      =    "true"                                   ,
      parameter            pld_aux_prog_en                                                                                      =    "true"                                   ,
      parameter            pld_crs_en                                                                                           =    "false"                                  ,
      parameter            pld_rx_cpl_bufflimit_bypass                                                                          =    "false"                                  ,
      parameter            pld_rx_np_bufflimit_bypass                                                                           =    "false"                                  ,
      parameter            pld_rx_parity_ena                                                                                    =    "enable"                                 ,
      parameter            pld_rx_posted_bufflimit_bypass                                                                       =    "false"                                  ,
      parameter            pld_tx_fifo_dyn_empty_dis                                                                            =    "false"                                  ,
      parameter  [3:0]     pld_tx_fifo_empty_threshold_1                                                                        =    4'b0011                                  ,
      parameter  [3:0]     pld_tx_fifo_empty_threshold_2                                                                        =    4'b1100                                  ,
      parameter  [4:0]     pld_tx_fifo_empty_threshold_3                                                                        =    5'b01111                                 ,
      parameter  [5:0]     pld_tx_fifo_full_threshold                                                                           =    6'b101000                                ,
      parameter            pld_tx_parity_ena                                                                                    =    "enable"                                 ,
      parameter            powerdown_mode                                                                                       =    "powerup"                                ,
      parameter            rx_lane_flip_en                                                                                      =    "false"                                  ,
      parameter            silicon_rev                                                                                          =    "14nm5"                                  ,
      parameter            sim_mode                                                                                             =    "enable"                                 ,
      parameter            ssm_aux_prog_en                                                                                      =    "false"                                  ,
      parameter            sup_mode                                                                                             =    "user_mode"                              ,
      parameter  [31:0]    test_in_hi                                                                                           =    32'b00000000000000000000000000000000     ,
      parameter  [31:0]    test_in_lo                                                                                           =    32'b00000000000000000000000000000000     ,
      parameter            test_in_override                                                                                     =    "false"                                  ,
      parameter            tx_avst_dsk_en                                                                                       =    "disable"                                ,
      parameter            tx_lane_flip_en                                                                                      =    "false"                                  ,
      parameter  [4:0]     user_mode_del_count                                                                                  =    5'b00101                                 ,
      parameter            valid_ecc_err_rpt_en                                                                                 =    "true"                                   ,
      parameter  [3:0]     vf1_pf0_ari_cap_version                                                                              =    4'b0001                                  ,
      parameter  [23:0]    vf1_pf0_ari_cap_vf_ari_base_addr_byte2                                                               =    24'b000100000000000100000010             ,
      parameter  [23:0]    vf1_pf0_ari_cap_vf_ari_base_addr_byte3                                                               =    24'b000100000000000100000011             ,
      parameter  [11:0]    vf1_pf0_ari_next_offset                                                                              =    12'b000101011000                         ,
      parameter  [23:0]    vf1_pf0_pcie_cap_vf_shadow_link_capabilities_reg_addr_byte1                                          =    24'b000100000000000001111101             ,
      parameter            vf1_pf0_shadow_pcie_cap_aspm_opt_compliance                                                          =    "false"                                  ,
      parameter            vf1_pf0_shadow_pcie_cap_clock_power_man                                                              =    "false"                                  ,
      parameter            vf1_pf0_shadow_pcie_cap_dll_active_rep_cap                                                           =    "false"                                  ,
      parameter  [1:0]     vf1_pf0_shadow_pcie_cap_l1_exit_latency_commclk_ena                                                  =    2'b11                                    ,
      parameter            vf1_pf0_shadow_pcie_cap_link_bw_not_cap                                                              =    "false"                                  ,
      parameter            vf1_pf0_shadow_pcie_cap_surprise_down_err_rep_cap                                                    =    "false"                                  ,
      parameter  [23:0]    vf1_pf0_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte2                                                    =    24'b000100000000000100010010             ,
      parameter  [23:0]    vf1_pf0_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte3                                                    =    24'b000100000000000100010011             ,
      parameter  [3:0]     vf1_pf0_tph_req_cap_ver                                                                              =    4'b0001                                  ,
      parameter  [11:0]    vf1_pf0_tph_req_next_ptr                                                                             =    12'b001000101000                         ,
      parameter            vf1_pf0_vf_shadow_link_capabilities_reg_shadow_rsvdp_23                                              =    "false"                                  ,
      parameter  [3:0]     vf1_pf1_ari_cap_version                                                                              =    4'b0001                                  ,
      parameter  [23:0]    vf1_pf1_ari_cap_vf_ari_base_addr_byte2                                                               =    24'b000100000001000100000010             ,
      parameter  [23:0]    vf1_pf1_ari_cap_vf_ari_base_addr_byte3                                                               =    24'b000100000001000100000011             ,
      parameter  [11:0]    vf1_pf1_ari_next_offset                                                                              =    12'b000101011000                         ,
      parameter  [23:0]    vf1_pf1_pcie_cap_vf_shadow_link_capabilities_reg_addr_byte1                                          =    24'b000100000001000001111101             ,
      parameter            vf1_pf1_shadow_pcie_cap_aspm_opt_compliance                                                          =    "false"                                  ,
      parameter            vf1_pf1_shadow_pcie_cap_clock_power_man                                                              =    "false"                                  ,
      parameter            vf1_pf1_shadow_pcie_cap_dll_active_rep_cap                                                           =    "false"                                  ,
      parameter  [1:0]     vf1_pf1_shadow_pcie_cap_l1_exit_latency_commclk_ena                                                  =    2'b11                                    ,
      parameter            vf1_pf1_shadow_pcie_cap_link_bw_not_cap                                                              =    "false"                                  ,
      parameter            vf1_pf1_shadow_pcie_cap_surprise_down_err_rep_cap                                                    =    "false"                                  ,
      parameter  [23:0]    vf1_pf1_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte2                                                    =    24'b000100000001000100010010             ,
      parameter  [23:0]    vf1_pf1_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte3                                                    =    24'b000100000001000100010011             ,
      parameter  [3:0]     vf1_pf1_tph_req_cap_ver                                                                              =    4'b0001                                  ,
      parameter  [11:0]    vf1_pf1_tph_req_next_ptr                                                                             =    12'b001000101000                         ,
      parameter            vf1_pf1_vf_shadow_link_capabilities_reg_shadow_rsvdp_23                                              =    "false"                                  ,
      parameter  [7:0]     vf_dbi_reserved_0                                                                                    =    8'b00000000                              ,
      parameter  [7:0]     vf_dbi_reserved_1                                                                                    =    8'b00000000                              ,
      parameter  [7:0]     vf_dbi_reserved_2                                                                                    =    8'b00000000                              ,
      parameter  [7:0]     vf_dbi_reserved_3                                                                                    =    8'b00000000                              ,
      parameter  [7:0]     vf_dbi_reserved_4                                                                                    =    8'b00000000                              ,
      parameter  [7:0]     vf_dbi_reserved_5                                                                                    =    8'b00000000                              ,
      parameter  [23:0]    vf_reserved_0_addr                                                                                   =    24'b000000000000000000000000             ,
      parameter  [23:0]    vf_reserved_1_addr                                                                                   =    24'b000000000000000000000000             ,
      parameter  [23:0]    vf_reserved_2_addr                                                                                   =    24'b000000000000000000000000             ,
      parameter  [23:0]    vf_reserved_3_addr                                                                                   =    24'b000000000000000000000000             ,
      parameter  [23:0]    vf_reserved_4_addr                                                                                   =    24'b000000000000000000000000             ,
      parameter  [23:0]    vf_reserved_5_addr                                                                                   =    24'b000000000000000000000000             ,
      parameter            virtual_drop_vendor0_msg                                                                             =    "false"                                  ,
      parameter            virtual_drop_vendor1_msg                                                                             =    "false"                                  ,
      parameter            virtual_ep_native                                                                                    =    "native"                                 ,
      parameter            virtual_gen2_pma_pll_usage                                                                           =    "not_applicable"                         ,
      parameter            virtual_hrdrstctrl_en                                                                                =    "enable"                                 ,
      parameter            virtual_link_rate                                                                                    =    "gen3"                                   ,
      parameter            virtual_link_width                                                                                   =    "x16"                                    ,
      parameter            virtual_maxpayload_size                                                                              =    "max_payload_1024"                       ,
      parameter            virtual_pf0_ats_cap_enable                                                                           =    "disable"                                ,
      parameter            virtual_pf0_bar1_mask_bit0                                                                           =    "false"                                  ,
      parameter            virtual_pf0_bar3_mask_bit0                                                                           =    "false"                                  ,
      parameter            virtual_pf0_bar5_mask_bit0                                                                           =    "false"                                  ,
      parameter            virtual_pf0_io_decode                                                                                =    "io32"                                   ,
      parameter            virtual_pf0_msi_enable                                                                               =    "disable"                                ,
      parameter            virtual_pf0_msix_enable                                                                              =    "disable"                                ,
      parameter            virtual_pf0_pb_cap_enable                                                                            =    "disable"                                ,
      parameter            virtual_pf0_prefetch_decode                                                                          =    "pref64"                                 ,
      parameter            virtual_pf0_sn_cap_enable                                                                            =    "disable"                                ,
      parameter            virtual_pf0_sriov_enable                                                                             =    "disable"                                ,
      parameter  [15:0]    virtual_pf0_sriov_num_vf_ari                                                                         =    16'b0000000000000000                     ,
      parameter  [15:0]    virtual_pf0_sriov_num_vf_non_ari                                                                     =    16'b0000000000000000                     ,
      parameter            virtual_pf0_sriov_vf_bar0_enabled                                                                    =    "disable"                                ,
      parameter            virtual_pf0_sriov_vf_bar1_enabled                                                                    =    "disable"                                ,
      parameter            virtual_pf0_sriov_vf_bar2_enabled                                                                    =    "disable"                                ,
      parameter            virtual_pf0_sriov_vf_bar3_enabled                                                                    =    "disable"                                ,
      parameter            virtual_pf0_sriov_vf_bar4_enabled                                                                    =    "disable"                                ,
      parameter            virtual_pf0_sriov_vf_bar5_enabled                                                                    =    "disable"                                ,
      parameter            virtual_pf0_tph_cap_enable                                                                           =    "disable"                                ,
      parameter            virtual_pf0_user_vsec_cap_enable                                                                     =    "disable"                                ,
      parameter            virtual_pf1_ats_cap_enable                                                                           =    "disable"                                ,
      parameter            virtual_pf1_bar1_mask_bit0                                                                           =    "false"                                  ,
      parameter            virtual_pf1_bar3_mask_bit0                                                                           =    "false"                                  ,
      parameter            virtual_pf1_bar5_mask_bit0                                                                           =    "false"                                  ,
      parameter            virtual_pf1_enable                                                                                   =    "disable"                                ,
      parameter            virtual_pf1_msi_enable                                                                               =    "disable"                                ,
      parameter            virtual_pf1_msix_enable                                                                              =    "disable"                                ,
      parameter            virtual_pf1_pb_cap_enable                                                                            =    "disable"                                ,
      parameter            virtual_pf1_sn_cap_enable                                                                            =    "disable"                                ,
      parameter            virtual_pf1_sriov_enable                                                                             =    "disable"                                ,
      parameter  [15:0]    virtual_pf1_sriov_num_vf_ari                                                                         =    16'b0000000000000000                     ,
      parameter  [15:0]    virtual_pf1_sriov_num_vf_non_ari                                                                     =    16'b0000000000000000                     ,
      parameter            virtual_pf1_sriov_vf_bar0_enabled                                                                    =    "disable"                                ,
      parameter            virtual_pf1_sriov_vf_bar1_enabled                                                                    =    "disable"                                ,
      parameter            virtual_pf1_sriov_vf_bar2_enabled                                                                    =    "disable"                                ,
      parameter            virtual_pf1_sriov_vf_bar3_enabled                                                                    =    "disable"                                ,
      parameter            virtual_pf1_sriov_vf_bar4_enabled                                                                    =    "disable"                                ,
      parameter            virtual_pf1_sriov_vf_bar5_enabled                                                                    =    "disable"                                ,
      parameter            virtual_pf1_tph_cap_enable                                                                           =    "disable"                                ,
      parameter            virtual_pf1_user_vsec_cap_enable                                                                     =    "disable"                                ,
      parameter            virtual_phase23_txpreset                                                                             =    "preset7"                                ,
      parameter            virtual_rp_ep_mode                                                                                   =    "ep"                                     ,
      parameter            virtual_txeq_mode                                                                                    =    "eq_disable"                             ,
      parameter            virtual_uc_calibration_en                                                                            =    "enable"                                 ,
      parameter            virtual_vf1_pf0_ats_cap_enable                                                                       =    "disable"                                ,
      parameter            virtual_vf1_pf0_tph_cap_enable                                                                       =    "disable"                                ,
      parameter            virtual_vf1_pf0_user_vsec_cap_enable                                                                 =    "disable"                                ,
      parameter            virtual_vf1_pf1_ats_cap_enable                                                                       =    "disable"                                ,
      parameter            virtual_vf1_pf1_tph_cap_enable                                                                       =    "disable"                                ,
      parameter            virtual_vf1_pf1_user_vsec_cap_enable                                                                 =    "disable"                                ,
      parameter            vsec_legacy_interr_mask_en                                                                           =    "false"                                  ,
      parameter  [11:0]    vsec_next_offset                                                                                     =    12'b000000000000

      )
      (
//Clk and reset
    input                refclk                                           ,
    output               coreclkout_hip                                   , //pld_clk_out
    input                npor                                             ,
    input                pin_perst                                        ,
    output               reset_status                                     , //hip_ready_n
    output               clr_st                                           , // reset_status
    input                pld_warm_rst_rdy                                 ,
    output               link_req_rst_n                                   ,

//AVST Signals
//RX Data Path
    input               rx_st_ready                                       ,
    output              rx_st_sop                                         ,
    output              rx_st_eop                                         ,
    output    [255:0]   rx_st_data                                        ,
    output    [31:0]    rx_st_parity                                      ,
    output              rx_st_valid                                       ,
    output    [2:0]     rx_st_bar_range                                   ,
    output    [2:0]     rx_st_empty                                       ,

//TX Data Path
    input               tx_st_sop                                         ,
    input               tx_st_eop                                         ,
    input    [255:0]    tx_st_data                                        ,
    input    [31:0]     tx_st_parity                                      ,
    input               tx_st_valid                                       ,
    input               tx_st_err                                         ,
    output              tx_st_ready                                       ,

//TX Credit Interface
    output    [1:0]     tx_cdts_type                                      ,
    output              tx_data_cdts_consumed                             ,
    output              tx_hdr_cdts_consumed                              ,
    output    [1:0]     tx_cdts_data_value                                ,
    output    [11:0]    tx_pd_cdts                                        ,
    output    [11:0]    tx_npd_cdts                                       ,
    output    [11:0]    tx_cpld_cdts                                      ,
    output    [7:0]     tx_ph_cdts                                        ,
    output    [7:0]     tx_nph_cdts                                       ,
    output    [7:0]     tx_cplh_cdts                                      ,

//AVMM DPRIO Interface
    input               user_avmm_rst_n                                   ,
    output              user_avmm_waitrequest                             ,
    input               user_avmm_read                                    ,
    input    [20:0]     user_avmm_addr                                    ,
    input               user_avmm_write                                   ,
    input    [7:0]      user_avmm_writedata                               ,
    input               user_avmm_clk                                     ,
    output              user_avmm_readdatavalid                           ,
    output    [7:0]     user_avmm_readdata                                ,


//MSI and legacy Interrupt
    input               app_msi_req                                       ,
    output              app_msi_ack                                       ,
    input    [2:0]      app_msi_tc                                        ,
    input    [4:0]      app_msi_num                                       ,
    input               app_int_0                                         ,
    output   [7:0]      int_status_pf0                                    ,
    output   [2:0]      int_status_common                                 ,



//Error & cfg_tl Interface
//cfg_tl
    output    [1:0]     tl_cfg_func                                       ,
    output    [4:0]     tl_cfg_add                                        ,
    output    [31:0]    tl_cfg_ctl                                        ,

//Error
    output              serr_out_0                                        ,
    input               app_err_valid                                     ,
    input    [31:0]     app_err_hdr                                       ,
    input    [10:0]     app_err_info                                      ,

    output              derr_cor_ext_rpl                                  , // retry_corr_ecc_err
    output              derr_rpl                                          , // retry_unc_ecc_err
    output              derr_cor_ext_rcv                                  , // rxbuff_corr_ecc_err
    output              derr_uncor_ext_rcv                                , // rxbuff_unc_ecc_err

    output              rx_par_err                                        ,
    output              tx_par_err                                        ,


//Status & Link Training Interface
    output              serdes_pll_locked                                 , // from phy
    input               pld_core_ready                                    ,
    output              pld_clk_inuse                                     ,
    output              link_up                                           ,
    output    [5:0]     ltssm_state                                       ,
    output    [1:0]     currentspeed                                      ,
    output    [4:0]     lane_act                                          ,

//CEB Interface
    output              ceb_req                                           ,
    input               ceb_ack                                           ,
    output    [31:0]    ceb_addr                                          ,
    input     [31:0]    ceb_din                                           ,
    output    [31:0]    ceb_dout                                          ,
    output    [3:0]     ceb_wr                                            ,

//PM signals
    output              pm_linkst_in_l1                                   ,
    output              pm_linkst_in_l0s                                  ,
    output    [2:0]     pm_state                                          ,
    output    [2:0]     pm_dstate_0                                       ,
    input               apps_pm_xmt_pme_0                                 ,
    input               apps_ready_entr_l23                               ,
    input               apps_pm_xmt_turnoff                               ,
    input               app_init_rst                                      ,
    input               app_xfer_pending                                  ,


    // PIPE Interface Signals
    input               pipe32_sim_only                                   ,
    input               sim_pipe_pclk_in                                  ,
    output              sim_pipe_pclk_out                                 ,
    output    [1:0]     sim_pipe_rate                                     ,
    input               sim_pipe_mask_tx_pll_lock                         ,
    output    [5:0]     sim_ltssmstate                                    ,

    //OUTPUT PIPE Interface Signals
    output  [31:0]      txdata0                                           ,
    output  [31:0]      txdata1                                           ,
    output  [31:0]      txdata2                                           ,
    output  [31:0]      txdata3                                           ,
    output  [31:0]      txdata4                                           ,
    output  [31:0]      txdata5                                           ,
    output  [31:0]      txdata6                                           ,
    output  [31:0]      txdata7                                           ,
    output  [31:0]      txdata8                                           ,
    output  [31:0]      txdata9                                           ,
    output  [31:0]      txdata10                                          ,
    output  [31:0]      txdata11                                          ,
    output  [31:0]      txdata12                                          ,
    output  [31:0]      txdata13                                          ,
    output  [31:0]      txdata14                                          ,
    output  [31:0]      txdata15                                          ,

    output  [3:0]       txdatak0                                          ,
    output  [3:0]       txdatak1                                          ,
    output  [3:0]       txdatak2                                          ,
    output  [3:0]       txdatak3                                          ,
    output  [3:0]       txdatak4                                          ,
    output  [3:0]       txdatak5                                          ,
    output  [3:0]       txdatak6                                          ,
    output  [3:0]       txdatak7                                          ,
    output  [3:0]       txdatak8                                          ,
    output  [3:0]       txdatak9                                          ,
    output  [3:0]       txdatak10                                         ,
    output  [3:0]       txdatak11                                         ,
    output  [3:0]       txdatak12                                         ,
    output  [3:0]       txdatak13                                         ,
    output  [3:0]       txdatak14                                         ,
    output  [3:0]       txdatak15                                         ,

    output              txcompl0                                          ,
    output              txcompl1                                          ,
    output              txcompl2                                          ,
    output              txcompl3                                          ,
    output              txcompl4                                          ,
    output              txcompl5                                          ,
    output              txcompl6                                          ,
    output              txcompl7                                          ,
    output              txcompl8                                          ,
    output              txcompl9                                          ,
    output              txcompl10                                         ,
    output              txcompl11                                         ,
    output              txcompl12                                         ,
    output              txcompl13                                         ,
    output              txcompl14                                         ,
    output              txcompl15                                         ,

    output              txelecidle0                                       ,
    output              txelecidle1                                       ,
    output              txelecidle2                                       ,
    output              txelecidle3                                       ,
    output              txelecidle4                                       ,
    output              txelecidle5                                       ,
    output              txelecidle6                                       ,
    output              txelecidle7                                       ,
    output              txelecidle8                                       ,
    output              txelecidle9                                       ,
    output              txelecidle10                                      ,
    output              txelecidle11                                      ,
    output              txelecidle12                                      ,
    output              txelecidle13                                      ,
    output              txelecidle14                                      ,
    output              txelecidle15                                      ,

    output              txdetectrx0                                       ,
    output              txdetectrx1                                       ,
    output              txdetectrx2                                       ,
    output              txdetectrx3                                       ,
    output              txdetectrx4                                       ,
    output              txdetectrx5                                       ,
    output              txdetectrx6                                       ,
    output              txdetectrx7                                       ,
    output              txdetectrx8                                       ,
    output              txdetectrx9                                       ,
    output              txdetectrx10                                      ,
    output              txdetectrx11                                      ,
    output              txdetectrx12                                      ,
    output              txdetectrx13                                      ,
    output              txdetectrx14                                      ,
    output              txdetectrx15                                      ,

    output  [1:0]       powerdown0                                        ,
    output  [1:0]       powerdown1                                        ,
    output  [1:0]       powerdown2                                        ,
    output  [1:0]       powerdown3                                        ,
    output  [1:0]       powerdown4                                        ,
    output  [1:0]       powerdown5                                        ,
    output  [1:0]       powerdown6                                        ,
    output  [1:0]       powerdown7                                        ,
    output  [1:0]       powerdown8                                        ,
    output  [1:0]       powerdown9                                        ,
    output  [1:0]       powerdown10                                       ,
    output  [1:0]       powerdown11                                       ,
    output  [1:0]       powerdown12                                       ,
    output  [1:0]       powerdown13                                       ,
    output  [1:0]       powerdown14                                       ,
    output  [1:0]       powerdown15                                       ,

    output  [2:0]       txmargin0                                         ,
    output  [2:0]       txmargin1                                         ,
    output  [2:0]       txmargin2                                         ,
    output  [2:0]       txmargin3                                         ,
    output  [2:0]       txmargin4                                         ,
    output  [2:0]       txmargin5                                         ,
    output  [2:0]       txmargin6                                         ,
    output  [2:0]       txmargin7                                         ,
    output  [2:0]       txmargin8                                         ,
    output  [2:0]       txmargin9                                         ,
    output  [2:0]       txmargin10                                        ,
    output  [2:0]       txmargin11                                        ,
    output  [2:0]       txmargin12                                        ,
    output  [2:0]       txmargin13                                        ,
    output  [2:0]       txmargin14                                        ,
    output  [2:0]       txmargin15                                        ,

    output              txdeemph0                                         ,
    output              txdeemph1                                         ,
    output              txdeemph2                                         ,
    output              txdeemph3                                         ,
    output              txdeemph4                                         ,
    output              txdeemph5                                         ,
    output              txdeemph6                                         ,
    output              txdeemph7                                         ,
    output              txdeemph8                                         ,
    output              txdeemph9                                         ,
    output              txdeemph10                                        ,
    output              txdeemph11                                        ,
    output              txdeemph12                                        ,
    output              txdeemph13                                        ,
    output              txdeemph14                                        ,
    output              txdeemph15                                        ,

    output              txswing0                                          ,
    output              txswing1                                          ,
    output              txswing2                                          ,
    output              txswing3                                          ,
    output              txswing4                                          ,
    output              txswing5                                          ,
    output              txswing6                                          ,
    output              txswing7                                          ,
    output              txswing8                                          ,
    output              txswing9                                          ,
    output              txswing10                                         ,
    output              txswing11                                         ,
    output              txswing12                                         ,
    output              txswing13                                         ,
    output              txswing14                                         ,
    output              txswing15                                         ,

    output  [1:0]       txsynchd0                                         ,
    output  [1:0]       txsynchd1                                         ,
    output  [1:0]       txsynchd2                                         ,
    output  [1:0]       txsynchd3                                         ,
    output  [1:0]       txsynchd4                                         ,
    output  [1:0]       txsynchd5                                         ,
    output  [1:0]       txsynchd6                                         ,
    output  [1:0]       txsynchd7                                         ,
    output  [1:0]       txsynchd8                                         ,
    output  [1:0]       txsynchd9                                         ,
    output  [1:0]       txsynchd10                                        ,
    output  [1:0]       txsynchd11                                        ,
    output  [1:0]       txsynchd12                                        ,
    output  [1:0]       txsynchd13                                        ,
    output  [1:0]       txsynchd14                                        ,
    output  [1:0]       txsynchd15                                        ,

    output              txblkst0                                          ,
    output              txblkst1                                          ,
    output              txblkst2                                          ,
    output              txblkst3                                          ,
    output              txblkst4                                          ,
    output              txblkst5                                          ,
    output              txblkst6                                          ,
    output              txblkst7                                          ,
    output              txblkst8                                          ,
    output              txblkst9                                          ,
    output              txblkst10                                         ,
    output              txblkst11                                         ,
    output              txblkst12                                         ,
    output              txblkst13                                         ,
    output              txblkst14                                         ,
    output              txblkst15                                         ,

    output              txdatavalid0                                      ,
    output              txdatavalid1                                      ,
    output              txdatavalid2                                      ,
    output              txdatavalid3                                      ,
    output              txdatavalid4                                      ,
    output              txdatavalid5                                      ,
    output              txdatavalid6                                      ,
    output              txdatavalid7                                      ,
    output              txdatavalid8                                      ,
    output              txdatavalid9                                      ,
    output              txdatavalid10                                     ,
    output              txdatavalid11                                     ,
    output              txdatavalid12                                     ,
    output              txdatavalid13                                     ,
    output              txdatavalid14                                     ,
    output              txdatavalid15                                     ,

    output  [1:0]       rate0                                             ,
    output  [1:0]       rate1                                             ,
    output  [1:0]       rate2                                             ,
    output  [1:0]       rate3                                             ,
    output  [1:0]       rate4                                             ,
    output  [1:0]       rate5                                             ,
    output  [1:0]       rate6                                             ,
    output  [1:0]       rate7                                             ,
    output  [1:0]       rate8                                             ,
    output  [1:0]       rate9                                             ,
    output  [1:0]       rate10                                            ,
    output  [1:0]       rate11                                            ,
    output  [1:0]       rate12                                            ,
    output  [1:0]       rate13                                            ,
    output  [1:0]       rate14                                            ,
    output  [1:0]       rate15                                            ,

    output              rxpolarity0                                       ,
    output              rxpolarity1                                       ,
    output              rxpolarity2                                       ,
    output              rxpolarity3                                       ,
    output              rxpolarity4                                       ,
    output              rxpolarity5                                       ,
    output              rxpolarity6                                       ,
    output              rxpolarity7                                       ,
    output              rxpolarity8                                       ,
    output              rxpolarity9                                       ,
    output              rxpolarity10                                      ,
    output              rxpolarity11                                      ,
    output              rxpolarity12                                      ,
    output              rxpolarity13                                      ,
    output              rxpolarity14                                      ,
    output              rxpolarity15                                      ,

    output  [2:0]       currentrxpreset0                                  ,
    output  [2:0]       currentrxpreset1                                  ,
    output  [2:0]       currentrxpreset2                                  ,
    output  [2:0]       currentrxpreset3                                  ,
    output  [2:0]       currentrxpreset4                                  ,
    output  [2:0]       currentrxpreset5                                  ,
    output  [2:0]       currentrxpreset6                                  ,
    output  [2:0]       currentrxpreset7                                  ,
    output  [2:0]       currentrxpreset8                                  ,
    output  [2:0]       currentrxpreset9                                  ,
    output  [2:0]       currentrxpreset10                                 ,
    output  [2:0]       currentrxpreset11                                 ,
    output  [2:0]       currentrxpreset12                                 ,
    output  [2:0]       currentrxpreset13                                 ,
    output  [2:0]       currentrxpreset14                                 ,
    output  [2:0]       currentrxpreset15                                 ,

    output [17:0]       currentcoeff0                                     ,
    output [17:0]       currentcoeff1                                     ,
    output [17:0]       currentcoeff2                                     ,
    output [17:0]       currentcoeff3                                     ,
    output [17:0]       currentcoeff4                                     ,
    output [17:0]       currentcoeff5                                     ,
    output [17:0]       currentcoeff6                                     ,
    output [17:0]       currentcoeff7                                     ,
    output [17:0]       currentcoeff8                                     ,
    output [17:0]       currentcoeff9                                     ,
    output [17:0]       currentcoeff10                                    ,
    output [17:0]       currentcoeff11                                    ,
    output [17:0]       currentcoeff12                                    ,
    output [17:0]       currentcoeff13                                    ,
    output [17:0]       currentcoeff14                                    ,
    output [17:0]       currentcoeff15                                    ,

    output              rxeqeval0                                         ,
    output              rxeqeval1                                         ,
    output              rxeqeval2                                         ,
    output              rxeqeval3                                         ,
    output              rxeqeval4                                         ,
    output              rxeqeval5                                         ,
    output              rxeqeval6                                         ,
    output              rxeqeval7                                         ,
    output              rxeqeval8                                         ,
    output              rxeqeval9                                         ,
    output              rxeqeval10                                        ,
    output              rxeqeval11                                        ,
    output              rxeqeval12                                        ,
    output              rxeqeval13                                        ,
    output              rxeqeval14                                        ,
    output              rxeqeval15                                        ,

    output              rxeqinprogress0                                   ,
    output              rxeqinprogress1                                   ,
    output              rxeqinprogress2                                   ,
    output              rxeqinprogress3                                   ,
    output              rxeqinprogress4                                   ,
    output              rxeqinprogress5                                   ,
    output              rxeqinprogress6                                   ,
    output              rxeqinprogress7                                   ,
    output              rxeqinprogress8                                   ,
    output              rxeqinprogress9                                   ,
    output              rxeqinprogress10                                  ,
    output              rxeqinprogress11                                  ,
    output              rxeqinprogress12                                  ,
    output              rxeqinprogress13                                  ,
    output              rxeqinprogress14                                  ,
    output              rxeqinprogress15                                  ,

    output              invalidreq0                                       ,
    output              invalidreq1                                       ,
    output              invalidreq2                                       ,
    output              invalidreq3                                       ,
    output              invalidreq4                                       ,
    output              invalidreq5                                       ,
    output              invalidreq6                                       ,
    output              invalidreq7                                       ,
    output              invalidreq8                                       ,
    output              invalidreq9                                       ,
    output              invalidreq10                                      ,
    output              invalidreq11                                      ,
    output              invalidreq12                                      ,
    output              invalidreq13                                      ,
    output              invalidreq14                                      ,
    output              invalidreq15                                      ,

    //INPUT PIPE Interfae Signals
    input  [31:0]       rxdata0                                           ,
    input  [31:0]       rxdata1                                           ,
    input  [31:0]       rxdata2                                           ,
    input  [31:0]       rxdata3                                           ,
    input  [31:0]       rxdata4                                           ,
    input  [31:0]       rxdata5                                           ,
    input  [31:0]       rxdata6                                           ,
    input  [31:0]       rxdata7                                           ,
    input  [31:0]       rxdata8                                           ,
    input  [31:0]       rxdata9                                           ,
    input  [31:0]       rxdata10                                          ,
    input  [31:0]       rxdata11                                          ,
    input  [31:0]       rxdata12                                          ,
    input  [31:0]       rxdata13                                          ,
    input  [31:0]       rxdata14                                          ,
    input  [31:0]       rxdata15                                          ,

    input  [3:0]        rxdatak0                                          ,
    input  [3:0]        rxdatak1                                          ,
    input  [3:0]        rxdatak2                                          ,
    input  [3:0]        rxdatak3                                          ,
    input  [3:0]        rxdatak4                                          ,
    input  [3:0]        rxdatak5                                          ,
    input  [3:0]        rxdatak6                                          ,
    input  [3:0]        rxdatak7                                          ,
    input  [3:0]        rxdatak8                                          ,
    input  [3:0]        rxdatak9                                          ,
    input  [3:0]        rxdatak10                                         ,
    input  [3:0]        rxdatak11                                         ,
    input  [3:0]        rxdatak12                                         ,
    input  [3:0]        rxdatak13                                         ,
    input  [3:0]        rxdatak14                                         ,
    input  [3:0]        rxdatak15                                         ,

    input               phystatus0                                        ,
    input               phystatus1                                        ,
    input               phystatus2                                        ,
    input               phystatus3                                        ,
    input               phystatus4                                        ,
    input               phystatus5                                        ,
    input               phystatus6                                        ,
    input               phystatus7                                        ,
    input               phystatus8                                        ,
    input               phystatus9                                        ,
    input               phystatus10                                       ,
    input               phystatus11                                       ,
    input               phystatus12                                       ,
    input               phystatus13                                       ,
    input               phystatus14                                       ,
    input               phystatus15                                       ,

    input               rxvalid0                                          ,
    input               rxvalid1                                          ,
    input               rxvalid2                                          ,
    input               rxvalid3                                          ,
    input               rxvalid4                                          ,
    input               rxvalid5                                          ,
    input               rxvalid6                                          ,
    input               rxvalid7                                          ,
    input               rxvalid8                                          ,
    input               rxvalid9                                          ,
    input               rxvalid10                                         ,
    input               rxvalid11                                         ,
    input               rxvalid12                                         ,
    input               rxvalid13                                         ,
    input               rxvalid14                                         ,
    input               rxvalid15                                         ,

    input  [2:0]        rxstatus0                                         ,
    input  [2:0]        rxstatus1                                         ,
    input  [2:0]        rxstatus2                                         ,
    input  [2:0]        rxstatus3                                         ,
    input  [2:0]        rxstatus4                                         ,
    input  [2:0]        rxstatus5                                         ,
    input  [2:0]        rxstatus6                                         ,
    input  [2:0]        rxstatus7                                         ,
    input  [2:0]        rxstatus8                                         ,
    input  [2:0]        rxstatus9                                         ,
    input  [2:0]        rxstatus10                                        ,
    input  [2:0]        rxstatus11                                        ,
    input  [2:0]        rxstatus12                                        ,
    input  [2:0]        rxstatus13                                        ,
    input  [2:0]        rxstatus14                                        ,
    input  [2:0]        rxstatus15                                        ,

    input               rxelecidle0                                       ,
    input               rxelecidle1                                       ,
    input               rxelecidle2                                       ,
    input               rxelecidle3                                       ,
    input               rxelecidle4                                       ,
    input               rxelecidle5                                       ,
    input               rxelecidle6                                       ,
    input               rxelecidle7                                       ,
    input               rxelecidle8                                       ,
    input               rxelecidle9                                       ,
    input               rxelecidle10                                      ,
    input               rxelecidle11                                      ,
    input               rxelecidle12                                      ,
    input               rxelecidle13                                      ,
    input               rxelecidle14                                      ,
    input               rxelecidle15                                      ,

    input  [1:0]        rxsynchd0                                         ,
    input  [1:0]        rxsynchd1                                         ,
    input  [1:0]        rxsynchd2                                         ,
    input  [1:0]        rxsynchd3                                         ,
    input  [1:0]        rxsynchd4                                         ,
    input  [1:0]        rxsynchd5                                         ,
    input  [1:0]        rxsynchd6                                         ,
    input  [1:0]        rxsynchd7                                         ,
    input  [1:0]        rxsynchd8                                         ,
    input  [1:0]        rxsynchd9                                         ,
    input  [1:0]        rxsynchd10                                        ,
    input  [1:0]        rxsynchd11                                        ,
    input  [1:0]        rxsynchd12                                        ,
    input  [1:0]        rxsynchd13                                        ,
    input  [1:0]        rxsynchd14                                        ,
    input  [1:0]        rxsynchd15                                        ,

    input               rxblkst0                                          ,
    input               rxblkst1                                          ,
    input               rxblkst2                                          ,
    input               rxblkst3                                          ,
    input               rxblkst4                                          ,
    input               rxblkst5                                          ,
    input               rxblkst6                                          ,
    input               rxblkst7                                          ,
    input               rxblkst8                                          ,
    input               rxblkst9                                          ,
    input               rxblkst10                                         ,
    input               rxblkst11                                         ,
    input               rxblkst12                                         ,
    input               rxblkst13                                         ,
    input               rxblkst14                                         ,
    input               rxblkst15                                         ,

    input               rxdatavalid0                                      ,
    input               rxdatavalid1                                      ,
    input               rxdatavalid2                                      ,
    input               rxdatavalid3                                      ,
    input               rxdatavalid4                                      ,
    input               rxdatavalid5                                      ,
    input               rxdatavalid6                                      ,
    input               rxdatavalid7                                      ,
    input               rxdatavalid8                                      ,
    input               rxdatavalid9                                      ,
    input               rxdatavalid10                                     ,
    input               rxdatavalid11                                     ,
    input               rxdatavalid12                                     ,
    input               rxdatavalid13                                     ,
    input               rxdatavalid14                                     ,
    input               rxdatavalid15                                     ,

    input  [5:0]        dirfeedback0                                      ,
    input  [5:0]        dirfeedback1                                      ,
    input  [5:0]        dirfeedback2                                      ,
    input  [5:0]        dirfeedback3                                      ,
    input  [5:0]        dirfeedback4                                      ,
    input  [5:0]        dirfeedback5                                      ,
    input  [5:0]        dirfeedback6                                      ,
    input  [5:0]        dirfeedback7                                      ,
    input  [5:0]        dirfeedback8                                      ,
    input  [5:0]        dirfeedback9                                      ,
    input  [5:0]        dirfeedback10                                     ,
    input  [5:0]        dirfeedback11                                     ,
    input  [5:0]        dirfeedback12                                     ,
    input  [5:0]        dirfeedback13                                     ,
    input  [5:0]        dirfeedback14                                     ,
    input  [5:0]        dirfeedback15                                     ,


    //Serial Interface Sgnals
    output              tx_out0                                           ,
    output              tx_out1                                           ,
    output              tx_out2                                           ,
    output              tx_out3                                           ,
    output              tx_out4                                           ,
    output              tx_out5                                           ,
    output              tx_out6                                           ,
    output              tx_out7                                           ,
    output              tx_out8                                           ,
    output              tx_out9                                           ,
    output              tx_out10                                          ,
    output              tx_out11                                          ,
    output              tx_out12                                          ,
    output              tx_out13                                          ,
    output              tx_out14                                          ,
    output              tx_out15                                          ,

    input               rx_in0                                            ,
    input               rx_in1                                            ,
    input               rx_in2                                            ,
    input               rx_in3                                            ,
    input               rx_in4                                            ,
    input               rx_in5                                            ,
    input               rx_in6                                            ,
    input               rx_in7                                            ,
    input               rx_in8                                            ,
    input               rx_in9                                            ,
    input               rx_in10                                           ,
    input               rx_in11                                           ,
    input               rx_in12                                           ,
    input               rx_in13                                           ,
    input               rx_in14                                           ,
    input               rx_in15                                           ,


//Test Signals
    input    [63:0]     test_in                                           ,
    output   [6:0]      aux_test_out                                      ,
    output   [255:0]    test_out                                          ,


//rx_buffer_limit_signals
    input    [6:0]     rx_np_buffer_limit                                 ,
    input    [6:0]     rx_p_buffer_limit                                  ,
    input    [9:0]     rx_cpl_buffer_limit                                ,


  //Reconfig Interface
   input                          xcvr_reconfig_clk                       ,
   input                          xcvr_reconfig_reset                     ,
   input                          xcvr_reconfig_write                     ,
   input                          xcvr_reconfig_read                      ,
   input   [13:0]                 xcvr_reconfig_address                   ,
   input   [31:0]                 xcvr_reconfig_writedata                 ,
   output  [31:0]                 xcvr_reconfig_readdata                  ,
   output                         xcvr_reconfig_waitrequest               ,

   //FPLL Reconfig Interface
   input                          reconfig_pll0_clk                       ,     //     reconfig_clk.clk
   input                          reconfig_pll0_reset                     ,     //     reconfig_reset.reset
   input                          reconfig_pll0_write                     ,     //     reconfig_avmm.write
   input                          reconfig_pll0_read                      ,     //                 .read
   input   [10:0]                 reconfig_pll0_address                   ,     //                 .address
   input   [31:0]                 reconfig_pll0_writedata                 ,     //                 .writedata
   output  [31:0]                 reconfig_pll0_readdata                  ,     //                 .readdata
   output                         reconfig_pll0_waitrequest               ,     //                 .waitrequest
   //LC PLL Reconfig Interface
   input                          reconfig_pll1_clk                       ,     //     reconfig_clk.clk
   input                          reconfig_pll1_reset                     ,     //     reconfig_reset.reset
   input                          reconfig_pll1_write                     ,     //     reconfig_avmm.write
   input                          reconfig_pll1_read                      ,     //                 .read
   input   [10:0]                 reconfig_pll1_address                   ,     //                 .address
   input   [31:0]                 reconfig_pll1_writedata                 ,     //                 .writedata
   output  [31:0]                 reconfig_pll1_readdata                  ,     //                 .readdata
   output                         reconfig_pll1_waitrequest               ,       //


//Unused Multifunction Inputs

   input               app_int_1                                          ,
   input               app_msi_func_num                                   ,
   input  [31:0]       app_msi_pending                                    ,
   input               apps_pm_xmt_pme_1                                  ,
   input               app_req_retry_en                                   ,
   input  [6:0]        app_err_vfunc_num                                  ,
   input               app_err_func_num                                   ,
   input               app_err_vfunc_active                               ,
   input               apps_req_exit_l1                                   ,
   input               apps_req_entr_l1                                   ,
   input  [2:0]        cfg_buffer_limit_byp                               ,
   input  [2:0]        diag_ctrl_bus                                      ,
   input  [31:0]       pld_hip_reserved_in                                ,
   input               pld_ltssm_en                                       ,
   input  [7:0]        pld_gp_status                                      ,
   input  [3:0]        flr_vf_done_tdm                                    ,
   input  [7:0]        flr_vf_done                                        ,
   input  [1:0]        flr_pf_done                                        ,
   input               sys_eml_interlock_engaged                          ,
   input               sys_cmd_cpled_int                                  ,
   input               sys_pre_det_chged                                  ,
   input               sys_mrl_sensor_chged                               ,
   input               sys_pwr_fault_det                                  ,
   input               sys_mrl_sensor_state                               ,
   input               sys_pre_det_state                                  ,
   input               sys_atten_button_pressed                           ,
   input               sys_aux_pwr_det                                    ,
   input               tx_st_vf_active                                    ,
//Unused Multifunction Outputs
   output              ceb_func_num                                       ,
   output              ceb_vf_active                                      ,
   output  [6:0]       ceb_vf_num                                         ,
   output  [3:0]       flr_vf_active_tdm                                  ,
   output  [7:0]       flr_vf_active                                      ,
   output  [1:0]       flr_pf_active                                      ,
   output  [7:0]       int_status_pf1                                     ,
   output  [7:0]       pld_gp_ctrl                                        ,
   output  [30:0]      pld_hip_reserved_out                               ,
   output  [2:0]       pm_dstate_1                                        ,
   output              rx_st_vf_active                                    ,
   output              rx_st_func_num                                     ,
   output  [6:0]       rx_st_vf_num                                       ,
   output  [32:0]      sriov_test_out                                     ,
   output              serr_out_1

    );




   localparam LANES                                                   = (virtual_link_width=="x1")?1:(virtual_link_width=="x2")?2:(virtual_link_width=="x4")?4:(virtual_link_width=="x8")?8:16;
   //synthesis translate_off
   localparam ALTPCIE_HIP_256_PIPEN1B_SIM_ONLY                        = 1;
   //synthesis translate_on

   //synthesis read_comments_as_HDL on
   //localparam ALTPCIE_HIP_256_PIPEN1B_SIM_ONLY = 0;
   //synthesis read_comments_as_HDL off

   localparam USE_HARD_RESET                                          = (low_str(virtual_hrdrstctrl_en)=="enable") ? 1:0;
   localparam ST_DATA_WIDTH                                           = 256 ;
   localparam ST_BE_WIDTH                                             = 32;
   localparam ST_CTRL_WIDTH                                           = 4;

   localparam pll_refclk_freq                                         = "100 MHz"; //legal value = "100 MHz"

   localparam [255:0] ONES  = 256'HFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
   localparam [255:0] ZEROS = 256'H0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;

   localparam protocol_version  =  (low_str(virtual_link_rate)=="gen1")?"Gen 1":
                                  (low_str(virtual_link_rate)=="gen2")?"Gen 2":
                                  (low_str(virtual_link_rate)=="gen3")?"Gen 3":"<invalid>"; //legal value: "Gen 1", "Gen 2", "Gen 3"


   localparam TOTAL_LANES       =  (LANES ==16 ) ? 16:8;


   function [8*25:1] low_str;
   // Convert parameter strings to lower case
      input [8*25:1] input_string;
      reg [8*25:1] return_string;
      reg [8*25:1] reg_string;
      reg [8:1] tmp;
      reg [8:1] conv_char;
      integer byte_count;
      begin
         reg_string = input_string;
         for (byte_count = 25; byte_count >= 1; byte_count = byte_count - 1) begin
            tmp = reg_string[8*25:(8*(25-1)+1)];
            reg_string = reg_string << 8;
            if ((tmp >= 65) && (tmp <= 90)) // ASCII number of 'A' is 65, 'Z' is 90
               begin
               conv_char = tmp + 32; // 32 is the difference in the position of 'A' and 'a' in the ASCII char set
               return_string = {return_string, conv_char};
               end
            else
               return_string = {return_string, tmp};
         end
      low_str = return_string;
      end
   endfunction


   wire npor_sync;
   wire pld_in_use_hip;
   wire hip_ready_n_hip;


   altera_pcie_s10_reset_delay_sync #(
      .WIDTH_RST              (1),
      .NODENAME               ("npor_sync_altera_pcie_s10_reset_delay_sync")
   ) npor_sync_altera_pcie_s10_reset_delay_sync(
      .clk         (coreclkout_hip ),
      .rst_n       (npor),
      .srst_n      (npor_sync)
   );

   altera_std_synchronizer_nocut pld_clk_in_use_sync (.clk (coreclkout_hip), .reset_n (npor_sync), .din (pld_in_use_hip), .dout (pld_clk_inuse) );
   altera_std_synchronizer_nocut reset_status_sync (.clk (coreclkout_hip), .reset_n (npor_sync), .din (hip_ready_n_hip), .dout (reset_status) );
   ////////////////////////////////////////////////////////////////////////////////////
   //
   // HIP-AIB Mapped Signals
   //
    wire   [6:0]       l0_hip_aib_rx_data              ;
    wire   [6:0]       l1_hip_aib_rx_data              ;
    wire   [6:0]       l2_hip_aib_rx_data              ;
    wire   [6:0]       l3_hip_aib_rx_data              ;
    wire   [6:0]       l4_hip_aib_rx_data              ;
    wire   [6:0]       l5_hip_aib_rx_data              ;
    wire   [6:0]       l6_hip_aib_rx_data              ;
    wire   [6:0]       l7_hip_aib_rx_data              ;
    wire   [6:0]       l8_hip_aib_rx_data              ;
    wire   [6:0]       l9_hip_aib_rx_data              ;
    wire   [6:0]       l10_hip_aib_rx_data             ;
    wire   [6:0]       l11_hip_aib_rx_data             ;
    wire   [6:0]       l12_hip_aib_rx_data             ;
    wire   [6:0]       l13_hip_aib_rx_data             ;
    wire   [6:0]       l14_hip_aib_rx_data             ;
    wire   [6:0]       l15_hip_aib_rx_data             ;

    wire   [9:0]       l0_hip_aib_tx_data              ;
    wire   [9:0]       l1_hip_aib_tx_data              ;
    wire   [9:0]       l2_hip_aib_tx_data              ;
    wire   [9:0]       l3_hip_aib_tx_data              ;
    wire   [9:0]       l4_hip_aib_tx_data              ;
    wire   [9:0]       l5_hip_aib_tx_data              ;
    wire   [9:0]       l6_hip_aib_tx_data              ;
    wire   [9:0]       l7_hip_aib_tx_data              ;
    wire   [9:0]       l8_hip_aib_tx_data              ;
    wire   [9:0]       l9_hip_aib_tx_data              ;
    wire   [9:0]       l10_hip_aib_tx_data             ;
    wire   [9:0]       l11_hip_aib_tx_data             ;
    wire   [9:0]       l12_hip_aib_tx_data             ;
    wire   [9:0]       l13_hip_aib_tx_data             ;
    wire   [9:0]       l14_hip_aib_tx_data             ;
    wire   [9:0]       l15_hip_aib_tx_data             ;

   ////////////////////////////////////////////////////////////////////////////////////
   //
   // PCS Mapped Signals
   //
    wire   [50:0]      l0_hip_pcs_rx_data              ;
    wire   [50:0]      l1_hip_pcs_rx_data              ;
    wire   [50:0]      l2_hip_pcs_rx_data              ;
    wire   [50:0]      l3_hip_pcs_rx_data              ;
    wire   [50:0]      l4_hip_pcs_rx_data              ;
    wire   [50:0]      l5_hip_pcs_rx_data              ;
    wire   [50:0]      l6_hip_pcs_rx_data              ;
    wire   [50:0]      l7_hip_pcs_rx_data              ;
    wire   [50:0]      l8_hip_pcs_rx_data              ;
    wire   [50:0]      l9_hip_pcs_rx_data              ;
    wire   [50:0]      l10_hip_pcs_rx_data             ;
    wire   [50:0]      l11_hip_pcs_rx_data             ;
    wire   [50:0]      l12_hip_pcs_rx_data             ;
    wire   [50:0]      l13_hip_pcs_rx_data             ;
    wire   [50:0]      l14_hip_pcs_rx_data             ;
    wire   [50:0]      l15_hip_pcs_rx_data             ;

    wire   [63:0]      l0_hip_pcs_tx_data              ;
    wire   [63:0]      l1_hip_pcs_tx_data              ;
    wire   [63:0]      l2_hip_pcs_tx_data              ;
    wire   [63:0]      l3_hip_pcs_tx_data              ;
    wire   [63:0]      l4_hip_pcs_tx_data              ;
    wire   [63:0]      l5_hip_pcs_tx_data              ;
    wire   [63:0]      l6_hip_pcs_tx_data              ;
    wire   [63:0]      l7_hip_pcs_tx_data              ;
    wire   [63:0]      l8_hip_pcs_tx_data              ;
    wire   [63:0]      l9_hip_pcs_tx_data              ;
    wire   [63:0]      l10_hip_pcs_tx_data             ;
    wire   [63:0]      l11_hip_pcs_tx_data             ;
    wire   [63:0]      l12_hip_pcs_tx_data             ;
    wire   [63:0]      l13_hip_pcs_tx_data             ;
    wire   [63:0]      l14_hip_pcs_tx_data             ;
    wire   [63:0]      l15_hip_pcs_tx_data             ;


    wire   [23:0]      l0_hip_pcs_tx_async             ;
    wire   [23:0]      l1_hip_pcs_tx_async              ;
    wire   [23:0]      l2_hip_pcs_tx_async              ;
    wire   [23:0]      l3_hip_pcs_tx_async              ;
    wire   [23:0]      l4_hip_pcs_tx_async              ;
    wire   [23:0]      l5_hip_pcs_tx_async              ;
    wire   [23:0]      l6_hip_pcs_tx_async              ;
    wire   [23:0]      l7_hip_pcs_tx_async              ;
    wire   [23:0]      l8_hip_pcs_tx_async              ;
    wire   [23:0]      l9_hip_pcs_tx_async              ;
    wire   [23:0]      l10_hip_pcs_tx_async             ;
    wire   [23:0]      l11_hip_pcs_tx_async             ;
    wire   [23:0]      l12_hip_pcs_tx_async             ;
    wire   [23:0]      l13_hip_pcs_tx_async             ;
    wire   [23:0]      l14_hip_pcs_tx_async             ;
    wire   [23:0]      l15_hip_pcs_tx_async             ;


    wire   [15:0]        pll_cal_done                   ;
    wire   [15:0]        chnl_cal_done                  ;
    wire   [15:0]        tx_lcff_pll_lock               ;
    wire   [15:0]        rx_pll_freq_lock               ;
    wire   [15:0]        mask_tx_pll_lock               ;
    wire   [15:0]        rxelecidle                     ;
    wire   [15:0]        fref_clk                       ;
    wire   [1:0]         pll_fixed_clk_ch               ;
    wire   [15:0]        pclk_ch                        ;



    wire   [15:0]        serdes_pll_cal_done            ;
    wire   [15:0]        serdes_chnl_cal_done           ;
    wire   [15:0]        serdes_tx_lcff_pll_lock        ;
    wire   [15:0]        serdes_rx_pll_freq_lock        ;
    wire   [15:0]        serdes_rx_pll_phase_lock       ;
    wire   [15:0]        serdes_mask_tx_pll_lock        ;
    wire   [15:0]        serdes_rxelecidle              ;
    wire   [15:0]        serdes_fref_clk                ;
    wire   [15:0]        serdes_pll_fixed_clk           ;
    wire   [15:0]        serdes_pclk_ch                 ;


// HRC Signals

    wire   [15:0]       tx_pma_rstb         ;
    wire   [15:0]       rx_pma_rstb         ;
    wire   [15:0]       tx_pcs_rst_n        ;
    wire   [15:0]       rx_pcs_rst_n        ;
    wire   [15:0]       tx_lcff_pll_rstb    ;




    //============================
    //AIB/PCS Signal BUS from Phy
    wire   [61:0]        ch0_pcs_data_out            ;
    wire   [61:0]        ch1_pcs_data_out            ;
    wire   [61:0]        ch2_pcs_data_out            ;
    wire   [61:0]        ch3_pcs_data_out            ;
    wire   [61:0]        ch4_pcs_data_out            ;
    wire   [61:0]        ch5_pcs_data_out            ;
    wire   [61:0]        ch6_pcs_data_out            ;
    wire   [61:0]        ch7_pcs_data_out            ;
    wire   [61:0]        ch8_pcs_data_out            ;
    wire   [61:0]        ch9_pcs_data_out            ;
    wire   [61:0]        ch10_pcs_data_out           ;
    wire   [61:0]        ch11_pcs_data_out           ;
    wire   [61:0]        ch12_pcs_data_out           ;
    wire   [61:0]        ch13_pcs_data_out           ;
    wire   [61:0]        ch14_pcs_data_out           ;
    wire   [61:0]        ch15_pcs_data_out           ;

    wire   [91:0]        ch0_pcs_data_in            ;
    wire   [91:0]        ch1_pcs_data_in            ;
    wire   [91:0]        ch2_pcs_data_in            ;
    wire   [91:0]        ch3_pcs_data_in            ;
    wire   [91:0]        ch4_pcs_data_in            ;
    wire   [91:0]        ch5_pcs_data_in            ;
    wire   [91:0]        ch6_pcs_data_in            ;
    wire   [91:0]        ch7_pcs_data_in            ;
    wire   [91:0]        ch8_pcs_data_in            ;
    wire   [91:0]        ch9_pcs_data_in            ;
    wire   [91:0]        ch10_pcs_data_in           ;
    wire   [91:0]        ch11_pcs_data_in           ;
    wire   [91:0]        ch12_pcs_data_in           ;
    wire   [91:0]        ch13_pcs_data_in           ;
    wire   [91:0]        ch14_pcs_data_in           ;
    wire   [91:0]        ch15_pcs_data_in           ;

    wire   [100:0]       ch0_aib_data_in            ;
    wire   [100:0]       ch1_aib_data_in            ;
    wire   [100:0]       ch2_aib_data_in            ;
    wire   [100:0]       ch3_aib_data_in            ;
    wire   [100:0]       ch4_aib_data_in            ;
    wire   [100:0]       ch5_aib_data_in            ;
    wire   [100:0]       ch6_aib_data_in            ;
    wire   [100:0]       ch7_aib_data_in            ;
    wire   [100:0]       ch8_aib_data_in            ;
    wire   [100:0]       ch9_aib_data_in            ;
    wire   [100:0]       ch10_aib_data_in           ;
    wire   [100:0]       ch11_aib_data_in           ;
    wire   [100:0]       ch12_aib_data_in           ;
    wire   [100:0]       ch13_aib_data_in           ;
    wire   [100:0]       ch14_aib_data_in           ;
    wire   [100:0]       ch15_aib_data_in           ;

    wire   [131:0]       ch0_aib_data_out            ;
    wire   [131:0]       ch1_aib_data_out            ;
    wire   [131:0]       ch2_aib_data_out            ;
    wire   [131:0]       ch3_aib_data_out            ;
    wire   [131:0]       ch4_aib_data_out            ;
    wire   [131:0]       ch5_aib_data_out            ;
    wire   [131:0]       ch6_aib_data_out            ;
    wire   [131:0]       ch7_aib_data_out            ;
    wire   [131:0]       ch8_aib_data_out            ;
    wire   [131:0]       ch9_aib_data_out            ;
    wire   [131:0]       ch10_aib_data_out           ;
    wire   [131:0]       ch11_aib_data_out           ;
    wire   [131:0]       ch12_aib_data_out           ;
    wire   [131:0]       ch13_aib_data_out           ;
    wire   [131:0]       ch14_aib_data_out           ;
    wire   [131:0]       ch15_aib_data_out           ;


    wire   [77:0]        ch0_hip_aib_sync_data_out       ;
    wire   [77:0]        ch1_hip_aib_sync_data_out       ;
    wire   [77:0]        ch2_hip_aib_sync_data_out       ;
    wire   [77:0]        ch3_hip_aib_sync_data_out       ;
    wire   [77:0]        ch4_hip_aib_sync_data_out       ;
    wire   [77:0]        ch5_hip_aib_sync_data_out       ;
    wire   [77:0]        ch6_hip_aib_sync_data_out       ;
    wire   [77:0]        ch7_hip_aib_sync_data_out       ;
    wire   [77:0]        ch8_hip_aib_sync_data_out       ;
    wire   [77:0]        ch9_hip_aib_sync_data_out       ;
    wire   [77:0]        ch10_hip_aib_sync_data_out      ;
    wire   [77:0]        ch11_hip_aib_sync_data_out      ;
    wire   [77:0]        ch12_hip_aib_sync_data_out      ;
    wire   [77:0]        ch13_hip_aib_sync_data_out      ;
    wire   [77:0]        ch14_hip_aib_sync_data_out      ;
    wire   [77:0]        ch15_hip_aib_sync_data_out      ;

    wire   [3:0]         ch0_hip_aib_fsr_out       ;
    wire   [3:0]         ch1_hip_aib_fsr_out       ;
    wire   [3:0]         ch2_hip_aib_fsr_out       ;
    wire   [3:0]         ch3_hip_aib_fsr_out       ;
    wire   [3:0]         ch4_hip_aib_fsr_out       ;
    wire   [3:0]         ch5_hip_aib_fsr_out       ;
    wire   [3:0]         ch6_hip_aib_fsr_out       ;
    wire   [3:0]         ch7_hip_aib_fsr_out       ;
    wire   [3:0]         ch8_hip_aib_fsr_out       ;
    wire   [3:0]         ch9_hip_aib_fsr_out       ;
    wire   [3:0]         ch10_hip_aib_fsr_out      ;
    wire   [3:0]         ch11_hip_aib_fsr_out      ;
    wire   [3:0]         ch12_hip_aib_fsr_out      ;
    wire   [3:0]         ch13_hip_aib_fsr_out      ;
    wire   [3:0]         ch14_hip_aib_fsr_out      ;
    wire   [3:0]         ch15_hip_aib_fsr_out      ;



    wire   [3:0]         ch0_hip_aib_ssr_out       ;
    wire   [3:0]         ch1_hip_aib_ssr_out       ;
    wire   [3:0]         ch2_hip_aib_ssr_out       ;
    wire   [3:0]         ch3_hip_aib_ssr_out       ;
    wire   [3:0]         ch4_hip_aib_ssr_out       ;
    wire   [3:0]         ch5_hip_aib_ssr_out       ;
    wire   [3:0]         ch6_hip_aib_ssr_out       ;
    wire   [3:0]         ch7_hip_aib_ssr_out       ;
    wire   [3:0]         ch8_hip_aib_ssr_out       ;
    wire   [3:0]         ch9_hip_aib_ssr_out       ;
    wire   [3:0]         ch10_hip_aib_ssr_out      ;
    wire   [3:0]         ch11_hip_aib_ssr_out      ;
    wire   [3:0]         ch12_hip_aib_ssr_out      ;
    wire   [3:0]         ch13_hip_aib_ssr_out      ;
    wire   [3:0]         ch14_hip_aib_ssr_out      ;
    wire   [3:0]         ch15_hip_aib_ssr_out      ;



    wire                 ch0_hip_aib_clk       ;
    wire                 ch1_hip_aib_clk       ;
    wire                 ch2_hip_aib_clk       ;
    wire                 ch3_hip_aib_clk       ;
    wire                 ch4_hip_aib_clk       ;
    wire                 ch5_hip_aib_clk       ;
    wire                 ch6_hip_aib_clk       ;
    wire                 ch7_hip_aib_clk       ;
    wire                 ch8_hip_aib_clk       ;
    wire                 ch9_hip_aib_clk       ;
    wire                 ch10_hip_aib_clk      ;
    wire                 ch11_hip_aib_clk      ;
    wire                 ch12_hip_aib_clk      ;
    wire                 ch13_hip_aib_clk      ;
    wire                 ch14_hip_aib_clk      ;
    wire                 ch15_hip_aib_clk      ;



    wire                 ch0_hip_aib_clk_2x       ;
    wire                 ch1_hip_aib_clk_2x       ;
    wire                 ch2_hip_aib_clk_2x       ;
    wire                 ch3_hip_aib_clk_2x       ;
    wire                 ch4_hip_aib_clk_2x       ;
    wire                 ch5_hip_aib_clk_2x       ;
    wire                 ch6_hip_aib_clk_2x       ;
    wire                 ch7_hip_aib_clk_2x       ;
    wire                 ch8_hip_aib_clk_2x       ;
    wire                 ch9_hip_aib_clk_2x       ;
    wire                 ch10_hip_aib_clk_2x      ;
    wire                 ch11_hip_aib_clk_2x      ;
    wire                 ch12_hip_aib_clk_2x      ;
    wire                 ch13_hip_aib_clk_2x      ;
    wire                 ch14_hip_aib_clk_2x      ;
    wire                 ch15_hip_aib_clk_2x      ;


    wire   [9:0]         ch0_hip_aib_txeq_out       ;
    wire   [9:0]         ch1_hip_aib_txeq_out       ;
    wire   [9:0]         ch2_hip_aib_txeq_out       ;
    wire   [9:0]         ch3_hip_aib_txeq_out       ;
    wire   [9:0]         ch4_hip_aib_txeq_out       ;
    wire   [9:0]         ch5_hip_aib_txeq_out       ;
    wire   [9:0]         ch6_hip_aib_txeq_out       ;
    wire   [9:0]         ch7_hip_aib_txeq_out       ;
    wire   [9:0]         ch8_hip_aib_txeq_out       ;
    wire   [9:0]         ch9_hip_aib_txeq_out       ;
    wire   [9:0]         ch10_hip_aib_txeq_out      ;
    wire   [9:0]         ch11_hip_aib_txeq_out      ;
    wire   [9:0]         ch12_hip_aib_txeq_out      ;
    wire   [9:0]         ch13_hip_aib_txeq_out      ;
    wire   [9:0]         ch14_hip_aib_txeq_out      ;
    wire   [9:0]         ch15_hip_aib_txeq_out      ;



    wire                 ch0_hip_aib_txeq_clk_out       ;
    wire                 ch1_hip_aib_txeq_clk_out       ;
    wire                 ch2_hip_aib_txeq_clk_out       ;
    wire                 ch3_hip_aib_txeq_clk_out       ;
    wire                 ch4_hip_aib_txeq_clk_out       ;
    wire                 ch5_hip_aib_txeq_clk_out       ;
    wire                 ch6_hip_aib_txeq_clk_out       ;
    wire                 ch7_hip_aib_txeq_clk_out       ;
    wire                 ch8_hip_aib_txeq_clk_out       ;
    wire                 ch9_hip_aib_txeq_clk_out       ;
    wire                 ch10_hip_aib_txeq_clk_out      ;
    wire                 ch11_hip_aib_txeq_clk_out      ;
    wire                 ch12_hip_aib_txeq_clk_out      ;
    wire                 ch13_hip_aib_txeq_clk_out      ;
    wire                 ch14_hip_aib_txeq_clk_out      ;
    wire                 ch15_hip_aib_txeq_clk_out      ;


    wire                 ch0_hip_aib_txeq_rst_n       ;
    wire                 ch1_hip_aib_txeq_rst_n       ;
    wire                 ch2_hip_aib_txeq_rst_n       ;
    wire                 ch3_hip_aib_txeq_rst_n       ;
    wire                 ch4_hip_aib_txeq_rst_n       ;
    wire                 ch5_hip_aib_txeq_rst_n       ;
    wire                 ch6_hip_aib_txeq_rst_n       ;
    wire                 ch7_hip_aib_txeq_rst_n       ;
    wire                 ch8_hip_aib_txeq_rst_n       ;
    wire                 ch9_hip_aib_txeq_rst_n       ;
    wire                 ch10_hip_aib_txeq_rst_n      ;
    wire                 ch11_hip_aib_txeq_rst_n      ;
    wire                 ch12_hip_aib_txeq_rst_n      ;
    wire                 ch13_hip_aib_txeq_rst_n      ;
    wire                 ch14_hip_aib_txeq_rst_n      ;
    wire                 ch15_hip_aib_txeq_rst_n      ;

    wire                 ch0_hip_aib_async_out       ;
    wire                 ch1_hip_aib_async_out       ;
    wire                 ch2_hip_aib_async_out       ;
    wire                 ch3_hip_aib_async_out       ;
    wire                 ch4_hip_aib_async_out       ;
    wire                 ch5_hip_aib_async_out       ;
    wire                 ch6_hip_aib_async_out       ;
    wire                 ch7_hip_aib_async_out       ;
    wire                 ch8_hip_aib_async_out       ;
    wire                 ch9_hip_aib_async_out       ;
    wire                 ch10_hip_aib_async_out      ;
    wire                 ch11_hip_aib_async_out      ;
    wire                 ch12_hip_aib_async_out      ;
    wire                 ch13_hip_aib_async_out      ;
    wire                 ch14_hip_aib_async_out      ;
    wire                 ch15_hip_aib_async_out      ;


    wire   [77:0]        ch0_hip_aib_sync_data_in        ;
    wire   [77:0]        ch1_hip_aib_sync_data_in        ;
    wire   [77:0]        ch2_hip_aib_sync_data_in        ;
    wire   [77:0]        ch3_hip_aib_sync_data_in        ;
    wire   [77:0]        ch4_hip_aib_sync_data_in        ;
    wire   [77:0]        ch5_hip_aib_sync_data_in        ;
    wire   [77:0]        ch6_hip_aib_sync_data_in        ;
    wire   [77:0]        ch7_hip_aib_sync_data_in        ;
    wire   [77:0]        ch8_hip_aib_sync_data_in        ;
    wire   [77:0]        ch9_hip_aib_sync_data_in        ;
    wire   [77:0]        ch10_hip_aib_sync_data_in       ;
    wire   [77:0]        ch11_hip_aib_sync_data_in       ;
    wire   [77:0]        ch12_hip_aib_sync_data_in       ;
    wire   [77:0]        ch13_hip_aib_sync_data_in       ;
    wire   [77:0]        ch14_hip_aib_sync_data_in       ;
    wire   [77:0]        ch15_hip_aib_sync_data_in       ;


    wire   [3:0]         ch0_hip_aib_fsr_in       ;
    wire   [3:0]         ch1_hip_aib_fsr_in       ;
    wire   [3:0]         ch2_hip_aib_fsr_in       ;
    wire   [3:0]         ch3_hip_aib_fsr_in       ;
    wire   [3:0]         ch4_hip_aib_fsr_in       ;
    wire   [3:0]         ch5_hip_aib_fsr_in       ;
    wire   [3:0]         ch6_hip_aib_fsr_in       ;
    wire   [3:0]         ch7_hip_aib_fsr_in       ;
    wire   [3:0]         ch8_hip_aib_fsr_in       ;
    wire   [3:0]         ch9_hip_aib_fsr_in       ;
    wire   [3:0]         ch10_hip_aib_fsr_in      ;
    wire   [3:0]         ch11_hip_aib_fsr_in      ;
    wire   [3:0]         ch12_hip_aib_fsr_in      ;
    wire   [3:0]         ch13_hip_aib_fsr_in      ;
    wire   [3:0]         ch14_hip_aib_fsr_in      ;
    wire   [3:0]         ch15_hip_aib_fsr_in      ;



    wire   [39:0]         ch0_hip_aib_ssr_in       ;
    wire   [39:0]         ch1_hip_aib_ssr_in       ;
    wire   [39:0]         ch2_hip_aib_ssr_in       ;
    wire   [39:0]         ch3_hip_aib_ssr_in       ;
    wire   [39:0]         ch4_hip_aib_ssr_in       ;
    wire   [39:0]         ch5_hip_aib_ssr_in       ;
    wire   [39:0]         ch6_hip_aib_ssr_in       ;
    wire   [39:0]         ch7_hip_aib_ssr_in       ;
    wire   [39:0]         ch8_hip_aib_ssr_in       ;
    wire   [39:0]         ch9_hip_aib_ssr_in       ;
    wire   [39:0]         ch10_hip_aib_ssr_in      ;
    wire   [39:0]         ch11_hip_aib_ssr_in      ;
    wire   [39:0]         ch12_hip_aib_ssr_in      ;
    wire   [39:0]         ch13_hip_aib_ssr_in      ;
    wire   [39:0]         ch14_hip_aib_ssr_in      ;
    wire   [39:0]         ch15_hip_aib_ssr_in      ;


    wire   [2:0]         ch0_hip_aib_status      ;
    wire   [2:0]         ch1_hip_aib_status      ;
    wire   [2:0]         ch2_hip_aib_status      ;
    wire   [2:0]         ch3_hip_aib_status      ;
    wire   [2:0]         ch4_hip_aib_status      ;
    wire   [2:0]         ch5_hip_aib_status      ;
    wire   [2:0]         ch6_hip_aib_status      ;
    wire   [2:0]         ch7_hip_aib_status      ;
    wire   [2:0]         ch8_hip_aib_status      ;
    wire   [2:0]         ch9_hip_aib_status      ;
    wire   [2:0]         ch10_hip_aib_status     ;
    wire   [2:0]         ch11_hip_aib_status     ;
    wire   [2:0]         ch12_hip_aib_status     ;
    wire   [2:0]         ch13_hip_aib_status     ;
    wire   [2:0]         ch14_hip_aib_status     ;
    wire   [2:0]         ch15_hip_aib_status     ;

    wire   [6:0]         ch0_aib_hip_txeq_in     ;
    wire   [6:0]         ch1_aib_hip_txeq_in     ;
    wire   [6:0]         ch2_aib_hip_txeq_in     ;
    wire   [6:0]         ch3_aib_hip_txeq_in     ;
    wire   [6:0]         ch4_aib_hip_txeq_in     ;
    wire   [6:0]         ch5_aib_hip_txeq_in     ;
    wire   [6:0]         ch6_aib_hip_txeq_in     ;
    wire   [6:0]         ch7_aib_hip_txeq_in     ;
    wire   [6:0]         ch8_aib_hip_txeq_in     ;
    wire   [6:0]         ch9_aib_hip_txeq_in     ;
    wire   [6:0]         ch10_aib_hip_txeq_in    ;
    wire   [6:0]         ch11_aib_hip_txeq_in    ;
    wire   [6:0]         ch12_aib_hip_txeq_in    ;
    wire   [6:0]         ch13_aib_hip_txeq_in    ;
    wire   [6:0]         ch14_aib_hip_txeq_in    ;
    wire   [6:0]         ch15_aib_hip_txeq_in    ;
//AIB PLD Signals
    wire   [77:0]        ch0_tx_parallel_data              ;
    wire   [77:0]        ch1_tx_parallel_data              ;
    wire   [77:0]        ch2_tx_parallel_data              ;
    wire   [77:0]        ch3_tx_parallel_data              ;
    wire   [77:0]        ch4_tx_parallel_data              ;
    wire   [77:0]        ch5_tx_parallel_data              ;
    wire   [77:0]        ch6_tx_parallel_data              ;
    wire   [77:0]        ch7_tx_parallel_data              ;
    wire   [77:0]        ch8_tx_parallel_data              ;
    wire   [77:0]        ch9_tx_parallel_data              ;
    wire   [77:0]        ch10_tx_parallel_data             ;
    wire   [77:0]        ch11_tx_parallel_data             ;
    wire   [77:0]        ch12_tx_parallel_data             ;
    wire   [77:0]        ch13_tx_parallel_data             ;
    wire   [77:0]        ch14_tx_parallel_data             ;
    wire   [77:0]        ch15_tx_parallel_data             ;


    wire   [77:0]        ch0_rx_parallel_data              ;
    wire   [77:0]        ch1_rx_parallel_data              ;
    wire   [77:0]        ch2_rx_parallel_data              ;
    wire   [77:0]        ch3_rx_parallel_data              ;
    wire   [77:0]        ch4_rx_parallel_data              ;
    wire   [77:0]        ch5_rx_parallel_data              ;
    wire   [77:0]        ch6_rx_parallel_data              ;
    wire   [77:0]        ch7_rx_parallel_data              ;
    wire   [77:0]        ch8_rx_parallel_data              ;
    wire   [77:0]        ch9_rx_parallel_data              ;
    wire   [77:0]        ch10_rx_parallel_data             ;
    wire   [77:0]        ch11_rx_parallel_data             ;
    wire   [77:0]        ch12_rx_parallel_data             ;
    wire   [77:0]        ch13_rx_parallel_data             ;
    wire   [77:0]        ch14_rx_parallel_data             ;
    wire   [77:0]        ch15_rx_parallel_data             ;

    wire   [79:0]        ch0_tx_parallel_data_int              ;
    wire   [79:0]        ch1_tx_parallel_data_int              ;
    wire   [79:0]        ch2_tx_parallel_data_int              ;
    wire   [79:0]        ch3_tx_parallel_data_int              ;
    wire   [79:0]        ch4_tx_parallel_data_int              ;
    wire   [79:0]        ch5_tx_parallel_data_int              ;
    wire   [79:0]        ch6_tx_parallel_data_int              ;
    wire   [79:0]        ch7_tx_parallel_data_int              ;
    wire   [79:0]        ch8_tx_parallel_data_int              ;
    wire   [79:0]        ch9_tx_parallel_data_int              ;
    wire   [79:0]        ch10_tx_parallel_data_int             ;
    wire   [79:0]        ch11_tx_parallel_data_int             ;
    wire   [79:0]        ch12_tx_parallel_data_int             ;
    wire   [79:0]        ch13_tx_parallel_data_int             ;
    wire   [79:0]        ch14_tx_parallel_data_int             ;
    wire   [79:0]        ch15_tx_parallel_data_int             ;


    wire   [79:0]        ch0_rx_parallel_data_int              ;
    wire   [79:0]        ch1_rx_parallel_data_int              ;
    wire   [79:0]        ch2_rx_parallel_data_int              ;
    wire   [79:0]        ch3_rx_parallel_data_int              ;
    wire   [79:0]        ch4_rx_parallel_data_int              ;
    wire   [79:0]        ch5_rx_parallel_data_int              ;
    wire   [79:0]        ch6_rx_parallel_data_int              ;
    wire   [79:0]        ch7_rx_parallel_data_int              ;
    wire   [79:0]        ch8_rx_parallel_data_int              ;
    wire   [79:0]        ch9_rx_parallel_data_int              ;
    wire   [79:0]        ch10_rx_parallel_data_int             ;
    wire   [79:0]        ch11_rx_parallel_data_int             ;
    wire   [79:0]        ch12_rx_parallel_data_int             ;
    wire   [79:0]        ch13_rx_parallel_data_int             ;
    wire   [79:0]        ch14_rx_parallel_data_int             ;
    wire   [79:0]        ch15_rx_parallel_data_int             ;


    wire   [3:0]         ch0_pld_aib_fsr_out       ;
    wire   [3:0]         ch1_pld_aib_fsr_out       ;
    wire   [3:0]         ch2_pld_aib_fsr_out       ;
    wire   [3:0]         ch3_pld_aib_fsr_out       ;
    wire   [3:0]         ch4_pld_aib_fsr_out       ;
    wire   [3:0]         ch5_pld_aib_fsr_out       ;
    wire   [3:0]         ch6_pld_aib_fsr_out       ;
    wire   [3:0]         ch7_pld_aib_fsr_out       ;
    wire   [3:0]         ch8_pld_aib_fsr_out       ;
    wire   [3:0]         ch9_pld_aib_fsr_out       ;
    wire   [3:0]         ch10_pld_aib_fsr_out      ;
    wire   [3:0]         ch11_pld_aib_fsr_out      ;
    wire   [3:0]         ch12_pld_aib_fsr_out      ;
    wire   [3:0]         ch13_pld_aib_fsr_out      ;
    wire   [3:0]         ch14_pld_aib_fsr_out      ;
    wire   [3:0]         ch15_pld_aib_fsr_out      ;



    wire   [3:0]         ch0_pld_aib_ssr_out       ;
    wire   [3:0]         ch1_pld_aib_ssr_out       ;
    wire   [3:0]         ch2_pld_aib_ssr_out       ;
    wire   [3:0]         ch3_pld_aib_ssr_out       ;
    wire   [3:0]         ch4_pld_aib_ssr_out       ;
    wire   [3:0]         ch5_pld_aib_ssr_out       ;
    wire   [3:0]         ch6_pld_aib_ssr_out       ;
    wire   [3:0]         ch7_pld_aib_ssr_out       ;
    wire   [3:0]         ch8_pld_aib_ssr_out       ;
    wire   [3:0]         ch9_pld_aib_ssr_out       ;
    wire   [3:0]         ch10_pld_aib_ssr_out      ;
    wire   [3:0]         ch11_pld_aib_ssr_out      ;
    wire   [3:0]         ch12_pld_aib_ssr_out      ;
    wire   [3:0]         ch13_pld_aib_ssr_out      ;
    wire   [3:0]         ch14_pld_aib_ssr_out      ;
    wire   [3:0]         ch15_pld_aib_ssr_out      ;




    wire   [3:0]         ch0_pld_aib_fsr_in       ;
    wire   [3:0]         ch1_pld_aib_fsr_in       ;
    wire   [3:0]         ch2_pld_aib_fsr_in       ;
    wire   [3:0]         ch3_pld_aib_fsr_in       ;
    wire   [3:0]         ch4_pld_aib_fsr_in       ;
    wire   [3:0]         ch5_pld_aib_fsr_in       ;
    wire   [3:0]         ch6_pld_aib_fsr_in       ;
    wire   [3:0]         ch7_pld_aib_fsr_in       ;
    wire   [3:0]         ch8_pld_aib_fsr_in       ;
    wire   [3:0]         ch9_pld_aib_fsr_in       ;
    wire   [3:0]         ch10_pld_aib_fsr_in      ;
    wire   [3:0]         ch11_pld_aib_fsr_in      ;
    wire   [3:0]         ch12_pld_aib_fsr_in      ;
    wire   [3:0]         ch13_pld_aib_fsr_in      ;
    wire   [3:0]         ch14_pld_aib_fsr_in      ;
    wire   [3:0]         ch15_pld_aib_fsr_in      ;



    wire   [39:0]         ch0_pld_aib_ssr_in       ;
    wire   [39:0]         ch1_pld_aib_ssr_in       ;
    wire   [39:0]         ch2_pld_aib_ssr_in       ;
    wire   [39:0]         ch3_pld_aib_ssr_in       ;
    wire   [39:0]         ch4_pld_aib_ssr_in       ;
    wire   [39:0]         ch5_pld_aib_ssr_in       ;
    wire   [39:0]         ch6_pld_aib_ssr_in       ;
    wire   [39:0]         ch7_pld_aib_ssr_in       ;
    wire   [39:0]         ch8_pld_aib_ssr_in       ;
    wire   [39:0]         ch9_pld_aib_ssr_in       ;
    wire   [39:0]         ch10_pld_aib_ssr_in      ;
    wire   [39:0]         ch11_pld_aib_ssr_in      ;
    wire   [39:0]         ch12_pld_aib_ssr_in      ;
    wire   [39:0]         ch13_pld_aib_ssr_in      ;
    wire   [39:0]         ch14_pld_aib_ssr_in      ;
    wire   [39:0]         ch15_pld_aib_ssr_in      ;

    wire                  txeq_clk_out             ;
    wire                  hip_pld_clk_out          ;
    wire                  hip_pld_clk_out_2x       ;
    wire                  hip_core_clk_out         ;
    wire   [6:0]          hip_aux_test_out         ;

    //Signals for Deskew Logic

    wire   [3:0]         rx_st_sop_undsk          ;
    wire                 rx_st_eop_undsk          ;
    wire   [255:0]       rx_st_data_undsk         ;
    wire                 rx_st_valid_undsk        ;
    wire   [31:0]        rx_st_parity_undsk       ;
    wire   [2:0]         rx_st_bar_range_undsk    ;
    wire   [2:0]         rx_st_empty_undsk        ;
    wire                 rx_par_err_undsk         ;
    wire                 rx_st_vf_active_undsk    ;
    wire                 rx_st_func_num_undsk     ;
    wire   [6:0]         rx_st_vf_num_undsk       ;
    wire   [1:0]         rx_dsk_status            ;
    wire                 rx_dsk_eval_done         ;
    wire                 tx_st_ready_undsk        ;
    wire                 tx_st_sop_undsk          ;
    wire                 tx_st_eop_undsk          ;
    wire   [255:0]       tx_st_data_undsk         ;
    wire                 tx_st_valid_undsk        ;
    wire   [32:0]        tx_st_parity_undsk       ;
    wire                 tx_st_err_undsk          ;
    wire                 tx_st_vf_active_undsk    ;
    wire   [1:0]         tx_dsk_status            ;
    wire                 tx_dsk_eval_done         ;
    reg                  tx_st_sop_dummy          ;
    reg                  dummy_sop_sent           ;

 //To get negotiated link width and current speed
    reg   [1:0]          currentspeed_reg;
    wire  [1:0]          pm_status               ;
    wire  [1:0]          pm_pme_en               ;
    wire                 pm_linkst_l2_exit       ;
    wire                 pm_linkst_in_l2         ;
    wire  [5:0]          nego_link_width         ;

// AVMM Interface Signals
    // To/From XCVR ATOM
    wire             user_avmm_writedone_int      ;
    wire             user_avmm_read_int           ;
    wire  [20:0]     user_avmm_addr_int           ;
    wire             user_avmm_write_int          ;
    wire  [7:0]      user_avmm_writedata_int      ;
    wire             user_avmm_readdatavalid_int  ;
    wire  [7:0]      user_avmm_readdata_int       ;
    // To/From HIP
    wire             hip_avmm_read                ;
    wire             hip_avmm_write               ;
    wire  [20:0]     hip_avmm_reg_addr            ;
    wire  [7 :0]     hip_avmm_writedata           ;
    wire  [7 :0]     hip_avmm_readdata            ;
    wire             hip_avmm_readdatavalid       ;
    wire             hip_avmm_writedone           ;
    wire             hip_aib_avmm_clk             ;
    wire  [30:0]     hip_aib_avmm_in              ;
    wire  [14:0]     hip_aib_avmm_out             ;

//PLLnPHY singals
//PLD AIB
   wire [TOTAL_LANES*80-1:0]    pllnphy_tx_parallel_data         ;
   wire [TOTAL_LANES*80-1:0]    pllnphy_rx_parallel_data         ;
   wire [TOTAL_LANES*4-1:0]     pllnphy_pld_aib_fsr_in           ;
   wire [TOTAL_LANES*40-1:0]    pllnphy_pld_aib_ssr_in           ;
   wire [TOTAL_LANES*4-1:0]     pllnphy_pld_aib_fsr_out          ;
   wire [TOTAL_LANES*8-1:0]     pllnphy_pld_aib_ssr_out          ;
//HIP AIB
   wire [TOTAL_LANES*101-1:0]   pllnphy_hip_aib_data_in          ;
   wire [TOTAL_LANES*132-1:0]   pllnphy_hip_aib_data_out         ;
// AIB PCS
   wire [TOTAL_LANES*92-1:0]    pllnphy_hip_pcs_data_in          ;
   wire [TOTAL_LANES*62-1:0]    pllnphy_hip_pcs_data_out         ;
// Pll and MCGB
   wire                         pllnphy_tx_fpll_rstb             ;
   wire                         pllnphy_tx_lcpll_rstb            ;
   wire                         pllnphy_pll_locked_lcpll         ;
   wire                         pllnphy_pll_locked_lcpll_to_pld  ;
   wire                         pllnphy_pll_cal_done_lcpll       ;
   wire                         pllnphy_pll_locked_fpll          ;
   wire                         pllnphy_pll_locked_fpll_to_pld   ;
   wire                         pllnphy_pll_cal_done_fpll        ;
   wire                         pllnphy_mcgb_rst                 ;
   wire [TOTAL_LANES-1:0]       pllnphy_tx_serial_data           ;
   wire [TOTAL_LANES-1:0]       pllnphy_rx_serial_data           ;
   wire [TOTAL_LANES-1:0]       pllnphy_tx_clkout                ;
   wire [TOTAL_LANES-1:0]       pllnphy_chnl_cal_done            ;
 //Simulation Only Clocks
   wire                        clk125_out                       ;
   wire                        clk250_out                       ;
   wire                        clk500_out                       ;
   wire                        clk1000_out                      ;




//Channel AIB/PCS Signal BreakDown
//[100:0] aib_data_in
//                                [77:0]              in_hip_aib_sync_data_out
//                                [81:78]             in_aib_hssi_hip_aib_fsr_out
//                                [85:82]             in_aib_hssi_hip_aib_ssr_out
//                                [86]                in_hip_aib_clk
//                                [87]                in_hip_aib_clk_2x
//                                [97:88]             in_hip_aib_txeq_out
//                                [98]                in_hip_aib_txeq_clk_out
//                                [99]                in_hip_aib_txeq_rst_n
//                                [100]               in_hip_aib_async_out
//
//[131:0] aib_data_out
//                                [77:0]              out_hip_aib_sync_data_in
//                                [81:78]             out_aibhssi_hip_aib_fsr_in
//                                [121:82]            out_aibhssi_hip_aib_ssr_in
//                                [124:122]           out_hip_aib_status
//                                [131:125]           out_aib_hip_txeq_in
//
//[91:0]  pcs_data_in
//                                [63:0]              in_hip_tx_data
//                                [64]                in_pcs_pld_8g_g3_rx_pld_rst_n
//                                [65]                in_pcs_pld_8g_g3_tx_pld_rst_n
//                                [66]                in_pld_pma_rxpma_rstb
//                                [67]                in_pld_pma_txpma_rstb
//                                [69:68]             in_pld_rate
//                                [70]                in_pld_8g_rxpolarity
//                                [73:71]             in_pld_g3_current_rxpreset
//                                [91:74]             in_pld_g3_current_coeff
//
//[61:0]  pcs_data_out
//                                [50:0]              int_out_hip_rx_data;
//                                [58:51]             int_out_hip_ctrl_out;
//                                [61:59]             int_out_hip_clk_out;
//
//


// ch0_pcs_chnl_hip_clk_out[2]          fref_clk[0]
// ch0_pcs_chnl_hip_clk_out[1]          pll_fixed_clk_ch[0]
// ch0_pcs_chnl_hip_clk_out[0]          pclk_ch[0]
//
//
//assign  pll_cal_done            = (k_hrc_chnl_en==1'b1) ? pcs_chnl_hip_ctrl_out[7] : 1'b1;
//assign  chnl_cal_done           = (k_hrc_chnl_en==1'b1) ? pcs_chnl_hip_ctrl_out[6] : 1'b1;
//assign  tx_lcff_pll_lock        = (k_hrc_chnl_en==1'b1) ? pcs_chnl_hip_ctrl_out[5] : 1'b1;
//assign  rx_pll_freq_lock        = (k_hrc_chnl_en==1'b1) ? pcs_chnl_hip_ctrl_out[4] : 1'b1; //Locked-to-reference
//assign  rx_pll_phase_lock       = (k_hrc_chnl_en==1'b1) ? pcs_chnl_hip_ctrl_out[3] : 1'b1; //Locked-to-data
//assign  mask_tx_pll_lock        = (k_hrc_chnl_en==1'b1) ? pcs_chnl_hip_ctrl_out[2] : 1'b1;
//assign  rxelecidle              = (k_hrc_chnl_en==1'b1) ? pcs_chnl_hip_ctrl_out[1] : 1'b1;
//assign  rxfreqlocked            = (k_hrc_chnl_en==1'b1) ? pcs_chnl_hip_ctrl_out[0] : 1'b1; // Usused port



   assign ch0_pcs_data_in     = {  l0_hip_pcs_tx_async ,  tx_pma_rstb[0] , rx_pma_rstb[0] , tx_pcs_rst_n[0] , rx_pcs_rst_n[0] , l0_hip_pcs_tx_data   } ;
   assign ch1_pcs_data_in     = {  l1_hip_pcs_tx_async ,  tx_pma_rstb[1] , rx_pma_rstb[1] , tx_pcs_rst_n[1] , rx_pcs_rst_n[1] , l1_hip_pcs_tx_data   } ;
   assign ch2_pcs_data_in     = {  l2_hip_pcs_tx_async ,  tx_pma_rstb[2] , rx_pma_rstb[2] , tx_pcs_rst_n[2] , rx_pcs_rst_n[2] , l2_hip_pcs_tx_data   } ;
   assign ch3_pcs_data_in     = {  l3_hip_pcs_tx_async ,  tx_pma_rstb[3] , rx_pma_rstb[3] , tx_pcs_rst_n[3] , rx_pcs_rst_n[3] , l3_hip_pcs_tx_data   } ;
   assign ch4_pcs_data_in     = {  l4_hip_pcs_tx_async ,  tx_pma_rstb[4] , rx_pma_rstb[4] , tx_pcs_rst_n[4] , rx_pcs_rst_n[4] , l4_hip_pcs_tx_data   } ;
   assign ch5_pcs_data_in     = {  l5_hip_pcs_tx_async ,  tx_pma_rstb[5] , rx_pma_rstb[5] , tx_pcs_rst_n[5] , rx_pcs_rst_n[5] , l5_hip_pcs_tx_data   } ;
   assign ch6_pcs_data_in     = {  l6_hip_pcs_tx_async ,  tx_pma_rstb[6] , rx_pma_rstb[6] , tx_pcs_rst_n[6] , rx_pcs_rst_n[6] , l6_hip_pcs_tx_data   } ;
   assign ch7_pcs_data_in     = {  l7_hip_pcs_tx_async ,  tx_pma_rstb[7] , rx_pma_rstb[7] , tx_pcs_rst_n[7] , rx_pcs_rst_n[7] , l7_hip_pcs_tx_data   } ;
   assign ch8_pcs_data_in     = {  l8_hip_pcs_tx_async ,  tx_pma_rstb[8] , rx_pma_rstb[8] , tx_pcs_rst_n[8] , rx_pcs_rst_n[8] , l8_hip_pcs_tx_data   } ;
   assign ch9_pcs_data_in     = {  l9_hip_pcs_tx_async ,  tx_pma_rstb[9] , rx_pma_rstb[9] , tx_pcs_rst_n[9] , rx_pcs_rst_n[9] , l9_hip_pcs_tx_data   } ;
   assign ch10_pcs_data_in    = {  l10_hip_pcs_tx_async,  tx_pma_rstb[10], rx_pma_rstb[10], tx_pcs_rst_n[10], rx_pcs_rst_n[10], l10_hip_pcs_tx_data  } ;
   assign ch11_pcs_data_in    = {  l11_hip_pcs_tx_async,  tx_pma_rstb[11], rx_pma_rstb[11], tx_pcs_rst_n[11], rx_pcs_rst_n[11], l11_hip_pcs_tx_data  } ;
   assign ch12_pcs_data_in    = {  l12_hip_pcs_tx_async,  tx_pma_rstb[12], rx_pma_rstb[12], tx_pcs_rst_n[12], rx_pcs_rst_n[12], l12_hip_pcs_tx_data  } ;
   assign ch13_pcs_data_in    = {  l13_hip_pcs_tx_async,  tx_pma_rstb[13], rx_pma_rstb[13], tx_pcs_rst_n[13], rx_pcs_rst_n[13], l13_hip_pcs_tx_data  } ;
   assign ch14_pcs_data_in    = {  l14_hip_pcs_tx_async,  tx_pma_rstb[14], rx_pma_rstb[14], tx_pcs_rst_n[14], rx_pcs_rst_n[14], l14_hip_pcs_tx_data  } ;
   assign ch15_pcs_data_in    = {  l15_hip_pcs_tx_async,  tx_pma_rstb[15], rx_pma_rstb[15], tx_pcs_rst_n[15], rx_pcs_rst_n[15], l15_hip_pcs_tx_data  } ;



   assign  ch0_hip_aib_sync_data_in     =  ch0_aib_data_out[77:0]       ;
   assign  ch1_hip_aib_sync_data_in     =  ch1_aib_data_out[77:0]       ;
   assign  ch2_hip_aib_sync_data_in     =  ch2_aib_data_out[77:0]       ;
   assign  ch3_hip_aib_sync_data_in     =  ch3_aib_data_out[77:0]       ;
   assign  ch4_hip_aib_sync_data_in     =  ch4_aib_data_out[77:0]       ;
   assign  ch5_hip_aib_sync_data_in     =  ch5_aib_data_out[77:0]       ;
   assign  ch6_hip_aib_sync_data_in     =  ch6_aib_data_out[77:0]       ;
   assign  ch7_hip_aib_sync_data_in     =  ch7_aib_data_out[77:0]       ;
   assign  ch8_hip_aib_sync_data_in     =  ch8_aib_data_out[77:0]       ;
   assign  ch9_hip_aib_sync_data_in     =  ch9_aib_data_out[77:0]       ;
   assign  ch10_hip_aib_sync_data_in    =  ch10_aib_data_out[77:0]      ;
   assign  ch11_hip_aib_sync_data_in    =  ch11_aib_data_out[77:0]      ;
   assign  ch12_hip_aib_sync_data_in    =  ch12_aib_data_out[77:0]      ;
   assign  ch13_hip_aib_sync_data_in    =  ch13_aib_data_out[77:0]      ;
   assign  ch14_hip_aib_sync_data_in    =  ch14_aib_data_out[77:0]      ;
   assign  ch15_hip_aib_sync_data_in    =  ch15_aib_data_out[77:0]      ;

   assign  ch0_hip_aib_fsr_in           =  ch0_aib_data_out[81:78]       ;
   assign  ch1_hip_aib_fsr_in           =  ch1_aib_data_out[81:78]       ;
   assign  ch2_hip_aib_fsr_in           =  ch2_aib_data_out[81:78]       ;
   assign  ch3_hip_aib_fsr_in           =  ch3_aib_data_out[81:78]       ;
   assign  ch4_hip_aib_fsr_in           =  ch4_aib_data_out[81:78]       ;
   assign  ch5_hip_aib_fsr_in           =  ch5_aib_data_out[81:78]       ;
   assign  ch6_hip_aib_fsr_in           =  ch6_aib_data_out[81:78]       ;
   assign  ch7_hip_aib_fsr_in           =  ch7_aib_data_out[81:78]       ;
   assign  ch8_hip_aib_fsr_in           =  ch8_aib_data_out[81:78]       ;
   assign  ch9_hip_aib_fsr_in           =  ch9_aib_data_out[81:78]       ;
   assign  ch10_hip_aib_fsr_in          =  ch10_aib_data_out[81:78]      ;
   assign  ch11_hip_aib_fsr_in          =  ch11_aib_data_out[81:78]      ;
   assign  ch12_hip_aib_fsr_in          =  ch12_aib_data_out[81:78]      ;
   assign  ch13_hip_aib_fsr_in          =  ch13_aib_data_out[81:78]      ;
   assign  ch14_hip_aib_fsr_in          =  ch14_aib_data_out[81:78]      ;
   assign  ch15_hip_aib_fsr_in          =  ch15_aib_data_out[81:78]      ;

   assign  ch0_hip_aib_ssr_in           =  ch0_aib_data_out[121:82]       ;
   assign  ch1_hip_aib_ssr_in           =  ch1_aib_data_out[121:82]       ;
   assign  ch2_hip_aib_ssr_in           =  ch2_aib_data_out[121:82]       ;
   assign  ch3_hip_aib_ssr_in           =  ch3_aib_data_out[121:82]       ;
   assign  ch4_hip_aib_ssr_in           =  ch4_aib_data_out[121:82]       ;
   assign  ch5_hip_aib_ssr_in           =  ch5_aib_data_out[121:82]       ;
   assign  ch6_hip_aib_ssr_in           =  ch6_aib_data_out[121:82]       ;
   assign  ch7_hip_aib_ssr_in           =  ch7_aib_data_out[121:82]       ;
   assign  ch8_hip_aib_ssr_in           =  ch8_aib_data_out[121:82]       ;
   assign  ch9_hip_aib_ssr_in           =  ch9_aib_data_out[121:82]       ;
   assign  ch10_hip_aib_ssr_in          =  ch10_aib_data_out[121:82]      ;
   assign  ch11_hip_aib_ssr_in          =  ch11_aib_data_out[121:82]      ;
   assign  ch12_hip_aib_ssr_in          =  ch12_aib_data_out[121:82]      ;
   assign  ch13_hip_aib_ssr_in          =  ch13_aib_data_out[121:82]      ;
   assign  ch14_hip_aib_ssr_in          =  ch14_aib_data_out[121:82]      ;
   assign  ch15_hip_aib_ssr_in          =  ch15_aib_data_out[121:82]      ;

   assign  ch0_hip_aib_status           =  ch0_aib_data_out[124:122]       ;
   assign  ch1_hip_aib_status           =  ch1_aib_data_out[124:122]       ;
   assign  ch2_hip_aib_status           =  ch2_aib_data_out[124:122]       ;
   assign  ch3_hip_aib_status           =  ch3_aib_data_out[124:122]       ;
   assign  ch4_hip_aib_status           =  ch4_aib_data_out[124:122]       ;
   assign  ch5_hip_aib_status           =  ch5_aib_data_out[124:122]       ;
   assign  ch6_hip_aib_status           =  ch6_aib_data_out[124:122]       ;
   assign  ch7_hip_aib_status           =  ch7_aib_data_out[124:122]       ;
   assign  ch8_hip_aib_status           =  ch8_aib_data_out[124:122]       ;
   assign  ch9_hip_aib_status           =  ch9_aib_data_out[124:122]       ;
   assign  ch10_hip_aib_status          =  ch10_aib_data_out[124:122]      ;
   assign  ch11_hip_aib_status          =  ch11_aib_data_out[124:122]      ;
   assign  ch12_hip_aib_status          =  ch12_aib_data_out[124:122]      ;
   assign  ch13_hip_aib_status          =  ch13_aib_data_out[124:122]      ;
   assign  ch14_hip_aib_status          =  ch14_aib_data_out[124:122]      ;
   assign  ch15_hip_aib_status          =  ch15_aib_data_out[124:122]      ;

   assign  ch0_aib_hip_txeq_in          =  ch0_aib_data_out[131:125]       ;
   assign  ch1_aib_hip_txeq_in          =  ch1_aib_data_out[131:125]       ;
   assign  ch2_aib_hip_txeq_in          =  ch2_aib_data_out[131:125]       ;
   assign  ch3_aib_hip_txeq_in          =  ch3_aib_data_out[131:125]       ;
   assign  ch4_aib_hip_txeq_in          =  ch4_aib_data_out[131:125]       ;
   assign  ch5_aib_hip_txeq_in          =  ch5_aib_data_out[131:125]       ;
   assign  ch6_aib_hip_txeq_in          =  ch6_aib_data_out[131:125]       ;
   assign  ch7_aib_hip_txeq_in          =  ch7_aib_data_out[131:125]       ;
   assign  ch8_aib_hip_txeq_in          =  ch8_aib_data_out[131:125]       ;
   assign  ch9_aib_hip_txeq_in          =  ch9_aib_data_out[131:125]       ;
   assign  ch10_aib_hip_txeq_in         =  ch10_aib_data_out[131:125]      ;
   assign  ch11_aib_hip_txeq_in         =  ch11_aib_data_out[131:125]      ;
   assign  ch12_aib_hip_txeq_in         =  ch12_aib_data_out[131:125]      ;
   assign  ch13_aib_hip_txeq_in         =  ch13_aib_data_out[131:125]      ;
   assign  ch14_aib_hip_txeq_in         =  ch14_aib_data_out[131:125]      ;
   assign  ch15_aib_hip_txeq_in         =  ch15_aib_data_out[131:125]      ;


   assign ch0_aib_data_in     = {  ch0_hip_aib_async_out, ch0_hip_aib_txeq_rst_n, ch0_hip_aib_txeq_clk_out, ch0_hip_aib_txeq_out, ch0_hip_aib_clk_2x, ch0_hip_aib_clk, ch0_hip_aib_ssr_out, ch0_hip_aib_fsr_out ,ch0_hip_aib_sync_data_out };
   assign ch1_aib_data_in     = {  ch1_hip_aib_async_out, ch1_hip_aib_txeq_rst_n, ch1_hip_aib_txeq_clk_out, ch1_hip_aib_txeq_out, ch1_hip_aib_clk_2x, ch1_hip_aib_clk, ch1_hip_aib_ssr_out, ch1_hip_aib_fsr_out ,ch1_hip_aib_sync_data_out };
   assign ch2_aib_data_in     = {  ch2_hip_aib_async_out, ch2_hip_aib_txeq_rst_n, ch2_hip_aib_txeq_clk_out, ch2_hip_aib_txeq_out, ch2_hip_aib_clk_2x, ch2_hip_aib_clk, ch2_hip_aib_ssr_out, ch2_hip_aib_fsr_out ,ch2_hip_aib_sync_data_out };
   assign ch3_aib_data_in     = {  ch3_hip_aib_async_out, ch3_hip_aib_txeq_rst_n, ch3_hip_aib_txeq_clk_out, ch3_hip_aib_txeq_out, ch3_hip_aib_clk_2x, ch3_hip_aib_clk, ch3_hip_aib_ssr_out, ch3_hip_aib_fsr_out ,ch3_hip_aib_sync_data_out };
   assign ch4_aib_data_in     = {  ch4_hip_aib_async_out, ch4_hip_aib_txeq_rst_n, ch4_hip_aib_txeq_clk_out, ch4_hip_aib_txeq_out, ch4_hip_aib_clk_2x, ch4_hip_aib_clk, ch4_hip_aib_ssr_out, ch4_hip_aib_fsr_out ,ch4_hip_aib_sync_data_out };
   assign ch5_aib_data_in     = {  ch5_hip_aib_async_out, ch5_hip_aib_txeq_rst_n, ch5_hip_aib_txeq_clk_out, ch5_hip_aib_txeq_out, ch5_hip_aib_clk_2x, ch5_hip_aib_clk, ch5_hip_aib_ssr_out, ch5_hip_aib_fsr_out ,ch5_hip_aib_sync_data_out };
   assign ch6_aib_data_in     = {  ch6_hip_aib_async_out, ch6_hip_aib_txeq_rst_n, ch6_hip_aib_txeq_clk_out, ch6_hip_aib_txeq_out, ch6_hip_aib_clk_2x, ch6_hip_aib_clk, ch6_hip_aib_ssr_out, ch6_hip_aib_fsr_out ,ch6_hip_aib_sync_data_out };
   assign ch7_aib_data_in     = {  ch7_hip_aib_async_out, ch7_hip_aib_txeq_rst_n, ch7_hip_aib_txeq_clk_out, ch7_hip_aib_txeq_out, ch7_hip_aib_clk_2x, ch7_hip_aib_clk, ch7_hip_aib_ssr_out, ch7_hip_aib_fsr_out ,ch7_hip_aib_sync_data_out };
   assign ch8_aib_data_in     = {  ch8_hip_aib_async_out, ch8_hip_aib_txeq_rst_n, ch8_hip_aib_txeq_clk_out, ch8_hip_aib_txeq_out, ch8_hip_aib_clk_2x, ch8_hip_aib_clk, ch8_hip_aib_ssr_out, ch8_hip_aib_fsr_out ,ch8_hip_aib_sync_data_out };
   assign ch9_aib_data_in     = {  ch9_hip_aib_async_out, ch9_hip_aib_txeq_rst_n, ch9_hip_aib_txeq_clk_out, ch9_hip_aib_txeq_out, ch9_hip_aib_clk_2x, ch9_hip_aib_clk, ch9_hip_aib_ssr_out, ch9_hip_aib_fsr_out ,ch9_hip_aib_sync_data_out };
   assign ch10_aib_data_in    = {  ch10_hip_aib_async_out, ch10_hip_aib_txeq_rst_n, ch10_hip_aib_txeq_clk_out, ch10_hip_aib_txeq_out, ch10_hip_aib_clk_2x, ch10_hip_aib_clk, ch10_hip_aib_ssr_out, ch10_hip_aib_fsr_out ,ch10_hip_aib_sync_data_out };
   assign ch11_aib_data_in    = {  ch11_hip_aib_async_out, ch11_hip_aib_txeq_rst_n, ch11_hip_aib_txeq_clk_out, ch11_hip_aib_txeq_out, ch11_hip_aib_clk_2x, ch11_hip_aib_clk, ch11_hip_aib_ssr_out, ch11_hip_aib_fsr_out ,ch11_hip_aib_sync_data_out };
   assign ch12_aib_data_in    = {  ch12_hip_aib_async_out, ch12_hip_aib_txeq_rst_n, ch12_hip_aib_txeq_clk_out, ch12_hip_aib_txeq_out, ch12_hip_aib_clk_2x, ch12_hip_aib_clk, ch12_hip_aib_ssr_out, ch12_hip_aib_fsr_out ,ch12_hip_aib_sync_data_out };
   assign ch13_aib_data_in    = {  ch13_hip_aib_async_out, ch13_hip_aib_txeq_rst_n, ch13_hip_aib_txeq_clk_out, ch13_hip_aib_txeq_out, ch13_hip_aib_clk_2x, ch13_hip_aib_clk, ch13_hip_aib_ssr_out, ch13_hip_aib_fsr_out ,ch13_hip_aib_sync_data_out };
   assign ch14_aib_data_in    = {  ch14_hip_aib_async_out, ch14_hip_aib_txeq_rst_n, ch14_hip_aib_txeq_clk_out, ch14_hip_aib_txeq_out, ch14_hip_aib_clk_2x, ch14_hip_aib_clk, ch14_hip_aib_ssr_out, ch14_hip_aib_fsr_out ,ch14_hip_aib_sync_data_out };
   assign ch15_aib_data_in    = {  ch15_hip_aib_async_out, ch15_hip_aib_txeq_rst_n, ch15_hip_aib_txeq_clk_out, ch15_hip_aib_txeq_out, ch15_hip_aib_clk_2x, ch15_hip_aib_clk, ch15_hip_aib_ssr_out, ch15_hip_aib_fsr_out ,ch15_hip_aib_sync_data_out };


   assign ch0_hip_aib_clk     = hip_pld_clk_out          ;
   assign ch1_hip_aib_clk     = hip_pld_clk_out          ;
   assign ch2_hip_aib_clk     = hip_pld_clk_out          ;
   assign ch3_hip_aib_clk     = hip_pld_clk_out          ;
   assign ch4_hip_aib_clk     = hip_pld_clk_out          ;
   assign ch5_hip_aib_clk     = hip_pld_clk_out          ;
   assign ch6_hip_aib_clk     = hip_pld_clk_out          ;
   assign ch7_hip_aib_clk     = hip_pld_clk_out          ;
   assign ch8_hip_aib_clk     = hip_core_clk_out         ;
   assign ch9_hip_aib_clk     = hip_core_clk_out         ;
   assign ch10_hip_aib_clk    = hip_core_clk_out         ;
   assign ch11_hip_aib_clk    = hip_core_clk_out         ;
   assign ch12_hip_aib_clk    = hip_core_clk_out         ;
   assign ch13_hip_aib_clk    = hip_core_clk_out         ;
   assign ch14_hip_aib_clk    = hip_core_clk_out         ;
   assign ch15_hip_aib_clk    = hip_core_clk_out         ;

   assign ch0_hip_aib_clk_2x  = hip_pld_clk_out_2x       ;
   assign ch1_hip_aib_clk_2x  = hip_pld_clk_out_2x       ;
   assign ch2_hip_aib_clk_2x  = hip_pld_clk_out_2x       ;
   assign ch3_hip_aib_clk_2x  = hip_pld_clk_out_2x       ;
   assign ch4_hip_aib_clk_2x  = hip_pld_clk_out_2x       ;
   assign ch5_hip_aib_clk_2x  = hip_pld_clk_out_2x       ;
   assign ch6_hip_aib_clk_2x  = hip_pld_clk_out_2x       ;
   assign ch7_hip_aib_clk_2x  = hip_pld_clk_out_2x       ;
   assign ch8_hip_aib_clk_2x  = hip_core_clk_out         ;
   assign ch9_hip_aib_clk_2x  = hip_core_clk_out         ;
   assign ch10_hip_aib_clk_2x = hip_core_clk_out         ;
   assign ch11_hip_aib_clk_2x = hip_core_clk_out         ;
   assign ch12_hip_aib_clk_2x = hip_core_clk_out         ;
   assign ch13_hip_aib_clk_2x = hip_core_clk_out         ;
   assign ch14_hip_aib_clk_2x = hip_core_clk_out         ;
   assign ch15_hip_aib_clk_2x = hip_core_clk_out         ;

   assign ch0_hip_aib_txeq_out     =  l0_hip_aib_tx_data        ;
   assign ch1_hip_aib_txeq_out     =  l1_hip_aib_tx_data        ;
   assign ch2_hip_aib_txeq_out     =  l2_hip_aib_tx_data        ;
   assign ch3_hip_aib_txeq_out     =  l3_hip_aib_tx_data        ;
   assign ch4_hip_aib_txeq_out     =  l4_hip_aib_tx_data        ;
   assign ch5_hip_aib_txeq_out     =  l5_hip_aib_tx_data        ;
   assign ch6_hip_aib_txeq_out     =  l6_hip_aib_tx_data        ;
   assign ch7_hip_aib_txeq_out     =  l7_hip_aib_tx_data        ;
   assign ch8_hip_aib_txeq_out     =  l8_hip_aib_tx_data        ;
   assign ch9_hip_aib_txeq_out     =  l9_hip_aib_tx_data        ;
   assign ch10_hip_aib_txeq_out    =  l10_hip_aib_tx_data       ;
   assign ch11_hip_aib_txeq_out    =  l11_hip_aib_tx_data       ;
   assign ch12_hip_aib_txeq_out    =  l12_hip_aib_tx_data       ;
   assign ch13_hip_aib_txeq_out    =  l13_hip_aib_tx_data       ;
   assign ch14_hip_aib_txeq_out    =  l14_hip_aib_tx_data       ;
   assign ch15_hip_aib_txeq_out    =  l15_hip_aib_tx_data       ;

   assign ch0_hip_aib_txeq_clk_out      =   txeq_clk_out        ;
   assign ch1_hip_aib_txeq_clk_out      =   txeq_clk_out        ;
   assign ch2_hip_aib_txeq_clk_out      =   txeq_clk_out        ;
   assign ch3_hip_aib_txeq_clk_out      =   txeq_clk_out        ;
   assign ch4_hip_aib_txeq_clk_out      =   txeq_clk_out        ;
   assign ch5_hip_aib_txeq_clk_out      =   txeq_clk_out        ;
   assign ch6_hip_aib_txeq_clk_out      =   txeq_clk_out        ;
   assign ch7_hip_aib_txeq_clk_out      =   txeq_clk_out        ;
   assign ch8_hip_aib_txeq_clk_out      =   txeq_clk_out        ;
   assign ch9_hip_aib_txeq_clk_out      =   txeq_clk_out        ;
   assign ch10_hip_aib_txeq_clk_out     =   txeq_clk_out        ;
   assign ch11_hip_aib_txeq_clk_out     =   txeq_clk_out        ;
   assign ch12_hip_aib_txeq_clk_out     =   txeq_clk_out        ;
   assign ch13_hip_aib_txeq_clk_out     =   txeq_clk_out        ;
   assign ch14_hip_aib_txeq_clk_out     =   txeq_clk_out        ;
   assign ch15_hip_aib_txeq_clk_out     =   txeq_clk_out        ;

   assign ch0_hip_aib_txeq_rst_n     =    rx_pcs_rst_n[0]       ;
   assign ch1_hip_aib_txeq_rst_n     =    rx_pcs_rst_n[1]       ;
   assign ch2_hip_aib_txeq_rst_n     =    rx_pcs_rst_n[2]       ;
   assign ch3_hip_aib_txeq_rst_n     =    rx_pcs_rst_n[3]       ;
   assign ch4_hip_aib_txeq_rst_n     =    rx_pcs_rst_n[4]       ;
   assign ch5_hip_aib_txeq_rst_n     =    rx_pcs_rst_n[5]       ;
   assign ch6_hip_aib_txeq_rst_n     =    rx_pcs_rst_n[6]       ;
   assign ch7_hip_aib_txeq_rst_n     =    rx_pcs_rst_n[7]       ;
   assign ch8_hip_aib_txeq_rst_n     =    rx_pcs_rst_n[8]       ;
   assign ch9_hip_aib_txeq_rst_n     =    rx_pcs_rst_n[9]       ;
   assign ch10_hip_aib_txeq_rst_n    =    rx_pcs_rst_n[10]      ;
   assign ch11_hip_aib_txeq_rst_n    =    rx_pcs_rst_n[11]      ;
   assign ch12_hip_aib_txeq_rst_n    =    rx_pcs_rst_n[12]      ;
   assign ch13_hip_aib_txeq_rst_n    =    rx_pcs_rst_n[13]      ;
   assign ch14_hip_aib_txeq_rst_n    =    rx_pcs_rst_n[14]      ;
   assign ch15_hip_aib_txeq_rst_n    =    rx_pcs_rst_n[15]      ;

   assign ch0_hip_aib_async_out       =   ch0_hip_aib_sync_data_out[67] ; //tx_st_ready
   assign ch1_hip_aib_async_out       =   hip_aux_test_out[0]           ;
   assign ch2_hip_aib_async_out       =   hip_aux_test_out[1]           ;
   assign ch3_hip_aib_async_out       =   hip_aux_test_out[2]           ;
   assign ch4_hip_aib_async_out       =   hip_aux_test_out[3]           ;
   assign ch5_hip_aib_async_out       =   hip_aux_test_out[4]           ;
   assign ch6_hip_aib_async_out       =   hip_aux_test_out[5]           ;
   assign ch7_hip_aib_async_out       =   hip_aux_test_out[6]           ;
   assign ch8_hip_aib_async_out       =   1'b0 ;
   assign ch9_hip_aib_async_out       =   1'b0 ;
   assign ch10_hip_aib_async_out      =   1'b0 ;
   assign ch11_hip_aib_async_out      =   1'b0 ;
   assign ch12_hip_aib_async_out      =   1'b0 ;
   assign ch13_hip_aib_async_out      =   1'b0 ;
   assign ch14_hip_aib_async_out      =   1'b0 ;
   assign ch15_hip_aib_async_out      =   1'b0 ;



/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
///lower Tile
//assign ch0_pcs_chnl_hip_ctrl_out = {1'b0            ,hip_cal_done[0],1'b0,hip_ctrl[4:0]};
//assign ch1_pcs_chnl_hip_ctrl_out = {~(apll_cal_busy),hip_cal_done[1],apll_locked,hip_ctrl[12:8]};
//assign ch2_pcs_chnl_hip_ctrl_out = {~(fpll_cal_busy),hip_cal_done[2],fpll_locked,hip_ctrl[20:16]};
//assign ch3_pcs_chnl_hip_ctrl_out = {1'b0            ,hip_cal_done[3],1'b0,hip_ctrl[28:24]};
//assign ch4_pcs_chnl_hip_ctrl_out = {1'b0            ,hip_cal_done[4],1'b0,hip_ctrl[36:32]};
//assign ch5_pcs_chnl_hip_ctrl_out = {1'b0            ,hip_cal_done[5],1'b0,hip_ctrl[44:40]};
////Middle Tile
//assign ch6_pcs_chnl_hip_ctrl_out = {1'b0            ,hip_cal_done[6],1'b0,hip_ctrl[52:48]};
//assign ch7_pcs_chnl_hip_ctrl_out = {~(apll_cal_busy),hip_cal_done[7],apll_locked,hip_ctrl[60:56]};
//assign ch8_pcs_chnl_hip_ctrl_out = {~(fpll_cal_busy),hip_cal_done[8],fpll_locked,hip_ctrl[68:64]};
//assign ch9_pcs_chnl_hip_ctrl_out = {1'b0            ,hip_cal_done[9],1'b0,hip_ctrl[76:72]};
//assign ch10_pcs_chnl_hip_ctrl_out = {1'b0            ,hip_cal_done[10],1'b0,hip_ctrl[84:80]};
//assign ch11_pcs_chnl_hip_ctrl_out = {1'b0            ,hip_cal_done[11],1'b0,hip_ctrl[92:88]};
////Upper Tile
//assign ch12_pcs_chnl_hip_ctrl_out = {1'b0            ,hip_cal_done[12],1'b0,hip_ctrl[100:96]};
//assign ch13_pcs_chnl_hip_ctrl_out = {~(apll_cal_busy),hip_cal_done[13],apll_locked,hip_ctrl[108:104]};
//assign ch14_pcs_chnl_hip_ctrl_out = {~(fpll_cal_busy),hip_cal_done[14],fpll_locked,hip_ctrl[116:112]};
//assign ch15_pcs_chnl_hip_ctrl_out = {1'b0            ,hip_cal_done[15],1'b0,hip_ctrl[124:120]};
//
//





   generate
   if (LANES ==1 ) begin : x1
       //SERDES to HIP
       assign serdes_pll_cal_done      = { ONES[15:3] ,pllnphy_pll_cal_done_fpll, virtual_link_rate == "gen3" ? pllnphy_pll_cal_done_lcpll : ONES[0], ONES[0]  }  ;
       assign serdes_chnl_cal_done     = { ONES[15:1] , ch0_pcs_data_out[57] }  ;
       assign serdes_tx_lcff_pll_lock  = { ONES[15:3] ,pllnphy_pll_locked_fpll, virtual_link_rate == "gen3" ? pllnphy_pll_locked_lcpll : ONES[0],ONES[0]  }  ;

       assign serdes_rx_pll_freq_lock  = { ONES[15:1] , ch0_pcs_data_out[54] }  ;
       assign serdes_rx_pll_phase_lock = { ONES[15:1] , ch0_pcs_data_out[55] }  ;
       assign serdes_mask_tx_pll_lock  = { ONES[15:1] , ch0_pcs_data_out[53] }  ;
       assign serdes_rxelecidle        = { ZEROS[15:1] , ch0_pcs_data_out[52] }  ;
       assign serdes_fref_clk          = { ONES[15:1] , ch0_pcs_data_out[61] }  ;
       assign serdes_pll_fixed_clk     = { ONES[15:1] , ch0_pcs_data_out[60] }  ;
       assign serdes_pclk_ch           = { ONES[15:1] , ch0_pcs_data_out[59] }  ;

       //SERDES to OUTPUT
       assign  pllnphy_rx_serial_data =  { rx_in0 }  ;

   end
   else if (LANES == 2 ) begin : x2
       //SERDES to HIP
       assign serdes_pll_cal_done      = { ONES[15:3] ,pllnphy_pll_cal_done_fpll, virtual_link_rate == "gen3" ? pllnphy_pll_cal_done_lcpll : ONES[0],ONES[0]  }  ;
       assign serdes_chnl_cal_done     = { ONES[15:2] , ch1_pcs_data_out[57], ch0_pcs_data_out[57] }  ;
       assign serdes_tx_lcff_pll_lock  = { ONES[15:3] ,pllnphy_pll_locked_fpll, virtual_link_rate == "gen3" ? pllnphy_pll_locked_lcpll : ONES[0],ONES[0]  }  ;

       assign serdes_rx_pll_freq_lock  = { ONES[15:2] , ch1_pcs_data_out[54], ch0_pcs_data_out[54] }  ;
       assign serdes_rx_pll_phase_lock = { ONES[15:2] , ch1_pcs_data_out[55], ch0_pcs_data_out[55] }  ;
       assign serdes_mask_tx_pll_lock  = { ONES[15:2] , ch1_pcs_data_out[53], ch0_pcs_data_out[53] }  ;
       assign serdes_rxelecidle        = { ZEROS[15:2], ch1_pcs_data_out[52], ch0_pcs_data_out[52] }  ;
       assign serdes_fref_clk          = { ONES[15:2] , ch1_pcs_data_out[61], ch0_pcs_data_out[61] }  ;
       assign serdes_pll_fixed_clk     = { ONES[15:2] , ch1_pcs_data_out[60], ch0_pcs_data_out[60] }  ;
       assign serdes_pclk_ch           = { ONES[15:2] , ch1_pcs_data_out[59], ch0_pcs_data_out[59] }  ;

       //SERDES to OUTPUT
       assign  pllnphy_rx_serial_data =  { rx_in1, rx_in0 }  ;

   end
   else if (LANES == 4 ) begin : x4
       //SERDES to HIP
       assign serdes_pll_cal_done      = { ONES[15:3] ,pllnphy_pll_cal_done_fpll, virtual_link_rate == "gen3" ? pllnphy_pll_cal_done_lcpll : ONES[0],ONES[0]  }  ;
       assign serdes_chnl_cal_done     = { ONES[15:4] , ch3_pcs_data_out[57], ch2_pcs_data_out[57], ch1_pcs_data_out[57], ch0_pcs_data_out[57] }  ;
       assign serdes_tx_lcff_pll_lock  = { ONES[15:3] ,pllnphy_pll_locked_fpll, virtual_link_rate == "gen3" ? pllnphy_pll_locked_lcpll : ONES[0],ONES[0]  }  ;

       assign serdes_rx_pll_freq_lock  = { ONES[15:4] , ch3_pcs_data_out[54], ch2_pcs_data_out[54], ch1_pcs_data_out[54], ch0_pcs_data_out[54] }  ;
       assign serdes_rx_pll_phase_lock = { ONES[15:4] , ch3_pcs_data_out[55], ch2_pcs_data_out[55], ch1_pcs_data_out[55], ch0_pcs_data_out[55] }  ;
       assign serdes_mask_tx_pll_lock  = { ONES[15:4] , ch3_pcs_data_out[53], ch2_pcs_data_out[53], ch1_pcs_data_out[53], ch0_pcs_data_out[53] }  ;
       assign serdes_rxelecidle        = { ZEROS[15:4], ch3_pcs_data_out[52], ch2_pcs_data_out[52], ch1_pcs_data_out[52], ch0_pcs_data_out[52] }  ;
       assign serdes_fref_clk          = { ONES[15:4] , ch3_pcs_data_out[61], ch2_pcs_data_out[61], ch1_pcs_data_out[61], ch0_pcs_data_out[61] }  ;
       assign serdes_pll_fixed_clk     = { ONES[15:4] , ch3_pcs_data_out[60], ch2_pcs_data_out[60], ch1_pcs_data_out[60], ch0_pcs_data_out[60] }  ;
       assign serdes_pclk_ch           = { ONES[15:4] , ch3_pcs_data_out[59], ch2_pcs_data_out[59], ch1_pcs_data_out[59], ch0_pcs_data_out[59] }  ;

       //SERDES to OUTPUT
       assign  pllnphy_rx_serial_data =  { rx_in3, rx_in2, rx_in1, rx_in0 }  ;



   end
   else if (LANES == 8 ) begin : x8
       //SERDES to HIP
       assign serdes_pll_cal_done      = { ONES[15:3] ,pllnphy_pll_cal_done_fpll, virtual_link_rate == "gen3" ? pllnphy_pll_cal_done_lcpll : ONES[0],ONES[0]  }  ;
       assign serdes_chnl_cal_done     = { ONES[15:8] , ch7_pcs_data_out[57], ch6_pcs_data_out[57], ch5_pcs_data_out[57], ch4_pcs_data_out[57] , ch3_pcs_data_out[57], ch2_pcs_data_out[57], ch1_pcs_data_out[57], ch0_pcs_data_out[57] }  ;
       assign serdes_tx_lcff_pll_lock  = { ONES[15:3] ,pllnphy_pll_locked_fpll, virtual_link_rate == "gen3" ? pllnphy_pll_locked_lcpll : ONES[0],ONES[0]  }  ;

       assign serdes_rx_pll_freq_lock  = { ONES[15:8] , ch7_pcs_data_out[54], ch6_pcs_data_out[54], ch5_pcs_data_out[54], ch4_pcs_data_out[54] , ch3_pcs_data_out[54], ch2_pcs_data_out[54], ch1_pcs_data_out[54], ch0_pcs_data_out[54] }  ;
       assign serdes_rx_pll_phase_lock = { ONES[15:8] , ch7_pcs_data_out[55], ch6_pcs_data_out[55], ch5_pcs_data_out[55], ch4_pcs_data_out[55] , ch3_pcs_data_out[55], ch2_pcs_data_out[55], ch1_pcs_data_out[55], ch0_pcs_data_out[55] }  ;
       assign serdes_mask_tx_pll_lock  = { ONES[15:8] , ch7_pcs_data_out[53], ch6_pcs_data_out[53], ch5_pcs_data_out[53], ch4_pcs_data_out[53] , ch3_pcs_data_out[53], ch2_pcs_data_out[53], ch1_pcs_data_out[53], ch0_pcs_data_out[53] }  ;
       assign serdes_rxelecidle        = { ZEROS[15:8], ch7_pcs_data_out[52], ch6_pcs_data_out[52], ch5_pcs_data_out[52], ch4_pcs_data_out[52] , ch3_pcs_data_out[52], ch2_pcs_data_out[52], ch1_pcs_data_out[52], ch0_pcs_data_out[52] }  ;
       assign serdes_fref_clk          = { ONES[15:8] , ch7_pcs_data_out[61], ch6_pcs_data_out[61], ch5_pcs_data_out[61], ch4_pcs_data_out[61] , ch3_pcs_data_out[61], ch2_pcs_data_out[61], ch1_pcs_data_out[61], ch0_pcs_data_out[61] }  ;
       assign serdes_pll_fixed_clk     = { ONES[15:8] , ch7_pcs_data_out[60], ch6_pcs_data_out[60], ch5_pcs_data_out[60], ch4_pcs_data_out[60] , ch3_pcs_data_out[60], ch2_pcs_data_out[60], ch1_pcs_data_out[60], ch0_pcs_data_out[60] }  ;
       assign serdes_pclk_ch           = { ONES[15:8] , ch7_pcs_data_out[59], ch6_pcs_data_out[59], ch5_pcs_data_out[59], ch4_pcs_data_out[59] , ch3_pcs_data_out[59], ch2_pcs_data_out[59], ch1_pcs_data_out[59], ch0_pcs_data_out[59] }  ;

       //SERDES to OUTPUT
       assign  pllnphy_rx_serial_data =  { rx_in7, rx_in6, rx_in5, rx_in4, rx_in3, rx_in2, rx_in1, rx_in0 }  ;

   end
   else if (LANES == 16 ) begin : x16
       //SERDES to HIP
       assign serdes_pll_cal_done      = { ONES[15:9] ,pllnphy_pll_cal_done_fpll, virtual_link_rate == "gen3" ? pllnphy_pll_cal_done_lcpll : ONES[0],ONES[6:0]  }  ;
       assign serdes_chnl_cal_done     = { ch15_pcs_data_out[57], ch14_pcs_data_out[57] , ch13_pcs_data_out[57], ch12_pcs_data_out[57], ch11_pcs_data_out[57], ch10_pcs_data_out[57], ch9_pcs_data_out[57], ch8_pcs_data_out[57], ch7_pcs_data_out[57], ch6_pcs_data_out[57], ch5_pcs_data_out[57], ch4_pcs_data_out[57] , ch3_pcs_data_out[57], ch2_pcs_data_out[57], ch1_pcs_data_out[57], ch0_pcs_data_out[57] }  ;
       assign serdes_tx_lcff_pll_lock  = { ONES[15:9] ,pllnphy_pll_locked_fpll,  virtual_link_rate == "gen3" ? pllnphy_pll_locked_lcpll : ONES[0],ONES[6:0]  }  ;

       assign serdes_rx_pll_freq_lock  = { ch15_pcs_data_out[54], ch14_pcs_data_out[54] , ch13_pcs_data_out[54], ch12_pcs_data_out[54], ch11_pcs_data_out[54], ch10_pcs_data_out[54], ch9_pcs_data_out[54], ch8_pcs_data_out[54], ch7_pcs_data_out[54], ch6_pcs_data_out[54], ch5_pcs_data_out[54], ch4_pcs_data_out[54] , ch3_pcs_data_out[54], ch2_pcs_data_out[54], ch1_pcs_data_out[54], ch0_pcs_data_out[54] }  ;
       assign serdes_rx_pll_phase_lock = { ch15_pcs_data_out[55], ch14_pcs_data_out[55] , ch13_pcs_data_out[55], ch12_pcs_data_out[55], ch11_pcs_data_out[55], ch10_pcs_data_out[55], ch9_pcs_data_out[55], ch8_pcs_data_out[55], ch7_pcs_data_out[55], ch6_pcs_data_out[55], ch5_pcs_data_out[55], ch4_pcs_data_out[55] , ch3_pcs_data_out[55], ch2_pcs_data_out[55], ch1_pcs_data_out[55], ch0_pcs_data_out[55] }  ;
       assign serdes_mask_tx_pll_lock  = { ch15_pcs_data_out[53], ch14_pcs_data_out[53] , ch13_pcs_data_out[53], ch12_pcs_data_out[53], ch11_pcs_data_out[53], ch10_pcs_data_out[53], ch9_pcs_data_out[53], ch8_pcs_data_out[53], ch7_pcs_data_out[53], ch6_pcs_data_out[53], ch5_pcs_data_out[53], ch4_pcs_data_out[53] , ch3_pcs_data_out[53], ch2_pcs_data_out[53], ch1_pcs_data_out[53], ch0_pcs_data_out[53] }  ;
       assign serdes_rxelecidle        = { ch15_pcs_data_out[52], ch14_pcs_data_out[52] , ch13_pcs_data_out[52], ch12_pcs_data_out[52], ch11_pcs_data_out[52], ch10_pcs_data_out[52], ch9_pcs_data_out[52], ch8_pcs_data_out[52], ch7_pcs_data_out[52], ch6_pcs_data_out[52], ch5_pcs_data_out[52], ch4_pcs_data_out[52] , ch3_pcs_data_out[52], ch2_pcs_data_out[52], ch1_pcs_data_out[52], ch0_pcs_data_out[52] }  ;
       assign serdes_fref_clk          = { ch15_pcs_data_out[61], ch14_pcs_data_out[61] , ch13_pcs_data_out[61], ch12_pcs_data_out[61], ch11_pcs_data_out[61], ch10_pcs_data_out[61], ch9_pcs_data_out[61], ch8_pcs_data_out[61], ch7_pcs_data_out[61], ch6_pcs_data_out[61], ch5_pcs_data_out[61], ch4_pcs_data_out[61] , ch3_pcs_data_out[61], ch2_pcs_data_out[61], ch1_pcs_data_out[61], ch0_pcs_data_out[61] }  ;
       assign serdes_pll_fixed_clk     = { ch15_pcs_data_out[60], ch14_pcs_data_out[60] , ch13_pcs_data_out[60], ch12_pcs_data_out[60], ch11_pcs_data_out[60], ch10_pcs_data_out[60], ch9_pcs_data_out[60], ch8_pcs_data_out[60], ch7_pcs_data_out[60], ch6_pcs_data_out[60], ch5_pcs_data_out[60], ch4_pcs_data_out[60] , ch3_pcs_data_out[60], ch2_pcs_data_out[60], ch1_pcs_data_out[60], ch0_pcs_data_out[60] }  ;
       assign serdes_pclk_ch           = { ch15_pcs_data_out[59], ch14_pcs_data_out[59] , ch13_pcs_data_out[59], ch12_pcs_data_out[59], ch11_pcs_data_out[59], ch10_pcs_data_out[59], ch9_pcs_data_out[59], ch8_pcs_data_out[59], ch7_pcs_data_out[59], ch6_pcs_data_out[59], ch5_pcs_data_out[59], ch4_pcs_data_out[59] , ch3_pcs_data_out[59], ch2_pcs_data_out[59], ch1_pcs_data_out[59], ch0_pcs_data_out[59] }  ;

       //SERDES to OUTPUT
       assign  pllnphy_rx_serial_data =  { rx_in15, rx_in14, rx_in13, rx_in12, rx_in11, rx_in10, rx_in9, rx_in8, rx_in7, rx_in6, rx_in5, rx_in4, rx_in3, rx_in2, rx_in1, rx_in0 }  ;

   end
   endgenerate


  //========================
  //PIPE Input signals
   assign l0_hip_pcs_rx_data     = (pipe32_sim_only==1'b0)?  ch0_pcs_data_out[50:0]    :  {3'b0,rxdatavalid0 ,3'b0,rxblkst0 ,rxsynchd0 ,rxstatus0 ,rxvalid0 ,phystatus0 ,rxdatak0 ,rxdata0 }         ;
   assign l1_hip_pcs_rx_data     = (pipe32_sim_only==1'b0)?  ch1_pcs_data_out[50:0]    :  {3'b0,rxdatavalid1 ,3'b0,rxblkst1 ,rxsynchd1 ,rxstatus1 ,rxvalid1 ,phystatus1 ,rxdatak1 ,rxdata1 }         ;
   assign l2_hip_pcs_rx_data     = (pipe32_sim_only==1'b0)?  ch2_pcs_data_out[50:0]    :  {3'b0,rxdatavalid2 ,3'b0,rxblkst2 ,rxsynchd2 ,rxstatus2 ,rxvalid2 ,phystatus2 ,rxdatak2 ,rxdata2 }         ;
   assign l3_hip_pcs_rx_data     = (pipe32_sim_only==1'b0)?  ch3_pcs_data_out[50:0]    :  {3'b0,rxdatavalid3 ,3'b0,rxblkst3 ,rxsynchd3 ,rxstatus3 ,rxvalid3 ,phystatus3 ,rxdatak3 ,rxdata3 }         ;
   assign l4_hip_pcs_rx_data     = (pipe32_sim_only==1'b0)?  ch4_pcs_data_out[50:0]    :  {3'b0,rxdatavalid4 ,3'b0,rxblkst4 ,rxsynchd4 ,rxstatus4 ,rxvalid4 ,phystatus4 ,rxdatak4 ,rxdata4 }         ;
   assign l5_hip_pcs_rx_data     = (pipe32_sim_only==1'b0)?  ch5_pcs_data_out[50:0]    :  {3'b0,rxdatavalid5 ,3'b0,rxblkst5 ,rxsynchd5 ,rxstatus5 ,rxvalid5 ,phystatus5 ,rxdatak5 ,rxdata5 }         ;
   assign l6_hip_pcs_rx_data     = (pipe32_sim_only==1'b0)?  ch6_pcs_data_out[50:0]    :  {3'b0,rxdatavalid6 ,3'b0,rxblkst6 ,rxsynchd6 ,rxstatus6 ,rxvalid6 ,phystatus6 ,rxdatak6 ,rxdata6 }         ;
   assign l7_hip_pcs_rx_data     = (pipe32_sim_only==1'b0)?  ch7_pcs_data_out[50:0]    :  {3'b0,rxdatavalid7 ,3'b0,rxblkst7 ,rxsynchd7 ,rxstatus7 ,rxvalid7 ,phystatus7 ,rxdatak7 ,rxdata7 }         ;
   assign l8_hip_pcs_rx_data     = (pipe32_sim_only==1'b0)?  ch8_pcs_data_out[50:0]    :  {3'b0,rxdatavalid8 ,3'b0,rxblkst8 ,rxsynchd8 ,rxstatus8 ,rxvalid8 ,phystatus8 ,rxdatak8 ,rxdata8 }         ;
   assign l9_hip_pcs_rx_data     = (pipe32_sim_only==1'b0)?  ch9_pcs_data_out[50:0]    :  {3'b0,rxdatavalid9 ,3'b0,rxblkst9 ,rxsynchd9 ,rxstatus9 ,rxvalid9 ,phystatus9 ,rxdatak9 ,rxdata9 }         ;
   assign l10_hip_pcs_rx_data    = (pipe32_sim_only==1'b0)?  ch10_pcs_data_out[50:0]   :  {3'b0,rxdatavalid10 ,3'b0,rxblkst10 ,rxsynchd10 ,rxstatus10 ,rxvalid10 ,phystatus10 ,rxdatak10 ,rxdata10 } ;
   assign l11_hip_pcs_rx_data    = (pipe32_sim_only==1'b0)?  ch11_pcs_data_out[50:0]   :  {3'b0,rxdatavalid11 ,3'b0,rxblkst11 ,rxsynchd11 ,rxstatus11 ,rxvalid11 ,phystatus11 ,rxdatak11 ,rxdata11 } ;
   assign l12_hip_pcs_rx_data    = (pipe32_sim_only==1'b0)?  ch12_pcs_data_out[50:0]   :  {3'b0,rxdatavalid12 ,3'b0,rxblkst12 ,rxsynchd12 ,rxstatus12 ,rxvalid12 ,phystatus12 ,rxdatak12 ,rxdata12 } ;
   assign l13_hip_pcs_rx_data    = (pipe32_sim_only==1'b0)?  ch13_pcs_data_out[50:0]   :  {3'b0,rxdatavalid13 ,3'b0,rxblkst13 ,rxsynchd13 ,rxstatus13 ,rxvalid13 ,phystatus13 ,rxdatak13 ,rxdata13 } ;
   assign l14_hip_pcs_rx_data    = (pipe32_sim_only==1'b0)?  ch14_pcs_data_out[50:0]   :  {3'b0,rxdatavalid14 ,3'b0,rxblkst14 ,rxsynchd14 ,rxstatus14 ,rxvalid14 ,phystatus14 ,rxdatak14 ,rxdata14 } ;
   assign l15_hip_pcs_rx_data    = (pipe32_sim_only==1'b0)?  ch15_pcs_data_out[50:0]   :  {3'b0,rxdatavalid15 ,3'b0,rxblkst15 ,rxsynchd15 ,rxstatus15 ,rxvalid15 ,phystatus15 ,rxdatak15 ,rxdata15 } ;


   assign l0_hip_aib_rx_data     = (pipe32_sim_only==1'b0)? ch0_aib_hip_txeq_in        :   { phystatus0  , dirfeedback0    }      ;
   assign l1_hip_aib_rx_data     = (pipe32_sim_only==1'b0)? ch1_aib_hip_txeq_in        :   { phystatus1  , dirfeedback1    }      ;
   assign l2_hip_aib_rx_data     = (pipe32_sim_only==1'b0)? ch2_aib_hip_txeq_in        :   { phystatus2  , dirfeedback2    }      ;
   assign l3_hip_aib_rx_data     = (pipe32_sim_only==1'b0)? ch3_aib_hip_txeq_in        :   { phystatus3  , dirfeedback3    }      ;
   assign l4_hip_aib_rx_data     = (pipe32_sim_only==1'b0)? ch4_aib_hip_txeq_in        :   { phystatus4  , dirfeedback4    }      ;
   assign l5_hip_aib_rx_data     = (pipe32_sim_only==1'b0)? ch5_aib_hip_txeq_in        :   { phystatus5  , dirfeedback5    }      ;
   assign l6_hip_aib_rx_data     = (pipe32_sim_only==1'b0)? ch6_aib_hip_txeq_in        :   { phystatus6  , dirfeedback6    }      ;
   assign l7_hip_aib_rx_data     = (pipe32_sim_only==1'b0)? ch7_aib_hip_txeq_in        :   { phystatus7  , dirfeedback7    }      ;
   assign l8_hip_aib_rx_data     = (pipe32_sim_only==1'b0)? ch8_aib_hip_txeq_in        :   { phystatus8  , dirfeedback8    }      ;
   assign l9_hip_aib_rx_data     = (pipe32_sim_only==1'b0)? ch9_aib_hip_txeq_in        :   { phystatus9  , dirfeedback9    }      ;
   assign l10_hip_aib_rx_data    = (pipe32_sim_only==1'b0)? ch10_aib_hip_txeq_in       :   { phystatus10  , dirfeedback10   }      ;
   assign l11_hip_aib_rx_data    = (pipe32_sim_only==1'b0)? ch11_aib_hip_txeq_in       :   { phystatus11  , dirfeedback11   }      ;
   assign l12_hip_aib_rx_data    = (pipe32_sim_only==1'b0)? ch12_aib_hip_txeq_in       :   { phystatus12  , dirfeedback12   }      ;
   assign l13_hip_aib_rx_data    = (pipe32_sim_only==1'b0)? ch13_aib_hip_txeq_in       :   { phystatus13  , dirfeedback13   }      ;
   assign l14_hip_aib_rx_data    = (pipe32_sim_only==1'b0)? ch14_aib_hip_txeq_in       :   { phystatus14  , dirfeedback14   }      ;
   assign l15_hip_aib_rx_data    = (pipe32_sim_only==1'b0)? ch15_aib_hip_txeq_in       :   { phystatus15  , dirfeedback15   }      ;


   //========================
   //PIPE output signals
   assign txdata0     [31 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[31:0]  :  {l0_hip_pcs_tx_data[40:33],l0_hip_pcs_tx_data[29:22],l0_hip_pcs_tx_data[18:11],l0_hip_pcs_tx_data[7:0]};
   assign txdata1     [31 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[31:0]  :  {l1_hip_pcs_tx_data[40:33],l1_hip_pcs_tx_data[29:22],l1_hip_pcs_tx_data[18:11],l1_hip_pcs_tx_data[7:0]};
   assign txdata2     [31 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[31:0]  :  {l2_hip_pcs_tx_data[40:33],l2_hip_pcs_tx_data[29:22],l2_hip_pcs_tx_data[18:11],l2_hip_pcs_tx_data[7:0]};
   assign txdata3     [31 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[31:0]  :  {l3_hip_pcs_tx_data[40:33],l3_hip_pcs_tx_data[29:22],l3_hip_pcs_tx_data[18:11],l3_hip_pcs_tx_data[7:0]};
   assign txdata4     [31 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[31:0]  :  {l4_hip_pcs_tx_data[40:33],l4_hip_pcs_tx_data[29:22],l4_hip_pcs_tx_data[18:11],l4_hip_pcs_tx_data[7:0]};
   assign txdata5     [31 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[31:0]  :  {l5_hip_pcs_tx_data[40:33],l5_hip_pcs_tx_data[29:22],l5_hip_pcs_tx_data[18:11],l5_hip_pcs_tx_data[7:0]};
   assign txdata6     [31 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[31:0]  :  {l6_hip_pcs_tx_data[40:33],l6_hip_pcs_tx_data[29:22],l6_hip_pcs_tx_data[18:11],l6_hip_pcs_tx_data[7:0]};
   assign txdata7     [31 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[31:0]  :  {l7_hip_pcs_tx_data[40:33],l7_hip_pcs_tx_data[29:22],l7_hip_pcs_tx_data[18:11],l7_hip_pcs_tx_data[7:0]};
   assign txdata8     [31 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[31:0]  :  {l8_hip_pcs_tx_data[40:33],l8_hip_pcs_tx_data[29:22],l8_hip_pcs_tx_data[18:11],l8_hip_pcs_tx_data[7:0]};
   assign txdata9     [31 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[31:0]  :  {l9_hip_pcs_tx_data[40:33],l9_hip_pcs_tx_data[29:22],l9_hip_pcs_tx_data[18:11],l9_hip_pcs_tx_data[7:0]};
   assign txdata10    [31 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[31:0]  :  {l10_hip_pcs_tx_data[40:33],l10_hip_pcs_tx_data[29:22],l10_hip_pcs_tx_data[18:11],l10_hip_pcs_tx_data[7:0]};
   assign txdata11    [31 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[31:0]  :  {l11_hip_pcs_tx_data[40:33],l11_hip_pcs_tx_data[29:22],l11_hip_pcs_tx_data[18:11],l11_hip_pcs_tx_data[7:0]};
   assign txdata12    [31 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[31:0]  :  {l12_hip_pcs_tx_data[40:33],l12_hip_pcs_tx_data[29:22],l12_hip_pcs_tx_data[18:11],l12_hip_pcs_tx_data[7:0]};
   assign txdata13    [31 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[31:0]  :  {l13_hip_pcs_tx_data[40:33],l13_hip_pcs_tx_data[29:22],l13_hip_pcs_tx_data[18:11],l13_hip_pcs_tx_data[7:0]};
   assign txdata14    [31 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[31:0]  :  {l14_hip_pcs_tx_data[40:33],l14_hip_pcs_tx_data[29:22],l14_hip_pcs_tx_data[18:11],l14_hip_pcs_tx_data[7:0]};
   assign txdata15    [31 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[31:0]  :  {l15_hip_pcs_tx_data[40:33],l15_hip_pcs_tx_data[29:22],l15_hip_pcs_tx_data[18:11],l15_hip_pcs_tx_data[7:0]};


   assign txdatak0    [ 3 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[ 3:0]  :  {l0_hip_pcs_tx_data[41],   l0_hip_pcs_tx_data[30] ,   l0_hip_pcs_tx_data[19],   l0_hip_pcs_tx_data[8]};
   assign txdatak1    [ 3 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[ 3:0]  :  {l1_hip_pcs_tx_data[41],   l1_hip_pcs_tx_data[30] ,   l1_hip_pcs_tx_data[19],   l1_hip_pcs_tx_data[8]};
   assign txdatak2    [ 3 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[ 3:0]  :  {l2_hip_pcs_tx_data[41],   l2_hip_pcs_tx_data[30] ,   l2_hip_pcs_tx_data[19],   l2_hip_pcs_tx_data[8]};
   assign txdatak3    [ 3 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[ 3:0]  :  {l3_hip_pcs_tx_data[41],   l3_hip_pcs_tx_data[30] ,   l3_hip_pcs_tx_data[19],   l3_hip_pcs_tx_data[8]};
   assign txdatak4    [ 3 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[ 3:0]  :  {l4_hip_pcs_tx_data[41],   l4_hip_pcs_tx_data[30] ,   l4_hip_pcs_tx_data[19],   l4_hip_pcs_tx_data[8]};
   assign txdatak5    [ 3 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[ 3:0]  :  {l5_hip_pcs_tx_data[41],   l5_hip_pcs_tx_data[30] ,   l5_hip_pcs_tx_data[19],   l5_hip_pcs_tx_data[8]};
   assign txdatak6    [ 3 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[ 3:0]  :  {l6_hip_pcs_tx_data[41],   l6_hip_pcs_tx_data[30] ,   l6_hip_pcs_tx_data[19],   l6_hip_pcs_tx_data[8]};
   assign txdatak7    [ 3 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[ 3:0]  :  {l7_hip_pcs_tx_data[41],   l7_hip_pcs_tx_data[30] ,   l7_hip_pcs_tx_data[19],   l7_hip_pcs_tx_data[8]};
   assign txdatak8    [ 3 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[ 3:0]  :  {l8_hip_pcs_tx_data[41],   l8_hip_pcs_tx_data[30] ,   l8_hip_pcs_tx_data[19],   l8_hip_pcs_tx_data[8]};
   assign txdatak9    [ 3 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[ 3:0]  :  {l9_hip_pcs_tx_data[41],   l9_hip_pcs_tx_data[30] ,   l9_hip_pcs_tx_data[19],   l9_hip_pcs_tx_data[8]};
   assign txdatak10   [ 3 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[ 3:0]  :  {l10_hip_pcs_tx_data[41],   l10_hip_pcs_tx_data[30] ,   l10_hip_pcs_tx_data[19],   l10_hip_pcs_tx_data[8]};
   assign txdatak11   [ 3 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[ 3:0]  :  {l11_hip_pcs_tx_data[41],   l11_hip_pcs_tx_data[30] ,   l11_hip_pcs_tx_data[19],   l11_hip_pcs_tx_data[8]};
   assign txdatak12   [ 3 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[ 3:0]  :  {l12_hip_pcs_tx_data[41],   l12_hip_pcs_tx_data[30] ,   l12_hip_pcs_tx_data[19],   l12_hip_pcs_tx_data[8]};
   assign txdatak13   [ 3 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[ 3:0]  :  {l13_hip_pcs_tx_data[41],   l13_hip_pcs_tx_data[30] ,   l13_hip_pcs_tx_data[19],   l13_hip_pcs_tx_data[8]};
   assign txdatak14   [ 3 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[ 3:0]  :  {l14_hip_pcs_tx_data[41],   l14_hip_pcs_tx_data[30] ,   l14_hip_pcs_tx_data[19],   l14_hip_pcs_tx_data[8]};
   assign txdatak15   [ 3 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[ 3:0]  :  {l15_hip_pcs_tx_data[41],   l15_hip_pcs_tx_data[30] ,   l15_hip_pcs_tx_data[19],   l15_hip_pcs_tx_data[8]};


   assign txcompl0               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l0_hip_pcs_tx_data[9];
   assign txcompl1               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l1_hip_pcs_tx_data[9];
   assign txcompl2               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l2_hip_pcs_tx_data[9];
   assign txcompl3               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l3_hip_pcs_tx_data[9];
   assign txcompl4               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l4_hip_pcs_tx_data[9];
   assign txcompl5               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l5_hip_pcs_tx_data[9];
   assign txcompl6               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l6_hip_pcs_tx_data[9];
   assign txcompl7               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l7_hip_pcs_tx_data[9];
   assign txcompl8               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l8_hip_pcs_tx_data[9];
   assign txcompl9               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l9_hip_pcs_tx_data[9];
   assign txcompl10              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l10_hip_pcs_tx_data[9];
   assign txcompl11              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l11_hip_pcs_tx_data[9];
   assign txcompl12              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l12_hip_pcs_tx_data[9];
   assign txcompl13              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l13_hip_pcs_tx_data[9];
   assign txcompl14              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l14_hip_pcs_tx_data[9];
   assign txcompl15              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l15_hip_pcs_tx_data[9];

   assign txelecidle0            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l0_hip_pcs_tx_data[43];
   assign txelecidle1            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l1_hip_pcs_tx_data[43];
   assign txelecidle2            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l2_hip_pcs_tx_data[43];
   assign txelecidle3            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l3_hip_pcs_tx_data[43];
   assign txelecidle4            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l4_hip_pcs_tx_data[43];
   assign txelecidle5            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l5_hip_pcs_tx_data[43];
   assign txelecidle6            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l6_hip_pcs_tx_data[43];
   assign txelecidle7            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l7_hip_pcs_tx_data[43];
   assign txelecidle8            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l8_hip_pcs_tx_data[43];
   assign txelecidle9            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l9_hip_pcs_tx_data[43];
   assign txelecidle10           = (pipe32_sim_only==1'b0)?ZEROS[0]     :l10_hip_pcs_tx_data[43];
   assign txelecidle11           = (pipe32_sim_only==1'b0)?ZEROS[0]     :l11_hip_pcs_tx_data[43];
   assign txelecidle12           = (pipe32_sim_only==1'b0)?ZEROS[0]     :l12_hip_pcs_tx_data[43];
   assign txelecidle13           = (pipe32_sim_only==1'b0)?ZEROS[0]     :l13_hip_pcs_tx_data[43];
   assign txelecidle14           = (pipe32_sim_only==1'b0)?ZEROS[0]     :l14_hip_pcs_tx_data[43];
   assign txelecidle15           = (pipe32_sim_only==1'b0)?ZEROS[0]     :l15_hip_pcs_tx_data[43];

   assign txdetectrx0            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l0_hip_pcs_tx_data[46];
   assign txdetectrx1            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l1_hip_pcs_tx_data[46];
   assign txdetectrx2            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l2_hip_pcs_tx_data[46];
   assign txdetectrx3            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l3_hip_pcs_tx_data[46];
   assign txdetectrx4            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l4_hip_pcs_tx_data[46];
   assign txdetectrx5            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l5_hip_pcs_tx_data[46];
   assign txdetectrx6            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l6_hip_pcs_tx_data[46];
   assign txdetectrx7            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l7_hip_pcs_tx_data[46];
   assign txdetectrx8            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l8_hip_pcs_tx_data[46];
   assign txdetectrx9            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l9_hip_pcs_tx_data[46];
   assign txdetectrx10           = (pipe32_sim_only==1'b0)?ZEROS[0]     :l10_hip_pcs_tx_data[46];
   assign txdetectrx11           = (pipe32_sim_only==1'b0)?ZEROS[0]     :l11_hip_pcs_tx_data[46];
   assign txdetectrx12           = (pipe32_sim_only==1'b0)?ZEROS[0]     :l12_hip_pcs_tx_data[46];
   assign txdetectrx13           = (pipe32_sim_only==1'b0)?ZEROS[0]     :l13_hip_pcs_tx_data[46];
   assign txdetectrx14           = (pipe32_sim_only==1'b0)?ZEROS[0]     :l14_hip_pcs_tx_data[46];
   assign txdetectrx15           = (pipe32_sim_only==1'b0)?ZEROS[0]     :l15_hip_pcs_tx_data[46];


   assign powerdown0  [1 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[1:0]   :l0_hip_pcs_tx_data[48:47];
   assign powerdown1  [1 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[1:0]   :l1_hip_pcs_tx_data[48:47];
   assign powerdown2  [1 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[1:0]   :l2_hip_pcs_tx_data[48:47];
   assign powerdown3  [1 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[1:0]   :l3_hip_pcs_tx_data[48:47];
   assign powerdown4  [1 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[1:0]   :l4_hip_pcs_tx_data[48:47];
   assign powerdown5  [1 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[1:0]   :l5_hip_pcs_tx_data[48:47];
   assign powerdown6  [1 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[1:0]   :l6_hip_pcs_tx_data[48:47];
   assign powerdown7  [1 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[1:0]   :l7_hip_pcs_tx_data[48:47];
   assign powerdown8  [1 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[1:0]   :l8_hip_pcs_tx_data[48:47];
   assign powerdown9  [1 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[1:0]   :l9_hip_pcs_tx_data[48:47];
   assign powerdown10 [1 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[1:0]   :l10_hip_pcs_tx_data[48:47];
   assign powerdown11 [1 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[1:0]   :l11_hip_pcs_tx_data[48:47];
   assign powerdown12 [1 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[1:0]   :l12_hip_pcs_tx_data[48:47];
   assign powerdown13 [1 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[1:0]   :l13_hip_pcs_tx_data[48:47];
   assign powerdown14 [1 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[1:0]   :l14_hip_pcs_tx_data[48:47];
   assign powerdown15 [1 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[1:0]   :l15_hip_pcs_tx_data[48:47];

   assign txmargin0   [2 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l0_hip_pcs_tx_data[51:49];
   assign txmargin1   [2 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l1_hip_pcs_tx_data[51:49];
   assign txmargin2   [2 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l2_hip_pcs_tx_data[51:49];
   assign txmargin3   [2 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l3_hip_pcs_tx_data[51:49];
   assign txmargin4   [2 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l4_hip_pcs_tx_data[51:49];
   assign txmargin5   [2 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l5_hip_pcs_tx_data[51:49];
   assign txmargin6   [2 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l6_hip_pcs_tx_data[51:49];
   assign txmargin7   [2 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l7_hip_pcs_tx_data[51:49];
   assign txmargin8   [2 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l8_hip_pcs_tx_data[51:49];
   assign txmargin9   [2 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l9_hip_pcs_tx_data[51:49];
   assign txmargin10  [2 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l10_hip_pcs_tx_data[51:49];
   assign txmargin11  [2 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l11_hip_pcs_tx_data[51:49];
   assign txmargin12  [2 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l12_hip_pcs_tx_data[51:49];
   assign txmargin13  [2 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l13_hip_pcs_tx_data[51:49];
   assign txmargin14  [2 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l14_hip_pcs_tx_data[51:49];
   assign txmargin15  [2 : 0]    = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l15_hip_pcs_tx_data[51:49];

   // For gen3  the coefficients are provided by currentcoeff0
   assign txdeemph0              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l0_hip_pcs_tx_data[52];
   assign txdeemph1              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l1_hip_pcs_tx_data[52];
   assign txdeemph2              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l2_hip_pcs_tx_data[52];
   assign txdeemph3              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l3_hip_pcs_tx_data[52];
   assign txdeemph4              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l4_hip_pcs_tx_data[52];
   assign txdeemph5              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l5_hip_pcs_tx_data[52];
   assign txdeemph6              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l6_hip_pcs_tx_data[52];
   assign txdeemph7              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l7_hip_pcs_tx_data[52];
   assign txdeemph8              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l8_hip_pcs_tx_data[52];
   assign txdeemph9              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l9_hip_pcs_tx_data[52];
   assign txdeemph10             = (pipe32_sim_only==1'b0)?ZEROS[0]     :l10_hip_pcs_tx_data[52];
   assign txdeemph11             = (pipe32_sim_only==1'b0)?ZEROS[0]     :l11_hip_pcs_tx_data[52];
   assign txdeemph12             = (pipe32_sim_only==1'b0)?ZEROS[0]     :l12_hip_pcs_tx_data[52];
   assign txdeemph13             = (pipe32_sim_only==1'b0)?ZEROS[0]     :l13_hip_pcs_tx_data[52];
   assign txdeemph14             = (pipe32_sim_only==1'b0)?ZEROS[0]     :l14_hip_pcs_tx_data[52];
   assign txdeemph15             = (pipe32_sim_only==1'b0)?ZEROS[0]     :l15_hip_pcs_tx_data[52];

   assign txswing0               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l0_hip_pcs_tx_data[53];
   assign txswing1               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l1_hip_pcs_tx_data[53];
   assign txswing2               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l2_hip_pcs_tx_data[53];
   assign txswing3               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l3_hip_pcs_tx_data[53];
   assign txswing4               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l4_hip_pcs_tx_data[53];
   assign txswing5               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l5_hip_pcs_tx_data[53];
   assign txswing6               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l6_hip_pcs_tx_data[53];
   assign txswing7               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l7_hip_pcs_tx_data[53];
   assign txswing8               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l8_hip_pcs_tx_data[53];
   assign txswing9               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l9_hip_pcs_tx_data[53];
   assign txswing10              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l10_hip_pcs_tx_data[53];
   assign txswing11              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l11_hip_pcs_tx_data[53];
   assign txswing12              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l12_hip_pcs_tx_data[53];
   assign txswing13              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l13_hip_pcs_tx_data[53];
   assign txswing14              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l14_hip_pcs_tx_data[53];
   assign txswing15              = (pipe32_sim_only==1'b0)?ZEROS[0]     :l15_hip_pcs_tx_data[53];

   assign txsynchd0   [1 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l0_hip_pcs_tx_data[55:54];
   assign txsynchd1   [1 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l1_hip_pcs_tx_data[55:54];
   assign txsynchd2   [1 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l2_hip_pcs_tx_data[55:54];
   assign txsynchd3   [1 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l3_hip_pcs_tx_data[55:54];
   assign txsynchd4   [1 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l4_hip_pcs_tx_data[55:54];
   assign txsynchd5   [1 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l5_hip_pcs_tx_data[55:54];
   assign txsynchd6   [1 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l6_hip_pcs_tx_data[55:54];
   assign txsynchd7   [1 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l7_hip_pcs_tx_data[55:54];
   assign txsynchd8   [1 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l8_hip_pcs_tx_data[55:54];
   assign txsynchd9   [1 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l9_hip_pcs_tx_data[55:54];
   assign txsynchd10  [1 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l10_hip_pcs_tx_data[55:54];
   assign txsynchd11  [1 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l11_hip_pcs_tx_data[55:54];
   assign txsynchd12  [1 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l12_hip_pcs_tx_data[55:54];
   assign txsynchd13  [1 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l13_hip_pcs_tx_data[55:54];
   assign txsynchd14  [1 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l14_hip_pcs_tx_data[55:54];
   assign txsynchd15  [1 : 0]   = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l15_hip_pcs_tx_data[55:54];

   assign txblkst0              = (pipe32_sim_only==1'b0)?ZEROS[0]      :l0_hip_pcs_tx_data[56];
   assign txblkst1              = (pipe32_sim_only==1'b0)?ZEROS[0]      :l1_hip_pcs_tx_data[56];
   assign txblkst2              = (pipe32_sim_only==1'b0)?ZEROS[0]      :l2_hip_pcs_tx_data[56];
   assign txblkst3              = (pipe32_sim_only==1'b0)?ZEROS[0]      :l3_hip_pcs_tx_data[56];
   assign txblkst4              = (pipe32_sim_only==1'b0)?ZEROS[0]      :l4_hip_pcs_tx_data[56];
   assign txblkst5              = (pipe32_sim_only==1'b0)?ZEROS[0]      :l5_hip_pcs_tx_data[56];
   assign txblkst6              = (pipe32_sim_only==1'b0)?ZEROS[0]      :l6_hip_pcs_tx_data[56];
   assign txblkst7              = (pipe32_sim_only==1'b0)?ZEROS[0]      :l7_hip_pcs_tx_data[56];
   assign txblkst8              = (pipe32_sim_only==1'b0)?ZEROS[0]      :l8_hip_pcs_tx_data[56];
   assign txblkst9              = (pipe32_sim_only==1'b0)?ZEROS[0]      :l9_hip_pcs_tx_data[56];
   assign txblkst10             = (pipe32_sim_only==1'b0)?ZEROS[0]      :l10_hip_pcs_tx_data[56];
   assign txblkst11             = (pipe32_sim_only==1'b0)?ZEROS[0]      :l11_hip_pcs_tx_data[56];
   assign txblkst12             = (pipe32_sim_only==1'b0)?ZEROS[0]      :l12_hip_pcs_tx_data[56];
   assign txblkst13             = (pipe32_sim_only==1'b0)?ZEROS[0]      :l13_hip_pcs_tx_data[56];
   assign txblkst14             = (pipe32_sim_only==1'b0)?ZEROS[0]      :l14_hip_pcs_tx_data[56];
   assign txblkst15             = (pipe32_sim_only==1'b0)?ZEROS[0]      :l15_hip_pcs_tx_data[56];

   assign txdatavalid0          = (pipe32_sim_only==1'b0)?ZEROS[0]      :l0_hip_pcs_tx_data[60];
   assign txdatavalid1          = (pipe32_sim_only==1'b0)?ZEROS[0]      :l1_hip_pcs_tx_data[60];
   assign txdatavalid2          = (pipe32_sim_only==1'b0)?ZEROS[0]      :l2_hip_pcs_tx_data[60];
   assign txdatavalid3          = (pipe32_sim_only==1'b0)?ZEROS[0]      :l3_hip_pcs_tx_data[60];
   assign txdatavalid4          = (pipe32_sim_only==1'b0)?ZEROS[0]      :l4_hip_pcs_tx_data[60];
   assign txdatavalid5          = (pipe32_sim_only==1'b0)?ZEROS[0]      :l5_hip_pcs_tx_data[60];
   assign txdatavalid6          = (pipe32_sim_only==1'b0)?ZEROS[0]      :l6_hip_pcs_tx_data[60];
   assign txdatavalid7          = (pipe32_sim_only==1'b0)?ZEROS[0]      :l7_hip_pcs_tx_data[60];
   assign txdatavalid8          = (pipe32_sim_only==1'b0)?ZEROS[0]      :l8_hip_pcs_tx_data[60];
   assign txdatavalid9          = (pipe32_sim_only==1'b0)?ZEROS[0]      :l9_hip_pcs_tx_data[60];
   assign txdatavalid10         = (pipe32_sim_only==1'b0)?ZEROS[0]      :l10_hip_pcs_tx_data[60];
   assign txdatavalid11         = (pipe32_sim_only==1'b0)?ZEROS[0]      :l11_hip_pcs_tx_data[60];
   assign txdatavalid12         = (pipe32_sim_only==1'b0)?ZEROS[0]      :l12_hip_pcs_tx_data[60];
   assign txdatavalid13         = (pipe32_sim_only==1'b0)?ZEROS[0]      :l13_hip_pcs_tx_data[60];
   assign txdatavalid14         = (pipe32_sim_only==1'b0)?ZEROS[0]      :l14_hip_pcs_tx_data[60];
   assign txdatavalid15         = (pipe32_sim_only==1'b0)?ZEROS[0]      :l15_hip_pcs_tx_data[60];

   assign rate0      [1:0]      = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l0_hip_pcs_tx_async[1:0]             ;
   assign rate1      [1:0]      = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l1_hip_pcs_tx_async[1:0]             ;
   assign rate2      [1:0]      = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l2_hip_pcs_tx_async[1:0]             ;
   assign rate3      [1:0]      = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l3_hip_pcs_tx_async[1:0]             ;
   assign rate4      [1:0]      = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l4_hip_pcs_tx_async[1:0]             ;
   assign rate5      [1:0]      = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l5_hip_pcs_tx_async[1:0]             ;
   assign rate6      [1:0]      = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l6_hip_pcs_tx_async[1:0]             ;
   assign rate7      [1:0]      = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l7_hip_pcs_tx_async[1:0]             ;
   assign rate8      [1:0]      = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l8_hip_pcs_tx_async[1:0]             ;
   assign rate9      [1:0]      = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l9_hip_pcs_tx_async[1:0]             ;
   assign rate10     [1:0]      = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l10_hip_pcs_tx_async[1:0]             ;
   assign rate11     [1:0]      = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l11_hip_pcs_tx_async[1:0]             ;
   assign rate12     [1:0]      = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l12_hip_pcs_tx_async[1:0]             ;
   assign rate13     [1:0]      = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l13_hip_pcs_tx_async[1:0]             ;
   assign rate14     [1:0]      = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l14_hip_pcs_tx_async[1:0]             ;
   assign rate15     [1:0]      = (pipe32_sim_only==1'b0)?ZEROS[1:0]    :l15_hip_pcs_tx_async[1:0]             ;


   assign rxpolarity0           = (pipe32_sim_only==1'b0)?1'b0          :l0_hip_pcs_tx_async[2]             ;
   assign rxpolarity1           = (pipe32_sim_only==1'b0)?1'b0          :l1_hip_pcs_tx_async[2]             ;
   assign rxpolarity2           = (pipe32_sim_only==1'b0)?1'b0          :l2_hip_pcs_tx_async[2]             ;
   assign rxpolarity3           = (pipe32_sim_only==1'b0)?1'b0          :l3_hip_pcs_tx_async[2]             ;
   assign rxpolarity4           = (pipe32_sim_only==1'b0)?1'b0          :l4_hip_pcs_tx_async[2]             ;
   assign rxpolarity5           = (pipe32_sim_only==1'b0)?1'b0          :l5_hip_pcs_tx_async[2]             ;
   assign rxpolarity6           = (pipe32_sim_only==1'b0)?1'b0          :l6_hip_pcs_tx_async[2]             ;
   assign rxpolarity7           = (pipe32_sim_only==1'b0)?1'b0          :l7_hip_pcs_tx_async[2]             ;
   assign rxpolarity8           = (pipe32_sim_only==1'b0)?1'b0          :l8_hip_pcs_tx_async[2]             ;
   assign rxpolarity9           = (pipe32_sim_only==1'b0)?1'b0          :l9_hip_pcs_tx_async[2]             ;
   assign rxpolarity10          = (pipe32_sim_only==1'b0)?1'b0          :l10_hip_pcs_tx_async[2]             ;
   assign rxpolarity11          = (pipe32_sim_only==1'b0)?1'b0          :l11_hip_pcs_tx_async[2]             ;
   assign rxpolarity12          = (pipe32_sim_only==1'b0)?1'b0          :l12_hip_pcs_tx_async[2]             ;
   assign rxpolarity13          = (pipe32_sim_only==1'b0)?1'b0          :l13_hip_pcs_tx_async[2]             ;
   assign rxpolarity14          = (pipe32_sim_only==1'b0)?1'b0          :l14_hip_pcs_tx_async[2]             ;
   assign rxpolarity15          = (pipe32_sim_only==1'b0)?1'b0          :l15_hip_pcs_tx_async[2]             ;


   assign currentrxpreset0  [2:0]  = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l0_hip_pcs_tx_async[5:3]             ;
   assign currentrxpreset1  [2:0]  = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l1_hip_pcs_tx_async[5:3]             ;
   assign currentrxpreset2  [2:0]  = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l2_hip_pcs_tx_async[5:3]             ;
   assign currentrxpreset3  [2:0]  = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l3_hip_pcs_tx_async[5:3]             ;
   assign currentrxpreset4  [2:0]  = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l4_hip_pcs_tx_async[5:3]             ;
   assign currentrxpreset5  [2:0]  = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l5_hip_pcs_tx_async[5:3]             ;
   assign currentrxpreset6  [2:0]  = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l6_hip_pcs_tx_async[5:3]             ;
   assign currentrxpreset7  [2:0]  = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l7_hip_pcs_tx_async[5:3]             ;
   assign currentrxpreset8  [2:0]  = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l8_hip_pcs_tx_async[5:3]             ;
   assign currentrxpreset9  [2:0]  = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l9_hip_pcs_tx_async[5:3]             ;
   assign currentrxpreset10 [2:0]  = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l10_hip_pcs_tx_async[5:3]             ;
   assign currentrxpreset11 [2:0]  = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l11_hip_pcs_tx_async[5:3]             ;
   assign currentrxpreset12 [2:0]  = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l12_hip_pcs_tx_async[5:3]             ;
   assign currentrxpreset13 [2:0]  = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l13_hip_pcs_tx_async[5:3]             ;
   assign currentrxpreset14 [2:0]  = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l14_hip_pcs_tx_async[5:3]             ;
   assign currentrxpreset15 [2:0]  = (pipe32_sim_only==1'b0)?ZEROS[2:0]   :l15_hip_pcs_tx_async[5:3]             ;

   assign currentcoeff0    [17:0]  = (pipe32_sim_only==1'b0)?ZEROS[17:0]  :l0_hip_pcs_tx_async[23:6]             ;
   assign currentcoeff1    [17:0]  = (pipe32_sim_only==1'b0)?ZEROS[17:0]  :l1_hip_pcs_tx_async[23:6]             ;
   assign currentcoeff2    [17:0]  = (pipe32_sim_only==1'b0)?ZEROS[17:0]  :l2_hip_pcs_tx_async[23:6]             ;
   assign currentcoeff3    [17:0]  = (pipe32_sim_only==1'b0)?ZEROS[17:0]  :l3_hip_pcs_tx_async[23:6]             ;
   assign currentcoeff4    [17:0]  = (pipe32_sim_only==1'b0)?ZEROS[17:0]  :l4_hip_pcs_tx_async[23:6]             ;
   assign currentcoeff5    [17:0]  = (pipe32_sim_only==1'b0)?ZEROS[17:0]  :l5_hip_pcs_tx_async[23:6]             ;
   assign currentcoeff6    [17:0]  = (pipe32_sim_only==1'b0)?ZEROS[17:0]  :l6_hip_pcs_tx_async[23:6]             ;
   assign currentcoeff7    [17:0]  = (pipe32_sim_only==1'b0)?ZEROS[17:0]  :l7_hip_pcs_tx_async[23:6]             ;
   assign currentcoeff8    [17:0]  = (pipe32_sim_only==1'b0)?ZEROS[17:0]  :l8_hip_pcs_tx_async[23:6]             ;
   assign currentcoeff9    [17:0]  = (pipe32_sim_only==1'b0)?ZEROS[17:0]  :l9_hip_pcs_tx_async[23:6]             ;
   assign currentcoeff10   [17:0]  = (pipe32_sim_only==1'b0)?ZEROS[17:0]  :l10_hip_pcs_tx_async[23:6]             ;
   assign currentcoeff11   [17:0]  = (pipe32_sim_only==1'b0)?ZEROS[17:0]  :l11_hip_pcs_tx_async[23:6]             ;
   assign currentcoeff12   [17:0]  = (pipe32_sim_only==1'b0)?ZEROS[17:0]  :l12_hip_pcs_tx_async[23:6]             ;
   assign currentcoeff13   [17:0]  = (pipe32_sim_only==1'b0)?ZEROS[17:0]  :l13_hip_pcs_tx_async[23:6]             ;
   assign currentcoeff14   [17:0]  = (pipe32_sim_only==1'b0)?ZEROS[17:0]  :l14_hip_pcs_tx_async[23:6]             ;
   assign currentcoeff15   [17:0]  = (pipe32_sim_only==1'b0)?ZEROS[17:0]  :l15_hip_pcs_tx_async[23:6]             ;


   assign rxeqeval0                  = (pipe32_sim_only==1'b0)?ZEROS[0]     :l0_hip_aib_tx_data[1]               ;
   assign rxeqeval1                  = (pipe32_sim_only==1'b0)?ZEROS[0]     :l1_hip_aib_tx_data[1]               ;
   assign rxeqeval2                  = (pipe32_sim_only==1'b0)?ZEROS[0]     :l2_hip_aib_tx_data[1]               ;
   assign rxeqeval3                  = (pipe32_sim_only==1'b0)?ZEROS[0]     :l3_hip_aib_tx_data[1]               ;
   assign rxeqeval4                  = (pipe32_sim_only==1'b0)?ZEROS[0]     :l4_hip_aib_tx_data[1]               ;
   assign rxeqeval5                  = (pipe32_sim_only==1'b0)?ZEROS[0]     :l5_hip_aib_tx_data[1]               ;
   assign rxeqeval6                  = (pipe32_sim_only==1'b0)?ZEROS[0]     :l6_hip_aib_tx_data[1]               ;
   assign rxeqeval7                  = (pipe32_sim_only==1'b0)?ZEROS[0]     :l7_hip_aib_tx_data[1]               ;
   assign rxeqeval8                  = (pipe32_sim_only==1'b0)?ZEROS[0]     :l8_hip_aib_tx_data[1]               ;
   assign rxeqeval9                  = (pipe32_sim_only==1'b0)?ZEROS[0]     :l9_hip_aib_tx_data[1]               ;
   assign rxeqeval10                 = (pipe32_sim_only==1'b0)?ZEROS[0]     :l10_hip_aib_tx_data[1]              ;
   assign rxeqeval11                 = (pipe32_sim_only==1'b0)?ZEROS[0]     :l11_hip_aib_tx_data[1]              ;
   assign rxeqeval12                 = (pipe32_sim_only==1'b0)?ZEROS[0]     :l12_hip_aib_tx_data[1]              ;
   assign rxeqeval13                 = (pipe32_sim_only==1'b0)?ZEROS[0]     :l13_hip_aib_tx_data[1]              ;
   assign rxeqeval14                 = (pipe32_sim_only==1'b0)?ZEROS[0]     :l14_hip_aib_tx_data[1]              ;
   assign rxeqeval15                 = (pipe32_sim_only==1'b0)?ZEROS[0]     :l15_hip_aib_tx_data[1]              ;

   assign rxeqinprogress0            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l0_hip_aib_tx_data[0]               ;
   assign rxeqinprogress1            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l1_hip_aib_tx_data[0]               ;
   assign rxeqinprogress2            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l2_hip_aib_tx_data[0]               ;
   assign rxeqinprogress3            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l3_hip_aib_tx_data[0]               ;
   assign rxeqinprogress4            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l4_hip_aib_tx_data[0]               ;
   assign rxeqinprogress5            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l5_hip_aib_tx_data[0]               ;
   assign rxeqinprogress6            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l6_hip_aib_tx_data[0]               ;
   assign rxeqinprogress7            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l7_hip_aib_tx_data[0]               ;
   assign rxeqinprogress8            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l8_hip_aib_tx_data[0]               ;
   assign rxeqinprogress9            = (pipe32_sim_only==1'b0)?ZEROS[0]     :l9_hip_aib_tx_data[0]               ;
   assign rxeqinprogress10           = (pipe32_sim_only==1'b0)?ZEROS[0]     :l10_hip_aib_tx_data[0]              ;
   assign rxeqinprogress11           = (pipe32_sim_only==1'b0)?ZEROS[0]     :l11_hip_aib_tx_data[0]              ;
   assign rxeqinprogress12           = (pipe32_sim_only==1'b0)?ZEROS[0]     :l12_hip_aib_tx_data[0]              ;
   assign rxeqinprogress13           = (pipe32_sim_only==1'b0)?ZEROS[0]     :l13_hip_aib_tx_data[0]              ;
   assign rxeqinprogress14           = (pipe32_sim_only==1'b0)?ZEROS[0]     :l14_hip_aib_tx_data[0]              ;
   assign rxeqinprogress15           = (pipe32_sim_only==1'b0)?ZEROS[0]     :l15_hip_aib_tx_data[0]              ;


   assign invalidreq0                = (pipe32_sim_only==1'b0)?ZEROS[0]     :l0_hip_aib_tx_data[2]               ;
   assign invalidreq1                = (pipe32_sim_only==1'b0)?ZEROS[0]     :l1_hip_aib_tx_data[2]               ;
   assign invalidreq2                = (pipe32_sim_only==1'b0)?ZEROS[0]     :l2_hip_aib_tx_data[2]               ;
   assign invalidreq3                = (pipe32_sim_only==1'b0)?ZEROS[0]     :l3_hip_aib_tx_data[2]               ;
   assign invalidreq4                = (pipe32_sim_only==1'b0)?ZEROS[0]     :l4_hip_aib_tx_data[2]               ;
   assign invalidreq5                = (pipe32_sim_only==1'b0)?ZEROS[0]     :l5_hip_aib_tx_data[2]               ;
   assign invalidreq6                = (pipe32_sim_only==1'b0)?ZEROS[0]     :l6_hip_aib_tx_data[2]               ;
   assign invalidreq7                = (pipe32_sim_only==1'b0)?ZEROS[0]     :l7_hip_aib_tx_data[2]               ;
   assign invalidreq8                = (pipe32_sim_only==1'b0)?ZEROS[0]     :l8_hip_aib_tx_data[2]               ;
   assign invalidreq9                = (pipe32_sim_only==1'b0)?ZEROS[0]     :l9_hip_aib_tx_data[2]               ;
   assign invalidreq10               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l10_hip_aib_tx_data[2]              ;
   assign invalidreq11               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l11_hip_aib_tx_data[2]              ;
   assign invalidreq12               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l12_hip_aib_tx_data[2]              ;
   assign invalidreq13               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l13_hip_aib_tx_data[2]              ;
   assign invalidreq14               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l14_hip_aib_tx_data[2]              ;
   assign invalidreq15               = (pipe32_sim_only==1'b0)?ZEROS[0]     :l15_hip_aib_tx_data[2]              ;




// synthesis translate_off
   //PLLs for PIPE Simulation
   wire     open_locked;
   wire     open_fbclkout;

   generic_pll #        ( .reference_clock_frequency(pll_refclk_freq), .output_clock_frequency("125.0 MHz") )
      refclk_to_125mhz      ( .refclk(refclk), .outclk(clk125_out), .locked(open_locked),    .fboutclk(open_fbclkout), .rst(1'b0), .fbclk(fbclkout));

   generic_pll #        ( .reference_clock_frequency(pll_refclk_freq), .output_clock_frequency("250.0 MHz") )
      refclk_to_250mhz      ( .refclk(refclk), .outclk(clk250_out), .locked(open_locked),    .fboutclk(open_fbclkout), .rst(1'b0), .fbclk(fbclkout));

   generic_pll #        ( .reference_clock_frequency(pll_refclk_freq), .output_clock_frequency("500.0 MHz") )
      pll_100mhz_to_500mhz      ( .refclk(refclk), .outclk(clk500_out), .locked(open_locked),    .fboutclk(open_fbclkout), .rst(1'b0), .fbclk(fbclkout));

   generic_pll #        ( .reference_clock_frequency(pll_refclk_freq), .output_clock_frequency("1000.0 MHz") )
      pll_100mhz_to_1GHz      ( .refclk(refclk), .outclk(clk1000_out), .locked(open_locked),    .fboutclk(open_fbclkout), .rst(1'b0), .fbclk(fbclkout));

   //iocsd_rdy_dly and config_avmm_rst_n signals for simulation- For synthesis - these will be driven by Crete SSM
   reg config_avmm_rst_n ;
   reg iocsr_rdy_dly ;

   initial begin
      config_avmm_rst_n = 1'b1;
      iocsr_rdy_dly = 1'b1;
      #0.2 config_avmm_rst_n = 1'b0;
      iocsr_rdy_dly = 1'b0;
      #0.4 config_avmm_rst_n = 1'b1;
      iocsr_rdy_dly = 1'b1;
   end
// synthesis translate_on

// hip_ctrl signals from PCS
   assign    rxelecidle                    =  (pipe32_sim_only==1'b0)?  serdes_rxelecidle        :  {  rxelecidle15,rxelecidle14,rxelecidle13,rxelecidle12,rxelecidle11,rxelecidle10,rxelecidle9,rxelecidle8,
                                                                                                       rxelecidle7 ,rxelecidle6 ,rxelecidle5 ,rxelecidle4 ,rxelecidle3 ,rxelecidle2 ,rxelecidle1,rxelecidle0 } ;
   assign    mask_tx_pll_lock              =  (pipe32_sim_only==1'b0)?  serdes_mask_tx_pll_lock  :  {LANES{sim_pipe_mask_tx_pll_lock} }                                               ;
   assign    rx_pll_freq_lock              =  (pipe32_sim_only==1'b0)?  serdes_rx_pll_freq_lock  :  ONES[15:0]                                                               ;
   assign    tx_lcff_pll_lock              =  (pipe32_sim_only==1'b0)?  serdes_tx_lcff_pll_lock  :  ONES[15:0]                                                               ;
   assign    chnl_cal_done                 =  (pipe32_sim_only==1'b0)?  serdes_chnl_cal_done     :  ONES[15:0]                                                               ;
   assign    pll_cal_done                  =  (pipe32_sim_only==1'b0)?  serdes_pll_cal_done      :  ONES[15:0]                                                               ;
   assign    fref_clk                      =  (pipe32_sim_only==1'b0)?  serdes_fref_clk          :  {LANES{refclk} }                                                         ; // HIP Hard Reset Controller input
   assign    pll_fixed_clk_ch              =  (pipe32_sim_only==1'b0 )? {serdes_pll_fixed_clk[6], serdes_pll_fixed_clk[0] }: ( (virtual_link_rate=="gen3") ? {clk1000_out,clk1000_out} :{clk500_out,clk500_out}  ) ;
   assign    pclk_ch                       =  (pipe32_sim_only==1'b0)?  serdes_pclk_ch           :  {LANES{sim_pipe_pclk_in}} ;

   // HIP Atom
   ct1_hssi_x16_pcie  # (
       .adp_bypass                                                                                              (  adp_bypass                                                                                            ) ,
       .aux_cfg_vf_en                                                                                           (  aux_cfg_vf_en                                                                                         ) ,
       .aux_warm_reset_ctl                                                                                      (  aux_warm_reset_ctl                                                                                    ) ,
       .cfg_blk_crs_en                                                                                          (  cfg_blk_crs_en                                                                                        ) ,
       .cfg_dbi_pf0_table_size                                                                                  (  cfg_dbi_pf0_table_size                                                                                ) ,
       .cfg_dbi_pf1_start_addr                                                                                  (  cfg_dbi_pf1_start_addr                                                                                ) ,
       .cfg_dbi_pf1_tablesize                                                                                   (  cfg_dbi_pf1_tablesize                                                                                 ) ,
       .cfg_g3_pset_coeff_0                                                                                     (  cfg_g3_pset_coeff_0                                                                                   ) ,
       .cfg_g3_pset_coeff_1                                                                                     (  cfg_g3_pset_coeff_1                                                                                   ) ,
       .cfg_g3_pset_coeff_10                                                                                    (  cfg_g3_pset_coeff_10                                                                                  ) ,
       .cfg_g3_pset_coeff_2                                                                                     (  cfg_g3_pset_coeff_2                                                                                   ) ,
       .cfg_g3_pset_coeff_3                                                                                     (  cfg_g3_pset_coeff_3                                                                                   ) ,
       .cfg_g3_pset_coeff_4                                                                                     (  cfg_g3_pset_coeff_4                                                                                   ) ,
       .cfg_g3_pset_coeff_5                                                                                     (  cfg_g3_pset_coeff_5                                                                                   ) ,
       .cfg_g3_pset_coeff_6                                                                                     (  cfg_g3_pset_coeff_6                                                                                   ) ,
       .cfg_g3_pset_coeff_7                                                                                     (  cfg_g3_pset_coeff_7                                                                                   ) ,
       .cfg_g3_pset_coeff_8                                                                                     (  cfg_g3_pset_coeff_8                                                                                   ) ,
       .cfg_g3_pset_coeff_9                                                                                     (  cfg_g3_pset_coeff_9                                                                                   ) ,
       .cfg_vf_num_pf0                                                                                          (  cfg_vf_num_pf0                                                                                        ) ,
       .cfg_vf_num_pf1                                                                                          (  cfg_vf_num_pf1                                                                                        ) ,
       .cfg_vf_table_size                                                                                       (  cfg_vf_table_size                                                                                     ) ,
       .clkmod_gen3_hclk_div_sel                                                                                (  clkmod_gen3_hclk_div_sel                                                                              ) ,
       .clkmod_gen3_hclk_source_sel                                                                             (  clkmod_gen3_hclk_source_sel                                                                           ) ,
       .clkmod_hip_clk_dis                                                                                      (  clkmod_hip_clk_dis                                                                                    ) ,
       .clkmod_pclk_sel                                                                                         (  clkmod_pclk_sel                                                                                       ) ,
       .clkmod_pld_clk_out_sel                                                                                  (  clkmod_pld_clk_out_sel                                                                                ) ,
       .clkmod_pld_clk_out_sel_2x                                                                               (  clkmod_pld_clk_out_sel_2x                                                                             ) ,
       .clock_ctl_rsvd_3                                                                                        (  clock_ctl_rsvd_3                                                                                      ) ,
       .clock_ctl_rsvd_5                                                                                        (  clock_ctl_rsvd_5                                                                                      ) ,
       .clrhip_not_rst_sticky                                                                                   (  clrhip_not_rst_sticky                                                                                 ) ,
       .crs_override                                                                                            (  crs_override                                                                                          ) ,
       .crs_override_value                                                                                      (  crs_override_value                                                                                    ) ,
       .cvp_blocking_dis                                                                                        (  cvp_blocking_dis                                                                                      ) ,
       .cvp_clk_sel                                                                                             (  cvp_clk_sel                                                                                           ) ,
       .cvp_data_compressed                                                                                     (  cvp_data_compressed                                                                                   ) ,
       .cvp_data_encrypted                                                                                      (  cvp_data_encrypted                                                                                    ) ,
       .cvp_extra                                                                                               (  cvp_extra                                                                                             ) ,
       .cvp_hard_reset_bypass                                                                                   (  cvp_hard_reset_bypass                                                                                 ) ,
       .cvp_hip_clk_sel_default                                                                                 (  cvp_hip_clk_sel_default                                                                               ) ,
       .cvp_intf_reset_ctl                                                                                      (  cvp_intf_reset_ctl                                                                                    ) ,
       .cvp_irq_en                                                                                              (  cvp_irq_en                                                                                            ) ,
       .cvp_jtag0                                                                                               (  cvp_jtag0                                                                                             ) ,
       .cvp_jtag1                                                                                               (  cvp_jtag1                                                                                             ) ,
       .cvp_jtag2                                                                                               (  cvp_jtag2                                                                                             ) ,
       .cvp_jtag3                                                                                               (  cvp_jtag3                                                                                             ) ,
       .cvp_mode_default                                                                                        (  cvp_mode_default                                                                                      ) ,
       .cvp_mode_gating_dis                                                                                     (  cvp_mode_gating_dis                                                                                   ) ,
       .cvp_rate_sel                                                                                            (  cvp_rate_sel                                                                                          ) ,
       .cvp_user_id                                                                                             (  cvp_user_id                                                                                           ) ,
       .cvp_vsec_id                                                                                             (  cvp_vsec_id                                                                                           ) ,
       .cvp_vsec_rev                                                                                            (  cvp_vsec_rev                                                                                          ) ,
       .cvp_warm_rst_ready_force_bit0                                                                           (  cvp_warm_rst_ready_force_bit0                                                                         ) ,
       .cvp_warm_rst_ready_force_bit1                                                                           (  cvp_warm_rst_ready_force_bit1                                                                         ) ,
       .cvp_warm_rst_req_ena                                                                                    (  cvp_warm_rst_req_ena                                                                                  ) ,
       .cvp_write_mask_ctl                                                                                      (  cvp_write_mask_ctl                                                                                    ) ,
       .device_type                                                                                             (  device_type                                                                                           ) ,
       .ecc_chk_val                                                                                             (  ecc_chk_val                                                                                           ) ,
       .ecc_gen_val                                                                                             (  ecc_gen_val                                                                                           ) ,
       .eco_flops                                                                                               (  eco_flops                                                                                             ) ,
       .eqctrl_adp_ctle                                                                                         (  eqctrl_adp_ctle                                                                                       ) ,
       .eqctrl_ctle_val                                                                                         (  eqctrl_ctle_val                                                                                       ) ,
       .eqctrl_dir_mode_en                                                                                      (  eqctrl_dir_mode_en                                                                                    ) ,
       .eqctrl_fom_mode_en                                                                                      (  eqctrl_fom_mode_en                                                                                    ) ,
       .eqctrl_legacy_mode_en                                                                                   (  eqctrl_legacy_mode_en                                                                                 ) ,
       .eqctrl_num_fom_cycles                                                                                   (  eqctrl_num_fom_cycles                                                                                 ) ,
       .eqctrl_use_dsp_rxpreset                                                                                 (  eqctrl_use_dsp_rxpreset                                                                               ) ,
       .func_mode                                                                                               (  func_mode                                                                                             ) ,
       .gpio_irq                                                                                                (  gpio_irq                                                                                              ) ,
       .hip_pcs_chnl_en                                                                                         (  hip_pcs_chnl_en                                                                                       ) ,
       .hrc_chnl_cal_done_active                                                                                (  hrc_chnl_cal_done_active                                                                              ) ,
       .hrc_chnl_en                                                                                             (  hrc_chnl_en                                                                                           ) ,
       .hrc_chnl_txpll_master_cgb_rst_en                                                                        (  hrc_chnl_txpll_master_cgb_rst_en                                                                      ) ,
       .hrc_chnl_txpll_rst_en                                                                                   (  hrc_chnl_txpll_rst_en                                                                                 ) ,
       .hrc_en_pcs_fifo_err                                                                                     (  hrc_en_pcs_fifo_err                                                                                   ) ,
       .hrc_force_inactive_rst                                                                                  (  hrc_force_inactive_rst                                                                                ) ,
       .hrc_fref_clk_active                                                                                     (  hrc_fref_clk_active                                                                                   ) ,
       .hrc_mask_tx_pll_lock_active                                                                             (  hrc_mask_tx_pll_lock_active                                                                           ) ,
       .hrc_pll_cal_done_active                                                                                 (  hrc_pll_cal_done_active                                                                               ) ,
       .hrc_pll_perst_en                                                                                        (  hrc_pll_perst_en                                                                                      ) ,
       .hrc_pma_perst_en                                                                                        (  hrc_pma_perst_en                                                                                      ) ,
       .hrc_rstctl_1ms                                                                                          (  hrc_rstctl_1ms                                                                                        ) ,
       .hrc_rstctl_1us                                                                                          (  hrc_rstctl_1us                                                                                        ) ,
       .hrc_rstctl_timer_type_a                                                                                 (  hrc_rstctl_timer_type_a                                                                               ) ,
       .hrc_rstctl_timer_type_f                                                                                 (  hrc_rstctl_timer_type_f                                                                               ) ,
       .hrc_rstctl_timer_type_g                                                                                 (  hrc_rstctl_timer_type_g                                                                               ) ,
       .hrc_rstctl_timer_type_h                                                                                 (  hrc_rstctl_timer_type_h                                                                               ) ,
       .hrc_rstctl_timer_type_i                                                                                 (  hrc_rstctl_timer_type_i                                                                               ) ,
       .hrc_rstctl_timer_type_j                                                                                 (  hrc_rstctl_timer_type_j                                                                               ) ,
       .hrc_rstctl_timer_value_a                                                                                (  hrc_rstctl_timer_value_a                                                                              ) ,
       .hrc_rstctl_timer_value_f                                                                                (  hrc_rstctl_timer_value_f                                                                              ) ,
       .hrc_rstctl_timer_value_g                                                                                (  hrc_rstctl_timer_value_g                                                                              ) ,
       .hrc_rstctl_timer_value_h                                                                                (  hrc_rstctl_timer_value_h                                                                              ) ,
       .hrc_rstctl_timer_value_i                                                                                (  hrc_rstctl_timer_value_i                                                                              ) ,
       .hrc_rstctl_timer_value_j                                                                                (  hrc_rstctl_timer_value_j                                                                              ) ,
       .hrc_rx_pcs_rst_n_active                                                                                 (  hrc_rx_pcs_rst_n_active                                                                               ) ,
       .hrc_rx_pll_lock_active                                                                                  (  hrc_rx_pll_lock_active                                                                                ) ,
       .hrc_rx_pma_rstb_active                                                                                  (  hrc_rx_pma_rstb_active                                                                                ) ,
       .hrc_soft_rstctrl_clr                                                                                    (  hrc_soft_rstctrl_clr                                                                                  ) ,
       .hrc_soft_rstctrl_en                                                                                     (  hrc_soft_rstctrl_en                                                                                   ) ,
       .hrc_tx_lc_pll_rstb_active                                                                               (  hrc_tx_lc_pll_rstb_active                                                                             ) ,
       .hrc_tx_lcff_pll_lock_active                                                                             (  hrc_tx_lcff_pll_lock_active                                                                           ) ,
       .hrc_tx_pcs_rst_n_active                                                                                 (  hrc_tx_pcs_rst_n_active                                                                               ) ,
       .irq_misc_ctrl                                                                                           (  irq_misc_ctrl                                                                                         ) ,
       .k_phy_misc_ctrl_rsvd_0_5                                                                                (  k_phy_misc_ctrl_rsvd_0_5                                                                              ) ,
       .k_phy_misc_ctrl_rsvd_13_15                                                                              (  k_phy_misc_ctrl_rsvd_13_15                                                                            ) ,
       .pf0_ack_n_fts                                                                                           (  pf0_ack_n_fts                                                                                         ) ,
       .pf0_adv_err_int_msg_num                                                                                 (  pf0_adv_err_int_msg_num                                                                               ) ,
       .pf0_aer_cap_aer_ext_cap_hdr_off_addr_byte2                                                              (  pf0_aer_cap_aer_ext_cap_hdr_off_addr_byte2                                                            ) ,
       .pf0_aer_cap_aer_ext_cap_hdr_off_addr_byte3                                                              (  pf0_aer_cap_aer_ext_cap_hdr_off_addr_byte3                                                            ) ,
       .pf0_aer_cap_root_err_status_off_addr_byte0                                                              (  pf0_aer_cap_root_err_status_off_addr_byte0                                                            ) ,
       .pf0_aer_cap_version                                                                                     (  pf0_aer_cap_version                                                                                   ) ,
       .pf0_aer_next_offset                                                                                     (  pf0_aer_next_offset                                                                                   ) ,
       .pf0_ari_cap_ari_base_addr_byte2                                                                         (  pf0_ari_cap_ari_base_addr_byte2                                                                       ) ,
       .pf0_ari_cap_ari_base_addr_byte3                                                                         (  pf0_ari_cap_ari_base_addr_byte3                                                                       ) ,
       .pf0_ari_cap_version                                                                                     (  pf0_ari_cap_version                                                                                   ) ,
       .pf0_ari_next_offset                                                                                     (  pf0_ari_next_offset                                                                                   ) ,
       .pf0_ats_cap_ats_cap_hdr_reg_addr_byte2                                                                  (  pf0_ats_cap_ats_cap_hdr_reg_addr_byte2                                                                ) ,
       .pf0_ats_cap_ats_cap_hdr_reg_addr_byte3                                                                  (  pf0_ats_cap_ats_cap_hdr_reg_addr_byte3                                                                ) ,
       .pf0_ats_cap_ats_capabilities_ctrl_reg_addr_byte0                                                        (  pf0_ats_cap_ats_capabilities_ctrl_reg_addr_byte0                                                      ) ,
       .pf0_ats_cap_version                                                                                     (  pf0_ats_cap_version                                                                                   ) ,
       .pf0_ats_capabilities_ctrl_reg_rsvdp_7                                                                   (  pf0_ats_capabilities_ctrl_reg_rsvdp_7                                                                 ) ,
       .pf0_ats_next_offset                                                                                     (  pf0_ats_next_offset                                                                                   ) ,
       .pf0_auto_lane_flip_ctrl_en                                                                              (  pf0_auto_lane_flip_ctrl_en                                                                            ) ,
       .pf0_aux_clk_freq                                                                                        (  pf0_aux_clk_freq                                                                                      ) ,
       .pf0_aux_clk_freq_off_rsvdp_10                                                                           (  pf0_aux_clk_freq_off_rsvdp_10                                                                         ) ,
       .pf0_aux_curr                                                                                            (  pf0_aux_curr                                                                                          ) ,
       .pf0_bar0_mem_io                                                                                         (  pf0_bar0_mem_io                                                                                       ) ,
       .pf0_bar0_prefetch                                                                                       (  pf0_bar0_prefetch                                                                                     ) ,
       .pf0_bar0_start                                                                                          (  pf0_bar0_start                                                                                        ) ,
       .pf0_bar0_type                                                                                           (  pf0_bar0_type                                                                                         ) ,
       .pf0_bar1_mem_io                                                                                         (  pf0_bar1_mem_io                                                                                       ) ,
       .pf0_bar1_prefetch                                                                                       (  pf0_bar1_prefetch                                                                                     ) ,
       .pf0_bar1_start                                                                                          (  pf0_bar1_start                                                                                        ) ,
       .pf0_bar1_type                                                                                           (  pf0_bar1_type                                                                                         ) ,
       .pf0_bar2_mem_io                                                                                         (  pf0_bar2_mem_io                                                                                       ) ,
       .pf0_bar2_prefetch                                                                                       (  pf0_bar2_prefetch                                                                                     ) ,
       .pf0_bar2_start                                                                                          (  pf0_bar2_start                                                                                        ) ,
       .pf0_bar2_type                                                                                           (  pf0_bar2_type                                                                                         ) ,
       .pf0_bar3_mem_io                                                                                         (  pf0_bar3_mem_io                                                                                       ) ,
       .pf0_bar3_prefetch                                                                                       (  pf0_bar3_prefetch                                                                                     ) ,
       .pf0_bar3_start                                                                                          (  pf0_bar3_start                                                                                        ) ,
       .pf0_bar3_type                                                                                           (  pf0_bar3_type                                                                                         ) ,
       .pf0_bar4_mem_io                                                                                         (  pf0_bar4_mem_io                                                                                       ) ,
       .pf0_bar4_prefetch                                                                                       (  pf0_bar4_prefetch                                                                                     ) ,
       .pf0_bar4_start                                                                                          (  pf0_bar4_start                                                                                        ) ,
       .pf0_bar4_type                                                                                           (  pf0_bar4_type                                                                                         ) ,
       .pf0_bar5_mem_io                                                                                         (  pf0_bar5_mem_io                                                                                       ) ,
       .pf0_bar5_prefetch                                                                                       (  pf0_bar5_prefetch                                                                                     ) ,
       .pf0_bar5_start                                                                                          (  pf0_bar5_start                                                                                        ) ,
       .pf0_bar5_type                                                                                           (  pf0_bar5_type                                                                                         ) ,
       .pf0_base_class_code                                                                                     (  pf0_base_class_code                                                                                   ) ,
       .pf0_cap_id_nxt_ptr_reg_rsvdp_20                                                                         (  pf0_cap_id_nxt_ptr_reg_rsvdp_20                                                                       ) ,
       .pf0_cap_pointer                                                                                         (  pf0_cap_pointer                                                                                       ) ,
       .pf0_cardbus_cis_pointer                                                                                 (  pf0_cardbus_cis_pointer                                                                               ) ,
       .pf0_common_clk_n_fts                                                                                    (  pf0_common_clk_n_fts                                                                                  ) ,
       .pf0_con_status_reg_rsvdp_2                                                                              (  pf0_con_status_reg_rsvdp_2                                                                            ) ,
       .pf0_con_status_reg_rsvdp_4                                                                              (  pf0_con_status_reg_rsvdp_4                                                                            ) ,
       .pf0_config_phy_tx_change                                                                                (  pf0_config_phy_tx_change                                                                              ) ,
       .pf0_config_tx_comp_rx                                                                                   (  pf0_config_tx_comp_rx                                                                                 ) ,
       .pf0_cross_link_active                                                                                   (  pf0_cross_link_active                                                                                 ) ,
       .pf0_cross_link_en                                                                                       (  pf0_cross_link_en                                                                                     ) ,
       .pf0_d1_support                                                                                          (  pf0_d1_support                                                                                        ) ,
       .pf0_d2_support                                                                                          (  pf0_d2_support                                                                                        ) ,
       .pf0_dbi_reserved_0                                                                                      (  pf0_dbi_reserved_0                                                                                    ) ,
       .pf0_dbi_reserved_1                                                                                      (  pf0_dbi_reserved_1                                                                                    ) ,
       .pf0_dbi_reserved_10                                                                                     (  pf0_dbi_reserved_10                                                                                   ) ,
       .pf0_dbi_reserved_11                                                                                     (  pf0_dbi_reserved_11                                                                                   ) ,
       .pf0_dbi_reserved_12                                                                                     (  pf0_dbi_reserved_12                                                                                   ) ,
       .pf0_dbi_reserved_13                                                                                     (  pf0_dbi_reserved_13                                                                                   ) ,
       .pf0_dbi_reserved_14                                                                                     (  pf0_dbi_reserved_14                                                                                   ) ,
       .pf0_dbi_reserved_15                                                                                     (  pf0_dbi_reserved_15                                                                                   ) ,
       .pf0_dbi_reserved_16                                                                                     (  pf0_dbi_reserved_16                                                                                   ) ,
       .pf0_dbi_reserved_17                                                                                     (  pf0_dbi_reserved_17                                                                                   ) ,
       .pf0_dbi_reserved_18                                                                                     (  pf0_dbi_reserved_18                                                                                   ) ,
       .pf0_dbi_reserved_19                                                                                     (  pf0_dbi_reserved_19                                                                                   ) ,
       .pf0_dbi_reserved_2                                                                                      (  pf0_dbi_reserved_2                                                                                    ) ,
       .pf0_dbi_reserved_20                                                                                     (  pf0_dbi_reserved_20                                                                                   ) ,
       .pf0_dbi_reserved_21                                                                                     (  pf0_dbi_reserved_21                                                                                   ) ,
       .pf0_dbi_reserved_22                                                                                     (  pf0_dbi_reserved_22                                                                                   ) ,
       .pf0_dbi_reserved_23                                                                                     (  pf0_dbi_reserved_23                                                                                   ) ,
       .pf0_dbi_reserved_24                                                                                     (  pf0_dbi_reserved_24                                                                                   ) ,
       .pf0_dbi_reserved_25                                                                                     (  pf0_dbi_reserved_25                                                                                   ) ,
       .pf0_dbi_reserved_26                                                                                     (  pf0_dbi_reserved_26                                                                                   ) ,
       .pf0_dbi_reserved_27                                                                                     (  pf0_dbi_reserved_27                                                                                   ) ,
       .pf0_dbi_reserved_28                                                                                     (  pf0_dbi_reserved_28                                                                                   ) ,
       .pf0_dbi_reserved_29                                                                                     (  pf0_dbi_reserved_29                                                                                   ) ,
       .pf0_dbi_reserved_3                                                                                      (  pf0_dbi_reserved_3                                                                                    ) ,
       .pf0_dbi_reserved_30                                                                                     (  pf0_dbi_reserved_30                                                                                   ) ,
       .pf0_dbi_reserved_31                                                                                     (  pf0_dbi_reserved_31                                                                                   ) ,
       .pf0_dbi_reserved_32                                                                                     (  pf0_dbi_reserved_32                                                                                   ) ,
       .pf0_dbi_reserved_33                                                                                     (  pf0_dbi_reserved_33                                                                                   ) ,
       .pf0_dbi_reserved_34                                                                                     (  pf0_dbi_reserved_34                                                                                   ) ,
       .pf0_dbi_reserved_35                                                                                     (  pf0_dbi_reserved_35                                                                                   ) ,
       .pf0_dbi_reserved_36                                                                                     (  pf0_dbi_reserved_36                                                                                   ) ,
       .pf0_dbi_reserved_37                                                                                     (  pf0_dbi_reserved_37                                                                                   ) ,
       .pf0_dbi_reserved_38                                                                                     (  pf0_dbi_reserved_38                                                                                   ) ,
       .pf0_dbi_reserved_39                                                                                     (  pf0_dbi_reserved_39                                                                                   ) ,
       .pf0_dbi_reserved_4                                                                                      (  pf0_dbi_reserved_4                                                                                    ) ,
       .pf0_dbi_reserved_40                                                                                     (  pf0_dbi_reserved_40                                                                                   ) ,
       .pf0_dbi_reserved_41                                                                                     (  pf0_dbi_reserved_41                                                                                   ) ,
       .pf0_dbi_reserved_42                                                                                     (  pf0_dbi_reserved_42                                                                                   ) ,
       .pf0_dbi_reserved_43                                                                                     (  pf0_dbi_reserved_43                                                                                   ) ,
       .pf0_dbi_reserved_44                                                                                     (  pf0_dbi_reserved_44                                                                                   ) ,
       .pf0_dbi_reserved_45                                                                                     (  pf0_dbi_reserved_45                                                                                   ) ,
       .pf0_dbi_reserved_46                                                                                     (  pf0_dbi_reserved_46                                                                                   ) ,
       .pf0_dbi_reserved_47                                                                                     (  pf0_dbi_reserved_47                                                                                   ) ,
       .pf0_dbi_reserved_48                                                                                     (  pf0_dbi_reserved_48                                                                                   ) ,
       .pf0_dbi_reserved_49                                                                                     (  pf0_dbi_reserved_49                                                                                   ) ,
       .pf0_dbi_reserved_5                                                                                      (  pf0_dbi_reserved_5                                                                                    ) ,
       .pf0_dbi_reserved_50                                                                                     (  pf0_dbi_reserved_50                                                                                   ) ,
       .pf0_dbi_reserved_51                                                                                     (  pf0_dbi_reserved_51                                                                                   ) ,
       .pf0_dbi_reserved_52                                                                                     (  pf0_dbi_reserved_52                                                                                   ) ,
       .pf0_dbi_reserved_53                                                                                     (  pf0_dbi_reserved_53                                                                                   ) ,
       .pf0_dbi_reserved_54                                                                                     (  pf0_dbi_reserved_54                                                                                   ) ,
       .pf0_dbi_reserved_55                                                                                     (  pf0_dbi_reserved_55                                                                                   ) ,
       .pf0_dbi_reserved_56                                                                                     (  pf0_dbi_reserved_56                                                                                   ) ,
       .pf0_dbi_reserved_57                                                                                     (  pf0_dbi_reserved_57                                                                                   ) ,
       .pf0_dbi_reserved_6                                                                                      (  pf0_dbi_reserved_6                                                                                    ) ,
       .pf0_dbi_reserved_7                                                                                      (  pf0_dbi_reserved_7                                                                                    ) ,
       .pf0_dbi_reserved_8                                                                                      (  pf0_dbi_reserved_8                                                                                    ) ,
       .pf0_dbi_reserved_9                                                                                      (  pf0_dbi_reserved_9                                                                                    ) ,
       .pf0_dbi_ro_wr_en                                                                                        (  pf0_dbi_ro_wr_en                                                                                      ) ,
       .pf0_device_capabilities_reg_rsvdp_12                                                                    (  pf0_device_capabilities_reg_rsvdp_12                                                                  ) ,
       .pf0_device_capabilities_reg_rsvdp_16                                                                    (  pf0_device_capabilities_reg_rsvdp_16                                                                  ) ,
       .pf0_device_capabilities_reg_rsvdp_29                                                                    (  pf0_device_capabilities_reg_rsvdp_29                                                                  ) ,
       .pf0_direct_speed_change                                                                                 (  pf0_direct_speed_change                                                                               ) ,
       .pf0_disable_fc_wd_timer                                                                                 (  pf0_disable_fc_wd_timer                                                                               ) ,
       .pf0_disable_scrambler_gen_3                                                                             (  pf0_disable_scrambler_gen_3                                                                           ) ,
       .pf0_dll_link_en                                                                                         (  pf0_dll_link_en                                                                                       ) ,
       .pf0_dsi                                                                                                 (  pf0_dsi                                                                                               ) ,
       .pf0_dsp_rx_preset_hint0                                                                                 (  pf0_dsp_rx_preset_hint0                                                                               ) ,
       .pf0_dsp_rx_preset_hint1                                                                                 (  pf0_dsp_rx_preset_hint1                                                                               ) ,
       .pf0_dsp_rx_preset_hint10                                                                                (  pf0_dsp_rx_preset_hint10                                                                              ) ,
       .pf0_dsp_rx_preset_hint11                                                                                (  pf0_dsp_rx_preset_hint11                                                                              ) ,
       .pf0_dsp_rx_preset_hint12                                                                                (  pf0_dsp_rx_preset_hint12                                                                              ) ,
       .pf0_dsp_rx_preset_hint13                                                                                (  pf0_dsp_rx_preset_hint13                                                                              ) ,
       .pf0_dsp_rx_preset_hint14                                                                                (  pf0_dsp_rx_preset_hint14                                                                              ) ,
       .pf0_dsp_rx_preset_hint15                                                                                (  pf0_dsp_rx_preset_hint15                                                                              ) ,
       .pf0_dsp_rx_preset_hint2                                                                                 (  pf0_dsp_rx_preset_hint2                                                                               ) ,
       .pf0_dsp_rx_preset_hint3                                                                                 (  pf0_dsp_rx_preset_hint3                                                                               ) ,
       .pf0_dsp_rx_preset_hint4                                                                                 (  pf0_dsp_rx_preset_hint4                                                                               ) ,
       .pf0_dsp_rx_preset_hint5                                                                                 (  pf0_dsp_rx_preset_hint5                                                                               ) ,
       .pf0_dsp_rx_preset_hint6                                                                                 (  pf0_dsp_rx_preset_hint6                                                                               ) ,
       .pf0_dsp_rx_preset_hint7                                                                                 (  pf0_dsp_rx_preset_hint7                                                                               ) ,
       .pf0_dsp_rx_preset_hint8                                                                                 (  pf0_dsp_rx_preset_hint8                                                                               ) ,
       .pf0_dsp_rx_preset_hint9                                                                                 (  pf0_dsp_rx_preset_hint9                                                                               ) ,
       .pf0_dsp_tx_preset0                                                                                      (  pf0_dsp_tx_preset0                                                                                    ) ,
       .pf0_dsp_tx_preset1                                                                                      (  pf0_dsp_tx_preset1                                                                                    ) ,
       .pf0_dsp_tx_preset10                                                                                     (  pf0_dsp_tx_preset10                                                                                   ) ,
       .pf0_dsp_tx_preset11                                                                                     (  pf0_dsp_tx_preset11                                                                                   ) ,
       .pf0_dsp_tx_preset12                                                                                     (  pf0_dsp_tx_preset12                                                                                   ) ,
       .pf0_dsp_tx_preset13                                                                                     (  pf0_dsp_tx_preset13                                                                                   ) ,
       .pf0_dsp_tx_preset14                                                                                     (  pf0_dsp_tx_preset14                                                                                   ) ,
       .pf0_dsp_tx_preset15                                                                                     (  pf0_dsp_tx_preset15                                                                                   ) ,
       .pf0_dsp_tx_preset2                                                                                      (  pf0_dsp_tx_preset2                                                                                    ) ,
       .pf0_dsp_tx_preset3                                                                                      (  pf0_dsp_tx_preset3                                                                                    ) ,
       .pf0_dsp_tx_preset4                                                                                      (  pf0_dsp_tx_preset4                                                                                    ) ,
       .pf0_dsp_tx_preset5                                                                                      (  pf0_dsp_tx_preset5                                                                                    ) ,
       .pf0_dsp_tx_preset6                                                                                      (  pf0_dsp_tx_preset6                                                                                    ) ,
       .pf0_dsp_tx_preset7                                                                                      (  pf0_dsp_tx_preset7                                                                                    ) ,
       .pf0_dsp_tx_preset8                                                                                      (  pf0_dsp_tx_preset8                                                                                    ) ,
       .pf0_dsp_tx_preset9                                                                                      (  pf0_dsp_tx_preset9                                                                                    ) ,
       .pf0_eidle_timer                                                                                         (  pf0_eidle_timer                                                                                       ) ,
       .pf0_eq_eieos_cnt                                                                                        (  pf0_eq_eieos_cnt                                                                                      ) ,
       .pf0_eq_phase_2_3                                                                                        (  pf0_eq_phase_2_3                                                                                      ) ,
       .pf0_eq_redo                                                                                             (  pf0_eq_redo                                                                                           ) ,
       .pf0_exp_rom_bar_mask_reg_rsvdp_1                                                                        (  pf0_exp_rom_bar_mask_reg_rsvdp_1                                                                      ) ,
       .pf0_exp_rom_base_addr_reg_rsvdp_1                                                                       (  pf0_exp_rom_base_addr_reg_rsvdp_1                                                                     ) ,
       .pf0_fast_link_mode                                                                                      (  pf0_fast_link_mode                                                                                    ) ,
       .pf0_fast_training_seq                                                                                   (  pf0_fast_training_seq                                                                                 ) ,
       .pf0_forward_user_vsec                                                                                   (  pf0_forward_user_vsec                                                                                 ) ,
       .pf0_gen1_ei_inference                                                                                   (  pf0_gen1_ei_inference                                                                                 ) ,
       .pf0_gen2_ctrl_off_rsvdp_22                                                                              (  pf0_gen2_ctrl_off_rsvdp_22                                                                            ) ,
       .pf0_gen3_dc_balance_disable                                                                             (  pf0_gen3_dc_balance_disable                                                                           ) ,
       .pf0_gen3_dllp_xmt_delay_disable                                                                         (  pf0_gen3_dllp_xmt_delay_disable                                                                       ) ,
       .pf0_gen3_eq_control_off_rsvdp_26                                                                        (  pf0_gen3_eq_control_off_rsvdp_26                                                                      ) ,
       .pf0_gen3_eq_control_off_rsvdp_6                                                                         (  pf0_gen3_eq_control_off_rsvdp_6                                                                       ) ,
       .pf0_gen3_eq_eval_2ms_disable                                                                            (  pf0_gen3_eq_eval_2ms_disable                                                                          ) ,
       .pf0_gen3_eq_fb_mode                                                                                     (  pf0_gen3_eq_fb_mode                                                                                   ) ,
       .pf0_gen3_eq_fb_mode_dir_change_off_rsvdp_18                                                             (  pf0_gen3_eq_fb_mode_dir_change_off_rsvdp_18                                                           ) ,
       .pf0_gen3_eq_fmdc_max_post_cusror_delta                                                                  (  pf0_gen3_eq_fmdc_max_post_cusror_delta                                                                ) ,
       .pf0_gen3_eq_fmdc_max_pre_cusror_delta                                                                   (  pf0_gen3_eq_fmdc_max_pre_cusror_delta                                                                 ) ,
       .pf0_gen3_eq_fmdc_n_evals                                                                                (  pf0_gen3_eq_fmdc_n_evals                                                                              ) ,
       .pf0_gen3_eq_fmdc_t_min_phase23                                                                          (  pf0_gen3_eq_fmdc_t_min_phase23                                                                        ) ,
       .pf0_gen3_eq_fom_inc_initial_eval                                                                        (  pf0_gen3_eq_fom_inc_initial_eval                                                                      ) ,
       .pf0_gen3_eq_local_fs                                                                                    (  pf0_gen3_eq_local_fs                                                                                  ) ,
       .pf0_gen3_eq_local_fs_lf_off_rsvdp_12                                                                    (  pf0_gen3_eq_local_fs_lf_off_rsvdp_12                                                                  ) ,
       .pf0_gen3_eq_local_lf                                                                                    (  pf0_gen3_eq_local_lf                                                                                  ) ,
       .pf0_gen3_eq_phase23_exit_mode                                                                           (  pf0_gen3_eq_phase23_exit_mode                                                                         ) ,
       .pf0_gen3_eq_pset_req_as_coef                                                                            (  pf0_gen3_eq_pset_req_as_coef                                                                          ) ,
       .pf0_gen3_eq_pset_req_vec                                                                                (  pf0_gen3_eq_pset_req_vec                                                                              ) ,
       .pf0_gen3_equalization_disable                                                                           (  pf0_gen3_equalization_disable                                                                         ) ,
       .pf0_gen3_related_off_rsvdp_1                                                                            (  pf0_gen3_related_off_rsvdp_1                                                                          ) ,
       .pf0_gen3_related_off_rsvdp_13                                                                           (  pf0_gen3_related_off_rsvdp_13                                                                         ) ,
       .pf0_gen3_related_off_rsvdp_19                                                                           (  pf0_gen3_related_off_rsvdp_19                                                                         ) ,
       .pf0_gen3_zrxdc_noncompl                                                                                 (  pf0_gen3_zrxdc_noncompl                                                                               ) ,
       .pf0_global_inval_spprtd                                                                                 (  pf0_global_inval_spprtd                                                                               ) ,
       .pf0_header_type                                                                                         (  pf0_header_type                                                                                       ) ,
       .pf0_int_pin                                                                                             (  pf0_int_pin                                                                                           ) ,
       .pf0_invalidate_q_depth                                                                                  (  pf0_invalidate_q_depth                                                                                ) ,
       .pf0_lane_equalization_control01_reg_rsvdp_15                                                            (  pf0_lane_equalization_control01_reg_rsvdp_15                                                          ) ,
       .pf0_lane_equalization_control01_reg_rsvdp_23                                                            (  pf0_lane_equalization_control01_reg_rsvdp_23                                                          ) ,
       .pf0_lane_equalization_control01_reg_rsvdp_31                                                            (  pf0_lane_equalization_control01_reg_rsvdp_31                                                          ) ,
       .pf0_lane_equalization_control01_reg_rsvdp_7                                                             (  pf0_lane_equalization_control01_reg_rsvdp_7                                                           ) ,
       .pf0_lane_equalization_control1011_reg_rsvdp_15                                                          (  pf0_lane_equalization_control1011_reg_rsvdp_15                                                        ) ,
       .pf0_lane_equalization_control1011_reg_rsvdp_23                                                          (  pf0_lane_equalization_control1011_reg_rsvdp_23                                                        ) ,
       .pf0_lane_equalization_control1011_reg_rsvdp_31                                                          (  pf0_lane_equalization_control1011_reg_rsvdp_31                                                        ) ,
       .pf0_lane_equalization_control1011_reg_rsvdp_7                                                           (  pf0_lane_equalization_control1011_reg_rsvdp_7                                                         ) ,
       .pf0_lane_equalization_control1213_reg_rsvdp_15                                                          (  pf0_lane_equalization_control1213_reg_rsvdp_15                                                        ) ,
       .pf0_lane_equalization_control1213_reg_rsvdp_23                                                          (  pf0_lane_equalization_control1213_reg_rsvdp_23                                                        ) ,
       .pf0_lane_equalization_control1213_reg_rsvdp_31                                                          (  pf0_lane_equalization_control1213_reg_rsvdp_31                                                        ) ,
       .pf0_lane_equalization_control1213_reg_rsvdp_7                                                           (  pf0_lane_equalization_control1213_reg_rsvdp_7                                                         ) ,
       .pf0_lane_equalization_control1415_reg_rsvdp_15                                                          (  pf0_lane_equalization_control1415_reg_rsvdp_15                                                        ) ,
       .pf0_lane_equalization_control1415_reg_rsvdp_23                                                          (  pf0_lane_equalization_control1415_reg_rsvdp_23                                                        ) ,
       .pf0_lane_equalization_control1415_reg_rsvdp_31                                                          (  pf0_lane_equalization_control1415_reg_rsvdp_31                                                        ) ,
       .pf0_lane_equalization_control1415_reg_rsvdp_7                                                           (  pf0_lane_equalization_control1415_reg_rsvdp_7                                                         ) ,
       .pf0_lane_equalization_control23_reg_rsvdp_15                                                            (  pf0_lane_equalization_control23_reg_rsvdp_15                                                          ) ,
       .pf0_lane_equalization_control23_reg_rsvdp_23                                                            (  pf0_lane_equalization_control23_reg_rsvdp_23                                                          ) ,
       .pf0_lane_equalization_control23_reg_rsvdp_31                                                            (  pf0_lane_equalization_control23_reg_rsvdp_31                                                          ) ,
       .pf0_lane_equalization_control23_reg_rsvdp_7                                                             (  pf0_lane_equalization_control23_reg_rsvdp_7                                                           ) ,
       .pf0_lane_equalization_control45_reg_rsvdp_15                                                            (  pf0_lane_equalization_control45_reg_rsvdp_15                                                          ) ,
       .pf0_lane_equalization_control45_reg_rsvdp_23                                                            (  pf0_lane_equalization_control45_reg_rsvdp_23                                                          ) ,
       .pf0_lane_equalization_control45_reg_rsvdp_31                                                            (  pf0_lane_equalization_control45_reg_rsvdp_31                                                          ) ,
       .pf0_lane_equalization_control45_reg_rsvdp_7                                                             (  pf0_lane_equalization_control45_reg_rsvdp_7                                                           ) ,
       .pf0_lane_equalization_control67_reg_rsvdp_15                                                            (  pf0_lane_equalization_control67_reg_rsvdp_15                                                          ) ,
       .pf0_lane_equalization_control67_reg_rsvdp_23                                                            (  pf0_lane_equalization_control67_reg_rsvdp_23                                                          ) ,
       .pf0_lane_equalization_control67_reg_rsvdp_31                                                            (  pf0_lane_equalization_control67_reg_rsvdp_31                                                          ) ,
       .pf0_lane_equalization_control67_reg_rsvdp_7                                                             (  pf0_lane_equalization_control67_reg_rsvdp_7                                                           ) ,
       .pf0_lane_equalization_control89_reg_rsvdp_15                                                            (  pf0_lane_equalization_control89_reg_rsvdp_15                                                          ) ,
       .pf0_lane_equalization_control89_reg_rsvdp_23                                                            (  pf0_lane_equalization_control89_reg_rsvdp_23                                                          ) ,
       .pf0_lane_equalization_control89_reg_rsvdp_31                                                            (  pf0_lane_equalization_control89_reg_rsvdp_31                                                          ) ,
       .pf0_lane_equalization_control89_reg_rsvdp_7                                                             (  pf0_lane_equalization_control89_reg_rsvdp_7                                                           ) ,
       .pf0_link_capabilities_reg_rsvdp_23                                                                      (  pf0_link_capabilities_reg_rsvdp_23                                                                    ) ,
       .pf0_link_capable                                                                                        (  pf0_link_capable                                                                                      ) ,
       .pf0_link_control_link_status_reg_rsvdp_12                                                               (  pf0_link_control_link_status_reg_rsvdp_12                                                             ) ,
       .pf0_link_control_link_status_reg_rsvdp_2                                                                (  pf0_link_control_link_status_reg_rsvdp_2                                                              ) ,
       .pf0_link_control_link_status_reg_rsvdp_25                                                               (  pf0_link_control_link_status_reg_rsvdp_25                                                             ) ,
       .pf0_link_control_link_status_reg_rsvdp_9                                                                (  pf0_link_control_link_status_reg_rsvdp_9                                                              ) ,
       .pf0_link_disable                                                                                        (  pf0_link_disable                                                                                      ) ,
       .pf0_link_num                                                                                            (  pf0_link_num                                                                                          ) ,
       .pf0_loopback_enable                                                                                     (  pf0_loopback_enable                                                                                   ) ,
       .pf0_mask_radm_1                                                                                         (  pf0_mask_radm_1                                                                                       ) ,
       .pf0_mask_radm_2                                                                                         (  pf0_mask_radm_2                                                                                       ) ,
       .pf0_max_func_num                                                                                        (  pf0_max_func_num                                                                                      ) ,
       .pf0_misc_control_1_off_rsvdp_1                                                                          (  pf0_misc_control_1_off_rsvdp_1                                                                        ) ,
       .pf0_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte1                                                     (  pf0_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte1                                                   ) ,
       .pf0_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte2                                                     (  pf0_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte2                                                   ) ,
       .pf0_msix_cap_msix_pba_offset_reg_addr_byte0                                                             (  pf0_msix_cap_msix_pba_offset_reg_addr_byte0                                                           ) ,
       .pf0_msix_cap_msix_pba_offset_reg_addr_byte1                                                             (  pf0_msix_cap_msix_pba_offset_reg_addr_byte1                                                           ) ,
       .pf0_msix_cap_msix_pba_offset_reg_addr_byte2                                                             (  pf0_msix_cap_msix_pba_offset_reg_addr_byte2                                                           ) ,
       .pf0_msix_cap_msix_pba_offset_reg_addr_byte3                                                             (  pf0_msix_cap_msix_pba_offset_reg_addr_byte3                                                           ) ,
       .pf0_msix_cap_msix_table_offset_reg_addr_byte0                                                           (  pf0_msix_cap_msix_table_offset_reg_addr_byte0                                                         ) ,
       .pf0_msix_cap_msix_table_offset_reg_addr_byte1                                                           (  pf0_msix_cap_msix_table_offset_reg_addr_byte1                                                         ) ,
       .pf0_msix_cap_msix_table_offset_reg_addr_byte2                                                           (  pf0_msix_cap_msix_table_offset_reg_addr_byte2                                                         ) ,
       .pf0_msix_cap_msix_table_offset_reg_addr_byte3                                                           (  pf0_msix_cap_msix_table_offset_reg_addr_byte3                                                         ) ,
       .pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte1                                                   (  pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte1                                                 ) ,
       .pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte2                                                   (  pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte2                                                 ) ,
       .pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte3                                                   (  pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte3                                                 ) ,
       .pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte2                                        (  pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte2                                      ) ,
       .pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte3                                        (  pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte3                                      ) ,
       .pf0_multi_func                                                                                          (  pf0_multi_func                                                                                        ) ,
       .pf0_no_soft_rst                                                                                         (  pf0_no_soft_rst                                                                                       ) ,
       .pf0_num_of_lanes                                                                                        (  pf0_num_of_lanes                                                                                      ) ,
       .pf0_page_aligned_req                                                                                    (  pf0_page_aligned_req                                                                                  ) ,
       .pf0_pci_msi_64_bit_addr_cap                                                                             (  pf0_pci_msi_64_bit_addr_cap                                                                           ) ,
       .pf0_pci_msi_cap_next_offset                                                                             (  pf0_pci_msi_cap_next_offset                                                                           ) ,
       .pf0_pci_msi_enable                                                                                      (  pf0_pci_msi_enable                                                                                    ) ,
       .pf0_pci_msi_multiple_msg_cap                                                                            (  pf0_pci_msi_multiple_msg_cap                                                                          ) ,
       .pf0_pci_msi_multiple_msg_en                                                                             (  pf0_pci_msi_multiple_msg_en                                                                           ) ,
       .pf0_pci_msix_bir                                                                                        (  pf0_pci_msix_bir                                                                                      ) ,
       .pf0_pci_msix_cap_id_next_ctrl_reg_rsvdp_27                                                              (  pf0_pci_msix_cap_id_next_ctrl_reg_rsvdp_27                                                            ) ,
       .pf0_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                                        (  pf0_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                                      ) ,
       .pf0_pci_msix_cap_next_offset                                                                            (  pf0_pci_msix_cap_next_offset                                                                          ) ,
       .pf0_pci_msix_enable                                                                                     (  pf0_pci_msix_enable                                                                                   ) ,
       .pf0_pci_msix_enable_vfcomm_cs2                                                                          (  pf0_pci_msix_enable_vfcomm_cs2                                                                        ) ,
       .pf0_pci_msix_function_mask                                                                              (  pf0_pci_msix_function_mask                                                                            ) ,
       .pf0_pci_msix_function_mask_vfcomm_cs2                                                                   (  pf0_pci_msix_function_mask_vfcomm_cs2                                                                 ) ,
       .pf0_pci_msix_pba                                                                                        (  pf0_pci_msix_pba                                                                                      ) ,
       .pf0_pci_msix_pba_offset                                                                                 (  pf0_pci_msix_pba_offset                                                                               ) ,
       .pf0_pci_msix_table_offset                                                                               (  pf0_pci_msix_table_offset                                                                             ) ,
       .pf0_pci_msix_table_size                                                                                 (  pf0_pci_msix_table_size                                                                               ) ,
       .pf0_pci_msix_table_size_vfcomm_cs2                                                                      (  pf0_pci_msix_table_size_vfcomm_cs2                                                                    ) ,
       .pf0_pci_type0_bar0_enabled                                                                              (  pf0_pci_type0_bar0_enabled                                                                            ) ,
       .pf0_pci_type0_bar0_mask_31_1                                                                            (  pf0_pci_type0_bar0_mask_31_1                                                                          ) ,
       .pf0_pci_type0_bar1_dummy_mask_7_1                                                                       (  pf0_pci_type0_bar1_dummy_mask_7_1                                                                     ) ,
       .pf0_pci_type0_bar1_enabled                                                                              (  pf0_pci_type0_bar1_enabled                                                                            ) ,
       .pf0_pci_type0_bar1_enabled_or_mask64lsb                                                                 (  pf0_pci_type0_bar1_enabled_or_mask64lsb                                                               ) ,
       .pf0_pci_type0_bar1_mask_31_1                                                                            (  pf0_pci_type0_bar1_mask_31_1                                                                          ) ,
       .pf0_pci_type0_bar2_enabled                                                                              (  pf0_pci_type0_bar2_enabled                                                                            ) ,
       .pf0_pci_type0_bar2_mask_31_1                                                                            (  pf0_pci_type0_bar2_mask_31_1                                                                          ) ,
       .pf0_pci_type0_bar3_dummy_mask_7_1                                                                       (  pf0_pci_type0_bar3_dummy_mask_7_1                                                                     ) ,
       .pf0_pci_type0_bar3_enabled                                                                              (  pf0_pci_type0_bar3_enabled                                                                            ) ,
       .pf0_pci_type0_bar3_enabled_or_mask64lsb                                                                 (  pf0_pci_type0_bar3_enabled_or_mask64lsb                                                               ) ,
       .pf0_pci_type0_bar3_mask_31_1                                                                            (  pf0_pci_type0_bar3_mask_31_1                                                                          ) ,
       .pf0_pci_type0_bar4_enabled                                                                              (  pf0_pci_type0_bar4_enabled                                                                            ) ,
       .pf0_pci_type0_bar4_mask_31_1                                                                            (  pf0_pci_type0_bar4_mask_31_1                                                                          ) ,
       .pf0_pci_type0_bar5_dummy_mask_7_1                                                                       (  pf0_pci_type0_bar5_dummy_mask_7_1                                                                     ) ,
       .pf0_pci_type0_bar5_enabled                                                                              (  pf0_pci_type0_bar5_enabled                                                                            ) ,
       .pf0_pci_type0_bar5_enabled_or_mask64lsb                                                                 (  pf0_pci_type0_bar5_enabled_or_mask64lsb                                                               ) ,
       .pf0_pci_type0_bar5_mask_31_1                                                                            (  pf0_pci_type0_bar5_mask_31_1                                                                          ) ,
       .pf0_pci_type0_device_id                                                                                 (  pf0_pci_type0_device_id                                                                               ) ,
       .pf0_pci_type0_vendor_id                                                                                 (  pf0_pci_type0_vendor_id                                                                               ) ,
       .pf0_pcie_cap_active_state_link_pm_control                                                               (  pf0_pcie_cap_active_state_link_pm_control                                                             ) ,
       .pf0_pcie_cap_active_state_link_pm_support                                                               (  pf0_pcie_cap_active_state_link_pm_support                                                             ) ,
       .pf0_pcie_cap_aspm_opt_compliance                                                                        (  pf0_pcie_cap_aspm_opt_compliance                                                                      ) ,
       .pf0_pcie_cap_attention_indicator                                                                        (  pf0_pcie_cap_attention_indicator                                                                      ) ,
       .pf0_pcie_cap_attention_indicator_button                                                                 (  pf0_pcie_cap_attention_indicator_button                                                               ) ,
       .pf0_pcie_cap_aux_power_pm_en                                                                            (  pf0_pcie_cap_aux_power_pm_en                                                                          ) ,
       .pf0_pcie_cap_clock_power_man                                                                            (  pf0_pcie_cap_clock_power_man                                                                          ) ,
       .pf0_pcie_cap_common_clk_config                                                                          (  pf0_pcie_cap_common_clk_config                                                                        ) ,
       .pf0_pcie_cap_crs_sw_visibility                                                                          (  pf0_pcie_cap_crs_sw_visibility                                                                        ) ,
       .pf0_pcie_cap_device_capabilities_reg_addr_byte0                                                         (  pf0_pcie_cap_device_capabilities_reg_addr_byte0                                                       ) ,
       .pf0_pcie_cap_device_capabilities_reg_addr_byte1                                                         (  pf0_pcie_cap_device_capabilities_reg_addr_byte1                                                       ) ,
       .pf0_pcie_cap_device_capabilities_reg_addr_byte2                                                         (  pf0_pcie_cap_device_capabilities_reg_addr_byte2                                                       ) ,
       .pf0_pcie_cap_device_control_device_status_addr_byte1                                                    (  pf0_pcie_cap_device_control_device_status_addr_byte1                                                  ) ,
       .pf0_pcie_cap_dll_active                                                                                 (  pf0_pcie_cap_dll_active                                                                               ) ,
       .pf0_pcie_cap_dll_active_rep_cap                                                                         (  pf0_pcie_cap_dll_active_rep_cap                                                                       ) ,
       .pf0_pcie_cap_electromech_interlock                                                                      (  pf0_pcie_cap_electromech_interlock                                                                    ) ,
       .pf0_pcie_cap_en_clk_power_man                                                                           (  pf0_pcie_cap_en_clk_power_man                                                                         ) ,
       .pf0_pcie_cap_en_no_snoop                                                                                (  pf0_pcie_cap_en_no_snoop                                                                              ) ,
       .pf0_pcie_cap_enter_compliance                                                                           (  pf0_pcie_cap_enter_compliance                                                                         ) ,
       .pf0_pcie_cap_ep_l0s_accpt_latency                                                                       (  pf0_pcie_cap_ep_l0s_accpt_latency                                                                     ) ,
       .pf0_pcie_cap_ep_l1_accpt_latency                                                                        (  pf0_pcie_cap_ep_l1_accpt_latency                                                                      ) ,
       .pf0_pcie_cap_ext_tag_en                                                                                 (  pf0_pcie_cap_ext_tag_en                                                                               ) ,
       .pf0_pcie_cap_ext_tag_supp                                                                               (  pf0_pcie_cap_ext_tag_supp                                                                             ) ,
       .pf0_pcie_cap_extended_synch                                                                             (  pf0_pcie_cap_extended_synch                                                                           ) ,
       .pf0_pcie_cap_flr_cap                                                                                    (  pf0_pcie_cap_flr_cap                                                                                  ) ,
       .pf0_pcie_cap_hot_plug_capable                                                                           (  pf0_pcie_cap_hot_plug_capable                                                                         ) ,
       .pf0_pcie_cap_hot_plug_surprise                                                                          (  pf0_pcie_cap_hot_plug_surprise                                                                        ) ,
       .pf0_pcie_cap_hw_auto_speed_disable                                                                      (  pf0_pcie_cap_hw_auto_speed_disable                                                                    ) ,
       .pf0_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvd                                                     (  pf0_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvd                                                   ) ,
       .pf0_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvdp_31                                                 (  pf0_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvdp_31                                               ) ,
       .pf0_pcie_cap_initiate_flr                                                                               (  pf0_pcie_cap_initiate_flr                                                                             ) ,
       .pf0_pcie_cap_l0s_exit_latency_commclk_dis                                                               (  pf0_pcie_cap_l0s_exit_latency_commclk_dis                                                             ) ,
       .pf0_pcie_cap_l0s_exit_latency_commclk_ena_cs2                                                           (  pf0_pcie_cap_l0s_exit_latency_commclk_ena_cs2                                                         ) ,
       .pf0_pcie_cap_l1_exit_latency_commclk_dis                                                                (  pf0_pcie_cap_l1_exit_latency_commclk_dis                                                              ) ,
       .pf0_pcie_cap_l1_exit_latency_commclk_ena_cs2                                                            (  pf0_pcie_cap_l1_exit_latency_commclk_ena_cs2                                                          ) ,
       .pf0_pcie_cap_link_auto_bw_int_en                                                                        (  pf0_pcie_cap_link_auto_bw_int_en                                                                      ) ,
       .pf0_pcie_cap_link_auto_bw_status                                                                        (  pf0_pcie_cap_link_auto_bw_status                                                                      ) ,
       .pf0_pcie_cap_link_bw_man_int_en                                                                         (  pf0_pcie_cap_link_bw_man_int_en                                                                       ) ,
       .pf0_pcie_cap_link_bw_man_status                                                                         (  pf0_pcie_cap_link_bw_man_status                                                                       ) ,
       .pf0_pcie_cap_link_bw_not_cap                                                                            (  pf0_pcie_cap_link_bw_not_cap                                                                          ) ,
       .pf0_pcie_cap_link_capabilities_reg_addr_byte0                                                           (  pf0_pcie_cap_link_capabilities_reg_addr_byte0                                                         ) ,
       .pf0_pcie_cap_link_capabilities_reg_addr_byte1                                                           (  pf0_pcie_cap_link_capabilities_reg_addr_byte1                                                         ) ,
       .pf0_pcie_cap_link_capabilities_reg_addr_byte2                                                           (  pf0_pcie_cap_link_capabilities_reg_addr_byte2                                                         ) ,
       .pf0_pcie_cap_link_capabilities_reg_addr_byte3                                                           (  pf0_pcie_cap_link_capabilities_reg_addr_byte3                                                         ) ,
       .pf0_pcie_cap_link_control2_link_status2_reg_addr_byte0                                                  (  pf0_pcie_cap_link_control2_link_status2_reg_addr_byte0                                                ) ,
       .pf0_pcie_cap_link_control_link_status_reg_addr_byte0                                                    (  pf0_pcie_cap_link_control_link_status_reg_addr_byte0                                                  ) ,
       .pf0_pcie_cap_link_control_link_status_reg_addr_byte1                                                    (  pf0_pcie_cap_link_control_link_status_reg_addr_byte1                                                  ) ,
       .pf0_pcie_cap_link_control_link_status_reg_addr_byte2                                                    (  pf0_pcie_cap_link_control_link_status_reg_addr_byte2                                                  ) ,
       .pf0_pcie_cap_link_disable                                                                               (  pf0_pcie_cap_link_disable                                                                             ) ,
       .pf0_pcie_cap_link_training                                                                              (  pf0_pcie_cap_link_training                                                                            ) ,
       .pf0_pcie_cap_max_link_speed                                                                             (  pf0_pcie_cap_max_link_speed                                                                           ) ,
       .pf0_pcie_cap_max_link_width                                                                             (  pf0_pcie_cap_max_link_width                                                                           ) ,
       .pf0_pcie_cap_max_payload_size                                                                           (  pf0_pcie_cap_max_payload_size                                                                         ) ,
       .pf0_pcie_cap_max_read_req_size                                                                          (  pf0_pcie_cap_max_read_req_size                                                                        ) ,
       .pf0_pcie_cap_mrl_sensor                                                                                 (  pf0_pcie_cap_mrl_sensor                                                                               ) ,
       .pf0_pcie_cap_nego_link_width                                                                            (  pf0_pcie_cap_nego_link_width                                                                          ) ,
       .pf0_pcie_cap_next_ptr                                                                                   (  pf0_pcie_cap_next_ptr                                                                                 ) ,
       .pf0_pcie_cap_no_cmd_cpl_support                                                                         (  pf0_pcie_cap_no_cmd_cpl_support                                                                       ) ,
       .pf0_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte1                                      (  pf0_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte1                                    ) ,
       .pf0_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte3                                      (  pf0_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte3                                    ) ,
       .pf0_pcie_cap_phantom_func_en                                                                            (  pf0_pcie_cap_phantom_func_en                                                                          ) ,
       .pf0_pcie_cap_phantom_func_support                                                                       (  pf0_pcie_cap_phantom_func_support                                                                     ) ,
       .pf0_pcie_cap_phy_slot_num                                                                               (  pf0_pcie_cap_phy_slot_num                                                                             ) ,
       .pf0_pcie_cap_port_num                                                                                   (  pf0_pcie_cap_port_num                                                                                 ) ,
       .pf0_pcie_cap_power_controller                                                                           (  pf0_pcie_cap_power_controller                                                                         ) ,
       .pf0_pcie_cap_power_indicator                                                                            (  pf0_pcie_cap_power_indicator                                                                          ) ,
       .pf0_pcie_cap_rcb                                                                                        (  pf0_pcie_cap_rcb                                                                                      ) ,
       .pf0_pcie_cap_retrain_link                                                                               (  pf0_pcie_cap_retrain_link                                                                             ) ,
       .pf0_pcie_cap_role_based_err_report                                                                      (  pf0_pcie_cap_role_based_err_report                                                                    ) ,
       .pf0_pcie_cap_root_control_root_capabilities_reg_addr_byte2                                              (  pf0_pcie_cap_root_control_root_capabilities_reg_addr_byte2                                            ) ,
       .pf0_pcie_cap_sel_deemphasis                                                                             (  pf0_pcie_cap_sel_deemphasis                                                                           ) ,
       .pf0_pcie_cap_shadow_link_capabilities_reg_addr_byte0                                                    (  pf0_pcie_cap_shadow_link_capabilities_reg_addr_byte0                                                  ) ,
       .pf0_pcie_cap_shadow_link_capabilities_reg_addr_byte1                                                    (  pf0_pcie_cap_shadow_link_capabilities_reg_addr_byte1                                                  ) ,
       .pf0_pcie_cap_slot_capabilities_reg_addr_byte0                                                           (  pf0_pcie_cap_slot_capabilities_reg_addr_byte0                                                         ) ,
       .pf0_pcie_cap_slot_capabilities_reg_addr_byte1                                                           (  pf0_pcie_cap_slot_capabilities_reg_addr_byte1                                                         ) ,
       .pf0_pcie_cap_slot_capabilities_reg_addr_byte2                                                           (  pf0_pcie_cap_slot_capabilities_reg_addr_byte2                                                         ) ,
       .pf0_pcie_cap_slot_capabilities_reg_addr_byte3                                                           (  pf0_pcie_cap_slot_capabilities_reg_addr_byte3                                                         ) ,
       .pf0_pcie_cap_slot_clk_config                                                                            (  pf0_pcie_cap_slot_clk_config                                                                          ) ,
       .pf0_pcie_cap_slot_power_limit_scale                                                                     (  pf0_pcie_cap_slot_power_limit_scale                                                                   ) ,
       .pf0_pcie_cap_slot_power_limit_value                                                                     (  pf0_pcie_cap_slot_power_limit_value                                                                   ) ,
       .pf0_pcie_cap_surprise_down_err_rep_cap                                                                  (  pf0_pcie_cap_surprise_down_err_rep_cap                                                                ) ,
       .pf0_pcie_cap_target_link_speed                                                                          (  pf0_pcie_cap_target_link_speed                                                                        ) ,
       .pf0_pcie_cap_tx_margin                                                                                  (  pf0_pcie_cap_tx_margin                                                                                ) ,
       .pf0_pcie_int_msg_num                                                                                    (  pf0_pcie_int_msg_num                                                                                  ) ,
       .pf0_pcie_slot_imp                                                                                       (  pf0_pcie_slot_imp                                                                                     ) ,
       .pf0_pipe_loopback                                                                                       (  pf0_pipe_loopback                                                                                     ) ,
       .pf0_pipe_loopback_control_off_rsvdp_27                                                                  (  pf0_pipe_loopback_control_off_rsvdp_27                                                                ) ,
       .pf0_pm_cap_cap_id_nxt_ptr_reg_addr_byte1                                                                (  pf0_pm_cap_cap_id_nxt_ptr_reg_addr_byte1                                                              ) ,
       .pf0_pm_cap_cap_id_nxt_ptr_reg_addr_byte2                                                                (  pf0_pm_cap_cap_id_nxt_ptr_reg_addr_byte2                                                              ) ,
       .pf0_pm_cap_cap_id_nxt_ptr_reg_addr_byte3                                                                (  pf0_pm_cap_cap_id_nxt_ptr_reg_addr_byte3                                                              ) ,
       .pf0_pm_cap_con_status_reg_addr_byte0                                                                    (  pf0_pm_cap_con_status_reg_addr_byte0                                                                  ) ,
       .pf0_pm_next_pointer                                                                                     (  pf0_pm_next_pointer                                                                                   ) ,
       .pf0_pm_spec_ver                                                                                         (  pf0_pm_spec_ver                                                                                       ) ,
       .pf0_pme_clk                                                                                             (  pf0_pme_clk                                                                                           ) ,
       .pf0_pme_support                                                                                         (  pf0_pme_support                                                                                       ) ,
       .pf0_port_link_ctrl_off_rsvdp_4                                                                          (  pf0_port_link_ctrl_off_rsvdp_4                                                                        ) ,
       .pf0_port_logic_ack_f_aspm_ctrl_off_addr_byte1                                                           (  pf0_port_logic_ack_f_aspm_ctrl_off_addr_byte1                                                         ) ,
       .pf0_port_logic_ack_f_aspm_ctrl_off_addr_byte2                                                           (  pf0_port_logic_ack_f_aspm_ctrl_off_addr_byte2                                                         ) ,
       .pf0_port_logic_aux_clk_freq_off_addr_byte0                                                              (  pf0_port_logic_aux_clk_freq_off_addr_byte0                                                            ) ,
       .pf0_port_logic_aux_clk_freq_off_addr_byte1                                                              (  pf0_port_logic_aux_clk_freq_off_addr_byte1                                                            ) ,
       .pf0_port_logic_filter_mask_2_off_addr_byte0                                                             (  pf0_port_logic_filter_mask_2_off_addr_byte0                                                           ) ,
       .pf0_port_logic_filter_mask_2_off_addr_byte1                                                             (  pf0_port_logic_filter_mask_2_off_addr_byte1                                                           ) ,
       .pf0_port_logic_filter_mask_2_off_addr_byte2                                                             (  pf0_port_logic_filter_mask_2_off_addr_byte2                                                           ) ,
       .pf0_port_logic_filter_mask_2_off_addr_byte3                                                             (  pf0_port_logic_filter_mask_2_off_addr_byte3                                                           ) ,
       .pf0_port_logic_gen2_ctrl_off_addr_byte0                                                                 (  pf0_port_logic_gen2_ctrl_off_addr_byte0                                                               ) ,
       .pf0_port_logic_gen2_ctrl_off_addr_byte1                                                                 (  pf0_port_logic_gen2_ctrl_off_addr_byte1                                                               ) ,
       .pf0_port_logic_gen2_ctrl_off_addr_byte2                                                                 (  pf0_port_logic_gen2_ctrl_off_addr_byte2                                                               ) ,
       .pf0_port_logic_gen3_eq_control_off_addr_byte0                                                           (  pf0_port_logic_gen3_eq_control_off_addr_byte0                                                         ) ,
       .pf0_port_logic_gen3_eq_control_off_addr_byte1                                                           (  pf0_port_logic_gen3_eq_control_off_addr_byte1                                                         ) ,
       .pf0_port_logic_gen3_eq_control_off_addr_byte2                                                           (  pf0_port_logic_gen3_eq_control_off_addr_byte2                                                         ) ,
       .pf0_port_logic_gen3_eq_control_off_addr_byte3                                                           (  pf0_port_logic_gen3_eq_control_off_addr_byte3                                                         ) ,
       .pf0_port_logic_gen3_eq_fb_mode_dir_change_off_addr_byte0                                                (  pf0_port_logic_gen3_eq_fb_mode_dir_change_off_addr_byte0                                              ) ,
       .pf0_port_logic_gen3_eq_fb_mode_dir_change_off_addr_byte1                                                (  pf0_port_logic_gen3_eq_fb_mode_dir_change_off_addr_byte1                                              ) ,
       .pf0_port_logic_gen3_eq_fb_mode_dir_change_off_addr_byte2                                                (  pf0_port_logic_gen3_eq_fb_mode_dir_change_off_addr_byte2                                              ) ,
       .pf0_port_logic_gen3_eq_local_fs_lf_off_addr_byte0                                                       (  pf0_port_logic_gen3_eq_local_fs_lf_off_addr_byte0                                                     ) ,
       .pf0_port_logic_gen3_eq_local_fs_lf_off_addr_byte1                                                       (  pf0_port_logic_gen3_eq_local_fs_lf_off_addr_byte1                                                     ) ,
       .pf0_port_logic_gen3_related_off_addr_byte0                                                              (  pf0_port_logic_gen3_related_off_addr_byte0                                                            ) ,
       .pf0_port_logic_gen3_related_off_addr_byte1                                                              (  pf0_port_logic_gen3_related_off_addr_byte1                                                            ) ,
       .pf0_port_logic_gen3_related_off_addr_byte2                                                              (  pf0_port_logic_gen3_related_off_addr_byte2                                                            ) ,
       .pf0_port_logic_misc_control_1_off_addr_byte0                                                            (  pf0_port_logic_misc_control_1_off_addr_byte0                                                          ) ,
       .pf0_port_logic_pipe_loopback_control_off_addr_byte3                                                     (  pf0_port_logic_pipe_loopback_control_off_addr_byte3                                                   ) ,
       .pf0_port_logic_port_force_off_addr_byte0                                                                (  pf0_port_logic_port_force_off_addr_byte0                                                              ) ,
       .pf0_port_logic_port_link_ctrl_off_addr_byte0                                                            (  pf0_port_logic_port_link_ctrl_off_addr_byte0                                                          ) ,
       .pf0_port_logic_port_link_ctrl_off_addr_byte2                                                            (  pf0_port_logic_port_link_ctrl_off_addr_byte2                                                          ) ,
       .pf0_port_logic_queue_status_off_addr_byte2                                                              (  pf0_port_logic_queue_status_off_addr_byte2                                                            ) ,
       .pf0_port_logic_queue_status_off_addr_byte3                                                              (  pf0_port_logic_queue_status_off_addr_byte3                                                            ) ,
       .pf0_port_logic_symbol_timer_filter_1_off_addr_byte0                                                     (  pf0_port_logic_symbol_timer_filter_1_off_addr_byte0                                                   ) ,
       .pf0_port_logic_symbol_timer_filter_1_off_addr_byte1                                                     (  pf0_port_logic_symbol_timer_filter_1_off_addr_byte1                                                   ) ,
       .pf0_port_logic_symbol_timer_filter_1_off_addr_byte2                                                     (  pf0_port_logic_symbol_timer_filter_1_off_addr_byte2                                                   ) ,
       .pf0_port_logic_symbol_timer_filter_1_off_addr_byte3                                                     (  pf0_port_logic_symbol_timer_filter_1_off_addr_byte3                                                   ) ,
       .pf0_port_logic_timer_ctrl_max_func_num_off_addr_byte0                                                   (  pf0_port_logic_timer_ctrl_max_func_num_off_addr_byte0                                                 ) ,
       .pf0_port_logic_vc0_cpl_rx_q_ctrl_off_addr_byte0                                                         (  pf0_port_logic_vc0_cpl_rx_q_ctrl_off_addr_byte0                                                       ) ,
       .pf0_port_logic_vc0_cpl_rx_q_ctrl_off_addr_byte1                                                         (  pf0_port_logic_vc0_cpl_rx_q_ctrl_off_addr_byte1                                                       ) ,
       .pf0_port_logic_vc0_cpl_rx_q_ctrl_off_addr_byte2                                                         (  pf0_port_logic_vc0_cpl_rx_q_ctrl_off_addr_byte2                                                       ) ,
       .pf0_port_logic_vc0_np_rx_q_ctrl_off_addr_byte0                                                          (  pf0_port_logic_vc0_np_rx_q_ctrl_off_addr_byte0                                                        ) ,
       .pf0_port_logic_vc0_np_rx_q_ctrl_off_addr_byte1                                                          (  pf0_port_logic_vc0_np_rx_q_ctrl_off_addr_byte1                                                        ) ,
       .pf0_port_logic_vc0_np_rx_q_ctrl_off_addr_byte2                                                          (  pf0_port_logic_vc0_np_rx_q_ctrl_off_addr_byte2                                                        ) ,
       .pf0_port_logic_vc0_p_rx_q_ctrl_off_addr_byte0                                                           (  pf0_port_logic_vc0_p_rx_q_ctrl_off_addr_byte0                                                         ) ,
       .pf0_port_logic_vc0_p_rx_q_ctrl_off_addr_byte1                                                           (  pf0_port_logic_vc0_p_rx_q_ctrl_off_addr_byte1                                                         ) ,
       .pf0_port_logic_vc0_p_rx_q_ctrl_off_addr_byte2                                                           (  pf0_port_logic_vc0_p_rx_q_ctrl_off_addr_byte2                                                         ) ,
       .pf0_power_state                                                                                         (  pf0_power_state                                                                                       ) ,
       .pf0_pre_det_lane                                                                                        (  pf0_pre_det_lane                                                                                      ) ,
       .pf0_program_interface                                                                                   (  pf0_program_interface                                                                                 ) ,
       .pf0_queue_status_off_rsvdp_29                                                                           (  pf0_queue_status_off_rsvdp_29                                                                         ) ,
       .pf0_reserved4                                                                                           (  pf0_reserved4                                                                                         ) ,
       .pf0_reserved6                                                                                           (  pf0_reserved6                                                                                         ) ,
       .pf0_reserved8                                                                                           (  pf0_reserved8                                                                                         ) ,
       .pf0_reserved_0_addr                                                                                     (  pf0_reserved_0_addr                                                                                   ) ,
       .pf0_reserved_10_addr                                                                                    (  pf0_reserved_10_addr                                                                                  ) ,
       .pf0_reserved_11_addr                                                                                    (  pf0_reserved_11_addr                                                                                  ) ,
       .pf0_reserved_12_addr                                                                                    (  pf0_reserved_12_addr                                                                                  ) ,
       .pf0_reserved_13_addr                                                                                    (  pf0_reserved_13_addr                                                                                  ) ,
       .pf0_reserved_14_addr                                                                                    (  pf0_reserved_14_addr                                                                                  ) ,
       .pf0_reserved_15_addr                                                                                    (  pf0_reserved_15_addr                                                                                  ) ,
       .pf0_reserved_16_addr                                                                                    (  pf0_reserved_16_addr                                                                                  ) ,
       .pf0_reserved_17_addr                                                                                    (  pf0_reserved_17_addr                                                                                  ) ,
       .pf0_reserved_18_addr                                                                                    (  pf0_reserved_18_addr                                                                                  ) ,
       .pf0_reserved_19_addr                                                                                    (  pf0_reserved_19_addr                                                                                  ) ,
       .pf0_reserved_1_addr                                                                                     (  pf0_reserved_1_addr                                                                                   ) ,
       .pf0_reserved_20_addr                                                                                    (  pf0_reserved_20_addr                                                                                  ) ,
       .pf0_reserved_21_addr                                                                                    (  pf0_reserved_21_addr                                                                                  ) ,
       .pf0_reserved_22_addr                                                                                    (  pf0_reserved_22_addr                                                                                  ) ,
       .pf0_reserved_23_addr                                                                                    (  pf0_reserved_23_addr                                                                                  ) ,
       .pf0_reserved_24_addr                                                                                    (  pf0_reserved_24_addr                                                                                  ) ,
       .pf0_reserved_25_addr                                                                                    (  pf0_reserved_25_addr                                                                                  ) ,
       .pf0_reserved_26_addr                                                                                    (  pf0_reserved_26_addr                                                                                  ) ,
       .pf0_reserved_27_addr                                                                                    (  pf0_reserved_27_addr                                                                                  ) ,
       .pf0_reserved_28_addr                                                                                    (  pf0_reserved_28_addr                                                                                  ) ,
       .pf0_reserved_29_addr                                                                                    (  pf0_reserved_29_addr                                                                                  ) ,
       .pf0_reserved_2_addr                                                                                     (  pf0_reserved_2_addr                                                                                   ) ,
       .pf0_reserved_30_addr                                                                                    (  pf0_reserved_30_addr                                                                                  ) ,
       .pf0_reserved_31_addr                                                                                    (  pf0_reserved_31_addr                                                                                  ) ,
       .pf0_reserved_32_addr                                                                                    (  pf0_reserved_32_addr                                                                                  ) ,
       .pf0_reserved_33_addr                                                                                    (  pf0_reserved_33_addr                                                                                  ) ,
       .pf0_reserved_34_addr                                                                                    (  pf0_reserved_34_addr                                                                                  ) ,
       .pf0_reserved_35_addr                                                                                    (  pf0_reserved_35_addr                                                                                  ) ,
       .pf0_reserved_36_addr                                                                                    (  pf0_reserved_36_addr                                                                                  ) ,
       .pf0_reserved_37_addr                                                                                    (  pf0_reserved_37_addr                                                                                  ) ,
       .pf0_reserved_38_addr                                                                                    (  pf0_reserved_38_addr                                                                                  ) ,
       .pf0_reserved_39_addr                                                                                    (  pf0_reserved_39_addr                                                                                  ) ,
       .pf0_reserved_3_addr                                                                                     (  pf0_reserved_3_addr                                                                                   ) ,
       .pf0_reserved_40_addr                                                                                    (  pf0_reserved_40_addr                                                                                  ) ,
       .pf0_reserved_41_addr                                                                                    (  pf0_reserved_41_addr                                                                                  ) ,
       .pf0_reserved_42_addr                                                                                    (  pf0_reserved_42_addr                                                                                  ) ,
       .pf0_reserved_43_addr                                                                                    (  pf0_reserved_43_addr                                                                                  ) ,
       .pf0_reserved_44_addr                                                                                    (  pf0_reserved_44_addr                                                                                  ) ,
       .pf0_reserved_45_addr                                                                                    (  pf0_reserved_45_addr                                                                                  ) ,
       .pf0_reserved_46_addr                                                                                    (  pf0_reserved_46_addr                                                                                  ) ,
       .pf0_reserved_47_addr                                                                                    (  pf0_reserved_47_addr                                                                                  ) ,
       .pf0_reserved_48_addr                                                                                    (  pf0_reserved_48_addr                                                                                  ) ,
       .pf0_reserved_49_addr                                                                                    (  pf0_reserved_49_addr                                                                                  ) ,
       .pf0_reserved_4_addr                                                                                     (  pf0_reserved_4_addr                                                                                   ) ,
       .pf0_reserved_50_addr                                                                                    (  pf0_reserved_50_addr                                                                                  ) ,
       .pf0_reserved_51_addr                                                                                    (  pf0_reserved_51_addr                                                                                  ) ,
       .pf0_reserved_52_addr                                                                                    (  pf0_reserved_52_addr                                                                                  ) ,
       .pf0_reserved_53_addr                                                                                    (  pf0_reserved_53_addr                                                                                  ) ,
       .pf0_reserved_54_addr                                                                                    (  pf0_reserved_54_addr                                                                                  ) ,
       .pf0_reserved_55_addr                                                                                    (  pf0_reserved_55_addr                                                                                  ) ,
       .pf0_reserved_56_addr                                                                                    (  pf0_reserved_56_addr                                                                                  ) ,
       .pf0_reserved_57_addr                                                                                    (  pf0_reserved_57_addr                                                                                  ) ,
       .pf0_reserved_5_addr                                                                                     (  pf0_reserved_5_addr                                                                                   ) ,
       .pf0_reserved_6_addr                                                                                     (  pf0_reserved_6_addr                                                                                   ) ,
       .pf0_reserved_7_addr                                                                                     (  pf0_reserved_7_addr                                                                                   ) ,
       .pf0_reserved_8_addr                                                                                     (  pf0_reserved_8_addr                                                                                   ) ,
       .pf0_reserved_9_addr                                                                                     (  pf0_reserved_9_addr                                                                                   ) ,
       .pf0_reset_assert                                                                                        (  pf0_reset_assert                                                                                      ) ,
       .pf0_revision_id                                                                                         (  pf0_revision_id                                                                                       ) ,
       .pf0_rom_bar_enable                                                                                      (  pf0_rom_bar_enable                                                                                    ) ,
       .pf0_rom_bar_enabled                                                                                     (  pf0_rom_bar_enabled                                                                                   ) ,
       .pf0_rom_mask                                                                                            (  pf0_rom_mask                                                                                          ) ,
       .pf0_root_control_root_capabilities_reg_rsvdp_17                                                         (  pf0_root_control_root_capabilities_reg_rsvdp_17                                                       ) ,
       .pf0_root_err_status_off_rsvdp_7                                                                         (  pf0_root_err_status_off_rsvdp_7                                                                       ) ,
       .pf0_rp_exp_rom_bar_mask_reg_rp_rom_rsvdp_1                                                              (  pf0_rp_exp_rom_bar_mask_reg_rp_rom_rsvdp_1                                                            ) ,
       .pf0_rp_rom_bar_enabled                                                                                  (  pf0_rp_rom_bar_enabled                                                                                ) ,
       .pf0_rp_rom_mask                                                                                         (  pf0_rp_rom_mask                                                                                       ) ,
       .pf0_rxeq_ph01_en                                                                                        (  pf0_rxeq_ph01_en                                                                                      ) ,
       .pf0_rxstatus_value                                                                                      (  pf0_rxstatus_value                                                                                    ) ,
       .pf0_scramble_disable                                                                                    (  pf0_scramble_disable                                                                                  ) ,
       .pf0_sel_deemphasis                                                                                      (  pf0_sel_deemphasis                                                                                    ) ,
       .pf0_shadow_link_capabilities_reg_shadow_rsvdp_23                                                        (  pf0_shadow_link_capabilities_reg_shadow_rsvdp_23                                                      ) ,
       .pf0_shadow_pcie_cap_active_state_link_pm_support                                                        (  pf0_shadow_pcie_cap_active_state_link_pm_support                                                      ) ,
       .pf0_shadow_pcie_cap_aspm_opt_compliance                                                                 (  pf0_shadow_pcie_cap_aspm_opt_compliance                                                               ) ,
       .pf0_shadow_pcie_cap_clock_power_man                                                                     (  pf0_shadow_pcie_cap_clock_power_man                                                                   ) ,
       .pf0_shadow_pcie_cap_dll_active_rep_cap                                                                  (  pf0_shadow_pcie_cap_dll_active_rep_cap                                                                ) ,
       .pf0_shadow_pcie_cap_link_bw_not_cap                                                                     (  pf0_shadow_pcie_cap_link_bw_not_cap                                                                   ) ,
       .pf0_shadow_pcie_cap_max_link_width                                                                      (  pf0_shadow_pcie_cap_max_link_width                                                                    ) ,
       .pf0_shadow_pcie_cap_surprise_down_err_rep_cap                                                           (  pf0_shadow_pcie_cap_surprise_down_err_rep_cap                                                         ) ,
       .pf0_shadow_sriov_vf_stride_ari_cs2                                                                      (  pf0_shadow_sriov_vf_stride_ari_cs2                                                                    ) ,
       .pf0_skp_int_val                                                                                         (  pf0_skp_int_val                                                                                       ) ,
       .pf0_sn_cap_ser_num_reg_dw_1_addr_byte0                                                                  (  pf0_sn_cap_ser_num_reg_dw_1_addr_byte0                                                                ) ,
       .pf0_sn_cap_ser_num_reg_dw_1_addr_byte1                                                                  (  pf0_sn_cap_ser_num_reg_dw_1_addr_byte1                                                                ) ,
       .pf0_sn_cap_ser_num_reg_dw_1_addr_byte2                                                                  (  pf0_sn_cap_ser_num_reg_dw_1_addr_byte2                                                                ) ,
       .pf0_sn_cap_ser_num_reg_dw_1_addr_byte3                                                                  (  pf0_sn_cap_ser_num_reg_dw_1_addr_byte3                                                                ) ,
       .pf0_sn_cap_ser_num_reg_dw_2_addr_byte0                                                                  (  pf0_sn_cap_ser_num_reg_dw_2_addr_byte0                                                                ) ,
       .pf0_sn_cap_ser_num_reg_dw_2_addr_byte1                                                                  (  pf0_sn_cap_ser_num_reg_dw_2_addr_byte1                                                                ) ,
       .pf0_sn_cap_ser_num_reg_dw_2_addr_byte2                                                                  (  pf0_sn_cap_ser_num_reg_dw_2_addr_byte2                                                                ) ,
       .pf0_sn_cap_ser_num_reg_dw_2_addr_byte3                                                                  (  pf0_sn_cap_ser_num_reg_dw_2_addr_byte3                                                                ) ,
       .pf0_sn_cap_sn_base_addr_byte2                                                                           (  pf0_sn_cap_sn_base_addr_byte2                                                                         ) ,
       .pf0_sn_cap_sn_base_addr_byte3                                                                           (  pf0_sn_cap_sn_base_addr_byte3                                                                         ) ,
       .pf0_sn_cap_version                                                                                      (  pf0_sn_cap_version                                                                                    ) ,
       .pf0_sn_next_offset                                                                                      (  pf0_sn_next_offset                                                                                    ) ,
       .pf0_sn_ser_num_reg_1_dw                                                                                 (  pf0_sn_ser_num_reg_1_dw                                                                               ) ,
       .pf0_sn_ser_num_reg_2_dw                                                                                 (  pf0_sn_ser_num_reg_2_dw                                                                               ) ,
       .pf0_spcie_cap_lane_equalization_control01_reg_addr_byte0                                                (  pf0_spcie_cap_lane_equalization_control01_reg_addr_byte0                                              ) ,
       .pf0_spcie_cap_lane_equalization_control01_reg_addr_byte1                                                (  pf0_spcie_cap_lane_equalization_control01_reg_addr_byte1                                              ) ,
       .pf0_spcie_cap_lane_equalization_control01_reg_addr_byte2                                                (  pf0_spcie_cap_lane_equalization_control01_reg_addr_byte2                                              ) ,
       .pf0_spcie_cap_lane_equalization_control01_reg_addr_byte3                                                (  pf0_spcie_cap_lane_equalization_control01_reg_addr_byte3                                              ) ,
       .pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte0                                              (  pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte0                                            ) ,
       .pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte1                                              (  pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte1                                            ) ,
       .pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte2                                              (  pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte2                                            ) ,
       .pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte3                                              (  pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte3                                            ) ,
       .pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte0                                              (  pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte0                                            ) ,
       .pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte1                                              (  pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte1                                            ) ,
       .pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte2                                              (  pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte2                                            ) ,
       .pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte3                                              (  pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte3                                            ) ,
       .pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte0                                              (  pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte0                                            ) ,
       .pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte1                                              (  pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte1                                            ) ,
       .pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte2                                              (  pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte2                                            ) ,
       .pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte3                                              (  pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte3                                            ) ,
       .pf0_spcie_cap_lane_equalization_control23_reg_addr_byte0                                                (  pf0_spcie_cap_lane_equalization_control23_reg_addr_byte0                                              ) ,
       .pf0_spcie_cap_lane_equalization_control23_reg_addr_byte1                                                (  pf0_spcie_cap_lane_equalization_control23_reg_addr_byte1                                              ) ,
       .pf0_spcie_cap_lane_equalization_control23_reg_addr_byte2                                                (  pf0_spcie_cap_lane_equalization_control23_reg_addr_byte2                                              ) ,
       .pf0_spcie_cap_lane_equalization_control23_reg_addr_byte3                                                (  pf0_spcie_cap_lane_equalization_control23_reg_addr_byte3                                              ) ,
       .pf0_spcie_cap_lane_equalization_control45_reg_addr_byte0                                                (  pf0_spcie_cap_lane_equalization_control45_reg_addr_byte0                                              ) ,
       .pf0_spcie_cap_lane_equalization_control45_reg_addr_byte1                                                (  pf0_spcie_cap_lane_equalization_control45_reg_addr_byte1                                              ) ,
       .pf0_spcie_cap_lane_equalization_control45_reg_addr_byte2                                                (  pf0_spcie_cap_lane_equalization_control45_reg_addr_byte2                                              ) ,
       .pf0_spcie_cap_lane_equalization_control45_reg_addr_byte3                                                (  pf0_spcie_cap_lane_equalization_control45_reg_addr_byte3                                              ) ,
       .pf0_spcie_cap_lane_equalization_control67_reg_addr_byte0                                                (  pf0_spcie_cap_lane_equalization_control67_reg_addr_byte0                                              ) ,
       .pf0_spcie_cap_lane_equalization_control67_reg_addr_byte1                                                (  pf0_spcie_cap_lane_equalization_control67_reg_addr_byte1                                              ) ,
       .pf0_spcie_cap_lane_equalization_control67_reg_addr_byte2                                                (  pf0_spcie_cap_lane_equalization_control67_reg_addr_byte2                                              ) ,
       .pf0_spcie_cap_lane_equalization_control67_reg_addr_byte3                                                (  pf0_spcie_cap_lane_equalization_control67_reg_addr_byte3                                              ) ,
       .pf0_spcie_cap_lane_equalization_control89_reg_addr_byte0                                                (  pf0_spcie_cap_lane_equalization_control89_reg_addr_byte0                                              ) ,
       .pf0_spcie_cap_lane_equalization_control89_reg_addr_byte1                                                (  pf0_spcie_cap_lane_equalization_control89_reg_addr_byte1                                              ) ,
       .pf0_spcie_cap_lane_equalization_control89_reg_addr_byte2                                                (  pf0_spcie_cap_lane_equalization_control89_reg_addr_byte2                                              ) ,
       .pf0_spcie_cap_lane_equalization_control89_reg_addr_byte3                                                (  pf0_spcie_cap_lane_equalization_control89_reg_addr_byte3                                              ) ,
       .pf0_spcie_cap_spcie_cap_header_reg_addr_byte2                                                           (  pf0_spcie_cap_spcie_cap_header_reg_addr_byte2                                                         ) ,
       .pf0_spcie_cap_spcie_cap_header_reg_addr_byte3                                                           (  pf0_spcie_cap_spcie_cap_header_reg_addr_byte3                                                         ) ,
       .pf0_spcie_cap_version                                                                                   (  pf0_spcie_cap_version                                                                                 ) ,
       .pf0_spcie_next_offset                                                                                   (  pf0_spcie_next_offset                                                                                 ) ,
       .pf0_sriov_cap_shadow_sriov_initial_vfs_addr_byte0                                                       (  pf0_sriov_cap_shadow_sriov_initial_vfs_addr_byte0                                                     ) ,
       .pf0_sriov_cap_shadow_sriov_initial_vfs_addr_byte1                                                       (  pf0_sriov_cap_shadow_sriov_initial_vfs_addr_byte1                                                     ) ,
       .pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte0                                                (  pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte0                                              ) ,
       .pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte1                                                (  pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte1                                              ) ,
       .pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte2                                                (  pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte2                                              ) ,
       .pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte3                                                (  pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte3                                              ) ,
       .pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte0                                                             (  pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte0                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte1                                                             (  pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte1                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte2                                                             (  pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte2                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte3                                                             (  pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte3                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte0                                                             (  pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte0                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte1                                                             (  pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte1                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte2                                                             (  pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte2                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte3                                                             (  pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte3                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte0                                                             (  pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte0                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte1                                                             (  pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte1                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte2                                                             (  pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte2                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte3                                                             (  pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte3                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte0                                                             (  pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte0                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte1                                                             (  pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte1                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte2                                                             (  pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte2                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte3                                                             (  pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte3                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte0                                                             (  pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte0                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte1                                                             (  pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte1                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte2                                                             (  pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte2                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte3                                                             (  pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte3                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte0                                                             (  pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte0                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte1                                                             (  pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte1                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte2                                                             (  pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte2                                                           ) ,
       .pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte3                                                             (  pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte3                                                           ) ,
       .pf0_sriov_cap_sriov_bar1_enable_reg_addr_byte0                                                          (  pf0_sriov_cap_sriov_bar1_enable_reg_addr_byte0                                                        ) ,
       .pf0_sriov_cap_sriov_bar3_enable_reg_addr_byte0                                                          (  pf0_sriov_cap_sriov_bar3_enable_reg_addr_byte0                                                        ) ,
       .pf0_sriov_cap_sriov_bar5_enable_reg_addr_byte0                                                          (  pf0_sriov_cap_sriov_bar5_enable_reg_addr_byte0                                                        ) ,
       .pf0_sriov_cap_sriov_base_reg_addr_byte2                                                                 (  pf0_sriov_cap_sriov_base_reg_addr_byte2                                                               ) ,
       .pf0_sriov_cap_sriov_base_reg_addr_byte3                                                                 (  pf0_sriov_cap_sriov_base_reg_addr_byte3                                                               ) ,
       .pf0_sriov_cap_sriov_initial_vfs_addr_byte0                                                              (  pf0_sriov_cap_sriov_initial_vfs_addr_byte0                                                            ) ,
       .pf0_sriov_cap_sriov_initial_vfs_addr_byte1                                                              (  pf0_sriov_cap_sriov_initial_vfs_addr_byte1                                                            ) ,
       .pf0_sriov_cap_sriov_vf_offset_position_addr_byte0                                                       (  pf0_sriov_cap_sriov_vf_offset_position_addr_byte0                                                     ) ,
       .pf0_sriov_cap_sriov_vf_offset_position_addr_byte1                                                       (  pf0_sriov_cap_sriov_vf_offset_position_addr_byte1                                                     ) ,
       .pf0_sriov_cap_sriov_vf_offset_position_addr_byte2                                                       (  pf0_sriov_cap_sriov_vf_offset_position_addr_byte2                                                     ) ,
       .pf0_sriov_cap_sriov_vf_offset_position_addr_byte3                                                       (  pf0_sriov_cap_sriov_vf_offset_position_addr_byte3                                                     ) ,
       .pf0_sriov_cap_sup_page_sizes_reg_addr_byte0                                                             (  pf0_sriov_cap_sup_page_sizes_reg_addr_byte0                                                           ) ,
       .pf0_sriov_cap_sup_page_sizes_reg_addr_byte1                                                             (  pf0_sriov_cap_sup_page_sizes_reg_addr_byte1                                                           ) ,
       .pf0_sriov_cap_sup_page_sizes_reg_addr_byte2                                                             (  pf0_sriov_cap_sup_page_sizes_reg_addr_byte2                                                           ) ,
       .pf0_sriov_cap_sup_page_sizes_reg_addr_byte3                                                             (  pf0_sriov_cap_sup_page_sizes_reg_addr_byte3                                                           ) ,
       .pf0_sriov_cap_version                                                                                   (  pf0_sriov_cap_version                                                                                 ) ,
       .pf0_sriov_cap_vf_bar0_reg_addr_byte0                                                                    (  pf0_sriov_cap_vf_bar0_reg_addr_byte0                                                                  ) ,
       .pf0_sriov_cap_vf_bar1_reg_addr_byte0                                                                    (  pf0_sriov_cap_vf_bar1_reg_addr_byte0                                                                  ) ,
       .pf0_sriov_cap_vf_bar2_reg_addr_byte0                                                                    (  pf0_sriov_cap_vf_bar2_reg_addr_byte0                                                                  ) ,
       .pf0_sriov_cap_vf_bar3_reg_addr_byte0                                                                    (  pf0_sriov_cap_vf_bar3_reg_addr_byte0                                                                  ) ,
       .pf0_sriov_cap_vf_bar4_reg_addr_byte0                                                                    (  pf0_sriov_cap_vf_bar4_reg_addr_byte0                                                                  ) ,
       .pf0_sriov_cap_vf_bar5_reg_addr_byte0                                                                    (  pf0_sriov_cap_vf_bar5_reg_addr_byte0                                                                  ) ,
       .pf0_sriov_cap_vf_device_id_reg_addr_byte2                                                               (  pf0_sriov_cap_vf_device_id_reg_addr_byte2                                                             ) ,
       .pf0_sriov_cap_vf_device_id_reg_addr_byte3                                                               (  pf0_sriov_cap_vf_device_id_reg_addr_byte3                                                             ) ,
       .pf0_sriov_initial_vfs_ari_cs2                                                                           (  pf0_sriov_initial_vfs_ari_cs2                                                                         ) ,
       .pf0_sriov_initial_vfs_nonari                                                                            (  pf0_sriov_initial_vfs_nonari                                                                          ) ,
       .pf0_sriov_next_offset                                                                                   (  pf0_sriov_next_offset                                                                                 ) ,
       .pf0_sriov_sup_page_size                                                                                 (  pf0_sriov_sup_page_size                                                                               ) ,
       .pf0_sriov_vf_bar0_mask                                                                                  (  pf0_sriov_vf_bar0_mask                                                                                ) ,
       .pf0_sriov_vf_bar0_prefetch                                                                              (  pf0_sriov_vf_bar0_prefetch                                                                            ) ,
       .pf0_sriov_vf_bar0_start                                                                                 (  pf0_sriov_vf_bar0_start                                                                               ) ,
       .pf0_sriov_vf_bar0_type                                                                                  (  pf0_sriov_vf_bar0_type                                                                                ) ,
       .pf0_sriov_vf_bar1_dummy_mask_7_1                                                                        (  pf0_sriov_vf_bar1_dummy_mask_7_1                                                                      ) ,
       .pf0_sriov_vf_bar1_enabled                                                                               (  pf0_sriov_vf_bar1_enabled                                                                             ) ,
       .pf0_sriov_vf_bar1_mask                                                                                  (  pf0_sriov_vf_bar1_mask                                                                                ) ,
       .pf0_sriov_vf_bar1_prefetch                                                                              (  pf0_sriov_vf_bar1_prefetch                                                                            ) ,
       .pf0_sriov_vf_bar1_start                                                                                 (  pf0_sriov_vf_bar1_start                                                                               ) ,
       .pf0_sriov_vf_bar1_type                                                                                  (  pf0_sriov_vf_bar1_type                                                                                ) ,
       .pf0_sriov_vf_bar2_mask                                                                                  (  pf0_sriov_vf_bar2_mask                                                                                ) ,
       .pf0_sriov_vf_bar2_prefetch                                                                              (  pf0_sriov_vf_bar2_prefetch                                                                            ) ,
       .pf0_sriov_vf_bar2_start                                                                                 (  pf0_sriov_vf_bar2_start                                                                               ) ,
       .pf0_sriov_vf_bar2_type                                                                                  (  pf0_sriov_vf_bar2_type                                                                                ) ,
       .pf0_sriov_vf_bar3_dummy_mask_7_1                                                                        (  pf0_sriov_vf_bar3_dummy_mask_7_1                                                                      ) ,
       .pf0_sriov_vf_bar3_enabled                                                                               (  pf0_sriov_vf_bar3_enabled                                                                             ) ,
       .pf0_sriov_vf_bar3_mask                                                                                  (  pf0_sriov_vf_bar3_mask                                                                                ) ,
       .pf0_sriov_vf_bar3_prefetch                                                                              (  pf0_sriov_vf_bar3_prefetch                                                                            ) ,
       .pf0_sriov_vf_bar3_start                                                                                 (  pf0_sriov_vf_bar3_start                                                                               ) ,
       .pf0_sriov_vf_bar3_type                                                                                  (  pf0_sriov_vf_bar3_type                                                                                ) ,
       .pf0_sriov_vf_bar4_mask                                                                                  (  pf0_sriov_vf_bar4_mask                                                                                ) ,
       .pf0_sriov_vf_bar4_prefetch                                                                              (  pf0_sriov_vf_bar4_prefetch                                                                            ) ,
       .pf0_sriov_vf_bar4_start                                                                                 (  pf0_sriov_vf_bar4_start                                                                               ) ,
       .pf0_sriov_vf_bar4_type                                                                                  (  pf0_sriov_vf_bar4_type                                                                                ) ,
       .pf0_sriov_vf_bar5_dummy_mask_7_1                                                                        (  pf0_sriov_vf_bar5_dummy_mask_7_1                                                                      ) ,
       .pf0_sriov_vf_bar5_enabled                                                                               (  pf0_sriov_vf_bar5_enabled                                                                             ) ,
       .pf0_sriov_vf_bar5_mask                                                                                  (  pf0_sriov_vf_bar5_mask                                                                                ) ,
       .pf0_sriov_vf_bar5_prefetch                                                                              (  pf0_sriov_vf_bar5_prefetch                                                                            ) ,
       .pf0_sriov_vf_bar5_start                                                                                 (  pf0_sriov_vf_bar5_start                                                                               ) ,
       .pf0_sriov_vf_bar5_type                                                                                  (  pf0_sriov_vf_bar5_type                                                                                ) ,
       .pf0_sriov_vf_device_id                                                                                  (  pf0_sriov_vf_device_id                                                                                ) ,
       .pf0_sriov_vf_offset_ari_cs2                                                                             (  pf0_sriov_vf_offset_ari_cs2                                                                           ) ,
       .pf0_sriov_vf_offset_nonari                                                                              (  pf0_sriov_vf_offset_nonari                                                                            ) ,
       .pf0_sriov_vf_stride_nonari                                                                              (  pf0_sriov_vf_stride_nonari                                                                            ) ,
       .pf0_subclass_code                                                                                       (  pf0_subclass_code                                                                                     ) ,
       .pf0_subsys_dev_id                                                                                       (  pf0_subsys_dev_id                                                                                     ) ,
       .pf0_subsys_vendor_id                                                                                    (  pf0_subsys_vendor_id                                                                                  ) ,
       .pf0_timer_mod_flow_control                                                                              (  pf0_timer_mod_flow_control                                                                            ) ,
       .pf0_timer_mod_flow_control_en                                                                           (  pf0_timer_mod_flow_control_en                                                                         ) ,
       .pf0_tph_cap_tph_ext_cap_hdr_reg_addr_byte2                                                              (  pf0_tph_cap_tph_ext_cap_hdr_reg_addr_byte2                                                            ) ,
       .pf0_tph_cap_tph_ext_cap_hdr_reg_addr_byte3                                                              (  pf0_tph_cap_tph_ext_cap_hdr_reg_addr_byte3                                                            ) ,
       .pf0_tph_cap_tph_req_cap_reg_addr_byte0                                                                  (  pf0_tph_cap_tph_req_cap_reg_addr_byte0                                                                ) ,
       .pf0_tph_cap_tph_req_cap_reg_addr_byte1                                                                  (  pf0_tph_cap_tph_req_cap_reg_addr_byte1                                                                ) ,
       .pf0_tph_cap_tph_req_cap_reg_addr_byte2                                                                  (  pf0_tph_cap_tph_req_cap_reg_addr_byte2                                                                ) ,
       .pf0_tph_cap_tph_req_cap_reg_addr_byte3                                                                  (  pf0_tph_cap_tph_req_cap_reg_addr_byte3                                                                ) ,
       .pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte0                                                       (  pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte0                                                     ) ,
       .pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte1                                                       (  pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte1                                                     ) ,
       .pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte2                                                       (  pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte2                                                     ) ,
       .pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte3                                                       (  pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte3                                                     ) ,
       .pf0_tph_req_cap_int_vec                                                                                 (  pf0_tph_req_cap_int_vec                                                                               ) ,
       .pf0_tph_req_cap_int_vec_vfcomm_cs2                                                                      (  pf0_tph_req_cap_int_vec_vfcomm_cs2                                                                    ) ,
       .pf0_tph_req_cap_reg_rsvdp_11                                                                            (  pf0_tph_req_cap_reg_rsvdp_11                                                                          ) ,
       .pf0_tph_req_cap_reg_rsvdp_27                                                                            (  pf0_tph_req_cap_reg_rsvdp_27                                                                          ) ,
       .pf0_tph_req_cap_reg_rsvdp_3                                                                             (  pf0_tph_req_cap_reg_rsvdp_3                                                                           ) ,
       .pf0_tph_req_cap_reg_vfcomm_cs2_rsvdp_11_vfcomm_cs2                                                      (  pf0_tph_req_cap_reg_vfcomm_cs2_rsvdp_11_vfcomm_cs2                                                    ) ,
       .pf0_tph_req_cap_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                                                      (  pf0_tph_req_cap_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                                                    ) ,
       .pf0_tph_req_cap_reg_vfcomm_cs2_rsvdp_3_vfcomm_cs2                                                       (  pf0_tph_req_cap_reg_vfcomm_cs2_rsvdp_3_vfcomm_cs2                                                     ) ,
       .pf0_tph_req_cap_st_table_loc_0                                                                          (  pf0_tph_req_cap_st_table_loc_0                                                                        ) ,
       .pf0_tph_req_cap_st_table_loc_0_vfcomm_cs2                                                               (  pf0_tph_req_cap_st_table_loc_0_vfcomm_cs2                                                             ) ,
       .pf0_tph_req_cap_st_table_loc_1                                                                          (  pf0_tph_req_cap_st_table_loc_1                                                                        ) ,
       .pf0_tph_req_cap_st_table_loc_1_vfcomm_cs2                                                               (  pf0_tph_req_cap_st_table_loc_1_vfcomm_cs2                                                             ) ,
       .pf0_tph_req_cap_st_table_size                                                                           (  pf0_tph_req_cap_st_table_size                                                                         ) ,
       .pf0_tph_req_cap_st_table_size_vfcomm_cs2                                                                (  pf0_tph_req_cap_st_table_size_vfcomm_cs2                                                              ) ,
       .pf0_tph_req_cap_ver                                                                                     (  pf0_tph_req_cap_ver                                                                                   ) ,
       .pf0_tph_req_device_spec                                                                                 (  pf0_tph_req_device_spec                                                                               ) ,
       .pf0_tph_req_device_spec_vfcomm_cs2                                                                      (  pf0_tph_req_device_spec_vfcomm_cs2                                                                    ) ,
       .pf0_tph_req_extended_tph                                                                                (  pf0_tph_req_extended_tph                                                                              ) ,
       .pf0_tph_req_extended_tph_vfcomm_cs2                                                                     (  pf0_tph_req_extended_tph_vfcomm_cs2                                                                   ) ,
       .pf0_tph_req_next_ptr                                                                                    (  pf0_tph_req_next_ptr                                                                                  ) ,
       .pf0_tph_req_no_st_mode                                                                                  (  pf0_tph_req_no_st_mode                                                                                ) ,
       .pf0_tph_req_no_st_mode_vfcomm_cs2                                                                       (  pf0_tph_req_no_st_mode_vfcomm_cs2                                                                     ) ,
       .pf0_type0_hdr_bar0_mask_reg_addr_byte0                                                                  (  pf0_type0_hdr_bar0_mask_reg_addr_byte0                                                                ) ,
       .pf0_type0_hdr_bar0_mask_reg_addr_byte1                                                                  (  pf0_type0_hdr_bar0_mask_reg_addr_byte1                                                                ) ,
       .pf0_type0_hdr_bar0_mask_reg_addr_byte2                                                                  (  pf0_type0_hdr_bar0_mask_reg_addr_byte2                                                                ) ,
       .pf0_type0_hdr_bar0_mask_reg_addr_byte3                                                                  (  pf0_type0_hdr_bar0_mask_reg_addr_byte3                                                                ) ,
       .pf0_type0_hdr_bar0_reg_addr_byte0                                                                       (  pf0_type0_hdr_bar0_reg_addr_byte0                                                                     ) ,
       .pf0_type0_hdr_bar1_enable_reg_addr_byte0                                                                (  pf0_type0_hdr_bar1_enable_reg_addr_byte0                                                              ) ,
       .pf0_type0_hdr_bar1_mask_reg_addr_byte0                                                                  (  pf0_type0_hdr_bar1_mask_reg_addr_byte0                                                                ) ,
       .pf0_type0_hdr_bar1_mask_reg_addr_byte1                                                                  (  pf0_type0_hdr_bar1_mask_reg_addr_byte1                                                                ) ,
       .pf0_type0_hdr_bar1_mask_reg_addr_byte2                                                                  (  pf0_type0_hdr_bar1_mask_reg_addr_byte2                                                                ) ,
       .pf0_type0_hdr_bar1_mask_reg_addr_byte3                                                                  (  pf0_type0_hdr_bar1_mask_reg_addr_byte3                                                                ) ,
       .pf0_type0_hdr_bar1_reg_addr_byte0                                                                       (  pf0_type0_hdr_bar1_reg_addr_byte0                                                                     ) ,
       .pf0_type0_hdr_bar2_mask_reg_addr_byte0                                                                  (  pf0_type0_hdr_bar2_mask_reg_addr_byte0                                                                ) ,
       .pf0_type0_hdr_bar2_mask_reg_addr_byte1                                                                  (  pf0_type0_hdr_bar2_mask_reg_addr_byte1                                                                ) ,
       .pf0_type0_hdr_bar2_mask_reg_addr_byte2                                                                  (  pf0_type0_hdr_bar2_mask_reg_addr_byte2                                                                ) ,
       .pf0_type0_hdr_bar2_mask_reg_addr_byte3                                                                  (  pf0_type0_hdr_bar2_mask_reg_addr_byte3                                                                ) ,
       .pf0_type0_hdr_bar2_reg_addr_byte0                                                                       (  pf0_type0_hdr_bar2_reg_addr_byte0                                                                     ) ,
       .pf0_type0_hdr_bar3_enable_reg_addr_byte0                                                                (  pf0_type0_hdr_bar3_enable_reg_addr_byte0                                                              ) ,
       .pf0_type0_hdr_bar3_mask_reg_addr_byte0                                                                  (  pf0_type0_hdr_bar3_mask_reg_addr_byte0                                                                ) ,
       .pf0_type0_hdr_bar3_mask_reg_addr_byte1                                                                  (  pf0_type0_hdr_bar3_mask_reg_addr_byte1                                                                ) ,
       .pf0_type0_hdr_bar3_mask_reg_addr_byte2                                                                  (  pf0_type0_hdr_bar3_mask_reg_addr_byte2                                                                ) ,
       .pf0_type0_hdr_bar3_mask_reg_addr_byte3                                                                  (  pf0_type0_hdr_bar3_mask_reg_addr_byte3                                                                ) ,
       .pf0_type0_hdr_bar3_reg_addr_byte0                                                                       (  pf0_type0_hdr_bar3_reg_addr_byte0                                                                     ) ,
       .pf0_type0_hdr_bar4_mask_reg_addr_byte0                                                                  (  pf0_type0_hdr_bar4_mask_reg_addr_byte0                                                                ) ,
       .pf0_type0_hdr_bar4_mask_reg_addr_byte1                                                                  (  pf0_type0_hdr_bar4_mask_reg_addr_byte1                                                                ) ,
       .pf0_type0_hdr_bar4_mask_reg_addr_byte2                                                                  (  pf0_type0_hdr_bar4_mask_reg_addr_byte2                                                                ) ,
       .pf0_type0_hdr_bar4_mask_reg_addr_byte3                                                                  (  pf0_type0_hdr_bar4_mask_reg_addr_byte3                                                                ) ,
       .pf0_type0_hdr_bar4_reg_addr_byte0                                                                       (  pf0_type0_hdr_bar4_reg_addr_byte0                                                                     ) ,
       .pf0_type0_hdr_bar5_enable_reg_addr_byte0                                                                (  pf0_type0_hdr_bar5_enable_reg_addr_byte0                                                              ) ,
       .pf0_type0_hdr_bar5_mask_reg_addr_byte0                                                                  (  pf0_type0_hdr_bar5_mask_reg_addr_byte0                                                                ) ,
       .pf0_type0_hdr_bar5_mask_reg_addr_byte1                                                                  (  pf0_type0_hdr_bar5_mask_reg_addr_byte1                                                                ) ,
       .pf0_type0_hdr_bar5_mask_reg_addr_byte2                                                                  (  pf0_type0_hdr_bar5_mask_reg_addr_byte2                                                                ) ,
       .pf0_type0_hdr_bar5_mask_reg_addr_byte3                                                                  (  pf0_type0_hdr_bar5_mask_reg_addr_byte3                                                                ) ,
       .pf0_type0_hdr_bar5_reg_addr_byte0                                                                       (  pf0_type0_hdr_bar5_reg_addr_byte0                                                                     ) ,
       .pf0_type0_hdr_bist_header_type_latency_cache_line_size_reg_addr_byte2                                   (  pf0_type0_hdr_bist_header_type_latency_cache_line_size_reg_addr_byte2                                 ) ,
       .pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte0                                                            (  pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte0                                                          ) ,
       .pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte1                                                            (  pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte1                                                          ) ,
       .pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte2                                                            (  pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte2                                                          ) ,
       .pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte3                                                            (  pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte3                                                          ) ,
       .pf0_type0_hdr_class_code_revision_id_addr_byte0                                                         (  pf0_type0_hdr_class_code_revision_id_addr_byte0                                                       ) ,
       .pf0_type0_hdr_class_code_revision_id_addr_byte1                                                         (  pf0_type0_hdr_class_code_revision_id_addr_byte1                                                       ) ,
       .pf0_type0_hdr_class_code_revision_id_addr_byte2                                                         (  pf0_type0_hdr_class_code_revision_id_addr_byte2                                                       ) ,
       .pf0_type0_hdr_class_code_revision_id_addr_byte3                                                         (  pf0_type0_hdr_class_code_revision_id_addr_byte3                                                       ) ,
       .pf0_type0_hdr_device_id_vendor_id_reg_addr_byte0                                                        (  pf0_type0_hdr_device_id_vendor_id_reg_addr_byte0                                                      ) ,
       .pf0_type0_hdr_device_id_vendor_id_reg_addr_byte1                                                        (  pf0_type0_hdr_device_id_vendor_id_reg_addr_byte1                                                      ) ,
       .pf0_type0_hdr_device_id_vendor_id_reg_addr_byte2                                                        (  pf0_type0_hdr_device_id_vendor_id_reg_addr_byte2                                                      ) ,
       .pf0_type0_hdr_device_id_vendor_id_reg_addr_byte3                                                        (  pf0_type0_hdr_device_id_vendor_id_reg_addr_byte3                                                      ) ,
       .pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte0                                                           (  pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte0                                                         ) ,
       .pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte1                                                           (  pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte1                                                         ) ,
       .pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte2                                                           (  pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte2                                                         ) ,
       .pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte3                                                           (  pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte3                                                         ) ,
       .pf0_type0_hdr_exp_rom_base_addr_reg_addr_byte0                                                          (  pf0_type0_hdr_exp_rom_base_addr_reg_addr_byte0                                                        ) ,
       .pf0_type0_hdr_max_latency_min_grant_interrupt_pin_interrupt_line_reg_addr_byte1                         (  pf0_type0_hdr_max_latency_min_grant_interrupt_pin_interrupt_line_reg_addr_byte1                       ) ,
       .pf0_type0_hdr_pci_cap_ptr_reg_addr_byte0                                                                (  pf0_type0_hdr_pci_cap_ptr_reg_addr_byte0                                                              ) ,
       .pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte0                                                        (  pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte0                                                      ) ,
       .pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte1                                                        (  pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte1                                                      ) ,
       .pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte2                                                        (  pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte2                                                      ) ,
       .pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte3                                                        (  pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte3                                                      ) ,
       .pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte0                                           (  pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte0                                         ) ,
       .pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte1                                           (  pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte1                                         ) ,
       .pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte2                                           (  pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte2                                         ) ,
       .pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte3                                           (  pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte3                                         ) ,
       .pf0_usp_rx_preset_hint0                                                                                 (  pf0_usp_rx_preset_hint0                                                                               ) ,
       .pf0_usp_rx_preset_hint1                                                                                 (  pf0_usp_rx_preset_hint1                                                                               ) ,
       .pf0_usp_rx_preset_hint10                                                                                (  pf0_usp_rx_preset_hint10                                                                              ) ,
       .pf0_usp_rx_preset_hint11                                                                                (  pf0_usp_rx_preset_hint11                                                                              ) ,
       .pf0_usp_rx_preset_hint12                                                                                (  pf0_usp_rx_preset_hint12                                                                              ) ,
       .pf0_usp_rx_preset_hint13                                                                                (  pf0_usp_rx_preset_hint13                                                                              ) ,
       .pf0_usp_rx_preset_hint14                                                                                (  pf0_usp_rx_preset_hint14                                                                              ) ,
       .pf0_usp_rx_preset_hint15                                                                                (  pf0_usp_rx_preset_hint15                                                                              ) ,
       .pf0_usp_rx_preset_hint2                                                                                 (  pf0_usp_rx_preset_hint2                                                                               ) ,
       .pf0_usp_rx_preset_hint3                                                                                 (  pf0_usp_rx_preset_hint3                                                                               ) ,
       .pf0_usp_rx_preset_hint4                                                                                 (  pf0_usp_rx_preset_hint4                                                                               ) ,
       .pf0_usp_rx_preset_hint5                                                                                 (  pf0_usp_rx_preset_hint5                                                                               ) ,
       .pf0_usp_rx_preset_hint6                                                                                 (  pf0_usp_rx_preset_hint6                                                                               ) ,
       .pf0_usp_rx_preset_hint7                                                                                 (  pf0_usp_rx_preset_hint7                                                                               ) ,
       .pf0_usp_rx_preset_hint8                                                                                 (  pf0_usp_rx_preset_hint8                                                                               ) ,
       .pf0_usp_rx_preset_hint9                                                                                 (  pf0_usp_rx_preset_hint9                                                                               ) ,
       .pf0_usp_tx_preset0                                                                                      (  pf0_usp_tx_preset0                                                                                    ) ,
       .pf0_usp_tx_preset1                                                                                      (  pf0_usp_tx_preset1                                                                                    ) ,
       .pf0_usp_tx_preset10                                                                                     (  pf0_usp_tx_preset10                                                                                   ) ,
       .pf0_usp_tx_preset11                                                                                     (  pf0_usp_tx_preset11                                                                                   ) ,
       .pf0_usp_tx_preset12                                                                                     (  pf0_usp_tx_preset12                                                                                   ) ,
       .pf0_usp_tx_preset13                                                                                     (  pf0_usp_tx_preset13                                                                                   ) ,
       .pf0_usp_tx_preset14                                                                                     (  pf0_usp_tx_preset14                                                                                   ) ,
       .pf0_usp_tx_preset15                                                                                     (  pf0_usp_tx_preset15                                                                                   ) ,
       .pf0_usp_tx_preset2                                                                                      (  pf0_usp_tx_preset2                                                                                    ) ,
       .pf0_usp_tx_preset3                                                                                      (  pf0_usp_tx_preset3                                                                                    ) ,
       .pf0_usp_tx_preset4                                                                                      (  pf0_usp_tx_preset4                                                                                    ) ,
       .pf0_usp_tx_preset5                                                                                      (  pf0_usp_tx_preset5                                                                                    ) ,
       .pf0_usp_tx_preset6                                                                                      (  pf0_usp_tx_preset6                                                                                    ) ,
       .pf0_usp_tx_preset7                                                                                      (  pf0_usp_tx_preset7                                                                                    ) ,
       .pf0_usp_tx_preset8                                                                                      (  pf0_usp_tx_preset8                                                                                    ) ,
       .pf0_usp_tx_preset9                                                                                      (  pf0_usp_tx_preset9                                                                                    ) ,
       .pf0_vc0_cpl_data_credit                                                                                 (  pf0_vc0_cpl_data_credit                                                                               ) ,
       .pf0_vc0_cpl_header_credit                                                                               (  pf0_vc0_cpl_header_credit                                                                             ) ,
       .pf0_vc0_cpl_tlp_q_mode                                                                                  (  pf0_vc0_cpl_tlp_q_mode                                                                                ) ,
       .pf0_vc0_np_data_credit                                                                                  (  pf0_vc0_np_data_credit                                                                                ) ,
       .pf0_vc0_np_header_credit                                                                                (  pf0_vc0_np_header_credit                                                                              ) ,
       .pf0_vc0_np_tlp_q_mode                                                                                   (  pf0_vc0_np_tlp_q_mode                                                                                 ) ,
       .pf0_vc0_p_data_credit                                                                                   (  pf0_vc0_p_data_credit                                                                                 ) ,
       .pf0_vc0_p_header_credit                                                                                 (  pf0_vc0_p_header_credit                                                                               ) ,
       .pf0_vc0_p_tlp_q_mode                                                                                    (  pf0_vc0_p_tlp_q_mode                                                                                  ) ,
       .pf0_vc_cap_vc_base_addr_byte2                                                                           (  pf0_vc_cap_vc_base_addr_byte2                                                                         ) ,
       .pf0_vc_cap_vc_base_addr_byte3                                                                           (  pf0_vc_cap_vc_base_addr_byte3                                                                         ) ,
       .pf0_vc_cap_version                                                                                      (  pf0_vc_cap_version                                                                                    ) ,
       .pf0_vc_next_offset                                                                                      (  pf0_vc_next_offset                                                                                    ) ,
       .pf0_vendor_specific_dllp_req                                                                            (  pf0_vendor_specific_dllp_req                                                                          ) ,
       .pf0_vf_bar0_reg_rsvdp_0                                                                                 (  pf0_vf_bar0_reg_rsvdp_0                                                                               ) ,
       .pf0_vf_bar1_reg_rsvdp_0                                                                                 (  pf0_vf_bar1_reg_rsvdp_0                                                                               ) ,
       .pf0_vf_bar2_reg_rsvdp_0                                                                                 (  pf0_vf_bar2_reg_rsvdp_0                                                                               ) ,
       .pf0_vf_bar3_reg_rsvdp_0                                                                                 (  pf0_vf_bar3_reg_rsvdp_0                                                                               ) ,
       .pf0_vf_bar4_reg_rsvdp_0                                                                                 (  pf0_vf_bar4_reg_rsvdp_0                                                                               ) ,
       .pf0_vf_bar5_reg_rsvdp_0                                                                                 (  pf0_vf_bar5_reg_rsvdp_0                                                                               ) ,
       .pf0_vf_forward_user_vsec                                                                                (  pf0_vf_forward_user_vsec                                                                              ) ,
       .pf1_aer_cap_aer_ext_cap_hdr_off_addr_byte2                                                              (  pf1_aer_cap_aer_ext_cap_hdr_off_addr_byte2                                                            ) ,
       .pf1_aer_cap_aer_ext_cap_hdr_off_addr_byte3                                                              (  pf1_aer_cap_aer_ext_cap_hdr_off_addr_byte3                                                            ) ,
       .pf1_aer_cap_version                                                                                     (  pf1_aer_cap_version                                                                                   ) ,
       .pf1_aer_next_offset                                                                                     (  pf1_aer_next_offset                                                                                   ) ,
       .pf1_ari_cap_ari_base_addr_byte2                                                                         (  pf1_ari_cap_ari_base_addr_byte2                                                                       ) ,
       .pf1_ari_cap_ari_base_addr_byte3                                                                         (  pf1_ari_cap_ari_base_addr_byte3                                                                       ) ,
       .pf1_ari_cap_version                                                                                     (  pf1_ari_cap_version                                                                                   ) ,
       .pf1_ari_next_offset                                                                                     (  pf1_ari_next_offset                                                                                   ) ,
       .pf1_ats_cap_ats_cap_hdr_reg_addr_byte2                                                                  (  pf1_ats_cap_ats_cap_hdr_reg_addr_byte2                                                                ) ,
       .pf1_ats_cap_ats_cap_hdr_reg_addr_byte3                                                                  (  pf1_ats_cap_ats_cap_hdr_reg_addr_byte3                                                                ) ,
       .pf1_ats_cap_ats_capabilities_ctrl_reg_addr_byte0                                                        (  pf1_ats_cap_ats_capabilities_ctrl_reg_addr_byte0                                                      ) ,
       .pf1_ats_cap_version                                                                                     (  pf1_ats_cap_version                                                                                   ) ,
       .pf1_ats_capabilities_ctrl_reg_rsvdp_7                                                                   (  pf1_ats_capabilities_ctrl_reg_rsvdp_7                                                                 ) ,
       .pf1_ats_next_offset                                                                                     (  pf1_ats_next_offset                                                                                   ) ,
       .pf1_aux_curr                                                                                            (  pf1_aux_curr                                                                                          ) ,
       .pf1_bar0_mem_io                                                                                         (  pf1_bar0_mem_io                                                                                       ) ,
       .pf1_bar0_prefetch                                                                                       (  pf1_bar0_prefetch                                                                                     ) ,
       .pf1_bar0_start                                                                                          (  pf1_bar0_start                                                                                        ) ,
       .pf1_bar0_type                                                                                           (  pf1_bar0_type                                                                                         ) ,
       .pf1_bar1_mem_io                                                                                         (  pf1_bar1_mem_io                                                                                       ) ,
       .pf1_bar1_prefetch                                                                                       (  pf1_bar1_prefetch                                                                                     ) ,
       .pf1_bar1_start                                                                                          (  pf1_bar1_start                                                                                        ) ,
       .pf1_bar1_type                                                                                           (  pf1_bar1_type                                                                                         ) ,
       .pf1_bar2_mem_io                                                                                         (  pf1_bar2_mem_io                                                                                       ) ,
       .pf1_bar2_prefetch                                                                                       (  pf1_bar2_prefetch                                                                                     ) ,
       .pf1_bar2_start                                                                                          (  pf1_bar2_start                                                                                        ) ,
       .pf1_bar2_type                                                                                           (  pf1_bar2_type                                                                                         ) ,
       .pf1_bar3_mem_io                                                                                         (  pf1_bar3_mem_io                                                                                       ) ,
       .pf1_bar3_prefetch                                                                                       (  pf1_bar3_prefetch                                                                                     ) ,
       .pf1_bar3_start                                                                                          (  pf1_bar3_start                                                                                        ) ,
       .pf1_bar3_type                                                                                           (  pf1_bar3_type                                                                                         ) ,
       .pf1_bar4_mem_io                                                                                         (  pf1_bar4_mem_io                                                                                       ) ,
       .pf1_bar4_prefetch                                                                                       (  pf1_bar4_prefetch                                                                                     ) ,
       .pf1_bar4_start                                                                                          (  pf1_bar4_start                                                                                        ) ,
       .pf1_bar4_type                                                                                           (  pf1_bar4_type                                                                                         ) ,
       .pf1_bar5_mem_io                                                                                         (  pf1_bar5_mem_io                                                                                       ) ,
       .pf1_bar5_prefetch                                                                                       (  pf1_bar5_prefetch                                                                                     ) ,
       .pf1_bar5_start                                                                                          (  pf1_bar5_start                                                                                        ) ,
       .pf1_bar5_type                                                                                           (  pf1_bar5_type                                                                                         ) ,
       .pf1_base_class_code                                                                                     (  pf1_base_class_code                                                                                   ) ,
       .pf1_cap_id_nxt_ptr_reg_rsvdp_20                                                                         (  pf1_cap_id_nxt_ptr_reg_rsvdp_20                                                                       ) ,
       .pf1_cap_pointer                                                                                         (  pf1_cap_pointer                                                                                       ) ,
       .pf1_cardbus_cis_pointer                                                                                 (  pf1_cardbus_cis_pointer                                                                               ) ,
       .pf1_con_status_reg_rsvdp_2                                                                              (  pf1_con_status_reg_rsvdp_2                                                                            ) ,
       .pf1_con_status_reg_rsvdp_4                                                                              (  pf1_con_status_reg_rsvdp_4                                                                            ) ,
       .pf1_d1_support                                                                                          (  pf1_d1_support                                                                                        ) ,
       .pf1_d2_support                                                                                          (  pf1_d2_support                                                                                        ) ,
       .pf1_dbi_reserved_0                                                                                      (  pf1_dbi_reserved_0                                                                                    ) ,
       .pf1_dbi_reserved_1                                                                                      (  pf1_dbi_reserved_1                                                                                    ) ,
       .pf1_dbi_reserved_10                                                                                     (  pf1_dbi_reserved_10                                                                                   ) ,
       .pf1_dbi_reserved_11                                                                                     (  pf1_dbi_reserved_11                                                                                   ) ,
       .pf1_dbi_reserved_12                                                                                     (  pf1_dbi_reserved_12                                                                                   ) ,
       .pf1_dbi_reserved_13                                                                                     (  pf1_dbi_reserved_13                                                                                   ) ,
       .pf1_dbi_reserved_14                                                                                     (  pf1_dbi_reserved_14                                                                                   ) ,
       .pf1_dbi_reserved_15                                                                                     (  pf1_dbi_reserved_15                                                                                   ) ,
       .pf1_dbi_reserved_16                                                                                     (  pf1_dbi_reserved_16                                                                                   ) ,
       .pf1_dbi_reserved_17                                                                                     (  pf1_dbi_reserved_17                                                                                   ) ,
       .pf1_dbi_reserved_18                                                                                     (  pf1_dbi_reserved_18                                                                                   ) ,
       .pf1_dbi_reserved_19                                                                                     (  pf1_dbi_reserved_19                                                                                   ) ,
       .pf1_dbi_reserved_2                                                                                      (  pf1_dbi_reserved_2                                                                                    ) ,
       .pf1_dbi_reserved_3                                                                                      (  pf1_dbi_reserved_3                                                                                    ) ,
       .pf1_dbi_reserved_4                                                                                      (  pf1_dbi_reserved_4                                                                                    ) ,
       .pf1_dbi_reserved_5                                                                                      (  pf1_dbi_reserved_5                                                                                    ) ,
       .pf1_dbi_reserved_6                                                                                      (  pf1_dbi_reserved_6                                                                                    ) ,
       .pf1_dbi_reserved_7                                                                                      (  pf1_dbi_reserved_7                                                                                    ) ,
       .pf1_dbi_reserved_8                                                                                      (  pf1_dbi_reserved_8                                                                                    ) ,
       .pf1_dbi_reserved_9                                                                                      (  pf1_dbi_reserved_9                                                                                    ) ,
       .pf1_device_capabilities_reg_rsvdp_12                                                                    (  pf1_device_capabilities_reg_rsvdp_12                                                                  ) ,
       .pf1_device_capabilities_reg_rsvdp_16                                                                    (  pf1_device_capabilities_reg_rsvdp_16                                                                  ) ,
       .pf1_device_capabilities_reg_rsvdp_29                                                                    (  pf1_device_capabilities_reg_rsvdp_29                                                                  ) ,
       .pf1_dsi                                                                                                 (  pf1_dsi                                                                                               ) ,
       .pf1_exp_rom_bar_mask_reg_rsvdp_1                                                                        (  pf1_exp_rom_bar_mask_reg_rsvdp_1                                                                      ) ,
       .pf1_exp_rom_base_addr_reg_rsvdp_1                                                                       (  pf1_exp_rom_base_addr_reg_rsvdp_1                                                                     ) ,
       .pf1_forward_user_vsec                                                                                   (  pf1_forward_user_vsec                                                                                 ) ,
       .pf1_global_inval_spprtd                                                                                 (  pf1_global_inval_spprtd                                                                               ) ,
       .pf1_header_type                                                                                         (  pf1_header_type                                                                                       ) ,
       .pf1_int_pin                                                                                             (  pf1_int_pin                                                                                           ) ,
       .pf1_invalidate_q_depth                                                                                  (  pf1_invalidate_q_depth                                                                                ) ,
       .pf1_link_capabilities_reg_rsvdp_23                                                                      (  pf1_link_capabilities_reg_rsvdp_23                                                                    ) ,
       .pf1_link_control_link_status_reg_rsvdp_12                                                               (  pf1_link_control_link_status_reg_rsvdp_12                                                             ) ,
       .pf1_link_control_link_status_reg_rsvdp_2                                                                (  pf1_link_control_link_status_reg_rsvdp_2                                                              ) ,
       .pf1_link_control_link_status_reg_rsvdp_25                                                               (  pf1_link_control_link_status_reg_rsvdp_25                                                             ) ,
       .pf1_link_control_link_status_reg_rsvdp_9                                                                (  pf1_link_control_link_status_reg_rsvdp_9                                                              ) ,
       .pf1_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte1                                                     (  pf1_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte1                                                   ) ,
       .pf1_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte2                                                     (  pf1_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte2                                                   ) ,
       .pf1_msix_cap_msix_pba_offset_reg_addr_byte0                                                             (  pf1_msix_cap_msix_pba_offset_reg_addr_byte0                                                           ) ,
       .pf1_msix_cap_msix_pba_offset_reg_addr_byte1                                                             (  pf1_msix_cap_msix_pba_offset_reg_addr_byte1                                                           ) ,
       .pf1_msix_cap_msix_pba_offset_reg_addr_byte2                                                             (  pf1_msix_cap_msix_pba_offset_reg_addr_byte2                                                           ) ,
       .pf1_msix_cap_msix_pba_offset_reg_addr_byte3                                                             (  pf1_msix_cap_msix_pba_offset_reg_addr_byte3                                                           ) ,
       .pf1_msix_cap_msix_table_offset_reg_addr_byte0                                                           (  pf1_msix_cap_msix_table_offset_reg_addr_byte0                                                         ) ,
       .pf1_msix_cap_msix_table_offset_reg_addr_byte1                                                           (  pf1_msix_cap_msix_table_offset_reg_addr_byte1                                                         ) ,
       .pf1_msix_cap_msix_table_offset_reg_addr_byte2                                                           (  pf1_msix_cap_msix_table_offset_reg_addr_byte2                                                         ) ,
       .pf1_msix_cap_msix_table_offset_reg_addr_byte3                                                           (  pf1_msix_cap_msix_table_offset_reg_addr_byte3                                                         ) ,
       .pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte1                                                   (  pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte1                                                 ) ,
       .pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte2                                                   (  pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte2                                                 ) ,
       .pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte3                                                   (  pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte3                                                 ) ,
       .pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte2                                        (  pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte2                                      ) ,
       .pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte3                                        (  pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte3                                      ) ,
       .pf1_multi_func                                                                                          (  pf1_multi_func                                                                                        ) ,
       .pf1_no_soft_rst                                                                                         (  pf1_no_soft_rst                                                                                       ) ,
       .pf1_page_aligned_req                                                                                    (  pf1_page_aligned_req                                                                                  ) ,
       .pf1_pci_msi_64_bit_addr_cap                                                                             (  pf1_pci_msi_64_bit_addr_cap                                                                           ) ,
       .pf1_pci_msi_cap_next_offset                                                                             (  pf1_pci_msi_cap_next_offset                                                                           ) ,
       .pf1_pci_msi_enable                                                                                      (  pf1_pci_msi_enable                                                                                    ) ,
       .pf1_pci_msi_multiple_msg_cap                                                                            (  pf1_pci_msi_multiple_msg_cap                                                                          ) ,
       .pf1_pci_msi_multiple_msg_en                                                                             (  pf1_pci_msi_multiple_msg_en                                                                           ) ,
       .pf1_pci_msix_bir                                                                                        (  pf1_pci_msix_bir                                                                                      ) ,
       .pf1_pci_msix_cap_id_next_ctrl_reg_rsvdp_27                                                              (  pf1_pci_msix_cap_id_next_ctrl_reg_rsvdp_27                                                            ) ,
       .pf1_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                                        (  pf1_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                                      ) ,
       .pf1_pci_msix_cap_next_offset                                                                            (  pf1_pci_msix_cap_next_offset                                                                          ) ,
       .pf1_pci_msix_enable                                                                                     (  pf1_pci_msix_enable                                                                                   ) ,
       .pf1_pci_msix_enable_vfcomm_cs2                                                                          (  pf1_pci_msix_enable_vfcomm_cs2                                                                        ) ,
       .pf1_pci_msix_function_mask                                                                              (  pf1_pci_msix_function_mask                                                                            ) ,
       .pf1_pci_msix_function_mask_vfcomm_cs2                                                                   (  pf1_pci_msix_function_mask_vfcomm_cs2                                                                 ) ,
       .pf1_pci_msix_pba                                                                                        (  pf1_pci_msix_pba                                                                                      ) ,
       .pf1_pci_msix_pba_offset                                                                                 (  pf1_pci_msix_pba_offset                                                                               ) ,
       .pf1_pci_msix_table_offset                                                                               (  pf1_pci_msix_table_offset                                                                             ) ,
       .pf1_pci_msix_table_size                                                                                 (  pf1_pci_msix_table_size                                                                               ) ,
       .pf1_pci_msix_table_size_vfcomm_cs2                                                                      (  pf1_pci_msix_table_size_vfcomm_cs2                                                                    ) ,
       .pf1_pci_type0_bar0_enabled                                                                              (  pf1_pci_type0_bar0_enabled                                                                            ) ,
       .pf1_pci_type0_bar0_mask_31_1                                                                            (  pf1_pci_type0_bar0_mask_31_1                                                                          ) ,
       .pf1_pci_type0_bar1_dummy_mask_7_1                                                                       (  pf1_pci_type0_bar1_dummy_mask_7_1                                                                     ) ,
       .pf1_pci_type0_bar1_enabled                                                                              (  pf1_pci_type0_bar1_enabled                                                                            ) ,
       .pf1_pci_type0_bar1_enabled_or_mask64lsb                                                                 (  pf1_pci_type0_bar1_enabled_or_mask64lsb                                                               ) ,
       .pf1_pci_type0_bar1_mask_31_1                                                                            (  pf1_pci_type0_bar1_mask_31_1                                                                          ) ,
       .pf1_pci_type0_bar2_enabled                                                                              (  pf1_pci_type0_bar2_enabled                                                                            ) ,
       .pf1_pci_type0_bar2_mask_31_1                                                                            (  pf1_pci_type0_bar2_mask_31_1                                                                          ) ,
       .pf1_pci_type0_bar3_dummy_mask_7_1                                                                       (  pf1_pci_type0_bar3_dummy_mask_7_1                                                                     ) ,
       .pf1_pci_type0_bar3_enabled                                                                              (  pf1_pci_type0_bar3_enabled                                                                            ) ,
       .pf1_pci_type0_bar3_enabled_or_mask64lsb                                                                 (  pf1_pci_type0_bar3_enabled_or_mask64lsb                                                               ) ,
       .pf1_pci_type0_bar3_mask_31_1                                                                            (  pf1_pci_type0_bar3_mask_31_1                                                                          ) ,
       .pf1_pci_type0_bar4_enabled                                                                              (  pf1_pci_type0_bar4_enabled                                                                            ) ,
       .pf1_pci_type0_bar4_mask_31_1                                                                            (  pf1_pci_type0_bar4_mask_31_1                                                                          ) ,
       .pf1_pci_type0_bar5_dummy_mask_7_1                                                                       (  pf1_pci_type0_bar5_dummy_mask_7_1                                                                     ) ,
       .pf1_pci_type0_bar5_enabled                                                                              (  pf1_pci_type0_bar5_enabled                                                                            ) ,
       .pf1_pci_type0_bar5_enabled_or_mask64lsb                                                                 (  pf1_pci_type0_bar5_enabled_or_mask64lsb                                                               ) ,
       .pf1_pci_type0_bar5_mask_31_1                                                                            (  pf1_pci_type0_bar5_mask_31_1                                                                          ) ,
       .pf1_pci_type0_device_id                                                                                 (  pf1_pci_type0_device_id                                                                               ) ,
       .pf1_pci_type0_vendor_id                                                                                 (  pf1_pci_type0_vendor_id                                                                               ) ,
       .pf1_pcie_cap_active_state_link_pm_control                                                               (  pf1_pcie_cap_active_state_link_pm_control                                                             ) ,
       .pf1_pcie_cap_active_state_link_pm_support                                                               (  pf1_pcie_cap_active_state_link_pm_support                                                             ) ,
       .pf1_pcie_cap_aspm_opt_compliance                                                                        (  pf1_pcie_cap_aspm_opt_compliance                                                                      ) ,
       .pf1_pcie_cap_aux_power_pm_en                                                                            (  pf1_pcie_cap_aux_power_pm_en                                                                          ) ,
       .pf1_pcie_cap_clock_power_man                                                                            (  pf1_pcie_cap_clock_power_man                                                                          ) ,
       .pf1_pcie_cap_common_clk_config                                                                          (  pf1_pcie_cap_common_clk_config                                                                        ) ,
       .pf1_pcie_cap_device_capabilities_reg_addr_byte0                                                         (  pf1_pcie_cap_device_capabilities_reg_addr_byte0                                                       ) ,
       .pf1_pcie_cap_device_capabilities_reg_addr_byte1                                                         (  pf1_pcie_cap_device_capabilities_reg_addr_byte1                                                       ) ,
       .pf1_pcie_cap_device_capabilities_reg_addr_byte2                                                         (  pf1_pcie_cap_device_capabilities_reg_addr_byte2                                                       ) ,
       .pf1_pcie_cap_device_control_device_status_addr_byte1                                                    (  pf1_pcie_cap_device_control_device_status_addr_byte1                                                  ) ,
       .pf1_pcie_cap_dll_active                                                                                 (  pf1_pcie_cap_dll_active                                                                               ) ,
       .pf1_pcie_cap_dll_active_rep_cap                                                                         (  pf1_pcie_cap_dll_active_rep_cap                                                                       ) ,
       .pf1_pcie_cap_en_clk_power_man                                                                           (  pf1_pcie_cap_en_clk_power_man                                                                         ) ,
       .pf1_pcie_cap_en_no_snoop                                                                                (  pf1_pcie_cap_en_no_snoop                                                                              ) ,
       .pf1_pcie_cap_enter_compliance                                                                           (  pf1_pcie_cap_enter_compliance                                                                         ) ,
       .pf1_pcie_cap_ep_l0s_accpt_latency                                                                       (  pf1_pcie_cap_ep_l0s_accpt_latency                                                                     ) ,
       .pf1_pcie_cap_ep_l1_accpt_latency                                                                        (  pf1_pcie_cap_ep_l1_accpt_latency                                                                      ) ,
       .pf1_pcie_cap_ext_tag_en                                                                                 (  pf1_pcie_cap_ext_tag_en                                                                               ) ,
       .pf1_pcie_cap_ext_tag_supp                                                                               (  pf1_pcie_cap_ext_tag_supp                                                                             ) ,
       .pf1_pcie_cap_extended_synch                                                                             (  pf1_pcie_cap_extended_synch                                                                           ) ,
       .pf1_pcie_cap_flr_cap                                                                                    (  pf1_pcie_cap_flr_cap                                                                                  ) ,
       .pf1_pcie_cap_hw_auto_speed_disable                                                                      (  pf1_pcie_cap_hw_auto_speed_disable                                                                    ) ,
       .pf1_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvd                                                     (  pf1_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvd                                                   ) ,
       .pf1_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvdp_31                                                 (  pf1_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvdp_31                                               ) ,
       .pf1_pcie_cap_initiate_flr                                                                               (  pf1_pcie_cap_initiate_flr                                                                             ) ,
       .pf1_pcie_cap_l0s_exit_latency_commclk_dis                                                               (  pf1_pcie_cap_l0s_exit_latency_commclk_dis                                                             ) ,
       .pf1_pcie_cap_l0s_exit_latency_commclk_ena_cs2                                                           (  pf1_pcie_cap_l0s_exit_latency_commclk_ena_cs2                                                         ) ,
       .pf1_pcie_cap_l1_exit_latency_commclk_dis                                                                (  pf1_pcie_cap_l1_exit_latency_commclk_dis                                                              ) ,
       .pf1_pcie_cap_l1_exit_latency_commclk_ena_cs2                                                            (  pf1_pcie_cap_l1_exit_latency_commclk_ena_cs2                                                          ) ,
       .pf1_pcie_cap_link_auto_bw_int_en                                                                        (  pf1_pcie_cap_link_auto_bw_int_en                                                                      ) ,
       .pf1_pcie_cap_link_auto_bw_status                                                                        (  pf1_pcie_cap_link_auto_bw_status                                                                      ) ,
       .pf1_pcie_cap_link_bw_man_int_en                                                                         (  pf1_pcie_cap_link_bw_man_int_en                                                                       ) ,
       .pf1_pcie_cap_link_bw_man_status                                                                         (  pf1_pcie_cap_link_bw_man_status                                                                       ) ,
       .pf1_pcie_cap_link_bw_not_cap                                                                            (  pf1_pcie_cap_link_bw_not_cap                                                                          ) ,
       .pf1_pcie_cap_link_capabilities_reg_addr_byte0                                                           (  pf1_pcie_cap_link_capabilities_reg_addr_byte0                                                         ) ,
       .pf1_pcie_cap_link_capabilities_reg_addr_byte1                                                           (  pf1_pcie_cap_link_capabilities_reg_addr_byte1                                                         ) ,
       .pf1_pcie_cap_link_capabilities_reg_addr_byte2                                                           (  pf1_pcie_cap_link_capabilities_reg_addr_byte2                                                         ) ,
       .pf1_pcie_cap_link_capabilities_reg_addr_byte3                                                           (  pf1_pcie_cap_link_capabilities_reg_addr_byte3                                                         ) ,
       .pf1_pcie_cap_link_control2_link_status2_reg_addr_byte0                                                  (  pf1_pcie_cap_link_control2_link_status2_reg_addr_byte0                                                ) ,
       .pf1_pcie_cap_link_control_link_status_reg_addr_byte0                                                    (  pf1_pcie_cap_link_control_link_status_reg_addr_byte0                                                  ) ,
       .pf1_pcie_cap_link_control_link_status_reg_addr_byte1                                                    (  pf1_pcie_cap_link_control_link_status_reg_addr_byte1                                                  ) ,
       .pf1_pcie_cap_link_control_link_status_reg_addr_byte2                                                    (  pf1_pcie_cap_link_control_link_status_reg_addr_byte2                                                  ) ,
       .pf1_pcie_cap_link_disable                                                                               (  pf1_pcie_cap_link_disable                                                                             ) ,
       .pf1_pcie_cap_link_training                                                                              (  pf1_pcie_cap_link_training                                                                            ) ,
       .pf1_pcie_cap_max_link_speed                                                                             (  pf1_pcie_cap_max_link_speed                                                                           ) ,
       .pf1_pcie_cap_max_link_width                                                                             (  pf1_pcie_cap_max_link_width                                                                           ) ,
       .pf1_pcie_cap_max_payload_size                                                                           (  pf1_pcie_cap_max_payload_size                                                                         ) ,
       .pf1_pcie_cap_max_read_req_size                                                                          (  pf1_pcie_cap_max_read_req_size                                                                        ) ,
       .pf1_pcie_cap_nego_link_width                                                                            (  pf1_pcie_cap_nego_link_width                                                                          ) ,
       .pf1_pcie_cap_next_ptr                                                                                   (  pf1_pcie_cap_next_ptr                                                                                 ) ,
       .pf1_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte1                                      (  pf1_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte1                                    ) ,
       .pf1_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte3                                      (  pf1_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte3                                    ) ,
       .pf1_pcie_cap_phantom_func_en                                                                            (  pf1_pcie_cap_phantom_func_en                                                                          ) ,
       .pf1_pcie_cap_phantom_func_support                                                                       (  pf1_pcie_cap_phantom_func_support                                                                     ) ,
       .pf1_pcie_cap_port_num                                                                                   (  pf1_pcie_cap_port_num                                                                                 ) ,
       .pf1_pcie_cap_rcb                                                                                        (  pf1_pcie_cap_rcb                                                                                      ) ,
       .pf1_pcie_cap_retrain_link                                                                               (  pf1_pcie_cap_retrain_link                                                                             ) ,
       .pf1_pcie_cap_role_based_err_report                                                                      (  pf1_pcie_cap_role_based_err_report                                                                    ) ,
       .pf1_pcie_cap_sel_deemphasis                                                                             (  pf1_pcie_cap_sel_deemphasis                                                                           ) ,
       .pf1_pcie_cap_shadow_link_capabilities_reg_addr_byte0                                                    (  pf1_pcie_cap_shadow_link_capabilities_reg_addr_byte0                                                  ) ,
       .pf1_pcie_cap_shadow_link_capabilities_reg_addr_byte1                                                    (  pf1_pcie_cap_shadow_link_capabilities_reg_addr_byte1                                                  ) ,
       .pf1_pcie_cap_slot_clk_config                                                                            (  pf1_pcie_cap_slot_clk_config                                                                          ) ,
       .pf1_pcie_cap_surprise_down_err_rep_cap                                                                  (  pf1_pcie_cap_surprise_down_err_rep_cap                                                                ) ,
       .pf1_pcie_cap_target_link_speed                                                                          (  pf1_pcie_cap_target_link_speed                                                                        ) ,
       .pf1_pcie_cap_tx_margin                                                                                  (  pf1_pcie_cap_tx_margin                                                                                ) ,
       .pf1_pcie_int_msg_num                                                                                    (  pf1_pcie_int_msg_num                                                                                  ) ,
       .pf1_pcie_slot_imp                                                                                       (  pf1_pcie_slot_imp                                                                                     ) ,
       .pf1_pm_cap_cap_id_nxt_ptr_reg_addr_byte1                                                                (  pf1_pm_cap_cap_id_nxt_ptr_reg_addr_byte1                                                              ) ,
       .pf1_pm_cap_cap_id_nxt_ptr_reg_addr_byte2                                                                (  pf1_pm_cap_cap_id_nxt_ptr_reg_addr_byte2                                                              ) ,
       .pf1_pm_cap_cap_id_nxt_ptr_reg_addr_byte3                                                                (  pf1_pm_cap_cap_id_nxt_ptr_reg_addr_byte3                                                              ) ,
       .pf1_pm_cap_con_status_reg_addr_byte0                                                                    (  pf1_pm_cap_con_status_reg_addr_byte0                                                                  ) ,
       .pf1_pm_next_pointer                                                                                     (  pf1_pm_next_pointer                                                                                   ) ,
       .pf1_pm_spec_ver                                                                                         (  pf1_pm_spec_ver                                                                                       ) ,
       .pf1_pme_clk                                                                                             (  pf1_pme_clk                                                                                           ) ,
       .pf1_pme_support                                                                                         (  pf1_pme_support                                                                                       ) ,
       .pf1_power_state                                                                                         (  pf1_power_state                                                                                       ) ,
       .pf1_program_interface                                                                                   (  pf1_program_interface                                                                                 ) ,
       .pf1_reserved_0_addr                                                                                     (  pf1_reserved_0_addr                                                                                   ) ,
       .pf1_reserved_10_addr                                                                                    (  pf1_reserved_10_addr                                                                                  ) ,
       .pf1_reserved_11_addr                                                                                    (  pf1_reserved_11_addr                                                                                  ) ,
       .pf1_reserved_12_addr                                                                                    (  pf1_reserved_12_addr                                                                                  ) ,
       .pf1_reserved_13_addr                                                                                    (  pf1_reserved_13_addr                                                                                  ) ,
       .pf1_reserved_14_addr                                                                                    (  pf1_reserved_14_addr                                                                                  ) ,
       .pf1_reserved_15_addr                                                                                    (  pf1_reserved_15_addr                                                                                  ) ,
       .pf1_reserved_16_addr                                                                                    (  pf1_reserved_16_addr                                                                                  ) ,
       .pf1_reserved_17_addr                                                                                    (  pf1_reserved_17_addr                                                                                  ) ,
       .pf1_reserved_18_addr                                                                                    (  pf1_reserved_18_addr                                                                                  ) ,
       .pf1_reserved_19_addr                                                                                    (  pf1_reserved_19_addr                                                                                  ) ,
       .pf1_reserved_1_addr                                                                                     (  pf1_reserved_1_addr                                                                                   ) ,
       .pf1_reserved_2_addr                                                                                     (  pf1_reserved_2_addr                                                                                   ) ,
       .pf1_reserved_3_addr                                                                                     (  pf1_reserved_3_addr                                                                                   ) ,
       .pf1_reserved_4_addr                                                                                     (  pf1_reserved_4_addr                                                                                   ) ,
       .pf1_reserved_5_addr                                                                                     (  pf1_reserved_5_addr                                                                                   ) ,
       .pf1_reserved_6_addr                                                                                     (  pf1_reserved_6_addr                                                                                   ) ,
       .pf1_reserved_7_addr                                                                                     (  pf1_reserved_7_addr                                                                                   ) ,
       .pf1_reserved_8_addr                                                                                     (  pf1_reserved_8_addr                                                                                   ) ,
       .pf1_reserved_9_addr                                                                                     (  pf1_reserved_9_addr                                                                                   ) ,
       .pf1_revision_id                                                                                         (  pf1_revision_id                                                                                       ) ,
       .pf1_rom_bar_enable                                                                                      (  pf1_rom_bar_enable                                                                                    ) ,
       .pf1_rom_bar_enabled                                                                                     (  pf1_rom_bar_enabled                                                                                   ) ,
       .pf1_rom_mask                                                                                            (  pf1_rom_mask                                                                                          ) ,
       .pf1_shadow_link_capabilities_reg_shadow_rsvdp_23                                                        (  pf1_shadow_link_capabilities_reg_shadow_rsvdp_23                                                      ) ,
       .pf1_shadow_pcie_cap_active_state_link_pm_support                                                        (  pf1_shadow_pcie_cap_active_state_link_pm_support                                                      ) ,
       .pf1_shadow_pcie_cap_aspm_opt_compliance                                                                 (  pf1_shadow_pcie_cap_aspm_opt_compliance                                                               ) ,
       .pf1_shadow_pcie_cap_clock_power_man                                                                     (  pf1_shadow_pcie_cap_clock_power_man                                                                   ) ,
       .pf1_shadow_pcie_cap_dll_active_rep_cap                                                                  (  pf1_shadow_pcie_cap_dll_active_rep_cap                                                                ) ,
       .pf1_shadow_pcie_cap_link_bw_not_cap                                                                     (  pf1_shadow_pcie_cap_link_bw_not_cap                                                                   ) ,
       .pf1_shadow_pcie_cap_max_link_width                                                                      (  pf1_shadow_pcie_cap_max_link_width                                                                    ) ,
       .pf1_shadow_pcie_cap_surprise_down_err_rep_cap                                                           (  pf1_shadow_pcie_cap_surprise_down_err_rep_cap                                                         ) ,
       .pf1_shadow_sriov_vf_stride_ari_cs2                                                                      (  pf1_shadow_sriov_vf_stride_ari_cs2                                                                    ) ,
       .pf1_sn_cap_ser_num_reg_dw_1_addr_byte0                                                                  (  pf1_sn_cap_ser_num_reg_dw_1_addr_byte0                                                                ) ,
       .pf1_sn_cap_ser_num_reg_dw_1_addr_byte1                                                                  (  pf1_sn_cap_ser_num_reg_dw_1_addr_byte1                                                                ) ,
       .pf1_sn_cap_ser_num_reg_dw_1_addr_byte2                                                                  (  pf1_sn_cap_ser_num_reg_dw_1_addr_byte2                                                                ) ,
       .pf1_sn_cap_ser_num_reg_dw_1_addr_byte3                                                                  (  pf1_sn_cap_ser_num_reg_dw_1_addr_byte3                                                                ) ,
       .pf1_sn_cap_ser_num_reg_dw_2_addr_byte0                                                                  (  pf1_sn_cap_ser_num_reg_dw_2_addr_byte0                                                                ) ,
       .pf1_sn_cap_ser_num_reg_dw_2_addr_byte1                                                                  (  pf1_sn_cap_ser_num_reg_dw_2_addr_byte1                                                                ) ,
       .pf1_sn_cap_ser_num_reg_dw_2_addr_byte2                                                                  (  pf1_sn_cap_ser_num_reg_dw_2_addr_byte2                                                                ) ,
       .pf1_sn_cap_ser_num_reg_dw_2_addr_byte3                                                                  (  pf1_sn_cap_ser_num_reg_dw_2_addr_byte3                                                                ) ,
       .pf1_sn_cap_sn_base_addr_byte2                                                                           (  pf1_sn_cap_sn_base_addr_byte2                                                                         ) ,
       .pf1_sn_cap_sn_base_addr_byte3                                                                           (  pf1_sn_cap_sn_base_addr_byte3                                                                         ) ,
       .pf1_sn_cap_version                                                                                      (  pf1_sn_cap_version                                                                                    ) ,
       .pf1_sn_next_offset                                                                                      (  pf1_sn_next_offset                                                                                    ) ,
       .pf1_sn_ser_num_reg_1_dw                                                                                 (  pf1_sn_ser_num_reg_1_dw                                                                               ) ,
       .pf1_sn_ser_num_reg_2_dw                                                                                 (  pf1_sn_ser_num_reg_2_dw                                                                               ) ,
       .pf1_sriov_cap_shadow_sriov_initial_vfs_addr_byte0                                                       (  pf1_sriov_cap_shadow_sriov_initial_vfs_addr_byte0                                                     ) ,
       .pf1_sriov_cap_shadow_sriov_initial_vfs_addr_byte1                                                       (  pf1_sriov_cap_shadow_sriov_initial_vfs_addr_byte1                                                     ) ,
       .pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte0                                                (  pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte0                                              ) ,
       .pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte1                                                (  pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte1                                              ) ,
       .pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte2                                                (  pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte2                                              ) ,
       .pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte3                                                (  pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte3                                              ) ,
       .pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte0                                                             (  pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte0                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte1                                                             (  pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte1                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte2                                                             (  pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte2                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte3                                                             (  pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte3                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte0                                                             (  pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte0                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte1                                                             (  pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte1                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte2                                                             (  pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte2                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte3                                                             (  pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte3                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte0                                                             (  pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte0                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte1                                                             (  pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte1                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte2                                                             (  pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte2                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte3                                                             (  pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte3                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte0                                                             (  pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte0                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte1                                                             (  pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte1                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte2                                                             (  pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte2                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte3                                                             (  pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte3                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte0                                                             (  pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte0                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte1                                                             (  pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte1                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte2                                                             (  pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte2                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte3                                                             (  pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte3                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte0                                                             (  pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte0                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte1                                                             (  pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte1                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte2                                                             (  pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte2                                                           ) ,
       .pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte3                                                             (  pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte3                                                           ) ,
       .pf1_sriov_cap_sriov_bar1_enable_reg_addr_byte0                                                          (  pf1_sriov_cap_sriov_bar1_enable_reg_addr_byte0                                                        ) ,
       .pf1_sriov_cap_sriov_bar3_enable_reg_addr_byte0                                                          (  pf1_sriov_cap_sriov_bar3_enable_reg_addr_byte0                                                        ) ,
       .pf1_sriov_cap_sriov_bar5_enable_reg_addr_byte0                                                          (  pf1_sriov_cap_sriov_bar5_enable_reg_addr_byte0                                                        ) ,
       .pf1_sriov_cap_sriov_base_reg_addr_byte2                                                                 (  pf1_sriov_cap_sriov_base_reg_addr_byte2                                                               ) ,
       .pf1_sriov_cap_sriov_base_reg_addr_byte3                                                                 (  pf1_sriov_cap_sriov_base_reg_addr_byte3                                                               ) ,
       .pf1_sriov_cap_sriov_initial_vfs_addr_byte0                                                              (  pf1_sriov_cap_sriov_initial_vfs_addr_byte0                                                            ) ,
       .pf1_sriov_cap_sriov_initial_vfs_addr_byte1                                                              (  pf1_sriov_cap_sriov_initial_vfs_addr_byte1                                                            ) ,
       .pf1_sriov_cap_sriov_vf_offset_position_addr_byte0                                                       (  pf1_sriov_cap_sriov_vf_offset_position_addr_byte0                                                     ) ,
       .pf1_sriov_cap_sriov_vf_offset_position_addr_byte1                                                       (  pf1_sriov_cap_sriov_vf_offset_position_addr_byte1                                                     ) ,
       .pf1_sriov_cap_sriov_vf_offset_position_addr_byte2                                                       (  pf1_sriov_cap_sriov_vf_offset_position_addr_byte2                                                     ) ,
       .pf1_sriov_cap_sriov_vf_offset_position_addr_byte3                                                       (  pf1_sriov_cap_sriov_vf_offset_position_addr_byte3                                                     ) ,
       .pf1_sriov_cap_sup_page_sizes_reg_addr_byte0                                                             (  pf1_sriov_cap_sup_page_sizes_reg_addr_byte0                                                           ) ,
       .pf1_sriov_cap_sup_page_sizes_reg_addr_byte1                                                             (  pf1_sriov_cap_sup_page_sizes_reg_addr_byte1                                                           ) ,
       .pf1_sriov_cap_sup_page_sizes_reg_addr_byte2                                                             (  pf1_sriov_cap_sup_page_sizes_reg_addr_byte2                                                           ) ,
       .pf1_sriov_cap_sup_page_sizes_reg_addr_byte3                                                             (  pf1_sriov_cap_sup_page_sizes_reg_addr_byte3                                                           ) ,
       .pf1_sriov_cap_version                                                                                   (  pf1_sriov_cap_version                                                                                 ) ,
       .pf1_sriov_cap_vf_bar0_reg_addr_byte0                                                                    (  pf1_sriov_cap_vf_bar0_reg_addr_byte0                                                                  ) ,
       .pf1_sriov_cap_vf_bar1_reg_addr_byte0                                                                    (  pf1_sriov_cap_vf_bar1_reg_addr_byte0                                                                  ) ,
       .pf1_sriov_cap_vf_bar2_reg_addr_byte0                                                                    (  pf1_sriov_cap_vf_bar2_reg_addr_byte0                                                                  ) ,
       .pf1_sriov_cap_vf_bar3_reg_addr_byte0                                                                    (  pf1_sriov_cap_vf_bar3_reg_addr_byte0                                                                  ) ,
       .pf1_sriov_cap_vf_bar4_reg_addr_byte0                                                                    (  pf1_sriov_cap_vf_bar4_reg_addr_byte0                                                                  ) ,
       .pf1_sriov_cap_vf_bar5_reg_addr_byte0                                                                    (  pf1_sriov_cap_vf_bar5_reg_addr_byte0                                                                  ) ,
       .pf1_sriov_cap_vf_device_id_reg_addr_byte2                                                               (  pf1_sriov_cap_vf_device_id_reg_addr_byte2                                                             ) ,
       .pf1_sriov_cap_vf_device_id_reg_addr_byte3                                                               (  pf1_sriov_cap_vf_device_id_reg_addr_byte3                                                             ) ,
       .pf1_sriov_initial_vfs_ari_cs2                                                                           (  pf1_sriov_initial_vfs_ari_cs2                                                                         ) ,
       .pf1_sriov_initial_vfs_nonari                                                                            (  pf1_sriov_initial_vfs_nonari                                                                          ) ,
       .pf1_sriov_next_offset                                                                                   (  pf1_sriov_next_offset                                                                                 ) ,
       .pf1_sriov_sup_page_size                                                                                 (  pf1_sriov_sup_page_size                                                                               ) ,
       .pf1_sriov_vf_bar0_mask                                                                                  (  pf1_sriov_vf_bar0_mask                                                                                ) ,
       .pf1_sriov_vf_bar0_prefetch                                                                              (  pf1_sriov_vf_bar0_prefetch                                                                            ) ,
       .pf1_sriov_vf_bar0_start                                                                                 (  pf1_sriov_vf_bar0_start                                                                               ) ,
       .pf1_sriov_vf_bar0_type                                                                                  (  pf1_sriov_vf_bar0_type                                                                                ) ,
       .pf1_sriov_vf_bar1_dummy_mask_7_1                                                                        (  pf1_sriov_vf_bar1_dummy_mask_7_1                                                                      ) ,
       .pf1_sriov_vf_bar1_enabled                                                                               (  pf1_sriov_vf_bar1_enabled                                                                             ) ,
       .pf1_sriov_vf_bar1_mask                                                                                  (  pf1_sriov_vf_bar1_mask                                                                                ) ,
       .pf1_sriov_vf_bar1_prefetch                                                                              (  pf1_sriov_vf_bar1_prefetch                                                                            ) ,
       .pf1_sriov_vf_bar1_start                                                                                 (  pf1_sriov_vf_bar1_start                                                                               ) ,
       .pf1_sriov_vf_bar1_type                                                                                  (  pf1_sriov_vf_bar1_type                                                                                ) ,
       .pf1_sriov_vf_bar2_mask                                                                                  (  pf1_sriov_vf_bar2_mask                                                                                ) ,
       .pf1_sriov_vf_bar2_prefetch                                                                              (  pf1_sriov_vf_bar2_prefetch                                                                            ) ,
       .pf1_sriov_vf_bar2_start                                                                                 (  pf1_sriov_vf_bar2_start                                                                               ) ,
       .pf1_sriov_vf_bar2_type                                                                                  (  pf1_sriov_vf_bar2_type                                                                                ) ,
       .pf1_sriov_vf_bar3_dummy_mask_7_1                                                                        (  pf1_sriov_vf_bar3_dummy_mask_7_1                                                                      ) ,
       .pf1_sriov_vf_bar3_enabled                                                                               (  pf1_sriov_vf_bar3_enabled                                                                             ) ,
       .pf1_sriov_vf_bar3_mask                                                                                  (  pf1_sriov_vf_bar3_mask                                                                                ) ,
       .pf1_sriov_vf_bar3_prefetch                                                                              (  pf1_sriov_vf_bar3_prefetch                                                                            ) ,
       .pf1_sriov_vf_bar3_start                                                                                 (  pf1_sriov_vf_bar3_start                                                                               ) ,
       .pf1_sriov_vf_bar3_type                                                                                  (  pf1_sriov_vf_bar3_type                                                                                ) ,
       .pf1_sriov_vf_bar4_mask                                                                                  (  pf1_sriov_vf_bar4_mask                                                                                ) ,
       .pf1_sriov_vf_bar4_prefetch                                                                              (  pf1_sriov_vf_bar4_prefetch                                                                            ) ,
       .pf1_sriov_vf_bar4_start                                                                                 (  pf1_sriov_vf_bar4_start                                                                               ) ,
       .pf1_sriov_vf_bar4_type                                                                                  (  pf1_sriov_vf_bar4_type                                                                                ) ,
       .pf1_sriov_vf_bar5_dummy_mask_7_1                                                                        (  pf1_sriov_vf_bar5_dummy_mask_7_1                                                                      ) ,
       .pf1_sriov_vf_bar5_enabled                                                                               (  pf1_sriov_vf_bar5_enabled                                                                             ) ,
       .pf1_sriov_vf_bar5_mask                                                                                  (  pf1_sriov_vf_bar5_mask                                                                                ) ,
       .pf1_sriov_vf_bar5_prefetch                                                                              (  pf1_sriov_vf_bar5_prefetch                                                                            ) ,
       .pf1_sriov_vf_bar5_start                                                                                 (  pf1_sriov_vf_bar5_start                                                                               ) ,
       .pf1_sriov_vf_bar5_type                                                                                  (  pf1_sriov_vf_bar5_type                                                                                ) ,
       .pf1_sriov_vf_device_id                                                                                  (  pf1_sriov_vf_device_id                                                                                ) ,
       .pf1_sriov_vf_offset_ari_cs2                                                                             (  pf1_sriov_vf_offset_ari_cs2                                                                           ) ,
       .pf1_sriov_vf_offset_position_nonari                                                                     (  pf1_sriov_vf_offset_position_nonari                                                                   ) ,
       .pf1_sriov_vf_stride_nonari                                                                              (  pf1_sriov_vf_stride_nonari                                                                            ) ,
       .pf1_subclass_code                                                                                       (  pf1_subclass_code                                                                                     ) ,
       .pf1_subsys_dev_id                                                                                       (  pf1_subsys_dev_id                                                                                     ) ,
       .pf1_subsys_vendor_id                                                                                    (  pf1_subsys_vendor_id                                                                                  ) ,
       .pf1_tph_cap_tph_ext_cap_hdr_reg_addr_byte2                                                              (  pf1_tph_cap_tph_ext_cap_hdr_reg_addr_byte2                                                            ) ,
       .pf1_tph_cap_tph_ext_cap_hdr_reg_addr_byte3                                                              (  pf1_tph_cap_tph_ext_cap_hdr_reg_addr_byte3                                                            ) ,
       .pf1_tph_cap_tph_req_cap_reg_addr_byte0                                                                  (  pf1_tph_cap_tph_req_cap_reg_addr_byte0                                                                ) ,
       .pf1_tph_cap_tph_req_cap_reg_addr_byte1                                                                  (  pf1_tph_cap_tph_req_cap_reg_addr_byte1                                                                ) ,
       .pf1_tph_cap_tph_req_cap_reg_addr_byte2                                                                  (  pf1_tph_cap_tph_req_cap_reg_addr_byte2                                                                ) ,
       .pf1_tph_cap_tph_req_cap_reg_addr_byte3                                                                  (  pf1_tph_cap_tph_req_cap_reg_addr_byte3                                                                ) ,
       .pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte0                                                       (  pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte0                                                     ) ,
       .pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte1                                                       (  pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte1                                                     ) ,
       .pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte2                                                       (  pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte2                                                     ) ,
       .pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte3                                                       (  pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte3                                                     ) ,
       .pf1_tph_req_cap_int_vec                                                                                 (  pf1_tph_req_cap_int_vec                                                                               ) ,
       .pf1_tph_req_cap_int_vec_vfcomm_cs2                                                                      (  pf1_tph_req_cap_int_vec_vfcomm_cs2                                                                    ) ,
       .pf1_tph_req_cap_reg_rsvdp_11                                                                            (  pf1_tph_req_cap_reg_rsvdp_11                                                                          ) ,
       .pf1_tph_req_cap_reg_rsvdp_27                                                                            (  pf1_tph_req_cap_reg_rsvdp_27                                                                          ) ,
       .pf1_tph_req_cap_reg_rsvdp_3                                                                             (  pf1_tph_req_cap_reg_rsvdp_3                                                                           ) ,
       .pf1_tph_req_cap_reg_vfcomm_cs2_rsvdp_11_vfcomm_cs2                                                      (  pf1_tph_req_cap_reg_vfcomm_cs2_rsvdp_11_vfcomm_cs2                                                    ) ,
       .pf1_tph_req_cap_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                                                      (  pf1_tph_req_cap_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                                                    ) ,
       .pf1_tph_req_cap_reg_vfcomm_cs2_rsvdp_3_vfcomm_cs2                                                       (  pf1_tph_req_cap_reg_vfcomm_cs2_rsvdp_3_vfcomm_cs2                                                     ) ,
       .pf1_tph_req_cap_st_table_loc_0                                                                          (  pf1_tph_req_cap_st_table_loc_0                                                                        ) ,
       .pf1_tph_req_cap_st_table_loc_0_vfcomm_cs2                                                               (  pf1_tph_req_cap_st_table_loc_0_vfcomm_cs2                                                             ) ,
       .pf1_tph_req_cap_st_table_loc_1                                                                          (  pf1_tph_req_cap_st_table_loc_1                                                                        ) ,
       .pf1_tph_req_cap_st_table_loc_1_vfcomm_cs2                                                               (  pf1_tph_req_cap_st_table_loc_1_vfcomm_cs2                                                             ) ,
       .pf1_tph_req_cap_st_table_size                                                                           (  pf1_tph_req_cap_st_table_size                                                                         ) ,
       .pf1_tph_req_cap_st_table_size_vfcomm_cs2                                                                (  pf1_tph_req_cap_st_table_size_vfcomm_cs2                                                              ) ,
       .pf1_tph_req_cap_ver                                                                                     (  pf1_tph_req_cap_ver                                                                                   ) ,
       .pf1_tph_req_device_spec                                                                                 (  pf1_tph_req_device_spec                                                                               ) ,
       .pf1_tph_req_device_spec_vfcomm_cs2                                                                      (  pf1_tph_req_device_spec_vfcomm_cs2                                                                    ) ,
       .pf1_tph_req_extended_tph                                                                                (  pf1_tph_req_extended_tph                                                                              ) ,
       .pf1_tph_req_extended_tph_vfcomm_cs2                                                                     (  pf1_tph_req_extended_tph_vfcomm_cs2                                                                   ) ,
       .pf1_tph_req_next_ptr                                                                                    (  pf1_tph_req_next_ptr                                                                                  ) ,
       .pf1_tph_req_no_st_mode                                                                                  (  pf1_tph_req_no_st_mode                                                                                ) ,
       .pf1_tph_req_no_st_mode_vfcomm_cs2                                                                       (  pf1_tph_req_no_st_mode_vfcomm_cs2                                                                     ) ,
       .pf1_type0_hdr_bar0_mask_reg_addr_byte0                                                                  (  pf1_type0_hdr_bar0_mask_reg_addr_byte0                                                                ) ,
       .pf1_type0_hdr_bar0_mask_reg_addr_byte1                                                                  (  pf1_type0_hdr_bar0_mask_reg_addr_byte1                                                                ) ,
       .pf1_type0_hdr_bar0_mask_reg_addr_byte2                                                                  (  pf1_type0_hdr_bar0_mask_reg_addr_byte2                                                                ) ,
       .pf1_type0_hdr_bar0_mask_reg_addr_byte3                                                                  (  pf1_type0_hdr_bar0_mask_reg_addr_byte3                                                                ) ,
       .pf1_type0_hdr_bar0_reg_addr_byte0                                                                       (  pf1_type0_hdr_bar0_reg_addr_byte0                                                                     ) ,
       .pf1_type0_hdr_bar1_enable_reg_addr_byte0                                                                (  pf1_type0_hdr_bar1_enable_reg_addr_byte0                                                              ) ,
       .pf1_type0_hdr_bar1_mask_reg_addr_byte0                                                                  (  pf1_type0_hdr_bar1_mask_reg_addr_byte0                                                                ) ,
       .pf1_type0_hdr_bar1_mask_reg_addr_byte1                                                                  (  pf1_type0_hdr_bar1_mask_reg_addr_byte1                                                                ) ,
       .pf1_type0_hdr_bar1_mask_reg_addr_byte2                                                                  (  pf1_type0_hdr_bar1_mask_reg_addr_byte2                                                                ) ,
       .pf1_type0_hdr_bar1_mask_reg_addr_byte3                                                                  (  pf1_type0_hdr_bar1_mask_reg_addr_byte3                                                                ) ,
       .pf1_type0_hdr_bar1_reg_addr_byte0                                                                       (  pf1_type0_hdr_bar1_reg_addr_byte0                                                                     ) ,
       .pf1_type0_hdr_bar2_mask_reg_addr_byte0                                                                  (  pf1_type0_hdr_bar2_mask_reg_addr_byte0                                                                ) ,
       .pf1_type0_hdr_bar2_mask_reg_addr_byte1                                                                  (  pf1_type0_hdr_bar2_mask_reg_addr_byte1                                                                ) ,
       .pf1_type0_hdr_bar2_mask_reg_addr_byte2                                                                  (  pf1_type0_hdr_bar2_mask_reg_addr_byte2                                                                ) ,
       .pf1_type0_hdr_bar2_mask_reg_addr_byte3                                                                  (  pf1_type0_hdr_bar2_mask_reg_addr_byte3                                                                ) ,
       .pf1_type0_hdr_bar2_reg_addr_byte0                                                                       (  pf1_type0_hdr_bar2_reg_addr_byte0                                                                     ) ,
       .pf1_type0_hdr_bar3_enable_reg_addr_byte0                                                                (  pf1_type0_hdr_bar3_enable_reg_addr_byte0                                                              ) ,
       .pf1_type0_hdr_bar3_mask_reg_addr_byte0                                                                  (  pf1_type0_hdr_bar3_mask_reg_addr_byte0                                                                ) ,
       .pf1_type0_hdr_bar3_mask_reg_addr_byte1                                                                  (  pf1_type0_hdr_bar3_mask_reg_addr_byte1                                                                ) ,
       .pf1_type0_hdr_bar3_mask_reg_addr_byte2                                                                  (  pf1_type0_hdr_bar3_mask_reg_addr_byte2                                                                ) ,
       .pf1_type0_hdr_bar3_mask_reg_addr_byte3                                                                  (  pf1_type0_hdr_bar3_mask_reg_addr_byte3                                                                ) ,
       .pf1_type0_hdr_bar3_reg_addr_byte0                                                                       (  pf1_type0_hdr_bar3_reg_addr_byte0                                                                     ) ,
       .pf1_type0_hdr_bar4_mask_reg_addr_byte0                                                                  (  pf1_type0_hdr_bar4_mask_reg_addr_byte0                                                                ) ,
       .pf1_type0_hdr_bar4_mask_reg_addr_byte1                                                                  (  pf1_type0_hdr_bar4_mask_reg_addr_byte1                                                                ) ,
       .pf1_type0_hdr_bar4_mask_reg_addr_byte2                                                                  (  pf1_type0_hdr_bar4_mask_reg_addr_byte2                                                                ) ,
       .pf1_type0_hdr_bar4_mask_reg_addr_byte3                                                                  (  pf1_type0_hdr_bar4_mask_reg_addr_byte3                                                                ) ,
       .pf1_type0_hdr_bar4_reg_addr_byte0                                                                       (  pf1_type0_hdr_bar4_reg_addr_byte0                                                                     ) ,
       .pf1_type0_hdr_bar5_enable_reg_addr_byte0                                                                (  pf1_type0_hdr_bar5_enable_reg_addr_byte0                                                              ) ,
       .pf1_type0_hdr_bar5_mask_reg_addr_byte0                                                                  (  pf1_type0_hdr_bar5_mask_reg_addr_byte0                                                                ) ,
       .pf1_type0_hdr_bar5_mask_reg_addr_byte1                                                                  (  pf1_type0_hdr_bar5_mask_reg_addr_byte1                                                                ) ,
       .pf1_type0_hdr_bar5_mask_reg_addr_byte2                                                                  (  pf1_type0_hdr_bar5_mask_reg_addr_byte2                                                                ) ,
       .pf1_type0_hdr_bar5_mask_reg_addr_byte3                                                                  (  pf1_type0_hdr_bar5_mask_reg_addr_byte3                                                                ) ,
       .pf1_type0_hdr_bar5_reg_addr_byte0                                                                       (  pf1_type0_hdr_bar5_reg_addr_byte0                                                                     ) ,
       .pf1_type0_hdr_bist_header_type_latency_cache_line_size_reg_addr_byte2                                   (  pf1_type0_hdr_bist_header_type_latency_cache_line_size_reg_addr_byte2                                 ) ,
       .pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte0                                                            (  pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte0                                                          ) ,
       .pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte1                                                            (  pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte1                                                          ) ,
       .pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte2                                                            (  pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte2                                                          ) ,
       .pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte3                                                            (  pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte3                                                          ) ,
       .pf1_type0_hdr_class_code_revision_id_addr_byte0                                                         (  pf1_type0_hdr_class_code_revision_id_addr_byte0                                                       ) ,
       .pf1_type0_hdr_class_code_revision_id_addr_byte1                                                         (  pf1_type0_hdr_class_code_revision_id_addr_byte1                                                       ) ,
       .pf1_type0_hdr_class_code_revision_id_addr_byte2                                                         (  pf1_type0_hdr_class_code_revision_id_addr_byte2                                                       ) ,
       .pf1_type0_hdr_class_code_revision_id_addr_byte3                                                         (  pf1_type0_hdr_class_code_revision_id_addr_byte3                                                       ) ,
       .pf1_type0_hdr_device_id_vendor_id_reg_addr_byte0                                                        (  pf1_type0_hdr_device_id_vendor_id_reg_addr_byte0                                                      ) ,
       .pf1_type0_hdr_device_id_vendor_id_reg_addr_byte1                                                        (  pf1_type0_hdr_device_id_vendor_id_reg_addr_byte1                                                      ) ,
       .pf1_type0_hdr_device_id_vendor_id_reg_addr_byte2                                                        (  pf1_type0_hdr_device_id_vendor_id_reg_addr_byte2                                                      ) ,
       .pf1_type0_hdr_device_id_vendor_id_reg_addr_byte3                                                        (  pf1_type0_hdr_device_id_vendor_id_reg_addr_byte3                                                      ) ,
       .pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte0                                                           (  pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte0                                                         ) ,
       .pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte1                                                           (  pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte1                                                         ) ,
       .pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte2                                                           (  pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte2                                                         ) ,
       .pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte3                                                           (  pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte3                                                         ) ,
       .pf1_type0_hdr_exp_rom_base_addr_reg_addr_byte0                                                          (  pf1_type0_hdr_exp_rom_base_addr_reg_addr_byte0                                                        ) ,
       .pf1_type0_hdr_max_latency_min_grant_interrupt_pin_interrupt_line_reg_addr_byte1                         (  pf1_type0_hdr_max_latency_min_grant_interrupt_pin_interrupt_line_reg_addr_byte1                       ) ,
       .pf1_type0_hdr_pci_cap_ptr_reg_addr_byte0                                                                (  pf1_type0_hdr_pci_cap_ptr_reg_addr_byte0                                                              ) ,
       .pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte0                                           (  pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte0                                         ) ,
       .pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte1                                           (  pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte1                                         ) ,
       .pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte2                                           (  pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte2                                         ) ,
       .pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte3                                           (  pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte3                                         ) ,
       .pf1_vf_bar0_reg_rsvdp_0                                                                                 (  pf1_vf_bar0_reg_rsvdp_0                                                                               ) ,
       .pf1_vf_bar1_reg_rsvdp_0                                                                                 (  pf1_vf_bar1_reg_rsvdp_0                                                                               ) ,
       .pf1_vf_bar2_reg_rsvdp_0                                                                                 (  pf1_vf_bar2_reg_rsvdp_0                                                                               ) ,
       .pf1_vf_bar3_reg_rsvdp_0                                                                                 (  pf1_vf_bar3_reg_rsvdp_0                                                                               ) ,
       .pf1_vf_bar4_reg_rsvdp_0                                                                                 (  pf1_vf_bar4_reg_rsvdp_0                                                                               ) ,
       .pf1_vf_bar5_reg_rsvdp_0                                                                                 (  pf1_vf_bar5_reg_rsvdp_0                                                                               ) ,
       .pf1_vf_forward_user_vsec                                                                                (  pf1_vf_forward_user_vsec                                                                              ) ,
       .pipe_ctrl                                                                                               (  pipe_ctrl                                                                                             ) ,
       .pld_aib_loopback_en                                                                                     (  pld_aib_loopback_en                                                                                   ) ,
       .pld_aux_gate_en                                                                                         (  pld_aux_gate_en                                                                                       ) ,
       .pld_aux_prog_en                                                                                         (  pld_aux_prog_en                                                                                       ) ,
       .pld_crs_en                                                                                              (  pld_crs_en                                                                                            ) ,
       .pld_rx_cpl_bufflimit_bypass                                                                             (  pld_rx_cpl_bufflimit_bypass                                                                           ) ,
       .pld_rx_np_bufflimit_bypass                                                                              (  pld_rx_np_bufflimit_bypass                                                                            ) ,
       .pld_rx_parity_ena                                                                                       (  pld_rx_parity_ena                                                                                     ) ,
       .pld_rx_posted_bufflimit_bypass                                                                          (  pld_rx_posted_bufflimit_bypass                                                                        ) ,
       .pld_tx_fifo_dyn_empty_dis                                                                               (  pld_tx_fifo_dyn_empty_dis                                                                             ) ,
       .pld_tx_fifo_empty_threshold_1                                                                           (  pld_tx_fifo_empty_threshold_1                                                                         ) ,
       .pld_tx_fifo_empty_threshold_2                                                                           (  pld_tx_fifo_empty_threshold_2                                                                         ) ,
       .pld_tx_fifo_empty_threshold_3                                                                           (  pld_tx_fifo_empty_threshold_3                                                                         ) ,
       .pld_tx_fifo_full_threshold                                                                              (  pld_tx_fifo_full_threshold                                                                            ) ,
       .pld_tx_parity_ena                                                                                       (  pld_tx_parity_ena                                                                                     ) ,
       .powerdown_mode                                                                                          (  powerdown_mode                                                                                        ) ,
       .rx_lane_flip_en                                                                                         (  rx_lane_flip_en                                                                                       ) ,
       .silicon_rev                                                                                             (  silicon_rev                                                                                           ) ,
       .sim_mode                                                                                                (  sim_mode                                                                                              ) ,
       .ssm_aux_prog_en                                                                                         (  ssm_aux_prog_en                                                                                       ) ,
       .sup_mode                                                                                                (  sup_mode                                                                                              ) ,
       .test_in_hi                                                                                              (  test_in_hi                                                                                            ) ,
       .test_in_lo                                                                                              (  test_in_lo                                                                                            ) ,
       .test_in_override                                                                                        (  test_in_override                                                                                      ) ,
       .tx_avst_dsk_en                                                                                          (  tx_avst_dsk_en                                                                                        ) ,
       .tx_lane_flip_en                                                                                         (  tx_lane_flip_en                                                                                       ) ,
       .user_mode_del_count                                                                                     (  user_mode_del_count                                                                                   ) ,
       .valid_ecc_err_rpt_en                                                                                    (  valid_ecc_err_rpt_en                                                                                  ) ,
       .vf1_pf0_ari_cap_version                                                                                 (  vf1_pf0_ari_cap_version                                                                               ) ,
       .vf1_pf0_ari_cap_vf_ari_base_addr_byte2                                                                  (  vf1_pf0_ari_cap_vf_ari_base_addr_byte2                                                                ) ,
       .vf1_pf0_ari_cap_vf_ari_base_addr_byte3                                                                  (  vf1_pf0_ari_cap_vf_ari_base_addr_byte3                                                                ) ,
       .vf1_pf0_ari_next_offset                                                                                 (  vf1_pf0_ari_next_offset                                                                               ) ,
       .vf1_pf0_pcie_cap_vf_shadow_link_capabilities_reg_addr_byte1                                             (  vf1_pf0_pcie_cap_vf_shadow_link_capabilities_reg_addr_byte1                                           ) ,
       .vf1_pf0_shadow_pcie_cap_aspm_opt_compliance                                                             (  vf1_pf0_shadow_pcie_cap_aspm_opt_compliance                                                           ) ,
       .vf1_pf0_shadow_pcie_cap_clock_power_man                                                                 (  vf1_pf0_shadow_pcie_cap_clock_power_man                                                               ) ,
       .vf1_pf0_shadow_pcie_cap_dll_active_rep_cap                                                              (  vf1_pf0_shadow_pcie_cap_dll_active_rep_cap                                                            ) ,
       .vf1_pf0_shadow_pcie_cap_l1_exit_latency_commclk_ena                                                     (  vf1_pf0_shadow_pcie_cap_l1_exit_latency_commclk_ena                                                   ) ,
       .vf1_pf0_shadow_pcie_cap_link_bw_not_cap                                                                 (  vf1_pf0_shadow_pcie_cap_link_bw_not_cap                                                               ) ,
       .vf1_pf0_shadow_pcie_cap_surprise_down_err_rep_cap                                                       (  vf1_pf0_shadow_pcie_cap_surprise_down_err_rep_cap                                                     ) ,
       .vf1_pf0_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte2                                                       (  vf1_pf0_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte2                                                     ) ,
       .vf1_pf0_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte3                                                       (  vf1_pf0_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte3                                                     ) ,
       .vf1_pf0_tph_req_cap_ver                                                                                 (  vf1_pf0_tph_req_cap_ver                                                                               ) ,
       .vf1_pf0_tph_req_next_ptr                                                                                (  vf1_pf0_tph_req_next_ptr                                                                              ) ,
       .vf1_pf0_vf_shadow_link_capabilities_reg_shadow_rsvdp_23                                                 (  vf1_pf0_vf_shadow_link_capabilities_reg_shadow_rsvdp_23                                               ) ,
       .vf1_pf1_ari_cap_version                                                                                 (  vf1_pf1_ari_cap_version                                                                               ) ,
       .vf1_pf1_ari_cap_vf_ari_base_addr_byte2                                                                  (  vf1_pf1_ari_cap_vf_ari_base_addr_byte2                                                                ) ,
       .vf1_pf1_ari_cap_vf_ari_base_addr_byte3                                                                  (  vf1_pf1_ari_cap_vf_ari_base_addr_byte3                                                                ) ,
       .vf1_pf1_ari_next_offset                                                                                 (  vf1_pf1_ari_next_offset                                                                               ) ,
       .vf1_pf1_pcie_cap_vf_shadow_link_capabilities_reg_addr_byte1                                             (  vf1_pf1_pcie_cap_vf_shadow_link_capabilities_reg_addr_byte1                                           ) ,
       .vf1_pf1_shadow_pcie_cap_aspm_opt_compliance                                                             (  vf1_pf1_shadow_pcie_cap_aspm_opt_compliance                                                           ) ,
       .vf1_pf1_shadow_pcie_cap_clock_power_man                                                                 (  vf1_pf1_shadow_pcie_cap_clock_power_man                                                               ) ,
       .vf1_pf1_shadow_pcie_cap_dll_active_rep_cap                                                              (  vf1_pf1_shadow_pcie_cap_dll_active_rep_cap                                                            ) ,
       .vf1_pf1_shadow_pcie_cap_l1_exit_latency_commclk_ena                                                     (  vf1_pf1_shadow_pcie_cap_l1_exit_latency_commclk_ena                                                   ) ,
       .vf1_pf1_shadow_pcie_cap_link_bw_not_cap                                                                 (  vf1_pf1_shadow_pcie_cap_link_bw_not_cap                                                               ) ,
       .vf1_pf1_shadow_pcie_cap_surprise_down_err_rep_cap                                                       (  vf1_pf1_shadow_pcie_cap_surprise_down_err_rep_cap                                                     ) ,
       .vf1_pf1_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte2                                                       (  vf1_pf1_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte2                                                     ) ,
       .vf1_pf1_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte3                                                       (  vf1_pf1_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte3                                                     ) ,
       .vf1_pf1_tph_req_cap_ver                                                                                 (  vf1_pf1_tph_req_cap_ver                                                                               ) ,
       .vf1_pf1_tph_req_next_ptr                                                                                (  vf1_pf1_tph_req_next_ptr                                                                              ) ,
       .vf1_pf1_vf_shadow_link_capabilities_reg_shadow_rsvdp_23                                                 (  vf1_pf1_vf_shadow_link_capabilities_reg_shadow_rsvdp_23                                               ) ,
       .vf_dbi_reserved_0                                                                                       (  vf_dbi_reserved_0                                                                                     ) ,
       .vf_dbi_reserved_1                                                                                       (  vf_dbi_reserved_1                                                                                     ) ,
       .vf_dbi_reserved_2                                                                                       (  vf_dbi_reserved_2                                                                                     ) ,
       .vf_dbi_reserved_3                                                                                       (  vf_dbi_reserved_3                                                                                     ) ,
       .vf_dbi_reserved_4                                                                                       (  vf_dbi_reserved_4                                                                                     ) ,
       .vf_dbi_reserved_5                                                                                       (  vf_dbi_reserved_5                                                                                     ) ,
       .vf_reserved_0_addr                                                                                      (  vf_reserved_0_addr                                                                                    ) ,
       .vf_reserved_1_addr                                                                                      (  vf_reserved_1_addr                                                                                    ) ,
       .vf_reserved_2_addr                                                                                      (  vf_reserved_2_addr                                                                                    ) ,
       .vf_reserved_3_addr                                                                                      (  vf_reserved_3_addr                                                                                    ) ,
       .vf_reserved_4_addr                                                                                      (  vf_reserved_4_addr                                                                                    ) ,
       .vf_reserved_5_addr                                                                                      (  vf_reserved_5_addr                                                                                    ) ,
       .virtual_drop_vendor0_msg                                                                                (  virtual_drop_vendor0_msg                                                                              ) ,
       .virtual_drop_vendor1_msg                                                                                (  virtual_drop_vendor1_msg                                                                              ) ,
       .virtual_ep_native                                                                                       (  virtual_ep_native                                                                                     ) ,
       .virtual_gen2_pma_pll_usage                                                                              (  virtual_gen2_pma_pll_usage                                                                            ) ,
       .virtual_hrdrstctrl_en                                                                                   (  virtual_hrdrstctrl_en                                                                                 ) ,
       .virtual_link_rate                                                                                       (  virtual_link_rate                                                                                     ) ,
       .virtual_link_width                                                                                      (  virtual_link_width                                                                                    ) ,
       .virtual_maxpayload_size                                                                                 (  virtual_maxpayload_size                                                                               ) ,
       .virtual_pf0_ats_cap_enable                                                                              (  virtual_pf0_ats_cap_enable                                                                            ) ,
       .virtual_pf0_bar1_mask_bit0                                                                              (  virtual_pf0_bar1_mask_bit0                                                                            ) ,
       .virtual_pf0_bar3_mask_bit0                                                                              (  virtual_pf0_bar3_mask_bit0                                                                            ) ,
       .virtual_pf0_bar5_mask_bit0                                                                              (  virtual_pf0_bar5_mask_bit0                                                                            ) ,
       .virtual_pf0_io_decode                                                                                   (  virtual_pf0_io_decode                                                                                 ) ,
       .virtual_pf0_msi_enable                                                                                  (  virtual_pf0_msi_enable                                                                                ) ,
       .virtual_pf0_msix_enable                                                                                 (  virtual_pf0_msix_enable                                                                               ) ,
       .virtual_pf0_pb_cap_enable                                                                               (  virtual_pf0_pb_cap_enable                                                                             ) ,
       .virtual_pf0_prefetch_decode                                                                             (  virtual_pf0_prefetch_decode                                                                           ) ,
       .virtual_pf0_sn_cap_enable                                                                               (  virtual_pf0_sn_cap_enable                                                                             ) ,
       .virtual_pf0_sriov_enable                                                                                (  virtual_pf0_sriov_enable                                                                              ) ,
       .virtual_pf0_sriov_num_vf_ari                                                                            (  virtual_pf0_sriov_num_vf_ari                                                                          ) ,
       .virtual_pf0_sriov_num_vf_non_ari                                                                        (  virtual_pf0_sriov_num_vf_non_ari                                                                      ) ,
       .virtual_pf0_sriov_vf_bar0_enabled                                                                       (  virtual_pf0_sriov_vf_bar0_enabled                                                                     ) ,
       .virtual_pf0_sriov_vf_bar1_enabled                                                                       (  virtual_pf0_sriov_vf_bar1_enabled                                                                     ) ,
       .virtual_pf0_sriov_vf_bar2_enabled                                                                       (  virtual_pf0_sriov_vf_bar2_enabled                                                                     ) ,
       .virtual_pf0_sriov_vf_bar3_enabled                                                                       (  virtual_pf0_sriov_vf_bar3_enabled                                                                     ) ,
       .virtual_pf0_sriov_vf_bar4_enabled                                                                       (  virtual_pf0_sriov_vf_bar4_enabled                                                                     ) ,
       .virtual_pf0_sriov_vf_bar5_enabled                                                                       (  virtual_pf0_sriov_vf_bar5_enabled                                                                     ) ,
       .virtual_pf0_tph_cap_enable                                                                              (  virtual_pf0_tph_cap_enable                                                                            ) ,
       .virtual_pf0_user_vsec_cap_enable                                                                        (  virtual_pf0_user_vsec_cap_enable                                                                      ) ,
       .virtual_pf1_ats_cap_enable                                                                              (  virtual_pf1_ats_cap_enable                                                                            ) ,
       .virtual_pf1_bar1_mask_bit0                                                                              (  virtual_pf1_bar1_mask_bit0                                                                            ) ,
       .virtual_pf1_bar3_mask_bit0                                                                              (  virtual_pf1_bar3_mask_bit0                                                                            ) ,
       .virtual_pf1_bar5_mask_bit0                                                                              (  virtual_pf1_bar5_mask_bit0                                                                            ) ,
       .virtual_pf1_enable                                                                                      (  virtual_pf1_enable                                                                                    ) ,
       .virtual_pf1_msi_enable                                                                                  (  virtual_pf1_msi_enable                                                                                ) ,
       .virtual_pf1_msix_enable                                                                                 (  virtual_pf1_msix_enable                                                                               ) ,
       .virtual_pf1_pb_cap_enable                                                                               (  virtual_pf1_pb_cap_enable                                                                             ) ,
       .virtual_pf1_sn_cap_enable                                                                               (  virtual_pf1_sn_cap_enable                                                                             ) ,
       .virtual_pf1_sriov_enable                                                                                (  virtual_pf1_sriov_enable                                                                              ) ,
       .virtual_pf1_sriov_num_vf_ari                                                                            (  virtual_pf1_sriov_num_vf_ari                                                                          ) ,
       .virtual_pf1_sriov_num_vf_non_ari                                                                        (  virtual_pf1_sriov_num_vf_non_ari                                                                      ) ,
       .virtual_pf1_sriov_vf_bar0_enabled                                                                       (  virtual_pf1_sriov_vf_bar0_enabled                                                                     ) ,
       .virtual_pf1_sriov_vf_bar1_enabled                                                                       (  virtual_pf1_sriov_vf_bar1_enabled                                                                     ) ,
       .virtual_pf1_sriov_vf_bar2_enabled                                                                       (  virtual_pf1_sriov_vf_bar2_enabled                                                                     ) ,
       .virtual_pf1_sriov_vf_bar3_enabled                                                                       (  virtual_pf1_sriov_vf_bar3_enabled                                                                     ) ,
       .virtual_pf1_sriov_vf_bar4_enabled                                                                       (  virtual_pf1_sriov_vf_bar4_enabled                                                                     ) ,
       .virtual_pf1_sriov_vf_bar5_enabled                                                                       (  virtual_pf1_sriov_vf_bar5_enabled                                                                     ) ,
       .virtual_pf1_tph_cap_enable                                                                              (  virtual_pf1_tph_cap_enable                                                                            ) ,
       .virtual_pf1_user_vsec_cap_enable                                                                        (  virtual_pf1_user_vsec_cap_enable                                                                      ) ,
       .virtual_phase23_txpreset                                                                                (  virtual_phase23_txpreset                                                                              ) ,
       .virtual_rp_ep_mode                                                                                      (  virtual_rp_ep_mode                                                                                    ) ,
       .virtual_txeq_mode                                                                                       (  virtual_txeq_mode                                                                                     ) ,
       .virtual_uc_calibration_en                                                                               (  virtual_uc_calibration_en                                                                             ) ,
       .virtual_vf1_pf0_ats_cap_enable                                                                          (  virtual_vf1_pf0_ats_cap_enable                                                                        ) ,
       .virtual_vf1_pf0_tph_cap_enable                                                                          (  virtual_vf1_pf0_tph_cap_enable                                                                        ) ,
       .virtual_vf1_pf0_user_vsec_cap_enable                                                                    (  virtual_vf1_pf0_user_vsec_cap_enable                                                                  ) ,
       .virtual_vf1_pf1_ats_cap_enable                                                                          (  virtual_vf1_pf1_ats_cap_enable                                                                        ) ,
       .virtual_vf1_pf1_tph_cap_enable                                                                          (  virtual_vf1_pf1_tph_cap_enable                                                                        ) ,
       .virtual_vf1_pf1_user_vsec_cap_enable                                                                    (  virtual_vf1_pf1_user_vsec_cap_enable                                                                  ) ,
       .vsec_legacy_interr_mask_en                                                                              (  vsec_legacy_interr_mask_en                                                                            ) ,
       .vsec_next_offset                                                                                        (  vsec_next_offset                                                                                      )
 )
     wys  (
//Inputs
        .app_err_func_num                                      (  ch6_hip_aib_sync_data_in[50]                             ) ,
        .app_err_hdr                                           (  ch6_hip_aib_sync_data_in[31:0]                           ) ,
        .app_err_info                                          (  ch6_hip_aib_sync_data_in[42:32]                          ) ,
        .app_err_valid                                         (  ch6_hip_aib_sync_data_in[51]                             ) ,
        .app_err_vfunc_active                                  (  ch6_hip_aib_sync_data_in[52]                             ) ,
        .app_err_vfunc_num                                     (  ch6_hip_aib_sync_data_in[49:43]                          ) ,
        .app_init_rst                                          (  ch4_hip_aib_sync_data_in[73]                             ) ,
        .app_int                                               (  ch4_hip_aib_sync_data_in[75:74]                          ) ,
        .app_msi_func_num                                      (  ch4_hip_aib_sync_data_in[67]                             ) ,
        .app_msi_num                                           (  ch4_hip_aib_sync_data_in[66:62]                          ) ,
        .app_msi_pending                                       (  ch4_hip_aib_sync_data_in[60:29]                          ) ,
        .app_msi_req                                           (  ch4_hip_aib_sync_data_in[61]                             ) ,
        .app_msi_tc                                            (  ch4_hip_aib_sync_data_in[28:26]                          ) ,
        .app_req_retry_en                                      (  ch4_hip_aib_sync_data_in[76]                             ) ,
        .app_xfer_pending                                      (  ch4_hip_aib_sync_data_in[77]                             ) ,
        .apps_pm_xmt_pme_0                                     (  ch4_hip_aib_sync_data_in[72]                             ) ,
        .apps_pm_xmt_pme_1                                     (  ch4_hip_aib_sync_data_in[71]                             ) ,
        .apps_pm_xmt_turnoff                                   (  ch6_hip_aib_sync_data_in[76]                             ) ,
        .apps_ready_entr_l23                                   (  ch4_hip_aib_sync_data_in[70]                             ) ,
        .apps_req_entr_l1                                      (  ch4_hip_aib_sync_data_in[69]                             ) , //Input not supported by core
        .apps_req_exit_l1                                      (  ch4_hip_aib_sync_data_in[68]                             ) , //Input not supported by core
        .ceb_ack                                               (  ch5_hip_aib_sync_data_in[32]                             ) ,
        .ceb_din                                               (  ch5_hip_aib_sync_data_in[31:0]                           ) ,
        .cfg_buffer_limit_byp                                  (  {ch4_hip_aib_sync_data_in[25:24],ch5_hip_aib_sync_data_in[49] }  ) ,
        .ch0_aib_osc_transfer_en                               (  ch0_hip_aib_status[2]                                    ) ,
        .ch0_aib_rx_transfer_en                                (  ch0_hip_aib_status[1]                                    ) ,
        .ch0_aib_tx_transfer_en                                (  ch0_hip_aib_status[0]                                    ) ,
        .ch1_aib_osc_transfer_en                               (  ch1_hip_aib_status[2]                                    ) ,
        .ch1_aib_rx_transfer_en                                (  ch1_hip_aib_status[1]                                    ) ,
        .ch1_aib_tx_transfer_en                                (  ch1_hip_aib_status[0]                                    ) ,
        .ch2_aib_osc_transfer_en                               (  ch2_hip_aib_status[2]                                    ) ,
        .ch2_aib_rx_transfer_en                                (  ch2_hip_aib_status[1]                                    ) ,
        .ch2_aib_tx_transfer_en                                (  ch2_hip_aib_status[0]                                    ) ,
        .ch3_aib_osc_transfer_en                               (  ch3_hip_aib_status[2]                                    ) ,
        .ch3_aib_rx_transfer_en                                (  ch3_hip_aib_status[1]                                    ) ,
        .ch3_aib_tx_transfer_en                                (  ch3_hip_aib_status[0]                                    ) ,
        .ch4_aib_osc_transfer_en                               (  ch4_hip_aib_status[2]                                    ) ,
        .ch4_aib_rx_transfer_en                                (  ch4_hip_aib_status[1]                                    ) ,
        .ch4_aib_tx_transfer_en                                (  ch4_hip_aib_status[0]                                    ) ,
        .ch5_aib_osc_transfer_en                               (  ch5_hip_aib_status[2]                                    ) ,
        .ch5_aib_rx_transfer_en                                (  ch5_hip_aib_status[1]                                    ) ,
        .ch5_aib_tx_transfer_en                                (  ch5_hip_aib_status[0]                                    ) ,
        .ch6_aib_osc_transfer_en                               (  ch6_hip_aib_status[2]                                    ) ,
        .ch6_aib_rx_transfer_en                                (  ch6_hip_aib_status[1]                                    ) ,
        .ch6_aib_tx_transfer_en                                (  ch6_hip_aib_status[0]                                    ) ,
        .ch7_aib_osc_transfer_en                               (  ch7_hip_aib_status[2]                                    ) ,
        .ch7_aib_rx_transfer_en                                (  ch7_hip_aib_status[1]                                    ) ,
        .ch7_aib_tx_transfer_en                                (  ch7_hip_aib_status[0]                                    ) ,
        .chnl_cal_done                                         (  chnl_cal_done                                            ) ,
        .diag_ctrl_bus                                         (  ch5_hip_aib_sync_data_in[43:41]                          ) ,
        .flr_pf_done                                           (  ch6_hip_aib_sync_data_in[66:65]                          ) ,
        .flr_vf_done                                           (  ch6_hip_aib_sync_data_in[64:57]                          ) ,
        .flr_vf_done_tdm                                       (  ch6_hip_aib_sync_data_in[56:53]                          ) ,
        .fref_clk                                              (  fref_clk                                                 ) ,
        .l0_hip_aib_rx_data                                    (  l0_hip_aib_rx_data                                       ) ,
        .l0_hip_pcs_rx_data                                    (  l0_hip_pcs_rx_data                                       ) ,
        .l10_hip_aib_rx_data                                   (  l10_hip_aib_rx_data                                      ) ,
        .l10_hip_pcs_rx_data                                   (  l10_hip_pcs_rx_data                                      ) ,
        .l11_hip_aib_rx_data                                   (  l11_hip_aib_rx_data                                      ) ,
        .l11_hip_pcs_rx_data                                   (  l11_hip_pcs_rx_data                                      ) ,
        .l12_hip_aib_rx_data                                   (  l12_hip_aib_rx_data                                      ) ,
        .l12_hip_pcs_rx_data                                   (  l12_hip_pcs_rx_data                                      ) ,
        .l13_hip_aib_rx_data                                   (  l13_hip_aib_rx_data                                      ) ,
        .l13_hip_pcs_rx_data                                   (  l13_hip_pcs_rx_data                                      ) ,
        .l14_hip_aib_rx_data                                   (  l14_hip_aib_rx_data                                      ) ,
        .l14_hip_pcs_rx_data                                   (  l14_hip_pcs_rx_data                                      ) ,
        .l15_hip_aib_rx_data                                   (  l15_hip_aib_rx_data                                      ) ,
        .l15_hip_pcs_rx_data                                   (  l15_hip_pcs_rx_data                                      ) ,
        .l1_hip_aib_rx_data                                    (  l1_hip_aib_rx_data                                       ) ,
        .l1_hip_pcs_rx_data                                    (  l1_hip_pcs_rx_data                                       ) ,
        .l2_hip_aib_rx_data                                    (  l2_hip_aib_rx_data                                       ) ,
        .l2_hip_pcs_rx_data                                    (  l2_hip_pcs_rx_data                                       ) ,
        .l3_hip_aib_rx_data                                    (  l3_hip_aib_rx_data                                       ) ,
        .l3_hip_pcs_rx_data                                    (  l3_hip_pcs_rx_data                                       ) ,
        .l4_hip_aib_rx_data                                    (  l4_hip_aib_rx_data                                       ) ,
        .l4_hip_pcs_rx_data                                    (  l4_hip_pcs_rx_data                                       ) ,
        .l5_hip_aib_rx_data                                    (  l5_hip_aib_rx_data                                       ) ,
        .l5_hip_pcs_rx_data                                    (  l5_hip_pcs_rx_data                                       ) ,
        .l6_hip_aib_rx_data                                    (  l6_hip_aib_rx_data                                       ) ,
        .l6_hip_pcs_rx_data                                    (  l6_hip_pcs_rx_data                                       ) ,
        .l7_hip_aib_rx_data                                    (  l7_hip_aib_rx_data                                       ) ,
        .l7_hip_pcs_rx_data                                    (  l7_hip_pcs_rx_data                                       ) ,
        .l8_hip_aib_rx_data                                    (  l8_hip_aib_rx_data                                       ) ,
        .l8_hip_pcs_rx_data                                    (  l8_hip_pcs_rx_data                                       ) ,
        .l9_hip_aib_rx_data                                    (  l9_hip_aib_rx_data                                       ) ,
        .l9_hip_pcs_rx_data                                    (  l9_hip_pcs_rx_data                                       ) ,
        .mask_tx_pll_lock                                      (  mask_tx_pll_lock                                         ) ,
        .pclk_ch                                               (  pclk_ch                                                  ) ,
        .pin_perst_n                                           (  pin_perst                                                ) ,
        .pld_clrhip_n                                          (  ch2_hip_aib_fsr_in[0]                                    ) ,
        .pld_clrpcsrx_n                                        (  ch1_hip_aib_fsr_in[1]                                    ) ,
        .pld_clrpcstx_n                                        (  ch1_hip_aib_fsr_in[0]                                    ) ,
        .pld_clrpmarx_n                                        (  ch3_hip_aib_fsr_in[1]                                    ) ,
        .pld_clrpmatx_n                                        (  ch1_hip_aib_fsr_in[2]                                    ) ,
        .pld_core_ready                                        (  ch0_hip_aib_fsr_in[3]                                    ) ,
        .pld_core_rst_n                                        (  ch2_hip_aib_fsr_in[2]                                    ) ,
        .pld_fom_rdy                                           (  {ch3_hip_aib_ssr_in[35:32],ch2_hip_aib_ssr_in[35:32] ,ch1_hip_aib_ssr_in[35:32] ,ch0_hip_aib_ssr_in[35:32] }               ) ,
        .pld_fomfeedback                                       (  {ch3_hip_aib_ssr_in[31:0],ch2_hip_aib_ssr_in[31:0] ,ch1_hip_aib_ssr_in[31:0] ,ch0_hip_aib_ssr_in[31:0]     }               ) ,
        .pld_gp_status                                         (  ch5_hip_aib_sync_data_in[40:33]                          ) ,
        .pld_hip_reserved_in                                   (  {ch5_hip_aib_sync_data_in[48:45] ,ch3_hip_aib_sync_data_in[77:72] , ch2_hip_aib_sync_data_in[72],ch1_hip_aib_sync_data_in[76:72],ch7_hip_aib_sync_data_in[15:0] }                          ) ,
        .pld_hip_rsvd_ssr_in                                   (  ch4_hip_aib_ssr_in[3:0]                                  ) ,
        .pld_ltssm_en                                          (  ch0_hip_aib_ssr_in[36]                                   ) ,
        .pld_non_sticky_rst_n                                  (  ch3_hip_aib_fsr_in[0]                                    ) ,
        .pld_perst_n                                           (  ch0_hip_aib_fsr_in[0]                                    ) ,
        .pld_pld_rst_n                                         (  ch0_hip_aib_fsr_in[1]                                    ) ,
        .pld_pwr_rst_n                                         (  ch0_hip_aib_fsr_in[2]                                    ) ,
        .pld_sticky_rst_n                                      (  ch2_hip_aib_fsr_in[1]                                    ) ,
        .pld_warm_rst_rdy                                      (  ch1_hip_aib_fsr_in[3]                                    ) ,
        .pll_cal_done                                          (  pll_cal_done                                             ) ,
        .pll_fixed_clk_ch                                      (  pll_fixed_clk_ch                                         ) ,
        .rx_cpl_buffer_limit                                   (  ch4_hip_aib_sync_data_in[23:14]                          ) ,
        .rx_np_buffer_limit                                    (  ch4_hip_aib_sync_data_in[13:7]                           ) ,
        .rx_p_buffer_limit                                     (  ch4_hip_aib_sync_data_in[6:0]                            ) ,
        .rx_pll_freq_lock                                      (  rx_pll_freq_lock                                         ) ,
        .rx_st_ready                                           (  ch5_hip_aib_sync_data_in[44]                             ) ,
        .rxelecidle                                            (  rxelecidle                                               ) ,
        .sys_atten_button_pressed                              (  ch6_hip_aib_sync_data_in[74]                             ) ,
        .sys_aux_pwr_det                                       (  ch6_hip_aib_sync_data_in[75]                             ) ,
        .sys_cmd_cpled_int                                     (  ch6_hip_aib_sync_data_in[68]                             ) ,
        .sys_eml_interlock_engaged                             (  ch6_hip_aib_sync_data_in[67]                             ) ,
        .sys_mrl_sensor_chged                                  (  ch6_hip_aib_sync_data_in[70]                             ) ,
        .sys_mrl_sensor_state                                  (  ch6_hip_aib_sync_data_in[72]                             ) ,
        .sys_pre_det_chged                                     (  ch6_hip_aib_sync_data_in[69]                             ) ,
        .sys_pre_det_state                                     (  ch6_hip_aib_sync_data_in[73]                             ) ,
        .sys_pwr_fault_det                                     (  ch6_hip_aib_sync_data_in[71]                             ) ,
        .test_in                                               (  {ch11_hip_aib_sync_data_in[15:0] ,ch10_hip_aib_sync_data_in[15:0] ,ch9_hip_aib_sync_data_in[15:0] ,ch8_hip_aib_sync_data_in[15:0] } ) ,
        .tx_lcff_pll_lock                                      (  tx_lcff_pll_lock                                         ) ,
        .tx_st_data                                            (  {ch3_hip_aib_sync_data_in[63:0] ,ch2_hip_aib_sync_data_in[63:0] ,ch1_hip_aib_sync_data_in[63:0] ,ch0_hip_aib_sync_data_in[63:0] }   ) ,
        .tx_st_eop                                             (  ch0_hip_aib_sync_data_in[73]                             ) ,
        .tx_st_err                                             (  ch0_hip_aib_sync_data_in[75]                             ) ,
        .tx_st_parity                                          (  {ch3_hip_aib_sync_data_in[71:64] ,ch2_hip_aib_sync_data_in[71:64] ,ch1_hip_aib_sync_data_in[71:64] ,ch0_hip_aib_sync_data_in[71:64] }  ) ,
        .tx_st_sop                                             (  ch0_hip_aib_sync_data_in[72]                             ) ,
        .tx_st_valid                                           (  ch0_hip_aib_sync_data_in[74]                             ) ,
        .tx_st_vf_active                                       (  ch0_hip_aib_sync_data_in[76]                             ) ,
        .user_avmm_addr                                        (  hip_avmm_reg_addr                                        ) ,
        .user_avmm_clk                                         (  hip_aib_avmm_clk                                         ) ,
        .user_avmm_read                                        (  hip_avmm_read                                            ) ,
        .user_avmm_write                                       (  hip_avmm_write                                           ) ,
        .user_avmm_writedata                                   (  hip_avmm_writedata                                       ) ,
        .user_avmm_rst_n                                       (  ch3_hip_aib_fsr_in[2]                                    ) ,
// synthesis translate_off
        .config_avmm_clk                                       (  clk125_out                                               )   ,
        .config_avmm_rst_n                                     (  config_avmm_rst_n                                        )   ,
        .iocsr_rdy_dly                                         (  iocsr_rdy_dly                                            )   ,
        .global_pipe_se                                        (  ONES[0]                                                  )   ,
        .user_mode                                             (  ONES[0]                                                  )   ,
        .bistmode_n                                            (  ONES[0]                                                  )   ,
        .config_avmm_addr                                      (  ONES[0]                                                  )   ,
        .config_avmm_byte_en                                   (  ONES[0]                                                  )   ,
        .config_avmm_read                                      (  ZEROS[0]                                                 )   ,
        .config_avmm_write                                     (  ZEROS[0]                                                 )   ,
        .config_avmm_writedata                                 (  ONES[0]                                                  )   ,
        .cvp_hip_avmm_wait                                     (  ZEROS[0]                                                 )   ,
        .cvp_en                                                (  ZEROS[0]                                                 )   ,
        .scan_clk0                                             (  ONES[0]                                                  )   ,
        .scan_clk1                                             (  ONES[0]                                                  )   ,
        .scan_clk2                                             (  ONES[0]                                                  )   ,
        .scan_mode_n                                           (  ONES[0]                                                  )   ,
        .scan_rst_n                                            (  ONES[0]                                                  )   ,
        .scan_shift_n                                          (  ONES[0]                                                  )   ,
        .occ_clk250                                            (  ONES[0]                                                  )   ,
        .occ_clk500                                            (  ONES[0]                                                  )   ,
        .occ_clk_sel_n                                         (  ONES[0]                                                  )   ,
        .occ_enable                                            (  ONES[0]                                                  )   ,
        .LV_CaptureWR                                          (  ZEROS[0]                                                 )   ,
        .LV_EnableWR                                           (  ZEROS[0]                                                 )   ,
        .LV_SelectWIR                                          (  ZEROS[0]                                                 )   ,
        .LV_ShiftWR                                            (  ZEROS[0]                                                 )   ,
        .LV_TM                                                 (  ZEROS[0]                                                 )   ,
        .LV_UpdateWR                                           (  ZEROS[0]                                                 )   ,
        .LV_WRCK                                               (  ZEROS[0]                                                 )   ,
        .LV_WRSTN                                              (  ZEROS[0]                                                 )   ,
        .LV_WSI                                                (  ZEROS[0]                                                 )   ,

         // synthesis translate_on


//Outputs
        .app_msi_ack                                           (  ch2_hip_aib_sync_data_out[54]                           ) ,
        .aux_test_out                                          (  hip_aux_test_out                                        ) ,
        .ceb_addr                                              (  ch3_hip_aib_sync_data_out[63:32]                        ) ,
        .ceb_dout                                              (  ch3_hip_aib_sync_data_out[31:0]                         ) ,
        .ceb_func_num                                          (  ch3_hip_aib_sync_data_out[76]                           ) , //Unused
        .ceb_req                                               (  ch3_hip_aib_sync_data_out[77]                           ) ,
        .ceb_vf_active                                         (  ch3_hip_aib_sync_data_out[75]                           ) , //Unused
        .ceb_vf_num                                            (  ch3_hip_aib_sync_data_out[74:68]                        ) , //Unused
        .ceb_wr                                                (  ch3_hip_aib_sync_data_out[67:64]                        ) ,
        .config_avmm_readdata                                  (                                                          ) , //Unused
        .config_avmm_readdatavalid                             (                                                          ) , //Unused
        .config_avmm_waitrequest                               (                                                          ) , //Unused
        .core_clk_out                                          (  hip_core_clk_out                                        ) , //Unused
        .cvp_hip_avmm_clk                                      (                                                          ) , //Unused
        .cvp_hip_avmm_rst_n                                    (                                                          ) , //Unused
        .cvp_hip_avmm_rst_req                                  (                                                          ) , //Unused
        .cvp_hip_avmm_write                                    (                                                          ) , //Unused
        .cvp_hip_avmm_writedata                                (                                                          ) , //Unused
        .cvp_hip_interrupt_out                                 (                                                          ) , //Unused
        .flr_pf_active                                         (  ch2_hip_aib_sync_data_out[74:73]                        ) , //Unused
        .flr_vf_active                                         (  ch2_hip_aib_sync_data_out[72:65]                        ) , //Unused
        .flr_vf_active_tdm                                     (  ch2_hip_aib_sync_data_out[64:61]                        ) ,
        .hip_ready_n                                           (  ch0_hip_aib_fsr_out[0]                                  ) ,
        .int_status_common                                     (  ch1_hip_aib_sync_data_out[26:24]                        ) ,
        .int_status_pf0                                        (  ch1_hip_aib_sync_data_out[23:16]                        ) ,
        .int_status_pf1                                        (  ch1_hip_aib_sync_data_out[15:8]                         ) , //Unused
        .k_legacy_eq_mode_en                                   (                  ) ,
        .l0_hip_aib_tx_data                                    (  l0_hip_aib_tx_data                                      ) , //Map
        .l0_hip_pcs_tx_async                                   (  l0_hip_pcs_tx_async                                     ) ,
        .l0_hip_pcs_tx_data                                    (  l0_hip_pcs_tx_data                                      ) ,
        .l10_hip_aib_tx_data                                   (  l10_hip_aib_tx_data                                     ) , //Map
        .l10_hip_pcs_tx_async                                  (  l10_hip_pcs_tx_async                                    ) ,
        .l10_hip_pcs_tx_data                                   (  l10_hip_pcs_tx_data                                     ) ,
        .l11_hip_aib_tx_data                                   (  l11_hip_aib_tx_data                                     ) , //Map
        .l11_hip_pcs_tx_async                                  (  l11_hip_pcs_tx_async                                    ) ,
        .l11_hip_pcs_tx_data                                   (  l11_hip_pcs_tx_data                                     ) ,
        .l12_hip_aib_tx_data                                   (  l12_hip_aib_tx_data                                     ) , //Map
        .l12_hip_pcs_tx_async                                  (  l12_hip_pcs_tx_async                                    ) ,
        .l12_hip_pcs_tx_data                                   (  l12_hip_pcs_tx_data                                     ) ,
        .l13_hip_aib_tx_data                                   (  l13_hip_aib_tx_data                                     ) , //Map
        .l13_hip_pcs_tx_async                                  (  l13_hip_pcs_tx_async                                    ) ,
        .l13_hip_pcs_tx_data                                   (  l13_hip_pcs_tx_data                                     ) ,
        .l14_hip_aib_tx_data                                   (  l14_hip_aib_tx_data                                     ) , //Map
        .l14_hip_pcs_tx_async                                  (  l14_hip_pcs_tx_async                                    ) ,
        .l14_hip_pcs_tx_data                                   (  l14_hip_pcs_tx_data                                     ) ,
        .l15_hip_aib_tx_data                                   (  l15_hip_aib_tx_data                                     ) , //Map
        .l15_hip_pcs_tx_async                                  (  l15_hip_pcs_tx_async                                    ) ,
        .l15_hip_pcs_tx_data                                   (  l15_hip_pcs_tx_data                                     ) ,
        .l1_hip_aib_tx_data                                    (  l1_hip_aib_tx_data                                      ) , //Map
        .l1_hip_pcs_tx_async                                   (  l1_hip_pcs_tx_async                                     ) ,
        .l1_hip_pcs_tx_data                                    (  l1_hip_pcs_tx_data                                      ) ,
        .l2_hip_aib_tx_data                                    (  l2_hip_aib_tx_data                                      ) , //Map
        .l2_hip_pcs_tx_async                                   (  l2_hip_pcs_tx_async                                     ) ,
        .l2_hip_pcs_tx_data                                    (  l2_hip_pcs_tx_data                                      ) ,
        .l3_hip_aib_tx_data                                    (  l3_hip_aib_tx_data                                      ) , //Map
        .l3_hip_pcs_tx_async                                   (  l3_hip_pcs_tx_async                                     ) ,
        .l3_hip_pcs_tx_data                                    (  l3_hip_pcs_tx_data                                      ) ,
        .l4_hip_aib_tx_data                                    (  l4_hip_aib_tx_data                                      ) , //Map
        .l4_hip_pcs_tx_async                                   (  l4_hip_pcs_tx_async                                     ) ,
        .l4_hip_pcs_tx_data                                    (  l4_hip_pcs_tx_data                                      ) ,
        .l5_hip_aib_tx_data                                    (  l5_hip_aib_tx_data                                      ) , //Map
        .l5_hip_pcs_tx_async                                   (  l5_hip_pcs_tx_async                                     ) ,
        .l5_hip_pcs_tx_data                                    (  l5_hip_pcs_tx_data                                      ) ,
        .l6_hip_aib_tx_data                                    (  l6_hip_aib_tx_data                                      ) , //Map
        .l6_hip_pcs_tx_async                                   (  l6_hip_pcs_tx_async                                     ) ,
        .l6_hip_pcs_tx_data                                    (  l6_hip_pcs_tx_data                                      ) ,
        .l7_hip_aib_tx_data                                    (  l7_hip_aib_tx_data                                      ) , //Map
        .l7_hip_pcs_tx_async                                   (  l7_hip_pcs_tx_async                                     ) ,
        .l7_hip_pcs_tx_data                                    (  l7_hip_pcs_tx_data                                      ) ,
        .l8_hip_aib_tx_data                                    (  l8_hip_aib_tx_data                                      ) , //Map
        .l8_hip_pcs_tx_async                                   (  l8_hip_pcs_tx_async                                     ) ,
        .l8_hip_pcs_tx_data                                    (  l8_hip_pcs_tx_data                                      ) ,
        .l9_hip_aib_tx_data                                    (  l9_hip_aib_tx_data                                      ) , //Map
        .l9_hip_pcs_tx_async                                   (  l9_hip_pcs_tx_async                                     ) ,
        .l9_hip_pcs_tx_data                                    (  l9_hip_pcs_tx_data                                      ) ,
        .link_req_rst_n                                        (  ch0_hip_aib_fsr_out[1]                                  ) ,
        .link_up                                               (  ch2_hip_aib_sync_data_out[77]                           ) ,
        .ltssm_state                                           (  ch2_hip_aib_sync_data_out[60:55]                        ) ,
        .LV_AuxEn                                              (                                                          ) , //Unused
        .LV_AuxOut                                             (                                                          ) , //Unused
        .LV_WSO                                                (                                                          ) , //Unused
        .pld_clk_out                                           (  hip_pld_clk_out                                         ) ,
        .pld_clk_out_2x                                        (  hip_pld_clk_out_2x                                      ) , //Unused
        .pld_gp_ctrl                                           (  ch1_hip_aib_sync_data_out[7:0]                          ) ,
        .pld_hip_reserved_out                                  (  {ch7_hip_aib_sync_data_out[77] ,ch6_hip_aib_sync_data_out[77] ,ch5_hip_aib_sync_data_out[77] ,ch7_hip_aib_sync_data_out[76:75] ,ch0_hip_aib_sync_data_out[77:70] ,ch1_hip_aib_sync_data_out[77:60] }) , //Unused
        .pld_hip_rsvd_ssr_out                                  (  ch4_hip_aib_ssr_out[3:0]                                ) , //Unused
        .pld_in_use                                            (  ch0_hip_aib_fsr_out[2]                                  ) ,
        .pld_rxeqeval                                          (  {ch3_hip_aib_ssr_out[3:0] ,ch2_hip_aib_ssr_out[3:0] ,ch1_hip_aib_ssr_out[3:0] ,ch0_hip_aib_ssr_out[3:0] }                          ) , //Unused
        .pm_dstate_0                                           (  ch2_hip_aib_sync_data_out[44:42]                        ) ,
        .pm_dstate_1                                           (  ch2_hip_aib_sync_data_out[47:45]                        ) ,
        .pm_linkst_in_l0s                                      (  ch2_hip_aib_sync_data_out[41]                           ) ,
        .pm_linkst_in_l1                                       (  ch2_hip_aib_sync_data_out[40]                           ) ,
        .pm_linkst_in_l2                                       (  ch2_hip_aib_sync_data_out[39]                           ) ,
        .pm_linkst_l2_exit                                     (  ch2_hip_aib_sync_data_out[53]                           ) ,
        .pm_pme_en                                             (  ch0_hip_aib_sync_data_out[69:68]                        ) ,
        .pm_state                                              (  ch2_hip_aib_sync_data_out[50:48]                        ) ,
        .pm_status                                             (  ch2_hip_aib_sync_data_out[52:51]                        ) ,
        .retry_corr_ecc_err                                    (  ch5_hip_aib_fsr_out[3]                                  ) ,
        .retry_unc_ecc_err                                     (  ch5_hip_aib_fsr_out[2]                                  ) ,
        .rx_pcs_rst_n                                          (  rx_pcs_rst_n                                            ) ,
        .rx_pma_rstb                                           (  rx_pma_rstb                                             ) ,
        .rx_st_bar_range                                       (  ch6_hip_aib_sync_data_out[76:74]                        ) ,
        .rx_st_data                                            (  {ch7_hip_aib_sync_data_out[63:0] ,ch6_hip_aib_sync_data_out[63:0] ,ch5_hip_aib_sync_data_out[63:0], ch4_hip_aib_sync_data_out[63:0] }  ) ,
        .rx_st_empty                                           (  ch7_hip_aib_sync_data_out[74:72]                        ) ,
        .rx_st_eop                                             (  ch4_hip_aib_sync_data_out[73]                           ) ,
        .rx_st_func_num                                        (  ch4_hip_aib_sync_data_out[77]                           ) , //Unused
        .rx_st_par_err                                         (  ch4_hip_aib_sync_data_out[75]                           ) ,
        .rx_st_parity                                          (  {ch7_hip_aib_sync_data_out[71:64] ,ch6_hip_aib_sync_data_out[71:64] ,ch5_hip_aib_sync_data_out[71:64] ,ch4_hip_aib_sync_data_out[71:64] } ) ,
        .rx_st_sop                                             (  ch4_hip_aib_sync_data_out[72]                           ) ,
        .rx_st_valid                                           (  ch4_hip_aib_sync_data_out[74]                           ) ,
        .rx_st_vf_active                                       (  ch4_hip_aib_sync_data_out[76]                           ) , //Unused
        .rx_st_vf_num                                          (  {ch6_hip_aib_sync_data_out[73:72] ,ch5_hip_aib_sync_data_out[76:72] }    ) , //Unused
        .rxbuff_corr_ecc_err                                   (  ch6_hip_aib_fsr_out[3]                                  ) ,
        .rxbuff_unc_ecc_err                                    (  ch6_hip_aib_fsr_out[2]                                  ) ,
        .serr_out                                              (  ch2_hip_aib_sync_data_out[76:75]                        ) ,
        .sriov_test_out                                        (  ch1_hip_aib_sync_data_out[59:27]                        ) , //Unused
        .test_out                                              (  {ch15_hip_aib_sync_data_out[31:0] ,ch14_hip_aib_sync_data_out[31:0] ,ch13_hip_aib_sync_data_out[31:0] ,ch12_hip_aib_sync_data_out[31:0] ,ch11_hip_aib_sync_data_out[31:0] ,ch10_hip_aib_sync_data_out[31:0] ,ch9_hip_aib_sync_data_out[31:0] ,ch8_hip_aib_sync_data_out[31:0] }   ) ,
        .tl_cfg_add                                            (  ch2_hip_aib_sync_data_out[36:32]                        ) ,
        .tl_cfg_ctl                                            (  ch2_hip_aib_sync_data_out[31:0]                         ) ,
        .tl_cfg_func                                           (  ch2_hip_aib_sync_data_out[38:37]                        ) ,
        .tx_cdts_data_value                                    (  ch0_hip_aib_sync_data_out[63:62]                        ) ,
        .tx_cdts_type                                          (  ch0_hip_aib_sync_data_out[61:60]                        ) ,
        .tx_cpld_cdts                                          (  ch0_hip_aib_sync_data_out[59:48]                        ) ,
        .tx_cplh_cdts                                          (  ch0_hip_aib_sync_data_out[47:40]                        ) ,
        .tx_data_cdts_consumed                                 (  ch0_hip_aib_sync_data_out[65]                           ) ,
        .tx_hdr_cdts_consumed                                  (  ch0_hip_aib_sync_data_out[64]                           ) ,
        .tx_lcff_pll_rstb                                      (  tx_lcff_pll_rstb                                        ) ,
        .tx_npd_cdts                                           (  ch0_hip_aib_sync_data_out[39:28]                        ) ,
        .tx_nph_cdts                                           (  ch0_hip_aib_sync_data_out[27:20]                        ) ,
        .tx_pcs_rst_n                                          (  tx_pcs_rst_n                                            ) ,
        .tx_pd_cdts                                            (  ch0_hip_aib_sync_data_out[19:8]                         ) ,
        .tx_ph_cdts                                            (  ch0_hip_aib_sync_data_out[7:0]                          ) ,
        .tx_pma_rstb                                           (  tx_pma_rstb                                             ) ,
        .tx_st_par_err                                         (  ch0_hip_aib_sync_data_out[66]                           ) ,
        .tx_st_ready                                           (  ch0_hip_aib_sync_data_out[67]                           ) ,
        .txeq_clk_out                                          (  txeq_clk_out                                            ) ,
        .user_avmm_readdata                                    (  hip_avmm_readdata                                       ) ,
        .user_avmm_readdatavalid                               (  hip_avmm_readdatavalid                                  ) ,
        .user_avmm_writedone                                   (  hip_avmm_writedone                                      ) ,
        .user_mode_del                                         (  ch0_hip_aib_fsr_out[3]                                  )  //Unused

        );



//AIB/PHY Signal Bus
    //Tie Off unused FSR and HSR - HIP to AIB Signals
    assign   ch1_hip_aib_fsr_out[3:0] = 'h0;
    assign   ch2_hip_aib_fsr_out[3:0] = 'h0;
    assign   ch3_hip_aib_fsr_out[3:0] = 'h0;
    assign   ch4_hip_aib_fsr_out[3:0] = 'h0;
    assign   ch5_hip_aib_fsr_out[1:0] = 'h0;
    assign   ch5_hip_aib_ssr_out[3:0] = 'h0;

    assign   ch6_hip_aib_fsr_out[1:0] = 'h0;
    assign   ch6_hip_aib_ssr_out[3:0] = 'h0;

    assign   ch7_hip_aib_fsr_out[3:0] = 'h0;
    assign   ch7_hip_aib_ssr_out[3:0] = 'h0;

    assign   ch8_hip_aib_fsr_out[3:0] = 'h0;
    assign   ch8_hip_aib_ssr_out[3:0] = 'h0;
    assign   ch8_hip_aib_sync_data_out[77:32] = 'h0;

    assign   ch9_hip_aib_fsr_out[3:0] = 'h0;
    assign   ch9_hip_aib_ssr_out[3:0] = 'h0;
    assign   ch9_hip_aib_sync_data_out[77:32] = 'h0;

    assign   ch10_hip_aib_fsr_out[3:0] = 'h0;
    assign   ch10_hip_aib_ssr_out[3:0] = 'h0;
    assign   ch10_hip_aib_sync_data_out[77:32] = 'h0;

    assign   ch11_hip_aib_fsr_out[3:0] = 'h0;
    assign   ch11_hip_aib_ssr_out[3:0] = 'h0;
    assign   ch11_hip_aib_sync_data_out[77:32] = 'h0;

    assign   ch12_hip_aib_fsr_out[3:0] = 'h0;
    assign   ch12_hip_aib_ssr_out[3:0] = 'h0;
    assign   ch12_hip_aib_sync_data_out[77:32] = 'h0;

    assign   ch13_hip_aib_fsr_out[3:0] = 'h0;
    assign   ch13_hip_aib_ssr_out[3:0] = 'h0;
    assign   ch13_hip_aib_sync_data_out[77:32] = 'h0;

    assign   ch14_hip_aib_fsr_out[3:0] = 'h0;
    assign   ch14_hip_aib_ssr_out[3:0] = 'h0;
    assign   ch14_hip_aib_sync_data_out[77:32] = 'h0;

    assign   ch15_hip_aib_fsr_out[3:0] = 'h0;
    assign   ch15_hip_aib_ssr_out[3:0] = 'h0;
    assign   ch15_hip_aib_sync_data_out[77:32] = 'h0;


//FSR Inputs from PLD AIB to HIP
   assign   ch0_pld_aib_fsr_in[0]     =  ZEROS[0]                    ;           //   pld_perst_n
   assign   ch0_pld_aib_fsr_in[1]     =  ZEROS[0]                    ;           //   pld_pld_rst_n
   assign   ch0_pld_aib_fsr_in[2]     =  ZEROS[0]                    ;           //   pld_pwr_rst_n
   assign   ch0_pld_aib_fsr_in[3]     =  pld_core_ready              ;           //   pld_core_ready
   assign   ch1_pld_aib_fsr_in[0]     =  ZEROS[0]                    ;           //   pld_clrpcstx_n
   assign   ch1_pld_aib_fsr_in[1]     =  ZEROS[0]                    ;           //   pld_clrpcsrx_n
   assign   ch1_pld_aib_fsr_in[2]     =  ZEROS[0]                    ;           //   pld_clrpmatx_n
   assign   ch1_pld_aib_fsr_in[3]     =  pld_warm_rst_rdy            ;           //   pld_warm_rst_rdy
   assign   ch2_pld_aib_fsr_in[0]     =  npor                        ;           //   pld_clrhip_n
   assign   ch2_pld_aib_fsr_in[1]     =  ZEROS[0]                    ;           //   pld_sticky_rst_n
   assign   ch2_pld_aib_fsr_in[2]     =  ZEROS[0]                    ;           //   pld_core_rst_n
   assign   ch2_pld_aib_fsr_in[3]     =  ZEROS[0]                    ;           //   unused
   assign   ch3_pld_aib_fsr_in[0]     =  ZEROS[0]                    ;           //   pld_non_sticky_rst_n
   assign   ch3_pld_aib_fsr_in[1]     =  ZEROS[0]                    ;           //   pld_clrpmarx_n
   assign   ch3_pld_aib_fsr_in[2]     =  user_avmm_rst_n             ;           //   user_avmm_rst_n
   assign   ch3_pld_aib_fsr_in[3]     =  ZEROS[0]                    ;           //   Unused
   assign   ch4_pld_aib_fsr_in[3:0]   =  ZEROS[3:0]                  ;           //   Unused
   assign   ch5_pld_aib_fsr_in[3:0]   =  ZEROS[3:0]                  ;           //   Unused
   assign   ch6_pld_aib_fsr_in[3:0]   =  ZEROS[3:0]                  ;           //   Unused
   assign   ch7_pld_aib_fsr_in[3:0]   =  ZEROS[3:0]                  ;           //   Unused
   assign   ch8_pld_aib_fsr_in[3:0]   =  ZEROS[3:0]                  ;           //   Unused
   assign   ch9_pld_aib_fsr_in[3:0]   =  ZEROS[3:0]                  ;           //   Unused
   assign   ch10_pld_aib_fsr_in[3:0]   =  ZEROS[3:0]                 ;           //   Unused
   assign   ch11_pld_aib_fsr_in[3:0]   =  ZEROS[3:0]                 ;           //   Unused
   assign   ch12_pld_aib_fsr_in[3:0]   =  ZEROS[3:0]                 ;           //   Unused
   assign   ch13_pld_aib_fsr_in[3:0]   =  ZEROS[3:0]                 ;           //   Unused
   assign   ch14_pld_aib_fsr_in[3:0]   =  ZEROS[3:0]                 ;           //   Unused
   assign   ch15_pld_aib_fsr_in[3:0]   =  ZEROS[3:0]                 ;           //   Unused



//SSR Inputs from PLD AIB to HIP
   assign   ch0_pld_aib_ssr_in[31:0]   =   ZEROS[31:0]               ;            //  pld_fomfeedback
   assign   ch0_pld_aib_ssr_in[35:32]  =   ZEROS[3:0]                ;            //  pld_fom_rdy
   assign   ch0_pld_aib_ssr_in[36]     =   ONES[0]                   ;            //  pld_ltssm_en
   assign   ch0_pld_aib_ssr_in[39:37]  =   ZEROS[2:0]                ;            //  Unused
   assign   ch1_pld_aib_ssr_in[31:0]   =   ZEROS[31:0]               ;            //  pld_fomfeedback
   assign   ch1_pld_aib_ssr_in[35:32]  =   ZEROS[3:0]                ;            //  pld_fom_rdy
   assign   ch1_pld_aib_ssr_in[39:36]  =   ZEROS[3:0]                ;            //  Unused
   assign   ch2_pld_aib_ssr_in[31:0]   =   ZEROS[31:0]               ;            //  pld_fomfeedback
   assign   ch2_pld_aib_ssr_in[35:32]  =   ZEROS[3:0]                ;            //  pld_fom_rdy
   assign   ch2_pld_aib_ssr_in[39:36]  =   ZEROS[3:0]                ;            //  Unused
   assign   ch3_pld_aib_ssr_in[31:0]   =   ZEROS[31:0]               ;            //  pld_fomfeedback
   assign   ch3_pld_aib_ssr_in[35:32]  =   ZEROS[3:0]                ;            //  pld_fom_rdy
   assign   ch3_pld_aib_ssr_in[39:36]  =   ZEROS[3:0]                ;            //  Unused
   assign   ch4_pld_aib_ssr_in[3:0]    =   ZEROS[3:0]                ;            //  pld_hip_rsvd_ssr_in
   assign   ch4_pld_aib_ssr_in[39:4]   =  ZEROS[35:0]                ;           //   Unused
   assign   ch5_pld_aib_ssr_in[39:0]   =  ZEROS[39:0]                ;           //   Unused
   assign   ch6_pld_aib_ssr_in[39:0]   =  ZEROS[39:0]                ;           //   Unused
   assign   ch7_pld_aib_ssr_in[39:0]   =  ZEROS[39:0]                ;           //   Unused
   assign   ch8_pld_aib_ssr_in[39:0]   =  ZEROS[39:0]                ;           //   Unused
   assign   ch9_pld_aib_ssr_in[39:0]   =  ZEROS[39:0]                ;           //   Unused
   assign   ch10_pld_aib_ssr_in[39:0]   =  ZEROS[39:0]               ;           //   Unused
   assign   ch11_pld_aib_ssr_in[39:0]   =  ZEROS[39:0]               ;           //   Unused
   assign   ch12_pld_aib_ssr_in[39:0]   =  ZEROS[39:0]               ;           //   Unused
   assign   ch13_pld_aib_ssr_in[39:0]   =  ZEROS[39:0]               ;           //   Unused
   assign   ch14_pld_aib_ssr_in[39:0]   =  ZEROS[39:0]               ;           //   Unused
   assign   ch15_pld_aib_ssr_in[39:0]   =  ZEROS[39:0]               ;           //   Unused

//FSR Outputs from HIP to PLD
   assign   hip_ready_n_hip            =   ch0_pld_aib_fsr_out[0]    ;
   assign   link_req_rst_n             =   ch0_pld_aib_fsr_out[1]    ;
   assign   pld_in_use_hip             =   ch0_pld_aib_fsr_out[2]    ;
   assign   derr_cor_ext_rpl           =   ch5_pld_aib_fsr_out[3]    ;
   assign   derr_rpl                   =   ch5_pld_aib_fsr_out[2]    ;
   assign   derr_cor_ext_rcv           =   ch6_pld_aib_fsr_out[3]    ;
   assign   derr_uncor_ext_rcv         =   ch6_pld_aib_fsr_out[2]    ;

//Unused Outputs From HIP to PLD
////SSR Outputs from HIP to PLD
//   assign   pld_rxeqeval               =   {ch3_pld_aib_ssr_out[3:0] ,ch2_pld_aib_ssr_out[3:0] ,ch1_pld_aib_ssr_out[3:0] ,ch0_pld_aib_ssr_out[3:0] } ;
//   assign   pld_hip_rsvd_ssr_out       =   ch4_pld_aib_ssr_out[3:0]  ;
////FSR Outputs from HIP to PLD
//   assign   user_mode_del              =   ch0_pld_aib_fsr_out[3]    ;



//PLLnPHY
   assign coreclkout_hip               =     pllnphy_tx_clkout[0] ;
//AIB to Core Inteface
   // TX data Path Mapping
   assign  ch0_tx_parallel_data[63:0]            =    tx_st_data_undsk[63:0]                                ;// ch3_hip_aib_sync_data_in[63:0] ,ch2_hip_aib_sync_data_in[63:0] ,ch1_hip_aib_sync_data_in[63:0] ,ch0_hip_aib_sync_data_in[63:0] }   ) ,
   assign  ch0_tx_parallel_data[71:64]           =    tx_st_parity_undsk[7:0]                               ;// ch3_hip_aib_sync_data_in[71:64] ,ch2_hip_aib_sync_data_in[71:64] ,ch1_hip_aib_sync_data_in[71:64] ,ch0_hip_aib_sync_data_in[71:64] }  ) ,
   assign  ch0_tx_parallel_data[72]              =    tx_st_sop_undsk                                       ;// ch0_hip_aib_sync_data_in[72]                             ) ,
   assign  ch0_tx_parallel_data[73]              =    tx_st_eop_undsk                                       ;// ch0_hip_aib_sync_data_in[73]                             ) ,
   assign  ch0_tx_parallel_data[74]              =    tx_st_valid_undsk                                     ;// ch0_hip_aib_sync_data_in[74]                             ) ,
   assign  ch0_tx_parallel_data[75]              =    tx_st_err_undsk                                       ;// ch0_hip_aib_sync_data_in[75]                             ) ,
   assign  ch0_tx_parallel_data[76]              =    tx_st_vf_active_undsk                                 ;// ch0_hip_aib_sync_data_in[76]                             ) ,
   assign  ch0_tx_parallel_data[77]              =    ZEROS[0]                                              ;


   assign  ch1_tx_parallel_data[63:0]            =    tx_st_data_undsk[127:64]                              ;// ch3_hip_aib_sync_data_in[63:0] ,ch2_hip_aib_sync_data_in[63:0] ,ch1_hip_aib_sync_data_in[63:0] ,ch0_hip_aib_sync_data_in[63:0] }   ) ,
   assign  ch1_tx_parallel_data[71:64]           =    tx_st_parity_undsk[15:8]                              ;// ch3_hip_aib_sync_data_in[71:64] ,ch2_hip_aib_sync_data_in[71:64] ,ch1_hip_aib_sync_data_in[71:64] ,ch0_hip_aib_sync_data_in[71:64] }  ) ,
   assign  ch1_tx_parallel_data[72]              =    tx_st_sop_undsk                                       ;// ch5_hip_aib_sync_data_in[48:45] ,ch3_hip_aib_sync_data_in[77:72] , ch2_hip_aib_sync_data_in[72],ch1_hip_aib_sync_data_in[76:72],ch7_hip_aib_sync_data_in[15:0] }                          ) ,
   assign  ch1_tx_parallel_data[76:73]           =    pld_hip_reserved_in[20:17]                            ;// ch5_hip_aib_sync_data_in[48:45] ,ch3_hip_aib_sync_data_in[77:72] , ch2_hip_aib_sync_data_in[72],ch1_hip_aib_sync_data_in[76:72],ch7_hip_aib_sync_data_in[15:0] }                          ) ,
   assign  ch1_tx_parallel_data[77]              =    ZEROS[0]                                              ;


   assign  ch2_tx_parallel_data[63:0]            =    tx_st_data_undsk[191:128]                             ;// ch3_hip_aib_sync_data_in[63:0] ,ch2_hip_aib_sync_data_in[63:0] ,ch1_hip_aib_sync_data_in[63:0] ,ch0_hip_aib_sync_data_in[63:0] }   ) ,
   assign  ch2_tx_parallel_data[71:64]           =    tx_st_parity_undsk[23:16]                             ;// ch3_hip_aib_sync_data_in[71:64] ,ch2_hip_aib_sync_data_in[71:64] ,ch1_hip_aib_sync_data_in[71:64] ,ch0_hip_aib_sync_data_in[71:64] }  ) ,
   assign  ch2_tx_parallel_data[72]              =    tx_st_sop_undsk                                       ;
   assign  ch2_tx_parallel_data[77:73]           =    ZEROS[4:0]                                            ;


   assign  ch3_tx_parallel_data[63:0]            =    tx_st_data_undsk[255:192]                             ;// ch3_hip_aib_sync_data_in[63:0] ,ch2_hip_aib_sync_data_in[63:0] ,ch1_hip_aib_sync_data_in[63:0] ,ch0_hip_aib_sync_data_in[63:0] }   ) ,
   assign  ch3_tx_parallel_data[71:64]           =    tx_st_parity_undsk[31:24]                             ;// ch3_hip_aib_sync_data_in[71:64] ,ch2_hip_aib_sync_data_in[71:64] ,ch1_hip_aib_sync_data_in[71:64] ,ch0_hip_aib_sync_data_in[71:64] }  ) ,
   assign  ch3_tx_parallel_data[72]              =    tx_st_sop_undsk                                       ;// ch5_hip_aib_sync_data_in[48:45] ,ch3_hip_aib_sync_data_in[77:72] , ch2_hip_aib_sync_data_in[72],ch1_hip_aib_sync_data_in[76:72],ch7_hip_aib_sync_data_in[15:0] }                          ) ,
   assign  ch3_tx_parallel_data[77:73]           =    pld_hip_reserved_in[27:23]                            ;// ch5_hip_aib_sync_data_in[48:45] ,ch3_hip_aib_sync_data_in[77:72] , ch2_hip_aib_sync_data_in[72],ch1_hip_aib_sync_data_in[76:72],ch7_hip_aib_sync_data_in[15:0] }                          ) ,


   assign  ch4_tx_parallel_data[6:0]             =    rx_p_buffer_limit                                     ;// ch4_hip_aib_sync_data_in[6:0]                           ) ,
   assign  ch4_tx_parallel_data[13:7]            =    rx_np_buffer_limit                                    ;// ch4_hip_aib_sync_data_in[13:7]                          ) ,
   assign  ch4_tx_parallel_data[23:14]           =    rx_cpl_buffer_limit                                   ;// ch4_hip_aib_sync_data_in[23:14]                          ) ,
   assign  ch4_tx_parallel_data[25:24]           =    cfg_buffer_limit_byp[2:1]                             ;// ch4_hip_aib_sync_data_in[25:24],ch5_hip_aib_sync_data_in[49] }  ) ,
   assign  ch4_tx_parallel_data[28:26]           =    app_msi_tc                                            ;// ch4_hip_aib_sync_data_in[28:26]                                  ) ,
   assign  ch4_tx_parallel_data[60:29]           =    app_msi_pending[31:0]                                 ;// ch4_hip_aib_sync_data_in[60:29]                                  ) ,
   assign  ch4_tx_parallel_data[61]              =    app_msi_req                                           ;// ch4_hip_aib_sync_data_in[61]                                     ) ,
   assign  ch4_tx_parallel_data[66:62]           =    app_msi_num                                           ;// ch4_hip_aib_sync_data_in[66:62]                                  ) ,
   assign  ch4_tx_parallel_data[67]              =    app_msi_func_num                                      ;// ch4_hip_aib_sync_data_in[67]                                     ) ,
   assign  ch4_tx_parallel_data[68]              =    apps_req_exit_l1                                      ;// ch4_hip_aib_sync_data_in[68]                                     ) , //Input not supported by core
   assign  ch4_tx_parallel_data[69]              =    apps_req_entr_l1                                      ;// ch4_hip_aib_sync_data_in[69]                                     ) , //Input not supported by core
   assign  ch4_tx_parallel_data[70]              =    apps_ready_entr_l23                                   ;// ch4_hip_aib_sync_data_in[70]                                     ) ,
   assign  ch4_tx_parallel_data[71]              =    apps_pm_xmt_pme_1                                     ;// ch4_hip_aib_sync_data_in[71]                                     ) ,
   assign  ch4_tx_parallel_data[72]              =    apps_pm_xmt_pme_0                                     ;// ch4_hip_aib_sync_data_in[72]                                     ) ,
   assign  ch4_tx_parallel_data[73]              =    app_init_rst                                          ;// ch4_hip_aib_sync_data_in[73]                                     ) , //TODO
   assign  ch4_tx_parallel_data[75:74]           =    {app_int_0,app_int_1}                                 ;// ch4_hip_aib_sync_data_in[75:74]                                  ) ,
   assign  ch4_tx_parallel_data[76]              =    app_req_retry_en                                      ;// ch4_hip_aib_sync_data_in[76]                                     ) ,
   assign  ch4_tx_parallel_data[77]              =    app_xfer_pending                                      ;// ch4_hip_aib_sync_data_in[77]                                     ) ,


   assign  ch5_tx_parallel_data[31:0]            =    ceb_din                                               ;// ch5_hip_aib_sync_data_in[31:0]                                   ) ,
   assign  ch5_tx_parallel_data[32]              =    ceb_ack                                               ;// ch5_hip_aib_sync_data_in[32]                                     ) ,
   assign  ch5_tx_parallel_data[40:33]           =    pld_gp_status[7:0]                                    ;// ch5_hip_aib_sync_data_in[40:33]                         ) ,
   assign  ch5_tx_parallel_data[43:41]           =    diag_ctrl_bus                                         ;// ch5_hip_aib_sync_data_in[43:41]                                  ) ,
   assign  ch5_tx_parallel_data[44]              =    rx_st_ready                                           ;// ch5_hip_aib_sync_data_in[44]                            ) ,
   assign  ch5_tx_parallel_data[48:45]           =    pld_hip_reserved_in[31:28]                            ;// ch5_hip_aib_sync_data_in[48:45] ,ch3_hip_aib_sync_data_in[77:72] , ch2_hip_aib_sync_data_in[72],ch1_hip_aib_sync_data_in[76:72],ch7_hip_aib_sync_data_in[15:0] }                          ) ,
   assign  ch5_tx_parallel_data[49]              =    cfg_buffer_limit_byp[0]                               ;// ch4_hip_aib_sync_data_in[25:24],ch5_hip_aib_sync_data_in[49] }  ) ,
   assign  ch5_tx_parallel_data[77:50]           =    ZEROS[27:0]                                           ;


   assign  ch6_tx_parallel_data[31:0]            =    app_err_hdr                                           ;// ch6_hip_aib_sync_data_in[31:0]                                   ) ,
   assign  ch6_tx_parallel_data[42:32]           =    app_err_info[10:0]                                    ; // ch6_hip_aib_sync_data_in[42:32]                                  ) ,
   assign  ch6_tx_parallel_data[49:43]           =    app_err_vfunc_num                                     ;// ch6_hip_aib_sync_data_in[49:43]                                  ) ,
   assign  ch6_tx_parallel_data[50]              =    app_err_func_num                                      ;// ch6_hip_aib_sync_data_in[50]                                     ) ,
   assign  ch6_tx_parallel_data[51]              =    app_err_valid                                         ;// ch6_hip_aib_sync_data_in[51]                                     ) ,
   assign  ch6_tx_parallel_data[52]              =    app_err_vfunc_active                                  ;// ch6_hip_aib_sync_data_in[52]                                     ) ,
   assign  ch6_tx_parallel_data[56:53]           =    flr_vf_done_tdm                                       ;// ch6_hip_aib_sync_data_in[56:53]                                  ) ,
   assign  ch6_tx_parallel_data[64:57]           =    flr_vf_done                                           ;// ch6_hip_aib_sync_data_in[64:57]                                  ) ,
   assign  ch6_tx_parallel_data[66:65]           =    flr_pf_done                                           ;// ch6_hip_aib_sync_data_in[66:65]                                  ) ,
   assign  ch6_tx_parallel_data[67]              =    sys_eml_interlock_engaged                             ;// ch6_hip_aib_sync_data_in[67]                             ) ,
   assign  ch6_tx_parallel_data[68]              =    sys_cmd_cpled_int                                     ;// ch6_hip_aib_sync_data_in[68]                             ) ,
   assign  ch6_tx_parallel_data[69]              =    sys_pre_det_chged                                     ;// ch6_hip_aib_sync_data_in[69]                             ) ,
   assign  ch6_tx_parallel_data[70]              =    sys_mrl_sensor_chged                                  ;// ch6_hip_aib_sync_data_in[70]                             ) ,
   assign  ch6_tx_parallel_data[71]              =    sys_pwr_fault_det                                     ;// ch6_hip_aib_sync_data_in[71]                             ) ,
   assign  ch6_tx_parallel_data[72]              =    sys_mrl_sensor_state                                  ;// ch6_hip_aib_sync_data_in[72]                             ) ,
   assign  ch6_tx_parallel_data[73]              =    sys_pre_det_state                                     ;// ch6_hip_aib_sync_data_in[73]                             ) ,
   assign  ch6_tx_parallel_data[74]              =    sys_atten_button_pressed                              ;// ch6_hip_aib_sync_data_in[74]                             ) ,
   assign  ch6_tx_parallel_data[75]              =    sys_aux_pwr_det                                       ;// ch6_hip_aib_sync_data_in[75]                             ) ,
   assign  ch6_tx_parallel_data[76]              =    apps_pm_xmt_turnoff                                   ;// ch6_hip_aib_sync_data_in[76]                                     ) ,
   assign  ch6_tx_parallel_data[77]              =    ZEROS[0]                                              ;



   assign  ch7_tx_parallel_data[77:16]           =    ZEROS[63:0]                                           ;
   assign  ch7_tx_parallel_data[15:0]            =    pld_hip_reserved_in[15:0]                             ;// ch5_hip_aib_sync_data_in[48:45] ,ch3_hip_aib_sync_data_in[77:72] , ch2_hip_aib_sync_data_in[72],ch1_hip_aib_sync_data_in[76:72],ch7_hip_aib_sync_data_in[15:0] }                          ) ,

   assign  ch8_tx_parallel_data[77:16]           =    ZEROS[63:0]                                           ;
   assign  ch8_tx_parallel_data[15:0]            =    test_in[15:0]                                         ;// ch11_hip_aib_sync_data_in[15:0] ,ch10_hip_aib_sync_data_in[15:0] ,ch9_hip_aib_sync_data_in[15:0] ,ch8_hip_aib_sync_data_in[15:0] } ) ,

   assign  ch9_tx_parallel_data[77:16]           =    ZEROS[63:0]                                           ;
   assign  ch9_tx_parallel_data[15:0]            =    test_in[31:16]                                        ;// ch11_hip_aib_sync_data_in[15:0] ,ch10_hip_aib_sync_data_in[15:0] ,ch9_hip_aib_sync_data_in[15:0] ,ch8_hip_aib_sync_data_in[15:0] } ) ,

   assign  ch10_tx_parallel_data[77:16]          =    ZEROS[63:0]                                           ;
   assign  ch10_tx_parallel_data[15:0]           =    test_in[47:32]                                        ;// ch11_hip_aib_sync_data_in[15:0] ,ch10_hip_aib_sync_data_in[15:0] ,ch9_hip_aib_sync_data_in[15:0] ,ch8_hip_aib_sync_data_in[15:0] } ) ,

   assign  ch11_tx_parallel_data[77:16]          =    ZEROS[63:0]                                           ;
   assign  ch11_tx_parallel_data[15:0]           =    test_in[63:48]                                        ;// ch11_hip_aib_sync_data_in[15:0] ,ch10_hip_aib_sync_data_in[15:0] ,ch9_hip_aib_sync_data_in[15:0] ,ch8_hip_aib_sync_data_in[15:0] } ) ,

   assign  ch12_tx_parallel_data[77:0]           =    ZEROS[79:0]                                           ;
   assign  ch13_tx_parallel_data[77:0]           =    ZEROS[79:0]                                           ;
   assign  ch14_tx_parallel_data[77:0]           =    ZEROS[79:0]                                           ;
   assign  ch15_tx_parallel_data[77:0]           =    ZEROS[79:0]                                           ;


//hip_aib_sync_data_in[77:0] - {tx_parallel_data[78:40], tx_parallel_data[38:0]};

   assign ch0_tx_parallel_data_int               = {1'b0, ch0_tx_parallel_data[77:39] ,1'b0 , ch0_tx_parallel_data[38:0]} ;
   assign ch1_tx_parallel_data_int               = {1'b0, ch1_tx_parallel_data[77:39] ,1'b0 , ch1_tx_parallel_data[38:0]} ;
   assign ch2_tx_parallel_data_int               = {1'b0, ch2_tx_parallel_data[77:39] ,1'b0 , ch2_tx_parallel_data[38:0]} ;
   assign ch3_tx_parallel_data_int               = {1'b0, ch3_tx_parallel_data[77:39] ,1'b0 , ch3_tx_parallel_data[38:0]} ;
   assign ch4_tx_parallel_data_int               = {1'b0, ch4_tx_parallel_data[77:39] ,1'b0 , ch4_tx_parallel_data[38:0]} ;
   assign ch5_tx_parallel_data_int               = {1'b0, ch5_tx_parallel_data[77:39] ,1'b0 , ch5_tx_parallel_data[38:0]} ;
   assign ch6_tx_parallel_data_int               = {1'b0, ch6_tx_parallel_data[77:39] ,1'b0 , ch6_tx_parallel_data[38:0]} ;
   assign ch7_tx_parallel_data_int               = {1'b0, ch7_tx_parallel_data[77:39] ,1'b0 , ch7_tx_parallel_data[38:0]} ;
   assign ch8_tx_parallel_data_int               = {1'b0, ch8_tx_parallel_data[77:39] ,1'b0 , ch8_tx_parallel_data[38:0]} ;
   assign ch9_tx_parallel_data_int               = {1'b0, ch9_tx_parallel_data[77:39] ,1'b0 , ch9_tx_parallel_data[38:0]} ;
   assign ch10_tx_parallel_data_int              = {1'b0, ch10_tx_parallel_data[77:39] ,1'b0 , ch10_tx_parallel_data[38:0]} ;
   assign ch11_tx_parallel_data_int              = {1'b0, ch11_tx_parallel_data[77:39] ,1'b0 , ch11_tx_parallel_data[38:0]} ;
   assign ch12_tx_parallel_data_int              = {1'b0, ch12_tx_parallel_data[77:39] ,1'b0 , ch12_tx_parallel_data[38:0]} ;
   assign ch13_tx_parallel_data_int              = {1'b0, ch13_tx_parallel_data[77:39] ,1'b0 , ch13_tx_parallel_data[38:0]} ;
   assign ch14_tx_parallel_data_int              = {1'b0, ch14_tx_parallel_data[77:39] ,1'b0 , ch14_tx_parallel_data[38:0]} ;
   assign ch15_tx_parallel_data_int              = {1'b0, ch15_tx_parallel_data[77:39] ,1'b0 , ch15_tx_parallel_data[38:0]} ;


   assign ch0_rx_parallel_data                    = {ch0_rx_parallel_data_int[78:40],ch0_rx_parallel_data_int[38:0]};
   assign ch1_rx_parallel_data                    = {ch1_rx_parallel_data_int[78:40],ch1_rx_parallel_data_int[38:0]};
   assign ch2_rx_parallel_data                    = {ch2_rx_parallel_data_int[78:40],ch2_rx_parallel_data_int[38:0]};
   assign ch3_rx_parallel_data                    = {ch3_rx_parallel_data_int[78:40],ch3_rx_parallel_data_int[38:0]};
   assign ch4_rx_parallel_data                    = {ch4_rx_parallel_data_int[78:40],ch4_rx_parallel_data_int[38:0]};
   assign ch5_rx_parallel_data                    = {ch5_rx_parallel_data_int[78:40],ch5_rx_parallel_data_int[38:0]};
   assign ch6_rx_parallel_data                    = {ch6_rx_parallel_data_int[78:40],ch6_rx_parallel_data_int[38:0]};
   assign ch7_rx_parallel_data                    = {ch7_rx_parallel_data_int[78:40],ch7_rx_parallel_data_int[38:0]};
   assign ch8_rx_parallel_data                    = {ch8_rx_parallel_data_int[78:40],ch8_rx_parallel_data_int[38:0]};
   assign ch9_rx_parallel_data                    = {ch9_rx_parallel_data_int[78:40],ch9_rx_parallel_data_int[38:0]};
   assign ch10_rx_parallel_data                   = {ch10_rx_parallel_data_int[78:40],ch10_rx_parallel_data_int[38:0]};
   assign ch11_rx_parallel_data                   = {ch11_rx_parallel_data_int[78:40],ch11_rx_parallel_data_int[38:0]};
   assign ch12_rx_parallel_data                   = {ch12_rx_parallel_data_int[78:40],ch12_rx_parallel_data_int[38:0]};
   assign ch13_rx_parallel_data                   = {ch13_rx_parallel_data_int[78:40],ch13_rx_parallel_data_int[38:0]};
   assign ch14_rx_parallel_data                   = {ch14_rx_parallel_data_int[78:40],ch14_rx_parallel_data_int[38:0]};
   assign ch15_rx_parallel_data                   = {ch15_rx_parallel_data_int[78:40],ch15_rx_parallel_data_int[38:0]};



//RX Data Path Mapping
//hip_aib_sync_data_out[77:0] - {rx_parallel_data[78:40], rx_parallel_data[38:0]};-  Done at pllnphy instanstiation
   assign  tx_ph_cdts                            =    ch0_rx_parallel_data[7:0]             ;         //    ch0_hip_aib_sync_data_out[7:0]
   assign  tx_pd_cdts                            =    ch0_rx_parallel_data[19:8]            ;         //    ch0_hip_aib_sync_data_out[19:8]
   assign  tx_nph_cdts                           =    ch0_rx_parallel_data[27:20]           ;         //    ch0_hip_aib_sync_data_out[27:20]
   assign  tx_npd_cdts[11:0]                     =    ch0_rx_parallel_data[39:28]           ;         //    ch0_hip_aib_sync_data_out[39:28]
   assign  tx_cplh_cdts                          =    ch0_rx_parallel_data[47:40]           ;         //    ch0_hip_aib_sync_data_out[47:40]
   assign  tx_cpld_cdts                          =    ch0_rx_parallel_data[59:48]           ;         //    ch0_hip_aib_sync_data_out[59:48]
   assign  tx_cdts_type                          =    ch0_rx_parallel_data[61:60]           ;         //    ch0_hip_aib_sync_data_out[61:60]
   assign  tx_cdts_data_value                    =    ch0_rx_parallel_data[63:62]           ;         //    ch0_hip_aib_sync_data_out[63:62]
   assign  tx_hdr_cdts_consumed                  =    ch0_rx_parallel_data[64]              ;         //    ch0_hip_aib_sync_data_out[64]
   assign  tx_data_cdts_consumed                 =    ch0_rx_parallel_data[65]              ;         //    ch0_hip_aib_sync_data_out[65]
   assign  tx_par_err                            =    ch0_rx_parallel_data[66]              ;         //    ch0_hip_aib_sync_data_out[66]
   assign  tx_st_ready_undsk                     =    ch0_rx_parallel_data[67]              ;         //    ch0_hip_aib_sync_data_out[67]
   assign  pm_pme_en                             =    ch0_rx_parallel_data[69:68]           ;         //    ch0_hip_aib_sync_data_out[69:68]
   assign  tx_dsk_eval_done                      =    ch0_rx_parallel_data[70]              ;         //    ch0_hip_aib_sync_data_out[69:68]
   assign  tx_dsk_status                         =    ch0_rx_parallel_data[72:71]           ;         //    ch0_hip_aib_sync_data_out[69:68]


   assign  int_status_pf0                        =    ch1_rx_parallel_data[23:16]           ;         //    ch1_hip_aib_sync_data_out[23:16]
   assign  int_status_common                     =    ch1_rx_parallel_data[26:24]           ;         //    ch1_hip_aib_sync_data_out[26:24]
   assign  pld_gp_ctrl                           =    ch1_rx_parallel_data[7:0]             ;         //    ch1_hip_aib_sync_data_out[7:0]
   assign  int_status_pf1                        =    ch1_rx_parallel_data[15:8]            ;         //    ch1_hip_aib_sync_data_out[15:8]
   assign  sriov_test_out                        =    ch1_rx_parallel_data[59:27]           ;         //    ch1_hip_aib_sync_data_out[59:27]

   assign  tl_cfg_ctl                            =    ch2_rx_parallel_data[31:0]            ;         //    ch2_hip_aib_sync_data_out[31:0]
   assign  tl_cfg_add                            =    ch2_rx_parallel_data[36:32]           ;         //    ch2_hip_aib_sync_data_out[36:32]
   assign  tl_cfg_func                           =    ch2_rx_parallel_data[38:37]           ;         //    ch2_hip_aib_sync_data_out[38:37]
   assign  pm_linkst_in_l2                       =    ch2_rx_parallel_data[39]              ;         //    ch2_hip_aib_sync_data_out[39]
   assign  pm_linkst_in_l1                       =    ch2_rx_parallel_data[40]              ;         //    ch2_hip_aib_sync_data_out[40]
   assign  pm_linkst_in_l0s                      =    ch2_rx_parallel_data[41]              ;         //    ch2_hip_aib_sync_data_out[41]
   assign  pm_dstate_0                           =    ch2_rx_parallel_data[44:42]           ;         //    ch2_hip_aib_sync_data_out[44:42]
   assign  pm_state                              =    ch2_rx_parallel_data[50:48]           ;         //    ch2_hip_aib_sync_data_out[50:48]
   assign  pm_status                             =    ch2_rx_parallel_data[52:51]           ;         //    ch2_hip_aib_sync_data_out[52:51]
   assign  pm_linkst_l2_exit                     =    ch2_rx_parallel_data[53]              ;         //    ch2_hip_aib_sync_data_out[53]
   assign  app_msi_ack                           =    ch2_rx_parallel_data[54]              ;         //    ch2_hip_aib_sync_data_out[54]
   assign  ltssm_state                           =    ch2_rx_parallel_data[60:55]           ;         //    ch2_hip_aib_sync_data_out[60:55]
   assign  serr_out_0                            =    ch2_rx_parallel_data[75]              ;         //    ch2_hip_aib_sync_data_out[76:75]
   assign  serr_out_1                            =    ch2_rx_parallel_data[76]              ;         //    ch2_hip_aib_sync_data_out[76:75]
   assign  link_up                               =    ch2_rx_parallel_data[77]              ;         //    ch2_hip_aib_sync_data_out[77]
   assign  pm_dstate_1                           =    ch2_rx_parallel_data[47:45]           ;         //    ch2_hip_aib_sync_data_out[47:45]
   assign  flr_vf_active_tdm                     =    ch2_rx_parallel_data[64:61]           ;         //    ch2_hip_aib_sync_data_out[64:61]
   assign  flr_vf_active                         =    ch2_rx_parallel_data[72:65]           ;         //    ch2_hip_aib_sync_data_out[72:65]
   assign  flr_pf_active                         =    ch2_rx_parallel_data[74:73]           ;         //    ch2_hip_aib_sync_data_out[74:73]


   assign  ceb_dout                              =    ch3_rx_parallel_data[31:0]            ;         //    ch3_hip_aib_sync_data_out[31:0]
   assign  ceb_addr[31:0]                        =    ch3_rx_parallel_data[63:32]           ;         //    ch3_hip_aib_sync_data_out[63:32]
   assign  ceb_wr                                =    ch3_rx_parallel_data[67:64]           ;         //    ch3_hip_aib_sync_data_out[67:64]
   assign  ceb_req                               =    ch3_rx_parallel_data[77]              ;         //    ch3_hip_aib_sync_data_out[77]
   assign  ceb_vf_num                            =    ch3_rx_parallel_data[74:68]           ;         //    ch3_hip_aib_sync_data_out[74:68]
   assign  ceb_vf_active                         =    ch3_rx_parallel_data[75]              ;         //    ch3_hip_aib_sync_data_out[75]
   assign  ceb_func_num                          =    ch3_rx_parallel_data[76]              ;         //    ch3_hip_aib_sync_data_out[76]


   assign  rx_st_data_undsk                      =    {ch7_rx_parallel_data[63:0] ,ch6_rx_parallel_data[63:0] ,ch5_rx_parallel_data[63:0] ,ch4_rx_parallel_data[63:0]  }               ;
   assign  rx_st_parity_undsk                    =    {ch7_rx_parallel_data[71:64] ,ch6_rx_parallel_data[71:64] ,ch5_rx_parallel_data[71:64] ,ch4_rx_parallel_data[71:64] }            ;
   assign  rx_st_sop_undsk                       =    {ch7_rx_parallel_data[77] ,ch6_rx_parallel_data[77] ,ch5_rx_parallel_data[77] ,ch4_rx_parallel_data[72] }             ;         //    ch4_hip_aib_sync_data_out[72]
   assign  rx_st_eop_undsk                       =    ch4_rx_parallel_data[73]              ;         //    ch4_hip_aib_sync_data_out[73]
   assign  rx_st_valid_undsk                     =    ch4_rx_parallel_data[74]              ;         //    ch4_hip_aib_sync_data_out[74]
   assign  rx_par_err_undsk                      =    ch4_rx_parallel_data[75]              ;         //    ch4_hip_aib_sync_data_out[75]
   assign  rx_st_vf_active_undsk                 =    ch4_rx_parallel_data[76]              ;         //    ch4_hip_aib_sync_data_out[76]
   assign  rx_st_func_num_undsk                  =    ch4_rx_parallel_data[77]              ;         //    ch4_hip_aib_sync_data_out[77]


   assign  rx_st_vf_num_undsk                    =    {ch6_rx_parallel_data[73:72] ,ch5_rx_parallel_data[76:72] }    ;
   assign  rx_st_bar_range_undsk                 =    ch6_rx_parallel_data[76:74]           ;

   assign  rx_st_empty_undsk                     =    ch7_rx_parallel_data[74:72]           ;
   assign  test_out                              =    {ch15_rx_parallel_data[31:0]  ,ch14_rx_parallel_data[31:0] ,ch13_rx_parallel_data[31:0] ,ch12_rx_parallel_data[31:0] ,ch11_rx_parallel_data[31:0] ,ch10_rx_parallel_data[31:0] ,ch9_rx_parallel_data[31:0] ,ch8_rx_parallel_data[31:0]}      ;
   assign  pld_hip_reserved_out                  =    {ch7_rx_parallel_data[77]    ,ch6_rx_parallel_data[77] ,ch5_rx_parallel_data[77] ,ch7_rx_parallel_data[76:75] ,ch0_rx_parallel_data[77:70] ,ch1_rx_parallel_data[77:60] }                                                                    ;


   generate
      if (TOTAL_LANES ==8 )  begin : x8_aiblanes
         assign  pllnphy_tx_parallel_data       = {ch7_tx_parallel_data_int,ch6_tx_parallel_data_int,ch5_tx_parallel_data_int,ch4_tx_parallel_data_int,ch3_tx_parallel_data_int,ch2_tx_parallel_data_int,ch1_tx_parallel_data_int,ch0_tx_parallel_data_int}    ;
         assign  pllnphy_pld_aib_ssr_in         = {ch7_pld_aib_ssr_in,ch6_pld_aib_ssr_in,ch5_pld_aib_ssr_in,ch4_pld_aib_ssr_in,ch3_pld_aib_ssr_in,ch2_pld_aib_ssr_in,ch1_pld_aib_ssr_in,ch0_pld_aib_ssr_in}    ;
         assign  pllnphy_pld_aib_fsr_in         = {ch7_pld_aib_fsr_in,ch6_pld_aib_fsr_in,ch5_pld_aib_fsr_in,ch4_pld_aib_fsr_in,ch3_pld_aib_fsr_in,ch2_pld_aib_fsr_in,ch1_pld_aib_fsr_in,ch0_pld_aib_fsr_in}    ;
         assign  pllnphy_hip_aib_data_in        = {ch7_aib_data_in,ch6_aib_data_in,ch5_aib_data_in,ch4_aib_data_in,ch3_aib_data_in,ch2_aib_data_in,ch1_aib_data_in,ch0_aib_data_in}    ;
         assign  pllnphy_hip_pcs_data_in        = {ch7_pcs_data_in,ch6_pcs_data_in,ch5_pcs_data_in,ch4_pcs_data_in,ch3_pcs_data_in,ch2_pcs_data_in,ch1_pcs_data_in,ch0_pcs_data_in}    ;

      end
      else begin : x16_aiblanes
         assign  pllnphy_tx_parallel_data       = {ch15_tx_parallel_data_int,ch14_tx_parallel_data_int,ch13_tx_parallel_data_int,ch12_tx_parallel_data_int,ch11_tx_parallel_data_int,ch10_tx_parallel_data_int,ch9_tx_parallel_data_int,ch8_tx_parallel_data_int,ch7_tx_parallel_data_int,ch6_tx_parallel_data_int,ch5_tx_parallel_data_int,ch4_tx_parallel_data_int,ch3_tx_parallel_data_int,ch2_tx_parallel_data_int,ch1_tx_parallel_data_int,ch0_tx_parallel_data_int}    ;
         assign  pllnphy_pld_aib_ssr_in         = {ch15_pld_aib_ssr_in,ch14_pld_aib_ssr_in,ch13_pld_aib_ssr_in,ch12_pld_aib_ssr_in,ch11_pld_aib_ssr_in,ch10_pld_aib_ssr_in,ch9_pld_aib_ssr_in,ch8_pld_aib_ssr_in,ch7_pld_aib_ssr_in,ch6_pld_aib_ssr_in,ch5_pld_aib_ssr_in,ch4_pld_aib_ssr_in,ch3_pld_aib_ssr_in,ch2_pld_aib_ssr_in,ch1_pld_aib_ssr_in,ch0_pld_aib_ssr_in}    ;
         assign  pllnphy_pld_aib_fsr_in         = {ch15_pld_aib_fsr_in,ch14_pld_aib_fsr_in,ch13_pld_aib_fsr_in,ch12_pld_aib_fsr_in,ch11_pld_aib_fsr_in,ch10_pld_aib_fsr_in,ch9_pld_aib_fsr_in,ch8_pld_aib_fsr_in,ch7_pld_aib_fsr_in,ch6_pld_aib_fsr_in,ch5_pld_aib_fsr_in,ch4_pld_aib_fsr_in,ch3_pld_aib_fsr_in,ch2_pld_aib_fsr_in,ch1_pld_aib_fsr_in,ch0_pld_aib_fsr_in}    ;
         assign  pllnphy_hip_aib_data_in        = {ch15_aib_data_in,ch14_aib_data_in,ch13_aib_data_in,ch12_aib_data_in,ch11_aib_data_in,ch10_aib_data_in,ch9_aib_data_in,ch8_aib_data_in,ch7_aib_data_in,ch6_aib_data_in,ch5_aib_data_in,ch4_aib_data_in,ch3_aib_data_in,ch2_aib_data_in,ch1_aib_data_in,ch0_aib_data_in}    ;
         assign  pllnphy_hip_pcs_data_in        = {ch15_pcs_data_in,ch14_pcs_data_in,ch13_pcs_data_in,ch12_pcs_data_in,ch11_pcs_data_in,ch10_pcs_data_in,ch9_pcs_data_in,ch8_pcs_data_in,ch7_pcs_data_in,ch6_pcs_data_in,ch5_pcs_data_in,ch4_pcs_data_in,ch3_pcs_data_in,ch2_pcs_data_in,ch1_pcs_data_in,ch0_pcs_data_in}    ;

      end
   endgenerate

   assign  ch0_pcs_data_out         =  pllnphy_hip_pcs_data_out[1*62-1:0*62]   ;
   assign  ch1_pcs_data_out         =  (LANES < 2  ) ? ZEROS[61:0]   :  pllnphy_hip_pcs_data_out[2 *62-1:1 *62]   ;
   assign  ch2_pcs_data_out         =  (LANES < 4  ) ? ZEROS[61:0]   :  pllnphy_hip_pcs_data_out[3 *62-1:2 *62]   ;
   assign  ch3_pcs_data_out         =  (LANES < 4  ) ? ZEROS[61:0]   :  pllnphy_hip_pcs_data_out[4 *62-1:3 *62]   ;
   assign  ch4_pcs_data_out         =  (LANES < 8  ) ? ZEROS[61:0]   :  pllnphy_hip_pcs_data_out[5 *62-1:4 *62]   ;
   assign  ch5_pcs_data_out         =  (LANES < 8  ) ? ZEROS[61:0]   :  pllnphy_hip_pcs_data_out[6 *62-1:5 *62]   ;
   assign  ch6_pcs_data_out         =  (LANES < 8  ) ? ZEROS[61:0]   :  pllnphy_hip_pcs_data_out[7 *62-1:6 *62]   ;
   assign  ch7_pcs_data_out         =  (LANES < 8  ) ? ZEROS[61:0]   :  pllnphy_hip_pcs_data_out[8 *62-1:7 *62]   ;
   assign  ch8_pcs_data_out         =  (LANES < 16  ) ? ZEROS[61:0]  :  pllnphy_hip_pcs_data_out[9 *62-1:8 *62]   ;
   assign  ch9_pcs_data_out         =  (LANES < 16  ) ? ZEROS[61:0]  :  pllnphy_hip_pcs_data_out[10*62-1:9 *62]   ;
   assign  ch10_pcs_data_out        =  (LANES < 16  ) ? ZEROS[61:0]  :  pllnphy_hip_pcs_data_out[11*62-1:10*62]   ;
   assign  ch11_pcs_data_out        =  (LANES < 16  ) ? ZEROS[61:0]  :  pllnphy_hip_pcs_data_out[12*62-1:11*62]   ;
   assign  ch12_pcs_data_out        =  (LANES < 16  ) ? ZEROS[61:0]  :  pllnphy_hip_pcs_data_out[13*62-1:12*62]   ;
   assign  ch13_pcs_data_out        =  (LANES < 16  ) ? ZEROS[61:0]  :  pllnphy_hip_pcs_data_out[14*62-1:13*62]   ;
   assign  ch14_pcs_data_out        =  (LANES < 16  ) ? ZEROS[61:0]  :  pllnphy_hip_pcs_data_out[15*62-1:14*62]   ;
   assign  ch15_pcs_data_out        =  (LANES < 16  ) ? ZEROS[61:0]  :  pllnphy_hip_pcs_data_out[16*62-1:15*62]   ;


   assign  ch0_aib_data_out         =  pllnphy_hip_aib_data_out[1*132-1:0*132]   ;
   assign  ch1_aib_data_out         =  pllnphy_hip_aib_data_out[2*132-1:1*132]   ;
   assign  ch2_aib_data_out         =  pllnphy_hip_aib_data_out[3*132-1:2*132]   ;
   assign  ch3_aib_data_out         =  pllnphy_hip_aib_data_out[4*132-1:3*132]   ;
   assign  ch4_aib_data_out         =  pllnphy_hip_aib_data_out[5*132-1:4*132]   ;
   assign  ch5_aib_data_out         =  pllnphy_hip_aib_data_out[6*132-1:5*132]   ;
   assign  ch6_aib_data_out         =  pllnphy_hip_aib_data_out[7*132-1:6*132]   ;
   assign  ch7_aib_data_out         =  pllnphy_hip_aib_data_out[8*132-1:7*132]   ;
   assign  ch8_aib_data_out         =  (TOTAL_LANES !=16 ) ? ZEROS[131:0]   : pllnphy_hip_aib_data_out[9 *132-1:8 *132]   ;
   assign  ch9_aib_data_out         =  (TOTAL_LANES !=16 ) ? ZEROS[131:0]   : pllnphy_hip_aib_data_out[10*132-1:9 *132]   ;
   assign  ch10_aib_data_out        =  (TOTAL_LANES !=16 ) ? ZEROS[131:0]   : pllnphy_hip_aib_data_out[11*132-1:10*132]   ;
   assign  ch11_aib_data_out        =  (TOTAL_LANES !=16 ) ? ZEROS[131:0]   : pllnphy_hip_aib_data_out[12*132-1:11*132]   ;
   assign  ch12_aib_data_out        =  (TOTAL_LANES !=16 ) ? ZEROS[131:0]   : pllnphy_hip_aib_data_out[13*132-1:12*132]   ;
   assign  ch13_aib_data_out        =  (TOTAL_LANES !=16 ) ? ZEROS[131:0]   : pllnphy_hip_aib_data_out[14*132-1:13*132]   ;
   assign  ch14_aib_data_out        =  (TOTAL_LANES !=16 ) ? ZEROS[131:0]   : pllnphy_hip_aib_data_out[15*132-1:14*132]   ;
   assign  ch15_aib_data_out        =  (TOTAL_LANES !=16 ) ? ZEROS[131:0]   : pllnphy_hip_aib_data_out[16*132-1:15*132]   ;



   assign ch0_pld_aib_fsr_out        =  pllnphy_pld_aib_fsr_out[1*4-1:0*4]   ;
   assign ch1_pld_aib_fsr_out        =  pllnphy_pld_aib_fsr_out[2*4-1:1*4]   ;
   assign ch2_pld_aib_fsr_out        =  pllnphy_pld_aib_fsr_out[3*4-1:2*4]   ;
   assign ch3_pld_aib_fsr_out        =  pllnphy_pld_aib_fsr_out[4*4-1:3*4]   ;
   assign ch4_pld_aib_fsr_out        =  pllnphy_pld_aib_fsr_out[5*4-1:4*4]   ;
   assign ch5_pld_aib_fsr_out        =  pllnphy_pld_aib_fsr_out[6*4-1:5*4]   ;
   assign ch6_pld_aib_fsr_out        =  pllnphy_pld_aib_fsr_out[7*4-1:6*4]   ;
   assign ch7_pld_aib_fsr_out        =  pllnphy_pld_aib_fsr_out[8*4-1:7*4]   ;
   assign ch8_pld_aib_fsr_out        =  (TOTAL_LANES !=16 ) ? ZEROS[3:0]   : pllnphy_pld_aib_fsr_out[9 *4-1:8 *4]   ;
   assign ch9_pld_aib_fsr_out        =  (TOTAL_LANES !=16 ) ? ZEROS[3:0]   : pllnphy_pld_aib_fsr_out[10*4-1:9 *4]   ;
   assign ch10_pld_aib_fsr_out       =  (TOTAL_LANES !=16 ) ? ZEROS[3:0]   : pllnphy_pld_aib_fsr_out[11*4-1:10*4]   ;
   assign ch11_pld_aib_fsr_out       =  (TOTAL_LANES !=16 ) ? ZEROS[3:0]   : pllnphy_pld_aib_fsr_out[12*4-1:11*4]   ;
   assign ch12_pld_aib_fsr_out       =  (TOTAL_LANES !=16 ) ? ZEROS[3:0]   : pllnphy_pld_aib_fsr_out[13*4-1:12*4]   ;
   assign ch13_pld_aib_fsr_out       =  (TOTAL_LANES !=16 ) ? ZEROS[3:0]   : pllnphy_pld_aib_fsr_out[14*4-1:13*4]   ;
   assign ch14_pld_aib_fsr_out       =  (TOTAL_LANES !=16 ) ? ZEROS[3:0]   : pllnphy_pld_aib_fsr_out[15*4-1:14*4]   ;
   assign ch15_pld_aib_fsr_out       =  (TOTAL_LANES !=16 ) ? ZEROS[3:0]   : pllnphy_pld_aib_fsr_out[16*4-1:15*4]   ;



   assign ch0_pld_aib_ssr_out        =  pllnphy_pld_aib_ssr_out[1*4-1:0*4]   ;
   assign ch1_pld_aib_ssr_out        =  pllnphy_pld_aib_ssr_out[2*4-1:1*4]   ;
   assign ch2_pld_aib_ssr_out        =  pllnphy_pld_aib_ssr_out[3*4-1:2*4]   ;
   assign ch3_pld_aib_ssr_out        =  pllnphy_pld_aib_ssr_out[4*4-1:3*4]   ;
   assign ch4_pld_aib_ssr_out        =  pllnphy_pld_aib_ssr_out[5*4-1:4*4]   ;
   assign ch5_pld_aib_ssr_out        =  pllnphy_pld_aib_ssr_out[6*4-1:5*4]   ;
   assign ch6_pld_aib_ssr_out        =  pllnphy_pld_aib_ssr_out[7*4-1:6*4]   ;
   assign ch7_pld_aib_ssr_out        =  pllnphy_pld_aib_ssr_out[8*4-1:7*4]   ;
   assign ch8_pld_aib_ssr_out        =  (TOTAL_LANES !=16 ) ? ZEROS[3:0]   : pllnphy_pld_aib_ssr_out[9 *4-1:8 *4]   ;
   assign ch9_pld_aib_ssr_out        =  (TOTAL_LANES !=16 ) ? ZEROS[3:0]   : pllnphy_pld_aib_ssr_out[10*4-1:9 *4]   ;
   assign ch10_pld_aib_ssr_out       =  (TOTAL_LANES !=16 ) ? ZEROS[3:0]   : pllnphy_pld_aib_ssr_out[11*4-1:10*4]   ;
   assign ch11_pld_aib_ssr_out       =  (TOTAL_LANES !=16 ) ? ZEROS[3:0]   : pllnphy_pld_aib_ssr_out[12*4-1:11*4]   ;
   assign ch12_pld_aib_ssr_out       =  (TOTAL_LANES !=16 ) ? ZEROS[3:0]   : pllnphy_pld_aib_ssr_out[13*4-1:12*4]   ;
   assign ch13_pld_aib_ssr_out       =  (TOTAL_LANES !=16 ) ? ZEROS[3:0]   : pllnphy_pld_aib_ssr_out[14*4-1:13*4]   ;
   assign ch14_pld_aib_ssr_out       =  (TOTAL_LANES !=16 ) ? ZEROS[3:0]   : pllnphy_pld_aib_ssr_out[15*4-1:14*4]   ;
   assign ch15_pld_aib_ssr_out       =  (TOTAL_LANES !=16 ) ? ZEROS[3:0]   : pllnphy_pld_aib_ssr_out[16*4-1:15*4]   ;


   assign ch0_rx_parallel_data_int  =  pllnphy_rx_parallel_data[1*80-1:0*80]   ;
   assign ch1_rx_parallel_data_int  =  pllnphy_rx_parallel_data[2*80-1:1*80]   ;
   assign ch2_rx_parallel_data_int  =  pllnphy_rx_parallel_data[3*80-1:2*80]   ;
   assign ch3_rx_parallel_data_int  =  pllnphy_rx_parallel_data[4*80-1:3*80]   ;
   assign ch4_rx_parallel_data_int  =  pllnphy_rx_parallel_data[5*80-1:4*80]   ;
   assign ch5_rx_parallel_data_int  =  pllnphy_rx_parallel_data[6*80-1:5*80]   ;
   assign ch6_rx_parallel_data_int  =  pllnphy_rx_parallel_data[7*80-1:6*80]   ;
   assign ch7_rx_parallel_data_int  =  pllnphy_rx_parallel_data[8*80-1:7*80]   ;
   assign ch8_rx_parallel_data_int  =  (TOTAL_LANES !=16 ) ? ZEROS[79:0]   : pllnphy_rx_parallel_data[9 *80-1:8 *80]   ;
   assign ch9_rx_parallel_data_int  =  (TOTAL_LANES !=16 ) ? ZEROS[79:0]   : pllnphy_rx_parallel_data[10*80-1:9 *80]   ;
   assign ch10_rx_parallel_data_int =  (TOTAL_LANES !=16 ) ? ZEROS[79:0]   : pllnphy_rx_parallel_data[11*80-1:10*80]   ;
   assign ch11_rx_parallel_data_int =  (TOTAL_LANES !=16 ) ? ZEROS[79:0]   : pllnphy_rx_parallel_data[12*80-1:11*80]   ;
   assign ch12_rx_parallel_data_int =  (TOTAL_LANES !=16 ) ? ZEROS[79:0]   : pllnphy_rx_parallel_data[13*80-1:12*80]   ;
   assign ch13_rx_parallel_data_int =  (TOTAL_LANES !=16 ) ? ZEROS[79:0]   : pllnphy_rx_parallel_data[14*80-1:13*80]   ;
   assign ch14_rx_parallel_data_int =  (TOTAL_LANES !=16 ) ? ZEROS[79:0]   : pllnphy_rx_parallel_data[15*80-1:14*80]   ;
   assign ch15_rx_parallel_data_int =  (TOTAL_LANES !=16 ) ? ZEROS[79:0]   : pllnphy_rx_parallel_data[16*80-1:15*80]   ;


   assign pllnphy_tx_fpll_rstb         =     (LANES < 16 ) ? tx_lcff_pll_rstb[2] :tx_lcff_pll_rstb[8];
   assign pllnphy_tx_lcpll_rstb        =     (low_str(virtual_link_rate)!="gen3")? 1'b0 : (LANES < 16 ) ? tx_lcff_pll_rstb[1] :tx_lcff_pll_rstb[7];
   assign pllnphy_mcgb_rst             =     (LANES < 16 ) ? tx_pcs_rst_n[1] : tx_pcs_rst_n[7];



   altera_pcie_s10_hip_ast_pllnphy # (
      .protocol_version             (  protocol_version       ),
      .USED_LANES                   (  LANES                  ),
      .TOTAL_LANES                  (  TOTAL_LANES            )
      ) altera_pcie_s10_hip_ast_pllnphy_inst (

          .tx_analogreset                  (                                     ),   //  input  wire [TOTAL_LANES-1:0]
          .tx_digitalreset                 (                                     ),   //  input  wire [TOTAL_LANES-1:0]
          .rx_analogreset                  (                                     ),   //  input  wire [TOTAL_LANES-1:0]
          .rx_digitalreset                 (                                     ),   //  input  wire [TOTAL_LANES-1:0]
          .tx_aibreset                     ( {TOTAL_LANES{~npor}}                ),   //  input  wire [TOTAL_LANES-1:0] //TODO - Removethis
          .rx_aibreset                     ( {TOTAL_LANES{~npor}}                ),   //  input  wire [TOTAL_LANES-1:0] //TODO - Removethis
          .tx_transfer_ready               (                                     ),   //  output wire [TOTAL_LANES-1:0]
          .rx_transfer_ready               (                                     ),   //  output wire [TOTAL_LANES-1:0]
          .tx_cal_busy                     (                                     ),   //  output wire [TOTAL_LANES-1:0]
          .rx_cal_busy                     (                                     ),   //  output wire [TOTAL_LANES-1:0]
          .rx_cdr_refclk0                  ( (pipe32_sim_only==1'b1)?1'b0:refclk ),   //  input  wire
          .tx_serial_data                  ( pllnphy_tx_serial_data              ),   //  output wire [TOTAL_LANES-1:0]
          .rx_serial_data                  ( pllnphy_rx_serial_data              ),   //  input  wire [TOTAL_LANES-1:0]
          .rx_is_lockedtoref               (                                     ),   //  output wire [TOTAL_LANES-1:0]
          .rx_is_lockedtodata              (                                     ),   //  output wire [TOTAL_LANES-1:0]
          .tx_parallel_data                ( pllnphy_tx_parallel_data            ),   //  input  wire [TOTAL_LANES*80-1:0]
          .rx_parallel_data                ( pllnphy_rx_parallel_data            ),   //  output wire [TOTAL_LANES*80-1:0]


          .tx_clkout                       ( pllnphy_tx_clkout                   ),   //  output wire [TOTAL_LANES-1:0]
          .tx_clkout2                      (                                     ),   //  output wire [TOTAL_LANES-1:0]
          .rx_clkout                       (                                     ),   //  output wire [TOTAL_LANES-1:0]

          .pipe_rx_eidleinfersel           ( {TOTAL_LANES{3'b000}}               ),   //  input  wire [TOTAL_LANES*3-1:0]
          .pipe_rx_elecidle                (                                     ),   //  output wire [TOTAL_LANES-1:0]

          .hip_aib_data_in                 ( pllnphy_hip_aib_data_in             ),   //  input  wire [TOTAL_LANES*101-1:0]
          .hip_aib_data_out                ( pllnphy_hip_aib_data_out            ),   //  output wire [TOTAL_LANES*132-1:0]
          .hip_pcs_data_in                 ( pllnphy_hip_pcs_data_in             ),   //  input  wire [TOTAL_LANES*92-1:0]
          .hip_pcs_data_out                ( pllnphy_hip_pcs_data_out            ),   //  output wire [TOTAL_LANES*62-1:0]
          .hip_aib_fsr_in                  ( pllnphy_pld_aib_fsr_in              ),   //  input  wire [TOTAL_LANES*4-1:0]
          .hip_aib_ssr_in                  ( pllnphy_pld_aib_ssr_in              ),   //  input  wire [TOTAL_LANES*40-1:0]
          .hip_aib_fsr_out                 ( pllnphy_pld_aib_fsr_out             ),   //  output wire [TOTAL_LANES*4-1:0]
          .hip_aib_ssr_out                 ( pllnphy_pld_aib_ssr_out             ),   //  output wire [TOTAL_LANES*8-1:0]
          .chnl_cal_done                   ( pllnphy_chnl_cal_done               ),   //  output wire [TOTAL_LANES-1:0]         //hip_cal_done
          //Reconfig Interface
          .reconfig_clk                    (  xcvr_reconfig_clk                  ),    //   input  wire
          .reconfig_reset                  (  xcvr_reconfig_reset                ),    //   input  wire
          .reconfig_write                  (  xcvr_reconfig_write                ),    //   input  wire
          .reconfig_read                   (  xcvr_reconfig_read                 ),    //   input  wire
          .reconfig_address                (  xcvr_reconfig_address              ),    //   input  wire [13:0]
          .reconfig_writedata              (  xcvr_reconfig_writedata            ),    //   input  wire [31:0]
          .reconfig_readdata               (  xcvr_reconfig_readdata             ),    //   output wire [31:0]
          .reconfig_waitrequest            (  xcvr_reconfig_waitrequest          ),    //   output wire
          //FPLL Reconfig Interface
          .reconfig_pll0_clk               (  reconfig_pll0_clk                  ),    //   input  wire                            //     reconfig_clk.clk
          .reconfig_pll0_reset             (  reconfig_pll0_reset                ),    //   input  wire                            //     reconfig_reset.reset
          .reconfig_pll0_write             (  reconfig_pll0_write                ),    //   input  wire                            //     reconfig_avmm.write
          .reconfig_pll0_read              (  reconfig_pll0_read                 ),    //   input  wire                            //                 .read
          .reconfig_pll0_address           (  reconfig_pll0_address              ),    //   input  wire [10:0]                     //                 .address
          .reconfig_pll0_writedata         (  reconfig_pll0_writedata            ),    //   input  wire [31:0]                     //                 .writedata
          .reconfig_pll0_readdata          (  reconfig_pll0_readdata             ),    //   output wire [31:0]                     //                 .readdata
          .reconfig_pll0_waitrequest       (  reconfig_pll0_waitrequest          ),    //   output wire                            //                 .waitrequest
          //LC PLL Reconfig Interface
          .reconfig_pll1_clk               (  reconfig_pll1_clk                  ),    //   input  wire                            //     reconfig_clk.clk
          .reconfig_pll1_reset             (  reconfig_pll1_reset                ),    //   input  wire                            //     reconfig_reset.reset
          .reconfig_pll1_write             (  reconfig_pll1_write                ),    //   input  wire                            //     reconfig_avmm.write
          .reconfig_pll1_read              (  reconfig_pll1_read                 ),    //   input  wire                            //                 .read
          .reconfig_pll1_address           (  reconfig_pll1_address              ),    //   input  wire [10:0]                     //                 .address
          .reconfig_pll1_writedata         (  reconfig_pll1_writedata            ),    //   input  wire [31:0]                     //                 .writedata
          .reconfig_pll1_readdata          (  reconfig_pll1_readdata             ),    //   output wire [31:0]                     //                 .readdata
          .reconfig_pll1_waitrequest       (  reconfig_pll1_waitrequest          ),    //   output wire                            //                 .waitrequest
          //LC PLL ports
          .pll_powerdown_lcpll             ( pllnphy_tx_lcpll_rstb               ),   //   input  wire                            //    pll_powerdown.pll_powerdown   //TODO for Gen3 with LC n FF PLL
          .pll_locked_lcpll_to_pld         ( pllnphy_pll_locked_lcpll_to_pld     ),   //   output wire                            //    pll_locked.pll_locked
          .pll_locked_lcpll                ( pllnphy_pll_locked_lcpll            ),   //   output wire                            //    pll_locked.pll_locked
          .pll_cal_done_lcpll              ( pllnphy_pll_cal_done_lcpll          ),   //   output wire                            //    pll_cal_done.hip_cal_done
          //FPLL ports
          .pll_powerdown_fpll              ( pllnphy_tx_fpll_rstb                ),   //   input  wire                            //    pll_powerdown.pll_powerdown   //TODO for Gen3 with LC n FF PLL
          .pll_locked_fpll_to_pld          ( pllnphy_pll_locked_fpll_to_pld      ),   //   output wire                            //    pll_locked.pll_locked
          .pll_locked_fpll                 ( pllnphy_pll_locked_fpll             ),   //   output wire                            //    pll_locked.pll_locked
          .pll_cal_done_fpll               ( pllnphy_pll_cal_done_fpll           ),   //   output wire                            //    pll_cal_done.hip_cal_done
          // Master CGB reset port
          .mcgb_rst                        ( pllnphy_mcgb_rst                    ),   //   input  wire                            //    reset to the MST CGB
          .pll_refclk0                     ( (pipe32_sim_only==1'b1)?1'b0:refclk )    //   input  wire                            //    pll_refclk0.clk


   );



   assign  tx_out0       =  (  LANES > 0  ) ? pllnphy_tx_serial_data[0 ]  : ZEROS[0] ;
   assign  tx_out1       =  (  LANES > 1  ) ? pllnphy_tx_serial_data[1 ]  : ZEROS[0] ;
   assign  tx_out2       =  (  LANES > 3  ) ? pllnphy_tx_serial_data[2 ]  : ZEROS[0] ;
   assign  tx_out3       =  (  LANES > 3  ) ? pllnphy_tx_serial_data[3 ]  : ZEROS[0] ;
   assign  tx_out4       =  (  LANES > 7  ) ? pllnphy_tx_serial_data[4 ]  : ZEROS[0] ;
   assign  tx_out5       =  (  LANES > 7  ) ? pllnphy_tx_serial_data[5 ]  : ZEROS[0] ;
   assign  tx_out6       =  (  LANES > 7  ) ? pllnphy_tx_serial_data[6 ]  : ZEROS[0] ;
   assign  tx_out7       =  (  LANES > 7  ) ? pllnphy_tx_serial_data[7 ]  : ZEROS[0] ;
   assign  tx_out8       =  (  LANES > 15 ) ? pllnphy_tx_serial_data[8 ]  : ZEROS[0] ;
   assign  tx_out9       =  (  LANES > 15 ) ? pllnphy_tx_serial_data[9 ]  : ZEROS[0] ;
   assign  tx_out10      =  (  LANES > 15 ) ? pllnphy_tx_serial_data[10]  : ZEROS[0] ;
   assign  tx_out11      =  (  LANES > 15 ) ? pllnphy_tx_serial_data[11]  : ZEROS[0] ;
   assign  tx_out12      =  (  LANES > 15 ) ? pllnphy_tx_serial_data[12]  : ZEROS[0] ;
   assign  tx_out13      =  (  LANES > 15 ) ? pllnphy_tx_serial_data[13]  : ZEROS[0] ;
   assign  tx_out14      =  (  LANES > 15 ) ? pllnphy_tx_serial_data[14]  : ZEROS[0] ;
   assign  tx_out15      =  (  LANES > 15 ) ? pllnphy_tx_serial_data[15]  : ZEROS[0] ;


    //Mapping from S10 signals to A10 signals
   assign nego_link_width = {pm_status,pm_pme_en,pm_linkst_in_l2,pm_linkst_l2_exit} ;

   always @ (posedge coreclkout_hip or posedge reset_status) begin
   if (reset_status) begin
      currentspeed_reg <=2'b00;
   end
   else begin
      if ((tl_cfg_func == 2'b00 ) && (tl_cfg_add == 5'h07) )
         currentspeed_reg <= tl_cfg_ctl[7:6];
   end

   end

   assign currentspeed  = currentspeed_reg;
   assign lane_act      = nego_link_width[4:0];

   assign clr_st                       =  reset_status    ;
   assign sim_pipe_pclk_out            = (pipe32_sim_only==1'b0)?1'b0  : sim_pipe_pclk_in ;
   assign sim_pipe_rate                = (pipe32_sim_only==1'b0)?2'b00 : rate0 ;
   assign sim_ltssmstate               = ltssm_state ;
   assign serdes_pll_locked= (pipe32_sim_only==1'b1)?1'b1:(virtual_link_rate!="gen3")? pllnphy_pll_locked_fpll_to_pld : pllnphy_pll_locked_lcpll_to_pld & pllnphy_pll_locked_fpll_to_pld;


   //From HIP to HSSI AIB
   assign hip_aib_avmm_out = {1'b0,1'b0,1'b0,1'b0,hip_avmm_writedone,hip_avmm_readdatavalid,hip_avmm_readdata};
   //From HSSI AIB to HIP
   assign hip_avmm_read        =     hip_aib_avmm_in[30]        ;
   assign hip_avmm_write       =     hip_aib_avmm_in[29]        ;
   assign hip_avmm_reg_addr    =     hip_aib_avmm_in[28:8]      ;
   assign hip_avmm_writedata   =     hip_aib_avmm_in[7:0]       ;




//This atom is needed for the HIP Reconfig AVMM Interface to connect from PLD
   //to HIP .
    ct1_xcvr_avmm2
     #(
       //PARAM_LIST_START
       .avmm_interfaces                              ( 1                             )  ,
       .rcfg_enable                                  ( 0                             )  ,
       .enable_avmm                                  ( 1                             )  ,
       .silicon_rev                                  ( "14nm5"                       )  ,
       .pcs_calibration_feature_en                   ( "avmm2_pcs_calibration_dis"   )  ,
       .pcs_arbiter_ctrl                             ( "avmm2_arbiter_pld_sel"        )  ,
       .pcs_cal_done                                 ( "avmm2_cal_done_assert"       )  ,
       .calibration_type                             ( "one_time"                    )  ,
       .pcs_hip_cal_en                               ( "disable"                      )  ,
       .pldadapt_hip_mode                            ( "user_chnl"                   )  ,
       .hssiadapt_hip_mode                           ( "user_chnl"                   )  ,
       .hssiadapt_avmm_osc_clock_setting             ( "osc_clk_div_by1"             )  ,
       .pldadapt_avmm_osc_clock_setting              ( "osc_clk_div_by1"             )
       //PARAM_LIST_END
     )  ct1_xcvr_avmm2_inst (
       //PORT_LIST_START
       // AVMM slave interface signals (user)
       .avmm_clk                                     ( user_avmm_clk                 ) ,                                                     // input  wire  [avmm_interfaces-1     :0]
       .avmm_reset                                   ( 1'h0                          ) ,                                                     // input  wire  [avmm_interfaces-1     :0]
       .avmm_writedata                               ( 8'h0                          ) ,                                                     // input  wire  [avmm_interfaces*8-1   :0]
       .avmm_address                                 ( 10'h0                         ) ,                                                     // input  wire  [avmm_interfaces*10-1  :0]  //TODO - 9 or 10 bits?
       .avmm_write                                   ( 1'h0                          ) ,                                                     // input  wire  [avmm_interfaces-1     :0]
       .avmm_read                                    ( 1'h0                          ) ,                                                     // input  wire  [avmm_interfaces-1     :0]
       .avmm_readdata                                (                               ) ,                                                     // output reg   [avmm_interfaces*8-1   :0]
       .avmm_waitrequest                             (                               ) ,                                                     // output wire  [avmm_interfaces-1     :0]
           //AVMM interface busy with calibratio
       .avmm_busy                                    (                               ) ,                                                     // output wire  [avmm_interfaces-1     :0]
           // Calibration Done
       .hip_cal_done                                 (                               ) ,                                                     //  output wire  [avmm_interfaces-1     :0] //To HIP
       .pld_cal_done                                 (                               ) ,                                                     //  output wire  [avmm_interfaces-1     :0] //To PLD
           //DPRIO interface to far-end Crete and PCS/PMA atoms connected to AVMM1 interface
       .pll_avmm_clk                                 (                               ) ,                                                     // output  wire  [avmm_interfaces-1    :0]
       .pll_avmm_writedata                           (                               ) ,                                                     // output  wire  [avmm_interfaces*8-1  :0]  //Internal AVMM interface is 8-bit wide
       .pll_avmm_address                             (                               ) ,                                                     // output  wire  [avmm_interfaces*10-1 :0]
       .pll_avmm_write                               (                               ) ,                                                     // output  wire  [avmm_interfaces-1    :0]
       .pll_avmm_read                                (                               ) ,                                                     // output  wire  [avmm_interfaces-1    :0]
           // PLL AVMM signals
       .pll_avmmreaddata_lc_pll                      ( 8'h0                          ) ,                                                     //     input   wire  [avmm_interfaces*8-1  :0]                     // LC PLL readdata                  (8 for each PLL)
       .pll_avmmreaddata_lc_refclk_select            ( 8'h0                          ) ,                                                     //     input   wire  [avmm_interfaces*8-1  :0]                     // LC Refclk Select Mux readdata    (8 for each PLL)
       .pll_avmmreaddata_cgb_master                  ( 8'h0                          ) ,                                                     //     input   wire  [avmm_interfaces*8-1  :0]                     // Master CGB readdata              (8 for each PLL)
       .pll_avmmreaddata_cmu_fpll                    ( 8'h0                          ) ,                                                     //     input   wire  [avmm_interfaces*8-1  :0]                     // CMU-FPLL readdata                (8 for each PLL)
       .pll_avmmreaddata_cmu_fpll_refclk_select      ( 8'h0                          ) ,                                                     //     input   wire  [avmm_interfaces*8-1  :0]                     // CMU-FPLL refclk mux readdata     (8 for each PLL)
           // CDR Tx PLL will instantiate avmm1 wrapper and connect to pma_avmmreaddata_cdr_pll and pma_avmmreaddata_cdr_refclk_select
       .pll_blockselect_lc_pll                       ( 1'h0                          ) ,                                                     //      input   wire  [avmm_interfaces-1    :0]                            // LC PLL blockselect               (1 for each PLL)
       .pll_blockselect_lc_refclk_select             ( 1'h0                          ) ,                                                     //      input   wire  [avmm_interfaces-1    :0]                            // LC Refclk Select Mux blockselect (1 for each PLL)
       .pll_blockselect_cgb_master                   ( 1'h0                          ) ,                                                     //      input   wire  [avmm_interfaces-1    :0]                            // Master CGB blockselect           (1 for each PLL)
       .pll_blockselect_cmu_fpll                     ( 1'h0                          ) ,                                                     //      input   wire  [avmm_interfaces-1    :0]                            // CMU-FPLL blockselect             (1 for each PLL)
       .pll_blockselect_cmu_fpll_refclk_select       ( 1'h0                          ) ,                                                     //      input   wire  [avmm_interfaces-1    :0]                            // CMU-FPLL refclk mux blockselect  (1 for each PLL)
           // CDR Tx PLL will instantiate avmm1 wrapper and connect to pma_blockselect_cdr_pll and pma_blockselect_cdr_refclk_select

       // PLD AIB -PLD signals
       .hip_avmm_read                                ( user_avmm_read_int            ) ,                                                     //      input wire    [avmm_interfaces-1    :0]
       .hip_avmm_write                               ( user_avmm_write_int           ) ,                                                     //      input wire    [avmm_interfaces-1    :0]
       .hip_avmm_reg_addr                            ( user_avmm_addr_int            ) ,                                                     //      input wire    [avmm_interfaces*21-1 :0]
       .hip_avmm_writedata                           ( user_avmm_writedata_int       ) ,                                                     //      input wire    [avmm_interfaces*8-1  :0]
       .hip_avmm_readdata                            ( user_avmm_readdata_int        ) ,                                                     //      output wire   [avmm_interfaces*8-1  :0]
       .hip_avmm_readdatavalid                       ( user_avmm_readdatavalid_int   ) ,                                                     //      output wire   [avmm_interfaces-1    :0]
       .hip_avmm_writedone                           ( user_avmm_writedone_int       ) ,                                                     //      output wire   [avmm_interfaces-1    :0]
       .hip_avmm_reserved_out                        (                               ) ,                                                     //      output wire   [avmm_interfaces*5-1  :0]

       //HSSI AIB - HIP
       .hip_aib_avmm_clk                             ( hip_aib_avmm_clk              ) ,                                                     //      output wire   [avmm_interfaces-1    :0]
       .hip_aib_avmm_in                              ( hip_aib_avmm_in               ) ,                                                     //      output wire   [avmm_interfaces*31-1 :0]
       .hip_aib_avmm_out                             ( hip_aib_avmm_out              )                                                       //      input wire    [avmm_interfaces*15-1 :0]
       //PORT_LIST_END
     );



   //To convert HIP AVMM Protocol to Standard AVMM Protocol
   hip_user_avmm_adaptor hip_user_avmm_adaptor_inst
   (
      .clk                            ( user_avmm_clk               )   , //     input
      .rst_n                          ( user_avmm_rst_n             )   , //     input
      // from/to XCVR AVMM ATOM
      .hip_readdatavalid              ( user_avmm_readdatavalid_int )   , //     input
      .hip_readdata                   ( user_avmm_readdata_int      )   , //     input    [7:0]
      .hip_writedone                  ( user_avmm_writedone_int     )   , //     input
      .hip_read                       ( user_avmm_read_int          )   , //     output
      .hip_write                      ( user_avmm_write_int         )   , //     output
      .hip_addr                       ( user_avmm_addr_int          )   , //     output   [20:0]
      .hip_writedata                  ( user_avmm_writedata_int     )   , //     output   [7:0]
      // from/to to user PLD - Standard AVMM
      .pld_read                       ( user_avmm_read              )   , //     input
      .pld_write                      ( user_avmm_write             )   , //     input
      .pld_addr                       ( user_avmm_addr              )   , //     input    [20:0]
      .pld_writedata                  ( user_avmm_writedata         )   , //     input    [7:0]
      .pld_waitrequest                ( user_avmm_waitrequest       )   , //     output
      .pld_readdatavalid              ( user_avmm_readdatavalid     )   , //     output
      .pld_readdata                   ( user_avmm_readdata          )     //     output   [7:0]
   );


   generate begin
   if ( virtual_link_rate == "gen3" && virtual_link_width == "x16" ) begin : deskew
      rx_deskew_logic rx_deskew_logic_inst
         (
          .clk                        (coreclkout_hip          ),
          .rst_n                      (~reset_status           ),
          .rx_st_sop_undsk            (rx_st_sop_undsk         ),
          .rx_st_eop_undsk            (rx_st_eop_undsk         ),
          .rx_st_data_undsk           (rx_st_data_undsk        ),
          .rx_st_valid_undsk          (rx_st_valid_undsk       ),
          .rx_st_parity_undsk         (rx_st_parity_undsk      ),
          .rx_st_bar_range_undsk      (rx_st_bar_range_undsk   ),
          .rx_st_empty_undsk          (rx_st_empty_undsk       ),
          .rx_st_par_err_undsk        (rx_par_err_undsk        ),
          .rx_st_vf_active_undsk      (rx_st_vf_active_undsk   ),
          .rx_st_func_num_undsk       (rx_st_func_num_undsk    ),
          .rx_st_vf_num_undsk         (rx_st_vf_num_undsk      ),
          .rx_st_sop_dsk              (rx_st_sop               ),
          .rx_st_eop_dsk              (rx_st_eop               ),
          .rx_st_data_dsk             (rx_st_data              ),
          .rx_st_valid_dsk            (rx_st_valid             ),
          .rx_st_parity_dsk           (rx_st_parity            ),
          .rx_st_bar_range_dsk        (rx_st_bar_range         ),
          .rx_st_empty_dsk            (rx_st_empty             ),
          .rx_st_par_err_dsk          (rx_par_err              ),
          .rx_st_vf_active_dsk        (rx_st_vf_active         ),
          .rx_st_func_num_dsk         (rx_st_func_num          ),
          .rx_st_vf_num_dsk           (rx_st_vf_num            ),
          .rx_dsk_eval_done           (rx_dsk_eval_done        ),
          .rx_dsk_status              (rx_dsk_status           )
          );

      assign tx_st_data_undsk           =  tx_dsk_eval_done ?  tx_st_data        : 256'h0;
      assign tx_st_parity_undsk         =  tx_dsk_eval_done ?  tx_st_parity      : 32'h0;
      assign tx_st_sop_undsk            =  tx_dsk_eval_done ?  tx_st_sop         : tx_st_sop_dummy ;
      assign tx_st_eop_undsk            =  tx_dsk_eval_done ?  tx_st_eop         : 1'b0;
      assign tx_st_valid_undsk          =  tx_dsk_eval_done ?  tx_st_valid       : 1'b0;
      assign tx_st_err_undsk            =  tx_dsk_eval_done ?  tx_st_err         : 1'b0;
      assign tx_st_vf_active_undsk      =  tx_dsk_eval_done ?  tx_st_vf_active   : 1'b0;
      assign tx_st_ready                =  tx_dsk_eval_done ?  tx_st_ready_undsk : 1'b0;
      //Creating a Dummy SOP for one cycle
      always @ (posedge coreclkout_hip or posedge reset_status ) begin
         if(reset_status ) begin
            dummy_sop_sent = 1'b0 ;
            tx_st_sop_dummy= 1'b0 ;
         end
         else begin
            if (tx_st_ready_undsk  == 1'b1 && dummy_sop_sent == 1'b0 ) begin
               tx_st_sop_dummy = 1'b1 ;
               dummy_sop_sent = 1'b1 ;
            end
            else begin
               tx_st_sop_dummy = 1'b0 ;
            end
         end
      end
    end
    else begin : no_deskew
       assign rx_st_sop          = rx_st_sop_undsk[0]       ;
       assign rx_st_eop          = rx_st_eop_undsk          ;
       assign rx_st_data         = rx_st_data_undsk         ;
       assign rx_st_valid        = rx_st_valid_undsk        ;
       assign rx_st_parity       = rx_st_parity_undsk       ;
       assign rx_st_bar_range    = rx_st_bar_range_undsk    ;
       assign rx_st_empty        = rx_st_empty_undsk        ;
       assign rx_par_err         = rx_par_err_undsk      ;
       assign rx_st_vf_active    = rx_st_vf_active_undsk    ;
       assign rx_st_func_num     = rx_st_func_num_undsk     ;
       assign rx_st_vf_num       = rx_st_vf_num_undsk       ;
       assign rx_dsk_eval_done   = 1'b1                     ;
       assign rx_dsk_status      = 2'b00                    ;

       assign tx_st_data_undsk           =    tx_st_data          ;
       assign tx_st_parity_undsk         =    tx_st_parity        ;
       assign tx_st_sop_undsk            =    tx_st_sop           ;
       assign tx_st_eop_undsk            =    tx_st_eop           ;
       assign tx_st_valid_undsk          =    tx_st_valid         ;
       assign tx_st_err_undsk            =    tx_st_err           ;
       assign tx_st_vf_active_undsk      =    tx_st_vf_active     ;
       assign tx_st_ready                =    tx_st_ready_undsk   ;
   end
   end
   endgenerate

endmodule



module altpcie_grounder
 # (
    parameter WIDTH = 1

    )
 (
   input [WIDTH-1:0] in_sig,
   input grounded,
   output [WIDTH-1:0] out_sig
 );

   assign out_sig =           (grounded)? {(WIDTH){1'b0}} :in_sig;
endmodule






//  This module is going to be used in soft logic to convert the user AVMM protocol
//  from HIP to standard AVMM interface
module hip_user_avmm_adaptor
(
   input             clk,
   input             rst_n,

   // from AIB FIFO side
   input             hip_readdatavalid,
   input    [7:0]    hip_readdata,
   input             hip_writedone,

   // from PLD
   input             pld_read,
   input             pld_write,
   input    [20:0]   pld_addr,
   input    [7:0]    pld_writedata,

   output            hip_read,
   output            hip_write,
   output   [20:0]   hip_addr,
   output   [7:0]    hip_writedata,

   output            pld_waitrequest,
   output            pld_readdatavalid,
   output   [7:0]    pld_readdata
);

   reg               pld_waitrequest_r;
   reg               req_in_process_r;

   assign pld_waitrequest   = pld_waitrequest_r;
   assign pld_readdatavalid = hip_readdatavalid;
   assign pld_readdata      = hip_readdata;

   always @ (posedge clk or negedge rst_n)
   begin
      if (~rst_n)
      begin
         pld_waitrequest_r <= 1'b1;
         req_in_process_r            <= 1'b0;
      end
      else
      begin
         req_in_process_r
            <= (hip_writedone | hip_readdatavalid) ? 1'b0
             : ((pld_read | pld_write) &
                ~pld_waitrequest_r) ? 1'b1
             : req_in_process_r;

         pld_waitrequest_r
            <= (pld_waitrequest_r &
                (~req_in_process_r |
                 req_in_process_r &
                 (hip_writedone | hip_readdatavalid))) ? 1'b0
             : ((pld_read | pld_write) &
                ~pld_waitrequest_r) ? 1'b1
             : pld_waitrequest_r;
      end
   end


   reg               hip_read_r;
   reg               hip_write_r;
   reg      [20:0]   hip_addr_r;
   reg      [7:0]    hip_writedata_r;

   always @ (posedge clk or negedge rst_n)
   begin
      if (~rst_n)
      begin
         hip_read_r      <= 1'b0;
         hip_write_r     <= 1'b0;
         hip_addr_r      <= 21'h0;
         hip_writedata_r <= 8'h0;
      end
      else
      begin
         hip_read_r      <= pld_read  & ~pld_waitrequest_r;
         hip_write_r     <= pld_write & ~pld_waitrequest_r;
         hip_addr_r      <= pld_addr;
         hip_writedata_r <= pld_writedata;
      end
   end

   assign hip_read        = hip_read_r;
   assign hip_write       = hip_write_r;
   assign hip_addr        = hip_addr_r;
   assign hip_writedata   = hip_writedata_r;
endmodule



module rx_deskew_logic
(

   input            clk                           ,
   input            rst_n                         ,

   input [3:0]      rx_st_sop_undsk               ,
   input            rx_st_eop_undsk               ,
   input [255:0]    rx_st_data_undsk              ,
   input            rx_st_valid_undsk             ,
   input [31:0]     rx_st_parity_undsk            ,
   input [2:0]      rx_st_bar_range_undsk         ,
   input [2:0]      rx_st_empty_undsk             ,
   input            rx_st_par_err_undsk           ,
   input            rx_st_vf_active_undsk         ,
   input            rx_st_func_num_undsk          ,
   input [6:0]      rx_st_vf_num_undsk            ,

   output           rx_st_sop_dsk                 ,
   output           rx_st_eop_dsk                 ,
   output [255:0]   rx_st_data_dsk                ,
   output           rx_st_valid_dsk               ,
   output [31:0]    rx_st_parity_dsk              ,
   output [2:0]     rx_st_bar_range_dsk           ,
   output [2:0]     rx_st_empty_dsk               ,
   output           rx_st_par_err_dsk             ,
   output           rx_st_vf_active_dsk           ,
   output           rx_st_func_num_dsk            ,
   output [6:0]     rx_st_vf_num_dsk              ,

   output reg       rx_dsk_eval_done              ,
   output reg [1:0] rx_dsk_status
 );


   reg [3:0]      rx_st_sop_lat_0          ;
   reg            rx_st_eop_lat_0          ;
   reg [255:0]    rx_st_data_lat_0         ;
   reg            rx_st_valid_lat_0        ;
   reg [32:0]     rx_st_parity_lat_0       ;
   reg [2:0]      rx_st_bar_range_lat_0    ;
   reg [2:0]      rx_st_empty_lat_0        ;
   reg            rx_st_par_err_lat_0      ;
   reg            rx_st_vf_active_lat_0    ;
   reg            rx_st_func_num_lat_0     ;
   reg [6:0]      rx_st_vf_num_lat_0       ;

   reg [3:0]      rx_st_sop_lat_1          ;
   reg            rx_st_eop_lat_1          ;
   reg [255:0]    rx_st_data_lat_1         ;
   reg            rx_st_valid_lat_1        ;
   reg [32:0]     rx_st_parity_lat_1       ;
   reg [2:0]      rx_st_bar_range_lat_1    ;
   reg [2:0]      rx_st_empty_lat_1        ;
   reg            rx_st_par_err_lat_1      ;
   reg            rx_st_vf_active_lat_1    ;
   reg            rx_st_func_num_lat_1     ;
   reg [6:0]      rx_st_vf_num_lat_1       ;

   reg [3:0]      rx_st_sop_lat_2          ;
   reg            rx_st_eop_lat_2          ;
   reg [255:0]    rx_st_data_lat_2         ;
   reg            rx_st_valid_lat_2        ;
   reg [32:0]     rx_st_parity_lat_2       ;
   reg [2:0]      rx_st_bar_range_lat_2    ;
   reg [2:0]      rx_st_empty_lat_2        ;
   reg            rx_st_par_err_lat_2      ;
   reg            rx_st_vf_active_lat_2    ;
   reg            rx_st_func_num_lat_2     ;
   reg [6:0]      rx_st_vf_num_lat_2       ;


   //This is needed to deskew the first TLP
   reg [3:0]      rx_st_sop_side_pipeline_0          ;
   reg            rx_st_eop_side_pipeline_0          ;
   reg [255:0]    rx_st_data_side_pipeline_0         ;
   reg            rx_st_valid_side_pipeline_0        ;
   reg [32:0]     rx_st_parity_side_pipeline_0       ;
   reg [2:0]      rx_st_bar_range_side_pipeline_0    ;
   reg [2:0]      rx_st_empty_side_pipeline_0        ;
   reg            rx_st_par_err_side_pipeline_0      ;
   reg            rx_st_vf_active_side_pipeline_0    ;
   reg            rx_st_func_num_side_pipeline_0     ;
   reg [6:0]      rx_st_vf_num_side_pipeline_0       ;

   reg [3:0]      rx_st_sop_side_pipeline_1          ;
   reg            rx_st_eop_side_pipeline_1          ;
   reg [255:0]    rx_st_data_side_pipeline_1         ;
   reg            rx_st_valid_side_pipeline_1        ;
   reg [32:0]     rx_st_parity_side_pipeline_1       ;
   reg [2:0]      rx_st_bar_range_side_pipeline_1    ;
   reg [2:0]      rx_st_empty_side_pipeline_1        ;
   reg            rx_st_par_err_side_pipeline_1      ;
   reg            rx_st_vf_active_side_pipeline_1    ;
   reg            rx_st_func_num_side_pipeline_1     ;
   reg [6:0]      rx_st_vf_num_side_pipeline_1       ;



   wire           all_1lvl_rx_st_sop       ;
   wire           all_2lvl_rx_st_sop       ;
   wire           all_3lvl_rx_st_sop       ;
   wire           any_3lvl_rx_st_sop       ;
   wire           any_2lvl_rx_st_sop       ;
   wire           any_1lvl_rx_st_sop       ;
   reg            any_1lvl_rx_st_sop_flag  ;

   wire [3:0]     set_dly_rx_st_sop        ;
   wire [3:0]     set_dly2_rx_st_sop       ;
   reg [3:0]      dly_rx_st_sop            ;
   reg [3:0]      dly2_rx_st_sop           ;

   wire [63:0]    muxed_rx_st_data_0       ;
   wire [63:0]    muxed_rx_st_data_1       ;
   wire [63:0]    muxed_rx_st_data_2       ;
   wire [63:0]    muxed_rx_st_data_3       ;
   wire [255:0]   muxed_rx_st_data         ;

   wire [7:0]     muxed_rx_st_parity_0     ;
   wire [7:0]     muxed_rx_st_parity_1     ;
   wire [7:0]     muxed_rx_st_parity_2     ;
   wire [7:0]     muxed_rx_st_parity_3     ;
   wire [31:0]    muxed_rx_st_parity       ;

   wire           muxed_rx_st_sop          ;
   wire           muxed_rx_st_eop          ;
   wire           muxed_rx_st_valid        ;
   wire [2:0]     muxed_rx_st_bar_range    ;
   wire [2:0]     muxed_rx_st_empty        ;
   wire           muxed_rx_st_par_err      ;
   wire           muxed_rx_st_vf_active    ;
   wire           muxed_rx_st_func_num     ;
   wire [6:0]     muxed_rx_st_vf_num       ;

   //---------------------------------------------------------------
   // Latching all input signals from PLD at interface boundary
   always @ (posedge clk or negedge rst_n)
     if (!rst_n)
       begin
           rx_st_sop_lat_0          <=   4'h0          ;
           rx_st_eop_lat_0          <=   1'h0          ;
           rx_st_data_lat_0         <=   256'h0        ;
           rx_st_valid_lat_0        <=   1'h0          ;
           rx_st_parity_lat_0       <=   32'h0         ;
           rx_st_bar_range_lat_0    <=   3'h0          ;
           rx_st_empty_lat_0        <=   3'h0          ;
           rx_st_par_err_lat_0      <=   1'h0          ;
           rx_st_vf_active_lat_0    <=   1'h0          ;
           rx_st_func_num_lat_0     <=   1'h0          ;
           rx_st_vf_num_lat_0       <=   7'h0          ;
       end
     else
       begin
            rx_st_sop_lat_0          <=   any_1lvl_rx_st_sop_flag  ? rx_st_sop_side_pipeline_1        :  rx_st_sop_undsk           ;
            rx_st_eop_lat_0          <=   any_1lvl_rx_st_sop_flag  ? rx_st_eop_side_pipeline_1        :  rx_st_eop_undsk           ;
            rx_st_data_lat_0         <=   any_1lvl_rx_st_sop_flag  ? rx_st_data_side_pipeline_1       :  rx_st_data_undsk          ;
            rx_st_valid_lat_0        <=   any_1lvl_rx_st_sop_flag  ? rx_st_valid_side_pipeline_1      :  rx_st_valid_undsk         ;
            rx_st_parity_lat_0       <=   any_1lvl_rx_st_sop_flag  ? rx_st_parity_side_pipeline_1     :  rx_st_parity_undsk        ;
            rx_st_bar_range_lat_0    <=   any_1lvl_rx_st_sop_flag  ? rx_st_bar_range_side_pipeline_1  :  rx_st_bar_range_undsk     ;
            rx_st_empty_lat_0        <=   any_1lvl_rx_st_sop_flag  ? rx_st_empty_side_pipeline_1      :  rx_st_empty_undsk         ;
            rx_st_par_err_lat_0      <=   any_1lvl_rx_st_sop_flag  ? rx_st_par_err_side_pipeline_1    :  rx_st_par_err_undsk       ;
            rx_st_vf_active_lat_0    <=   any_1lvl_rx_st_sop_flag  ? rx_st_vf_active_side_pipeline_1  :  rx_st_vf_active_undsk     ;
            rx_st_func_num_lat_0     <=   any_1lvl_rx_st_sop_flag  ? rx_st_func_num_side_pipeline_1   :  rx_st_func_num_undsk      ;
            rx_st_vf_num_lat_0       <=   any_1lvl_rx_st_sop_flag  ? rx_st_vf_num_side_pipeline_1     :  rx_st_vf_num_undsk        ;
       end // else: !if(~pld_rst_n)

   //Add new AVST deskew circuit piplining
   always @ (posedge clk or negedge rst_n)
     if (!rst_n)
       begin
           rx_st_sop_lat_1          <=   4'h0          ;
           rx_st_eop_lat_1          <=   1'h0          ;
           rx_st_data_lat_1         <=   256'h0        ;
           rx_st_valid_lat_1        <=   1'h0          ;
           rx_st_parity_lat_1       <=   32'h0         ;
           rx_st_bar_range_lat_1    <=   3'h0          ;
           rx_st_empty_lat_1        <=   3'h0          ;
           rx_st_par_err_lat_1      <=   1'h0          ;
           rx_st_vf_active_lat_1    <=   1'h0          ;
           rx_st_func_num_lat_1     <=   1'h0          ;
           rx_st_vf_num_lat_1       <=   7'h0          ;

           rx_st_sop_lat_2          <=   4'h0          ;
           rx_st_eop_lat_2          <=   1'h0          ;
           rx_st_data_lat_2         <=   256'h0        ;
           rx_st_valid_lat_2        <=   1'h0          ;
           rx_st_parity_lat_2       <=   32'h0         ;
           rx_st_bar_range_lat_2    <=   3'h0          ;
           rx_st_empty_lat_2        <=   3'h0          ;
           rx_st_par_err_lat_2      <=   1'h0          ;
           rx_st_vf_active_lat_2    <=   1'h0          ;
           rx_st_func_num_lat_2     <=   1'h0          ;
           rx_st_vf_num_lat_2       <=   7'h0          ;
       end
     else
       begin

           rx_st_sop_lat_1          <=  rx_st_sop_lat_0               ;
           rx_st_eop_lat_1          <=  rx_st_eop_lat_0               ;
           rx_st_data_lat_1         <=  rx_st_data_lat_0              ;
           rx_st_valid_lat_1        <=  rx_st_valid_lat_0             ;
           rx_st_parity_lat_1       <=  rx_st_parity_lat_0            ;
           rx_st_bar_range_lat_1    <=  rx_st_bar_range_lat_0         ;
           rx_st_empty_lat_1        <=  rx_st_empty_lat_0             ;
           rx_st_par_err_lat_1      <=  rx_st_par_err_lat_0           ;
           rx_st_vf_active_lat_1    <=  rx_st_vf_active_lat_0         ;
           rx_st_func_num_lat_1     <=  rx_st_func_num_lat_0          ;
           rx_st_vf_num_lat_1       <=  rx_st_vf_num_lat_0            ;

           rx_st_sop_lat_2          <=  rx_st_sop_lat_1               ;
           rx_st_eop_lat_2          <=  rx_st_eop_lat_1               ;
           rx_st_data_lat_2         <=  rx_st_data_lat_1              ;
           rx_st_valid_lat_2        <=  rx_st_valid_lat_1             ;
           rx_st_parity_lat_2       <=  rx_st_parity_lat_1            ;
           rx_st_bar_range_lat_2    <=  rx_st_bar_range_lat_1         ;
           rx_st_empty_lat_2        <=  rx_st_empty_lat_1             ;
           rx_st_par_err_lat_2      <=  rx_st_par_err_lat_1           ;
           rx_st_vf_active_lat_2    <=  rx_st_vf_active_lat_1         ;
           rx_st_func_num_lat_2     <=  rx_st_func_num_lat_1          ;
           rx_st_vf_num_lat_2       <=  rx_st_vf_num_lat_1            ;
        end

    //---------------------------------------------------------------
    // Latching all input signals from PLD at interface boundary
    always @ (posedge clk or negedge rst_n)
      if (!rst_n)
        begin

            rx_st_sop_side_pipeline_0          <=   4'h0          ;
            rx_st_eop_side_pipeline_0          <=   1'h0          ;
            rx_st_data_side_pipeline_0         <=   256'h0        ;
            rx_st_valid_side_pipeline_0        <=   1'h0          ;
            rx_st_parity_side_pipeline_0       <=   32'h0         ;
            rx_st_bar_range_side_pipeline_0    <=   3'h0          ;
            rx_st_empty_side_pipeline_0        <=   3'h0          ;
            rx_st_par_err_side_pipeline_0      <=   1'h0          ;
            rx_st_vf_active_side_pipeline_0    <=   1'h0          ;
            rx_st_func_num_side_pipeline_0     <=   1'h0          ;
            rx_st_vf_num_side_pipeline_0       <=   7'h0          ;

            rx_st_sop_side_pipeline_1          <=   4'h0          ;
            rx_st_eop_side_pipeline_1          <=   1'h0          ;
            rx_st_data_side_pipeline_1         <=   256'h0        ;
            rx_st_valid_side_pipeline_1        <=   1'h0          ;
            rx_st_parity_side_pipeline_1       <=   32'h0         ;
            rx_st_bar_range_side_pipeline_1    <=   3'h0          ;
            rx_st_empty_side_pipeline_1        <=   3'h0          ;
            rx_st_par_err_side_pipeline_1      <=   1'h0          ;
            rx_st_vf_active_side_pipeline_1    <=   1'h0          ;
            rx_st_func_num_side_pipeline_1     <=   1'h0          ;
            rx_st_vf_num_side_pipeline_1       <=   7'h0          ;
        end
      else
        begin
            rx_st_sop_side_pipeline_0          <=   rx_st_sop_undsk           ;
            rx_st_eop_side_pipeline_0          <=   rx_st_eop_undsk           ;
            rx_st_data_side_pipeline_0         <=   rx_st_data_undsk          ;
            rx_st_valid_side_pipeline_0        <=   rx_st_valid_undsk         ;
            rx_st_parity_side_pipeline_0       <=   rx_st_parity_undsk        ;
            rx_st_bar_range_side_pipeline_0    <=   rx_st_bar_range_undsk     ;
            rx_st_empty_side_pipeline_0        <=   rx_st_empty_undsk         ;
            rx_st_par_err_side_pipeline_0      <=   rx_st_par_err_undsk       ;
            rx_st_vf_active_side_pipeline_0    <=   rx_st_vf_active_undsk     ;
            rx_st_func_num_side_pipeline_0     <=   rx_st_func_num_undsk      ;
            rx_st_vf_num_side_pipeline_0       <=   rx_st_vf_num_undsk        ;

            rx_st_sop_side_pipeline_1          <=  rx_st_sop_side_pipeline_0               ;
            rx_st_eop_side_pipeline_1          <=  rx_st_eop_side_pipeline_0               ;
            rx_st_data_side_pipeline_1         <=  rx_st_data_side_pipeline_0              ;
            rx_st_valid_side_pipeline_1        <=  rx_st_valid_side_pipeline_0             ;
            rx_st_parity_side_pipeline_1       <=  rx_st_parity_side_pipeline_0            ;
            rx_st_bar_range_side_pipeline_1    <=  rx_st_bar_range_side_pipeline_0         ;
            rx_st_empty_side_pipeline_1        <=  rx_st_empty_side_pipeline_0             ;
            rx_st_par_err_side_pipeline_1      <=  rx_st_par_err_side_pipeline_0           ;
            rx_st_vf_active_side_pipeline_1    <=  rx_st_vf_active_side_pipeline_0         ;
            rx_st_func_num_side_pipeline_1     <=  rx_st_func_num_side_pipeline_0          ;
            rx_st_vf_num_side_pipeline_1       <=  rx_st_vf_num_side_pipeline_0            ;

         end

   //Flag the first occurance SOP on any lane after reset
   always @ (posedge clk or negedge rst_n)
      if (!rst_n)
      begin
          any_1lvl_rx_st_sop_flag <= 1'b0 ;
      end
      else
      begin
         any_1lvl_rx_st_sop_flag <=   any_1lvl_rx_st_sop_flag ? 1'b1 :  any_1lvl_rx_st_sop ;
      end


    //--------------------------
    // AVST deskew control logic
    // NOTE: rx_st_data and rx_st_parity are split evenly
    assign all_1lvl_rx_st_sop = &rx_st_sop_lat_0;
    assign all_2lvl_rx_st_sop = &(rx_st_sop_lat_0 | rx_st_sop_lat_1);
    assign all_3lvl_rx_st_sop = &(rx_st_sop_lat_0 | rx_st_sop_lat_1| rx_st_sop_lat_2);
    assign any_3lvl_rx_st_sop = |rx_st_sop_lat_2;
    assign any_2lvl_rx_st_sop = |rx_st_sop_lat_1;
    assign any_1lvl_rx_st_sop = |rx_st_sop_lat_0;

    //set a sticky deskew flag, if this data group detects an SOP, but not all SOP's are detected across the four AIB channels
    assign set_dly_rx_st_sop  = { (rx_st_sop_lat_1[3] & any_3lvl_rx_st_sop & any_1lvl_rx_st_sop) | (rx_st_sop_lat_2[3] & ~any_1lvl_rx_st_sop & any_2lvl_rx_st_sop),
                                  (rx_st_sop_lat_1[2] & any_3lvl_rx_st_sop & any_1lvl_rx_st_sop) | (rx_st_sop_lat_2[2] & ~any_1lvl_rx_st_sop & any_2lvl_rx_st_sop),
                                  (rx_st_sop_lat_1[1] & any_3lvl_rx_st_sop & any_1lvl_rx_st_sop) | (rx_st_sop_lat_2[1] & ~any_1lvl_rx_st_sop & any_2lvl_rx_st_sop),
                                  (rx_st_sop_lat_1[0] & any_3lvl_rx_st_sop & any_1lvl_rx_st_sop) | (rx_st_sop_lat_2[0] & ~any_1lvl_rx_st_sop & any_2lvl_rx_st_sop)
                                 };
    assign set_dly2_rx_st_sop = { rx_st_sop_lat_2[3] & any_1lvl_rx_st_sop,
                                  rx_st_sop_lat_2[2] & any_1lvl_rx_st_sop,
                                  rx_st_sop_lat_2[1] & any_1lvl_rx_st_sop,
                                  rx_st_sop_lat_2[0] & any_1lvl_rx_st_sop
                                 };

   always @(negedge rst_n or posedge clk)
     if (!rst_n)
       begin
           dly_rx_st_sop  <= 4'b0;
           dly2_rx_st_sop <= 4'b0;
       end
     else
       begin
           dly_rx_st_sop  <= {set_dly_rx_st_sop[3] & ~rx_dsk_eval_done? 1'b1 : dly_rx_st_sop[3],
                              set_dly_rx_st_sop[2] & ~rx_dsk_eval_done? 1'b1 : dly_rx_st_sop[2],
                              set_dly_rx_st_sop[1] & ~rx_dsk_eval_done? 1'b1 : dly_rx_st_sop[1],
                              set_dly_rx_st_sop[0] & ~rx_dsk_eval_done? 1'b1 : dly_rx_st_sop[0]
                              };
           dly2_rx_st_sop <= {set_dly2_rx_st_sop[3] & ~rx_dsk_eval_done? 1'b1 : dly2_rx_st_sop[3],
                              set_dly2_rx_st_sop[2] & ~rx_dsk_eval_done? 1'b1 : dly2_rx_st_sop[2],
                              set_dly2_rx_st_sop[1] & ~rx_dsk_eval_done? 1'b1 : dly2_rx_st_sop[1],
                              set_dly2_rx_st_sop[0] & ~rx_dsk_eval_done? 1'b1 : dly2_rx_st_sop[0]
                              };
       end

    //with the deskew eval mechanism, we should be able to tell how many deskew level we need by the time when the actual packet is received
    assign muxed_rx_st_data_0[63:0] = dly2_rx_st_sop[0] ? rx_st_data_lat_2[ 63:  0] : dly_rx_st_sop[0] ? rx_st_data_lat_1[ 63:  0] : rx_st_data_lat_0[ 63: 0];
    assign muxed_rx_st_data_1[63:0] = dly2_rx_st_sop[1] ? rx_st_data_lat_2[127: 64] : dly_rx_st_sop[1] ? rx_st_data_lat_1[127: 64] : rx_st_data_lat_0[127:64];
    assign muxed_rx_st_data_2[63:0] = dly2_rx_st_sop[2] ? rx_st_data_lat_2[191:128] : dly_rx_st_sop[2] ? rx_st_data_lat_1[191:128] : rx_st_data_lat_0[191:128];
    assign muxed_rx_st_data_3[63:0] = dly2_rx_st_sop[3] ? rx_st_data_lat_2[255:192] : dly_rx_st_sop[3] ? rx_st_data_lat_1[255:192] : rx_st_data_lat_0[255:192];
    assign muxed_rx_st_data[255:0]  = {muxed_rx_st_data_3[63:0],muxed_rx_st_data_2[63:0],muxed_rx_st_data_1[63:0],muxed_rx_st_data_0[63:0]};

    assign muxed_rx_st_parity_0[7:0] = dly2_rx_st_sop[0] ? rx_st_parity_lat_2[ 7: 0]: dly_rx_st_sop[0] ? rx_st_parity_lat_1[ 7: 0] : rx_st_parity_lat_0[ 7: 0];
    assign muxed_rx_st_parity_1[7:0] = dly2_rx_st_sop[1] ? rx_st_parity_lat_2[15: 8]: dly_rx_st_sop[1] ? rx_st_parity_lat_1[15: 8] : rx_st_parity_lat_0[15: 8];
    assign muxed_rx_st_parity_2[7:0] = dly2_rx_st_sop[2] ? rx_st_parity_lat_2[23:16]: dly_rx_st_sop[2] ? rx_st_parity_lat_1[23:16] : rx_st_parity_lat_0[23:16];
    assign muxed_rx_st_parity_3[7:0] = dly2_rx_st_sop[3] ? rx_st_parity_lat_2[31:24]: dly_rx_st_sop[3] ? rx_st_parity_lat_1[31:24] : rx_st_parity_lat_0[31:24];
    assign muxed_rx_st_parity        = {muxed_rx_st_parity_3[7:0],muxed_rx_st_parity_2[7:0],muxed_rx_st_parity_1[7:0],muxed_rx_st_parity_0[7:0]};

    //should always use the channel0 sop since it's in sync with rx_st_valid
    assign muxed_rx_st_sop       = (dly2_rx_st_sop[0])? rx_st_sop_lat_2[0] : (dly_rx_st_sop[0])? rx_st_sop_lat_1[0] : rx_st_sop_lat_0[0];

    assign muxed_rx_st_eop       = dly2_rx_st_sop[0] ? rx_st_eop_lat_2   :  dly_rx_st_sop[0] ? rx_st_eop_lat_1   : rx_st_eop_lat_0;
    assign muxed_rx_st_valid     = dly2_rx_st_sop[0] ? rx_st_valid_lat_2 :  dly_rx_st_sop[0] ? rx_st_valid_lat_1 : rx_st_valid_lat_0;
    assign muxed_rx_st_vf_active = dly2_rx_st_sop[0] ? rx_st_vf_active_lat_2 :  dly_rx_st_sop[0] ? rx_st_vf_active_lat_1 : rx_st_vf_active_lat_0;
    assign muxed_rx_st_par_err   = dly2_rx_st_sop[0] ? rx_st_par_err_lat_2 :  dly_rx_st_sop[0] ? rx_st_par_err_lat_1 : rx_st_par_err_lat_0;
    assign muxed_rx_st_bar_range = dly2_rx_st_sop[0] ? rx_st_bar_range_lat_2 :  dly_rx_st_sop[0] ? rx_st_bar_range_lat_1 : rx_st_bar_range_lat_0;
    assign muxed_rx_st_empty     = dly2_rx_st_sop[0] ? rx_st_empty_lat_2 :  dly_rx_st_sop[0] ? rx_st_empty_lat_1 : rx_st_empty_lat_0;
    assign muxed_rx_st_func_num  = dly2_rx_st_sop[0] ? rx_st_func_num_lat_2 :  dly_rx_st_sop[0] ? rx_st_func_num_lat_1 : rx_st_func_num_lat_0;
    assign muxed_rx_st_vf_num    = dly2_rx_st_sop[0] ? rx_st_vf_num_lat_2 :  dly_rx_st_sop[0] ? rx_st_vf_num_lat_1 : rx_st_vf_num_lat_0;

    //mux the final aligned output
    assign rx_st_sop_dsk         =  ~ rx_dsk_eval_done ? 1'b0     : muxed_rx_st_sop ;
    assign rx_st_eop_dsk         =  ~ rx_dsk_eval_done ? 1'b0     : muxed_rx_st_eop ;
    assign rx_st_data_dsk        =  ~ rx_dsk_eval_done ? 256'h0   : muxed_rx_st_data[255:0] ;
    assign rx_st_valid_dsk       =  ~ rx_dsk_eval_done ? 1'b0     : muxed_rx_st_valid ;
    assign rx_st_parity_dsk      =  ~ rx_dsk_eval_done ? 32'h0    : muxed_rx_st_parity[31:0] ;
    assign rx_st_bar_range_dsk   =  ~ rx_dsk_eval_done ? 3'b000   : muxed_rx_st_bar_range ;
    assign rx_st_empty_dsk       =  ~ rx_dsk_eval_done ? 3'b000   : muxed_rx_st_empty ;
    assign rx_st_par_err_dsk     =  ~ rx_dsk_eval_done ? 1'b0     : muxed_rx_st_par_err ;
    assign rx_st_vf_active_dsk   =  ~ rx_dsk_eval_done ? 1'b0     : muxed_rx_st_vf_active ;
    assign rx_st_func_num_dsk    =  ~ rx_dsk_eval_done ? 1'b0     : muxed_rx_st_func_num ;
    assign rx_st_vf_num_dsk      =  ~ rx_dsk_eval_done ? 7'h0     : muxed_rx_st_vf_num ;


    // Error is flagged if two levels of deskew buffer is not enough
    always @(negedge rst_n or posedge clk)
      if (!rst_n)
        begin
            rx_dsk_eval_done <= 1'b0;
            rx_dsk_status    <= 2'b00;
        end
      else
        begin
            rx_dsk_eval_done <=  (any_3lvl_rx_st_sop)  ? 1'b1 : rx_dsk_eval_done;
            rx_dsk_status    <=  ~rx_dsk_eval_done ? (( ~(&rx_st_sop_lat_2) & ~all_3lvl_rx_st_sop) ? 2'b11 : //indicate deskew error happens
                                                     (|set_dly2_rx_st_sop) ? 2'b10: //two-level of deskew buffer needed
                                                     (|set_dly_rx_st_sop)  ? 2'b01: //one-level of deskew buffer needed
                                                     2'b00): rx_dsk_status;         //no deskew mechanism needed
        end
endmodule



