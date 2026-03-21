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
# | SDI II Testbench Receiver Checker v12.0
# | Intel Corporation 2009.08.19.17:10:07
# | 
# +-----------------------------------

package require -exact qsys 16.0

source ../sdi_ii/sdi_ii_params.tcl
source ../sdi_ii/sdi_ii_interface.tcl

# +-----------------------------------
# | module SDI II Testbench Receiver Checker
# | 
set_module_property DESCRIPTION "SDI II Testbench Receiver Checker"
set_module_property NAME sdi_ii_tb_rx_checker
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/SDI II Testbench Receiver Checker"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "SDI II Testbench Receiver Checker"
# set_module_property DATASHEET_URL http://www.altera.com/literature/ug/ug_sdi.pdf
# set_module_property TOP_LEVEL_HDL_FILE src_hdl/sdi_ii_tb_rx_checker.v
# set_module_property TOP_LEVEL_HDL_MODULE sdi_ii_tb_rx_checker
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
#set_module_property SIMULATION_MODEL_IN_VERILOG true
#set_module_property SIMULATION_MODEL_IN_VHDL true
set_module_property ELABORATION_CALLBACK elaboration_callback

# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
#set module_dir [get_module_property MODULE_DIRECTORY]
#add_file ${module_dir}/src_hdl/sdi_ii_tb_rx_checker.v   {SIMULATION}
#add_file ${module_dir}/src_hdl/tb_fifo_line_test.v      {SIMULATION}
#add_file ${module_dir}/src_hdl/tb_data_compare.v        {SIMULATION}
#add_file ${module_dir}/src_hdl/tb_dual_link_sync.v      {SIMULATION}
#add_file ${module_dir}/src_hdl/tb_trs_locked_test.v     {SIMULATION}
#add_file ${module_dir}/src_hdl/tb_frame_locked_test.v   {SIMULATION}
#add_file ${module_dir}/src_hdl/tb_vpid_check.v          {SIMULATION}
#add_file ${module_dir}/src_hdl/tb_rxsample_test.v       {SIMULATION}

add_fileset simulation_verilog SIM_VERILOG generate_files
add_fileset simulation_vhdl    SIM_VHDL    generate_files

set_fileset_property simulation_verilog TOP_LEVEL   sdi_ii_tb_rx_checker
set_fileset_property simulation_vhdl    TOP_LEVEL   sdi_ii_tb_rx_checker

proc generate_files {name} {
   add_fileset_file sdi_ii_tb_rx_checker.v   VERILOG PATH src_hdl/sdi_ii_tb_rx_checker.v
   add_fileset_file tb_fifo_line_test.v      VERILOG PATH src_hdl/tb_fifo_line_test.v
   add_fileset_file tb_data_compare.v        VERILOG PATH src_hdl/tb_data_compare.v
   add_fileset_file tb_dual_link_sync.v      VERILOG PATH src_hdl/tb_dual_link_sync.v
   add_fileset_file tb_trs_locked_test.sv    SYSTEM_VERILOG PATH src_hdl/tb_trs_locked_test.sv
   add_fileset_file tb_frame_locked_test.sv  SYSTEM_VERILOG PATH src_hdl/tb_frame_locked_test.sv
   add_fileset_file tb_vpid_check.v          VERILOG PATH src_hdl/tb_vpid_check.v
   add_fileset_file tb_rxsample_test.v       VERILOG PATH src_hdl/tb_rxsample_test.v
   add_fileset_file tb_txpll_test.sv         SYSTEM_VERILOG PATH src_hdl/tb_txpll_test.sv
}

# | 
# +-----------------------------------

set common_composed_mode 0
sdi_ii_common_params
set_parameter_property    FAMILY                     HDL_PARAMETER true
set_parameter_property    DIRECTION                  HDL_PARAMETER true
set_parameter_property    TRANSCEIVER_PROTOCOL       HDL_PARAMETER false
#set_parameter_property   USE_SOFT_LOGIC             HDL_PARAMETER false
#set_parameter_property   STARTING_CHANNEL_NUMBER    HDL_PARAMETER false
set_parameter_property    TX_HD_2X_OVERSAMPLING      HDL_PARAMETER false
#set_parameter_property    RX_EN_A2B_CONV             HDL_PARAMETER false
#set_parameter_property    RX_EN_B2A_CONV             HDL_PARAMETER false
set_parameter_property    XCVR_TX_PLL_SEL            HDL_PARAMETER true
set_parameter_property    ED_TXPLL_SWITCH            HDL_PARAMETER true
set_parameter_property    HD_FREQ                    HDL_PARAMETER false

sdi_ii_test_params
set_parameter_property    TEST_LN_OUTPUT             HDL_PARAMETER true
set_parameter_property    TEST_SYNC_OUTPUT           HDL_PARAMETER true
set_parameter_property    TEST_DISTURB_SERIAL        HDL_PARAMETER true
set_parameter_property    TEST_DATA_COMPARE          HDL_PARAMETER true
set_parameter_property    TEST_DL_SYNC               HDL_PARAMETER true
set_parameter_property    TEST_TRS_LOCKED            HDL_PARAMETER true
set_parameter_property    TEST_FRAME_LOCKED          HDL_PARAMETER true
set_parameter_property    TEST_VPID_OVERWRITE        HDL_PARAMETER true
set_parameter_property    TEST_RESET_RECON           HDL_PARAMETER true
set_parameter_property    TEST_RST_PRE_OW            HDL_PARAMETER true
set_parameter_property    TEST_RXSAMPLE_CHK          HDL_PARAMETER true

sdi_ii_test_pattgen_params
sdi_ii_test_multi_ch_params
set_parameter_property    CH_NUMBER                  HDL_PARAMETER true

proc elaboration_callback {} {
    set video_std     [get_parameter_value VIDEO_STANDARD]
    set crc_err       [get_parameter_value RX_CRC_ERROR_OUTPUT]
    set cmp_data      [get_parameter_value TEST_DATA_COMPARE]
    set a2b         [get_parameter_value RX_EN_A2B_CONV]
    set b2a         [get_parameter_value RX_EN_B2A_CONV]
    set dl_sync       [get_parameter_value TEST_DL_SYNC]
    set trs_test      [get_parameter_value TEST_TRS_LOCKED]
    set frame_test    [get_parameter_value TEST_FRAME_LOCKED]
    set vpid_ext      [get_parameter_value RX_EN_VPID_EXTRACT]
    set rxsample_test [get_parameter_value TEST_RXSAMPLE_CHK]
    set xcvr_tx_pll_sel [get_parameter_value XCVR_TX_PLL_SEL]
    set dir           [get_parameter_value DIRECTION]
    set pll_switch    [get_parameter_value ED_TXPLL_SWITCH]
    
    if { $video_std == "mr" } {
        set num_streams 4
    } else {
        set num_streams 1
    }

    common_add_clock             rx_clk                  input  true
    common_add_clock             rx_refclk               input  true
    common_add_clock             tx_clk                  input   true

    common_add_reset             ref_rst                 input  rx_clk

    common_add_optional_conduit  align_locked            export  input   1               true
    common_add_optional_conduit  frame_locked            export  input   1               true
    common_add_optional_conduit  rxdata_valid            export  input   1               true
    common_add_optional_conduit  dl_mapping              export  input   1               true
    common_add_optional_conduit  chk_rx                  export  input   2               true
    common_add_optional_conduit  rxcheck_done            export  output  2               true
    common_add_optional_conduit  chk_completed           export  output  1               true
    common_add_optional_conduit  tx_format               export  input   4               true
    common_add_optional_conduit  tx_std                  export  input   3               true
    common_add_optional_conduit  rx_std                  export  input   3               true
    common_add_optional_conduit  align_locked_b          export  input   1               true
    common_add_optional_conduit  trs_locked_b            export  input   1               true
    common_add_optional_conduit  dl_locked               export  input   1               true
    common_add_optional_conduit  frame_locked_b          export  input   1               true
    common_add_optional_conduit  rxdata_b                export  input   20              true
    common_add_optional_conduit  rxdata_valid_b          export  input   1               true
    common_add_optional_conduit  rx_sdi_start_reconfig   export  input   1               true
    common_add_optional_conduit  rx_format               export  input   4*$num_streams  true
    common_add_optional_conduit  txdata_valid            export  input   1               true
    common_add_optional_conduit  txdata_b                export  input   20              true
    common_add_optional_conduit  txdata_valid_b          export  input   1               true
    common_add_optional_conduit  tx_sdi_reconfig_done    export  input   1               true
    common_add_optional_conduit  tx_sdi_start_reconfig   export  input   1               true
    common_add_optional_conduit  rx_check_posedge        export  output  1               true
    common_add_optional_conduit  txdata                  export  input  20*$num_streams  true
    common_add_optional_conduit  rx_f                    export  input   1*$num_streams  true
    common_add_optional_conduit  rx_v                    export  input   1*$num_streams  true
    common_add_optional_conduit  rx_h                    export  input   1*$num_streams  true
    common_add_optional_conduit  rx_ap                   export  input   1*$num_streams  true
    common_add_optional_conduit  trs_locked              export  input   1*$num_streams  true
    common_add_optional_conduit  rxdata                  export  input  20*$num_streams  true
    common_add_optional_conduit  rx_ln                   export  input  11*$num_streams  true
    common_add_optional_conduit  rx_ln_b                 export  input  11*$num_streams  true
    common_add_optional_conduit  rx_trs                  export  input   1*$num_streams  true
    common_add_optional_conduit  rx_eav                  export  input   1*$num_streams  true
    common_add_optional_conduit  rx_crc_error_c          export  input   1*$num_streams  true
    common_add_optional_conduit  rx_crc_error_y          export  input   1*$num_streams  true
    common_add_optional_conduit  rx_crc_error_c_b        export  input   1*$num_streams  true
    common_add_optional_conduit  rx_crc_error_y_b        export  input   1*$num_streams  true
    common_add_optional_conduit  rx_vpid_byte1           export  input   8*$num_streams  true
    common_add_optional_conduit  rx_vpid_byte2           export  input   8*$num_streams  true
    common_add_optional_conduit  rx_vpid_byte3           export  input   8*$num_streams  true
    common_add_optional_conduit  rx_vpid_byte4           export  input   8*$num_streams  true
    common_add_optional_conduit  rx_vpid_valid           export  input   1*$num_streams  true
    common_add_optional_conduit  rx_vpid_checksum_error  export  input   1*$num_streams  true
    common_add_optional_conduit  rx_line_f0              export  input  11*$num_streams  true
    common_add_optional_conduit  rx_line_f1              export  input  11*$num_streams  true 
    common_add_optional_conduit  rx_vpid_byte1_b         export  input   8*$num_streams  true
    common_add_optional_conduit  rx_vpid_byte2_b         export  input   8*$num_streams  true
    common_add_optional_conduit  rx_vpid_byte3_b         export  input   8*$num_streams  true
    common_add_optional_conduit  rx_vpid_byte4_b         export  input   8*$num_streams  true
    common_add_optional_conduit  rx_vpid_valid_b         export  input   1*$num_streams  true
    common_add_optional_conduit  rx_vpid_checksum_error_b  export  input 1*$num_streams  true


    if { $video_std == "sd" } {
       terminate_port  rx_ln                  input 
    }

    if { ($video_std == "sd") | ($video_std != "dl" & $video_std != "tr" & $video_std != "threeg" & $video_std != "mr") } {
       terminate_port  rx_ln_b                input 
    }
    
    if { $video_std == "sd" } {
       set_port_property rx_std     TERMINATION       true
       set_port_property rx_std     TERMINATION_VALUE   0
       terminate_port    tx_std     input 
    } elseif { $a2b } {
       set_port_property rx_std     TERMINATION       true
       set_port_property rx_std     TERMINATION_VALUE   2
       terminate_port    tx_std     input 
    } elseif { $b2a | $video_std == "hd" | $video_std == "dl" } {
       set_port_property rx_std     TERMINATION       true
       set_port_property rx_std     TERMINATION_VALUE   1
       terminate_port    tx_std     input 
    }

    if { $video_std != "dl" } {
       terminate_port  align_locked_b         input 
       terminate_port  trs_locked_b           input
       terminate_port  dl_locked              input 
       terminate_port  frame_locked_b         input
       terminate_port  rxdata_b               input
       terminate_port  rxdata_valid_b         input  
    }

    if {$video_std != "ds" & $video_std != "tr" & $video_std != "mr"} {
       terminate_port  rx_sdi_start_reconfig  input 
    }

    if { !$crc_err } {
       terminate_port  rx_crc_error_c         input 
       terminate_port  rx_crc_error_y         input
    }

    if { !$crc_err | ($video_std != "threeg" & $video_std != "dl" & $video_std != "tr" & $video_std != "mr") } {
       terminate_port  rx_crc_error_c_b       input 
       terminate_port  rx_crc_error_y_b       input
    }

    if { !$frame_test } {
       terminate_port  rx_format              input 
    }

    if { !$trs_test & !$frame_test & !$rxsample_test & !$dl_sync } {
       terminate_port  rx_trs                 input 
       terminate_port  rx_eav                 input 
    }

    if { !$cmp_data } {
       terminate_port  tx_clk                 input  
       terminate_port  txdata                 input  
       terminate_port  txdata_valid           input  
    }

    if { !$cmp_data | $video_std != "dl" } {
       terminate_port  txdata_b               input  
       terminate_port  txdata_valid_b         input  
    }

    if { $xcvr_tx_pll_sel == "0" & $pll_switch == "0" } {
       terminate_port  tx_sdi_reconfig_done   input 
       terminate_port  tx_sdi_start_reconfig  input  
       terminate_port  rx_check_posedge       output 
    }

    if { !$vpid_ext } {
       terminate_port  rx_vpid_byte1            input 
       terminate_port  rx_vpid_byte2            input 
       terminate_port  rx_vpid_byte3            input 
       terminate_port  rx_vpid_byte4            input 
       terminate_port  rx_vpid_valid            input 
       terminate_port  rx_vpid_checksum_error   input 
       terminate_port  rx_line_f0               input 
       terminate_port  rx_line_f1               input 
    }

    if { !$vpid_ext | ($video_std != "threeg" & $video_std != "dl" & $video_std != "tr" & $video_std != "mr") } {
       terminate_port  rx_vpid_byte1_b           input 
       terminate_port  rx_vpid_byte2_b           input  
       terminate_port  rx_vpid_byte3_b           output 
       terminate_port  rx_vpid_byte4_b           output 
       terminate_port  rx_vpid_valid_b           output 
       terminate_port  rx_vpid_checksum_error_b  output 
    }
}

