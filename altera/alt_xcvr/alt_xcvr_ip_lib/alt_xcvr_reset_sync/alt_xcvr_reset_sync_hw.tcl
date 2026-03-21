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

package require -exact qsys 14.0
package require -exact alt_xcvr::ip_tcl::ip_module 13.0
package require alt_xcvr::ip_tcl::messages

namespace import ::alt_xcvr::ip_tcl::ip_module::*
namespace import ::alt_xcvr::ip_tcl::messages::*

# Declare the module using a nested list. First list is header, second list is property values
set module {\
  {NAME                VERSION INTERNAL VALIDATION_CALLBACK                 ELABORATION_CALLBACK                DISPLAY_NAME                         GROUP                                  AUTHOR            }\
  {alt_xcvr_reset_sync 14.0    true    alt_xcvr_reset_sync_val_callback    alt_xcvr_reset_sync_elab_callback   "Reset Synchronizer"                 "Interface Protocols/Transceiver PHY"  "Altera Corporation"}\
}


# Declare the fileset using a nested list. First list is a header row.
set filesets {\
  {NAME            TYPE            CALLBACK                TOP_LEVEL }\
  {quartus_synth   QUARTUS_SYNTH   callback_quartus_synth  alt_xcvr_reset_sync}\
  {sim_verilog     SIM_VERILOG     callback_sim_verilog    alt_xcvr_reset_sync}\
  {sim_vhdl        SIM_VHDL        callback_sim_vhdl       alt_xcvr_reset_sync}\
}


# Declare the parameters using a nested list. First list is a header row.
set parameters {\
  {NAME           TYPE    DERIVED HDL_PARAMETER DEFAULT_VALUE ALLOWED_RANGES ENABLED       VISIBLE}\
  {CLKS_PER_SEC  integer  false   true          25000000      NOVAL          true          true   }\
  {RESET_PER_NS  integer  false   true          1000000       NOVAL          true          true   }\
}

# Declare the ports and interfaces using a nested list. First list is a header row.
set ports {\
 {NAME        DIRECTION WIDTH_EXPR    ROLE        IFACE_NAME IFACE_TYPE IFACE_DIRECTION TERMINATION ELABORATION_CALLBACK}\
 {clk         input     1             clk         clk        clock      sink            false       NOVAL     }\
 {reset_req   input     1             reset       reset_req  reset      sink            false       elaborate_reset_req}\
 {reset       output    1             reset       reset      reset      source          false       elaborate_reset}\
 {reset_n     output    1             reset       reset_n    reset      source          false       elaborate_reset_n}\
}


# Declare the modules properties to the framework
ip_declare_module $module
# Declare the fileset properties to the framework
ip_declare_filesets $filesets
# Declare the parameters and properties to the framework
ip_declare_parameters $parameters
# Declare the ports and interfaces with their properties to the framework
ip_declare_interfaces $ports

proc alt_xcvr_reset_sync_val_callback {} {
  ip_validate_parameters
}

proc alt_xcvr_reset_sync_elab_callback {} {
  ip_elaborate_interfaces
}

proc elaborate_reset_req {} {
  ip_set "interface.reset_req.synchronousEdges" none
}

proc elaborate_reset {} {
  ip_set "interface.reset.associatedclock" clk
}

proc elaborate_reset_n {} {
  ip_set "interface.reset_n.associatedclock" clk
  ip_set "interface.reset_n.synchronousEdges" none
}

proc elaborate_my_avmm {} {
  ip_set "interface.my_avmm.associatedclock" clock
}

proc callback_quartus_synth { entity } {
  add_fileset_file ./alt_xcvr_reset_sync.v VERILOG PATH ./alt_xcvr_reset_sync.v
}

proc callback_sim_verilog { entity } {
  add_fileset_file ./alt_xcvr_reset_sync.v VERILOG PATH ./alt_xcvr_reset_sync.v
}

proc callback_sim_vhdl { entity } {
  add_fileset_file ./alt_xcvr_reset_sync.v VERILOG PATH ./alt_xcvr_reset_sync.v
}
