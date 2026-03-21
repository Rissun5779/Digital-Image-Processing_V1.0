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


# *********************************************************************
# Description
# 
# Device, pin and other assignments for the DisplayPort Example Design
#
# *********************************************************************

# Set the family, device, top-level entity
set_global_assignment -name FAMILY "Arria V"
set_global_assignment -name DEVICE 5AGXFB3H4F35C4
set_global_assignment -name TOP_LEVEL_ENTITY top

# add files to the project
set_global_assignment -name VERILOG_FILE top.v
set_global_assignment -name QIP_FILE video_pll_av.qip
set_global_assignment -name QIP_FILE ./clkrec/clkrec_pll_av.qip
set_global_assignment -name QIP_FILE gxb_reset.qip
set_global_assignment -name QIP_FILE gxb_reconfig.qip
set_global_assignment -name QIP_FILE gxb_rx.qip
set_global_assignment -name QIP_FILE gxb_tx.qip
set_global_assignment -name QIP_FILE pll_135.qip
set_global_assignment -name QIP_FILE ./control/synthesis/control.qip
set_global_assignment -name QIP_FILE bitec_reconfig_alt_av.qip
set_global_assignment -name QIP_FILE ./clkrec/bitec_clkrec.qip

# Set various options
set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "2.5 V"
# set_global_assignment -name PROJECT_OUTPUT_DIRECTORY files
set_global_assignment -name UNIPHY_SEQUENCER_DQS_CONFIG_ENABLE ON
set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON
set_global_assignment -name ECO_REGENERATE_REPORT ON

# add the Nios SW HEX file to the project
set_global_assignment -name QIP_FILE ./software/dp_demo/mem_init/meminit.qip

# Add the example SDC last to not get overwritten by the IP ones
set_global_assignment -name SDC_FILE example.sdc

# Pin & Location Assignments
# ==========================
# set_location_assignment PIN_A19 -to clk_in_ddr_100
# set_location_assignment PIN_A20 -to "clk_in_ddr_100(n)"
set_location_assignment PIN_AH18 -to clk100
set_location_assignment PIN_AJ13 -to AUX_RX_DRV_OE
set_location_assignment PIN_AH13 -to AUX_RX_DRV_OUT
set_location_assignment PIN_B11 -to AUX_TX_DRV_OE
set_location_assignment PIN_E11 -to AUX_TX_DRV_OUT
set_location_assignment PIN_AJ10 -to RX_CAD
set_location_assignment PIN_AP11 -to RX_ENA
# set_location_assignment PIN_AN9 -to RX_SCL_DDC
# set_location_assignment PIN_AH8 -to RX_SDA_DDC
set_location_assignment PIN_AJ8 -to SCL_CTL
set_location_assignment PIN_AK8 -to SDA_CTL
# set_location_assignment PIN_AE6 -to TX_CAD
# set_location_assignment PIN_AL12 -to TX_SCL_DDC
# set_location_assignment PIN_AM11 -to TX_SDA_DDC
set_location_assignment PIN_D5 -to resetn
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
# set_location_assignment PIN_B15 -to user_pb[1]
set_location_assignment PIN_A14 -to user_pb[0]
set_location_assignment PIN_AL8 -to TX_ENA
# set_location_assignment PIN_E26 -to mem_ck
# set_location_assignment PIN_F26 -to mem_ck_n
# set_location_assignment PIN_D26 -to mem_a[0]
# set_location_assignment PIN_E27 -to mem_a[1]
# set_location_assignment PIN_A27 -to mem_a[2]
# set_location_assignment PIN_B27 -to mem_a[3]
# set_location_assignment PIN_G26 -to mem_a[4]
# set_location_assignment PIN_H26 -to mem_a[5]
# set_location_assignment PIN_K27 -to mem_a[6]
# set_location_assignment PIN_L27 -to mem_a[7]
# set_location_assignment PIN_D27 -to mem_a[8]
# set_location_assignment PIN_C28 -to mem_a[9]
# set_location_assignment PIN_C29 -to mem_a[10]
# set_location_assignment PIN_D28 -to mem_a[11]
# set_location_assignment PIN_G27 -to mem_a[12]
# set_location_assignment PIN_A29 -to mem_ba[0]
# set_location_assignment PIN_A28 -to mem_ba[1]
# set_location_assignment PIN_B29 -to mem_ba[2]
# set_location_assignment PIN_F28 -to mem_cas_n
# set_location_assignment PIN_K29 -to mem_cke
# set_location_assignment PIN_D30 -to mem_cs_n
# set_location_assignment PIN_H27 -to mem_odt
# set_location_assignment PIN_B30 -to mem_ras_n
# set_location_assignment PIN_F29 -to mem_we_n
set_location_assignment PIN_K25 -to mem_reset_n
# set_location_assignment PIN_E32 -to oct_rzqin
# set_location_assignment PIN_G24 -to mem_dq[0]
# set_location_assignment PIN_H24 -to mem_dq[1]
# set_location_assignment PIN_M24 -to mem_dq[2]
# set_location_assignment PIN_A26 -to mem_dq[3]
# set_location_assignment PIN_A25 -to mem_dq[4]
# set_location_assignment PIN_C25 -to mem_dq[5]
# set_location_assignment PIN_B26 -to mem_dq[6]
# set_location_assignment PIN_C26 -to mem_dq[7]
# set_location_assignment PIN_M25 -to mem_dm[0]
# set_location_assignment PIN_F25 -to mem_dqs[0]
# set_location_assignment PIN_G25 -to mem_dqs_n[0]
# set_location_assignment PIN_H23 -to mem_dq[8]
# set_location_assignment PIN_J23 -to mem_dq[9]
# set_location_assignment PIN_K24 -to mem_dq[10]
# set_location_assignment PIN_B24 -to mem_dq[11]
# set_location_assignment PIN_C23 -to mem_dq[12]
# set_location_assignment PIN_D23 -to mem_dq[13]
# set_location_assignment PIN_D24 -to mem_dq[14]
# set_location_assignment PIN_E24 -to mem_dq[15]
# set_location_assignment PIN_M23 -to mem_dm[1]
# set_location_assignment PIN_F23 -to mem_dqs[1]
# set_location_assignment PIN_G23 -to mem_dqs_n[1]
# set_location_assignment PIN_D21 -to mem_dq[16]
# set_location_assignment PIN_E21 -to mem_dq[17]
# set_location_assignment PIN_M21 -to mem_dq[18]
# set_location_assignment PIN_C22 -to mem_dq[19]
# set_location_assignment PIN_D22 -to mem_dq[20]
# set_location_assignment PIN_G21 -to mem_dq[21]
# set_location_assignment PIN_A23 -to mem_dq[22]
# set_location_assignment PIN_B23 -to mem_dq[23]
# set_location_assignment PIN_M22 -to mem_dm[2]
# set_location_assignment PIN_F22 -to mem_dqs[2]
# set_location_assignment PIN_G22 -to mem_dqs_n[2]
# set_location_assignment PIN_K20 -to mem_dq[24]
# set_location_assignment PIN_L20 -to mem_dq[25]
# set_location_assignment PIN_M20 -to mem_dq[26]
# set_location_assignment PIN_A22 -to mem_dq[27]
# set_location_assignment PIN_B21 -to mem_dq[28]
# set_location_assignment PIN_B20 -to mem_dq[29]
# set_location_assignment PIN_F20 -to mem_dq[30]
# set_location_assignment PIN_G20 -to mem_dq[31]
# set_location_assignment PIN_K21 -to mem_dm[3]
# set_location_assignment PIN_D20 -to mem_dqs[3]
# set_location_assignment PIN_E20 -to mem_dqs_n[3]
# set_location_assignment PIN_A3 -to clk50
# set_location_assignment PIN_B3 -to "clk50(n)"
# set_location_assignment PIN_A3 -to clkintop_125_p
# set_location_assignment PIN_C3 -to clkout_sma
# set_location_assignment PIN_AL13 -to AUX_RX_PC
# set_location_assignment PIN_AM13 -to AUX_RX_NC
set_location_assignment PIN_AH10 -to RX_HPD
set_location_assignment PIN_AG12 -to AUX_RX_DRV_IN
set_location_assignment PIN_AC6 -to RX_SENSE_P
set_location_assignment PIN_AC7 -to RX_SENSE_N
# set_location_assignment PIN_B12 -to AUX_TX_PC
# set_location_assignment PIN_A13 -to AUX_TX_NC
set_location_assignment PIN_AK12 -to TX_HPD
set_location_assignment PIN_A11 -to AUX_TX_DRV_IN
# set_location_assignment PIN_AE3 -to hsma_tx_p[3]
# set_location_assignment PIN_AE4 -to "hsma_tx_p[3](n)"
# set_location_assignment PIN_AG3 -to hsma_tx_p[2]
# set_location_assignment PIN_AG4 -to "hsma_tx_p[2](n)"
# set_location_assignment PIN_AJ3 -to hsma_tx_p[1]
# set_location_assignment PIN_AJ4 -to "hsma_tx_p[1](n)"
# set_location_assignment PIN_AC3 -to hsma_tx_p[0]
# set_location_assignment PIN_W9 -to refclk1_qr0_p
# set_location_assignment PIN_W26 -to refclk1_ql0_p
set_location_assignment PIN_U9 -to refclk2_qr1_p
# set_location_assignment PIN_L9 -to SMA_J8
# set_location_assignment PIN_M8 -to SMA_J7
# set_location_assignment PIN_AF8 -to hdmi_hpd
# set_location_assignment PIN_AC9 -to hdmi_oe_n

# Analysis & Synthesis Assignments
# ================================
set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to SCL_CTL
set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to SDA_CTL
set_global_assignment -name NUM_PARALLEL_PROCESSORS ALL

# Fitter Assignments
# ==================
# set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsma_tx_p[3]
# set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsma_tx_p[2]
# set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsma_tx_p[1]
# set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to hsma_tx_p[0]
# set_instance_assignment -name IO_STANDARD LVDS -to clk50
set_instance_assignment -name IO_STANDARD LVDS -to clk100
# set_instance_assignment -name IO_STANDARD LVDS -to clk_in_ddr_100
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to tx_serial_data[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to tx_serial_data[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to tx_serial_data[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to tx_serial_data[0]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_serial_data[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_serial_data[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_serial_data[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to rx_serial_data[0]
# set_instance_assignment -name IO_STANDARD LVDS -to clkintop_125_p
# set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 2.5-V SSTL CLASS II" -to AUX_RX_NC
# set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 2.5-V SSTL CLASS II" -to AUX_RX_PC
# set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 2.5-V SSTL CLASS II" -to AUX_TX_NC
# set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 2.5-V SSTL CLASS II" -to AUX_TX_PC
set_instance_assignment -name XCVR_TX_PLL_RECONFIG_GROUP 0 -to *cmu_pll.tx_pll
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to SCL_CTL
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to SDA_CTL
set_instance_assignment -name CURRENT_STRENGTH_NEW 16MA -to RX_HPD
# set_instance_assignment -name IO_STANDARD LVDS -to refclk1_qr0_p
# set_instance_assignment -name IO_STANDARD LVDS -to refclk1_ql0_p
set_instance_assignment -name IO_STANDARD LVDS -to refclk2_qr1_p
set_instance_assignment -name XCVR_RX_LINEAR_EQUALIZER_CONTROL 0 -to rx_serial_data[*]
# Set Tx Transceiver clock to Global to resolve timing violation.
set_instance_assignment -name GLOBAL_SIGNAL "GLOBAL CLOCK" -to gxb_tx:gxb_tx_i|altera_xcvr_native_av:gxb_tx_inst|av_xcvr_native:gen_native_inst.av_xcvr_native_insts[0].gen_bonded_group_native.av_xcvr_native_inst|av_pcs:inst_av_pcs|av_pcs_ch:ch[0].inst_av_pcs_ch|av_hssi_tx_pld_pcs_interface_rbc:inst_av_hssi_tx_pld_pcs_interface|pld8gtxclkout

