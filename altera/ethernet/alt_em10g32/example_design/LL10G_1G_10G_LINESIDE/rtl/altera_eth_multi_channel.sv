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



// $Revision: #1 
// $Date: 07/05/2013
// $Author: IP APPs
module altera_eth_multi_channel(

        mm_clk,
        
        pll_ref_clk_1g,  // for tx
        pll_ref_clk_10g,  //
        
        cdr_ref_clk_1g,   //for rx
        cdr_ref_clk_10g,                    
        
        master_reset_n,
        channel_reset_n,
        xgmii_clk,

        dc_fifo_tx_clk,
        dc_fifo_rx_clk,
        
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
        mdio_oen

);


    parameter   NUM_CHANNELS = 12;                  // range from 1-12
    parameter   SV_RCN_BUNDLE_MODE = 1;          // mode0-10GBaseKR, mode1-1G10G without 1588, mode2 -1G10G with 1588  
    parameter   MDIO_MDC_CLOCK_DIVISOR  = 32;       //MDIO
    parameter   SHARED_REFCLK_EN  = 1;              //share ref clock for all channel  1- enable sharing, 0- disable sharing
    parameter   FIFO_OPTIONS = 1;              // 0 - disable, 1-SC FIFO, 2-DC FIFO, 3- SC+DC FIFO
    
    localparam MAX_NUM_CHANNELS = 12;
    localparam NUM_UNSHARED_CHANNELS = (SHARED_REFCLK_EN == 1) ? 1:NUM_CHANNELS;
    
        input       wire                                            mm_clk;
        
        input       wire        [NUM_UNSHARED_CHANNELS-1:0]         pll_ref_clk_1g;  // for syncE
        input       wire        [NUM_UNSHARED_CHANNELS-1:0]         pll_ref_clk_10g;  //share same pll_ref_clk
        
        input       wire        [NUM_UNSHARED_CHANNELS-1:0]         cdr_ref_clk_1g;   //for SyncE
        input       wire        [NUM_UNSHARED_CHANNELS-1:0]         cdr_ref_clk_10g;                    
        
        input       wire                                            dc_fifo_tx_clk;
        input       wire                                            dc_fifo_rx_clk;


        input       wire        [NUM_CHANNELS-1:0]                  channel_reset_n;
        input       wire                                            master_reset_n;
        output      wire        [NUM_UNSHARED_CHANNELS-1:0]         xgmii_clk;

        input       wire                                            write;              
        input       wire                                            read;           
        input       wire        [19:0]                              address;            
        input       wire        [31:0]                              writedata;          
        output      wire        [31:0]                              readdata;           
        output      wire                                            waitrequest;           
                     
        output      wire        [NUM_CHANNELS-1:0]                  rx_recovered_clk;
                     
        input       wire        [NUM_CHANNELS-1:0]                  avalon_st_tx_startofpacket;
        input       wire        [NUM_CHANNELS-1:0]                  avalon_st_tx_endofpacket;
        input       wire        [NUM_CHANNELS-1:0]                  avalon_st_tx_valid;
        output      wire        [NUM_CHANNELS-1:0]                  avalon_st_tx_ready;
        input       wire        [NUM_CHANNELS-1:0][63:0]            avalon_st_tx_data;
        input       wire        [NUM_CHANNELS-1:0][2:0]             avalon_st_tx_empty;
        input       wire        [NUM_CHANNELS-1:0]                  avalon_st_tx_error;
                  
        output      wire        [NUM_CHANNELS-1:0]                  avalon_st_rx_startofpacket;
        output      wire        [NUM_CHANNELS-1:0]                  avalon_st_rx_endofpacket;
        output      wire        [NUM_CHANNELS-1:0]                  avalon_st_rx_valid;
        input       wire        [NUM_CHANNELS-1:0]                  avalon_st_rx_ready;
        output      wire        [NUM_CHANNELS-1:0][63:0]            avalon_st_rx_data;
        output      wire        [NUM_CHANNELS-1:0][2:0]             avalon_st_rx_empty;
        output      wire        [NUM_CHANNELS-1:0][5:0]             avalon_st_rx_error;

        output      wire        [NUM_CHANNELS-1:0]                  avalon_st_tx_status_valid;                      
        output      wire        [NUM_CHANNELS-1:0][39:0]            avalon_st_tx_status_data;                       
        output      wire        [NUM_CHANNELS-1:0][6:0]             avalon_st_tx_status_error;                          
        output      wire        [NUM_CHANNELS-1:0]                  avalon_st_rx_status_valid;                       
        output      wire        [NUM_CHANNELS-1:0][39:0]            avalon_st_rx_status_data;                        
        output      wire        [NUM_CHANNELS-1:0][6:0]             avalon_st_rx_status_error; 

        input       wire        [NUM_CHANNELS-1:0][1:0]             avalon_st_pause_data;

        input       wire        [NUM_CHANNELS-1:0]                  rx_serial_data;
        output      wire        [NUM_CHANNELS-1:0]                  tx_serial_data;

        output      wire        [NUM_CHANNELS-1:0]                  channel_ready;
        output      wire        [NUM_CHANNELS-1:0]                  ethernet_1g_an;
        output      wire        [NUM_CHANNELS-1:0]                  ethernet_1g_char_err;
        output      wire        [NUM_CHANNELS-1:0]                  ethernet_1g_disp_err; 
        
        output      wire        [NUM_CHANNELS-1:0]                  mdio_mdc;                            
        input       wire        [NUM_CHANNELS-1:0]                  mdio_in;                    
        output      wire        [NUM_CHANNELS-1:0]                  mdio_out;                  
        output      wire        [NUM_CHANNELS-1:0]                  mdio_oen; 


    wire        [NUM_CHANNELS-1:0]          xgmii_clk_312_5;
    wire        [NUM_CHANNELS-1:0]          pll_ref_clk_1g_reg;  // for syncE
    wire        [NUM_CHANNELS-1:0]          pll_ref_clk_10g_reg;  //share same pll_ref_clk
    wire        [NUM_CHANNELS-1:0]          cdr_ref_clk_1g_reg;   //for SyncE
    wire        [NUM_CHANNELS-1:0]          cdr_ref_clk_10g_reg;                    
    wire        [NUM_CHANNELS-1:0]          xgmii_clk_reg;  
        
    wire        [NUM_CHANNELS-1:0]          xgmii_clk_312_5_reset_sync;
        
    wire                                    calc_clk_1g;     // sampling clock for GIGE PCS latency measurement
    wire        [NUM_CHANNELS-1:0]          datapath_reset_sync;
    wire        [NUM_CHANNELS-1:0]          mm_clk_reset_sync;   
     
    wire                                    pll_locked;
    wire        [NUM_UNSHARED_CHANNELS-1:0]          pll_1_locked;
    wire        [((NUM_CHANNELS-1)/12):0]    pll_locked_10g;
    wire        [((NUM_CHANNELS-1)/6):0]    pll_locked_1g;
     
    wire        [NUM_CHANNELS-1:0]                  led_link;
    wire        [NUM_CHANNELS-1:0][0:0]             rx_data_ready;
    wire        [NUM_CHANNELS-1:0]                  channel_1g_ready;  
    wire        [NUM_CHANNELS-1:0]                  channel_10g_ready; 
    wire        [NUM_CHANNELS-1:0][1:0]             link_fault_status_xgmii_rx_data;     
   
    wire        [MAX_NUM_CHANNELS-1:0]              multi_channel_write;            
    wire        [MAX_NUM_CHANNELS-1:0]              multi_channel_read;             
    wire        [MAX_NUM_CHANNELS-1:0][15:0]        multi_channel_address;            
    wire        [MAX_NUM_CHANNELS-1:0][31:0]        multi_channel_writedata;            
    wire        [MAX_NUM_CHANNELS-1:0][31:0]        multi_channel_readdata;         
    wire        [MAX_NUM_CHANNELS-1:0]              multi_channel_readdata_valid;   
    wire        [MAX_NUM_CHANNELS-1:0]              multi_channel_waitrequest;          
 
    wire     [NUM_CHANNELS-1:0]                             rx_hi_ber;
    wire     [NUM_CHANNELS-1:0]                             rx_syncstatus;
    wire     [NUM_CHANNELS-1:0]                             rx_10g_block_lock;   
    wire     [NUM_CHANNELS-1:0]                             rx_rlv;                               
    wire     [NUM_CHANNELS-1:0]                             rx_pcfifo_error_1g;                   
    wire     [NUM_CHANNELS-1:0]                             tx_pcfifo_error_1g;                   
    wire     [NUM_CHANNELS-1:0][3:0]                        tm_out_trigger;
     
   
    wire     [NUM_CHANNELS-1:0]                             xcvr_reset_control_pll_powerdown;
    wire     [NUM_CHANNELS-1:0]                             pll_powerdown;
    wire     [NUM_CHANNELS-1 :0]                            channel_reset_reg_n;    

    wire     [((NUM_CHANNELS-1)/12):0]                      tx_serial_clk_10g;
    wire     [((NUM_CHANNELS-1)/6):0]                       tx_serial_clk_1g;

    wire     [NUM_UNSHARED_CHANNELS-1:0]                    xgmii_clk_shared;
    wire     [NUM_UNSHARED_CHANNELS-1:0]                    xgmii_clk_312_5_shared;
     
    assign pll_locked = (&pll_1_locked) & (&pll_locked_10g) & (&pll_locked_1g);
    
    
    //=========== Reset Sync=====================================
    
    

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

//=============NF 1g PLL====================================================
    nf_xcvr_1g_pll  oneg_pll_inst (
        .pll_powerdown      (pll_powerdown[phypllid]),
        .pll_refclk0        (pll_ref_clk_1g_reg[0]),
        .tx_serial_clk      (tx_serial_clk_1g[phypllid]),
        .pll_locked         (pll_locked_1g[phypllid]),
	.mcgb_rst	    (),
	.mcgb_serial_clk    (),
	.pll_cal_busy	    ()
    );  
    
    end //end for
endgenerate

genvar fpllid;
generate
    for (fpllid = 0; fpllid < NUM_UNSHARED_CHANNELS; fpllid = fpllid+1)
    begin: FPLL
        pll pll_inst (
            .refclk    (pll_ref_clk_10g[0]), 
            .rst  (~master_reset_n),    
            .outclk_0        (xgmii_clk_shared[fpllid]),      
            .outclk_1        (xgmii_clk_312_5_shared[fpllid]),       
            .locked     (pll_1_locked[fpllid])
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
        .NUM_RESET_INPUTS        (2),
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

    
    altera_eth_channel #(
      
      .MDIO_MDC_CLOCK_DIVISOR           (MDIO_MDC_CLOCK_DIVISOR),
      .FIFO_OPTIONS                     (FIFO_OPTIONS) 
                
    ) altera_eth_channel_inst ( 
    
          //============================================================================
          // CLK and RESET
          //===============================================================================
                //pll
              .pll_locked                               (pll_locked),
    
              .xgmii_clk                                (xgmii_clk_reg[portid]),
              .xgmii_clk_312_5                          (xgmii_clk_312_5[portid]),
              .xgmii_clk_312_5_reset                    (xgmii_clk_312_5_reset_sync[portid]),
              .datapath_reset                          (datapath_reset_sync[portid]),
              .mm_clk                                    (mm_clk),
              .mm_reset                                     (mm_clk_reset_sync[portid]),

    
              .pll_ref_clk_10g                                  (pll_ref_clk_10g_reg[portid]),
              .pll_ref_clk_1g                                   (pll_ref_clk_1g_reg[portid]),
        
              .tx_serial_clk_10g                                (tx_serial_clk_10g[portid/12]),
              .tx_serial_clk_1g                                 (tx_serial_clk_1g[portid/6]),
              .cdr_ref_clk_10g                                  (cdr_ref_clk_10g_reg[portid]),            //for SyncE
              .cdr_ref_clk_1g                                       (cdr_ref_clk_1g_reg[portid]),                                            
              .phy_rx_recovered_clk                             (rx_recovered_clk[portid]),

              .dc_fifo_tx_clk                                       (dc_fifo_tx_clk),
           .dc_fifo_rx_clk                                  (dc_fifo_rx_clk),
              //.dc_fifo_tx_clk_reset                               (dc_fifo_tx_clk_reset),
           //.dc_fifo_rx_clk_reset                          (dc_fifo_rx_clk_reset),
              
              
              //=======================================================================================
              //avalon MM interface      
              //===============================================================================
              .csr_address                                          (multi_channel_address[portid]),   
              .csr_waitrequest                                 (multi_channel_waitrequest[portid]),
              .csr_read                                         (multi_channel_read[portid]),       
              .csr_readdata                                     (multi_channel_readdata[portid]),   
              .csr_write                                        (multi_channel_write[portid]),      
              .csr_writedata                                    (multi_channel_writedata[portid]),   
    
      
              
              //=================================================================================
              // PHY interface
              //===============================================================================
               .phy_usr_seq_reset                   (mm_clk_reset_sync[portid]),

               .phy_tx_serial_data                  (tx_serial_data[portid]),
               .phy_rx_serial_data                  (rx_serial_data[portid]),

               .phy_led_link                        (led_link[portid]),
               .phy_led_an                          (ethernet_1g_an[portid]), 
               .phy_led_char_err                    (ethernet_1g_char_err[portid]), 
               .phy_led_disp_err                    (ethernet_1g_disp_err[portid]), 
               .phy_tx_pcfifo_error_1g              (), 
               .phy_rx_pcfifo_error_1g              (), 
             
               .phy_rx_data_ready                   (rx_data_ready[portid]),
              
               .phy_tm_in_trigger                   (4'd0),
               .phy_tm_out_trigger                  (), 
      
               .phy_rx_syncstatus                   (rx_syncstatus[portid]),
               .phy_rx_block_lock                   (rx_10g_block_lock[portid]), 
               .phy_rx_hi_ber                       (rx_hi_ber[portid]),
              
     
               .phy_en_lcl_rxeq                     (),
               .phy_rxeq_done                       (1'b1),
               .phy_lcl_rf                          (1'b0),
              
               .phy_rx_rlv                          (), 
               .phy_rx_clkslip                      (1'b0),
                // Reset Controller

                .xcvr_reset_control_pll_powerdown   (xcvr_reset_control_pll_powerdown[portid]),
                
              //========================================================================
              // MAC interface 
              //===============================================================================
               .mac_avalon_st_tx_data                               (avalon_st_tx_data[portid]),                    
               .mac_avalon_st_tx_valid                              (avalon_st_tx_valid[portid]),         
               .mac_avalon_st_tx_ready                              (avalon_st_tx_ready[portid]), 
               .mac_avalon_st_tx_error                                 (avalon_st_tx_error[portid]),        
               .mac_avalon_st_tx_startofpacket                      (avalon_st_tx_startofpacket[portid]), 
               .mac_avalon_st_tx_endofpacket                        (avalon_st_tx_endofpacket[portid]),   
               .mac_avalon_st_tx_empty                              (avalon_st_tx_empty[portid]),         
    
               .mac_avalon_st_rx_data                               (avalon_st_rx_data[portid]),
               .mac_avalon_st_rx_valid                              (avalon_st_rx_valid[portid]),
               .mac_avalon_st_rx_ready                              (avalon_st_rx_ready[portid]),
               .mac_avalon_st_rx_startofpacket                      (avalon_st_rx_startofpacket[portid]),
               .mac_avalon_st_rx_endofpacket                        (avalon_st_rx_endofpacket[portid]),
               .mac_avalon_st_rx_empty                              (avalon_st_rx_empty[portid]),
               .mac_avalon_st_rx_error                              (avalon_st_rx_error[portid]),
 
                   
                .mac_avalon_st_rxstatus_valid       (avalon_st_rx_status_valid[portid]),                                             //export
               .mac_avalon_st_rxstatus_data         (avalon_st_rx_status_data[portid]),                                                  //export
               .mac_avalon_st_rxstatus_error        (avalon_st_rx_status_error[portid]),                                                 //export
               .mac_avalon_st_txstatus_valid        (avalon_st_tx_status_valid[portid]),                                   //export
               .mac_avalon_st_txstatus_data         (avalon_st_tx_status_data[portid]),                                    //export
               .mac_avalon_st_txstatus_error        (avalon_st_tx_status_error[portid]),                                   //export
               .mac_link_fault_status_xgmii_rx_data (link_fault_status_xgmii_rx_data[portid]),                
                .mac_avalon_st_pause_data                   (2'b00),
                
                .mdio_mdc                                           (mdio_mdc[portid]),                        
                .mdio_in                                                (mdio_in[portid]),                   
                .mdio_out                                           (mdio_out[portid]),                   
                .mdio_oen                                           (mdio_oen[portid]),
               
                .phy_tap_to_upd			    () 
                                                //export
              );
    
          end
      endgenerate   

//============================================================================
 // Address Decoder

 //===============================================================================  
    address_decoder_multi_channel address_decoder_multi_channel_inst (
        .clk_clk                                                                (mm_clk),                          
        .reset_reset_n                                                      (~master_mm_reset_sync),                   


        .master_channel_avalon_anti_master_0_waitrequest        (waitrequest),   
        .master_channel_avalon_anti_master_0_readdata           (readdata),     
        .master_channel_avalon_anti_master_0_writedata          (writedata),    
        .master_channel_avalon_anti_master_0_address                (address),     
        .master_channel_avalon_anti_master_0_write              (write),          
        .master_channel_avalon_anti_master_0_read                   (read),  

        .channel_0_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[0]),       
        .channel_0_avalon_anti_slave_0_readdata                 (multi_channel_readdata[0]),         
        .channel_0_avalon_anti_slave_0_writedata                    (multi_channel_writedata[0]),        
        .channel_0_avalon_anti_slave_0_address                      (multi_channel_address[0]),           
        .channel_0_avalon_anti_slave_0_write                        (multi_channel_write[0]),            
        .channel_0_avalon_anti_slave_0_read                         (multi_channel_read[0]),              

        .channel_1_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[1]),       
        .channel_1_avalon_anti_slave_0_readdata                 (multi_channel_readdata[1]),         
        .channel_1_avalon_anti_slave_0_writedata                    (multi_channel_writedata[1]),         
        .channel_1_avalon_anti_slave_0_address                      (multi_channel_address[1]),            
        .channel_1_avalon_anti_slave_0_write                        (multi_channel_write[1]),              
        .channel_1_avalon_anti_slave_0_read                         (multi_channel_read[1]),             



        .channel_2_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[2]),       
        .channel_2_avalon_anti_slave_0_readdata                 (multi_channel_readdata[2]),          
        .channel_2_avalon_anti_slave_0_writedata                    (multi_channel_writedata[2]),         
        .channel_2_avalon_anti_slave_0_address                      (multi_channel_address[2]),          
        .channel_2_avalon_anti_slave_0_write                        (multi_channel_write[2]),             
        .channel_2_avalon_anti_slave_0_read                         (multi_channel_read[2]),              


        .channel_3_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[3]),       
        .channel_3_avalon_anti_slave_0_readdata                 (multi_channel_readdata[3]),          
        .channel_3_avalon_anti_slave_0_writedata                    (multi_channel_writedata[3]),         
        .channel_3_avalon_anti_slave_0_address                      (multi_channel_address[3]),           
        .channel_3_avalon_anti_slave_0_write                        (multi_channel_write[3]),             
        .channel_3_avalon_anti_slave_0_read                         (multi_channel_read[3]),
        

        .channel_4_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[4]),       
        .channel_4_avalon_anti_slave_0_readdata                 (multi_channel_readdata[4]),         
        .channel_4_avalon_anti_slave_0_writedata                    (multi_channel_writedata[4]),        
        .channel_4_avalon_anti_slave_0_address                      (multi_channel_address[4]),           
        .channel_4_avalon_anti_slave_0_write                        (multi_channel_write[4]),            
        .channel_4_avalon_anti_slave_0_read                         (multi_channel_read[4]),              

        .channel_5_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[5]),       
        .channel_5_avalon_anti_slave_0_readdata                 (multi_channel_readdata[5]),         
        .channel_5_avalon_anti_slave_0_writedata                    (multi_channel_writedata[5]),         
        .channel_5_avalon_anti_slave_0_address                      (multi_channel_address[5]),            
        .channel_5_avalon_anti_slave_0_write                        (multi_channel_write[5]),              
        .channel_5_avalon_anti_slave_0_read                         (multi_channel_read[5]),               



        .channel_6_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[6]),       
        .channel_6_avalon_anti_slave_0_readdata                 (multi_channel_readdata[6]),          
        .channel_6_avalon_anti_slave_0_writedata                    (multi_channel_writedata[6]),         
        .channel_6_avalon_anti_slave_0_address                      (multi_channel_address[6]),          
        .channel_6_avalon_anti_slave_0_write                        (multi_channel_write[6]),             
        .channel_6_avalon_anti_slave_0_read                         (multi_channel_read[6]),              


        .channel_7_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[7]),       
        .channel_7_avalon_anti_slave_0_readdata                 (multi_channel_readdata[7]),          
        .channel_7_avalon_anti_slave_0_writedata                    (multi_channel_writedata[7]),         
        .channel_7_avalon_anti_slave_0_address                      (multi_channel_address[7]),           
        .channel_7_avalon_anti_slave_0_write                        (multi_channel_write[7]),             
        .channel_7_avalon_anti_slave_0_read                         (multi_channel_read[7]),
        
        
        .channel_8_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[8]),       
        .channel_8_avalon_anti_slave_0_readdata                 (multi_channel_readdata[8]),         
        .channel_8_avalon_anti_slave_0_writedata                    (multi_channel_writedata[8]),        
        .channel_8_avalon_anti_slave_0_address                      (multi_channel_address[8]),           
        .channel_8_avalon_anti_slave_0_write                        (multi_channel_write[8]),            
        .channel_8_avalon_anti_slave_0_read                         (multi_channel_read[8]),              

        .channel_9_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[9]),       
        .channel_9_avalon_anti_slave_0_readdata                 (multi_channel_readdata[9]),         
        .channel_9_avalon_anti_slave_0_writedata                    (multi_channel_writedata[9]),         
        .channel_9_avalon_anti_slave_0_address                      (multi_channel_address[9]),            
        .channel_9_avalon_anti_slave_0_write                        (multi_channel_write[9]),              
        .channel_9_avalon_anti_slave_0_read                         (multi_channel_read[9]),             

        .channel_10_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[10]),       
        .channel_10_avalon_anti_slave_0_readdata                 (multi_channel_readdata[10]),         
        .channel_10_avalon_anti_slave_0_writedata                    (multi_channel_writedata[10]),         
        .channel_10_avalon_anti_slave_0_address                      (multi_channel_address[10]),            
        .channel_10_avalon_anti_slave_0_write                        (multi_channel_write[10]),              
        .channel_10_avalon_anti_slave_0_read                         (multi_channel_read[10]),              

        .channel_11_avalon_anti_slave_0_waitrequest              (multi_channel_waitrequest[11]),       
        .channel_11_avalon_anti_slave_0_readdata                 (multi_channel_readdata[11]),         
        .channel_11_avalon_anti_slave_0_writedata                    (multi_channel_writedata[11]),         
        .channel_11_avalon_anti_slave_0_address                      (multi_channel_address[11]),            
        .channel_11_avalon_anti_slave_0_write                        (multi_channel_write[11]),              
        .channel_11_avalon_anti_slave_0_read                         (multi_channel_read[11])              

    );

    
 endmodule     
        
