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


# 
# request TCL package from ACDS 12.1
# 
package require -exact qsys 12.1



# 
# module hps_virt_clk
# 
# This module represents an external clock input to 
# the hps. This is a virtual clock in the sense
# that no rtl is generated for the clock
#
set_module_property NAME hps_virt_clk
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property DISPLAY_NAME "HPS Virtual Clock"
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property elaboration_callback elaborate

set_module_assignment embeddedsw.dts.compatible {fixed-clock}
set_module_assignment embeddedsw.dts.group clock
set_module_assignment embeddedsw.dts.vendor altr

add_parameter clockFrequency long 0
set_parameter_property clockFrequency affects_elaboration true

# 
# file sets
# 

# 
# parameters
# 

# 
# display items
# 

# connection point reset_sink
# 
add_interface clk_reset reset start
set_interface_property clk_reset associatedClock clk
set_interface_property clk_reset synchronousEdges DEASSERT
set_interface_property clk_reset ENABLED true

add_interface_port clk_reset new_signal_13 reset output 1


# 
# connection point clock_sink
# 
add_interface clk clock start
set_interface_property clk clockRate 0
set_interface_property clk ENABLED true

add_interface_port clk new_signal_14 clk output 1

proc elaborate {} {
	set_interface_property clk clockRate [get_parameter_value clockFrequency]
}
