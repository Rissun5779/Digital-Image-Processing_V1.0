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


##############################################################################
# derive_pll_clock is used to calculate all clock derived from PCIe refclk
# the derive_pll_clocks and derive clock_uncertainty should only
# be applied once across all of the SDC files used in a project
derive_pll_clocks -create_base_clocks
derive_clock_uncertainty

##############################################################################
# PHY IP reconfig controller constraints
# Set reconfig_xcvr clock
# this line will likely need to be modified to match the actual clock pin name
# used for this clock, and also changed to have the correct period set for the actually used clock
# QSYS Design example has 2 clock pins
#  PCIe refclk
create_clock -period "100 MHz" -name {refclk_clk} {refclk_clk}

#  Phy IP Reconfig clk
create_clock -period "125 MHz" -name {xcvr_pcie_phy_clk} {reconfig_xcvr_clk_clk}

if { [get_collection_size [get_clocks {altera_reserved_tck}] ] eq 1 } {
   set_false_path -from [get_clocks {xcvr_pcie_phy_clk}] -to [get_clocks {altera_reserved_tck}]
}

if { [get_collection_size [get_clocks {*|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|coreclkout}] ] eq 1 } {
   set_false_path -from [get_clocks {xcvr_pcie_phy_clk}]  -to [get_clocks {*|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|coreclkout}]
   set_false_path -from [get_clocks {*|altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip|coreclkout}]  -to  [get_clocks {xcvr_pcie_phy_clk}]
} elseif { [get_collection_size [get_clocks {*|altpcie_av_hip_128bit_atom|cyclonev_hd_altpe2_hip_top|coreclkout}] ] eq 1 } {
   set_false_path -from [get_clocks {xcvr_pcie_phy_clk}]  -to [get_clocks {*|altpcie_av_hip_128bit_atom|cyclonev_hd_altpe2_hip_top|coreclkout}]
   set_false_path -from [get_clocks {*|altpcie_av_hip_128bit_atom|cyclonev_hd_altpe2_hip_top|coreclkout}] -to  [get_clocks {xcvr_pcie_phy_clk}]
} elseif { [get_collection_size [get_clocks {*|altpcie_av_hip_128bit_atom|arriav_hd_altpe2_hip_top|coreclkout}] ] eq 1 } {
   set_false_path -from [get_clocks {xcvr_pcie_phy_clk}]  -to [get_clocks {*|altpcie_av_hip_128bit_atom|arriav_hd_altpe2_hip_top|coreclkout}]
   set_false_path -from [get_clocks {*|altpcie_av_hip_128bit_atom|arriav_hd_altpe2_hip_top|coreclkout}] -to [get_clocks {xcvr_pcie_phy_clk}]
}

if { [get_collection_size [get_clocks {*pll_coreclkout_hip*PLL_OUTPUT_COUNTER|divclk}]] eq 1 } {
   set_false_path -from [get_clocks {xcvr_pcie_phy_clk}]  -to [get_clocks {*pll_coreclkout_hip*PLL_OUTPUT_COUNTER|divclk}]
   set_false_path -from [get_clocks {*pll_coreclkout_hip*PLL_OUTPUT_COUNTER|divclk}]  -to  [get_clocks {xcvr_pcie_phy_clk}]
}

set_false_path -from [ get_pins -compatibility {*stratixv_hssi_gen3_pcie_hip|testinhip[*]}]
set_false_path -from [ get_pins -compatibility {*stratixv_hssi_gen3_pcie_hip|testin1hip[*]}]
set_false_path -from [ get_pins -compatibility {*arriav_hd_altpe2_hip_top|testinhip[*]}]

if { [get_collection_size [get_ports {*_hip_ctrl_*}]] ne 0 } {
   set_false_path -from [get_ports {*_hip_ctrl_*}]
}
if { [get_collection_size [get_ports {*_hip_pipe_*}]] ne 0 } {
   set_false_path -from [get_ports {*_hip_pipe_*}]
}

