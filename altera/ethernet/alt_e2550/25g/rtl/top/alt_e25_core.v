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


//------------------------------------------------------------------------------
// 25G Ethernet IP core top level with Avalon Stream Interface
// If user want to use custom interface, they can choose alt_e25_cust
// as top level
//------------------------------------------------------------------------------

`timescale 1ps/1ps
module alt_e25_core #(
    parameter SIM_HURRY                 = 1'b0, // push through the reset delays
    parameter SIM_SIMPLE_RATE           = 1'b0, // take a nearby rate to help PLL models
    parameter SIM_SHORT_RST             = 1'b0,
    parameter SIM_SHORT_AM              = 1'b0,
    parameter SYNOPT_PREAMBLE_PASS      = 1'b0,
    parameter SYNOPT_TXCRC_PASS         = 1'b0,
    parameter SIM_EMULATE               = 1'b0,
    parameter SYNOPT_LINK_FAULT         = 1'b0,
    parameter SYNOPT_READY_LATENCY      = 0,
    parameter SYNOPT_RSFEC              = 0,
    parameter SYNOPT_FLOW_CONTROL       = 0,
    parameter SYNOPT_NUMPRIORITY        = 8,
    parameter SYNOPT_MAC_STATS_COUNTERS = 1,
    parameter SYNOPT_TSTAMP_FP_WIDTH    = 4,
    parameter SYNOPT_TIME_OF_DAY_FORMAT = 2,
    parameter SYNOPT_ENABLE_PTP         = 1'b0,
    parameter SYNOPT_STRICT_SOP         = 0,    
    parameter TARGET_CHIP               = 5
)(
    input               clk_ref,
    input               csr_rst_n,
    input               tx_rst_n,
    input               rx_rst_n,

    input               tx_pll_locked,

    // PMA Interface
    output rx_bitslip,
    input  rx_digitalreset,
    input  rx_empty,
    input  rx_full,
    input  rx_is_lockedtodata,
    input  [65:0] rx_parallel_data,
    input  rx_pempty,
    input  rx_pfull,
    output rx_seriallpbken,
    output rx_set_locktodata,
    output rx_set_locktoref,
    output tvalid,
    input  tx_digitalreset,
    input  tx_empty,
    input  tx_full,
    output [65:0] tx_parallel_data,
    input  tx_pempty,
    input  tx_pfull,
    output phy_reset,

    // AVMM CSR bus
    input               clk_status,
    input               reset_status,
    input               status_write,
    input               status_read,
    input  [15:0]       status_addr,
    input  [31:0]       status_writedata,
    output reg [31:0]   status_readdata,
    output              status_readdata_valid,
    output reg          status_waitrequest,

    input               clk_txmac,
    input               l1_tx_startofpacket,
    input               l1_tx_endofpacket,
    input               l1_tx_valid,
    output              l1_tx_ready,
    input               l1_tx_error,
    input  [2:0]        l1_tx_empty,
    input  [63:0]       l1_tx_data,
    output              tx_lanes_stable,

    output              rx_block_lock,
    output              rx_am_lock,
    output              rx_pcs_ready,
    input               clk_rxmac,
    output [5:0]        l1_rx_error,
    output              l1_rx_valid,
    output              l1_rx_startofpacket,
    output              l1_rx_endofpacket,
    output [63:0]       l1_rx_data,
    output [2:0]        l1_rx_empty,

    output [39:0]       l1_rxstatus_data,
    output              l1_rxstatus_valid,

    output [39:0]       l1_txstatus_data,
    output              l1_txstatus_valid,
    output [6:0]        l1_txstatus_error,

    output              remote_fault_status,
    output              local_fault_status,
    output              unidirectional_en,
    output              link_fault_gen_en,

    // Flow control interface
    input  [SYNOPT_NUMPRIORITY-1:0] pause_insert_tx0,
    input  [SYNOPT_NUMPRIORITY-1:0] pause_insert_tx1,
    output [SYNOPT_NUMPRIORITY-1:0] pause_receive_rx,

    //PTP interface
    input [95:0]                        tx_time_of_day_96b_data,
    input [63:0]                        tx_time_of_day_64b_data,
    input [95:0]                        rx_time_of_day_96b_data,
    input [63:0]                        rx_time_of_day_64b_data,
    input                               tx_egress_timestamp_request_valid,
    input [SYNOPT_TSTAMP_FP_WIDTH-1:0]  tx_egress_timestamp_request_fingerprint,
    input                               tx_etstamp_ins_ctrl_timestamp_insert,
    input                               tx_etstamp_ins_ctrl_timestamp_format,
    input                               tx_etstamp_ins_ctrl_residence_time_update,
    input [95:0]                        tx_etstamp_ins_ctrl_ingress_timestamp_96b,
    input [63:0]                        tx_etstamp_ins_ctrl_ingress_timestamp_64b,
    input                               tx_etstamp_ins_ctrl_residence_time_calc_format,
    input                               tx_etstamp_ins_ctrl_checksum_zero,
    input                               tx_etstamp_ins_ctrl_checksum_correct,
    input [15:0]                        tx_etstamp_ins_ctrl_offset_timestamp,
    input [15:0]                        tx_etstamp_ins_ctrl_offset_correction_field,
    input [15:0]                        tx_etstamp_ins_ctrl_offset_checksum_field,
    input [15:0]                        tx_etstamp_ins_ctrl_offset_checksum_correction,
    input                               tx_egress_asymmetry_update,
    output                              tx_egress_timestamp_96b_valid,
    output [95:0]                       tx_egress_timestamp_96b_data,
    output [SYNOPT_TSTAMP_FP_WIDTH-1:0] tx_egress_timestamp_96b_fingerprint,
    output                              tx_egress_timestamp_64b_valid,
    output [63:0]                       tx_egress_timestamp_64b_data,
    output [SYNOPT_TSTAMP_FP_WIDTH-1:0] tx_egress_timestamp_64b_fingerprint,
    output                              rx_ingress_timestamp_96b_valid,
    output [95:0]                       rx_ingress_timestamp_96b_data,
    output                              rx_ingress_timestamp_64b_valid,
    output [63:0]                       rx_ingress_timestamp_64b_data,
    input [21:0]                        tx_path_delay_data,
    input [21:0]                        rx_path_delay_data
 );

    localparam WORDS            = 1;
    localparam WIDTH            = 64;
    localparam RXERRWIDTH       = 6;
    localparam RXSTATUSWIDTH    = 3;

    //Wire declaration
    wire [63:0]   tx_mac_data;
    wire          tx_mac_sop;
    wire          tx_mac_eop;
    wire [2:0]    tx_mac_eop_empty;
    wire          tx_mac_error;
    wire          tx_mac_sclr;
    wire          tx_mac_valid;
    wire          tx_req;

    wire [63:0]              rx_mac_data;
    wire                     rx_mac_sop;
    wire                     rx_mac_eop;
    wire [2:0]               rx_mac_eop_empty;
    wire [RXERRWIDTH-1:0]    rx_mac_error;
    wire [RXSTATUSWIDTH-1:0] rx_mac_status;
    wire                     rx_mac_valid;
    wire                     rx_mac_sclr;
    wire                     tx_out_of_rst;
    wire                     rx_out_of_rst;
    wire                     tx_clk_stable;
    wire                     rx_clk_stable;
    wire [15:0]              rx_inc_octetsOK;
    wire                     rx_inc_octetsOK_valid;

    //Flow Control CSR
    wire         fc_pfc_sel;
    wire [7:0]   fc_ena;
    wire [127:0] fc_pause_quanta;
    wire [127:0] fc_hold_quanta;
    wire [7:0]   fc_2b_req_mode_sel;
    wire [7:0]   fc_2b_req_mode_csr_req_sel;
    wire [7:0]   fc_req0;
    wire [7:0]   fc_req1;
    wire [47:0]  fc_dest_addr;
    wire [47:0]  fc_src_addr;
    wire         fc_tx_off_en;
    wire [7:0]   fc_rx_pfc_en;
    wire [47:0]  fc_rx_dest_addr;
    wire         rx_crc_pt;

    //Flow Control control and data
    wire         tx_off_req;
    wire         tx_off_ack;
    wire         fc_sel;
    wire         fc_din_sop;
    wire         fc_din_eop;
    wire [63:0]  fc_din;
    wire [2:0]   fc_din_mty;
    wire         fc_din_ready;

    //PTP CSR
    wire [19:0] ptp_tx_clk_period;
    wire [18:0] ptp_tx_asym_ns;
    wire [31:0] ptp_tx_pma_latency;
    wire [19:0] ptp_rx_clk_period;
    wire [31:0] ptp_rx_pma_latency;

    //PTP RX signals
    wire        rx_ptp_sop;
    wire        rx_ptp_valid;
    wire        rx_ptp_fb_at_lane3;

    //data in from TX PTP
    wire [63:0] ptp_in_data;
    wire        ptp_in_sop;
    wire        ptp_in_eop;
    wire [2:0]  ptp_in_eop_empty;
    wire        ptp_in_error;
    wire        ptp_in_valid;

    //data out to TX PTP
    wire [63:0] ptp_out_data;
    wire        ptp_out_sop;
    wire        ptp_out_eop;
    wire [2:0]  ptp_out_eop_empty;
    wire        ptp_out_error;
    wire        ptp_out_valid;
    wire        ptp_out_pfc_sel;
    wire        ptp_out_shift;

    //ptp signal
    wire                               tx_mac_egress_timestamp_request_valid;
    wire [SYNOPT_TSTAMP_FP_WIDTH-1:0]  tx_mac_egress_timestamp_request_fingerprint;
    wire                               tx_mac_etstamp_ins_ctrl_timestamp_insert;
    wire                               tx_mac_etstamp_ins_ctrl_timestamp_format;
    wire                               tx_mac_etstamp_ins_ctrl_residence_time_update;
    wire [95:0]                        tx_mac_etstamp_ins_ctrl_ingress_timestamp_96b;
    wire [63:0]                        tx_mac_etstamp_ins_ctrl_ingress_timestamp_64b;
    wire                               tx_mac_etstamp_ins_ctrl_residence_time_calc_format;
    wire                               tx_mac_etstamp_ins_ctrl_checksum_zero;
    wire                               tx_mac_etstamp_ins_ctrl_checksum_correct;
    wire [15:0]                        tx_mac_etstamp_ins_ctrl_offset_timestamp;
    wire [15:0]                        tx_mac_etstamp_ins_ctrl_offset_correction_field;
    wire [15:0]                        tx_mac_etstamp_ins_ctrl_offset_checksum_field;
    wire [15:0]                        tx_mac_etstamp_ins_ctrl_offset_checksum_correction;
    wire                               tx_mac_egress_asymmetry_update;

    wire        csr_reset;
    wire        tx_stats_aclr;
    wire        rx_stats_aclr;

    reg     sel_cust;
    reg     sel_txstats;
    reg     sel_rxstats;
    reg     sel_other;
    always @(*) begin
        sel_cust    = 1'b0;
        sel_txstats = 1'b0;
        sel_rxstats = 1'b0;
        sel_other   = 1'b0;
        case (status_addr[15:8])
            8'h03   :   sel_cust    = 1'b1;
            8'h04   :   sel_cust    = 1'b1;
            8'h05   :   sel_cust    = 1'b1;
            8'h06   :   sel_cust    = 1'b1;
            8'h07   :   sel_cust    = 1'b1;
            8'h08   :   sel_txstats = 1'b1;
            8'h09   :   sel_rxstats = 1'b1;
            8'h0A   :   sel_cust    = 1'b1;
            8'h0B   :   sel_cust    = 1'b1;
            8'h0C   :   sel_cust    = 1'b1;
            8'h0D   :   sel_cust    = 1'b1;
            default :   sel_other   = 1'b1;
        endcase
    end

    // MAC stats counters


    wire    read_cust       = sel_cust    && status_read;
    wire    read_txstats    = sel_txstats && status_read;
    wire    read_rxstats    = sel_rxstats && status_read;
    wire    read_other      = sel_other   && status_read;

    wire    write_cust      = sel_cust    && status_write;
    wire    write_txstats   = sel_txstats && status_write;
    wire    write_rxstats   = sel_rxstats && status_write;
    wire    write_other     = sel_other   && status_write;

    wire [31:0] cust_readdata;
    wire [31:0] rxstat_readdata;
    wire [31:0] txstat_readdata;

    wire    cust_waitrequest;
    wire    rxstat_wait_request;
    wire    txstat_wait_request;

    wire    cust_data_valid;
    wire    txstat_data_valid;
    wire    rxstat_data_valid;
    reg     other_datavalid;

    always @(*) begin
        case (1'b1)
            sel_cust    : status_waitrequest = cust_waitrequest;
            sel_txstats : status_waitrequest = txstat_wait_request;
            sel_rxstats : status_waitrequest = rxstat_wait_request;
            default     : status_waitrequest = 1'b0;
        endcase
    end

    always @(posedge clk_status) other_datavalid <= read_other;

    // datavalid is OR or all data valids
    assign status_readdata_valid = rxstat_data_valid || txstat_data_valid || cust_data_valid || other_datavalid;

    // readdata is selected based on data valid signal
    always @(*) begin
        case (1'b1)
            cust_data_valid     : status_readdata = cust_readdata;
            txstat_data_valid   : status_readdata = txstat_readdata;
            rxstat_data_valid   : status_readdata = rxstat_readdata;
            default             : status_readdata = 32'hdeadc0de;
        endcase
    end

    generate
        if (SYNOPT_MAC_STATS_COUNTERS) begin : g_ctrs
            alt_e2550_stats_counters #(
                .WIDTH  (64)
            ) txstats (
                .counter_aclr        (tx_stats_aclr),
                .csr_reset           (csr_reset),
                .stats_clk           (clk_status),  // 100 MHz status clk
                .addr                (status_addr[7:0]),
                .readdata            (txstat_readdata),
                .read                (read_txstats),
                .write               (write_txstats),
                .writedata           (status_writedata),
                .data_valid          (txstat_data_valid),
                .wait_request        (txstat_wait_request),
                .mac_rst             (!tx_pll_locked),
                .mac_clk             (clk_txmac),
                .crc_error           (1'b0),
                .undersized_frame    (1'b0),
                .oversized_frame_in  (l1_txstatus_error[1]),
                .payload_len_error   (l1_txstatus_error[2]),
                .valid_in            (l1_txstatus_valid),
                .status_data_vector  (l1_txstatus_data)
            );

            alt_e2550_stats_counters #(
                .WIDTH  (64)
            ) rxstats (
                .counter_aclr        (rx_stats_aclr),
                .csr_reset           (csr_reset),
                .stats_clk           (clk_status),  // 100 MHz status clk
                .addr                (status_addr[7:0]),
                .readdata            (rxstat_readdata),
                .read                (read_rxstats),
                .write               (write_rxstats),
                .writedata           (status_writedata),
                .data_valid          (rxstat_data_valid),
                .wait_request        (rxstat_wait_request),
                .mac_rst             (!rx_is_lockedtodata),
                .mac_clk             (clk_rxmac),
                .crc_error           (l1_rx_error[1]),
                .undersized_frame    (l1_rx_error[2]),
                .oversized_frame_in  (l1_rx_error[3]),
                .payload_len_error   (l1_rx_error[4]),
                .valid_in            (l1_rxstatus_valid),
                .status_data_vector  (l1_rxstatus_data)
            );
        end else begin : g_noctrs
            reg txstat_data_valid_reg;
            reg rxstat_data_valid_reg;
            always @(posedge clk_status) begin
                txstat_data_valid_reg   <= read_txstats;
                rxstat_data_valid_reg   <= read_rxstats;
            end
            assign rxstat_data_valid    = rxstat_data_valid_reg;
            assign txstat_data_valid    = txstat_data_valid_reg;
            assign rxstat_readdata      = 32'd0;
            assign txstat_readdata      = 32'd0;

            assign rxstat_wait_request  = !(read_rxstats || write_rxstats);
            assign txstat_wait_request  = !(read_txstats || write_txstats);
        end
    endgenerate

    alt_e25_cust #(
        .SIM_HURRY              (SIM_HURRY),        // push through the reset delays
        .SIM_SIMPLE_RATE        (SIM_SIMPLE_RATE),  // take a nearby rate to help PLL models
        .SYNOPT_PREAMBLE_PASS   (SYNOPT_PREAMBLE_PASS),
        .SYNOPT_TXCRC_PASS      (SYNOPT_TXCRC_PASS),
        .SYNOPT_RSFEC           (SYNOPT_RSFEC),
        .SIM_SHORT_AM           (SIM_SHORT_AM),
        .SYNOPT_LINK_FAULT      (SYNOPT_LINK_FAULT),
        .SYNOPT_FLOW_CONTROL    (SYNOPT_FLOW_CONTROL),
        .SYNOPT_ENABLE_PTP      (SYNOPT_ENABLE_PTP),
        .SYNOPT_STRICT_SOP      (SYNOPT_STRICT_SOP),        
        .SIM_EMULATE            (SIM_EMULATE)
    ) eth_custom (
        // system resets
        .csr_rst_n          (csr_rst_n),

        .tx_rst_n           (tx_rst_n),
        .rx_rst_n           (rx_rst_n),
        .phy_reset          (phy_reset),

        .tx_stats_aclr      (tx_stats_aclr),
        .rx_stats_aclr      (rx_stats_aclr),
    // PMA
        .rx_bitslip(rx_bitslip),
        .rx_digitalreset(rx_digitalreset),
        .rx_empty(rx_empty),
        .rx_full(rx_full),
        .rx_is_lockedtodata(rx_is_lockedtodata),
        .rx_parallel_data(rx_parallel_data),
        .rx_pempty(rx_pempty),
        .rx_pfull(rx_pfull),
        .rx_seriallpbken(rx_seriallpbken),
        .rx_set_locktodata(rx_set_locktodata),
        .rx_set_locktoref(rx_set_locktoref),
        .tvalid(tvalid),
        .tx_digitalreset(tx_digitalreset),
        .tx_empty(tx_empty),
        .tx_full(tx_full),
        .tx_parallel_data(tx_parallel_data),
        .tx_pempty(tx_pempty),
        .tx_pfull(tx_pfull),

        //Sync clear to adaptor
        .tx_mac_sclr        (tx_mac_sclr),
        .rx_mac_sclr        (rx_mac_sclr),

        //Transceiver clock relationship
        .rx_cdr_refclk      (clk_ref),
        .pll_locked         (tx_pll_locked),

        // tx data
        .tx_clk             (clk_txmac), // @ 390.625
        .tx_clk_stable      (tx_clk_stable),

        //tx interface with adaptor. TBD with Jlee
        .tx_req             (tx_req),
        .tx_valid           (tx_mac_valid),
        .tx_stall           (1'b0),      // Use for pacing when overclocking for PR
        .tx_din             (tx_mac_data), // read left to right
        .tx_sop             (tx_mac_sop),
        .tx_eop             (tx_mac_eop),
        .tx_eeop            (tx_mac_error),
        .tx_mty             (tx_mac_eop_empty), // number of empty bytes in eop word 0..7
        .tx_stats           (l1_txstatus_data),
        .tx_stats_valid     (l1_txstatus_valid),
        .tx_error           (l1_txstatus_error),

        // rx data with adaptor interface
        .rx_clk             (clk_rxmac), // @ 390.625 (remote)
        .rx_clk_stable      (rx_clk_stable),
        .rx_valid           (rx_mac_valid),  // when 0 ignore all others
        .rx_dout            (rx_mac_data), // read left to right
        .rx_sop             (rx_mac_sop),
        .rx_eop             (rx_mac_eop),
        .rx_error           (rx_mac_error),
        .rx_stats           (l1_rxstatus_data),
        .rx_stats_valid     (l1_rxstatus_valid),
        .rx_eeop            (),
        .rx_mty             (rx_mac_eop_empty), // number of empty bytes in eop word 0..7

        .rx_block_lock      (rx_block_lock),
        .rx_am_lock         (rx_am_lock),
        .rx_pcs_ready       (rx_pcs_ready),  // lane alignment lock achieved
        .rx_out_of_rst      (rx_out_of_rst),
        .tx_out_of_rst      (tx_out_of_rst),

        .rx_inc_octetsOK_valid  (rx_inc_octetsOK_valid),
        .rx_inc_octetsOK        (rx_inc_octetsOK),

        // management port
        .csr_reset                  (csr_reset),
        .avmm_clk                   (clk_status),
        .avmm_clk_stable            (~reset_status),
        .avmm_reset                 (reset_status),
        .avmm_write                 (write_cust),
        .avmm_read                  (read_cust),
        .avmm_address               (status_addr),
        .avmm_write_data            (status_writedata),
        .avmm_read_data             (cust_readdata),
        .avmm_read_data_valid       (cust_data_valid),
        .avmm_waitrequest           (cust_waitrequest),

        // Link Fault Status
        .remote_fault_status        (remote_fault_status),
        .local_fault_status         (local_fault_status ),
        .unidirectional_en          (unidirectional_en ),
        .link_fault_gen_en          (link_fault_gen_en ),

        //Flow Control CSR
        .fc_pfc_sel                 (fc_pfc_sel),
        .fc_ena                     (fc_ena),
        .fc_pause_quanta            (fc_pause_quanta),
        .fc_hold_quanta             (fc_hold_quanta),
        .fc_2b_req_mode_sel         (fc_2b_req_mode_sel),
        .fc_2b_req_mode_csr_req_sel (fc_2b_req_mode_csr_req_sel),
        .fc_req0                    (fc_req0),
        .fc_req1                    (fc_req1),
        .fc_dest_addr               (fc_dest_addr),
        .fc_src_addr                (fc_src_addr),
        .fc_tx_off_en               (fc_tx_off_en),
        .fc_rx_pfc_en               (fc_rx_pfc_en),
        .fc_rx_dest_addr            (fc_rx_dest_addr),
        .rx_crc_pt                  (rx_crc_pt),

        //Flow Control control and data
        .tx_off_req                 (tx_off_req),
        .tx_off_ack                 (tx_off_ack),
        .fc_sel                     (fc_sel),
        .fc_din_sop                 (fc_din_sop),
        .fc_din_eop                 (fc_din_eop),
        .fc_din                     (fc_din),
        .fc_din_mty                 (fc_din_mty),
        .fc_din_ready               (fc_din_ready),

        //PTP CSR
        .ptp_tx_clk_period          (ptp_tx_clk_period),
        .ptp_tx_asym_ns             (ptp_tx_asym_ns),
        .ptp_tx_pma_latency         (ptp_tx_pma_latency),
        .ptp_rx_clk_period          (ptp_rx_clk_period),
        .ptp_rx_pma_latency         (ptp_rx_pma_latency),

        //PTP RX signals
        .rx_ptp_sop                 (rx_ptp_sop),
        .rx_ptp_valid               (rx_ptp_valid),
        .rx_ptp_fb_at_lane3         (rx_ptp_fb_at_lane3),

        //data in from TX PTP
        .ptp_in_data                (ptp_in_data),
        .ptp_in_sop                 (ptp_in_sop),
        .ptp_in_eop                 (ptp_in_eop),
        .ptp_in_eop_empty           (ptp_in_eop_empty),
        .ptp_in_error               (ptp_in_error),
        .ptp_in_valid               (ptp_in_valid),

        //data out to TX PTP
        .ptp_out_data               (ptp_out_data),
        .ptp_out_sop                (ptp_out_sop),
        .ptp_out_eop                (ptp_out_eop),
        .ptp_out_eop_empty          (ptp_out_eop_empty),
        .ptp_out_error              (ptp_out_error),
        .ptp_out_valid              (ptp_out_valid),
        .ptp_out_pfc_sel            (ptp_out_pfc_sel),
        .ptp_out_shift              (ptp_out_shift)
    );

    alt_e25_adapter #(
        .SYNOPT_READY_LATENCY   (SYNOPT_READY_LATENCY),
        .WIDTH                  (WIDTH),
        .WORDS                  (WORDS),
        .TARGET_CHIP            (TARGET_CHIP),
        .RXERRWIDTH             (RXERRWIDTH),
        .RXSTATUSWIDTH          (RXSTATUSWIDTH),
        .SYNOPT_ENABLE_PTP      (SYNOPT_ENABLE_PTP)
    ) ast (

      // TX
        .tx_mac_sclr            (tx_mac_sclr),
        .tx_clk_mac             (clk_txmac),            // MAC + PCS clock -390.625Mhz
        .rx_mac_sclr            (rx_mac_sclr),
        .rx_clk_mac             (clk_rxmac),            // MAC + PCS clock -390.625Mhz
        .tx_usr_data            (l1_tx_data),
        .tx_usr_eop_empty       (l1_tx_empty),   //avl_filter removed, not output from avl_filter,  
        .tx_usr_sop             (l1_tx_startofpacket), //avl_filter removed, not output from avl_filter
        .tx_usr_eop             (l1_tx_endofpacket),   //avl_filter removed, not output from avl_filter
        .tx_usr_ready           (l1_tx_ready),
        .tx_usr_valid           (l1_tx_valid),
        .tx_usr_error           (l1_tx_error),
        .tx_mac_data            (tx_mac_data),
        .tx_mac_sop             (tx_mac_sop),
        .tx_mac_eop             (tx_mac_eop),
        .tx_mac_eop_empty       (tx_mac_eop_empty),
        .tx_mac_error           (tx_mac_error),      
        .tx_mac_valid           (tx_mac_valid),
        .tx_mac_ready           (tx_req),
        .rx_usr_data            (l1_rx_data),
        .rx_usr_eop_empty       (l1_rx_empty),
        .rx_usr_sop             (l1_rx_startofpacket),
        .rx_usr_eop             (l1_rx_endofpacket),
        .rx_usr_valid           (l1_rx_valid),
        .rx_usr_error           (l1_rx_error),
        .rx_usr_status          (), // UNUSED
        .rx_mac_data            (rx_mac_data),
        .rx_mac_sop             (rx_mac_sop),
        .rx_mac_eop             (rx_mac_eop),
        .rx_mac_eop_empty       (rx_mac_eop_empty),
        .rx_mac_error           (rx_mac_error),
        .rx_mac_status          ({RXSTATUSWIDTH{1'b0}}), // UNUSED
        .rx_mac_valid           (rx_mac_valid),
        .tx_usr_egress_timestamp_request_valid              (tx_egress_timestamp_request_valid),
        .tx_usr_egress_timestamp_request_fingerprint        (tx_egress_timestamp_request_fingerprint),
        .tx_usr_etstamp_ins_ctrl_timestamp_insert           (tx_etstamp_ins_ctrl_timestamp_insert),
        .tx_usr_etstamp_ins_ctrl_timestamp_format           (tx_etstamp_ins_ctrl_timestamp_format),
        .tx_usr_etstamp_ins_ctrl_residence_time_update      (tx_etstamp_ins_ctrl_residence_time_update),
        .tx_usr_etstamp_ins_ctrl_ingress_timestamp_96b      (tx_etstamp_ins_ctrl_ingress_timestamp_96b),
        .tx_usr_etstamp_ins_ctrl_ingress_timestamp_64b      (tx_etstamp_ins_ctrl_ingress_timestamp_64b),
        .tx_usr_etstamp_ins_ctrl_residence_time_calc_format (tx_etstamp_ins_ctrl_residence_time_calc_format),
        .tx_usr_etstamp_ins_ctrl_checksum_zero              (tx_etstamp_ins_ctrl_checksum_zero),
        .tx_usr_etstamp_ins_ctrl_checksum_correct           (tx_etstamp_ins_ctrl_checksum_correct),
        .tx_usr_etstamp_ins_ctrl_offset_timestamp           (tx_etstamp_ins_ctrl_offset_timestamp),
        .tx_usr_etstamp_ins_ctrl_offset_correction_field    (tx_etstamp_ins_ctrl_offset_correction_field),
        .tx_usr_etstamp_ins_ctrl_offset_checksum_field      (tx_etstamp_ins_ctrl_offset_checksum_field),
        .tx_usr_etstamp_ins_ctrl_offset_checksum_correction (tx_etstamp_ins_ctrl_offset_checksum_correction),
        .tx_usr_egress_asymmetry_update                     (tx_egress_asymmetry_update),
        .tx_mac_egress_timestamp_request_valid              (tx_mac_egress_timestamp_request_valid),
        .tx_mac_egress_timestamp_request_fingerprint        (tx_mac_egress_timestamp_request_fingerprint),
        .tx_mac_etstamp_ins_ctrl_timestamp_insert           (tx_mac_etstamp_ins_ctrl_timestamp_insert),
        .tx_mac_etstamp_ins_ctrl_timestamp_format           (tx_mac_etstamp_ins_ctrl_timestamp_format),
        .tx_mac_etstamp_ins_ctrl_residence_time_update      (tx_mac_etstamp_ins_ctrl_residence_time_update),
        .tx_mac_etstamp_ins_ctrl_ingress_timestamp_96b      (tx_mac_etstamp_ins_ctrl_ingress_timestamp_96b),
        .tx_mac_etstamp_ins_ctrl_ingress_timestamp_64b      (tx_mac_etstamp_ins_ctrl_ingress_timestamp_64b),
        .tx_mac_etstamp_ins_ctrl_residence_time_calc_format (tx_mac_etstamp_ins_ctrl_residence_time_calc_format),
        .tx_mac_etstamp_ins_ctrl_checksum_zero              (tx_mac_etstamp_ins_ctrl_checksum_zero),
        .tx_mac_etstamp_ins_ctrl_checksum_correct           (tx_mac_etstamp_ins_ctrl_checksum_correct),
        .tx_mac_etstamp_ins_ctrl_offset_timestamp           (tx_mac_etstamp_ins_ctrl_offset_timestamp),
        .tx_mac_etstamp_ins_ctrl_offset_correction_field    (tx_mac_etstamp_ins_ctrl_offset_correction_field),
        .tx_mac_etstamp_ins_ctrl_offset_checksum_field      (tx_mac_etstamp_ins_ctrl_offset_checksum_field),
        .tx_mac_etstamp_ins_ctrl_offset_checksum_correction (tx_mac_etstamp_ins_ctrl_offset_checksum_correction),
        .tx_mac_egress_asymmetry_update                     (tx_mac_egress_asymmetry_update)
    );

assign tx_lanes_stable = tx_out_of_rst;

generate if (SYNOPT_FLOW_CONTROL == 1) begin:fc_top
    alt_e25_fc_top #(
        .SYNOPT_PREAMBLE_PASS(SYNOPT_PREAMBLE_PASS),
        .ALLOCATE_4B_CRC(0),
        .WORDS(WORDS),
        .EMPTYBITS(3),
        .RXERRWIDTH(6),
        .NUMPRIORITY(SYNOPT_NUMPRIORITY)
    ) fc_top (
        // Clock & Reset
        .clk_tx(clk_txmac),
        .clk_rx(clk_rxmac),
        .reset_tx_n(~tx_mac_sclr),
        .reset_rx_n(~rx_mac_sclr),

        // Input from CSR
        .cfg_enable(fc_ena),
        .cfg_pfc_sel(fc_pfc_sel),
        .cfg_pause_quanta(fc_pause_quanta[SYNOPT_NUMPRIORITY*16-1:0]),
        .cfg_holdoff_quanta(fc_hold_quanta[SYNOPT_NUMPRIORITY*16-1:0]),
        .cfg_2b_req_mode_sel(fc_2b_req_mode_sel[SYNOPT_NUMPRIORITY-1:0]),
        .cfg_2b_req_mode_csr_req_sel(fc_2b_req_mode_csr_req_sel[SYNOPT_NUMPRIORITY-1:0]),
        .cfg_pause_req0(fc_req0[SYNOPT_NUMPRIORITY-1:0]),
        .cfg_pause_req1(fc_req1[SYNOPT_NUMPRIORITY-1:0]),
        .cfg_tx_saddr(fc_src_addr),
        .cfg_tx_daddr(fc_dest_addr),
        .cfg_rx_daddr(fc_rx_dest_addr),
        .cfg_tx_off_en(fc_tx_off_en),
        .cfg_rx_pfc_en(fc_rx_pfc_en),
        .cfg_rx_crc_pt(rx_crc_pt),

        .tx_din_req(fc_din_ready),
        .rx_data_valid(1'b1),
        .rx_stall(1'b0),

        .tx_off_req(tx_off_req),
        .tx_off_ack(tx_off_ack),
        .fc_sel(fc_sel),
        .fc_sop(fc_din_sop),
        .fc_eop(fc_din_eop),
        .fc_data(fc_din),
        .fc_empty(fc_din_mty),

        .pause_insert_tx0(pause_insert_tx0),
        .pause_insert_tx1(pause_insert_tx1),
        .pause_receive_rx(pause_receive_rx),
        .tx_xoff(), //not connected
        .tx_xon(), //not connected

        // AV-ST input from MAC
        .rx_in_data(l1_rx_data),
        .rx_in_sop(l1_rx_startofpacket),
        .rx_in_eop(l1_rx_endofpacket),
        .rx_in_valid(l1_rx_valid),
        .rx_in_empty(l1_rx_empty),
        .rx_in_error(l1_rx_error)
    );
end else begin
        assign tx_off_req = 1'b0;
        assign fc_sel = 1'b0;
        assign fc_din_sop = 1'b0;
        assign fc_din_eop = 1'b0;
        assign fc_din = 64'b0;
        assign fc_din_mty = 3'b0;
        assign pause_receive_rx = {SYNOPT_NUMPRIORITY{1'b0}};
end
endgenerate

generate if (SYNOPT_ENABLE_PTP) begin:ptp_top
    alt_e25_ptp_top #(
        .PREAMBLE_PASS(SYNOPT_PREAMBLE_PASS),
        .TSTAMP_FP_WIDTH(SYNOPT_TSTAMP_FP_WIDTH),
        .TIME_OF_DAY_FORMAT(SYNOPT_TIME_OF_DAY_FORMAT),
        .TARGET_CHIP(TARGET_CHIP)
    ) ptp_top (
        .tx_clk(clk_txmac),
        .tx_reset_n(~tx_mac_sclr),
        .rx_clk(clk_rxmac),
        .rx_reset_n(~rx_mac_sclr),
        .tx_in_data_extr(tx_mac_data),
        .tx_in_sop_extr(tx_mac_sop),
        .tx_in_eop_extr(tx_mac_eop),
        .tx_in_eop_empty_extr(tx_mac_eop_empty),
        .tx_in_error_extr(tx_mac_error),
        .tx_in_valid_extr(tx_mac_valid),
        .tx_in_ready_extr(tx_req),

        //data out from tx inserter
        .tx_out_data_ins(ptp_in_data),
        .tx_out_sop_ins(ptp_in_sop),
        .tx_out_eop_ins(ptp_in_eop),
        .tx_out_eop_empty_ins(ptp_in_eop_empty),
        .tx_out_error_ins(ptp_in_error),
        .tx_out_valid_ins(ptp_in_valid),

        //data in to tx dly22
        .tx_in_data_dly(ptp_out_data),
        .tx_in_sop_dly(ptp_out_sop),
        .tx_in_eop_dly(ptp_out_eop),
        .tx_in_eop_empty_dly(ptp_out_eop_empty),
        .tx_in_error_dly(ptp_out_error),
        .tx_in_valid_dly(ptp_out_valid),
        .tx_in_pfc_sel_dly(ptp_out_pfc_sel),
        .tx_in_shift_dly(ptp_out_shift),

        //RX SOP signals for timestamping
        .rx_ptp_sop(rx_ptp_sop),
        .rx_ptp_valid(rx_ptp_valid),
        .rx_ptp_fb_at_lane3(rx_ptp_fb_at_lane3),

        //RX SOP signals to read from timestamp FIFO
        .rx_st_sop(l1_rx_startofpacket),
        .rx_st_valid(l1_rx_valid),
        .rx_st_ready(1'b1),

        //User input for 2-step operations
        .tx_egress_timestamp_request_valid(tx_mac_egress_timestamp_request_valid),
        .tx_egress_timestamp_request_fingerprint(tx_mac_egress_timestamp_request_fingerprint),

        // User input for 1-step operations
        .tx_etstamp_ins_ctrl_timestamp_insert(tx_mac_etstamp_ins_ctrl_timestamp_insert),
        .tx_etstamp_ins_ctrl_timestamp_format(tx_mac_etstamp_ins_ctrl_timestamp_format),
        .tx_etstamp_ins_ctrl_residence_time_update(tx_mac_etstamp_ins_ctrl_residence_time_update),
        .tx_etstamp_ins_ctrl_ingress_timestamp_96b(tx_mac_etstamp_ins_ctrl_ingress_timestamp_96b),
        .tx_etstamp_ins_ctrl_ingress_timestamp_64b(tx_mac_etstamp_ins_ctrl_ingress_timestamp_64b),
        .tx_etstamp_ins_ctrl_residence_time_calc_format(tx_mac_etstamp_ins_ctrl_residence_time_calc_format),
        .tx_etstamp_ins_ctrl_checksum_zero(tx_mac_etstamp_ins_ctrl_checksum_zero),
        .tx_etstamp_ins_ctrl_checksum_correct(tx_mac_etstamp_ins_ctrl_checksum_correct),
        .tx_etstamp_ins_ctrl_offset_timestamp(tx_mac_etstamp_ins_ctrl_offset_timestamp),
        .tx_etstamp_ins_ctrl_offset_correction_field(tx_mac_etstamp_ins_ctrl_offset_correction_field),
        .tx_etstamp_ins_ctrl_offset_checksum_field(tx_mac_etstamp_ins_ctrl_offset_checksum_field),
        .tx_etstamp_ins_ctrl_offset_checksum_correction(tx_mac_etstamp_ins_ctrl_offset_checksum_correction),
        .tx_egress_asymmetry_update(tx_mac_egress_asymmetry_update),

        // User output for fingerprint and timestamp
        .tx_egress_timestamp_96b_valid(tx_egress_timestamp_96b_valid),
        .tx_egress_timestamp_96b_data(tx_egress_timestamp_96b_data),
        .tx_egress_timestamp_96b_fingerprint(tx_egress_timestamp_96b_fingerprint),
        .tx_egress_timestamp_64b_valid(tx_egress_timestamp_64b_valid),
        .tx_egress_timestamp_64b_data(tx_egress_timestamp_64b_data),
        .tx_egress_timestamp_64b_fingerprint(tx_egress_timestamp_64b_fingerprint),

        //rx ingress timestamp
        .rx_ingress_timestamp_96b_valid(rx_ingress_timestamp_96b_valid),
        .rx_ingress_timestamp_96b_data(rx_ingress_timestamp_96b_data),
        .rx_ingress_timestamp_64b_valid(rx_ingress_timestamp_64b_valid),
        .rx_ingress_timestamp_64b_data(rx_ingress_timestamp_64b_data),

        // CSR Configuration Input
        .tx_asymmetry_reg(ptp_tx_asym_ns),
        .tx_pma_delay_reg(ptp_tx_pma_latency),
        .rx_pma_delay_reg(ptp_rx_pma_latency),
        .tx_period(ptp_tx_clk_period),
        .rx_period(ptp_rx_clk_period),

        //Path Delay data
        .tx_path_delay_data(tx_path_delay_data),
        .rx_path_delay_data(rx_path_delay_data),

        // Inputs from ToD
        .tx_time_of_day_96b_data(tx_time_of_day_96b_data),
        .tx_time_of_day_64b_data(tx_time_of_day_64b_data),
        .rx_time_of_day_96b_data(rx_time_of_day_96b_data),
        .rx_time_of_day_64b_data(rx_time_of_day_64b_data)
    );
end else begin
    assign tx_egress_timestamp_96b_valid = 1'h0;
    assign tx_egress_timestamp_96b_data = 96'h0;
    assign tx_egress_timestamp_96b_fingerprint = {SYNOPT_TSTAMP_FP_WIDTH{1'h0}};
    assign tx_egress_timestamp_64b_valid = 1'h0; 
    assign tx_egress_timestamp_64b_data = 64'h0;
    assign tx_egress_timestamp_64b_fingerprint = {SYNOPT_TSTAMP_FP_WIDTH{1'h0}};
    assign rx_ingress_timestamp_96b_valid = 1'h0;
    assign rx_ingress_timestamp_96b_data = 96'h0;
    assign rx_ingress_timestamp_64b_valid = 1'h0;
    assign rx_ingress_timestamp_64b_data = 64'h0;
end
endgenerate

endmodule
