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




`ifndef TB_TESTCASE_SV
`define TB_TESTCASE_SV

`include "default_test_params_pkg.sv"
`include "eth_mac_frame.sv"
`include "avalon_if_params_pkg.sv"

`timescale 1fs / 1fs

    
// Test case specific testbench
module tb_testcase(
    input clk,
    input reset
    );
    
    
    parameter DUT_READY_TIMEOUT                 = 100_000;
    localparam NUM_TRANSMIT_FRAMES_PER_SPEED    = 3;
    localparam FRAMESOK_SIZE                    = 12;
    // Get the register map definition from the package
    import eth_register_map_params_pkg::*;
    
    //Get test parameter from the package
    import default_test_params_pkt::*;

    // Get the Avalon interface parameters definition from the package
    import avalon_if_params_pkt::*;
    
    
    
    reg [17:0] dut_ready_timeout_counter;
    reg [1:0]  current_speed = 2'bxx;
    bit [31:0] readdata = 32'h0;
    reg [8:0] tx_frame_count = 9'h0;
    bit error;
    bit [63:0] framesOK_1;
    bit [63:0] framesOK_2;
     
    initial begin
  
        static reg [1:0] speed_array[4] = {ETH_SPEED_10G,ETH_SPEED_1G,ETH_SPEED_100M,ETH_SPEED_10M};
      
        while(tb_top.reset !== 1'b0) begin
            @(posedge clk);
        end
         
          
        // tb_top.configure_csr_speed_n(CHANNEL_START_ADDR+PHY_0_ADDR, speed_array[0]);  
    
        $display("\n********************************************************************");
        $display("\n                 START SIMULATION");   
        $display("\n********************************************************************");
    
        foreach(speed_array[speed]) begin
            $display("===================================================================");
            $display("\nRunning in speed: %s", (speed_array[speed] == ETH_SPEED_10G) ? "10Gbps" : 
                                               (speed_array[speed] == ETH_SPEED_1G) ? "1Gbps" : 
                                               (speed_array[speed] == ETH_SPEED_100M) ? "100Mbps" : 
                                               "10Mbps");
            $display("\n===================================================================\n");
            // ReConfigure Speed 
                
            repeat(5) @(posedge clk);
    
            // Wait until DUT is ready
            dut_ready_timeout_counter = 0;
    
            $display("%t configure csr speed register", $time());
            tb_top.configure_csr_speed_n(CHANNEL_START_ADDR+PHY_0_ADDR, speed_array[speed]); 
              
            current_speed = speed_array[speed];
            // Configure MAC for N channels
            tb_top.configure_csr_basic_n(CHANNEL_START_ADDR + MAC_0_ADDR);  
       
            // configure PHY
                
            if(speed_array[speed] == ETH_SPEED_1G ||
               speed_array[speed] == ETH_SPEED_100M ||
               speed_array[speed] == ETH_SPEED_10M
              ) begin
                tb_top.configure_csr_phy_n(CHANNEL_START_ADDR+PHY_0_ADDR, speed_array[speed]);
            end
               
            //configure RX FIFO   
            //tb_top.configure_fifo_n(CHANNEL_START_ADDR+RX_FIFO_0_ADDR);
                    
            while((tb_top.channel_ready !== {NUM_CHANNELS{1'b1}}) && dut_ready_timeout_counter < DUT_READY_TIMEOUT) begin
                dut_ready_timeout_counter++;
                @(posedge clk);
            end
                        
            if(dut_ready_timeout_counter >= DUT_READY_TIMEOUT) begin
                $display("%t Error - Timeout was reached before DUT is ready!", $time());
                $finish();
            end
            
            repeat(5000) @(posedge clk);
                  
            tx_frame_count = tx_frame_count +NUM_TRANSMIT_FRAMES_PER_SPEED;
                
            // Send Ethernet packet through Avalon-ST TX path
            U_AVALON_DRIVER.avalon_st_transmit_data_frame(MAC_ADDR, MAC_ADDR, 64, INSERT_PAD, INSERT_CRC);
//            U_AVALON_DRIVER.avalon_st_transmit_vlan_frame(MULTICAST_ADDR, MAC_ADDR, VLAN_INFO, 1500, INSERT_PAD, INSERT_CRC);
//            U_AVALON_DRIVER.avalon_st_transmit_data_frame(MAC_ADDR, MAC_ADDR, 1500, INSERT_PAD, INSERT_CRC);
            U_AVALON_DRIVER.avalon_st_transmit_svlan_frame(BROADCAST_ADDR, MAC_ADDR, VLAN_INFO, SVLAN_INFO, 64, INSERT_PAD, INSERT_CRC);
            U_AVALON_DRIVER.avalon_st_transmit_vlan_frame(UNICAST_ADDR, MAC_ADDR, VLAN_INFO, 500, INSERT_PAD, INSERT_CRC);
//            U_AVALON_DRIVER.avalon_st_transmit_svlan_frame(MAC_ADDR, INVALID_ADDR, VLAN_INFO, SVLAN_INFO, 1500, INSERT_PAD, INSERT_CRC);
    
            // Wait until all packet received at avalon ST if
            while (tb_top.U_MON_RX.mac_frame_q.size() !== tx_frame_count)  begin
                @(posedge clk);
            end
        end
          
             
        repeat(500) @(posedge clk);
        tb_top.display_statistics(CHANNEL_START_ADDR + MAC_0_ADDR);
            
        tb_top.compare_eth_statistics(CHANNEL_START_ADDR + MAC_0_ADDR + TX_STATISTICS_ADDR, CHANNEL_START_ADDR + MAC_0_ADDR + RX_STATISTICS_ADDR, error, framesOK_1, framesOK_2);

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
