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


module altera_eth_multi_channel_1588 (

        mm_clk,
        
        pll_ref_clk_1g,  // for tx
        pll_ref_clk_10g,  //
        
        cdr_ref_clk_1g,   //for rx
        cdr_ref_clk_10g,                    
        master_reset_n,
        channel_reset_n,
        xgmii_clk,

        write,              
        read,           
        address,            
        writedata,          
        readdata,           
        waitrequest,           
                     
        rx_recovered_clk,

                     
        avalon_st_tx_startofpacket,
        avalon_st_tx_endofpacket,
        avalon_st_tx_valid,
        avalon_st_tx_ready,
        avalon_st_tx_data,
        avalon_st_tx_empty,
        avalon_st_tx_error,
                  
        avalon_st_rx_startofpacket,
        avalon_st_rx_endofpacket,
        avalon_st_rx_valid,
        avalon_st_rx_ready,
        avalon_st_rx_data,
        avalon_st_rx_empty,
        avalon_st_rx_error,

        avalon_st_tx_status_valid,                      
        avalon_st_tx_status_data,                       
        avalon_st_tx_status_error,                          
        avalon_st_rx_status_valid,                       
        avalon_st_rx_status_data,                        
        avalon_st_rx_status_error, 

        avalon_st_pause_data,

        rx_serial_data,
        tx_serial_data,

        channel_ready,
        ethernet_1g_an,
        ethernet_1g_char_err,
        ethernet_1g_disp_err, 
        
        mdio_mdc,                            
        mdio_in,                    
        mdio_out,                  
        mdio_oen, 

        master_pulse_per_second,

        tx_egress_timestamp_request_in_valid,
        tx_egress_timestamp_request_in_fingerprint,
     
        tx_ingress_timestamp_valid,
        tx_ingress_timestamp_96b_data,
        tx_ingress_timestamp_64b_data,
        tx_ingress_timestamp_format,
    
        clock_operation_mode_mode,
        pkt_with_crc_mode,

        tx_egress_timestamp_96b_valid,
        tx_egress_timestamp_96b_data,          
        tx_egress_timestamp_96b_fingerprint,
        tx_egress_timestamp_64b_valid,
        tx_egress_timestamp_64b_data,
        tx_egress_timestamp_64b_fingerprint,

        rx_ingress_timestamp_96b_valid,
        rx_ingress_timestamp_96b_data,
        rx_ingress_timestamp_64b_valid,
        rx_ingress_timestamp_64b_data,

        start_tod_sync,
        
        
        pulse_per_second_10g,  
        pulse_per_second_1g

        );


    parameter   NUM_CHANNELS = 2;                                               // range from 1-12
    parameter   TSTAMP_FP_WIDTH = 4;                                            //Fingerprint Width follow the setting in MAC 1588 GUI
    parameter   SV_RCN_BUNDLE_MODE = 2;                                         // mode0-10GBaseKR, mode1-1G10G without 1588, mode2 -1G10G with 1588  
    parameter   MDIO_MDC_CLOCK_DIVISOR  = 32;                                   //MDIO
    parameter   SHARED_REFCLK_EN  = 1;                                          //share ref clock for all channel  1- enable sharing, 0- disable sharing
    
    
    localparam  MASTER_TOD_SYNC_MODE        = 1;                                //must set to 1; mode 0--> Master TOD is 10G; mode 1--> Master TOD is 1G         
    localparam  DEFAULT_NSEC_PERIOD_10G     = 4'h6;                             //Time of Day each step is 6.4ns for 10G
    localparam  DEFAULT_FNSEC_PERIOD_10G    = 16'h6666;
    localparam  DEFAULT_NSEC_PERIOD_1G      = 4'h8;                             //Time of Day each step is 8.0ns for 1G
    localparam  DEFAULT_FNSEC_PERIOD_1G     = 16'h0000; 
    localparam  PPS_PULSE_ASSERT_CYCLE_10G = 1562500;                           //Pulse Per Second for 10G - Assert for 10ms (10ms / 6.4ns = 1562500)
    localparam  PPS_PULSE_ASSERT_CYCLE_1G   = 1250000;                          //Pulse Per Second for 1G - Assert for 10ms (10ms / 8.0ns = 1250000)    

	localparam  TOD_SYNC_MODE_1G  = (MASTER_TOD_SYNC_MODE == 1) ? 2:1; 			//mode 0 --> 1G(125mhz) to 10G(156.25mhz) Sync, mode 1 --> 10G(156.25mhz) to 1G(125mhz) Sync, mode 2 --> same freq sync (tested at 125mhz to 312.5mhz), mode 5 --> 1G(125Mhz) to 10G(312.5mhz) Sync
    localparam  TOD_SYNC_MODE_10G = (MASTER_TOD_SYNC_MODE == 1) ? 5:2;			//mode 0 --> 1G(125mhz) to 10G(156.25mhz) Sync, mode 1 --> 10G(156.25mhz) to 1G(125mhz) Sync, mode 2 --> same freq sync (tested at 125mhz to 312.5mhz), mode 5 --> 1G(125Mhz) to 10G(312.5mhz) Sync

    localparam  MAX_NUM_CHANNELS=12;
    
    localparam  NUM_UNSHARED_CHANNELS = (SHARED_REFCLK_EN == 1) ? 1:NUM_CHANNELS;
    
    // ports declaration
    input       wire                                                        mm_clk;
    input       wire    [NUM_UNSHARED_CHANNELS-1:0]                         pll_ref_clk_1g;     // for syncE
    input       wire    [NUM_UNSHARED_CHANNELS-1:0]                         pll_ref_clk_10g;    
    input       wire    [NUM_UNSHARED_CHANNELS-1:0]                         cdr_ref_clk_1g;     //for SyncE
    input       wire    [NUM_UNSHARED_CHANNELS-1:0]                         cdr_ref_clk_10g;                    
    input       wire    [NUM_CHANNELS-1:0]                                  channel_reset_n;
    output      wire    [NUM_UNSHARED_CHANNELS-1:0]                         xgmii_clk;
    input       wire                                                        master_reset_n;     
    input       wire                                                        write;              
    input       wire                                                        read;           
    input       wire    [19:0]                                              address;            
    input       wire    [31:0]                                              writedata;          
    output      wire    [31:0]                                              readdata;           
    output      wire                                                        waitrequest;           
    output      wire    [NUM_CHANNELS-1:0]                                  rx_recovered_clk;
    input       wire    [NUM_CHANNELS-1:0]                                  avalon_st_tx_startofpacket;
    input       wire    [NUM_CHANNELS-1:0]                                  avalon_st_tx_endofpacket;
    input       wire    [NUM_CHANNELS-1:0]                                  avalon_st_tx_valid;
    output      wire    [NUM_CHANNELS-1:0]                                  avalon_st_tx_ready;
    input       wire    [NUM_CHANNELS-1:0][63:0]                            avalon_st_tx_data;
    input       wire    [NUM_CHANNELS-1:0][2:0]                             avalon_st_tx_empty;
    input       wire    [NUM_CHANNELS-1:0]                                  avalon_st_tx_error;
                
    output      wire    [NUM_CHANNELS-1:0]                                  avalon_st_rx_startofpacket;
    output      wire    [NUM_CHANNELS-1:0]                                  avalon_st_rx_endofpacket;
    output      wire    [NUM_CHANNELS-1:0]                                  avalon_st_rx_valid;
    input       wire    [NUM_CHANNELS-1:0]                                  avalon_st_rx_ready;
    output      wire    [NUM_CHANNELS-1:0][63:0]                            avalon_st_rx_data;
    output      wire    [NUM_CHANNELS-1:0][2:0]                             avalon_st_rx_empty;
    output      wire    [NUM_CHANNELS-1:0][5:0]                             avalon_st_rx_error;
    
    output      wire    [NUM_CHANNELS-1:0]                                  avalon_st_tx_status_valid;                      
    output      wire    [NUM_CHANNELS-1:0][39:0]                            avalon_st_tx_status_data;                       
    output      wire    [NUM_CHANNELS-1:0][6:0]                             avalon_st_tx_status_error;                          
    output      wire    [NUM_CHANNELS-1:0]                                  avalon_st_rx_status_valid;                       
    output      wire    [NUM_CHANNELS-1:0][39:0]                            avalon_st_rx_status_data;                        
    output      wire    [NUM_CHANNELS-1:0][6:0]                             avalon_st_rx_status_error; 
    
    input       wire    [NUM_CHANNELS-1:0][1:0]                             avalon_st_pause_data;
    
    input       wire    [NUM_CHANNELS-1:0]                                  rx_serial_data;
    output      wire    [NUM_CHANNELS-1:0]                                  tx_serial_data;
    
    output      wire    [NUM_CHANNELS-1:0]                                  channel_ready;
    output      wire    [NUM_CHANNELS-1:0]                                  ethernet_1g_an;
    output      wire    [NUM_CHANNELS-1:0]                                  ethernet_1g_char_err;
    output      wire    [NUM_CHANNELS-1:0]                                  ethernet_1g_disp_err; 
    
    output      wire    [NUM_CHANNELS-1:0]                                  mdio_mdc;                            
    input       wire    [NUM_CHANNELS-1:0]                                  mdio_in;                    
    output      wire    [NUM_CHANNELS-1:0]                                  mdio_out;                  
    output      wire    [NUM_CHANNELS-1:0]                                  mdio_oen; 
    

  
    output      wire                                                        master_pulse_per_second;
    
    input       wire    [NUM_CHANNELS-1:0]                                  tx_egress_timestamp_request_in_valid;
    input       wire    [NUM_CHANNELS-1:0][TSTAMP_FP_WIDTH-1:0]             tx_egress_timestamp_request_in_fingerprint;
    
    input       wire    [NUM_CHANNELS-1:0]                                  tx_ingress_timestamp_valid;
    input       wire    [NUM_CHANNELS-1:0][95:0]                            tx_ingress_timestamp_96b_data;
    input       wire    [NUM_CHANNELS-1:0][63:0]                            tx_ingress_timestamp_64b_data;
    input       wire    [NUM_CHANNELS-1:0]                                  tx_ingress_timestamp_format;
    
    input       wire    [NUM_CHANNELS-1:0][1:0]                             clock_operation_mode_mode;
    input       wire    [NUM_CHANNELS-1:0]                                  pkt_with_crc_mode;
    
    output      wire    [NUM_CHANNELS-1:0]                                  tx_egress_timestamp_96b_valid;
    output      wire    [NUM_CHANNELS-1:0][95:0]                            tx_egress_timestamp_96b_data;          
    output      wire    [NUM_CHANNELS-1:0][TSTAMP_FP_WIDTH - 1:0]           tx_egress_timestamp_96b_fingerprint;
    output      wire    [NUM_CHANNELS-1:0]                                  tx_egress_timestamp_64b_valid;
    output      wire    [NUM_CHANNELS-1:0][63:0]                            tx_egress_timestamp_64b_data;
    output      wire    [NUM_CHANNELS-1:0][TSTAMP_FP_WIDTH - 1:0]           tx_egress_timestamp_64b_fingerprint;
    
    output      wire    [NUM_CHANNELS-1:0]                                  rx_ingress_timestamp_96b_valid;
    output      wire    [NUM_CHANNELS-1:0][95:0]                            rx_ingress_timestamp_96b_data;
    output      wire    [NUM_CHANNELS-1:0]                                  rx_ingress_timestamp_64b_valid;
    output      wire    [NUM_CHANNELS-1:0][63:0]                            rx_ingress_timestamp_64b_data;
    
    input       wire    [NUM_CHANNELS-1:0]                                  start_tod_sync;
    
    output      wire    [NUM_CHANNELS-1:0]                                  pulse_per_second_10g;  
    output      wire    [NUM_CHANNELS-1:0]                                  pulse_per_second_1g;
    
    // wire declaration
    wire                [NUM_CHANNELS-1:0]                                  xgmii_clk_312_5;
    wire                [NUM_CHANNELS-1:0]                                  pll_ref_clk_1g_reg;     // for syncE
    wire                [NUM_CHANNELS-1:0]                                  pll_ref_clk_10g_reg;    
    wire                [NUM_CHANNELS-1:0]                                  cdr_ref_clk_1g_reg;     //for SyncE
    wire                [NUM_CHANNELS-1:0]                                  cdr_ref_clk_10g_reg;                    
    wire                [NUM_CHANNELS-1:0]                                  xgmii_clk_reg;
    wire                                                                    calc_clk_1g;            // sampling clock for GIGE PCS latency measurement
    wire                [NUM_CHANNELS-1:0]                                  datapath_reset_sync;
    
    wire                [NUM_CHANNELS-1:0]                                  xgmii_clk_312_5_reset_sync;
    wire                [NUM_CHANNELS-1:0]                                  mm_clk_reset_sync;   
    
    wire                                                                    pll_locked;
    wire                [NUM_UNSHARED_CHANNELS-1:0]                         pll_1_locked;
    wire                                                                    pll_2_locked;    
    wire                [((NUM_CHANNELS-1)/12):0]                           pll_locked_10g;
    wire                [((NUM_CHANNELS-1)/6):0]                            pll_locked_1g;  
    
    wire                                                                    master_tod_clk;
    wire                                                                    master_tod_reset_sync;
    wire                [95:0]                                              master_tod_96b;
    wire                [63:0]                                              master_tod_64b;
    
    wire                                                                    tod_sync_1g_sampling_clk;
    
    wire                                                                    eth_1588_master_tod_csr_waitrequest;                                                      
    wire                [31:0]                                              eth_1588_master_tod_csr_writedata;                                                        
    wire                [5:0]                                               eth_1588_master_tod_csr_address;                                                         
    wire                                                                    eth_1588_master_tod_csr_write;                                                            
    wire                                                                    eth_1588_master_tod_csr_read;                                                          
    wire                [31:0]                                              eth_1588_master_tod_csr_readdata;   
    
    wire                [NUM_CHANNELS-1:0]                                  led_link;
    wire                [NUM_CHANNELS-1:0][0:0]                             rx_data_ready;
    wire                [NUM_CHANNELS-1:0]                                  channel_1g_ready;  
    wire                [NUM_CHANNELS-1:0]                                  channel_10g_ready; 
    wire                [NUM_CHANNELS-1:0][1:0]                             link_fault_status_xgmii_rx_data;     
    
    wire                [MAX_NUM_CHANNELS-1:0]                              multi_channel_write;            
    wire                [MAX_NUM_CHANNELS-1:0]                              multi_channel_read;             
    wire                [MAX_NUM_CHANNELS-1:0][15:0]                        multi_channel_address;            
    wire                [MAX_NUM_CHANNELS-1:0][31:0]                        multi_channel_writedata;            
    wire                [MAX_NUM_CHANNELS-1:0][31:0]                        multi_channel_readdata;         
    wire                [MAX_NUM_CHANNELS-1:0]                              multi_channel_readdata_valid;   
    wire                [MAX_NUM_CHANNELS-1:0]                              multi_channel_waitrequest;          
    
    wire                [NUM_CHANNELS-1:0]                                  en_lcl_rxeq;   

    wire                [NUM_CHANNELS-1:0]                                  rx_hi_ber;
    wire                [NUM_CHANNELS-1:0]                                  rx_syncstatus;
    wire                [NUM_CHANNELS-1:0]                                  rx_10g_block_lock;   
    wire                [NUM_CHANNELS-1:0]                                  rx_rlv;                               
    wire                [NUM_CHANNELS-1:0]                                  rx_pcfifo_error_1g;                   
    wire                [NUM_CHANNELS-1:0]                                  tx_pcfifo_error_1g;                   
     
    wire                [NUM_CHANNELS-1:0]                                  xcvr_reset_control_pll_powerdown;
    wire                [NUM_CHANNELS-1:0]                                  pll_powerdown;
    wire                [NUM_CHANNELS-1:0][1:0]                             speed_sel;
    wire                [NUM_CHANNELS-1 :0]                                 channel_reset_reg_n;
    wire                [NUM_UNSHARED_CHANNELS-1:0]                         xgmii_clk_shared;
    wire                [NUM_UNSHARED_CHANNELS-1:0]                         xgmii_clk_312_5_shared;
    wire                [((NUM_CHANNELS-1)/12):0]                           tx_serial_clk_10g;
    wire                [((NUM_CHANNELS-1)/6):0]                            tx_serial_clk_1g;
    wire                                                                    tod_sync_10g_sampling_clk;


    assign  master_tod_clk = pll_ref_clk_1g[0];
 
    assign  calc_clk_1g = tod_sync_1g_sampling_clk;
     
    assign  pll_locked = (&pll_1_locked) & pll_2_locked & (&pll_locked_10g) & (&pll_locked_1g);
    
    //=============PLL==========================================                   
    pll_2 pll_2_inst (
        .refclk         (pll_ref_clk_1g[0]),    // use fixed pll_ref_clk_1g[0] for this pll
        .rst            (~master_reset_n),    
        .outclk_0       (tod_sync_1g_sampling_clk), //125*64/63
        .outclk_1       (tod_sync_10g_sampling_clk),//125*16/63
        .locked         (pll_2_locked)
    );
    //=========== Reset Sync=====================================
    altera_reset_controller #(
        .NUM_RESET_INPUTS        (1),
        .OUTPUT_RESET_SYNC_EDGES ("deassert"),
        .SYNC_DEPTH              (2)
    ) reset_sync_master_tod_clk (
        .reset_in0  (~master_reset_n),             
        .clk        (master_tod_clk),                     
        .reset_out  (master_tod_reset_sync),

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
    ) reset_sync_master_mm_clk (
        .reset_in0  (~master_reset_n),             
        .clk        (mm_clk),                     
        .reset_out  (master_mm_reset_sync),

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
    
   //--------------------------
genvar phyatxpllid;
generate
    for (phyatxpllid = 0; phyatxpllid <= ((NUM_CHANNELS-1)/12); phyatxpllid = phyatxpllid+1)
    begin: PHY_ATXPLL
            //=============NF ATX 10g PLL====================================================
            nf_xcvr_10g_pll atx_pll_inst (
                .pll_powerdown      (~master_reset_n),
                .pll_refclk0        (pll_ref_clk_10g_reg[0]),
                .tx_serial_clk      (),
                .pll_locked         (pll_locked_10g[phyatxpllid]),
                .pll_cal_busy       (),
                .mcgb_rst           (~master_reset_n),
                .mcgb_serial_clk    (tx_serial_clk_10g[phyatxpllid])
            ); 
    end //end for
endgenerate   
   
genvar phypllid;
generate
    for (phypllid = 0; phypllid <= ((NUM_CHANNELS-1)/6); phypllid = phypllid+1)
    begin: PHY_PLL

        assign  pll_powerdown[phypllid] = ~ master_reset_n; 
 
            //=============NF FPLL 1G PLL====================================================
            nf_xcvr_1g_pll  oneg_pll_inst (
                .pll_powerdown      (pll_powerdown[phypllid]),
                .pll_refclk0        (pll_ref_clk_1g_reg[0]),
                .tx_serial_clk      (tx_serial_clk_1g[phypllid]),
                .pll_locked         (pll_locked_1g[phypllid]),
                .mcgb_rst           (pll_powerdown[phypllid]),
                .mcgb_serial_clk    (),
		.pll_cal_busy	    ()
            );  
    
    end //end for
endgenerate

genvar fpllid;
generate
    for (fpllid = 0; fpllid < NUM_UNSHARED_CHANNELS; fpllid = fpllid+1)
    begin: FPLL       
        io_pll pll_inst (
            .refclk         (pll_ref_clk_10g_reg[fpllid]), 
            .rst            (~master_reset_n),    
            .outclk_0       (xgmii_clk_shared[fpllid]),      
            .outclk_1       (xgmii_clk_312_5_shared[fpllid]),       
            .locked         (pll_1_locked[fpllid])   
        );  

        if (SHARED_REFCLK_EN == 1) begin
            assign xgmii_clk[0] = xgmii_clk_shared[0];
   end
        else if (SHARED_REFCLK_EN == 0) begin
            assign xgmii_clk[fpllid] = xgmii_clk_shared[fpllid];
        end   
    end //end for
endgenerate
    
    //========== start loop=======================================
    
genvar portid;
generate
 
 
    for (portid =0; portid < NUM_CHANNELS; portid = portid+1)
    begin: CHANNEL

    assign channel_10g_ready[portid] = rx_data_ready[portid] & (link_fault_status_xgmii_rx_data[portid] == 2'b00) & rx_10g_block_lock[portid];
    assign channel_1g_ready[portid]  = led_link[portid];
    assign channel_ready[portid]     = channel_10g_ready[portid] | channel_1g_ready[portid];
    
    assign channel_reset_reg_n[portid] = channel_reset_n[portid] & master_reset_n;    
    
    if (SHARED_REFCLK_EN == 1) begin
        assign pll_ref_clk_10g_reg[portid] = pll_ref_clk_10g[0];
        assign pll_ref_clk_1g_reg[portid] = pll_ref_clk_1g[0];
        assign cdr_ref_clk_10g_reg[portid] = cdr_ref_clk_10g[0];
        assign cdr_ref_clk_1g_reg[portid] = cdr_ref_clk_1g[0];
        assign xgmii_clk_reg[portid] = xgmii_clk_shared[0];
        assign xgmii_clk_312_5[portid] = xgmii_clk_312_5_shared[0];
    end
    else if (SHARED_REFCLK_EN == 0) begin
        assign pll_ref_clk_10g_reg[portid] = pll_ref_clk_10g[portid];
        assign pll_ref_clk_1g_reg[portid] = pll_ref_clk_1g[portid];
        assign cdr_ref_clk_10g_reg[portid] = cdr_ref_clk_10g[portid];
        assign cdr_ref_clk_1g_reg[portid] = cdr_ref_clk_1g[portid];
        assign xgmii_clk_reg[portid] = xgmii_clk_shared[portid];
        assign xgmii_clk_312_5[portid] = xgmii_clk_312_5_shared[portid];
    end

  //--------------------------
    altera_reset_controller #(
        .NUM_RESET_INPUTS        (1),
        .OUTPUT_RESET_SYNC_EDGES ("deassert"),
        .SYNC_DEPTH              (2)
    ) reset_sync_156_25_clk (
        .reset_in0  (~channel_reset_reg_n[portid]), 
        .clk        (xgmii_clk_reg[portid]),                     
        .reset_out  (datapath_reset_sync[portid]),

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
    ) reset_sync_312_5_clk (
        .reset_in0  (~channel_reset_reg_n[portid]), 
        .clk        (xgmii_clk_312_5[portid]),                     
        .reset_out  (xgmii_clk_312_5_reset_sync[portid]),

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
    ) reset_sync_mm_clk (
        .reset_in0  (~channel_reset_reg_n[portid]),             
        .clk        (mm_clk),                     
        .reset_out  (mm_clk_reset_sync[portid]),

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

    //---------------------------------
    altera_eth_channel_1588 
    #(
                .TSTAMP_FP_WIDTH                    (TSTAMP_FP_WIDTH),
                .DEFAULT_NSEC_PERIOD_10G            (DEFAULT_NSEC_PERIOD_10G),          
                .DEFAULT_FNSEC_PERIOD_10G           (DEFAULT_FNSEC_PERIOD_10G),
                .DEFAULT_NSEC_PERIOD_1G             (DEFAULT_NSEC_PERIOD_1G),           
                .DEFAULT_FNSEC_PERIOD_1G            (DEFAULT_FNSEC_PERIOD_1G),  
                .TOD_SYNC_MODE_10G                  (TOD_SYNC_MODE_10G),                    
                .TOD_SYNC_MODE_1G                   (TOD_SYNC_MODE_1G),                 
                .PPS_PULSE_ASSERT_CYCLE_10G         (PPS_PULSE_ASSERT_CYCLE_10G),   
                .PPS_PULSE_ASSERT_CYCLE_1G          (PPS_PULSE_ASSERT_CYCLE_1G),    
                .MDIO_MDC_CLOCK_DIVISOR             (MDIO_MDC_CLOCK_DIVISOR)    
                
     ) altera_eth_channel_1588_inst ( 
    
          //============================================================================
          // CLK and RESET
          //===============================================================================
                //pll
                .pll_locked                                                 (pll_locked),
    
                .xgmii_clk                                                  (xgmii_clk_reg[portid]),
                .datapath_reset                                             (datapath_reset_sync[portid]),
                .xgmii_clk_312_5                                            (xgmii_clk_312_5[portid]),
                .xgmii_clk_312_5_reset                                      (xgmii_clk_312_5_reset_sync[portid]),
                .mm_clk                                                     (mm_clk),
                .mm_reset                                                   (mm_clk_reset_sync[portid]),
                .calc_clk_1g                                                (calc_clk_1g),
                
                .ref_clk_10g                                                (pll_ref_clk_10g_reg[portid]),
                .ref_clk_1g                                                 (pll_ref_clk_1g_reg[portid]),
                
                .tx_serial_clk_10g                                          (tx_serial_clk_10g[portid/12]),
                .tx_serial_clk_1g                                           (tx_serial_clk_1g[portid/6]),
                .cdr_ref_clk_10g                                            (cdr_ref_clk_10g_reg[portid]),              //for SyncE
                .cdr_ref_clk_1g                                             (cdr_ref_clk_1g_reg[portid]),                                            
                .phy_rx_recovered_clk                                       (rx_recovered_clk[portid]),     

                //=======================================================================================
                //avalon MM interface      
                //===============================================================================
                .csr_address                                                (multi_channel_address[portid]),   
                .csr_waitrequest                                            (multi_channel_waitrequest[portid]),
                .csr_read                                                   (multi_channel_read[portid]),       
                .csr_readdata                                               (multi_channel_readdata[portid]),   
                .csr_write                                                  (multi_channel_write[portid]),      
                .csr_writedata                                              (multi_channel_writedata[portid]),   
              
                //=================================================================================
                // PHY interface
                //===============================================================================
                .phy_usr_seq_reset                                          (mm_clk_reset_sync[portid]),
                
                .phy_tx_serial_data                                         (tx_serial_data[portid]),
                .phy_rx_serial_data                                         (rx_serial_data[portid]),
                
                .phy_led_link                                               (led_link[portid]),
                .phy_led_an                                                 (ethernet_1g_an[portid]), 
                .phy_led_char_err                                           (ethernet_1g_char_err[portid]), 
                .phy_led_disp_err                                           (ethernet_1g_disp_err[portid]), 
                .phy_tx_pcfifo_error_1g                                     (tx_pcfifo_error_1g[portid]), 
                .phy_rx_pcfifo_error_1g                                     (tx_pcfifo_error_1g[portid]), 
                
                .phy_rx_data_ready                                          (rx_data_ready[portid]),
                .phy_rx_syncstatus                                          (rx_syncstatus[portid]),
                .phy_rx_block_lock                                          (rx_10g_block_lock[portid]), 
                .phy_rx_hi_ber                                              (rx_hi_ber[portid]),
                
                
                .phy_en_lcl_rxeq                                            (en_lcl_rxeq[portid]),
                .phy_rxeq_done                                              (1'b1),
                .phy_lcl_rf                                                 (1'b0),
                
                .phy_rx_rlv                                                 (rx_rlv[portid]), 
                .phy_rx_clkslip                                             (1'b0),
                
                // Reset Controller
                
                .xcvr_reset_control_pll_powerdown                           (xcvr_reset_control_pll_powerdown[portid]),
                
                //========================================================================
                // MAC interface 
                //===============================================================================
                .mac_avalon_st_tx_data                                      (avalon_st_tx_data[portid]),                    
                .mac_avalon_st_tx_valid                                     (avalon_st_tx_valid[portid]),         
                .mac_avalon_st_tx_ready                                     (avalon_st_tx_ready[portid]), 
                .mac_avalon_st_tx_error                                     (avalon_st_tx_error[portid]),        
                .mac_avalon_st_tx_startofpacket                             (avalon_st_tx_startofpacket[portid]), 
                .mac_avalon_st_tx_endofpacket                               (avalon_st_tx_endofpacket[portid]),   
                .mac_avalon_st_tx_empty                                     (avalon_st_tx_empty[portid]),         
                
                .mac_avalon_st_rx_data                                      (avalon_st_rx_data[portid]),
                .mac_avalon_st_rx_valid                                     (avalon_st_rx_valid[portid]),
                .mac_avalon_st_rx_ready                                     (avalon_st_rx_ready[portid]),
                .mac_avalon_st_rx_startofpacket                             (avalon_st_rx_startofpacket[portid]),
                .mac_avalon_st_rx_endofpacket                               (avalon_st_rx_endofpacket[portid]),
                .mac_avalon_st_rx_empty                                     (avalon_st_rx_empty[portid]),
                .mac_avalon_st_rx_error                                     (avalon_st_rx_error[portid]),
                
                
                
                .mac_avalon_st_rx_status_valid                              (avalon_st_rx_status_valid[portid]),                                    //export
                .mac_avalon_st_rx_status_data                               (avalon_st_rx_status_data[portid]),                                     //export
                .mac_avalon_st_rx_status_error                              (avalon_st_rx_status_error[portid]),                                    //export
                .mac_avalon_st_tx_status_valid                              (avalon_st_tx_status_valid[portid]),                                    //export
                .mac_avalon_st_tx_status_data                               (avalon_st_tx_status_data[portid]),                                     //export
                .mac_avalon_st_tx_status_error                              (avalon_st_tx_status_error[portid]),                                    //export
                .mac_link_fault_status_xgmii_rx_data                        (link_fault_status_xgmii_rx_data[portid]),                
                .mac_avalon_st_pause_data                                   (avalon_st_pause_data[portid]),                                         //export to higher level
                
                .mdio_mdc                                                   (mdio_mdc[portid]),                        
                .mdio_in                                                    (mdio_in[portid]),                   
                .mdio_out                                                   (mdio_out[portid]),                   
                .mdio_oen                                                   (mdio_oen[portid]),                          
                
                
                .tx_egress_timestamp_request_in_valid                       (tx_egress_timestamp_request_in_valid[portid]),                         //export
                .tx_egress_timestamp_request_in_fingerprint                 (tx_egress_timestamp_request_in_fingerprint[portid]),                   //export
                
                .tx_etstamp_ins_ctrl_in_residence_time_update               (tx_ingress_timestamp_valid[portid]),                                   //export
                .tx_etstamp_ins_ctrl_in_ingress_timestamp_96b               (tx_ingress_timestamp_96b_data[portid]),                                //export
                .tx_etstamp_ins_ctrl_in_ingress_timestamp_64b               (tx_ingress_timestamp_64b_data[portid]),    
                .tx_etstamp_ins_ctrl_in_residence_time_calc_format          (tx_ingress_timestamp_format[portid]),                                  //export
                
                .clock_operation_mode_mode                                  (clock_operation_mode_mode[portid]),                                    //export    
                .pkt_with_crc_mode                                          (pkt_with_crc_mode[portid]),                                            //export
                
                .tx_egress_timestamp_96b_valid                              (tx_egress_timestamp_96b_valid[portid]),                                //export
                .tx_egress_timestamp_96b_data                               (tx_egress_timestamp_96b_data[portid]),                                 //export
                .tx_egress_timestamp_96b_fingerprint                        (tx_egress_timestamp_96b_fingerprint[portid]),                          //export
                .tx_egress_timestamp_64b_valid                              (tx_egress_timestamp_64b_valid[portid]),                                //export
                .tx_egress_timestamp_64b_data                               (tx_egress_timestamp_64b_data[portid]),                                 //export
                .tx_egress_timestamp_64b_fingerprint                        (tx_egress_timestamp_64b_fingerprint[portid]),                          //export
                
                .rx_ingress_timestamp_96b_valid                             (rx_ingress_timestamp_96b_valid[portid]),                               //export    
                .rx_ingress_timestamp_96b_data                              (rx_ingress_timestamp_96b_data[portid]),                                //export    
                .rx_ingress_timestamp_64b_valid                             (rx_ingress_timestamp_64b_valid[portid]),                               //export
                .rx_ingress_timestamp_64b_data                              (rx_ingress_timestamp_64b_data[portid]),                                //export
                
                .master_tod_clk                                             (master_tod_clk),                                                       
                .master_tod_reset                                           (master_tod_reset_sync),
                .master_tod_96b_data                                        (master_tod_96b),
                .master_tod_64b_data                                        (master_tod_64b),
                .start_tod_sync                                             (start_tod_sync[portid]),                                               //export
                
                .tod_sync_10g_sampling_clk                                  (tod_sync_10g_sampling_clk),                                            //derive from pll 2                              
                .tod_sync_1g_sampling_clk                                   (tod_sync_1g_sampling_clk),                                             //derive from pll 2                                 
                
                .pulse_per_second_10g                                       (pulse_per_second_10g[portid]),                                         //export
                .pulse_per_second_1g                                        (pulse_per_second_1g[portid]),                                          //export
                .speed_sel                                                  (speed_sel[portid]),
		.xgmii_clk_reset					    ()
    );  

    
    end //end for

    endgenerate 
        
//=============Master Time of Day ==========================================

    altera_eth_1588_tod_master eth_1588_master_tod_u0 (
        .period_clk                             (master_tod_clk),                                           
        .period_rst_n                           (~master_tod_reset_sync),           
        .clk                                    (mm_clk),
        .rst_n                                  (~master_mm_reset_sync),                            
        .csr_write                              (eth_1588_master_tod_csr_write),                                
        .csr_read                               (eth_1588_master_tod_csr_read),
        .csr_address                            ({1'b0, eth_1588_master_tod_csr_address[5:2]}),
        .csr_writedata                          (eth_1588_master_tod_csr_writedata),
        .csr_readdata                           (eth_1588_master_tod_csr_readdata),
        .csr_waitrequest                        (eth_1588_master_tod_csr_waitrequest),
        .time_of_day_96b                        (master_tod_96b),
        .time_of_day_64b                        (master_tod_64b),
        .time_of_day_96b_load_valid             (1'b0),                        
        .time_of_day_96b_load_data              (96'd0),
        .time_of_day_64b_load_valid             (1'b0),                        
        .time_of_day_64b_load_data              (64'd0)
        );

//============= Master Pulse Per Second ==========================================  

    altera_eth_1588_pps #(
        .PULSE_CYCLE        (PPS_PULSE_ASSERT_CYCLE_1G)
    ) master_pulse_per_second_u0 (
        .clk                                    (master_tod_clk),
        .reset                                  (master_tod_reset_sync),
    
        .time_of_day_96b                        (master_tod_96b),
        .pulse_per_second                       (master_pulse_per_second)
    );

 //============================================================================
 // Address Decoder

 //===============================================================================  
    address_decoder_multi_channel address_decoder_multi_channel_inst (
        .clk_clk                                                (mm_clk),                          
        .reset_reset_n                                          (~master_mm_reset_sync),                   


        .master_channel_avalon_anti_master_0_waitrequest        (waitrequest),   
        .master_channel_avalon_anti_master_0_readdata           (readdata),     
        .master_channel_avalon_anti_master_0_writedata          (writedata),    
        .master_channel_avalon_anti_master_0_address            (address),     
        .master_channel_avalon_anti_master_0_write              (write),          
        .master_channel_avalon_anti_master_0_read               (read),  

        .eth_1588_master_tod_avalon_anti_slave_0_waitrequest    (eth_1588_master_tod_csr_waitrequest),      
        .eth_1588_master_tod_avalon_anti_slave_0_readdata       (eth_1588_master_tod_csr_readdata),         
        .eth_1588_master_tod_avalon_anti_slave_0_writedata      (eth_1588_master_tod_csr_writedata),        
        .eth_1588_master_tod_avalon_anti_slave_0_address        (eth_1588_master_tod_csr_address),         
        .eth_1588_master_tod_avalon_anti_slave_0_write          (eth_1588_master_tod_csr_write),           
        .eth_1588_master_tod_avalon_anti_slave_0_read           (eth_1588_master_tod_csr_read),
        

        .channel_0_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[0]),       
        .channel_0_avalon_anti_slave_0_readdata                 (multi_channel_readdata[0]),         
        .channel_0_avalon_anti_slave_0_writedata                (multi_channel_writedata[0]),        
        .channel_0_avalon_anti_slave_0_address                  (multi_channel_address[0]),           
        .channel_0_avalon_anti_slave_0_write                    (multi_channel_write[0]),            
        .channel_0_avalon_anti_slave_0_read                     (multi_channel_read[0]),              

        .channel_1_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[1]),       
        .channel_1_avalon_anti_slave_0_readdata                 (multi_channel_readdata[1]),         
        .channel_1_avalon_anti_slave_0_writedata                (multi_channel_writedata[1]),         
        .channel_1_avalon_anti_slave_0_address                  (multi_channel_address[1]),            
        .channel_1_avalon_anti_slave_0_write                    (multi_channel_write[1]),              
        .channel_1_avalon_anti_slave_0_read                     (multi_channel_read[1]),             



        .channel_2_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[2]),       
        .channel_2_avalon_anti_slave_0_readdata                 (multi_channel_readdata[2]),          
        .channel_2_avalon_anti_slave_0_writedata                (multi_channel_writedata[2]),         
        .channel_2_avalon_anti_slave_0_address                  (multi_channel_address[2]),          
        .channel_2_avalon_anti_slave_0_write                    (multi_channel_write[2]),             
        .channel_2_avalon_anti_slave_0_read                     (multi_channel_read[2]),              


        .channel_3_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[3]),       
        .channel_3_avalon_anti_slave_0_readdata                 (multi_channel_readdata[3]),          
        .channel_3_avalon_anti_slave_0_writedata                (multi_channel_writedata[3]),         
        .channel_3_avalon_anti_slave_0_address                  (multi_channel_address[3]),           
        .channel_3_avalon_anti_slave_0_write                    (multi_channel_write[3]),             
        .channel_3_avalon_anti_slave_0_read                     (multi_channel_read[3]),
        

        .channel_4_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[4]),       
        .channel_4_avalon_anti_slave_0_readdata                 (multi_channel_readdata[4]),         
        .channel_4_avalon_anti_slave_0_writedata                (multi_channel_writedata[4]),        
        .channel_4_avalon_anti_slave_0_address                  (multi_channel_address[4]),           
        .channel_4_avalon_anti_slave_0_write                    (multi_channel_write[4]),            
        .channel_4_avalon_anti_slave_0_read                     (multi_channel_read[4]),              

        .channel_5_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[5]),       
        .channel_5_avalon_anti_slave_0_readdata                 (multi_channel_readdata[5]),         
        .channel_5_avalon_anti_slave_0_writedata                (multi_channel_writedata[5]),         
        .channel_5_avalon_anti_slave_0_address                  (multi_channel_address[5]),            
        .channel_5_avalon_anti_slave_0_write                    (multi_channel_write[5]),              
        .channel_5_avalon_anti_slave_0_read                     (multi_channel_read[5]),               



        .channel_6_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[6]),       
        .channel_6_avalon_anti_slave_0_readdata                 (multi_channel_readdata[6]),          
        .channel_6_avalon_anti_slave_0_writedata                (multi_channel_writedata[6]),         
        .channel_6_avalon_anti_slave_0_address                  (multi_channel_address[6]),          
        .channel_6_avalon_anti_slave_0_write                    (multi_channel_write[6]),             
        .channel_6_avalon_anti_slave_0_read                     (multi_channel_read[6]),              


        .channel_7_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[7]),       
        .channel_7_avalon_anti_slave_0_readdata                 (multi_channel_readdata[7]),          
        .channel_7_avalon_anti_slave_0_writedata                (multi_channel_writedata[7]),         
        .channel_7_avalon_anti_slave_0_address                  (multi_channel_address[7]),           
        .channel_7_avalon_anti_slave_0_write                    (multi_channel_write[7]),             
        .channel_7_avalon_anti_slave_0_read                     (multi_channel_read[7]),
        
        
        .channel_8_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[8]),       
        .channel_8_avalon_anti_slave_0_readdata                 (multi_channel_readdata[8]),         
        .channel_8_avalon_anti_slave_0_writedata                (multi_channel_writedata[8]),        
        .channel_8_avalon_anti_slave_0_address                  (multi_channel_address[8]),           
        .channel_8_avalon_anti_slave_0_write                    (multi_channel_write[8]),            
        .channel_8_avalon_anti_slave_0_read                     (multi_channel_read[8]),              

        .channel_9_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[9]),       
        .channel_9_avalon_anti_slave_0_readdata                 (multi_channel_readdata[9]),         
        .channel_9_avalon_anti_slave_0_writedata                (multi_channel_writedata[9]),         
        .channel_9_avalon_anti_slave_0_address                  (multi_channel_address[9]),            
        .channel_9_avalon_anti_slave_0_write                    (multi_channel_write[9]),              
        .channel_9_avalon_anti_slave_0_read                     (multi_channel_read[9]),              

        .channel_10_avalon_anti_slave_0_waitrequest             (multi_channel_waitrequest[10]),       
        .channel_10_avalon_anti_slave_0_readdata                (multi_channel_readdata[10]),         
        .channel_10_avalon_anti_slave_0_writedata               (multi_channel_writedata[10]),         
        .channel_10_avalon_anti_slave_0_address                 (multi_channel_address[10]),            
        .channel_10_avalon_anti_slave_0_write                   (multi_channel_write[10]),              
        .channel_10_avalon_anti_slave_0_read                    (multi_channel_read[10]),              

        .channel_11_avalon_anti_slave_0_waitrequest             (multi_channel_waitrequest[11]),       
        .channel_11_avalon_anti_slave_0_readdata                (multi_channel_readdata[11]),         
        .channel_11_avalon_anti_slave_0_writedata               (multi_channel_writedata[11]),         
        .channel_11_avalon_anti_slave_0_address                 (multi_channel_address[11]),            
        .channel_11_avalon_anti_slave_0_write                   (multi_channel_write[11]),              
        .channel_11_avalon_anti_slave_0_read                    (multi_channel_read[11])              
    
    );
    
endmodule         
        
