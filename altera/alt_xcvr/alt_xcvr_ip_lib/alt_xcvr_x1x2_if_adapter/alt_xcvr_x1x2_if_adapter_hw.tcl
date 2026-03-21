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
package require alt_xcvr::ip_tcl::ip_interfaces
package require alt_xcvr::ip_tcl::messages

namespace import ::alt_xcvr::ip_tcl::ip_module::*
namespace import ::alt_xcvr::ip_tcl::ip_interfaces::*
namespace import ::alt_xcvr::ip_tcl::messages::*

# This module is used as an adapter between the data generator/checker and the native phy during double transfer rate mode
# Maps the simplified output/input of the generator/checker to the unsimplified interface for native phy
# Currently only designed for PCS Direct mode, will need to modify later for Standard and Enhanced
                                                                                                                                                                                                      
# Declare the module using a nested list. First list is header, second list is property values
set module {\
  {NAME                         VERSION             INTERNAL   VALIDATION_CALLBACK                          ELABORATION_CALLBACK                            DISPLAY_NAME                                            GROUP                                   AUTHOR            }\
  {alt_xcvr_x1x2_if_adapter     18.1    true       alt_xcvr_x1x2_if_adapter_val_callback        alt_xcvr_x1x2_if_adapter_elab_callback          "Design Example Double-Rate Mode Interface Adapter"     "Interface Protocols/Transceiver PHY"   "Altera Corporation"}\
}


# Declare the fileset using a nested list. First list is a header row.
set filesets {\
  {NAME            TYPE            CALLBACK                TOP_LEVEL     }\
  {quartus_synth   QUARTUS_SYNTH   callback_quartus_synth  alt_xcvr_x1x2_if_adapter_top}\
  {sim_verilog     SIM_VERILOG     callback_sim_verilog    alt_xcvr_x1x2_if_adapter_top}\
  {sim_vhdl        SIM_VHDL        callback_sim_vhdl       alt_xcvr_x1x2_if_adapter_top}\
}


# Declare the parameters using a nested list. First list is a header row.
set parameters {\
  {NAME                         TYPE     DERIVED HDL_PARAMETER DEFAULT_VALUE ALLOWED_RANGES             DISPLAY_HINT    ENABLED       VISIBLE}\
  {design_environment           STRING   false   false         "QSYS"        NOVAL                      NOVAL           true          false}\
  {WIDTH                        integer  false   true          32            {8 10 16 20 32}            NOVAL           true          true}\
  {CHANNELS                     integer  false   true          1             NOVAL                      NOVAL           true          true}\
  {BASIC_TX_FIFO_MODE_EN        integer  false   true          0             {0 1}                      NOVAL           true          true}\
  {gui_split_interfaces         integer  false   false         0             NOVAL                      NOVAL           true          true}\
}

# Declare the ports and interfaces using a nested list. First list is a header row.
set interfaces {\
 {NAME                          DIRECTION  UI_DIRECTION  WIDTH_EXPR      ROLE                    TERMINATION                    TERMINATION_VALUE  IFACE_NAME            IFACE_TYPE        IFACE_DIRECTION  DYNAMIC  SPLIT                   SPLIT_WIDTH         SPLIT_COUNT   ELABORATION_CALLBACK }\
 {tx_clkout                     input      input         CHANNELS        clk                     false                          NOVAL              tx_clkout             clock             sink             true     gui_split_interfaces    1                   CHANNELS      NOVAL}\
 {tx_digitalreset               input      input         CHANNELS        tx_digitalreset         false                          NOVAL              tx_digitalreset       conduit           end              true     gui_split_interfaces    1                   CHANNELS      NOVAL}\
 {tx_fifo_wr_en                 input      input         CHANNELS        conduit                 "!BASIC_TX_FIFO_MODE_EN"       NOVAL              tx_fifo_wr_en         conduit           end              true     gui_split_interfaces    1                   CHANNELS      NOVAL}\
 {gen_data_out                  input      input         CHANNELS*WIDTH  tx_parallel_data        false                          NOVAL              gen_data_out          conduit           end              true     gui_split_interfaces    WIDTH               CHANNELS      NOVAL}\
 {check_data_in                 output     output        CHANNELS*WIDTH  rx_parallel_data        false                          NOVAL              check_data_in         conduit           end              true     gui_split_interfaces    WIDTH               CHANNELS      NOVAL}\
 {tx_data                       output     output        CHANNELS*80     tx_parallel_data        false                          NOVAL              tx_data               conduit           end              true     gui_split_interfaces    80                  CHANNELS      NOVAL}\
 {rx_data                       input      input         CHANNELS*80     rx_parallel_data        false                          NOVAL              rx_data               conduit           end              true     gui_split_interfaces    80                  CHANNELS      NOVAL}\
}

ip_declare_module $module
ip_declare_filesets $filesets
ip_declare_parameters $parameters
ip_set_auto_conduit_in_native_mode 1
ip_set_iface_split_suffix "_ch"
ip_declare_interfaces $interfaces

proc alt_xcvr_x1x2_if_adapter_val_callback {} {
  ip_validate_parameters
}

proc alt_xcvr_x1x2_if_adapter_elab_callback {} {
  ip_elaborate_interfaces
}

proc elaborate_reset {} {
  ip_set "interface.reset.synchronousEdges" none
}

proc elaborate_tx_digitalreset { PROP_IFACE_SPLIT_INDEX PROP_IFACE_NAME gui_split_interfaces CHANNELS design_environment} {
  if { $design_environment != "NATIVE" } {
    set tx_clkout "tx_clkout"
    if {$gui_split_interfaces} {
      regsub {.*(_ch.*)} $PROP_IFACE_NAME {tx_clkout\1} tx_clkout
    }
    ip_set "interface.${PROP_IFACE_NAME}.associatedclock" $tx_clkout
  }
}

proc callback_quartus_synth { entity } {
  add_fileset_file ./alt_xcvr_x1x2_if_adapter_top.v VERILOG PATH ./alt_xcvr_x1x2_if_adapter_top.v
  add_fileset_file ./alt_xcvr_x1x2_if_adapter.v VERILOG PATH ./alt_xcvr_x1x2_if_adapter.v
}

proc callback_sim_verilog { entity } {
  add_fileset_file ./alt_xcvr_x1x2_if_adapter_top.v VERILOG PATH ./alt_xcvr_x1x2_if_adapter_top.v
  add_fileset_file ./alt_xcvr_x1x2_if_adapter.v VERILOG PATH ./alt_xcvr_x1x2_if_adapter.v
}

proc callback_sim_vhdl { entity } {
  add_fileset_file ./alt_xcvr_x1x2_if_adapter_top.v VERILOG PATH ./alt_xcvr_x1x2_if_adapter_top.v
  add_fileset_file ./alt_xcvr_x1x2_if_adapter.v VERILOG PATH ./alt_xcvr_x1x2_if_adapter.v
}
