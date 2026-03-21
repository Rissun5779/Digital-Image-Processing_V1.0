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

proc i2c_reg_write {base_addr offset data} {
 set sfp_addr [expr ($offset & 0xFF)+ 0xAC00]
  reg_write $base_addr 0x48 $sfp_addr
  after 50
  reg_write $base_addr 0x40 $data
  after 50
  reg_write $base_addr 0x4C 0x02
  after 50
}

proc i2c_reg_read {base_addr offset} {
 set test_temp 0x40000000
 set sfp_addr [expr ($offset & 0xFF)+ 0xAC00]
  reg_write $base_addr 0x48 $sfp_addr
  after 50
 reg_write $base_addr 0x4C 0x01
 after 50

 #jier the while loop check condition should check the ack error, change later 
 while {$test_temp == 0x40000000} {				
 	set rdata [reg_read $base_addr 0x44]
 	#puts "rdata = $rdata"
 	set test_temp [expr {$rdata & 0x40000000}]
 	#puts "test_temp = $test_temp"
 	after 50
 }
 
 return $rdata
}
## =======================================================================================

proc SFPP_SETPHY_SW_RESET {}  {
	
	global  PHY_BASE_ADDRESS
	global PHY_CONTROL_ADDRESS
	set reg0_msb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS]
	set reg0_lsb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS]
	puts "reg0_msb : $reg0_msb"
	puts "reg0_lsb : $reg0_lsb"
	
   set reg0_msb [expr {$reg0_msb | (1<<7)}]
	puts "Set Software Reset : $reg0_msb"
	
   i2c_reg_write $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS $reg0_msb
   i2c_reg_write $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS $reg0_lsb
   
   set sw_rst_complete 0x80
   puts "Wait Software Reset to Complete"
   while {$sw_rst_complete == 0x80} {
   		set reg0_msb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS]
		set reg0_lsb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS]
		
   		set sw_rst_complete [expr {$reg0_msb & 0x00000080}]
   }

}
## =======================================================================================
#             SGMII HWCFG_MODE
## =======================================================================================

proc SPFF_SETPHY_HWCFG_MODE {} {
	global  PHY_BASE_ADDRESS
	global PHY_EXT_SPECIFIC_STATUS_ADDRESS
	puts "Set PHY HWCFG_MODE for SGMII to Copper Without Clock";
	
	set reg27_msb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_EXT_SPECIFIC_STATUS_ADDRESS];
	set reg27_lsb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_EXT_SPECIFIC_STATUS_ADDRESS];
	puts "reg27_msb : $reg27_msb"
	puts "reg27_lsb : $reg27_lsb"

	set  reg27_lsb [expr {($reg27_lsb & 0xF0) | 0x0004}];
	puts "reg27_lsb : $reg27_lsb"
	
	i2c_reg_write $PHY_BASE_ADDRESS $PHY_EXT_SPECIFIC_STATUS_ADDRESS $reg27_msb
	i2c_reg_write $PHY_BASE_ADDRESS $PHY_EXT_SPECIFIC_STATUS_ADDRESS $reg27_lsb
   
	SFPP_SETPHY_SW_RESET
	puts "check PHY_EXT_SPECIFIC_STATUS_ADDRESS = [i2c_reg_read $PHY_BASE_ADDRESS $PHY_EXT_SPECIFIC_STATUS_ADDRESS]"
	puts "check PHY_EXT_SPECIFIC_STATUS_ADDRESS = [i2c_reg_read $PHY_BASE_ADDRESS $PHY_EXT_SPECIFIC_STATUS_ADDRESS]"
	
	}
## =======================================================================================

proc SPFF_AN_ENA {} { 
 global  PHY_BASE_ADDRESS
 global PHY_CONTROL_ADDRESS	 
	
#Enable Auto Negotiation in Control Register
 set reg0_msb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS];
 set reg0_lsb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_CONTROL_ADDRESS];
 puts "Default Reg 0 = $reg0_msb $reg0_lsb";
 set reg0_msb [expr {$reg0_msb & 0x7D}];
 set reg0_msb [expr {$reg0_msb |(1<<4)}];
 puts "Enable Copper Auto Negotiation";
 i2c_reg_write $PHY_BASE_ADDRESS  $PHY_CONTROL_ADDRESS $reg0_msb
 i2c_reg_write $PHY_BASE_ADDRESS  $PHY_CONTROL_ADDRESS $reg0_lsb
 
 SFPP_SETPHY_SW_RESET

 
} 



### =======================================================================================
##             PHY AUTO NEGOTIATION ADVERTISEMENT COPPER
### =======================================================================================
#

proc SFPP_SETPHY_ADVERTISE_1000TX_FD {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_1000BASE_T_CONTROL_ADDRESS
 
 set reg9_msb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_1000BASE_T_CONTROL_ADDRESS];
 set reg9_lsb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_1000BASE_T_CONTROL_ADDRESS];
 
 set reg9_msb [expr {$reg9_msb & 0xE5}];
 set reg9_lsb [expr {$reg9_lsb & 0xFF}];
 
 set reg9_msb [expr {$reg9_msb |(1<<1)}];
 puts "Set Advertise PHY 1000BASE-T Full Duplex";


 i2c_reg_write $PHY_BASE_ADDRESS  $PHY_1000BASE_T_CONTROL_ADDRESS $reg9_msb
 i2c_reg_write $PHY_BASE_ADDRESS  $PHY_1000BASE_T_CONTROL_ADDRESS $reg9_lsb

  SFPP_SETPHY_SW_RESET
  
}

## =======================================================================================

proc SFPP_SETPHY_ADVERTISE_1000TX_HD {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_1000BASE_T_CONTROL_ADDRESS

 set reg9_msb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_1000BASE_T_CONTROL_ADDRESS];
 set reg9_lsb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_1000BASE_T_CONTROL_ADDRESS];
 
 set reg9_msb [expr {$reg9_msb & 0xE6}];
 set reg9_lsb [expr {$reg9_lsb & 0xFF}];
 

 set reg9_msb [expr {$reg9_msb | (1<<0)}];
 puts "Set Advertise PHY 1000BASE-T Half Duplex";
 

 i2c_reg_write $PHY_BASE_ADDRESS  $PHY_1000BASE_T_CONTROL_ADDRESS $reg9_msb
 i2c_reg_write $PHY_BASE_ADDRESS  $PHY_1000BASE_T_CONTROL_ADDRESS $reg9_lsb

 
 SFPP_SETPHY_SW_RESET
 
 
}
## =======================================================================================

proc SFPP_SETPHY_ADVERTISE_100TX_FD {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_AUTO_NEG_ADVERTISE_ADDRESS
 set reg4_msb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS];
 set reg4_lsb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS];
 
 set reg4_msb [expr {$reg4_msb & 0xFE}];
 set reg4_lsb [expr {$reg4_lsb & 0xFF}];

 set reg4_msb [expr {$reg4_msb |(1<<0)}];
 puts "Set Advertise PHY 100BASE-TX Full Duplex";

 
 i2c_reg_write $PHY_BASE_ADDRESS  $PHY_AUTO_NEG_ADVERTISE_ADDRESS $reg4_msb
 i2c_reg_write $PHY_BASE_ADDRESS  $PHY_AUTO_NEG_ADVERTISE_ADDRESS $reg4_lsb
 
 SFPP_SETPHY_SW_RESET

 
 
}
## =======================================================================================

proc SFPP_SETPHY_ADVERTISE_100TX_HD {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_AUTO_NEG_ADVERTISE_ADDRESS
 
 set reg4_msb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS];
 set reg4_lsb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS];
 
 set reg4_msb [expr {$reg4_msb & 0xFF}];
 set reg4_lsb [expr {$reg4_lsb & 0x7F}];

 set reg4_lsb [expr {$reg4_lsb | (1<<7)}];
 puts "Set Advertise PHY 100BASE-TX Half Duplex";
 
 i2c_reg_write $PHY_BASE_ADDRESS  $PHY_AUTO_NEG_ADVERTISE_ADDRESS $reg4_msb
 i2c_reg_write $PHY_BASE_ADDRESS  $PHY_AUTO_NEG_ADVERTISE_ADDRESS $reg4_lsb
 
 
 SFPP_SETPHY_SW_RESET
}
## =======================================================================================

proc SFPP_SETPHY_ADVERTISE_10TX_FD {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_AUTO_NEG_ADVERTISE_ADDRESS

 set reg4_msb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS];
 set reg4_lsb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS];
 
 set reg4_msb [expr {$reg4_msb & 0xFF}];
 set reg4_lsb [expr {$reg4_lsb & 0xBF}];
 set reg4_lsb [expr {$reg4_lsb |(1<<6)}];
 puts "Set Advertise PHY 10BASE-T Full Duplex";
 
 i2c_reg_write $PHY_BASE_ADDRESS  $PHY_AUTO_NEG_ADVERTISE_ADDRESS $reg4_msb
 i2c_reg_write $PHY_BASE_ADDRESS  $PHY_AUTO_NEG_ADVERTISE_ADDRESS $reg4_lsb
 
 SFPP_SETPHY_SW_RESET
 
}
## =======================================================================================

proc SFPP_SETPHY_ADVERTISE_10TX_HD {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_AUTO_NEG_ADVERTISE_ADDRESS

 set reg4_msb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS];
 set reg4_lsb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_AUTO_NEG_ADVERTISE_ADDRESS];
 
 set reg4_msb [expr {$reg4_msb & 0xFF}];
 set reg4_lsb [expr {$reg4_lsb & 0xDF}];

 set reg4_lsb [expr {$reg4_lsb | (1<<5)}];
 puts "Set Advertise PHY 10BASE-T Half Duplex";
 
 
 
 i2c_reg_write $PHY_BASE_ADDRESS  $PHY_AUTO_NEG_ADVERTISE_ADDRESS $reg4_msb
 i2c_reg_write $PHY_BASE_ADDRESS  $PHY_AUTO_NEG_ADVERTISE_ADDRESS $reg4_lsb
 
 
 SFPP_SETPHY_SW_RESET
}

# to enable SFPP tx and rx packet more than 1518 bytes
proc SFPP_SETPHY_FIFODEPTH {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_SPECIFIC_CONTROL_ADDRESS

 set reg16_msb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_SPECIFIC_CONTROL_ADDRESS];
 set reg16_lsb [i2c_reg_read $PHY_BASE_ADDRESS $PHY_SPECIFIC_CONTROL_ADDRESS];
 
 set reg16_msb [expr {$reg16_msb & 0x0F}];
 set reg16_lsb [expr {$reg16_lsb & 0xFF}];

 set reg16_msb [expr {$reg16_msb | 0xF0}];
 puts "Set TX and RX FIFO Depth to 40 bits";
 
 
 
 i2c_reg_write $PHY_BASE_ADDRESS  $PHY_SPECIFIC_CONTROL_ADDRESS $reg16_msb
 i2c_reg_write $PHY_BASE_ADDRESS  $PHY_SPECIFIC_CONTROL_ADDRESS $reg16_lsb
 
 
 SFPP_SETPHY_SW_RESET
}

## =======================================================================================
#             PHY CHECK STATUS
## =======================================================================================

proc SFPP_CHKPHY_LINK_STAT {} {
	
	global  PHY_BASE_ADDRESS
	global PHY_SPECIFIC_STATUS_ADDRESS
	
	
	set PHY_TIMEOUT 1000;
	set PHY_COUNT_TEMP 0;
	
	set reg17_msb 0;
	while { (reg17_msb == 0x00000000) && ($PHY_COUNT_TEMP < $PHY_TIMEOUT) } {
		set reg17_msb [i2c_reg_read  $PHY_BASE_ADDRESS $PHY_SPECIFIC_STATUS_ADDRESS];
		set reg17_lsb [i2c_reg_read  $PHY_BASE_ADDRESS $PHY_SPECIFIC_STATUS_ADDRESS];
		set reg17_msb [expr {$reg17_msb & 0x04}];
		set reg17_lsb [expr {$reg17_lsb & 0x00}];
		
		if {($reg17_msb == 0x04) && ($reg17_lsb == 0x00) && ($PHY_COUNT_TEMP < $PHY_TIMEOUT)} {
			puts "PHY Link Up.";
		}
		
		set PHY_COUNT_TEMP [expr {$PHY_COUNT_TEMP + 1}];
		
		if {$PHY_COUNT_TEMP == $PHY_TIMEOUT} {
			puts "PHY Link Down!";
		}
	}
}
## =======================================================================================

proc SFPP_CHKPHY_DUPLEX {} {

	global  PHY_BASE_ADDRESS
	global PHY_SPECIFIC_STATUS_ADDRESS
	
	set reg17_msb [i2c_reg_read  $PHY_BASE_ADDRESS $PHY_SPECIFIC_STATUS_ADDRESS];
	set reg17_lsb [i2c_reg_read  $PHY_BASE_ADDRESS $PHY_SPECIFIC_STATUS_ADDRESS];
	set reg17_msb [expr {$reg17_msb & 0x02}];
	set reg17_lsb [expr {$reg17_lsb & 0x00}];
		

	if {($reg17_msb == 0x02) && ($reg17_lsb == 0x00)} {
		puts "PHY operating in Full Duplex mode.";
	} else {
		puts "PHY operating in Half Duplex mode.";
	}

}
## =======================================================================================

proc SFPP_CHKPHY_SPEED {} {

	global  PHY_BASE_ADDRESS
	global PHY_SPECIFIC_STATUS_ADDRESS
	
	set reg17_msb [i2c_reg_read  $PHY_BASE_ADDRESS $PHY_SPECIFIC_STATUS_ADDRESS];
	set reg17_lsb [i2c_reg_read  $PHY_BASE_ADDRESS $PHY_SPECIFIC_STATUS_ADDRESS];
	set reg17_msb [expr {$reg17_msb & 0x0C}];
	set reg17_lsb [expr {$reg17_lsb & 0x00}];
		

	if {($reg17_msb == 0x00) && ($reg17_lsb == 0x00)} {
		puts "PHY operating Speed 10Mbps";
	} elseif {($reg17_msb == 0x04) && ($reg17_lsb == 0x00)} {
		puts "PHY operating Speed 100Mbps";
	} elseif {($reg17_msb == 0x08) && ($reg17_lsb == 0x00)} {
		puts "PHY operating Speed 1000Mbps";
	} else {
		puts "PHY operating Speed Error!";
	}

}
## =======================================================================================
proc SFPP_CHKPHY_AN_STAT {} {
	
	global PHY_BASE_ADDRESS
	global PHY_STATUS_ADDRESS
		
	puts "PHY Status Register:   [i2c_reg_read $PHY_BASE_ADDRESS $PHY_STATUS_ADDRESS]";
	set reg1_msb [i2c_reg_read  $PHY_BASE_ADDRESS $PHY_SPECIFIC_STATUS_ADDRESS];
	set reg1_lsb [i2c_reg_read  $PHY_BASE_ADDRESS $PHY_SPECIFIC_STATUS_ADDRESS];

	#check bit 5 - AN completed bit in reg 1 PHY STATUS REG
	set reg1_msb [expr {$reg1_msb & 0x00}];
	set reg1_lsb [expr {$reg1_lsb & 0x20}];

	if {($reg1_msb == 0x00) && ($reg1_lsb == 0x20)} {
		puts "AN is completed";
	} else {
		puts "AN is NOT completed";
	}
	
	
	
}

