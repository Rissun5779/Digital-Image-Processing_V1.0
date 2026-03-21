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


#|
#| altera_interlaken 50G
#|
#+-----------------------------

# +-----------------------------------
# | request TCL package from ACDS 13.0
# | 
lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/alt_xcvr_tcl_packages
lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_interlaken_hp


package require -exact qsys 13.0
package require altera_terp 1.0

package require alt_xcvr::utils::fileset
package require alt_xcvr::utils::device
package require alt_xcvr::utils::ipgen
package require alt_xcvr::ip_tcl::ip_module

namespace import ::alt_xcvr::utils::ipgen::*
namespace import ::alt_xcvr::utils::fileset::*
namespace import ::alt_xcvr::utils::device::*
namespace import ::alt_xcvr::ip_tcl::ip_module::*
# | 
# +-----------------------------------

# +-----------------------------------
# | module interlaken_50G_8lane_6G
# | 
send_message PROGRESS "reading tcl" 

set_module_property NAME ilk_core_50g
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property DISPLAY_NAME "50G Interlaken"
set_module_property EDITABLE false
# set_module_property ANALYZE_HDL false
set_module_property GROUP "Interface Protocols/Interlaken"
set_module_property AUTHOR "Intel Corporation"
set_module_property DESCRIPTION "Intel Interlaken"
# set_module_property DATASHEET_URL "http://www.altera.com/literature/ug/ug_50g_interlaken.pdf"
set_module_property HIDE_FROM_QSYS true
set_module_property supported_device_families {{Stratix V} {Arria V GZ} {Arria 10}}



add_fileset synth QUARTUS_SYNTH synth_proc
#set_fileset_property synth TOP_LEVEL ilk_core_50g

set_module_property ELABORATION_CALLBACK elaborate
set_module_property VALIDATION_CALLBACK validate_proc

# # Add fileset for simulation  
add_fileset simulation_verilog SIM_VERILOG sim_ver
#set_fileset_property simulation_verilog TOP_LEVEL ilk_core_50g

# # Add fileset for example_design
add_fileset example_design EXAMPLE_DESIGN example_design_ver
# set_fileset_property example_design TOP_LEVEL top
# add_fileset testbench EXAMPLE_DESIGN testbench_ver
# set_fileset_property testbench TOP_LEVEL top

# #upgrade 
set_module_property PARAMETER_UPGRADE_CALLBACK upgrade_proc
# | 
# +-----------------------------------

#+-----------------------------------
# #| display tabs
# #| 
# add_display_item "" "General" GROUP
# add_display_item "" "PCS" GROUP
# add_display_item "" "Block Diagram" GROUP

# # #############################################################################
# # Add tabs 
# # #############################################################################
add_display_item "" {IP} GROUP tab

add_display_item "IP" {General} GROUP
add_display_item "IP" {In-Band Flow Control} GROUP
add_display_item "IP" {Scrambler} GROUP
add_display_item "IP" {User Data Transfer Interface} GROUP
# add_display_item {General} RXFIFO_ADDR_WIDTH PARAMETER
# add_display_item {General} OPERATIONAL_MODE PARAMETER

add_display_item "" {Example Design} GROUP tab

add_display_item "Example Design" {Available Example Design} GROUP
add_display_item "Example Design" {Example Design Files} GROUP
add_display_item "Example Design" {Generated HDL Format} GROUP
add_display_item "Example Design" {Target Development Kit} GROUP

#+-----------------------------------
#| parameters
#|

add_parameter DEVICE_FAMILY STRING
set_parameter_property DEVICE_FAMILY DISPLAY_NAME "Device family"
set_parameter_property DEVICE_FAMILY SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property DEVICE_FAMILY ALLOWED_RANGES {"Stratix V" "Arria V GZ" "Arria 10"}
set_parameter_property DEVICE_FAMILY DESCRIPTION "Supports Stratix V, Arria V GZ and  Arria 10 devices."
set_parameter_property DEVICE_FAMILY HDL_PARAMETER false
set_parameter_property DEVICE_FAMILY ENABLED false
add_display_item "General" DEVICE_FAMILY parameter

add_parameter DEVICE STRING
set_parameter_property DEVICE SYSTEM_INFO {DEVICE}
set_parameter_property DEVICE VISIBLE false
# FAMILY 
add_parameter FAMILY STRING
set_parameter_property FAMILY DEFAULT_VALUE "Stratix V"
set_parameter_property FAMILY DISPLAY_NAME "family"
set_parameter_property FAMILY ALLOWED_RANGES  {"Stratix V" "Arria V GZ" "Arria 10"}
set_parameter_property FAMILY DISPLAY_HINT ""
set_parameter_property FAMILY AFFECTS_ELABORATION true
set_parameter_property FAMILY AFFECTS_GENERATION true
set_parameter_property FAMILY DESCRIPTION "Specifies family type"
set_parameter_property FAMILY VISIBLE false
set_parameter_property FAMILY DERIVED true
set_parameter_property FAMILY HDL_PARAMETER true
add_display_item "General" FAMILY parameter

add_parameter OPERATIONAL_MODE INTEGER 0 Duplex
set_parameter_property OPERATIONAL_MODE DISPLAY_NAME "Operational mode"
set_parameter_property OPERATIONAL_MODE ALLOWED_RANGES {0:Duplex }
set_parameter_property OPERATIONAL_MODE DISPLAY_HINT "string"
set_parameter_property OPERATIONAL_MODE DESCRIPTION "Only duplex mode is supported"
set_parameter_property OPERATIONAL_MODE AFFECTS_ELABORATION true
set_parameter_property OPERATIONAL_MODE HDL_PARAMETER false
set_parameter_property OPERATIONAL_MODE ENABLED false
set_parameter_property OPERATIONAL_MODE VISIBLE false
add_display_item "General" OPERATIONAL_MODE parameter

# # RXFIFO_ADDR_WIDTH, HDL parameter, 11
add_parameter RXFIFO_ADDR_WIDTH INTEGER 12
set_parameter_property RXFIFO_ADDR_WIDTH DEFAULT_VALUE 12
set_parameter_property RXFIFO_ADDR_WIDTH DISPLAY_NAME "RX FIFO address width"
set_parameter_property RXFIFO_ADDR_WIDTH ALLOWED_RANGES {11 12}
set_parameter_property RXFIFO_ADDR_WIDTH DISPLAY_HINT ""
set_parameter_property RXFIFO_ADDR_WIDTH AFFECTS_ELABORATION true
set_parameter_property RXFIFO_ADDR_WIDTH AFFECTS_GENERATION true
set_parameter_property RXFIFO_ADDR_WIDTH HDL_PARAMETER true
set_parameter_property RXFIFO_ADDR_WIDTH VISIBLE false
set_parameter_property RXFIFO_ADDR_WIDTH DESCRIPTION "Receiver FIFO Address Width"
add_display_item "General" RXFIFO_ADDR_WIDTH parameter

# # CNTR_BITS, HDL parameter
add_parameter CNTR_BITS INTEGER 20
set_parameter_property CNTR_BITS DEFAULT_VALUE 20
set_parameter_property CNTR_BITS DISPLAY_NAME "Counter bits"
set_parameter_property CNTR_BITS ALLOWED_RANGES {6 20}
set_parameter_property CNTR_BITS DISPLAY_HINT ""
set_parameter_property CNTR_BITS AFFECTS_ELABORATION true
set_parameter_property CNTR_BITS AFFECTS_GENERATION true
set_parameter_property CNTR_BITS VISIBLE false
set_parameter_property CNTR_BITS HDL_PARAMETER true
add_display_item "General" CNTR_BITS parameter

# # NUM_LANES, HDL parameter
add_parameter NUM_LANES INTEGER 8
set_parameter_property NUM_LANES DEFAULT_VALUE 8
set_parameter_property NUM_LANES DISPLAY_NAME "Number of lanes"
set_parameter_property NUM_LANES ALLOWED_RANGES {8}
set_parameter_property NUM_LANES DISPLAY_HINT ""
set_parameter_property NUM_LANES AFFECTS_ELABORATION true
set_parameter_property NUM_LANES AFFECTS_GENERATION true
set_parameter_property NUM_LANES HDL_PARAMETER true
set_parameter_property NUM_LANES ENABLED false
set_parameter_property NUM_LANES DESCRIPTION "Supports 8-lane configuration. Additional lane and data rate configurations are available. Contact your Intel sales representative or email interlaken@altera.com for more information."
add_display_item "General" NUM_LANES parameter

# # CALENDAR_PAGES, HDL parameter, 1
add_parameter CALENDAR_PAGES INTEGER 1
set_parameter_property CALENDAR_PAGES DEFAULT_VALUE 1
set_parameter_property CALENDAR_PAGES DISPLAY_NAME "Number of calendar pages"
set_parameter_property CALENDAR_PAGES ALLOWED_RANGES {1,2,4,8,16}
set_parameter_property CALENDAR_PAGES DISPLAY_HINT ""
set_parameter_property CALENDAR_PAGES DESCRIPTION "In-band flow control supports 16-bit calendar pages. Supported numbers of pages are 1, 2, 4, 8, and 16. Flow control channels can be mapped to a calendar entry or entries."
set_parameter_property CALENDAR_PAGES HDL_PARAMETER true
set_parameter_property CALENDAR_PAGES AFFECTS_ELABORATION true
add_display_item "In-Band Flow Control" CALENDAR_PAGES parameter

# #  LOG_CALENDAR_PAGES, derived HDL parameter, 1 
add_parameter LOG_CALENDAR_PAGES INTEGER 1
set_parameter_property LOG_CALENDAR_PAGES DEFAULT_VALUE 1
set_parameter_property LOG_CALENDAR_PAGES ALLOWED_RANGES {1 2 3 4}
set_parameter_property LOG_CALENDAR_PAGES TYPE INTEGER
set_parameter_property LOG_CALENDAR_PAGES UNITS None
set_parameter_property LOG_CALENDAR_PAGES HDL_PARAMETER true
set_parameter_property LOG_CALENDAR_PAGES VISIBLE false
set_parameter_property LOG_CALENDAR_PAGES DERIVED true

# # # INCLUDE_TEMP_SENSE, HDL parameter, integer  
# add_parameter INCLUDE_TEMP_SENSE INTEGER 1
# set_parameter_property INCLUDE_TEMP_SENSE DEFAULT_VALUE 1
# set_parameter_property INCLUDE_TEMP_SENSE DISPLAY_NAME "Temperature sensor enable"
# set_parameter_property INCLUDE_TEMP_SENSE ALLOWED_RANGES {1}
# set_parameter_property INCLUDE_TEMP_SENSE DISPLAY_HINT ""
# set_parameter_property INCLUDE_TEMP_SENSE DESCRIPTION "Specifies the number of calendar pages; 16 bits per page"
# set_parameter_property INCLUDE_TEMP_SENSE HDL_PARAMETER true
# set_parameter_property INCLUDE_TEMP_SENSE AFFECTS_ELABORATION true
# add_display_item "Temperature enable " INCLUDE_TEMP_SENSE parameter

# # METALEN, HDL parameter, 64, range  
add_parameter METALEN INTEGER 2048
set_parameter_property METALEN DEFAULT_VALUE 2048
set_parameter_property METALEN DISPLAY_NAME "Meta frame length in words"
set_parameter_property METALEN ALLOWED_RANGES 128:8191
set_parameter_property METALEN TYPE INTEGER
set_parameter_property METALEN UNITS None
set_parameter_property METALEN HDL_PARAMETER true
set_parameter_property METALEN DESCRIPTION "Specifies the meta frame length; possible lengths are 128-8191 words."
add_display_item "General" METALEN parameter



 # # SCRAM_CONST, Native Phy parameter, A10 only long  
 add_parameter SCRAM_CONST_A10 Std_Logic_Vector 
 set_parameter_property SCRAM_CONST_A10 DEFAULT_VALUE 58'hdeadbeef123
 set_parameter_property SCRAM_CONST_A10 DISPLAY_NAME "Tx Scrambler seed"
 set_parameter_property SCRAM_CONST_A10 ALLOWED_RANGES 58'h1:58'h3FFFFFFFFFFFFFF
 set_parameter_property SCRAM_CONST_A10 DISPLAY_HINT "Initial Scrambler seed"
 set_parameter_property SCRAM_CONST_A10 VISIBLE false
 set_parameter_property SCRAM_CONST_A10 DESCRIPTION "This parameter specifies the initial scrambler state. It needs to be different for different instantiations of interlaken to reduce cross talk"
 add_display_item "Scrambler" SCRAM_CONST_A10 parameter
 
   # # SCRAM_CONST
 add_parameter SCRAM_CONST Std_Logic_Vector
 set_parameter_property SCRAM_CONST DEFAULT_VALUE 58'hdeadbeef123
 set_parameter_property SCRAM_CONST DISPLAY_NAME "Tx Scrambler seed"
 set_parameter_property SCRAM_CONST ALLOWED_RANGES 58'h1:58'h3FFFFFFFFFFFFFF
 set_parameter_property SCRAM_CONST DISPLAY_HINT "Initial Scrambler seed"
 set_parameter_property SCRAM_CONST VISIBLE false
 set_parameter_property SCRAM_CONST HDL_PARAMETER true
 set_parameter_property SCRAM_CONST AFFECTS_ELABORATION true
 set_parameter_property SCRAM_CONST DESCRIPTION "This parameter specifies the initial scrambler state. It needs to be different for different instantiations of interlaken to reduce cross talk"
 add_display_item "Scrambler" SCRAM_CONST parameter
 
 
 
# # INTERNAL_WORDS, HDL parameter, 4
add_parameter INTERNAL_WORDS INTEGER 1
set_parameter_property INTERNAL_WORDS DEFAULT_VALUE 4
set_parameter_property INTERNAL_WORDS DISPLAY_NAME "Internal words"
set_parameter_property INTERNAL_WORDS ALLOWED_RANGES {4}
set_parameter_property INTERNAL_WORDS DISPLAY_HINT ""
set_parameter_property INTERNAL_WORDS DESCRIPTION "Internal words"
set_parameter_property INTERNAL_WORDS VISIBLE false
set_parameter_property INTERNAL_WORDS HDL_PARAMETER true
set_parameter_property INTERNAL_WORDS AFFECTS_ELABORATION true
add_display_item "Internal words" INTERNAL_WORDS parameter

# # W_BUNDLE_TO_XCVR  
add_parameter W_BUNDLE_TO_XCVR INTEGER 70
set_parameter_property W_BUNDLE_TO_XCVR DEFAULT_VALUE 70
set_parameter_property W_BUNDLE_TO_XCVR DISPLAY_NAME "W_BUNDLE_TO_XCVR"
set_parameter_property W_BUNDLE_TO_XCVR ALLOWED_RANGES {70}
set_parameter_property W_BUNDLE_TO_XCVR DISPLAY_HINT ""
set_parameter_property W_BUNDLE_TO_XCVR DESCRIPTION "W_BUNDLE_TO_XCVR"
set_parameter_property W_BUNDLE_TO_XCVR VISIBLE false
set_parameter_property W_BUNDLE_TO_XCVR HDL_PARAMETER true
set_parameter_property W_BUNDLE_TO_XCVR AFFECTS_ELABORATION true
add_display_item "W_BUNDLE_TO_XCVR" W_BUNDLE_TO_XCVR parameter

# # W_BUNDLE_FROM_XCVR
add_parameter W_BUNDLE_FROM_XCVR INTEGER 46
set_parameter_property W_BUNDLE_FROM_XCVR DEFAULT_VALUE 46
set_parameter_property W_BUNDLE_FROM_XCVR DISPLAY_NAME "W_BUNDLE_FROM_XCVR"
set_parameter_property W_BUNDLE_FROM_XCVR ALLOWED_RANGES {46}
set_parameter_property W_BUNDLE_FROM_XCVR DISPLAY_HINT ""
set_parameter_property W_BUNDLE_FROM_XCVR DESCRIPTION "W_BUNDLE_FROM_XCVR"
set_parameter_property W_BUNDLE_FROM_XCVR VISIBLE false
set_parameter_property W_BUNDLE_FROM_XCVR HDL_PARAMETER true
set_parameter_property W_BUNDLE_FROM_XCVR AFFECTS_ELABORATION true
add_display_item "W_BUNDLE_FROM_XCVR" W_BUNDLE_FROM_XCVR parameter

# USE_ATX 
# add_parameter USE_ATX Boolean 1
# set_parameter_property USE_ATX DEFAULT_VALUE 1
# set_parameter_property USE_ATX DISPLAY_NAME "USE_ATX"
# # set_parameter_property USE_ATX ALLOWED_RANGES {0 1}
# set_parameter_property USE_ATX DISPLAY_HINT ""
# set_parameter_property USE_ATX AFFECTS_ELABORATION true
# set_parameter_property USE_ATX AFFECTS_GENERATION true
# set_parameter_property USE_ATX VISIBLE false
# set_parameter_property USE_ATX HDL_PARAMETER true
# add_display_item "Reconfig Settings" USE_ATX parameter

# # BONDED 
# add_parameter BONDED INTEGER 0 
# set_parameter_property BONDED DISPLAY_NAME "BONDED"
# set_parameter_property BONDED ALLOWED_RANGES {0 1 }
# set_parameter_property BONDED DISPLAY_HINT "BONDED"
# set_parameter_property BONDED DESCRIPTION "BONDED"
# set_parameter_property BONDED AFFECTS_ELABORATION true
# set_parameter_property BONDED HDL_PARAMETER true
# set_parameter_property BONDED ENABLED false
# add_display_item "General" BONDED parameter


# # DATA_RATE 
# add_parameter DATA_RATE STRING
# set_parameter_property DATA_RATE DEFAULT_VALUE "6250.0 Mbps"
# set_parameter_property DATA_RATE DISPLAY_NAME "Data rate"
# set_parameter_property DATA_RATE ALLOWED_RANGES {"6250.0 Mbps"}
# set_parameter_property DATA_RATE DISPLAY_HINT ""
# set_parameter_property DATA_RATE AFFECTS_ELABORATION true
# set_parameter_property DATA_RATE AFFECTS_GENERATION true
# set_parameter_property DATA_RATE DESCRIPTION "Specifies data rate on each lane"
# set_parameter_property DATA_RATE ENABLED false
# set_parameter_property DATA_RATE HDL_PARAMETER true
# add_display_item "General" DATA_RATE parameter

# DATA_RATE_GUI 
add_parameter DATA_RATE_GUI STRING
set_parameter_property DATA_RATE_GUI DEFAULT_VALUE "6.25"
set_parameter_property DATA_RATE_GUI DISPLAY_NAME "Data rate"
set_parameter_property DATA_RATE_GUI ALLOWED_RANGES {"6.25" }
set_parameter_property DATA_RATE_GUI UNITS GigabitsPerSecond
set_parameter_property DATA_RATE_GUI DISPLAY_HINT ""
set_parameter_property DATA_RATE_GUI AFFECTS_ELABORATION true
set_parameter_property DATA_RATE_GUI AFFECTS_GENERATION true
set_parameter_property DATA_RATE_GUI ENABLED false
set_parameter_property DATA_RATE_GUI DESCRIPTION "Supports one data rate: 6.25 Gbps."
add_display_item "General" DATA_RATE_GUI parameter

# DATA_RATE 
add_parameter DATA_RATE STRING
set_parameter_property DATA_RATE DEFAULT_VALUE "6250.0 Mbps"
set_parameter_property DATA_RATE DISPLAY_NAME "Data rate internal"
set_parameter_property DATA_RATE ALLOWED_RANGES {"6250.0 Mbps"}
set_parameter_property DATA_RATE DISPLAY_HINT ""
set_parameter_property DATA_RATE AFFECTS_ELABORATION true
set_parameter_property DATA_RATE AFFECTS_GENERATION true
set_parameter_property DATA_RATE DESCRIPTION "Specifies data rate on each lane"
set_parameter_property DATA_RATE VISIBLE false
set_parameter_property DATA_RATE DERIVED true
set_parameter_property DATA_RATE HDL_PARAMETER true
add_display_item "General" DATA_RATE parameter

# PLL_OUT_FREQ
add_parameter PLL_OUT_FREQ STRING
set_parameter_property PLL_OUT_FREQ DEFAULT_VALUE "3125.0 MHz"
set_parameter_property PLL_OUT_FREQ DISPLAY_NAME "PLL_OUT_FREQ"
set_parameter_property PLL_OUT_FREQ ALLOWED_RANGES {"3125.0 MHz"}
set_parameter_property PLL_OUT_FREQ DISPLAY_HINT ""
set_parameter_property PLL_OUT_FREQ AFFECTS_ELABORATION true
set_parameter_property PLL_OUT_FREQ AFFECTS_GENERATION true
set_parameter_property PLL_OUT_FREQ VISIBLE false
set_parameter_property PLL_OUT_FREQ HDL_PARAMETER true
set_parameter_property PLL_OUT_FREQ DERIVED true
add_display_item "Reconfig Settings" PLL_OUT_FREQ parameter

# PLL_REFCLK_FREQ
add_parameter PLL_REFCLK_FREQ STRING
set_parameter_property PLL_REFCLK_FREQ DEFAULT_VALUE "312.5 MHz"
set_parameter_property PLL_REFCLK_FREQ DISPLAY_NAME "Transceiver reference clock frequency"
set_parameter_property PLL_REFCLK_FREQ ALLOWED_RANGES {"156.25 MHz" "195.3125 MHz" "250.0 MHz" "312.5 MHz" "390.625 MHz" "500.0 MHz" "625.0 MHz" }
set_parameter_property PLL_REFCLK_FREQ DISPLAY_HINT ""
set_parameter_property PLL_REFCLK_FREQ AFFECTS_ELABORATION true
set_parameter_property PLL_REFCLK_FREQ AFFECTS_GENERATION true
set_parameter_property PLL_REFCLK_FREQ VISIBLE true
set_parameter_property PLL_REFCLK_FREQ HDL_PARAMETER true
# set_parameter_property PLL_REFCLK_FREQ DERIVED true
set_parameter_property PLL_REFCLK_FREQ DESCRIPTION "Supports multiple transceiver reference clock frequencies for flexibility in oscillator and PLL choices."
add_display_item "General" PLL_REFCLK_FREQ parameter

#ADME
add_parameter ADME BOOLEAN 0 
set_parameter_property ADME DEFAULT_VALUE 0
set_parameter_property ADME DISPLAY_NAME "Enable Native XCVR PHY ADME"
set_parameter_property ADME DISPLAY_HINT BOOLEAN
set_parameter_property ADME AFFECTS_ELABORATION true
set_parameter_property ADME AFFECTS_GENERATION true
set_parameter_property ADME HDL_PARAMETER false
# set_parameter_property ADME DERIVED true
set_parameter_property ADME VISIBLE false
set_parameter_property ADME DESCRIPTION  "Enables ADME and Optional Reconfiguration Logic Parameters of Native PHY."
add_display_item "General" ADME parameter


# INT_TX_CLK_DIV, this value is derived based on frequency
add_parameter INT_TX_CLK_DIV INTEGER 1
set_parameter_property INT_TX_CLK_DIV DEFAULT_VALUE 1
set_parameter_property INT_TX_CLK_DIV DISPLAY_NAME "INT_TX_CLK_DIV"
set_parameter_property INT_TX_CLK_DIV ALLOWED_RANGES {1}
set_parameter_property INT_TX_CLK_DIV DISPLAY_HINT ""
set_parameter_property INT_TX_CLK_DIV AFFECTS_ELABORATION true
set_parameter_property INT_TX_CLK_DIV AFFECTS_GENERATION true
set_parameter_property INT_TX_CLK_DIV VISIBLE false
set_parameter_property INT_TX_CLK_DIV HDL_PARAMETER true
set_parameter_property INT_TX_CLK_DIV DERIVED true
add_display_item "Reconfig Settings" INT_TX_CLK_DIV parameter

# LANE_PROFILE
add_parameter LANE_PROFILE Std_logic_vector 
set_parameter_property LANE_PROFILE WIDTH 24
set_parameter_property LANE_PROFILE DEFAULT_VALUE 24'b000000000000101101101101
set_parameter_property LANE_PROFILE DISPLAY_NAME "LANE_PROFILE"
# set_parameter_property LANE_PROFILE ALLOWED_RANGES {000000000000111111111111 111111111111111111111111}
set_parameter_property LANE_PROFILE DISPLAY_HINT ""
set_parameter_property LANE_PROFILE AFFECTS_ELABORATION true
set_parameter_property LANE_PROFILE AFFECTS_GENERATION true
set_parameter_property LANE_PROFILE VISIBLE false
set_parameter_property LANE_PROFILE HDL_PARAMETER true
set_parameter_property LANE_PROFILE DERIVED true
add_display_item "Reconfig Settings" LANE_PROFILE parameter

# NUM_SIXPACKS is set as a default value of 2/replaced by count_sixpacks inside ilk_core_50g
add_parameter NUM_SIXPACKS INTEGER 2
set_parameter_property NUM_SIXPACKS DEFAULT_VALUE 2
set_parameter_property NUM_SIXPACKS DISPLAY_NAME "NUM_SIXPACKS"
set_parameter_property NUM_SIXPACKS ALLOWED_RANGES {2 4}
set_parameter_property NUM_SIXPACKS DISPLAY_HINT ""
set_parameter_property NUM_SIXPACKS AFFECTS_ELABORATION true
set_parameter_property NUM_SIXPACKS AFFECTS_GENERATION true
set_parameter_property NUM_SIXPACKS VISIBLE false
set_parameter_property NUM_SIXPACKS HDL_PARAMETER true
set_parameter_property NUM_SIXPACKS DERIVED true
add_display_item "Reconfig Settings" NUM_SIXPACKS parameter


# Interleave
# add_parameter INTERLEAVE Boolean 1
# set_parameter_property INTERLEAVE DEFAULT_VALUE 1
# set_parameter_property INTERLEAVE DISPLAY_NAME "Interleave mode selection"
# set_parameter_property INTERLEAVE DISPLAY_HINT ""
# set_parameter_property INTERLEAVE AFFECTS_ELABORATION true
# set_parameter_property INTERLEAVE AFFECTS_GENERATION true
# set_parameter_property INTERLEAVE AFFECTS_VALIDATION true
# set_parameter_property INTERLEAVE VISIBLE false
# set_parameter_property INTERLEAVE HDL_PARAMETER false
# set_parameter_property INTERLEAVE DESCRIPTION "Interleave mode selection"
# add_display_item "Interleave Mode Selection" INTERLEAVE parameter

# RX_PKTMOD_ONLY
add_parameter RX_PKTMOD_ONLY INTEGER 0 Interleave
set_parameter_property RX_PKTMOD_ONLY DEFAULT_VALUE 1
set_parameter_property RX_PKTMOD_ONLY DISPLAY_NAME "RX Packet mode Selection"
set_parameter_property RX_PKTMOD_ONLY ALLOWED_RANGES {0:"Interleaved" 1:"Packet only" }
set_parameter_property RX_PKTMOD_ONLY DISPLAY_HINT ""
set_parameter_property RX_PKTMOD_ONLY AFFECTS_ELABORATION true
set_parameter_property RX_PKTMOD_ONLY AFFECTS_GENERATION true
set_parameter_property RX_PKTMOD_ONLY HDL_PARAMETER true
# set_parameter_property RX_PKTMOD_ONLY DERIVED true
set_parameter_property RX_PKTMOD_ONLY VISIBLE false
set_parameter_property RX_PKTMOD_ONLY DESCRIPTION  ":  Supports two modes for packet transfer flexibility and ASIC/ASSP/FPGA/SoC interoperability."
add_display_item "User Data Transfer Interface" RX_PKTMOD_ONLY parameter
 
 # TX_PKTMOD_ONLY
add_parameter TX_PKTMOD_ONLY INTEGER 0  
set_parameter_property TX_PKTMOD_ONLY DEFAULT_VALUE 0
set_parameter_property TX_PKTMOD_ONLY DISPLAY_NAME "Transfer mode selection"
set_parameter_property TX_PKTMOD_ONLY ALLOWED_RANGES {"0:Interleaved (segmented)" "1:Packet" }
set_parameter_property TX_PKTMOD_ONLY DISPLAY_HINT radio
set_parameter_property TX_PKTMOD_ONLY AFFECTS_ELABORATION true
set_parameter_property TX_PKTMOD_ONLY AFFECTS_GENERATION true
set_parameter_property TX_PKTMOD_ONLY HDL_PARAMETER true
# set_parameter_property TX_PKTMOD_ONLY DERIVED true
set_parameter_property TX_PKTMOD_ONLY VISIBLE true
set_parameter_property TX_PKTMOD_ONLY DESCRIPTION  "Supports two modes for packet transfer flexibility and ASIC/ASSP/FPGA/SoC interoperability."
add_display_item "User Data Transfer Interface" TX_PKTMOD_ONLY parameter

# # MM_CLK_KHZ, HDL parameter, integer  
add_parameter MM_CLK_KHZ INTEGER 1
set_parameter_property MM_CLK_KHZ DEFAULT_VALUE 100000
set_parameter_property MM_CLK_KHZ DISPLAY_NAME "MM_CLK_KHZ"
set_parameter_property MM_CLK_KHZ ALLOWED_RANGES {100000:150000}
set_parameter_property MM_CLK_KHZ DISPLAY_HINT ""
set_parameter_property MM_CLK_KHZ DESCRIPTION "mm clock in KHz"
set_parameter_property MM_CLK_KHZ HDL_PARAMETER true
set_parameter_property MM_CLK_KHZ AFFECTS_ELABORATION true
set_parameter_property MM_CLK_KHZ VISIBLE false
add_display_item "MM_CLK_KHZ " MM_CLK_KHZ parameter
# # MM_CLK_MHZ, HDL parameter, integer  
add_parameter MM_CLK_MHZ INTEGER 1
set_parameter_property MM_CLK_MHZ DEFAULT_VALUE 100
set_parameter_property MM_CLK_MHZ DISPLAY_NAME "MM_CLK_MHZ"
set_parameter_property MM_CLK_MHZ ALLOWED_RANGES {100:150}
set_parameter_property MM_CLK_MHZ DISPLAY_HINT ""
set_parameter_property MM_CLK_MHZ DESCRIPTION "mm clock in MHz"
set_parameter_property MM_CLK_MHZ HDL_PARAMETER true
set_parameter_property MM_CLK_MHZ AFFECTS_ELABORATION true
set_parameter_property MM_CLK_MHZ VISIBLE false
set_parameter_property MM_CLK_MHZ DERIVED true
add_display_item "MM_CLK_MHZ " MM_CLK_MHZ parameter
# #  RECONF_ADDR, derived HDL parameter 
add_parameter RECONF_ADDR INTEGER 3
set_parameter_property RECONF_ADDR DEFAULT_VALUE 3
set_parameter_property RECONF_ADDR ALLOWED_RANGES {0 3 4 5}
set_parameter_property RECONF_ADDR TYPE INTEGER
set_parameter_property RECONF_ADDR UNITS None
set_parameter_property RECONF_ADDR HDL_PARAMETER true
set_parameter_property RECONF_ADDR VISIBLE false
set_parameter_property RECONF_ADDR DERIVED true

#Device dependent Phy and atx PLL
# add_parameter BASE_DEVICE string "Unknown"
# set_parameter_property BASE_DEVICE SYSTEM_INFO {BASE_DEVICE}

add_parameter part_trait_bd string ""
set_parameter_property part_trait_bd SYSTEM_INFO_TYPE PART_TRAIT
set_parameter_property part_trait_bd SYSTEM_INFO_ARG BASE_DEVICE
set_parameter_property part_trait_bd VISIBLE false

add_parameter base_device string "Unknown"
set_parameter_property base_device SYSTEM_INFO_ARG BASE_DEVICE
set_parameter_property base_device VISIBLE false


#=======================================================
#
# Example Design Tab
#
#=======================================================

# EXAMPLE_DESIGN_SELECT 
add_parameter EXAMPLE_DESIGN_SELECT STRING
set_parameter_property EXAMPLE_DESIGN_SELECT DEFAULT_VALUE "Interlaken Serial Loopback Design"
set_parameter_property EXAMPLE_DESIGN_SELECT DISPLAY_NAME "Select Design"
set_parameter_property EXAMPLE_DESIGN_SELECT ALLOWED_RANGES {"Interlaken Serial Loopback Design"}
set_parameter_property EXAMPLE_DESIGN_SELECT DISPLAY_HINT ""
# set_parameter_property EXAMPLE_DESIGN_SELECT DERIVED true
set_parameter_property EXAMPLE_DESIGN_SELECT AFFECTS_ELABORATION true
set_parameter_property EXAMPLE_DESIGN_SELECT AFFECTS_GENERATION true
set_parameter_property EXAMPLE_DESIGN_SELECT DESCRIPTION "<p>The example design generates and transmits packets of known payload across the layers of the IP (MAC, PCS, and PMA) and verifies if the packets received include errors or not. These packet errors are flagged via system console.</p>"
add_display_item "Available Example Design" EXAMPLE_DESIGN_SELECT PARAMETER

# EXAMPLE_DESIGN_SIM_FILES 
add_parameter EXAMPLE_DESIGN_SIM_FILES BOOLEAN 1
set_parameter_property EXAMPLE_DESIGN_SIM_FILES DEFAULT_VALUE 1
set_parameter_property EXAMPLE_DESIGN_SIM_FILES DISPLAY_NAME "Simulation"
set_parameter_property EXAMPLE_DESIGN_SIM_FILES DISPLAY_HINT ""
# set_parameter_property EXAMPLE_DESIGN_SIM_FILES DERIVED true
set_parameter_property EXAMPLE_DESIGN_SIM_FILES AFFECTS_ELABORATION true
set_parameter_property EXAMPLE_DESIGN_SIM_FILES AFFECTS_GENERATION true
set_parameter_property EXAMPLE_DESIGN_SIM_FILES DESCRIPTION "<p>When the simulation box is checked, all necessary filesets required for simulation will be generated. Simulation is supported for Questasim, VCS and NCSim.<br><br>When the simulation box is NOT checked, files required for simulation will NOT be generated.</p>"
add_display_item "Example Design Files" EXAMPLE_DESIGN_SIM_FILES PARAMETER

# EXAMPLE_DESIGN_SYNTH_FILES 
add_parameter EXAMPLE_DESIGN_SYNTH_FILES BOOLEAN 0
set_parameter_property EXAMPLE_DESIGN_SYNTH_FILES DEFAULT_VALUE 0
set_parameter_property EXAMPLE_DESIGN_SYNTH_FILES DISPLAY_NAME "Synthesis"
set_parameter_property EXAMPLE_DESIGN_SYNTH_FILES DISPLAY_HINT ""
# set_parameter_property EXAMPLE_DESIGN_SYNTH_FILES DERIVED true
set_parameter_property EXAMPLE_DESIGN_SYNTH_FILES AFFECTS_ELABORATION true
set_parameter_property EXAMPLE_DESIGN_SYNTH_FILES AFFECTS_GENERATION true
set_parameter_property EXAMPLE_DESIGN_SYNTH_FILES DESCRIPTION "<p>When the synthesis box is checked, all necessary filesets required for synthesis will be generated.<br><br>When the synthesis box is NOT checked, files required for synthesis will NOT be generated.</p>"
add_display_item "Example Design Files" EXAMPLE_DESIGN_SYNTH_FILES PARAMETER

set_parameter_update_callback EXAMPLE_DESIGN_SYNTH_FILES choose_EXAMPLE_DESIGN_SYNTH_FILES_callback


# EXAMPLE_DESIGN_Generated_HDL_Format
add_parameter GENERATED_HDL STRING
set_parameter_property GENERATED_HDL DEFAULT_VALUE "Verilog"
set_parameter_property GENERATED_HDL DISPLAY_NAME "Generated HDL Format"
set_parameter_property GENERATED_HDL ALLOWED_RANGES {"Verilog"}
set_parameter_property GENERATED_HDL DISPLAY_HINT ""
# set_parameter_property GENERATED_HDL ENABLED false
set_parameter_property GENERATED_HDL AFFECTS_ELABORATION true
set_parameter_property GENERATED_HDL AFFECTS_GENERATION true
set_parameter_property GENERATED_HDL DESCRIPTION "Only Verilog HDL generation is supported."
add_display_item "Generated HDL Format" GENERATED_HDL PARAMETER

# BOARD_SELECTION 
add_parameter BOARD_SELECTION STRING
set_parameter_property BOARD_SELECTION DEFAULT_VALUE "None"
set_parameter_property BOARD_SELECTION DISPLAY_NAME "Select Board"
# set_parameter_property BOARD_SELECTION ALLOWED_RANGES {"Arria 10 GX Transceiver Signal Integrity Development Kit" "Arria 10 GX Transceiver Signal Integrity Development Kit (ES)" "None"}
set_parameter_property BOARD_SELECTION ALLOWED_RANGES {"Arria 10 GX Transceiver Signal Integrity Development Kit" "None"}
set_parameter_property BOARD_SELECTION DISPLAY_HINT ""
set_parameter_property BOARD_SELECTION ENABLED false
# set_parameter_property BOARD_SELECTION DERIVED true
set_parameter_property BOARD_SELECTION AFFECTS_ELABORATION true
set_parameter_property BOARD_SELECTION AFFECTS_GENERATION true
set_parameter_property BOARD_SELECTION DESCRIPTION "<p>This option provides support for various development kits listed.The example design will be generated for the target device shown. If this menu is greyed out, it is because no board is supported for the options selected such as synthesis checked off. If an Intel FPGA Development board is selected, the Target Device used for generation will be the one that matches the device on the Development Kit.<br> For more details, visit https://www.altera.com/products/development-kits/kit-index.html<\p>"
add_display_item "Target Development Kit" BOARD_SELECTION PARAMETER

add_parameter part_trait_device string ""
set_parameter_property part_trait_device SYSTEM_INFO_TYPE PART_TRAIT
set_parameter_property part_trait_device SYSTEM_INFO_ARG  DEVICE
set_parameter_property part_trait_device VISIBLE false
set_parameter_property part_trait_device ENABLED false

# BOARD_SELECTION_TEXT
add_display_item "Target Development Kit" "HW_BOARD_TEXT" text ""


set_qip_strings { "set_instance_assignment -name MESSAGE_DISABLE 14320 -entity %entityName% -library %libraryName%  -to \"ilk_iw4_iw2_rx_packet_regroup:rg0|ilk_iw4_iw2_rx_regroup_wrapper:rg|ilk_iw4_rx_regroup:rg_iw4|ilk_iw4_rx_wide_word_ram*\" 
set_instance_assignment -name MESSAGE_DISABLE 14320 -entity %entityName% -library %libraryName%  -to \"iilk_iw4_iw2_rx_datapath:rdp|ilk_iw4_iw2_rx_crc24_check_wrapper:rcc|ilk_iw4_rx_crc24_check:rcrc_iw4|ilk_crc24_multiple_upto3:mu3|include_evo*\" 
set_instance_assignment -name MESSAGE_DISABLE 14320 -entity %entityName% -library %libraryName%  -to \"ilk_iw4_iw2_smoothed_domain_change:rdc0.rdc|dcfifo:dcfifo_component|dcfifo_n2n1:auto_generated|altsyncram_jl91:fifo_ram|q_b*\" 
set_instance_assignment -name MESSAGE_DISABLE 14320 -entity %entityName% -library %libraryName%  -to \"ilk_iw4_iw2_rx_packet_regroup:rg0|ilk_iw4_iw2_rx_compact_words_wrapper:cw|ilk_iw4_rx_compact_words:cw_iw4|ilk_six_three_comp:sc1|sum*\" 
set_instance_assignment -name MESSAGE_DISABLE 14320 -entity %entityName% -library %libraryName%  -to \"ilk_iw4_iw2_rx_packet_regroup:rg0|ilk_iw4_iw2_rx_channel_filter_wrapper:rf|ilk_iw4_rx_channel_filter:rf_iw4|ilk_six_three_comp:sc1|sum*\" 
set_instance_assignment -name MESSAGE_DISABLE 14320 -entity %entityName% -library %libraryName%  -to \"ilk_iw4_iw2_rx_packet_regroup:rg0|ilk_iw4_iw2_rx_regroup_wrapper:rg|ilk_iw4_rx_regroup:rg_iw4|ilk_iw4_rx_burst_read_scheduler:bstrs|dcfifo:wffo|dcfifo_4ht1:auto_generated|altsyncram_imb1:fifo_ram|q_b*\" 
set_instance_assignment -name MESSAGE_DISABLE 14320 -entity %entityName% -library %libraryName%  -to \"ilk_iw4_iw2_smoothed_domain_change:rdc0.rdc|dcfifo:dcfifo_component|dcfifo_n2n1:auto_generated|altsyncram_jl91:fifo_ram|q_b*\" 
set_instance_assignment -name MESSAGE_DISABLE 14320 -entity %entityName% -library %libraryName%  -to \"ilk_iw4_iw2_rx_packet_regroup:rg0|ilk_iw4_iw2_rx_channel_filter_wrapper:rf|ilk_iw4_rx_channel_filter:rf_iw4|altshift_taps:datwords_rr_rtl_0|shift_taps_kmu:auto_generated|altsyncram_u7c1:altsyncram4|ram_block*\" 
set_instance_assignment -name MESSAGE_DISABLE 14320 -entity %entityName% -library %libraryName%  -to \"ilk_iw4_iw2_smoothed_domain_change:rdc0.rdc|dcfifo:dcfifo_component|dcfifo_n2n1:auto_generated|altsyncram_jl91:fifo_ram|q_b*\" " } 
#+-------------------------------
#| VALIDATE CALLBACK
#|


proc validate_proc {} {

    set dev [get_parameter_value DEVICE_FAMILY]
	set dev_family [get_parameter_value DEVICE_FAMILY]
    set check_device [get_parameter_value DEVICE]
    set dev_family_S5 [check_device_family_equivalence $dev_family {"Stratix V"} ]
    set dev_family_A5 [check_device_family_equivalence $dev_family {"Arria V GZ"}]
    set dev_family_a10 [check_device_family_equivalence $dev_family {"Arria 10"} ]
    set num_of_lanes [get_parameter_value NUM_LANES]
	set rx_packet_mode [get_parameter_value RX_PKTMOD_ONLY]
	set tx_packet_mode [get_parameter_value TX_PKTMOD_ONLY]
# METALEN
    set meta_len [get_parameter_value METALEN]	
	
    # if {$dev == "Stratix V"} {
	# send_message info "The device selected is Stratix V"
	# } elseif {$dev == "Arria V GZ"} {
	# send_message info "The device selected is Arria V GZ"	
	# } elseif {$dev == "Arria 10"} {
	# send_message info "The device selected is Arria 10"	
	# } else {
	# send_message error "$dev is not supported, only Stratix V,Arria V GZ  and Arria 10 is supported"
    # }  


    if {$dev == "Arria V GZ" && $num_of_lanes == 24} {
	send_message error "Please select 12 lanes for Arria V GZ device "
	} else {
 
    } 	
	
	
    if {$meta_len < 128 || $meta_len > 8191  } {
	send_message error "Please enter meta frame length between 128 and 8191"
    } else {
	# send_message info "Meta frame length entered is $meta_len"
    }  	
 
 		
	
	############### GUI discription text display ############### 
	if {$dev_family_a10} {    
	    if {[string match [get_parameter_value EXAMPLE_DESIGN_SYNTH_FILES] "true"] == 1} {
		   if { [string match [get_parameter_value BOARD_SELECTION] "Arria 10 GX Transceiver Signal Integrity Development Kit"] == 1 } { 
               set_display_item_property "HW_BOARD_TEXT" text "<html>Family: Arria 10 Device: 10AX115S3F45I2SG<br><br> This example design supports generation, simulation and Quartus compile flows for any selected device.<br>The hardware support is provided through selected Development kit(s) with a specific device.</html>"
           } elseif { [string match [get_parameter_value BOARD_SELECTION] "Arria 10 GX Transceiver Signal Integrity Development Kit (ES)"] == 1 } { 
               set_display_item_property "HW_BOARD_TEXT" text "<html>choose_callback Family: Arria 10 Device: 10AX115S3F45I2SGE2<br><br> This example design supports generation, simulation and Quartus compile flows for any selected device.<br>The hardware support is provided through selected Development kit(s) with a specific device.</html>"
           } else {
			   set_display_item_property "HW_BOARD_TEXT" TEXT "<html>Family: Arria 10 Device: [get_parameter_value part_trait_device] <br><br> This example design supports generation, simulation and Quartus compile flows for any selected device.</html>"
           }
		### synthesis file selection
        } else {
           set_display_item_property "HW_BOARD_TEXT" text " "
        }
	### family selection
	} else {
	   set_display_item_property "HW_BOARD_TEXT" text "Target Developement Board Selection is not supported for this device"
	}
	
	if { [string match [get_parameter_value EXAMPLE_DESIGN_SYNTH_FILES] "false"] == 1 } {
        if { [string match [get_parameter_value EXAMPLE_DESIGN_SIM_FILES] "false"] == 1 } {
            send_message WARNING "At least one of the \"Simulation\" and \"Synthesis\" check boxes from \"Example Design Files\" must be selected to allow generation of Example Design Files."
        }
    }
	

} 


# +-------------------------------
# |ELABORATE CALLBACK
# |

proc elaborate {} {

    upvar np_name np_name
    upvar reset_controller_name reset_controller_name
        
        
    set    np_name               "np_"
    set    reset_controller_name "reset_control_a10_"
    
    add_interfaces 

		#Its better to use check_device_family_equivalence command than doing a direct compare 
  set dev_family [get_parameter_value DEVICE_FAMILY]
  set check_device [get_parameter_value DEVICE]
  set dev_family_S5 [check_device_family_equivalence $dev_family {"Stratix V"} ]
  set dev_family_A5 [check_device_family_equivalence $dev_family {"Arria V GZ"}]
  set dev_family_a10 [check_device_family_equivalence $dev_family {"Arria 10"} ]
  set adme [get_parameter_value ADME]	
 
		
  set num_of_lanes [get_parameter_value NUM_LANES]
  set data_rate_string [get_parameter_value DATA_RATE]
		set mm_clock_mhz [get_parameter_value MM_CLK_MHZ]
		# send_message info "mm_clock_mhz is $mm_clock_mhz" 
		# truncate Mbps and convert string to number
		set data_rate_num [expr [string trim $data_rate_string Mbps ] ]
		set meta_length [get_parameter_value METALEN]
		set pll_ref_string [get_parameter_value PLL_REFCLK_FREQ]
		set pll_ref_num [expr [string trim $pll_ref_string MHz ] ]   
        set pll_ref_char [string trim $pll_ref_string MHz ]
        set pll_ref_num_int [string range $pll_ref_char 0 2]
	
	if {$dev_family_a10 && [string match -nocase $check_device "unknown"]} {
             send_message error "The current selected device \"$check_device\" is invalid, please select a valid device to generate the IP."
    }
	
    #make scrambler seed visible for A10 device familt
     if {$dev_family_a10} {
           set_parameter_property SCRAM_CONST_A10 VISIBLE true           
           set_parameter_property ADME VISIBLE true
           #set_fileset_property synth TOP_LEVEL $outputName
           #set_fileset_property simulation_verilog TOP_LEVEL $outputName
        } else {
          set_parameter_property SCRAM_CONST VISIBLE true  
          set_fileset_property synth TOP_LEVEL ilk_core_50g
          set_fileset_property simulation_verilog TOP_LEVEL ilk_core_50g
        }
        
        set scram_seed_a10 [get_parameter_value SCRAM_CONST_A10]
        set scram_seed [get_parameter_value SCRAM_CONST]
        set hex [list 0123456789ABCDEF] 
        
        if {$scram_seed_a10 > 288230376151711743 || $scram_seed_a10 == 0} {
            send_message ERROR "Tx Scrambler seed is out of range. Valid range is 0x1 to 0x3FFFFFFFFFFFFFF"
            
        } else {
            set i 0
            while {[string range $scram_seed_a10 $i $i] != ""} {
                set match_found 0
                set j 0
                while {!$match_found && $j < 16} {
                  if {[string match [string range $scram_seed_a10 $i $i] [string range $hex $j $j]]} {
                      set match_found 1 
                  } 
                  set j [expr {$j + 1}]
                }
                if {$match_found == 0} {
                    send_message ERROR "Tx Scrambler seed is out of range. Valid range is 0x1 to 0x3FFFFFFFFFFFFFF"
                    return;
                }
                set i [expr {$i + 1}]
            }
        }
        
        if {$scram_seed > 288230376151711743 || $scram_seed == 0} {
            send_message ERROR "Tx Scrambler seed is out of range. Valid range is 0x1 to 0x3FFFFFFFFFFFFFF"
            
        } else {
            set i 0
            while {[string range $scram_seed $i $i] != ""} {
                set match_found 0
                set j 0
                while {!$match_found && $j < 16} {
                 if {[string match [string range $scram_seed $i $i] [string range $hex $j $j]]} {
                      set match_found 1 
                  } 
                  set j [expr {$j + 1}]
                }
                if {$match_found == 0} {
                    send_message ERROR "Tx Scrambler seed is out of range. Valid range is 0x1 to 0x3FFFFFFFFFFFFFF"
                    return;
                }
                set i [expr {$i + 1}]
            }
        }
    	
    if {$num_of_lanes == 8} {
        set_parameter_value RECONF_ADDR 3
	} else {
		send_message error "Lane number is not supported"
	}	
      if {$data_rate_string == "6250.0 Mbps"} {
		set atxpll_out_clk_freq "3125.0 MHz"
		# set pll_ref_num "156.25"
		# send_message info "atx pll out clock frequency is $atxpll_out_clk_freq" 
	   } else {
		# send_message info "atx pll out clock frequency is not set"
	   }
		
	if {$dev_family_a10} {
	    # send_message info "The value of data rate num is $data_rate_num" 
	    # send_message info "The value of pll ref num is $pll_ref_num" 	

	       ########## add ATX PLL    ###############
		 add_hdl_instance atxpll altera_xcvr_atx_pll_a10
         set atxpll_param_val_list [list set_output_clock_frequency $atxpll_out_clk_freq set_auto_reference_clock_frequency $pll_ref_num enable_mcgb 1 enable_hfreq_clk 1 base_device [get_parameter_value part_trait_bd]]
         foreach {param val} $atxpll_param_val_list {
           set_instance_parameter_value atxpll $param $val
         }

        if {$adme} {          
           append np_name "8l_6g_${pll_ref_num_int}ref_admeon_${meta_length}meta_${scram_seed_a10}"
        } else {
           append np_name "8l_6g_${pll_ref_num_int}ref_${meta_length}meta_${scram_seed_a10}"
        }
        add_hdl_instance $np_name altera_xcvr_native_a10
        if {$adme} {        
          set param_val_list [list device_family {Arria 10} protocol_mode interlaken_mode channels $num_of_lanes set_data_rate $data_rate_num plls 1 set_cdr_refclk_freq $pll_ref_num enable_ports_rx_prbs 1 enable_ports_rx_manual_cdr_mode 1 enable_port_rx_seriallpbken 1 enh_pld_pcs_width 67 enh_txfifo_mode Interlaken enh_txfifo_pfull 13 enh_txfifo_pempty 8 enable_port_tx_enh_fifo_full 1 enh_tx_crcgen_enable 1 enh_tx_crcerr_enable 1 enh_rx_crcchk_enable 1 enable_port_rx_enh_crc32_err 1 enable_port_tx_enh_fifo_pfull 1 enable_port_tx_enh_fifo_empty 1 enable_port_tx_enh_fifo_pempty 1 enable_port_tx_enh_fifo_cnt 1 enh_rxfifo_mode Interlaken enh_rxfifo_pempty 8 enable_port_rx_enh_data_valid 1 enable_port_rx_enh_fifo_full 1 enable_port_rx_enh_fifo_pfull 1 enable_port_rx_enh_fifo_empty 1 enable_port_rx_enh_fifo_pempty 1 enable_port_rx_enh_fifo_rd_en 1 enable_port_rx_enh_fifo_align_val 1 enable_port_rx_enh_fifo_align_clr 1 enh_tx_frmgen_enable 1 enh_tx_frmgen_mfrm_length $meta_length enh_tx_frmgen_burst_enable 1 enable_port_tx_enh_frame 1 enable_port_tx_enh_frame_diag_status 1 enable_port_tx_enh_frame_burst_en 1 enh_rx_frmsync_enable 1 enh_rx_frmsync_mfrm_length $meta_length enable_port_rx_enh_frame 1 enable_port_rx_enh_frame_lock 1 enable_port_rx_enh_frame_diag_status 1 enh_tx_crcgen_enable 1 enh_rx_crcchk_enable 1 enable_port_rx_enh_crc32_err 1 enh_tx_scram_enable 1 enh_tx_scram_seed $scram_seed_a10 enh_rx_descram_enable 1 enh_tx_dispgen_enable 1 enh_rx_dispchk_enable 1 enh_rx_blksync_enable 1 enable_port_rx_enh_blk_lock 1 generate_add_hdl_instance_example 1 rcfg_enable 1 rcfg_shared 1 rcfg_file_prefix altera_xcvr_native_vi rcfg_jtag_enable 1 set_capability_reg_enable 1 set_prbs_soft_logic_enable  1 set_odi_soft_logic_enable 1 set_csr_soft_logic_enable 1  base_device [get_parameter_value part_trait_bd]]
        } else {
          set param_val_list [list device_family {Arria 10} protocol_mode interlaken_mode channels $num_of_lanes set_data_rate $data_rate_num plls 1 set_cdr_refclk_freq $pll_ref_num enable_ports_rx_prbs 1 enable_ports_rx_manual_cdr_mode 1 enable_port_rx_seriallpbken 1 enh_pld_pcs_width 67 enh_txfifo_mode Interlaken enh_txfifo_pfull 13 enh_txfifo_pempty 8 enable_port_tx_enh_fifo_full 1 enh_tx_crcgen_enable 1 enh_tx_crcerr_enable 1 enh_rx_crcchk_enable 1 enable_port_rx_enh_crc32_err 1 enable_port_tx_enh_fifo_pfull 1 enable_port_tx_enh_fifo_empty 1 enable_port_tx_enh_fifo_pempty 1 enable_port_tx_enh_fifo_cnt 1 enh_rxfifo_mode Interlaken enh_rxfifo_pempty 8 enable_port_rx_enh_data_valid 1 enable_port_rx_enh_fifo_full 1 enable_port_rx_enh_fifo_pfull 1 enable_port_rx_enh_fifo_empty 1 enable_port_rx_enh_fifo_pempty 1 enable_port_rx_enh_fifo_rd_en 1 enable_port_rx_enh_fifo_align_val 1 enable_port_rx_enh_fifo_align_clr 1 enh_tx_frmgen_enable 1 enh_tx_frmgen_mfrm_length $meta_length enh_tx_frmgen_burst_enable 1 enable_port_tx_enh_frame 1 enable_port_tx_enh_frame_diag_status 1 enable_port_tx_enh_frame_burst_en 1 enh_rx_frmsync_enable 1 enh_rx_frmsync_mfrm_length $meta_length enable_port_rx_enh_frame 1 enable_port_rx_enh_frame_lock 1 enable_port_rx_enh_frame_diag_status 1 enh_tx_crcgen_enable 1 enh_rx_crcchk_enable 1 enable_port_rx_enh_crc32_err 1 enh_tx_scram_enable 1 enh_tx_scram_seed $scram_seed_a10 enh_rx_descram_enable 1 enh_tx_dispgen_enable 1 enh_rx_dispchk_enable 1 enh_rx_blksync_enable 1 enable_port_rx_enh_blk_lock 1 generate_add_hdl_instance_example 1 rcfg_enable 1 rcfg_shared 1 rcfg_file_prefix altera_xcvr_native_vi base_device [get_parameter_value part_trait_bd]]
        }
        
        foreach {param val} $param_val_list {
          set_instance_parameter_value $np_name $param $val
        }
	
       append reset_controller_name "${num_of_lanes}l"
       add_hdl_instance $reset_controller_name altera_xcvr_reset_control
        set param_val_list [list channels $num_of_lanes plls 1 sys_clk_in_mhz $mm_clock_mhz synchronize_reset 1 reduced_sim_time 0 tx_pll_enable 1 t_pll_powerdown 1000 synchronize_pll_reset 0 tx_enable 1 tx_per_channel 0 t_tx_analogreset 70000 t_tx_digitalreset 70000 t_pll_lock_hyst 0 rx_enable 1 rx_per_channel 1 t_rx_analogreset 40 t_rx_analogreset 70000 t_rx_digitalreset 4000]
        foreach {param val} $param_val_list {
          set_instance_parameter_value $reset_controller_name $param $val
        }	
		
		########## add Jtag    ###############
		 add_hdl_instance jtag_master altera_jtag_avalon_master
         set atxpll_param_val_list [list use_pli 0]
         foreach {param val} $atxpll_param_val_list {
           set_instance_parameter_value jtag_master $param $val
         }
		 
	# # add_hdl_instance altera_xcvr_reset_control_inst altera_xcvr_reset_control
    # #  set param_val_list [list channels $num_of_lanes plls 1 sys_clk_in_mhz 100 synchronize_reset 1 reduced_sim_time 1 tx_pll_enable 1 t_pll_powerdown 1000 synchronize_pll_reset 0 tx_enable 1 tx_per_channel 0 t_tx_digitalreset 20 t_pll_lock_hyst 0 rx_enable 1 rx_per_channel 0 t_rx_analogreset 40 t_rx_digitalreset 4000]
    # #  foreach {param val} $param_val_list {
    # #    set_instance_parameter_value altera_xcvr_reset_control_inst $param $val
    # #  }
	} else {
		# send_message info "******* not running add hdl inst ***************" 
	}	

	
} 

proc add_interfaces {} {
 
   #Its better to use check_device_family_equivalence command than doing a direct compare 
  set dev_family [get_parameter_value DEVICE_FAMILY]
  set dev_family_S5 [check_device_family_equivalence $dev_family {"Stratix V"} ]
  set dev_family_A5 [check_device_family_equivalence $dev_family {"Arria V GZ"}]
  set dev_family_a10 [check_device_family_equivalence $dev_family {"Arria 10"} ]
  
	set internal_word_size [get_parameter_value INTERNAL_WORDS]
	set num_of_lanes [get_parameter_value NUM_LANES]
	set data_rate [get_parameter_value DATA_RATE]
	set rx_fifo_addr_width [get_parameter_value RXFIFO_ADDR_WIDTH]	
	set num_calendar_pgs [get_parameter_value CALENDAR_PAGES]
	# set interleave_mode [get_parameter_value INTERLEAVE]
	set num_of_sixpack [get_parameter_value NUM_SIXPACKS]
    set mm_clock_khz [get_parameter_value MM_CLK_KHZ]
	# send_message info "mm_clock_khz is $mm_clock_khz" 
	set_parameter_value MM_CLK_MHZ [expr  $mm_clock_khz/1000 ]
	set mmclk_khz [get_parameter_value MM_CLK_KHZ]
    set reconfig_adr_width [get_parameter_value RECONF_ADDR]
	# send_message info "mmclk_khz is $mmclk_khz" 

	set data_rate_gui [get_parameter_value DATA_RATE_GUI]
	
    if {$data_rate_gui == "6.25"} {
		set_parameter_value DATA_RATE "6250.0 Mbps"
		# send_message info "data rate gui is $data_rate_gui" 
	} else {
		send_message error "Data rate is not supported, set data rate"
		# send_message info "data rate gui is $data_rate_gui" 
	}

# family value in wrapper
	if {$dev_family_S5} {
	   set_parameter_value FAMILY "Stratix V"
    } elseif {$dev_family_A5} {
	   set_parameter_value FAMILY "Arria V GZ"  
    } elseif {$dev_family_a10} {
	   set_parameter_value FAMILY "Arria 10"   
	} else {
		send_message error "device is not supported, please select Stratix V, Arria V GZ or Arria 10 "
	}
	
	# if {$dev_family == "Arria 10"} {
        # if {$data_rate == "6250.0 Mbps"} {
	           # set_parameter_property PLL_REFCLK_FREQ ALLOWED_RANGES {"156.25 MHz"  }
	        # } else {
	        	# send_message error "Data rate is not supported, set range of pll ref clk"
	        # }
	# } else {
         # if {$data_rate == "6250.0 Mbps"} {
	           # set_parameter_property PLL_REFCLK_FREQ ALLOWED_RANGES {"156.25 MHz" "195.3125 MHz" "250.0 MHz" "312.5 MHz" "390.625 MHz" "500.0 MHz" "625.0 MHz" }
	        # } else {
	        	# send_message error "Data rate is not supported, set range of pll ref clk"
	        # }
	# }	
	
	if {$dev_family_a10} {
       set_parameter_property EXAMPLE_DESIGN_SYNTH_FILES ENABLED true
	} else {
	   set_parameter_property EXAMPLE_DESIGN_SYNTH_FILES ENABLED false
	}
	
# terminate value in interface
	if {$dev_family_a10} {
	set termin_or_not "false"
	} else {
	set termin_or_not "true"
    }

	set termin_value 0
	
	# if {$interleave_mode == true} {
	    # # send_message info "interleave_mode is $interleave_mode" 
		# set_parameter_value RX_PKTMOD_ONLY 0
		# set_parameter_value TX_PKTMOD_ONLY 0
		# # send_message info "Interleave mode is selected, receiver expect traffic from transmit is interleaved or packet mode with burstmin nx64."
		# # send_message info "Interleave mode is selected, on transmitter side, user is responsible to provide itx_sob/itx_eob for instructing Interlaken core where to insert control word."		
	# } else {
		# # send_message info "interleave_mode is $interleave_mode" 
		# set_parameter_value RX_PKTMOD_ONLY 1
		# set_parameter_value TX_PKTMOD_ONLY 1
		# # send_message info "Packet only mode is selected, receiver expect traffic from transmit is packet based with burstmin/burstshort 32 byte up."
		# # send_message info "Packet only mode is selected, transmitter will ignore itx_sob/itx_eob  and use internal enhance scheduling for insert control word."
	# }	

	
	
	    if {$num_calendar_pgs == 1} {
		set_parameter_value LOG_CALENDAR_PAGES 1
    } elseif {$num_calendar_pgs == 2} {
		set_parameter_value LOG_CALENDAR_PAGES 1
    } elseif {$num_calendar_pgs == 4} {
		set_parameter_value LOG_CALENDAR_PAGES 2		
    } elseif {$num_calendar_pgs == 8} {
		set_parameter_value LOG_CALENDAR_PAGES 3
    } elseif {$num_calendar_pgs == 16} {
		set_parameter_value LOG_CALENDAR_PAGES 4
	} else {
		send_message error "Calendar width is not supported"
	}

	# if {[string match [get_parameter_value EXAMPLE_DESIGN_SYNTH_FILES] "true"] == 1} {
        # # set_parameter_property BOARD_SELECTION ALLOWED_RANGES {"Arria 10 GX Transceiver Signal Integrity Development Kit" "Arria 10 GX Transceiver Signal Integrity Development Kit (ES)" "None"}
        # set_parameter_property BOARD_SELECTION ALLOWED_RANGES {"Arria 10 GX Transceiver Signal Integrity Development Kit" "None"}
    # } else {
        # set_parameter_property BOARD_SELECTION ALLOWED_RANGES {"None"}
    # }
	
	set pll_reference_clock [get_parameter_value PLL_REFCLK_FREQ]
	# send_message info "The transceiver reference clock frequency is set as  $pll_reference_clock"

# # Calculate width and add to/from_xcvr signals
    set bundle_width_to_xcvr [get_parameter_value W_BUNDLE_TO_XCVR]
    set bundle_width_from_xcvr [get_parameter_value W_BUNDLE_FROM_XCVR]

	# if {$dev_family_A5} {
		# if {$bond == 1} {
			# set num_plls 1 
		# } else {
			# set num_plls $num_of_lanes 
		# }
	# } else {
	 # set num_plls $num_of_sixpack
	# } 

# reconfig_to_xcvr 
add_conduit reconfig_to_xcvr end Input [expr $bundle_width_to_xcvr * ( $num_of_lanes + $num_of_sixpack ) ]
# reconfig_from_xcvr
add_conduit reconfig_from_xcvr end output [expr $bundle_width_from_xcvr * ( $num_of_lanes + $num_of_sixpack ) ] 

	if {$dev_family_a10} {
       set_port_property reconfig_to_xcvr TERMINATION true
       set_port_property reconfig_to_xcvr TERMINATION_VALUE 0 
       
       set_port_property reconfig_from_xcvr TERMINATION true
       set_port_property reconfig_from_xcvr TERMINATION_VALUE 0
	} 
	
# rx_pin, tx_pin
add_conduit rx_pin end Input $num_of_lanes
add_conduit tx_pin end output $num_of_lanes

# rx_dual_sop_enable
# add_conduit rx_dual_sop_enable end Input 1

# reset output
add_conduit tx_mac_srst end Output 1
add_conduit rx_mac_srst end Output 1
add_conduit tx_usr_srst end Output 1
add_conduit rx_usr_srst end Output 1

# Native PHY specific interface
add_interface np_interface conduit end
add_interface_port np_interface tx_pll_powerdown export output 1
set_port_property tx_pll_powerdown TERMINATION $termin_or_not

# add_interface_port np_interface mm_waitrequest export output 1
# set_port_property mm_waitrequest TERMINATION $termin_or_not

add_interface_port np_interface tx_pll_locked export input 1
set_port_property tx_pll_locked TERMINATION $termin_or_not
set_port_property tx_pll_locked TERMINATION_VALUE $termin_value

add_interface_port np_interface tx_serial_clk export input $num_of_lanes
set_port_property tx_serial_clk TERMINATION $termin_or_not
set_port_property tx_serial_clk TERMINATION_VALUE $termin_value

# add_interface_port np_interface tx_bonding_clocks export input [expr 6 * $num_of_lanes ]
# set_port_property tx_bonding_clocks TERMINATION $termin_or_not
# set_port_property tx_bonding_clocks TERMINATION_VALUE $termin_value
# Reconfig status conduit
add_interface reconfig_status conduit end
add_interface_port reconfig_status reconfig_clk export input 1
set_port_property reconfig_clk TERMINATION $termin_or_not
set_port_property reconfig_clk TERMINATION_VALUE $termin_value

add_interface_port reconfig_status reconfig_reset export input 1
set_port_property reconfig_reset TERMINATION $termin_or_not
set_port_property reconfig_reset TERMINATION_VALUE $termin_value

add_interface_port reconfig_status reconfig_write export input 1
set_port_property reconfig_write TERMINATION $termin_or_not
set_port_property reconfig_write TERMINATION_VALUE $termin_value

add_interface_port reconfig_status reconfig_read export input 1
set_port_property reconfig_read TERMINATION $termin_or_not
set_port_property reconfig_read TERMINATION_VALUE $termin_value

add_interface_port reconfig_status reconfig_address export input [expr $reconfig_adr_width + 10 ]
set_port_property reconfig_address TERMINATION $termin_or_not
set_port_property reconfig_address TERMINATION_VALUE $termin_value

add_interface_port reconfig_status reconfig_writedata export input 32
set_port_property reconfig_writedata TERMINATION $termin_or_not
set_port_property reconfig_writedata TERMINATION_VALUE $termin_value

add_interface_port reconfig_status reconfig_readdata export output 32

add_interface_port reconfig_status reconfig_waitrequest export output 1

# TX status conduit
add_interface tx_status conduit end
add_interface_port tx_status tx_lanes_aligned export output 1
add_interface_port tx_status itx_hungry export output 1
add_interface_port tx_status itx_overflow export output 1
add_interface_port tx_status itx_underflow export output 1
add_interface_port tx_status itx_ready export output 1
# set_interface_property  tx_status ASSOCIATED_CLOCK tx_usr_clk

# # TX side Data Conduit Interface
add_interface tx_data conduit end
add_interface_port tx_data  itx_chan export input 8
add_interface_port tx_data  itx_num_valid export input 3
add_interface_port tx_data  itx_sop export input 1
add_interface_port tx_data  itx_eopbits export input 4
add_interface_port tx_data  itx_sob export input 1
add_interface_port tx_data  itx_eob export input 1
add_interface_port tx_data  itx_din_words export input  [expr 64 * $internal_word_size ]
add_interface_port tx_data  itx_calendar  export input [expr 16 * $num_calendar_pgs ]
# set_interface_property  tx_data ASSOCIATED_CLOCK tx_usr_clk
   
# Burst Control Settings		 
add_interface burst_control conduit end
add_interface_port burst_control burst_max_in export input 4
add_interface_port burst_control burst_short_in export input 4
add_interface_port burst_control burst_min_in export input 4

# RX side Data Conduit Interface, 
add_interface rx_data conduit end
add_interface_port rx_data irx_chan export output 8
add_interface_port rx_data irx_num_valid export output 3
add_interface_port rx_data irx_sop export output 1
add_interface_port rx_data irx_eopbits export output 4
add_interface_port rx_data irx_sob export output 1
add_interface_port rx_data irx_eob export output 1
add_interface_port rx_data irx_err export output 1
add_interface_port rx_data irx_dout_words export output  [expr 64 * $internal_word_size ]
add_interface_port rx_data irx_calendar export output  [expr 16 * $num_calendar_pgs ]
# set_interface_property rx_data ASSOCIATED_CLOCK rx_usr_clk

# RX side real-time status Conduit Interface 
add_interface rx_status conduit end
add_interface_port rx_status sync_locked export output $num_of_lanes
add_interface_port rx_status word_locked export output $num_of_lanes
add_interface_port rx_status rx_lanes_aligned export output 1
add_interface_port rx_status crc24_err export output 1
add_interface_port rx_status crc32_err export output $num_of_lanes
add_interface_port rx_status irx_overflow export output 1
add_interface_port rx_status rdc_overflow export output 1
add_interface_port rx_status rg_overflow export output 1
add_interface_port rx_status rxfifo_fill_level export output $rx_fifo_addr_width
add_interface_port rx_status sop_cntr_inc export output 1
add_interface_port rx_status eop_cntr_inc export output 1
add_interface_port rx_status nad_cntr_inc export output 1
# set_interface_property rx_status ASSOCIATED_CLOCK rx_usr_clk

# srst_tx_common
add_conduit srst_tx_common end output 1

# srst_rx_common
add_conduit srst_rx_common end output 1

# +-----------------------------------
# | connection point management_interface
# | 

add_interface management_interface avalon slave
set_interface_property management_interface addressUnits word
# set_interface_property management_interface burstCountUnits word
# set_interface_property management_interface constantBurstBehavior false
set_interface_property management_interface burstOnBurstBoundariesOnly false
set_interface_property management_interface holdTime 0
set_interface_property management_interface linewrapBursts false
# supported pending read 1
set_interface_property management_interface maximumPendingReadTransactions 1
# set_interface_property management_interface readLatency 1
set_interface_property management_interface readWaitTime 0
set_interface_property management_interface setupTime 0
set_interface_property management_interface timingUnits Cycles
set_interface_property management_interface writeWaitTime 0


set_interface_property management_interface ASSOCIATED_CLOCK  mm_clk
set_interface_property management_interface ENABLED true

# management_interface is associated with reset
set_interface_property management_interface associatedReset  reset_n

#  mm_clk_locked" signal is set as conduit
add_conduit mm_clk_locked end Input 1

add_interface_port management_interface mm_addr address Input 16
add_interface_port management_interface mm_write write Input 1
add_interface_port management_interface mm_write write Input 1
add_interface_port management_interface mm_read read Input 1
add_interface_port management_interface mm_rdata_valid readdatavalid output 1
add_interface_port management_interface mm_wdata writedata Input 32
add_interface_port management_interface mm_rdata readdata Output 32


}


#+--------------------------------------------
#| clocks interfaces
#|

# # clk_sys 
#     add_interface clk_sys clock end
#     set_interface_property clk_sys ENABLED true
# 	   add_interface_port clk_sys clk_sys clk Input 1

# tx_usr_clk 
    add_interface tx_usr_clk clock end
    set_interface_property tx_usr_clk ENABLED true
    add_interface_port tx_usr_clk tx_usr_clk clk Input 1

# rx_usr_clk 	
    add_interface rx_usr_clk clock end
    set_interface_property rx_usr_clk ENABLED true
    add_interface_port rx_usr_clk rx_usr_clk clk Input 1

# pll_ref_clk
    add_interface pll_ref_clk clock end
    set_interface_property pll_ref_clk ENABLED true
    add_interface_port pll_ref_clk pll_ref_clk clk Input 1

# clk_tx_common
    add_interface clk_tx_common clock start
    set_interface_property clk_tx_common ENABLED true
    add_interface_port clk_tx_common clk_tx_common clk Output 1
	
# 	clk_rx_common
    add_interface clk_rx_common clock start
    set_interface_property clk_rx_common ENABLED true
    add_interface_port clk_rx_common clk_rx_common clk Output 1
	
#  mm_clk
    add_interface mm_clk clock end
    set_interface_property mm_clk ENABLED true
    add_interface_port mm_clk mm_clk clk Input 1

#+--------------------------------------------
#| reset interfaces
#|	

# reset
    add_interface reset_n reset reset
    set_interface_property reset_n ENABLED true
	add_interface_port reset_n reset_n reset Input 1
	set_interface_property reset_n associatedClock clk_tx_common
    set_interface_property reset_n synchronousEdges BOTH

#+--------------------------------------
#| procedure to add conduit interfaces
#|

proc add_conduit {iface_name type dir width} {

    add_interface $iface_name conduit $type
    add_interface_port $iface_name $iface_name export $dir $width
  
}


#+--------------------------------------
#| specify verilog files
#|

proc check_if_boolean { parameter } {
  set param_val [get_parameter_value $parameter]
  if { $param_val == "true"} {
    return 1;
  } elseif { $param_val == "false"} {
    return 0;
  } else {
    return "not_boolean";
  }
}

proc synth_proc {outputName} {
  global np_name 
  global reset_controller_name
		#Its better to use check_device_family_equivalence command than doing a direct compare
  set dev_family [get_parameter_value DEVICE_FAMILY]
  set dev_family_S5 [check_device_family_equivalence $dev_family {"Stratix V"} ]
  set dev_family_A5 [check_device_family_equivalence $dev_family {"Arria V GZ"}]
  set dev_family_a10 [check_device_family_equivalence $dev_family {"Arria 10"} ]
		  
       # if {$dev_family == "Stratix V" || $dev_family == "Arria V GZ" } {
            # add_pcs_lib
	   # # send_message info "******* add pcs lib in synth  ***************" 
       # } else {
       	# # send_message info "******* skip add pcs lib in synth ***************" 
       # }
       if {$dev_family_S5 || $dev_family_A5 } {
            add_pcs_lib
	   # send_message info "******* add pcs lib in synth  ***************" 
       } else {
       	# send_message info "******* skip add pcs lib in synth ***************" 
       }	   

# ###################
# ilk_pcs directory

# add if statement for A10 only
       if {$dev_family_a10 } {
          #add_fileset_file "./ilk_pcs/altera_xcvr_functions.sv" SYSTEM_VERILOG PATH "../../altera_xcvr_generic/altera_xcvr_functions.sv"
          #add_fileset_file "./ilk_pcs/alt_xcvr_resync.sv" SYSTEM_VERILOG PATH "../../altera_xcvr_generic/ctrl/alt_xcvr_resync.sv"
          # ADD stp files
          add_fileset_file "../debug/stp/ilk_core_50g_a10.xml" OTHER PATH "../ilk_50g_stp/ilk_50g.txt"
          add_fileset_file "../debug/stp/ilk_core_50g_build_stp_a10.tcl" OTHER PATH "../ilk_50g_stp/build_stp.tcl"
          
          add_fileset_file "../ilk_pcs/ilk_rx_aligner.sv" SYSTEM_VERILOG PATH "../ilk_pcs/ilk_rx_aligner.sv"  
          add_fileset_file "../ilk_pcs/ilk_tx_aligner.sv" SYSTEM_VERILOG PATH "../ilk_pcs/ilk_tx_aligner.sv"  
          add_fileset_file "../ilk_pcs/pempty_gen_a10.sv" SYSTEM_VERILOG PATH "../ilk_pcs/pempty_gen_a10.sv"  
          add_fileset_file "../ilk_pcs/ilk_hard_pcs_csr_a10.sv" SYSTEM_VERILOG PATH "../ilk_pcs/ilk_hard_pcs_csr_a10.sv"  
          add_fileset_file "../ilk_pcs/striper_wd_req.sv" SYSTEM_VERILOG PATH "../ilk_pcs/striper_wd_req.sv"  
          
          set params(np_name)                              $np_name
          set params(reset_controller_name)          $reset_controller_name
          interpret_terp ../ilk_pcs/ilk_hard_pcs_assembly_a10_50g.sv  ../ilk_pcs/ilk_hard_pcs_assembly_a10_50g.sv.terp  [array get params]
          #add_fileset_file "../ilk_pcs/ilk_hard_pcs_assembly_a10_50g.sv" SYSTEM_VERILOG PATH "../ilk_pcs/ilk_hard_pcs_assembly_a10_50g.sv"  
          #add_fileset_file "../ilk_pcs/alt_xcvr_reset_counter.sv" SYSTEM_VERILOG PATH "../ilk_pcs/alt_xcvr_reset_counter.sv"  
          #add_fileset_file "../ilk_pcs/altera_xcvr_reset_control.sv" SYSTEM_VERILOG PATH "../ilk_pcs/altera_xcvr_reset_control.sv" 
          add_fileset_file "../ilk_pcs/tx_fifo_write.sv" SYSTEM_VERILOG PATH "../ilk_pcs/tx_fifo_write.sv"  			  
           # add_fileset_file "../ilk_pcs/alt_xcvr_resync.sv" SYSTEM_VERILOG PATH "../ilk_pcs/alt_xcvr_resync.sv"  
           # add_fileset_file "../ilk_pcs/altera_xcvr_functions.sv" SYSTEM_VERILOG PATH "../ilk_pcs/altera_xcvr_functions.sv"
	   # send_message info "******* add reset files in synth  for a10 ***************" 
       } else {
	      add_fileset_file "../ilk_pcs/ilk_pcs_assembly_50g.sv" SYSTEM_VERILOG PATH  "../ilk_pcs/ilk_pcs_assembly_50g.sv" 
          add_fileset_file "../ilk_pcs/ilk_reconfig_bundle_merger.sv" SYSTEM_VERILOG PATH "../ilk_pcs/ilk_reconfig_bundle_merger.sv" 
          add_fileset_file "../ilk_pcs/ilk_reconfig_bundle_to_xcvr.sv" SYSTEM_VERILOG PATH "../ilk_pcs/ilk_reconfig_bundle_to_xcvr.sv"  
          add_fileset_file "../ilk_pcs/sv_ilk_sixpack.sv" SYSTEM_VERILOG PATH "../ilk_pcs/sv_ilk_sixpack.sv" 
       	# send_message info "******* skip adding reset files in synth ***************" 
       }

	   add_fileset_file "../ilk_oob/ilk_oob_rx/ilk_oob_flow_rx.v" VERILOG PATH "../ilk_oob/ilk_oob_rx/ilk_oob_flow_rx.v" 
add_fileset_file "../ilk_oob/ilk_oob_rx/ilk_oob_flow_rx_dcfifo.v" VERILOG PATH "../ilk_oob/ilk_oob_rx/ilk_oob_flow_rx_dcfifo.v" 
add_fileset_file "../ilk_oob/ilk_oob_tx/ilk_oob_flow_tx.v" VERILOG PATH "../ilk_oob/ilk_oob_tx/ilk_oob_flow_tx.v" 
	   

# middle level directories, because of encryption sub-directories
# for verilog files
set synth_med_level_dir {"../ilk_50g_mac" "../ilk_50g_regroup"  "../ilk_striper/top" "../ilk_striper/8lane" }

foreach synth_med_dir1 $synth_med_level_dir {
# add all .v files
             set file_med_lst [glob -- -path $synth_med_dir1/*.v]
                     foreach file ${file_med_lst} {
						 set file_string [split $file /]
                         set file_name [lindex $file_string end]                                                 
                     add_fileset_file "$synth_med_dir1/$file_name" VERILOG PATH ${file}
					 
                     }
     }	    
     
set files_components_v "ilk_a10mlab.v ilk_aclr_filter.v ilk_add3_cmp3.v ilk_avgzmlab.v ilk_barrel_layer.v ilk_barrel_shift.v ilk_barrelshift_8to1.v ilk_bin_to_asc_hex.v \
     ilk_char_type.v ilk_clock_crossing_fifo.v ilk_compressor_3to2.v ilk_compressor_4to3.v ilk_compressor_5to3.v ilk_compressor_6to3.v ilk_count_to_here_12.v ilk_crc24_dat64_only_flat.v \
    ilk_crc24_multiple_upto2.v ilk_crc24_multiple_upto3.v ilk_crc24_multiple_upto4.v ilk_crc24_multiple_upto5.v ilk_crc24_zer64_flat.v ilk_crc24_zer64x2_flat.v ilk_crc24_zer64x3_flat.v ilk_crc24_zer64x4_flat.v \
    ilk_crc24_zer64x5_flat.v ilk_crc24_zer64x6_flat.v ilk_crc24_zer64x7_flat.v ilk_crc24_zer64x8_flat.v ilk_crc24_zer64x9_flat.v ilk_cross_bus.v ilk_delay_regs.v ilk_eq_5_ena.v ilk_err_handler.v ilk_frequency_monitor.v ilk_gray_cntr_4_sl.v \
    ilk_gray_cntr_5_sl.v ilk_gray_to_bin_5.v ilk_index_with_restart_12.v ilk_index_with_restart_3.v ilk_index_with_restart_6.v ilk_jtag_to_c_probe.v ilk_mult16.v ilk_mx12_ena.v ilk_mx16r.v ilk_mx4r.v ilk_mx8r.v ilk_mx_nto1_r.v \
    ilk_neq_5_ena.v ilk_page_grabber_12.v ilk_pipelined_any_flag.v ilk_priority_12.v ilk_priority_6.v ilk_priority_6_upper.v ilk_pwm9.v ilk_reset_delay.v ilk_rst_ctrl.v ilk_rst_sync.v ilk_rx_buffer_fifo_2.v ilk_s5m20k_ecc_1r1w.v \
    ilk_s5m20k_ecc_off.v ilk_s5m20k_group.v ilk_s5mlab.v ilk_sample_crossdomain.v ilk_scfifo_mlab.v ilk_six_three_comp.v ilk_status_sync.v ilk_sum_of_3bit_pair.v ilk_sync_fifo_mlab.v ilk_sync_regs_aclr_m2.v ilk_tx_buffer_fifo_ram_loose.v \
    ilk_wys_lut.v"


foreach vfile $files_components_v {
       add_fileset_file "../components/${vfile}" VERILOG PATH "../components/${vfile}"
  }
if {$dev_family_S5 } {
add_fileset_file "../components/ilk_temp_sense.v" VERILOG PATH "../components/ilk_temp_sense.v"
}

# add OCP file
add_fileset_file "../ilk_50g_mac/ilk_iw4_iw2_tx_datapath.ocp" OTHER PATH "../ilk_50g_mac/ilk_iw4_iw2_tx_datapath.ocp"
add_fileset_file "../ilk_50g_regroup/ilk_iw4_iw2_rx_packet_regroup.ocp" OTHER PATH "../ilk_50g_regroup/ilk_iw4_iw2_rx_packet_regroup.ocp"

# ilk_striper/top SYSTEM_VERILOG
add_fileset_file "../ilk_striper/ilk_50g_striper/ilk_rx_stripe_adapter.sv" SYSTEM_VERILOG_ENCRYPT PATH "../ilk_striper/ilk_50g_striper/ilk_rx_stripe_adapter.sv"
add_fileset_file "../ilk_striper/ilk_50g_striper/ilk_tx_stripe_adapter.sv" SYSTEM_VERILOG_ENCRYPT PATH "../ilk_striper/ilk_50g_striper/ilk_tx_stripe_adapter.sv"


# set synth_med_level_sv_dir { "../ilk_striper/top" }
# #for SystemVerilog files
# foreach synth_med_sv_dir1 $synth_med_level_sv_dir {
# # add the .sv files
#              set file_med_sv_lst [glob -- -path $synth_med_sv_dir1/*.sv]
#                      foreach file ${file_med_sv_lst} {
# 						 set file_string [split $file /]
#                          set file_name [lindex $file_string end]                                                  
#                      add_fileset_file "$synth_med_sv_dir1/$file_name" SYSTEM_VERILOG PATH ${file}
# 					 
#                      }
#      }		 

# add top-level file
  if {$dev_family_a10} {
       set params(top_level_name)                  $outputName
       set top_file_name   $outputName.sv
	   set params(family)                                [get_parameter_value DEVICE_FAMILY]
       set params(data_rate_mbps)                        [get_parameter_value DATA_RATE]
	   set params(mm_clk_khz)						     [get_parameter_value MM_CLK_KHZ]
	   set params(pll_refclk_freq)						 [get_parameter_value PLL_REFCLK_FREQ]
       set params(num_lanes)                             [get_parameter_value NUM_LANES]
       set params(tx_pkt_mode)                           [get_parameter_value TX_PKTMOD_ONLY]
       set params(calendar_pages)                        [get_parameter_value CALENDAR_PAGES]
	   set params(rxfifo_addr_width)					 [get_parameter_value RXFIFO_ADDR_WIDTH]
	   set params(internal_words)						 [get_parameter_value INTERNAL_WORDS] 
       set params(meta_frame)                            [get_parameter_value METALEN]    
       interpret_terp $top_file_name  ilk_core_50g_a10.sv.terp  [array get params]
  } else {
    add_fileset_file ilk_core_50g.sv SYSTEM_VERILOG PATH ilk_core_50g.sv
  }

# add SDC files
# add_fileset_file ilk_50g_top.sdc SDC PATH ilk_50g_top.sdc
       if {$dev_family_a10} {
           add_fileset_file ilk_50g_top.sdc SDC PATH ilk_50g_top_a10.sdc
        } else {
add_fileset_file ilk_50g_top.sdc SDC PATH ilk_50g_top.sdc
	    } 
	 
send_message PROGRESS "synth_proc done" 

}
	   
proc sim_ver {outputName} {

  global np_name 
  global reset_controller_name
  set dev_family [get_parameter_value DEVICE_FAMILY]
  set dev_family_S5 [check_device_family_equivalence $dev_family {"Stratix V"} ]
  set dev_family_A5 [check_device_family_equivalence $dev_family {"Arria V GZ"}]
  set dev_family_a10 [check_device_family_equivalence $dev_family {"Arria 10"} ]
       	
       # if {$dev_family == "Stratix V" || $dev_family == "Arria V GZ" } {
       # add_pcs_lib
	   # # send_message info "******* add pcs lib in sim ver ***************" 
       # } else {
       	# # send_message info "******* skip add pcs lib in sim ver ***************" 
       # }
       
       if {$dev_family_S5 || $dev_family_A5 } {
       add_pcs_lib
	   # send_message info "******* add pcs lib in sim ver ***************" 
       } else {
       	# send_message info "******* skip add pcs lib in sim ver ***************" 
       }
	   
# ###################
# ilk_pcs directory

# add if statement for A10 only
       if {$dev_family_a10 } {
	      #add_fileset_file "./ilk_pcs/altera_xcvr_functions.sv" SYSTEM_VERILOG PATH "../../altera_xcvr_generic/altera_xcvr_functions.sv"
		  #add_fileset_file "./ilk_pcs/alt_xcvr_resync.sv" SYSTEM_VERILOG PATH "../../altera_xcvr_generic/ctrl/alt_xcvr_resync.sv"
          add_fileset_file "../ilk_pcs/ilk_rx_aligner.sv" SYSTEM_VERILOG PATH "../ilk_pcs/ilk_rx_aligner.sv"  
          add_fileset_file "../ilk_pcs/ilk_tx_aligner.sv" SYSTEM_VERILOG PATH "../ilk_pcs/ilk_tx_aligner.sv"  
          add_fileset_file "../ilk_pcs/pempty_gen_a10.sv" SYSTEM_VERILOG PATH "../ilk_pcs/pempty_gen_a10.sv"  
          add_fileset_file "../ilk_pcs/ilk_hard_pcs_csr_a10.sv" SYSTEM_VERILOG PATH "../ilk_pcs/ilk_hard_pcs_csr_a10.sv"  
          add_fileset_file "../ilk_pcs/striper_wd_req.sv" SYSTEM_VERILOG PATH "../ilk_pcs/striper_wd_req.sv"  
          
          set params(np_name)                  $np_name
          set params(reset_controller_name)                  $reset_controller_name
          interpret_terp ../ilk_pcs/ilk_hard_pcs_assembly_a10_50g.sv  ../ilk_pcs/ilk_hard_pcs_assembly_a10_50g.sv.terp  [array get params]
          
          #add_fileset_file "../ilk_pcs/ilk_hard_pcs_assembly_a10_50g.sv" SYSTEM_VERILOG PATH "../ilk_pcs/ilk_hard_pcs_assembly_a10_50g.sv"  
         # add_fileset_file "../ilk_pcs/alt_xcvr_reset_counter.sv" SYSTEM_VERILOG PATH "../ilk_pcs/alt_xcvr_reset_counter.sv"  
         # add_fileset_file "../ilk_pcs/altera_xcvr_reset_control.sv" SYSTEM_VERILOG PATH "../ilk_pcs/altera_xcvr_reset_control.sv"  
          add_fileset_file "../ilk_pcs/tx_fifo_write.sv" SYSTEM_VERILOG PATH "../ilk_pcs/tx_fifo_write.sv"  			  
           # add_fileset_file "../ilk_pcs/alt_xcvr_resync.sv" SYSTEM_VERILOG PATH "../ilk_pcs/alt_xcvr_resync.sv"  
           # add_fileset_file "../ilk_pcs/altera_xcvr_functions.sv" SYSTEM_VERILOG PATH "../ilk_pcs/altera_xcvr_functions.sv"
	   # send_message info "******* add reset files in synth  for a10 ***************" 
       } else {
	      add_fileset_file "../ilk_pcs/ilk_pcs_assembly_50g.sv" SYSTEM_VERILOG PATH  "../ilk_pcs/ilk_pcs_assembly_50g.sv" 
          add_fileset_file "../ilk_pcs/ilk_reconfig_bundle_merger.sv" SYSTEM_VERILOG PATH "../ilk_pcs/ilk_reconfig_bundle_merger.sv" 
          add_fileset_file "../ilk_pcs/ilk_reconfig_bundle_to_xcvr.sv" SYSTEM_VERILOG PATH "../ilk_pcs/ilk_reconfig_bundle_to_xcvr.sv"  
          add_fileset_file "../ilk_pcs/sv_ilk_sixpack.sv" SYSTEM_VERILOG PATH "../ilk_pcs/sv_ilk_sixpack.sv" 
       	# send_message info "******* skip adding reset files in synth ***************" 
       }

add_fileset_file "../ilk_oob/ilk_oob_rx/ilk_oob_flow_rx.v" VERILOG PATH "../ilk_oob/ilk_oob_rx/ilk_oob_flow_rx.v" 
add_fileset_file "../ilk_oob/ilk_oob_rx/ilk_oob_flow_rx_dcfifo.v" VERILOG PATH "../ilk_oob/ilk_oob_rx/ilk_oob_flow_rx_dcfifo.v" 
add_fileset_file "../ilk_oob/ilk_oob_tx/ilk_oob_flow_tx.v" VERILOG PATH "../ilk_oob/ilk_oob_tx/ilk_oob_flow_tx.v" 
	   

	   
# ##########################################    Encrypted Eiles    ##########################################    


# #### SYNOPSYS files ####

# ilk_striper/top/synopsys SYSTEM_VERILOG
# add_fileset_file "../synopsys/ilk_striper/ilk_50g_striper/ilk_rx_stripe_adapter.sv" SYSTEM_VERILOG_ENCRYPT PATH "../ilk_striper/ilk_50g_striper/synopsys/ilk_rx_stripe_adapter.sv" SYNOPSYS_SPECIFIC
# add_fileset_file "../synopsys/ilk_striper/ilk_50g_striper/ilk_tx_stripe_adapter.sv" SYSTEM_VERILOG_ENCRYPT PATH "../ilk_striper/ilk_50g_striper/synopsys/ilk_tx_stripe_adapter.sv" SYNOPSYS_SPECIFIC

set files_components_v "ilk_a10mlab.v ilk_aclr_filter.v ilk_add3_cmp3.v ilk_avgzmlab.v ilk_barrel_layer.v ilk_barrel_shift.v ilk_barrelshift_8to1.v ilk_bin_to_asc_hex.v \
    ilk_char_type.v ilk_clock_crossing_fifo.v ilk_compressor_3to2.v ilk_compressor_4to3.v ilk_compressor_5to3.v ilk_compressor_6to3.v ilk_count_to_here_12.v ilk_crc24_dat64_only_flat.v \
    ilk_crc24_multiple_upto2.v ilk_crc24_multiple_upto3.v ilk_crc24_multiple_upto4.v ilk_crc24_multiple_upto5.v ilk_crc24_zer64_flat.v ilk_crc24_zer64x2_flat.v ilk_crc24_zer64x3_flat.v ilk_crc24_zer64x4_flat.v \
    ilk_crc24_zer64x5_flat.v ilk_crc24_zer64x6_flat.v ilk_crc24_zer64x7_flat.v ilk_crc24_zer64x8_flat.v ilk_crc24_zer64x9_flat.v ilk_cross_bus.v ilk_delay_regs.v ilk_eq_5_ena.v ilk_err_handler.v ilk_frequency_monitor.v ilk_gray_cntr_4_sl.v \
    ilk_gray_cntr_5_sl.v ilk_gray_to_bin_5.v ilk_index_with_restart_12.v ilk_index_with_restart_3.v ilk_index_with_restart_6.v ilk_jtag_to_c_probe.v ilk_mult16.v ilk_mx12_ena.v ilk_mx16r.v ilk_mx4r.v ilk_mx8r.v ilk_mx_nto1_r.v \
    ilk_neq_5_ena.v ilk_page_grabber_12.v ilk_pipelined_any_flag.v ilk_priority_12.v ilk_priority_6.v ilk_priority_6_upper.v ilk_pwm9.v ilk_reset_delay.v ilk_rst_ctrl.v ilk_rst_sync.v ilk_rx_buffer_fifo_2.v ilk_s5m20k_ecc_1r1w.v \
    ilk_s5m20k_ecc_off.v ilk_s5m20k_group.v ilk_s5mlab.v ilk_sample_crossdomain.v ilk_scfifo_mlab.v ilk_six_three_comp.v ilk_status_sync.v ilk_sum_of_3bit_pair.v ilk_sync_fifo_mlab.v ilk_sync_regs_aclr_m2.v ilk_tx_buffer_fifo_ram_loose.v \
    ilk_wys_lut.v"

set component_list_synopsys [glob -nocomplain -- -path ../components/synopsys/*.v]    
set length_component_synopsys [llength $component_list_synopsys]
if {$length_component_synopsys > 1} {
  foreach vfile $files_components_v {
       add_fileset_file "../synopsys/components/${vfile}" VERILOG_ENCRYPT PATH "../components/synopsys/${vfile}" SYNOPSYS_SPECIFIC
   }
}
if {$dev_family_S5 } {
add_fileset_file "../synopsys/components/ilk_temp_sense.v" VERILOG_ENCRYPT PATH "../components/synopsys/ilk_temp_sense.v" SYNOPSYS_SPECIFIC
}
set component_list_cadence [glob -nocomplain -- -path ../components/cadence/*.v] 
set length_component_cadence [llength $component_list_synopsys]   
if {$length_component_cadence > 1} {
  foreach vfile $files_components_v {
       add_fileset_file "../cadence/components/${vfile}" VERILOG_ENCRYPT PATH "../components/cadence/${vfile}" CADENCE_SPECIFIC
   }
}

if {$dev_family_S5 } {
add_fileset_file "../cadence/components/ilk_temp_sense.v" VERILOG_ENCRYPT PATH "../components/cadence/ilk_temp_sense.v" CADENCE_SPECIFIC
}

foreach vfile $files_components_v {
       #add_fileset_file "../synopsys/components/${vfile}" VERILOG_ENCRYPT PATH "../components/synopsys/${vfile}" SYNOPSYS_SPECIFIC
       #add_fileset_file "../cadence/components/${vfile}" VERILOG_ENCRYPT PATH "../components/cadence/${vfile}" CADENCE_SPECIFIC
       add_fileset_file "../mentor/components/${vfile}" VERILOG_ENCRYPT PATH "../components/mentor/${vfile}" MENTOR_SPECIFIC
  }

  
if {$dev_family_S5 } {
add_fileset_file "../mentor/components/ilk_temp_sense.v" VERILOG_ENCRYPT PATH "../components/mentor/ilk_temp_sense.v" MENTOR_SPECIFIC
}




set sim_synopsys_dir { "../ilk_50g_regroup/synopsys" "../ilk_50g_mac/synopsys"  "../ilk_striper/top/synopsys" "../ilk_striper/8lane/synopsys" }

set dest_path_sy                "../synopsys"

foreach sim_sy_dir1 $sim_synopsys_dir {
# add everything, including .sv in ilk_pcs
      # replace ../ with / , so "../ilk_regroup/synopsys" become "/ilk_regroup/synopsys"
      regsub ../ $sim_sy_dir1 / tmp01
      # replace /synopsys with /, so "/ilk_regroup/synopsys" become "/ilk_regroup"	  
      regsub /synopsys $tmp01 / individual_dir
               set file_sim_sy_lst [glob -nocomplain -- -path $sim_sy_dir1/*.v]	  
               # windows doesn't have files for synopsys and cadence, so use -nocomplain here
                     foreach file ${file_sim_sy_lst} {
                         # split a string by / and store it in an array(file_string), so split ../dir1/dir2/rtl.v, file_string has .. dir1 dir2 rlt.v
						 set file_string [split $file /]
						 # take the last element from array file_string, which is rtl.v
                         set file_name [lindex $file_string end]  
                         add_fileset_file "$dest_path_sy$individual_dir$file_name" VERILOG_ENCRYPT PATH ${file} SYNOPSYS_SPECIFIC
                     }
     }	

set sim_synopsys_dir_sv { "../ilk_striper/ilk_50g_striper/synopsys" }
set dest_path_sy_sv                "../synopsys"
foreach sim_sy_dir1 $sim_synopsys_dir_sv {
# add everything, including .sv in ilk_pcs
      # replace ../ with / , so "../ilk_regroup/synopsys" become "/ilk_regroup/synopsys"
      regsub ../ $sim_sy_dir1 / tmp01
      # replace /synopsys with /, so "/ilk_regroup/synopsys" become "/ilk_regroup"	  
      regsub /synopsys $tmp01 / individual_dir
               set file_sim_sy_lst [glob -nocomplain -- -path $sim_sy_dir1/*.sv]	  
               # windows doesn't have files for synopsys and cadence, so use -nocomplain here
                     foreach file ${file_sim_sy_lst} {
                         # split a string by / and store it in an array(file_string), so split ../dir1/dir2/rtl.v, file_string has .. dir1 dir2 rlt.v
						 set file_string [split $file /]
						 # take the last element from array file_string, which is rtl.v
                         set file_name [lindex $file_string end]  
                         add_fileset_file "$dest_path_sy_sv$individual_dir$file_name" SYSTEM_VERILOG_ENCRYPT PATH ${file} SYNOPSYS_SPECIFIC
                     }
     }	
# #### CADENCE files ####
	
# ilk_striper/top/cadence SYSTEM_VERILOG
# add_fileset_file "../cadence/ilk_striper/ilk_50g_striper/ilk_rx_stripe_adapter.sv" SYSTEM_VERILOG_ENCRYPT PATH "../ilk_striper/ilk_50g_striper/cadence/ilk_rx_stripe_adapter.sv" CADENCE_SPECIFIC
# add_fileset_file "../cadence/ilk_striper/ilk_50g_striper/ilk_tx_stripe_adapter.sv" SYSTEM_VERILOG_ENCRYPT PATH "../ilk_striper/ilk_50g_striper/cadence/ilk_tx_stripe_adapter.sv" CADENCE_SPECIFIC

set sim_cadence_dir { "../ilk_50g_regroup/cadence" "../ilk_50g_mac/cadence"  "../ilk_striper/top/cadence" "../ilk_striper/8lane/cadence" }

set dest_path_ca                "../cadence"
	
foreach sim_ca_dir1 $sim_cadence_dir {
# add everything, including .sv in ilk_pcs
      # replace ../ with / , so "../ilk_regroup/synopsys" become "/ilk_regroup/synopsys"
      regsub ../ $sim_ca_dir1 / tmp02
      # replace /synopsys with /, so "/ilk_regroup/synopsys" become "/ilk_regroup"	  
      regsub /cadence $tmp02 / individual_dir
	         # windows doesn't have files for synopsys and cadence, so use -nocomplain here
             set file_sim_ca_lst [glob -nocomplain -- -path $sim_ca_dir1/*.v]
                     foreach file ${file_sim_ca_lst} {
                         # split a string by / and store it in an array(file_string), so split ../dir1/dir2/rtl.v, file_string has .. dir1 dir2 rlt.v
						 set file_string [split $file /]
						 # take the last element from array file_string, which is rtl.v
                         set file_name [lindex $file_string end]  
                         add_fileset_file "$dest_path_ca$individual_dir$file_name" VERILOG_ENCRYPT PATH ${file} CADENCE_SPECIFIC
                     }
     }	
set sim_cadence_dir_sv { "../ilk_striper/ilk_50g_striper/cadence" }
set dest_path_ca_sv                "../cadence"
foreach sim_ca_dir1 $sim_cadence_dir_sv {
# add everything, including .sv in ilk_pcs
      # replace ../ with / , so "../ilk_regroup/synopsys" become "/ilk_regroup/synopsys"
      regsub ../ $sim_ca_dir1 / tmp02
      # replace /synopsys with /, so "/ilk_regroup/synopsys" become "/ilk_regroup"	  
      regsub /cadence $tmp02 / individual_dir
	         # windows doesn't have files for synopsys and cadence, so use -nocomplain here
             set file_sim_ca_lst [glob -nocomplain -- -path $sim_ca_dir1/*.sv]
                     foreach file ${file_sim_ca_lst} {
                         # split a string by / and store it in an array(file_string), so split ../dir1/dir2/rtl.v, file_string has .. dir1 dir2 rlt.v
						 set file_string [split $file /]
						 # take the last element from array file_string, which is rtl.v
                         set file_name [lindex $file_string end]  
                         add_fileset_file "$dest_path_ca_sv$individual_dir$file_name" SYSTEM_VERILOG_ENCRYPT PATH ${file} CADENCE_SPECIFIC
                     }
     }	

	 	 
# set sim_bottom_level_dir {"../ilk_regroup/cadence" "../ilk_regroup/mentor" "../ilk_100g_mac/cadence" "../ilk_100g_mac/mentor" 
# "../ilk_striper/top/cadence" "../ilk_striper/top/mentor"  "../ilk_oob/ilk_oob_rx/cadence"  "../ilk_oob/ilk_oob_rx/mentor"  
# "../ilk_oob/ilk_oob_tx/cadence" "../ilk_oob/ilk_oob_tx/mentor" }

# #### MENTOR files ####
	
# ilk_striper/top/mentor SYSTEM_VERILOG
add_fileset_file "../mentor/ilk_striper/ilk_50g_striper/ilk_rx_stripe_adapter.sv" SYSTEM_VERILOG_ENCRYPT PATH "../ilk_striper/ilk_50g_striper/mentor/ilk_rx_stripe_adapter.sv" MENTOR_SPECIFIC
add_fileset_file "../mentor/ilk_striper/ilk_50g_striper/ilk_tx_stripe_adapter.sv" SYSTEM_VERILOG_ENCRYPT PATH "../ilk_striper/ilk_50g_striper/mentor/ilk_tx_stripe_adapter.sv" MENTOR_SPECIFIC

set sim_mentor_dir { "../ilk_50g_regroup/mentor" "../ilk_50g_mac/mentor" "../ilk_striper/top/mentor" "../ilk_striper/8lane/mentor" }

set dest_path_me "../mentor"
	
foreach sim_me_dir1 $sim_mentor_dir {
# add everything, including .sv in ilk_pcs
      # replace ../ with / , so "../ilk_regroup/mentor" become "/ilk_regroup/mentor"
      regsub ../ $sim_me_dir1 / tmp03
      # replace /mentor with /, so "/ilk_regroup/mentor" become "/ilk_regroup"	  
      regsub /mentor $tmp03 / individual_dir
	  
             set file_sim_me_lst [glob -- -path $sim_me_dir1/*.v]
                     foreach file ${file_sim_me_lst} {
                         # split a string by / and store it in an array(file_string), so split ../dir1/dir2/rtl.v, file_string has .. dir1 dir2 rlt.v
						 set file_string [split $file /]
						 # take the last element from array file_string, which is rtl.v
                         set file_name [lindex $file_string end]  
                         add_fileset_file "$dest_path_me$individual_dir$file_name" VERILOG_ENCRYPT PATH ${file} MENTOR_SPECIFIC
                     }
     }	

  if {$dev_family_a10} {
       set params(top_level_name)                  $outputName
       set top_file_name   $outputName.sv
	   set params(family)                                [get_parameter_value DEVICE_FAMILY]
       set params(data_rate_mbps)                        [get_parameter_value DATA_RATE]
	   set params(mm_clk_khz)						     [get_parameter_value MM_CLK_KHZ]
	   set params(pll_refclk_freq)						 [get_parameter_value PLL_REFCLK_FREQ]
       set params(num_lanes)                             [get_parameter_value NUM_LANES]
       set params(tx_pkt_mode)                           [get_parameter_value TX_PKTMOD_ONLY]
       set params(calendar_pages)                        [get_parameter_value CALENDAR_PAGES]
	   set params(rxfifo_addr_width)					 [get_parameter_value RXFIFO_ADDR_WIDTH]
	   set params(internal_words)						 [get_parameter_value INTERNAL_WORDS]
       set params(meta_frame)                            [get_parameter_value METALEN]   
       interpret_terp $top_file_name  ilk_core_50g_a10.sv.terp  [array get params]
  } else {
    add_fileset_file ilk_core_50g.sv SYSTEM_VERILOG PATH ilk_core_50g.sv
  }

   send_message PROGRESS "sim_proc done" 

}

proc add_pcs_lib {} {

send_message PROGRESS "running add_pcs_lib" 

add_fileset_file "./pcs_lib/sv_xcvr_h.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/sv_xcvr_h.sv"
add_fileset_file "./pcs_lib/alt_xcvr_csr_common_h.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/ctrl/alt_xcvr_csr_common_h.sv"
add_fileset_file "./pcs_lib/altera_xcvr_functions.sv" SYSTEM_VERILOG PATH "../../altera_xcvr_generic/altera_xcvr_functions.sv"

add_fileset_file "./pcs_lib/sv_hssi_10g_rx_pcs_rbc.sv" SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/rbc/sv_hssi_10g_rx_pcs_rbc.sv"
add_fileset_file "./pcs_lib/sv_hssi_10g_tx_pcs_rbc.sv" SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/rbc/sv_hssi_10g_tx_pcs_rbc.sv"
add_fileset_file "./pcs_lib/sv_hssi_common_pcs_pma_interface_rbc.sv" SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/rbc/sv_hssi_common_pcs_pma_interface_rbc.sv"
add_fileset_file "./pcs_lib/sv_hssi_common_pld_pcs_interface_rbc.sv" SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/rbc/sv_hssi_common_pld_pcs_interface_rbc.sv"
add_fileset_file "./pcs_lib/sv_hssi_rx_pcs_pma_interface_rbc.sv" SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/rbc/sv_hssi_rx_pcs_pma_interface_rbc.sv"
add_fileset_file "./pcs_lib/sv_hssi_rx_pld_pcs_interface_rbc.sv" SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/rbc/sv_hssi_rx_pld_pcs_interface_rbc.sv"
add_fileset_file "./pcs_lib/sv_hssi_tx_pcs_pma_interface_rbc.sv" SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/rbc/sv_hssi_tx_pcs_pma_interface_rbc.sv"
add_fileset_file "./pcs_lib/sv_hssi_tx_pld_pcs_interface_rbc.sv" SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/rbc/sv_hssi_tx_pld_pcs_interface_rbc.sv"

add_fileset_file "./pcs_lib/sv_pcs_ch.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/sv_pcs_ch.sv"
add_fileset_file "./pcs_lib/sv_pcs.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/sv_pcs.sv"
add_fileset_file "./pcs_lib/sv_pma.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/sv_pma.sv"
add_fileset_file "./pcs_lib/sv_reconfig_bundle_merger.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/sv_reconfig_bundle_merger.sv"
add_fileset_file "./pcs_lib/sv_reconfig_bundle_to_xcvr.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/sv_reconfig_bundle_to_xcvr.sv"
add_fileset_file "./pcs_lib/sv_reconfig_bundle_to_ip.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/sv_reconfig_bundle_to_ip.sv"

add_fileset_file "./pcs_lib/sv_rx_pma.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/sv_rx_pma.sv"
add_fileset_file "./pcs_lib/sv_tx_pma_ch.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/sv_tx_pma_ch.sv"
add_fileset_file "./pcs_lib/sv_tx_pma.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/sv_tx_pma.sv"

add_fileset_file "./pcs_lib/sv_xcvr_avmm_csr.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/sv_xcvr_avmm_csr.sv"
add_fileset_file "./pcs_lib/sv_xcvr_avmm_dcd.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/sv_xcvr_avmm_dcd.sv"
add_fileset_file "./pcs_lib/sv_xcvr_avmm.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/sv_xcvr_avmm.sv"

add_fileset_file "./pcs_lib/alt_xcvr_csr_common.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/ctrl/alt_xcvr_csr_common.sv"
add_fileset_file "./pcs_lib/alt_xcvr_csr_pcs8g_h.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/ctrl/alt_xcvr_csr_pcs8g_h.sv"
add_fileset_file "./pcs_lib/alt_xcvr_csr_pcs8g.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/ctrl/alt_xcvr_csr_pcs8g.sv"
add_fileset_file "./pcs_lib/alt_xcvr_csr_selector.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/ctrl/alt_xcvr_csr_selector.sv"

add_fileset_file "./pcs_lib/alt_xcvr_mgmt2dec.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/ctrl/alt_xcvr_mgmt2dec.sv"
add_fileset_file "./pcs_lib/altera_wait_generate.v"  VERILOG PATH "../../altera_xcvr_generic/ctrl/altera_wait_generate.v"
add_fileset_file "./pcs_lib/alt_xcvr_interlaken_amm_slave.v"  VERILOG PATH "../../alt_interlaken/alt_interlaken_pcs_sv/alt_xcvr_interlaken_amm_slave.v"
add_fileset_file "./pcs_lib/alt_xcvr_interlaken_soft_pbip.sv"  SYSTEM_VERILOG PATH "../../alt_interlaken/alt_interlaken_pcs_sv/alt_xcvr_interlaken_soft_pbip.sv"

add_fileset_file "./pcs_lib/sv_xcvr_interlaken_native.sv"  SYSTEM_VERILOG PATH "../../alt_interlaken/alt_interlaken_pcs_sv/sv_xcvr_interlaken_native.sv"
add_fileset_file "./pcs_lib/sv_xcvr_interlaken_nr.sv"  SYSTEM_VERILOG PATH "../../alt_interlaken/alt_interlaken_pcs_sv/sv_xcvr_interlaken_nr.sv"
add_fileset_file "./pcs_lib/altera_xcvr_interlaken.sv"  SYSTEM_VERILOG PATH "../../alt_interlaken/alt_interlaken_pcs/altera_xcvr_interlaken.sv"
add_fileset_file "./pcs_lib/altera_xcvr_reset_control.sv"  SYSTEM_VERILOG PATH "../../alt_xcvr/altera_xcvr_reset_control/altera_xcvr_reset_control.sv"
add_fileset_file "./pcs_lib/alt_xcvr_reset_counter.sv" SYSTEM_VERILOG PATH "../../alt_xcvr/altera_xcvr_reset_control/alt_xcvr_reset_counter.sv"

add_fileset_file "./pcs_lib/alt_xcvr_resync.sv" SYSTEM_VERILOG PATH "../../altera_xcvr_generic/ctrl/alt_xcvr_resync.sv"
add_fileset_file "./pcs_lib/sv_xcvr_native.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/sv_xcvr_native.sv"
add_fileset_file "./pcs_lib/sv_xcvr_plls.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/sv_xcvr_plls.sv"

add_fileset_file "./pcs_lib/sv_xcvr_data_adapter.sv"  SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/sv_xcvr_data_adapter.sv"

add_fileset_file "./pcs_lib/sv_hssi_8g_pcs_aggregate_rbc.sv" SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/rbc/sv_hssi_8g_pcs_aggregate_rbc.sv"
add_fileset_file "./pcs_lib/sv_hssi_8g_rx_pcs_rbc.sv" SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/rbc/sv_hssi_8g_rx_pcs_rbc.sv"
add_fileset_file "./pcs_lib/sv_hssi_8g_tx_pcs_rbc.sv" SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/rbc/sv_hssi_8g_tx_pcs_rbc.sv"

# add_fileset_file "./pcs_lib/sv_hssi_pipe_gen1_2_rbc.sv" SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/rbc/sv_hssi_pipe_gen1_2_rbc.sv"
# add_fileset_file "./pcs_lib/sv_hssi_pipe_gen3_rbc.sv" SYSTEM_VERILOG PATH "../../altera_xcvr_generic/sv/rbc/sv_hssi_pipe_gen3_rbc.sv"

send_message PROGRESS "finish adding pcs_lib" 
}

# Callback to force options in the GUI
proc choose_EXAMPLE_DESIGN_SYNTH_FILES_callback { EXAMPLE_DESIGN_SYNTH_FILES } {    
    if {[string match [get_parameter_value EXAMPLE_DESIGN_SYNTH_FILES] "true"] == 1} {
        set_parameter_value BOARD_SELECTION "Arria 10 GX Transceiver Signal Integrity Development Kit"
		set_parameter_property BOARD_SELECTION ENABLED true
    } else {
        set_parameter_value BOARD_SELECTION "None"
		set_parameter_property BOARD_SELECTION ENABLED false
    }
}

proc upgrade_proc  {ip_core_type version parameters} {
	if {$ip_core_type == "ilk_core_50g"} {
        send_message info "******* this is ilk core 50g ***************"
        set my_parameters [get_parameters]	

	    foreach { name value } $parameters {
		    if {[lsearch $my_parameters $name] == -1} {
			# If the parameter no longer exists and is not applicable, then do nothing
			} else {
			# if the parameter exists and interpretation has not changed, then set it directly
			    set_parameter_value $name $value
			}
        }

    }	

}

proc example_design_ver {outputName} {
	set dev_family [get_parameter_value DEVICE_FAMILY]
    set dev_family_S5 [check_device_family_equivalence $dev_family {"Stratix V"} ]
    set dev_family_A5 [check_device_family_equivalence $dev_family {"Arria V GZ"}]
    set dev_family_a10 [check_device_family_equivalence $dev_family {"Arria 10"} ]
	
	if { [string match [get_parameter_value EXAMPLE_DESIGN_SYNTH_FILES] "false"] == 1 } {
       if { [string match [get_parameter_value EXAMPLE_DESIGN_SIM_FILES] "false"] == 1 } {
            send_message ERROR "Neither \"Simulation\" nor \"Synthesis\" check boxes from \"Example Design Files\" are selected to allow generation of Example Design Files."
            return
        }
    }
	
	if {$dev_family_a10} {
        example_design_a10_board_level $outputName
      } else {
        testbench_ver $outputName
    }
}


proc example_design_a10_board_level {outputName} {

send_message INFO "Inside example design a10 board level"

	set dev_family [get_parameter_value DEVICE_FAMILY]
    set dev_family_S5 [check_device_family_equivalence $dev_family {"Stratix V"} ]
    set dev_family_A5 [check_device_family_equivalence $dev_family {"Arria V GZ"}]
    set dev_family_a10 [check_device_family_equivalence $dev_family {"Arria 10"} ]
    set params(top_level_name)                  $outputName
	set num_of_lanes_tb [get_parameter_value NUM_LANES]
	set data_rate_tb [get_parameter_value DATA_RATE]
    set lane_profile_tb [get_parameter_value LANE_PROFILE]
    set int_tx_clk_div_tb [get_parameter_value INT_TX_CLK_DIV]
	set num_calendar_pgs_tb [get_parameter_value CALENDAR_PAGES]
    set log_num_calendar_pgs_tb [get_parameter_value LOG_CALENDAR_PAGES]
    set tx_packet_mode_tb [get_parameter_value TX_PKTMOD_ONLY]
    set pll_out_freq_tb [get_parameter_value PLL_OUT_FREQ]
   ## set metalen_tb [get_parameter_value METALEN]
	set pll_refclk_tb [get_parameter_value PLL_REFCLK_FREQ]
	set example_synth_file [get_parameter_value EXAMPLE_DESIGN_SYNTH_FILES]
	set example_sim_file   [get_parameter_value EXAMPLE_DESIGN_SIM_FILES]

	# # # terp simulation top level file
    set template "../testbench/example_design_50g_a10_board_level/top_tb.sv.terp"

    set template_fd [open $template "r"]
    set template_contents [read $template_fd]
    
	### Don't put white space between variable_to_values and parenthese, otherwise it won't work
	set variable_to_values(family_select) \"$dev_family\"
    set variable_to_values(tx_packet_mode) $tx_packet_mode_tb
    set variable_to_values(num_lane) $num_of_lanes_tb
    set variable_to_values(data_rate) \"$data_rate_tb\"
    set variable_to_values(lane_profile) $lane_profile_tb
    set variable_to_values(clk_div) $int_tx_clk_div_tb
    set variable_to_values(pll_out_freq) \"$pll_out_freq_tb\"
    ##set variable_to_values(metalen) $metalen_tb
	set variable_to_values(tx_pakect_only) $tx_packet_mode_tb
	set variable_to_values(pll_ref_clk_freq) \"$pll_refclk_tb\"
	# set variable_to_values(rx_dual_segment) $rx_dual_seg_tb
	set variable_to_values(cal_pages) $num_calendar_pgs_tb	
	set variable_to_values(log_cal_pages) $log_num_calendar_pgs_tb
	
    set contents [altera_terp $template_contents variable_to_values]
	# write out to be a systemverilog file
    add_fileset_file "../example_design_a10/rtl/top_tb.sv" SYSTEM_VERILOG TEXT  $contents
	
	# # # terp synthesis top level file
    set template "../testbench/example_design_50g_a10_board_level/example_design.sv.terp"
    set template_fd [open $template "r"]
    set template_contents [read $template_fd]
    set contents [altera_terp $template_contents variable_to_values]
    add_fileset_file "../example_design_a10/rtl/example_design.sv" SYSTEM_VERILOG TEXT  $contents

	add_fileset_file "../example_design_a10/rtl/ilk_pkt_gen.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_50g_a10_board_level/ilk_pkt_gen.sv" 
	add_fileset_file "../example_design_a10/rtl/ilk_pkt_checker.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_50g_a10_board_level/ilk_pkt_checker.sv" 
	add_fileset_file "../example_design_a10/rtl/test_agent.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_50g_a10_board_level/test_agent.sv" 
	add_fileset_file "../example_design_a10/rtl/test_env.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_50g_a10_board_level/test_env.sv" 
	add_fileset_file "../example_design_a10/rtl/test_host.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_50g_a10_board_level/test_host.sv" 
	add_fileset_file "../example_design_a10/rtl/test_infra.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_50g_a10_board_level/test_infra.sv" 
	add_fileset_file "../example_design_a10/rtl/test_dut.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_50g_a10_board_level/test_dut.sv" 
	add_fileset_file "../example_design_a10/rtl/one_shot.v" VERILOG PATH  "../testbench/example_design_50g_a10_board_level/one_shot.v" 
	add_fileset_file "../example_design_a10/rtl/ilk_top.v" VERILOG PATH  "../testbench/example_design_50g_a10_board_level/ilk_top.v" 

    if {$example_sim_file} {
	add_fileset_file "../example_design_a10/testbench/vcstest.sh" OTHER PATH  "../testbench/example_design_50g_a10_board_level/vcstest.sh" 
	add_fileset_file "../example_design_a10/testbench/ncsim.sh" OTHER PATH  "../testbench/example_design_50g_a10_board_level/ncsim.sh" 
	add_fileset_file "../example_design_a10/testbench/vlog_pro.do" OTHER PATH  "../testbench/example_design_50g_a10_board_level/vlog_pro.do" 
	add_fileset_file "../example_design_a10/testbench/vlog.do" OTHER PATH  "../testbench/example_design_50g_a10_board_level/vlog.do" 
    }

	if { [string match [get_parameter_value BOARD_SELECTION] "Arria 10 GX Transceiver Signal Integrity Development Kit"] == 1 } { 
        set device "10AX115S3F45I2SG"
    } elseif { [string match [get_parameter_value BOARD_SELECTION] "Arria 10 GX Transceiver Signal Integrity Development Kit (ES)"] == 1 } { 
        set device "10AX115S3F45I2SGE2"
    } else {
	    set device [get_parameter_value part_trait_device]
    }
	
	set params(device_part)                     $device	
		
    if {$example_synth_file} {
	add_fileset_file "../example_design_a10/quartus/example_design.sdc" SDC PATH  "../testbench/example_design_50g_a10_board_level/example_design.sdc" 
	add_fileset_file "../example_design_a10/quartus/jtag_timing_template.sdc" SDC PATH  "../testbench/example_design_50g_a10_board_level/jtag_timing_template.sdc" 

	add_fileset_file "../example_design_a10/quartus/example_design.qpf" OTHER PATH  "../testbench/example_design_50g_a10_board_level/example_design.qpf" 
	add_fileset_file "../example_design_a10/hwtest/sysconsole_testbench.tcl" OTHER PATH  "../testbench/example_design_50g_a10_board_level/sysconsole_testbench.tcl" 
       if { [string match [get_parameter_value BOARD_SELECTION] "None"] == 1 } { 
           interpret_terp ../example_design_a10/quartus/example_design.qsf         ../testbench/example_design_50g_a10_board_level/example_design_8lx6g_virtual.qsf.terp       [array get params] "OTHER" 
	   } else {
          interpret_terp ../example_design_a10/quartus/example_design.qsf         ../testbench/example_design_50g_a10_board_level/example_design_8lx6g.qsf.terp       [array get params] "OTHER"
       }
	}

	set std_edition "QUARTUS_PRIME_STANDARD"
    set std_edition_true [is_software_edition $std_edition]
    if {$std_edition_true} {
	  # send_message INFO "*************** This is Quartus Standard ******************"
      gen_core_in_example_design_std
    } else {
	  # send_message INFO "*************** This is Quartus Pro      ******************"
	  gen_core_in_example_design_pro
    }

send_message PROGRESS "Finish adding example design" 

}


proc testbench_ver {outputName} {


# ##################################################################

	set dev_family [get_parameter_value DEVICE_FAMILY]
    set dev_family_S5 [check_device_family_equivalence $dev_family {"Stratix V"} ]
    set dev_family_A5 [check_device_family_equivalence $dev_family {"Arria V GZ"}]
    set dev_family_a10 [check_device_family_equivalence $dev_family {"Arria 10"} ]
	
    set params(top_level_name)                  $outputName
	set num_of_lanes_tb [get_parameter_value NUM_LANES]
	set data_rate_tb [get_parameter_value DATA_RATE]
    # set lane_profile_tb [get_parameter_value LANE_PROFILE]
    set int_tx_clk_div_tb [get_parameter_value INT_TX_CLK_DIV]
	set num_calendar_pgs_tb [get_parameter_value CALENDAR_PAGES]
    set log_num_calendar_pgs_tb [get_parameter_value LOG_CALENDAR_PAGES]
    set tx_packet_mode_tb [get_parameter_value TX_PKTMOD_ONLY]
    set pll_out_freq_tb [get_parameter_value PLL_OUT_FREQ]
   ## set metalen_tb [get_parameter_value METALEN]
	set pll_refclk_tb [get_parameter_value PLL_REFCLK_FREQ]
	# set rx_dual_seg_tb [get_parameter_value RX_DUAL_SEG]

	## the top_tb is changed to txt file extension to bypass make check
	if {$dev_family_a10} {
            set template "../testbench/example_design_50g_a10/top_tb.txt"
      } else {
    set template "../testbench/example_design_50g/top_tb.txt"
    }
    set template_fd [open $template "r"]
    set template_contents [read $template_fd]
    
	### Don't put white space between variable_to_values and parenthese, otherwise it won't work
	set variable_to_values(family_select) \"$dev_family\"
    set variable_to_values(tx_packet_mode) $tx_packet_mode_tb
    set variable_to_values(num_lane) $num_of_lanes_tb
    set variable_to_values(data_rate) \"$data_rate_tb\"
    # set variable_to_values(lane_profile) $lane_profile_tb
    set variable_to_values(clk_div) $int_tx_clk_div_tb
    set variable_to_values(pll_out_freq) \"$pll_out_freq_tb\"
    ##set variable_to_values(metalen) $metalen_tb
	set variable_to_values(tx_pakect_only) $tx_packet_mode_tb
	set variable_to_values(pll_ref_clk_freq) \"$pll_refclk_tb\"
	# set variable_to_values(rx_dual_segment) $rx_dual_seg_tb
	set variable_to_values(cal_pages) $num_calendar_pgs_tb	
	set variable_to_values(log_cal_pages) $log_num_calendar_pgs_tb
	
    set contents [altera_terp $template_contents variable_to_values]
	# write out to be a systemverilog file
    add_fileset_file "../testbench/top_tb.sv" SYSTEM_VERILOG TEXT  $contents

  	 if {$dev_family_a10 } {
         add_fileset_file "../testbench/ilk_pkt_gen.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_50g_a10/ilk_pkt_gen.sv" 
         add_fileset_file "../testbench/ilk_pkt_checker.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_50g_a10/ilk_pkt_checker.sv" 
         
         interpret_terp ../testbench/example_design.sv  ../testbench/example_design_50g_a10/example_design.sv.terp  [array get params]
         #add_fileset_file "../testbench/example_design.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_50g_a10/example_design.sv"
         add_fileset_file "../testbench/vlog.do" OTHER PATH  "../testbench/example_design_50g_a10/vlog.do" 
      
	     interpret_terp ../example_design_hw/example_design.sv ../testbench/example_design_hw_a10/example_design_50g.sv.terp [array get params] 
	     add_fileset_file "../example_design_hw/example_gen.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_hw_a10/example_gen.sv"
         add_fileset_file "../example_design_hw/example_chk.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_hw_a10/example_chk.sv"
         add_fileset_file "../example_design_hw/example_host.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_hw_a10/example_host.sv"
		 add_fileset_file "../example_design_hw/example_design.qpf" OTHER PATH  "../testbench/example_design_hw_a10/example_design.qpf"  
		 add_fileset_file "../example_design_hw/example_design.qsf" OTHER PATH  "../testbench/example_design_hw_a10/example_design_50G.qsf"  
         add_fileset_file "../example_design_hw/example_design.sdc" SDC PATH  "../testbench/example_design_hw_a10/example_design.sdc"  
         add_fileset_file "../example_design_hw/test_top.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_hw_a10/test_top_50G.sv" 

	  } else {
    add_fileset_file "../testbench/ilk_pkt_gen.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_50g/ilk_pkt_gen.sv" 
    add_fileset_file "../testbench/ilk_pkt_checker.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_50g/ilk_pkt_checker.sv" 
    add_fileset_file "../testbench/example_design.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_50g/example_design.sv"
    
    add_fileset_file "../testbench/vlog.do" OTHER PATH  "../testbench/example_design_50g/vlog.do" 
    }

    send_message PROGRESS "Finish adding example design" 
	
    set std_edition "QUARTUS_PRIME_STANDARD"
    set std_edition_true [is_software_edition $std_edition]
    if {$std_edition_true} {
	  # send_message INFO "*************** This is Quartus Standard ******************"
      gen_core_in_example_design_std
    } else {
	  # send_message INFO "*************** This is Quartus Pro      ******************"
	  gen_core_in_example_design_pro
    }

send_message PROGRESS "Finish adding example design" 



}

proc gen_core_in_example_design_pro {} {

    set DEVICE_FAMILY [get_parameter_value DEVICE_FAMILY]
    set ip_type            ilk_core_50g
    set device              [get_part_number_pro]
    set FAMILY [get_parameter_value FAMILY]
	
    set dev_family [get_parameter_value DEVICE_FAMILY]
    set dev_family_S5 [check_device_family_equivalence $dev_family {"Stratix V"} ]
    set dev_family_A5 [check_device_family_equivalence $dev_family {"Arria V GZ"}]
    set dev_family_a10 [check_device_family_equivalence $dev_family {"Arria 10"} ]

	set variant "ilk_50g"
	
    set templocation [create_temp_file "${variant}_gen.tcl"]
    set tempdir [file dirname $templocation]

    # Get a list of parameter value pairs. Ex: {ADME_ENABLE=1 PREAMBLE_PASS=0 ... }
    set parameters [generate_parameter_value_pairs_pro [get_parameters]]
    # Use parameter list to generate copy of IP
    # generate_ip_core_pro $ip_type $variant "Stratix 10" $device $tempdir true $parameters
    generate_ip_core_pro $ip_type $variant $dev_family $device $tempdir true $parameters

    # Copy files from temp directory to project directory
    add_fileset_file "./${variant}.ip" OTHER PATH "${tempdir}/${variant}.ip"
    set fl [findFiles_pro ${tempdir}/${variant}]
    foreach file $fl {
        set f_path [string map [list ${tempdir} ""] $file]
        add_fileset_file "./$f_path" OTHER PATH $file
    }
}

proc get_part_number_pro {} {
    set dev_family [get_parameter_value DEVICE_FAMILY]
    set dev_family_S5 [check_device_family_equivalence $dev_family {"Stratix V"} ]
    set dev_family_A5 [check_device_family_equivalence $dev_family {"Arria V GZ"}]
    set dev_family_a10 [check_device_family_equivalence $dev_family {"Arria 10"} ]
	
	if {$dev_family_S5} {
		return 5SGXEA5N1F45C2
		send_message info "S5 selected"
    } elseif {$dev_family_A5 } {
	    return AGZME1H2F35I3L 
		send_message info "Arria 5 GZ selected"
    } elseif {$dev_family_a10} {
	   	return 10AX115S3F45I2SG 
        send_message info "Arria 10 selected"		
	} else {
		send_message error "Device is not supported. Please select Stratix V, Arria V GZ or Arria 10 "
	}	
	
	
}


    # Generates an ip core
    # Example usage to generate 40g ultra ethernet core
    # and place it in the current directory
    #
    # lappend parameters "SPEED_CONFIG=\"40 GbE\""
    # ::ethernet::tools::generate_ip_core_pro alt_eth_ultra ex_40g "Arria 10" 10AX115S2F45I2SG "." true $parameters
    proc generate_ip_core_pro {ip_name ip_core_name family device path gen_rtl {parameter_list {}}} {
        set ip_inst_name ${ip_name}_0; # IP instantiation name
        set qsysfile_generation_script ${path}/${ip_core_name}.tcl; #Tcl file for generating qsys file
        set fileId [open $qsysfile_generation_script "w"]

        puts $fileId "package require -exact qsys 16.1"
        puts $fileId "create_system ${ip_core_name}"
        puts $fileId "add_instance ${ip_inst_name} ${ip_name}"
        puts $fileId "set_instance_property ${ip_inst_name} AUTO_EXPORT 1"
        foreach item $parameter_list {
            set pair  [split  $item =]
            set param [lindex $pair 0]
            set val   [lindex $pair 1]
            puts $fileId "set_instance_parameter_value ${ip_inst_name} $param $val"
        }

        puts $fileId "set_project_property DEVICE_FAMILY \"${family}\""
        puts $fileId "set_project_property DEVICE ${device}"
        puts $fileId "save_system ${path}/${ip_core_name}.ip"
        close $fileId

        qsys_file_generate_pro ${path} ${ip_core_name}

        if {$gen_rtl == true} {
            local_qsysgenerate_pro ${path} ${ip_core_name} "./${ip_core_name}"
        }

        file delete -force $qsysfile_generation_script
    }

    proc qsys_file_generate_pro { filepath qsysname} {
        set ip_generation_script ${filepath}/${qsysname}_gen.tcl
        set fh [open ${ip_generation_script} w]
        set qdir $::env(QUARTUS_ROOTDIR)

        set cmd "${qdir}/sopc_builder/bin/qsys-script"
        set cmd "${cmd} --pro"
        set cmd "${cmd} --script=${filepath}/${qsysname}.tcl\n"
        puts $fh "catch \{eval \[exec ${cmd}\]\} temp"
        puts $fh "puts \$temp"
        close $fh

        set result [source ${ip_generation_script}]
        file delete -force ${ip_generation_script}
        puts "run_tclsh_script result:${result}"
    }


    proc local_qsysgenerate_pro { filepath qsysname subdir} {
        set ip_generation_script ${filepath}/${qsysname}_gen.tcl
        set fh [open ${ip_generation_script} w]
        set qdir $::env(QUARTUS_ROOTDIR)

        set cmd "${qdir}/sopc_builder/bin/qsys-generate"
        set cmd "${cmd} ${filepath}/${qsysname}.ip"
        set cmd "${cmd} --output-directory=${filepath}/${subdir}"
        set cmd "${cmd} --synthesis=VERILOG"
        set cmd "${cmd} --simulation=VERILOG"
        puts $fh "catch \{eval \[exec ${cmd}\]\} temp"
        puts $fh "puts \$temp"
        close $fh

        set result [source ${ip_generation_script}]
        file delete -force ${ip_generation_script}
        puts "run_tclsh_script result:${result}"
    }

    proc generate_parameter_value_pairs_pro {parameters} {
        foreach p $parameters {
            if {[get_parameter_property $p DERIVED] == 0} {
                set val \"[get_parameter_value $p]\"
                if {$p != "DEVICE_FAMILY" && $p != "DEVICE"} {
                    lappend parameter_pairs ${p}=${val}
                }
            }
        }
        return $parameter_pairs
    }

# -------------------------------------------------------------
# This function returns a list of all files in a directory tree
# -------------------------------------------------------------
proc findFiles_pro { path } {
    set filelist {}
    # grab files and directories that exist at this level
    set file_lst [glob -nocomplain -directory $path -- *]
    
    # move systemverilog headers to front
    set idxs [lsearch -glob -all $file_lst *_h.sv]
    foreach idx $idxs {
        set f [lindex $file_lst $idx]
        set file_lst [lreplace $file_lst $idx $idx]
        set file_lst [linsert $file_lst 0 $f]
    }

    # move VHDL packages to front
    set vhd_pkgs [list *rsx_roots.vhd *package.vhd *functions.vhd *parameters.vhd ]
    foreach pkg $vhd_pkgs {
        set idxs [lsearch -glob -all $file_lst $pkg]
        foreach idx $idxs {
            set f [lindex $file_lst $idx]
            set file_lst [lreplace $file_lst $idx $idx]
            set file_lst [linsert $file_lst 0 $f]
        }
    }

    # for each file or directory
    foreach file ${file_lst} {   
        if {[file isdirectory $file] == 1} {
            # if its a directory call findFiles on that directory and append output to list
            set filelist [join [list $filelist [findFiles_pro $path/[file tail $file]]]]
        } else {
            # if its a file append file location to list, ignore qsys files
            if {![regexp {.*\.qsys$} $file]} {
            lappend filelist $path/[file tail $file]
        }
    }
    }
    # return the list
    return $filelist
}



# #######----------------------------------------------------------------------------------------------
# #######------------- Quartus Standard core generateion in example design ----------------------------
# #######----------------------------------------------------------------------------------------------

proc gen_core_in_example_design_std {} {

    set DEVICE_FAMILY [get_parameter_value DEVICE_FAMILY]
    set FAMILY [get_parameter_value FAMILY]
	
	set dev_family [get_parameter_value DEVICE_FAMILY]
    set dev_family_S5 [check_device_family_equivalence $dev_family {"Stratix V"} ]
    set dev_family_A5 [check_device_family_equivalence $dev_family {"Arria V GZ"}]
    set dev_family_a10 [check_device_family_equivalence $dev_family {"Arria 10"} ]
	set BOARD_SELECTION [get_parameter_value BOARD_SELECTION]
    set device [get_parameter_value DEVICE]
	
	set variant "ilk_50g"
	
    set templocation [create_temp_file "${variant}_gen.tcl"]
    
    set fileId [open [file dirname $templocation]/${variant}.tcl "w"]
    puts $fileId "package require -exact qsys 15.1"
    puts $fileId "create_system ${variant}"
    puts $fileId "add_instance ${variant}_inst ilk_core_50g"
    puts $fileId "set_instance_property ${variant}_inst autoexport 1"
    
    foreach p [get_parameters] {
        if {[get_parameter_property $p DERIVED] == 0} {
            set val \"[get_parameter_value $p]\"
            if {$p != "DEVICE_FAMILY" && $p != "DEVICE"} {
                puts $fileId "set_instance_parameter_value ${variant}_inst $p $val"
            }
        }
    }
		

	if { $BOARD_SELECTION == "None" } {
	  puts $fileId "set_project_property DEVICE $device"
	} else {	
	  if {$dev_family_S5} {
        puts $fileId "set_project_property DEVICE_FAMILY \"Stratix V\""
        puts $fileId "set_project_property DEVICE 5SGXEA5N1F45C2"
		send_message info "S5 selected"
      } elseif {$dev_family_A5 } {
	    puts $fileId "set_project_property DEVICE_FAMILY \"Arria V GZ\""
        puts $fileId "set_project_property DEVICE 5AGZME1H2F35I3L" 
		send_message info "Arria 5 GZ selected"
      } elseif {$dev_family_a10} {
	   	puts $fileId "set_project_property DEVICE_FAMILY \"Arria 10\""
        puts $fileId "set_project_property DEVICE 10AX115S3F45I2SG" 
        send_message info "Arria 10 selected"		
      } else {
		send_message error "Device is not supported. Please select Stratix V, Arria V GZ or Arria 10 "
	  }	
	}
 
    puts $fileId "save_system [file dirname $templocation]/${variant}.qsys"
    close $fileId

    local_qsysgenerate_std [file dirname $templocation] ${variant}_gen.tcl ${variant} "./${variant}"
    
    add_fileset_file "./${variant}.qsys" OTHER PATH "[file dirname $templocation]/${variant}.qsys"

}

proc local_qsysgenerate_std { filepath filename qsysname subdir} {
  
  set fh [open $filepath/$filename w]
  
  set qdir $::env(QUARTUS_ROOTDIR)
  set cmd "${qdir}/sopc_builder/bin/qsys-script"
  set cmd "${cmd} --script=${filepath}/${qsysname}.tcl\n"
  
  puts $fh "catch \{eval \[exec ${cmd}\]\} temp"
  puts $fh "puts \$temp"
  
  set cmd "${qdir}/sopc_builder/bin/qsys-generate"
  set cmd "${cmd} ${filepath}/${qsysname}.qsys"
  set cmd "${cmd} --output-directory=${filepath}/${subdir}"
  set cmd "${cmd} --synthesis=VERILOG"
  set cmd "${cmd} --simulation=VERILOG"
  
  puts $fh "catch \{eval \[exec ${cmd}\]\} temp"
  puts $fh "puts \$temp"

  close $fh
  set result [run_tclsh_script $filepath/$filename]
  puts "run_tclsh_script result:${result}"
  
  set fl [findFiles_std ${filepath}/${subdir}]
    foreach file $fl {
        set f_path [string map [list ${filepath} ""] $file]
        if {[file ext $file] == ".v"} {
            add_fileset_file "./$f_path" VERILOG PATH $file
        } elseif {[file ext $file] == ".sv"} {
            add_fileset_file "./$f_path" SYSTEM_VERILOG PATH $file
        } elseif {[file ext $file] == ".mif"} {
            add_fileset_file "./$f_path" MIF PATH $file
        } elseif {[file ext $file] == ".hex"} {
            add_fileset_file "./$f_path" HEX PATH $file
        } elseif {[file ext $file] == ".vhd"} {
            add_fileset_file "./$f_path" VHDL PATH $file
        } elseif {[file ext $file] == ".sdc"} {
            add_fileset_file "./$f_path" SDC PATH $file
        } else {
            add_fileset_file "./$f_path" OTHER PATH $file
        }
    }
}

# -------------------------------------------------------------
# This function returns a list of all files in a directory tree
# -------------------------------------------------------------
proc findFiles_std { path } {
    set filelist {}
    # grab files and directories that exist at this level
    set file_lst [glob -nocomplain -directory $path -- *]
    
    # move systemverilog headers to front
    set idxs [lsearch -glob -all $file_lst *_h.sv]
    foreach idx $idxs {
        set f [lindex $file_lst $idx]
        set file_lst [lreplace $file_lst $idx $idx]
        set file_lst [linsert $file_lst 0 $f]
    }

    # move VHDL packages to front
    set vhd_pkgs [list *rsx_roots.vhd *package.vhd *functions.vhd *parameters.vhd ]
    foreach pkg $vhd_pkgs {
        set idxs [lsearch -glob -all $file_lst $pkg]
        foreach idx $idxs {
            set f [lindex $file_lst $idx]
            set file_lst [lreplace $file_lst $idx $idx]
            set file_lst [linsert $file_lst 0 $f]
        }
    }

    # for each file or directory
    foreach file ${file_lst} {   
        if {[file isdirectory $file] == 1} {
            # if its a directory call findFiles on that directory and append output to list
            set filelist [join [list $filelist [findFiles_std $path/[file tail $file]]]]
        } else {
            # if its a file append file location to list, ignore qsys files
            if {![regexp {.*\.qsys$} $file]} {
            lappend filelist $path/[file tail $file]
        }
    }
    }
    # return the list
    return $filelist
}

proc interpret_terp {output_file_path terp_file_path passed_in_params {file_type "SYSTEM_VERILOG"}} {
    array set params $passed_in_params

    # get template
    set template_path $terp_file_path; # path to the TERP template
    set template_fd   [open $template_path] ;# file handle for template
    set template      [read $template_fd]   ;# template contents
    close $template_fd ;# we are done with the file so we should close it

    # process template with parameters
    set contents [altera_terp $template params] ;# pass parameter array in by reference
    add_fileset_file $output_file_path $file_type TEXT $contents
}














## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/nik1411004570087/nik1411004470158
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697714795
add_documentation_link "Example Design - User Guide" https://documentation.altera.com/#/link/dsu1459187448902/dsu1459204041093
