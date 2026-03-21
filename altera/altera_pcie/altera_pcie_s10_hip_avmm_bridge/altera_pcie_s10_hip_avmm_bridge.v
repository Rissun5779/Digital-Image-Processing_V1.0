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

//`default_nettype none


module altera_pcie_s10_hip_avmm_bridge # (

  // PCIe S10 AVMM Bridge only parameters
  parameter                   enable_a2p_interrupt_hwtcl                                                      = 0,
  parameter                   enable_advanced_interrupt_hwtcl                                                 = 0,

  parameter                   dma_enabled_hwtcl                                                               = 1,           // 0 - not enabled,  1 - enabled
  parameter                   dma_controller_enabled_hwtcl                                                    = 1,           // 0 - not enabled,  1 - enabled
  parameter                   avmm_addr_width_hwtcl                                                           = 32,          // 32(address translation enabled) or 64
  parameter                   txs_enabled_hwtcl                                                               = 1,           // 0 - not enabled,  1 - enabled
  parameter                   txs_address_width_hwtcl                                                         = 32,
  parameter                   hptxs_enabled_hwtcl                                                             = 1,           // 0 - not enabled,  1 - enabled
  parameter                   hptxs_address_width_hwtcl                                                       = 32,
  parameter                   hptxs_address_translation_table_address_width_hwtcl                             = 9,           // [0-9] are allowed. e.g. 9:512 entries
  parameter                   hptxs_address_translation_window_address_width_hwtcl                            = 12,          // [12-(32-hptxs_address_translation_table_address_width_hwtcl)] are allowed. e.g. 12:4KB window


  parameter                   pf0_bar0_enable_rxm_burst_hwtcl                                                 = 0,
  parameter                   pf0_bar1_enable_rxm_burst_hwtcl                                                 = 0,
  parameter                   pf0_bar2_enable_rxm_burst_hwtcl                                                 = 0,
  parameter                   pf0_bar3_enable_rxm_burst_hwtcl                                                 = 0,
  parameter                   pf0_bar4_enable_rxm_burst_hwtcl                                                 = 0,
  parameter                   pf0_bar5_enable_rxm_burst_hwtcl                                                 = 0,

  // PCIe S10 AST parameters
  //Attributes IPTCL
  //Virtual Attributes
  parameter                   powerdown_mode                                                                  = "powerup",
  parameter                   func_mode                                                                       = "disable",
  parameter                   sup_mode                                                                        = "user_mode",
  parameter                   virtual_rp_ep_mode                                                              = "ep",
  parameter                   virtual_link_width                                                              = "x16",
  parameter                   virtual_link_rate                                                               = "gen3",
  parameter                   virtual_maxpayload_size                                                         = "max_payload_1024",
  parameter                   virtual_gen2_pma_pll_usage                                                      = "not_applicable",
  parameter                   virtual_hrdrstctrl_en                                                           = "enable",
  parameter                   virtual_uc_calibration_en                                                       = "enable",
  parameter                   virtual_txeq_mode                                                               = "eq_disable",
  parameter                   virtual_pf1_enable                                                              = "disable",                            // this enables PF1.  PF0 is always enabled.
  parameter                   virtual_pf0_sriov_enable                                                        = "disable",
  parameter                   virtual_pf1_sriov_enable                                                        = "disable",

  parameter                   virtual_pf0_msix_enable                                                         = "disable",                            // must enable this if PF has VFs
  parameter                   virtual_pf0_msi_enable                                                          = "disable",
  parameter                   virtual_pf0_sn_cap_enable                                                       = "disable",
  parameter                   virtual_pf0_tph_cap_enable                                                      = "disable",
  parameter                   virtual_pf0_ats_cap_enable                                                      = "disable",                            // must enable ATS in PF if ATS is enabled in VF
  parameter                   virtual_pf0_user_vsec_cap_enable                                                = "disable",
  parameter  [15:0]           virtual_pf0_sriov_num_vf_non_ari                                                = 16'b0000000000000000,                 // SRIOV num_vf field to be used when in non-ARI hierarchy
  parameter                   virtual_pf0_sriov_vf_bar0_enabled                                               = "disable",
  parameter                   virtual_pf0_sriov_vf_bar1_enabled                                               = "disable",                            // set to disable when part of 64-bit BAR
  parameter                   virtual_pf0_sriov_vf_bar2_enabled                                               = "disable",
  parameter                   virtual_pf0_sriov_vf_bar3_enabled                                               = "disable",                            // set to disable when part of 64-bit BAR
  parameter                   virtual_pf0_sriov_vf_bar4_enabled                                               = "disable",
  parameter                   virtual_pf0_sriov_vf_bar5_enabled                                               = "disable",                            // set to disable when part of 64-bit BAR
  parameter                   virtual_vf1_pf0_user_vsec_cap_enable                                            = "disable",
  parameter                   virtual_vf1_pf0_tph_cap_enable                                                  = "disable",
  parameter                   virtual_vf1_pf0_ats_cap_enable                                                  = "disable",


  parameter                   virtual_pf1_msix_enable                                                         = "disable",                            // must enable this if PF has VFs
  parameter                   virtual_pf1_msi_enable                                                          = "disable",
  parameter                   virtual_pf1_sn_cap_enable                                                       = "disable",
  parameter                   virtual_pf1_tph_cap_enable                                                      = "disable",
  parameter                   virtual_pf1_ats_cap_enable                                                      = "disable",                            // must enable ATS in PF if ATS is enabled in VF
  parameter                   virtual_pf1_user_vsec_cap_enable                                                = "disable",
  parameter  [15:0]           virtual_pf1_sriov_num_vf_non_ari                                                = 16'b0000000000000000,                 // SRIOV num_vf field to be used when in non-ARI hierarchy
  parameter                   virtual_pf1_sriov_vf_bar0_enabled                                               = "disable",
  parameter                   virtual_pf1_sriov_vf_bar1_enabled                                               = "disable",                            // set to disable when part of 64-bit BAR
  parameter                   virtual_pf1_sriov_vf_bar2_enabled                                               = "disable",
  parameter                   virtual_pf1_sriov_vf_bar3_enabled                                               = "disable",                            // set to disable when part of 64-bit BAR
  parameter                   virtual_pf1_sriov_vf_bar4_enabled                                               = "disable",
  parameter                   virtual_pf1_sriov_vf_bar5_enabled                                               = "disable",                            // set to disable when part of 64-bit BAR
  parameter                   virtual_vf1_pf1_user_vsec_cap_enable                                            = "disable",
  parameter                   virtual_vf1_pf1_tph_cap_enable                                                  = "disable",
  parameter                   virtual_vf1_pf1_ats_cap_enable                                                  = "disable",

  parameter                   virtual_drop_vendor0_msg                                                        = "false",
  parameter                   virtual_drop_vendor1_msg                                                        = "false",
  parameter                   virtual_phase23_txpreset                                                        = "preset7",

  //  hard reset controller Attributes
  //-------------------------------
  parameter                   hrc_pma_perst_en                                                                = "level",                              //  hard reset controller - enables PERSTN fpr pma reset gen
  parameter                   hrc_en_pcs_fifo_err                                                             = "false",                              //  hard reset controller  - enables detection of elastic FIFO errors for PCS reset generation
  parameter                   hrc_pll_perst_en                                                                = "disable",
  parameter                   hrc_soft_rstctrl_clr                                                            = "false",                              //  hard reset controller - enables PLD inputs to request resets from the hard reset controller
  parameter                   hrc_soft_rstctrl_en                                                             = "disable",                            //  hard reset controller - enables the soft reset controller
  parameter                   clrhip_not_rst_sticky                                                           = "false",                              //  hard reset controller -  determines if clrhip_rst input from PLD also clears sticky bits or not

  //  pld adaptor Attributes
  //-------------------------------
  parameter                   pld_tx_parity_ena                                                               = "enable",                             // enables AVST TX parity
  parameter                   pld_rx_parity_ena                                                               = "enable",                             // enables AVST RX parity
  parameter                   pld_rx_posted_bufflimit_bypass                                                  = "false",                              // disables the Posted mask mechanism on AVST-RX
  parameter                   pld_rx_cpl_bufflimit_bypass                                                     = "false",                              // disables the NP mask mechanism on AVST-RX
  parameter                   pld_rx_np_bufflimit_bypass                                                      = "false",                              // disables the CPL mask mechanism on AVST-RX
  parameter                   enable_rx_buffer_limit_ports_hwtcl                                              = 0,                                    // Exports RX Buffer Limits ports to toplevel

  //  vsec  Attributes
  //-------------------------------
  parameter                   cvp_data_encrypted                                                              = "false",                              // cvp_status POF encrypted
  parameter                   cvp_extra                                                                       = "false",
  parameter  [2:0]            cvp_intf_reset_ctl                                                              = 3'b010,
  parameter                   cvp_data_compressed                                                             = "false",                              // cvp status POF compressed
  parameter  [31:0]           cvp_jtag0                                                                       = 32'b00000000000000000000000000000000, // jtag silicon ID.  CVP driver can use this to determine POF matches IOCSR.
  parameter  [31:0]           cvp_jtag1                                                                       = 32'b00000000000000000000000000000000, // jtag silicon ID.  CVP driver can use this to determine POF matches IOCSR.
  parameter  [31:0]           cvp_jtag2                                                                       = 32'b00000000000000000000000000000000, // jtag silicon ID.  CVP driver can use this to determine POF matches IOCSR.
  parameter  [31:0]           cvp_jtag3                                                                       = 32'b00000000000000000000000000000000, // jtag silicon ID.  CVP driver can use this to determine POF matches IOCSR.
  parameter  [15:0]           cvp_user_id                                                                     = 16'b0000000000000000,                 // user configurable device/board ID used for POF selection

  // crs_control  Attributes
  //------------------------------
  parameter                   cvp_irq_en                                                                      = "false",                              // crs_control - cvp command bit is enabled to trigger SSM IRQ when this bit is 1

  // lane flip control  Attributes
  //------------------------------
  parameter                   rx_lane_flip_en                                                                 = "false",                              // enable HIP to do manual lane flip on RX side
  parameter                   tx_lane_flip_en                                                                 = "false",                              // enable HIP to do manual lane flip on TX side

  // miscellaneous Phy control Attributes
  //-------------------------------
  parameter  [25:0]           pipe_ctrl                                                                       = 26'b00010000000010101000101010,

  // miscellaneous Phy control Attributes
  //-------------------------------
  parameter  [5:0]            k_phy_misc_ctrl_rsvd_0_5                                                        = 6'b000000,

  // use gpio pin to drive SSM IRQ Attributes(one bit per pin)
  //-------------------------------
  parameter  [7:0]            gpio_irq                                                                        = 8'b00000000,

  // diagnostic  Attributes
  //-------------------------------
  parameter                   test_in_override                                                                = "false",

  // ecc Attributes
  //-------------------------------
  parameter                   valid_ecc_err_rpt_en                                                            = "true",

  // diagnostic  Attributes
  //-------------------------------
  parameter  [31:0]           test_in_lo                                                                      = 32'b00000000000000000000000000000000,
  parameter  [31:0]           test_in_hi                                                                      = 32'b00000000000000000000000000000000,

  //  ssm irq Attributes
  //-------------------------------
  parameter  [5:0]            irq_misc_ctrl                                                                   = 6'b000000,

  // pf0_type0_hdr Attributes
  //-------------------------------
  parameter  [15:0]           pf0_pci_type0_vendor_id                                                         = 16'b0001011011000011,
  parameter  [15:0]           pf0_pci_type0_device_id                                                         = 16'b1010101111001101,
  parameter  [7:0]            pf0_program_interface                                                           = 8'b00000000,
  parameter  [7:0]            pf0_subclass_code                                                               = 8'b00000000,
  parameter  [7:0]            pf0_base_class_code                                                             = 8'b00000000,
  parameter                   pf0_pci_type0_bar0_enabled                                                      = "enable",
  parameter                   pf0_bar0_type                                                                   = "pf0_bar0_mem32",
  parameter                   pf0_bar0_prefetch                                                               = "false",
  parameter                   pf0_pci_type0_bar1_enabled                                                      = "enable",
  parameter                   pf0_pci_type0_bar2_enabled                                                      = "enable",
  parameter                   pf0_bar2_type                                                                   = "pf0_bar2_mem32",
  parameter                   pf0_bar2_prefetch                                                               = "false",
  parameter                   pf0_pci_type0_bar3_enabled                                                      = "enable",
  parameter                   pf0_pci_type0_bar4_enabled                                                      = "enable",
  parameter                   pf0_bar4_type                                                                   = "pf0_bar4_mem32",
  parameter                   pf0_bar4_prefetch                                                               = "false",
  parameter                   pf0_pci_type0_bar5_enabled                                                      = "enable",
  parameter  [31:0]           pf0_cardbus_cis_pointer                                                         = 32'b00000000000000000000000000000000,
  parameter  [15:0]           pf0_subsys_vendor_id                                                            = 16'b0000000000000000,
  parameter  [15:0]           pf0_subsys_dev_id                                                               = 16'b0000000000000000,
  parameter                   pf0_rom_bar_enable                                                              = "disable",
  parameter                   pf0_rom_bar_enabled                                                             = "enable",
  parameter                   pf0_rp_rom_bar_enabled                                                          = "enable",
  parameter  [20:0]           pf0_rp_rom_mask                                                                 = 21'b000000000000000000000,
  parameter                   pf0_int_pin                                                                     = "pf0_inta",
  parameter                   pf0_bar0_address_width_hwtcl                                                    = 1,
  parameter                   pf0_bar1_address_width_hwtcl                                                    = 1,
  parameter                   pf0_bar2_address_width_hwtcl                                                    = 1,
  parameter                   pf0_bar3_address_width_hwtcl                                                    = 1,
  parameter                   pf0_bar4_address_width_hwtcl                                                    = 1,
  parameter                   pf0_bar5_address_width_hwtcl                                                    = 1,
  parameter                   pf0_expansion_base_address_register_hwtcl                                       = 32'h0,

  // pf0_sriov_cap Attributes
  //------------------------------        -
  parameter  [15:0]           pf0_shadow_sriov_vf_stride_ari_cs2                                              = 16'b0000000000000010,
  parameter  [15:0]           pf0_sriov_vf_offset_ari_cs2                                                     = 16'b0000000000000010,
  parameter  [15:0]           pf0_sriov_vf_offset_nonari                                                      = 16'b0000000100000000,
  parameter  [15:0]           pf0_sriov_vf_stride_nonari                                                      = 16'b0000000100000000,
  parameter  [15:0]           pf0_sriov_vf_device_id                                                          = 16'b1010101111001101,
  parameter  [31:0]           pf0_sriov_sup_page_size                                                         = 32'b00000000000000000000010101010011,
  parameter  [31:0]           pf0_sriov_vf_bar0_mask                                                          = 32'b00000000000000000000000000000000,
  parameter                   pf0_sriov_vf_bar0_type                                                          = "pf0_sriov_vf_bar0_mem32",
  parameter                   pf0_sriov_vf_bar0_prefetch                                                      = "false",
  parameter  [31:0]           pf0_sriov_vf_bar1_mask                                                          = 32'b00000000000000000000000000000000,
  parameter  [31:0]           pf0_sriov_vf_bar2_mask                                                          = 32'b00000000000000000000000000000000,
  parameter                   pf0_sriov_vf_bar2_type                                                          = "pf0_sriov_vf_bar2_mem32",
  parameter                   pf0_sriov_vf_bar2_prefetch                                                      = "false",
  parameter  [31:0]           pf0_sriov_vf_bar3_mask                                                          = 32'b00000000000000000000000000000000,
  parameter  [31:0]           pf0_sriov_vf_bar4_mask                                                          = 32'b00000000000000000000000000000000,
  parameter                   pf0_sriov_vf_bar4_type                                                          = "pf0_sriov_vf_bar4_mem32",
  parameter                   pf0_sriov_vf_bar4_prefetch                                                      = "false",
  parameter  [31:0]           pf0_sriov_vf_bar5_mask                                                          = 32'b00000000000000000000000000000000,

  // pf0_spcie_cap Attributes
  //------------------------------        -
  parameter  [3:0]            pf0_usp_tx_preset3                                                              = 4'b1111,
  parameter  [3:0]            pf0_usp_tx_preset1                                                              = 4'b1111,
  parameter  [3:0]            pf0_usp_tx_preset6                                                              = 4'b1111,
  parameter  [3:0]            pf0_usp_tx_preset9                                                              = 4'b1111,
  parameter  [3:0]            pf0_usp_tx_preset15                                                             = 4'b1111,
  parameter  [3:0]            pf0_usp_tx_preset12                                                             = 4'b1111,
  parameter  [3:0]            pf0_usp_tx_preset0                                                              = 4'b1111,
  parameter  [3:0]            pf0_usp_tx_preset4                                                              = 4'b1111,
  parameter  [3:0]            pf0_usp_tx_preset2                                                              = 4'b1111,
  parameter  [3:0]            pf0_usp_tx_preset8                                                              = 4'b1111,
  parameter  [3:0]            pf0_usp_tx_preset10                                                             = 4'b1111,
  parameter  [3:0]            pf0_usp_tx_preset7                                                              = 4'b1111,
  parameter  [3:0]            pf0_usp_tx_preset5                                                              = 4'b1111,
  parameter  [3:0]            pf0_usp_tx_preset13                                                             = 4'b1111,
  parameter  [3:0]            pf0_usp_tx_preset11                                                             = 4'b1111,
  parameter  [3:0]            pf0_usp_tx_preset14                                                             = 4'b1111,

  parameter  [2:0]            pf0_usp_rx_preset_hint5                                                         = 3'b111,
  parameter  [2:0]            pf0_usp_rx_preset_hint8                                                         = 3'b111,
  parameter  [2:0]            pf0_usp_rx_preset_hint10                                                        = 3'b111,
  parameter  [2:0]            pf0_usp_rx_preset_hint11                                                        = 3'b111,
  parameter  [2:0]            pf0_usp_rx_preset_hint0                                                         = 3'b111,
  parameter  [2:0]            pf0_usp_rx_preset_hint12                                                        = 3'b111,
  parameter  [2:0]            pf0_usp_rx_preset_hint1                                                         = 3'b111,
  parameter  [2:0]            pf0_usp_rx_preset_hint3                                                         = 3'b111,
  parameter  [2:0]            pf0_usp_rx_preset_hint7                                                         = 3'b111,
  parameter  [2:0]            pf0_usp_rx_preset_hint4                                                         = 3'b111,
  parameter  [2:0]            pf0_usp_rx_preset_hint14                                                        = 3'b111,
  parameter  [2:0]            pf0_usp_rx_preset_hint15                                                        = 3'b111,
  parameter  [2:0]            pf0_usp_rx_preset_hint6                                                         = 3'b111,
  parameter  [2:0]            pf0_usp_rx_preset_hint2                                                         = 3'b111,
  parameter  [2:0]            pf0_usp_rx_preset_hint13                                                        = 3'b111,
  parameter  [2:0]            pf0_usp_rx_preset_hint9                                                         = 3'b111,

  // pf0_sn_cap Attributes
  //------------------------------        -
  parameter  [31:0]           pf0_sn_ser_num_reg_1_dw                                                         = 32'b00000000000000000000000000000000,
  parameter  [31:0]           pf0_sn_ser_num_reg_2_dw                                                         = 32'b00000000000000000000000000000000,

  // pf0_pm_cap Attributes
  //------------------------------        -
  parameter                   pf0_dsi                                                                         = "pf0_not_required",
  parameter  [2:0]            pf0_aux_curr                                                                    = 3'b111,
  parameter                   pf0_d1_support                                                                  = "pf0_d1_not_supported",
  parameter                   pf0_d2_support                                                                  = "pf0_d2_not_supported",
  parameter  [4:0]            pf0_pme_support                                                                 = 5'b11011,
  parameter                   pf0_no_soft_rst                                                                 = "pf0_internally_reset",



  // pf0_pcie_cap Attributes
  //------------------------------        -
  parameter                   pf0_pcie_slot_imp                                                               = "pf0_not_implemented",
  parameter  [4:0]            pf0_pcie_int_msg_num                                                            = 5'b00000,
  parameter                   pf0_pcie_cap_ext_tag_en                                                         = "false",
  parameter                   pf0_pcie_cap_ext_tag_supp                                                       = "pf0_supported",
  parameter  [2:0]            pf0_pcie_cap_ep_l0s_accpt_latency                                               = 3'b000,
  parameter  [2:0]            pf0_pcie_cap_ep_l1_accpt_latency                                                = 3'b000,
  parameter                   pf0_pcie_cap_flr_cap                                                            = "pf0_capable",
  parameter                   pf0_pcie_cap_initiate_flr                                                       = "false",
  parameter  [2:0]            pf0_pcie_cap_l0s_exit_latency_commclk_dis                                       = 3'b111,
  parameter  [2:0]            pf0_pcie_cap_l1_exit_latency_commclk_dis                                        = 3'b111,
  parameter  [7:0]            pf0_pcie_cap_port_num                                                           = 8'b00000000,
  parameter  [2:0]            pf0_pcie_cap_l0s_exit_latency_commclk_ena_cs2                                   = 3'b111,
  parameter  [2:0]            pf0_pcie_cap_l1_exit_latency_commclk_ena_cs2                                    = 3'b111,
  parameter                   pf0_pcie_cap_rcb                                                                = "pf0_rcb_64",
  parameter                   pf0_pcie_cap_slot_clk_config                                                    = "false",
  parameter                   pf0_pcie_cap_attention_indicator_button                                         = "false",
  parameter                   pf0_pcie_cap_power_controller                                                   = "false",
  parameter                   pf0_pcie_cap_mrl_sensor                                                         = "false",
  parameter                   pf0_pcie_cap_attention_indicator                                                = "false",
  parameter                   pf0_pcie_cap_power_indicator                                                    = "false",
  parameter                   pf0_pcie_cap_hot_plug_surprise                                                  = "false",
  parameter                   pf0_pcie_cap_hot_plug_capable                                                   = "false",
  parameter  [7:0]            pf0_pcie_cap_slot_power_limit_value                                             = 8'b00000000,
  parameter  [1:0]            pf0_pcie_cap_slot_power_limit_scale                                             = 2'b00,
  parameter                   pf0_pcie_cap_electromech_interlock                                              = "false",
  parameter                   pf0_pcie_cap_no_cmd_cpl_support                                                 = "false",
  parameter  [12:0]           pf0_pcie_cap_phy_slot_num                                                       = 13'b0000000000000,
  parameter                   pf0_pcie_cap_crs_sw_visibility                                                  = "false",
  parameter                   pf0_pcie_cap_sel_deemphasis                                                     = "pf0_minus_6db",

  // pf0_aer_cap Attributes
  //------------------------------        -
  parameter  [4:0]            pf0_adv_err_int_msg_num                                                         = 5'b00000,


  // pf0_tph_cap Attributes
  //------------------------------        -
  parameter                   pf0_tph_req_cap_int_vec_vfcomm_cs2                                              = "disable",
  parameter                   pf0_tph_req_device_spec_vfcomm_cs2                                              = "disable",
  parameter                   pf0_tph_req_cap_st_table_loc_0_vfcomm_cs2                                       = "pf0_not_in_tph_struct_vf",
  parameter                   pf0_tph_req_cap_st_table_loc_1_vfcomm_cs2                                       = "pf0_not_in_msix_table_vf",
  parameter  [10:0]           pf0_tph_req_cap_st_table_size_vfcomm_cs2                                        = 11'b00000000001,
  parameter                   pf0_tph_req_cap_int_vec                                                         = "disable",
  parameter                   pf0_tph_req_device_spec                                                         = "disable",
  parameter                   pf0_tph_req_cap_st_table_loc_0                                                  = "pf0_not_in_tph_struct",
  parameter                   pf0_tph_req_cap_st_table_loc_1                                                  = "pf0_not_in_msix_table",
  parameter  [10:0]           pf0_tph_req_cap_st_table_size                                                   = 11'b00000000001,

  // pf0_msi_cap Attributes
  //------------------------------        -
  parameter                   pf0_pci_msi_multiple_msg_cap                                                    = "pf0_msi_vec_32",
  parameter                   pf0_pci_msi_64_bit_addr_cap                                                     = "true",

  // pf0_msix_cap Attributes
  //------------------------------        -
  parameter  [10:0]           pf0_pci_msix_table_size                                                         = 11'b00011111111,
  parameter  [10:0]           pf0_pci_msix_table_size_vfcomm_cs2                                              = 11'b00000000000,
  parameter  [2:0]            pf0_pci_msix_bir                                                                = 3'b000,
  parameter  [28:0]           pf0_pci_msix_table_offset                                                       = 29'b00000000000000000000000000000,
  parameter  [2:0]            pf0_pci_msix_pba                                                                = 3'b000,
  parameter  [28:0]           pf0_pci_msix_pba_offset                                                         = 29'b00000000000000000000000000000,

  // pf0_ats_cap Attributes
  //------------------------------        -
  parameter  [4:0]            pf0_invalidate_q_depth                                                          = 5'b00000,
  parameter                   pf0_page_aligned_req                                                            = "true",
  parameter                   pf0_global_inval_spprtd                                                         = "false",

  // pf0_port_logic Attributes
  //------------------------------        -
  parameter                   pf0_fast_link_mode                                                              = "false",
  parameter                   pf0_auto_lane_flip_ctrl_en                                                      = "enable",
  parameter                   pf0_config_phy_tx_change                                                        = "pf0_full_swing",
  parameter                   pf0_sel_deemphasis                                                              = "pf0_minus_3db_ctl",
  parameter                   pf0_eq_phase_2_3                                                                = "enable",
  parameter                   pf0_rxeq_ph01_en                                                                = "enable",
  parameter                   pf0_gen3_eq_phase23_exit_mode                                                   = "pf0_next_rec_speed",
  parameter                   pf0_gen3_eq_eval_2ms_disable                                                    = "pf0_abort",
  parameter  [4:0]            pf0_gen3_eq_fmdc_t_min_phase23                                                  = 5'b00010,


  // pf1_type0_hdr Attributes
  //------------------------------        -
  parameter  [15:0]           pf1_pci_type0_vendor_id                                                         = 16'b0001011011000011,
  parameter  [15:0]           pf1_pci_type0_device_id                                                         = 16'b1010101111001101,
  parameter  [7:0]            pf1_program_interface                                                           = 8'b00000000,
  parameter  [7:0]            pf1_subclass_code                                                               = 8'b00000000,
  parameter  [7:0]            pf1_base_class_code                                                             = 8'b00000000,
  parameter                   pf1_pci_type0_bar1_enabled                                                      = "enable",
  parameter                   pf1_pci_type0_bar3_enabled                                                      = "enable",
  parameter                   pf1_pci_type0_bar5_enabled                                                      = "enable",
  parameter                   pf1_pci_type0_bar0_enabled                                                      = "enable",
  parameter                   pf1_bar0_type                                                                   = "pf1_bar0_mem32",
  parameter                   pf1_bar0_prefetch                                                               = "false",
  parameter                   pf1_pci_type0_bar2_enabled                                                      = "enable",
  parameter                   pf1_bar2_type                                                                   = "pf1_bar2_mem32",
  parameter                   pf1_bar2_prefetch                                                               = "false",
  parameter                   pf1_pci_type0_bar4_enabled                                                      = "enable",
  parameter                   pf1_bar4_type                                                                   = "pf1_bar4_mem32",
  parameter                   pf1_bar4_prefetch                                                               = "false",
  parameter  [31:0]           pf1_cardbus_cis_pointer                                                         = 32'b00000000000000000000000000000000,
  parameter  [15:0]           pf1_subsys_vendor_id                                                            = 16'b0000000000000000,
  parameter  [15:0]           pf1_subsys_dev_id                                                               = 16'b0000000000000000,
  parameter                   pf1_rom_bar_enable                                                              = "disable",
  parameter                   pf1_rom_bar_enabled                                                             = "enable",
  parameter                   pf1_int_pin                                                                     = "pf1_inta",
  parameter                   pf1_bar0_address_width_mux_hwtcl                                                = 0,
  parameter                   pf1_bar1_address_width_mux_hwtcl                                                = 0,
  parameter                   pf1_bar2_address_width_mux_hwtcl                                                = 0,
  parameter                   pf1_bar3_address_width_mux_hwtcl                                                = 0,
  parameter                   pf1_bar4_address_width_mux_hwtcl                                                = 0,
  parameter                   pf1_bar5_address_width_mux_hwtcl                                                = 0,
  parameter                   pf1_expansion_base_address_register_hwtcl                                       = 32'h0,

  // pf1_sriov_cap Attributes
  //------------------------------        -
  parameter  [15:0]           pf1_shadow_sriov_vf_stride_ari_cs2                                              = 16'b0000000000000010,
  parameter  [15:0]           pf1_sriov_vf_offset_ari_cs2                                                     = 16'b0000000000000010,
  parameter  [15:0]           pf1_sriov_vf_offset_position_nonari                                             = 16'b0000000100000000,
  parameter  [15:0]           pf1_sriov_vf_stride_nonari                                                      = 16'b0000000100000000,
  parameter  [15:0]           pf1_sriov_vf_device_id                                                          = 16'b1010101111001101,
  parameter  [31:0]           pf1_sriov_sup_page_size                                                         = 32'b00000000000000000000010101010011,
  parameter  [31:0]           pf1_sriov_vf_bar0_mask                                                          = 32'b00000000000000000000000000000000,
  parameter                   pf1_sriov_vf_bar0_type                                                          = "pf1_sriov_vf_bar0_mem32",
  parameter                   pf1_sriov_vf_bar0_prefetch                                                      = "false",
  parameter  [31:0]           pf1_sriov_vf_bar1_mask                                                          = 32'b00000000000000000000000000000000,
  parameter  [31:0]           pf1_sriov_vf_bar2_mask                                                          = 32'b00000000000000000000000000000000,
  parameter                   pf1_sriov_vf_bar2_type                                                          = "pf1_sriov_vf_bar2_mem32",
  parameter                   pf1_sriov_vf_bar2_prefetch                                                      = "false",
  parameter  [31:0]           pf1_sriov_vf_bar3_mask                                                          = 32'b00000000000000000000000000000000,
  parameter  [31:0]           pf1_sriov_vf_bar4_mask                                                          = 32'b00000000000000000000000000000000,
  parameter                   pf1_sriov_vf_bar4_type                                                          = "pf1_sriov_vf_bar4_mem32",
  parameter                   pf1_sriov_vf_bar4_prefetch                                                      = "false",
  parameter  [31:0]           pf1_sriov_vf_bar5_mask                                                          = 32'b00000000000000000000000000000000,


  // pf1_sn_cap Attributes
  //------------------------------        -
  parameter  [31:0]           pf1_sn_ser_num_reg_2_dw                                                         = 32'b00000000000000000000000000000000,
  parameter  [31:0]           pf1_sn_ser_num_reg_1_dw                                                         = 32'b00000000000000000000000000000000,

  // pf1_pm_cap Attributes
  //------------------------------        -
  parameter                   pf1_dsi                                                                         = "pf1_not_required",
  parameter  [2:0]            pf1_aux_curr                                                                    = 3'b111,
  parameter                   pf1_d1_support                                                                  = "pf1_d1_not_supported",
  parameter                   pf1_d2_support                                                                  = "pf1_d2_not_supported",
  parameter  [4:0]            pf1_pme_support                                                                 = 5'b11011,
  parameter                   pf1_no_soft_rst                                                                 = "pf1_internally_reset",

  // pf1_pcie_cap Attributes
  //------------------------------        -
  parameter                   pf1_pcie_slot_imp                                                               = "pf1_not_implemented",
  parameter  [4:0]            pf1_pcie_int_msg_num                                                            = 5'b00000,
  parameter                   pf1_pcie_cap_ext_tag_en                                                         = "false",
  parameter                   pf1_pcie_cap_ext_tag_supp                                                       = "pf1_supported",
  parameter  [2:0]            pf1_pcie_cap_ep_l0s_accpt_latency                                               = 3'b000,
  parameter  [2:0]            pf1_pcie_cap_ep_l1_accpt_latency                                                = 3'b000,
  parameter                   pf1_pcie_cap_flr_cap                                                            = "pf1_capable",
  parameter                   pf1_pcie_cap_active_state_link_pm_support                                       = "pf1_no_aspm",
  parameter  [2:0]            pf1_pcie_cap_l0s_exit_latency_commclk_dis                                       = 3'b111,
  parameter                   pf1_pcie_cap_initiate_flr                                                       = "false",
  parameter  [2:0]            pf1_pcie_cap_l1_exit_latency_commclk_dis                                        = 3'b111,
  parameter                   pf1_pcie_cap_aux_power_pm_en                                                    = "false",
  parameter                   pf1_pcie_cap_clock_power_man                                                    = "pf1_refclk_remove_not_ok",
  parameter  [7:0]            pf1_pcie_cap_port_num                                                           = 8'b00000000,
  parameter  [2:0]            pf1_pcie_cap_l0s_exit_latency_commclk_ena_cs2                                   = 3'b111,
  parameter  [2:0]            pf1_pcie_cap_l1_exit_latency_commclk_ena_cs2                                    = 3'b111,
  parameter                   pf1_pcie_cap_rcb                                                                = "pf1_rcb_64",
  parameter                   pf1_pcie_cap_slot_clk_config                                                    = "false",
  parameter                   pf1_pcie_cap_sel_deemphasis                                                     = "pf1_minus_6db",

  // pf1_tph_cap Attributes
  //------------------------------        -
  parameter                   pf1_tph_req_cap_int_vec_vfcomm_cs2                                              = "disable",
  parameter                   pf1_tph_req_device_spec_vfcomm_cs2                                              = "disable",
  parameter                   pf1_tph_req_cap_st_table_loc_0_vfcomm_cs2                                       = "pf1_not_in_tph_struct_vf",
  parameter                   pf1_tph_req_cap_st_table_loc_1_vfcomm_cs2                                       = "pf1_not_in_msix_table_vf",
  parameter  [10:0]           pf1_tph_req_cap_st_table_size_vfcomm_cs2                                        = 11'b00000000001,
  parameter                   pf1_tph_req_cap_int_vec                                                         = "disable",
  parameter                   pf1_tph_req_device_spec                                                         = "disable",
  parameter                   pf1_tph_req_cap_st_table_loc_0                                                  = "pf1_not_in_tph_struct",
  parameter                   pf1_tph_req_cap_st_table_loc_1                                                  = "pf1_not_in_msix_table",
  parameter  [10:0]           pf1_tph_req_cap_st_table_size                                                   = 11'b00000000001,

  // pf1_msi_cap Attributes
  //------------------------------        -
  parameter                   pf1_pci_msi_multiple_msg_cap                                                    = "pf1_msi_vec_32_pf1",
  parameter                   pf1_pci_msi_64_bit_addr_cap                                                     = "true",

  // pf1_msix_cap Attributes
  //------------------------------        -
  parameter  [10:0]           pf1_pci_msix_table_size                                                         = 11'b00011111111,
  parameter  [10:0]           pf1_pci_msix_table_size_vfcomm_cs2                                              = 11'b00000000000,
  parameter  [2:0]            pf1_pci_msix_bir                                                                = 3'b000,
  parameter  [28:0]           pf1_pci_msix_table_offset                                                       = 29'b00000000000000000000000000000,
  parameter  [2:0]            pf1_pci_msix_pba                                                                = 3'b000,
  parameter  [28:0]           pf1_pci_msix_pba_offset                                                         = 29'b00000000000000000000000000000,

  // pf1_ats_cap Attributes
  //------------------------------        -
  parameter  [4:0]            pf1_invalidate_q_depth                                                          = 5'b00000,
  parameter                   pf1_page_aligned_req                                                            = "true",
  parameter                   pf1_global_inval_spprtd                                                         = "false",

  // vf1_pf0_pcie_cap Attributes
  //------------------------------        -
  parameter                   vf1_pf0_shadow_pcie_cap_clock_power_man                                         = "false",
  // vf1_pf1_pcie_cap Attributes
  //------------------------------        -
  parameter                   vf1_pf1_shadow_pcie_cap_clock_power_man                                         = "false",

  //Derived Parameters

  parameter  [23:0]           pf0_msix_cap_msix_table_offset_reg_addr_byte2                                   = 24'b000000000000000010110110,
  parameter  [7:0]            vf_dbi_reserved_3                                                               = 8'b00000000,
  parameter                   pf1_tph_req_no_st_mode_vfcomm_cs2                                               = "false",
  parameter                   pf1_vf_bar1_reg_rsvdp_0                                                         = "false",
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte3                                     = 24'b001000000001000111100111,
  parameter  [23:0]           pf0_msix_cap_msix_table_offset_reg_addr_byte3                                   = 24'b000000000000000010110111,
  parameter  [23:0]           pf0_type0_hdr_bar3_mask_reg_addr_byte0                                          = 24'b001000000000000000011100,
  parameter  [3:0]            pf0_gen3_eq_fmdc_max_pre_cusror_delta                                           = 4'b0010,
  parameter                   pf0_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvdp_31                         = "false",
  parameter  [2:0]            pf0_dsp_rx_preset_hint8                                                         = 3'b111,
  parameter  [2:0]            pf0_pci_msi_multiple_msg_en                                                     = 3'b000,
  parameter  [7:0]            pf0_dbi_reserved_40                                                             = 8'b00000000,
  parameter                   ecc_chk_val                                                                     = "true",
  parameter                   pf0_multi_func                                                                  = "true",
  parameter                   clock_ctl_rsvd_3                                                                = "false",
  parameter  [7:0]            cfg_vf_num_pf1                                                                  = 8'b01000000,
  parameter                   vf1_pf1_shadow_pcie_cap_surprise_down_err_rep_cap                               = "false",
  parameter                   clkmod_hip_clk_dis                                                              = "false",
  parameter  [23:0]           pf0_reserved_29_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf1_type0_hdr_bar2_mask_reg_addr_byte3                                          = 24'b001000000001000000011011,
  parameter  [23:0]           pf0_vc_cap_vc_base_addr_byte3                                                   = 24'b000000000000000101001011,
  parameter  [23:0]           pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte2                        = 24'b001000000000000111001110,
  parameter  [23:0]           pf0_port_logic_vc0_p_rx_q_ctrl_off_addr_byte2                                   = 24'b000000000000011101001010,
  parameter                   pf0_bar4_mem_io                                                                 = "pf0_bar4_mem",
  parameter  [23:0]           pf1_pcie_cap_link_control2_link_status2_reg_addr_byte0                          = 24'b010000000001000010100000,
  parameter  [23:0]           pf1_pcie_cap_shadow_link_capabilities_reg_addr_byte1                            = 24'b001000000001000001111101,
  parameter  [23:0]           pf0_pcie_cap_root_control_root_capabilities_reg_addr_byte2                      = 24'b000000000000000010001110,
  parameter  [11:0]           pf0_spcie_next_offset                                                           = 12'b000111001000,
  parameter  [23:0]           pf0_reserved_26_addr                                                            = 24'b000000000000000000000000,
  parameter  [3:0]            pf1_aer_cap_version                                                             = 4'b0010,
  parameter  [7:0]            hrc_rstctl_timer_value_g                                                        = 8'b00001010,
  parameter                   pf0_con_status_reg_rsvdp_2                                                      = "false",
  parameter                   virtual_pf1_pb_cap_enable                                                       = "disable",
  parameter  [7:0]            pf0_dbi_reserved_20                                                             = 8'b00000000,
  parameter  [23:0]           pf0_type0_hdr_bar1_mask_reg_addr_byte2                                          = 24'b001000000000000000010110,
  parameter                   pf1_pcie_cap_retrain_link                                                       = "false",
  parameter  [23:0]           pf0_port_logic_gen3_eq_control_off_addr_byte1                                   = 24'b000000000000100010101001,
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte3                                     = 24'b001000000000000111100111,
  parameter  [23:0]           pf1_reserved_9_addr                                                             = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_sn_cap_ser_num_reg_dw_1_addr_byte0                                          = 24'b000000000000000101101100,
  parameter  [7:0]            pf1_pm_next_pointer                                                             = 8'b01010000,
  parameter                   pf0_pcie_cap_target_link_speed                                                  = "pf0_trgt_gen3",
  parameter  [23:0]           pf0_type0_hdr_bar4_mask_reg_addr_byte0                                          = 24'b001000000000000000100000,
  parameter  [23:0]           pf0_reserved_11_addr                                                            = 24'b000000000000000000000000,
  parameter  [9:0]            pf0_aux_clk_freq                                                                = 10'b0000001010,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte0                      = 24'b000000000000000110101100,
  parameter                   hrc_rx_pcs_rst_n_active                                                         = "rx_pcs_rst_0_to_15",
  parameter                   pf0_pcie_cap_max_link_width                                                     = "pf0_x16",
  parameter  [23:0]           pf1_tph_cap_tph_req_cap_reg_addr_byte2                                          = 24'b000000000001000111111110,
  parameter  [8:0]            cfg_dbi_pf1_tablesize                                                           = 9'b010101100,
  parameter                   pf1_bar0_mem_io                                                                 = "pf1_bar0_mem",
  parameter                   pf0_gen3_eq_pset_req_as_coef                                                    = "false",
  parameter  [23:0]           pf0_port_logic_vc0_cpl_rx_q_ctrl_off_addr_byte2                                 = 24'b000000000000011101010010,
  parameter  [7:0]            pf1_revision_id                                                                 = 8'b00000001,
  parameter  [2:0]            pf0_root_err_status_off_rsvdp_7                                                 = 3'b000,
  parameter  [23:0]           pf0_sriov_cap_vf_bar4_reg_addr_byte0                                            = 24'b000000000000000111101100,
  parameter  [5:0]            pf0_gen3_eq_control_off_rsvdp_26                                                = 6'b000000,
  parameter  [7:0]            pf0_dbi_reserved_33                                                             = 8'b00000000,
  parameter  [23:0]           pf1_pcie_cap_link_control_link_status_reg_addr_byte0                            = 24'b010000000001000010000000,
  parameter                   pf0_lane_equalization_control1213_reg_rsvdp_15                                  = "false",
  parameter  [23:0]           pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte1                                    = 24'b000000000000000000101001,
  parameter  [23:0]           pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte2                        = 24'b001000000001000111001110,
  parameter  [23:0]           pf0_reserved_12_addr                                                            = 24'b000000000000000000000000,
  parameter                   pf0_direct_speed_change                                                         = "pf0_auto_speed_chg",
  parameter  [7:0]            pf0_dbi_reserved_5                                                              = 8'b00000000,
  parameter  [23:0]           pf0_port_logic_port_force_off_addr_byte0                                        = 24'b000000000000011100001000,
  parameter  [23:0]           vf1_pf1_ari_cap_vf_ari_base_addr_byte2                                          = 24'b000100000001000100000010,
  parameter                   pf0_forward_user_vsec                                                           = "false",
  parameter                   pf0_bar3_prefetch                                                               = "false",
  parameter  [23:0]           pf0_reserved_43_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_msix_cap_msix_table_offset_reg_addr_byte1                                   = 24'b000000000000000010110101,
  parameter  [3:0]            pf1_bar3_start                                                                  = 4'b0000,
  parameter  [23:0]           pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte2                               = 24'b001000000000000111111110,
  parameter  [3:0]            pf0_ats_cap_version                                                             = 4'b0001,
  parameter  [23:0]           pf1_type0_hdr_bar5_mask_reg_addr_byte3                                          = 24'b001000000001000000100111,
  parameter  [23:0]           pf0_sriov_cap_vf_bar2_reg_addr_byte0                                            = 24'b000000000000000111100100,
  parameter  [23:0]           vf1_pf0_ari_cap_vf_ari_base_addr_byte2                                          = 24'b000100000000000100000010,
  parameter                   hrc_rx_pma_rstb_active                                                          = "rx_pma_rstb_0_to_15",
  parameter  [23:0]           pf1_reserved_7_addr                                                             = 24'b000000000000000000000000,
  parameter                   pf0_pcie_cap_active_state_link_pm_control                                       = "pf0_aspm_dis",
  parameter  [23:0]           pf1_pm_cap_con_status_reg_addr_byte0                                            = 24'b000000000001000001000100,
  parameter                   pf1_pci_type0_bar3_enabled_or_mask64lsb                                         = "disable",
  parameter                   pf0_pci_type0_bar5_enabled_or_mask64lsb                                         = "disable",
  parameter                   pf1_pcie_cap_max_link_width                                                     = "pf1_x16",
  parameter  [23:0]           pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte1                               = 24'b001000000000000111111101,
  parameter  [3:0]            pf0_sriov_vf_bar2_start                                                         = 4'b0000,
  parameter  [1:0]            pf0_gen3_eq_control_off_rsvdp_6                                                 = 2'b00,
  parameter  [5:0]            pf0_gen3_eq_fb_mode_dir_change_off_rsvdp_18                                     = 6'b000000,
  parameter  [23:0]           pf0_port_logic_misc_control_1_off_addr_byte0                                    = 24'b000000000000100010111100,
  parameter  [17:0]           cfg_g3_pset_coeff_10                                                            = 18'b010111101000000000,
  parameter  [7:0]            pf1_dbi_reserved_13                                                             = 8'b00000000,
  parameter                   vf1_pf0_shadow_pcie_cap_surprise_down_err_rep_cap                               = "false",
  parameter  [23:0]           pf1_type0_hdr_device_id_vendor_id_reg_addr_byte3                                = 24'b000000000001000000000011,
  parameter  [23:0]           pf0_port_logic_gen2_ctrl_off_addr_byte2                                         = 24'b010000000000100000001110,
  parameter  [15:0]           cvp_vsec_id                                                                     = 16'b0001000101110010,
  parameter  [23:0]           pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte3                = 24'b001000000001000010110011,
  parameter  [23:0]           pf0_reserved_37_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_reserved_50_addr                                                            = 24'b000000000000000000000000,
  parameter                   pf1_bar1_mem_io                                                                 = "pf1_bar1_mem",
  parameter                   eqctrl_ctle_val                                                                 = "ctle_val_0",
  parameter                   pf0_gen3_dllp_xmt_delay_disable                                                 = "enable",
  parameter  [17:0]           cfg_g3_pset_coeff_1                                                             = 18'b001011110100000000,
  parameter  [6:0]            pf1_sriov_vf_bar1_dummy_mask_7_1                                                = 7'b1111111,
  parameter  [17:0]           cfg_g3_pset_coeff_7                                                             = 18'b001101101011000111,
  parameter  [23:0]           pf0_type0_hdr_class_code_revision_id_addr_byte1                                 = 24'b000000000000000000001001,
  parameter                   pf0_pcie_cap_link_auto_bw_int_en                                                = "false",
  parameter  [23:0]           pf1_type0_hdr_max_latency_min_grant_interrupt_pin_interrupt_line_reg_addr_byte1 = 24'b000000000001000000111101,
  parameter  [23:0]           pf1_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte1              = 24'b000000000001000001110001,
  parameter  [23:0]           pf0_port_logic_symbol_timer_filter_1_off_addr_byte0                             = 24'b000000000000011100011100,
  parameter                   cvp_mode_default                                                                = "false",
  parameter  [3:0]            vf1_pf0_ari_cap_version                                                         = 4'b0001,
  parameter  [23:0]           pf0_type0_hdr_bar4_mask_reg_addr_byte2                                          = 24'b001000000000000000100010,
  parameter                   pf0_link_capable                                                                = "pf0_conn_x1",
  parameter  [23:0]           pf1_sn_cap_ser_num_reg_dw_1_addr_byte1                                          = 24'b000000000001000101101101,
  parameter                   pf0_gen3_zrxdc_noncompl                                                         = "pf0_non_compliant",
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control45_reg_addr_byte1                        = 24'b000000000000000110011101,
  parameter  [23:0]           pf0_sriov_cap_sriov_vf_offset_position_addr_byte0                               = 24'b000000000000000111001100,
  parameter  [2:0]            pf0_dsp_rx_preset_hint0                                                         = 3'b111,
  parameter  [7:0]            pf1_dbi_reserved_4                                                              = 8'b00000000,
  parameter  [23:0]           pf0_pm_cap_cap_id_nxt_ptr_reg_addr_byte1                                        = 24'b000000000000000001000001,
  parameter                   pf1_sriov_vf_bar5_type                                                          = "pf1_sriov_vf_bar5_mem32",
  parameter  [7:0]            pf0_dbi_reserved_2                                                              = 8'b00000000,
  parameter  [23:0]           pf1_pcie_cap_link_capabilities_reg_addr_byte0                                   = 24'b000000000001000001111100,
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte0                                     = 24'b001000000000000111011100,
  parameter                   hrc_rstctl_timer_type_i                                                         = "micro_sec_i",
  parameter                   pf1_vf_bar0_reg_rsvdp_0                                                         = "false",
  parameter  [3:0]            pf0_bar4_start                                                                  = 4'b0000,
  parameter  [23:0]           pf1_type0_hdr_bar1_mask_reg_addr_byte0                                          = 24'b001000000001000000010100,
  parameter                   pf0_sriov_vf_bar1_type                                                          = "pf0_sriov_vf_bar1_mem32",
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte2                                     = 24'b001000000001000111110010,
  parameter                   hrc_rstctl_timer_type_a                                                         = "fref_cyc_a",
  parameter                   pf0_lane_equalization_control45_reg_rsvdp_23                                    = "false",
  parameter  [7:0]            pf0_dbi_reserved_27                                                             = 8'b00000000,
  parameter  [23:0]           pf1_reserved_19_addr                                                            = 24'b000000000000000000000000,
  parameter                   pf1_pcie_cap_role_based_err_report                                              = "false",
  parameter  [3:0]            pf1_link_control_link_status_reg_rsvdp_12                                       = 4'b0000,
  parameter  [23:0]           pf0_reserved_34_addr                                                            = 24'b000000000000000000000000,
  parameter                   clkmod_gen3_hclk_div_sel                                                        = "hclk_div1",
  parameter  [11:0]           pf0_ari_next_offset                                                             = 12'b000110011000,
  parameter  [23:0]           pf0_sriov_cap_sriov_bar1_enable_reg_addr_byte0                                  = 24'b001000000000000111100000,
  parameter  [11:0]           pf1_ats_next_offset                                                             = 12'b000000000000,
  parameter  [23:0]           pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte0                        = 24'b001000000001000111001100,
  parameter  [23:0]           pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte1                           = 24'b000000000000000010110001,
  parameter                   pf1_pcie_cap_dll_active_rep_cap                                                 = "false",
  parameter  [2:0]            pf1_pci_msi_multiple_msg_en                                                     = 3'b000,
  parameter  [23:0]           pf1_ari_cap_ari_base_addr_byte2                                                 = 24'b000000000001000101111010,
  parameter  [23:0]           pf1_type0_hdr_class_code_revision_id_addr_byte2                                 = 24'b000000000001000000001010,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control89_reg_addr_byte3                        = 24'b000000000000000110100111,
  parameter  [23:0]           pf0_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte1                             = 24'b000000000000000001010001,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte3                      = 24'b000000000000000110110011,
  parameter  [3:0]            pf1_ari_cap_version                                                             = 4'b0001,
  parameter  [23:0]           pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte2                               = 24'b001000000001000111111110,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control23_reg_addr_byte1                        = 24'b000000000000000110011001,
  parameter                   pf0_bar0_mem_io                                                                 = "pf0_bar0_mem",
  parameter  [23:0]           pf0_reserved_38_addr                                                            = 24'b000000000000000000000000,
  parameter                   pf0_lane_equalization_control01_reg_rsvdp_31                                    = "false",
  parameter  [1:0]            pf0_power_state                                                                 = 2'b00,
  parameter  [23:0]           pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte1                        = 24'b001000000000000111001101,
  parameter  [23:0]           pf1_type0_hdr_bar3_mask_reg_addr_byte1                                          = 24'b001000000001000000011101,
  parameter  [4:0]            pf0_tph_req_cap_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                              = 5'b00000,
  parameter  [4:0]            pf1_tph_req_cap_reg_rsvdp_11                                                    = 5'b00000,
  parameter  [23:0]           pf1_pcie_cap_device_control_device_status_addr_byte1                            = 24'b000000000001000001111001,
  parameter                   pf1_pcie_cap_dll_active                                                         = "false",
  parameter  [23:0]           pf0_port_logic_gen3_eq_control_off_addr_byte0                                   = 24'b000000000000100010101000,
  parameter                   cfg_blk_crs_en                                                                  = "false",
  parameter  [7:0]            pf0_dbi_reserved_46                                                             = 8'b00000000,
  parameter  [4:0]            pf0_tph_req_cap_reg_rsvdp_3                                                     = 5'b00000,
  parameter  [3:0]            pf0_sriov_vf_bar3_start                                                         = 4'b0000,
  parameter                   aux_warm_reset_ctl                                                              = "true",
  parameter                   adp_bypass                                                                      = "false",
  parameter                   pf1_bar3_prefetch                                                               = "false",
  parameter  [11:0]           pf0_aer_next_offset                                                             = 12'b000101001000,
  parameter  [4:0]            pld_tx_fifo_empty_threshold_3                                                   = 5'b01111,
  parameter                   pf1_pcie_cap_link_disable                                                       = "false",
  parameter  [23:0]           pf1_sriov_cap_sriov_vf_offset_position_addr_byte0                               = 24'b000000000001000111001100,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control45_reg_addr_byte3                        = 24'b000000000000000110011111,
  parameter                   virtual_pf0_pb_cap_enable                                                       = "disable",
  parameter  [7:0]            pf1_dbi_reserved_14                                                             = 8'b00000000,
  parameter                   pf1_cap_id_nxt_ptr_reg_rsvdp_20                                                 = "false",
  parameter  [23:0]           pf1_sn_cap_sn_base_addr_byte2                                                   = 24'b000000000001000101101010,
  parameter  [23:0]           pf0_type0_hdr_bist_header_type_latency_cache_line_size_reg_addr_byte2           = 24'b000000000000000000001110,
  parameter  [23:0]           pf0_reserved_25_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_reserved_8_addr                                                             = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_port_logic_vc0_p_rx_q_ctrl_off_addr_byte0                                   = 24'b000000000000011101001000,
  parameter  [23:0]           pf1_type0_hdr_bar4_mask_reg_addr_byte1                                          = 24'b001000000001000000100001,
  parameter  [23:0]           pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte2                                   = 24'b001000000000000000110010,
  parameter  [7:0]            pf0_dbi_reserved_4                                                              = 8'b00000000,
  parameter  [11:0]           pf0_vc_next_offset                                                              = 12'b000101101000,
  parameter  [23:0]           pf0_sriov_cap_vf_bar0_reg_addr_byte0                                            = 24'b000000000000000111011100,
  parameter  [23:0]           pf0_port_logic_port_link_ctrl_off_addr_byte0                                    = 24'b000000000000011100010000,
  parameter  [11:0]           pf0_sn_next_offset                                                              = 12'b000101111000,
  parameter  [7:0]            pf0_dbi_reserved_1                                                              = 8'b00000000,
  parameter  [23:0]           pf1_pcie_cap_device_capabilities_reg_addr_byte0                                 = 24'b000000000001000001110100,
  parameter  [23:0]           pf0_ats_cap_ats_capabilities_ctrl_reg_addr_byte0                                = 24'b000000000000001010001000,
  parameter  [6:0]            pf1_header_type                                                                 = 7'b0000000,
  parameter  [23:0]           pf0_reserved_41_addr                                                            = 24'b000000000000000000000000,
  parameter  [3:0]            pf0_sriov_vf_bar4_start                                                         = 4'b0000,
  parameter                   pf0_lane_equalization_control1415_reg_rsvdp_31                                  = "false",
  parameter                   pf0_bar1_mem_io                                                                 = "pf0_bar1_mem",
  parameter  [23:0]           pf0_type0_hdr_bar5_reg_addr_byte0                                               = 24'b000000000000000000100100,
  parameter  [2:0]            pf1_pci_msix_cap_id_next_ctrl_reg_rsvdp_27                                      = 3'b000,
  parameter  [2:0]            pf0_dsp_rx_preset_hint3                                                         = 3'b111,
  parameter  [17:0]           cfg_g3_pset_coeff_9                                                             = 18'b000000110100001011,
  parameter  [7:0]            pf0_dbi_reserved_45                                                             = 8'b00000000,
  parameter  [23:0]           pf0_reserved_14_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf1_pcie_cap_link_capabilities_reg_addr_byte2                                   = 24'b000000000001000001111110,
  parameter  [1:0]            pf1_shadow_pcie_cap_active_state_link_pm_support                                = 2'b00,
  parameter  [6:0]            pf1_pci_type0_bar1_dummy_mask_7_1                                               = 7'b1111111,
  parameter                   pf0_eq_redo                                                                     = "enable",
  parameter                   pf0_pci_type0_bar1_enabled_or_mask64lsb                                         = "disable",
  parameter  [7:0]            pf0_dbi_reserved_56                                                             = 8'b00000000,
  parameter                   pf0_pcie_cap_link_auto_bw_status                                                = "false",
  parameter                   pf1_tph_req_no_st_mode                                                          = "false",
  parameter  [23:0]           pf0_reserved_48_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_port_logic_timer_ctrl_max_func_num_off_addr_byte0                           = 24'b000000000000011100011000,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte1                      = 24'b000000000000000110101001,
  parameter  [23:0]           pf0_type0_hdr_bar4_mask_reg_addr_byte3                                          = 24'b001000000000000000100011,
  parameter  [23:0]           pf0_reserved_23_addr                                                            = 24'b000000000000000000000000,
  parameter  [6:0]            pf0_sriov_vf_bar5_dummy_mask_7_1                                                = 7'b1111111,
  parameter  [3:0]            pf1_con_status_reg_rsvdp_4                                                      = 4'b0000,
  parameter  [11:0]           vf1_pf1_tph_req_next_ptr                                                        = 12'b001000101000,
  parameter  [23:0]           pf1_msix_cap_msix_pba_offset_reg_addr_byte2                                     = 24'b000000000001000010111010,
  parameter  [23:0]           pf0_type0_hdr_bar3_reg_addr_byte0                                               = 24'b000000000000000000011100,
  parameter  [6:0]            pf0_pci_type0_bar5_dummy_mask_7_1                                               = 7'b1111111,
  parameter  [7:0]            pf0_dbi_reserved_18                                                             = 8'b00000000,
  parameter  [23:0]           pf0_type0_hdr_exp_rom_base_addr_reg_addr_byte0                                  = 24'b000000000000000000110000,
  parameter  [23:0]           pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte0                                   = 24'b001000000000000000110000,
  parameter  [23:0]           pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte3                               = 24'b001000000000000111111111,
  parameter                   pf0_bar2_mem_io                                                                 = "pf0_bar2_mem",
  parameter                   pf0_vf_bar5_reg_rsvdp_0                                                         = "false",
  parameter                   pf0_lane_equalization_control1011_reg_rsvdp_7                                   = "false",
  parameter  [23:0]           pf1_type0_hdr_bar0_mask_reg_addr_byte0                                          = 24'b001000000001000000010000,
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte0                                     = 24'b001000000000000111100000,
  parameter                   pf1_vf_bar4_reg_rsvdp_0                                                         = "false",
  parameter  [2:0]            pf0_rxstatus_value                                                              = 3'b000,
  parameter  [23:0]           pf1_sriov_cap_vf_bar4_reg_addr_byte0                                            = 24'b000000000001000111101100,
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte1                                     = 24'b001000000000000111101001,
  parameter                   pf1_shadow_pcie_cap_link_bw_not_cap                                             = "false",
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte2                                     = 24'b001000000000000111011110,
  parameter  [23:0]           pf0_port_logic_gen3_eq_fb_mode_dir_change_off_addr_byte1                        = 24'b000000000000100010101101,
  parameter                   pf0_vendor_specific_dllp_req                                                    = "false",
  parameter  [2:0]            pf0_dsp_rx_preset_hint4                                                         = 3'b111,
  parameter  [23:0]           pf0_type0_hdr_class_code_revision_id_addr_byte3                                 = 24'b000000000000000000001011,
  parameter                   hrc_tx_lcff_pll_lock_active                                                     = "tx_lcff_pll_lock_78",
  parameter  [8:0]            cfg_dbi_pf0_table_size                                                          = 9'b100000110,
  parameter                   pf1_vf_bar3_reg_rsvdp_0                                                         = "false",
  parameter  [23:0]           pf0_sriov_cap_sriov_bar5_enable_reg_addr_byte0                                  = 24'b001000000000000111110000,
  parameter  [2:0]            pf1_device_capabilities_reg_rsvdp_29                                            = 3'b000,
  parameter  [23:0]           pf0_type0_hdr_bar2_mask_reg_addr_byte0                                          = 24'b001000000000000000011000,
  parameter  [23:0]           pf0_pm_cap_cap_id_nxt_ptr_reg_addr_byte3                                        = 24'b000000000000000001000011,
  parameter                   pf0_sriov_vf_bar5_enabled                                                       = "enable",
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte3                                     = 24'b001000000001000111101111,
  parameter                   vf1_pf0_vf_shadow_link_capabilities_reg_shadow_rsvdp_23                         = "false",
  parameter  [23:0]           pf0_port_logic_gen3_related_off_addr_byte0                                      = 24'b000000000000100010010000,
  parameter  [23:0]           pf0_port_logic_gen2_ctrl_off_addr_byte0                                         = 24'b000000000000100000001100,
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte1                                     = 24'b001000000000000111100101,
  parameter                   hrc_rstctl_timer_type_f                                                         = "fref_cyc_f",
  parameter                   pf0_pcie_cap_hw_auto_speed_disable                                              = "false",
  parameter  [4:0]            pf0_gen3_related_off_rsvdp_19                                                   = 5'b00000,
  parameter                   pf0_pcie_cap_link_disable                                                       = "false",
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte0                                     = 24'b001000000001000111100100,
  parameter  [2:0]            pf0_dsp_rx_preset_hint7                                                         = 3'b111,
  parameter  [23:0]           pf1_reserved_5_addr                                                             = 24'b000000000000000000000000,
  parameter  [23:0]           pf1_sriov_cap_vf_bar5_reg_addr_byte0                                            = 24'b000000000001000111110000,
  parameter  [23:0]           pf1_type0_hdr_bar2_mask_reg_addr_byte1                                          = 24'b001000000001000000011001,
  parameter  [23:0]           pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte1                                = 24'b001000000000000000111001,
  parameter  [1:0]            vf1_pf0_shadow_pcie_cap_l1_exit_latency_commclk_ena                             = 2'b11,
  parameter  [23:0]           pf0_type0_hdr_device_id_vendor_id_reg_addr_byte0                                = 24'b000000000000000000000000,
  parameter  [23:0]           pf1_type0_hdr_device_id_vendor_id_reg_addr_byte1                                = 24'b000000000001000000000001,
  parameter                   pf1_pcie_cap_extended_synch                                                     = "false",
  parameter                   ssm_aux_prog_en                                                                 = "false",
  parameter  [23:0]           pf1_type0_hdr_bar3_mask_reg_addr_byte2                                          = 24'b001000000001000000011110,
  parameter                   hrc_mask_tx_pll_lock_active                                                     = "mask_tx_pll_lock_34",
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte0                                     = 24'b001000000001000111011100,
  parameter  [23:0]           pf0_reserved_55_addr                                                            = 24'b000000000000000000000000,
  parameter                   pf0_reserved4                                                                   = "false",
  parameter  [23:0]           pf0_sriov_cap_shadow_sriov_initial_vfs_addr_byte0                               = 24'b001000000000000111000100,
  parameter                   pf1_pci_type0_bar5_enabled_or_mask64lsb                                         = "disable",
  parameter  [23:0]           pf0_reserved_51_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_pcie_cap_link_control_link_status_reg_addr_byte1                            = 24'b010000000000000010000001,
  parameter  [4:0]            user_mode_del_count                                                             = 5'b00101,
  parameter  [23:0]           pf0_type0_hdr_bar5_mask_reg_addr_byte1                                          = 24'b001000000000000000100101,
  parameter  [7:0]            pf1_pcie_cap_next_ptr                                                           = 8'b10110000,
  parameter  [23:0]           pf1_sriov_cap_sriov_base_reg_addr_byte2                                         = 24'b000000000001000110111010,
  parameter                   pf1_bar1_prefetch                                                               = "false",
  parameter                   pf0_link_control_link_status_reg_rsvdp_9                                        = "false",
  parameter  [2:0]            pf0_dsp_rx_preset_hint6                                                         = 3'b111,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte0                      = 24'b000000000000000110101000,
  parameter  [23:0]           pf0_port_logic_gen3_eq_local_fs_lf_off_addr_byte0                               = 24'b000000000000100010010100,
  parameter                   pf1_con_status_reg_rsvdp_2                                                      = "false",
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte1                                     = 24'b001000000001000111100101,
  parameter                   cvp_blocking_dis                                                                = "false",
  parameter                   pf0_bar5_prefetch                                                               = "false",
  parameter  [23:0]           pf0_type0_hdr_bar1_mask_reg_addr_byte1                                          = 24'b001000000000000000010101,
  parameter  [3:0]            pf0_dsp_tx_preset6                                                              = 4'b1111,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte3                      = 24'b000000000000000110101111,
  parameter  [6:0]            pf0_pci_type0_bar1_dummy_mask_7_1                                               = 7'b1111111,
  parameter  [23:0]           pf0_reserved_13_addr                                                            = 24'b000000000000000000000000,
  parameter  [7:0]            pf0_dbi_reserved_0                                                              = 8'b00000000,
  parameter  [23:0]           pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte0                                    = 24'b000000000001000000101000,
  parameter  [23:0]           pf1_pm_cap_cap_id_nxt_ptr_reg_addr_byte1                                        = 24'b000000000001000001000001,
  parameter  [23:0]           pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte3                           = 24'b000000000001000010110011,
  parameter                   cvp_warm_rst_ready_force_bit0                                                   = "false",
  parameter                   cvp_warm_rst_ready_force_bit1                                                   = "true",
  parameter                   cvp_warm_rst_req_ena                                                            = "disable",
  parameter  [2:0]            cvp_write_mask_ctl                                                              = 3'b011,
  parameter  [23:0]           pf0_ari_cap_ari_base_addr_byte3                                                 = 24'b000000000000000101111011,
  parameter                   pf1_pcie_cap_link_training                                                      = "false",
  parameter                   pf1_bar5_prefetch                                                               = "false",
  parameter                   pf0_timer_mod_flow_control_en                                                   = "disable",
  parameter                   pf0_disable_scrambler_gen_3                                                     = "enable",
  parameter  [19:0]           hrc_rstctl_1ms                                                                  = 20'b00000000000000000000,
  parameter  [23:0]           pf1_sn_cap_ser_num_reg_dw_1_addr_byte2                                          = 24'b000000000001000101101110,
  parameter  [23:0]           pf0_type0_hdr_bar5_mask_reg_addr_byte2                                          = 24'b001000000000000000100110,
  parameter  [23:0]           pf0_aer_cap_aer_ext_cap_hdr_off_addr_byte3                                      = 24'b000000000000000100000011,
  parameter  [23:0]           pf1_sriov_cap_sup_page_sizes_reg_addr_byte3                                     = 24'b000000000001000111010111,
  parameter  [15:0]           hrc_chnl_en                                                                     = 16'b1111111111111111,
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte1                                     = 24'b001000000001000111100001,
  parameter                   pf0_pipe_loopback                                                               = "disable",
  parameter  [7:0]            pf0_dbi_reserved_7                                                              = 8'b00000000,
  parameter                   pf1_pcie_cap_max_link_speed                                                     = "pf1_max_8gts",
  parameter  [1:0]            pf0_shadow_pcie_cap_max_link_width                                              = 2'b00,
  parameter  [17:0]           cfg_g3_pset_coeff_5                                                             = 18'b000000111000000111,
  parameter                   pf1_pci_msi_enable                                                              = "false",
  parameter  [3:0]            pf1_device_capabilities_reg_rsvdp_16                                            = 4'b0000,
  parameter  [23:0]           pf0_sriov_cap_sup_page_sizes_reg_addr_byte2                                     = 24'b000000000000000111010110,
  parameter  [23:0]           pf1_type0_hdr_class_code_revision_id_addr_byte0                                 = 24'b000000000001000000001000,
  parameter  [23:0]           pf0_sriov_cap_sup_page_sizes_reg_addr_byte1                                     = 24'b000000000000000111010101,
  parameter  [23:0]           pf0_port_logic_vc0_np_rx_q_ctrl_off_addr_byte2                                  = 24'b000000000000011101001110,
  parameter  [23:0]           vf1_pf0_pcie_cap_vf_shadow_link_capabilities_reg_addr_byte1                     = 24'b000100000000000001111101,
  parameter  [23:0]           pf1_type0_hdr_bar1_enable_reg_addr_byte0                                        = 24'b001000000001000000010100,
  parameter  [7:0]            pf0_pci_msi_cap_next_offset                                                     = 8'b01110000,
  parameter  [7:0]            pf1_dbi_reserved_5                                                              = 8'b00000000,
  parameter  [23:0]           pf1_reserved_2_addr                                                             = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_port_logic_filter_mask_2_off_addr_byte1                                     = 24'b000000000000011100100001,
  parameter  [23:0]           pf0_ats_cap_ats_cap_hdr_reg_addr_byte2                                          = 24'b000000000000001010000110,
  parameter  [3:0]            pf0_spcie_cap_version                                                           = 4'b0001,
  parameter                   pf0_shadow_link_capabilities_reg_shadow_rsvdp_23                                = "false",
  parameter  [23:0]           pf0_pcie_cap_link_capabilities_reg_addr_byte1                                   = 24'b000000000000000001111101,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte2                      = 24'b000000000000000110101010,
  parameter                   crs_override                                                                    = "false",
  parameter                   pf1_link_control_link_status_reg_rsvdp_2                                        = "false",
  parameter  [3:0]            pf0_dsp_tx_preset11                                                             = 4'b1111,
  parameter  [23:0]           pf0_port_logic_aux_clk_freq_off_addr_byte1                                      = 24'b000000000000101101000001,
  parameter  [4:0]            pf0_gen3_eq_fmdc_n_evals                                                        = 5'b00100,
  parameter  [23:0]           pf1_sn_cap_ser_num_reg_dw_2_addr_byte3                                          = 24'b000000000001000101110011,
  parameter  [2:0]            pf0_vc0_cpl_tlp_q_mode                                                          = 3'b001,
  parameter                   pf0_lane_equalization_control45_reg_rsvdp_31                                    = "false",
  parameter  [7:0]            pf0_pcie_cap_next_ptr                                                           = 8'b10110000,
  parameter  [23:0]           pf1_reserved_17_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_reserved_53_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_sn_cap_sn_base_addr_byte3                                                   = 24'b000000000000000101101011,
  parameter  [23:0]           pf1_sriov_cap_sriov_bar3_enable_reg_addr_byte0                                  = 24'b001000000001000111101000,
  parameter  [2:0]            pf1_pcie_cap_max_read_req_size                                                  = 3'b000,
  parameter                   pf1_pcie_cap_max_payload_size                                                   = "pf1_payload_1024",
  parameter  [7:0]            pf0_dbi_reserved_38                                                             = 8'b00000000,
  parameter  [3:0]            pf0_link_control_link_status_reg_rsvdp_12                                       = 4'b0000,
  parameter                   hrc_chnl_cal_done_active                                                        = "chnl_cal_done_0_to_15",
  parameter  [3:0]            pf1_bar1_start                                                                  = 4'b0000,
  parameter  [4:0]            pf1_tph_req_cap_reg_rsvdp_27                                                    = 5'b00000,
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte2                                     = 24'b001000000001000111011110,
  parameter                   pf1_sriov_vf_bar5_enabled                                                       = "enable",
  parameter  [2:0]            pf0_dsp_rx_preset_hint12                                                        = 3'b111,
  parameter                   pf0_lane_equalization_control23_reg_rsvdp_15                                    = "false",
  parameter                   pf0_lane_equalization_control1415_reg_rsvdp_7                                   = "false",
  parameter                   eqctrl_use_dsp_rxpreset                                                         = "false",
  parameter  [31:0]           pf0_mask_radm_2                                                                 = 32'b00000000000000000000000000000011,
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte3                                     = 24'b001000000000000111101111,
  parameter  [23:0]           pf1_sriov_cap_sriov_bar5_enable_reg_addr_byte0                                  = 24'b001000000001000111110000,
  parameter                   pf1_bar3_mem_io                                                                 = "pf1_bar3_mem",
  parameter                   pf0_gen3_eq_fb_mode                                                             = "pf0_dir_chg",
  parameter  [23:0]           pf0_msix_cap_msix_pba_offset_reg_addr_byte1                                     = 24'b000000000000000010111001,
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte0                                     = 24'b001000000000000111100100,
  parameter  [23:0]           vf_reserved_3_addr                                                              = 24'b000000000000000000000000,
  parameter  [7:0]            pf1_dbi_reserved_1                                                              = 8'b00000000,
  parameter                   pf0_pci_msi_enable                                                              = "false",
  parameter                   pf0_sriov_vf_bar3_type                                                          = "pf0_sriov_vf_bar3_mem32",
  parameter  [23:0]           pf0_type0_hdr_bar5_enable_reg_addr_byte0                                        = 24'b001000000000000000100100,
  parameter  [23:0]           pf0_type0_hdr_bar2_mask_reg_addr_byte3                                          = 24'b001000000000000000011011,
  parameter  [23:0]           pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte0                   = 24'b000000000000000000101100,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control67_reg_addr_byte3                        = 24'b000000000000000110100011,
  parameter                   pf1_pcie_cap_nego_link_width                                                    = "false",
  parameter  [23:0]           pf1_sriov_cap_sriov_initial_vfs_addr_byte0                                      = 24'b000000000001000111000100,
  parameter                   pf1_tph_req_extended_tph                                                        = "disable",
  parameter  [17:0]           cfg_g3_pset_coeff_3                                                             = 18'b001000110111000000,
  parameter  [7:0]            pf0_dbi_reserved_48                                                             = 8'b00000000,
  parameter                   hrc_rstctl_timer_type_g                                                         = "fref_cyc_g",
  parameter  [23:0]           pf0_reserved_45_addr                                                            = 24'b000000000000000000000000,
  parameter                   pf0_pcie_cap_surprise_down_err_rep_cap                                          = "false",
  parameter  [23:0]           pf1_msix_cap_msix_table_offset_reg_addr_byte1                                   = 24'b000000000001000010110101,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte0                      = 24'b000000000000000110110000,
  parameter  [2:0]            pf0_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                = 3'b000,
  parameter  [7:0]            pf0_ack_n_fts                                                                   = 8'b11111111,
  parameter                   vf1_pf1_shadow_pcie_cap_link_bw_not_cap                                         = "false",
  parameter  [23:0]           pf1_type0_hdr_bar5_mask_reg_addr_byte1                                          = 24'b001000000001000000100101,
  parameter  [23:0]           pf1_type0_hdr_bar1_mask_reg_addr_byte1                                          = 24'b001000000001000000010101,
  parameter  [7:0]            pf0_cap_pointer                                                                 = 8'b01000000,
  parameter  [7:0]            pf1_dbi_reserved_18                                                             = 8'b00000000,
  parameter                   pf0_shadow_pcie_cap_dll_active_rep_cap                                          = "false",
  parameter  [7:0]            pf0_dbi_reserved_42                                                             = 8'b00000000,
  parameter  [23:0]           pf0_reserved_24_addr                                                            = 24'b000000000000000000000000,
  parameter                   pf0_cross_link_active                                                           = "false",
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte0                                     = 24'b001000000000000111101100,
  parameter                   pld_crs_en                                                                      = "false",
  parameter                   eqctrl_fom_mode_en                                                              = "false",
  parameter                   eqctrl_adp_ctle                                                                 = "false",
  parameter  [23:0]           pf0_sn_cap_ser_num_reg_dw_2_addr_byte1                                          = 24'b000000000000000101110001,
  parameter                   pf0_pci_type0_bar3_enabled_or_mask64lsb                                         = "disable",
  parameter  [23:0]           pf0_type0_hdr_bar3_mask_reg_addr_byte3                                          = 24'b001000000000000000011111,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control01_reg_addr_byte2                        = 24'b000000000000000110010110,
  parameter  [6:0]            pf0_sriov_vf_bar3_dummy_mask_7_1                                                = 7'b1111111,
  parameter  [1:0]            vf1_pf1_shadow_pcie_cap_l1_exit_latency_commclk_ena                             = 2'b11,
  parameter  [23:0]           pf0_port_logic_symbol_timer_filter_1_off_addr_byte3                             = 24'b000000000000011100011111,
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte2                                     = 24'b001000000000000111100010,
  parameter  [23:0]           pf0_type0_hdr_device_id_vendor_id_reg_addr_byte2                                = 24'b000000000000000000000010,
  parameter  [23:0]           pf1_aer_cap_aer_ext_cap_hdr_off_addr_byte2                                      = 24'b000000000001000100000010,
  parameter                   pf1_sriov_vf_bar1_prefetch                                                      = "false",
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control45_reg_addr_byte0                        = 24'b000000000000000110011100,
  parameter  [3:0]            pf1_sriov_vf_bar3_start                                                         = 4'b0000,
  parameter  [11:0]           vf1_pf0_tph_req_next_ptr                                                        = 12'b001000101000,
  parameter                   pf0_lane_equalization_control01_reg_rsvdp_15                                    = "false",
  parameter  [23:0]           pf1_type0_hdr_exp_rom_base_addr_reg_addr_byte0                                  = 24'b000000000001000000110000,
  parameter  [23:0]           pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte0                                   = 24'b001000000001000000110000,
  parameter  [7:0]            pf0_dbi_reserved_25                                                             = 8'b00000000,
  parameter                   pf0_loopback_enable                                                             = "false",
  parameter  [7:0]            pf0_pci_msix_cap_next_offset                                                    = 8'b00000000,
  parameter  [7:0]            pf0_dbi_reserved_30                                                             = 8'b00000000,
  parameter  [23:0]           pf0_pcie_cap_shadow_link_capabilities_reg_addr_byte0                            = 24'b001000000000000001111100,
  parameter  [7:0]            pf0_dbi_reserved_36                                                             = 8'b00000000,
  parameter  [23:0]           pf0_sriov_cap_sriov_base_reg_addr_byte3                                         = 24'b000000000000000110111011,
  parameter  [23:0]           pf0_type0_hdr_bar1_reg_addr_byte0                                               = 24'b000000000000000000010100,
  parameter  [23:0]           pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte0                               = 24'b001000000001000111111100,
  parameter  [23:0]           pf1_sn_cap_sn_base_addr_byte3                                                   = 24'b000000000001000101101011,
  parameter  [23:0]           pf0_reserved_2_addr                                                             = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_port_logic_vc0_np_rx_q_ctrl_off_addr_byte0                                  = 24'b000000000000011101001100,
  parameter  [15:0]           virtual_pf1_sriov_num_vf_ari                                                    = 16'b0000000000000000,
  parameter  [23:0]           pf1_reserved_8_addr                                                             = 24'b000000000000000000000000,
  parameter  [7:0]            pf0_dbi_reserved_15                                                             = 8'b00000000,
  parameter  [7:0]            pf0_pm_next_pointer                                                             = 8'b01010000,
  parameter  [15:0]           pf0_sriov_initial_vfs_ari_cs2                                                   = 16'b0000000001000000,
  parameter                   virtual_pf0_io_decode                                                           = "io32",
  parameter  [3:0]            pf0_dsp_tx_preset0                                                              = 4'b1111,
  parameter  [23:0]           pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte3                                   = 24'b001000000001000000110011,
  parameter  [11:0]           pf0_tph_req_next_ptr                                                            = 12'b001011011000,
  parameter  [23:0]           pf0_sriov_cap_sriov_initial_vfs_addr_byte1                                      = 24'b000000000000000111000101,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control23_reg_addr_byte3                        = 24'b000000000000000110011011,
  parameter  [4:0]            pf1_tph_req_cap_reg_vfcomm_cs2_rsvdp_11_vfcomm_cs2                              = 5'b00000,
  parameter  [23:0]           pf1_sriov_cap_vf_device_id_reg_addr_byte3                                       = 24'b000000000001000111010011,
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte0                                     = 24'b001000000000000111110000,
  parameter  [23:0]           vf1_pf1_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte3                               = 24'b000100000001000100010011,
  parameter  [23:0]           pf0_reserved_31_addr                                                            = 24'b000000000000000000000000,
  parameter  [3:0]            pf1_tph_req_cap_ver                                                             = 4'b0001,
  parameter  [23:0]           pf0_reserved_21_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte1              = 24'b000000000000000001110001,
  parameter  [23:0]           pf1_type0_hdr_device_id_vendor_id_reg_addr_byte2                                = 24'b000000000001000000000010,
  parameter  [3:0]            pf1_sriov_cap_version                                                           = 4'b0001,
  parameter                   pf0_bar1_type                                                                   = "pf0_bar1_mem32",
  parameter  [3:0]            pf0_bar0_start                                                                  = 4'b0000,
  parameter  [23:0]           vf_reserved_2_addr                                                              = 24'b000000000000000000000000,
  parameter  [3:0]            pf1_sriov_vf_bar0_start                                                         = 4'b0000,
  parameter                   pf1_pcie_cap_en_no_snoop                                                        = "false",
  parameter                   pf1_pcie_cap_enter_compliance                                                   = "false",
  parameter  [7:0]            pf1_cap_pointer                                                                 = 8'b01000000,
  parameter  [23:0]           pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte2                = 24'b001000000001000010110010,
  parameter  [7:0]            pf0_vc0_cpl_header_credit                                                       = 8'b00000000,
  parameter                   pf0_vf_bar0_reg_rsvdp_0                                                         = "false",
  parameter  [23:0]           pf1_sriov_cap_sriov_vf_offset_position_addr_byte1                               = 24'b000000000001000111001101,
  parameter                   pf0_lane_equalization_control01_reg_rsvdp_23                                    = "false",
  parameter  [23:0]           pf0_port_logic_aux_clk_freq_off_addr_byte0                                      = 24'b000000000000101101000000,
  parameter                   pf0_dbi_ro_wr_en                                                                = "enable",
  parameter  [23:0]           pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte0                               = 24'b001000000000000111111100,
  parameter  [23:0]           pf0_reserved_44_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte3                                     = 24'b001000000000000111110011,
  parameter                   vf1_pf1_vf_shadow_link_capabilities_reg_shadow_rsvdp_23                         = "false",
  parameter  [23:0]           pf0_type0_hdr_bar0_mask_reg_addr_byte2                                          = 24'b001000000000000000010010,
  parameter  [23:0]           pf1_pm_cap_cap_id_nxt_ptr_reg_addr_byte3                                        = 24'b000000000001000001000011,
  parameter  [23:0]           vf1_pf0_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte3                               = 24'b000100000000000100010011,
  parameter  [23:0]           pf0_aer_cap_aer_ext_cap_hdr_off_addr_byte2                                      = 24'b000000000000000100000010,
  parameter  [19:0]           hrc_rstctl_1us                                                                  = 20'b00000000000000000000,
  parameter  [15:0]           pf0_mask_radm_1                                                                 = 16'b0010000000001000,
  parameter  [4:0]            pf1_tph_req_cap_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                              = 5'b00000,
  parameter  [23:0]           pf1_sn_cap_ser_num_reg_dw_2_addr_byte1                                          = 24'b000000000001000101110001,
  parameter  [23:0]           pf1_type0_hdr_bar5_enable_reg_addr_byte0                                        = 24'b001000000001000000100100,
  parameter                   pf0_pcie_cap_role_based_err_report                                              = "false",
  parameter  [5:0]            pf0_aux_clk_freq_off_rsvdp_10                                                   = 6'b000000,
  parameter                   clkmod_gen3_hclk_source_sel                                                     = "hclk_1",
  parameter  [23:0]           pf1_type0_hdr_bar0_mask_reg_addr_byte2                                          = 24'b001000000001000000010010,
  parameter                   pf0_pcie_cap_phantom_func_en                                                    = "false",
  parameter  [1:0]            pf0_pcie_cap_phantom_func_support                                               = 2'b00,
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte0                                     = 24'b001000000001000111101000,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control01_reg_addr_byte0                        = 24'b000000000000000110010100,
  parameter  [7:0]            pf1_dbi_reserved_19                                                             = 8'b00000000,
  parameter  [3:0]            pf0_dsp_tx_preset5                                                              = 4'b1111,
  parameter                   pf0_lane_equalization_control89_reg_rsvdp_31                                    = "false",
  parameter  [3:0]            pf0_dsp_tx_preset14                                                             = 4'b1111,
  parameter  [7:0]            vf_dbi_reserved_1                                                               = 8'b00000000,
  parameter  [7:0]            pf0_dbi_reserved_19                                                             = 8'b00000000,
  parameter                   pf0_reserved6                                                                   = "false",
  parameter  [7:0]            pf0_dbi_reserved_28                                                             = 8'b00000000,
  parameter  [23:0]           pf1_ats_cap_ats_cap_hdr_reg_addr_byte2                                          = 24'b000000000001001010000110,
  parameter                   pf0_pci_msix_enable_vfcomm_cs2                                                  = "false",
  parameter  [23:0]           pf0_port_logic_gen3_related_off_addr_byte1                                      = 24'b000000000000100010010001,
  parameter  [7:0]            pf0_dbi_reserved_49                                                             = 8'b00000000,
  parameter  [23:0]           pf0_pcie_cap_link_capabilities_reg_addr_byte3                                   = 24'b000000000000000001111111,
  parameter  [23:0]           pf1_sriov_cap_sriov_bar1_enable_reg_addr_byte0                                  = 24'b001000000001000111100000,
  parameter  [3:0]            pf0_gen3_eq_fmdc_max_post_cusror_delta                                          = 4'b0010,
  parameter                   pf0_lane_equalization_control01_reg_rsvdp_7                                     = "false",
  parameter  [6:0]            pf0_header_type                                                                 = 7'b0000000,
  parameter  [7:0]            pf0_dbi_reserved_39                                                             = 8'b00000000,
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte1                                     = 24'b001000000000000111101101,
  parameter  [7:0]            pf1_dbi_reserved_0                                                              = 8'b00000000,
  parameter  [23:0]           pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte2                                    = 24'b000000000001000000101010,
  parameter  [12:0]           pf0_timer_mod_flow_control                                                      = 13'b0000000000000,
  parameter  [23:0]           pf0_type0_hdr_bar3_mask_reg_addr_byte1                                          = 24'b001000000000000000011101,
  parameter                   pf0_pre_det_lane                                                                = "pf0_det_all_lanes",
  parameter  [7:0]            pf0_vc0_np_header_credit                                                        = 8'b01110011,
  parameter  [2:0]            pf1_device_capabilities_reg_rsvdp_12                                            = 3'b000,
  parameter  [7:0]            pf0_dbi_reserved_57                                                             = 8'b00000000,
  parameter                   vf1_pf0_shadow_pcie_cap_link_bw_not_cap                                         = "false",
  parameter                   device_type                                                                     = "dev_nep",
  parameter  [23:0]           pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte2                   = 24'b000000000000000000101110,
  parameter  [23:0]           pf1_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte2                             = 24'b000000000001000001010010,
  parameter                   clkmod_pld_clk_out_sel_2x                                                       = "aib2x_div1",
  parameter  [7:0]            pf0_dbi_reserved_54                                                             = 8'b00000000,
  parameter                   pf0_lane_equalization_control1011_reg_rsvdp_23                                  = "false",
  parameter  [23:0]           pf0_sriov_cap_vf_bar3_reg_addr_byte0                                            = 24'b000000000000000111101000,
  parameter                   hrc_rstctl_timer_type_j                                                         = "fref_cyc_j",
  parameter  [23:0]           pf0_pcie_cap_slot_capabilities_reg_addr_byte1                                   = 24'b000000000000000010000101,
  parameter  [7:0]            pf1_dbi_reserved_3                                                              = 8'b00000000,
  parameter  [23:0]           pf1_sriov_cap_shadow_sriov_initial_vfs_addr_byte1                               = 24'b001000000001000111000101,
  parameter  [23:0]           pf0_reserved_10_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf1_pcie_cap_shadow_link_capabilities_reg_addr_byte0                            = 24'b001000000001000001111100,
  parameter  [6:0]            pf0_root_control_root_capabilities_reg_rsvdp_17                                 = 7'b0000000,
  parameter  [23:0]           pf0_type0_hdr_bar2_mask_reg_addr_byte1                                          = 24'b001000000000000000011001,
  parameter  [7:0]            pf1_dbi_reserved_6                                                              = 8'b00000000,
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte2                                     = 24'b001000000001000111100010,
  parameter  [23:0]           pf0_port_logic_gen3_eq_control_off_addr_byte3                                   = 24'b000000000000100010101011,
  parameter  [4:0]            pf1_tph_req_cap_reg_vfcomm_cs2_rsvdp_3_vfcomm_cs2                               = 5'b00000,
  parameter                   pf0_dll_link_en                                                                 = "enable",
  parameter  [3:0]            pf0_sriov_vf_bar0_start                                                         = 4'b0000,
  parameter  [3:0]            pf0_eidle_timer                                                                 = 4'b0000,
  parameter  [23:0]           pf1_reserved_11_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf1_pcie_cap_device_capabilities_reg_addr_byte2                                 = 24'b000000000001000001110110,
  parameter  [23:0]           pf0_tph_cap_tph_ext_cap_hdr_reg_addr_byte3                                      = 24'b000000000000000111111011,
  parameter  [7:0]            pf0_dbi_reserved_16                                                             = 8'b00000000,
  parameter                   pf0_lane_equalization_control1213_reg_rsvdp_23                                  = "false",
  parameter  [11:0]           pf0_sriov_next_offset                                                           = 12'b001001111000,
  parameter  [3:0]            pf0_bar5_start                                                                  = 4'b0000,
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte1                                     = 24'b001000000000000111110001,
  parameter  [3:0]            pld_tx_fifo_empty_threshold_1                                                   = 4'b0011,
  parameter  [23:0]           pf1_tph_cap_tph_ext_cap_hdr_reg_addr_byte2                                      = 24'b000000000001000111111010,
  parameter  [23:0]           pf0_type0_hdr_bar0_mask_reg_addr_byte3                                          = 24'b001000000000000000010011,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control45_reg_addr_byte2                        = 24'b000000000000000110011110,
  parameter                   vsec_legacy_interr_mask_en                                                      = "false",
  parameter  [3:0]            pf1_sriov_vf_bar5_start                                                         = 4'b0000,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control89_reg_addr_byte0                        = 24'b000000000000000110100100,
  parameter  [7:0]            pf0_dbi_reserved_47                                                             = 8'b00000000,
  parameter  [7:0]            pf0_dbi_reserved_6                                                              = 8'b00000000,
  parameter  [23:0]           pf1_msix_cap_msix_table_offset_reg_addr_byte3                                   = 24'b000000000001000010110111,
  parameter  [6:0]            pf0_sriov_vf_bar1_dummy_mask_7_1                                                = 7'b1111111,
  parameter  [3:0]            pf0_bar3_start                                                                  = 4'b0000,
  parameter  [5:0]            pf0_gen3_eq_local_fs                                                            = 6'b111111,
  parameter  [23:0]           pf0_sriov_cap_sriov_bar3_enable_reg_addr_byte0                                  = 24'b001000000000000111101000,
  parameter                   cvp_hard_reset_bypass                                                           = "false",
  parameter                   pf1_bar2_mem_io                                                                 = "pf1_bar2_mem",
  parameter  [23:0]           pf0_reserved_17_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_reserved_32_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_port_logic_ack_f_aspm_ctrl_off_addr_byte1                                   = 24'b000000000000011100001101,
  parameter  [23:0]           pf1_reserved_15_addr                                                            = 24'b000000000000000000000000,
  parameter                   pld_aux_prog_en                                                                 = "true",
  parameter  [23:0]           pf0_sn_cap_ser_num_reg_dw_1_addr_byte3                                          = 24'b000000000000000101101111,
  parameter                   pf0_tph_req_no_st_mode                                                          = "false",
  parameter                   pf0_gen3_eq_fom_inc_initial_eval                                                = "pf0_ignore_init_fom",
  parameter                   pf0_lane_equalization_control89_reg_rsvdp_7                                     = "false",
  parameter  [3:0]            pf1_sriov_vf_bar4_start                                                         = 4'b0000,
  parameter                   pf0_pcie_cap_aspm_opt_compliance                                                = "true",
  parameter                   pf0_lane_equalization_control1213_reg_rsvdp_31                                  = "false",
  parameter  [23:0]           pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte3                               = 24'b001000000001000111111111,
  parameter                   hrc_rx_pll_lock_active                                                          = "rx_pll_lock_0_to_15",
  parameter                   pf1_pci_msix_enable                                                             = "false",
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte0                                     = 24'b001000000001000111110000,
  parameter  [23:0]           pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte3                = 24'b001000000000000010110011,
  parameter  [23:0]           pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte2                   = 24'b000000000001000000101110,
  parameter  [23:0]           pf1_sriov_cap_vf_bar1_reg_addr_byte0                                            = 24'b000000000001000111100000,
  parameter  [15:0]           pf0_gen3_eq_pset_req_vec                                                        = 16'b0000000010000000,
  parameter  [3:0]            pf0_bar2_start                                                                  = 4'b0000,
  parameter  [17:0]           cfg_g3_pset_coeff_6                                                             = 18'b000000110111001000,
  parameter  [7:0]            pf1_pci_msi_cap_next_offset                                                     = 8'b01110000,
  parameter                   pf0_pcie_cap_dll_active                                                         = "false",
  parameter  [23:0]           pf1_tph_cap_tph_req_cap_reg_addr_byte1                                          = 24'b000000000001000111111101,
  parameter  [7:0]            vf_dbi_reserved_0                                                               = 8'b00000000,
  parameter                   pf0_lane_equalization_control45_reg_rsvdp_7                                     = "false",
  parameter                   pf0_lane_equalization_control89_reg_rsvdp_23                                    = "false",
  parameter                   pf0_tph_req_extended_tph                                                        = "disable",
  parameter  [17:0]           cfg_g3_pset_coeff_0                                                             = 18'b010000101111000000,
  parameter                   vf1_pf0_shadow_pcie_cap_dll_active_rep_cap                                      = "false",
  parameter  [23:0]           pf1_type0_hdr_device_id_vendor_id_reg_addr_byte0                                = 24'b000000000001000000000000,
  parameter  [7:0]            pf0_dbi_reserved_32                                                             = 8'b00000000,
  parameter  [2:0]            pf0_dsp_rx_preset_hint14                                                        = 3'b111,
  parameter  [7:0]            pf0_dbi_reserved_35                                                             = 8'b00000000,
  parameter                   pf0_shadow_pcie_cap_clock_power_man                                             = "false",
  parameter  [23:0]           pf0_reserved_52_addr                                                            = 24'b000000000000000000000000,
  parameter                   pf0_pcie_cap_common_clk_config                                                  = "false",
  parameter  [7:0]            pf0_dbi_reserved_55                                                             = 8'b00000000,
  parameter  [23:0]           pf0_type0_hdr_bar4_mask_reg_addr_byte1                                          = 24'b001000000000000000100001,
  parameter  [23:0]           pf1_sriov_cap_shadow_sriov_initial_vfs_addr_byte0                               = 24'b001000000001000111000100,
  parameter  [23:0]           pf0_type0_hdr_bar0_mask_reg_addr_byte0                                          = 24'b001000000000000000010000,
  parameter  [6:0]            pf0_gen3_related_off_rsvdp_1                                                    = 7'b0000000,
  parameter  [7:0]            hrc_rstctl_timer_value_i                                                        = 8'b00010100,
  parameter  [23:0]           pf1_sriov_cap_vf_device_id_reg_addr_byte2                                       = 24'b000000000001000111010010,
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte1                                     = 24'b001000000001000111101101,
  parameter  [3:0]            pf0_bar1_start                                                                  = 4'b0000,
  parameter                   pf0_link_capabilities_reg_rsvdp_23                                              = "false",
  parameter  [23:0]           pf0_reserved_27_addr                                                            = 24'b000000000000000000000000,
  parameter  [3:0]            pf0_sn_cap_version                                                              = 4'b0001,
  parameter  [3:0]            pf0_dsp_tx_preset1                                                              = 4'b1111,
  parameter  [7:0]            pf0_dbi_reserved_50                                                             = 8'b00000000,
  parameter  [11:0]           pf0_vc0_p_data_credit                                                           = 12'b001011101110,
  parameter  [23:0]           pf0_pm_cap_cap_id_nxt_ptr_reg_addr_byte2                                        = 24'b000000000000000001000010,
  parameter  [3:0]            vf1_pf1_tph_req_cap_ver                                                         = 4'b0001,
  parameter  [23:0]           vf1_pf0_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte2                               = 24'b000100000000000100010010,
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte1                                     = 24'b001000000000000111011101,
  parameter                   cvp_hip_clk_sel_default                                                         = "false",
  parameter                   pf0_lane_equalization_control67_reg_rsvdp_7                                     = "false",
  parameter                   pf1_bar1_type                                                                   = "pf1_bar1_mem32",
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte3                                     = 24'b001000000001000111110011,
  parameter                   pf0_gen3_equalization_disable                                                   = "enable",
  parameter                   pf0_lane_equalization_control67_reg_rsvdp_23                                    = "false",
  parameter  [7:0]            pf0_fast_training_seq                                                           = 8'b11111111,
  parameter  [2:0]            pf0_dsp_rx_preset_hint5                                                         = 3'b111,
  parameter  [23:0]           pf0_port_logic_symbol_timer_filter_1_off_addr_byte1                             = 24'b000000000000011100011101,
  parameter  [23:0]           pf0_sriov_cap_shadow_sriov_initial_vfs_addr_byte1                               = 24'b001000000000000111000101,
  parameter  [11:0]           pf1_sriov_next_offset                                                           = 12'b001001111000,
  parameter  [23:0]           pf1_type0_hdr_bar3_mask_reg_addr_byte3                                          = 24'b001000000001000000011111,
  parameter  [23:0]           pf1_reserved_4_addr                                                             = 24'b000000000000000000000000,
  parameter  [11:0]           pf1_sn_next_offset                                                              = 12'b000101111000,
  parameter                   virtual_pf0_prefetch_decode                                                     = "pref64",
  parameter                   hrc_pll_cal_done_active                                                         = "pll_cal_done_34",
  parameter                   pf0_sriov_vf_bar1_enabled                                                       = "enable",
  parameter                   pf1_pci_msix_enable_vfcomm_cs2                                                  = "false",
  parameter                   pf0_pcie_cap_en_clk_power_man                                                   = "pf0_clkreq_dis",
  parameter  [23:0]           pf1_sriov_cap_sriov_vf_offset_position_addr_byte3                               = 24'b000000000001000111001111,
  parameter  [4:0]            pf0_tph_req_cap_reg_rsvdp_27                                                    = 5'b00000,
  parameter  [23:0]           pf0_type0_hdr_class_code_revision_id_addr_byte2                                 = 24'b000000000000000000001010,
  parameter  [23:0]           pf0_tph_cap_tph_req_cap_reg_addr_byte3                                          = 24'b000000000000000111111111,
  parameter  [23:0]           pf0_sriov_cap_vf_bar5_reg_addr_byte0                                            = 24'b000000000000000111110000,
  parameter  [23:0]           pf0_pcie_cap_link_control_link_status_reg_addr_byte0                            = 24'b010000000000000010000000,
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte1                                     = 24'b001000000001000111011101,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control67_reg_addr_byte1                        = 24'b000000000000000110100001,
  parameter  [6:0]            pf0_pci_type0_bar3_dummy_mask_7_1                                               = 7'b1111111,
  parameter  [3:0]            pf0_sriov_vf_bar5_start                                                         = 4'b0000,
  parameter  [23:0]           pf0_reserved_39_addr                                                            = 24'b000000000000000000000000,
  parameter                   clock_ctl_rsvd_5                                                                = "false",
  parameter  [23:0]           pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte1                               = 24'b001000000001000111111101,
  parameter                   pf1_sriov_vf_bar3_enabled                                                       = "enable",
  parameter                   pf1_bar4_mem_io                                                                 = "pf1_bar4_mem",
  parameter                   clkmod_pclk_sel                                                                 = "pclk_ch7",
  parameter  [3:0]            pf0_vc_cap_version                                                              = 4'b0001,
  parameter  [23:0]           pf0_reserved_5_addr                                                             = 24'b000000000000000000000000,
  parameter                   pf0_pci_msix_enable                                                             = "false",
  parameter  [23:0]           pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte2                                    = 24'b000000000000000000101010,
  parameter                   pf1_forward_user_vsec                                                           = "false",
  parameter  [23:0]           pf0_reserved_20_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_tph_cap_tph_req_cap_reg_addr_byte0                                          = 24'b000000000000000111111100,
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte3                                     = 24'b001000000001000111101011,
  parameter  [3:0]            pf0_dsp_tx_preset13                                                             = 4'b1111,
  parameter                   pf1_shadow_link_capabilities_reg_shadow_rsvdp_23                                = "false",
  parameter  [7:0]            pf0_dbi_reserved_37                                                             = 8'b00000000,
  parameter                   hrc_rstctl_timer_type_h                                                         = "fref_cyc_h",
  parameter  [11:0]           pf1_aer_next_offset                                                             = 12'b000101001000,
  parameter  [23:0]           pf1_sn_cap_ser_num_reg_dw_2_addr_byte2                                          = 24'b000000000001000101110010,
  parameter  [23:0]           pf0_pcie_cap_device_capabilities_reg_addr_byte2                                 = 24'b000000000000000001110110,
  parameter  [23:0]           pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte3                           = 24'b000000000000000010110011,
  parameter                   clkmod_pld_clk_out_sel                                                          = "div1",
  parameter  [23:0]           pf0_sn_cap_ser_num_reg_dw_1_addr_byte1                                          = 24'b000000000000000101101101,
  parameter  [23:0]           pf0_msix_cap_msix_pba_offset_reg_addr_byte3                                     = 24'b000000000000000010111011,
  parameter                   pf1_pcie_cap_en_clk_power_man                                                   = "pf1_clkreq_dis",
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte2                                     = 24'b001000000000000111100110,
  parameter  [23:0]           pf0_type0_hdr_bar1_mask_reg_addr_byte3                                          = 24'b001000000000000000010111,
  parameter  [7:0]            pf0_dbi_reserved_11                                                             = 8'b00000000,
  parameter  [3:0]            pf0_dsp_tx_preset4                                                              = 4'b1111,
  parameter                   pf0_cap_id_nxt_ptr_reg_rsvdp_20                                                 = "false",
  parameter                   pf1_pcie_cap_link_bw_man_status                                                 = "false",
  parameter                   pf0_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvd                             = "false",
  parameter  [5:0]            pld_tx_fifo_full_threshold                                                      = 6'b101000,
  parameter  [23:0]           pf0_type0_hdr_class_code_revision_id_addr_byte0                                 = 24'b000000000000000000001000,
  parameter                   pf0_tph_req_no_st_mode_vfcomm_cs2                                               = "false",
  parameter  [23:0]           pf0_port_logic_gen3_eq_fb_mode_dir_change_off_addr_byte0                        = 24'b000000000000100010101100,
  parameter  [23:0]           pf1_reserved_10_addr                                                            = 24'b000000000000000000000000,
  parameter  [7:0]            pf1_dbi_reserved_9                                                              = 8'b00000000,
  parameter                   pf0_bar3_mem_io                                                                 = "pf0_bar3_mem",
  parameter  [3:0]            cvp_vsec_rev                                                                    = 4'b0000,
  parameter  [7:0]            hrc_rstctl_timer_value_h                                                        = 8'b00000100,
  parameter  [23:0]           pf0_pcie_cap_link_capabilities_reg_addr_byte2                                   = 24'b000000000000000001111110,
  parameter  [7:0]            pf0_dbi_reserved_43                                                             = 8'b00000000,
  parameter  [23:0]           pf0_reserved_33_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_pcie_cap_slot_capabilities_reg_addr_byte3                                   = 24'b000000000000000010000111,
  parameter  [23:0]           pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte3                        = 24'b001000000001000111001111,
  parameter                   pf0_lane_equalization_control1011_reg_rsvdp_31                                  = "false",
  parameter  [23:0]           pf1_type0_hdr_bar5_mask_reg_addr_byte2                                          = 24'b001000000001000000100110,
  parameter  [23:0]           pf0_port_logic_port_link_ctrl_off_addr_byte2                                    = 24'b000000000000011100010010,
  parameter                   pf0_eq_eieos_cnt                                                                = "enable",
  parameter                   hrc_tx_lc_pll_rstb_active                                                       = "tx_lc_pll_rstb_78",
  parameter  [23:0]           pf1_type0_hdr_class_code_revision_id_addr_byte3                                 = 24'b000000000001000000001011,
  parameter  [23:0]           pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte3                                    = 24'b000000000001000000101011,
  parameter                   cvp_clk_sel                                                                     = "false",
  parameter  [23:0]           pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte1                                   = 24'b001000000000000000110001,
  parameter  [23:0]           vf1_pf1_ari_cap_vf_ari_base_addr_byte3                                          = 24'b000100000001000100000011,
  parameter  [23:0]           pf1_pcie_cap_device_capabilities_reg_addr_byte1                                 = 24'b000000000001000001110101,
  parameter  [23:0]           pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte3                                   = 24'b001000000000000000110011,
  parameter  [23:0]           pf1_msix_cap_msix_pba_offset_reg_addr_byte0                                     = 24'b000000000001000010111000,
  parameter  [3:0]            pf0_dsp_tx_preset10                                                             = 4'b1111,
  parameter  [23:0]           pf0_sriov_cap_vf_device_id_reg_addr_byte2                                       = 24'b000000000000000111010010,
  parameter  [3:0]            pf0_dsp_tx_preset15                                                             = 4'b1111,
  parameter  [23:0]           pf0_reserved_18_addr                                                            = 24'b000000000000000000000000,
  parameter  [7:0]            pf0_common_clk_n_fts                                                            = 8'b11111111,
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte3                                     = 24'b001000000000000111101011,
  parameter  [15:0]           hrc_chnl_txpll_rst_en                                                           = 16'b0000000110000000,
  parameter  [23:0]           pf0_port_logic_queue_status_off_addr_byte3                                      = 24'b000000000000011100111111,
  parameter                   pf0_bar3_type                                                                   = "pf0_bar3_mem32",
  parameter  [11:0]           pf0_ats_next_offset                                                             = 12'b000000000000,
  parameter  [23:0]           pf0_port_logic_gen2_ctrl_off_addr_byte1                                         = 24'b000000000000100000001101,
  parameter  [23:0]           pf0_port_logic_gen3_related_off_addr_byte2                                      = 24'b000000000000100010010010,
  parameter  [23:0]           pf1_msix_cap_msix_pba_offset_reg_addr_byte1                                     = 24'b000000000001000010111001,
  parameter  [23:0]           pf1_type0_hdr_bar1_reg_addr_byte0                                               = 24'b000000000001000000010100,
  parameter                   hrc_fref_clk_active                                                             = "fref_clk_sel_0",
  parameter                   pf0_pcie_cap_max_link_speed                                                     = "pf0_max_8gts",
  parameter                   pf1_sriov_vf_bar1_enabled                                                       = "enable",
  parameter  [17:0]           cfg_g3_pset_coeff_8                                                             = 18'b001000101111001000,
  parameter  [23:0]           pf1_type0_hdr_bar0_mask_reg_addr_byte1                                          = 24'b001000000001000000010001,
  parameter  [7:0]            pf0_dbi_reserved_34                                                             = 8'b00000000,
  parameter  [23:0]           pf1_type0_hdr_bar1_mask_reg_addr_byte3                                          = 24'b001000000001000000010111,
  parameter                   pf1_pcie_cap_link_auto_bw_int_en                                                = "false",
  parameter  [3:0]            pf0_dsp_tx_preset7                                                              = 4'b1111,
  parameter  [23:0]           pf1_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte3              = 24'b000000000001000001110011,
  parameter  [23:0]           pf0_type0_hdr_bar5_mask_reg_addr_byte0                                          = 24'b001000000000000000100100,
  parameter  [23:0]           pf0_reserved_59_addr                                                            = 24'b000000000000000000000000,
  parameter                   pf0_sriov_vf_bar5_type                                                          = "pf0_sriov_vf_bar5_mem32",
  parameter  [23:0]           pf1_pcie_cap_link_capabilities_reg_addr_byte1                                   = 24'b000000000001000001111101,
  parameter                   pf1_shadow_pcie_cap_dll_active_rep_cap                                          = "false",
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte2                                     = 24'b001000000001000111101110,
  parameter  [7:0]            pf0_dbi_reserved_23                                                             = 8'b00000000,
  parameter  [17:0]           cfg_g3_pset_coeff_4                                                             = 18'b000000111111000000,
  parameter  [23:0]           pf0_sn_cap_ser_num_reg_dw_2_addr_byte2                                          = 24'b000000000000000101110010,
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte1                                     = 24'b001000000000000111100001,
  parameter  [1:0]            pf0_gen2_ctrl_off_rsvdp_22                                                      = 2'b00,
  parameter  [1:0]            pf1_power_state                                                                 = 2'b00,
  parameter  [23:0]           pf0_port_logic_pipe_loopback_control_off_addr_byte3                             = 24'b000000000000100010111011,
  parameter                   pf0_pcie_cap_en_no_snoop                                                        = "false",
  parameter                   pf0_pcie_cap_enter_compliance                                                   = "false",
  parameter  [3:0]            pf0_dsp_tx_preset9                                                              = 4'b1111,
  parameter  [7:0]            pf1_dbi_reserved_8                                                              = 8'b00000000,
  parameter                   pf0_lane_equalization_control1415_reg_rsvdp_23                                  = "false",
  parameter                   pf0_lane_equalization_control23_reg_rsvdp_7                                     = "false",
  parameter  [23:0]           pf1_sriov_cap_vf_bar3_reg_addr_byte0                                            = 24'b000000000001000111101000,
  parameter  [23:0]           pf1_reserved_16_addr                                                            = 24'b000000000000000000000000,
  parameter  [7:0]            pf0_dbi_reserved_26                                                             = 8'b00000000,
  parameter                   pf1_bar5_mem_io                                                                 = "pf1_bar5_mem",
  parameter                   pf0_ats_capabilities_ctrl_reg_rsvdp_7                                           = "false",
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte0                                     = 24'b001000000000000111101000,
  parameter  [23:0]           pf1_type0_hdr_bar4_reg_addr_byte0                                               = 24'b000000000001000000100000,
  parameter  [2:0]            pf0_device_capabilities_reg_rsvdp_29                                            = 3'b000,
  parameter  [7:0]            pf0_dbi_reserved_51                                                             = 8'b00000000,
  parameter  [7:0]            pf0_vc0_p_header_credit                                                         = 8'b01111111,
  parameter                   pf0_vf_bar1_reg_rsvdp_0                                                         = "false",
  parameter  [2:0]            pf0_device_capabilities_reg_rsvdp_12                                            = 3'b000,
  parameter  [23:0]           pf0_sriov_cap_sup_page_sizes_reg_addr_byte3                                     = 24'b000000000000000111010111,
  parameter                   pf0_gen3_dc_balance_disable                                                     = "enable",
  parameter  [23:0]           pf0_reserved_9_addr                                                             = 24'b000000000000000000000000,
  parameter                   pf0_bar5_type                                                                   = "pf0_bar5_mem32",
  parameter  [11:0]           vf1_pf0_ari_next_offset                                                         = 12'b000101011000,
  parameter  [23:0]           pf0_port_logic_gen3_eq_local_fs_lf_off_addr_byte1                               = 24'b000000000000100010010101,
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte3                                     = 24'b001000000000000111011111,
  parameter  [23:0]           pf1_sriov_cap_vf_bar0_reg_addr_byte0                                            = 24'b000000000001000111011100,
  parameter  [23:0]           vf1_pf1_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte2                               = 24'b000100000001000100010010,
  parameter  [2:0]            pf1_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                = 3'b000,
  parameter  [9:0]            pf1_exp_rom_bar_mask_reg_rsvdp_1                                                = 10'b0000000000,
  parameter  [6:0]            pf1_exp_rom_base_addr_reg_rsvdp_1                                               = 7'b0000000,
  parameter                   pf0_tph_req_extended_tph_vfcomm_cs2                                             = "disable",
  parameter                   pf1_link_capabilities_reg_rsvdp_23                                              = "false",
  parameter  [23:0]           pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte2                           = 24'b000000000000000010110010,
  parameter  [3:0]            pf0_tph_req_cap_ver                                                             = 4'b0001,
  parameter                   pf1_pme_clk                                                                     = "false",
  parameter  [15:0]           pf1_sriov_initial_vfs_nonari                                                    = 16'b0000000001000000,
  parameter  [1:0]            pf0_link_control_link_status_reg_rsvdp_25                                       = 2'b00,
  parameter  [2:0]            k_phy_misc_ctrl_rsvd_13_15                                                      = 3'b000,
  parameter  [8:0]            cfg_dbi_pf1_start_addr                                                          = 9'b101000000,
  parameter  [23:0]           pf0_sriov_cap_sriov_initial_vfs_addr_byte0                                      = 24'b000000000000000111000100,
  parameter                   pf0_pcie_cap_retrain_link                                                       = "false",
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte2                                     = 24'b001000000001000111100110,
  parameter  [23:0]           pf1_ari_cap_ari_base_addr_byte3                                                 = 24'b000000000001000101111011,
  parameter  [23:0]           pf1_tph_cap_tph_req_cap_reg_addr_byte3                                          = 24'b000000000001000111111111,
  parameter  [23:0]           pf0_reserved_46_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_pm_cap_con_status_reg_addr_byte0                                            = 24'b000000000000000001000100,
  parameter                   pf1_shadow_pcie_cap_aspm_opt_compliance                                         = "false",
  parameter  [3:0]            pf0_gen3_eq_local_fs_lf_off_rsvdp_12                                            = 4'b0000,
  parameter                   aux_cfg_vf_en                                                                   = "true",
  parameter  [23:0]           pf0_sn_cap_ser_num_reg_dw_2_addr_byte3                                          = 24'b000000000000000101110011,
  parameter                   pf1_pcie_cap_link_bw_not_cap                                                    = "false",
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte1                                     = 24'b001000000001000111101001,
  parameter  [7:0]            pf0_dbi_reserved_14                                                             = 8'b00000000,
  parameter  [23:0]           pf0_reserved_4_addr                                                             = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_type0_hdr_bar0_reg_addr_byte0                                               = 24'b000000000000000000010000,
  parameter                   pf0_pcie_cap_active_state_link_pm_support                                       = "pf0_no_aspm",
  parameter  [7:0]            pf1_pci_msix_cap_next_offset                                                    = 8'b00000000,
  parameter  [23:0]           pf0_port_logic_vc0_cpl_rx_q_ctrl_off_addr_byte1                                 = 24'b000000000000011101010001,
  parameter  [7:0]            pf0_dbi_reserved_41                                                             = 8'b00000000,
  parameter  [23:0]           pf0_port_logic_vc0_p_rx_q_ctrl_off_addr_byte1                                   = 24'b000000000000011101001001,
  parameter  [1:0]            pf1_shadow_pcie_cap_max_link_width                                              = 2'b00,
  parameter  [23:0]           pf0_msix_cap_msix_pba_offset_reg_addr_byte0                                     = 24'b000000000000000010111000,
  parameter                   pld_tx_fifo_dyn_empty_dis                                                       = "false",
  parameter                   ecc_gen_val                                                                     = "false",
  parameter                   vf1_pf0_shadow_pcie_cap_aspm_opt_compliance                                     = "false",
  parameter  [23:0]           pf0_tph_cap_tph_req_cap_reg_addr_byte2                                          = 24'b000000000000000111111110,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte2                      = 24'b000000000000000110110010,
  parameter                   pf1_vf_bar2_reg_rsvdp_0                                                         = "false",
  parameter  [23:0]           pf1_type0_hdr_bar2_mask_reg_addr_byte2                                          = 24'b001000000001000000011010,
  parameter  [7:0]            pf0_dbi_reserved_8                                                              = 8'b00000000,
  parameter  [23:0]           pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte0                        = 24'b001000000000000111001100,
  parameter  [23:0]           pf1_type0_hdr_bar3_mask_reg_addr_byte0                                          = 24'b001000000001000000011100,
  parameter                   hrc_tx_pcs_rst_n_active                                                         = "tx_pcs_rst_0_to_15",
  parameter  [23:0]           pf0_aer_cap_root_err_status_off_addr_byte0                                      = 24'b000000000000000100110000,
  parameter  [23:0]           pf0_spcie_cap_spcie_cap_header_reg_addr_byte2                                   = 24'b000000000000000110001010,
  parameter  [1:0]            pf0_shadow_pcie_cap_active_state_link_pm_support                                = 2'b00,
  parameter  [23:0]           pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte2                                = 24'b001000000000000000111010,
  parameter  [23:0]           pf0_reserved_3_addr                                                             = 24'b000000000000000000000000,
  parameter  [23:0]           pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte0                   = 24'b000000000001000000101100,
  parameter  [3:0]            pf0_dsp_tx_preset8                                                              = 4'b1111,
  parameter                   pf0_scramble_disable                                                            = "false",
  parameter  [23:0]           pf1_reserved_1_addr                                                             = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_port_logic_gen3_eq_fb_mode_dir_change_off_addr_byte2                        = 24'b000000000000100010101110,
  parameter  [23:0]           pf0_reserved_40_addr                                                            = 24'b000000000000000000000000,
  parameter  [11:0]           vf1_pf1_ari_next_offset                                                         = 12'b000101011000,
  parameter  [7:0]            pf0_dbi_reserved_53                                                             = 8'b00000000,
  parameter  [23:0]           pf0_reserved_22_addr                                                            = 24'b000000000000000000000000,
  parameter                   pf1_pcie_cap_active_state_link_pm_control                                       = "pf1_aspm_dis",
  parameter  [23:0]           pf1_type0_hdr_bist_header_type_latency_cache_line_size_reg_addr_byte2           = 24'b000000000001000000001110,
  parameter  [23:0]           pf0_sriov_cap_vf_device_id_reg_addr_byte3                                       = 24'b000000000000000111010011,
  parameter  [23:0]           pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte3                        = 24'b001000000000000111001111,
  parameter                   pf0_max_func_num                                                                = "pf0_one_function",
  parameter  [23:0]           pf1_type0_hdr_bar4_mask_reg_addr_byte0                                          = 24'b001000000001000000100000,
  parameter  [23:0]           pf1_sriov_cap_sup_page_sizes_reg_addr_byte1                                     = 24'b000000000001000111010101,
  parameter                   pf1_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvdp_31                         = "false",
  parameter                   pf0_pci_msix_function_mask                                                      = "false",
  parameter  [4:0]            pf0_tph_req_cap_reg_vfcomm_cs2_rsvdp_3_vfcomm_cs2                               = 5'b00000,
  parameter                   pf0_bar5_mem_io                                                                 = "pf0_bar5_mem",
  parameter  [6:0]            pf1_pci_type0_bar5_dummy_mask_7_1                                               = 7'b1111111,
  parameter                   pf0_sriov_vf_bar3_prefetch                                                      = "false",
  parameter  [23:0]           pf0_port_logic_vc0_np_rx_q_ctrl_off_addr_byte1                                  = 24'b000000000000011101001101,
  parameter                   pf0_vf_bar2_reg_rsvdp_0                                                         = "false",
  parameter                   pf0_pcie_cap_link_bw_man_status                                                 = "false",
  parameter                   pf0_lane_equalization_control1011_reg_rsvdp_15                                  = "false",
  parameter  [2:0]            pf0_pci_msix_cap_id_next_ctrl_reg_rsvdp_27                                      = 3'b000,
  parameter  [3:0]            pf1_ats_cap_version                                                             = 4'b0001,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte1                      = 24'b000000000000000110101101,
  parameter  [23:0]           pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte1                        = 24'b001000000001000111001101,
  parameter  [23:0]           pf1_type0_hdr_bar0_reg_addr_byte0                                               = 24'b000000000001000000010000,
  parameter                   pf0_lane_equalization_control23_reg_rsvdp_23                                    = "false",
  parameter  [23:0]           pf0_port_logic_filter_mask_2_off_addr_byte2                                     = 24'b000000000000011100100010,
  parameter  [7:0]            pf0_dbi_reserved_12                                                             = 8'b00000000,
  parameter  [23:0]           pf1_reserved_13_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control23_reg_addr_byte0                        = 24'b000000000000000110011000,
  parameter  [23:0]           pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte1                   = 24'b000000000001000000101101,
  parameter  [23:0]           pf0_type0_hdr_max_latency_min_grant_interrupt_pin_interrupt_line_reg_addr_byte1 = 24'b000000000000000000111101,
  parameter  [23:0]           pf1_sriov_cap_sriov_initial_vfs_addr_byte1                                      = 24'b000000000001000111000101,
  parameter                   pf0_lane_equalization_control1415_reg_rsvdp_15                                  = "false",
  parameter  [2:0]            pf1_pm_spec_ver                                                                 = 3'b011,
  parameter                   pf0_pci_msix_function_mask_vfcomm_cs2                                           = "false",
  parameter  [3:0]            pf0_con_status_reg_rsvdp_4                                                      = 4'b0000,
  parameter                   pf0_shadow_pcie_cap_link_bw_not_cap                                             = "false",
  parameter                   pf1_link_control_link_status_reg_rsvdp_9                                        = "false",
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control01_reg_addr_byte1                        = 24'b000000000000000110010101,
  parameter  [23:0]           pf1_type0_hdr_bar2_mask_reg_addr_byte0                                          = 24'b001000000001000000011000,
  parameter                   pf0_pcie_cap_aux_power_pm_en                                                    = "false",
  parameter                   pf0_pcie_cap_clock_power_man                                                    = "pf0_refclk_remove_not_ok",
  parameter  [7:0]            pf0_link_num                                                                    = 8'b00000100,
  parameter  [23:0]           pf0_tph_cap_tph_req_cap_reg_addr_byte1                                          = 24'b000000000000000111111101,
  parameter  [23:0]           pf1_sriov_cap_vf_bar2_reg_addr_byte0                                            = 24'b000000000001000111100100,
  parameter  [23:0]           pf0_reserved_16_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf1_msix_cap_msix_table_offset_reg_addr_byte0                                   = 24'b000000000001000010110100,
  parameter  [23:0]           pf0_tph_cap_tph_ext_cap_hdr_reg_addr_byte2                                      = 24'b000000000000000111111010,
  parameter  [23:0]           pf1_reserved_12_addr                                                            = 24'b000000000000000000000000,
  parameter                   vf1_pf1_shadow_pcie_cap_dll_active_rep_cap                                      = "false",
  parameter  [23:0]           pf0_type0_hdr_pci_cap_ptr_reg_addr_byte0                                        = 24'b000000000000000000110100,
  parameter  [3:0]            pf1_bar2_start                                                                  = 4'b0000,
  parameter  [7:0]            pf0_revision_id                                                                 = 8'b00000001,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte1                      = 24'b000000000000000110110001,
  parameter                   pf1_sriov_vf_bar5_prefetch                                                      = "false",
  parameter  [23:0]           pf0_pcie_cap_device_capabilities_reg_addr_byte0                                 = 24'b000000000000000001110100,
  parameter  [7:0]            hrc_rstctl_timer_value_a                                                        = 8'b00001010,
  parameter  [23:0]           pf0_reserved_57_addr                                                            = 24'b000000000000000000000000,
  parameter  [11:0]           vsec_next_offset                                                                = 12'b000000000000,
  parameter                   pf1_multi_func                                                                  = "true",
  parameter  [23:0]           pf0_port_logic_symbol_timer_filter_1_off_addr_byte2                             = 24'b000000000000011100011110,
  parameter  [7:0]            pf1_dbi_reserved_11                                                             = 8'b00000000,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control89_reg_addr_byte2                        = 24'b000000000000000110100110,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte3                      = 24'b000000000000000110101011,
  parameter                   pf1_vf_forward_user_vsec                                                        = "false",
  parameter  [23:0]           pf1_pcie_cap_link_control_link_status_reg_addr_byte1                            = 24'b010000000001000010000001,
  parameter  [23:0]           pf0_type0_hdr_bar5_mask_reg_addr_byte3                                          = 24'b001000000000000000100111,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control89_reg_addr_byte1                        = 24'b000000000000000110100101,
  parameter  [15:0]           virtual_pf0_sriov_num_vf_ari                                                    = 16'b0000000000000000,
  parameter  [3:0]            pf1_bar4_start                                                                  = 4'b0000,
  parameter                   pf0_port_link_ctrl_off_rsvdp_4                                                  = "false",
  parameter                   pf0_link_control_link_status_reg_rsvdp_2                                        = "false",
  parameter  [3:0]            vf1_pf1_ari_cap_version                                                         = 4'b0001,
  parameter  [7:0]            pf0_dbi_reserved_44                                                             = 8'b00000000,
  parameter  [2:0]            pf0_vc0_p_tlp_q_mode                                                            = 3'b001,
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte3                                     = 24'b001000000000000111100011,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control01_reg_addr_byte3                        = 24'b000000000000000110010111,
  parameter                   pf0_pcie_cap_link_training                                                      = "false",
  parameter                   pf1_shadow_pcie_cap_surprise_down_err_rep_cap                                   = "false",
  parameter  [23:0]           pf0_sriov_cap_sriov_base_reg_addr_byte2                                         = 24'b000000000000000110111010,
  parameter                   pf1_sriov_vf_bar3_prefetch                                                      = "false",
  parameter  [23:0]           pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte1                                   = 24'b001000000001000000110001,
  parameter  [23:0]           pf1_tph_cap_tph_req_cap_reg_addr_byte0                                          = 24'b000000000001000111111100,
  parameter  [11:0]           pf1_tph_req_next_ptr                                                            = 12'b001011011000,
  parameter                   pf1_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvd                             = "false",
  parameter  [23:0]           pf0_type0_hdr_device_id_vendor_id_reg_addr_byte1                                = 24'b000000000000000000000001,
  parameter  [23:0]           pf0_reserved_47_addr                                                            = 24'b000000000000000000000000,
  parameter                   sim_mode                                                                        = "enable",
  parameter  [23:0]           vf_reserved_1_addr                                                              = 24'b000000000000000000000000,
  parameter                   pf1_pcie_cap_tx_margin                                                          = "false",
  parameter  [7:0]            pf0_dbi_reserved_22                                                             = 8'b00000000,
  parameter                   pf1_sriov_vf_bar3_type                                                          = "pf1_sriov_vf_bar3_mem32",
  parameter  [23:0]           pf0_reserved_36_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control23_reg_addr_byte2                        = 24'b000000000000000110011010,
  parameter  [23:0]           pf0_reserved_30_addr                                                            = 24'b000000000000000000000000,
  parameter                   pf1_pcie_cap_hw_auto_speed_disable                                              = "false",
  parameter  [23:0]           pf0_type0_hdr_bar2_reg_addr_byte0                                               = 24'b000000000000000000011000,
  parameter  [23:0]           pf1_sriov_cap_sriov_base_reg_addr_byte3                                         = 24'b000000000001000110111011,
  parameter  [3:0]            pf1_sriov_vf_bar1_start                                                         = 4'b0000,
  parameter  [23:0]           pf1_ats_cap_ats_cap_hdr_reg_addr_byte3                                          = 24'b000000000001001010000111,
  parameter  [23:0]           pf0_type0_hdr_bar1_mask_reg_addr_byte0                                          = 24'b001000000000000000010100,
  parameter                   vf1_pf1_shadow_pcie_cap_aspm_opt_compliance                                     = "false",
  parameter                   pf0_sriov_vf_bar1_prefetch                                                      = "false",
  parameter  [3:0]            pf0_sriov_vf_bar1_start                                                         = 4'b0000,
  parameter                   pf0_lane_equalization_control1213_reg_rsvdp_7                                   = "false",
  parameter                   pf1_shadow_pcie_cap_clock_power_man                                             = "false",
  parameter  [23:0]           pf0_type0_hdr_bar3_enable_reg_addr_byte0                                        = 24'b001000000000000000011100,
  parameter  [23:0]           pf1_type0_hdr_bar3_enable_reg_addr_byte0                                        = 24'b001000000001000000011100,
  parameter  [7:0]            pf0_dbi_reserved_24                                                             = 8'b00000000,
  parameter  [15:0]           hip_pcs_chnl_en                                                                 = 16'b1111111111111111,
  parameter                   pf0_pme_clk                                                                     = "false",
  parameter  [23:0]           pf0_sriov_cap_sup_page_sizes_reg_addr_byte0                                     = 24'b000000000000000111010100,
  parameter  [23:0]           pf1_type0_hdr_bar5_reg_addr_byte0                                               = 24'b000000000001000000100100,
  parameter  [23:0]           pf0_reserved_7_addr                                                             = 24'b000000000000000000000000,
  parameter                   pf0_lane_equalization_control67_reg_rsvdp_15                                    = "false",
  parameter                   pf0_pcie_cap_tx_margin                                                          = "false",
  parameter  [11:0]           pf0_vc0_np_data_credit                                                          = 12'b000011100110,
  parameter  [2:0]            pf0_dsp_rx_preset_hint1                                                         = 3'b111,
  parameter  [23:0]           pf0_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte2                             = 24'b000000000000000001010010,
  parameter  [23:0]           pf0_ari_cap_ari_base_addr_byte2                                                 = 24'b000000000000000101111010,
  parameter                   pf1_bar5_type                                                                   = "pf1_bar5_mem32",
  parameter  [23:0]           pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte2                           = 24'b000000000001000010110010,
  parameter                   cvp_mode_gating_dis                                                             = "false",
  parameter                   pf0_sriov_vf_bar5_prefetch                                                      = "false",
  parameter                   pf0_gen1_ei_inference                                                           = "pf0_use_rx_eidle",
  parameter  [23:0]           pf1_type0_hdr_class_code_revision_id_addr_byte1                                 = 24'b000000000001000000001001,
  parameter  [23:0]           pf1_sn_cap_ser_num_reg_dw_1_addr_byte0                                          = 24'b000000000001000101101100,
  parameter                   pf0_pcie_cap_max_payload_size                                                   = "pf0_payload_1024",
  parameter  [2:0]            pf0_pcie_cap_max_read_req_size                                                  = 3'b000,
  parameter  [23:0]           pf0_reserved_15_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte2                      = 24'b000000000000000110101110,
  parameter  [7:0]            pf1_dbi_reserved_16                                                             = 8'b00000000,
  parameter  [23:0]           pf1_reserved_14_addr                                                            = 24'b000000000000000000000000,
  parameter                   pf1_pci_type0_bar1_enabled_or_mask64lsb                                         = "disable",
  parameter  [2:0]            pf0_dsp_rx_preset_hint11                                                        = 3'b111,
  parameter  [7:0]            vf_dbi_reserved_2                                                               = 8'b00000000,
  parameter  [1:0]            pf1_link_control_link_status_reg_rsvdp_25                                       = 2'b00,
  parameter                   pf1_pcie_cap_phantom_func_en                                                    = "false",
  parameter  [1:0]            pf1_pcie_cap_phantom_func_support                                               = 2'b00,
  parameter                   cvp_rate_sel                                                                    = "false",
  parameter  [23:0]           pf1_msix_cap_msix_table_offset_reg_addr_byte2                                   = 24'b000000000001000010110110,
  parameter  [7:0]            pf0_dbi_reserved_13                                                             = 8'b00000000,
  parameter  [23:0]           pf0_reserved_1_addr                                                             = 24'b000000000000000000000000,
  parameter  [7:0]            pf1_dbi_reserved_17                                                             = 8'b00000000,
  parameter  [2:0]            pf0_dsp_rx_preset_hint2                                                         = 3'b111,
  parameter  [23:0]           pf1_sriov_cap_sup_page_sizes_reg_addr_byte0                                     = 24'b000000000001000111010100,
  parameter                   pf0_reserved8                                                                   = "false",
  parameter  [23:0]           pf1_sriov_cap_sup_page_sizes_reg_addr_byte2                                     = 24'b000000000001000111010110,
  parameter  [23:0]           pf0_sn_cap_ser_num_reg_dw_2_addr_byte0                                          = 24'b000000000000000101110000,
  parameter  [23:0]           pf1_type0_hdr_bar0_mask_reg_addr_byte3                                          = 24'b001000000001000000010011,
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte2                                     = 24'b001000000000000111101010,
  parameter  [23:0]           pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte0                                    = 24'b000000000000000000101000,
  parameter                   pf0_lane_equalization_control45_reg_rsvdp_15                                    = "false",
  parameter  [23:0]           pf1_sn_cap_ser_num_reg_dw_2_addr_byte0                                          = 24'b000000000001000101110000,
  parameter  [23:0]           pf0_port_logic_filter_mask_2_off_addr_byte0                                     = 24'b000000000000011100100000,
  parameter  [23:0]           pf0_sriov_cap_sriov_vf_offset_position_addr_byte3                               = 24'b000000000000000111001111,
  parameter  [23:0]           pf0_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte3              = 24'b000000000000000001110011,
  parameter  [23:0]           pf1_tph_cap_tph_ext_cap_hdr_reg_addr_byte3                                      = 24'b000000000001000111111011,
  parameter  [23:0]           pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte3                                = 24'b001000000000000000111011,
  parameter  [23:0]           pf0_sriov_cap_sriov_vf_offset_position_addr_byte2                               = 24'b000000000000000111001110,
  parameter  [23:0]           pf0_port_logic_vc0_cpl_rx_q_ctrl_off_addr_byte0                                 = 24'b000000000000011101010000,
  parameter  [2:0]            pf0_dsp_rx_preset_hint9                                                         = 3'b111,
  parameter  [23:0]           pf1_type0_hdr_bar4_mask_reg_addr_byte2                                          = 24'b001000000001000000100010,
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte3                                     = 24'b001000000001000111011111,
  parameter  [23:0]           pf1_reserved_6_addr                                                             = 24'b000000000000000000000000,
  parameter  [23:0]           pf1_type0_hdr_bar4_mask_reg_addr_byte3                                          = 24'b001000000001000000100011,
  parameter  [6:0]            pf1_sriov_vf_bar5_dummy_mask_7_1                                                = 7'b1111111,
  parameter  [3:0]            pf1_sriov_vf_bar2_start                                                         = 4'b0000,
  parameter  [23:0]           pf0_pcie_cap_slot_capabilities_reg_addr_byte0                                   = 24'b000000000000000010000100,
  parameter                   pf0_cross_link_en                                                               = "false",
  parameter  [3:0]            pf0_dsp_tx_preset3                                                              = 4'b1111,
  parameter  [23:0]           pf1_reserved_0_addr                                                             = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control67_reg_addr_byte0                        = 24'b000000000000000110100000,
  parameter                   pld_aib_loopback_en                                                             = "false",
  parameter  [3:0]            pf1_bar5_start                                                                  = 4'b0000,
  parameter  [23:0]           pf1_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte1                             = 24'b000000000001000001010001,
  parameter                   pf1_pci_msix_function_mask                                                      = "false",
  parameter  [23:0]           pf0_type0_hdr_bar3_mask_reg_addr_byte2                                          = 24'b001000000000000000011110,
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte2                                     = 24'b001000000001000111101010,
  parameter  [23:0]           pf0_reserved_56_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_port_logic_queue_status_off_addr_byte2                                      = 24'b000000000000011100111110,
  parameter  [23:0]           pf0_type0_hdr_bar1_enable_reg_addr_byte0                                        = 24'b001000000000000000010100,
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte3                                     = 24'b001000000001000111100011,
  parameter  [7:0]            pf0_dbi_reserved_9                                                              = 8'b00000000,
  parameter  [17:0]           cfg_g3_pset_coeff_2                                                             = 18'b001101110010000000,
  parameter                   pf1_bar3_type                                                                   = "pf1_bar3_mem32",
  parameter                   pf1_pcie_cap_aspm_opt_compliance                                                = "true",
  parameter  [11:0]           pf1_ari_next_offset                                                             = 12'b000110011000,
  parameter                   eqctrl_legacy_mode_en                                                           = "false",
  parameter                   hrc_force_inactive_rst                                                          = "false",
  parameter  [7:0]            hrc_rstctl_timer_value_j                                                        = 8'b00010100,
  parameter  [2:0]            pf0_dsp_rx_preset_hint13                                                        = 3'b111,
  parameter  [7:0]            pf1_dbi_reserved_10                                                             = 8'b00000000,
  parameter  [23:0]           pf1_reserved_3_addr                                                             = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_pcie_cap_link_control_link_status_reg_addr_byte2                            = 24'b010000000000000010000010,
  parameter                   pf0_pcie_cap_nego_link_width                                                    = "false",
  parameter  [3:0]            pld_tx_fifo_empty_threshold_2                                                   = 4'b1100,
  parameter  [7:0]            hrc_rstctl_timer_value_f                                                        = 8'b00001010,
  parameter  [23:0]           pf0_pcie_cap_link_capabilities_reg_addr_byte0                                   = 24'b000000000000000001111100,
  parameter  [15:0]           pf1_sriov_initial_vfs_ari_cs2                                                   = 16'b0000000001000000,
  parameter  [23:0]           pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte1                   = 24'b000000000000000000101101,
  parameter  [23:0]           pf1_type0_hdr_bar5_mask_reg_addr_byte0                                          = 24'b001000000001000000100100,
  parameter  [9:0]            pf0_exp_rom_bar_mask_reg_rsvdp_1                                                = 10'b0000000000,
  parameter  [6:0]            pf0_exp_rom_base_addr_reg_rsvdp_1                                               = 7'b0000000,
  parameter  [7:0]            pf0_dbi_reserved_21                                                             = 8'b00000000,
  parameter  [23:0]           pf1_reserved_18_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_pcie_cap_device_control_device_status_addr_byte1                            = 24'b000000000000000001111001,
  parameter                   pf0_pcie_cap_dll_active_rep_cap                                                 = "false",
  parameter  [7:0]            pf1_dbi_reserved_12                                                             = 8'b00000000,
  parameter  [23:0]           pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte3                   = 24'b000000000000000000101111,
  parameter  [23:0]           pf1_pcie_cap_link_control_link_status_reg_addr_byte2                            = 24'b010000000001000010000010,
  parameter  [23:0]           pf0_spcie_cap_lane_equalization_control67_reg_addr_byte2                        = 24'b000000000000000110100010,
  parameter  [23:0]           pf0_type0_hdr_bar2_mask_reg_addr_byte2                                          = 24'b001000000000000000011010,
  parameter  [23:0]           pf0_type0_hdr_device_id_vendor_id_reg_addr_byte3                                = 24'b000000000000000000000011,
  parameter                   pf0_vf_bar3_reg_rsvdp_0                                                         = "false",
  parameter  [23:0]           pf0_pcie_cap_link_control2_link_status2_reg_addr_byte0                          = 24'b010000000000000010100000,
  parameter  [23:0]           pf0_spcie_cap_spcie_cap_header_reg_addr_byte3                                   = 24'b000000000000000110001011,
  parameter  [23:0]           pf0_sn_cap_sn_base_addr_byte2                                                   = 24'b000000000000000101101010,
  parameter                   pf0_vf_bar4_reg_rsvdp_0                                                         = "false",
  parameter  [23:0]           pf0_pcie_cap_slot_capabilities_reg_addr_byte2                                   = 24'b000000000000000010000110,
  parameter  [4:0]            pf1_tph_req_cap_reg_rsvdp_3                                                     = 5'b00000,
  parameter                   pf0_shadow_pcie_cap_surprise_down_err_rep_cap                                   = "false",
  parameter  [23:0]           vf1_pf1_pcie_cap_vf_shadow_link_capabilities_reg_addr_byte1                     = 24'b000100000001000001111101,
  parameter  [7:0]            pf0_dbi_reserved_10                                                             = 8'b00000000,
  parameter  [10:0]           pf0_skp_int_val                                                                 = 11'b01010000000,
  parameter  [4:0]            pf0_tph_req_cap_reg_rsvdp_11                                                    = 5'b00000,
  parameter  [23:0]           pf0_reserved_54_addr                                                            = 24'b000000000000000000000000,
  parameter  [7:0]            pf0_dbi_reserved_3                                                              = 8'b00000000,
  parameter  [3:0]            pf0_sriov_cap_version                                                           = 4'b0001,
  parameter                   pf0_lane_equalization_control67_reg_rsvdp_31                                    = "false",
  parameter  [5:0]            pf0_gen3_eq_local_lf                                                            = 6'b010000,
  parameter                   pf0_sriov_vf_bar3_enabled                                                       = "enable",
  parameter  [23:0]           pf0_reserved_28_addr                                                            = 24'b000000000000000000000000,
  parameter                   pf0_reset_assert                                                                = "false",
  parameter  [23:0]           pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte2                = 24'b001000000000000010110010,
  parameter                   pf1_pcie_cap_surprise_down_err_rep_cap                                          = "false",
  parameter  [15:0]           hrc_chnl_txpll_master_cgb_rst_en                                                = 16'b0000000010000000,
  parameter  [2:0]            pf0_dsp_rx_preset_hint10                                                        = 3'b111,
  parameter                   pf1_tph_req_extended_tph_vfcomm_cs2                                             = "disable",
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte1                                     = 24'b001000000001000111110001,
  parameter                   pf1_sriov_vf_bar1_type                                                          = "pf1_sriov_vf_bar1_mem32",
  parameter                   pf0_pcie_cap_link_bw_not_cap                                                    = "false",
  parameter  [23:0]           pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte3                   = 24'b000000000001000000101111,
  parameter  [23:0]           pf1_ats_cap_ats_capabilities_ctrl_reg_addr_byte0                                = 24'b000000000001001010001000,
  parameter                   pf0_lane_equalization_control23_reg_rsvdp_31                                    = "false",
  parameter  [23:0]           pf0_sn_cap_ser_num_reg_dw_1_addr_byte2                                          = 24'b000000000000000101101110,
  parameter  [3:0]            pf0_dsp_tx_preset2                                                              = 4'b1111,
  parameter  [3:0]            pf0_dsp_tx_preset12                                                             = 4'b1111,
  parameter  [7:0]            pf1_dbi_reserved_15                                                             = 8'b00000000,
  parameter  [23:0]           pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte3                                    = 24'b000000000000000000101011,
  parameter  [7:0]            pf0_dbi_reserved_52                                                             = 8'b00000000,
  parameter                   pf1_vf_bar5_reg_rsvdp_0                                                         = "false",
  parameter  [23:0]           pf1_type0_hdr_bar2_reg_addr_byte0                                               = 24'b000000000001000000011000,
  parameter  [23:0]           pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte0                                = 24'b001000000000000000111000,
  parameter  [23:0]           pf0_vc_cap_vc_base_addr_byte2                                                   = 24'b000000000000000101001010,
  parameter  [7:0]            pf0_dbi_reserved_31                                                             = 8'b00000000,
  parameter                   pf0_link_disable                                                                = "false",
  parameter  [23:0]           pf0_sriov_cap_sriov_vf_offset_position_addr_byte1                               = 24'b000000000000000111001101,
  parameter                   pf0_pcie_cap_link_bw_man_int_en                                                 = "false",
  parameter  [3:0]            pf0_aer_cap_version                                                             = 4'b0010,
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte0                                     = 24'b001000000001000111101100,
  parameter  [23:0]           pf0_port_logic_ack_f_aspm_ctrl_off_addr_byte2                                   = 24'b000000000000011100001110,
  parameter                   pf0_vf_forward_user_vsec                                                        = "false",
  parameter  [3:0]            pf1_bar0_start                                                                  = 4'b0000,
  parameter  [3:0]            pf0_ari_cap_version                                                             = 4'b0001,
  parameter                   pf0_config_tx_comp_rx                                                           = "false",
  parameter  [23:0]           pf0_type0_hdr_bar4_reg_addr_byte0                                               = 24'b000000000000000000100000,
  parameter  [4:0]            cfg_vf_table_size                                                               = 5'b01010,
  parameter  [7:0]            pf0_dbi_reserved_17                                                             = 8'b00000000,
  parameter  [23:0]           pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte2                                   = 24'b001000000001000000110010,
  parameter  [2:0]            pf0_dsp_rx_preset_hint15                                                        = 3'b111,
  parameter  [23:0]           pf1_aer_cap_aer_ext_cap_hdr_off_addr_byte3                                      = 24'b000000000001000100000011,
  parameter  [2:0]            pf0_vc0_np_tlp_q_mode                                                           = 3'b001,
  parameter  [23:0]           pf1_sn_cap_ser_num_reg_dw_1_addr_byte3                                          = 24'b000000000001000101101111,
  parameter  [23:0]           pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte0                                     = 24'b001000000001000111100000,
  parameter  [23:0]           vf_reserved_0_addr                                                              = 24'b000000000000000000000000,
  parameter  [1:0]            pf0_queue_status_off_rsvdp_29                                                   = 2'b00,
  parameter  [6:0]            pf0_misc_control_1_off_rsvdp_1                                                  = 7'b0000000,
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte2                                     = 24'b001000000000000111110010,
  parameter  [23:0]           pf0_sriov_cap_vf_bar1_reg_addr_byte0                                            = 24'b000000000000000111100000,
  parameter  [6:0]            pf1_pci_type0_bar3_dummy_mask_7_1                                               = 7'b1111111,
  parameter  [7:0]            pf0_dbi_reserved_29                                                             = 8'b00000000,
  parameter  [23:0]           pf0_reserved_0_addr                                                             = 24'b000000000000000000000000,
  parameter  [2:0]            pf0_pm_spec_ver                                                                 = 3'b011,
  parameter                   pf0_shadow_pcie_cap_aspm_opt_compliance                                         = "false",
  parameter  [23:0]           pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte1                           = 24'b000000000001000010110001,
  parameter                   pf1_pcie_cap_link_bw_man_int_en                                                 = "false",
  parameter                   pf0_disable_fc_wd_timer                                                         = "enable",
  parameter  [3:0]            pf0_pipe_loopback_control_off_rsvdp_27                                          = 4'b0000,
  parameter  [23:0]           pf0_reserved_35_addr                                                            = 24'b000000000000000000000000,
  parameter  [23:0]           pf1_sriov_cap_sriov_vf_offset_position_addr_byte2                               = 24'b000000000001000111001110,
  parameter  [23:0]           pf0_reserved_49_addr                                                            = 24'b000000000000000000000000,
  parameter  [3:0]            pf1_sn_cap_version                                                              = 4'b0001,
  parameter  [4:0]            pf0_num_of_lanes                                                                = 5'b10000,
  parameter  [23:0]           pf0_pcie_cap_shadow_link_capabilities_reg_addr_byte1                            = 24'b001000000000000001111101,
  parameter                   pf0_bar1_prefetch                                                               = "false",
  parameter  [15:0]           pf0_sriov_initial_vfs_nonari                                                    = 16'b0000000001000000,
  parameter                   pf1_pcie_cap_common_clk_config                                                  = "false",
  parameter  [23:0]           pf1_pcie_cap_link_capabilities_reg_addr_byte3                                   = 24'b000000000001000001111111,
  parameter  [23:0]           pf1_pm_cap_cap_id_nxt_ptr_reg_addr_byte2                                        = 24'b000000000001000001000010,
  parameter  [11:0]           eco_flops                                                                       = 12'b000000000000,
  parameter                   pf1_pcie_cap_target_link_speed                                                  = "pf1_trgt_gen3",
  parameter  [23:0]           pf1_type0_hdr_pci_cap_ptr_reg_addr_byte0                                        = 24'b000000000001000000110100,
  parameter                   eqctrl_dir_mode_en                                                              = "false",
  parameter                   pf0_pcie_cap_extended_synch                                                     = "false",
  parameter                   pld_aux_gate_en                                                                 = "true",
  parameter  [2:0]            pf0_gen3_related_off_rsvdp_13                                                   = 3'b000,
  parameter  [23:0]           pf0_reserved_6_addr                                                             = 24'b000000000000000000000000,
  parameter  [23:0]           pf0_msix_cap_msix_table_offset_reg_addr_byte0                                   = 24'b000000000000000010110100,
  parameter  [23:0]           pf0_msix_cap_msix_pba_offset_reg_addr_byte2                                     = 24'b000000000000000010111010,
  parameter  [23:0]           pf0_reserved_42_addr                                                            = 24'b000000000000000000000000,
  parameter  [4:0]            pf0_tph_req_cap_reg_vfcomm_cs2_rsvdp_11_vfcomm_cs2                              = 5'b00000,
  parameter  [3:0]            pf0_device_capabilities_reg_rsvdp_16                                            = 4'b0000,
  parameter                   crs_override_value                                                              = "true",
  parameter  [11:0]           pf0_vc0_cpl_data_credit                                                         = 12'b000000000000,
  parameter  [23:0]           pf0_reserved_19_addr                                                            = 24'b000000000000000000000000,
  parameter  [9:0]            pf0_rp_exp_rom_bar_mask_reg_rp_rom_rsvdp_1                                      = 10'b0000000000,
  parameter  [23:0]           pf0_port_logic_gen3_eq_control_off_addr_byte2                                   = 24'b000000000000100010101010,
  parameter  [7:0]            cfg_vf_num_pf0                                                                  = 8'b01000000,
  parameter  [23:0]           vf1_pf0_ari_cap_vf_ari_base_addr_byte3                                          = 24'b000100000000000100000011,
  parameter                   pf1_pcie_cap_link_auto_bw_status                                                = "false",
  parameter  [23:0]           pf1_msix_cap_msix_pba_offset_reg_addr_byte3                                     = 24'b000000000001000010111011,
  parameter  [23:0]           pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte1                                    = 24'b000000000001000000101001,
  parameter                   pf1_ats_capabilities_ctrl_reg_rsvdp_7                                           = "false",
  parameter  [23:0]           pf0_ats_cap_ats_cap_hdr_reg_addr_byte3                                          = 24'b000000000000001010000111,
  parameter  [23:0]           pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte2                                     = 24'b001000000000000111101110,
  parameter  [23:0]           pf0_pcie_cap_device_capabilities_reg_addr_byte1                                 = 24'b000000000000000001110101,
  parameter  [7:0]            pf1_dbi_reserved_7                                                              = 8'b00000000,
  parameter  [23:0]           pf0_port_logic_filter_mask_2_off_addr_byte3                                     = 24'b000000000000011100100011,
  parameter  [3:0]            eqctrl_num_fom_cycles                                                           = 4'b0000,
  parameter  [23:0]           pf1_type0_hdr_bar3_reg_addr_byte0                                               = 24'b000000000001000000011100,
  parameter  [6:0]            pf1_sriov_vf_bar3_dummy_mask_7_1                                                = 7'b1111111,
  parameter  [3:0]            vf1_pf0_tph_req_cap_ver                                                         = 4'b0001,
  parameter  [23:0]           pf1_type0_hdr_bar1_mask_reg_addr_byte2                                          = 24'b001000000001000000010110,
  parameter  [7:0]            pf1_dbi_reserved_2                                                              = 8'b00000000,
  parameter                   pf0_lane_equalization_control89_reg_rsvdp_15                                    = "false",
  parameter  [23:0]           pf0_type0_hdr_bar0_mask_reg_addr_byte1                                          = 24'b001000000000000000010001,
  parameter                   pf1_pci_msix_function_mask_vfcomm_cs2                                           = "false",
  parameter                   silicon_rev                                                                     = "14nm5",
  parameter                   tx_avst_dsk_en                                                                  = "disable",
  parameter  [7:0]            vf_dbi_reserved_4                                                               = 8'b00000000,
  parameter  [7:0]            vf_dbi_reserved_5                                                               = 8'b00000000,
  parameter  [23:0]           vf_reserved_4_addr                                                              = 24'b000000000000000000000000,
  parameter  [23:0]           vf_reserved_5_addr                                                              = 24'b000000000000000000000000,
  parameter                   virtual_ep_native                                                               = "native",

  //Misc IPTCL Top Level Parameters
  parameter                   enable_test_out_hwtcl                                                           = 0,
  parameter                   hip_reconfig_hwtcl                                                              = 0,
  parameter                   xcvr_reconfig_hwtcl                                                             = 0

) (

  //Clk and reset
  input                                                     refclk,
  output                                                    coreclkout_hip,
  input                                                     npor,
  input                                                     pin_perst,
  output                                                    reset_status,
  output                                                    app_nreset_status,

  // PCIe Read DMA Avalon-MM master (RDDMA)
  output  [avmm_addr_width_hwtcl-1:0]                       rd_dma_address_o,
  output  [31:0]                                            rd_dma_byte_enable_o,
  output                                                    rd_dma_write_o,
  output  [255:0]                                           rd_dma_write_data_o,
  input                                                     rd_dma_wait_request_i,
  output  [4:0]                                             rd_dma_burst_count_o,

  // PCIe Read DMA Decriptor Table Slave
  input                                                     rd_dts_chip_select_i,
  input   [7:0]                                             rd_dts_address_i, // Byte address.
  input                                                     rd_dts_write_i,
  input   [255:0]                                           rd_dts_write_data_i,
  output                                                    rd_dts_wait_request_o,
  input   [4:0]                                             rd_dts_burst_count_i,

  // PCIe Read DMA Decriptor Status Update & MSI Master
  output  [63:0]                                            rd_dcm_address_o,
  output  [3:0]                                             rd_dcm_byte_enable_o,
  output                                                    rd_dcm_read_o,
  input   [31:0]                                            rd_dcm_read_data_i,
  output                                                    rd_dcm_write_o,
  output  [31:0]                                            rd_dcm_writedata_o,
  input                                                     rd_dcm_wait_request_i,
  input                                                     rd_dcm_read_data_valid_i,


  // PCIe Read DMA control Avalon-ST sink (RDDMA_RX)
  input   [159:0]                                           rd_ast_rx_data_i,
  output                                                    rd_ast_rx_ready_o,
  input                                                     rd_ast_rx_valid_i,

  // PCIe Read DMA status Avalon-ST source (RDDMA_TX)
  output  [31:0]                                            rd_ast_tx_data_o,
  output                                                    rd_ast_tx_valid_o,

  // PCIe Write DMA Avalon-MM master (WRDMA)
  output  [avmm_addr_width_hwtcl-1:0]                       wr_dma_address_o,
  output  [31:0]                                            wr_dma_byte_enable_o,
  output                                                    wr_dma_read_o,
  input   [255:0]                                           wr_dma_read_data_i,
  input                                                     wr_dma_wait_request_i,
  input                                                     wr_dma_read_data_valid_i,
  output  [4:0]                                             wr_dma_burst_count_o,

  // PCIe Write DMA Decriptor Table Slave
  input                                                     wr_dts_chip_select_i,
  input   [7:0]                                             wr_dts_address_i, // Byte address.
  input                                                     wr_dts_write_i,
  input   [255:0]                                           wr_dts_write_data_i,
  output                                                    wr_dts_wait_request_o,
  input   [4:0]                                             wr_dts_burst_count_i,

  // PCIe Write DMA Decriptor Status Update & MSI Master
  output  [63:0]                                            wr_dcm_address_o,
  output  [3:0]                                             wr_dcm_byte_enable_o,
  output                                                    wr_dcm_read_o,
  input   [31:0]                                            wr_dcm_read_data_i,
  output                                                    wr_dcm_write_o,
  output  [31:0]                                            wr_dcm_writedata_o,
  input                                                     wr_dcm_wait_request_i,
  input                                                     wr_dcm_read_data_valid_i,

  // PCIe Write DMA control Avalon-ST sink (WRDMA_RX)
  input   [159:0]                                           wr_ast_rx_data_i,
  output                                                    wr_ast_rx_ready_o,
  input                                                     wr_ast_rx_valid_i,

  // PCIe Write DMA status Avalon-ST source (WRDMA_TX)
  output   [31:0]                                           wr_ast_tx_data_o,
  output                                                    wr_ast_tx_valid_o,

  // High performance bursting Avalon-MM slave (HPTXS)
  input   [hptxs_address_width_hwtcl-1:0]                   hptxs_address_i, // Byte address. Bits [4:0] are assumed to be zero.
  input   [31:0]                                            hptxs_byteenable_i,
  input                                                     hptxs_read_i,
  output  [255:0]                                           hptxs_readdata_o,
  input                                                     hptxs_write_i,
  input   [255:0]                                           hptxs_writedata_i,
  output                                                    hptxs_waitrequest_o,
  output                                                    hptxs_readdatavalid_o,
  input   [4:0]                                             hptxs_burstcount_i,

  // 32-bit wide, non-bursting Avalon-MM slave with individual byte enable control (TXS)
  input                                                     txs_chipselect_i,
  input   [txs_address_width_hwtcl-1:0]                     txs_address_i, // Byte address. Bits [1:0] are assumed to be zero.
  input   [3:0]                                             txs_byteenable_i,
  input                                                     txs_read_i,
  output  [31:0]                                            txs_readdata_o,
  input                                                     txs_write_i,
  input   [31:0]                                            txs_writedata_i,
  output                                                    txs_waitrequest_o,
  output                                                    txs_readdatavalid_o,


  // BAR 0 Avalon-MM master with individual byte enabling and interrupt support (RXM).
  output  [avmm_addr_width_hwtcl-1:0]                       rxm_bar0_address_o, // Byte address.
  output  [((pf0_bar0_enable_rxm_burst_hwtcl==1)?31:3):0]   rxm_bar0_byteenable_o,
  output                                                    rxm_bar0_read_o,
  input   [((pf0_bar0_enable_rxm_burst_hwtcl==1)?255:31):0] rxm_bar0_readdata_i,
  output                                                    rxm_bar0_write_o,
  output  [((pf0_bar0_enable_rxm_burst_hwtcl==1)?255:31):0] rxm_bar0_writedata_o,
  input                                                     rxm_bar0_waitrequest_i,
  output  [4:0]                                             rxm_bar0_burstcount_o,
  input                                                     rxm_bar0_readdatavalid_i,

  // BAR 1 Avalon-MM master with individual byte enabling and interrupt support (RXM).
  output  [avmm_addr_width_hwtcl-1:0]                       rxm_bar1_address_o, // Byte address.
  output  [((pf0_bar1_enable_rxm_burst_hwtcl==1)?31:3):0]   rxm_bar1_byteenable_o,
  output                                                    rxm_bar1_read_o,
  input   [((pf0_bar1_enable_rxm_burst_hwtcl==1)?255:31):0] rxm_bar1_readdata_i,
  output                                                    rxm_bar1_write_o,
  output  [((pf0_bar1_enable_rxm_burst_hwtcl==1)?255:31):0] rxm_bar1_writedata_o,
  input                                                     rxm_bar1_waitrequest_i,
  output  [4:0]                                             rxm_bar1_burstcount_o,
  input                                                     rxm_bar1_readdatavalid_i,

  // BAR 2 Avalon-MM master with individual byte enabling and interrupt support (RXM).
  output  [avmm_addr_width_hwtcl-1:0]                       rxm_bar2_address_o, // Byte address.
  output  [((pf0_bar2_enable_rxm_burst_hwtcl==1)?31:3):0]   rxm_bar2_byteenable_o,
  output                                                    rxm_bar2_read_o,
  input   [((pf0_bar2_enable_rxm_burst_hwtcl==1)?255:31):0] rxm_bar2_readdata_i,
  output                                                    rxm_bar2_write_o,
  output  [((pf0_bar2_enable_rxm_burst_hwtcl==1)?255:31):0] rxm_bar2_writedata_o,
  input                                                     rxm_bar2_waitrequest_i,
  output  [4:0]                                             rxm_bar2_burstcount_o,
  input                                                     rxm_bar2_readdatavalid_i,

  // BAR 3 Avalon-MM master with individual byte enabling and interrupt support (RXM).
  output  [avmm_addr_width_hwtcl-1:0]                       rxm_bar3_address_o, // Byte address.
  output  [((pf0_bar3_enable_rxm_burst_hwtcl==1)?31:3):0]   rxm_bar3_byteenable_o,
  output                                                    rxm_bar3_read_o,
  input   [((pf0_bar3_enable_rxm_burst_hwtcl==1)?255:31):0] rxm_bar3_readdata_i,
  output                                                    rxm_bar3_write_o,
  output  [((pf0_bar3_enable_rxm_burst_hwtcl==1)?255:31):0] rxm_bar3_writedata_o,
  input                                                     rxm_bar3_waitrequest_i,
  output  [4:0]                                             rxm_bar3_burstcount_o,
  input                                                     rxm_bar3_readdatavalid_i,

  // BAR 4 Avalon-MM master with individual byte enabling and interrupt support (RXM).
  output  [avmm_addr_width_hwtcl-1:0]                       rxm_bar4_address_o, // Byte address.
  output  [((pf0_bar4_enable_rxm_burst_hwtcl==1)?31:3):0]   rxm_bar4_byteenable_o,
  output                                                    rxm_bar4_read_o,
  input   [((pf0_bar4_enable_rxm_burst_hwtcl==1)?255:31):0] rxm_bar4_readdata_i,
  output                                                    rxm_bar4_write_o,
  output  [((pf0_bar4_enable_rxm_burst_hwtcl==1)?255:31):0] rxm_bar4_writedata_o,
  input                                                     rxm_bar4_waitrequest_i,
  output  [4:0]                                             rxm_bar4_burstcount_o,
  input                                                     rxm_bar4_readdatavalid_i,

  // BAR 5 Avalon-MM master with individual byte enabling and interrupt support (RXM).
  output  [avmm_addr_width_hwtcl-1:0]                       rxm_bar5_address_o, // Byte address.
  output  [((pf0_bar5_enable_rxm_burst_hwtcl==1)?31:3):0]   rxm_bar5_byteenable_o,
  output                                                    rxm_bar5_read_o,
  input   [((pf0_bar5_enable_rxm_burst_hwtcl==1)?255:31):0] rxm_bar5_readdata_i,
  output                                                    rxm_bar5_write_o,
  output  [((pf0_bar5_enable_rxm_burst_hwtcl==1)?255:31):0] rxm_bar5_writedata_o,
  input                                                     rxm_bar5_waitrequest_i,
  output  [4:0]                                             rxm_bar5_burstcount_o,
  input                                                     rxm_bar5_readdatavalid_i,

  // Interrupt inputs
  input   [15:0]                                            rxm_irq_i,     // Avalon->PCIe interrupt generation through CRA


  // Avalon-MM slave for Control and Status registers access (CRA)
  input                                                     cra_chipselect_i, // for backward compatibility. tie 1 normally
  input   [14:0]                                            cra_address_i, // Hardcoded for now to maximum width, assuming 512 address mapping windows for TXS and HPTXS.
  input   [3:0]                                             cra_byteenable_i, // dummy for backward compatibility in EB release. will be implemented later
  input                                                     cra_read_i,
  output  [31:0]                                            cra_readdata_o,
  input                                                     cra_write_i,
  input   [31:0]                                            cra_writedata_i,
  output                                                    cra_waitrequest_o,
  output                                                    cra_readdatavalid_o,

  output                                                    cra_irq_o,

  //AVMM DPRIO Interface
  input                                                     hip_reconfig_rst_n,
  output                                                    hip_reconfig_waitrequest,
  input                                                     hip_reconfig_read,
  input      [20:0]                                         hip_reconfig_address,
  input                                                     hip_reconfig_write,
  input      [7:0]                                          hip_reconfig_writedata,
  input                                                     hip_reconfig_clk,
  output                                                    hip_reconfig_readdatavalid,
  output     [7:0]                                          hip_reconfig_readdata,


  //MSI and legacy Interrupt
  input                                                     intx_req_i,    // Connected to HIP directly when enable_advanced_interrupt_hwtcl is enabled
  output     [7:0]                                          int_status, // int_status_pf0 10
  output     [2:0]                                          int_status_common,
  output     [81:0]                                         msi_intfc_o,
  output     [15:0]                                         msi_control_o,
  output     [15:0]                                         msix_intfc_o,

  //Error
  output                                                    derr_cor_ext_rpl,   // retry_corr_ecc_err
  output                                                    derr_rpl,           // retry_unc_ecc_err
  output                                                    derr_cor_ext_rcv,   // rxbuff_corr_ecc_err
  output                                                    derr_uncor_ext_rcv, // rxbuff_unc_ecc_err

  output                                                    rx_par_err,
  output                                                    tx_par_err,


  //Status & Link Training Interface
  output                                                    link_up,
  output     [5:0]                                          ltssmstate,
  output     [1:0]                                          currentspeed,
  output     [4:0]                                          lane_act,

  //CEB Interface
  output                                                    ceb_req,
  input                                                     ceb_ack,
  output     [31:0]                                         ceb_addr,
  input      [31:0]                                         ceb_din,
  output     [31:0]                                         ceb_dout,
  output     [3:0]                                          ceb_wr,


  // PIPE Interface Signals
  input                                                     simu_mode_pipe,
  input                                                     sim_pipe_pclk_in,
  output     [1:0]                                          sim_pipe_rate,
  output     [5:0]                                          sim_ltssmstate,

  //OUTPUT PIPE Interface Signals
  output     [31:0]                                         txdata0,
  output     [31:0]                                         txdata1,
  output     [31:0]                                         txdata2,
  output     [31:0]                                         txdata3,
  output     [31:0]                                         txdata4,
  output     [31:0]                                         txdata5,
  output     [31:0]                                         txdata6,
  output     [31:0]                                         txdata7,
  output     [31:0]                                         txdata8,
  output     [31:0]                                         txdata9,
  output     [31:0]                                         txdata10,
  output     [31:0]                                         txdata11,
  output     [31:0]                                         txdata12,
  output     [31:0]                                         txdata13,
  output     [31:0]                                         txdata14,
  output     [31:0]                                         txdata15,

  output     [3:0]                                          txdatak0,
  output     [3:0]                                          txdatak1,
  output     [3:0]                                          txdatak2,
  output     [3:0]                                          txdatak3,
  output     [3:0]                                          txdatak4,
  output     [3:0]                                          txdatak5,
  output     [3:0]                                          txdatak6,
  output     [3:0]                                          txdatak7,
  output     [3:0]                                          txdatak8,
  output     [3:0]                                          txdatak9,
  output     [3:0]                                          txdatak10,
  output     [3:0]                                          txdatak11,
  output     [3:0]                                          txdatak12,
  output     [3:0]                                          txdatak13,
  output     [3:0]                                          txdatak14,
  output     [3:0]                                          txdatak15,

  output                                                    txcompl0,
  output                                                    txcompl1,
  output                                                    txcompl2,
  output                                                    txcompl3,
  output                                                    txcompl4,
  output                                                    txcompl5,
  output                                                    txcompl6,
  output                                                    txcompl7,
  output                                                    txcompl8,
  output                                                    txcompl9,
  output                                                    txcompl10,
  output                                                    txcompl11,
  output                                                    txcompl12,
  output                                                    txcompl13,
  output                                                    txcompl14,
  output                                                    txcompl15,

  output                                                    txelecidle0,
  output                                                    txelecidle1,
  output                                                    txelecidle2,
  output                                                    txelecidle3,
  output                                                    txelecidle4,
  output                                                    txelecidle5,
  output                                                    txelecidle6,
  output                                                    txelecidle7,
  output                                                    txelecidle8,
  output                                                    txelecidle9,
  output                                                    txelecidle10,
  output                                                    txelecidle11,
  output                                                    txelecidle12,
  output                                                    txelecidle13,
  output                                                    txelecidle14,
  output                                                    txelecidle15,

  output                                                    txdetectrx0,
  output                                                    txdetectrx1,
  output                                                    txdetectrx2,
  output                                                    txdetectrx3,
  output                                                    txdetectrx4,
  output                                                    txdetectrx5,
  output                                                    txdetectrx6,
  output                                                    txdetectrx7,
  output                                                    txdetectrx8,
  output                                                    txdetectrx9,
  output                                                    txdetectrx10,
  output                                                    txdetectrx11,
  output                                                    txdetectrx12,
  output                                                    txdetectrx13,
  output                                                    txdetectrx14,
  output                                                    txdetectrx15,

  output     [1:0]                                          powerdown0,
  output     [1:0]                                          powerdown1,
  output     [1:0]                                          powerdown2,
  output     [1:0]                                          powerdown3,
  output     [1:0]                                          powerdown4,
  output     [1:0]                                          powerdown5,
  output     [1:0]                                          powerdown6,
  output     [1:0]                                          powerdown7,
  output     [1:0]                                          powerdown8,
  output     [1:0]                                          powerdown9,
  output     [1:0]                                          powerdown10,
  output     [1:0]                                          powerdown11,
  output     [1:0]                                          powerdown12,
  output     [1:0]                                          powerdown13,
  output     [1:0]                                          powerdown14,
  output     [1:0]                                          powerdown15,

  output     [2:0]                                          txmargin0,
  output     [2:0]                                          txmargin1,
  output     [2:0]                                          txmargin2,
  output     [2:0]                                          txmargin3,
  output     [2:0]                                          txmargin4,
  output     [2:0]                                          txmargin5,
  output     [2:0]                                          txmargin6,
  output     [2:0]                                          txmargin7,
  output     [2:0]                                          txmargin8,
  output     [2:0]                                          txmargin9,
  output     [2:0]                                          txmargin10,
  output     [2:0]                                          txmargin11,
  output     [2:0]                                          txmargin12,
  output     [2:0]                                          txmargin13,
  output     [2:0]                                          txmargin14,
  output     [2:0]                                          txmargin15,

  output                                                    txdeemph0,
  output                                                    txdeemph1,
  output                                                    txdeemph2,
  output                                                    txdeemph3,
  output                                                    txdeemph4,
  output                                                    txdeemph5,
  output                                                    txdeemph6,
  output                                                    txdeemph7,
  output                                                    txdeemph8,
  output                                                    txdeemph9,
  output                                                    txdeemph10,
  output                                                    txdeemph11,
  output                                                    txdeemph12,
  output                                                    txdeemph13,
  output                                                    txdeemph14,
  output                                                    txdeemph15,

  output                                                    txswing0,
  output                                                    txswing1,
  output                                                    txswing2,
  output                                                    txswing3,
  output                                                    txswing4,
  output                                                    txswing5,
  output                                                    txswing6,
  output                                                    txswing7,
  output                                                    txswing8,
  output                                                    txswing9,
  output                                                    txswing10,
  output                                                    txswing11,
  output                                                    txswing12,
  output                                                    txswing13,
  output                                                    txswing14,
  output                                                    txswing15,

  output     [1:0]                                          txsynchd0,
  output     [1:0]                                          txsynchd1,
  output     [1:0]                                          txsynchd2,
  output     [1:0]                                          txsynchd3,
  output     [1:0]                                          txsynchd4,
  output     [1:0]                                          txsynchd5,
  output     [1:0]                                          txsynchd6,
  output     [1:0]                                          txsynchd7,
  output     [1:0]                                          txsynchd8,
  output     [1:0]                                          txsynchd9,
  output     [1:0]                                          txsynchd10,
  output     [1:0]                                          txsynchd11,
  output     [1:0]                                          txsynchd12,
  output     [1:0]                                          txsynchd13,
  output     [1:0]                                          txsynchd14,
  output     [1:0]                                          txsynchd15,

  output                                                    txblkst0,
  output                                                    txblkst1,
  output                                                    txblkst2,
  output                                                    txblkst3,
  output                                                    txblkst4,
  output                                                    txblkst5,
  output                                                    txblkst6,
  output                                                    txblkst7,
  output                                                    txblkst8,
  output                                                    txblkst9,
  output                                                    txblkst10,
  output                                                    txblkst11,
  output                                                    txblkst12,
  output                                                    txblkst13,
  output                                                    txblkst14,
  output                                                    txblkst15,

  output                                                    txdataskip0,
  output                                                    txdataskip1,
  output                                                    txdataskip2,
  output                                                    txdataskip3,
  output                                                    txdataskip4,
  output                                                    txdataskip5,
  output                                                    txdataskip6,
  output                                                    txdataskip7,
  output                                                    txdataskip8,
  output                                                    txdataskip9,
  output                                                    txdataskip10,
  output                                                    txdataskip11,
  output                                                    txdataskip12,
  output                                                    txdataskip13,
  output                                                    txdataskip14,
  output                                                    txdataskip15,

  output     [1:0]                                          rate0,
  output     [1:0]                                          rate1,
  output     [1:0]                                          rate2,
  output     [1:0]                                          rate3,
  output     [1:0]                                          rate4,
  output     [1:0]                                          rate5,
  output     [1:0]                                          rate6,
  output     [1:0]                                          rate7,
  output     [1:0]                                          rate8,
  output     [1:0]                                          rate9,
  output     [1:0]                                          rate10,
  output     [1:0]                                          rate11,
  output     [1:0]                                          rate12,
  output     [1:0]                                          rate13,
  output     [1:0]                                          rate14,
  output     [1:0]                                          rate15,

  output                                                    rxpolarity0,
  output                                                    rxpolarity1,
  output                                                    rxpolarity2,
  output                                                    rxpolarity3,
  output                                                    rxpolarity4,
  output                                                    rxpolarity5,
  output                                                    rxpolarity6,
  output                                                    rxpolarity7,
  output                                                    rxpolarity8,
  output                                                    rxpolarity9,
  output                                                    rxpolarity10,
  output                                                    rxpolarity11,
  output                                                    rxpolarity12,
  output                                                    rxpolarity13,
  output                                                    rxpolarity14,
  output                                                    rxpolarity15,

  output     [2:0]                                          currentrxpreset0,
  output     [2:0]                                          currentrxpreset1,
  output     [2:0]                                          currentrxpreset2,
  output     [2:0]                                          currentrxpreset3,
  output     [2:0]                                          currentrxpreset4,
  output     [2:0]                                          currentrxpreset5,
  output     [2:0]                                          currentrxpreset6,
  output     [2:0]                                          currentrxpreset7,
  output     [2:0]                                          currentrxpreset8,
  output     [2:0]                                          currentrxpreset9,
  output     [2:0]                                          currentrxpreset10,
  output     [2:0]                                          currentrxpreset11,
  output     [2:0]                                          currentrxpreset12,
  output     [2:0]                                          currentrxpreset13,
  output     [2:0]                                          currentrxpreset14,
  output     [2:0]                                          currentrxpreset15,

  output     [17:0]                                         currentcoeff0,
  output     [17:0]                                         currentcoeff1,
  output     [17:0]                                         currentcoeff2,
  output     [17:0]                                         currentcoeff3,
  output     [17:0]                                         currentcoeff4,
  output     [17:0]                                         currentcoeff5,
  output     [17:0]                                         currentcoeff6,
  output     [17:0]                                         currentcoeff7,
  output     [17:0]                                         currentcoeff8,
  output     [17:0]                                         currentcoeff9,
  output     [17:0]                                         currentcoeff10,
  output     [17:0]                                         currentcoeff11,
  output     [17:0]                                         currentcoeff12,
  output     [17:0]                                         currentcoeff13,
  output     [17:0]                                         currentcoeff14,
  output     [17:0]                                         currentcoeff15,

  output                                                    rxeqeval0,
  output                                                    rxeqeval1,
  output                                                    rxeqeval2,
  output                                                    rxeqeval3,
  output                                                    rxeqeval4,
  output                                                    rxeqeval5,
  output                                                    rxeqeval6,
  output                                                    rxeqeval7,
  output                                                    rxeqeval8,
  output                                                    rxeqeval9,
  output                                                    rxeqeval10,
  output                                                    rxeqeval11,
  output                                                    rxeqeval12,
  output                                                    rxeqeval13,
  output                                                    rxeqeval14,
  output                                                    rxeqeval15,

  output                                                    rxeqinprogress0,
  output                                                    rxeqinprogress1,
  output                                                    rxeqinprogress2,
  output                                                    rxeqinprogress3,
  output                                                    rxeqinprogress4,
  output                                                    rxeqinprogress5,
  output                                                    rxeqinprogress6,
  output                                                    rxeqinprogress7,
  output                                                    rxeqinprogress8,
  output                                                    rxeqinprogress9,
  output                                                    rxeqinprogress10,
  output                                                    rxeqinprogress11,
  output                                                    rxeqinprogress12,
  output                                                    rxeqinprogress13,
  output                                                    rxeqinprogress14,
  output                                                    rxeqinprogress15,

  output                                                    invalidreq0,
  output                                                    invalidreq1,
  output                                                    invalidreq2,
  output                                                    invalidreq3,
  output                                                    invalidreq4,
  output                                                    invalidreq5,
  output                                                    invalidreq6,
  output                                                    invalidreq7,
  output                                                    invalidreq8,
  output                                                    invalidreq9,
  output                                                    invalidreq10,
  output                                                    invalidreq11,
  output                                                    invalidreq12,
  output                                                    invalidreq13,
  output                                                    invalidreq14,
  output                                                    invalidreq15,

  //INPUT PIPE Interfae Signals
  input      [31:0]                                         rxdata0,
  input      [31:0]                                         rxdata1,
  input      [31:0]                                         rxdata2,
  input      [31:0]                                         rxdata3,
  input      [31:0]                                         rxdata4,
  input      [31:0]                                         rxdata5,
  input      [31:0]                                         rxdata6,
  input      [31:0]                                         rxdata7,
  input      [31:0]                                         rxdata8,
  input      [31:0]                                         rxdata9,
  input      [31:0]                                         rxdata10,
  input      [31:0]                                         rxdata11,
  input      [31:0]                                         rxdata12,
  input      [31:0]                                         rxdata13,
  input      [31:0]                                         rxdata14,
  input      [31:0]                                         rxdata15,

  input      [3:0]                                          rxdatak0,
  input      [3:0]                                          rxdatak1,
  input      [3:0]                                          rxdatak2,
  input      [3:0]                                          rxdatak3,
  input      [3:0]                                          rxdatak4,
  input      [3:0]                                          rxdatak5,
  input      [3:0]                                          rxdatak6,
  input      [3:0]                                          rxdatak7,
  input      [3:0]                                          rxdatak8,
  input      [3:0]                                          rxdatak9,
  input      [3:0]                                          rxdatak10,
  input      [3:0]                                          rxdatak11,
  input      [3:0]                                          rxdatak12,
  input      [3:0]                                          rxdatak13,
  input      [3:0]                                          rxdatak14,
  input      [3:0]                                          rxdatak15,

  input                                                     phystatus0,
  input                                                     phystatus1,
  input                                                     phystatus2,
  input                                                     phystatus3,
  input                                                     phystatus4,
  input                                                     phystatus5,
  input                                                     phystatus6,
  input                                                     phystatus7,
  input                                                     phystatus8,
  input                                                     phystatus9,
  input                                                     phystatus10,
  input                                                     phystatus11,
  input                                                     phystatus12,
  input                                                     phystatus13,
  input                                                     phystatus14,
  input                                                     phystatus15,

  input                                                     rxvalid0,
  input                                                     rxvalid1,
  input                                                     rxvalid2,
  input                                                     rxvalid3,
  input                                                     rxvalid4,
  input                                                     rxvalid5,
  input                                                     rxvalid6,
  input                                                     rxvalid7,
  input                                                     rxvalid8,
  input                                                     rxvalid9,
  input                                                     rxvalid10,
  input                                                     rxvalid11,
  input                                                     rxvalid12,
  input                                                     rxvalid13,
  input                                                     rxvalid14,
  input                                                     rxvalid15,

  input      [2:0]                                          rxstatus0,
  input      [2:0]                                          rxstatus1,
  input      [2:0]                                          rxstatus2,
  input      [2:0]                                          rxstatus3,
  input      [2:0]                                          rxstatus4,
  input      [2:0]                                          rxstatus5,
  input      [2:0]                                          rxstatus6,
  input      [2:0]                                          rxstatus7,
  input      [2:0]                                          rxstatus8,
  input      [2:0]                                          rxstatus9,
  input      [2:0]                                          rxstatus10,
  input      [2:0]                                          rxstatus11,
  input      [2:0]                                          rxstatus12,
  input      [2:0]                                          rxstatus13,
  input      [2:0]                                          rxstatus14,
  input      [2:0]                                          rxstatus15,

  input                                                     rxelecidle0,
  input                                                     rxelecidle1,
  input                                                     rxelecidle2,
  input                                                     rxelecidle3,
  input                                                     rxelecidle4,
  input                                                     rxelecidle5,
  input                                                     rxelecidle6,
  input                                                     rxelecidle7,
  input                                                     rxelecidle8,
  input                                                     rxelecidle9,
  input                                                     rxelecidle10,
  input                                                     rxelecidle11,
  input                                                     rxelecidle12,
  input                                                     rxelecidle13,
  input                                                     rxelecidle14,
  input                                                     rxelecidle15,

  input      [1:0]                                          rxsynchd0,
  input      [1:0]                                          rxsynchd1,
  input      [1:0]                                          rxsynchd2,
  input      [1:0]                                          rxsynchd3,
  input      [1:0]                                          rxsynchd4,
  input      [1:0]                                          rxsynchd5,
  input      [1:0]                                          rxsynchd6,
  input      [1:0]                                          rxsynchd7,
  input      [1:0]                                          rxsynchd8,
  input      [1:0]                                          rxsynchd9,
  input      [1:0]                                          rxsynchd10,
  input      [1:0]                                          rxsynchd11,
  input      [1:0]                                          rxsynchd12,
  input      [1:0]                                          rxsynchd13,
  input      [1:0]                                          rxsynchd14,
  input      [1:0]                                          rxsynchd15,

  input                                                     rxblkst0,
  input                                                     rxblkst1,
  input                                                     rxblkst2,
  input                                                     rxblkst3,
  input                                                     rxblkst4,
  input                                                     rxblkst5,
  input                                                     rxblkst6,
  input                                                     rxblkst7,
  input                                                     rxblkst8,
  input                                                     rxblkst9,
  input                                                     rxblkst10,
  input                                                     rxblkst11,
  input                                                     rxblkst12,
  input                                                     rxblkst13,
  input                                                     rxblkst14,
  input                                                     rxblkst15,

  input                                                     rxdataskip0,
  input                                                     rxdataskip1,
  input                                                     rxdataskip2,
  input                                                     rxdataskip3,
  input                                                     rxdataskip4,
  input                                                     rxdataskip5,
  input                                                     rxdataskip6,
  input                                                     rxdataskip7,
  input                                                     rxdataskip8,
  input                                                     rxdataskip9,
  input                                                     rxdataskip10,
  input                                                     rxdataskip11,
  input                                                     rxdataskip12,
  input                                                     rxdataskip13,
  input                                                     rxdataskip14,
  input                                                     rxdataskip15,

  input      [5:0]                                          dirfeedback0,
  input      [5:0]                                          dirfeedback1,
  input      [5:0]                                          dirfeedback2,
  input      [5:0]                                          dirfeedback3,
  input      [5:0]                                          dirfeedback4,
  input      [5:0]                                          dirfeedback5,
  input      [5:0]                                          dirfeedback6,
  input      [5:0]                                          dirfeedback7,
  input      [5:0]                                          dirfeedback8,
  input      [5:0]                                          dirfeedback9,
  input      [5:0]                                          dirfeedback10,
  input      [5:0]                                          dirfeedback11,
  input      [5:0]                                          dirfeedback12,
  input      [5:0]                                          dirfeedback13,
  input      [5:0]                                          dirfeedback14,
  input      [5:0]                                          dirfeedback15,


  //Serial Interface Sgnals
  output                                                    tx_out0,
  output                                                    tx_out1,
  output                                                    tx_out2,
  output                                                    tx_out3,
  output                                                    tx_out4,
  output                                                    tx_out5,
  output                                                    tx_out6,
  output                                                    tx_out7,
  output                                                    tx_out8,
  output                                                    tx_out9,
  output                                                    tx_out10,
  output                                                    tx_out11,
  output                                                    tx_out12,
  output                                                    tx_out13,
  output                                                    tx_out14,
  output                                                    tx_out15,

  input                                                     rx_in0,
  input                                                     rx_in1,
  input                                                     rx_in2,
  input                                                     rx_in3,
  input                                                     rx_in4,
  input                                                     rx_in5,
  input                                                     rx_in6,
  input                                                     rx_in7,
  input                                                     rx_in8,
  input                                                     rx_in9,
  input                                                     rx_in10,
  input                                                     rx_in11,
  input                                                     rx_in12,
  input                                                     rx_in13,
  input                                                     rx_in14,
  input                                                     rx_in15,


  //Test Signals
  input      [66:0]                                         test_in,
  output     [6:0]                                          aux_test_out,
  output     [255:0]                                        test_out,

  //Used only in BFM PIPE Simulations
  input                                                     sim_pipe_mask_tx_pll_lock,

  //Reconfig Interface
  input                                                     xcvr_reconfig_clk,
  input                                                     xcvr_reconfig_reset,
  input                                                     xcvr_reconfig_write,
  input                                                     xcvr_reconfig_read,
  input      [13:0]                                         xcvr_reconfig_address,
  input      [31:0]                                         xcvr_reconfig_writedata,
  output     [31:0]                                         xcvr_reconfig_readdata,
  output                                                    xcvr_reconfig_waitrequest,

  //FPLL Reconfig Interface
  input                                                     reconfig_pll0_clk,
  input                                                     reconfig_pll0_reset,
  input                                                     reconfig_pll0_write,
  input                                                     reconfig_pll0_read,
  input      [10:0]                                         reconfig_pll0_address,
  input      [31:0]                                         reconfig_pll0_writedata,
  output     [31:0]                                         reconfig_pll0_readdata,
  output                                                    reconfig_pll0_waitrequest,
  //LC PLL Reconfig Interface
  input                                                     reconfig_pll1_clk,
  input                                                     reconfig_pll1_reset,
  input                                                     reconfig_pll1_write,
  input                                                     reconfig_pll1_read,
  input      [10:0]                                         reconfig_pll1_address,
  input      [31:0]                                         reconfig_pll1_writedata,
  output     [31:0]                                         reconfig_pll1_readdata,
  output                                                    reconfig_pll1_waitrequest
);

  wire                                                      reset_status_hip;
  wire       [10:0]                                         core_rst_n;

  wire                                                      app_int_sts;

  //AVST Signals
  //RX Data Path
  wire                                                      rx_st_ready;
  wire                                                      rx_st_sop;
  wire                                                      rx_st_eop;
  wire       [255:0]                                        rx_st_data;
  wire       [31:0]                                         rx_st_parity;
  wire                                                      rx_st_valid;
  wire       [2:0]                                          rx_st_bar_range;
  wire       [2:0]                                          rx_st_empty;

  //TX Data Path
  wire                                                      tx_st_sop;
  wire                                                      tx_st_eop;
  wire       [255:0]                                        tx_st_data;
  wire       [31:0]                                         tx_st_parity;
  wire                                                      tx_st_valid;
  wire                                                      tx_st_err;
  wire                                                      tx_st_ready;

  //TX Credit Interface
  wire       [1:0]                                          tx_cdts_type;
  wire                                                      tx_data_cdts_consumed;
  wire                                                      tx_hdr_cdts_consumed;
  wire       [1:0]                                          tx_cdts_data_value;
  wire       [11:0]                                         tx_pd_cdts;
  wire       [11:0]                                         tx_npd_cdts;
  wire       [11:0]                                         tx_cpld_cdts;
  wire       [7:0]                                          tx_ph_cdts;
  wire       [7:0]                                          tx_nph_cdts;
  wire       [7:0]                                          tx_cplh_cdts;

  //Error & cfg_tl Interface
  //cfg_tl
  wire       [1:0]                                          tl_cfg_func;
  wire       [4:0]                                          tl_cfg_add;
  wire       [31:0]                                         tl_cfg_ctl;

  wire                                                      serdes_pll_locked;
  wire                                                      pld_clk_inuse;

  //rx_buffer_limit_signals
  wire       [6:0]                                          rx_np_buffer_limit;
  wire       [6:0]                                          rx_p_buffer_limit;
  wire       [9:0]                                          rx_cpl_buffer_limit;

  assign                      reset_status = ~core_rst_n[10];
  assign                      app_nreset_status = core_rst_n[10];

  // Extended Tag is always enabled for AVMM
  localparam local_pf0_pcie_cap_ext_tag_supp = "pf0_supported" ;

   altera_pcie_s10_reset_sync #(
    .WIDTH_RST                                                                       (11                                                                              )  // = 1
  ) rst_sync (
    .clk                                                                             (coreclkout_hip                                                                  ), // input
    .rst_n                                                                           (~reset_status_hip                                                               ), // input
    .srst_n                                                                          (core_rst_n                                                                      )  // output [WIDTH_RST-1:0]
  );

  altera_pcie_s10_avmm_bridge_dcore # (
    // PCIe HIP AVMM-specific parameters
    .DEVICE_FAMILY                                                                   ("Stratix 10"                                                                    ), // = "Stratix 10",
    .ENABLE_ECC                                                                      ("FALSE"                                                                         ), // = "FALSE",

    .enable_a2p_interrupt_hwtcl                                                      (enable_a2p_interrupt_hwtcl                                                      ), // = 0,
    .enable_advanced_interrupt_hwtcl                                                 (enable_advanced_interrupt_hwtcl                                                 ), // = 0,

    .dma_enabled_hwtcl                                                               (dma_enabled_hwtcl                                                               ), // = 1,     // 0 - not enabled,  1 - enabled
    .dma_controller_enabled_hwtcl                                                    (dma_controller_enabled_hwtcl                                                    ), // = 1,     // 0 - not enabled,  1 - enabled
    .avmm_addr_width_hwtcl                                                           (avmm_addr_width_hwtcl                                                           ), // 32(address translation enabled) or 64
    .txs_enabled_hwtcl                                                               (txs_enabled_hwtcl                                                               ), // = 1,     // 0 - not enabled,  1 - enabled
    .txs_address_width_hwtcl                                                         (txs_address_width_hwtcl                                                         ), // = 32
    .hptxs_enabled_hwtcl                                                             (hptxs_enabled_hwtcl                                                             ), // = 1,     // 0 - not enabled,  1 - enabled
    .hptxs_address_width_hwtcl                                                       (hptxs_address_width_hwtcl                                                       ), // = 32,
    .hptxs_address_translation_table_address_width_hwtcl                             (hptxs_address_translation_table_address_width_hwtcl                             ), // = 9,     // [0-9] are allowed. e.g. 9:512 entries
    .hptxs_address_translation_window_address_width_hwtcl                            (hptxs_address_translation_window_address_width_hwtcl                            ), // = 12,    // [12-(32-hptxs_address_translation_table_address_width_hwtcl)] are allowed. e.g. 12:4KB window


    .pf0_bar0_enable_rxm_burst_hwtcl                                                 (pf0_bar0_enable_rxm_burst_hwtcl                                                 ), // = 0,
    .pf0_bar1_enable_rxm_burst_hwtcl                                                 (pf0_bar1_enable_rxm_burst_hwtcl                                                 ), // = 0,
    .pf0_bar2_enable_rxm_burst_hwtcl                                                 (pf0_bar2_enable_rxm_burst_hwtcl                                                 ), // = 0,
    .pf0_bar3_enable_rxm_burst_hwtcl                                                 (pf0_bar3_enable_rxm_burst_hwtcl                                                 ), // = 0,
    .pf0_bar4_enable_rxm_burst_hwtcl                                                 (pf0_bar4_enable_rxm_burst_hwtcl                                                 ), // = 0,
    .pf0_bar5_enable_rxm_burst_hwtcl                                                 (pf0_bar5_enable_rxm_burst_hwtcl                                                 ), // = 0,

    // PCIe HIP AST parameters
    .pf0_bar0_address_width_hwtcl                                                    (pf0_bar0_address_width_hwtcl                                                    ), // = 0,
    .pf0_bar1_address_width_hwtcl                                                    (pf0_bar1_address_width_hwtcl                                                    ), // = 0,
    .pf0_bar2_address_width_hwtcl                                                    (pf0_bar2_address_width_hwtcl                                                    ), // = 0,
    .pf0_bar3_address_width_hwtcl                                                    (pf0_bar3_address_width_hwtcl                                                    ), // = 0,
    .pf0_bar4_address_width_hwtcl                                                    (pf0_bar4_address_width_hwtcl                                                    ), // = 0,
    .pf0_bar5_address_width_hwtcl                                                    (pf0_bar5_address_width_hwtcl                                                    ), // = 0,

    .pf0_pci_type0_bar0_enabled                                                      (pf0_pci_type0_bar0_enabled                                                      ), // = "enable",
    .pf0_pci_type0_bar1_enabled                                                      (pf0_pci_type0_bar1_enabled                                                      ), // = "enable",
    .pf0_pci_type0_bar2_enabled                                                      (pf0_pci_type0_bar2_enabled                                                      ), // = "enable",
    .pf0_pci_type0_bar3_enabled                                                      (pf0_pci_type0_bar3_enabled                                                      ), // = "enable",
    .pf0_pci_type0_bar4_enabled                                                      (pf0_pci_type0_bar4_enabled                                                      ), // = "enable",
    .pf0_pci_type0_bar5_enabled                                                      (pf0_pci_type0_bar5_enabled                                                      ), // = "enable",

    .pf0_bar0_type                                                                   (pf0_bar0_type                                                                   ), // = "pf0_bar0_mem32",
    .pf0_bar1_type                                                                   (pf0_bar1_type                                                                   ), // = "pf0_bar1_mem32",
    .pf0_bar2_type                                                                   (pf0_bar2_type                                                                   ), // = "pf0_bar2_mem32",
    .pf0_bar3_type                                                                   (pf0_bar3_type                                                                   ), // = "pf0_bar3_mem32",
    .pf0_bar4_type                                                                   (pf0_bar4_type                                                                   ), // = "pf0_bar4_mem32",
    .pf0_bar5_type                                                                   (pf0_bar5_type                                                                   )  // = "pf0_bar5_mem32",
  ) dcore (

    // clock and reset
    .clk                                                                             (coreclkout_hip                                                                  ), // input
    .rst_n                                                                           (core_rst_n[9:0]                                                                 ), // input

    // PCIe Read DMA Avalon-MM master (RDDMA)
    .rd_dma_address_o                                                                (rd_dma_address_o                                                                ), // output  [avmm_addr_width_hwtcl-1:0]
    .rd_dma_byte_enable_o                                                            (rd_dma_byte_enable_o                                                            ), // output  [31:0]
    .rd_dma_write_o                                                                  (rd_dma_write_o                                                                  ), // output
    .rd_dma_write_data_o                                                             (rd_dma_write_data_o                                                             ), // output  [255:0]
    .rd_dma_wait_request_i                                                           (rd_dma_wait_request_i                                                           ), // input
    .rd_dma_burst_count_o                                                            (rd_dma_burst_count_o                                                            ), // output  [4:0]

    // PCIe Read DMA Decriptor Table Slave
    .rd_dts_chip_select_i                                                            (rd_dts_chip_select_i                                                            ), // input
    .rd_dts_address_i                                                                (rd_dts_address_i                                                                ), // input   [7:0]
    .rd_dts_write_i                                                                  (rd_dts_write_i                                                                  ), // input
    .rd_dts_write_data_i                                                             (rd_dts_write_data_i                                                             ), // input   [255:0]
    .rd_dts_wait_request_o                                                           (rd_dts_wait_request_o                                                           ), // output
    .rd_dts_burst_count_i                                                            (rd_dts_burst_count_i                                                            ), // input   [4:0]

    // PCIe Read DMA Decriptor Status Update & MSI Master
    .rd_dcm_address_o                                                                (rd_dcm_address_o                                                                ), // output  [63:0]
    .rd_dcm_byte_enable_o                                                            (rd_dcm_byte_enable_o                                                            ), // output  [3:0]
    .rd_dcm_read_o                                                                   (rd_dcm_read_o                                                                   ), // output
    .rd_dcm_read_data_i                                                              (rd_dcm_read_data_i                                                              ), // input   [31:0]
    .rd_dcm_write_o                                                                  (rd_dcm_write_o                                                                  ), // output
    .rd_dcm_writedata_o                                                              (rd_dcm_writedata_o                                                              ), // output  [31:0]
    .rd_dcm_wait_request_i                                                           (rd_dcm_wait_request_i                                                           ), // input
    .rd_dcm_read_data_valid_i                                                        (rd_dcm_read_data_valid_i                                                        ), // input

    // PCIe Read DMA control Avalon-ST sink (RDDMA_RX)
    .rd_ast_rx_data_i                                                                (rd_ast_rx_data_i                                                                ), // input   [159:0]
    .rd_ast_rx_ready_o                                                               (rd_ast_rx_ready_o                                                               ), // output
    .rd_ast_rx_valid_i                                                               (rd_ast_rx_valid_i                                                               ), // input

    // PCIe Read DMA status Avalon-ST source (RDDMA_TX)
    .rd_ast_tx_data_o                                                                (rd_ast_tx_data_o                                                                ), // output  [31:0]
    .rd_ast_tx_valid_o                                                               (rd_ast_tx_valid_o                                                               ), // output

    // PCIe Write DMA Avalon-MM master (WRDMA)
    .wr_dma_address_o                                                                (wr_dma_address_o                                                                ), // output  [avmm_addr_width_hwtcl-1:0]
    .wr_dma_byte_enable_o                                                            (wr_dma_byte_enable_o                                                            ), // output  [31:0]
    .wr_dma_read_o                                                                   (wr_dma_read_o                                                                   ), // output
    .wr_dma_read_data_i                                                              (wr_dma_read_data_i                                                              ), // input   [255:0]
    .wr_dma_wait_request_i                                                           (wr_dma_wait_request_i                                                           ), // input
    .wr_dma_read_data_valid_i                                                        (wr_dma_read_data_valid_i                                                        ), // input
    .wr_dma_burst_count_o                                                            (wr_dma_burst_count_o                                                            ), // output  [4:0]

    // PCIe Write DMA Decriptor Table Slave
    .wr_dts_chip_select_i                                                            (wr_dts_chip_select_i                                                            ), // input
    .wr_dts_address_i                                                                (wr_dts_address_i                                                                ), // input   [7:0]
    .wr_dts_write_i                                                                  (wr_dts_write_i                                                                  ), // input
    .wr_dts_write_data_i                                                             (wr_dts_write_data_i                                                             ), // input   [255:0]
    .wr_dts_wait_request_o                                                           (wr_dts_wait_request_o                                                           ), // output
    .wr_dts_burst_count_i                                                            (wr_dts_burst_count_i                                                            ), // input   [4:0]

    // PCIe Write DMA Decriptor Status Update & MSI Master
    .wr_dcm_address_o                                                                (wr_dcm_address_o                                                                ), // output  [63:0]
    .wr_dcm_byte_enable_o                                                            (wr_dcm_byte_enable_o                                                            ), // output  [3:0]
    .wr_dcm_read_o                                                                   (wr_dcm_read_o                                                                   ), // output
    .wr_dcm_read_data_i                                                              (wr_dcm_read_data_i                                                              ), // input   [31:0]
    .wr_dcm_write_o                                                                  (wr_dcm_write_o                                                                  ), // output
    .wr_dcm_writedata_o                                                              (wr_dcm_writedata_o                                                              ), // output  [31:0]
    .wr_dcm_wait_request_i                                                           (wr_dcm_wait_request_i                                                           ), // input
    .wr_dcm_read_data_valid_i                                                        (wr_dcm_read_data_valid_i                                                        ), // input

    // PCIe Write DMA control Avalon-ST sink (WRDMA_RX)
    .wr_ast_rx_data_i                                                                (wr_ast_rx_data_i                                                                ), // input   [159:0]
    .wr_ast_rx_ready_o                                                               (wr_ast_rx_ready_o                                                               ), // output
    .wr_ast_rx_valid_i                                                               (wr_ast_rx_valid_i                                                               ), // input

    // PCIe Write DMA status Avalon-ST source (WRDMA_TX)
    .wr_ast_tx_data_o                                                                (wr_ast_tx_data_o                                                                ), // output   [31:0]
    .wr_ast_tx_valid_o                                                               (wr_ast_tx_valid_o                                                               ), // output

    // High performance bursting Avalon-MM slave (HPTXS)
    .hptxs_address_i                                                                 (hptxs_address_i                                                                 ), // input   [hptxs_address_width_hwtcl-1:0]
    .hptxs_byteenable_i                                                              (hptxs_byteenable_i                                                              ), // input   [31:0]
    .hptxs_read_i                                                                    (hptxs_read_i                                                                    ), // input
    .hptxs_readdata_o                                                                (hptxs_readdata_o                                                                ), // output  [255:0]
    .hptxs_write_i                                                                   (hptxs_write_i                                                                   ), // input
    .hptxs_writedata_i                                                               (hptxs_writedata_i                                                               ), // input   [255:0]
    .hptxs_waitrequest_o                                                             (hptxs_waitrequest_o                                                             ), // output
    .hptxs_readdatavalid_o                                                           (hptxs_readdatavalid_o                                                           ), // output
    .hptxs_burstcount_i                                                              (hptxs_burstcount_i                                                              ), // input   [4:0]

    // 32-bit wide, non-bursting Avalon-MM slave with individual byte enable control (TXS)
    .txs_chipselect_i                                                                (txs_chipselect_i                                                                ), // input
    .txs_address_i                                                                   (txs_address_i                                                                   ), // input   [txs_address_width_hwtcl-1:0]
    .txs_byteenable_i                                                                (txs_byteenable_i                                                                ), // input   [3:0]
    .txs_read_i                                                                      (txs_read_i                                                                      ), // input
    .txs_readdata_o                                                                  (txs_readdata_o                                                                  ), // output  [31:0]
    .txs_write_i                                                                     (txs_write_i                                                                     ), // input
    .txs_writedata_i                                                                 (txs_writedata_i                                                                 ), // input   [31:0]
    .txs_waitrequest_o                                                               (txs_waitrequest_o                                                               ), // output
    .txs_readdatavalid_o                                                             (txs_readdatavalid_o                                                             ), // output

    // BAR 0 Avalon-MM master with individual byte enabling and interrupt support (RXM).
    .rxm_bar0_address_o                                                              (rxm_bar0_address_o                                                              ), // output  [avmm_addr_width_hwtcl-1:0]
    .rxm_bar0_byteenable_o                                                           (rxm_bar0_byteenable_o                                                           ), // output  [(pf0_bar0_enable_rxm_burst_hwtcl==1)?31:3):0]
    .rxm_bar0_read_o                                                                 (rxm_bar0_read_o                                                                 ), // output
    .rxm_bar0_readdata_i                                                             (rxm_bar0_readdata_i                                                             ), // input   [(pf0_bar0_enable_rxm_burst_hwtcl==1)?255:31):0]
    .rxm_bar0_write_o                                                                (rxm_bar0_write_o                                                                ), // output
    .rxm_bar0_writedata_o                                                            (rxm_bar0_writedata_o                                                            ), // output  [(pf0_bar0_enable_rxm_burst_hwtcl==1)?255:31):0]
    .rxm_bar0_waitrequest_i                                                          (rxm_bar0_waitrequest_i                                                          ), // input
    .rxm_bar0_burstcount_o                                                           (rxm_bar0_burstcount_o                                                           ), // output  [4:0]
    .rxm_bar0_readdatavalid_i                                                        (rxm_bar0_readdatavalid_i                                                        ), // input

    // BAR 1 Avalon-MM master with individual byte enabling and interrupt support (RXM).
    .rxm_bar1_address_o                                                              (rxm_bar1_address_o                                                              ), // output  [avmm_addr_width_hwtcl-1:0]
    .rxm_bar1_byteenable_o                                                           (rxm_bar1_byteenable_o                                                           ), // output  [(pf0_bar1_enable_rxm_burst_hwtcl==1)?31:3):0]
    .rxm_bar1_read_o                                                                 (rxm_bar1_read_o                                                                 ), // output
    .rxm_bar1_readdata_i                                                             (rxm_bar1_readdata_i                                                             ), // input   [(pf0_bar1_enable_rxm_burst_hwtcl==1)?255:31):0]
    .rxm_bar1_write_o                                                                (rxm_bar1_write_o                                                                ), // output
    .rxm_bar1_writedata_o                                                            (rxm_bar1_writedata_o                                                            ), // output  [(pf0_bar1_enable_rxm_burst_hwtcl==1)?255:31):0]
    .rxm_bar1_waitrequest_i                                                          (rxm_bar1_waitrequest_i                                                          ), // input
    .rxm_bar1_burstcount_o                                                           (rxm_bar1_burstcount_o                                                           ), // output  [4:0]
    .rxm_bar1_readdatavalid_i                                                        (rxm_bar1_readdatavalid_i                                                        ), // input

    // BAR 2 Avalon-MM master with individual byte enabling and interrupt support (RXM).
    .rxm_bar2_address_o                                                              (rxm_bar2_address_o                                                              ), // output  [avmm_addr_width_hwtcl-1:0]
    .rxm_bar2_byteenable_o                                                           (rxm_bar2_byteenable_o                                                           ), // output  [(pf0_bar2_enable_rxm_burst_hwtcl==1)?31:3):0]
    .rxm_bar2_read_o                                                                 (rxm_bar2_read_o                                                                 ), // output
    .rxm_bar2_readdata_i                                                             (rxm_bar2_readdata_i                                                             ), // input   [(pf0_bar2_enable_rxm_burst_hwtcl==1)?255:31):0]
    .rxm_bar2_write_o                                                                (rxm_bar2_write_o                                                                ), // output
    .rxm_bar2_writedata_o                                                            (rxm_bar2_writedata_o                                                            ), // output  [(pf0_bar2_enable_rxm_burst_hwtcl==1)?255:31):0]
    .rxm_bar2_waitrequest_i                                                          (rxm_bar2_waitrequest_i                                                          ), // input
    .rxm_bar2_burstcount_o                                                           (rxm_bar2_burstcount_o                                                           ), // output  [4:0]
    .rxm_bar2_readdatavalid_i                                                        (rxm_bar2_readdatavalid_i                                                        ), // input

    // BAR 3 Avalon-MM master with individual byte enabling and interrupt support (RXM).
    .rxm_bar3_address_o                                                              (rxm_bar3_address_o                                                              ), // output  [avmm_addr_width_hwtcl-1:0]
    .rxm_bar3_byteenable_o                                                           (rxm_bar3_byteenable_o                                                           ), // output  [(pf0_bar3_enable_rxm_burst_hwtcl==1)?31:3):0]
    .rxm_bar3_read_o                                                                 (rxm_bar3_read_o                                                                 ), // output
    .rxm_bar3_readdata_i                                                             (rxm_bar3_readdata_i                                                             ), // input   [(pf0_bar3_enable_rxm_burst_hwtcl==1)?255:31):0]
    .rxm_bar3_write_o                                                                (rxm_bar3_write_o                                                                ), // output
    .rxm_bar3_writedata_o                                                            (rxm_bar3_writedata_o                                                            ), // output  [(pf0_bar3_enable_rxm_burst_hwtcl==1)?255:31):0]
    .rxm_bar3_waitrequest_i                                                          (rxm_bar3_waitrequest_i                                                          ), // input
    .rxm_bar3_burstcount_o                                                           (rxm_bar3_burstcount_o                                                           ), // output  [4:0]
    .rxm_bar3_readdatavalid_i                                                        (rxm_bar3_readdatavalid_i                                                        ), // input

    // BAR 4 Avalon-MM master with individual byte enabling and interrupt support (RXM).
    .rxm_bar4_address_o                                                              (rxm_bar4_address_o                                                              ), // output  [avmm_addr_width_hwtcl-1:0]
    .rxm_bar4_byteenable_o                                                           (rxm_bar4_byteenable_o                                                           ), // output  [(pf0_bar4_enable_rxm_burst_hwtcl==1)?31:3):0]
    .rxm_bar4_read_o                                                                 (rxm_bar4_read_o                                                                 ), // output
    .rxm_bar4_readdata_i                                                             (rxm_bar4_readdata_i                                                             ), // input   [(pf0_bar4_enable_rxm_burst_hwtcl==1)?255:31):0]
    .rxm_bar4_write_o                                                                (rxm_bar4_write_o                                                                ), // output
    .rxm_bar4_writedata_o                                                            (rxm_bar4_writedata_o                                                            ), // output  [(pf0_bar4_enable_rxm_burst_hwtcl==1)?255:31):0]
    .rxm_bar4_waitrequest_i                                                          (rxm_bar4_waitrequest_i                                                          ), // input
    .rxm_bar4_burstcount_o                                                           (rxm_bar4_burstcount_o                                                           ), // output  [4:0]
    .rxm_bar4_readdatavalid_i                                                        (rxm_bar4_readdatavalid_i                                                        ), // input

    // BAR 5 Avalon-MM master with individual byte enabling and interrupt support (RXM).
    .rxm_bar5_address_o                                                              (rxm_bar5_address_o                                                              ), // output  [avmm_addr_width_hwtcl-1:0]
    .rxm_bar5_byteenable_o                                                           (rxm_bar5_byteenable_o                                                           ), // output  [(pf0_bar5_enable_rxm_burst_hwtcl==1)?31:3):0]
    .rxm_bar5_read_o                                                                 (rxm_bar5_read_o                                                                 ), // output
    .rxm_bar5_readdata_i                                                             (rxm_bar5_readdata_i                                                             ), // input   [(pf0_bar5_enable_rxm_burst_hwtcl==1)?255:31):0]
    .rxm_bar5_write_o                                                                (rxm_bar5_write_o                                                                ), // output
    .rxm_bar5_writedata_o                                                            (rxm_bar5_writedata_o                                                            ), // output  [(pf0_bar5_enable_rxm_burst_hwtcl==1)?255:31):0]
    .rxm_bar5_waitrequest_i                                                          (rxm_bar5_waitrequest_i                                                          ), // input
    .rxm_bar5_burstcount_o                                                           (rxm_bar5_burstcount_o                                                           ), // output  [4:0]
    .rxm_bar5_readdatavalid_i                                                        (rxm_bar5_readdatavalid_i                                                        ), // input

    // Interrupt inputs
    .rxm_irq_i                                                                       (rxm_irq_i                                                                       ), // input   [15:0]

    .intx_req_i                                                                      (intx_req_i                                                                      ), // input

    // Avalon-MM slave for Control and Status registers access (CRA)
    .cra_chipselect_i                                                                (cra_chipselect_i                                                                ), // input
    .cra_address_i                                                                   (cra_address_i                                                                   ), // input   [14:0]
    .cra_byteenable_i                                                                (cra_byteenable_i                                                                ), // input   [3:0]
    .cra_read_i                                                                      (cra_read_i                                                                      ), // input
    .cra_readdata_o                                                                  (cra_readdata_o                                                                  ), // output  [31:0]
    .cra_write_i                                                                     (cra_write_i                                                                     ), // input
    .cra_writedata_i                                                                 (cra_writedata_i                                                                 ), // input   [31:0]
    .cra_waitrequest_o                                                               (cra_waitrequest_o                                                               ), // output
    .cra_readdatavalid_o                                                             (cra_readdatavalid_o                                                             ), // output

    .cra_irq_o                                                                       (cra_irq_o                                                                       ), // output

    // PCIe HIP AVST Signals
    //RX Data Path
    .rx_st_ready                                                                     (rx_st_ready                                                                     ), // output
    .rx_st_sop                                                                       (rx_st_sop                                                                       ), // input
    .rx_st_eop                                                                       (rx_st_eop                                                                       ), // input
    .rx_st_data                                                                      (rx_st_data                                                                      ), // input   [255:0]
    .rx_st_parity                                                                    (rx_st_parity                                                                    ), // input   [31:0]
    .rx_st_valid                                                                     (rx_st_valid                                                                     ), // input
    .rx_st_bar_range                                                                 (rx_st_bar_range                                                                 ), // input   [2:0]
    .rx_st_empty                                                                     (rx_st_empty                                                                     ), // input   [2:0]

    //TX Data Path
    .tx_st_sop                                                                       (tx_st_sop                                                                       ), // output
    .tx_st_eop                                                                       (tx_st_eop                                                                       ), // output
    .tx_st_data                                                                      (tx_st_data                                                                      ), // output  [255:0]
    .tx_st_parity                                                                    (tx_st_parity                                                                    ), // output  [31:0]
    .tx_st_valid                                                                     (tx_st_valid                                                                     ), // output
    .tx_st_err                                                                       (tx_st_err                                                                       ), // output
    .tx_st_ready                                                                     (tx_st_ready                                                                     ), // input

    // TX credit interface
    .tx_cdts_type                                                                    (tx_cdts_type                                                                    ), // input   [1:0]
    .tx_data_cdts_consumed                                                           (tx_data_cdts_consumed                                                           ), // input
    .tx_hdr_cdts_consumed                                                            (tx_hdr_cdts_consumed                                                            ), // input
    .tx_cdts_data_value                                                              (tx_cdts_data_value                                                              ), // input   [1:0]
    .tx_pd_cdts                                                                      (tx_pd_cdts                                                                      ), // input   [11:0]
    .tx_npd_cdts                                                                     (tx_npd_cdts                                                                     ), // input   [11:0]
    .tx_cpld_cdts                                                                    (tx_cpld_cdts                                                                    ), // input   [11:0]
    .tx_ph_cdts                                                                      (tx_ph_cdts                                                                      ), // input   [7:0]
    .tx_nph_cdts                                                                     (tx_nph_cdts                                                                     ), // input   [7:0]
    .tx_cplh_cdts                                                                    (tx_cplh_cdts                                                                    ), // input   [7:0]

    // RX buffer limit interface
    .rx_np_buffer_limit                                                              (rx_np_buffer_limit                                                              ), // output  [6:0]
    .rx_p_buffer_limit                                                               (rx_p_buffer_limit                                                               ), // output  [6:0]
    .rx_cpl_buffer_limit                                                             (rx_cpl_buffer_limit                                                             ), // output  [9:0]

    // HIP misc interface
    .tl_cfg_func                                                                     (tl_cfg_func                                                                     ), // input   [1:0]
    .tl_cfg_add                                                                      (tl_cfg_add                                                                      ), // input   [4:0]
    .tl_cfg_ctl                                                                      (tl_cfg_ctl                                                                      ), // input   [31:0]

    // MSI interface
    .msi_intfc_o                                                                     (msi_intfc_o                                                                     ), // output  [81:0]
    .msi_control_o                                                                   (msi_control_o                                                                   ), // output  [15:0]
    .msix_intfc_o                                                                    (msix_intfc_o                                                                    ), // output  [15:0]

    // HIP interrupt status in root mode
    .int_status                                                                      (int_status                                                                      ), // input   [7:0]
    .int_status_common                                                               (int_status_common                                                               ), // input   [2:0]

    // HIP legacy interrupt input
    .app_int_sts                                                                     (app_int_sts                                                                     ), // output

    // parity errors from HIP
    .rx_par_err                                                                      (rx_par_err                                                                      ), // input
    .tx_par_err                                                                      (tx_par_err                                                                      )  // input
  );

  altera_pcie_s10_hip_ast # (

    //Attributes IPTCL
    //Virtual Attributes
    .powerdown_mode                                                                  (powerdown_mode                                                                  ), //parameter
    .func_mode                                                                       (func_mode                                                                       ), //parameter
    .sup_mode                                                                        (sup_mode                                                                        ), //parameter
    .virtual_rp_ep_mode                                                              (virtual_rp_ep_mode                                                              ), //parameter
    .virtual_link_width                                                              (virtual_link_width                                                              ), //parameter
    .virtual_link_rate                                                               (virtual_link_rate                                                               ), //parameter
    .virtual_maxpayload_size                                                         (virtual_maxpayload_size                                                         ), //parameter
    .virtual_gen2_pma_pll_usage                                                      (virtual_gen2_pma_pll_usage                                                      ), //parameter
    .virtual_hrdrstctrl_en                                                           (virtual_hrdrstctrl_en                                                           ), //parameter
    .virtual_uc_calibration_en                                                       (virtual_uc_calibration_en                                                       ), //parameter
    .virtual_txeq_mode                                                               (virtual_txeq_mode                                                               ), //parameter
    .virtual_pf1_enable                                                              (virtual_pf1_enable                                                              ), //parameter
    .virtual_pf0_sriov_enable                                                        (virtual_pf0_sriov_enable                                                        ), //parameter
    .virtual_pf1_sriov_enable                                                        (virtual_pf1_sriov_enable                                                        ), //parameter

    .virtual_pf0_msix_enable                                                         (virtual_pf0_msix_enable                                                         ), //parameter
    .virtual_pf0_msi_enable                                                          (virtual_pf0_msi_enable                                                          ), //parameter
    .virtual_pf0_sn_cap_enable                                                       (virtual_pf0_sn_cap_enable                                                       ), //parameter
    .virtual_pf0_tph_cap_enable                                                      (virtual_pf0_tph_cap_enable                                                      ), //parameter
    .virtual_pf0_ats_cap_enable                                                      (virtual_pf0_ats_cap_enable                                                      ), //parameter
    .virtual_pf0_user_vsec_cap_enable                                                (virtual_pf0_user_vsec_cap_enable                                                ), //parameter
    .virtual_pf0_sriov_num_vf_non_ari                                                (virtual_pf0_sriov_num_vf_non_ari                                                ), //parameter  [15:0]
    .virtual_pf0_sriov_vf_bar0_enabled                                               (virtual_pf0_sriov_vf_bar0_enabled                                               ), //parameter
    .virtual_pf0_sriov_vf_bar1_enabled                                               (virtual_pf0_sriov_vf_bar1_enabled                                               ), //parameter
    .virtual_pf0_sriov_vf_bar2_enabled                                               (virtual_pf0_sriov_vf_bar2_enabled                                               ), //parameter
    .virtual_pf0_sriov_vf_bar3_enabled                                               (virtual_pf0_sriov_vf_bar3_enabled                                               ), //parameter
    .virtual_pf0_sriov_vf_bar4_enabled                                               (virtual_pf0_sriov_vf_bar4_enabled                                               ), //parameter
    .virtual_pf0_sriov_vf_bar5_enabled                                               (virtual_pf0_sriov_vf_bar5_enabled                                               ), //parameter
    .virtual_vf1_pf0_user_vsec_cap_enable                                            (virtual_vf1_pf0_user_vsec_cap_enable                                            ), //parameter
    .virtual_vf1_pf0_tph_cap_enable                                                  (virtual_vf1_pf0_tph_cap_enable                                                  ), //parameter
    .virtual_vf1_pf0_ats_cap_enable                                                  (virtual_vf1_pf0_ats_cap_enable                                                  ), //parameter


    .virtual_pf1_msix_enable                                                         (virtual_pf1_msix_enable                                                         ), //parameter
    .virtual_pf1_msi_enable                                                          (virtual_pf1_msi_enable                                                          ), //parameter
    .virtual_pf1_sn_cap_enable                                                       (virtual_pf1_sn_cap_enable                                                       ), //parameter
    .virtual_pf1_tph_cap_enable                                                      (virtual_pf1_tph_cap_enable                                                      ), //parameter
    .virtual_pf1_ats_cap_enable                                                      (virtual_pf1_ats_cap_enable                                                      ), //parameter
    .virtual_pf1_user_vsec_cap_enable                                                (virtual_pf1_user_vsec_cap_enable                                                ), //parameter
    .virtual_pf1_sriov_num_vf_non_ari                                                (virtual_pf1_sriov_num_vf_non_ari                                                ), //parameter  [15:0]
    .virtual_pf1_sriov_vf_bar0_enabled                                               (virtual_pf1_sriov_vf_bar0_enabled                                               ), //parameter
    .virtual_pf1_sriov_vf_bar1_enabled                                               (virtual_pf1_sriov_vf_bar1_enabled                                               ), //parameter
    .virtual_pf1_sriov_vf_bar2_enabled                                               (virtual_pf1_sriov_vf_bar2_enabled                                               ), //parameter
    .virtual_pf1_sriov_vf_bar3_enabled                                               (virtual_pf1_sriov_vf_bar3_enabled                                               ), //parameter
    .virtual_pf1_sriov_vf_bar4_enabled                                               (virtual_pf1_sriov_vf_bar4_enabled                                               ), //parameter
    .virtual_pf1_sriov_vf_bar5_enabled                                               (virtual_pf1_sriov_vf_bar5_enabled                                               ), //parameter
    .virtual_vf1_pf1_user_vsec_cap_enable                                            (virtual_vf1_pf1_user_vsec_cap_enable                                            ), //parameter
    .virtual_vf1_pf1_tph_cap_enable                                                  (virtual_vf1_pf1_tph_cap_enable                                                  ), //parameter
    .virtual_vf1_pf1_ats_cap_enable                                                  (virtual_vf1_pf1_ats_cap_enable                                                  ), //parameter

    .virtual_drop_vendor0_msg                                                        (virtual_drop_vendor0_msg                                                        ), //parameter
    .virtual_drop_vendor1_msg                                                        (virtual_drop_vendor1_msg                                                        ), //parameter
    .virtual_phase23_txpreset                                                        (virtual_phase23_txpreset                                                        ), //parameter

    //  hard reset controller Attributes
    //-------------------------------
    .hrc_pma_perst_en                                                                (hrc_pma_perst_en                                                                ), //parameter
    .hrc_en_pcs_fifo_err                                                             (hrc_en_pcs_fifo_err                                                             ), //parameter
    .hrc_pll_perst_en                                                                (hrc_pll_perst_en                                                                ), //parameter
    .hrc_soft_rstctrl_clr                                                            (hrc_soft_rstctrl_clr                                                            ), //parameter
    .hrc_soft_rstctrl_en                                                             (hrc_soft_rstctrl_en                                                             ), //parameter
    .clrhip_not_rst_sticky                                                           (clrhip_not_rst_sticky                                                           ), //parameter

    //  pld adaptor Attributes
    //-------------------------------
    .pld_tx_parity_ena                                                               (pld_tx_parity_ena                                                               ), //parameter
    .pld_rx_parity_ena                                                               (pld_rx_parity_ena                                                               ), //parameter
    .pld_rx_posted_bufflimit_bypass                                                  (pld_rx_posted_bufflimit_bypass                                                  ), //parameter
    .pld_rx_cpl_bufflimit_bypass                                                     (pld_rx_cpl_bufflimit_bypass                                                     ), //parameter
    .pld_rx_np_bufflimit_bypass                                                      (pld_rx_np_bufflimit_bypass                                                      ), //parameter
    .enable_rx_buffer_limit_ports_hwtcl                                              (enable_rx_buffer_limit_ports_hwtcl                                              ), //parameter

    //  vsec  Attributes
    //-------------------------------
    .cvp_data_encrypted                                                              (cvp_data_encrypted                                                              ), //parameter
    .cvp_extra                                                                       (cvp_extra                                                                       ), //parameter
    .cvp_intf_reset_ctl                                                              (cvp_intf_reset_ctl                                                              ), //parameter  [2:0]
    .cvp_data_compressed                                                             (cvp_data_compressed                                                             ), //parameter
    .cvp_jtag0                                                                       (cvp_jtag0                                                                       ), //parameter  [31:0]
    .cvp_jtag1                                                                       (cvp_jtag1                                                                       ), //parameter  [31:0]
    .cvp_jtag2                                                                       (cvp_jtag2                                                                       ), //parameter  [31:0]
    .cvp_jtag3                                                                       (cvp_jtag3                                                                       ), //parameter  [31:0]
    .cvp_user_id                                                                     (cvp_user_id                                                                     ), //parameter  [15:0]

    // crs_control  Attributes
    //------------------------------
    .cvp_irq_en                                                                      (cvp_irq_en                                                                      ), //parameter

    // lane flip control  Attributes
    //------------------------------
    .rx_lane_flip_en                                                                 (rx_lane_flip_en                                                                 ), //parameter
    .tx_lane_flip_en                                                                 (tx_lane_flip_en                                                                 ), //parameter

    // miscellaneous Phy control Attributes
    //-------------------------------
    .pipe_ctrl                                                                       (pipe_ctrl                                                                       ), //parameter  [25:0]

    // miscellaneous Phy control Attributes
    //-------------------------------
    .k_phy_misc_ctrl_rsvd_0_5                                                        (k_phy_misc_ctrl_rsvd_0_5                                                        ), //parameter  [5:0]

    // use gpio pin to drive SSM IRQ Attributes(one bit per pin)
    //-------------------------------
    .gpio_irq                                                                        (gpio_irq                                                                        ), //parameter  [7:0]

    // diagnostic  Attributes
    //-------------------------------
    .test_in_override                                                                (test_in_override                                                                ), //parameter

    // ecc Attributes
    //-------------------------------
    .valid_ecc_err_rpt_en                                                            (valid_ecc_err_rpt_en                                                            ), //parameter

    // diagnostic  Attributes
    //-------------------------------
    .test_in_lo                                                                      (test_in_lo                                                                      ), //parameter  [31:0]
    .test_in_hi                                                                      (test_in_hi                                                                      ), //parameter  [31:0]

    //  ssm irq Attributes
    //-------------------------------
    .irq_misc_ctrl                                                                   (irq_misc_ctrl                                                                   ), //parameter  [5:0]

    // pf0_type0_hdr Attributes
    //-------------------------------
    .pf0_pci_type0_vendor_id                                                         (pf0_pci_type0_vendor_id                                                         ), //parameter  [15:0]
    .pf0_pci_type0_device_id                                                         (pf0_pci_type0_device_id                                                         ), //parameter  [15:0]
    .pf0_program_interface                                                           (pf0_program_interface                                                           ), //parameter  [7:0]
    .pf0_subclass_code                                                               (pf0_subclass_code                                                               ), //parameter  [7:0]
    .pf0_base_class_code                                                             (pf0_base_class_code                                                             ), //parameter  [7:0]
    .pf0_pci_type0_bar0_enabled                                                      (pf0_pci_type0_bar0_enabled                                                      ), //parameter
    .pf0_bar0_type                                                                   (pf0_bar0_type                                                                   ), //parameter
    .pf0_bar0_prefetch                                                               (pf0_bar0_prefetch                                                               ), //parameter
    .pf0_pci_type0_bar1_enabled                                                      (pf0_pci_type0_bar1_enabled                                                      ), //parameter
    .pf0_pci_type0_bar2_enabled                                                      (pf0_pci_type0_bar2_enabled                                                      ), //parameter
    .pf0_bar2_type                                                                   (pf0_bar2_type                                                                   ), //parameter
    .pf0_bar2_prefetch                                                               (pf0_bar2_prefetch                                                               ), //parameter
    .pf0_pci_type0_bar3_enabled                                                      (pf0_pci_type0_bar3_enabled                                                      ), //parameter
    .pf0_pci_type0_bar4_enabled                                                      (pf0_pci_type0_bar4_enabled                                                      ), //parameter
    .pf0_bar4_type                                                                   (pf0_bar4_type                                                                   ), //parameter
    .pf0_bar4_prefetch                                                               (pf0_bar4_prefetch                                                               ), //parameter
    .pf0_pci_type0_bar5_enabled                                                      (pf0_pci_type0_bar5_enabled                                                      ), //parameter
    .pf0_cardbus_cis_pointer                                                         (pf0_cardbus_cis_pointer                                                         ), //parameter  [31:0]
    .pf0_subsys_vendor_id                                                            (pf0_subsys_vendor_id                                                            ), //parameter  [15:0]
    .pf0_subsys_dev_id                                                               (pf0_subsys_dev_id                                                               ), //parameter  [15:0]
    .pf0_rom_bar_enable                                                              (pf0_rom_bar_enable                                                              ), //parameter
    .pf0_rom_bar_enabled                                                             (pf0_rom_bar_enabled                                                             ), //parameter
    .pf0_rp_rom_bar_enabled                                                          (pf0_rp_rom_bar_enabled                                                          ), //parameter
    .pf0_rp_rom_mask                                                                 (pf0_rp_rom_mask                                                                 ), //parameter  [20:0]
    .pf0_int_pin                                                                     (pf0_int_pin                                                                     ), //parameter
    .pf0_bar0_address_width_hwtcl                                                    (pf0_bar0_address_width_hwtcl                                                    ), //parameter
    .pf0_bar1_address_width_hwtcl                                                    (pf0_bar1_address_width_hwtcl                                                    ), //parameter
    .pf0_bar2_address_width_hwtcl                                                    (pf0_bar2_address_width_hwtcl                                                    ), //parameter
    .pf0_bar3_address_width_hwtcl                                                    (pf0_bar3_address_width_hwtcl                                                    ), //parameter
    .pf0_bar4_address_width_hwtcl                                                    (pf0_bar4_address_width_hwtcl                                                    ), //parameter
    .pf0_bar5_address_width_hwtcl                                                    (pf0_bar5_address_width_hwtcl                                                    ), //parameter
    .pf0_expansion_base_address_register_hwtcl                                       (pf0_expansion_base_address_register_hwtcl                                       ), //parameter

    // pf0_sriov_cap Attributes
    //------------------------------        -
    .pf0_shadow_sriov_vf_stride_ari_cs2                                              (pf0_shadow_sriov_vf_stride_ari_cs2                                              ), //parameter  [15:0]
    .pf0_sriov_vf_offset_ari_cs2                                                     (pf0_sriov_vf_offset_ari_cs2                                                     ), //parameter  [15:0]
    .pf0_sriov_vf_offset_nonari                                                      (pf0_sriov_vf_offset_nonari                                                      ), //parameter  [15:0]
    .pf0_sriov_vf_stride_nonari                                                      (pf0_sriov_vf_stride_nonari                                                      ), //parameter  [15:0]
    .pf0_sriov_vf_device_id                                                          (pf0_sriov_vf_device_id                                                          ), //parameter  [15:0]
    .pf0_sriov_sup_page_size                                                         (pf0_sriov_sup_page_size                                                         ), //parameter  [31:0]
    .pf0_sriov_vf_bar0_mask                                                          (pf0_sriov_vf_bar0_mask                                                          ), //parameter  [31:0]
    .pf0_sriov_vf_bar0_type                                                          (pf0_sriov_vf_bar0_type                                                          ), //parameter
    .pf0_sriov_vf_bar0_prefetch                                                      (pf0_sriov_vf_bar0_prefetch                                                      ), //parameter
    .pf0_sriov_vf_bar1_mask                                                          (pf0_sriov_vf_bar1_mask                                                          ), //parameter  [31:0]
    .pf0_sriov_vf_bar2_mask                                                          (pf0_sriov_vf_bar2_mask                                                          ), //parameter  [31:0]
    .pf0_sriov_vf_bar2_type                                                          (pf0_sriov_vf_bar2_type                                                          ), //parameter
    .pf0_sriov_vf_bar2_prefetch                                                      (pf0_sriov_vf_bar2_prefetch                                                      ), //parameter
    .pf0_sriov_vf_bar3_mask                                                          (pf0_sriov_vf_bar3_mask                                                          ), //parameter  [31:0]
    .pf0_sriov_vf_bar4_mask                                                          (pf0_sriov_vf_bar4_mask                                                          ), //parameter  [31:0]
    .pf0_sriov_vf_bar4_type                                                          (pf0_sriov_vf_bar4_type                                                          ), //parameter
    .pf0_sriov_vf_bar4_prefetch                                                      (pf0_sriov_vf_bar4_prefetch                                                      ), //parameter
    .pf0_sriov_vf_bar5_mask                                                          (pf0_sriov_vf_bar5_mask                                                          ), //parameter  [31:0]

    // pf0_spcie_cap Attributes
    //------------------------------        -
    .pf0_usp_tx_preset3                                                              (pf0_usp_tx_preset3                                                              ), //parameter  [3:0]
    .pf0_usp_tx_preset1                                                              (pf0_usp_tx_preset1                                                              ), //parameter  [3:0]
    .pf0_usp_tx_preset6                                                              (pf0_usp_tx_preset6                                                              ), //parameter  [3:0]
    .pf0_usp_tx_preset9                                                              (pf0_usp_tx_preset9                                                              ), //parameter  [3:0]
    .pf0_usp_tx_preset15                                                             (pf0_usp_tx_preset15                                                             ), //parameter  [3:0]
    .pf0_usp_tx_preset12                                                             (pf0_usp_tx_preset12                                                             ), //parameter  [3:0]
    .pf0_usp_tx_preset0                                                              (pf0_usp_tx_preset0                                                              ), //parameter  [3:0]
    .pf0_usp_tx_preset4                                                              (pf0_usp_tx_preset4                                                              ), //parameter  [3:0]
    .pf0_usp_tx_preset2                                                              (pf0_usp_tx_preset2                                                              ), //parameter  [3:0]
    .pf0_usp_tx_preset8                                                              (pf0_usp_tx_preset8                                                              ), //parameter  [3:0]
    .pf0_usp_tx_preset10                                                             (pf0_usp_tx_preset10                                                             ), //parameter  [3:0]
    .pf0_usp_tx_preset7                                                              (pf0_usp_tx_preset7                                                              ), //parameter  [3:0]
    .pf0_usp_tx_preset5                                                              (pf0_usp_tx_preset5                                                              ), //parameter  [3:0]
    .pf0_usp_tx_preset13                                                             (pf0_usp_tx_preset13                                                             ), //parameter  [3:0]
    .pf0_usp_tx_preset11                                                             (pf0_usp_tx_preset11                                                             ), //parameter  [3:0]
    .pf0_usp_tx_preset14                                                             (pf0_usp_tx_preset14                                                             ), //parameter  [3:0]

    .pf0_usp_rx_preset_hint5                                                         (pf0_usp_rx_preset_hint5                                                         ), //parameter  [2:0]
    .pf0_usp_rx_preset_hint8                                                         (pf0_usp_rx_preset_hint8                                                         ), //parameter  [2:0]
    .pf0_usp_rx_preset_hint10                                                        (pf0_usp_rx_preset_hint10                                                        ), //parameter  [2:0]
    .pf0_usp_rx_preset_hint11                                                        (pf0_usp_rx_preset_hint11                                                        ), //parameter  [2:0]
    .pf0_usp_rx_preset_hint0                                                         (pf0_usp_rx_preset_hint0                                                         ), //parameter  [2:0]
    .pf0_usp_rx_preset_hint12                                                        (pf0_usp_rx_preset_hint12                                                        ), //parameter  [2:0]
    .pf0_usp_rx_preset_hint1                                                         (pf0_usp_rx_preset_hint1                                                         ), //parameter  [2:0]
    .pf0_usp_rx_preset_hint3                                                         (pf0_usp_rx_preset_hint3                                                         ), //parameter  [2:0]
    .pf0_usp_rx_preset_hint7                                                         (pf0_usp_rx_preset_hint7                                                         ), //parameter  [2:0]
    .pf0_usp_rx_preset_hint4                                                         (pf0_usp_rx_preset_hint4                                                         ), //parameter  [2:0]
    .pf0_usp_rx_preset_hint14                                                        (pf0_usp_rx_preset_hint14                                                        ), //parameter  [2:0]
    .pf0_usp_rx_preset_hint15                                                        (pf0_usp_rx_preset_hint15                                                        ), //parameter  [2:0]
    .pf0_usp_rx_preset_hint6                                                         (pf0_usp_rx_preset_hint6                                                         ), //parameter  [2:0]
    .pf0_usp_rx_preset_hint2                                                         (pf0_usp_rx_preset_hint2                                                         ), //parameter  [2:0]
    .pf0_usp_rx_preset_hint13                                                        (pf0_usp_rx_preset_hint13                                                        ), //parameter  [2:0]
    .pf0_usp_rx_preset_hint9                                                         (pf0_usp_rx_preset_hint9                                                         ), //parameter  [2:0]

    // pf0_sn_cap Attributes
    //------------------------------        -
    .pf0_sn_ser_num_reg_1_dw                                                         (pf0_sn_ser_num_reg_1_dw                                                         ), //parameter  [31:0]
    .pf0_sn_ser_num_reg_2_dw                                                         (pf0_sn_ser_num_reg_2_dw                                                         ), //parameter  [31:0]

    // pf0_pm_cap Attributes
    //------------------------------        -
    .pf0_dsi                                                                         (pf0_dsi                                                                         ), //parameter
    .pf0_aux_curr                                                                    (pf0_aux_curr                                                                    ), //parameter  [2:0]
    .pf0_d1_support                                                                  (pf0_d1_support                                                                  ), //parameter
    .pf0_d2_support                                                                  (pf0_d2_support                                                                  ), //parameter
    .pf0_pme_support                                                                 (pf0_pme_support                                                                 ), //parameter  [4:0]
    .pf0_no_soft_rst                                                                 (pf0_no_soft_rst                                                                 ), //parameter



    // pf0_pcie_cap Attributes
    //------------------------------        -
    .pf0_pcie_slot_imp                                                               (pf0_pcie_slot_imp                                                               ), //parameter
    .pf0_pcie_int_msg_num                                                            (pf0_pcie_int_msg_num                                                            ), //parameter  [4:0]
    .pf0_pcie_cap_ext_tag_en                                                         (pf0_pcie_cap_ext_tag_en                                                         ), //parameter
    .pf0_pcie_cap_ext_tag_supp                                                       (local_pf0_pcie_cap_ext_tag_supp                                                 ), //parameter
    .pf0_pcie_cap_ep_l0s_accpt_latency                                               (pf0_pcie_cap_ep_l0s_accpt_latency                                               ), //parameter  [2:0]
    .pf0_pcie_cap_ep_l1_accpt_latency                                                (pf0_pcie_cap_ep_l1_accpt_latency                                                ), //parameter  [2:0]
    .pf0_pcie_cap_flr_cap                                                            (pf0_pcie_cap_flr_cap                                                            ), //parameter
    .pf0_pcie_cap_initiate_flr                                                       (pf0_pcie_cap_initiate_flr                                                       ), //parameter
    .pf0_pcie_cap_l0s_exit_latency_commclk_dis                                       (pf0_pcie_cap_l0s_exit_latency_commclk_dis                                       ), //parameter  [2:0]
    .pf0_pcie_cap_l1_exit_latency_commclk_dis                                        (pf0_pcie_cap_l1_exit_latency_commclk_dis                                        ), //parameter  [2:0]
    .pf0_pcie_cap_port_num                                                           (pf0_pcie_cap_port_num                                                           ), //parameter  [7:0]
    .pf0_pcie_cap_l0s_exit_latency_commclk_ena_cs2                                   (pf0_pcie_cap_l0s_exit_latency_commclk_ena_cs2                                   ), //parameter  [2:0]
    .pf0_pcie_cap_l1_exit_latency_commclk_ena_cs2                                    (pf0_pcie_cap_l1_exit_latency_commclk_ena_cs2                                    ), //parameter  [2:0]
    .pf0_pcie_cap_rcb                                                                (pf0_pcie_cap_rcb                                                                ), //parameter
    .pf0_pcie_cap_slot_clk_config                                                    (pf0_pcie_cap_slot_clk_config                                                    ), //parameter
    .pf0_pcie_cap_attention_indicator_button                                         (pf0_pcie_cap_attention_indicator_button                                         ), //parameter
    .pf0_pcie_cap_power_controller                                                   (pf0_pcie_cap_power_controller                                                   ), //parameter
    .pf0_pcie_cap_mrl_sensor                                                         (pf0_pcie_cap_mrl_sensor                                                         ), //parameter
    .pf0_pcie_cap_attention_indicator                                                (pf0_pcie_cap_attention_indicator                                                ), //parameter
    .pf0_pcie_cap_power_indicator                                                    (pf0_pcie_cap_power_indicator                                                    ), //parameter
    .pf0_pcie_cap_hot_plug_surprise                                                  (pf0_pcie_cap_hot_plug_surprise                                                  ), //parameter
    .pf0_pcie_cap_hot_plug_capable                                                   (pf0_pcie_cap_hot_plug_capable                                                   ), //parameter
    .pf0_pcie_cap_slot_power_limit_value                                             (pf0_pcie_cap_slot_power_limit_value                                             ), //parameter  [7:0]
    .pf0_pcie_cap_slot_power_limit_scale                                             (pf0_pcie_cap_slot_power_limit_scale                                             ), //parameter  [1:0]
    .pf0_pcie_cap_electromech_interlock                                              (pf0_pcie_cap_electromech_interlock                                              ), //parameter
    .pf0_pcie_cap_no_cmd_cpl_support                                                 (pf0_pcie_cap_no_cmd_cpl_support                                                 ), //parameter
    .pf0_pcie_cap_phy_slot_num                                                       (pf0_pcie_cap_phy_slot_num                                                       ), //parameter  [12:0]
    .pf0_pcie_cap_crs_sw_visibility                                                  (pf0_pcie_cap_crs_sw_visibility                                                  ), //parameter
    .pf0_pcie_cap_sel_deemphasis                                                     (pf0_pcie_cap_sel_deemphasis                                                     ), //parameter

    // pf0_aer_cap Attributes
    //------------------------------        -
    .pf0_adv_err_int_msg_num                                                         (pf0_adv_err_int_msg_num                                                         ), //parameter  [4:0]


    // pf0_tph_cap Attributes
    //------------------------------        -
    .pf0_tph_req_cap_int_vec_vfcomm_cs2                                              (pf0_tph_req_cap_int_vec_vfcomm_cs2                                              ), //parameter
    .pf0_tph_req_device_spec_vfcomm_cs2                                              (pf0_tph_req_device_spec_vfcomm_cs2                                              ), //parameter
    .pf0_tph_req_cap_st_table_loc_0_vfcomm_cs2                                       (pf0_tph_req_cap_st_table_loc_0_vfcomm_cs2                                       ), //parameter
    .pf0_tph_req_cap_st_table_loc_1_vfcomm_cs2                                       (pf0_tph_req_cap_st_table_loc_1_vfcomm_cs2                                       ), //parameter
    .pf0_tph_req_cap_st_table_size_vfcomm_cs2                                        (pf0_tph_req_cap_st_table_size_vfcomm_cs2                                        ), //parameter  [10:0]
    .pf0_tph_req_cap_int_vec                                                         (pf0_tph_req_cap_int_vec                                                         ), //parameter
    .pf0_tph_req_device_spec                                                         (pf0_tph_req_device_spec                                                         ), //parameter
    .pf0_tph_req_cap_st_table_loc_0                                                  (pf0_tph_req_cap_st_table_loc_0                                                  ), //parameter
    .pf0_tph_req_cap_st_table_loc_1                                                  (pf0_tph_req_cap_st_table_loc_1                                                  ), //parameter
    .pf0_tph_req_cap_st_table_size                                                   (pf0_tph_req_cap_st_table_size                                                   ), //parameter  [10:0]

    // pf0_msi_cap Attributes
    //------------------------------        -
    .pf0_pci_msi_multiple_msg_cap                                                    (pf0_pci_msi_multiple_msg_cap                                                    ), //parameter
    .pf0_pci_msi_64_bit_addr_cap                                                     (pf0_pci_msi_64_bit_addr_cap                                                     ), //parameter

    // pf0_msix_cap Attributes
    //------------------------------        -
    .pf0_pci_msix_table_size                                                         (pf0_pci_msix_table_size                                                         ), //parameter  [10:0]
    .pf0_pci_msix_table_size_vfcomm_cs2                                              (pf0_pci_msix_table_size_vfcomm_cs2                                              ), //parameter  [10:0]
    .pf0_pci_msix_bir                                                                (pf0_pci_msix_bir                                                                ), //parameter  [2:0]
    .pf0_pci_msix_table_offset                                                       (pf0_pci_msix_table_offset                                                       ), //parameter  [28:0]
    .pf0_pci_msix_pba                                                                (pf0_pci_msix_pba                                                                ), //parameter  [2:0]
    .pf0_pci_msix_pba_offset                                                         (pf0_pci_msix_pba_offset                                                         ), //parameter  [28:0]

    // pf0_ats_cap Attributes
    //------------------------------        -
    .pf0_invalidate_q_depth                                                          (pf0_invalidate_q_depth                                                          ), //parameter  [4:0]
    .pf0_page_aligned_req                                                            (pf0_page_aligned_req                                                            ), //parameter
    .pf0_global_inval_spprtd                                                         (pf0_global_inval_spprtd                                                         ), //parameter

    // pf0_port_logic Attributes
    //------------------------------        -
    .pf0_fast_link_mode                                                              (pf0_fast_link_mode                                                              ), //parameter
    .pf0_auto_lane_flip_ctrl_en                                                      (pf0_auto_lane_flip_ctrl_en                                                      ), //parameter
    .pf0_config_phy_tx_change                                                        (pf0_config_phy_tx_change                                                        ), //parameter
    .pf0_sel_deemphasis                                                              (pf0_sel_deemphasis                                                              ), //parameter
    .pf0_eq_phase_2_3                                                                (pf0_eq_phase_2_3                                                                ), //parameter
    .pf0_rxeq_ph01_en                                                                (pf0_rxeq_ph01_en                                                                ), //parameter
    .pf0_gen3_eq_phase23_exit_mode                                                   (pf0_gen3_eq_phase23_exit_mode                                                   ), //parameter
    .pf0_gen3_eq_eval_2ms_disable                                                    (pf0_gen3_eq_eval_2ms_disable                                                    ), //parameter
    .pf0_gen3_eq_fmdc_t_min_phase23                                                  (pf0_gen3_eq_fmdc_t_min_phase23                                                  ), //parameter  [4:0]


    // pf1_type0_hdr Attributes
    //------------------------------        -
    .pf1_pci_type0_vendor_id                                                         (pf1_pci_type0_vendor_id                                                         ), //parameter  [15:0]
    .pf1_pci_type0_device_id                                                         (pf1_pci_type0_device_id                                                         ), //parameter  [15:0]
    .pf1_program_interface                                                           (pf1_program_interface                                                           ), //parameter  [7:0]
    .pf1_subclass_code                                                               (pf1_subclass_code                                                               ), //parameter  [7:0]
    .pf1_base_class_code                                                             (pf1_base_class_code                                                             ), //parameter  [7:0]
    .pf1_pci_type0_bar1_enabled                                                      (pf1_pci_type0_bar1_enabled                                                      ), //parameter
    .pf1_pci_type0_bar3_enabled                                                      (pf1_pci_type0_bar3_enabled                                                      ), //parameter
    .pf1_pci_type0_bar5_enabled                                                      (pf1_pci_type0_bar5_enabled                                                      ), //parameter
    .pf1_pci_type0_bar0_enabled                                                      (pf1_pci_type0_bar0_enabled                                                      ), //parameter
    .pf1_bar0_type                                                                   (pf1_bar0_type                                                                   ), //parameter
    .pf1_bar0_prefetch                                                               (pf1_bar0_prefetch                                                               ), //parameter
    .pf1_pci_type0_bar2_enabled                                                      (pf1_pci_type0_bar2_enabled                                                      ), //parameter
    .pf1_bar2_type                                                                   (pf1_bar2_type                                                                   ), //parameter
    .pf1_bar2_prefetch                                                               (pf1_bar2_prefetch                                                               ), //parameter
    .pf1_pci_type0_bar4_enabled                                                      (pf1_pci_type0_bar4_enabled                                                      ), //parameter
    .pf1_bar4_type                                                                   (pf1_bar4_type                                                                   ), //parameter
    .pf1_bar4_prefetch                                                               (pf1_bar4_prefetch                                                               ), //parameter
    .pf1_cardbus_cis_pointer                                                         (pf1_cardbus_cis_pointer                                                         ), //parameter  [31:0]
    .pf1_subsys_vendor_id                                                            (pf1_subsys_vendor_id                                                            ), //parameter  [15:0]
    .pf1_subsys_dev_id                                                               (pf1_subsys_dev_id                                                               ), //parameter  [15:0]
    .pf1_rom_bar_enable                                                              (pf1_rom_bar_enable                                                              ), //parameter
    .pf1_rom_bar_enabled                                                             (pf1_rom_bar_enabled                                                             ), //parameter
    .pf1_int_pin                                                                     (pf1_int_pin                                                                     ), //parameter
    .pf1_bar0_address_width_mux_hwtcl                                                (pf1_bar0_address_width_mux_hwtcl                                                ), //parameter
    .pf1_bar1_address_width_mux_hwtcl                                                (pf1_bar1_address_width_mux_hwtcl                                                ), //parameter
    .pf1_bar2_address_width_mux_hwtcl                                                (pf1_bar2_address_width_mux_hwtcl                                                ), //parameter
    .pf1_bar3_address_width_mux_hwtcl                                                (pf1_bar3_address_width_mux_hwtcl                                                ), //parameter
    .pf1_bar4_address_width_mux_hwtcl                                                (pf1_bar4_address_width_mux_hwtcl                                                ), //parameter
    .pf1_bar5_address_width_mux_hwtcl                                                (pf1_bar5_address_width_mux_hwtcl                                                ), //parameter
    .pf1_expansion_base_address_register_hwtcl                                       (pf1_expansion_base_address_register_hwtcl                                       ), //parameter

    // pf1_sriov_cap Attributes
    //------------------------------        -
    .pf1_shadow_sriov_vf_stride_ari_cs2                                              (pf1_shadow_sriov_vf_stride_ari_cs2                                              ), //parameter  [15:0]
    .pf1_sriov_vf_offset_ari_cs2                                                     (pf1_sriov_vf_offset_ari_cs2                                                     ), //parameter  [15:0]
    .pf1_sriov_vf_offset_position_nonari                                             (pf1_sriov_vf_offset_position_nonari                                             ), //parameter  [15:0]
    .pf1_sriov_vf_stride_nonari                                                      (pf1_sriov_vf_stride_nonari                                                      ), //parameter  [15:0]
    .pf1_sriov_vf_device_id                                                          (pf1_sriov_vf_device_id                                                          ), //parameter  [15:0]
    .pf1_sriov_sup_page_size                                                         (pf1_sriov_sup_page_size                                                         ), //parameter  [31:0]
    .pf1_sriov_vf_bar0_mask                                                          (pf1_sriov_vf_bar0_mask                                                          ), //parameter  [31:0]
    .pf1_sriov_vf_bar0_type                                                          (pf1_sriov_vf_bar0_type                                                          ), //parameter
    .pf1_sriov_vf_bar0_prefetch                                                      (pf1_sriov_vf_bar0_prefetch                                                      ), //parameter
    .pf1_sriov_vf_bar1_mask                                                          (pf1_sriov_vf_bar1_mask                                                          ), //parameter  [31:0]
    .pf1_sriov_vf_bar2_mask                                                          (pf1_sriov_vf_bar2_mask                                                          ), //parameter  [31:0]
    .pf1_sriov_vf_bar2_type                                                          (pf1_sriov_vf_bar2_type                                                          ), //parameter
    .pf1_sriov_vf_bar2_prefetch                                                      (pf1_sriov_vf_bar2_prefetch                                                      ), //parameter
    .pf1_sriov_vf_bar3_mask                                                          (pf1_sriov_vf_bar3_mask                                                          ), //parameter  [31:0]
    .pf1_sriov_vf_bar4_mask                                                          (pf1_sriov_vf_bar4_mask                                                          ), //parameter  [31:0]
    .pf1_sriov_vf_bar4_type                                                          (pf1_sriov_vf_bar4_type                                                          ), //parameter
    .pf1_sriov_vf_bar4_prefetch                                                      (pf1_sriov_vf_bar4_prefetch                                                      ), //parameter
    .pf1_sriov_vf_bar5_mask                                                          (pf1_sriov_vf_bar5_mask                                                          ), //parameter  [31:0]


    // pf1_sn_cap Attributes
    //------------------------------        -
    .pf1_sn_ser_num_reg_2_dw                                                         (pf1_sn_ser_num_reg_2_dw                                                         ), //parameter  [31:0]
    .pf1_sn_ser_num_reg_1_dw                                                         (pf1_sn_ser_num_reg_1_dw                                                         ), //parameter  [31:0]

    // pf1_pm_cap Attributes
    //------------------------------        -
    .pf1_dsi                                                                         (pf1_dsi                                                                         ), //parameter
    .pf1_aux_curr                                                                    (pf1_aux_curr                                                                    ), //parameter  [2:0]
    .pf1_d1_support                                                                  (pf1_d1_support                                                                  ), //parameter
    .pf1_d2_support                                                                  (pf1_d2_support                                                                  ), //parameter
    .pf1_pme_support                                                                 (pf1_pme_support                                                                 ), //parameter  [4:0]
    .pf1_no_soft_rst                                                                 (pf1_no_soft_rst                                                                 ), //parameter

    // pf1_pcie_cap Attributes
    //------------------------------        -
    .pf1_pcie_slot_imp                                                               (pf1_pcie_slot_imp                                                               ), //parameter
    .pf1_pcie_int_msg_num                                                            (pf1_pcie_int_msg_num                                                            ), //parameter  [4:0]
    .pf1_pcie_cap_ext_tag_en                                                         (pf1_pcie_cap_ext_tag_en                                                         ), //parameter
    .pf1_pcie_cap_ext_tag_supp                                                       (pf1_pcie_cap_ext_tag_supp                                                       ), //parameter
    .pf1_pcie_cap_ep_l0s_accpt_latency                                               (pf1_pcie_cap_ep_l0s_accpt_latency                                               ), //parameter  [2:0]
    .pf1_pcie_cap_ep_l1_accpt_latency                                                (pf1_pcie_cap_ep_l1_accpt_latency                                                ), //parameter  [2:0]
    .pf1_pcie_cap_flr_cap                                                            (pf1_pcie_cap_flr_cap                                                            ), //parameter
    .pf1_pcie_cap_active_state_link_pm_support                                       (pf1_pcie_cap_active_state_link_pm_support                                       ), //parameter
    .pf1_pcie_cap_l0s_exit_latency_commclk_dis                                       (pf1_pcie_cap_l0s_exit_latency_commclk_dis                                       ), //parameter  [2:0]
    .pf1_pcie_cap_initiate_flr                                                       (pf1_pcie_cap_initiate_flr                                                       ), //parameter
    .pf1_pcie_cap_l1_exit_latency_commclk_dis                                        (pf1_pcie_cap_l1_exit_latency_commclk_dis                                        ), //parameter  [2:0]
    .pf1_pcie_cap_aux_power_pm_en                                                    (pf1_pcie_cap_aux_power_pm_en                                                    ), //parameter
    .pf1_pcie_cap_clock_power_man                                                    (pf1_pcie_cap_clock_power_man                                                    ), //parameter
    .pf1_pcie_cap_port_num                                                           (pf1_pcie_cap_port_num                                                           ), //parameter  [7:0]
    .pf1_pcie_cap_l0s_exit_latency_commclk_ena_cs2                                   (pf1_pcie_cap_l0s_exit_latency_commclk_ena_cs2                                   ), //parameter  [2:0]
    .pf1_pcie_cap_l1_exit_latency_commclk_ena_cs2                                    (pf1_pcie_cap_l1_exit_latency_commclk_ena_cs2                                    ), //parameter  [2:0]
    .pf1_pcie_cap_rcb                                                                (pf1_pcie_cap_rcb                                                                ), //parameter
    .pf1_pcie_cap_slot_clk_config                                                    (pf1_pcie_cap_slot_clk_config                                                    ), //parameter
    .pf1_pcie_cap_sel_deemphasis                                                     (pf1_pcie_cap_sel_deemphasis                                                     ), //parameter

    // pf1_tph_cap Attributes
    //------------------------------        -
    .pf1_tph_req_cap_int_vec_vfcomm_cs2                                              (pf1_tph_req_cap_int_vec_vfcomm_cs2                                              ), //parameter
    .pf1_tph_req_device_spec_vfcomm_cs2                                              (pf1_tph_req_device_spec_vfcomm_cs2                                              ), //parameter
    .pf1_tph_req_cap_st_table_loc_0_vfcomm_cs2                                       (pf1_tph_req_cap_st_table_loc_0_vfcomm_cs2                                       ), //parameter
    .pf1_tph_req_cap_st_table_loc_1_vfcomm_cs2                                       (pf1_tph_req_cap_st_table_loc_1_vfcomm_cs2                                       ), //parameter
    .pf1_tph_req_cap_st_table_size_vfcomm_cs2                                        (pf1_tph_req_cap_st_table_size_vfcomm_cs2                                        ), //parameter  [10:0]
    .pf1_tph_req_cap_int_vec                                                         (pf1_tph_req_cap_int_vec                                                         ), //parameter
    .pf1_tph_req_device_spec                                                         (pf1_tph_req_device_spec                                                         ), //parameter
    .pf1_tph_req_cap_st_table_loc_0                                                  (pf1_tph_req_cap_st_table_loc_0                                                  ), //parameter
    .pf1_tph_req_cap_st_table_loc_1                                                  (pf1_tph_req_cap_st_table_loc_1                                                  ), //parameter
    .pf1_tph_req_cap_st_table_size                                                   (pf1_tph_req_cap_st_table_size                                                   ), //parameter  [10:0]

    // pf1_msi_cap Attributes
    //------------------------------        -
    .pf1_pci_msi_multiple_msg_cap                                                    (pf1_pci_msi_multiple_msg_cap                                                    ), //parameter
    .pf1_pci_msi_64_bit_addr_cap                                                     (pf1_pci_msi_64_bit_addr_cap                                                     ), //parameter

    // pf1_msix_cap Attributes
    //------------------------------        -
    .pf1_pci_msix_table_size                                                         (pf1_pci_msix_table_size                                                         ), //parameter  [10:0]
    .pf1_pci_msix_table_size_vfcomm_cs2                                              (pf1_pci_msix_table_size_vfcomm_cs2                                              ), //parameter  [10:0]
    .pf1_pci_msix_bir                                                                (pf1_pci_msix_bir                                                                ), //parameter  [2:0]
    .pf1_pci_msix_table_offset                                                       (pf1_pci_msix_table_offset                                                       ), //parameter  [28:0]
    .pf1_pci_msix_pba                                                                (pf1_pci_msix_pba                                                                ), //parameter  [2:0]
    .pf1_pci_msix_pba_offset                                                         (pf1_pci_msix_pba_offset                                                         ), //parameter  [28:0]

    // pf1_ats_cap Attributes
    //------------------------------        -
    .pf1_invalidate_q_depth                                                          (pf1_invalidate_q_depth                                                          ), //parameter  [4:0]
    .pf1_page_aligned_req                                                            (pf1_page_aligned_req                                                            ), //parameter
    .pf1_global_inval_spprtd                                                         (pf1_global_inval_spprtd                                                         ), //parameter

    // vf1_pf0_pcie_cap Attributes
    //------------------------------        -
    .vf1_pf0_shadow_pcie_cap_clock_power_man                                         (vf1_pf0_shadow_pcie_cap_clock_power_man                                         ), //parameter
    // vf1_pf1_pcie_cap Attributes
    //------------------------------        -
    .vf1_pf1_shadow_pcie_cap_clock_power_man                                         (vf1_pf1_shadow_pcie_cap_clock_power_man                                         ), //parameter

    //Derived Parameters

    .pf0_msix_cap_msix_table_offset_reg_addr_byte2                                   (pf0_msix_cap_msix_table_offset_reg_addr_byte2                                   ), //parameter  [23:0]
    .vf_dbi_reserved_3                                                               (vf_dbi_reserved_3                                                               ), //parameter  [7:0]
    .pf1_tph_req_no_st_mode_vfcomm_cs2                                               (pf1_tph_req_no_st_mode_vfcomm_cs2                                               ), //parameter
    .pf1_vf_bar1_reg_rsvdp_0                                                         (pf1_vf_bar1_reg_rsvdp_0                                                         ), //parameter
    .pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte3                                     (pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte3                                     ), //parameter  [23:0]
    .pf0_msix_cap_msix_table_offset_reg_addr_byte3                                   (pf0_msix_cap_msix_table_offset_reg_addr_byte3                                   ), //parameter  [23:0]
    .pf0_type0_hdr_bar3_mask_reg_addr_byte0                                          (pf0_type0_hdr_bar3_mask_reg_addr_byte0                                          ), //parameter  [23:0]
    .pf0_gen3_eq_fmdc_max_pre_cusror_delta                                           (pf0_gen3_eq_fmdc_max_pre_cusror_delta                                           ), //parameter  [3:0]
    .pf0_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvdp_31                         (pf0_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvdp_31                         ), //parameter
    .pf0_dsp_rx_preset_hint8                                                         (pf0_dsp_rx_preset_hint8                                                         ), //parameter  [2:0]
    .pf0_pci_msi_multiple_msg_en                                                     (pf0_pci_msi_multiple_msg_en                                                     ), //parameter  [2:0]
    .pf0_dbi_reserved_40                                                             (pf0_dbi_reserved_40                                                             ), //parameter  [7:0]
    .ecc_chk_val                                                                     (ecc_chk_val                                                                     ), //parameter
    .pf0_multi_func                                                                  (pf0_multi_func                                                                  ), //parameter
    .clock_ctl_rsvd_3                                                                (clock_ctl_rsvd_3                                                                ), //parameter
    .cfg_vf_num_pf1                                                                  (cfg_vf_num_pf1                                                                  ), //parameter  [7:0]
    .vf1_pf1_shadow_pcie_cap_surprise_down_err_rep_cap                               (vf1_pf1_shadow_pcie_cap_surprise_down_err_rep_cap                               ), //parameter
    .clkmod_hip_clk_dis                                                              (clkmod_hip_clk_dis                                                              ), //parameter
    .pf0_reserved_29_addr                                                            (pf0_reserved_29_addr                                                            ), //parameter  [23:0]
    .pf1_type0_hdr_bar2_mask_reg_addr_byte3                                          (pf1_type0_hdr_bar2_mask_reg_addr_byte3                                          ), //parameter  [23:0]
    .pf0_vc_cap_vc_base_addr_byte3                                                   (pf0_vc_cap_vc_base_addr_byte3                                                   ), //parameter  [23:0]
    .pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte2                        (pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte2                        ), //parameter  [23:0]
    .pf0_port_logic_vc0_p_rx_q_ctrl_off_addr_byte2                                   (pf0_port_logic_vc0_p_rx_q_ctrl_off_addr_byte2                                   ), //parameter  [23:0]
    .pf0_bar4_mem_io                                                                 (pf0_bar4_mem_io                                                                 ), //parameter
    .pf1_pcie_cap_link_control2_link_status2_reg_addr_byte0                          (pf1_pcie_cap_link_control2_link_status2_reg_addr_byte0                          ), //parameter  [23:0]
    .pf1_pcie_cap_shadow_link_capabilities_reg_addr_byte1                            (pf1_pcie_cap_shadow_link_capabilities_reg_addr_byte1                            ), //parameter  [23:0]
    .pf0_pcie_cap_root_control_root_capabilities_reg_addr_byte2                      (pf0_pcie_cap_root_control_root_capabilities_reg_addr_byte2                      ), //parameter  [23:0]
    .pf0_spcie_next_offset                                                           (pf0_spcie_next_offset                                                           ), //parameter  [11:0]
    .pf0_reserved_26_addr                                                            (pf0_reserved_26_addr                                                            ), //parameter  [23:0]
    .pf1_aer_cap_version                                                             (pf1_aer_cap_version                                                             ), //parameter  [3:0]
    .hrc_rstctl_timer_value_g                                                        (hrc_rstctl_timer_value_g                                                        ), //parameter  [7:0]
    .pf0_con_status_reg_rsvdp_2                                                      (pf0_con_status_reg_rsvdp_2                                                      ), //parameter
    .virtual_pf1_pb_cap_enable                                                       (virtual_pf1_pb_cap_enable                                                       ), //parameter
    .pf0_dbi_reserved_20                                                             (pf0_dbi_reserved_20                                                             ), //parameter  [7:0]
    .pf0_type0_hdr_bar1_mask_reg_addr_byte2                                          (pf0_type0_hdr_bar1_mask_reg_addr_byte2                                          ), //parameter  [23:0]
    .pf1_pcie_cap_retrain_link                                                       (pf1_pcie_cap_retrain_link                                                       ), //parameter
    .pf0_port_logic_gen3_eq_control_off_addr_byte1                                   (pf0_port_logic_gen3_eq_control_off_addr_byte1                                   ), //parameter  [23:0]
    .pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte3                                     (pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte3                                     ), //parameter  [23:0]
    .pf1_reserved_9_addr                                                             (pf1_reserved_9_addr                                                             ), //parameter  [23:0]
    .pf0_sn_cap_ser_num_reg_dw_1_addr_byte0                                          (pf0_sn_cap_ser_num_reg_dw_1_addr_byte0                                          ), //parameter  [23:0]
    .pf1_pm_next_pointer                                                             (pf1_pm_next_pointer                                                             ), //parameter  [7:0]
    .pf0_pcie_cap_target_link_speed                                                  (pf0_pcie_cap_target_link_speed                                                  ), //parameter
    .pf0_type0_hdr_bar4_mask_reg_addr_byte0                                          (pf0_type0_hdr_bar4_mask_reg_addr_byte0                                          ), //parameter  [23:0]
    .pf0_reserved_11_addr                                                            (pf0_reserved_11_addr                                                            ), //parameter  [23:0]
    .pf0_aux_clk_freq                                                                (pf0_aux_clk_freq                                                                ), //parameter  [9:0]
    .pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte0                      (pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte0                      ), //parameter  [23:0]
    .hrc_rx_pcs_rst_n_active                                                         (hrc_rx_pcs_rst_n_active                                                         ), //parameter
    .pf0_pcie_cap_max_link_width                                                     (pf0_pcie_cap_max_link_width                                                     ), //parameter
    .pf1_tph_cap_tph_req_cap_reg_addr_byte2                                          (pf1_tph_cap_tph_req_cap_reg_addr_byte2                                          ), //parameter  [23:0]
    .cfg_dbi_pf1_tablesize                                                           (cfg_dbi_pf1_tablesize                                                           ), //parameter  [8:0]
    .pf1_bar0_mem_io                                                                 (pf1_bar0_mem_io                                                                 ), //parameter
    .pf0_gen3_eq_pset_req_as_coef                                                    (pf0_gen3_eq_pset_req_as_coef                                                    ), //parameter
    .pf0_port_logic_vc0_cpl_rx_q_ctrl_off_addr_byte2                                 (pf0_port_logic_vc0_cpl_rx_q_ctrl_off_addr_byte2                                 ), //parameter  [23:0]
    .pf1_revision_id                                                                 (pf1_revision_id                                                                 ), //parameter  [7:0]
    .pf0_root_err_status_off_rsvdp_7                                                 (pf0_root_err_status_off_rsvdp_7                                                 ), //parameter  [2:0]
    .pf0_sriov_cap_vf_bar4_reg_addr_byte0                                            (pf0_sriov_cap_vf_bar4_reg_addr_byte0                                            ), //parameter  [23:0]
    .pf0_gen3_eq_control_off_rsvdp_26                                                (pf0_gen3_eq_control_off_rsvdp_26                                                ), //parameter  [5:0]
    .pf0_dbi_reserved_33                                                             (pf0_dbi_reserved_33                                                             ), //parameter  [7:0]
    .pf1_pcie_cap_link_control_link_status_reg_addr_byte0                            (pf1_pcie_cap_link_control_link_status_reg_addr_byte0                            ), //parameter  [23:0]
    .pf0_lane_equalization_control1213_reg_rsvdp_15                                  (pf0_lane_equalization_control1213_reg_rsvdp_15                                  ), //parameter
    .pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte1                                    (pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte1                                    ), //parameter  [23:0]
    .pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte2                        (pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte2                        ), //parameter  [23:0]
    .pf0_reserved_12_addr                                                            (pf0_reserved_12_addr                                                            ), //parameter  [23:0]
    .pf0_direct_speed_change                                                         (pf0_direct_speed_change                                                         ), //parameter
    .pf0_dbi_reserved_5                                                              (pf0_dbi_reserved_5                                                              ), //parameter  [7:0]
    .pf0_port_logic_port_force_off_addr_byte0                                        (pf0_port_logic_port_force_off_addr_byte0                                        ), //parameter  [23:0]
    .vf1_pf1_ari_cap_vf_ari_base_addr_byte2                                          (vf1_pf1_ari_cap_vf_ari_base_addr_byte2                                          ), //parameter  [23:0]
    .pf0_forward_user_vsec                                                           (pf0_forward_user_vsec                                                           ), //parameter
    .pf0_bar3_prefetch                                                               (pf0_bar3_prefetch                                                               ), //parameter
    .pf0_reserved_43_addr                                                            (pf0_reserved_43_addr                                                            ), //parameter  [23:0]
    .pf0_msix_cap_msix_table_offset_reg_addr_byte1                                   (pf0_msix_cap_msix_table_offset_reg_addr_byte1                                   ), //parameter  [23:0]
    .pf1_bar3_start                                                                  (pf1_bar3_start                                                                  ), //parameter  [3:0]
    .pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte2                               (pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte2                               ), //parameter  [23:0]
    .pf0_ats_cap_version                                                             (pf0_ats_cap_version                                                             ), //parameter  [3:0]
    .pf1_type0_hdr_bar5_mask_reg_addr_byte3                                          (pf1_type0_hdr_bar5_mask_reg_addr_byte3                                          ), //parameter  [23:0]
    .pf0_sriov_cap_vf_bar2_reg_addr_byte0                                            (pf0_sriov_cap_vf_bar2_reg_addr_byte0                                            ), //parameter  [23:0]
    .vf1_pf0_ari_cap_vf_ari_base_addr_byte2                                          (vf1_pf0_ari_cap_vf_ari_base_addr_byte2                                          ), //parameter  [23:0]
    .hrc_rx_pma_rstb_active                                                          (hrc_rx_pma_rstb_active                                                          ), //parameter
    .pf1_reserved_7_addr                                                             (pf1_reserved_7_addr                                                             ), //parameter  [23:0]
    .pf0_pcie_cap_active_state_link_pm_control                                       (pf0_pcie_cap_active_state_link_pm_control                                       ), //parameter
    .pf1_pm_cap_con_status_reg_addr_byte0                                            (pf1_pm_cap_con_status_reg_addr_byte0                                            ), //parameter  [23:0]
    .pf1_pci_type0_bar3_enabled_or_mask64lsb                                         (pf1_pci_type0_bar3_enabled_or_mask64lsb                                         ), //parameter
    .pf0_pci_type0_bar5_enabled_or_mask64lsb                                         (pf0_pci_type0_bar5_enabled_or_mask64lsb                                         ), //parameter
    .pf1_pcie_cap_max_link_width                                                     (pf1_pcie_cap_max_link_width                                                     ), //parameter
    .pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte1                               (pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte1                               ), //parameter  [23:0]
    .pf0_sriov_vf_bar2_start                                                         (pf0_sriov_vf_bar2_start                                                         ), //parameter  [3:0]
    .pf0_gen3_eq_control_off_rsvdp_6                                                 (pf0_gen3_eq_control_off_rsvdp_6                                                 ), //parameter  [1:0]
    .pf0_gen3_eq_fb_mode_dir_change_off_rsvdp_18                                     (pf0_gen3_eq_fb_mode_dir_change_off_rsvdp_18                                     ), //parameter  [5:0]
    .pf0_port_logic_misc_control_1_off_addr_byte0                                    (pf0_port_logic_misc_control_1_off_addr_byte0                                    ), //parameter  [23:0]
    .cfg_g3_pset_coeff_10                                                            (cfg_g3_pset_coeff_10                                                            ), //parameter  [17:0]
    .pf1_dbi_reserved_13                                                             (pf1_dbi_reserved_13                                                             ), //parameter  [7:0]
    .vf1_pf0_shadow_pcie_cap_surprise_down_err_rep_cap                               (vf1_pf0_shadow_pcie_cap_surprise_down_err_rep_cap                               ), //parameter
    .pf1_type0_hdr_device_id_vendor_id_reg_addr_byte3                                (pf1_type0_hdr_device_id_vendor_id_reg_addr_byte3                                ), //parameter  [23:0]
    .pf0_port_logic_gen2_ctrl_off_addr_byte2                                         (pf0_port_logic_gen2_ctrl_off_addr_byte2                                         ), //parameter  [23:0]
    .cvp_vsec_id                                                                     (cvp_vsec_id                                                                     ), //parameter  [15:0]
    .pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte3                (pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte3                ), //parameter  [23:0]
    .pf0_reserved_37_addr                                                            (pf0_reserved_37_addr                                                            ), //parameter  [23:0]
    .pf0_reserved_50_addr                                                            (pf0_reserved_50_addr                                                            ), //parameter  [23:0]
    .pf1_bar1_mem_io                                                                 (pf1_bar1_mem_io                                                                 ), //parameter
    .eqctrl_ctle_val                                                                 (eqctrl_ctle_val                                                                 ), //parameter
    .pf0_gen3_dllp_xmt_delay_disable                                                 (pf0_gen3_dllp_xmt_delay_disable                                                 ), //parameter
    .cfg_g3_pset_coeff_1                                                             (cfg_g3_pset_coeff_1                                                             ), //parameter  [17:0]
    .pf1_sriov_vf_bar1_dummy_mask_7_1                                                (pf1_sriov_vf_bar1_dummy_mask_7_1                                                ), //parameter  [6:0]
    .cfg_g3_pset_coeff_7                                                             (cfg_g3_pset_coeff_7                                                             ), //parameter  [17:0]
    .pf0_type0_hdr_class_code_revision_id_addr_byte1                                 (pf0_type0_hdr_class_code_revision_id_addr_byte1                                 ), //parameter  [23:0]
    .pf0_pcie_cap_link_auto_bw_int_en                                                (pf0_pcie_cap_link_auto_bw_int_en                                                ), //parameter
    .pf1_type0_hdr_max_latency_min_grant_interrupt_pin_interrupt_line_reg_addr_byte1 (pf1_type0_hdr_max_latency_min_grant_interrupt_pin_interrupt_line_reg_addr_byte1 ), //parameter  [23:0]
    .pf1_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte1              (pf1_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte1              ), //parameter  [23:0]
    .pf0_port_logic_symbol_timer_filter_1_off_addr_byte0                             (pf0_port_logic_symbol_timer_filter_1_off_addr_byte0                             ), //parameter  [23:0]
    .cvp_mode_default                                                                (cvp_mode_default                                                                ), //parameter
    .vf1_pf0_ari_cap_version                                                         (vf1_pf0_ari_cap_version                                                         ), //parameter  [3:0]
    .pf0_type0_hdr_bar4_mask_reg_addr_byte2                                          (pf0_type0_hdr_bar4_mask_reg_addr_byte2                                          ), //parameter  [23:0]
    .pf0_link_capable                                                                (pf0_link_capable                                                                ), //parameter
    .pf1_sn_cap_ser_num_reg_dw_1_addr_byte1                                          (pf1_sn_cap_ser_num_reg_dw_1_addr_byte1                                          ), //parameter  [23:0]
    .pf0_gen3_zrxdc_noncompl                                                         (pf0_gen3_zrxdc_noncompl                                                         ), //parameter
    .pf0_spcie_cap_lane_equalization_control45_reg_addr_byte1                        (pf0_spcie_cap_lane_equalization_control45_reg_addr_byte1                        ), //parameter  [23:0]
    .pf0_sriov_cap_sriov_vf_offset_position_addr_byte0                               (pf0_sriov_cap_sriov_vf_offset_position_addr_byte0                               ), //parameter  [23:0]
    .pf0_dsp_rx_preset_hint0                                                         (pf0_dsp_rx_preset_hint0                                                         ), //parameter  [2:0]
    .pf1_dbi_reserved_4                                                              (pf1_dbi_reserved_4                                                              ), //parameter  [7:0]
    .pf0_pm_cap_cap_id_nxt_ptr_reg_addr_byte1                                        (pf0_pm_cap_cap_id_nxt_ptr_reg_addr_byte1                                        ), //parameter  [23:0]
    .pf1_sriov_vf_bar5_type                                                          (pf1_sriov_vf_bar5_type                                                          ), //parameter
    .pf0_dbi_reserved_2                                                              (pf0_dbi_reserved_2                                                              ), //parameter  [7:0]
    .pf1_pcie_cap_link_capabilities_reg_addr_byte0                                   (pf1_pcie_cap_link_capabilities_reg_addr_byte0                                   ), //parameter  [23:0]
    .pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte0                                     (pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte0                                     ), //parameter  [23:0]
    .hrc_rstctl_timer_type_i                                                         (hrc_rstctl_timer_type_i                                                         ), //parameter
    .pf1_vf_bar0_reg_rsvdp_0                                                         (pf1_vf_bar0_reg_rsvdp_0                                                         ), //parameter
    .pf0_bar4_start                                                                  (pf0_bar4_start                                                                  ), //parameter  [3:0]
    .pf1_type0_hdr_bar1_mask_reg_addr_byte0                                          (pf1_type0_hdr_bar1_mask_reg_addr_byte0                                          ), //parameter  [23:0]
    .pf0_sriov_vf_bar1_type                                                          (pf0_sriov_vf_bar1_type                                                          ), //parameter
    .pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte2                                     (pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte2                                     ), //parameter  [23:0]
    .hrc_rstctl_timer_type_a                                                         (hrc_rstctl_timer_type_a                                                         ), //parameter
    .pf0_lane_equalization_control45_reg_rsvdp_23                                    (pf0_lane_equalization_control45_reg_rsvdp_23                                    ), //parameter
    .pf0_dbi_reserved_27                                                             (pf0_dbi_reserved_27                                                             ), //parameter  [7:0]
    .pf1_reserved_19_addr                                                            (pf1_reserved_19_addr                                                            ), //parameter  [23:0]
    .pf1_pcie_cap_role_based_err_report                                              (pf1_pcie_cap_role_based_err_report                                              ), //parameter
    .pf1_link_control_link_status_reg_rsvdp_12                                       (pf1_link_control_link_status_reg_rsvdp_12                                       ), //parameter  [3:0]
    .pf0_reserved_34_addr                                                            (pf0_reserved_34_addr                                                            ), //parameter  [23:0]
    .clkmod_gen3_hclk_div_sel                                                        (clkmod_gen3_hclk_div_sel                                                        ), //parameter
    .pf0_ari_next_offset                                                             (pf0_ari_next_offset                                                             ), //parameter  [11:0]
    .pf0_sriov_cap_sriov_bar1_enable_reg_addr_byte0                                  (pf0_sriov_cap_sriov_bar1_enable_reg_addr_byte0                                  ), //parameter  [23:0]
    .pf1_ats_next_offset                                                             (pf1_ats_next_offset                                                             ), //parameter  [11:0]
    .pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte0                        (pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte0                        ), //parameter  [23:0]
    .pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte1                           (pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte1                           ), //parameter  [23:0]
    .pf1_pcie_cap_dll_active_rep_cap                                                 (pf1_pcie_cap_dll_active_rep_cap                                                 ), //parameter
    .pf1_pci_msi_multiple_msg_en                                                     (pf1_pci_msi_multiple_msg_en                                                     ), //parameter  [2:0]
    .pf1_ari_cap_ari_base_addr_byte2                                                 (pf1_ari_cap_ari_base_addr_byte2                                                 ), //parameter  [23:0]
    .pf1_type0_hdr_class_code_revision_id_addr_byte2                                 (pf1_type0_hdr_class_code_revision_id_addr_byte2                                 ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control89_reg_addr_byte3                        (pf0_spcie_cap_lane_equalization_control89_reg_addr_byte3                        ), //parameter  [23:0]
    .pf0_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte1                             (pf0_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte1                             ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte3                      (pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte3                      ), //parameter  [23:0]
    .pf1_ari_cap_version                                                             (pf1_ari_cap_version                                                             ), //parameter  [3:0]
    .pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte2                               (pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte2                               ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control23_reg_addr_byte1                        (pf0_spcie_cap_lane_equalization_control23_reg_addr_byte1                        ), //parameter  [23:0]
    .pf0_bar0_mem_io                                                                 (pf0_bar0_mem_io                                                                 ), //parameter
    .pf0_reserved_38_addr                                                            (pf0_reserved_38_addr                                                            ), //parameter  [23:0]
    .pf0_lane_equalization_control01_reg_rsvdp_31                                    (pf0_lane_equalization_control01_reg_rsvdp_31                                    ), //parameter
    .pf0_power_state                                                                 (pf0_power_state                                                                 ), //parameter  [1:0]
    .pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte1                        (pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte1                        ), //parameter  [23:0]
    .pf1_type0_hdr_bar3_mask_reg_addr_byte1                                          (pf1_type0_hdr_bar3_mask_reg_addr_byte1                                          ), //parameter  [23:0]
    .pf0_tph_req_cap_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                              (pf0_tph_req_cap_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                              ), //parameter  [4:0]
    .pf1_tph_req_cap_reg_rsvdp_11                                                    (pf1_tph_req_cap_reg_rsvdp_11                                                    ), //parameter  [4:0]
    .pf1_pcie_cap_device_control_device_status_addr_byte1                            (pf1_pcie_cap_device_control_device_status_addr_byte1                            ), //parameter  [23:0]
    .pf1_pcie_cap_dll_active                                                         (pf1_pcie_cap_dll_active                                                         ), //parameter
    .pf0_port_logic_gen3_eq_control_off_addr_byte0                                   (pf0_port_logic_gen3_eq_control_off_addr_byte0                                   ), //parameter  [23:0]
    .cfg_blk_crs_en                                                                  (cfg_blk_crs_en                                                                  ), //parameter
    .pf0_dbi_reserved_46                                                             (pf0_dbi_reserved_46                                                             ), //parameter  [7:0]
    .pf0_tph_req_cap_reg_rsvdp_3                                                     (pf0_tph_req_cap_reg_rsvdp_3                                                     ), //parameter  [4:0]
    .pf0_sriov_vf_bar3_start                                                         (pf0_sriov_vf_bar3_start                                                         ), //parameter  [3:0]
    .aux_warm_reset_ctl                                                              (aux_warm_reset_ctl                                                              ), //parameter
    .adp_bypass                                                                      (adp_bypass                                                                      ), //parameter
    .pf1_bar3_prefetch                                                               (pf1_bar3_prefetch                                                               ), //parameter
    .pf0_aer_next_offset                                                             (pf0_aer_next_offset                                                             ), //parameter  [11:0]
    .pld_tx_fifo_empty_threshold_3                                                   (pld_tx_fifo_empty_threshold_3                                                   ), //parameter  [4:0]
    .pf1_pcie_cap_link_disable                                                       (pf1_pcie_cap_link_disable                                                       ), //parameter
    .pf1_sriov_cap_sriov_vf_offset_position_addr_byte0                               (pf1_sriov_cap_sriov_vf_offset_position_addr_byte0                               ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control45_reg_addr_byte3                        (pf0_spcie_cap_lane_equalization_control45_reg_addr_byte3                        ), //parameter  [23:0]
    .virtual_pf0_pb_cap_enable                                                       (virtual_pf0_pb_cap_enable                                                       ), //parameter
    .pf1_dbi_reserved_14                                                             (pf1_dbi_reserved_14                                                             ), //parameter  [7:0]
    .pf1_cap_id_nxt_ptr_reg_rsvdp_20                                                 (pf1_cap_id_nxt_ptr_reg_rsvdp_20                                                 ), //parameter
    .pf1_sn_cap_sn_base_addr_byte2                                                   (pf1_sn_cap_sn_base_addr_byte2                                                   ), //parameter  [23:0]
    .pf0_type0_hdr_bist_header_type_latency_cache_line_size_reg_addr_byte2           (pf0_type0_hdr_bist_header_type_latency_cache_line_size_reg_addr_byte2           ), //parameter  [23:0]
    .pf0_reserved_25_addr                                                            (pf0_reserved_25_addr                                                            ), //parameter  [23:0]
    .pf0_reserved_8_addr                                                             (pf0_reserved_8_addr                                                             ), //parameter  [23:0]
    .pf0_port_logic_vc0_p_rx_q_ctrl_off_addr_byte0                                   (pf0_port_logic_vc0_p_rx_q_ctrl_off_addr_byte0                                   ), //parameter  [23:0]
    .pf1_type0_hdr_bar4_mask_reg_addr_byte1                                          (pf1_type0_hdr_bar4_mask_reg_addr_byte1                                          ), //parameter  [23:0]
    .pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte2                                   (pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte2                                   ), //parameter  [23:0]
    .pf0_dbi_reserved_4                                                              (pf0_dbi_reserved_4                                                              ), //parameter  [7:0]
    .pf0_vc_next_offset                                                              (pf0_vc_next_offset                                                              ), //parameter  [11:0]
    .pf0_sriov_cap_vf_bar0_reg_addr_byte0                                            (pf0_sriov_cap_vf_bar0_reg_addr_byte0                                            ), //parameter  [23:0]
    .pf0_port_logic_port_link_ctrl_off_addr_byte0                                    (pf0_port_logic_port_link_ctrl_off_addr_byte0                                    ), //parameter  [23:0]
    .pf0_sn_next_offset                                                              (pf0_sn_next_offset                                                              ), //parameter  [11:0]
    .pf0_dbi_reserved_1                                                              (pf0_dbi_reserved_1                                                              ), //parameter  [7:0]
    .pf1_pcie_cap_device_capabilities_reg_addr_byte0                                 (pf1_pcie_cap_device_capabilities_reg_addr_byte0                                 ), //parameter  [23:0]
    .pf0_ats_cap_ats_capabilities_ctrl_reg_addr_byte0                                (pf0_ats_cap_ats_capabilities_ctrl_reg_addr_byte0                                ), //parameter  [23:0]
    .pf1_header_type                                                                 (pf1_header_type                                                                 ), //parameter  [6:0]
    .pf0_reserved_41_addr                                                            (pf0_reserved_41_addr                                                            ), //parameter  [23:0]
    .pf0_sriov_vf_bar4_start                                                         (pf0_sriov_vf_bar4_start                                                         ), //parameter  [3:0]
    .pf0_lane_equalization_control1415_reg_rsvdp_31                                  (pf0_lane_equalization_control1415_reg_rsvdp_31                                  ), //parameter
    .pf0_bar1_mem_io                                                                 (pf0_bar1_mem_io                                                                 ), //parameter
    .pf0_type0_hdr_bar5_reg_addr_byte0                                               (pf0_type0_hdr_bar5_reg_addr_byte0                                               ), //parameter  [23:0]
    .pf1_pci_msix_cap_id_next_ctrl_reg_rsvdp_27                                      (pf1_pci_msix_cap_id_next_ctrl_reg_rsvdp_27                                      ), //parameter  [2:0]
    .pf0_dsp_rx_preset_hint3                                                         (pf0_dsp_rx_preset_hint3                                                         ), //parameter  [2:0]
    .cfg_g3_pset_coeff_9                                                             (cfg_g3_pset_coeff_9                                                             ), //parameter  [17:0]
    .pf0_dbi_reserved_45                                                             (pf0_dbi_reserved_45                                                             ), //parameter  [7:0]
    .pf0_reserved_14_addr                                                            (pf0_reserved_14_addr                                                            ), //parameter  [23:0]
    .pf1_pcie_cap_link_capabilities_reg_addr_byte2                                   (pf1_pcie_cap_link_capabilities_reg_addr_byte2                                   ), //parameter  [23:0]
    .pf1_shadow_pcie_cap_active_state_link_pm_support                                (pf1_shadow_pcie_cap_active_state_link_pm_support                                ), //parameter  [1:0]
    .pf1_pci_type0_bar1_dummy_mask_7_1                                               (pf1_pci_type0_bar1_dummy_mask_7_1                                               ), //parameter  [6:0]
    .pf0_eq_redo                                                                     (pf0_eq_redo                                                                     ), //parameter
    .pf0_pci_type0_bar1_enabled_or_mask64lsb                                         (pf0_pci_type0_bar1_enabled_or_mask64lsb                                         ), //parameter
    .pf0_dbi_reserved_56                                                             (pf0_dbi_reserved_56                                                             ), //parameter  [7:0]
    .pf0_pcie_cap_link_auto_bw_status                                                (pf0_pcie_cap_link_auto_bw_status                                                ), //parameter
    .pf1_tph_req_no_st_mode                                                          (pf1_tph_req_no_st_mode                                                          ), //parameter
    .pf0_reserved_48_addr                                                            (pf0_reserved_48_addr                                                            ), //parameter  [23:0]
    .pf0_port_logic_timer_ctrl_max_func_num_off_addr_byte0                           (pf0_port_logic_timer_ctrl_max_func_num_off_addr_byte0                           ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte1                      (pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte1                      ), //parameter  [23:0]
    .pf0_type0_hdr_bar4_mask_reg_addr_byte3                                          (pf0_type0_hdr_bar4_mask_reg_addr_byte3                                          ), //parameter  [23:0]
    .pf0_reserved_23_addr                                                            (pf0_reserved_23_addr                                                            ), //parameter  [23:0]
    .pf0_sriov_vf_bar5_dummy_mask_7_1                                                (pf0_sriov_vf_bar5_dummy_mask_7_1                                                ), //parameter  [6:0]
    .pf1_con_status_reg_rsvdp_4                                                      (pf1_con_status_reg_rsvdp_4                                                      ), //parameter  [3:0]
    .vf1_pf1_tph_req_next_ptr                                                        (vf1_pf1_tph_req_next_ptr                                                        ), //parameter  [11:0]
    .pf1_msix_cap_msix_pba_offset_reg_addr_byte2                                     (pf1_msix_cap_msix_pba_offset_reg_addr_byte2                                     ), //parameter  [23:0]
    .pf0_type0_hdr_bar3_reg_addr_byte0                                               (pf0_type0_hdr_bar3_reg_addr_byte0                                               ), //parameter  [23:0]
    .pf0_pci_type0_bar5_dummy_mask_7_1                                               (pf0_pci_type0_bar5_dummy_mask_7_1                                               ), //parameter  [6:0]
    .pf0_dbi_reserved_18                                                             (pf0_dbi_reserved_18                                                             ), //parameter  [7:0]
    .pf0_type0_hdr_exp_rom_base_addr_reg_addr_byte0                                  (pf0_type0_hdr_exp_rom_base_addr_reg_addr_byte0                                  ), //parameter  [23:0]
    .pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte0                                   (pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte0                                   ), //parameter  [23:0]
    .pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte3                               (pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte3                               ), //parameter  [23:0]
    .pf0_bar2_mem_io                                                                 (pf0_bar2_mem_io                                                                 ), //parameter
    .pf0_vf_bar5_reg_rsvdp_0                                                         (pf0_vf_bar5_reg_rsvdp_0                                                         ), //parameter
    .pf0_lane_equalization_control1011_reg_rsvdp_7                                   (pf0_lane_equalization_control1011_reg_rsvdp_7                                   ), //parameter
    .pf1_type0_hdr_bar0_mask_reg_addr_byte0                                          (pf1_type0_hdr_bar0_mask_reg_addr_byte0                                          ), //parameter  [23:0]
    .pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte0                                     (pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte0                                     ), //parameter  [23:0]
    .pf1_vf_bar4_reg_rsvdp_0                                                         (pf1_vf_bar4_reg_rsvdp_0                                                         ), //parameter
    .pf0_rxstatus_value                                                              (pf0_rxstatus_value                                                              ), //parameter  [2:0]
    .pf1_sriov_cap_vf_bar4_reg_addr_byte0                                            (pf1_sriov_cap_vf_bar4_reg_addr_byte0                                            ), //parameter  [23:0]
    .pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte1                                     (pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte1                                     ), //parameter  [23:0]
    .pf1_shadow_pcie_cap_link_bw_not_cap                                             (pf1_shadow_pcie_cap_link_bw_not_cap                                             ), //parameter
    .pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte2                                     (pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte2                                     ), //parameter  [23:0]
    .pf0_port_logic_gen3_eq_fb_mode_dir_change_off_addr_byte1                        (pf0_port_logic_gen3_eq_fb_mode_dir_change_off_addr_byte1                        ), //parameter  [23:0]
    .pf0_vendor_specific_dllp_req                                                    (pf0_vendor_specific_dllp_req                                                    ), //parameter
    .pf0_dsp_rx_preset_hint4                                                         (pf0_dsp_rx_preset_hint4                                                         ), //parameter  [2:0]
    .pf0_type0_hdr_class_code_revision_id_addr_byte3                                 (pf0_type0_hdr_class_code_revision_id_addr_byte3                                 ), //parameter  [23:0]
    .hrc_tx_lcff_pll_lock_active                                                     (hrc_tx_lcff_pll_lock_active                                                     ), //parameter
    .cfg_dbi_pf0_table_size                                                          (cfg_dbi_pf0_table_size                                                          ), //parameter  [8:0]
    .pf1_vf_bar3_reg_rsvdp_0                                                         (pf1_vf_bar3_reg_rsvdp_0                                                         ), //parameter
    .pf0_sriov_cap_sriov_bar5_enable_reg_addr_byte0                                  (pf0_sriov_cap_sriov_bar5_enable_reg_addr_byte0                                  ), //parameter  [23:0]
    .pf1_device_capabilities_reg_rsvdp_29                                            (pf1_device_capabilities_reg_rsvdp_29                                            ), //parameter  [2:0]
    .pf0_type0_hdr_bar2_mask_reg_addr_byte0                                          (pf0_type0_hdr_bar2_mask_reg_addr_byte0                                          ), //parameter  [23:0]
    .pf0_pm_cap_cap_id_nxt_ptr_reg_addr_byte3                                        (pf0_pm_cap_cap_id_nxt_ptr_reg_addr_byte3                                        ), //parameter  [23:0]
    .pf0_sriov_vf_bar5_enabled                                                       (pf0_sriov_vf_bar5_enabled                                                       ), //parameter
    .pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte3                                     (pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte3                                     ), //parameter  [23:0]
    .vf1_pf0_vf_shadow_link_capabilities_reg_shadow_rsvdp_23                         (vf1_pf0_vf_shadow_link_capabilities_reg_shadow_rsvdp_23                         ), //parameter
    .pf0_port_logic_gen3_related_off_addr_byte0                                      (pf0_port_logic_gen3_related_off_addr_byte0                                      ), //parameter  [23:0]
    .pf0_port_logic_gen2_ctrl_off_addr_byte0                                         (pf0_port_logic_gen2_ctrl_off_addr_byte0                                         ), //parameter  [23:0]
    .pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte1                                     (pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte1                                     ), //parameter  [23:0]
    .hrc_rstctl_timer_type_f                                                         (hrc_rstctl_timer_type_f                                                         ), //parameter
    .pf0_pcie_cap_hw_auto_speed_disable                                              (pf0_pcie_cap_hw_auto_speed_disable                                              ), //parameter
    .pf0_gen3_related_off_rsvdp_19                                                   (pf0_gen3_related_off_rsvdp_19                                                   ), //parameter  [4:0]
    .pf0_pcie_cap_link_disable                                                       (pf0_pcie_cap_link_disable                                                       ), //parameter
    .pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte0                                     (pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte0                                     ), //parameter  [23:0]
    .pf0_dsp_rx_preset_hint7                                                         (pf0_dsp_rx_preset_hint7                                                         ), //parameter  [2:0]
    .pf1_reserved_5_addr                                                             (pf1_reserved_5_addr                                                             ), //parameter  [23:0]
    .pf1_sriov_cap_vf_bar5_reg_addr_byte0                                            (pf1_sriov_cap_vf_bar5_reg_addr_byte0                                            ), //parameter  [23:0]
    .pf1_type0_hdr_bar2_mask_reg_addr_byte1                                          (pf1_type0_hdr_bar2_mask_reg_addr_byte1                                          ), //parameter  [23:0]
    .pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte1                                (pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte1                                ), //parameter  [23:0]
    .vf1_pf0_shadow_pcie_cap_l1_exit_latency_commclk_ena                             (vf1_pf0_shadow_pcie_cap_l1_exit_latency_commclk_ena                             ), //parameter  [1:0]
    .pf0_type0_hdr_device_id_vendor_id_reg_addr_byte0                                (pf0_type0_hdr_device_id_vendor_id_reg_addr_byte0                                ), //parameter  [23:0]
    .pf1_type0_hdr_device_id_vendor_id_reg_addr_byte1                                (pf1_type0_hdr_device_id_vendor_id_reg_addr_byte1                                ), //parameter  [23:0]
    .pf1_pcie_cap_extended_synch                                                     (pf1_pcie_cap_extended_synch                                                     ), //parameter
    .ssm_aux_prog_en                                                                 (ssm_aux_prog_en                                                                 ), //parameter
    .pf1_type0_hdr_bar3_mask_reg_addr_byte2                                          (pf1_type0_hdr_bar3_mask_reg_addr_byte2                                          ), //parameter  [23:0]
    .hrc_mask_tx_pll_lock_active                                                     (hrc_mask_tx_pll_lock_active                                                     ), //parameter
    .pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte0                                     (pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte0                                     ), //parameter  [23:0]
    .pf0_reserved_55_addr                                                            (pf0_reserved_55_addr                                                            ), //parameter  [23:0]
    .pf0_reserved4                                                                   (pf0_reserved4                                                                   ), //parameter
    .pf0_sriov_cap_shadow_sriov_initial_vfs_addr_byte0                               (pf0_sriov_cap_shadow_sriov_initial_vfs_addr_byte0                               ), //parameter  [23:0]
    .pf1_pci_type0_bar5_enabled_or_mask64lsb                                         (pf1_pci_type0_bar5_enabled_or_mask64lsb                                         ), //parameter
    .pf0_reserved_51_addr                                                            (pf0_reserved_51_addr                                                            ), //parameter  [23:0]
    .pf0_pcie_cap_link_control_link_status_reg_addr_byte1                            (pf0_pcie_cap_link_control_link_status_reg_addr_byte1                            ), //parameter  [23:0]
    .user_mode_del_count                                                             (user_mode_del_count                                                             ), //parameter  [4:0]
    .pf0_type0_hdr_bar5_mask_reg_addr_byte1                                          (pf0_type0_hdr_bar5_mask_reg_addr_byte1                                          ), //parameter  [23:0]
    .pf1_pcie_cap_next_ptr                                                           (pf1_pcie_cap_next_ptr                                                           ), //parameter  [7:0]
    .pf1_sriov_cap_sriov_base_reg_addr_byte2                                         (pf1_sriov_cap_sriov_base_reg_addr_byte2                                         ), //parameter  [23:0]
    .pf1_bar1_prefetch                                                               (pf1_bar1_prefetch                                                               ), //parameter
    .pf0_link_control_link_status_reg_rsvdp_9                                        (pf0_link_control_link_status_reg_rsvdp_9                                        ), //parameter
    .pf0_dsp_rx_preset_hint6                                                         (pf0_dsp_rx_preset_hint6                                                         ), //parameter  [2:0]
    .pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte0                      (pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte0                      ), //parameter  [23:0]
    .pf0_port_logic_gen3_eq_local_fs_lf_off_addr_byte0                               (pf0_port_logic_gen3_eq_local_fs_lf_off_addr_byte0                               ), //parameter  [23:0]
    .pf1_con_status_reg_rsvdp_2                                                      (pf1_con_status_reg_rsvdp_2                                                      ), //parameter
    .pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte1                                     (pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte1                                     ), //parameter  [23:0]
    .cvp_blocking_dis                                                                (cvp_blocking_dis                                                                ), //parameter
    .pf0_bar5_prefetch                                                               (pf0_bar5_prefetch                                                               ), //parameter
    .pf0_type0_hdr_bar1_mask_reg_addr_byte1                                          (pf0_type0_hdr_bar1_mask_reg_addr_byte1                                          ), //parameter  [23:0]
    .pf0_dsp_tx_preset6                                                              (pf0_dsp_tx_preset6                                                              ), //parameter  [3:0]
    .pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte3                      (pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte3                      ), //parameter  [23:0]
    .pf0_pci_type0_bar1_dummy_mask_7_1                                               (pf0_pci_type0_bar1_dummy_mask_7_1                                               ), //parameter  [6:0]
    .pf0_reserved_13_addr                                                            (pf0_reserved_13_addr                                                            ), //parameter  [23:0]
    .pf0_dbi_reserved_0                                                              (pf0_dbi_reserved_0                                                              ), //parameter  [7:0]
    .pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte0                                    (pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte0                                    ), //parameter  [23:0]
    .pf1_pm_cap_cap_id_nxt_ptr_reg_addr_byte1                                        (pf1_pm_cap_cap_id_nxt_ptr_reg_addr_byte1                                        ), //parameter  [23:0]
    .pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte3                           (pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte3                           ), //parameter  [23:0]
    .cvp_warm_rst_ready_force_bit0                                                   (cvp_warm_rst_ready_force_bit0                                                   ), //parameter
    .cvp_warm_rst_ready_force_bit1                                                   (cvp_warm_rst_ready_force_bit1                                                   ), //parameter
    .cvp_warm_rst_req_ena                                                            (cvp_warm_rst_req_ena                                                            ), //parameter
    .cvp_write_mask_ctl                                                              (cvp_write_mask_ctl                                                              ), //parameter  [2:0]
    .pf0_ari_cap_ari_base_addr_byte3                                                 (pf0_ari_cap_ari_base_addr_byte3                                                 ), //parameter  [23:0]
    .pf1_pcie_cap_link_training                                                      (pf1_pcie_cap_link_training                                                      ), //parameter
    .pf1_bar5_prefetch                                                               (pf1_bar5_prefetch                                                               ), //parameter
    .pf0_timer_mod_flow_control_en                                                   (pf0_timer_mod_flow_control_en                                                   ), //parameter
    .pf0_disable_scrambler_gen_3                                                     (pf0_disable_scrambler_gen_3                                                     ), //parameter
    .hrc_rstctl_1ms                                                                  (hrc_rstctl_1ms                                                                  ), //parameter  [19:0]
    .pf1_sn_cap_ser_num_reg_dw_1_addr_byte2                                          (pf1_sn_cap_ser_num_reg_dw_1_addr_byte2                                          ), //parameter  [23:0]
    .pf0_type0_hdr_bar5_mask_reg_addr_byte2                                          (pf0_type0_hdr_bar5_mask_reg_addr_byte2                                          ), //parameter  [23:0]
    .pf0_aer_cap_aer_ext_cap_hdr_off_addr_byte3                                      (pf0_aer_cap_aer_ext_cap_hdr_off_addr_byte3                                      ), //parameter  [23:0]
    .pf1_sriov_cap_sup_page_sizes_reg_addr_byte3                                     (pf1_sriov_cap_sup_page_sizes_reg_addr_byte3                                     ), //parameter  [23:0]
    .hrc_chnl_en                                                                     (hrc_chnl_en                                                                     ), //parameter  [15:0]
    .pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte1                                     (pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte1                                     ), //parameter  [23:0]
    .pf0_pipe_loopback                                                               (pf0_pipe_loopback                                                               ), //parameter
    .pf0_dbi_reserved_7                                                              (pf0_dbi_reserved_7                                                              ), //parameter  [7:0]
    .pf1_pcie_cap_max_link_speed                                                     (pf1_pcie_cap_max_link_speed                                                     ), //parameter
    .pf0_shadow_pcie_cap_max_link_width                                              (pf0_shadow_pcie_cap_max_link_width                                              ), //parameter  [1:0]
    .cfg_g3_pset_coeff_5                                                             (cfg_g3_pset_coeff_5                                                             ), //parameter  [17:0]
    .pf1_pci_msi_enable                                                              (pf1_pci_msi_enable                                                              ), //parameter
    .pf1_device_capabilities_reg_rsvdp_16                                            (pf1_device_capabilities_reg_rsvdp_16                                            ), //parameter  [3:0]
    .pf0_sriov_cap_sup_page_sizes_reg_addr_byte2                                     (pf0_sriov_cap_sup_page_sizes_reg_addr_byte2                                     ), //parameter  [23:0]
    .pf1_type0_hdr_class_code_revision_id_addr_byte0                                 (pf1_type0_hdr_class_code_revision_id_addr_byte0                                 ), //parameter  [23:0]
    .pf0_sriov_cap_sup_page_sizes_reg_addr_byte1                                     (pf0_sriov_cap_sup_page_sizes_reg_addr_byte1                                     ), //parameter  [23:0]
    .pf0_port_logic_vc0_np_rx_q_ctrl_off_addr_byte2                                  (pf0_port_logic_vc0_np_rx_q_ctrl_off_addr_byte2                                  ), //parameter  [23:0]
    .vf1_pf0_pcie_cap_vf_shadow_link_capabilities_reg_addr_byte1                     (vf1_pf0_pcie_cap_vf_shadow_link_capabilities_reg_addr_byte1                     ), //parameter  [23:0]
    .pf1_type0_hdr_bar1_enable_reg_addr_byte0                                        (pf1_type0_hdr_bar1_enable_reg_addr_byte0                                        ), //parameter  [23:0]
    .pf0_pci_msi_cap_next_offset                                                     (pf0_pci_msi_cap_next_offset                                                     ), //parameter  [7:0]
    .pf1_dbi_reserved_5                                                              (pf1_dbi_reserved_5                                                              ), //parameter  [7:0]
    .pf1_reserved_2_addr                                                             (pf1_reserved_2_addr                                                             ), //parameter  [23:0]
    .pf0_port_logic_filter_mask_2_off_addr_byte1                                     (pf0_port_logic_filter_mask_2_off_addr_byte1                                     ), //parameter  [23:0]
    .pf0_ats_cap_ats_cap_hdr_reg_addr_byte2                                          (pf0_ats_cap_ats_cap_hdr_reg_addr_byte2                                          ), //parameter  [23:0]
    .pf0_spcie_cap_version                                                           (pf0_spcie_cap_version                                                           ), //parameter  [3:0]
    .pf0_shadow_link_capabilities_reg_shadow_rsvdp_23                                (pf0_shadow_link_capabilities_reg_shadow_rsvdp_23                                ), //parameter
    .pf0_pcie_cap_link_capabilities_reg_addr_byte1                                   (pf0_pcie_cap_link_capabilities_reg_addr_byte1                                   ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte2                      (pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte2                      ), //parameter  [23:0]
    .crs_override                                                                    (crs_override                                                                    ), //parameter
    .pf1_link_control_link_status_reg_rsvdp_2                                        (pf1_link_control_link_status_reg_rsvdp_2                                        ), //parameter
    .pf0_dsp_tx_preset11                                                             (pf0_dsp_tx_preset11                                                             ), //parameter  [3:0]
    .pf0_port_logic_aux_clk_freq_off_addr_byte1                                      (pf0_port_logic_aux_clk_freq_off_addr_byte1                                      ), //parameter  [23:0]
    .pf0_gen3_eq_fmdc_n_evals                                                        (pf0_gen3_eq_fmdc_n_evals                                                        ), //parameter  [4:0]
    .pf1_sn_cap_ser_num_reg_dw_2_addr_byte3                                          (pf1_sn_cap_ser_num_reg_dw_2_addr_byte3                                          ), //parameter  [23:0]
    .pf0_vc0_cpl_tlp_q_mode                                                          (pf0_vc0_cpl_tlp_q_mode                                                          ), //parameter  [2:0]
    .pf0_lane_equalization_control45_reg_rsvdp_31                                    (pf0_lane_equalization_control45_reg_rsvdp_31                                    ), //parameter
    .pf0_pcie_cap_next_ptr                                                           (pf0_pcie_cap_next_ptr                                                           ), //parameter  [7:0]
    .pf1_reserved_17_addr                                                            (pf1_reserved_17_addr                                                            ), //parameter  [23:0]
    .pf0_reserved_53_addr                                                            (pf0_reserved_53_addr                                                            ), //parameter  [23:0]
    .pf0_sn_cap_sn_base_addr_byte3                                                   (pf0_sn_cap_sn_base_addr_byte3                                                   ), //parameter  [23:0]
    .pf1_sriov_cap_sriov_bar3_enable_reg_addr_byte0                                  (pf1_sriov_cap_sriov_bar3_enable_reg_addr_byte0                                  ), //parameter  [23:0]
    .pf1_pcie_cap_max_read_req_size                                                  (pf1_pcie_cap_max_read_req_size                                                  ), //parameter  [2:0]
    .pf1_pcie_cap_max_payload_size                                                   (pf1_pcie_cap_max_payload_size                                                   ), //parameter
    .pf0_dbi_reserved_38                                                             (pf0_dbi_reserved_38                                                             ), //parameter  [7:0]
    .pf0_link_control_link_status_reg_rsvdp_12                                       (pf0_link_control_link_status_reg_rsvdp_12                                       ), //parameter  [3:0]
    .hrc_chnl_cal_done_active                                                        (hrc_chnl_cal_done_active                                                        ), //parameter
    .pf1_bar1_start                                                                  (pf1_bar1_start                                                                  ), //parameter  [3:0]
    .pf1_tph_req_cap_reg_rsvdp_27                                                    (pf1_tph_req_cap_reg_rsvdp_27                                                    ), //parameter  [4:0]
    .pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte2                                     (pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte2                                     ), //parameter  [23:0]
    .pf1_sriov_vf_bar5_enabled                                                       (pf1_sriov_vf_bar5_enabled                                                       ), //parameter
    .pf0_dsp_rx_preset_hint12                                                        (pf0_dsp_rx_preset_hint12                                                        ), //parameter  [2:0]
    .pf0_lane_equalization_control23_reg_rsvdp_15                                    (pf0_lane_equalization_control23_reg_rsvdp_15                                    ), //parameter
    .pf0_lane_equalization_control1415_reg_rsvdp_7                                   (pf0_lane_equalization_control1415_reg_rsvdp_7                                   ), //parameter
    .eqctrl_use_dsp_rxpreset                                                         (eqctrl_use_dsp_rxpreset                                                         ), //parameter
    .pf0_mask_radm_2                                                                 (pf0_mask_radm_2                                                                 ), //parameter  [31:0]
    .pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte3                                     (pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte3                                     ), //parameter  [23:0]
    .pf1_sriov_cap_sriov_bar5_enable_reg_addr_byte0                                  (pf1_sriov_cap_sriov_bar5_enable_reg_addr_byte0                                  ), //parameter  [23:0]
    .pf1_bar3_mem_io                                                                 (pf1_bar3_mem_io                                                                 ), //parameter
    .pf0_gen3_eq_fb_mode                                                             (pf0_gen3_eq_fb_mode                                                             ), //parameter
    .pf0_msix_cap_msix_pba_offset_reg_addr_byte1                                     (pf0_msix_cap_msix_pba_offset_reg_addr_byte1                                     ), //parameter  [23:0]
    .pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte0                                     (pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte0                                     ), //parameter  [23:0]
    .vf_reserved_3_addr                                                              (vf_reserved_3_addr                                                              ), //parameter  [23:0]
    .pf1_dbi_reserved_1                                                              (pf1_dbi_reserved_1                                                              ), //parameter  [7:0]
    .pf0_pci_msi_enable                                                              (pf0_pci_msi_enable                                                              ), //parameter
    .pf0_sriov_vf_bar3_type                                                          (pf0_sriov_vf_bar3_type                                                          ), //parameter
    .pf0_type0_hdr_bar5_enable_reg_addr_byte0                                        (pf0_type0_hdr_bar5_enable_reg_addr_byte0                                        ), //parameter  [23:0]
    .pf0_type0_hdr_bar2_mask_reg_addr_byte3                                          (pf0_type0_hdr_bar2_mask_reg_addr_byte3                                          ), //parameter  [23:0]
    .pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte0                   (pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte0                   ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control67_reg_addr_byte3                        (pf0_spcie_cap_lane_equalization_control67_reg_addr_byte3                        ), //parameter  [23:0]
    .pf1_pcie_cap_nego_link_width                                                    (pf1_pcie_cap_nego_link_width                                                    ), //parameter
    .pf1_sriov_cap_sriov_initial_vfs_addr_byte0                                      (pf1_sriov_cap_sriov_initial_vfs_addr_byte0                                      ), //parameter  [23:0]
    .pf1_tph_req_extended_tph                                                        (pf1_tph_req_extended_tph                                                        ), //parameter
    .cfg_g3_pset_coeff_3                                                             (cfg_g3_pset_coeff_3                                                             ), //parameter  [17:0]
    .pf0_dbi_reserved_48                                                             (pf0_dbi_reserved_48                                                             ), //parameter  [7:0]
    .hrc_rstctl_timer_type_g                                                         (hrc_rstctl_timer_type_g                                                         ), //parameter
    .pf0_reserved_45_addr                                                            (pf0_reserved_45_addr                                                            ), //parameter  [23:0]
    .pf0_pcie_cap_surprise_down_err_rep_cap                                          (pf0_pcie_cap_surprise_down_err_rep_cap                                          ), //parameter
    .pf1_msix_cap_msix_table_offset_reg_addr_byte1                                   (pf1_msix_cap_msix_table_offset_reg_addr_byte1                                   ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte0                      (pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte0                      ), //parameter  [23:0]
    .pf0_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                (pf0_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                ), //parameter  [2:0]
    .pf0_ack_n_fts                                                                   (pf0_ack_n_fts                                                                   ), //parameter  [7:0]
    .vf1_pf1_shadow_pcie_cap_link_bw_not_cap                                         (vf1_pf1_shadow_pcie_cap_link_bw_not_cap                                         ), //parameter
    .pf1_type0_hdr_bar5_mask_reg_addr_byte1                                          (pf1_type0_hdr_bar5_mask_reg_addr_byte1                                          ), //parameter  [23:0]
    .pf1_type0_hdr_bar1_mask_reg_addr_byte1                                          (pf1_type0_hdr_bar1_mask_reg_addr_byte1                                          ), //parameter  [23:0]
    .pf0_cap_pointer                                                                 (pf0_cap_pointer                                                                 ), //parameter  [7:0]
    .pf1_dbi_reserved_18                                                             (pf1_dbi_reserved_18                                                             ), //parameter  [7:0]
    .pf0_shadow_pcie_cap_dll_active_rep_cap                                          (pf0_shadow_pcie_cap_dll_active_rep_cap                                          ), //parameter
    .pf0_dbi_reserved_42                                                             (pf0_dbi_reserved_42                                                             ), //parameter  [7:0]
    .pf0_reserved_24_addr                                                            (pf0_reserved_24_addr                                                            ), //parameter  [23:0]
    .pf0_cross_link_active                                                           (pf0_cross_link_active                                                           ), //parameter
    .pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte0                                     (pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte0                                     ), //parameter  [23:0]
    .pld_crs_en                                                                      (pld_crs_en                                                                      ), //parameter
    .eqctrl_fom_mode_en                                                              (eqctrl_fom_mode_en                                                              ), //parameter
    .eqctrl_adp_ctle                                                                 (eqctrl_adp_ctle                                                                 ), //parameter
    .pf0_sn_cap_ser_num_reg_dw_2_addr_byte1                                          (pf0_sn_cap_ser_num_reg_dw_2_addr_byte1                                          ), //parameter  [23:0]
    .pf0_pci_type0_bar3_enabled_or_mask64lsb                                         (pf0_pci_type0_bar3_enabled_or_mask64lsb                                         ), //parameter
    .pf0_type0_hdr_bar3_mask_reg_addr_byte3                                          (pf0_type0_hdr_bar3_mask_reg_addr_byte3                                          ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control01_reg_addr_byte2                        (pf0_spcie_cap_lane_equalization_control01_reg_addr_byte2                        ), //parameter  [23:0]
    .pf0_sriov_vf_bar3_dummy_mask_7_1                                                (pf0_sriov_vf_bar3_dummy_mask_7_1                                                ), //parameter  [6:0]
    .vf1_pf1_shadow_pcie_cap_l1_exit_latency_commclk_ena                             (vf1_pf1_shadow_pcie_cap_l1_exit_latency_commclk_ena                             ), //parameter  [1:0]
    .pf0_port_logic_symbol_timer_filter_1_off_addr_byte3                             (pf0_port_logic_symbol_timer_filter_1_off_addr_byte3                             ), //parameter  [23:0]
    .pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte2                                     (pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte2                                     ), //parameter  [23:0]
    .pf0_type0_hdr_device_id_vendor_id_reg_addr_byte2                                (pf0_type0_hdr_device_id_vendor_id_reg_addr_byte2                                ), //parameter  [23:0]
    .pf1_aer_cap_aer_ext_cap_hdr_off_addr_byte2                                      (pf1_aer_cap_aer_ext_cap_hdr_off_addr_byte2                                      ), //parameter  [23:0]
    .pf1_sriov_vf_bar1_prefetch                                                      (pf1_sriov_vf_bar1_prefetch                                                      ), //parameter
    .pf0_spcie_cap_lane_equalization_control45_reg_addr_byte0                        (pf0_spcie_cap_lane_equalization_control45_reg_addr_byte0                        ), //parameter  [23:0]
    .pf1_sriov_vf_bar3_start                                                         (pf1_sriov_vf_bar3_start                                                         ), //parameter  [3:0]
    .vf1_pf0_tph_req_next_ptr                                                        (vf1_pf0_tph_req_next_ptr                                                        ), //parameter  [11:0]
    .pf0_lane_equalization_control01_reg_rsvdp_15                                    (pf0_lane_equalization_control01_reg_rsvdp_15                                    ), //parameter
    .pf1_type0_hdr_exp_rom_base_addr_reg_addr_byte0                                  (pf1_type0_hdr_exp_rom_base_addr_reg_addr_byte0                                  ), //parameter  [23:0]
    .pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte0                                   (pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte0                                   ), //parameter  [23:0]
    .pf0_dbi_reserved_25                                                             (pf0_dbi_reserved_25                                                             ), //parameter  [7:0]
    .pf0_loopback_enable                                                             (pf0_loopback_enable                                                             ), //parameter
    .pf0_pci_msix_cap_next_offset                                                    (pf0_pci_msix_cap_next_offset                                                    ), //parameter  [7:0]
    .pf0_dbi_reserved_30                                                             (pf0_dbi_reserved_30                                                             ), //parameter  [7:0]
    .pf0_pcie_cap_shadow_link_capabilities_reg_addr_byte0                            (pf0_pcie_cap_shadow_link_capabilities_reg_addr_byte0                            ), //parameter  [23:0]
    .pf0_dbi_reserved_36                                                             (pf0_dbi_reserved_36                                                             ), //parameter  [7:0]
    .pf0_sriov_cap_sriov_base_reg_addr_byte3                                         (pf0_sriov_cap_sriov_base_reg_addr_byte3                                         ), //parameter  [23:0]
    .pf0_type0_hdr_bar1_reg_addr_byte0                                               (pf0_type0_hdr_bar1_reg_addr_byte0                                               ), //parameter  [23:0]
    .pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte0                               (pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte0                               ), //parameter  [23:0]
    .pf1_sn_cap_sn_base_addr_byte3                                                   (pf1_sn_cap_sn_base_addr_byte3                                                   ), //parameter  [23:0]
    .pf0_reserved_2_addr                                                             (pf0_reserved_2_addr                                                             ), //parameter  [23:0]
    .pf0_port_logic_vc0_np_rx_q_ctrl_off_addr_byte0                                  (pf0_port_logic_vc0_np_rx_q_ctrl_off_addr_byte0                                  ), //parameter  [23:0]
    .virtual_pf1_sriov_num_vf_ari                                                    (virtual_pf1_sriov_num_vf_ari                                                    ), //parameter  [15:0]
    .pf1_reserved_8_addr                                                             (pf1_reserved_8_addr                                                             ), //parameter  [23:0]
    .pf0_dbi_reserved_15                                                             (pf0_dbi_reserved_15                                                             ), //parameter  [7:0]
    .pf0_pm_next_pointer                                                             (pf0_pm_next_pointer                                                             ), //parameter  [7:0]
    .pf0_sriov_initial_vfs_ari_cs2                                                   (pf0_sriov_initial_vfs_ari_cs2                                                   ), //parameter  [15:0]
    .virtual_pf0_io_decode                                                           (virtual_pf0_io_decode                                                           ), //parameter
    .pf0_dsp_tx_preset0                                                              (pf0_dsp_tx_preset0                                                              ), //parameter  [3:0]
    .pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte3                                   (pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte3                                   ), //parameter  [23:0]
    .pf0_tph_req_next_ptr                                                            (pf0_tph_req_next_ptr                                                            ), //parameter  [11:0]
    .pf0_sriov_cap_sriov_initial_vfs_addr_byte1                                      (pf0_sriov_cap_sriov_initial_vfs_addr_byte1                                      ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control23_reg_addr_byte3                        (pf0_spcie_cap_lane_equalization_control23_reg_addr_byte3                        ), //parameter  [23:0]
    .pf1_tph_req_cap_reg_vfcomm_cs2_rsvdp_11_vfcomm_cs2                              (pf1_tph_req_cap_reg_vfcomm_cs2_rsvdp_11_vfcomm_cs2                              ), //parameter  [4:0]
    .pf1_sriov_cap_vf_device_id_reg_addr_byte3                                       (pf1_sriov_cap_vf_device_id_reg_addr_byte3                                       ), //parameter  [23:0]
    .pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte0                                     (pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte0                                     ), //parameter  [23:0]
    .vf1_pf1_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte3                               (vf1_pf1_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte3                               ), //parameter  [23:0]
    .pf0_reserved_31_addr                                                            (pf0_reserved_31_addr                                                            ), //parameter  [23:0]
    .pf1_tph_req_cap_ver                                                             (pf1_tph_req_cap_ver                                                             ), //parameter  [3:0]
    .pf0_reserved_21_addr                                                            (pf0_reserved_21_addr                                                            ), //parameter  [23:0]
    .pf0_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte1              (pf0_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte1              ), //parameter  [23:0]
    .pf1_type0_hdr_device_id_vendor_id_reg_addr_byte2                                (pf1_type0_hdr_device_id_vendor_id_reg_addr_byte2                                ), //parameter  [23:0]
    .pf1_sriov_cap_version                                                           (pf1_sriov_cap_version                                                           ), //parameter  [3:0]
    .pf0_bar1_type                                                                   (pf0_bar1_type                                                                   ), //parameter
    .pf0_bar0_start                                                                  (pf0_bar0_start                                                                  ), //parameter  [3:0]
    .vf_reserved_2_addr                                                              (vf_reserved_2_addr                                                              ), //parameter  [23:0]
    .pf1_sriov_vf_bar0_start                                                         (pf1_sriov_vf_bar0_start                                                         ), //parameter  [3:0]
    .pf1_pcie_cap_en_no_snoop                                                        (pf1_pcie_cap_en_no_snoop                                                        ), //parameter
    .pf1_pcie_cap_enter_compliance                                                   (pf1_pcie_cap_enter_compliance                                                   ), //parameter
    .pf1_cap_pointer                                                                 (pf1_cap_pointer                                                                 ), //parameter  [7:0]
    .pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte2                (pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte2                ), //parameter  [23:0]
    .pf0_vc0_cpl_header_credit                                                       (pf0_vc0_cpl_header_credit                                                       ), //parameter  [7:0]
    .pf0_vf_bar0_reg_rsvdp_0                                                         (pf0_vf_bar0_reg_rsvdp_0                                                         ), //parameter
    .pf1_sriov_cap_sriov_vf_offset_position_addr_byte1                               (pf1_sriov_cap_sriov_vf_offset_position_addr_byte1                               ), //parameter  [23:0]
    .pf0_lane_equalization_control01_reg_rsvdp_23                                    (pf0_lane_equalization_control01_reg_rsvdp_23                                    ), //parameter
    .pf0_port_logic_aux_clk_freq_off_addr_byte0                                      (pf0_port_logic_aux_clk_freq_off_addr_byte0                                      ), //parameter  [23:0]
    .pf0_dbi_ro_wr_en                                                                (pf0_dbi_ro_wr_en                                                                ), //parameter
    .pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte0                               (pf0_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte0                               ), //parameter  [23:0]
    .pf0_reserved_44_addr                                                            (pf0_reserved_44_addr                                                            ), //parameter  [23:0]
    .pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte3                                     (pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte3                                     ), //parameter  [23:0]
    .vf1_pf1_vf_shadow_link_capabilities_reg_shadow_rsvdp_23                         (vf1_pf1_vf_shadow_link_capabilities_reg_shadow_rsvdp_23                         ), //parameter
    .pf0_type0_hdr_bar0_mask_reg_addr_byte2                                          (pf0_type0_hdr_bar0_mask_reg_addr_byte2                                          ), //parameter  [23:0]
    .pf1_pm_cap_cap_id_nxt_ptr_reg_addr_byte3                                        (pf1_pm_cap_cap_id_nxt_ptr_reg_addr_byte3                                        ), //parameter  [23:0]
    .vf1_pf0_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte3                               (vf1_pf0_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte3                               ), //parameter  [23:0]
    .pf0_aer_cap_aer_ext_cap_hdr_off_addr_byte2                                      (pf0_aer_cap_aer_ext_cap_hdr_off_addr_byte2                                      ), //parameter  [23:0]
    .hrc_rstctl_1us                                                                  (hrc_rstctl_1us                                                                  ), //parameter  [19:0]
    .pf0_mask_radm_1                                                                 (pf0_mask_radm_1                                                                 ), //parameter  [15:0]
    .pf1_tph_req_cap_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                              (pf1_tph_req_cap_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                              ), //parameter  [4:0]
    .pf1_sn_cap_ser_num_reg_dw_2_addr_byte1                                          (pf1_sn_cap_ser_num_reg_dw_2_addr_byte1                                          ), //parameter  [23:0]
    .pf1_type0_hdr_bar5_enable_reg_addr_byte0                                        (pf1_type0_hdr_bar5_enable_reg_addr_byte0                                        ), //parameter  [23:0]
    .pf0_pcie_cap_role_based_err_report                                              (pf0_pcie_cap_role_based_err_report                                              ), //parameter
    .pf0_aux_clk_freq_off_rsvdp_10                                                   (pf0_aux_clk_freq_off_rsvdp_10                                                   ), //parameter  [5:0]
    .clkmod_gen3_hclk_source_sel                                                     (clkmod_gen3_hclk_source_sel                                                     ), //parameter
    .pf1_type0_hdr_bar0_mask_reg_addr_byte2                                          (pf1_type0_hdr_bar0_mask_reg_addr_byte2                                          ), //parameter  [23:0]
    .pf0_pcie_cap_phantom_func_en                                                    (pf0_pcie_cap_phantom_func_en                                                    ), //parameter
    .pf0_pcie_cap_phantom_func_support                                               (pf0_pcie_cap_phantom_func_support                                               ), //parameter  [1:0]
    .pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte0                                     (pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte0                                     ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control01_reg_addr_byte0                        (pf0_spcie_cap_lane_equalization_control01_reg_addr_byte0                        ), //parameter  [23:0]
    .pf1_dbi_reserved_19                                                             (pf1_dbi_reserved_19                                                             ), //parameter  [7:0]
    .pf0_dsp_tx_preset5                                                              (pf0_dsp_tx_preset5                                                              ), //parameter  [3:0]
    .pf0_lane_equalization_control89_reg_rsvdp_31                                    (pf0_lane_equalization_control89_reg_rsvdp_31                                    ), //parameter
    .pf0_dsp_tx_preset14                                                             (pf0_dsp_tx_preset14                                                             ), //parameter  [3:0]
    .vf_dbi_reserved_1                                                               (vf_dbi_reserved_1                                                               ), //parameter  [7:0]
    .pf0_dbi_reserved_19                                                             (pf0_dbi_reserved_19                                                             ), //parameter  [7:0]
    .pf0_reserved6                                                                   (pf0_reserved6                                                                   ), //parameter
    .pf0_dbi_reserved_28                                                             (pf0_dbi_reserved_28                                                             ), //parameter  [7:0]
    .pf1_ats_cap_ats_cap_hdr_reg_addr_byte2                                          (pf1_ats_cap_ats_cap_hdr_reg_addr_byte2                                          ), //parameter  [23:0]
    .pf0_pci_msix_enable_vfcomm_cs2                                                  (pf0_pci_msix_enable_vfcomm_cs2                                                  ), //parameter
    .pf0_port_logic_gen3_related_off_addr_byte1                                      (pf0_port_logic_gen3_related_off_addr_byte1                                      ), //parameter  [23:0]
    .pf0_dbi_reserved_49                                                             (pf0_dbi_reserved_49                                                             ), //parameter  [7:0]
    .pf0_pcie_cap_link_capabilities_reg_addr_byte3                                   (pf0_pcie_cap_link_capabilities_reg_addr_byte3                                   ), //parameter  [23:0]
    .pf1_sriov_cap_sriov_bar1_enable_reg_addr_byte0                                  (pf1_sriov_cap_sriov_bar1_enable_reg_addr_byte0                                  ), //parameter  [23:0]
    .pf0_gen3_eq_fmdc_max_post_cusror_delta                                          (pf0_gen3_eq_fmdc_max_post_cusror_delta                                          ), //parameter  [3:0]
    .pf0_lane_equalization_control01_reg_rsvdp_7                                     (pf0_lane_equalization_control01_reg_rsvdp_7                                     ), //parameter
    .pf0_header_type                                                                 (pf0_header_type                                                                 ), //parameter  [6:0]
    .pf0_dbi_reserved_39                                                             (pf0_dbi_reserved_39                                                             ), //parameter  [7:0]
    .pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte1                                     (pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte1                                     ), //parameter  [23:0]
    .pf1_dbi_reserved_0                                                              (pf1_dbi_reserved_0                                                              ), //parameter  [7:0]
    .pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte2                                    (pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte2                                    ), //parameter  [23:0]
    .pf0_timer_mod_flow_control                                                      (pf0_timer_mod_flow_control                                                      ), //parameter  [12:0]
    .pf0_type0_hdr_bar3_mask_reg_addr_byte1                                          (pf0_type0_hdr_bar3_mask_reg_addr_byte1                                          ), //parameter  [23:0]
    .pf0_pre_det_lane                                                                (pf0_pre_det_lane                                                                ), //parameter
    .pf0_vc0_np_header_credit                                                        (pf0_vc0_np_header_credit                                                        ), //parameter  [7:0]
    .pf1_device_capabilities_reg_rsvdp_12                                            (pf1_device_capabilities_reg_rsvdp_12                                            ), //parameter  [2:0]
    .pf0_dbi_reserved_57                                                             (pf0_dbi_reserved_57                                                             ), //parameter  [7:0]
    .vf1_pf0_shadow_pcie_cap_link_bw_not_cap                                         (vf1_pf0_shadow_pcie_cap_link_bw_not_cap                                         ), //parameter
    .device_type                                                                     (device_type                                                                     ), //parameter
    .pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte2                   (pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte2                   ), //parameter  [23:0]
    .pf1_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte2                             (pf1_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte2                             ), //parameter  [23:0]
    .clkmod_pld_clk_out_sel_2x                                                       (clkmod_pld_clk_out_sel_2x                                                       ), //parameter
    .pf0_dbi_reserved_54                                                             (pf0_dbi_reserved_54                                                             ), //parameter  [7:0]
    .pf0_lane_equalization_control1011_reg_rsvdp_23                                  (pf0_lane_equalization_control1011_reg_rsvdp_23                                  ), //parameter
    .pf0_sriov_cap_vf_bar3_reg_addr_byte0                                            (pf0_sriov_cap_vf_bar3_reg_addr_byte0                                            ), //parameter  [23:0]
    .hrc_rstctl_timer_type_j                                                         (hrc_rstctl_timer_type_j                                                         ), //parameter
    .pf0_pcie_cap_slot_capabilities_reg_addr_byte1                                   (pf0_pcie_cap_slot_capabilities_reg_addr_byte1                                   ), //parameter  [23:0]
    .pf1_dbi_reserved_3                                                              (pf1_dbi_reserved_3                                                              ), //parameter  [7:0]
    .pf1_sriov_cap_shadow_sriov_initial_vfs_addr_byte1                               (pf1_sriov_cap_shadow_sriov_initial_vfs_addr_byte1                               ), //parameter  [23:0]
    .pf0_reserved_10_addr                                                            (pf0_reserved_10_addr                                                            ), //parameter  [23:0]
    .pf1_pcie_cap_shadow_link_capabilities_reg_addr_byte0                            (pf1_pcie_cap_shadow_link_capabilities_reg_addr_byte0                            ), //parameter  [23:0]
    .pf0_root_control_root_capabilities_reg_rsvdp_17                                 (pf0_root_control_root_capabilities_reg_rsvdp_17                                 ), //parameter  [6:0]
    .pf0_type0_hdr_bar2_mask_reg_addr_byte1                                          (pf0_type0_hdr_bar2_mask_reg_addr_byte1                                          ), //parameter  [23:0]
    .pf1_dbi_reserved_6                                                              (pf1_dbi_reserved_6                                                              ), //parameter  [7:0]
    .pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte2                                     (pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte2                                     ), //parameter  [23:0]
    .pf0_port_logic_gen3_eq_control_off_addr_byte3                                   (pf0_port_logic_gen3_eq_control_off_addr_byte3                                   ), //parameter  [23:0]
    .pf1_tph_req_cap_reg_vfcomm_cs2_rsvdp_3_vfcomm_cs2                               (pf1_tph_req_cap_reg_vfcomm_cs2_rsvdp_3_vfcomm_cs2                               ), //parameter  [4:0]
    .pf0_dll_link_en                                                                 (pf0_dll_link_en                                                                 ), //parameter
    .pf0_sriov_vf_bar0_start                                                         (pf0_sriov_vf_bar0_start                                                         ), //parameter  [3:0]
    .pf0_eidle_timer                                                                 (pf0_eidle_timer                                                                 ), //parameter  [3:0]
    .pf1_reserved_11_addr                                                            (pf1_reserved_11_addr                                                            ), //parameter  [23:0]
    .pf1_pcie_cap_device_capabilities_reg_addr_byte2                                 (pf1_pcie_cap_device_capabilities_reg_addr_byte2                                 ), //parameter  [23:0]
    .pf0_tph_cap_tph_ext_cap_hdr_reg_addr_byte3                                      (pf0_tph_cap_tph_ext_cap_hdr_reg_addr_byte3                                      ), //parameter  [23:0]
    .pf0_dbi_reserved_16                                                             (pf0_dbi_reserved_16                                                             ), //parameter  [7:0]
    .pf0_lane_equalization_control1213_reg_rsvdp_23                                  (pf0_lane_equalization_control1213_reg_rsvdp_23                                  ), //parameter
    .pf0_sriov_next_offset                                                           (pf0_sriov_next_offset                                                           ), //parameter  [11:0]
    .pf0_bar5_start                                                                  (pf0_bar5_start                                                                  ), //parameter  [3:0]
    .pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte1                                     (pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte1                                     ), //parameter  [23:0]
    .pld_tx_fifo_empty_threshold_1                                                   (pld_tx_fifo_empty_threshold_1                                                   ), //parameter  [3:0]
    .pf1_tph_cap_tph_ext_cap_hdr_reg_addr_byte2                                      (pf1_tph_cap_tph_ext_cap_hdr_reg_addr_byte2                                      ), //parameter  [23:0]
    .pf0_type0_hdr_bar0_mask_reg_addr_byte3                                          (pf0_type0_hdr_bar0_mask_reg_addr_byte3                                          ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control45_reg_addr_byte2                        (pf0_spcie_cap_lane_equalization_control45_reg_addr_byte2                        ), //parameter  [23:0]
    .vsec_legacy_interr_mask_en                                                      (vsec_legacy_interr_mask_en                                                      ), //parameter
    .pf1_sriov_vf_bar5_start                                                         (pf1_sriov_vf_bar5_start                                                         ), //parameter  [3:0]
    .pf0_spcie_cap_lane_equalization_control89_reg_addr_byte0                        (pf0_spcie_cap_lane_equalization_control89_reg_addr_byte0                        ), //parameter  [23:0]
    .pf0_dbi_reserved_47                                                             (pf0_dbi_reserved_47                                                             ), //parameter  [7:0]
    .pf0_dbi_reserved_6                                                              (pf0_dbi_reserved_6                                                              ), //parameter  [7:0]
    .pf1_msix_cap_msix_table_offset_reg_addr_byte3                                   (pf1_msix_cap_msix_table_offset_reg_addr_byte3                                   ), //parameter  [23:0]
    .pf0_sriov_vf_bar1_dummy_mask_7_1                                                (pf0_sriov_vf_bar1_dummy_mask_7_1                                                ), //parameter  [6:0]
    .pf0_bar3_start                                                                  (pf0_bar3_start                                                                  ), //parameter  [3:0]
    .pf0_gen3_eq_local_fs                                                            (pf0_gen3_eq_local_fs                                                            ), //parameter  [5:0]
    .pf0_sriov_cap_sriov_bar3_enable_reg_addr_byte0                                  (pf0_sriov_cap_sriov_bar3_enable_reg_addr_byte0                                  ), //parameter  [23:0]
    .cvp_hard_reset_bypass                                                           (cvp_hard_reset_bypass                                                           ), //parameter
    .pf1_bar2_mem_io                                                                 (pf1_bar2_mem_io                                                                 ), //parameter
    .pf0_reserved_17_addr                                                            (pf0_reserved_17_addr                                                            ), //parameter  [23:0]
    .pf0_reserved_32_addr                                                            (pf0_reserved_32_addr                                                            ), //parameter  [23:0]
    .pf0_port_logic_ack_f_aspm_ctrl_off_addr_byte1                                   (pf0_port_logic_ack_f_aspm_ctrl_off_addr_byte1                                   ), //parameter  [23:0]
    .pf1_reserved_15_addr                                                            (pf1_reserved_15_addr                                                            ), //parameter  [23:0]
    .pld_aux_prog_en                                                                 (pld_aux_prog_en                                                                 ), //parameter
    .pf0_sn_cap_ser_num_reg_dw_1_addr_byte3                                          (pf0_sn_cap_ser_num_reg_dw_1_addr_byte3                                          ), //parameter  [23:0]
    .pf0_tph_req_no_st_mode                                                          (pf0_tph_req_no_st_mode                                                          ), //parameter
    .pf0_gen3_eq_fom_inc_initial_eval                                                (pf0_gen3_eq_fom_inc_initial_eval                                                ), //parameter
    .pf0_lane_equalization_control89_reg_rsvdp_7                                     (pf0_lane_equalization_control89_reg_rsvdp_7                                     ), //parameter
    .pf1_sriov_vf_bar4_start                                                         (pf1_sriov_vf_bar4_start                                                         ), //parameter  [3:0]
    .pf0_pcie_cap_aspm_opt_compliance                                                (pf0_pcie_cap_aspm_opt_compliance                                                ), //parameter
    .pf0_lane_equalization_control1213_reg_rsvdp_31                                  (pf0_lane_equalization_control1213_reg_rsvdp_31                                  ), //parameter
    .pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte3                               (pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte3                               ), //parameter  [23:0]
    .hrc_rx_pll_lock_active                                                          (hrc_rx_pll_lock_active                                                          ), //parameter
    .pf1_pci_msix_enable                                                             (pf1_pci_msix_enable                                                             ), //parameter
    .pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte0                                     (pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte0                                     ), //parameter  [23:0]
    .pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte3                (pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte3                ), //parameter  [23:0]
    .pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte2                   (pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte2                   ), //parameter  [23:0]
    .pf1_sriov_cap_vf_bar1_reg_addr_byte0                                            (pf1_sriov_cap_vf_bar1_reg_addr_byte0                                            ), //parameter  [23:0]
    .pf0_gen3_eq_pset_req_vec                                                        (pf0_gen3_eq_pset_req_vec                                                        ), //parameter  [15:0]
    .pf0_bar2_start                                                                  (pf0_bar2_start                                                                  ), //parameter  [3:0]
    .cfg_g3_pset_coeff_6                                                             (cfg_g3_pset_coeff_6                                                             ), //parameter  [17:0]
    .pf1_pci_msi_cap_next_offset                                                     (pf1_pci_msi_cap_next_offset                                                     ), //parameter  [7:0]
    .pf0_pcie_cap_dll_active                                                         (pf0_pcie_cap_dll_active                                                         ), //parameter
    .pf1_tph_cap_tph_req_cap_reg_addr_byte1                                          (pf1_tph_cap_tph_req_cap_reg_addr_byte1                                          ), //parameter  [23:0]
    .vf_dbi_reserved_0                                                               (vf_dbi_reserved_0                                                               ), //parameter  [7:0]
    .pf0_lane_equalization_control45_reg_rsvdp_7                                     (pf0_lane_equalization_control45_reg_rsvdp_7                                     ), //parameter
    .pf0_lane_equalization_control89_reg_rsvdp_23                                    (pf0_lane_equalization_control89_reg_rsvdp_23                                    ), //parameter
    .pf0_tph_req_extended_tph                                                        (pf0_tph_req_extended_tph                                                        ), //parameter
    .cfg_g3_pset_coeff_0                                                             (cfg_g3_pset_coeff_0                                                             ), //parameter  [17:0]
    .vf1_pf0_shadow_pcie_cap_dll_active_rep_cap                                      (vf1_pf0_shadow_pcie_cap_dll_active_rep_cap                                      ), //parameter
    .pf1_type0_hdr_device_id_vendor_id_reg_addr_byte0                                (pf1_type0_hdr_device_id_vendor_id_reg_addr_byte0                                ), //parameter  [23:0]
    .pf0_dbi_reserved_32                                                             (pf0_dbi_reserved_32                                                             ), //parameter  [7:0]
    .pf0_dsp_rx_preset_hint14                                                        (pf0_dsp_rx_preset_hint14                                                        ), //parameter  [2:0]
    .pf0_dbi_reserved_35                                                             (pf0_dbi_reserved_35                                                             ), //parameter  [7:0]
    .pf0_shadow_pcie_cap_clock_power_man                                             (pf0_shadow_pcie_cap_clock_power_man                                             ), //parameter
    .pf0_reserved_52_addr                                                            (pf0_reserved_52_addr                                                            ), //parameter  [23:0]
    .pf0_pcie_cap_common_clk_config                                                  (pf0_pcie_cap_common_clk_config                                                  ), //parameter
    .pf0_dbi_reserved_55                                                             (pf0_dbi_reserved_55                                                             ), //parameter  [7:0]
    .pf0_type0_hdr_bar4_mask_reg_addr_byte1                                          (pf0_type0_hdr_bar4_mask_reg_addr_byte1                                          ), //parameter  [23:0]
    .pf1_sriov_cap_shadow_sriov_initial_vfs_addr_byte0                               (pf1_sriov_cap_shadow_sriov_initial_vfs_addr_byte0                               ), //parameter  [23:0]
    .pf0_type0_hdr_bar0_mask_reg_addr_byte0                                          (pf0_type0_hdr_bar0_mask_reg_addr_byte0                                          ), //parameter  [23:0]
    .pf0_gen3_related_off_rsvdp_1                                                    (pf0_gen3_related_off_rsvdp_1                                                    ), //parameter  [6:0]
    .hrc_rstctl_timer_value_i                                                        (hrc_rstctl_timer_value_i                                                        ), //parameter  [7:0]
    .pf1_sriov_cap_vf_device_id_reg_addr_byte2                                       (pf1_sriov_cap_vf_device_id_reg_addr_byte2                                       ), //parameter  [23:0]
    .pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte1                                     (pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte1                                     ), //parameter  [23:0]
    .pf0_bar1_start                                                                  (pf0_bar1_start                                                                  ), //parameter  [3:0]
    .pf0_link_capabilities_reg_rsvdp_23                                              (pf0_link_capabilities_reg_rsvdp_23                                              ), //parameter
    .pf0_reserved_27_addr                                                            (pf0_reserved_27_addr                                                            ), //parameter  [23:0]
    .pf0_sn_cap_version                                                              (pf0_sn_cap_version                                                              ), //parameter  [3:0]
    .pf0_dsp_tx_preset1                                                              (pf0_dsp_tx_preset1                                                              ), //parameter  [3:0]
    .pf0_dbi_reserved_50                                                             (pf0_dbi_reserved_50                                                             ), //parameter  [7:0]
    .pf0_vc0_p_data_credit                                                           (pf0_vc0_p_data_credit                                                           ), //parameter  [11:0]
    .pf0_pm_cap_cap_id_nxt_ptr_reg_addr_byte2                                        (pf0_pm_cap_cap_id_nxt_ptr_reg_addr_byte2                                        ), //parameter  [23:0]
    .vf1_pf1_tph_req_cap_ver                                                         (vf1_pf1_tph_req_cap_ver                                                         ), //parameter  [3:0]
    .vf1_pf0_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte2                               (vf1_pf0_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte2                               ), //parameter  [23:0]
    .pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte1                                     (pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte1                                     ), //parameter  [23:0]
    .cvp_hip_clk_sel_default                                                         (cvp_hip_clk_sel_default                                                         ), //parameter
    .pf0_lane_equalization_control67_reg_rsvdp_7                                     (pf0_lane_equalization_control67_reg_rsvdp_7                                     ), //parameter
    .pf1_bar1_type                                                                   (pf1_bar1_type                                                                   ), //parameter
    .pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte3                                     (pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte3                                     ), //parameter  [23:0]
    .pf0_gen3_equalization_disable                                                   (pf0_gen3_equalization_disable                                                   ), //parameter
    .pf0_lane_equalization_control67_reg_rsvdp_23                                    (pf0_lane_equalization_control67_reg_rsvdp_23                                    ), //parameter
    .pf0_fast_training_seq                                                           (pf0_fast_training_seq                                                           ), //parameter  [7:0]
    .pf0_dsp_rx_preset_hint5                                                         (pf0_dsp_rx_preset_hint5                                                         ), //parameter  [2:0]
    .pf0_port_logic_symbol_timer_filter_1_off_addr_byte1                             (pf0_port_logic_symbol_timer_filter_1_off_addr_byte1                             ), //parameter  [23:0]
    .pf0_sriov_cap_shadow_sriov_initial_vfs_addr_byte1                               (pf0_sriov_cap_shadow_sriov_initial_vfs_addr_byte1                               ), //parameter  [23:0]
    .pf1_sriov_next_offset                                                           (pf1_sriov_next_offset                                                           ), //parameter  [11:0]
    .pf1_type0_hdr_bar3_mask_reg_addr_byte3                                          (pf1_type0_hdr_bar3_mask_reg_addr_byte3                                          ), //parameter  [23:0]
    .pf1_reserved_4_addr                                                             (pf1_reserved_4_addr                                                             ), //parameter  [23:0]
    .pf1_sn_next_offset                                                              (pf1_sn_next_offset                                                              ), //parameter  [11:0]
    .virtual_pf0_prefetch_decode                                                     (virtual_pf0_prefetch_decode                                                     ), //parameter
    .hrc_pll_cal_done_active                                                         (hrc_pll_cal_done_active                                                         ), //parameter
    .pf0_sriov_vf_bar1_enabled                                                       (pf0_sriov_vf_bar1_enabled                                                       ), //parameter
    .pf1_pci_msix_enable_vfcomm_cs2                                                  (pf1_pci_msix_enable_vfcomm_cs2                                                  ), //parameter
    .pf0_pcie_cap_en_clk_power_man                                                   (pf0_pcie_cap_en_clk_power_man                                                   ), //parameter
    .pf1_sriov_cap_sriov_vf_offset_position_addr_byte3                               (pf1_sriov_cap_sriov_vf_offset_position_addr_byte3                               ), //parameter  [23:0]
    .pf0_tph_req_cap_reg_rsvdp_27                                                    (pf0_tph_req_cap_reg_rsvdp_27                                                    ), //parameter  [4:0]
    .pf0_type0_hdr_class_code_revision_id_addr_byte2                                 (pf0_type0_hdr_class_code_revision_id_addr_byte2                                 ), //parameter  [23:0]
    .pf0_tph_cap_tph_req_cap_reg_addr_byte3                                          (pf0_tph_cap_tph_req_cap_reg_addr_byte3                                          ), //parameter  [23:0]
    .pf0_sriov_cap_vf_bar5_reg_addr_byte0                                            (pf0_sriov_cap_vf_bar5_reg_addr_byte0                                            ), //parameter  [23:0]
    .pf0_pcie_cap_link_control_link_status_reg_addr_byte0                            (pf0_pcie_cap_link_control_link_status_reg_addr_byte0                            ), //parameter  [23:0]
    .pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte1                                     (pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte1                                     ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control67_reg_addr_byte1                        (pf0_spcie_cap_lane_equalization_control67_reg_addr_byte1                        ), //parameter  [23:0]
    .pf0_pci_type0_bar3_dummy_mask_7_1                                               (pf0_pci_type0_bar3_dummy_mask_7_1                                               ), //parameter  [6:0]
    .pf0_sriov_vf_bar5_start                                                         (pf0_sriov_vf_bar5_start                                                         ), //parameter  [3:0]
    .pf0_reserved_39_addr                                                            (pf0_reserved_39_addr                                                            ), //parameter  [23:0]
    .clock_ctl_rsvd_5                                                                (clock_ctl_rsvd_5                                                                ), //parameter
    .pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte1                               (pf1_tph_cap_tph_req_cap_reg_vfcomm_cs2_addr_byte1                               ), //parameter  [23:0]
    .pf1_sriov_vf_bar3_enabled                                                       (pf1_sriov_vf_bar3_enabled                                                       ), //parameter
    .pf1_bar4_mem_io                                                                 (pf1_bar4_mem_io                                                                 ), //parameter
    .clkmod_pclk_sel                                                                 (clkmod_pclk_sel                                                                 ), //parameter
    .pf0_vc_cap_version                                                              (pf0_vc_cap_version                                                              ), //parameter  [3:0]
    .pf0_reserved_5_addr                                                             (pf0_reserved_5_addr                                                             ), //parameter  [23:0]
    .pf0_pci_msix_enable                                                             (pf0_pci_msix_enable                                                             ), //parameter
    .pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte2                                    (pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte2                                    ), //parameter  [23:0]
    .pf1_forward_user_vsec                                                           (pf1_forward_user_vsec                                                           ), //parameter
    .pf0_reserved_20_addr                                                            (pf0_reserved_20_addr                                                            ), //parameter  [23:0]
    .pf0_tph_cap_tph_req_cap_reg_addr_byte0                                          (pf0_tph_cap_tph_req_cap_reg_addr_byte0                                          ), //parameter  [23:0]
    .pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte3                                     (pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte3                                     ), //parameter  [23:0]
    .pf0_dsp_tx_preset13                                                             (pf0_dsp_tx_preset13                                                             ), //parameter  [3:0]
    .pf1_shadow_link_capabilities_reg_shadow_rsvdp_23                                (pf1_shadow_link_capabilities_reg_shadow_rsvdp_23                                ), //parameter
    .pf0_dbi_reserved_37                                                             (pf0_dbi_reserved_37                                                             ), //parameter  [7:0]
    .hrc_rstctl_timer_type_h                                                         (hrc_rstctl_timer_type_h                                                         ), //parameter
    .pf1_aer_next_offset                                                             (pf1_aer_next_offset                                                             ), //parameter  [11:0]
    .pf1_sn_cap_ser_num_reg_dw_2_addr_byte2                                          (pf1_sn_cap_ser_num_reg_dw_2_addr_byte2                                          ), //parameter  [23:0]
    .pf0_pcie_cap_device_capabilities_reg_addr_byte2                                 (pf0_pcie_cap_device_capabilities_reg_addr_byte2                                 ), //parameter  [23:0]
    .pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte3                           (pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte3                           ), //parameter  [23:0]
    .clkmod_pld_clk_out_sel                                                          (clkmod_pld_clk_out_sel                                                          ), //parameter
    .pf0_sn_cap_ser_num_reg_dw_1_addr_byte1                                          (pf0_sn_cap_ser_num_reg_dw_1_addr_byte1                                          ), //parameter  [23:0]
    .pf0_msix_cap_msix_pba_offset_reg_addr_byte3                                     (pf0_msix_cap_msix_pba_offset_reg_addr_byte3                                     ), //parameter  [23:0]
    .pf1_pcie_cap_en_clk_power_man                                                   (pf1_pcie_cap_en_clk_power_man                                                   ), //parameter
    .pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte2                                     (pf0_sriov_cap_shadow_vf_bar2_reg_addr_byte2                                     ), //parameter  [23:0]
    .pf0_type0_hdr_bar1_mask_reg_addr_byte3                                          (pf0_type0_hdr_bar1_mask_reg_addr_byte3                                          ), //parameter  [23:0]
    .pf0_dbi_reserved_11                                                             (pf0_dbi_reserved_11                                                             ), //parameter  [7:0]
    .pf0_dsp_tx_preset4                                                              (pf0_dsp_tx_preset4                                                              ), //parameter  [3:0]
    .pf0_cap_id_nxt_ptr_reg_rsvdp_20                                                 (pf0_cap_id_nxt_ptr_reg_rsvdp_20                                                 ), //parameter
    .pf1_pcie_cap_link_bw_man_status                                                 (pf1_pcie_cap_link_bw_man_status                                                 ), //parameter
    .pf0_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvd                             (pf0_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvd                             ), //parameter
    .pld_tx_fifo_full_threshold                                                      (pld_tx_fifo_full_threshold                                                      ), //parameter  [5:0]
    .pf0_type0_hdr_class_code_revision_id_addr_byte0                                 (pf0_type0_hdr_class_code_revision_id_addr_byte0                                 ), //parameter  [23:0]
    .pf0_tph_req_no_st_mode_vfcomm_cs2                                               (pf0_tph_req_no_st_mode_vfcomm_cs2                                               ), //parameter
    .pf0_port_logic_gen3_eq_fb_mode_dir_change_off_addr_byte0                        (pf0_port_logic_gen3_eq_fb_mode_dir_change_off_addr_byte0                        ), //parameter  [23:0]
    .pf1_reserved_10_addr                                                            (pf1_reserved_10_addr                                                            ), //parameter  [23:0]
    .pf1_dbi_reserved_9                                                              (pf1_dbi_reserved_9                                                              ), //parameter  [7:0]
    .pf0_bar3_mem_io                                                                 (pf0_bar3_mem_io                                                                 ), //parameter
    .cvp_vsec_rev                                                                    (cvp_vsec_rev                                                                    ), //parameter  [3:0]
    .hrc_rstctl_timer_value_h                                                        (hrc_rstctl_timer_value_h                                                        ), //parameter  [7:0]
    .pf0_pcie_cap_link_capabilities_reg_addr_byte2                                   (pf0_pcie_cap_link_capabilities_reg_addr_byte2                                   ), //parameter  [23:0]
    .pf0_dbi_reserved_43                                                             (pf0_dbi_reserved_43                                                             ), //parameter  [7:0]
    .pf0_reserved_33_addr                                                            (pf0_reserved_33_addr                                                            ), //parameter  [23:0]
    .pf0_pcie_cap_slot_capabilities_reg_addr_byte3                                   (pf0_pcie_cap_slot_capabilities_reg_addr_byte3                                   ), //parameter  [23:0]
    .pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte3                        (pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte3                        ), //parameter  [23:0]
    .pf0_lane_equalization_control1011_reg_rsvdp_31                                  (pf0_lane_equalization_control1011_reg_rsvdp_31                                  ), //parameter
    .pf1_type0_hdr_bar5_mask_reg_addr_byte2                                          (pf1_type0_hdr_bar5_mask_reg_addr_byte2                                          ), //parameter  [23:0]
    .pf0_port_logic_port_link_ctrl_off_addr_byte2                                    (pf0_port_logic_port_link_ctrl_off_addr_byte2                                    ), //parameter  [23:0]
    .pf0_eq_eieos_cnt                                                                (pf0_eq_eieos_cnt                                                                ), //parameter
    .hrc_tx_lc_pll_rstb_active                                                       (hrc_tx_lc_pll_rstb_active                                                       ), //parameter
    .pf1_type0_hdr_class_code_revision_id_addr_byte3                                 (pf1_type0_hdr_class_code_revision_id_addr_byte3                                 ), //parameter  [23:0]
    .pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte3                                    (pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte3                                    ), //parameter  [23:0]
    .cvp_clk_sel                                                                     (cvp_clk_sel                                                                     ), //parameter
    .pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte1                                   (pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte1                                   ), //parameter  [23:0]
    .vf1_pf1_ari_cap_vf_ari_base_addr_byte3                                          (vf1_pf1_ari_cap_vf_ari_base_addr_byte3                                          ), //parameter  [23:0]
    .pf1_pcie_cap_device_capabilities_reg_addr_byte1                                 (pf1_pcie_cap_device_capabilities_reg_addr_byte1                                 ), //parameter  [23:0]
    .pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte3                                   (pf0_type0_hdr_exp_rom_bar_mask_reg_addr_byte3                                   ), //parameter  [23:0]
    .pf1_msix_cap_msix_pba_offset_reg_addr_byte0                                     (pf1_msix_cap_msix_pba_offset_reg_addr_byte0                                     ), //parameter  [23:0]
    .pf0_dsp_tx_preset10                                                             (pf0_dsp_tx_preset10                                                             ), //parameter  [3:0]
    .pf0_sriov_cap_vf_device_id_reg_addr_byte2                                       (pf0_sriov_cap_vf_device_id_reg_addr_byte2                                       ), //parameter  [23:0]
    .pf0_dsp_tx_preset15                                                             (pf0_dsp_tx_preset15                                                             ), //parameter  [3:0]
    .pf0_reserved_18_addr                                                            (pf0_reserved_18_addr                                                            ), //parameter  [23:0]
    .pf0_common_clk_n_fts                                                            (pf0_common_clk_n_fts                                                            ), //parameter  [7:0]
    .pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte3                                     (pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte3                                     ), //parameter  [23:0]
    .hrc_chnl_txpll_rst_en                                                           (hrc_chnl_txpll_rst_en                                                           ), //parameter  [15:0]
    .pf0_port_logic_queue_status_off_addr_byte3                                      (pf0_port_logic_queue_status_off_addr_byte3                                      ), //parameter  [23:0]
    .pf0_bar3_type                                                                   (pf0_bar3_type                                                                   ), //parameter
    .pf0_ats_next_offset                                                             (pf0_ats_next_offset                                                             ), //parameter  [11:0]
    .pf0_port_logic_gen2_ctrl_off_addr_byte1                                         (pf0_port_logic_gen2_ctrl_off_addr_byte1                                         ), //parameter  [23:0]
    .pf0_port_logic_gen3_related_off_addr_byte2                                      (pf0_port_logic_gen3_related_off_addr_byte2                                      ), //parameter  [23:0]
    .pf1_msix_cap_msix_pba_offset_reg_addr_byte1                                     (pf1_msix_cap_msix_pba_offset_reg_addr_byte1                                     ), //parameter  [23:0]
    .pf1_type0_hdr_bar1_reg_addr_byte0                                               (pf1_type0_hdr_bar1_reg_addr_byte0                                               ), //parameter  [23:0]
    .hrc_fref_clk_active                                                             (hrc_fref_clk_active                                                             ), //parameter
    .pf0_pcie_cap_max_link_speed                                                     (pf0_pcie_cap_max_link_speed                                                     ), //parameter
    .pf1_sriov_vf_bar1_enabled                                                       (pf1_sriov_vf_bar1_enabled                                                       ), //parameter
    .cfg_g3_pset_coeff_8                                                             (cfg_g3_pset_coeff_8                                                             ), //parameter  [17:0]
    .pf1_type0_hdr_bar0_mask_reg_addr_byte1                                          (pf1_type0_hdr_bar0_mask_reg_addr_byte1                                          ), //parameter  [23:0]
    .pf0_dbi_reserved_34                                                             (pf0_dbi_reserved_34                                                             ), //parameter  [7:0]
    .pf1_type0_hdr_bar1_mask_reg_addr_byte3                                          (pf1_type0_hdr_bar1_mask_reg_addr_byte3                                          ), //parameter  [23:0]
    .pf1_pcie_cap_link_auto_bw_int_en                                                (pf1_pcie_cap_link_auto_bw_int_en                                                ), //parameter
    .pf0_dsp_tx_preset7                                                              (pf0_dsp_tx_preset7                                                              ), //parameter  [3:0]
    .pf1_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte3              (pf1_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte3              ), //parameter  [23:0]
    .pf0_type0_hdr_bar5_mask_reg_addr_byte0                                          (pf0_type0_hdr_bar5_mask_reg_addr_byte0                                          ), //parameter  [23:0]
    .pf0_reserved_59_addr                                                            (pf0_reserved_59_addr                                                            ), //parameter  [23:0]
    .pf0_sriov_vf_bar5_type                                                          (pf0_sriov_vf_bar5_type                                                          ), //parameter
    .pf1_pcie_cap_link_capabilities_reg_addr_byte1                                   (pf1_pcie_cap_link_capabilities_reg_addr_byte1                                   ), //parameter  [23:0]
    .pf1_shadow_pcie_cap_dll_active_rep_cap                                          (pf1_shadow_pcie_cap_dll_active_rep_cap                                          ), //parameter
    .pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte2                                     (pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte2                                     ), //parameter  [23:0]
    .pf0_dbi_reserved_23                                                             (pf0_dbi_reserved_23                                                             ), //parameter  [7:0]
    .cfg_g3_pset_coeff_4                                                             (cfg_g3_pset_coeff_4                                                             ), //parameter  [17:0]
    .pf0_sn_cap_ser_num_reg_dw_2_addr_byte2                                          (pf0_sn_cap_ser_num_reg_dw_2_addr_byte2                                          ), //parameter  [23:0]
    .pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte1                                     (pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte1                                     ), //parameter  [23:0]
    .pf0_gen2_ctrl_off_rsvdp_22                                                      (pf0_gen2_ctrl_off_rsvdp_22                                                      ), //parameter  [1:0]
    .pf1_power_state                                                                 (pf1_power_state                                                                 ), //parameter  [1:0]
    .pf0_port_logic_pipe_loopback_control_off_addr_byte3                             (pf0_port_logic_pipe_loopback_control_off_addr_byte3                             ), //parameter  [23:0]
    .pf0_pcie_cap_en_no_snoop                                                        (pf0_pcie_cap_en_no_snoop                                                        ), //parameter
    .pf0_pcie_cap_enter_compliance                                                   (pf0_pcie_cap_enter_compliance                                                   ), //parameter
    .pf0_dsp_tx_preset9                                                              (pf0_dsp_tx_preset9                                                              ), //parameter  [3:0]
    .pf1_dbi_reserved_8                                                              (pf1_dbi_reserved_8                                                              ), //parameter  [7:0]
    .pf0_lane_equalization_control1415_reg_rsvdp_23                                  (pf0_lane_equalization_control1415_reg_rsvdp_23                                  ), //parameter
    .pf0_lane_equalization_control23_reg_rsvdp_7                                     (pf0_lane_equalization_control23_reg_rsvdp_7                                     ), //parameter
    .pf1_sriov_cap_vf_bar3_reg_addr_byte0                                            (pf1_sriov_cap_vf_bar3_reg_addr_byte0                                            ), //parameter  [23:0]
    .pf1_reserved_16_addr                                                            (pf1_reserved_16_addr                                                            ), //parameter  [23:0]
    .pf0_dbi_reserved_26                                                             (pf0_dbi_reserved_26                                                             ), //parameter  [7:0]
    .pf1_bar5_mem_io                                                                 (pf1_bar5_mem_io                                                                 ), //parameter
    .pf0_ats_capabilities_ctrl_reg_rsvdp_7                                           (pf0_ats_capabilities_ctrl_reg_rsvdp_7                                           ), //parameter
    .pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte0                                     (pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte0                                     ), //parameter  [23:0]
    .pf1_type0_hdr_bar4_reg_addr_byte0                                               (pf1_type0_hdr_bar4_reg_addr_byte0                                               ), //parameter  [23:0]
    .pf0_device_capabilities_reg_rsvdp_29                                            (pf0_device_capabilities_reg_rsvdp_29                                            ), //parameter  [2:0]
    .pf0_dbi_reserved_51                                                             (pf0_dbi_reserved_51                                                             ), //parameter  [7:0]
    .pf0_vc0_p_header_credit                                                         (pf0_vc0_p_header_credit                                                         ), //parameter  [7:0]
    .pf0_vf_bar1_reg_rsvdp_0                                                         (pf0_vf_bar1_reg_rsvdp_0                                                         ), //parameter
    .pf0_device_capabilities_reg_rsvdp_12                                            (pf0_device_capabilities_reg_rsvdp_12                                            ), //parameter  [2:0]
    .pf0_sriov_cap_sup_page_sizes_reg_addr_byte3                                     (pf0_sriov_cap_sup_page_sizes_reg_addr_byte3                                     ), //parameter  [23:0]
    .pf0_gen3_dc_balance_disable                                                     (pf0_gen3_dc_balance_disable                                                     ), //parameter
    .pf0_reserved_9_addr                                                             (pf0_reserved_9_addr                                                             ), //parameter  [23:0]
    .pf0_bar5_type                                                                   (pf0_bar5_type                                                                   ), //parameter
    .vf1_pf0_ari_next_offset                                                         (vf1_pf0_ari_next_offset                                                         ), //parameter  [11:0]
    .pf0_port_logic_gen3_eq_local_fs_lf_off_addr_byte1                               (pf0_port_logic_gen3_eq_local_fs_lf_off_addr_byte1                               ), //parameter  [23:0]
    .pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte3                                     (pf0_sriov_cap_shadow_vf_bar0_reg_addr_byte3                                     ), //parameter  [23:0]
    .pf1_sriov_cap_vf_bar0_reg_addr_byte0                                            (pf1_sriov_cap_vf_bar0_reg_addr_byte0                                            ), //parameter  [23:0]
    .vf1_pf1_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte2                               (vf1_pf1_tph_cap_vf_tph_ext_cap_hdr_reg_addr_byte2                               ), //parameter  [23:0]
    .pf1_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                (pf1_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_rsvdp_27_vfcomm_cs2                ), //parameter  [2:0]
    .pf1_exp_rom_bar_mask_reg_rsvdp_1                                                (pf1_exp_rom_bar_mask_reg_rsvdp_1                                                ), //parameter  [9:0]
    .pf1_exp_rom_base_addr_reg_rsvdp_1                                               (pf1_exp_rom_base_addr_reg_rsvdp_1                                               ), //parameter  [6:0]
    .pf0_tph_req_extended_tph_vfcomm_cs2                                             (pf0_tph_req_extended_tph_vfcomm_cs2                                             ), //parameter
    .pf1_link_capabilities_reg_rsvdp_23                                              (pf1_link_capabilities_reg_rsvdp_23                                              ), //parameter
    .pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte2                           (pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte2                           ), //parameter  [23:0]
    .pf0_tph_req_cap_ver                                                             (pf0_tph_req_cap_ver                                                             ), //parameter  [3:0]
    .pf1_pme_clk                                                                     (pf1_pme_clk                                                                     ), //parameter
    .pf1_sriov_initial_vfs_nonari                                                    (pf1_sriov_initial_vfs_nonari                                                    ), //parameter  [15:0]
    .pf0_link_control_link_status_reg_rsvdp_25                                       (pf0_link_control_link_status_reg_rsvdp_25                                       ), //parameter  [1:0]
    .k_phy_misc_ctrl_rsvd_13_15                                                      (k_phy_misc_ctrl_rsvd_13_15                                                      ), //parameter  [2:0]
    .cfg_dbi_pf1_start_addr                                                          (cfg_dbi_pf1_start_addr                                                          ), //parameter  [8:0]
    .pf0_sriov_cap_sriov_initial_vfs_addr_byte0                                      (pf0_sriov_cap_sriov_initial_vfs_addr_byte0                                      ), //parameter  [23:0]
    .pf0_pcie_cap_retrain_link                                                       (pf0_pcie_cap_retrain_link                                                       ), //parameter
    .pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte2                                     (pf1_sriov_cap_shadow_vf_bar2_reg_addr_byte2                                     ), //parameter  [23:0]
    .pf1_ari_cap_ari_base_addr_byte3                                                 (pf1_ari_cap_ari_base_addr_byte3                                                 ), //parameter  [23:0]
    .pf1_tph_cap_tph_req_cap_reg_addr_byte3                                          (pf1_tph_cap_tph_req_cap_reg_addr_byte3                                          ), //parameter  [23:0]
    .pf0_reserved_46_addr                                                            (pf0_reserved_46_addr                                                            ), //parameter  [23:0]
    .pf0_pm_cap_con_status_reg_addr_byte0                                            (pf0_pm_cap_con_status_reg_addr_byte0                                            ), //parameter  [23:0]
    .pf1_shadow_pcie_cap_aspm_opt_compliance                                         (pf1_shadow_pcie_cap_aspm_opt_compliance                                         ), //parameter
    .pf0_gen3_eq_local_fs_lf_off_rsvdp_12                                            (pf0_gen3_eq_local_fs_lf_off_rsvdp_12                                            ), //parameter  [3:0]
    .aux_cfg_vf_en                                                                   (aux_cfg_vf_en                                                                   ), //parameter
    .pf0_sn_cap_ser_num_reg_dw_2_addr_byte3                                          (pf0_sn_cap_ser_num_reg_dw_2_addr_byte3                                          ), //parameter  [23:0]
    .pf1_pcie_cap_link_bw_not_cap                                                    (pf1_pcie_cap_link_bw_not_cap                                                    ), //parameter
    .pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte1                                     (pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte1                                     ), //parameter  [23:0]
    .pf0_dbi_reserved_14                                                             (pf0_dbi_reserved_14                                                             ), //parameter  [7:0]
    .pf0_reserved_4_addr                                                             (pf0_reserved_4_addr                                                             ), //parameter  [23:0]
    .pf0_type0_hdr_bar0_reg_addr_byte0                                               (pf0_type0_hdr_bar0_reg_addr_byte0                                               ), //parameter  [23:0]
    .pf0_pcie_cap_active_state_link_pm_support                                       (pf0_pcie_cap_active_state_link_pm_support                                       ), //parameter
    .pf1_pci_msix_cap_next_offset                                                    (pf1_pci_msix_cap_next_offset                                                    ), //parameter  [7:0]
    .pf0_port_logic_vc0_cpl_rx_q_ctrl_off_addr_byte1                                 (pf0_port_logic_vc0_cpl_rx_q_ctrl_off_addr_byte1                                 ), //parameter  [23:0]
    .pf0_dbi_reserved_41                                                             (pf0_dbi_reserved_41                                                             ), //parameter  [7:0]
    .pf0_port_logic_vc0_p_rx_q_ctrl_off_addr_byte1                                   (pf0_port_logic_vc0_p_rx_q_ctrl_off_addr_byte1                                   ), //parameter  [23:0]
    .pf1_shadow_pcie_cap_max_link_width                                              (pf1_shadow_pcie_cap_max_link_width                                              ), //parameter  [1:0]
    .pf0_msix_cap_msix_pba_offset_reg_addr_byte0                                     (pf0_msix_cap_msix_pba_offset_reg_addr_byte0                                     ), //parameter  [23:0]
    .pld_tx_fifo_dyn_empty_dis                                                       (pld_tx_fifo_dyn_empty_dis                                                       ), //parameter
    .ecc_gen_val                                                                     (ecc_gen_val                                                                     ), //parameter
    .vf1_pf0_shadow_pcie_cap_aspm_opt_compliance                                     (vf1_pf0_shadow_pcie_cap_aspm_opt_compliance                                     ), //parameter
    .pf0_tph_cap_tph_req_cap_reg_addr_byte2                                          (pf0_tph_cap_tph_req_cap_reg_addr_byte2                                          ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte2                      (pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte2                      ), //parameter  [23:0]
    .pf1_vf_bar2_reg_rsvdp_0                                                         (pf1_vf_bar2_reg_rsvdp_0                                                         ), //parameter
    .pf1_type0_hdr_bar2_mask_reg_addr_byte2                                          (pf1_type0_hdr_bar2_mask_reg_addr_byte2                                          ), //parameter  [23:0]
    .pf0_dbi_reserved_8                                                              (pf0_dbi_reserved_8                                                              ), //parameter  [7:0]
    .pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte0                        (pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte0                        ), //parameter  [23:0]
    .pf1_type0_hdr_bar3_mask_reg_addr_byte0                                          (pf1_type0_hdr_bar3_mask_reg_addr_byte0                                          ), //parameter  [23:0]
    .hrc_tx_pcs_rst_n_active                                                         (hrc_tx_pcs_rst_n_active                                                         ), //parameter
    .pf0_aer_cap_root_err_status_off_addr_byte0                                      (pf0_aer_cap_root_err_status_off_addr_byte0                                      ), //parameter  [23:0]
    .pf0_spcie_cap_spcie_cap_header_reg_addr_byte2                                   (pf0_spcie_cap_spcie_cap_header_reg_addr_byte2                                   ), //parameter  [23:0]
    .pf0_shadow_pcie_cap_active_state_link_pm_support                                (pf0_shadow_pcie_cap_active_state_link_pm_support                                ), //parameter  [1:0]
    .pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte2                                (pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte2                                ), //parameter  [23:0]
    .pf0_reserved_3_addr                                                             (pf0_reserved_3_addr                                                             ), //parameter  [23:0]
    .pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte0                   (pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte0                   ), //parameter  [23:0]
    .pf0_dsp_tx_preset8                                                              (pf0_dsp_tx_preset8                                                              ), //parameter  [3:0]
    .pf0_scramble_disable                                                            (pf0_scramble_disable                                                            ), //parameter
    .pf1_reserved_1_addr                                                             (pf1_reserved_1_addr                                                             ), //parameter  [23:0]
    .pf0_port_logic_gen3_eq_fb_mode_dir_change_off_addr_byte2                        (pf0_port_logic_gen3_eq_fb_mode_dir_change_off_addr_byte2                        ), //parameter  [23:0]
    .pf0_reserved_40_addr                                                            (pf0_reserved_40_addr                                                            ), //parameter  [23:0]
    .vf1_pf1_ari_next_offset                                                         (vf1_pf1_ari_next_offset                                                         ), //parameter  [11:0]
    .pf0_dbi_reserved_53                                                             (pf0_dbi_reserved_53                                                             ), //parameter  [7:0]
    .pf0_reserved_22_addr                                                            (pf0_reserved_22_addr                                                            ), //parameter  [23:0]
    .pf1_pcie_cap_active_state_link_pm_control                                       (pf1_pcie_cap_active_state_link_pm_control                                       ), //parameter
    .pf1_type0_hdr_bist_header_type_latency_cache_line_size_reg_addr_byte2           (pf1_type0_hdr_bist_header_type_latency_cache_line_size_reg_addr_byte2           ), //parameter  [23:0]
    .pf0_sriov_cap_vf_device_id_reg_addr_byte3                                       (pf0_sriov_cap_vf_device_id_reg_addr_byte3                                       ), //parameter  [23:0]
    .pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte3                        (pf0_sriov_cap_shadow_sriov_vf_offset_position_addr_byte3                        ), //parameter  [23:0]
    .pf0_max_func_num                                                                (pf0_max_func_num                                                                ), //parameter
    .pf1_type0_hdr_bar4_mask_reg_addr_byte0                                          (pf1_type0_hdr_bar4_mask_reg_addr_byte0                                          ), //parameter  [23:0]
    .pf1_sriov_cap_sup_page_sizes_reg_addr_byte1                                     (pf1_sriov_cap_sup_page_sizes_reg_addr_byte1                                     ), //parameter  [23:0]
    .pf1_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvdp_31                         (pf1_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvdp_31                         ), //parameter
    .pf0_pci_msix_function_mask                                                      (pf0_pci_msix_function_mask                                                      ), //parameter
    .pf0_tph_req_cap_reg_vfcomm_cs2_rsvdp_3_vfcomm_cs2                               (pf0_tph_req_cap_reg_vfcomm_cs2_rsvdp_3_vfcomm_cs2                               ), //parameter  [4:0]
    .pf0_bar5_mem_io                                                                 (pf0_bar5_mem_io                                                                 ), //parameter
    .pf1_pci_type0_bar5_dummy_mask_7_1                                               (pf1_pci_type0_bar5_dummy_mask_7_1                                               ), //parameter  [6:0]
    .pf0_sriov_vf_bar3_prefetch                                                      (pf0_sriov_vf_bar3_prefetch                                                      ), //parameter
    .pf0_port_logic_vc0_np_rx_q_ctrl_off_addr_byte1                                  (pf0_port_logic_vc0_np_rx_q_ctrl_off_addr_byte1                                  ), //parameter  [23:0]
    .pf0_vf_bar2_reg_rsvdp_0                                                         (pf0_vf_bar2_reg_rsvdp_0                                                         ), //parameter
    .pf0_pcie_cap_link_bw_man_status                                                 (pf0_pcie_cap_link_bw_man_status                                                 ), //parameter
    .pf0_lane_equalization_control1011_reg_rsvdp_15                                  (pf0_lane_equalization_control1011_reg_rsvdp_15                                  ), //parameter
    .pf0_pci_msix_cap_id_next_ctrl_reg_rsvdp_27                                      (pf0_pci_msix_cap_id_next_ctrl_reg_rsvdp_27                                      ), //parameter  [2:0]
    .pf1_ats_cap_version                                                             (pf1_ats_cap_version                                                             ), //parameter  [3:0]
    .pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte1                      (pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte1                      ), //parameter  [23:0]
    .pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte1                        (pf1_sriov_cap_shadow_sriov_vf_offset_position_addr_byte1                        ), //parameter  [23:0]
    .pf1_type0_hdr_bar0_reg_addr_byte0                                               (pf1_type0_hdr_bar0_reg_addr_byte0                                               ), //parameter  [23:0]
    .pf0_lane_equalization_control23_reg_rsvdp_23                                    (pf0_lane_equalization_control23_reg_rsvdp_23                                    ), //parameter
    .pf0_port_logic_filter_mask_2_off_addr_byte2                                     (pf0_port_logic_filter_mask_2_off_addr_byte2                                     ), //parameter  [23:0]
    .pf0_dbi_reserved_12                                                             (pf0_dbi_reserved_12                                                             ), //parameter  [7:0]
    .pf1_reserved_13_addr                                                            (pf1_reserved_13_addr                                                            ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control23_reg_addr_byte0                        (pf0_spcie_cap_lane_equalization_control23_reg_addr_byte0                        ), //parameter  [23:0]
    .pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte1                   (pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte1                   ), //parameter  [23:0]
    .pf0_type0_hdr_max_latency_min_grant_interrupt_pin_interrupt_line_reg_addr_byte1 (pf0_type0_hdr_max_latency_min_grant_interrupt_pin_interrupt_line_reg_addr_byte1 ), //parameter  [23:0]
    .pf1_sriov_cap_sriov_initial_vfs_addr_byte1                                      (pf1_sriov_cap_sriov_initial_vfs_addr_byte1                                      ), //parameter  [23:0]
    .pf0_lane_equalization_control1415_reg_rsvdp_15                                  (pf0_lane_equalization_control1415_reg_rsvdp_15                                  ), //parameter
    .pf1_pm_spec_ver                                                                 (pf1_pm_spec_ver                                                                 ), //parameter  [2:0]
    .pf0_pci_msix_function_mask_vfcomm_cs2                                           (pf0_pci_msix_function_mask_vfcomm_cs2                                           ), //parameter
    .pf0_con_status_reg_rsvdp_4                                                      (pf0_con_status_reg_rsvdp_4                                                      ), //parameter  [3:0]
    .pf0_shadow_pcie_cap_link_bw_not_cap                                             (pf0_shadow_pcie_cap_link_bw_not_cap                                             ), //parameter
    .pf1_link_control_link_status_reg_rsvdp_9                                        (pf1_link_control_link_status_reg_rsvdp_9                                        ), //parameter
    .pf0_spcie_cap_lane_equalization_control01_reg_addr_byte1                        (pf0_spcie_cap_lane_equalization_control01_reg_addr_byte1                        ), //parameter  [23:0]
    .pf1_type0_hdr_bar2_mask_reg_addr_byte0                                          (pf1_type0_hdr_bar2_mask_reg_addr_byte0                                          ), //parameter  [23:0]
    .pf0_pcie_cap_aux_power_pm_en                                                    (pf0_pcie_cap_aux_power_pm_en                                                    ), //parameter
    .pf0_pcie_cap_clock_power_man                                                    (pf0_pcie_cap_clock_power_man                                                    ), //parameter
    .pf0_link_num                                                                    (pf0_link_num                                                                    ), //parameter  [7:0]
    .pf0_tph_cap_tph_req_cap_reg_addr_byte1                                          (pf0_tph_cap_tph_req_cap_reg_addr_byte1                                          ), //parameter  [23:0]
    .pf1_sriov_cap_vf_bar2_reg_addr_byte0                                            (pf1_sriov_cap_vf_bar2_reg_addr_byte0                                            ), //parameter  [23:0]
    .pf0_reserved_16_addr                                                            (pf0_reserved_16_addr                                                            ), //parameter  [23:0]
    .pf1_msix_cap_msix_table_offset_reg_addr_byte0                                   (pf1_msix_cap_msix_table_offset_reg_addr_byte0                                   ), //parameter  [23:0]
    .pf0_tph_cap_tph_ext_cap_hdr_reg_addr_byte2                                      (pf0_tph_cap_tph_ext_cap_hdr_reg_addr_byte2                                      ), //parameter  [23:0]
    .pf1_reserved_12_addr                                                            (pf1_reserved_12_addr                                                            ), //parameter  [23:0]
    .vf1_pf1_shadow_pcie_cap_dll_active_rep_cap                                      (vf1_pf1_shadow_pcie_cap_dll_active_rep_cap                                      ), //parameter
    .pf0_type0_hdr_pci_cap_ptr_reg_addr_byte0                                        (pf0_type0_hdr_pci_cap_ptr_reg_addr_byte0                                        ), //parameter  [23:0]
    .pf1_bar2_start                                                                  (pf1_bar2_start                                                                  ), //parameter  [3:0]
    .pf0_revision_id                                                                 (pf0_revision_id                                                                 ), //parameter  [7:0]
    .pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte1                      (pf0_spcie_cap_lane_equalization_control1415_reg_addr_byte1                      ), //parameter  [23:0]
    .pf1_sriov_vf_bar5_prefetch                                                      (pf1_sriov_vf_bar5_prefetch                                                      ), //parameter
    .pf0_pcie_cap_device_capabilities_reg_addr_byte0                                 (pf0_pcie_cap_device_capabilities_reg_addr_byte0                                 ), //parameter  [23:0]
    .hrc_rstctl_timer_value_a                                                        (hrc_rstctl_timer_value_a                                                        ), //parameter  [7:0]
    .pf0_reserved_57_addr                                                            (pf0_reserved_57_addr                                                            ), //parameter  [23:0]
    .vsec_next_offset                                                                (vsec_next_offset                                                                ), //parameter  [11:0]
    .pf1_multi_func                                                                  (pf1_multi_func                                                                  ), //parameter
    .pf0_port_logic_symbol_timer_filter_1_off_addr_byte2                             (pf0_port_logic_symbol_timer_filter_1_off_addr_byte2                             ), //parameter  [23:0]
    .pf1_dbi_reserved_11                                                             (pf1_dbi_reserved_11                                                             ), //parameter  [7:0]
    .pf0_spcie_cap_lane_equalization_control89_reg_addr_byte2                        (pf0_spcie_cap_lane_equalization_control89_reg_addr_byte2                        ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte3                      (pf0_spcie_cap_lane_equalization_control1011_reg_addr_byte3                      ), //parameter  [23:0]
    .pf1_vf_forward_user_vsec                                                        (pf1_vf_forward_user_vsec                                                        ), //parameter
    .pf1_pcie_cap_link_control_link_status_reg_addr_byte1                            (pf1_pcie_cap_link_control_link_status_reg_addr_byte1                            ), //parameter  [23:0]
    .pf0_type0_hdr_bar5_mask_reg_addr_byte3                                          (pf0_type0_hdr_bar5_mask_reg_addr_byte3                                          ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control89_reg_addr_byte1                        (pf0_spcie_cap_lane_equalization_control89_reg_addr_byte1                        ), //parameter  [23:0]
    .virtual_pf0_sriov_num_vf_ari                                                    (virtual_pf0_sriov_num_vf_ari                                                    ), //parameter  [15:0]
    .pf1_bar4_start                                                                  (pf1_bar4_start                                                                  ), //parameter  [3:0]
    .pf0_port_link_ctrl_off_rsvdp_4                                                  (pf0_port_link_ctrl_off_rsvdp_4                                                  ), //parameter
    .pf0_link_control_link_status_reg_rsvdp_2                                        (pf0_link_control_link_status_reg_rsvdp_2                                        ), //parameter
    .vf1_pf1_ari_cap_version                                                         (vf1_pf1_ari_cap_version                                                         ), //parameter  [3:0]
    .pf0_dbi_reserved_44                                                             (pf0_dbi_reserved_44                                                             ), //parameter  [7:0]
    .pf0_vc0_p_tlp_q_mode                                                            (pf0_vc0_p_tlp_q_mode                                                            ), //parameter  [2:0]
    .pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte3                                     (pf0_sriov_cap_shadow_vf_bar1_reg_addr_byte3                                     ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control01_reg_addr_byte3                        (pf0_spcie_cap_lane_equalization_control01_reg_addr_byte3                        ), //parameter  [23:0]
    .pf0_pcie_cap_link_training                                                      (pf0_pcie_cap_link_training                                                      ), //parameter
    .pf1_shadow_pcie_cap_surprise_down_err_rep_cap                                   (pf1_shadow_pcie_cap_surprise_down_err_rep_cap                                   ), //parameter
    .pf0_sriov_cap_sriov_base_reg_addr_byte2                                         (pf0_sriov_cap_sriov_base_reg_addr_byte2                                         ), //parameter  [23:0]
    .pf1_sriov_vf_bar3_prefetch                                                      (pf1_sriov_vf_bar3_prefetch                                                      ), //parameter
    .pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte1                                   (pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte1                                   ), //parameter  [23:0]
    .pf1_tph_cap_tph_req_cap_reg_addr_byte0                                          (pf1_tph_cap_tph_req_cap_reg_addr_byte0                                          ), //parameter  [23:0]
    .pf1_tph_req_next_ptr                                                            (pf1_tph_req_next_ptr                                                            ), //parameter  [11:0]
    .pf1_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvd                             (pf1_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_rsvd                             ), //parameter
    .pf0_type0_hdr_device_id_vendor_id_reg_addr_byte1                                (pf0_type0_hdr_device_id_vendor_id_reg_addr_byte1                                ), //parameter  [23:0]
    .pf0_reserved_47_addr                                                            (pf0_reserved_47_addr                                                            ), //parameter  [23:0]
    .sim_mode                                                                        (sim_mode                                                                        ), //parameter
    .vf_reserved_1_addr                                                              (vf_reserved_1_addr                                                              ), //parameter  [23:0]
    .pf1_pcie_cap_tx_margin                                                          (pf1_pcie_cap_tx_margin                                                          ), //parameter
    .pf0_dbi_reserved_22                                                             (pf0_dbi_reserved_22                                                             ), //parameter  [7:0]
    .pf1_sriov_vf_bar3_type                                                          (pf1_sriov_vf_bar3_type                                                          ), //parameter
    .pf0_reserved_36_addr                                                            (pf0_reserved_36_addr                                                            ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control23_reg_addr_byte2                        (pf0_spcie_cap_lane_equalization_control23_reg_addr_byte2                        ), //parameter  [23:0]
    .pf0_reserved_30_addr                                                            (pf0_reserved_30_addr                                                            ), //parameter  [23:0]
    .pf1_pcie_cap_hw_auto_speed_disable                                              (pf1_pcie_cap_hw_auto_speed_disable                                              ), //parameter
    .pf0_type0_hdr_bar2_reg_addr_byte0                                               (pf0_type0_hdr_bar2_reg_addr_byte0                                               ), //parameter  [23:0]
    .pf1_sriov_cap_sriov_base_reg_addr_byte3                                         (pf1_sriov_cap_sriov_base_reg_addr_byte3                                         ), //parameter  [23:0]
    .pf1_sriov_vf_bar1_start                                                         (pf1_sriov_vf_bar1_start                                                         ), //parameter  [3:0]
    .pf1_ats_cap_ats_cap_hdr_reg_addr_byte3                                          (pf1_ats_cap_ats_cap_hdr_reg_addr_byte3                                          ), //parameter  [23:0]
    .pf0_type0_hdr_bar1_mask_reg_addr_byte0                                          (pf0_type0_hdr_bar1_mask_reg_addr_byte0                                          ), //parameter  [23:0]
    .vf1_pf1_shadow_pcie_cap_aspm_opt_compliance                                     (vf1_pf1_shadow_pcie_cap_aspm_opt_compliance                                     ), //parameter
    .pf0_sriov_vf_bar1_prefetch                                                      (pf0_sriov_vf_bar1_prefetch                                                      ), //parameter
    .pf0_sriov_vf_bar1_start                                                         (pf0_sriov_vf_bar1_start                                                         ), //parameter  [3:0]
    .pf0_lane_equalization_control1213_reg_rsvdp_7                                   (pf0_lane_equalization_control1213_reg_rsvdp_7                                   ), //parameter
    .pf1_shadow_pcie_cap_clock_power_man                                             (pf1_shadow_pcie_cap_clock_power_man                                             ), //parameter
    .pf0_type0_hdr_bar3_enable_reg_addr_byte0                                        (pf0_type0_hdr_bar3_enable_reg_addr_byte0                                        ), //parameter  [23:0]
    .pf1_type0_hdr_bar3_enable_reg_addr_byte0                                        (pf1_type0_hdr_bar3_enable_reg_addr_byte0                                        ), //parameter  [23:0]
    .pf0_dbi_reserved_24                                                             (pf0_dbi_reserved_24                                                             ), //parameter  [7:0]
    .hip_pcs_chnl_en                                                                 (hip_pcs_chnl_en                                                                 ), //parameter  [15:0]
    .pf0_pme_clk                                                                     (pf0_pme_clk                                                                     ), //parameter
    .pf0_sriov_cap_sup_page_sizes_reg_addr_byte0                                     (pf0_sriov_cap_sup_page_sizes_reg_addr_byte0                                     ), //parameter  [23:0]
    .pf1_type0_hdr_bar5_reg_addr_byte0                                               (pf1_type0_hdr_bar5_reg_addr_byte0                                               ), //parameter  [23:0]
    .pf0_reserved_7_addr                                                             (pf0_reserved_7_addr                                                             ), //parameter  [23:0]
    .pf0_lane_equalization_control67_reg_rsvdp_15                                    (pf0_lane_equalization_control67_reg_rsvdp_15                                    ), //parameter
    .pf0_pcie_cap_tx_margin                                                          (pf0_pcie_cap_tx_margin                                                          ), //parameter
    .pf0_vc0_np_data_credit                                                          (pf0_vc0_np_data_credit                                                          ), //parameter  [11:0]
    .pf0_dsp_rx_preset_hint1                                                         (pf0_dsp_rx_preset_hint1                                                         ), //parameter  [2:0]
    .pf0_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte2                             (pf0_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte2                             ), //parameter  [23:0]
    .pf0_ari_cap_ari_base_addr_byte2                                                 (pf0_ari_cap_ari_base_addr_byte2                                                 ), //parameter  [23:0]
    .pf1_bar5_type                                                                   (pf1_bar5_type                                                                   ), //parameter
    .pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte2                           (pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte2                           ), //parameter  [23:0]
    .cvp_mode_gating_dis                                                             (cvp_mode_gating_dis                                                             ), //parameter
    .pf0_sriov_vf_bar5_prefetch                                                      (pf0_sriov_vf_bar5_prefetch                                                      ), //parameter
    .pf0_gen1_ei_inference                                                           (pf0_gen1_ei_inference                                                           ), //parameter
    .pf1_type0_hdr_class_code_revision_id_addr_byte1                                 (pf1_type0_hdr_class_code_revision_id_addr_byte1                                 ), //parameter  [23:0]
    .pf1_sn_cap_ser_num_reg_dw_1_addr_byte0                                          (pf1_sn_cap_ser_num_reg_dw_1_addr_byte0                                          ), //parameter  [23:0]
    .pf0_pcie_cap_max_payload_size                                                   (pf0_pcie_cap_max_payload_size                                                   ), //parameter
    .pf0_pcie_cap_max_read_req_size                                                  (pf0_pcie_cap_max_read_req_size                                                  ), //parameter  [2:0]
    .pf0_reserved_15_addr                                                            (pf0_reserved_15_addr                                                            ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte2                      (pf0_spcie_cap_lane_equalization_control1213_reg_addr_byte2                      ), //parameter  [23:0]
    .pf1_dbi_reserved_16                                                             (pf1_dbi_reserved_16                                                             ), //parameter  [7:0]
    .pf1_reserved_14_addr                                                            (pf1_reserved_14_addr                                                            ), //parameter  [23:0]
    .pf1_pci_type0_bar1_enabled_or_mask64lsb                                         (pf1_pci_type0_bar1_enabled_or_mask64lsb                                         ), //parameter
    .pf0_dsp_rx_preset_hint11                                                        (pf0_dsp_rx_preset_hint11                                                        ), //parameter  [2:0]
    .vf_dbi_reserved_2                                                               (vf_dbi_reserved_2                                                               ), //parameter  [7:0]
    .pf1_link_control_link_status_reg_rsvdp_25                                       (pf1_link_control_link_status_reg_rsvdp_25                                       ), //parameter  [1:0]
    .pf1_pcie_cap_phantom_func_en                                                    (pf1_pcie_cap_phantom_func_en                                                    ), //parameter
    .pf1_pcie_cap_phantom_func_support                                               (pf1_pcie_cap_phantom_func_support                                               ), //parameter  [1:0]
    .cvp_rate_sel                                                                    (cvp_rate_sel                                                                    ), //parameter
    .pf1_msix_cap_msix_table_offset_reg_addr_byte2                                   (pf1_msix_cap_msix_table_offset_reg_addr_byte2                                   ), //parameter  [23:0]
    .pf0_dbi_reserved_13                                                             (pf0_dbi_reserved_13                                                             ), //parameter  [7:0]
    .pf0_reserved_1_addr                                                             (pf0_reserved_1_addr                                                             ), //parameter  [23:0]
    .pf1_dbi_reserved_17                                                             (pf1_dbi_reserved_17                                                             ), //parameter  [7:0]
    .pf0_dsp_rx_preset_hint2                                                         (pf0_dsp_rx_preset_hint2                                                         ), //parameter  [2:0]
    .pf1_sriov_cap_sup_page_sizes_reg_addr_byte0                                     (pf1_sriov_cap_sup_page_sizes_reg_addr_byte0                                     ), //parameter  [23:0]
    .pf0_reserved8                                                                   (pf0_reserved8                                                                   ), //parameter
    .pf1_sriov_cap_sup_page_sizes_reg_addr_byte2                                     (pf1_sriov_cap_sup_page_sizes_reg_addr_byte2                                     ), //parameter  [23:0]
    .pf0_sn_cap_ser_num_reg_dw_2_addr_byte0                                          (pf0_sn_cap_ser_num_reg_dw_2_addr_byte0                                          ), //parameter  [23:0]
    .pf1_type0_hdr_bar0_mask_reg_addr_byte3                                          (pf1_type0_hdr_bar0_mask_reg_addr_byte3                                          ), //parameter  [23:0]
    .pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte2                                     (pf0_sriov_cap_shadow_vf_bar3_reg_addr_byte2                                     ), //parameter  [23:0]
    .pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte0                                    (pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte0                                    ), //parameter  [23:0]
    .pf0_lane_equalization_control45_reg_rsvdp_15                                    (pf0_lane_equalization_control45_reg_rsvdp_15                                    ), //parameter
    .pf1_sn_cap_ser_num_reg_dw_2_addr_byte0                                          (pf1_sn_cap_ser_num_reg_dw_2_addr_byte0                                          ), //parameter  [23:0]
    .pf0_port_logic_filter_mask_2_off_addr_byte0                                     (pf0_port_logic_filter_mask_2_off_addr_byte0                                     ), //parameter  [23:0]
    .pf0_sriov_cap_sriov_vf_offset_position_addr_byte3                               (pf0_sriov_cap_sriov_vf_offset_position_addr_byte3                               ), //parameter  [23:0]
    .pf0_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte3              (pf0_pcie_cap_pcie_cap_id_pcie_next_cap_ptr_pcie_cap_reg_addr_byte3              ), //parameter  [23:0]
    .pf1_tph_cap_tph_ext_cap_hdr_reg_addr_byte3                                      (pf1_tph_cap_tph_ext_cap_hdr_reg_addr_byte3                                      ), //parameter  [23:0]
    .pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte3                                (pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte3                                ), //parameter  [23:0]
    .pf0_sriov_cap_sriov_vf_offset_position_addr_byte2                               (pf0_sriov_cap_sriov_vf_offset_position_addr_byte2                               ), //parameter  [23:0]
    .pf0_port_logic_vc0_cpl_rx_q_ctrl_off_addr_byte0                                 (pf0_port_logic_vc0_cpl_rx_q_ctrl_off_addr_byte0                                 ), //parameter  [23:0]
    .pf0_dsp_rx_preset_hint9                                                         (pf0_dsp_rx_preset_hint9                                                         ), //parameter  [2:0]
    .pf1_type0_hdr_bar4_mask_reg_addr_byte2                                          (pf1_type0_hdr_bar4_mask_reg_addr_byte2                                          ), //parameter  [23:0]
    .pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte3                                     (pf1_sriov_cap_shadow_vf_bar0_reg_addr_byte3                                     ), //parameter  [23:0]
    .pf1_reserved_6_addr                                                             (pf1_reserved_6_addr                                                             ), //parameter  [23:0]
    .pf1_type0_hdr_bar4_mask_reg_addr_byte3                                          (pf1_type0_hdr_bar4_mask_reg_addr_byte3                                          ), //parameter  [23:0]
    .pf1_sriov_vf_bar5_dummy_mask_7_1                                                (pf1_sriov_vf_bar5_dummy_mask_7_1                                                ), //parameter  [6:0]
    .pf1_sriov_vf_bar2_start                                                         (pf1_sriov_vf_bar2_start                                                         ), //parameter  [3:0]
    .pf0_pcie_cap_slot_capabilities_reg_addr_byte0                                   (pf0_pcie_cap_slot_capabilities_reg_addr_byte0                                   ), //parameter  [23:0]
    .pf0_cross_link_en                                                               (pf0_cross_link_en                                                               ), //parameter
    .pf0_dsp_tx_preset3                                                              (pf0_dsp_tx_preset3                                                              ), //parameter  [3:0]
    .pf1_reserved_0_addr                                                             (pf1_reserved_0_addr                                                             ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control67_reg_addr_byte0                        (pf0_spcie_cap_lane_equalization_control67_reg_addr_byte0                        ), //parameter  [23:0]
    .pld_aib_loopback_en                                                             (pld_aib_loopback_en                                                             ), //parameter
    .pf1_bar5_start                                                                  (pf1_bar5_start                                                                  ), //parameter  [3:0]
    .pf1_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte1                             (pf1_msi_cap_pci_msi_cap_id_next_ctrl_reg_addr_byte1                             ), //parameter  [23:0]
    .pf1_pci_msix_function_mask                                                      (pf1_pci_msix_function_mask                                                      ), //parameter
    .pf0_type0_hdr_bar3_mask_reg_addr_byte2                                          (pf0_type0_hdr_bar3_mask_reg_addr_byte2                                          ), //parameter  [23:0]
    .pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte2                                     (pf1_sriov_cap_shadow_vf_bar3_reg_addr_byte2                                     ), //parameter  [23:0]
    .pf0_reserved_56_addr                                                            (pf0_reserved_56_addr                                                            ), //parameter  [23:0]
    .pf0_port_logic_queue_status_off_addr_byte2                                      (pf0_port_logic_queue_status_off_addr_byte2                                      ), //parameter  [23:0]
    .pf0_type0_hdr_bar1_enable_reg_addr_byte0                                        (pf0_type0_hdr_bar1_enable_reg_addr_byte0                                        ), //parameter  [23:0]
    .pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte3                                     (pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte3                                     ), //parameter  [23:0]
    .pf0_dbi_reserved_9                                                              (pf0_dbi_reserved_9                                                              ), //parameter  [7:0]
    .cfg_g3_pset_coeff_2                                                             (cfg_g3_pset_coeff_2                                                             ), //parameter  [17:0]
    .pf1_bar3_type                                                                   (pf1_bar3_type                                                                   ), //parameter
    .pf1_pcie_cap_aspm_opt_compliance                                                (pf1_pcie_cap_aspm_opt_compliance                                                ), //parameter
    .pf1_ari_next_offset                                                             (pf1_ari_next_offset                                                             ), //parameter  [11:0]
    .eqctrl_legacy_mode_en                                                           (eqctrl_legacy_mode_en                                                           ), //parameter
    .hrc_force_inactive_rst                                                          (hrc_force_inactive_rst                                                          ), //parameter
    .hrc_rstctl_timer_value_j                                                        (hrc_rstctl_timer_value_j                                                        ), //parameter  [7:0]
    .pf0_dsp_rx_preset_hint13                                                        (pf0_dsp_rx_preset_hint13                                                        ), //parameter  [2:0]
    .pf1_dbi_reserved_10                                                             (pf1_dbi_reserved_10                                                             ), //parameter  [7:0]
    .pf1_reserved_3_addr                                                             (pf1_reserved_3_addr                                                             ), //parameter  [23:0]
    .pf0_pcie_cap_link_control_link_status_reg_addr_byte2                            (pf0_pcie_cap_link_control_link_status_reg_addr_byte2                            ), //parameter  [23:0]
    .pf0_pcie_cap_nego_link_width                                                    (pf0_pcie_cap_nego_link_width                                                    ), //parameter
    .pld_tx_fifo_empty_threshold_2                                                   (pld_tx_fifo_empty_threshold_2                                                   ), //parameter  [3:0]
    .hrc_rstctl_timer_value_f                                                        (hrc_rstctl_timer_value_f                                                        ), //parameter  [7:0]
    .pf0_pcie_cap_link_capabilities_reg_addr_byte0                                   (pf0_pcie_cap_link_capabilities_reg_addr_byte0                                   ), //parameter  [23:0]
    .pf1_sriov_initial_vfs_ari_cs2                                                   (pf1_sriov_initial_vfs_ari_cs2                                                   ), //parameter  [15:0]
    .pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte1                   (pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte1                   ), //parameter  [23:0]
    .pf1_type0_hdr_bar5_mask_reg_addr_byte0                                          (pf1_type0_hdr_bar5_mask_reg_addr_byte0                                          ), //parameter  [23:0]
    .pf0_exp_rom_bar_mask_reg_rsvdp_1                                                (pf0_exp_rom_bar_mask_reg_rsvdp_1                                                ), //parameter  [9:0]
    .pf0_exp_rom_base_addr_reg_rsvdp_1                                               (pf0_exp_rom_base_addr_reg_rsvdp_1                                               ), //parameter  [6:0]
    .pf0_dbi_reserved_21                                                             (pf0_dbi_reserved_21                                                             ), //parameter  [7:0]
    .pf1_reserved_18_addr                                                            (pf1_reserved_18_addr                                                            ), //parameter  [23:0]
    .pf0_pcie_cap_device_control_device_status_addr_byte1                            (pf0_pcie_cap_device_control_device_status_addr_byte1                            ), //parameter  [23:0]
    .pf0_pcie_cap_dll_active_rep_cap                                                 (pf0_pcie_cap_dll_active_rep_cap                                                 ), //parameter
    .pf1_dbi_reserved_12                                                             (pf1_dbi_reserved_12                                                             ), //parameter  [7:0]
    .pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte3                   (pf0_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte3                   ), //parameter  [23:0]
    .pf1_pcie_cap_link_control_link_status_reg_addr_byte2                            (pf1_pcie_cap_link_control_link_status_reg_addr_byte2                            ), //parameter  [23:0]
    .pf0_spcie_cap_lane_equalization_control67_reg_addr_byte2                        (pf0_spcie_cap_lane_equalization_control67_reg_addr_byte2                        ), //parameter  [23:0]
    .pf0_type0_hdr_bar2_mask_reg_addr_byte2                                          (pf0_type0_hdr_bar2_mask_reg_addr_byte2                                          ), //parameter  [23:0]
    .pf0_type0_hdr_device_id_vendor_id_reg_addr_byte3                                (pf0_type0_hdr_device_id_vendor_id_reg_addr_byte3                                ), //parameter  [23:0]
    .pf0_vf_bar3_reg_rsvdp_0                                                         (pf0_vf_bar3_reg_rsvdp_0                                                         ), //parameter
    .pf0_pcie_cap_link_control2_link_status2_reg_addr_byte0                          (pf0_pcie_cap_link_control2_link_status2_reg_addr_byte0                          ), //parameter  [23:0]
    .pf0_spcie_cap_spcie_cap_header_reg_addr_byte3                                   (pf0_spcie_cap_spcie_cap_header_reg_addr_byte3                                   ), //parameter  [23:0]
    .pf0_sn_cap_sn_base_addr_byte2                                                   (pf0_sn_cap_sn_base_addr_byte2                                                   ), //parameter  [23:0]
    .pf0_vf_bar4_reg_rsvdp_0                                                         (pf0_vf_bar4_reg_rsvdp_0                                                         ), //parameter
    .pf0_pcie_cap_slot_capabilities_reg_addr_byte2                                   (pf0_pcie_cap_slot_capabilities_reg_addr_byte2                                   ), //parameter  [23:0]
    .pf1_tph_req_cap_reg_rsvdp_3                                                     (pf1_tph_req_cap_reg_rsvdp_3                                                     ), //parameter  [4:0]
    .pf0_shadow_pcie_cap_surprise_down_err_rep_cap                                   (pf0_shadow_pcie_cap_surprise_down_err_rep_cap                                   ), //parameter
    .vf1_pf1_pcie_cap_vf_shadow_link_capabilities_reg_addr_byte1                     (vf1_pf1_pcie_cap_vf_shadow_link_capabilities_reg_addr_byte1                     ), //parameter  [23:0]
    .pf0_dbi_reserved_10                                                             (pf0_dbi_reserved_10                                                             ), //parameter  [7:0]
    .pf0_skp_int_val                                                                 (pf0_skp_int_val                                                                 ), //parameter  [10:0]
    .pf0_tph_req_cap_reg_rsvdp_11                                                    (pf0_tph_req_cap_reg_rsvdp_11                                                    ), //parameter  [4:0]
    .pf0_reserved_54_addr                                                            (pf0_reserved_54_addr                                                            ), //parameter  [23:0]
    .pf0_dbi_reserved_3                                                              (pf0_dbi_reserved_3                                                              ), //parameter  [7:0]
    .pf0_sriov_cap_version                                                           (pf0_sriov_cap_version                                                           ), //parameter  [3:0]
    .pf0_lane_equalization_control67_reg_rsvdp_31                                    (pf0_lane_equalization_control67_reg_rsvdp_31                                    ), //parameter
    .pf0_gen3_eq_local_lf                                                            (pf0_gen3_eq_local_lf                                                            ), //parameter  [5:0]
    .pf0_sriov_vf_bar3_enabled                                                       (pf0_sriov_vf_bar3_enabled                                                       ), //parameter
    .pf0_reserved_28_addr                                                            (pf0_reserved_28_addr                                                            ), //parameter  [23:0]
    .pf0_reset_assert                                                                (pf0_reset_assert                                                                ), //parameter
    .pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte2                (pf0_msix_cap_pci_msix_cap_id_next_ctrl_reg_vfcomm_cs2_addr_byte2                ), //parameter  [23:0]
    .pf1_pcie_cap_surprise_down_err_rep_cap                                          (pf1_pcie_cap_surprise_down_err_rep_cap                                          ), //parameter
    .hrc_chnl_txpll_master_cgb_rst_en                                                (hrc_chnl_txpll_master_cgb_rst_en                                                ), //parameter  [15:0]
    .pf0_dsp_rx_preset_hint10                                                        (pf0_dsp_rx_preset_hint10                                                        ), //parameter  [2:0]
    .pf1_tph_req_extended_tph_vfcomm_cs2                                             (pf1_tph_req_extended_tph_vfcomm_cs2                                             ), //parameter
    .pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte1                                     (pf1_sriov_cap_shadow_vf_bar5_reg_addr_byte1                                     ), //parameter  [23:0]
    .pf1_sriov_vf_bar1_type                                                          (pf1_sriov_vf_bar1_type                                                          ), //parameter
    .pf0_pcie_cap_link_bw_not_cap                                                    (pf0_pcie_cap_link_bw_not_cap                                                    ), //parameter
    .pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte3                   (pf1_type0_hdr_subsystem_id_subsystem_vendor_id_reg_addr_byte3                   ), //parameter  [23:0]
    .pf1_ats_cap_ats_capabilities_ctrl_reg_addr_byte0                                (pf1_ats_cap_ats_capabilities_ctrl_reg_addr_byte0                                ), //parameter  [23:0]
    .pf0_lane_equalization_control23_reg_rsvdp_31                                    (pf0_lane_equalization_control23_reg_rsvdp_31                                    ), //parameter
    .pf0_sn_cap_ser_num_reg_dw_1_addr_byte2                                          (pf0_sn_cap_ser_num_reg_dw_1_addr_byte2                                          ), //parameter  [23:0]
    .pf0_dsp_tx_preset2                                                              (pf0_dsp_tx_preset2                                                              ), //parameter  [3:0]
    .pf0_dsp_tx_preset12                                                             (pf0_dsp_tx_preset12                                                             ), //parameter  [3:0]
    .pf1_dbi_reserved_15                                                             (pf1_dbi_reserved_15                                                             ), //parameter  [7:0]
    .pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte3                                    (pf0_type0_hdr_cardbus_cis_ptr_reg_addr_byte3                                    ), //parameter  [23:0]
    .pf0_dbi_reserved_52                                                             (pf0_dbi_reserved_52                                                             ), //parameter  [7:0]
    .pf1_vf_bar5_reg_rsvdp_0                                                         (pf1_vf_bar5_reg_rsvdp_0                                                         ), //parameter
    .pf1_type0_hdr_bar2_reg_addr_byte0                                               (pf1_type0_hdr_bar2_reg_addr_byte0                                               ), //parameter  [23:0]
    .pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte0                                (pf0_type0_hdr_rp_exp_rom_bar_mask_reg_addr_byte0                                ), //parameter  [23:0]
    .pf0_vc_cap_vc_base_addr_byte2                                                   (pf0_vc_cap_vc_base_addr_byte2                                                   ), //parameter  [23:0]
    .pf0_dbi_reserved_31                                                             (pf0_dbi_reserved_31                                                             ), //parameter  [7:0]
    .pf0_link_disable                                                                (pf0_link_disable                                                                ), //parameter
    .pf0_sriov_cap_sriov_vf_offset_position_addr_byte1                               (pf0_sriov_cap_sriov_vf_offset_position_addr_byte1                               ), //parameter  [23:0]
    .pf0_pcie_cap_link_bw_man_int_en                                                 (pf0_pcie_cap_link_bw_man_int_en                                                 ), //parameter
    .pf0_aer_cap_version                                                             (pf0_aer_cap_version                                                             ), //parameter  [3:0]
    .pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte0                                     (pf1_sriov_cap_shadow_vf_bar4_reg_addr_byte0                                     ), //parameter  [23:0]
    .pf0_port_logic_ack_f_aspm_ctrl_off_addr_byte2                                   (pf0_port_logic_ack_f_aspm_ctrl_off_addr_byte2                                   ), //parameter  [23:0]
    .pf0_vf_forward_user_vsec                                                        (pf0_vf_forward_user_vsec                                                        ), //parameter
    .pf1_bar0_start                                                                  (pf1_bar0_start                                                                  ), //parameter  [3:0]
    .pf0_ari_cap_version                                                             (pf0_ari_cap_version                                                             ), //parameter  [3:0]
    .pf0_config_tx_comp_rx                                                           (pf0_config_tx_comp_rx                                                           ), //parameter
    .pf0_type0_hdr_bar4_reg_addr_byte0                                               (pf0_type0_hdr_bar4_reg_addr_byte0                                               ), //parameter  [23:0]
    .cfg_vf_table_size                                                               (cfg_vf_table_size                                                               ), //parameter  [4:0]
    .pf0_dbi_reserved_17                                                             (pf0_dbi_reserved_17                                                             ), //parameter  [7:0]
    .pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte2                                   (pf1_type0_hdr_exp_rom_bar_mask_reg_addr_byte2                                   ), //parameter  [23:0]
    .pf0_dsp_rx_preset_hint15                                                        (pf0_dsp_rx_preset_hint15                                                        ), //parameter  [2:0]
    .pf1_aer_cap_aer_ext_cap_hdr_off_addr_byte3                                      (pf1_aer_cap_aer_ext_cap_hdr_off_addr_byte3                                      ), //parameter  [23:0]
    .pf0_vc0_np_tlp_q_mode                                                           (pf0_vc0_np_tlp_q_mode                                                           ), //parameter  [2:0]
    .pf1_sn_cap_ser_num_reg_dw_1_addr_byte3                                          (pf1_sn_cap_ser_num_reg_dw_1_addr_byte3                                          ), //parameter  [23:0]
    .pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte0                                     (pf1_sriov_cap_shadow_vf_bar1_reg_addr_byte0                                     ), //parameter  [23:0]
    .vf_reserved_0_addr                                                              (vf_reserved_0_addr                                                              ), //parameter  [23:0]
    .pf0_queue_status_off_rsvdp_29                                                   (pf0_queue_status_off_rsvdp_29                                                   ), //parameter  [1:0]
    .pf0_misc_control_1_off_rsvdp_1                                                  (pf0_misc_control_1_off_rsvdp_1                                                  ), //parameter  [6:0]
    .pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte2                                     (pf0_sriov_cap_shadow_vf_bar5_reg_addr_byte2                                     ), //parameter  [23:0]
    .pf0_sriov_cap_vf_bar1_reg_addr_byte0                                            (pf0_sriov_cap_vf_bar1_reg_addr_byte0                                            ), //parameter  [23:0]
    .pf1_pci_type0_bar3_dummy_mask_7_1                                               (pf1_pci_type0_bar3_dummy_mask_7_1                                               ), //parameter  [6:0]
    .pf0_dbi_reserved_29                                                             (pf0_dbi_reserved_29                                                             ), //parameter  [7:0]
    .pf0_reserved_0_addr                                                             (pf0_reserved_0_addr                                                             ), //parameter  [23:0]
    .pf0_pm_spec_ver                                                                 (pf0_pm_spec_ver                                                                 ), //parameter  [2:0]
    .pf0_shadow_pcie_cap_aspm_opt_compliance                                         (pf0_shadow_pcie_cap_aspm_opt_compliance                                         ), //parameter
    .pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte1                           (pf1_msix_cap_pci_msix_cap_id_next_ctrl_reg_addr_byte1                           ), //parameter  [23:0]
    .pf1_pcie_cap_link_bw_man_int_en                                                 (pf1_pcie_cap_link_bw_man_int_en                                                 ), //parameter
    .pf0_disable_fc_wd_timer                                                         (pf0_disable_fc_wd_timer                                                         ), //parameter
    .pf0_pipe_loopback_control_off_rsvdp_27                                          (pf0_pipe_loopback_control_off_rsvdp_27                                          ), //parameter  [3:0]
    .pf0_reserved_35_addr                                                            (pf0_reserved_35_addr                                                            ), //parameter  [23:0]
    .pf1_sriov_cap_sriov_vf_offset_position_addr_byte2                               (pf1_sriov_cap_sriov_vf_offset_position_addr_byte2                               ), //parameter  [23:0]
    .pf0_reserved_49_addr                                                            (pf0_reserved_49_addr                                                            ), //parameter  [23:0]
    .pf1_sn_cap_version                                                              (pf1_sn_cap_version                                                              ), //parameter  [3:0]
    .pf0_num_of_lanes                                                                (pf0_num_of_lanes                                                                ), //parameter  [4:0]
    .pf0_pcie_cap_shadow_link_capabilities_reg_addr_byte1                            (pf0_pcie_cap_shadow_link_capabilities_reg_addr_byte1                            ), //parameter  [23:0]
    .pf0_bar1_prefetch                                                               (pf0_bar1_prefetch                                                               ), //parameter
    .pf0_sriov_initial_vfs_nonari                                                    (pf0_sriov_initial_vfs_nonari                                                    ), //parameter  [15:0]
    .pf1_pcie_cap_common_clk_config                                                  (pf1_pcie_cap_common_clk_config                                                  ), //parameter
    .pf1_pcie_cap_link_capabilities_reg_addr_byte3                                   (pf1_pcie_cap_link_capabilities_reg_addr_byte3                                   ), //parameter  [23:0]
    .pf1_pm_cap_cap_id_nxt_ptr_reg_addr_byte2                                        (pf1_pm_cap_cap_id_nxt_ptr_reg_addr_byte2                                        ), //parameter  [23:0]
    .eco_flops                                                                       (eco_flops                                                                       ), //parameter  [11:0]
    .pf1_pcie_cap_target_link_speed                                                  (pf1_pcie_cap_target_link_speed                                                  ), //parameter
    .pf1_type0_hdr_pci_cap_ptr_reg_addr_byte0                                        (pf1_type0_hdr_pci_cap_ptr_reg_addr_byte0                                        ), //parameter  [23:0]
    .eqctrl_dir_mode_en                                                              (eqctrl_dir_mode_en                                                              ), //parameter
    .pf0_pcie_cap_extended_synch                                                     (pf0_pcie_cap_extended_synch                                                     ), //parameter
    .pld_aux_gate_en                                                                 (pld_aux_gate_en                                                                 ), //parameter
    .pf0_gen3_related_off_rsvdp_13                                                   (pf0_gen3_related_off_rsvdp_13                                                   ), //parameter  [2:0]
    .pf0_reserved_6_addr                                                             (pf0_reserved_6_addr                                                             ), //parameter  [23:0]
    .pf0_msix_cap_msix_table_offset_reg_addr_byte0                                   (pf0_msix_cap_msix_table_offset_reg_addr_byte0                                   ), //parameter  [23:0]
    .pf0_msix_cap_msix_pba_offset_reg_addr_byte2                                     (pf0_msix_cap_msix_pba_offset_reg_addr_byte2                                     ), //parameter  [23:0]
    .pf0_reserved_42_addr                                                            (pf0_reserved_42_addr                                                            ), //parameter  [23:0]
    .pf0_tph_req_cap_reg_vfcomm_cs2_rsvdp_11_vfcomm_cs2                              (pf0_tph_req_cap_reg_vfcomm_cs2_rsvdp_11_vfcomm_cs2                              ), //parameter  [4:0]
    .pf0_device_capabilities_reg_rsvdp_16                                            (pf0_device_capabilities_reg_rsvdp_16                                            ), //parameter  [3:0]
    .crs_override_value                                                              (crs_override_value                                                              ), //parameter
    .pf0_vc0_cpl_data_credit                                                         (pf0_vc0_cpl_data_credit                                                         ), //parameter  [11:0]
    .pf0_reserved_19_addr                                                            (pf0_reserved_19_addr                                                            ), //parameter  [23:0]
    .pf0_rp_exp_rom_bar_mask_reg_rp_rom_rsvdp_1                                      (pf0_rp_exp_rom_bar_mask_reg_rp_rom_rsvdp_1                                      ), //parameter  [9:0]
    .pf0_port_logic_gen3_eq_control_off_addr_byte2                                   (pf0_port_logic_gen3_eq_control_off_addr_byte2                                   ), //parameter  [23:0]
    .cfg_vf_num_pf0                                                                  (cfg_vf_num_pf0                                                                  ), //parameter  [7:0]
    .vf1_pf0_ari_cap_vf_ari_base_addr_byte3                                          (vf1_pf0_ari_cap_vf_ari_base_addr_byte3                                          ), //parameter  [23:0]
    .pf1_pcie_cap_link_auto_bw_status                                                (pf1_pcie_cap_link_auto_bw_status                                                ), //parameter
    .pf1_msix_cap_msix_pba_offset_reg_addr_byte3                                     (pf1_msix_cap_msix_pba_offset_reg_addr_byte3                                     ), //parameter  [23:0]
    .pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte1                                    (pf1_type0_hdr_cardbus_cis_ptr_reg_addr_byte1                                    ), //parameter  [23:0]
    .pf1_ats_capabilities_ctrl_reg_rsvdp_7                                           (pf1_ats_capabilities_ctrl_reg_rsvdp_7                                           ), //parameter
    .pf0_ats_cap_ats_cap_hdr_reg_addr_byte3                                          (pf0_ats_cap_ats_cap_hdr_reg_addr_byte3                                          ), //parameter  [23:0]
    .pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte2                                     (pf0_sriov_cap_shadow_vf_bar4_reg_addr_byte2                                     ), //parameter  [23:0]
    .pf0_pcie_cap_device_capabilities_reg_addr_byte1                                 (pf0_pcie_cap_device_capabilities_reg_addr_byte1                                 ), //parameter  [23:0]
    .pf1_dbi_reserved_7                                                              (pf1_dbi_reserved_7                                                              ), //parameter  [7:0]
    .pf0_port_logic_filter_mask_2_off_addr_byte3                                     (pf0_port_logic_filter_mask_2_off_addr_byte3                                     ), //parameter  [23:0]
    .eqctrl_num_fom_cycles                                                           (eqctrl_num_fom_cycles                                                           ), //parameter  [3:0]
    .pf1_type0_hdr_bar3_reg_addr_byte0                                               (pf1_type0_hdr_bar3_reg_addr_byte0                                               ), //parameter  [23:0]
    .pf1_sriov_vf_bar3_dummy_mask_7_1                                                (pf1_sriov_vf_bar3_dummy_mask_7_1                                                ), //parameter  [6:0]
    .vf1_pf0_tph_req_cap_ver                                                         (vf1_pf0_tph_req_cap_ver                                                         ), //parameter  [3:0]
    .pf1_type0_hdr_bar1_mask_reg_addr_byte2                                          (pf1_type0_hdr_bar1_mask_reg_addr_byte2                                          ), //parameter  [23:0]
    .pf1_dbi_reserved_2                                                              (pf1_dbi_reserved_2                                                              ), //parameter  [7:0]
    .pf0_lane_equalization_control89_reg_rsvdp_15                                    (pf0_lane_equalization_control89_reg_rsvdp_15                                    ), //parameter
    .pf0_type0_hdr_bar0_mask_reg_addr_byte1                                          (pf0_type0_hdr_bar0_mask_reg_addr_byte1                                          ), //parameter  [23:0]
    .pf1_pci_msix_function_mask_vfcomm_cs2                                           (pf1_pci_msix_function_mask_vfcomm_cs2                                           ), //parameter
    .silicon_rev                                                                     (silicon_rev                                                                     ), //parameter
    .tx_avst_dsk_en                                                                  (tx_avst_dsk_en                                                                  ), //parameter
    .vf_dbi_reserved_4                                                               (vf_dbi_reserved_4                                                               ), //parameter  [7:0]
    .vf_dbi_reserved_5                                                               (vf_dbi_reserved_5                                                               ), //parameter  [7:0]
    .vf_reserved_4_addr                                                              (vf_reserved_4_addr                                                              ), //parameter  [23:0]
    .vf_reserved_5_addr                                                              (vf_reserved_5_addr                                                              ), //parameter  [23:0]
    .virtual_ep_native                                                               (virtual_ep_native                                                               ), //parameter

    //Misc IPTCL Top Level Parameters
    .enable_test_out_hwtcl                                                           (enable_test_out_hwtcl                                                           ), //parameter
    .hip_reconfig_hwtcl                                                              (hip_reconfig_hwtcl                                                              ),  //parameter
    .xcvr_reconfig_hwtcl                                                             (xcvr_reconfig_hwtcl                                                             )  //parameter

  ) hip (

    //Clk and reset
    .refclk                                                                          (refclk                                                                          ), // input
    .coreclkout_hip                                                                  (coreclkout_hip                                                                  ), // output
    .npor                                                                            (npor                                                                            ), // input
    .pin_perst                                                                       (pin_perst                                                                       ), // input
    .reset_status                                                                    (reset_status_hip                                                                ), // output
    .clr_st                                                                          (                                                                                ), // output   : Unused in Bridge
    .pld_warm_rst_rdy                                                                (1'b1                                                                            ), // input    : Unused in Bridge
    .link_req_rst_n                                                                  (                                                                                ), // output   : Unused in Bridge

    //AVST Signals
    //RX Data Path
    .rx_st_ready                                                                     (rx_st_ready                                                                     ), // input
    .rx_st_sop                                                                       (rx_st_sop                                                                       ), // output
    .rx_st_eop                                                                       (rx_st_eop                                                                       ), // output
    .rx_st_data                                                                      (rx_st_data                                                                      ), // output     [255:0]
    .rx_st_parity                                                                    (rx_st_parity                                                                    ), // output     [31:0]
    .rx_st_valid                                                                     (rx_st_valid                                                                     ), // output
    .rx_st_bar_range                                                                 (rx_st_bar_range                                                                 ), // output     [2:0]
    .rx_st_empty                                                                     (rx_st_empty                                                                     ), // output     [2:0]

    //TX Data Path
    .tx_st_sop                                                                       (tx_st_sop                                                                       ), // input
    .tx_st_eop                                                                       (tx_st_eop                                                                       ), // input
    .tx_st_data                                                                      (tx_st_data                                                                      ), // input      [255:0]
    .tx_st_parity                                                                    (tx_st_parity                                                                    ), // input      [31:0]
    .tx_st_valid                                                                     (tx_st_valid                                                                     ), // input
    .tx_st_err                                                                       (tx_st_err                                                                       ), // input
    .tx_st_ready                                                                     (tx_st_ready                                                                     ), // output

    //TX Credit Interface
    .tx_cdts_type                                                                    (tx_cdts_type                                                                    ), // output     [1:0]
    .tx_data_cdts_consumed                                                           (tx_data_cdts_consumed                                                           ), // output
    .tx_hdr_cdts_consumed                                                            (tx_hdr_cdts_consumed                                                            ), // output
    .tx_cdts_data_value                                                              (tx_cdts_data_value                                                              ), // output     [1:0]
    .tx_pd_cdts                                                                      (tx_pd_cdts                                                                      ), // output     [11:0]
    .tx_npd_cdts                                                                     (tx_npd_cdts                                                                     ), // output     [11:0]
    .tx_cpld_cdts                                                                    (tx_cpld_cdts                                                                    ), // output     [11:0]
    .tx_ph_cdts                                                                      (tx_ph_cdts                                                                      ), // output     [7:0]
    .tx_nph_cdts                                                                     (tx_nph_cdts                                                                     ), // output     [7:0]
    .tx_cplh_cdts                                                                    (tx_cplh_cdts                                                                    ), // output     [7:0]

    //AVMM DPRIO Interface
    .hip_reconfig_rst_n                                                              (hip_reconfig_rst_n                                                              ), // input
    .hip_reconfig_waitrequest                                                        (hip_reconfig_waitrequest                                                        ), // output
    .hip_reconfig_read                                                               (hip_reconfig_read                                                               ), // input
    .hip_reconfig_address                                                            (hip_reconfig_address                                                            ), // input      [20:0]
    .hip_reconfig_write                                                              (hip_reconfig_write                                                              ), // input
    .hip_reconfig_writedata                                                          (hip_reconfig_writedata                                                          ), // input      [7:0]
    .hip_reconfig_clk                                                                (hip_reconfig_clk                                                                ), // input
    .hip_reconfig_readdatavalid                                                      (hip_reconfig_readdatavalid                                                      ), // output
    .hip_reconfig_readdata                                                           (hip_reconfig_readdata                                                           ), // output     [7:0]


    //MSI and legacy Interrupt
    .app_msi_req                                                                     (1'b0                                                                            ), // input            : Unused in Bridge
    .app_msi_ack                                                                     (                                                                                ), // output           : Unused in Bridge
    .app_msi_tc                                                                      (3'b000                                                                          ), // input      [2:0] : Unused in Bridge
    .app_msi_num                                                                     (5'b00000                                                                        ), // input      [4:0] : Unused in Bridge
    .app_int_sts                                                                     (app_int_sts                                                                     ), // input
    .int_status                                                                      (int_status                                                                      ), // output     [7:0]
    .int_status_common                                                               (int_status_common                                                               ), // output     [2:0]



    //Error & cfg_tl Interface
    //cfg_tl
    .tl_cfg_func                                                                     (tl_cfg_func                                                                     ), // output     [1:0]
    .tl_cfg_add                                                                      (tl_cfg_add                                                                      ), // output     [4:0]
    .tl_cfg_ctl                                                                      (tl_cfg_ctl                                                                      ), // output     [31:0]

    //Error
    .serr_out                                                                        (                                                                                ), // output           : Unused in Bridge
    .app_err_valid                                                                   (1'b0                                                                            ), // input            : Unused in Bridge
    .app_err_hdr                                                                     (32'h0                                                                           ), // input      [31:0]: Unused in Bridge
    .app_err_info                                                                    (11'h0                                                                           ), // input      [10:0]: Unused in Bridge

    .derr_cor_ext_rpl                                                                (derr_cor_ext_rpl                                                                ), // output
    .derr_rpl                                                                        (derr_rpl                                                                        ), // output
    .derr_cor_ext_rcv                                                                (derr_cor_ext_rcv                                                                ), // output
    .derr_uncor_ext_rcv                                                              (derr_uncor_ext_rcv                                                              ), // output

    .rx_par_err                                                                      (rx_par_err                                                                      ), // output
    .tx_par_err                                                                      (tx_par_err                                                                      ), // output


    //Status & Link Training Interface
    .serdes_pll_locked                                                               (serdes_pll_locked                                                               ), // output           : Unused in Bridge
    .pld_core_ready                                                                  (serdes_pll_locked                                                               ), // input
    .pld_clk_inuse                                                                   (pld_clk_inuse                                                                   ), // output
    .link_up                                                                         (link_up                                                                         ), // output
    .ltssmstate                                                                      (ltssmstate                                                                      ), // output     [5:0]
    .currentspeed                                                                    (currentspeed                                                                    ), // output     [1:0]
    .lane_act                                                                        (lane_act                                                                        ), // output     [4:0]

    //CEB Interface
    .ceb_req                                                                         (ceb_req                                                                         ), // output
    .ceb_ack                                                                         (ceb_ack                                                                         ), // input
    .ceb_addr                                                                        (ceb_addr                                                                        ), // output     [31:0]
    .ceb_din                                                                         (ceb_din                                                                         ), // input      [31:0]
    .ceb_dout                                                                        (ceb_dout                                                                        ), // output     [31:0]
    .ceb_wr                                                                          (ceb_wr                                                                          ), // output     [3:0]

    //PM signals
    .pm_linkst_in_l1                                                                 (                                                                                ), // output            : Unsed in Bridge
    .pm_linkst_in_l0s                                                                (                                                                                ), // output            : Unsed in Bridge
    .pm_state                                                                        (                                                                                ), // output     [2:0]  : Unsed in Bridge
    .pm_dstate                                                                       (                                                                                ), // output     [2:0]  : Unsed in Bridge
    .apps_pm_xmt_pme                                                                 (1'b0                                                                            ), // input             : Unsed in Bridge
    .apps_ready_entr_l23                                                             (1'b0                                                                            ), // input             : Unsed in Bridge
    .apps_pm_xmt_turnoff                                                             (1'b0                                                                            ), // input             : Unsed in Bridge
    .app_init_rst                                                                    (1'b0                                                                            ), // input             : Unsed in Bridge
    .app_xfer_pending                                                                (1'b0                                                                            ), // input             : Unsed in Bridge


    // PIPE Interface Signals
    .simu_mode_pipe                                                                  (simu_mode_pipe                                                                  ), // input
    .sim_pipe_pclk_in                                                                (sim_pipe_pclk_in                                                                ), // input
    .sim_pipe_pclk_out                                                               (                                                                                ), // output            : Unused in Bridge
    .sim_pipe_rate                                                                   (sim_pipe_rate                                                                   ), // output     [1:0]
    .sim_ltssmstate                                                                  (sim_ltssmstate                                                                  ), // output     [5:0]

    //OUTPUT PIPE Interface Signals
    .txdata0                                                                         (txdata0                                                                         ), // output     [31:0]
    .txdata1                                                                         (txdata1                                                                         ), // output     [31:0]
    .txdata2                                                                         (txdata2                                                                         ), // output     [31:0]
    .txdata3                                                                         (txdata3                                                                         ), // output     [31:0]
    .txdata4                                                                         (txdata4                                                                         ), // output     [31:0]
    .txdata5                                                                         (txdata5                                                                         ), // output     [31:0]
    .txdata6                                                                         (txdata6                                                                         ), // output     [31:0]
    .txdata7                                                                         (txdata7                                                                         ), // output     [31:0]
    .txdata8                                                                         (txdata8                                                                         ), // output     [31:0]
    .txdata9                                                                         (txdata9                                                                         ), // output     [31:0]
    .txdata10                                                                        (txdata10                                                                        ), // output     [31:0]
    .txdata11                                                                        (txdata11                                                                        ), // output     [31:0]
    .txdata12                                                                        (txdata12                                                                        ), // output     [31:0]
    .txdata13                                                                        (txdata13                                                                        ), // output     [31:0]
    .txdata14                                                                        (txdata14                                                                        ), // output     [31:0]
    .txdata15                                                                        (txdata15                                                                        ), // output     [31:0]

    .txdatak0                                                                        (txdatak0                                                                        ), // output     [3:0]
    .txdatak1                                                                        (txdatak1                                                                        ), // output     [3:0]
    .txdatak2                                                                        (txdatak2                                                                        ), // output     [3:0]
    .txdatak3                                                                        (txdatak3                                                                        ), // output     [3:0]
    .txdatak4                                                                        (txdatak4                                                                        ), // output     [3:0]
    .txdatak5                                                                        (txdatak5                                                                        ), // output     [3:0]
    .txdatak6                                                                        (txdatak6                                                                        ), // output     [3:0]
    .txdatak7                                                                        (txdatak7                                                                        ), // output     [3:0]
    .txdatak8                                                                        (txdatak8                                                                        ), // output     [3:0]
    .txdatak9                                                                        (txdatak9                                                                        ), // output     [3:0]
    .txdatak10                                                                       (txdatak10                                                                       ), // output     [3:0]
    .txdatak11                                                                       (txdatak11                                                                       ), // output     [3:0]
    .txdatak12                                                                       (txdatak12                                                                       ), // output     [3:0]
    .txdatak13                                                                       (txdatak13                                                                       ), // output     [3:0]
    .txdatak14                                                                       (txdatak14                                                                       ), // output     [3:0]
    .txdatak15                                                                       (txdatak15                                                                       ), // output     [3:0]

    .txcompl0                                                                        (txcompl0                                                                        ), // output
    .txcompl1                                                                        (txcompl1                                                                        ), // output
    .txcompl2                                                                        (txcompl2                                                                        ), // output
    .txcompl3                                                                        (txcompl3                                                                        ), // output
    .txcompl4                                                                        (txcompl4                                                                        ), // output
    .txcompl5                                                                        (txcompl5                                                                        ), // output
    .txcompl6                                                                        (txcompl6                                                                        ), // output
    .txcompl7                                                                        (txcompl7                                                                        ), // output
    .txcompl8                                                                        (txcompl8                                                                        ), // output
    .txcompl9                                                                        (txcompl9                                                                        ), // output
    .txcompl10                                                                       (txcompl10                                                                       ), // output
    .txcompl11                                                                       (txcompl11                                                                       ), // output
    .txcompl12                                                                       (txcompl12                                                                       ), // output
    .txcompl13                                                                       (txcompl13                                                                       ), // output
    .txcompl14                                                                       (txcompl14                                                                       ), // output
    .txcompl15                                                                       (txcompl15                                                                       ), // output

    .txelecidle0                                                                     (txelecidle0                                                                     ), // output
    .txelecidle1                                                                     (txelecidle1                                                                     ), // output
    .txelecidle2                                                                     (txelecidle2                                                                     ), // output
    .txelecidle3                                                                     (txelecidle3                                                                     ), // output
    .txelecidle4                                                                     (txelecidle4                                                                     ), // output
    .txelecidle5                                                                     (txelecidle5                                                                     ), // output
    .txelecidle6                                                                     (txelecidle6                                                                     ), // output
    .txelecidle7                                                                     (txelecidle7                                                                     ), // output
    .txelecidle8                                                                     (txelecidle8                                                                     ), // output
    .txelecidle9                                                                     (txelecidle9                                                                     ), // output
    .txelecidle10                                                                    (txelecidle10                                                                    ), // output
    .txelecidle11                                                                    (txelecidle11                                                                    ), // output
    .txelecidle12                                                                    (txelecidle12                                                                    ), // output
    .txelecidle13                                                                    (txelecidle13                                                                    ), // output
    .txelecidle14                                                                    (txelecidle14                                                                    ), // output
    .txelecidle15                                                                    (txelecidle15                                                                    ), // output

    .txdetectrx0                                                                     (txdetectrx0                                                                     ), // output
    .txdetectrx1                                                                     (txdetectrx1                                                                     ), // output
    .txdetectrx2                                                                     (txdetectrx2                                                                     ), // output
    .txdetectrx3                                                                     (txdetectrx3                                                                     ), // output
    .txdetectrx4                                                                     (txdetectrx4                                                                     ), // output
    .txdetectrx5                                                                     (txdetectrx5                                                                     ), // output
    .txdetectrx6                                                                     (txdetectrx6                                                                     ), // output
    .txdetectrx7                                                                     (txdetectrx7                                                                     ), // output
    .txdetectrx8                                                                     (txdetectrx8                                                                     ), // output
    .txdetectrx9                                                                     (txdetectrx9                                                                     ), // output
    .txdetectrx10                                                                    (txdetectrx10                                                                    ), // output
    .txdetectrx11                                                                    (txdetectrx11                                                                    ), // output
    .txdetectrx12                                                                    (txdetectrx12                                                                    ), // output
    .txdetectrx13                                                                    (txdetectrx13                                                                    ), // output
    .txdetectrx14                                                                    (txdetectrx14                                                                    ), // output
    .txdetectrx15                                                                    (txdetectrx15                                                                    ), // output

    .powerdown0                                                                      (powerdown0                                                                      ), // output     [1:0]
    .powerdown1                                                                      (powerdown1                                                                      ), // output     [1:0]
    .powerdown2                                                                      (powerdown2                                                                      ), // output     [1:0]
    .powerdown3                                                                      (powerdown3                                                                      ), // output     [1:0]
    .powerdown4                                                                      (powerdown4                                                                      ), // output     [1:0]
    .powerdown5                                                                      (powerdown5                                                                      ), // output     [1:0]
    .powerdown6                                                                      (powerdown6                                                                      ), // output     [1:0]
    .powerdown7                                                                      (powerdown7                                                                      ), // output     [1:0]
    .powerdown8                                                                      (powerdown8                                                                      ), // output     [1:0]
    .powerdown9                                                                      (powerdown9                                                                      ), // output     [1:0]
    .powerdown10                                                                     (powerdown10                                                                     ), // output     [1:0]
    .powerdown11                                                                     (powerdown11                                                                     ), // output     [1:0]
    .powerdown12                                                                     (powerdown12                                                                     ), // output     [1:0]
    .powerdown13                                                                     (powerdown13                                                                     ), // output     [1:0]
    .powerdown14                                                                     (powerdown14                                                                     ), // output     [1:0]
    .powerdown15                                                                     (powerdown15                                                                     ), // output     [1:0]

    .txmargin0                                                                       (txmargin0                                                                       ), // output     [2:0]
    .txmargin1                                                                       (txmargin1                                                                       ), // output     [2:0]
    .txmargin2                                                                       (txmargin2                                                                       ), // output     [2:0]
    .txmargin3                                                                       (txmargin3                                                                       ), // output     [2:0]
    .txmargin4                                                                       (txmargin4                                                                       ), // output     [2:0]
    .txmargin5                                                                       (txmargin5                                                                       ), // output     [2:0]
    .txmargin6                                                                       (txmargin6                                                                       ), // output     [2:0]
    .txmargin7                                                                       (txmargin7                                                                       ), // output     [2:0]
    .txmargin8                                                                       (txmargin8                                                                       ), // output     [2:0]
    .txmargin9                                                                       (txmargin9                                                                       ), // output     [2:0]
    .txmargin10                                                                      (txmargin10                                                                      ), // output     [2:0]
    .txmargin11                                                                      (txmargin11                                                                      ), // output     [2:0]
    .txmargin12                                                                      (txmargin12                                                                      ), // output     [2:0]
    .txmargin13                                                                      (txmargin13                                                                      ), // output     [2:0]
    .txmargin14                                                                      (txmargin14                                                                      ), // output     [2:0]
    .txmargin15                                                                      (txmargin15                                                                      ), // output     [2:0]

    .txdeemph0                                                                       (txdeemph0                                                                       ), // output
    .txdeemph1                                                                       (txdeemph1                                                                       ), // output
    .txdeemph2                                                                       (txdeemph2                                                                       ), // output
    .txdeemph3                                                                       (txdeemph3                                                                       ), // output
    .txdeemph4                                                                       (txdeemph4                                                                       ), // output
    .txdeemph5                                                                       (txdeemph5                                                                       ), // output
    .txdeemph6                                                                       (txdeemph6                                                                       ), // output
    .txdeemph7                                                                       (txdeemph7                                                                       ), // output
    .txdeemph8                                                                       (txdeemph8                                                                       ), // output
    .txdeemph9                                                                       (txdeemph9                                                                       ), // output
    .txdeemph10                                                                      (txdeemph10                                                                      ), // output
    .txdeemph11                                                                      (txdeemph11                                                                      ), // output
    .txdeemph12                                                                      (txdeemph12                                                                      ), // output
    .txdeemph13                                                                      (txdeemph13                                                                      ), // output
    .txdeemph14                                                                      (txdeemph14                                                                      ), // output
    .txdeemph15                                                                      (txdeemph15                                                                      ), // output

    .txswing0                                                                        (txswing0                                                                        ), // output
    .txswing1                                                                        (txswing1                                                                        ), // output
    .txswing2                                                                        (txswing2                                                                        ), // output
    .txswing3                                                                        (txswing3                                                                        ), // output
    .txswing4                                                                        (txswing4                                                                        ), // output
    .txswing5                                                                        (txswing5                                                                        ), // output
    .txswing6                                                                        (txswing6                                                                        ), // output
    .txswing7                                                                        (txswing7                                                                        ), // output
    .txswing8                                                                        (txswing8                                                                        ), // output
    .txswing9                                                                        (txswing9                                                                        ), // output
    .txswing10                                                                       (txswing10                                                                       ), // output
    .txswing11                                                                       (txswing11                                                                       ), // output
    .txswing12                                                                       (txswing12                                                                       ), // output
    .txswing13                                                                       (txswing13                                                                       ), // output
    .txswing14                                                                       (txswing14                                                                       ), // output
    .txswing15                                                                       (txswing15                                                                       ), // output

    .txsynchd0                                                                       (txsynchd0                                                                       ), // output     [1:0]
    .txsynchd1                                                                       (txsynchd1                                                                       ), // output     [1:0]
    .txsynchd2                                                                       (txsynchd2                                                                       ), // output     [1:0]
    .txsynchd3                                                                       (txsynchd3                                                                       ), // output     [1:0]
    .txsynchd4                                                                       (txsynchd4                                                                       ), // output     [1:0]
    .txsynchd5                                                                       (txsynchd5                                                                       ), // output     [1:0]
    .txsynchd6                                                                       (txsynchd6                                                                       ), // output     [1:0]
    .txsynchd7                                                                       (txsynchd7                                                                       ), // output     [1:0]
    .txsynchd8                                                                       (txsynchd8                                                                       ), // output     [1:0]
    .txsynchd9                                                                       (txsynchd9                                                                       ), // output     [1:0]
    .txsynchd10                                                                      (txsynchd10                                                                      ), // output     [1:0]
    .txsynchd11                                                                      (txsynchd11                                                                      ), // output     [1:0]
    .txsynchd12                                                                      (txsynchd12                                                                      ), // output     [1:0]
    .txsynchd13                                                                      (txsynchd13                                                                      ), // output     [1:0]
    .txsynchd14                                                                      (txsynchd14                                                                      ), // output     [1:0]
    .txsynchd15                                                                      (txsynchd15                                                                      ), // output     [1:0]

    .txblkst0                                                                        (txblkst0                                                                        ), // output
    .txblkst1                                                                        (txblkst1                                                                        ), // output
    .txblkst2                                                                        (txblkst2                                                                        ), // output
    .txblkst3                                                                        (txblkst3                                                                        ), // output
    .txblkst4                                                                        (txblkst4                                                                        ), // output
    .txblkst5                                                                        (txblkst5                                                                        ), // output
    .txblkst6                                                                        (txblkst6                                                                        ), // output
    .txblkst7                                                                        (txblkst7                                                                        ), // output
    .txblkst8                                                                        (txblkst8                                                                        ), // output
    .txblkst9                                                                        (txblkst9                                                                        ), // output
    .txblkst10                                                                       (txblkst10                                                                       ), // output
    .txblkst11                                                                       (txblkst11                                                                       ), // output
    .txblkst12                                                                       (txblkst12                                                                       ), // output
    .txblkst13                                                                       (txblkst13                                                                       ), // output
    .txblkst14                                                                       (txblkst14                                                                       ), // output
    .txblkst15                                                                       (txblkst15                                                                       ), // output

    .txdataskip0                                                                     (txdataskip0                                                                     ), // output
    .txdataskip1                                                                     (txdataskip1                                                                     ), // output
    .txdataskip2                                                                     (txdataskip2                                                                     ), // output
    .txdataskip3                                                                     (txdataskip3                                                                     ), // output
    .txdataskip4                                                                     (txdataskip4                                                                     ), // output
    .txdataskip5                                                                     (txdataskip5                                                                     ), // output
    .txdataskip6                                                                     (txdataskip6                                                                     ), // output
    .txdataskip7                                                                     (txdataskip7                                                                     ), // output
    .txdataskip8                                                                     (txdataskip8                                                                     ), // output
    .txdataskip9                                                                     (txdataskip9                                                                     ), // output
    .txdataskip10                                                                    (txdataskip10                                                                    ), // output
    .txdataskip11                                                                    (txdataskip11                                                                    ), // output
    .txdataskip12                                                                    (txdataskip12                                                                    ), // output
    .txdataskip13                                                                    (txdataskip13                                                                    ), // output
    .txdataskip14                                                                    (txdataskip14                                                                    ), // output
    .txdataskip15                                                                    (txdataskip15                                                                    ), // output

    .rate0                                                                           (rate0                                                                           ), // output     [1:0]
    .rate1                                                                           (rate1                                                                           ), // output     [1:0]
    .rate2                                                                           (rate2                                                                           ), // output     [1:0]
    .rate3                                                                           (rate3                                                                           ), // output     [1:0]
    .rate4                                                                           (rate4                                                                           ), // output     [1:0]
    .rate5                                                                           (rate5                                                                           ), // output     [1:0]
    .rate6                                                                           (rate6                                                                           ), // output     [1:0]
    .rate7                                                                           (rate7                                                                           ), // output     [1:0]
    .rate8                                                                           (rate8                                                                           ), // output     [1:0]
    .rate9                                                                           (rate9                                                                           ), // output     [1:0]
    .rate10                                                                          (rate10                                                                          ), // output     [1:0]
    .rate11                                                                          (rate11                                                                          ), // output     [1:0]
    .rate12                                                                          (rate12                                                                          ), // output     [1:0]
    .rate13                                                                          (rate13                                                                          ), // output     [1:0]
    .rate14                                                                          (rate14                                                                          ), // output     [1:0]
    .rate15                                                                          (rate15                                                                          ), // output     [1:0]

    .rxpolarity0                                                                     (rxpolarity0                                                                     ), // output
    .rxpolarity1                                                                     (rxpolarity1                                                                     ), // output
    .rxpolarity2                                                                     (rxpolarity2                                                                     ), // output
    .rxpolarity3                                                                     (rxpolarity3                                                                     ), // output
    .rxpolarity4                                                                     (rxpolarity4                                                                     ), // output
    .rxpolarity5                                                                     (rxpolarity5                                                                     ), // output
    .rxpolarity6                                                                     (rxpolarity6                                                                     ), // output
    .rxpolarity7                                                                     (rxpolarity7                                                                     ), // output
    .rxpolarity8                                                                     (rxpolarity8                                                                     ), // output
    .rxpolarity9                                                                     (rxpolarity9                                                                     ), // output
    .rxpolarity10                                                                    (rxpolarity10                                                                    ), // output
    .rxpolarity11                                                                    (rxpolarity11                                                                    ), // output
    .rxpolarity12                                                                    (rxpolarity12                                                                    ), // output
    .rxpolarity13                                                                    (rxpolarity13                                                                    ), // output
    .rxpolarity14                                                                    (rxpolarity14                                                                    ), // output
    .rxpolarity15                                                                    (rxpolarity15                                                                    ), // output

    .currentrxpreset0                                                                (currentrxpreset0                                                                ), // output     [2:0]
    .currentrxpreset1                                                                (currentrxpreset1                                                                ), // output     [2:0]
    .currentrxpreset2                                                                (currentrxpreset2                                                                ), // output     [2:0]
    .currentrxpreset3                                                                (currentrxpreset3                                                                ), // output     [2:0]
    .currentrxpreset4                                                                (currentrxpreset4                                                                ), // output     [2:0]
    .currentrxpreset5                                                                (currentrxpreset5                                                                ), // output     [2:0]
    .currentrxpreset6                                                                (currentrxpreset6                                                                ), // output     [2:0]
    .currentrxpreset7                                                                (currentrxpreset7                                                                ), // output     [2:0]
    .currentrxpreset8                                                                (currentrxpreset8                                                                ), // output     [2:0]
    .currentrxpreset9                                                                (currentrxpreset9                                                                ), // output     [2:0]
    .currentrxpreset10                                                               (currentrxpreset10                                                               ), // output     [2:0]
    .currentrxpreset11                                                               (currentrxpreset11                                                               ), // output     [2:0]
    .currentrxpreset12                                                               (currentrxpreset12                                                               ), // output     [2:0]
    .currentrxpreset13                                                               (currentrxpreset13                                                               ), // output     [2:0]
    .currentrxpreset14                                                               (currentrxpreset14                                                               ), // output     [2:0]
    .currentrxpreset15                                                               (currentrxpreset15                                                               ), // output     [2:0]

    .currentcoeff0                                                                   (currentcoeff0                                                                   ), // output     [17:0]
    .currentcoeff1                                                                   (currentcoeff1                                                                   ), // output     [17:0]
    .currentcoeff2                                                                   (currentcoeff2                                                                   ), // output     [17:0]
    .currentcoeff3                                                                   (currentcoeff3                                                                   ), // output     [17:0]
    .currentcoeff4                                                                   (currentcoeff4                                                                   ), // output     [17:0]
    .currentcoeff5                                                                   (currentcoeff5                                                                   ), // output     [17:0]
    .currentcoeff6                                                                   (currentcoeff6                                                                   ), // output     [17:0]
    .currentcoeff7                                                                   (currentcoeff7                                                                   ), // output     [17:0]
    .currentcoeff8                                                                   (currentcoeff8                                                                   ), // output     [17:0]
    .currentcoeff9                                                                   (currentcoeff9                                                                   ), // output     [17:0]
    .currentcoeff10                                                                  (currentcoeff10                                                                  ), // output     [17:0]
    .currentcoeff11                                                                  (currentcoeff11                                                                  ), // output     [17:0]
    .currentcoeff12                                                                  (currentcoeff12                                                                  ), // output     [17:0]
    .currentcoeff13                                                                  (currentcoeff13                                                                  ), // output     [17:0]
    .currentcoeff14                                                                  (currentcoeff14                                                                  ), // output     [17:0]
    .currentcoeff15                                                                  (currentcoeff15                                                                  ), // output     [17:0]

    .rxeqeval0                                                                       (rxeqeval0                                                                       ), // output
    .rxeqeval1                                                                       (rxeqeval1                                                                       ), // output
    .rxeqeval2                                                                       (rxeqeval2                                                                       ), // output
    .rxeqeval3                                                                       (rxeqeval3                                                                       ), // output
    .rxeqeval4                                                                       (rxeqeval4                                                                       ), // output
    .rxeqeval5                                                                       (rxeqeval5                                                                       ), // output
    .rxeqeval6                                                                       (rxeqeval6                                                                       ), // output
    .rxeqeval7                                                                       (rxeqeval7                                                                       ), // output
    .rxeqeval8                                                                       (rxeqeval8                                                                       ), // output
    .rxeqeval9                                                                       (rxeqeval9                                                                       ), // output
    .rxeqeval10                                                                      (rxeqeval10                                                                      ), // output
    .rxeqeval11                                                                      (rxeqeval11                                                                      ), // output
    .rxeqeval12                                                                      (rxeqeval12                                                                      ), // output
    .rxeqeval13                                                                      (rxeqeval13                                                                      ), // output
    .rxeqeval14                                                                      (rxeqeval14                                                                      ), // output
    .rxeqeval15                                                                      (rxeqeval15                                                                      ), // output

    .rxeqinprogress0                                                                 (rxeqinprogress0                                                                 ), // output
    .rxeqinprogress1                                                                 (rxeqinprogress1                                                                 ), // output
    .rxeqinprogress2                                                                 (rxeqinprogress2                                                                 ), // output
    .rxeqinprogress3                                                                 (rxeqinprogress3                                                                 ), // output
    .rxeqinprogress4                                                                 (rxeqinprogress4                                                                 ), // output
    .rxeqinprogress5                                                                 (rxeqinprogress5                                                                 ), // output
    .rxeqinprogress6                                                                 (rxeqinprogress6                                                                 ), // output
    .rxeqinprogress7                                                                 (rxeqinprogress7                                                                 ), // output
    .rxeqinprogress8                                                                 (rxeqinprogress8                                                                 ), // output
    .rxeqinprogress9                                                                 (rxeqinprogress9                                                                 ), // output
    .rxeqinprogress10                                                                (rxeqinprogress10                                                                ), // output
    .rxeqinprogress11                                                                (rxeqinprogress11                                                                ), // output
    .rxeqinprogress12                                                                (rxeqinprogress12                                                                ), // output
    .rxeqinprogress13                                                                (rxeqinprogress13                                                                ), // output
    .rxeqinprogress14                                                                (rxeqinprogress14                                                                ), // output
    .rxeqinprogress15                                                                (rxeqinprogress15                                                                ), // output

    .invalidreq0                                                                     (invalidreq0                                                                     ), // output
    .invalidreq1                                                                     (invalidreq1                                                                     ), // output
    .invalidreq2                                                                     (invalidreq2                                                                     ), // output
    .invalidreq3                                                                     (invalidreq3                                                                     ), // output
    .invalidreq4                                                                     (invalidreq4                                                                     ), // output
    .invalidreq5                                                                     (invalidreq5                                                                     ), // output
    .invalidreq6                                                                     (invalidreq6                                                                     ), // output
    .invalidreq7                                                                     (invalidreq7                                                                     ), // output
    .invalidreq8                                                                     (invalidreq8                                                                     ), // output
    .invalidreq9                                                                     (invalidreq9                                                                     ), // output
    .invalidreq10                                                                    (invalidreq10                                                                    ), // output
    .invalidreq11                                                                    (invalidreq11                                                                    ), // output
    .invalidreq12                                                                    (invalidreq12                                                                    ), // output
    .invalidreq13                                                                    (invalidreq13                                                                    ), // output
    .invalidreq14                                                                    (invalidreq14                                                                    ), // output
    .invalidreq15                                                                    (invalidreq15                                                                    ), // output

    //INPUT PIPE Interfae Signals
    .rxdata0                                                                         (rxdata0                                                                         ), // input      [31:0]
    .rxdata1                                                                         (rxdata1                                                                         ), // input      [31:0]
    .rxdata2                                                                         (rxdata2                                                                         ), // input      [31:0]
    .rxdata3                                                                         (rxdata3                                                                         ), // input      [31:0]
    .rxdata4                                                                         (rxdata4                                                                         ), // input      [31:0]
    .rxdata5                                                                         (rxdata5                                                                         ), // input      [31:0]
    .rxdata6                                                                         (rxdata6                                                                         ), // input      [31:0]
    .rxdata7                                                                         (rxdata7                                                                         ), // input      [31:0]
    .rxdata8                                                                         (rxdata8                                                                         ), // input      [31:0]
    .rxdata9                                                                         (rxdata9                                                                         ), // input      [31:0]
    .rxdata10                                                                        (rxdata10                                                                        ), // input      [31:0]
    .rxdata11                                                                        (rxdata11                                                                        ), // input      [31:0]
    .rxdata12                                                                        (rxdata12                                                                        ), // input      [31:0]
    .rxdata13                                                                        (rxdata13                                                                        ), // input      [31:0]
    .rxdata14                                                                        (rxdata14                                                                        ), // input      [31:0]
    .rxdata15                                                                        (rxdata15                                                                        ), // input      [31:0]

    .rxdatak0                                                                        (rxdatak0                                                                        ), // input      [3:0]
    .rxdatak1                                                                        (rxdatak1                                                                        ), // input      [3:0]
    .rxdatak2                                                                        (rxdatak2                                                                        ), // input      [3:0]
    .rxdatak3                                                                        (rxdatak3                                                                        ), // input      [3:0]
    .rxdatak4                                                                        (rxdatak4                                                                        ), // input      [3:0]
    .rxdatak5                                                                        (rxdatak5                                                                        ), // input      [3:0]
    .rxdatak6                                                                        (rxdatak6                                                                        ), // input      [3:0]
    .rxdatak7                                                                        (rxdatak7                                                                        ), // input      [3:0]
    .rxdatak8                                                                        (rxdatak8                                                                        ), // input      [3:0]
    .rxdatak9                                                                        (rxdatak9                                                                        ), // input      [3:0]
    .rxdatak10                                                                       (rxdatak10                                                                       ), // input      [3:0]
    .rxdatak11                                                                       (rxdatak11                                                                       ), // input      [3:0]
    .rxdatak12                                                                       (rxdatak12                                                                       ), // input      [3:0]
    .rxdatak13                                                                       (rxdatak13                                                                       ), // input      [3:0]
    .rxdatak14                                                                       (rxdatak14                                                                       ), // input      [3:0]
    .rxdatak15                                                                       (rxdatak15                                                                       ), // input      [3:0]

    .phystatus0                                                                      (phystatus0                                                                      ), // input
    .phystatus1                                                                      (phystatus1                                                                      ), // input
    .phystatus2                                                                      (phystatus2                                                                      ), // input
    .phystatus3                                                                      (phystatus3                                                                      ), // input
    .phystatus4                                                                      (phystatus4                                                                      ), // input
    .phystatus5                                                                      (phystatus5                                                                      ), // input
    .phystatus6                                                                      (phystatus6                                                                      ), // input
    .phystatus7                                                                      (phystatus7                                                                      ), // input
    .phystatus8                                                                      (phystatus8                                                                      ), // input
    .phystatus9                                                                      (phystatus9                                                                      ), // input
    .phystatus10                                                                     (phystatus10                                                                     ), // input
    .phystatus11                                                                     (phystatus11                                                                     ), // input
    .phystatus12                                                                     (phystatus12                                                                     ), // input
    .phystatus13                                                                     (phystatus13                                                                     ), // input
    .phystatus14                                                                     (phystatus14                                                                     ), // input
    .phystatus15                                                                     (phystatus15                                                                     ), // input

    .rxvalid0                                                                        (rxvalid0                                                                        ), // input
    .rxvalid1                                                                        (rxvalid1                                                                        ), // input
    .rxvalid2                                                                        (rxvalid2                                                                        ), // input
    .rxvalid3                                                                        (rxvalid3                                                                        ), // input
    .rxvalid4                                                                        (rxvalid4                                                                        ), // input
    .rxvalid5                                                                        (rxvalid5                                                                        ), // input
    .rxvalid6                                                                        (rxvalid6                                                                        ), // input
    .rxvalid7                                                                        (rxvalid7                                                                        ), // input
    .rxvalid8                                                                        (rxvalid8                                                                        ), // input
    .rxvalid9                                                                        (rxvalid9                                                                        ), // input
    .rxvalid10                                                                       (rxvalid10                                                                       ), // input
    .rxvalid11                                                                       (rxvalid11                                                                       ), // input
    .rxvalid12                                                                       (rxvalid12                                                                       ), // input
    .rxvalid13                                                                       (rxvalid13                                                                       ), // input
    .rxvalid14                                                                       (rxvalid14                                                                       ), // input
    .rxvalid15                                                                       (rxvalid15                                                                       ), // input

    .rxstatus0                                                                       (rxstatus0                                                                       ), // input      [2:0]
    .rxstatus1                                                                       (rxstatus1                                                                       ), // input      [2:0]
    .rxstatus2                                                                       (rxstatus2                                                                       ), // input      [2:0]
    .rxstatus3                                                                       (rxstatus3                                                                       ), // input      [2:0]
    .rxstatus4                                                                       (rxstatus4                                                                       ), // input      [2:0]
    .rxstatus5                                                                       (rxstatus5                                                                       ), // input      [2:0]
    .rxstatus6                                                                       (rxstatus6                                                                       ), // input      [2:0]
    .rxstatus7                                                                       (rxstatus7                                                                       ), // input      [2:0]
    .rxstatus8                                                                       (rxstatus8                                                                       ), // input      [2:0]
    .rxstatus9                                                                       (rxstatus9                                                                       ), // input      [2:0]
    .rxstatus10                                                                      (rxstatus10                                                                      ), // input      [2:0]
    .rxstatus11                                                                      (rxstatus11                                                                      ), // input      [2:0]
    .rxstatus12                                                                      (rxstatus12                                                                      ), // input      [2:0]
    .rxstatus13                                                                      (rxstatus13                                                                      ), // input      [2:0]
    .rxstatus14                                                                      (rxstatus14                                                                      ), // input      [2:0]
    .rxstatus15                                                                      (rxstatus15                                                                      ), // input      [2:0]

    .rxelecidle0                                                                     (rxelecidle0                                                                     ), // input
    .rxelecidle1                                                                     (rxelecidle1                                                                     ), // input
    .rxelecidle2                                                                     (rxelecidle2                                                                     ), // input
    .rxelecidle3                                                                     (rxelecidle3                                                                     ), // input
    .rxelecidle4                                                                     (rxelecidle4                                                                     ), // input
    .rxelecidle5                                                                     (rxelecidle5                                                                     ), // input
    .rxelecidle6                                                                     (rxelecidle6                                                                     ), // input
    .rxelecidle7                                                                     (rxelecidle7                                                                     ), // input
    .rxelecidle8                                                                     (rxelecidle8                                                                     ), // input
    .rxelecidle9                                                                     (rxelecidle9                                                                     ), // input
    .rxelecidle10                                                                    (rxelecidle10                                                                    ), // input
    .rxelecidle11                                                                    (rxelecidle11                                                                    ), // input
    .rxelecidle12                                                                    (rxelecidle12                                                                    ), // input
    .rxelecidle13                                                                    (rxelecidle13                                                                    ), // input
    .rxelecidle14                                                                    (rxelecidle14                                                                    ), // input
    .rxelecidle15                                                                    (rxelecidle15                                                                    ), // input

    .rxsynchd0                                                                       (rxsynchd0                                                                       ), // input      [1:0]
    .rxsynchd1                                                                       (rxsynchd1                                                                       ), // input      [1:0]
    .rxsynchd2                                                                       (rxsynchd2                                                                       ), // input      [1:0]
    .rxsynchd3                                                                       (rxsynchd3                                                                       ), // input      [1:0]
    .rxsynchd4                                                                       (rxsynchd4                                                                       ), // input      [1:0]
    .rxsynchd5                                                                       (rxsynchd5                                                                       ), // input      [1:0]
    .rxsynchd6                                                                       (rxsynchd6                                                                       ), // input      [1:0]
    .rxsynchd7                                                                       (rxsynchd7                                                                       ), // input      [1:0]
    .rxsynchd8                                                                       (rxsynchd8                                                                       ), // input      [1:0]
    .rxsynchd9                                                                       (rxsynchd9                                                                       ), // input      [1:0]
    .rxsynchd10                                                                      (rxsynchd10                                                                      ), // input      [1:0]
    .rxsynchd11                                                                      (rxsynchd11                                                                      ), // input      [1:0]
    .rxsynchd12                                                                      (rxsynchd12                                                                      ), // input      [1:0]
    .rxsynchd13                                                                      (rxsynchd13                                                                      ), // input      [1:0]
    .rxsynchd14                                                                      (rxsynchd14                                                                      ), // input      [1:0]
    .rxsynchd15                                                                      (rxsynchd15                                                                      ), // input      [1:0]

    .rxblkst0                                                                        (rxblkst0                                                                        ), // input
    .rxblkst1                                                                        (rxblkst1                                                                        ), // input
    .rxblkst2                                                                        (rxblkst2                                                                        ), // input
    .rxblkst3                                                                        (rxblkst3                                                                        ), // input
    .rxblkst4                                                                        (rxblkst4                                                                        ), // input
    .rxblkst5                                                                        (rxblkst5                                                                        ), // input
    .rxblkst6                                                                        (rxblkst6                                                                        ), // input
    .rxblkst7                                                                        (rxblkst7                                                                        ), // input
    .rxblkst8                                                                        (rxblkst8                                                                        ), // input
    .rxblkst9                                                                        (rxblkst9                                                                        ), // input
    .rxblkst10                                                                       (rxblkst10                                                                       ), // input
    .rxblkst11                                                                       (rxblkst11                                                                       ), // input
    .rxblkst12                                                                       (rxblkst12                                                                       ), // input
    .rxblkst13                                                                       (rxblkst13                                                                       ), // input
    .rxblkst14                                                                       (rxblkst14                                                                       ), // input
    .rxblkst15                                                                       (rxblkst15                                                                       ), // input

    .rxdataskip0                                                                     (rxdataskip0                                                                     ), // input
    .rxdataskip1                                                                     (rxdataskip1                                                                     ), // input
    .rxdataskip2                                                                     (rxdataskip2                                                                     ), // input
    .rxdataskip3                                                                     (rxdataskip3                                                                     ), // input
    .rxdataskip4                                                                     (rxdataskip4                                                                     ), // input
    .rxdataskip5                                                                     (rxdataskip5                                                                     ), // input
    .rxdataskip6                                                                     (rxdataskip6                                                                     ), // input
    .rxdataskip7                                                                     (rxdataskip7                                                                     ), // input
    .rxdataskip8                                                                     (rxdataskip8                                                                     ), // input
    .rxdataskip9                                                                     (rxdataskip9                                                                     ), // input
    .rxdataskip10                                                                    (rxdataskip10                                                                    ), // input
    .rxdataskip11                                                                    (rxdataskip11                                                                    ), // input
    .rxdataskip12                                                                    (rxdataskip12                                                                    ), // input
    .rxdataskip13                                                                    (rxdataskip13                                                                    ), // input
    .rxdataskip14                                                                    (rxdataskip14                                                                    ), // input
    .rxdataskip15                                                                    (rxdataskip15                                                                    ), // input

    .dirfeedback0                                                                    (dirfeedback0                                                                    ), // input      [5:0]
    .dirfeedback1                                                                    (dirfeedback1                                                                    ), // input      [5:0]
    .dirfeedback2                                                                    (dirfeedback2                                                                    ), // input      [5:0]
    .dirfeedback3                                                                    (dirfeedback3                                                                    ), // input      [5:0]
    .dirfeedback4                                                                    (dirfeedback4                                                                    ), // input      [5:0]
    .dirfeedback5                                                                    (dirfeedback5                                                                    ), // input      [5:0]
    .dirfeedback6                                                                    (dirfeedback6                                                                    ), // input      [5:0]
    .dirfeedback7                                                                    (dirfeedback7                                                                    ), // input      [5:0]
    .dirfeedback8                                                                    (dirfeedback8                                                                    ), // input      [5:0]
    .dirfeedback9                                                                    (dirfeedback9                                                                    ), // input      [5:0]
    .dirfeedback10                                                                   (dirfeedback10                                                                   ), // input      [5:0]
    .dirfeedback11                                                                   (dirfeedback11                                                                   ), // input      [5:0]
    .dirfeedback12                                                                   (dirfeedback12                                                                   ), // input      [5:0]
    .dirfeedback13                                                                   (dirfeedback13                                                                   ), // input      [5:0]
    .dirfeedback14                                                                   (dirfeedback14                                                                   ), // input      [5:0]
    .dirfeedback15                                                                   (dirfeedback15                                                                   ), // input      [5:0]


    //Serial Interface Sgnals
    .tx_out0                                                                         (tx_out0                                                                         ), // output
    .tx_out1                                                                         (tx_out1                                                                         ), // output
    .tx_out2                                                                         (tx_out2                                                                         ), // output
    .tx_out3                                                                         (tx_out3                                                                         ), // output
    .tx_out4                                                                         (tx_out4                                                                         ), // output
    .tx_out5                                                                         (tx_out5                                                                         ), // output
    .tx_out6                                                                         (tx_out6                                                                         ), // output
    .tx_out7                                                                         (tx_out7                                                                         ), // output
    .tx_out8                                                                         (tx_out8                                                                         ), // output
    .tx_out9                                                                         (tx_out9                                                                         ), // output
    .tx_out10                                                                        (tx_out10                                                                        ), // output
    .tx_out11                                                                        (tx_out11                                                                        ), // output
    .tx_out12                                                                        (tx_out12                                                                        ), // output
    .tx_out13                                                                        (tx_out13                                                                        ), // output
    .tx_out14                                                                        (tx_out14                                                                        ), // output
    .tx_out15                                                                        (tx_out15                                                                        ), // output

    .rx_in0                                                                          (rx_in0                                                                          ), // input
    .rx_in1                                                                          (rx_in1                                                                          ), // input
    .rx_in2                                                                          (rx_in2                                                                          ), // input
    .rx_in3                                                                          (rx_in3                                                                          ), // input
    .rx_in4                                                                          (rx_in4                                                                          ), // input
    .rx_in5                                                                          (rx_in5                                                                          ), // input
    .rx_in6                                                                          (rx_in6                                                                          ), // input
    .rx_in7                                                                          (rx_in7                                                                          ), // input
    .rx_in8                                                                          (rx_in8                                                                          ), // input
    .rx_in9                                                                          (rx_in9                                                                          ), // input
    .rx_in10                                                                         (rx_in10                                                                         ), // input
    .rx_in11                                                                         (rx_in11                                                                         ), // input
    .rx_in12                                                                         (rx_in12                                                                         ), // input
    .rx_in13                                                                         (rx_in13                                                                         ), // input
    .rx_in14                                                                         (rx_in14                                                                         ), // input
    .rx_in15                                                                         (rx_in15                                                                         ), // input


    //Test Signals
    .test_in                                                                         (test_in                                                                         ), // input      [66:0]
    .aux_test_out                                                                    (aux_test_out                                                                    ), // output     [6:0]
    .test_out                                                                        (test_out                                                                        ), // output     [255:0]
    .testin_zero                                                                     (                                                                                ), // output            : Unused in Bridge

    .sim_pipe_mask_tx_pll_lock                                                       (sim_pipe_mask_tx_pll_lock                                                       ), // input

    //rx_buffer_limit_signals
    .rx_np_buffer_limit                                                              (rx_np_buffer_limit                                                              ), // input      [6:0]
    .rx_p_buffer_limit                                                               (rx_p_buffer_limit                                                               ), // input      [6:0]
    .rx_cpl_buffer_limit                                                             (rx_cpl_buffer_limit                                                             ), // input      [9:0]


    .xcvr_reconfig_clk                                                               (xcvr_reconfig_clk                                                               ), // input
    .xcvr_reconfig_reset                                                             (xcvr_reconfig_reset                                                             ), // input
    .xcvr_reconfig_address                                                           (xcvr_reconfig_address                                                           ), // input
    .xcvr_reconfig_read                                                              (xcvr_reconfig_read                                                              ), // input
    .xcvr_reconfig_readdata                                                          (xcvr_reconfig_readdata                                                          ), // input   [13:0]
    .xcvr_reconfig_write                                                             (xcvr_reconfig_write                                                             ), // input   [31:0]
    .xcvr_reconfig_writedata                                                         (xcvr_reconfig_writedata                                                         ), // output  [31:0]
    .xcvr_reconfig_waitrequest                                                       (xcvr_reconfig_waitrequest                                                       ), // output

    .reconfig_pll0_clk                                                               (reconfig_pll0_clk                                                               ), // input
    .reconfig_pll0_reset                                                             (reconfig_pll0_reset                                                             ), // input
    .reconfig_pll0_address                                                           (reconfig_pll0_address                                                           ), // input
    .reconfig_pll0_read                                                              (reconfig_pll0_read                                                              ), // input
    .reconfig_pll0_readdata                                                          (reconfig_pll0_readdata                                                          ), // input   [10:0]
    .reconfig_pll0_write                                                             (reconfig_pll0_write                                                             ), // input   [31:0]
    .reconfig_pll0_writedata                                                         (reconfig_pll0_writedata                                                         ), // output  [31:0]
    .reconfig_pll0_waitrequest                                                       (reconfig_pll0_waitrequest                                                       ), // output

    .reconfig_pll1_clk                                                               (reconfig_pll1_clk                                                               ), // input
    .reconfig_pll1_reset                                                             (reconfig_pll1_reset                                                             ), // input
    .reconfig_pll1_address                                                           (reconfig_pll1_address                                                           ), // input
    .reconfig_pll1_read                                                              (reconfig_pll1_read                                                              ), // input
    .reconfig_pll1_readdata                                                          (reconfig_pll1_readdata                                                          ), // input   [10:0]
    .reconfig_pll1_write                                                             (reconfig_pll1_write                                                             ), // input   [31:0]
    .reconfig_pll1_writedata                                                         (reconfig_pll1_writedata                                                         ), // output  [31:0]
    .reconfig_pll1_waitrequest                                                       (reconfig_pll1_waitrequest                                                       )  // output
);

endmodule




