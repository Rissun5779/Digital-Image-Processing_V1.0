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
  {NAME         VERSION INTERNAL VALIDATION_CALLBACK        ELABORATION_CALLBACK       DISPLAY_NAME                     GROUP                                 AUTHOR            }\
  {byte_order   14.0    true   byte_order_val_callback    byte_order_elab_callback   "Design Example Byte Order"      "Interface Protocols/Transceiver PHY" "Altera Corporation"}\
}


# Declare the fileset using a nested list. First list is a header row.
set filesets {\
  {NAME            TYPE            CALLBACK                TOP_LEVEL     }\
  {quartus_synth   QUARTUS_SYNTH   callback_quartus_synth  byte_order_top}\
  {sim_verilog     SIM_VERILOG     callback_sim_verilog    byte_order_top}\
  {sim_vhdl        SIM_VHDL        callback_sim_vhdl       byte_order_top}\
}


# Declare the parameters using a nested list. First list is a header row.
set parameters {\
  {NAME                 TYPE     DERIVED HDL_PARAMETER  DEFAULT_VALUE ALLOWED_RANGES ENABLED       VISIBLE}\
  {design_environment   STRING   false   false          "QSYS"         NOVAL          true          false}\
  {ALIGN_BYTE           integer  false   true           188            NOVAL          true          true}\
  {PLD_PCS_WIDTH        integer  false   true           16             NOVAL          true          true}\
  {PMA_PCS_WIDTH        integer  false   true           8              NOVAL          true          true}\
  {SER_FACTOR           integer  false   true           2              NOVAL          true          true}\
  {CHANNELS             integer  false   true           1              NOVAL          true          true}\
  {gui_split_interfaces integer  false   false          0              NOVAL          true          true}\
}

# Declare the ports and interfaces using a nested list. First list is a header row.
set ports {\
 {NAME                         DIRECTION WIDTH_EXPR             ROLE        IFACE_NAME         DYNAMIC SPLIT                   SPLIT_WIDTH         SPLIT_COUNT     IFACE_TYPE IFACE_DIRECTION TERMINATION ELABORATION_CALLBACK}\
 {clk                          input     CHANNELS               clk         clk                true    gui_split_interfaces    1                   CHANNELS        clock      sink            false       NOVAL     }\
 {reset                        input     CHANNELS               reset       reset              true    gui_split_interfaces    1                   CHANNELS        reset      sink            false       elaborate_interfaces}\
 {rx_syncstatus                input     CHANNELS               conduit     rx_syncstatus      true    gui_split_interfaces    1                   CHANNELS        conduit    end             false       NOVAL}\
 {parallel_data_in             input     PLD_PCS_WIDTH*CHANNELS conduit     parallel_data_in   true    gui_split_interfaces    PLD_PCS_WIDTH       CHANNELS        conduit    end             false       NOVAL}\
 {parallel_data_out            output    PLD_PCS_WIDTH*CHANNELS conduit     parallel_data_out  true    gui_split_interfaces    PLD_PCS_WIDTH       CHANNELS        conduit    end             false       NOVAL}\
 {byte_order_aligned           output    CHANNELS               conduit     byte_order_aligned true    gui_split_interfaces    1                   CHANNELS        conduit    end             false       NOVAL}\
}                                                                                          


ip_declare_module $module
ip_declare_filesets $filesets
ip_declare_parameters $parameters
ip_declare_interfaces $ports
ip_set_iface_split_suffix "_ch"
ip_declare_interfaces $ports


proc elaborate_interfaces { PROP_IFACE_SPLIT_INDEX PROP_IFACE_NAME design_environment gui_split_interfaces CHANNELS } {
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
    #ip_set "interface.${PROP_IFACE_NAME}.associatedclock" $clk
    ip_set "interface.${PROP_IFACE_NAME}.synchronousEdges" none
    set properties [get_interface_properties ${PROP_IFACE_NAME}]
    #puts "properties are $properties"
  }
}

proc byte_order_val_callback {} {
  ip_validate_parameters
}

proc byte_order_elab_callback {} {
  ip_elaborate_interfaces
}

proc elaborate_reset {} {
  ip_set "interface.reset.synchronousEdges" none
}

proc callback_quartus_synth { entity } {
  add_fileset_file ./byte_order_top.v VERILOG PATH ./byte_order_top.v
  add_fileset_file ./byte_order.v VERILOG PATH ./byte_order.v
}

proc callback_sim_verilog { entity } {
  add_fileset_file ./byte_order_top.v VERILOG PATH ./byte_order_top.v
  add_fileset_file ./byte_order.v VERILOG PATH ./byte_order.v
}

proc callback_sim_vhdl { entity } {
  add_fileset_file ./byte_order_top.v VERILOG PATH ./byte_order_top.v
  add_fileset_file ./byte_order.v VERILOG PATH ./byte_order.v
}
