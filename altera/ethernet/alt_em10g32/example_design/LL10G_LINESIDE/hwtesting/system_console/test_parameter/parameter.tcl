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


set NUM_CHANNELS				2
set 10G_ETH_MODE			  "1G10G"
set 1588_MODE					0
set SGMII_MODE					1

set MAC_SRC_ADDRESS			F0F1F2F3F4F5
set MAC_DST_ADDRESS			C5C4C3C2C1C0 

# traffic controller setting
set PACKET_TYPE				RANDOM
set PACKET_SIZE				1518
set BURST_TYPE					RANDOM
set BURST_SIZE					1000
set BURST_ITERATION			1

#1588 setting
# TOD nano second
set MASTER_TOD					0x3B9A8A46
set 1G_TOD					 	0x3B9A8A46
set 10G_TOD					 	0x3B9A8A46

# Adjustment latency

#PMA delay =  digital delay + analog delay
#1g TX = 42.4 + (-1.11) = 41.29ns
#1g RX = 20.8 +1.75 = 22.55ns
#10g TX = 11.93 + (-1.11) = 10.82ns
#10g RX = 8.44 + 1.75 = 10.19ns

set TX_ADJUST_10G_NSECOND    	 0x0A
set TX_ADJUST_10G_FNSECOND     0xD1EB
set TX_ADJUST_1G_NSECOND     	 0x29
set TX_ADJUST_1G_FNSECOND   	 0x4A3D

set RX_ADJUST_10G_NSECOND    	 0x0A
set RX_ADJUST_10G_FNSECOND     0x30A3
set RX_ADJUST_1G_NSECOND     	 0x16
set RX_ADJUST_1G_FNSECOND   	 0x8CCC
