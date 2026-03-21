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

package require -exact qsys 15.0

package require altera_emif::ip_top::exports
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::device_family
package require altera_emif::ip_mem_model::ip_top::main

load_strings common_messages.properties
load_strings common_gui.properties
load_strings common_params.properties
load_strings common_ports.properties
load_strings messages.properties
load_strings gui.properties

set_module_property DESCRIPTION [get_string HWTCL_MODULE_DESCRIPTION]
set_module_property NAME altera_emif_mem_model
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP [get_string INTERNAL_COMPONENT_ROOT_FOLDER]
set_module_property AUTHOR [get_string AUTHOR]
set_module_property DISPLAY_NAME [get_string HWTCL_MODULE_DISPLAY_NAME]
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property DATASHEET_URL [get_string DATASHEET_URL]
set_module_property SUPPORTED_DEVICE_FAMILIES [::altera_emif::util::device_family::get_qsys_supported_families]
set_module_property COMPOSITION_CALLBACK ::altera_emif::ip_mem_model::ip_top::main::composition_callback

::altera_emif::ip_top::exports::inherit_top_level_parameter_defs

add_display_item "" QSYS_GUI_FOR_INTERNAL_COMPONENTS_TEXT TEXT [get_string QSYS_GUI_FOR_INTERNAL_COMPONENTS_DESC]
