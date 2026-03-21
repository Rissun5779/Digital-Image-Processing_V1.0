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
  {NAME                 VERSION INTERNAL   VALIDATION_CALLBACK               ELABORATION_CALLBACK               DISPLAY_NAME                       GROUP                                 AUTHOR              }\
  {alt_xcvr_prbs_gen    14.0    true       alt_xcvr_prbs_gen_val_callback    alt_xcvr_prbs_gen_elab_callback    "Design Example PRBS Generator"    "Interface Protocols/Transceiver PHY" "Altera Corporation"}\
}


# Declare the fileset using a nested list. First list is a header row.
set filesets {\
  {NAME            TYPE            CALLBACK                TOP_LEVEL     }\
  {quartus_synth   QUARTUS_SYNTH   callback_quartus_synth  alt_xcvr_prbs_gen_top}\
  {sim_verilog     SIM_VERILOG     callback_sim_verilog    alt_xcvr_prbs_gen_top}\
  {sim_vhdl        SIM_VHDL        callback_sim_vhdl       alt_xcvr_prbs_gen_top}\
}


# Declare the parameters using a nested list. First list is a header row.
set parameters {\
  {NAME                 TYPE     DERIVED HDL_PARAMETER DEFAULT_VALUE ALLOWED_RANGES ENABLED       VISIBLE}\
  {design_environment   STRING   false   false         "QSYS"        NOVAL          true          false}\
  {PRBS_INITIAL_VALUE   integer  false   true          97            NOVAL          true          true}\
  {DATA_WIDTH           integer  false   true          10            NOVAL          true          true}\
  {PRBS                 integer  false   true          23            NOVAL          true          true}\
  {XAUI_PATTERN         integer  false   true          97            NOVAL          true          true}\
  {CHANNELS             integer  false   true          1             NOVAL          true          true}\
  {gui_split_interfaces integer  false   false         0             NOVAL          true          true}\
}

# Declare the ports and interfaces using a nested list. First list is a header row.
set ports {\
 {NAME         DIRECTION UI_DIRECTION  WIDTH_EXPR               ROLE                TERMINATION      TERMINATION_VALUE  IFACE_NAME     IFACE_TYPE      IFACE_DIRECTION DYNAMIC  SPLIT                  SPLIT_WIDTH    SPLIT_COUNT   ELABORATION_CALLBACK }\
 {clk          input     input         1                        clk                 false            NOVAL              clk            clock           sink            true     gui_split_interfaces   1              CHANNELS      NOVAL}\
 {reset        input     input         1                        reset               false            NOVAL              reset          reset           sink            true     gui_split_interfaces   1              CHANNELS      elaborate_interfaces}\
 {start        input     input         1                        conduit             false            NOVAL              start          conduit         sink            true     gui_split_interfaces   1              CHANNELS      NOVAL}\
 {insert_error input     input         1                        conduit             false            NOVAL              insert_error   conduit         end             true     gui_split_interfaces   1              CHANNELS      NOVAL}\
 {pause        input     input         1                        conduit             false            NOVAL              pause          conduit         end             true     gui_split_interfaces   1              CHANNELS      NOVAL}\
 {dout         output    output        CHANNELS*DATA_WIDTH      tx_parallel_data    false            NOVAL              dout           conduit         end             true     gui_split_interfaces   DATA_WIDTH     CHANNELS      NOVAL}\
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
    #                            condition             pname                src_port        dir    channels  sing_ch_width  grp_width   words       width         offset used     add_offset  
    #create_fragmented_interface  $gui_split_interfaces "clk${sfx}"          "clk"           input  $channels 1              1           1           1             0      used     $add_offset
    #create_fragmented_interface  $gui_split_interfaces "reset${sfx}"        "reset"         input  $channels 1              1           1           1             0      used     $add_offset
  
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

proc alt_xcvr_prbs_gen_val_callback {} {  
  ip_validate_parameters
}

proc alt_xcvr_prbs_gen_elab_callback {} {
  ip_elaborate_interfaces
}

proc elaborate_nreset {} {
  ip_set "interface.nreset.synchronousEdges" none
}

proc elaborate_reset {} {
  ip_set "interface.reset.synchronousEdges" none
}

proc callback_quartus_synth { entity } {
  add_fileset_file ./alt_xcvr_prbs_gen_top.v VERILOG PATH ./alt_xcvr_prbs_gen_top.v
  add_fileset_file ./alt_xcvr_prbs_gen.v VERILOG PATH ./alt_xcvr_prbs_gen.v
  add_fileset_file ./prbs_poly.v VERILOG PATH ./alt_xcvr_prbs_poly.v
}

proc callback_sim_verilog { entity } {
  add_fileset_file ./alt_xcvr_prbs_gen_top.v VERILOG PATH ./alt_xcvr_prbs_gen_top.v
  add_fileset_file ./alt_xcvr_prbs_gen.v VERILOG PATH ./alt_xcvr_prbs_gen.v
  add_fileset_file ./prbs_poly.v VERILOG PATH ./alt_xcvr_prbs_poly.v
}

proc callback_sim_vhdl { entity } {
  add_fileset_file ./alt_xcvr_prbs_gen_top.v VERILOG PATH ./alt_xcvr_prbs_gen_top.v
  add_fileset_file ./alt_xcvr_prbs_gen.v VERILOG PATH ./alt_xcvr_prbs_gen.v
  add_fileset_file ./prbs_poly.v VERILOG PATH ./alt_xcvr_prbs_poly.v
}
