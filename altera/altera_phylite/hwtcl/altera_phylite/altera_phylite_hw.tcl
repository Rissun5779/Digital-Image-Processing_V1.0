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

set altera_phylite_tcl_libs_dir "$env(QUARTUS_ROOTDIR)/../ip/altera/altera_phylite/util"
if {[lsearch -exact $auto_path $altera_phylite_tcl_libs_dir] == -1} {
   lappend auto_path $altera_phylite_tcl_libs_dir
}

lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/alt_xcvr_tcl_packages
lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/altera_iopll_common
lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/alt_xcvr_core/nf


package require -exact qsys 15.0

package require altera_emif::util::device_family
package require altera_phylite::ip_top::main
package require altera_phylite::ip_top::ex_design

load_strings common_messages.properties
load_strings common_gui.properties
load_strings messages.properties
load_strings gui.properties

set_module_property DESCRIPTION [get_string HWTCL_MODULE_DESCRIPTION]
set_module_property NAME altera_phylite
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP [get_string COMPONENT_ROOT_FOLDER]
set_module_property AUTHOR [get_string AUTHOR]
set_module_property DISPLAY_NAME [get_string HWTCL_MODULE_DISPLAY_NAME]
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property HIDE_FROM_QSYS true
set_module_property HIDE_FROM_SOPC true

set_module_property EDITABLE true

set_module_property DATASHEET_URL [get_string DATASHEET_URL]

set_module_property SUPPORTED_DEVICE_FAMILIES [list ARRIA10]

set ::altera_emif::util::device_family::m_family_enum FAMILY_ARRIA10

set_module_property SUPPRESS_WARNINGS NO_PORTS_AFTER_ELABORATION

set_module_property COMPOSITION_CALLBACK ::altera_phylite::ip_top::main::composition_callback
add_fileset example_design EXAMPLE_DESIGN ::altera_phylite::ip_top::ex_design::example_design_fileset_callback

set_module_property PARAMETER_UPGRADE_CALLBACK ::altera_phylite::ip_top::main::parameter_upgrade_callback

::altera_phylite::ip_top::main::create_parameters
::altera_phylite::ip_top::main::add_display_items


add_documentation_link "User Guide" "https://documentation.altera.com/#/link/bhc1410942178562/bhc1410941851660"
add_documentation_link "Release Notes" "https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408"
