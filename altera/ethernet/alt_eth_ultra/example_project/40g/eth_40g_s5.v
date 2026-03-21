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



`include "dynamic_parameters.v"

module eth_40g_s5 (
		input  wire [0:0]   reset_async,           //        reset_async.reset_async
		input  wire [3:0]   rx_serial,             //          rx_serial.rx_serial
		output wire [3:0]   tx_serial,             //          tx_serial.tx_serial
		input  wire [0:0]   clk_status,            //         clk_status.clk_status
		input  wire [0:0]   reset_status,          //       reset_status.reset_status
		input  wire [0:0]   status_write,          //        status_avmm.status_write
		input  wire [0:0]   status_read,           //                   .status_read
		input  wire [15:0]  status_addr,           //                   .status_addr
		input  wire [31:0]  status_writedata,      //                   .status_writedata
		output wire [31:0]  status_readdata,       //                   .status_readdata
		output wire [0:0]   status_readdata_valid, //                   .status_readdata_valid
		output wire [0:0]   status_waitrequest,    //                   .status_waitrequest
		output wire [0:0]   status_read_timeout,   //                   .status_read_timeout
		output wire [0:0]   clk_txmac,             //          clk_txmac.clk_txmac
		output wire [0:0]   rx_pcs_ready,          //       rx_pcs_ready.rx_pcs_ready
		output wire [0:0]   clk_rxmac,             //          clk_rxmac.clk_rxmac
		`ifdef SYNOPT_PAUSE
		input  wire [0:0]   pause_insert_tx,       //              pause.pause_insert_tx
		output wire [0:0]   pause_receive_rx,      //                   .pause_receive_rx
		`endif
		`ifdef SYNOPT_LINK_FAULT
		output wire [0:0]   remote_fault_status,   //              fault.remote_fault_status
		output wire [0:0]   local_fault_status,    //                   .local_fault_status
        output wire [0:0]   link_fault_gen_en,
        output wire [0:0]   unidirectional_en,
		`endif
		output wire [0:0]   rx_inc_runt,           //           rx_stats.rx_inc_runt
		output wire [0:0]   rx_inc_64,             //                   .rx_inc_64
		output wire [0:0]   rx_inc_127,            //                   .rx_inc_127
		output wire [0:0]   rx_inc_255,            //                   .rx_inc_255
		output wire [0:0]   rx_inc_511,            //                   .rx_inc_511
		output wire [0:0]   rx_inc_1023,           //                   .rx_inc_1023
		output wire [0:0]   rx_inc_1518,           //                   .rx_inc_1518
		output wire [0:0]   rx_inc_max,            //                   .rx_inc_max
		output wire [0:0]   rx_inc_over,           //                   .rx_inc_over
		output wire [0:0]   rx_inc_mcast_data_err, //                   .rx_inc_mcast_data_err
		output wire [0:0]   rx_inc_mcast_data_ok,  //                   .rx_inc_mcast_data_ok
		output wire [0:0]   rx_inc_bcast_data_err, //                   .rx_inc_bcast_data_err
		output wire [0:0]   rx_inc_bcast_data_ok,  //                   .rx_inc_bcast_data_ok
		output wire [0:0]   rx_inc_ucast_data_err, //                   .rx_inc_ucast_data_err
		output wire [0:0]   rx_inc_ucast_data_ok,  //                   .rx_inc_ucast_data_ok
		output wire [0:0]   rx_inc_mcast_ctrl,     //                   .rx_inc_mcast_ctrl
		output wire [0:0]   rx_inc_bcast_ctrl,     //                   .rx_inc_bcast_ctrl
		output wire [0:0]   rx_inc_ucast_ctrl,     //                   .rx_inc_ucast_ctrl
		output wire [0:0]   rx_inc_pause,          //                   .rx_inc_pause
		output wire [0:0]   rx_inc_fcs_err,        //                   .rx_inc_fcs_err
		output wire [0:0]   rx_inc_fragment,       //                   .rx_inc_fragment
		output wire [0:0]   rx_inc_jabber,         //                   .rx_inc_jabber
		output wire [0:0]   rx_inc_sizeok_fcserr,  //                   .rx_inc_sizeok_fcserr
		output wire [0:0]   rx_inc_pause_ctrl_err, //                   .rx_inc_pause_ctrl_err
		output wire [0:0]   rx_inc_mcast_ctrl_err, //                   .rx_inc_mcast_ctrl_err
		output wire [0:0]   rx_inc_bcast_ctrl_err, //                   .rx_inc_bcast_ctrl_err
		output wire [0:0]   rx_inc_ucast_ctrl_err, //                   .rx_inc_ucast_ctrl_err
        output wire [15:0]  rx_inc_octetsOK,
        output wire         rx_inc_octetsOK_valid,
        output wire [15:0]  tx_inc_octetsOK,
        output wire         tx_inc_octetsOK_valid,
        output wire         tx_lanes_stable,
		output wire [0:0]   tx_inc_64,             //           tx_stats.tx_inc_64
		output wire [0:0]   tx_inc_127,            //                   .tx_inc_127
		output wire [0:0]   tx_inc_255,            //                   .tx_inc_255
		output wire [0:0]   tx_inc_511,            //                   .tx_inc_511
		output wire [0:0]   tx_inc_1023,           //                   .tx_inc_1023
		output wire [0:0]   tx_inc_1518,           //                   .tx_inc_1518
		output wire [0:0]   tx_inc_max,            //                   .tx_inc_max
		output wire [0:0]   tx_inc_over,           //                   .tx_inc_over
		output wire [0:0]   tx_inc_mcast_data_err, //                   .tx_inc_mcast_data_err
		output wire [0:0]   tx_inc_mcast_data_ok,  //                   .tx_inc_mcast_data_ok
		output wire [0:0]   tx_inc_bcast_data_err, //                   .tx_inc_bcast_data_err
		output wire [0:0]   tx_inc_bcast_data_ok,  //                   .tx_inc_bcast_data_ok
		output wire [0:0]   tx_inc_ucast_data_err, //                   .tx_inc_ucast_data_err
		output wire [0:0]   tx_inc_ucast_data_ok,  //                   .tx_inc_ucast_data_ok
		output wire [0:0]   tx_inc_mcast_ctrl,     //                   .tx_inc_mcast_ctrl
		output wire [0:0]   tx_inc_bcast_ctrl,     //                   .tx_inc_bcast_ctrl
		output wire [0:0]   tx_inc_ucast_ctrl,     //                   .tx_inc_ucast_ctrl
		output wire [0:0]   tx_inc_pause,          //                   .tx_inc_pause
		output wire [0:0]   tx_inc_fcs_err,        //                   .tx_inc_fcs_err
		output wire [0:0]   tx_inc_fragment,       //                   .tx_inc_fragment
		output wire [0:0]   tx_inc_jabber,         //                   .tx_inc_jabber
		output wire [0:0]   tx_inc_sizeok_fcserr,  //                   .tx_inc_sizeok_fcserr

        `ifdef EXT_TX_PLL
        input wire clk_txmac_in,
        `endif

        `ifdef SYNOPT_PTP
            input wire tx_egress_timestamp_request_valid,
            input wire [`PTP_FP_WIDTH-1:0] tx_egress_timestamp_request_fingerprint,
            input wire tx_etstamp_ins_ctrl_timestamp_insert,
            input wire tx_etstamp_ins_ctrl_timestamp_format,
            input wire tx_etstamp_ins_ctrl_residence_time_update,
            input wire tx_etstamp_ins_ctrl_residence_time_calc_format,
            input wire tx_etstamp_ins_ctrl_checksum_zero,
            input wire tx_etstamp_ins_ctrl_checksum_correct,
            input wire [15:0] tx_etstamp_ins_ctrl_offset_timestamp,
            input wire [15:0] tx_etstamp_ins_ctrl_offset_correction_field,
            input wire [15:0] tx_etstamp_ins_ctrl_offset_checksum_field,
            input wire [15:0] tx_etstamp_ins_ctrl_offset_checksum_correction,
            input wire tx_egress_asymmetry_update,

            `ifdef SYNOPT_96B_PTP
                input wire [95:0] rx_time_of_day_96b_data,
                input wire [95:0] tx_time_of_day_96b_data,
                input wire [95:0] tx_etstamp_ins_ctrl_ingress_timestamp_96b,
                output wire [95:0] rx_ingress_timestamp_96b_data,
                output wire rx_ingress_timestamp_96b_valid,
                output wire [95:0] tx_egress_timestamp_96b_data,
                output wire tx_egress_timestamp_96b_valid,
                output wire [`PTP_FP_WIDTH-1:0] tx_egress_timestamp_96b_fingerprint,
            `endif

            `ifdef SYNOPT_64B_PTP
                input wire [63:0] rx_time_of_day_64b_data,
                input wire [63:0] tx_time_of_day_64b_data,
                input wire [63:0] tx_etstamp_ins_ctrl_ingress_timestamp_64b,
                output wire [63:0] rx_ingress_timestamp_64b_data,
                output wire rx_ingress_timestamp_64b_valid,
                output wire [63:0] tx_egress_timestamp_64b_data,
                output wire tx_egress_timestamp_64b_valid,
                output wire [`PTP_FP_WIDTH-1:0] tx_egress_timestamp_64b_fingerprint,
            `endif
        `endif

		`ifdef CUSTOM_IF
		input  wire [1:0]   din_sop,               //         custom_st_tx.din_sop
		input  wire [1:0]   din_eop,               //                     .din_eop
		input  wire [1:0]   din_idle,              //                     .din_idle
		input  wire [5:0]   din_eop_empty,         //                     .din_eop_empty
		input  wire [127:0] din,                   //                     .din
		output wire         din_req,               //                     .din_req
		output wire         dout_valid,            //         custom_st_rx.dout_valid
		output wire [127:0] dout_d,                //                     .dout_d
		output wire [15:0]  dout_c,                //                     .dout_c
		output wire [1:0]   dout_sop,              //                     .dout_sop
		output wire [1:0]   dout_eop,              //                     .dout_eop
		output wire [5:0]   dout_eop_empty,        //                     .dout_eop_empty
		output wire [1:0]   dout_idle,             //                     .dout_idle
		output wire [1:0]   rx_fcs_error,          //                     .rx_fcs_error
		output wire [1:0]   rx_fcs_valid,          //                     .rx_fcs_valid		
		`endif
		
		`ifdef AVALON_IF	
		input  wire         l4_tx_startofpacket,   //       avalon_st_tx.l4_tx_startofpacket
        input  wire         l4_tx_error,           //                   .l4_tx_error
		input  wire         l4_tx_endofpacket,     //                   .l4_tx_endofpacket
		input  wire         l4_tx_valid,           //                   .l4_tx_valid
		output wire         l4_tx_ready,           //                   .l4_tx_ready
		input  wire [4:0]   l4_tx_empty,           //                   .l4_tx_empty
		input  wire [255:0] l4_tx_data,            //                   .l4_tx_data
		output wire         l4_rx_error,           //       avalon_st_rx.l4_rx_error
		output wire         l4_rx_valid,           //                   .l4_rx_valid
		output wire         l4_rx_startofpacket,   //                   .l4_rx_startofpacket
		output wire         l4_rx_endofpacket,     //                   .l4_rx_endofpacket
		output wire [255:0] l4_rx_data,            //                   .l4_rx_data
		output wire [4:0]   l4_rx_empty,           //                   .l4_rx_empty
		output wire         l4_rx_fcs_error,       //                   .l4_rx_fcs_error
		output wire         l4_rx_fcs_valid,       //                   .l4_rx_fcs_valid
        output wire [2:0]   l4_rx_status,
		`endif
		
		input  wire [0:0]   clk_ref                //            clk_ref.clk_ref
	);
	
		wire [559:0] reconfig_to_xcvr;      //   reconfig_to_xcvr.reconfig_to_xcvr
		wire [367:0] reconfig_from_xcvr;    // reconfig_from_xcvr.reconfig_from_xcvr
		wire [0:0]   reconfig_busy;         //      reconfig_busy.reconfig_busy
		
	e40_reco e40_reco_inst (
		.reconfig_busy(reconfig_busy),             //      reconfig_busy.reconfig_busy
		.mgmt_clk_clk(clk_status),              //       mgmt_clk_clk.clk
		.mgmt_rst_reset(reset_status),            //     mgmt_rst_reset.reset
		.reconfig_mgmt_address(7'b0),     //      reconfig_mgmt.address
		.reconfig_mgmt_read(1'b0),        //                   .read
		.reconfig_mgmt_readdata(),    //                   .readdata
		.reconfig_mgmt_waitrequest(), //                   .waitrequest
		.reconfig_mgmt_write(1'b0),       //                   .write
		.reconfig_mgmt_writedata(32'b0),   //                   .writedata
		.reconfig_to_xcvr(reconfig_to_xcvr),          //   reconfig_to_xcvr.reconfig_to_xcvr
		.reconfig_from_xcvr(reconfig_from_xcvr)         // reconfig_from_xcvr.reconfig_from_xcvr
	);

    `ifdef SYNOPT_PTP
    
    wire [95:0] tod_txmac_in;
    wire [95:0] tod_rxmac_in;
    
    alt_aeu_clks_des 
      #(.TARGET_CHIP(2)) // Stratix V
    des
      (
       .rst_txmac(reset_async),
       .rst_rxmac(reset_async),
       .tod_txmclk(tod_txmac_in),
       .tod_rxmclk(tod_rxmac_in),
       .clk_txmac(clk_txmac), // mac tx clk
       .clk_rxmac(clk_rxmac)  // mac rx clk
       );

    `endif

	ENET_ENTITY_QMEGA_01312014 ENET_ENTITY_QMEGA_01312014_inst (
		.reset_async           (reset_async),                                                                                                                           //        reset_async.reset_async
		.rx_serial             (rx_serial),                                                                                                                             //          rx_serial.rx_serial
		.tx_serial             (tx_serial),                                                                                                                             //          tx_serial.tx_serial
		.clk_status            (clk_status),                                                                                                                            //         clk_status.clk_status
		.reset_status          (reset_status),                                                                                                                          //       reset_status.reset_status
		.status_write          (status_write),                                                                                                                          //        status_avmm.status_write
		.status_read           (status_read),                                                                                                                           //                   .status_read
		.status_addr           (status_addr),                                                                                                                           //                   .status_addr
		.status_writedata      (status_writedata),                                                                                                                      //                   .status_writedata
		.status_readdata       (status_readdata),                                                                                                                       //                   .status_readdata
		.status_readdata_valid (status_readdata_valid),                                                                                                                 //                   .status_readdata_valid
		.status_waitrequest    (status_waitrequest),                                                                                                                    //                   .status_waitrequest
		.status_read_timeout   (status_read_timeout),                                                                                                                   //                   .status_read_timeout
		.clk_txmac             (clk_txmac),                                                                                                                             //          clk_txmac.clk_txmac
		.rx_pcs_ready          (rx_pcs_ready),                                                                                                                          //       rx_pcs_ready.rx_pcs_ready
		.clk_rxmac             (clk_rxmac),                                                                                                                             //          clk_rxmac.clk_rxmac
		`ifdef SYNOPT_PAUSE
		.pause_insert_tx       (pause_insert_tx),       //                pause.pause_insert_tx
		.pause_receive_rx      (pause_receive_rx),      //                     .pause_receive_rx
		`endif
		`ifdef SYNOPT_LINK_FAULT
		.remote_fault_status  (remote_fault_status),  //                fault.remote_fault_from_rx
		.local_fault_status   (local_fault_status),   //                     .local_fault_from_rx
        .link_fault_gen_en    (link_fault_gen_en),
        .unidirectional_en    (unidirectional_en),
        `endif

        `ifdef EXT_TX_PLL
        .clk_txmac_in          (clk_txmac_in),
        `endif

		.rx_inc_runt           (rx_inc_runt),                                                                                                                           //           rx_stats.rx_inc_runt
		.rx_inc_64             (rx_inc_64),                                                                                                                             //                   .rx_inc_64
		.rx_inc_127            (rx_inc_127),                                                                                                                            //                   .rx_inc_127
		.rx_inc_255            (rx_inc_255),                                                                                                                            //                   .rx_inc_255
		.rx_inc_511            (rx_inc_511),                                                                                                                            //                   .rx_inc_511
		.rx_inc_1023           (rx_inc_1023),                                                                                                                           //                   .rx_inc_1023
		.rx_inc_1518           (rx_inc_1518),                                                                                                                           //                   .rx_inc_1518
		.rx_inc_max            (rx_inc_max),                                                                                                                            //                   .rx_inc_max
		.rx_inc_over           (rx_inc_over),                                                                                                                           //                   .rx_inc_over
		.rx_inc_mcast_data_err (rx_inc_mcast_data_err),                                                                                                                 //                   .rx_inc_mcast_data_err
		.rx_inc_mcast_data_ok  (rx_inc_mcast_data_ok),                                                                                                                  //                   .rx_inc_mcast_data_ok
		.rx_inc_bcast_data_err (rx_inc_bcast_data_err),                                                                                                                 //                   .rx_inc_bcast_data_err
		.rx_inc_bcast_data_ok  (rx_inc_bcast_data_ok),                                                                                                                  //                   .rx_inc_bcast_data_ok
		.rx_inc_ucast_data_err (rx_inc_ucast_data_err),                                                                                                                 //                   .rx_inc_ucast_data_err
		.rx_inc_ucast_data_ok  (rx_inc_ucast_data_ok),                                                                                                                  //                   .rx_inc_ucast_data_ok
		.rx_inc_mcast_ctrl     (rx_inc_mcast_ctrl),                                                                                                                     //                   .rx_inc_mcast_ctrl
		.rx_inc_bcast_ctrl     (rx_inc_bcast_ctrl),                                                                                                                     //                   .rx_inc_bcast_ctrl
		.rx_inc_ucast_ctrl     (rx_inc_ucast_ctrl),                                                                                                                     //                   .rx_inc_ucast_ctrl
		.rx_inc_pause          (rx_inc_pause),                                                                                                                          //                   .rx_inc_pause
		.rx_inc_fcs_err        (rx_inc_fcs_err),                                                                                                                        //                   .rx_inc_fcs_err
		.rx_inc_fragment       (rx_inc_fragment),                                                                                                                       //                   .rx_inc_fragment
		.rx_inc_jabber         (rx_inc_jabber),                                                                                                                         //                   .rx_inc_jabber
		.rx_inc_sizeok_fcserr  (rx_inc_sizeok_fcserr),                                                                                                                  //                   .rx_inc_sizeok_fcserr
		.rx_inc_pause_ctrl_err (rx_inc_pause_ctrl_err),                                                                                                                 //                   .rx_inc_pause_ctrl_err
		.rx_inc_mcast_ctrl_err (rx_inc_mcast_ctrl_err),                                                                                                                 //                   .rx_inc_mcast_ctrl_err
		.rx_inc_bcast_ctrl_err (rx_inc_bcast_ctrl_err),                                                                                                                 //                   .rx_inc_bcast_ctrl_err
		.rx_inc_ucast_ctrl_err (rx_inc_ucast_ctrl_err),                                                                                                                 //                   .rx_inc_ucast_ctrl_err
        .rx_inc_octetsOK       (rx_inc_octetsOK),
        .rx_inc_octetsOK_valid (rx_inc_octetsOK_valid),
        .tx_inc_octetsOK       (tx_inc_octetsOK),
        .tx_inc_octetsOK_valid (tx_inc_octetsOK_valid),
        .tx_lanes_stable       (tx_lanes_stable),
        .tx_inc_64             (tx_inc_64),                                                                                                                             //           tx_stats.tx_inc_64
		.tx_inc_127            (tx_inc_127),                                                                                                                            //                   .tx_inc_127
		.tx_inc_255            (tx_inc_255),                                                                                                                            //                   .tx_inc_255
		.tx_inc_511            (tx_inc_511),                                                                                                                            //                   .tx_inc_511
		.tx_inc_1023           (tx_inc_1023),                                                                                                                           //                   .tx_inc_1023
		.tx_inc_1518           (tx_inc_1518),                                                                                                                           //                   .tx_inc_1518
		.tx_inc_max            (tx_inc_max),                                                                                                                            //                   .tx_inc_max
		.tx_inc_over           (tx_inc_over),                                                                                                                           //                   .tx_inc_over
		.tx_inc_mcast_data_err (tx_inc_mcast_data_err),                                                                                                                 //                   .tx_inc_mcast_data_err
		.tx_inc_mcast_data_ok  (tx_inc_mcast_data_ok),                                                                                                                  //                   .tx_inc_mcast_data_ok
		.tx_inc_bcast_data_err (tx_inc_bcast_data_err),                                                                                                                 //                   .tx_inc_bcast_data_err
		.tx_inc_bcast_data_ok  (tx_inc_bcast_data_ok),                                                                                                                  //                   .tx_inc_bcast_data_ok
		.tx_inc_ucast_data_err (tx_inc_ucast_data_err),                                                                                                                 //                   .tx_inc_ucast_data_err
		.tx_inc_ucast_data_ok  (tx_inc_ucast_data_ok),                                                                                                                  //                   .tx_inc_ucast_data_ok
		.tx_inc_mcast_ctrl     (tx_inc_mcast_ctrl),                                                                                                                     //                   .tx_inc_mcast_ctrl
		.tx_inc_bcast_ctrl     (tx_inc_bcast_ctrl),                                                                                                                     //                   .tx_inc_bcast_ctrl
		.tx_inc_ucast_ctrl     (tx_inc_ucast_ctrl),                                                                                                                     //                   .tx_inc_ucast_ctrl
		.tx_inc_pause          (tx_inc_pause),                                                                                                                          //                   .tx_inc_pause
		.tx_inc_fcs_err        (tx_inc_fcs_err),                                                                                                                        //                   .tx_inc_fcs_err
		.tx_inc_fragment       (tx_inc_fragment),                                                                                                                       //                   .tx_inc_fragment
		.tx_inc_jabber         (tx_inc_jabber),                                                                                                                         //                   .tx_inc_jabber
		.tx_inc_sizeok_fcserr  (tx_inc_sizeok_fcserr),                                                                                                                  //                   .tx_inc_sizeok_fcserr

        `ifdef SYNOPT_PTP
            .tx_egress_timestamp_request_valid(tx_egress_timestamp_request_valid),
            .tx_egress_timestamp_request_fingerprint(tx_egress_timestamp_request_fingerprint),
            .tx_etstamp_ins_ctrl_timestamp_insert(tx_etstamp_ins_ctrl_timestamp_insert),
            .tx_etstamp_ins_ctrl_timestamp_format(tx_etstamp_ins_ctrl_timestamp_format),
            .tx_etstamp_ins_ctrl_residence_time_update(tx_etstamp_ins_ctrl_residence_time_update),
            .tx_etstamp_ins_ctrl_residence_time_calc_format(tx_etstamp_ins_ctrl_residence_time_calc_format),
            .tx_etstamp_ins_ctrl_checksum_zero(tx_etstamp_ins_ctrl_checksum_zero),
            .tx_etstamp_ins_ctrl_checksum_correct(tx_etstamp_ins_ctrl_checksum_correct),
            .tx_etstamp_ins_ctrl_offset_timestamp(tx_etstamp_ins_ctrl_offset_timestamp),
            .tx_etstamp_ins_ctrl_offset_correction_field(tx_etstamp_ins_ctrl_offset_correction_field),
            .tx_etstamp_ins_ctrl_offset_checksum_field(tx_etstamp_ins_ctrl_offset_checksum_field),
            .tx_etstamp_ins_ctrl_offset_checksum_correction(tx_etstamp_ins_ctrl_offset_checksum_correction),
            .tx_egress_asymmetry_update(tx_egress_asymmetry_update),

            `ifdef SYNOPT_96B_PTP
                .rx_time_of_day_96b_data(rx_time_of_day_96b_data),
                .tx_time_of_day_96b_data(tx_time_of_day_96b_data),
                .tx_etstamp_ins_ctrl_ingress_timestamp_96b(tx_etstamp_ins_ctrl_ingress_timestamp_96b),
                .rx_ingress_timestamp_96b_data(rx_ingress_timestamp_96b_data),
                .rx_ingress_timestamp_96b_valid(rx_ingress_timestamp_96b_valid),
                .tx_egress_timestamp_96b_data(tx_egress_timestamp_96b_data),
                .tx_egress_timestamp_96b_valid(tx_egress_timestamp_96b_valid),
                .tx_egress_timestamp_96b_fingerprint(tx_egress_timestamp_96b_fingerprint),
            `endif

            `ifdef SYNOPT_64B_PTP
                .rx_time_of_day_64b_data(rx_time_of_day_64b_data),
                .tx_time_of_day_64b_data(tx_time_of_day_64b_data),
                .tx_etstamp_ins_ctrl_ingress_timestamp_64b(tx_etstamp_ins_ctrl_ingress_timestamp_64b),
                .rx_ingress_timestamp_64b_data(rx_ingress_timestamp_64b_data),
                .rx_ingress_timestamp_64b_valid(rx_ingress_timestamp_64b_valid),
                .tx_egress_timestamp_64b_data(tx_egress_timestamp_64b_data),
                .tx_egress_timestamp_64b_valid(tx_egress_timestamp_64b_valid),
                .tx_egress_timestamp_64b_fingerprint(tx_egress_timestamp_64b_fingerprint),
            `endif
        `endif

		.reconfig_to_xcvr      (reconfig_to_xcvr),                                                                                                                      //   reconfig_to_xcvr.reconfig_to_xcvr
		.reconfig_from_xcvr    (reconfig_from_xcvr),                                                                                                                    // reconfig_from_xcvr.reconfig_from_xcvr
		.reconfig_busy         (reconfig_busy),                                                                                                                         //      reconfig_busy.reconfig_busy		
		
		`ifdef CUSTOM_IF
		.din_sop		    (din_sop),        	
		.din_eop		    (din_eop),	
		.din_idle		    (din_idle),	
		.din_eop_empty		(din_eop_empty), 
		.din			    (din),    		
		.din_req		    (din_req),		
		.dout_valid	    	(dout_valid),
		.dout_d		    	(dout_d),
		.dout_c		    	(dout_c),
		.dout_sop		    (dout_sop),
		.dout_eop		    (dout_eop),
		.dout_eop_empty 	(dout_eop_empty),
		.dout_idle		    (dout_idle),
		.rx_fcs_error		(rx_fcs_error),
		.rx_fcs_valid		(rx_fcs_valid),
		`endif		
		
		`ifdef AVALON_IF
		.l4_tx_startofpacket   (l4_tx_startofpacket),                                                                                                                   //       avalon_st_tx.l4_tx_startofpacket
        .l4_tx_error           (l4_tx_error),                                                                                                                           //                   .l4_tx_error
		.l4_tx_endofpacket     (l4_tx_endofpacket),                                                                                                                     //                   .l4_tx_endofpacket
		.l4_tx_valid           (l4_tx_valid),                                                                                                                           //                   .l4_tx_valid
		.l4_tx_ready           (l4_tx_ready),                                                                                                                           //                   .l4_tx_ready
		.l4_tx_empty           (l4_tx_empty),                                                                                                                           //                   .l4_tx_empty
		.l4_tx_data            (l4_tx_data),                                                                                                                            //                   .l4_tx_data
		.l4_rx_error           (l4_rx_error),                                                                                                                           //       avalon_st_rx.l4_rx_error
		.l4_rx_valid           (l4_rx_valid),                                                                                                                           //                   .l4_rx_valid
		.l4_rx_startofpacket   (l4_rx_startofpacket),                                                                                                                   //                   .l4_rx_startofpacket
		.l4_rx_endofpacket     (l4_rx_endofpacket),                                                                                                                     //                   .l4_rx_endofpacket
		.l4_rx_data            (l4_rx_data),                                                                                                                            //                   .l4_rx_data
		.l4_rx_empty           (l4_rx_empty),                                                                                                                           //                   .l4_rx_empty
		.l4_rx_fcs_error       (l4_rx_fcs_error),                                                                                                                       //                   .l4_rx_fcs_error
		.l4_rx_fcs_valid       (l4_rx_fcs_valid),                                                                                                                       //                   .l4_rx_fcs_valid
        .l4_rx_status          (l4_rx_status),
        `endif
		
		.clk_ref               (clk_ref)                                                                                                                                //            clk_ref.clk_ref
		
	);

endmodule
