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


`timescale 1ps/1ps

module alt_e25_cust #(
    parameter SIM_HURRY = 1'b0, // push through the reset delays
    parameter SIM_SIMPLE_RATE = 1'b0, // take a nearby rate to help PLL models
    parameter SIM_SHORT_AM = 1'b0, // shorten the AM interval to lock faster
    parameter SYNOPT_PREAMBLE_PASS = 1'b0,
    parameter SYNOPT_TXCRC_PASS = 1'b0,
    parameter SYNOPT_RSFEC         = 0,
    parameter SYNOPT_LINK_FAULT    = 1'b0,
    parameter SYNOPT_FLOW_CONTROL    = 1'b0,
    parameter SYNOPT_ENABLE_PTP = 1'b0,
    parameter SYNOPT_STRICT_SOP         = 1'b0,
    parameter SIM_EMULATE = 1'b0
) (
    // Resets & Reset Status
    input           csr_rst_n,
    input           tx_rst_n,
    input           rx_rst_n,
    output          tx_mac_sclr,
    output          rx_mac_sclr,
    output          rx_out_of_rst,
    output          tx_out_of_rst,

    output          tx_stats_aclr,
    output          rx_stats_aclr,

    // Clocks & Clock Status
    input           pll_locked,
    input           rx_cdr_refclk,
    input           tx_clk,         // @ 390.625 (ref)
    input           tx_clk_stable,
    input           rx_clk,         // @ 390.625 (remote)
    input           rx_clk_stable,

    // PMA Interface
    output         rx_bitslip,
    input          rx_digitalreset,
    input          rx_empty,
    input          rx_full,
    input          rx_is_lockedtodata,
    input   [65:0] rx_parallel_data,
    input          rx_pempty,
    input          rx_pfull,
    output         rx_seriallpbken,
    output         rx_set_locktodata,
    output         rx_set_locktoref,
    output         tvalid,
    input          tx_digitalreset,
    input          tx_empty,
    input          tx_full,
    output  [65:0] tx_parallel_data,
    input          tx_pempty,
    input          tx_pfull,
    output         phy_reset,

    // Transmit Interface
    output  tx_req,
    input   [63:0] tx_din,
    input   tx_sop,
    input   tx_eop,
    input   tx_eeop,
    input   [2:0] tx_mty, // number of empty bytes in eop word 0..7
    input   tx_valid,
    input   tx_stall, // Stall pipeline to support overclocking

    output  [39:0] tx_stats,
    output         tx_stats_valid,
    output  [6:0]  tx_error,

    // rx data
    output  rx_valid,
    output  [63:0] rx_dout,
    output   rx_sop,
    output   rx_eop,
    output   rx_eeop,
    output   [2:0] rx_mty, // number of empty bytes in eop word 0..7

    // rx status
    output  [5:0]   rx_error,
    output  [39:0]  rx_stats,
    output          rx_stats_valid,
    output  [15:0]  rx_inc_octetsOK,
    output          rx_inc_octetsOK_valid,
    output          rx_block_lock,
    output          rx_am_lock,
    output          rx_pcs_ready,

    // Avalon MM Interface
    output              csr_reset,
    input               avmm_clk,
    input               avmm_clk_stable,
    input               avmm_reset,
    input               avmm_write,
    input               avmm_read,
    input       [15:0]  avmm_address,
    input       [31:0]  avmm_write_data,
    output reg  [31:0]  avmm_read_data,
    output              avmm_read_data_valid,
    output reg          avmm_waitrequest,

    //Link Fault Status
    output          remote_fault_status,
    output          local_fault_status,
    output          unidirectional_en,
    output          link_fault_gen_en,

    //Flow Control CSR
    output         fc_pfc_sel,
    output [7:0]   fc_ena,
    output [127:0] fc_pause_quanta,
    output [127:0] fc_hold_quanta,
    output [7:0]   fc_2b_req_mode_sel,
    output [7:0]   fc_2b_req_mode_csr_req_sel,
    output [7:0]   fc_req0,
    output [7:0]   fc_req1,
    output [47:0]  fc_dest_addr,
    output [47:0]  fc_src_addr,
    output         fc_tx_off_en,
    output [7:0]   fc_rx_pfc_en,
    output [47:0]  fc_rx_dest_addr,
    output         rx_crc_pt,

    //Flow Control control and data
    input         tx_off_req,
    output        tx_off_ack,
    input         fc_sel,
    input         fc_din_sop,
    input         fc_din_eop,
    input [63:0]  fc_din,
    input [2:0]   fc_din_mty,
    output        fc_din_ready,

    //PTP CSR
    output [19:0] ptp_tx_clk_period,
    output [18:0] ptp_tx_asym_ns,
    output [31:0] ptp_tx_pma_latency,
    output [19:0] ptp_rx_clk_period,
    output [31:0] ptp_rx_pma_latency,

    //PTP RX signals
    output rx_ptp_sop,
    output rx_ptp_valid,
    output rx_ptp_fb_at_lane3,

    //data in from TX PTP
    input [63:0] ptp_in_data,
    input        ptp_in_sop,
    input        ptp_in_eop,
    input [2:0]  ptp_in_eop_empty,
    input        ptp_in_error,
    input        ptp_in_valid,

    //data out to TX PTP
    output [63:0] ptp_out_data,
    output        ptp_out_sop,
    output        ptp_out_eop,
    output [2:0]  ptp_out_eop_empty,
    output        ptp_out_error,
    output        ptp_out_valid,
    output        ptp_out_pfc_sel,
    output        ptp_out_shift
);

genvar i;

///////////////////////////////////////
// Reset logic
//

wire        soft_txp_rst, soft_rxp_rst, eio_sys_rst;
wire        tx_pcs_sclr, rx_pcs_sclr;
wire rxpcs_dout_word_locked;

// Used to clear the MAC stats counters memory
assign tx_stats_aclr = ~csr_rst_n || ~tx_rst_n || soft_txp_rst;
assign rx_stats_aclr = ~csr_rst_n || ~rx_rst_n || soft_rxp_rst;


alt_e25_reset rst (
    // clocks
    .avmm_clk               (avmm_clk),
    .tx_clk                 (tx_clk),
    .rx_clk                 (rx_clk),

    // external resets
    .csr_rst                (~csr_rst_n),
    .tx_rst                 (~tx_rst_n),
    .rx_rst                 (~rx_rst_n),

    // status input signals
    .avmm_clk_stable        (avmm_clk_stable),
    .rx_pcs_ready_in        (rxpcs_dout_word_locked),
    .rx_pcs_ready_out       (rx_pcs_ready),

    // soft resets
    .soft_txp_rst           (soft_txp_rst),
    .soft_rxp_rst           (soft_rxp_rst),
    .eio_sys_rst            (eio_sys_rst),

    // outputs
    .phy_reset              (phy_reset),
    .csr_rst_out            (csr_reset),
    .tx_digitalreset        (tx_digitalreset),
    .rx_digitalreset        (rx_digitalreset),
    .tx_out_of_rst          (tx_out_of_rst),
    .rx_out_of_rst          (rx_out_of_rst),

    .tx_mac_sclr            (tx_mac_sclr),
    .tx_pcs_sclr            (tx_pcs_sclr),
    .rx_mac_sclr            (rx_mac_sclr),
    .rx_pcs_sclr            (rx_pcs_sclr)

);
defparam rst .SIM_EMULATE = SIM_EMULATE;
defparam rst .SIM_HURRY = SIM_HURRY;

reg tvalid_reg = 1'b0;

always @(posedge tx_clk)
    tvalid_reg   <=  ~tx_mac_sclr;

assign tvalid = tvalid_reg;

//////////////////////////////////////
// TX RSFEC
wire bypass_tx_rsfec;
wire bypass_rx_rsfec;
wire txpcs_dout_am;
wire txpcs_dout_valid;

  wire       err_ins_done;
  wire       err_ins_enable;
  wire       err_ins_en_1cw;
  wire [6:0] group_num;
  wire [7:0] sym_mask;
  wire [9:0] bit_mask;
  reg [65:0] txpcs_dout_xor;

generate
if (SYNOPT_RSFEC) begin : TXFEC

  wire [65:0] txfec_dout;
  reg        rxfec_din_am;
  reg        rxfec_din_valid;

  always @(posedge tx_clk) begin
    rxfec_din_am     <= txpcs_dout_am;
  end
  always @(posedge tx_clk) begin
    if (tx_pcs_sclr) begin
      rxfec_din_valid <= 0;
    end else if (txpcs_dout_am) begin
      rxfec_din_valid  <= txpcs_dout_valid;
    end
  end

  alt_e25_rs_tx tx_rsfec (
    .amstart_in (rxfec_din_am),
    .din_pcs    (txpcs_dout_xor),
    .valid_in   (rxfec_din_valid),
    .clk        (tx_clk),
    .sreset     (tx_pcs_sclr),
    .dout_pma   (tx_parallel_data),
    .valid_out  (),

    .err_ins_done      (err_ins_done),
    .err_ins_enable    (err_ins_enable),
    .err_ins_enable_for_one_cw  (err_ins_en_1cw),
    .group_num         (group_num),
    .sym_mask          (sym_mask),
    .bit_mask          (bit_mask),
    .bypass_rsfec      (bypass_tx_rsfec)
  );

end else begin  // no RSFEC mode
    assign tx_parallel_data = txpcs_dout_xor;
  end
endgenerate


//////////////////////////////////////
// TX PCS

wire [63:0] txpcs_din_d;
wire [7:0] txpcs_din_c;
wire txpcs_din_am;
wire txpcs_din_stall;
wire txpcs_din_valid;
wire [65:0] txpcs_dout;

wire tx_ber_inject = 1'b0;

wire tx_ber_inject_rise;
alt_e2550_xrise1r3 xr0 (
    .din_clk(avmm_clk),
    .din(tx_ber_inject),
    .dout_clk(tx_clk),
    .dout(tx_ber_inject_rise)
);
defparam xr0 .SIM_EMULATE = SIM_EMULATE;

always @(posedge tx_clk) txpcs_dout_xor[65:0] <= txpcs_dout[65:0] ^ {65'h0, tx_ber_inject_rise};

wire txmac_dout_stall;
wire txmac_dout_am;
wire txmac_dout_valid;
assign txpcs_din_stall = txmac_dout_stall;
assign txpcs_din_am    = txmac_dout_am;
assign txpcs_din_valid = txmac_dout_valid;

alt_e25_epcs_t ep_t (
    .clk            (tx_clk),
    .din_sclr       (tx_pcs_sclr),
    .din_c          (txpcs_din_c),
    .din_d          (txpcs_din_d),
    .din_stall      (txpcs_din_stall),
    .din_am         (txpcs_din_am),
    .din_valid      (txpcs_din_valid),
    .dout           (txpcs_dout),
    .dout_am        (txpcs_dout_am),
    .dout_valid     (txpcs_dout_valid)
);
defparam ep_t .SYNOPT_RSFEC = SYNOPT_RSFEC;
defparam ep_t .SIM_EMULATE = SIM_EMULATE;

//////////////////////////////////////
// TX MAC

wire [63:0] txmac_dout_d;
wire [7:0] txmac_dout_c;

wire din_ready;
wire [63:0] din;
wire din_sop;
wire din_eop;
wire din_eeop;
wire [2:0] din_mty; // number of empty bytes in eop word 0..7
wire din_valid;
wire din_stall;
wire [15:0] tx_max_frm_length;
wire tx_cfg_vlandet_disable;
wire [2:0]  tx_frm_error;

wire tx_mac_lf_cfg_linkfault_rpt_en;
wire tx_mac_lf_cfg_unidir_en       ;
wire tx_mac_lf_cfg_disable_rf      ;
wire tx_mac_lf_cfg_force_rf        ;
assign  unidirectional_en = tx_mac_lf_cfg_unidir_en;
assign  link_fault_gen_en = tx_mac_lf_cfg_linkfault_rpt_en;

alt_e25_mac_tx em_t (
    .sclr           (tx_mac_sclr),
    .bypass_rsfec   (bypass_tx_rsfec),
    .clk            (tx_clk),
    .din            (din),
    .din_sop        (din_sop),
    .din_eop        (din_eop),
    .din_eeop       (din_eeop),
    .din_mty        (din_mty),
    .din_valid      (din_valid),
    .din_stall      (din_stall),
    .din_ready      (din_ready),
    .fc_sel         (fc_sel),
    .fc_din         (fc_din),
    .fc_din_sop     (fc_din_sop),
    .fc_din_eop     (fc_din_eop),
    .fc_din_mty     (fc_din_mty),
    .fc_din_ready   (fc_din_ready),
    .tx_off_req     (tx_off_req),
    .tx_off_ack     (tx_off_ack),
    .dout_d         (txmac_dout_d),
    .dout_c         (txmac_dout_c),

    .dout_stall     (txmac_dout_stall),
    .dout_am        (txmac_dout_am),
    .dout_valid     (txmac_dout_valid),

    .cfg_max_frm_length     (tx_max_frm_length),
    .cfg_vlandet_disable    (tx_cfg_vlandet_disable),
    .tx_stats               (tx_stats),
    .tx_stats_valid         (tx_stats_valid),
    .tx_frm_error           (tx_frm_error),

    //data in from ptp
    .ptp_in_data        (ptp_in_data),
    .ptp_in_sop         (ptp_in_sop),
    .ptp_in_eop         (ptp_in_eop),
    .ptp_in_eop_empty   (ptp_in_eop_empty),
    .ptp_in_error       (ptp_in_error),
    .ptp_in_valid       (ptp_in_valid),

    //data out to ptp
    .ptp_out_data       (ptp_out_data),
    .ptp_out_sop        (ptp_out_sop),
    .ptp_out_eop        (ptp_out_eop),
    .ptp_out_eop_empty  (ptp_out_eop_empty),
    .ptp_out_error      (ptp_out_error),
    .ptp_out_valid      (ptp_out_valid),
    .ptp_out_pfc_sel    (ptp_out_pfc_sel),
    .ptp_out_shift      (ptp_out_shift),

     //link fault related inputs
    .tx_mac_lf_cfg_linkfault_rpt_en (tx_mac_lf_cfg_linkfault_rpt_en),
    .tx_mac_lf_cfg_unidir_en        (tx_mac_lf_cfg_unidir_en       ),
    .tx_mac_lf_cfg_disable_rf       (tx_mac_lf_cfg_disable_rf      ),
    .tx_mac_lf_cfg_force_rf         (tx_mac_lf_cfg_force_rf        ),
    .remote_fault_status            (remote_fault_status           ),
    .local_fault_status             (local_fault_status            )
);
defparam em_t .SYNOPT_RSFEC = SYNOPT_RSFEC;
defparam em_t .SIM_SHORT_AM = SIM_SHORT_AM;
defparam em_t .SIM_EMULATE = SIM_EMULATE;
defparam em_t .SYNOPT_PREAMBLE_PASS = SYNOPT_PREAMBLE_PASS;
defparam em_t .SYNOPT_TXCRC_PASS = SYNOPT_TXCRC_PASS;
defparam em_t .SYNOPT_LINK_FAULT    = SYNOPT_LINK_FAULT;
defparam em_t .SYNOPT_FLOW_CONTROL  = SYNOPT_FLOW_CONTROL;
defparam em_t .SYNOPT_ENABLE_PTP  = SYNOPT_ENABLE_PTP;

assign tx_error = {4'b0000, tx_frm_error};

// switch from MAC (read left to right) to PCS (bit 0 first)
generate
    for (i=0; i<8; i=i+1) begin : rolp0
        assign txpcs_din_d[((7-i)+1)*8-1:(7-i)*8] = txmac_dout_d[(i+1)*8-1:i*8];
        assign txpcs_din_c[7-i] = txmac_dout_c[i];
    end
endgenerate

assign din = tx_din;
assign din_sop = tx_sop;
assign din_eop = tx_eop;
assign din_eeop = tx_eeop;
assign din_mty = tx_mty;
assign din_valid = tx_valid;
assign din_stall = tx_stall;
assign tx_req = din_ready;

//////////////////////////////////////
// RX RSFEC
wire [65:0] rxfec_dout;
wire        pcs_bitslip;
wire        rxfec_dout_am;
wire        rxfec_dout_valid;
wire        rxpcs_din_valid;

  wire fec_align_status;
  wire corr_cw_inc;
  wire uncorr_cw_inc;
  wire fec_sync_restarted;
  wire bypass_err_corr;
  wire restart_fec_sync;

generate
if (SYNOPT_RSFEC) begin : RXFEC

  wire bitslip_out_to_pma;
  alt_e25_rs_rx rx_rsfec (
    .din_pma     (rx_parallel_data),
    .valid_in    (1'b1),  // Only active for PR designs
    .clk         (rx_clk),
    .sreset      (rx_pcs_sclr),
    .dout_pcs    (rxfec_dout),
    .valid_out_pcs      (rxfec_dout_valid),
    .amcode_start_out   (rxfec_dout_am),
    .bitslip_out_to_pma (bitslip_out_to_pma),

    .fec_align_status        (fec_align_status),
    .corrected_cw_inc        (corr_cw_inc),
    .uncorrected_cw_inc      (uncorr_cw_inc),
    .fec_sync_restarted      (fec_sync_restarted),
    .bypass_error_correction (bypass_err_corr),
    .restart_fec_sync        (restart_fec_sync),
    .bypass_rsfec            (bypass_rx_rsfec)
  );
  defparam rx_rsfec .SIM_SHORT_AM = SIM_SHORT_AM;

  assign rxpcs_din_valid = rxfec_dout_valid & ~rxfec_dout_am;

  // Use PCS bitslip if RSFEC is bypassed through CSR
  assign rx_bitslip = bypass_rx_rsfec?  pcs_bitslip : bitslip_out_to_pma;

end else begin  // no RSFEC mode
    assign rxfec_dout      = rx_parallel_data;
    assign rx_bitslip      = pcs_bitslip;
    assign rxpcs_din_valid = 1'b1;
  end
endgenerate


//////////////////////////////////////
// RX PCS

wire [65:0] rxpcs_din = rxfec_dout;
wire rxpcs_frm_err_sclr;
wire rxpcs_dout_sticky_frm_err;
wire [63:0] rxpcs_dout_d;
wire [7:0] rxpcs_dout_c;
wire rxpcs_dout_valid;
wire        rx_fifo_soft_purge;
wire hi_ber_raw;

alt_e25_epcs_r ep_r (
    .clk                (rx_clk),
    .din                (rxpcs_din),
    .din_valid          (rxpcs_din_valid),
    .csr_rst_n          (csr_rst_n),
    .dout_sclr          (rx_pcs_sclr),
    .dout_sclr_err      (rxpcs_frm_err_sclr),
    .dout_sticky_frm_err(rxpcs_dout_sticky_frm_err),
    .dout_word_locked   (rxpcs_dout_word_locked),
    .purge_req          (pcs_bitslip),
    .dout_c             (rxpcs_dout_c),
    .dout_d             (rxpcs_dout_d),
    .dout_valid         (rxpcs_dout_valid),
    .hi_ber             (hi_ber_raw) // connect to csr
);
defparam ep_r .SIM_EMULATE = SIM_EMULATE;
defparam ep_r .SYNOPT_LINK_FAULT = SYNOPT_LINK_FAULT;

//////////////////////////////////////
// RX MAC

wire [63:0] rxmac_din_d;
wire [7:0] rxmac_din_c;
wire rxmac_din_valid;

// switch from PCS (bit 0 first) to MAC (read left to right)
generate
    for (i=0; i<8; i=i+1) begin : rolp1
        assign rxmac_din_d[((7-i)+1)*8-1:(7-i)*8] = rxpcs_dout_d[(i+1)*8-1:i*8];
        assign rxmac_din_c[7-i] = rxpcs_dout_c[i];
    end
endgenerate

assign rxmac_din_valid = rxpcs_dout_valid;

wire [63:0] dout; // read left to right
wire dout_sop;
wire dout_eop;
wire dout_eeop;
wire [2:0] dout_mty; // number of empty bytes in eop word 0..7
wire dout_valid;
wire [15:0] rx_max_frm_length;
wire rx_cfg_vlandet_disable;

wire cfg_sfd_det_on;
wire cfg_preamble_det_on;

alt_e25_emac_r em_r (
    .clk            (rx_clk),
    .sclr           (rx_mac_sclr),
    .csr_rst_n      (csr_rst_n),
    .rx_crc_pt      (rx_crc_pt),
    .din_d          (rxmac_din_d),
    .din_c          (rxmac_din_c),
    .din_valid      (rxmac_din_valid),
    .dout           (dout),
    .dout_sop       (dout_sop),
    .dout_eop       (dout_eop),
    .dout_eeop      (dout_eeop),
    .dout_eeopst    (), // Not connected for now; indicates CRC is stomped
    .dout_mty       (dout_mty),
    .dout_valid     (dout_valid),
    .rx_error               (rx_error),
    .rx_inc_octetsOK        (rx_inc_octetsOK),
    .rx_inc_octetsOK_valid  (rx_inc_octetsOK_valid),
    .rx_stats               (rx_stats),
    .rx_statsvalid          (rx_stats_valid),
    .cfg_max_frm_length     (rx_max_frm_length),
    .cfg_vlandet_disable    (rx_cfg_vlandet_disable),

    .cfg_sfd_det_on         (cfg_sfd_det_on),
    .cfg_preamble_det_on    (cfg_preamble_det_on),

    //link fault status output
    .remote_fault_status    (remote_fault_status),
    .local_fault_status     (local_fault_status ),

    //ptp output
    .ptp_sop(rx_ptp_sop),
    .ptp_valid(rx_ptp_valid),
    .ptp_fb_at_lane3(rx_ptp_fb_at_lane3)

);
defparam em_r .SIM_EMULATE = SIM_EMULATE;
defparam em_r .SYNOPT_PREAMBLE_PASS = SYNOPT_PREAMBLE_PASS;
defparam em_r .SYNOPT_LINK_FAULT    = SYNOPT_LINK_FAULT;
defparam em_r .SYNOPT_STRICT_SOP    = SYNOPT_STRICT_SOP;

assign rx_dout = dout;
assign rx_sop = dout_sop;
assign rx_eop = dout_eop;
assign rx_eeop = dout_eeop;
assign rx_mty = dout_mty;
assign rx_valid = dout_valid;

// --------------------
//   AVMM decoding
// --------------------

wire [31:0] csr_read_data;
wire [31:0] fec_txrd_data;
wire [31:0] fec_rxrd_data;

reg csr_sel;
reg fec_tx_sel;
reg fec_rx_sel;
reg other_sel;

wire    csr_read        = csr_sel && avmm_read;
wire    csr_write       = csr_sel && avmm_write;
wire    fec_tx_write    = fec_tx_sel && avmm_write;
wire    fec_rx_write    = fec_rx_sel && avmm_write;
wire    fec_tx_rd       = fec_tx_sel && avmm_read;
wire    fec_rx_rd       = fec_rx_sel && avmm_read;
wire    other_read      = other_sel && avmm_read;
wire    other_write     = other_sel && avmm_write;

wire    csr_waitrequest;
wire    fec_tx_waitrequest  = !(fec_tx_rd || fec_tx_write);
wire    fec_rx_waitrequest  = !(fec_rx_rd || fec_rx_write);

wire    csr_readdatavalid;
wire    fec_txrd_dval;
wire    fec_rxrd_dval;
reg     other_readdatavalid;

always @(posedge avmm_clk) other_readdatavalid <= other_read;
assign avmm_read_data_valid = fec_txrd_dval || fec_rxrd_dval || csr_readdatavalid || other_readdatavalid;

always @(*) begin
    csr_sel       = 1'b0;
    fec_tx_sel    = 1'b0;
    fec_rx_sel    = 1'b0;
    other_sel     = 1'b0;
    casez (avmm_address)
        16'b0000_0011_????_???? : csr_sel       = 1'b1; // 0x0300-0x0BFF
        16'b0000_0100_????_???? : csr_sel       = 1'b1;
        16'b0000_0101_????_???? : csr_sel       = 1'b1;
        16'b0000_0110_????_???? : csr_sel       = 1'b1;
        16'b0000_0111_????_???? : csr_sel       = 1'b1;
        16'b0000_1000_????_???? : csr_sel       = 1'b1;
        16'b0000_1001_????_???? : csr_sel       = 1'b1;
        16'b0000_1010_????_???? : csr_sel       = 1'b1;
        16'b0000_1011_????_???? : csr_sel       = 1'b1;
        16'b0000_1100_0000_0??? : fec_tx_sel    = 1'b1; // 0x0C00-0x0C07
        16'b0000_1101_0000_0??? : fec_rx_sel    = 1'b1; // 0x0D00-0x0D07
        default                 : other_sel     = 1'b1;
    endcase
end

always @(*) begin
    case(1'b1)
        csr_readdatavalid   : avmm_read_data  = csr_read_data;
        fec_txrd_dval       : avmm_read_data  = fec_txrd_data;
        fec_rxrd_dval       : avmm_read_data  = fec_rxrd_data;
        default             : avmm_read_data  = 32'hdeadc0de;
    endcase
end

always @(*) begin
    case(1'b1)
        csr_sel     : avmm_waitrequest = csr_waitrequest;
        fec_tx_sel  : avmm_waitrequest = fec_tx_waitrequest;
        fec_rx_sel  : avmm_waitrequest = fec_rx_waitrequest;
        default     : avmm_waitrequest = 1'b0;
    endcase
end

//////////////////////////////////////
// CSR Block
//
//

alt_e25_csr csr(
    // Clocks
    .csr_clk                (avmm_clk),
    .tx_clk                 (tx_clk),
    .rx_clk                 (rx_clk),
    .cdr_ref_clk            (rx_cdr_refclk),

    // AVMMM Interface
    .reset                  (csr_reset),
    .write                  (csr_write),
    .read                   (csr_read),
    .address                (avmm_address),
    .data_in                (avmm_write_data),
    .data_out               (csr_read_data),
    .data_valid             (csr_readdatavalid),
    .waitrequest            (csr_waitrequest),

    // Reset outputs
    .soft_txp_rst           (soft_txp_rst),
    .soft_rxp_rst           (soft_rxp_rst),
    .eio_sys_rst            (eio_sys_rst),


    // RX status in
    .rx_pempty              (rx_pempty),
    .rx_pfull               (rx_pfull),
    .rx_empty               (rx_empty),
    .rx_full                (rx_full),
    .rxpcs_frm_err          (rxpcs_dout_sticky_frm_err),
    .rx_is_lockedtodata     (rx_is_lockedtodata),
    .rx_deskew_locked       (rx_pcs_ready), // Set to word locked
    .rx_hi_ber              (hi_ber_raw),             // Meaningful only when linkfault is enabled, from alt_e25_epcs_r

    //Rx Link Fault Status
    .local_fault_status    (local_fault_status ),
    .remote_fault_status   (remote_fault_status),


    //RX strict preamble check
    .cfg_sfd_det_on         (cfg_sfd_det_on),
    .cfg_preamble_det_on    (cfg_preamble_det_on),

    // RX Status and Control Out
    .rx_clk_stable          (rx_clk_stable),
    .rxpcs_frm_err_sclr     (rxpcs_frm_err_sclr),
    .rx_fifo_soft_purge     (), // WILL NEED THIS LATER
    .rx_seriallpbken        (rx_seriallpbken),
    .rx_set_locktoref       (rx_set_locktoref),
    .rx_set_locktodata      (rx_set_locktodata),
    .rx_crc_pt              (rx_crc_pt),

    // Stats Vector
    .tx_vlandet_disable     (tx_cfg_vlandet_disable),
    .rx_vlandet_disable     (rx_cfg_vlandet_disable),
    .tx_max_frm_length      (tx_max_frm_length),
    .rx_max_frm_length      (rx_max_frm_length),


    // TX status in
    .tx_pempty              (tx_pempty),
    .tx_pfull               (tx_pfull),
    .tx_empty               (tx_empty),
    .tx_full                (tx_full),
    .tx_pll_locked          (pll_locked),
    .tx_digitalreset        (tx_digitalreset),

    // TX Status and Control Out
    .tx_crc_pt              (),
    .tx_clk_stable          (tx_clk_stable),

    // TX Mac Link Fault Config
    .tx_mac_lf_cfg_linkfault_rpt_en  (tx_mac_lf_cfg_linkfault_rpt_en),
    .tx_mac_lf_cfg_unidir_en         (tx_mac_lf_cfg_unidir_en       ),
    .tx_mac_lf_cfg_disable_rf        (tx_mac_lf_cfg_disable_rf      ),
    .tx_mac_lf_cfg_force_rf          (tx_mac_lf_cfg_force_rf        ),

    //Flow Control
    .fc_pfc_sel(fc_pfc_sel),
    .fc_ena(fc_ena),
    .fc_pause_quanta(fc_pause_quanta),
    .fc_hold_quanta(fc_hold_quanta),
    .fc_2b_req_mode_sel(fc_2b_req_mode_sel),
    .fc_2b_req_mode_csr_req_sel(fc_2b_req_mode_csr_req_sel),
    .fc_req0(fc_req0),
    .fc_req1(fc_req1),
    .fc_dest_addr(fc_dest_addr),
    .fc_src_addr(fc_src_addr),
    .fc_tx_off_en(fc_tx_off_en),
    .fc_rx_pfc_en(fc_rx_pfc_en),
    .fc_rx_dest_addr(fc_rx_dest_addr),

    //PTP
    .ptp_tx_clk_period(ptp_tx_clk_period),
    .ptp_tx_asym_ns(ptp_tx_asym_ns),
    .ptp_tx_pma_latency(ptp_tx_pma_latency),
    .ptp_rx_clk_period(ptp_rx_clk_period),
    .ptp_rx_pma_latency(ptp_rx_pma_latency)
);
defparam csr .SIM_EMULATE = SIM_EMULATE;


//////////////////////////////////////
// RSFEC CSRs

generate
    if (SYNOPT_RSFEC) begin : FEC_CSR
        alt_e25_tx_rsfec_regs tx_fec_csr (
            .csr_clk                    (avmm_clk),
            .csr_reset                  (csr_reset),
            .csr_writedata              (avmm_write_data),
            .csr_read                   (fec_tx_rd),
            .csr_write                  (fec_tx_write),
            .csr_byteenable             (4'hF),  // always access as 32-bits
            .csr_readdata               (fec_txrd_data),
            .csr_readdatavalid          (fec_txrd_dval),
            .csr_address                (avmm_address[2:0]),

            .rs_tx_clk                  (tx_clk),
            .rs_rx_clk                  (rx_clk),
            .err_ins_done               (err_ins_done),
            .err_ins_enable             (err_ins_enable),
            .err_ins_enable_for_one_cw  (err_ins_en_1cw),
            .group_num                  (group_num),
            .sym_mask                   (sym_mask),
            .bit_mask                   (bit_mask),
            .bypass_tx_rsfec            (bypass_tx_rsfec),
            .bypass_rx_rsfec            (bypass_rx_rsfec)
        );

        alt_e25_rx_rsfec_regs rx_fec_csr (
            .csr_clk                    (avmm_clk),
            .csr_reset                  (csr_reset),
            .csr_writedata              (avmm_write_data),
            .csr_read                   (fec_rx_rd),
            .csr_write                  (fec_rx_write),
            .csr_byteenable             (4'hF),  // always access as 32-bits
            .csr_readdata               (fec_rxrd_data),
            .csr_readdatavalid          (fec_rxrd_dval),
            .csr_address                (avmm_address[2:0]),

            .rs_clk                     (rx_clk),
            .fec_align_status           (fec_align_status),
            .corrected_cw_inc           (corr_cw_inc),
            .uncorrected_cw_inc         (uncorr_cw_inc),
            .fec_sync_restarted         (fec_sync_restarted),
            .bypass_error_correction    (bypass_err_corr),
            .restart_fec_sync           (restart_fec_sync)
        );
    end else begin
        reg fec_txrd_dval_reg;
        reg fec_rxrd_dval_reg;
        always @(posedge avmm_clk) begin
            fec_txrd_dval_reg <= fec_tx_rd;
            fec_rxrd_dval_reg <= fec_rx_rd;
        end
        assign  fec_txrd_dval = fec_txrd_dval_reg;
        assign  fec_rxrd_dval = fec_rxrd_dval_reg;
        assign fec_txrd_data = 32'hdeadc0de;
        assign fec_rxrd_data = 32'hdeadc0de;
    end
endgenerate


assign  rx_block_lock   = rx_pcs_ready;
assign  rx_am_lock      = rx_block_lock; // Block lock is the only locking needed

endmodule
