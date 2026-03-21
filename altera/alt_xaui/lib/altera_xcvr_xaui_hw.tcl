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


#-----------------------------------------------------------------------------
#
# Description: altera_xcvr_xaui_hw.tcl
#
# Authors:     dunnikri    19-Aug-2010
# Modified:    ishimony    13-Dec-2010 dxaui added
# Modified:    hhleong     11-May-2012 av xaui added
# Modified:    smlam       18-Nov-2013 a10 xaui added
#
#              Copyright (c) Altera Corporation 1997 - 2012
#              All rights reserved.
#
# 
#-----------------------------------------------------------------------------
# | request TCL package from ACDS 11.1
# | 
package require -exact qsys 13.0
# | 
# +-----------------------------------
#
 set_module_property ALLOW_GREYBOX_GENERATION true

# module alt_xaui_phy_top
set_module_property NAME altera_xcvr_xaui
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property HIDE_FROM_QSYS true
set_module_property GROUP "Interface Protocols/Ethernet/10G to 1G Multi-rate Ethernet"
set_module_property DISPLAY_NAME "XAUI PHY Intel FPGA IP"
set_module_property EDITABLE true
set_module_property ELABORATION_CALLBACK elaboration_callback
set_module_property VALIDATION_CALLBACK validation_callback
set_module_property ANALYZE_HDL false
set_module_property AUTHOR Intel
set_module_property DESCRIPTION "XGMII to XAUI transceiver"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
add_documentation_link "User Guide (Arria 10)" "http://www.altera.com/literature/hb/arria-10/ug_arria10_xcvr_phy.pdf"  
add_documentation_link "User Guide (other families)" "http://www.altera.com/literature/ug/xcvr_user_guide.pdf"  
add_documentation_link "Release Notes" "http://www.altera.com/literature/rn/ip/xaui_phy_revision.html"

set_module_property supported_device_families {{stratix iv} {stratix v} {cyclone iv} {arria v} {cyclone v} {arria ii} {arria ii gz} {arria v gz} {arria 10}}

lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/alt_xcvr_tcl_packages
lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/altera_xcvr_reset_control
lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/altera_xcvr_pll/altera_xcvr_cdr_pll_vi

package require alt_xcvr::utils::rbc
package require altera_xcvr_reset_control::fileset

source ipcc_tcl_helper.tcl
source ../../altera_xcvr_generic/alt_xcvr_common.tcl
source ../../altera_xcvr_generic/ctrl/alt_xcvr_csr_fileset.tcl	;# function to declare csr soft logic files
source ../../altera_xcvr_generic/sv/sv_xcvr_native_fileset.tcl	;# function to decl S5 native channel files
source ../../altera_xcvr_generic/av/av_xcvr_native_fileset.tcl	;# function to decl A5 native channel files
source ../../alt_xcvr_reconfig/alt_xcvr_reconfig/alt_xreconf_common.tcl	;# function to declare reconf block files
source ./alt_xaui_common.tcl

# +-----------------------------------
# | files
# | 

custom_decl_fileset_groups .. ../../alt_xcvr_reconfig

add_fileset          synth2      QUARTUS_SYNTH fileset_quartus_synth
add_fileset          sim_verilog SIM_VERILOG   fileset_sim_verilog
add_fileset          sim_vhdl    SIM_VHDL      fileset_sim_vhdl

set_fileset_property synth2      TOP_LEVEL altera_xcvr_xaui
set_fileset_property sim_verilog TOP_LEVEL altera_xcvr_xaui
set_fileset_property sim_vhdl    TOP_LEVEL altera_xcvr_xaui

# synthesis fileset callback
proc fileset_quartus_synth {name} {
  custom_add_fileset_for_tool {PLAIN QENCRYPT QIP}
}

# Verilog simulation fileset callback
proc fileset_sim_verilog {name} {
  custom_add_fileset_for_tool [concat PLAIN SIM_SCRIPT [common_fileset_tags_all_simulators]]
}

# Verilog simulation fileset callback
proc fileset_sim_vhdl {name} {
  custom_add_fileset_for_tool [concat PLAIN SIM_SCRIPT [common_fileset_tags_all_simulators]]
}

# | 
# +-----------------------------------

# | 
# +-----------------------------------
# | tabs
# |
add_display_item "" "General Options"  GROUP tab
  add_param_str device_family "Stratix IV" {"Stratix IV" "HardCopy IV" "Stratix V" "Arria V" "Cyclone V" "Cyclone IV GX" "Arria II GX" "Arria II GZ" "Arria V GZ" "Arria 10"} "General Options"
  set_parameter_property device_family SYSTEM_INFO {DEVICE_FAMILY}
  set_parameter_property device_family DESCRIPTION \
    "Possible values are Stratix IV or HardCopy IV or Stratix V or Arria V or Cyclone V or Cyclone IV GX or Arria II GX or Arria II GZ or Arria V GZ or Arria 10"
  set_parameter_property device_family DISPLAY_NAME \
    "Device family"
add_display_item "" "Analog Options"   GROUP tab
add_display_item "" "Advanced Options" GROUP tab

add_display_item "Analog Options" sv_message_text TEXT "These options are only available for families Stratix IV, Arria II and Cyclone IV."

# |
# +-----------------------------------
  # | parameters
  # | 
  common_add_parameters_for_native_phy 
  add_extra_parameters_for_top_phy
# +-----------------------------------
add_parameter part_trait_bd string ""
set_parameter_property part_trait_bd SYSTEM_INFO_TYPE PART_TRAIT
set_parameter_property part_trait_bd SYSTEM_INFO_ARG BASE_DEVICE
set_parameter_property part_trait_bd VISIBLE false

 
#
# Elaborate
#----------
proc elaboration_callback { } {
  set use_cs_ports   [get_parameter_value use_control_and_status_ports]
  set external_pcr   [get_parameter_value external_pma_ctrl_reconf]
  set sv_support     [get_parameter_value device_family]
  set sv_support     [get_parameter_value device_family]
  set exp_cdr_clk    [get_parameter_value en_synce_support]
  set pll_ext_enable [get_parameter_value pll_external_enable]
  set enable_rx_coreclkin [get_parameter_value enable_rx_coreclkin]

  if {[get_parameter_value device_family] == "Stratix V" } {
    set sv_support 1
  } elseif {[get_parameter_value device_family] == "Arria V GZ" } {
    set sv_support 1 
  } else {
    set sv_support 0
   }
 
  set av_support     [get_parameter_value device_family]
  if {[get_parameter_value device_family] == "Arria V" } {
    set av_support 1
  } else {
    set av_support 0
   } 
   
  set cv_support     [get_parameter_value device_family]
  if {[get_parameter_value device_family] == "Cyclone V" } {
    set cv_support 1
  } else {
    set cv_support 0
   } 

  set a10_support     [get_parameter_value device_family]
  if {[get_parameter_value device_family] == "Arria 10" } {
    set a10_support 1
  } else {
    set a10_support 0
  } 

  # declare ports and mappings for elaboration callback
  common_clock_interfaces

  #XAUI_RATE:0 for channel_based; 1 for shared
  common_xaui_interface_ports 1 

  # add memory-mapped slave interface, with 9-bit wide word address, readLatency of 0 (uses waitrequest)
  common_mgmt_interface 9 0

  if {$use_cs_ports} {
    common_xaui_controlstatus_ports
  } else { 
    terminate_xaui_controlstatus_ports
  }

  if {$external_pcr } {
    common_xaui_extpma_ports
  } else { 
    terminate_xaui_extpma_ports
  }

  
  if {$exp_cdr_clk} {
    cdr_ref_clk_port
  } else { 
    terminate_cdr_ref_clk_port
  }


  if {$external_pcr & (!$sv_support | !$av_support | !$cv_support )} {
    add_reconfig_ports
  } else { 
    terminate_reconfig_ports
  }
  
  if {[get_parameter_value device_family] == "Arria V" || [get_parameter_value device_family] == "Cyclone V"} {
    common_display_reconfig_interface_message [get_parameter_value device_family] 4 1
  } else {
    common_display_reconfig_interface_message [get_parameter_value device_family] 4 4
  }

  if {$sv_support | $av_support | $cv_support} {
      if {$pll_ext_enable && $av_support} {
        add_reconfig_ports
        add_pll_ports
        add_ext_pll_clk_port
        terminate_rx_coreclkin_port
      } elseif {$sv_support && $enable_rx_coreclkin} {
        add_reconfig_ports
        add_rx_coreclkin_port
        terminate_pll_ports
        terminate_ext_pll_clk_port
      } else {
        add_reconfig_ports
        terminate_pll_ports
        terminate_ext_pll_clk_port
        terminate_rx_coreclkin_port
      }
    terminate_dyn_reconfig_ports
    terminate_tx_bonding_clk_port
    terminate_xgmii_rx_inclk_port
  } elseif {$a10_support} {

    set xcvr_rcfg_jtag_enable [get_parameter_value xcvr_rcfg_jtag_enable]
    set xcvr_set_capability_reg_enable [get_parameter_value xcvr_set_capability_reg_enable]
    set xcvr_set_user_identifier [get_parameter_value xcvr_set_user_identifier]
    set xcvr_set_csr_soft_logic_enable [get_parameter_value xcvr_set_csr_soft_logic_enable]
    set xcvr_set_prbs_soft_logic_enable [get_parameter_value xcvr_set_prbs_soft_logic_enable]

    add_pll_ports
    add_tx_bonding_clk_port
    terminate_reconfig_ports
    terminate_rx_coreclkin_port
    terminate_ext_pll_clk_port

    if {[get_parameter_value dyn_reconf]} {
      add_dyn_reconfig_ports
    } else {
      terminate_dyn_reconfig_ports
    }

    if {[get_parameter_value en_dual_fifo]} {
      add_xgmii_rx_inclk_port
    } else {
      terminate_xgmii_rx_inclk_port
    }

    

    add_hdl_instance a10_xcvr_custom_native altera_xcvr_native_a10 
    set_instance_parameter_value a10_xcvr_custom_native base_device [get_parameter_value part_trait_bd]
    set_instance_parameter_value a10_xcvr_custom_native device_family {Arria 10}
    set_instance_parameter_value a10_xcvr_custom_native protocol_mode {basic_std} 
    set_instance_parameter_value a10_xcvr_custom_native duplex_mode {duplex}
    set_instance_parameter_value a10_xcvr_custom_native channels {4}
    set_instance_parameter_value a10_xcvr_custom_native set_data_rate {3125}
    set_instance_parameter_value a10_xcvr_custom_native rcfg_iface_enable {0}
    set_instance_parameter_value a10_xcvr_custom_native enable_simple_interface {1}
    set_instance_parameter_value a10_xcvr_custom_native enable_split_interface {0}
    set_instance_parameter_value a10_xcvr_custom_native bonded_mode {pma_pcs}
    set_instance_parameter_value a10_xcvr_custom_native tx_pma_clk_div {1}
    set_instance_parameter_value a10_xcvr_custom_native plls {1}
    set_instance_parameter_value a10_xcvr_custom_native pll_select {0}
    set_instance_parameter_value a10_xcvr_custom_native cdr_refclk_cnt {1}
    set_instance_parameter_value a10_xcvr_custom_native cdr_refclk_select {0}
    set_instance_parameter_value a10_xcvr_custom_native set_cdr_refclk_freq {156.25000}             
    set_instance_parameter_value a10_xcvr_custom_native rx_ppm_detect_threshold {300}          
    set_instance_parameter_value a10_xcvr_custom_native enable_port_rx_is_lockedtodata {1}    
    set_instance_parameter_value a10_xcvr_custom_native enable_port_rx_is_lockedtoref {1}     
    set_instance_parameter_value a10_xcvr_custom_native enable_ports_rx_manual_cdr_mode {1}
    set_instance_parameter_value a10_xcvr_custom_native enable_port_rx_seriallpbken {1}       
    set_instance_parameter_value a10_xcvr_custom_native std_pcs_pma_width {20}
    set_instance_parameter_value a10_xcvr_custom_native std_tx_pcfifo_mode {low_latency}               
    set_instance_parameter_value a10_xcvr_custom_native std_rx_pcfifo_mode {low_latency}                
    set_instance_parameter_value a10_xcvr_custom_native std_tx_byte_ser_mode {Disabled}
    set_instance_parameter_value a10_xcvr_custom_native std_rx_byte_deser_mode {Disabled}
    set_instance_parameter_value a10_xcvr_custom_native std_tx_8b10b_enable {0}              
    set_instance_parameter_value a10_xcvr_custom_native std_tx_8b10b_disp_ctrl_enable {0} 
    set_instance_parameter_value a10_xcvr_custom_native std_rx_8b10b_enable {0}              
    set_instance_parameter_value a10_xcvr_custom_native std_rx_rmfifo_mode {disabled} 
    set_instance_parameter_value a10_xcvr_custom_native std_tx_bitslip_enable {0}
    set_instance_parameter_value a10_xcvr_custom_native std_rx_word_aligner_mode {synchronous state machine}
    set_instance_parameter_value a10_xcvr_custom_native std_rx_word_aligner_pattern_len {20}
    set_instance_parameter_value a10_xcvr_custom_native std_rx_word_aligner_pattern {658812} 
    set_instance_parameter_value a10_xcvr_custom_native std_rx_word_aligner_rknumber {1}
    set_instance_parameter_value a10_xcvr_custom_native std_rx_word_aligner_renumber {1}  
    set_instance_parameter_value a10_xcvr_custom_native std_rx_word_aligner_rgnumber {1}      
    set_instance_parameter_value a10_xcvr_custom_native enable_port_rx_std_wa_patternalign {0}
    set_instance_parameter_value a10_xcvr_custom_native enable_port_rx_std_wa_a1a2size {0}   
    set_instance_parameter_value a10_xcvr_custom_native enable_port_rx_std_bitslip {0}        
    set_instance_parameter_value a10_xcvr_custom_native generate_docs {0}
    set_instance_parameter_value a10_xcvr_custom_native rcfg_enable {1}
    set_instance_parameter_value a10_xcvr_custom_native rcfg_shared {1}
    set_instance_parameter_value a10_xcvr_custom_native rcfg_jtag_enable $xcvr_rcfg_jtag_enable
    set_instance_parameter_value a10_xcvr_custom_native set_capability_reg_enable $xcvr_set_capability_reg_enable
    set_instance_parameter_value a10_xcvr_custom_native set_user_identifier $xcvr_set_user_identifier
    set_instance_parameter_value a10_xcvr_custom_native set_csr_soft_logic_enable $xcvr_set_csr_soft_logic_enable
    set_instance_parameter_value a10_xcvr_custom_native set_prbs_soft_logic_enable $xcvr_set_prbs_soft_logic_enable

  } else {
    terminate_ext_pll_clk_port
    terminate_pll_ports
    terminate_dyn_reconfig_ports
    terminate_tx_bonding_clk_port
    terminate_xgmii_rx_inclk_port
    terminate_rx_coreclkin_port
  }

}

#------------------------------------------------------------------------------
#
# Validation
#-------------
# validate - displaying messages and checking parameters
proc validation_callback {} {
     common_parameter_validation
}

      

                 

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/nik1398707230472/nik1398706797771
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698007333
