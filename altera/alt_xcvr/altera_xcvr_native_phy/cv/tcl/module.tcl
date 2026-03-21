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


package provide altera_xcvr_native_cv::module 18.1

package require alt_xcvr::ip_tcl::ip_module 12.1
package require altera_xcvr_native_cv::parameters
package require altera_xcvr_native_cv::interfaces
package require altera_xcvr_native_cv::fileset

namespace eval ::altera_xcvr_native_cv::module:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*

  namespace export \
    declare_module

  # Internal variables
  variable module {\
    {NAME                   VERSION                 INTERNAL  ANALYZE_HDL EDITABLE  ELABORATION_CALLBACK                        PARAMETER_UPGRADE_CALLBACK                    DISPLAY_NAME                        GROUP                                 AUTHOR                DESCRIPTION DATASHEET_URL                                           DESCRIPTION  }\
    {altera_xcvr_native_cv  18.1  true      false       false     ::altera_xcvr_native_cv::module::elaborate  ::altera_xcvr_native_cv::parameters::upgrade  "Transceiver Native PHY Intel Cyclone V FPGA IP"  "Interface Protocols/Transceiver PHY" "Intel Corporation"  NOVAL       "http://www.altera.com/literature/ug/xcvr_user_guide.pdf" "Cyclone V Transceiver Native PHY."}\
  }
}


proc ::altera_xcvr_native_cv::module::declare_module {} {
  variable module
  ip_declare_module $module
  ::altera_xcvr_native_cv::fileset::declare_filesets
  ::altera_xcvr_native_cv::parameters::declare_parameters
  ::altera_xcvr_native_cv::interfaces::declare_interfaces
}

proc ::altera_xcvr_native_cv::module::elaborate {} {
  ::altera_xcvr_native_cv::parameters::validate
  ::altera_xcvr_native_cv::interfaces::elaborate
}

