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


// (C) 2001-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


`ifndef ETH_REGISTER_MAP_PARAMS_PKG__SV
`define ETH_REGISTER_MAP_PARAMS_PKG__SV

// Package defines address of registers
package eth_register_map_params_pkg;
    
    // ******************************************************************************************
    // Base Address (As specified by address decoder) - Byte Addressing / 4
    // ******************************************************************************************
    parameter RD_MGE_RECONFIG_ADDR                              = 32'h00000 / 4;
    parameter RD_CHANNEL_0_BASE_ADDR                            = 32'h10000 / 4;
    parameter RD_CHANNEL_N_OFFSET                               = 32'h10000 / 4;
    parameter RD_CHANNEL_MAC_OFFSET                             = 32'h00000 / 4;
    parameter RD_CHANNEL_PHY_OFFSET                             = 32'h08000 / 4;
    
    // ******************************************************************************************
    // Register Address of MAC - Word Addressing
    // ******************************************************************************************
    // Primary MAC address
    parameter PRIMARY_MAC_ADD_0_ADDR                            = 32'h010;
    parameter PRIMARY_MAC_ADD_1_ADDR                            = 32'h011;
    
    // TX Path Enabled/disabled
    parameter TX_TRANSFER_CONTROL_ADDR                          = 32'h020;
    
    // TX Pad Insertion Control
    parameter TX_PADINS_CONTROL_ADDR                            = 32'h024;
    
    // TX CRC Insertion Control
    parameter TX_CRC_INSERT_CONTROL_ADDR                        = 32'h026;
    
    // TX Address Insertion Control
    parameter TX_ADDRESS_INSERT_CONTROL_ADDR                    = 32'h02A;
    
    // RX Path Enabled/disabled
    parameter RX_TRANSFER_CONTROL_ADDR                          = 32'h0A0;
    
    // Base address for statistics
    parameter TX_STATISTICS_ADDR                                = 32'h140;
    parameter RX_STATISTICS_ADDR                                = 32'h1C0;
    
    // Unicast address for source address insertion on TX path
    parameter TX_ADDRESS_INSERT_UCAST_MAC_ADD_0_ADDR            = 32'h010;
    parameter TX_ADDRESS_INSERT_UCAST_MAC_ADD_1_ADDR            = 32'h011;
    
    // RX uses the primary MAC address to filter unicast frames when the en_allucast bit of the rx_frame_control register is set to 0.
    parameter RX_FRAME_0_ADDR                                   = 32'h010;
    parameter RX_FRAME_1_ADDR                                   = 32'h011;
    
    // Base address for XGMII TSU
    parameter RX_10G_PERIOD_ADDR                                = 32'h120;
    parameter RX_10G_ADJUST_FNS_ADDR                            = 32'h122;
    parameter RX_10G_ADJUST_NS_ADDR                             = 32'h124;
    
    parameter TX_10G_PERIOD_ADDR                                = 32'h100;
    parameter TX_10G_ADJUST_FNS_ADDR                            = 32'h102;
    parameter TX_10G_ADJUST_NS_ADDR                             = 32'h104;
    
    // Base address for GMII TSU
    parameter RX_1G_PERIOD_ADDR                                 = 32'h128;
    parameter RX_1G_ADJUST_FNS_ADDR                             = 32'h12A;
    parameter RX_1G_ADJUST_NS_ADDR                              = 32'h12C;
    
    parameter TX_1G_PERIOD_ADDR                                 = 32'h108;
    parameter TX_1G_ADJUST_FNS_ADDR                             = 32'h10A;
    parameter TX_1G_ADJUST_NS_ADDR                              = 32'h10C;

    // Base address for RX Frame Decoder
    parameter RX_FRAME_CONTROL_ADDR                             = 32'h0AC;

    // Register Of Pause Frame Gen
    parameter TX_PAUSEFRAME_CONTROL                             = 32'h040;
    parameter TX_PAUSEFRAME_QUANTA                              = 32'h042;
    parameter TX_PAUSEFRAME_ENABLE                              = 32'h044;

    // Programmable PIPG (New in LLC MAC)
    parameter TX_ETH_PIPG_10G_ADDR                              = 32'h02E;
    parameter TX_ETH_PIPG_1G_ADDR                               = 32'h02F;

    // ******************************************************************************************
    // Registers Offset of MAC - Word Addressing
    // ******************************************************************************************
    // ------------------------------------------------------------------------------------------
    // Statistics
    // ------------------------------------------------------------------------------------------
    parameter STATISTICS_framesOK_OFFSET                        = 32'h002;
    parameter STATISTICS_framesErr_OFFSET                       = 32'h004;
    parameter STATISTICS_framesCRCErr_OFFSET                    = 32'h006;
    parameter STATISTICS_octetsOK_OFFSET                        = 32'h008;
    parameter STATISTICS_pauseMACCtrlFrames_OFFSET              = 32'h00A;
    parameter STATISTICS_ifErrors_OFFSET                        = 32'h00C;
    parameter STATISTICS_unicastFramesOK_OFFSET                 = 32'h00E;
    parameter STATISTICS_unicastFramesErr_OFFSET                = 32'h010;
    parameter STATISTICS_multicastFramesOK_OFFSET               = 32'h012;
    parameter STATISTICS_multicastFramesErr_OFFSET              = 32'h014;
    parameter STATISTICS_broadcastFramesOK_OFFSET               = 32'h016;
    parameter STATISTICS_broadcastFramesErr_OFFSET              = 32'h018;
    parameter STATISTICS_etherStatsOctets_OFFSET                = 32'h01A;
    parameter STATISTICS_etherStatsPkts_OFFSET                  = 32'h01C;
    parameter STATISTICS_etherStatsUndersizePkts_OFFSET         = 32'h01E;
    parameter STATISTICS_etherStatsOversizePkts_OFFSET          = 32'h020;
    parameter STATISTICS_etherStatsPkts64Octets_OFFSET          = 32'h022;
    parameter STATISTICS_etherStatsPkts65to127Octets_OFFSET     = 32'h024;
    parameter STATISTICS_etherStatsPkts128to255Octets_OFFSET    = 32'h026;
    parameter STATISTICS_etherStatsPkts256to511Octets_OFFSET    = 32'h028;
    parameter STATISTICS_etherStatsPkts512to1023Octets_OFFSET   = 32'h02A;
    parameter STATISTICS_etherStatPkts1024to1518Octets_OFFSET   = 32'h02C;
    parameter STATISTICS_etherStatsPkts1519toXOctets_OFFSET     = 32'h02E;
    parameter STATISTICS_etherStatsFragments_OFFSET             = 32'h030;
    parameter STATISTICS_etherStatsJabbers_OFFSET               = 32'h032;
    parameter STATISTICS_etherStatsCRCErr_OFFSET                = 32'h034;
    parameter STATISTICS_unicastMACCtrlFrames_OFFSET            = 32'h036;
    parameter STATISTICS_multicastMACCtrlFrames_OFFSET          = 32'h038;
    parameter STATISTICS_broadcastMACCtrlFrames_OFFSET          = 32'h03A;
    
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
    
    //***********************************************************************************************
    // Time-of-Day 81000 81100
    //***********************************************************************************************
    parameter TOD_MASTER_ADDR      = 32'h4000;
    parameter TOD_0_10G_ADDR       = 32'h7800;
    parameter TOD_0_1G_ADDR        = 32'h7900;
     
    parameter TOD_SECOND_H         = 32'h000;
    parameter TOD_SECOND_L         = 32'h004;
    parameter TOD_NANOSECOND       = 32'h008;
    parameter TOD_PERIOD           = 32'h010;
    parameter TOD_ADJUSTPERIOD     = 32'h014;
    parameter TOD_DJUSTCOUNT       = 32'h018;
     
    // ******************************************************************************************
    // Registers Address of Reconfig Block
    // ******************************************************************************************
    parameter RCFG_LOGICAL_CHANNEL_NUM_ADDR                     = 32'h0;
    parameter RCFG_CONTROL_ADDR                                 = 32'h1;
    parameter RCFG_STATUS_ADDR                                  = 32'h2;
    
endpackage

`endif
