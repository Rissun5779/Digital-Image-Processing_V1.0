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


# 10G base KR
## SEQ, AN and LT
set seq_control 							0x12C0
set RESET_SEQ_BIT 						0
set DISABLE_AN_TIMER_BIT 				1
set DSIABLE_LF_TIMER_BIT 				2
set SEG_FORCE_MODE_BIT 					4

set seq_status 							0x12C4
set SEQ_LINK_READY_BIT 					0

#start for KR only
set SEQ_AN_TIMEOUT_BIT 					1  

set an_control 							0x1300
set AN_ENABLE_BIT 						0
set AN_BASE_PAGES_CTRL_BIT 			1
set AN_NEXT_PAGES_CTRL_BIT 			2
set LOCAL_DEVICE_REMOTE_FAULT_BIT 	3

set an_control_expand					0x1304
set RESET_AN_BIT 							0
set RESTART_AN_TX_SM_BIT 				4
set AN_NEXT_PAGE_BIT 					8

set an_status								0x1308
set AN_PAGE_RECEIVED_BIT 				1
set AN_COMPLETE_BIT 						2
set AN_ADV_REMOTE_FAULT_BIT 			3
set AN_RX_SM_IDLE_BIT 					4
set AN_ABILITY_BIT 						5
set AN_STATUS_BIT 						6
set LP_AN_ABILITY_BIT 					7
set SEQ_AN_FAILURE_BIT					9
set KR_AN_LINK_READY_BIT 				12

set lt_setting								0x1354
set LT_VOD_SETTING_BIT 					0
set LT_POST_TAP_SETTING 				8
set LT_PRE_TAP_SETTING 					16

set pma_setting							0x1358


#end for KR

### 10G PCS
set indirect_addr							0x1200

set rclr_error_count						0x1204
set RCLR_ERRBLK_CNT_BIT					2
set RCLR_BER_COUNT_BIT					3

set pcs_status_reg						0x1208
set HI_BER_BIT								1
set BLOCK_LOCK_BIT						2
set TX_FIFO_FULL_BIT 					3
set RX_FIFO_FULL_BIT 					4
set RX_SYNC_HEAD_ERROR_BIT 			5
set RX_SCRAMBLER_ERROR_BIT 			6
set RX_DATA_READY_BIT					7

## start for 1GPCS only

set 1g_pcs_control 					0x1240
set RESTART_AUTO_NEGOTIATION_BIT		9
set AUTONEGOTIATION_ENABLE_BIT		12
set RESET									15


set 1g_pcs_status						0x1244
set LINK_STATUS_BIT 						2			
set AUTO_NEGOTIATION_ABILITY_BIT  	3
set AUTO_NEGOTIATION_COMPLETE_BIT 	5

set 1g_pcs_dev_ability				0x1248
set FD										5
set HD										6
set PS1										7
set PS2										8
set RF1										12
set RF2										13
set ACK										14
set NP										15

#AN_EXPANSION REG
set 1g_pcs_an_expand					0x124C
set LINK_PARTNER_AUTO_NEGOTIATION_ABLE		0
set PAGE_RECEIVE									1



set 1g_pcs_if_mode					0x1290
###end for 1g PCS only


#### PMA REgister
## from/to xcvr reset controller

set pma_tx_pll_is_locked				0x1088
set reset_analog_digital				0x1110
set phy_serial_loopback					0x1184
set pma_rx_set_locktodata				0x1190
set pma_rx_set_locktoref				0x1194
set pma_rx_is_locktodata				0x1198
set pma_rx_is_locktoref					0x119C

set RESET_TX_DIGITAL_BIT				1
set RESET_RX_ANALOG_BIT    			2
set RESET_RX_DIGITAL_BIT				3

## tx/rx serial data if

set pma_electrical_setting				0x12A0
set TX_INVPOLARITY_BIT					0
set RX_INVPOLARITY_BIT					1
set RX_BITREVERSAL_ENABLE_BIT 		2
set RX_BYTEREVERSAL_ENABLE_BIT		3
set FORCE_ELECTRICAL_IDLE_BIT 		4

set pma_status_reg						0x12A4
set RX_SYNSTATUS_BIT						0
set RX_PATTERNDETECT_BIT				1
set RX_RLV_BIT								2
set RX_RMFIFODATAINSERTED_BIT 		3
set RX_RMFIFODATADELETED_BIT 			4
set RX_DISPERR_BIT						5
set RX_ERRDETECT_BIT 					6
