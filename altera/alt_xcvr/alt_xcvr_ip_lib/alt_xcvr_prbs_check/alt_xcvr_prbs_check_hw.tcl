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
package require alt_xcvr::ip_tcl::ip_interfaces
package require alt_xcvr::ip_tcl::messages

namespace import ::alt_xcvr::ip_tcl::ip_module::*
namespace import ::alt_xcvr::ip_tcl::ip_interfaces::*
namespace import ::alt_xcvr::ip_tcl::messages::*

# Declare the module using a nested list. First list is header, second list is property values
set module {\
  {NAME                   VERSION INTERNAL   VALIDATION_CALLBACK                 ELABORATION_CALLBACK                 DISPLAY_NAME       GROUP                                   AUTHOR            }\
  {alt_xcvr_prbs_check    14.0    true       alt_xcvr_prbs_check_val_callback    alt_xcvr_prbs_check_elab_callback    "PRBS Checker"     "Interface Protocols/Transceiver PHY"   "Altera Corporation"}\
}


# Declare the fileset using a nested list. First list is a header row.
set filesets {\
  {NAME            TYPE            CALLBACK                TOP_LEVEL     }\
  {quartus_synth   QUARTUS_SYNTH   callback_quartus_synth  alt_xcvr_prbs_check_top}\
  {sim_verilog     SIM_VERILOG     callback_sim_verilog    alt_xcvr_prbs_check_top}\
  {sim_vhdl        SIM_VHDL        callback_sim_vhdl       alt_xcvr_prbs_check_top}\
}


# Declare the parameters using a nested list. First list is a header row.
set parameters {\
  {NAME                 TYPE     DERIVED HDL_PARAMETER DEFAULT_VALUE ALLOWED_RANGES ENABLED       VISIBLE}\
  {design_environment   STRING   false   false         "QSYS"        NOVAL          true          false}\
  {NUM_CYCLES_FOR_LOCK  integer  false   true          31            NOVAL          true          true}\
  {PRBS_INITIAL_VALUE   integer  false   true          97            NOVAL          true          true}\
  {DATA_WIDTH           integer  false   true          10            NOVAL          true          true}\
  {PRBS                 integer  false   true          23            NOVAL          true          true}\
  {PIPELINE             integer  false   true          3             NOVAL          true          true}\
  {CHANNELS             integer  false   true          1             NOVAL          true          true}\
  {gui_split_interfaces integer  false   false         0             NOVAL          true          true}\
}

# Declare the ports and interfaces using a nested list. First list is a header row.
set ports {\
 {NAME             DIRECTION UI_DIRECTION  WIDTH_EXPR              ROLE                TERMINATION      TERMINATION_VALUE  IFACE_NAME     IFACE_TYPE          IFACE_DIRECTION DYNAMIC  SPLIT                  SPLIT_WIDTH    SPLIT_COUNT   ELABORATION_CALLBACK }\
 {clk              input     input         CHANNELS                clk                 false            NOVAL              clk            clock               sink            true     gui_split_interfaces   1              CHANNELS      NOVAL}\
 {reset            input     input         CHANNELS                reset               false            NOVAL              reset          reset               sink            true     gui_split_interfaces   1              CHANNELS      elaborate_interfaces}\
 {start            input     input         CHANNELS                conduit             false            NOVAL              start          conduit             end             true     gui_split_interfaces   1              CHANNELS      NOVAL}\
 {data_in          input     input         CHANNELS*DATA_WIDTH     rx_parallel_data    false            NOVAL              data_in        conduit             end             true     gui_split_interfaces   DATA_WIDTH     CHANNELS      NOVAL}\
 {lock             output    output        CHANNELS                conduit             false            NOVAL              lock           conduit             end             true     gui_split_interfaces   1              CHANNELS      NOVAL}\
 {error_flag       output    output        CHANNELS                conduit             false            NOVAL              error_flag     conduit             end             true     gui_split_interfaces   1              CHANNELS      NOVAL}\
}


ip_declare_module $module
ip_declare_filesets $filesets
ip_declare_parameters $parameters
ip_set_auto_conduit_in_native_mode 1
ip_set_iface_split_suffix "_ch"
ip_declare_interfaces $ports

proc elaborate_interfaces { PROP_IFACE_SPLIT_INDEX PROP_IFACE_NAME design_environment gui_split_interfaces CHANNELS DATA_WIDTH} {
    set channels [expr {$gui_split_interfaces ? 1 : $CHANNELS}]
    set sfx [expr {$gui_split_interfaces ? "_ch${PROP_IFACE_SPLIT_INDEX}" : ""}]
    set add_offset [expr 1 * $PROP_IFACE_SPLIT_INDEX]
  
    if { $design_environment != "NATIVE" } {
    set clk "clk"
    set reset "reset"
    if {$gui_split_interfaces} {
      regsub {.*(_ch.*)} $PROP_IFACE_NAME {clk\1} clk  
      regsub {.*(_ch.*)} $PROP_IFACE_NAME {reset\1} reset  
    }
    ip_set "interface.${PROP_IFACE_NAME}.associatedclock" $clk
  }
}

proc alt_xcvr_prbs_check_val_callback {} {  
  ip_validate_parameters
}

proc alt_xcvr_prbs_check_elab_callback {} {  
  ip_elaborate_interfaces
}

proc callback_quartus_synth { entity } {
  add_fileset_file ./alt_xcvr_prbs_check_top.v VERILOG PATH ./alt_xcvr_prbs_check_top.v
  add_fileset_file ./alt_xcvr_prbs_check.v VERILOG PATH ./alt_xcvr_prbs_check.v
  add_fileset_file ./prbs_poly.v VERILOG PATH ./alt_xcvr_prbs_poly.v
}

proc callback_sim_verilog { entity } {
  add_fileset_file ./alt_xcvr_prbs_check_top.v VERILOG PATH ./alt_xcvr_prbs_check_top.v
  add_fileset_file ./alt_xcvr_prbs_check.v VERILOG PATH ./alt_xcvr_prbs_check.v
  add_fileset_file ./prbs_poly.v VERILOG PATH ./alt_xcvr_prbs_poly.v
}

proc callback_sim_vhdl { entity } {
  add_fileset_file ./alt_xcvr_prbs_check_top.v VERILOG PATH ./alt_xcvr_prbs_check_top.v
  add_fileset_file ./alt_xcvr_prbs_check.v VERILOG PATH ./alt_xcvr_prbs_check.v
  add_fileset_file ./prbs_poly.v VERILOG PATH ./alt_xcvr_prbs_poly.v
}
