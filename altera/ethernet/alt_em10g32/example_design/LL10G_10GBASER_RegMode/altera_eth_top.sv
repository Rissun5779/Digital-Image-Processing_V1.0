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


module altera_eth_top ( 

	input   wire 			csr_clk,
	output  wire			tx_xcvr_clk,
	output  wire			rx_xcvr_clk,	
	input   wire			ref_clk_clk, 

    input   wire            master_reset_n,

    output  wire            sfp_txdisable,
    output  wire            xfp_txdisable,

    output  wire [1:0]      SFPP_RATE_SEL,
    
    // LED
    output  wire            block_lock_n,
    output  wire            tx_ready_export_n,
    output  wire            rx_ready_export_n,
    
    // debug clock
    input   wire            debug_clk,
    output  wire            rx_xcvr_half_clk,
    output  wire            tx_xcvr_half_clk,
	
	output  wire			tx_serial_data,
	input   wire			rx_serial_data
    

);

wire			csr_rst_n;
wire			tx_rst_n; 
wire			rx_rst_n; 

wire            block_lock;
wire            tx_ready_export;
wire            rx_ready_export;



assign csr_rst_n = master_reset_n;
assign tx_rst_n = master_reset_n;
assign rx_rst_n = master_reset_n; 

assign sfp_txdisable = 1'b0;
assign xfp_txdisable= 1'b0; 

assign SFPP_RATE_SEL = 2'b11;

assign block_lock_n = ~block_lock;
assign tx_ready_export_n = ~tx_ready_export;
assign rx_ready_export_n = ~rx_ready_export;


altera_eth_10g_mac_base_r_low_latency dut_inst(

	.csr_clk            (csr_clk),
	.csr_rst_n          (csr_rst_n),
	.tx_xcvr_clk        (tx_xcvr_clk),
	.tx_rst_n           (tx_rst_n),
	.rx_xcvr_clk        (rx_xcvr_clk),
	.rx_rst_n           (rx_rst_n),
	.ref_clk_clk        (ref_clk_clk),
    
    .rx_xcvr_half_clk   (rx_xcvr_half_clk),
    .tx_xcvr_half_clk   (tx_xcvr_half_clk),
    


	// csr interface
	.csr_read           (1'b0),
	.csr_write          (1'b0),
	.csr_writedata      (32'b0),
	.csr_readdata       (),
	.csr_address        (32'b0),
	.csr_waitrequest    (),
    
    .tx_ready_export    (tx_ready_export),
    .rx_ready_export    (rx_ready_export),
    .block_lock         (block_lock),
	
	.tx_serial_data     (tx_serial_data),
	.rx_serial_data     (rx_serial_data)
    


);

endmodule