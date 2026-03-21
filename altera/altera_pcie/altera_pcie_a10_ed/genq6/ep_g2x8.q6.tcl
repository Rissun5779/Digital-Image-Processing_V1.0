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


<?xml version="1.0" encoding="UTF-8"?>
<system name="$${FILENAME}">
 <component
   name="$${FILENAME}"
   displayName="$${FILENAME}"
   version="1.0"
   description=""
   tags=""
   categories="System" />
 <parameter name="bonusData"><![CDATA[bonusData 
{
   element $${FILENAME}
   {
      datum _originalDeviceFamily
      {
         value = "Arria 10";
         type = "String";
      }
   }
   element APPS
   {
      datum _sortIndex
      {
         value = "0";
         type = "int";
      }
      datum sopceditor_expanded
      {
         value = "1";
         type = "boolean";
      }
   }
   element DUT
   {
      datum _sortIndex
      {
         value = "1";
         type = "int";
      }
      datum sopceditor_expanded
      {
         value = "1";
         type = "boolean";
      }
   }
}
]]></parameter>
 <parameter name="clockCrossingAdapter" value="HANDSHAKE" />
 <parameter name="device" value="10AX115S1F45I1SGE2" />
 <parameter name="deviceFamily" value="Arria 10" />
 <parameter name="deviceSpeedGrade" value="Unknown" />
 <parameter name="fabricMode" value="QSYS" />
 <parameter name="generateLegacySim" value="false" />
 <parameter name="generationId" value="0" />
 <parameter name="globalResetBus" value="false" />
 <parameter name="hdlLanguage" value="VERILOG" />
 <parameter name="hideFromIPCatalog" value="false" />
 <parameter name="lockedInterfaceDefinition" value="" />
 <parameter name="maxAdditionalLatency" value="0" />
 <parameter name="projectName" value="" />
 <parameter name="sopcBorderPoints" value="false" />
 <parameter name="systemHash" value="0" />
 <parameter name="testBenchDutName" value="" />
 <parameter name="timeStamp" value="0" />
 <parameter name="useTestBenchNamingPattern" value="false" />
 <instanceScript></instanceScript>
 <interface name="apps_app_ctrl" internal="APPS.app_ctrl" />
 <interface name="apps_simu_mode_clkin" internal="APPS.simu_mode_clkin" />
 <interface
   name="currentspeed"
   internal="DUT.currentspeed"
   type="conduit"
   dir="end" />
 <interface name="hip_ctrl" internal="DUT.hip_ctrl" type="conduit" dir="end" />
 <interface name="hip_pipe" internal="DUT.hip_pipe" type="conduit" dir="end" />
 <interface name="hip_serial" internal="DUT.hip_serial" type="conduit" dir="end" />
 <interface name="pcie_rstn" internal="DUT.npor" type="conduit" dir="end" />
 <interface name="reconfig_xcvr_clk" internal="APPS.reconfig_xcvr_clk" />
 <interface name="reconfig_xcvr_rst" internal="APPS.reconfig_xcvr_rst" />
 <interface name="refclk" internal="DUT.refclk" type="clock" dir="end" />
 <module name="APPS" kind="altera_pcie_a10_ed" version="15.1" enabled="1">
  <parameter name="INTENDED_DEVICE_FAMILY" value="Arria 10" />
  <parameter name="ast_width_hwtcl" value="Avalon-ST 256-bit" />
  <parameter name="avalon_waddr_hwltcl" value="12" />
  <parameter name="check_bus_master_ena_hwtcl" value="1" />
  <parameter name="check_rx_buffer_cpl_hwtcl" value="1" />
  <parameter name="device_family_hwtcl" value="Arria 10" />
  <parameter name="enable_avst_reset_hwtcl" value="1" />
  <parameter name="enable_fpga_devkit_board_hwtcl" value="0" />
  <parameter name="enable_fpga_devkit_cbb_hwtcl" value="0" />
  <parameter name="enable_lmi_hwtcl" value="0" />
  <parameter name="extend_tag_field_hwtcl" value="64" />
  <parameter name="gen123_lane_rate_mode_hwtcl" value="Gen2 (5.0 Gbps)" />
  <parameter name="lane_mask_hwtcl" value="x8" />
  <parameter name="max_payload_size_hwtcl" value="128" />
  <parameter name="multiple_packets_per_cycle_hwtcl" value="0" />
  <parameter name="num_of_func_hwtcl" value="1" />
  <parameter name="pld_clockrate_hwtcl" value="125000000" />
  <parameter name="port_type_hwtcl" value="Native endpoint" />
  <parameter name="track_rxfc_cplbuf_ovf_hwtcl" value="0" />
  <parameter name="use_crc_forwarding_hwtcl" value="0" />
  <parameter name="use_ep_simple_downstream_apps_hwtcl" value="0" />
  <parameter name="use_rx_st_be_hwtcl" value="0" />
  <parameter name="use_tx_cons_cred_sel_hwtcl" value="0" />
 </module>
 <module name="DUT" kind="altera_pcie_a10_hip" version="15.1" enabled="1">
  <parameter name="AUTO_RXM_IRQ_INTERRUPTS_USED" value="-1" />
  <parameter name="adme_enable_hwtcl" value="0" />
  <parameter name="advance_error_reporting_hwtcl" value="1" />
  <parameter name="app_interface_width_hwtcl" value="256-bit" />
  <parameter name="ari_support_hwtcl" value="0" />
  <parameter name="avmm_addr_width_hwtcl" value="32" />
  <parameter name="bar0_address_width_hwtcl" value="28" />
  <parameter name="bar0_type_hwtcl">64-bit prefetchable memory</parameter>
  <parameter name="bar1_address_width_hwtcl" value="0" />
  <parameter name="bar1_type_hwtcl" value="Disabled" />
  <parameter name="bar2_address_width_hwtcl" value="10" />
  <parameter name="bar2_type_hwtcl">32-bit non-prefetchable memory</parameter>
  <parameter name="bar3_address_width_hwtcl" value="0" />
  <parameter name="bar3_type_hwtcl" value="Disabled" />
  <parameter name="bar4_address_width_hwtcl" value="0" />
  <parameter name="bar4_type_hwtcl" value="Disabled" />
  <parameter name="bar5_address_width_hwtcl" value="0" />
  <parameter name="bar5_type_hwtcl" value="Disabled" />
  <parameter name="base_device" value="NIGHTFURY5ES2" />
  <parameter name="bfm_drive_interface_clk_hwtcl" value="1" />
  <parameter name="bfm_drive_interface_control_hwtcl" value="1" />
  <parameter name="bfm_drive_interface_npor_hwtcl" value="1" />
  <parameter name="bfm_drive_interface_pipe_hwtcl" value="1" />
  <parameter name="cb_pcie_mode_hwtcl" value="0" />
  <parameter name="cb_pcie_rx_lite_hwtcl" value="0" />
  <parameter name="cg_a2p_addr_map_num_entries_hwtcl" value="2" />
  <parameter name="cg_a2p_addr_map_pass_thru_bits_hwtcl" value="20" />
  <parameter name="cg_enable_a2p_interrupt_hwtcl" value="1" />
  <parameter name="cg_enable_advanced_interrupt_hwtcl" value="0" />
  <parameter name="cg_impl_cra_av_slave_port_hwtcl" value="1" />
  <parameter name="class_code_hwtcl" value="16711680" />
  <parameter name="completion_timeout_disable_hwtcl" value="1" />
  <parameter name="completion_timeout_hwtcl" value="BCD" />
  <parameter name="cseb_autonomous_hwtcl" value="0" />
  <parameter name="cseb_config_bypass_hwtcl" value="0" />
  <parameter name="cseb_extend_pci_hwtcl" value="0" />
  <parameter name="cseb_extend_pcie_hwtcl" value="0" />
  <parameter name="cvp_enable_hwtcl" value="0" />
  <parameter name="deemphasis_enable_hwtcl" value="0" />
  <parameter name="design_environment_hwtcl" value="" />
  <parameter name="device_family" value="Arria 10" />
  <parameter name="device_id_hwtcl" value="57345" />
  <parameter name="dll_active_report_support_hwtcl" value="0" />
  <parameter name="dma_use_scfifo_ext_hwtcl" value="0" />
  <parameter name="ecrc_check_capable_hwtcl" value="1" />
  <parameter name="ecrc_gen_capable_hwtcl" value="1" />
  <parameter name="enable_avst_reset_hwtcl" value="1" />
  <parameter name="enable_devkit_conduit_hwtcl" value="0" />
  <parameter name="enable_example_design_qii_hwtcl" value="0" />
  <parameter name="enable_example_design_sim_hwtcl" value="0" />
  <parameter name="enable_example_design_synth_hwtcl" value="0" />
  <parameter name="enable_example_design_tb_hwtcl" value="0" />
  <parameter name="enable_function_msix_support_hwtcl" value="0" />
  <parameter name="enable_hip_status_for_avmm_hwtcl" value="0" />
  <parameter name="enable_lmi_hwtcl" value="0" />
  <parameter name="enable_pipe32_phyip_ser_driver_hwtcl" value="0" />
  <parameter name="enable_rxm_burst_hwtcl" value="0" />
  <parameter name="enable_slot_register_hwtcl" value="0" />
  <parameter name="endpoint_l0_latency_hwtcl" value="0" />
  <parameter name="endpoint_l1_latency_hwtcl" value="0" />
  <parameter name="expansion_base_address_register_hwtcl" value="0" />
  <parameter name="export_fpll_output_to_top_level_hwtcl" value="0" />
  <parameter name="export_phy_input_to_top_level_hwtcl" value="0" />
  <parameter name="extended_tag_field_hwtcl" value="32" />
  <parameter name="flr_capability_hwtcl" value="0" />
  <parameter name="hip_reconfig_hwtcl" value="0" />
  <parameter name="interface_type_hwtcl" value="Avalon-ST" />
  <parameter name="internal_controller_hwtcl" value="0" />
  <parameter name="io_window_addr_width_hwtcl" value="0" />
  <parameter name="lane_rate_hwtcl" value="Gen2 (5.0 Gbps)" />
  <parameter name="link2csr_width_hwtcl" value="16" />
  <parameter name="link_width_hwtcl" value="x8" />
  <parameter name="maximum_payload_size_hwtcl" value="128" />
  <parameter name="message_level" value="error" />
  <parameter name="msi_multi_message_capable_hwtcl" value="4" />
  <parameter name="msix_pba_bir_hwtcl" value="0" />
  <parameter name="msix_pba_offset_hwtcl" value="0" />
  <parameter name="msix_table_bir_hwtcl" value="0" />
  <parameter name="msix_table_offset_hwtcl" value="0" />
  <parameter name="msix_table_size_hwtcl" value="0" />
  <parameter name="multiple_packets_per_cycle_hwtcl" value="0" />
  <parameter name="pcie_spec_version_hwtcl" value="3.0" />
  <parameter name="pf0_bar0_prefetchable_hwtcl" value="1" />
  <parameter name="pf0_bar0_present_hwtcl" value="1" />
  <parameter name="pf0_bar0_size_hwtcl" value="12" />
  <parameter name="pf0_bar0_type_hwtcl" value="1" />
  <parameter name="pf0_bar1_prefetchable_hwtcl" value="1" />
  <parameter name="pf0_bar1_present_hwtcl" value="0" />
  <parameter name="pf0_bar1_size_hwtcl" value="12" />
  <parameter name="pf0_bar2_prefetchable_hwtcl" value="1" />
  <parameter name="pf0_bar2_present_hwtcl" value="0" />
  <parameter name="pf0_bar2_size_hwtcl" value="12" />
  <parameter name="pf0_bar2_type_hwtcl" value="1" />
  <parameter name="pf0_bar3_prefetchable_hwtcl" value="1" />
  <parameter name="pf0_bar3_present_hwtcl" value="0" />
  <parameter name="pf0_bar3_size_hwtcl" value="12" />
  <parameter name="pf0_bar4_prefetchable_hwtcl" value="1" />
  <parameter name="pf0_bar4_present_hwtcl" value="0" />
  <parameter name="pf0_bar4_size_hwtcl" value="12" />
  <parameter name="pf0_bar4_type_hwtcl" value="1" />
  <parameter name="pf0_bar5_prefetchable_hwtcl" value="1" />
  <parameter name="pf0_bar5_present_hwtcl" value="0" />
  <parameter name="pf0_bar5_size_hwtcl" value="12" />
  <parameter name="pf0_interrupt_pin_hwtcl" value="inta" />
  <parameter name="pf0_intr_line_hwtcl" value="0" />
  <parameter name="pf0_msi_multi_message_capable_hwtcl" value="4" />
  <parameter name="pf0_msix_pba_bir_hwtcl" value="0" />
  <parameter name="pf0_msix_pba_offset_hwtcl" value="0" />
  <parameter name="pf0_msix_table_bir_hwtcl" value="0" />
  <parameter name="pf0_msix_table_offset_hwtcl" value="0" />
  <parameter name="pf0_msix_table_size_hwtcl" value="0" />
  <parameter name="pf0_subclass_code_hwtcl" value="0" />
  <parameter name="pf0_vf_bar0_prefetchable_hwtcl" value="1" />
  <parameter name="pf0_vf_bar0_present_hwtcl" value="0" />
  <parameter name="pf0_vf_bar0_size_hwtcl" value="12" />
  <parameter name="pf0_vf_bar0_type_hwtcl" value="1" />
  <parameter name="pf0_vf_bar1_prefetchable_hwtcl" value="1" />
  <parameter name="pf0_vf_bar1_present_hwtcl" value="0" />
  <parameter name="pf0_vf_bar1_size_hwtcl" value="12" />
  <parameter name="pf0_vf_bar2_prefetchable_hwtcl" value="1" />
  <parameter name="pf0_vf_bar2_present_hwtcl" value="0" />
  <parameter name="pf0_vf_bar2_size_hwtcl" value="12" />
  <parameter name="pf0_vf_bar2_type_hwtcl" value="1" />
  <parameter name="pf0_vf_bar3_prefetchable_hwtcl" value="1" />
  <parameter name="pf0_vf_bar3_present_hwtcl" value="0" />
  <parameter name="pf0_vf_bar3_size_hwtcl" value="12" />
  <parameter name="pf0_vf_bar4_prefetchable_hwtcl" value="1" />
  <parameter name="pf0_vf_bar4_present_hwtcl" value="0" />
  <parameter name="pf0_vf_bar4_size_hwtcl" value="12" />
  <parameter name="pf0_vf_bar4_type_hwtcl" value="1" />
  <parameter name="pf0_vf_bar5_prefetchable_hwtcl" value="1" />
  <parameter name="pf0_vf_bar5_present_hwtcl" value="0" />
  <parameter name="pf0_vf_bar5_size_hwtcl" value="12" />
  <parameter name="pf0_vf_count_user_hwtcl" value="0" />
  <parameter name="pf0_vf_device_id_hwtcl" value="0" />
  <parameter name="pf0_vf_msix_pba_bir_hwtcl" value="0" />
  <parameter name="pf0_vf_msix_pba_offset_hwtcl" value="0" />
  <parameter name="pf0_vf_msix_tbl_bir_hwtcl" value="0" />
  <parameter name="pf0_vf_msix_tbl_offset_hwtcl" value="0" />
  <parameter name="pf0_vf_msix_tbl_size_hwtcl" value="0" />
  <parameter name="pf1_bar0_prefetchable_hwtcl" value="1" />
  <parameter name="pf1_bar0_present_hwtcl" value="0" />
  <parameter name="pf1_bar0_size_hwtcl" value="12" />
  <parameter name="pf1_bar0_type_hwtcl" value="1" />
  <parameter name="pf1_bar1_prefetchable_hwtcl" value="1" />
  <parameter name="pf1_bar1_present_hwtcl" value="0" />
  <parameter name="pf1_bar1_size_hwtcl" value="12" />
  <parameter name="pf1_bar2_prefetchable_hwtcl" value="1" />
  <parameter name="pf1_bar2_present_hwtcl" value="0" />
  <parameter name="pf1_bar2_size_hwtcl" value="12" />
  <parameter name="pf1_bar2_type_hwtcl" value="1" />
  <parameter name="pf1_bar3_prefetchable_hwtcl" value="1" />
  <parameter name="pf1_bar3_present_hwtcl" value="0" />
  <parameter name="pf1_bar3_size_hwtcl" value="12" />
  <parameter name="pf1_bar4_prefetchable_hwtcl" value="1" />
  <parameter name="pf1_bar4_present_hwtcl" value="0" />
  <parameter name="pf1_bar4_size_hwtcl" value="12" />
  <parameter name="pf1_bar4_type_hwtcl" value="1" />
  <parameter name="pf1_bar5_prefetchable_hwtcl" value="1" />
  <parameter name="pf1_bar5_present_hwtcl" value="0" />
  <parameter name="pf1_bar5_size_hwtcl" value="12" />
  <parameter name="pf1_class_code_hwtcl" value="0" />
  <parameter name="pf1_device_id_hwtcl" value="0" />
  <parameter name="pf1_interrupt_pin_hwtcl" value="inta" />
  <parameter name="pf1_intr_line_hwtcl" value="0" />
  <parameter name="pf1_msi_multi_message_capable_hwtcl" value="4" />
  <parameter name="pf1_msix_pba_bir_hwtcl" value="0" />
  <parameter name="pf1_msix_pba_offset_hwtcl" value="0" />
  <parameter name="pf1_msix_table_bir_hwtcl" value="0" />
  <parameter name="pf1_msix_table_offset_hwtcl" value="0" />
  <parameter name="pf1_msix_table_size_hwtcl" value="0" />
  <parameter name="pf1_revision_id_hwtcl" value="0" />
  <parameter name="pf1_subclass_code_hwtcl" value="0" />
  <parameter name="pf1_subsystem_device_id_hwtcl" value="0" />
  <parameter name="pf1_subsystem_vendor_id_hwtcl" value="0" />
  <parameter name="pf1_vendor_id_hwtcl" value="0" />
  <parameter name="pf1_vf_bar0_prefetchable_hwtcl" value="1" />
  <parameter name="pf1_vf_bar0_present_hwtcl" value="0" />
  <parameter name="pf1_vf_bar0_size_hwtcl" value="12" />
  <parameter name="pf1_vf_bar0_type_hwtcl" value="1" />
  <parameter name="pf1_vf_bar1_prefetchable_hwtcl" value="1" />
  <parameter name="pf1_vf_bar1_present_hwtcl" value="0" />
  <parameter name="pf1_vf_bar1_size_hwtcl" value="12" />
  <parameter name="pf1_vf_bar2_prefetchable_hwtcl" value="1" />
  <parameter name="pf1_vf_bar2_present_hwtcl" value="0" />
  <parameter name="pf1_vf_bar2_size_hwtcl" value="12" />
  <parameter name="pf1_vf_bar2_type_hwtcl" value="1" />
  <parameter name="pf1_vf_bar3_prefetchable_hwtcl" value="1" />
  <parameter name="pf1_vf_bar3_present_hwtcl" value="0" />
  <parameter name="pf1_vf_bar3_size_hwtcl" value="12" />
  <parameter name="pf1_vf_bar4_prefetchable_hwtcl" value="1" />
  <parameter name="pf1_vf_bar4_present_hwtcl" value="0" />
  <parameter name="pf1_vf_bar4_size_hwtcl" value="12" />
  <parameter name="pf1_vf_bar4_type_hwtcl" value="1" />
  <parameter name="pf1_vf_bar5_prefetchable_hwtcl" value="1" />
  <parameter name="pf1_vf_bar5_present_hwtcl" value="0" />
  <parameter name="pf1_vf_bar5_size_hwtcl" value="12" />
  <parameter name="pf1_vf_count_user_hwtcl" value="0" />
  <parameter name="pf1_vf_device_id_hwtcl" value="0" />
  <parameter name="pf1_vf_msix_pba_bir_hwtcl" value="0" />
  <parameter name="pf1_vf_msix_pba_offset_hwtcl" value="0" />
  <parameter name="pf1_vf_msix_tbl_bir_hwtcl" value="0" />
  <parameter name="pf1_vf_msix_tbl_offset_hwtcl" value="0" />
  <parameter name="pf1_vf_msix_tbl_size_hwtcl" value="0" />
  <parameter name="pf_enable_function_msix_support_hwtcl" value="0" />
  <parameter name="pf_msi_support_hwtcl" value="0" />
  <parameter name="pll_refclk_freq_hwtcl" value="100 MHz" />
  <parameter name="port_link_number_hwtcl" value="1" />
  <parameter name="port_type_hwtcl" value="Native endpoint" />
  <parameter name="prefetchable_mem_window_addr_width_hwtcl" value="0" />
  <parameter name="reserved_debug_hwtcl" value="0" />
  <parameter name="revision_id_hwtcl" value="1" />
  <parameter name="rx_buffer_credit_alloc_hwtcl" value="Low" />
  <parameter name="select_design_example_hwtcl" value="QSYS" />
  <parameter name="serial_sim_hwtcl" value="1" />
  <parameter name="set_pld_clk_x1_625MHz_hwtcl" value="0" />
  <parameter name="sim_sriov_dma_hwtcl" value="0" />
  <parameter name="slave_address_map_0_hwtcl" value="0" />
  <parameter name="slave_address_map_1_hwtcl" value="0" />
  <parameter name="slave_address_map_2_hprxm_hwtcl" value="0" />
  <parameter name="slave_address_map_2_hwtcl" value="0" />
  <parameter name="slave_address_map_3_hwtcl" value="0" />
  <parameter name="slave_address_map_4_hwtcl" value="0" />
  <parameter name="slave_address_map_5_hwtcl" value="0" />
  <parameter name="slot_clock_cfg_hwtcl" value="1" />
  <parameter name="slot_number_hwtcl" value="0" />
  <parameter name="slot_power_limit_hwtcl" value="0" />
  <parameter name="slot_power_scale_hwtcl" value="0" />
  <parameter name="speed_change_hwtcl" value="0" />
  <parameter name="sr_iov_support_hwtcl" value="0" />
  <parameter name="subsystem_device_id_hwtcl" value="19980" />
  <parameter name="subsystem_vendor_id_hwtcl" value="19995" />
  <parameter name="surprise_down_error_support_hwtcl" value="0" />
  <parameter name="system_page_sizes_supported_hwtcl" value="1363" />
  <parameter name="targeted_devkit_hwtcl">Arria 10 FPGA Development Kit</parameter>
  <parameter name="test_cseb_switch_hwtcl" value="0" />
  <parameter name="tlp_insp_trg_dw0_hwtcl" value="2049" />
  <parameter name="tlp_insp_trg_dw1_hwtcl" value="0" />
  <parameter name="tlp_insp_trg_dw2_hwtcl" value="0" />
  <parameter name="tlp_inspector_hwtcl" value="0" />
  <parameter name="tlp_inspector_use_signal_probe_hwtcl" value="0" />
  <parameter name="tlp_inspector_use_thin_rx_master" value="0" />
  <parameter name="total_pf_count_hwtcl" value="1" />
  <parameter name="track_rxfc_cplbuf_ovf_hwtcl" value="0" />
  <parameter name="use_ast_parity_hwtcl" value="0" />
  <parameter name="use_crc_forwarding_hwtcl" value="0" />
  <parameter name="use_dynamic_design_example_hwtcl" value="0" />
  <parameter name="use_rx_st_be_hwtcl" value="0" />
  <parameter name="use_tx_cons_cred_sel_hwtcl" value="0" />
  <parameter name="user_id_hwtcl" value="0" />
  <parameter name="user_txs_addr_width_hwtcl" value="32" />
  <parameter name="vendor_id_hwtcl" value="4466" />
  <parameter name="vf_msix_cap_present_hwtcl" value="0" />
  <parameter name="xcvr_reconfig_hwtcl" value="0" />
 </module>
 <connection
   kind="avalon_streaming"
   version="15.1"
   start="DUT.rx_st"
   end="APPS.rx_st" />
 <connection
   kind="avalon_streaming"
   version="15.1"
   start="APPS.tx_st"
   end="DUT.tx_st" />
 <connection
   kind="clock"
   version="15.1"
   start="DUT.coreclkout_hip"
   end="APPS.coreclkout_hip" />
 <connection
   kind="clock"
   version="15.1"
   start="APPS.pld_clk_hip"
   end="DUT.pld_clk" />
 <connection
   kind="conduit"
   version="15.1"
   start="DUT.config_tl"
   end="APPS.config_tl">
  <parameter name="endPort" value="" />
  <parameter name="endPortLSB" value="0" />
  <parameter name="startPort" value="" />
  <parameter name="startPortLSB" value="0" />
  <parameter name="width" value="0" />
 </connection>
 <connection kind="conduit" version="15.1" start="APPS.hip_rst" end="DUT.hip_rst">
  <parameter name="endPort" value="" />
  <parameter name="endPortLSB" value="0" />
  <parameter name="startPort" value="" />
  <parameter name="startPortLSB" value="0" />
  <parameter name="width" value="0" />
 </connection>
 <connection
   kind="conduit"
   version="15.1"
   start="APPS.hip_status"
   end="DUT.hip_status">
  <parameter name="endPort" value="" />
  <parameter name="endPortLSB" value="0" />
  <parameter name="startPort" value="" />
  <parameter name="startPortLSB" value="0" />
  <parameter name="width" value="0" />
 </connection>
 <connection kind="conduit" version="15.1" start="APPS.int_msi" end="DUT.int_msi">
  <parameter name="endPort" value="" />
  <parameter name="endPortLSB" value="0" />
  <parameter name="startPort" value="" />
  <parameter name="startPortLSB" value="0" />
  <parameter name="width" value="0" />
 </connection>
 <connection
   kind="conduit"
   version="15.1"
   start="APPS.power_mngt"
   end="DUT.power_mgnt">
  <parameter name="endPort" value="" />
  <parameter name="endPortLSB" value="0" />
  <parameter name="startPort" value="" />
  <parameter name="startPortLSB" value="0" />
  <parameter name="width" value="0" />
 </connection>
 <connection kind="conduit" version="15.1" start="DUT.rx_bar" end="APPS.rx_bar_be">
  <parameter name="endPort" value="" />
  <parameter name="endPortLSB" value="0" />
  <parameter name="startPort" value="" />
  <parameter name="startPortLSB" value="0" />
  <parameter name="width" value="0" />
 </connection>
 <connection kind="conduit" version="15.1" start="DUT.tx_cred" end="APPS.tx_cred">
  <parameter name="endPort" value="" />
  <parameter name="endPortLSB" value="0" />
  <parameter name="startPort" value="" />
  <parameter name="startPortLSB" value="0" />
  <parameter name="width" value="0" />
 </connection>
 <connection kind="reset" version="15.1" start="DUT.clr_st" end="APPS.clr_st" />
 <interconnectRequirement for="$system" name="qsys_mm.clockCrossingAdapter" value="HANDSHAKE" />
 <interconnectRequirement for="$system" name="qsys_mm.maxAdditionalLatency" value="0" />
</system>
