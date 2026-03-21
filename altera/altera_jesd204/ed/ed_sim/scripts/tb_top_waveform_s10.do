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


# (C) 2001-2016 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


onerror {resume}
quietly WaveActivateNextPane {} 0
log -r /tb_top/*
#add dataflow -r /tb_top/*
add wave -noupdate -divider TB
add wave -noupdate /tb_top/refclk_core
add wave -noupdate /tb_top/refclk_xcvr
add wave -noupdate /tb_top/mgmt_clk 
add wave -noupdate /tb_top/rst_n 
add wave -noupdate /tb_top/rst 
add wave -noupdate /tb_top/sysref 
add wave -noupdate /tb_top/tx_link_error_reg 
add wave -noupdate /tb_top/rx_link_error_reg 
add wave -noupdate /tb_top/data_error_reg 
add wave -noupdate /tb_top/tx_testmode 
add wave -noupdate /tb_top/rx_testmode
add wave -noupdate /tb_top/rx_seriallpbken 
add wave -noupdate /tb_top/tx_serial_data 
add wave -noupdate /tb_top/rx_serial_data 
add wave -noupdate /tb_top/data_valid 
add wave -noupdate /tb_top/data_error 
add wave -noupdate /tb_top/tx_link_error 
add wave -noupdate /tb_top/rx_link_error 
add wave -noupdate /tb_top/test_passed 
add wave -noupdate -divider {LINK 0}
add wave -noupdate -group {PATTERN GEN L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_gen/avst_dataout}
add wave -noupdate -group {PATTERN GEN L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_gen/clk}
add wave -noupdate -group {PATTERN GEN L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_gen/csr_m}
add wave -noupdate -group {PATTERN GEN L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_gen/csr_s}
add wave -noupdate -group {PATTERN GEN L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_gen/csr_tx_testmode}
add wave -noupdate -group {PATTERN GEN L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_gen/error_inject}
add wave -noupdate -group {PATTERN GEN L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_gen/ready}
add wave -noupdate -group {PATTERN GEN L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_gen/rst_n}
add wave -noupdate -group {PATTERN GEN L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_gen/valid}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_tx/csr_f}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_tx/csr_l}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_tx/csr_n}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_tx/jesd204_tx_controlin}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_tx/jesd204_tx_data_ready}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_tx/jesd204_tx_data_valid}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_tx/jesd204_tx_datain}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_tx/jesd204_tx_link_data_valid}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_tx/jesd204_tx_link_datain}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_tx/jesd204_tx_link_early_ready}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_tx/jesd204_tx_link_error}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_tx/txframe_clk}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_tx/txframe_rst_n}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_tx/txlink_clk}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_tx/txlink_rst_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/alldev_lane_aligned}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/csr_rx_testmode}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/csr_tx_testmode}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/csr_tx_testpattern_a}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/csr_tx_testpattern_b}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/csr_tx_testpattern_c}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/csr_tx_testpattern_d}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/dev_lane_aligned}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_rx_avs_address}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_rx_avs_chipselect}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_rx_avs_clk}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_rx_avs_read}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_rx_avs_readdata}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_rx_avs_rst_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_rx_avs_waitrequest}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_rx_avs_write}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_rx_avs_writedata}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_rx_dlb_data}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_rx_dlb_data_valid}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_rx_dlb_disperr}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_rx_dlb_errdetect}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_rx_dlb_kchar_data}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_rx_frame_error}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_rx_int}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_rx_link_data}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_rx_link_ready}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_rx_link_valid}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_tx_avs_address}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_tx_avs_chipselect}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_tx_avs_clk}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_tx_avs_read}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_tx_avs_readdata}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_tx_avs_rst_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_tx_avs_waitrequest}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_tx_avs_write}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_tx_avs_writedata}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_tx_dlb_data}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_tx_dlb_kchar_data}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_tx_frame_error}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_tx_frame_ready}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_tx_int}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_tx_link_data}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_tx_link_ready}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/jesd204_tx_link_valid}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/mdev_sync_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/pll_locked}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_analogreset}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_cal_busy}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_csr_cf}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_csr_cs}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_csr_f}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_csr_hd}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_csr_k}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_csr_l}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_csr_lane_powerdown}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_csr_m}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_csr_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_csr_np}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_csr_s}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_dev_sync_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_digitalreset}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_islockedtodata}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_pll_ref_clk}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_serial_data}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_seriallpbken}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_sof}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_somf}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rx_sysref}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rxlink_clk}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rxlink_rst_n_reset_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/rxphy_clk}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/sync_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/tx_analogreset}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/tx_cal_busy}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/tx_csr_cf}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/tx_csr_cs}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/tx_csr_f}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/tx_csr_hd}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/tx_csr_k}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/tx_csr_l}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/tx_csr_lane_powerdown}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/tx_csr_m}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/tx_csr_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/tx_csr_np}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/tx_csr_s}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/tx_dev_sync_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/tx_digitalreset}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/tx_serial_data}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/tx_sysref}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/txlink_clk}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/txlink_rst_n_reset_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/u_jesd204b_ed_qsys/jesd204b_subsystem_0/jesd204b/txphy_clk}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_rx/csr_f}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_rx/csr_l}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_rx/csr_n}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_rx/jesd204_rx_controlout}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_rx/jesd204_rx_data_valid}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_rx/jesd204_rx_dataout}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_rx/jesd204_rx_link_data_ready}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_rx/jesd204_rx_link_data_valid}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_rx/jesd204_rx_link_datain}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_rx/jesd204_rx_link_error}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_rx/rxframe_clk}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_rx/rxframe_rst_n}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_rx/rxlink_clk}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_jesd204b_transport_rx/rxlink_rst_n}
add wave -noupdate -group {PATTERN CHK L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_chk/avst_datain}
add wave -noupdate -group {PATTERN CHK L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_chk/clk}
add wave -noupdate -group {PATTERN CHK L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_chk/csr_m}
add wave -noupdate -group {PATTERN CHK L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_chk/csr_rx_testmode}
add wave -noupdate -group {PATTERN CHK L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_chk/csr_s}
add wave -noupdate -group {PATTERN CHK L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_chk/err_out}
add wave -noupdate -group {PATTERN CHK L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_chk/ready}
add wave -noupdate -group {PATTERN CHK L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_chk/rst_n}
add wave -noupdate -group {PATTERN CHK L0} {/tb_top/u_jesd204b_ed/GEN_BLOCK[0]/u_chk/valid}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {188188949 ps} 0} {{Cursor 4} {188504212 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 314
configure wave -valuecolwidth 43
configure wave -justifyvalue left
configure wave -signalnamewidth 2
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {630 us}
