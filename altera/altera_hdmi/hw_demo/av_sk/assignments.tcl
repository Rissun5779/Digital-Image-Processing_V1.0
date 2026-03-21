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


#######################################################
#
# Device, pin and other assignments for the 
# HDMI MegaCore Hardware Demo
# 
# #####################################################

# Set the family, device, top-level entity
set_global_assignment -name FAMILY "Arria V"
set_global_assignment -name DEVICE 5AGXFB3H4F35C4
set_global_assignment -name TOP_LEVEL_ENTITY av_sk_demo
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files

# add files to the project
set_global_assignment -name VERILOG_FILE av_sk_demo.v
set_global_assignment -name VERILOG_FILE clock_crosser.v
set_global_assignment -name VERILOG_FILE hdmi_rx/hdmi_rx_top.v
set_global_assignment -name VERILOG_FILE hdmi_rx/mr_clock_sync.v
set_global_assignment -name VERILOG_FILE hdmi_rx/mr_hdmi_rx_core_top.v
set_global_assignment -name VERILOG_FILE hdmi_rx/mr_rx_oversample.v
set_global_assignment -name VERILOG_FILE hdmi_tx/hdmi_tx_top.v
set_global_assignment -name VERILOG_FILE hdmi_tx/mr_ce.v
set_global_assignment -name VERILOG_FILE hdmi_tx/mr_hdmi_tx_core_top.v
set_global_assignment -name VERILOG_FILE hdmi_tx/mr_tx_oversample.v
set_global_assignment -name VERILOG_FILE i2c_edid/i2cslave_to_avlmm_bridge.v
set_global_assignment -name VERILOG_FILE i2c_edid/i2c_avl_mst_intf_gen.v
set_global_assignment -name VERILOG_FILE i2c_edid/i2c_clk_cnt.v
set_global_assignment -name VERILOG_FILE i2c_edid/i2c_condt_det.v
set_global_assignment -name VERILOG_FILE i2c_edid/i2c_databuffer.v
set_global_assignment -name VERILOG_FILE i2c_edid/i2c_rxshifter.v
set_global_assignment -name VERILOG_FILE i2c_edid/i2c_slvfsm.v
set_global_assignment -name VERILOG_FILE i2c_edid/i2c_spksupp.v
set_global_assignment -name VERILOG_FILE i2c_edid/i2c_txout.v
set_global_assignment -name VERILOG_FILE i2c_edid/i2c_txshifter.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_pll_compare.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_rate_detect.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_reconfig_fsm.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_reconfig_mgmt_av.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_rx_compare_av.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_tx_compare_av.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_tx_pll_compare_av.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_xcvr_offset_av.v

set_global_assignment -name QIP_FILE qsys_vip_passthrough/synthesis/qsys_vip_passthrough.qip
set_global_assignment -name QIP_FILE hdmi_tx/hdmi_tx/synthesis/hdmi_tx.qip
set_global_assignment -name QIP_FILE hdmi_rx/hdmi_rx/synthesis/hdmi_rx.qip

set_global_assignment -name QIP_FILE hdmi_pll_with_reconfig/pll_hdmi.qip
set_global_assignment -name QIP_FILE hdmi_pll_with_reconfig/pll_reconfig.qip
set_global_assignment -name QIP_FILE hdmi_pll_with_reconfig/pll_sys_50.qip
set_global_assignment -name QIP_FILE i2c_edid/hdmi_rx_edid_ram.qip
set_global_assignment -name QIP_FILE i2c_edid/output_buf_i2c.qip
set_global_assignment -name QIP_FILE native_phy_rx/gxb_rx.qip
set_global_assignment -name QIP_FILE native_phy_rx/gxb_rx_reset.qip
set_global_assignment -name QIP_FILE native_phy_tx/gxb_tx.qip
set_global_assignment -name QIP_FILE native_phy_tx/gxb_tx_reset.qip
set_global_assignment -name QIP_FILE reconfig_ip/gxb_reconfig.qip

# Set various options
set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "2.5 V"
set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON
set_global_assignment -name NUM_PARALLEL_PROCESSORS ALL

# add the Nios SW HEX file to the project
set_global_assignment -name QIP_FILE ./software/hdmi_demo/mem_init/meminit.qip

#Add the example SDC last to not get overwritten by the IP ones
set_global_assignment -name SDC_FILE hdmi_demo.sdc
set_global_assignment -name SDC_FILE mr.sdc

# Pin & Location Assignments
set_location_assignment PIN_AP29 -to clkin_50_bot
set_location_assignment PIN_A19 -to clk_in_ddr_100
set_location_assignment PIN_A20 -to "clk_in_ddr_100(n)"
set_location_assignment PIN_D5 -to cpu_resetn
#set_location_assignment PIN_A3 -to clkin_ch0
set_location_assignment PIN_H1 -to rx_serial_data[0]
set_location_assignment PIN_P1 -to rx_serial_data[3]
set_location_assignment PIN_M1 -to rx_serial_data[2]
set_location_assignment PIN_K1 -to rx_serial_data[1]
set_location_assignment PIN_G3 -to tx_serial_data[3]
set_location_assignment PIN_J3 -to tx_serial_data[2]
set_location_assignment PIN_L3 -to tx_serial_data[1]
set_location_assignment PIN_N3 -to tx_serial_data[0]
set_location_assignment PIN_AH8 -to hdmi_rx_i2c_sda
set_location_assignment PIN_AH10 -to hdmi_rx_i2c_scl
set_location_assignment PIN_AP11 -to hdmi_rx_hpd_n
set_location_assignment PIN_AP10 -to hdmi_rx_5v_n
set_location_assignment PIN_C16 -to user_led[7]
set_location_assignment PIN_C14 -to user_led[6]
set_location_assignment PIN_C13 -to user_led[5]
set_location_assignment PIN_D16 -to user_led[4]
set_location_assignment PIN_G17 -to user_led[3]
set_location_assignment PIN_G16 -to user_led[2]
set_location_assignment PIN_G15 -to user_led[1]
set_location_assignment PIN_F17 -to user_led[0]
set_location_assignment PIN_B14 -to user_pb[2]
set_location_assignment PIN_B15 -to user_pb[1]
set_location_assignment PIN_A14 -to user_pb[0]
set_location_assignment PIN_E15 -to user_dipsw[3]
set_location_assignment PIN_D13 -to user_dipsw[2]
set_location_assignment PIN_D14 -to user_dipsw[1]
set_location_assignment PIN_D15 -to user_dipsw[0]
set_location_assignment PIN_E26 -to mem_ck
set_location_assignment PIN_F26 -to mem_ck_n
set_location_assignment PIN_K29 -to mem_cke
set_location_assignment PIN_D30 -to mem_cs_n
set_location_assignment PIN_B30 -to mem_ras_n
set_location_assignment PIN_F28 -to mem_cas_n
set_location_assignment PIN_F29 -to mem_we_n
set_location_assignment PIN_K25 -to mem_reset_n
set_location_assignment PIN_H27 -to mem_odt
set_location_assignment PIN_D26 -to mem_a[0]
set_location_assignment PIN_E27 -to mem_a[1]
set_location_assignment PIN_A27 -to mem_a[2]
set_location_assignment PIN_B27 -to mem_a[3]
set_location_assignment PIN_G26 -to mem_a[4]
set_location_assignment PIN_H26 -to mem_a[5]
set_location_assignment PIN_K27 -to mem_a[6]
set_location_assignment PIN_L27 -to mem_a[7]
set_location_assignment PIN_D27 -to mem_a[8]
set_location_assignment PIN_C28 -to mem_a[9]
set_location_assignment PIN_C29 -to mem_a[10]
set_location_assignment PIN_D28 -to mem_a[11]
set_location_assignment PIN_G27 -to mem_a[12]
set_location_assignment PIN_A29 -to mem_ba[0]
set_location_assignment PIN_A28 -to mem_ba[1]
set_location_assignment PIN_B29 -to mem_ba[2]
set_location_assignment PIN_M25 -to mem_dm[0]
set_location_assignment PIN_M23 -to mem_dm[1]
set_location_assignment PIN_M22 -to mem_dm[2]
set_location_assignment PIN_K21 -to mem_dm[3]
set_location_assignment PIN_G24 -to mem_dq[0]
set_location_assignment PIN_H24 -to mem_dq[1]
set_location_assignment PIN_M24 -to mem_dq[2]
set_location_assignment PIN_A26 -to mem_dq[3]
set_location_assignment PIN_A25 -to mem_dq[4]
set_location_assignment PIN_C25 -to mem_dq[5]
set_location_assignment PIN_B26 -to mem_dq[6]
set_location_assignment PIN_C26 -to mem_dq[7]
set_location_assignment PIN_H23 -to mem_dq[8]
set_location_assignment PIN_J23 -to mem_dq[9]
set_location_assignment PIN_K24 -to mem_dq[10]
set_location_assignment PIN_B24 -to mem_dq[11]
set_location_assignment PIN_C23 -to mem_dq[12]
set_location_assignment PIN_D23 -to mem_dq[13]
set_location_assignment PIN_D24 -to mem_dq[14]
set_location_assignment PIN_E24 -to mem_dq[15]
set_location_assignment PIN_D21 -to mem_dq[16]
set_location_assignment PIN_E21 -to mem_dq[17]
set_location_assignment PIN_M21 -to mem_dq[18]
set_location_assignment PIN_C22 -to mem_dq[19]
set_location_assignment PIN_D22 -to mem_dq[20]
set_location_assignment PIN_G21 -to mem_dq[21]
set_location_assignment PIN_A23 -to mem_dq[22]
set_location_assignment PIN_B23 -to mem_dq[23]
set_location_assignment PIN_K20 -to mem_dq[24]
set_location_assignment PIN_L20 -to mem_dq[25]
set_location_assignment PIN_M20 -to mem_dq[26]
set_location_assignment PIN_A22 -to mem_dq[27]
set_location_assignment PIN_B21 -to mem_dq[28]
set_location_assignment PIN_B20 -to mem_dq[29]
set_location_assignment PIN_F20 -to mem_dq[30]
set_location_assignment PIN_G20 -to mem_dq[31]
set_location_assignment PIN_F25 -to mem_dqs[0]
set_location_assignment PIN_F23 -to mem_dqs[1]
set_location_assignment PIN_F22 -to mem_dqs[2]
set_location_assignment PIN_D20 -to mem_dqs[3]
set_location_assignment PIN_G25 -to mem_dqs_n[0]
set_location_assignment PIN_G23 -to mem_dqs_n[1]
set_location_assignment PIN_G22 -to mem_dqs_n[2]
set_location_assignment PIN_E20 -to mem_dqs_n[3]
set_location_assignment PIN_E32 -to oct_rzqin

# Fitter Assignments
set_instance_assignment -name IO_STANDARD LVDS -to clk_in_ddr_100
set_instance_assignment -name GXB_0PPM_CORECLK ON -to rx_serial_data
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_serial_data[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_serial_data[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_serial_data[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_serial_data[0]
set_instance_assignment -name GXB_0PPM_CORECLK ON -to tx_serial_data
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to tx_serial_data[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to tx_serial_data[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to tx_serial_data[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to tx_serial_data[0]
set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to hdmi_rx_i2c_sda
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hdmi_rx_i2c_sda
set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to hdmi_rx_i2c_scl
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hdmi_rx_i2c_scl
