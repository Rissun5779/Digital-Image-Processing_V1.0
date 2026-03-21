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


# THIS MODULE INTENDED FOR INTERNAL USE ONLY, FOR TEMPORARY WORKAROUNDS ETC...
lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/alt_xcvr_tcl_packages

package require -exact qsys 16.0
package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages

namespace import ::alt_xcvr::ip_tcl::ip_module::*
namespace import ::alt_xcvr::ip_tcl::messages::*

# Declare the module using a nested list. First list is header, second list is property values
set module {\
  {NAME                       VERSION           INTERNAL  VALIDATION_CALLBACK                  ELABORATION_CALLBACK                      DISPLAY_NAME            GROUP                                  AUTHOR              }\
  {alt_xcvr_if_terminator     18.1  true      alt_xcvr_if_terminator_val_callback  alt_xcvr_if_terminator_elab_callback      "Conduit terminator"    "Interface Protocols/Transceiver PHY"  "Altera Corporation"}\
}

# Declare the fileset using a nested list. First list is a header row.
set filesets {\
  {NAME            TYPE            CALLBACK               TOP_LEVEL }\
  {quartus_synth   QUARTUS_SYNTH   callback_quartus_synth alt_xcvr_if_terminator_top }\
  {sim_verilog     SIM_VERILOG     callback_sim_verilog   alt_xcvr_if_terminator_top }\
  {sim_vhdl        SIM_VHDL        callback_sim_vhdl      alt_xcvr_if_terminator_top }\
}

# Declare the parameters using a nested list. First list is a header row.
set parameters {\
  {NAME                 TYPE     DERIVED HDL_PARAMETER DEFAULT_VALUE ALLOWED_RANGES                                                         ENABLED VISIBLE  DISPLAY_NAME                  DISPLAY_HINT   VALIDATION_CALLBACK          DESCRIPTION     }\
  {design_environment   STRING   false   false         "QSYS"        NOVAL                                                                  true    false    "Design Environment"          NOVAL           NOVAL                       "Design environment must be set to QSYS"}\
  {port_width           INTEGER  false   true          1             NOVAL                                                                  true    true     "Port Width"                  NOVAL           NOVAL                       "TBD"}\
  {termination_value    INTEGER  false   true          0             {0 1}                                                                  true    true     "Termination Value"           NOVAL           NOVAL                       "TBD"}\
 }

# Declare the ports and interfaces using a nested list. First list is a header row.
set interfaces {\
  {NAME              DIRECTION UI_DIRECTION WIDTH_EXPR     ROLE             TERMINATION TERMINATION_VALUE IFACE_NAME       IFACE_TYPE IFACE_DIRECTION DYNAMIC SPLIT                 SPLIT_WIDTH SPLIT_COUNT ELABORATION_CALLBACK }\
  {port_o            output    output       port_width*1   port_o           false       NOVAL             port_o           conduit    end             false   NOVAL                 NOVAL       NOVAL       NOVAL }\
}

# Declare the modules properties to the framework
ip_declare_module $module
# Declare the fileset properties to the framework
ip_declare_filesets $filesets
# Declare the parameters and properties to the framework
ip_declare_parameters $parameters
# Declare the interfaces and properties to the framework
ip_declare_interfaces $interfaces

ip_set "parameter.design_environment.SYSTEM_INFO" DESIGN_ENVIRONMENT

##############################################################################################
proc alt_xcvr_if_terminator_val_callback {} {  
  ip_validate_parameters
}
##############################################################################################

proc alt_xcvr_if_terminator_elab_callback {} {         
  ip_elaborate_interfaces
}

##############################################################################################
proc callback_quartus_synth { entity } {
  add_fileset_file ./alt_xcvr_if_terminator_top.v VERILOG PATH ./alt_xcvr_if_terminator_top.v
}

proc callback_sim_verilog { entity } {
  add_fileset_file ./alt_xcvr_if_terminator_top.v VERILOG PATH ./alt_xcvr_if_terminator_top.v
}

proc callback_sim_vhdl { entity } {
  add_fileset_file ./alt_xcvr_if_terminator_top.v VERILOG PATH ./alt_xcvr_if_terminator_top.v
}
