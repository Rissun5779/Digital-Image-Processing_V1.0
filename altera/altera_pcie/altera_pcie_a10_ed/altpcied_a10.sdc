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


# SDC constraints for PCIe A10 HIP design example
# derive_pll_clock is used to calculate all clock derived from PCIe refclk
#  the derive_pll_clocks and derive clock_uncertainty should only
# be applied once across all of the SDC files used in a project
#derive_pll_clocks -create_base_clocks
#
## HIP testin pins SDC constraints
#if { [get_collection_size [get_pins -compatibility_mode *hip_ctrl*]]  ne 0 } {
#   set_false_path -from [get_pins -compatibility_mode *hip_ctrl*]
#}
set_multicycle_path -setup -through [get_pins -compatibility_mode -nocase {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys|tl_cfg_add[*]}] 2 
set_multicycle_path -hold  -through [get_pins -compatibility_mode -nocase {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys|tl_cfg_add[*]}] 2 
set_multicycle_path -setup -through [get_pins -compatibility_mode -nocase {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys|tl_cfg_ctl[*]}] 2 
set_multicycle_path -hold  -through [get_pins -compatibility_mode -nocase {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys|tl_cfg_ctl[*]}] 2