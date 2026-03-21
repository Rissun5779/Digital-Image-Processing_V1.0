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


puts "Generating Jesd204 simulation model"
set arg_list [list]
set output_dir [file join testbench ${variant_name}_sim]
set spd_filename [file join $output_dir ${variant_name}.spd]

lappend arg_list "--file-set=$sim_gen"
lappend arg_list "--system-info=DEVICE_FAMILY=$dut_device_family"
lappend arg_list "--part=$dut_device_part"
lappend arg_list "--output-name=${variant_name}"
lappend arg_list "--output-dir=$output_dir"
lappend arg_list "--report-file=spd:$spd_filename"

set qdir $::env(QUARTUS_ROOTDIR)
catch {eval [concat [list exec "$qdir/sopc_builder/bin/ip-generate" --component-name=altera_jesd204] $arg_list $dut_parameters]} temp
puts $temp

puts "Generating Transceiver Reset Control simulation model"
set rst_ctrl_name "xcvr_reset_control"
set rst_ctrl_parameters [list]

# RST_CTRL_PARAMETERS


set output_dir_rst_ctrl [file join testbench ${rst_ctrl_name}_sim]
set spd_filename_rst_ctrl [file join $output_dir_rst_ctrl ${rst_ctrl_name}.spd]

set arg_list_rst_ctrl [list]
lappend arg_list_rst_ctrl "--file-set=$sim_gen"
lappend arg_list_rst_ctrl "--system-info=DEVICE_FAMILY=$dut_device_family"
lappend arg_list_rst_ctrl "--part=$dut_device_part"
lappend arg_list_rst_ctrl "--output-name=$rst_ctrl_name"
lappend arg_list_rst_ctrl "--output-dir=$output_dir_rst_ctrl"
lappend arg_list_rst_ctrl "--report-file=spd:$spd_filename_rst_ctrl"

set qdir $::env(QUARTUS_ROOTDIR)
catch {eval [concat [list exec "$qdir/sopc_builder/bin/ip-generate" --component-name=altera_xcvr_reset_control ] $arg_list_rst_ctrl $rst_ctrl_parameters]} temp
puts $temp

puts "Generating PLL_reconfig simulation model"
set pll_reconfig_name "core_pll_reconfig"
set pll_reconfig_parameters [list]
lappend pll_reconfig_parameters "--component-parameter=ENABLE_MIF=true"
lappend pll_reconfig_parameters "--component-parameter=MIF_FILE_NAME=core_pll.mif"

set output_dir_pll_reconfig [file join testbench ${pll_reconfig_name}]
set spd_filename_pll_reconfig [file join $output_dir_pll_reconfig ${pll_reconfig_name}.spd]

set arg_list_pll_reconfig [list]
lappend arg_list_pll_reconfig "--file-set=$sim_gen"
lappend arg_list_pll_reconfig "--system-info=DEVICE_FAMILY=$dut_device_family"
lappend arg_list_pll_reconfig "--part=$dut_device_part"
lappend arg_list_pll_reconfig "--output-name=$pll_reconfig_name"
lappend arg_list_pll_reconfig "--output-dir=$output_dir_pll_reconfig"
lappend arg_list_pll_reconfig "--report-file=spd:$spd_filename_pll_reconfig"

set qdir $::env(QUARTUS_ROOTDIR)
catch {eval [concat [list exec "$qdir/sopc_builder/bin/ip-generate" --component-name=altera_pll_reconfig ] $arg_list_pll_reconfig $pll_reconfig_parameters]} temp
puts $temp

puts "Generating XCVR_RECONFIG simulation model"
set xcvr_reconfig_name "XCVR_reconfig"
set xcvr_reconfig_parameters [list]



set output_dir_xcvr_reconfig [file join testbench ${xcvr_reconfig_name}_sim]
set spd_filename_xcvr_reconfig [file join $output_dir_xcvr_reconfig ${xcvr_reconfig_name}.spd]

set arg_list_xcvr_reconfig [list]
lappend arg_list_xcvr_reconfig "--file-set=$sim_gen"
lappend arg_list_xcvr_reconfig "--system-info=DEVICE_FAMILY=$dut_device_family"
lappend arg_list_xcvr_reconfig "--part=$dut_device_part"
lappend arg_list_xcvr_reconfig "--output-name=$xcvr_reconfig_name"
lappend arg_list_xcvr_reconfig "--output-dir=$output_dir_xcvr_reconfig"
lappend arg_list_xcvr_reconfig "--report-file=spd:$spd_filename_xcvr_reconfig"

set qdir $::env(QUARTUS_ROOTDIR)
catch {eval [concat [list exec "$qdir/sopc_builder/bin/ip-generate" --component-name=alt_xcvr_reconfig ] $arg_list_xcvr_reconfig $xcvr_reconfig_parameters]} temp
puts $temp

#Create spd files for modules 
set modules_dir "testbench/"
#set model_dir "testbench/models"
set m_spd [open "$modules_dir/modules.spd" w]
   puts $m_spd "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
   puts $m_spd "<simPackage>"
   puts $m_spd "<file path=\"models/tb_top.sv\" type=\"SYSTEM_VERILOG\" />"
   #puts $m_spd "<file_path=\"jesd204b_ed.v\" type=\"VERILOG\" library=\"tb_top\" />"
   puts $m_spd "<topLevel name=\"tb_top\" />"
   #puts $m_spd "</simPackage>" 
   #puts $m_spd "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
   #puts $m_spd "<simPackage>"
   puts $m_spd "<file path=\"models/jesd204b_ed.sv\" type=\"SYSTEM_VERILOG\" />"
   puts $m_spd "<topLevel name=\"jesd204b_ed\" />"
   puts $m_spd "<file path=\"altera_reset_controller/altera_reset_controller.v\" type=\"VERILOG\" />"
   puts $m_spd "<topLevel name=\"altera_reset_controller\" />"
   puts $m_spd "<file path=\"altera_reset_controller/altera_reset_synchronizer.v\" type=\"VERILOG\" />"
   puts $m_spd "<topLevel name=\"altera_reset_synchronizer\" />"
   puts $m_spd "<file path=\"control_unit/control_unit.sv\" type=\"SYSTEM_VERILOG\" />"
   puts $m_spd "<topLevel name=\"control_unit\" />"
   puts $m_spd "<file path=\"control_unit/rom_1port_16.v\" type=\"VERILOG\" />"
   puts $m_spd "<topLevel name=\"rom_1port_16\" />"
   puts $m_spd "<file path=\"control_unit/rom_1port_128.v\" type=\"VERILOG\" />"
   puts $m_spd "<topLevel name=\"rom_1port_128\" />"
   puts $m_spd "<file path=\"control_unit/phy_mif_rom.v\" type=\"VERILOG\" />"
   puts $m_spd "<topLevel name=\"phy_mif_rom\" />"
   puts $m_spd "<file path=\"pattern/alternate_checker.sv\" type=\"SYSTEM_VERILOG\" />"
   puts $m_spd "<topLevel name=\"alternate_checker\" />"
   puts $m_spd "<file path=\"pattern/alternate_generator.sv\" type=\"SYSTEM_VERILOG\" />"
   puts $m_spd "<topLevel name=\"alternate_generator\" />"
   puts $m_spd "<file path=\"pattern/pattern_checker_top.sv\" type=\"SYSTEM_VERILOG\" />"
   puts $m_spd "<topLevel name=\"pattern_checker_top\" />"
   puts $m_spd "<file path=\"pattern/pattern_generator_top.sv\" type=\"SYSTEM_VERILOG\" />"
   puts $m_spd "<topLevel name=\"pattern_generator_top\" />"
   puts $m_spd "<file path=\"pattern/prbs_checker.sv\" type=\"SYSTEM_VERILOG\" />"
   puts $m_spd "<topLevel name=\"prbs_checker\" />"
   puts $m_spd "<file path=\"pattern/prbs_generator.sv\" type=\"SYSTEM_VERILOG\" />"
   puts $m_spd "<topLevel name=\"prbs_generator\" />"
   puts $m_spd "<file path=\"pattern/ramp_checker.sv\" type=\"SYSTEM_VERILOG\" />"
   puts $m_spd "<topLevel name=\"ramp_checker\" />"
   puts $m_spd "<file path=\"pattern/ramp_generator.sv\" type=\"SYSTEM_VERILOG\" />"
   puts $m_spd "<topLevel name=\"ramp_generator\" />"
   #puts $m_spd "<file path=\"pll/core_pll_0002.v\" type=\"VERILOG\" />"
   #puts $m_spd "<topLevel name=\"core_pll_0002\" />"
   puts $m_spd "<file path=\"pll/core_pll.v\" type=\"VERILOG\" />"
   puts $m_spd "<topLevel name=\"core_pll\" />"
   puts $m_spd "<file path=\"spi/spi_master_24.v\" type=\"VERILOG\" />"
   puts $m_spd "<topLevel name=\"spi_master_24\" />"
   puts $m_spd "<file path=\"spi/spi_master_32.v\" type=\"VERILOG\" />"
   puts $m_spd "<topLevel name=\"spi_master_32\" />"
   puts $m_spd "<file path=\"transport_layer/altera_jesd204_assembler.sv\" type=\"SYSTEM_VERILOG\" />"
   puts $m_spd "<topLevel name=\"altera_jesd204_assembler\" />"
   puts $m_spd "<file path=\"transport_layer/altera_jesd204_deassembler.sv\" type=\"SYSTEM_VERILOG\" />"
   puts $m_spd "<topLevel name=\"altera_jesd204_deassembler\" />"
   puts $m_spd "<file path=\"transport_layer/altera_jesd204_transport_rx_top.sv\" type=\"SYSTEM_VERILOG\" />"
   puts $m_spd "<topLevel name=\"altera_jesd204_transport_rx_top\" />"
   puts $m_spd "<file path=\"transport_layer/altera_jesd204_transport_tx_top.sv\" type=\"SYSTEM_VERILOG\" />"
   puts $m_spd "<topLevel name=\"altera_jesd204_transport_tx_top\" />"
   puts $m_spd "</simPackage>" 
close $m_spd
set modules_spd "$modules_dir/modules.spd"


# ed_sim_PLL_PARAMETERS

# Create setup scripts(i.e msim_setup.tcl) by joining generated spd files
set setup_scripts_dir [file join testbench setup_scripts]
catch {eval [list exec "$qdir/sopc_builder/bin/ip-make-simscript" --spd=${spd_filename_rst_ctrl} --spd=${modules_spd} --spd=${spd_filename} --spd=${spd_filename_pll_reconfig} --spd=${spd_filename_xcvr_reconfig} --compile-to-work --output-directory=$setup_scripts_dir]} temp
puts $temp

