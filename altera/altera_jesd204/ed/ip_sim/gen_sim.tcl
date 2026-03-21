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


# INFO

# GENERAL_PARAMETERS


# TX_DUT_PARAMETERS


# GENERATE_TX_DUT


# RX_DUT_PARAMETERS


# GENERATE_RX_DUT


# Create spd for files that not generated from IP-GENERATE
set tb_dir "testbench/models"
set w_spd [open "$tb_dir/tb_jesd204.spd" w]
   puts $w_spd "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
   puts $w_spd "<simPackage>"
   puts $w_spd "<file path=\"tb_jesd204.sv\" type=\"SYSTEM_VERILOG\" />"
   puts $w_spd "<topLevel name=\"tb_jesd204\" />"
   puts $w_spd "</simPackage>" 
close $w_spd
set tb_spd "$tb_dir/tb_jesd204.spd"

# Declare directory for setup scripts
set setup_scripts_dir [file join testbench setup_scripts]

# Create setup scripts(i.e msim_setup.tcl) by joining generated spd files
catch {eval [list exec "$qdir/sopc_builder/bin/ip-make-simscript" --spd=${tx_spd_filename} --spd=${rx_spd_filename} --spd=${tb_spd} --output-directory=$setup_scripts_dir]} temp
puts $temp
	


