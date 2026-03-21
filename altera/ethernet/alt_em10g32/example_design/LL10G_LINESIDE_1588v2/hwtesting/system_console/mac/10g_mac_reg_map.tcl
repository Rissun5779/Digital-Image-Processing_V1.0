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


#==============================================================================
#                       MAC Register Address Map                
#==============================================================================
# RX path
set 10g_mac_rx_packet_transfer_reg_map		0x00000000
set 10g_mac_rx_pad_crc_remover_reg_map		0x00000100
set 10g_mac_rx_crc_checker_reg_map			0x00000200
set 10g_mac_rx_packet_overflow_reg_map		0x00000300
set 10g_mac_rx_preamble_control_reg_map	0x00000400
set 10g_mac_rx_lane_decoder_reg_map			0x00000500
set 10g_mac_rx_frame_decoder_reg_map		0x00002000
##set 10g_mac_rx_statistic_counters_reg_map	0x00003000

# TX path
set 	10g_mac_tx_packet_transfer_reg_map		0x00004000
set	10g_mac_tx_pad_inserter_reg_map			0x00004100
set	10g_mac_tx_crc_inserter_reg_map			0x00004200
set	10g_mac_tx_packet_underflow_reg_map		0x00004300
set	10g_mac_tx_preamble_control_reg_map		0x00004400
set	10g_mac_tx_pause_frm_ctrl_gen_reg_map	0x00004500
set	10g_mac_tx_pfc_gen_reg_map				0x00004600
set	10g_mac_tx_address_inserter_reg_map		0x00004800
set	10g_mac_tx_frame_decoder_reg_map		0x00006000
##set	10g_mac_tx_statistic_counters_reg_map	0x00007000

#==============================================================================
#		MAC registers Offset
#==============================================================================
  


# RX Packet Transfer
set	rx_transfer_control						0x0000
set	rx_transfer_status						0x0004

set XGMII_LLPBK                           0x08                                			

# RX Pad/CRC Remover            			
set rx_padcrc_control						0x0100
                                			
# RX CRC Checker                			
set	rx_crccheck_control					0x0200
                                			
# RX Packet Overflow            			
set rx_pktovrflow_error_lo					0x0300
set rx_pktovrflow_error_hi					0x0304
set rx_pktovrflow_etherStatsDropEvents_lo	0x0308
set rx_pktovrflow_etherStatsDropEvents_hi	0x030C

# RX Preamble Control
set rx_preamble_inserter_control			0x0400

# RX Lane Decoder
set rx_lane_decoder_preamble_control	0x0500

# RX Frame Decoder
set rx_frame_control							0x2000
set rx_frame_maxlength						0x2004
set rx_frame_addr0							0x2008
set rx_frame_addr1							0x200C
                                    		
set rx_frame_spaddr0_0						0x2010
set rx_frame_spaddr0_1						0x2014
set rx_frame_spaddr1_0						0x2018
set rx_frame_spaddr1_1						0x201C
set rx_frame_spaddr2_0						0x2020
set rx_frame_spaddr2_1						0x2024
set rx_frame_spaddr3_0						0x2028
set rx_frame_spaddr3_1						0x202C
                                    		
set rx_pfc_control							0x2060

# TX Packet Transfer
set tx_transfer_control						0x4000
set tx_transfer_status						0x4004
                                    		
# TX Pad Inserter                   		
set tx_padins_control						0x4100
                                    		
# TX CRC Inserter                   		
set tx_crcins_control						0x4200
                                    		
# TX Packet Underflow               		
set tx_pktunderflow_error_lo				0x4300
set tx_pktunderflow_error_hi				0x4304
                                    		
# TX Preamble Control               		
set tx_preamble_control						0x4400
                                    		
# TX Pause Frame Control and Generator
set tx_pauseframe_control					0x4500
set tx_pauseframe_quanta					0x4504
set tx_pauseframe_enable					0x4508
                                    		
# TX PFC Generator                  		
set pfc_pause_quanta_0						0x4600
set pfc_pause_quanta_1						0x4604
set pfc_pause_quanta_2						0x4608
set pfc_pause_quanta_3						0x460C
set pfc_pause_quanta_4						0x4610
set pfc_pause_quanta_5						0x4614
set pfc_pause_quanta_6						0x4618
set pfc_pause_quanta_7						0x461C
                                    		
set pfc_holdoff_quanta_0					0x4640
set pfc_holdoff_quanta_1					0x4644
set pfc_holdoff_quanta_2					0x4648
set pfc_holdoff_quanta_3					0x464C
set pfc_holdoff_quanta_4					0x4650
set pfc_holdoff_quanta_5					0x4654
set pfc_holdoff_quanta_6					0x4658
set pfc_holdoff_quanta_7					0x465C
                                    		
set tx_pfc_priority_enable					0x4680
                                    		
# TX Address Inserter               		
set tx_addrins_control						0x4800
set tx_addrins_macaddr0						0x4804
set tx_addrins_macaddr1						0x4808
                                    		
# TX Frame Decoder                  		
set tx_frame_maxlength						0x6004


##EDMOND-TX STATS
# 64-bits Statistic Counter High & Low Byte (Reg Map: 10g_mac_rx_statistic_counters_reg_map & 10g_mac_tx_statistic_counters_reg_map)
set tClearStats             					0x7000
set tframesOK_lo            					0x7008
set tframesOK_hi									0x700C
set tframesErr_lo           					0x7010
set tframesErr_hi									0x7014
set tframesCRCErr_lo        					0x7018
set tframesCRCErr_hi								0x701C
set toctetsOK_lo            					0x7020
set toctetsOK_hi            					0x7024
set tpauseMACCtrlFrames_lo  					0x7028
set tpauseMACCtrlFrames_hi  					0x702C 
set tifErrors_lo            					0x7030
set tifErrors_hi            					0x7034
set tunicastFramesOK_lo     					0x7038
set tunicastFramesOK_hi     					0x703C
set tunicastFramesErr_lo    					0x7040
set tunicastFramesErr_hi    					0x7044
set tmulticastFramesOK_lo   					0x7048
set tmulticastFramesOK_hi   					0x704C
set tmulticastFramesErr_lo  					0x7050
set tmulticastFramesErr_hi  					0x7054
set tbroadcastFramesOK_lo   					0x7058
set tbroadcastFramesOK_hi   					0x705C
set tbroadcastFramesErr_lo  					0x7060
set tbroadcastFramesErr_hi  					0x7064
set tetherStatsOctets_lo    					0x7068
set tetherStatsOctets_hi    					0x706C
set tetherStatsPkts_lo      					0x7070
set tetherStatsPkts_hi      					0x7074
set tetherStatsUndersizePkts_lo         		0x7078
set tetherStatsUndersizePkts_hi         		0x707C
set tetherStatsOversizePkts_lo          		0x7080
set tetherStatsOversizePkts_hi          		0x7084
set tetherStatsPkts64Octets_lo          		0x7088
set tetherStatsPkts64Octets_hi          		0x708C
set tetherStatsPkts65to127Octets_lo     		0x7090
set tetherStatsPkts65to127Octets_hi     		0x7094
set tetherStatsPkts128to255Octets_lo    		0x7098
set tetherStatsPkts128to255Octets_hi    		0x709C
set tetherStatsPkts256to511Octets_lo    		0x70A0
set tetherStatsPkts256to511Octets_hi    		0x70A4
set tetherStatsPkts512to1023Octets_lo   		0x70A8
set tetherStatsPkts512to1023Octets_hi   		0x70AC
set tetherStatPkts1024to1518Octets_lo   		0x70B0
set tetherStatPkts1024to1518Octets_hi   		0x70B4
set tetherStatsPkts1519toXOctets_lo     		0x70B8
set tetherStatsPkts1519toXOctets_hi     		0x70Bc
set tetherStatsFragments_lo             		0x70C0
set tetherStatsFragments_hi             		0x70C4
set tetherStatsJabbers_lo               		0x70C8
set tetherStatsJabbers_hi               		0x70CC
set tetherStatsCRCErr_lo                		0x70D0
set tetherStatsCRCErr_hi                		0x70D4
set tunicastMACCtrlFrames_lo            		0x70D8
set tunicastMACCtrlFrames_hi            		0x70DC
set tmulticastMACCtrlFrames_lo          		0x70E0
set tmulticastMACCtrlFrames_hi          		0x70E4
set tbroadcastMACCtrlFrames_lo          		0x70E8
set tbroadcastMACCtrlFrames_hi          		0x70EC

###EDMOND-RX STATs

set ClearStats             					0x3000
set framesOK_lo            					0x3008
set framesOK_hi								0x300C
set framesErr_lo           					0x3010
set framesErr_hi							0x3014
set framesCRCErr_lo        					0x3018
set framesCRCErr_hi							0x301C
set octetsOK_lo            					0x3020
set octetsOK_hi            					0x3024
set pauseMACCtrlFrames_lo  					0x3028
set pauseMACCtrlFrames_hi  					0x302C 
set ifErrors_lo            					0x3030
set ifErrors_hi            					0x3034
set unicastFramesOK_lo     					0x3038
set unicastFramesOK_hi     					0x303C
set unicastFramesErr_lo    					0x3040
set unicastFramesErr_hi    					0x3044
set multicastFramesOK_lo   					0x3048
set multicastFramesOK_hi   					0x304C
set multicastFramesErr_lo  					0x3050
set multicastFramesErr_hi  					0x3054
set broadcastFramesOK_lo   					0x3058
set broadcastFramesOK_hi   					0x305C
set broadcastFramesErr_lo  					0x3060
set broadcastFramesErr_hi  					0x3064
set etherStatsOctets_lo    					0x3068
set etherStatsOctets_hi    					0x306C
set etherStatsPkts_lo      					0x3070
set etherStatsPkts_hi      					0x3074
set etherStatsUndersizePkts_lo         		0x3078
set etherStatsUndersizePkts_hi         		0x307C
set etherStatsOversizePkts_lo          		0x3080
set etherStatsOversizePkts_hi          		0x3084
set etherStatsPkts64Octets_lo          		0x3088
set etherStatsPkts64Octets_hi          		0x308C
set etherStatsPkts65to127Octets_lo     		0x3090
set etherStatsPkts65to127Octets_hi     		0x3094
set etherStatsPkts128to255Octets_lo    		0x3098
set etherStatsPkts128to255Octets_hi    		0x309C
set etherStatsPkts256to511Octets_lo    		0x30A0
set etherStatsPkts256to511Octets_hi    		0x30A4
set etherStatsPkts512to1023Octets_lo   		0x30A8
set etherStatsPkts512to1023Octets_hi   		0x30AC
set etherStatPkts1024to1518Octets_lo   		0x30B0
set etherStatPkts1024to1518Octets_hi   		0x30B4
set etherStatsPkts1519toXOctets_lo     		0x30B8
set etherStatsPkts1519toXOctets_hi     		0x30Bc
set etherStatsFragments_lo             		0x30C0
set etherStatsFragments_hi             		0x30C4
set etherStatsJabbers_lo               		0x30C8
set etherStatsJabbers_hi               		0x30CC
set etherStatsCRCErr_lo                		0x30D0
set etherStatsCRCErr_hi                		0x30D4
set unicastMACCtrlFrames_lo            		0x30D8
set unicastMACCtrlFrames_hi            		0x30DC
set multicastMACCtrlFrames_lo          		0x30E0
set multicastMACCtrlFrames_hi          		0x30E4
set broadcastMACCtrlFrames_lo          		0x30E8
set broadcastMACCtrlFrames_hi          		0x30EC



#TSU 1588    
# Base address for XGMII TSU

set rx_10g_period_addr                           0x0440;  
set rx_10g_adjust_fns_addr                       0x0448;
set rx_10g_adjust_ns_addr                        0x044c;

set rx_1g_period_addr                           0x0460;  
set rx_1g_adjust_fns_addr                       0x0468;
set rx_1g_adjust_ns_addr                        0x046c;   


set tx_10g_period_addr                           0x4440;  
set tx_10g_adjust_fns_addr                       0x4448;
set tx_10g_adjust_ns_addr                        0x444c;

set tx_1g_period_addr                           0x4460;  
set tx_1g_adjust_fns_addr                       0x4468;
set tx_1g_adjust_ns_addr                        0x446c;  


set TSU_10G_PERIOD_FNS_BIT      					0
set TSU_10G_PERIOD_NS_BIT      					16
    

set TSU_1G_PERIOD_FNS_BIT     					0
set TSU_1G_PERIOD_NS_BIT       	 				16
    

    