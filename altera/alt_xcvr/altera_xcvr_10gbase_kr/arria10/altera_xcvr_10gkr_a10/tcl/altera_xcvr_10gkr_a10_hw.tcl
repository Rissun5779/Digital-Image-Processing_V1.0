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
lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/altera_xcvr_10gbase_kr/arria10
lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/altera_xcvr_native_phy/sv

package require -exact qsys 13.0

package require altera_xcvr_10gkr_a10::module

set_module_property ALLOW_GREYBOX_GENERATION true 

::altera_xcvr_10gkr_a10::module::declare_module


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" "https://documentation.altera.com/#/link/nik1398707230472/nik1398706797771"
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697740509
