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


package provide altera_sl3::gui_params 14.1

namespace eval ::altera_sl3::gui_params:: {
   namespace export \
            params_top_hw \
            params_sink_mac_hw \
            params_source_mac_hw \
            params_pll_wrapper_hw \
            params_interlaken_soft_hw \
            params_phy_adapter_hw \
	        params_phy_hw 

}	


######################################
# Set the names for TAB and Group (GUI)
######################################
add_display_item "" "IP" GROUP tab
add_display_item "IP" "General Design Options" GROUP
add_display_item "IP" "User Interface" GROUP

add_display_item "" "Example Design" GROUP tab
add_display_item "Example Design" "Available Example Designs" GROUP
add_display_item "Example Design" "Files Types Generated" GROUP
add_display_item "Files Types Generated" "" text "<html>Generate Files for:</html>"
add_display_item "Files Types Generated" ENABLE_ED_FILESET_SIM PARAMETER
add_display_item "Files Types Generated" ENABLE_ED_FILESET_SYNTHESIS PARAMETER
add_display_item "Files Types Generated" "info1" text "<html>The example design supports generation, simulation, and Quartus compilation flows for any selected device. To use the<br>
example design for simulation, select the 'Simulation' option above. To use the example design for compilation and<br>
hardware, select the 'Synthesis' option above.</html>"
add_display_item "Example Design" "Generated HDL Format" GROUP
add_display_item "Example Design" "Target Development Kit" GROUP
add_display_item "Target Development Kit" SELECT_TARGETED_DEVICE parameter
add_display_item "Target Development Kit" "explanation1" text "<html>Example design supports generation, simulation and Quartus compilation flows for any selected device.<br>
 The hardware support is provided through selected development kit with a specific device.<br> 
 To exclude hardware aspects of example design, select 'No Development Kit' from the Target Development Kit pull down menu.</html>"
add_display_item "Example Design" "Target Device" GROUP
add_display_item "Target Device" "target_dev" text "<html>Device Selected:     Family: Stratix 10 Device<br><br></html>"
add_display_item "Target Device" SELECT_CUSTOM_DEVICE parameter
add_display_item "Target Device" "explanation2" text "<html></html>"

set tab1_grp1 "General Design Options"
set tab1_grp2 "User Interface"
set tab4 "Test Configurations"
set tab4_grp1 "Test Components"

set hidden_grp "Hidden Parameters"


proc ::altera_sl3::gui_params::conf_params {param_name} {
 
   # Variable for gui
   global tab1_grp1
   global tab1_grp2 
   global tab4_grp1
   global hidden_grp


# Reference for html codes used in this section
 # ----------------------------------------------
 # &lt = less than (<)
 # &gt = greater than (>)
 # <b></b> = bold text
 # <ul></ul> = defines an unordered list
 # <li></li> = bullet list
 # <br> = line break


#--General Settings--

if {[expr {$param_name == "system_family"}]} {
add_display_item $tab1_grp1 "system_family" PARAMETER 
add_parameter "system_family" STRING 
set_parameter_property "system_family" SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property "system_family" DISPLAY_NAME "Device family"
set_parameter_property "system_family" ENABLED 0    
set_parameter_property "system_family" VISIBLE false
set_parameter_property "system_family" HDL_PARAMETER false
set_parameter_property "system_family" DESCRIPTION "Select the targeted device family"
}


if {[expr {$param_name == "DEVICE_FAMILY"}]} {
add_display_item $hidden_grp "DEVICE_FAMILY" PARAMETER 
add_parameter "DEVICE_FAMILY" STRING 
#set_parameter_property "DEVICE_FAMILY" SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property "DEVICE_FAMILY" DISPLAY_NAME "Device family HDL param"
#set_parameter_property "DEVICE_FAMILY" ENABLED 0   
set_parameter_property "DEVICE_FAMILY" ENABLED true
set_parameter_property "DEVICE_FAMILY" DERIVED true 
set_parameter_property "DEVICE_FAMILY" HDL_PARAMETER true
set_parameter_property "DEVICE_FAMILY" VISIBLE false
set_parameter_property "DEVICE_FAMILY" DESCRIPTION "Select the targeted device family"
}


if {[expr {$param_name == "part_trait_bd"}]} {
add_display_item $tab1_grp1 "part_trait_bd" PARAMETER 
add_parameter "part_trait_bd" STRING 
set_parameter_property "part_trait_bd" SYSTEM_INFO_TYPE PART_TRAIT
set_parameter_property "part_trait_bd" SYSTEM_INFO_ARG BASE_DEVICE
set_parameter_property "part_trait_bd" DISPLAY_NAME "Base Device"
set_parameter_property "part_trait_bd" ENABLED 0    
set_parameter_property "part_trait_bd" HDL_PARAMETER false
set_parameter_property "part_trait_bd" VISIBLE false
}


if {[expr {$param_name == "part_trait_device"}]} {
add_display_item $tab1_grp1 "part_trait_device" PARAMETER 
add_parameter "part_trait_device" STRING 
#set_parameter_property "part_trait_device" SYSTEM_INFO {DEVICE}
set_parameter_property "part_trait_device" SYSTEM_INFO_TYPE PART_TRAIT
set_parameter_property "part_trait_device" SYSTEM_INFO_ARG DEVICE
set_parameter_property "part_trait_device" DISPLAY_NAME "Device Part"
set_parameter_property "part_trait_device" ENABLED 0    
set_parameter_property "part_trait_device" HDL_PARAMETER false
set_parameter_property "part_trait_device" VISIBLE false
}


#--Core Settings---


if {[expr {$param_name == "DIRECTION"}]} {
add_display_item $tab1_grp1 "DIRECTION" PARAMETER
add_parameter "DIRECTION" STRING "Duplex"
set_parameter_property "DIRECTION" DISPLAY_NAME "Direction"
set_parameter_property "DIRECTION" DISPLAY_HINT RADIO
set_parameter_property "DIRECTION" ALLOWED_RANGES {"Tx:Source" "Rx:Sink" "Duplex:Duplex"}
set_parameter_property "DIRECTION" HDL_PARAMETER true
set_parameter_property "DIRECTION" VISIBLE true
set_parameter_property "DIRECTION" DERIVED false
set_parameter_property "DIRECTION" DESCRIPTION "Supports simplex transmitter or simplex receiver or full duplex transmissions"
}


if {[expr {$param_name == "LANES"}]} {
add_parameter "LANES" INTEGER 6
add_display_item $tab1_grp1 "LANES" PARAMETER
set_parameter_property "LANES" VISIBLE true
set_parameter_property "LANES" HDL_PARAMETER true
set_parameter_property "LANES" DERIVED false
set_parameter_property "LANES" DISPLAY_NAME "Number of lanes"
set_parameter_property "LANES" ALLOWED_RANGES 1:24
set_parameter_property "LANES" DESCRIPTION "Supports 1 to 24 lanes"
}


if {[expr {$param_name == "METALEN"}]} {
add_parameter "METALEN" INTEGER 200
add_display_item $hidden_grp "METALEN" PARAMETER
set_parameter_property "METALEN" DISPLAY_NAME "Metaframe length HDL"
set_parameter_property "METALEN" ALLOWED_RANGES {200:8191}
set_parameter_property "METALEN" VISIBLE false
set_parameter_property "METALEN" HDL_PARAMETER true
set_parameter_property "METALEN" DISPLAY_UNITS "words"
set_parameter_property "METALEN" DERIVED true
set_parameter_property "METALEN" DESCRIPTION "Specifies the Meta Frame interval in words"
}

if {[expr {$param_name == "meta_frame_length"}]} {
add_parameter "meta_frame_length" INTEGER 200
add_display_item $tab1_grp1 "meta_frame_length" PARAMETER
set_parameter_property "meta_frame_length" DISPLAY_NAME "Meta frame length in words"
set_parameter_property "meta_frame_length" ALLOWED_RANGES {200:8191}
set_parameter_property "meta_frame_length" VISIBLE true
set_parameter_property "meta_frame_length" HDL_PARAMETER false
set_parameter_property "meta_frame_length" DISPLAY_UNITS "words"
set_parameter_property "meta_frame_length" DERIVED false
set_parameter_property "meta_frame_length" DESCRIPTION "Specifies the meta frame length; possible lengths are 200-8191 words"
}


if {[expr {$param_name == "gui_pll_ref_freq"}]} {
add_parameter "gui_pll_ref_freq" FLOAT "312.5"
add_display_item $tab1_grp1 "gui_pll_ref_freq" PARAMETER
set_parameter_property "gui_pll_ref_freq" DISPLAY_NAME "Transceiver reference clock frequency"
set_parameter_property "gui_pll_ref_freq" ALLOWED_RANGES {}
set_parameter_property "gui_pll_ref_freq" DISPLAY_UNITS "MHz"
set_parameter_property "gui_pll_ref_freq" HDL_PARAMETER false
set_parameter_property "gui_pll_ref_freq" DESCRIPTION "Specifies the transceiver's reference clock frequency compatible with given set of user parameters."
}


if {[expr {$param_name == "gui_analog_voltage"}]} {
add_parameter "gui_analog_voltage" STRING "1_0V"
add_display_item $tab1_grp1 "gui_analog_voltage" PARAMETER
set_parameter_property "gui_analog_voltage" DISPLAY_NAME "VCCR_GXB and VCCT_GXB supply voltage for the Transceiver"
set_parameter_property "gui_analog_voltage" ALLOWED_RANGES {}
set_parameter_property "gui_analog_voltage" HDL_PARAMETER false
set_parameter_property "gui_analog_voltage" DESCRIPTION "Selects the VCCR_GXB and VCCT_GXB supply voltage for the transceiver"
}


if {[expr {$param_name == "ECC_ENABLE"}]} {
add_parameter "ECC_ENABLE" BOOLEAN "false"
add_display_item $hidden_grp  "ECC_ENABLE" PARAMETER
set_parameter_property "ECC_ENABLE" DISPLAY_NAME "Enable ECC protection HDL"
set_parameter_property "ECC_ENABLE" VISIBLE false
set_parameter_property "ECC_ENABLE" HDL_PARAMETER true
set_parameter_property "ECC_ENABLE" DERIVED true
set_parameter_property "ECC_ENABLE" DESCRIPTION "Enables built-in ECC support on the M20K embedded block memory for single-error correction, double-adjacent-error correction, and triple-adjacent-error detection"
}

if {[expr {$param_name == "gui_ecc_enable"}]} {
add_parameter "gui_ecc_enable" BOOLEAN "false"
add_display_item $tab1_grp1 "gui_ecc_enable" PARAMETER
set_parameter_property "gui_ecc_enable" DISPLAY_NAME "Enable M20K ECC support"
set_parameter_property "gui_ecc_enable" VISIBLE true
set_parameter_property "gui_ecc_enable" HDL_PARAMETER false
set_parameter_property "gui_ecc_enable" DERIVED false
set_parameter_property "gui_ecc_enable" DESCRIPTION "ECC Protection for Memory Blocks"
}


if {[expr {$param_name == "STREAM"}]} {
add_display_item $tab1_grp2 "STREAM" parameter
add_parameter "STREAM" STRING "FULL"
set_parameter_property "STREAM" ALLOWED_RANGES {"BASIC" "FULL"}
set_parameter_property "STREAM" DISPLAY_NAME "Streaming Mode"
set_parameter_property "STREAM" UNITS None
set_parameter_property "STREAM" ENABLED true
set_parameter_property "STREAM" VISIBLE false
set_parameter_property "STREAM" DEFAULT_VALUE "FULL"
set_parameter_property "STREAM" HDL_PARAMETER true
set_parameter_property "STREAM" DESCRIPTION "Specifies the streaming mode"
}


if {[expr {$param_name == "BURST_GAP"}]} {
add_display_item $tab1_grp2 "BURST_GAP" parameter
add_parameter "BURST_GAP" INTEGER 2
set_parameter_property "BURST_GAP" ALLOWED_RANGES {1 2}
set_parameter_property "BURST_GAP" DISPLAY_NAME "Required idle cycles between bursts"
set_parameter_property "BURST_GAP" UNITS None
set_parameter_property "BURST_GAP" ENABLED true
set_parameter_property "BURST_GAP" VISIBLE true 
set_parameter_property "BURST_GAP" HDL_PARAMETER true
set_parameter_property "BURST_GAP" DEFAULT_VALUE 2
set_parameter_property "BURST_GAP" DESCRIPTION "Supports two values to optimize for bandwidth efficiency or maintain backwards compatibility with existing SerialLite III Streaming IP cores (legacy) in the field"
set_parameter_property "BURST_GAP" DESCRIPTION "1: Recommended for high bandwidth streaming. (Same Burst Gap setting must be set for both Source and Sink IP core)"
}

if {[expr {$param_name == "ADAPT_PFULL_THRESHOLD"}]} {
add_display_item $tab1_grp2 "ADAPT_PFULL_THRESHOLD" parameter
add_parameter "ADAPT_PFULL_THRESHOLD" INTEGER 15
set_parameter_property "ADAPT_PFULL_THRESHOLD" ALLOWED_RANGES {8 9 10 11 12 13 14 15 16 17 18}
set_parameter_property "ADAPT_PFULL_THRESHOLD" DISPLAY_NAME "Adaptation FIFO partial full threshold"
set_parameter_property "ADAPT_PFULL_THRESHOLD" UNITS None
set_parameter_property "ADAPT_PFULL_THRESHOLD" ENABLED true
set_parameter_property "ADAPT_PFULL_THRESHOLD" VISIBLE true 
set_parameter_property "ADAPT_PFULL_THRESHOLD" HDL_PARAMETER true
set_parameter_property "ADAPT_PFULL_THRESHOLD" DEFAULT_VALUE 15
set_parameter_property "ADAPT_PFULL_THRESHOLD" DESCRIPTION "Back pressure the upstream data thru tx_ready port whenever the partial full flag trigger."
}


if {[expr {$param_name == "ADVANCED_CLOCKING"}]} {
add_parameter ADVANCED_CLOCKING BOOLEAN "false"
add_display_item $hidden_grp  "ADVANCED_CLOCKING" PARAMETER
set_parameter_property "ADVANCED_CLOCKING" DISPLAY_NAME "Advanced Clocking Mode HDL"
set_parameter_property ADVANCED_CLOCKING VISIBLE false
set_parameter_property ADVANCED_CLOCKING HDL_PARAMETER true
set_parameter_property ADVANCED_CLOCKING DERIVED true
set_parameter_property "ADVANCED_CLOCKING" DESCRIPTION "Select to use Advanced clocking mode, unselect to use Standard clocking mode"
}


if {[expr {$param_name == "gui_clocking_mode"}]} {
add_parameter gui_clocking_mode BOOLEAN "false"
add_display_item $tab1_grp2 "gui_clocking_mode" PARAMETER
set_parameter_property "gui_clocking_mode" DISPLAY_NAME "Clocking mode"
set_parameter_property gui_clocking_mode DISPLAY_HINT radio
set_parameter_property gui_clocking_mode ALLOWED_RANGES {"false:Standard clocking mode" "true:Advanced clocking mode"}
set_parameter_property gui_clocking_mode VISIBLE true
set_parameter_property gui_clocking_mode HDL_PARAMETER false
set_parameter_property gui_clocking_mode DERIVED false
set_parameter_property gui_clocking_mode DEFAULT_VALUE "false"
set_parameter_property "gui_clocking_mode" DESCRIPTION "<b>Standard clocking mode:</b><br> Generates an output clock at the transmit user interface to be used for user logic clocking. On the receive user interface, an output clock is provided. See User Guide for more details.<br><br>
<b>Advanced clocking mode:</b><br> Allows for a clock to be provided as an input to the transmit user interface. On the receive user interface, an output clock is provided. See User Guide for more details.<br><br> 
"
}


if {[expr {$param_name == "gui_user_input"}]} {
add_parameter "gui_user_input" INTEGER 0
add_display_item $tab1_grp2 "gui_user_input" PARAMETER
set_parameter_property "gui_user_input" DISPLAY_NAME "User input"
set_parameter_property "gui_user_input" DISPLAY_HINT radio
set_parameter_property "gui_user_input" AFFECTS_ELABORATION true
set_parameter_property "gui_user_input" ALLOWED_RANGES {"0:User clock frequency" "1:Transceiver data rate"}
set_parameter_property "gui_user_input" IS_HDL_PARAMETER false
set_parameter_property "gui_user_input" DESCRIPTION "<b>Transceiver data rate:</b><br> Users have to provide required transceiver data rate in order to derive the user clock frequency.<br><br>
<b>User clock frequency:</b><br> Users have to provide required user clock frequency in order to derive the transceiver data rate.<br><br> 
"
}


if {[expr {$param_name == "gui_user_clock_frequency"}]} {
add_parameter "gui_user_clock_frequency" FLOAT 177.556818
add_display_item $tab1_grp2 "gui_user_clock_frequency" PARAMETER
set_parameter_property "gui_user_clock_frequency" DISPLAY_NAME "User clock frequency required"
set_parameter_property "gui_user_clock_frequency" DISPLAY_UNITS "MHz"
set_parameter_property "gui_user_clock_frequency" DISPLAY_HINT "user_clock_frequency"
set_parameter_property "gui_user_clock_frequency" AFFECTS_ELABORATION true
set_parameter_property "gui_user_clock_frequency" AFFECTS_GENERATION true
set_parameter_property "gui_user_clock_frequency" IS_HDL_PARAMETER false
set_parameter_property "gui_user_clock_frequency" DESCRIPTION "The user specifies the frequency desired for the user clock input or output for the transmit and receive user interface (dependent on clocking mode selected: output for Standard Clocking Mode, input for Advanced Clocking Mode). This frequency in turn determines the required transceiver data rate to support the calculated transmit and receive bandwidths"
}


#--Transceiver Settings---

if {[expr {$param_name == "gui_pll_type"}]} {
add_display_item $tab1_grp2 "gui_pll_type" parameter
add_parameter "gui_pll_type" STRING "CMU"
set_parameter_property "gui_pll_type" ALLOWED_RANGES {"CMU" "ATX"}
set_parameter_property "gui_pll_type" DISPLAY_NAME "PLL type"
set_parameter_property "gui_pll_type" UNITS None
set_parameter_property "gui_pll_type" ENABLED true
set_parameter_property "gui_pll_type" VISIBLE true
set_parameter_property "gui_pll_type" HDL_PARAMETER false
set_parameter_property "gui_pll_type" DESCRIPTION "Specifies the PLL type"
}

if {[expr {$param_name == "lane_rate"}]} {
add_parameter "lane_rate" float 12.5
add_display_item $tab1_grp2 "lane_rate" PARAMETER
set_parameter_property "lane_rate" VISIBLE false
set_parameter_property "lane_rate" HDL_PARAMETER false
set_parameter_property "lane_rate" DERIVED true
set_parameter_property "lane_rate" DISPLAY_NAME "Transceiver data rate"
set_parameter_property "lane_rate" DISPLAY_UNITS "Gbps"
set_parameter_property "lane_rate" DESCRIPTION "The effective data rate at the output of the transceiver incorporating transmission and other overheads. The value is automatically calculated from the user parameters."
}


if {[expr {$param_name == "gui_xcvr_data_rate"}]} {
add_parameter "gui_xcvr_data_rate" float 12.5
add_display_item $tab1_grp2 "gui_xcvr_data_rate" PARAMETER
set_parameter_property "gui_xcvr_data_rate" DISPLAY_NAME "Transceiver data rate"
set_parameter_property "gui_xcvr_data_rate" DISPLAY_UNITS "Gbps"
set_parameter_property "gui_xcvr_data_rate" AFFECTS_ELABORATION true
set_parameter_property "gui_xcvr_data_rate" AFFECTS_GENERATION true
set_parameter_property "gui_xcvr_data_rate" IS_HDL_PARAMETER false
}


if {[expr {$param_name == "gui_actual_user_clock_frequency"}]} {
add_parameter "gui_actual_user_clock_frequency" STRING "177.556818"
add_display_item $tab1_grp2 "gui_actual_user_clock_frequency" PARAMETER
set_parameter_property "gui_actual_user_clock_frequency" DISPLAY_NAME "User clock frequency output"
set_parameter_property "gui_actual_user_clock_frequency" DISPLAY_UNITS "MHz"
set_parameter_property "gui_actual_user_clock_frequency" AFFECTS_GENERATION true
set_parameter_property "gui_actual_user_clock_frequency" IS_HDL_PARAMETER false
set_parameter_property "gui_actual_user_clock_frequency" DERIVED true
set_parameter_property "gui_actual_user_clock_frequency" DESCRIPTION "Specifies the actual user clock frequency at the clock output(s) for either Standard or Advanced Clocking Modes."
set_display_item_property "gui_actual_user_clock_frequency" DISPLAY_HINT "columns:11"
}


if {[expr {$param_name == "lane_rate_recommended"}]} {
add_parameter "lane_rate_recommended" float 14
add_display_item $tab1_grp2 "lane_rate_recommended" PARAMETER
set_parameter_property "lane_rate_recommended" HDL_PARAMETER false
set_parameter_property "lane_rate_recommended" DERIVED true
set_parameter_property "lane_rate_recommended" DISPLAY_NAME "Transceiver data rate"
set_parameter_property "lane_rate_recommended" DISPLAY_UNITS "Gbps"
set_parameter_property "lane_rate_recommended" DESCRIPTION "The effective data rate at the output of the transceiver incorporating transmission and other overheads. The value is automatically calculated from the user parameters by rounding up to 1 decimal place in Gbps unit."
}


if {[expr {$param_name == "gui_actual_coreclkin_frequency"}]} {
add_parameter "gui_actual_coreclkin_frequency" FLOAT "205.078125"
add_display_item $tab1_grp2 "gui_actual_coreclkin_frequency" PARAMETER
set_parameter_property "gui_actual_coreclkin_frequency" DISPLAY_NAME "Core clock frequency"
set_parameter_property "gui_actual_coreclkin_frequency" DISPLAY_UNITS "MHz"
set_parameter_property "gui_actual_coreclkin_frequency" DISPLAY_HINT "coreclkin_frequency"
set_parameter_property "gui_actual_coreclkin_frequency" AFFECTS_GENERATION true
set_parameter_property "gui_actual_coreclkin_frequency" HDL_PARAMETER false
set_parameter_property "gui_actual_coreclkin_frequency" DERIVED true
set_parameter_property "gui_actual_coreclkin_frequency" VISIBLE false
set_parameter_property "gui_actual_coreclkin_frequency" DESCRIPTION "Specifies the frequency of the core clock at Interlaken PHY IP interface. The value is automatically calculated."
}


if {[expr {$param_name == "in_lane_rate"}]} {
add_parameter "in_lane_rate" float 2000
add_display_item $tab1_grp2 "in_lane_rate" PARAMETER
set_parameter_property "in_lane_rate" DISPLAY_NAME "Input data rate per lane"
set_parameter_property "in_lane_rate" DISPLAY_UNITS "Gbps"
set_parameter_property "in_lane_rate" HDL_PARAMETER false
set_parameter_property "in_lane_rate" DERIVED true
set_parameter_property "in_lane_rate" VISIBLE false
set_parameter_property "in_lane_rate" DESCRIPTION "The value represents the user input/output data rate per lane that is supported with current configuration."
}


if {[expr {$param_name == "gui_aggregate_data_rate"}]} {
add_parameter "gui_aggregate_data_rate" FLOAT ""
add_display_item $tab1_grp2 "gui_aggregate_data_rate" PARAMETER
set_parameter_property "gui_aggregate_data_rate" DISPLAY_NAME "Aggregate user bandwidth"
set_parameter_property "gui_aggregate_data_rate" DISPLAY_UNITS "Gbps"
set_parameter_property "gui_aggregate_data_rate" HDL_PARAMETER false
set_parameter_property "gui_aggregate_data_rate" DERIVED true
set_parameter_property "gui_aggregate_data_rate" DESCRIPTION "This value is derived by multiplying the number of lanes and user interface data rate."
}


if {[expr {$param_name == "int_reference_clock_frequency"}]} {
add_parameter "int_reference_clock_frequency" FLOAT "257.8125"
add_display_item $tab4_grp1 "int_reference_clock_frequency" PARAMETER
set_parameter_property "int_reference_clock_frequency" DISPLAY_NAME "IOPLL reference clock frequency"
set_parameter_property "int_reference_clock_frequency" DISPLAY_UNITS "MHz"
set_parameter_property "int_reference_clock_frequency" DISPLAY_HINT "IOPLL reference_clock_frequency"
set_parameter_property "int_reference_clock_frequency" VISIBLE false
set_parameter_property "int_reference_clock_frequency" HDL_PARAMETER false
set_parameter_property "int_reference_clock_frequency" DERIVED false
set_parameter_property "int_reference_clock_frequency" DESCRIPTION "Specifies the IOPLL reference clock frequency"
}

##########################################
# EXAMPLE DESIGNS OPTIONS
##########################################
if {[expr {$param_name == "gui_ed_option"}]} {
add_parameter gui_ed_option STRING "Standard Clocking Mode"
add_display_item "Available Example Designs" gui_ed_option PARAMETER
set_parameter_property gui_ed_option DISPLAY_NAME "Select Design"
set_parameter_property gui_ed_option ALLOWED_RANGES {"Standard Clocking Mode"}
set_parameter_property gui_ed_option DESCRIPTION "<html>Please select available design for Example Design generation.<br><br><b>Standard Clocking Mode/Advanced Clocking Mode</b>: Current design only able to generate example design for simulation. However, we have other example designs that come with specific IP and related parameter settings that you may use by selecting one of the presets below.<br><br><i>Please note that when you apply preset, current IP and other parameter settings will be set to match those of selected preset. If you like to save your current settings, you should do so before you hit apply preset. Also you can always save the new 'preset' settings under a different name using File->Save as</i></html>"
set_parameter_property gui_ed_option HDL_PARAMETER false
}

if {[expr {$param_name == "ed_option"}]} {
add_parameter ed_option STRING "Standard Clocking Mode"
set_parameter_property ed_option DERIVED true
set_parameter_property ed_option VISIBLE false
set_parameter_property ed_option HDL_PARAMETER false
}

if {[expr {$param_name == "ENABLE_ED_FILESET_SYNTHESIS"}]} {
add_parameter ENABLE_ED_FILESET_SYNTHESIS INTEGER 1
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DEFAULT_VALUE 1
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DISPLAY_NAME "Synthesis"
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DESCRIPTION "When Synthesis box is checked, all necessary filesets required for synthesis will be generated when 'Generate Example Design' is clicked. Expect an additional 1-2 minute delay when generating the synthesis fileset.<br><br>When this box is NOT checked, filesets required for synthesis will NOT be generated."
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS TYPE INTEGER
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS UNITS None
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DISPLAY_HINT boolean
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS HDL_PARAMETER false
set_parameter_update_callback ENABLE_ED_FILESET_SYNTHESIS update_ed_fileset_synthesis
}

if {[expr {$param_name == "ENABLE_ED_FILESET_SIM"}]} {
add_parameter ENABLE_ED_FILESET_SIM INTEGER 0
set_parameter_property ENABLE_ED_FILESET_SIM DEFAULT_VALUE 1
set_parameter_property ENABLE_ED_FILESET_SIM DISPLAY_NAME "Simulation"
set_parameter_property ENABLE_ED_FILESET_SIM DESCRIPTION "When Simulation box is checked, all necessary filesets required for simulation will be generated when 'Generate Example Design' is clicked. Expect an additional 1-2 minute delay when generating the simulation fileset.<br><br>When this box is NOT checked, filesets required for simulation will NOT be generated."
set_parameter_property ENABLE_ED_FILESET_SIM TYPE INTEGER
set_parameter_property ENABLE_ED_FILESET_SIM UNITS None
set_parameter_property ENABLE_ED_FILESET_SIM DISPLAY_HINT boolean
set_parameter_property ENABLE_ED_FILESET_SIM HDL_PARAMETER false
}

if {[expr {$param_name == "SELECT_ED_FILESET"}]} {
add_parameter SELECT_ED_FILESET INTEGER 0
add_display_item "Generated HDL Format" SELECT_ED_FILESET PARAMETER
set_parameter_property SELECT_ED_FILESET DEFAULT_VALUE "0"
set_parameter_property SELECT_ED_FILESET DISPLAY_NAME "Generate File Format"
set_parameter_property SELECT_ED_FILESET DESCRIPTION "Please select an HDL format for the generated Example Design filesets."
set_parameter_property SELECT_ED_FILESET allowed_ranges {
"0:Verilog"
"1:VHDL"
}
set_parameter_property SELECT_ED_FILESET HDL_PARAMETER false
}

if {[expr {$param_name == "SELECT_TARGETED_DEVICE"}]} {
add_parameter SELECT_TARGETED_DEVICE INTEGER 3
set_parameter_property SELECT_TARGETED_DEVICE DEFAULT_VALUE "3"
set_parameter_property SELECT_TARGETED_DEVICE DISPLAY_NAME "Select Board"
set_parameter_property SELECT_TARGETED_DEVICE DESCRIPTION "<html>This option provides supports for various Development Kits listed. The details of Altera Development Kits can be found on Altera website <a href='https://www.altera.com/products/boards_and_kits/all-development-kits.html'>https://www.altera.com/products/boards_and_kits/all-development-kits.html</a>. If this menu is greyed out, it is because no board is supported for the options selected such as synthesis checked off. If an Altera Development board is selected, the Target Device used for generation will be the one that matches the device on the Development Kit<br><br>
<b>Altera  Development Kit:</b><br>
This option allows the Example Design to be tested on the selected Altera development kit. This selection automatically selects the Target Device to match the device on the selected Altera development kit. If your board revision has a different grade of this device, you can correct it.<br><br>
<b>Custom Development Kit:</b><br>
This option allows the Example Design to be tested on a third party development kit with Altera device, a custom designed board with Altera device, or a standard Altera development kit not available for selection.  You may also select a custom device for the custom development kit.<br><br>
<b>No Development Kit:</b><br>
This option excluding hardware aspects for the Example Design.</html>"
set_parameter_property SELECT_TARGETED_DEVICE allowed_ranges {
"1:Stratix 10 GX Signal Integrity Development Kit"
"2:Custom Development Kit"
"3:No Development Kit"
}
set_parameter_property SELECT_TARGETED_DEVICE HDL_PARAMETER false
}

if {[expr {$param_name == "SELECT_CUSTOM_DEVICE"}]} {
add_parameter SELECT_CUSTOM_DEVICE INTEGER 0
set_parameter_property SELECT_CUSTOM_DEVICE DEFAULT_VALUE 0
set_parameter_property SELECT_CUSTOM_DEVICE DISPLAY_NAME "Change Target Device"
set_parameter_property SELECT_CUSTOM_DEVICE DESCRIPTION "<html>When select, user is able to select different device grade for Altera development kit. For device specific details look for Device data sheet on <a href='http://www.altera.com/'>www.altera.com</a></html>"
set_parameter_property SELECT_CUSTOM_DEVICE TYPE INTEGER
set_parameter_property SELECT_CUSTOM_DEVICE UNITS None
set_parameter_property SELECT_CUSTOM_DEVICE DISPLAY_HINT boolean
set_parameter_property SELECT_CUSTOM_DEVICE HDL_PARAMETER false
}

##########################################
# HIDDEN Parameters
##########################################

# Set HDL param addr-width from no of lanes for A10
if {[expr {$param_name == "ADDR_WIDTH"}]} {
 add_display_item $hidden_grp "ADDR_WIDTH" PARAMETER 
 add_parameter "ADDR_WIDTH" INTEGER 16
 set_parameter_property "ADDR_WIDTH" VISIBLE false
 set_parameter_property "ADDR_WIDTH" HDL_PARAMETER true
 set_parameter_property "ADDR_WIDTH" DERIVED true
} 

if {[expr {$param_name == "PULSE_WIDTH"}]} {
 add_display_item $hidden_grp "PULSE_WIDTH" PARAMETER 
 add_parameter "PULSE_WIDTH" INTEGER 1
 set_parameter_property "PULSE_WIDTH" VISIBLE false
 set_parameter_property "PULSE_WIDTH" HDL_PARAMETER true
 set_parameter_property "PULSE_WIDTH" DERIVED true
} 

##if {[expr {$param_name == "MAX_LANES"}]} {
## add_display_item $hidden_grp "MAX_LANES" PARAMETER 
## add_parameter "MAX_LANES" INTEGER 24
## set_parameter_property "MAX_LANES" VISIBLE false
## set_parameter_property "MAX_LANES" HDL_PARAMETER true
## set_parameter_property "MAX_LANES" DERIVED true
##}
 
##if {[expr {$param_name == "SYNC_DEPTH"}]} {
## add_display_item $hidden_grp "SYNC_DEPTH" PARAMETER 
## add_parameter "SYNC_DEPTH" INTEGER 2
## set_parameter_property "SYNC_DEPTH" VISIBLE false
## set_parameter_property "SYNC_DEPTH" HDL_PARAMETER true
## set_parameter_property "SYNC_DEPTH" DERIVED true
##}
 
##if {[expr {$param_name == "ADAPTATION_FIFO_DEPTH"}]} {
## add_display_item $hidden_grp "ADAPTATION_FIFO_DEPTH" PARAMETER 
##add_parameter "ADAPTATION_FIFO_DEPTH" INTEGER 32
##set_parameter_property "ADAPTATION_FIFO_DEPTH" VISIBLE false
##set_parameter_property "ADAPTATION_FIFO_DEPTH" HDL_PARAMETER true
##set_parameter_property "ADAPTATION_FIFO_DEPTH" DERIVED true
##}


if {[expr {$param_name == "XCVR_TX_PARALLEL_DATA_WIDTH"}]} {
add_display_item $hidden_grp "XCVR_TX_PARALLEL_DATA_WIDTH" PARAMETER 
add_parameter "XCVR_TX_PARALLEL_DATA_WIDTH" INTEGER 64
set_parameter_property "XCVR_TX_PARALLEL_DATA_WIDTH" VISIBLE false
set_parameter_property "XCVR_TX_PARALLEL_DATA_WIDTH" HDL_PARAMETER true
set_parameter_property "XCVR_TX_PARALLEL_DATA_WIDTH" DERIVED true
}

if {[expr {$param_name == "PHY_DATA_WIDTH"}]} {
add_display_item $hidden_grp "PHY_DATA_WIDTH" PARAMETER 
add_parameter "PHY_DATA_WIDTH" INTEGER 64
set_parameter_property "PHY_DATA_WIDTH" VISIBLE false
set_parameter_property "PHY_DATA_WIDTH" HDL_PARAMETER true
set_parameter_property "PHY_DATA_WIDTH" DERIVED true
}

##if {[expr {$param_name == "XCVR_RX_PARALLEL_DATA_WIDTH"}]} {
##add_display_item $hidden_grp "XCVR_RX_PARALLEL_DATA_WIDTH" PARAMETER 
##add_parameter "XCVR_RX_PARALLEL_DATA_WIDTH" INTEGER 64
##set_parameter_property "XCVR_RX_PARALLEL_DATA_WIDTH" VISIBLE false
##set_parameter_property "XCVR_RX_PARALLEL_DATA_WIDTH" HDL_PARAMETER true
##set_parameter_property "XCVR_RX_PARALLEL_DATA_WIDTH" DERIVED true
##}

##if {[expr {$param_name == "XCVR_TX_CONTROL_WIDTH"}]} {
##add_display_item $hidden_grp "XCVR_TX_CONTROL_WIDTH" PARAMETER 
##add_parameter "XCVR_TX_CONTROL_WIDTH" INTEGER 9
##set_parameter_property "XCVR_TX_CONTROL_WIDTH" VISIBLE false
##set_parameter_property "XCVR_TX_CONTROL_WIDTH" HDL_PARAMETER true
##set_parameter_property "XCVR_TX_CONTROL_WIDTH" DERIVED true
##}

##if {[expr {$param_name == "XCVR_RX_CONTROL_WIDTH"}]} {
##add_display_item $hidden_grp "XCVR_RX_CONTROL_WIDTH" PARAMETER 
##add_parameter "XCVR_RX_CONTROL_WIDTH" INTEGER 10
##set_parameter_property "XCVR_RX_CONTROL_WIDTH" VISIBLE false
##set_parameter_property "XCVR_RX_CONTROL_WIDTH" HDL_PARAMETER true
##set_parameter_property "XCVR_RX_CONTROL_WIDTH" DERIVED true
##}

if {[expr {$param_name == "TX_PHY_CTL_WIDTH"}]} {
add_display_item $hidden_grp "TX_PHY_CTL_WIDTH" PARAMETER 
add_parameter "TX_PHY_CTL_WIDTH" INTEGER 3
set_parameter_property "TX_PHY_CTL_WIDTH" VISIBLE false
set_parameter_property "TX_PHY_CTL_WIDTH" HDL_PARAMETER true
set_parameter_property "TX_PHY_CTL_WIDTH" DERIVED true
}

if {[expr {$param_name == "RX_PHY_CTL_WIDTH"}]} {
add_display_item $hidden_grp "RX_PHY_CTL_WIDTH" PARAMETER 
add_parameter "RX_PHY_CTL_WIDTH" INTEGER 10
set_parameter_property "RX_PHY_CTL_WIDTH" VISIBLE false
set_parameter_property "RX_PHY_CTL_WIDTH" HDL_PARAMETER true
set_parameter_property "RX_PHY_CTL_WIDTH" DERIVED true
}

if {[expr {$param_name == "UNUSED_TX_PARALLEL_WIDTH"}]} {
add_display_item $hidden_grp "UNUSED_TX_PARALLEL_WIDTH" PARAMETER  
add_parameter "UNUSED_TX_PARALLEL_WIDTH" INTEGER 11
set_parameter_property "UNUSED_TX_PARALLEL_WIDTH" HDL_PARAMETER true
set_parameter_property "UNUSED_TX_PARALLEL_WIDTH" VISIBLE false
set_parameter_property "UNUSED_TX_PARALLEL_WIDTH" DERIVED true
}
	
if {[expr {$param_name == "PMA_MODE"}]} {
add_display_item $hidden_grp "PMA_MODE" PARAMETER 
add_parameter "PMA_MODE" INTEGER 40
set_parameter_property "PMA_MODE" VISIBLE false
set_parameter_property "PMA_MODE" HDL_PARAMETER true
set_parameter_property "PMA_MODE" DERIVED true
}

if {[expr {$param_name == "sdc_constraint"}]} {  
    add_display_item $hidden_grp "sdc_constraint" PARAMETER  
    add_parameter "sdc_constraint" float 1.00
    set_parameter_property "sdc_constraint" DISPLAY_NAME "Set constraint for sdc"
    set_parameter_property "sdc_constraint" HDL_PARAMETER false
    set_parameter_property "sdc_constraint" VISIBLE false
}

if {[expr {$param_name == "SHOW_ALLOWED_CDR_FREQ_INFO"}]} {
add_display_item $hidden_grp "SHOW_ALLOWED_CDR_FREQ_INFO" PARAMETER 
add_parameter "SHOW_ALLOWED_CDR_FREQ_INFO" BOOLEAN "false"
set_parameter_property "SHOW_ALLOWED_CDR_FREQ_INFO" VISIBLE false
set_parameter_property "SHOW_ALLOWED_CDR_FREQ_INFO" HDL_PARAMETER false
set_parameter_property "SHOW_ALLOWED_CDR_FREQ_INFO" DERIVED false
}

if {[expr {$param_name == "TEST_COMPONENTS_EN"}]} {  
    add_display_item $tab4_grp1 "TEST_COMPONENTS_EN" PARAMETER  
    add_parameter "TEST_COMPONENTS_EN" boolean false
    set_parameter_property "TEST_COMPONENTS_EN" DISPLAY_NAME "Add Test Components"
    set_parameter_property "TEST_COMPONENTS_EN" HDL_PARAMETER false
    set_parameter_property "TEST_COMPONENTS_EN" VISIBLE false
}

if {[expr {$param_name == "GUI_USE_FPLL"}]} {  
    add_display_item $tab4_grp1 "GUI_USE_FPLL" PARAMETER  
    add_parameter "GUI_USE_FPLL" boolean false
    set_parameter_property "GUI_USE_FPLL" DISPLAY_NAME "Use fPLL"
    set_parameter_property "GUI_USE_FPLL" HDL_PARAMETER false
    set_parameter_property "GUI_USE_FPLL" VISIBLE false
}


###################################################################################

}

proc ::altera_sl3::gui_params::params_top_hw {} {
# List down what parameters to add. 
  define_params "system_family"
  define_params "part_trait_bd"
  define_params "part_trait_device"
  define_params "DIRECTION" 
  define_params "LANES" 
  define_params "meta_frame_length"
  define_params "gui_pll_ref_freq"
  define_params "gui_analog_voltage"
  define_params "gui_ecc_enable"
  define_params "STREAM"
  define_params "BURST_GAP"
  define_params "ADAPT_PFULL_THRESHOLD"
  define_params "gui_clocking_mode"
  define_params "gui_user_input"
  define_params "gui_user_clock_frequency"
  define_params "gui_actual_coreclkin_frequency" 
  define_params "lane_rate"
  define_params "gui_xcvr_data_rate"
  define_params "gui_actual_user_clock_frequency"
  define_params "lane_rate_recommended"
  define_params "gui_pll_type"
  define_params "in_lane_rate"
  define_params "gui_aggregate_data_rate"
  define_params "int_reference_clock_frequency"
  define_params "ADVANCED_CLOCKING"
  define_params "DEVICE_FAMILY"
  define_params "METALEN"
  define_params "ECC_ENABLE"
  define_params "ADDR_WIDTH"
  define_params "PMA_MODE"
  define_params "PULSE_WIDTH"
  define_params "PHY_DATA_WIDTH"
  define_params "TX_PHY_CTL_WIDTH"
  define_params "RX_PHY_CTL_WIDTH"
  define_params "sdc_constraint"
  define_params "SHOW_ALLOWED_CDR_FREQ_INFO"
  define_params "TEST_COMPONENTS_EN"
  define_params "GUI_USE_FPLL"
  define_params "gui_ed_option"
  define_params "ed_option"
  define_params "ENABLE_ED_FILESET_SYNTHESIS"
  define_params "ENABLE_ED_FILESET_SIM"
  define_params "SELECT_ED_FILESET"  
  define_params "SELECT_TARGETED_DEVICE"
  define_params "SELECT_CUSTOM_DEVICE"
  define_params "UNUSED_TX_PARALLEL_WIDTH"

# Define GUI Layout
  global tab1_grp1
  global tab1_grp2
  global tab4_grp1

#  add_display_item $tab1_grp1 GROUP
#  add_display_item $tab1_grp2 GROUP

# Add selected parameters
  global GLOBAL_PARAMS
  foreach params $GLOBAL_PARAMS {
  conf_params $params

  set_parameter_property $params AFFECTS_VALIDATION true
  set_parameter_property $params AFFECTS_GENERATION true
  set_parameter_property $params AFFECTS_ELABORATION true
  if {[ expr {$params == "sdc_constraint" || $params == "METALEN"}]} {
     set_parameter_property $params VISIBLE false
     }

  }

}



proc ::altera_sl3::gui_params::params_phy_hw {} {
# List down what parameters to add. 
  define_params "DEVICE_FAMILY" 
  define_params "LANES" 
  define_params "DIRECTION" 
  define_params "gui_pll_type"
  define_params "METALEN" 
  define_params "gui_pll_ref_freq"
  define_params "gui_analog_voltage"
  define_params "lane_rate"
  define_params "lane_rate_recommended"
  define_params "ADDR_WIDTH"
  define_params "PULSE_WIDTH"
  define_params "ADVANCED_CLOCKING"
  define_params "PHY_DATA_WIDTH"
  define_params "TX_PHY_CTL_WIDTH"
  define_params "RX_PHY_CTL_WIDTH"
  define_params "PMA_MODE"
  define_params "UNUSED_TX_PARALLEL_WIDTH"
  define_params "TEST_COMPONENTS_EN"


# Add selected parameters
   global GLOBAL_PARAMS
   foreach params $GLOBAL_PARAMS {
   conf_params $params
   set_parameter_property $params AFFECTS_GENERATION true
   set_parameter_property $params DERIVED false
   set_parameter_property $params VISIBLE true
   }
}

proc ::altera_sl3::gui_params::params_source_mac_hw {} {
# List down what parameters to add. 
  define_params "DEVICE_FAMILY" 
  define_params "LANES" 
#  define_params "METALEN"
  define_params "ECC_ENABLE"
#  define_params "ADVANCED_CLOCKING"
  define_params "DIRECTION" 
  define_params "STREAM"
  define_params "BURST_GAP"
  define_params "ADAPT_PFULL_THRESHOLD"
  define_params "gui_user_input"
  define_params "gui_user_clock_frequency"
  define_params "gui_actual_user_clock_frequency"
  define_params "gui_pll_ref_freq"
  define_params "gui_ecc_enable"
  define_params "gui_clocking_mode"
  define_params "lane_rate_recommended"
  define_params "sdc_constraint"

# Add selected parameters
   global GLOBAL_PARAMS
   foreach params $GLOBAL_PARAMS {
   conf_params $params
   if {$params == "DIRECTION"} {
      set_parameter_property $params HDL_PARAMETER false
   } 
   set_parameter_property $params AFFECTS_GENERATION true
   set_parameter_property $params DERIVED false
   set_parameter_property $params VISIBLE true
   if {[ expr {$params == "sdc_constraint"}]} {
     set_parameter_property $params VISIBLE false
     }

   }
}

proc ::altera_sl3::gui_params::params_sink_mac_hw {} {
# List down what parameters to add. 
  define_params "DEVICE_FAMILY" 
  define_params "LANES" 
  define_params "ECC_ENABLE"
  define_params "STREAM"
  define_params "ADVANCED_CLOCKING"
  define_params "DIRECTION" 
  define_params "BURST_GAP"
  define_params "gui_user_input"
  define_params "gui_user_clock_frequency"
  define_params "gui_actual_user_clock_frequency"
  define_params "gui_ecc_enable"
  define_params "gui_clocking_mode"
  define_params "gui_pll_ref_freq"
  define_params "lane_rate_recommended"
  define_params "sdc_constraint"

# Add selected parameters
   global GLOBAL_PARAMS
   foreach params $GLOBAL_PARAMS {
   conf_params $params
   if {$params == "DIRECTION" || $params == "DEVICE_FAMILY"} {
      set_parameter_property $params HDL_PARAMETER false
   } 
   set_parameter_property $params AFFECTS_GENERATION true
   set_parameter_property $params DERIVED false
   set_parameter_property $params VISIBLE true
   if {[ expr {$params == "sdc_constraint"}]} {
     set_parameter_property $params VISIBLE false
     }

   }
}



proc ::altera_sl3::gui_params::params_interlaken_soft_hw {} {
# List down what parameters to add. 
  define_params "DEVICE_FAMILY" 
  define_params "LANES" 
  define_params "DIRECTION" 
  define_params "ADVANCED_CLOCKING"
  define_params "ADDR_WIDTH"
  define_params "PULSE_WIDTH"


# Add selected parameters
   global GLOBAL_PARAMS
   foreach params $GLOBAL_PARAMS {
   conf_params $params
   if {$params == "ADVANCED_CLOCKING"} {
      set_parameter_property $params HDL_PARAMETER false
   } 
   set_parameter_property $params AFFECTS_GENERATION true
   set_parameter_property $params DERIVED false
   set_parameter_property $params VISIBLE true
   }
}

proc ::altera_sl3::gui_params::params_phy_adapter_hw {} {
# List down what parameters to add. 
  define_params "DEVICE_FAMILY" 
  define_params "LANES" 
  define_params "DIRECTION" 
  define_params "PHY_DATA_WIDTH"
  define_params "TX_PHY_CTL_WIDTH"
  define_params "RX_PHY_CTL_WIDTH"
  define_params "UNUSED_TX_PARALLEL_WIDTH"
  define_params "TEST_COMPONENTS_EN"

# Add selected parameters
   global GLOBAL_PARAMS
   foreach params $GLOBAL_PARAMS {
   conf_params $params
   set_parameter_property $params AFFECTS_GENERATION true
   set_parameter_property $params DERIVED false
   set_parameter_property $params VISIBLE true
   }
}


proc ::altera_sl3::gui_params::params_clock_gen_top_hw {} {
# List down what parameters to add. 
  define_params "DEVICE_FAMILY" 
  define_params "gui_reference_clock_frequency" 
  define_params "gui_user_clock_frequency" 
  define_params "gui_coreclkin_frequency"
  define_params "gui_actual_user_clock_frequency" 
  define_params "gui_actual_coreclkin_frequency" 

# Add selected parameters
   global GLOBAL_PARAMS
   foreach params $GLOBAL_PARAMS {
   conf_params $params
   set_parameter_property $params AFFECTS_GENERATION true
   if {$params == "gui_actual_user_clock_frequency" || $params == "gui_actual_coreclkin_frequency"} {
      set_parameter_property $params DERIVED true
   } else {
      set_parameter_property $params DERIVED false
   }
   set_parameter_property $params VISIBLE true
   }
}

proc ::altera_sl3::gui_params::params_pll_wrapper_hw {} {
# List down what parameters to add. 

   define_params "DIRECTION" 
   define_params "DEVICE_FAMILY"
   define_params "LANES" 
   define_params "lane_rate_recommended" 
   define_params "gui_pll_ref_freq"
   define_params "gui_user_clock_frequency" 
   define_params "int_reference_clock_frequency"
   define_params "PMA_MODE"
   define_params "GUI_USE_FPLL"
   define_params "part_trait_device"
   define_params "system_family"
   define_params "gui_user_input"
   define_params "gui_actual_user_clock_frequency"
   define_params "TEST_COMPONENTS_EN"
   define_params "gui_analog_voltage"

   # Add selected parameters
   global GLOBAL_PARAMS
   foreach params $GLOBAL_PARAMS {
   conf_params $params
   set_parameter_property $params AFFECTS_GENERATION true
   set_parameter_property $params DERIVED false
   set_parameter_property $params VISIBLE true
   }
}


proc define_params {param_name} {
   global GLOBAL_PARAMS
   lappend GLOBAL_PARAMS $param_name
}
