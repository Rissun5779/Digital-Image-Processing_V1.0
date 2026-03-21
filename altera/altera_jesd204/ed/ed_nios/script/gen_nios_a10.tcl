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


set jesd_subsystem_name "jesd204b_subsystem"
set dut_parameters [list]

# DUT_PARAMETERS

# Adding_filesets
puts "Generating Jesd204_subsystem"
set arg_list [list]
set output_dir [file join "" ${jesd_subsystem_name}]
set spd_filename [file join $output_dir ${jesd_subsystem_name}.spd]

lappend arg_list "--file-set=QUARTUS_SYNTH"
lappend arg_list "--system-info=DEVICE_FAMILY=$dut_device_family"
lappend arg_list "--part=$dut_device_part"
lappend arg_list "--component-file=${jesd_subsystem_name}.qsys"
lappend arg_list "--output-name=${jesd_subsystem_name}"
lappend arg_list "--output-dir=$output_dir"
lappend arg_list "--report-file=spd:$spd_filename"
lappend arg_list "--report-file=csv:${output_dir}.csv"
lappend arg_list "--report-file=qip:$output_dir/${jesd_subsystem_name}.qip"
lappend arg_list "--report-file=sopcinfo:${jesd_subsystem_name}.sopcinfo"

set qdir $::env(QUARTUS_ROOTDIR)
catch {eval [concat [list exec "$qdir/sopc_builder/bin/ip-generate" ] $arg_list $dut_parameters]} temp
puts $temp

puts "Generating NIOS_subsystem"
set nios_subsystem_name "nios_subsystem"
set arg_list [list]
set output_dir [file join "" ${nios_subsystem_name}]
set spd_filename [file join $output_dir ${nios_subsystem_name}.spd]

lappend arg_list "--file-set=QUARTUS_SYNTH"
lappend arg_list "--system-info=DEVICE_FAMILY=$dut_device_family"
lappend arg_list "--part=$dut_device_part"
lappend arg_list "--component-file=${nios_subsystem_name}.qsys"
lappend arg_list "--output-name=${nios_subsystem_name}"
lappend arg_list "--output-dir=$output_dir"
lappend arg_list "--report-file=spd:$spd_filename"
lappend arg_list "--report-file=csv:${output_dir}.csv"
lappend arg_list "--report-file=qip:$output_dir/${nios_subsystem_name}.qip"
lappend arg_list "--report-file=sopcinfo:${nios_subsystem_name}.sopcinfo"

set qdir $::env(QUARTUS_ROOTDIR)
catch {eval [concat [list exec "$qdir/sopc_builder/bin/ip-generate" ] $arg_list $dut_parameters]} temp
puts $temp

puts "Generating se_outbuf_1bit"
set se_outbuf_1bit_name "se_outbuf_1bit"
set arg_list [list]
set output_dir [file join "" ${se_outbuf_1bit_name}]
set spd_filename [file join $output_dir ${se_outbuf_1bit_name}.spd]

lappend arg_list "--file-set=QUARTUS_SYNTH"
lappend arg_list "--system-info=DEVICE_FAMILY=$dut_device_family"
lappend arg_list "--part=$dut_device_part"
lappend arg_list "--component-file=${se_outbuf_1bit_name}.qsys"
lappend arg_list "--output-name=${se_outbuf_1bit_name}"
lappend arg_list "--output-dir=$output_dir"
lappend arg_list "--report-file=spd:$spd_filename"
lappend arg_list "--report-file=csv:${output_dir}.csv"
lappend arg_list "--report-file=qip:$output_dir/${se_outbuf_1bit_name}.qip"
lappend arg_list "--report-file=sopcinfo:${se_outbuf_1bit_name}.sopcinfo"

set qdir $::env(QUARTUS_ROOTDIR)
catch {eval [concat [list exec "$qdir/sopc_builder/bin/ip-generate" ] $arg_list $dut_parameters]} temp
puts $temp

puts "Generating jesd204b_ed_qsys"
set jesd204b_ed_qsys_name "jesd204b_ed_qsys"
set arg_list [list]
set output_dir [file join "" ${jesd204b_ed_qsys_name}]
set spd_filename [file join $output_dir ${jesd204b_ed_qsys_name}.spd]

lappend arg_list "--file-set=QUARTUS_SYNTH"
lappend arg_list "--system-info=DEVICE_FAMILY=$dut_device_family"
lappend arg_list "--part=$dut_device_part"
lappend arg_list "--component-file=${jesd204b_ed_qsys_name}.qsys"
lappend arg_list "--output-name=${jesd204b_ed_qsys_name}"
lappend arg_list "--output-dir=$output_dir"
lappend arg_list "--report-file=spd:$spd_filename"
lappend arg_list "--report-file=csv:${output_dir}.csv"
lappend arg_list "--report-file=qip:$output_dir/${jesd204b_ed_qsys_name}.qip"
lappend arg_list "--report-file=sopcinfo:${jesd204b_ed_qsys_name}.sopcinfo"
lappend arg_list "--report-file=sip:$output_dir/${jesd204b_ed_qsys_name}.sip"

set qdir $::env(QUARTUS_ROOTDIR)
catch {eval [concat [list exec "$qdir/sopc_builder/bin/ip-generate" ] $arg_list $dut_parameters]} temp
puts $temp



source create_project.tcl

# Create setup scripts(i.e msim_setup.tcl) by joining generated spd files
#set setup_scripts_dir [file join example_design setup_scripts]
#catch {eval [list exec "$qdir/sopc_builder/bin/ip-make-simscript" --spd=${spd_filename} --spd=${spd_filename_pll_reconfig} --spd=${spd_filename_xcvr_reconfig} --spd=${spd_filename_pll} --spd=${spd_filename_rst_ctrl} --compile-to-work --output-directory=$setup_scripts_dir]} temp
#puts $temp

