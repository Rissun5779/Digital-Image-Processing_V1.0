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


onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TB
add wave -noupdate /tb_top/is_lockedtodata
add wave -noupdate /tb_top/rx_is_lockedtodata
add wave -noupdate /tb_top/data_valid
add wave -noupdate /tb_top/data_error
add wave -noupdate /tb_top/rx_link_error
add wave -noupdate /tb_top/tx_link_error
add wave -noupdate /tb_top/test_passed
add wave -noupdate /tb_top/test_pass_count_reg
add wave -noupdate /tb_top/test_passed_count_match
add wave -noupdate -divider {LINK 0}
add wave -noupdate -group {PATTERN GEN L0} {/tb_top/u_jesd204b_ed/GENERATOR[0]/u_gen/avst_dataout}
add wave -noupdate -group {PATTERN GEN L0} {/tb_top/u_jesd204b_ed/GENERATOR[0]/u_gen/clk}
add wave -noupdate -group {PATTERN GEN L0} {/tb_top/u_jesd204b_ed/GENERATOR[0]/u_gen/csr_m}
add wave -noupdate -group {PATTERN GEN L0} {/tb_top/u_jesd204b_ed/GENERATOR[0]/u_gen/csr_s}
add wave -noupdate -group {PATTERN GEN L0} {/tb_top/u_jesd204b_ed/GENERATOR[0]/u_gen/csr_tx_testmode}
add wave -noupdate -group {PATTERN GEN L0} {/tb_top/u_jesd204b_ed/GENERATOR[0]/u_gen/error_inject}
add wave -noupdate -group {PATTERN GEN L0} {/tb_top/u_jesd204b_ed/GENERATOR[0]/u_gen/ready}
add wave -noupdate -group {PATTERN GEN L0} {/tb_top/u_jesd204b_ed/GENERATOR[0]/u_gen/rst_n}
add wave -noupdate -group {PATTERN GEN L0} {/tb_top/u_jesd204b_ed/GENERATOR[0]/u_gen/valid}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/ASSEMBLER[0]/u_tx_transport/csr_f}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/ASSEMBLER[0]/u_tx_transport/csr_l}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/ASSEMBLER[0]/u_tx_transport/csr_n}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/ASSEMBLER[0]/u_tx_transport/jesd204_tx_controlin}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/ASSEMBLER[0]/u_tx_transport/jesd204_tx_data_ready}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/ASSEMBLER[0]/u_tx_transport/jesd204_tx_data_valid}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/ASSEMBLER[0]/u_tx_transport/jesd204_tx_datain}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/ASSEMBLER[0]/u_tx_transport/jesd204_tx_link_data_valid}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/ASSEMBLER[0]/u_tx_transport/jesd204_tx_link_datain}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/ASSEMBLER[0]/u_tx_transport/jesd204_tx_link_early_ready}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/ASSEMBLER[0]/u_tx_transport/jesd204_tx_link_error}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/ASSEMBLER[0]/u_tx_transport/txframe_clk}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/ASSEMBLER[0]/u_tx_transport/txframe_rst_n}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/ASSEMBLER[0]/u_tx_transport/txlink_clk}
add wave -noupdate -group {TX TRANSPORT L0} {/tb_top/u_jesd204b_ed/ASSEMBLER[0]/u_tx_transport/txlink_rst_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/alldev_lane_aligned}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/csr_rx_testmode}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/csr_tx_testmode}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/csr_tx_testpattern_a}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/csr_tx_testpattern_b}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/csr_tx_testpattern_c}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/csr_tx_testpattern_d}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/dev_lane_aligned}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_rx_avs_address}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_rx_avs_chipselect}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_rx_avs_clk}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_rx_avs_read}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_rx_avs_readdata}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_rx_avs_rst_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_rx_avs_waitrequest}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_rx_avs_write}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_rx_avs_writedata}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_rx_dlb_data}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_rx_dlb_data_valid}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_rx_dlb_disperr}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_rx_dlb_errdetect}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_rx_dlb_kchar_data}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_rx_frame_error}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_rx_int}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_rx_link_data}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_rx_link_ready}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_rx_link_valid}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_tx_avs_address}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_tx_avs_chipselect}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_tx_avs_clk}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_tx_avs_read}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_tx_avs_readdata}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_tx_avs_rst_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_tx_avs_waitrequest}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_tx_avs_write}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_tx_avs_writedata}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_tx_dlb_data}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_tx_dlb_kchar_data}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_tx_frame_error}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_tx_frame_ready}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_tx_int}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_tx_link_data}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_tx_link_ready}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/jesd204_tx_link_valid}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/mdev_sync_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/pll_locked}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_analogreset}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_cal_busy}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_csr_cf}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_csr_cs}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_csr_f}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_csr_hd}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_csr_k}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_csr_l}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_csr_lane_powerdown}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_csr_m}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_csr_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_csr_np}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_csr_s}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_dev_sync_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_digitalreset}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_islockedtodata}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_pll_ref_clk}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_serial_data}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_seriallpbken}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_sof}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_somf}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rx_sysref}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rxlink_clk}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rxlink_rst_n_reset_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/rxphy_clk}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/sync_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/tx_analogreset}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/tx_cal_busy}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/tx_csr_cf}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/tx_csr_cs}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/tx_csr_f}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/tx_csr_hd}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/tx_csr_k}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/tx_csr_l}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/tx_csr_lane_powerdown}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/tx_csr_m}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/tx_csr_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/tx_csr_np}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/tx_csr_s}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/tx_dev_sync_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/tx_digitalreset}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/tx_serial_data}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/tx_sysref}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/txlink_clk}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/txlink_rst_n_reset_n}
add wave -noupdate -group {JESD204B BASE CORE 222 L0} {/tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE[0]/u_jesd204/txphy_clk}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/DEASSEMBLER[0]/u_rx_transport/csr_f}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/DEASSEMBLER[0]/u_rx_transport/csr_l}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/DEASSEMBLER[0]/u_rx_transport/csr_n}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/DEASSEMBLER[0]/u_rx_transport/jesd204_rx_controlout}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/DEASSEMBLER[0]/u_rx_transport/jesd204_rx_data_ready}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/DEASSEMBLER[0]/u_rx_transport/jesd204_rx_data_valid}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/DEASSEMBLER[0]/u_rx_transport/jesd204_rx_dataout}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/DEASSEMBLER[0]/u_rx_transport/jesd204_rx_link_data_ready}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/DEASSEMBLER[0]/u_rx_transport/jesd204_rx_link_data_valid}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/DEASSEMBLER[0]/u_rx_transport/jesd204_rx_link_datain}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/DEASSEMBLER[0]/u_rx_transport/jesd204_rx_link_error}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/DEASSEMBLER[0]/u_rx_transport/rxframe_clk}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/DEASSEMBLER[0]/u_rx_transport/rxframe_rst_n}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/DEASSEMBLER[0]/u_rx_transport/rxlink_clk}
add wave -noupdate -group {RX TRANSPORT L0} {/tb_top/u_jesd204b_ed/DEASSEMBLER[0]/u_rx_transport/rxlink_rst_n}
add wave -noupdate -group {PATTERN CHK L0} {/tb_top/u_jesd204b_ed/CHECKER[0]/u_chk/avst_datain}
add wave -noupdate -group {PATTERN CHK L0} {/tb_top/u_jesd204b_ed/CHECKER[0]/u_chk/clk}
add wave -noupdate -group {PATTERN CHK L0} {/tb_top/u_jesd204b_ed/CHECKER[0]/u_chk/csr_m}
add wave -noupdate -group {PATTERN CHK L0} {/tb_top/u_jesd204b_ed/CHECKER[0]/u_chk/csr_rx_testmode}
add wave -noupdate -group {PATTERN CHK L0} {/tb_top/u_jesd204b_ed/CHECKER[0]/u_chk/csr_s}
add wave -noupdate -group {PATTERN CHK L0} {/tb_top/u_jesd204b_ed/CHECKER[0]/u_chk/err_out}
add wave -noupdate -group {PATTERN CHK L0} {/tb_top/u_jesd204b_ed/CHECKER[0]/u_chk/ready}
add wave -noupdate -group {PATTERN CHK L0} {/tb_top/u_jesd204b_ed/CHECKER[0]/u_chk/rst_n}
add wave -noupdate -group {PATTERN CHK L0} {/tb_top/u_jesd204b_ed/CHECKER[0]/u_chk/valid}
add wave -noupdate -divider PLL
add wave -noupdate -group {Core PLL} /tb_top/u_jesd204b_ed/u_pll/locked
add wave -noupdate -group {Core PLL} /tb_top/u_jesd204b_ed/u_pll/outclk_0
add wave -noupdate -group {Core PLL} /tb_top/u_jesd204b_ed/u_pll/outclk_1
add wave -noupdate -group {Core PLL} /tb_top/u_jesd204b_ed/u_pll/reconfig_from_pll
add wave -noupdate -group {Core PLL} /tb_top/u_jesd204b_ed/u_pll/reconfig_to_pll
add wave -noupdate -group {Core PLL} /tb_top/u_jesd204b_ed/u_pll/refclk
add wave -noupdate -group {Core PLL} /tb_top/u_jesd204b_ed/u_pll/rst
add wave -noupdate -divider {CONTROL UNIT}
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/avs_rst_n
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/clk
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/cu_busy
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/current_state
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/frame_rst_n
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/jesd204_rx_avs_address
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/jesd204_rx_avs_chipselect
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/jesd204_rx_avs_read
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/jesd204_rx_avs_readdata
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/jesd204_rx_avs_waitrequest
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/jesd204_rx_avs_write
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/jesd204_rx_avs_writedata
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/jesd204_tx_avs_address
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/jesd204_tx_avs_chipselect
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/jesd204_tx_avs_read
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/jesd204_tx_avs_readdata
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/jesd204_tx_avs_waitrequest
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/jesd204_tx_avs_write
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/jesd204_tx_avs_writedata
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/link_rst_n
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/pll_mgmt_address
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/pll_mgmt_read
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/pll_mgmt_readdata
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/pll_mgmt_waitrequest
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/pll_mgmt_write
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/pll_mgmt_writedata
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/reconfig
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/rst_n
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/runtime_datarate
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/runtime_lmf
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/rx_ready
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/spi_addr
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/spi_read_n
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/spi_rrdy
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/spi_rxdata
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/spi_select
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/spi_trdy
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/spi_txdata
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/spi_write_n
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/tx_ready
add wave -noupdate -group {Control Unit} /tb_top/u_jesd204b_ed/u_cu/xcvr_rst_n
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
