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
  {NAME                    VERSION INTERNAL VALIDATION_CALLBACK                     ELABORATION_CALLBACK                    DISPLAY_NAME                                  GROUP                                   AUTHOR               }\
  {alt_xcvr_21_bus_concat   16.1    true     alt_xcvr_21_bus_concat_val_callback      alt_xcvr_21_bus_concat_elab_callback     "Design Example 1:2 bus splitter (uneven)"    "Interface Protocols/Transceiver PHY"   "Altera Corporation" }\
}


# Declare the fileset using a nested list. First list is a header row.
set filesets {\
  {NAME            TYPE            CALLBACK                TOP_LEVEL     }\
  {quartus_synth   QUARTUS_SYNTH   callback_quartus_synth  alt_xcvr_21_bus_concat_top}\
  {sim_verilog     SIM_VERILOG     callback_sim_verilog    alt_xcvr_21_bus_concat_top}\
  {sim_vhdl        SIM_VHDL        callback_sim_vhdl       alt_xcvr_21_bus_concat_top}\
}


# Declare the parameters using a nested list. First list is a header row.
set parameters {\
  {NAME                 TYPE     DERIVED HDL_PARAMETER  DEFAULT_VALUE DISPLAY_HINT ALLOWED_RANGES ENABLED       VISIBLE}\
  {design_environment   STRING   false   false          "QSYS"        NOVAL        NOVAL          true          false }\
  {gui_split_interfaces integer  false   false          1             boolean      NOVAL          true          true  }\
  {DWIDTH_O1            integer  false   true           66            NOVAL        NOVAL          true          true  }\
  {DWIDTH_I1            integer  false   true           64            NOVAL        NOVAL          true          true  }\
  {DWIDTH_I2            integer  false   true           2             NOVAL        NOVAL          true          true  }\
  {CHANNELS             integer  false   true           1             NOVAL        NOVAL          true          true  }\
}

# Declare the ports and interfaces using a nested list. First list is a header row.
set ports {\
 {NAME                       DIRECTION  WIDTH_EXPR                 ROLE                IFACE_NAME           DYNAMIC  SPLIT                   SPLIT_WIDTH       SPLIT_COUNT     IFACE_TYPE   IFACE_DIRECTION   TERMINATION   ELABORATION_CALLBACK    }\
 {data_out1                  output     CHANNELS*DWIDTH_O1         data_out1           data_out1            true     gui_split_interfaces    DWIDTH_O1         CHANNELS        conduit      end               false         NOVAL                   }\
 {data_in1                   input      CHANNELS*DWIDTH_I1         data_in1            data_in1             true     gui_split_interfaces    DWIDTH_I1         CHANNELS        conduit      end               false         NOVAL                   }\
 {data_in2                   input      CHANNELS*DWIDTH_I2         data_in2            data_in2             true     gui_split_interfaces    DWIDTH_I2         CHANNELS        conduit      end               false         NOVAL                   }\
}                                                                                          


ip_declare_module $module
ip_declare_filesets $filesets
ip_declare_parameters $parameters
ip_declare_interfaces $ports
ip_set_iface_split_suffix "_ch"
ip_declare_interfaces $ports

proc alt_xcvr_21_bus_concat_val_callback {} {
  ip_validate_parameters
}

proc alt_xcvr_21_bus_concat_elab_callback {} {
  ip_elaborate_interfaces
}

proc callback_quartus_synth { entity } {
  add_fileset_file ./alt_xcvr_21_bus_concat_top.v VERILOG PATH ./alt_xcvr_21_bus_concat_top.sv
  add_fileset_file ./alt_xcvr_21_bus_concat.v VERILOG PATH ./alt_xcvr_21_bus_concat.sv
}

proc callback_sim_verilog { entity } {
  add_fileset_file ./alt_xcvr_21_bus_concat_top.v VERILOG PATH ./alt_xcvr_21_bus_concat_top.sv
  add_fileset_file ./alt_xcvr_21_bus_concat.v VERILOG PATH ./alt_xcvr_21_bus_concat.sv
}

proc callback_sim_vhdl { entity } {
  add_fileset_file ./alt_xcvr_21_bus_concat_top.v VERILOG PATH ./alt_xcvr_21_bus_concat_top.sv
  add_fileset_file ./alt_xcvr_21_bus_concat.v VERILOG PATH ./alt_xcvr_21_bus_concat.sv
}
