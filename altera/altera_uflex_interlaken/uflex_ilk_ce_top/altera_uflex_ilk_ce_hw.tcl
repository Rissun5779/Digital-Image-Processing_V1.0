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
# altera_uflex_ilk
#
#======================================

#======================================
#
# request TCL package from ACDS 14.0
#
package require -exact qsys 14.1
package require altera_terp 1.0
#
#======================================

#======================================
#
# module altera_uflex_ilk


send_message PROGRESS "Reading TCL"

set_module_property NAME "altera_uflex_ilk"
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property DISPLAY_NAME "Interlaken IP Core (2nd Generation)"
set_module_property EDITABLE false
#set_module_property ANALYZE_HDL false
set_module_property GROUP "Interface Protocols/Interlaken"
set_module_property AUTHOR "Altera Corporation"
set_module_property DESCRIPTION "Interlaken IP Core (2nd Generation)"
set_module_property supported_device_families {{Stratix 10}}
set_module_property HIDE_FROM_QSYS true

#===========================================================
# Add fileset for synthesis
#=========================================================== 

add_fileset synth QUARTUS_SYNTH synth_proc
set_fileset_property synth TOP_LEVEL uflex_ilk_core


#===========================================================
# Set properties of elaboration through a proc call
#=========================================================== 
set_module_property ELABORATION_CALLBACK elaborate


#===========================================================
# Add fileset for simulation
#=========================================================== 

add_fileset simulation_verilog SIM_VERILOG sim_ver
set_fileset_property simulation_verilog TOP_LEVEL uflex_ilk_core

#===========================================================
# Add fileset for example design
#=========================================================== 
add_fileset example_design EXAMPLE_DESIGN example_design_ver

#======================================
# display tabs
#======================================

add_display_item "" {IP} GROUP tab

add_display_item "IP" {General} GROUP
add_display_item "IP" {In-Band Flow Control} GROUP
add_display_item "IP" {Scrambler} GROUP
add_display_item "IP" {User Data Transfer Interface} GROUP

# add_display_item "" "General" GROUP
# #add_display_item "" "Striper" GROUP

add_display_item "" {Example Design} GROUP tab

add_display_item "Example Design" {Available Example Design} GROUP
add_display_item "Example Design" {Example Design Files} GROUP
add_display_item "Example Design" {Generated HDL Format} GROUP
add_display_item "Example Design" {Target Development Kit} GROUP

#=======================================================
# Parameters 
#=======================================================

add_parameter DEVICE_FAMILY STRING
set_parameter_property DEVICE_FAMILY DISPLAY_NAME "Device family"
set_parameter_property DEVICE_FAMILY SYSTEM_INFO DEVICE_FAMILY
set_parameter_property DEVICE_FAMILY ALLOWED_RANGES {"Stratix 10"}
set_parameter_property DEVICE_FAMILY DESCRIPTION "Supports Stratix 10"
set_parameter_property DEVICE_FAMILY VISIBLE false
set_parameter_property DEVICE_FAMILY HDL_PARAMETER true
set_parameter_property DEVICE_FAMILY ENABLED false
add_display_item "General" DEVICE_FAMILY parameter


add_parameter METALEN INTEGER
set_parameter_property METALEN DEFAULT_VALUE 2048
set_parameter_property METALEN ALLOWED_RANGES {64:8192}
set_parameter_property METALEN DISPLAY_NAME "Meta frame length"
set_parameter_property METALEN UNITS None
set_parameter_property METALEN VISIBLE true
set_parameter_property METALEN HDL_PARAMETER true
set_parameter_property METALEN DESCRIPTION "Specifies the meta frame length; possible lengths are 64-8192 words."
add_display_item "General" METALEN parameter


add_parameter PMA_WIDTH INTEGER
set_parameter_property PMA_WIDTH DEFAULT_VALUE 32
set_parameter_property PMA_WIDTH ALLOWED_RANGES {32,40}
set_parameter_property PMA_WIDTH VISIBLE false
set_parameter_property PMA_WIDTH HDL_PARAMETER true
add_display_item "General" PMA_WIDTH parameter


add_parameter TXFIFO_PEMPTY INTEGER
set_parameter_property TXFIFO_PEMPTY DEFAULT_VALUE 2
set_parameter_property TXFIFO_PEMPTY ALLOWED_RANGES {1,2}
set_parameter_property TXFIFO_PEMPTY VISIBLE false
set_parameter_property TXFIFO_PEMPTY HDL_PARAMETER true
add_display_item "General" TXFIFO_PEMPTY parameter


add_parameter MM_CLK_KHZ INTEGER 1
set_parameter_property MM_CLK_KHZ DEFAULT_VALUE 100000
set_parameter_property MM_CLK_KHZ DISPLAY_NAME "MM_CLK_KHZ"
set_parameter_property MM_CLK_KHZ ALLOWED_RANGES {100000:150000}
set_parameter_property MM_CLK_KHZ DISPLAY_HINT ""
set_parameter_property MM_CLK_KHZ DESCRIPTION "mm clock in KHz"
set_parameter_property MM_CLK_KHZ HDL_PARAMETER true
set_parameter_property MM_CLK_KHZ AFFECTS_ELABORATION true
set_parameter_property MM_CLK_KHZ VISIBLE false
add_display_item "General " MM_CLK_KHZ parameter


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
add_display_item "General " MM_CLK_MHZ parameter


# add_parameter STRIPER BOOLEAN
# set_parameter_property STRIPER DEFAULT_VALUE 1
# set_parameter_property STRIPER DERIVED true
# set_parameter_property STRIPER DISPLAY_NAME "Striper"
# set_parameter_property STRIPER ALLOWED_RANGES {0 1}
# set_parameter_property STRIPER DISPLAY_HINT "BOOLEAN"
# set_parameter_property STRIPER DESCRIPTION ""
# set_parameter_property STRIPER AFFECTS_ELABORATION true
# set_parameter_property STRIPER HDL_PARAMETER true
# set_parameter_property STRIPER VISIBLE false
# add_display_item "General" STRIPER parameter

add_parameter NUM_LANES INTEGER 12
set_parameter_property NUM_LANES DEFAULT_VALUE 12
set_parameter_property NUM_LANES DISPLAY_NAME "Number of lanes"
# set_parameter_property NUM_LANES ALLOWED_RANGES {4,12,24}
set_parameter_property NUM_LANES ALLOWED_RANGES {4,12}
set_parameter_property NUM_LANES DISPLAY_HINT ""
set_parameter_property NUM_LANES AFFECTS_ELABORATION true
set_parameter_property NUM_LANES AFFECTS_GENERATION true
set_parameter_property NUM_LANES HDL_PARAMETER ture
set_parameter_property NUM_LANES DESCRIPTION "Supports 4- and 12-  configurations. Additional lane and data rate configurations are available. Contact your Altera sales representative or email interlaken@altera.com for more information."
add_display_item "General" NUM_LANES parameter

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

add_parameter INTERNAL_WORDS INTEGER 12
set_parameter_property INTERNAL_WORDS DEFAULT_VALUE 4
set_parameter_property INTERNAL_WORDS DISPLAY_NAME "Internal Words"
#set_parameter_property INTERNAL_WORDS DERIVED true
set_parameter_property INTERNAL_WORDS ALLOWED_RANGES {4,8,16}
set_parameter_property INTERNAL_WORDS VISIBLE false
set_parameter_property INTERNAL_WORDS ENABLED true
set_parameter_property INTERNAL_WORDS DESCRIPTION "Number of parallel 64bit words in the datapath"
set_parameter_property INTERNAL_WORDS AFFECTS_ELABORATION true
set_parameter_property INTERNAL_WORDS AFFECTS_GENERATION true
set_parameter_property INTERNAL_WORDS DERIVED true
set_parameter_property INTERNAL_WORDS HDL_PARAMETER ture
add_display_item "General" INTERNAL_WORDS parameter


# add_parameter TX_CREDIT_LATENCY INTEGER
# set_parameter_property TX_CREDIT_LATENCY DEFAULT_VALUE 4
# set_parameter_property TX_CREDIT_LATENCY ALLOWED_RANGES {2:6}
# set_parameter_property TX_CREDIT_LATENCY VISIBLE true
# set_parameter_property TX_CREDIT_LATENCY HDL_PARAMETER true
# set_parameter_property TX_CREDIT_LATENCY DESCRIPTION "It is the latency between tx_credit to the tx_valid. User logic should consider this value when it generates tx_valid signal."
# add_display_item "General" TX_CREDIT_LATENCY parameter


# # INBAND_FLW_ON, HDL parameter, 0
add_parameter INBAND_FLW_ON BOOLEAN 0
set_parameter_property INBAND_FLW_ON DEFAULT_VALUE 0
set_parameter_property INBAND_FLW_ON DISPLAY_NAME "Include in-band flow control functionality"
# set_parameter_property INBAND_FLW_ON ALLOWED_RANGES {0 1}
set_parameter_property INBAND_FLW_ON DISPLAY_HINT BOOLEAN
set_parameter_property INBAND_FLW_ON DESCRIPTION "Enables control to stop or continue the transmission of data through a simple on/off (XON/XOFF) mechanism of a channel or channels. Altera provides an out-of-band flow control block with this IP core. For designs that require retransmission, contact your Altera sales representative or email interlaken@altera.com."
set_parameter_property INBAND_FLW_ON HDL_PARAMETER true
set_parameter_property INBAND_FLW_ON AFFECTS_ELABORATION true
add_display_item "In-Band Flow Control" INBAND_FLW_ON parameter

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


add_parameter IBFC_ERR BOOLEAN
set_parameter_property IBFC_ERR DEFAULT_VALUE 1
#set_parameter_property IBFC_ERR ALLOWED_RANGES {0 1}
set_parameter_property IBFC_ERR DISPLAY_NAME "Include In band flow control err handler"
set_parameter_property IBFC_ERR AFFECTS_GENERATION true
set_parameter_property IBFC_ERR HDL_PARAMETER true
set_parameter_property IBFC_ERR AFFECTS_ELABORATION true
set_parameter_property IBFC_ERR VISIBLE false
add_display_item "General" IBFC_ERR parameter


add_parameter TX_ERR_INJ_EN BOOLEAN
set_parameter_property TX_ERR_INJ_EN DEFAULT_VALUE 0
set_parameter_property TX_ERR_INJ_EN DISPLAY_HINT "BOOLEAN"
set_parameter_property TX_ERR_INJ_EN VISIBLE false
set_parameter_property TX_ERR_INJ_EN DERIVED false
set_parameter_property TX_ERR_INJ_EN HDL_PARAMETER true
set_parameter_property TX_ERR_INJ_EN DESCRIPTION "Error Injection at mac level for simulation only.Will be removed from final version"
add_display_item "General" TX_ERR_INJ_EN parameter


add_parameter DATA_RATE_GUI STRING
set_parameter_property DATA_RATE_GUI DEFAULT_VALUE "10.3125"
set_parameter_property DATA_RATE_GUI DISPLAY_NAME "Data rate"
set_parameter_property DATA_RATE_GUI ALLOWED_RANGES {"6.25" "10.3125" "12.5"}
set_parameter_property DATA_RATE_GUI UNITS GigabitsPerSecond
set_parameter_property DATA_RATE_GUI AFFECTS_ELABORATION true
set_parameter_property DATA_RATE_GUI AFFECTS_GENERATION true
set_parameter_property DATA_RATE_GUI HDL_PARAMETER false
set_parameter_property DATA_RATE_GUI DESCRIPTION "Supports three data rates: 6.25 Gbps,10.3125 Gbps, and 12.5 Gbps. "
add_display_item "General" DATA_RATE_GUI parameter

 # # SCRAM_CONST, Native Phy parameter, A10 only long  
 add_parameter SCRAM_CONST_S10 Std_Logic_Vector 
 set_parameter_property SCRAM_CONST_S10 DEFAULT_VALUE 58'hdeadbeef123
 set_parameter_property SCRAM_CONST_S10 DISPLAY_NAME "Tx Scrambler seed"
 set_parameter_property SCRAM_CONST_S10 ALLOWED_RANGES 58'h1:58'h3FFFFFFFFFFFFFF
 set_parameter_property SCRAM_CONST_S10 DISPLAY_HINT "Initial Scrambler seed"
 set_parameter_property SCRAM_CONST_S10 VISIBLE true
 set_parameter_property SCRAM_CONST_S10 DESCRIPTION "This parameter specifies the initial scrambler state. It needs to be different for different instantiations of interlaken to reduce cross talk"
 add_display_item "Scrambler" SCRAM_CONST_S10 parameter
 
  # # # SCRAM_CONST
 # add_parameter SCRAM_CONST Std_Logic_Vector
 # set_parameter_property SCRAM_CONST DEFAULT_VALUE 58'hdeadbeef123
 # set_parameter_property SCRAM_CONST DISPLAY_NAME "Tx Scrambler seed"
 # set_parameter_property SCRAM_CONST ALLOWED_RANGES 58'h1:58'h3FFFFFFFFFFFFFF
 # set_parameter_property SCRAM_CONST DISPLAY_HINT "Initial Scrambler seed"
 # set_parameter_property SCRAM_CONST VISIBLE false
 # set_parameter_property SCRAM_CONST HDL_PARAMETER true
 # set_parameter_property SCRAM_CONST AFFECTS_ELABORATION true
 # set_parameter_property SCRAM_CONST DESCRIPTION "This parameter specifies the initial scrambler state. It needs to be different for different instantiations of interlaken to reduce cross talk"
 # add_display_item "Scrambler" SCRAM_CONST parameter

# PLL_REFCLK_FREQ
add_parameter PLL_REFCLK_FREQ STRING
set_parameter_property PLL_REFCLK_FREQ DEFAULT_VALUE "412.5 MHz"
set_parameter_property PLL_REFCLK_FREQ DISPLAY_NAME "Transceiver reference clock frequency"
# put allowed range in elaboration call_back
set_parameter_property PLL_REFCLK_FREQ DISPLAY_HINT ""
# set_parameter_property PLL_REFCLK_FREQ UNITS MegabitsPerSecond
set_parameter_property PLL_REFCLK_FREQ AFFECTS_ELABORATION true
set_parameter_property PLL_REFCLK_FREQ AFFECTS_GENERATION true
set_parameter_property PLL_REFCLK_FREQ VISIBLE true
set_parameter_property PLL_REFCLK_FREQ HDL_PARAMETER false
# set_parameter_property PLL_REFCLK_FREQ DERIVED true
set_parameter_property PLL_REFCLK_FREQ ENABLED true
set_parameter_property PLL_REFCLK_FREQ DESCRIPTION "Supports multiple transceiver reference clock frequencies for flexibility in oscillator and PLL choices."
add_display_item "General" PLL_REFCLK_FREQ parameter

# # ECC_ENABLE, HDL parameter, 0
add_parameter ECC_ENABLE BOOLEAN 0
set_parameter_property ECC_ENABLE DEFAULT_VALUE 0
set_parameter_property ECC_ENABLE DISPLAY_NAME "Enable M20K ECC support"
# set_parameter_property ECC_ENABLE ALLOWED_RANGES {0 1}
set_parameter_property ECC_ENABLE DISPLAY_HINT BOOLEAN
set_parameter_property ECC_ENABLE DESCRIPTION "Enables built-in ECC support on the M20K embedded block memory for single-error correction, double-adjacent-error correction, and triple-adjacent-error detection."
set_parameter_property ECC_ENABLE HDL_PARAMETER true
set_parameter_property ECC_ENABLE AFFECTS_ELABORATION true
add_display_item "General" ECC_ENABLE parameter

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
set_parameter_property ADME DESCRIPTION  "Enables ADME capabilities of the native xcvr phy."
add_display_item "General" ADME parameter

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
# set_parameter_property GENERATED_HDL DERIVED true
set_parameter_property GENERATED_HDL AFFECTS_ELABORATION true
set_parameter_property GENERATED_HDL AFFECTS_GENERATION true
set_parameter_property GENERATED_HDL DESCRIPTION "Only Verilog HDL generation is supported."
add_display_item "Generated HDL Format" GENERATED_HDL PARAMETER

# BOARD_SELECTION 
add_parameter BOARD_SELECTION STRING
set_parameter_property BOARD_SELECTION DEFAULT_VALUE "None"
set_parameter_property BOARD_SELECTION DISPLAY_NAME "Select Board"
set_parameter_property BOARD_SELECTION ALLOWED_RANGES {"Stratix 10 GX Transceiver Signal Integrity Development Kit" "None"}
# set_parameter_property BOARD_SELECTION ALLOWED_RANGES {"Stratix 10 GX Transceiver Signal Integrity Development Kit" "Stratix 10 GX Transceiver Signal Integrity Development Kit (ES)" "None"}
set_parameter_property BOARD_SELECTION DISPLAY_HINT ""
# set_parameter_property BOARD_SELECTION DERIVED true
set_parameter_property BOARD_SELECTION ENABLED false
set_parameter_property BOARD_SELECTION AFFECTS_ELABORATION true
set_parameter_property BOARD_SELECTION AFFECTS_GENERATION true
set_parameter_property BOARD_SELECTION DESCRIPTION "<p>This option provides support for various development kits listed.The example design will be generated for the target device shown. If this menu is greyed out, it is because no board is supported for the options selected such as synthesis checked off. If an Altera Development board is selected, the Target Device used for generation will be the one that matches the device on the Development Kit.<br> For more details, visit https://www.altera.com/products/development-kits/kit-index.html<\p>"
add_display_item "Target Development Kit" BOARD_SELECTION PARAMETER

# set_parameter_update_callback BOARD_SELECTION choose_BOARD_SELECTION_callback

add_parameter part_trait_bd string ""
set_parameter_property part_trait_bd SYSTEM_INFO_TYPE PART_TRAIT
set_parameter_property part_trait_bd SYSTEM_INFO_ARG BASE_DEVICE
set_parameter_property part_trait_bd VISIBLE false

add_parameter DEVICE STRING
set_parameter_property DEVICE SYSTEM_INFO {DEVICE}
set_parameter_property DEVICE VISIBLE false

# add_parameter COMPONENT_EXTN BOOLEAN
# set_parameter_property COMPONENT_EXTN DEFAULT_VALUE 0
# #set_parameter_property COMPONENT_EXTN ALLOWED_RANGES {0 1}
# set_parameter_property COMPONENT_EXTN DISPLAY_HINT "BOOLEAN"
# set_parameter_property COMPONENT_EXTN VISIBLE true
# set_parameter_property COMPONENT_EXTN HDL_PARAMETER false
# set_parameter_property COMPONENT_EXTN DESCRIPTION "Maybe removed once the structure is finalized. Generates component extension"
# add_display_item "General" COMPONENT_EXTN parameter



#=======================================================
# Code 
#=======================================================


proc elaborate {} {
  set lanes [get_parameter_value NUM_LANES]
  set words [get_parameter_value INTERNAL_WORDS]
  set data_rate_gui [get_parameter_value DATA_RATE_GUI]
  set cal_pages [get_parameter_value CALENDAR_PAGES]
  set pll_refclk_mhz [get_parameter_value PLL_REFCLK_FREQ]
  set pll_refclk [expr [string trim $pll_refclk_mhz MHz ] ]
  #set pll_refclk_num [expr [string trim $pll_refclk MHz ]]
  # set sim_mode [get_parameter_value SIM_MODE]
  set metalen [get_parameter_value METALEN]
  set device_family [get_parameter_value DEVICE_FAMILY]
  set pma_width [get_parameter_value PMA_WIDTH]
  set mm_clock_mhz [get_parameter_value MM_CLK_MHZ]
  #set comp_extn [get_parameter_value COMPONENT_EXTN]
  set adme [get_parameter_value ADME]
  
  set check_device [get_parameter_value DEVICE]
  set dev_family_S5 [check_device_family_equivalence $device_family {"Stratix V"} ]
  set dev_family_S10 [check_device_family_equivalence $device_family {"Stratix 10"}]
  set dev_family_A10 [check_device_family_equivalence $device_family {"Arria 10"} ]
  		
  if {$dev_family_A10 && [string match -nocase $check_device "unknown"]} {
       send_message error "The current selected device \"$check_device\" is invalid, please select a valid device to generate the IP."
  }
  #set_parameter_value FAMILY $device_family
    set_parameter_property INTERNAL_WORDS ALLOWED_RANGES {4,8,16}
    if {$lanes == 4 ||$lanes == 8 || $lanes == 12 || $lanes == 20 || $lanes == 24} {
      # if {$lanes == 4 } {
        # if {$words != 4 } {
          # send_message ERROR "Please select Internal Words as 4"
        # }
        # set_parameter_value INTERNAL_WORDS 4
      # }
      if {$lanes == 4 } {
        set_parameter_value INTERNAL_WORDS 4
      }
	  
      if {$lanes == 8 } {
        set_parameter_value INTERNAL_WORDS 4
      }
	  
      if {$lanes == 12 } {
        set_parameter_value INTERNAL_WORDS 8
      }
	  
      # if {$lanes == 16 } {
       # if {$words != 8 } {
          # send_message ERROR "Please select Internal Words as 8"
        # }
        # set_parameter_property INTERNAL_WORDS ALLOWED_RANGES {8}
      # }
      if {$lanes == 24 || $lanes == 20} {
        set_parameter_value INTERNAL_WORDS 16
      }
    }
  
 
 if {$words == 16} {
    set raw_words 12
  } else {
    set raw_words $words
  }
  
  
 if {$words == 4} {
    set log_words 3
    set dual 1
  } elseif {$words == 8} {
    set log_words 4
    set dual 2
  } else {
    set log_words 5
    set dual 2
  }
  
  
  if {$lanes == 24 || $lanes == 20} {
    set reconfig 5
  } elseif {$lanes == 12} {
    set reconfig 4
  } elseif {$lanes == 8} {
    set reconfig 3
  } elseif {$lanes == 4} {
    set reconfig 3  
  }
  
  #set Meta Frame Length if sim_mode is on
  # if {$sim_mode} {
    # if {$metalen != 128} {
        # send_message ERROR "Please select MetaFrameLength as 128 for Sim Mode"
      # }
      # set_parameter_property METALEN ALLOWED_RANGES {128}
  # } else {
      # set_parameter_property METALEN ALLOWED_RANGES {64:8192}
  # }
  #set value of data rate
  if {$data_rate_gui == 6.25} {
    set data_rate 6250.0
  } elseif {$data_rate_gui == 10.3125} {
    set data_rate 10312.5
  } elseif {$data_rate_gui == 12.5} {
    set data_rate 12500
  } elseif {$data_rate_gui == 15} {
    set data_rate 15000
  } else {
      send_message error "Data Rate is not supported"
  }
  
    set in_band_mode [get_parameter_value INBAND_FLW_ON]
	
    if {$in_band_mode} {
    set_parameter_property CALENDAR_PAGES ENABLED true
    } else {
    set_parameter_property CALENDAR_PAGES ENABLED false
    }
  
  #set value of Log_calendar_pages
  if {$cal_pages == 1 || $cal_pages == 2 } {
    set_parameter_value LOG_CALENDAR_PAGES 1
  } elseif {$cal_pages == 4} {
      set_parameter_value LOG_CALENDAR_PAGES 2  
  } elseif {$cal_pages == 8} {
      set_parameter_value LOG_CALENDAR_PAGES 3
  } elseif {$cal_pages == 16} {
      set_parameter_value LOG_CALENDAR_PAGES 4
  }
  
  #CDR and PLL ref clocks
  if {$data_rate == 10312.5} {
    set_parameter_property PLL_REFCLK_FREQ ALLOWED_RANGES {"156.25 MHz" "206.25 MHz" "257.8125 MHz" "322.265625 MHz" "412.5 MHz" "515.625 MHz" "644.53125 MHz" }
  } elseif {$data_rate == 12500.0} {
      set_parameter_property PLL_REFCLK_FREQ ALLOWED_RANGES {"156.25 MHz" "195.3125 MHz" "250.0 MHz" "312.5 MHz" "390.625 MHz" "500.0 MHz" "625.0 MHz" }
  } elseif {$data_rate == 6250.0} {
      set_parameter_property PLL_REFCLK_FREQ ALLOWED_RANGES {"156.25 MHz" "195.3125 MHz" "250.0 MHz" "312.5 MHz" "390.625 MHz" "500.0 MHz" "625.0 MHz" }
  } elseif {$data_rate == 15000} {
      set_parameter_property PLL_REFCLK_FREQ ALLOWED_RANGES {"156.25 MHz" "312.5 MHz" "400.0 MHz" }
  } else {
      send_message error "Data rate is not supported, set range of pll ref clk"
  }
  
  set scram_seed_s10 [get_parameter_value SCRAM_CONST_S10]
  set hex [list 0123456789ABCDEF] 
  
          if {$scram_seed_s10 > 288230376151711743 || $scram_seed_s10 == 0} {
            send_message ERROR "Tx Scrambler seed is out of range. Valid range is 0x1 to 0x3FFFFFFFFFFFFFF"
            
        } else {
            set i 0
            while {[string range $scram_seed_s10 $i $i] != ""} {
                set match_found 0
                set j 0
                while {!$match_found && $j < 16} {
                  if {[string match [string range $scram_seed_s10 $i $i] [string range $hex $j $j]]} {
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
        		
		
  if {$dev_family_S10} {
  
    add_hdl_instance atxpll altera_xcvr_atx_pll_s10
    set atxpll_param_val_list [list \
      set_output_clock_frequency              [expr {$data_rate/2}] \
      set_auto_reference_clock_frequency      $pll_refclk \
      pma_width                               $pma_width \
      enable_mcgb                             1 \
      enable_hfreq_clk                        1 \
      base_device                             [get_parameter_value part_trait_bd] \
      ]
    foreach {param val} $atxpll_param_val_list {
        set_instance_parameter_value atxpll $param $val
    }
    add_hdl_instance uflex_ilk_xcvr altera_xcvr_native_s10
    set_instance_parameter_value  uflex_ilk_xcvr  base_device [get_parameter_value part_trait_bd]
    set uflex_ilk_xcvr_param_val_list [list  \
      rcfg_enable                                0 \
      protocol_mode                              interlaken_mode \
      channels                                   $lanes \
      set_data_rate                              $data_rate \
      enh_tx_scram_enable                        1 \
      enh_tx_scram_seed                          $scram_seed_s10 \
      enh_rx_descram_enable                      1 \
      enh_tx_dispgen_enable                      1 \
      enh_rx_dispchk_enable                      1 \
      enh_rx_blksync_enable                      1 \
      enable_port_rx_enh_blk_lock                1 \
      enable_port_rx_fifo_full                   1 \
      enable_port_rx_fifo_empty                  1 \
      enable_port_rx_fifo_pfull                  1 \
      enable_port_rx_fifo_pempty                 1 \
      enable_port_rx_fifo_rd_en                  1 \
      enable_port_rx_fifo_align_clr              1 \
      rx_clkout_sel                              pcs_clkout \
      pcs_reset_sequencing_mode                  bonded \
      rcfg_shared                                0 \
      plls                                       1 \
      set_cdr_refclk_freq                        $pll_refclk \
      enable_ports_rx_manual_cdr_mode            1 \
      enable_ports_rx_prbs                       1 \
      enable_port_rx_seriallpbken                1 \
      enh_pcs_pma_width                          $pma_width \
      enh_pld_pcs_width                          67 \
      enh_tx_frmgen_enable                       1 \
      enh_tx_frmgen_mfrm_length                  $metalen \
      enh_tx_frmgen_burst_enable                 1 \
      enable_port_tx_enh_frame                   1 \
      enable_port_tx_enh_frame_diag_status       1 \
      enable_port_tx_enh_frame_burst_en          1 \
      enh_rx_frmsync_enable                      1 \
      enh_rx_frmsync_mfrm_length                 $metalen \
      enable_port_rx_enh_frame                   1 \
      enable_port_rx_enh_frame_lock              1 \
      enable_port_rx_enh_frame_diag_status       1 \
      enh_tx_crcgen_enable                       1 \
      enh_tx_crcerr_enable                       1 \
      enh_rx_crcchk_enable                       1 \
      enable_port_rx_enh_crc32_err               1 \
      tx_fifo_mode                               Interlaken \
      tx_fifo_pfull                              24 \
      tx_fifo_pempty                             2 \
      enable_port_tx_fifo_full                   1 \
      enable_port_tx_fifo_empty                  1 \
      enable_port_tx_fifo_pfull                  1 \
      enable_port_tx_fifo_pempty                 1 \
      enable_port_tx_dll_lock                    1 \
      rx_fifo_mode                               Interlaken \
      rx_fifo_pfull                              48 \
      rx_fifo_pempty                             8 \
      tx_clkout_sel                              pcs_clkout \
      ]
        
    foreach {param val} $uflex_ilk_xcvr_param_val_list {
        set_instance_parameter_value uflex_ilk_xcvr $param $val
    }
    
    add_hdl_instance uflex_ilk_reset_control altera_xcvr_reset_control_s10
    set param_val_list [list \
      channels                              $lanes \
      plls                                  1 \
      sys_clk_in_mhz                        $mm_clock_mhz \
      reduced_sim_time                      1 \
      enable_digital_seq                    0 \
      gui_pll_cal_busy                      1 \
      tx_pll_enable                         1 \
      t_pll_powerdown                       1000 \
      tx_enable                             1 \
      t_tx_analogreset                      70 \
      t_tx_digitalreset                     20 \
      rx_enable                             1 \
      t_rx_analogreset                      70 \
      t_rx_digitalreset                     4000  \
      ]
    foreach {param val} $param_val_list {
      set_instance_parameter_value uflex_ilk_reset_control $param $val
    }
    
  }  
  
  
  
  #Pll and native phy instantiation for A10
  if {$dev_family_A10} {
    
    #Make ADME selection visible
    set_parameter_property ADME VISIBLE true
    
    #PLL 
    add_hdl_instance atxpll altera_xcvr_atx_pll_a10
    set atxpll_param_val_list [list \
            set_output_clock_frequency              [expr {$data_rate/2}] \
            set_auto_reference_clock_frequency      $pll_refclk \
            pma_width                               $pma_width \
            enable_mcgb                             1 \
            enable_hfreq_clk                        1 \
            base_device                             [get_parameter_value part_trait_bd] \
            ]
        foreach {param val} $atxpll_param_val_list {
            set_instance_parameter_value atxpll $param $val
        }
    
    #Native PHY 
    add_hdl_instance uflex_ilk_xcvr altera_xcvr_native_a10
    set_instance_parameter_value  uflex_ilk_xcvr  base_device [get_parameter_value part_trait_bd]
    if {$adme} {
        set uflex_ilk_xcvr_param_val_list [list  \
            protocol_mode                        interlaken_mode \
            channels                             $lanes \
            set_data_rate                        $data_rate \
            plls                                 1 \
            set_cdr_refclk_freq                  $pll_refclk \
            enable_ports_rx_prbs                 1 \
            enable_ports_rx_manual_cdr_mode      1 \
            enable_port_rx_seriallpbken          1 \
            rx_pma_dfe_adaptation_mode           continuous \
            enh_pcs_pma_width                    $pma_width \
            enh_pld_pcs_width                    67 \
            enh_txfifo_mode                      Interlaken \
            enh_txfifo_pfull                     11 \
            enh_txfifo_pempty                    2 \
            enable_port_tx_enh_fifo_full         1 \
            enable_port_tx_enh_fifo_pfull        1 \
            enable_port_tx_enh_fifo_empty        1 \
            enable_port_tx_enh_fifo_pempty       1 \
            enable_port_tx_enh_fifo_cnt          1 \
            enh_rxfifo_mode                      Interlaken  \
            enh_rxfifo_pempty                    2 \
            enable_port_rx_enh_data_valid        1 \
            enable_port_rx_enh_fifo_full         1 \
            enable_port_rx_enh_fifo_pfull        1 \
            enable_port_rx_enh_fifo_empty        1 \
            enable_port_rx_enh_fifo_pempty       1 \
            enable_port_rx_enh_fifo_rd_en        1 \
            enable_port_rx_enh_fifo_align_val    1 \
            enable_port_rx_enh_fifo_align_clr    1 \
            enh_tx_frmgen_enable                 1 \
            enh_tx_frmgen_mfrm_length            $metalen \
            enh_tx_frmgen_burst_enable           1 \
            enable_port_tx_enh_frame             1 \
            enable_port_tx_enh_frame_diag_status 1 \
            enable_port_tx_enh_frame_burst_en    1 \
            enh_rx_frmsync_enable                1 \
            enh_rx_frmsync_mfrm_length           $metalen \
            enable_port_rx_enh_frame             1 \
            enable_port_rx_enh_frame_lock        1 \
            enable_port_rx_enh_frame_diag_status 1 \
            enh_tx_crcgen_enable                 1 \
            enh_tx_crcerr_enable                 1 \
            enh_rx_crcchk_enable                 1 \
            enable_port_rx_enh_crc32_err         1 \
            enh_tx_scram_enable                  1 \
            enh_tx_scram_seed                    1 \
            enh_rx_descram_enable                1 \
            enh_tx_dispgen_enable                1 \
            enh_rx_dispchk_enable                1 \
            enh_rx_blksync_enable                1 \
            enable_port_rx_enh_blk_lock          1 \
            generate_add_hdl_instance_example    1 \
            rcfg_enable                          1 \
            rcfg_shared                          1 \
            rcfg_jtag_enable                   1 \
            set_capability_reg_enable    1 \
            set_prbs_soft_logic_enable  1 \
            set_odi_soft_logic_enable    1 \
            rcfg_file_prefix                     altera_xcvr_native_phy \
            ]
            
    } else {
        
        set uflex_ilk_xcvr_param_val_list [list  \
            protocol_mode                        interlaken_mode \
            channels                             $lanes \
            set_data_rate                        $data_rate \
            plls                                 1 \
            set_cdr_refclk_freq                  $pll_refclk \
            enable_ports_rx_prbs                 1 \
            enable_ports_rx_manual_cdr_mode      1 \
            enable_port_rx_seriallpbken          1 \
            rx_pma_dfe_adaptation_mode           continuous \
            enh_pcs_pma_width                    $pma_width \
            enh_pld_pcs_width                    67 \
            enh_txfifo_mode                      Interlaken \
            enh_txfifo_pfull                     11 \
            enh_txfifo_pempty                    2 \
            enable_port_tx_enh_fifo_full         1 \
            enable_port_tx_enh_fifo_pfull        1 \
            enable_port_tx_enh_fifo_empty        1 \
            enable_port_tx_enh_fifo_pempty       1 \
            enable_port_tx_enh_fifo_cnt          1 \
            enh_rxfifo_mode                      Interlaken  \
            enh_rxfifo_pempty                    2 \
            enable_port_rx_enh_data_valid        1 \
            enable_port_rx_enh_fifo_full         1 \
            enable_port_rx_enh_fifo_pfull        1 \
            enable_port_rx_enh_fifo_empty        1 \
            enable_port_rx_enh_fifo_pempty       1 \
            enable_port_rx_enh_fifo_rd_en        1 \
            enable_port_rx_enh_fifo_align_val    1 \
            enable_port_rx_enh_fifo_align_clr    1 \
            enh_tx_frmgen_enable                 1 \
            enh_tx_frmgen_mfrm_length            $metalen \
            enh_tx_frmgen_burst_enable           1 \
            enable_port_tx_enh_frame             1 \
            enable_port_tx_enh_frame_diag_status 1 \
            enable_port_tx_enh_frame_burst_en    1 \
            enh_rx_frmsync_enable                1 \
            enh_rx_frmsync_mfrm_length           $metalen \
            enable_port_rx_enh_frame             1 \
            enable_port_rx_enh_frame_lock        1 \
            enable_port_rx_enh_frame_diag_status 1 \
            enh_tx_crcgen_enable                 1 \
            enh_tx_crcerr_enable                 1 \
            enh_rx_crcchk_enable                 1 \
            enable_port_rx_enh_crc32_err         1 \
            enh_tx_scram_enable                  1 \
            enh_tx_scram_seed                    1 \
            enh_rx_descram_enable                1 \
            enh_tx_dispgen_enable                1 \
            enh_rx_dispchk_enable                1 \
            enh_rx_blksync_enable                1 \
            enable_port_rx_enh_blk_lock          1 \
            generate_add_hdl_instance_example    1 \
            rcfg_enable                          1 \
            rcfg_shared                          1 \
            rcfg_file_prefix                     altera_xcvr_native_phy \
            ]
    }    

    foreach {param val} $uflex_ilk_xcvr_param_val_list {
        set_instance_parameter_value uflex_ilk_xcvr $param $val
    }
    
    #Reset_control 
    add_hdl_instance uflex_ilk_reset_control altera_xcvr_reset_control
    set param_val_list [list \
      channels                              $lanes \
      plls                                  1 \
      sys_clk_in_mhz                        $mm_clock_mhz \
      synchronize_reset                     1 \
      reduced_sim_time                      1 \
      tx_pll_enable                         1 \
      t_pll_powerdown                       1000 \
      synchronize_pll_reset                 1 \
      tx_enable                             1 \
      t_tx_digitalreset                     20 \
      rx_enable                             1 \
      t_rx_analogreset                      40 \
      t_rx_digitalreset                     4000  \
      ]
    foreach {param val} $param_val_list {
      set_instance_parameter_value uflex_ilk_reset_control $param $val
    }
  }
    
    
    #ADD ports
    
    #Clock and reset
    add_conduit pll_ref_clk         end     Input   1
    add_conduit reset_n             end     Input   1
    add_conduit tx_pll_locked       end     Input   1
    add_conduit tx_pll_cal_busy     end     Input   1
    add_conduit tx_serial_clk       end     Input   $lanes
    add_conduit tx_clk              end     Input   1
    add_conduit tx_srst             end     Output  1
    add_conduit clk_tx_common       end     Output  1
    add_conduit rx_clk              end     Input   1
    add_conduit rx_srst             end     Output  1
    add_conduit clk_rx_common       end     Output  1
    add_conduit tx_pll_powerdown       end     Output  1
      
    #Burst config
    add_conduit burst_max_in     end        Input      4
    add_conduit burst_min_in      end        Input      4
    add_conduit burst_short_in    end       Input       4

    #TX User interface
    add_conduit itx_din_words            end     Input   [expr {64 * $words}]
    add_conduit itx_num_valid             end     Input   [expr {$dual * $log_words}]
    add_conduit itx_sob              end     Input   $dual
    add_conduit itx_sop              end     Input   $dual
    add_conduit itx_eob                end     Input  1
    add_conduit itx_eopbits          end     Input   4
    add_conduit itx_chan             end     Input   8 
    add_conduit itx_ready           end     Output  1
    add_conduit itx_calendar         end     Input   [expr {16 * $cal_pages}]
    
     # RX User Interface
    add_conduit irx_dout_words            end     Output   [expr {64 * $words}]
    add_conduit irx_num_valid             end     Output    [expr {$dual * $log_words}]
    add_conduit irx_sob              end     Output   $dual
    add_conduit irx_sop              end     Output   $dual
    add_conduit irx_eob              end     Output   1
    add_conduit irx_eopbits          end     Output  4
    add_conduit irx_chan             end     Output   8
    add_conduit irx_calendar         end     Output   [expr {16 * $cal_pages}]
    add_conduit irx_err         end     Output   1

    # Serial interface signals
    add_conduit tx_pin              end     Output  $lanes
    add_conduit rx_pin              end     Input   $lanes

    # Miscellaneous signals
    add_conduit tx_lanes_aligned    end     Output  1
    add_conduit rx_lanes_aligned    end     Output  1
    add_conduit word_locked         end     Output  $lanes
    add_conduit sync_locked         end     Output  $lanes
    add_conduit crc32_err        end     Output  $lanes
    add_conduit crc24_err        end     Output   1
    add_conduit tx_overflow         end     Output  1
    add_conduit tx_underflow        end     Output  1
    add_conduit rx_overflow         end     Output  1

    # Avalon-MM interface for Uflex Interlaken core CSR
    add_conduit mm_clk              end     Input   1
    add_conduit mm_read             end     Input   1
    add_conduit mm_write            end     Input   1
    add_conduit mm_address          end     Input   16
    add_conduit mm_readdata         end     Output  32
    add_conduit mm_readdatavalid    end     Output  1
    add_conduit mm_writedata        end     Input   32

    # Avalon-MM interface for native PHY reconfiguration 
    # add_conduit reconfig_clk         end     Input   1
    # add_conduit reconfig_reset       end     Input   1
    # add_conduit reconfig_read        end     Input   1
    # add_conduit reconfig_write       end     Input   1
    # add_conduit reconfig_address     end     Input   [expr {$reconfig + 10}]
    # add_conduit reconfig_readdata    end     Output  32
    # add_conduit reconfig_writedata   end     Input   32
    # add_conduit reconfig_waitrequest end     Output   1

    # Reconfiguration interface for StratixV
  
    add_conduit reconfig_to_xcvr      end     Input   [expr {70 * $lanes}]
    add_conduit reconfig_from_xcvr    end     Output  [expr {46 * $lanes}]

}  


proc add_conduit {iface_name type dir width} {

    add_interface $iface_name conduit $type
    add_interface_port $iface_name $iface_name export $dir $width
  
}

proc synth_proc {outputName} {

  set files_mac  "uflex_ilk_crc24_evo8_2lut.sv uflex_ilk_iw4_local_buffer.sv  uflex_ilk_rx_crc24.sv \
     uflex_ilk_crc24_12.sv uflex_ilk_crc24_evo9_2lut.sv uflex_ilk_iw4_sync_ram.sv uflex_ilk_rx_ibfc_err_handle.sv \
     uflex_ilk_crc24_4.sv uflex_ilk_crc24_in_n.sv uflex_ilk_iw4_tx_bs_control_rd.sv uflex_ilk_rx_ibfc.sv \
     uflex_ilk_crc24_8.sv uflex_ilk_crc24_n.sv	 uflex_ilk_iw8_addr_gen.sv \
     uflex_ilk_crc24_acc.sv uflex_ilk_iw16_addr_gen.sv uflex_ilk_iw8_barrel_shift.sv uflex_ilk_tx_crc24_scalable.sv \
     uflex_ilk_crc24_evo10_2lut.sv uflex_ilk_iw16_enhance_scheduler.sv uflex_ilk_iw8_burst_decode.sv uflex_ilk_tx_crc24_striper.sv \
     uflex_ilk_crc24_evo11_2lut.sv uflex_ilk_iw16_tx_ctl_insert.sv uflex_ilk_iw8_enhance_scheduler_ctrl.sv uflex_ilk_tx_crc24.sv \
     uflex_ilk_crc24_evo12_2lut.sv uflex_ilk_iw16_tx_regroup.sv uflex_ilk_iw8_enhance_scheduler.sv uflex_ilk_tx_ext_iw16.sv \
     uflex_ilk_crc24_evo1_2lut.sv uflex_ilk_iw48c_rx_crc24.sv uflex_ilk_iw8_idle_gen.sv  uflex_ilk_tx_ext_iw4.sv \
     uflex_ilk_crc24_evo2_2lut.sv uflex_ilk_iw48c_tx_crc24.sv uflex_ilk_iw8_local_buffer.sv  uflex_ilk_tx_ext_iw8.sv \
     uflex_ilk_crc24_evo3_2lut.sv uflex_ilk_iw4_barrel_shift.sv uflex_ilk_iw8_sync_ram.sv  uflex_ilk_tx_ext.sv \
     uflex_ilk_crc24_evo4_2lut.sv uflex_ilk_iw4_burst_decode.sv uflex_ilk_iw8_tx_bs_control_rd.sv uflex_ilk_tx_ibfc.sv \
     uflex_ilk_crc24_evo5_2lut.sv uflex_ilk_iw4_enhance_scheduler_ctrl.sv uflex_ilk_rx_crc24_calendar.sv \
     uflex_ilk_crc24_evo6_2lut.sv uflex_ilk_iw4_enhance_scheduler.sv uflex_ilk_rx_crc24_scalable.sv uflex_ilk_tx_intlv.sv \
     uflex_ilk_crc24_evo7_2lut.sv uflex_ilk_iw4_idle_gen.sv uflex_ilk_rx_crc24_striper.sv"
     
    set files_components_sv "uflex_ilk_crc24_evo5.sv uflex_ilk_index_with_restart_6.sv uflex_ilk_page_dealer_12.sv \
     uflex_ilk_a10mlab.sv uflex_ilk_crc24_evo6.sv uflex_ilk_iw16_sync_fifo_mlab.sv uflex_ilk_page_grabber_12.sv \
     uflex_ilk_add3_cmp3.sv uflex_ilk_crc24_evo7.sv uflex_ilk_leftmost_one_12_1.sv uflex_ilk_priority_12.sv \
     uflex_ilk_altera_syncram.sv uflex_ilk_altera_syncram_mlab.sv uflex_ilk_crc24_evo8.sv uflex_ilk_leftmost_one_12_2.sv uflex_ilk_priority_6.sv \
     uflex_ilk_and_r.sv uflex_ilk_crc24_evo9.sv uflex_ilk_leftmost_one_4.sv uflex_ilk_priority_6_upper.sv \
     uflex_ilk_barrel_layer.sv uflex_ilk_crc24_in12.sv uflex_ilk_leftmost_one_8.sv uflex_ilk_reg_delay.sv \
     uflex_ilk_barrel_shift.sv uflex_ilk_crc24_in4.sv uflex_ilk_m20k.sv uflex_ilk_reset_delay.sv \
     uflex_ilk_compressor_12to4.sv uflex_ilk_crc24_in8.sv uflex_ilk_mlab_fifo.sv uflex_ilk_rst_sync.sv \
     uflex_ilk_compressor_3to2.sv uflex_ilk_crc24_sig.sv uflex_ilk_mlab.sv uflex_ilk_scfifo_mlab.sv \
     uflex_ilk_compressor_4to3.sv uflex_ilk_cross_bus.sv uflex_ilk_mx12_ena.sv uflex_ilk_status_sync.sv \
     uflex_ilk_compressor_5to3.sv uflex_ilk_delay_mlab.sv uflex_ilk_mx16r.sv uflex_ilk_sum_of_3bit_pair.sv \
     uflex_ilk_compressor_6to3.sv uflex_ilk_delay_regs.sv uflex_ilk_mx4r.sv uflex_ilk_sum_of_3bit_two_1bit.sv \
     uflex_ilk_compressor_8to4.sv uflex_ilk_eq_12.sv uflex_ilk_mx8r.sv uflex_ilk_sync_fifo_mlab_2.sv \
     uflex_ilk_count_to_here_12.sv uflex_ilk_eq_3.sv uflex_ilk_mx_nto1_r.sv uflex_ilk_sync_fifo_mlab.sv \
     uflex_ilk_crc24_evo10.sv uflex_ilk_eq_5_ena.sv uflex_ilk_neq_24.sv \
     uflex_ilk_crc24_evo11.sv uflex_ilk_fifo_4.sv uflex_ilk_neq_5_ena.sv uflex_ilk_wys_lut.sv \
     uflex_ilk_crc24_evo12.sv uflex_ilk_fifo_8.sv uflex_ilk_nogap_one_12.sv uflex_ilk_xor_lut.sv \
     uflex_ilk_crc24_evo1.sv uflex_ilk_frequency_monitor.sv uflex_ilk_nogap_one_8.sv uflex_ilk_xor_r_12w.sv \
     uflex_ilk_crc24_evo2.sv uflex_ilk_hyper_pipe.sv uflex_ilk_s10mlab.sv uflex_ilk_one_hot_enc_16.sv uflex_ilk_xor_r.sv \
     uflex_ilk_crc24_evo3.sv uflex_ilk_index_with_restart_12.sv uflex_ilk_one_hot_enc_8.sv uflex_std_synchronizer_nocut.sv \
     uflex_ilk_crc24_evo4.sv uflex_ilk_index_with_restart_3.sv uflex_ilk_or_r.sv"
  
     set files_regroup_sv "uflex_ilk_m20k_group.sv uflex_ilk_rg_out_iw4.sv uflex_ilk_rx_regroup_n.sv uflex_ilk_pkt_annotate.sv \
     uflex_ilk_rg_out_iw8.sv uflex_ilk_rx_regroup.sv uflex_ilk_burst_read_scheduler_iw16.sv uflex_ilk_rg_ctlw_iw12.sv \
     uflex_ilk_seg_shift_layer.sv uflex_ilk_burst_read_scheduler_iw4.sv uflex_ilk_rg_ctlw_iw4.sv \
     uflex_ilk_rx_eob_gen.sv uflex_ilk_seg_shift_split.sv uflex_ilk_burst_read_scheduler_iw8.sv uflex_ilk_rg_ctlw_iw8.sv \
     uflex_ilk_rx_regroup_iw12_to_iw16.sv uflex_ilk_seg_shift.sv uflex_ilk_dcfifo_m20k_ecc.sv uflex_ilk_rg_dp.sv \
     uflex_ilk_rx_regroup_iw4.sv uflex_ilk_wram_m20k.sv uflex_ilk_m20k_ecc_1r1w.sv uflex_ilk_rg_out_iw16.sv \
     uflex_ilk_rx_regroup_iw8.sv uflex_ilk_wram_mult_inst.sv"
  
      set output_name  "uflex_ilk_core"
      set params(output_name)                  $output_name
      #add_fileset_file /uflex_ilk_top/uflex_ilk_core.sv SYSTEM_VERILOG PATH ../uflex_ilk_top/uflex_ilk_core_ext.sv
      add_fileset_file /uflex_ilk_top/uflex_ilk_dcore.sv SYSTEM_VERILOG PATH ../uflex_ilk_ce_top/uflex_ilk_dcore_ext.sv
      interpret_terp /uflex_ilk_top/uflex_ilk_core.sv  ../uflex_ilk_ce_top/uflex_ilk_core.sv.terp  [array get params]
    
  
    # set files_components_sv "	uflex_ilk_a10mlab.sv	uflex_ilk_add3_cmp3.sv	uflex_ilk_compressor_3to2.sv	uflex_ilk_compressor_4to3.sv uflex_ilk_compressor_5to3.sv uflex_ilk_compressor_6to3.sv uflex_ilk_count_to_here_12.sv \
    	# uflex_ilk_crc24_evo1.sv uflex_ilk_crc24_evo10.sv uflex_ilk_crc24_evo11.sv	uflex_ilk_crc24_evo12.sv	uflex_ilk_crc24_evo2.sv	uflex_ilk_crc24_evo3.sv	uflex_ilk_crc24_evo4.sv	uflex_ilk_crc24_evo5.sv \
	  	# uflex_ilk_crc24_evo6.sv uflex_ilk_crc24_evo7.sv	uflex_ilk_crc24_evo8.sv uflex_ilk_crc24_evo9.sv uflex_ilk_crc24_in12.sv uflex_ilk_crc24_in4.sv uflex_ilk_crc24_in8.sv uflex_ilk_crc24_sig.sv uflex_ilk_delay_mlab.sv \
	  	# uflex_ilk_delay_regs.sv uflex_ilk_eq_12.sv	uflex_ilk_eq_3.sv	uflex_ilk_frequency_monitor.sv	uflex_ilk_index_with_restart_12.sv	uflex_ilk_index_with_restart_3.sv	uflex_ilk_index_with_restart_6.sv \
	  	# uflex_ilk_leftmost_one_12_1.sv	uflex_ilk_leftmost_one_12_2.sv	uflex_ilk_leftmost_one_4.sv	uflex_ilk_leftmost_one_8.sv	uflex_ilk_mx12_ena.sv	uflex_ilk_mx16r.sv	uflex_ilk_mx4r.sv	uflex_ilk_mx8r.sv \
	  	# uflex_ilk_mx_nto1_r.sv	uflex_ilk_neq_24.sv uflex_ilk_page_dealer_12.sv	uflex_ilk_page_grabber_12.sv	uflex_ilk_priority_12.sv	uflex_ilk_priority_6.sv	uflex_ilk_priority_6_upper.sv	uflex_ilk_reg_delay.sv \
	  	# uflex_ilk_reset_delay.sv	uflex_ilk_rst_sync.sv	uflex_ilk_scfifo_mlab.sv	uflex_ilk_status_sync.sv	uflex_ilk_sum_of_3bit_pair.sv	uflex_ilk_sync_fifo_mlab.sv	uflex_ilk_sync_fifo_mlab_2.sv	\
	  	# uflex_ilk_wys_lut.sv	uflex_ilk_xor_lut.sv	uflex_ilk_xor_r.sv	uflex_ilk_xor_r_12w.sv"
  

  set files_pcs "uflex_ilk_csr.sv uflex_ilk_rx_pcsif.sv uflex_ilk_rxa.sv uflex_ilk_tx_pcsif.sv uflex_ilk_txa.sv"

  set files_striper "uflex_ilk_striper_2n_to_n.sv uflex_ilk_striper_8_to_12.sv uflex_ilk_striper_n_to_3n.sv uflex_ilk_rx_striper.sv \
    uflex_ilk_striper_3n_to_n.sv uflex_ilk_striper_8_to_6.sv uflex_ilk_tx_striper.sv uflex_ilk_striper_12_to_8.sv uflex_ilk_striper_6_to_8.sv \
    uflex_ilk_striper_n_to_2n.sv"

  set files_uflex_top "uflex_ilk_rx.sv uflex_ilk_tx.sv" 
  
  
  foreach svfile $files_components_sv {
       add_fileset_file /components/${svfile} SYSTEM_VERILOG PATH ../components/${svfile}
  }
  add_fileset_file /components/uflex_ilk_wys_lut.iv SYSTEM_VERILOG_INCLUDE PATH ../components/uflex_ilk_wys_lut.iv
  add_fileset_file /uflex_ilk_mac/uflex_ilk_wys_lut.iv SYSTEM_VERILOG_INCLUDE PATH ../components/uflex_ilk_wys_lut.iv
  
  foreach svfile $files_mac {
       add_fileset_file /uflex_ilk_mac/${svfile} SYSTEM_VERILOG PATH ../uflex_ilk_mac/${svfile}
  }
  
  foreach svfile $files_regroup_sv {
    add_fileset_file /uflex_ilk_regroup/${svfile} SYSTEM_VERILOG PATH ../uflex_ilk_regroup/${svfile}
  }  
  
  foreach svfile $files_pcs {
       add_fileset_file /uflex_ilk_pcs/${svfile} SYSTEM_VERILOG PATH ../uflex_ilk_pcs/${svfile}
  }
  
  foreach svfile $files_striper {
       add_fileset_file /uflex_ilk_striper/${svfile} SYSTEM_VERILOG PATH ../uflex_ilk_striper/${svfile}
  }
  foreach svfile $files_uflex_top {
    add_fileset_file /uflex_ilk_top/${svfile} SYSTEM_VERILOG PATH ../uflex_ilk_top/${svfile}
  }    
  
  add_fileset_file uflex_ilk_core.sdc SDC PATH uflex_ilk_core.sdc
  add_fileset_file "../components/altera_std_synchronizer_nocut.v" VERILOG PATH "../../sopc_builder_ip/altera_avalon_jtag_phy/altera_std_synchronizer_nocut.v"
  # add_fileset_file "../components/uflex_std_synchronizer_nocut.v" VERILOG PATH "../components/uflex_std_synchronizer_nocut.v"

  
}  

proc sim_ver {outputName} {
 
# ##########################################    Encrypted Eiles    ##########################################    

# #### SYNOPSYS files ####

set sim_synopsys_dir {"../components/synopsys" }

set dest_path_sy                "../synopsys"

foreach sim_sy_dir1 $sim_synopsys_dir {
# add everything, including .sv in ilk_pcs
      # replace ../ with / , so "../ilk_regroup/synopsys" become "/ilk_regroup/synopsys"
      regsub ../ $sim_sy_dir1 / tmp01
      # replace /synopsys with /, so "/ilk_regroup/synopsys" become "/ilk_regroup"	  
      regsub /synopsys $tmp01 / individual_dir
               set file_sim_sy_lst [glob -nocomplain -- -path $sim_sy_dir1/*.ivp]	  
               # windows doesn't have files for synopsys and cadence, so use -nocomplain here
                     foreach file ${file_sim_sy_lst} {
                         # split a string by / and store it in an array(file_string), so split ../dir1/dir2/rtl.v, file_string has .. dir1 dir2 rlt.v
						 set file_string [split $file /]
						 # take the last element from array file_string, which is rtl.v
                         set file_name [lindex $file_string end]  
                         # set file_name "uflex_ilk_wys_lut.ivp" 
                         add_fileset_file "$dest_path_sy$individual_dir$file_name" SYSTEM_VERILOG_INCLUDE PATH ${file} SYNOPSYS_SPECIFIC
                     }
     }	

# ########## for sv encryption ##################
set sv_synopsys_dir { "../components/synopsys" "../uflex_ilk_regroup/synopsys" "../uflex_ilk_mac/synopsys" "../uflex_ilk_pcs/synopsys" "../uflex_ilk_striper/synopsys"  }
set dest_path_sy_sv                "../synopsys"
foreach sim_sy_dir1_sv $sv_synopsys_dir {
# add everything, including .sv in ilk_pcs
      # replace ../ with / , so "../ilk_regroup/synopsys" become "/ilk_regroup/synopsys"
      regsub ../ $sim_sy_dir1_sv / tmpsv
      # replace /synopsys with /, so "/ilk_regroup/synopsys" become "/ilk_regroup"	  
      regsub /synopsys $tmpsv / individual_dir
               set file_sim_sy_lst [glob -nocomplain -- -path $sim_sy_dir1_sv/*.sv]	  
               # windows doesn't have files for synopsys and cadence, so use -nocomplain here
                     foreach file ${file_sim_sy_lst} {
                         # split a string by / and store it in an array(file_string), so split ../dir1/dir2/rtl.v, file_string has .. dir1 dir2 rlt.v
						 set file_string [split $file /]
						 # take the last element from array file_string, which is rtl.v
                         set file_name [lindex $file_string end]  
                         add_fileset_file "$dest_path_sy_sv$individual_dir$file_name" SYSTEM_VERILOG_ENCRYPT PATH ${file} SYNOPSYS_SPECIFIC
                     }
     }	

# ########## for v encryption ##################
set v_only_synopsys_dir { "../components/synopsys" }
set dest_path_sy_v_only                "../synopsys"
foreach sim_sy_dir1_v_only $v_only_synopsys_dir {
# add everything, including .sv in ilk_pcs
      # replace ../ with / , so "../ilk_regroup/synopsys" become "/ilk_regroup/synopsys"
      regsub ../ $sim_sy_dir1_v_only / tmpsv
      # replace /synopsys with /, so "/ilk_regroup/synopsys" become "/ilk_regroup"	  
      regsub /synopsys $tmpsv / individual_dir
               set file_sim_sy_lst [glob -nocomplain -- -path $sim_sy_dir1_v_only/*.v]	  
               # windows doesn't have files for synopsys and cadence, so use -nocomplain here
                     foreach file ${file_sim_sy_lst} {
                         # split a string by / and store it in an array(file_string), so split ../dir1/dir2/rtl.v, file_string has .. dir1 dir2 rlt.v
						 set file_string [split $file /]
						 # take the last element from array file_string, which is rtl.v
                         set file_name [lindex $file_string end]  
                         add_fileset_file "$dest_path_sy_v_only$individual_dir$file_name" VERILOG_ENCRYPT PATH ${file} SYNOPSYS_SPECIFIC
                     }
     }
	 
# #### CADENCE files ####
	
# set sim_cadence_dir {"../components/cadence"  }

# set dest_path_ca                "../cadence"
	
# foreach sim_ca_dir1 $sim_cadence_dir {
# # add everything, including .sv in ilk_pcs
      # # replace ../ with / , so "../ilk_regroup/synopsys" become "/ilk_regroup/synopsys"
      # regsub ../ $sim_ca_dir1 / tmp02
      # # replace /synopsys with /, so "/ilk_regroup/synopsys" become "/ilk_regroup"	  
      # regsub /cadence $tmp02 / individual_dir
	         # # windows doesn't have files for synopsys and cadence, so use -nocomplain here
             # set file_sim_ca_lst [glob -nocomplain -- -path $sim_ca_dir1/*.iv]
                     # foreach file ${file_sim_ca_lst} {
                         # # split a string by / and store it in an array(file_string), so split ../dir1/dir2/rtl.v, file_string has .. dir1 dir2 rlt.v
						 # set file_string [split $file /]
						 # # take the last element from array file_string, which is rtl.v
                         # set file_name [lindex $file_string end]  
                         # add_fileset_file "$dest_path_ca$individual_dir$file_name" VERILOG_ENCRYPT PATH ${file} CADENCE_SPECIFIC
                     # }
     # }	
# ############ for sv files ###################
set sim_cadence_sv { "../components/cadence" "../uflex_ilk_regroup/cadence" "../uflex_ilk_mac/cadence" "../uflex_ilk_pcs/cadence" "../uflex_ilk_striper/cadence" }

set dest_path_ca_sv                "../cadence"
foreach sim_ca_dir1 $sim_cadence_sv {
# add everything, including .sv in ilk_pcs
      # replace ../ with / , so "../ilk_regroup/synopsys" become "/ilk_regroup/synopsys"
      regsub ../ $sim_ca_dir1 / tmp02sv
      # replace /synopsys with /, so "/ilk_regroup/synopsys" become "/ilk_regroup"	  
      regsub /cadence $tmp02sv / individual_dir
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

# # ############ for verilog files ###################
# set sim_cadence_v_only { "../components/cadence"  }

# set dest_path_ca_v_only                "../cadence"
# foreach sim_ca_dir1_v_only $sim_cadence_v_only {
# # add everything, including .sv in ilk_pcs
      # # replace ../ with / , so "../ilk_regroup/synopsys" become "/ilk_regroup/synopsys"
      # regsub ../ $sim_ca_dir1_v_only / tmp02sv
      # # replace /synopsys with /, so "/ilk_regroup/synopsys" become "/ilk_regroup"	  
      # regsub /cadence $tmp02sv / individual_dir
	         # # windows doesn't have files for synopsys and cadence, so use -nocomplain here
             # set file_sim_ca_lst [glob -nocomplain -- -path $sim_ca_dir1_v_only/*.v]
                     # foreach file ${file_sim_ca_lst} {
                         # # split a string by / and store it in an array(file_string), so split ../dir1/dir2/rtl.v, file_string has .. dir1 dir2 rlt.v
						 # set file_string [split $file /]
						 # # take the last element from array file_string, which is rtl.v
                         # set file_name [lindex $file_string end]  
                         # add_fileset_file "$dest_path_ca_v_only$individual_dir$file_name" SYSTEM_VERILOG_ENCRYPT PATH ${file} CADENCE_SPECIFIC
                     # }
     # }	
	 	 


# #### MENTOR files ####

set sim_mentor_dir {"../components/mentor" "../uflex_ilk_regroup/mentor" "../uflex_ilk_mac/mentor" "../uflex_ilk_pcs/mentor" "../uflex_ilk_striper/mentor"  }

set dest_path_me "../mentor"
	
foreach sim_me_dir1 $sim_mentor_dir {
# add everything, including .sv in ilk_pcs
      # replace ../ with / , so "../ilk_regroup/mentor" become "/ilk_regroup/mentor"
      regsub ../ $sim_me_dir1 / tmp03
      # replace /mentor with /, so "/ilk_regroup/mentor" become "/ilk_regroup"	  
      regsub /mentor $tmp03 / individual_dir
	  
             set file_sim_me_lst [glob -- -path $sim_me_dir1/*.sv]
                     foreach file ${file_sim_me_lst} {
                         # split a string by / and store it in an array(file_string), so split ../dir1/dir2/rtl.v, file_string has .. dir1 dir2 rlt.v
						 set file_string [split $file /]
						 # take the last element from array file_string, which is rtl.v
                         set file_name [lindex $file_string end]  
                         add_fileset_file "$dest_path_me$individual_dir$file_name" SYSTEM_VERILOG_ENCRYPT PATH ${file} MENTOR_SPECIFIC
                     }
     }	

	 
# # #### for iv file #########
# set sim_mentor_dir_iv {"../components/mentor" }

# set dest_path_me_iv "../mentor"
	
# foreach sim_me_dir_iv $sim_mentor_dir_iv {
# # add everything, including .sv in ilk_pcs
      # # replace ../ with / , so "../ilk_regroup/mentor" become "/ilk_regroup/mentor"
      # regsub ../ $sim_me_dir_iv / tmp03
      # # replace /mentor with /, so "/ilk_regroup/mentor" become "/ilk_regroup"	  
      # regsub /mentor $tmp03 / individual_dir
	  
             # set file_sim_me_lst [glob -- -path $sim_me_dir_iv/*.iv]
                     # foreach file ${file_sim_me_lst} {
                         # # split a string by / and store it in an array(file_string), so split ../dir1/dir2/rtl.v, file_string has .. dir1 dir2 rlt.v
						 # set file_string [split $file /]
						 # # take the last element from array file_string, which is rtl.v
                         # set file_name [lindex $file_string end]  
                         # add_fileset_file "$dest_path_me_iv$individual_dir$file_name" SYSTEM_VERILOG_ENCRYPT PATH ${file} MENTOR_SPECIFIC
                     # }
     # }	

# # #### for verilog file #########
# set sim_mentor_dir_v_only {"../components/mentor" }

# set dest_path_me_v_only "../mentor"
	
# foreach sim_me_dir_v_only $sim_mentor_dir_v_only {
# # add everything, including .sv in ilk_pcs
      # # replace ../ with / , so "../ilk_regroup/mentor" become "/ilk_regroup/mentor"
      # regsub ../ $sim_me_dir_v_only / tmp03
      # # replace /mentor with /, so "/ilk_regroup/mentor" become "/ilk_regroup"	  
      # regsub /mentor $tmp03 / individual_dir
	  
             # set file_sim_me_lst [glob -- -path $sim_me_dir_v_only/*.v]
                     # foreach file ${file_sim_me_lst} {
                         # # split a string by / and store it in an array(file_string), so split ../dir1/dir2/rtl.v, file_string has .. dir1 dir2 rlt.v
						 # set file_string [split $file /]
						 # # take the last element from array file_string, which is rtl.v
                         # set file_name [lindex $file_string end]  
                         # add_fileset_file "$dest_path_me_v_only$individual_dir$file_name" SYSTEM_VERILOG_ENCRYPT PATH ${file} MENTOR_SPECIFIC
                     # }
     # }	

      set output_name  "uflex_ilk_core"
      set params(output_name)                  $output_name

      add_fileset_file /uflex_ilk_top/uflex_ilk_dcore.sv SYSTEM_VERILOG PATH ../uflex_ilk_ce_top/uflex_ilk_dcore_ext.sv      
      interpret_terp /uflex_ilk_top/uflex_ilk_core.sv  ../uflex_ilk_ce_top/uflex_ilk_core_ext.sv.terp  [array get params]

	 
  set files_uflex_top "uflex_ilk_rx.sv uflex_ilk_tx.sv" 
  
  foreach svfile $files_uflex_top {
     add_fileset_file /uflex_ilk_top/${svfile} SYSTEM_VERILOG PATH ../uflex_ilk_top/${svfile} 
	 #SYNOPSYS_SPECIFIC
     #add_fileset_file /mentor/uflex_ilk_top/${svfile} SYSTEM_VERILOG PATH ../uflex_ilk_top/mentor/${svfile} MENTOR_SPECIFIC
     #add_fileset_file /cadence/uflex_ilk_top/${svfile} SYSTEM_VERILOG PATH ../uflex_ilk_top/cadence/${svfile} CADENCE_SPECIFIC
  }

  # add_fileset_file "../components/altera_std_synchronizer_nocut.v" VERILOG PATH "../../sopc_builder_ip/altera_avalon_jtag_phy/altera_std_synchronizer_nocut.v"
  # add_fileset_file "../components/uflex_std_synchronizer_nocut.v" SYSTEM_VERILOG PATH "../components/uflex_std_synchronizer_nocut.sv"

  
}

proc example_design_ver {outputName} {
	set dev_family [get_parameter_value DEVICE_FAMILY]
    set dev_family_S5 [check_device_family_equivalence $dev_family {"Stratix V"} ]
    set dev_family_A5 [check_device_family_equivalence $dev_family {"Arria V GZ"}]
    set dev_family_a10 [check_device_family_equivalence $dev_family {"Arria 10"} ]
	
	# if { [string match [get_parameter_value EXAMPLE_DESIGN_SYNTH_FILES] "false"] == 1 } {
        # if { [string match [get_parameter_value EXAMPLE_DESIGN_SIM_FILES] "false"] == 1 } {
            # send_message ERROR "Neither \"Simulation\" nor \"Synthesis\" check boxes from \"Example Design Files\" are selected to allow generation of Example Design Files."
            # return
        # }
    # }
	

    example_design_s10_board_level $outputName

}

proc example_design_s10_board_level {outputName} {
# send_message INFO "Inside example design a10 board level"

	set dev_family [get_parameter_value DEVICE_FAMILY]
    set dev_family_S5 [check_device_family_equivalence $dev_family {"Stratix V"} ]
    set dev_family_A5 [check_device_family_equivalence $dev_family {"Arria V GZ"}]
    set dev_family_a10 [check_device_family_equivalence $dev_family {"Arria 10"} ]
    
	set num_of_lanes_tb [get_parameter_value NUM_LANES]
	
	 if {$num_of_lanes_tb == 4 } {
        set internal_words_tb 4
     } elseif {$num_of_lanes_tb == 12 } {
        set internal_words_tb 8
     } elseif {$num_of_lanes_tb == 24 || $num_of_lanes_tb == 20} {
         set internal_words_tb 16
     } else {
	 send_message INFO "set num of lanes first"
	 }
	  
	# set internal_words_tb [get_parameter_value INTERNAL_WORDS]
	#send_message INFO "num_of_lanes_tb is $num_of_lanes_tb"
	# send_message INFO "internal_words_tb is $internal_words_tb"

	
	# set data_rate_tb [get_parameter_value DATA_RATE]
	set data_rate_gui [get_parameter_value DATA_RATE_GUI]
	
   	if {$data_rate_gui == 6.25} {
       set data_rate_tb 6250.0
     } elseif {$data_rate_gui == 10.3125} {
       set data_rate_tb 10312.5
     } elseif {$data_rate_gui == 12.5} {
       set data_rate_tb 12500
     } elseif {$data_rate_gui == 15} {
       set data_rate_tb 15000
     } else {
         send_message error "Data Rate is not supported"
     }
  
	set num_calendar_pgs_tb [get_parameter_value CALENDAR_PAGES]
    set log_num_calendar_pgs_tb [get_parameter_value LOG_CALENDAR_PAGES]
    # set tx_packet_mode_tb [get_parameter_value TX_PKTMOD_ONLY]
    # set pll_out_freq_tb [get_parameter_value PLL_OUT_FREQ]
   ## set metalen_tb [get_parameter_value METALEN]
	set pll_refclk_tb [get_parameter_value PLL_REFCLK_FREQ]
	# set rx_dual_seg_tb [get_parameter_value RX_DUAL_SEG]
	
	# set example_synth_file [get_parameter_value EXAMPLE_DESIGN_SYNTH_FILES]
	# set example_sim_file   [get_parameter_value EXAMPLE_DESIGN_SIM_FILES]

	set example_synth_file 0
	set example_sim_file   1
	
	# # # terp simulation top level file
    set template "../testbench/example_design_uflex_s10_board_level/top_tb.sv.terp"

    set template_fd [open $template "r"]
    set template_contents [read $template_fd]
    
	### Don't put white space between variable_to_values and parenthese, otherwise it won't work
	set variable_to_values(family_select) \"$dev_family\"
    set variable_to_values(num_lane) $num_of_lanes_tb
    set variable_to_values(internal_words) $internal_words_tb
    set variable_to_values(data_rate) \"$data_rate_tb\"
	set variable_to_values(pll_ref_clk_freq) \"$pll_refclk_tb\"
	set variable_to_values(cal_pages) $num_calendar_pgs_tb	
	set variable_to_values(log_cal_pages) $log_num_calendar_pgs_tb
	
    set contents [altera_terp $template_contents variable_to_values]
	# write out to be a systemverilog file
    add_fileset_file "../example_design_s10/top_tb.sv" SYSTEM_VERILOG TEXT  $contents
	
	# # # terp synthesis top level file
    set template "../testbench/example_design_uflex_s10_board_level/example_design.sv.terp"
    set template_fd [open $template "r"]
    set template_contents [read $template_fd]
    set contents [altera_terp $template_contents variable_to_values]
    add_fileset_file "../example_design_s10/example_design.sv" SYSTEM_VERILOG TEXT  $contents

	add_fileset_file "../example_design_s10/ilk_oob_flow_rx.v" VERILOG PATH  "../testbench/example_design_uflex_s10_board_level/ilk_oob_flow_rx.v" 
	add_fileset_file "../example_design_s10/ilk_oob_flow_rx_dcfifo.v" VERILOG PATH  "../testbench/example_design_uflex_s10_board_level/ilk_oob_flow_rx_dcfifo.v" 
	add_fileset_file "../example_design_s10/ilk_oob_flow_tx.v" VERILOG PATH  "../testbench/example_design_uflex_s10_board_level/ilk_oob_flow_tx.v" 
	add_fileset_file "../example_design_s10/ilk_reset_delay.v" VERILOG PATH  "../testbench/example_design_uflex_s10_board_level/ilk_reset_delay.v" 
	add_fileset_file "../example_design_s10/ilk_status_sync.v" VERILOG PATH  "../testbench/example_design_uflex_s10_board_level/ilk_status_sync.v" 
	
	
	add_fileset_file "../example_design_s10/ilk_pkt_gen.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_uflex_s10_board_level/ilk_pkt_gen.sv" 
	add_fileset_file "../example_design_s10/ilk_pkt_checker.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_uflex_s10_board_level/ilk_pkt_checker.sv" 
	add_fileset_file "../example_design_s10/test_agent.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_uflex_s10_board_level/test_agent.sv" 
	add_fileset_file "../example_design_s10/test_env.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_uflex_s10_board_level/test_env.sv" 
	add_fileset_file "../example_design_s10/test_host.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_uflex_s10_board_level/test_host.sv" 
	add_fileset_file "../example_design_s10/test_infra.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_uflex_s10_board_level/test_infra.sv" 
	add_fileset_file "../example_design_s10/test_dut.sv" SYSTEM_VERILOG PATH  "../testbench/example_design_uflex_s10_board_level/test_dut.sv" 
	add_fileset_file "../example_design_s10/one_shot.v" VERILOG PATH  "../testbench/example_design_uflex_s10_board_level/one_shot.v" 
	add_fileset_file "../example_design_s10/ilk_top.v" VERILOG PATH  "../testbench/example_design_uflex_s10_board_level/ilk_top.v" 
	
	# set params(top_level_name)                  $outputName
	# interpret_terp ../example_design_s10/ilk_top.v         ../testbench/example_design_uflex_s10_board_level/ilk_top.v.terp       [array get params] "VERILOG"
	
    if {$example_sim_file} {
	add_fileset_file "../example_design_s10/vcstest.sh" OTHER PATH  "../testbench/example_design_uflex_s10_board_level/vcstest.sh" 
	# add_fileset_file "../example_design_s10/ncsim.sh" OTHER PATH  "../testbench/example_design_uflex_s10_board_level/ncsim.sh" 
	add_fileset_file "../example_design_s10/vlog_pro.do" OTHER PATH  "../testbench/example_design_uflex_s10_board_level/vlog_pro.do" 
	# add_fileset_file "../example_design_s10/vlog.do" OTHER PATH  "../testbench/example_design_uflex_s10_board_level/vlog.do" 
   }

   set device "1SG250HH1F50E1VG"
   # set device "10AX115S3F45I2SG"

	
	set params(device_part)                     $device	
	
    if {$example_synth_file} {
	add_fileset_file "../example_design_s10/example_design.sdc" SDC PATH  "../testbench/example_design_uflex_s10_board_level/example_design.sdc" 
	add_fileset_file "../example_design_s10/example_design.qpf" OTHER PATH  "../testbench/example_design_uflex_s10_board_level/example_design.qpf" 
	add_fileset_file "../example_design_s10/sysconsole_testbench.tcl" OTHER PATH  "../testbench/example_design_uflex_s10_board_level/sysconsole_testbench.tcl" 

        # if {$num_of_lanes_tb == 12 && $data_rate_gui== "10.3125"} {
           # interpret_terp ../example_design_s10/example_design.qsf         ../testbench/example_design_uflex_s10_board_level/example_design_12lx10g_virtual.qsf.terp       [array get params] "OTHER"
        # } elseif {$num_of_lanes_tb == 12 && $data_rate_gui == "12.5"} {
           # interpret_terp ../example_design_s10/example_design.qsf         ../testbench/example_design_uflex_s10_board_level/example_design_12lx12g_virtual.qsf.terp       [array get params] "OTHER"
        # } elseif {$num_of_lanes_tb == 24 &&  $data_rate_gui == "6.25"} {		
           # interpret_terp ../example_design_s10/example_design.qsf         ../testbench/example_design_uflex_s10_board_level/example_design_24lx6g_virtual.qsf.terp       [array get params] "OTHER"
        # } else {
	       # send_message error "Please select the right data rate and lane combination"
	    # } 
	
	}

	generate_a10_ip_core


send_message PROGRESS "Finish adding example design" 

}

proc generate_a10_ip_core {} {
    set DEVICE_FAMILY       [get_parameter_value DEVICE_FAMILY]
    set ip_type             altera_uflex_ilk
    set device              [get_part_number]

    set variant ilk_uflex

    # Create temporary location to generate files
    set templocation [create_temp_file "${variant}_gen.tcl"]
    set tempdir [file dirname $templocation]

    # Get a list of parameter value pairs. Ex: {ADME_ENABLE=1 PREAMBLE_PASS=0 ... }
    set parameters [generate_parameter_value_pairs [get_parameters]]
    # Use parameter list to generate copy of IP
    # generate_ip_core $ip_type $variant "Stratix 10" $device $tempdir true $parameters
    generate_ip_core $ip_type $variant "Stratix 10" $device $tempdir true $parameters

    # Copy files from temp directory to project directory
    add_fileset_file "./${variant}.ip" OTHER PATH "${tempdir}/${variant}.ip"
    set fl [findFiles ${tempdir}/${variant}]
    foreach file $fl {
        set f_path [string map [list ${tempdir} ""] $file]
        add_fileset_file "./$f_path" OTHER PATH $file
    }
}

proc get_part_number {} {
    return 1SG250HH1F50E1VG
    # return 10AX115S3F45I2SG
    # return 10SG250H1F50E1VG
}


    # Generates an ip core
    # Example usage to generate 40g ultra ethernet core
    # and place it in the current directory
    #
    # lappend parameters "SPEED_CONFIG=\"40 GbE\""
    # ::ethernet::tools::generate_ip_core alt_eth_ultra ex_40g "Arria 10" 10AX115S2F45I2SG "." true $parameters
    proc generate_ip_core {ip_name ip_core_name family device path gen_rtl {parameter_list {}}} {
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

        qsys_file_generate ${path} ${ip_core_name}

        if {$gen_rtl == true} {
            local_qsysgenerate ${path} ${ip_core_name} "./${ip_core_name}"
        }

        file delete -force $qsysfile_generation_script
    }

    proc qsys_file_generate { filepath qsysname} {
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


    proc local_qsysgenerate { filepath qsysname subdir} {
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

    proc generate_parameter_value_pairs {parameters} {
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
proc findFiles { path } {
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
            set filelist [join [list $filelist [findFiles $path/[file tail $file]]]]
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