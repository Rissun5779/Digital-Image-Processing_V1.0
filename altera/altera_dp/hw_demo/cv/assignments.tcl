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
set_global_assignment -name FAMILY "Cyclone V"
set_global_assignment -name DEVICE 5CGTFD9E5F35C7
set_global_assignment -name TOP_LEVEL_ENTITY cv_dp_demo

# add files to the project
set_global_assignment -name VERILOG_FILE cv_dp_demo.v
set_global_assignment -name VERILOG_FILE ./reconfig_mgmt/dp_analog_mappings.v
set_global_assignment -name VERILOG_FILE ./reconfig_mgmt/dp_mif_mappings.v
set_global_assignment -name VERILOG_FILE ./reconfig_mgmt/reconfig_mgmt_hw_ctrl.v
set_global_assignment -name VERILOG_FILE ./reconfig_mgmt/reconfig_mgmt_write.v
set_global_assignment -name QIP_FILE video_pll_cv.qip
set_global_assignment -name QIP_FILE xcvr_pll_cv.qip
set_global_assignment -name QIP_FILE gxb_reset.qip
set_global_assignment -name QIP_FILE gxb_reconfig.qip
set_global_assignment -name QIP_FILE gxb_rx.qip
set_global_assignment -name QIP_FILE gxb_tx.qip
set_global_assignment -name QIP_FILE ./control/synthesis/control.qip
set_global_assignment -name QIP_FILE ./clkrec/bitec_clkrec.qip
set_global_assignment -name QIP_FILE ./clkrec/clkrec_pll_cv.qip

# Set various options
set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "2.5 V"
# set_global_assignment -name PROJECT_OUTPUT_DIRECTORY files
set_global_assignment -name UNIPHY_SEQUENCER_DQS_CONFIG_ENABLE ON
set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON
set_global_assignment -name ECO_REGENERATE_REPORT ON

# add the Nios SW HEX file to the project
set_global_assignment -name QIP_FILE ./software/dp_demo/mem_init/meminit.qip

# Add the example SDC last to not get overwritten by the IP ones
set_global_assignment -name SDC_FILE cv_dp_demo.sdc

# Pin & Location Assignments
# ==========================
# set_location_assignment PIN_H19 -to clk_in_ddr_100
# set_location_assignment PIN_H18 -to "clk_in_ddr_100(n)"
set_location_assignment PIN_W26 -to clk100
set_location_assignment PIN_H14 -to AUX_RX_DRV_OE
set_location_assignment PIN_G14 -to AUX_RX_DRV_OUT
set_location_assignment PIN_G15 -to AUX_TX_DRV_OE
set_location_assignment PIN_E18 -to AUX_TX_DRV_OUT
set_location_assignment PIN_L12 -to RX_CAD
set_location_assignment PIN_P14 -to RX_ENA
set_location_assignment PIN_E12 -to SCL_CTL
set_location_assignment PIN_K13 -to SDA_CTL
set_location_assignment PIN_AD29 -to resetn
set_location_assignment PIN_R2 -to rx_serial_data[3]
set_location_assignment PIN_U2 -to rx_serial_data[2]
set_location_assignment PIN_W2 -to rx_serial_data[1]
set_location_assignment PIN_AA2 -to rx_serial_data[0]
set_location_assignment PIN_Y4 -to tx_serial_data[3]
set_location_assignment PIN_V4 -to tx_serial_data[2]
set_location_assignment PIN_T4 -to tx_serial_data[1]
set_location_assignment PIN_P4 -to tx_serial_data[0]
set_location_assignment PIN_AH27 -to user_led[7]
set_location_assignment PIN_AC22 -to user_led[6]
set_location_assignment PIN_AJ27 -to user_led[5]
set_location_assignment PIN_AF25 -to user_led[4]
set_location_assignment PIN_AL31 -to user_led[3]
set_location_assignment PIN_AK29 -to user_led[2]
set_location_assignment PIN_AE25 -to user_led[1]
set_location_assignment PIN_AM23 -to user_led[0]
# set_location_assignment PIN_AA15 -to user_pb[1]
set_location_assignment PIN_AK13 -to user_pb[0]
set_location_assignment PIN_L13 -to TX_ENA
# set_location_assignment PIN_R30 -to mem_ck
# set_location_assignment PIN_R29 -to mem_ck_n
# set_location_assignment PIN_H29 -to mem_a[0]
# set_location_assignment PIN_K28 -to mem_a[1]
# set_location_assignment PIN_K34 -to mem_a[2]
# set_location_assignment PIN_L32 -to mem_a[3]
# set_location_assignment PIN_R32 -to mem_a[4]
# set_location_assignment PIN_R33 -to mem_a[5]
# set_location_assignment PIN_N32 -to mem_a[6]
# set_location_assignment PIN_G33 -to mem_a[7]
# set_location_assignment PIN_AE34 -to mem_a[8]
# set_location_assignment PIN_L27 -to mem_a[9]
# set_location_assignment PIN_V33 -to mem_a[10]
# set_location_assignment PIN_U33 -to mem_a[11]
# set_location_assignment PIN_T31 -to mem_a[12]
# set_location_assignment PIN_J31 -to mem_ba[0]
# set_location_assignment PIN_N29 -to mem_ba[1]
# set_location_assignment PIN_P27 -to mem_ba[2]
# set_location_assignment PIN_N27 -to mem_cas_n
# set_location_assignment PIN_AF32 -to mem_cke
# set_location_assignment PIN_V27 -to mem_cs_n
# set_location_assignment PIN_AA32 -to mem_odt
# set_location_assignment PIN_Y32 -to mem_ras_n
# set_location_assignment PIN_AM34 -to mem_we_n
set_location_assignment PIN_AG31 -to mem_reset_n
# set_location_assignment PIN_AP19 -to oct_rzqin
# set_location_assignment PIN_AF31 -to mem_dq[0]
# set_location_assignment PIN_AD30 -to mem_dq[1]
# set_location_assignment PIN_AJ32 -to mem_dq[2]
# set_location_assignment PIN_AC31 -to mem_dq[3]
# set_location_assignment PIN_AH32 -to mem_dq[4]
# set_location_assignment PIN_Y28 -to mem_dq[5]
# set_location_assignment PIN_AN34 -to mem_dq[6]
# set_location_assignment PIN_Y27 -to mem_dq[7]
# set_location_assignment PIN_AE30 -to mem_dm[0]
# set_location_assignment PIN_Y29 -to mem_dqs[0]
# set_location_assignment PIN_AD32 -to mem_dq[8]
# set_location_assignment PIN_AH33 -to mem_dq[9]
# set_location_assignment PIN_AB31 -to mem_dq[10]
# set_location_assignment PIN_AJ34 -to mem_dq[11]
# set_location_assignment PIN_AA31 -to mem_dq[12]
# set_location_assignment PIN_AK34 -to mem_dq[13]
# set_location_assignment PIN_W31 -to mem_dq[14]
# set_location_assignment PIN_AG33 -to mem_dq[15]
# set_location_assignment PIN_AE32 -to mem_dm[1]
# set_location_assignment PIN_W29 -to mem_dqs[1]
# set_location_assignment PIN_AD34 -to mem_dq[16]
# set_location_assignment PIN_AC33 -to mem_dq[17]
# set_location_assignment PIN_AG34 -to mem_dq[18]
# set_location_assignment PIN_AB33 -to mem_dq[19]
# set_location_assignment PIN_AE33 -to mem_dq[20]
# set_location_assignment PIN_V32 -to mem_dq[21]
# set_location_assignment PIN_AH34 -to mem_dq[22]
# set_location_assignment PIN_W32 -to mem_dq[23]
# set_location_assignment PIN_AC34 -to mem_dm[2]
# set_location_assignment PIN_V24 -to mem_dqs[2]
# set_location_assignment PIN_U29 -to mem_dq[24]
# set_location_assignment PIN_V34 -to mem_dq[25]
# set_location_assignment PIN_U34 -to mem_dq[26]
# set_location_assignment PIN_AA33 -to mem_dq[27]
# set_location_assignment PIN_R34 -to mem_dq[28]
# set_location_assignment PIN_Y33 -to mem_dq[29]
# set_location_assignment PIN_P34 -to mem_dq[30]
# set_location_assignment PIN_U28 -to mem_dq[31]
# set_location_assignment PIN_W34 -to mem_dm[3]
# set_location_assignment PIN_U24 -to mem_dqs[3]
# set_location_assignment PIN_B8 -to AUX_RX_PC
# set_location_assignment PIN_A8 -to AUX_RX_NC
set_location_assignment PIN_F11 -to RX_HPD
set_location_assignment PIN_K14 -to AUX_RX_DRV_IN
set_location_assignment PIN_C13 -to RX_SENSE_P
set_location_assignment PIN_C12 -to RX_SENSE_N
# set_location_assignment PIN_E15 -to AUX_TX_PC
# set_location_assignment PIN_D15 -to AUX_TX_NC
set_location_assignment PIN_L17 -to TX_HPD
set_location_assignment PIN_F15 -to AUX_TX_DRV_IN
set_location_assignment PIN_AF18 -to refclk2_qr1_p

# Analysis & Synthesis Assignments
# ================================
set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to SCL_CTL
set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to SDA_CTL
set_global_assignment -name NUM_PARALLEL_PROCESSORS ALL
set_global_assignment -name SEED 1

# Fitter Assignments
# ==================
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
# set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 2.5-V SSTL CLASS II" -to AUX_RX_NC
# set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 2.5-V SSTL CLASS II" -to AUX_RX_PC
# set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 2.5-V SSTL CLASS II" -to AUX_TX_NC
# set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 2.5-V SSTL CLASS II" -to AUX_TX_PC
set_instance_assignment -name XCVR_TX_PLL_RECONFIG_GROUP 0 -to *cmu_pll.tx_pll
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to SCL_CTL
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to SDA_CTL
set_instance_assignment -name CURRENT_STRENGTH_NEW 16MA -to RX_HPD
set_instance_assignment -name IO_STANDARD LVDS -to refclk2_qr1_p
set_instance_assignment -name XCVR_RX_LINEAR_EQUALIZER_CONTROL 0 -to rx_serial_data[*]
