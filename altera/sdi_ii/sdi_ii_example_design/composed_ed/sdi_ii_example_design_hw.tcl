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


# +----------------------------------
# | 
# | SDI II Example Design v12.1
# | Intel Corporation 2009.08.19.17:10:07
# | 
# +-----------------------------------

package require -exact qsys 16.0

source ../../sdi_ii/sdi_ii_params.tcl
source ../../sdi_ii/sdi_ii_ed.tcl
source ../../sdi_ii/sdi_ii_interface.tcl
source sdi_ii_ed_v_series.tcl
source sdi_ii_ed_arria10.tcl

# +-----------------------------------
# | module SDI II Example Design
# | 
set_module_property DESCRIPTION "SDI II Example Design"
set_module_property NAME sdi_ii_example_design
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/SDI II Example Design"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "SDI II Example Design"
# set_module_property DATASHEET_URL http://www.altera.com/literature/ug/ug_sdi.pdf
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
#set_module_property ANALYZE_HDL false
set_module_property COMPOSITION_CALLBACK compose_callback
set_module_property HIDE_FROM_QSYS true
# | 
# +-----------------------------------

# +-----------------------------------
# | IP core, Testbench, Example design
# | Common parameters
# |
sdi_ii_common_params

# +-----------------------------------
# | Testbench, Example Design 
# | Common parameters
# |
sdi_ii_tb_ed_common_params

# +-----------------------------------
# | Example Design 
# | Specific parameters
# |
sdi_ii_ed_params
sdi_ii_ed_reconfig_params

# +-----------------------------------
# | Testbench
# | Specific parameters
# |
sdi_ii_test_params
sdi_ii_test_pattgen_params

# +--------------------
# | Compose Callback
# |
proc compose_callback {} {
    #_dprint 1 "Running IP Compose for [get_module_property NAME]"

    set  dir             [get_parameter_value DIRECTION]
    set  config          [get_parameter_value TRANSCEIVER_PROTOCOL]
    set  insert_vpid     [get_parameter_value TX_EN_VPID_INSERT]
    set  extract_vpid    [get_parameter_value RX_EN_VPID_EXTRACT]
    set  video_std       [get_parameter_value VIDEO_STANDARD]
    set  crc_err         [get_parameter_value RX_CRC_ERROR_OUTPUT]
    # set  trs_misc        [get_parameter_value RX_EN_TRS_MISC]
    set  a2b             [get_parameter_value RX_EN_A2B_CONV]
    set  b2a             [get_parameter_value RX_EN_B2A_CONV]
    set  dl_sync         [get_parameter_value TEST_DL_SYNC]
    set  cmp_data        [get_parameter_value TEST_DATA_COMPARE]
    set  trs_test        [get_parameter_value TEST_TRS_LOCKED]
    set  frame_test      [get_parameter_value TEST_FRAME_LOCKED]
    set  device          [get_parameter_value FAMILY]
    set  reset_reconfig  [get_parameter_value TEST_RESET_RECON]
    set  xcvr_tx_pll_sel [get_parameter_value XCVR_TX_PLL_SEL]
    set  hd_frequency    [get_parameter_value HD_FREQ]
    set  txpll_switch    [get_parameter_value ED_TXPLL_SWITCH]

    if { $device == "Cyclone V" || $device == "Arria V" || $device == "Stratix V" || $device == "Arria V GZ" } {
       compose_ed_v_series $dir $config $device $video_std $xcvr_tx_pll_sel $insert_vpid $extract_vpid $crc_err $a2b $b2a $hd_frequency $dl_sync $cmp_data $trs_test $frame_test $reset_reconfig
    } elseif { $device == "Arria 10" } {
       compose_ed_arria_10 $dir $config $device $video_std $insert_vpid $extract_vpid $crc_err $a2b $b2a $cmp_data $txpll_switch
    }
    set_qip_strings {"set_global_assignment -library \"%libraryName%\" -name SDC_FILE \[file join \$::quartus(qip_path) \"sdi_ii_example_design.sdc\"\]" }
}

# +---------------------------------------------------------------------------
# proc: add_export_rename_interface
#
# Renames all ports on the interface of the supplied instance to be named the
# same as the instance ports. This is used when exporting the interface but
# wanting to keep the ports named appended with instance name.
#
proc add_export_rename_interface {instance interface interface_type port_dir} {
  array set in_out [list {output} {start} {input} {end}]
  add_interface ${instance}_${interface} $interface_type $in_out($port_dir)
  set_interface_property ${instance}_${interface} export_of $instance.$interface
  set port_map [list]
  lappend port_map ${instance}_${interface}
  lappend port_map $interface    
  set_interface_property ${instance}_${interface} PORT_NAME_MAP $port_map
}

proc add_export_fanout_rename_interface { instance interface type port_dir} {
    add_interface              ${instance}_${interface}   $type                       $port_dir
    set_interface_property     ${instance}_${interface}   export_of                   ${instance}_${interface}_fanout.sig_fanout0
    set_interface_property     ${instance}_${interface}   PORT_NAME_MAP              "${instance}_${interface} sig_fanout0"
}
