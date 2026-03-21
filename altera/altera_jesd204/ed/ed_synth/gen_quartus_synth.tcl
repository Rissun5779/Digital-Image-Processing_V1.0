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

# Adding_filesets
puts "Generating Jesd204 example design"
set arg_list [list]
set output_dir [file join example_design ${variant_name}]
set spd_filename [file join $output_dir ${variant_name}.spd]

lappend arg_list "--file-set=QUARTUS_SYNTH"
lappend arg_list "--system-info=DEVICE_FAMILY=$dut_device_family"
lappend arg_list "--part=$dut_device_part"
lappend arg_list "--component-parameter=DATA_PATH=RX_TX"
lappend arg_list "--output-name=${variant_name}"
lappend arg_list "--output-dir=$output_dir"
lappend arg_list "--report-file=spd:$spd_filename"
lappend arg_list "--report-file=csv:${output_dir}.csv"
lappend arg_list "--report-file=qip:$output_dir/${variant_name}.qip"

set qdir $::env(QUARTUS_ROOTDIR)
catch {eval [concat [list exec "$qdir/sopc_builder/bin/ip-generate" --component-name=altera_jesd204] $arg_list $dut_parameters]} temp
puts $temp

puts "Generating Transceiver Reset Control simulation model"
set rst_ctrl_name "xcvr_reset_control"
set rst_ctrl_parameters [list]

# RST_CTRL_PARAMETERS


set output_dir_rst_ctrl [file join example_design ${rst_ctrl_name}_module]
set spd_filename_rst_ctrl [file join $output_dir_rst_ctrl ${rst_ctrl_name}.spd]

set arg_list_rst_ctrl [list]
lappend arg_list_rst_ctrl "--file-set=QUARTUS_SYNTH"
lappend arg_list_rst_ctrl "--system-info=DEVICE_FAMILY=$dut_device_family"
lappend arg_list_rst_ctrl "--part=$dut_device_part"
lappend arg_list_rst_ctrl "--output-name=$rst_ctrl_name"
lappend arg_list_rst_ctrl "--output-dir=$output_dir_rst_ctrl"
lappend arg_list_rst_ctrl "--report-file=spd:$spd_filename_rst_ctrl"
lappend arg_list_rst_ctrl "--report-file=qip:$output_dir_rst_ctrl/${rst_ctrl_name}.qip"

set qdir $::env(QUARTUS_ROOTDIR)
catch {eval [concat [list exec "$qdir/sopc_builder/bin/ip-generate" --component-name=altera_xcvr_reset_control ] $arg_list_rst_ctrl $rst_ctrl_parameters]} temp
puts $temp

puts "Generating PLL_reconfig simulation model"
set pll_reconfig_name "core_pll_reconfig"
set pll_reconfig_parameters [list]



set output_dir_pll_reconfig [file join example_design ${pll_reconfig_name}_module]
set spd_filename_pll_reconfig [file join $output_dir_pll_reconfig ${pll_reconfig_name}.spd]

set arg_list_pll_reconfig [list]
lappend arg_list_pll_reconfig "--file-set=QUARTUS_SYNTH"
lappend arg_list_pll_reconfig "--system-info=DEVICE_FAMILY=$dut_device_family"
lappend arg_list_pll_reconfig "--part=$dut_device_part"
lappend arg_list_pll_reconfig "--output-name=$pll_reconfig_name"
lappend arg_list_pll_reconfig "--output-dir=$output_dir_pll_reconfig"
lappend arg_list_pll_reconfig "--report-file=spd:$spd_filename_pll_reconfig"
lappend arg_list_pll_reconfig "--report-file=qip:$output_dir_pll_reconfig/${pll_reconfig_name}.qip"

set qdir $::env(QUARTUS_ROOTDIR)
catch {eval [concat [list exec "$qdir/sopc_builder/bin/ip-generate" --component-name=altera_pll_reconfig ] $arg_list_pll_reconfig $pll_reconfig_parameters]} temp
puts $temp

puts "Generating XCVR_RECONFIG simulation model"
set xcvr_reconfig_name "XCVR_reconfig"
set xcvr_reconfig_parameters [list]



set output_dir_xcvr_reconfig [file join example_design ${xcvr_reconfig_name}_module]
set spd_filename_xcvr_reconfig [file join $output_dir_xcvr_reconfig ${xcvr_reconfig_name}.spd]

set arg_list_xcvr_reconfig [list]
lappend arg_list_xcvr_reconfig "--file-set=QUARTUS_SYNTH"
lappend arg_list_xcvr_reconfig "--system-info=DEVICE_FAMILY=$dut_device_family"
lappend arg_list_xcvr_reconfig "--part=$dut_device_part"
lappend arg_list_xcvr_reconfig "--output-name=$xcvr_reconfig_name"
lappend arg_list_xcvr_reconfig "--output-dir=$output_dir_xcvr_reconfig"
lappend arg_list_xcvr_reconfig "--report-file=spd:$spd_filename_xcvr_reconfig"
lappend arg_list_xcvr_reconfig "--report-file=qip:$output_dir_xcvr_reconfig/${xcvr_reconfig_name}.qip"

set qdir $::env(QUARTUS_ROOTDIR)
catch {eval [concat [list exec "$qdir/sopc_builder/bin/ip-generate" --component-name=alt_xcvr_reconfig ] $arg_list_xcvr_reconfig $xcvr_reconfig_parameters]} temp
puts $temp

puts "Generating Altera PLL simulation model"
set pll_name "core_pll"
set pll_parameters [list]


set output_dir_pll [file join example_design ${pll_name}_module]
#set spd_filename_pll [file join $output_dir_pll ${pll_name}.spd]

set arg_list_pll [list]
lappend arg_list_pll "--file-set=QUARTUS_SYNTH"
lappend arg_list_pll "--system-info=DEVICE_FAMILY=$dut_device_family"
lappend arg_list_pll "--part=$dut_device_part"
lappend arg_list_pll "--component-parameter=gui_reference_clock_frequency=$PLL_refclk_freq"
lappend arg_list_pll "--component-parameter=gui_number_of_clocks=2"
lappend arg_list_pll "--component-parameter=gui_output_clock_frequency0=$pll_output_clk_freq0"
lappend arg_list_pll "--component-parameter=gui_output_clock_frequency1=$PLL_refclk_freq"
lappend arg_list_pll "--component-parameter=gui_en_reconf=1"
lappend arg_list_pll "--component-parameter=gui_operation_mode=source synchronous"
lappend arg_list_pll "--output-name=$pll_name"
lappend arg_list_pll "--output-dir=$output_dir_pll"
#lappend arg_list_pll "--report-file=spd:$spd_filename_pll"
lappend arg_list_pll "--report-file=txt:$output_dir_pll/${pll_name}.txt"
lappend arg_list_pll "--report-file=qip:$output_dir_pll/${pll_name}.qip"
lappend arg_list_pll "--report-file=csv:$output_dir_pll/${pll_name}.csv"


set qdir $::env(QUARTUS_ROOTDIR)
catch {eval [concat [list exec "$qdir/sopc_builder/bin/ip-generate" --component-name=altera_pll ] $arg_list_pll $pll_parameters]} temp
puts $temp

cd example_design
source create_project.tcl

# Create setup scripts(i.e msim_setup.tcl) by joining generated spd files
#set setup_scripts_dir [file join example_design setup_scripts]
#catch {eval [list exec "$qdir/sopc_builder/bin/ip-make-simscript" --spd=${spd_filename} --spd=${spd_filename_pll_reconfig} --spd=${spd_filename_xcvr_reconfig} --spd=${spd_filename_pll} --spd=${spd_filename_rst_ctrl} --compile-to-work --output-directory=$setup_scripts_dir]} temp
#puts $temp

