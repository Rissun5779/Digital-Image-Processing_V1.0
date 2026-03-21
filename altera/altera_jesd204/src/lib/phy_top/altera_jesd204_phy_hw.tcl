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


#########################################
### request TCL package from ACDS
#########################################
package require -exact qsys 16.0
package require altera_tcl_testlib 1.0
package require -exact altera_terp 1.0

#########################################
### Source required procs
#########################################
source $env(QUARTUS_ROOTDIR)/../ip/altera/altera_jesd204/src/top/altera_jesd204_common_procs.tcl

##########################
# module altera_jesd204b
##########################
set_module_property NAME altera_jesd204_phy
set_module_property AUTHOR "Altera Corporation"
set_module_property DESCRIPTION "JESD204B MegaCore Function"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/JESD"
set_module_property DISPLAY_NAME "JESD204B PHY wrapper"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_SOPC true


########################
# Declare the callbacks
########################
set_module_property VALIDATION_CALLBACK my_validation_callback   
set_module_property COMPOSITION_CALLBACK my_compose_callback   

#------------------------------------------------------------------------
# 1. GUI parameters
#------------------------------------------------------------------------
source ./../../top/altera_jesd204_params.tcl
::altera_jesd204::gui_params::params_phy_hw

#############################################################
#                  Validation Callback
#############################################################
proc my_validation_callback {} {
#Do NOT change HDL_PARAMETER property. Refer to case:285229
#   if {[param_matches DATA_PATH "TX" ]} {
#   set_parameter_property "ALIGNMENT_PATTERN" HDL_PARAMETER false
#   } elseif  {[param_matches DATA_PATH "RX" ]} {
#   set_parameter_property "ALIGNMENT_PATTERN" HDL_PARAMETER true  
#   } 

}
#############################################################
#                  Compose Callback
#############################################################

proc my_compose_callback {} {
   my_jesd_add_instance
   my_jesd_add_connection
}

# Add instance and set its parameters value
proc my_jesd_add_instance {} {
   if {[device_is_vseries]} {
      if {[param_matches DATA_PATH "TX" ]} {
         tx_add_instances
	 set_parameter_property "d_refclk_freq" ALLOWED_RANGES [get_instance_parameter_property "inst_xcvr" gui_pll_reconfig_pll0_refclk_freq ALLOWED_RANGES]
      } elseif {[param_matches DATA_PATH "RX" ] } {
         rx_add_instances
	 set_parameter_property "d_refclk_freq" ALLOWED_RANGES [get_instance_parameter_property "inst_xcvr" set_cdr_refclk_freq ALLOWED_RANGES]
      } elseif { [param_matches DATA_PATH "RX_TX"] } {
         duplex_add_instances
	 set_parameter_property "d_refclk_freq" ALLOWED_RANGES [get_instance_parameter_property "inst_xcvr" gui_pll_reconfig_pll0_refclk_freq ALLOWED_RANGES]
      } 
   } elseif {[device_is_xseries] } {
      if {[param_matches DATA_PATH "TX" ]} {
         tx_add_instances_xs 
      } elseif {[param_matches DATA_PATH "RX" ] } {
         rx_add_instances_xs
	 set_parameter_property "d_refclk_freq" ALLOWED_RANGES [get_instance_parameter_property "inst_xcvr" set_cdr_refclk_freq ALLOWED_RANGES]
      } elseif { [param_matches DATA_PATH "RX_TX"] } {
         duplex_add_instances_xs
	 set_parameter_property "d_refclk_freq" ALLOWED_RANGES [get_instance_parameter_property "inst_xcvr" set_cdr_refclk_freq ALLOWED_RANGES]
      } 
   }
}

# Set instances connection
proc my_jesd_add_connection {} {
   # Add prefix tx and rx to ensure the uniqueness interfaces naming for TX and RX
   set tx_ [expr {[param_matches DATA_PATH "RX_TX"] ? "tx_": ""}]
   set rx_ [expr {[param_matches DATA_PATH "RX_TX"] ? "rx_": ""}]
   if {[device_is_vseries]} {
      set_phy_connections $tx_ $rx_
   } else {
      set_phy_connections_xs $tx_ $rx_
   }
}

# Proc to add instances for TX and set the parameters for series V device family
proc tx_add_instances {} {
   add_instance              inst_tx_mlpcs                  altera_jesd204_tx_mlpcs     18.1
   propagate_params          inst_tx_mlpcs
   add_instance              inst_phy_adapter               altera_jesd204_phy_adapter  18.1
   propagate_params          inst_phy_adapter

   if {[param_matches PCS_CONFIG "JESD_PCS_CFG1" ]} {
      # Standard pcs (PCS_CONFIG=JESD_PCS_CFG1)
      add_instance                  inst_xcvr  [get_xcvr_component_name [get_parameter_value "DEVICE_FAMILY"]]  18.1
      set_instance_parameter_value  inst_xcvr  tx_enable 1
      set_instance_parameter_value  inst_xcvr  rx_enable 0
      set_instance_parameter_value  inst_xcvr  enable_std 1
      set_instance_parameter_value  inst_xcvr  channels [get_parameter_value "L"]
      set_instance_parameter_value  inst_xcvr  bonded_mode [expr {[derive_bonded_mode] == "x1" ? "non_bonded" : [derive_bonded_mode]}] 
      set_instance_parameter_value  inst_xcvr  set_data_rate [get_parameter_value "lane_rate"]
      set_instance_parameter_value  inst_xcvr  pll_reconfig_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  std_protocol_hint "basic"
      set_instance_parameter_value  inst_xcvr  std_pcs_pma_width 20
      set_instance_parameter_value  inst_xcvr  std_tx_pcfifo_mode "low_latency"
      set_instance_parameter_value  inst_xcvr  enable_port_tx_std_pcfifo_full 1
      set_instance_parameter_value  inst_xcvr  enable_port_tx_std_pcfifo_empty 1
      set_instance_parameter_value  inst_xcvr  std_tx_byte_ser_enable 1
      set_instance_parameter_value  inst_xcvr  std_tx_8b10b_enable 1
      set_instance_parameter_value  inst_xcvr  std_tx_bitrev_enable [get_parameter_value "BIT_REVERSAL"]
      set_instance_parameter_value  inst_xcvr  std_tx_byterev_enable [get_parameter_value "BIT_REVERSAL"]
      set_instance_parameter_value  inst_xcvr  std_tx_polinv_enable 1	
      set_instance_parameter_value  inst_xcvr  enable_port_tx_std_polinv 1
      set_instance_parameter_value  inst_xcvr  enable_port_tx_std_elecidle 1
      set_instance_parameter_value  inst_xcvr  gui_pll_reconfig_pll0_refclk_freq "[get_parameter_value "d_refclk_freq"] MHz"
      set_instance_parameter_value  inst_xcvr  gui_pll_reconfig_pll0_pll_type [get_parameter_value "pll_type"]
      if {[param_matches DEVICE_FAMILY "Arria V" ] || [param_matches DEVICE_FAMILY "Cyclone V"] } {
      set_instance_parameter_value  inst_xcvr  gui_pll_reconfig_pll0_clk_network [derive_bonded_mode]
      }
      set_instance_parameter_value  inst_xcvr  enable_simple_interface 1

   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG2" ]} {
      # 10g pcs (PCS_CONFIG=JESD_PCS_CFG2)
      add_instance                  inst_xcvr  [get_xcvr_component_name [get_parameter_value "DEVICE_FAMILY"]]  18.1
      set_instance_parameter_value  inst_xcvr  tx_enable 1
      set_instance_parameter_value  inst_xcvr  rx_enable 0
      set_instance_parameter_value  inst_xcvr  enable_std 0
      set_instance_parameter_value  inst_xcvr  enable_teng 1
      set_instance_parameter_value  inst_xcvr  channels [get_parameter_value "L"]
      set_instance_parameter_value  inst_xcvr  bonded_mode [expr {[derive_bonded_mode] == "x1" ? "non_bonded" : [derive_bonded_mode]}]       
      set_instance_parameter_value  inst_xcvr  set_data_rate [get_parameter_value "lane_rate"]
      set_instance_parameter_value  inst_xcvr  pll_reconfig_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  teng_protocol_hint "basic"
      set_instance_parameter_value  inst_xcvr  teng_pcs_pma_width 40
      set_instance_parameter_value  inst_xcvr  teng_pld_pcs_width 40
      set_instance_parameter_value  inst_xcvr  teng_txfifo_mode "phase_comp"	
      set_instance_parameter_value  inst_xcvr  enable_port_tx_10g_fifo_full 1
      set_instance_parameter_value  inst_xcvr  enable_port_tx_10g_fifo_empty 1
      set_instance_parameter_value  inst_xcvr  gui_pll_reconfig_pll0_refclk_freq "[get_parameter_value "d_refclk_freq"] MHz"
      set_instance_parameter_value  inst_xcvr  gui_pll_reconfig_pll0_pll_type [get_parameter_value "pll_type"]
      set_instance_parameter_value  inst_xcvr  enable_simple_interface 1
   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG3" ]} {
   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG4" ]} {
      add_instance                  inst_xcvr  [get_xcvr_component_name [get_parameter_value "DEVICE_FAMILY"]]  18.1
      set_instance_parameter_value  inst_xcvr  tx_enable 1
      set_instance_parameter_value  inst_xcvr  rx_enable 0
      set_instance_parameter_value  inst_xcvr  enable_std 0
      set_instance_parameter_value  inst_xcvr  channels [get_parameter_value "L"]
      set_instance_parameter_value  inst_xcvr  bonded_mode [expr {[derive_bonded_mode] == "x1" ? "non_bonded" : [derive_bonded_mode]}] 
      set_instance_parameter_value  inst_xcvr  set_data_rate [get_parameter_value "lane_rate"]
      set_instance_parameter_value  inst_xcvr  pll_reconfig_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  pma_direct_width 80
      set_instance_parameter_value  inst_xcvr  gui_pll_reconfig_pll0_refclk_freq "[get_parameter_value "d_refclk_freq"] MHz"
      set_instance_parameter_value  inst_xcvr  gui_pll_reconfig_pll0_pll_type [get_parameter_value "pll_type"]
      set_instance_parameter_value  inst_xcvr  gui_pll_reconfig_pll0_clk_network [derive_bonded_mode]
      set_instance_parameter_value  inst_xcvr  enable_simple_interface 1
   } 
}

# Proc to add instances for RX and set the parameters for series V device family
proc rx_add_instances {} {
   add_instance              inst_rx_mlpcs               altera_jesd204_rx_mlpcs 18.1
   propagate_params          inst_rx_mlpcs
   add_instance              inst_phy_adapter            altera_jesd204_phy_adapter 18.1
   propagate_params          inst_phy_adapter

   if {[param_matches PCS_CONFIG "JESD_PCS_CFG1" ]} {
      # Standard pcs (PCS_CONFIG=JESD_PCS_CFG1)
      add_instance                  inst_xcvr  [get_xcvr_component_name [get_parameter_value "DEVICE_FAMILY"]]  18.1
      set_instance_parameter_value  inst_xcvr  tx_enable 0
      set_instance_parameter_value  inst_xcvr  rx_enable 1
      set_instance_parameter_value  inst_xcvr  enable_std 1
      set_instance_parameter_value  inst_xcvr  channels [get_parameter_value "L"]
      set_instance_parameter_value  inst_xcvr  set_data_rate [get_parameter_value "lane_rate"]
      set_instance_parameter_value  inst_xcvr  cdr_reconfig_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  set_cdr_refclk_freq  "[get_parameter_value "d_refclk_freq"] MHz"
      set_instance_parameter_value  inst_xcvr  enable_port_rx_pma_clkout 0
      set_instance_parameter_value  inst_xcvr  enable_port_rx_is_lockedtoref 0 
      set_instance_parameter_value  inst_xcvr  enable_ports_rx_manual_cdr_mode 0
      set_instance_parameter_value  inst_xcvr  std_protocol_hint "basic"
      set_instance_parameter_value  inst_xcvr  std_pcs_pma_width 20
      set_instance_parameter_value  inst_xcvr  std_rx_pcfifo_mode "low_latency"
      set_instance_parameter_value  inst_xcvr  enable_port_rx_std_pcfifo_full 1
      set_instance_parameter_value  inst_xcvr  enable_port_rx_std_pcfifo_empty 1
      set_instance_parameter_value  inst_xcvr  std_rx_byte_deser_enable 1
      set_instance_parameter_value  inst_xcvr  std_rx_8b10b_enable 1
      set_instance_parameter_value  inst_xcvr  std_rx_word_aligner_mode "manual"
      set_instance_parameter_value  inst_xcvr  std_rx_word_aligner_pattern [format %x [get_parameter_value "ALIGNMENT_PATTERN"]]
      set_instance_parameter_value  inst_xcvr  std_rx_word_aligner_pattern_len 20
      set_instance_parameter_value  inst_xcvr  enable_port_rx_std_wa_patternalign 1
      set_instance_parameter_value  inst_xcvr  std_rx_8b10b_enable 1
      set_instance_parameter_value  inst_xcvr  std_rx_bitrev_enable 1 
      set_instance_parameter_value  inst_xcvr  std_rx_byterev_enable 1 
      set_instance_parameter_value  inst_xcvr  std_rx_polinv_enable 1	
      set_instance_parameter_value  inst_xcvr  enable_port_rx_std_bitrev_ena 1
      set_instance_parameter_value  inst_xcvr  enable_port_rx_std_byterev_ena 1
      set_instance_parameter_value  inst_xcvr  enable_port_rx_std_polinv 1	   
      set_instance_parameter_value  inst_xcvr  enable_simple_interface 1

   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG2" ]} {
      add_instance                  inst_xcvr  [get_xcvr_component_name [get_parameter_value "DEVICE_FAMILY"]]  18.1
      set_instance_parameter_value  inst_xcvr  tx_enable 0
      set_instance_parameter_value  inst_xcvr  rx_enable 1
      set_instance_parameter_value  inst_xcvr  enable_std 0
      set_instance_parameter_value  inst_xcvr  enable_teng 1
      set_instance_parameter_value  inst_xcvr  channels [get_parameter_value "L"]
      set_instance_parameter_value  inst_xcvr  set_data_rate [get_parameter_value "lane_rate"]
      set_instance_parameter_value  inst_xcvr  cdr_reconfig_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  set_cdr_refclk_freq "[get_parameter_value "d_refclk_freq"] MHz"
      set_instance_parameter_value  inst_xcvr  enable_port_rx_pma_clkout 0
      set_instance_parameter_value  inst_xcvr  enable_port_rx_is_lockedtoref 0 
      set_instance_parameter_value  inst_xcvr  enable_ports_rx_manual_cdr_mode 0
      set_instance_parameter_value  inst_xcvr  teng_protocol_hint "basic"
      set_instance_parameter_value  inst_xcvr  teng_pcs_pma_width 40
      set_instance_parameter_value  inst_xcvr  teng_pld_pcs_width 40
      set_instance_parameter_value  inst_xcvr  teng_txfifo_mode "phase_comp"	
      set_instance_parameter_value  inst_xcvr  enable_port_rx_10g_fifo_full 1
      set_instance_parameter_value  inst_xcvr  enable_port_rx_10g_fifo_empty 1
      set_instance_parameter_value  inst_xcvr  enable_simple_interface 1

   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG3" ]} {
   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG4" ]} {
      add_instance                  inst_xcvr  [get_xcvr_component_name [get_parameter_value "DEVICE_FAMILY"]]  18.1
      set_instance_parameter_value  inst_xcvr  tx_enable 0
      set_instance_parameter_value  inst_xcvr  rx_enable 1
      set_instance_parameter_value  inst_xcvr  enable_std 0
      set_instance_parameter_value  inst_xcvr  channels [get_parameter_value "L"]
      set_instance_parameter_value  inst_xcvr  set_data_rate [get_parameter_value "lane_rate"]
      set_instance_parameter_value  inst_xcvr  cdr_reconfig_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  set_cdr_refclk_freq "[get_parameter_value "d_refclk_freq"] MHz"
      set_instance_parameter_value  inst_xcvr  pma_direct_width 80
      set_instance_parameter_value  inst_xcvr  enable_port_rx_is_lockedtoref 0
      set_instance_parameter_value  inst_xcvr  enable_ports_rx_manual_cdr_mode 0
      set_instance_parameter_value  inst_xcvr  enable_simple_interface 1
   } 
}

#Proc to add instances for duplex mode for series V device family
proc duplex_add_instances {} {
   
   add_instance              inst_tx_mlpcs                  altera_jesd204_tx_mlpcs 18.1
   propagate_params          inst_tx_mlpcs
   add_instance              inst_rx_mlpcs                  altera_jesd204_rx_mlpcs 18.1
   propagate_params          inst_rx_mlpcs
   add_instance              inst_phy_adapter               altera_jesd204_phy_adapter 18.1
   propagate_params          inst_phy_adapter

   if {[param_matches PCS_CONFIG "JESD_PCS_CFG1" ]} {
      # Standard pcs (PCS_CONFIG=JESD_PCS_CFG1)
      add_instance                  inst_xcvr  [get_xcvr_component_name [get_parameter_value "DEVICE_FAMILY"]]  18.1
      set_instance_parameter_value  inst_xcvr  tx_enable 1
      set_instance_parameter_value  inst_xcvr  rx_enable 1
      set_instance_parameter_value  inst_xcvr  enable_std 1
      set_instance_parameter_value  inst_xcvr  channels [get_parameter_value "L"]
      set_instance_parameter_value  inst_xcvr  bonded_mode [expr {[derive_bonded_mode] == "x1" ? "non_bonded" : [derive_bonded_mode]}]
      set_instance_parameter_value  inst_xcvr  set_data_rate [get_parameter_value "lane_rate"]
      set_instance_parameter_value  inst_xcvr  pll_reconfig_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  cdr_reconfig_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  set_cdr_refclk_freq  "[get_parameter_value "d_refclk_freq"] MHz"
      set_instance_parameter_value  inst_xcvr  enable_port_rx_pma_clkout 0
      set_instance_parameter_value  inst_xcvr  enable_port_rx_is_lockedtoref 0 
      set_instance_parameter_value  inst_xcvr  enable_ports_rx_manual_cdr_mode 0
      set_instance_parameter_value  inst_xcvr  std_protocol_hint "basic"
      set_instance_parameter_value  inst_xcvr  std_pcs_pma_width 20
      set_instance_parameter_value  inst_xcvr  std_rx_pcfifo_mode "low_latency"
      set_instance_parameter_value  inst_xcvr  enable_port_rx_std_pcfifo_full 1
      set_instance_parameter_value  inst_xcvr  enable_port_rx_std_pcfifo_empty 1
      set_instance_parameter_value  inst_xcvr  std_rx_byte_deser_enable 1
      set_instance_parameter_value  inst_xcvr  std_rx_8b10b_enable 1
      set_instance_parameter_value  inst_xcvr  std_rx_word_aligner_mode "manual"
      set_instance_parameter_value  inst_xcvr  std_rx_word_aligner_pattern [format %x [get_parameter_value "ALIGNMENT_PATTERN"]]
      set_instance_parameter_value  inst_xcvr  std_rx_word_aligner_pattern_len 20
      set_instance_parameter_value  inst_xcvr  enable_port_rx_std_wa_patternalign 1
      set_instance_parameter_value  inst_xcvr  std_rx_8b10b_enable 1
      set_instance_parameter_value  inst_xcvr  std_rx_bitrev_enable 1 
      set_instance_parameter_value  inst_xcvr  std_rx_byterev_enable 1 
      set_instance_parameter_value  inst_xcvr  std_rx_polinv_enable 1	
      set_instance_parameter_value  inst_xcvr  enable_port_rx_std_bitrev_ena 1
      set_instance_parameter_value  inst_xcvr  enable_port_rx_std_byterev_ena 1
      set_instance_parameter_value  inst_xcvr  enable_port_rx_std_polinv 1
      set_instance_parameter_value  inst_xcvr  enable_port_rx_seriallpbken 1  
      set_instance_parameter_value  inst_xcvr  enable_simple_interface 1
      set_instance_parameter_value  inst_xcvr  enable_port_tx_std_pcfifo_full 1
      set_instance_parameter_value  inst_xcvr  enable_port_tx_std_pcfifo_empty 1
      set_instance_parameter_value  inst_xcvr  std_tx_byte_ser_enable 1
      set_instance_parameter_value  inst_xcvr  std_tx_8b10b_enable 1
      set_instance_parameter_value  inst_xcvr  std_tx_bitrev_enable [get_parameter_value "BIT_REVERSAL"]
      set_instance_parameter_value  inst_xcvr  std_tx_byterev_enable [get_parameter_value "BIT_REVERSAL"]
      set_instance_parameter_value  inst_xcvr  std_tx_polinv_enable 1	
      set_instance_parameter_value  inst_xcvr  enable_port_tx_std_polinv 1
      set_instance_parameter_value  inst_xcvr  enable_port_tx_std_elecidle 1
      set_instance_parameter_value  inst_xcvr  gui_pll_reconfig_pll0_refclk_freq "[get_parameter_value "d_refclk_freq"] MHz"
      set_instance_parameter_value  inst_xcvr  gui_pll_reconfig_pll0_pll_type [get_parameter_value "pll_type"]
      if {[param_matches DEVICE_FAMILY "Arria V" ] || [param_matches DEVICE_FAMILY "Cyclone V"] } {
      set_instance_parameter_value  inst_xcvr  gui_pll_reconfig_pll0_clk_network [derive_bonded_mode]
      }


   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG2" ]} {
      add_instance                  inst_xcvr  [get_xcvr_component_name [get_parameter_value "DEVICE_FAMILY"]]  18.1
      set_instance_parameter_value  inst_xcvr  tx_enable 1
      set_instance_parameter_value  inst_xcvr  rx_enable 1
      set_instance_parameter_value  inst_xcvr  enable_std 0
      set_instance_parameter_value  inst_xcvr  enable_teng 1
      set_instance_parameter_value  inst_xcvr  channels [get_parameter_value "L"]
      set_instance_parameter_value  inst_xcvr  bonded_mode [expr {[derive_bonded_mode] == "x1" ? "non_bonded" : [derive_bonded_mode]}]
      set_instance_parameter_value  inst_xcvr  set_data_rate [get_parameter_value "lane_rate"]
      set_instance_parameter_value  inst_xcvr  pll_reconfig_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  cdr_reconfig_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  set_cdr_refclk_freq "[get_parameter_value "d_refclk_freq"] MHz"
      set_instance_parameter_value  inst_xcvr  enable_port_rx_pma_clkout 0
      set_instance_parameter_value  inst_xcvr  enable_port_rx_is_lockedtoref 0 
      set_instance_parameter_value  inst_xcvr  enable_ports_rx_manual_cdr_mode 0
      set_instance_parameter_value  inst_xcvr  teng_protocol_hint "basic"
      set_instance_parameter_value  inst_xcvr  teng_pcs_pma_width 40
      set_instance_parameter_value  inst_xcvr  teng_pld_pcs_width 40
      set_instance_parameter_value  inst_xcvr  teng_txfifo_mode "phase_comp"	
      set_instance_parameter_value  inst_xcvr  enable_port_rx_10g_fifo_full 1
      set_instance_parameter_value  inst_xcvr  enable_port_rx_10g_fifo_empty 1
      set_instance_parameter_value  inst_xcvr  enable_port_rx_seriallpbken 1  
      set_instance_parameter_value  inst_xcvr  enable_simple_interface 1
      set_instance_parameter_value  inst_xcvr  enable_port_tx_10g_fifo_full 1
      set_instance_parameter_value  inst_xcvr  enable_port_tx_10g_fifo_empty 1
      set_instance_parameter_value  inst_xcvr  gui_pll_reconfig_pll0_refclk_freq "[get_parameter_value "d_refclk_freq"] MHz"
      set_instance_parameter_value  inst_xcvr  gui_pll_reconfig_pll0_pll_type [get_parameter_value "pll_type"]

   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG3" ]} {
   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG4" ]} {
      add_instance                  inst_xcvr  [get_xcvr_component_name [get_parameter_value "DEVICE_FAMILY"]]  18.1
      set_instance_parameter_value  inst_xcvr  tx_enable 1
      set_instance_parameter_value  inst_xcvr  rx_enable 1
      set_instance_parameter_value  inst_xcvr  enable_std 0
      set_instance_parameter_value  inst_xcvr  channels [get_parameter_value "L"]
      set_instance_parameter_value  inst_xcvr  bonded_mode [expr {[derive_bonded_mode] == "x1" ? "non_bonded" : [derive_bonded_mode]}] 
      set_instance_parameter_value  inst_xcvr  set_data_rate [get_parameter_value "lane_rate"]
      set_instance_parameter_value  inst_xcvr  pma_direct_width 80
      set_instance_parameter_value  inst_xcvr  gui_pll_reconfig_pll0_refclk_freq "[get_parameter_value "d_refclk_freq"] MHz"
      set_instance_parameter_value  inst_xcvr  gui_pll_reconfig_pll0_pll_type [get_parameter_value "pll_type"]
      set_instance_parameter_value  inst_xcvr  gui_pll_reconfig_pll0_clk_network [derive_bonded_mode] 
      set_instance_parameter_value  inst_xcvr  pll_reconfig_enable [param_is_true "pll_reconfig_enable"]     
      set_instance_parameter_value  inst_xcvr  cdr_reconfig_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  set_cdr_refclk_freq "[get_parameter_value "d_refclk_freq"] MHz"
      set_instance_parameter_value  inst_xcvr  enable_port_rx_is_lockedtoref 0
      set_instance_parameter_value  inst_xcvr  enable_ports_rx_manual_cdr_mode 0
      set_instance_parameter_value  inst_xcvr  enable_port_rx_seriallpbken 1      
      set_instance_parameter_value  inst_xcvr  enable_simple_interface 1
   } 

}

# Proc to add instances for TX and set the parameters for series 10 device family
proc tx_add_instances_xs {} {
   set d_L [get_parameter_value "L"]

   add_instance              inst_tx_mlpcs                  altera_jesd204_tx_mlpcs 18.1
   propagate_params          inst_tx_mlpcs

   if {[param_is_true rcfg_shared] || $d_L==1} {
      add_instance              inst_phy_adapter               altera_jesd204_phy_adapter_xs 18.1
      propagate_params          inst_phy_adapter
   } else {
      add_instance              inst_phy_adapter               altera_jesd204_phy_adapter_xs_rcfg_shared_off 18.1
      propagate_params          inst_phy_adapter
   }

   if {[param_matches PCS_CONFIG "JESD_PCS_CFG1" ]} {
   # Standard pcs (PCS_CONFIG=JESD_PCS_CFG1)
      add_instance                  inst_xcvr  [get_xcvr_component_name [get_parameter_value "DEVICE_FAMILY"]]  18.1
      set_instance_parameter_value  inst_xcvr  duplex_mode "tx"
      set_instance_parameter_value  inst_xcvr  protocol_mode "basic_std"
      set_instance_parameter_value  inst_xcvr  channels [get_parameter_value "L"]
      set_instance_parameter_value  inst_xcvr  set_data_rate [get_parameter_value "lane_rate"]
      set_instance_parameter_value  inst_xcvr  enable_simple_interface 1
      set_instance_parameter_value  inst_xcvr  bonded_mode [derive_pll_mode_clk_xs [get_parameter_value "L"] bonded_mode]
      set_instance_parameter_value  inst_xcvr  enable_port_tx_pma_elecidle 1
      set_instance_parameter_value  inst_xcvr  std_pcs_pma_width 20
      if {[param_matches DEVICE_FAMILY "Arria 10"]} {
         set_instance_parameter_value  inst_xcvr  enable_port_tx_std_pcfifo_empty 1
         set_instance_parameter_value  inst_xcvr  enable_port_tx_std_pcfifo_full 1
      }
      set_instance_parameter_value  inst_xcvr  std_tx_byte_ser_mode "Serialize x2"
      set_instance_parameter_value  inst_xcvr  std_tx_8b10b_enable 1
      set_instance_parameter_value  inst_xcvr  std_tx_bitrev_enable [get_parameter_value "BIT_REVERSAL"]
      set_instance_parameter_value  inst_xcvr  std_tx_byterev_enable [get_parameter_value "BIT_REVERSAL"]
      set_instance_parameter_value  inst_xcvr  std_tx_polinv_enable 1	
      set_instance_parameter_value  inst_xcvr  enable_port_tx_polinv 1
      if {[param_matches DEVICE_FAMILY "Stratix 10"] } {
         set_instance_parameter_value  inst_xcvr  tx_fifo_mode "Phase compensation"
         set_instance_parameter_value  inst_xcvr  tx_clkout_sel "pcs_clkout"
         #set_instance_parameter_value  inst_xcvr  tx_coreclkin_clock_network "rowclk"
         set_instance_parameter_value  inst_xcvr  pcs_reset_sequencing_mode [derive_pcs_reset_sequencing_s10]
         set_instance_parameter_value  inst_xcvr  enable_port_tx_fifo_full 1
         set_instance_parameter_value  inst_xcvr  enable_port_tx_fifo_empty 1
         set_instance_parameter_value  inst_xcvr  tx_fifo_pfull 10
      }
      set_instance_parameter_value  inst_xcvr  rcfg_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_shared [expr {[param_is_true "pll_reconfig_enable"] && [param_is_true "rcfg_shared"] && [get_parameter_value "L"]>1}]
      set_instance_parameter_value  inst_xcvr  rcfg_jtag_enable [param_is_true "rcfg_jtag_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_sv_file_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_h_file_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_mif_file_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  set_capability_reg_enable [param_is_true "set_capability_reg_enable"]
      set_instance_parameter_value  inst_xcvr  set_user_identifier [get_parameter_value "set_user_identifier"]
      set_instance_parameter_value  inst_xcvr  set_csr_soft_logic_enable [param_is_true "set_csr_soft_logic_enable"]
      set_instance_parameter_value  inst_xcvr  set_prbs_soft_logic_enable [param_is_true "set_prbs_soft_logic_enable"]
#      set_instance_parameter_value  inst_xcvr  set_odi_soft_logic_enable [param_is_true "set_odi_soft_logic_enable"]
      set_instance_parameter_value  inst_xcvr  generate_docs 1

   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG2" ]} {
   # 10g pcs (PCS_CONFIG=JESD_PCS_CFG2)
      add_instance                  inst_xcvr  [get_xcvr_component_name [get_parameter_value "DEVICE_FAMILY"]]  18.1
      set_instance_parameter_value  inst_xcvr  duplex_mode "tx"
      set_instance_parameter_value  inst_xcvr  protocol_mode "basic_enh"
      set_instance_parameter_value  inst_xcvr  channels [get_parameter_value "L"]
      set_instance_parameter_value  inst_xcvr  set_data_rate [get_parameter_value "lane_rate"]
      set_instance_parameter_value  inst_xcvr  enable_simple_interface 1
      set_instance_parameter_value  inst_xcvr  bonded_mode [derive_pll_mode_clk_xs [get_parameter_value "L"] bonded_mode]
      set_instance_parameter_value  inst_xcvr  enable_port_tx_pma_elecidle 1
      set_instance_parameter_value  inst_xcvr  enh_pcs_pma_width 40
      set_instance_parameter_value  inst_xcvr  enh_pld_pcs_width 40
      if {[param_matches DEVICE_FAMILY "Arria 10"] } {
         set_instance_parameter_value  inst_xcvr  enh_txfifo_mode "Phase compensation"
         set_instance_parameter_value  inst_xcvr  enable_port_tx_enh_fifo_empty 1
         set_instance_parameter_value  inst_xcvr  enable_port_tx_enh_fifo_full 1
      } elseif {[param_matches DEVICE_FAMILY "Stratix 10"] } {
         set_instance_parameter_value  inst_xcvr  pcs_reset_sequencing_mode [derive_pcs_reset_sequencing_s10]
         set_instance_parameter_value  inst_xcvr  tx_fifo_mode "Phase compensation"
         set_instance_parameter_value  inst_xcvr  enable_port_tx_fifo_empty 1
         set_instance_parameter_value  inst_xcvr  enable_port_tx_fifo_full 1
      }
      set_instance_parameter_value  inst_xcvr  rcfg_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_shared [expr {[param_is_true "pll_reconfig_enable"] && [param_is_true "rcfg_shared"] && [get_parameter_value "L"]>1}]
      set_instance_parameter_value  inst_xcvr  rcfg_jtag_enable [param_is_true "rcfg_jtag_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_sv_file_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_h_file_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_mif_file_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  set_capability_reg_enable [param_is_true "set_capability_reg_enable"]
      set_instance_parameter_value  inst_xcvr  set_user_identifier [get_parameter_value "set_user_identifier"]
      set_instance_parameter_value  inst_xcvr  set_csr_soft_logic_enable [param_is_true "set_csr_soft_logic_enable"]
      set_instance_parameter_value  inst_xcvr  set_prbs_soft_logic_enable [param_is_true "set_prbs_soft_logic_enable"]
#      set_instance_parameter_value  inst_xcvr  set_odi_soft_logic_enable [param_is_true "set_odi_soft_logic_enable"]
      set_instance_parameter_value  inst_xcvr  generate_docs 1

   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG3" ]} {
   #{[param_matches PCS_CONFIG "JESD_PCS_CFG3" ]} 

   } else { 
   #{[param_matches PCS_CONFIG "JESD_PCS_CFG4" ]} 
   }
}

# Proc to add instances for RX and set the parameters for series 10 device family
proc rx_add_instances_xs {} {
   set d_L [get_parameter_value "L"]

   add_instance              inst_rx_mlpcs                altera_jesd204_rx_mlpcs 18.1
   propagate_params          inst_rx_mlpcs

   if {[param_is_true rcfg_shared] || $d_L==1} {
      add_instance              inst_phy_adapter             altera_jesd204_phy_adapter_xs 18.1
      propagate_params          inst_phy_adapter
   } else {
      add_instance              inst_phy_adapter             altera_jesd204_phy_adapter_xs_rcfg_shared_off 18.1
      propagate_params          inst_phy_adapter
   }

   if {[param_matches PCS_CONFIG "JESD_PCS_CFG1" ]} {
      # Standard pcs (PCS_CONFIG=JESD_PCS_CFG1)
      add_instance                  inst_xcvr  [get_xcvr_component_name [get_parameter_value "DEVICE_FAMILY"]]  18.1
      set_instance_parameter_value  inst_xcvr  duplex_mode "rx"
      set_instance_parameter_value  inst_xcvr  protocol_mode "basic_std"
      set_instance_parameter_value  inst_xcvr  channels [get_parameter_value "L"]
      set_instance_parameter_value  inst_xcvr  set_data_rate [get_parameter_value "lane_rate"]
      set_instance_parameter_value  inst_xcvr  enable_simple_interface 1
      set_instance_parameter_value  inst_xcvr  set_cdr_refclk_freq [get_parameter_value "d_refclk_freq"]
      set_instance_parameter_value  inst_xcvr  enable_port_rx_is_lockedtodata 1
      set_instance_parameter_value  inst_xcvr  enable_port_rx_is_lockedtoref 0 
      set_instance_parameter_value  inst_xcvr  enable_ports_rx_manual_cdr_mode 0
      set_instance_parameter_value  inst_xcvr  std_pcs_pma_width 20
      if {[param_matches DEVICE_FAMILY "Arria 10"]} {
         set_instance_parameter_value  inst_xcvr  enable_port_rx_pma_clkout 0
         set_instance_parameter_value  inst_xcvr  enable_port_rx_std_pcfifo_empty 1
         set_instance_parameter_value  inst_xcvr  enable_port_rx_std_pcfifo_full 1
      }
      set_instance_parameter_value  inst_xcvr  std_rx_byte_deser_mode "Deserialize x2"
      set_instance_parameter_value  inst_xcvr  std_rx_8b10b_enable 1
      set_instance_parameter_value  inst_xcvr  std_rx_word_aligner_mode "manual (PLD controlled)"
      set_instance_parameter_value  inst_xcvr  std_rx_word_aligner_pattern [get_parameter_value "ALIGNMENT_PATTERN"]
      set_instance_parameter_value  inst_xcvr  std_rx_word_aligner_pattern_len 20
      set_instance_parameter_value  inst_xcvr  enable_port_rx_std_wa_patternalign 1
      set_instance_parameter_value  inst_xcvr  std_rx_bitrev_enable 1 
      set_instance_parameter_value  inst_xcvr  std_rx_byterev_enable 1 
      set_instance_parameter_value  inst_xcvr  std_rx_polinv_enable 1	
      set_instance_parameter_value  inst_xcvr  enable_port_rx_std_bitrev_ena 1
      set_instance_parameter_value  inst_xcvr  enable_port_rx_std_byterev_ena 1
      set_instance_parameter_value  inst_xcvr  enable_port_rx_polinv 1
      if {[param_matches DEVICE_FAMILY "Stratix 10"] } {
         #set_instance_parameter_value  inst_xcvr  rx_fifo_mode "Register-Phase compensation"
         set_instance_parameter_value  inst_xcvr  rx_fifo_mode "Phase compensation"
         set_instance_parameter_value  inst_xcvr  rx_clkout_sel "pcs_clkout"
         #set_instance_parameter_value  inst_xcvr  rx_coreclkin_clock_network "rowclk"
         set_instance_parameter_value  inst_xcvr  enable_port_rx_fifo_full 1
         set_instance_parameter_value  inst_xcvr  enable_port_rx_fifo_empty 1
         set_instance_parameter_value  inst_xcvr  rx_fifo_pfull 10
      }
      set_instance_parameter_value  inst_xcvr  rcfg_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_shared [expr {[param_is_true "pll_reconfig_enable"] && [param_is_true "rcfg_shared"] && [get_parameter_value "L"]>1}]
      set_instance_parameter_value  inst_xcvr  rcfg_jtag_enable [param_is_true "rcfg_jtag_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_sv_file_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_h_file_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_mif_file_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  set_capability_reg_enable [param_is_true "set_capability_reg_enable"]
      set_instance_parameter_value  inst_xcvr  set_user_identifier [get_parameter_value "set_user_identifier"]
      set_instance_parameter_value  inst_xcvr  set_csr_soft_logic_enable [param_is_true "set_csr_soft_logic_enable"]
      set_instance_parameter_value  inst_xcvr  set_prbs_soft_logic_enable [param_is_true "set_prbs_soft_logic_enable"]
#      set_instance_parameter_value  inst_xcvr  set_odi_soft_logic_enable [param_is_true "set_odi_soft_logic_enable"]
      set_instance_parameter_value  inst_xcvr  generate_docs 1

   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG2" ]} {
      add_instance                  inst_xcvr  [get_xcvr_component_name [get_parameter_value "DEVICE_FAMILY"]]  18.1
      set_instance_parameter_value  inst_xcvr  duplex_mode "rx"
      set_instance_parameter_value  inst_xcvr  protocol_mode "basic_enh"
      set_instance_parameter_value  inst_xcvr  channels [get_parameter_value "L"]
      set_instance_parameter_value  inst_xcvr  set_data_rate [get_parameter_value "lane_rate"]
      set_instance_parameter_value  inst_xcvr  enable_simple_interface 1
      set_instance_parameter_value  inst_xcvr  set_cdr_refclk_freq [get_parameter_value "d_refclk_freq"]
      set_instance_parameter_value  inst_xcvr  enable_port_rx_is_lockedtodata 1
      set_instance_parameter_value  inst_xcvr  enable_port_rx_is_lockedtoref 0 
      set_instance_parameter_value  inst_xcvr  enable_ports_rx_manual_cdr_mode 0
      set_instance_parameter_value  inst_xcvr  enh_pcs_pma_width 40
      set_instance_parameter_value  inst_xcvr  enh_pld_pcs_width 40
      if {[param_matches DEVICE_FAMILY "Arria 10"] } {
         set_instance_parameter_value  inst_xcvr  enable_port_rx_pma_clkout 0
         set_instance_parameter_value  inst_xcvr  enh_rxfifo_mode "Phase compensation"
         set_instance_parameter_value  inst_xcvr  enable_port_rx_enh_fifo_empty 1
         set_instance_parameter_value  inst_xcvr  enable_port_rx_enh_fifo_full 1
      } elseif {[param_matches DEVICE_FAMILY "Stratix 10"] } {
         set_instance_parameter_value  inst_xcvr  rx_fifo_mode "Phase compensation"
         set_instance_parameter_value  inst_xcvr  enable_port_rx_fifo_empty 1
         set_instance_parameter_value  inst_xcvr  enable_port_rx_fifo_full 1
      }
      set_instance_parameter_value  inst_xcvr  rcfg_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_shared [expr {[param_is_true "pll_reconfig_enable"] && [param_is_true "rcfg_shared"] && [get_parameter_value "L"]>1}]
      set_instance_parameter_value  inst_xcvr  rcfg_jtag_enable [param_is_true "rcfg_jtag_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_sv_file_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_h_file_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_mif_file_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  set_capability_reg_enable [param_is_true "set_capability_reg_enable"]
      set_instance_parameter_value  inst_xcvr  set_user_identifier [get_parameter_value "set_user_identifier"]
      set_instance_parameter_value  inst_xcvr  set_csr_soft_logic_enable [param_is_true "set_csr_soft_logic_enable"]
      set_instance_parameter_value  inst_xcvr  set_prbs_soft_logic_enable [param_is_true "set_prbs_soft_logic_enable"]
#      set_instance_parameter_value  inst_xcvr  set_odi_soft_logic_enable [param_is_true "set_odi_soft_logic_enable"]
      set_instance_parameter_value  inst_xcvr  generate_docs 1
     
   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG3" ]} {
   } else { 
      #{[param_matches PCS_CONFIG "JESD_PCS_CFG4" ]} 
   }
}

#Proc to add instances for duplex mode for series 10 device family
proc duplex_add_instances_xs {} {
   set d_L [get_parameter_value "L"]

   add_instance              inst_tx_mlpcs                  altera_jesd204_tx_mlpcs 18.1
   propagate_params          inst_tx_mlpcs
   add_instance              inst_rx_mlpcs                  altera_jesd204_rx_mlpcs 18.1
   propagate_params          inst_rx_mlpcs

   if {[param_is_true rcfg_shared] || $d_L==1} {
      add_instance              inst_phy_adapter               altera_jesd204_phy_adapter_xs 18.1
      propagate_params          inst_phy_adapter
   } else {
      add_instance              inst_phy_adapter               altera_jesd204_phy_adapter_xs_rcfg_shared_off 18.1
      propagate_params          inst_phy_adapter
   }

   if {[param_matches PCS_CONFIG "JESD_PCS_CFG1" ]} {
      # (PCS_CONFIG=JESD_PCS_CFG1)
      add_instance                  inst_xcvr  [get_xcvr_component_name [get_parameter_value "DEVICE_FAMILY"]]  18.1
      set_instance_parameter_value  inst_xcvr  duplex_mode "duplex"
      set_instance_parameter_value  inst_xcvr  protocol_mode "basic_std"
      set_instance_parameter_value  inst_xcvr  channels [get_parameter_value "L"]
      set_instance_parameter_value  inst_xcvr  set_data_rate [get_parameter_value "lane_rate"]
      set_instance_parameter_value  inst_xcvr  enable_simple_interface 1
      set_instance_parameter_value  inst_xcvr  set_cdr_refclk_freq [get_parameter_value "d_refclk_freq"]
      set_instance_parameter_value  inst_xcvr  enable_port_rx_is_lockedtodata 1
      set_instance_parameter_value  inst_xcvr  enable_port_rx_is_lockedtoref 0 
      set_instance_parameter_value  inst_xcvr  enable_ports_rx_manual_cdr_mode 0
      set_instance_parameter_value  inst_xcvr  std_pcs_pma_width 20
      if {[param_matches DEVICE_FAMILY "Arria 10"] } {
         set_instance_parameter_value  inst_xcvr  enable_port_rx_pma_clkout 0
         set_instance_parameter_value  inst_xcvr  enable_port_rx_std_pcfifo_empty 1
         set_instance_parameter_value  inst_xcvr  enable_port_rx_std_pcfifo_full 1
      }
      set_instance_parameter_value  inst_xcvr  std_rx_byte_deser_mode "Deserialize x2"
      set_instance_parameter_value  inst_xcvr  std_rx_8b10b_enable 1
      set_instance_parameter_value  inst_xcvr  std_rx_word_aligner_mode "manual (PLD controlled)"
      set_instance_parameter_value  inst_xcvr  std_rx_word_aligner_pattern [get_parameter_value "ALIGNMENT_PATTERN"]
      set_instance_parameter_value  inst_xcvr  std_rx_word_aligner_pattern_len 20
      set_instance_parameter_value  inst_xcvr  enable_port_rx_std_wa_patternalign 1
      set_instance_parameter_value  inst_xcvr  std_rx_bitrev_enable 1 
      set_instance_parameter_value  inst_xcvr  std_rx_byterev_enable 1 
      set_instance_parameter_value  inst_xcvr  std_rx_polinv_enable 1	
      set_instance_parameter_value  inst_xcvr  enable_port_rx_std_bitrev_ena 1
      set_instance_parameter_value  inst_xcvr  enable_port_rx_std_byterev_ena 1
      set_instance_parameter_value  inst_xcvr  enable_port_rx_polinv 1
      set_instance_parameter_value  inst_xcvr  enable_port_rx_seriallpbken 1  
      if {[param_matches DEVICE_FAMILY "Stratix 10"] } {
         #set_instance_parameter_value  inst_xcvr  rx_fifo_mode "Register-Phase compensation"
         set_instance_parameter_value  inst_xcvr  rx_fifo_mode "Phase compensation"
         set_instance_parameter_value  inst_xcvr  rx_clkout_sel "pcs_clkout"
         #set_instance_parameter_value  inst_xcvr  rx_coreclkin_clock_network "rowclk"
         set_instance_parameter_value  inst_xcvr  pcs_reset_sequencing_mode [derive_pcs_reset_sequencing_s10]
         set_instance_parameter_value  inst_xcvr  enable_port_rx_fifo_full 1
         set_instance_parameter_value  inst_xcvr  enable_port_rx_fifo_empty 1
         set_instance_parameter_value  inst_xcvr  tx_fifo_pfull 10
         set_instance_parameter_value  inst_xcvr  rx_fifo_pfull 10
      }
      set_instance_parameter_value  inst_xcvr  rcfg_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_shared [expr {[param_is_true "pll_reconfig_enable"] && [param_is_true "rcfg_shared"] && [get_parameter_value "L"]>1}]
      set_instance_parameter_value  inst_xcvr  rcfg_jtag_enable [param_is_true "rcfg_jtag_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_sv_file_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_h_file_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_mif_file_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  set_capability_reg_enable [param_is_true "set_capability_reg_enable"]
      set_instance_parameter_value  inst_xcvr  set_user_identifier [get_parameter_value "set_user_identifier"]
      set_instance_parameter_value  inst_xcvr  set_csr_soft_logic_enable [param_is_true "set_csr_soft_logic_enable"]
      set_instance_parameter_value  inst_xcvr  set_prbs_soft_logic_enable [param_is_true "set_prbs_soft_logic_enable"]
#      set_instance_parameter_value  inst_xcvr  set_odi_soft_logic_enable [param_is_true "set_odi_soft_logic_enable"]
      set_instance_parameter_value  inst_xcvr  generate_docs 1
      set_instance_parameter_value  inst_xcvr  bonded_mode [derive_pll_mode_clk_xs [get_parameter_value "L"] bonded_mode]
      set_instance_parameter_value  inst_xcvr  enable_port_tx_pma_elecidle 1
      set_instance_parameter_value  inst_xcvr  std_pcs_pma_width 20
      if {[param_matches DEVICE_FAMILY "Arria 10"] } {
         set_instance_parameter_value  inst_xcvr  enable_port_tx_std_pcfifo_empty 1
         set_instance_parameter_value  inst_xcvr  enable_port_tx_std_pcfifo_full 1
      }
      set_instance_parameter_value  inst_xcvr  std_tx_byte_ser_mode "Serialize x2"
      set_instance_parameter_value  inst_xcvr  std_tx_8b10b_enable 1
      set_instance_parameter_value  inst_xcvr  std_tx_bitrev_enable [get_parameter_value "BIT_REVERSAL"]
      set_instance_parameter_value  inst_xcvr  std_tx_byterev_enable [get_parameter_value "BIT_REVERSAL"]
      set_instance_parameter_value  inst_xcvr  std_tx_polinv_enable 1	
      set_instance_parameter_value  inst_xcvr  enable_port_tx_polinv 1
      if {[param_matches DEVICE_FAMILY "Stratix 10"] } {
         set_instance_parameter_value  inst_xcvr  tx_fifo_mode "Phase compensation"
         set_instance_parameter_value  inst_xcvr  tx_clkout_sel "pcs_clkout"
         #set_instance_parameter_value  inst_xcvr  tx_coreclkin_clock_network "rowclk"
         set_instance_parameter_value  inst_xcvr  enable_port_tx_fifo_full 1
         set_instance_parameter_value  inst_xcvr  enable_port_tx_fifo_empty 1
      }

   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG2" ]} {
      add_instance                  inst_xcvr  [get_xcvr_component_name [get_parameter_value "DEVICE_FAMILY"]]  18.1
      set_instance_parameter_value  inst_xcvr  duplex_mode "duplex"
      set_instance_parameter_value  inst_xcvr  protocol_mode "basic_enh"
      set_instance_parameter_value  inst_xcvr  channels [get_parameter_value "L"]
      set_instance_parameter_value  inst_xcvr  set_data_rate [get_parameter_value "lane_rate"]
      set_instance_parameter_value  inst_xcvr  enable_simple_interface 1
      set_instance_parameter_value  inst_xcvr  bonded_mode [derive_pll_mode_clk_xs [get_parameter_value "L"] bonded_mode]
      set_instance_parameter_value  inst_xcvr  enable_port_tx_pma_elecidle 1
      set_instance_parameter_value  inst_xcvr  set_cdr_refclk_freq [get_parameter_value "d_refclk_freq"]

      set_instance_parameter_value  inst_xcvr  enable_port_rx_is_lockedtodata 1
      set_instance_parameter_value  inst_xcvr  enable_port_rx_is_lockedtoref 0
      set_instance_parameter_value  inst_xcvr  enable_port_rx_seriallpbken 1
      set_instance_parameter_value  inst_xcvr  enable_ports_rx_manual_cdr_mode 0
      set_instance_parameter_value  inst_xcvr  enh_pcs_pma_width 40
      set_instance_parameter_value  inst_xcvr  enh_pld_pcs_width 40
      if {[param_matches DEVICE_FAMILY "Arria 10"] } {
         set_instance_parameter_value  inst_xcvr  enable_port_rx_pma_clkout 0
         set_instance_parameter_value  inst_xcvr  enh_txfifo_mode "Phase compensation"
         set_instance_parameter_value  inst_xcvr  enable_port_tx_enh_fifo_empty 1
         set_instance_parameter_value  inst_xcvr  enable_port_tx_enh_fifo_full 1
         set_instance_parameter_value  inst_xcvr  enh_rxfifo_mode "Phase compensation"
         set_instance_parameter_value  inst_xcvr  enable_port_rx_enh_fifo_empty 1
         set_instance_parameter_value  inst_xcvr  enable_port_rx_enh_fifo_full 1
      } elseif {[param_matches DEVICE_FAMILY "Stratix 10"] } {
         set_instance_parameter_value  inst_xcvr  pcs_reset_sequencing_mode [derive_pcs_reset_sequencing_s10]
         set_instance_parameter_value  inst_xcvr  tx_fifo_mode "Phase compensation"
         set_instance_parameter_value  inst_xcvr  enable_port_tx_fifo_empty 1
         set_instance_parameter_value  inst_xcvr  enable_port_tx_fifo_full 1
         set_instance_parameter_value  inst_xcvr  rx_fifo_mode "Phase compensation"
         set_instance_parameter_value  inst_xcvr  enable_port_rx_fifo_empty 1
         set_instance_parameter_value  inst_xcvr  enable_port_rx_fifo_full 1
      }
      set_instance_parameter_value  inst_xcvr  rcfg_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_shared [expr {[param_is_true "pll_reconfig_enable"] && [param_is_true "rcfg_shared"] && [get_parameter_value "L"]>1}]
      set_instance_parameter_value  inst_xcvr  rcfg_jtag_enable [param_is_true "rcfg_jtag_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_sv_file_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_h_file_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  rcfg_mif_file_enable [param_is_true "pll_reconfig_enable"]
      set_instance_parameter_value  inst_xcvr  set_capability_reg_enable [param_is_true "set_capability_reg_enable"]
      set_instance_parameter_value  inst_xcvr  set_user_identifier [get_parameter_value "set_user_identifier"]
      set_instance_parameter_value  inst_xcvr  set_csr_soft_logic_enable [param_is_true "set_csr_soft_logic_enable"]
      set_instance_parameter_value  inst_xcvr  set_prbs_soft_logic_enable [param_is_true "set_prbs_soft_logic_enable"]
#      set_instance_parameter_value  inst_xcvr  set_odi_soft_logic_enable [param_is_true "set_odi_soft_logic_enable"]
      set_instance_parameter_value  inst_xcvr  generate_docs 1

   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG3" ]} {
   } else { 
      #{[param_matches PCS_CONFIG "JESD_PCS_CFG4" ]} 
   }

}

#--DEVICE FAMILY V series--
# Set interfaces for TX and RX and add "prefix" to the interfaces to make the interfaces'name unique
# The "prefix" is to avoid tx and rx having same interfaces'name in DUPLEX mode
proc set_phy_connections { tx_ rx_ } {
   #--------------TX interfaces----------------
   # set_export_interface  <interface_name>  <interface_type>  <direction>  <instance_name>  <instance_interface>  <enable_condition>
   #Clocks and Resets	
   set_export_interface  ${tx_}pll_ref_clk   clock  end   inst_phy_adapter  in_clk        [expr {[set_tx_interfaces_on] && [device_is_vseries] }]
   set_export_interface  txlink_clk          clock  end   inst_phy_adapter  txlink_clk    [expr {[set_tx_interfaces_on] }]
   set_export_interface  txlink_rst_n        reset  end   inst_phy_adapter  txlink_rst_n  [expr {[set_tx_interfaces_on] }]

   # Debug & Testing
   set_export_interface  jesd204_tx_pcs_data        conduit  end    inst_tx_mlpcs     jesd204_tx_pcs_data        [expr { [set_tx_interfaces_on]}]
   set_export_interface  jesd204_tx_pcs_kchar_data  conduit  end    inst_tx_mlpcs     jesd204_tx_pcs_kchar_data  [expr { [set_tx_interfaces_on] }]

   # CSR
   set_export_interface  ${tx_}csr_lane_polarity    conduit  end    inst_tx_mlpcs     csr_lane_polarity   [expr { [set_tx_interfaces_on]}]
   set_export_interface  ${tx_}csr_bit_reversal     conduit  end    inst_tx_mlpcs     csr_bit_reversal    [expr { [set_tx_interfaces_on]}]
   set_export_interface  ${tx_}csr_byte_reversal    conduit  end    inst_tx_mlpcs     csr_byte_reversal   [expr { [set_tx_interfaces_on]}]
   set_export_interface  ${tx_}csr_lane_powerdown   conduit  end    inst_tx_mlpcs     csr_lane_powerdown  [expr { [set_tx_interfaces_on]}]    
  
   set_export_interface  phy_csr_pll_locked         conduit  start  inst_phy_adapter  phy_csr_pll_locked       [expr { [set_tx_interfaces_on] && [device_is_vseries]}]
   set_export_interface  phy_csr_tx_cal_busy        conduit  start  inst_phy_adapter  phy_csr_tx_cal_busy      [expr { [set_tx_interfaces_on]}]
   set_export_interface  phy_tx_elecidle            conduit  end    inst_phy_adapter  phy_tx_elecidle          [expr { [set_tx_interfaces_on]}]

   set_connections inst_phy_adapter.phy_txlink_clk    inst_tx_mlpcs.txlink_clk    [expr { [set_tx_interfaces_on]}]
   set_connections inst_phy_adapter.phy_txlink_rst_n  inst_tx_mlpcs.txlink_rst_n  [expr { [set_tx_interfaces_on]}]

   #--------------RX interfaces----------------
   #Clocks and Resets	
   set_export_interface  ${rx_}pll_ref_clk   clock    end    inst_phy_adapter  rx_refclk     [expr {[set_rx_interfaces_on] }]
   set_export_interface  rxlink_clk          clock    end    inst_phy_adapter  rxlink_clk    [expr {[set_rx_interfaces_on] }]
   set_export_interface  rxlink_rst_n        reset    end    inst_phy_adapter  rxlink_rst_n  [expr {[set_rx_interfaces_on] }]
 
   # CSR
   set_export_interface  ${rx_}csr_lane_polarity     conduit  end    inst_rx_mlpcs     csr_lane_polarity          [expr {[set_rx_interfaces_on] }]
   set_export_interface  ${rx_}csr_bit_reversal      conduit  end    inst_rx_mlpcs     csr_bit_reversal           [expr {[set_rx_interfaces_on] }]
   set_export_interface  ${rx_}csr_byte_reversal     conduit  end    inst_rx_mlpcs     csr_byte_reversal          [expr {[set_rx_interfaces_on] }]
   set_export_interface  patternalign_en             conduit  end    inst_rx_mlpcs     patternalign_en            [expr {[set_rx_interfaces_on] }]
   set_export_interface  jesd204_rx_pcs_data         conduit  start  inst_rx_mlpcs     jesd204_rx_pcs_data        [expr {[set_rx_interfaces_on] }]
   set_export_interface  jesd204_rx_pcs_data_valid   conduit  start  inst_rx_mlpcs     jesd204_rx_pcs_data_valid  [expr {[set_rx_interfaces_on] }] 
   set_export_interface  jesd204_rx_pcs_kchar_data   conduit  start  inst_rx_mlpcs     jesd204_rx_pcs_kchar_data  [expr {[set_rx_interfaces_on] }]
   set_export_interface  jesd204_rx_pcs_errdetect    conduit  start  inst_rx_mlpcs     jesd204_rx_pcs_errdetect   [expr {[set_rx_interfaces_on] }]
   set_export_interface  jesd204_rx_pcs_disperr      conduit  start  inst_rx_mlpcs     jesd204_rx_pcs_disperr     [expr {[set_rx_interfaces_on] }]
   set_export_interface  ${rx_}csr_lane_powerdown    conduit  end    inst_rx_mlpcs     csr_lane_powerdown         [expr {[set_rx_interfaces_on] }]

   set_export_interface  phy_csr_rx_locked_to_data   conduit  start  inst_phy_adapter  phy_csr_rx_locked_to_data  [expr {[set_rx_interfaces_on] }]
   set_export_interface  phy_csr_rx_cal_busy         conduit  start  inst_phy_adapter  phy_csr_rx_cal_busy        [expr {[set_rx_interfaces_on] }]
   
   set_connections inst_phy_adapter.phy_rxlink_clk    inst_rx_mlpcs.rxlink_clk     [expr {[set_rx_interfaces_on] }]
   set_connections inst_phy_adapter.phy_rxlink_rst_n  inst_rx_mlpcs.rxlink_rst_n   [expr {[set_rx_interfaces_on] }]

   # Interfaces and connections for PHY
   if {[param_matches PCS_CONFIG "JESD_PCS_CFG1" ]} {
      #--------------TX interfaces----------------
      set_export_interface  tx_serial_data       conduit  start  inst_xcvr  tx_serial_data       [expr { [set_tx_interfaces_on] }]
      set_export_interface  pll_powerdown        conduit  end    inst_xcvr  pll_powerdown        [expr { [set_tx_interfaces_on] }]
      set_export_interface  tx_analogreset       conduit  end    inst_xcvr  tx_analogreset       [expr { [set_tx_interfaces_on] }]
      set_export_interface  tx_digitalreset      conduit  end    inst_xcvr  tx_digitalreset      [expr { [set_tx_interfaces_on] }]
      set_export_interface  reconfig_to_xcvr     conduit  end    inst_xcvr  reconfig_to_xcvr     [expr { [set_tx_interfaces_on] }]
      set_export_interface  reconfig_from_xcvr   conduit  start  inst_xcvr  reconfig_from_xcvr   [expr { [set_tx_interfaces_on] }]
      set_export_interface  txphy_clk            conduit  start  inst_xcvr  tx_std_clkout        [expr { [set_tx_interfaces_on] }]

      set_connections       inst_phy_adapter.out_clk             inst_xcvr.tx_pll_refclk         [expr { [set_tx_interfaces_on] }]
      set_connections       inst_xcvr.tx_std_clkout              inst_tx_mlpcs.txphy_clk         [expr { [set_tx_interfaces_on] }]
      set_connections       inst_tx_mlpcs.tx_parallel_data       inst_xcvr.tx_parallel_data      [expr { [set_tx_interfaces_on] }]
      set_connections       inst_tx_mlpcs.tx_datak               inst_xcvr.tx_datak              [expr { [set_tx_interfaces_on] }]
      set_connections       inst_tx_mlpcs.phy_lane_polarity      inst_xcvr.tx_std_polinv         [expr { [set_tx_interfaces_on] }]
      set_connections       inst_phy_adapter.phy_tx_coreclkin    inst_xcvr.tx_std_coreclkin      [expr { [set_tx_interfaces_on] }]
      set_connections       inst_xcvr.pll_locked                 inst_phy_adapter.pll_locked     [expr { [set_tx_interfaces_on] }]
      set_connections       inst_xcvr.tx_cal_busy                inst_phy_adapter.tx_cal_busy    [expr { [set_tx_interfaces_on] }]
      set_connections       inst_phy_adapter.tx_elecidle         inst_xcvr.tx_std_elecidle       [expr {[set_tx_interfaces_on] }]
      set_connections       inst_xcvr.tx_std_pcfifo_full         inst_phy_adapter.tx_pcfifo_full   [expr {[set_tx_interfaces_on] }]
      set_connections       inst_xcvr.tx_std_pcfifo_empty        inst_phy_adapter.tx_pcfifo_empty  [expr {[set_tx_interfaces_on] }]	

      # CSR
      set_export_interface  phy_csr_tx_pcfifo_full     conduit  start  inst_phy_adapter  phy_csr_tx_pcfifo_full   [expr { [set_tx_interfaces_on]}]
      set_export_interface  phy_csr_tx_pcfifo_empty    conduit  start  inst_phy_adapter  phy_csr_tx_pcfifo_empty  [expr { [set_tx_interfaces_on]}]

      # GND unused ports from XCVR
      set_connections   inst_phy_adapter.unused_tx_parallel_data   inst_xcvr.unused_tx_parallel_data [expr {[set_tx_interfaces_on] }]

      #--------------RX interfaces----------------
      set_export_interface  rx_serial_data       conduit    end    inst_xcvr   rx_serial_data       [expr {[set_rx_interfaces_on] }]
      set_export_interface  rx_analogreset       conduit    end    inst_xcvr   rx_analogreset       [expr {[set_rx_interfaces_on] }]
      set_export_interface  rx_digitalreset      conduit    end    inst_xcvr   rx_digitalreset      [expr {[set_rx_interfaces_on] }]
      set_export_interface  reconfig_to_xcvr     conduit    end    inst_xcvr   reconfig_to_xcvr     [expr {[set_rx_interfaces_on] }]    
      set_export_interface  reconfig_from_xcvr   conduit    start  inst_xcvr   reconfig_from_xcvr   [expr {[set_rx_interfaces_on] }]
      set_export_interface  rxphy_clk            conduit    start  inst_xcvr   rx_std_clkout        [expr {[set_rx_interfaces_on] }]

      set_connections  inst_phy_adapter.rx_refclk_phy         inst_xcvr.rx_cdr_refclk              [expr {[set_rx_interfaces_on] }]
      set_connections  inst_phy_adapter.phy_rx_coreclkin      inst_xcvr.rx_std_coreclkin           [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_std_clkout                inst_rx_mlpcs.rxphy_clk              [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_parallel_data             inst_rx_mlpcs.rx_parallel_data       [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_datak                     inst_rx_mlpcs.phy_kchar_data         [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_errdetect                 inst_rx_mlpcs.phy_code_err           [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_disperr                   inst_rx_mlpcs.phy_rd_err             [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_syncstatus                inst_rx_mlpcs.phy_sync_status        [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_is_lockedtodata           inst_phy_adapter.rx_locked_to_data   [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_cal_busy                  inst_phy_adapter.rx_cal_busy         [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_std_pcfifo_full           inst_phy_adapter.rx_pcfifo_full      [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_std_pcfifo_empty          inst_phy_adapter.rx_pcfifo_empty     [expr {[set_rx_interfaces_on] }]
      set_connections  inst_rx_mlpcs.phy_lane_polarity        inst_xcvr.rx_std_polinv              [expr {[set_rx_interfaces_on] }]  
      set_connections  inst_rx_mlpcs.phy_bit_reversal         inst_xcvr.rx_std_bitrev_ena          [expr {[set_rx_interfaces_on] }]
      set_connections  inst_rx_mlpcs.phy_byte_reversal        inst_xcvr.rx_std_byterev_ena         [expr {[set_rx_interfaces_on] }] 
      set_connections  inst_rx_mlpcs.phy_patternalign_en      inst_xcvr.rx_std_wa_patternalign     [expr {[set_rx_interfaces_on] }] 

      # Seriallpbk port
      set_export_interface  rx_seriallpbken      conduit  end    inst_xcvr  rx_seriallpbken        [expr {[set_rx_interfaces_on] && [set_tx_interfaces_on] }]

      # CSR
      set_export_interface  phy_csr_rx_pcfifo_full      conduit  start  inst_phy_adapter  phy_csr_rx_pcfifo_full     [expr {[set_rx_interfaces_on] }]
      set_export_interface  phy_csr_rx_pcfifo_empty     conduit  start  inst_phy_adapter  phy_csr_rx_pcfifo_empty    [expr {[set_rx_interfaces_on] }]

      #Sink unused ports from XCVR
      set_connections  inst_xcvr.rx_runningdisp            inst_phy_adapter.unused_rx_runningdisp          [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_patterndetect          inst_phy_adapter.unused_rx_patterndetect        [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.unused_rx_parallel_data   inst_phy_adapter.unused_rx_parallel_data        [expr {[set_rx_interfaces_on] }]

   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG2" ]} {
      #--------------TX interfaces----------------
      set_export_interface  tx_serial_data       conduit  start  inst_xcvr  tx_serial_data       [expr {[set_tx_interfaces_on] }]
      set_export_interface  pll_powerdown        conduit  end    inst_xcvr  pll_powerdown        [expr {[set_tx_interfaces_on] }]
      set_export_interface  tx_analogreset       conduit  end    inst_xcvr  tx_analogreset       [expr {[set_tx_interfaces_on] }]
      set_export_interface  tx_digitalreset      conduit  end    inst_xcvr  tx_digitalreset      [expr {[set_tx_interfaces_on] }]
      set_export_interface  reconfig_to_xcvr     conduit  end    inst_xcvr  reconfig_to_xcvr     [expr {[set_tx_interfaces_on] }]
      set_export_interface  reconfig_from_xcvr   conduit  start  inst_xcvr  reconfig_from_xcvr   [expr {[set_tx_interfaces_on] }]
      set_export_interface  txphy_clk            conduit  start  inst_xcvr  tx_10g_clkout        [expr {[set_tx_interfaces_on] }]

      set_connections       inst_phy_adapter.out_clk             inst_xcvr.tx_pll_refclk            [expr {[set_tx_interfaces_on] }]
      set_connections       inst_xcvr.tx_10g_clkout              inst_tx_mlpcs.txphy_clk            [expr {[set_tx_interfaces_on] }]
      set_connections       inst_tx_mlpcs.tx_parallel_data       inst_xcvr.tx_parallel_data         [expr {[set_tx_interfaces_on] }]
      set_connections       inst_phy_adapter.phy_tx_coreclkin    inst_xcvr.tx_10g_coreclkin         [expr {[set_tx_interfaces_on] }]
      set_connections       inst_xcvr.pll_locked                 inst_phy_adapter.pll_locked        [expr {[set_tx_interfaces_on] }]
      set_connections       inst_xcvr.tx_cal_busy                inst_phy_adapter.tx_cal_busy       [expr {[set_tx_interfaces_on] }]
      # No electrical idle support for 10g pcs. Refer to FB 133626
      #set_connections       inst_phy_adapter.tx_elecidle         inst_xcvr.tx_10g_elecidle          [expr {[set_tx_interfaces_on] }]
      set_connections       inst_xcvr.tx_10g_fifo_full           inst_phy_adapter.tx_pcfifo_full    [expr {[set_tx_interfaces_on] }]
      set_connections       inst_xcvr.tx_10g_fifo_empty          inst_phy_adapter.tx_pcfifo_empty   [expr {[set_tx_interfaces_on] }]

      # CSR
      set_export_interface  phy_csr_tx_pcfifo_full     conduit  start  inst_phy_adapter  phy_csr_tx_pcfifo_full   [expr { [set_tx_interfaces_on]}]
      set_export_interface  phy_csr_tx_pcfifo_empty    conduit  start  inst_phy_adapter  phy_csr_tx_pcfifo_empty  [expr { [set_tx_interfaces_on]}]

      #GND unused ports from XCVR
      set_connections       inst_phy_adapter.unused_tx_10g_control          inst_xcvr.tx_10g_control            [expr {[set_tx_interfaces_on] }] 
      set_connections       inst_phy_adapter.unused_tx_10g_data_valid       inst_xcvr.tx_10g_data_valid         [expr {[set_tx_interfaces_on] }] 
      set_connections       inst_phy_adapter.unused_tx_parallel_data        inst_xcvr.unused_tx_parallel_data   [expr {[set_tx_interfaces_on] }]

      #--------------RX interfaces----------------
      set_export_interface  rx_serial_data       conduit    end    inst_xcvr   rx_serial_data       [expr {[set_rx_interfaces_on] }]
      set_export_interface  rx_analogreset       conduit    end    inst_xcvr   rx_analogreset       [expr {[set_rx_interfaces_on] }]
      set_export_interface  rx_digitalreset      conduit    end    inst_xcvr   rx_digitalreset      [expr {[set_rx_interfaces_on] }]
      set_export_interface  reconfig_to_xcvr     conduit    end    inst_xcvr   reconfig_to_xcvr     [expr {[set_rx_interfaces_on] }]    
      set_export_interface  reconfig_from_xcvr   conduit    start  inst_xcvr   reconfig_from_xcvr   [expr {[set_rx_interfaces_on] }]
      set_export_interface  rxphy_clk            conduit    start  inst_xcvr   rx_10g_clkout        [expr {[set_rx_interfaces_on] }]

      set_connections  inst_phy_adapter.rx_refclk_phy       inst_xcvr.rx_cdr_refclk              [expr {[set_rx_interfaces_on] }]
      set_connections  inst_phy_adapter.phy_rx_coreclkin    inst_xcvr.rx_10g_coreclkin           [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_10g_clkout              inst_rx_mlpcs.rxphy_clk              [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_parallel_data           inst_rx_mlpcs.rx_parallel_data       [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_is_lockedtodata         inst_phy_adapter.rx_locked_to_data   [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_cal_busy                inst_phy_adapter.rx_cal_busy         [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_10g_fifo_full           inst_phy_adapter.rx_pcfifo_full      [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_10g_fifo_empty          inst_phy_adapter.rx_pcfifo_empty     [expr {[set_rx_interfaces_on] }]

      # Serial loopback port within transceiver (Valid for Duplex mode only)
      set_export_interface  rx_seriallpbken    conduit  end   inst_xcvr  rx_seriallpbken   [expr {[set_rx_interfaces_on] && [set_tx_interfaces_on]}]

      # CSR
      set_export_interface  phy_csr_rx_pcfifo_full      conduit  start  inst_phy_adapter  phy_csr_rx_pcfifo_full     [expr {[set_rx_interfaces_on] }]
      set_export_interface  phy_csr_rx_pcfifo_empty     conduit  start  inst_phy_adapter  phy_csr_rx_pcfifo_empty    [expr {[set_rx_interfaces_on] }]
  
      #Sink unused ports from XCVR
      set_connections inst_xcvr.rx_10g_control            inst_phy_adapter.unused_rx_10g_control          [expr {[set_rx_interfaces_on] }]
      set_connections inst_xcvr.unused_rx_parallel_data   inst_phy_adapter.unused_rx_parallel_data        [expr {[set_rx_interfaces_on] }]

   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG3" ]} {

#       add_connection                inst_xcvr.tx_std_clkout                        inst_tx.tx_clkout
#	add_connection                inst_phy_adapter.phy_tx_coreclkin              inst_xcvr.tx_std_coreclkin
#	add_connection                inst_xcvr.pll_locked                           inst_tx.phy_csr_pll_locked
#	add_connection                inst_xcvr.tx_cal_busy                          inst_tx.phy_csr_tx_cal_busy
#	add_connection                inst_tx.tx_parallel_data                       inst_xcvr.tx_parallel_data
#	add_connection                inst_tx.tx_datak                               inst_xcvr.tx_datak
#	add_connection                inst_tx.phy_csr_tx_polarity                    inst_xcvr.tx_std_polinv
#	add_connection                inst_tx.phy_csr_tx_forcedisp                   inst_xcvr.tx_forcedisp
#	add_connection                inst_tx.phy_csr_tx_dispval                     inst_xcvr.tx_dispval

   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG4" ]} {
      #--------------TX interfaces----------------
      set_export_interface  tx_serial_data       conduit  start  inst_xcvr  tx_serial_data       [expr { [set_tx_interfaces_on] }]
      set_export_interface  pll_powerdown        conduit  end    inst_xcvr  pll_powerdown        [expr { [set_tx_interfaces_on] }]
      set_export_interface  tx_analogreset       conduit  end    inst_xcvr  tx_analogreset       [expr { [set_tx_interfaces_on] }]
      set_export_interface  tx_digitalreset      conduit  end    inst_xcvr  tx_digitalreset      [expr { [set_tx_interfaces_on] }]
      set_export_interface  reconfig_to_xcvr     conduit  end    inst_xcvr  reconfig_to_xcvr     [expr { [set_tx_interfaces_on] }]
      set_export_interface  reconfig_from_xcvr   conduit  start  inst_xcvr  reconfig_from_xcvr   [expr { [set_tx_interfaces_on] }]
      set_export_interface  txphy_clk            conduit  start  inst_xcvr  tx_pma_clkout        [expr { [set_tx_interfaces_on] }]
   
      set_connections       inst_phy_adapter.out_clk             inst_xcvr.tx_pll_refclk         [expr { [set_tx_interfaces_on] }]
      set_connections       inst_xcvr.tx_pma_clkout              inst_tx_mlpcs.txphy_clk         [expr { [set_tx_interfaces_on] }]
      set_connections       inst_tx_mlpcs.tx_parallel_data       inst_xcvr.tx_pma_parallel_data  [expr { [set_tx_interfaces_on] }]
      set_connections       inst_xcvr.pll_locked                 inst_phy_adapter.pll_locked     [expr { [set_tx_interfaces_on] }]
      set_connections       inst_xcvr.tx_cal_busy                inst_phy_adapter.tx_cal_busy    [expr { [set_tx_interfaces_on] }]  

      # CSR
      set_export_interface  phy_csr_tx_pcfifo_full     conduit  start  inst_tx_mlpcs  csr_pcfifo_full   [expr { [set_tx_interfaces_on]}]
      set_export_interface  phy_csr_tx_pcfifo_empty    conduit  start  inst_tx_mlpcs  csr_pcfifo_empty  [expr { [set_tx_interfaces_on]}]
  
      #--------------RX interfaces----------------
      set_export_interface  rx_serial_data       conduit    end    inst_xcvr   rx_serial_data       [expr {[set_rx_interfaces_on] }]
      set_export_interface  rx_analogreset       conduit    end    inst_xcvr   rx_analogreset       [expr {[set_rx_interfaces_on] }]
      set_export_interface  rx_digitalreset      conduit    end    inst_xcvr   rx_digitalreset      [expr {[set_rx_interfaces_on] }]
      set_export_interface  reconfig_to_xcvr     conduit    end    inst_xcvr   reconfig_to_xcvr     [expr {[set_rx_interfaces_on] }]    
      set_export_interface  reconfig_from_xcvr   conduit    start  inst_xcvr   reconfig_from_xcvr   [expr {[set_rx_interfaces_on] }]
      set_export_interface  rxphy_clk            conduit    start  inst_xcvr   rx_pma_clkout        [expr {[set_rx_interfaces_on] }]
 
      set_connections  inst_phy_adapter.rx_refclk_phy         inst_xcvr.rx_cdr_refclk              [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_pma_clkout                inst_rx_mlpcs.rxphy_clk              [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_pma_parallel_data         inst_rx_mlpcs.rx_parallel_data       [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_is_lockedtodata           inst_phy_adapter.rx_locked_to_data   [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_cal_busy                  inst_phy_adapter.rx_cal_busy         [expr {[set_rx_interfaces_on] }]
   
      # Seriallpbk port
      set_export_interface  rx_seriallpbken      conduit  end    inst_xcvr  rx_seriallpbken        [expr {[set_rx_interfaces_on] && [set_tx_interfaces_on] }]

      # CSR
      set_export_interface  phy_csr_rx_pcfifo_full      conduit  start  inst_rx_mlpcs  csr_pcfifo_full     [expr {[set_rx_interfaces_on] }]
      set_export_interface  phy_csr_rx_pcfifo_empty     conduit  start  inst_rx_mlpcs  csr_pcfifo_empty    [expr {[set_rx_interfaces_on] }]

   } else { 
	  # {[param_matches PCS_CONFIG "JESD_PCS_CFG4" ]}
#       add_connection                inst_xcvr.tx_pma_clkout                        inst_tx.tx_clkout
#	add_connection                inst_phy_adapter.phy_tx_coreclkin              inst_xcvr.tx_pma_coreclkin
#	add_connection                inst_xcvr.pll_locked                           inst_tx.phy_csr_pll_locked
#	add_connection                inst_xcvr.tx_cal_busy                          inst_tx.phy_csr_tx_cal_busy
#	add_connection                inst_tx.tx_parallel_data                       inst_xcvr.tx_pma_parallel_data

   }

}

#--DEVICE FAMILY X series--
# Set interfaces for TX and RX and add "prefix" to the interfaces to make the interfaces'name unique
# The "prefix" is to avoid tx and rx having same interfaces'name in DUPLEX mode
proc set_phy_connections_xs { tx_ rx_ } {
   set d_L [get_parameter_value "L"]
   #--------------TX interfaces----------------
   # set_export_interface  <interface_name>  <interface_type>  <direction>  <instance_name>  <instance_interface>  <enable_condition>
   #Clocks and Resets	
   set_export_interface  txlink_clk          clock  end   inst_phy_adapter  txlink_clk    [expr {[set_tx_interfaces_on] }]
   set_export_interface  txlink_rst_n        reset  end   inst_phy_adapter  txlink_rst_n  [expr {[set_tx_interfaces_on] }]

   # Debug & Testing
   set_export_interface  jesd204_tx_pcs_data        conduit  end    inst_tx_mlpcs     jesd204_tx_pcs_data        [expr { [set_tx_interfaces_on]}]
   set_export_interface  jesd204_tx_pcs_kchar_data  conduit  end    inst_tx_mlpcs     jesd204_tx_pcs_kchar_data  [expr { [set_tx_interfaces_on] }]

   # CSR
   set_export_interface  ${tx_}csr_lane_polarity    conduit  end    inst_tx_mlpcs     csr_lane_polarity   [expr { [set_tx_interfaces_on]}]
   set_export_interface  ${tx_}csr_bit_reversal     conduit  end    inst_tx_mlpcs     csr_bit_reversal    [expr { [set_tx_interfaces_on]}]
   set_export_interface  ${tx_}csr_byte_reversal    conduit  end    inst_tx_mlpcs     csr_byte_reversal   [expr { [set_tx_interfaces_on]}]
   set_export_interface  ${tx_}csr_lane_powerdown   conduit  end    inst_tx_mlpcs     csr_lane_powerdown  [expr { [set_tx_interfaces_on]}]    

   set_export_interface  phy_csr_tx_cal_busy        conduit  start  inst_phy_adapter  phy_csr_tx_cal_busy      [expr { [set_tx_interfaces_on]}]
   set_export_interface  phy_tx_elecidle            conduit  end    inst_phy_adapter  phy_tx_elecidle          [expr { [set_tx_interfaces_on]}]
   set_export_interface  phy_csr_tx_pcfifo_full     conduit  start  inst_phy_adapter  phy_csr_tx_pcfifo_full   [expr { [set_tx_interfaces_on]}]
   set_export_interface  phy_csr_tx_pcfifo_empty    conduit  start  inst_phy_adapter  phy_csr_tx_pcfifo_empty  [expr { [set_tx_interfaces_on]}]

   set_connections inst_phy_adapter.phy_txlink_clk    inst_tx_mlpcs.txlink_clk    [expr { [set_tx_interfaces_on]}]
   set_connections inst_phy_adapter.phy_txlink_rst_n  inst_tx_mlpcs.txlink_rst_n  [expr { [set_tx_interfaces_on]}]

   #--------------RX interfaces----------------
   #Clocks and Resets	
   set_export_interface  ${rx_}pll_ref_clk   clock    end    inst_phy_adapter  rx_refclk     [expr {[set_rx_interfaces_on] }]
   set_export_interface  rxlink_clk          clock    end    inst_phy_adapter  rxlink_clk    [expr {[set_rx_interfaces_on] }]
   set_export_interface  rxlink_rst_n        reset    end    inst_phy_adapter  rxlink_rst_n  [expr {[set_rx_interfaces_on] }]
 
   # CSR
   set_export_interface  ${rx_}csr_lane_polarity     conduit  end    inst_rx_mlpcs     csr_lane_polarity          [expr {[set_rx_interfaces_on] }]
   set_export_interface  ${rx_}csr_bit_reversal      conduit  end    inst_rx_mlpcs     csr_bit_reversal           [expr {[set_rx_interfaces_on] }]
   set_export_interface  ${rx_}csr_byte_reversal     conduit  end    inst_rx_mlpcs     csr_byte_reversal          [expr {[set_rx_interfaces_on] }]
   set_export_interface  ${rx_}csr_lane_powerdown    conduit  end    inst_rx_mlpcs     csr_lane_powerdown         [expr {[set_rx_interfaces_on] }] 
   set_export_interface  patternalign_en             conduit  end    inst_rx_mlpcs     patternalign_en            [expr {[set_rx_interfaces_on] }]
   set_export_interface  jesd204_rx_pcs_data         conduit  start  inst_rx_mlpcs     jesd204_rx_pcs_data        [expr {[set_rx_interfaces_on] }]
   set_export_interface  jesd204_rx_pcs_data_valid   conduit  start  inst_rx_mlpcs     jesd204_rx_pcs_data_valid  [expr {[set_rx_interfaces_on] }] 
   set_export_interface  jesd204_rx_pcs_kchar_data   conduit  start  inst_rx_mlpcs     jesd204_rx_pcs_kchar_data  [expr {[set_rx_interfaces_on] }]
   set_export_interface  jesd204_rx_pcs_errdetect    conduit  start  inst_rx_mlpcs     jesd204_rx_pcs_errdetect   [expr {[set_rx_interfaces_on] }]
   set_export_interface  jesd204_rx_pcs_disperr      conduit  start  inst_rx_mlpcs     jesd204_rx_pcs_disperr     [expr {[set_rx_interfaces_on] }]
 
   set_export_interface  phy_csr_rx_locked_to_data   conduit  start  inst_phy_adapter  phy_csr_rx_locked_to_data  [expr {[set_rx_interfaces_on] }]
   set_export_interface  phy_csr_rx_cal_busy         conduit  start  inst_phy_adapter  phy_csr_rx_cal_busy        [expr {[set_rx_interfaces_on] }]
   set_export_interface  phy_csr_rx_pcfifo_full      conduit  start  inst_phy_adapter  phy_csr_rx_pcfifo_full     [expr {[set_rx_interfaces_on] }]
   set_export_interface  phy_csr_rx_pcfifo_empty     conduit  start  inst_phy_adapter  phy_csr_rx_pcfifo_empty    [expr {[set_rx_interfaces_on] }]
   
   set_connections inst_phy_adapter.phy_rxlink_clk    inst_rx_mlpcs.rxlink_clk     [expr {[set_rx_interfaces_on] }]
   set_connections inst_phy_adapter.phy_rxlink_rst_n  inst_rx_mlpcs.rxlink_rst_n   [expr {[set_rx_interfaces_on] }]

   # Interfaces and connections for PHY
   if {[param_matches PCS_CONFIG "JESD_PCS_CFG1" ]} {
      #--------------TX interfaces----------------
      #--DEVICE FAMILY X series--
      set_export_interface  tx_serial_data       conduit  start  inst_xcvr          tx_serial_data   [expr {[set_tx_interfaces_on] }]
      if {$d_L == 1} {
         set_export_interface  "[derive_pll_mode_clk_xs $d_L clk_name]"  [derive_pll_mode_clk_xs $d_L clk_type]  end  inst_phy_adapter "[derive_pll_mode_clk_xs $d_L clk_name]" \
                               [expr {[set_tx_interfaces_on] }]
      } else {
         for { set i 0 } {$i < $d_L} {incr i} {
         set_export_interface  "[derive_pll_mode_clk_xs $d_L clk_name]_ch${i}"  [derive_pll_mode_clk_xs $d_L clk_type]  end  inst_phy_adapter "[derive_pll_mode_clk_xs $d_L clk_name]_ch${i}" \
                               [expr {[set_tx_interfaces_on] }]
         }
      }
      set_export_interface  tx_analogreset       conduit  end    inst_xcvr          tx_analogreset   [expr {[set_tx_interfaces_on] }]
      set_export_interface  tx_digitalreset      conduit  end    inst_xcvr          tx_digitalreset  [expr {[set_tx_interfaces_on] }]
      set_export_interface  tx_analogreset_stat  conduit  start  inst_xcvr     tx_analogreset_stat   [expr {[set_tx_interfaces_on] && [param_matches DEVICE_FAMILY "Stratix 10"] }]
      set_export_interface  tx_digitalreset_stat conduit  start  inst_xcvr     tx_digitalreset_stat  [expr {[set_tx_interfaces_on] && [param_matches DEVICE_FAMILY "Stratix 10"] }]
      set_export_interface  txphy_clk            conduit  start  inst_phy_adapter   txphy_clk        [expr {[set_tx_interfaces_on] }]
      
      if {[get_parameter_value "bonded_mode"] == "bonded"} {
         set_connections       inst_phy_adapter.phy_tx_bonding_clocks   inst_xcvr.tx_bonding_clocks     [expr {[set_tx_interfaces_on] }]
      } else {
         set_connections       inst_phy_adapter.phy_tx_serial_clk0      inst_xcvr.tx_serial_clk0        [expr {[set_tx_interfaces_on] }]
      }

      set_connections       inst_xcvr.tx_clkout                  inst_phy_adapter.tx_clkout         [expr {[set_tx_interfaces_on] }]
      set_connections       inst_phy_adapter.txphy_clk           inst_tx_mlpcs.txphy_clk            [expr {[set_tx_interfaces_on] }]
      set_connections       inst_tx_mlpcs.tx_parallel_data       inst_xcvr.tx_parallel_data         [expr {[set_tx_interfaces_on] }]
      set_connections       inst_tx_mlpcs.tx_datak               inst_xcvr.tx_datak                 [expr {[set_tx_interfaces_on] }]
      set_connections       inst_tx_mlpcs.phy_lane_polarity      inst_xcvr.tx_polinv                [expr {[set_tx_interfaces_on] }]

      set_connections       inst_phy_adapter.phy_tx_coreclkin    inst_xcvr.tx_coreclkin             [expr {[set_tx_interfaces_on] }]
      set_connections       inst_xcvr.tx_cal_busy                inst_phy_adapter.tx_cal_busy       [expr {[set_tx_interfaces_on] }]
      set_connections       inst_phy_adapter.tx_elecidle         inst_xcvr.tx_pma_elecidle          [expr {[set_tx_interfaces_on] }]
      set_connections       inst_xcvr.tx_std_pcfifo_full         inst_phy_adapter.tx_pcfifo_full    [expr {[set_tx_interfaces_on] && [param_matches DEVICE_FAMILY "Arria 10"]}]
      set_connections       inst_xcvr.tx_std_pcfifo_empty        inst_phy_adapter.tx_pcfifo_empty   [expr {[set_tx_interfaces_on] && [param_matches DEVICE_FAMILY "Arria 10"]}]	
      set_connections       inst_xcvr.tx_fifo_full               inst_phy_adapter.tx_pcfifo_full    [expr {[set_tx_interfaces_on] && [param_matches DEVICE_FAMILY "Stratix 10"]}]
      set_connections       inst_xcvr.tx_fifo_empty              inst_phy_adapter.tx_pcfifo_empty   [expr {[set_tx_interfaces_on] && [param_matches DEVICE_FAMILY "Stratix 10"]}]	

      # AV-MM Interface for Dynamic Reconfig
        #RECONFIG_SHARED = 1
      set_export_interface   reconfig_clk         clock   sink   inst_phy_adapter  reconfig_clk            [expr {[param_is_true "pll_reconfig_enable"] && [expr {[param_is_true rcfg_shared] || $d_L==1}] }]
      set_export_interface   reconfig_reset       reset   sink   inst_phy_adapter  reconfig_reset          [expr {[param_is_true "pll_reconfig_enable"] && [expr {[param_is_true rcfg_shared] || $d_L==1}] }]
      set_export_interface   reconfig_avmm        avalon  slave  inst_phy_adapter  reconfig_avmm           [expr {[param_is_true "pll_reconfig_enable"] && [expr {[param_is_true rcfg_shared] || $d_L==1}] }]
        #RECONFIG_SHARED = 0
      set_export_interface   reconfig_clk         conduit sink   inst_phy_adapter  reconfig_clk            [expr {[param_is_true "pll_reconfig_enable"] && ![expr {[param_is_true rcfg_shared] || $d_L==1}] }]
      set_export_interface   reconfig_reset       conduit sink   inst_phy_adapter  reconfig_reset          [expr {[param_is_true "pll_reconfig_enable"] && ![expr {[param_is_true rcfg_shared] || $d_L==1}] }]
      set_export_interface   reconfig_avmm        conduit slave  inst_phy_adapter  reconfig_avmm           [expr {[param_is_true "pll_reconfig_enable"] && ![expr {[param_is_true rcfg_shared] || $d_L==1}] }]

      set_connections        inst_xcvr.reconfig_clk     inst_phy_adapter.phy_reconfig_clk     [expr {[param_is_true "pll_reconfig_enable"] }]
      set_connections        inst_xcvr.reconfig_reset   inst_phy_adapter.phy_reconfig_reset   [expr {[param_is_true "pll_reconfig_enable"] }]
      set_connections        inst_xcvr.reconfig_avmm    inst_phy_adapter.phy_reconfig_avmm    [expr {[param_is_true "pll_reconfig_enable"] }]
     	
      #GND unused ports from XCVR
      set_connections       inst_phy_adapter.unused_tx_parallel_data         inst_xcvr.unused_tx_parallel_data   [expr {[set_tx_interfaces_on] }]

      #--------------RX interfaces----------------      
      #--DEVICE FAMILY X series--
      set_export_interface  rx_serial_data      conduit    end    inst_xcvr          rx_serial_data    [expr {[set_rx_interfaces_on] }]
      set_export_interface  rx_analogreset      conduit    end    inst_xcvr          rx_analogreset    [expr {[set_rx_interfaces_on] }]
      set_export_interface  rx_digitalreset     conduit    end    inst_xcvr          rx_digitalreset   [expr {[set_rx_interfaces_on] }]
      set_export_interface  rx_analogreset_stat   conduit  start  inst_xcvr      rx_analogreset_stat   [expr {[set_rx_interfaces_on] && [param_matches DEVICE_FAMILY "Stratix 10"] }]
      set_export_interface  rx_digitalreset_stat  conduit  start  inst_xcvr      rx_digitalreset_stat  [expr {[set_rx_interfaces_on] && [param_matches DEVICE_FAMILY "Stratix 10"] }]
      set_export_interface  rxphy_clk           conduit    start  inst_phy_adapter   rxphy_clk         [expr {[set_rx_interfaces_on] }]
   
      set_connections  inst_phy_adapter.rx_refclk_phy         inst_xcvr.rx_cdr_refclk0             [expr {[set_rx_interfaces_on] }]
      set_connections  inst_phy_adapter.phy_rx_coreclkin      inst_xcvr.rx_coreclkin               [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_clkout                    inst_phy_adapter.rx_clkout           [expr {[set_rx_interfaces_on] }] 
      set_connections  inst_phy_adapter.rxphy_clk             inst_rx_mlpcs.rxphy_clk              [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_parallel_data             inst_rx_mlpcs.rx_parallel_data       [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_datak                     inst_rx_mlpcs.phy_kchar_data         [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_errdetect                 inst_rx_mlpcs.phy_code_err           [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_disperr                   inst_rx_mlpcs.phy_rd_err             [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_syncstatus                inst_rx_mlpcs.phy_sync_status        [expr {[set_rx_interfaces_on] }]

      set_connections  inst_xcvr.rx_is_lockedtodata           inst_phy_adapter.rx_locked_to_data   [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_cal_busy                  inst_phy_adapter.rx_cal_busy         [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_std_pcfifo_full           inst_phy_adapter.rx_pcfifo_full      [expr {[set_rx_interfaces_on] && [param_matches DEVICE_FAMILY "Arria 10"]}]
      set_connections  inst_xcvr.rx_std_pcfifo_empty          inst_phy_adapter.rx_pcfifo_empty     [expr {[set_rx_interfaces_on] && [param_matches DEVICE_FAMILY "Arria 10"]}]
      set_connections  inst_xcvr.rx_fifo_full                 inst_phy_adapter.rx_pcfifo_full      [expr {[set_rx_interfaces_on] && [param_matches DEVICE_FAMILY "Stratix 10"]}]
      set_connections  inst_xcvr.rx_fifo_empty                inst_phy_adapter.rx_pcfifo_empty     [expr {[set_rx_interfaces_on] && [param_matches DEVICE_FAMILY "Stratix 10"]}]
      set_connections  inst_rx_mlpcs.phy_lane_polarity        inst_xcvr.rx_polinv                  [expr {[set_rx_interfaces_on] }]  
      set_connections  inst_rx_mlpcs.phy_bit_reversal         inst_xcvr.rx_std_bitrev_ena          [expr {[set_rx_interfaces_on] }]
      set_connections  inst_rx_mlpcs.phy_byte_reversal        inst_xcvr.rx_std_byterev_ena         [expr {[set_rx_interfaces_on] }] 
      set_connections  inst_rx_mlpcs.phy_patternalign_en      inst_xcvr.rx_std_wa_patternalign     [expr {[set_rx_interfaces_on] }] 

      # Serial loopback port within transceiver (Valid for Duplex mode only)
      set_export_interface  rx_seriallpbken    conduit  end   inst_xcvr  rx_seriallpbken   [expr {[set_rx_interfaces_on] && [set_tx_interfaces_on] }]

      #Sink unused ports from XCVR
      set_connections  inst_xcvr.rx_runningdisp            inst_phy_adapter.unused_rx_runningdisp          [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_patterndetect          inst_phy_adapter.unused_rx_patterndetect        [expr {[set_rx_interfaces_on] }]
      set_connections inst_xcvr.unused_rx_parallel_data    inst_phy_adapter.unused_rx_parallel_data        [expr {[set_rx_interfaces_on] }]

   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG2" ]} {
      #--------------TX interfaces----------------
      #--DEVICE FAMILY X series--
      set_export_interface  tx_serial_data       conduit  start  inst_xcvr          tx_serial_data   [expr {[set_tx_interfaces_on] }]
      if {$d_L == 1} {
         set_export_interface  "[derive_pll_mode_clk_xs $d_L clk_name]"  [derive_pll_mode_clk_xs $d_L clk_type]  end  inst_phy_adapter "[derive_pll_mode_clk_xs $d_L clk_name]" \
                               [expr {[set_tx_interfaces_on] }]
      } else {
         for { set i 0 } {$i < $d_L} {incr i} {
         set_export_interface  "[derive_pll_mode_clk_xs $d_L clk_name]_ch${i}"  [derive_pll_mode_clk_xs $d_L clk_type]  end  inst_phy_adapter "[derive_pll_mode_clk_xs $d_L clk_name]_ch${i}" \
                               [expr {[set_tx_interfaces_on] }]
         }
      }

      set_export_interface  tx_analogreset       conduit  end    inst_xcvr          tx_analogreset   [expr {[set_tx_interfaces_on] }]
      set_export_interface  tx_digitalreset      conduit  end    inst_xcvr          tx_digitalreset  [expr {[set_tx_interfaces_on] }]
      set_export_interface  tx_analogreset_stat  conduit  start  inst_xcvr     tx_analogreset_stat   [expr {[set_tx_interfaces_on] && [param_matches DEVICE_FAMILY "Stratix 10"] }]
      set_export_interface  tx_digitalreset_stat conduit  start  inst_xcvr     tx_digitalreset_stat  [expr {[set_tx_interfaces_on] && [param_matches DEVICE_FAMILY "Stratix 10"] }]
      set_export_interface  txphy_clk            conduit  start  inst_phy_adapter   txphy_clk        [expr {[set_tx_interfaces_on] }]

      if {[get_parameter_value "bonded_mode"] == "bonded"} {
         set_connections       inst_phy_adapter.phy_tx_bonding_clocks   inst_xcvr.tx_bonding_clocks     [expr {[set_tx_interfaces_on] }]
      } else {
         set_connections       inst_phy_adapter.phy_tx_serial_clk0      inst_xcvr.tx_serial_clk0        [expr {[set_tx_interfaces_on] }]
      }

      set_connections       inst_xcvr.tx_clkout                  inst_phy_adapter.tx_clkout         [expr {[set_tx_interfaces_on] }]
      set_connections       inst_phy_adapter.txphy_clk           inst_tx_mlpcs.txphy_clk            [expr {[set_tx_interfaces_on] }]
      set_connections       inst_tx_mlpcs.tx_parallel_data       inst_xcvr.tx_parallel_data         [expr {[set_tx_interfaces_on] }]
      set_connections       inst_phy_adapter.phy_tx_coreclkin    inst_xcvr.tx_coreclkin             [expr {[set_tx_interfaces_on] }]
      set_connections       inst_xcvr.tx_cal_busy                inst_phy_adapter.tx_cal_busy       [expr {[set_tx_interfaces_on] }]
      set_connections       inst_phy_adapter.tx_elecidle         inst_xcvr.tx_pma_elecidle          [expr {[set_tx_interfaces_on] }]
      set_connections       inst_xcvr.tx_enh_fifo_full           inst_phy_adapter.tx_pcfifo_full    [expr {[set_tx_interfaces_on] && [param_matches DEVICE_FAMILY "Arria 10"]}]
      set_connections       inst_xcvr.tx_enh_fifo_empty          inst_phy_adapter.tx_pcfifo_empty   [expr {[set_tx_interfaces_on] && [param_matches DEVICE_FAMILY "Arria 10"]}]	
      set_connections       inst_xcvr.tx_fifo_full               inst_phy_adapter.tx_pcfifo_full    [expr {[set_tx_interfaces_on] && [param_matches DEVICE_FAMILY "Stratix 10"]}]
      set_connections       inst_xcvr.tx_fifo_empty              inst_phy_adapter.tx_pcfifo_empty   [expr {[set_tx_interfaces_on] && [param_matches DEVICE_FAMILY "Stratix 10"]}]	

      # AV-MM Interface for Dynamic Reconfig
        #RECONFIG_SHARED = 1
      set_export_interface   reconfig_clk         clock   sink   inst_phy_adapter  reconfig_clk            [expr {[param_is_true "pll_reconfig_enable"] && [expr {[param_is_true rcfg_shared] || $d_L==1}] }]
      set_export_interface   reconfig_reset       reset   sink   inst_phy_adapter  reconfig_reset          [expr {[param_is_true "pll_reconfig_enable"] && [expr {[param_is_true rcfg_shared] || $d_L==1}] }]
      set_export_interface   reconfig_avmm        avalon  slave  inst_phy_adapter  reconfig_avmm           [expr {[param_is_true "pll_reconfig_enable"] && [expr {[param_is_true rcfg_shared] || $d_L==1}] }]
        #RECONFIG_SHARED = 0
      set_export_interface   reconfig_clk         conduit sink   inst_phy_adapter  reconfig_clk            [expr {[param_is_true "pll_reconfig_enable"] && ![expr {[param_is_true rcfg_shared] || $d_L==1}] }]
      set_export_interface   reconfig_reset       conduit sink   inst_phy_adapter  reconfig_reset          [expr {[param_is_true "pll_reconfig_enable"] && ![expr {[param_is_true rcfg_shared] || $d_L==1}] }]
      set_export_interface   reconfig_avmm        conduit slave  inst_phy_adapter  reconfig_avmm           [expr {[param_is_true "pll_reconfig_enable"] && ![expr {[param_is_true rcfg_shared] || $d_L==1}] }]

      set_connections        inst_xcvr.reconfig_clk     inst_phy_adapter.phy_reconfig_clk     [expr {[param_is_true "pll_reconfig_enable"] }]
      set_connections        inst_xcvr.reconfig_reset   inst_phy_adapter.phy_reconfig_reset   [expr {[param_is_true "pll_reconfig_enable"] }]
      set_connections        inst_xcvr.reconfig_avmm    inst_phy_adapter.phy_reconfig_avmm    [expr {[param_is_true "pll_reconfig_enable"] }]
	
      #GND unused ports from XCVR
      set_connections       inst_phy_adapter.unused_tx_enh_data_valid        inst_xcvr.tx_enh_data_valid         [expr {[set_tx_interfaces_on] && [param_matches DEVICE_FAMILY "Arria 10"]}] 
      set_connections       inst_phy_adapter.unused_tx_parallel_data         inst_xcvr.unused_tx_parallel_data   [expr {[set_tx_interfaces_on] }]

      #--------------RX interfaces----------------      
      #--DEVICE FAMILY X series--
      set_export_interface  rx_serial_data      conduit    end    inst_xcvr          rx_serial_data    [expr {[set_rx_interfaces_on] }]
      set_export_interface  rx_analogreset      conduit    end    inst_xcvr          rx_analogreset    [expr {[set_rx_interfaces_on] }]
      set_export_interface  rx_digitalreset     conduit    end    inst_xcvr          rx_digitalreset   [expr {[set_rx_interfaces_on] }]
      set_export_interface  rx_analogreset_stat   conduit  start  inst_xcvr      rx_analogreset_stat   [expr {[set_rx_interfaces_on] && [param_matches DEVICE_FAMILY "Stratix 10"] }]
      set_export_interface  rx_digitalreset_stat  conduit  start  inst_xcvr      rx_digitalreset_stat  [expr {[set_rx_interfaces_on] && [param_matches DEVICE_FAMILY "Stratix 10"] }]
      set_export_interface  rxphy_clk           conduit    start  inst_phy_adapter   rxphy_clk         [expr {[set_rx_interfaces_on] }]

      set_connections  inst_phy_adapter.rx_refclk_phy         inst_xcvr.rx_cdr_refclk0             [expr {[set_rx_interfaces_on] }]
      set_connections  inst_phy_adapter.phy_rx_coreclkin      inst_xcvr.rx_coreclkin               [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_clkout                    inst_phy_adapter.rx_clkout           [expr {[set_rx_interfaces_on] }] 
      set_connections  inst_phy_adapter.rxphy_clk             inst_rx_mlpcs.rxphy_clk              [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_parallel_data             inst_rx_mlpcs.rx_parallel_data       [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_is_lockedtodata           inst_phy_adapter.rx_locked_to_data   [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_cal_busy                  inst_phy_adapter.rx_cal_busy         [expr {[set_rx_interfaces_on] }]
      set_connections  inst_xcvr.rx_enh_fifo_full             inst_phy_adapter.rx_pcfifo_full      [expr {[set_rx_interfaces_on] && [param_matches DEVICE_FAMILY "Arria 10"]}]
      set_connections  inst_xcvr.rx_enh_fifo_empty            inst_phy_adapter.rx_pcfifo_empty     [expr {[set_rx_interfaces_on] && [param_matches DEVICE_FAMILY "Arria 10"]}]
      set_connections  inst_xcvr.rx_fifo_full                 inst_phy_adapter.rx_pcfifo_full      [expr {[set_rx_interfaces_on] && [param_matches DEVICE_FAMILY "Stratix 10"]}]
      set_connections  inst_xcvr.rx_fifo_empty                inst_phy_adapter.rx_pcfifo_empty     [expr {[set_rx_interfaces_on] && [param_matches DEVICE_FAMILY "Stratix 10"]}]

      # Serial loopback port within transceiver (Valid for Duplex mode only)
      set_export_interface  rx_seriallpbken    conduit  end   inst_xcvr  rx_seriallpbken   [expr {[set_rx_interfaces_on] && [set_tx_interfaces_on]}]

      #Sink unused ports from XCVR
      set_connections inst_xcvr.unused_rx_parallel_data   inst_phy_adapter.unused_rx_parallel_data   [expr {[set_rx_interfaces_on]}]

   } elseif {[param_matches PCS_CONFIG "JESD_PCS_CFG3" ]} {

#       add_connection                inst_xcvr.tx_std_clkout                        inst_tx.tx_clkout
#	add_connection                inst_phy_adapter.phy_tx_coreclkin              inst_xcvr.tx_std_coreclkin
#	add_connection                inst_xcvr.pll_locked                           inst_tx.phy_csr_pll_locked
#	add_connection                inst_xcvr.tx_cal_busy                          inst_tx.phy_csr_tx_cal_busy
#	add_connection                inst_tx.tx_parallel_data                       inst_xcvr.tx_parallel_data
#	add_connection                inst_tx.tx_datak                               inst_xcvr.tx_datak
#	add_connection                inst_tx.phy_csr_tx_polarity                    inst_xcvr.tx_std_polinv
#	add_connection                inst_tx.phy_csr_tx_forcedisp                   inst_xcvr.tx_forcedisp
#	add_connection                inst_tx.phy_csr_tx_dispval                     inst_xcvr.tx_dispval

   } else { 
	  # {[param_matches PCS_CONFIG "JESD_PCS_CFG4" ]}
#       add_connection                inst_xcvr.tx_pma_clkout                        inst_tx.tx_clkout
#	add_connection                inst_phy_adapter.phy_tx_coreclkin              inst_xcvr.tx_pma_coreclkin
#	add_connection                inst_xcvr.pll_locked                           inst_tx.phy_csr_pll_locked
#	add_connection                inst_xcvr.tx_cal_busy                          inst_tx.phy_csr_tx_cal_busy
#	add_connection                inst_tx.tx_parallel_data                       inst_xcvr.tx_pma_parallel_data

   }


}
