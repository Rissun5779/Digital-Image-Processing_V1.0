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


#
# altera_modular_adc_sw.tcl
#

# Create a new driver
create_driver altera_modular_adc_driver

# Associate it with some hardware known as "altera_modular_adc"
set_sw_property hw_class_name altera_modular_adc

# The version of this driver
set_sw_property version 18.1

# This driver may be incompatible with versions of hardware less
# than specified below. Updates to hardware and device drivers
# rendering the driver incompatible with older versions of
# hardware are noted with this property assignment.
#
set_sw_property min_compatible_hw_version 18.1

# Initialize the driver in alt_sys_init()
set_sw_property auto_initialize true

# Location in generated BSP that above sources will be copied into
set_sw_property bsp_subdirectory drivers

# Interrupt properties: This driver supports both legacy and enhanced
# interrupt APIs, as well as ISR preemption.
set_sw_property isr_preemption_supported true
set_sw_property supported_interrupt_apis "enhanced_interrupt_api"

# This uses the $argv0 pre-set variable which contains the
# complete path to this script.
set dir [file dirname $argv0]

#
# Source file listings...
#

# C/C++ source files
add_sw_property c_source HAL/src/altera_modular_adc.c

# Include files
add_sw_property include_source HAL/inc/altera_modular_adc.h


# HAL driver common settings 
source $dir/altera_modular_adc_common.tcl

# This driver supports HAL & UCOSII BSP (OS) types
add_sw_property supported_bsp_type HAL
add_sw_property supported_bsp_type UCOSII

# End of file
