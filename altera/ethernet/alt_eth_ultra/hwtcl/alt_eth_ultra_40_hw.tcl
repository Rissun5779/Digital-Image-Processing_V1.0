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
lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/ethernet/alt_eth_ultra

package require -exact qsys 13.1
package require alt_eth_ultra::module

::alt_eth_ultra::module::declare_module 40

## Add documentation links for user guide and release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/nik1411172688901/nik1411172548649
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697853261
add_documentation_link "Example Design" https://www.altera.com/en_US/pdfs/literature/ug/deug_ll_40ge.pdf
