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
`include "avalon_if_params_pkg.sv"
`include "avalon_st_eth_packet_monitor.sv"
`include "default_test_params_pkg.sv"
`include "eth_mac_frame.sv"
`include "ptp_timestamp.sv"
`include "tb_testcase.sv"

`timescale 1fs / 1fs

// Top level testbench
module tb_top;
    
    // Get the Avalon interface parameters definition from the package
    import avalon_if_params_pkt::*;
    
    // Get the register map definition from the package
    import eth_register_map_params_pkg::*;
    
    //Get test parameter from the package
    import default_test_params_pkt::*;
    
    // Clock and Reset signals
   
	 
	 wire			 xgmii_clk;
	 wire        clk_156_25;
    reg         ref_clk_10g;
    reg         ref_clk_1g;
    reg         clk_100;
    reg         reset;
    reg         reset_n;    
    // Avalon-MM CSR signals
    wire [19:0] avalon_mm_csr_address;
    wire        avalon_mm_csr_read;
    wire [31:0] avalon_mm_csr_readdata;
    wire        avalon_mm_csr_write;
    wire [31:0] avalon_mm_csr_writedata;
    wire        avalon_mm_csr_waitrequest;
    
    // Avalon-ST TX signals
    wire        avalon_st_tx_startofpacket;
    wire        avalon_st_tx_endofpacket;
    wire        avalon_st_tx_valid;
    wire        avalon_st_tx_ready;
    wire [63:0] avalon_st_tx_data;
    wire [2:0]  avalon_st_tx_empty;
    wire        avalon_st_tx_error;
    
    // Avalon-ST RX signals
    wire        avalon_st_rx_startofpacket;
    wire        avalon_st_rx_endofpacket;
    wire        avalon_st_rx_valid;
    wire        avalon_st_rx_ready;
    wire [63:0] avalon_st_rx_data;
    wire [2:0]  avalon_st_rx_empty;
    wire [5:0]  avalon_st_rx_error;
   
	 // Serial data
	 wire  	 [NUM_CHANNELS-1:0]          									rx_serial_data;
    wire  	 [NUM_CHANNELS-1:0]          									tx_serial_data;
    wire  	 [NUM_CHANNELS-1:0]          									serial_data_loopback;

    wire  	 [NUM_CHANNELS-1:0]          									channel_ready;
	

 // Clock and reset generation
    initial clk_100 = 1'b0;
    always #5000000 clk_100 = ~clk_100;
	 
	 reg clk_200;
	initial clk_200 = 1'b0;
    always #2500000 clk_200 = ~clk_200;
	 
	 
	 initial ref_clk_10g = 1'b0;
    always #775760 ref_clk_10g = ~ref_clk_10g;

    initial ref_clk_1g = 1'b0;
    always #4000000 ref_clk_1g = ~ref_clk_1g;

	 
	initial begin
        reset = 1'b0;
        #1 reset = 1'b1;
        #40000000 reset = 1'b0;
    end
    

    assign reset_n = !reset;

  
  
   // Assign clock signals
    assign avalon_mm_csr_clk    = clk_100;
    assign avalon_st_tx_clk     = xgmii_clk;
    assign avalon_st_rx_clk     = xgmii_clk;
	 assign clk_156_25			  = xgmii_clk;
    wire channel_loopback_fifo_reset;
    
  
  genvar i;
  generate
	
	
	if (NUM_CHANNELS >1)
	
	 begin
	
		
  
    // Loopback for channel-1 packet interface
    wire     [NUM_CHANNELS-2:0]   				avalon_st_lb_rx_startofpacket;
    wire     [NUM_CHANNELS-2:0]   				avalon_st_lb_rx_endofpacket;
    wire     [NUM_CHANNELS-2:0]   				avalon_st_lb_rx_valid;
    wire     [NUM_CHANNELS-2:0]   				avalon_st_lb_rx_ready;
    wire 	 [NUM_CHANNELS-2:0][63:0]		 	avalon_st_lb_rx_data;
    wire 	 [NUM_CHANNELS-2:0][2:0] 			avalon_st_lb_rx_empty;
    wire 	 [NUM_CHANNELS-2:0][5:0]  			avalon_st_lb_rx_error;
    
    wire     [NUM_CHANNELS-2:0]   				avalon_st_lb_tx_startofpacket;
    wire     [NUM_CHANNELS-2:0]   				avalon_st_lb_tx_endofpacket;
    wire     [NUM_CHANNELS-2:0]   				avalon_st_lb_tx_valid;
    wire     [NUM_CHANNELS-2:0]   				avalon_st_lb_tx_ready;
    wire 	 [NUM_CHANNELS-2:0][63:0]		 	avalon_st_lb_tx_data;
    wire 	 [NUM_CHANNELS-2:0][2:0] 			avalon_st_lb_tx_empty;
    wire 	 [NUM_CHANNELS-2:0]  				avalon_st_lb_tx_error;

  	
				
	 altera_eth_multi_channel #(
			.NUM_CHANNELS (NUM_CHANNELS),					// range from 1-12
			.SV_RCN_BUNDLE_MODE (1),          			// mode0-10GBaseKR, mode1-1G10G without 1588, mode2 -1G10G with 1588  
			.FIFO_OPTIONS			(3),						//0- disable, 1-sc, 2-dc, 3-sc+dc
			.SHARED_REFCLK_EN (1),
			.MDIO_MDC_CLOCK_DIVISOR	(32)		//MDIO
			
	   ) dut (
        .mm_clk                           (clk_100),
       .pll_ref_clk_1g                            	(ref_clk_1g),
    	  .pll_ref_clk_10g                           	(ref_clk_10g),

		  .cdr_ref_clk_10g	 									(ref_clk_10g),            
		  .cdr_ref_clk_1g	 									(ref_clk_1g),                 		                     
		  .rx_recovered_clk										(),		

        .xgmii_clk                        (xgmii_clk),
        
		  .channel_reset_n						({NUM_CHANNELS{reset_n}}),
        .master_reset_n                   (reset_n),
		  
		  .dc_fifo_tx_clk							(avalon_st_tx_clk),
        .dc_fifo_rx_clk       				(avalon_st_rx_clk),
        //perform circle looopback ,for example: NUM_CHANNELS = 4
		  // tx_serial_data[0] = rx_serial_data[1]= serial_data_loopback[0]
		  // tx_serial_data[1] = rx_serial_data[2]= serial_data_loopback[1]    ---> tx_serial_data = serial_data_loopback
		  // tx_serial_data[2] = rx_serial_data[3]= serial_data_loopback[2]         rx_serial_data = {serial_data_loopback[NUM_CHANNELS-2:0], serial_data_loopback[NUM_CHANNELS-1]}
		  // tx_serial_data[3] = rx_serial_data[0]= serial_data_loopback[3] 
		  
		  .rx_serial_data                   ({serial_data_loopback[NUM_CHANNELS-2:0], serial_data_loopback[NUM_CHANNELS-1]}),
        .tx_serial_data                   (serial_data_loopback),
       
        .channel_ready                     (channel_ready),
		  
        .avalon_st_tx_startofpacket       ({avalon_st_lb_tx_startofpacket,avalon_st_tx_startofpacket}),
        .avalon_st_tx_endofpacket         ({avalon_st_lb_tx_endofpacket,avalon_st_tx_endofpacket}),
        .avalon_st_tx_valid               ({avalon_st_lb_tx_valid,avalon_st_tx_valid}),
        .avalon_st_tx_ready               ({avalon_st_lb_tx_ready,avalon_st_tx_ready}),
        .avalon_st_tx_data                ({avalon_st_lb_tx_data,avalon_st_tx_data}),
        .avalon_st_tx_empty               ({avalon_st_lb_tx_empty,avalon_st_tx_empty}),
        .avalon_st_tx_error               ({avalon_st_lb_tx_error,avalon_st_tx_error}),
    
        .avalon_st_rx_startofpacket    	({avalon_st_lb_rx_startofpacket,avalon_st_rx_startofpacket}),
        .avalon_st_rx_endofpacket      	({avalon_st_lb_rx_endofpacket,avalon_st_rx_endofpacket}),
        .avalon_st_rx_valid            	({avalon_st_lb_rx_valid,avalon_st_rx_valid}),
        .avalon_st_rx_ready            	({avalon_st_lb_rx_ready,avalon_st_rx_ready}),
        .avalon_st_rx_data             	({avalon_st_lb_rx_data,avalon_st_rx_data}),
        .avalon_st_rx_empty            	({avalon_st_lb_rx_empty,avalon_st_rx_empty}),
        .avalon_st_rx_error             	({avalon_st_lb_rx_error,avalon_st_rx_error}),
    
        
        .address                  			(avalon_mm_csr_address),
        .waitrequest              			(avalon_mm_csr_waitrequest),
        .read                     			(avalon_mm_csr_read),       
        .readdata                 			(avalon_mm_csr_readdata),   
        .write                    			(avalon_mm_csr_write),      
        .writedata                			(avalon_mm_csr_writedata),

		  .avalon_st_tx_status_valid                 (),
        .avalon_st_tx_status_error                 (),
        .avalon_st_tx_status_data                  (),
        .avalon_st_rx_status_valid                 (),
        .avalon_st_rx_status_error                 (),
        .avalon_st_rx_status_data                  (),
		  
	.avalon_st_pause_data			   (),
	.ethernet_1g_an				   (),
	.ethernet_1g_char_err			   (),
	.ethernet_1g_disp_err			   (),
	.mdio_mdc				   (),
	.mdio_in				   (),
	.mdio_out				   (),
	.mdio_oen				   ()
  
        );
		
	
 
  
   altera_reset_synchronizer
        #(
            .DEPTH      (2),
            .ASYNC_RESET(1)
        )
        alt_eth_rst_sync_channel_loopback_fifo
        (
            .clk        (xgmii_clk),
            .reset_in   (reset),
            .reset_out  (channel_loopback_fifo_reset)
        );
 
   //data loopback fifo 
   for (i= 0; i <NUM_CHANNELS-1;i++)
	 begin: DATA_LOOPBACK_FIFO_LOOP
		 altera_avalon_sc_fifo  #(
			  .SYMBOLS_PER_BEAT    (8),
			  .BITS_PER_SYMBOL     (8),
			  .FIFO_DEPTH          (256), // equivalent to 2048 bytes
			  .CHANNEL_WIDTH       (0), 
			  .ERROR_WIDTH         (1),
			  .USE_PACKETS         (1),
			  .USE_FILL_LEVEL      (0),
			  .EMPTY_LATENCY       (3),
			  .USE_MEMORY_BLOCKS   (1),
			  .USE_STORE_FORWARD   (1),
			  .USE_ALMOST_FULL_IF  (0),
			  .USE_ALMOST_EMPTY_IF (0)
		 ) data_loopback_fifo (
			  .clk               (xgmii_clk),
			  .reset             (channel_loopback_fifo_reset),
			  .csr_address       (3'b0),
			  .csr_read          (1'b0),
			  .csr_write         (1'b0),
			  .csr_readdata      (),
			  .csr_writedata     (32'b0),
			  .in_data           (avalon_st_lb_rx_data[i]),
			  .in_valid          (avalon_st_lb_rx_valid[i]),
			  .in_ready          (avalon_st_lb_rx_ready[i]),
			  .in_startofpacket  (avalon_st_lb_rx_startofpacket[i]),
			  .in_endofpacket    (avalon_st_lb_rx_endofpacket[i]),
			  .in_empty          (avalon_st_lb_rx_empty[i]),
			  .in_error          (|avalon_st_lb_rx_error[i]),
			  .out_data          (avalon_st_lb_tx_data[i]),
			  .out_valid         (avalon_st_lb_tx_valid[i]),
			  .out_ready         (avalon_st_lb_tx_ready[i]),
			  .out_startofpacket (avalon_st_lb_tx_startofpacket[i]),
			  .out_endofpacket   (avalon_st_lb_tx_endofpacket[i]),
			  .out_empty         (avalon_st_lb_tx_empty[i]),
			  .out_error         (avalon_st_lb_tx_error[i]),
			  .almost_full_data  (),
			  .almost_empty_data (),
			  .in_channel        (1'b0),
			  .out_channel       ()
		 );
    
     end
	
 
   end
  

  
 else
  
   begin
	

	
	altera_eth_multi_channel #(
	 
	 		.NUM_CHANNELS (NUM_CHANNELS),					// range from 1-12
			.SV_RCN_BUNDLE_MODE (1),          // mode0-10GBaseKR, mode1-1G10G without 1588, mode2 -1G10G with 1588  
			.FIFO_OPTIONS		  (3),				//0- disable, 1-sc, 2-dc, 3-sc+dc
			.SHARED_REFCLK_EN (1),
			.MDIO_MDC_CLOCK_DIVISOR	(32)		//MDIO
	
	 ) dut (
        .mm_clk                           (clk_100),
       .pll_ref_clk_1g                            	(ref_clk_1g),
    	  .pll_ref_clk_10g                           	(ref_clk_10g),

		  .cdr_ref_clk_10g	 									(ref_clk_10g),            
		  .cdr_ref_clk_1g	 									(ref_clk_1g),                 		                     
		  .rx_recovered_clk										(),		

        .xgmii_clk                        (xgmii_clk),
        
		  .channel_reset_n						({NUM_CHANNELS{reset_n}}),
        .master_reset_n                   (reset_n),
		  		  
		  .dc_fifo_tx_clk							(avalon_st_tx_clk),
        .dc_fifo_rx_clk       				(avalon_st_rx_clk),
		  
        .rx_serial_data                   (serial_data_loopback),
        .tx_serial_data                   (serial_data_loopback),
		  
        .channel_ready                    (channel_ready),
       
    
        .avalon_st_tx_startofpacket       (avalon_st_tx_startofpacket),
        .avalon_st_tx_endofpacket         (avalon_st_tx_endofpacket),
        .avalon_st_tx_valid               (avalon_st_tx_valid),
        .avalon_st_tx_ready               (avalon_st_tx_ready),
        .avalon_st_tx_data                (avalon_st_tx_data),
        .avalon_st_tx_empty               (avalon_st_tx_empty),
        .avalon_st_tx_error               (avalon_st_tx_error),
    
        .avalon_st_rx_startofpacket    	(avalon_st_rx_startofpacket),
        .avalon_st_rx_endofpacket      	(avalon_st_rx_endofpacket),
        .avalon_st_rx_valid            	(avalon_st_rx_valid),
        .avalon_st_rx_ready            	(avalon_st_rx_ready),
        .avalon_st_rx_data             	(avalon_st_rx_data),
        .avalon_st_rx_empty            	(avalon_st_rx_empty),
        .avalon_st_rx_error             	(avalon_st_rx_error),
    
        
        .address                  			(avalon_mm_csr_address),
        .waitrequest              			(avalon_mm_csr_waitrequest),
        .read                     			(avalon_mm_csr_read),       
        .readdata                 			(avalon_mm_csr_readdata),   
        .write                    			(avalon_mm_csr_write),      
        .writedata                			(avalon_mm_csr_writedata),

        .avalon_st_tx_status_valid                 (),
        .avalon_st_tx_status_error                 (),
        .avalon_st_tx_status_data                  (),
        .avalon_st_rx_status_valid                 (),
        .avalon_st_rx_status_error                 (),
        .avalon_st_rx_status_data                  ()
		  
        );
		
	  
	
	end
  
  
endgenerate
	
   
   
   
        
    //Implement all the test case in tb_testcase.v
    tb_testcase TESTCASE (
        .clk(xgmii_clk),
        .reset(reset)
    );
    
    
    
    // Avalon-MM and Avalon-ST signals driver
    avalon_driver U_AVALON_DRIVER (
        .avalon_mm_csr_clk          (clk_100),
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
        .avalon_st_tx_error         (avalon_st_tx_error),
        
	.tx_egress_timestamp_request_valid		(),
	.tx_egress_timestamp_request_fingerprint	(),
	.tx_ingress_timestamp_valid			(),
	.tx_ingress_timestamp_96b_data			(),
	.tx_ingress_timestamp_64b_data			(),
	.tx_ingress_timestamp_format			()    

    );
    

    // Ethernet packet monitor on Avalon-ST RX path
    avalon_st_eth_packet_monitor #(
        .ST_ERROR_W                 (AVALON_ST_RX_ST_ERROR_W)
    ) U_MON_RX (
        .clk                        (xgmii_clk),
        .reset                      (reset),
        
        .startofpacket              (avalon_st_rx_startofpacket),
        .endofpacket                (avalon_st_rx_endofpacket),
        .valid                      (avalon_st_rx_valid),
        .ready                      (avalon_st_rx_ready),
        .data                       (avalon_st_rx_data),
        .empty                      (avalon_st_rx_empty),
        .error                      (avalon_st_rx_error)
    );
    
   // To elimiate 'x' case (set to '0') when these signals are not driven
    bit tx_sop ;
    bit tx_eop ;

    assign tx_sop = (avalon_st_tx_startofpacket & avalon_st_tx_valid)==1 ? avalon_st_tx_startofpacket : 1'b0;
    assign tx_eop = (avalon_st_tx_endofpacket & avalon_st_tx_valid)==1 ? avalon_st_tx_endofpacket : 1'b0;

    
    // Ethernet packet monitor on Avalon-ST TX path
    avalon_st_eth_packet_monitor #(
        .ST_ERROR_W (AVALON_ST_TX_ST_ERROR_W)
    ) U_MON_TX (
        .clk                        (xgmii_clk),
        .reset                      (reset),
        
        .startofpacket              (tx_sop),
        .endofpacket                (tx_eop),
        .valid                      (avalon_st_tx_valid),
        .ready                      (avalon_st_tx_ready),
        .data                       (avalon_st_tx_data),
        .empty                      (avalon_st_tx_empty),
        .error                      (avalon_st_tx_error)
    );



    // Data read from CSR
    bit [31:0]  readdata;
    int unsigned id;
    
	
	// configure N channels
	
	 task automatic configure_csr_basic_n (bit [31:0] address_offset);
		for (id=0; id<NUM_CHANNELS;id++)
			begin
				configure_csr_basic(address_offset + 32'h10000*id);
			end
	 endtask
	 
	 task automatic configure_csr_phy_n (bit [31:0] address_offset, bit[1:0] speed);
		for (id=0; id<NUM_CHANNELS;id++)
			begin
				configure_csr_phy(address_offset + 32'h10000*id, speed);
			end
	 endtask
	 
	  task automatic configure_fifo_n (bit [31:0] address_offset);
		for (id=0; id<NUM_CHANNELS;id++)
			begin
				configure_fifo(address_offset + 32'h10000*id);
			end
	 endtask
	
    task automatic configure_csr_speed_n (bit [31:0] address_offset,bit [1:0] speed);
		for (id=0; id<NUM_CHANNELS;id++)
			begin
			configure_csr_speed(address_offset+ 32'h10000*id,speed);
			end
	 endtask
	
	task automatic display_statistics_n (bit [31:0] address_offset);
		for (id=0; id<NUM_CHANNELS;id++)
		  begin
			display_statistics(address_offset + 32'h10000*id);
		  end
	 endtask
	
	//end 
	
	// CSR Configuration
    task automatic configure_csr_basic(bit [31:0] address_offset);
        // TX CRC Inserter
        // Enable CRC insertion on TX
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + TX_CRC_INSERT_CONTROL_ADDR, {1'b1, 1'b1});
        
        // TX Address Inserter
        // Enable source address insertion on TX
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + TX_ADDRESS_INSERT_CONTROL_ADDR, 1);    
        
        // Configure unicast address for TX
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + TX_ADDRESS_INSERT_UCAST_MAC_ADD_0_ADDR, MAC_ADDR[31:0]);
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + TX_ADDRESS_INSERT_UCAST_MAC_ADD_1_ADDR, MAC_ADDR[47:32]);   

        // Configure frame address for RX
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + RX_FRAME_0_ADDR, MAC_ADDR[31:0]);
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + RX_FRAME_1_ADDR, MAC_ADDR[47:32]);
    endtask
    
    
    task automatic configure_csr_phy(bit [31:0] address_offset, bit [1:0] speed);
        // Configure 1GbE PCS Auto-negotiation
        U_AVALON_DRIVER.avalon_mm_csr_rd(address_offset + PHY_GIGE_PCS_REG_ADDR, readdata);
        readdata[PHY_GIGE_PCS_AN_OFFSET] = 1'b0;
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + PHY_GIGE_PCS_REG_ADDR, readdata);
		  
		 U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + PHY_GIGE_PCS_IF_MODE_ADDR, {{28{1'b0}}, ~speed, 1'b0, 1'b1});

    endtask
    
    task automatic configure_fifo (bit [31:0] address_offset);
	 // Configure the RX FIFO
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset+ RX_FIFO_DROP_ON_ERROR_OFFSET, RX_FIFO_DROP_ON_ERROR);
	 endtask
       
    // speed = 0: 10GbE
    // speed = 1: 10/100/1000
    task automatic configure_csr_speed(bit [31:0] address_offset, bit [1:0] speed);
 		 U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + RECONFIG_SPEED_ADDR, (|speed) ? 32'h11 : 32'h41);
    endtask
     
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
