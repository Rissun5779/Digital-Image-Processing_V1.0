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

if {$is_qsys_pro} {
    set spd_filename [file join $output_dir $variant_name ${variant_name}.spd]
	
	lappend arg_list "--family=$dut_device_family"
	lappend arg_list "--part=$dut_device_part"
	lappend arg_list "--output-name=${variant_name}"
	lappend arg_list "--output-directory=$output_dir"

	
    catch {eval [concat [list exec "ip-deploy" --component-name=altera_jesd204] $arg_list $dut_parameters]} temp
    puts $temp

    if {[string equal $sim_gen "SIM_VHDL"]} {
	   catch {eval [list exec "qsys-generate" --simulation=VHDL "${output_dir}/${variant_name}.ip"]} temp
    } else {
	   catch {eval [list exec "qsys-generate" --simulation=VERILOG "${output_dir}/${variant_name}.ip"]} temp
    }
    puts $temp
} else {
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
}

puts "Generating Transceiver Reset Control simulation model"
set rst_ctrl_name "xcvr_reset_control"
set rst_ctrl_parameters [list]

# RST_CTRL_PARAMETERS

set arg_list_rst_ctrl [list]
set output_dir_rst_ctrl [file join testbench ${rst_ctrl_name}_sim]

if {$is_qsys_pro} {
    set spd_filename_rst_ctrl [file join $output_dir_rst_ctrl $rst_ctrl_name ${rst_ctrl_name}.spd]
	
	lappend arg_list_rst_ctrl "--family=$dut_device_family"
	lappend arg_list_rst_ctrl "--part=$dut_device_part"
	lappend arg_list_rst_ctrl "--output-name=$rst_ctrl_name"
	lappend arg_list_rst_ctrl "--output-directory=$output_dir_rst_ctrl"
	
    catch {eval [concat [list exec "ip-deploy" --component-name=altera_xcvr_reset_control] $arg_list_rst_ctrl $rst_ctrl_parameters]} temp
    puts $temp

    if {[string equal $sim_gen "SIM_VHDL"]} {
	   catch {eval [list exec "qsys-generate" --simulation=VHDL "${output_dir_rst_ctrl}/${rst_ctrl_name}.ip"]} temp
    } else {
	   catch {eval [list exec "qsys-generate" --simulation=VERILOG "${output_dir_rst_ctrl}/${rst_ctrl_name}.ip"]} temp
    }
    puts $temp
} else {
    set spd_filename_rst_ctrl [file join $output_dir_rst_ctrl ${rst_ctrl_name}.spd]

	lappend arg_list_rst_ctrl "--file-set=$sim_gen"
	lappend arg_list_rst_ctrl "--system-info=DEVICE_FAMILY=$dut_device_family"
	lappend arg_list_rst_ctrl "--part=$dut_device_part"
	lappend arg_list_rst_ctrl "--output-name=$rst_ctrl_name"
	lappend arg_list_rst_ctrl "--output-dir=$output_dir_rst_ctrl"
	lappend arg_list_rst_ctrl "--report-file=spd:$spd_filename_rst_ctrl"

    set qdir $::env(QUARTUS_ROOTDIR)
    catch {eval [concat [list exec "$qdir/sopc_builder/bin/ip-generate" --component-name=altera_xcvr_reset_control ] $arg_list_rst_ctrl $rst_ctrl_parameters]} temp
    puts $temp
}

puts "Generating PLL_reconfig simulation model"
set pll_reconfig_name "core_pll_reconfig"

set output_dir_pll_reconfig [file join testbench ${pll_reconfig_name}]
set spd_filename_pll_reconfig [file join $output_dir_pll_reconfig ${pll_reconfig_name}.spd]

set arg_list_pll_reconfig [list]

if {[string equal $sim_gen "SIM_VHDL"]} {
   lappend arg_list_pll_reconfig "--simulation=VHDL"
} else {
   lappend arg_list_pll_reconfig "--simulation=VERILOG"
}
lappend arg_list_pll_reconfig "--part=$dut_device_part"
lappend arg_list_pll_reconfig "--output-directory=$output_dir_pll_reconfig"

set pll_reconfig_qsys_file "./testbench/models/core_pll_reconfig.qsys"

if {$is_qsys_pro} {
    set qsys_file_name [file tail $pll_reconfig_qsys_file]
	
    set script_cmd [list qsys-script --package-version=16.1 --new-quartus-project=$qsys_file_name --system-file=$pll_reconfig_qsys_file --cmd='save_system']
    set status [catch {exec {*}$script_cmd} result]
} 
set qdir $::env(QUARTUS_ROOTDIR)
catch {eval [concat [list exec "$qdir/sopc_builder/bin/qsys-generate" $pll_reconfig_qsys_file ] $arg_list_pll_reconfig ]} temp
puts $temp

puts "Generating XCVR_ATX_PLL simulation model"
set xcvr_atx_pll_name "xcvr_atx_pll"

set output_dir_xcvr_atx_pll [file join testbench ${xcvr_atx_pll_name}_sim]
set spd_filename_xcvr_atx_pll [file join $output_dir_xcvr_atx_pll ${xcvr_atx_pll_name}.spd]

set arg_list_xcvr_atx_pll [list]
if {[string equal $sim_gen "SIM_VHDL"]} {
   lappend arg_list_xcvr_atx_pll "--simulation=VHDL"
} else {
   lappend arg_list_xcvr_atx_pll "--simulation=VERILOG"
}
lappend arg_list_xcvr_atx_pll "--part=$dut_device_part"
lappend arg_list_xcvr_atx_pll "--output-directory=$output_dir_xcvr_atx_pll"

set xcvr_atx_pll_qsys_file "./testbench/models/xcvr_atx_pll.qsys"

if {$is_qsys_pro} {
    set qsys_file_name [file tail $xcvr_atx_pll_qsys_file]
	
    set script_cmd [list qsys-script --package-version=16.1 --new-quartus-project=$qsys_file_name --system-file=$xcvr_atx_pll_qsys_file --cmd='save_system']
    set status [catch {exec {*}$script_cmd} result]
} 

set qdir $::env(QUARTUS_ROOTDIR)
catch {eval [concat [list exec "$qdir/sopc_builder/bin/qsys-generate" $xcvr_atx_pll_qsys_file ] $arg_list_xcvr_atx_pll ]} temp
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
   if {$is_qsys_pro} {
       puts $m_spd "<file path=\"xcvr_reset_control_sim/xcvr_reset_control/altera_xcvr_reset_control_*/sim/altera_xcvr_functions.sv\" type=\"SYSTEM_VERILOG\" />"
   }
   puts $m_spd "<file path=\"models/jesd204b_ed.sv\" type=\"SYSTEM_VERILOG\" />"
   puts $m_spd "<topLevel name=\"jesd204b_ed\" />"
   puts $m_spd "<file path=\"altera_reset_controller/altera_reset_controller.v\" type=\"VERILOG\" />"
   puts $m_spd "<topLevel name=\"altera_reset_controller\" />"
   puts $m_spd "<file path=\"altera_reset_controller/altera_reset_synchronizer.v\" type=\"VERILOG\" />"
   puts $m_spd "<topLevel name=\"altera_reset_synchronizer\" />"
   puts $m_spd "<file path=\"control_unit/control_unit.sv\" type=\"SYSTEM_VERILOG\" />"
   puts $m_spd "<topLevel name=\"control_unit\" />"
   puts $m_spd "<file path=\"control_unit/rom_1port.v\" type=\"VERILOG\" />"
   puts $m_spd "<topLevel name=\"rom_1port\" />"
   puts $m_spd "<file path=\"control_unit/rom_1port_16.v\" type=\"VERILOG\" />"
   puts $m_spd "<topLevel name=\"rom_1port_16\" />"
   puts $m_spd "<file path=\"control_unit/rom_1port_128.v\" type=\"VERILOG\" />"
   puts $m_spd "<topLevel name=\"rom_1port_128\" />"
   puts $m_spd "<file path=\"control_unit/xcvr_reconfig_mif_master.v\" type=\"VERILOG\" />"
   puts $m_spd "<topLevel name=\"xcvr_reconfig_mif_master\" />"
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
catch {eval [list exec "$qdir/sopc_builder/bin/ip-make-simscript"  --spd=${spd_filename_rst_ctrl} --spd=${modules_spd} --spd=${spd_filename} --spd=${spd_filename_pll_reconfig} --spd=${spd_filename_xcvr_atx_pll} --output-directory=$setup_scripts_dir]} temp
puts $temp

