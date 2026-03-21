// (C) 2001-2018 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.




`ifndef ETH_REGISTER_MAP_PARAMS_PKG__SV
`define ETH_REGISTER_MAP_PARAMS_PKG__SV

// Package defines address of registers
package eth_register_map_params_pkg;

    parameter CHANNEL_START_ADDR											 = 32'h20000;
	 // ******************************************************************************************
    // MAC Base Address Offset
    // ******************************************************************************************
    parameter MAC_0_ADDR                                        = 32'h08000;
   
	 parameter	RX_FIFO_0_ADDR												 = 32'h7600;
    parameter	TX_FIFO_0_ADDR												 = 32'h7700;
	 parameter RX_FIFO_DROP_ON_ERROR_OFFSET					 		 = 32'h0014;
    // ******************************************************************************************
    // Register Address of MAC
    // ******************************************************************************************
    // Control register for CRC insertion on TX path
    parameter TX_CRC_INSERT_CONTROL_ADDR                        = 32'h4200;
    
    // Control register for source address insertion on TX path
    parameter TX_ADDRESS_INSERT_CONTROL_ADDR                    = 32'h4800;
    
    // Unicast address for source address insertion on TX path
    parameter TX_ADDRESS_INSERT_UCAST_MAC_ADD_0_ADDR            = 32'h4804;
    parameter TX_ADDRESS_INSERT_UCAST_MAC_ADD_1_ADDR            = 32'h4808;
    
    // RX uses the primary MAC address to filter unicast frames when the en_allucast bit of the rx_frame_control register is set to 0.
    parameter RX_FRAME_0_ADDR                                   = 32'h2008;
    parameter RX_FRAME_1_ADDR                                   = 32'h200c;
    
    // Base address for statistics
    parameter RX_STATISTICS_ADDR                                = 32'h3000;
    parameter TX_STATISTICS_ADDR                                = 32'h7000;
    
    // Base address for RX FIFO
    //parameter RX_FIFO_DROP_ON_ERROR_ADDR                        = 32'h10414;  
    
    // Base address for XGMII TSU
    parameter RX_10G_PERIOD_ADDR                                = 32'h0440;  
    parameter RX_10G_ADJUST_FNS_ADDR                            = 32'h0448;
    parameter RX_10G_ADJUST_NS_ADDR                             = 32'h044C;
    
    parameter TX_10G_PERIOD_ADDR                                = 32'h4440;
    parameter TX_10G_ADJUST_FNS_ADDR                            = 32'h4448;
    parameter TX_10G_ADJUST_NS_ADDR                             = 32'h444C;
    
    // Base address for GMII TSU
    parameter RX_1G_PERIOD_ADDR                                 = 32'h0460;
    parameter RX_1G_ADJUST_FNS_ADDR                             = 32'h0468;
    parameter RX_1G_ADJUST_NS_ADDR                              = 32'h046C;
    
    parameter TX_1G_PERIOD_ADDR                                 = 32'h4460;
    parameter TX_1G_ADJUST_FNS_ADDR                             = 32'h4468;
    parameter TX_1G_ADJUST_NS_ADDR                              = 32'h446C;	

    // Base address for RX Frame Decoder
    parameter RX_FRAME_CONTROL_ADDR                             = 32'h2000;
    
    // Register of Pad Inserter
	parameter TX_PADINS_CONTROL				                    = 32'h4100;
    
    // Enable/Disable RX Path
    parameter RX_TRANSFER_CONTROL_ADDR                          = 32'h0000;
    
    // Register Of Pause Frame Gen
    parameter TX_PAUSEFRAME_CONTROL			                    = 32'h4500;
	parameter TX_PAUSEFRAME_QUANTA			                    = 32'h4504;
	parameter TX_PAUSEFRAME_ENABLE			                    = 32'h4508;

    // Programmable PIPG (New in LLC MAC)
    parameter TX_ETH_PIPG_10G_ADDR                              = 32'h2078;
    parameter TX_ETH_PIPG_1G_ADDR                               = 32'h207C;
    
    // ******************************************************************************************
    // Registers Offset of MAC
    // ******************************************************************************************
    // ------------------------------------------------------------------------------------------
    // Statistics
    // ------------------------------------------------------------------------------------------
    parameter STATISTICS_framesOK_OFFSET                        = 32'h008;
    parameter STATISTICS_framesErr_OFFSET                       = 32'h010;
    parameter STATISTICS_framesCRCErr_OFFSET                    = 32'h018;
    parameter STATISTICS_octetsOK_OFFSET                        = 32'h020;
    parameter STATISTICS_pauseMACCtrlFrames_OFFSET              = 32'h028;
    parameter STATISTICS_ifErrors_OFFSET                        = 32'h030;
    parameter STATISTICS_unicastFramesOK_OFFSET                 = 32'h038;
    parameter STATISTICS_unicastFramesErr_OFFSET                = 32'h040;
    parameter STATISTICS_multicastFramesOK_OFFSET               = 32'h048;
    parameter STATISTICS_multicastFramesErr_OFFSET              = 32'h050;
    parameter STATISTICS_broadcastFramesOK_OFFSET               = 32'h058;
    parameter STATISTICS_broadcastFramesErr_OFFSET              = 32'h060;
    parameter STATISTICS_etherStatsOctets_OFFSET                = 32'h068;
    parameter STATISTICS_etherStatsPkts_OFFSET                  = 32'h070;
    parameter STATISTICS_etherStatsUndersizePkts_OFFSET         = 32'h078;
    parameter STATISTICS_etherStatsOversizePkts_OFFSET          = 32'h080;
    parameter STATISTICS_etherStatsPkts64Octets_OFFSET          = 32'h088;
    parameter STATISTICS_etherStatsPkts65to127Octets_OFFSET     = 32'h090;
    parameter STATISTICS_etherStatsPkts128to255Octets_OFFSET    = 32'h098;
    parameter STATISTICS_etherStatsPkts256to511Octets_OFFSET    = 32'h0A0;
    parameter STATISTICS_etherStatsPkts512to1023Octets_OFFSET   = 32'h0A8;
    parameter STATISTICS_etherStatPkts1024to1518Octets_OFFSET   = 32'h0B0;
    parameter STATISTICS_etherStatsPkts1519toXOctets_OFFSET     = 32'h0B8;
    parameter STATISTICS_etherStatsFragments_OFFSET             = 32'h0C0;
    parameter STATISTICS_etherStatsJabbers_OFFSET               = 32'h0C8;
    parameter STATISTICS_etherStatsCRCErr_OFFSET                = 32'h0D0;
    parameter STATISTICS_unicastMACCtrlFrames_OFFSET            = 32'h0D8;
    parameter STATISTICS_multicastMACCtrlFrames_OFFSET          = 32'h0E0;
    parameter STATISTICS_broadcastMACCtrlFrames_OFFSET          = 32'h0E8;
    
    // ------------------------------------------------------------------------------------------
    // TSU Register Offset
    // ------------------------------------------------------------------------------------------
    parameter TSU_10G_PERIOD_FNS_OFFSET     = 0;
    parameter TSU_10G_PERIOD_NS_OFFSET      = 16;
    
    parameter TSU_10G_ADJUST_FNS_OFFSET     = 0;
    parameter TSU_10G_ADJUST_NS_OFFSET      = 0;
    
    parameter TSU_1G_PERIOD_FNS_OFFSET      = 0;
    parameter TSU_1G_PERIOD_NS_OFFSET       = 16;
    
    parameter TSU_1G_ADJUST_FNS_OFFSET      = 0;
    parameter TSU_1G_ADJUST_NS_OFFSET       = 0;
    
	
	
    //nga need to edit
    
    //***********************************************************************************************
	// Time-of-Day 81000 81100
	//***********************************************************************************************
	 parameter TOD_MASTER_ADDR	     = 32'h10000;
	 parameter TOD_0_10G_ADDR		  = 32'h7800;
	 parameter TOD_0_1G_ADDR		  = 32'h7900;
	 
	 parameter TOD_SECOND_H         = 32'h000;
    parameter TOD_SECOND_L         = 32'h004;
    parameter TOD_NANOSECOND       = 32'h008;
    parameter TOD_PERIOD           = 32'h010;
    parameter TOD_ADJUSTPERIOD     = 32'h014;
    parameter TOD_DJUSTCOUNT       = 32'h018;
    
 
    
    //***********************************************************************************************
    // 10GBASE-KR PHY
    //***********************************************************************************************
    parameter PHY_0_ADDR                    = 32'h4000;

    
    parameter PHY_GIGE_PCS_REG_ADDR         = 32'h1240;	
    parameter PHY_GIGE_PCS_AN_OFFSET        = 0;
    parameter PHY_GIGE_PCS_IF_MODE_ADDR     = 32'h1290;
 
	 parameter RECONFIG_SPEED_ADDR           = 32'h12C0;
    
endpackage

`endif
