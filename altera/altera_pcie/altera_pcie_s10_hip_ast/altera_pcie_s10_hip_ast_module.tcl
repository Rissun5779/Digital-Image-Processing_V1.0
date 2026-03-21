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


package provide altera_pcie_s10_hip_ast::module 18.1

package require alt_xcvr::ip_tcl::ip_module
package require altera_pcie_s10_hip_ast::parameters
package require altera_pcie_s10_hip_ast::interfaces
package require altera_pcie_s10_hip_ast::fileset

namespace eval ::altera_pcie_s10_hip_ast::module:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*

  namespace export \
    declare_module

  # Internal variables
  # TODO Link to user guide PDF needs to be updated
  variable module {\
    {NAME                          VERSION                 SUPPORTED_DEVICE_FAMILIES INTERNAL  ANALYZE_HDL EDITABLE  ELABORATION_CALLBACK                                            DISPLAY_NAME                                   GROUP                             AUTHOR                DESCRIPTION DATASHEET_URL                                        DESCRIPTION                                 HIDE_FROM_QSYS  HIDE_FROM_QUARTUS }\
    {altera_pcie_s10_hip_ast   18.1                 {"Stratix 10"}                  false     false       false    ::altera_pcie_s10_hip_ast::module::elaborate                     "Avalon-ST Stratix 10 Hard IP for PCI Express" "Interface Protocols/PCI Express" "Altera Corporation"  NOVAL       "http://www.altera.com/literature/ug/ug_s10_pcie.pdf" "Avalon-ST Stratix 10 Hard IP for PCI Express"     false           false             }\
  }
}

proc ::altera_pcie_s10_hip_ast::module::declare_module {} {
  variable module
  ip_declare_module $module

  ::altera_pcie_s10_hip_ast::parameters::declare_parameters
  ::altera_pcie_s10_hip_ast::fileset::declare_filesets
  ::altera_pcie_s10_hip_ast::interfaces::declare_interfaces
}

proc ::altera_pcie_s10_hip_ast::module::elaborate {} {
  ::altera_pcie_s10_hip_ast::parameters::validate
  ::altera_pcie_s10_hip_ast::interfaces::elaborate
  ::altera_pcie_s10_hip_ast::parameters::setup_testbench
  ::altera_pcie_s10_hip_ast::fileset::declare_pllnphy_fileset
}

