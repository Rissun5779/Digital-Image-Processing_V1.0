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




`timescale 1 ps / 1 ps
module altera_eth_channel_1588 #(
    parameter       TSTAMP_FP_WIDTH = 4,                    //Fingerprint Width
                    DEFAULT_NSEC_PERIOD_10G = 4'h6,         //Time of Day each step is 6.4ns for 10G
                    DEFAULT_FNSEC_PERIOD_10G = 16'h6666,
                    DEFAULT_NSEC_PERIOD_1G = 4'h8,          //Time of Day each step is 8.0ns for 1G
                    DEFAULT_FNSEC_PERIOD_1G = 16'h0000, 
                    TOD_SYNC_MODE_10G = 5,                  //mode 0 --> 1G(125mhz) to 10G(156.25mhz) Sync, mode 1 --> 10G(156.25mhz) to 1G(125mhz) Sync, mode 2 --> same freq sync (tested at 125mhz to 312.5mhz), mode 5 --> 1G(125Mhz) to 10G(312.5mhz) Sync
                    TOD_SYNC_MODE_1G = 2,                   //mode 0 --> 1G(125mhz) to 10G(156.25mhz) Sync, mode 1 --> 10G(156.25mhz) to 1G(125mhz) Sync, mode 2 --> same freq sync (tested at 125mhz to 312.5mhz), mode 5 --> 1G(125Mhz) to 10G(312.5mhz) Sync
                    PPS_PULSE_ASSERT_CYCLE_10G = 1562500,   //Pulse Per Second for 10G - Assert for 10ms (10ms / 6.4ns = 1562500)
                    PPS_PULSE_ASSERT_CYCLE_1G = 1250000,    //Pulse Per Second for 1G - Assert for 10ms (10ms / 8.0ns = 1250000)    
                    MDIO_MDC_CLOCK_DIVISOR  = 32            //MDIO
    )(

        // avalon MM
        input  wire [15:0]                      csr_address,     
        output wire                             csr_waitrequest,
        input  wire                             csr_read,        
        output wire [31:0]                      csr_readdata,  
        input  wire                             csr_write,      
        input  wire [31:0]                      csr_writedata,  
                 
        //clk
        input  wire                             tx_serial_clk_10g,
        input  wire                             tx_serial_clk_1g,
        input  wire                             cdr_ref_clk_10g,        
        input  wire                             cdr_ref_clk_1g,         

        input  wire                             ref_clk_1g,  
        input  wire                             ref_clk_10g,                                       
        input  wire                             xgmii_clk,         
        input  wire                             xgmii_clk_312_5,
        input  wire                             mm_clk,                                                
        input  wire                             calc_clk_1g,     // for gigE PCS latency
        
        //reset 

                                               
        input  wire                             mm_reset,                                        
        input  wire                             datapath_reset,                                  
        input  wire                             xgmii_clk_reset,                                  
        input  wire                             xgmii_clk_312_5_reset,  


        //pll
        input  wire                             pll_locked,   
        
        //MAC
        
        input  wire [63:0]                      mac_avalon_st_tx_data,                            
        input  wire                             mac_avalon_st_tx_valid,                           
        output wire                             mac_avalon_st_tx_ready,                            
        input  wire                             mac_avalon_st_tx_startofpacket,                    
        input  wire                             mac_avalon_st_tx_endofpacket,                      
        input  wire [2:0]                       mac_avalon_st_tx_empty,                          
        input  wire                             mac_avalon_st_tx_error,                            
    
        output wire [63:0]                      mac_avalon_st_rx_data,                           
        output wire                             mac_avalon_st_rx_valid,                          
        input  wire                             mac_avalon_st_rx_ready,                           
        output wire                             mac_avalon_st_rx_startofpacket,                   
        output wire                             mac_avalon_st_rx_endofpacket,                    
        output wire [2:0]                       mac_avalon_st_rx_empty,                          
        output wire [5:0]                       mac_avalon_st_rx_error,                          
    
        output wire                             mac_avalon_st_tx_status_valid,                      
        output wire [39:0]                      mac_avalon_st_tx_status_data,                       
        output wire [6:0]                       mac_avalon_st_tx_status_error,                          
        output wire                             mac_avalon_st_rx_status_valid,                       
        output wire [39:0]                      mac_avalon_st_rx_status_data,                        
        output wire [6:0]                       mac_avalon_st_rx_status_error,                       
        output wire [1:0]                       mac_link_fault_status_xgmii_rx_data,            
        input  wire [1:0]                       mac_avalon_st_pause_data,
                                      
        
        //PHY

        input  wire                             phy_usr_seq_reset,                

        output wire                             phy_tx_serial_data,                             
        input  wire                             phy_rx_serial_data,                      
        
        output wire                             phy_led_an,                               
        output wire                             phy_led_char_err,                               
        output wire                             phy_led_disp_err,                         
        output wire                             phy_led_link,                                   

        output wire                             phy_rx_syncstatus,                        
        output wire                             phy_rx_data_ready,                       
           

        output wire                             phy_rx_block_lock,                        
        output wire                             phy_rx_hi_ber,                              
        output wire                             phy_rx_rlv,                               
        input  wire                             phy_rxeq_done,                           
        output wire                             phy_rx_pcfifo_error_1g,                   
        output wire                             phy_tx_pcfifo_error_1g,                   
        input  wire                             phy_rx_clkslip,                                                             

        input  wire                             phy_lcl_rf,                              
        output wire                             phy_en_lcl_rxeq,                                

        output wire                             phy_rx_recovered_clk,

        //Reset Controller 
        
        output wire                             xcvr_reset_control_pll_powerdown,   
        //MDIO
        output wire                             mdio_mdc,                       
        input  wire                             mdio_in,                  
        output wire                             mdio_out,                   
        output wire                             mdio_oen,   
  
        //1588
        input  wire                             tx_egress_timestamp_request_in_valid,
        input  wire [TSTAMP_FP_WIDTH-1:0]       tx_egress_timestamp_request_in_fingerprint,
    
        input  wire                             tx_etstamp_ins_ctrl_in_residence_time_update,
        input  wire [95:0]                      tx_etstamp_ins_ctrl_in_ingress_timestamp_96b,
        input  wire [63:0]                      tx_etstamp_ins_ctrl_in_ingress_timestamp_64b,
        input  wire                             tx_etstamp_ins_ctrl_in_residence_time_calc_format,
    
        input  wire [1:0]                       clock_operation_mode_mode,
        input  wire                             pkt_with_crc_mode,

        output wire                             tx_egress_timestamp_96b_valid,
        output wire [95:0]                      tx_egress_timestamp_96b_data,          
        output wire [TSTAMP_FP_WIDTH - 1:0]     tx_egress_timestamp_96b_fingerprint,
        output wire                             tx_egress_timestamp_64b_valid,
        output wire [63:0]                      tx_egress_timestamp_64b_data,
        output wire [TSTAMP_FP_WIDTH - 1:0]     tx_egress_timestamp_64b_fingerprint,

        output wire                             rx_ingress_timestamp_96b_valid,
        output wire [95:0]                      rx_ingress_timestamp_96b_data,
        output wire                             rx_ingress_timestamp_64b_valid,
        output wire [63:0]                      rx_ingress_timestamp_64b_data,

        input  wire                             master_tod_clk,
        input  wire                             master_tod_reset,
        input  wire [95:0]                      master_tod_96b_data,
        input  wire [63:0]                      master_tod_64b_data,
        input  wire                             start_tod_sync,

        input  wire                             tod_sync_10g_sampling_clk,
        input  wire                             tod_sync_1g_sampling_clk,       

        output wire                             pulse_per_second_10g,
        output wire                             pulse_per_second_1g,
        output wire [1:0]                       speed_sel
    );
 
  
    localparam  PHY2MAC_RESET_EN        = 0;  

        //XCVR Reset Controller
            
        wire [0:0]                      xcvr_reset_control_pll_select;                 
        wire [0:0]                      xcvr_reset_control_tx_analogreset;              
        wire [0:0]                      xcvr_reset_control_rx_analogreset;          
        wire [0:0]                      xcvr_reset_control_pll_locked;                 
        wire [0:0]                      xcvr_reset_control_rx_cal_busy;                 
        wire [0:0]                      xcvr_reset_control_rx_is_lockedtodata;          
        wire [0:0]                      xcvr_reset_control_tx_digitalreset;        
        wire [0:0]                      xcvr_reset_control_rx_ready;                    
        wire [0:0]                      xcvr_reset_control_rx_digitalreset;        
        wire [0:0]                      xcvr_reset_control_tx_ready;                     
        wire [0:0]                      xcvr_reset_control_tx_cal_busy;               

        wire                            mac_rx_reset;                                                                        
        wire                            mac_tx_reset;                                                                        
      
        //mac xgmii
        wire [71:0]                     mac_xgmii_tx_data;                                                                                      
        wire [71:0]                     phy_xgmii_rx_data;                                                                                 

        
        //mac gmii
        wire [0:0]                      mac_gmii_tx_en;                                                                                   
        wire                            mac_gmii_tx_err;                                                                                 
        wire [7:0]                      mac_gmii_tx_d;                                                                                    

        wire [7:0]                      phy_gmii_rx_d;                                                                                 
        wire                            phy_gmii_rx_err;                                                                               
        wire                            phy_gmii_rx_dv;          
        
        wire                            phy_tx_recovered_clk;

        // CSR
        wire                            phy_mgmt_waitrequest;                                                      
        wire [31:0]                     phy_mgmt_writedata;                                                       
        wire [12:0]                     phy_mgmt_address;                                                          
        wire                            phy_mgmt_write;                                                           
        wire                            phy_mgmt_read;                                                             
        wire [31:0]                     phy_mgmt_readdata;                                                         

        wire                            mac_csr_waitrequest;                                                   
        wire [31:0]                     mac_csr_writedata;                                                      
        wire [14:0]                     mac_csr_address;                                                       
        wire                            mac_csr_write;                                                          
        wire                            mac_csr_read;                                                          
        wire [31:0]                     mac_csr_readdata;                                                       

        wire                            eth_mdio_csr_waitrequest;                                                      
        wire [31:0]                     eth_mdio_csr_writedata;                                                        
        wire [7:0]                      eth_mdio_csr_address;                                                         
        wire                            eth_mdio_csr_write;                                                            
        wire                            eth_mdio_csr_read;                                                          
        wire [31:0]                     eth_mdio_csr_readdata;                                                          

        wire                            eth_1588_tod_10g_csr_waitrequest;                                                      
        wire [31:0]                     eth_1588_tod_10g_csr_writedata;                                                        
        wire [5:0]                      eth_1588_tod_10g_csr_address;                                                         
        wire                            eth_1588_tod_10g_csr_write;                                                            
        wire                            eth_1588_tod_10g_csr_read;                                                          
        wire [31:0]                     eth_1588_tod_10g_csr_readdata;                                                          
    
        wire                            eth_1588_tod_1g_csr_waitrequest;                                                      
        wire [31:0]                     eth_1588_tod_1g_csr_writedata;                                                        
        wire [5:0]                      eth_1588_tod_1g_csr_address;                                                         
        wire                            eth_1588_tod_1g_csr_write;                                                            
        wire                            eth_1588_tod_1g_csr_read;                                                          
        wire [31:0]                     eth_1588_tod_1g_csr_readdata;                                                          

        //Packet Classifier
        wire                            tx_pkt_class_out_endofpacket;                               
        wire                            tx_pkt_class_out_valid;                                     
        wire                            tx_pkt_class_out_startofpacket;                             
        wire                            tx_pkt_class_out_error;                                     
        wire [2:0]                      tx_pkt_class_out_empty;                                     
        wire [63:0]                     tx_pkt_class_out_data;                                      
        wire                            tx_pkt_class_out_ready;
        
        wire                            tx_egress_timestamp_request_out_valid;
        wire [TSTAMP_FP_WIDTH-1:0]      tx_egress_timestamp_request_out_fingerprint;
        
        wire [15:0]                     tx_etstamp_ins_ctrl_out_offset_timestamp;
        wire [15:0]                     tx_etstamp_ins_ctrl_out_offset_correction_field;
        wire [15:0]                     tx_etstamp_ins_ctrl_out_offset_checksum_field;
        wire [15:0]                     tx_etstamp_ins_ctrl_out_offset_checksum_correction;
        
        wire                            tx_etstamp_ins_ctrl_out_checksum_zero;
        wire                            tx_etstamp_ins_ctrl_out_checksum_correct;
        wire                            tx_etstamp_ins_ctrl_out_timestamp_format;
        wire                            tx_etstamp_ins_ctrl_out_timestamp_insert;
        wire                            tx_etstamp_ins_ctrl_out_residence_time_update;      
        
        wire [95:0]                     tx_etstamp_ins_ctrl_out_ingress_timestamp_96b;
        wire [63:0]                     tx_etstamp_ins_ctrl_out_ingress_timestamp_64b;
        wire                            tx_etstamp_ins_ctrl_out_residence_time_calc_format;
        
        //tod
        wire [95:0]                     tx_time_of_day_96b_10g_data;
        wire [63:0]                     tx_time_of_day_64b_10g_data;
        wire [95:0]                     tx_time_of_day_96b_1g_data;
        wire [63:0]                     tx_time_of_day_64b_1g_data;
        
        wire [95:0]                     rx_time_of_day_96b_10g_data;
        wire [63:0]                     rx_time_of_day_64b_10g_data;
        wire [95:0]                     rx_time_of_day_96b_1g_data;
        wire [63:0]                     rx_time_of_day_64b_1g_data;
        
        wire [15:0]                     phy_rx_latency_adj_10g;
        wire [21:0]                     phy_rx_latency_adj_1g;
        wire [15:0]                     phy_tx_latency_adj_10g;
        wire [21:0]                     phy_tx_latency_adj_1g;
        
        wire [95:0]                     time_of_day_96b_10g;
        wire [63:0]                     time_of_day_64b_10g;
        wire [95:0]                     time_of_day_96b_1g;
        wire [63:0]                     time_of_day_64b_1g;
        
        wire                            tod_96b_slave_load_valid_10g;
        wire [95:0]                     tod_96b_slave_load_data_10g;
        wire                            tod_64b_slave_load_valid_10g;
        wire [63:0]                     tod_64b_slave_load_data_10g;
        
        wire                            tod_96b_slave_load_valid_1g;
        wire [95:0]                     tod_96b_slave_load_data_1g;
        wire                            tod_64b_slave_load_valid_1g;
        wire [63:0]                     tod_64b_slave_load_data_1g;
        
        wire                            phy_tx_clkout_1g_clk_reset_sync;
        wire                            phy_tx_clkout_1g_clk;

        wire [5:0]                      phy_pcs_mode_rc;
        wire                            reset_to_mac_wire;
        
 
        //sharing the same ToD for TX and RX
        assign  tx_time_of_day_96b_10g_data = time_of_day_96b_10g;
        assign  tx_time_of_day_64b_10g_data = time_of_day_64b_10g;
        assign  tx_time_of_day_96b_1g_data  = time_of_day_96b_1g;
        assign  tx_time_of_day_64b_1g_data  = time_of_day_64b_1g;
            
        assign  rx_time_of_day_96b_10g_data = time_of_day_96b_10g;
        assign  rx_time_of_day_64b_10g_data = time_of_day_64b_10g;
        assign  rx_time_of_day_96b_1g_data  = time_of_day_96b_1g;
        assign  rx_time_of_day_64b_1g_data  = time_of_day_64b_1g;
    
        assign xcvr_reset_control_pll_locked = pll_locked;
    
        assign phy_tx_clkout_1g_clk = phy_tx_recovered_clk;
      
        assign speed_sel[0] = phy_led_link;
  
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

//--------------------------------------------------------------------------    
    altera_reset_controller #(
        .NUM_RESET_INPUTS        (1),
        .OUTPUT_RESET_SYNC_EDGES ("deassert"),
        .SYNC_DEPTH              (2)
    ) reset_sync_tx_clkout_1g (
        .reset_in0  (datapath_reset), 
        .clk        (phy_tx_clkout_1g_clk),                  
        .reset_out  (phy_tx_clkout_1g_clk_reset_sync),

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
    
//============= Ethernet MAC PTP Frame Classifier ==========================================        
    altera_eth_packet_classifier #(
        .BITSPERSYMBOL      (8), 
        .SYMBOLSPERBEAT     (8), 
        .TSTAMP_FP_WIDTH    (TSTAMP_FP_WIDTH)
    ) altera_eth_packet_classifier_u0 (
        //Common clock and reset
        .clk                                                    (xgmii_clk),                        
        .reset                                                  (mac_tx_reset),         
        
        //Av-ST Data Sink
        .data_sink_sop                                          (mac_avalon_st_tx_startofpacket),
        .data_sink_eop                                          (mac_avalon_st_tx_endofpacket),
        .data_sink_valid                                        (mac_avalon_st_tx_valid),
        .data_sink_data                                         (mac_avalon_st_tx_data),                                                
        .data_sink_ready                                        (mac_avalon_st_tx_ready),
        .data_sink_empty                                        (mac_avalon_st_tx_empty),
        .data_sink_error                                        (mac_avalon_st_tx_error),
        
        //Av-ST Data Source
        .data_src_sop                                           (tx_pkt_class_out_startofpacket),
        .data_src_eop                                           (tx_pkt_class_out_endofpacket),
        .data_src_valid                                         (tx_pkt_class_out_valid),
        .data_src_data                                          (tx_pkt_class_out_data),                                                    
        .data_src_ready                                         (tx_pkt_class_out_ready),
        .data_src_empty                                         (tx_pkt_class_out_empty),
        .data_src_error                                         (tx_pkt_class_out_error),
        
        //timestamp
        .tx_etstamp_ins_ctrl_in_residence_time_update           (tx_etstamp_ins_ctrl_in_residence_time_update),
        .tx_etstamp_ins_ctrl_in_ingress_timestamp_96b           (tx_etstamp_ins_ctrl_in_ingress_timestamp_96b),
        .tx_etstamp_ins_ctrl_in_ingress_timestamp_64b           (tx_etstamp_ins_ctrl_in_ingress_timestamp_64b),
        .tx_etstamp_ins_ctrl_in_residence_time_calc_format      (tx_etstamp_ins_ctrl_in_residence_time_calc_format),
        
        .tx_egress_timestamp_request_in_valid                   (tx_egress_timestamp_request_in_valid),
        .tx_egress_timestamp_request_in_fingerprint             (tx_egress_timestamp_request_in_fingerprint),
        
        
        .tx_egress_timestamp_request_out_valid                  (tx_egress_timestamp_request_out_valid),
        .tx_egress_timestamp_request_out_fingerprint            (tx_egress_timestamp_request_out_fingerprint),
        
        //operation mode
        .clock_mode                                             (clock_operation_mode_mode),
        .pkt_with_crc                                           (pkt_with_crc_mode),  //1 = packet with crc; 0 = packet without crc
        
        //Offset locations
        .tx_etstamp_ins_ctrl_out_ingress_timestamp_96b          (tx_etstamp_ins_ctrl_out_ingress_timestamp_96b),
        .tx_etstamp_ins_ctrl_out_ingress_timestamp_64b          (tx_etstamp_ins_ctrl_out_ingress_timestamp_64b),
        .tx_etstamp_ins_ctrl_out_residence_time_calc_format     (tx_etstamp_ins_ctrl_out_residence_time_calc_format),
        .tx_etstamp_ins_ctrl_out_offset_timestamp               (tx_etstamp_ins_ctrl_out_offset_timestamp),
        .tx_etstamp_ins_ctrl_out_offset_correction_field        (tx_etstamp_ins_ctrl_out_offset_correction_field),
        .tx_etstamp_ins_ctrl_out_offset_checksum_field          (tx_etstamp_ins_ctrl_out_offset_checksum_field),
        .tx_etstamp_ins_ctrl_out_offset_checksum_correction     (tx_etstamp_ins_ctrl_out_offset_checksum_correction),
        
        .tx_etstamp_ins_ctrl_out_checksum_zero                  (tx_etstamp_ins_ctrl_out_checksum_zero),
        .tx_etstamp_ins_ctrl_out_checksum_correct               (tx_etstamp_ins_ctrl_out_checksum_correct),
        .tx_etstamp_ins_ctrl_out_timestamp_format               (tx_etstamp_ins_ctrl_out_timestamp_format),
        .tx_etstamp_ins_ctrl_out_timestamp_insert               (tx_etstamp_ins_ctrl_out_timestamp_insert),
        .tx_etstamp_ins_ctrl_out_residence_time_update          (tx_etstamp_ins_ctrl_out_residence_time_update)
    );  
//=============MAC==========================================
    altera_eth_10g_mac  mac (                                                                                                       
        .csr_clk                                                    (mm_clk),                                                                                                   
        .csr_rst_n                                                  (~mm_reset),                                                                                               
        .csr_address                                                (mac_csr_address[14:2]),    //byte to dword address                                                        
        .csr_waitrequest                                            (mac_csr_waitrequest),                                                                                     
        .csr_read                                                   (mac_csr_read),                                                                                  
        .csr_readdata                                               (mac_csr_readdata),                                                                              
        .csr_write                                                  (mac_csr_write),                                                                                                           
        .csr_writedata                                              (mac_csr_writedata),                                                                                                      
        .tx_156_25_clk                                              (xgmii_clk),                                                                                 
        .tx_312_5_clk                                               (xgmii_clk_312_5),                                      
        .tx_rst_n                                                   (~mac_tx_reset),                                                                                                          
        .rx_156_25_clk                                              (xgmii_clk),                                                                                 
        .rx_312_5_clk                                               (xgmii_clk_312_5),                                      
        .rx_rst_n                                                   (~mac_rx_reset),                                                                                                
        .avalon_st_tx_startofpacket                                 (tx_pkt_class_out_startofpacket),                                                                                              
        .avalon_st_tx_valid                                         (tx_pkt_class_out_valid),                                                                                                      
        .avalon_st_tx_data                                          (tx_pkt_class_out_data),                                                                                            
        .avalon_st_tx_empty                                         (tx_pkt_class_out_empty),                                                                                  
        .avalon_st_tx_ready                                         (tx_pkt_class_out_ready),                                                                                  
        .avalon_st_tx_error                                         (tx_pkt_class_out_error),                                                                                  
        .avalon_st_tx_endofpacket                                   (tx_pkt_class_out_endofpacket),                                                                            
        .xgmii_rx                                                   (phy_xgmii_rx_data),                                                                             
        .xgmii_tx                                                   (mac_xgmii_tx_data),                                                                         
        .avalon_st_txstatus_valid                                   (mac_avalon_st_tx_status_valid),                                                                           
        .avalon_st_txstatus_data                                    (mac_avalon_st_tx_status_data),                                                                                      
        .avalon_st_txstatus_error                                   (mac_avalon_st_tx_status_error),                                                                                                 
        .avalon_st_rx_startofpacket                                 (mac_avalon_st_rx_startofpacket),                                                                                             
        .avalon_st_rx_endofpacket                                   (mac_avalon_st_rx_endofpacket),                                                                                               
        .avalon_st_rx_valid                                         (mac_avalon_st_rx_valid),                                                                                                     
        .avalon_st_rx_ready                                         (mac_avalon_st_rx_ready),                                                                                                     
        .avalon_st_rx_data                                          (mac_avalon_st_rx_data),                                                                                              
        .avalon_st_rx_empty                                         (mac_avalon_st_rx_empty),                                                                                                  
        .avalon_st_rx_error                                         (mac_avalon_st_rx_error),                                                                                                  
        .avalon_st_rxstatus_valid                                   (mac_avalon_st_rx_status_valid),                                                                                            
        .avalon_st_rxstatus_data                                    (mac_avalon_st_rx_status_data),                                                                
        .avalon_st_rxstatus_error                                   (mac_avalon_st_rx_status_error),                                                                                  
        .avalon_st_pause_data                                       (mac_avalon_st_pause_data),                                                                                   
        .link_fault_status_xgmii_rx_data                            (mac_link_fault_status_xgmii_rx_data),                                                            
        .speed_sel                                                  (speed_sel),                                                                                  
        .gmii_tx_clk                                                (phy_tx_clkout_1g_clk),                                                                                             
        .gmii_tx_d                                                  (mac_gmii_tx_d),                                                                                                    
        .gmii_tx_en                                                 (mac_gmii_tx_en),                                                                                                   
        .gmii_tx_err                                                (mac_gmii_tx_err),                                                                                                  
        .gmii_rx_clk                                                (phy_tx_clkout_1g_clk),                                                                             
        .gmii_rx_err                                                (phy_gmii_rx_err),                                                                                  
        .gmii_rx_d                                                  (phy_gmii_rx_d),                                                                                                   
        .gmii_rx_dv                                                 (phy_gmii_rx_dv),                                                                                                  
        .tx_egress_timestamp_request_valid                          (tx_egress_timestamp_request_out_valid),                                     
        .tx_egress_timestamp_request_fingerprint                    (tx_egress_timestamp_request_out_fingerprint),                                                           
        .tx_egress_timestamp_96b_valid                              (tx_egress_timestamp_96b_valid),                                                   
        .tx_egress_timestamp_96b_data                               (tx_egress_timestamp_96b_data),                                                    
        .tx_egress_timestamp_96b_fingerprint                        (tx_egress_timestamp_96b_fingerprint),                                             
        .tx_egress_timestamp_64b_valid                              (tx_egress_timestamp_64b_valid),                                                   
        .tx_egress_timestamp_64b_data                               (tx_egress_timestamp_64b_data),                                                    
        .tx_egress_timestamp_64b_fingerprint                        (tx_egress_timestamp_64b_fingerprint),                                             
        .tx_etstamp_ins_ctrl_timestamp_insert                       (tx_etstamp_ins_ctrl_out_timestamp_insert),                                        
        .tx_etstamp_ins_ctrl_timestamp_format                       (tx_etstamp_ins_ctrl_out_timestamp_format),                                        
        .tx_etstamp_ins_ctrl_residence_time_update                  (tx_etstamp_ins_ctrl_out_residence_time_update),                                   
        .tx_etstamp_ins_ctrl_ingress_timestamp_96b                  (tx_etstamp_ins_ctrl_out_ingress_timestamp_96b),                                   
        .tx_etstamp_ins_ctrl_ingress_timestamp_64b                  (tx_etstamp_ins_ctrl_out_ingress_timestamp_64b),                                   
        .tx_etstamp_ins_ctrl_residence_time_calc_format             (tx_etstamp_ins_ctrl_out_residence_time_calc_format),                              
        .tx_etstamp_ins_ctrl_checksum_zero                          (tx_etstamp_ins_ctrl_out_checksum_zero),                            
        .tx_etstamp_ins_ctrl_checksum_correct                       (tx_etstamp_ins_ctrl_out_checksum_correct),                                
        .tx_etstamp_ins_ctrl_offset_timestamp                       (tx_etstamp_ins_ctrl_out_offset_timestamp),                                
        .tx_etstamp_ins_ctrl_offset_correction_field                (tx_etstamp_ins_ctrl_out_offset_correction_field),                         
        .tx_etstamp_ins_ctrl_offset_checksum_field                  (tx_etstamp_ins_ctrl_out_offset_checksum_field),                           
        .tx_etstamp_ins_ctrl_offset_checksum_correction             (tx_etstamp_ins_ctrl_out_offset_checksum_correction),                      
        .rx_ingress_timestamp_96b_valid                             (rx_ingress_timestamp_96b_valid),                                         
        .rx_ingress_timestamp_96b_data                              (rx_ingress_timestamp_96b_data),                                          
        .rx_ingress_timestamp_64b_valid                             (rx_ingress_timestamp_64b_valid),                                         
        .rx_ingress_timestamp_64b_data                              (rx_ingress_timestamp_64b_data),                                          
        .tx_time_of_day_96b_10g_data                                (tx_time_of_day_96b_10g_data),                                      
        .tx_time_of_day_64b_10g_data                                (tx_time_of_day_64b_10g_data),                                      
        .tx_time_of_day_96b_1g_data                                 (tx_time_of_day_96b_1g_data),                                         
        .tx_time_of_day_64b_1g_data                                 (tx_time_of_day_64b_1g_data),                                         
        .rx_time_of_day_96b_10g_data                                (rx_time_of_day_96b_10g_data),                                        
        .rx_time_of_day_64b_10g_data                                (rx_time_of_day_64b_10g_data),                                        
        .rx_time_of_day_96b_1g_data                                 (rx_time_of_day_96b_1g_data),                                         
        .rx_time_of_day_64b_1g_data                                 (rx_time_of_day_64b_1g_data),                                         
        .tx_path_delay_10g_data                                     (phy_tx_latency_adj_10g),                                             
        .tx_path_delay_1g_data                                      (phy_tx_latency_adj_1g),                                              
        .rx_path_delay_10g_data                                     (phy_rx_latency_adj_10g),                                             
        .rx_path_delay_1g_data                                      (phy_rx_latency_adj_1g)
        //,.latency_measure_sampling_clk                               (phy_tx_recovered_clk)
    );                                                                                                                                    
                                                                                                                                          
//=============NF PHY==========================================                                                                                                             
    altera_eth_10gkr_phy phy (                                                                                        
        .tx_serial_clk_10g        (tx_serial_clk_10g),
        .tx_serial_clk_1g         (tx_serial_clk_1g),
        .rx_cdr_ref_clk_10g       (cdr_ref_clk_10g),
        .rx_cdr_ref_clk_1g        (cdr_ref_clk_1g), 
        .xgmii_tx_clk             (xgmii_clk),                                                                        
        .xgmii_rx_clk             (xgmii_clk),                                                                        
        .tx_clkout 		          (phy_tx_recovered_clk),                                                             
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
//        .mii_speed_sel            (speed_sel),                                                                                    
        .led_an                   (phy_led_an),                                                                       
        .led_char_err             (phy_led_char_err),                                                                 
        .led_disp_err             (phy_led_disp_err),                                                                 
        .led_link                 (phy_led_link),                                                                     
        .tx_pcfifo_error_1g       (phy_tx_pcfifo_error_1g),                                                           
        .rx_pcfifo_error_1g       (phy_rx_pcfifo_error_1g),                                                           
        .rx_syncstatus            (phy_rx_syncstatus),                                                                
        .rx_clkslip               (phy_rx_clkslip),                                                                   
        .xgmii_tx_dc              (mac_xgmii_tx_data),                                                                
        .xgmii_rx_dc              (phy_xgmii_rx_data),                                                                
        .rx_is_lockedtodata       (xcvr_reset_control_rx_is_lockedtodata[0]),                                         
        .tx_cal_busy              (xcvr_reset_control_tx_cal_busy[0]),                                                
        .rx_cal_busy              (xcvr_reset_control_rx_cal_busy[0]),                                                
        .rx_data_ready            (phy_rx_data_ready),                                                                
        .rx_block_lock            (phy_rx_block_lock),                                                                
        .rx_hi_ber                (phy_rx_hi_ber),                                                                    
        .tx_serial_data           (phy_tx_serial_data),                                                               
        .rx_serial_data           (phy_rx_serial_data),                                                               
        .rx_latency_adj_10g       (phy_rx_latency_adj_10g),                                                           
        .tx_latency_adj_10g       (phy_tx_latency_adj_10g),                                                           
        .rx_latency_adj_1g        (phy_rx_latency_adj_1g),                                                            
        .tx_latency_adj_1g        (phy_tx_latency_adj_1g),                                                            
        .calc_clk_1g              (calc_clk_1g),
        //.lcl_rf                 (phy_lcl_rf),                                                                       
        //.en_lcl_rxeq            (phy_en_lcl_rxeq),                                                                  
        //.rxeq_done              (phy_rxeq_done),
        .tx_pma_clkout		  (),
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
    
    //=============Time of Day ==========================================
    altera_eth_1588_tod_10g eth_1588_tod_10g_u0 (
        .period_clk                         (xgmii_clk_312_5),                  
        .period_rst_n                       (~xgmii_clk_312_5_reset),
        .clk                                (mm_clk),
        .rst_n                              (~mm_reset),                
        .csr_write                          (eth_1588_tod_10g_csr_write),                       
        .csr_read                           (eth_1588_tod_10g_csr_read),
        .csr_address                        (eth_1588_tod_10g_csr_address[5:2]), //byte to dword address 
        .csr_writedata                      (eth_1588_tod_10g_csr_writedata),
        .csr_readdata                       (eth_1588_tod_10g_csr_readdata),
        .csr_waitrequest                    (eth_1588_tod_10g_csr_waitrequest),
        .time_of_day_96b                    (time_of_day_96b_10g),
        .time_of_day_64b                    (time_of_day_64b_10g),
        .time_of_day_96b_load_valid         (tod_96b_slave_load_valid_10g),                        
        .time_of_day_96b_load_data          (tod_96b_slave_load_data_10g),
        .time_of_day_64b_load_valid         (tod_64b_slave_load_valid_10g),                        
        .time_of_day_64b_load_data          (tod_64b_slave_load_data_10g)
        );
        
    altera_eth_1588_tod_1g eth_1588_tod_1g_u1 (
        .period_clk                         (phy_tx_clkout_1g_clk),     
        .period_rst_n                       (~phy_tx_clkout_1g_clk_reset_sync),
        .clk                                (mm_clk),
        .rst_n                              (~mm_reset),                        
        .csr_write                          (eth_1588_tod_1g_csr_write),                                
        .csr_read                           (eth_1588_tod_1g_csr_read),
        .csr_address                        (eth_1588_tod_1g_csr_address[5:2]), //byte to dword address 
        .csr_writedata                      (eth_1588_tod_1g_csr_writedata),
        .csr_readdata                       (eth_1588_tod_1g_csr_readdata),
        .csr_waitrequest                    (eth_1588_tod_1g_csr_waitrequest),
        .time_of_day_96b                    (time_of_day_96b_1g),
        .time_of_day_64b                    (time_of_day_64b_1g),
        .time_of_day_96b_load_valid         (tod_96b_slave_load_valid_1g),                         
        .time_of_day_96b_load_data          (tod_96b_slave_load_data_1g),
        .time_of_day_64b_load_valid         (tod_64b_slave_load_valid_1g),                         
        .time_of_day_64b_load_data          (tod_64b_slave_load_data_1g)
    );
    
//============= Time of Day Sync ==========================================         
    altera_eth_1588_tod_sync_96b_10g eth_1588_tod_synchronizer_96b_10g_u0 (
    
    //master tod interface
        .clk_master                         (master_tod_clk),
        .reset_master                       (master_tod_reset),
        .start_tod_sync                     (start_tod_sync),
        .tod_master_data                    (master_tod_96b_data),
        
        //slave tod interface
        .clk_slave                          (xgmii_clk_312_5),
        .clk_sampling                       (tod_sync_10g_sampling_clk),
        .reset_slave                        (xgmii_clk_312_5_reset),
        .tod_slave_valid                    (tod_96b_slave_load_valid_10g),
        .tod_slave_data                     (tod_96b_slave_load_data_10g)
    );
    
    altera_eth_1588_tod_sync_64b_10g eth_1588_tod_synchronizer_64b_10g_u1 (
    
        
        //master tod interface
        .clk_master                         (master_tod_clk),
        .reset_master                       (master_tod_reset),
        .start_tod_sync                     (start_tod_sync),
        .tod_master_data                    (master_tod_64b_data),
        
        //slave tod interface
        .clk_slave                          (xgmii_clk_312_5),
        .clk_sampling                       (tod_sync_10g_sampling_clk),
        .reset_slave                        (xgmii_clk_312_5_reset),
        .tod_slave_valid                    (tod_64b_slave_load_valid_10g),
        .tod_slave_data                     (tod_64b_slave_load_data_10g)
    );


    altera_eth_1588_tod_sync_96b_1g eth_1588_tod_synchronizer_96b_1g_u2 (
    
            
        //master tod interface
        .clk_master                         (master_tod_clk),
        .reset_master                       (master_tod_reset),
        .start_tod_sync                     (start_tod_sync),
        .tod_master_data                    (master_tod_96b_data),
        
        //slave tod interface

        .clk_slave                          (phy_tx_clkout_1g_clk),
        .clk_sampling                       (tod_sync_1g_sampling_clk),
        .reset_slave                        (phy_tx_clkout_1g_clk_reset_sync),
        .tod_slave_valid                    (tod_96b_slave_load_valid_1g),
        .tod_slave_data                     (tod_96b_slave_load_data_1g)

    );

    altera_eth_1588_tod_sync_64b_1g eth_1588_tod_synchronizer_64b_1g_u3 (
    
            
        //master tod interface
        .clk_master                         (master_tod_clk),
        .reset_master                       (master_tod_reset),
        .start_tod_sync                     (start_tod_sync),
        .tod_master_data                    (master_tod_64b_data),
        
        //slave tod interface

        .clk_slave                          (phy_tx_clkout_1g_clk),
        .clk_sampling                       (tod_sync_1g_sampling_clk),
        .reset_slave                        (phy_tx_clkout_1g_clk_reset_sync),
        .tod_slave_valid                    (tod_64b_slave_load_valid_1g),
        .tod_slave_data                     (tod_64b_slave_load_data_1g)
    );


//============= Pulse Per Second ========================================== 
    altera_eth_1588_pps #(
        .PULSE_CYCLE        (PPS_PULSE_ASSERT_CYCLE_10G)    // assert for 1ms for every 10ms
    ) pulse_per_second_10g_u0 (
        .clk                                (xgmii_clk_312_5),
        .reset                              (xgmii_clk_312_5_reset),
    
        .time_of_day_96b                    (time_of_day_96b_10g),
        .pulse_per_second                   (pulse_per_second_10g)
    );  
    
    altera_eth_1588_pps #(
        .PULSE_CYCLE        (PPS_PULSE_ASSERT_CYCLE_1G)     // assert for 1ms for every 10ms    
    ) pulse_per_second_1g_u1 (
        .clk                                (phy_tx_clkout_1g_clk),
        .reset                              (phy_tx_clkout_1g_clk_reset_sync),
    
        .time_of_day_96b                    (time_of_day_96b_1g),
        .pulse_per_second                   (pulse_per_second_1g)
    );      

//==============MDIO=========================================================================

    altera_eth_mdio #(
        .MDC_DIVISOR        (MDIO_MDC_CLOCK_DIVISOR)
    ) eth_mdio (
        .clk             (mm_clk),                                          
        .reset           (mm_reset),                   
        .csr_write       (eth_mdio_csr_write),     
        .csr_read        (eth_mdio_csr_read),       
        .csr_address     (eth_mdio_csr_address[7:2]),    //byte to dword address 
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

        .clk_clk                                                (mm_clk),                             
        .reset_reset_n                                          (~mm_reset),                     

    
        .master_avalon_anti_master_0_waitrequest                (csr_waitrequest),    
        .master_avalon_anti_master_0_readdata                   (csr_readdata),      
        .master_avalon_anti_master_0_writedata                  (csr_writedata),     
        .master_avalon_anti_master_0_address                    (csr_address),       
        .master_avalon_anti_master_0_write                      (csr_write),          
        .master_avalon_anti_master_0_read                       (csr_read),           
    

        .mac_avalon_anti_slave_0_waitrequest                    (mac_csr_waitrequest),      
        .mac_avalon_anti_slave_0_readdata                       (mac_csr_readdata),
        .mac_avalon_anti_slave_0_writedata                      (mac_csr_writedata),
        .mac_avalon_anti_slave_0_address                        (mac_csr_address),
        .mac_avalon_anti_slave_0_write                          (mac_csr_write),
        .mac_avalon_anti_slave_0_read                           (mac_csr_read),

        
        .phy_avalon_anti_slave_0_waitrequest                    (phy_mgmt_waitrequest),       
        .phy_avalon_anti_slave_0_readdata                       (phy_mgmt_readdata),          
        .phy_avalon_anti_slave_0_writedata                      (phy_mgmt_writedata),        
        .phy_avalon_anti_slave_0_address                        (phy_mgmt_address),          
        .phy_avalon_anti_slave_0_write                          (phy_mgmt_write),            
        .phy_avalon_anti_slave_0_read                           (phy_mgmt_read),             

    
//      .mdio_avalon_anti_slave_0_waitrequest                   (eth_mdio_csr_waitrequest),      
//      .mdio_avalon_anti_slave_0_readdata                      (eth_mdio_csr_readdata),         
//      .mdio_avalon_anti_slave_0_writedata                     (eth_mdio_csr_writedata),        
//      .mdio_avalon_anti_slave_0_address                       (eth_mdio_csr_address),         
//      .mdio_avalon_anti_slave_0_write                         (eth_mdio_csr_write),           
//      .mdio_avalon_anti_slave_0_read                          (eth_mdio_csr_read),

        .eth_1588_tod_1g_avalon_anti_slave_0_waitrequest        (eth_1588_tod_1g_csr_waitrequest),      
        .eth_1588_tod_1g_avalon_anti_slave_0_readdata           (eth_1588_tod_1g_csr_readdata),         
        .eth_1588_tod_1g_avalon_anti_slave_0_writedata          (eth_1588_tod_1g_csr_writedata),        
        .eth_1588_tod_1g_avalon_anti_slave_0_address            (eth_1588_tod_1g_csr_address),         
        .eth_1588_tod_1g_avalon_anti_slave_0_write              (eth_1588_tod_1g_csr_write),           
        .eth_1588_tod_1g_avalon_anti_slave_0_read               (eth_1588_tod_1g_csr_read),
        
        .eth_1588_tod_10g_avalon_anti_slave_0_waitrequest       (eth_1588_tod_10g_csr_waitrequest),      
        .eth_1588_tod_10g_avalon_anti_slave_0_readdata          (eth_1588_tod_10g_csr_readdata),         
        .eth_1588_tod_10g_avalon_anti_slave_0_writedata         (eth_1588_tod_10g_csr_writedata),        
        .eth_1588_tod_10g_avalon_anti_slave_0_address           (eth_1588_tod_10g_csr_address),         
        .eth_1588_tod_10g_avalon_anti_slave_0_write             (eth_1588_tod_10g_csr_write),           
        .eth_1588_tod_10g_avalon_anti_slave_0_read              (eth_1588_tod_10g_csr_read) 
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
