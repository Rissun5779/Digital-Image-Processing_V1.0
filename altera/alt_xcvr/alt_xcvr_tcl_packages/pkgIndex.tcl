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



# GUI
package ifneeded alt_xcvr::gui::pll_reconfig 11.1 [list source [file join $dir gui pll_reconfig.tcl]]
package ifneeded alt_xcvr::gui::messages 11.1 [list source [file join $dir gui messages.tcl]]
package ifneeded alt_xcvr::gui::pll_nf_common_parameters 18.1 [list source [file join $dir pll_nf_common_parameters.tcl]]

# Utilities
package ifneeded alt_xcvr::utils::rbc 11.1 [list source [file join $dir utils rbc.tcl]]
package ifneeded alt_xcvr::utils::common 18.1 [list source [file join $dir utils common.tcl]]
package ifneeded alt_xcvr::utils::device 18.1 [list source [file join $dir utils device.tcl]]
package ifneeded alt_xcvr::utils::fileset 11.1 [list source [file join $dir utils fileset.tcl]]
package ifneeded alt_xcvr::utils::params_and_ports 11.1 [list source [file join $dir utils params_and_ports.tcl]]
package ifneeded alt_xcvr::utils::ipgen 13.0 [list source [file join $dir utils ipgen.tcl]]
package ifneeded alt_xcvr::utils::reconfiguration_arria10 18.1 [list source [file join $dir utils reconfiguration_arria10.tcl]]
package ifneeded alt_xcvr::utils::reconfiguration_stratix10 18.1 [list source [file join $dir utils reconfiguration_stratix10.tcl]]

# System console scripts
package ifneeded alt_xcvr::system_console::alt_xcvr_reconfig_if 12.0 [list source [file join $dir system_console alt_xcvr_reconfig_if.tcl]]
package ifneeded alt_xcvr::system_console::alt_xcvr_reconfig_analog 12.0 [list source [file join $dir system_console alt_xcvr_reconfig_analog.tcl]]
package ifneeded alt_xcvr::system_console::alt_xcvr_reconfig_mif 12.0 [list source [file join $dir system_console alt_xcvr_reconfig_mif.tcl]]

# ip_tcl
package ifneeded alt_xcvr::ip_tcl::ip_module 13.0 [list source [file join $dir ip_tcl ip_module.tcl]]
package ifneeded alt_xcvr::ip_tcl::ip_module 12.1 [list source [file join $dir ip_tcl ip_module_12_1.tcl]]
package ifneeded alt_xcvr::ip_tcl::ip_interfaces 18.1 [list source [file join $dir ip_tcl ip_interfaces.tcl]]
package ifneeded alt_xcvr::ip_tcl::messages  18.1 [list source [file join $dir ip_tcl messages.tcl]]
package ifneeded alt_xcvr::ip_tcl::file_utils 18.1 [list source [file join $dir ip_tcl file_utils.tcl]]

# de_tcl
package ifneeded alt_xcvr::de_tcl::de_api               18.1     [list source [file join $dir  de_tcl  de_api.tcl]]
package ifneeded alt_xcvr::de_tcl::framework            18.1     [list source [file join $dir  de_tcl  framework.tcl]]
package ifneeded alt_xcvr::de_tcl::data                 18.1     [list source [file join $dir  de_tcl  data.tcl]]
package ifneeded alt_xcvr::de_tcl::DE_TCL_CONSTANTS     18.1     [list source [file join $dir  de_tcl  DE_TCL_CONSTANTS.tcl]]
package ifneeded alt_xcvr::de_tcl::qsys_conversion      18.1     [list source [file join $dir  de_tcl  qsys_conversion.tcl]]

