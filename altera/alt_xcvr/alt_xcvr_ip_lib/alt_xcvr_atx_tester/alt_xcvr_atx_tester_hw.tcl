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

set module {\
  {NAME                VERSION INTERNAL   VALIDATION_CALLBACK              ELABORATION_CALLBACK              DISPLAY_NAME       GROUP                                 AUTHOR              }\
  {alt_xcvr_atx_tester 14.0    true       alt_xcvr_atx_tester_val_callback alt_xcvr_atx_tester_elab_callback "ATX PLL Tester"   "Interface Protocols/Transceiver PHY" "Altera Corporation"}\
}


# Declare the fileset using a nested list. First list is a header row.
set filesets {\
  {NAME            TYPE            CALLBACK                TOP_LEVEL     }\
  {quartus_synth   QUARTUS_SYNTH   callback_quartus_synth  alt_xcvr_atx_tester_top}\
  {sim_verilog     SIM_VERILOG     callback_sim_verilog    alt_xcvr_atx_tester_top}\
  {sim_vhdl        SIM_VHDL        callback_sim_vhdl       alt_xcvr_atx_tester_top}\
}


# Declare the parameters using a nested list. First list is a header row.
set parameters {\
  {NAME                             TYPE     DERIVED HDL_PARAMETER DEFAULT_VALUE ALLOWED_RANGES  DISPLAY_HINT        ENABLED       VISIBLE}\
  {design_environment               STRING   false   false         "QSYS"        NOVAL           NOVAL               true          false}\
  {EXPECTED_TX_SERIAL_CLOCK_FREQ    integer  false   true          100           NOVAL           NOVAL               true          true}\
  {TOLERANCE                        integer  false   true          1             NOVAL           NOVAL               true          true}\
  {MEASURE_TX_SERIAL                integer  false   true          0             NOVAL           BOOLEAN             true          true}\
  {MEASURE_TX_BONDED                integer  false   true          0             NOVAL           BOOLEAN             true          true}\
  {PMA_WIDTH                        integer  false   true          8             NOVAL           NOVAL               true          true}\
  {MCGB_DIV                         integer  false   true          1             NOVAL           NOVAL               true          true}\
  {TEST_PCIE_SW                     integer  false   true          0             NOVAL           BOOLEAN             true          true}\
}

# Declare the ports and interfaces using a nested list. First list is a header row.
set ports {\
 {NAME                         DIRECTION UI_DIRECTION  WIDTH_EXPR    ROLE           TERMINATION                 TERMINATION_VALUE IFACE_NAME               IFACE_TYPE        IFACE_DIRECTION DYNAMIC SPLIT     SPLIT_WIDTH  SPLIT_COUNT   ELABORATION_CALLBACK }\
 {test_clk                     input     input         1             clk            false                       NOVAL             test_clk                 clock             sink            false   NOVAL     NOVAL        NOVAL         NOVAL}\
 {test_reset                   input     input         1             reset          false                       NOVAL             test_reset               reset             sink            false   NOVAL     NOVAL        NOVAL         elaborate_reset}\
 {pll_powerdown                output    output        1             pll_powerdown  false                       NOVAL             pll_powerdown            conduit           end             false   NOVAL     NOVAL        NOVAL         NOVAL}\
 {mcgb_rst                     output    output        1             mcgb_rst       false                       NOVAL             mcgb_rst                 conduit           end             false   NOVAL     NOVAL        NOVAL         NOVAL}\
 {pcie_sw                      output    output        2             conduit        "!TEST_PCIE_SW"             NOVAL             pcie_sw                  conduit           end             false   NOVAL     NOVAL        NOVAL         NOVAL}\
 {pll_locked                   input     input         1             pll_locked     false                       NOVAL             pll_locked               conduit           end             false   NOVAL     NOVAL        NOVAL         NOVAL}\
 {start_freq_check             output    output        1             conduit        false                       NOVAL             start_freq_check         conduit           end             false   NOVAL     NOVAL        NOVAL         NOVAL}\
 {pcie_sw_done                 output    output        2             conduit        "!TEST_PCIE_SW"             NOVAL             pcie_sw_done             conduit           end             false   NOVAL     NOVAL        NOVAL         NOVAL}\
 {clkout_freq_tx_serial        input     input         16            conduit        "!MEASURE_TX_SERIAL"        NOVAL             clkout_freq_tx_serial    conduit           end             false   NOVAL     NOVAL        NOVAL         NOVAL}\
 {clkout_freq_tx_bonded        input     input         16*6          conduit        "!MEASURE_TX_BONDED"        NOVAL             clkout_freq_tx_bonded    conduit           end             true    true      16           6             NOVAL}\
 {freq_measured_tx_serial      input     input         1             conduit        "!MEASURE_TX_SERIAL"        NOVAL             freq_measured_tx_serial  conduit           end             false   NOVAL     NOVAL        NOVAL         NOVAL}\
 {freq_measured_tx_bonded      input     input         6             conduit        "!MEASURE_TX_BONDED"        NOVAL             freq_measured_tx_bonded  conduit           end             true    true      1            6             NOVAL}\
 {pass                         output    output        1             conduit        false                       NOVAL             pass                     conduit           end             false   NOVAL     NOVAL        NOVAL         NOVAL}\
}

ip_declare_module $module
ip_declare_filesets $filesets
ip_declare_parameters $parameters
ip_set_auto_conduit_in_native_mode 1
ip_set_iface_split_suffix "_ch"
ip_declare_interfaces $ports

proc alt_xcvr_atx_tester_val_callback {} {  
  ip_validate_parameters
}

proc alt_xcvr_atx_tester_elab_callback {} {
  ip_elaborate_interfaces
}

proc elaborate_reset {} {
  ip_set "interface.test_reset.synchronousEdges" none
}


proc elaborate_interfaces { PROP_IFACE_SPLIT_INDEX gui_split_interfaces CHANNELS } {
    set channels [expr {$gui_split_interfaces ? 1 : $CHANNELS}]
    set sfx [expr {$gui_split_interfaces ? "_ch${PROP_IFACE_SPLIT_INDEX}" : ""}]
    set add_offset [expr 1 * $PROP_IFACE_SPLIT_INDEX]
}

proc callback_quartus_synth { entity } {
  add_fileset_file ./alt_xcvr_atx_tester_top.v VERILOG PATH ./alt_xcvr_atx_tester_top.v
  add_fileset_file ./freq_validate.v VERILOG PATH ./freq_validate.v
}

proc callback_sim_verilog { entity } {
  add_fileset_file ./alt_xcvr_atx_tester_top.v VERILOG PATH ./alt_xcvr_atx_tester_top.v
  add_fileset_file ./freq_validate.v VERILOG PATH ./freq_validate.v
}

proc callback_sim_vhdl { entity } {
  add_fileset_file ./alt_xcvr_atx_tester_top.v VERILOG PATH ./alt_xcvr_atx_tester_top.v
  add_fileset_file ./freq_validate.v VERILOG PATH ./freq_validate.v
}
