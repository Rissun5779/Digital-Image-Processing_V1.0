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
`include "tb_testcase_1588.sv"

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
    reg         ref_clk_644;
    reg         ref_clk_125;
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

 
   
	 // Timestamp request
    wire                                        						tx_egress_timestamp_request_valid;
    wire      [TSTAMP_FP_WIDTH - 1:0]           						tx_egress_timestamp_request_fingerprint;
    
    // Timestamp correction
    wire                                        						tx_ingress_timestamp_valid;
    wire      [95:0]             											tx_ingress_timestamp_96b_data;
    wire      [63:0]      														tx_ingress_timestamp_64b_data;
    wire                                                          tx_ingress_timestamp_format;
    

  // RX timestamp
    wire                                       							rx_ingress_timestamp_96b_valid;
    wire      [95:0]                            						rx_ingress_timestamp_96b_data;
    
    wire                                       							rx_ingress_timestamp_64b_valid;
    wire      [63:0]                            						rx_ingress_timestamp_64b_data;
	 

    // output TX timestamp and fingerprint
    wire      [NUM_CHANNELS-1:0]                                  tx_egress_timestamp_96b_valid;
    wire      [NUM_CHANNELS-1:0][95:0]                            tx_egress_timestamp_96b_data;
    wire      [NUM_CHANNELS-1:0][TSTAMP_FP_WIDTH - 1:0]           tx_egress_timestamp_96b_fingerprint;
    
    wire      [NUM_CHANNELS-1:0]                                  tx_egress_timestamp_64b_valid;
    wire      [NUM_CHANNELS-1:0][63:0]                            tx_egress_timestamp_64b_data;
    wire      [NUM_CHANNELS-1:0][TSTAMP_FP_WIDTH - 1:0]           tx_egress_timestamp_64b_fingerprint;

  	 wire		  [NUM_CHANNELS-1:0]												start_tod_sync;

    wire																				master_pulse_per_second;
    wire      [NUM_CHANNELS-1:0]                                  pps_10g;
    wire      [NUM_CHANNELS-1:0]                                  pps_1g;
	reg 	  [1:0]							  					  ext_mode_1g_10gbar;
 
    wire      [NUM_CHANNELS-1:0]                                  channel_ready;
    bit      [NUM_CHANNELS-1:0][1:0]                             	clock_mode; 
  
    bit tx_ts_req_valid ;
    bit tx_ts_valid ;
    
	 assign tx_ts_req_valid = (tx_egress_timestamp_request_valid & avalon_st_tx_valid)==1 ? tx_egress_timestamp_request_valid : 1'b0;
    assign tx_ts_valid = (tx_ingress_timestamp_valid & avalon_st_tx_valid)==1 ? tx_ingress_timestamp_valid : 1'b0;
    
   

 // Clock and reset generation
    initial clk_100 = 1'b0;
    always #5000000 clk_100 = ~clk_100;
	 
	 initial ref_clk_644 = 1'b0;
// change to frequency of 644.53125 MHz
      always #775758 ref_clk_644 = ~ref_clk_644;

    initial ref_clk_125 = 1'b0;
    always #4000000 ref_clk_125 = ~ref_clk_125;

	 
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

   // Loopback  timestamp interface
    wire      [NUM_CHANNELS-2:0]                         lb_rx_ingress_timestamp_96b_valid;
    wire      [NUM_CHANNELS-2:0][95:0]                   lb_rx_ingress_timestamp_96b_data;
    wire      [NUM_CHANNELS-2:0]                         lb_rx_ingress_timestamp_64b_valid;
    wire      [NUM_CHANNELS-2:0][63:0]                   lb_rx_ingress_timestamp_64b_data;
    
    wire      [NUM_CHANNELS-2:0]                         lb_tx_ingress_timestamp_96b_valid;
    wire      [NUM_CHANNELS-2:0][95:0]                   lb_tx_ingress_timestamp_96b_data;
    wire      [NUM_CHANNELS-2:0]                         lb_tx_ingress_timestamp_64b_valid;
    wire      [NUM_CHANNELS-2:0][63:0]                   lb_tx_ingress_timestamp_64b_data;
    
    wire      [NUM_CHANNELS-2:0]                         lb_tx_ingress_timestamp_format;
    
    assign lb_tx_ingress_timestamp_format = {(NUM_CHANNELS-1){PTP_TIMESTAMP_FORMAT_96B}};
   	 
		
				
	 altera_eth_multi_channel_1588 #(
			.NUM_CHANNELS (NUM_CHANNELS),					// range from 1-12
			.TSTAMP_FP_WIDTH (TSTAMP_FP_WIDTH),			//Fingerprint Width follow the setting in MAC 1588 GUI
			.SV_RCN_BUNDLE_MODE (2),          			// mode0-10GBaseKR, mode1-1G10G without 1588, mode2 -1G10G with 1588  
			.MDIO_MDC_CLOCK_DIVISOR	(32),					//MDIO
			.SHARED_REFCLK_EN (1)
			
	   ) dut (
        .mm_clk                           (clk_100),
        .pll_ref_clk_1g                   (ref_clk_125),
        .pll_ref_clk_10g                  (ref_clk_644),
        .cdr_ref_clk_1g                   (ref_clk_125),
        .cdr_ref_clk_10g                  (ref_clk_644),
        .master_reset_n                   (reset_n),
        .channel_reset_n		  ({NUM_CHANNELS{reset_n}}),
        .xgmii_clk                        (xgmii_clk),
    
        //perform circle looopback ,for example: NUM_CHANNELS = 4
		  // tx_serial_data[0] = rx_serial_data[1]= serial_data_loopback[0]
		  // tx_serial_data[1] = rx_serial_data[2]= serial_data_loopback[1]    ---> tx_serial_data = serial_data_loopback
		  // tx_serial_data[2] = rx_serial_data[3]= serial_data_loopback[2]         rx_serial_data = {serial_data_loopback[NUM_CHANNELS-2:0], serial_data_loopback[NUM_CHANNELS-1]}
		  // tx_serial_data[3] = rx_serial_data[0]= serial_data_loopback[3] 
		  
		.rx_serial_data                   ({serial_data_loopback[NUM_CHANNELS-2:0], serial_data_loopback[NUM_CHANNELS-1]}),
        .tx_serial_data                   (serial_data_loopback),
       
    
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
	
		  .avalon_st_pause_data							({NUM_CHANNELS{2'h0}}),  //adding
		  .ethernet_1g_an                  				(), 
		  .ethernet_1g_char_err            				(), 
		  .ethernet_1g_disp_err            				(), 	
        
        .tx_egress_timestamp_request_in_valid      ({{(NUM_CHANNELS-1){1'b0}},tx_ts_req_valid}),
        .tx_egress_timestamp_request_in_fingerprint  ({{(NUM_CHANNELS-1){4'h0}},tx_egress_timestamp_request_fingerprint}),
        
        .tx_ingress_timestamp_valid               ({lb_tx_ingress_timestamp_96b_valid,tx_ts_valid}),
        .tx_ingress_timestamp_96b_data            ({lb_tx_ingress_timestamp_96b_data,tx_ingress_timestamp_96b_data}),
        .tx_ingress_timestamp_64b_data            ({lb_tx_ingress_timestamp_64b_data,tx_ingress_timestamp_64b_data}),
        .tx_ingress_timestamp_format              ({lb_tx_ingress_timestamp_format,tx_ingress_timestamp_format}),
        
        .tx_egress_timestamp_96b_valid            (tx_egress_timestamp_96b_valid),
        .tx_egress_timestamp_96b_data             (tx_egress_timestamp_96b_data),
        .tx_egress_timestamp_96b_fingerprint      (tx_egress_timestamp_96b_fingerprint),
        
        .tx_egress_timestamp_64b_valid            (tx_egress_timestamp_64b_valid),
        .tx_egress_timestamp_64b_data             (tx_egress_timestamp_64b_data),
        .tx_egress_timestamp_64b_fingerprint      (tx_egress_timestamp_64b_fingerprint),
        
        .rx_ingress_timestamp_96b_valid           ({lb_rx_ingress_timestamp_96b_valid,rx_ingress_timestamp_96b_valid}),
        .rx_ingress_timestamp_96b_data            ({lb_rx_ingress_timestamp_96b_data,rx_ingress_timestamp_96b_data}),
        
        .rx_ingress_timestamp_64b_valid           ({lb_rx_ingress_timestamp_64b_valid,rx_ingress_timestamp_64b_valid}),
        .rx_ingress_timestamp_64b_data            ({lb_rx_ingress_timestamp_64b_data, rx_ingress_timestamp_64b_data}),
        
        .master_pulse_per_second						  (master_pulse_per_second),
        .pulse_per_second_10g                     (pps_10g),
        .pulse_per_second_1g                      (pps_1g),
        .start_tod_sync							  ({NUM_CHANNELS{1'b1}}),  //need to provide input for this
        .channel_ready                            (channel_ready),
              
        // Configuration
        .clock_operation_mode_mode                (clock_mode),
        .pkt_with_crc_mode                        ({NUM_CHANNELS{1'b0}}),

	.rx_recovered_clk			  (),
        .mdio_mdc                                 (),
        .mdio_in                                  (),
        .mdio_out                                 (),
        .mdio_oen                                 ()
		 
        );
		
	
 
  
   altera_reset_synchronizer
        #(
            .DEPTH      (2),
            .ASYNC_RESET(1)
        )
        alt_eth_rst_sync_channel_loopback_fifo
        (
            .clk        (clk_156_25),
            .reset_in   (reset),
            .reset_out  (channel_loopback_fifo_reset)
        );
 
   //data loopback fifo 
   for (i= 0; i <NUM_CHANNELS-1;i++)
	 begin: DATA_LOOPBACK_FIFO_LOOP
		 altera_avalon_sc_fifo  #(
			  .SYMBOLS_PER_BEAT    (8),
			  .BITS_PER_SYMBOL     (8),
			  .FIFO_DEPTH          (512), // equivalent to 2048 bytes
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
			  .clk               (clk_156_25),
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
	 
 
 // timestamp loopback fifo Assume no packet drop by the data FIFO	
	for (i= 0; i <NUM_CHANNELS-1;i++)
	 begin: TIMESTAMP_LOOPBACK_FIFO_LOOP
	
    altera_avalon_sc_fifo  #(
        .SYMBOLS_PER_BEAT    (1),
        .BITS_PER_SYMBOL     (1 + 1 + TIMESTAMP_96B_WIDTH + TIMESTAMP_64B_WIDTH),
        .FIFO_DEPTH          (2048/64), // maximum number of packet stored in data FIFO
        .CHANNEL_WIDTH       (0), 
        .ERROR_WIDTH         (0),
        .USE_PACKETS         (0),
        .USE_FILL_LEVEL      (0),
        .EMPTY_LATENCY       (3),
        .USE_MEMORY_BLOCKS   (1),
        .USE_STORE_FORWARD   (0),
        .USE_ALMOST_FULL_IF  (0),
        .USE_ALMOST_EMPTY_IF (0)
    ) timestamp_loopback_fifo (
        .clk               (clk_156_25),
        .reset             (channel_loopback_fifo_reset),
        .csr_address       (2'b0),
        .csr_read          (1'b0),
        .csr_write         (1'b0),
        .csr_readdata      (),
        .csr_writedata     (32'b0),
        .in_data           ({lb_rx_ingress_timestamp_96b_valid[i], lb_rx_ingress_timestamp_64b_valid[i], lb_rx_ingress_timestamp_96b_data[i], lb_rx_ingress_timestamp_64b_data[i]}),
        .in_valid          (avalon_st_lb_rx_valid[i] & avalon_st_lb_rx_ready[i] & avalon_st_lb_rx_startofpacket[i]), // Write to FIFO when SOP
        .in_ready          (), // Assume this FIFO depth is large enough to hold all possible packets
        .in_startofpacket  (1'b0),
        .in_endofpacket    (1'b0),
        .in_empty          (1'b0),
        .in_error          (1'b0),
        .out_data          ({lb_tx_ingress_timestamp_96b_valid[i], lb_tx_ingress_timestamp_64b_valid[i], lb_tx_ingress_timestamp_96b_data[i], lb_tx_ingress_timestamp_64b_data[i]}),
        .out_valid         (), // Assume this FIFO data is always valid when output SOP
        .out_ready         (avalon_st_lb_tx_valid[i] & avalon_st_lb_tx_ready[i] & avalon_st_lb_tx_startofpacket[i]), // Read from FIFO when SOP
        .out_startofpacket (),
        .out_endofpacket   (),
        .out_empty         (),
        .out_error         (),
        .almost_full_data  (),
        .almost_empty_data (),
        .in_channel        (1'b0),
        .out_channel       ()
    );
    end
  
  end
  
 else
  
   begin
	

	
	altera_eth_multi_channel_1588 #(
	 
	 		.NUM_CHANNELS (NUM_CHANNELS),					// range from 1-12
			.TSTAMP_FP_WIDTH (TSTAMP_FP_WIDTH),					//Fingerprint Width follow the setting in MAC 1588 GUI
			.SV_RCN_BUNDLE_MODE (2),          // mode0-10GBaseKR, mode1-1G10G without 1588, mode2 -1G10G with 1588  
			.MDIO_MDC_CLOCK_DIVISOR	(32),		//MDIO
			.SHARED_REFCLK_EN (1)
	
	 ) dut (
        .mm_clk                           (clk_100),
        .pll_ref_clk_1g                   (ref_clk_125),
        .pll_ref_clk_10g                  (ref_clk_644),
        .cdr_ref_clk_1g                   (ref_clk_125),
        .cdr_ref_clk_10g                  (ref_clk_644),
        .master_reset_n                   (reset_n),
        .channel_reset_n		  (reset_n),
        .xgmii_clk                        (xgmii_clk),
    
        .rx_serial_data                   (serial_data_loopback),
        .tx_serial_data                   (serial_data_loopback),
       
    
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
        .avalon_st_rx_status_data                  (),
	
		  .avalon_st_pause_data							(2'h0),  //adding
		  .ethernet_1g_an                  				(), 
		  .ethernet_1g_char_err            				(), 
		  .ethernet_1g_disp_err            				(), 	
 

        .tx_egress_timestamp_request_in_valid        (tx_ts_req_valid),
        .tx_egress_timestamp_request_in_fingerprint  (tx_egress_timestamp_request_fingerprint),
        
        .tx_ingress_timestamp_valid               (tx_ts_valid),
        .tx_ingress_timestamp_96b_data            (tx_ingress_timestamp_96b_data),
        .tx_ingress_timestamp_64b_data            (tx_ingress_timestamp_64b_data),
        .tx_ingress_timestamp_format              (tx_ingress_timestamp_format),
        
        .tx_egress_timestamp_96b_valid            (tx_egress_timestamp_96b_valid),
        .tx_egress_timestamp_96b_data             (tx_egress_timestamp_96b_data),
        .tx_egress_timestamp_96b_fingerprint      (tx_egress_timestamp_96b_fingerprint),
        
        .tx_egress_timestamp_64b_valid            (tx_egress_timestamp_64b_valid),
        .tx_egress_timestamp_64b_data             (tx_egress_timestamp_64b_data),
        .tx_egress_timestamp_64b_fingerprint      (tx_egress_timestamp_64b_fingerprint),
        
        .rx_ingress_timestamp_96b_valid           (rx_ingress_timestamp_96b_valid),
        .rx_ingress_timestamp_96b_data            (rx_ingress_timestamp_96b_data),
        
        .rx_ingress_timestamp_64b_valid           (rx_ingress_timestamp_64b_valid),
        .rx_ingress_timestamp_64b_data            (rx_ingress_timestamp_64b_data),
        
        
        .master_pulse_per_second						  (master_pulse_per_second),
        .pulse_per_second_10g                     (pps_10g),
        .pulse_per_second_1g                      (pps_1g),
        .start_tod_sync							  (1'b1),  //need to provide input for this
        .channel_ready                            (channel_ready),
              
        // Configuration
        .clock_operation_mode_mode                (clock_mode),
        .pkt_with_crc_mode                        (1'b0)  	    
		  
        );
		
	  
	
	end
  
  
endgenerate
	
   
   
   
        
    //Implement all the test case in tb_testcase.v
    tb_testcase_1588 TESTCASE (
        .clk(clk_156_25),
        .reset(reset)
    );
    
    
    
    // Avalon-MM and Avalon-ST signals driver
    avalon_driver U_AVALON_DRIVER (
        .avalon_mm_csr_clk          (clk_100),
        .avalon_st_rx_clk           (clk_156_25),
        .avalon_st_tx_clk           (clk_156_25),
        
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
        
        .tx_egress_timestamp_request_valid          (tx_egress_timestamp_request_valid), 
        .tx_egress_timestamp_request_fingerprint    (tx_egress_timestamp_request_fingerprint),
        
        .tx_ingress_timestamp_valid                 (tx_ingress_timestamp_valid),
        .tx_ingress_timestamp_96b_data              (tx_ingress_timestamp_96b_data),
        .tx_ingress_timestamp_64b_data              (tx_ingress_timestamp_64b_data),
        .tx_ingress_timestamp_format                (tx_ingress_timestamp_format)
    );
    

    // Ethernet packet monitor on Avalon-ST RX path
    avalon_st_eth_packet_monitor #(
        .ST_ERROR_W                 (AVALON_ST_RX_ST_ERROR_W)
    ) U_MON_RX (
        .clk                        (clk_156_25),
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
        .clk                        (clk_156_25),
        .reset                      (reset),
        
        .startofpacket              (tx_sop),
        .endofpacket                (tx_eop),
        .valid                      (avalon_st_tx_valid),
        .ready                      (avalon_st_tx_ready),
        .data                       (avalon_st_tx_data),
        .empty                      (avalon_st_tx_empty),
        .error                      (avalon_st_tx_error)
    );



  //Stimulus
   
    bit [3:0]  period_nsecond;
    bit [15:0] period_fnsecond;
    bit [15:0] adjust_nsecond;
    bit [15:0] adjust_fnsecond;   
    
    
    
    // Data read from CSR
    bit [31:0]  readdata;
    int unsigned id;
    
	
	// nga configure N channels
	
	 task automatic configure_csr_basic_n (bit [31:0] address_offset);
		for (id=0; id<NUM_CHANNELS;id++)
			begin
				configure_csr_basic(address_offset + 32'h10000*id, id);
			end
	 endtask
	 
	 task automatic configure_csr_phy_n (bit [31:0] address_offset, bit[1:0] speed);
		for (id=0; id<NUM_CHANNELS;id++)
			begin
				configure_csr_phy(address_offset + 32'h10000*id, speed);
			end
	 endtask
	 
	  task automatic configure_csr_1588_n (bit [31:0] address_offset);
		for (id=0; id<NUM_CHANNELS;id++)
		 begin
			configure_csr_1588(address_offset + 32'h10000*id);
		 end
	 endtask
	 
	 task automatic configure_csr_tod_n (bit [31:0] address_offset_master,bit [31:0] address_offset_1g,bit [31:0] address_offset_10g);
		//configure Master TOD
		configure_csr_tod(address_offset_master);
		for (id=0; id<NUM_CHANNELS;id++)
		  begin
			configure_csr_tod_1g10g(address_offset_1g + 32'h10000*id,address_offset_10g + 32'h10000*id);
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
	
	//end nga
	
	// CSR Configuration
    task automatic configure_csr_basic(bit [31:0] address_offset, int unsigned channel_id);
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
    
    
    task automatic configure_csr_1588(bit [31:0] address_offset);
        
		  
		  // TX XGMII TSU & RX XGMII TSU
        // Configure Period and Adjustment
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + RX_10G_PERIOD_ADDR,     (PERIOD_10G_NSECOND  << TSU_10G_PERIOD_NS_OFFSET) | (PERIOD_10G_FNSECOND << TSU_10G_PERIOD_FNS_OFFSET));
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + RX_10G_ADJUST_FNS_ADDR, (ADJUST_10G_FNSECOND << TSU_10G_ADJUST_FNS_OFFSET));
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + RX_10G_ADJUST_NS_ADDR,  (ADJUST_10G_NSECOND  << TSU_10G_ADJUST_NS_OFFSET));

        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + TX_10G_PERIOD_ADDR,     (PERIOD_10G_NSECOND  << TSU_10G_PERIOD_NS_OFFSET) | (PERIOD_10G_FNSECOND << TSU_10G_PERIOD_FNS_OFFSET));
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + TX_10G_ADJUST_FNS_ADDR, (ADJUST_10G_FNSECOND << TSU_10G_ADJUST_FNS_OFFSET));
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + TX_10G_ADJUST_NS_ADDR,  (ADJUST_10G_NSECOND  << TSU_10G_ADJUST_NS_OFFSET));
        
        // TX GMII TSU & RX GMII TSU
        // Configure Period and Adjustment
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + RX_1G_PERIOD_ADDR,     (PERIOD_1G_NSECOND  << TSU_1G_PERIOD_NS_OFFSET) | (PERIOD_1G_FNSECOND << TSU_1G_PERIOD_FNS_OFFSET));
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + RX_1G_ADJUST_FNS_ADDR, (ADJUST_1G_FNSECOND << TSU_1G_ADJUST_FNS_OFFSET));
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + RX_1G_ADJUST_NS_ADDR,  (ADJUST_1G_NSECOND  << TSU_1G_ADJUST_NS_OFFSET));

        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + TX_1G_PERIOD_ADDR,     (PERIOD_1G_NSECOND  << TSU_1G_PERIOD_NS_OFFSET) | (PERIOD_1G_FNSECOND << TSU_1G_PERIOD_FNS_OFFSET));
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + TX_1G_ADJUST_FNS_ADDR, (ADJUST_1G_FNSECOND << TSU_1G_ADJUST_FNS_OFFSET));
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + TX_1G_ADJUST_NS_ADDR,  (ADJUST_1G_NSECOND  << TSU_1G_ADJUST_NS_OFFSET));
    endtask 
    
    task automatic configure_csr_tod_1g10g (bit [31:0] address_offset_1g,bit [31:0] address_offset_10g);
		configure_csr_tod(address_offset_1g);
		configure_csr_tod(address_offset_10g);
	 endtask
	 
	 task automatic configure_csr_tod(bit [31:0] address_offset); // different value for diff channel?
        
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + TOD_SECOND_H, {16'h0,16'h0});
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + TOD_SECOND_L, 32'h00000000);
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + TOD_NANOSECOND, {2'h0,30'h3B9A_C900}); //2'h0,30'h3B9A_8A46
        

    endtask
    
    // speed = 0: 10GbE
    // speed = 1: 10/100/1000
    task automatic configure_csr_speed(bit [31:0] address_offset, bit [1:0] speed);
		
        U_AVALON_DRIVER.avalon_mm_csr_wr(address_offset + RECONFIG_SPEED_ADDR, (|speed) ? 32'h11 : 32'h41);
		
    endtask
    
	 //nga added display TX/RX statistics move from tb_top.sv
//    task automatic display_statistics (bit [31:0] address_offset, int unsigned channel_id);
//                // Display the collected statistics of the MAC
//            $display("\n------------------------");
//            $display("Channel-%d: TX Statistics", channel_id);
//            $display("------------------------");
//            U_AVALON_DRIVER.display_eth_statistics(address_offset + TX_STATISTICS_ADDR);
//            
//            $display("\n------------------------");
//            $display("Channel-%d: RX Statistics", channel_id);
//            $display("------------------------");
//            U_AVALON_DRIVER.display_eth_statistics(address_offset + RX_STATISTICS_ADDR);
//     endtask       
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

    // Queues
    ptp_timestamp tx_timestamp_q[$];
    ptp_timestamp rx_timestamp_q[$];    
    eth_mac_frame mac_frame_expected_q[$];

    //Global handle
    ptp_timestamp tx_timestamp;
    ptp_timestamp rx_timestamp;
    
    //Source/Sink Packet Number
    integer unsigned source_num_frame;
    integer unsigned sink_num_frame;
	event event_push_back_tx_timestamp_q;
	event event_push_back_rx_timestamp_q;

    // Capture TX Ingress Timestamp
    initial begin

        forever begin
            @(posedge tx_sop);
               
                tx_timestamp = new();
                tx_timestamp.timestamp_req_valid = tx_egress_timestamp_request_valid;
                tx_timestamp.ingress_timestamp_valid = tx_ingress_timestamp_valid;
                tx_timestamp.ingress_timestamp_format = tx_ingress_timestamp_format;
                tx_timestamp.ingress_time_96b_second = tx_ingress_timestamp_96b_data[95:48];
                tx_timestamp.ingress_time_96b_nsecond = tx_ingress_timestamp_96b_data[47:16];
                tx_timestamp.ingress_time_96b_fnsecond = tx_ingress_timestamp_96b_data[15:0];
                tx_timestamp.ingress_time_64b_nsecond = tx_ingress_timestamp_64b_data[63:16];
                tx_timestamp.ingress_time_64b_fnsecond = tx_ingress_timestamp_64b_data[15:0];
                tx_timestamp.ingress_fingerprint   = tx_egress_timestamp_request_fingerprint;
                
                if (!tx_ts_req_valid) begin
                    
                    tx_timestamp.egress_timestamp_valid = 1'b0;
                    tx_timestamp.egress_time_96b_second = 48'h0;
                    tx_timestamp.egress_time_96b_nsecond = 32'h0;
                    tx_timestamp.egress_time_96b_fnsecond = 16'h0;
                    tx_timestamp.egress_time_64b_nsecond = 48'h0;
                    tx_timestamp.egress_time_64b_fnsecond = 16'h0;
                    tx_timestamp.egress_fingerprint = {TIMESTAMP_FINGERPRINT_WIDTH{1'b0}};
					
                    $display("tx_timestamp_q.push_back");
                    tx_timestamp_q.push_back(tx_timestamp);
					-> event_push_back_tx_timestamp_q; 				//sh
                end     
            
        end
    end
 


    // Capture TX Egress Timestamp
    initial begin

        
        forever begin
            @(posedge tx_egress_timestamp_96b_valid[0]);
            
            // Store the timestamp generated by TX XGMII TSU
            tx_timestamp.egress_timestamp_valid = tx_egress_timestamp_96b_valid[0]; // or tx_egress_timestamp_64b_valid, they are identical
            tx_timestamp.egress_time_96b_second = tx_egress_timestamp_96b_data[0][95:48];
            tx_timestamp.egress_time_96b_nsecond = tx_egress_timestamp_96b_data[0][47:16];
            tx_timestamp.egress_time_96b_fnsecond = tx_egress_timestamp_96b_data[0][15:0];
            tx_timestamp.egress_time_64b_nsecond = tx_egress_timestamp_64b_data[0][63:16];
            tx_timestamp.egress_time_64b_fnsecond = tx_egress_timestamp_64b_data[0][15:0];
            tx_timestamp.egress_fingerprint = tx_egress_timestamp_96b_fingerprint[0]; // or tx_egress_timestamp_64b_fingerprint, they are identical
            
			$display("tx_timestamp_q.push_back");
            tx_timestamp_q.push_back(tx_timestamp);
			-> event_push_back_tx_timestamp_q; 				//sh
            
        end       
    end
 
    
    
    // Capture RX Egress Timestamp
    initial begin
 
        forever begin
            @(posedge rx_ingress_timestamp_96b_valid);

            
            // Store the timestamp generated by RX XGMII TSU
            rx_timestamp = new();
            
            rx_timestamp.egress_timestamp_valid = rx_ingress_timestamp_96b_valid; // or rx_ingress_timestamp_64b_valid, they are identical
            rx_timestamp.egress_time_96b_second = rx_ingress_timestamp_96b_data[95:48];
            rx_timestamp.egress_time_96b_nsecond = rx_ingress_timestamp_96b_data[47:16];
            rx_timestamp.egress_time_96b_fnsecond = rx_ingress_timestamp_96b_data[15:0];
            rx_timestamp.egress_time_64b_nsecond = rx_ingress_timestamp_64b_data[63:16];
            rx_timestamp.egress_time_64b_fnsecond = rx_ingress_timestamp_64b_data[15:0];
            
            rx_timestamp_q.push_back(rx_timestamp);
            -> event_push_back_rx_timestamp_q; 
        end
    end
 
 

 
    //display timestamp and correction field data
    initial begin
        
        integer unsigned rx_num_timestamp;
        integer unsigned tx_num_timestamp;
        
        ptp_timestamp tx_timestamp_temp;
        ptp_timestamp rx_timestamp_temp;
        eth_mac_frame mac_frame_source;
        
        
        forever begin
            @(U_MON_RX.frame_complete);
            
            source_num_frame = U_MON_RX.mac_frame_q.size();
            sink_num_frame = U_MON_TX.mac_frame_q.size();
            mac_frame_source = U_MON_RX.mac_frame_q[source_num_frame-1];
            mac_frame_source.analyze_frame(clock_mode);
            
			@event_push_back_tx_timestamp_q;
            tx_timestamp_temp = tx_timestamp_q[source_num_frame - 1];
            @event_push_back_rx_timestamp_q
            rx_timestamp_temp = rx_timestamp_q[source_num_frame - 1]; 
            
            // Display PTP info from packet
            $display("------------------------------");
            $display("PTP Info of This Packet");
            $display("------------------------------");
            if (mac_frame_source.ptp_ethernet) begin
                $display("Type                         : Basic PTP");
            end else if (mac_frame_source.ipv4_header) begin
                $display("Type                         : IPV4");
            end else if (mac_frame_source.ipv6_header) begin
                $display("Type                         : IPV6");
            end else begin
                $display("Type                         : Invalid PTP Packet Type!");
            end 
            
            if (mac_frame_source.vlan_tag == 0) begin
                $display("Transport Layer              : Untagged");
            end else if (mac_frame_source.vlan_tag == 1) begin
                $display("Transport Layer              : VLAN");
            end else if (mac_frame_source.vlan_tag == 2) begin
                $display("Transport Layer              : STACKED VLAN");
            end else begin
                $display("Transport Layer              : Invalid VLAN!");
            end 
            
            if (mac_frame_source.clock_mode == ORDINARY_CLOCK) begin
                $display("Clock Mode                   : Ordinary Clock");
            end else if (mac_frame_source.clock_mode == BOUNDARY_CLOCK) begin
                $display("Clock Mode                   : Boundary Clock");
            end else if (mac_frame_source.clock_mode == E2E_TRANSPARENT_CLOCK) begin
                $display("Clock Mode                   : End To End Transparent Clock");
            end else if (mac_frame_source.clock_mode == P2P_TRANSPARENT_CLOCK) begin
                $display("Clock Mode                   : Peer To Peer Transparent Clock");
            end else begin
                $display("Clock Mode                   : Invalid Clock Mode");
            end     

            if (mac_frame_source.ptp_message_type == MSG_SYNC) begin
                $display("PTP Message Type             : Sync");
            end else if (mac_frame_source.ptp_message_type == MSG_DELAY_REQ) begin
                $display("PTP Message Type             : Delay Request");
            end else if (mac_frame_source.ptp_message_type == MSG_PDELAY_REQ) begin
                $display("PTP Message Type             : Pdelay Request");
            end else if (mac_frame_source.ptp_message_type == MSG_PDELAY_RESP) begin
                $display("PTP Message Type             : Pdelay Response");
            end else begin
                $display("PTP Message Type             : Non Event Message");
            end     

            if (mac_frame_source.ptp_message_flag == 1'b0) begin
                $display("2-step Flag                  : 0");
            end else begin
                $display("2-step Flag                  : 1");
            end 
            
            if (tx_timestamp_temp.timestamp_req_valid == 1'b1) begin
                $display("Timestamp Request Valid      : Yes");
            end else begin
                $display("Timestamp Request Valid      : No");
            end
            
            if (tx_timestamp_temp.ingress_timestamp_valid == 1'b1) begin
                $display("TX Ingress Timestamp Valid   : Yes");
            end else begin
                $display("TX Ingress Timestamp Valid   : No");
            end
            
            $display("TX Fingerprint Valid         : 0x%X", tx_timestamp_temp.timestamp_req_valid);
            $display("TX Fingerprint Data          : 0x%X", tx_timestamp_temp.egress_fingerprint);
            
            $display("TX Ingress Timestamp Valid   : 0x%X", tx_timestamp_temp.ingress_timestamp_valid);
            $display("TX Ingress Timestamp Format  : %s", tx_timestamp_temp.ingress_timestamp_format ? "64-bits" : "96-bits");
            $display("TX Ingress Timestamp 96-bits : -");
            $display("                Second Field : 0x%X", tx_timestamp_temp.ingress_time_96b_second);
            $display("            Nanosecond Field : 0x%X", tx_timestamp_temp.ingress_time_96b_nsecond);
            $display(" Fractional Nanosecond Field : 0x%X", tx_timestamp_temp.ingress_time_96b_fnsecond);
            $display("TX Ingress Timestamp 64-bits : -");
            $display("            Nanosecond Field : 0x%X", tx_timestamp_temp.ingress_time_64b_nsecond);
            $display(" Fractional Nanosecond Field : 0x%X", tx_timestamp_temp.ingress_time_64b_fnsecond);
            
            $display("TX Egress Timestamp 96-bits  : -");
            $display("                Second Field : 0x%X", tx_timestamp_temp.egress_time_96b_second);
            $display("            Nanosecond Field : 0x%X", tx_timestamp_temp.egress_time_96b_nsecond);
            $display(" Fractional Nanosecond Field : 0x%X", tx_timestamp_temp.egress_time_96b_fnsecond);
            $display("TX Egress Timestamp 64-bits  : -");
            $display("            Nanosecond Field : 0x%X", tx_timestamp_temp.egress_time_64b_nsecond);
            $display(" Fractional Nanosecond Field : 0x%X", tx_timestamp_temp.egress_time_64b_fnsecond);
            
            $display("RX Ingress Timestamp 96-bits : -");
            $display("                Second Field : 0x%X", rx_timestamp_temp.egress_time_96b_second);
            $display("            Nanosecond Field : 0x%X", rx_timestamp_temp.egress_time_96b_nsecond);
            $display(" Fractional Nanosecond Field : 0x%X", rx_timestamp_temp.egress_time_96b_fnsecond);
            $display("RX Ingress Timestamp 64-bits : -");
            $display("            Nanosecond Field : 0x%X", rx_timestamp_temp.egress_time_64b_nsecond);
            $display(" Fractional Nanosecond Field : 0x%X", rx_timestamp_temp.egress_time_64b_fnsecond);
            
            $display("Correction Field             : 0x%X", mac_frame_source.ptp_correction_field);
            $display("TimeStamp Field              : 0x%X\n\n", mac_frame_source.ptp_timestamp);
            $display("\n\n\n\n");
        end
    end
	
//	initial begin 
//       $vcdpluson();
//    end
    
 
endmodule

`endif
