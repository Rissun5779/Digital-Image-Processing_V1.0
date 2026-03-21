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
    parameter TX_INGRESS_TIMESTAMP_96B_DATA     = 96'h000000000000_00000000_0012;
    parameter TX_INGRESS_TIMESTAMP_64B_DATA     = 64'h000000000000_0034;
    
    parameter DUT_READY_TIMEOUT                 = 10000;
    localparam NUM_TRANSMIT_FRAMES_PER_SPEED    = 7;
    localparam FRAMESOK_SIZE                    = 14;
    
    // Get the register map definition from the package
    import eth_register_map_params_pkg::*;
    
    //Get test parameter from the package
    import default_test_params_pkt::*;

    // Get the Avalon interface parameters definition from the package
    import avalon_if_params_pkt::*;
    
    reg [1:0]  current_speed = 2'bxx;
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
            
            // Wait until DUT is ready
            dut_ready_timeout_counter = 0;
            
            // Configure MAC for N channels
            tb_top.configure_csr_basic_n(RD_CHANNEL_0_BASE_ADDR+RD_CHANNEL_MAC_OFFSET);  
            
            // Configure Period and Adjustment for N channels
            tb_top.configure_csr_1588_n(RD_CHANNEL_0_BASE_ADDR+RD_CHANNEL_MAC_OFFSET);
            
            // Configure Time-of-Day for N channels
            tb_top.configure_csr_tod_n(TOD_MASTER_ADDR,RD_CHANNEL_0_BASE_ADDR+TOD_0_1G_ADDR,RD_CHANNEL_0_BASE_ADDR+TOD_0_10G_ADDR);
            
            // Configure PTP Clock Mode
            tb_top.clock_mode = {{(NUM_OF_CHANNEL-1){E2E_TRANSPARENT_CLOCK}},ORDINARY_CLOCK};
            
            for(i = 0; i < NUM_OF_CHANNEL; i = i + 1) begin
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
            // Packet Type:
            //      - Non-PTP
            // 2-step Operation:
            //      - N/A
            // 1-step Operation:
            //      - N/A
            // Expected Result (Channel-0 Ordinary Clock):
            //      - No return egress timestamp
            //      - No change to timestamp field
            //      - No change to correction field
            // Expected Result (Channel-1 End-to-end Transparent Clock):
            //      - No return egress timestamp
            //      - No change to timestamp field
            //      - No change to correction field
            tb_top.U_AVALON_DRIVER.avalon_st_transmit_data_frame(
                .dest_addr                              (MAC_ADDR),
                .src_addr                               (MAC_ADDR),
                .frame_length                           (64),
                .insert_pad                             (INSERT_PAD),
                .insert_crc                             (NO_INSERT_CRC)
            );
            repeat (500) @ (posedge tb_top.refclk);
            
            
            
            // Packet Type:
            //      - No VLAN
            //      - PTP over Ethernet
            //      - PTP Sync Message
            //      - 1-step PTP Packet
            // 2-step Operation:
            //      - Request egress timestamp
            // 1-step Operation:
            //      - No correction field update
            // Expected Result (Channel-0 Ordinary Clock):
            //      - Return egress timestamp
            //      - Timestamp inserted into timestamp field
            //      - Correction field inserted with fractional nanosecond of egress timestamp
            // Expected Result (Channel-1 End-to-end Transparent Clock):
            //      - No return egress timestamp
            //      - No change to timestamp field
            //      - Correction field updated with residence time
            tb_top.U_AVALON_DRIVER.avalon_st_transmit_ptp_frame_universal(
                .dest_addr                              (MAC_ADDR),
                .src_addr                               (MAC_ADDR),
                .vlan_tag                               (NO_VLAN),
                .length_type                            (LENGTH_TYPE_PTP),
                .ip_protocol                            (PROTOCOL_UDP),
                .udp_port                               (UDP_PORT_PTP_EVENT),
                .ptp_message_type                       (MSG_SYNC), 
                .ptp_two_step_flag                      (PTP_ONE_STEP),
                .insert_pad                             (INSERT_PAD),
                .insert_crc                             (NO_INSERT_CRC),
                .egress_timestamp_request_valid         (1'b1),
                .egress_timestamp_request_fingerprint   (0),
                .ingress_timestamp_valid                (1'b0),
                .ingress_timestamp_96b                  (TX_INGRESS_TIMESTAMP_96B_DATA),
                .ingress_timestamp_64b                  (TX_INGRESS_TIMESTAMP_64B_DATA),
                .ingress_timestamp_format               (PTP_TIMESTAMP_FORMAT_96B)
            );
            repeat (500) @ (posedge tb_top.refclk);
            
            
            
            // Packet Type:
            //      - VLAN
            //      - PTP over UDP/IPv4
            //      - PTP Sync Message
            //      - 1-step PTP Packet
            // 2-step Operation:
            //      - Request egress timestamp
            // 1-step Operation:
            //      - No correction field update
            // Expected Result (Channel-0 Ordinary Clock):
            //      - Return egress timestamp
            //      - Timestamp inserted into timestamp field
            //      - Correction field inserted with fractional nanosecond of egress timestamp
            // Expected Result (Channel-1 End-to-end Transparent Clock):
            //      - No return egress timestamp
            //      - No change to timestamp field
            //      - Correction field updated with residence time
            tb_top.U_AVALON_DRIVER.avalon_st_transmit_ptp_frame_universal(
                .dest_addr                              (MAC_ADDR),
                .src_addr                               (MAC_ADDR),
                .vlan_tag                               (VLAN),
                .length_type                            (LENGTH_TYPE_IPV4),
                .ip_protocol                            (PROTOCOL_UDP),
                .udp_port                               (UDP_PORT_PTP_EVENT),
                .ptp_message_type                       (MSG_SYNC), 
                .ptp_two_step_flag                      (PTP_ONE_STEP),
                .insert_pad                             (INSERT_PAD),
                .insert_crc                             (NO_INSERT_CRC),
                .egress_timestamp_request_valid         (1'b1),
                .egress_timestamp_request_fingerprint   (1),
                .ingress_timestamp_valid                (1'b0),
                .ingress_timestamp_96b                  (TX_INGRESS_TIMESTAMP_96B_DATA),
                .ingress_timestamp_64b                  (TX_INGRESS_TIMESTAMP_64B_DATA),
                .ingress_timestamp_format               (PTP_TIMESTAMP_FORMAT_96B)
            );
            repeat (500) @ (posedge tb_top.refclk);    
            
            
            
            // Packet Type:
            //      - Stacked VLAN
            //      - PTP over UDP/IPv6
            //      - PTP Sync Message
            //      - 2-step PTP Packet
            // 2-step Operation:
            //      - Request egress timestamp
            // 1-step Operation:
            //      - No correction field update
            // Expected Result (Channel-0 Ordinary Clock):
            //      - Return egress timestamp
            //      - No change to timestamp field
            //      - No change to correction field
            // Expected Result (Channel-1 End-to-end Transparent Clock):
            //      - No return egress timestamp
            //      - No change to timestamp field
            //      - Correction field updated with residence time
            tb_top.U_AVALON_DRIVER.avalon_st_transmit_ptp_frame_universal(
                .dest_addr                              (MAC_ADDR),
                .src_addr                               (MAC_ADDR),
                .vlan_tag                               (STACK_VLAN),
                .length_type                            (LENGTH_TYPE_IPV6),
                .ip_protocol                            (PROTOCOL_UDP),
                .udp_port                               (UDP_PORT_PTP_EVENT),
                .ptp_message_type                       (MSG_SYNC), 
                .ptp_two_step_flag                      (PTP_TWO_STEP),
                .insert_pad                             (INSERT_PAD),
                .insert_crc                             (NO_INSERT_CRC),
                .egress_timestamp_request_valid         (1'b1),
                .egress_timestamp_request_fingerprint   (2),
                .ingress_timestamp_valid                (1'b0),
                .ingress_timestamp_96b                  (TX_INGRESS_TIMESTAMP_96B_DATA),
                .ingress_timestamp_64b                  (TX_INGRESS_TIMESTAMP_64B_DATA),
                .ingress_timestamp_format               (PTP_TIMESTAMP_FORMAT_96B)
            );
            repeat (500) @ (posedge tb_top.refclk);        
            
            
            
            // Packet Type:
            //      - No VLAN
            //      - PTP over Ethernet
            //      - PTP Delay Request Message
            //      - 1-step PTP Packet
            // 2-step Operation:
            //      - No request egress timestamp
            // 1-step Operation:
            //      - Correction field update (96-bits)
            // Expected Result (Channel-0 Ordinary Clock):
            //      - No return egress timestamp
            //      - No change to timestamp field
            //      - No change to correction field
            // Expected Result (Channel-1 End-to-end Transparent Clock):
            //      - No return egress timestamp
            //      - No change to timestamp field
            //      - Correction field updated with residence time
            tb_top.U_AVALON_DRIVER.avalon_st_transmit_ptp_frame_universal(
                .dest_addr                              (MAC_ADDR),
                .src_addr                               (MAC_ADDR),
                .vlan_tag                               (NO_VLAN),
                .length_type                            (LENGTH_TYPE_PTP),
                .ip_protocol                            (PROTOCOL_UDP),
                .udp_port                               (UDP_PORT_PTP_EVENT),
                .ptp_message_type                       (MSG_DELAY_REQ), 
                .ptp_two_step_flag                      (PTP_ONE_STEP),
                .insert_pad                             (INSERT_PAD),
                .insert_crc                             (NO_INSERT_CRC),
                .egress_timestamp_request_valid         (1'b0),
                .egress_timestamp_request_fingerprint   (3),
                .ingress_timestamp_valid                (1'b1),
                .ingress_timestamp_96b                  (TX_INGRESS_TIMESTAMP_96B_DATA),
                .ingress_timestamp_64b                  (TX_INGRESS_TIMESTAMP_64B_DATA),
                .ingress_timestamp_format               (PTP_TIMESTAMP_FORMAT_96B)
            );
            repeat (500) @ (posedge tb_top.refclk);
            
            
            
            // Packet Type:
            //      - VLAN
            //      - PTP over UDP/IPv4
            //      - PTP Delay Request Message
            //      - 2-step PTP Packet
            // 2-step Operation:
            //      - Request egress timestamp
            // 1-step Operation:
            //      - Correction field update (96-bits)
            // Expected Result (Channel-0 Ordinary Clock):
            //      - Return egress timestamp
            //      - No change to timestamp field
            //      - No change to correction field
            // Expected Result (Channel-1 End-to-end Transparent Clock):
            //      - No return egress timestamp
            //      - No change to timestamp field
            //      - Correction field updated with residence time
            tb_top.U_AVALON_DRIVER.avalon_st_transmit_ptp_frame_universal(
                .dest_addr                              (MAC_ADDR),
                .src_addr                               (MAC_ADDR),
                .vlan_tag                               (VLAN),
                .length_type                            (LENGTH_TYPE_IPV4),
                .ip_protocol                            (PROTOCOL_UDP),
                .udp_port                               (UDP_PORT_PTP_EVENT),
                .ptp_message_type                       (MSG_DELAY_REQ), 
                .ptp_two_step_flag                      (PTP_TWO_STEP),
                .insert_pad                             (INSERT_PAD),
                .insert_crc                             (NO_INSERT_CRC),
                .egress_timestamp_request_valid         (1'b1),
                .egress_timestamp_request_fingerprint   (4),
                .ingress_timestamp_valid                (1'b1),
                .ingress_timestamp_96b                  (TX_INGRESS_TIMESTAMP_96B_DATA),
                .ingress_timestamp_64b                  (TX_INGRESS_TIMESTAMP_64B_DATA),
                .ingress_timestamp_format               (PTP_TIMESTAMP_FORMAT_96B)
            );
            repeat (500) @ (posedge tb_top.refclk);    
            
            
            
            // Packet Type:
            //      - Stacked VLAN
            //      - PTP over UDP/IPv6
            //      - PTP Delay Request Message
            //      - 1-step PTP Packet
            // 2-step Operation:
            //      - Request egress timestamp
            // 1-step Operation:
            //      - Correction field update (64-bits)
            // Expected Result (Channel-0 Ordinary Clock):
            //      - Return egress timestamp
            //      - No change to timestamp field
            //      - No change to correction field
            // Expected Result (Channel-1 End-to-end Transparent Clock):
            //      - No return egress timestamp
            //      - No change to timestamp field
            //      - Correction field updated with residence time
            tb_top.U_AVALON_DRIVER.avalon_st_transmit_ptp_frame_universal(
                .dest_addr                              (MAC_ADDR),
                .src_addr                               (MAC_ADDR),
                .vlan_tag                               (STACK_VLAN),
                .length_type                            (LENGTH_TYPE_IPV6),
                .ip_protocol                            (PROTOCOL_UDP),
                .udp_port                               (UDP_PORT_PTP_EVENT),
                .ptp_message_type                       (MSG_DELAY_REQ), 
                .ptp_two_step_flag                      (PTP_ONE_STEP),
                .insert_pad                             (INSERT_PAD),
                .insert_crc                             (NO_INSERT_CRC),
                .egress_timestamp_request_valid         (1'b1),
                .egress_timestamp_request_fingerprint   (5),
                .ingress_timestamp_valid                (1'b0),
                .ingress_timestamp_96b                  (TX_INGRESS_TIMESTAMP_96B_DATA),
                .ingress_timestamp_64b                  (TX_INGRESS_TIMESTAMP_64B_DATA),
                .ingress_timestamp_format               (PTP_TIMESTAMP_FORMAT_64B)
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
