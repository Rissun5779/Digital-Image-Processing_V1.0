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
# fpoint2_qsys_sw.tcl
#

# Create a new driver
create_driver fpoint2_driver

# Associate it with some hardware known as "altera_nios_custom_instr_floating_point_2"
set_sw_property hw_class_name altera_nios_custom_instr_floating_point_2 

# The version of this driver
set_sw_property version 13.1

# This driver may be incompatible with versions of hardware less
# than specified below. Updates to hardware and device drivers
# rendering the driver incompatible with older versions of
# hardware are noted with this property assignment.
#
# Multiple-Version compatibility was introduced in version 1.1;
# prior versions are therefore excluded.
set_sw_property min_compatible_hw_version 1.1

# This driver supports HAL & UCOSII BSP (OS) types
add_sw_property supported_bsp_type HAL
add_sw_property supported_bsp_type UCOSII

################################################################
# Add command-line options to the GCC C/C++ compilier via the  #
# BSP public.mk ALT_CFLAGS variable.                           #
################################################################
# Set callback
set_sw_property callback_source_file fpoint2_qsys_sw_callback.tcl
set_sw_property validation_callback validate

# Tell GCC not to add extra code after sqrt() to set the errno variable
# if the sqrt() result was NaN.
# This can be overriden by passing -fmath-errno on the GCC command-line
# in your Makefile as long as it occurs on the GCC command-line after
# the -fno-math-errno option.
add_sw_property alt_cflags_addition -fno-math-errno

# Force the Newlib libraries to be recompiled with the same compiler
# flags as used by the BSP. This is done so that the floating-point
# math library will use available floating-point custom instructions
# instead of the slower software emulation.
set_sw_property compile_newlib 1
