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


#==============================================================================
#                    High Level System Base Addresses
#==============================================================================
# this is MDIO address
set PHY_BASE_ADDRESS				0x200000

set BASE_ADDR_CHANNEL_0		0x20000 
set BASE_ADDR_CHANNEL_1		0x30000
set BASE_ADDR_CHANNEL_2		0x40000
set BASE_ADDR_CHANNEL_3		0x50000
set BASE_ADDR_CHANNEL_4		0x60000 
set BASE_ADDR_CHANNEL_5		0x70000
set BASE_ADDR_CHANNEL_6		0x80000
set BASE_ADDR_CHANNEL_7		0x90000
set BASE_ADDR_CHANNEL_8		0xa0000 
set BASE_ADDR_CHANNEL_9		0xb0000
set BASE_ADDR_CHANNEL_10	0xc0000
set BASE_ADDR_CHANNEL_11	0xd0000

#--1588 TOD
#all channels share 1 tod master
set TOD_MASTER_ADDR	    0x10000



# -- System Controller Base Address
set TRAFFIC_CONTROLLER_SELECTOR_0	0x101000
set TRAFFIC_CONTROLLER_SELECTOR_1	0x105000
set TRAFFIC_CONTROLLER_SELECTOR_2	0x109000
set TRAFFIC_CONTROLLER_SELECTOR_3	0x10d000
set TRAFFIC_CONTROLLER_SELECTOR_4	0x111000
set TRAFFIC_CONTROLLER_SELECTOR_5	0x115000
#-without 1588

set TRAFFIC_CONTROLLER_BASE_ADDR_CHANNEL_0		0x102000
set TRAFFIC_CONTROLLER_BASE_ADDR_CHANNEL_1		0x103000
set TRAFFIC_CONTROLLER_BASE_ADDR_CHANNEL_2		0x106000
set TRAFFIC_CONTROLLER_BASE_ADDR_CHANNEL_3		0x107000
set TRAFFIC_CONTROLLER_BASE_ADDR_CHANNEL_4		0x10a000
set TRAFFIC_CONTROLLER_BASE_ADDR_CHANNEL_5		0x10b000
set TRAFFIC_CONTROLLER_BASE_ADDR_CHANNEL_6		0x10e000
set TRAFFIC_CONTROLLER_BASE_ADDR_CHANNEL_7		0x10f000
set TRAFFIC_CONTROLLER_BASE_ADDR_CHANNEL_8		0x112000
set TRAFFIC_CONTROLLER_BASE_ADDR_CHANNEL_9		0x113000
set TRAFFIC_CONTROLLER_BASE_ADDR_CHANNEL_10		0x116000
set TRAFFIC_CONTROLLER_BASE_ADDR_CHANNEL_11		0x117000

#-with 1588
set TRAFFIC_CONTROLLER_1588_BASE_ADDR_0	0x100000
set TRAFFIC_CONTROLLER_1588_BASE_ADDR_1	0x104000
set TRAFFIC_CONTROLLER_1588_BASE_ADDR_2	0x108000
set TRAFFIC_CONTROLLER_1588_BASE_ADDR_3	0x10c000
set TRAFFIC_CONTROLLER_1588_BASE_ADDR_4	0x110000
set TRAFFIC_CONTROLLER_1588_BASE_ADDR_5	0x114000


