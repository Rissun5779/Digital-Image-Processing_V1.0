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
`include "nf_phyip_reset_model.v"

`timescale 1ps / 1ps

// Top level testbench
module tb;
    
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
    
    // Parameter definition for FIFO configuration
    parameter RX_FIFO_DROP_ON_ERROR = 1;
    
    
    // Get the Avalon interface parameters definition from the package
    import avalon_if_params_pkt::*;
    
    // Get the register map definition from the package
    import eth_register_map_params_pkg::*;
    
    
    
    // Clock and Reset signals
    reg         clk_156p25;
    reg         clk_1562p5;
    reg         clk_125;
    reg         clk_122;
    wire        clk_gmii = clk_156p25;
    reg         clk_mac;
    reg         clk_50;
    reg         reset;
    
    wire        avalon_mm_csr_clk;
    wire        avalon_st_rx_clk;
    wire        avalon_st_tx_clk;
    
    // Avalon-MM CSR signals
    wire [18:0] avalon_mm_csr_address;
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
    wire [63:0] avalon_st_rx_data;
    wire [2:0]  avalon_st_rx_empty;
    wire [5:0]  avalon_st_rx_error;
    
    // Avalon-ST TX signals
    wire        avalon_st_tx_startofpacket;
    wire        avalon_st_tx_endofpacket;
    wire        avalon_st_tx_valid;
    wire        avalon_st_tx_ready;
    wire [63:0] avalon_st_tx_data;
    wire [2:0]  avalon_st_tx_empty;
    wire        avalon_st_tx_error;
    
    // DUT specific signals
    wire rx_recovered_clk;    
    wire rx_analogreset;
    wire rx_digitalreset;
    wire tx_analogreset;
    wire tx_digitalreset;
    wire tx_cal_busy;
    wire rx_cal_busy;
    wire rx_is_lockedtodata;
    wire tx_ready;
    wire rx_ready;
    //wire pll_powerdown;
    //wire pll_locked;



    
    // Clock and reset generation
    initial clk_156p25 = 1'b0;
    always #3200 clk_156p25 = ~clk_156p25;
    
    initial clk_125 = 1'b0;
    always #4000 clk_125 = ~clk_125;
    
    initial clk_122 = 1'b0;
    always #4098 clk_122 = ~clk_122;
    
    initial clk_50 = 1'b0;
    always #10000 clk_50 = ~clk_50;
    
    initial clk_mac = 1'b0;
    always #12800 clk_mac = ~clk_mac;

    initial begin
        reset = 1'b0;
        #1 reset = 1'b1;
        #400000 reset = 1'b0;
    end
    
    
    
    // DUT specific signals
    wire [3:0] xaui_rx_data;
    wire [3:0] xaui_tx_data;
    wire clk_mac2;
    // Loopback at Ethernet side
    assign xaui_rx_data = xaui_tx_data;
    // Loopback at Transceiver Side
    wire txp_from_the_eth_2_5g_pcs_pma_0;
    wire eth_2_5g_pcs_pma_0_rx_clk_out;
    wire [91:0] reconfig_fromgxb_from_the_eth_2_5g_pcs_pma_0;
    
    
    // DUT instantiation
    altera_eth_2_5GbE DUT(
        // Clock and Reset
        .clk_39                                          (clk_mac),
        .clk_122                                         (clk_122),
        .tx_serial_clk0(clk_1562p5),            
	.rx_cdr_refclk_clk(clk_125),          
        .reset_n                                         (~reset),
        .eth_2_5g_phy_tx_clk_out                   (eth_2_5g_pcs_pma_0_tx_clk_out),
	.rx_recovered_clk(rx_recovered_clk),                       
        // Reconfig
	.reconfig_clk_clk(clk_125),                      
	.reconfig_reset_reset(reset),                 
	.reconfig_avmm_write(1'b0),                
	.reconfig_avmm_read(1'b0),                 
	.reconfig_avmm_address(10'b0),             
	.reconfig_avmm_writedata(32'b0),              
	.reconfig_avmm_readdata(),                
	.reconfig_avmm_waitrequest(),  
        // Reset Controller
	.tx_ready(tx_ready),                              
	.rx_ready(rx_ready),  
        .tx_analogreset_tx_analogreset(tx_analogreset),                 
        .tx_digitalreset_tx_digitalreset(tx_digitalreset),               
        .rx_analogreset_rx_analogreset(rx_analogreset),                  
        .rx_digitalreset_rx_digitalreset(rx_digitalreset),              
        .tx_cal_busy_tx_cal_busy(tx_cal_busy),                         
        .rx_cal_busy_rx_cal_busy(rx_cal_busy),                        
        .rx_is_lockedtoref_rx_is_lockedtoref(),             
        .rx_is_lockedtodata_rx_is_lockedtodata(rx_is_lockedtodata),                
       // Avalon-MM CSR
        .avalon_mm_csr_address			            (avalon_mm_csr_address),
        .avalon_mm_csr_read                         (avalon_mm_csr_read),
        .avalon_mm_csr_readdata                   (avalon_mm_csr_readdata),
        .avalon_mm_csr_waitrequest                (avalon_mm_csr_waitrequest),
        .avalon_mm_csr_write                        (avalon_mm_csr_write),
        .avalon_mm_csr_writedata                    (avalon_mm_csr_writedata),
        // Avalon-ST RX
        .avalon_st_rx_data  (avalon_st_rx_data),
        .avalon_st_rx_empty (avalon_st_rx_empty),
        .avalon_st_rx_eop   (avalon_st_rx_endofpacket),
        .avalon_st_rx_error (avalon_st_rx_error),
        .avalon_st_rx_ready   (avalon_st_rx_ready),
        .avalon_st_rx_sop   (avalon_st_rx_startofpacket),
        .avalon_st_rx_valid (avalon_st_rx_valid),
        // Avalon-ST TX
        .avalon_st_tx_data    (avalon_st_tx_data),
        .avalon_st_tx_empty   (avalon_st_tx_empty),
        .avalon_st_tx_eop     (avalon_st_tx_endofpacket),
        .avalon_st_tx_error   (avalon_st_tx_error),
        .avalon_st_tx_ready (avalon_st_tx_ready),
        .avalon_st_tx_sop     (avalon_st_tx_startofpacket),
        .avalon_st_tx_valid   (avalon_st_tx_valid),
        // Transceiver
        .rxp                   (txp_from_the_eth_2_5g_pcs_pma_0),
        .txp                 (txp_from_the_eth_2_5g_pcs_pma_0)
        
    );

    // Simulation purpose only    
    // Replace with reset_controller and PLL in actual implementation
    nf_phyip_reset_model nf_phyip_reset_model(
        .clk(clk_125), 
        .reset(reset),
        .tx_serial_clk(clk_1562p5), 
        .tx_analogreset(tx_analogreset),
        .tx_digitalreset(tx_digitalreset),
        .tx_ready(tx_ready),
        .rx_analogreset(rx_analogreset),
        .rx_digitalreset(rx_digitalreset),
        .rx_ready(rx_ready),
        .tx_cal_busy(tx_cal_busy),
        .rx_is_lockedtodata(rx_is_lockedtodata),
        .rx_cal_busy(rx_cal_busy)
    );

/*
    // NOTE: Generate following modules for actual implementation to replace nf_phyip_reset_model
    // Reset Controller (Transceiver PHY Reset Controller)
    reset_controller reset_controller(
	.clock(clk_125),              //              clock.clk
	.reset(reset),              //              reset.reset
	.pll_powerdown(pll_powerdown),      //      pll_powerdown.pll_powerdown
	.tx_analogreset(tx_analogreset),     //     tx_analogreset.tx_analogreset
	.tx_digitalreset(tx_digitalreset),    //    tx_digitalreset.tx_digitalreset
	.tx_ready(tx_ready),           //           tx_ready.tx_ready
	.pll_locked(pll_locked),         //         pll_locked.pll_locked
	.pll_select(1'b0),         //         pll_select.pll_select
	.tx_cal_busy(tx_cal_busy),        //        tx_cal_busy.tx_cal_busy
	.rx_analogreset(rx_analogreset),     //     rx_analogreset.rx_analogreset
	.rx_digitalreset(rx_digitalreset),    //    rx_digitalreset.rx_digitalreset
	.rx_ready(rx_ready),           //           rx_ready.rx_ready
	.rx_is_lockedtodata(rx_is_lockedtodata), // rx_is_lockedtodata.rx_is_lockedtodata
	.rx_cal_busy(rx_cal_busy)         //        rx_cal_busy.rx_cal_busy    
    );

    // PLL (Arria 10 Transceiver ATX/CMU PLL)
    pll pll (
        .pll_powerdown(pll_powerdown), // pll_powerdown.pll_powerdown
	.pll_refclk0(clk_125),   //   pll_refclk0.clk
	.tx_serial_clk(clk_1562p5), // tx_serial_clk.clk
	.pll_locked(pll_locked)     //    pll_locked.pll_locked
    );
*/





    
    
    // Assign clock signals
    assign avalon_mm_csr_clk    = clk_122;
    assign avalon_st_tx_clk     = clk_122;
    assign avalon_st_rx_clk     = clk_122;
    
    // Avalon-MM and Avalon-ST signals driver
    avalon_driver U_AVALON_DRIVER (
		.avalon_mm_csr_clk          (avalon_mm_csr_clk),
		.avalon_st_rx_clk           (avalon_st_rx_clk),
		.avalon_st_tx_clk           (avalon_st_tx_clk),
		
        .reset                      (reset),
		
        .avalon_mm_csr_address      (avalon_mm_csr_address),
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
		.ST_ERROR_W                 (AVALON_ST_RX_ST_ERROR_W)
    ) U_MON_RX (
		.clk                        (avalon_st_rx_clk),
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
		.ST_ERROR_W (AVALON_ST_TX_ST_ERROR_W)
    ) U_MON_TX (
		.clk                        (avalon_st_tx_clk),
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
    
    // Control the testbench flow and driving signals by calling Avalon BFM Driver
    initial begin
        // Configure the MAC
        // Enable source address insertion on TX
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
 
        U_AVALON_DRIVER.avalon_mm_csr_rd(PHY_STATUS_ADDR, readdata);
        readdata = readdata&32'h4;
        
        while (readdata != 32'h4) begin
            U_AVALON_DRIVER.avalon_mm_csr_rd(PHY_STATUS_ADDR, readdata);
            readdata = readdata&32'h4;
        end

        // Send Ethernet packet through Avalon-ST TX path
        U_AVALON_DRIVER.avalon_st_transmit_data_frame(UNICAST_ADDR, INVALID_ADDR, 64, INSERT_PAD, INSERT_CRC);
        U_AVALON_DRIVER.avalon_st_transmit_pause_frame(PAUSE_MULTICAST_ADDR, MAC_ADDR, PAUSE_QUANTA, INSERT_PAD, INSERT_CRC);
        U_AVALON_DRIVER.avalon_st_transmit_vlan_frame(MULTICAST_ADDR, MAC_ADDR, VLAN_INFO, 1518, INSERT_PAD, INSERT_CRC);
        U_AVALON_DRIVER.avalon_st_transmit_data_frame(MAC_ADDR, MAC_ADDR, 1518, INSERT_PAD, INSERT_CRC);
        U_AVALON_DRIVER.avalon_st_transmit_svlan_frame(BROADCAST_ADDR, MAC_ADDR, VLAN_INFO, SVLAN_INFO, 64, INSERT_PAD, INSERT_CRC);
        U_AVALON_DRIVER.avalon_st_transmit_vlan_frame(UNICAST_ADDR, MAC_ADDR, VLAN_INFO, 500, INSERT_PAD, INSERT_CRC);
        U_AVALON_DRIVER.avalon_st_transmit_pause_frame(MAC_ADDR, MAC_ADDR, PAUSE_QUANTA, INSERT_PAD, INSERT_CRC);
        U_AVALON_DRIVER.avalon_st_transmit_svlan_frame(MAC_ADDR, INVALID_ADDR, VLAN_INFO, SVLAN_INFO, 1518, INSERT_PAD, INSERT_CRC);
        
        
        
        // Wait until packet loopback on Avalon-ST RX path
        repeat(3500) @(posedge clk_156p25);
         
        
        
        // Display the collected statistics of the MAC
        $display("\n-------------");
        $display("TX Statistics");
        $display("-------------");
        U_AVALON_DRIVER.display_eth_statistics(TX_STATISTICS_ADDR);
        
        $display("\n-------------");
        $display("RX Statistics");
        $display("-------------");
        U_AVALON_DRIVER.display_eth_statistics(RX_STATISTICS_ADDR);
        
        
        
        // Simulation ended
        $display("\n\nSimulation Ended\n");
        $stop();
    end
    
    
endmodule

`endif
