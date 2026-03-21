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

# Declare the module using a nested list. First list is header, second list is property values
set module {\
  {NAME                    VERSION             INTERNAL   VALIDATION_CALLBACK                  ELABORATION_CALLBACK                  DISPLAY_NAME                                     GROUP                                 AUTHOR            }\
  {alt_xcvr_tb_stim_gen    18.1    true       alt_xcvr_tb_stim_gen_val_callback    alt_xcvr_tb_stim_gen_elab_callback    "Design Example Testbech Stimulus Generator"     "Interface Protocols/Transceiver PHY" "Altera Corporation"}\
}

# Declare the fileset using a nested list. First list is a header row.
set filesets {\
  {NAME            TYPE            CALLBACK                TOP_LEVEL     }\
  {quartus_synth   QUARTUS_SYNTH   callback_quartus_synth  alt_xcvr_tb_stim_gen_top}\
  {sim_verilog     SIM_VERILOG     callback_sim_verilog    alt_xcvr_tb_stim_gen_top}\
  {sim_vhdl        SIM_VHDL        callback_sim_vhdl       alt_xcvr_tb_stim_gen_top}\
}

# Declare the parameters using a nested list. First list is a header row.
set parameters {\
  {NAME                             TYPE      DERIVED   HDL_PARAMETER DEFAULT_VALUE ALLOWED_RANGES   DISPLAY_HINT    ENABLED       VISIBLE}\
  {design_environment               STRING    false     false         "QSYS"        NOVAL            NOVAL           true          false}\
  {CHANNELS                         integer   false     true          1             NOVAL            NOVAL           true          true}\
  {pll_refclk_freq_mhz              float     false     false         100.0         NOVAL            NOVAL           true          true}\
  {pll_ref_clk_period_ps            integer   true      true          100           NOVAL            NOVAL           true          true}\
  {mgmt_clk_freq_mhz                float     false     false         100.0         NOVAL            NOVAL           true          true}\
  {mgmt_clk_period_ps               integer   true      true          100           NOVAL            NOVAL           true          true}\
  {reset_duration_ns                integer   false     true          200           NOVAL            NOVAL           true          true}\
  {simulation_duration_us           integer   false     true          800           NOVAL            NOVAL           true          true}\
  {gui_split_interfaces             integer   false     false         0             NOVAL            boolean         true          true}\
}

# Declare the ports and interfaces using a nested list. First list is a header row.
set interfaces {\
  {NAME              DIRECTION UI_DIRECTION WIDTH_EXPR  ROLE             TERMINATION TERMINATION_VALUE IFACE_NAME       IFACE_TYPE IFACE_DIRECTION DYNAMIC SPLIT                 SPLIT_WIDTH SPLIT_COUNT ELABORATION_CALLBACK }\
  {pll_ref_clk       output    output       1           clk              false       NOVAL             pll_ref_clk      clock      source          false   NOVAL                 NOVAL       NOVAL       NOVAL }\
  {mgmt_clk          output    output       1           clk              false       NOVAL             mgmt_clk         clock      source          false   NOVAL                 NOVAL       NOVAL       NOVAL }\
  {mgmt_reset        output    output       1           reset            false       NOVAL             mgmt_reset       reset      source          false   NOVAL                 NOVAL       NOVAL       elaborate_reset }\
  {tx_serial_data    input     input        CHANNELS*1  tx_serial_data   false       NOVAL             tx_serial_data   conduit    end             true    gui_split_interfaces  1           CHANNELS    NOVAL }\
  {rx_serial_data    output    output       CHANNELS*1  rx_serial_data   false       NOVAL             rx_serial_data   conduit    end             true    gui_split_interfaces  1           CHANNELS    NOVAL }\
  {pass              input     input        1           pass             false       NOVAL             pass             conduit    end             false   NOVAL                 NOVAL       NOVAL       NOVAL }\
}

ip_declare_module $module
ip_declare_filesets $filesets
ip_declare_parameters $parameters
ip_set_auto_conduit_in_native_mode 1
ip_set_iface_split_suffix "_ch"
ip_declare_interfaces $interfaces


proc alt_xcvr_tb_stim_gen_val_callback {} {  
  ip_validate_parameters

  set CONVERSION_FACTOR 1000000
  set pll_refclk_freq_mhz [ip_get "parameter.pll_refclk_freq_mhz.value"]
  set pll_period [expr {int($CONVERSION_FACTOR/(double($pll_refclk_freq_mhz)))}]
  ip_set "parameter.pll_ref_clk_period_ps.value" $pll_period

  set mgmt_clk_freq_mhz [ip_get "parameter.mgmt_clk_freq_mhz.value"]
  set mgmt_period [expr {int($CONVERSION_FACTOR/(double($mgmt_clk_freq_mhz)))}]
  ip_set "parameter.mgmt_clk_period_ps.value" $mgmt_period
}

proc alt_xcvr_tb_stim_gen_elab_callback {} {
  ip_elaborate_interfaces
}

proc elaborate_reset {} {
  ip_set "interface.mgmt_reset.associatedclock" mgmt_clk
}


proc elaborate_interfaces { PROP_IFACE_SPLIT_INDEX gui_split_interfaces CHANNELS CLOCK_TYPE} {
    set channels [expr {$gui_split_interfaces ? 1 : $CHANNELS}]
    set sfx [expr {$gui_split_interfaces ? "_ch${PROP_IFACE_SPLIT_INDEX}" : ""}]
    set add_offset [expr 1 * $PROP_IFACE_SPLIT_INDEX]
}

proc callback_quartus_synth { entity } {
  add_fileset_file ./alt_xcvr_tb_stim_gen_top.sv VERILOG PATH ./alt_xcvr_tb_stim_gen_top.sv
}

proc callback_sim_verilog { entity } {
  add_fileset_file ./alt_xcvr_tb_stim_gen_top.sv VERILOG PATH ./alt_xcvr_tb_stim_gen_top.sv
}

proc callback_sim_vhdl { entity } {
  add_fileset_file ./alt_xcvr_tb_stim_gen_top.sv VERILOG PATH ./alt_xcvr_tb_stim_gen_top.sv
}
