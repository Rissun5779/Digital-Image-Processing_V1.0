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
# lists all the ports used in NF ATX PLL IP, as well as associated validation callbacks
package provide altera_xcvr_atx_pll_vi::interfaces 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::ip_interfaces
package require alt_xcvr::ip_tcl::messages
package require mcgb_package_vi::mcgb

namespace eval ::altera_xcvr_atx_pll_vi::interfaces:: {
   namespace import ::alt_xcvr::ip_tcl::ip_module::*
   namespace import ::alt_xcvr::ip_tcl::ip_interfaces::*
   namespace import ::alt_xcvr::ip_tcl::messages::*
   
   namespace export \
      declare_interfaces \
      elaborate
   
   variable interfaces
   
   set interfaces {\
      {NAME                  DIRECTION UI_DIRECTION  WIDTH_EXPR         ROLE              TERMINATION_VALUE  IFACE_NAME        IFACE_TYPE         IFACE_DIRECTION  TERMINATION                                                       ELABORATION_CALLBACK }\
      {pll_powerdown         input     input         1                  pll_powerdown     NOVAL              pll_powerdown     conduit            end              false                                                             NOVAL                }\
      {pll_refclk0           input     input         1                  clk               NOVAL              pll_refclk0       clock              sink             "refclk_cnt<1"                                                    NOVAL                }\
      {pll_refclk1           input     input         1                  clk               NOVAL              pll_refclk1       clock              sink             "refclk_cnt<2"                                                    NOVAL                }\
      {pll_refclk2           input     input         1                  clk               NOVAL              pll_refclk2       clock              sink             "refclk_cnt<3"                                                    NOVAL                }\
      {pll_refclk3           input     input         1                  clk               NOVAL              pll_refclk3       clock              sink             "refclk_cnt<4"                                                    NOVAL                }\
      {pll_refclk4           input     input         1                  clk               NOVAL              pll_refclk4       clock              sink             "refclk_cnt<5"                                                    NOVAL                }\
      {tx_serial_clk         output    output        1                  clk               NOVAL              tx_serial_clk     hssi_serial_clock  start            "!enable_8G_path"                                                 NOVAL                }\
      {tx_serial_clk_gt      output    output        1                  clk               NOVAL              tx_serial_clk_gt  hssi_serial_clock  start            "!enable_16G_path"                                                NOVAL                }\
      {pll_locked            output    output        1                  pll_locked        NOVAL              pll_locked        conduit            end              "enable_atx_to_fpll_cascade_out"                                  NOVAL                }\
      \
      {pll_pcie_clk          output    output        1                  pll_pcie_clk      NOVAL              pll_pcie_clk      conduit            end              "!enable_pcie_clk"                                                NOVAL                }\
      {pll_cascade_clk       output    output        1                  clk               NOVAL              pll_cascade_clk   clock              source           "!enable_cascade_out"                                             NOVAL                }\
      {atx_to_fpll_cascade_clk output  output        1                  clk               NOVAL              atx_to_fpll_cascade_clk clock        source           "!enable_atx_to_fpll_cascade_out"                                 NOVAL                }\
      \
      {reconfig_clk0         input     input         1                  clk               NOVAL              reconfig_clk0     clock              sink             "!enable_pll_reconfig"                                            NOVAL                }\
      {reconfig_reset0       input     input         1                  reset             NOVAL              reconfig_reset0   reset              sink             "!enable_pll_reconfig"                                            ::altera_xcvr_atx_pll_vi::interfaces::elaborate_reconfig_reset  }\
      {reconfig_write0       input     input         1                  write             NOVAL              reconfig_avmm0    avalon             slave            "!enable_pll_reconfig"                                            ::altera_xcvr_atx_pll_vi::interfaces::elaborate_reconfig }\
      {reconfig_read0        input     input         1                  read              NOVAL              reconfig_avmm0    avalon             slave            "!enable_pll_reconfig"                                            NOVAL                }\
      {reconfig_address0     input     input         10                 address           NOVAL              reconfig_avmm0    avalon             slave            "!enable_pll_reconfig"                                            NOVAL                }\
      {reconfig_writedata0   input     input         32                 writedata         NOVAL              reconfig_avmm0    avalon             slave            "!enable_pll_reconfig"                                            NOVAL                }\
      {reconfig_readdata0    output    output        32                 readdata          NOVAL              reconfig_avmm0    avalon             slave            "!enable_pll_reconfig"                                            NOVAL                }\
      {reconfig_waitrequest0 output    output        1                  waitrequest       NOVAL              reconfig_avmm0    avalon             slave            "!enable_pll_reconfig"                                            NOVAL                }\
      {avmm_busy0            output    output        1                  avmm_busy0        NOVAL              avmm_busy0        conduit            end              "!enable_pll_reconfig || !rcfg_enable_avmm_busy_port || !enable_advanced_avmm_options" NOVAL                }\
      {pll_cal_busy          output    output        1                  pll_cal_busy      NOVAL              pll_cal_busy      conduit            end              "!enable_pld_atx_cal_busy_port"                                   NOVAL                }\
      {hip_cal_done          output    output        1                  hip_cal_done      NOVAL              hip_cal_done      conduit            end              "!enable_hip_cal_done_port"                                       NOVAL                }\
      \
      {clklow                output    output        1                  clk               NOVAL            ext_lock_detect_clklow conduit            end              "!enable_ext_lockdetect_ports"                                  NOVAL                }\
      {fref                  output    output        1                  clk               NOVAL            ext_lock_detect_fref conduit            end              "!enable_ext_lockdetect_ports"                                  NOVAL                }\
      {overrange             output    output        1                  debug             NOVAL              debug             conduit            end              "!enable_debug_ports_parameters"                                  NOVAL                }\
      {underrange            output    output        1                  debug             NOVAL              debug             conduit            end              "!enable_debug_ports_parameters"                                  NOVAL                }\
   }
}

proc ::altera_xcvr_atx_pll_vi::interfaces::declare_interfaces {} {
   variable interfaces
   ip_declare_interfaces $interfaces
   ::mcgb_package_vi::mcgb::declare_mcgb_interfaces
}

proc ::altera_xcvr_atx_pll_vi::interfaces::elaborate {} {
   ip_elaborate_interfaces
}

proc ::altera_xcvr_atx_pll_vi::interfaces::elaborate_reconfig_reset { } {
  ip_set "interface.reconfig_reset0.associatedclock" reconfig_clk0
}

proc ::altera_xcvr_atx_pll_vi::interfaces::elaborate_reconfig { device_revision } {
    set reconfig_clk "reconfig_clk0"
    set reconfig_reset "reconfig_reset0"

	ip_set "interface.reconfig_avmm0.associatedclock" $reconfig_clk
    ip_set "interface.reconfig_avmm0.associatedreset" $reconfig_reset	ip_set "interface.reconfig_avmm0.assignment" [list "debug.typeName" "altera_xcvr_atx_pll_a10.slave"]	ip_set "interface.reconfig_avmm0.assignment" [list "debug.param.device_revision" $device_revision]
}



