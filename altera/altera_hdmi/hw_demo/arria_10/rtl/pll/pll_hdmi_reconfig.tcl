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


# qsys scripting (.tcl) file for pll_hdmi_reconfig
package require -exact qsys 16.0

create_system {pll_hdmi_reconfig}

set_project_property DEVICE_FAMILY {Arria 10}
set_project_property DEVICE {10AX115S2F45I2SGE2}
set_project_property HIDE_FROM_IP_CATALOG {true}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance pll_reconfig_0 altera_pll_reconfig 
set_instance_parameter_value pll_reconfig_0 {ENABLE_MIF} {0}
set_instance_parameter_value pll_reconfig_0 {MIF_FILE_NAME} {}
set_instance_parameter_value pll_reconfig_0 {ENABLE_BYTEENABLE} {0}

# exported interfaces
set_instance_property pll_reconfig_0 AUTO_EXPORT {true}

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}

save_system {pll_hdmi_reconfig.qsys}
