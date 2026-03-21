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



package provide altera_xcvr_cal_a10::interfaces 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages

namespace eval ::altera_xcvr_cal_a10::interfaces:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::ip_tcl::messages::*

  namespace export \
    declare_interfaces \
    elaborate

  variable interfaces


  set interfaces {\
    {NAME               DIRECTION WIDTH_EXPR          ROLE                TERMINATION           TERMINATION_VALUE SPLIT                 SPLIT_COUNT SPLIT_WIDTH         IFACE_NAME          IFACE_TYPE  IFACE_DIRECTION DYNAMIC ELABORATION_CALLBACK  }\
    {core_uc_clk        input     1                   clk                 false                 0                 NOVAL                 NOVAL       NOVAL               clock               clock       sink            false   NOVAL                 }\
    \
    {jtag_tdo           output    1                   jtag_tdo            !ENABLE_JTAG_DBG      0                 NOVAL                 NOVAL       NOVAL               jtag_tdo            conduit     end             true    ::altera_xcvr_cal_a10::interfaces::elaborate_direction  }\
    {jtag_tck           input     1                   jtag_tck            !ENABLE_JTAG_DBG      0                 NOVAL                 NOVAL       NOVAL               jtag_tck            conduit     end             true    ::altera_xcvr_cal_a10::interfaces::elaborate_direction  }\
    {jtag_tms           input     1                   jtag_tms            !ENABLE_JTAG_DBG      0                 NOVAL                 NOVAL       NOVAL               jtag_tms            conduit     end             true    ::altera_xcvr_cal_a10::interfaces::elaborate_direction  }\
    {jtag_tdi           input     1                   jtag_tdi            !ENABLE_JTAG_DBG      0                 NOVAL                 NOVAL       NOVAL               jtag_tdi            conduit     end             true    ::altera_xcvr_cal_a10::interfaces::elaborate_direction  }\
    \
    {dft_flag_up        output    1                   dft_flag_up         !ENABLE_DFT_SIGNALS   0                 NOVAL                 NOVAL       NOVAL               dft_flag_up         conduit     end             true    ::altera_xcvr_cal_a10::interfaces::elaborate_direction  }\
    {dft_flag_down      output    1                   dft_flag_down       !ENABLE_DFT_SIGNALS   0                 NOVAL                 NOVAL       NOVAL               dft_flag_down       conduit     end             true    ::altera_xcvr_cal_a10::interfaces::elaborate_direction  }\
    {dbg_dfx_out        output    1                   dbg_dfx_out         !ENABLE_DFX_SIGNALS   0                 NOVAL                 NOVAL       NOVAL               dbg_dfx_out         conduit     end             true    ::altera_xcvr_cal_a10::interfaces::elaborate_direction  }\
    {dbg_dfx_sel        input     1                   dbg_dfx_sel         !ENABLE_DFX_SIGNALS   0                 NOVAL                 NOVAL       NOVAL               dbg_dfx_sel         conduit     end             true    ::altera_xcvr_cal_a10::interfaces::elaborate_direction  }\
    {dbg_dfx_clk        input     1                   dbg_dfx_clk         !ENABLE_DFX_SIGNALS   0                 NOVAL                 NOVAL       NOVAL               dbg_dfx_clk         clock       sink            true    ::altera_xcvr_cal_a10::interfaces::elaborate_direction  }\
    \
    {core_interrupt_in  input     8                   core_interrupt_in   !ENABLE_SOFT_NIOS     0                 NOVAL                 NOVAL       NOVAL               core_interrupt_in   conduit     end             true    ::altera_xcvr_cal_a10::interfaces::elaborate_direction  }\
    {core_interrupt_out output    8                   core_interrupt_out  !ENABLE_SOFT_NIOS     0                 NOVAL                 NOVAL       NOVAL               core_interrupt_out  conduit     end             true    ::altera_xcvr_cal_a10::interfaces::elaborate_direction  }\
    \
    {aux_tx_50          input     5                   aux_tx_50           true                  NOVAL             NOVAL                 NOVAL       NOVAL               aux_tx_50           conduit     end             true    ::altera_xcvr_cal_a10::interfaces::elaborate_direction  }\
    {aux_rx_50          output    5                   aux_rx_50           true                  NOVAL             NOVAL                 NOVAL       NOVAL               aux_rx_50           conduit     end             true    ::altera_xcvr_cal_a10::interfaces::elaborate_direction  }\
  }

}

proc ::altera_xcvr_cal_a10::interfaces::declare_interfaces {} {
  variable interfaces
  ip_declare_interfaces $interfaces
}

proc ::altera_xcvr_cal_a10::interfaces::elaborate {} {
  ip_elaborate_interfaces
}


proc ::altera_xcvr_cal_a10::interfaces::elaborate_direction { PROP_IFACE_NAME PROP_DIRECTION } {
  ip_set "interface.${PROP_IFACE_NAME}.assignment" [list "ui.blockdiagram.direction" $PROP_DIRECTION]
}

proc ::altera_xcvr_cal_a10::interfaces::elaborate_reset {} {
  ip_set "interface.reset.synchronousEdges" NONE
}
