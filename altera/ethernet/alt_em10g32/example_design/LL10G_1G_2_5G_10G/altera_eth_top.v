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

`timescale 1 ps / 1 ps

module altera_eth_top # (
    parameter NUM_OF_CHANNEL = 2
 )(
    
    // Clock
    input                               refclk_1g2p5g,
    input                               refclk_10g,
    
    // Reset
    input                               reset_n,
    
    // Serial Interface
    input       [NUM_OF_CHANNEL-1:0]    rx_serial_data,
    output      [NUM_OF_CHANNEL-1:0]    tx_serial_data,
    
    // LED
    output      [NUM_OF_CHANNEL-1:0]    channel_ready_n,
    
    // SFP
    output                              sfp_txdisable
    
);
    // Loop Control Variable
    genvar i;
    
    // Clock
    wire                                csr_clk;
    wire                                mac_clk;
    wire                                mac64b_clk;
    
    // Reset
    wire [NUM_OF_CHANNEL-1:0]           tx_digitalreset;
    wire [NUM_OF_CHANNEL-1:0]           rx_digitalreset;
    wire                                reset_mac64b_clk;
    
    // JTAG CSR
    wire                     [31:0]     jtag_if_address;
    wire                                jtag_if_read;
    wire                                jtag_if_write;
    wire                     [31:0]     jtag_if_writedata;
    wire                     [31:0]     jtag_if_readdata;
    wire                                jtag_if_readdatavalid;
    wire                                jtag_if_waitrequest;
    
    // MAC CSR
    wire [NUM_OF_CHANNEL-1:0][ 9:0]     csr_mac_address;
    wire [NUM_OF_CHANNEL-1:0]           csr_mac_read;
    wire [NUM_OF_CHANNEL-1:0]           csr_mac_write;
    wire [NUM_OF_CHANNEL-1:0][31:0]     csr_mac_writedata;
    wire [NUM_OF_CHANNEL-1:0][31:0]     csr_mac_readdata;
    wire [NUM_OF_CHANNEL-1:0]           csr_mac_waitrequest;
    
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
    
    // PHY CSR
    wire [NUM_OF_CHANNEL-1:0][10:0]     csr_phy_address;
    wire [NUM_OF_CHANNEL-1:0]           csr_phy_read;
    wire [NUM_OF_CHANNEL-1:0]           csr_phy_write;
    wire [NUM_OF_CHANNEL-1:0][31:0]     csr_phy_writedata;
    wire [NUM_OF_CHANNEL-1:0][31:0]     csr_phy_readdata;
    wire [NUM_OF_CHANNEL-1:0]           csr_phy_waitrequest;
    
    // Data Path Readiness
    wire [NUM_OF_CHANNEL-1:0]           channel_tx_ready;
    wire [NUM_OF_CHANNEL-1:0]           channel_rx_ready;
    wire                                core_pll_locked;
    
    // Reconfig CSR
    wire                     [ 1:0]     csr_rcfg_address;
    wire                                csr_rcfg_read;
    wire                                csr_rcfg_write;
    wire                     [31:0]     csr_rcfg_writedata;
    wire                     [31:0]     csr_rcfg_readdata;
    
    // Traffic Controller CSR
    wire [NUM_OF_CHANNEL/2-1:0][11:0]   csr_traffic_controller_address;
    wire [NUM_OF_CHANNEL/2-1:0]         csr_traffic_controller_read;
    wire [NUM_OF_CHANNEL/2-1:0]         csr_traffic_controller_write;
    wire [NUM_OF_CHANNEL/2-1:0][31:0]   csr_traffic_controller_writedata;
    wire [NUM_OF_CHANNEL/2-1:0][31:0]   csr_traffic_controller_readdata;
    wire [NUM_OF_CHANNEL/2-1:0]         csr_traffic_controller_waitrequest;
    
    // Native PHY Reconfig CSR
    wire [NUM_OF_CHANNEL-1:0][ 9:0]     csr_native_phy_rcfg_address;
    wire [NUM_OF_CHANNEL-1:0]           csr_native_phy_rcfg_read;
    wire [NUM_OF_CHANNEL-1:0]           csr_native_phy_rcfg_write;
    wire [NUM_OF_CHANNEL-1:0][31:0]     csr_native_phy_rcfg_writedata;
    wire [NUM_OF_CHANNEL-1:0][31:0]     csr_native_phy_rcfg_readdata;
    wire [NUM_OF_CHANNEL-1:0]           csr_native_phy_rcfg_waitrequest;
    
    // Clock
    assign csr_clk = refclk_1g2p5g;
    
    // Channel Ready
    assign channel_ready_n = ~(channel_tx_ready & channel_rx_ready & {NUM_OF_CHANNEL{core_pll_locked}});
    
    // SFP
    assign sfp_txdisable = 1'b0;
    
    // Core PLL
    alt_mge_core_pll core_pll (
        .pll_refclk0        (refclk_10g),
        .pll_powerdown      (~reset_n),
        .outclk0            (mac64b_clk),
        .outclk1            (mac_clk),
        .pll_locked         (core_pll_locked),
        .pll_cal_busy       ()
    );
    
    // Reset
    alt_mge_reset_synchronizer #(
        .DEPTH      (2),
        .ASYNC_RESET(1)
    ) lb_fifo_reset_sync (
        .clk        (mac64b_clk),
        .reset_in   (~reset_n),
        .reset_out  (reset_mac64b_clk)
    );
    
    // DUT
    alt_mge_rd #(
        .NUM_OF_CHANNEL                 (NUM_OF_CHANNEL)
    ) DUT (
        
        // CSR Clock
        .csr_clk                        (csr_clk),
        
        // MAC Clock
        .mac_clk                        (mac_clk),
        
        // XGMII Clock
        .mac64b_clk                     (mac64b_clk),
        
        // Reference Clock
        .refclk_1g2p5g                  (refclk_1g2p5g),
        .refclk_10g                     (refclk_10g),
        
        // Reset
        .reset                          (~reset_n),
        .tx_digitalreset                (tx_digitalreset),
        .rx_digitalreset                (rx_digitalreset),
        
        // MAC CSR
        .csr_mac_address                (csr_mac_address),
        .csr_mac_read                   (csr_mac_read),
        .csr_mac_write                  (csr_mac_write),
        .csr_mac_writedata              (csr_mac_writedata),
        .csr_mac_readdata               (csr_mac_readdata),
        .csr_mac_waitrequest            (csr_mac_waitrequest),
        
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
        
        // PHY CSR
        .csr_phy_address                (csr_phy_address),
        .csr_phy_read                   (csr_phy_read),
        .csr_phy_write                  (csr_phy_write),
        .csr_phy_writedata              (csr_phy_writedata),
        .csr_phy_readdata               (csr_phy_readdata),
        .csr_phy_waitrequest            (csr_phy_waitrequest),
        
        // PHY Status
        .led_link                       (),
        .led_char_err                   (),
        .led_disp_err                   (),
        .led_an                         (),
        .rx_block_lock                  (),
        
        // Transceiver Serial Interface
        .tx_serial_data                 (tx_serial_data),
        .rx_serial_data                 (rx_serial_data),
        .rx_pma_clkout                  (),
        
        // Data Path Readiness
        .channel_tx_ready               (channel_tx_ready),
        .channel_rx_ready               (channel_rx_ready),
        
        // Reconfig CSR
        .csr_rcfg_address               (csr_rcfg_address),
        .csr_rcfg_read                  (csr_rcfg_read),
        .csr_rcfg_write                 (csr_rcfg_write),
        .csr_rcfg_writedata             (csr_rcfg_writedata),
        .csr_rcfg_readdata              (csr_rcfg_readdata),
        
        // Native PHY Reconfig CSR
        .csr_native_phy_rcfg_address    (csr_native_phy_rcfg_address),
        .csr_native_phy_rcfg_read       (csr_native_phy_rcfg_read),
        .csr_native_phy_rcfg_write      (csr_native_phy_rcfg_write),
        .csr_native_phy_rcfg_writedata  (csr_native_phy_rcfg_writedata),
        .csr_native_phy_rcfg_readdata   (csr_native_phy_rcfg_readdata),
        .csr_native_phy_rcfg_waitrequest(csr_native_phy_rcfg_waitrequest)
        
    );
    
    generate for (i =0; i <(NUM_OF_CHANNEL/2); i = i + 1)
        begin: ETH_TRAFFIC_CTRL_PAIR_CHANNEL
            eth_traffic_controller_top #(
                .NUM_CHANNELS       (2),
                .TSTAMP_FP_WIDTH    (4)
            ) eth_traffic_controller (
                .clk                                        (mac64b_clk),
                .reset_n                                    (~reset_mac64b_clk),
                
                .avl_mm_baddress                            ({csr_traffic_controller_address[i], 2'b00}),
                .avl_mm_read                                (csr_traffic_controller_read[i]),
                .avl_mm_write                               (csr_traffic_controller_write[i]),
                .avl_mm_writedata                           (csr_traffic_controller_writedata[i]),
                .avl_mm_readdata                            (csr_traffic_controller_readdata[i]),
                .avl_mm_waitrequest                         (csr_traffic_controller_waitrequest[i]),
                
                .avl_st_tx_val                              (avalon_st_tx_valid         [2*(i+1)-1: 2*i]),
                .avl_st_tx_ready                            (avalon_st_tx_ready         [2*(i+1)-1: 2*i]),
                .avl_st_tx_sop                              (avalon_st_tx_startofpacket [2*(i+1)-1: 2*i]),
                .avl_st_tx_eop                              (avalon_st_tx_endofpacket   [2*(i+1)-1: 2*i]),
                .avl_st_tx_data                             (avalon_st_tx_data          [2*(i+1)-1: 2*i]),
                .avl_st_tx_empty                            (avalon_st_tx_empty         [2*(i+1)-1: 2*i]),
                .avl_st_tx_error                            (avalon_st_tx_error         [2*(i+1)-1: 2*i]),
                
                .avl_st_rx_val                              (avalon_st_rx_valid         [2*(i+1)-1: 2*i]),
                .avl_st_rx_ready                            (avalon_st_rx_ready         [2*(i+1)-1: 2*i]),
                .avl_st_rx_sop                              (avalon_st_rx_startofpacket [2*(i+1)-1: 2*i]),
                .avl_st_rx_eop                              (avalon_st_rx_endofpacket   [2*(i+1)-1: 2*i]),
                .avl_st_rx_data                             (avalon_st_rx_data          [2*(i+1)-1: 2*i]),
                .avl_st_rx_empty                            (avalon_st_rx_empty         [2*(i+1)-1: 2*i]),
                .avl_st_rx_error                            (avalon_st_rx_error         [2*(i+1)-1: 2*i]),
                
                .avl_st_tx_status_valid                     ({2{1'b0}}),
                .avl_st_tx_status_data                      ({2{40'h0}}),
                .avl_st_tx_status_error                     ({2{7'h0}}),
                
                .avl_st_rx_status_valid                     ({2{1'b0}}),
                .avl_st_rx_status_data                      ({2{40'h0}}),
                .avl_st_rx_status_error                     ({2{7'h0}}),
                
                .tx_egress_timestamp_96b_valid              ({2{1'b0}}),
                .tx_egress_timestamp_96b_data               ({2{96'h0}}),
                .tx_egress_timestamp_96b_fingerprint        ({2{4'h0}}),
                
                .tx_egress_timestamp_request_fingerprint    (),
                .tx_egress_timestamp_request_valid          (),
                
                .rx_ingress_timestamp_96b_valid             ({2{1'b0}}),
                .rx_ingress_timestamp_96b_data              ({2{96'h0}}),
                
                .eth_std_stop_mon                           (2'b00),
                .eth_std_mon_active                         (),
                .eth_std_mon_done                           (),
                .eth_std_mon_error                          (),
                
                .eth_1588_wait_limit                        (1'b1),
                .eth_1588_start_tod_sync                    (),
                .eth_1588_channel_ready                     (2'b11),
                .eth_1588_traffic_controller_error_n        ()
            );
        end
    endgenerate 
    
    // JTAG Master
    alt_jtag_csr_master jtag_master (
        .clk_clk                           (csr_clk),
        .clk_reset_reset                   (~reset_n),
        .master_address                    (jtag_if_address),
        .master_write                      (jtag_if_write),
        .master_read                       (jtag_if_read),
        .master_writedata                  (jtag_if_writedata),
        .master_readdata                   (jtag_if_readdata),
        .master_readdatavalid              (jtag_if_readdatavalid),
        .master_waitrequest                (jtag_if_waitrequest)
    );
    
    // Avalon-MM Address Decoder
    alt_mge_rd_addrdec_mch csr_address_decoder (
        .csr_clk_clk                                (csr_clk),
        .csr_clk_reset_reset_n                      (reset_n),
        
        .mac_clk_clk                                (mac64b_clk),
        .mac_clk_reset_reset_n                      (reset_n),
        
        .slave_address                              (24'h0),
        .slave_write                                (1'b0),
        .slave_read                                 (1'b0),
        .slave_writedata                            (32'h0),
        .slave_readdata                             (),
        .slave_waitrequest                          (),
        
        .jtag_slave_address                         (jtag_if_address),
        .jtag_slave_write                           (jtag_if_write),
        .jtag_slave_read                            (jtag_if_read),
        .jtag_slave_writedata                       (jtag_if_writedata),
        .jtag_slave_readdata                        (jtag_if_readdata),
        .jtag_slave_readdatavalid                   (jtag_if_readdatavalid),
        .jtag_slave_waitrequest                     (jtag_if_waitrequest),
        
        .mge_reconfig_address                       (csr_rcfg_address),
        .mge_reconfig_read                          (csr_rcfg_read),
        .mge_reconfig_write                         (csr_rcfg_write),
        .mge_reconfig_writedata                     (csr_rcfg_writedata),
        .mge_reconfig_readdata                      (csr_rcfg_readdata),
        
        .channel_0_mac_address                      (csr_mac_address[0]),
        .channel_0_mac_read                         (csr_mac_read[0]),
        .channel_0_mac_write                        (csr_mac_write[0]),
        .channel_0_mac_writedata                    (csr_mac_writedata[0]),
        .channel_0_mac_readdata                     (csr_mac_readdata[0]),
        .channel_0_mac_waitrequest                  (csr_mac_waitrequest[0]),
        
        .channel_0_phy_address                      (csr_phy_address[0]),
        .channel_0_phy_read                         (csr_phy_read[0]),
        .channel_0_phy_write                        (csr_phy_write[0]),
        .channel_0_phy_writedata                    (csr_phy_writedata[0]),
		.channel_0_phy_readdata                     ({16'h0, csr_phy_readdata[0]}),
		.channel_0_phy_waitrequest                  (csr_phy_waitrequest[0]),
        
        .channel_0_native_phy_rcfg_address          (csr_native_phy_rcfg_address[0]),
        .channel_0_native_phy_rcfg_read             (csr_native_phy_rcfg_read[0]),
        .channel_0_native_phy_rcfg_write            (csr_native_phy_rcfg_write[0]),
        .channel_0_native_phy_rcfg_writedata        (csr_native_phy_rcfg_writedata[0]),
        .channel_0_native_phy_rcfg_readdata         (csr_native_phy_rcfg_readdata[0]),
        .channel_0_native_phy_rcfg_waitrequest      (csr_native_phy_rcfg_waitrequest[0]),
        
        .channel_1_mac_address                      (csr_mac_address[1]),
        .channel_1_mac_read                         (csr_mac_read[1]),
        .channel_1_mac_write                        (csr_mac_write[1]),
        .channel_1_mac_writedata                    (csr_mac_writedata[1]),
        .channel_1_mac_readdata                     (csr_mac_readdata[1]),
        .channel_1_mac_waitrequest                  (csr_mac_waitrequest[1]),
        
        .channel_1_phy_address                      (csr_phy_address[1]),
        .channel_1_phy_read                         (csr_phy_read[1]),
        .channel_1_phy_write                        (csr_phy_write[1]),
        .channel_1_phy_writedata                    (csr_phy_writedata[1]),
		.channel_1_phy_readdata                     ({16'h0, csr_phy_readdata[1]}),
		.channel_1_phy_waitrequest                  (csr_phy_waitrequest[1]),
        
        .channel_1_native_phy_rcfg_address          (csr_native_phy_rcfg_address[1]),
        .channel_1_native_phy_rcfg_read             (csr_native_phy_rcfg_read[1]),
        .channel_1_native_phy_rcfg_write            (csr_native_phy_rcfg_write[1]),
        .channel_1_native_phy_rcfg_writedata        (csr_native_phy_rcfg_writedata[1]),
        .channel_1_native_phy_rcfg_readdata         (csr_native_phy_rcfg_readdata[1]),
        .channel_1_native_phy_rcfg_waitrequest      (csr_native_phy_rcfg_waitrequest[1]),
        
        .channel_0_1_traffic_controller_address     (csr_traffic_controller_address[0]),
        .channel_0_1_traffic_controller_read        (csr_traffic_controller_read[0]),
        .channel_0_1_traffic_controller_write       (csr_traffic_controller_write[0]),
        .channel_0_1_traffic_controller_writedata   (csr_traffic_controller_writedata[0]),
        .channel_0_1_traffic_controller_readdata    (csr_traffic_controller_readdata[0]),
        .channel_0_1_traffic_controller_waitrequest (csr_traffic_controller_waitrequest[0])
    );

endmodule         
