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
set_global_assignment -name TOP_LEVEL_ENTITY av_sk_hdmi2_demo
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files

# add files to the project
set_global_assignment -name VERILOG_FILE av_sk_hdmi2_demo.v
set_global_assignment -name VERILOG_FILE clock_crosser.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_ce.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_pll_compare.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_rate_detect.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_reconfig_fsm.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_reconfig_mgmt_av.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_rx_compare_av.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_tx_compare_av.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_tx_oversample.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_tx_pll_compare_av.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_xcvr_offset_av.v
set_global_assignment -name VERILOG_FILE reconfig_mgmt/mr_clock_sync.v
set_global_assignment -name VERILOG_FILE hdmi_rx/hdmi_rx_top.v
set_global_assignment -name VERILOG_FILE hdmi_rx/mr_hdmi_rx_core_top.v
set_global_assignment -name VERILOG_FILE hdmi_rx/mr_rx_oversample.v
set_global_assignment -name VERILOG_FILE hdmi_tx/hdmi_tx_top.v
set_global_assignment -name VERILOG_FILE hdmi_tx/mr_hdmi_tx_core_top.v
set_global_assignment -name VERILOG_FILE i2c/i2cslave_to_avlmm_bridge.v
set_global_assignment -name VERILOG_FILE i2c/i2c_avl_mst_intf_gen.v
set_global_assignment -name VERILOG_FILE i2c/i2c_clk_cnt.v
set_global_assignment -name VERILOG_FILE i2c/i2c_condt_det.v
set_global_assignment -name VERILOG_FILE i2c/i2c_databuffer.v
set_global_assignment -name VERILOG_FILE i2c/i2c_rxshifter.v
set_global_assignment -name VERILOG_FILE i2c/i2c_slvfsm.v
set_global_assignment -name VERILOG_FILE i2c/i2c_spksupp.v
set_global_assignment -name VERILOG_FILE i2c/i2c_txout.v
set_global_assignment -name VERILOG_FILE i2c/i2c_txshifter.v
set_global_assignment -name QIP_FILE i2c/output_buf_i2c.qip
set_global_assignment -name QIP_FILE i2c/hdmi_rx_edid_ram.qip
set_global_assignment -name QIP_FILE pll/pll_hdmi.qip
set_global_assignment -name QIP_FILE pll/pll_sys.qip
set_global_assignment -name QIP_FILE native_phy_tx/gxb_tx_reset.qip
set_global_assignment -name QIP_FILE native_phy_tx/gxb_tx.qip
set_global_assignment -name QIP_FILE native_phy_rx/gxb_rx_reset1.qip
set_global_assignment -name QIP_FILE native_phy_rx/gxb_rx.qip
set_global_assignment -name QIP_FILE reconfig_ip/pll_reconfig.qip
set_global_assignment -name QIP_FILE reconfig_ip/gxb_rx_reconfig.qip
set_global_assignment -name QIP_FILE hdmi_tx/hdmi_tx/synthesis/hdmi_tx.qip
set_global_assignment -name QIP_FILE hdmi_rx/hdmi_rx/synthesis/hdmi_rx.qip
set_global_assignment -name QIP_FILE qsys_vip_passthrough/synthesis/qsys_vip_passthrough.qip

# Set various options
set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "2.5 V"
set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON
set_global_assignment -name NUM_PARALLEL_PROCESSORS ALL

# add the Nios SW HEX file to the project
set_global_assignment -name QIP_FILE ./software/hdmi_demo/mem_init/meminit.qip

#Add the example SDC last to not get overwritten by the IP ones
set_global_assignment -name SDC_FILE hdmi_demo.sdc
set_global_assignment -name SDC_FILE reconfig_mgmt/mr.sdc

# Pin & Location Assignments
set_location_assignment PIN_A19 -to clk_in_ddr_100
set_location_assignment PIN_A20 -to "clk_in_ddr_100(n)"
set_location_assignment PIN_AH18 -to clk100
set_location_assignment PIN_D5 -to cpu_resetn
set_location_assignment PIN_AH10 -to hdmi_rx_i2c_scl
set_location_assignment PIN_AH8 -to hdmi_rx_i2c_sda
set_location_assignment PIN_B6 -to hdmi_tx_i2c_sda
set_location_assignment PIN_A6 -to hdmi_tx_i2c_scl
set_location_assignment PIN_AP11 -to hdmi_rx_hpd_n
set_location_assignment PIN_AP10 -to hdmi_rx_5v_n
set_location_assignment PIN_C7 -to hdmi_tx_hpd_n
set_location_assignment PIN_P1 -to rx_serial_data[3]
set_location_assignment PIN_M1 -to rx_serial_data[2]
set_location_assignment PIN_K1 -to rx_serial_data[1]
set_location_assignment PIN_H1 -to rx_serial_data[0]
set_location_assignment PIN_G3 -to tx_serial_data[3]
set_location_assignment PIN_J3 -to tx_serial_data[2]
set_location_assignment PIN_L3 -to tx_serial_data[1]
set_location_assignment PIN_N3 -to tx_serial_data[0]
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


# Fitter Assignments
set_instance_assignment -name IO_STANDARD LVDS -to clk_in_ddr_100
set_instance_assignment -name IO_STANDARD LVDS -to clk100
set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to hdmi_rx_hpd
set_instance_assignment -name WEAK_PULL_UP_RESISTOR OFF -to hdmi_rx_hpd
set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to hdmi_rx_i2c_scl
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hdmi_rx_i2c_scl
set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to hdmi_rx_i2c_sda
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hdmi_rx_i2c_sda
set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to hdmi_tx_i2c_sda
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hdmi_tx_i2c_sda
set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to hdmi_tx_i2c_scl
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hdmi_tx_i2c_scl
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_serial_data[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_serial_data[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_serial_data[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_serial_data[0]
set_instance_assignment -name XCVR_RX_LINEAR_EQUALIZER_CONTROL 2 -to rx_serial_data[1]
set_instance_assignment -name XCVR_RX_LINEAR_EQUALIZER_CONTROL 2 -to rx_serial_data[3]
set_instance_assignment -name XCVR_RX_LINEAR_EQUALIZER_CONTROL 2 -to rx_serial_data[2]
set_instance_assignment -name XCVR_RX_LINEAR_EQUALIZER_CONTROL 2 -to rx_serial_data[0]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to tx_serial_data[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to tx_serial_data[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to tx_serial_data[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to tx_serial_data[0]
set_instance_assignment -name XCVR_TX_VOD 40 -to tx_serial_data[3]
set_instance_assignment -name XCVR_TX_VOD 40 -to tx_serial_data[2]
set_instance_assignment -name XCVR_TX_VOD 40 -to tx_serial_data[1]
set_instance_assignment -name XCVR_TX_VOD 40 -to tx_serial_data[0]


