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

 proc SETPHY_SERIAL_LLPBK {} {
    	global PHY_IP_BASE_ADDR
    	global phy_serial_loopback
        puts "\t 			Enabling serial PMA Loopback (local)"
        reg_write $PHY_IP_BASE_ADDR $phy_serial_loopback 0x0000000f 
        puts "				Read back Serial PMA loopback register = [reg_read $PHY_IP_BASE_ADDR $phy_serial_loopback] " 
       }

 proc RESETPHY_SERIAL_LLPBK {} {
    	global PHY_IP_BASE_ADDR
    	global phy_serial_loopback
        puts "\t			Disabling serial PMA Loopback (local)"
        reg_write $PHY_IP_BASE_ADDR $phy_serial_loopback 0x00000000 
        puts "\t			Read back Serial PMA loopback register = [reg_read $PHY_IP_BASE_ADDR $phy_serial_loopback] " 
       }

 proc CHKPHY_SERIAL_LLPBK {} {
    	global PHY_IP_BASE_ADDR
    	global phy_serial_loopback
        puts "\t		Read Serial PMA loopback register = [reg_read $PHY_IP_BASE_ADDR $phy_serial_loopback] " 
       }

 

 proc SETPHY_SPEED_10G {} {
	
	 global PHY_IP_BASE_ADDR
	 global seq_control 
	 
	 puts "\t 			configure_to_10G"

	 reg_write $PHY_IP_BASE_ADDR $seq_control 0x141
      
}
 
 proc CHKPHY_SPEED_10G {} {
	global PHY_IP_BASE_ADDR	 
	global seq_control 
	puts "\t 			VALUE AFTER CONFIGURE_10G = [reg_read $PHY_IP_BASE_ADDR $seq_control]" 
	 
}



proc SETPHY_SPEED_1G {} {
	
	global PHY_IP_BASE_ADDR
	global seq_control 
	
	puts "\t 			configure_to_1G"
	 
	reg_write $PHY_IP_BASE_ADDR $seq_control 0x111
   
}
 
 proc CHKPHY_SPEED_1G {} {
	 
	global PHY_IP_BASE_ADDR 
	global seq_control 
	puts "\t 			VALUE AFTER CONFIGURE_1G = [reg_read $PHY_IP_BASE_ADDR $seq_control]"  

}	 
# new functions

proc SETPHY_SGMII_SPEED_10M {} {


	global PHY_IP_BASE_ADDR
	global 1g_pcs_if_mode 
	
	puts "\t 			configure SGMII speed to 10M"
	 
	reg_write $PHY_IP_BASE_ADDR $1g_pcs_if_mode 0x01


}

proc SETPHY_SGMII_SPEED_100M {} {


	global PHY_IP_BASE_ADDR
	global 1g_pcs_if_mode 
	
	puts "\t 			configure SGMII speed to 100M"
	
	reg_write $PHY_IP_BASE_ADDR $1g_pcs_if_mode 0x05 


}
proc SETPHY_SGMII_SPEED_1G {} {


	global PHY_IP_BASE_ADDR
	global 1g_pcs_if_mode 
	
	puts "\t 			 configure SGMII speed to 1G"
	
	reg_write $PHY_IP_BASE_ADDR $1g_pcs_if_mode 0x09 


}






proc WAITPHY_READY_10G {} {
	 
	global PHY_IP_BASE_ADDR 
	global pcs_status_reg
	
	puts "\t 			Wait for 10G PHY to be ready..."
	set value [reg_read  $PHY_IP_BASE_ADDR $pcs_status_reg];
	set value [expr {$value & 0x84}]
	while {$value !=0x82} {
		set value [reg_read  $PHY_IP_BASE_ADDR $pcs_status_reg];
		set value [expr {$value & 0x84}]
	
	}
   puts "\t 			10G PHY is ready"
		
}	 

 proc WAITPHY_READY_1G {} {
	 
	global PHY_IP_BASE_ADDR 
	global 1g_pcs_status
	
	puts "\t 			Wait for 1G PHY to be ready..."
	set value [reg_read  $PHY_IP_BASE_ADDR $1g_pcs_status];
	set value [expr {$value & 0x04}]
	while {$value !=0x82} {
		set value [reg_read  $PHY_IP_BASE_ADDR $1g_pcs_status];
		set value [expr {$value & 0x04}]
	
	}
   puts "\t 			1G PHY is ready"
	
}	 
proc CHKPHY_SGMII_DUPLEX {} {

	global  PHY_IP_BASE_ADDR
	global 1g_pcs_control
	
	set temp_value [reg_read  $PHY_IP_BASE_ADDR $1g_pcs_control];
	set temp_value [expr {$temp_value & 0x0100}];

	if { $temp_value == 0x00000100} {
		puts "PHY operating in Full Duplex mode.";
	} else {
		puts "PHY operating in Half Duplex mode.";
	}

}
proc CHKPHY_SGMII_SPEED {} {

	global  PHY_IP_BASE_ADDR
	global 1g_pcs_control
	
	set temp_value [reg_read  $PHY_IP_BASE_ADDR $1g_pcs_control];
	set temp_value [expr {$temp_value & 0x2040}];

	if { $temp_value == 0x00000000 } {
		puts "PHY operating Speed 10Mbps";
	} elseif { $temp_value == 0x00002000 } {
		puts "PHY operating Speed 100Mbps";
	} elseif { $temp_value == 0x00000040 } {
		puts "PHY operating Speed 1000Mbps";
	} else {
		puts "PHY operating Speed Error!";
	}

}



# end new


proc RESETPHY_1G_AN {} {
  global PHY_IP_BASE_ADDR 
  global 1g_pcs_control
  global AUTONEGOTIATION_ENABLE_BIT			
  puts "\t 			Reset PCS AN"
  set value [reg_read  $PHY_IP_BASE_ADDR $1g_pcs_control] 
  set value [expr $value & (!(1<$AUTONEGOTIATION_ENABLE_BIT))]
  reg_write $PHY_IP_BASE_ADDR $1g_pcs_control $value
   
}	
proc SETPHY_SGMII_ENA {} {


	global PHY_IP_BASE_ADDR
	global 1g_pcs_if_mode 
	
	puts "\t 			Set Enable PCS SGMII and Auto-Negotiation"
	
	reg_write $PHY_IP_BASE_ADDR $1g_pcs_if_mode 0x03 


}


proc SETPHY_1G_ENABLE_AN {} {
	
	global PHY_IP_BASE_ADDR
	global 1g_pcs_control
	global AUTONEGOTIATION_ENABLE_BIT
	set value [reg_read $PHY_IP_BASE_ADDR $1g_pcs_control];
	
   set value [expr {$value | (1<<$AUTONEGOTIATION_ENABLE_BIT)}];
	puts "\t 			Set Enable PCS Auto-Negotiation";
	
   reg_write $PHY_IP_BASE_ADDR $1g_pcs_control $value
	
}
proc SETPHY_1G_RESTART_AN {} { 
	
	global PHY_IP_BASE_ADDR
	global 1g_pcs_control
	global RESTART_AUTO_NEGOTIATION_BIT
	set value [reg_read $PHY_IP_BASE_ADDR $1g_pcs_control];
   set value [expr {$value | {1<<$RESTART_AUTO_NEGOTIATION_BIT}}];
	puts "\t 			Set PCS Resart Auto Negotiation ";
	
   reg_write $PHY_IP_BASE_ADDR $1g_pcs_control $value
}

proc CHKPHY_1G_AN_COMPLETED {} {

	global PHY_IP_BASE_ADDR
	global 1g_pcs_status
	global AUTO_NEGOTIATION_COMPLETE_BIT
	
	set value [reg_read  $PHY_IP_BASE_ADDR $1g_pcs_status];
	set value [expr {$value & {1<<$AUTO_NEGOTIATION_COMPLETE_BIT}}]
	while ($value !=0x0020) {
		set value [reg_read  $PHY_IP_BASE_ADDR $1g_pcs_status];
		set value [expr {$value & {1<<$AUTO_NEGOTIATION_COMPLETE_BIT}}]
	
	}
   puts "\t 			 The auto-negotiation process is completed"
		
	
}
	 