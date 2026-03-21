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


#!/usr/bin/tclsh8.4
##==============================================================================
##		Marvell PHY Registers Map
##==============================================================================  
source external_phy/marvell/marvell_phy_reg_map.tcl
source basic/basic.tcl
## =======================================================================================
#             PHY CONTROL ADDRESS
## =======================================================================================


proc MARVELL_SETPHY_SPEED {value} {
	global  PHY_BASE_ADDRESS
	global PHY_CONTROL_ADDRESS
	
	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS];
	#set temp_value [expr {$quad_phy_register_value_temp & 0x8EBF}];  #clear all necessary bit
	
	switch -exact -- $value {
	10 { set temp_value [expr {$temp_value | 0x0000}];
	puts "Set PHY SPEED to 10Mbps";
	}
	100 { set temp_value [expr {$temp_value | 0x2000}]; 
	puts "Set PHY SPEED to 100Mbps";
	}
	1000 { set temp_value [expr {$temp_value| 0x0040}];
	puts "Set PHY SPEED to 1000Mbps"; 
	}
	default { 
	set temp_value [expr {$temp_value |  0x0040}];
	puts "Set PHY SPEED to default value (1000Mbps)"
	}
	}
	
	reg_write $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET
}


proc MARVELL_SETPHY_FULL_DUPLEX {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_CONTROL_ADDRESS
	
	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS];
	
	set temp_value [expr {$temp_value | (1<<8)}];
	puts "Set Enable PHY In Full Duplex Mode";
	 
   reg_write $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET
}
  

proc MARVELL_SETPHY_ENABLE_AN {}  {
	
	global  PHY_BASE_ADDRESS
	global PHY_CONTROL_ADDRESS
	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS];
	
   set temp_value [expr {$temp_value | (1<<12)}];
	puts "Set Enable PHY Auto-Negotiation";
	
   reg_write $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET
}


proc MARVELL_SETPHY_ENABLE_LOOPBACK {}  {
	
	global  PHY_BASE_ADDRESS
	global PHY_CONTROL_ADDRESS
	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS];
	
   set temp_value [expr {$temp_value | (1<<14)}];
	puts "Set Enable PHY Loopback";
	
   reg_write $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET
}

proc MARVELL_SETPHY_SW_RESET {}  {
	
	global  PHY_BASE_ADDRESS
	global PHY_CONTROL_ADDRESS
	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS];
	
   set temp_value [expr {$temp_value | (1<<15)}];
	puts "Set Software Reset";
	
   reg_write $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS $temp_value

}

proc MARVELL_SETPHY_PWR_DOWN {}  {
	
	global  PHY_BASE_ADDRESS
	global PHY_CONTROL_ADDRESS
	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS];
	
   set temp_value [expr {$temp_value | (1<<11)}];
	puts "Set PHY power down ";
	
   reg_write $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET
}



proc MARVELL_SETPHY_ISOLATE {}  {
	
	global  PHY_BASE_ADDRESS
	global PHY_CONTROL_ADDRESS
	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS];
	
   set temp_value [expr {$temp_value | (1<<10)}];
	puts "Set PHY isolate ";
	
   reg_write $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET
}



proc MARVELL_SETPHY_RESTART_AN {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_CONTROL_ADDRESS
	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS];
	
   set temp_value [expr {$temp_value | (1<<9)}];
	puts "Set PHY Resart Auto Negotiation ";
	
   reg_write $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET
}


proc MARVELL_SETPHY_EN_COLTEST {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_CONTROL_ADDRESS
	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS];
	
   set temp_value [expr {$temp_value | (1<<7)}];
	puts "Set PHY Enable Collision Test ";
	
   reg_write $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET
}


proc MARVELL_SETPHY_RESTART_AN {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_CONTROL_ADDRESS
	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS];
	
   set temp_value [expr {$temp_value | (1<<9)}];
	puts "Set PHY Resart Auto Negotiation ";
	
   reg_write $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET
}

## =======================================================================================
#             PHY STATUS ADDRESS
## =======================================================================================
proc MARVELL_CHKPHY_STAT {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_STATUS_ADDRESS
		
	puts "PHY Status Register:   [reg_read $PHY_BASE_ADDRESS $PHY_STATUS_ADDRESS]";
	MARVELL_SETPHY_SW_RESET
}

## =======================================================================================
#             PHY AUTO NEGOTIATION ADVERTISEMENT COPPER
## =======================================================================================

proc MARVELL_SETPHY_ADVERTISE_100TX_FD {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_AUTO_NEG_ADVERTISE_ADDRESS
	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS];
	
   set temp_value [expr {$temp_value | (1<<8)}];
	puts "Set Advertise PHY 100BASE-TX Full Duplex";
	
   reg_write $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET
}

proc MARVELL_SETPHY_ADVERTISE_100TX_HD {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_AUTO_NEG_ADVERTISE_ADDRESS
	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS];
	
   set temp_value [expr {$temp_value | (1<<7)}];
	puts "Set Advertise PHY 100BASE-TX Half Duplex";
	
   reg_write $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET
}

proc MARVELL_SETPHY_ADVERTISE_10TX_HD {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_AUTO_NEG_ADVERTISE_ADDRESS
	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS];
	
   set temp_value [expr {$temp_value | (1<<6)}];
	puts "Set Advertise PHY 10BASE-TX Full Duplex";
	
   reg_write $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET
}
proc MARVELL_SETPHY_ADVERTISE_10TX_FD {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_AUTO_NEG_ADVERTISE_ADDRESS
	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS];
	
   set temp_value [expr {$temp_value | (1<<5)}];
	puts "Set Advertise PHY 10BASE-TX Half Duplex";
	
   reg_write $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET
}
proc MARVELL_SETPHY_ADVERTISE_REMOTEFAULT {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_AUTO_NEG_ADVERTISE_ADDRESS
	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS];
	
   set temp_value [expr {$temp_value | (1<<5)}];
	puts "Set Enable Remote Fault";
	
   reg_write $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET
}
proc MARVELL_SETPHY_ADVERTISE_PAUSE {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_AUTO_NEG_ADVERTISE_ADDRESS
	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS];
	
   set temp_value [expr {$temp_value | (1<<11)}];
	puts " Set MAC Pause";
	
   reg_write $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET
}
proc MARVELL_SETPHY_ADVERTISE_ASYMETRIC_PAUSE {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_AUTO_NEG_ADVERTISE_ADDRESS
	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS];
	
   set temp_value [expr {$temp_value | (1<<10)}];
	puts "Set Asymmetric Pause";
	
   reg_write $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET
}
## =======================================================================================
#             PHY 1000 BASE-T CONTROL REGISTER
## =======================================================================================
#### PHY 1000BASE-T Control Register (REG 9)
proc MARVELL_SETPHY_ADVERTISE_1000TX_FD {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_1000BASE_T_CONTROL_ADDRESS
	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_1000BASE_T_CONTROL_ADDRESS];
	
   set temp_value [expr {$temp_value | (1<<9)}];
	puts "Set Advertise PHY 1000BASE-TX Full Duplex";
	
   reg_write $PHY_BASE_ADDRESS $PHY_1000BASE_T_CONTROL_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET
}


proc MARVELL_SETPHY_ADVERTISE_1000TX_HD {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_1000BASE_T_CONTROL_ADDRESS
	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_1000BASE_T_CONTROL_ADDRESS];
	   
	set temp_value [expr {$temp_value | (1<<8)}];
	puts "Set Advertise PHY 1000BASE-TX Half Duplex";
	
   reg_write $PHY_BASE_ADDRESS $PHY_1000BASE_T_CONTROL_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET
}
## =======================================================================================
#             PHY 1000 BASE-T STATUS REGISTER
## =======================================================================================
#### PHY 1000BASE-T Control Register (REG 9)
proc MARVELL_CHKPHY_1000BASE_T_STAT {} {

	global PHY_BASE_ADDRESS
	global PHY_1000BASE_T_STATUS_ADDRESS
	
	puts "PHY read 1000BASE-T Status Register		= [reg_read $PHY_BASE_ADDRESS $PHY_1000BASE_T_STATUS_ADDRESS]";

}
## =======================================================================================
#             PHY SPECIFIC CONTROL REGISTER REG 16
## =======================================================================================

proc  MARVELL_SETPHY_FIFO_MAX {} {
	global  PHY_BASE_ADDRESS
	global PHY_SPECIFIC_CONTROL_ADDRESS

	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_SPECIFIC_CONTROL_ADDRESS];
	   
	set temp_value [expr {$temp_value | 0xC000}];
	puts "Set PHY Synchronizing FIFO to maximum";
	
   reg_write $PHY_BASE_ADDRESS $PHY_SPECIFIC_CONTROL_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET
}

## =======================================================================================
#             PHY SPECIFIC STATUS REGISTER REG 17
## =======================================================================================

proc MARVELL_CHKPHY_DUPLEX {} {

	global  PHY_BASE_ADDRESS
	global PHY_SPECIFIC_STATUS_ADDRESS
	
	set temp_value [reg_read  $PHY_BASE_ADDRESS $PHY_SPECIFIC_STATUS_ADDRESS];
	set temp_value [expr {$temp_value & 0x2000}];

	if { $temp_value == 0x00002000} {
		puts "PHY operating in Full Duplex mode.";
	} else {
		puts "PHY operating in Half Duplex mode.";
	}

}
proc MARVELL_CHKPHY_SPEED {} {

	global  PHY_BASE_ADDRESS
	global PHY_SPECIFIC_STATUS_ADDRESS
	
	set temp_value [reg_read  $PHY_BASE_ADDRESS $PHY_SPECIFIC_STATUS_ADDRESS];
	set temp_value [expr {$temp_value & 0xC000}];

	if { $temp_value == 0x00000000 } {
		puts "PHY operating Speed 10Mbps";
	} elseif { $temp_value == 0x00004000 } {
		puts "PHY operating Speed 100Mbps";
	} elseif { $temp_value == 0x00008000 } {
		puts "PHY operating Speed 1000Mbps";
	} else {
		puts "PHY operating Speed Error!";
	}

}

proc MARVELL_CHKPHY_LINK_STAT {} {

	set PHY_TIMEOUT 1000;
	set PHY_COUNT_TEMP 0;
	set temp_value 0;
	while { (temp_value == 0x00000000) && ($PHY_COUNT_TEMP < $PHY_TIMEOUT) } {
		set temp_value [reg_read  $PHY_BASE_ADDRESS $PHY_SPECIFIC_STATUS_ADDRESS];
		set temp_value [expr {$temp_value & 0x0400}];
		
		if {($temp_value == 0x00000400) && ($PHY_COUNT_TEMP < $PHY_TIMEOUT)} {
			puts "PHY Link Up.";
		}
		
		set PHY_COUNT_TEMP [expr {$PHY_COUNT_TEMP + 1}];
		
		if {$PHY_COUNT_TEMP == $PHY_TIMEOUT} {
			puts "PHY Link Down!";
		}
	}
}

proc MARVELL_CHKPHY_SPEED_DUPLEX_RESOVED {} {

	sset PHY_COUNT_TEMP 0;
	set temp_value 0;
	while { ($temp_value == 0x00000000) && ($PHY_COUNT_TEMP < $PHY_TIMEOUT) } {
		set temp_value [reg_read  $PHY_BASE_ADDRESS $PHY_SPECIFIC_STATUS_ADDRESS];
		set temp_value [expr {$temp_value & 0x0800}];
		
		if {($temp_value == 0x00000800) && ($PHY_COUNT_TEMP < $PHY_TIMEOUT)} {
			puts "PHY Speed and Duplex Resolved.";
		}
		
		set PHY_COUNT_TEMP [expr {$PHY_COUNT_TEMP + 1}];
		
		if {$PHY_COUNT_TEMP == $PHY_TIMEOUT} {
			puts "PHY Speed and Duplex Resolve Failed!";
		}
	}
}

	


## =======================================================================================
#             PHY EXTENTED SPECIFIC  CONTROL REGISTER REG 20
## =======================================================================================
proc  MARVELL_SETPHY_TX_TIMING_CTRL {} {

	global  PHY_BASE_ADDRESS
	global PHY_EXT_SPECIFIC_CONTROL_ADDRESS

	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_EXT_SPECIFIC_CONTROL_ADDRESS];
	set temp_value [expr {$temp_value & 0xFF7D}];   
	
	set temp_value [expr {$temp_value | 0x0080}];
	puts "Set RGMII TX Timing Control";
	
   reg_write $PHY_BASE_ADDRESS $PHY_EXT_SPECIFIC_CONTROL_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET

}

proc  MARVELL_SETPHY_RX_TIMING_CTRL {} {

	global  PHY_BASE_ADDRESS
	global PHY_EXT_SPECIFIC_CONTROL_ADDRESS

	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_EXT_SPECIFIC_CONTROL_ADDRESS];
	set temp_value [expr {$temp_value & 0xFF7D}];   
	
	set temp_value [expr {$temp_value | 0x0002}];
	puts "Set RGMII TX Timing Control";
	
   reg_write $PHY_BASE_ADDRESS $PHY_EXT_SPECIFIC_CONTROL_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET

}
proc  MARVELL_SETPHY_TXRX_TIMING_CTRL {} {

	global  PHY_BASE_ADDRESS
	global PHY_EXT_SPECIFIC_CONTROL_ADDRESS

	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_EXT_SPECIFIC_CONTROL_ADDRESS];
	set temp_value [expr {$temp_value & 0xFF7D}];   
	
	set temp_value [expr {$temp_value | 0x0082}];
	puts "Set RGMII TX and RX Timing Control";
	
   reg_write $PHY_BASE_ADDRESS $PHY_EXT_SPECIFIC_CONTROL_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET

}



## =======================================================================================
#             PHY EXTENTED SPECIFIC  STATUS REGISTER REG 27
## =======================================================================================

proc  MARVELL_SETPHY_HWCFG_MODE {value} {
	global  PHY_BASE_ADDRESS
	global PHY_EXT_SPECIFIC_STATUS_ADDRESS

	set temp_value [reg_read $PHY_BASE_ADDRESS $PHY_EXT_SPECIFIC_STATUS_ADDRESS];
	   
	switch -exact -- $value {
	1 { set  temp_value [expr {$temp_value | 0x0004}];
	puts "Set PHY HWCFG_MODE for SGMII to Copper Without Clock";
	}
	2 { set  temp_value [expr {$temp_value | 0x000D}]; 
	puts "Set PHY HWCFG_MODE for TBI to Copper";
	}
	3 { set  temp_value [expr {$temp_value | 0x000B}];
	puts "Set PHY HWCFG_MODE for RGMII to Copper"; 
	}
	4 { set  temp_value [expr {$temp_value | 0x000F}];
	puts "Set PHY HWCFG_MODE for GMII/MII to Copper"; 
	}
	default { 
	set  temp_value [expr {$temp_value | 0x0004}];
	puts "Set PHY HWCFG_MODE to default mode (SGMII to Copper Without Clock)"
	}
	};
	
   reg_write $PHY_BASE_ADDRESS $PHY_EXT_SPECIFIC_STATUS_ADDRESS $temp_value
	MARVELL_SETPHY_SW_RESET
}

proc MARVELL_CHKPHY_EXT_SPECIFIC_STAT {} {

	global  PHY_BASE_ADDRESS
	global PHY_EXT_SPECIFIC_STATUS_ADDRESS
	puts "PHY read Extended PHY Specific Status Register	= [reg_read $PHY_BASE_ADDRESS $PHY_EXT_SPECIFIC_STATUS_ADDRESS]";
}

	














