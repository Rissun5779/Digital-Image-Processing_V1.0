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


lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/alt_xcvr_tcl_packages

package require -exact qsys 16.0
package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages

namespace import ::alt_xcvr::ip_tcl::ip_module::*
namespace import ::alt_xcvr::ip_tcl::messages::*

# Declare the module using a nested list. First list is header, second list is property values
set module {\
  {NAME                   VERSION           INTERNAL  VALIDATION_CALLBACK                ELABORATION_CALLBACK                DISPLAY_NAME        GROUP                                  AUTHOR              }\
  {alt_xcvr_if_fanout     18.1  true      alt_xcvr_if_fanout_val_callback  alt_xcvr_if_fanout_elab_callback      "Conduit Fanout"    "Interface Protocols/Transceiver PHY"  "Altera Corporation"}\
}

# Declare the fileset using a nested list. First list is a header row.
set filesets {\
  {NAME            TYPE            CALLBACK               TOP_LEVEL }\
  {quartus_synth   QUARTUS_SYNTH   callback_quartus_synth alt_xcvr_if_fanout_top }\
  {sim_verilog     SIM_VERILOG     callback_sim_verilog   alt_xcvr_if_fanout_top }\
  {sim_vhdl        SIM_VHDL        callback_sim_vhdl      alt_xcvr_if_fanout_top }\
}

# Declare the parameters using a nested list. First list is a header row.
set parameters {\
  {NAME                 TYPE     DERIVED HDL_PARAMETER DEFAULT_VALUE ALLOWED_RANGES                                                         ENABLED VISIBLE  DISPLAY_NAME                  DISPLAY_HINT   VALIDATION_CALLBACK          DESCRIPTION     }\
  {design_environment   STRING   false   false         "QSYS"        NOVAL                                                                  true    false    "Design Environment"          NOVAL           NOVAL                       "Design environment must be set to QSYS"}\
  {port_width           INTEGER  false   true          1             NOVAL                                                                  true    true     "Port Width"                  NOVAL           NOVAL                        "all-ports - what to do about clock reset etc and split ports"}\
  \
  {i_role               STRING   false   false         "type_role"   NOVAL                                                                  true    true     "Input interface role"        NOVAL           NOVAL                       "Specifies the role of the adapter input interface"}\
  {i_iface_type         STRING   false   false         "conduit"     {"conduit" "clock" "reset" "hssi_serial_clock" "hssi_bonded_clock"}    true    true     "Input interface type"        NOVAL           NOVAL                       "Specifies the type of the adapter input interface"}\
  {i_iface_direction    STRING   true    false         "end"         {"end" "sink"}                                                         true    true     "Input interface direction"   NOVAL           validate_i_iface_direction  "Specifies the direction of the adapter input interface"    }\
  \
  {num_bcast_outputs    integer  false   true          2             NOVAL                                                                  true    true     "Number of broadcast outputs" NOVAL           validate_num_bcast_outputs  "If the input interface must be broadcast to one or more output interfaces, this field specifies the number of broadcast output interfaces." }\
  \
  {o_role               STRING   true    false         "UnknownRole" NOVAL                                                                  true    true     "Output interface role"       NOVAL           validate_o_role             "Specifies the role of the adapter output interface"   }\
  {o_iface_type         STRING   true    false         "conduit"     {"conduit" "clock" "reset" "hssi_serial_clock" "hssi_bonded_clock"}    true    true     "Output interface type"       NOVAL           validate_o_iface_type       "Specifies the type of the adapter output interface"    }\
  {o_iface_direction    STRING   true    false         "end"         {"end" "source"}                                                       true    true     "Output interface direction"  NOVAL           validate_o_iface_direction  "Specifies the direction of the adapter output interface"   }\
 }

# Declare the modules properties to the framework
ip_declare_module $module
# Declare the fileset properties to the framework
ip_declare_filesets $filesets
# Declare the parameters and properties to the framework
ip_declare_parameters $parameters

ip_set "parameter.design_environment.SYSTEM_INFO" DESIGN_ENVIRONMENT

##############################################################################################
proc alt_xcvr_if_fanout_val_callback {} {  
  ip_validate_parameters
}

proc validate_num_bcast_outputs {PROP_NAME PROP_VALUE} {
  if {$PROP_VALUE<0} {
    ip_message error "${PROP_NAME}(${PROP_VALUE}) should be a positive value!"   
  }
}

proc validate_i_iface_direction { PROP_NAME i_iface_type } {
    set direction "end"
    if { $i_iface_type=="conduit" } {
        set direction  "end"
    } elseif { $i_iface_type=="clock"  || $i_iface_type=="hssi_serial_clock" || $i_iface_type=="hssi_bonded_clock" } {
        set direction  "sink"
    } elseif { $i_iface_type=="reset" } {
        set direction  "sink"
    }
    ip_set "parameter.${PROP_NAME}.value" ${direction}
}

proc validate_o_iface_direction { PROP_NAME o_iface_type } {    
    set direction "end"
    if { $o_iface_type=="conduit" } {
        set direction "end"
    } elseif { $o_iface_type=="clock"  || $o_iface_type=="hssi_serial_clock" || $o_iface_type=="hssi_bonded_clock" } {
        set direction "source"
    } elseif { $o_iface_type=="reset" } {
        set direction "source"
    }
    ip_set "parameter.${PROP_NAME}.value" ${direction}
}

proc validate_o_iface_type { PROP_NAME PROP_VALUE i_iface_type} {
   ip_set "parameter.$PROP_NAME.value" $i_iface_type
}

proc validate_o_role { PROP_NAME PROP_VALUE i_role} {
   ip_set "parameter.$PROP_NAME.value" $i_role
}

##############################################################################################

proc alt_xcvr_if_fanout_elab_callback {} {
  add_interface       port_i          [ip_get "parameter.i_iface_type.value"] [ip_get "parameter.i_iface_direction.value"] 
  add_interface_port  port_i port_i   [ip_get "parameter.i_role.value"] input [ip_get "parameter.port_width.value"]
  ip_set "interface.port_i.assignment" [list "ui.blockdiagram.direction" input]
  if {[ip_get "parameter.i_iface_type.value"] == "reset"} {
    set_interface_property "port_i" synchronousEdges NONE
  }    
  for {set output_index 0} {$output_index < [ip_get "parameter.num_bcast_outputs.value"]} {incr output_index} {
    add_interface       "port_o${output_index}"   [ip_get "parameter.o_iface_type.value"]  [ip_get "parameter.o_iface_direction.value"] 
    add_interface_port  "port_o${output_index}"   "port_o${output_index}"                  [ip_get "parameter.o_role.value"] output [ip_get "parameter.port_width.value"]
    ip_set "port.port_o${output_index}.TERMINATION" 0
    ip_set "interface.port_o${output_index}.assignment" [list "ui.blockdiagram.direction" output]
    if {[ip_get "parameter.o_iface_type.value"] == "reset"} {
      set_interface_property "port_o${output_index}" synchronousEdges NONE
    }
    set f_list ""
    set upper_index [expr {[ip_get "parameter.port_width.value"]*(${output_index}+1)-1}]
    set lower_index [expr {$upper_index-[ip_get "parameter.port_width.value"]}]
    for {set index $upper_index}  {$index>$lower_index} {incr index -1} {
      set f_list [linsert $f_list end "port_o@${index}"]
    }
    #set_port_property "port_o${output_index}" FRAGMENT_LIST ${f_list}
    ip_set "port.port_o${output_index}.FRAGMENT_LIST" ${f_list}
  }
   
  ip_elaborate_interfaces
}

##############################################################################################
proc callback_quartus_synth { entity } {
  add_fileset_file ./alt_xcvr_if_fanout_top.v VERILOG PATH ./alt_xcvr_if_fanout_top.v
}

proc callback_sim_verilog { entity } {
  add_fileset_file ./alt_xcvr_if_fanout_top.v VERILOG PATH ./alt_xcvr_if_fanout_top.v
}

proc callback_sim_vhdl { entity } {
  add_fileset_file ./alt_xcvr_if_fanout_top.v VERILOG PATH ./alt_xcvr_if_fanout_top.v
}
