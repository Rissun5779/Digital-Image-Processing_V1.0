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


# qsys scripting (.tcl) file for edid_ram
package require -exact qsys 16.0

create_system {edid_ram}

set_project_property DEVICE_FAMILY {Arria 10}
set_project_property DEVICE {10AX115S2F45I2SGE2}
set_project_property HIDE_FROM_IP_CATALOG {true}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance ram_1port_0 ram_1port 
set_instance_parameter_value ram_1port_0 {GUI_RegData} {1}
set_instance_parameter_value ram_1port_0 {GUI_RegAddr} {1}
set_instance_parameter_value ram_1port_0 {GUI_RegOutput} {1}
set_instance_parameter_value ram_1port_0 {GUI_Clken} {0}
set_instance_parameter_value ram_1port_0 {GUI_CLOCK_ENABLE_INPUT_A} {0}
set_instance_parameter_value ram_1port_0 {GUI_CLOCK_ENABLE_OUTPUT_A} {0}
set_instance_parameter_value ram_1port_0 {GUI_ADDRESSSTALL_A} {0}
set_instance_parameter_value ram_1port_0 {GUI_BYTE_ENABLE} {0}
set_instance_parameter_value ram_1port_0 {GUI_AclrData} {0}
set_instance_parameter_value ram_1port_0 {GUI_WRCONTROL_ACLR_A} {0}
set_instance_parameter_value ram_1port_0 {GUI_AclrAddr} {0}
set_instance_parameter_value ram_1port_0 {GUI_AclrOutput} {0}
set_instance_parameter_value ram_1port_0 {GUI_AclrByte} {0}
set_instance_parameter_value ram_1port_0 {GUI_SclrOutput} {0}
set_instance_parameter_value ram_1port_0 {GUI_rden} {1}
set_instance_parameter_value ram_1port_0 {GUI_X_MASK} {1}
set_instance_parameter_value ram_1port_0 {GUI_INIT_TO_SIM_X} {0}
set_instance_parameter_value ram_1port_0 {GUI_JTAG_ENABLED} {1}
set_instance_parameter_value ram_1port_0 {GUI_JTAG_ID} {HDMI}
set_instance_parameter_value ram_1port_0 {GUI_INIT_FILE_LAYOUT} {PORT_A}
set_instance_parameter_value ram_1port_0 {GUI_TBENCH} {0}
set_instance_parameter_value ram_1port_0 {GUI_FORCE_TO_ZERO} {0}
set_instance_parameter_value ram_1port_0 {GUI_WIDTH_A} {8}
set_instance_parameter_value ram_1port_0 {GUI_NUMWORDS_A} {256}
set_instance_parameter_value ram_1port_0 {GUI_MAXIMUM_DEPTH} {0}
set_instance_parameter_value ram_1port_0 {GUI_BYTE_SIZE} {8}
set_instance_parameter_value ram_1port_0 {GUI_READ_DURING_WRITE_MODE_PORT_A} {1}
set_instance_parameter_value ram_1port_0 {GUI_RAM_BLOCK_TYPE} {Auto}
set_instance_parameter_value ram_1port_0 {GUI_IMPLEMENT_IN_LES} {0}
set_instance_parameter_value ram_1port_0 {GUI_SingleClock} {0}
set_instance_parameter_value ram_1port_0 {GUI_BlankMemory} {1}
set_instance_parameter_value ram_1port_0 {GUI_FILE_REFERENCE} {0}
set_instance_parameter_value ram_1port_0 {GUI_MIFfilename} {../../../Panasonic.hex}

# exported interfaces
set_instance_property ram_1port_0 AUTO_EXPORT {true}

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}

save_system {edid_ram.qsys}
