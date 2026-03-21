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


// _________________________________________________________________________
//	
//	Author: Ajay Dubey, IP Apps engineering
// __________________________________________________________________________

 module avalon_st_traffic_controller_top (
	input 	wire		avl_mm_read      ,
	input 	wire		avl_mm_write     ,
	output 	wire		avl_mm_waitrequest,
	input 	wire[11:0]	avl_mm_baddress   ,
	output 	wire[31:0]	avl_mm_readdata  ,
	input 	wire[31:0]	avl_mm_writedata ,

	input 	wire 		mm_clk	,
	input 	wire 		st_clk	,

	input 	wire 		reset_n	,

	//input	wire[38:0] 	mac_rx_status_data	,
	input 	wire[39:0] 	mac_rx_status_data	,
	input 	wire		mac_rx_status_valid	,
	input 	wire		mac_rx_status_error	,
	input   wire	        stop_mon	,
	output  wire	        mon_active	,
	output  wire	        mon_done	,
	output  wire	        mon_error	,

	output 	wire[63:0] 	avl_st_tx_data	,
	output 	wire[2:0]  	avl_st_tx_empty	,
	output 	wire 		avl_st_tx_eop	,
	output 	wire 		avl_st_tx_error	,
	input 	wire 		avl_st_tx_ready	,
	output 	wire 		avl_st_tx_sop	,
	output 	wire 		avl_st_tx_val	,             

	input 	wire[63:0] 	avl_st_rx_data	,
	input 	wire[2:0]  	avl_st_rx_empty	,
	input 	wire 		avl_st_rx_eop	,
	input 	wire [5:0]	avl_st_rx_error	,
	output 	wire 		avl_st_rx_ready	,
	input 	wire 		avl_st_rx_sop	,
	input 	wire 		avl_st_rx_val  
);


	wire		avl_mm_out_read      ;
	wire		avl_mm_out_write     ;
	wire		avl_mm_out_waitrequest;
	wire[11:0]	avl_mm_out_baddress   ;
	wire[31:0]	avl_mm_out_readdata  ;
	wire[31:0]	avl_mm_out_writedata ;

	
altera_avalon_mm_clock_crossing_bridge #(
		.DATA_WIDTH          (32),
		.SYMBOL_WIDTH        (8),
		.ADDRESS_WIDTH       (12),
		.BURSTCOUNT_WIDTH    (1),
		.COMMAND_FIFO_DEPTH  (4),
		.RESPONSE_FIFO_DEPTH (4),
		.MASTER_SYNC_DEPTH   (2),
		.SLAVE_SYNC_DEPTH    (2)
	) mm_clock_crossing_bridge_0 (
	 	.s0_clk           (mm_clk),                                                                //   s0_clk.clk
		.s0_reset         (~reset_n),  // need to sync to slave_clk?                                             // s0_reset.reset
		.s0_waitrequest   (avl_mm_waitrequest),  
		.s0_readdata      (avl_mm_readdata),    
		.s0_readdatavalid (), 
		.s0_burstcount    (),    
		.s0_writedata     (avl_mm_writedata),   
		.s0_address       (avl_mm_baddress),      
		.s0_write         (avl_mm_write),        
		.s0_read          (avl_mm_read),         
		.s0_byteenable    (),   
		.s0_debugaccess   (),   
		
		.m0_clk           (st_clk),                                                             //   m0_clk.clk
		.m0_reset         (~reset_n),     //sync to master clk?       
		.m0_waitrequest   (avl_mm_out_waitrequest),                                
		.m0_readdata      (avl_mm_out_readdata),                                    
		.m0_readdatavalid (avl_mm_out_read & ~avl_mm_out_waitrequest),//(master_cross_csr_readdatavalid),                                
		.m0_burstcount    (),                                   
		.m0_writedata     (avl_mm_out_writedata),                                   
		.m0_address       (avl_mm_out_baddress),                                    
		.m0_write         (avl_mm_out_write),                                      
		.m0_read          (avl_mm_out_read),                                       
		.m0_byteenable    (),                                  
		.m0_debugaccess   ()                                 
	);

 avalon_st_traffic_controller avalon_st_traffic_controller_inst (
			.clk												(st_clk),           
			.reset_n											(reset_n),

			.avl_mm_read      							(avl_mm_out_read), 
			.avl_mm_write     							(avl_mm_out_write), 
			.avl_mm_waitrequest 							(avl_mm_out_waitrequest),
			.avl_mm_baddress   							(avl_mm_out_baddress),    	
			.avl_mm_readdata  							(avl_mm_out_readdata), 
			.avl_mm_writedata 							(avl_mm_out_writedata), 
			
			
			.avl_st_tx_data								(avl_st_tx_data),
			.avl_st_tx_empty								(avl_st_tx_empty),
			.avl_st_tx_eop									(avl_st_tx_eop),
			.avl_st_tx_error								(avl_st_tx_error),
			.avl_st_tx_ready								(avl_st_tx_ready),
			.avl_st_tx_sop									(avl_st_tx_sop),
			.avl_st_tx_val									(avl_st_tx_val),
			
			.avl_st_rx_data								(avl_st_rx_data),
			.avl_st_rx_empty								(avl_st_rx_empty),
			.avl_st_rx_eop									(avl_st_rx_eop),
			.avl_st_rx_error								(avl_st_rx_error),
			.avl_st_rx_ready								(avl_st_rx_ready),
			.avl_st_rx_sop									(avl_st_rx_sop),
			.avl_st_rx_val									(avl_st_rx_val),

			.mac_rx_status_valid							(mac_rx_status_valid),
			.mac_rx_status_error							(mac_rx_status_error),
			.mac_rx_status_data							(mac_rx_status_data),

			.stop_mon										(stop_mon),
			.mon_active										(mon_active),
			.mon_done										(mon_done),
			.mon_error										(mon_error)

);

endmodule
