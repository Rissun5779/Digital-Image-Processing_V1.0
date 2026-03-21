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
  {NAME                               VERSION INTERNAL   VALIDATION_CALLBACK                             ELABORATION_CALLBACK                             DISPLAY_NAME              GROUP                                 AUTHOR              }\
  {alt_xcvr_basic_custom_tester       14.0    true       alt_xcvr_basic_custom_tester_val_callback       alt_xcvr_basic_custom_tester_elab_callback       "Basic/Custom 8G Tester"  "Interface Protocols/Transceiver PHY" "Altera Corporation"}\
}


# Declare the fileset using a nested list. First list is a header row.
set filesets {\
  {NAME            TYPE            CALLBACK                TOP_LEVEL     }\
  {quartus_synth   QUARTUS_SYNTH   callback_quartus_synth  alt_xcvr_basic_custom_tester_top}\
  {sim_verilog     SIM_VERILOG     callback_sim_verilog    alt_xcvr_basic_custom_tester_top}\
  {sim_vhdl        SIM_VHDL        callback_sim_vhdl       alt_xcvr_basic_custom_tester_top}\
}


# Declare the parameters using a nested list. First list is a header row.
set parameters {\
  {NAME                    TYPE     DERIVED HDL_PARAMETER DEFAULT_VALUE ALLOWED_RANGES ENABLED                VISIBLE}\
  {design_environment      STRING   false   false         "QSYS"        NOVAL          true                   false}\
  {EXPECTED_TX_LO_FREQ     integer  false   true          310           NOVAL          true                   true}\
  {EXPECTED_TX_HI_FREQ     integer  false   true          315           NOVAL          true                   true}\
  {EXPECTED_RX_LO_FREQ     integer  false   true          310           NOVAL          true                   true}\
  {EXPECTED_RX_HI_FREQ     integer  false   true          315           NOVAL          true                   true}\
  {EN_SERIAL_LOOPBACK      integer  false   true          1             NOVAL          true                   true}\
  {CHANNELS                integer  false   true          1             NOVAL          true                   true}\
  {DATA_WIDTH              integer  false   true          16             NOVAL         true                   true}\
  {UNUSED_TX_DATA_WIDTH    integer  false   true          1             NOVAL          true                   true}\
  {UNUSED_RX_DATA_WIDTH    integer  false   true          1             NOVAL          true                   true}\
  {TEST_TIMEOUT            integer  false   true          100000        NOVAL          true                   true}\
  {gui_split_interfaces    integer  false   false         0             NOVAL          true                   true}\
  {BYTE_SERIALIZE_X2_EN    integer  false   true          0             NOVAL          true                   true}\
  {EN_8B10B                integer  false   true          0             NOVAL          true                   true}\
  {EXT_DATA_PATTERN_EN     integer  false   false         0             NOVAL          true                   true}\
  {TX_ENH_BITSLIP_EN       integer  false   false         0             NOVAL          true                   true}\
  {TX_STD_BITSLIP_EN       integer  false   false         0             NOVAL          true                   true}\
}

# Declare the ports and interfaces using a nested list. First list is a header row.    
set ports {\
 {NAME                         DIRECTION UI_DIRECTION  WIDTH_EXPR             ROLE                      TERMINATION               TERMINATION_VALUE IFACE_NAME                IFACE_TYPE        IFACE_DIRECTION DYNAMIC SPLIT                    SPLIT_WIDTH SPLIT_COUNT   ELABORATION_CALLBACK }\
 {clock                        input     input         1                      clk                       false                     NOVAL             clock                     clock             sink            false   NOVAL                    NOVAL       NOVAL         NOVAL}\
 {prbs_data_gen_clk            input     input         CHANNELS               clk                       false                     NOVAL             prbs_data_gen_clk         clock             sink            true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {prbs_data_check_clk          input     input         CHANNELS               clk                       false                     NOVAL             prbs_data_check_clk       clock             sink            true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {reset                        input     input         1                      reset                     false                     NOVAL             reset                     reset             sink            false   NOVAL                    NOVAL       NOVAL         elaborate_interfaces}\
 {mcgb_rst                     output    output        1                      mcgb_rst                  false                     NOVAL             mcgb_rst                  conduit           sink            false   NOVAL                    NOVAL       NOVAL         NOVAL}\
 {rx_set_locktodata            output    output        CHANNELS               rx_set_locktodata         false                     NOVAL             rx_set_locktodata         conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {rx_set_locktoref             output    output        CHANNELS               rx_set_locktoref          false                     NOVAL             rx_set_locktoref          conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {rx_is_lockedtoref            input     input         CHANNELS               rx_is_lockedtoref         false                     NOVAL             rx_is_lockedtoref         conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {rx_is_lockedtodata           input     input         CHANNELS               rx_is_lockedtodata        false                     NOVAL             rx_is_lockedtodata        conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {rx_seriallpbken              output    output        CHANNELS               rx_seriallpbken           false                     NOVAL             rx_seriallpbken           conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {verifier_lock                input     input         CHANNELS               conduit                   false                     NOVAL             verifier_lock             conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {verifier_error               input     input         CHANNELS               conduit                   false                     NOVAL             verifier_error            conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {txclkout_freq_measured       input     input         CHANNELS               conduit                   false                     NOVAL             txclkout_freq_measured    conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {rxclkout_freq_measured       input     input         CHANNELS               conduit                   false                     NOVAL             rxclkout_freq_measured    conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {txclkout_freq                input     input         CHANNELS*16            conduit                   false                     NOVAL             txclkout_freq             conduit           end             true    gui_split_interfaces     16          CHANNELS      NOVAL}\
 {rxclkout_freq                input     input         CHANNELS*16            conduit                   false                     NOVAL             rxclkout_freq             conduit           end             true    gui_split_interfaces     16          CHANNELS      NOVAL}\
 {tx_ready                     input     input         CHANNELS               tx_ready                  false                     NOVAL             tx_ready                  conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {rx_ready                     input     input         CHANNELS               rx_ready                  false                     NOVAL             rx_ready                  conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {start_freq_check_tx          output    output        CHANNELS               conduit                   false                     NOVAL             start_freq_check_tx       conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {start_freq_check_rx          output    output        CHANNELS               conduit                   false                     NOVAL             start_freq_check_rx       conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {start_bit_slip               output    output        CHANNELS               start_bit_slip            false                     NOVAL             start_bit_slip            conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {channel_aligned              input     input         CHANNELS               conduit                   false                     NOVAL             channel_aligned           conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {prbs_gen_insert_error        output    output        CHANNELS               conduit                   false                     NOVAL             prbs_gen_insert_error     conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {prbs_gen_insert_pause        output    output        CHANNELS               conduit                   false                     NOVAL             prbs_gen_insert_pause     conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {prbs_gen_start               output    output        CHANNELS               conduit                   false                     NOVAL             prbs_gen_start            conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {prbs_check_start             output    output        CHANNELS               conduit                   false                     NOVAL             prbs_check_start          conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {prbs_gen_reset               output    output        CHANNELS               conduit                   false                     NOVAL             prbs_gen_reset            conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {prbs_check_reset             output    output        CHANNELS               conduit                   false                     NOVAL             prbs_check_reset          conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {unused_tx_parallel_data      output    output        UNUSED_TX_DATA_WIDTH   unused_tx_parallel_data   false                     NOVAL             unused_tx_parallel_data   conduit           end             false   NOVAL                    NOVAL       NOVAL         NOVAL}\
 {unused_rx_parallel_data      input     input         UNUSED_RX_DATA_WIDTH   unused_rx_parallel_data   false                     NOVAL             unused_rx_parallel_data   conduit           end             false   NOVAL                    NOVAL       NOVAL         NOVAL}\
 {tx_enh_data_valid            output    output        CHANNELS               tx_enh_data_valid         false                     NOVAL             tx_enh_data_valid         conduit           end             true    gui_split_interfaces     1           CHANNELS      NOVAL}\
 {tx_enh_bitslip               output    output        CHANNELS*7             tx_enh_bitslip            !TX_ENH_BITSLIP_EN        NOVAL             tx_enh_bitslip            conduit           end             true    gui_split_interfaces     7           CHANNELS      NOVAL}\
 {tx_std_bitslipboundarysel    output    output        CHANNELS*5             tx_std_bitslipboundarysel !TX_STD_BITSLIP_EN        NOVAL             tx_std_bitslipboundarysel conduit           end             true    gui_split_interfaces     5           CHANNELS      NOVAL}\
 {ext_data_pattern             output    output        CHANNELS*DATA_WIDTH    ext_data_pattern          !EXT_DATA_PATTERN_EN      NOVAL             ext_data_pattern          conduit           end             true    gui_split_interfaces     DATA_WIDTH  CHANNELS      NOVAL}\
 {pass                         output    output        1                      pass                      false                     NOVAL             pass                      conduit           end             false   NOVAL                    NOVAL       CHANNELS      NOVAL}\
}

ip_declare_module $module
ip_declare_filesets $filesets
ip_declare_parameters $parameters
ip_set_auto_conduit_in_native_mode 1
ip_set_iface_split_suffix "_ch"
ip_declare_interfaces $ports

proc alt_xcvr_basic_custom_tester_val_callback {} {  
  ip_validate_parameters
}

proc alt_xcvr_basic_custom_tester_elab_callback {} {
  ip_elaborate_interfaces
}

proc elaborate_reset {} {
  ip_set "interface.test_reset.synchronousEdges" none
}


proc elaborate_interfaces { PROP_IFACE_SPLIT_INDEX gui_split_interfaces CHANNELS } {
    set channels [expr {$gui_split_interfaces ? 1 : $CHANNELS}]
    set sfx [expr {$gui_split_interfaces ? "_ch${PROP_IFACE_SPLIT_INDEX}" : ""}]
    set add_offset [expr 1 * $PROP_IFACE_SPLIT_INDEX]
    ip_set "interface.reset.synchronousEdges" none
}

proc callback_quartus_synth { entity } {
  add_fileset_file ./alt_xcvr_basic_custom_tester_top.v VERILOG PATH ./alt_xcvr_basic_custom_tester_top.v
}

proc callback_sim_verilog { entity } {
  add_fileset_file ./alt_xcvr_basic_custom_tester_top.v VERILOG PATH ./alt_xcvr_basic_custom_tester_top.v
}

proc callback_sim_vhdl { entity } {
  add_fileset_file ./alt_xcvr_basic_custom_tester_top.v VERILOG PATH ./alt_xcvr_basic_custom_tester_top.v
}
