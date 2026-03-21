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

set_module_property NAME seriallite_iii_sv
set_module_property VERSION 18.1
set_module_property AUTHOR "Altera Corporation"

#set_module_property INTERNAL true
set_module_property DESCRIPTION "seriallite_iii_sv_top"
set_module_property GROUP "Interface Protocols/SerialLite"
set_module_property DISPLAY_NAME "Serial Lite III Streaming Intel FPGA IP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ELABORATION_CALLBACK elaboration_callback
set_module_property VALIDATION_CALLBACK validation_callback
set_module_property SUPPORTED_DEVICE_FAMILIES {{StratixV} {Arria V GZ}}
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property HIDE_FROM_QSYS true

add_parameter gui_pll_ref_freq STRING "644.53125"
add_parameter lane_rate_parameter STRING "9375 Mbps"
add_parameter gui_xcvr_data_rate STRING "10.312500"
set_parameter_property gui_xcvr_data_rate DESCRIPTION "The user specifies the data rate desired for transceiver. This transceiver data rate in turn determines the required user clock frequency to support the calculated transmit and receive bandwidths.<br><br> Supports a wide range of data rates: from 3 Gbps to 14.1 Gbps (Stratix V) and 12.5 Gbps (Arria V GZ)"
set_parameter_property lane_rate_parameter DESCRIPTION "Supports a wide range of data rates: from 3 Gbps to 14.1 Gbps (Stratix V) and 12.5 Gbps (Arria V GZ)"
set_parameter_property gui_pll_ref_freq DESCRIPTION "Supports multiple transceiver reference clock frequencies for flexibility in oscillator and PLL choices. This transceiver reference clock frequency must match the external PLL reference clock frequency"

source seriallite_iii.tcl
set_parameter_property speedgrade VISIBLE true
set_parameter_property speedgrade ENABLED true

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/bhc1411113020049/bhc1411112778182
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697961295
add_documentation_link "Example Design User Guide" https://www.altera.com/documentation/ylx1497333748890.html

