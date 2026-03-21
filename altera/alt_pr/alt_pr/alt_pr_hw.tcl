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


# (C) 2001-2013 Altera Corporation. All rights reserved.
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

# +-----------------------------------
# | 
# | $Header: //acds/rel/18.1std/ip/alt_pr/alt_pr/alt_pr_hw.tcl#1 $
# | 
# +-----------------------------------

# request TCL package
package require -exact qsys 12.1

# Source files
source ./alt_pr_hw_proc.tcl

# +-----------------------------------
# | module Partial Reconfiguration
# +-----------------------------------
set_module_property NAME alt_pr
set_module_property VERSION 18.1
set_module_property DISPLAY_NAME "Partial Reconfiguration Intel FPGA IP"
set_module_property DESCRIPTION "Partial Reconfiguration megafunction is used to reconfigure part of your design while the rest \
									of your design continues to run."
set_module_property GROUP "Basic Functions/Configuration and Programming"
set_module_property INTERNAL false
set_module_property AUTHOR "Altera Corporation"
set_module_property DATASHEET_URL "http://www.altera.com/literature/ug/ug_partrecon.pdf"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_SOPC true
set_module_property SUPPORTED_DEVICE_FAMILIES {{ALL}}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/mwh1393631425397/mwh1393631402541
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697985505/en-us

add_display_item "" "Settings" GROUP
add_display_item "" "General" GROUP
add_display_item "" "Advanced Settings" GROUP

# +-----------------------------------
# | Parameters - Settings tab
# +-----------------------------------

# select Internal Host or External Host
add_parameter PR_INTERNAL_HOST boolean 1
set_parameter_property PR_INTERNAL_HOST DEFAULT_VALUE 1
set_parameter_property PR_INTERNAL_HOST DISPLAY_NAME "Use as PR Internal Host"
set_parameter_property PR_INTERNAL_HOST DESCRIPTION "Enable this option to use the PR megafunction as an Internal Host (i.e. both prblock and crcblock WYSIWYG are auto-instantiated as part of your design). Disable this option to use the PR megafunction as an External Host. You must connect additional interface signals to the dedicated PR pins or the external prblock and crcblock WYSIWYG interface signals if the PR megafunction is used as an External Host."
set_parameter_property PR_INTERNAL_HOST UNITS None
set_parameter_property PR_INTERNAL_HOST AFFECTS_GENERATION true
set_parameter_property PR_INTERNAL_HOST AFFECTS_ELABORATION true
set_parameter_property PR_INTERNAL_HOST HDL_PARAMETER true
set_parameter_property PR_INTERNAL_HOST ENABLED true
add_display_item "Settings" PR_INTERNAL_HOST parameter

# select JTAG debug mode
add_parameter ENABLE_JTAG boolean 1
set_parameter_property ENABLE_JTAG DEFAULT_VALUE 1
set_parameter_property ENABLE_JTAG DISPLAY_NAME "Enable JTAG debug mode"
set_parameter_property ENABLE_JTAG DESCRIPTION "Enable this option to access the PR megafunction with the Programmer tool to perform Partial Reconfiguration."
set_parameter_property ENABLE_JTAG UNITS None
set_parameter_property ENABLE_JTAG AFFECTS_GENERATION true
set_parameter_property ENABLE_JTAG AFFECTS_ELABORATION true
set_parameter_property ENABLE_JTAG HDL_PARAMETER true
set_parameter_property ENABLE_JTAG ENABLED true
add_display_item "Settings" ENABLE_JTAG parameter

# select Avalon-MM slave interface or Conduit interface
add_parameter ENABLE_AVMM_SLAVE boolean 1
set_parameter_property ENABLE_AVMM_SLAVE DEFAULT_VALUE 0
set_parameter_property ENABLE_AVMM_SLAVE DISPLAY_NAME "Enable Avalon-MM slave interface"
set_parameter_property ENABLE_AVMM_SLAVE DESCRIPTION "Enable this option to use Avalon-MM slave interface."
set_parameter_property ENABLE_AVMM_SLAVE UNITS None
set_parameter_property ENABLE_AVMM_SLAVE AFFECTS_GENERATION true
set_parameter_property ENABLE_AVMM_SLAVE AFFECTS_ELABORATION true
set_parameter_property ENABLE_AVMM_SLAVE HDL_PARAMETER true
set_parameter_property ENABLE_AVMM_SLAVE ENABLED true
add_display_item "Settings" ENABLE_AVMM_SLAVE parameter

add_parameter ENABLE_INTERRUPT boolean false
set_parameter_property ENABLE_INTERRUPT DISPLAY_NAME "Enable interrupt interface"
set_parameter_property ENABLE_INTERRUPT DESCRIPTION "This can only be used together with the Avalon-MM slave interface. Interrupt is asserted when there is an incompatible bitstream, CRC_ERROR, PR_ERROR or a successful PR operation. When that happens, query PR_CSR\[4:2\] for its status. After that, write a 1 to PR_CSR\[5\] to clear the interrupt."
set_parameter_property ENABLE_INTERRUPT HDL_PARAMETER true
add_display_item "Settings" ENABLE_INTERRUPT parameter

# select bitstream compatibility check
add_parameter ENABLE_PRPOF_ID_CHECK_UI boolean 1
set_parameter_property ENABLE_PRPOF_ID_CHECK_UI DEFAULT_VALUE 0
set_parameter_property ENABLE_PRPOF_ID_CHECK_UI DISPLAY_NAME "Enable bitstream compatibility check"
set_parameter_property ENABLE_PRPOF_ID_CHECK_UI DESCRIPTION "Enable this option to check the bitstream compatibility during PR operation for External Host. The bitstream compatibility check feature is always enabled for PR Internal Host. The PR bitstream ID value must be specified if this option is enabled for PR External Host."
set_parameter_property ENABLE_PRPOF_ID_CHECK_UI UNITS None
set_parameter_property ENABLE_PRPOF_ID_CHECK_UI AFFECTS_GENERATION true
set_parameter_property ENABLE_PRPOF_ID_CHECK_UI AFFECTS_ELABORATION true
set_parameter_property ENABLE_PRPOF_ID_CHECK_UI HDL_PARAMETER false
add_display_item "Settings" ENABLE_PRPOF_ID_CHECK_UI parameter

# select derived bitstream compatibility check
add_parameter ENABLE_PRPOF_ID_CHECK boolean 1
set_parameter_property ENABLE_PRPOF_ID_CHECK DEFAULT_VALUE 0
set_parameter_property ENABLE_PRPOF_ID_CHECK UNITS None
set_parameter_property ENABLE_PRPOF_ID_CHECK AFFECTS_GENERATION true
set_parameter_property ENABLE_PRPOF_ID_CHECK AFFECTS_ELABORATION true
set_parameter_property ENABLE_PRPOF_ID_CHECK HDL_PARAMETER true
set_parameter_property ENABLE_PRPOF_ID_CHECK VISIBLE false
set_parameter_property ENABLE_PRPOF_ID_CHECK DERIVED true

# select pr bitstream id for external host
add_parameter EXT_HOST_PRPOF_ID INTEGER
set_parameter_property EXT_HOST_PRPOF_ID DEFAULT_VALUE 0
set_parameter_property EXT_HOST_PRPOF_ID DISPLAY_NAME "PR bitstream ID"
set_parameter_property EXT_HOST_PRPOF_ID DESCRIPTION "Specifies a signed 32-bit integer value of the PR bitstream ID for External Host. This value must match with the PR bitstream ID generated for the target PR design during compilation. The PR bitstream ID value of the target PR design can be found in the Assembler compilation report (.asm.rpt)."
set_parameter_property EXT_HOST_PRPOF_ID TYPE INTEGER
set_parameter_property EXT_HOST_PRPOF_ID UNITS None
set_parameter_property EXT_HOST_PRPOF_ID AFFECTS_GENERATION true
set_parameter_property EXT_HOST_PRPOF_ID AFFECTS_ELABORATION true
set_parameter_property EXT_HOST_PRPOF_ID HDL_PARAMETER true
add_display_item "Settings" EXT_HOST_PRPOF_ID parameter 

# select target device family for PR when External Host is enabled
add_parameter EXT_HOST_TARGET_DEVICE_FAMILY STRING "Stratix V"
set_parameter_property EXT_HOST_TARGET_DEVICE_FAMILY DEFAULT_VALUE "Stratix V"
set_parameter_property EXT_HOST_TARGET_DEVICE_FAMILY DISPLAY_NAME "Target device family for partial reconfiguration"
set_parameter_property EXT_HOST_TARGET_DEVICE_FAMILY DESCRIPTION "Select the target device family for partial reconfiguration when the PR megafunction is used as External Host. This option is ignored for PR Internal Host."
set_parameter_property EXT_HOST_TARGET_DEVICE_FAMILY UNITS None
set_parameter_property EXT_HOST_TARGET_DEVICE_FAMILY AFFECTS_GENERATION true
set_parameter_property EXT_HOST_TARGET_DEVICE_FAMILY AFFECTS_ELABORATION true
set_parameter_property EXT_HOST_TARGET_DEVICE_FAMILY HDL_PARAMETER true
set_parameter_property EXT_HOST_TARGET_DEVICE_FAMILY ALLOWED_RANGES {"Stratix V" "Arria V" "Arria V GZ" "Cyclone V" "Arria 10"}
add_display_item "Settings" EXT_HOST_TARGET_DEVICE_FAMILY parameter

# select input data width
add_parameter DATA_WIDTH_INDEX INTEGER
set_parameter_property DATA_WIDTH_INDEX DEFAULT_VALUE 16
set_parameter_property DATA_WIDTH_INDEX DISPLAY_NAME "Input data width"
set_parameter_property DATA_WIDTH_INDEX DESCRIPTION "Size of the data conduit interface in bits."
set_parameter_property DATA_WIDTH_INDEX TYPE INTEGER
set_parameter_property DATA_WIDTH_INDEX UNITS BITS
set_parameter_property DATA_WIDTH_INDEX AFFECTS_GENERATION true
set_parameter_property DATA_WIDTH_INDEX AFFECTS_ELABORATION true
set_parameter_property DATA_WIDTH_INDEX HDL_PARAMETER true
set_parameter_property DATA_WIDTH_INDEX ALLOWED_RANGES {1 8 16 32}
set_parameter_property DATA_WIDTH_INDEX ENABLED true
add_display_item "Settings" DATA_WIDTH_INDEX parameter 

# set derived control block data width
add_parameter CB_DATA_WIDTH INTEGER
set_parameter_property CB_DATA_WIDTH DEFAULT_VALUE 16
set_parameter_property CB_DATA_WIDTH TYPE INTEGER
set_parameter_property CB_DATA_WIDTH UNITS BITS
set_parameter_property CB_DATA_WIDTH AFFECTS_GENERATION true
set_parameter_property CB_DATA_WIDTH AFFECTS_ELABORATION true
set_parameter_property CB_DATA_WIDTH HDL_PARAMETER true
set_parameter_property CB_DATA_WIDTH ALLOWED_RANGES {1 8 16 32}
set_parameter_property CB_DATA_WIDTH VISIBLE false
set_parameter_property CB_DATA_WIDTH DERIVED true

add_parameter ENABLE_DATA_PACKING boolean true
set_parameter_property ENABLE_DATA_PACKING DERIVED true
set_parameter_property ENABLE_DATA_PACKING HDL_PARAMETER true
set_parameter_property ENABLE_DATA_PACKING VISIBLE false

# select CDRATIO
add_parameter CDRATIO INTEGER
set_parameter_property CDRATIO DEFAULT_VALUE 1
set_parameter_property CDRATIO DISPLAY_NAME "Clock-to-Data ratio"
set_parameter_property CDRATIO DESCRIPTION "Select Clock-to-Data ratio according to PR data format (plain, encrypted ot compressed)."
set_parameter_property CDRATIO TYPE INTEGER
set_parameter_property CDRATIO UNITS None
set_parameter_property CDRATIO AFFECTS_GENERATION true
set_parameter_property CDRATIO AFFECTS_ELABORATION true
set_parameter_property CDRATIO HDL_PARAMETER true
set_parameter_property CDRATIO ALLOWED_RANGES {1 2 4}
set_parameter_property CDRATIO ENABLED true
add_display_item "Settings" CDRATIO parameter 

add_display_item "Settings" CDRATIO_INFORMATION TEXT ""

# select edcrc osc divider
add_parameter EDCRC_OSC_DIVIDER INTEGER
set_parameter_property EDCRC_OSC_DIVIDER DEFAULT_VALUE 1
set_parameter_property EDCRC_OSC_DIVIDER DISPLAY_NAME "Divide error detection frequency by"
set_parameter_property EDCRC_OSC_DIVIDER DESCRIPTION "Specifies the divide value of the internal clock, which determines the frequency of the error detection CRC. The divide value must be a power of two. Refer to the device handbook to find the frequency of the internal clock for the selected device."
set_parameter_property EDCRC_OSC_DIVIDER TYPE INTEGER
set_parameter_property EDCRC_OSC_DIVIDER UNITS None
set_parameter_property EDCRC_OSC_DIVIDER AFFECTS_GENERATION true
set_parameter_property EDCRC_OSC_DIVIDER AFFECTS_ELABORATION true
set_parameter_property EDCRC_OSC_DIVIDER HDL_PARAMETER true
set_parameter_property EDCRC_OSC_DIVIDER ALLOWED_RANGES {1 2 4 8 16 32 64 128 256}
add_display_item "Settings" EDCRC_OSC_DIVIDER parameter 

add_parameter ENABLE_ENHANCED_DECOMPRESSION boolean false
set_parameter_property ENABLE_ENHANCED_DECOMPRESSION DISPLAY_NAME "Enable enhanced decompression"
set_parameter_property ENABLE_ENHANCED_DECOMPRESSION DESCRIPTION "Check this if you want to apply enhanced decompression on your PR bitstreams."
set_parameter_property ENABLE_ENHANCED_DECOMPRESSION HDL_PARAMETER true
add_display_item "Settings" ENABLE_ENHANCED_DECOMPRESSION parameter

add_parameter INSTANTIATE_PR_BLOCK boolean true
set_parameter_property INSTANTIATE_PR_BLOCK DISPLAY_NAME "Auto-instantiate PR block"
set_parameter_property INSTANTIATE_PR_BLOCK DESCRIPTION "Set this to true (default) to have the PR block automatically instantiated within this PR IP. If you are using this PR IP as an internal host, and wish to share the PR block with other IPs, set this to false; do instantiate the PR block on your own, and connect the relevant signals to this PR IP."
set_parameter_property INSTANTIATE_PR_BLOCK HDL_PARAMETER true
add_display_item "Advanced Settings" INSTANTIATE_PR_BLOCK parameter

add_parameter INSTANTIATE_CRC_BLOCK boolean true
set_parameter_property INSTANTIATE_CRC_BLOCK DISPLAY_NAME "Auto-instantiate CRC block"
set_parameter_property INSTANTIATE_CRC_BLOCK DESCRIPTION "Set this to true (default) to have the CRC block automatically instantiated within this PR IP. If you are using this PR IP as an internal host, and wish to share the CRC block with other IPs, set this to false; do instantiate the CRC block on your own, and connect the relevant signals to this PR IP."
set_parameter_property INSTANTIATE_CRC_BLOCK HDL_PARAMETER true
add_display_item "Advanced Settings" INSTANTIATE_CRC_BLOCK parameter

# +-----------------------------------
# | Parameters - General tab
# +-----------------------------------
add_display_item "General" "Information1" TEXT "The input clk signal should be constrained by the user with a maximum frequency of 100MHz."
add_display_item "General" "Information2" TEXT "The same clk frequency is applied to PR_CLK signal during Partial Reconfiguration operation."
add_display_item "General" "Information3" TEXT "User must supply the input clk signal to meet the device PR_CLK Fmax specification."

add_parameter DEVICE_FAMILY STRING
set_parameter_property DEVICE_FAMILY VISIBLE false
set_parameter_property DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property DEVICE_FAMILY HDL_PARAMETER true

add_parameter GENERATE_SDC boolean true
set_parameter_property GENERATE_SDC VISIBLE false
set_parameter_property GENERATE_SDC DISPLAY_NAME "Generate timing constraints file"
set_parameter_property GENERATE_SDC DESCRIPTION "Set this to true (default) to generate the SDC timing constraints file required to constrain this IP. If you have the required timing constraints in another SDC file, this option can be set to false to supress generation of the SDC file"
add_display_item "Advanced Settings" GENERATE_SDC parameter



set_module_property ELABORATION_CALLBACK elaboration_callback

# +-----------------------------------
# | Fileset Callbacks
# +----------------------------------- 
add_fileset quartus_synth QUARTUS_SYNTH generate_synth
set_fileset_property quartus_synth TOP_LEVEL alt_pr

add_fileset sim_vhdl SIM_VHDL generate_sim
set_fileset_property sim_vhdl TOP_LEVEL alt_pr

add_fileset sim_verilog SIM_VERILOG generate_sim
set_fileset_property sim_verilog TOP_LEVEL alt_pr




