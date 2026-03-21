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


set alt_mem_if_tcl_libs_dir "$env(QUARTUS_ROOTDIR)/../ip/altera/alt_mem_if/alt_mem_if_tcl_packages"
if {[lsearch -exact $auto_path $alt_mem_if_tcl_libs_dir] == -1} {
	lappend auto_path $alt_mem_if_tcl_libs_dir
}


package require -exact qsys 12.0

package require alt_mem_if::util::messaging
package require alt_mem_if::util::profiling
package require alt_mem_if::gen::uniphy_interfaces
package require alt_mem_if::util::hwtcl_utils

namespace import ::alt_mem_if::util::messaging::*

set_module_property NAME m10_trk_mgr
set_module_property VERSION 18.1
set_module_property AUTHOR "Altera Corporation"
::alt_mem_if::util::hwtcl_utils::set_module_internal_mode
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP [::alt_mem_if::util::hwtcl_utils::memory_sequencer_components_group_name] 
set_module_property DISPLAY_NAME "Max10 Tracking Manager"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL TRUE

add_fileset sim_vhdl SIM_VHDL generate_vhdl_sim
set_fileset_property sim_vhdl TOP_LEVEL sequencer_trk_mgr
add_fileset sim_verilog SIM_VERILOG generate_verilog_sim
set_fileset_property sim_verilog TOP_LEVEL sequencer_trk_mgr
add_fileset quartus_synth QUARTUS_SYNTH generate_synth
set_fileset_property quartus_synth TOP_LEVEL sequencer_trk_mgr


proc generate_verilog_fileset {} {
	set file_list [list \
		sequencer_trk_mgr_m10.sv \
	]
	
	return $file_list
}


proc generate_vhdl_sim {name} {
	_dprint 1 "Preparing to generate VHDL simulation fileset for $name"

	set non_encryp_simulators [::alt_mem_if::util::hwtcl_utils::get_simulator_attributes 1]

	foreach file_name [generate_verilog_fileset] {
		_dprint 1 "Preparing to add $file_name"

		add_fileset_file $file_name [::alt_mem_if::util::hwtcl_utils::get_file_type $file_name] PATH $file_name $non_encryp_simulators

		add_fileset_file [file join mentor $file_name] [::alt_mem_if::util::hwtcl_utils::get_file_type $file_name 1 1] PATH [file join mentor $file_name] {MENTOR_SPECIFIC}
	}
}

proc generate_verilog_sim {name} {
	_dprint 1 "Preparing to generate verilog simulation fileset for $name"

	foreach file_name [generate_verilog_fileset] {
		_dprint 1 "Preparing to add $file_name"
		add_fileset_file $file_name [::alt_mem_if::util::hwtcl_utils::get_file_type $file_name] PATH $file_name
	}
}

proc generate_synth {name} {
	_dprint 1 "Preparing to generate verilog synthesis fileset for $name"

	foreach file_name [generate_verilog_fileset] {
		_dprint 1 "Preparing to add $file_name"
		add_fileset_file $file_name [::alt_mem_if::util::hwtcl_utils::get_file_type $file_name 0] PATH $file_name
	}
}

add_parameter AVL_DATA_WIDTH INTEGER 32
set_parameter_property AVL_DATA_WIDTH DISPLAY_NAME AVL_DATA_WIDTH
set_parameter_property AVL_DATA_WIDTH AFFECTS_ELABORATION true
set_parameter_property AVL_DATA_WIDTH HDL_PARAMETER true
set_parameter_property AVL_DATA_WIDTH ALLOWED_RANGES {1:2147483647}

add_parameter AVL_ADDR_WIDTH INTEGER 20
set_parameter_property AVL_ADDR_WIDTH DISPLAY_NAME AVL_ADDR_WIDTH
set_parameter_property AVL_ADDR_WIDTH ALLOWED_RANGES 1:1024
set_parameter_property AVL_ADDR_WIDTH AFFECTS_ELABORATION true
set_parameter_property AVL_ADDR_WIDTH HDL_PARAMETER true
set_parameter_property AVL_ADDR_WIDTH ALLOWED_RANGES {1:2147483647}

add_parameter MEM_IF_READ_DQS_WIDTH INTEGER 8
set_parameter_property MEM_IF_READ_DQS_WIDTH DISPLAY_NAME MEM_IF_READ_DQS_WIDTH
set_parameter_property MEM_IF_READ_DQS_WIDTH AFFECTS_ELABORATION true
set_parameter_property MEM_IF_READ_DQS_WIDTH HDL_PARAMETER true
set_parameter_property MEM_IF_READ_DQS_WIDTH ALLOWED_RANGES {1:1024}

add_parameter READ_VALID_FIFO_SIZE INTEGER 4
set_parameter_property READ_VALID_FIFO_SIZE DISPLAY_NAME READ_VALID_FIFO_SIZE
set_parameter_property READ_VALID_FIFO_SIZE AFFECTS_ELABORATION true
set_parameter_property READ_VALID_FIFO_SIZE HDL_PARAMETER true
set_parameter_property READ_VALID_FIFO_SIZE ALLOWED_RANGES {1:1024}

add_parameter PHY_MGR_BASE INTEGER 0x00000
set_parameter_property PHY_MGR_BASE DISPLAY_NAME PHY_MGR_BASE
set_parameter_property PHY_MGR_BASE AFFECTS_ELABORATION true
set_parameter_property PHY_MGR_BASE HDL_PARAMETER true

add_parameter RW_MGR_BASE INTEGER 0x00000
set_parameter_property RW_MGR_BASE DISPLAY_NAME RW_MGR_BASE
set_parameter_property RW_MGR_BASE AFFECTS_ELABORATION true
set_parameter_property RW_MGR_BASE HDL_PARAMETER true

add_parameter PLL_MGR_BASE INTEGER 0x00000
set_parameter_property PLL_MGR_BASE DISPLAY_NAME PLL_MGR_BASE
set_parameter_property PLL_MGR_BASE AFFECTS_ELABORATION true
set_parameter_property PLL_MGR_BASE HDL_PARAMETER true



if {[string compare -nocase [::alt_mem_if::util::hwtcl_utils::combined_callbacks] "false"] == 0} {
	set_module_property Validation_Callback ip_validate
	set_module_property elaboration_Callback ip_elaborate
} else {
	set_module_property elaboration_Callback combined_callback
}

proc combined_callback {} {
	ip_validate
	ip_elaborate
}

proc ip_validate {} {
	_dprint 1 "Running IP Validation"

}

proc ip_elaborate {} {
	_dprint 1 "Running IP Elaboration"

	
	add_interface avl_clk clock end
	set_interface_property avl_clk ENABLED true
	add_interface_port avl_clk avl_clk clk Input 1
	

	add_interface avl_reset reset end
	set_interface_property avl_reset ENABLED true
	set_interface_property avl_reset synchronousEdges NONE
	add_interface_port avl_reset avl_reset_n reset_n Input 1
	
	::alt_mem_if::gen::uniphy_interfaces::tracking_manager_interfaces "master" "trkm"
	::alt_mem_if::gen::uniphy_interfaces::tracking_strobe "sequencer"

	add_interface afi conduit end

	set_interface_property afi ENABLED true

	add_interface_port afi afi_seq_busy afi_seq_busy Output 1
	add_interface_port afi afi_ctl_long_idle afi_ctl_long_idle Input 1
	add_interface_port afi afi_ctl_refresh_done afi_ctl_refresh_done Input 1
	foreach port_name [list afi_seq_busy afi_ctl_long_idle afi_ctl_refresh_done] {
		set_port_property $port_name VHDL_TYPE STD_LOGIC_VECTOR
	}
}
