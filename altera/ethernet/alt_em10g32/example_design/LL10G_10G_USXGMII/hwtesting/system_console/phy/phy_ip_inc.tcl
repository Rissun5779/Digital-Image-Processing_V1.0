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


source basic/basic.tcl
source system_base_addr_map.tcl
source phy/phy_ip_reg_map.tcl

# Serial loopback mode is used for internal testing only
proc SETPHY_SERIAL_LLPBK {} {
    global PHY_IP_BASE_ADDR
    global PHY_USXGMII_SERIAL_LOOPBACK_REG
    puts "\t Enabling serial PMA Loopback (local)"
    reg_write $PHY_IP_BASE_ADDR $PHY_USXGMII_SERIAL_LOOPBACK_REG [expr (1 << 0)]
}

proc RESETPHY_SERIAL_LLPBK {} {
    global PHY_IP_BASE_ADDR
    global PHY_USXGMII_SERIAL_LOOPBACK_REG
    puts "\t Disabling serial PMA Loopback (local)"
    reg_write $PHY_IP_BASE_ADDR $PHY_USXGMII_SERIAL_LOOPBACK_REG [expr (0 << 0)]
}

# Set operating speeds
proc SETPHY_SPEED {speed} {
    global PHY_IP_BASE_ADDR
    global PHY_USXGMII_CONTROL_REG
    global PHY_USXGMII_ENA
    global PHY_USXGMII_AN_ENA
    global PHY_USXGMII_SPEED
    global PHY_USXGMII_RESTART_AN
    
    puts "\t Configure to $speed"
    
    set usxgmii_ena_value 1
    set usxgmii_an_ena_value 0
    set speed_value 0
    set restart_an_value 0
    
    if {$speed == "10G"} {
        set speed_value 3
    } elseif {$speed == "5G"} {
        set speed_value 5
    } elseif {$speed == "2P5G"} {
        set speed_value 4
    } elseif {$speed == "1G"} {
        set speed_value 2
    } elseif {$speed == "100M"} {
        set speed_value 1
    } elseif {$speed == "10M"} {
        set speed_value 0
    } else {
        set speed_value 0
        puts "\t Error: Invalid operating speed specified : $speed"
    }
    
    reg_write $PHY_IP_BASE_ADDR $PHY_USXGMII_CONTROL_REG [expr (($restart_an_value << $PHY_USXGMII_RESTART_AN) | ($speed_value << $PHY_USXGMII_SPEED) | ($usxgmii_an_ena_value << $PHY_USXGMII_AN_ENA) | ($usxgmii_ena_value << $PHY_USXGMII_ENA))]
}

# USXGMII Auto-Negotiation
proc SETPHY_USXGMII_AN {} {
    global PHY_IP_BASE_ADDR
    global PHY_USXGMII_CONTROL_REG
    global PHY_USXGMII_ENA
    global PHY_USXGMII_AN_ENA
    global PHY_USXGMII_SPEED
    global PHY_USXGMII_RESTART_AN
    
    puts "\t Enabling USXGMII Auto-Negotiation"
    
    set usxgmii_ena_value 1
    set usxgmii_an_ena_value 1
    set speed_value 0
    set restart_an_value 0
    
    reg_write $PHY_IP_BASE_ADDR $PHY_USXGMII_CONTROL_REG [expr (($restart_an_value << $PHY_USXGMII_RESTART_AN) | ($speed_value << $PHY_USXGMII_SPEED) | ($usxgmii_an_ena_value << $PHY_USXGMII_AN_ENA) | ($usxgmii_ena_value << $PHY_USXGMII_ENA))]
}

proc SETPHY_USXGMII_AN_RESTART {} {
    global PHY_IP_BASE_ADDR
    global PHY_USXGMII_CONTROL_REG
    global PHY_USXGMII_ENA
    global PHY_USXGMII_AN_ENA
    global PHY_USXGMII_SPEED
    global PHY_USXGMII_RESTART_AN
    
    puts "\t Enabling Clause 37 Auto-Negotiation Restart"
    
    set usxgmii_ena_value 1
    set usxgmii_an_ena_value 1
    set speed_value 0
    set restart_an_value 1
    
    reg_write $PHY_IP_BASE_ADDR $PHY_USXGMII_CONTROL_REG [expr (($restart_an_value << $PHY_USXGMII_RESTART_AN) | ($speed_value << $PHY_USXGMII_SPEED) | ($usxgmii_an_ena_value << $PHY_USXGMII_AN_ENA) | ($usxgmii_ena_value << $PHY_USXGMII_ENA))]
}

proc SETPHY_USXGMII_AN_DEV_ABILITY {value} {
    global PHY_IP_BASE_ADDR
    global PHY_USXGMII_DEV_ABILITY_REG
    
    puts "\t Setting $value into USXGMII dev_ability"
    
    reg_write $PHY_IP_BASE_ADDR $PHY_USXGMII_DEV_ABILITY_REG $value
}

# PHY Status
proc CHKPHY_STATUS {} {
    global PHY_IP_BASE_ADDR
    global PHY_USXGMII_CONTROL_REG
    global PHY_USXGMII_STATUS_REG
    global PHY_USXGMII_DEV_ABILITY_REG
    global PHY_USXGMII_PARTNER_ABILITY_REG
    global PHY_USXGMII_LINK_TIMER_REG
    
    puts "\t USXGMII Control         = 0x[format %X [reg_read $PHY_IP_BASE_ADDR $PHY_USXGMII_CONTROL_REG]]"
    puts "\t USXGMII Status          = 0x[format %X [reg_read $PHY_IP_BASE_ADDR $PHY_USXGMII_STATUS_REG]]"
    puts "\t USXGMII Device Ability  = 0x[format %X [reg_read $PHY_IP_BASE_ADDR $PHY_USXGMII_DEV_ABILITY_REG]]"
    puts "\t USXGMII Partner Ability = 0x[format %X [reg_read $PHY_IP_BASE_ADDR $PHY_USXGMII_PARTNER_ABILITY_REG]]"
    puts "\t USXGMII Link Timer      = 0x[format %X [reg_read $PHY_IP_BASE_ADDR $PHY_USXGMII_LINK_TIMER_REG]]"
}
