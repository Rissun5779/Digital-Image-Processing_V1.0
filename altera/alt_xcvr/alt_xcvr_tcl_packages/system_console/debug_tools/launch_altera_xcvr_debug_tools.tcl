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



if {[lsearch $auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/alt_xcvr_tcl_packages] == -1} {
  lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/alt_xcvr_tcl_packages
}

package forget alt_xcvr::system_console::alt_xcvr_debug_tools_pkg
package forget alt_xcvr::system_console::alt_xcvr_debug_tools

source $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/alt_xcvr_tcl_packages/system_console/debug_tools/alt_xcvr_debug_tools.tcl

::alt_xcvr::system_console::alt_xcvr_debug_tools::start

#Wrappers around command APIs to show up in system console during tab-complete
proc hssi_build_all {} { 
  ::alt_xcvr::system_console::alt_xcvr_debug_tools::hssi_build_all 
}
proc hssi_get_end_points {} { 
  ::alt_xcvr::system_console::alt_xcvr_debug_tools::hssi_get_end_points
}
proc hssi_query_parameter_names { phy_type param_string } {
  ::alt_xcvr::system_console::alt_xcvr_debug_tools::hssi_query_parameter_names $phy_type $param_string 
}
proc hssi_query_parameter_values { phy_type param } {
  ::alt_xcvr::system_console::alt_xcvr_debug_tools::hssi_query_parameter_values $phy_type $param
}
proc hssi_register_get { phy_index channel_num rcfg_shared user_ofst reg } {
  ::alt_xcvr::system_console::alt_xcvr_debug_tools::hssi_register_get $phy_index $channel_num $rcfg_shared $user_ofst $reg
}
proc hssi_register_set { phy_index enable_bcast total_channels channel_num rcfg_shared user_ofst reg value mask } {
  ::alt_xcvr::system_console::alt_xcvr_debug_tools::hssi_register_set $phy_index $enable_bcast $total_channels $channel_num $rcfg_shared $user_ofst $reg $value $mask
}
proc hssi_param_get { phy_index channel_num rcfg_shared user_ofst param } {
  ::alt_xcvr::system_console::alt_xcvr_debug_tools::hssi_param_get $phy_index $channel_num $rcfg_shared $user_ofst $param
}
proc hssi_param_set { phy_index enable_bcast total_channels channel_num rcfg_shared user_ofst param value } {
  ::alt_xcvr::system_console::alt_xcvr_debug_tools::hssi_param_set $phy_index $enable_bcast $total_channels $channel_num $rcfg_shared $user_ofst $param $value
}
proc hssi_get_user_id { phy_index channel_num rcfg_shared user_ofst } {
  ::alt_xcvr::system_console::alt_xcvr_debug_tools::hssi_get_user_id $phy_index $channel_num $rcfg_shared $user_ofst
}
proc hssi_get_total_channels { phy_index channel_num rcfg_shared user_ofst } {
  ::alt_xcvr::system_console::alt_xcvr_debug_tools::hssi_get_total_channels $phy_index $channel_num $rcfg_shared $user_ofst
}
proc hssi_get_channel_type { phy_index channel_num rcfg_shared user_ofst } {
  ::alt_xcvr::system_console::alt_xcvr_debug_tools::hssi_get_channel_type $phy_index $channel_num $rcfg_shared $user_ofst
}
proc hssi_get_current_channel { phy_index channel_num rcfg_shared user_ofst } {
  ::alt_xcvr::system_console::alt_xcvr_debug_tools::hssi_get_current_channel $phy_index $channel_num $rcfg_shared $user_ofst
}
proc hssi_get_mcgb_en { phy_index user_ofst } {
  ::alt_xcvr::system_console::alt_xcvr_debug_tools::hssi_get_mcgb_en $phy_index $user_ofst
}
proc hssi_mif_store_all_registers { phy_index channel_num rcfg_shared user_ofst xcvr_mif } {
  ::alt_xcvr::system_console::alt_xcvr_debug_tools::hssi_mif_store_all_registers $phy_index $channel_num $rcfg_shared $user_ofst $xcvr_mif
}
proc hssi_mif_stream { phy_index channel_num rcfg_shared user_ofst xcvr_mif enable_bcast total_channels } {
  ::alt_xcvr::system_console::alt_xcvr_debug_tools::hssi_mif_stream $phy_index $channel_num $rcfg_shared $user_ofst $xcvr_mif $enable_bcast $total_channels 
}

