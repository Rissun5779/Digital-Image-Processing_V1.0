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


set alt_mem_if_tcl_libs_dir "$env(QUARTUS_ROOTDIR)/../ip/altera/emif/util"
if {[lsearch -exact $auto_path $alt_mem_if_tcl_libs_dir] == -1} {
   lappend auto_path $alt_mem_if_tcl_libs_dir
}

set altera_gpio_tcl_libs_dir "$env(QUARTUS_ROOTDIR)/../ip/altera/altera_gpio/altera_gpio_common"
if {[lsearch -exact $auto_path $altera_gpio_tcl_libs_dir] == -1} {
   lappend auto_path $altera_gpio_tcl_libs_dir
}

package require -exact qsys 15.0
package require ip_migrate
package require altera_gpio::common

set_module_property DESCRIPTION "GPIO Intel FPGA IP"
set_module_property NAME altera_gpio
set_module_property VERSION 18.1
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property DISPLAY_NAME "GPIO Intel FPGA IP"
set_module_property GROUP "Basic Functions/I\/O"
set_module_property AUTHOR "Intel Corporation"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property SUPPORTED_DEVICE_FAMILIES [list ARRIA10 STRATIX10]
set_module_property EDITABLE true

set_module_property HIDE_FROM_SOPC true
set_module_property HIDE_FROM_QSYS true
set_module_property INTERNAL false
add_documentation_link "Altera GPIO user guide" http://www.altera.com/literature/ug/ug_altera_gpio.pdf


set_module_property COMPOSITION_CALLBACK composition_callback

add_fileset example_design EXAMPLE_DESIGN generate_example_design

add_display_item "" "General" GROUP
add_display_item "" "Buffer" GROUP
add_display_item "" "Registers" GROUP

add_parameter device_family STRING "ArriaVI"
set_parameter_property device_family SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property device_family VISIBLE false
::altera_gpio::common::add_gpio_parameters "false" "true"

proc ip_validate {} {
	::altera_gpio::common::validate
	send_message INFO "Altera GPIO supports a maximum interface frequency of 300 MHZ."
}

proc ip_compose {} {
	set family [get_parameter_value device_family]
	if {[string equal $family "Arria 10"]} {
	   set core_component altera_gpio_core20
	} else {
	   set core_component altera_gpio_core14
	}
	set core_name "core"

	add_instance $core_name $core_component

	foreach param_name [get_parameters] {
		set is_derived_param [get_parameter_property $param_name DERIVED]
		set param_val [get_parameter_value $param_name]
		if {$param_name != "device_family" && $is_derived_param != "1"} {
			set_instance_parameter_value $core_name $param_name $param_val
		}
	}

	foreach interface_name [get_instance_interfaces $core_name] {
		add_interface ${interface_name} conduit end
		set_interface_property ${interface_name} EXPORT_OF ${core_name}.${interface_name}
		rename_exported_interface_ports $core_name ${interface_name} ${interface_name}
	}
	
	if {[string equal -nocase [get_parameter_value gui_enable_migratable_port_names] "true"]} {
		::ip_migrate::do_port_mappings [get_parameter_value IP_MIGRATE_PORT_MAP_FILE]
	}
	
	return 1
}

proc rename_exported_interface_ports {instance_name interface_name exported_interface_name} {

   
	set port_map [list]
	foreach port_name [get_instance_interface_ports $instance_name $interface_name] {
		lappend port_map $port_name
		lappend port_map $port_name
	}
	set_interface_property $exported_interface_name PORT_NAME_MAP $port_map
	return 1
}

proc composition_callback { } {
	ip_validate
	ip_compose
}

proc generate_example_design { name } {
	
	set family [get_parameter_value device_family]
	if {[string equal $family "Arria 10"]} {
	   set default_device "10AX115R3F40I3SGES"
	} else {
	   set default_device "10SX280N3F43E3VG"
	}   
	 
	
	set synth_qsys_name "ed_synth"
	set synth_qsys_file "${synth_qsys_name}.qsys"
	set synth_qsys_path [_create_and_get_temp_file_path $synth_qsys_file]
	
	set sim_qsys_name   "ed_sim"
	set sim_qsys_file   "${sim_qsys_name}.qsys"
	set sim_qsys_path   [_create_and_get_temp_file_path $sim_qsys_file]


	set params_file "params.tcl"
	set params_path [create_temp_file $params_file]
	set fh [open $params_path "w"]    

	puts $fh "# This file is auto-generated."
	puts $fh "# It is used by make_qii_design.tcl and make_sim_design.tcl, and"
	puts $fh "# is not intended to be executed directly."
	puts $fh ""

	foreach param_name [get_parameters] {
		set is_derived_param [get_parameter_property $param_name DERIVED]
		set param_val [get_parameter_value $param_name]
		if {$param_name != "device_family" && $is_derived_param != "1"} {
			puts $fh "set ip_params(${param_name}) \"${param_val}\""
		}
	}

	puts $fh "set pro_edition  [_is_pro_edition]"
	puts $fh "set device_family \"[get_parameter_value device_family]\""
	puts $fh "set gpio_name           \"$name\""
	puts $fh "set ed_params(DEFAULT_DEVICE)      \"$default_device\""
	puts $fh "set ed_params(SYNTH_QSYS_NAME)     \"$synth_qsys_name\""
	puts $fh "set ed_params(SIM_QSYS_NAME)       \"$sim_qsys_name\""
	puts $fh "set ed_params(TMP_SYNTH_QSYS_PATH) \"$synth_qsys_path\""
	puts $fh "set ed_params(TMP_SIM_QSYS_PATH)   \"$sim_qsys_path\""
	close $fh

	add_fileset_file $params_file OTHER PATH $params_path
	
	set make_qsys_file "make_qsys.tcl"

   	set qsys_script_exe_path "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-script"
   	set platform [lindex $::tcl_platform(platform) 0]
	if { [_is_pro_edition] } {
		set pro_string "--pro"
	} else {
		set pro_string ""
	}
	
	if { $platform == "windows" } {
		set cmd [concat [list exec $qsys_script_exe_path $pro_string --quartus-project=none --cmd="source $params_path" --script=ex_design/make_qsys.tcl]]
	} else {
		set cmd [concat [list exec $qsys_script_exe_path $pro_string --quartus-project=none --cmd='source $params_path' --script=ex_design/make_qsys.tcl]]
	}
	
	set cmd_fail [catch { eval $cmd } tempresult]
	add_fileset_file $synth_qsys_file OTHER PATH $synth_qsys_path
	add_fileset_file $sim_qsys_file OTHER PATH $sim_qsys_path
	
	if {[_is_pro_edition]} {
		set tmp_dir_path [create_temp_file ""]
		set ip_files [_ls_recursive "${tmp_dir_path}" "*.ip"]
		
		foreach path $ip_files {
			set file [_get_relative_path $tmp_dir_path $path]
			add_fileset_file $file OTHER PATH $path
		}
	}
	
	set file "make_qii_design.tcl"
	set path "ex_design/${file}"
	add_fileset_file $file OTHER PATH $path

	set file "make_sim_design.tcl"
	set path "ex_design/${file}"
	add_fileset_file $file OTHER PATH $path

	set file "readme.txt"
	set path "ex_design/${file}"
	add_fileset_file $file OTHER PATH $path
}

proc _is_pro_edition {} {

	if { [catch {is_qsys_edition QSYS_PRO} result] } {
		return 0
	} else {
		return $result
	}
}

proc _ls_recursive {base glob} {
	set files [list]

	foreach f [glob -nocomplain -types f -directory $base $glob] {
		set file_path [file join $base $f]
		lappend files $file_path
	}

	foreach d [glob -nocomplain -types d -directory $base *] {
		set files_recursive [_ls_recursive [file join $base $d] $glob]
		lappend files {*}$files_recursive
	}

	return $files
}

proc _get_relative_path {base path} {
	return [string trimleft [ string range $path [string length $base] [string length $path] ] "/"]
}

proc _create_and_get_temp_file_path { filename } {
	set qsys_path [create_temp_file $filename]
	set fh [open $qsys_path "w"] 
	close $fh
	return $qsys_path
}

add_documentation_link "User Guide" "https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/ug/ug_altera_gpio.pdf"
add_documentation_link "Release Notes" "https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408"
