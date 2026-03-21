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
sopc::preview_add_transform name preview_avalon_mm_transform
source ../altera_pcie_sv_hip_ast/pcie_sv_parameters.tcl
source ../altera_pcie_sv_hip_ast/pcie_sv_port.tcl

global env
set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)

source ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie_pipe/xcvr_generic/altera_xcvr_pipe_common.tcl

pipe_decl_fileset_groups_sv_xcvr_pipe_native ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie_pipe/xcvr_generic

# +-----------------------------------
# | module PCI Express
# |
set_module_property NAME altera_pcie_avgz_hip_ast
set_module_property DESCRIPTION "Arria V GZ Hard IP for PCI Express Intel FPGA IP"
set_module_property VERSION 18.1
set_module_property GROUP "Interface Protocols/PCI Express"
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "Arria V GZ Hard IP for PCI Express Intel FPGA IP"
set_module_property ELABORATION_CALLBACK elaboration_callback

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
set_module_property SUPPORTED_DEVICE_FAMILIES {"Arria V GZ"}

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
# # | Documentation
#   |
add_documentation_link "Application Note" https://documentation.altera.com/#/link/nik1412548086590/nik1412548063092
add_documentation_link "Application note" https://documentation.altera.com/#/link/nik1412473924913/nik1412473905263


add_parameter ACDS_VERSION_HWTCL String "18.1"
set_parameter_property ACDS_VERSION_HWTCL VISIBLE FALSE
set_parameter_property ACDS_VERSION_HWTCL HDL_PARAMETER true

add_parameter design_environment_hwtcl string "NATIVE"
set_parameter_property design_environment_hwtcl SYSTEM_INFO DESIGN_ENVIRONMENT
set_parameter_property design_environment_hwtcl HDL_PARAMETER false
set_parameter_property design_environment_hwtcl VISIBLE FALSE

# # +-----------------------------------
# # | QUARTUS_SYNTH design RTL files
#   |
add_fileset synth QUARTUS_SYNTH proc_quartus_synth
set_fileset_property synth TOP_LEVEL altpcie_sv_hip_ast_hwtcl

# # +-----------------------------------
# # | SIM_ design files
#   |
add_fileset sim_vhdl SIM_VHDL proc_sim_vhdl
set_fileset_property sim_vhdl TOP_LEVEL altpcie_sv_hip_ast_hwtcl

add_fileset sim_verilog SIM_VERILOG proc_sim_verilog
set_fileset_property sim_verilog TOP_LEVEL altpcie_sv_hip_ast_hwtcl

# # +-----------------------------------
# # | Example QSYS Design
#   |
add_fileset example_design {EXAMPLE_DESIGN} example_design_proc

# # +-----------------------------------
# # | elaboration items
# # |

proc validation_parameter_prj_setting {} {
   # Check that device used is Stratix V
   set INTENDED_DEVICE_FAMILY [ get_parameter_value INTENDED_DEVICE_FAMILY ]
   send_message info "Family: $INTENDED_DEVICE_FAMILY"
   send_message info "Arria V GZ Hard IP for PCI Express Intel FPGA IP v18.1"
   if { [string compare -nocase $INTENDED_DEVICE_FAMILY "Arria V GZ"] != 0 } {
      send_message error "Selected device family: $INTENDED_DEVICE_FAMILY is not supported"
   }
}

proc elaboration_callback { } {
   validation_parameter_prj_setting
   validation_parameter_system_setting
   validation_parameter_bar
   validation_parameter_base_limit_reg
   validation_parameter_pcie_cap_reg
   update_default_value_hidden_parameter_common

   # Port updates
   add_pcie_hip_port_ast_rx
   add_pcie_hip_port_ast_tx
   add_pcie_hip_port_clk
   add_pcie_hip_port_rst
   add_pcie_hip_port_reconfig
   add_pcie_hip_port_serial
   add_pcie_hip_port_pipe
   add_pcie_hip_port_interrupt
   add_pcie_hip_port_hip_reconfig
   add_pcie_hip_port_config_bypass
   add_pcie_hip_port_cseb
   add_pcie_hip_port_control
   add_pcie_hip_port_status


   # Parameter updates
   set_pcie_hip_flow_control_settings_common
   set_pcie_cvp_parameters_common
   set_module_assignment testbench.partner.pcie_tb.parameter.lane_mask_hwtcl                 [get_parameter lane_mask_hwtcl]
   set_module_assignment testbench.partner.pcie_tb.parameter.pll_refclk_freq_hwtcl           [get_parameter pll_refclk_freq_hwtcl]
   set_module_assignment testbench.partner.pcie_tb.parameter.port_type_hwtcl                 [get_parameter port_type_hwtcl]
   set_module_assignment testbench.partner.pcie_tb.parameter.gen123_lane_rate_mode_hwtcl     [get_parameter gen123_lane_rate_mode_hwtcl]
   set_module_assignment testbench.partner.pcie_tb.parameter.serial_sim_hwtcl                [get_parameter serial_sim_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.enable_pipe32_sim_hwtcl         [get_parameter enable_pipe32_sim_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.enable_tl_only_sim_hwtcl        [get_parameter enable_tl_only_sim_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.deemphasis_enable_hwtcl         [get_parameter deemphasis_enable_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.pld_clk_MHz                     [get_parameter pld_clk_MHz ]
   set_module_assignment testbench.partner.pcie_tb.parameter.millisecond_cycle_count_hwtcl   [get_parameter millisecond_cycle_count_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.use_crc_forwarding_hwtcl        [get_parameter use_crc_forwarding_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.ecrc_check_capable_hwtcl        [get_parameter ecrc_check_capable_hwtcl ]
   set_module_assignment testbench.partner.pcie_tb.parameter.ecrc_gen_capable_hwtcl          [get_parameter ecrc_gen_capable_hwtcl ]


   set vendor_id_hwtcl [get_parameter_value vendor_id_hwtcl ]
   set device_id_hwtcl [get_parameter_value device_id_hwtcl ]
   set ast_width_hwtcl [get_parameter_value ast_width_hwtcl ]

   # Setting testbench driver
   # If Vendor ID == 0x1172 && Device ID == 0xE001 --> assign driver to DMA or target
   # else  assign driver to training & configuration only
   # set_parameter_property apps_type_hwtcl ALLOWED_RANGES {"1:Link training and configuration" "2:Link training, configuration and chaining DMA" "3:Link training, configuration and target"}
   if { $vendor_id_hwtcl == 4466 && $device_id_hwtcl == 57345 } {
      if { [ regexp 256 $ast_width_hwtcl ] } {
        set_module_assignment testbench.partner.pcie_tb.parameter.apps_type_hwtcl 3
        send_message info "When using VendorID:0x1172 and DeviceID:0xE001 the generated testbench driver will run a simulation which includes link training, configuration and target"
      } else {
        set_module_assignment testbench.partner.pcie_tb.parameter.apps_type_hwtcl 2
        send_message info "When using VendorID:0x1172 and DeviceID:0xE001 the generated testbench driver will run a simulation which includes link training, configuration and chaining DMA"
      }
   } else {
     set_module_assignment testbench.partner.pcie_tb.parameter.apps_type_hwtcl  1
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

# +-----------------------------------
# | Static IO
# |
add_interface no_connect conduit end
add_pcie_hip_port_npor
add_pcie_hip_port_lmi
add_pcie_hip_port_tl_cfg
add_pcie_hip_port_pw_mngt

# ************** Global Variables ***************
set not_init "default"
# **************** Parameters *******************


proc proc_quartus_synth {name} {

   set pld_clk_MHz                                    [ get_parameter_value pld_clk_MHz ]
   add_quartus_sv_ast_common_fileset

   common_add_fileset_files { S5 ALL_HDL } { PLAIN }

   #########################
   #
   # SDC Files addition
   #
   set hip_hard_reset_hwtcl              [ get_parameter_value hip_hard_reset_hwtcl ]
   set enable_pcisigtest_hwtcl           [ get_parameter_value enable_pcisigtest_hwtcl ]

   add_fileset_file altera_pcie_sv_hip_ast_pipen1b.sdc                     SDC     PATH ../altera_pcie_sv_hip_ast/altera_pcie_sv_hip_ast_pipen1b.sdc

   if { $enable_pcisigtest_hwtcl == 1 } {
      add_fileset_file altera_pcie_sv_hip_ast_enable_pcisigtest.sdc  SDC     PATH ../altera_pcie_sv_hip_ast/altera_pcie_sv_hip_ast_enable_pcisigtest.sdc
   }

   if { $hip_hard_reset_hwtcl == 0 } {
      add_fileset_file altera_pcie_sv_hip_ast_rs_serdes.sdc          SDC     PATH ../altera_pcie_sv_hip_ast/altera_pcie_sv_hip_ast_rs_serdes.sdc
      set enable_power_on_rst_pulse_hwtcl   [ get_parameter_value enable_power_on_rst_pulse_hwtcl ]
      if { $enable_power_on_rst_pulse_hwtcl == 1 } {
         add_fileset_file altera_pcie_sv_hip_ast_enable_power_on_rst_pulse.sdc          SDC     PATH ../altera_pcie_sv_hip_ast/altera_pcie_sv_hip_ast_enable_power_on_rst_pulse.sdc
      }
   }
}

proc proc_sim_vhdl {name} {

   add_simvhdl_sv_ast_common_fileset
   common_add_fileset_files { S5 ALL_HDL } { PLAIN MENTOR  }
}

proc proc_sim_verilog {name} {
   add_simverilog_sv_ast_common_fileset
   common_add_fileset_files { S5 ALL_HDL } { PLAIN }
}


proc example_design_proc { outputName } {

   global env
   set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)
   set ast_width_hwtcl [ get_parameter_value ast_width_hwtcl ]
   set port_type_hwtcl [ get_parameter_value port_type_hwtcl ]
   set gen123_lane_rate_mode_hwtcl [ get_parameter_value gen123_lane_rate_mode_hwtcl ]
   set qsysprj       "pcie_de_gen1_x4_ast64"

   if { [ regexp endpoint $port_type_hwtcl ] } {
      #Add EP Design example
      if { [ regexp 256 $ast_width_hwtcl ] } {
         if { [ regexp Gen3 $gen123_lane_rate_mode_hwtcl ] } {
            set qsysprj  "pcie_de_gen3_x8_ast256"
            add_fileset_file pcie_de_gen3_x8_ast256.qsys OTHER PATH ../altera_pcie_hip_ast_ed/example_design/avgz/pcie_de_gen3_x8_ast256.qsys
         } else {
            set qsysprj  "pcie_de_gen2_x8_ast256"
            add_fileset_file pcie_de_gen2_x8_ast256.qsys OTHER PATH ../altera_pcie_hip_ast_ed/example_design/avgz/pcie_de_gen2_x8_ast256.qsys
         }
      } elseif { [ regexp 128 $ast_width_hwtcl ] } {
         if { [ regexp Gen3 $gen123_lane_rate_mode_hwtcl ] } {
            set qsysprj  "pcie_de_gen3_x4_ast128"
            add_fileset_file pcie_de_gen3_x4_ast128.qsys OTHER PATH ../altera_pcie_hip_ast_ed/example_design/avgz/pcie_de_gen3_x4_ast128.qsys
         } else {
            set qsysprj  "pcie_de_gen1_x8_ast128"
            add_fileset_file pcie_de_gen1_x8_ast128.qsys OTHER PATH ../altera_pcie_hip_ast_ed/example_design/avgz/pcie_de_gen1_x8_ast128.qsys
         }
      } else {
          if { [ regexp Gen3 $gen123_lane_rate_mode_hwtcl ] } {
            set qsysprj  "pcie_de_gen3_x1_ast64"
            add_fileset_file pcie_de_gen3_x1_ast64.qsys OTHER PATH ../altera_pcie_hip_ast_ed/example_design/avgz/pcie_de_gen3_x1_ast64.qsys
         } else {
            set qsysprj  "pcie_de_gen1_x4_ast64"
            add_fileset_file pcie_de_gen1_x4_ast64.qsys OTHER PATH ../altera_pcie_hip_ast_ed/example_design/avgz/pcie_de_gen1_x4_ast64.qsys
         }
      }
   } else {
      #Add RP Design example
      if { [ regexp 128 $ast_width_hwtcl ] } {
         set qsysprj  "pcie_de_rp_gen1_x8_ast128"
         add_fileset_file pcie_de_rp_gen1_x8_ast128.qsys OTHER PATH ../altera_pcie_hip_ast_ed/example_design/avgz/pcie_de_rp_gen1_x8_ast128.qsys
      } else {
         set qsysprj  "pcie_de_rp_gen1_x4_ast64"
         add_fileset_file pcie_de_rp_gen1_x4_ast64.qsys OTHER PATH ../altera_pcie_hip_ast_ed/example_design/avgz/pcie_de_rp_gen1_x4_ast64.qsys
      }
   }

   add_fileset_file altpcied_qii.tcl OTHER PATH ../altera_pcie_hip_ast_ed/example_design/altpcied_qii.tcl
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/lbl1415812006393/nik1410905278518 
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697731237
