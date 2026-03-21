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


# *********************************************************************
# Description
# 
# Top-level Tcl script for compiling HDMI Example Designs
#
# *********************************************************************

# Use Quartus 64bit version
export PATH=`cygpath -u $QUARTUS_ROOTDIR/bin64`:$PATH

# Fix a Quartus 13.1 bug affecting SW hex file generation
export QUARTUS_BINDIR=${QUARTUS_ROOTDIR}/bin

# Build the IP
quartus_sh -t build_ip.tcl

# create the SW
sh build_sw.sh

# Compile the project
quartus_map sv_hdmi2_demo
#quartus_sta -t ./qsys_vip_passthrough/synthesis/submodules/qsys_vip_passthrough_ddr3_p0_pin_assignments.tcl sv_hdmi2_demo
quartus_fit sv_hdmi2_demo
quartus_sta sv_hdmi2_demo
quartus_asm sv_hdmi2_demo
