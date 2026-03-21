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
set_global_assignment -name FAMILY "Stratix V"
set_global_assignment -name DEVICE 5SGXEA7K2F40C2
set_global_assignment -name TOP_LEVEL_ENTITY sv_hdmi2_demo
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files

# add files to the project
set_global_assignment -name VERILOG_FILE sv_hdmi2_demo.v
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
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_reconfig_mgmt_sv.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_rx_compare_sv.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_tx_compare_sv.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_tx_pll_compare_sv.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_xcvr_offset_sv.v

set_global_assignment -name QIP_FILE qsys_vip_passthrough/synthesis/qsys_vip_passthrough.qip
set_global_assignment -name QIP_FILE hdmi_tx/hdmi_tx/synthesis/hdmi_tx.qip
set_global_assignment -name QIP_FILE hdmi_rx/hdmi_rx/synthesis/hdmi_rx.qip

set_global_assignment -name QIP_FILE hdmi_pll_with_reconfig/pll_hdmi.qip
set_global_assignment -name QIP_FILE hdmi_pll_with_reconfig/pll_reconfig.qip
set_global_assignment -name QIP_FILE i2c_edid/hdmi_rx_edid_ram.qip
set_global_assignment -name QIP_FILE i2c_edid/pll_i2c.qip
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
set_global_assignment -name BLOCK_RAM_AND_MLAB_EQUIVALENT_POWER_UP_CONDITIONS "DONT CARE"

# add the Nios SW HEX file to the project
set_global_assignment -name QIP_FILE ./software/hdmi_demo/mem_init/meminit.qip

#Add the example SDC last to not get overwritten by the IP ones
set_global_assignment -name SDC_FILE hdmi_demo.sdc
set_global_assignment -name SDC_FILE reconfig_mgmt/mr.sdc

# Pin & Location Assignments
set_location_assignment PIN_AH22 -to clk100
set_location_assignment PIN_AM34 -to cpu_resetn
set_location_assignment PIN_AV2 -to rx_serial_data[0]
set_location_assignment PIN_AP2 -to rx_serial_data[1]
set_location_assignment PIN_AM2 -to rx_serial_data[2]
set_location_assignment PIN_AK2 -to rx_serial_data[3]
set_location_assignment PIN_A7 -to user_pb[0]
set_location_assignment PIN_B7 -to user_pb[1]
set_location_assignment PIN_C7 -to user_pb[2]
set_location_assignment PIN_L9 -to hdmi_rx_eq_boost1
set_location_assignment PIN_AP28 -to hdmi_rx_i2c_sda
set_location_assignment PIN_AK29 -to hdmi_rx_i2c_scl
set_location_assignment PIN_AL28 -to hdmi_rx_pre
set_location_assignment PIN_AV11 -to hdmi_rx_hpd_n
set_location_assignment PIN_AW11 -to hdmi_rx_5v_n
set_location_assignment PIN_B10 -to hdmi_tx_i2c_sda
set_location_assignment PIN_C9 -to hdmi_tx_i2c_scl
set_location_assignment PIN_A10 -to hdmi_tx_hpd_n
set_location_assignment PIN_AU4 -to tx_serial_data[0]
set_location_assignment PIN_AN4 -to tx_serial_data[1]
set_location_assignment PIN_AL4 -to tx_serial_data[2]
set_location_assignment PIN_AJ4 -to tx_serial_data[3]
set_location_assignment PIN_J11 -to user_led_g[0]
set_location_assignment PIN_U10 -to user_led_g[1]
set_location_assignment PIN_U9 -to user_led_g[2]
set_location_assignment PIN_AU24 -to user_led_g[3]
set_location_assignment PIN_AF28 -to user_led_g[4]
set_location_assignment PIN_AE29 -to user_led_g[5]
set_location_assignment PIN_AR7 -to user_led_g[6]
set_location_assignment PIN_AV10 -to user_led_g[7]

# Fitter Assignments
set_instance_assignment -name IO_STANDARD LVDS -to clk100
set_instance_assignment -name IO_STANDARD LVDS -to clkintop_p
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_serial_data[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_serial_data[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_serial_data[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_serial_data[0]
set_instance_assignment -name GXB_0PPM_CORECLK ON -to rx_serial_data[0]
set_instance_assignment -name GXB_0PPM_CORECLK ON -to rx_serial_data[1]
set_instance_assignment -name GXB_0PPM_CORECLK ON -to rx_serial_data[2]
set_instance_assignment -name GXB_0PPM_CORECLK ON -to rx_serial_data[3]
set_instance_assignment -name XCVR_RX_LINEAR_EQUALIZER_CONTROL 15 -to rx_serial_data[0]
set_instance_assignment -name XCVR_RX_LINEAR_EQUALIZER_CONTROL 15 -to rx_serial_data[1]
set_instance_assignment -name XCVR_RX_LINEAR_EQUALIZER_CONTROL 15 -to rx_serial_data[2]
set_instance_assignment -name XCVR_RX_LINEAR_EQUALIZER_CONTROL 15 -to rx_serial_data[3]
set_instance_assignment -name IO_STANDARD "1.5 V" -to user_pb[2]
set_instance_assignment -name IO_STANDARD "1.5 V" -to user_pb[1]
set_instance_assignment -name IO_STANDARD "1.5 V" -to user_pb[0]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to tx_serial_data[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to tx_serial_data[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to tx_serial_data[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to tx_serial_data[0]
set_instance_assignment -name XCVR_TX_VOD 15 -to tx_serial_data[0]
set_instance_assignment -name XCVR_TX_VOD 15 -to tx_serial_data[1]
set_instance_assignment -name XCVR_TX_VOD 15 -to tx_serial_data[2]
set_instance_assignment -name XCVR_TX_VOD 15 -to tx_serial_data[3]
set_instance_assignment -name XCVR_TX_SLEW_RATE_CTRL 4 -to tx_serial_data[3]
set_instance_assignment -name XCVR_TX_SLEW_RATE_CTRL 4 -to tx_serial_data[2]
set_instance_assignment -name XCVR_TX_SLEW_RATE_CTRL 4 -to tx_serial_data[1]
set_instance_assignment -name XCVR_TX_SLEW_RATE_CTRL 4 -to tx_serial_data[0]
set_instance_assignment -name XCVR_TX_PRE_EMP_1ST_POST_TAP 0 -to tx_serial_data[3]
set_instance_assignment -name XCVR_TX_PRE_EMP_1ST_POST_TAP 0 -to tx_serial_data[2]
set_instance_assignment -name XCVR_TX_PRE_EMP_1ST_POST_TAP 0 -to tx_serial_data[1]
set_instance_assignment -name XCVR_TX_PRE_EMP_1ST_POST_TAP 0 -to tx_serial_data[0]
set_instance_assignment -name GXB_0PPM_CORECLK ON -to tx_serial_data[3]
set_instance_assignment -name GXB_0PPM_CORECLK ON -to tx_serial_data[2]
set_instance_assignment -name GXB_0PPM_CORECLK ON -to tx_serial_data[1]
set_instance_assignment -name GXB_0PPM_CORECLK ON -to tx_serial_data[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to user_led_g[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to user_led_g[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to user_led_g[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to user_led_g[3]
set_instance_assignment -name IO_STANDARD "2.5 V" -to user_led_g[4]
set_instance_assignment -name IO_STANDARD "2.5 V" -to user_led_g[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to user_led_g[6]
set_instance_assignment -name IO_STANDARD "2.5 V" -to user_led_g[7]
