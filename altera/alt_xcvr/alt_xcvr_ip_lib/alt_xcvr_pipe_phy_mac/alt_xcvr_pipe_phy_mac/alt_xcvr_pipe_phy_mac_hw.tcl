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
lappend auto_path $env(QUARTUS_ROOTDIR)/../../p4/ip/alt_xcvr/altera_xcvr_pcie_hip_native/alt_xcvr_pipe_phy_mac
#lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/altera_xcvr_pcie_hip_native/alt_xcvr_pipe_phy_mac

package require -exact qsys 16.0
package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::ip_interfaces
package require alt_xcvr::ip_tcl::messages
package require altera_terp

package provide altera_xcvr_pcie_hip_native::alt_xcvr_pipe_phy_mac 16.1

namespace eval ::alt_xcvr_pipe_phy_mac:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::ip_tcl::ip_interfaces::*
  namespace import ::alt_xcvr::ip_tcl::messages::*

  # Declare the module using a nested list. First list is header, second list is property values
  variable module {\
    {NAME                   VERSION             SUPPORTED_DEVICE_FAMILIES   EDITABLE  INTERNAL VALIDATION_CALLBACK                                          ELABORATION_CALLBACK                                            DISPLAY_NAME                           GROUP                                 AUTHOR            }\
    {alt_xcvr_pipe_phy_mac  18.1    {"Stratix 10"}              false     true     ::alt_xcvr_pipe_phy_mac::alt_xcvr_pipe_phy_mac_val_callback  ::alt_xcvr_pipe_phy_mac::alt_xcvr_pipe_phy_mac_elab_callback    "PCIe PIPE PHY Mac"                    "Interface Protocols/Transceiver PHY" "Altera Corporation"}\
  }

  # Declare the fileset using a nested list. First list is a header row.
  variable filesets {\
    {NAME            TYPE            CALLBACK                                                   TOP_LEVEL     }\
    {quartus_synth   QUARTUS_SYNTH   ::alt_xcvr_pipe_phy_mac::callback_quartus_synth  }\
    {sim_verilog     SIM_VERILOG     ::alt_xcvr_pipe_phy_mac::callback_sim_verilog    }\
    {sim_vhdl        SIM_VHDL        ::alt_xcvr_pipe_phy_mac::callback_sim_vhdl       }\
  }


  # Declare the parameters using a nested list. First list is a header row.
  variable parameters {\
    {NAME                 TYPE     DERIVED HDL_PARAMETER DEFAULT_VALUE ALLOWED_RANGES                                                                 DISPLAY_HINT    DISPLAY_NAME                     ENABLED       VISIBLE   VALIDATION_CALLBACK}\
    {device_family        STRING   false   false         "Stratix 10"  NOVAL                                                                          NOVAL           NOVAL                            true          false     NOVAL}\
    {device               STRING   false   false         "Unknown"     NOVAL                                                                          NOVAL           NOVAL                            true          false     NOVAL}\
    {base_device          STRING   false   false         "Unknown"     NOVAL                                                                          NOVAL           NOVAL                            true          false     NOVAL}\
    {design_environment   STRING   false   false         "Native"      NOVAL                                                                          NOVAL           NOVAL                            true          false     NOVAL}\
    {unique_string        INTEGER  false   false         "random"      NOVAL                                                                          NOVAL           NOVAL                            true          false     NOVAL}\
    \
    {design_environment   STRING   false   false         "QSYS"        NOVAL                                                                          NOVAL           NOVAL                            true          false     NOVAL}\
    \
    {PIPE_PROTOCOL_MODE   STRING   false   false         "pipe_g3"     {"pipe_g1" "pipe_g2" "pipe_g3"}                                                NOVAL           "Protocol Mode"                  true          true      NOVAL}\
    {PIPE_USED_CHANNELS   integer  false   false         1             {1 2 4 8 16}                                                                   NOVAL           "Channels"                       true          true      NOVAL}\
    {PIPE_CONTROL_SOURCE  boolean  false   false         0             NOVAL                                                                          NOVAL           "Manual Mode"                    true          true      NOVAL}\
    {PIPE_PLD_IF_WIDTH    integer  false   false         16            {8 16 32}                                                                      NOVAL           "PLD Interface Width"            true          true      NOVAL}\
    {PIPE_REFCLK          STRING   false   false         "100.0"       {"100.0" "125.0"}                                                              NOVAL           "Reference Clock Frequency"      true          true      NOVAL}\
    {PIPE_DATA_PATTERN    STRING   false   false         "prbs15"      {"prbs7" "prbs10" "prbs9" "prbs15" "prbs23" "prbs31" "walking_one" "counter"}  NOVAL           "Data Pattern"                   true          true      NOVAL}\
    {PIPE_FAST_SIM        boolean  false   false         0             NOVAL                                                                          NOVAL           "Enable Fast Sim"                true          true      NOVAL}\
    {PIPE_PHY_CONTROL     boolean  false   false         0             NOVAL                                                                          NOVAL           "MAC Signal Simulus"             true          true      NOVAL}\
    {PIPE_COMPLIANCE_EN   boolean  false   false         0             NOVAL                                                                          NOVAL           "Force Compliance Mode"          true          true      NOVAL}\
    \
    {max_rate             STRING   true    true          "gen3"        NOVAL                                                                          NOVAL           NOVAL                            true          false     ::alt_xcvr_pipe_phy_mac::validate_max_rate                        }\
    {lanes                integer  true    true          1             NOVAL                                                                          NOVAL           NOVAL                            true          false     ::alt_xcvr_pipe_phy_mac::validate_lanes                           }\
    {mac_control          STRING   true    true          "ltssm"       NOVAL                                                                          NOVAL           NOVAL                            true          false     ::alt_xcvr_pipe_phy_mac::validate_mac_control                     }\
    {pld_if_dw            integer  true    true          16            NOVAL                                                                          NOVAL           NOVAL                            true          false     ::alt_xcvr_pipe_phy_mac::validate_pld_if_width                    }\
    {words_pld_if         integer  true    true          2             NOVAL                                                                          NOVAL           NOVAL                            true          false     ::alt_xcvr_pipe_phy_mac::validate_words_pld_if                    }\
    {cdr_refclk           STRING   true    true          "100Mhz"      NOVAL                                                                          NOVAL           NOVAL                            true          false     ::alt_xcvr_pipe_phy_mac::validate_cdr_refclk                      }\
    {data_pattern         STRING   true    true          "prbs15"      NOVAL                                                                          NOVAL           NOVAL                            true          false     ::alt_xcvr_pipe_phy_mac::validate_data_pattern                    }\
    {fast_sim             STRING   true    true          "true"        NOVAL                                                                          NOVAL           NOVAL                            true          false     ::alt_xcvr_pipe_phy_mac::validate_fast_sim                        }\
    {mac_control          STRING   true    true          "mac"         NOVAL                                                                          NOVAL           NOVAL                            true          false     ::alt_xcvr_pipe_phy_mac::validate_mac_control                     }\
    {compliance           STRING   true    true          "false"       NOVAL                                                                          NOVAL           NOVAL                            true          false     ::alt_xcvr_pipe_phy_mac::validate_compliance                      }\
  }

  # Declare the ports and interfaces using a nested list. First list is a header row.
  variable interfaces {\
    {NAME                          DIRECTION UI_DIRECTION  WIDTH_EXPR                      ROLE                     TERMINATION                 TERMINATION_VALUE IFACE_NAME                   IFACE_TYPE        IFACE_DIRECTION DYNAMIC SPLIT                   SPLIT_WIDTH         SPLIT_COUNT   ELABORATION_CALLBACK }\
    {core_reset                    input     input         1                               reset                    false                       NOVAL             core_reset                   reset             sink            true    NOVAL                   NOVAL               NOVAL         ::alt_xcvr_pipe_phy_mac::elaborate_core_reset}\
    \
    {core_tx_detectrx              input     input         1                               core_tx_detectrx         true                        NOVAL             core_tx_detectrx             conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {core_tx_elecidle              input     input         1                               core_tx_elecidle         true                        NOVAL             core_tx_elecidle             conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {core_tx_swing                 input     input         1                               core_tx_swing            true                        NOVAL             core_tx_swing                conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {core_rx_polarity              input     input         1                               core_rx_polarity         true                        NOVAL             core_rx_polarity             conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {core_rx_preset_hint           input     input         2                               core_rx_preset_hint      true                        NOVAL             core_rx_preset_hint          conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {core_powerdown                input     input         2                               core_powerdown           true                        NOVAL             core_powerdown               conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {core_rate                     input     input         2                               core_rate                true                        NOVAL             core_rate                    conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {core_tx_margin                input     input         2                               core_tx_margin           true                        NOVAL             core_tx_margin               conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {core_tx_deemphasis            input     input         18                              core_tx_deemphasis       true                        NOVAL             core_tx_deemphasis           conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    \
    {data_tx_data                  output    output        lanes*words_pld_if              data_tx_data             false                       NOVAL             data_tx_data                 conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {data_tx_datak                 output    output        lanes*words_pld_if              data_tx_datak            false                       NOVAL             data_tx_datak                conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {data_tx_data_valid            output    output        lanes                           data_tx_data_valid       false                       NOVAL             data_tx_data_valid           conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {data_tx_blk_start             output    output        lanes                           data_tx_blk_start        false                       NOVAL             data_tx_blk_start            conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {data_tx_sync_hdr              output    output        lanes*2                         data_tx_sync_hdr         false                       NOVAL             data_tx_sync_hdr             conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {mac_tx_detectrx               output    output        lanes                           mac_tx_detectrx          false                       NOVAL             mac_tx_detectrx              conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {mac_tx_elecidle               output    output        lanes*words_pld_if              mac_tx_elecidle          false                       NOVAL             mac_tx_elecidle              conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {mac_compliance                output    output        lanes*words_pld_if              mac_compliance           false                       NOVAL             mac_compliance               conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {mac_rx_polarity               output    output        lanes                           mac_rx_polarity          false                       NOVAL             mac_rx_polarity              conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {mac_powerdown                 output    output        lanes*2                         mac_powerdown            false                       NOVAL             mac_powerdown                conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {mac_rate                      output    output        lanes*2                         mac_rate                 false                       NOVAL             mac_rate                     conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    \
    {pipe_pclk                     input     input         lanes                           pipe_pclk                false                       NOVAL             pipe_pclk                    clock             sink            true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {phy_rx_syncstatus             input     input         lanes*words_pld_if              phy_rx_syncstatus        false                       NOVAL             phy_rx_syncstatus            conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {phy_rx_data                   input     input         lanes*pld_if_dw                 phy_rx_data              false                       NOVAL             phy_rx_data                  conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {phy_rx_datak                  input     input         lanes*words_pld_if              phy_rx_datak             false                       NOVAL             phy_rx_datak                 conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {phy_rx_valid                  input     input         lanes                           phy_rx_valid             false                       NOVAL             phy_rx_valid                 conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {phy_rx_sync_hdr               input     input         lanes*2                         phy_rx_sync_hdr          false                       NOVAL             phy_rx_sync_hdr              conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {phy_rx_blk_start              input     input         lanes                           phy_rx_blk_start         false                       NOVAL             phy_rx_blk_start             conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {phy_rx_data_valid             input     input         lanes                           phy_rx_data_valid        false                       NOVAL             phy_rx_data_valid            conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {phy_rx_elecidle               input     input         lanes                           phy_rx_elecidle          false                       NOVAL             phy_rx_elecidle              conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {phy_rx_status                 input     input         lanes*3                         phy_rx_status            false                       NOVAL             phy_rx_status                conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {phy_status                    input     input         lanes                           phy_status               false                       NOVAL             phy_status                   conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    \
    {data_rx_infer_elecidle        output    output        1                               data_rx_infer_elecidle   false                       NOVAL             data_rx_infer_elecidle       conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {data_end_ts                   output    output        2                               data_end_ts              false                       NOVAL             data_end_ts                  conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    \
    {test_complete                 output    output        1                               test_complete            false                       NOVAL             test_complete                conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {ltssm_tx_elecidle             output    output        1                               ltssm_tx_elecidle        false                       NOVAL             ltssm_tx_elecidle            conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {ltssm_tx_detectrx             output    output        1                               ltssm_tx_detectrx        false                       NOVAL             ltssm_tx_detectrx            conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {ltssm_rate                    output    output        2                               ltssm_rate               false                       NOVAL             ltssm_rate                   conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {ltssm_powerdown               output    output        2                               ltssm_powerdown          false                       NOVAL             ltssm_powerdown              conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {ltssm_state                   output    output        4                               ltssm_state              false                       NOVAL             ltssm_state                  conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    {data_errors                   output    output        lanes                           data_errors              false                       NOVAL             data_errors                  conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
    \
    {manual_control                input     input         1                               manual_control           false                       NOVAL             manual_control               conduit           end             true    NOVAL                   NOVAL               NOVAL         NOVAL}\
  }
}

proc ::alt_xcvr_pipe_phy_mac::declare_module {} {
  variable interfaces
  variable parameters
  variable module
  variable filesets

  ip_declare_module $module
  ip_declare_filesets $filesets
  ip_declare_parameters $parameters
  ip_set_auto_conduit_in_native_mode 1
  ip_set_iface_split_suffix "_ch"
  ip_declare_interfaces $interfaces
}

proc ::alt_xcvr_pipe_phy_mac::elaborate_core_reset { } {
  ip_set "interface.core_reset.synchronousEdges" NONE
}

proc ::alt_xcvr_pipe_phy_mac::alt_xcvr_pipe_phy_mac_val_callback {} {  
  ip_validate_parameters
}

proc ::alt_xcvr_pipe_phy_mac::alt_xcvr_pipe_phy_mac_elab_callback {} {
  ::alt_xcvr_pipe_phy_mac::elaborate_add_hdl_instance
  ip_elaborate_interfaces
}

proc ::alt_xcvr_pipe_phy_mac::validate_max_rate      { PIPE_PROTOCOL_MODE } {
  if { $PIPE_PROTOCOL_MODE == "pipe_g3" } {
    ip_set "parameter.max_rate.value" "gen3"
  } elseif {$PIPE_PROTOCOL_MODE == "pipe_g2" } {
    ip_set "parameter.max_rate.value" "gen2"
  } elseif {$PIPE_PROTOCOL_MODE == "pipe_g1" } {
    ip_set "parameter.max_rate.value" "gen1"
  } else {
    ip_message error "Please select a valid protocol"
  }
} 

proc ::alt_xcvr_pipe_phy_mac::validate_lanes         { PIPE_USED_CHANNELS } {
  ip_set "parameter.lanes.value" $PIPE_USED_CHANNELS
}

proc ::alt_xcvr_pipe_phy_mac::validate_mac_control   { PIPE_CONTROL_SOURCE } {
  if { $PIPE_CONTROL_SOURCE == 0 } {
    ip_set "parameter.mac_control.value" "ltssm"
  } else {
    ip_set "parameter.mac_control.value" "manual"
  }
}

proc ::alt_xcvr_pipe_phy_mac::validate_words_pld_if { PIPE_PLD_IF_WIDTH } {
  ip_set "parameter.words_pld_if.value" [expr $PIPE_PLD_IF_WIDTH/8]
}

proc ::alt_xcvr_pipe_phy_mac::validate_pld_if_width  { PIPE_PLD_IF_WIDTH } {
  ip_set "parameter.pld_if_dw.value" $PIPE_PLD_IF_WIDTH
}

proc ::alt_xcvr_pipe_phy_mac::validate_cdr_refclk    { PIPE_REFCLK } {
  if { $PIPE_REFCLK == "100.0" } {
    ip_set "parameter.cdr_refclk.value" "100Mhz"
  } elseif {$PIPE_REFCLK == "125.0" } {
    ip_set "parameter.cdr_refclk.value" "125Mhz"
  } else {
    ip_message error "Invalid reference clock freq"
  }
}

proc ::alt_xcvr_pipe_phy_mac::validate_data_pattern  { PIPE_DATA_PATTERN } {
  ip_set "parameter.data_pattern.value" $PIPE_DATA_PATTERN"
}

proc ::alt_xcvr_pipe_phy_mac::validate_fast_sim      { PIPE_FAST_SIM } {
  if { $PIPE_FAST_SIM == 0 } {
    ip_set "parameter.fast_sim.value" "false"
  } else {
    ip_set "parameter.fast_sim.value" "true"
  }
}

proc ::alt_xcvr_pipe_phy_mac::validate_mac_control   { PIPE_PHY_CONTROL } {
  if { $PIPE_PHY_CONTROL == 0 } {
    ip_set "parameter.mac_control.value" "top"
  } else {
    ip_set "parameter.mac_control.value" "mac"
  }
}

proc ::alt_xcvr_pipe_phy_mac::validate_compliance    { PIPE_COMPLIANCE_EN } {
  if { $PIPE_COMPLIANCE_EN == 0 } {
    ip_set "parameter.compliance.value" "false"
  } else {
    ip_set "parameter.compliance.value" "true"
  }
}

proc ::alt_xcvr_pipe_phy_mac::decode_prbs_poly { } {
  set pattern [ip_get "parameter.PIPE_DATA_PATTERN.value"]
  if        { $pattern == "prbs7" } {
    return 1
  } elseif  { $pattern == "prbs9" } {
    return 2
  } elseif  { $pattern == "prbs10" } {
    return 3
  } elseif  { $pattern == "prbs15" } {
    return 4
  } elseif  { $pattern == "prbs23" } {
    return 5
  } elseif  { $pattern == "prbs31" } {
    return 6
  } elseif  { $pattern == "counter" } {
    return 8
  } elseif  { $pattern == "walking_one" } {
    return 7
  } else {
    return 4
  }
}

proc ::alt_xcvr_pipe_phy_mac::elaborate_add_hdl_instance {} {
  add_hdl_instance pattern_ver alt_xcvr_data_pattern_check
  set_instance_parameter_value pattern_ver {STATIC_PATTERN_EN}  1
  set_instance_parameter_value pattern_ver {DATA_WIDTH}         [ip_get "parameter.pld_if_dw.value"]
  set_instance_parameter_value pattern_ver {STATIC_PATTERN}     [::alt_xcvr_pipe_phy_mac::decode_prbs_poly]
  add_hdl_instance pattern_gen alt_xcvr_data_pattern_gen
  set_instance_parameter_value pattern_gen {STATIC_PATTERN_EN}  1
  set_instance_parameter_value pattern_gen {DATA_WIDTH}         [ip_get "parameter.pld_if_dw.value"]       
  set_instance_parameter_value pattern_gen {STATIC_PATTERN}     [::alt_xcvr_pipe_phy_mac::decode_prbs_poly]
}

proc ::alt_xcvr_pipe_phy_mac::callback_quartus_synth { entity } {
  add_fileset_file ./pipe_data_checker.v          VERILOG PATH  ./pipe_data_checker.v
  add_fileset_file ./pipe_data_top.v              VERILOG PATH  ./pipe_data_top.v
  add_fileset_file ./pipe_ltssm_adapter.v         VERILOG PATH  ./pipe_ltssm_adapter.v
  add_fileset_file ./pipe_ltssm_control_signal.v  VERILOG PATH  ./pipe_ltssm_control_signal.v
  add_fileset_file ./pipe_ltssm_sm.v              VERILOG PATH  ./pipe_ltssm_sm.v
  add_fileset_file ./pipe_mac_top.v               VERILOG PATH  ./pipe_mac_top.v
  add_fileset_file ./pipe_scrambler.v             VERILOG PATH  ./pipe_scrambler.v
  add_fileset_file ./pipe_top.v                   VERILOG PATH  ./pipe_top.v
}

proc ::alt_xcvr_pipe_phy_mac::callback_sim_verilog { entity } {
  add_fileset_file ./pipe_data_checker.v          VERILOG PATH  ./pipe_data_checker.v
  add_fileset_file ./pipe_data_top.v              VERILOG PATH  ./pipe_data_top.v
  add_fileset_file ./pipe_ltssm_adapter.v         VERILOG PATH  ./pipe_ltssm_adapter.v
  add_fileset_file ./pipe_ltssm_control_signal.v  VERILOG PATH  ./pipe_ltssm_control_signal.v
  add_fileset_file ./pipe_ltssm_sm.v              VERILOG PATH  ./pipe_ltssm_sm.v
  add_fileset_file ./pipe_mac_top.v               VERILOG PATH  ./pipe_mac_top.v
  add_fileset_file ./pipe_scrambler.v             VERILOG PATH  ./pipe_scrambler.v
  add_fileset_file ./pipe_top.v                   VERILOG PATH  ./pipe_top.v
}

proc ::alt_xcvr_pipe_phy_mac::callback_sim_vhdl { entity } {
  add_fileset_file ./pipe_data_checker.v          VERILOG PATH  ./pipe_data_checker.v
  add_fileset_file ./pipe_data_top.v              VERILOG PATH  ./pipe_data_top.v
  add_fileset_file ./pipe_ltssm_adapter.v         VERILOG PATH  ./pipe_ltssm_adapter.v
  add_fileset_file ./pipe_ltssm_control_signal.v  VERILOG PATH  ./pipe_ltssm_control_signal.v
  add_fileset_file ./pipe_ltssm_sm.v              VERILOG PATH  ./pipe_ltssm_sm.v
  add_fileset_file ./pipe_mac_top.v               VERILOG PATH  ./pipe_mac_top.v
  add_fileset_file ./pipe_scrambler.v             VERILOG PATH  ./pipe_scrambler.v
  add_fileset_file ./pipe_top.v                   VERILOG PATH  ./pipe_top.v
}

::alt_xcvr_pipe_phy_mac::declare_module
