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



package provide altera_xcvr_cdr_pll_s10::interfaces 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::ip_tcl::ip_interfaces
package require altera_xcvr_cdr_pll_s10::interfaces::data

namespace eval ::altera_xcvr_cdr_pll_s10::interfaces:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::ip_tcl::messages::*
  namespace import ::alt_xcvr::ip_tcl::ip_interfaces::*

  namespace export \
    declare_interfaces \
    elaborate

  variable interfaces
  set interfaces [altera_xcvr_cdr_pll_s10::interfaces::data::get_variable "interfaces"]

}

proc ::altera_xcvr_cdr_pll_s10::interfaces::declare_interfaces {} {
  variable interfaces
  ip_declare_interfaces $interfaces
}

proc ::altera_xcvr_cdr_pll_s10::interfaces::elaborate {} {
  ip_elaborate_interfaces
}

proc ::altera_xcvr_cdr_pll_s10::interfaces::elaborate_direction { PROP_IFACE_NAME PROP_DIRECTION } {
  ip_set "interface.${PROP_IFACE_NAME}.assignment" [list "ui.blockdiagram.direction" $PROP_DIRECTION]
}

proc ::altera_xcvr_cdr_pll_s10::interfaces::elaborate_reconfig_reset { } {
  ip_set "interface.reconfig_reset0.associatedclock" reconfig_clk0
}

proc ::altera_xcvr_cdr_pll_s10::interfaces::elaborate_reconfig { device_revision } {
    set reconfig_clk   "reconfig_clk0"
    set reconfig_reset "reconfig_reset0"

	ip_set "interface.reconfig_avmm0.associatedclock" $reconfig_clk
  ip_set "interface.reconfig_avmm0.associatedreset" $reconfig_reset
	ip_set "interface.reconfig_avmm0.assignment" [list "debug.typeName" "altera_xcvr_cdr_pll_s10.slave"]
	ip_set "interface.reconfig_avmm0.assignment" [list "debug.param.device_revision" $device_revision]
}

