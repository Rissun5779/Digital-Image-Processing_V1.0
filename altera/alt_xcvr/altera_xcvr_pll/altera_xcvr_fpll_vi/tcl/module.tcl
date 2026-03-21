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


# +-----------------------------------
# | request TCL package from other libraries
# | 
package provide altera_xcvr_fpll_vi::module 18.1
package require alt_xcvr::ip_tcl::ip_module
package require altera_xcvr_fpll_vi::parameters
package require altera_xcvr_fpll_vi::interfaces
package require altera_xcvr_fpll_vi::fileset
# +-----------------------------------
# | create CMU_FPLL module
# |
namespace eval ::altera_xcvr_fpll_vi::module:: {
   namespace import ::alt_xcvr::ip_tcl::ip_module::*
   namespace export \
      declare_module
	  
   # Internal variables
   variable module {\
      {NAME                    VERSION                  SUPPORTED_DEVICE_FAMILIES   INTERNAL   ANALYZE_HDL EDITABLE  PARAMETER_UPGRADE_CALLBACK               ELABORATION_CALLBACK                        DISPLAY_NAME                      GROUP                                            AUTHOR                DESCRIPTION DATASHEET_URL                                                            DESCRIPTION }\
      {altera_xcvr_fpll_a10     18.1  { "Arria VI" "Arria 10"}    false      false       false     ::altera_xcvr_fpll_vi::module::upgrade   ::altera_xcvr_fpll_vi::module::elaborate    "fPLL Intel Arria 10 FPGA IP"     "Interface Protocols/Transceiver PLL"            "Intel Corporation"  NOVAL       "http://www.altera.com/literature/hb/arria-10/ug_arria10_xcvr_phy.pdf"   "Arria 10 FPLL." }\
   }
}             

# +-----------------------------------
# | callback function to declare filesets and parameter lists
# | 
proc ::altera_xcvr_fpll_vi::module::declare_module {} {
   variable module
   
   ip_declare_module $module
   ::altera_xcvr_fpll_vi::fileset::declare_filesets
   ::altera_xcvr_fpll_vi::parameters::declare_parameters
   ::altera_xcvr_fpll_vi::interfaces::declare_interfaces
}
# +-----------------------------------
# | callback function to validate and elaborate IP
# |
proc ::altera_xcvr_fpll_vi::module::elaborate {} {
   ::altera_xcvr_fpll_vi::parameters::validate
   ::altera_xcvr_fpll_vi::interfaces::elaborate
}      

proc ::altera_xcvr_fpll_vi::module::upgrade {ip_core_type version parameters} {
	::altera_xcvr_fpll_vi::parameters::upgrade $ip_core_type $version $parameters
}
