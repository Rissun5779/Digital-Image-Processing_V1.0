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


package require -exact qsys 12.0
set hard_peripheral_logical_view_dir ..
source "$hard_peripheral_logical_view_dir/common/hps_utils.tcl"
set hps_dir ../..
source "$hps_dir/altera_hps/clock_manager.tcl"
#
# module clkmgr
#
hps_utils_add_component_boiler_plate asimov_clkmgr {Altera Clock Manager}
#
# file sets
#
#
# parameters
#
add_display_item "" "HPS Clocks" "group" "tab"
add_clock_tab "HPS Clocks"

set_module_assignment embeddedsw.dts.compatible altr,clk-mgr
set_module_assignment embeddedsw.dts.group clkmgr
set_module_assignment embeddedsw.dts.name clk-mgr
set_module_assignment embeddedsw.dts.vendor altr
# 
# display items
# 


hps_utils_add_clock eosc1

hps_utils_add_reset reset_sink eosc1

hps_utils_add_clock eosc2

hps_utils_add_clock f2s_periph_ref_clk

hps_utils_add_clock f2s_sdram_ref_clk

hps_utils_add_clock_out emac0_clk

hps_utils_add_clock_out emac1_clk

hps_utils_add_clock_out can0_clk

hps_utils_add_clock_out can1_clk

hps_utils_add_clock_out nand_clk

hps_utils_add_clock_out l4_sp_clk

hps_utils_add_clock_out l4_mp_clk

hps_utils_add_clock_out l4_main_clk

hps_utils_add_clock_out per_base_clk

hps_utils_add_clock_out mpu_periph_clk

hps_utils_add_clock_out usb_mp_clk

hps_utils_add_clock_out sdmmc_clk

hps_utils_add_clock_out qspi_clk

hps_utils_add_clock_out spi_m_clk
#
# Interrupt sender
#

# 
# connection point altera_axi_slave
# 
hps_utils_add_axi_slave_with_clk axi_slave0 axi_sig0 12 eosc1
