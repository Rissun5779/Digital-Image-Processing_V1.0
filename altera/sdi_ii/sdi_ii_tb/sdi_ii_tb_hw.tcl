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
# | SDI II Testbench v12.1
# | Intel Corporation 2009.08.19.17:10:07
# | 
# +-----------------------------------

package require -exact qsys 16.0

source ../sdi_ii/sdi_ii_params.tcl
source ../sdi_ii/sdi_ii_ed.tcl
source ../sdi_ii/sdi_ii_interface.tcl
source sdi_ii_tb_v_series.tcl
source sdi_ii_tb_arria_10.tcl

# +-----------------------------------
# | module SDI II Testbench
# | 
set_module_property DESCRIPTION "SDI II Testbench"
set_module_property NAME sdi_ii_tb
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/SDI II Testbench"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "SDI II Testbench"
# set_module_property DATASHEET_URL http://www.altera.com/literature/ug/ug_sdi.pdf
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
#set_module_property ANALYZE_HDL false
set_module_property COMPOSITION_CALLBACK compose_callback
set_module_property HIDE_FROM_QSYS true
# | 
# +-----------------------------------

# +-----------------------------------
# | IP core, testbench, example design
# | Common parameters
# |
sdi_ii_common_params

# +-----------------------------------
# | Testbench, Example Design 
# | Common parameters
# |
sdi_ii_tb_ed_common_params
sdi_ii_ed_reconfig_params

# +-----------------------------------
# | Testbench 
# | Specific parameters
# |
sdi_ii_test_params
sdi_ii_test_pattgen_params
sdi_ii_test_multi_ch_params

# set_parameter_property    TEST_LN_OUTPUT        HDL_PARAMETER true
# set_parameter_property    TEST_RECONFIG_SEQ     HDL_PARAMETER true
# set_parameter_property    TEST_DISTURB_SERIAL   HDL_PARAMETER true
# set_parameter_property    TEST_DATA_COMPARE     HDL_PARAMETER true
# set_parameter_property    TEST_DL_SYNC          HDL_PARAMETER true
# set_parameter_property    TEST_TRS_LOCKED       HDL_PARAMETER true
# set_parameter_property    TEST_FRAME_LOCKED     HDL_PARAMETER true
# set_parameter_property    TEST_VPID_OVERWRITE   HDL_PARAMETER true
# set_parameter_property    TEST_MULTI_RECON      HDL_PARAMETER true
# set_parameter_property    TEST_RESET_RECON      HDL_PARAMETER true
# set_parameter_property    TEST_RXSAMPLE_CHK     HDL_PARAMETER true

# +-----------------------------------
# | Compose Callback
# |
proc compose_callback {} {
    #_dprint 1 "Running IP Compose for [get_module_property NAME]"
   
    set  fam              [get_parameter_value FAMILY]
    set  dir              [get_parameter_value DIRECTION]
    set  config           [get_parameter_value TRANSCEIVER_PROTOCOL]
    set  video_std        [get_parameter_value VIDEO_STANDARD]
    set  crc_err          [get_parameter_value RX_CRC_ERROR_OUTPUT]
    set  a2b              [get_parameter_value RX_EN_A2B_CONV]
    set  b2a              [get_parameter_value RX_EN_B2A_CONV]
    set  disturb_serial   [get_parameter_value TEST_DISTURB_SERIAL]
    set  dl_sync          [get_parameter_value TEST_DL_SYNC]
    set  cmp_data         [get_parameter_value TEST_DATA_COMPARE]
    set  insert_vpid      [get_parameter_value TX_EN_VPID_INSERT]
    set  extract_vpid     [get_parameter_value RX_EN_VPID_EXTRACT] 
    set  trs_test         [get_parameter_value TEST_TRS_LOCKED]
    set  frame_test       [get_parameter_value TEST_FRAME_LOCKED]
    set  err_vpid         [get_parameter_value TEST_ERR_VPID]
    set  multi_reconfig   [get_parameter_value TEST_MULTI_RECON]
    set  reset_reconfig   [get_parameter_value TEST_RESET_RECON]
    set  rxsample_test    [get_parameter_value TEST_RXSAMPLE_CHK]
    set  xcvr_tx_pll_sel  [get_parameter_value XCVR_TX_PLL_SEL]
    set  hd_frequency      [get_parameter_value HD_FREQ]
    set  pll_switch        [get_parameter_value ED_TXPLL_SWITCH]
     
    # Derive the desired variation name of each sub instances 
    # (eg du xcvr, du proto) in a core
    if { $fam == "Arria 10" } {
       derive_instance_name  $dir  xcvr_proto  $video_std
    } else {
       derive_instance_name  $dir  $config  $video_std
    }

    # Instantiate example design component
    add_instance  example_design   sdi_ii_example_design
   
    # Propagate the value of parameters to the example design component
    propagate_params  example_design

    # Adding test components
    add_instance      tb_test_control  sdi_ii_tb_control
    propagate_params  tb_test_control
    # Workaround to resolve VHDL compilation issue in Modelsim after upgrading hwtcl API to 16.0
    if { $fam == "Stratix V" | $fam == "Arria V GZ" | $fam == "Arria V" | $fam == "Cyclone V" } {
        add_interface           tb_test_control_tx_rst      reset       start
        set_interface_property  tb_test_control_tx_rst      export_of   tb_test_control.tx_rst
    }

    add_instance      tb_tx_checker    sdi_ii_tb_tx_checker
    propagate_params  tb_tx_checker
    add_instance      tb_rx_checker    sdi_ii_tb_rx_checker
    propagate_params  tb_rx_checker

    if { $video_std == "mr" } {
        set_instance_parameter  tb_rx_checker  RX_EN_VPID_EXTRACT  0
        set_instance_parameter  tb_rx_checker  TEST_LN_OUTPUT      0
        set                     extract_vpid   0
    }

    if { $extract_vpid & !$insert_vpid } {
      set_instance_parameter tb_rx_checker   TEST_GEN_ANC 1
      set_instance_parameter tb_rx_checker   TEST_GEN_VPID 1
    }
    
    # Extra Rx checked is needed for multi-channel test
    if { $multi_reconfig } {
      add_instance            tb_rx_checker_ch0  sdi_ii_tb_rx_checker
      propagate_params        tb_rx_checker_ch0
      set_instance_parameter  tb_rx_checker_ch0  CH_NUMBER             0
      if { $video_std == "tr"} {
        set_instance_parameter  tb_rx_checker_ch0  TX_EN_VPID_INSERT     1
      } else {
        set_instance_parameter  tb_rx_checker_ch0  TX_EN_VPID_INSERT     0
      }
    }

    # For level A (HD-DL) to level B (3Gb) conversion demo, the tx/rx checker could be configured
    # to become tr or 3g checker. To ease maintanance effort, force to 3g. 
    if { $a2b } {
      # set insert_vpid         1
      set_instance_parameter  tb_tx_checker  VIDEO_STANDARD  threeg
      set_instance_parameter  tb_rx_checker  VIDEO_STANDARD  threeg
    }

    # For level B (3Gb) to level A (HD-DL) conversion demo, configure the tx/rx checker to become dl
    if { $b2a } {
      # set insert_vpid         1
      set_instance_parameter  tb_tx_checker  VIDEO_STANDARD  dl
      set_instance_parameter  tb_rx_checker  VIDEO_STANDARD  dl
    }

    if { $fam == "Arria 10" } {
       compose_tb_arria_10   $dir $video_std $crc_err $a2b $b2a $disturb_serial $dl_sync $cmp_data $insert_vpid $extract_vpid $trs_test $frame_test $rxsample_test $pll_switch
    } else {
       compose_tb_v_series $dir $video_std $crc_err $a2b $b2a $disturb_serial $dl_sync $cmp_data $insert_vpid $extract_vpid $trs_test $frame_test $multi_reconfig $reset_reconfig \
       $rxsample_test $xcvr_tx_pll_sel $hd_frequency   
    }
}
