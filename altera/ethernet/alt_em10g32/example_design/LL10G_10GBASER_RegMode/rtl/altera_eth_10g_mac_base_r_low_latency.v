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


module altera_eth_10g_mac_base_r_low_latency (

	input wire 			csr_clk,
	input wire			csr_rst_n,
	output wire			tx_xcvr_clk,
	input wire			tx_rst_n,
	output wire			rx_xcvr_clk,
	input wire			rx_rst_n,
	
	input wire			ref_clk_clk,


	// csr interface
	input wire			csr_read,
	input wire			csr_write,
	input wire	[31:0]	csr_writedata,
	output wire	[31:0]	csr_readdata,
	input wire	[15:0]	csr_address,
	output wire 		csr_waitrequest,

	output wire			tx_ready_export,
	output wire			rx_ready_export,
    output wire			block_lock, 
    output wire         atx_pll_locked,
	output wire         iopll_locked,
	
	//output clock
    output wire        rx_xcvr_half_clk,
    output wire        tx_xcvr_half_clk,
    
	output wire			tx_serial_data,
	input wire			rx_serial_data 

);

wire			mac_csr_read;
wire			mac_csr_write;
wire	[31:0]	mac_csr_readdata;
wire	[31:0]	mac_csr_writedata;
wire			mac_csr_waitrequest;
wire	[13:0]	mac_csr_address;

wire			phy_csr_read;
wire			phy_csr_write;
wire	[31:0]	phy_csr_readdata;
wire	[31:0]	phy_csr_writedata;
wire			phy_csr_waitrequest;
wire	[9:0]	phy_csr_address;

wire	[1:0]	avalon_st_pause_data;
wire	[1:0]	avalon_st_pause_data_sync;


wire    [63:0]  tx_sc_fifo_in_data;          
wire            tx_sc_fifo_in_valid;         
wire            tx_sc_fifo_in_ready;         
wire            tx_sc_fifo_in_startofpacket; 
wire            tx_sc_fifo_in_endofpacket;   
wire    [2:0]   tx_sc_fifo_in_empty;         
wire            tx_sc_fifo_in_error; 
        
wire    [63:0]  tx_sc_fifo_out_data;         
wire            tx_sc_fifo_out_valid;        
wire            tx_sc_fifo_out_ready;        
wire            tx_sc_fifo_out_startofpacket;
wire            tx_sc_fifo_out_endofpacket;  
wire    [2:0]   tx_sc_fifo_out_empty;        
wire            tx_sc_fifo_out_error; 

wire    [63:0]  rx_sc_fifo_in_data;          
wire            rx_sc_fifo_in_valid;         
wire            rx_sc_fifo_in_ready;         
wire            rx_sc_fifo_in_startofpacket; 
wire            rx_sc_fifo_in_endofpacket;   
wire    [2:0]   rx_sc_fifo_in_empty;         
wire    [5:0]   rx_sc_fifo_in_error;   
      
wire    [63:0]  rx_sc_fifo_out_data;         
wire            rx_sc_fifo_out_valid;        
wire            rx_sc_fifo_out_ready;        
wire            rx_sc_fifo_out_startofpacket;
wire            rx_sc_fifo_out_endofpacket;  
wire    [2:0]   rx_sc_fifo_out_empty;        
wire    [5:0]   rx_sc_fifo_out_error;         



wire    [2:0]   tx_sc_fifo_csr_address;
wire            tx_sc_fifo_csr_read;
wire            tx_sc_fifo_csr_write;
wire    [31:0]  tx_sc_fifo_csr_readdata;
wire    [31:0]  tx_sc_fifo_csr_writedata;

wire    [2:0]   rx_sc_fifo_csr_address;
wire            rx_sc_fifo_csr_read;
wire            rx_sc_fifo_csr_write;
wire    [31:0]  rx_sc_fifo_csr_readdata;
wire    [31:0]  rx_sc_fifo_csr_writedata;

wire    [11:0]  eth_gen_mon_avalon_anti_slave_0_address;   
wire            eth_gen_mon_avalon_anti_slave_0_write;    
wire            eth_gen_mon_avalon_anti_slave_0_read;      
wire    [31:0]  eth_gen_mon_avalon_anti_slave_0_readdata;  
wire    [31:0]  eth_gen_mon_avalon_anti_slave_0_writedata;
wire            eth_gen_mon_avalon_anti_slave_0_waitrequest;


wire    sync_rx_rst_n;
wire    sync_rx_half_rst_n;
wire    sync_tx_half_rst_n;
wire    sync_tx_rst_n;


wire    sync_tx_half_rst;
wire    sync_rx_half_rst;

wire    sync_tx_rst;
wire    sync_rx_rst;

assign sync_tx_rst_n = ~sync_tx_rst;
assign sync_rx_rst_n = ~sync_rx_rst;

assign sync_rx_half_rst_n = ~sync_rx_half_rst;
assign sync_tx_half_rst_n = ~sync_tx_half_rst;

wire    [31:0]  mac_in_data;
wire            mac_in_valid;
wire            mac_in_ready;
wire            mac_in_startofpacket;
wire            mac_in_endofpacket;
wire    [1:0]   mac_in_empty;
wire    [0:0]   mac_in_error;

wire    [31:0]  mac_out_data;
wire            mac_out_valid;
wire            mac_out_ready;
wire            mac_out_startofpacket;
wire            mac_out_endofpacket;
wire    [1:0]   mac_out_empty;
wire    [5:0]   mac_out_error;


wire [63:0] tx_st_adapter_0_in_0_data;          
wire        tx_st_adapter_0_in_0_valid;         
wire        tx_st_adapter_0_in_0_ready;        
wire        tx_st_adapter_0_in_0_startofpacket; 
wire        tx_st_adapter_0_in_0_endofpacket;   
wire [2:0]  tx_st_adapter_0_in_0_empty;         
wire [0:0]  tx_st_adapter_0_in_0_error;         
wire [31:0] tx_st_adapter_0_out_0_data;         
wire        tx_st_adapter_0_out_0_valid;        
wire        tx_st_adapter_0_out_0_ready;        
wire        tx_st_adapter_0_out_0_startofpacket;
wire        tx_st_adapter_0_out_0_endofpacket;  

wire [1:0]  tx_st_adapter_0_out_0_empty;        

wire [1:0]  tx_st_adapter_0_out_0_error;

wire [31:0] rx_st_adapter_0_in_0_data;          
wire        rx_st_adapter_0_in_0_valid;         
wire        rx_st_adapter_0_in_0_ready;         
wire        rx_st_adapter_0_in_0_startofpacket; 
wire        rx_st_adapter_0_in_0_endofpacket;   
wire [1:0]  rx_st_adapter_0_in_0_empty;         
wire        rx_st_adapter_0_in_0_error;         
wire [63:0] rx_st_adapter_0_out_0_data;         
wire        rx_st_adapter_0_out_0_valid;        
wire        rx_st_adapter_0_out_0_ready;        
wire        rx_st_adapter_0_out_0_startofpacket;
wire        rx_st_adapter_0_out_0_endofpacket;  
wire [2:0]  rx_st_adapter_0_out_0_empty;        
wire [5:0]  rx_st_adapter_0_out_0_error;  


    IOPLL_half_clk IOPLL_half_clk_inst (
		.locked(iopll_locked),   //  locked.export
		.outclk_0(tx_xcvr_half_clk), // outclk0.clk
		.refclk(ref_clk_clk),   //  refclk.clk
		.rst(~csr_rst_n)        //   reset.reset
	);

    altera_std_synchronizer #(.depth(2)) almost_empty_sync (
        .clk(tx_xcvr_clk),
        .reset_n(tx_rst_n),
        .din(avalon_st_pause_data[0]),
        .dout(avalon_st_pause_data_sync[0])

    );

    

    altera_std_synchronizer #(.depth(2)) almost_full_sync (
        .clk(tx_xcvr_clk),
        .reset_n(tx_rst_n),
        .din(avalon_st_pause_data[1]),
        .dout(avalon_st_pause_data_sync[1])

    );


altera_eth_10g_mac_base_r_low_latency_wrap wrapper_inst (

	
	.csr_clk		(csr_clk),
	.csr_rst_n		(csr_rst_n),
	.tx_xcvr_clk	(tx_xcvr_clk),
	// .tx_xcvr_half_clk	(tx_xcvr_half_clk), // Modifed by HH: Replace xcvr tx_pma_div_clk by using IOPLL for the half-rate clock 
	.tx_rst_n		(tx_rst_n),
	.rx_xcvr_clk	(rx_xcvr_clk),
    .rx_xcvr_half_clk   (rx_xcvr_half_clk),
	.tx_xcvr_half_clk	(),
	.rx_rst_n		(rx_rst_n),	
	
	.ref_clk_clk	(ref_clk_clk),
    
	.avalon_st_tx_startofpacket	(mac_in_startofpacket),
	.avalon_st_tx_endofpacket	(mac_in_endofpacket),
	.avalon_st_tx_valid			(mac_in_valid),
	.avalon_st_tx_data			(mac_in_data),
	.avalon_st_tx_empty			(mac_in_empty),
	.avalon_st_tx_ready			(mac_in_ready),
	.avalon_st_tx_error			(mac_in_error),
	
    .avalon_st_rx_startofpacket	(mac_out_startofpacket),
	.avalon_st_rx_endofpacket	(mac_out_endofpacket),
	.avalon_st_rx_valid			(mac_out_valid),
	.avalon_st_rx_data			(mac_out_data),
	.avalon_st_rx_empty			(mac_out_empty),
	.avalon_st_rx_ready			(mac_out_ready),
	.avalon_st_rx_error			(mac_out_error),

	.avalon_st_pause_data		(avalon_st_pause_data_sync),	
	.avalon_st_txstatus_valid	(avalon_st_txstatus_valid),
	.avalon_st_txstatus_data	(), 
	.avalon_st_txstatus_error	(),
	
	.avalon_st_rxstatus_valid	(avalon_st_rxstatus_valid),                                  
	.avalon_st_rxstatus_error	(),                                  
	.avalon_st_rxstatus_data	(),
	
	.link_fault_status_xgmii_rx_data	(),
	
	
	.tx_ready_export	(tx_ready_export),
	.rx_ready_export	(rx_ready_export),
    .block_lock         (block_lock),
    .atx_pll_locked     (atx_pll_locked),
	
	
	.tx_serial_data		(tx_serial_data),
	.rx_serial_data		(rx_serial_data),
    
    
    .mac_csr_read       (mac_csr_read),
    .mac_csr_write      (mac_csr_write),
    .mac_csr_readdata   (mac_csr_readdata),
    .mac_csr_writedata  (mac_csr_writedata),
    .mac_csr_waitrequest(mac_csr_waitrequest),
    .mac_csr_address    (mac_csr_address),
    
    .phy_csr_read       (phy_csr_read),
    .phy_csr_write      (phy_csr_write),
    .phy_csr_readdata   (phy_csr_readdata),
    .phy_csr_writedata  (phy_csr_writedata),
    .phy_csr_waitrequest(phy_csr_waitrequest),
    .phy_csr_address    (phy_csr_address)
    


);


address_decode address_decoder_inst (

	.clk_csr_clk												(csr_clk),                                                
    .csr_reset_n												(csr_rst_n),

    .tx_xcvr_half_clk_clk                                       (tx_xcvr_half_clk),     
    .sync_tx_half_rst_reset_n                                   (sync_tx_half_rst_n), 
    .tx_xcvr_clk_clk                                            (tx_xcvr_clk),          
    .sync_tx_rst_reset_n                                        (sync_tx_rst_n),      
    .rx_xcvr_clk_clk                                            (rx_xcvr_clk),          
    .sync_rx_rst_reset_n                                        (sync_rx_rst_n),     

    .merlin_master_translator_0_avalon_anti_master_0_address	(csr_address),    
    .merlin_master_translator_0_avalon_anti_master_0_waitrequest(csr_waitrequest),
    .merlin_master_translator_0_avalon_anti_master_0_read		(csr_read),       
    .merlin_master_translator_0_avalon_anti_master_0_readdata	(csr_readdata),   
    .merlin_master_translator_0_avalon_anti_master_0_write		(csr_write),      
    .merlin_master_translator_0_avalon_anti_master_0_writedata	(csr_writedata),  
    .mac_avalon_anti_slave_0_address							(mac_csr_address[12:0]),                            
    .mac_avalon_anti_slave_0_write								(mac_csr_write),                              
    .mac_avalon_anti_slave_0_read								(mac_csr_read),                               
    .mac_avalon_anti_slave_0_readdata							(mac_csr_readdata),                           
    .mac_avalon_anti_slave_0_writedata							(mac_csr_writedata),                          
    .mac_avalon_anti_slave_0_waitrequest						(mac_csr_waitrequest),                        
    .phy_avalon_anti_slave_0_address							(phy_csr_address),                            
    .phy_avalon_anti_slave_0_write								(phy_csr_write),                              
    .phy_avalon_anti_slave_0_read								(phy_csr_read),                               
    .phy_avalon_anti_slave_0_readdata							(phy_csr_readdata),                           
    .phy_avalon_anti_slave_0_writedata							(phy_csr_writedata),                          
    .phy_avalon_anti_slave_0_waitrequest                        (phy_csr_waitrequest),
    
    .tx_sc_fifo_avalon_anti_slave_0_address                     (tx_sc_fifo_csr_address),    
    .tx_sc_fifo_avalon_anti_slave_0_write                       (tx_sc_fifo_csr_write),      
    .tx_sc_fifo_avalon_anti_slave_0_read                        (tx_sc_fifo_csr_read),       
    .tx_sc_fifo_avalon_anti_slave_0_readdata                    (tx_sc_fifo_csr_readdata),   
    .tx_sc_fifo_avalon_anti_slave_0_writedata                   (tx_sc_fifo_csr_writedata),  
    
    .rx_sc_fifo_avalon_anti_slave_0_address                     (rx_sc_fifo_csr_address),    
    .rx_sc_fifo_avalon_anti_slave_0_write                       (rx_sc_fifo_csr_write),      
    .rx_sc_fifo_avalon_anti_slave_0_read                        (rx_sc_fifo_csr_read),       
    .rx_sc_fifo_avalon_anti_slave_0_readdata                    (rx_sc_fifo_csr_readdata),   
    .rx_sc_fifo_avalon_anti_slave_0_writedata                   (rx_sc_fifo_csr_writedata),  
    
    .eth_gen_mon_avalon_anti_slave_0_address                    (eth_gen_mon_avalon_anti_slave_0_address),   
    .eth_gen_mon_avalon_anti_slave_0_write                      (eth_gen_mon_avalon_anti_slave_0_write),     
    .eth_gen_mon_avalon_anti_slave_0_read                       (eth_gen_mon_avalon_anti_slave_0_read),      
    .eth_gen_mon_avalon_anti_slave_0_readdata                   (eth_gen_mon_avalon_anti_slave_0_readdata),  
    .eth_gen_mon_avalon_anti_slave_0_writedata                  (eth_gen_mon_avalon_anti_slave_0_writedata),
    .eth_gen_mon_avalon_anti_slave_0_waitrequest                (eth_gen_mon_avalon_anti_slave_0_waitrequest)
    
    
);    


    
sc_fifo fifo_inst(

    .tx_sc_fifo_csr_address                 (tx_sc_fifo_csr_address),       
	.tx_sc_fifo_csr_read                    (tx_sc_fifo_csr_read),          
	.tx_sc_fifo_csr_write                   (tx_sc_fifo_csr_write),         
	.tx_sc_fifo_csr_readdata                (tx_sc_fifo_csr_readdata),      
	.tx_sc_fifo_csr_writedata               (tx_sc_fifo_csr_writedata),     
	.rx_sc_fifo_csr_address                 (rx_sc_fifo_csr_address),       
	.rx_sc_fifo_csr_read                    (rx_sc_fifo_csr_read),          
	.rx_sc_fifo_csr_write                   (rx_sc_fifo_csr_write),         
	.rx_sc_fifo_csr_readdata                (rx_sc_fifo_csr_readdata),      
	.rx_sc_fifo_csr_writedata               (rx_sc_fifo_csr_writedata),     
	.tx_sc_fifo_clk_clk                     (tx_xcvr_half_clk),           
	.tx_sc_fifo_clk_reset_reset             (~sync_tx_half_rst_n),   
	.tx_sc_fifo_in_data                     (tx_sc_fifo_in_data),           
	.tx_sc_fifo_in_valid                    (tx_sc_fifo_in_valid),          
	.tx_sc_fifo_in_ready                    (tx_sc_fifo_in_ready),          
	.tx_sc_fifo_in_startofpacket            (tx_sc_fifo_in_startofpacket),  
	.tx_sc_fifo_in_endofpacket              (tx_sc_fifo_in_endofpacket),    
	.tx_sc_fifo_in_empty                    (tx_sc_fifo_in_empty),          
	.tx_sc_fifo_in_error                    (tx_sc_fifo_in_error),          
	.tx_sc_fifo_out_data                    (tx_sc_fifo_out_data),          
	.tx_sc_fifo_out_valid                   (tx_sc_fifo_out_valid),         
	.tx_sc_fifo_out_ready                   (tx_sc_fifo_out_ready),         
	.tx_sc_fifo_out_startofpacket           (tx_sc_fifo_out_startofpacket), 
	.tx_sc_fifo_out_endofpacket             (tx_sc_fifo_out_endofpacket),   
	.tx_sc_fifo_out_empty                   (tx_sc_fifo_out_empty),         
	.tx_sc_fifo_out_error                   (tx_sc_fifo_out_error),         
	.rx_sc_fifo_clk_clk                     (tx_xcvr_half_clk),           
	.rx_sc_fifo_clk_reset_reset             (~sync_tx_half_rst_n),   
	.rx_sc_fifo_almost_full_data            (avalon_st_pause_data[1]),    
	.rx_sc_fifo_almost_empty_data           (avalon_st_pause_data[0]),    
	.rx_sc_fifo_in_data                     (rx_sc_fifo_in_data),           
	.rx_sc_fifo_in_valid                    (rx_sc_fifo_in_valid),          
	.rx_sc_fifo_in_ready                    (rx_sc_fifo_in_ready),          
	.rx_sc_fifo_in_startofpacket            (rx_sc_fifo_in_startofpacket),  
	.rx_sc_fifo_in_endofpacket              (rx_sc_fifo_in_endofpacket),    
	.rx_sc_fifo_in_empty                    (rx_sc_fifo_in_empty),          
	.rx_sc_fifo_in_error                    (rx_sc_fifo_in_error),          
	.rx_sc_fifo_out_data                    (rx_sc_fifo_out_data),          
	.rx_sc_fifo_out_valid                   (rx_sc_fifo_out_valid),         
	.rx_sc_fifo_out_ready                   (rx_sc_fifo_out_ready),         
	.rx_sc_fifo_out_startofpacket           (rx_sc_fifo_out_startofpacket), 
	.rx_sc_fifo_out_endofpacket             (rx_sc_fifo_out_endofpacket),   
	.rx_sc_fifo_out_empty                   (rx_sc_fifo_out_empty),         
	.rx_sc_fifo_out_error                   (rx_sc_fifo_out_error)          


); 

// generator and checker and also loopback
eth_std_traffic_controller_top gen_mon_inst (

    .clk                 (tx_xcvr_half_clk),
	.reset_n             (sync_tx_half_rst_n),

	.avl_mm_read         (eth_gen_mon_avalon_anti_slave_0_read),
	.avl_mm_write        (eth_gen_mon_avalon_anti_slave_0_write),
	.avl_mm_waitrequest  (eth_gen_mon_avalon_anti_slave_0_waitrequest),
	.avl_mm_baddress     (eth_gen_mon_avalon_anti_slave_0_address),
	.avl_mm_readdata     (eth_gen_mon_avalon_anti_slave_0_readdata),
	.avl_mm_writedata    (eth_gen_mon_avalon_anti_slave_0_writedata),

    .mac_rx_status_data  (40'b0),
	.mac_rx_status_valid (1'b0),
	.mac_rx_status_error (1'b0),
	.stop_mon            (1'b0),
	.mon_active          (),
	.mon_done            (),
	.mon_error           (),

    .avl_st_tx_data      (tx_sc_fifo_in_data),
	.avl_st_tx_empty     (tx_sc_fifo_in_empty),
	.avl_st_tx_eop       (tx_sc_fifo_in_endofpacket),
	.avl_st_tx_error     (tx_sc_fifo_in_error),
	.avl_st_tx_ready     (tx_sc_fifo_in_ready),
	.avl_st_tx_sop       (tx_sc_fifo_in_startofpacket),
	.avl_st_tx_val       (tx_sc_fifo_in_valid),             

    .avl_st_rx_data      (rx_sc_fifo_out_data),
	.avl_st_rx_empty     (rx_sc_fifo_out_empty),
	.avl_st_rx_eop       (rx_sc_fifo_out_endofpacket),
	.avl_st_rx_error     (rx_sc_fifo_out_error),
	.avl_st_rx_ready     (rx_sc_fifo_out_ready),
	.avl_st_rx_sop       (rx_sc_fifo_out_startofpacket),
	.avl_st_rx_val       (rx_sc_fifo_out_valid)


);
      

// tx path clock by rx

altera_eth_avalon_st_adapter dc_fifo_adapter_inst(

	.csr_tx_adptdcff_rdwtrmrk	  (3'b010),
	.csr_tx_adptdcff_vldpkt_minwt (3'b010),
	.csr_tx_adptdcff_rdwtrmrk_dis (1'b0),

    .avalon_st_tx_clk_312         (tx_xcvr_clk),    
    .avalon_st_tx_312_reset_n     (sync_tx_rst_n),    
    .avalon_st_tx_clk_156         (tx_xcvr_half_clk),          
    .avalon_st_tx_156_reset_n     (sync_tx_half_rst_n),
    
    .avalon_st_tx_156_ready       (tx_sc_fifo_out_ready),         
    .avalon_st_tx_156_valid       (tx_sc_fifo_out_valid),         
    .avalon_st_tx_156_data        (tx_sc_fifo_out_data),          
    .avalon_st_tx_156_error       (tx_sc_fifo_out_error),         
    .avalon_st_tx_156_startofpacket(tx_sc_fifo_out_startofpacket), 
    .avalon_st_tx_156_endofpacket (tx_sc_fifo_out_endofpacket),   
    .avalon_st_tx_156_empty       (tx_sc_fifo_out_empty),
    
    .avalon_st_tx_312_ready       (mac_in_ready),        
    .avalon_st_tx_312_valid       (mac_in_valid),        
    .avalon_st_tx_312_data        (mac_in_data),         
    .avalon_st_tx_312_error       (mac_in_error),        
    .avalon_st_tx_312_startofpacket(mac_in_startofpacket),
    .avalon_st_tx_312_endofpacket (mac_in_endofpacket),  
    .avalon_st_tx_312_empty       (mac_in_empty),

    //rx clock and reset    
    .avalon_st_rx_clk_312         (rx_xcvr_clk),          
    .avalon_st_rx_312_reset_n     (sync_rx_rst_n),    
    .avalon_st_rx_clk_156         (tx_xcvr_half_clk),          
    .avalon_st_rx_156_reset_n     (sync_tx_half_rst_n),
 
    .avalon_st_rx_312_ready       (mac_out_ready),         
    .avalon_st_rx_312_valid       (mac_out_valid),         
    .avalon_st_rx_312_data        (mac_out_data),          
    .avalon_st_rx_312_error       (mac_out_error),         
    .avalon_st_rx_312_startofpacket(mac_out_startofpacket), 
    .avalon_st_rx_312_endofpacket (mac_out_endofpacket),   
    .avalon_st_rx_312_empty       (mac_out_empty),  

    .avalon_st_rx_156_ready      (rx_sc_fifo_in_ready),        
    .avalon_st_rx_156_valid      (rx_sc_fifo_in_valid),        
    .avalon_st_rx_156_data       (rx_sc_fifo_in_data),         
    .avalon_st_rx_156_error      (rx_sc_fifo_in_error),        
    .avalon_st_rx_156_startofpacket(rx_sc_fifo_in_startofpacket),
    .avalon_st_rx_156_endofpacket(rx_sc_fifo_in_endofpacket),  
    .avalon_st_rx_156_empty      (rx_sc_fifo_in_empty),

    // TX 1588 signals at 156mhz domain
    .tx_egress_timestamp_request_valid_156        (1'b0),
    .tx_egress_timestamp_request_fingerprint_156  (4'b0),    
    .tx_etstamp_ins_ctrl_timestamp_insert_156     (1'b0),
    .tx_etstamp_ins_ctrl_timestamp_format_156     (1'b0),
    .tx_etstamp_ins_ctrl_residence_time_update_156(1'b0),
    .tx_etstamp_ins_ctrl_ingress_timestamp_96b_156(96'b0),
    .tx_etstamp_ins_ctrl_ingress_timestamp_64b_156(64'b0),
    .tx_etstamp_ins_ctrl_residence_time_calc_format_156(1'b0),
    .tx_etstamp_ins_ctrl_checksum_zero_156        (1'b0),
    .tx_etstamp_ins_ctrl_checksum_correct_156     (1'b0),
    .tx_etstamp_ins_ctrl_offset_timestamp_156     (16'b0),
    .tx_etstamp_ins_ctrl_offset_correction_field_156(16'b0),
    .tx_etstamp_ins_ctrl_offset_checksum_field_156(16'b0),
    .tx_etstamp_ins_ctrl_offset_checksum_correction_156(16'b0),
    
    // TX 1588 signals at 312mhz domain

    .tx_egress_timestamp_96b_data_312             (96'b0),
    .tx_egress_timestamp_96b_valid_312            (1'b0),
    .tx_egress_timestamp_96b_fingerprint_312      (4'b0),
    .tx_egress_timestamp_64b_data_312             (64'b0),
    .tx_egress_timestamp_64b_valid_312            (1'b0),
    .tx_egress_timestamp_64b_fingerprint_312      (4'b0),
    

    //TX Status Signals
    .avalon_st_txstatus_valid_156                 (),
    .avalon_st_txstatus_data_156                  (),
    .avalon_st_txstatus_error_156                 (),
    
    .avalon_st_txstatus_valid_312                 (1'b0),
    .avalon_st_txstatus_data_312                  (40'b0),
    .avalon_st_txstatus_error_312                 (7'b0),
    
    //TX PFC Status Signals
    .avalon_st_tx_pfc_data_156                    (16'b0),       
    .avalon_st_tx_pfc_status_valid_312            (1'b0),
    .avalon_st_tx_pfc_status_data_312             (16'b0),  

    // TX Pause Data
    .avalon_st_tx_pause_data_156                 (2'b0),


    // Pause Quanta (For TX only variant)
    .avalon_st_tx_pause_length_valid_156          (1'b0),
    .avalon_st_tx_pause_length_data_156           (16'b0),     

    // RX 1588 signals
    .rx_ingress_timestamp_96b_valid_312           (1'b0),
    .rx_ingress_timestamp_96b_data_312            (96'b0),
    .rx_ingress_timestamp_64b_valid_312           (1'b0),
    .rx_ingress_timestamp_64b_data_312            (64'b0),

    //RX Status Signals

    
   .avalon_st_rxstatus_valid_312                 (1'b0),
   .avalon_st_rxstatus_data_312                  (40'b0),
   .avalon_st_rxstatus_error_312                 (7'b0),

    //RX PFC Status Signals
    .avalon_st_rx_pfc_pause_data_312              (8'b0),
    .avalon_st_rx_pfc_status_valid_312            (1'b0),
    .avalon_st_rx_pfc_status_data_312             (16'b0),      
    
    
    // Pause Quanta (For RX only variant)
    .avalon_st_rx_pause_length_valid_312           (1'b0),
    .avalon_st_rx_pause_length_data_312            (16'b0),

    .tx_egress_timestamp_96b_data_156			(),
    .tx_egress_timestamp_96b_valid_156			(),
    .tx_egress_timestamp_96b_fingerprint_156		(),
    .tx_egress_timestamp_64b_data_156			(),
    .tx_egress_timestamp_64b_valid_156			(),
    .tx_egress_timestamp_64b_fingerprint_156		(),
    .tx_egress_timestamp_request_valid_312		(),
    .tx_egress_timestamp_request_fingerprint_312	(),
    .tx_etstamp_ins_ctrl_timestamp_insert_312		(),
    .tx_etstamp_ins_ctrl_timestamp_format_312		(),

    .tx_etstamp_ins_ctrl_residence_time_update_312	(),
    .tx_etstamp_ins_ctrl_ingress_timestamp_96b_312	(),
    .tx_etstamp_ins_ctrl_ingress_timestamp_64b_312	(),
    .tx_etstamp_ins_ctrl_residence_time_calc_format_312	(),
    .tx_etstamp_ins_ctrl_checksum_zero_312		(),
    .tx_etstamp_ins_ctrl_checksum_correct_312		(),
    .tx_etstamp_ins_ctrl_offset_timestamp_312		(),
    .tx_etstamp_ins_ctrl_offset_correction_field_312	(),
    .tx_etstamp_ins_ctrl_offset_checksum_field_312	(),
    .tx_etstamp_ins_ctrl_offset_checksum_correction_312	(),

    .avalon_st_tx_pfc_data_312				(),
    .avalon_st_tx_pfc_status_valid_156			(),
    .avalon_st_tx_pfc_status_data_156			(),
    .avalon_st_tx_pause_data_312			(),
    .avalon_st_tx_pause_length_valid_312		(),
    .avalon_st_tx_pause_length_data_312			(),
    .rx_ingress_timestamp_96b_valid_156			(),
    .rx_ingress_timestamp_96b_data_156			(),
    .rx_ingress_timestamp_64b_valid_156			(),
    .rx_ingress_timestamp_64b_data_156			(),

    .avalon_st_rxstatus_valid_156			(),
    .avalon_st_rxstatus_data_156			(),
    .avalon_st_rxstatus_error_156			(),
    .avalon_st_rx_pfc_pause_data_156			(),
    .avalon_st_rx_pfc_status_valid_156			(),
    .avalon_st_rx_pfc_status_data_156			(),
    .avalon_st_rx_pause_length_valid_156		(),
    .avalon_st_rx_pause_length_data_156			()

);

altera_reset_synchronizer # (
        .ASYNC_RESET(1),
        .DEPTH      (4)  
    ) tx_reset_synchronizer_inst(
        .clk(tx_xcvr_clk),
        .reset_in(~tx_rst_n),
        .reset_out(sync_tx_rst)
    );

altera_reset_synchronizer # (
        .ASYNC_RESET(1),
        .DEPTH      (4)  
    ) rx_reset_synchronizer_inst(
        .clk(rx_xcvr_clk),
        .reset_in(~rx_rst_n),
        .reset_out(sync_rx_rst)
    );   

    
altera_reset_synchronizer # (
        .ASYNC_RESET(1),
        .DEPTH      (4)  
    ) tx_half_clk_reset_synchronizer_inst(
        .clk(tx_xcvr_half_clk),
        .reset_in(~tx_rst_n),
        .reset_out(sync_tx_half_rst)
    );

altera_reset_synchronizer # (
        .ASYNC_RESET(1),
        .DEPTH      (4)  
    ) rx_half_clk_reset_synchronizer_inst(
        .clk(rx_xcvr_half_clk),
        .reset_in(~rx_rst_n),
        .reset_out(sync_rx_half_rst)
    );     
    
	 
endmodule 
