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
# altera_avalon_mutex_lwhal_driver.tcl
#

# Create a new driver
create_driver altera_avalon_mutex_lwhal_driver

# Associate it with some hardware known as "altera_avalon_mutex"
set_sw_property hw_class_name altera_avalon_mutex

# The version of this driver
set_sw_property version __VERSION_SHORT__

# This driver may be incompatible with versions of hardware less
# than specified below. Updates to hardware and device drivers
# rendering the driver incompatible with older versions of
# hardware are noted with this property assignment.
#
# Multiple-Version compatibility was introduced in version 7.1;
# prior versions are therefore excluded.
set_sw_property min_compatible_hw_version 7.1

# Location in generated BSP that above sources will be copied into
set_sw_property bsp_subdirectory drivers

#
# Source file listings...
#

# C/C++ source files
add_sw_property c_source LWHAL/src/altera_avalon_mutex_lwhal_lock.c
add_sw_property c_source LWHAL/src/altera_avalon_mutex_lwhal_unlock.c
add_sw_property c_source LWHAL/src/altera_avalon_mutex_lwhal_is_mine.c

# Include files
add_sw_property include_source LWHAL/inc/altera_avalon_mutex_lwhal.h
add_sw_property include_source inc/altera_avalon_mutex_regs.h

# This driver supports LWHAL BSP (OS) types
add_sw_property supported_bsp_type LWHAL

# End of file
