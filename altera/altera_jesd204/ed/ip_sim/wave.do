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

add wave -noupdate -group {TX - Clocks and Resets} -radix hexadecimal /tb_jesd204/tx_dut/pll_ref_clk
add wave -noupdate -group {TX - Clocks and Resets} -radix hexadecimal /tb_jesd204/tx_dut/txlink_clk
add wave -noupdate -group {TX - Clocks and Resets} -radix hexadecimal /tb_jesd204/tx_dut/txlink_rst_n_reset_n
add wave -noupdate -group {TX - Clocks and Resets} -radix hexadecimal /tb_jesd204/tx_dut/txphy_clk
add wave -noupdate -group {RX - Clocks and Resets} -radix hexadecimal /tb_jesd204/rx_dut/pll_ref_clk
add wave -noupdate -group {RX - Clocks and Resets} -radix hexadecimal /tb_jesd204/rx_dut/rxlink_clk
add wave -noupdate -group {RX - Clocks and Resets} -radix hexadecimal /tb_jesd204/rx_dut/rxlink_rst_n_reset_n
add wave -noupdate -group {RX - Clocks and Resets} -radix hexadecimal /tb_jesd204/rx_dut/rxphy_clk
add wave -noupdate -group AV-MM -radix hexadecimal /tb_jesd204/tx_dut/jesd204_tx_avs_clk
add wave -noupdate -group AV-MM -radix hexadecimal /tb_jesd204/tx_dut/jesd204_tx_avs_rst_n
add wave -noupdate -group AV-MM -radix hexadecimal /tb_jesd204/tx_dut/jesd204_tx_avs_chipselect
add wave -noupdate -group AV-MM -radix hexadecimal /tb_jesd204/tx_dut/jesd204_tx_avs_address
add wave -noupdate -group AV-MM -radix hexadecimal /tb_jesd204/tx_dut/jesd204_tx_avs_read
add wave -noupdate -group AV-MM -radix hexadecimal /tb_jesd204/tx_dut/jesd204_tx_avs_readdata
add wave -noupdate -group AV-MM -radix hexadecimal /tb_jesd204/tx_dut/jesd204_tx_avs_waitrequest
add wave -noupdate -group AV-MM -radix hexadecimal /tb_jesd204/tx_dut/jesd204_tx_avs_write
add wave -noupdate -group AV-MM -radix hexadecimal /tb_jesd204/tx_dut/jesd204_tx_avs_writedata
add wave -noupdate -group AV-MM -radix hexadecimal /tb_jesd204/rx_dut/jesd204_rx_avs_clk
add wave -noupdate -group AV-MM -radix hexadecimal /tb_jesd204/rx_dut/jesd204_rx_avs_rst_n
add wave -noupdate -group AV-MM -radix hexadecimal /tb_jesd204/rx_dut/jesd204_rx_avs_chipselect
add wave -noupdate -group AV-MM -radix hexadecimal /tb_jesd204/rx_dut/jesd204_rx_avs_address
add wave -noupdate -group AV-MM -radix hexadecimal /tb_jesd204/rx_dut/jesd204_rx_avs_read
add wave -noupdate -group AV-MM -radix hexadecimal /tb_jesd204/rx_dut/jesd204_rx_avs_readdata
add wave -noupdate -group AV-MM -radix hexadecimal /tb_jesd204/rx_dut/jesd204_rx_avs_waitrequest
add wave -noupdate -group AV-MM -radix hexadecimal /tb_jesd204/rx_dut/jesd204_rx_avs_write
add wave -noupdate -group AV-MM -radix hexadecimal /tb_jesd204/rx_dut/jesd204_rx_avs_writedata
add wave -noupdate -group AV-ST -radix hexadecimal /tb_jesd204/tx_dut/jesd204_tx_link_data
add wave -noupdate -group AV-ST -radix hexadecimal /tb_jesd204/tx_dut/jesd204_tx_link_valid
add wave -noupdate -group AV-ST -radix hexadecimal /tb_jesd204/tx_dut/jesd204_tx_link_ready
add wave -noupdate -group AV-ST -radix hexadecimal /tb_jesd204/rx_dut/jesd204_rx_link_data
add wave -noupdate -group AV-ST -radix hexadecimal /tb_jesd204/rx_dut/jesd204_rx_link_valid
add wave -noupdate -group AV-ST -radix hexadecimal /tb_jesd204/rx_dut/jesd204_rx_link_ready
add wave -noupdate -group {OOB Signals} -radix hexadecimal /tb_jesd204/tx_dut/jesd204_tx_int
add wave -noupdate -group {OOB Signals} -radix hexadecimal /tb_jesd204/rx_dut/jesd204_rx_int
add wave -noupdate -group {JESD204B TX specific interfaces} -radix hexadecimal /tb_jesd204/tx_dut/sysref
add wave -noupdate -group {JESD204B TX specific interfaces} -radix hexadecimal /tb_jesd204/tx_dut/sync_n
add wave -noupdate -group {JESD204B TX specific interfaces} -radix hexadecimal /tb_jesd204/tx_dut/dev_sync_n
add wave -noupdate -group {JESD204B TX specific interfaces} -radix hexadecimal /tb_jesd204/tx_dut/mdev_sync_n
add wave -noupdate -group {JESD204B TX specific interfaces} -radix hexadecimal /tb_jesd204/tx_dut/jesd204_tx_frame_ready
add wave -noupdate -group {JESD204B RX specific interfaces} -radix hexadecimal /tb_jesd204/rx_dut/sysref
add wave -noupdate -group {JESD204B RX specific interfaces} -radix hexadecimal /tb_jesd204/rx_dut/dev_sync_n
add wave -noupdate -group {JESD204B RX specific interfaces} -radix hexadecimal /tb_jesd204/rx_dut/dev_lane_aligned
add wave -noupdate -group {JESD204B RX specific interfaces} -radix hexadecimal /tb_jesd204/rx_dut/alldev_lane_aligned
add wave -noupdate -group {JESD204B RX specific interfaces} -radix hexadecimal /tb_jesd204/rx_dut/sof
add wave -noupdate -group {JESD204B RX specific interfaces} -radix hexadecimal /tb_jesd204/rx_dut/somf
add wave -noupdate -group {TX - CSR} -radix hexadecimal /tb_jesd204/tx_dut/jesd204_tx_frame_error
add wave -noupdate -group {TX - CSR} -radix hexadecimal /tb_jesd204/tx_dut/csr_l
add wave -noupdate -group {TX - CSR} -radix hexadecimal /tb_jesd204/tx_dut/csr_f
add wave -noupdate -group {TX - CSR} -radix hexadecimal /tb_jesd204/tx_dut/csr_k
add wave -noupdate -group {TX - CSR} -radix hexadecimal /tb_jesd204/tx_dut/csr_m
add wave -noupdate -group {TX - CSR} -radix hexadecimal /tb_jesd204/tx_dut/csr_cs
add wave -noupdate -group {TX - CSR} -radix hexadecimal /tb_jesd204/tx_dut/csr_n
add wave -noupdate -group {TX - CSR} -radix hexadecimal /tb_jesd204/tx_dut/csr_np
add wave -noupdate -group {TX - CSR} -radix hexadecimal /tb_jesd204/tx_dut/csr_s
add wave -noupdate -group {TX - CSR} -radix hexadecimal /tb_jesd204/tx_dut/csr_hd
add wave -noupdate -group {TX - CSR} -radix hexadecimal /tb_jesd204/tx_dut/csr_cf
add wave -noupdate -group {TX - CSR} -radix hexadecimal /tb_jesd204/tx_dut/csr_lane_powerdown
add wave -noupdate -group {TX - CSR} -radix hexadecimal /tb_jesd204/tx_dut/csr_tx_testmode
add wave -noupdate -group {TX - CSR} -radix hexadecimal /tb_jesd204/tx_dut/csr_tx_testpattern_a
add wave -noupdate -group {TX - CSR} -radix hexadecimal /tb_jesd204/tx_dut/csr_tx_testpattern_b
add wave -noupdate -group {TX - CSR} -radix hexadecimal /tb_jesd204/tx_dut/csr_tx_testpattern_c
add wave -noupdate -group {TX - CSR} -radix hexadecimal /tb_jesd204/tx_dut/csr_tx_testpattern_d
add wave -noupdate -group {RX - CSR} -radix hexadecimal /tb_jesd204/rx_dut/jesd204_rx_frame_error
add wave -noupdate -group {RX - CSR} -radix hexadecimal /tb_jesd204/rx_dut/csr_f
add wave -noupdate -group {RX - CSR} -radix hexadecimal /tb_jesd204/rx_dut/csr_k
add wave -noupdate -group {RX - CSR} -radix hexadecimal /tb_jesd204/rx_dut/csr_l
add wave -noupdate -group {RX - CSR} -radix hexadecimal /tb_jesd204/rx_dut/csr_m
add wave -noupdate -group {RX - CSR} -radix hexadecimal /tb_jesd204/rx_dut/csr_n
add wave -noupdate -group {RX - CSR} -radix hexadecimal /tb_jesd204/rx_dut/csr_s
add wave -noupdate -group {RX - CSR} -radix hexadecimal /tb_jesd204/rx_dut/csr_cf
add wave -noupdate -group {RX - CSR} -radix hexadecimal /tb_jesd204/rx_dut/csr_cs
add wave -noupdate -group {RX - CSR} -radix hexadecimal /tb_jesd204/rx_dut/csr_hd
add wave -noupdate -group {RX - CSR} -radix hexadecimal /tb_jesd204/rx_dut/csr_np
add wave -noupdate -group {RX - CSR} -radix hexadecimal /tb_jesd204/rx_dut/csr_lane_powerdown
add wave -noupdate -group {RX - CSR} -radix hexadecimal /tb_jesd204/rx_dut/csr_rx_testmode
add wave -noupdate -group {Debug Signals} -radix hexadecimal /tb_jesd204/tx_dut/jesd204_tx_dlb_data
add wave -noupdate -group {Debug Signals} -radix hexadecimal /tb_jesd204/tx_dut/jesd204_tx_dlb_kchar_data
add wave -noupdate -group {Debug Signals} -radix hexadecimal /tb_jesd204/rx_dut/jesd204_rx_dlb_data
add wave -noupdate -group {Debug Signals} -radix hexadecimal /tb_jesd204/rx_dut/jesd204_rx_dlb_data_valid
add wave -noupdate -group {Debug Signals} -radix hexadecimal /tb_jesd204/rx_dut/jesd204_rx_dlb_kchar_data
add wave -noupdate -group {Debug Signals} -radix hexadecimal /tb_jesd204/rx_dut/jesd204_rx_dlb_errdetect
add wave -noupdate -group {Debug Signals} -radix hexadecimal /tb_jesd204/rx_dut/jesd204_rx_dlb_disperr
add wave -noupdate -group {Transceiver I/O} -radix hexadecimal /tb_jesd204/tx_dut/tx_serial_data
add wave -noupdate -group {Transceiver I/O} -radix hexadecimal /tb_jesd204/rx_dut/rx_serial_data
add wave -noupdate -group {TX - PHY Reset Controller} /tb_jesd204/tx_dut/altera_jesd204_tx_inst/xcvr_rst_ctrl_clk
add wave -noupdate -group {TX - PHY Reset Controller} /tb_jesd204/tx_dut/altera_jesd204_tx_inst/xcvr_rst_ctrl_rst
add wave -noupdate -group {TX - PHY Reset Controller} /tb_jesd204/tx_dut/altera_jesd204_tx_inst/xcvr_rst_ctrl_pll_select
add wave -noupdate -group {TX - PHY Reset Controller} /tb_jesd204/tx_dut/altera_jesd204_tx_inst/xcvr_rst_ctrl_tx_ready
add wave -noupdate -group {RX - PHY Reset Controller} /tb_jesd204/rx_dut/altera_jesd204_rx_inst/xcvr_rst_ctrl_clk
add wave -noupdate -group {RX - PHY Reset Controller} /tb_jesd204/rx_dut/altera_jesd204_rx_inst/xcvr_rst_ctrl_rst
add wave -noupdate -group {RX - PHY Reset Controller} /tb_jesd204/rx_dut/altera_jesd204_rx_inst/xcvr_rst_ctrl_rx_ready
