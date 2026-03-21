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
# | SDI II Testbench Tx Checker v12.0
# | Intel Corporation 2009.08.19.17:10:07
# | 
# +-----------------------------------

package require -exact qsys 16.0

source ../sdi_ii/sdi_ii_params.tcl
source ../sdi_ii/sdi_ii_interface.tcl

# +-----------------------------------
# | module SDI II Testbench Tx Checker
# | 
set_module_property DESCRIPTION "SDI II Testbench Tx Checker"
set_module_property NAME sdi_ii_tb_tx_checker
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/SDI II Testbench Tx Checker"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "SDI II Testbench Tx Checker"
# set_module_property DATASHEET_URL http://www.altera.com/literature/ug/ug_sdi.pdf
# set_module_property TOP_LEVEL_HDL_FILE src_hdl/sdi_ii_tb_tx_checker.v
# set_module_property TOP_LEVEL_HDL_MODULE sdi_ii_tb_tx_checker
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
#add_file ${module_dir}/src_hdl/sdi_ii_tb_tx_checker.v    {SIMULATION}
#add_file ${module_dir}/src_hdl/tb_serial_descrambler.v   {SIMULATION}
#add_file ${module_dir}/src_hdl/tb_serial_check_counter.v {SIMULATION}

add_fileset simulation_verilog SIM_VERILOG generate_files
add_fileset simulation_vhdl    SIM_VHDL    generate_files

set_fileset_property simulation_verilog TOP_LEVEL   sdi_ii_tb_tx_checker
set_fileset_property simulation_vhdl    TOP_LEVEL   sdi_ii_tb_tx_checker

proc generate_files {name} {
   add_fileset_file sdi_ii_tb_tx_checker.v       VERILOG PATH src_hdl/sdi_ii_tb_tx_checker.v
   add_fileset_file tb_serial_descrambler.v      VERILOG PATH src_hdl/tb_serial_descrambler.v
   add_fileset_file tb_serial_check_counter.v    VERILOG PATH src_hdl/tb_serial_check_counter.v
   add_fileset_file tb_tx_clkout_check.v         VERILOG PATH src_hdl/tb_tx_clkout_check.v
}
# | 
# +-----------------------------------

set common_composed_mode 0
sdi_ii_common_params
set_parameter_property DIRECTION                HDL_PARAMETER false
set_parameter_property TRANSCEIVER_PROTOCOL     HDL_PARAMETER false
#set_parameter_property USE_SOFT_LOGIC          HDL_PARAMETER false
#set_parameter_property STARTING_CHANNEL_NUMBER HDL_PARAMETER false
set_parameter_property RX_CRC_ERROR_OUTPUT      HDL_PARAMETER false
set_parameter_property RX_EN_VPID_EXTRACT       HDL_PARAMETER false
set_parameter_property TX_HD_2X_OVERSAMPLING    HDL_PARAMETER false
set_parameter_property TX_EN_VPID_INSERT        HDL_PARAMETER false
set_parameter_property SD_BIT_WIDTH             HDL_PARAMETER false
set_parameter_property XCVR_TX_PLL_SEL          HDL_PARAMETER false
set_parameter_property HD_FREQ                  HDL_PARAMETER false

proc elaboration_callback {} {
    set video_std [get_parameter_value VIDEO_STANDARD]
    set xcvr_tx_pll_sel  [get_parameter_value XCVR_TX_PLL_SEL]
    set pll_switch       [get_parameter_value ED_TXPLL_SWITCH]
    set family           [get_parameter_value FAMILY]

    common_add_clock                ref_clk        input   true
    common_add_clock                tx_clkout      input   true

    if { $family == "Arria 10" } {
       add_interface sdi_serial conduit input
       set_interface_property sdi_serial ENABLED true
       add_interface_port sdi_serial sdi_serial tx_serial_data input 1

       add_interface sdi_serial_b conduit input
       set_interface_property sdi_serial_b ENABLED true
       add_interface_port sdi_serial_b sdi_serial_b tx_serial_data input 1
    } else {
       common_add_optional_conduit   sdi_serial     export  input 1 true
       common_add_optional_conduit   sdi_serial_b   export  input 1 true
    }

    common_add_optional_conduit     tx_clkout_match    export  output 1 true
    common_add_optional_conduit     tx_status          export  input  1 true
    common_add_optional_conduit     chk_tx             export  input  2 true
    common_add_optional_conduit     tx_std             export  input  3 true

    if { $xcvr_tx_pll_sel == "0" & $pll_switch == "0" } {
       terminate_port     tx_clkout          input
       terminate_port     tx_clkout_match    output
    }

    if { $video_std != "dl" } {
       terminate_port     sdi_serial_b       input
    }

}

