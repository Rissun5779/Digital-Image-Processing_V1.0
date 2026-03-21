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


lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/alt_xcvr_tcl_packages
package require -exact qsys 13.1
package require -exact alt_xcvr::ip_tcl::ip_module 13.0
package require alt_xcvr::ip_tcl::messages
namespace import ::alt_xcvr::ip_tcl::ip_module::*
namespace import ::alt_xcvr::ip_tcl::messages::*





source altera_pcie_s10_hip_common.tcl
source altera_pcie_s10_hip_ast_parameters.tcl
source altera_pcie_s10_hip_ast_interfaces.tcl
source altera_pcie_s10_hip_ast_fileset.tcl
source altera_pcie_s10_hip_ast_module.tcl

package require altera_pcie_s10_hip_ast::module

::altera_pcie_s10_hip_ast:::module::declare_module

