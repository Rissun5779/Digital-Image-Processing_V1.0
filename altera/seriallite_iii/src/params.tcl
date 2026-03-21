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


for { set i 0 } {$i < 2} {incr i} {
#add_display_item "Output Clocks" "outclk$i" GROUP
add_parameter gui_output_clock_frequency$i FLOAT "100.0"
set_parameter_property gui_output_clock_frequency$i DEFAULT_VALUE "100.0"
set_parameter_property gui_output_clock_frequency$i DISPLAY_NAME "Desired Frequency"
set_parameter_property gui_output_clock_frequency$i UNITS "megahertz"
set_parameter_property gui_output_clock_frequency$i VISIBLE false
set_parameter_property gui_output_clock_frequency$i AFFECTS_GENERATION true
set_parameter_property gui_output_clock_frequency$i HDL_PARAMETER false
set_parameter_property gui_output_clock_frequency$i DERIVED true
set_parameter_property gui_output_clock_frequency$i DESCRIPTION "Specifies requested value for output clock frequency"
add_display_item "outclk$i" gui_output_clock_frequency$i parameter 

add_parameter gui_divide_factor_c$i INTEGER "1"
set_parameter_property gui_divide_factor_c$i DEFAULT_VALUE "1"
set_parameter_property gui_divide_factor_c$i DISPLAY_NAME "Divide Factor (C-Counter)"
set_parameter_property gui_divide_factor_c$i UNITS ""
set_parameter_property gui_divide_factor_c$i ALLOWED_RANGES {1:512}
set_parameter_property gui_divide_factor_c$i VISIBLE false
set_parameter_property gui_divide_factor_c$i AFFECTS_GENERATION true
set_parameter_property gui_divide_factor_c$i HDL_PARAMETER false
set_parameter_property gui_divide_factor_c$i DESCRIPTION "Specifies requested value for the divide factor for the output clock"
add_display_item "outclk$i" gui_divide_factor_c$i parameter

add_parameter gui_actual_multiply_factor$i INTEGER "1"
set_parameter_property gui_actual_multiply_factor$i DEFAULT_VALUE "1"
set_parameter_property gui_actual_multiply_factor$i DISPLAY_NAME "Actual Multiply Factor"
set_parameter_property gui_actual_multiply_factor$i UNITS ""
set_parameter_property gui_actual_multiply_factor$i VISIBLE false
set_parameter_property gui_actual_multiply_factor$i DERIVED true
set_parameter_property gui_actual_multiply_factor$i AFFECTS_GENERATION true
set_parameter_property gui_actual_multiply_factor$i HDL_PARAMETER false
set_parameter_property gui_actual_multiply_factor$i DESCRIPTION "Specifies actual value for the multiply factor for the output clock"
add_display_item "outclk$i" gui_actual_multiply_factor$i parameter

add_parameter gui_actual_frac_multiply_factor$i LONG "1"
set_parameter_property gui_actual_frac_multiply_factor$i DEFAULT_VALUE "1"
set_parameter_property gui_actual_frac_multiply_factor$i DISPLAY_NAME "Actual Fractional Multiply Factor (K)"
set_parameter_property gui_actual_frac_multiply_factor$i UNITS ""
set_parameter_property gui_actual_frac_multiply_factor$i VISIBLE false
set_parameter_property gui_actual_frac_multiply_factor$i DERIVED true
set_parameter_property gui_actual_frac_multiply_factor$i AFFECTS_GENERATION true
set_parameter_property gui_actual_frac_multiply_factor$i HDL_PARAMETER false
set_parameter_property gui_actual_frac_multiply_factor$i DESCRIPTION "Specifies actual value for the fractional multiply factor for the output clock"
add_display_item "outclk$i" gui_actual_frac_multiply_factor$i parameter

add_parameter gui_actual_divide_factor$i INTEGER "1"
set_parameter_property gui_actual_divide_factor$i DEFAULT_VALUE "1"
set_parameter_property gui_actual_divide_factor$i DISPLAY_NAME "Actual Divide Factor"
set_parameter_property gui_actual_divide_factor$i UNITS ""
set_parameter_property gui_actual_divide_factor$i VISIBLE false
set_parameter_property gui_actual_divide_factor$i DERIVED true
set_parameter_property gui_actual_divide_factor$i AFFECTS_GENERATION true
set_parameter_property gui_actual_divide_factor$i HDL_PARAMETER false
set_parameter_property gui_actual_divide_factor$i DESCRIPTION "Specifies actual value for the divide factor for the output clock"
add_display_item "outclk$i" gui_actual_divide_factor$i parameter

add_parameter gui_actual_output_clock_frequency$i STRING ""
#set_parameter_property gui_actual_output_clock_frequency$i DEFAULT_VALUE "0 MHz"
set_parameter_property gui_actual_output_clock_frequency$i DISPLAY_NAME "Actual Frequency"
set_parameter_property gui_actual_output_clock_frequency$i VISIBLE false
set_parameter_property gui_actual_output_clock_frequency$i AFFECTS_GENERATION true
set_parameter_property gui_actual_output_clock_frequency$i HDL_PARAMETER false
set_parameter_property gui_actual_output_clock_frequency$i DESCRIPTION "Specifies actual value for output clock frequency"
add_display_item "outclk$i" gui_actual_output_clock_frequency$i parameter 

add_parameter gui_ps_units$i STRING "ps"
set_parameter_property gui_ps_units$i DEFAULT_VALUE "ps"
set_parameter_property gui_ps_units$i DISPLAY_NAME "Phase Shift units"
set_parameter_property gui_ps_units$i VISIBLE false 
set_parameter_property gui_ps_units$i UNITS None
set_parameter_property gui_ps_units$i ALLOWED_RANGES {"ps" "degrees"}
set_parameter_property gui_ps_units$i AFFECTS_GENERATION true
set_parameter_property gui_ps_units$i HDL_PARAMETER false
set_parameter_property gui_ps_units$i DESCRIPTION "Enter phase shift in degrees or picoseconds."
add_display_item "outclk$i" gui_ps_units$i parameter 

add_parameter gui_phase_shift$i INTEGER "0"
set_parameter_property gui_phase_shift$i DEFAULT_VALUE "0"
set_parameter_property gui_phase_shift$i DISPLAY_NAME "Phase Shift"
set_parameter_property gui_phase_shift$i UNITS "picoseconds"
set_parameter_property gui_phase_shift$i VISIBLE false
set_parameter_property gui_phase_shift$i AFFECTS_GENERATION true
set_parameter_property gui_phase_shift$i HDL_PARAMETER false
set_parameter_property gui_phase_shift$i DESCRIPTION "Specifies requested value for phase shift"
add_display_item "outclk$i" gui_phase_shift$i parameter

add_parameter gui_phase_shift_deg$i INTEGER "0"
set_parameter_property gui_phase_shift_deg$i DEFAULT_VALUE "0"
set_parameter_property gui_phase_shift_deg$i DISPLAY_NAME "Phase Shift"
set_parameter_property gui_phase_shift_deg$i DISPLAY_UNITS "degrees"
set_parameter_property gui_phase_shift_deg$i ALLOWED_RANGES {-360:360}
set_parameter_property gui_phase_shift_deg$i VISIBLE false
set_parameter_property gui_phase_shift_deg$i AFFECTS_GENERATION true
set_parameter_property gui_phase_shift_deg$i HDL_PARAMETER false
set_parameter_property gui_phase_shift_deg$i DESCRIPTION "Specifies requested value for phase shift"
add_display_item "outclk$i" gui_phase_shift_deg$i parameter

add_parameter gui_actual_phase_shift$i STRING "0"
set_parameter_property gui_actual_phase_shift$i DEFAULT_VALUE "0"
set_parameter_property gui_actual_phase_shift$i DISPLAY_NAME "Actual Phase Shift"
set_parameter_property gui_actual_phase_shift$i VISIBLE false
set_parameter_property gui_actual_phase_shift$i AFFECTS_GENERATION true
set_parameter_property gui_actual_phase_shift$i HDL_PARAMETER false
set_parameter_property gui_actual_phase_shift$i DESCRIPTION "Specifies actual value for phase shift"
add_display_item "outclk$i" gui_actual_phase_shift$i parameter 

add_parameter gui_duty_cycle$i INTEGER 50
set_parameter_property gui_duty_cycle$i DEFAULT_VALUE 50
set_parameter_property gui_duty_cycle$i DISPLAY_NAME "Duty Cycle"
set_parameter_property gui_duty_cycle$i UNITS "percent"
set_parameter_property gui_duty_cycle$i ALLOWED_RANGES {1:99}
set_parameter_property gui_duty_cycle$i VISIBLE false
set_parameter_property gui_duty_cycle$i AFFECTS_GENERATION true
set_parameter_property gui_duty_cycle$i HDL_PARAMETER false
set_parameter_property gui_duty_cycle$i DESCRIPTION "Specifies requested value for duty cycle"
add_display_item "outclk$i" gui_duty_cycle$i parameter
}

for { set i 0 } {$i < 18} {incr i} {
add_parameter output_clock_frequency$i STRING "0 MHz"
set_parameter_property output_clock_frequency$i DEFAULT_VALUE "0 MHz"
set_parameter_property output_clock_frequency$i VISIBLE false
set_parameter_property output_clock_frequency$i AFFECTS_GENERATION true
set_parameter_property output_clock_frequency$i DERIVED true
set_parameter_property output_clock_frequency$i HDL_PARAMETER false
#add_display_item "Output Clocks" output_clock_frequency$i parameter

add_parameter phase_shift$i STRING "0 ps"
set_parameter_property phase_shift$i DEFAULT_VALUE "0 ps"
set_parameter_property phase_shift$i UNITS "picoseconds"
set_parameter_property phase_shift$i VISIBLE false
set_parameter_property phase_shift$i AFFECTS_GENERATION true
set_parameter_property phase_shift$i DERIVED true
set_parameter_property phase_shift$i HDL_PARAMETER false
#add_display_item "Output Clocks" phase_shift$i parameter

add_parameter duty_cycle$i INTEGER 50
set_parameter_property duty_cycle$i DEFAULT_VALUE 50
set_parameter_property duty_cycle$i ALLOWED_RANGES {1:99}
set_parameter_property duty_cycle$i VISIBLE false
set_parameter_property duty_cycle$i AFFECTS_GENERATION true
set_parameter_property duty_cycle$i DERIVED true
set_parameter_property duty_cycle$i HDL_PARAMETER false
#add_display_item "Output Clocks" duty_cycle$i parameter
}

add_parameter fractional_vco_multiplier boolean 0
set_parameter_property fractional_vco_multiplier DEFAULT_VALUE 0
set_parameter_property fractional_vco_multiplier VISIBLE false
set_parameter_property fractional_vco_multiplier AFFECTS_GENERATION true
set_parameter_property fractional_vco_multiplier DERIVED true
set_parameter_property fractional_vco_multiplier ENABLED true
set_parameter_property fractional_vco_multiplier HDL_PARAMETER false

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
 To exclude hardware aspects of example design, select 'None' from the Target Development Kit pull down menu.</html>"
add_display_item "Example Design" "Target Device" GROUP
add_display_item "Target Device" "target_dev" text "<html>Device Selected:     Family: Arria 10 Device 10AX115S4F45I3SGE2<br><br></html>"
add_display_item "Target Device" SELECT_CUSTOM_DEVICE parameter
add_display_item "Target Device" "explanation2" text "<html></html>"

##########################################
# GENERAL DESIGN OPTIONS
##########################################

add_parameter DEVICE_FAMILY STRING ""
set_parameter_property DEVICE_FAMILY VISIBLE false
set_parameter_property DEVICE_FAMILY HDL_PARAMETER true
set_parameter_property DEVICE_FAMILY ENABLED true
set_parameter_property DEVICE_FAMILY DERIVED true

##########################################
# DIRECTION
##########################################
add_parameter direction STRING "Duplex"
set_parameter_property direction DISPLAY_NAME "Direction"
set_parameter_property direction DISPLAY_HINT radio
set_parameter_property direction ALLOWED_RANGES {"Source" "Sink" "Duplex"}
set_parameter_property direction AFFECTS_ELABORATION true
set_parameter_property direction AFFECTS_GENERATION true
set_parameter_property direction IS_HDL_PARAMETER false
add_display_item "General Design Options" direction PARAMETER
set_parameter_property direction VISIBLE true
set_parameter_property direction DESCRIPTION "Supports simplex transmitter or simplex receiver or full duplex transmissions"

##########################################
# LANES 
##########################################

add_parameter lanes INTEGER 2
set_parameter_property lanes DISPLAY_NAME "Number of lanes"
set_parameter_property lanes DISPLAY_HINT "Number of lanes"
set_parameter_property lanes ALLOWED_RANGES 1:24
set_parameter_property lanes AFFECTS_GENERATION true
set_parameter_property lanes IS_HDL_PARAMETER true
add_display_item "General Design Options" lanes PARAMETER
set_parameter_property lanes DESCRIPTION "Supports 1 to 24 lanes"
set_display_item_property lanes DISPLAY_HINT "columns:11"

# Set HDL param addr-width from no of lanes for A10
add_parameter ADDR_WIDTH INTEGER 11
set_parameter_property ADDR_WIDTH VISIBLE false
set_parameter_property ADDR_WIDTH AFFECTS_GENERATION true
set_parameter_property ADDR_WIDTH IS_HDL_PARAMETER true
set_parameter_property ADDR_WIDTH DERIVED true

add_parameter enable_seventeeng BOOLEAN
set_parameter_property enable_seventeeng VISIBLE false
set_parameter_property enable_seventeeng AFFECTS_GENERATION true
set_parameter_property enable_seventeeng HDL_PARAMETER true
set_parameter_property enable_seventeeng DERIVED true
##########################################
# OPTIONAL SERIAL PLL FOR ARRIA 10
##########################################

add_parameter enable_tx_pll BOOLEAN
set_parameter_property enable_tx_pll VISIBLE false
set_parameter_property enable_tx_pll HDL_PARAMETER true
set_parameter_property enable_tx_pll ENABLED true
set_parameter_property enable_tx_pll DERIVED true

add_parameter gui_enable_tx_pll BOOLEAN false
set_parameter_property gui_enable_tx_pll DISPLAY_NAME "Instantiate TX PLL"
set_parameter_property gui_enable_tx_pll DISPLAY_HINT "This will instantiate Serial TX PLL as part of IP"
set_parameter_property gui_enable_tx_pll AFFECTS_ELABORATION true
set_parameter_property gui_enable_tx_pll AFFECTS_GENERATION true
set_parameter_property gui_enable_tx_pll IS_HDL_PARAMETER false
add_display_item "General Design Options" gui_enable_tx_pll PARAMETER
set_parameter_property gui_enable_tx_pll DESCRIPTION "This will instantiate Serial TX PLL as part of IP"
set_parameter_property gui_enable_tx_pll VISIBLE false


##########################################
# pLL TYPE
##########################################

add_parameter pll_type STRING
set_parameter_property pll_type VISIBLE false
set_parameter_property pll_type HDL_PARAMETER true
set_parameter_property pll_type ENABLED true
set_parameter_property pll_type DERIVED true


# adding pll type parameter - GUI param is symbolic only
add_parameter gui_pll_type STRING "CMU"
set_parameter_property gui_pll_type DEFAULT_VALUE "CMU"
set_parameter_property gui_pll_type ALLOWED_RANGES {"CMU" "ATX"}
set_parameter_property gui_pll_type DISPLAY_NAME "PLL type"
set_parameter_property gui_pll_type UNITS None
#set_parameter_property gui_pll_type ENABLED [get_parameter_value gui_enable_tx_pll]
set_parameter_property gui_pll_type VISIBLE true
set_parameter_property gui_pll_type DISPLAY_HINT ""
set_parameter_property gui_pll_type HDL_PARAMETER false
set_parameter_property gui_pll_type DESCRIPTION "Specifies the PLL type"
add_display_item "General Design Options" gui_pll_type parameter
set_display_item_property gui_pll_type DISPLAY_HINT "columns:11"


##########################################
# SpeedGrade
##########################################
add_parameter speedgrade STRING "2"
set_parameter_property speedgrade DISPLAY_NAME "Device speed grade"
set_parameter_property speedgrade DISPLAY_HINT "Speed Grade of the device"
set_parameter_property speedgrade ALLOWED_RANGES {"1" "2" "3" "4"}
set_parameter_property speedgrade AFFECTS_ELABORATION true
set_parameter_property speedgrade AFFECTS_GENERATION true
set_parameter_property speedgrade IS_HDL_PARAMETER false
add_display_item "General Design Options" speedgrade PARAMETER
set_parameter_property speedgrade DESCRIPTION "Specifies the speed grade of the device"
set_display_item_property speedgrade DISPLAY_HINT "columns:11"


##########################################
# Mode of Operation 
##########################################
add_parameter mode STRING "continuous"
set_parameter_property mode DISPLAY_NAME "Mode"
set_parameter_property mode DISPLAY_HINT "Operation mode"
#set_parameter_property mode ALLOWED_RANGES {"continuous" "packet"}
set_parameter_property mode ALLOWED_RANGES {"continuous"}
set_parameter_property mode AFFECTS_ELABORATION true
set_parameter_property mode AFFECTS_GENERATION true
set_parameter_property mode IS_HDL_PARAMETER false
add_display_item "General Design Options" mode PARAMETER
set_parameter_property mode DESCRIPTION "Mode of operation"
set_parameter_property mode VISIBLE false

##########################################
# Adaptation & Lane FIFO Depths
##########################################

#add_parameter lane_fifo_depth INTEGER 16
#set_parameter_property lane_fifo_depth DISPLAY_NAME "Lane FIFO Depth"
#set_parameter_property lane_fifo_depth DISPLAY_HINT "lane_fifo_depth"
#set_parameter_property lane_fifo_depth ALLOWED_RANGES 1:16
#set_parameter_property lane_fifo_depth AFFECTS_ELABORATION true
#set_parameter_property lane_fifo_depth AFFECTS_GENERATION true
#set_parameter_property lane_fifo_depth IS_HDL_PARAMETER false
#set_parameter_property lane_fifo_depth VISIBLE false
##set_parameter_property lane_fifo_depth DERIVED true
#set_parameter_property lane_fifo_depth ENABLED false
#add_display_item "General Design Options" lane_fifo_depth PARAMETER
#set_parameter_property lane_fifo_depth DESCRIPTION "Specifies the depth of the lane alignment FIFO"

add_parameter adaptation_fifo_depth INTEGER 32
#set_parameter_property adaptation_fifo_depth DISPLAY_NAME "Adaptation FIFO Depth"
#set_parameter_property adaptation_fifo_depth DISPLAY_HINT "adaptation_fifo_depth"
set_parameter_property adaptation_fifo_depth ALLOWED_RANGES 1:32
#set_parameter_property adaptation_fifo_depth AFFECTS_ELABORATION true
set_parameter_property adaptation_fifo_depth AFFECTS_GENERATION true
set_parameter_property adaptation_fifo_depth IS_HDL_PARAMETER true
set_parameter_property adaptation_fifo_depth VISIBLE false
set_parameter_property adaptation_fifo_depth DERIVED true
set_parameter_property adaptation_fifo_depth ENABLED true


##########################################
# TRANSCEIVER REFERENCE CLOCK FREQUENCY
##########################################

set_parameter_property gui_pll_ref_freq DISPLAY_NAME "Transceiver reference clock frequency"
set_parameter_property gui_pll_ref_freq ALLOWED_RANGES {"100.121359" "550" "644.531250"}
set_parameter_property gui_pll_ref_freq DISPLAY_HINT "Please chose from compatible transceiver Clock frequencies"
set_parameter_property gui_pll_ref_freq DISPLAY_UNITS "MHz"
set_parameter_property gui_pll_ref_freq AFFECTS_ELABORATION true
set_parameter_property gui_pll_ref_freq AFFECTS_GENERATION true
set_parameter_property gui_pll_ref_freq IS_HDL_PARAMETER false
#set_parameter_property gui_pll_ref_freq ENABLED true
add_display_item "General Design Options" gui_pll_ref_freq PARAMETER
#set_parameter_property gui_pll_ref_freq DERIVED true
#set_display_item_property gui_pll_ref_freq DISPLAY_HINT "columns:11"


##########################################
# Metaframe Size
##########################################
add_parameter meta_frame_length INTEGER 200
set_parameter_property meta_frame_length DISPLAY_NAME "Meta frame length in words"
set_parameter_property meta_frame_length DISPLAY_HINT "meta_frame_length"
set_parameter_property meta_frame_length ALLOWED_RANGES {200:8191}
set_parameter_property meta_frame_length AFFECTS_ELABORATION true
set_parameter_property meta_frame_length AFFECTS_GENERATION true
set_parameter_property meta_frame_length IS_HDL_PARAMETER true
add_display_item "General Design Options" meta_frame_length PARAMETER
set_parameter_property meta_frame_length DESCRIPTION "Specifies the meta frame length; possible lengths are 200-8191 words"
set_display_item_property meta_frame_length DISPLAY_HINT "columns:11"


##############################
# Device Information 
#############################
add_parameter system_family STRING
set_parameter_property system_family SYSTEM_INFO DEVICE_FAMILY
set_parameter_property system_family VISIBLE false


add_parameter device_speed_grade STRING
set_parameter_property device_speed_grade SYSTEM_INFO DEVICE_SPEEDGRADE
set_parameter_property device_speed_grade VISIBLE false

add_parameter part_trait_bd STRING ""
set_parameter_property part_trait_bd SYSTEM_INFO_TYPE PART_TRAIT
set_parameter_property part_trait_bd SYSTEM_INFO_ARG BASE_DEVICE
set_parameter_property part_trait_bd DERIVED true
set_parameter_property part_trait_bd HDL_PARAMETER false
set_parameter_property part_trait_bd ENABLED true
set_parameter_property part_trait_bd VISIBLE false
#set_parameter_property part_trait_bd DISPLAY_HINT NOVAL
#set_parameter_property part_trait_bd DISPLAY_UNITS NOVAL
#set_parameter_property part_trait_bd DISPLAY_ITEM NOVAL
#set_parameter_property part_trait_bd DISPLAY_NAME NOVAL
#
add_parameter part_trait_device STRING ""
set_parameter_property part_trait_device SYSTEM_INFO_TYPE PART_TRAIT
set_parameter_property part_trait_device SYSTEM_INFO_ARG DEVICE
set_parameter_property part_trait_device DERIVED true
set_parameter_property part_trait_device HDL_PARAMETER false
set_parameter_property part_trait_device ENABLED true
set_parameter_property part_trait_device VISIBLE false
#

add_parameter DEVKIT_DEVICE STRING "10AX115S4F45E3SGE3"
set_parameter_property DEVKIT_DEVICE DISPLAY_NAME "Devkit device part"
set_parameter_property DEVKIT_DEVICE DESCRIPTION "Device part for supported devkit"
set_parameter_property DEVKIT_DEVICE HDL_PARAMETER false
set_parameter_property DEVKIT_DEVICE DERIVED true
set_parameter_property DEVKIT_DEVICE VISIBLE false

add_parameter DEVICE STRING "10AX115S4F45I3SGE2"
set_parameter_property DEVICE DISPLAY_NAME "Device part"
set_parameter_property DEVICE DESCRIPTION "Target device part for SerialLite III IP"
# set_parameter_property DEVICE_FAMILY ALLOWED_RANGES {"Stratix V" "Arria 10" "Arria V GZ"}
set_parameter_property DEVICE VISIBLE false
set_parameter_property DEVICE IS_HDL_PARAMETER false
set_parameter_property DEVICE SYSTEM_INFO DEVICE

#########################################
# Burst Gap parameter
#########################################
#
add_display_item "User Interface" "BURST_GAP" parameter
add_parameter "BURST_GAP" INTEGER 2
set_parameter_property "BURST_GAP" ALLOWED_RANGES {1 2}
set_parameter_property "BURST_GAP" DISPLAY_NAME "Required idle cycles between bursts"
set_parameter_property "BURST_GAP" ENABLED true
set_parameter_property "BURST_GAP" VISIBLE true 
set_parameter_property "BURST_GAP" HDL_PARAMETER true
set_parameter_property "BURST_GAP" DESCRIPTION "Supports two values to optimize for bandwidth efficiency or maintain backwards compatibility with existing SerialLite III Streaming IP cores (legacy) in the field"


#########################################
# Transceiver Native PHY ADME 
#########################################
add_parameter rcfg_jtag_enable BOOLEAN false
set_parameter_property rcfg_jtag_enable DISPLAY_NAME "Enable Transceiver Native PHY ADME"
set_parameter_property rcfg_jtag_enable UNITS None
set_parameter_property rcfg_jtag_enable DISPLAY_HINT boolean
add_display_item "General Design Options" rcfg_jtag_enable PARAMETER
set_parameter_property rcfg_jtag_enable DESCRIPTION "Enables ADME and Optional Reconfiguration Logic Parameters of Transceiver Native PHY."
set_parameter_property rcfg_jtag_enable HDL_PARAMETER false


add_parameter xcvr_capability_reg_en boolean false
set_parameter_property xcvr_capability_reg_en HDL_PARAMETER false
set_parameter_property xcvr_capability_reg_en VISIBLE false
set_parameter_property xcvr_capability_reg_en DISPLAY_NAME "Enable Transceiver capability registers"
set_parameter_property xcvr_capability_reg_en DESCRIPTION "Enables Transceiver capability registers, which provide high level information about the transceiver channel's configuration."
add_display_item "General Design Options" xcvr_capability_reg_en PARAMETER


add_parameter xcvr_set_user_identifier integer 0
set_parameter_property xcvr_set_user_identifier HDL_PARAMETER false
set_parameter_property xcvr_set_user_identifier DISPLAY_NAME "Set user-defined IP identifier"
set_parameter_property xcvr_set_user_identifier DESCRIPTION "Sets a user-defined numeric identifier that can be read from the user_identifer offset when the capability registers are enabled."
set_parameter_property xcvr_set_user_identifier ALLOWED_RANGES {0:255}
set_parameter_property xcvr_set_user_identifier VISIBLE false
add_display_item "General Design Options" xcvr_set_user_identifier PARAMETER


add_parameter xcvr_csr_soft_log_en boolean false
set_parameter_property xcvr_csr_soft_log_en HDL_PARAMETER false
set_parameter_property xcvr_csr_soft_log_en VISIBLE false
set_parameter_property xcvr_csr_soft_log_en DISPLAY_NAME "Enable Transceiver control and status registers"
set_parameter_property xcvr_csr_soft_log_en DESCRIPTION "Enables Transceiver's soft registers for reading status signals and writing control signals on the phy interface through the embedded debug. Signals include rx_is_locktoref, rx_is_locktodata, tx_cal_busy, rx_cal_busy, rx_serial_loopback, set_rx_locktodata, set_rx_locktoref, tx_analogreset, tx_digitalreset, rx_analogreset and rx_digitalreset. For more information, please refer to the Transceiver User Guide."
add_display_item "General Design Options" xcvr_csr_soft_log_en PARAMETER


add_parameter xcvr_prbs_soft_log_en boolean false
set_parameter_property xcvr_prbs_soft_log_en HDL_PARAMETER false
set_parameter_property xcvr_prbs_soft_log_en VISIBLE false
set_parameter_property xcvr_prbs_soft_log_en DISPLAY_NAME "Enable Transceiver PRBS soft accumulators"
set_parameter_property xcvr_prbs_soft_log_en DESCRIPTION "Enables Transceiver's soft logic for doing prbs bit and error accumulation when using the hard prbs generator and checker."
add_display_item "General Design Options" xcvr_prbs_soft_log_en PARAMETER
	
	
##########################################
# ECC Protection
##########################################

add_parameter gui_ecc_enable BOOLEAN false
set_parameter_property gui_ecc_enable DISPLAY_NAME "Enable M20K ECC support"
set_parameter_property gui_ecc_enable DISPLAY_HINT "ECC Protection for Memory Blocks"
set_parameter_property gui_ecc_enable AFFECTS_ELABORATION true
set_parameter_property gui_ecc_enable AFFECTS_GENERATION true
set_parameter_property gui_ecc_enable IS_HDL_PARAMETER false
add_display_item "General Design Options" gui_ecc_enable PARAMETER
set_parameter_property gui_ecc_enable DESCRIPTION "Enables built-in ECC support on the M20K embedded block memory for single-error correction, double-adjacent-error correction, and triple-adjacent-error detection"
set_parameter_property gui_ecc_enable VISIBLE true


add_parameter ecc_enable BOOLEAN false
set_parameter_property ecc_enable IS_HDL_PARAMETER true
set_parameter_property ecc_enable VISIBLE false
set_parameter_property ecc_enable DERIVED true
set_parameter_property ecc_enable ENABLED true


add_parameter randString STRING "" 
set_parameter_property randString AFFECTS_ELABORATION true
set_parameter_property randString AFFECTS_GENERATION true
set_parameter_property randString IS_HDL_PARAMETER false
set_parameter_property randString VISIBLE false
set_parameter_property randString DERIVED true

##########################################
# EXAMPLE DESIGNS OPTIONS
##########################################
add_parameter gui_ed_option STRING "Standard Clocking Mode"
add_display_item "Available Example Designs" gui_ed_option PARAMETER
set_parameter_property gui_ed_option DISPLAY_NAME "Select Design"
set_parameter_property gui_ed_option ALLOWED_RANGES {"Standard Clocking Mode"}
set_parameter_property gui_ed_option DESCRIPTION "<html>Please select available design for Example Design generation.<br><br><b>Standard Clocking Mode/Advanced Clocking Mode</b>: Current design only able to generate example design for simulation. However, we have other example designs that come with specific IP and related parameter settings that you may use by selecting one of the presets below.<br><br><i>Please note that when you apply preset, current IP and other parameter settings will be set to match those of selected preset. If you like to save your current settings, you should do so before you hit apply preset. Also you can always save the new 'preset' settings under a different name using File->Save as</i></html>"
set_parameter_property gui_ed_option HDL_PARAMETER false

add_parameter ed_option STRING "Standard Clocking Mode"
set_parameter_property ed_option DERIVED true
set_parameter_property ed_option VISIBLE false
set_parameter_property ed_option HDL_PARAMETER false

add_parameter ENABLE_ED_FILESET_SYNTHESIS INTEGER 1
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DEFAULT_VALUE 1
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DISPLAY_NAME "Synthesis"
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DESCRIPTION "When Synthesis box is checked, all necessary filesets required for synthesis will be generated when 'Generate Example Design' is clicked. Expect an additional 1-2 minute delay when generating the synthesis fileset.<br><br>When this box is NOT checked, filesets required for synthesis will NOT be generated."
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS TYPE INTEGER
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS UNITS None
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DISPLAY_HINT boolean
set_parameter_property ENABLE_ED_FILESET_SYNTHESIS HDL_PARAMETER false
set_parameter_update_callback ENABLE_ED_FILESET_SYNTHESIS update_ed_fileset_synthesis


add_parameter ENABLE_ED_FILESET_SIM INTEGER 0
set_parameter_property ENABLE_ED_FILESET_SIM DEFAULT_VALUE 1
set_parameter_property ENABLE_ED_FILESET_SIM DISPLAY_NAME "Simulation"
set_parameter_property ENABLE_ED_FILESET_SIM DESCRIPTION "When Simulation box is checked, all necessary filesets required for simulation will be generated when 'Generate Example Design' is clicked. Expect an additional 1-2 minute delay when generating the simulation fileset.<br><br>When this box is NOT checked, filesets required for simulation will NOT be generated."
set_parameter_property ENABLE_ED_FILESET_SIM TYPE INTEGER
set_parameter_property ENABLE_ED_FILESET_SIM UNITS None
set_parameter_property ENABLE_ED_FILESET_SIM DISPLAY_HINT boolean
set_parameter_property ENABLE_ED_FILESET_SIM HDL_PARAMETER false

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
"1:Arria 10 GX Transceiver Signal Integrity Development Kit"
"2:Custom Development Kit"
"3:No Development Kit"
}
set_parameter_property SELECT_TARGETED_DEVICE HDL_PARAMETER false

add_parameter SELECT_CUSTOM_DEVICE INTEGER 0
set_parameter_property SELECT_CUSTOM_DEVICE DEFAULT_VALUE 0
set_parameter_property SELECT_CUSTOM_DEVICE DISPLAY_NAME "Change Target Device"
set_parameter_property SELECT_CUSTOM_DEVICE DESCRIPTION "<html>When select, user is able to select different device grade for Altera development kit. For device specific details look for Device data sheet on <a href='http://www.altera.com/'>www.altera.com</a></html>"
set_parameter_property SELECT_CUSTOM_DEVICE TYPE INTEGER
set_parameter_property SELECT_CUSTOM_DEVICE UNITS None
set_parameter_property SELECT_CUSTOM_DEVICE DISPLAY_HINT boolean
set_parameter_property SELECT_CUSTOM_DEVICE HDL_PARAMETER false