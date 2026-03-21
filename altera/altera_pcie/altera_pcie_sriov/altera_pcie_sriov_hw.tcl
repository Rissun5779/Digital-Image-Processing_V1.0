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


package require -exact qsys 14.1
# Case 198687 => revert back to 14.0
#package require -exact qsys 14.0

sopc::preview_add_transform name preview_avalon_mm_transform
source pcie_sriov_parameters.tcl
source pcie_sriov_ports.tcl

global env
set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)

source ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/pcie_sv_parameters_common.tcl
source ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie_pipe/xcvr_generic/altera_xcvr_pipe_common.tcl

pipe_decl_fileset_groups_sv_xcvr_pipe_native ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie_pipe/xcvr_generic

# +-----------------------------------
# | module PCI Express
# |
set_module_property NAME altera_pcie_sriov
set_module_property DESCRIPTION "Stratix V Hard IP for PCI Express with SR-IOV Intel FPGA IP"
set_module_property VERSION 18.1
set_module_property GROUP "Interface Protocols/PCI Express"
set_module_property AUTHOR Altera
set_module_property DISPLAY_NAME "Stratix V Hard IP for PCI Express with SR-IOV Intel FPGA IP"
set_module_property ELABORATION_CALLBACK elaboration_callback


# # +-----------------------------------
# # | Documentation
#   |
add_documentation_link "User Guide" https://documentation.altera.com/#/link/lbl1414013788823/nik1410905278518 
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697974158

# # +-----------------------------------
# # | Component Properties
#   |
set_module_property EDITABLE false
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property instantiateInSystemModule "true"
set_module_property HIDE_FROM_QUARTUS false
set_module_property HIDE_FROM_QSYS false
set_module_property INTERNAL false
set_module_property SUPPORTED_DEVICE_FAMILIES {"Stratix V"}

# # +-----------------------------------
# # | Testbench files
#   |
# This is to tell the testbench generator "my_partner_name" is a "my_partner_type"
set_module_assignment testbench.partner.pcie_tb.class  altera_pcie_tbed
set_module_assignment testbench.partner.pcie_tb.version 18.1
set_module_assignment testbench.partner.map.refclk     pcie_tb.refclk
set_module_assignment testbench.partner.map.hip_ctrl   pcie_tb.hip_ctrl
set_module_assignment testbench.partner.map.npor       pcie_tb.npor
set_module_assignment testbench.partner.map.hip_pipe   pcie_tb.hip_pipe
set_module_assignment testbench.partner.map.hip_serial pcie_tb.hip_serial

# # +-----------------------------------
# # | Global parameters
#   |
add_parameter ACDS_VERSION_HWTCL String "18.1"
set_parameter_property ACDS_VERSION_HWTCL VISIBLE FALSE
set_parameter_property ACDS_VERSION_HWTCL HDL_PARAMETER true

# # +-----------------------------------
# # | QUARTUS_SYNTH design RTL files
#   |
add_fileset synth QUARTUS_SYNTH proc_quartus_synth
set_fileset_property synth TOP_LEVEL altera_pcie_sriov_hwtcl

# # +-----------------------------------
# # | SIM_ design files
#   |
add_fileset sim_vhdl SIM_VHDL proc_sim_vhdl
set_fileset_property sim_vhdl TOP_LEVEL altera_pcie_sriov_hwtcl

add_fileset sim_verilog SIM_VERILOG proc_sim_verilog
set_fileset_property sim_verilog TOP_LEVEL altera_pcie_sriov_hwtcl

# # +-----------------------------------
# # | Example QSYS Design
#   |
add_fileset example_design {EXAMPLE_DESIGN} example_design_proc

# # | TODO parse project property to enable use of VHDL design vs VERILOG design
# #send_message info "hw.tcl dir is [get_module_property MODULE_DIRECTORY]"
# #source ./sv_xcvr_pipe_common.tcl
#
# # +-----------------------------------
# # | elaboration items
# # |
proc elaboration_callback { } {
   validation_avst_width
   validation_total_vf_count
   validation_parameter_system_setting
   validation_parameter_pf0_bar
   validation_parameter_pf1_bar
   validation_parameter_pf0_vf_bar
   validation_parameter_pf1_vf_bar
   validation_parameter_pcie_cap_reg
   update_default_value_hidden_parameter_common

   # Port updates
   add_pcie_sriov_port_ast_rx
   add_pcie_sriov_port_ast_tx
   add_pcie_sriov_port_clk
   add_pcie_sriov_port_rst
   add_pcie_sriov_port_reconfig
   add_pcie_sriov_port_serial
   add_pcie_sriov_port_pipe
   add_pcie_sriov_port_interrupt
   add_pcie_sriov_port_control
   add_pcie_sriov_port_status
   add_pcie_sriov_port_flr
   add_pcie_sriov_port_cfgstatus
   add_pcie_sriov_port_completion
   add_pcie_sriov_port_hip_misc


   # Parameter updates
   set_pcie_hip_flow_control_settings_common
   set_pcie_cvp_parameters_common
   set_module_assignment testbench.partner.pcie_tb.parameter.lane_mask_hwtcl                       [get_parameter lane_mask_hwtcl]
   set_module_assignment testbench.partner.pcie_tb.parameter.pll_refclk_freq_hwtcl                 [get_parameter pll_refclk_freq_hwtcl]
   #set_module_assignment testbench.partner.pcie_tb.parameter.port_type_hwtcl                       [get_parameter port_type_hwtcl]
   set_module_assignment testbench.partner.pcie_tb.parameter.gen123_lane_rate_mode_hwtcl           [get_parameter gen123_lane_rate_mode_hwtcl]
   set_module_assignment testbench.partner.pcie_tb.parameter.serial_sim_hwtcl                      [get_parameter serial_sim_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.enable_pipe32_sim_hwtcl               [get_parameter enable_pipe32_sim_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.enable_pipe32_phyip_ser_driver_hwtcl  [get_parameter enable_pipe32_phyip_ser_driver_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.enable_tl_only_sim_hwtcl              [get_parameter enable_tl_only_sim_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.deemphasis_enable_hwtcl               [get_parameter deemphasis_enable_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.pld_clk_MHz                           [get_parameter pld_clk_MHz ]
   set_module_assignment testbench.partner.pcie_tb.parameter.millisecond_cycle_count_hwtcl         [get_parameter millisecond_cycle_count_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.use_crc_forwarding_hwtcl              [get_parameter use_crc_forwarding_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.ecrc_check_capable_hwtcl              [get_parameter ecrc_check_capable_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.ecrc_gen_capable_hwtcl                [get_parameter ecrc_gen_capable_hwtcl ]


   set vendor_id_hwtcl         [get_parameter_value vendor_id_hwtcl ]
   set device_id_hwtcl         [get_parameter_value device_id_hwtcl ]
   set ast_width_hwtcl         [get_parameter_value ast_width_hwtcl ]
   set use_config_bypass_hwtcl [get_parameter_value use_config_bypass_hwtcl ]
   set SIM_SRIOV_DMA           [get_parameter_value SIM_SRIOV_DMA]

   set set_bfm_driver_to_config_only   1
   set set_bfm_driver_to_chaining_dma  2
   set set_bfm_driver_to_config_target 3
   set set_bfm_driver_to_simple_ep_downstream 11

   # Use latest BFM to prevent hanging condition by adding 100
   set set_bfm_driver_to_config_bypass 110
   set set_bfm_driver_to_sriov_dma 112
   set set_bfm_driver_to_sriov_target 113

   set_module_assignment testbench.partner.pcie_tb.parameter.port_type_hwtcl "Native endpoint"
   if {$SIM_SRIOV_DMA == 1} {
      set_module_assignment testbench.partner.pcie_tb.parameter.apps_type_hwtcl $set_bfm_driver_to_sriov_dma
      send_message info "Simulation with SR-IOV DMA "

   } else {
      set_module_assignment testbench.partner.pcie_tb.parameter.apps_type_hwtcl $set_bfm_driver_to_sriov_target
      send_message info "Simulation with SR-IOV Target only test"
   }
}

# +-----------------------------------
# | parameters
# |
add_pcie_hip_parameters_ui_system_settings
add_pcie_hip_parameters_ui_pci_registers
add_pcie_hip_parameters_ui_pcie_cap_registers
add_pcie_hip_hidden_rtl_parameters
add_pcie_hip_common_hidden_rtl_parameters
add_pcie_hip_gen2_vod
add_pcie_hip_parameters_gen3_coef
add_pcie_hip_parameters_phy_characteristics
add_sriov_bridge_parameters
add_pcie_sim_options

# +-----------------------------------
# | Static IO
# |
add_interface no_connect conduit end
add_pcie_hip_port_npor
add_pcie_hip_port_lmi

#add_pcie_hip_port_tl_cfg
#add_pcie_hip_port_pw_mngt

# ************** Global Variables ***************
set not_init "default"
# **************** Parameters *******************


proc proc_quartus_synth {name} {
   global QUARTUS_ROOTDIR

   set pld_clk_MHz                                    [ get_parameter_value pld_clk_MHz ]
   add_fileset_file altera_pcie_sriov_hwtcl.v  VERILOG PATH altera_pcie_sriov_hwtcl.v
   add_fileset_file altpcie_sv_hip_ast_hwtcl.v        VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/altpcie_sv_hip_ast_hwtcl.v
   add_fileset_file altpcie_hip_256_pipen1b.v         VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/altpcie_hip_256_pipen1b.v
   add_fileset_file altpcie_rs_serdes.v               VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/altpcie_rs_serdes.v
   add_fileset_file altpcie_rs_hip.v                  VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/altpcie_rs_hip.v
   add_fileset_file altpcierd_hip_rs.v                VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
   add_fileset_file altera_pcie_sriov_bridge.sv       VERILOG PATH rtl/altera_pcie_sriov_bridge.sv
   add_fileset_file altpcied_sriov_top.v              VERILOG PATH rtl/altpcied_sriov_top.v

   # Mentor
   add_fileset_file altpcied_sriov_rx_data_bridge.v               VERILOG PATH  rtl/altpcied_sriov_rx_data_bridge.v
   add_fileset_file altpcied_sriov_tx_data_bridge.v               VERILOG PATH  rtl/altpcied_sriov_tx_data_bridge.v
   add_fileset_file altpcied_sriov_cfg_dataflow.v                 VERILOG PATH  rtl/altpcied_sriov_cfg_dataflow.v
   add_fileset_file altpcied_sriov_cfg_fn0_regset.v               VERILOG PATH  rtl/altpcied_sriov_cfg_fn0_regset.v
   add_fileset_file altpcied_sriov_cfg_fn1_regset.v               VERILOG PATH  rtl/altpcied_sriov_cfg_fn1_regset.v
   add_fileset_file altpcied_sriov_rx_bar_check.v                 VERILOG PATH  rtl/altpcied_sriov_rx_bar_check.v
   add_fileset_file altpcied_sriov_cfg_vf_flr.v                   VERILOG PATH  rtl/altpcied_sriov_cfg_vf_flr.v
   add_fileset_file altpcied_sriov_cfg_vf_mux.v                   VERILOG PATH  rtl/altpcied_sriov_cfg_vf_mux.v
   add_fileset_file altpcied_sriov_cfg_vf_pci_cmd_status_reg.v    VERILOG PATH  rtl/altpcied_sriov_cfg_vf_pci_cmd_status_reg.v
   add_fileset_file altpcied_sriov_cfg_vf_pcie_dev_status_reg.v   VERILOG PATH  rtl/altpcied_sriov_cfg_vf_pcie_dev_status_reg.v
   add_fileset_file altpcied_sriov_cfg_vf_regset.v                VERILOG PATH  rtl/altpcied_sriov_cfg_vf_regset.v
   add_fileset_file altpcied_sriov_cfg_vf_msi_cap.v               VERILOG PATH  rtl/altpcied_sriov_cfg_vf_msi_cap.v

   #########################
   #
   # SDC Files addition
   #
   #add_fileset_file altpcied_sv.sdc                   SDC     PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/altpcied_sv.sdc
   set hip_hard_reset_hwtcl              [ get_parameter_value hip_hard_reset_hwtcl ]
   set enable_pcisigtest_hwtcl           [ get_parameter_value enable_pcisigtest_hwtcl ]

   add_fileset_file altera_pcie_sv_hip_ast_pipen1b.sdc SDC     PATH   ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/altera_pcie_sv_hip_ast_pipen1b.sdc

   if { $enable_pcisigtest_hwtcl == 1 } {
      add_fileset_file altera_pcie_sv_hip_ast_enable_pcisigtest.sdc  SDC PATH  ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/altera_pcie_sv_hip_ast_enable_pcisigtest.sdc
   }

   if { $hip_hard_reset_hwtcl == 0 } {
      add_fileset_file altera_pcie_sv_hip_ast_rs_serdes.sdc  SDC PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/altera_pcie_sv_hip_ast_rs_serdes.sdc
      set enable_power_on_rst_pulse_hwtcl   [ get_parameter_value enable_power_on_rst_pulse_hwtcl ]
      if { $enable_power_on_rst_pulse_hwtcl == 1 } {
         add_fileset_file altera_pcie_sv_hip_ast_enable_power_on_rst_pulse.sdc  SDC PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/altera_pcie_sv_hip_ast_enable_power_on_rst_pulse.sdc
      }
   }

   ############################################
   # HIP AST
   #
   add_quartus_sv_ast_common_fileset

   ############################################
   #
   #  PHY IP
   common_add_fileset_files { S5 ALL_HDL } { PLAIN }

}

proc proc_sim_vhdl {name} {
   global QUARTUS_ROOTDIR

   set pld_clk_MHz                                    [ get_parameter_value pld_clk_MHz ]
   add_fileset_file altera_pcie_sriov_hwtcl.v  VERILOG PATH altera_pcie_sriov_hwtcl.v
   add_fileset_file altpcie_sv_hip_ast_hwtcl.v        VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/altpcie_sv_hip_ast_hwtcl.v
   add_fileset_file altpcie_hip_256_pipen1b.v         VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/altpcie_hip_256_pipen1b.v
   add_fileset_file altpcie_rs_serdes.v               VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/altpcie_rs_serdes.v
   add_fileset_file altpcie_rs_hip.v                  VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/altpcie_rs_hip.v
   add_fileset_file altpcierd_hip_rs.v                VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
   add_fileset_file altpcie_monitor_sv_dlhip_sim.sv   SYSTEMVERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/altpcie_monitor_sv_dlhip_sim.sv
   add_fileset_file altera_pcie_sriov_bridge.sv       VERILOG PATH rtl/altera_pcie_sriov_bridge.sv
   add_fileset_file altpcied_sriov_top.v              VERILOG PATH rtl/altpcied_sriov_top.v

   # Verilog encryption
   set verilog_files {  "altpcied_sriov_rx_data_bridge.v"
                        "altpcied_sriov_tx_data_bridge.v"
                        "altpcied_sriov_cfg_dataflow.v"
                        "altpcied_sriov_cfg_fn0_regset.v"
                        "altpcied_sriov_cfg_fn1_regset.v"
                        "altpcied_sriov_rx_bar_check.v"
                        "altpcied_sriov_cfg_vf_flr.v"
                        "altpcied_sriov_cfg_vf_mux.v"
                        "altpcied_sriov_cfg_vf_pci_cmd_status_reg.v"
                        "altpcied_sriov_cfg_vf_pcie_dev_status_reg.v"
                        "altpcied_sriov_cfg_vf_regset.v"
                        "altpcied_sriov_cfg_vf_msi_cap.v"}

   foreach vf $verilog_files {
      # Co-simulation encrypted verilog files
      if {1} {
         add_fileset_file aldec/${vf} VERILOG_ENCRYPT PATH "${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sriov/aldec/rtl/${vf}" {ALDEC_SPECIFIC}
      }
      if {1} {
         add_fileset_file mentor/${vf} VERILOG_ENCRYPT PATH "${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sriov/mentor/rtl/${vf}" {MENTOR_SPECIFIC}
      }
      if {1} {
         add_fileset_file synopsys/${vf} VERILOG_ENCRYPT PATH "${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sriov/synopsys/rtl/${vf}" {SYNOPSYS_SPECIFIC}
      }
      if {1} {
         add_fileset_file cadence/${vf} VERILOG_ENCRYPT PATH "${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sriov/cadence/rtl/${vf}" {CADENCE_SPECIFIC}
      }
   }

   # Testbench files
   add_fileset_file altpcietb_bfm_cfbp.v              VERILOG_INCLUDE PATH bench/altpcietb_bfm_cfbp.v
   add_fileset_file altpcietb_bfm_shmem.v             VERILOG_INCLUDE PATH bench/altpcietb_bfm_shmem.v
   add_fileset_file altpcietb_g3bfm_shmem.v           VERILOG_INCLUDE PATH bench/altpcietb_g3bfm_shmem.v
   add_fileset_file altpcietb_pipe32_driver.v         VERILOG_INCLUDE PATH bench/altpcietb_pipe32_driver.v
   add_fileset_file altpcietb_pipe32_hip_interface.v  VERILOG_INCLUDE PATH bench/altpcietb_pipe32_hip_interface.v

   ############################################
   #
   #  HIP
   add_simvhdl_sv_ast_common_fileset

   ############################################
   #
   #  PHY IP
   common_add_fileset_files { S5 ALL_HDL } { PLAIN MENTOR}

}

proc proc_sim_verilog {name} {
   global QUARTUS_ROOTDIR

   set pld_clk_MHz                                    [ get_parameter_value pld_clk_MHz ]

  # Verilog unencrypted filess
   add_fileset_file altera_pcie_sriov_hwtcl.v         VERILOG PATH altera_pcie_sriov_hwtcl.v
   add_fileset_file altpcie_sv_hip_ast_hwtcl.v        VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/altpcie_sv_hip_ast_hwtcl.v
   add_fileset_file altpcie_hip_256_pipen1b.v         VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/altpcie_hip_256_pipen1b.v
   add_fileset_file altpcie_rs_serdes.v               VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/altpcie_rs_serdes.v
   add_fileset_file altpcie_rs_hip.v                  VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/altpcie_rs_hip.v
   add_fileset_file altpcierd_hip_rs.v                VERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_hip_ast_ed/example_design/verilog/chaining_dma/altpcierd_hip_rs.v
   add_fileset_file altpcie_monitor_sv_dlhip_sim.sv   SYSTEMVERILOG PATH ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/altpcie_monitor_sv_dlhip_sim.sv

   add_fileset_file altera_pcie_sriov_bridge.sv       VERILOG PATH rtl/altera_pcie_sriov_bridge.sv
   add_fileset_file altpcied_sriov_top.v              VERILOG PATH rtl/altpcied_sriov_top.v

   # Verilog encryption
   set verilog_files {  "altpcied_sriov_rx_data_bridge.v"
                        "altpcied_sriov_tx_data_bridge.v"
                        "altpcied_sriov_cfg_dataflow.v"
                        "altpcied_sriov_cfg_fn0_regset.v"
                        "altpcied_sriov_cfg_fn1_regset.v"
                        "altpcied_sriov_rx_bar_check.v"
                        "altpcied_sriov_cfg_vf_flr.v"
                        "altpcied_sriov_cfg_vf_mux.v"
                        "altpcied_sriov_cfg_vf_pci_cmd_status_reg.v"
                        "altpcied_sriov_cfg_vf_pcie_dev_status_reg.v"
                        "altpcied_sriov_cfg_vf_regset.v"
                        "altpcied_sriov_cfg_vf_msi_cap.v"}

   foreach vf $verilog_files {
      # Co-simulation encrypted verilog files
      if {1} {
         add_fileset_file aldec/${vf} VERILOG_ENCRYPT PATH "${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sriov/aldec/rtl/${vf}" {ALDEC_SPECIFIC}
      }
      if {1} {
         add_fileset_file mentor/${vf} VERILOG_ENCRYPT PATH "${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sriov/mentor/rtl/${vf}" {MENTOR_SPECIFIC}
      }
      if {1} {
         add_fileset_file synopsys/${vf} VERILOG_ENCRYPT PATH "${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sriov/synopsys/rtl/${vf}" {SYNOPSYS_SPECIFIC}
      }
      if {1} {
         add_fileset_file cadence/${vf} VERILOG_ENCRYPT PATH "${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sriov/cadence/rtl/${vf}" {CADENCE_SPECIFIC}
      }
   }

   # Testbench include files
   add_fileset_file altpcietb_bfm_cfbp.v              VERILOG_INCLUDE PATH bench/altpcietb_bfm_cfbp.v
   add_fileset_file altpcietb_bfm_shmem.v             VERILOG_INCLUDE PATH bench/altpcietb_bfm_shmem.v
   add_fileset_file altpcietb_g3bfm_shmem.v           VERILOG_INCLUDE PATH bench/altpcietb_g3bfm_shmem.v
   add_fileset_file altpcietb_pipe32_driver.v         VERILOG_INCLUDE PATH bench/altpcietb_pipe32_driver.v
   add_fileset_file altpcietb_pipe32_hip_interface.v  VERILOG_INCLUDE PATH bench/altpcietb_pipe32_hip_interface.v

   ############################################
   #
   #  HIP
   add_simverilog_sv_ast_common_fileset
   ############################################
   #
   #  PHY IP
   common_add_fileset_files { S5 ALL_HDL } { PLAIN }
}


proc example_design_proc { outputName } {

   global env
   set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)
   set ast_width_hwtcl [ get_parameter_value ast_width_hwtcl ]
   set port_type_hwtcl [ get_parameter_value port_type_hwtcl ]
   set gen123_lane_rate_mode_hwtcl [ get_parameter_value gen123_lane_rate_mode_hwtcl ]
   set qsysprj       "sriov_top_dma_gen3_x8_256b"

   if { [ regexp endpoint $port_type_hwtcl ] } {
      #Add EP Design example
      if { [ regexp 256 $ast_width_hwtcl ] } {
         if { [ regexp Gen3 $gen123_lane_rate_mode_hwtcl ] } {
            set qsysprj  "sriov_top_dma_gen3_x8_256b"
            add_fileset_file sriov_top_dma_gen3_x8_256b.qsys OTHER PATH ./example_design/sriov_top_dma_gen3_x8_256b.qsys
         } else {
            set qsysprj  "sriov_top_dma_gen2_x8_256b"
            add_fileset_file sriov_top_dma_gen2_x8_256b.qsys OTHER PATH ./example_design/sriov_top_dma_gen2_x8_256b.qsys
         }
   }

   #add_fileset_file altpcied_qii.tcl OTHER PATH ../altera_pcie_hip_ast_ed/example_design/altpcied_qii.tcl
   add_fileset_file run_me_first.sdc OTHER PATH ./hw_devkit/run_me_first.sdc
   add_fileset_file top_hw.sdc OTHER PATH ./hw_devkit/top_hw.sdc
   add_fileset_file top_hw.v OTHER PATH ./hw_devkit/top_hw.v
   add_fileset_file top.tcl OTHER PATH ./hw_devkit/top.tcl
  }
}

proc safe_exe {exec_list} {
    if {[catch {set gen_output [ eval $exec_list ]} errmsg]} {
        puts $errmsg
        send_message info "Failed: $exec_list"
    } else {
        puts $gen_output
    }
}
