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

source nf/tcl/nf_hssi_parameters.tcl
source nf/tcl/nf_hssi_common_util.tcl
source nf/tcl/nf_hssi_gen3_x8_pcie_hip_rbc.tcl
source altera_pcie_a10_hip_parameters.tcl
source altera_pcie_a10_hip_interfaces.tcl
source altera_pcie_a10_hip_fileset.tcl
source altera_pcie_a10_hip_module.tcl

package require altera_pcie_a10_hip::module

::altera_pcie_a10_hip:::module::declare_module


## Add documentation links for user guide and/or release notes
add_documentation_link "Arria 10 Avalon-ST Interface for PCIe Solutions User Guide" https://documentation.altera.com/#/link/lbl1414599283601/nik1410905278518
add_documentation_link "Arria 10 Avalon-ST Hard IP for PCI Express Design Example User Guide" https://documentation.altera.com/#/link/owv1467062573484/lbl1441208916409
add_documentation_link "Arria 10 Avalon-MM Interface for PCIe Solutions User Guide" https://documentation.altera.com/#/link/lbl1415230609011/nik1410905278518
add_documentation_link "Arria 10 Avalon-MM  Hard IP for PCI Express Design Example User Guide" https://documentation.altera.com/#/link/xtq1467072880606/lbl1441208916409
add_documentation_link "Arria 10 Avalon-MM DMA Interface for PCIe Solutions User Guide" https://documentation.altera.com/#/link/lbl1415138844137/nik1410905278518
add_documentation_link "Getting Started with the Avalon-MM DMA Design Example" https://documentation.altera.com/#/link/lbl1415138844137/nik1410905310368
add_documentation_link "Arria 10 Avalon-ST Interface with SR-IOV PCIe Solutions User Guide" https://documentation.altera.com/#/link/lbl1415123763821/nik1410905278518
add_documentation_link "Getting Started with the SR-IOV Design Example" https://documentation.altera.com/#/link/lbl1415123763821/lbl1443202387473
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697756668

## FB 401691
set_qip_strings {"set_instance_assignment -entity %entityName% -library %libraryName% -name MESSAGE_DISABLE 332088"}
