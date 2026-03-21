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


`ifndef TB_TOP__SV
`define TB_TOP__SV

`include "eth_register_map_params_pkg.sv"
`include "avalon_driver.sv"
`include "avalon_if_params_pkg.sv"
`include "avalon_st_eth_packet_monitor.sv"
`include "default_test_params_pkg.sv"
`include "eth_mac_frame.sv"
`include "tb_testcase.sv"
`include "avst_pkt_lb_fifo.v"

`timescale 1ps / 1fs

// Top level testbench
module tb_top;
    
    // Get the Avalon interface parameters definition from the package
    import avalon_if_params_pkt::*;
    
    // Get the register map definition from the package
    import eth_register_map_params_pkg::*;
    
    //Get test parameter from the package
    import default_test_params_pkt::*;
    
    // Loop Control Variable
    genvar i;
    
    // Clock
    reg                                 clk_125;
    reg                                 refclk_10g;
    wire                                csr_clk;
    wire                                mac32b_clk;
    wire                                mac64b_clk;
    
    // Reset
    reg                                 reset;
    wire [NUM_OF_CHANNEL-1:0]           tx_digitalreset;
    wire [NUM_OF_CHANNEL-1:0]           rx_digitalreset;
    wire [NUM_OF_CHANNEL-1:0]           tx_digitalreset_mac_clk;
    wire [NUM_OF_CHANNEL-1:0]           rx_digitalreset_mac_clk;
    wire [NUM_OF_CHANNEL-1:0]           txrx_digitalreset_mac_clk;
    
    // MAC TX User Frame
    wire [NUM_OF_CHANNEL-1:0]           avalon_st_tx_valid;
    wire [NUM_OF_CHANNEL-1:0]           avalon_st_tx_ready;
    wire [NUM_OF_CHANNEL-1:0]           avalon_st_tx_startofpacket;
    wire [NUM_OF_CHANNEL-1:0]           avalon_st_tx_endofpacket;
    wire [NUM_OF_CHANNEL-1:0][63:0]     avalon_st_tx_data;
    wire [NUM_OF_CHANNEL-1:0][ 2:0]     avalon_st_tx_empty;
    wire [NUM_OF_CHANNEL-1:0]           avalon_st_tx_error;
    
    // MAC RX User Frame
    wire [NUM_OF_CHANNEL-1:0]           avalon_st_rx_valid;
    wire [NUM_OF_CHANNEL-1:0]           avalon_st_rx_ready;
    wire [NUM_OF_CHANNEL-1:0]           avalon_st_rx_startofpacket;
    wire [NUM_OF_CHANNEL-1:0]           avalon_st_rx_endofpacket;
    wire [NUM_OF_CHANNEL-1:0][63:0]     avalon_st_rx_data;
    wire [NUM_OF_CHANNEL-1:0][ 2:0]     avalon_st_rx_empty;
    wire [NUM_OF_CHANNEL-1:0][ 5:0]     avalon_st_rx_error;
    
    // Transceiver Serial Interface
    wire [NUM_OF_CHANNEL-1:0]           tx_serial_data;
    wire [NUM_OF_CHANNEL-1:0]           rx_serial_data;
    
    // Data Path Readiness
    wire [NUM_OF_CHANNEL-1:0]           channel_tx_ready;
    wire [NUM_OF_CHANNEL-1:0]           channel_rx_ready;
    
    // Avalon-MM CSR - Avalon Driver
    wire                     [19:0]     avalon_mm_csr_address;
    wire                                avalon_mm_csr_read;
    wire                                avalon_mm_csr_write;
    wire                     [31:0]     avalon_mm_csr_writedata;
    wire                     [31:0]     avalon_mm_csr_readdata;
    wire                                avalon_mm_csr_waitrequest;
    
    // MAC TX User Frame - Avalon Driver
    wire                                drv_avalon_st_tx_valid;
    wire                                drv_avalon_st_tx_ready;
    wire                                drv_avalon_st_tx_startofpacket;
    wire                                drv_avalon_st_tx_endofpacket;
    wire                     [63:0]     drv_avalon_st_tx_data;
    wire                     [ 2:0]     drv_avalon_st_tx_empty;
    wire                                drv_avalon_st_tx_error;
    
    // MAC RX User Frame - Avalon Driver
    wire                                drv_avalon_st_rx_valid;
    wire                                drv_avalon_st_rx_ready;
    wire                                drv_avalon_st_rx_startofpacket;
    wire                                drv_avalon_st_rx_endofpacket;
    wire                     [63:0]     drv_avalon_st_rx_data;
    wire                     [ 2:0]     drv_avalon_st_rx_empty;
    wire                     [ 5:0]     drv_avalon_st_rx_error;
    
    // Clock
    assign csr_clk = clk_125;
    
    // DUT
    alt_mge_multi_channel #(
        .NUM_OF_CHANNEL                 (NUM_OF_CHANNEL)
    ) DUT (
        
        // Reference Clock
        .refclk_10g                     (refclk_10g),
        
        // CSR Clock
        .csr_clk                        (csr_clk),
        
        // MAC Clock
        .mac32b_clk                     (mac32b_clk),
        
        // XGMII Clock
        .mac64b_clk                     (mac64b_clk),
        
        // Reset
        .reset                          (reset),
        .tx_digitalreset                (tx_digitalreset),
        .rx_digitalreset                (rx_digitalreset),
        
        // CSR
        .csr_mch_address                (avalon_mm_csr_address),
        .csr_mch_read                   (avalon_mm_csr_read),
        .csr_mch_write                  (avalon_mm_csr_write),
        .csr_mch_writedata              (avalon_mm_csr_writedata),
        .csr_mch_readdata               (avalon_mm_csr_readdata),
        .csr_mch_waitrequest            (avalon_mm_csr_waitrequest),
        
        // MAC TX User Frame
        .avalon_st_tx_valid             (avalon_st_tx_valid),
        .avalon_st_tx_ready             (avalon_st_tx_ready),
        .avalon_st_tx_startofpacket     (avalon_st_tx_startofpacket),
        .avalon_st_tx_endofpacket       (avalon_st_tx_endofpacket),
        .avalon_st_tx_data              (avalon_st_tx_data),
        .avalon_st_tx_empty             (avalon_st_tx_empty),
        .avalon_st_tx_error             (avalon_st_tx_error),
        
        // MAC RX User Frame
        .avalon_st_rx_valid             (avalon_st_rx_valid),
        .avalon_st_rx_ready             (avalon_st_rx_ready),
        .avalon_st_rx_startofpacket     (avalon_st_rx_startofpacket),
        .avalon_st_rx_endofpacket       (avalon_st_rx_endofpacket),
        .avalon_st_rx_data              (avalon_st_rx_data),
        .avalon_st_rx_empty             (avalon_st_rx_empty),
        .avalon_st_rx_error             (avalon_st_rx_error),
        
        // MAC TX Frame Status
        .avalon_st_txstatus_valid       (),
        .avalon_st_txstatus_data        (),
        .avalon_st_txstatus_error       (),
        
        // MAC RX Frame Status
        .avalon_st_rxstatus_valid       (),
        .avalon_st_rxstatus_data        (),
        .avalon_st_rxstatus_error       (),
        
        // MAC TX Pause Frame Generation Command
        .avalon_st_pause_data           ({NUM_OF_CHANNEL{2'b00}}),
        
        // MAC Status
        .xgmii_rx_link_fault_status     (),
        
        // PHY Status
        .led_an                         (),
        .rx_block_lock                  (),
        
        // Transceiver Serial Interface
        .tx_serial_data                 (tx_serial_data),
        .rx_serial_data                 (rx_serial_data),
        .rx_pma_clkout                  (),
        
        // Data Path Readiness
        .channel_tx_ready               (channel_tx_ready),
        .channel_rx_ready               (channel_rx_ready)
        
    );
    
    // Serial Intefaces
    if(NUM_OF_CHANNEL > 1) begin
        assign rx_serial_data[NUM_OF_CHANNEL-1:0] = {tx_serial_data[NUM_OF_CHANNEL-2:0], tx_serial_data[NUM_OF_CHANNEL-1]};
    end
    else begin
        assign rx_serial_data = tx_serial_data;
    end
    
    // Loop for multiple instances
    generate for(i = 0; i < NUM_OF_CHANNEL; i = i + 1)
    begin : CHANNEL_GEN
        
        // Reset Synchronizer
        altera_reset_synchronizer #(
            .DEPTH      (2),
            .ASYNC_RESET(1)
        ) tx_digitalreset_sync (
            .clk        (mac64b_clk),
            .reset_in   (tx_digitalreset[i]),
            .reset_out  (tx_digitalreset_mac_clk[i])
        );
        
        altera_reset_synchronizer #(
            .DEPTH      (2),
            .ASYNC_RESET(1)
        ) rx_digitalreset_sync (
            .clk        (mac64b_clk),
            .reset_in   (rx_digitalreset[i]),
            .reset_out  (rx_digitalreset_mac_clk[i])
        );
        
        altera_reset_synchronizer #(
            .DEPTH      (2),
            .ASYNC_RESET(1)
        ) lb_fifo_reset_sync (
            .clk        (mac64b_clk),
            .reset_in   (tx_digitalreset_mac_clk[i] | rx_digitalreset_mac_clk[i]),
            .reset_out  (txrx_digitalreset_mac_clk[i])
        );
        
        if(i > 0) begin
            // Channels other than first channel loopback from Avalon-ST RX to Avalon-ST TX
            // Store-and-forward Loopback FIFO
            avst_pkt_lb_fifo #(
                .SYMBOLS_PER_BEAT    (8),
                .BITS_PER_SYMBOL     (8),
                .FIFO_DEPTH          (512), // Equivalent to 2048 bytes
                .CHANNEL_WIDTH       (0), 
                .ERROR_WIDTH         (1),
                .USE_PACKETS         (1),
                .USE_FILL_LEVEL      (0),
                .EMPTY_LATENCY       (3),
                .USE_MEMORY_BLOCKS   (1),
                .USE_STORE_FORWARD   (1),
                .USE_ALMOST_FULL_IF  (0),
                .USE_ALMOST_EMPTY_IF (0)
            ) packet_loopback_fifo (
                .clk               (mac64b_clk),
                .reset             (txrx_digitalreset_mac_clk   [i]),
                
                .csr_address       (3'b0),
                .csr_read          (1'b0),
                .csr_write         (1'b0),
                .csr_readdata      (),
                .csr_writedata     (32'b0),
                
                .in_valid          (avalon_st_rx_valid          [i]),
                .in_ready          (avalon_st_rx_ready          [i]),
                .in_startofpacket  (avalon_st_rx_startofpacket  [i]),
                .in_endofpacket    (avalon_st_rx_endofpacket    [i]),
                .in_data           (avalon_st_rx_data           [i]),
                .in_empty          (avalon_st_rx_empty          [i]),
                .in_error          (|avalon_st_rx_error         [i]),
                
                .out_valid         (avalon_st_tx_valid          [i]),
                .out_ready         (avalon_st_tx_ready          [i]),
                .out_startofpacket (avalon_st_tx_startofpacket  [i]),
                .out_endofpacket   (avalon_st_tx_endofpacket    [i]),
                .out_data          (avalon_st_tx_data           [i]),
                .out_empty         (avalon_st_tx_empty          [i]),
                .out_error         (avalon_st_tx_error          [i]),
                
                .almost_full_data  (),
                .almost_empty_data (),
                
                .in_channel        (1'b0),
                .out_channel       ()
            );
        end
        
    end
    endgenerate
    
    // Channel-0 is driven by Avalon-ST Packet generator, while other channels loopback from Avalon-ST RX to Avalon-ST TX
    assign drv_avalon_st_rx_valid           = avalon_st_rx_valid[0];
    assign avalon_st_rx_ready[0]            = drv_avalon_st_rx_ready;
    assign drv_avalon_st_rx_startofpacket   = avalon_st_rx_startofpacket[0];
    assign drv_avalon_st_rx_endofpacket     = avalon_st_rx_endofpacket[0];
    assign drv_avalon_st_rx_data            = avalon_st_rx_data[0];
    assign drv_avalon_st_rx_empty           = avalon_st_rx_empty[0];
    assign drv_avalon_st_rx_error           = avalon_st_rx_error[0];
    
    assign avalon_st_tx_valid[0]            = drv_avalon_st_tx_valid;
    assign drv_avalon_st_tx_ready           = avalon_st_tx_ready[0];
    assign avalon_st_tx_startofpacket[0]    = drv_avalon_st_tx_startofpacket;
    assign avalon_st_tx_endofpacket[0]      = drv_avalon_st_tx_endofpacket;
    assign avalon_st_tx_data[0]             = drv_avalon_st_tx_data;
    assign avalon_st_tx_empty[0]            = drv_avalon_st_tx_empty;
    assign avalon_st_tx_error[0]            = drv_avalon_st_tx_error;
    
    // Ethernet packet monitor on Avalon-ST RX path
    avalon_st_eth_packet_monitor #(
        .ST_NUMSYMBOLS              (AVALON_ST_RX_ST_NUMSYMBOLS),
        .ST_EMPTY_W                 (AVALON_ST_RX_ST_EMPTY_W),
        .ST_ERROR_W                 (AVALON_ST_RX_ST_ERROR_W)
    ) U_MON_RX (
        .clk                        (mac64b_clk),
        .reset                      (rx_digitalreset_mac_clk    [0]),
        
        .valid                      (avalon_st_rx_valid         [0]),
        .ready                      (avalon_st_rx_ready         [0]),
        .startofpacket              (avalon_st_rx_startofpacket [0]),
        .endofpacket                (avalon_st_rx_endofpacket   [0]),
        .data                       (avalon_st_rx_data          [0]),
        .empty                      (avalon_st_rx_empty         [0]),
        .error                      (avalon_st_rx_error         [0])
    );
    
    // Ethernet packet monitor on Avalon-ST TX path
    avalon_st_eth_packet_monitor #(
        .ST_NUMSYMBOLS              (AVALON_ST_TX_ST_NUMSYMBOLS),
        .ST_EMPTY_W                 (AVALON_ST_TX_ST_EMPTY_W),
        .ST_ERROR_W                 (AVALON_ST_TX_ST_ERROR_W)
    ) U_MON_TX (
        .clk                        (mac64b_clk),
        .reset                      (tx_digitalreset_mac_clk    [0]),
        
        .valid                      (avalon_st_tx_valid         [0]),
        .ready                      (avalon_st_tx_ready         [0]),
        .startofpacket              (avalon_st_tx_startofpacket [0]),
        .endofpacket                (avalon_st_tx_endofpacket   [0]),
        .data                       (avalon_st_tx_data          [0]),
        .empty                      (avalon_st_tx_empty         [0]),
        .error                      (avalon_st_tx_error         [0])
    );
    
    // Avalon-MM and Avalon-ST signals Driver
    avalon_driver U_AVALON_DRIVER (
        .avalon_mm_csr_clk          (csr_clk),
		.avalon_st_rx_clk           (mac64b_clk),
		.avalon_st_tx_clk           (mac64b_clk),
		
        .reset                      (reset),
		
        .avalon_mm_csr_address      (avalon_mm_csr_address),
		.avalon_mm_csr_read         (avalon_mm_csr_read),
		.avalon_mm_csr_readdata     (avalon_mm_csr_readdata),
		.avalon_mm_csr_write        (avalon_mm_csr_write),
		.avalon_mm_csr_writedata    (avalon_mm_csr_writedata),
		.avalon_mm_csr_waitrequest  (avalon_mm_csr_waitrequest),
        
        .avalon_st_rx_startofpacket (drv_avalon_st_rx_startofpacket),
		.avalon_st_rx_endofpacket   (drv_avalon_st_rx_endofpacket),
		.avalon_st_rx_valid         (drv_avalon_st_rx_valid),
		.avalon_st_rx_ready         (drv_avalon_st_rx_ready),
		.avalon_st_rx_data          (drv_avalon_st_rx_data),
		.avalon_st_rx_empty         (drv_avalon_st_rx_empty),
		.avalon_st_rx_error         (drv_avalon_st_rx_error),
		
        .avalon_st_tx_startofpacket (drv_avalon_st_tx_startofpacket),
		.avalon_st_tx_endofpacket   (drv_avalon_st_tx_endofpacket),
		.avalon_st_tx_valid         (drv_avalon_st_tx_valid),
		.avalon_st_tx_ready         (drv_avalon_st_tx_ready),
		.avalon_st_tx_data          (drv_avalon_st_tx_data),
		.avalon_st_tx_empty         (drv_avalon_st_tx_empty),
		.avalon_st_tx_error         (drv_avalon_st_tx_error)
    );
    
    
    // Clock ceneration
    initial begin
        clk_125 = 1'b0;
    end
    
    always begin
        #4000 clk_125 = ~clk_125;
    end
    
    initial begin
        refclk_10g = 1'b0;
    end
    
    always begin
        #775.758 refclk_10g = ~refclk_10g;
    end
    
    // Reset generation
	initial begin
        reset = 1'b0;
        #1 reset = 1'b1;
        #40000 reset = 1'b0;
    end
    
    // Test flow scenario
    tb_testcase U_TESTCASE ();
    
    task automatic display_statistics (bit [31:0] address_offset);
        // Display the collected statistics of the MAC
        $display("\n------------------------");
        $display("Channel 0: TX Statistics");
        $display("------------------------");
        U_AVALON_DRIVER.display_eth_statistics(address_offset + TX_STATISTICS_ADDR);
        
        $display("\n------------------------");
        $display("Channel 0: RX Statistics");
        $display("------------------------");
        U_AVALON_DRIVER.display_eth_statistics(address_offset + RX_STATISTICS_ADDR);
        
    endtask
    
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
    
endmodule

`endif
