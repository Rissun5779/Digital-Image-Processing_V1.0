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


set dut_parameters [list]

# DUT_PARAMETERS

puts "Generating altera_seriallite_iii synthesis model"
set arg_list [list]
set output_dir [file join example_design ${variant_name}]
set spd_filename [file join $output_dir ${variant_name}.spd]

#lappend arg_list "--file-set=$sim_gen"
lappend arg_list "--family=$dut_device_family"
lappend arg_list "--synthesis=$sim_gen"
#lappend arg_list "--simulation=$sim_gen"
#lappend arg_list "--system-info=DEVICE_FAMILY=$dut_device_family"
lappend arg_list "--part=$dut_device_part"
#lappend arg_list "--output-name=${variant_name}"
lappend arg_list "--output-directory=$output_dir"
#lappend arg_list "--report-file=spd:$spd_filename"

set qdir $::env(QUARTUS_ROOTDIR)
catch {eval [concat [list exec "$qdir/sopc_builder/bin/qsys-generate" ../qsys_design/$variant_name.qsys] $arg_list ]} temp
puts $temp


# Declare directory for setup scripts
#set setup_scripts_dir [file join testbench setup_scripts]

# Create setup scripts(i.e msim_setup.tcl) by joining generated spd files
#catch {eval [list exec "$qdir/sopc_builder/bin/ip-make-simscript" --spd=${spd_filename} --spd=${tb_spd} --output-directory=$setup_scripts_dir]} temp
#puts $temp

