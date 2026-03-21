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
source mac/10g_mac_reg_map.tcl

##Edmond##
#source channel_setting.tcl

proc CONFIG_MAC_BASIC {macaddr} {
	 puts "\t\t\t\tsetting up mac with a basic working config"
	 SETMAC_PRIMARY_ADDR $macaddr 			
	 SETMAC_STRIP_RX_PADCRC  
	 SETMAC_CLR_STATS
} 
 
 proc SETMAC_PRIMARY_ADDR {value} {
    global 10GMAC_BASE_ADDR
    global rx_frame_addr0
    global rx_frame_addr1
    set rx_mac_primaddr1 0x[string range $value 0 3]
    puts "\t 			setting $rx_mac_primaddr1 into rxmac primary address Reg-1"
    reg_write $10GMAC_BASE_ADDR $rx_frame_addr1 $rx_mac_primaddr1

    set rx_mac_primaddr0 0x[string range $value 4 11]
    puts "\t 			setting $rx_mac_primaddr0 into rxmac primary address Reg-0"
    reg_write $10GMAC_BASE_ADDR $rx_frame_addr0 $rx_mac_primaddr0
   }

 
 
 
 proc SETMAC_STRIP_RX_PADCRC {} {
    	global 10GMAC_BASE_ADDR
    	global rx_padcrc_control
       	puts "\t 			enabling: pad and crc stripping in rx mac"
       	reg_write $10GMAC_BASE_ADDR $rx_padcrc_control 0x00000003
  }

 proc CHKMAC_STRIP_RX_PADCRC {} {
    	global 10GMAC_BASE_ADDR
    	global rx_padcrc_control
        puts "\t 			rxmac pad-crc stripping setting = "
        reg_read $10GMAC_BASE_ADDR $rx_padcrc_control 
      }

 ## ______________________________________________________
 ## 

 proc RESETMAC_LLPBK_XGMII {} {
    	global XGMII_LB_BASE_ADDR
    	global XGMII_LLPBK
        puts "\t 			disabling: local loopback at xgmii interface "
        reg_write $XGMII_LB_BASE_ADDR $XGMII_LLPBK 0x0 
      }
 proc CHKMAC_LLPBK_XGMII {} {
    	global XGMII_LB_BASE_ADDR
    	global XGMII_LLPBK
        puts "\t 			local loopback at xgmii setting = [reg_read $XGMII_LB_BASE_ADDR $XGMII_LLPBK]"  
     }

 proc SETMAC_LLPBK_XGMII {} {
    	global XGMII_LB_BASE_ADDR
    	global XGMII_LLPBK
        puts "\t 			enabling: local loopback at xgmii interface "
        reg_write $XGMII_LB_BASE_ADDR $XGMII_LLPBK 0x1 
      }



 proc SETMAC_CLR_STATS {} {
    	global  ClearStats  
    	global  tClearStats           	  
    	global 	10g_mac_tx_statistic_counters_reg_map    
    	global 	10g_mac_rx_statistic_counters_reg_map 
    	global   10GMAC_BASE_ADDR  
        puts "\t 			clearing mac stats registers"
    	reg_write $10GMAC_BASE_ADDR $tClearStats 0x01
    	reg_write $10GMAC_BASE_ADDR $ClearStats 0x01
	}
 ## ______________________________________________________



 ## =======================================================================================
 #		mac sanity check utilities
 ## =======================================================================================

  proc CHKMAC_RXSTATS {} {
        global 	LOGFILE    
    	global  10GMAC_BASE_ADDR
    	global	rx_frame_addr0     		
    	global	rx_frame_addr1     		
    	global	rx_frame_maxlength  		
    	
    	global	rx_frame_spaddr0_0  		
    	global	rx_frame_spaddr0_1  		
    	global	rx_frame_spaddr1_0  		
    	global	rx_frame_spaddr1_1  		
    	global	rx_frame_spaddr2_0  		
    	global	rx_frame_spaddr2_1  		
    	global	rx_frame_spaddr3_0  		
    	global	rx_frame_spaddr3_1  		

    	global	rx_padcrc_control     		
    	global 	RXFIFO_DROP_ON_ERROR                 
    	global 	XGMII_LLPBK                           

    	global 	tx_addrins_control    	
    	global 	tx_addrins_macaddr0    
    	global 	tx_addrins_macaddr1    
    	global 	10g_mac_tx_statistic_counters_reg_map    
    	global 	10g_mac_rx_statistic_counters_reg_map    
    
    ## _____________________________________________________________________
    ## 	Statistics Registers
    ## _____________________________________________________________________
    	global framesOK_lo             	  
    	global framesErr_lo            	  
    	global framesCRCErr_lo         	  
    	global octetsOK_lo             	  
    	global pauseMACCtrlFrames_lo   	  
    	global ifErrors_lo             	  
    	global unicastFramesOK_lo      	  
    	global unicastFramesErr_lo     	  
    	global multicastFramesOK_lo    	  
    	global multicastFramesErr_lo   	  
    	global broadcastFramesOK_lo    	  
    	global broadcastFramesErr_lo   	  
    	global etherStatsOctets_lo     	  
    	global etherStatsPkts_lo       	  
    	global etherStatsUndersizePkts_lo      
    	global etherStatsOversizePkts_lo       
    	global etherStatsPkts64Octets_lo       
    	global etherStatsPkts65to127Octets_lo  
    	global etherStatsPkts128to255Octets_lo 
    	global etherStatsPkts256to511Octets_lo 
    	global etherStatsPkts512to1023Octets_lo  
    	global etherStatPkts1024to1518Octets_lo  
    	global etherStatsPkts1519toXOctets_lo    
    	global etherStatsFragments_lo            
    	global etherStatsJabbers_lo              
    	global etherStatsCRCErr_lo               
    	global unicastMACCtrlFrames_lo           
    	global multicastMACCtrlFrames_lo         
    	global broadcastMACCtrlFrames_lo         

       	puts "\t 		       ======================================================================"
	puts "\t			|  MAC RX STATS REGISTER CHECK					     "
       	puts "\t 		       ======================================================================"
  	puts "\t			|# FRAMES_RECEIVED_WITH_ERROR         	= [format %u [reg_read $10GMAC_BASE_ADDR $framesErr_lo]]"
  	puts "\t			|# UNICAST_FRAMES_WITH_ERROR     	= [format %u [reg_read $10GMAC_BASE_ADDR $unicastFramesErr_lo]]"
  	puts "\t			|# MULTICAST_FRAMES_RECEIVED_WITH_ERROR = [format %u [reg_read $10GMAC_BASE_ADDR $multicastFramesErr_lo]]"
  	puts "\t			|# BRDCAST_FRAMES_WITH_ERROR   		= [format %u [reg_read $10GMAC_BASE_ADDR $broadcastFramesErr_lo]]"
  	puts "\t			|# FRAMES_RECEIVED_WITH_ONLY_CRCERROR 	= [format %u [reg_read $10GMAC_BASE_ADDR $framesCRCErr_lo]]"
  	puts "\t			|# VALID_LENGTH_FRAMES_WITH_CRC_ERROR   = [format %u [reg_read $10GMAC_BASE_ADDR $etherStatsCRCErr_lo]]"
  	puts "\t			|# JABBER_FRAMES                	= [format %u [reg_read $10GMAC_BASE_ADDR $etherStatsJabbers_lo]]"
  	puts "\t			|# FRAGMENTED_FRAMES                	= [format %u [reg_read $10GMAC_BASE_ADDR $etherStatsFragments_lo]]"
  	puts "\t			|# INVALID_FRAMES_RECEIVED             	= [format %u [reg_read $10GMAC_BASE_ADDR $ifErrors_lo]]"

  	puts "\t			|# FRAMES_RECEIVED_GOOD	 		= [format %u [reg_read $10GMAC_BASE_ADDR $framesOK_lo]]"
  	puts "\t			|# PAUSE_FRAMES_RECEIVED   		= [format %u [reg_read $10GMAC_BASE_ADDR $pauseMACCtrlFrames_lo]]"
  	puts "\t			|# UNICAST_CONTROL_FRAMES              	= [format %u [reg_read $10GMAC_BASE_ADDR $unicastMACCtrlFrames_lo]]"
  	puts "\t			|# MULTICAST_CONTROL_FRAMES            	= [format %u [reg_read $10GMAC_BASE_ADDR $multicastMACCtrlFrames_lo]]"
  	puts "\t			|# UNICAST_FRAMES_RECEIVED_GOOD   	= [format %u [reg_read $10GMAC_BASE_ADDR $unicastFramesOK_lo]]"
  	puts "\t			|# MULTICAST_FRAMES_RECEIVED_GOOD 	= [format %u [reg_read $10GMAC_BASE_ADDR $multicastFramesOK_lo]]"
  	puts "\t			|# BRDCAST_FRAMES_GOOD    		= [format %u [reg_read $10GMAC_BASE_ADDR $broadcastFramesOK_lo]]"
  	puts "\t			|# DATA_AND_PADDING_OCTETS_RECEIVED_GOOD= [format %u [reg_read $10GMAC_BASE_ADDR $octetsOK_lo]]"

  	puts "\t			|# COMPREHENSICE_OCTETS_RECEIVED       	= [format %u [reg_read $10GMAC_BASE_ADDR $etherStatsOctets_lo     	]]"
  	puts "\t			|# FRAMES_WITH_SIZE_64_BYTES            = [format %u [reg_read $10GMAC_BASE_ADDR $etherStatsPkts64Octets_lo]]"
  	puts "\t			|# FRAMES_BETWEEN_SIZE_64AND127_BYTES   = [format %u [reg_read $10GMAC_BASE_ADDR $etherStatsPkts65to127Octets_lo  ]]"
  	puts "\t			|# FRAMES_BETWEEN_SIZE_128AND255_BYTES  = [format %u [reg_read $10GMAC_BASE_ADDR $etherStatsPkts128to255Octets_lo ]]"
  	puts "\t			|# FRAMES_BETWEEN_SIZE_256AND511_BYTES  = [format %u [reg_read $10GMAC_BASE_ADDR $etherStatsPkts256to511Octets_lo ]]"
  	puts "\t			|# FRAMES_BETWEEN_SIZE_512AND1K_BYTES   = [format %u [reg_read $10GMAC_BASE_ADDR $etherStatsPkts512to1023Octets_lo]]"
  	puts "\t			|# FRAMES_BETWEEN_SIZE_1KND1518_BYTES   = [format %u [reg_read $10GMAC_BASE_ADDR $etherStatPkts1024to1518Octets_lo]]"
  	puts "\t			|# FRAMES_BETWEEN_SIZE_ABOVE1519_BYTES  = [format %u [reg_read $10GMAC_BASE_ADDR $etherStatsPkts1519toXOctets_lo  ]]"

       	puts $LOGFILE "\t 	       ======================================================================"
	puts $LOGFILE "\t		|  MAC RX STATS REGISTER CHECK					     "
       	puts $LOGFILE "\t 	       ======================================================================"
  	puts $LOGFILE "\t		|# FRAMES_RECEIVED_WITH_ERROR         	= [format %u [reg_read $10GMAC_BASE_ADDR $framesErr_lo]]"
  	puts $LOGFILE "\t		|# UNICAST_FRAMES_WITH_ERROR     	= [format %u [reg_read $10GMAC_BASE_ADDR $unicastFramesErr_lo]]"
  	puts $LOGFILE "\t		|# MULTICAST_FRAMES_RECEIVED_WITH_ERROR = [format %u [reg_read $10GMAC_BASE_ADDR $multicastFramesErr_lo]]"
  	puts $LOGFILE "\t		|# BRDCAST_FRAMES_WITH_ERROR   		= [format %u [reg_read $10GMAC_BASE_ADDR $broadcastFramesErr_lo]]"
  	puts $LOGFILE "\t		|# FRAMES_RECEIVED_WITH_ONLY_CRCERROR 	= [format %u [reg_read $10GMAC_BASE_ADDR $framesCRCErr_lo]]"
  	puts $LOGFILE "\t		|# VALID_LENGTH_FRAMES_WITH_CRC_ERROR   = [format %u [reg_read $10GMAC_BASE_ADDR $etherStatsCRCErr_lo]]"
  	puts $LOGFILE "\t		|# JABBER_FRAMES                	= [format %u [reg_read $10GMAC_BASE_ADDR $etherStatsJabbers_lo]]"
  	puts $LOGFILE "\t		|# FRAGMENTED_FRAMES                	= [format %u [reg_read $10GMAC_BASE_ADDR $etherStatsFragments_lo]]"
  	puts $LOGFILE "\t		|# INVALID_FRAMES_RECEIVED             	= [format %u [reg_read $10GMAC_BASE_ADDR $ifErrors_lo]]"

  	puts $LOGFILE "\t		|# FRAMES_RECEIVED_GOOD	 		= [format %u [reg_read $10GMAC_BASE_ADDR $framesOK_lo]]"
  	puts $LOGFILE "\t		|# PAUSE_FRAMES_RECEIVED   		= [format %u [reg_read $10GMAC_BASE_ADDR $pauseMACCtrlFrames_lo]]"
  	puts $LOGFILE "\t		|# UNICAST_CONTROL_FRAMES              	= [format %u [reg_read $10GMAC_BASE_ADDR $unicastMACCtrlFrames_lo]]"
  	puts $LOGFILE "\t		|# MULTICAST_CONTROL_FRAMES            	= [format %u [reg_read $10GMAC_BASE_ADDR $multicastMACCtrlFrames_lo]]"
  	puts $LOGFILE "\t		|# UNICAST_FRAMES_RECEIVED_GOOD   	= [format %u [reg_read $10GMAC_BASE_ADDR $unicastFramesOK_lo]]"
  	puts $LOGFILE "\t		|# MULTICAST_FRAMES_RECEIVED_GOOD 	= [format %u [reg_read $10GMAC_BASE_ADDR $multicastFramesOK_lo]]"
  	puts $LOGFILE "\t		|# BRDCAST_FRAMES_GOOD    		= [format %u [reg_read $10GMAC_BASE_ADDR $broadcastFramesOK_lo]]"
  	puts $LOGFILE "\t		|# DATA_AND_PADDING_OCTETS_RECEIVED_GOOD= [format %u [reg_read $10GMAC_BASE_ADDR $octetsOK_lo]]"

  	puts $LOGFILE "\t		|# COMPREHENSICE_OCTETS_RECEIVED       	= [format %u [reg_read $10GMAC_BASE_ADDR $etherStatsOctets_lo     	]]"
  	puts $LOGFILE "\t		|# FRAMES_WITH_SIZE_64_BYTES            = [format %u [reg_read $10GMAC_BASE_ADDR $etherStatsPkts64Octets_lo]]"
  	puts $LOGFILE "\t		|# FRAMES_BETWEEN_SIZE_64AND127_BYTES   = [format %u [reg_read $10GMAC_BASE_ADDR $etherStatsPkts65to127Octets_lo  ]]"
  	puts $LOGFILE "\t		|# FRAMES_BETWEEN_SIZE_128AND255_BYTES  = [format %u [reg_read $10GMAC_BASE_ADDR $etherStatsPkts128to255Octets_lo ]]"
  	puts $LOGFILE "\t		|# FRAMES_BETWEEN_SIZE_256AND511_BYTES  = [format %u [reg_read $10GMAC_BASE_ADDR $etherStatsPkts256to511Octets_lo ]]"
  	puts $LOGFILE "\t		|# FRAMES_BETWEEN_SIZE_512AND1K_BYTES   = [format %u [reg_read $10GMAC_BASE_ADDR $etherStatsPkts512to1023Octets_lo]]"
  	puts $LOGFILE "\t		|# FRAMES_BETWEEN_SIZE_1KND1518_BYTES   = [format %u [reg_read $10GMAC_BASE_ADDR $etherStatPkts1024to1518Octets_lo]]"
      } 

  proc CHKMAC_TXSTATS {} {
    	global  10GMAC_BASE_ADDR
    	global	rx_frame_addr0     		
    	global	rx_frame_addr1     		
    	global	rx_frame_maxlength  		
    	 
    	global	rx_frame_spaddr0_0  		
    	global	rx_frame_spaddr0_1  		
    	global	rx_frame_spaddr1_0  		
    	global	rx_frame_spaddr1_1  		
    	global	rx_frame_spaddr2_0  		
    	global	rx_frame_spaddr2_1  		
    	global	rx_frame_spaddr3_0  		
    	global	rx_frame_spaddr3_1  		

    	global	rx_padcrc_control     		
    	global 	RXFIFO_DROP_ON_ERROR                 
    	global 	XGMII_LLPBK                           

    	global 	tx_addrins_control    	
    	global 	tx_addrins_macaddr0    
    	global 	tx_addrins_macaddr1    
    	global 	10g_mac_tx_statistic_counters_reg_map    
    	global 	10g_mac_rx_statistic_counters_reg_map    
    	global 	LOGFILE    
    	 
    	 
    	 # _____________________________________________________________________
    	 # 	Statistics Registers
    	 # _____________________________________________________________________
    	global tframesOK_lo             	  
    	global tframesErr_lo            	  
    	global tframesCRCErr_lo         	  
    	global toctetsOK_lo             	  
    	global tpauseMACCtrlFrames_lo   	  
    	global tifErrors_lo             	  
    	global tunicastFramesOK_lo      	  
    	global tunicastFramesErr_lo     	  
    	global tmulticastFramesOK_lo    	  
    	global tmulticastFramesErr_lo   	  
    	global tbroadcastFramesOK_lo    	  
    	global tbroadcastFramesErr_lo   	  
    	global tetherStatsOctets_lo     	  
    	global tetherStatsPkts_lo       	  
    	global tetherStatsUndersizePkts_lo      
    	global tetherStatsOversizePkts_lo       
    	global tetherStatsPkts64Octets_lo       
    	global tetherStatsPkts65to127Octets_lo  
    	global tetherStatsPkts128to255Octets_lo 
    	global tetherStatsPkts256to511Octets_lo 
    	global tetherStatsPkts512to1023Octets_lo  
    	global tetherStatPkts1024to1518Octets_lo  
    	global tetherStatsPkts1519toXOctets_lo    
    	global tetherStatsFragments_lo            
    	global tetherStatsJabbers_lo              
    	global tetherStatsCRCErr_lo               
    	global tunicastMACCtrlFrames_lo           
    	global tmulticastMACCtrlFrames_lo         
    	global tbroadcastMACCtrlFrames_lo         

       	puts "\t		       ==================================================================="
	puts "\t			|  MAC TX STATS REGISTER CHECK					  "
       	puts "\t 		       ==================================================================="
  	puts "\t			|# FRAMES_RECEIVED_WITH_ERROR         	= [format %u [reg_read $10GMAC_BASE_ADDR $tframesErr_lo            	]]"
  	puts "\t			|# UNICAST_FRAMES_WITH_ERROR     	= [format %u [reg_read $10GMAC_BASE_ADDR $tunicastFramesErr_lo     	]]"
  	puts "\t			|# MULTICAST_FRAMES_RECEIVED_WITH_ERROR = [format %u [reg_read $10GMAC_BASE_ADDR $tmulticastFramesErr_lo   	]]"
  	puts "\t			|# BRDCAST_FRAMES_WITH_ERROR   		= [format %u [reg_read $10GMAC_BASE_ADDR $tbroadcastFramesErr_lo   	]]"
  	puts "\t			|# FRAMES_RECEIVED_WITH_ONLY_CRCERROR 	= [format %u [reg_read $10GMAC_BASE_ADDR $tframesCRCErr_lo         	]]"
  	puts "\t			|# VALID_LENGTH_FRAMES_WITH_CRC_ERROR   = [format %u [reg_read $10GMAC_BASE_ADDR $tetherStatsCRCErr_lo      ]]"
  	puts "\t			|# JABBER_FRAMES                	= [format %u [reg_read $10GMAC_BASE_ADDR $tetherStatsJabbers_lo     ]]"
  	puts "\t			|# FRAGMENTED_FRAMES                	= [format %u [reg_read $10GMAC_BASE_ADDR $tetherStatsFragments_lo   ]]"
  	puts "\t			|# INVALID_FRAMES_RECEIVED             	= [format %u [reg_read $10GMAC_BASE_ADDR $tifErrors_lo             	]]"

  	puts "\t			|# FRAMES_RECEIVED_GOOD	 		= [format %u [reg_read $10GMAC_BASE_ADDR $tframesOK_lo             	]]"
  	puts "\t			|# PAUSE_FRAMES_RECEIVED   		= [format %u [reg_read $10GMAC_BASE_ADDR $tpauseMACCtrlFrames_lo   	]]"
  	puts "\t			|# UNICAST_CONTROL_FRAMES              	= [format %u [reg_read $10GMAC_BASE_ADDR $tunicastMACCtrlFrames_lo  ]]"
  	puts "\t			|# MULTICAST_CONTROL_FRAMES            	= [format %u [reg_read $10GMAC_BASE_ADDR $tmulticastMACCtrlFrames_lo]]"
  	puts "\t			|# UNICAST_FRAMES_RECEIVED_GOOD   	= [format %u [reg_read $10GMAC_BASE_ADDR $tunicastFramesOK_lo      	]]"
  	puts "\t			|# MULTICAST_FRAMES_RECEIVED_GOOD 	= [format %u [reg_read $10GMAC_BASE_ADDR $tmulticastFramesOK_lo    	]]"
  	puts "\t			|# BRDCAST_FRAMES_GOOD    		= [format %u [reg_read $10GMAC_BASE_ADDR $tbroadcastFramesOK_lo    	]]"
  	puts "\t			|# DATA_AND_PADDING_OCTETS_RECEIVED_GOOD= [format %u [reg_read $10GMAC_BASE_ADDR $toctetsOK_lo      	]]"

  	puts "\t			|# COMPREHENSICE_OCTETS_RECEIVED       	= [format %u [reg_read $10GMAC_BASE_ADDR $tetherStatsOctets_lo     	]]"
  	puts "\t			|# FRAMES_WITH_SIZE_64_BYTES            = [format %u [reg_read $10GMAC_BASE_ADDR $tetherStatsPkts64Octets_lo]]"
  	puts "\t			|# FRAMES_BETWEEN_SIZE_64AND127_BYTES   = [format %u [reg_read $10GMAC_BASE_ADDR $tetherStatsPkts65to127Octets_lo  ]]"
  	puts "\t			|# FRAMES_BETWEEN_SIZE_128AND255_BYTES  = [format %u [reg_read $10GMAC_BASE_ADDR $tetherStatsPkts128to255Octets_lo ]]"
  	puts "\t			|# FRAMES_BETWEEN_SIZE_256AND511_BYTES  = [format %u [reg_read $10GMAC_BASE_ADDR $tetherStatsPkts256to511Octets_lo ]]"
  	puts "\t			|# FRAMES_BETWEEN_SIZE_512AND1K_BYTES   = [format %u [reg_read $10GMAC_BASE_ADDR $tetherStatsPkts512to1023Octets_lo]]"
  	puts "\t			|# FRAMES_BETWEEN_SIZE_1KND1518_BYTES   = [format %u [reg_read $10GMAC_BASE_ADDR $tetherStatPkts1024to1518Octets_lo]]"

   puts $LOGFILE "\t	       ==================================================================="
	puts $LOGFILE "\t		|  MAC TX STATS REGISTER CHECK					  "
   puts $LOGFILE "\t 	       ==================================================================="
  	puts $LOGFILE "\t		|# FRAMES_RECEIVED_WITH_ERROR         	= [format %u [reg_read $10GMAC_BASE_ADDR $tframesErr_lo            	]]"
  	puts $LOGFILE "\t		|# UNICAST_FRAMES_WITH_ERROR     	= [format %u [reg_read $10GMAC_BASE_ADDR $tunicastFramesErr_lo     	]]"
  	puts $LOGFILE "\t		|# MULTICAST_FRAMES_RECEIVED_WITH_ERROR = [format %u [reg_read $10GMAC_BASE_ADDR $tmulticastFramesErr_lo   	]]"
  	puts $LOGFILE "\t		|# BRDCAST_FRAMES_WITH_ERROR   		= [format %u [reg_read $10GMAC_BASE_ADDR $tbroadcastFramesErr_lo   	]]"
  	puts $LOGFILE "\t		|# FRAMES_RECEIVED_WITH_ONLY_CRCERROR 	= [format %u [reg_read $10GMAC_BASE_ADDR $tframesCRCErr_lo         	]]"
  	puts $LOGFILE "\t		|# VALID_LENGTH_FRAMES_WITH_CRC_ERROR   = [format %u [reg_read $10GMAC_BASE_ADDR $tetherStatsCRCErr_lo      ]]"
  	puts $LOGFILE "\t		|# JABBER_FRAMES                	= [format %u [reg_read $10GMAC_BASE_ADDR $tetherStatsJabbers_lo     ]]"
  	puts $LOGFILE "\t		|# FRAGMENTED_FRAMES                	= [format %u [reg_read $10GMAC_BASE_ADDR $tetherStatsFragments_lo   ]]"
  	puts $LOGFILE "\t		|# INVALID_FRAMES_RECEIVED             	= [format %u [reg_read $10GMAC_BASE_ADDR $tifErrors_lo             	]]"

  	puts $LOGFILE "\t		|# FRAMES_RECEIVED_GOOD	 		= [format %u [reg_read $10GMAC_BASE_ADDR $tframesOK_lo             	]]"
  	puts $LOGFILE "\t		|# PAUSE_FRAMES_RECEIVED   		= [format %u [reg_read $10GMAC_BASE_ADDR $tpauseMACCtrlFrames_lo   	]]"
  	puts $LOGFILE "\t		|# UNICAST_CONTROL_FRAMES              	= [format %u [reg_read $10GMAC_BASE_ADDR $tunicastMACCtrlFrames_lo  ]]"
  	puts $LOGFILE "\t		|# MULTICAST_CONTROL_FRAMES            	= [format %u [reg_read $10GMAC_BASE_ADDR $tmulticastMACCtrlFrames_lo]]"
  	puts $LOGFILE "\t		|# UNICAST_FRAMES_RECEIVED_GOOD   	= [format %u [reg_read $10GMAC_BASE_ADDR $tunicastFramesOK_lo      	]]"
  	puts $LOGFILE "\t		|# MULTICAST_FRAMES_RECEIVED_GOOD 	= [format %u [reg_read $10GMAC_BASE_ADDR $tmulticastFramesOK_lo    	]]"
  	puts $LOGFILE "\t		|# BRDCAST_FRAMES_GOOD    		= [format %u [reg_read $10GMAC_BASE_ADDR $tbroadcastFramesOK_lo    	]]"
  	puts $LOGFILE "\t		|# DATA_AND_PADDING_OCTETS_RECEIVED_GOOD= [format %u [reg_read $10GMAC_BASE_ADDR $toctetsOK_lo      	]]"

  	puts $LOGFILE "\t		|# COMPREHENSICE_OCTETS_RECEIVED       	= [format %u [reg_read $10GMAC_BASE_ADDR $tetherStatsOctets_lo     	]]"
  	puts $LOGFILE "\t		|# FRAMES_WITH_SIZE_64_BYTES            = [format %u [reg_read $10GMAC_BASE_ADDR $tetherStatsPkts64Octets_lo]]"
  	puts $LOGFILE "\t		|# FRAMES_BETWEEN_SIZE_64AND127_BYTES   = [format %u [reg_read $10GMAC_BASE_ADDR $tetherStatsPkts65to127Octets_lo  ]]"
  	puts $LOGFILE "\t		|# FRAMES_BETWEEN_SIZE_128AND255_BYTES  = [format %u [reg_read $10GMAC_BASE_ADDR $tetherStatsPkts128to255Octets_lo ]]"
  	puts $LOGFILE "\t		|# FRAMES_BETWEEN_SIZE_256AND511_BYTES  = [format %u [reg_read $10GMAC_BASE_ADDR $tetherStatsPkts256to511Octets_lo ]]"
  	puts $LOGFILE "\t		|# FRAMES_BETWEEN_SIZE_512AND1K_BYTES   = [format %u [reg_read $10GMAC_BASE_ADDR $tetherStatsPkts512to1023Octets_lo]]"
  	puts $LOGFILE "\t		|# FRAMES_BETWEEN_SIZE_1KND1518_BYTES   = [format %u [reg_read $10GMAC_BASE_ADDR $tetherStatPkts1024to1518Octets_lo]]"
     } 

   proc CHKMAC_CONFIG {} {
    global	10GMAC_BASE_ADDR
    global  10G_RX_FIFO_BASE_ADDR
    global  XGMII_LB_BASE_ADDR
    global  PHY_IP_BASE_ADDR
    global	rx_frame_addr0     		
    global	rx_frame_addr1     		
    global	rx_frame_maxlength  		
    
    global	rx_frame_spaddr0_0  		
    global	rx_frame_spaddr0_1  		
    global	rx_frame_spaddr1_0  		
    global	rx_frame_spaddr1_1  		
    global	rx_frame_spaddr2_0  		
    global	rx_frame_spaddr2_1  		
    global	rx_frame_spaddr3_0  		
    global	rx_frame_spaddr3_1  		

    global	rx_padcrc_control     		
    global 	RXFIFO_DROP_ON_ERROR                 
    global 	XGMII_LLPBK                           
    global 	phy_serial_loopback                           

    global 	tx_addrins_control    	
    global 	tx_addrins_macaddr0    
    global 	tx_addrins_macaddr1    
    global 	10g_mac_tx_statistic_counters_reg_map    
    global 	10g_mac_rx_statistic_counters_reg_map    
    global 	LOGFILE    
    
    ## _____________________________________________________________________
    ## 	Statistics Registers
    ## _____________________________________________________________________
    	global framesOK_lo             	  
    	global framesErr_lo            	  
    	global framesCRCErr_lo         	  
    	global octetsOK_lo             	  
    	global pauseMACCtrlFrames_lo   	  
    	global ifErrors_lo             	  
    	global unicastFramesOK_lo      	  
    	global unicastFramesErr_lo     	  
    	global multicastFramesOK_lo    	  
    	global multicastFramesErr_lo   	  
    	global broadcastFramesOK_lo    	  
    	global broadcastFramesErr_lo   	  
    	global etherStatsOctets_lo     	  
    	global etherStatsPkts_lo       	  
    	global etherStatsUndersizePkts_lo      
    	global etherStatsOversizePkts_lo       
    	global etherStatsPkts64Octets_lo       
    	global etherStatsPkts65to127Octets_lo  
    	global etherStatsPkts128to255Octets_lo 
    	global etherStatsPkts256to511Octets_lo 
    	global etherStatsPkts512to1023Octets_lo  
    	global etherStatPkts1024to1518Octets_lo  
    	global etherStatsPkts1519toXOctets_lo    
    	global etherStatsFragments_lo            
    	global etherStatsJabbers_lo              
    	global etherStatsCRCErr_lo               
    	global unicastMACCtrlFrames_lo           
    	global multicastMACCtrlFrames_lo         
    	global broadcastMACCtrlFrames_lo         

      puts "\t 		  =========================================================================="
    	puts "\t 			| MAC CONFIGURATION DUMP 					      "
      puts "\t 		  ==========================================================================="
    	puts "\t 			| RX PAD/CRC SRIPPING		= [reg_read 10GMAC_BASE_ADDR $rx_padcrc_control]"
    	puts "\t 			| RX FIFO DROP ON ERROR 	= [reg_read $10G_RX_FIFO_BASE_ADDR $RXFIFO_DROP_ON_ERROR]"
    	puts "\t 			| LOCAL LOOPBACK @ XGMII	= [reg_read $XGMII_LB_BASE_ADDR $XGMII_LLPBK]"
    	puts "\t 			| LOCAL LOOPBACK @ PMA		= [reg_read $PHY_IP_BASE_ADDR $phy_serial_loopback]"
    	puts "\t 			| MAC TX SADDR INSERTION CTRL 	= [reg_read 10GMAC_BASE_ADDR $tx_addrins_control]"
    	puts "\t 			| PRIMARY MAC ADDRESS-1		= [reg_read 10GMAC_BASE_ADDR $rx_frame_addr1] "
    	puts "\t 			| PRIMARY MAC ADDRESS-0		= [reg_read 10GMAC_BASE_ADDR $rx_frame_addr0] "
    	puts "\t 			| MAX FRAME LENGTH 		= [reg_read 10GMAC_BASE_ADDR $rx_frame_maxlength] "
    	puts "\t 			| SUPPLIMENTARY ADDRESS-0 	= [reg_read 10GMAC_BASE_ADDR $rx_frame_spaddr0_1]"
    	puts "\t 			| 		            	  [reg_read 10GMAC_BASE_ADDR $rx_frame_spaddr0_0]"
    	puts "\t 			| SUPPLIMENTARY ADDRESS-1	= [reg_read 10GMAC_BASE_ADDR $rx_frame_spaddr1_1]"
    	puts "\t 			| 			    	  [reg_read 10GMAC_BASE_ADDR $rx_frame_spaddr1_0]"
    	puts "\t 			| SUPPLIMENTARY ADDRESS-2	= [reg_read 10GMAC_BASE_ADDR $rx_frame_spaddr2_1]"
    	puts "\t 			| 			    	  [reg_read 10GMAC_BASE_ADDR $rx_frame_spaddr2_0]"
    	puts "\t 			| SUPPLIMENTARY ADDRESS-3	= [reg_read 10GMAC_BASE_ADDR $rx_frame_spaddr3_1]"
    	puts "\t 			| 			    	  [reg_read 10GMAC_BASE_ADDR $rx_frame_spaddr3_0]"
    	puts "\t 			| TX MAC SOURCE ADDRESS  	= [reg_read 10GMAC_BASE_ADDR $tx_addrins_macaddr1]"
    	puts "\t					  	    	  [reg_read 10GMAC_BASE_ADDR $tx_addrins_macaddr0]"

      puts $LOGFILE "\t 	  =========================================================================="
    	puts $LOGFILE "\t 		| MAC CONFIGURATION DUMP 					      "
      puts $LOGFILE "\t 	  ==========================================================================="
    	puts $LOGFILE "\t 		| RX PAD/CRC SRIPPING		= [reg_read 10GMAC_BASE_ADDR $rx_padcrc_control]"
    	puts $LOGFILE "\t 		| RX FIFO DROP ON ERROR 	= [reg_read $10G_RX_FIFO_BASE_ADDR $RXFIFO_DROP_ON_ERROR]"
    	puts $LOGFILE "\t 		| LOCAL LOOPBACK @ XGMII	= [reg_read $XGMII_LB_BASE_ADDR $XGMII_LLPBK]"
    	puts $LOGFILE "\t 		| LOCAL LOOPBACK @ PMA		= [reg_read $PHY_IP_BASE_ADDR $phy_serial_loopback]"
    	puts $LOGFILE "\t 		| MAC TX SADDR INSERTION CTRL 	= [reg_read 10GMAC_BASE_ADDR $tx_addrins_control]"
    	puts $LOGFILE "\t 		| PRIMARY MAC ADDRESS-1		= [reg_read 10GMAC_BASE_ADDR $rx_frame_addr1] "
    	puts $LOGFILE "\t 		| PRIMARY MAC ADDRESS-0		= [reg_read 10GMAC_BASE_ADDR $rx_frame_addr0] "
    	puts $LOGFILE "\t 		| MAX FRAME LENGTH 		= [reg_read 10GMAC_BASE_ADDR $rx_frame_maxlength] "
    	puts $LOGFILE "\t 		| SUPPLIMENTARY ADDRESS-0 	= [reg_read 10GMAC_BASE_ADDR $rx_frame_spaddr0_1]"
    	puts $LOGFILE "\t 		| 		            	  [reg_read 10GMAC_BASE_ADDR $rx_frame_spaddr0_0]"
    	puts $LOGFILE "\t 		| SUPPLIMENTARY ADDRESS-1	= [reg_read 10GMAC_BASE_ADDR $rx_frame_spaddr1_1]"
    	puts $LOGFILE "\t 		| 			    	  [reg_read 10GMAC_BASE_ADDR $rx_frame_spaddr1_0]"
    	puts $LOGFILE "\t 		| SUPPLIMENTARY ADDRESS-2	= [reg_read 10GMAC_BASE_ADDR $rx_frame_spaddr2_1]"
    	puts $LOGFILE "\t 		| 			    	  [reg_read 10GMAC_BASE_ADDR $rx_frame_spaddr2_0]"
    	puts $LOGFILE "\t 		| SUPPLIMENTARY ADDRESS-3	= [reg_read 10GMAC_BASE_ADDR $rx_frame_spaddr3_1]"
    	puts $LOGFILE "\t 		| 			    	  [reg_read 10GMAC_BASE_ADDR $rx_frame_spaddr3_0]"
    	puts $LOGFILE "\t 		| TX MAC SOURCE ADDRESS  	= [reg_read 10GMAC_BASE_ADDR $tx_addrins_macaddr1]"
   }


   proc PROCESS_MAC {} {
     CHKMAC_CONFIG
     CHKMAC_TXSTATS
     CHKMAC_RXSTATS

   }
	
   proc CONFIG_TSU {} {
        
	global 10GMAC_BASE_ADDR

    global rx_10g_period_addr                   
	 global rx_10g_adjust_fns_addr                   
	 global rx_10g_adjust_ns_addr                    

	 global rx_1g_period_addr                         
	 global rx_1g_adjust_fns_addr                    
	 global rx_1g_adjust_ns_addr
	 
	 global tx_10g_period_addr                   
	 global tx_10g_adjust_fns_addr                   
	 global tx_10g_adjust_ns_addr                    

	 global tx_1g_period_addr                         
	 global tx_1g_adjust_fns_addr                    
	 global tx_1g_adjust_ns_addr
	 
	 
    global TSU_10G_PERIOD_FNS_BIT
    global TSU_1G_PERIOD_FNS_BIT

	 global RX_ADJUST_10G_NSECOND    	 
	 global RX_ADJUST_10G_FNSECOND     
    global RX_ADJUST_1G_NSECOND     	 
    global RX_ADJUST_1G_FNSECOND   	
	 
	 global TX_ADJUST_10G_NSECOND    	 
	 global TX_ADJUST_10G_FNSECOND     
    global TX_ADJUST_1G_NSECOND     	 
    global TX_ADJUST_1G_FNSECOND   	
	 
	 
	 set PERIOD_1G_NSECOND     	 0x8
	 set PERIOD_1G_FNSECOND    	 0x0000
	 set PERIOD_10G_NSECOND    	 0x6
    set PERIOD_10G_FNSECOND   	 0x6666
	
    # TX XGMII TSU & RX XGMII TSU
     puts "\t		Configure Period and Adjustment RX XGMII TSU"
     reg_write $10GMAC_BASE_ADDR $rx_10g_period_addr 0x66666
	  reg_write $10GMAC_BASE_ADDR $rx_10g_adjust_fns_addr $RX_ADJUST_10G_FNSECOND
     reg_write $10GMAC_BASE_ADDR $rx_10g_adjust_ns_addr  $RX_ADJUST_10G_NSECOND 
	  
	  puts "\t		Configure Period and Adjustment TX XGMII TSU"
     reg_write $10GMAC_BASE_ADDR $tx_10g_period_addr 0x66666
	  reg_write $10GMAC_BASE_ADDR $tx_10g_adjust_fns_addr $TX_ADJUST_10G_FNSECOND
     reg_write $10GMAC_BASE_ADDR $tx_10g_adjust_ns_addr  $TX_ADJUST_10G_NSECOND 
        
	 
	 # TX GMII TSU & RX GMII TSU
     puts "\t		Configure Period and Adjustment RX GMII TSU"
     reg_write $10GMAC_BASE_ADDR $rx_1g_period_addr 0x80000
	  reg_write $10GMAC_BASE_ADDR $rx_1g_adjust_fns_addr $RX_ADJUST_1G_FNSECOND
     reg_write $10GMAC_BASE_ADDR $rx_1g_adjust_ns_addr  $RX_ADJUST_1G_NSECOND 
	  
	  puts "\t		Configure Period and Adjustment TX GMII TSU"
     reg_write $10GMAC_BASE_ADDR $tx_1g_period_addr 0x80000
	  reg_write $10GMAC_BASE_ADDR $tx_1g_adjust_fns_addr $TX_ADJUST_1G_FNSECOND
     reg_write $10GMAC_BASE_ADDR $tx_1g_adjust_ns_addr  $TX_ADJUST_1G_NSECOND 
 }
