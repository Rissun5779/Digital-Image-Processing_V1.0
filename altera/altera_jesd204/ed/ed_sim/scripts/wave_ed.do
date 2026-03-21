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
add wave -noupdate /tb_top/rx_is_lockedtodata
add wave -noupdate /tb_top/is_lockedtodata
add wave -noupdate /tb_top/data_valid
add wave -noupdate /tb_top/data_error
add wave -noupdate /tb_top/tx_link_error
add wave -noupdate /tb_top/rx_link_error
add wave -noupdate /tb_top/test_passed
add wave -noupdate -divider {PATTERN GEN 0}
add wave -noupdate {/tb_top/u_jesd204b_ed/GENERATOR[0]/u_gen/clk}
add wave -noupdate {/tb_top/u_jesd204b_ed/GENERATOR[0]/u_gen/rst_n}
add wave -noupdate {/tb_top/u_jesd204b_ed/GENERATOR[0]/u_gen/dout}
add wave -noupdate {/tb_top/u_jesd204b_ed/GENERATOR[0]/u_gen/dout_valid}
add wave -noupdate -divider {PATTERN GEN 1}
add wave -noupdate {/tb_top/u_jesd204b_ed/GENERATOR[1]/u_gen/clk}
add wave -noupdate {/tb_top/u_jesd204b_ed/GENERATOR[1]/u_gen/rst_n}
add wave -noupdate {/tb_top/u_jesd204b_ed/GENERATOR[1]/u_gen/dout}
add wave -noupdate {/tb_top/u_jesd204b_ed/GENERATOR[1]/u_gen/dout_valid}
add wave -noupdate -divider {PATTERN GEN 2}
add wave -noupdate {/tb_top/u_jesd204b_ed/GENERATOR[2]/u_gen/clk}
add wave -noupdate {/tb_top/u_jesd204b_ed/GENERATOR[2]/u_gen/rst_n}
add wave -noupdate {/tb_top/u_jesd204b_ed/GENERATOR[2]/u_gen/dout}
add wave -noupdate {/tb_top/u_jesd204b_ed/GENERATOR[2]/u_gen/dout_valid}
add wave -noupdate -divider {PATTERN GEN 3}
add wave -noupdate {/tb_top/u_jesd204b_ed/GENERATOR[3]/u_gen/clk}
add wave -noupdate {/tb_top/u_jesd204b_ed/GENERATOR[3]/u_gen/rst_n}
add wave -noupdate {/tb_top/u_jesd204b_ed/GENERATOR[3]/u_gen/dout}
add wave -noupdate {/tb_top/u_jesd204b_ed/GENERATOR[3]/u_gen/dout_valid}
add wave -noupdate -divider {TX TRANSPORT}
add wave -noupdate /tb_top/u_jesd204b_ed/TX_TRANSPORT_1X_LINK/u_tx_transport/txlink_rst_n
add wave -noupdate /tb_top/u_jesd204b_ed/TX_TRANSPORT_1X_LINK/u_tx_transport/txframe_rst_n
add wave -noupdate /tb_top/u_jesd204b_ed/TX_TRANSPORT_1X_LINK/u_tx_transport/txframe_clk
add wave -noupdate /tb_top/u_jesd204b_ed/TX_TRANSPORT_1X_LINK/u_tx_transport/txlink_clk
add wave -noupdate /tb_top/u_jesd204b_ed/TX_TRANSPORT_1X_LINK/u_tx_transport/jesd204_tx_datain
add wave -noupdate /tb_top/u_jesd204b_ed/TX_TRANSPORT_1X_LINK/u_tx_transport/jesd204_tx_data_valid
add wave -noupdate /tb_top/u_jesd204b_ed/TX_TRANSPORT_1X_LINK/u_tx_transport/jesd204_tx_link_early_ready
add wave -noupdate /tb_top/u_jesd204b_ed/TX_TRANSPORT_1X_LINK/u_tx_transport/jesd204_tx_link_data_ready
add wave -noupdate /tb_top/u_jesd204b_ed/TX_TRANSPORT_1X_LINK/u_tx_transport/csr_lane_pd
add wave -noupdate /tb_top/u_jesd204b_ed/TX_TRANSPORT_1X_LINK/u_tx_transport/csr_l
add wave -noupdate /tb_top/u_jesd204b_ed/TX_TRANSPORT_1X_LINK/u_tx_transport/csr_m
add wave -noupdate /tb_top/u_jesd204b_ed/TX_TRANSPORT_1X_LINK/u_tx_transport/csr_f
add wave -noupdate /tb_top/u_jesd204b_ed/TX_TRANSPORT_1X_LINK/u_tx_transport/csr_n
add wave -noupdate /tb_top/u_jesd204b_ed/TX_TRANSPORT_1X_LINK/u_tx_transport/csr_s
add wave -noupdate /tb_top/u_jesd204b_ed/TX_TRANSPORT_1X_LINK/u_tx_transport/csr_tx_testmode
add wave -noupdate /tb_top/u_jesd204b_ed/TX_TRANSPORT_1X_LINK/u_tx_transport/jesd204_tx_data_ready
add wave -noupdate /tb_top/u_jesd204b_ed/TX_TRANSPORT_1X_LINK/u_tx_transport/jesd204_tx_link_error
add wave -noupdate /tb_top/u_jesd204b_ed/TX_TRANSPORT_1X_LINK/u_tx_transport/jesd204_tx_link_datain
add wave -noupdate /tb_top/u_jesd204b_ed/TX_TRANSPORT_1X_LINK/u_tx_transport/jesd204_tx_link_data_valid
add wave -noupdate -divider {JESD204B BASE CORE 442}
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/tx_pll_ref_clk
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/txlink_clk
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/txlink_rst_n_reset_n
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_tx_avs_clk
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_tx_avs_rst_n
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_tx_avs_chipselect
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_tx_avs_address
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_tx_avs_read
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_tx_avs_readdata
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_tx_avs_waitrequest
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_tx_avs_write
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_tx_avs_writedata
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_tx_link_data
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_tx_link_valid
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_tx_link_ready
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_tx_int
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/tx_sysref
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/sync_n
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/tx_dev_sync_n
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/mdev_sync_n
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_tx_frame_ready
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/tx_csr_l
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/tx_csr_f
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/tx_csr_k
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/tx_csr_m
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/tx_csr_cs
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/tx_csr_n
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/tx_csr_np
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/tx_csr_s
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/tx_csr_hd
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/tx_csr_cf
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/tx_csr_lane_powerdown
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/csr_tx_testmode
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/csr_tx_testpattern_a
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/csr_tx_testpattern_b
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/csr_tx_testpattern_c
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/csr_tx_testpattern_d
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_tx_frame_error
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_tx_dlb_data
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_tx_dlb_kchar_data
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/txphy_clk
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/tx_serial_data
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/pll_powerdown
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/tx_analogreset
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/tx_digitalreset
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/pll_locked
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/tx_cal_busy
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_pll_ref_clk
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rxlink_clk
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rxlink_rst_n_reset_n
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_rx_avs_clk
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_rx_avs_rst_n
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_rx_avs_chipselect
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_rx_avs_address
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_rx_avs_read
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_rx_avs_readdata
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_rx_avs_waitrequest
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_rx_avs_write
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_rx_avs_writedata
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_rx_link_data
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_rx_link_valid
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_rx_link_ready
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_rx_dlb_data
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_rx_dlb_data_valid
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_rx_dlb_kchar_data
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_rx_dlb_errdetect
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_rx_dlb_disperr
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/alldev_lane_aligned
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_sysref
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_rx_frame_error
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/jesd204_rx_int
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/csr_rx_testmode
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/dev_lane_aligned
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_dev_sync_n
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_sof
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_somf
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_csr_f
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_csr_k
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_csr_l
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_csr_m
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_csr_n
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_csr_s
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_csr_cf
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_csr_cs
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_csr_hd
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_csr_np
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_csr_lane_powerdown
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rxphy_clk
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_serial_data
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_analogreset
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_digitalreset
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/reconfig_to_xcvr
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/reconfig_from_xcvr
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_islockedtodata
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_cal_busy
add wave -noupdate /tb_top/u_jesd204b_ed/JESD204B_DUPLEX_CORE_442_1X/u_jesd204b_442/rx_seriallpbken
add wave -noupdate -divider {RX TRANSPORT}
add wave -noupdate /tb_top/u_jesd204b_ed/RX_TRANSPORT_1X_LINK/u_rx_transport/rxlink_rst_n
add wave -noupdate /tb_top/u_jesd204b_ed/RX_TRANSPORT_1X_LINK/u_rx_transport/rxframe_rst_n
add wave -noupdate /tb_top/u_jesd204b_ed/RX_TRANSPORT_1X_LINK/u_rx_transport/rxframe_clk
add wave -noupdate /tb_top/u_jesd204b_ed/RX_TRANSPORT_1X_LINK/u_rx_transport/rxlink_clk
add wave -noupdate /tb_top/u_jesd204b_ed/RX_TRANSPORT_1X_LINK/u_rx_transport/jesd204_rx_link_data_valid
add wave -noupdate /tb_top/u_jesd204b_ed/RX_TRANSPORT_1X_LINK/u_rx_transport/jesd204_rx_link_datain
add wave -noupdate /tb_top/u_jesd204b_ed/RX_TRANSPORT_1X_LINK/u_rx_transport/jesd204_rx_data_ready
add wave -noupdate /tb_top/u_jesd204b_ed/RX_TRANSPORT_1X_LINK/u_rx_transport/csr_lane_pd
add wave -noupdate /tb_top/u_jesd204b_ed/RX_TRANSPORT_1X_LINK/u_rx_transport/csr_l
add wave -noupdate /tb_top/u_jesd204b_ed/RX_TRANSPORT_1X_LINK/u_rx_transport/csr_m
add wave -noupdate /tb_top/u_jesd204b_ed/RX_TRANSPORT_1X_LINK/u_rx_transport/csr_f
add wave -noupdate /tb_top/u_jesd204b_ed/RX_TRANSPORT_1X_LINK/u_rx_transport/csr_n
add wave -noupdate /tb_top/u_jesd204b_ed/RX_TRANSPORT_1X_LINK/u_rx_transport/csr_s
add wave -noupdate /tb_top/u_jesd204b_ed/RX_TRANSPORT_1X_LINK/u_rx_transport/csr_tx_testmode
add wave -noupdate /tb_top/u_jesd204b_ed/RX_TRANSPORT_1X_LINK/u_rx_transport/jesd204_rx_dataout
add wave -noupdate /tb_top/u_jesd204b_ed/RX_TRANSPORT_1X_LINK/u_rx_transport/jesd204_rx_data_valid
add wave -noupdate /tb_top/u_jesd204b_ed/RX_TRANSPORT_1X_LINK/u_rx_transport/jesd204_rx_link_error
add wave -noupdate /tb_top/u_jesd204b_ed/RX_TRANSPORT_1X_LINK/u_rx_transport/jesd204_rx_link_data_ready
add wave -noupdate -divider {PATTERN CHK 0}
add wave -noupdate {/tb_top/u_jesd204b_ed/CHECKER[0]/u_chk/clk}
add wave -noupdate {/tb_top/u_jesd204b_ed/CHECKER[0]/u_chk/rst_n}
add wave -noupdate {/tb_top/u_jesd204b_ed/CHECKER[0]/u_chk/din}
add wave -noupdate {/tb_top/u_jesd204b_ed/CHECKER[0]/u_chk/en}
add wave -noupdate {/tb_top/u_jesd204b_ed/CHECKER[0]/u_chk/error}
add wave -noupdate -divider {PATTERN CHK 1}
add wave -noupdate {/tb_top/u_jesd204b_ed/CHECKER[1]/u_chk/clk}
add wave -noupdate {/tb_top/u_jesd204b_ed/CHECKER[1]/u_chk/rst_n}
add wave -noupdate {/tb_top/u_jesd204b_ed/CHECKER[1]/u_chk/din}
add wave -noupdate {/tb_top/u_jesd204b_ed/CHECKER[1]/u_chk/en}
add wave -noupdate {/tb_top/u_jesd204b_ed/CHECKER[1]/u_chk/error}
add wave -noupdate -divider {PATTERN CHK 2}
add wave -noupdate {/tb_top/u_jesd204b_ed/CHECKER[2]/u_chk/clk}
add wave -noupdate {/tb_top/u_jesd204b_ed/CHECKER[2]/u_chk/rst_n}
add wave -noupdate {/tb_top/u_jesd204b_ed/CHECKER[2]/u_chk/din}
add wave -noupdate {/tb_top/u_jesd204b_ed/CHECKER[2]/u_chk/en}
add wave -noupdate {/tb_top/u_jesd204b_ed/CHECKER[2]/u_chk/error}
add wave -noupdate -divider {PATTERN CHK 3}
add wave -noupdate {/tb_top/u_jesd204b_ed/CHECKER[3]/u_chk/clk}
add wave -noupdate {/tb_top/u_jesd204b_ed/CHECKER[3]/u_chk/rst_n}
add wave -noupdate {/tb_top/u_jesd204b_ed/CHECKER[3]/u_chk/din}
add wave -noupdate {/tb_top/u_jesd204b_ed/CHECKER[3]/u_chk/en}
add wave -noupdate {/tb_top/u_jesd204b_ed/CHECKER[3]/u_chk/error}
add wave -noupdate -divider {CONTROL UNIT}
add wave -noupdate /tb_top/u_jesd204b_ed/u_cu/clk
add wave -noupdate /tb_top/u_jesd204b_ed/u_cu/rst_n
add wave -noupdate /tb_top/u_jesd204b_ed/u_cu/tx_ready
add wave -noupdate /tb_top/u_jesd204b_ed/u_cu/rx_ready
add wave -noupdate /tb_top/u_jesd204b_ed/u_cu/avs_rst_n
add wave -noupdate /tb_top/u_jesd204b_ed/u_cu/frame_rst_n
add wave -noupdate /tb_top/u_jesd204b_ed/u_cu/link_rst_n
add wave -noupdate /tb_top/u_jesd204b_ed/u_cu/spi_trdy
add wave -noupdate /tb_top/u_jesd204b_ed/u_cu/spi_rrdy
add wave -noupdate /tb_top/u_jesd204b_ed/u_cu/spi_rxdata
add wave -noupdate /tb_top/u_jesd204b_ed/u_cu/spi_read_n
add wave -noupdate /tb_top/u_jesd204b_ed/u_cu/spi_write_n
add wave -noupdate /tb_top/u_jesd204b_ed/u_cu/spi_select
add wave -noupdate /tb_top/u_jesd204b_ed/u_cu/spi_addr
add wave -noupdate /tb_top/u_jesd204b_ed/u_cu/spi_txdata
add wave -noupdate -divider {SPI MASTER}
add wave -noupdate /tb_top/u_jesd204b_ed/u_spi_master/MOSI
add wave -noupdate /tb_top/u_jesd204b_ed/u_spi_master/SCLK
add wave -noupdate /tb_top/u_jesd204b_ed/u_spi_master/SS_n
add wave -noupdate /tb_top/u_jesd204b_ed/u_spi_master/data_to_cpu
add wave -noupdate /tb_top/u_jesd204b_ed/u_spi_master/dataavailable
add wave -noupdate /tb_top/u_jesd204b_ed/u_spi_master/endofpacket
add wave -noupdate /tb_top/u_jesd204b_ed/u_spi_master/irq
add wave -noupdate /tb_top/u_jesd204b_ed/u_spi_master/readyfordata
add wave -noupdate /tb_top/u_jesd204b_ed/u_spi_master/MISO
add wave -noupdate /tb_top/u_jesd204b_ed/u_spi_master/clk
add wave -noupdate /tb_top/u_jesd204b_ed/u_spi_master/data_from_cpu
add wave -noupdate /tb_top/u_jesd204b_ed/u_spi_master/mem_addr
add wave -noupdate /tb_top/u_jesd204b_ed/u_spi_master/read_n
add wave -noupdate /tb_top/u_jesd204b_ed/u_spi_master/reset_n
add wave -noupdate /tb_top/u_jesd204b_ed/u_spi_master/spi_select
add wave -noupdate /tb_top/u_jesd204b_ed/u_spi_master/write_n
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {93608340 ps} 0}
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
WaveRestoreZoom {0 ps} {332372855 ps}
