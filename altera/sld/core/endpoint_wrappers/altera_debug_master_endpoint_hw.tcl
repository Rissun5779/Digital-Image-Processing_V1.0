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


# (C) 2001-2014 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.

# 
# altera_debug_master_endpoint "altera_debug_master_endpoint" v1.0
# 

# request TCL package from ACDS 13.0
# 
package require -exact qsys 13.0

# 
# module altera_debug_master_endpoint
# 
set_module_property NAME altera_debug_master_endpoint
set_module_property AUTHOR "Altera Corporation"
set_module_property GROUP "Verification/Debug & Performance"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property DISPLAY_NAME altera_debug_master_endpoint
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ANALYZE_HDL false
set_module_property REPORT_TO_TALKBACK true
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property ELABORATION_CALLBACK elaborate
set_module_assignment debug.virtualInterface.link {debug.fabricLink {fabric mapped} }
set_module_assignment debug.isTransparent true

# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altera_debug_master_endpoint_wrapper
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file altera_debug_master_endpoint_wrapper.sv system_verilog path altera_debug_master_endpoint_wrapper.sv

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL altera_debug_master_endpoint_wrapper
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file altera_debug_master_endpoint_wrapper.sv system_verilog path altera_debug_master_endpoint_wrapper.sv


# 
# parameters
# 
add_parameter ADDR_WIDTH INTEGER 10
set_parameter_property ADDR_WIDTH ALLOWED_RANGES {1:20}
set_parameter_property ADDR_WIDTH AFFECTS_ELABORATION true
set_parameter_property ADDR_WIDTH AFFECTS_GENERATION false
set_parameter_property ADDR_WIDTH HDL_PARAMETER true

add_parameter DATA_WIDTH INTEGER 32
set_parameter_property DATA_WIDTH ALLOWED_RANGES 32
set_parameter_property DATA_WIDTH VISIBLE false
set_parameter_property DATA_WIDTH AFFECTS_ELABORATION true
set_parameter_property DATA_WIDTH AFFECTS_GENERATION false
set_parameter_property DATA_WIDTH HDL_PARAMETER true

add_parameter HAS_RDV INTEGER 1
set_parameter_property HAS_RDV ALLOWED_RANGES {0 1}
set_parameter_property HAS_RDV AFFECTS_ELABORATION true
set_parameter_property HAS_RDV AFFECTS_GENERATION false
set_parameter_property HAS_RDV HDL_PARAMETER true

add_parameter PREFER_HOST STRING {}
set_parameter_property PREFER_HOST AFFECTS_ELABORATION false
set_parameter_property PREFER_HOST AFFECTS_GENERATION false
set_parameter_property PREFER_HOST HDL_PARAMETER true

add_parameter CLOCK_RATE_CLK INTEGER 0
set_parameter_property CLOCK_RATE_CLK SYSTEM_INFO {CLOCK_RATE clk}
set_parameter_property CLOCK_RATE_CLK AFFECTS_ELABORATION false
set_parameter_property CLOCK_RATE_CLK AFFECTS_GENERATION false
set_parameter_property CLOCK_RATE_CLK HDL_PARAMETER true


# 
# display items
# 

#
# connection point clk
#
add_interface clk clock end
set_interface_property clk ENABLED true
add_interface_port clk clk clk Input 1


#
# connection point reset
#
add_interface reset reset end
set_interface_property reset associatedClock clk
set_interface_property reset ENABLED true
add_interface_port reset reset reset Input 1


#
# connection point master
#
add_interface master avalon start
set_interface_property master addressUnits WORDS
set_interface_property master associatedClock clk
set_interface_property master associatedReset reset
set_interface_property master ENABLED true
set_interface_assignment master debug.controlledBy {link}
add_interface_port master master_write write Output 1
add_interface_port master master_read read Output 1
add_interface_port master master_address address Output ADDR_WIDTH
add_interface_port master master_writedata writedata Output DATA_WIDTH
add_interface_port master master_waitrequest waitrequest Input 1
add_interface_port master master_readdatavalid readdatavalid Input 1
set_port_property master_readdatavalid termination true
add_interface_port master master_readdata readdata Input DATA_WIDTH


#
# Elaboration callback
#
proc elaborate {} {
    set HAS_RDV [get_parameter_value HAS_RDV]

    if {$HAS_RDV == 0} {
        set_interface_property master maximumPendingReadTransactions 0
    }

    if {$HAS_RDV != 0} {
        set_interface_property master maximumPendingReadTransactions 1
        set_port_property master_readdatavalid termination false
    }
}

proc log2 x {expr {int(ceil(log($x) / log(2)))}}
