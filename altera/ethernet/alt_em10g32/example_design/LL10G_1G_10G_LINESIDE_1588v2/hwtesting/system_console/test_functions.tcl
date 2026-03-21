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



source system_base_addr_map.tcl
source channel_setting.tcl
source basic/basic.tcl
source mac/mac_inc.tcl
source fifo/fifo_inc.tcl
source phy/phy_ip_inc.tcl
source tod/tod_inc.tcl
source traffic_controller/traffic_controller.tcl
#---------TEST N PORTS-------------------------------------

proc CONFIG_NPORTS {speed_test} {
	global NUM_CHANNELS
	for {set i 0} {$i < $NUM_CHANNELS} {incr i} {
		puts " CONFIGURE CHANNEL $i"
		SET_CHANNEL_BASE_ADDR $i
		CONFIG_1PORT $speed_test

   }
}
proc CHK_MAC_STATUS_NPORTS {} {
	global NUM_CHANNELS
	for {set i 0} {$i < $NUM_CHANNELS} {incr i} {
		puts " Check MAC TX RX STATUS CHANNEL $i"
		SET_CHANNEL_BASE_ADDR $i
		CHKMAC_TXSTATS
		CHKMAC_RXSTATS
	}
	

}

proc CONFIG_1PORT {speed_test} {
	
	global MAC_SRC_ADDRESS
	global MAC_DST_ADDRESS
	global 10G_ETH_MODE
	global 1588_MODE
	global SGMII_MODE
	#1. Configure speed
	   if {$speed_test == "10G"} {
				SETPHY_SPEED_10G
		} else {
				SETPHY_SPEED_1G
		}
		
	   if {$SGMII_MODE ==1} {	
			  if {$speed_test == "10M"} {
				SETPHY_SGMII_SPEED_10M
			  } elseif {$speed_test == "100M"} {
				SETPHY_SGMII_SPEED_100M
			  } elseif {$speed_test == "1G"} {
				SETPHY_SGMII_SPEED_1G
			  } 
		}
   #2. configure mac
		CONFIG_MAC_BASIC $MAC_DST_ADDRESS
		
		if {$1588_MODE == 1} { 
			CONFIG_TSU
		}
	#3. configure tod	if 1588  
		if {$1588_MODE == 1} {
			CONFIG_CSR_TOD_1G10G
		}
 	#4. configure PHY if 1G10G mode
#		 if {$10G_ETH_MODE == "1G10G"} {
#			RESETPHY_1G_PCS_AN
#		}
	#5. disable loopback	

   	RESETPHY_SERIAL_LLPBK


}

proc CONFIG_TRAFFIC_CONTROL {burst_size} {

	global MAC_SRC_ADDRESS
	global MAC_DST_ADDRESS
	global BURST_TYPE
	global PACKET_TYPE
	global PACKET_SIZE

	CONFIG_TRAFFIC $BURST_TYPE $burst_size $PACKET_TYPE $PACKET_SIZE $MAC_SRC_ADDRESS $MAC_DST_ADDRESS

}

#---------TEST 1 PORT-------------------------------------
proc TEST_SFPLPBK {burst_size} {
	global MAC_SRC_ADDRESS
	global MAC_DST_ADDRESS
	global BURST_TYPE
	global PACKET_TYPE
	global PACKET_SIZE
	global 10G_ETH_MODE
	global 1588_MODE
	
	#0. Configure speed
		SETPHY_SPEED_1G
			
		
	#1. configure traffic controller
		if {$1588_MODE == 0} {
			CONFIG_TRAFFIC $BURST_TYPE $burst_size $PACKET_TYPE $PACKET_SIZE $MAC_SRC_ADDRESS $MAC_DST_ADDRESS
 	    }
   #2. configure mac
		CONFIG_MAC_BASIC $MAC_DST_ADDRESS
		
		if {$1588_MODE == 1} {
			CONFIG_MAC_1588
		 }
	
	#3. configure tod	if 1588  
		if {$1588_MODE == 1} {
			CONFIG_CSR_TOD_1G10G
		}
 	#4. configure PHY if 1G!G mode
		 if {$10G_ETH_MODE == "1G10G"} {
			RESETPHY_1G10G_PCS_AN
		}
	
	#5. disable loopback	
 		#Disable XGMII Loopback
		if {$1588_MODE == 0} {
			CLR_AVALON_ST_LOOPBACK_ENA
		}
   	RESETPHY_SERIAL_LLPBK
			
 	
	#7. start generate packet
		if{$1588_MODE == 1 } {
			SET_1588_GO_MASTER
			SET_1588_START_TOD_SYNC
		} else {
			SETGEN_START
		}
 	
	#8. wait monitor done and display monitor reg and MAC statistic counter
		if {$1588_MODE == 0} {
			CHKMON_DONE
			CHKMON_STATUS
		}
   
		if {$1588_MODE == 1} {
			WAIT_OFFSET_DELAY_CAPTURED	
			CHK_1588_STATUS
		}
		CHKMAC_TXSTATS
		CHKMAC_RXSTATS	
}
  	

proc TEST_ALTPMA_LBPK {burst_size} {
	global MAC_SRC_ADDRESS
	global MAC_DST_ADDRESS
	global BURST_TYPE
	global PACKET_TYPE
	global PACKET_SIZE
	global 10G_ETH_MODE
	global SPEED_TEST
	
	#1. Configure speed
		if {$SPEED_TEST == "1G"} {
			SETPHY_SPEED_1G
		} elseif {$SPEED_TEST == "10G"} {
				
		}
	#1. configure traffic controller
		CONFIG_TRAFFIC $BURST_TYPE $burst_size $PACKET_TYPE $PACKET_SIZE $MAC_SRC_ADDRESS $MAC_DST_ADDRESS
 	
   #2. configure mac
		CONFIG_MAC_BASIC $MAC_DST_ADDRESS

 	#4. configure PHY if 1G10G mode
		 if{$10G_ETH_MODE == "1G10G"} {
			RESETPHY_1G10G_PCS_AN
		}
	#5. configure loopback	
 		
		SETPHY_SERIAL_LLPBK
		#Disable Avalon ST Loopback
		CLR_AVALON_ST_LOOPBACK_ENA
	
 	
	#7. start generate packet
		SETGEN_START
 	
	#8. wait monitor done and display monitor reg and MAC statistic counter
		CHKMON_DONE
		CHKMON_STATUS
		CHKMAC_TXSTATS
		CHKMAC_RXSTATS
	   

		
}
# Avalon ST loopback is no applicable for design with 1588
proc TEST_AVALONST_LBPK {burst_size} {
	global MAC_SRC_ADDRESS
	global MAC_DST_ADDRESS
	global BURST_TYPE
	global PACKET_TYPE
	global PACKET_SIZE
	global 10G_ETH_MODE
	global SPEED_TEST
	#1. Configure speed
		if {$SPEED_TEST == "1G"} {
			SETPHY_SPEED_1G
		} elseif {$SPEED_TEST == "10G"} {
				
		}
	#1. configure traffic controller
		CONFIG_TRAFFIC $BURST_TYPE $burst_size $PACKET_TYPE $PACKET_SIZE $MAC_SRC_ADDRESS $MAC_DST_ADDRESS
 	
   #2. configure mac
		CONFIG_MAC_BASIC $MAC_DST_ADDRESS
	
 	#3. configure PHY if 1G10G mode
		 if{$10G_ETH_MODE == "1G10G"} {
			RESETPHY_1G10G_PCS_AN
		}
	#4. enable serial loopback and Disable other loopbacks	
 		
		#ENable PMA Serial Loopback
		RESETPHY_SERIAL_LLPBK

		#Disable Avalon ST Loopback
		SET_AVALON_ST_LOOPBACK_ENA
	
 	#6. start generate packet
		SETGEN_START
 	
	#7. wait monitor done and display monitor reg and MAC statistic counter
		CHKMON_DONE
		CHKMON_STATUS
		CHKMAC_TXSTATS
		CHKMAC_RXSTATS
}
