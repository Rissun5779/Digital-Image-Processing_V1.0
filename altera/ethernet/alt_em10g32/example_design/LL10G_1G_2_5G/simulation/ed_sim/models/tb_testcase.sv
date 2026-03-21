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


// $Revision: #1 $
// $Date: 05/22/2013
// $Author: Viet Nga Dao $
`ifndef TB_TESTCASE_SV
`define TB_TESTCASE_SV

`include "default_test_params_pkg.sv"
`include "eth_mac_frame.sv"
`include "avalon_if_params_pkg.sv"

`timescale 1ps / 1ps

module tb_testcase;
    localparam NUM_TRANSMIT_FRAMES_PER_SPEED    = 3;
    localparam FRAMESOK_SIZE                    = 6;
    
    // Get the register map definition from the package
    import eth_register_map_params_pkg::*;
    
    //Get test parameter from the package
    import default_test_params_pkt::*;

    // Get the Avalon interface parameters definition from the package
    import avalon_if_params_pkt::*;
    
    reg [8:0] tx_frame_count = 9'h0;
    bit error;
    bit [63:0] framesOK_1;
    bit [63:0] framesOK_2;
    
    integer i;
    
    bit [31:0] mac_addr;
    
    reg [17:0] dut_ready_timeout_counter;
    
    string operating_speed;
    
    static reg [1:0] speed_array[2] = {ETH_SPEED_2P5G, ETH_SPEED_1G};
    
    // Test procedures
    initial begin
        
        while(tb_top.reset !== 1'b0) begin
            @(posedge tb_top.refclk);
        end
        
        $display("********************************************************************");
        $display("                          START SIMULATION                          ");   
        $display("********************************************************************");
        
        foreach(speed_array[speed]) begin
            
            operating_speed = (speed_array[speed] == ETH_SPEED_2P5G) ? "2.5GbE" : 
                              (speed_array[speed] == ETH_SPEED_1G)   ? "1GbE" : 
                              "Unknown";
            
            $display("====================================================================");
            $display(" Running in speed: %s", operating_speed);
            $display("====================================================================");
            
            for(i = 0; i < NUM_OF_CHANNEL; i = i + 1) begin
                // Configure MAC
                mac_addr = RD_CHANNEL_0_BASE_ADDR + (RD_CHANNEL_N_OFFSET * i) + RD_CHANNEL_MAC_OFFSET;
                
                // Configure primary MAC address
                U_AVALON_DRIVER.avalon_mm_csr_wr(mac_addr + PRIMARY_MAC_ADD_0_ADDR, MAC_ADDR[31:0]);
                U_AVALON_DRIVER.avalon_mm_csr_wr(mac_addr + PRIMARY_MAC_ADD_1_ADDR, MAC_ADDR[47:32]);
                
                // Enable pad insertion on TX
                U_AVALON_DRIVER.avalon_mm_csr_wr(mac_addr + TX_PADINS_CONTROL_ADDR, 1'b1);
                
                // Enable CRC insertion on TX
                U_AVALON_DRIVER.avalon_mm_csr_wr(mac_addr + TX_CRC_INSERT_CONTROL_ADDR, {1'b1, 1'b1});
                
                // Enable source address insertion on TX
                U_AVALON_DRIVER.avalon_mm_csr_wr(mac_addr + TX_ADDRESS_INSERT_CONTROL_ADDR, 1'b1);
                
                // Switching operating speed
                tb_top.U_AVALON_DRIVER.configure_xcvr_speed(i, speed_array[speed]);
            end
            
            // Wait until DUT is ready
            dut_ready_timeout_counter = 0;
            
            while(((&tb_top.channel_tx_ready == 0) || (&tb_top.channel_rx_ready == 0)) &&
                dut_ready_timeout_counter < 10000) begin
                
                dut_ready_timeout_counter++;
                @(posedge tb_top.refclk);
                
            end
            
            if(dut_ready_timeout_counter >= 10000) begin
                $display("%t Error - Timeout was reached before DUT is ready!", $time());
                $finish();
            end
            
            repeat(50) @(posedge tb_top.refclk);
            
            // Send Ethernet packet through Avalon-ST TX path
            tb_top.U_AVALON_DRIVER.avalon_st_transmit_data_frame(
                .dest_addr                              (MAC_ADDR),
                .src_addr                               (MAC_ADDR),
                .frame_length                           (64),
                .insert_pad                             (INSERT_PAD),
                .insert_crc                             (NO_INSERT_CRC)
            );
            
            tb_top.U_AVALON_DRIVER.avalon_st_transmit_data_frame(
                .dest_addr                              (MAC_ADDR),
                .src_addr                               (MAC_ADDR),
                .frame_length                           (1518),
                .insert_pad                             (INSERT_PAD),
                .insert_crc                             (NO_INSERT_CRC)
            );
            
            tb_top.U_AVALON_DRIVER.avalon_st_transmit_data_frame(
                .dest_addr                              (MAC_ADDR),
                .src_addr                               (MAC_ADDR),
                .frame_length                           (100),
                .insert_pad                             (INSERT_PAD),
                .insert_crc                             (NO_INSERT_CRC)
            );
            
            tx_frame_count = tx_frame_count +NUM_TRANSMIT_FRAMES_PER_SPEED; 
            // Wait until all packet received at avalon ST if
            while (tb_top.U_MON_RX.mac_frame_q.size() !== tx_frame_count)  begin
                      @(posedge tb_top.refclk);
            end
                  
            repeat(500) @(posedge tb_top.refclk);
            
        end // end of foreach loop
        
        repeat(500) @(posedge tb_top.refclk);
        tb_top.display_statistics(RD_CHANNEL_0_BASE_ADDR + RD_CHANNEL_MAC_OFFSET);

        tb_top.compare_eth_statistics(RD_CHANNEL_0_BASE_ADDR + RD_CHANNEL_MAC_OFFSET + TX_STATISTICS_ADDR, RD_CHANNEL_0_BASE_ADDR + RD_CHANNEL_MAC_OFFSET + RX_STATISTICS_ADDR, error, framesOK_1, framesOK_2);

        if (tb_top.U_MON_TX.mac_frame_q.size() != tb_top.U_MON_RX.mac_frame_q.size()) begin 
            $display("\n\nError: Packets received does not match packet transmitted.\n\n");
            $display("\n\nSimulation FAILED\n");
        end else if (error == 1'b1) begin 
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
