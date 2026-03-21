# (C) 2001-2018 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


global env
set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)
source ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/pcie_sv_parameters_common.tcl

proc update_pcie_parameters_avcv {} {
   set ast_width_hwtcl [ get_parameter_value ast_width_hwtcl ]
   if { [ regexp 128 $ast_width_hwtcl ] } {
      #Enable Half Rate Mode as per RBC for AV Gen2x4
      set_parameter_value enable_adapter_half_rate_mode_hwtcl "true"
   }
   set_parameter_value bypass_clk_switch_hwtcl                "disable"
   set_parameter_value no_command_completed_hwtcl             "false"
   set_parameter_value register_pipe_signals_hwtcl            "true"
}

proc add_pcie_pre_emph_vod_av {} {
   send_message debug "proc:add_pcie_pre_emph_vod_av"

   add_parameter          av_rpre_emph_a_val_hwtcl integer 12
   set_parameter_property av_rpre_emph_a_val_hwtcl VISIBLE false
   set_parameter_property av_rpre_emph_a_val_hwtcl HDL_PARAMETER true

   add_parameter          av_rpre_emph_b_val_hwtcl integer 0
   set_parameter_property av_rpre_emph_b_val_hwtcl VISIBLE false
   set_parameter_property av_rpre_emph_b_val_hwtcl HDL_PARAMETER true

   add_parameter          av_rpre_emph_c_val_hwtcl integer 19
   set_parameter_property av_rpre_emph_c_val_hwtcl VISIBLE false
   set_parameter_property av_rpre_emph_c_val_hwtcl HDL_PARAMETER true

   add_parameter          av_rpre_emph_d_val_hwtcl integer 13
   set_parameter_property av_rpre_emph_d_val_hwtcl VISIBLE false
   set_parameter_property av_rpre_emph_d_val_hwtcl HDL_PARAMETER true

   add_parameter          av_rpre_emph_e_val_hwtcl integer 21
   set_parameter_property av_rpre_emph_e_val_hwtcl VISIBLE false
   set_parameter_property av_rpre_emph_e_val_hwtcl HDL_PARAMETER true

   add_parameter          av_rvod_sel_a_val_hwtcl integer 42
   set_parameter_property av_rvod_sel_a_val_hwtcl VISIBLE false
   set_parameter_property av_rvod_sel_a_val_hwtcl HDL_PARAMETER true

   add_parameter          av_rvod_sel_b_val_hwtcl integer 30
   set_parameter_property av_rvod_sel_b_val_hwtcl VISIBLE false
   set_parameter_property av_rvod_sel_b_val_hwtcl HDL_PARAMETER true

   add_parameter          av_rvod_sel_c_val_hwtcl integer 43
   set_parameter_property av_rvod_sel_c_val_hwtcl VISIBLE false
   set_parameter_property av_rvod_sel_c_val_hwtcl HDL_PARAMETER true

   add_parameter          av_rvod_sel_d_val_hwtcl integer 43
   set_parameter_property av_rvod_sel_d_val_hwtcl VISIBLE false
   set_parameter_property av_rvod_sel_d_val_hwtcl HDL_PARAMETER true

   add_parameter          av_rvod_sel_e_val_hwtcl integer 9
   set_parameter_property av_rvod_sel_e_val_hwtcl VISIBLE false
   set_parameter_property av_rvod_sel_e_val_hwtcl HDL_PARAMETER true
}

proc add_pcie_pre_emph_vod_cv {} {
   send_message debug "proc:add_pcie_pre_emph_vod_cv"

   add_parameter          cv_rpre_emph_a_val_hwtcl integer 11
   set_parameter_property cv_rpre_emph_a_val_hwtcl VISIBLE false
   set_parameter_property cv_rpre_emph_a_val_hwtcl HDL_PARAMETER true

   add_parameter          cv_rpre_emph_b_val_hwtcl integer 0
   set_parameter_property cv_rpre_emph_b_val_hwtcl VISIBLE false
   set_parameter_property cv_rpre_emph_b_val_hwtcl HDL_PARAMETER true

   add_parameter          cv_rpre_emph_c_val_hwtcl integer 22
   set_parameter_property cv_rpre_emph_c_val_hwtcl VISIBLE false
   set_parameter_property cv_rpre_emph_c_val_hwtcl HDL_PARAMETER true

   add_parameter          cv_rpre_emph_d_val_hwtcl integer 12
   set_parameter_property cv_rpre_emph_d_val_hwtcl VISIBLE false
   set_parameter_property cv_rpre_emph_d_val_hwtcl HDL_PARAMETER true

   add_parameter          cv_rpre_emph_e_val_hwtcl integer 21
   set_parameter_property cv_rpre_emph_e_val_hwtcl VISIBLE false
   set_parameter_property cv_rpre_emph_e_val_hwtcl HDL_PARAMETER true

   add_parameter          cv_rvod_sel_a_val_hwtcl integer 50
   set_parameter_property cv_rvod_sel_a_val_hwtcl VISIBLE false
   set_parameter_property cv_rvod_sel_a_val_hwtcl HDL_PARAMETER true

   add_parameter          cv_rvod_sel_b_val_hwtcl integer 34
   set_parameter_property cv_rvod_sel_b_val_hwtcl VISIBLE false
   set_parameter_property cv_rvod_sel_b_val_hwtcl HDL_PARAMETER true

   add_parameter          cv_rvod_sel_c_val_hwtcl integer 50
   set_parameter_property cv_rvod_sel_c_val_hwtcl VISIBLE false
   set_parameter_property cv_rvod_sel_c_val_hwtcl HDL_PARAMETER true

   add_parameter          cv_rvod_sel_d_val_hwtcl integer 50
   set_parameter_property cv_rvod_sel_d_val_hwtcl VISIBLE false
   set_parameter_property cv_rvod_sel_d_val_hwtcl HDL_PARAMETER true

   add_parameter          cv_rvod_sel_e_val_hwtcl integer 9
   set_parameter_property cv_rvod_sel_e_val_hwtcl VISIBLE false
   set_parameter_property cv_rvod_sel_e_val_hwtcl HDL_PARAMETER true
}

proc add_pcie_hip_parameters_cvav {} {
   add_parameter          use_tl_cfg_sync_hwtcl integer 1
   set_parameter_property use_tl_cfg_sync_hwtcl VISIBLE false
   set_parameter_property use_tl_cfg_sync_hwtcl HDL_PARAMETER true
   set_parameter_property use_tl_cfg_sync_hwtcl DERIVED true

   # Specify is AST of AVMM bridge when using common parameter
   add_parameter altpcie_avmm_hwtcl integer 1
   set_parameter_property altpcie_avmm_hwtcl VISIBLE false
   set_parameter_property altpcie_avmm_hwtcl HDL_PARAMETER  false

   ####### ADVANCED DEFAULT HWTCL (Different naming system in SV)
   add_parameter          enable_rx_buffer_checking_advanced_default_hwtcl string "false"
   set_parameter_property enable_rx_buffer_checking_advanced_default_hwtcl VISIBLE false
   set_parameter_property enable_rx_buffer_checking_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          disable_link_x2_support_advanced_default_hwtcl string "false"
   set_parameter_property disable_link_x2_support_advanced_default_hwtcl VISIBLE false
   set_parameter_property disable_link_x2_support_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          device_number_advanced_default_hwtcl integer 0
   set_parameter_property device_number_advanced_default_hwtcl VISIBLE false
   set_parameter_property device_number_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          pipex1_debug_sel_advanced_default_hwtcl string "disable"
   set_parameter_property pipex1_debug_sel_advanced_default_hwtcl VISIBLE false
   set_parameter_property pipex1_debug_sel_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          pclk_out_sel_advanced_default_hwtcl string "pclk"
   set_parameter_property pclk_out_sel_advanced_default_hwtcl VISIBLE false
   set_parameter_property pclk_out_sel_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          no_soft_reset_advanced_default_hwtcl string "false"
   set_parameter_property no_soft_reset_advanced_default_hwtcl VISIBLE false
   set_parameter_property no_soft_reset_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          d1_support_advanced_default_hwtcl string "false"
   set_parameter_property d1_support_advanced_default_hwtcl VISIBLE false
   set_parameter_property d1_support_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          d2_support_advanced_default_hwtcl string "false"
   set_parameter_property d2_support_advanced_default_hwtcl VISIBLE false
   set_parameter_property d2_support_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          d0_pme_advanced_default_hwtcl string "false"
   set_parameter_property d0_pme_advanced_default_hwtcl VISIBLE false
   set_parameter_property d0_pme_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          d1_pme_advanced_default_hwtcl string "false"
   set_parameter_property d1_pme_advanced_default_hwtcl VISIBLE false
   set_parameter_property d1_pme_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          d2_pme_advanced_default_hwtcl string "false"
   set_parameter_property d2_pme_advanced_default_hwtcl VISIBLE false
   set_parameter_property d2_pme_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          d3_hot_pme_advanced_default_hwtcl string "false"
   set_parameter_property d3_hot_pme_advanced_default_hwtcl VISIBLE false
   set_parameter_property d3_hot_pme_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          d3_cold_pme_advanced_default_hwtcl string "false"
   set_parameter_property d3_cold_pme_advanced_default_hwtcl VISIBLE false
   set_parameter_property d3_cold_pme_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          low_priority_vc_advanced_default_hwtcl string "single_vc"
   set_parameter_property low_priority_vc_advanced_default_hwtcl VISIBLE false
   set_parameter_property low_priority_vc_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          enable_l1_aspm_advanced_default_hwtcl string "false"
   set_parameter_property enable_l1_aspm_advanced_default_hwtcl VISIBLE false
   set_parameter_property enable_l1_aspm_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          l1_exit_latency_sameclock_advanced_default_hwtcl integer 0
   set_parameter_property l1_exit_latency_sameclock_advanced_default_hwtcl VISIBLE false
   set_parameter_property l1_exit_latency_sameclock_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          l1_exit_latency_diffclock_advanced_default_hwtcl integer 0
   set_parameter_property l1_exit_latency_diffclock_advanced_default_hwtcl VISIBLE false
   set_parameter_property l1_exit_latency_diffclock_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          hot_plug_support_advanced_default_hwtcl integer 0
   set_parameter_property hot_plug_support_advanced_default_hwtcl VISIBLE false
   set_parameter_property hot_plug_support_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          no_command_completed_advanced_default_hwtcl string "false"
   set_parameter_property no_command_completed_advanced_default_hwtcl VISIBLE false
   set_parameter_property no_command_completed_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          eie_before_nfts_count_advanced_default_hwtcl integer 4
   set_parameter_property eie_before_nfts_count_advanced_default_hwtcl VISIBLE false
   set_parameter_property eie_before_nfts_count_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          gen2_diffclock_nfts_count_advanced_default_hwtcl integer 255
   set_parameter_property gen2_diffclock_nfts_count_advanced_default_hwtcl VISIBLE false
   set_parameter_property gen2_diffclock_nfts_count_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          gen2_sameclock_nfts_count_advanced_default_hwtcl integer 255
   set_parameter_property gen2_sameclock_nfts_count_advanced_default_hwtcl VISIBLE false
   set_parameter_property gen2_sameclock_nfts_count_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          deemphasis_enable_advanced_default_hwtcl string "false"
   set_parameter_property deemphasis_enable_advanced_default_hwtcl VISIBLE false 
   set_parameter_property deemphasis_enable_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          l0_exit_latency_sameclock_advanced_default_hwtcl integer 6
   set_parameter_property l0_exit_latency_sameclock_advanced_default_hwtcl VISIBLE false
   set_parameter_property l0_exit_latency_sameclock_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          l0_exit_latency_diffclock_advanced_default_hwtcl integer 6
   set_parameter_property l0_exit_latency_diffclock_advanced_default_hwtcl VISIBLE false
   set_parameter_property l0_exit_latency_diffclock_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          vc0_clk_enable_advanced_default_hwtcl string "true"
   set_parameter_property vc0_clk_enable_advanced_default_hwtcl VISIBLE false
   set_parameter_property vc0_clk_enable_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          register_pipe_signals_advanced_default_hwtcl string "true"
   set_parameter_property register_pipe_signals_advanced_default_hwtcl VISIBLE false
   set_parameter_property register_pipe_signals_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          tx_cdc_almost_empty_advanced_default_hwtcl integer 5
   set_parameter_property tx_cdc_almost_empty_advanced_default_hwtcl VISIBLE false
   set_parameter_property tx_cdc_almost_empty_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          rx_l0s_count_idl_advanced_default_hwtcl integer 0
   set_parameter_property rx_l0s_count_idl_advanced_default_hwtcl VISIBLE false
   set_parameter_property rx_l0s_count_idl_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          cdc_dummy_insert_limit_advanced_default_hwtcl integer 11
   set_parameter_property cdc_dummy_insert_limit_advanced_default_hwtcl VISIBLE false
   set_parameter_property cdc_dummy_insert_limit_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          ei_delay_powerdown_count_advanced_default_hwtcl integer 10
   set_parameter_property ei_delay_powerdown_count_advanced_default_hwtcl VISIBLE false
   set_parameter_property ei_delay_powerdown_count_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          skp_os_schedule_count_advanced_default_hwtcl integer 0
   set_parameter_property skp_os_schedule_count_advanced_default_hwtcl VISIBLE false
   set_parameter_property skp_os_schedule_count_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          fc_init_timer_advanced_default_hwtcl integer 1024
   set_parameter_property fc_init_timer_advanced_default_hwtcl VISIBLE false
   set_parameter_property fc_init_timer_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          l01_entry_latency_advanced_default_hwtcl integer 31
   set_parameter_property l01_entry_latency_advanced_default_hwtcl VISIBLE false
   set_parameter_property l01_entry_latency_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          flow_control_update_count_advanced_default_hwtcl integer 30
   set_parameter_property flow_control_update_count_advanced_default_hwtcl VISIBLE false
   set_parameter_property flow_control_update_count_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          flow_control_timeout_count_advanced_default_hwtcl integer 200
   set_parameter_property flow_control_timeout_count_advanced_default_hwtcl VISIBLE false
   set_parameter_property flow_control_timeout_count_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          retry_buffer_last_active_address_advanced_default_hwtcl integer 255
   set_parameter_property retry_buffer_last_active_address_advanced_default_hwtcl VISIBLE false
   set_parameter_property retry_buffer_last_active_address_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          reserved_debug_advanced_default_hwtcl integer 0
   set_parameter_property reserved_debug_advanced_default_hwtcl VISIBLE false
   set_parameter_property reserved_debug_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter          use_tl_cfg_sync_advanced_default_hwtcl integer 1
   set_parameter_property use_tl_cfg_sync_advanced_default_hwtcl VISIBLE false
   set_parameter_property use_tl_cfg_sync_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter diffclock_nfts_count_advanced_default_hwtcl integer 255
   set_parameter_property diffclock_nfts_count_advanced_default_hwtcl VISIBLE false
   set_parameter_property diffclock_nfts_count_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter sameclock_nfts_count_advanced_default_hwtcl integer 255
   set_parameter_property sameclock_nfts_count_advanced_default_hwtcl VISIBLE false
   set_parameter_property sameclock_nfts_count_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter l2_async_logic_advanced_default_hwtcl string "disable"
   set_parameter_property l2_async_logic_advanced_default_hwtcl VISIBLE false
   set_parameter_property l2_async_logic_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter rx_cdc_almost_full_advanced_default_hwtcl integer 12
   set_parameter_property rx_cdc_almost_full_advanced_default_hwtcl VISIBLE false
   set_parameter_property rx_cdc_almost_full_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter tx_cdc_almost_full_advanced_default_hwtcl integer 11
   set_parameter_property tx_cdc_almost_full_advanced_default_hwtcl VISIBLE false
   set_parameter_property tx_cdc_almost_full_advanced_default_hwtcl HDL_PARAMETER false

   add_parameter indicator_advanced_default_hwtcl integer 0
   set_parameter_property indicator_advanced_default_hwtcl VISIBLE false
   set_parameter_property indicator_advanced_default_hwtcl HDL_PARAMETER false
}

proc add_pcie_hip_parameters_ui_system_settings {} {
   send_message debug "proc:add_pcie_hip_parameters_ui_system_settings"

   set group_name "System Settings"
   # Gen1/Gen2
   add_parameter          lane_mask_hwtcl string "x8"
   set_parameter_property lane_mask_hwtcl DISPLAY_NAME "Number of lanes"
   set_parameter_property lane_mask_hwtcl ALLOWED_RANGES {"x2" "x4" "x8"}
   set_parameter_property lane_mask_hwtcl GROUP $group_name
   set_parameter_property lane_mask_hwtcl VISIBLE true
   set_parameter_property lane_mask_hwtcl HDL_PARAMETER true
   set_parameter_property lane_mask_hwtcl DESCRIPTION "Selects the maximum number of lanes supported. The IP core supports 2, 4, or 8 lanes."

   # Gen1/Gen2
   add_parameter          gen123_lane_rate_mode_hwtcl string "Gen3 (8.0 Gbps)"
   set_parameter_property gen123_lane_rate_mode_hwtcl DISPLAY_NAME "Lane rate"
   set_parameter_property gen123_lane_rate_mode_hwtcl ALLOWED_RANGES {"Gen1 (2.5 Gbps)" "Gen2 (5.0 Gbps)" "Gen3 (8.0 Gbps)"}
   set_parameter_property gen123_lane_rate_mode_hwtcl GROUP $group_name
   set_parameter_property gen123_lane_rate_mode_hwtcl VISIBLE true
   set_parameter_property gen123_lane_rate_mode_hwtcl HDL_PARAMETER true
   set_parameter_property gen123_lane_rate_mode_hwtcl DESCRIPTION "Selects the maximum data rate of the link. Gen1 (2.5Gbps), Gen2 (5.0 Gbps) and Gen3 (8.0 Gbps) are supported."

   # Interface Width
   add_parameter          app_interface_width_hwtcl integer 256
   set_parameter_property app_interface_width_hwtcl DISPLAY_NAME "Application interface width"
   set_parameter_property app_interface_width_hwtcl ALLOWED_RANGES {"128:128-bit" "256:256-bit"}
   set_parameter_property app_interface_width_hwtcl GROUP $group_name
   set_parameter_property app_interface_width_hwtcl VISIBLE true
   set_parameter_property app_interface_width_hwtcl HDL_PARAMETER false
   set_parameter_property app_interface_width_hwtcl DESCRIPTION "Selects the application interface width"

   add_parameter          DMA_WIDTH integer 256
   set_parameter_property DMA_WIDTH VISIBLE false
   set_parameter_property DMA_WIDTH DERIVED true
   set_parameter_property DMA_WIDTH HDL_PARAMETER true

   add_parameter          DMA_BE_WIDTH integer 32
   set_parameter_property DMA_BE_WIDTH VISIBLE false
   set_parameter_property DMA_BE_WIDTH DERIVED true
   set_parameter_property DMA_BE_WIDTH HDL_PARAMETER true

   add_parameter          DMA_BRST_CNT_W integer 5
   set_parameter_property DMA_BRST_CNT_W VISIBLE false
   set_parameter_property DMA_BRST_CNT_W DERIVED true
   set_parameter_property DMA_BRST_CNT_W HDL_PARAMETER true

   # Selects the port type
   add_parameter          port_type_hwtcl string "Native endpoint"
   set_parameter_property port_type_hwtcl DISPLAY_NAME "Port type"
   set_parameter_property port_type_hwtcl ALLOWED_RANGES {"Native endpoint" "Root port"}
   set_parameter_property port_type_hwtcl GROUP $group_name
   set_parameter_property port_type_hwtcl VISIBLE false
   set_parameter_property port_type_hwtcl HDL_PARAMETER true
   set_parameter_property port_type_hwtcl DESCRIPTION "Selects the port type. Native Endpoints, Root Ports, and legacy Endpoints are supported."

   add_parameter          pcie_spec_version_hwtcl string "2.1"
   set_parameter_property pcie_spec_version_hwtcl DISPLAY_NAME "PCI Express Base Specification version"
   set_parameter_property pcie_spec_version_hwtcl ALLOWED_RANGES {"2.1" "3.0"}
   set_parameter_property pcie_spec_version_hwtcl GROUP $group_name
   set_parameter_property pcie_spec_version_hwtcl VISIBLE false
   set_parameter_property pcie_spec_version_hwtcl DERIVED true
   set_parameter_property pcie_spec_version_hwtcl HDL_PARAMETER true
   set_parameter_property pcie_spec_version_hwtcl DESCRIPTION "Selects the version of PCI Express Base Specification implemented. Version 2.1 is supported."


   # RX Buffer Credit Setting
   add_parameter          rxbuffer_rxreq_hwtcl string "Low"
   set_parameter_property rxbuffer_rxreq_hwtcl DISPLAY_NAME "RX buffer credit  allocation - performance for received requests"
   set_parameter_property rxbuffer_rxreq_hwtcl ALLOWED_RANGES {"Minimum" "Low" "Balanced"}
   set_parameter_property rxbuffer_rxreq_hwtcl GROUP $group_name
   set_parameter_property rxbuffer_rxreq_hwtcl VISIBLE true
   set_parameter_property rxbuffer_rxreq_hwtcl HDL_PARAMETER false
   set_parameter_property rxbuffer_rxreq_hwtcl DESCRIPTION "Set the credits in the RX buffer for Posted, Non-Posted and Completion TLPs. The number of credits increases as the desired performance and maximum payload size increase."

   # Ref clk
   add_parameter          pll_refclk_freq_hwtcl string "100 MHz"
   set_parameter_property pll_refclk_freq_hwtcl DISPLAY_NAME "Reference clock frequency"
   set_parameter_property pll_refclk_freq_hwtcl ALLOWED_RANGES {"100 MHz" "125 MHz"}
   set_parameter_property pll_refclk_freq_hwtcl GROUP $group_name
   set_parameter_property pll_refclk_freq_hwtcl VISIBLE true
   set_parameter_property pll_refclk_freq_hwtcl HDL_PARAMETER true
   set_parameter_property pll_refclk_freq_hwtcl DESCRIPTION "Selects the reference clock frequency for the transceiver block. Both 100 Mhz and 125 MHz are supported."

   # x1 frequency
   add_parameter          set_pld_clk_x1_625MHz_hwtcl integer 0
   set_parameter_property set_pld_clk_x1_625MHz_hwtcl DISPLAY_NAME "Use  62.5 MHz application clock"
   set_parameter_property set_pld_clk_x1_625MHz_hwtcl DISPLAY_HINT boolean
   set_parameter_property set_pld_clk_x1_625MHz_hwtcl GROUP $group_name
   set_parameter_property set_pld_clk_x1_625MHz_hwtcl VISIBLE false
   set_parameter_property set_pld_clk_x1_625MHz_hwtcl HDL_PARAMETER true
   set_parameter_property set_pld_clk_x1_625MHz_hwtcl DESCRIPTION "Only available in x1 configurations."

   # Instantiate Controller internally
   add_parameter          internal_controller_hwtcl integer 0
   set_parameter_property internal_controller_hwtcl DISPLAY_NAME "Instantiate internal descriptor controller"
   set_parameter_property internal_controller_hwtcl DISPLAY_HINT boolean
   set_parameter_property internal_controller_hwtcl GROUP $group_name
   set_parameter_property internal_controller_hwtcl VISIBLE true
   set_parameter_property internal_controller_hwtcl HDL_PARAMETER true
   set_parameter_property internal_controller_hwtcl DESCRIPTION "Instantiate a descriptor controller within this variant. If this option is set to true, this variant will provide a descriptor controller along with read and write DMA engines. The descriptor controller will utilize BAR0 and BAR1. Otherwise, DMA engine ports will be exposed to allow for custom descriptor controllers."

   # Enable CRA Slave Port
   add_parameter          enable_cra_hwtcl integer 1
   set_parameter_property enable_cra_hwtcl DISPLAY_NAME "Enable AVMM CRA Slave hard IP Status port"
   set_parameter_property enable_cra_hwtcl DISPLAY_HINT boolean
   set_parameter_property enable_cra_hwtcl GROUP $group_name
   set_parameter_property enable_cra_hwtcl VISIBLE true
   set_parameter_property enable_cra_hwtcl HDL_PARAMETER true
   set_parameter_property enable_cra_hwtcl DESCRIPTION "Enable CRA Slave Port allowing access to selected hard IP Config register values and link status"


   # Enable RXM Burst Master
   add_parameter          enable_rxm_burst_hwtcl integer 0
   set_parameter_property enable_rxm_burst_hwtcl DISPLAY_NAME "Enable burst capabilities for RXM BAR2 port"
   set_parameter_property enable_rxm_burst_hwtcl DISPLAY_HINT boolean
   set_parameter_property enable_rxm_burst_hwtcl GROUP $group_name
   set_parameter_property enable_rxm_burst_hwtcl VISIBLE true
   set_parameter_property enable_rxm_burst_hwtcl HDL_PARAMETER true
   set_parameter_property enable_rxm_burst_hwtcl DESCRIPTION "Enable burst capabilities for the RXM BAR2 port. If this option is set to true, RXM BAR2 and BAR3 ports will be bursting masters. Otherwise, RXM BAR2 and BAR3 will be a single DW master."

   # CVP
   add_parameter          in_cvp_mode_hwtcl integer 0
   set_parameter_property in_cvp_mode_hwtcl DISPLAY_NAME "Enable configuration via the PCIe link"
   set_parameter_property in_cvp_mode_hwtcl DISPLAY_HINT boolean
   set_parameter_property in_cvp_mode_hwtcl GROUP $group_name
   set_parameter_property in_cvp_mode_hwtcl VISIBLE true
   set_parameter_property in_cvp_mode_hwtcl HDL_PARAMETER true
   set_parameter_property in_cvp_mode_hwtcl DESCRIPTION "Selects the hard IP block that includes logic to configure the FPGA  via the PCI Express link."

   add_parameter          enable_tl_only_sim_hwtcl integer 0
   set_parameter_property enable_tl_only_sim_hwtcl DISPLAY_NAME "Enable TL-Direct simulation"
   set_parameter_property enable_tl_only_sim_hwtcl DISPLAY_HINT boolean
   set_parameter_property enable_tl_only_sim_hwtcl GROUP $group_name
   set_parameter_property enable_tl_only_sim_hwtcl VISIBLE false
   set_parameter_property enable_tl_only_sim_hwtcl HDL_PARAMETER true
   set_parameter_property enable_tl_only_sim_hwtcl DESCRIPTION "When On, enables simulation with TL BFM"


   add_parameter          use_atx_pll_hwtcl integer 0
   set_parameter_property use_atx_pll_hwtcl DISPLAY_NAME "Use ATX PLL"
   set_parameter_property use_atx_pll_hwtcl DISPLAY_HINT boolean
   set_parameter_property use_atx_pll_hwtcl GROUP $group_name
   set_parameter_property use_atx_pll_hwtcl VISIBLE true
   set_parameter_property use_atx_pll_hwtcl HDL_PARAMETER true
   set_parameter_property use_atx_pll_hwtcl DESCRIPTION "When On, use ATX PLL instead of CMU PLL"

   ########################################################################################################
   #
   # Hidden parameters
   #
   # Enable Hard IP completion tag checking
   add_parameter          hip_tag_checking_hwtcl integer 1
   set_parameter_property hip_tag_checking_hwtcl DISPLAY_NAME "Enable hard IP completion tag checking"
   set_parameter_property hip_tag_checking_hwtcl DISPLAY_HINT boolean
   set_parameter_property hip_tag_checking_hwtcl GROUP $group_name
   set_parameter_property hip_tag_checking_hwtcl VISIBLE false
   set_parameter_property hip_tag_checking_hwtcl HDL_PARAMETER false
   set_parameter_property hip_tag_checking_hwtcl DESCRIPTION "When On, Enable completion tag checking circuit in the hard IP and the application can issue up to 64 tags. When Off, the application can issue up to 256 tags and the completion tag checking circuit is expected to be built in the application logic"

   # Enables power up Hard IP reset pulse
   add_parameter          enable_power_on_rst_pulse_hwtcl integer 0
   set_parameter_property enable_power_on_rst_pulse_hwtcl DISPLAY_NAME "Enable power up hard IP reset pulse when using the soft reset controller"
   set_parameter_property enable_power_on_rst_pulse_hwtcl DISPLAY_HINT boolean
   set_parameter_property enable_power_on_rst_pulse_hwtcl GROUP $group_name
   set_parameter_property enable_power_on_rst_pulse_hwtcl VISIBLE true
   set_parameter_property enable_power_on_rst_pulse_hwtcl HDL_PARAMETER false
   set_parameter_property enable_power_on_rst_pulse_hwtcl DESCRIPTION "When On Enables soft reset controller to generate a pulse at power up to reset hard IP, this ensures that the hard IP is being reset after programming the device, regardless of the behavior of the dedicated PCI Express reset pin perstn"

   # Enables power up Hard IP reset pulse
   add_parameter          enable_pcisigtest_hwtcl integer 0
   set_parameter_property enable_pcisigtest_hwtcl DISPLAY_NAME "Enables PCI-SIG test logic"
   set_parameter_property enable_pcisigtest_hwtcl DISPLAY_HINT boolean
   set_parameter_property enable_pcisigtest_hwtcl GROUP $group_name
   set_parameter_property enable_pcisigtest_hwtcl VISIBLE false
   set_parameter_property enable_pcisigtest_hwtcl HDL_PARAMETER false
   set_parameter_property enable_pcisigtest_hwtcl DESCRIPTION "Enables PCI-SIG test logic"

   #  Rxm Parameters
   set MAX_PREFETCH_MASTERS 6

   for { set i 0 } { $i < $MAX_PREFETCH_MASTERS } { incr i } {
      add_parameter "SLAVE_ADDRESS_MAP_$i" integer 0
      set_parameter_property "SLAVE_ADDRESS_MAP_$i" system_info_type ADDRESS_WIDTH
      set_parameter_property "SLAVE_ADDRESS_MAP_$i" system_info_arg "Rxm_BAR${i}"
      set_parameter_property "SLAVE_ADDRESS_MAP_$i" AFFECTS_ELABORATION true
      set_parameter_property "SLAVE_ADDRESS_MAP_$i" VISIBLE false
   }

   ##   DMA Read Master Size Map
      add_parameter "RD_SLAVE_ADDRESS_MAP" integer 1
      set_parameter_property "RD_SLAVE_ADDRESS_MAP" system_info_type ADDRESS_WIDTH
      set_parameter_property "RD_SLAVE_ADDRESS_MAP" system_info_arg "dma_rd_master"
      set_parameter_property "RD_SLAVE_ADDRESS_MAP" AFFECTS_ELABORATION true
      set_parameter_property "RD_SLAVE_ADDRESS_MAP" VISIBLE false

   ##   DMA Read Master Size Map
      add_parameter          "WR_SLAVE_ADDRESS_MAP" integer 1
      set_parameter_property "WR_SLAVE_ADDRESS_MAP" system_info_type ADDRESS_WIDTH
      set_parameter_property "WR_SLAVE_ADDRESS_MAP" system_info_arg "dma_wr_master"
      set_parameter_property "WR_SLAVE_ADDRESS_MAP" AFFECTS_ELABORATION true
      set_parameter_property "WR_SLAVE_ADDRESS_MAP" VISIBLE false

   ##   Optimized FIFO for SV
      add_parameter          dma_use_scfifo_ext_hwtcl integer 0
      set_parameter_property dma_use_scfifo_ext_hwtcl HDL_PARAMETER true
      set_parameter_property dma_use_scfifo_ext_hwtcl VISIBLE false
}

proc add_pcie_hip_parameters_ui_pci_registers {} {

   send_message debug "proc:add_pcie_hip_parameters_ui_pci_registers"
   #-----------------------------------------------------------------------------------------------------------------
   set group_name "Device Identification Registers"

   add_parameter          vendor_id_hwtcl integer  0
   set_parameter_property vendor_id_hwtcl DISPLAY_NAME "Vendor ID"
   set_parameter_property vendor_id_hwtcl ALLOWED_RANGES { 0:65534 }
   set_parameter_property vendor_id_hwtcl DISPLAY_HINT hexadecimal
   set_parameter_property vendor_id_hwtcl GROUP $group_name
   set_parameter_property vendor_id_hwtcl VISIBLE true
   set_parameter_property vendor_id_hwtcl HDL_PARAMETER true
   set_parameter_property vendor_id_hwtcl DESCRIPTION "Sets the read-only value of the Vendor ID register."

   add_parameter          device_id_hwtcl integer 1
   set_parameter_property device_id_hwtcl DISPLAY_NAME "Device ID"
   set_parameter_property device_id_hwtcl ALLOWED_RANGES { 0:65534 }
   set_parameter_property device_id_hwtcl DISPLAY_HINT hexadecimal
   set_parameter_property device_id_hwtcl GROUP $group_name
   set_parameter_property device_id_hwtcl VISIBLE true
   set_parameter_property device_id_hwtcl HDL_PARAMETER true
   set_parameter_property device_id_hwtcl DESCRIPTION "Sets the read-only value of the Device ID register."

   add_parameter          revision_id_hwtcl integer 1
   set_parameter_property revision_id_hwtcl DISPLAY_NAME "Revision ID"
   set_parameter_property revision_id_hwtcl ALLOWED_RANGES { 0:255 }
   set_parameter_property revision_id_hwtcl DISPLAY_HINT hexadecimal
   set_parameter_property revision_id_hwtcl GROUP $group_name
   set_parameter_property revision_id_hwtcl VISIBLE true
   set_parameter_property revision_id_hwtcl HDL_PARAMETER true
   set_parameter_property revision_id_hwtcl DESCRIPTION "Sets the read-only value of the Revision ID register."

   add_parameter          class_code_hwtcl integer 0
   set_parameter_property class_code_hwtcl DISPLAY_NAME "Class Code"
   set_parameter_property class_code_hwtcl ALLOWED_RANGES { 0:16777215 }
   set_parameter_property class_code_hwtcl DISPLAY_HINT hexadecimal
   set_parameter_property class_code_hwtcl GROUP $group_name
   set_parameter_property class_code_hwtcl VISIBLE true
   set_parameter_property class_code_hwtcl HDL_PARAMETER true
   set_parameter_property class_code_hwtcl DESCRIPTION "Sets the read-only value of the Class code register."

   add_parameter          subsystem_vendor_id_hwtcl integer  0
   set_parameter_property subsystem_vendor_id_hwtcl DISPLAY_NAME "Subsystem Vendor ID"
   set_parameter_property subsystem_vendor_id_hwtcl ALLOWED_RANGES { 0:65534 }
   set_parameter_property subsystem_vendor_id_hwtcl DISPLAY_HINT hexadecimal
   set_parameter_property subsystem_vendor_id_hwtcl GROUP $group_name
   set_parameter_property subsystem_vendor_id_hwtcl VISIBLE true
   set_parameter_property subsystem_vendor_id_hwtcl HDL_PARAMETER true
   set_parameter_property subsystem_vendor_id_hwtcl DESCRIPTION "Sets the read-only value of the Subsystem Vendor ID register."

   add_parameter          subsystem_device_id_hwtcl integer 0
   set_parameter_property subsystem_device_id_hwtcl DISPLAY_NAME "Subsystem Device ID"
   set_parameter_property subsystem_device_id_hwtcl ALLOWED_RANGES { 0:65534 }
   set_parameter_property subsystem_device_id_hwtcl DISPLAY_HINT hexadecimal
   set_parameter_property subsystem_device_id_hwtcl GROUP $group_name
   set_parameter_property subsystem_device_id_hwtcl VISIBLE true
   set_parameter_property subsystem_device_id_hwtcl HDL_PARAMETER true
   set_parameter_property subsystem_device_id_hwtcl DESCRIPTION "Sets the read-only value of the Subsystem Device ID register."

}


proc add_pcie_hip_parameters_bar_avmm {} {

   set MAX_PREFETCH_MASTERS 6
   add_parameter          NUM_PREFETCH_MASTERS integer 1
   set_parameter_property NUM_PREFETCH_MASTERS DISPLAY_NAME "Number of BARs"
   set_parameter_property NUM_PREFETCH_MASTERS ALLOWED_RANGES "0:$MAX_PREFETCH_MASTERS"
   set_parameter_property NUM_PREFETCH_MASTERS AFFECTS_ELABORATION true
   set_parameter_property NUM_PREFETCH_MASTERS VISIBLE FALSE

   add_pcie_hip_parameters_ui_pci_bar_avmm

   #By default, we have one 64 bit Bar
   for { set i 0 } { $i < $MAX_PREFETCH_MASTERS } { incr i } {
      add_parameter "CB_P2A_AVALON_ADDR_B${i}" integer "32'h00000000"
      set_parameter_property "CB_P2A_AVALON_ADDR_B${i}" "units" "Address"
      set_parameter_property  "CB_P2A_AVALON_ADDR_B${i}" VISIBLE FALSE
   }

   add_parameter "fixed_address_mode" string 0
   set_parameter_property  "fixed_address_mode" VISIBLE FALSE

   for { set i 0 } { $i < $MAX_PREFETCH_MASTERS } { incr i } {
      add_parameter "CB_P2A_FIXED_AVALON_ADDR_B${i}" integer "32'h00000000"
      set_parameter_property  "CB_P2A_FIXED_AVALON_ADDR_B${i}" VISIBLE FALSE
   }
}

proc add_pcie_hip_parameters_ui_pcie_cap_registers {} {

   send_message debug "proc:add_pcie_hip_parameters_ui_pcie_cap_registers"
   #-----------------------------------------------------------------------------------------------------------------
   set master_group_name "PCI Express/PCI Capabilities"
   add_display_item "" ${master_group_name} group

   set group_name "Device"
   add_display_item ${master_group_name} ${group_name} group
   set_display_item_property ${group_name} display_hint tab

   add_parameter max_payload_size_hwtcl integer 128
   set_parameter_property max_payload_size_hwtcl DISPLAY_NAME "Maximum payload size"
   set_parameter_property max_payload_size_hwtcl ALLOWED_RANGES { "128:128 Bytes" "256:256 Bytes"  }
   set_parameter_property max_payload_size_hwtcl GROUP $group_name
   set_parameter_property max_payload_size_hwtcl VISIBLE true
   set_parameter_property max_payload_size_hwtcl HDL_PARAMETER true
   set_parameter_property max_payload_size_hwtcl DESCRIPTION "Sets the read-only value of the max payload size of the Device Capabilities register and optimizes for this payload size."

   add_parameter          extend_tag_field_hwtcl string "32"
   set_parameter_property extend_tag_field_hwtcl DISPLAY_NAME "Number of tags supported"
   set_parameter_property extend_tag_field_hwtcl ALLOWED_RANGES { "32" }
   set_parameter_property extend_tag_field_hwtcl GROUP $group_name
   set_parameter_property extend_tag_field_hwtcl VISIBLE false
   set_parameter_property extend_tag_field_hwtcl HDL_PARAMETER true
   set_parameter_property extend_tag_field_hwtcl DESCRIPTION "Sets the number of tags supported for non-posted requests transmitted by the Application Layer."

   add_parameter          completion_timeout_hwtcl string "NONE"
   set_parameter_property completion_timeout_hwtcl DISPLAY_NAME "Completion timeout range"
   set_parameter_property completion_timeout_hwtcl ALLOWED_RANGES { "ABCD" "BCD" "ABC" "BC" "AB" "B" "A" "NONE"}
   set_parameter_property completion_timeout_hwtcl GROUP $group_name
   set_parameter_property completion_timeout_hwtcl VISIBLE false
   set_parameter_property completion_timeout_hwtcl HDL_PARAMETER true
   set_parameter_property completion_timeout_hwtcl DESCRIPTION "Sets the completion timeout range for Root Ports and Endpoints that issue requests on their own behalf in PCI Express version 2.0 or higher. For additional information, refer to the PCI Express User Guide."

   add_parameter enable_completion_timeout_disable_hwtcl integer 1
   set_parameter_property enable_completion_timeout_disable_hwtcl DISPLAY_NAME "Implement completion timeout disable"
   set_parameter_property enable_completion_timeout_disable_hwtcl DISPLAY_HINT boolean
   set_parameter_property enable_completion_timeout_disable_hwtcl GROUP $group_name
   set_parameter_property enable_completion_timeout_disable_hwtcl VISIBLE false
   set_parameter_property enable_completion_timeout_disable_hwtcl HDL_PARAMETER true
   set_parameter_property enable_completion_timeout_disable_hwtcl DESCRIPTION "Turns the completion timeout mechanism On or Off for Root Ports in PCI Express version 2.0 or higher. This option is forced to On for PCI Express version 2.0 and higher Endpoints."

   #-----------------------------------------------------------------------------------------------------------------
   set group_name "Error Reporting"
   add_display_item ${master_group_name} ${group_name} group
   set_display_item_property ${group_name} display_hint tab

   add_parameter          use_aer_hwtcl integer 0
   set_parameter_property use_aer_hwtcl DISPLAY_NAME "Advanced error reporting (AER)"
   set_parameter_property use_aer_hwtcl GROUP $group_name
   set_parameter_property use_aer_hwtcl VISIBLE true
   set_parameter_property use_aer_hwtcl HDL_PARAMETER true
   set_parameter_property use_aer_hwtcl DISPLAY_HINT boolean
   set_parameter_property use_aer_hwtcl DESCRIPTION "Enables or disables AER."

   add_parameter          ecrc_check_capable_hwtcl integer 0
   set_parameter_property ecrc_check_capable_hwtcl DISPLAY_NAME "ECRC checking"
   set_parameter_property ecrc_check_capable_hwtcl DISPLAY_HINT boolean
   set_parameter_property ecrc_check_capable_hwtcl GROUP $group_name
   set_parameter_property ecrc_check_capable_hwtcl VISIBLE true
   set_parameter_property ecrc_check_capable_hwtcl HDL_PARAMETER true
   set_parameter_property ecrc_check_capable_hwtcl DESCRIPTION "Enables or disables ECRC checking. When enabled, AER must also be On."

   add_parameter          ecrc_gen_capable_hwtcl integer 0
   set_parameter_property ecrc_gen_capable_hwtcl DISPLAY_NAME "ECRC generation"
   set_parameter_property ecrc_gen_capable_hwtcl DISPLAY_HINT boolean
   set_parameter_property ecrc_gen_capable_hwtcl GROUP $group_name
   set_parameter_property ecrc_gen_capable_hwtcl VISIBLE true
   set_parameter_property ecrc_gen_capable_hwtcl HDL_PARAMETER true
   set_parameter_property ecrc_gen_capable_hwtcl DESCRIPTION "Enables or disables ECRC generation."

   add_parameter          use_crc_forwarding_hwtcl integer 0
   set_parameter_property use_crc_forwarding_hwtcl DISPLAY_NAME "ECRC forwarding"
   set_parameter_property use_crc_forwarding_hwtcl DISPLAY_HINT boolean
   set_parameter_property use_crc_forwarding_hwtcl GROUP $group_name
   set_parameter_property use_crc_forwarding_hwtcl VISIBLE false
   set_parameter_property use_crc_forwarding_hwtcl HDL_PARAMETER true
   set_parameter_property use_crc_forwarding_hwtcl DESCRIPTION "Enables or disables ECRC forwarding."

   #-----------------------------------------------------------------------------------------------------------------
   set group_name "Link"
   add_display_item ${master_group_name} ${group_name} group
   set_display_item_property ${group_name} display_hint tab

   add_parameter          port_link_number_hwtcl integer 1
   set_parameter_property port_link_number_hwtcl DISPLAY_NAME "Link port number"
   set_parameter_property port_link_number_hwtcl ALLOWED_RANGES { 0:255 }
   set_parameter_property port_link_number_hwtcl GROUP $group_name
   set_parameter_property port_link_number_hwtcl VISIBLE true
   set_parameter_property port_link_number_hwtcl HDL_PARAMETER true
   set_parameter_property port_link_number_hwtcl DESCRIPTION "Sets the read-only value of the port number field in the Link Capabilities register."

   add_parameter          dll_active_report_support_hwtcl integer 0
   set_parameter_property dll_active_report_support_hwtcl DISPLAY_NAME "Data link layer active reporting"
   set_parameter_property dll_active_report_support_hwtcl DISPLAY_HINT boolean
   set_parameter_property dll_active_report_support_hwtcl GROUP $group_name
   set_parameter_property dll_active_report_support_hwtcl VISIBLE false
   set_parameter_property dll_active_report_support_hwtcl HDL_PARAMETER true
   set_parameter_property dll_active_report_support_hwtcl DESCRIPTION "Enables or disables Data Link Layer (DLL) active reporting."

   add_parameter          surprise_down_error_support_hwtcl integer 0
   set_parameter_property surprise_down_error_support_hwtcl DISPLAY_NAME "Surprise down reporting"
   set_parameter_property surprise_down_error_support_hwtcl DISPLAY_HINT boolean
   set_parameter_property surprise_down_error_support_hwtcl GROUP $group_name
   set_parameter_property surprise_down_error_support_hwtcl VISIBLE false
   set_parameter_property surprise_down_error_support_hwtcl HDL_PARAMETER true
   set_parameter_property surprise_down_error_support_hwtcl DESCRIPTION "Enables or disables surprise down reporting."

   add_parameter          slotclkcfg_hwtcl integer 1
   set_parameter_property slotclkcfg_hwtcl DISPLAY_NAME "Slot clock configuration"
   set_parameter_property slotclkcfg_hwtcl DISPLAY_HINT boolean
   set_parameter_property slotclkcfg_hwtcl GROUP $group_name
   set_parameter_property slotclkcfg_hwtcl VISIBLE true
   set_parameter_property slotclkcfg_hwtcl HDL_PARAMETER true
   set_parameter_property slotclkcfg_hwtcl DESCRIPTION "Sets the read-only value of the slot clock configuration bit in the link status register."

   # TODO Add Link COmmon Clock parameters

  #-----------------------------------------------------------------------------------------------------------------
   set group_name "MSI"
   add_display_item ${master_group_name} ${group_name} group
   set_display_item_property ${group_name} display_hint tab

   add_parameter          msi_multi_message_capable_hwtcl string        "4"
   set_parameter_property msi_multi_message_capable_hwtcl DISPLAY_NAME "Number of MSI messages requested"
   set_parameter_property msi_multi_message_capable_hwtcl ALLOWED_RANGES { "1" "2" "4" "8" "16"}
   set_parameter_property msi_multi_message_capable_hwtcl GROUP $group_name
   set_parameter_property msi_multi_message_capable_hwtcl VISIBLE true
   set_parameter_property msi_multi_message_capable_hwtcl HDL_PARAMETER true
   set_parameter_property msi_multi_message_capable_hwtcl DESCRIPTION "Sets the number of messages that the application can request in the multiple message capable field of the Message Control register."

   add_parameter msi_64bit_addressing_capable_hwtcl string "true"
   set_parameter_property msi_64bit_addressing_capable_hwtcl VISIBLE false
   set_parameter_property msi_64bit_addressing_capable_hwtcl HDL_PARAMETER true

   add_parameter msi_masking_capable_hwtcl string "false"
   set_parameter_property msi_masking_capable_hwtcl VISIBLE false
   set_parameter_property msi_masking_capable_hwtcl HDL_PARAMETER true

   add_parameter msi_support_hwtcl string "true"
   set_parameter_property msi_support_hwtcl VISIBLE false
   set_parameter_property msi_support_hwtcl HDL_PARAMETER true

    #-----------------------------------------------------------------------------------------------------------------
   set group_name "MSI-X"
   add_display_item ${master_group_name} ${group_name} group
   set_display_item_property ${group_name} display_hint tab

   add_parameter enable_function_msix_support_hwtcl integer 0
   set_parameter_property enable_function_msix_support_hwtcl DISPLAY_NAME "Implement MSI-X"
   set_parameter_property enable_function_msix_support_hwtcl DISPLAY_HINT boolean
   set_parameter_property enable_function_msix_support_hwtcl GROUP $group_name
   set_parameter_property enable_function_msix_support_hwtcl VISIBLE true
   set_parameter_property enable_function_msix_support_hwtcl HDL_PARAMETER true
   set_parameter_property enable_function_msix_support_hwtcl DESCRIPTION "Enables or disables the MSI-X capability."

   add_parameter          msix_table_size_hwtcl integer 0
   set_parameter_property msix_table_size_hwtcl DISPLAY_NAME "Table size"
   set_parameter_property msix_table_size_hwtcl ALLOWED_RANGES { 0:2047 }
   set_parameter_property msix_table_size_hwtcl GROUP $group_name
   set_parameter_property msix_table_size_hwtcl VISIBLE true
   set_parameter_property msix_table_size_hwtcl HDL_PARAMETER true
   set_parameter_property msix_table_size_hwtcl DESCRIPTION "Sets the number of entries in the MSI-X table."

   add_parameter          msix_table_offset_hwtcl long 0
   set_parameter_property msix_table_offset_hwtcl DISPLAY_NAME "Table offset"
   set_parameter_property msix_table_offset_hwtcl ALLOWED_RANGES { 0:4294967295 }
   set_parameter_property msix_table_offset_hwtcl DISPLAY_HINT hexadecimal
   set_parameter_property msix_table_offset_hwtcl GROUP $group_name
   set_parameter_property msix_table_offset_hwtcl VISIBLE true
   set_parameter_property msix_table_offset_hwtcl HDL_PARAMETER true
   set_parameter_property msix_table_offset_hwtcl DESCRIPTION "Sets the read-only base address of the MSI-X table. The low-order 3 bits are automatically set to 0."

   add_parameter          msix_table_bir_hwtcl integer 0
   set_parameter_property msix_table_bir_hwtcl DISPLAY_NAME "Table BAR indicator"
   set_parameter_property msix_table_bir_hwtcl ALLOWED_RANGES { 0:5 }
   set_parameter_property msix_table_bir_hwtcl GROUP $group_name
   set_parameter_property msix_table_bir_hwtcl VISIBLE true
   set_parameter_property msix_table_bir_hwtcl HDL_PARAMETER true
   set_parameter_property msix_table_bir_hwtcl DESCRIPTION "Specifies which one of a function's base address registers, located beginning at 0x10 in the Configuration Space, maps the MSI-X table into memory space. This field is read-only."

   add_parameter          msix_pba_offset_hwtcl long 0
   set_parameter_property msix_pba_offset_hwtcl DISPLAY_NAME "Pending bit array (PBA) offset"
   set_parameter_property msix_pba_offset_hwtcl ALLOWED_RANGES { 0:4294967295 }
   set_parameter_property msix_pba_offset_hwtcl DISPLAY_HINT hexadecimal
   set_parameter_property msix_pba_offset_hwtcl GROUP $group_name
   set_parameter_property msix_pba_offset_hwtcl VISIBLE true
   set_parameter_property msix_pba_offset_hwtcl HDL_PARAMETER true
   set_parameter_property msix_pba_offset_hwtcl DESCRIPTION "Specifies the offset from the address stored in one of the function's base address registers the points to the base of the MSI-X PBA. This field is read-only."

   add_parameter          msix_pba_bir_hwtcl integer 0
   set_parameter_property msix_pba_bir_hwtcl DISPLAY_NAME "PBA BAR Indicator"
   set_parameter_property msix_pba_bir_hwtcl ALLOWED_RANGES { 0:5 }
   set_parameter_property msix_pba_bir_hwtcl GROUP $group_name
   set_parameter_property msix_pba_bir_hwtcl VISIBLE true
   set_parameter_property msix_pba_bir_hwtcl HDL_PARAMETER true
   set_parameter_property msix_pba_bir_hwtcl DESCRIPTION "Indicates which of a function's base address registers, located beginning at 0x10 in the Configuration Space, maps the function's MSI-X PBA into memory space. This field is read-only."

   #-----------------------------------------------------------------------------------------------------------------
   #set group_name "Slot"
   #add_display_item ${master_group_name} ${group_name} group
   #set_display_item_property ${group_name} display_hint tab

   add_parameter          enable_slot_register_hwtcl integer 0
   set_parameter_property enable_slot_register_hwtcl DISPLAY_NAME "Use slot register"
   set_parameter_property enable_slot_register_hwtcl DISPLAY_HINT boolean
   set_parameter_property enable_slot_register_hwtcl GROUP $group_name
   set_parameter_property enable_slot_register_hwtcl VISIBLE false
   set_parameter_property enable_slot_register_hwtcl HDL_PARAMETER true
   set_parameter_property enable_slot_register_hwtcl DESCRIPTION "Enables the slot register when Enabled. This register is required for Root Ports if a slot is implemented on the port. Slot status is recorded in the PCI Express Capabilities register."


   add_parameter          slot_power_scale_hwtcl integer 0
   set_parameter_property slot_power_scale_hwtcl DISPLAY_NAME "Slot power scale"
   set_parameter_property slot_power_scale_hwtcl ALLOWED_RANGES { 0:3 }
   set_parameter_property slot_power_scale_hwtcl GROUP $group_name
   set_parameter_property slot_power_scale_hwtcl VISIBLE false
   set_parameter_property slot_power_scale_hwtcl HDL_PARAMETER true
   set_parameter_property slot_power_scale_hwtcl DESCRIPTION "Sets the scale used for the Slot power limit value, as follows: 0=1.0<n>, 1=0.1<n>, 2=0.01<n>, 3=0.001<n>."

   add_parameter          slot_power_limit_hwtcl integer 0
   set_parameter_property slot_power_limit_hwtcl DISPLAY_NAME "Slot power limit"
   set_parameter_property slot_power_limit_hwtcl ALLOWED_RANGES { 0:255 }
   set_parameter_property slot_power_limit_hwtcl GROUP $group_name
   set_parameter_property slot_power_limit_hwtcl VISIBLE false
   set_parameter_property slot_power_limit_hwtcl HDL_PARAMETER true
   set_parameter_property slot_power_limit_hwtcl DESCRIPTION "Sets the upper limit (in Watts) of power supplied by the slot in conjunction with the slot power scale register. For more information, refer to the PCI Express Base Specification."

   add_parameter          slot_number_hwtcl integer 0
   set_parameter_property slot_number_hwtcl DISPLAY_NAME "Slot number"
   set_parameter_property slot_number_hwtcl ALLOWED_RANGES { 0:8191 }
   set_parameter_property slot_number_hwtcl GROUP $group_name
   set_parameter_property slot_number_hwtcl VISIBLE false
   set_parameter_property slot_number_hwtcl HDL_PARAMETER true
   set_parameter_property slot_number_hwtcl DESCRIPTION "Specifies the physical slot number associated with a port."

   #-----------------------------------------------------------------------------------------------------------------
   set group_name "Power Management"
   add_display_item ${master_group_name} ${group_name} group
   set_display_item_property ${group_name} display_hint tab


   add_parameter endpoint_l0_latency_hwtcl integer 0
   set_parameter_property endpoint_l0_latency_hwtcl DISPLAY_NAME "Endpoint L0s acceptable latency"
   set_parameter_property endpoint_l0_latency_hwtcl ALLOWED_RANGES { "0:Maximum of 64 ns" "1:Maximum of 128 ns" "2:Maximum of 256 ns" "3:Maximum of 512 ns" "4:Maximum of 1 us" "5:Maximum of 2 us" "6:Maximum of 4 us" "7:No limit" }
   set_parameter_property endpoint_l0_latency_hwtcl GROUP $group_name
   set_parameter_property endpoint_l0_latency_hwtcl VISIBLE true
   set_parameter_property endpoint_l0_latency_hwtcl HDL_PARAMETER true
   set_parameter_property endpoint_l0_latency_hwtcl DESCRIPTION "Sets the read-only value of the Endpoint L0s acceptable latency field of the Device Capabilities register. This value should be based on the latency that the Application Layer can tolerate. This setting is disabled for Root Ports."

   add_parameter endpoint_l1_latency_hwtcl integer 0
   set_parameter_property endpoint_l1_latency_hwtcl DISPLAY_NAME "Endpoint L1 acceptable latency"
   set_parameter_property endpoint_l1_latency_hwtcl ALLOWED_RANGES { "0:Maximum of 1 us" "1:Maximum of 2 us" "2:Maximum of 4 us" "3:Maximum of 8 us" "4:Maximum of 16 us" "5:Maximum of 32 us" "6:Maximum of 64 us" "7:No limit" }
   set_parameter_property endpoint_l1_latency_hwtcl GROUP $group_name
   set_parameter_property endpoint_l1_latency_hwtcl VISIBLE true
   set_parameter_property endpoint_l1_latency_hwtcl HDL_PARAMETER true
   set_parameter_property endpoint_l1_latency_hwtcl DESCRIPTION "Sets the acceptable latency that an Endpoint can withstand in the transition from the L1 to L0 state. It is an indirect measure of the Endpoint internal buffering. This setting is disabled for Root Ports."

}

proc add_avalon_mm_parameters {} {
   # +------------------------------PAGE 6 ( Avalon )-------------------------------------------------------------
   send_message debug "proc:add_avalon_mm_parameters"

   set group_name "Avalon-MM System Settings"

   add_parameter CG_COMMON_CLOCK_MODE integer 1
   set_parameter_property  CG_COMMON_CLOCK_MODE VISIBLE false

   add_parameter          avmm_width_hwtcl integer 256
   set_parameter_property avmm_width_hwtcl DISPLAY_NAME "Avalon-MM data width"
   set_parameter_property avmm_width_hwtcl ALLOWED_RANGES {"64:64-bit" "128:128-bit" "256:256-bit"}
   set_parameter_property avmm_width_hwtcl DESCRIPTION "Select the Avalon-MM bus width"
   set_parameter_property avmm_width_hwtcl GROUP $group_name
   set_parameter_property avmm_width_hwtcl VISIBLE false
   set_parameter_property avmm_width_hwtcl HDL_PARAMETER true

   add_parameter          avmm_burst_width_hwtcl integer 7
   set_parameter_property avmm_burst_width_hwtcl VISIBLE false
   set_parameter_property avmm_burst_width_hwtcl DERIVED true
   set_parameter_property avmm_burst_width_hwtcl HDL_PARAMETER true



   add_parameter CG_RXM_IRQ_NUM integer 16
   set_parameter_property  CG_RXM_IRQ_NUM VISIBLE false


  set group_name_address_trans "PCIe Address Space Settings"

    add_parameter          TX_S_ADDR_WIDTH integer 32
    set_parameter_property TX_S_ADDR_WIDTH DISPLAY_NAME "Address width of accessible PCIe memory space"
    set_parameter_property TX_S_ADDR_WIDTH ALLOWED_RANGES {20:64}
    set_parameter_property TX_S_ADDR_WIDTH DESCRIPTION "The address width of accessible memory space"
    set_parameter_property TX_S_ADDR_WIDTH GROUP $group_name_address_trans
    set_parameter_property TX_S_ADDR_WIDTH VISIBLE true
    set_parameter_property TX_S_ADDR_WIDTH HDL_PARAMETER true

}


proc add_pcie_hip_hidden_rtl_parameters {} {

   send_message debug "proc:add_pcie_hip_hidden_rtl_parameters"
   #-----------------------------------------------------------------------------------------------------------------
   add_parameter          ast_width_hwtcl string "Avalon-ST 64-bit"
   set_parameter_property ast_width_hwtcl ALLOWED_RANGES {"Avalon-ST 64-bit" "Avalon-ST 128-bit" "Avalon-ST 256-bit"}
   set_parameter_property ast_width_hwtcl VISIBLE false
   set_parameter_property ast_width_hwtcl DERIVED true
   set_parameter_property ast_width_hwtcl HDL_PARAMETER true

   # When non zero, addfile_set SDC file for a given QSYS design example with
   # and expected posrt signature (clock or reset)
   #
   add_parameter          generate_sdc_for_qsys_design_example integer 0
   set_parameter_property generate_sdc_for_qsys_design_example VISIBLE false
   set_parameter_property generate_sdc_for_qsys_design_example HDL_PARAMETER false

   # RX St BE
   add_parameter          use_rx_st_be_hwtcl integer 0
   set_parameter_property use_rx_st_be_hwtcl VISIBLE false
   set_parameter_property use_rx_st_be_hwtcl HDL_PARAMETER false

   # Parity
   add_parameter          use_ast_parity integer 0
   set_parameter_property use_ast_parity VISIBLE false
   set_parameter_property use_ast_parity HDL_PARAMETER true

   add_parameter          pld_clk_MHz integer 125
   set_parameter_property pld_clk_MHz VISIBLE false
   set_parameter_property pld_clk_MHz HDL_PARAMETER false
   set_parameter_property pld_clk_MHz DERIVED true

   add_parameter millisecond_cycle_count_hwtcl integer 124250
   set_parameter_property millisecond_cycle_count_hwtcl VISIBLE false
   set_parameter_property millisecond_cycle_count_hwtcl HDL_PARAMETER true
   set_parameter_property millisecond_cycle_count_hwtcl DERIVED true


   # PLL Related parameters
   #                                                                _______
   #                                 |-------pld_clk_hip----------->|      |
   #                                 |   (pldclk_hip_phase_shift)   |      |
   #                               __^_                             | HIP  |
   #                              |    |                            |      |
   #                              |PLL |                            |      |
   #   <------coreclkout<--------<|____|<------coreclkout_hip------<|______|
   #    (coreclkout_hip_phaseshift)
   #
  #add_parameter coreclkout_hip_phaseshift_hwtcl string "0 ps"
  #set_parameter_property coreclkout_hip_phaseshift_hwtcl VISIBLE false
  #set_parameter_property coreclkout_hip_phaseshift_hwtcl HDL_PARAMETER true

  #add_parameter pldclk_hip_phase_shift_hwtcl string "0 ps"
  #set_parameter_property pldclk_hip_phase_shift_hwtcl VISIBLE false
  #set_parameter_property pldclk_hip_phase_shift_hwtcl HDL_PARAMETER true


   add_parameter add_pll_to_hip_coreclkout integer 0
   set_parameter_property add_pll_to_hip_coreclkout VISIBLE false
   set_parameter_property add_pll_to_hip_coreclkout HDL_PARAMETER false

   add_parameter set_pll_coreclkout_slack integer 10
   set_parameter_property set_pll_coreclkout_slack VISIBLE false
   set_parameter_property set_pll_coreclkout_slack HDL_PARAMETER false

   add_parameter set_pll_coreclkout_cout_hwtcl string "NA"
   set_parameter_property set_pll_coreclkout_cout_hwtcl VISIBLE false
   set_parameter_property set_pll_coreclkout_cout_hwtcl HDL_PARAMETER true
   set_parameter_property set_pll_coreclkout_cout_hwtcl DERIVED true

   add_parameter set_pll_coreclkout_cin_hwtcl string "NA"
   set_parameter_property set_pll_coreclkout_cin_hwtcl VISIBLE false
   set_parameter_property set_pll_coreclkout_cin_hwtcl HDL_PARAMETER true
   set_parameter_property set_pll_coreclkout_cin_hwtcl DERIVED true

   add_parameter          port_width_be_hwtcl integer 8
   set_parameter_property port_width_be_hwtcl VISIBLE false
   set_parameter_property port_width_be_hwtcl HDL_PARAMETER true
   set_parameter_property port_width_be_hwtcl DERIVED true

   add_parameter          port_width_data_hwtcl integer 64
   set_parameter_property port_width_data_hwtcl VISIBLE false
   set_parameter_property port_width_data_hwtcl DERIVED true
   set_parameter_property port_width_data_hwtcl HDL_PARAMETER true

   # Reserved debug pins

   add_parameter          hip_reconfig_hwtcl integer 0
   set_parameter_property hip_reconfig_hwtcl VISIBLE false
   set_parameter_property hip_reconfig_hwtcl HDL_PARAMETER true

   add_parameter          vsec_id_hwtcl integer 40960
   set_parameter_property vsec_id_hwtcl VISIBLE false
   set_parameter_property vsec_id_hwtcl HDL_PARAMETER true

    add_parameter         vsec_rev_hwtcl integer 0
   set_parameter_property vsec_rev_hwtcl VISIBLE false
   set_parameter_property vsec_rev_hwtcl HDL_PARAMETER true


   #-----------------------------------------------------------------------------------------------------------------
   set group_name "Expansion ROM"
   add_parameter          expansion_base_address_register_hwtcl integer 0
   set_parameter_property expansion_base_address_register_hwtcl DISPLAY_NAME "Size"
   set_parameter_property expansion_base_address_register_hwtcl ALLOWED_RANGES { "0:Disabled" "12: 4 KBytes - 12 bits" "13: 8 KBytes - 13 bits" "14: 16 KBytes - 14 bits" "15: 32 KBytes - 15 bits" "16: 64 KBytes - 16 bits" "17: 128 KBytes - 17 bits" "18: 256 KBytes - 18 bits" "19: 512 KBytes - 19 bits" "20: 1 MByte - 20 bits" "21: 2 MBytes - 21 bits" "22: 4 MBytes - 22 bits" "23: 8 MBytes - 23 bits" "24: 16 MBytes - 24 bits"}
   set_parameter_property expansion_base_address_register_hwtcl GROUP $group_name
   set_parameter_property expansion_base_address_register_hwtcl VISIBLE false
   set_parameter_property expansion_base_address_register_hwtcl HDL_PARAMETER true
   set_parameter_property expansion_base_address_register_hwtcl DESCRIPTION "Specifies an expansion ROM from 4 KBytes - 16 MBytes when enabled."

   #-----------------------------------------------------------------------------------------------------------------
   set group_name "Base and Limit Registers for Root Port"

   add_parameter io_window_addr_width_hwtcl integer 0
   set_parameter_property io_window_addr_width_hwtcl ALLOWED_RANGES { "0:Disabled" "1:16-bit I/O addressing" "2:32-bit I/O addressing "}
   set_parameter_property io_window_addr_width_hwtcl DISPLAY_NAME "Input/Output"
   set_parameter_property io_window_addr_width_hwtcl VISIBLE false
   set_parameter_property io_window_addr_width_hwtcl GROUP $group_name
   set_parameter_property io_window_addr_width_hwtcl HDL_PARAMETER false
   set_parameter_property io_window_addr_width_hwtcl DESCRIPTION "Specifies Input/Output base and limit register."

   add_parameter prefetchable_mem_window_addr_width_hwtcl integer 0
   set_parameter_property prefetchable_mem_window_addr_width_hwtcl DISPLAY_NAME "Prefetchable memory"
   set_parameter_property prefetchable_mem_window_addr_width_hwtcl ALLOWED_RANGES { "0:Disabled" "1:32-bit memory addressing" "2:64-bit memory addressing "}
   set_parameter_property prefetchable_mem_window_addr_width_hwtcl VISIBLE false
   set_parameter_property prefetchable_mem_window_addr_width_hwtcl HDL_PARAMETER true
   set_parameter_property prefetchable_mem_window_addr_width_hwtcl GROUP $group_name
   set_parameter_property prefetchable_mem_window_addr_width_hwtcl DESCRIPTION "Specifies an expansion prefetchable memory base and limit register."

}
proc update_default_value_hidden_avmm_parameter {} {
   # Internal Avalon-ST Width
  set app_interface_width_hwtcl [ get_parameter_value app_interface_width_hwtcl ]
  set INTENDED_DEVICE_FAMILY [ get_parameter_value INTENDED_DEVICE_FAMILY ]
   if { $app_interface_width_hwtcl == 128 } {
      set_parameter_value ast_width_hwtcl  "Avalon-ST 128-bit"
      set_parameter_value DMA_WIDTH 128
      set_parameter_value DMA_BE_WIDTH 16
      set_parameter_value DMA_BRST_CNT_W 6
   } else {
      set_parameter_value ast_width_hwtcl  "Avalon-ST 256-bit"
      set_parameter_value DMA_WIDTH 256
      set_parameter_value DMA_BE_WIDTH 32
      set_parameter_value DMA_BRST_CNT_W 5
      if { $INTENDED_DEVICE_FAMILY == "Arria V" || $INTENDED_DEVICE_FAMILY == "Cyclone V" } {
         send_message error "Device family: $INTENDED_DEVICE_FAMILY only supports 128-bit application interface."
      }
   }
}


proc isBarUsed { index } {
    set result 1
    # split the contents on ,
    set bar_type_list [split [ get_parameter_value "BAR Type" ] ","]
    set value_at_index [lindex $bar_type_list $index]
    if {[ string compare -nocase $value_at_index "Not used" ] == 0 } {
        set result 0
    }
    return $result
}

proc is64bitBar { index } {

    set result 0
    # split the contents on ,
    set bar_type_list [split [ get_parameter_value "BAR Type" ] ","]
    set value_at_index [lindex $bar_type_list $index]
    if {[ string compare -nocase $value_at_index "64 bit Prefetchable" ] == 0 } {
        set result 1
    }
    return $result
}

proc validation_parameter_system_setting {} {

   set ast_width_hwtcl             [ get_parameter_value ast_width_hwtcl             ]
   set lane_mask_hwtcl             [ get_parameter_value lane_mask_hwtcl             ]
   set gen123_lane_rate_mode_hwtcl [ get_parameter_value gen123_lane_rate_mode_hwtcl ]
   set set_pld_clk_x1_625MHz_hwtcl [ get_parameter_value set_pld_clk_x1_625MHz_hwtcl ]
   set pll_refclk_freq_hwtcl       [ get_parameter_value pll_refclk_freq_hwtcl ]
   set use_atx_pll                 [ get_parameter_value use_atx_pll_hwtcl     ]
   set INTENDED_DEVICE_FAMILY      [ get_parameter_value INTENDED_DEVICE_FAMILY      ]
   set  enable_rxm_burst_hwtcl     [ get_parameter_value enable_rxm_burst_hwtcl ]

# spec version
  if { [ regexp Gen3 $gen123_lane_rate_mode_hwtcl ] } {
   set_parameter_value pcie_spec_version_hwtcl "3.0"
  }

  if { [ regexp x1 $lane_mask_hwtcl ] && [ regexp Gen1 $gen123_lane_rate_mode_hwtcl ] } {
   # Gen1:x1
      if { [ regexp 256 $ast_width_hwtcl ] || [ regexp 128 $ast_width_hwtcl ] } {
         send_message error "This IP is not supported when using $gen123_lane_rate_mode_hwtcl $lane_mask_hwtcl"
      } else {
         if { $set_pld_clk_x1_625MHz_hwtcl == 0 } {
            send_message info "The application clock frequency (pld_clk) is 125 Mhz"
            set_parameter_value pld_clk_MHz 1250
            set_parameter_value millisecond_cycle_count_hwtcl 124250
         } else {
            send_message info "The application clock frequency (pld_clk) is 62.5 Mhz"
            set_parameter_value pld_clk_MHz 625
            set_parameter_value millisecond_cycle_count_hwtcl 62125
         }
      }
   } elseif { [ regexp x1 $lane_mask_hwtcl ] && [ regexp Gen2 $gen123_lane_rate_mode_hwtcl ] } {
   # Gen2:x1
      if { [ regexp 256 $ast_width_hwtcl ] || [ regexp 128 $ast_width_hwtcl ] } {
         send_message error "This IP is not supported when using $gen123_lane_rate_mode_hwtcl $lane_mask_hwtcl"
      } else {
         send_message info "The application clock frequency (pld_clk) is 125 Mhz"
         set_parameter_value pld_clk_MHz 1250
         set_parameter_value millisecond_cycle_count_hwtcl 124250
      }
   } elseif { [ regexp x1 $lane_mask_hwtcl ] && [ regexp Gen3 $gen123_lane_rate_mode_hwtcl ] } {
   # Gen3:x1
      if { $INTENDED_DEVICE_FAMILY == "Cyclone V" || $INTENDED_DEVICE_FAMILY == "Arria V" } {
         send_message error "Device family: $INTENDED_DEVICE_FAMILY does not support $gen123_lane_rate_mode_hwtcl"
      } else {
         if { [ regexp 256 $ast_width_hwtcl ] || [ regexp 128 $ast_width_hwtcl ] } {
            send_message error "This IP is not supported when using $gen123_lane_rate_mode_hwtcl $lane_mask_hwtcl"
         } else {
            send_message info "The application clock frequency (pld_clk) is 125 Mhz"
            set_parameter_value pld_clk_MHz 1250
            set_parameter_value millisecond_cycle_count_hwtcl 124250
         }
      }
   } elseif { [ regexp x2 $lane_mask_hwtcl ] && [ regexp Gen1 $gen123_lane_rate_mode_hwtcl ]  } {
   # Gen1:x2
      if { [ regexp 256 $ast_width_hwtcl ] || [ regexp 128 $ast_width_hwtcl ] } {
         send_message error "This IP is not supported when using $gen123_lane_rate_mode_hwtcl $lane_mask_hwtcl"
      } else {
         send_message info "The application clock frequency (pld_clk) is 125 Mhz"
         set_parameter_value pld_clk_MHz 1250
         set_parameter_value millisecond_cycle_count_hwtcl 124250
      }
   } elseif { [ regexp x2 $lane_mask_hwtcl ] && [ regexp Gen2 $gen123_lane_rate_mode_hwtcl ]  } {
   # Gen2:x2
      if { [ regexp 256 $ast_width_hwtcl ] || [ regexp 128 $ast_width_hwtcl ] } {
         send_message error "This IP is not supported when using $gen123_lane_rate_mode_hwtcl $lane_mask_hwtcl"
      } else {
         send_message info "The application clock frequency (pld_clk) is 125 Mhz"
         set_parameter_value pld_clk_MHz 1250
         set_parameter_value millisecond_cycle_count_hwtcl 124250
      }
   } elseif { [ regexp x2 $lane_mask_hwtcl ] && [ regexp Gen3 $gen123_lane_rate_mode_hwtcl ]  } {
   # Gen3:x2
      if { $INTENDED_DEVICE_FAMILY == "Cyclone V" || $INTENDED_DEVICE_FAMILY == "Arria V" } {
         send_message error "Device family: $INTENDED_DEVICE_FAMILY does not support $gen123_lane_rate_mode_hwtcl"
      } else {
         if { [ regexp 256 $ast_width_hwtcl ] } {
            send_message error "The application interface must be set to 128-bit when using $gen123_lane_rate_mode_hwtcl $lane_mask_hwtcl"
         } else {
            if { [ regexp 128 $ast_width_hwtcl ] } {
               send_message info "The application clock frequency (pld_clk) is 125 Mhz"
               set_parameter_value pld_clk_MHz 1250
               set_parameter_value millisecond_cycle_count_hwtcl 124250
            } else {
               send_message info "The application clock frequency (pld_clk) is 250 Mhz"
               set_parameter_value pld_clk_MHz 2500
               set_parameter_value millisecond_cycle_count_hwtcl 248500
            }
         }
      }
   } elseif { [ regexp x4 $lane_mask_hwtcl ] && [ regexp Gen1 $gen123_lane_rate_mode_hwtcl ] } {
   # Gen1:x4
      if { [ regexp 256 $ast_width_hwtcl ] || [ regexp 128 $ast_width_hwtcl ] } {
         send_message error "This IP is not supported when using $gen123_lane_rate_mode_hwtcl $lane_mask_hwtcl"
      } else {
         send_message info "The application clock frequency (pld_clk) is 125 Mhz"
         set_parameter_value pld_clk_MHz 1250
         set_parameter_value millisecond_cycle_count_hwtcl 124250
      }
   } elseif { [ regexp x4 $lane_mask_hwtcl ] && [ regexp Gen2 $gen123_lane_rate_mode_hwtcl ] } {
   # Gen2:x4
      if { [ regexp 256 $ast_width_hwtcl ] } {
         send_message error "The application interface must be set to 128-bit when using $gen123_lane_rate_mode_hwtcl $lane_mask_hwtcl"
      } else {
         if { [ regexp 128 $ast_width_hwtcl ] } {
            send_message info "The application clock frequency (pld_clk) is 125 Mhz"
            set_parameter_value pld_clk_MHz 1250
            set_parameter_value millisecond_cycle_count_hwtcl 124250
         } else {
            send_message info "The application clock frequency (pld_clk) is 250 Mhz"
            set_parameter_value pld_clk_MHz 2500
            set_parameter_value millisecond_cycle_count_hwtcl 248500
         }
      }
   } elseif { [ regexp x4 $lane_mask_hwtcl ] && [ regexp Gen3 $gen123_lane_rate_mode_hwtcl ] } {
   # Gen3:x4
      if { $INTENDED_DEVICE_FAMILY == "Cyclone V" || $INTENDED_DEVICE_FAMILY == "Arria V" } {
         send_message error "Device family: $INTENDED_DEVICE_FAMILY does not support $gen123_lane_rate_mode_hwtcl"
      } else {
         if { [ regexp 64 $ast_width_hwtcl ] } {
            send_message error "The application interface must be set to 128-bit or 256-bit when using $gen123_lane_rate_mode_hwtcl $lane_mask_hwtcl"
         } else {
            if { [ regexp 256 $ast_width_hwtcl ] } {
               send_message info "The application clock frequency (pld_clk) is 125 Mhz"
               set_parameter_value pld_clk_MHz 1250
               set_parameter_value millisecond_cycle_count_hwtcl 124250
            } else {
               send_message info "The application clock frequency (pld_clk) is 250 Mhz"
               set_parameter_value pld_clk_MHz 2500
               set_parameter_value millisecond_cycle_count_hwtcl 248500
            }
         }
      }
   } elseif { [ regexp x8 $lane_mask_hwtcl ] && [ regexp Gen1 $gen123_lane_rate_mode_hwtcl ] } {
   # Gen1:x8
      if { $INTENDED_DEVICE_FAMILY == "Cyclone V" } {
         send_message error "Device family: $INTENDED_DEVICE_FAMILY does not support $gen123_lane_rate_mode_hwtcl $lane_mask_hwtcl"
      } else {
         if { [ regexp 256 $ast_width_hwtcl ] } {
            send_message error "The application interface must be set to 128-bit when using $gen123_lane_rate_mode_hwtcl $lane_mask_hwtcl"
         } else {
            if { [ regexp 128 $ast_width_hwtcl ] } {
               send_message info "The application clock frequency (pld_clk) is 125 Mhz"
               set_parameter_value pld_clk_MHz 1250
               set_parameter_value millisecond_cycle_count_hwtcl 124250
            } else {
               send_message info "The application clock frequency (pld_clk) is 250 Mhz"
               set_parameter_value pld_clk_MHz 2500
               set_parameter_value millisecond_cycle_count_hwtcl 248500
            }
         }
      }
   } elseif { [ regexp x8 $lane_mask_hwtcl ] && [ regexp Gen2 $gen123_lane_rate_mode_hwtcl ] } {
   # Gen2:x8
      if { $INTENDED_DEVICE_FAMILY == "Cyclone V" || $INTENDED_DEVICE_FAMILY == "Arria V" } {
         send_message error "Device family: $INTENDED_DEVICE_FAMILY does not support $gen123_lane_rate_mode_hwtcl $lane_mask_hwtcl"
      } else {
         if { [ regexp 64 $ast_width_hwtcl ] } {
            send_message error "The application interface must be set to 128-bit when using $gen123_lane_rate_mode_hwtcl $lane_mask_hwtcl"
         } else {
            if { [ regexp 256 $ast_width_hwtcl ] } {
               send_message info "The application clock frequency (pld_clk) is 125 Mhz"
               set_parameter_value pld_clk_MHz 1250
               set_parameter_value millisecond_cycle_count_hwtcl 124250
            } else {
               send_message info "The application clock frequency (pld_clk) is 250 Mhz"
               set_parameter_value pld_clk_MHz 2500
               set_parameter_value millisecond_cycle_count_hwtcl 248500
            }
         }
      }
   } else {
   # Gen3:x8
      if { $INTENDED_DEVICE_FAMILY == "Cyclone V" || $INTENDED_DEVICE_FAMILY == "Arria V" } {
         send_message error "Device family: $INTENDED_DEVICE_FAMILY does not support $gen123_lane_rate_mode_hwtcl"
      } else {
         if { [ regexp 64 $ast_width_hwtcl ] || [ regexp 128 $ast_width_hwtcl ] } {
            send_message error "The application interface must be set to 256-bit when using $gen123_lane_rate_mode_hwtcl $lane_mask_hwtcl"
         } else {
            send_message info "The application clock frequency (pld_clk) is 250 Mhz"
            set_parameter_value pld_clk_MHz 2500
            set_parameter_value millisecond_cycle_count_hwtcl 248500
         }
      }
   }
   ########################################################################################################################################
   #
   # Use PLL to upsample the clock bridge bridge
   # Controlled by hidden QSYS HWTCL param add_pll_to_hip_coreclkout, set_pll_coreclkout_slack
   #     - When add_pll_to_hip_coreclkout set, set_pll_coreclkout_slack
   #       specifies a coreclkout hip % increase
   #     - For instance add_pll_to_hip_coreclkout=1, set_pll_coreclkout_slack=10, creates coreclkout 250MHz+20%=275MHz
   #
   #  <coreclkout to AVMM------+-------------------------------------+
   #                           |                                     |
   #         |=============|   |             |=============|         |                  |=============|
   #         |             |   |             |             |         +---------pld_clk->|             |
   #         | AVMM DMA    |   |             | altera_pll  |                            |   HIP       |
   #         | Bridge     <|---+--coreclkout<|             |<cin---------coreclkout_hip<|             |
   #         |=============|                 |=============|                            |=============|
   #
   #      - When add_pll_to_hip_coreclkout is disabled
   #
   #  <coreclkout to AVMM------+-------------------------------------+
   #                           |                                     |
   #         |=============|   |                                     |                  |=============|
   #         |             |   |              ___________/|          +---------pld_clk->|             |
   #         | AVMM DMA    |   |             | GLOBAL     |                             |   HIP       |
   #         | Bridge     <|---+--coreclkout<| Buffer     |<cin----------coreclkout_hip<|             |
   #         |=============|                 |____________|                             |=============|
   #
   #
   #
   #
   set add_pll_to_hip_coreclkout [ get_parameter_value add_pll_to_hip_coreclkout ]
   set set_pll_coreclkout_slack  [ get_parameter_value set_pll_coreclkout_slack ]
   if { $add_pll_to_hip_coreclkout==1 && $set_pll_coreclkout_slack>0 } {
      set pld_clk_MHz               [ get_parameter_value pld_clk_MHz ]
      set set_pll_coreclkout_cin_hwtcl  [ expr $pld_clk_MHz/10 ]
      set set_pll_coreclkout_cout_hwtcl [ expr round(($pld_clk_MHz+($set_pll_coreclkout_slack*$pld_clk_MHz/100))/10) ]
      # Check Valid Pll ranges
      if { $set_pll_coreclkout_cin_hwtcl == 250 } {
         if { $set_pll_coreclkout_cout_hwtcl == 287 } {
            set set_pll_coreclkout_cout_hwtcl 288
         }
      }
      set_parameter_value set_pll_coreclkout_cin_hwtcl  "$set_pll_coreclkout_cin_hwtcl MHz"
      set_parameter_value set_pll_coreclkout_cout_hwtcl "$set_pll_coreclkout_cout_hwtcl MHz"
   } else {
      set_parameter_value set_pll_coreclkout_cin_hwtcl  "NA"
      set_parameter_value set_pll_coreclkout_cout_hwtcl "NA"
   }

   set in_cvp_mode_hwtcl                 [ get_parameter_value in_cvp_mode_hwtcl ]           
   
if { $INTENDED_DEVICE_FAMILY == "Stratix V" } {      
         if {$in_cvp_mode_hwtcl == 1 } {
            set port_type_hwtcl [ get_parameter_value port_type_hwtcl ]
            if { [ regexp Root $port_type_hwtcl ] } {
               send_message error "CVP is not supported for Root port variants."
            } else {
               # multiple packets per cycle is only compatible with Gen3 x8
               set force_hrc  [ get_parameter_value force_hrc     ]
               if { [ regexp $use_atx_pll 1 ] } {
                  send_message error "CVP is not supported when using ATX PLL"
               } elseif { [regexp Gen3 $gen123_lane_rate_mode_hwtcl] || ( [regexp Gen2 $gen123_lane_rate_mode_hwtcl] && ( $force_hrc == 0 ) ) } {
                  send_message error "CVP is not supported for Gen2 or Gen3 lanes rate."
               } else {
                  send_message info "CVP support for this design is enabled."
               }
            }
         }
} 


   set fhrc             [ get_parameter_value force_hrc             ]
   set fsrc             [ get_parameter_value force_src             ]
   
 if { $INTENDED_DEVICE_FAMILY == "Cyclone V" || $INTENDED_DEVICE_FAMILY == "Arria V" } {  
 
       if { $fhrc == 1 || $in_cvp_mode_hwtcl == 1} {
               set_parameter_value hip_hard_reset_hwtcl 1    
               send_message info "Hard Reset Controller is enabled"
          } elseif {  $fsrc == 1  } {
               set_parameter_value hip_hard_reset_hwtcl 0
          } else {
               set_parameter_value hip_hard_reset_hwtcl 1 
               send_message info "Hard Reset Controller is enabled"
          }
     
      if { $in_cvp_mode_hwtcl == 1} { 
           set_parameter_value  core_clk_sel_hwtcl  "core_clk_out"
         } else {
          set_parameter_value  core_clk_sel_hwtcl         "pld_clk"   
         }
     
 } else {     
        if {$use_atx_pll==1} {
             set_parameter_value hip_hard_reset_hwtcl 0
             send_message info "ATX PLL only supported with Soft Reset Controller. Hard Reset Controller is disabled"
     
             if { [ regexp Gen3 $gen123_lane_rate_mode_hwtcl ] } {
                  send_message warning "CMU PLL  is also used for all Gen3 variants"
             }
        } else {
            if { $fhrc == 1  } {
              set_parameter_value hip_hard_reset_hwtcl 1   
              send_message info "Hard Reset Controller enabled"
            } elseif {  $fsrc == 1  } {
              set_parameter_value hip_hard_reset_hwtcl 0
            } elseif { [ regexp Gen1 $gen123_lane_rate_mode_hwtcl ] } {
              set_parameter_value hip_hard_reset_hwtcl 1    
              send_message info "Hard Reset Controller enabled"
            } else {
              set_parameter_value hip_hard_reset_hwtcl 0
            }
         }
  }  
    
    

   ##################################################################################################
   #
   # Setting AST Port width parameters
   set dataWidth        [ expr [ regexp 256 $ast_width_hwtcl  ] ? 256 : [ regexp 128 $ast_width_hwtcl ] ? 128 : 64 ]
   set dataByteWidth    [ expr [ regexp 256 $ast_width_hwtcl  ] ? 32  : [ regexp 128 $ast_width_hwtcl ] ? 16 : 8 ]
   set_parameter_value port_width_data_hwtcl      $dataWidth
   set_parameter_value port_width_be_hwtcl        $dataByteWidth

   ##################################################################################################
   #
   # Interface properties update
   set pld_clk_MHz [ get_parameter_value pld_clk_MHz ]
   set_interface_property coreclkout clockRate [expr {$pld_clk_MHz * 100000}]
   set_interface_property coreclkout clockRateKnown 1
   set pll_refclk_freq  [ get_parameter_value pll_refclk_freq_hwtcl]
   set refclk_hz        [ expr [ regexp 125 $pll_refclk_freq  ] ? 125000000 :  100000000 ]
   set_interface_property refclk clockRate $refclk_hz
}


proc validation_parameter_bar {} {
    set enable_rxm_burst_hwtcl [ get_parameter_value enable_rxm_burst_hwtcl ]
    set rxbuffer_rxreq_hwtcl [ get_parameter_value rxbuffer_rxreq_hwtcl ]
  
    if { [string compare -nocase $rxbuffer_rxreq_hwtcl "Balanced"] != 0 && $enable_rxm_burst_hwtcl == 1 } {
        send_message warning  "Rx Buffer Allocation should be set to Balanced when BAR2 bursting is enable "
      }
     
    if { [string compare -nocase $rxbuffer_rxreq_hwtcl "Balanced"] == 0 && $enable_rxm_burst_hwtcl == 0 } {
        send_message warning  "Rx Buffer Allocation should be set to Low or Minimum"
      }   
     
    set port_type_hwtcl [ get_parameter_value port_type_hwtcl ]
    if { [ regexp Root $port_type_hwtcl ] } {
     set_display_item_property "Base Address Registers" VISIBLE false
   } else {
     set_display_item_property "Base Address Registers" VISIBLE true
  }

   set  bar_size_mask_hwtcl(0) [ get_parameter_value bar0_size_mask_hwtcl ]
   set  bar_size_mask_hwtcl(1) [ get_parameter_value bar1_size_mask_hwtcl ]
   set  bar_size_mask_hwtcl(2) [ get_parameter_value bar2_size_mask_hwtcl ]
   set  bar_size_mask_hwtcl(3) [ get_parameter_value bar3_size_mask_hwtcl ]
   set  bar_size_mask_hwtcl(4) [ get_parameter_value bar4_size_mask_hwtcl ]
   set  bar_size_mask_hwtcl(5) [ get_parameter_value bar5_size_mask_hwtcl ]

   set  bar_ignore_warning_size(0) 0
   set  bar_ignore_warning_size(1) 0
   set  bar_ignore_warning_size(2) 0
   set  bar_ignore_warning_size(3) 0
   set  bar_ignore_warning_size(4) 0
   set  bar_ignore_warning_size(5) 0

   set  bar_type_hwtcl(0) [ get_parameter_value bar0_type_hwtcl ]
   set  bar_type_hwtcl(1) [ get_parameter_value bar1_type_hwtcl ]
   set  bar_type_hwtcl(2) [ get_parameter_value bar2_type_hwtcl ]
   set  bar_type_hwtcl(3) [ get_parameter_value bar3_type_hwtcl ]
   set  bar_type_hwtcl(4) [ get_parameter_value bar4_type_hwtcl ]
   set  bar_type_hwtcl(5) [ get_parameter_value bar5_type_hwtcl ]

   set  internal_controller_hwtcl [ get_parameter_value internal_controller_hwtcl ]
   set enable_function_msix_support_hwtcl [ get_parameter_value enable_function_msix_support_hwtcl]

   set DISABLE_BAR             1
   set PREFETACHBLE_64_BAR     64
   set NON_PREFETCHABLE_32_BAR 32
   set PREFETCHABLE_32_BAR     3
   set IO_SPACE_BAR            4

   if { [ regexp endpoint $port_type_hwtcl ] } {
      if { $bar_type_hwtcl(0) == $DISABLE_BAR && $bar_type_hwtcl(1) == $DISABLE_BAR && $bar_type_hwtcl(2) == $DISABLE_BAR && $bar_type_hwtcl(3) == $DISABLE_BAR && $bar_type_hwtcl(4) == $DISABLE_BAR && $bar_type_hwtcl(5) == $DISABLE_BAR } {
         send_message error "This component requires one enabled BAR"
      }
      if { ($bar_type_hwtcl(0) != $PREFETACHBLE_64_BAR || $bar_type_hwtcl(1) != $DISABLE_BAR) && $internal_controller_hwtcl == 1 } {
         send_message error "When instantiating the descriptor controller internally, BAR0 must be set to 64-bit prefetchable memory and BAR1 must be disabled. These BARs are allocated specifically for the descriptor controller and cannot be used for other applications."
      }

      # 64-bit address checking
      for {set i 0} {$i < 3} {incr i 2} {
         if { $bar_type_hwtcl($i) == $PREFETACHBLE_64_BAR } {
            set ii [ expr $i+1 ]
            set bar_ignore_warning_size($ii) 1
            if { $bar_type_hwtcl($ii) > 0 } {
               set bar_type_hwtcl($ii) $DISABLE_BAR;
               send_message warning "BAR$ii is disabled as BAR$i is set to 64-bit prefetchable memory"
            }
         }
      }
      if { [ regexp Native $port_type_hwtcl ] } {
         for {set i 0} {$i < 6} {incr i 1} {
            if { $bar_type_hwtcl($i) == $PREFETCHABLE_32_BAR } {
               send_message error "BAR$i cannot be set to 32-bit prefetchable memory for Native Endpoint"
            }
            if { $bar_type_hwtcl($i) == $IO_SPACE_BAR } {
               send_message error "BAR$i cannot be set to IO Address Space for Native Endpoint"
            }
         }
      }
   } else {
      set expansion_base_address_register [ get_parameter_value expansion_base_address_register_hwtcl ]
      if { $expansion_base_address_register > 0 } {
         send_message error "Expansion ROM must be Disabled when using Root port"
      }
      if { $bar_type_hwtcl(0) == $PREFETACHBLE_64_BAR } {
         set bar_ignore_warning_size(1) 1
         if { $bar_type_hwtcl(1) > 0 } {
            set bar_type_hwtcl(1) $DISABLE_BAR
            send_message warning "BAR1 is disabled as BAR0 is set to 64-bit prefetchable memory"
         }
      }
      for {set i 0} {$i < 6} {incr i 1} {
         if {  $bar_type_hwtcl($i) > 0 } {
            send_message error "All BAR must be Disabled when using Root port"
         }
      }
   }

   # Setting derived parameter
   for {set i 0} {$i < 6} {incr i 1} {
      if { $bar_type_hwtcl($i)>1 } {
         if { $bar_size_mask_hwtcl($i)==1 && $bar_ignore_warning_size($i)==0 } {
          #  send_message error "The size of BAR$i is incorrectly set"
         }
      }
      if { $bar_type_hwtcl($i)== $DISABLE_BAR } {
         if { $i==0 || $i==2 || $i==4 } {
            set_parameter_value "bar${i}_64bit_mem_space_hwtcl" "Disabled"
         }
         set_parameter_value "bar${i}_prefetchable_hwtcl" "Disabled"
         set_parameter_value "bar${i}_io_space_hwtcl" "Disabled"
         if { $bar_size_mask_hwtcl($i)>1 && $bar_ignore_warning_size($i)==0 && [ regexp Native $port_type_hwtcl ] } {
            send_message error "The size of BAR$i must be set to N/A as BAR$i is disabled"
         }
      } elseif { $bar_type_hwtcl($i) == $PREFETACHBLE_64_BAR } {
         if { $i==0 || $i==2 || $i==4 } {
            set_parameter_value "bar${i}_64bit_mem_space_hwtcl" "Enabled"
            set_parameter_value "bar${i}_prefetchable_hwtcl" "Enabled"
            set_parameter_value "bar${i}_io_space_hwtcl" "Disabled"
         }
         if { $bar_size_mask_hwtcl($i)<7 } {
           # send_message error "The size of the 64-bit prefetchable BAR$i must be greater than 7 bits"
         }
      } elseif { $bar_type_hwtcl($i) == $NON_PREFETCHABLE_32_BAR } {
         if { $i==0 || $i==2 || $i==4 } {
            set_parameter_value "bar${i}_64bit_mem_space_hwtcl" "Disabled"
         }
         set_parameter_value "bar${i}_prefetchable_hwtcl" "Disabled"
         set_parameter_value "bar${i}_io_space_hwtcl" "Disabled"
         if { $bar_size_mask_hwtcl($i)>31 } {
            send_message error "The size of the 32-bit non-prefetchable BAR$i must be less than 31 bits"
         }
         if { $bar_size_mask_hwtcl($i)<7 } {
           # send_message error "The size of the 32-bit non-prefetchable BAR$i must be greater than 7 bits"
         }
      } elseif { $bar_type_hwtcl($i)== $PREFETCHABLE_32_BAR } {
         if { $i==0 || $i==2 || $i==4 } {
            set_parameter_value "bar${i}_64bit_mem_space_hwtcl" "Disabled"
         }
         set_parameter_value "bar${i}_prefetchable_hwtcl" "Enabled"
         set_parameter_value "bar${i}_io_space_hwtcl" "Disabled"
         if { $bar_size_mask_hwtcl($i)>31 } {
            send_message error "The size of the 32-bit prefetchable BAR$i must be less than 31 bits"
         }
         if { $bar_size_mask_hwtcl($i)<7 } {
       #     send_message error "The size of the 32-bit prefetchable BAR$i must be greater than 7 bits"
         }
      } elseif { $bar_type_hwtcl($i) == $IO_SPACE_BAR } {
         if { $i==0 || $i==2 || $i==4 } {
            set_parameter_value "bar${i}_64bit_mem_space_hwtcl" "Disabled"
         }
         set_parameter_value "bar${i}_prefetchable_hwtcl" "Disabled"
         set_parameter_value "bar${i}_io_space_hwtcl" "Enabled"
         if { $bar_size_mask_hwtcl($i)>12 } {
            send_message error "The size of the I/O space BAR$i must be less than 12 bits"
         }
      }
   }
}

proc validation_parameter_base_limit_reg {} {

   set port_type_hwtcl [ get_parameter_value port_type_hwtcl ]
   set io_window_addr_width_hwtcl               [ get_parameter_value io_window_addr_width_hwtcl               ]
   set prefetchable_mem_window_addr_width_hwtcl [ get_parameter_value prefetchable_mem_window_addr_width_hwtcl ]
   if { [ regexp endpoint $port_type_hwtcl ] } {
      if { $io_window_addr_width_hwtcl>0 } {
         send_message error "Input/Ouput base and limit register must be disabled when using endpoint"
      }
      if { $prefetchable_mem_window_addr_width_hwtcl>0 } {
         send_message error "prefetchable memory base and limit register must be disabled when using endpoint"
      }
   }
}

proc validation_parameter_pcie_cap_reg {} {

   # AER settings checks
   set use_aer_hwtcl                  [ get_parameter_value use_aer_hwtcl             ]
   set ecrc_check_capable_hwtcl       [ get_parameter_value ecrc_check_capable_hwtcl  ]
   set ecrc_gen_capable_hwtcl         [ get_parameter_value ecrc_gen_capable_hwtcl    ]
   set use_crc_forwarding_hwtcl       [ get_parameter_value use_crc_forwarding_hwtcl  ]

   if { $use_aer_hwtcl == 0 } {
      if { $ecrc_check_capable_hwtcl == 1 } {
         send_message error "Implement ECRC check cannot be set when Implement advanced error reporting is not set"
      }
      if { $ecrc_gen_capable_hwtcl == 1 } {
         send_message error "Implement ECRC generation cannot be set when Implement advanced error reporting is not set"
      }
      if { $use_crc_forwarding_hwtcl == 1 } {
         send_message error "Implement ECRC forwarding cannot be set when Implement advanced error reporting is not set"
      }
   }
}

proc validation_parameter_prj_setting {} {
   # Check that device used is Stratix V
   set INTENDED_DEVICE_FAMILY [ get_parameter_value INTENDED_DEVICE_FAMILY ]
   send_message info "Family: $INTENDED_DEVICE_FAMILY"
   if { [string compare -nocase $INTENDED_DEVICE_FAMILY "Stratix V"] != 0 && [string compare -nocase $INTENDED_DEVICE_FAMILY "Arria V GZ"] != 0 && \
        [string compare -nocase $INTENDED_DEVICE_FAMILY "Arria V"] != 0  && [string compare -nocase $INTENDED_DEVICE_FAMILY "Cyclone V"] != 0 } {
      send_message error "Selected device family: $INTENDED_DEVICE_FAMILY is not supported"
   }
}


proc add_pcie_hip_parameters_ui_pci_bar_avmm {} {

   send_message debug "proc:add_pcie_hip_parameters_ui_pci_registers"

   set group_name_all "Base Address Registers"

   #-----------------------------------------------------------------------------------------------------------------
   add_display_item "" "Base Address Registers" group
   for { set i 0 } { $i < 6 } { incr i } {
       add_display_item "Base Address Registers" "BAR${i}" group
       set_display_item_property "BAR${i}" display_hint tab
   }


   set group_name "BAR0"

   add_parameter          bar0_type_hwtcl integer 1
   set_parameter_property bar0_type_hwtcl DISPLAY_NAME "Type"
   set_parameter_property bar0_type_hwtcl ALLOWED_RANGES { "1:Disabled" "64:64-bit prefetchable memory" "32:32-bit non-prefetchable memory" }
   set_parameter_property bar0_type_hwtcl GROUP $group_name
   set_parameter_property bar0_type_hwtcl VISIBLE true
   set_parameter_property bar0_type_hwtcl HDL_PARAMETER true
   set_parameter_property bar0_type_hwtcl DESCRIPTION "Sets the BAR type."

   add_parameter          bar0_size_mask_hwtcl integer 28
   set_parameter_property bar0_size_mask_hwtcl DISPLAY_NAME "Size"
   set_parameter_property bar0_size_mask_hwtcl ALLOWED_RANGES { "0:N/A" "4: 16 Bytes - 4 bits" "5: 32 Bytes - 5 bits" "6: 64 Bytes - 6 bits" "7: 128 Bytes - 7 bits" "8: 256 Bytes - 8 bits" "9: 512 Bytes - 9 bits" "10: 1 KByte - 10 bits" "11: 2 KBytes - 11 bits" "12: 4 KBytes - 12 bits" "13: 8 KBytes - 13 bits" "14: 16 KBytes - 14 bits" "15: 32 KBytes - 15 bits" "16: 64 KBytes - 16 bits" "17: 128 KBytes - 17 bits" "18: 256 KBytes - 18 bits" "19: 512 KBytes - 19 bits" "20: 1 MByte - 20 bits" "21: 2 MBytes - 21 bits" "22: 4 MBytes - 22 bits" "23: 8 MBytes - 23 bits" "24: 16 MBytes - 24 bits" "25: 32 MBytes - 25 bits" "26: 64 MBytes - 26 bits" "27: 128 MBytes - 27 bits" "28: 256 MBytes - 28 bits" "29: 512 MBytes - 29 bits" "30: 1 GByte - 30 bits" "31: 2 GBytes - 31 bits" "32: 4 GBytes - 32 bits" "33: 8 GBytes - 33 bits" "34: 16 GBytes - 34 bits" "35: 32 GBytes - 35 bits" "36: 64 GBytes - 36 bits" "37: 128 GBytes - 37 bits" "38: 256 GBytes - 38 bits" "39: 512 GBytes - 39 bits" "40: 1 TByte - 40 bits" "41: 2 TBytes - 41 bits" "42: 4 TBytes - 42 bits" "43: 8 TBytes - 43 bits" "44: 16 TBytes - 44 bits" "45: 32 TBytes - 45 bits" "46: 64 TBytes - 46 bits" "47: 128 TBytes - 47 bits" "48: 256 TBytes - 48 bits" "49: 512 TBytes - 49 bits" "50: 1 PByte - 50 bits" "51: 2 PBytes - 51 bits" "52: 4 PBytes - 52 bits" "53: 8 PBytes - 53 bits" "54: 16 PBytes - 54 bits" "55: 32 PBytes - 55 bits" "56: 64 PBytes - 56 bits" "57: 128 PBytes - 57 bits" "58: 256 PBytes - 58 bits" "59: 512 PBytes - 59 bits" "60: 1 EByte - 60 bits" "61: 2 EBytes - 61 bits" "62: 4 EBytes - 62 bits" "63: 8 EBytes - 63 bits"}
   set_parameter_property bar0_size_mask_hwtcl GROUP $group_name
   set_parameter_property bar0_size_mask_hwtcl VISIBLE true
   set_parameter_property bar0_size_mask_hwtcl DERIVED true
   set_parameter_property bar0_size_mask_hwtcl HDL_PARAMETER true
   set_parameter_property bar0_size_mask_hwtcl DESCRIPTION "Sets from 4-63 bits per base address register (BAR)."

   add_parameter          bar0_io_space_hwtcl string "Disabled"
   set_parameter_property bar0_io_space_hwtcl DISPLAY_NAME "I/O Space"
   set_parameter_property bar0_io_space_hwtcl ALLOWED_RANGES {"Enabled" "Disabled"}
   set_parameter_property bar0_io_space_hwtcl GROUP $group_name
   set_parameter_property bar0_io_space_hwtcl VISIBLE false
   set_parameter_property bar0_io_space_hwtcl HDL_PARAMETER true
   set_parameter_property bar0_io_space_hwtcl DERIVED true
   set_parameter_property bar0_io_space_hwtcl DESCRIPTION "For x1 and x4 legacy endpoints specifies an I/O space BAR sized from 16 bytes-4 KBytes. The x8 legacy endpoint supports an I/O space BAR of 4 KBytes."

   add_parameter          bar0_64bit_mem_space_hwtcl string "Enabled"
   set_parameter_property bar0_64bit_mem_space_hwtcl DISPLAY_NAME "64-bit address"
   set_parameter_property bar0_64bit_mem_space_hwtcl ALLOWED_RANGES {"Enabled" "Disabled"}
   set_parameter_property bar0_64bit_mem_space_hwtcl GROUP $group_name
   set_parameter_property bar0_64bit_mem_space_hwtcl VISIBLE false
   set_parameter_property bar0_64bit_mem_space_hwtcl HDL_PARAMETER true
   set_parameter_property bar0_64bit_mem_space_hwtcl DERIVED true
   set_parameter_property bar0_64bit_mem_space_hwtcl DESCRIPTION "Selects either a 64-or 32-bit BAR. When 64 bits, BARs 0 and 1 combine to form a single BAR."

   add_parameter          bar0_prefetchable_hwtcl string "Enabled"
   set_parameter_property bar0_prefetchable_hwtcl DISPLAY_NAME "Prefetchable"
   set_parameter_property bar0_prefetchable_hwtcl ALLOWED_RANGES {"Enabled" "Disabled"}
   set_parameter_property bar0_prefetchable_hwtcl GROUP $group_name
   set_parameter_property bar0_prefetchable_hwtcl VISIBLE false
   set_parameter_property bar0_prefetchable_hwtcl DERIVED true
   set_parameter_property bar0_prefetchable_hwtcl HDL_PARAMETER true
   set_parameter_property bar0_prefetchable_hwtcl DESCRIPTION "Specifies whether or not the 32-bit BAR is prefetchable. The 64-bit BAR is always prefetchable."

   #-----------------------------------------------------------------------------------------------------------------
   set group_name "BAR1"

   add_parameter          bar1_type_hwtcl integer 1
   set_parameter_property bar1_type_hwtcl DISPLAY_NAME "Type"
   set_parameter_property bar1_type_hwtcl ALLOWED_RANGES { "1:Disabled" "32:32-bit non-prefetchable memory" }
   set_parameter_property bar1_type_hwtcl GROUP $group_name
   set_parameter_property bar1_type_hwtcl VISIBLE true
   set_parameter_property bar1_type_hwtcl HDL_PARAMETER true
   set_parameter_property bar1_type_hwtcl DESCRIPTION "Sets the BAR type."

   add_parameter          bar1_size_mask_hwtcl integer 1
   set_parameter_property bar1_size_mask_hwtcl DISPLAY_NAME "Size"
   set_parameter_property bar1_size_mask_hwtcl ALLOWED_RANGES { "0:N/A" "4: 16 Bytes - 4 bits" "5: 32 Bytes - 5 bits" "6: 64 Bytes - 6 bits" "7: 128 Bytes - 7 bits" "8: 256 Bytes - 8 bits" "9: 512 Bytes - 9 bits" "10: 1 KByte - 10 bits" "11: 2 KBytes - 11 bits" "12: 4 KBytes - 12 bits" "13: 8 KBytes - 13 bits" "14: 16 KBytes - 14 bits" "15: 32 KBytes - 15 bits" "16: 64 KBytes - 16 bits" "17: 128 KBytes - 17 bits" "18: 256 KBytes - 18 bits" "19: 512 KBytes - 19 bits" "20: 1 MByte - 20 bits" "21: 2 MBytes - 21 bits" "22: 4 MBytes - 22 bits" "23: 8 MBytes - 23 bits" "24: 16 MBytes - 24 bits" "25: 32 MBytes - 25 bits" "26: 64 MBytes - 26 bits" "27: 128 MBytes - 27 bits" "28: 256 MBytes - 28 bits" "29: 512 MBytes - 29 bits" "30: 1 GByte - 30 bits" "31: 2 GBytes - 31 bits"}
   set_parameter_property bar1_size_mask_hwtcl GROUP $group_name
   set_parameter_property bar1_size_mask_hwtcl VISIBLE true
   set_parameter_property bar1_size_mask_hwtcl DERIVED true
   set_parameter_property bar1_size_mask_hwtcl HDL_PARAMETER true
   set_parameter_property bar1_size_mask_hwtcl DESCRIPTION "Sets from 4-63 bits per base address register (BAR)."


   add_parameter          bar1_io_space_hwtcl string "Disabled"
   set_parameter_property bar1_io_space_hwtcl DISPLAY_NAME "I/O Space"
   set_parameter_property bar1_io_space_hwtcl ALLOWED_RANGES {"Enabled" "Disabled"}
   set_parameter_property bar1_io_space_hwtcl GROUP $group_name
   set_parameter_property bar1_io_space_hwtcl VISIBLE false
   set_parameter_property bar1_io_space_hwtcl DERIVED true
   set_parameter_property bar1_io_space_hwtcl HDL_PARAMETER true
   set_parameter_property bar1_io_space_hwtcl DESCRIPTION "For x1 and x4 legacy endpoints specifies an I/O space BAR sized from 16 bytes-4 KBytes. The x8 legacy endpoint supports an I/O space BAR of 4 KBytes."

   add_parameter          bar1_prefetchable_hwtcl string "Disabled"
   set_parameter_property bar1_prefetchable_hwtcl DISPLAY_NAME "Prefetchable"
   set_parameter_property bar1_prefetchable_hwtcl ALLOWED_RANGES {"Enabled" "Disabled"}
   set_parameter_property bar1_prefetchable_hwtcl GROUP $group_name
   set_parameter_property bar1_prefetchable_hwtcl VISIBLE false
   set_parameter_property bar1_prefetchable_hwtcl DERIVED true
   set_parameter_property bar1_prefetchable_hwtcl HDL_PARAMETER true
   set_parameter_property bar1_prefetchable_hwtcl DESCRIPTION "Specifies whether or not the 32-bit BAR is prefetchable."


   #-----------------------------------------------------------------------------------------------------------------
   set group_name "BAR2"

   add_parameter          bar2_type_hwtcl integer 1
   set_parameter_property bar2_type_hwtcl DISPLAY_NAME "Type"
   set_parameter_property bar2_type_hwtcl ALLOWED_RANGES { "1:Disabled" "64:64-bit prefetchable memory" "32:32-bit non-prefetchable memory" }
   set_parameter_property bar2_type_hwtcl GROUP $group_name
   set_parameter_property bar2_type_hwtcl VISIBLE true
   set_parameter_property bar2_type_hwtcl HDL_PARAMETER true
   set_parameter_property bar2_type_hwtcl DESCRIPTION "Sets the BAR type."

   add_parameter          bar2_size_mask_hwtcl integer 1
   set_parameter_property bar2_size_mask_hwtcl DISPLAY_NAME "Size"
   set_parameter_property bar2_size_mask_hwtcl ALLOWED_RANGES { "0:N/A" "4: 16 Bytes - 4 bits" "5: 32 Bytes - 5 bits" "6: 64 Bytes - 6 bits" "7: 128 Bytes - 7 bits" "8: 256 Bytes - 8 bits" "9: 512 Bytes - 9 bits" "10: 1 KByte - 10 bits" "11: 2 KBytes - 11 bits" "12: 4 KBytes - 12 bits" "13: 8 KBytes - 13 bits" "14: 16 KBytes - 14 bits" "15: 32 KBytes - 15 bits" "16: 64 KBytes - 16 bits" "17: 128 KBytes - 17 bits" "18: 256 KBytes - 18 bits" "19: 512 KBytes - 19 bits" "20: 1 MByte - 20 bits" "21: 2 MBytes - 21 bits" "22: 4 MBytes - 22 bits" "23: 8 MBytes - 23 bits" "24: 16 MBytes - 24 bits" "25: 32 MBytes - 25 bits" "26: 64 MBytes - 26 bits" "27: 128 MBytes - 27 bits" "28: 256 MBytes - 28 bits" "29: 512 MBytes - 29 bits" "30: 1 GByte - 30 bits" "31: 2 GBytes - 31 bits" "32: 4 GBytes - 32 bits" "33: 8 GBytes - 33 bits" "34: 16 GBytes - 34 bits" "35: 32 GBytes - 35 bits" "36: 64 GBytes - 36 bits" "37: 128 GBytes - 37 bits" "38: 256 GBytes - 38 bits" "39: 512 GBytes - 39 bits" "40: 1 TByte - 40 bits" "41: 2 TBytes - 41 bits" "42: 4 TBytes - 42 bits" "43: 8 TBytes - 43 bits" "44: 16 TBytes - 44 bits" "45: 32 TBytes - 45 bits" "46: 64 TBytes - 46 bits" "47: 128 TBytes - 47 bits" "48: 256 TBytes - 48 bits" "49: 512 TBytes - 49 bits" "50: 1 PByte - 50 bits" "51: 2 PBytes - 51 bits" "52: 4 PBytes - 52 bits" "53: 8 PBytes - 53 bits" "54: 16 PBytes - 54 bits" "55: 32 PBytes - 55 bits" "56: 64 PBytes - 56 bits" "57: 128 PBytes - 57 bits" "58: 256 PBytes - 58 bits" "59: 512 PBytes - 59 bits" "60: 1 EByte - 60 bits" "61: 2 EBytes - 61 bits" "62: 4 EBytes - 62 bits" "63: 8 EBytes - 63 bits"}
   set_parameter_property bar2_size_mask_hwtcl GROUP $group_name
   set_parameter_property bar2_size_mask_hwtcl VISIBLE true
   set_parameter_property bar2_size_mask_hwtcl DERIVED true
   set_parameter_property bar2_size_mask_hwtcl HDL_PARAMETER true
   set_parameter_property bar2_size_mask_hwtcl DESCRIPTION "Sets from 4-63 bits per base address register (BAR)."

   add_parameter          bar2_io_space_hwtcl string "Disabled"
   set_parameter_property bar2_io_space_hwtcl DISPLAY_NAME "I/O Space"
   set_parameter_property bar2_io_space_hwtcl ALLOWED_RANGES {"Enabled" "Disabled"}
   set_parameter_property bar2_io_space_hwtcl GROUP $group_name
   set_parameter_property bar2_io_space_hwtcl VISIBLE false
   set_parameter_property bar2_io_space_hwtcl DERIVED true
   set_parameter_property bar2_io_space_hwtcl HDL_PARAMETER true
   set_parameter_property bar2_io_space_hwtcl DESCRIPTION "For x1 and x4 legacy endpoints specifies an I/O space BAR sized from 16 bytes-4 KBytes. The x8 legacy endpoint supports an I/O space BAR of 4 KBytes."

   add_parameter          bar2_64bit_mem_space_hwtcl string "Disabled"
   set_parameter_property bar2_64bit_mem_space_hwtcl DISPLAY_NAME "64-bit address"
   set_parameter_property bar2_64bit_mem_space_hwtcl ALLOWED_RANGES {"Enabled" "Disabled"}
   set_parameter_property bar2_64bit_mem_space_hwtcl GROUP $group_name
   set_parameter_property bar2_64bit_mem_space_hwtcl VISIBLE false
   set_parameter_property bar2_64bit_mem_space_hwtcl DERIVED true
   set_parameter_property bar2_64bit_mem_space_hwtcl HDL_PARAMETER true
   set_parameter_property bar2_64bit_mem_space_hwtcl DESCRIPTION "Selects either a 64-or 32-bit BAR. When 64 bits, BARs 2 and 3 combine to form a single BAR."


   add_parameter          bar2_prefetchable_hwtcl string "Disabled"
   set_parameter_property bar2_prefetchable_hwtcl DISPLAY_NAME "Prefetchable"
   set_parameter_property bar2_prefetchable_hwtcl ALLOWED_RANGES {"Enabled" "Disabled"}
   set_parameter_property bar2_prefetchable_hwtcl GROUP $group_name
   set_parameter_property bar2_prefetchable_hwtcl VISIBLE false
   set_parameter_property bar2_prefetchable_hwtcl DERIVED true
   set_parameter_property bar2_prefetchable_hwtcl HDL_PARAMETER true
   set_parameter_property bar2_prefetchable_hwtcl DESCRIPTION "Specifies whether or not the 32-bit BAR is prefetchable."


   #-----------------------------------------------------------------------------------------------------------------
   set group_name "BAR3"

   add_parameter          bar3_type_hwtcl integer 1
   set_parameter_property bar3_type_hwtcl DISPLAY_NAME "Type"
   set_parameter_property bar3_type_hwtcl ALLOWED_RANGES { "1:Disabled" "32:32-bit non-prefetchable memory" }
   set_parameter_property bar3_type_hwtcl GROUP $group_name
   set_parameter_property bar3_type_hwtcl VISIBLE true
   set_parameter_property bar3_type_hwtcl HDL_PARAMETER true
   set_parameter_property bar3_type_hwtcl DESCRIPTION "Sets the BAR type."

   add_parameter          bar3_size_mask_hwtcl integer 1
   set_parameter_property bar3_size_mask_hwtcl DISPLAY_NAME "Size"
   set_parameter_property bar3_size_mask_hwtcl ALLOWED_RANGES { "0:N/A" "4: 16 Bytes - 4 bits" "5: 32 Bytes - 5 bits" "6: 64 Bytes - 6 bits" "7: 128 Bytes - 7 bits" "8: 256 Bytes - 8 bits" "9: 512 Bytes - 9 bits" "10: 1 KByte - 10 bits" "11: 2 KBytes - 11 bits" "12: 4 KBytes - 12 bits" "13: 8 KBytes - 13 bits" "14: 16 KBytes - 14 bits" "15: 32 KBytes - 15 bits" "16: 64 KBytes - 16 bits" "17: 128 KBytes - 17 bits" "18: 256 KBytes - 18 bits" "19: 512 KBytes - 19 bits" "20: 1 MByte - 20 bits" "21: 2 MBytes - 21 bits" "22: 4 MBytes - 22 bits" "23: 8 MBytes - 23 bits" "24: 16 MBytes - 24 bits" "25: 32 MBytes - 25 bits" "26: 64 MBytes - 26 bits" "27: 128 MBytes - 27 bits" "28: 256 MBytes - 28 bits" "29: 512 MBytes - 29 bits" "30: 1 GByte - 30 bits" "31: 2 GBytes - 31 bits"}
   set_parameter_property bar3_size_mask_hwtcl GROUP $group_name
   set_parameter_property bar3_size_mask_hwtcl VISIBLE true
   set_parameter_property bar3_size_mask_hwtcl DERIVED true
   set_parameter_property bar3_size_mask_hwtcl HDL_PARAMETER true
   set_parameter_property bar3_size_mask_hwtcl DESCRIPTION "Sets from 4-63 bits per base address register (BAR)."


   add_parameter          bar3_io_space_hwtcl string "Disabled"
   set_parameter_property bar3_io_space_hwtcl DISPLAY_NAME "I/O Space"
   set_parameter_property bar3_io_space_hwtcl ALLOWED_RANGES {"Enabled" "Disabled"}
   set_parameter_property bar3_io_space_hwtcl GROUP $group_name
   set_parameter_property bar3_io_space_hwtcl VISIBLE false
   set_parameter_property bar3_io_space_hwtcl DERIVED true
   set_parameter_property bar3_io_space_hwtcl HDL_PARAMETER true
   set_parameter_property bar3_io_space_hwtcl DESCRIPTION "For x1 and x4 legacy endpoints specifies an I/O space BAR sized from 16 bytes-4 KBytes. The x8 legacy endpoint supports an I/O space BAR of 4 KBytes."

   add_parameter          bar3_prefetchable_hwtcl string "Disabled"
   set_parameter_property bar3_prefetchable_hwtcl DISPLAY_NAME "Prefetchable"
   set_parameter_property bar3_prefetchable_hwtcl ALLOWED_RANGES {"Enabled" "Disabled"}
   set_parameter_property bar3_prefetchable_hwtcl GROUP $group_name
   set_parameter_property bar3_prefetchable_hwtcl VISIBLE false
   set_parameter_property bar3_prefetchable_hwtcl DERIVED true
   set_parameter_property bar3_prefetchable_hwtcl HDL_PARAMETER true
   set_parameter_property bar3_prefetchable_hwtcl DESCRIPTION "Specifies whether or not the 32-bit BAR is prefetchable."

   #-----------------------------------------------------------------------------------------------------------------
   set group_name "BAR4"

   add_parameter          bar4_type_hwtcl integer 1
   set_parameter_property bar4_type_hwtcl DISPLAY_NAME "Type"
   set_parameter_property bar4_type_hwtcl ALLOWED_RANGES { "1:Disabled" "64:64-bit prefetchable memory" "32:32-bit non-prefetchable memory" }
   set_parameter_property bar4_type_hwtcl GROUP $group_name
   set_parameter_property bar4_type_hwtcl VISIBLE true
   set_parameter_property bar4_type_hwtcl HDL_PARAMETER true
   set_parameter_property bar4_type_hwtcl DESCRIPTION "Sets the BAR type."

   add_parameter          bar4_size_mask_hwtcl integer 1
   set_parameter_property bar4_size_mask_hwtcl DISPLAY_NAME "Size"
   set_parameter_property bar4_size_mask_hwtcl ALLOWED_RANGES { "0:N/A" "4: 16 Bytes - 4 bits" "5: 32 Bytes - 5 bits" "6: 64 Bytes - 6 bits" "7: 128 Bytes - 7 bits" "8: 256 Bytes - 8 bits" "9: 512 Bytes - 9 bits" "10: 1 KByte - 10 bits" "11: 2 KBytes - 11 bits" "12: 4 KBytes - 12 bits" "13: 8 KBytes - 13 bits" "14: 16 KBytes - 14 bits" "15: 32 KBytes - 15 bits" "16: 64 KBytes - 16 bits" "17: 128 KBytes - 17 bits" "18: 256 KBytes - 18 bits" "19: 512 KBytes - 19 bits" "20: 1 MByte - 20 bits" "21: 2 MBytes - 21 bits" "22: 4 MBytes - 22 bits" "23: 8 MBytes - 23 bits" "24: 16 MBytes - 24 bits" "25: 32 MBytes - 25 bits" "26: 64 MBytes - 26 bits" "27: 128 MBytes - 27 bits" "28: 256 MBytes - 28 bits" "29: 512 MBytes - 29 bits" "30: 1 GByte - 30 bits" "31: 2 GBytes - 31 bits" "32: 4 GBytes - 32 bits" "33: 8 GBytes - 33 bits" "34: 16 GBytes - 34 bits" "35: 32 GBytes - 35 bits" "36: 64 GBytes - 36 bits" "37: 128 GBytes - 37 bits" "38: 256 GBytes - 38 bits" "39: 512 GBytes - 39 bits" "40: 1 TByte - 40 bits" "41: 2 TBytes - 41 bits" "42: 4 TBytes - 42 bits" "43: 8 TBytes - 43 bits" "44: 16 TBytes - 44 bits" "45: 32 TBytes - 45 bits" "46: 64 TBytes - 46 bits" "47: 128 TBytes - 47 bits" "48: 256 TBytes - 48 bits" "49: 512 TBytes - 49 bits" "50: 1 PByte - 50 bits" "51: 2 PBytes - 51 bits" "52: 4 PBytes - 52 bits" "53: 8 PBytes - 53 bits" "54: 16 PBytes - 54 bits" "55: 32 PBytes - 55 bits" "56: 64 PBytes - 56 bits" "57: 128 PBytes - 57 bits" "58: 256 PBytes - 58 bits" "59: 512 PBytes - 59 bits" "60: 1 EByte - 60 bits" "61: 2 EBytes - 61 bits" "62: 4 EBytes - 62 bits" "63: 8 EBytes - 63 bits"}
   set_parameter_property bar4_size_mask_hwtcl GROUP $group_name
   set_parameter_property bar4_size_mask_hwtcl VISIBLE true
   set_parameter_property bar4_size_mask_hwtcl DERIVED true
   set_parameter_property bar4_size_mask_hwtcl HDL_PARAMETER true
   set_parameter_property bar4_size_mask_hwtcl DESCRIPTION "Sets from 4-63 bits per base address register (BAR)."

   add_parameter          bar4_io_space_hwtcl string "Disabled"
   set_parameter_property bar4_io_space_hwtcl DISPLAY_NAME "I/O Space"
   set_parameter_property bar4_io_space_hwtcl ALLOWED_RANGES {"Enabled" "Disabled"}
   set_parameter_property bar4_io_space_hwtcl GROUP $group_name
   set_parameter_property bar4_io_space_hwtcl VISIBLE false
   set_parameter_property bar4_io_space_hwtcl DERIVED true
   set_parameter_property bar4_io_space_hwtcl HDL_PARAMETER true
   set_parameter_property bar4_io_space_hwtcl DESCRIPTION "For x1 and x4 legacy endpoints specifies an I/O space BAR sized from 16 bytes-4 KBytes. The x8 legacy endpoint supports an I/O space BAR of 4 KBytes."


   add_parameter          bar4_64bit_mem_space_hwtcl string "Disabled"
   set_parameter_property bar4_64bit_mem_space_hwtcl DISPLAY_NAME "64-bit address"
   set_parameter_property bar4_64bit_mem_space_hwtcl ALLOWED_RANGES {"Enabled" "Disabled"}
   set_parameter_property bar4_64bit_mem_space_hwtcl GROUP $group_name
   set_parameter_property bar4_64bit_mem_space_hwtcl VISIBLE false
   set_parameter_property bar4_64bit_mem_space_hwtcl DERIVED true
   set_parameter_property bar4_64bit_mem_space_hwtcl HDL_PARAMETER true
   set_parameter_property bar4_64bit_mem_space_hwtcl DESCRIPTION "Selects either a 64-or 32-bit BAR. When 64 bits, BARs 4 and 5 combine to form a single BAR"

   add_parameter          bar4_prefetchable_hwtcl string "Disabled"
   set_parameter_property bar4_prefetchable_hwtcl DISPLAY_NAME "Prefetchable"
   set_parameter_property bar4_prefetchable_hwtcl ALLOWED_RANGES {"Enabled" "Disabled"}
   set_parameter_property bar4_prefetchable_hwtcl GROUP $group_name
   set_parameter_property bar4_prefetchable_hwtcl VISIBLE false
   set_parameter_property bar4_prefetchable_hwtcl DERIVED true
   set_parameter_property bar4_prefetchable_hwtcl HDL_PARAMETER true
   set_parameter_property bar4_prefetchable_hwtcl DESCRIPTION "Specifies whether or not the 32-bit BAR is prefetchable."

   #-----------------------------------------------------------------------------------------------------------------
   set group_name "BAR5"

   add_parameter          bar5_type_hwtcl integer 1
   set_parameter_property bar5_type_hwtcl DISPLAY_NAME "Type"
   set_parameter_property bar5_type_hwtcl ALLOWED_RANGES { "1:Disabled" "32:32-bit non-prefetchable memory" }
   set_parameter_property bar5_type_hwtcl GROUP $group_name
   set_parameter_property bar5_type_hwtcl VISIBLE true
   set_parameter_property bar5_type_hwtcl HDL_PARAMETER true
   set_parameter_property bar5_type_hwtcl DESCRIPTION "Sets the BAR type."

   add_parameter          bar5_size_mask_hwtcl integer 1
   set_parameter_property bar5_size_mask_hwtcl DISPLAY_NAME "Size"
   set_parameter_property bar5_size_mask_hwtcl ALLOWED_RANGES {"0:N/A" "4: 16 Bytes - 4 bits" "5: 32 Bytes - 5 bits" "6: 64 Bytes - 6 bits" "7: 128 Bytes - 7 bits" "8: 256 Bytes - 8 bits" "9: 512 Bytes - 9 bits" "10: 1 KByte - 10 bits" "11: 2 KBytes - 11 bits" "12: 4 KBytes - 12 bits" "13: 8 KBytes - 13 bits" "14: 16 KBytes - 14 bits" "15: 32 KBytes - 15 bits" "16: 64 KBytes - 16 bits" "17: 128 KBytes - 17 bits" "18: 256 KBytes - 18 bits" "19: 512 KBytes - 19 bits" "20: 1 MByte - 20 bits" "21: 2 MBytes - 21 bits" "22: 4 MBytes - 22 bits" "23: 8 MBytes - 23 bits" "24: 16 MBytes - 24 bits" "25: 32 MBytes - 25 bits" "26: 64 MBytes - 26 bits" "27: 128 MBytes - 27 bits" "28: 256 MBytes - 28 bits" "29: 512 MBytes - 29 bits" "30: 1 GByte - 30 bits" "31: 2 GBytes - 31 bits"}
   set_parameter_property bar5_size_mask_hwtcl GROUP $group_name
   set_parameter_property bar5_size_mask_hwtcl VISIBLE true
   set_parameter_property bar5_size_mask_hwtcl DERIVED true
   set_parameter_property bar5_size_mask_hwtcl HDL_PARAMETER true
   set_parameter_property bar5_size_mask_hwtcl DESCRIPTION "Sets from 4-63 bits per base address register (BAR)."

   add_parameter          rd_dma_size_mask_hwtcl integer 1
   set_parameter_property rd_dma_size_mask_hwtcl DISPLAY_NAME "Size"
   set_parameter_property rd_dma_size_mask_hwtcl GROUP $group_name
   set_parameter_property rd_dma_size_mask_hwtcl VISIBLE false
   set_parameter_property rd_dma_size_mask_hwtcl DERIVED true
   set_parameter_property rd_dma_size_mask_hwtcl HDL_PARAMETER true
   set_parameter_property rd_dma_size_mask_hwtcl DESCRIPTION "Read DMA address size"

   add_parameter          wr_dma_size_mask_hwtcl integer 8
   set_parameter_property wr_dma_size_mask_hwtcl DISPLAY_NAME "Size"
   set_parameter_property wr_dma_size_mask_hwtcl GROUP $group_name
   set_parameter_property wr_dma_size_mask_hwtcl VISIBLE false
   set_parameter_property wr_dma_size_mask_hwtcl DERIVED true
   set_parameter_property wr_dma_size_mask_hwtcl HDL_PARAMETER true
   set_parameter_property wr_dma_size_mask_hwtcl DESCRIPTION "Read DMA address size"


   add_parameter          bar5_io_space_hwtcl string "Disabled"
   set_parameter_property bar5_io_space_hwtcl DISPLAY_NAME "I/O Space"
   set_parameter_property bar5_io_space_hwtcl ALLOWED_RANGES {"Enabled" "Disabled"}
   set_parameter_property bar5_io_space_hwtcl GROUP $group_name
   set_parameter_property bar5_io_space_hwtcl VISIBLE false
   set_parameter_property bar5_io_space_hwtcl DERIVED true
   set_parameter_property bar5_io_space_hwtcl HDL_PARAMETER true
   set_parameter_property bar5_io_space_hwtcl DESCRIPTION "For x1 and x4 legacy endpoints specifies an I/O space BAR sized from 16 bytes-4 KBytes. The x8 legacy endpoint supports an I/O space BAR of 4 KBytes."


   add_parameter          bar5_prefetchable_hwtcl string "Disabled"
   set_parameter_property bar5_prefetchable_hwtcl DISPLAY_NAME "Prefetchable"
   set_parameter_property bar5_prefetchable_hwtcl ALLOWED_RANGES {"Enabled" "Disabled"}
   set_parameter_property bar5_prefetchable_hwtcl GROUP $group_name
   set_parameter_property bar5_prefetchable_hwtcl VISIBLE false
   set_parameter_property bar5_prefetchable_hwtcl DERIVED true
   set_parameter_property bar5_prefetchable_hwtcl HDL_PARAMETER true
   set_parameter_property bar5_prefetchable_hwtcl DESCRIPTION "Specifies whether or not the 32-bit BAR is prefetchable."

}


proc set_pcie_hip_flow_control_settings_avcv {} {

   set icredit_type 2
   set altpcie_avmm [ get_parameter_value altpcie_avmm_hwtcl ]

   if { $altpcie_avmm > 0 } {
      set max_payload  [ get_parameter_value max_payload_size_hwtcl ]
   } else {
      set max_payload  [ get_parameter_value max_payload_size_0_hwtcl ]
   }

   set rxbuffer_rxreq_hwtcl [ get_parameter_value rxbuffer_rxreq_hwtcl ]

   
      if  { [ regexp Minimum $rxbuffer_rxreq_hwtcl ] } {
         set icredit_type 0
      } elseif { [ regexp Low $rxbuffer_rxreq_hwtcl ] } {
         set icredit_type 1
      } elseif { [ regexp High $rxbuffer_rxreq_hwtcl ] } {
         set icredit_type 3
      } elseif { [ regexp Maximum $rxbuffer_rxreq_hwtcl ] } {
         set icredit_type 4
      } else {
         set icredit_type 2
      }

   # Info display
   #
   send_message info "Credit allocation in the 6K bytes receive buffer:"
   set cred_val ""

   #For readability
   set kvc_minimum   0
   set kvc_low       1
   set kvc_balanced  2
   set kvc_high      3
   set kvc_maximum   4

      set k_vc($kvc_minimum,128)   "0 0 0 1 8 1 300 74"
      set k_vc($kvc_minimum,256)   "0 0 0 1 16 1 293 73"
      set k_vc($kvc_minimum,512)   "0 0 0 1 32 1 280 70"

      set k_vc($kvc_low,128)       "0 0 0 16 16 16 269 67"
      set k_vc($kvc_low,256)       "0 0 0 16 16 16 269 67"
      set k_vc($kvc_low,512)       "0 0 0 16 32 16 256 64"

      set k_vc($kvc_balanced,128)  "0 0 0 32 94 18 196 44"
      set k_vc($kvc_balanced,256)  "0 0 0 32 94 18 196 44"
      set k_vc($kvc_balanced,512)  "0 0 0 32 94 18 196 44"

      set k_vc($kvc_high,128)      "0 0 0 36 280 36 16 16"
      set k_vc($kvc_high,256)      "0 0 0 20 312 20 16 16"
      set k_vc($kvc_high,512)      "0 0 0 16 304 16 32 16"

      set k_vc($kvc_maximum,128)   "0 0 0 39 297 39 8 1"
      set k_vc($kvc_maximum,256)   "0 0 0 23 320 24 16 1"
      set k_vc($kvc_maximum,512)   "0 0 0 16 319 16 32 1"
 

      set cred_val $k_vc($icredit_type,$max_payload)
      set cred_array [ split $cred_val " "]
      # Cpld(0), CplH(1), NPD(2), NPH(3), PD(4), PH(5), Size CPLD(6), Size CPLH(7)

      set CPLH_ADVERTISE [ lindex $cred_array 1 ]
      set CPLD_ADVERTISE [ lindex $cred_array 0 ]
      set NPH  [ lindex $cred_array 3]
      set NPD  [ lindex $cred_array 2]
      set PH   [ lindex $cred_array 5]
      set PD   [ lindex $cred_array 4]
      set CPLH [ lindex $cred_array 7]
      set CPLD [ lindex $cred_array 6]

      set_parameter_value vc0_rx_flow_ctrl_posted_header_hwtcl $PH
      set_parameter_value vc0_rx_flow_ctrl_posted_data_hwtcl $PD
      set_parameter_value vc0_rx_flow_ctrl_nonposted_header_hwtcl $NPH
      set_parameter_value vc0_rx_flow_ctrl_nonposted_data_hwtcl $NPD
      set_parameter_value vc0_rx_flow_ctrl_compl_header_hwtcl $CPLH_ADVERTISE
      set_parameter_value vc0_rx_flow_ctrl_compl_data_hwtcl $CPLD_ADVERTISE
      set_parameter_value cpl_spc_data_hwtcl $CPLD
      set_parameter_value cpl_spc_header_hwtcl $CPLH

      send_message info "Posted    : header=$PH  data=$PD"
      send_message info "Non posted: header=$NPH  data=$NPD"
      send_message info "Completion: header=$CPLH data=$CPLD"


}

