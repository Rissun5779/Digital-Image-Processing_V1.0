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
module caui4_e100_pcs_assembly #(
        parameter PHY_REFCLK = 1,
        parameter TARGET_CHIP = 2,
        parameter REVID = 32'h04012014,
        parameter SYNOPT_C4_RSFEC = 0,    // enable RS-FEC logic. set only for CUAI4
        parameter SYNOPT_PTP = 0,
        parameter PTP_LATENCY = 20,
        parameter BASE_TXFEC = 12,
        parameter BASE_RXFEC = 13,
        parameter SYNOPT_FULL_SKEW = 0,
        parameter EN_LINK_FAULT = 0,
        parameter WORDS = 4,                    // no override
        parameter NUM_VLANE = 20,               // no override
        parameter ADDR_PAGE = 8'h1,
        parameter SIM_FAKE_JTAG = 1'b0,
        parameter AM_CNT_BITS = 14,             // nominal 14, 6 Ok for sim
        parameter RST_CNTR = 16,                // nominal 16/20  or 6 for fast simulation of reset seq
        parameter CREATE_TX_SKEW = 1'b0,        // debbug - insert TX side lane skew 
        parameter TIMING_MODE = 1'b0,
    parameter PCS_CLK_LANE      = 1,            // which xcvr channel is used to generate the pcs clock
        parameter EXT_TX_PLL = 1'b0             // whether to use external fpll for TX core clocks
)(
        input pll_ref,
        output [3:0] etx_pin,
        input [3:0] erx_pin,
        
        input TX_CORE_CLK,
        input RX_CORE_CLK,
        
        //Sync-E
        output clk_rx_recover_syncE,
  
        // status port
        input clk100,
        input rst100,    // global reset, async, no domain
	input reset_status_async,  // reset_async and reset_status synced to clk_status	
  
        input slave_din,
        output slave_dout,

        // mii tx port
        input clk_txmac_in,     // used with EXT_TX_PLL, 390.625MHz derived from clk_ref
        output clk_tx_main,
        output srst_tx_main,
        output tx_lanes_stable,
        input tx_crc_ins_en,
        input [WORDS*64-1:0] din_d, 
        input [WORDS*8-1:0] din_c, 
        output din_am,          // this din will be replaced with align marks
        output pre_din_am,      // leading indicator
                
        // mii rx port
        output clk_rx_main,
        output srst_rx_main,
        output reg rx_pcs_fully_aligned,
        output [WORDS*64-1:0] dout_d,
        output [WORDS*8-1:0] dout_c,
        output dout_am,        // dout is an alignment mark position, discard
        output [199:0] dsk_depths,

        output [WORDS-1:0] tx_mii_start,
                        
        input  wire [0:0]   reconfig_clk,            // reconfig_clk.clk
        input  wire [0:0]   reconfig_reset,          // reconfig_reset.reset
        input  wire [0:0]   reconfig_write,          // reconfig_avmm.write
        input  wire [0:0]   reconfig_read,           // .read
        input  wire [11:0]  reconfig_address,        // .address
        input  wire [31:0]  reconfig_writedata,      // .writedata
        output wire [31:0]  reconfig_readdata,       // .readdata
        output wire [0:0]   reconfig_waitrequest,    // .waitrequest
        input       [9:0]   tx_serial_clk,
        input               tx_pll_locked
);
genvar i;
genvar j;

//////////////////////////////////////
// 10x10G pin array
//////////////////////////////////////

reg eio_sys_rst = 1'b0;
reg [9:0] eio_sloop = 10'b0;
reg [2:0] eio_flag_sel = 3'b0;
reg [3:0] eio_flags = 4'h0;
wire [3:0] eio_tx_pll_locked;
wire rxp_lock, txp_lock;
reg set_data_lock = 1'b0;
reg set_ref_lock = 1'b0;

wire [1399:0] eio_reconfig_to_xcvr;
wire [919:0]  eio_reconfig_from_xcvr;
    
wire [4*64-1:0] eio_din, eio_dout_hssi;
reg  [4*64-1:0] eio_dout, eio_dout_negedge;
wire [4*80-1:0] caui4_txa_din, caui4_rxa_dout;
reg  [4*80-1:0] caui4_rxa_dout_r;
reg  [4*80-1:0] caui4_rxa_dout_r2;
wire eio_din_valid;
wire [3:0] eio_dout_req;
wire eio_tx_online;
wire eio_rx_online;
wire eio_rx_soft_purge;
wire eio_rx_flush = !eio_rx_online | eio_rx_soft_purge;
wire [3:0] clk_tx_io;
wire txa_online;
wire [3:0] clk_rx_recover;
wire [3:0] rx_pma_iq_clkout;
wire [3:0] rx_pma_div_clkout;
wire [3:0] rx_lockedtodata;
wire rx_hi_ber_raw;
wire rx_pcs_fully_aligned_raw;
wire rx_aclr_pcs_ready;

wire [3:0] eio_freq_lock = rx_lockedtodata;

// reset syncer
wire rst_sync_sts; 
assign rst_sync_sts= reset_status_async;
//syncer moved to top to be shared by Quan
/*
aclr_filter reset_syncer_sts (
        .aclr     (rst100), // global reset, async, no domain
        .clk      (clk100),     
        .aclr_sync(rst_sync_sts)
);
 */
  
//Sync-E
assign clk_rx_recover_syncE = clk_rx_recover[0];    
   
// synthesis translate_off
always @(posedge eio_tx_online) begin
        $display ("100G transmit IO now operating at time %d",$time);
end
always @(posedge eio_rx_online) begin
        $display ("100G receive IO now operating at time %d",$time);
end
// synthesis translate_on

wire ss1_slave_dout, rs_txser_dout, rs_rxser_dout;
wire rx_backup;

generate
    if (SYNOPT_C4_RSFEC) begin
  assign slave_dout = ss1_slave_dout & rs_txser_dout & rs_rxser_dout;
    end else begin
  assign slave_dout = ss1_slave_dout;

  // after a RX sclr backup the FIFOs a little bit
  reg post_flush = 1'b0;
  reg last_eio_rx_flush = 1'b0;
  always @(posedge clk_rx_main) begin
        last_eio_rx_flush <= eio_rx_flush;
        post_flush <= (last_eio_rx_flush && !eio_rx_flush);
  end

  //grace_period_16 gp (
  grace_period_8 gp (
    .clk(clk_rx_main),
    .start_grace(post_flush),
    .grace(rx_backup)
  );
  defparam gp .TARGET_CHIP = TARGET_CHIP;
    end
endgenerate

reg [11:0]  reco_addr = 12'h0;
reg         reco_read = 1'b0;
reg         reco_write = 1'b0;
reg [31:0]  reco_wdata=32'h0;
wire [31:0] reco_rdata=32'h0;
wire        eio_pma_din_valid;
wire [3:0]  rx_bitslip;

assign eio_tx_pll_locked = {4{tx_pll_locked}};
caui4_e100_pma iof (
        .pll_refclk (pll_ref),
    .tx_pin                    (etx_pin),
    .rx_pin                    (erx_pin),

        // status and control
    .status_clk                (clk100),
    .sys_rst                   (eio_sys_rst | rst_sync_sts),
    .freq_lock                 (),
    .txa_online                (txa_online),
    .tx_pll_locked             (tx_pll_locked),
    .sloop                     (eio_sloop),
                
        // data stream to TX pins
    .din_clk                   (clk_tx_main),
    .din_clk_ready             (txp_lock),
    .rx_bitslip                (rx_bitslip[3:0]),
    .din                       (eio_din), // lsbit first serial streams
    .din_valid                 (eio_pma_din_valid),
    .tx_online                 (eio_tx_online),
    .clk_tx_io                 (clk_tx_io),
    
        // data stream from RX pins
    .dout_clk                  (clk_rx_main),
    .dout_clk_ready            (rxp_lock),
    .dout                      (eio_dout_hssi), // lsbit first serial streams
    .rx_online                 (eio_rx_online),
    .rx_aclr_pcs_ready         (rx_aclr_pcs_ready),
    .clk_rx_recovered          (clk_rx_recover),
    .rx_pma_iq_clkout          (rx_pma_iq_clkout),
    .rx_pma_div_clkout         (rx_pma_div_clkout),
    .rx_lockedtodata           (rx_lockedtodata),
        
    .reconfig_clk              (reconfig_clk),          //           reconfig_clk.clk
    .reconfig_reset            (reconfig_reset),        //           reconfig_reset.reset
    .reconfig_write            (reconfig_write),        //           reconfig_avmm.write
    .reconfig_read             (reconfig_read),         //           read
    .reconfig_address          (reconfig_address),      // [11:0]    address
    .reconfig_writedata        (reconfig_writedata),    // [31:0]    writedata
    .reconfig_readdata         (reconfig_readdata),     // [31:0]    readdata
    .reconfig_waitrequest      (reconfig_waitrequest),  //           waitrequest
    .tx_serial_clk             (tx_serial_clk)
);
defparam iof .RST_CNTR = RST_CNTR;
defparam iof .PHY_REFCLK= PHY_REFCLK;

/////////////////////////////////////////////////
// Capture HSSI RX data on -ve edge first 
////////////////////////////////////////////////
generate
   for (j=0; j<4; j=j+1) begin: capture_hssi_data
      always @ (negedge clk_rx_recover[j])
      eio_dout_negedge[(j+1)*64-1:j*64] <= eio_dout_hssi[(j+1)*64-1:j*64] ;

      always @ (posedge clk_rx_recover[j])
      eio_dout[(j+1)*64-1:j*64] <= eio_dout_negedge[(j+1)*64-1:j*64] ;
   end
endgenerate

//////////////////////////////////////
// MAC rate PLLs
//////////////////////////////////////

wire rxp_rst;
wire rxp_lock_i;
reg soft_rxp_rst = 1'b0;

reg rxp_ignore_freq = 1'b0;
wire rxp_rst_in = soft_rxp_rst || !((&eio_freq_lock) | rxp_ignore_freq);
wire rxp_rst_s;

sync_regs rxp_rst_sync(
        .clk(clk100),
        .din(rxp_rst_in),
        .dout(rxp_rst_s)      
);
defparam rxp_rst_sync .WIDTH = 1;

reg [3:0] rxp_rst_cnt = 4'b0;
wire rxp_rst_dly = &rxp_rst_cnt;

// delay pll reset to allow logic to be safely reset first
always @(posedge clk100) begin
    if(~rxp_rst_s) rxp_rst_cnt <= 4'b0;
    else if(~rxp_rst_dly) rxp_rst_cnt <= rxp_rst_cnt+1'b1;
end

wire rd4_ready;
reset_delay rd4 (
        .clk(clk100),
        .ready_in(~rxp_rst_dly),
        .ready_out(rd4_ready)
);
defparam rd4 .CNTR_BITS = RST_CNTR;
assign rxp_rst = !rd4_ready;

reg soft_txp_rst = 1'b0;

wire rd5_ready;
reset_delay rd5 (
        .clk(clk100),
        .ready_in((~soft_txp_rst)),
        .ready_out(rd5_ready)
);
defparam rd5 .CNTR_BITS = RST_CNTR;

wire clk_tx_rsfec;
wire clk_rx_rsfec;

generate
    if (TIMING_MODE) begin
        assign rxp_lock = 1'b1;
        assign txp_lock = 1'b1;
        assign clk_rx_main = RX_CORE_CLK;
        assign clk_tx_main = TX_CORE_CLK;
    end else begin : PLLS
  if (SYNOPT_C4_RSFEC == 0) begin
    clkctrl clk_inst(                
                .inclk(rx_pma_div_clkout[PCS_CLK_LANE]),
                .outclk(clk_rx_main)
              );
            assign rxp_lock = rx_lockedtodata[PCS_CLK_LANE];
  end else begin
    wire refclk_buf;
    wire cal_busy;
    wire recal_is_done;
    wire rcfg_wtrqst;
    wire rcfg_write;
    wire rcfg_read;
    wire [9:0] rcfg_address;
    wire [31:0] rcfg_wrdata;
    wire [31:0] rcfg_rddata;

    alt_aeu_100_pll_recal recal_fpll (
        .mgmt_clk  (clk100),
                .mgmt_reset         (rxp_rst),
                .rcfg_write         (rcfg_write),
        .rcfg_read (rcfg_read),
                .rcfg_address       (rcfg_address),
        .rcfg_wrdata (rcfg_wrdata),
        .rcfg_rddata (rcfg_rddata),
        .rcfg_wtrqst (rcfg_wtrqst),
        .cal_busy    (cal_busy),
        .recal_is_done      (recal_is_done),
                .rx_is_lockedtodata (rx_lockedtodata[PCS_CLK_LANE])
    );

    clkctrl clk_inst(                
                .inclk(rx_pma_div_clkout[PCS_CLK_LANE]),
                .outclk(refclk_buf)
              );

    wire pll_locked;
    caui4_rxrs_fpll rxfpll(
                .pll_refclk0(refclk_buf),   //   pll_refclk0.clk
                .pll_powerdown(rxp_rst),           // pll_powerdown.pll_powerdown
                .pll_locked(pll_locked),             //    pll_locked.pll_locked
                .outclk0(clk_rx_rsfec),
                .reconfig_clk0  (clk100),
                .reconfig_reset0(rxp_rst),
                .reconfig_write0(rcfg_write),
                .reconfig_read0 (rcfg_read),
                .reconfig_address0    (rcfg_address),
                .reconfig_writedata0  (rcfg_wrdata),
                .reconfig_readdata0   (rcfg_rddata),
                .reconfig_waitrequest0(rcfg_wtrqst),
                .pll_cal_busy(cal_busy)        //  pll_cal_busy.pll_cal_busy
  );
    assign clk_rx_main = refclk_buf; 
            assign rxp_lock = pll_locked & recal_is_done && !rxp_rst_s;
  end

        if(EXT_TX_PLL) begin
 assign txp_lock = 1'b1;
 assign clk_tx_main = clk_txmac_in;
        end else begin
            wire txp_rst = ~rd5_ready;

  if           ((SYNOPT_C4_RSFEC == 0) && (PHY_REFCLK == 1)) begin : TX_PLL_644
       caui4_tx_pll_644 txp (
                .refclk(pll_ref),  
                .rst(txp_rst),     
                .outclk_0(clk_tx_main),
                .locked(txp_lock) 
       );
   end else if ((SYNOPT_C4_RSFEC == 0) && (PHY_REFCLK == 2)) begin : TX_PLL_322 
       caui4_tx_pll_322 txp (
                .refclk(pll_ref),  
                .rst(txp_rst),     
                .outclk_0(clk_tx_main),
                .locked(txp_lock) 
       );
   end else if ((SYNOPT_C4_RSFEC == 1) && (PHY_REFCLK == 1)) begin : TX_RSF_PLL_644
       caui4_txrs_pll_644 txp (
                .pll_refclk0  (pll_ref),
                .pll_powerdown(txp_rst),
                .outclk0      (clk_tx_main),
                .outclk1      (clk_tx_rsfec),
                .pll_locked   (txp_lock),
                .pll_cal_busy () 
       );
   end else if ((SYNOPT_C4_RSFEC == 1) && (PHY_REFCLK == 2)) begin : TX_RSF_PLL_322 
       caui4_txrs_pll_322 txp (
                .pll_refclk0  (pll_ref),
                .pll_powerdown(txp_rst),
                .outclk0      (clk_tx_main),
                .outclk1      (clk_tx_rsfec),
                .pll_locked   (txp_lock),
                .pll_cal_busy () 
       );
   end
        end   // EXT_PLL else
    end  //  timing_mode else
endgenerate


//////////////////////////////////////////////
// clock monitor
//////////////////////////////////////////////

wire [19:0] khz_ref,khz_rx,khz_tx,khz_rx_rec,khz_tx_io;
frequency_monitor fm0 (
        .signal({pll_ref,clk_rx_main,clk_tx_main,clk_rx_recover[0],clk_tx_io[0]}),
        .ref_clk(clk100),
        .khz_counters ({khz_ref,khz_rx,khz_tx,khz_rx_rec,khz_tx_io})
);
defparam fm0 .NUM_SIGNALS = 5;
defparam fm0 .REF_KHZ = 20'd100000;

//////////////////////////////////////
// PCS with RS-FEC
//////////////////////////////////////

wire [NUM_VLANE-1:0] frm_err_out;
wire [NUM_VLANE-1:0] opp_ping_out;
wire sclr_frm_err_s;
wire rx_pcs_soft_rst;

generate
    if (SYNOPT_C4_RSFEC) begin : rsfec
  wire rs_rst;
  wire rsfec_rst =  (!eio_rx_online | rx_pcs_soft_rst | rst100);
   
  sync_regs rs_reset_inst (
        .clk (clk_rx_recover[0]),
        .din(!eio_rx_online | rx_pcs_soft_rst | rst100),
        .dout(rs_rst)
  );
  defparam rs_reset_inst .WIDTH = 1;

  reg [1:0] rd_wait = 'd0;
  always @(posedge clk_rx_recover[0])
    if (rs_rst)         rd_wait <= 'd0;
    else if (~&rd_wait) rd_wait <= rd_wait + 1'b1;
 
  wire [4*4-1:0]  wused;
  wire [4*4-1:0]  rused;
  wire [1*4-1:0]  wfull;
  wire [1*4-1:0]  rempty;
  wire [4*80-1:0] rsa_din, rsa_dout; // only 64 bits used per lane

  for (i=0; i<=3; i=i+1) begin : rs_rxa
      assign rsa_din[(i+1)*80-1: i*80] = {16'b0,eio_dout[(i+1)*64-1: i*64]};

      dcfifo_mlab #(
                .WIDTH  (80) , // typical 20,40,60,80
        .ADDR_WIDTH(4),
        .TARGET_CHIP(TARGET_CHIP)
      ) rs_rxfifo_inst (
        .aclr   (rsfec_rst),
        .wclk   (clk_rx_recover[i]),
        .wdata  (rsa_din[(i+1)*80-1: i*80]),
        .wreq   (1'b1),
        .wfull  (wfull[i]),
        .wused  (wused[(i+1)*4-1: i*4]),
        .rclk   (clk_rx_recover[0]),
        .rdata  (rsa_dout[(i+1)*80-1: i*80]),
        .rreq   (&rd_wait),
        .rempty (rempty[i]),
        .rused  (rused[(i+1)*4-1: i*4])
      );
  end

  wire [4*66+2:0] caui4_rs_dout;

        alt_aeu_100_rs_rx rx_rsfec (
      .arst        (rsfec_rst),
      .l3_din_pma  (rsa_dout[4*80-17: 3*80]),
      .l2_din_pma  (rsa_dout[3*80-17: 2*80]),
      .l1_din_pma  (rsa_dout[2*80-17: 1*80]),
      .l0_din_pma  (rsa_dout[1*80-17: 0]),
      .lanes_valid_in_pma  ({4{&rd_wait}}),
      .mrg_data_mgr        (caui4_rs_dout[4*66-1:0]),
      .amcode_start_out_mgr(caui4_rs_dout[4*66]),
      .mrg_valid_out_mgr   (caui4_rs_dout[4*66+1]),
      .slip                (rx_bitslip),
      .reset_slv        (rst100),
      .serif_master_din (slave_din),
      .serif_slave_dout (rs_rxser_dout),
      .clk      (clk_rx_main),
      .clk_rs   (clk_rx_rsfec),
      .clk_csr  (clk100),
      .clk_pma  (clk_rx_recover[0])
      );
     defparam rx_rsfec .FEC_AM_BITS = AM_CNT_BITS;
     defparam rx_rsfec .BASE        = BASE_RXFEC;

  alt_aeu_100_rx_pcs_4 rpcs (   //NOTE !!! there are two alt_aeu_100_rx_pcs_4 instaniation. this is the 1st one
      .clk(clk_rx_main),
      .sclr(!eio_rx_online || rx_pcs_soft_rst),
      .rst_async (rst100),     // global reset, async, no domain, to reset link fault      
      .din(caui4_rs_dout),     // lsbit first serial streams
      .din_req(eio_dout_req),      // 4 copies
      
      .sclr_frm_err(sclr_frm_err_s),
      .frm_err_out(frm_err_out),
      .opp_ping_out(opp_ping_out),
      .rx_pcs_fully_aligned(rx_pcs_fully_aligned_raw),
      .hi_ber(rx_hi_ber_raw),
      
      .dout_d(dout_d),
      .dout_c(dout_c),
      .dsk_depths(dsk_depths),
      .dout_am(dout_am)
  );
  defparam rpcs .TARGET_CHIP = TARGET_CHIP;
  defparam rpcs .EN_LINK_FAULT = EN_LINK_FAULT;
  defparam rpcs .AM_CNT_BITS = AM_CNT_BITS;
  defparam rpcs .SIM_FAKE_JTAG = SIM_FAKE_JTAG;
  defparam rpcs .EARLY_REQ = 2;
  defparam rpcs .SYNOPT_FULL_SKEW = SYNOPT_FULL_SKEW;
  defparam rpcs .SYNOPT_C4_RSFEC  = 1;
  defparam rpcs .DIN_WIDTH        = 4*66+2;

  wire [4*64-1:0] rs_dout_pma;
  wire [4-1:0]    dout_valid;
  wire [4*66:0]   caui4_txrs_din;

  alt_aeu_100_tx_pcs_4 tpcs (
      .clk(clk_tx_main),
      .sclr(!eio_tx_online),
      
      .din_d(din_d), 
      .din_c(din_c), 
      .din_am(din_am),                // this din_d/c will be replaced with align markers
      .pre_din_am(pre_din_am),        // advance warning
      .tx_crc_ins_en(tx_crc_ins_en),
            
      .dout(caui4_txrs_din),           // lsbit first serial streams
      .dout_valid(eio_din_valid),
      .tx_mii_start(tx_mii_start)
  );
  defparam tpcs .TARGET_CHIP = TARGET_CHIP;
   defparam tpcs .SYNOPT_PTP = SYNOPT_PTP;
   defparam tpcs .PTP_LATENCY = PTP_LATENCY;
  defparam tpcs .EN_LINK_FAULT = EN_LINK_FAULT;
  defparam tpcs .AM_CNT_BITS = AM_CNT_BITS;
  defparam tpcs .CREATE_TX_SKEW = CREATE_TX_SKEW;
  defparam tpcs .SYNOPT_C4_RSFEC = 1;
  defparam tpcs .DOUT_WIDTH      = 4*66+1;

        alt_aeu_100_rs_tx tx_rsfec (
      .arst         (!eio_tx_online),
      .tcd_valid_in (eio_din_valid),
      .tcd_data_in  (caui4_txrs_din[4*66-1:0]),
      .am_start_in  (caui4_txrs_din[4*66]),
      .l3_dout_pma  (rs_dout_pma[4*64-1: 3*64]),
      .l2_dout_pma  (rs_dout_pma[3*64-1: 2*64]),
      .l1_dout_pma  (rs_dout_pma[2*64-1: 1*64]),
      .l0_dout_pma  (rs_dout_pma[1*64-1: 0]),
      .lanes_valid_out_pma(dout_valid),
      .reset_slv          (rst100),
      .serif_master_din   (slave_din),
      .serif_slave_dout   (rs_txser_dout),
      .clk      (clk_tx_main),
      .clk_rs   (clk_tx_rsfec),
      .clk_csr  (clk100),
      .clk_pma  (clk_tx_io[0])
    );
   defparam tx_rsfec .FEC_AM_BITS = AM_CNT_BITS;
   defparam tx_rsfec .BASE        = BASE_TXFEC;

  reg [4*4-1:0] rdtx_d1   = 'd0;
  reg [4*4-1:0] rdtx_d2   = 'd0;
  reg [4*4-1:0] rdtx_d3   = 'd0;
  reg [4*4-1:0] rdtx_wait = 'd0;
  wire [4*4-1:0]  wtxused;
  wire [4*4-1:0]  rtxused;
  wire [1*4-1:0]  wtxfull;
  wire [1*4-1:0]  rtxempty;
  wire [4*80-1:0] rstxa_din, rstxa_dout; // only 65 bits used per lane
  reg  [4*64-1:0] rstx_reg;
  reg  [4*1-1:0]  rstx_val;

  for (i=0; i<=3; i=i+1) begin : rs_txa
     always @(posedge clk_tx_io[i]) begin
       rdtx_d1[i]   <= eio_tx_online;
       rdtx_d2[i]   <= rdtx_d1[i];
       rdtx_d3[i]   <= rdtx_d2[i];
       rdtx_wait[i] <= rdtx_d3[i];
     end

     assign rstxa_din[(i+1)*80-1: i*80] = {15'b0, dout_valid[i], rs_dout_pma[(i+1)*64-1: i*64]};

     dcfifo_mlab #(
       .WIDTH(80) , // typical 20,40,60,80
       .ADDR_WIDTH(4),
       .TARGET_CHIP(TARGET_CHIP)
     ) rs_txfifo_inst (
       .aclr   (!eio_tx_online),
       .wclk   (clk_tx_io[0]),
       .wdata  (rstxa_din[(i+1)*80-1: i*80]),
       .wreq   (1'b1),
       .wfull  (wtxfull[i]),
       .wused  (wtxused[(i+1)*4-1: i*4]),
       .rclk   (clk_tx_io[i]),
       .rdata  (rstxa_dout[(i+1)*80-1: i*80]),
       .rreq   (rdtx_wait[i]),
       .rempty (rtxempty[i]),
       .rused  (rtxused[(i+1)*4-1: i*4])
     );

    always @(posedge clk_tx_io[i]) begin
      rstx_reg[(i+1)*64-1: i*64] <= rstxa_dout[(i*80)+63: i*80];
      rstx_val[i]                <= rstxa_dout[(i*80)+64];
    end

    assign eio_din[(i+1)*64-1: i*64] = rstx_reg[(i+1)*64-1: i*64];
  end

  assign eio_pma_din_valid = &rstx_val;

    //////////////////////////////////////
    // PCS without fec
    //////////////////////////////////////
    end else begin : wofec
  assign rx_bitslip = 4'b0;
  wire [3:0] rxa_din_req;
   
  for (i=0; i<4; i=i+1) begin: req
    assign rxa_din_req[i] = (eio_dout_req[i] | eio_rx_flush) & !rx_backup;
  end
  
  caui4_rx_adapter#(
        .TARGET_CHIP(TARGET_CHIP)
  ) caui4_rxa(
        .sclr(!eio_rx_online || rx_pcs_soft_rst),
        .clk_rxmac(clk_rx_main),
        .din_req(rxa_din_req),           // 4 copies
        .din(eio_dout),                  //input [4*64-1:0] din,
        .clk_rxpma(clk_rx_recover),      //input clk_rxpma,
        .dout(caui4_rxa_dout)            //output [16*20-1:0] dout
  );
  
  always @(posedge clk_rx_main) caui4_rxa_dout_r <= caui4_rxa_dout;
  always @(posedge clk_rx_main) caui4_rxa_dout_r2 <= caui4_rxa_dout_r;

  alt_aeu_100_rx_pcs_4 rpcs ( //there are two alt_aeu_100_rx_pcs_4 instaniation. this is the 2nd one
      .clk(clk_rx_main),
      .sclr(!eio_rx_online || rx_pcs_soft_rst),
      .rst_async (rst100),         // global reset, async, no domain, to reset link fault      
      .din(caui4_rxa_dout_r2),     // lsbit first serial streams
      .din_req(eio_dout_req),      // 4 copies
      
      .sclr_frm_err(sclr_frm_err_s),
      .frm_err_out(frm_err_out),
      .opp_ping_out(opp_ping_out),
      .rx_pcs_fully_aligned(rx_pcs_fully_aligned_raw),
      .hi_ber(rx_hi_ber_raw),
      
      .dout_d(dout_d),
      .dout_c(dout_c),
      .dsk_depths(dsk_depths),
      .dout_am(dout_am)
  );
  defparam rpcs .TARGET_CHIP = TARGET_CHIP;
  defparam rpcs .EN_LINK_FAULT = EN_LINK_FAULT;
  defparam rpcs .AM_CNT_BITS = AM_CNT_BITS;
  defparam rpcs .SIM_FAKE_JTAG = SIM_FAKE_JTAG;
  defparam rpcs .EARLY_REQ = 2;
  defparam rpcs .SYNOPT_FULL_SKEW = SYNOPT_FULL_SKEW;
  defparam rpcs .SYNOPT_C4_RSFEC  = 0;
  defparam rpcs .DIN_WIDTH        = 16*20;

  alt_aeu_100_tx_pcs_4 tpcs (
      .clk(clk_tx_main),
      .sclr(!eio_tx_online),
      
      .din_d(din_d), 
      .din_c(din_c), 
      .din_am(din_am),                // this din_d/c will be replaced with align markers
      .pre_din_am(pre_din_am),        // advance warning
      .tx_crc_ins_en(tx_crc_ins_en),
            
      .dout(caui4_txa_din),           // lsbit first serial streams
      .dout_valid(eio_din_valid),
      .tx_mii_start(tx_mii_start)
  );
  defparam tpcs .TARGET_CHIP = TARGET_CHIP;
  defparam tpcs .SYNOPT_PTP = SYNOPT_PTP;
  defparam tpcs .PTP_LATENCY = PTP_LATENCY;
  defparam tpcs .EN_LINK_FAULT = EN_LINK_FAULT;
  defparam tpcs .AM_CNT_BITS = AM_CNT_BITS;
  defparam tpcs .CREATE_TX_SKEW = CREATE_TX_SKEW;
  defparam tpcs .SYNOPT_C4_RSFEC = 0;
  defparam tpcs .DOUT_WIDTH      = 16*20;

  caui4_tx_adapter#(
        .TARGET_CHIP(TARGET_CHIP) 
  ) caui4_txa(
        .sclr(!eio_tx_online),     //input sclr,
        .clk_txmac(clk_tx_main),   //input clk_txmac,
        .din_valid(eio_din_valid), //input din_valid,
        .din(caui4_txa_din), 
        .clk_txpma(clk_tx_io),     //input clk_txpma,
        .dout(eio_din)                     //output [4*64-1:0] dout
  );

  assign eio_pma_din_valid = eio_din_valid & eio_tx_online;
    end
endgenerate

wire [NUM_VLANE-1:0] frm_err_out_s;
sync_regs sr1 (
        .clk (clk100),
        .din(frm_err_out & {NUM_VLANE{rxp_lock}}),
        .dout(frm_err_out_s)
);
defparam sr1 .WIDTH = NUM_VLANE;

reg sclr_frm_err = 1'b0;
sync_regs sr2 (
        .clk (clk_rx_main),
        .din(sclr_frm_err),
        .dout(sclr_frm_err_s)
);
defparam sr2 .WIDTH = 1;

reg rx_pcs_soft_rst_s = 1'b0;
reg eio_rx_soft_purge_s = 1'b0;

sync_regs sr3(
        .clk (clk_rx_main),
        .din ({eio_rx_soft_purge_s,rx_pcs_soft_rst_s}),
        .dout({eio_rx_soft_purge,  rx_pcs_soft_rst})    
);
defparam sr3 .WIDTH = 2;

wire rx_pcs_fully_aligned_s;
wire rx_hi_ber;
wire rx_hi_ber_s;

//assign rx_pcs_fully_aligned = rx_pcs_fully_aligned_raw && eio_rx_online;
initial rx_pcs_fully_aligned = 1'b0;
always @(posedge clk_rx_main or posedge rx_aclr_pcs_ready) begin
    if (rx_aclr_pcs_ready) rx_pcs_fully_aligned <= 1'b0;
    else                   rx_pcs_fully_aligned <= rx_pcs_fully_aligned_raw;
end

assign rx_hi_ber = rx_hi_ber_raw && eio_rx_online;
   
sync_regs sr4(
        .clk (clk100),
        .din ({rx_hi_ber,   rx_pcs_fully_aligned  }),
        .dout({rx_hi_ber_s, rx_pcs_fully_aligned_s})    
);
defparam sr4 .WIDTH = 2;

//////////////////////////////////////////////
// status page - 100G IO pins
//////////////////////////////////////////////

wire        ss1_wr, ss1_rd;
wire [7:0]  ss1_addr;
wire [31:0] ss1_wdata;
reg [31:0]  ss1_rdata = 32'h0;
reg         ss1_rdata_valid = 1'b0;
wire        ss1_dout;

serif_slave ss1 (
    .clk(clk100),
    .din(slave_din),
    .dout(ss1_slave_dout),

    .wr(ss1_wr),
    .rd(ss1_rd),
    .addr(ss1_addr),
    .wdata(ss1_wdata),
    .rdata(ss1_rdata),
    .rdata_valid(ss1_rdata_valid)
);
defparam ss1 .ADDR_PAGE = ADDR_PAGE;

wire reco_busy = 1'b0;
reg [31:0] scratch1 = 32'h0;
wire [12*8-1:0] io_name = "100GE pcs   ";
always @(posedge clk100) begin
    ss1_rdata_valid <= 1'b0;
    if (ss1_rd) begin
        ss1_rdata_valid <= 1'b1;
        case (ss1_addr)
            8'h0 : ss1_rdata <= REVID;
            8'h1 : ss1_rdata <= 32'h0 | scratch1;
            8'h2 : ss1_rdata <= 32'h0 | io_name[8*12-1:8*8];
            8'h3 : ss1_rdata <= 32'h0 | io_name[8*8-1:8*4];
            8'h4 : ss1_rdata <= 32'h0 | io_name[8*4-1:0];
            
            8'h10 : ss1_rdata <= 32'h0 | {set_data_lock,set_ref_lock,rxp_ignore_freq,soft_rxp_rst,
                                                                                        soft_txp_rst,eio_sys_rst};
            8'h13 : ss1_rdata <= 32'h0 | eio_sloop;
                        8'h14 : ss1_rdata <= 32'h0 | eio_flag_sel;
                        8'h15 : ss1_rdata <= 32'h0 | eio_flags;
                        
                        8'h20 : ss1_rdata <= 32'h0 | eio_tx_pll_locked;
                        8'h21 : ss1_rdata <= 32'h0 | eio_freq_lock;
                        8'h22 : ss1_rdata <= 32'h0 | {rxp_lock,txp_lock,txa_online};
                        8'h23 : ss1_rdata <= 32'h0 | frm_err_out_s;
                        8'h24 : ss1_rdata <= 32'h0 | sclr_frm_err;
                        8'h25 : ss1_rdata <= 32'h0 | {eio_rx_soft_purge_s,rx_pcs_soft_rst_s};
                        8'h26 : ss1_rdata <= 32'h0 | {rx_hi_ber_s, rx_pcs_fully_aligned_s};
                        
                    8'h40 : ss1_rdata <= 32'h0 | khz_ref;
            8'h41 : ss1_rdata <= 32'h0 | khz_rx;
            8'h42 : ss1_rdata <= 32'h0 | khz_tx;
            8'h43 : ss1_rdata <= 32'h0 | khz_rx_rec;
            8'h44 : ss1_rdata <= 32'h0 | khz_tx_io;

                        8'h50 : ss1_rdata <= 32'h0 | reco_addr;
                        8'h51 : ss1_rdata <= 32'h0 | {reco_busy, reco_write,reco_read};
                        8'h52 : ss1_rdata <= 32'h0 | reco_wdata;
                        8'h53 : ss1_rdata <= 32'h0 | reco_rdata;
            
            default : ss1_rdata <= 32'hdeadc0de;
        endcase
    end

    if (ss1_wr) begin
        case (ss1_addr)
            8'h1 : scratch1 <= ss1_wdata;
            8'h10 : {set_data_lock,set_ref_lock,rxp_ignore_freq,soft_rxp_rst,
                                                soft_txp_rst,eio_sys_rst} <= ss1_wdata[5:0];
        
            8'h13 : eio_sloop <= ss1_wdata[9:0];             
            8'h14 : eio_flag_sel <= ss1_wdata[2:0];             
            
            8'h24 : sclr_frm_err <= ss1_wdata[0];
            8'h25 : {eio_rx_soft_purge_s,rx_pcs_soft_rst_s} <= ss1_wdata[1:0];
                        
            8'h50 : reco_addr <= ss1_wdata[11:0];
            8'h51 : {reco_write,reco_read} <= ss1_wdata[1:0];
            8'h52 : reco_wdata <= ss1_wdata;
                                
        endcase
    end
end

//////////////////////////////////////////////
// resets
//////////////////////////////////////////////
reg tx_lanes_stable_r = 1'b0;
always @(posedge clk_tx_main) begin
        tx_lanes_stable_r <= eio_tx_online;
end
assign tx_lanes_stable = tx_lanes_stable_r && txp_lock;

reg srst_tx_main_r = 1'b0;
always @(posedge clk_tx_main) begin
        srst_tx_main_r <= !eio_tx_online;
end
assign srst_tx_main = srst_tx_main_r;

reg srst_rx_main_r = 1'b0;
always @(posedge clk_rx_main) begin
        srst_rx_main_r <= !eio_rx_online;
end
assign srst_rx_main = srst_rx_main_r;


//////////////////////////////////////////////
// debug
//////////////////////////////////////////////
/*              
always @(posedge clk_tx_io[0])
   if (rx_pcs_fully_aligned) $display("PMA 0 TX %h", eio_din[63:0]);

always @(posedge clk_tx_io[1])
   if (rx_pcs_fully_aligned) $display("PMA 1 TX %h", eio_din[127:64]);

always @(posedge clk_tx_io[2])
   if (rx_pcs_fully_aligned) $display("PMA 2 TX %h", eio_din[191:128]);

always @(posedge clk_tx_io[3])
   if (rx_pcs_fully_aligned) $display("PMA 3 TX %h", eio_din[255:192]);

reg [255:0] eio_dout_r0;
reg [255:0] eio_dout_r1;
reg [255:0] eio_dout_r2;
reg [255:0] eio_dout_r3;
always @(posedge clk_rx_recover[0]) eio_dout_r0 <= eio_dout;
always @(posedge clk_rx_recover[1]) eio_dout_r1 <= eio_dout;
always @(posedge clk_rx_recover[2]) eio_dout_r2 <= eio_dout;
always @(posedge clk_rx_recover[3]) eio_dout_r3 <= eio_dout;

always @(posedge clk_rx_recover[0]) begin
  if (rx_pcs_fully_aligned) begin
   $display("PMA 0 RX 0 %h", eio_dout[63:0]);
   $display("PMA 0 RX 1 %h", {eio_dout[62:0], eio_dout_r0[63]});
   $display("PMA 0 RX 2 %h", {eio_dout[61:0], eio_dout_r0[63:62]});
   $display("PMA 0 RX 3 %h", {eio_dout[60:0], eio_dout_r0[63:61]});
  end
end

always @(posedge clk_rx_recover[1]) begin
  if (rx_pcs_fully_aligned) begin
   $display("PMA 1 RX 0 %h", eio_dout[127:64]);
   $display("PMA 1 RX 1 %h", {eio_dout[126:64], eio_dout_r1[127]});
   $display("PMA 1 RX 2 %h", {eio_dout[125:64], eio_dout_r1[127:126]});
   $display("PMA 1 RX 3 %h", {eio_dout[124:64], eio_dout_r1[127:125]});
  end
end

always @(posedge clk_rx_recover[2]) begin
  if (rx_pcs_fully_aligned) begin
   $display("PMA 2 RX 0 %h", eio_dout[191:128]);
   $display("PMA 2 RX 1 %h", {eio_dout[190:128], eio_dout_r2[191]});
   $display("PMA 2 RX 2 %h", {eio_dout[189:128], eio_dout_r2[191:190]});
   $display("PMA 2 RX 3 %h", {eio_dout[188:128], eio_dout_r2[191:189]});
  end
end

always @(posedge clk_rx_recover[3]) begin
  if (rx_pcs_fully_aligned) begin
   $display("PMA 3 RX 0 %h", eio_dout[255:192]);
   $display("PMA 3 RX 1 %h", {eio_dout[254:192], eio_dout_r3[255]});
   $display("PMA 3 RX 2 %h", {eio_dout[253:192], eio_dout_r3[255:254]});
   $display("PMA 3 RX 3 %h", {eio_dout[252:192], eio_dout_r3[255:253]});
  end
end

always @(posedge clk_rx_main)
   if (rx_pcs_fully_aligned && dout_req_r2[0]) $display("TORXPCS %h", caui4_rxa_dout_r2[15:0]);

reg [319:0] caui4_txa_din_r;
always @(posedge clk_tx_main) if (eio_din_valid) caui4_txa_din_r <= caui4_txa_din;

always @(posedge clk_tx_main) begin
  if (rx_pcs_fully_aligned) begin
   if (eio_din_valid) $display("FROMTXPCS 0 %h", caui4_txa_din[15:0]);
   if (eio_din_valid) $display("FROMTXPCS 1 %h", {caui4_txa_din[14:0], caui4_txa_din_r[15]});
   if (eio_din_valid) $display("FROMTXPCS 2 %h", {caui4_txa_din[13:0], caui4_txa_din_r[15:14]});
   if (eio_din_valid) $display("FROMTXPCS 3 %h", {caui4_txa_din[12:0], caui4_txa_din_r[15:13]});
   if (eio_din_valid) $display("FROMTXPCS 4 %h", {caui4_txa_din[11:0], caui4_txa_din_r[15:12]});
   if (eio_din_valid) $display("FROMTXPCS 5 %h", {caui4_txa_din[10:0], caui4_txa_din_r[15:11]});
   if (eio_din_valid) $display("FROMTXPCS 6 %h", {caui4_txa_din[ 9:0], caui4_txa_din_r[15:10]});
   if (eio_din_valid) $display("FROMTXPCS 7 %h", {caui4_txa_din[ 8:0], caui4_txa_din_r[15: 9]});
   if (eio_din_valid) $display("FROMTXPCS 8 %h", {caui4_txa_din[ 7:0], caui4_txa_din_r[15: 8]});
   if (eio_din_valid) $display("FROMTXPCS 9 %h", {caui4_txa_din[ 6:0], caui4_txa_din_r[15: 7]});
   if (eio_din_valid) $display("FROMTXPCS a %h", {caui4_txa_din[ 5:0], caui4_txa_din_r[15: 6]});
   if (eio_din_valid) $display("FROMTXPCS b %h", {caui4_txa_din[ 4:0], caui4_txa_din_r[15: 5]});
   if (eio_din_valid) $display("FROMTXPCS c %h", {caui4_txa_din[ 3:0], caui4_txa_din_r[15: 4]});
   if (eio_din_valid) $display("FROMTXPCS d %h", {caui4_txa_din[ 2:0], caui4_txa_din_r[15: 3]});
   if (eio_din_valid) $display("FROMTXPCS e %h", {caui4_txa_din[ 1:0], caui4_txa_din_r[15: 2]});
   if (eio_din_valid) $display("FROMTXPCS f %h", {caui4_txa_din[   0], caui4_txa_din_r[15: 1]});
 end
end

always @(posedge clk_tx_main)
   if (rx_pcs_fully_aligned && eio_din_valid) $display("FROMTXPCS %h", caui4_txa_din);

caui4_rx_pll rxpll (
                .refclk(clk_rx_recover[2]),  
                .rst(rxp_rst),     
                .outclk_0(clk_rx_main),
                .locked(rxp_lock) 
);
*/
endmodule
