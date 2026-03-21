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


package provide altera_xcvr_atx_pll_vi::module 18.1

package require alt_xcvr::ip_tcl::ip_module
package require altera_xcvr_atx_pll_vi::parameters
package require altera_xcvr_atx_pll_vi::interfaces
package require altera_xcvr_atx_pll_vi::fileset

namespace eval ::altera_xcvr_atx_pll_vi::module:: {
   namespace import ::alt_xcvr::ip_tcl::ip_module::*

   namespace export \
      declare_module

   # Internal variables
   variable module {\
      {NAME                    VERSION                 SUPPORTED_DEVICE_FAMILIES           INTERNAL  ANALYZE_HDL EDITABLE  ELABORATION_CALLBACK                         DISPLAY_NAME                      GROUP            AUTHOR                DESCRIPTION DATASHEET_URL                                               DESCRIPTION }\
      {altera_xcvr_atx_pll_a10  18.1  {"Arria VI" "Arria10"}              false      false       false     ::altera_xcvr_atx_pll_vi::module::elaborate  "Transceiver ATX PLL Intel Arria 10 FPGA IP"    "Interface Protocols/Transceiver PLL"            "Intel Corporation"  NOVAL       "http://www.altera.com/literature/hb/arria-10/ug_arria10_xcvr_phy.pdf"   "Arria 10 Transceiver ATX PLL." }\
   }
}             

proc ::altera_xcvr_atx_pll_vi::module::declare_module {} {
   variable module
   ip_declare_module $module
   ::altera_xcvr_atx_pll_vi::fileset::declare_filesets
   ::altera_xcvr_atx_pll_vi::parameters::declare_parameters
   ::altera_xcvr_atx_pll_vi::interfaces::declare_interfaces
}

proc ::altera_xcvr_atx_pll_vi::module::elaborate {} {
   ::altera_xcvr_atx_pll_vi::parameters::validate
   ::altera_xcvr_atx_pll_vi::interfaces::elaborate
}      
