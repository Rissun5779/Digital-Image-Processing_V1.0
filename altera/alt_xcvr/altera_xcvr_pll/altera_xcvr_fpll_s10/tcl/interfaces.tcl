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


## \file interfaces.tcl
# lists all the ports used in S10 FPLL IP, as well as associated validation callbacks
package provide altera_xcvr_fpll_s10::interfaces 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::ip_interfaces
package require alt_xcvr::ip_tcl::messages
package require mcgb_package_s10::mcgb

namespace eval ::altera_xcvr_fpll_s10::interfaces:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::ip_tcl::ip_interfaces::*
  namespace import ::alt_xcvr::ip_tcl::messages::*
  
  namespace export \
     declare_interfaces \
     elaborate
  
  variable interfaces
  
  set interfaces {\
    {NAME                  DIRECTION UI_DIRECTION  WIDTH_EXPR  ROLE              TERMINATION_VALUE       IFACE_NAME               IFACE_TYPE          IFACE_DIRECTION  TERMINATION                                    ELABORATION_CALLBACK }\
    {pll_powerdown         input     input         1           pll_powerdown     NOVAL                   pll_powerdown            conduit             end              "!enable_analog_resets && !in_pcie_hip_mode"   NOVAL                }\
    {pll_refclk0           input     input         1           clk               NOVAL                   pll_refclk0              clock               sink             "set_refclk_cnt<1"                             NOVAL                }\
    {pll_refclk1           input     input         1           clk               NOVAL                   pll_refclk1              clock               sink             "set_refclk_cnt<2"                             NOVAL                }\
    {pll_refclk2           input     input         1           clk               NOVAL                   pll_refclk2              clock               sink             "set_refclk_cnt<3"                             NOVAL                }\
    {pll_refclk3           input     input         1           clk               NOVAL                   pll_refclk3              clock               sink             "set_refclk_cnt<4"                             NOVAL                }\
    {pll_refclk4           input     input         1           clk               NOVAL                   pll_refclk4              clock               sink             "set_refclk_cnt<5"                             NOVAL                }\
    {tx_serial_clk         output    output        1           clk               NOVAL                   tx_serial_clk            hssi_serial_clock   start            "set_primary_use != 2"                         NOVAL                }\
    {outclk                output    output        1           clk               NOVAL                   outclk                   clock               start            "!outclk_en"                                   NOVAL                }\
    {unused_pllcout        output    output        3           clk               NOVAL                   unused_pllcout           conduit             start            true                                           NOVAL                }\
    {outclk_div1           output    output        1           clk               NOVAL                   outclk_div1              clock               start            "set_primary_use != 0"                         NOVAL                }\
    {outclk_div2           output    output        1           clk               NOVAL                   outclk_div2              clock               start            "set_primary_use != 0 || !set_x2_core_clock"   NOVAL                }\
    {outclk_div4           output    output        1           clk               NOVAL                   outclk_div4              clock               start            "set_primary_use != 0 || !set_x4_core_clock"   NOVAL                }\
    {pll_locked            output    output        1           pll_locked        NOVAL                   pll_locked               conduit             end              false                                          NOVAL                }\
    {pll_locked_hip        output    output        1           pll_locked_hip    NOVAL                   pll_locked_hip           conduit             end              "!enable_pcie_hip_connectivity"                NOVAL                }\
    \
    {pll_pcie_clk          output    output        1           pll_pcie_clk      NOVAL                   pll_pcie_clk             conduit             end              "!set_enable_hclk_out"                         NOVAL                }\
    {pll_cascade_clk       output    output        1           clk               NOVAL                   pll_cascade_clk          clock               start            "set_primary_use != 1"                         NOVAL                }\
    {atx_to_fpll_cascade_clk input   input         1           clk               NOVAL                   atx_to_fpll_cascade_clk  clock               sink             "set_atx_fpll_cascade_option!= 1"              NOVAL                }\
    \
    {reconfig_clk0         input     input         1           clk               NOVAL                   reconfig_clk0            clock               sink             "!rcfg_enable"                                 NOVAL                }\
    {reconfig_reset0       input     input         1           reset             NOVAL                   reconfig_reset0          reset               sink             "!rcfg_enable"                                 ::altera_xcvr_fpll_s10::interfaces::elaborate_reconfig_reset  }\
    {reconfig_write0       input     input         1           write             NOVAL                   reconfig_avmm0           avalon              slave            "!rcfg_enable"                                 ::altera_xcvr_fpll_s10::interfaces::elaborate_reconfig }\
    {reconfig_read0        input     input         1           read              NOVAL                   reconfig_avmm0           avalon              slave            "!rcfg_enable"                                 NOVAL                }\
    {reconfig_address0     input     input         11          address           NOVAL                   reconfig_avmm0           avalon              slave            "!rcfg_enable"                                 NOVAL                }\
    {reconfig_writedata0   input     input         32          writedata         NOVAL                   reconfig_avmm0           avalon              slave            "!rcfg_enable"                                 NOVAL                }\
    {reconfig_readdata0    output    output        32          readdata          NOVAL                   reconfig_avmm0           avalon              slave            "!rcfg_enable"                                 NOVAL                }\
    {reconfig_waitrequest0 output    output        1           waitrequest       NOVAL                   reconfig_avmm0           avalon              slave            "!rcfg_enable"                                 NOVAL                }\
    {avmm_busy0            output    output        1           avmm_busy0        NOVAL                   avmm_busy0               conduit             end              "!rcfg_enable || !rcfg_enable_avmm_busy_port || !enable_advanced_avmm_options" NOVAL                }\
    \
    {phase_reset           input     input         1           phase_reset       NOVAL                   phase_reset              conduit             sink             "!set_enable_dps"                              NOVAL                }\
    {phase_enable          input     input         1           phase_enable      NOVAL                   phase_enable             conduit             sink             "!set_enable_dps"                              NOVAL                }\
    {updn                  input     input         1           updn              NOVAL                   updn                     conduit             sink             "!set_enable_dps"                              NOVAL                }\
    {cntsel                input     input         4           cntsel            NOVAL                   cntsel                   conduit             sink             "!set_enable_dps"                              NOVAL                }\
    {num_phase_shifts      input     input         3           num_phase_shifts  NOVAL                   num_phase_shifts         conduit             sink             "!set_enable_dps"                              NOVAL                }\
    {phase_done            output    output        1           phase_done        NOVAL                   phase_done               conduit             end              "!set_enable_dps"                              NOVAL                }\
    \
    {pll_cal_busy          output    output        1           pll_cal_busy      NOVAL                   pll_cal_busy             conduit             end              "!enable_pld_fpll_cal_busy_port"               NOVAL                }\
    {hip_cal_done          output    output        1           hip_cal_done      NOVAL                   hip_cal_done             conduit             end              "!enable_hip_cal_done_port"                    NOVAL                }\
    {mcgb_hip_cal_done     output    output        1           mcgb_hip_cal_done NOVAL                   mcgb_hip_cal_done        conduit             end              "!enable_mcgb_hip_cal_done_port"               NOVAL                }\
    \
    {clklow                output    output        1           debug             NOVAL                   debug_clklow             conduit             end              "!enable_debug_ports_parameters"               NOVAL                }\
    {fref                  output    output        1           debug             NOVAL                   debug_fref               conduit             end              "!enable_debug_ports_parameters"               NOVAL                }\
  }
}

proc ::altera_xcvr_fpll_s10::interfaces::declare_interfaces {} {
   variable interfaces
   ip_declare_interfaces $interfaces
   ::mcgb_package_s10::mcgb::declare_mcgb_interfaces
}

proc ::altera_xcvr_fpll_s10::interfaces::elaborate {} {
   ip_elaborate_interfaces
}

proc ::altera_xcvr_fpll_s10::interfaces::elaborate_reconfig_reset { } {
  ip_set "interface.reconfig_reset0.associatedclock" reconfig_clk0
}

proc ::altera_xcvr_fpll_s10::interfaces::elaborate_reconfig { } {
    set reconfig_clk "reconfig_clk0"
    set reconfig_reset "reconfig_reset0"

      ip_set "interface.reconfig_avmm0.associatedclock" $reconfig_clk
    ip_set "interface.reconfig_avmm0.associatedreset" $reconfig_reset
    ip_set "interface.reconfig_avmm0.assignment" [list "debug.typeName" "altera_xcvr_fpll_a10.slave"]
}
