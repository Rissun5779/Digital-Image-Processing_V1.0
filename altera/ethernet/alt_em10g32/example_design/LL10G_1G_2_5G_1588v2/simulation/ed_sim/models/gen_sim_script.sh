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


# (C) 2001-2015 Altera Corporation. All rights reserved.
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

sim-script-gen --use-relative-paths \
--spd=../acds_ip/alt_mge_mac/alt_mge_mac.spd \
--spd=../acds_ip/alt_mge_1g_2p5g_phy/alt_mge_1g_2p5g_phy.spd \
--spd=../acds_ip/alt_mge_1588_sampling_pll/alt_mge_1588_sampling_pll.spd \
--spd=../acds_ip/alt_mge_1588_tod_1g/alt_mge_1588_tod_1g.spd \
--spd=../acds_ip/alt_mge_1588_tod_2p5g/alt_mge_1588_tod_2p5g.spd \
--spd=../acds_ip/alt_mge_1588_tod_master/alt_mge_1588_tod_master.spd \
--spd=../acds_ip/alt_mge_1588_tod_sync_64b_1g/alt_mge_1588_tod_sync_64b_1g.spd \
--spd=../acds_ip/alt_mge_1588_tod_sync_64b_2p5g/alt_mge_1588_tod_sync_64b_2p5g.spd \
--spd=../acds_ip/alt_mge_1588_tod_sync_96b_1g/alt_mge_1588_tod_sync_96b_1g.spd \
--spd=../acds_ip/alt_mge_1588_tod_sync_96b_2p5g/alt_mge_1588_tod_sync_96b_2p5g.spd \
--spd=../acds_ip/alt_mge_core_pll/alt_mge_core_pll.spd \
--spd=../acds_ip/alt_mge_packet_classifier/alt_mge_packet_classifier.spd \
--spd=../acds_ip/alt_mge_xcvr_fpll_1g/alt_mge_xcvr_fpll_1g.spd \
--spd=../acds_ip/alt_mge_xcvr_atx_pll_2p5g/alt_mge_xcvr_atx_pll_2p5g.spd \
--spd=../acds_ip/alt_mge_xcvr_reset_ctrl_txpll/alt_mge_xcvr_reset_ctrl_txpll.spd \
--spd=../acds_ip/alt_mge_xcvr_reset_ctrl_channel/alt_mge_xcvr_reset_ctrl_channel.spd \
--spd=../addr_decoder/alt_mge_rd_addrdec_mch/alt_mge_rd_addrdec_mch.spd \
--spd=../addr_decoder/alt_mge_rd_avmm_mux_xcvr_rcfg/alt_mge_rd_avmm_mux_xcvr_rcfg.spd
