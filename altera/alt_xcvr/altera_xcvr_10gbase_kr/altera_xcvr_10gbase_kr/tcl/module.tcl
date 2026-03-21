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


package provide altera_xcvr_10gbase_kr::module 12.0

package require alt_xcvr::ip_tcl::ip_module 12.1
package require altera_xcvr_10gbase_kr::parameters
package require altera_xcvr_10gbase_kr::interfaces
package require altera_xcvr_10gbase_kr::fileset

namespace eval ::altera_xcvr_10gbase_kr::module:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*

  namespace export \
    declare_module

  # Internal variables
  variable module {\
    {NAME                     VERSION                 SUPPORTED_DEVICE_FAMILIES    INTERNAL HIDE_FROM_QSYS ANALYZE_HDL EDITABLE  ELABORATION_CALLBACK                          DISPLAY_NAME                          GROUP                                                         AUTHOR                DESCRIPTION                    DATASHEET_URL                                             }\
    {altera_xcvr_10gbase_kr   18.1  {"Stratix V"  "Arria V GZ"}  false    true           false       false     ::altera_xcvr_10gbase_kr::module::elaborate   "1G/10GbE and 10GBASE-KR PHY Intel FPGA IP"         "Interface Protocols/Ethernet/10G to 1G Multi-rate Ethernet"  "Altera Corporation"  "1G/10GE and 10GBASE-KR PHY"  "http://www.altera.com/literature/ug/xcvr_user_guide.pdf" }\
  }
}


proc ::altera_xcvr_10gbase_kr::module::declare_module {} {
  variable module
  ip_declare_module $module
  ::altera_xcvr_10gbase_kr::fileset::declare_filesets
  ::altera_xcvr_10gbase_kr::parameters::declare_parameters
  ::altera_xcvr_10gbase_kr::interfaces::declare_interfaces
}

proc ::altera_xcvr_10gbase_kr::module::elaborate {} {
  ::altera_xcvr_10gbase_kr::parameters::validate
  ::altera_xcvr_10gbase_kr::interfaces::elaborate
}

