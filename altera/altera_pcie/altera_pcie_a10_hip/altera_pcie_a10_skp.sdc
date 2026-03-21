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


#for {set i 0} {$i != 8} {incr i} {
#   create_generated_clock -divide_by 1 -source "*|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_xcvr.g_phy_g3x*.phy_g3x*|phy_g3x*|g_xcvr_native_insts[$i].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs|byte_deserializer_pcs_clk_div_by_2_txclk_reg" "dut|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_xcvr.g_phy_g3x*.phy_g3x*|phy_g3x*|g_xcvr_native_insts[$i].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs|sta_rx_clk2_by2_1" -name "rx_pcs_clk_div_by_4[$i]"
#   create_generated_clock -multiply_by 1 -divide_by 1 -source "*|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_xcvr.g_phy_g3x*.phy_g3x*|phy_g3x*|g_xcvr_native_insts[$i].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_tx_pcs.inst_twentynm_hssi_8g_tx_pcs|byte_serializer_pcs_clk_div_by_2_reg" "dut|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_xcvr.g_phy_g3x*.phy_g3x*|phy_g3x*|g_xcvr_native_insts[$i].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_tx_pcs.inst_twentynm_hssi_8g_tx_pcs|sta_tx_clk2_by2_1" -name "tx_pcs_clk_div_by_4[$i]"
#}

remove_clock "dut|tx_bonding_clocks[0]"
#create_generated_clock -multiply_by 1 -divide_by 10 "*|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_pll.g_pll_g3n.lcpll_g3xn|lcpll_g3xn|a10_xcvr_atx_pll_inst|twentynm_hssi_pma_cgb_master_inst|cpulse_out_bus[0]" -source "*|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_pll.g_pll_g3n.lcpll_g3xn|lcpll_g3xn|a10_xcvr_atx_pll_inst|twentynm_hssi_pma_cgb_master_inst|clk_fpll_b" -master_clock "dut|tx_serial_clk" -name "dut|tx_bonding_clocks[0]"

#set_multicycle_path -setup -through [get_pins -compatibility_mode {*pld_rx_data*}] 0

foreach_in_collection mpin [get_pins -compatibility_mode {*pld_rx_data*}]  {
	set mpin_name [get_pin_info -name $mpin]
	if [string match "*altpcie_a10_hip_pipen1b*" $mpin_name] {
		set_multicycle_path -setup -through $mpin 0
	}
}


set rx_clkouts [list]
#for {set i 0} {$i != 8} {incr i} {
#	remove_clock "dut\|g_xcvr_native_insts\[$i\]\|rx_clk"
#	remove_clock "dut\|g_xcvr_native_insts\[$i\]\|rx_clkout"
#	
#	create_generated_clock -multiply_by 1 -source  "*\|altpcie_a10_hip_pipen1b\|g_xcvr.altpcie_a10_hip_pllnphy\|g_xcvr.g_phy_g3x*.phy_g3x*\|phy_g3x*\|g_xcvr_native_insts\[$i\].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst\|inst_twentynm_pcs\|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs\|byte_deserializer_pcs_clk_div_by_4_txclk_reg" -master_clock "dut|tx_bonding_clocks[0]" "*\|altpcie_a10_hip_pipen1b\|g_xcvr.altpcie_a10_hip_pllnphy\|g_xcvr.g_phy_g3x*.phy_g3x*\|phy_g3x*\|g_xcvr_native_insts\[$i\].twentynm_xcvr_native_inst\|twentynm_xcvr_native_inst\|inst_twentynm_pcs\|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs\|sta_rx_clk2_by4_1" -name "dut\|g_xcvr_native_insts\[$i\]\|rx_clk"
#	create_generated_clock -multiply_by 1 -source  "*\|altpcie_a10_hip_pipen1b\|g_xcvr.altpcie_a10_hip_pllnphy\|g_xcvr.g_phy_g3x*.phy_g3x*\|phy_g3x*\|g_xcvr_native_insts\[$i\].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst\|inst_twentynm_pcs\|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs\|byte_deserializer_pld_clk_div_by_4_txclk_reg" -master_clock "dut|tx_bonding_clocks[0]" "*\|altpcie_a10_hip_pipen1b\|g_xcvr.altpcie_a10_hip_pllnphy\|g_xcvr.g_phy_g3x*.phy_g3x*\|phy_g3x*\|g_xcvr_native_insts\[$i\].twentynm_xcvr_native_inst\|twentynm_xcvr_native_inst\|inst_twentynm_pcs\|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs\|sta_rx_clk2_by4_1_out" -name "dut\|g_xcvr_native_insts\[$i\]\|rx_clkout"
#
#	set_clock_groups -exclusive -group "dut|tx_bonding_clocks[0]" -group "dut|g_xcvr_native_insts[$i]|rx_clkout"
#   set_clock_groups -exclusive -group "dut|tx_bonding_clocks[0]" -group "rx_pcs_clk_div_by_4[$i]"
#	}
