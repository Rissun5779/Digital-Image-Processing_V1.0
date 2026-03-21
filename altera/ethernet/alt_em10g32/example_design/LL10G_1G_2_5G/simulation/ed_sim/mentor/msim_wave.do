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
add wave -noupdate -divider {ATX PLL 2.5GbE}
add wave -noupdate /tb_top/DUT/u_xcvr_atx_pll_2p5g/pll_powerdown
add wave -noupdate /tb_top/DUT/u_xcvr_atx_pll_2p5g/pll_refclk0
add wave -noupdate /tb_top/DUT/u_xcvr_atx_pll_2p5g/pll_locked
add wave -noupdate /tb_top/DUT/u_xcvr_atx_pll_2p5g/pll_cal_busy
add wave -noupdate /tb_top/DUT/u_xcvr_atx_pll_2p5g/mcgb_rst
add wave -noupdate /tb_top/DUT/u_xcvr_atx_pll_2p5g/mcgb_serial_clk
add wave -noupdate -divider {FPLL 1GbE}
add wave -noupdate /tb_top/DUT/u_xcvr_fpll_1g/pll_powerdown
add wave -noupdate /tb_top/DUT/u_xcvr_fpll_1g/pll_refclk0
add wave -noupdate /tb_top/DUT/u_xcvr_fpll_1g/pll_locked
add wave -noupdate /tb_top/DUT/u_xcvr_fpll_1g/pll_cal_busy
add wave -noupdate /tb_top/DUT/u_xcvr_fpll_1g/mcgb_rst
add wave -noupdate /tb_top/DUT/u_xcvr_fpll_1g/mcgb_serial_clk
add wave -noupdate -divider Reconfiguration
add wave -noupdate /tb_top/DUT/u_rcfg_a10/clk
add wave -noupdate /tb_top/DUT/u_rcfg_a10/rst_n
add wave -noupdate /tb_top/DUT/u_rcfg_a10/csr_rcfg_address
add wave -noupdate /tb_top/DUT/u_rcfg_a10/csr_rcfg_read
add wave -noupdate /tb_top/DUT/u_rcfg_a10/csr_rcfg_write
add wave -noupdate /tb_top/DUT/u_rcfg_a10/csr_rcfg_writedata
add wave -noupdate /tb_top/DUT/u_rcfg_a10/csr_rcfg_readdata
add wave -noupdate /tb_top/DUT/u_rcfg_a10/mode_selected
add wave -noupdate /tb_top/DUT/u_rcfg_a10/reconfig_busy
add wave -noupdate /tb_top/DUT/u_rcfg_a10/reconfig_xcvr_address
add wave -noupdate /tb_top/DUT/u_rcfg_a10/reconfig_xcvr_read
add wave -noupdate /tb_top/DUT/u_rcfg_a10/reconfig_xcvr_write
add wave -noupdate /tb_top/DUT/u_rcfg_a10/reconfig_xcvr_writedata
add wave -noupdate /tb_top/DUT/u_rcfg_a10/reconfig_xcvr_readdata
add wave -noupdate /tb_top/DUT/u_rcfg_a10/reconfig_xcvr_waitrequest
add wave -noupdate -divider Channel-0
add wave -noupdate -divider Clock
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/csr_clk}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/mac_clk}
add wave -noupdate -divider Reset
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/reset}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/tx_digitalreset}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/rx_digitalreset}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/tx_analogreset}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/rx_analogreset}
add wave -noupdate -divider {MAC Avalon-MM CSR}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/csr_mac_address}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/csr_mac_read}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/csr_mac_write}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/csr_mac_writedata}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/csr_mac_readdata}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/csr_mac_waitrequest}
add wave -noupdate -divider {MAC Avalon-ST TX}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/avalon_st_tx_valid}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/avalon_st_tx_ready}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/avalon_st_tx_startofpacket}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/avalon_st_tx_endofpacket}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/avalon_st_tx_data}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/avalon_st_tx_empty}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/avalon_st_tx_error}
add wave -noupdate -divider {MAC Avalon-ST RX}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/avalon_st_rx_valid}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/avalon_st_rx_ready}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/avalon_st_rx_startofpacket}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/avalon_st_rx_endofpacket}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/avalon_st_rx_data}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/avalon_st_rx_empty}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/avalon_st_rx_error}
add wave -noupdate -divider {MAC TX Status}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/avalon_st_txstatus_valid}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/avalon_st_txstatus_data}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/avalon_st_txstatus_error}
add wave -noupdate -divider {MAC RX Status}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/avalon_st_rxstatus_valid}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/avalon_st_rxstatus_data}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/avalon_st_rxstatus_error}
add wave -noupdate -divider {GMII 16b TX}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/gmii16b_tx_clk}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/gmii16b_tx_en}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/gmii16b_tx_d}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/gmii16b_tx_err}
add wave -noupdate -divider {GMII 16b RX}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/gmii16b_rx_clk}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/gmii16b_rx_dv}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/gmii16b_rx_d}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/gmii16b_rx_err}
add wave -noupdate -divider {PHY Avalon-MM CSR}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/csr_phy_address}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/csr_phy_read}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/csr_phy_write}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/csr_phy_writedata}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/csr_phy_readdata}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/csr_phy_waitrequest}
add wave -noupdate -divider {PHY Speed}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/xcvr_mode}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/operating_speed}
add wave -noupdate -divider {PHY Serial Interface}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/tx_serial_clk}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/rx_cdr_refclk}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/tx_serial_data}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/rx_serial_data}
add wave -noupdate -divider {PHY Status}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/led_link}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/led_char_err}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/led_disp_err}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/rx_is_lockedtodata}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/tx_cal_busy}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/rx_cal_busy}
add wave -noupdate -divider {PHY Reconfiguration}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/reconfig_clk}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/reconfig_reset}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/reconfig_address}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/reconfig_read}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/reconfig_write}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/reconfig_writedata}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/reconfig_readdata}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[0]/u_channel/reconfig_waitrequest}
add wave -noupdate -divider Channel-1
add wave -noupdate -divider Clock
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/csr_clk}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/mac_clk}
add wave -noupdate -divider Reset
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/reset}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/tx_digitalreset}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/rx_digitalreset}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/tx_analogreset}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/rx_analogreset}
add wave -noupdate -divider {MAC Avalon-MM CSR}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/csr_mac_address}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/csr_mac_read}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/csr_mac_write}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/csr_mac_writedata}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/csr_mac_readdata}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/csr_mac_waitrequest}
add wave -noupdate -divider {MAC Avalon-ST TX}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/avalon_st_tx_valid}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/avalon_st_tx_ready}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/avalon_st_tx_startofpacket}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/avalon_st_tx_endofpacket}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/avalon_st_tx_data}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/avalon_st_tx_empty}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/avalon_st_tx_error}
add wave -noupdate -divider {MAC Avalon-ST RX}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/avalon_st_rx_valid}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/avalon_st_rx_ready}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/avalon_st_rx_startofpacket}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/avalon_st_rx_endofpacket}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/avalon_st_rx_data}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/avalon_st_rx_empty}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/avalon_st_rx_error}
add wave -noupdate -divider {MAC TX Status}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/avalon_st_txstatus_valid}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/avalon_st_txstatus_data}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/avalon_st_txstatus_error}
add wave -noupdate -divider {MAC RX Status}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/avalon_st_rxstatus_valid}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/avalon_st_rxstatus_data}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/avalon_st_rxstatus_error}
add wave -noupdate -divider {GMII 16b TX}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/gmii16b_tx_clk}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/gmii16b_tx_en}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/gmii16b_tx_d}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/gmii16b_tx_err}
add wave -noupdate -divider {GMII 16b RX}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/gmii16b_rx_clk}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/gmii16b_rx_dv}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/gmii16b_rx_d}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/gmii16b_rx_err}
add wave -noupdate -divider {PHY Avalon-MM CSR}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/csr_phy_address}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/csr_phy_read}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/csr_phy_write}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/csr_phy_writedata}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/csr_phy_readdata}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/csr_phy_waitrequest}
add wave -noupdate -divider {PHY Speed}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/xcvr_mode}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/operating_speed}
add wave -noupdate -divider {PHY Serial Interface}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/tx_serial_clk}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/rx_cdr_refclk}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/tx_serial_data}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/rx_serial_data}
add wave -noupdate -divider {PHY Status}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/led_link}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/led_char_err}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/led_disp_err}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/rx_is_lockedtodata}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/tx_cal_busy}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/rx_cal_busy}
add wave -noupdate -divider {PHY Reconfiguration}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/reconfig_clk}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/reconfig_reset}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/reconfig_address}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/reconfig_read}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/reconfig_write}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/reconfig_writedata}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/reconfig_readdata}
add wave -noupdate {/tb_top/DUT/CHANNEL_GEN[1]/u_channel/reconfig_waitrequest}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {340332878 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 187
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {351825600 ps}
