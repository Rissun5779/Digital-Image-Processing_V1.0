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


# Address Offset
set PHY_USXGMII_CONTROL_REG             0x1000
set PHY_USXGMII_STATUS_REG              0x1004
set PHY_USXGMII_DEV_ABILITY_REG         0x1010
set PHY_USXGMII_PARTNER_ABILITY_REG     0x1014
set PHY_USXGMII_LINK_TIMER_REG          0x1048

set PHY_USXGMII_SERIAL_LOOPBACK_REG     0x1184

# Bit Offset
# USXGMII Control Register
set PHY_USXGMII_ENA                     0
set PHY_USXGMII_AN_ENA                  1
set PHY_USXGMII_SPEED                   2
set PHY_USXGMII_RESTART_AN              9
