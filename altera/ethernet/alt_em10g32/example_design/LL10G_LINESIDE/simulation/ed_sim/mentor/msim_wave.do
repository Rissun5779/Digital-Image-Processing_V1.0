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
quietly virtual signal -install {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy} { /tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[70:63]} 70_63
quietly virtual signal -install {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy} { /tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[61:54]} 61_54
quietly virtual signal -install {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy} { /tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[52:45]} 52_45
quietly virtual signal -install {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy} { /tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[43:36]} 43_36
quietly virtual signal -install {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy} { /tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[35:28]} 35_28
quietly virtual signal -install {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy} { /tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[26:19]} 26_19
quietly virtual signal -install {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy} { /tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[17:9]} 17_9
quietly virtual signal -install {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy} { /tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[7:0]} 7_0
quietly virtual signal -install {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy} { /tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[34:27]} 34_27
quietly virtual signal -install {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy} { /tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[25:18]} 25_18
quietly virtual signal -install {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy} { /tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[16:9]} 16_9
quietly virtual signal -install {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy} { /tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[70:63]} 7063
quietly virtual signal -install {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy} { /tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[61:54]} 6154
quietly virtual signal -install {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy} { /tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[52:45]} 5245
quietly virtual signal -install {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy} { /tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[43:36]} 4336
quietly virtual signal -install {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy} { /tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[34:27]} 3427
quietly virtual signal -install {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy} { /tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[25:18]} 2518
quietly virtual signal -install {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy} { /tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[16:9]} 169
quietly virtual signal -install {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy} { /tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[7:0]} 70
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider DUT
add wave -noupdate -radix hexadecimal /tb_top/genblk1/dut/mm_clk
add wave -noupdate -radix hexadecimal /tb_top/genblk1/dut/xgmii_clk
add wave -noupdate -radix hexadecimal /tb_top/genblk1/dut/channel_ready
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/speed_sel}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/speed_sel}
add wave -noupdate -divider CSR
add wave -noupdate -radix hexadecimal /tb_top/genblk1/dut/write
add wave -noupdate -radix hexadecimal /tb_top/genblk1/dut/read
add wave -noupdate -radix hexadecimal /tb_top/genblk1/dut/address
add wave -noupdate -radix hexadecimal /tb_top/genblk1/dut/writedata
add wave -noupdate -radix hexadecimal /tb_top/genblk1/dut/readdata
add wave -noupdate -radix hexadecimal /tb_top/genblk1/dut/waitrequest
add wave -noupdate -divider Decoder_Multichannel
add wave -noupdate -divider {Channel 0}
add wave -noupdate -divider CSR
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/csr_address}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/csr_waitrequest}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/csr_read}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/csr_readdata}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/csr_write}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/csr_writedata}
add wave -noupdate -divider {MAC CSR}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/genblk1/mac/csr_clk}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/genblk1/mac/csr_rst_n}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/genblk1/mac/csr_address}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/genblk1/mac/csr_waitrequest}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/genblk1/mac/csr_read}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/genblk1/mac/csr_readdata}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/genblk1/mac/csr_write}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/genblk1/mac/csr_writedata}
add wave -noupdate -divider {TX ST}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_tx_data}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_tx_valid}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_tx_ready}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_tx_startofpacket}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_tx_endofpacket}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_tx_empty}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_tx_error}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_txstatus_valid}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_txstatus_data}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_txstatus_error}
add wave -noupdate -divider {ST RX}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rx_data}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rx_valid}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rx_ready}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rx_startofpacket}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rx_endofpacket}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rx_empty}
add wave -noupdate -radix hexadecimal -childformat {{{/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rx_error[5]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rx_error[4]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rx_error[3]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rx_error[2]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rx_error[1]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rx_error[0]} -radix hexadecimal}} -subitemconfig {{/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rx_error[5]} {-height 16 -radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rx_error[4]} {-height 16 -radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rx_error[3]} {-height 16 -radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rx_error[2]} {-height 16 -radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rx_error[1]} {-height 16 -radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rx_error[0]} {-height 16 -radix hexadecimal}} {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rx_error}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rxstatus_valid}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rxstatus_data}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_avalon_st_rxstatus_error}
add wave -noupdate -divider clk
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/pll_ref_clk_10g}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/pll_ref_clk_1g}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_clk}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/rx_recovered_clk}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_rx_clk}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/tx_coreclkin_1g}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/rx_coreclkin_1g}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/tx_clkout_1g}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/rx_clkout_1g}
add wave -noupdate -divider {Reset Controller}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/pll_powerdown_10g}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/pll_powerdown_1g}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/tx_analogreset}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/tx_digitalreset}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/rx_analogreset}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/rx_digitalreset}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/usr_seq_reset}
add wave -noupdate -divider {PHY CSR}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/mgmt_clk}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/mgmt_clk_reset}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/mgmt_address}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/mgmt_read}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/mgmt_readdata}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/mgmt_waitrequest}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/mgmt_write}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/mgmt_writedata}
add wave -noupdate -divider {Serial data}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/tx_serial_data}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/rx_serial_data}
add wave -noupdate -divider XGMII
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[71]}
add wave -noupdate -radix hexadecimal -childformat {{{/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/70_63[70]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/70_63[69]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/70_63[68]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/70_63[67]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/70_63[66]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/70_63[65]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/70_63[64]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/70_63[63]} -radix hexadecimal}} -subitemconfig {{/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[70]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[69]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[68]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[67]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[66]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[65]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[64]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[63]} {-radix hexadecimal}} {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/70_63}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[62]}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/61_54}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[53]}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/52_45}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[44]}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/43_36}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[35]}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/34_27}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[26]}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/25_18}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[17]}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/16_9}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_tx_dc[8]}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/7_0}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/xgmii_rx_dc}
add wave -noupdate -divider MII
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_mii_tx_en}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_mii_tx_err}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/mac_mii_tx_d}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy_mii_tx_clkena}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy_mii_tx_clkena_half_rate}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy_mii_rx_d}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy_mii_rx_err}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy_mii_rx_dv}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy_mii_rx_clkena}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy_mii_rx_clkena_half_rate}
add wave -noupdate -divider GMII
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/gmii_tx_d}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/gmii_rx_d}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/gmii_tx_en}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/gmii_tx_err}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/gmii_rx_err}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/gmii_rx_dv}
add wave -noupdate -divider {Status 1g}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/led_an}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/led_char_err}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/led_disp_err}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/led_link}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/tx_pcfifo_error_1g}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/rx_pcfifo_error_1g}
add wave -noupdate -divider {Status 10g}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/rx_rlv}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/rx_syncstatus}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/rx_clkslip}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/mode_1g_10gbar}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/pll_locked}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/rx_is_lockedtodata}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/tx_cal_busy}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/rx_cal_busy}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/rx_data_ready}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/rx_block_lock}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/rx_hi_ber}
add wave -noupdate -divider Reconfig
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/lcl_rf}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/tm_in_trigger}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/tm_out_trigger}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/rc_busy}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/lt_start_rc}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/main_rc}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/post_rc}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/pre_rc}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/tap_to_upd}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/en_lcl_rxeq}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/rxeq_done}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/seq_start_rc}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/pcs_mode_rc}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/reconfig_to_xcvr}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[0]/altera_eth_channel_inst/phy/reconfig_from_xcvr}
add wave -noupdate -divider {Channel 1}
add wave -noupdate -divider CSR
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/csr_address}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/csr_waitrequest}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/csr_read}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/csr_readdata}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/csr_write}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/csr_writedata}
add wave -noupdate -divider {ST TX}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_avalon_st_tx_data}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_avalon_st_tx_valid}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_avalon_st_tx_ready}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_avalon_st_tx_startofpacket}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_avalon_st_tx_endofpacket}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_avalon_st_tx_empty}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_avalon_st_tx_error}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_avalon_st_txstatus_valid}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_avalon_st_txstatus_data}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_avalon_st_txstatus_error}
add wave -noupdate -divider {ST RX}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_avalon_st_rx_data}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_avalon_st_rx_valid}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_avalon_st_rx_ready}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_avalon_st_rx_startofpacket}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_avalon_st_rx_endofpacket}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_avalon_st_rx_empty}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_avalon_st_rx_error}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_avalon_st_rxstatus_valid}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_avalon_st_rxstatus_data}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_avalon_st_rxstatus_error}
add wave -noupdate -divider PHY
add wave -noupdate -divider clk
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/pll_ref_clk_10g}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/pll_ref_clk_1g}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_tx_clk}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/rx_recovered_clk}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_clk}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/tx_coreclkin_1g}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/rx_coreclkin_1g}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/tx_clkout_1g}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/rx_clkout_1g}
add wave -noupdate -divider {reset controller}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/pll_powerdown_10g}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/pll_powerdown_1g}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/tx_analogreset}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/tx_digitalreset}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/rx_analogreset}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/rx_digitalreset}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/usr_seq_reset}
add wave -noupdate -divider {PHY CSR}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/mgmt_clk}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/mgmt_clk_reset}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/mgmt_address}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/mgmt_read}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/mgmt_readdata}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/mgmt_waitrequest}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/mgmt_write}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/mgmt_writedata}
add wave -noupdate -divider XGMII
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_tx_dc}
add wave -noupdate -radix hexadecimal -childformat {{{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[71]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[70]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[69]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[68]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[67]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[66]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[65]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[64]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[63]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[62]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[61]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[60]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[59]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[58]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[57]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[56]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[55]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[54]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[53]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[52]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[51]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[50]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[49]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[48]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[47]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[46]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[45]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[44]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[43]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[42]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[41]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[40]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[39]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[38]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[37]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[36]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[35]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[34]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[33]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[32]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[31]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[30]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[29]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[28]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[27]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[26]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[25]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[24]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[23]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[22]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[21]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[20]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[19]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[18]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[17]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[16]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[15]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[14]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[13]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[12]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[11]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[10]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[9]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[8]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[7]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[6]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[5]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[4]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[3]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[2]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[1]} -radix hexadecimal} {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[0]} -radix hexadecimal}} -subitemconfig {{/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[71]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[70]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[69]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[68]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[67]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[66]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[65]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[64]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[63]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[62]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[61]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[60]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[59]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[58]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[57]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[56]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[55]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[54]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[53]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[52]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[51]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[50]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[49]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[48]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[47]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[46]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[45]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[44]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[43]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[42]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[41]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[40]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[39]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[38]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[37]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[36]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[35]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[34]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[33]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[32]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[31]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[30]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[29]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[28]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[27]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[26]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[25]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[24]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[23]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[22]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[21]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[20]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[19]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[18]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[17]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[16]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[15]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[14]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[13]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[12]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[11]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[10]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[9]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[8]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[7]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[6]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[5]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[4]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[3]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[2]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[1]} {-radix hexadecimal} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[0]} {-radix hexadecimal}} {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[71]}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/7063}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[62]}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/6154}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[53]}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/5245}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[44]}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/4336}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/xgmii_rx_dc[35]}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/3427}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/2518}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/169}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/70}
add wave -noupdate -divider MII
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_mii_tx_en}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_mii_tx_err}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/mac_mii_tx_d}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy_mii_tx_clkena}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy_mii_tx_clkena_half_rate}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy_mii_rx_d}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy_mii_rx_err}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy_mii_rx_dv}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy_mii_rx_clkena}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy_mii_rx_clkena_half_rate}
add wave -noupdate -divider GMII
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/gmii_tx_d}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/gmii_rx_d}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/gmii_tx_en}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/gmii_tx_err}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/gmii_rx_err}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/gmii_rx_dv}
add wave -noupdate -divider {Status 1g}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/led_an}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/led_char_err}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/led_disp_err}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/led_link}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/tx_pcfifo_error_1g}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/rx_pcfifo_error_1g}
add wave -noupdate -divider {Status 10g}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/rx_rlv}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/rx_syncstatus}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/rx_clkslip}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/mode_1g_10gbar}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/pll_locked}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/rx_is_lockedtodata}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/tx_cal_busy}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/rx_cal_busy}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/rx_data_ready}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/rx_block_lock}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/rx_hi_ber}
add wave -noupdate -divider Reconfig
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/lcl_rf}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/tm_in_trigger}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/tm_out_trigger}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/rc_busy}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/lt_start_rc}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/main_rc}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/post_rc}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/pre_rc}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/tap_to_upd}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/en_lcl_rxeq}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/rxeq_done}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/seq_start_rc}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/pcs_mode_rc}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/reconfig_to_xcvr}
add wave -noupdate -radix hexadecimal {/tb_top/genblk1/dut/CHANNEL[1]/altera_eth_channel_inst/phy/reconfig_from_xcvr}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1948159616509 fs} 0} {{Cursor 2} {77260880000 fs} 0}
quietly wave cursor active 2
configure wave -namecolwidth 526
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits fs
update
WaveRestoreZoom {71711383530 fs} {85549571616 fs}
