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


package require -exact qsys 14.1
source ../util/hps_utils.tcl

#
# module clkmgr
#
hps_utils_add_component_boiler_plate baum_clkmgr {Altera Clock Manager}
#
# file sets
#
#
# parameters
#

set_module_assignment embeddedsw.dts.compatible altr,clk-mgr
set_module_assignment embeddedsw.dts.group clkmgr
set_module_assignment embeddedsw.dts.name clk-mgr
set_module_assignment embeddedsw.dts.vendor altr
# 
# display items
# 



#hps_utils_add_clock_reset

hps_utils_add_clock eosc1

#hps_utils_add_clock fpga2soc_clk

#hps_utils_add_clock soc2fpga_clk

#hps_utils_add_clock lws2f_clk

hps_utils_add_clock cb_intosc_hs_div2_clk
hps_utils_add_clock cb_intosc_ls_clk
hps_utils_add_clock f2s_free_clk

hps_utils_add_reset reset_sink eosc1

hps_utils_add_clock_out l4_sys_free_clk

hps_utils_add_clock_out mpu_free_clk

hps_utils_add_clock_out l3_main_free_clk

hps_utils_add_clock_out cs_at_clk

hps_utils_add_clock_out cs_pdbg_clk

hps_utils_add_clock_out cs_trace_clk

hps_utils_add_clock_out cs_timer_clk

hps_utils_add_clock_out emac0_clk

hps_utils_add_clock_out emac1_clk

hps_utils_add_clock_out emac2_clk

hps_utils_add_clock_out usb_clk

hps_utils_add_clock_out emac_ptp_clk

hps_utils_add_clock_out gpio_db_clk

hps_utils_add_clock_out l4_sp_clk

hps_utils_add_clock_out l4_mp_clk

hps_utils_add_clock_out l4_main_clk

hps_utils_add_clock_out mpu_periph_clk

hps_utils_add_clock_out sdmmc_clk

hps_utils_add_clock_out qspi_sclk_out

hps_utils_add_clock_out s2f_free_clk

hps_utils_add_clock_out s2f_user_clk0

hps_utils_add_clock_out s2f_user_clk1

hps_utils_add_clock_out s2f_user0_clk

hps_utils_add_clock_out s2f_user1_clk

hps_utils_add_clock_out spim0_sclk_out

hps_utils_add_clock_out spim1_sclk_out

hps_utils_add_clock_out spi_m_clk

#
# Interrupt sender
#

# TER TODO: Need to add interrupt sender at some point


# 
# connection point altera_axi_slave
# 

hps_utils_add_axi_slave_with_clk axi_slave0 axi_sig0 12 eosc1
