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


package provide altera_xcvr_10gkr_a10::module 18.1

package require alt_xcvr::ip_tcl::ip_module 
package require altera_xcvr_10gkr_a10::parameters
package require altera_xcvr_10gkr_a10::interfaces
package require altera_xcvr_10gkr_a10::fileset

namespace eval ::altera_xcvr_10gkr_a10::module:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*

  namespace export \
    declare_module

  # Internal variables
  variable module {\
    {NAME                    VERSION                SUPPORTED_DEVICE_FAMILIES HIDE_FROM_QSYS INTERNAL  ANALYZE_HDL EDITABLE  ELABORATION_CALLBACK                        PARAMETER_UPGRADE_CALLBACK                                DISPLAY_NAME                                                     GROUP                                                         AUTHOR                DESCRIPTION                    DATASHEET_URL                                             }\
    {altera_xcvr_10gkr_a10   18.1  {"Arria 10"}             true           false     false       false     ::altera_xcvr_10gkr_a10::module::elaborate  ::altera_xcvr_10gkr_a10::parameters::upgrade   "1G/10GbE and 10GBASE-KR PHY Intel Arria 10 FPGA IP"       "Interface Protocols/Ethernet/10G to 1G Multi-rate Ethernet"  "Altera Corporation"  "1G/10GE and 10GBASE-KR PHY"  "http://www.altera.com/literature/hb/arria-10/ug_arria10_xcvr_phy.pdf" }\
  }
}


proc ::altera_xcvr_10gkr_a10::module::declare_module {} {
  variable module
  ip_declare_module $module
  ::altera_xcvr_10gkr_a10::fileset::declare_filesets
  ::altera_xcvr_10gkr_a10::parameters::declare_parameters
  ::altera_xcvr_10gkr_a10::interfaces::declare_interfaces
}

proc ::altera_xcvr_10gkr_a10::module::elaborate {} {
  ::altera_xcvr_10gkr_a10::fileset::generate_native_phy
  # tell Quartus that Arrays in the reconfig module are not RAM/ROM
  set_qip_strings {"set_instance_assignment -name AUTO_RAM_RECOGNITION -entity rcfg_top -to | off" "set_instance_assignment -name AUTO_ROM_RECOGNITION -entity rcfg_top -to | off"}
  ::altera_xcvr_10gkr_a10::parameters::validate
  ::altera_xcvr_10gkr_a10::interfaces::elaborate
}

