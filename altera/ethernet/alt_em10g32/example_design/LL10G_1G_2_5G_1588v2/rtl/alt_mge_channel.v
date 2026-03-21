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


// (C) 2001-2015 Altera Corporation. All rights reserved.
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

`timescale 1 ps / 1 ps

module alt_mge_channel (
    
    // CSR Clock
    input               csr_clk,
    
    // MAC User Clock
    input               mac_clk,
    
    // Latency Measurement Clock
    input               latency_measure_clk,
    
    // Sampling Clock
    input               tod_sync_2p5g_sampling_clk,
    input               tod_sync_1g_sampling_clk,
    
    // Reset
    input               reset,
    input               tx_digitalreset,
    input               rx_digitalreset,
    input               tx_analogreset,
    input               rx_analogreset,
    
    // MAC CSR
    input       [9:0]   csr_mac_address,
    input               csr_mac_read,
    input               csr_mac_write,
    input       [31:0]  csr_mac_writedata,
    output      [31:0]  csr_mac_readdata,
    output              csr_mac_waitrequest,
    
    // MAC TX User Frame
    input               avalon_st_tx_valid,
    output              avalon_st_tx_ready,
    input               avalon_st_tx_startofpacket,
    input               avalon_st_tx_endofpacket,
    input       [31:0]  avalon_st_tx_data,
    input       [1:0]   avalon_st_tx_empty,
    input               avalon_st_tx_error,
    
    // MAC RX User Frame
    output              avalon_st_rx_valid,
    input               avalon_st_rx_ready,
    output              avalon_st_rx_startofpacket,
    output              avalon_st_rx_endofpacket,
    output      [31:0]  avalon_st_rx_data,
    output       [1:0]  avalon_st_rx_empty,
    output       [5:0]  avalon_st_rx_error,
    
    // MAC TX Frame Status
    output              avalon_st_txstatus_valid,
    output      [39:0]  avalon_st_txstatus_data,
    output       [6:0]  avalon_st_txstatus_error,
    
    // MAC RX Frame Status
    output              avalon_st_rxstatus_valid,
    output      [39:0]  avalon_st_rxstatus_data,
    output       [6:0]  avalon_st_rxstatus_error,
    
    // MAC TX Pause Frame Generation Command
    input        [1:0]  avalon_st_pause_data,
    
    // PHY CSR
    input        [4:0]  csr_phy_address,
    input               csr_phy_read,
    input               csr_phy_write,
    input       [15:0]  csr_phy_writedata,
    output      [15:0]  csr_phy_readdata,
    output              csr_phy_waitrequest,
    
    // PHY Operating Mode from Reconfig Block
    input        [1:0]  xcvr_mode,
    
    // PHY Status
    output              led_link,
    output              led_char_err,
    output              led_disp_err,
    output              led_an,
    
    // Transceiver Serial Interface
    input        [1:0]  tx_serial_clk,
    input               rx_cdr_refclk,
    output              rx_pma_clkout,
    output              tx_serial_data,
    input               rx_serial_data,
    
    // Transceiver Status
    output              rx_is_lockedtodata,
    output              tx_cal_busy,
    output              rx_cal_busy,
    
    // Transceiver Reconfiguration
    input               reconfig_clk,
    input               reconfig_reset,
    input        [9:0]  reconfig_address,
    input               reconfig_read,
    input               reconfig_write,
    input       [31:0]  reconfig_writedata,
    output      [31:0]  reconfig_readdata,
    output              reconfig_waitrequest,
    
    //1588
    input               tx_egress_timestamp_request_in_valid,
    input        [3:0]  tx_egress_timestamp_request_in_fingerprint,

    input               tx_etstamp_ins_ctrl_in_residence_time_update,
    input       [95:0]  tx_etstamp_ins_ctrl_in_ingress_timestamp_96b,
    input       [63:0]  tx_etstamp_ins_ctrl_in_ingress_timestamp_64b,
    input               tx_etstamp_ins_ctrl_in_residence_time_calc_format,

    input        [1:0]  clock_operation_mode_mode,
    input               pkt_with_crc_mode,

    output              tx_egress_timestamp_96b_valid,
    output      [95:0]  tx_egress_timestamp_96b_data,          
    output       [3:0]  tx_egress_timestamp_96b_fingerprint,
    output              tx_egress_timestamp_64b_valid,
    output      [63:0]  tx_egress_timestamp_64b_data,
    output       [3:0]  tx_egress_timestamp_64b_fingerprint,

    output              rx_ingress_timestamp_96b_valid,
    output      [95:0]  rx_ingress_timestamp_96b_data,
    output              rx_ingress_timestamp_64b_valid,
    output      [63:0]  rx_ingress_timestamp_64b_data,

    input               master_tod_clk,
    input               master_tod_reset,
    input       [95:0]  master_tod_96b_data,
    input       [63:0]  master_tod_64b_data,
    input               start_tod_sync,

    output              pulse_per_second
    
);
    localparam PPS_PULSE_ASSERT_CYCLE_2p5G = 1562500;   //Pulse Per Second for 2p5g - Assert for 10ms (10ms / 6.4ns = 1562500)
    localparam PPS_PULSE_ASSERT_CYCLE_1G = 625000;      //Pulse Per Second for 1G - Assert for 10ms (10ms / 16.0ns = 625000)    
                    
    // GMII Clock from PHY to MAC
    wire        gmii16b_tx_clk;
    wire        gmii16b_rx_clk;
    
    // GMII TX from MAC to PHY
    wire  [1:0] gmii16b_tx_en;
    wire [15:0] gmii16b_tx_d;
    wire  [1:0] gmii16b_tx_err;
    
    // GMII RX from PHY to MAC
    wire  [1:0] gmii16b_rx_dv;
    wire [15:0] gmii16b_rx_d;
    wire  [1:0] gmii16b_rx_err;
    
    // PHY Operating Speed to MAC
    wire  [2:0] operating_speed;
    
    // Reset
    wire        reset_gmii16b_tx_clk;
    wire        reset_csr_clk;
    wire        mac_reset;
    
    // TOD CSR
    wire        alt_mge_1588_tod_2p5g_csr_waitrequest;
    wire [31:0] alt_mge_1588_tod_2p5g_csr_writedata;
    wire [5:0]  alt_mge_1588_tod_2p5g_csr_address;
    wire        alt_mge_1588_tod_2p5g_csr_write;
    wire        alt_mge_1588_tod_2p5g_csr_read;
    wire [31:0] alt_mge_1588_tod_2p5g_csr_readdata;

    wire        alt_mge_1588_tod_1g_csr_waitrequest;
    wire [31:0] alt_mge_1588_tod_1g_csr_writedata;
    wire [5:0]  alt_mge_1588_tod_1g_csr_address;
    wire        alt_mge_1588_tod_1g_csr_write;
    wire        alt_mge_1588_tod_1g_csr_read;
    wire [31:0] alt_mge_1588_tod_1g_csr_readdata;

    // Packet Classifier
    wire        tx_pkt_class_out_endofpacket;
    wire        tx_pkt_class_out_valid;
    wire        tx_pkt_class_out_startofpacket;
    wire        tx_pkt_class_out_error;
    wire [1:0]  tx_pkt_class_out_empty;
    wire [31:0] tx_pkt_class_out_data;
    wire        tx_pkt_class_out_ready;
    
    // 1588
    wire        tx_egress_timestamp_request_out_valid;
    wire [3:0]  tx_egress_timestamp_request_out_fingerprint;
    
    wire [15:0] tx_etstamp_ins_ctrl_out_offset_timestamp;
    wire [15:0] tx_etstamp_ins_ctrl_out_offset_correction_field;
    wire [15:0] tx_etstamp_ins_ctrl_out_offset_checksum_field;
    wire [15:0] tx_etstamp_ins_ctrl_out_offset_checksum_correction;
    
    wire        tx_etstamp_ins_ctrl_out_checksum_zero;
    wire        tx_etstamp_ins_ctrl_out_checksum_correct;
    wire        tx_etstamp_ins_ctrl_out_timestamp_format;
    wire        tx_etstamp_ins_ctrl_out_timestamp_insert;
    wire        tx_etstamp_ins_ctrl_out_residence_time_update;
    
    wire [95:0] tx_etstamp_ins_ctrl_out_ingress_timestamp_96b;
    wire [63:0] tx_etstamp_ins_ctrl_out_ingress_timestamp_64b;
    wire        tx_etstamp_ins_ctrl_out_residence_time_calc_format;
    
    // TOD
    wire [95:0] tx_time_of_day_96b_1g_data;
    wire [63:0] tx_time_of_day_64b_1g_data;
    
    wire [95:0] rx_time_of_day_96b_1g_data;
    wire [63:0] rx_time_of_day_64b_1g_data;
    
    wire [21:0] gmii16b_rx_latency;
    wire [21:0] gmii16b_tx_latency;
    
    wire [95:0] time_of_day_96b;
    wire [63:0] time_of_day_64b;
    wire [95:0] time_of_day_96b_2p5g;
    wire [63:0] time_of_day_64b_2p5g;
    wire [95:0] time_of_day_96b_1g;
    wire [63:0] time_of_day_64b_1g;
    
    wire        tod_96b_slave_load_valid_2p5g;
    wire [95:0] tod_96b_slave_load_data_2p5g;
    wire        tod_64b_slave_load_valid_2p5g;
    wire [63:0] tod_64b_slave_load_data_2p5g;
    
    wire        tod_96b_slave_load_valid_1g;
    wire [95:0] tod_96b_slave_load_data_1g;
    wire        tod_64b_slave_load_valid_1g;
    wire [63:0] tod_64b_slave_load_data_1g;
    
    // PPS
    wire        pulse_per_second_2p5g;
    wire        pulse_per_second_1g;

    //sharing the same ToD for TX and RX
    assign  tx_time_of_day_96b_1g_data  = time_of_day_96b;
    assign  tx_time_of_day_64b_1g_data  = time_of_day_64b;
        
    assign  rx_time_of_day_96b_1g_data  = time_of_day_96b;
    assign  rx_time_of_day_64b_1g_data  = time_of_day_64b;
        
    // Mux wire from different speed
    assign  pulse_per_second = (operating_speed[2] == 1'b1) ? pulse_per_second_2p5g : pulse_per_second_1g;
    assign  time_of_day_96b  = (operating_speed[2] == 1'b1) ? time_of_day_96b_2p5g : time_of_day_96b_1g;
    assign  time_of_day_64b  = (operating_speed[2] == 1'b1) ? time_of_day_64b_2p5g : time_of_day_64b_1g;
    
    // Tie unused CSR
    assign  alt_mge_1588_tod_2p5g_csr_writedata = 32'b0;
    assign  alt_mge_1588_tod_2p5g_csr_address   =  6'b0;
    assign  alt_mge_1588_tod_2p5g_csr_write     =  1'b0;
    assign  alt_mge_1588_tod_2p5g_csr_read      =  1'b0;

    assign  alt_mge_1588_tod_1g_csr_writedata = 32'b0;
    assign  alt_mge_1588_tod_1g_csr_address   =  6'b0;
    assign  alt_mge_1588_tod_1g_csr_write     =  1'b0;
    assign  alt_mge_1588_tod_1g_csr_read      =  1'b0;
    
    alt_mge_mac mac (
        // CSR Clock
        .csr_clk                        (csr_clk),
        
        // MAC User Clock
        .tx_156_25_clk                  (mac_clk),
        .rx_156_25_clk                  (mac_clk),
        
        // Reset
        .csr_rst_n                      (~reset),
        .tx_rst_n                       (~tx_digitalreset),
        .rx_rst_n                       (~rx_digitalreset),
        
        // MAC CSR
        .csr_address                    (csr_mac_address),
        .csr_read                       (csr_mac_read),
        .csr_write                      (csr_mac_write),
        .csr_writedata                  (csr_mac_writedata),
        .csr_readdata                   (csr_mac_readdata),
        .csr_waitrequest                (csr_mac_waitrequest),
        
        // MAC TX User Frame
        .avalon_st_tx_valid             (tx_pkt_class_out_valid),
        .avalon_st_tx_ready             (tx_pkt_class_out_ready),
        .avalon_st_tx_startofpacket     (tx_pkt_class_out_startofpacket),
        .avalon_st_tx_endofpacket       (tx_pkt_class_out_endofpacket),
        .avalon_st_tx_data              (tx_pkt_class_out_data),
        .avalon_st_tx_empty             (tx_pkt_class_out_empty),
        .avalon_st_tx_error             (tx_pkt_class_out_error),
        
        // MAC RX User Frame
        .avalon_st_rx_valid             (avalon_st_rx_valid),
        .avalon_st_rx_ready             (avalon_st_rx_ready),
        .avalon_st_rx_startofpacket     (avalon_st_rx_startofpacket),
        .avalon_st_rx_endofpacket       (avalon_st_rx_endofpacket),
        .avalon_st_rx_data              (avalon_st_rx_data),
        .avalon_st_rx_empty             (avalon_st_rx_empty),
        .avalon_st_rx_error             (avalon_st_rx_error),
        
        // MAC TX Frame Status
        .avalon_st_txstatus_valid       (avalon_st_txstatus_valid),
        .avalon_st_txstatus_data        (avalon_st_txstatus_data),
        .avalon_st_txstatus_error       (avalon_st_txstatus_error),
        
        // MAC RX Frame Status
        .avalon_st_rxstatus_valid       (avalon_st_rxstatus_valid),
        .avalon_st_rxstatus_data        (avalon_st_rxstatus_data),
        .avalon_st_rxstatus_error       (avalon_st_rxstatus_error),
        
        // MAC TX Pause Frame Generation Command
        .avalon_st_pause_data           (avalon_st_pause_data),
        
        // GMII Clock from PHY to MAC
        .gmii16b_tx_clk                 (gmii16b_tx_clk),
        .gmii16b_rx_clk                 (gmii16b_rx_clk),
        
        // GMII TX from MAC to PHY
        .gmii16b_tx_en                  (gmii16b_tx_en),
        .gmii16b_tx_d                   (gmii16b_tx_d),
        .gmii16b_tx_err                 (gmii16b_tx_err),
        
        // GMII RX from PHY to MAC
        .gmii16b_rx_dv                  (gmii16b_rx_dv),
        .gmii16b_rx_d                   (gmii16b_rx_d),
        .gmii16b_rx_err                 (gmii16b_rx_err),
        
        // PHY Operating Speed to MAC
        .speed_sel                      (operating_speed),
        
        // 1588
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
        .tx_time_of_day_96b_1g_data                                 (tx_time_of_day_96b_1g_data),
        .tx_time_of_day_64b_1g_data                                 (tx_time_of_day_64b_1g_data),
        .rx_time_of_day_96b_1g_data                                 (rx_time_of_day_96b_1g_data),
        .rx_time_of_day_64b_1g_data                                 (rx_time_of_day_64b_1g_data),
        .tx_path_delay_1g_data                                      (gmii16b_tx_latency),
        .rx_path_delay_1g_data                                      (gmii16b_rx_latency)
    );
    
    alt_mge_1g_2p5g_phy phy (
        // CSR Clock
        .csr_clk                        (csr_clk),
        
        // PHY Clock Out
        .tx_clkout                      (gmii16b_tx_clk),
        .rx_clkout                      (gmii16b_rx_clk),
        
        // Reset
        .reset                          (reset),
        .tx_digitalreset                (tx_digitalreset),
        .rx_digitalreset                (rx_digitalreset),
        .tx_analogreset                 (tx_analogreset),
        .rx_analogreset                 (rx_analogreset),
        
        // PHY CSR
        .csr_address                    (csr_phy_address),
        .csr_read                       (csr_phy_read),
        .csr_write                      (csr_phy_write),
        .csr_writedata                  (csr_phy_writedata),
        .csr_readdata                   (csr_phy_readdata),
        .csr_waitrequest                (csr_phy_waitrequest),
        
        // GMII TX from MAC to PHY
        .gmii16b_tx_en                  (gmii16b_tx_en),
        .gmii16b_tx_d                   (gmii16b_tx_d),
        .gmii16b_tx_err                 (gmii16b_tx_err),
        
        // GMII RX from PHY to MAC
        .gmii16b_rx_dv                  (gmii16b_rx_dv),
        .gmii16b_rx_d                   (gmii16b_rx_d),
        .gmii16b_rx_err                 (gmii16b_rx_err),
        
        // PHY Operating Mode from Reconfig Block
        .xcvr_mode                      (xcvr_mode),
        
        // PHY Operating Speed to MAC
        .operating_speed                (operating_speed),
        
        // PHY Status
        .led_link                       (led_link),
        .led_char_err                   (led_char_err),
        .led_disp_err                   (led_disp_err),
        .led_an                         (led_an),
        
        // Transceiver Serial Interface
        .tx_serial_clk                  (tx_serial_clk),
        .rx_cdr_refclk                  (rx_cdr_refclk),
        .rx_pma_clkout                  (rx_pma_clkout),
        .tx_serial_data                 (tx_serial_data),
        .rx_serial_data                 (rx_serial_data),
        
        // Transceiver Status
        .rx_is_lockedtodata             (rx_is_lockedtodata),
        .tx_cal_busy                    (tx_cal_busy),
        .rx_cal_busy                    (rx_cal_busy),
        
        // Transceiver Reconfiguration
        .reconfig_clk                   (reconfig_clk),
        .reconfig_reset                 (reconfig_reset),
        .reconfig_address               (reconfig_address),
        .reconfig_read                  (reconfig_read),
        .reconfig_write                 (reconfig_write),
        .reconfig_writedata             (reconfig_writedata),
        .reconfig_readdata              (reconfig_readdata),
        .reconfig_waitrequest           (reconfig_waitrequest),
        
        .gmii16b_rx_latency             (gmii16b_rx_latency),
        .gmii16b_tx_latency             (gmii16b_tx_latency),
        .latency_measure_clk            (latency_measure_clk)
    );
    
    alt_mge_packet_classifier packet_classifier (
        //Common clock and reset
        .clk                                                    (mac_clk),
        .reset                                                  (mac_reset),
        
        //Av-ST Data Sink
        .data_sink_sop                                          (avalon_st_tx_startofpacket),
        .data_sink_eop                                          (avalon_st_tx_endofpacket),
        .data_sink_valid                                        (avalon_st_tx_valid),
        .data_sink_data                                         (avalon_st_tx_data),
        .data_sink_ready                                        (avalon_st_tx_ready),
        .data_sink_empty                                        (avalon_st_tx_empty),
        .data_sink_error                                        (avalon_st_tx_error),
        
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
    
    alt_mge_1588_tod_2p5g tod_2p5g (
        .period_clk                         (gmii16b_tx_clk),                  
        .period_rst_n                       (~reset_gmii16b_tx_clk),
        .clk                                (csr_clk),
        .rst_n                              (~reset_csr_clk),                
        .csr_write                          (alt_mge_1588_tod_2p5g_csr_write),                       
        .csr_read                           (alt_mge_1588_tod_2p5g_csr_read),
        .csr_address                        (alt_mge_1588_tod_2p5g_csr_address[5:2]), //byte to dword address 
        .csr_writedata                      (alt_mge_1588_tod_2p5g_csr_writedata),
        .csr_readdata                       (alt_mge_1588_tod_2p5g_csr_readdata),
        .csr_waitrequest                    (alt_mge_1588_tod_2p5g_csr_waitrequest),
        .time_of_day_96b                    (time_of_day_96b_2p5g),
        .time_of_day_64b                    (time_of_day_64b_2p5g),
        .time_of_day_96b_load_valid         (tod_96b_slave_load_valid_2p5g),                        
        .time_of_day_96b_load_data          (tod_96b_slave_load_data_2p5g),
        .time_of_day_64b_load_valid         (tod_64b_slave_load_valid_2p5g),                        
        .time_of_day_64b_load_data          (tod_64b_slave_load_data_2p5g)
        );
        
    alt_mge_1588_tod_1g tod_1g (
        .period_clk                         (gmii16b_tx_clk),     
        .period_rst_n                       (~reset_gmii16b_tx_clk),
        .clk                                (csr_clk),
        .rst_n                              (~reset_csr_clk),                        
        .csr_write                          (alt_mge_1588_tod_1g_csr_write),                                
        .csr_read                           (alt_mge_1588_tod_1g_csr_read),
        .csr_address                        (alt_mge_1588_tod_1g_csr_address[5:2]), //byte to dword address 
        .csr_writedata                      (alt_mge_1588_tod_1g_csr_writedata),
        .csr_readdata                       (alt_mge_1588_tod_1g_csr_readdata),
        .csr_waitrequest                    (alt_mge_1588_tod_1g_csr_waitrequest),
        .time_of_day_96b                    (time_of_day_96b_1g),
        .time_of_day_64b                    (time_of_day_64b_1g),
        .time_of_day_96b_load_valid         (tod_96b_slave_load_valid_1g),                         
        .time_of_day_96b_load_data          (tod_96b_slave_load_data_1g),
        .time_of_day_64b_load_valid         (tod_64b_slave_load_valid_1g),                         
        .time_of_day_64b_load_data          (tod_64b_slave_load_data_1g)
    );
    
    alt_mge_1588_tod_sync_96b_2p5g tod_sync_96b_2p5g (
        //master tod interface
        .clk_master                         (master_tod_clk),
        .reset_master                       (master_tod_reset),
        .start_tod_sync                     (start_tod_sync),
        .tod_master_data                    (master_tod_96b_data),
        
        //slave tod interface
        .clk_slave                          (gmii16b_tx_clk),
        .clk_sampling                       (tod_sync_2p5g_sampling_clk),
        .reset_slave                        (reset_gmii16b_tx_clk),
        .tod_slave_valid                    (tod_96b_slave_load_valid_2p5g),
        .tod_slave_data                     (tod_96b_slave_load_data_2p5g)
    );
    
    alt_mge_1588_tod_sync_64b_2p5g tod_sync_64b_2p5g (
        //master tod interface
        .clk_master                         (master_tod_clk),
        .reset_master                       (master_tod_reset),
        .start_tod_sync                     (start_tod_sync),
        .tod_master_data                    (master_tod_64b_data),
        
        //slave tod interface
        .clk_slave                          (gmii16b_tx_clk),
        .clk_sampling                       (tod_sync_2p5g_sampling_clk),
        .reset_slave                        (reset_gmii16b_tx_clk),
        .tod_slave_valid                    (tod_64b_slave_load_valid_2p5g),
        .tod_slave_data                     (tod_64b_slave_load_data_2p5g)
    );

    alt_mge_1588_tod_sync_96b_1g tod_sync_96b_1g (
        //master tod interface
        .clk_master                         (master_tod_clk),
        .reset_master                       (master_tod_reset),
        .start_tod_sync                     (start_tod_sync),
        .tod_master_data                    (master_tod_96b_data),
        
        //slave tod interface
        .clk_slave                          (gmii16b_tx_clk),
        .clk_sampling                       (tod_sync_1g_sampling_clk),
        .reset_slave                        (reset_gmii16b_tx_clk),
        .tod_slave_valid                    (tod_96b_slave_load_valid_1g),
        .tod_slave_data                     (tod_96b_slave_load_data_1g)

    );

    alt_mge_1588_tod_sync_64b_1g tod_sync_64b_1g  (
        //master tod interface
        .clk_master                         (master_tod_clk),
        .reset_master                       (master_tod_reset),
        .start_tod_sync                     (start_tod_sync),
        .tod_master_data                    (master_tod_64b_data),
        
        //slave tod interface
        .clk_slave                          (gmii16b_tx_clk),
        .clk_sampling                       (tod_sync_1g_sampling_clk),
        .reset_slave                        (reset_gmii16b_tx_clk),
        .tod_slave_valid                    (tod_64b_slave_load_valid_1g),
        .tod_slave_data                     (tod_64b_slave_load_data_1g)
    );

    altera_eth_1588_pps #(
        .PULSE_CYCLE        (PPS_PULSE_ASSERT_CYCLE_2p5G)    // assert for 1ms for every 10ms
    ) pulse_per_second_2p5g_u0 (
        .clk                                (gmii16b_tx_clk),
        .reset                              (reset_gmii16b_tx_clk),
    
        .time_of_day_96b                    (time_of_day_96b_2p5g),
        .pulse_per_second                   (pulse_per_second_2p5g)
    );
    
    altera_eth_1588_pps #(
        .PULSE_CYCLE        (PPS_PULSE_ASSERT_CYCLE_1G)     // assert for 1ms for every 10ms    
    ) pulse_per_second_1g_u1 (
        .clk                                (gmii16b_tx_clk),
        .reset                              (reset_gmii16b_tx_clk),
    
        .time_of_day_96b                    (time_of_day_96b_1g),
        .pulse_per_second                   (pulse_per_second_1g)
    );
    
    
    // Reset Synchronization
    alt_mge_reset_synchronizer #(
        .ASYNC_RESET    (1),
        .DEPTH          (3)
    ) u_rst_sync_csr_clk (
        .clk            (csr_clk),
        .reset_in       (reset),
        .reset_out      (reset_csr_clk)
    );
    
    // Reset Synchronization
    alt_mge_reset_synchronizer #(
        .ASYNC_RESET    (1),
        .DEPTH          (3)
    ) u_rst_sync_gmii16b_tx_clk (
        .clk            (gmii16b_tx_clk),
        .reset_in       (tx_digitalreset),
        .reset_out      (reset_gmii16b_tx_clk)
    );
    
    // Reset Synchronization
    alt_mge_reset_synchronizer #(
        .ASYNC_RESET    (1),
        .DEPTH          (3)
    ) u_rst_sync_mac_clk (
        .clk            (mac_clk),
        .reset_in       (tx_digitalreset),
        .reset_out      (mac_reset)
    );
endmodule
