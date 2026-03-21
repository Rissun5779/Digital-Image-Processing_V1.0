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



module altera_eth_10g_mac_base_r (

    csr_clk,
    csr_rst_n,
    core_clk_312,
    tx_rst_n,
    rx_rst_n,
    
    ref_clk_clk,


    // csr interface
    csr_read,
    csr_write,
    csr_writedata,
    csr_readdata,
    csr_address,
    csr_waitrequest,

    tx_ready_export,
    rx_ready_export,
    block_lock, 
    atx_pll_locked,
    core_pll_locked,
    
    //output clock
    core_clk_156,
    
    tx_serial_data,
    rx_serial_data 

);

parameter   NUM_CHANNELS            = 2;                                               // range from 1-2
parameter   DEVICE_FAMILY           = "Stratix 10";

localparam  MAX_NUM_CHANNELS        = 2;

input wire                          csr_clk;
input wire                          csr_rst_n;
output wire                                 core_clk_312;
input wire                          tx_rst_n;
input wire                          rx_rst_n;

input wire                          ref_clk_clk;

// csr interface
input wire                          csr_read;
input wire                          csr_write;
input wire  [31:0]                  csr_writedata;
output wire [31:0]                  csr_readdata;
input wire  [15:0]                  csr_address;
output wire                         csr_waitrequest;

output wire [NUM_CHANNELS-1:0]      tx_ready_export;
output wire [NUM_CHANNELS-1:0]      rx_ready_export;
output wire [NUM_CHANNELS-1:0]      block_lock;
output wire [NUM_CHANNELS-1:0]      atx_pll_locked;
output wire                         core_pll_locked;

//output clock
output wire                         core_clk_156;

output wire [NUM_CHANNELS-1:0]      tx_serial_data;
input wire  [NUM_CHANNELS-1:0]      rx_serial_data;

wire    [NUM_CHANNELS-1:0]              mac_csr_read_32;
wire    [NUM_CHANNELS-1:0]              mac_csr_write_32;
wire    [NUM_CHANNELS-1:0][31:0]        mac_csr_readdata_32;
wire    [NUM_CHANNELS-1:0][31:0]        mac_csr_writedata_32;
wire    [NUM_CHANNELS-1:0]              mac_csr_waitrequest_32;
wire    [NUM_CHANNELS-1:0][9:0]         mac_csr_address_32;

wire    [MAX_NUM_CHANNELS-1:0]          mac_csr_read_64;
wire    [MAX_NUM_CHANNELS-1:0]          mac_csr_write_64;
wire    [MAX_NUM_CHANNELS-1:0][31:0]    mac_csr_readdata_64;
wire    [MAX_NUM_CHANNELS-1:0][31:0]    mac_csr_writedata_64;
wire    [MAX_NUM_CHANNELS-1:0]          mac_csr_waitrequest_64;
wire    [MAX_NUM_CHANNELS-1:0][13:0]    mac_csr_address_64;

wire    [MAX_NUM_CHANNELS-1:0]          phy_csr_read;
wire    [MAX_NUM_CHANNELS-1:0]          phy_csr_write;
wire    [MAX_NUM_CHANNELS-1:0][31:0]    phy_csr_readdata;
wire    [MAX_NUM_CHANNELS-1:0][31:0]    phy_csr_writedata;
wire    [MAX_NUM_CHANNELS-1:0]          phy_csr_waitrequest;
wire    [MAX_NUM_CHANNELS-1:0][9:0]     phy_csr_address;

wire    [NUM_CHANNELS-1:0][1:0]         avalon_st_pause_data;
wire    [NUM_CHANNELS-1:0][1:0]         avalon_st_pause_data_sync;


wire    [NUM_CHANNELS-1:0][63:0]        tx_sc_fifo_in_data;          
wire    [NUM_CHANNELS-1:0]              tx_sc_fifo_in_valid;         
wire    [NUM_CHANNELS-1:0]              tx_sc_fifo_in_ready;         
wire    [NUM_CHANNELS-1:0]              tx_sc_fifo_in_startofpacket; 
wire    [NUM_CHANNELS-1:0]              tx_sc_fifo_in_endofpacket;   
wire    [NUM_CHANNELS-1:0][2:0]         tx_sc_fifo_in_empty;         
wire    [NUM_CHANNELS-1:0]              tx_sc_fifo_in_error; 
        
wire    [NUM_CHANNELS-1:0][63:0]        tx_sc_fifo_out_data;         
wire    [NUM_CHANNELS-1:0]              tx_sc_fifo_out_valid;        
wire    [NUM_CHANNELS-1:0]              tx_sc_fifo_out_ready;        
wire    [NUM_CHANNELS-1:0]              tx_sc_fifo_out_startofpacket;
wire    [NUM_CHANNELS-1:0]              tx_sc_fifo_out_endofpacket;  
wire    [NUM_CHANNELS-1:0][2:0]         tx_sc_fifo_out_empty;        
wire    [NUM_CHANNELS-1:0]              tx_sc_fifo_out_error; 

wire    [NUM_CHANNELS-1:0][63:0]        rx_sc_fifo_in_data;          
wire    [NUM_CHANNELS-1:0]              rx_sc_fifo_in_valid;         
wire    [NUM_CHANNELS-1:0]              rx_sc_fifo_in_ready;         
wire    [NUM_CHANNELS-1:0]              rx_sc_fifo_in_startofpacket; 
wire    [NUM_CHANNELS-1:0]              rx_sc_fifo_in_endofpacket;   
wire    [NUM_CHANNELS-1:0][2:0]         rx_sc_fifo_in_empty;         
wire    [NUM_CHANNELS-1:0][5:0]         rx_sc_fifo_in_error;   
      
wire    [NUM_CHANNELS-1:0][63:0]        rx_sc_fifo_out_data;         
wire    [NUM_CHANNELS-1:0]              rx_sc_fifo_out_valid;        
wire    [NUM_CHANNELS-1:0]              rx_sc_fifo_out_ready;        
wire    [NUM_CHANNELS-1:0]              rx_sc_fifo_out_startofpacket;
wire    [NUM_CHANNELS-1:0]              rx_sc_fifo_out_endofpacket;  
wire    [NUM_CHANNELS-1:0][2:0]         rx_sc_fifo_out_empty;        
wire    [NUM_CHANNELS-1:0][5:0]         rx_sc_fifo_out_error;         

wire    [MAX_NUM_CHANNELS-1:0][2:0]     tx_sc_fifo_csr_address;
wire    [MAX_NUM_CHANNELS-1:0]          tx_sc_fifo_csr_read;
wire    [MAX_NUM_CHANNELS-1:0]          tx_sc_fifo_csr_write;
wire    [MAX_NUM_CHANNELS-1:0][31:0]    tx_sc_fifo_csr_readdata;
wire    [MAX_NUM_CHANNELS-1:0][31:0]    tx_sc_fifo_csr_writedata;

wire    [MAX_NUM_CHANNELS-1:0][2:0]     rx_sc_fifo_csr_address;
wire    [MAX_NUM_CHANNELS-1:0]          rx_sc_fifo_csr_read;
wire    [MAX_NUM_CHANNELS-1:0]          rx_sc_fifo_csr_write;
wire    [MAX_NUM_CHANNELS-1:0][31:0]    rx_sc_fifo_csr_readdata;
wire    [MAX_NUM_CHANNELS-1:0][31:0]    rx_sc_fifo_csr_writedata;

wire    [MAX_NUM_CHANNELS-1:0][11:0]    eth_gen_mon_avalon_anti_slave_0_address;   
wire    [MAX_NUM_CHANNELS-1:0]          eth_gen_mon_avalon_anti_slave_0_write;    
wire    [MAX_NUM_CHANNELS-1:0]          eth_gen_mon_avalon_anti_slave_0_read;      
wire    [MAX_NUM_CHANNELS-1:0][31:0]    eth_gen_mon_avalon_anti_slave_0_readdata;  
wire    [MAX_NUM_CHANNELS-1:0][31:0]    eth_gen_mon_avalon_anti_slave_0_writedata;
wire    [MAX_NUM_CHANNELS-1:0]          eth_gen_mon_avalon_anti_slave_0_waitrequest;


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

wire    [NUM_CHANNELS-1:0][31:0]    mac_in_data;
wire    [NUM_CHANNELS-1:0]          mac_in_valid;
wire    [NUM_CHANNELS-1:0]          mac_in_ready;
wire    [NUM_CHANNELS-1:0]          mac_in_startofpacket;
wire    [NUM_CHANNELS-1:0]          mac_in_endofpacket;
wire    [NUM_CHANNELS-1:0][1:0]     mac_in_empty;
wire    [NUM_CHANNELS-1:0][0:0]     mac_in_error;

wire    [NUM_CHANNELS-1:0][31:0]    mac_out_data;
wire    [NUM_CHANNELS-1:0]          mac_out_valid;
wire    [NUM_CHANNELS-1:0]          mac_out_ready;
wire    [NUM_CHANNELS-1:0]          mac_out_startofpacket;
wire    [NUM_CHANNELS-1:0]          mac_out_endofpacket;
wire    [NUM_CHANNELS-1:0][1:0]     mac_out_empty;
wire    [NUM_CHANNELS-1:0][5:0]     mac_out_error;


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

generate

    if(DEVICE_FAMILY == "Stratix 10")
    begin
        pll fpll_inst (
                .pll_refclk0    (ref_clk_clk), 
                .pll_cal_busy   (),    
                .outclk_div2    (core_clk_156),             // 156.25MHz clock
                .outclk_div1    (core_clk_312),             // 312.50MHz clock
                .pll_locked     (core_pll_locked)
            );  
    end
    else
    begin
        pll pll_inst (
            .refclk         (ref_clk_clk), 
            .rst            (~tx_rst_n),    
            .outclk_0       (core_clk_156),             // 156.25MHz clock
            .outclk_1       (core_clk_312),             // 312.50MHz clock
            .locked         (core_pll_locked)
        ); 
    end
endgenerate

//========== start loop=======================================
    
genvar portid;
generate
 
 
for (portid =0; portid < NUM_CHANNELS; portid = portid+1)
begin: CHANNEL

altera_eth_10g_mac_base_r_wrap wrapper_inst (
    
        .csr_clk            (csr_clk),
        .csr_rst_n          (csr_rst_n),
        .tx_clk_312         (core_clk_312),
        .tx_clk_156         (core_clk_156),
        .tx_rst_n           (tx_rst_n),
        .rx_clk_312         (core_clk_312),
        .rx_clk_156         (core_clk_156),
        .rx_rst_n           (rx_rst_n), 
        
        .ref_clk_clk        (ref_clk_clk),
    
        .avalon_st_tx_startofpacket (mac_in_startofpacket[portid]),
        .avalon_st_tx_endofpacket   (mac_in_endofpacket[portid]),
        .avalon_st_tx_valid         (mac_in_valid[portid]),
        .avalon_st_tx_data          (mac_in_data[portid]),
        .avalon_st_tx_empty         (mac_in_empty[portid]),
        .avalon_st_tx_ready         (mac_in_ready[portid]),
        .avalon_st_tx_error         (mac_in_error[portid]),
        
        .avalon_st_rx_startofpacket (mac_out_startofpacket[portid]),
        .avalon_st_rx_endofpacket   (mac_out_endofpacket[portid]),
        .avalon_st_rx_valid         (mac_out_valid[portid]),
        .avalon_st_rx_data          (mac_out_data[portid]),
        .avalon_st_rx_empty         (mac_out_empty[portid]),
        .avalon_st_rx_ready         (mac_out_ready[portid]),
        .avalon_st_rx_error         (mac_out_error[portid]),

        .avalon_st_pause_data       (avalon_st_pause_data_sync[portid]),    
        .avalon_st_txstatus_valid   (avalon_st_txstatus_valid),
        .avalon_st_txstatus_data    (), 
        .avalon_st_txstatus_error   (),
        
        .avalon_st_rxstatus_valid   (avalon_st_rxstatus_valid),                                  
        .avalon_st_rxstatus_error   (),                                  
        .avalon_st_rxstatus_data    (),
        
        .link_fault_status_xgmii_rx_data    (),
    
    
        .tx_ready_export    (tx_ready_export[portid]),
        .rx_ready_export    (rx_ready_export[portid]),
        .block_lock         (block_lock[portid]),
        .atx_pll_locked     (atx_pll_locked[portid]),
        
        
        .tx_serial_data     (tx_serial_data[portid]),
        .rx_serial_data     (rx_serial_data[portid]),
        
        
        .mac_csr_read       (mac_csr_read_32[portid]),
        .mac_csr_write      (mac_csr_write_32[portid]),
        .mac_csr_readdata   (mac_csr_readdata_32[portid]),
        .mac_csr_writedata  (mac_csr_writedata_32[portid]),
        .mac_csr_waitrequest(mac_csr_waitrequest_32[portid]),
        .mac_csr_address    (mac_csr_address_32[portid]),
        
        .phy_csr_read       (phy_csr_read[portid]),
        .phy_csr_write      (phy_csr_write[portid]),
        .phy_csr_readdata   (phy_csr_readdata[portid]),
        .phy_csr_writedata  (phy_csr_writedata[portid]),
        .phy_csr_waitrequest(phy_csr_waitrequest[portid]),
        .phy_csr_address    (phy_csr_address[portid])
    );

    sc_fifo fifo_inst(
    
        .tx_sc_fifo_csr_address                 (tx_sc_fifo_csr_address[portid]),       
        .tx_sc_fifo_csr_read                    (tx_sc_fifo_csr_read[portid]),          
        .tx_sc_fifo_csr_write                   (tx_sc_fifo_csr_write[portid]),         
        .tx_sc_fifo_csr_readdata                (tx_sc_fifo_csr_readdata[portid]),      
        .tx_sc_fifo_csr_writedata               (tx_sc_fifo_csr_writedata[portid]),     
        .rx_sc_fifo_csr_address                 (rx_sc_fifo_csr_address[portid]),       
        .rx_sc_fifo_csr_read                    (rx_sc_fifo_csr_read[portid]),          
        .rx_sc_fifo_csr_write                   (rx_sc_fifo_csr_write[portid]),         
        .rx_sc_fifo_csr_readdata                (rx_sc_fifo_csr_readdata[portid]),      
        .rx_sc_fifo_csr_writedata               (rx_sc_fifo_csr_writedata[portid]),     
        .tx_sc_fifo_clk_clk                     (core_clk_156),           
        .tx_sc_fifo_clk_reset_reset             (~sync_tx_half_rst_n),   
        .tx_sc_fifo_in_data                     (tx_sc_fifo_in_data[portid]),           
        .tx_sc_fifo_in_valid                    (tx_sc_fifo_in_valid[portid]),          
        .tx_sc_fifo_in_ready                    (tx_sc_fifo_in_ready[portid]),          
        .tx_sc_fifo_in_startofpacket            (tx_sc_fifo_in_startofpacket[portid]),  
        .tx_sc_fifo_in_endofpacket              (tx_sc_fifo_in_endofpacket[portid]),    
        .tx_sc_fifo_in_empty                    (tx_sc_fifo_in_empty[portid]),          
        .tx_sc_fifo_in_error                    (tx_sc_fifo_in_error[portid]),          
        .tx_sc_fifo_out_data                    (tx_sc_fifo_out_data[portid]),          
        .tx_sc_fifo_out_valid                   (tx_sc_fifo_out_valid[portid]),         
        .tx_sc_fifo_out_ready                   (tx_sc_fifo_out_ready[portid]),         
        .tx_sc_fifo_out_startofpacket           (tx_sc_fifo_out_startofpacket[portid]), 
        .tx_sc_fifo_out_endofpacket             (tx_sc_fifo_out_endofpacket[portid]),   
        .tx_sc_fifo_out_empty                   (tx_sc_fifo_out_empty[portid]),         
        .tx_sc_fifo_out_error                   (tx_sc_fifo_out_error[portid]),         
        .rx_sc_fifo_clk_clk                     (core_clk_156),           
        .rx_sc_fifo_clk_reset_reset             (~sync_tx_half_rst_n),   
        .rx_sc_fifo_almost_full_data            (avalon_st_pause_data[portid][1]),    
        .rx_sc_fifo_almost_empty_data           (avalon_st_pause_data[portid][0]),    
        .rx_sc_fifo_in_data                     (rx_sc_fifo_in_data[portid]),           
        .rx_sc_fifo_in_valid                    (rx_sc_fifo_in_valid[portid]),          
        .rx_sc_fifo_in_ready                    (rx_sc_fifo_in_ready[portid]),          
        .rx_sc_fifo_in_startofpacket            (rx_sc_fifo_in_startofpacket[portid]),  
        .rx_sc_fifo_in_endofpacket              (rx_sc_fifo_in_endofpacket[portid]),    
        .rx_sc_fifo_in_empty                    (rx_sc_fifo_in_empty[portid]),          
        .rx_sc_fifo_in_error                    (rx_sc_fifo_in_error[portid]),          
        .rx_sc_fifo_out_data                    (rx_sc_fifo_out_data[portid]),          
        .rx_sc_fifo_out_valid                   (rx_sc_fifo_out_valid[portid]),         
        .rx_sc_fifo_out_ready                   (rx_sc_fifo_out_ready[portid]),         
        .rx_sc_fifo_out_startofpacket           (rx_sc_fifo_out_startofpacket[portid]), 
        .rx_sc_fifo_out_endofpacket             (rx_sc_fifo_out_endofpacket[portid]),   
        .rx_sc_fifo_out_empty                   (rx_sc_fifo_out_empty[portid]),         
        .rx_sc_fifo_out_error                   (rx_sc_fifo_out_error[portid])          
    ); 

    // csr adapter
    altera_eth_avalon_mm_adapter csr_adapter_inst(
    
        // Avalon Slave Interface
        .sl_clock               (csr_clk),
        .sl_reset               (~csr_rst_n),    
        .sl_csr_readdata_o      (mac_csr_readdata_64[portid]),
        .sl_csr_address_i       (mac_csr_address_64[portid][12:0]),
        .sl_csr_read_i          (mac_csr_read_64[portid]),
        .sl_csr_write_i         (mac_csr_write_64[portid]),
        .sl_csr_writedata_i     (mac_csr_writedata_64[portid]),
        .sl_csr_waitrequest_o   (mac_csr_waitrequest_64[portid]),
    
        // Avalon Master Interface
        .ms_clock               (),
        .ms_reset               (),    
        .ms_csr_readdata_i      (mac_csr_readdata_32[portid]),
        .ms_csr_address_o       (mac_csr_address_32[portid]),
        .ms_csr_read_o          (mac_csr_read_32[portid]),
        .ms_csr_write_o         (mac_csr_write_32[portid]),
        .ms_csr_writedata_o     (mac_csr_writedata_32[portid]),
        .ms_csr_waitrequest_i   (mac_csr_waitrequest_32[portid])
    
    );

    // generator and checker and also loopback
    eth_std_traffic_controller_top #(
        .DEVICE_FAMILY (DEVICE_FAMILY)
        ) gen_mon_inst (
    
        .clk                 (core_clk_156),
        .reset_n             (sync_tx_half_rst_n),
    
        .avl_mm_read         (eth_gen_mon_avalon_anti_slave_0_read[portid]),
        .avl_mm_write        (eth_gen_mon_avalon_anti_slave_0_write[portid]),
        .avl_mm_waitrequest  (eth_gen_mon_avalon_anti_slave_0_waitrequest[portid]),
        .avl_mm_baddress     (eth_gen_mon_avalon_anti_slave_0_address[portid]),
        .avl_mm_readdata     (eth_gen_mon_avalon_anti_slave_0_readdata[portid]),
        .avl_mm_writedata    (eth_gen_mon_avalon_anti_slave_0_writedata[portid]),
    
        .mac_rx_status_data  (40'b0),
        .mac_rx_status_valid (1'b0),
        .mac_rx_status_error (1'b0),
        .stop_mon            (1'b0),
        .mon_active          (),
        .mon_done            (),
        .mon_error           (),
    
        .avl_st_tx_data      (tx_sc_fifo_in_data[portid]),
        .avl_st_tx_empty     (tx_sc_fifo_in_empty[portid]),
        .avl_st_tx_eop       (tx_sc_fifo_in_endofpacket[portid]),
        .avl_st_tx_error     (tx_sc_fifo_in_error[portid]),
        .avl_st_tx_ready     (tx_sc_fifo_in_ready[portid]),
        .avl_st_tx_sop       (tx_sc_fifo_in_startofpacket[portid]),
        .avl_st_tx_val       (tx_sc_fifo_in_valid[portid]),             
    
        .avl_st_rx_data      (rx_sc_fifo_out_data[portid]),
        .avl_st_rx_empty     (rx_sc_fifo_out_empty[portid]),
        .avl_st_rx_eop       (rx_sc_fifo_out_endofpacket[portid]),
        .avl_st_rx_error     (rx_sc_fifo_out_error[portid]),
        .avl_st_rx_ready     (rx_sc_fifo_out_ready[portid]),
        .avl_st_rx_sop       (rx_sc_fifo_out_startofpacket[portid]),
        .avl_st_rx_val       (rx_sc_fifo_out_valid[portid])
    
    );
      

    // tx path clock by rx
    
    altera_eth_avalon_st_adapter #(
        .DEVICE_FAMILY (DEVICE_FAMILY)
        ) dc_fifo_adapter_inst(
    
        .csr_tx_adptdcff_rdwtrmrk     (3'b010),
        .csr_tx_adptdcff_vldpkt_minwt (3'b010),
        .csr_tx_adptdcff_rdwtrmrk_dis (1'b0),
    
        .avalon_st_tx_clk_312         (core_clk_312),    
        .avalon_st_tx_312_reset_n     (sync_tx_rst_n),    
        .avalon_st_tx_clk_156         (core_clk_156),          
        .avalon_st_tx_156_reset_n     (sync_tx_half_rst_n),
        
        .avalon_st_tx_156_ready       (tx_sc_fifo_out_ready[portid]),         
        .avalon_st_tx_156_valid       (tx_sc_fifo_out_valid[portid]),         
        .avalon_st_tx_156_data        (tx_sc_fifo_out_data[portid]),          
        .avalon_st_tx_156_error       (tx_sc_fifo_out_error[portid]),         
        .avalon_st_tx_156_startofpacket(tx_sc_fifo_out_startofpacket[portid]), 
        .avalon_st_tx_156_endofpacket (tx_sc_fifo_out_endofpacket[portid]),   
        .avalon_st_tx_156_empty       (tx_sc_fifo_out_empty[portid]),
        
        .avalon_st_tx_312_ready       (mac_in_ready[portid]),        
        .avalon_st_tx_312_valid       (mac_in_valid[portid]),        
        .avalon_st_tx_312_data        (mac_in_data[portid]),         
        .avalon_st_tx_312_error       (mac_in_error[portid]),        
        .avalon_st_tx_312_startofpacket(mac_in_startofpacket[portid]),
        .avalon_st_tx_312_endofpacket (mac_in_endofpacket[portid]),  
        .avalon_st_tx_312_empty       (mac_in_empty[portid]),
    
        //rx clock and reset    
        .avalon_st_rx_clk_312         (core_clk_312),          
        .avalon_st_rx_312_reset_n     (sync_rx_rst_n),    
        .avalon_st_rx_clk_156         (core_clk_156),          
        .avalon_st_rx_156_reset_n     (sync_tx_half_rst_n),
     
        .avalon_st_rx_312_ready       (mac_out_ready[portid]),         
        .avalon_st_rx_312_valid       (mac_out_valid[portid]),         
        .avalon_st_rx_312_data        (mac_out_data[portid]),          
        .avalon_st_rx_312_error       (mac_out_error[portid]),         
        .avalon_st_rx_312_startofpacket(mac_out_startofpacket[portid]), 
        .avalon_st_rx_312_endofpacket (mac_out_endofpacket[portid]),   
        .avalon_st_rx_312_empty       (mac_out_empty[portid]),  
    
        .avalon_st_rx_156_ready      (rx_sc_fifo_in_ready[portid]),        
        .avalon_st_rx_156_valid      (rx_sc_fifo_in_valid[portid]),        
        .avalon_st_rx_156_data       (rx_sc_fifo_in_data[portid]),         
        .avalon_st_rx_156_error      (rx_sc_fifo_in_error[portid]),        
        .avalon_st_rx_156_startofpacket(rx_sc_fifo_in_startofpacket[portid]),
        .avalon_st_rx_156_endofpacket(rx_sc_fifo_in_endofpacket[portid]),  
        .avalon_st_rx_156_empty      (rx_sc_fifo_in_empty[portid]),
    
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
        .avalon_st_tx_pause_data_156                  (2'b0),
    
    
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
    
        .tx_egress_timestamp_96b_data_156           (),
        .tx_egress_timestamp_96b_valid_156          (),
        .tx_egress_timestamp_96b_fingerprint_156        (),
        .tx_egress_timestamp_64b_data_156           (),
        .tx_egress_timestamp_64b_valid_156          (),
        .tx_egress_timestamp_64b_fingerprint_156        (),
        .tx_egress_timestamp_request_valid_312      (),
        .tx_egress_timestamp_request_fingerprint_312    (),
        .tx_etstamp_ins_ctrl_timestamp_insert_312       (),
        .tx_etstamp_ins_ctrl_timestamp_format_312       (),
    
        .tx_etstamp_ins_ctrl_residence_time_update_312  (),
        .tx_etstamp_ins_ctrl_ingress_timestamp_96b_312  (),
        .tx_etstamp_ins_ctrl_ingress_timestamp_64b_312  (),
        .tx_etstamp_ins_ctrl_residence_time_calc_format_312 (),
        .tx_etstamp_ins_ctrl_checksum_zero_312      (),
        .tx_etstamp_ins_ctrl_checksum_correct_312       (),
        .tx_etstamp_ins_ctrl_offset_timestamp_312       (),
        .tx_etstamp_ins_ctrl_offset_correction_field_312    (),
        .tx_etstamp_ins_ctrl_offset_checksum_field_312  (),
        .tx_etstamp_ins_ctrl_offset_checksum_correction_312 (),
    
        .avalon_st_tx_pfc_data_312              (),
        .avalon_st_tx_pfc_status_valid_156          (),
        .avalon_st_tx_pfc_status_data_156           (),
        .avalon_st_tx_pause_data_312            (),
        .avalon_st_tx_pause_length_valid_312        (),
        .avalon_st_tx_pause_length_data_312         (),
        .rx_ingress_timestamp_96b_valid_156         (),
        .rx_ingress_timestamp_96b_data_156          (),
        .rx_ingress_timestamp_64b_valid_156         (),
        .rx_ingress_timestamp_64b_data_156          (),
    
        .avalon_st_rxstatus_valid_156           (),
        .avalon_st_rxstatus_data_156            (),
        .avalon_st_rxstatus_error_156           (),
        .avalon_st_rx_pfc_pause_data_156            (),
        .avalon_st_rx_pfc_status_valid_156          (),
        .avalon_st_rx_pfc_status_data_156           (),
        .avalon_st_rx_pause_length_valid_156        (),
        .avalon_st_rx_pause_length_data_156         ()
    
    );

    altera_std_synchronizer #(.depth(2)) almost_empty_sync (
        .clk(core_clk_312),
        .reset_n(tx_rst_n),
        .din(avalon_st_pause_data[portid][0]),
        .dout(avalon_st_pause_data_sync[portid][0])

    );

    altera_std_synchronizer #(.depth(2)) almost_full_sync (
        .clk(core_clk_312),
        .reset_n(tx_rst_n),
        .din(avalon_st_pause_data[portid][1]),
        .dout(avalon_st_pause_data_sync[portid][1])

    );

end //end for

endgenerate 

address_decode address_decoder_inst (

    .clk_csr_clk                                                    (csr_clk),                                                
    .csr_reset_n                                                    (csr_rst_n),

    .tx_xcvr_half_clk_clk                                           (core_clk_156),     
    .sync_tx_half_rst_reset_n                                       (sync_tx_half_rst_n), 
    .tx_xcvr_clk_clk                                                (core_clk_312),          
    .sync_tx_rst_reset_n                                            (sync_tx_rst_n),      
    .rx_xcvr_clk_clk                                                (core_clk_312),          
    .sync_rx_rst_reset_n                                            (sync_rx_rst_n),     

    .merlin_master_translator_0_avalon_anti_master_0_address        (csr_address),    
    .merlin_master_translator_0_avalon_anti_master_0_waitrequest    (csr_waitrequest),
    .merlin_master_translator_0_avalon_anti_master_0_read           (csr_read),       
    .merlin_master_translator_0_avalon_anti_master_0_readdata       (csr_readdata),   
    .merlin_master_translator_0_avalon_anti_master_0_write          (csr_write),      
    .merlin_master_translator_0_avalon_anti_master_0_writedata      (csr_writedata),  
    .mac_0_avalon_anti_slave_0_address                              (mac_csr_address_64[0][12:0]),                            
    .mac_0_avalon_anti_slave_0_write                                (mac_csr_write_64[0]),                              
    .mac_0_avalon_anti_slave_0_read                                 (mac_csr_read_64[0]),                               
    .mac_0_avalon_anti_slave_0_readdata                             (mac_csr_readdata_64[0]),                           
    .mac_0_avalon_anti_slave_0_writedata                            (mac_csr_writedata_64[0]),                          
    .mac_0_avalon_anti_slave_0_waitrequest                          (mac_csr_waitrequest_64[0]),                        
    .phy_0_avalon_anti_slave_0_address                              (phy_csr_address[0]),                            
    .phy_0_avalon_anti_slave_0_write                                (phy_csr_write[0]),                              
    .phy_0_avalon_anti_slave_0_read                                 (phy_csr_read[0]),                               
    .phy_0_avalon_anti_slave_0_readdata                             (phy_csr_readdata[0]),                           
    .phy_0_avalon_anti_slave_0_writedata                            (phy_csr_writedata[0]),                          
    .phy_0_avalon_anti_slave_0_waitrequest                          (phy_csr_waitrequest[0]),

    .mac_1_avalon_anti_slave_0_address                              (mac_csr_address_64[1][12:0]),                            
    .mac_1_avalon_anti_slave_0_write                                (mac_csr_write_64[1]),                              
    .mac_1_avalon_anti_slave_0_read                                 (mac_csr_read_64[1]),                               
    .mac_1_avalon_anti_slave_0_readdata                             (mac_csr_readdata_64[1]),                           
    .mac_1_avalon_anti_slave_0_writedata                            (mac_csr_writedata_64[1]),                          
    .mac_1_avalon_anti_slave_0_waitrequest                          (mac_csr_waitrequest_64[1]),                        
    .phy_1_avalon_anti_slave_0_address                              (phy_csr_address[1]),                            
    .phy_1_avalon_anti_slave_0_write                                (phy_csr_write[1]),                              
    .phy_1_avalon_anti_slave_0_read                                 (phy_csr_read[1]),                               
    .phy_1_avalon_anti_slave_0_readdata                             (phy_csr_readdata[1]),                           
    .phy_1_avalon_anti_slave_0_writedata                            (phy_csr_writedata[1]),                          
    .phy_1_avalon_anti_slave_0_waitrequest                          (phy_csr_waitrequest[1]),
    
    .tx_sc_fifo_0_avalon_anti_slave_0_address                       (tx_sc_fifo_csr_address[0]),    
    .tx_sc_fifo_0_avalon_anti_slave_0_write                         (tx_sc_fifo_csr_write[0]),      
    .tx_sc_fifo_0_avalon_anti_slave_0_read                          (tx_sc_fifo_csr_read[0]),       
    .tx_sc_fifo_0_avalon_anti_slave_0_readdata                      (tx_sc_fifo_csr_readdata[0]),   
    .tx_sc_fifo_0_avalon_anti_slave_0_writedata                     (tx_sc_fifo_csr_writedata[0]),  
    
    .rx_sc_fifo_0_avalon_anti_slave_0_address                       (rx_sc_fifo_csr_address[0]),    
    .rx_sc_fifo_0_avalon_anti_slave_0_write                         (rx_sc_fifo_csr_write[0]),      
    .rx_sc_fifo_0_avalon_anti_slave_0_read                          (rx_sc_fifo_csr_read[0]),       
    .rx_sc_fifo_0_avalon_anti_slave_0_readdata                      (rx_sc_fifo_csr_readdata[0]),   
    .rx_sc_fifo_0_avalon_anti_slave_0_writedata                     (rx_sc_fifo_csr_writedata[0]),  

    .tx_sc_fifo_1_avalon_anti_slave_0_address                       (tx_sc_fifo_csr_address[1]),    
    .tx_sc_fifo_1_avalon_anti_slave_0_write                         (tx_sc_fifo_csr_write[1]),      
    .tx_sc_fifo_1_avalon_anti_slave_0_read                          (tx_sc_fifo_csr_read[1]),       
    .tx_sc_fifo_1_avalon_anti_slave_0_readdata                      (tx_sc_fifo_csr_readdata[1]),   
    .tx_sc_fifo_1_avalon_anti_slave_0_writedata                     (tx_sc_fifo_csr_writedata[1]),  
    
    .rx_sc_fifo_1_avalon_anti_slave_0_address                       (rx_sc_fifo_csr_address[1]),    
    .rx_sc_fifo_1_avalon_anti_slave_0_write                         (rx_sc_fifo_csr_write[1]),      
    .rx_sc_fifo_1_avalon_anti_slave_0_read                          (rx_sc_fifo_csr_read[1]),       
    .rx_sc_fifo_1_avalon_anti_slave_0_readdata                      (rx_sc_fifo_csr_readdata[1]),   
    .rx_sc_fifo_1_avalon_anti_slave_0_writedata                     (rx_sc_fifo_csr_writedata[1]),  
    
    .eth_gen_mon_0_avalon_anti_slave_0_address                      (eth_gen_mon_avalon_anti_slave_0_address[0]),   
    .eth_gen_mon_0_avalon_anti_slave_0_write                        (eth_gen_mon_avalon_anti_slave_0_write[0]),     
    .eth_gen_mon_0_avalon_anti_slave_0_read                         (eth_gen_mon_avalon_anti_slave_0_read[0]),      
    .eth_gen_mon_0_avalon_anti_slave_0_readdata                     (eth_gen_mon_avalon_anti_slave_0_readdata[0]),  
    .eth_gen_mon_0_avalon_anti_slave_0_writedata                    (eth_gen_mon_avalon_anti_slave_0_writedata[0]),
    .eth_gen_mon_0_avalon_anti_slave_0_waitrequest                  (eth_gen_mon_avalon_anti_slave_0_waitrequest[0]),

    .eth_gen_mon_1_avalon_anti_slave_0_address                      (eth_gen_mon_avalon_anti_slave_0_address[1]),   
    .eth_gen_mon_1_avalon_anti_slave_0_write                        (eth_gen_mon_avalon_anti_slave_0_write[1]),     
    .eth_gen_mon_1_avalon_anti_slave_0_read                         (eth_gen_mon_avalon_anti_slave_0_read[1]),      
    .eth_gen_mon_1_avalon_anti_slave_0_readdata                     (eth_gen_mon_avalon_anti_slave_0_readdata[1]),  
    .eth_gen_mon_1_avalon_anti_slave_0_writedata                    (eth_gen_mon_avalon_anti_slave_0_writedata[1]),
    .eth_gen_mon_1_avalon_anti_slave_0_waitrequest                  (eth_gen_mon_avalon_anti_slave_0_waitrequest[1])
        
);    

altera_reset_synchronizer # (
        .ASYNC_RESET(1),
        .DEPTH      (4)  
    ) tx_reset_synchronizer_inst(
        .clk(core_clk_312),
        .reset_in(~tx_rst_n),
        .reset_out(sync_tx_rst)
    );

altera_reset_synchronizer # (
        .ASYNC_RESET(1),
        .DEPTH      (4)  
    ) rx_reset_synchronizer_inst(
        .clk(core_clk_312),
        .reset_in(~rx_rst_n),
        .reset_out(sync_rx_rst)
    );   

    
altera_reset_synchronizer # (
        .ASYNC_RESET(1),
        .DEPTH      (4)  
    ) tx_half_clk_reset_synchronizer_inst(
        .clk(core_clk_156),
        .reset_in(~tx_rst_n),
        .reset_out(sync_tx_half_rst)
    );

altera_reset_synchronizer # (
        .ASYNC_RESET(1),
        .DEPTH      (4)  
    ) rx_half_clk_reset_synchronizer_inst(
        .clk(core_clk_156),
        .reset_in(~rx_rst_n),
        .reset_out(sync_rx_half_rst)
    );     
    
     
endmodule 
