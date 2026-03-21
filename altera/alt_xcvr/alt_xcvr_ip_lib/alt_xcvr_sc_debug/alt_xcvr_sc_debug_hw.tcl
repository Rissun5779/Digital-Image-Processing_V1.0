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

namespace eval ::alt_xcvr_sc_debug:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::ip_tcl::ip_interfaces::*
  namespace import ::alt_xcvr::ip_tcl::messages::*

  # Declare the module using a nested list. First list is header, second list is property values
  variable module {\
    {NAME                   VERSION             SUPPORTED_DEVICE_FAMILIES   EDITABLE  INTERNAL VALIDATION_CALLBACK                                          ELABORATION_CALLBACK                                            DISPLAY_NAME                           GROUP                                 AUTHOR            }\
    {alt_xcvr_sc_debug      18.1    {"Stratix 10"}              false     true     ::alt_xcvr_sc_debug::alt_xcvr_sc_debug_val_callback          ::alt_xcvr_sc_debug::alt_xcvr_sc_debug_elab_callback    "System Console Debug block for hardware testing"                    "Interface Protocols/Transceiver PHY" "Altera Corporation"}\
  }

  # Declare the fileset using a nested list. First list is a header row.
  variable filesets {\
    {NAME            TYPE            CALLBACK                                                   TOP_LEVEL     }\
    {quartus_synth   QUARTUS_SYNTH   ::alt_xcvr_sc_debug::callback_quartus_synth                alt_xcvr_sc_debug}\
    {sim_verilog     SIM_VERILOG     ::alt_xcvr_sc_debug::callback_sim_verilog                  alt_xcvr_sc_debug}\
    {sim_vhdl        SIM_VHDL        ::alt_xcvr_sc_debug::callback_sim_vhdl                     alt_xcvr_sc_debug}\
  }


  # Declare the parameters using a nested list. First list is a header row.
  variable parameters {\
    {NAME                 TYPE     DERIVED HDL_PARAMETER DEFAULT_VALUE ALLOWED_RANGES                                                                 DISPLAY_HINT    DISPLAY_NAME                     ENABLED       VISIBLE   VALIDATION_CALLBACK}\
    {device_family        STRING   false   false         "Stratix 10"  NOVAL                                                                          NOVAL           NOVAL                            true          false     NOVAL}\
    {device               STRING   false   false         "Unknown"     NOVAL                                                                          NOVAL           NOVAL                            true          false     NOVAL}\
    {base_device          STRING   false   false         "Unknown"     NOVAL                                                                          NOVAL           NOVAL                            true          false     NOVAL}\
    {design_environment   STRING   false   false         "QSYS"        NOVAL                                                                          NOVAL           NOVAL                            true          false     NOVAL}\
    \
    {separate_interface   BOOLEAN  false   false         0             NOVAL                                                                          NOVAL           "Separate interfaces for status" true          true      NOVAL}\
    \
    {lcl_scratch_status   integer  false   false         1             NOVAL                                                                          NOVAL           "Number of scratch registers"    true          true      NOVAL}\
    {lcl_num_channels     integer  false   false         1             NOVAL                                                                          NOVAL           "Number of channels"             true          true      NOVAL}\
    {lcl_num_freq_chk     integer  false   false         1             NOVAL                                                                          NOVAL           "Number of frequency checkers"   true          true      NOVAL}\
    {lcl_num_ptrn_gen     integer  false   false         1             NOVAL                                                                          NOVAL           "Number of pattern generators"   true          true      NOVAL}\
    {lcl_num_ptrn_ver     integer  false   false         1             NOVAL                                                                          NOVAL           "Number of pattern verifiers"    true          true      NOVAL}\
    {lcl_num_plls         integer  false   false         1             NOVAL                                                                          NOVAL           "Number of plls"                 true          true      NOVAL}\
    {lcl_num_wrd_algn     integer  false   false         1             NOVAL                                                                          NOVAL           "Number of word aligners"        true          true      NOVAL}\
    \
    {scratch_status_reg   integer  true    true          1             NOVAL                                                                          NOVAL           NOVAL                            true          false     ::alt_xcvr_sc_debug::validate_scratch_status_reg}\
    {num_channels         integer  true    true          1             NOVAL                                                                          NOVAL           NOVAL                            true          false     ::alt_xcvr_sc_debug::validate_num_channels}\
    {num_freq_chk         integer  true    true          1             NOVAL                                                                          NOVAL           NOVAL                            true          false     ::alt_xcvr_sc_debug::validate_num_freq_chk}\
    {num_ptrn_gen         integer  true    true          1             NOVAL                                                                          NOVAL           NOVAL                            true          false     ::alt_xcvr_sc_debug::validate_num_ptrn_gen}\
    {num_ptrn_ver         integer  true    true          1             NOVAL                                                                          NOVAL           NOVAL                            true          false     ::alt_xcvr_sc_debug::validate_num_ptrn_ver}\
    {num_plls             integer  true    true          1             NOVAL                                                                          NOVAL           NOVAL                            true          false     ::alt_xcvr_sc_debug::validate_num_plls}\
    {num_wrd_algn         integer  true    true          1             NOVAL                                                                          NOVAL           NOVAL                            true          false     ::alt_xcvr_sc_debug::validate_num_wrd_algn}\
  }

  # Declare the ports and interfaces using a nested list. First list is a header row.
  variable interfaces {\
    {NAME                          DIRECTION UI_DIRECTION  WIDTH_EXPR                      ROLE                     TERMINATION                 TERMINATION_VALUE IFACE_NAME                   IFACE_TYPE        IFACE_DIRECTION DYNAMIC SPLIT                   SPLIT_WIDTH         SPLIT_COUNT   ELABORATION_CALLBACK }\
    {mgmt_clk                      input     input         1                               clk                      false                       NOVAL             mgmt_clk                     clock             sink            false   NOVAL                   NOVAL               NOVAL         NOVAL}\
    {jtag_reset                    output    output        1                               reset                    false                       NOVAL             jtag_reset                   reset             source          false   NOVAL                   NOVAL               NOVAL         ::alt_xcvr_sc_debug::elaborate_jtag_reset}\
    \
    {atso_start                    input     input         1                               atso_start               false                       NOVAL             atso_start                   conduit           end             false   NOVAL                   NOVAL               NOVAL         NOVAL}\
    {atso_fail                     input     input         1                               atso_fail                false                       NOVAL             atso_fail                    conduit           end             false   NOVAL                   NOVAL               NOVAL         NOVAL}\
    {atso_pass                     input     input         1                               atso_pass                false                       NOVAL             atso_pass                    conduit           end             false   NOVAL                   NOVAL               NOVAL         NOVAL}\
    \
    {pattern_ver_en                input     input         num_ptrn_ver                    pattern_ver_en           !lcl_num_ptrn_ver           NOVAL             pattern_ver_en               conduit           end             true    separate_interface      1                   num_ptrn_ver  NOVAL}\
    {pattern_ver_lock              input     input         num_ptrn_ver                    pattern_ver_lock         !lcl_num_ptrn_ver           NOVAL             pattern_ver_lock             conduit           end             true    separate_interface      1                   num_ptrn_ver  NOVAL}\
    {pattern_ver_err               input     input         num_ptrn_ver                    pattern_ver_err          !lcl_num_ptrn_ver           NOVAL             pattern_ver_err              conduit           end             true    separate_interface      1                   num_ptrn_ver  NOVAL}\
    \
    {pattern_gen_en                input     input         num_ptrn_gen                    pattern_gen_en           !lcl_num_ptrn_gen           NOVAL             pattern_gen_en               conduit           end             true    separate_interface      1                   num_ptrn_gen  NOVAL}\
    \
    {simple_wa_align               input     input         num_wrd_algn                    simple_wa_align          !lcl_num_wrd_algn           NOVAL             simple_wa_align              conduit           end             true    separate_interface      1                   num_wrd_algn  NOVAL}\
    {simple_wa_sync                input     input         num_wrd_algn                    simple_wa_sync           !lcl_num_wrd_algn           NOVAL             simple_wa_sync               conduit           end             true    separate_interface      1                   num_wrd_algn  NOVAL}\
    \
    {freq_measured                 input     input         num_freq_chk                    freq_measured            !lcl_num_freq_chk           NOVAL             freq_measured                conduit           end             true    separate_interface      1                   num_freq_chk  NOVAL}\
    {freq_start_cnt                input     input         num_freq_chk                    freq_start_cnt           !lcl_num_freq_chk           NOVAL             freq_start_cnt               conduit           end             true    separate_interface      1                   num_freq_chk  NOVAL}\
    {freq_count_value              input     input         num_freq_chk*16                 freq_count_value         !lcl_num_freq_chk           NOVAL             freq_count_value             conduit           end             true    separate_interface      16                  num_freq_chk  NOVAL}\
    \
    {tx_ready                      input     input         num_channels                    tx_ready                 !lcl_num_channels           NOVAL             tx_ready                     conduit           end             true    separate_interface      1                   num_channels  NOVAL}\
    {rx_ready                      input     input         num_channels                    rx_ready                 !lcl_num_channels           NOVAL             rx_ready                     conduit           end             true    separate_interface      1                   num_channels  NOVAL}\
    {rx_is_lockedtodata            input     input         num_channels                    rx_is_lockedtodata       !lcl_num_channels           NOVAL             rx_is_lockedtodata           conduit           end             true    separate_interface      1                   num_channels  NOVAL}\
    {rx_is_lockedtoref             input     input         num_channels                    rx_is_lockedtoref        !lcl_num_channels           NOVAL             rx_is_lockedtoref            conduit           end             true    separate_interface      1                   num_channels  NOVAL}\
    {tx_cal_busy                   input     input         num_channels                    tx_cal_busy              !lcl_num_channels           NOVAL             tx_cal_busy                  conduit           end             true    separate_interface      1                   num_channels  NOVAL}\
    {rx_cal_busy                   input     input         num_channels                    rx_cal_busy              !lcl_num_channels           NOVAL             rx_cal_busy                  conduit           end             true    separate_interface      1                   num_channels  NOVAL}\
    \
    {pll_locked                    input     input         num_plls                        pll_locked               !lcl_num_plls               NOVAL             pll_locked                   conduit           end             true    separate_interface      1                   num_plls      NOVAL}\
    {pll_cal_busy                  input     input         num_plls                        pll_cal_busy             !lcl_num_plls               NOVAL             pll_cal_busy                 conduit           end             true    separate_interface      1                   num_plls      NOVAL}\
    {scratch_input                 input     input         scratch_status_reg*32           scratch_input            !lcl_scratch_status         NOVAL             scratch_input                conduit           end             true    separate_interface      32                  scratch_status_reg NOVAL}\
    \
    {atso_output                   output    output        32                              atso_output              false                       NOVAL             atso_output                  conduit           end             false   NOVAL                   NOVAL               NOVAL         NOVAL}\
    {csr_reset                     output    output        1                               reset                    false                       NOVAL             csr_reset                    reset             source          false   NOVAL                   NOVAL               NOVAL         ::alt_xcvr_sc_debug::elaborate_csr_reset}\
  }
}

proc ::alt_xcvr_sc_debug::declare_module {} {
  variable interfaces
  variable parameters
  variable module
  variable filesets

  ip_declare_module $module
  ip_declare_filesets $filesets
  ip_declare_parameters $parameters
  ip_set_auto_conduit_in_native_mode 1
  ip_set_iface_split_suffix "_inst"
  ip_declare_interfaces $interfaces
}

proc ::alt_xcvr_sc_debug::elaborate_csr_reset { } {
  ip_set "interface.csr_reset.synchronousEdges" NONE
}

proc ::alt_xcvr_sc_debug::elaborate_jtag_reset { } {
  ip_set "interface.jtag_reset.synchronousEdges" NONE
}

proc ::alt_xcvr_sc_debug::alt_xcvr_sc_debug_val_callback {} {  
  ip_validate_parameters
}

proc ::alt_xcvr_sc_debug::alt_xcvr_sc_debug_elab_callback {} {
  ::alt_xcvr_sc_debug::elaborate_add_hdl_instance
  ip_elaborate_interfaces
}

proc ::alt_xcvr_sc_debug::validate_scratch_status_reg { lcl_scratch_status } {
  if { $lcl_scratch_status > 0 } {
    ip_set "parameter.scratch_status_reg.value" $lcl_scratch_status
  } else {
    ip_set "parameter.scratch_status_reg.value" 1
  }
}

proc ::alt_xcvr_sc_debug::validate_num_channels { lcl_num_channels } {
  if { $lcl_num_channels > 0 } {
    ip_set "parameter.num_channels.value" $lcl_num_channels
  } else {
    ip_set "parameter.num_channels.value" 1
  }
}

proc ::alt_xcvr_sc_debug::validate_num_freq_chk { lcl_num_freq_chk } {
  if { $lcl_num_freq_chk > 0 } {
    ip_set "parameter.num_freq_chk.value" $lcl_num_freq_chk
  } else {
    ip_set "parameter.num_freq_chk.value" 1
  }
}

proc ::alt_xcvr_sc_debug::validate_num_ptrn_gen { lcl_num_ptrn_gen } {
  if { $lcl_num_ptrn_gen > 0 } {
    ip_set "parameter.num_ptrn_gen.value" $lcl_num_ptrn_gen
  } else {
    ip_set "parameter.num_ptrn_gen.value" 1
  }
}

proc ::alt_xcvr_sc_debug::validate_num_ptrn_ver { lcl_num_ptrn_ver } {
  if { $lcl_num_ptrn_ver > 0 } {
    ip_set "parameter.num_ptrn_ver.value" $lcl_num_ptrn_ver
  } else {
    ip_set "parameter.num_ptrn_ver.value" 1
  }
}

proc ::alt_xcvr_sc_debug::validate_num_plls     { lcl_num_plls } {
  if { $lcl_num_plls > 0 } {
    ip_set "parameter.num_plls.value" $lcl_num_plls
  } else {
    ip_set "parameter.num_plls.value" 1
  }
}

proc ::alt_xcvr_sc_debug::validate_num_wrd_algn { lcl_num_wrd_algn } {
  if { $lcl_num_wrd_algn > 0 } {
    ip_set "parameter.num_wrd_algn.value" $lcl_num_wrd_algn
  } else {
    ip_set "parameter.num_wrd_algn.value" 1
  }
}

proc ::alt_xcvr_sc_debug::elaborate_add_hdl_instance {} {
  add_hdl_instance jtag_debug altera_jtag_debug_link
}

proc ::alt_xcvr_sc_debug::callback_quartus_synth { entity } {
  add_fileset_file ./alt_xcvr_sc_debug.sv       SYSTEMVERILOG PATH  ./alt_xcvr_sc_debug.sv
  add_fileset_file ./alt_xcvr_sc_debug_script.tcl     TCL     PATH  ./alt_xcvr_sc_debug_script.tcl
}

proc ::alt_xcvr_sc_debug::callback_sim_verilog { entity } {
  add_fileset_file ./alt_xcvr_sc_debug.sv       SYSTEMVERILOG PATH  ./alt_xcvr_sc_debug.sv
}

proc ::alt_xcvr_sc_debug::callback_sim_vhdl { entity } {
  add_fileset_file ./alt_xcvr_sc_debug.sv       SYSTEMVERILOG PATH  ./alt_xcvr_sc_debug.sv
}

::alt_xcvr_sc_debug::declare_module
