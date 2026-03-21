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


package require -exact qsys 13.0
source hps_utils.tcl

#
# module axi_ocram
#
hps_utils_add_component_boiler_plate arria10_axi_ocram {HPS On Chip RAM}
#
# file sets
#
#
# parameters
#

set_module_assignment embeddedsw.dts.group memory
set_module_assignment embeddedsw.dts.name ocram
set_module_assignment embeddedsw.dts.vendor altr
# 
# display items
# 


hps_utils_add_clock_reset

#
# Interrupt sender
#

# 
# connection point altera_axi_slave
# 
hps_utils_add_axi_slave axi_slave0 axi_sig0 16
