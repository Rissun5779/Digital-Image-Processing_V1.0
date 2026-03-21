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
// fkhan 04/2015

module alt_e50_cust #(
    parameter SIM_HURRY                 = 1'b0, // push through the reset delays
    parameter SIM_SIMPLE_RATE           = 1'b0, // take a nearby rate to help PLL models
    parameter SIM_SHORT_AM              = 1'b0, // shorten the AM interval to lock faster
    parameter SIM_EMULATE               = 1'b0,
    parameter SYNOPT_DIV40              = 1'b0,
    parameter SYNOPT_PREAMBLE_PASS      = 1'b0,
    parameter SYNOPT_TXCRC_PASS         = 1'b0,
    parameter SYNOPT_LINK_FAULT         = 1'b0,
    parameter SYNOPT_STRICT_SOP         = 1'b0,
    parameter SYNOPT_FLOW_CONTROL       = 1'b0
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
    input [1:0]     tx_serial_clk,
    input           pll_locked,
    input           rx_cdr_refclk,
    output          tx_clk,         // @ 390.625 (ref)
    output          tx_clk_stable,     
    output          rx_clk,         // @ 390.625 (remote)
    output          rx_fpll_locked,

    // high speed serial
    input   [1:0]   rx_serial_data,
    output  [1:0]   tx_serial_data,

    // Transmit Interface
    output          tx_req,
    input   [63:0]  tx_din_preamble,
    input   [127:0] tx_din, // read left to right
    input   [1:0]   tx_sop,
    input   [1:0]   tx_eop,
    input   [1:0]   tx_eeop,
    input   [1:0]   tx_idle,
    input   [5:0]   tx_mty, // number of empty bytes in eop word 0..7
    input           fc_sel,

    output  [39:0]  tx_stats,
    output          tx_stats_valid,
    output  [6:0]   tx_error,

    // rx data
    output          rx_valid,  // when 0 ignore all others
    output  [127:0] rx_dout, // read left to right
    output  [1:0]   rx_sop,
    output  [1:0]   rx_eop,
    output  [1:0]   rx_eeop,
    output  [5:0]   rx_mty, // number of empty bytes in eop word 0..7
    output  [1:0]   rx_idle,
    output  [1:0]   rx_prb,

    // rx status and stats
    output  [5:0]   rx_error,
    output  [39:0]  rx_stats,
    output          rx_stats_valid,
    output  [15:0]  rx_inc_octetsOK,
    output          rx_inc_octetsOK_valid,
    output          rx_block_lock,
    output          rx_am_lock,
    output          rx_pcs_ready,    
    output          rx_crc_pt,

    // Avalon MM Interface
    input           avmm_clk,
    input           avmm_clk_stable,
    input           avmm_write,
    input           avmm_read,
    input   [15:0]  avmm_address,
    input   [31:0]  avmm_write_data,
    output  [31:0]  avmm_read_data,
    output          avmm_read_data_valid,
    output          avmm_waitrequest,

    //Link Fault Status
    output          remote_fault_status,
    output          local_fault_status,
    output          unidirectional_en,
    output          link_fault_gen_en,

    //Flow Control CSR
    output          fc_pfc_sel,
    output  [7:0]   fc_ena,
    output  [127:0] fc_pause_quanta,
    output  [127:0] fc_hold_quanta,
    output  [7:0]   fc_2b_req_mode_sel,
    output  [7:0]   fc_2b_req_mode_csr_req_sel,
    output  [7:0]   fc_req0,
    output  [7:0]   fc_req1,
    output  [47:0]  fc_dest_addr,
    output  [47:0]  fc_src_addr,
    output          fc_tx_off_en,
    output  [7:0]   fc_rx_pfc_en,
    output  [47:0]  fc_rx_dest_addr,
    
    // Reconfig Interface
    input   [0:0]   reconfig_clk,
    input           reconfig_reset,
    input           reconfig_write,
    input           reconfig_read,
    input   [10:0]  reconfig_address, 
    input   [31:0]  reconfig_write_data,
    output  [31:0]  reconfig_read_data,
    output          reconfig_waitrequest
);

genvar i;

wire       rx_clk_stable;
wire [7:0] num_idle_rm;
wire       tx_crc_pt;
wire [1:0] rx_bitslip;
wire [1:0] rx_bitslip_pre;
   
///////////////////////////////////////
// Reset logic
//
wire        tx_analogreset;
wire        tx_digitalreset;

wire        rx_analogreset;
wire        rx_digitalreset;
wire        rx_digitalreset_pre;

wire        dig_rst_inhibit;        // CSR signal to stop rx_digitalreset from being asserted
wire        bitslip_inhibit;        // CSR signal to stop rx bitslips
wire [1:0]  rx_is_lockedtodata;
wire [1:0]  tx_cal_busy;
wire [1:0]  rx_cal_busy;
wire        soft_txp_rst, soft_rxp_rst, eio_sys_rst;
wire        tx_pcs_sclr, rx_pcs_sclr, csr_reset;
wire        rxpcs_dout_align_locked;
wire        hi_ber_raw;
wire        rx_pcs_rst_req;

assign      rx_digitalreset = dig_rst_inhibit ? 1'b0 : rx_digitalreset_pre; // Block rx digital resets. Used for PRBS checking
assign      rx_bitslip      = bitslip_inhibit ? 2'b0 : rx_bitslip_pre;      // Block rx bitslips. Prevents overflows when rx digital resets are blocked.

// Used to clear the MAC stats counters memory
assign tx_stats_aclr = ~csr_rst_n || ~tx_rst_n || soft_txp_rst;
assign rx_stats_aclr = ~csr_rst_n || ~rx_rst_n || soft_rxp_rst;

alt_e2550_reset rst (
    // clocks
    .avmm_clk               (avmm_clk),  
    .tx_clk                 (tx_clk),
    .rx_clk                 (rx_clk),
    .rx_fpll_locked         (rx_fpll_locked),
    
    // external resets
    .csr_rst                (~csr_rst_n),
    .tx_rst                 (~tx_rst_n),
    .rx_rst                 (~rx_rst_n),

    // status input signals
    .tx_cal_busy            (tx_cal_busy),
    .rx_cal_busy            (rx_cal_busy),
    .pll_locked             (pll_locked),
    .avmm_clk_stable        (avmm_clk_stable),
    .rx_is_lockedtodata     (rx_is_lockedtodata),
    .rx_pcs_ready_in        (rxpcs_dout_align_locked) ,

    // soft resets
    .soft_txp_rst           (soft_txp_rst),
    .soft_rxp_rst           (soft_rxp_rst),
    .eio_sys_rst            (eio_sys_rst),
    .rx_pcs_rst_req         (rx_pcs_rst_req),
    
    // outputs
    .csr_rst_out            (csr_reset),
    .tx_analogreset         (tx_analogreset),
    .tx_digitalreset        (tx_digitalreset),
    .rx_analogreset         (rx_analogreset),
    .rx_digitalreset        (rx_digitalreset_pre),
    .tx_out_of_rst          (tx_out_of_rst),
    .rx_out_of_rst          (rx_out_of_rst),
    .rx_pcs_ready_out       (rx_pcs_ready),

    .tx_mac_sclr            (tx_mac_sclr),
    .tx_pcs_sclr            (tx_pcs_sclr),
    .rx_mac_sclr            (rx_mac_sclr),
    .rx_pcs_sclr            (rx_pcs_sclr)

);
defparam rst .SIM_EMULATE = SIM_EMULATE;
defparam rst .SIM_HURRY = SIM_HURRY;

//////////////////////////////////////
// Serdes lane


wire [1:0] rx_seriallpbken ;

reg [131:0] tx_parallel_data;
wire [131:0] rx_parallel_data;

wire [7:0] rwire0 , rwire1;
wire [1:0] rx_empty;
wire [1:0] rx_pempty;
wire [1:0] rx_pfull;
wire [1:0] rx_full;
wire [1:0] tx_pempty;
wire [1:0] tx_empty;
wire [1:0] tx_pfull;
wire [1:0] tx_full;
wire [1:0] tx_pma_div_clk;
wire [1:0] rx_pma_div_clk;
wire       rx_set_locktoref;
wire       rx_set_locktodata;


wire    tvalid_n;
assign  tvalid_n = ~tx_out_of_rst; 
//reg  tvalid_n;
//always @(posedge tx_clk)
//begin
//    tvalid_n    <=  ~tx_out_of_rst; 
//end
 
// reconfig Muxes
wire    [31:0]  reconfig_read_data_0, reconfig_read_data_1;
wire            reconfig_read_0, reconfig_read_1;
wire            reconfig_write_0, reconfig_write_1;
wire            reconfig_waitrequest_0, reconfig_waitrequest_1;

assign  reconfig_read_0 = ~reconfig_address[10] & reconfig_read;
assign  reconfig_read_1 =  reconfig_address[10] & reconfig_read;
assign  reconfig_write_0 = ~reconfig_address[10] & reconfig_write;
assign  reconfig_write_1 =  reconfig_address[10] & reconfig_write;
assign  reconfig_waitrequest = (reconfig_address[10] == 0) ? reconfig_waitrequest_0 : reconfig_waitrequest_1 ;
assign  reconfig_read_data = (reconfig_address[10] == 0) ? reconfig_read_data_0 : reconfig_read_data_1 ;


// serdes
alt_e2550_serdes_a10_25g s0 (
    .tx_analogreset         (tx_analogreset),   
    .tx_digitalreset        (tx_digitalreset),
    .rx_analogreset         (rx_analogreset),   
    .rx_digitalreset        (rx_digitalreset),  
    .tx_serial_clk          (tx_serial_clk[0]),
    .rx_cdr_refclk          (rx_cdr_refclk),
    .tx_parallel_data       (tx_parallel_data[63:0]),
    .tx_control             ({8'h0, tx_parallel_data[65:64]}),
    .tvalid                 (~tvalid_n),
    .rx_parallel_data       (rx_parallel_data[63:0]),
    .rx_control             ({rwire0, rx_parallel_data[65:64]}),
    .rx_rden                (~rx_empty[0]),
    .rx_serial_data         (rx_serial_data[0]),
    .tx_serial_data         (tx_serial_data[0]),
    .tx_clkin               (tx_clk),  
    .tx_pma_div_clkout      (tx_pma_div_clk[0]),        // 390.625 MHz
    .rx_clkin               (rx_clk),
    .rx_pma_div_clkout      (rx_pma_div_clk[0]),        // 390.625 MHz
    .rx_seriallpbken        (rx_seriallpbken[0]),
    .rx_is_lockedtodata     (rx_is_lockedtodata[0]),
    .rx_bitslip             (rx_bitslip[0]),
    .rx_set_locktoref       (rx_set_locktoref),
    .rx_set_locktodata      (rx_set_locktodata),
    .tx_clkout              (),
    .rx_clkout              (),

    .tx_pempty              (tx_pempty[0]),
    .tx_pfull               (tx_pfull[0]),  
    .tx_empty               (tx_empty[0]),
    .tx_full                (tx_full[0]),
    .rx_empty               (rx_empty[0]),
    .rx_pempty              (rx_pempty[0]),
    .rx_pfull               (rx_pfull[0]),
    .rx_full                (rx_full[0]),
    .tx_cal_busy            (tx_cal_busy[0]),
    .rx_cal_busy            (rx_cal_busy[0]),

    .reconfig_write         (reconfig_write_0),     
    .reconfig_read          (reconfig_read_0),     
    .reconfig_address       (reconfig_address[9:0]),     
    .reconfig_writedata     (reconfig_write_data),     
    .reconfig_readdata      (reconfig_read_data_0),     
    .reconfig_waitrequest   (reconfig_waitrequest_0),     
    .reconfig_clk           (reconfig_clk[0]),     
    .reconfig_reset         (reconfig_reset)



);


alt_e2550_serdes_a10_25g s1 (
    .tx_analogreset         (tx_analogreset),   
    .tx_digitalreset        (tx_digitalreset),
    .rx_analogreset         (rx_analogreset),   
    .rx_digitalreset        (rx_digitalreset),  
    .tx_serial_clk          (tx_serial_clk[1]),
    .rx_cdr_refclk          (rx_cdr_refclk),
    .tx_parallel_data       (tx_parallel_data[129:66]),
    .tx_control             ({8'h0, tx_parallel_data[131:130]}),
    .tvalid                 (~tvalid_n),
    .rx_parallel_data       (rx_parallel_data[129:66]),
    .rx_control             ({rwire1, rx_parallel_data[131:130]}),
    .rx_rden                (~rx_empty[1]),
    .rx_serial_data         (rx_serial_data[1]),
    .tx_serial_data         (tx_serial_data[1]),
    .tx_clkin               (tx_clk),  
    .tx_pma_div_clkout      (tx_pma_div_clk[1]),
    .rx_clkin               (rx_clk),
    .rx_pma_div_clkout      (rx_pma_div_clk[1]),
    .rx_seriallpbken        (rx_seriallpbken[1]),
    .rx_is_lockedtodata     (rx_is_lockedtodata[1]),
    .rx_bitslip             (rx_bitslip[1]),
    .rx_set_locktoref       (rx_set_locktoref),
    .rx_set_locktodata      (rx_set_locktodata),
    .tx_clkout              (),
    .rx_clkout              (),

    .tx_pempty              (tx_pempty[1]),
    .tx_pfull               (tx_pfull[1]),  
    .tx_empty               (tx_empty[1]),
    .tx_full                (tx_full[1]),
    .rx_empty               (rx_empty[1]),
    .rx_pempty              (rx_pempty[1]),
    .rx_pfull               (rx_pfull[1]),
    .rx_full                (rx_full[1]),
    .tx_cal_busy            (tx_cal_busy[1]),
    .rx_cal_busy            (rx_cal_busy[1]),

    .reconfig_write         (reconfig_write_1),     
    .reconfig_read          (reconfig_read_1),     
    .reconfig_address       (reconfig_address[9:0]),     
    .reconfig_writedata     (reconfig_write_data),     
    .reconfig_readdata      (reconfig_read_data_1),     
    .reconfig_waitrequest   (reconfig_waitrequest_1),     
    .reconfig_clk           (reconfig_clk[0]),     
    .reconfig_reset         (reconfig_reset)

);


//////////////////////////////////////
// TX PCS

assign tx_clk = tx_pma_div_clk[0]; 

wire [127:0] txpcs_din_d; // bit 0 first
wire [15:0] txpcs_din_c;
wire txpcs_din_am;
wire [131:0] txpcs_dout;

wire [1:0] tx_ber_inject = 2'b0;
wire [1:0] tx_ber_inject_rise;
alt_e2550_xrise1r3 xr0 (
    .din_clk(avmm_clk),
    .din(tx_ber_inject[0]),
    .dout_clk(tx_clk),
    .dout(tx_ber_inject_rise[0])
);
defparam xr0 .SIM_EMULATE = SIM_EMULATE;

alt_e2550_xrise1r3 xr1 (
    .din_clk(avmm_clk),
    .din(tx_ber_inject[1]),
    .dout_clk(tx_clk),
    .dout(tx_ber_inject_rise[1])
);
defparam xr1 .SIM_EMULATE = SIM_EMULATE;

// the a10 pcs 66-bit basic interface
always @(posedge tx_clk) tx_parallel_data[65:0]   <= txpcs_dout[65:0]   ^ {66{tx_ber_inject_rise[0]}};
always @(posedge tx_clk) tx_parallel_data[131:66] <= txpcs_dout[131:66] ^ {66{tx_ber_inject_rise[1]}};

alt_e50_epcs_t ep0 (
    .clk        (tx_clk),
    .din_sclr   (tx_pcs_sclr),
    .din_c      (txpcs_din_c),
                    
    .din_d      (txpcs_din_d),
    .din_am     (txpcs_din_am),
    .dout       (txpcs_dout)
);
defparam ep0 .SIM_EMULATE = SIM_EMULATE;

//////////////////////////////////////
// TX MAC

wire txmac_dout_am;
wire [127:0] txmac_dout_d;
wire [15:0] txmac_dout_c;

wire din_req;
wire [63:0] din_preamble;
wire [127:0] din;
wire [1:0] din_sop;
wire [1:0] din_eop;
wire [1:0] din_eeop;
wire [5:0] din_mty; // number of empty bytes in eop word 0..7
wire [15:0] tx_max_frm_length;
wire        tx_cfg_vlandet_disable; 
wire [2:0]  tx_frm_error;

wire tx_mac_lf_cfg_linkfault_rpt_en;
wire tx_mac_lf_cfg_unidir_en       ;
wire tx_mac_lf_cfg_disable_rf      ;
wire tx_mac_lf_cfg_force_rf        ;
assign  unidirectional_en = tx_mac_lf_cfg_unidir_en;        
assign  link_fault_gen_en = tx_mac_lf_cfg_linkfault_rpt_en;
   
assign tx_error  = {4'b0000, tx_frm_error};

alt_e50_mac_tx #(
        .SIM_SHORT_AM      (SIM_SHORT_AM),
        .SIM_EMULATE       (SIM_EMULATE),
        .SYNOPT_PREAMBLE_PASS(SYNOPT_PREAMBLE_PASS),      
        .SYNOPT_TXCRC_PASS (SYNOPT_TXCRC_PASS),      
        .SYNOPT_FLOW_CONTROL (SYNOPT_FLOW_CONTROL),      
        .SYNOPT_LINK_FAULT (SYNOPT_LINK_FAULT)           
  ) em0(
    .sclr          (tx_mac_sclr),
    .clk           (tx_clk),
    .fc_sel        (fc_sel),
    .tx_crc_pt     (tx_crc_pt),
    .num_idle_rm   (num_idle_rm),       
    .din_sop       (din_sop), 
    .din_eop       (din_eop), 
    .din_error     (din_eeop),      
    .din_idle      (tx_idle), // Not used    
    .din_eop_empty (din_mty),
    .din           (din),
    .din_preamble  (din_preamble),
    .req           (din_req),
        
     //link fault       
    .tx_mac_lf_cfg_linkfault_rpt_en (tx_mac_lf_cfg_linkfault_rpt_en),
    .tx_mac_lf_cfg_unidir_en        (tx_mac_lf_cfg_unidir_en       ),
    .tx_mac_lf_cfg_disable_rf       (tx_mac_lf_cfg_disable_rf      ),
    .tx_mac_lf_cfg_force_rf         (tx_mac_lf_cfg_force_rf        ),
    .remote_fault_status            (remote_fault_status),      
    .local_fault_status             (local_fault_status ),  
    .cfg_max_frm_length             (tx_max_frm_length ),
    .cfg_vlandet_disable            (tx_cfg_vlandet_disable),

    .tx_mii_d      (txmac_dout_d),
    .tx_mii_c      (txmac_dout_c),
    .dout_am       (txmac_dout_am),

    .tx_stats           (tx_stats),
    .tx_stats_valid     (tx_stats_valid),
    .tx_frm_error       (tx_frm_error)
  );
   
// switch from MAC (read left to right) to PCS (bit 0 first)
generate
    for (i=0; i<16; i=i+1) begin : rolp0
        assign txpcs_din_d[((15-i)+1)*8-1:(15-i)*8] = txmac_dout_d[(i+1)*8-1:i*8];
        assign txpcs_din_c[15-i] = txmac_dout_c[i];
    end
endgenerate

assign tx_req = din_req;
assign din_preamble = tx_din_preamble;
assign din = tx_din;
assign din_sop = tx_sop;
assign din_eop = tx_eop;
assign din_eeop = tx_eeop;
assign din_mty = tx_mty;
assign txpcs_din_am = txmac_dout_am;


//////////////////////////////////////
// RX PCS

generate
if (SYNOPT_DIV40) begin

    wire refclk_buf;
    wire cal_busy;
    wire recal_is_done;
    wire rcfg_wtrqst;
    wire rcfg_write;
    wire rcfg_read;
    wire [9:0] rcfg_address;
    wire [31:0] rcfg_wrdata;
    wire [31:0] rcfg_rddata;
    wire        rx_digitalreset_sync;

    alt_e2550_synchronizer s (
        .clk(avmm_clk),
        .din(rx_digitalreset),
        .dout(rx_digitalreset_sync)
    );

    alt_e2550_pll_recal recal_fpll (
        .mgmt_clk           (avmm_clk),
        .mgmt_reset         (rx_digitalreset_sync),
        .rcfg_write         (rcfg_write),
        .rcfg_read          (rcfg_read),
        .rcfg_address       (rcfg_address),
        .rcfg_wrdata        (rcfg_wrdata),
        .rcfg_rddata        (rcfg_rddata),
        .rcfg_wtrqst        (rcfg_wtrqst),
        .cal_busy           (cal_busy),
        .recal_is_done      (recal_is_done),
        .rx_is_lockedtodata (rx_is_lockedtodata[0])
);

    //clkctrl clk_inst(
    //    .inclk(rx_pma_div_clk[0]),
    //    .outclk(divclk_buf)
    //);

    alt_e2550_rx_fpll rxfpll(
        .pll_refclk0          (rx_pma_div_clk[0]),   
        .pll_powerdown        (!rx_is_lockedtodata[0]),
        .pll_locked           (rx_fpll_locked), 
        .outclk0              (rx_clk),
        .reconfig_clk0        (avmm_clk),
        .reconfig_reset0      (rx_digitalreset_sync),
        .reconfig_write0      (rcfg_write),
        .reconfig_read0       (rcfg_read),
        .reconfig_address0    (rcfg_address),
        .reconfig_writedata0  (rcfg_wrdata),
        .reconfig_readdata0   (rcfg_rddata),
        .reconfig_waitrequest0(rcfg_wtrqst),
        .pll_cal_busy         (cal_busy)
    );
    assign rx_clk_stable = rx_fpll_locked;
end
else begin
    assign rx_fpll_locked = 1'b1;
    assign rx_clk_stable = rx_is_lockedtodata[0];
    assign rx_clk = rx_pma_div_clk[0];
end
endgenerate



wire [131:0] rxpcs_din = rx_parallel_data;
wire rxpcs_frm_err_sclr;
wire [3:0] rxpcs_dout_sticky_frm_err;
wire [3:0] rxpcs_dout_word_locked;
wire rxpcs_dout_deskew_locked;
wire rxpcs_dout_am;
wire [7:0] rxpcs_dout_tags;
wire [127:0] rxpcs_dout_d;
wire [15:0] rxpcs_dout_c;
wire        rx_fifo_soft_purge;
wire [5:0]  delay;
wire        blk_err;
   
alt_e50_epcs_r ep1 (
    .clk                    (rx_clk),
    .din                    (rxpcs_din),
    .csr_rst_n              (csr_rst_n), 
    .dout_sclr              (rx_pcs_sclr),
    .dout_sclr_err          (rxpcs_frm_err_sclr),
    .dout_sticky_frm_err    (rxpcs_dout_sticky_frm_err),
    .dout_deskew_locked     (rxpcs_dout_deskew_locked),
    .dout_align_locked      (rxpcs_dout_align_locked),
    .dout_word_locked       (rxpcs_dout_word_locked),
    .dout_tags              (rxpcs_dout_tags),
    .rx_pcs_rst_req         (rx_pcs_rst_req),
    .dout_am                (rxpcs_dout_am),
    .purge_req              (rx_bitslip_pre),       // bitslip output
    .purge_fifo             (rx_fifo_soft_purge),   // soft purging of RX FIFOs
    .delay                  (delay),
    .dout_d                 (rxpcs_dout_d),
    .dout_c                 (rxpcs_dout_c),
    .hi_ber                 (hi_ber_raw),
    .blk_err                (blk_err)
);
defparam ep1 .SIM_SHORT_AM      = SIM_SHORT_AM;
defparam ep1 .SIM_EMULATE       = SIM_EMULATE;
defparam ep1 .SYNOPT_LINK_FAULT = SYNOPT_LINK_FAULT;

//////////////////////////////////////
// RX MAC

wire rxmac_din_am = rxpcs_dout_am;
wire [127:0] rxmac_din_d;
wire [15:0] rxmac_din_c;

// switch from PCS (bit 0 first) to MAC (read left to right)
generate
    for (i=0; i<16; i=i+1) begin : rolp1
        assign rxmac_din_d[((15-i)+1)*8-1:(15-i)*8] = rxpcs_dout_d[(i+1)*8-1:i*8];
        assign rxmac_din_c[15-i] = rxpcs_dout_c[i];
    end
endgenerate

wire dout_valid;
wire [127:0] dout; // read left to right
wire [1:0] dout_sop;
wire [1:0] dout_idle;
wire [1:0] dout_eop;
wire [1:0] dout_eeop;
wire [5:0] dout_mty; // number of empty bytes in eop word 0..7
wire [15:0] rx_max_frm_length;
wire        rx_cfg_vlandet_disable; 

wire cfg_sfd_det_on;
wire cfg_preamble_det_on;

alt_e50_emac_r em1 (
    .clk                    (rx_clk),
    .sclr                   (rx_mac_sclr),
    .csr_rst_n              (csr_rst_n),  
    .din_d                  (rxmac_din_d),
    .din_c                  (rxmac_din_c),
    .din_am                 (rxmac_din_am),
    .rx_crc_pt              (rx_crc_pt),
    .dout_valid             (dout_valid),
    .dout                   (dout),
    .dout_sop               (dout_sop),
    .dout_eop               (dout_eop),
    .dout_eeop              (dout_eeop),
    .dout_mty               (dout_mty),
    .dout_idle              (dout_idle),
    .dout_prb               (rx_prb), 
    .rx_error               (rx_error),
    .rx_stats               (rx_stats),
    .rx_inc_octetsOK        (rx_inc_octetsOK),
    .rx_inc_octetsOK_valid  (rx_inc_octetsOK_valid),
    .remote_fault_status    (remote_fault_status),
    .local_fault_status     (local_fault_status ),
    .rx_statsvalid          (rx_stats_valid),
    .cfg_max_frm_length     (rx_max_frm_length),
    .cfg_sfd_det_on         (cfg_sfd_det_on),
    .cfg_preamble_det_on    (cfg_preamble_det_on),     
    .cfg_vlandet_disable    (rx_cfg_vlandet_disable)
);
defparam em1 .SIM_EMULATE          = SIM_EMULATE;
defparam em1 .SYNOPT_PREAMBLE_PASS = SYNOPT_PREAMBLE_PASS;
defparam em1 .SYNOPT_LINK_FAULT    = SYNOPT_LINK_FAULT;
defparam em1 .SYNOPT_STRICT_SOP    = SYNOPT_STRICT_SOP;

assign rx_valid = dout_valid;
assign rx_dout = dout;
assign rx_sop = dout_sop;
assign rx_eop = dout_eop;
assign rx_eeop = dout_eeop;
assign rx_mty = dout_mty;
assign rx_idle = dout_idle;

//////////////////////////////////////


//////////////////////////////////////
// CSR Block
//
//


alt_e50_csr #(
    .SYNOPT_FLOW_CONTROL  (SYNOPT_FLOW_CONTROL)
)csr(
    // Clocks
    .csr_clk                (avmm_clk),
    .tx_clk                 (tx_clk),
    .rx_clk                 (rx_clk),
    .cdr_ref_clk            (rx_cdr_refclk),
    
    // AVMMM Interface
    .reset                  (csr_reset),
    .write                  (avmm_write),
    .read                   (avmm_read),
    .address                (avmm_address),
    .data_in                (avmm_write_data),
    .data_out               (avmm_read_data),
    .data_valid             (avmm_read_data_valid),
    .waitrequest            (avmm_waitrequest),

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
    .rx_word_locked         (rxpcs_dout_word_locked),
    .rx_deskew_locked       (rxpcs_dout_deskew_locked),
    .rx_align_locked        (rx_pcs_ready),
    .rx_hi_ber              (hi_ber_raw),  //connect to csr
    .rxpcs_dout_tags        (rxpcs_dout_tags),
    .rx_word_locked_s       (),

     //Rx Link Fault Status             
     .local_fault_status    (local_fault_status ),             
     .remote_fault_status   (remote_fault_status),
     
    //RX strict preamble check 
    .cfg_sfd_det_on         (cfg_sfd_det_on),
    .cfg_preamble_det_on    (cfg_preamble_det_on),  
                
    // RX Status and Control Out
    .rx_clk_stable          (rx_clk_stable),
    .rxpcs_frm_err_sclr     (rxpcs_frm_err_sclr),
    .rx_fifo_soft_purge     (rx_fifo_soft_purge),
    .rx_seriallpbken        (rx_seriallpbken),
    .rx_set_locktoref       (rx_set_locktoref),
    .rx_set_locktodata      (rx_set_locktodata),
    .rx_crc_pt              (rx_crc_pt),
    .rx_delay               (delay),
    
    // TX status in
    .tx_pempty                  (tx_pempty),
    .tx_pfull                   (tx_pfull),
    .tx_empty                   (tx_empty),
    .tx_full                    (tx_full),
    .tx_pll_locked              (pll_locked),
    .tx_digitalreset            (tx_digitalreset),
    .rx_fifo_inhibit_bitslip    (bitslip_inhibit),
    .rx_fifo_inhibit_rx_reset   (dig_rst_inhibit),


    // TX Status and Control Out
    .tx_clk_stable          (tx_clk_stable),
    .tx_crc_pt              (tx_crc_pt),
    .num_idle_rm            (num_idle_rm),
    
    // Statistics Vector
    .tx_vlandet_disable             (tx_cfg_vlandet_disable),
    .rx_vlandet_disable             (rx_cfg_vlandet_disable),
    .tx_max_frm_length              (tx_max_frm_length),
    .rx_max_frm_length              (rx_max_frm_length),
                
    // TX Mac Link Fault Config  
    .tx_mac_lf_cfg_linkfault_rpt_en  (tx_mac_lf_cfg_linkfault_rpt_en),          
    .tx_mac_lf_cfg_unidir_en         (tx_mac_lf_cfg_unidir_en       ),
    .tx_mac_lf_cfg_disable_rf        (tx_mac_lf_cfg_disable_rf      ),          
    .tx_mac_lf_cfg_force_rf          (tx_mac_lf_cfg_force_rf        ),          
    
    //Flow Control
    .fc_pfc_sel                      (fc_pfc_sel),
    .fc_ena                          (fc_ena),
    .fc_pause_quanta                 (fc_pause_quanta),
    .fc_hold_quanta                  (fc_hold_quanta),
    .fc_2b_req_mode_sel              (fc_2b_req_mode_sel),
    .fc_2b_req_mode_csr_req_sel      (fc_2b_req_mode_csr_req_sel),
    .fc_req0                         (fc_req0),
    .fc_req1                         (fc_req1),
    .fc_dest_addr                    (fc_dest_addr),
    .fc_src_addr                     (fc_src_addr),
    .fc_tx_off_en                    (fc_tx_off_en),
    .fc_rx_pfc_en                    (fc_rx_pfc_en),
    .fc_rx_dest_addr                 (fc_rx_dest_addr)
);
defparam csr .SIM_EMULATE = SIM_EMULATE;

assign  rx_block_lock   = &rxpcs_dout_word_locked;
assign  rx_am_lock      = rx_pcs_ready;  // don't have the exposed signal





endmodule

