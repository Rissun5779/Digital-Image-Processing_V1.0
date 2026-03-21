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


# System
set NUM_CHANNELS                2

set 1588_MODE                   1

# MAC
set MAC_SRC_ADDRESS             F0F1F2F3F4F5
set MAC_DST_ADDRESS             C5C4C3C2C1C0 

set MAX_FRAME_LENGTH            1518

# Traffic Controller
set PACKET_TYPE                 RANDOM
set PACKET_SIZE                 1518
set BURST_TYPE                  RANDOM
set BURST_ITERATION             1

# 1588 setting
# TOD nano second
#set MASTER_TOD                 0x3B9A8A46
#set 1G_TOD                     0x3B9A8A46

set MASTER_TOD                  0x000FFFFF
set 1G_TOD                      0x000FFFFF
set 2p5G_TOD                    0x00066666


# Adjustment latency

#PMA delay =  digital delay + analog delay
#1G TX:
#43 * 0.8 + (-1.11) = 33.29 ns = 21, 4A3D

#1G RX:
#24.5 * 0.8 + 1.75 = 21.35 ns = 15, 599A

#2.5G TX:
#43 * 0.32 + (-1.11) = 12.65 ns = C, A666

#2.5G RX:
#24.5 * 0.32 + 1.75 = 9.59 ns = 9, 970A

set TX_ADJUST_10G_NSECOND       0x00
set TX_ADJUST_10G_FNSECOND      0x0000
set TX_ADJUST_1G_NSECOND        0x21
set TX_ADJUST_1G_FNSECOND       0x4A3D
set TX_ADJUST_2P5G_NSECOND      0xC
set TX_ADJUST_2P5G_FNSECOND     0xA666

set RX_ADJUST_10G_NSECOND       0x00
set RX_ADJUST_10G_FNSECOND      0x0000
set RX_ADJUST_1G_NSECOND        0x15
set RX_ADJUST_1G_FNSECOND       0x599A
set RX_ADJUST_2P5G_NSECOND      0x9
set RX_ADJUST_2P5G_FNSECOND     0x970A