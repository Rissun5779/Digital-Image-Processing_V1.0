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


// (C)Altera Corporation. All rights reserved.
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


// $Revision: #1 
// $Date: 07/05/2013
// $Author: IP APPs
`timescale 1 ps / 1 ps
module altera_eth_channel #(
    parameter   MDIO_MDC_CLOCK_DIVISOR  = 32,           //MDIO
                    FIFO_OPTIONS                = 1     //0-No FIDO, 1-SC FIFO, 2- DC FIFO, 3- SC-DC FIFO
    )(

        // avalon MM
        input  wire [15:0]  csr_address,     
        output wire         csr_waitrequest,
        input  wire         csr_read,        
        output wire [31:0]  csr_readdata,  
        input  wire         csr_write,      
        input  wire [31:0]  csr_writedata,  
        input  wire         tx_serial_clk_10g,      
        input  wire         tx_serial_clk_1g,       
                 
        //clk
        input  wire         cdr_ref_clk_10g,        
        input  wire         cdr_ref_clk_1g,         

        input  wire         pll_ref_clk_1g,  
        input  wire         pll_ref_clk_10g,       
        
        input  wire         xgmii_clk,                                            
        input  wire         xgmii_clk_312_5,
        input  wire         mm_clk,                                                
       input     wire             dc_fifo_tx_clk,
        input  wire          dc_fifo_rx_clk,
        
        //reset 

                                          
        input  wire         mm_reset,                                        
        input  wire         datapath_reset,                                
        input  wire         xgmii_clk_312_5_reset,  


        //pll
        input  wire         pll_locked,   
        
        //MAC
        
        input  wire [63:0]  mac_avalon_st_tx_data,                            
        input  wire         mac_avalon_st_tx_valid,                           
        output wire         mac_avalon_st_tx_ready,                            
        input  wire         mac_avalon_st_tx_startofpacket,                    
        input  wire         mac_avalon_st_tx_endofpacket,                      
        input  wire [2:0]   mac_avalon_st_tx_empty,                          
        input  wire         mac_avalon_st_tx_error,                            
    
        output wire [63:0]  mac_avalon_st_rx_data,                           
        output wire         mac_avalon_st_rx_valid,                          
        input  wire         mac_avalon_st_rx_ready,                           
        output wire         mac_avalon_st_rx_startofpacket,                   
        output wire         mac_avalon_st_rx_endofpacket,                    
        output wire [2:0]   mac_avalon_st_rx_empty,                          
        output wire [5:0]   mac_avalon_st_rx_error,                          
    
        output wire         mac_avalon_st_txstatus_valid,                      
        output wire [39:0]  mac_avalon_st_txstatus_data,                       
        output wire [6:0]   mac_avalon_st_txstatus_error,                           
        output wire         mac_avalon_st_rxstatus_valid,                       
        output wire [39:0]  mac_avalon_st_rxstatus_data,                        
        output wire [6:0]   mac_avalon_st_rxstatus_error,                       
        output wire [1:0]   mac_link_fault_status_xgmii_rx_data,                
        input wire [1:0]      mac_avalon_st_pause_data,
                              
        
        //PHY

        input  wire         phy_usr_seq_reset,                
    
        output wire         phy_tx_serial_data,                             
        input  wire         phy_rx_serial_data,                      
        
        output wire         phy_led_an,                               
        output wire         phy_led_char_err,                               
        output wire         phy_led_disp_err,                         
        output wire         phy_led_link,                                   

        output wire         phy_rx_syncstatus,                        
        output wire         phy_rx_data_ready,                       
           

        output wire         phy_rx_block_lock,                        
        output wire         phy_rx_hi_ber,                              
        output wire         phy_rx_rlv,                               
        input  wire         phy_rxeq_done,                           
        output wire         phy_rx_pcfifo_error_1g,                   
        output wire         phy_tx_pcfifo_error_1g,                   
        input  wire         phy_rx_clkslip,  
		output wire		    phy_rx_recovered_clk,                        

        
        output wire [3:0]   phy_tm_out_trigger,                       
        input  wire [3:0]   phy_tm_in_trigger,                                      


        input    wire         phy_lcl_rf,                              
        output wire         phy_en_lcl_rxeq,                                

        output wire [2:0]   phy_tap_to_upd,                          

        output  wire          xcvr_reset_control_pll_powerdown,
        //MDIO
        output wire         mdio_mdc,                       
        input  wire         mdio_in,                  
        output wire         mdio_out,                   
        output wire         mdio_oen   

  
    
    );
 
    localparam  PHY2MAC_RESET_EN        = 0;  
        //XCVR Reset Controller
               
        wire [0:0]   xcvr_reset_control_pll_select;                 
        wire [0:0]   xcvr_reset_control_tx_analogreset;                 
        wire [0:0]   xcvr_reset_control_rx_analogreset;          
        wire [0:0]   xcvr_reset_control_pll_locked;                 
        wire [0:0]   xcvr_reset_control_rx_cal_busy;                
        wire [0:0]   xcvr_reset_control_rx_is_lockedtodata;         
        wire [0:0]   xcvr_reset_control_tx_digitalreset;        
        wire [0:0]   xcvr_reset_control_rx_ready;                    
        wire [0:0]   xcvr_reset_control_rx_digitalreset;        
        wire [0:0]   xcvr_reset_control_tx_ready;                     
        wire [0:0]   xcvr_reset_control_tx_cal_busy;               

                                                                        
        wire              dc_fifo_tx_clk_reset; 
        wire              dc_fifo_rx_clk_reset;    
        wire          mac_rx_reset;                                                                        
        wire          mac_tx_reset;                                                                        
        wire          reset_controller_reset_out;                                                                               

     

        //mac gmii
        wire    [0:0] mac_gmii_tx_en;                                                                                   
        wire          mac_gmii_tx_err;                                                                                 
        wire    [7:0] mac_gmii_tx_d;                                                                                    
        wire   [71:0] mac_xgmii_tx_data;                                                                                      

        wire    [7:0] phy_gmii_rx_d;                                                                                 
        wire          phy_gmii_rx_err;                                                                               
        wire          phy_gmii_rx_dv;                                                                                
        wire   [71:0] phy_xgmii_rx_dc_data;                                                                                 

        wire          phy_tx_clkout_1g_clk;                                           // phy:tx_clkout_1g -> [mac:gmii_rx_clk_clk, mac:gmii_tx_clk_clk, phy:tx_coreclkin_1g]
//      wire          phy_rx_clkout_1g_clk;   
        wire          phy_tx_recovered_clk;
                                                                                      // PHY_10GBaseKR:rx_clkout_1g -> PHY_10GBaseKR:rx_coreclkin_1g

     
        //mac mii
        wire    [0:0] mac_mii_tx_en;                                                                                   
        wire          mac_mii_tx_err;                                                                                 
        wire    [3:0] mac_mii_tx_d;
        wire              phy_mii_tx_clkena;
        wire             phy_mii_tx_clkena_half_rate; 
        
        wire    [3:0] phy_mii_rx_d;                                                                                 
        wire          phy_mii_rx_err;                                                                               
        wire          phy_mii_rx_dv;
        wire             phy_mii_rx_clkena;
        wire             phy_mii_rx_clkena_half_rate;   
    
        wire    [1:0]      speed_sel;     
    
        // CSR
        
        wire   [31:0] tx_fifo_csr_writedata;                                                       
        wire    [4:0] tx_fifo_csr_address;                                                         
        wire          tx_fifo_csr_waitrequest;                                                          
        wire          tx_fifo_csr_write;                                                           
        wire          tx_fifo_csr_read;                                                            
        wire   [31:0] tx_fifo_csr_readdata;                                                        

        wire   [31:0] rx_fifo_csr_writedata;                                                       
        wire    [4:0] rx_fifo_csr_address;                                                         
        wire          rx_fifo_csr_write;                                                           
        wire          rx_fifo_csr_read;                                                            
        wire   [31:0] rx_fifo_csr_readdata;                                                       
        wire          rx_fifo_csr_waitrequest;                                                          

            
        wire          phy_mgmt_waitrequest;                                                      
        wire   [31:0] phy_mgmt_writedata;                                                       
        wire    [12:0] phy_mgmt_address;                                                          
        wire          phy_mgmt_write;                                                           
        wire          phy_mgmt_read;                                                             
        wire   [31:0] phy_mgmt_readdata;                                                         

        wire          mac_csr_waitrequest;                                                   
        wire   [31:0] mac_csr_writedata;                                                      
        wire   [14:0] mac_csr_address;                                                       
        wire          mac_csr_write;                                                          
        wire          mac_csr_read;                                                          
        wire   [31:0] mac_csr_readdata;                                                       

        wire          eth_loopback_composed_csr_waitrequest;                                         
        wire   [31:0] eth_loopback_composed_csr_writedata;                                            
        wire    [3:0] eth_loopback_composed_csr_address;                                              
        wire          eth_loopback_composed_csr_write;                                               
        wire          eth_loopback_composed_csr_read;                                                 
        wire   [31:0] eth_loopback_composed_csr_readdata;                                             

        wire          eth_mdio_csr_waitrequest;                                                      
        wire   [31:0] eth_mdio_csr_writedata;                                                        
        wire    [7:0] eth_mdio_csr_address;                                                         
        wire          eth_mdio_csr_write;                                                            
        wire          eth_mdio_csr_read;                                                          
        wire   [31:0] eth_mdio_csr_readdata;                                                          
               
        wire            phy_tx_clkout_1g_clk_reset_sync;

//      wire             phy_pll_locked;
        wire [5:0]                      phy_pcs_mode_rc;
        wire                            reset_to_mac_wire;
	
    
    assign xcvr_reset_control_pll_locked = pll_locked;
    
    assign phy_tx_clkout_1g_clk = phy_tx_recovered_clk;

  
//=============Reset Synchronizer==========================================  
    
//--------------------------------------------------------------------------    
    altera_reset_controller #(
        .NUM_RESET_INPUTS        (2),
        .OUTPUT_RESET_SYNC_EDGES ("deassert"),
        .SYNC_DEPTH              (2)
    ) reset_sync_mac_tx (
        
        .reset_in0  (reset_to_mac_wire),
        .reset_in1  (datapath_reset),
        .clk        (xgmii_clk),                    
        .reset_out  (mac_tx_reset),

        .reset_in2      (),
        .reset_in3      (),
        .reset_in4      (),
        .reset_in5      (),
        .reset_in6      (),
        .reset_in7      (),
        .reset_in8      (),
        .reset_in9      (),
        .reset_in10     (),
        .reset_in11     (),
        .reset_in12     (),
        .reset_in13     (),
        .reset_in14     (),
        .reset_in15     (),
        .reset_req      (),
        .reset_req_in0  (),
        .reset_req_in1  (),
        .reset_req_in2  (),
        .reset_req_in3  (),
        .reset_req_in4  (),
        .reset_req_in5  (),
        .reset_req_in6  (),
        .reset_req_in7  (),
        .reset_req_in8  (),
        .reset_req_in9  (),
        .reset_req_in10 (),
        .reset_req_in11 (),
        .reset_req_in12 (),
        .reset_req_in13 (),
        .reset_req_in14 (),
        .reset_req_in15 ()
    );
    
 //--------------------------------------------------------------------------   
    altera_reset_controller #(
        .NUM_RESET_INPUTS        (2),
        .OUTPUT_RESET_SYNC_EDGES ("deassert"),
        .SYNC_DEPTH              (2)
    ) reset_sync_mac_rx (
        
        .reset_in0  (reset_to_mac_wire),
        .reset_in1  (datapath_reset),
        .clk        (xgmii_clk),                    
        .reset_out  (mac_rx_reset),

        .reset_in2      (),
        .reset_in3      (),
        .reset_in4      (),
        .reset_in5      (),
        .reset_in6      (),
        .reset_in7      (),
        .reset_in8      (),
        .reset_in9      (),
        .reset_in10     (),
        .reset_in11     (),
        .reset_in12     (),
        .reset_in13     (),
        .reset_in14     (),
        .reset_in15     (),
        .reset_req      (),
        .reset_req_in0  (),
        .reset_req_in1  (),
        .reset_req_in2  (),
        .reset_req_in3  (),
        .reset_req_in4  (),
        .reset_req_in5  (),
        .reset_req_in6  (),
        .reset_req_in7  (),
        .reset_req_in8  (),
        .reset_req_in9  (),
        .reset_req_in10 (),
        .reset_req_in11 (),
        .reset_req_in12 (),
        .reset_req_in13 (),
        .reset_req_in14 (),
        .reset_req_in15 ()
    );
//--------------------------------------------------------------------------    
    altera_reset_controller #(
        .NUM_RESET_INPUTS        (1),
        .OUTPUT_RESET_SYNC_EDGES ("deassert"),
        .SYNC_DEPTH              (2)
    ) reset_sync_xcvr_reset (
        .reset_in0  (datapath_reset), 
        .clk        (mm_clk),                  
        .reset_out  (reset_controller_reset_out),

        .reset_in1      (),
        .reset_in2      (),
        .reset_in3      (),
        .reset_in4      (),
        .reset_in5      (),
        .reset_in6      (),
        .reset_in7      (),
        .reset_in8      (),
        .reset_in9      (),
        .reset_in10     (),
        .reset_in11     (),
        .reset_in12     (),
        .reset_in13     (),
        .reset_in14     (),
        .reset_in15     (),
        .reset_req      (),
        .reset_req_in0  (),
        .reset_req_in1  (),
        .reset_req_in2  (),
        .reset_req_in3  (),
        .reset_req_in4  (),
        .reset_req_in5  (),
        .reset_req_in6  (),
        .reset_req_in7  (),
        .reset_req_in8  (),
        .reset_req_in9  (),
        .reset_req_in10 (),
        .reset_req_in11 (),
        .reset_req_in12 (),
        .reset_req_in13 (),
        .reset_req_in14 (),
        .reset_req_in15 ()
    );

    altera_reset_controller #(
        .NUM_RESET_INPUTS        (1),
        .OUTPUT_RESET_SYNC_EDGES ("deassert"),
        .SYNC_DEPTH              (2)
    ) reset_sync_fifo_tx_reset (
        .reset_in0  (datapath_reset), 
        .clk        (dc_fifo_tx_clk),                  
        .reset_out  (dc_fifo_tx_clk_reset),

        .reset_in1      (),
        .reset_in2      (),
        .reset_in3      (),
        .reset_in4      (),
        .reset_in5      (),
        .reset_in6      (),
        .reset_in7      (),
        .reset_in8      (),
        .reset_in9      (),
        .reset_in10     (),
        .reset_in11     (),
        .reset_in12     (),
        .reset_in13     (),
        .reset_in14     (),
        .reset_in15     (),
        .reset_req      (),
        .reset_req_in0  (),
        .reset_req_in1  (),
        .reset_req_in2  (),
        .reset_req_in3  (),
        .reset_req_in4  (),
        .reset_req_in5  (),
        .reset_req_in6  (),
        .reset_req_in7  (),
        .reset_req_in8  (),
        .reset_req_in9  (),
        .reset_req_in10 (),
        .reset_req_in11 (),
        .reset_req_in12 (),
        .reset_req_in13 (),
        .reset_req_in14 (),
        .reset_req_in15 ()
    );
    
        altera_reset_controller #(
        .NUM_RESET_INPUTS        (1),
        .OUTPUT_RESET_SYNC_EDGES ("deassert"),
        .SYNC_DEPTH              (2)
    ) reset_sync_fifo_rx_reset (
        .reset_in0  (datapath_reset), 
        .clk        (dc_fifo_rx_clk),                  
        .reset_out  (dc_fifo_rx_clk_reset),

        .reset_in1      (),
        .reset_in2      (),
        .reset_in3      (),
        .reset_in4      (),
        .reset_in5      (),
        .reset_in6      (),
        .reset_in7      (),
        .reset_in8      (),
        .reset_in9      (),
        .reset_in10     (),
        .reset_in11     (),
        .reset_in12     (),
        .reset_in13     (),
        .reset_in14     (),
        .reset_in15     (),
        .reset_req      (),
        .reset_req_in0  (),
        .reset_req_in1  (),
        .reset_req_in2  (),
        .reset_req_in3  (),
        .reset_req_in4  (),
        .reset_req_in5  (),
        .reset_req_in6  (),
        .reset_req_in7  (),
        .reset_req_in8  (),
        .reset_req_in9  (),
        .reset_req_in10 (),
        .reset_req_in11 (),
        .reset_req_in12 (),
        .reset_req_in13 (),
        .reset_req_in14 (),
        .reset_req_in15 ()
    );

    
//=============FIFO==========================================
generate 
 if(FIFO_OPTIONS != 0)
    begin
    
       wire [63:0]  rx_fifo_in_data;                            
        wire         rx_fifo_in_valid;                           
        wire         rx_fifo_in_ready;                            
        wire         rx_fifo_in_startofpacket;                    
        wire         rx_fifo_in_endofpacket;                      
        wire [2:0]   rx_fifo_in_empty;                          
        wire [5:0]   rx_fifo_in_error;                            
    
        wire [63:0]  tx_fifo_out_data;                           
        wire         tx_fifo_out_valid;                          
        wire         tx_fifo_out_ready;                           
        wire         tx_fifo_out_startofpacket;                   
        wire         tx_fifo_out_endofpacket;                    
        wire [2:0]   tx_fifo_out_empty;                          
        wire             tx_fifo_out_error;                  
    
    altera_eth_fifo #(
    .FIFO_OPTIONS       (FIFO_OPTIONS), 
     .TX_RX_FIFO       (0),

     .SYMBOLS_PER_BEAT (8)  ,
    .BITS_PER_SYMBOL (8)    ,
    .CHANNEL_WIDTH   (1)  ,
    .ERROR_WIDTH     (1)   ,
    .USE_PACKETS     (1)   ,
    
     .DC_FIFO_DEPTH      (512)   ,
     .DC_USE_IN_FILL_LEVEL  (0)   ,
     .DC_USE_OUT_FILL_LEVEL  (0)   ,
    .DC_WR_SYNC_DEPTH (2) ,
    .DC_RD_SYNC_DEPTH (2) ,
    .DC_STREAM_ALMOST_FULL   (1)  ,
    .DC_STREAM_ALMOST_EMPTY (1),
     .DC_USE_SPACE_AVAIL_IF  (0),
    
    .SC_FIFO_DEPTH      (512)   ,
     .SC_USE_FILL_LEVEL  (0)   ,
    .SC_USE_STORE_FORWARD (1) ,
    .SC_USE_ALMOST_FULL_IF (0) ,
    .SC_USE_ALMOST_EMPTY_IF (0) ,
    .SC_EMPTY_LATENCY   (3)  ,
    .SC_USE_MEMORY_BLOCKS (1) 
  ) 
    altera_eth_fifo_tx (     
       .in_clk                  (dc_fifo_tx_clk),
      .in_reset_n           (~dc_fifo_tx_clk_reset),

      .xgmii_clk                (xgmii_clk),
      .xgmii_clk_reset_n    (~datapath_reset),

       .in_data           (mac_avalon_st_tx_data),                                    
        .in_valid          (mac_avalon_st_tx_valid),                                    
        .in_ready          (mac_avalon_st_tx_ready),                                   
        .in_startofpacket  (mac_avalon_st_tx_startofpacket),                            
        .in_endofpacket    (mac_avalon_st_tx_endofpacket),                              
        .in_empty          (mac_avalon_st_tx_empty),                                    
        .in_error          (mac_avalon_st_tx_error),                                    
        
        .out_data          (tx_fifo_out_data),                                    
        .out_valid         (tx_fifo_out_valid),                                    
        .out_ready         (tx_fifo_out_ready),                                    
        .out_startofpacket (tx_fifo_out_startofpacket),                            
        .out_endofpacket   (tx_fifo_out_endofpacket),                              
        .out_empty         (tx_fifo_out_empty),                                   
        .out_error         (tx_fifo_out_error),                                   

         // in csr
         .in_csr_address(),
         .in_csr_write(),
         .in_csr_read(),
         .in_csr_readdata(),
         .in_csr_writedata(),
         
         // out csr
         .out_csr_address(tx_fifo_csr_address[4:2]),
         .out_csr_write(tx_fifo_csr_write),
         .out_csr_read(tx_fifo_csr_read),
         .out_csr_readdata(tx_fifo_csr_readdata),
         .out_csr_writedata(tx_fifo_csr_writedata),

         .in_channel        (1'b0),                                            
         .out_channel       () ,                                                     
         
         // streaming in status
         .almost_full_valid(),
         .almost_full_data(),

         // streaming out status
         .almost_empty_valid(),
         .almost_empty_data(),

         // (internal, experimental interface) space available st source
         .space_avail_data()
         
     
     );
    
    altera_eth_fifo #(
    .FIFO_OPTIONS       (FIFO_OPTIONS), 
     .TX_RX_FIFO       (1),
     .SYMBOLS_PER_BEAT (8)  ,
    .BITS_PER_SYMBOL (8)    ,
    .CHANNEL_WIDTH   (1)  ,
    .ERROR_WIDTH     (6)   ,
    .USE_PACKETS     (1)   ,
    
     .DC_FIFO_DEPTH      (512)   ,
     .DC_USE_IN_FILL_LEVEL  (0)   ,
     .DC_USE_OUT_FILL_LEVEL  (0)   ,
    .DC_WR_SYNC_DEPTH (2) ,
    .DC_RD_SYNC_DEPTH (2) ,
    .DC_STREAM_ALMOST_FULL   (0)  ,
    .DC_STREAM_ALMOST_EMPTY (0),
     .DC_USE_SPACE_AVAIL_IF  (0),
    
    .SC_FIFO_DEPTH      (512)   ,
     .SC_USE_FILL_LEVEL  (1)   ,
    .SC_USE_STORE_FORWARD (1) ,
    .SC_USE_ALMOST_FULL_IF (1) ,
    .SC_USE_ALMOST_EMPTY_IF (1) ,
    .SC_EMPTY_LATENCY   (3)  ,
    .SC_USE_MEMORY_BLOCKS (1) 
  ) 
    altera_eth_fifo_rx (     
       .in_clk                  (dc_fifo_rx_clk),
      .in_reset_n             (~dc_fifo_rx_clk_reset),

      .xgmii_clk                (xgmii_clk),
      .xgmii_clk_reset_n    (~datapath_reset),

        .out_data           (mac_avalon_st_rx_data),                         
        .out_valid          (mac_avalon_st_rx_valid),                        
        .out_ready          (mac_avalon_st_rx_ready),                          
        .out_startofpacket  (mac_avalon_st_rx_startofpacket),                 
        .out_endofpacket    (mac_avalon_st_rx_endofpacket),                    
        .out_empty          (mac_avalon_st_rx_empty),                          
        .out_error          (mac_avalon_st_rx_error), 
        
        .in_data            (rx_fifo_in_data),                                     
        .in_valid           (rx_fifo_in_valid),                                    
        .in_ready           (rx_fifo_in_ready),                                    
        .in_startofpacket   (rx_fifo_in_startofpacket),                            
        .in_endofpacket     (rx_fifo_in_endofpacket),                              
        .in_empty           (rx_fifo_in_empty),                                   
        .in_error           (rx_fifo_in_error),                                               

         // in csr
         .in_csr_address(),
         .in_csr_write(),
         .in_csr_read(),
         .in_csr_readdata(),
         .in_csr_writedata(),
         
         // out csr
         .out_csr_address(rx_fifo_csr_address[4:2]),
         .out_csr_write(rx_fifo_csr_write),
         .out_csr_read(rx_fifo_csr_read),
         .out_csr_readdata(rx_fifo_csr_readdata),
         .out_csr_writedata(rx_fifo_csr_writedata),

         .in_channel        (1'b0),                                            
         .out_channel       () ,                                                     
         
         // streaming in status
         .almost_full_valid(),
         .almost_full_data(),

         // streaming out status
         .almost_empty_valid(),
         .almost_empty_data(),

         // (internal, experimental interface) space available st source
         .space_avail_data()
         
     
     );


//=============MAC==========================================
    altera_eth_10g_mac  mac (
        .csr_clk                                (mm_clk),                                                                                                   
        .csr_rst_n                              (~mm_reset),                                                                                               
        .csr_address                     (mac_csr_address[14:2]),    
        .csr_waitrequest                 (mac_csr_waitrequest), 
        .csr_read                        (mac_csr_read),        
        .csr_readdata                    (mac_csr_readdata),   
        .csr_write                       (mac_csr_write),       
        .csr_writedata                   (mac_csr_writedata),   

        .tx_156_25_clk                          (xgmii_clk),    
        .tx_312_5_clk                           (xgmii_clk_312_5),
        .tx_rst_n                               (~mac_tx_reset),                                                                                                          
        .rx_156_25_clk                          (xgmii_clk),                                                                                 
        .rx_312_5_clk                           (xgmii_clk_312_5),
        .rx_rst_n                               (~mac_rx_reset),                                                                                                
                                            

        //output
        .avalon_st_tx_startofpacket      (tx_fifo_out_startofpacket),                               
        .avalon_st_tx_valid              (tx_fifo_out_valid),                                       
        .avalon_st_tx_data               (tx_fifo_out_data),                                       
        .avalon_st_tx_empty              (tx_fifo_out_empty),                                      
        .avalon_st_tx_ready              (tx_fifo_out_ready),                                       
        .avalon_st_tx_error              (tx_fifo_out_error),                                      
        .avalon_st_tx_endofpacket        (tx_fifo_out_endofpacket),                                 
                      

        .xgmii_rx                        (phy_xgmii_rx_dc_data),                                                                             
        .xgmii_tx                    (mac_xgmii_tx_data),                                                                            
        
        .avalon_st_txstatus_valid        (mac_avalon_st_txstatus_valid),                                 
        .avalon_st_txstatus_data         (mac_avalon_st_txstatus_data),                                  
        .avalon_st_txstatus_error        (mac_avalon_st_txstatus_error),                                  
    
        .avalon_st_rx_startofpacket      (rx_fifo_in_startofpacket),                    
        .avalon_st_rx_endofpacket        (rx_fifo_in_endofpacket),                      
        .avalon_st_rx_valid              (rx_fifo_in_valid),                           
        .avalon_st_rx_ready              (rx_fifo_in_ready),                          
        .avalon_st_rx_data               (rx_fifo_in_data),                              
        .avalon_st_rx_empty              (rx_fifo_in_empty),                            
        .avalon_st_rx_error              (rx_fifo_in_error),                            

        .avalon_st_rxstatus_valid        (mac_avalon_st_rxstatus_valid),                                  
        .avalon_st_rxstatus_data         (mac_avalon_st_rxstatus_data),                                   
        .avalon_st_rxstatus_error        (mac_avalon_st_rxstatus_error),                                  
        
        .avalon_st_pause_data               (mac_avalon_st_pause_data),  
        .link_fault_status_xgmii_rx_data (mac_link_fault_status_xgmii_rx_data),                             

        .speed_sel                              (speed_sel),
        
        .gmii_tx_clk                            (phy_tx_clkout_1g_clk),
        .gmii_tx_d                              (mac_gmii_tx_d),                                      
        .gmii_tx_en                             (mac_gmii_tx_en),                                     
        .gmii_tx_err                            (mac_gmii_tx_err),                                     
        
        .gmii_rx_clk                            (phy_tx_clkout_1g_clk),
        .gmii_rx_err                            (phy_gmii_rx_err),                                 
        .gmii_rx_d                              (phy_gmii_rx_d),                                    
        .gmii_rx_dv                             (phy_gmii_rx_dv),
        
       .mii_tx_d                        (mac_mii_tx_d),
        .mii_tx_err                             (mac_mii_tx_err),
       .mii_tx_en                               (mac_mii_tx_en),
        .tx_clkena                              (phy_mii_tx_clkena),                    
        .tx_clkena_half_rate                    (phy_mii_tx_clkena_half_rate),          
            
        .mii_rx_d                        (phy_mii_rx_d),
        .mii_rx_err                             (phy_mii_rx_err),
       .mii_rx_dv                               (phy_mii_rx_dv),
        .rx_clkena                              (phy_mii_rx_clkena),                    
        .rx_clkena_half_rate                    (phy_mii_rx_clkena_half_rate)           
       
    

    );  
    
 end
 
 else
  begin
  //=============MAC==========================================
    altera_eth_10g_mac  mac (
        .csr_clk                         (mm_clk),                                                 
        .csr_rst_n                       (~mm_reset),                                        
        .csr_address                     (mac_csr_address[14:2]),    
        .csr_waitrequest                 (mac_csr_waitrequest), 
        .csr_read                        (mac_csr_read),        
        .csr_readdata                    (mac_csr_readdata),   
        .csr_write                       (mac_csr_write),       
        .csr_writedata                   (mac_csr_writedata),   

        .tx_156_25_clk                   (xgmii_clk),    
        .tx_312_5_clk            (xgmii_clk_312_5),
        .tx_rst_n                    (~mac_tx_reset),                                                                                                          
        .rx_156_25_clk                   (xgmii_clk),                                                                                 
        .rx_312_5_clk            (xgmii_clk_312_5),
        .rx_rst_n                    (~mac_rx_reset),                                                                                                
                                             

        //output
        .avalon_st_tx_startofpacket      (mac_avalon_st_tx_startofpacket),                               
        .avalon_st_tx_valid              (mac_avalon_st_tx_valid),                                       
        .avalon_st_tx_data               (mac_avalon_st_tx_data),                                       
        .avalon_st_tx_empty              (mac_avalon_st_tx_empty),                                      
        .avalon_st_tx_ready              (mac_avalon_st_tx_ready),                                       
        .avalon_st_tx_error              (mac_avalon_st_tx_error),                                      
        .avalon_st_tx_endofpacket        (mac_avalon_st_tx_endofpacket),                                 
                      

        .xgmii_rx                        (phy_xgmii_rx_dc_data),                                                                             
        .xgmii_tx                    (mac_xgmii_tx_data),                                                                            
        
        
        .avalon_st_txstatus_valid        (mac_avalon_st_txstatus_valid),                                 
        .avalon_st_txstatus_data         (mac_avalon_st_txstatus_data),                                  
        .avalon_st_txstatus_error        (mac_avalon_st_txstatus_error),                                  
    
        .avalon_st_rx_startofpacket      (mac_avalon_st_rx_startofpacket),                    
        .avalon_st_rx_endofpacket        (mac_avalon_st_rx_endofpacket),                      
        .avalon_st_rx_valid              (mac_avalon_st_rx_valid),                           
        .avalon_st_rx_ready              (mac_avalon_st_rx_ready),                          
        .avalon_st_rx_data               (mac_avalon_st_rx_data),                              
        .avalon_st_rx_empty              (mac_avalon_st_rx_empty),                            
        .avalon_st_rx_error              (mac_avalon_st_rx_error),                            

        .avalon_st_rxstatus_valid        (mac_avalon_st_rxstatus_valid),                                  
        .avalon_st_rxstatus_data         (mac_avalon_st_rxstatus_data),                                   
        .avalon_st_rxstatus_error        (mac_avalon_st_rxstatus_error),                                  
        
        .avalon_st_pause_data               (mac_avalon_st_pause_data),  
        .link_fault_status_xgmii_rx_data (mac_link_fault_status_xgmii_rx_data),                             

        .speed_sel                              (speed_sel),
        
        .gmii_tx_clk                        (phy_tx_clkout_1g_clk),
        .gmii_tx_d                              (mac_gmii_tx_d),                                      
        .gmii_tx_en                             (mac_gmii_tx_en),                                     
        .gmii_tx_err                            (mac_gmii_tx_err),                                     
        
        .gmii_rx_clk                        (phy_tx_clkout_1g_clk),
        .gmii_rx_err                            (phy_gmii_rx_err),                                 
        .gmii_rx_d                              (phy_gmii_rx_d),                                    
        .gmii_rx_dv                             (phy_gmii_rx_dv),
        
        .mii_tx_d                        (mac_mii_tx_d),
        .mii_tx_err                             (mac_mii_tx_err),
       .mii_tx_en                               (mac_mii_tx_en),
        .tx_clkena                              (phy_mii_tx_clkena),                    
        .tx_clkena_half_rate                    (phy_mii_tx_clkena_half_rate),          
            
        .mii_rx_d                        (phy_mii_rx_d),
        .mii_rx_err                             (phy_mii_rx_err),
       .mii_rx_dv                               (phy_mii_rx_dv),
        .rx_clkena                              (phy_mii_rx_clkena),                    
        .rx_clkena_half_rate                    (phy_mii_rx_clkena_half_rate)           
       
    

    );  
  
  
  end
endgenerate



//=============NF PHY==========================================
    altera_eth_10gkr_phy phy (
        .tx_serial_clk_10g        (tx_serial_clk_10g),
        .tx_serial_clk_1g         (tx_serial_clk_1g), 
        .rx_cdr_ref_clk_10g       (cdr_ref_clk_10g),  
        .rx_cdr_ref_clk_1g        (cdr_ref_clk_1g),   
        .xgmii_tx_clk             (xgmii_clk),                                                                        
        .xgmii_rx_clk             (xgmii_clk),                                                                        
        .tx_clkout            	  (phy_tx_recovered_clk),                                                             
        .rx_pma_clkout            (phy_rx_recovered_clk),      
        .tx_analogreset           (xcvr_reset_control_tx_analogreset[0]),                                             
        .tx_digitalreset          (xcvr_reset_control_tx_digitalreset[0]),                                            
        .rx_analogreset           (xcvr_reset_control_rx_analogreset[0]),                                             
        .rx_digitalreset          (xcvr_reset_control_rx_digitalreset[0]),                                            
        .usr_seq_reset            (phy_usr_seq_reset),                                                                                                                          
        .mgmt_clk                 (mm_clk),                                                                           
        .mgmt_clk_reset           (mm_reset),                                                                         
        .mgmt_address             (phy_mgmt_address[12:2]),    
        .mgmt_read                (phy_mgmt_read),                                                                    
        .mgmt_readdata            (phy_mgmt_readdata),                                                                
        .mgmt_waitrequest         (phy_mgmt_waitrequest),                                                             
        .mgmt_write               (phy_mgmt_write),                                                                   
        .mgmt_writedata           (phy_mgmt_writedata),                                                               
        .gmii_tx_d                (mac_gmii_tx_d),                                                                    
        .gmii_rx_d                (phy_gmii_rx_d),                                                                    
        .gmii_tx_en               (mac_gmii_tx_en),                                                                   
        .gmii_tx_err              (mac_gmii_tx_err),                                                                  
        .gmii_rx_err              (phy_gmii_rx_err),                                                                  
        .gmii_rx_dv               (phy_gmii_rx_dv),                                                                   
        .mii_tx_clkena            (phy_mii_tx_clkena),                                                                
        .mii_tx_clkena_half_rate  (phy_mii_tx_clkena_half_rate),                                                      
        .mii_tx_d                 (mac_mii_tx_d),                                                                     
        .mii_tx_en                (mac_mii_tx_en),                                                                    
        .mii_tx_err               (mac_mii_tx_err),                                                                   
        .mii_rx_clkena            (phy_mii_rx_clkena),                                                                
        .mii_rx_clkena_half_rate  (phy_mii_rx_clkena_half_rate),                                                      
        .mii_rx_d                 (phy_mii_rx_d),                                                                     
        .mii_rx_dv                (phy_mii_rx_dv),                                                                    
        .mii_rx_err               (phy_mii_rx_err),                                                                   
        .mii_speed_sel            (speed_sel),                                                                        
        .led_an                   (phy_led_an),                                                                       
        .led_char_err             (phy_led_char_err),                                                                 
        .led_disp_err             (phy_led_disp_err),                                                                 
        .led_link                 (phy_led_link),                                                                     
        .tx_pcfifo_error_1g       (phy_tx_pcfifo_error_1g),                                                           
        .rx_pcfifo_error_1g       (phy_rx_pcfifo_error_1g),                                                           
        .rx_syncstatus            (phy_rx_syncstatus),                                                                
        .rx_clkslip               (phy_rx_clkslip),                                                                   
        .xgmii_tx_dc              (mac_xgmii_tx_data),                                                                
        .xgmii_rx_dc              (phy_xgmii_rx_dc_data),                                                                
        .rx_is_lockedtodata       (xcvr_reset_control_rx_is_lockedtodata[0]),                                         
        .tx_cal_busy              (xcvr_reset_control_tx_cal_busy[0]),                                                
        .rx_cal_busy              (xcvr_reset_control_rx_cal_busy[0]),                                                
        .rx_data_ready            (phy_rx_data_ready),                                                                
        .rx_block_lock            (phy_rx_block_lock),                                                                
        .rx_hi_ber                (phy_rx_hi_ber),                                                                    
        .tx_serial_data           (phy_tx_serial_data),                                                               
        .rx_serial_data           (phy_rx_serial_data),
//      .lcl_rf                   (phy_lcl_rf),                                                                       
//      .en_lcl_rxeq              (phy_en_lcl_rxeq),                                                                  
//      .rxeq_done                (phy_rxeq_done),

        .rx_clkout                (),
        .tx_pma_clkout            (),
        .led_panel_link           (),
        .pcs_mode_rc              (phy_pcs_mode_rc)	
    );      

                                                               
    

//=============PHY Reset Controller==========================================
    altera_xcvr_reset_controller xcvr_reset_controller (
        .clock              (mm_clk),                                              
        .reset              (reset_controller_reset_out),                        
        .pll_powerdown      (xcvr_reset_control_pll_powerdown),          
        .tx_analogreset     (xcvr_reset_control_tx_analogreset),        
        .tx_digitalreset    (xcvr_reset_control_tx_digitalreset),      
        .tx_ready           (xcvr_reset_control_tx_ready),                    
        .pll_locked         (xcvr_reset_control_pll_locked),                
        .pll_select         (1'b0),               
        .tx_cal_busy        (xcvr_reset_control_tx_cal_busy),              
        .rx_analogreset     (xcvr_reset_control_rx_analogreset),         
        .rx_digitalreset    (xcvr_reset_control_rx_digitalreset),      
        .rx_ready           (xcvr_reset_control_rx_ready),                   
        .rx_is_lockedtodata (xcvr_reset_control_rx_is_lockedtodata), 
        .rx_cal_busy        (xcvr_reset_control_rx_cal_busy)               
                                 
    );
    

//==============MDIO=========================================================================

    altera_eth_mdio #(
        .MDC_DIVISOR        (MDIO_MDC_CLOCK_DIVISOR)
    ) eth_mdio (
        .clk             (mm_clk),                                          
        .reset           (mm_reset),                   
        .csr_write       (eth_mdio_csr_write),     
        .csr_read        (eth_mdio_csr_read),       
        .csr_address     (eth_mdio_csr_address[7:2]),    
        .csr_writedata   (eth_mdio_csr_writedata),   
        .csr_readdata    (eth_mdio_csr_readdata),   
        .csr_waitrequest (eth_mdio_csr_waitrequest), 
        .mdc             (mdio_mdc),                                                
        .mdio_in         (mdio_in),                                           
        .mdio_out        (mdio_out),                                           
        .mdio_oen        (mdio_oen)                                            
    );

        
//==============Address Decoder=========================================================================
    
        address_decoder_channel address_decoder_channel_inst(

        .clk_clk                                            (mm_clk),                             
        .reset_reset_n                                      (~mm_reset),                     

    
        .master_avalon_anti_master_0_waitrequest            (csr_waitrequest),    
        .master_avalon_anti_master_0_readdata               (csr_readdata),      
        .master_avalon_anti_master_0_writedata              (csr_writedata),     
        .master_avalon_anti_master_0_address                (csr_address),       
        .master_avalon_anti_master_0_write                  (csr_write),          
        .master_avalon_anti_master_0_read                   (csr_read),           
    

        .mac_avalon_anti_slave_0_waitrequest                (mac_csr_waitrequest),      
        .mac_avalon_anti_slave_0_readdata                   (mac_csr_readdata),
        .mac_avalon_anti_slave_0_writedata                  (mac_csr_writedata),
        .mac_avalon_anti_slave_0_address                    (mac_csr_address),
        .mac_avalon_anti_slave_0_write                      (mac_csr_write),
        .mac_avalon_anti_slave_0_read                       (mac_csr_read),

        
        .phy_avalon_anti_slave_0_waitrequest                (phy_mgmt_waitrequest),       
        .phy_avalon_anti_slave_0_readdata                   (phy_mgmt_readdata),          
        .phy_avalon_anti_slave_0_writedata                  (phy_mgmt_writedata),        
        .phy_avalon_anti_slave_0_address                    (phy_mgmt_address),          
        .phy_avalon_anti_slave_0_write                      (phy_mgmt_write),            
        .phy_avalon_anti_slave_0_read                       (phy_mgmt_read),

        .eth_fifo_rx_avalon_anti_slave_0_waitrequest        (1'b0),       
        .eth_fifo_rx_avalon_anti_slave_0_readdata           (rx_fifo_csr_readdata),          
        .eth_fifo_rx_avalon_anti_slave_0_writedata          (rx_fifo_csr_writedata),        
        .eth_fifo_rx_avalon_anti_slave_0_address            (rx_fifo_csr_address),          
        .eth_fifo_rx_avalon_anti_slave_0_write              (rx_fifo_csr_write),            
        .eth_fifo_rx_avalon_anti_slave_0_read               (rx_fifo_csr_read),

        .eth_fifo_tx_avalon_anti_slave_0_waitrequest        (1'b0),       
        .eth_fifo_tx_avalon_anti_slave_0_readdata           (tx_fifo_csr_readdata),          
        .eth_fifo_tx_avalon_anti_slave_0_writedata          (tx_fifo_csr_writedata),        
        .eth_fifo_tx_avalon_anti_slave_0_address            (tx_fifo_csr_address),          
        .eth_fifo_tx_avalon_anti_slave_0_write              (tx_fifo_csr_write),            
        .eth_fifo_tx_avalon_anti_slave_0_read               (tx_fifo_csr_read),

        .eth_1588_tod_10g_avalon_anti_slave_0_waitrequest   (),
        .eth_1588_tod_10g_avalon_anti_slave_0_readdata      (),
        .eth_1588_tod_10g_avalon_anti_slave_0_writedata     (),
        .eth_1588_tod_10g_avalon_anti_slave_0_address       (),
        .eth_1588_tod_10g_avalon_anti_slave_0_write         (),
        .eth_1588_tod_10g_avalon_anti_slave_0_read          (),

        .eth_1588_tod_1g_avalon_anti_slave_0_waitrequest    (),
        .eth_1588_tod_1g_avalon_anti_slave_0_readdata       (),
        .eth_1588_tod_1g_avalon_anti_slave_0_writedata      (),
        .eth_1588_tod_1g_avalon_anti_slave_0_address        (),
        .eth_1588_tod_1g_avalon_anti_slave_0_write          (),
        .eth_1588_tod_1g_avalon_anti_slave_0_read           (),

        .mdio_avalon_anti_slave_0_waitrequest               (),
        .mdio_avalon_anti_slave_0_readdata                  (),
        .mdio_avalon_anti_slave_0_writedata                 (),
        .mdio_avalon_anti_slave_0_address                   (),
        .mdio_avalon_anti_slave_0_write                     (),
        .mdio_avalon_anti_slave_0_read                      ()
    );

    reset_csr  #(
        .PHY2MAC_RESET_EN        (PHY2MAC_RESET_EN)
    ) reser_csr_inst (
        // input
        .clk                (mm_clk),
        .reset              (mm_reset),
        .pcs_mode_rc        (phy_pcs_mode_rc),
        .rx_block_lock      (phy_rx_block_lock),
        .led_link           (phy_led_link),
        // output
        .reset_to_mac       (reset_to_mac_wire)
    );    
    

endmodule
