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


##==============================================================================
##		Main Reference Design Test CLI
##==============================================================================  

source basic/basic.tcl
source system_base_addr_map.tcl
source test_functions.tcl
source mac/mac_inc.tcl
source fifo/fifo_inc.tcl
source phy/phy_ip_inc.tcl
source test_parameter/parameter.tcl
source tod/tod_inc.tcl
source traffic_controller/traffic_controller.tcl
source channel_setting.tcl
source external_phy/marvell/sfpp_i2c.tcl


## =======================================================================================
#            MAIN TEST FUNCTIONS
## =======================================================================================

# configure SFP to enable AN and advertisement 
proc CONFIG_SFPP {} {
 	
SPFF_SETPHY_HWCFG_MODE	
SPFF_AN_ENA
SFPP_SETPHY_FIFODEPTH
SFPP_SETPHY_ADVERTISE_1000TX_FD

SFPP_SETPHY_ADVERTISE_100TX_FD

SFPP_SETPHY_ADVERTISE_10TX_FD

 

}
# Test with Smart Bit:enable avalon ST loopback
# SFPP is channel 6

proc TEST_SFPP1_6 {} {

	global MAC_DST_ADDRESS
	
	global LOGFILE
	set filename REGRESS_SFPP.LOG
	set LOGFILE [open $filename "w"]
	
	

	puts " CONFIGURE CHANNEL 6"
	SET_CHANNEL_BASE_ADDR 6
	SETMAC_CLR_STATS
	CONFIG_MAC_BASIC $MAC_DST_ADDRESS
	# Must manually disable SGMII for 1000BASE-X
	SETPHY_SGMII_ENA
	# Must manually disable AN
	SETPHY_1G_ENABLE_AN
	
	


	SET_TRAFFIC_CONTROLLER_SELECTOR_BASE_ADDR 3
	SELECT_STD_ETHERNET_TRAFFIC_CONTROLLER
	SET_TRAFFIC_CONTROLLER_STD_CHANNEL_BASE_ADDR 6
	SET_AVALON_ST_LOOPBACK_ENA
   
	
	
}

# Test with Smart Bit:not enable avalon ST loopback
# SFPP is channel 6
proc TEST_SFPP2_6 {burst_size} {

	global MAC_DST_ADDRESS
	
	global LOGFILE
	set filename REGRESS_SFPP.LOG
	set LOGFILE [open $filename "w"]
	
	

	puts " CONFIGURE CHANNEL 6"
	SET_CHANNEL_BASE_ADDR 6
	SETMAC_CLR_STATS
	CONFIG_MAC_BASIC $MAC_DST_ADDRESS
	SETPHY_SGMII_ENA
	SETPHY_1G_ENABLE_AN
	
	


	SET_TRAFFIC_CONTROLLER_SELECTOR_BASE_ADDR 3
	SELECT_STD_ETHERNET_TRAFFIC_CONTROLLER
	SET_TRAFFIC_CONTROLLER_STD_CHANNEL_BASE_ADDR 6
	RESET_AVALON_ST_LOOPBACK_ENA
   
	CONFIG_TRAFFIC_CONTROL $burst_size
	SETGEN_START
	after 200

	CHKMAC_TXSTATS
}
## =======================================================================================
# test with 1588 master -slave pair

proc TEST_1588 {from_channel to_channel speed_test} {
   
		global LOGFILE
		set filename REGRESS_SFPP.LOG
		set LOGFILE [open $filename "w"]
		

		# TEST 2 port 0 and 1 with master slave 1588	
		puts " CONFIGURE CHANNEL $from_channel as master"
		SET_CHANNEL_BASE_ADDR $from_channel
		CONFIG_1PORT $speed_test
		
		puts " CONFIGURE CHANNEL $to_channel as slave"
		SET_CHANNEL_BASE_ADDR $to_channel
		CONFIG_1PORT $speed_test
	
     	#selector base address channel id = channel id /2
		#for example if channel id = 2, this wil be set 1
		#if channel id = 3, this will be set to 3/2 = 1
		SET_TRAFFIC_CONTROLLER_SELECTOR_BASE_ADDR [expr $from_channel/2] 
		SELECT_1588_TRAFFIC_CONTROLLER
		
		SET_TRAFFIC_CONTROLLER_1588_CHANNEL_BASE_ADDR [expr $from_channel/2] 
		SET_1588_START_TOD_SYNC
		SET_1588_GO_MASTER
		WAIT_OFFSET_DELAY_CAPTURED
		RESET_1588_GO_MASTER
		RESET_1588_START_TOD_SYNC
		after 200
		CHK_1588_STATUS
				
		SET_CHANNEL_BASE_ADDR $from_channel
		CHKMAC_TXSTATS
		CHKMAC_RXSTATS
		
		SET_CHANNEL_BASE_ADDR $to_channel
		CHKMAC_TXSTATS
		CHKMAC_RXSTATS
		

	
}
## =======================================================================================
#-test SMA loopback 
proc TEST_SMA_LB {channel speed_test burst_size} {
   global LOGFILE
	set filename REGRESS_SFPP.LOG
	set LOGFILE [open $filename "w"]
	
	
	puts " CONFIGURE CHANNEL $channel"
	
	SET_CHANNEL_BASE_ADDR $channel
	CONFIG_1PORT $speed_test

	
	#selector base address channel id = channel id /2
	#for example if channel id = 2, this wil be set 1
	#if channel id = 3, this will be set to 3/2 = 1
	SET_TRAFFIC_CONTROLLER_SELECTOR_BASE_ADDR [expr $channel/2]  
	SELECT_STD_ETHERNET_TRAFFIC_CONTROLLER
	
	SET_TRAFFIC_CONTROLLER_STD_CHANNEL_BASE_ADDR $channel
	RESET_AVALON_ST_LOOPBACK_ENA
	CONFIG_TRAFFIC_CONTROL $burst_size
	
	SETGEN_START
	after 200
	CHKMON_DONE
	CHKMON_STATUS
	SET_CHANNEL_BASE_ADDR $channel
	CHKMAC_TXSTATS
	CHKMAC_RXSTATS
	
}
## =======================================================================================
# test internal FPGA PHY serial loopback
proc TEST_PHYSERIAL_LOOPBACK {channel speed_test burst_size} {	
  
   global LOGFILE
	set filename REGRESS_SFPP.LOG
	set LOGFILE [open $filename "w"]

	puts " CONFIGURE CHANNEL $channel"
	
	SET_CHANNEL_BASE_ADDR $channel
	CONFIG_1PORT $speed_test
	SETPHY_SERIAL_LLPBK
	
	
	#selector base address channel id = channel id /2
	#for example if channel id = 2, this wil be set 1
	#if channel id = 3, this will be set to 3/2 = 1
	SET_TRAFFIC_CONTROLLER_SELECTOR_BASE_ADDR [expr $channel/2]    
	SELECT_STD_ETHERNET_TRAFFIC_CONTROLLER
	
	SET_TRAFFIC_CONTROLLER_STD_CHANNEL_BASE_ADDR $channel
	RESET_AVALON_ST_LOOPBACK_ENA
	CONFIG_TRAFFIC_CONTROL $burst_size
	
	SETGEN_START
	after 200
	CHKMON_DONE
	CHKMON_STATUS
	SET_CHANNEL_BASE_ADDR $channel
	CHKMAC_TXSTATS
	CHKMAC_RXSTATS
   
}


