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


package require -exact qsys 16.0

# create the system
create_system avalon_st_multiplexer
set_project_property DEVICE_FAMILY {Arria 10}
set_project_property DEVICE {10AX115S2F45I2SGE2}
set_project_property HIDE_FROM_IP_CATALOG {false}

set_use_testbench_naming_pattern 0 {}
set_interconnect_requirement {$system} qsys_mm.clockCrossingAdapter {HANDSHAKE}
set_interconnect_requirement {$system} qsys_mm.enableEccProtection {FALSE}
set_interconnect_requirement {$system} qsys_mm.insertDefaultSlave {FALSE}
set_interconnect_requirement {$system} qsys_mm.maxAdditionalLatency {1}

# add the instances
add_instance avalon_st_multiplexer_0 multiplexer
set_instance_parameter_value avalon_st_multiplexer_0 bitsPerSymbol {72}
set_instance_parameter_value avalon_st_multiplexer_0 errorWidth {0}
set_instance_parameter_value avalon_st_multiplexer_0 numInputInterfaces {2}
set_instance_parameter_value avalon_st_multiplexer_0 outChannelWidth {1}
set_instance_parameter_value avalon_st_multiplexer_0 packetScheduling {1}
set_instance_parameter_value avalon_st_multiplexer_0 schedulingSize {2}
set_instance_parameter_value avalon_st_multiplexer_0 symbolsPerBeat {1}
set_instance_parameter_value avalon_st_multiplexer_0 useHighBitsOfChannel {0}
set_instance_parameter_value avalon_st_multiplexer_0 usePackets {1}

add_interface clk clock INPUT
add_interface in0 avalon_streaming INPUT
add_interface in1 avalon_streaming INPUT
add_interface out avalon_streaming OUTPUT
add_interface reset reset INPUT


# add the exports
set_interface_property clk EXPORT_OF avalon_st_multiplexer_0.clk
set_interface_property multiplexer_in0 EXPORT_OF avalon_st_multiplexer_0.in0
set_interface_property multiplexer_in1 EXPORT_OF avalon_st_multiplexer_0.in1
set_interface_property multiplexer_out EXPORT_OF avalon_st_multiplexer_0.out
set_interface_property reset EXPORT_OF avalon_st_multiplexer_0.reset


# save the system
save_system avalon_st_multiplexer.qsys
