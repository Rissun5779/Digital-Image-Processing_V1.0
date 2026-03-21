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


`ifndef TB__SV
`define TB__SV

`include "eth_register_map_params_pkg.sv"
`include "avalon_driver.sv"
`include "avalon_st_eth_packet_monitor.sv"

`timescale 1ps / 1ps

// Top level testbench
module tb_top;
    
    // Parameter definition for MAC configuration and packet generation
    parameter UNICAST_ADDR          = 48'h22_44_66_88_AA_CC;
    parameter MULTICAST_ADDR        = 48'h21_44_66_88_AA_CC;
    parameter BROADCAST_ADDR        = 48'hFF_FF_FF_FF_FF_FF;
    parameter PAUSE_MULTICAST_ADDR  = 48'h01_80_C2_00_00_01;
    parameter INVALID_ADDR          = 48'h00_00_00_00_00_00;
    
    parameter MAC_ADDR              = 48'hEE_CC_88_CC_AA_EE;
    
    parameter VLAN_INFO             = 16'h0123;
    parameter SVLAN_INFO            = 16'h4567;
    
    parameter INSERT_PAD            = 1;
    parameter INSERT_CRC            = 0;
    parameter PAUSE_QUANTA          = 16'h0025;

    localparam FRAMESOK_SIZE        = 32;    
    
    
    // Get the Avalon interface parameters definition from the package
    import avalon_if_params_pkt::*;
    
    // Get the register map definition from the package
    import eth_register_map_params_pkg::*;
    
    
    
    // Clock and Reset signals
    reg         clk_156p25;
    reg         clk_ref;
    reg         clk_50;
    reg         reset;
    
    wire        avalon_mm_csr_clk;
    wire        avalon_st_rx_clk;
    wire        avalon_st_tx_clk;
    
    // Avalon-MM CSR signals
    wire [17:0] avalon_mm_csr_address;
    wire        avalon_mm_csr_read;
    wire [31:0] avalon_mm_csr_readdata;
    wire        avalon_mm_csr_write;
    wire [31:0] avalon_mm_csr_writedata;
    wire        avalon_mm_csr_waitrequest;
    
    // Avalon-ST RX signals
    wire        avalon_st_rx_startofpacket;
    wire        avalon_st_rx_endofpacket;
    wire        avalon_st_rx_valid;
    wire        avalon_st_rx_ready;
    wire [31:0] avalon_st_rx_data;
    wire [1:0]  avalon_st_rx_empty;
    wire [5:0]  avalon_st_rx_error;
    
    // Avalon-ST TX signals
    wire        avalon_st_tx_startofpacket;
    wire        avalon_st_tx_endofpacket;
    wire        avalon_st_tx_valid;
    wire        avalon_st_tx_ready;
    wire [31:0] avalon_st_tx_data;
    wire [1:0]  avalon_st_tx_empty;
    wire        avalon_st_tx_error;
    
    
    
    // Assign clock signals
    assign avalon_mm_csr_clk = clk_156p25;
    assign avalon_st_tx_clk = clk_156p25;
    assign avalon_st_rx_clk = clk_156p25;
    
    
    
    // Clock and reset generation
    initial clk_156p25 = 1'b0;
    always #3200 clk_156p25 = ~clk_156p25;
    
    initial clk_50 = 1'b0;
    always #10000 clk_50 = ~clk_50;
    
	initial clk_ref = 1'b0;
	always #1552 clk_ref = ~clk_ref;
	
    initial begin
        reset = 1'b0;
        #1 reset = 1'b1;
        #400000 reset = 1'b0;
    end
    
    
    
    // DUT specific signals
    wire [71:0] xgmii_rx_data;
    wire [71:0] xgmii_tx_data;
    
    // Loopback at Ethernet side
    assign xgmii_rx_data = xgmii_tx_data;
    
    // DUT instantiation
    /*
	altera_eth_10g_mac U_DUT(
		
        .csr_clk_clk                (clk_156p25),
		.csr_reset_reset_n          (~reset),
        
        .tx_clk_clk                 (clk_156p25),
		.tx_reset_reset_n           (~reset),
        
        .rx_clk_clk                 (clk_156p25),
		.rx_reset_reset_n           (~reset),
        
        .csr_address                (avalon_mm_csr_address),
		.csr_read                   (avalon_mm_csr_read),
		.csr_readdata               (avalon_mm_csr_readdata),
		.csr_write                  (avalon_mm_csr_write),
		.csr_writedata              (avalon_mm_csr_writedata),
		.csr_waitrequest            (avalon_mm_csr_waitrequest),
        
        .avalon_st_rx_startofpacket (avalon_st_rx_startofpacket),
		.avalon_st_rx_endofpacket   (avalon_st_rx_endofpacket),
		.avalon_st_rx_valid         (avalon_st_rx_valid),
		.avalon_st_rx_ready         (avalon_st_rx_ready),
		.avalon_st_rx_data          (avalon_st_rx_data),
		.avalon_st_rx_empty         (avalon_st_rx_empty),
		.avalon_st_rx_error         (avalon_st_rx_error),
		
        .avalon_st_tx_startofpacket (avalon_st_tx_startofpacket),
		.avalon_st_tx_endofpacket   (avalon_st_tx_endofpacket),
		.avalon_st_tx_valid         (avalon_st_tx_valid),
		.avalon_st_tx_ready         (avalon_st_tx_ready),
		.avalon_st_tx_data          (avalon_st_tx_data),
		.avalon_st_tx_empty         (avalon_st_tx_empty),
		.avalon_st_tx_error         (avalon_st_tx_error),
		
		.avalon_st_rxstatus_valid   (),
		.avalon_st_rxstatus_data    (),
		.avalon_st_rxstatus_error   (),
		.avalon_st_pause_data       (2'b00),
		
		.xgmii_rx_data              (xgmii_rx_data),
		.xgmii_tx_data              (xgmii_tx_data)
	);
	
	*/
    
	wire	tx_xcvr_clk;
	wire	rx_xcvr_clk;
	
	wire	serial_data;
	
	wire	tx_ready_export;
	wire	rx_ready_export;
	
	
	altera_eth_10g_mac_base_r_low_latency dut (

	.csr_clk			(clk_156p25),
	.csr_rst_n			(~reset),
	.tx_xcvr_clk		(tx_xcvr_clk),
	.tx_rst_n			(~reset),
	.rx_xcvr_clk		(rx_xcvr_clk),
	.rx_rst_n			(~reset),
	
	.ref_clk_clk		(clk_ref),
    
    
	
	.csr_read			(avalon_mm_csr_read),
	.csr_write			(avalon_mm_csr_write),
	.csr_writedata		(avalon_mm_csr_writedata),
	.csr_readdata		(avalon_mm_csr_readdata),
	.csr_address		(avalon_mm_csr_address[15:0]),
	.csr_waitrequest	(avalon_mm_csr_waitrequest),
    
    
	// .avalon_st_tx_startofpacket	(avalon_st_tx_startofpacket),
	// .avalon_st_tx_endofpacket	(avalon_st_tx_endofpacket),
	// .avalon_st_tx_valid			(avalon_st_tx_valid),
	// .avalon_st_tx_data			(avalon_st_tx_data),
	// .avalon_st_tx_empty			(avalon_st_tx_empty),
	// .avalon_st_tx_ready			(avalon_st_tx_ready),
	// .avalon_st_tx_error			(avalon_st_tx_error),
    
    
    
	// .avalon_st_rx_startofpacket	(avalon_st_rx_startofpacket),
	// .avalon_st_rx_endofpacket	(avalon_st_rx_endofpacket),
	// .avalon_st_rx_valid			(avalon_st_rx_valid),
	// .avalon_st_rx_data			(avalon_st_rx_data),
	// .avalon_st_rx_empty			(avalon_st_rx_empty),
	// .avalon_st_rx_ready			(avalon_st_rx_ready),
	// .avalon_st_rx_error			(avalon_st_rx_error),
	
	
	
    
	//.avalon_st_pause_data		(2'b00),
	// .avalon_st_txstatus_valid	(),
	// .avalon_st_txstatus_data	(), 
	// .avalon_st_txstatus_error	(),
	
	// .avalon_st_rxstatus_valid	(),                                  
	// .avalon_st_rxstatus_error	(),                                  
	// .avalon_st_rxstatus_data	(),
	
	// .link_fault_status_xgmii_rx_data(),
	
	// .tx_ready_export	(tx_ready_export),
	// .rx_ready_export	(rx_ready_export),
	
	
	.tx_serial_data		(serial_data),
	.rx_serial_data		(serial_data),
   
	.tx_ready_export	(),
	.rx_ready_export	(),
	.block_lock		(),
	.atx_pll_locked		(),
	.rx_xcvr_half_clk	(),
	.tx_xcvr_half_clk	(),
	.iopll_locked		() 

);

    
    
    reg		open_bit19;

    // Avalon-MM and Avalon-ST signals driver
    avalon_driver U_AVALON_DRIVER (
		.avalon_mm_csr_clk          (avalon_mm_csr_clk),
		.avalon_st_rx_clk           (rx_xcvr_clk),
		.avalon_st_tx_clk           (tx_xcvr_clk),
		
        .reset                      (reset),
		
        .avalon_mm_csr_address      ({open_bit19, avalon_mm_csr_address}),
		.avalon_mm_csr_read         (avalon_mm_csr_read),
		.avalon_mm_csr_readdata     (avalon_mm_csr_readdata),
		.avalon_mm_csr_write        (avalon_mm_csr_write),
		.avalon_mm_csr_writedata    (avalon_mm_csr_writedata),
		.avalon_mm_csr_waitrequest  (avalon_mm_csr_waitrequest),
        
        .avalon_st_rx_startofpacket (avalon_st_rx_startofpacket),
		.avalon_st_rx_endofpacket   (avalon_st_rx_endofpacket),
		.avalon_st_rx_valid         (avalon_st_rx_valid),
		.avalon_st_rx_ready         (avalon_st_rx_ready),
		.avalon_st_rx_data          (avalon_st_rx_data),
		.avalon_st_rx_empty         (avalon_st_rx_empty),
		.avalon_st_rx_error         (avalon_st_rx_error),
		
        .avalon_st_tx_startofpacket (avalon_st_tx_startofpacket),
		.avalon_st_tx_endofpacket   (avalon_st_tx_endofpacket),
		.avalon_st_tx_valid         (avalon_st_tx_valid),
		.avalon_st_tx_ready         (avalon_st_tx_ready),
		.avalon_st_tx_data          (avalon_st_tx_data),
		.avalon_st_tx_empty         (avalon_st_tx_empty),
		.avalon_st_tx_error         (avalon_st_tx_error)
	);
    
    
    
    // Ethernet packet monitor on Avalon-ST RX path
    avalon_st_eth_packet_monitor #(
		.ST_ERROR_W                 (AVALON_ST_RX_ST_ERROR_W),
		.ST_EMPTY_W					(AVALON_ST_RX_ST_EMPTY_W),
		.ST_NUMSYMBOLS				(AVALON_ST_RX_ST_NUMSYMBOLS)
    ) U_MON_RX (
		.clk                        (rx_xcvr_clk),
        .reset                      (reset),
		
        .startofpacket              (avalon_st_rx_startofpacket),
		.endofpacket                (avalon_st_rx_endofpacket),
		.valid                      (avalon_st_rx_valid),
		.ready                      (avalon_st_rx_ready),
		.data                       (avalon_st_rx_data),
		.empty                      (avalon_st_rx_empty),
		.error                      (avalon_st_rx_error)
	);
    
    
    
    // Ethernet packet monitor on Avalon-ST TX path
    avalon_st_eth_packet_monitor #(
		.ST_ERROR_W 				(AVALON_ST_TX_ST_ERROR_W),
		.ST_EMPTY_W					(AVALON_ST_TX_ST_EMPTY_W),
		.ST_NUMSYMBOLS				(AVALON_ST_TX_ST_NUMSYMBOLS)
    ) U_MON_TX (
		.clk                        (tx_xcvr_clk),
        .reset                      (reset),
		
        .startofpacket              (avalon_st_tx_startofpacket),
		.endofpacket                (avalon_st_tx_endofpacket),
		.valid                      (avalon_st_tx_valid),
		.ready                      (avalon_st_tx_ready),
		.data                       (avalon_st_tx_data),
		.empty                      (avalon_st_tx_empty),
		.error                      (avalon_st_tx_error)
	);
    
    
    
    // Variable to store data read from CSR interface
    bit [31:0] readdata;

    bit error;
    bit [63:0] framesOK_1;
    bit [63:0] framesOK_2;

    // Compare the statitics registers
    task automatic compare_eth_statistics(bit [31:0] addr1, bit [31:0] addr2, ref bit error, ref bit [63:0] framesOK_1, ref bit [63:0] framesOK_2);
        // Statistic 1
        bit [63:0] framesOK_stat1;
        bit [63:0] framesErr_stat1;
        bit [63:0] framesCRCErr_stat1;
        bit [63:0] octetsOK_stat1;
        bit [63:0] pauseMACCtrlFrames_stat1;
        bit [63:0] ifErrors_stat1;
        bit [63:0] unicastFramesOK_stat1;
        bit [63:0] unicastFramesErr_stat1;
        bit [63:0] multicastFramesOK_stat1;
        bit [63:0] multicastFramesErr_stat1;
        bit [63:0] broadcastFramesOK_stat1;
        bit [63:0] broadcastFramesErr_stat1;
        bit [63:0] etherStatsOctets_stat1;
        bit [63:0] etherStatsPkts_stat1;
        bit [63:0] etherStatsUndersizePkts_stat1;
        bit [63:0] etherStatsOversizePkts_stat1;
        bit [63:0] etherStatsPkts64Octets_stat1;
        bit [63:0] etherStatsPkts65to127Octets_stat1;
        bit [63:0] etherStatsPkts128to255Octets_stat1;
        bit [63:0] etherStatsPkts256to511Octet_stat1;
        bit [63:0] etherStatsPkts512to1023Octets_stat1;
        bit [63:0] etherStatsPkts1024to1518Octets_stat1;
        bit [63:0] etherStatsPkts1519OtoXOctets_stat1;
        bit [63:0] etherStatsFragments_stat1;
        bit [63:0] etherStatsJabbers_stat1;
        bit [63:0] etherStatsCRCErr_stat1;
        bit [63:0] unicastMACCtrlFrames_stat1;
        bit [63:0] multicastMACCtrlFrames_stat1;
        bit [63:0] broadcastMACCtrlFrames_stat1;   
        // Statistic 2
        bit [63:0] framesOK_stat2;
        bit [63:0] framesErr_stat2;
        bit [63:0] framesCRCErr_stat2;
        bit [63:0] octetsOK_stat2;
        bit [63:0] pauseMACCtrlFrames_stat2;
        bit [63:0] ifErrors_stat2;
        bit [63:0] unicastFramesOK_stat2;
        bit [63:0] unicastFramesErr_stat2;
        bit [63:0] multicastFramesOK_stat2;
        bit [63:0] multicastFramesErr_stat2;
        bit [63:0] broadcastFramesOK_stat2;
        bit [63:0] broadcastFramesErr_stat2;
        bit [63:0] etherStatsOctets_stat2;
        bit [63:0] etherStatsPkts_stat2;
        bit [63:0] etherStatsUndersizePkts_stat2;
        bit [63:0] etherStatsOversizePkts_stat2;
        bit [63:0] etherStatsPkts64Octets_stat2;
        bit [63:0] etherStatsPkts65to127Octets_stat2;
        bit [63:0] etherStatsPkts128to255Octets_stat2;
        bit [63:0] etherStatsPkts256to511Octet_stat2;
        bit [63:0] etherStatsPkts512to1023Octets_stat2;
        bit [63:0] etherStatsPkts1024to1518Octets_stat2;
        bit [63:0] etherStatsPkts1519OtoXOctets_stat2;
        bit [63:0] etherStatsFragments_stat2;
        bit [63:0] etherStatsJabbers_stat2;
        bit [63:0] etherStatsCRCErr_stat2;
        bit [63:0] unicastMACCtrlFrames_stat2;
        bit [63:0] multicastMACCtrlFrames_stat2;
        bit [63:0] broadcastMACCtrlFrames_stat2;

        bit error_status = 0;
    
        // Read Statistic 1
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_framesOK_OFFSET, framesOK_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_framesErr_OFFSET, framesErr_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_framesCRCErr_OFFSET, framesCRCErr_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_octetsOK_OFFSET, octetsOK_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_pauseMACCtrlFrames_OFFSET, pauseMACCtrlFrames_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_ifErrors_OFFSET, ifErrors_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_unicastFramesOK_OFFSET, unicastFramesOK_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_unicastFramesErr_OFFSET, unicastFramesErr_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_multicastFramesOK_OFFSET, multicastFramesOK_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_multicastFramesErr_OFFSET, multicastFramesErr_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_broadcastFramesOK_OFFSET, broadcastFramesOK_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_broadcastFramesErr_OFFSET, broadcastFramesErr_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_etherStatsOctets_OFFSET, etherStatsOctets_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_etherStatsPkts_OFFSET, etherStatsPkts_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_etherStatsUndersizePkts_OFFSET, etherStatsUndersizePkts_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_etherStatsOversizePkts_OFFSET, etherStatsOversizePkts_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_etherStatsPkts64Octets_OFFSET, etherStatsPkts64Octets_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_etherStatsPkts65to127Octets_OFFSET, etherStatsPkts65to127Octets_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_etherStatsPkts128to255Octets_OFFSET, etherStatsPkts128to255Octets_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_etherStatsPkts256to511Octets_OFFSET, etherStatsPkts256to511Octet_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_etherStatsPkts512to1023Octets_OFFSET, etherStatsPkts512to1023Octets_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_etherStatPkts1024to1518Octets_OFFSET, etherStatsPkts1024to1518Octets_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_etherStatsPkts1519toXOctets_OFFSET, etherStatsPkts1519OtoXOctets_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_etherStatsFragments_OFFSET, etherStatsFragments_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_etherStatsJabbers_OFFSET, etherStatsJabbers_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_etherStatsCRCErr_OFFSET, etherStatsCRCErr_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_unicastMACCtrlFrames_OFFSET, unicastMACCtrlFrames_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_multicastMACCtrlFrames_OFFSET, multicastMACCtrlFrames_stat1);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr1 + STATISTICS_broadcastMACCtrlFrames_OFFSET, broadcastMACCtrlFrames_stat1);

        // Read Statistic 2
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_framesOK_OFFSET, framesOK_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_framesErr_OFFSET, framesErr_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_framesCRCErr_OFFSET, framesCRCErr_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_octetsOK_OFFSET, octetsOK_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_pauseMACCtrlFrames_OFFSET, pauseMACCtrlFrames_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_ifErrors_OFFSET, ifErrors_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_unicastFramesOK_OFFSET, unicastFramesOK_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_unicastFramesErr_OFFSET, unicastFramesErr_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_multicastFramesOK_OFFSET, multicastFramesOK_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_multicastFramesErr_OFFSET, multicastFramesErr_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_broadcastFramesOK_OFFSET, broadcastFramesOK_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_broadcastFramesErr_OFFSET, broadcastFramesErr_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_etherStatsOctets_OFFSET, etherStatsOctets_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_etherStatsPkts_OFFSET, etherStatsPkts_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_etherStatsUndersizePkts_OFFSET, etherStatsUndersizePkts_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_etherStatsOversizePkts_OFFSET, etherStatsOversizePkts_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_etherStatsPkts64Octets_OFFSET, etherStatsPkts64Octets_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_etherStatsPkts65to127Octets_OFFSET, etherStatsPkts65to127Octets_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_etherStatsPkts128to255Octets_OFFSET, etherStatsPkts128to255Octets_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_etherStatsPkts256to511Octets_OFFSET, etherStatsPkts256to511Octet_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_etherStatsPkts512to1023Octets_OFFSET, etherStatsPkts512to1023Octets_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_etherStatPkts1024to1518Octets_OFFSET, etherStatsPkts1024to1518Octets_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_etherStatsPkts1519toXOctets_OFFSET, etherStatsPkts1519OtoXOctets_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_etherStatsFragments_OFFSET, etherStatsFragments_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_etherStatsJabbers_OFFSET, etherStatsJabbers_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_etherStatsCRCErr_OFFSET, etherStatsCRCErr_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_unicastMACCtrlFrames_OFFSET, unicastMACCtrlFrames_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_multicastMACCtrlFrames_OFFSET, multicastMACCtrlFrames_stat2);
        U_AVALON_DRIVER.avalon_mm_csr_rd64(addr2 + STATISTICS_broadcastMACCtrlFrames_OFFSET, broadcastMACCtrlFrames_stat2);
     
        // Check for err statistic for stat1, must be 0
        if(framesErr_stat1 != 0 || framesCRCErr_stat1 != 0 || ifErrors_stat1 != 0 || unicastFramesErr_stat1 != 0 || 
           multicastFramesErr_stat1 != 0 || broadcastFramesErr_stat1 != 0 || etherStatsCRCErr_stat1 != 0) begin
            error_status = 1;
        end

        // Check for err statistic for stat2, must be 0
        if(framesErr_stat2 != 0 || framesCRCErr_stat2 != 0 || ifErrors_stat2 != 0 || unicastFramesErr_stat2 != 0 || 
           multicastFramesErr_stat2 != 0 || broadcastFramesErr_stat2 != 0 || etherStatsCRCErr_stat2 != 0) begin
            error_status = 1;
        end

        // Compare non-err statistic between stat1 & stat2, they must be equal
        if(framesOK_stat1 != framesOK_stat2 || octetsOK_stat1 != octetsOK_stat2 || pauseMACCtrlFrames_stat1 != pauseMACCtrlFrames_stat2 ||
           unicastFramesOK_stat1 != unicastFramesOK_stat2 || multicastFramesOK_stat1 != multicastFramesOK_stat2 || broadcastFramesOK_stat1 != broadcastFramesOK_stat2 || 
           etherStatsOctets_stat1 != etherStatsOctets_stat2 || etherStatsPkts_stat1 != etherStatsPkts_stat2 || etherStatsUndersizePkts_stat1 != etherStatsUndersizePkts_stat2 ||
           etherStatsOversizePkts_stat1 != etherStatsOversizePkts_stat2 || etherStatsPkts64Octets_stat1 != etherStatsPkts64Octets_stat2 ||
           etherStatsPkts65to127Octets_stat1 != etherStatsPkts65to127Octets_stat2 || etherStatsPkts128to255Octets_stat1 != etherStatsPkts128to255Octets_stat2 ||
           etherStatsPkts256to511Octet_stat1 != etherStatsPkts256to511Octet_stat2 || etherStatsPkts512to1023Octets_stat1 != etherStatsPkts512to1023Octets_stat2 ||
           etherStatsPkts1024to1518Octets_stat1 != etherStatsPkts1024to1518Octets_stat2 || etherStatsPkts1519OtoXOctets_stat1 != etherStatsPkts1519OtoXOctets_stat2 ||
           etherStatsFragments_stat1 != etherStatsFragments_stat2 || etherStatsJabbers_stat1 != etherStatsJabbers_stat2 ||
           unicastMACCtrlFrames_stat1 != unicastMACCtrlFrames_stat2 || multicastMACCtrlFrames_stat1 != multicastMACCtrlFrames_stat2 ||
           broadcastMACCtrlFrames_stat1 != broadcastMACCtrlFrames_stat2) begin
            error_status = 1;
        end


        framesOK_1 = framesOK_stat1;
        framesOK_2 = framesOK_stat2;
        error = error_status;

    endtask
    
    // Control the testbench flow and driving signals by calling Avalon BFM Driver
    initial begin
        // Configure the MAC
        // Enable source address insertion on TX
        
        repeat(7800) @(posedge clk_156p25);
        
        
        
		U_AVALON_DRIVER.avalon_mm_csr_wr(TX_ADDRESS_INSERT_CONTROL_ADDR, 1);
        
        // Configure unicast address for TX
        U_AVALON_DRIVER.avalon_mm_csr_wr(TX_ADDRESS_INSERT_UCAST_MAC_ADD_0_ADDR, MAC_ADDR[31:0]);
        U_AVALON_DRIVER.avalon_mm_csr_wr(TX_ADDRESS_INSERT_UCAST_MAC_ADD_1_ADDR, MAC_ADDR[47:32]);
        
        // Read the configured registers
        U_AVALON_DRIVER.avalon_mm_csr_rd(TX_ADDRESS_INSERT_CONTROL_ADDR, readdata);
        $display("TX Source Address Insert Enable   = %0d", readdata[0]);
        
        U_AVALON_DRIVER.avalon_mm_csr_rd(TX_ADDRESS_INSERT_UCAST_MAC_ADD_1_ADDR, readdata);
        $display("TX Source Address [47:32]         = 0x%x", readdata[15:0]);
        
        U_AVALON_DRIVER.avalon_mm_csr_rd(TX_ADDRESS_INSERT_UCAST_MAC_ADD_0_ADDR, readdata);
        $display("TX Source Address [31:0]          = 0x%x", readdata[31:0]);
        
        // configure to remove CRC
        U_AVALON_DRIVER.avalon_mm_csr_rd(32'h100, readdata);
        $display("rx crc remove [31:0]          = 0x%x", readdata[31:0]);
        U_AVALON_DRIVER.avalon_mm_csr_wr(32'h100, 0);
        U_AVALON_DRIVER.avalon_mm_csr_rd(32'h100, readdata);
        $display("rx crc remove [31:0]          = 0x%x", readdata[31:0]);
        
        // configure rx fifo
            // drop on error
            U_AVALON_DRIVER.avalon_mm_csr_wr(32'h9414, 32'h01);
            U_AVALON_DRIVER.avalon_mm_csr_rd(32'h9414, readdata);
            $display("rx drop on error   = %0d", readdata);
            
            // configure almost full threshold
            U_AVALON_DRIVER.avalon_mm_csr_rd(32'h9408, readdata);
            $display("rx fifo almost full   = %0d", readdata);
            U_AVALON_DRIVER.avalon_mm_csr_wr(32'h9408, 32'h0370);
            U_AVALON_DRIVER.avalon_mm_csr_rd(32'h9408, readdata);
            $display("rx fifo almost full  = %0d", readdata);
            
            // configure almost empty threshold
            U_AVALON_DRIVER.avalon_mm_csr_rd(32'h940C, readdata);
            $display("rx fifo almost empty   = %0d", readdata);
            U_AVALON_DRIVER.avalon_mm_csr_wr(32'h940C, 32'h03);
            U_AVALON_DRIVER.avalon_mm_csr_rd(32'h940C, readdata);
            $display("rx fifo almost empty  = %0d", readdata);
        
       
        
        // configure generator
            //base address = 0, mon + 2000
            // confiure payload random
            //U_AVALON_DRIVER.avalon_mm_csr_wr(32'hE004, 1);
           // U_AVALON_DRIVER.avalon_mm_csr_rd(32'hE004, readdata);
            //$display("generator random length   = %0d", readdata[0]);
            // fixed length
            // set length of packets
            U_AVALON_DRIVER.avalon_mm_csr_wr(32'hE034, 32'h42);
            U_AVALON_DRIVER.avalon_mm_csr_rd(32'hE034, readdata);
            $display("generator length of packets   = %0d", readdata);
            
            //  random length 
            // U_AVALON_DRIVER.avalon_mm_csr_wr(32'hE004, 1);
            // U_AVALON_DRIVER.avalon_mm_csr_rd(32'hE004, readdata);
            // $display("generator random length   = %0d", readdata[0]);
            
            //  random payload 
            U_AVALON_DRIVER.avalon_mm_csr_wr(32'hE008, 1);
            U_AVALON_DRIVER.avalon_mm_csr_rd(32'hE008, readdata);
            $display("generator random payload   = %0d", readdata[0]);
            
            // set number of packets
            U_AVALON_DRIVER.avalon_mm_csr_wr(32'hE000, 32'h20);
            U_AVALON_DRIVER.avalon_mm_csr_rd(32'hE000, readdata);
            $display("generator number of packets   = %0d", readdata);
            
            // start to send packets
            U_AVALON_DRIVER.avalon_mm_csr_wr(32'hE00C, 1);
            U_AVALON_DRIVER.avalon_mm_csr_rd(32'hE00C, readdata);
            $display("start send packets   = %0d", readdata);
            
         repeat(10800) @(posedge clk_156p25);    
        // configure monitor
            // base address = 0, mon + 2400
            // monitor rx status
            // value and with 'h04
            U_AVALON_DRIVER.avalon_mm_csr_rd(32'hE41C, readdata);
            $display("rx_status   = %0d", readdata);
            
            // good packets receive
            U_AVALON_DRIVER.avalon_mm_csr_rd(32'hE404, readdata);
            $display("number of good packets   = %0d", readdata);
            
            // bad packets receive
            U_AVALON_DRIVER.avalon_mm_csr_rd(32'hE408, readdata);
            $display("number of bad packets   = %0d", readdata);
        // loopback address start from E800    
        
        // Wait until packet loopback on Avalon-ST RX path
        repeat(2800) @(posedge clk_156p25);
        
        
        
        // Display the collected statistics of the MAC
        $display("\n-------------");
        $display("TX Statistics");
        $display("-------------");
        U_AVALON_DRIVER.display_eth_statistics(TX_STATISTICS_ADDR);
        
        $display("\n-------------");
        $display("RX Statistics");
        $display("-------------");
        U_AVALON_DRIVER.display_eth_statistics(RX_STATISTICS_ADDR);
        
        tb_top.compare_eth_statistics(TX_STATISTICS_ADDR, RX_STATISTICS_ADDR, error, framesOK_1, framesOK_2);

        if (error == 1'b1) begin 
            $display("\n\nError: RX MAC statistic does not match TX MAC statistic.\n\n");
            $display("\n\nSimulation FAILED\n");
        end else if (framesOK_1 != FRAMESOK_SIZE || framesOK_2 != FRAMESOK_SIZE) begin 
            $display("\n\nError: framesOK size in MAC statistic does not match FRAMESOK_SIZE defined in testcase.\n\n");
            $display("\n\nSimulation FAILED\n");
        end else begin
            $display("\n\nSimulation PASSED\n");
        end

        $finish();
    end
    
    
endmodule

`endif
