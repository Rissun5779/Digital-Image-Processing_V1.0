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
proc TEST_PHYSERIAL_LOOPBACK_N {} {
 
 TEST_PHYSERIAL_LOOPBACK 0 10G 10000
 TEST_PHYSERIAL_LOOPBACK 1 10G 10000
 TEST_PHYSERIAL_LOOPBACK 2 10G 10000
 TEST_PHYSERIAL_LOOPBACK 3 10G 10000
 TEST_PHYSERIAL_LOOPBACK 4 10G 10000
 TEST_PHYSERIAL_LOOPBACK 5 10G 10000
 TEST_PHYSERIAL_LOOPBACK 6 10G 10000
 TEST_PHYSERIAL_LOOPBACK 7 10G 10000
 TEST_PHYSERIAL_LOOPBACK 8 10G 10000
 TEST_PHYSERIAL_LOOPBACK 9 10G 10000
 TEST_PHYSERIAL_LOOPBACK 10 10G 10000
 TEST_PHYSERIAL_LOOPBACK 11 10G 10000

 TEST_PHYSERIAL_LOOPBACK 0 1G 10000
 TEST_PHYSERIAL_LOOPBACK 1 1G 10000
 TEST_PHYSERIAL_LOOPBACK 2 1G 10000
 TEST_PHYSERIAL_LOOPBACK 3 1G 10000
 TEST_PHYSERIAL_LOOPBACK 4 1G 10000
 TEST_PHYSERIAL_LOOPBACK 5 1G 10000
 TEST_PHYSERIAL_LOOPBACK 6 1G 10000
 TEST_PHYSERIAL_LOOPBACK 7 1G 10000
 TEST_PHYSERIAL_LOOPBACK 8 1G 10000
 TEST_PHYSERIAL_LOOPBACK 9 1G 10000
 TEST_PHYSERIAL_LOOPBACK 10 1G 10000
 TEST_PHYSERIAL_LOOPBACK 11 1G 10000
 
 TEST_PHYSERIAL_LOOPBACK 0 100M 10000
 TEST_PHYSERIAL_LOOPBACK 1 100M 10000
 TEST_PHYSERIAL_LOOPBACK 2 100M 10000
 TEST_PHYSERIAL_LOOPBACK 3 100M 10000
 TEST_PHYSERIAL_LOOPBACK 4 100M 10000
 TEST_PHYSERIAL_LOOPBACK 5 100M 10000
 TEST_PHYSERIAL_LOOPBACK 6 100M 10000
 TEST_PHYSERIAL_LOOPBACK 7 100M 10000
 TEST_PHYSERIAL_LOOPBACK 8 100M 10000
 TEST_PHYSERIAL_LOOPBACK 9 100M 10000
 TEST_PHYSERIAL_LOOPBACK 10 100M 10000
 TEST_PHYSERIAL_LOOPBACK 11 100M 10000

 TEST_PHYSERIAL_LOOPBACK 0 10M 10000
 TEST_PHYSERIAL_LOOPBACK 1 10M 10000
 TEST_PHYSERIAL_LOOPBACK 2 10M 10000
 TEST_PHYSERIAL_LOOPBACK 3 10M 10000
 TEST_PHYSERIAL_LOOPBACK 4 10M 10000
 TEST_PHYSERIAL_LOOPBACK 5 10M 10000
 TEST_PHYSERIAL_LOOPBACK 6 10M 10000
 TEST_PHYSERIAL_LOOPBACK 7 10M 10000
 TEST_PHYSERIAL_LOOPBACK 8 10M 10000
 TEST_PHYSERIAL_LOOPBACK 9 10M 10000
 TEST_PHYSERIAL_LOOPBACK 10 10M 10000
 TEST_PHYSERIAL_LOOPBACK 11 10M 10000
}
#only 6 SMA channel is available
proc TEST_SMA_LOOPBACK_N {} {
 
 TEST_SMA_LOOPBACK 0 10G 10000
 TEST_SMA_LOOPBACK 1 10G 10000
 TEST_SMA_LOOPBACK 2 10G 10000
 TEST_SMA_LOOPBACK 3 10G 10000
 TEST_SMA_LOOPBACK 4 10G 10000
 TEST_SMA_LOOPBACK 5 10G 10000


 TEST_SMA_LOOPBACK 0 1G 10000
 TEST_SMA_LOOPBACK 1 1G 10000
 TEST_SMA_LOOPBACK 2 1G 10000
 TEST_SMA_LOOPBACK 3 1G 10000
 TEST_SMA_LOOPBACK 4 1G 10000
 TEST_SMA_LOOPBACK 5 1G 10000

 
 TEST_SMA_LOOPBACK 0 100M 10000
 TEST_SMA_LOOPBACK 1 100M 10000
 TEST_SMA_LOOPBACK 2 100M 10000
 TEST_SMA_LOOPBACK 3 100M 10000
 TEST_SMA_LOOPBACK 4 100M 10000
 TEST_SMA_LOOPBACK 5 100M 10000


 TEST_SMA_LOOPBACK 0 10M 10000
 TEST_SMA_LOOPBACK 1 10M 10000
 TEST_SMA_LOOPBACK 2 10M 10000
 TEST_SMA_LOOPBACK 3 10M 10000
 TEST_SMA_LOOPBACK 4 10M 10000
 TEST_SMA_LOOPBACK 5 10M 10000

}


#=====TEST SFPP=================

proc CONFIG_SFPP {} {
 	
SPFF_SETPHY_HWCFG_MODE	
SPFF_AN_ENA
SFPP_SETPHY_FIFODEPTH
SFPP_SETPHY_ADVERTISE_1000TX_FD
SFPP_SETPHY_ADVERTISE_1000TX_HD
SFPP_SETPHY_ADVERTISE_100TX_FD
SFPP_SETPHY_ADVERTISE_100TX_HD
SFPP_SETPHY_ADVERTISE_10TX_FD
SFPP_SETPHY_ADVERTISE_10TX_HD 
 

}

#test SFP with ST LOOPBACK enable
proc TEST_SFPP_ENA_ST_LOOPBACK {channel} {

	global MAC_DST_ADDRESS
	
	global LOGFILE
	set filename REGRESS_SFPP.LOG
	set LOGFILE [open $filename "w"]
	
	
   
	puts " CONFIGURE CHANNEL $channel"
	SET_CHANNEL_BASE_ADDR $channel
	CONFIG_MAC_BASIC $MAC_DST_ADDRESS
	SETPHY_SGMII_ENA
	SETPHY_1G_ENABLE_AN
	

	SET_TRAFFIC_CONTROLLER_STD_CHANNEL_BASE_ADDR $channel
	SET_AVALON_ST_LOOPBACK_ENA

	after 200

	CHKMAC_TXSTATS
	CHKMAC_RXSTATS
}
## =======================================================================================
#test SFP without ST LOOPBACK enable
proc TEST_SFPP_WO_ENA_ST_LOOPBACK {channel burst_size} {

	global MAC_DST_ADDRESS
	
	global LOGFILE
	set filename REGRESS_SFPP.LOG
	set LOGFILE [open $filename "w"]
	
	

	puts " CONFIGURE CHANNEL $channel"
	SET_CHANNEL_BASE_ADDR $channel
	CONFIG_MAC_BASIC $MAC_DST_ADDRESS
	SETPHY_SGMII_ENA
	SETPHY_1G_ENABLE_AN
	
	SET_TRAFFIC_CONTROLLER_STD_CHANNEL_BASE_ADDR $channel
	RESET_AVALON_ST_LOOPBACK_ENA
   
	CONFIG_TRAFFIC_CONTROL $burst_size
	SETGEN_START
	after 200

	CHKMAC_TXSTATS

}

## =======================================================================================
#-test N ports without 1588 design and SFP loopback 
proc TEST_SMA_LOOPBACK {channel speed_test burst_size} {
   global LOGFILE
	set filename REGRESS_SFPP.LOG
	set LOGFILE [open $filename "w"]
	
	
	puts " CONFIGURE CHANNEL $channel"
	
	SET_CHANNEL_BASE_ADDR $channel
	CONFIG_1PORT $speed_test

	

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

proc TEST_PHYSERIAL_LOOPBACK {channel speed_test burst_size} {	
  
   global LOGFILE
	set filename REGRESS_SFPP.LOG
	set LOGFILE [open $filename "w"]

	puts " CONFIGURE CHANNEL $channel"
	
	SET_CHANNEL_BASE_ADDR $channel
	CONFIG_1PORT $speed_test
	SETPHY_SERIAL_LLPBK

	
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


