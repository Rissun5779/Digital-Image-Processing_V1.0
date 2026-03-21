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




//============================================================================
// This confidential and proprietary software may be used only as authorized
// by a licensing agreement from ALTERA 
// copyright notice must be reproduced on all authorized copies.
//============================================================================
//


//
//****************************************************************************
// KR PHY Channel module
// Contains the Native PHY and channel-level soft logic
//****************************************************************************
`define CTL_BFL 9
`define TOTAL_XGMII_LANE 8
`define TOTAL_DATA_PER_LANE 8
`define TOTAL_CONTROL_PER_LANE 1
`define TOTAL_SIGNAL_PER_LANE (`TOTAL_DATA_PER_LANE+`TOTAL_CONTROL_PER_LANE)

`timescale 1 ps / 1 ps

module ultra_chnl
  #(
  parameter ES_DEVICE        = 1,            // select ES or PROD device, 1 is ES-DEVICE, 0 is device
  parameter REF_CLK_FREQ_10G = "322.265625", // select native PHY refclk
  parameter HARD_PRBS_ENABLE = 0,           // Synthesize Hard PRBS ge/chk logic in Native PHY
  parameter SYNTH_AN         = 1,          // Synthesize/include the AN logic
  parameter SYNTH_LT         = 1,          // Synthesize/include the LT logic
  parameter SYNTH_GIGE       = 0,          // Synthesize/include the GIGE logic
  parameter SYNTH_GMII       = 0,          // Synthesize/include the GMII PCS
  parameter SYNTH_FEC        = 0,          // Synthesize/include the FEC logic
  parameter INI_DATAPATH     = "10G",      // intial/reset datapath
  parameter LTD_MSB          = 8'd100,     // Locked_to_data counter MSB
     // GIGE_PCS Parameters
  parameter PHY_IDENTIFIER   = 32'h 00000000, // PHY Identifier
  parameter DEV_VERSION      = 16'h 0001 ,  //  Customer Phy's Core Version
  parameter SYNTH_SGMII      = 1,           // Enable SGMII logic for synthesis
  parameter SYNTH_CL37ANEG   = 0,           // Synth GIGE AN logic (Clause 37)
  parameter SYNTH_1588_1G    = 0,           // Synthesize/include 1588 1G logic
  parameter SYNTH_1588_10G   = 0,           // Synthesize/include 1588 10G logic
     // LT parameters
  parameter BERWIDTH         = 10,      // Width (4-12) of the Bit Error counter
  parameter TRNWTWIDTH       = 7,       // Width (7,8) of Training Wait counter
  parameter MAINTAPWIDTH     = 6,            // Width of the Main Tap control
  parameter POSTTAPWIDTH     = 6,            // Width of the Post Tap control
  parameter PRETAPWIDTH      = 5,            // Width of the Pre Tap control
     // AN parameters
  parameter AN_PAUSE         = 3'b000,     // Pause ability, depends upon MAC
  parameter AN_TECH          = 6'b00_0101, // Tech ability, only 10G and GIGE
                                         // bit-0 = GigE, bit-1 = XAUI
                                         // bit-2 = 10G , bit-3 = 40G BP
                                         // bit 4 = 40G-CR4, bit 5 = 100G-CR10
  parameter AN_SELECTOR      = 5'b0_0001,    // AN selector field 802.3 = 5'd1
  parameter CAPABLE_FEC      = 0,    // FEC ability on power on
  parameter ENABLE_FEC       = 0,    // FEC request on power on
  parameter ERR_INDICATION   = 0    // Turn error indication on/off
  )(
     // clocks
  input  wire     tx_serial_clk_10g,   // high speed serial clock0
  input  wire     tx_serial_clk_1g,    // high speed serial clock1
  input  wire     rx_cdr_ref_clk_10g,  // cdr_ref_clk
  input  wire     rx_cdr_ref_clk_1g,   // cdr_ref_clk
  input  wire     xgmii_tx_clk,        // user XGMII tx_clk input
  input  wire     xgmii_rx_clk,        // user XGMII rx_clk output
  input  wire     calc_clk_1g,         // 1588 calc clock
  output wire     tx_clkout,           // TX Parallel clock output
  output wire     rx_clkout,           // RX parallel clock output
  output wire     tx_pma_clkout,       // TX PMA clock output
  output wire     rx_pma_clkout,       // RX PMA clock output
  output wire     tx_pma_div_clkout,   // TX DIV33 clock
  output wire     rx_pma_div_clkout,   // RX DIV33 clock
     // Reset inputs
  input   wire         tx_analogreset,
  input   wire         tx_digitalreset,
  input   wire         rx_analogreset,
  input   wire         rx_digitalreset,
  output  wire         tx_analogreset_ack,
  output  wire         rx_analogreset_ack,
     // Avalon I/F
  input  wire         mgmt_clk,
  input  wire         mgmt_clk_reset,
  input  wire [10:0]  mgmt_address,
  input  wire         mgmt_read,
  output wire [31:0]  mgmt_readdata,
  output wire         mgmt_waitrequest,
  input  wire         mgmt_write,
  input  wire [31:0]  mgmt_writedata,
    // GMII interface
  input  wire [7:0]           gmii_tx_d,
  output wire [7:0]           gmii_rx_d,
  input  wire                 gmii_tx_en,
  input  wire                 gmii_tx_err,
  output wire                 gmii_rx_err,
  output wire                 gmii_rx_dv,
    // GMII Status
  output wire                 led_an,
  output wire                 led_char_err,
  output wire                 led_disp_err,
  output wire                 led_link,
  output wire                 led_panel_link,
  output wire                 tx_pcfifo_error_1g,  //Phase comp. FIFO full/empty
  output wire                 rx_pcfifo_error_1g,  //Phase comp. FIFO full/empty
  output wire                 rx_syncstatus,
  input  wire                 rx_clkslip,
    // MII interface
  output wire                 mii_tx_clkena,
  output wire                 mii_tx_clkena_half_rate,
  input  wire[3:0]            mii_tx_d,
  input  wire                 mii_tx_en,
  input  wire                 mii_tx_err,
  output wire                 mii_rx_clkena,
  output wire                 mii_rx_clkena_half_rate,
  output wire[3:0]            mii_rx_d,
  output wire                 mii_rx_dv,
  output wire                 mii_rx_err,
  output reg [1:0]            mii_speed_sel,
    // XGMII interface
  input wire  [71:0]      xgmii_tx_dc,       // XGMII data to PMA.
  output wire [71:0]      xgmii_rx_dc,       // XGMII data from PMA.
  output wire         rx_is_lockedtodata,    // rx_is_lockedtodata.export
  output wire         rx_is_lockedtoref,    // rx_is_lockedtoref.export
  output wire         tx_cal_busy,
  output wire         rx_cal_busy,
  output wire         rx_data_ready,
  output wire         rx_block_lock,
  output wire         rx_hi_ber,
  output wire         tx_serial_data,        // tx_serial_data.export
  input  wire         rx_serial_data,        // rx_serial_data.export
    // IEEE-1588 status
  output wire [16-1 : 0]  rx_latency_adj_10g,
  output wire [16-1 : 0]  tx_latency_adj_10g,
  output wire [22-1 : 0]  rx_latency_adj_1g,
  output wire [22-1 : 0]  tx_latency_adj_1g,
    // PRBS ports    
  input  wire             rx_prbs_err_clr,
  output wire             rx_prbs_done,
  output wire             rx_prbs_err,
    // may go away and/or change at some point
  input  wire            lcl_rf,         // local device Remote Fault = D13
  input  wire            rxeq_done,      // Local RX Equalization is finished
  input  wire            lt_rc_active,
  input  wire            rc_busy,
  input  wire            seq_start_rc,
    // Sequencer datapath
  output wire             pcs_link_sts,
  output wire             lt_fail_response,
  input  wire  [5:0]      pcs_mode_rc,
  input  wire  [1:0]      data_mux_sel,
  input  wire             seq_restart_an,
  input  wire             seq_restart_lt,
  output wire             training,
  output wire             dis_max_wait_tmr,
  input  wire             link_ready,
  input  wire             seq_an_timeout,
    // sequencer CSR
  output wire             csr_reset_all,
  input  wire             seq_lt_timeout,
  output wire             csr_seq_restart,
  output wire             dis_an_timer,
  output wire             dis_lf_timer,
  output wire [3:0]       force_mode,
  output wire             fail_lt_if_ber,
  output wire             an_enable,
  output wire             en_usr_np,
  output wire             lt_enable,
  input  wire             enable_fec,
  output wire             load_pdet,
  output wire [2:0]       par_det,
  output wire [5:0]       fnl_an_tech,     // final AN_TECH parameter
  output wire [1:0]       fnl_an_fec,      // final the AN_FEC parameter
  output wire             link_good,
  output wire             an_rx_idle,
  output wire             in_ability_det,
  output wire [5:0]       lp_tech,    // LP Technology ability = D45:21
  output wire [1:0]       lp_fec,     // LP FEC ability = D47:46  output reg
    // LT datapath
  output reg             ltd_ok_1ms ,      // LTD stable for 1 ms - to NOIS
  input  wire            clr_ltd_ok_1ms ,  // LTD stable clear
  input  wire             rmt_upd_new,     // New coef to send to LP
  input  wire [5:0]       rmt_coef_updl,   // Coef update low bits to LP
  input  wire [13:12]     rmt_coef_updh,   // Coef update hi bits to LP
  input  wire           lcl_sts_new,    // local status has changed
  input  wire [5:0]     lcl_coef_sts,   // local coefficient status to LP
  output wire             lcl_upd_new,     // New coef from LP
  output wire [5:0]       lcl_coefl,       // Coef update low bits from LP
  output wire [13:12]     lcl_coefh,       // Coef update hi bits from LP
  output wire           rmt_rx_ready,   // remote receiver ready from LP
  output wire [5:0]     rmt_coef_sts,   // remote RX coeff status from LP
  output wire [BERWIDTH-1:0] ber_cnt,        // BER counter value
  output wire               ber_max,         // BER counter roll-over
  output wire               bert_done,   // BER Timer at max count for SM
  input  wire               clear_ber,   // clear the BER counter
  input  wire               rx_trained,  // rx_trained status
  input  wire         training_error,    // Training Error (ber_max)
  input  wire         train_lock_err,    // Training Frame Lock Error
  input  wire [MAINTAPWIDTH-1:0] main_rc, // main tap value for reconfig
  input  wire [POSTTAPWIDTH-1:0] post_rc, // post tap value for reconfig
  input  wire [PRETAPWIDTH-1:0]  pre_rc,  // pre tap value for reconfig
  output wire           csr_restart_lt,
  output wire           training_fail,    // Training timed-out
  output wire           training_reset,
  input  wire           dis_tx_data,
  input  wire     frame_lock_filt,
  output wire     frame_lock,
  input  wire     nolock_rxeq,
  input  wire     fail_ctle,
  input  wire [1:0]   last_dfe_mode,
  input  wire [3:0]   last_ctle_rc,
  input  wire [1:0]   last_ctle_mode,
  output wire [2*MAINTAPWIDTH+POSTTAPWIDTH+PRETAPWIDTH+3:0]  param_ovrd,
  output wire          en_rcfg_cal
  );

//****************************************************************************
// Define Parameters
//****************************************************************************
  // FEC bits for AN, bit1=request, bit0=ability- only when FEC
  localparam AN_FEC = (SYNTH_FEC)? {ENABLE_FEC[0],CAPABLE_FEC[0]} : 2'b00 ;

  // Pipleline register for Native interface
  localparam  ENABLE_TX_PIPELINE = 1 ;
  localparam  ENABLE_RX_PIPELINE = 1 ;

  // Combine parameters for easier reading
  localparam  SYNTH_1588  = SYNTH_1588_1G && SYNTH_1588_10G ;
  localparam  SYNTH_AN_LT = SYNTH_AN || SYNTH_LT ;
  // param REF_CLK --> 0 -> 322 MHz, 1->644 MHz, 2 ->312 MHz
  localparam  REF_CLK      = (REF_CLK_FREQ_10G == "322.265625") ? 0 : (REF_CLK_FREQ_10G == "312.50000") ? 2 : 1 ;
  
  // PCS Offset for 1588
  localparam  TX_PCS_OFFSET_10G = 16'h321E;
  localparam  RX_PCS_OFFSET_10G = 16'h2CFF;
  localparam  TX_PCS_OFFSET_1G  = 6'd8;
  localparam  RX_PCS_OFFSET_1G  = 6'd16;

//****************************************************************************
// Define Wires
//****************************************************************************
  // for PHY
  wire         tx_coreclkin;
  wire [63:0]  tx_parallel_data;
  reg  [127:0] tx_parallel_data_to_pcs;
  reg  [7:0]   tx_parallel_ctrl;
  reg  [8:0]   tx_parallel_ctrl_to_pcs;
  reg          tx_10g_data_valid_to_pcs ;
  wire         rx_10g_data_valid_from_pcs;
  wire         rx_bitslip;            // sig the PMA to slip the datastream
  wire [65:0]  an_data;               // raw data from AN.  bit-0 first
  wire [31:0]  lt_data;               // raw data from LT.  bit-0 first
  wire [31:0]  an_mgmt_readdata;     // read data from the AN CSR module
  wire [31:0]  lt_mgmt_readdata;     // read data from the LT CSR module
  wire [31:0]  fec_mgmt_readdata;    // read data from the SEQ/TOP CSR

  // for 1G10G
  wire    [ 64-1:0 ] tx_parallel_data_10g;
  wire    [ 64-1:0 ] tx_parallel_data_native;
  wire    [  8-1:0 ] tx_parallel_data_1g;
  wire    [  8-1:0 ] rx_parallel_data_1g;
  reg     [ 64-1:0 ] rx_parallel_data_native;
  wire    [128-1:0 ] rx_parallel_data_native_from_pcs;
  wire    [  8-1:0 ] tx_10g_control;
  wire    [ 64-1:0 ] rx_dataout;
  wire    [ 10-1:0 ] rx_10g_control;
  wire               tx_std_pcfifo_full;
  wire               rx_std_pcfifo_full;
  wire               tx_std_pcfifo_empty;
  wire               rx_std_pcfifo_empty;

  // for IEEE-1588 10G
  wire [16-1:0]    tx_latency_adj_10g_int;
  wire [16-1:0]    rx_latency_adj_10g_int;
  wire [64-1:0]    tx_parallel_data_1588;
  wire [64-1:0]    rx_parallel_data_1588;
  wire             tx_10g_data_valid;
  wire             tx_10g_fifo_full;
  wire             tx_10g_fifo_full_inter;
  wire [8-1:0]     tx_10g_control_inter;
  reg  [10-1:0]    rx_10g_control_inter;
  wire [20-1:0]    rx_10g_control_inter_from_pcs;
  wire             rx_10g_fifo_full;
  wire             rx_10g_fifo_full_inter;
  reg              rx_10g_data_valid;
  wire             rx_enh_fifo_del,rx_enh_fifo_insert ; // may be used for 1588 Hard
  wire [3:0]       tx_10g_fifo_cnt;        //  may be used for 1588 Hard
  wire [4:0]       rx_10g_fifo_cnt;        //  may be used for 1588 Hard
  wire [31:0]      reconfig_readdata;      // read data PHY
  wire [ 5-1 : 0]  rx_std_bitslipboundarysel; // 1588 status
  wire             waitrequest, reconfig_waitrequest;
  wire             gige_pcs_waitreq;
  wire             gige_pcs_read;

  // FEC related
  reg    fec_tx_err_ins_pulse;
  wire   fec_enable;
  wire   fec_request;
  wire   fec_err_ind;

 // HSSI signals sync'ed on mgmt-clk  
  wire   rx_analogreset_ack_hssi,tx_analogreset_ack_hssi,rx_cal_busy_hssi; 
  wire   tx_cal_busy_hssi, rx_is_lockedtodata_hssi, rx_is_lockedtoref_hssi;
 // LT signals sync'ed on mgmt-clk  
  wire   frame_lock_lt_clk;
  wire [5:0]  rmt_coef_sts_lt_clk;
  // write-en for CSR. All PHY CSR start with 0x400
  wire           addr_soft_csr ;
  wire           addr_hard_reg ;
  
  assign addr_soft_csr = (mgmt_address >= 11'h400) && (mgmt_address <= 11'h4DF);
  assign addr_hard_reg = (mgmt_address <= 11'h3FF);


//****************************************************************************
// Instantiate the AN module
// also have the AN CSRs and test logic
//****************************************************************************
generate
  if (SYNTH_AN) begin: AN_GEN
    // signals between AN and CSRs
    wire         an_restart;         // re-start the AN process
    wire         restart_txsm;       // re-start the TXSM/ARB only
    wire         csr_lcl_rf;         // local device Remote Fault = D13
    wire         lcl_rf_sent;        // local device sent RF
    wire         en_usr_bp;          // Enable user base pages
    wire [48:16] usr_base_pgh;       // User base page hi bits
    wire [14:1]  usr_base_pgl;       // User base page low bits
    wire [48:16] usr_next_pgh;       // User next page hi bits
    wire [14:1]  usr_next_pgl;       // User next page low bits
    wire         lp_an_able;         // link partner is able to AN
    wire         an_pg_received;     // ARB SM has rcvd 3 codewords w/ ACK
    wire [48:1]  lp_base_pg;         // Link Partner base page data
    wire [48:1]  lp_next_pg;         // Link Partner next page data
    wire [2:0]   lp_pause;           // LP pause capability = D12:10
    wire         lp_rf;              // link partner Remote Fault = D13
    wire [24:6]  lp_tech_hi;         // LP Technology unused high bits
    wire         usr_new_np;  // New next page, hand shake with usr_np_sent
    wire         usr_np_sent; // next page sent, hand shake with usr_new_np
    wire         csr_hold_nonce;     // Mode for UNH testing to hold TX_nonce
    wire         an_tm_enable;       // AN test mode enable
    wire [3:0]   an_inj_err;        // inject errors into the AN TX data
    wire [3:0]   an_tm_err_mode;
    wire [3:0]   an_tm_err_trig;
    wire [7:0]   an_tm_err_time;
    wire [7:0]   an_tm_err_cnt;
    wire         en_an_param_ovrd;   // Enable AN parameter override
    wire [5:0]   ovrd_an_tech;       // override the AN_TECH parameter
    wire [1:0]   ovrd_an_fec;        // override the AN_FEC parameter
    wire [2:0]   ovrd_an_pause;      // override the AN_PAUSE parameter
    wire [2:0]   fnl_an_pause;       // final the AN_PAUSE parameter
    wire [65:0]  rx_an_data;         // raw data to AN. bit-0 first
    wire         tx_an_reset, rx_an_reset;

      // the AN data is raw bits
    assign rx_an_data = {rx_10g_control_inter[1],
                         rx_10g_control_inter[0],
                         rx_parallel_data_native};

    an_top #(
      .PCNTWIDTH    (4),
      .AN_SELECTOR  (AN_SELECTOR)
    ) AUTO_NEG (
      .AN_PAUSE     (fnl_an_pause),
      .AN_TECH      (fnl_an_tech),
      .AN_FEC       (fnl_an_fec),
      .tx_rstn      (~tx_an_reset),
      .tx_clk       (xgmii_tx_clk),
      .rx_rstn      (~rx_an_reset),
      .rx_clk       (rx_pma_div_clkout),
      .an_enable    (an_enable),
      .an_restart   (an_restart | seq_restart_an),
      .restart_txsm (restart_txsm),
      .lcl_rf       (lcl_rf | csr_lcl_rf),
      .en_usr_bp    (en_usr_bp),
      .en_usr_np    (en_usr_np),
      .usr_base_pgh (usr_base_pgh),
      .usr_base_pgl (usr_base_pgl),
      .usr_next_pgh (usr_next_pgh),
      .usr_next_pgl (usr_next_pgl),
      .usr_new_np   (usr_new_np),
      .hold_nonce   (csr_hold_nonce),
         // outputs
      .lp_an_able      (lp_an_able),
      .link_good       (link_good),
      .in_ability_det  (in_ability_det),
      .an_rx_idle      (an_rx_idle),
      .lcl_rf_sent     (lcl_rf_sent),
      .lp_pause        (lp_pause),
      .lp_rf           (lp_rf),
      .lp_tech         ({lp_tech_hi,lp_tech}),
      .lp_fec          (lp_fec),
      .an_pg_received  (an_pg_received),
      .lp_base_pg      (lp_base_pg),
      .lp_next_pg      (lp_next_pg),
      .usr_np_sent     (usr_np_sent),
      .load_pdet       (load_pdet),
      .par_det         (par_det),
         // data
      .dme_in       (rx_an_data),
      .inj_err      (an_inj_err),
      .dme_out      (an_data)
    );

    // instantiate the AN registers at address 0xC0 - 0xCF
    csr_kran  csr_kran_inst (
      .clk        (mgmt_clk                     ),
      .reset      (mgmt_clk_reset               ),
      .address    (mgmt_address[7:0]            ),
      .read       (mgmt_read                    ),
      .readdata   (an_mgmt_readdata             ),
      .write      (mgmt_write & addr_soft_csr   ),
      .writedata  (mgmt_writedata               ),
    //status inputs to this CSR
      .an_pg_received   (an_pg_received),
      .an_completed     (link_good),
      .lcl_dvce_rf_sent (lcl_rf_sent),
      .an_rx_idle       (an_rx_idle),
      .an_ability       (1'b1),       // if have AN, then should read 1
      .an_status        (link_good),  // latch low version
      .lp_an_able       (lp_an_able),
      .lp_fec_neg       (enable_fec),
      .an_failure       (seq_an_timeout),
      .an_link_ready
             ({3'd0,pcs_mode_rc[2]&link_ready,1'b0,pcs_mode_rc[3]&link_ready}),
      .lp_base_pg   (lp_base_pg),
      .lp_next_pg   (lp_next_pg),
      .lp_tech      ({lp_tech_hi,lp_tech}),
      .lp_fec       (lp_fec),
      .lp_rf        (lp_rf),
      .lp_pause     (lp_pause),
    // read/write control outputs
      .csr_an_enable    (an_enable),
      .usr_base_page_en (en_usr_bp),
      .usr_nxt_page_en  (en_usr_np),
      .usr_lcl_dvce_rf  (csr_lcl_rf),
      .csr_reset_an     (an_restart),
      .csr_restart_txsm (restart_txsm),
      .new_np_ready     (usr_new_np),
      .usr_base_pg_lo   (usr_base_pgl),
      .usr_base_pg_hi   (usr_base_pgh),
      .usr_next_pg_lo   (usr_next_pgl),
      .usr_next_pg_hi   (usr_next_pgh),
      .csr_hold_nonce   (csr_hold_nonce),
      .en_an_param_ovrd (en_an_param_ovrd),
      .ovrd_an_tech     (ovrd_an_tech),
      .ovrd_an_fec      (ovrd_an_fec),
      .ovrd_an_pause    (ovrd_an_pause),
      .an_tm_enable     (an_tm_enable),
      .an_tm_err_mode   (an_tm_err_mode),
      .an_tm_err_trig   (an_tm_err_trig),
      .an_tm_err_time   (an_tm_err_time),
      .an_tm_err_cnt    (an_tm_err_cnt)
    );

       // Override the AN Parameters
    assign fnl_an_tech  = en_an_param_ovrd ? ovrd_an_tech  : AN_TECH[5:0];
    assign fnl_an_fec   = en_an_param_ovrd ? ovrd_an_fec   : {fec_request,fec_enable} ;
    assign fnl_an_pause = en_an_param_ovrd ? ovrd_an_pause : AN_PAUSE[2:0];

       // instantiate the AN Test mode logic here
    assign an_inj_err          = 4'd0;

      // instantiate the reset synchronizers for the AN module
      //  \p4\ip\altera_xcvr_generic\ctrl\alt_xcvr_resync.sv
    alt_xcvr_resync #(
        .SYNC_CHAIN_LENGTH(2),  // Number of flip-flops for retiming
        .WIDTH            (1),  // Number of bits to resync
        .INIT_VALUE       (1)
    ) txan_resync_reset (
      .clk    (xgmii_tx_clk),
      .reset  (csr_reset_all),
      .d      (1'b0),
      .q      (tx_an_reset)
    );
  
    alt_xcvr_resync #(
        .SYNC_CHAIN_LENGTH(2),  // Number of flip-flops for retiming
        .WIDTH            (1),  // Number of bits to resync
        .INIT_VALUE       (1)
    ) rxan_resync_reset (
      .clk    (rx_pma_div_clkout),
      .reset  (csr_reset_all),
      .d      (1'b0),
      .q      (rx_an_reset)
    );

  end  // if synth_an
  else begin: NO_AN_GEN  // need to drive outputs if no AN module
    assign link_good      = 1'b0;
    assign in_ability_det = 1'b0;
    assign an_rx_idle     = 1'b1;
    assign an_enable      = 1'b0;
    assign en_usr_np      = 1'b0;
    assign load_pdet      = 1'b0;
    assign par_det        = 3'd0;
    assign lp_tech = 6'd0;
    assign lp_fec  = 2'd0;
    assign an_data = 66'd0;
    assign an_mgmt_readdata = 32'd0;
    assign fnl_an_tech  = AN_TECH[5:0];
    assign fnl_an_fec   = {fec_request, fec_enable};
  end  // else synth_an
endgenerate


//****************************************************************************
// Instantiate the LT module
// also have the LT CSRs and test logic
//****************************************************************************
generate
  if (SYNTH_LT) begin: LT_CHNL
       // signals between LT and CSRs
    wire         rx_lt_reset;
    wire         tx_lt_reset;
    wire [9:0]   sim_ber_t;         // Time(frames) to cnt when ber_time=0
    wire [9:0]   ber_time;          // Time(K-frames) to count BER Errors
    wire [9:0]   ber_ext;           // Extend(M-frames) Time to count BER
    wire         lcl_rx_ready;
    wire         use_full_time;
    wire [7:0]   lp_txo_update;     // Override LP TX update bits
    wire         lp_tx_upd_new;     // Override LP TX update new
    wire         ovrd_coef_rx;      // Override lcl coef update enable
    wire [7:0]   lcl_rxo_update;    // Override lcl coef update bits from CSR
    wire         ovrd_rx_new;       // Override lcl coef update new
    wire         ovrd_lp_coef;      // Override LP TX update enable
    wire         dis_init_pma;      // disable initialize PMA on timeout
    wire         lt_tm_enable;      // LT test mode enable
    wire [3:0]   lt_tm_err_mode;
    wire [3:0]   lt_tm_err_trig;
    wire [7:0]   lt_tm_err_time;
    wire [7:0]   lt_tm_err_cnt;
    wire           rmt_mux_new;
    wire [5:0]     rmt_mux_updl;
    wire [13:12]   rmt_mux_updh;
    wire           lcl_upd_new_int;
    wire [5:0]     lcl_coefl_int;
    wire [13:12]   lcl_coefh_int;

    lta10_ultra_top #(
      .BERWIDTH   (BERWIDTH),
      .TRNWTWIDTH (TRNWTWIDTH)
    ) LINK_TRAIN (
      .tx_rstn      (~tx_lt_reset),
      .tx_clk       (tx_clkout),
      .rx_rstn      (~rx_lt_reset),
      .rx_clk       (rx_clkout),
      .lt_enable    (lt_enable & (data_mux_sel == 2'b01)),
      .lt_restart   (csr_restart_lt | seq_restart_lt),
      // data ports
      .rx_data_in  (rx_parallel_data_native[31:0]),
      .tx_data_out (lt_data),
      .rx_bitslip  (rx_bitslip),
      // outputs to CSR for status
      .training        (training),
      .training_fail   (training_fail),
      .rx_trained      (rx_trained),
       // register bits for setting of operating mode
      .sim_ber_t      (sim_ber_t),
      .ber_time       (ber_time),
      .ber_ext        (ber_ext),
      .dis_max_wait_tmr (dis_max_wait_tmr),
      .dis_init_pma   (dis_init_pma),
      .inj_err        (4'b0),
      .use_full_time  (use_full_time),
      .rxeq_done      (rxeq_done),
       // for the re-partition
      .training_reset   (training_reset),
      .dis_tx_data      (dis_tx_data),
      .lt_rc_active     (lt_rc_active),
      .rmt_upd_new    (rmt_mux_new),
      .rmt_coef_updl  (rmt_mux_updl),
      .rmt_coef_updh  (rmt_mux_updh),
      .lcl_sts_new    (lcl_sts_new),
      .lcl_coef_sts   (lcl_coef_sts),
      .lcl_upd_new    (lcl_upd_new_int),  // mask for timeout
      .lcl_coefl      (lcl_coefl_int),
      .lcl_coefh      (lcl_coefh_int),
      .rmt_rx_ready   (rmt_rx_ready),
      .rmt_coef_sts   (rmt_coef_sts_lt_clk),
      .lcl_rx_ready   (lcl_rx_ready),
      .ber_cnt   (ber_cnt),
      .ber_max   (ber_max),
      .bert_done (bert_done),
      .clear_ber       (clear_ber),
      .frame_lock_filt (frame_lock_filt),
      .frame_lock      (frame_lock_lt_clk)
   );

    // CSR wires not used with Nios as it reads values via AVMM
    // still have wires/connections for warning abatement
    wire         quick_mode;        // Only look at init & preset EQ state
    wire         pass_one;          // look beyond first min in BER count
    wire [3:0]   main_step_cnt;     // Number of EQ steps per main update
    wire [3:0]   prpo_step_cnt;     // EQ steps for pre/post tap update
    wire [2:0]   equal_cnt;         // Number to make BER counts Equal
    wire [2:0]   rx_ctle_mode;
    wire [2:0]   rx_dfe_mode;
    wire         max_mode;
    wire         fixed_mode;
    wire [2:0]   max_post_step;
    wire [1:0]   ctle_depth;
    wire [1:0]   dfe_extra;
    wire         only_inc_main;
    wire [2:0]   ctle_bias;
    wire         dec_post;
    wire         dec_post_more;
    wire         ctle_pass_ber;

    // sync frame_lock signal to mgmt-clk -- goes to CPU, CSR
  // sync signals from HSSI
    alt_xcvr_resync #(
      .WIDTH  (7)       // Number of bits to resync
    ) frame_lck_sync (
      .clk    (mgmt_clk),
      .reset  (mgmt_clk_reset),
      .d      ({rmt_coef_sts_lt_clk,frame_lock_lt_clk}),
      .q      ({rmt_coef_sts       ,frame_lock})
    );

    
    // instantiate the LT registers at address 0xD0 - 0xDF
    csr_kra10lt #(
      .ES_DEVICE    (ES_DEVICE),
      .MAINTAPWIDTH (MAINTAPWIDTH),
      .POSTTAPWIDTH (POSTTAPWIDTH),
      .PRETAPWIDTH  (PRETAPWIDTH)
      ) csr_krlt_inst (
      .clk        (mgmt_clk          ),
      .reset      (mgmt_clk_reset    ),
      .address    (mgmt_address[7:0] ),
      .read       (mgmt_read         ),
      .readdata   (lt_mgmt_readdata  ),
      .write      (mgmt_write & addr_soft_csr),
      .writedata  (mgmt_writedata    ),
    //status inputs to this CSR
      .pcs_mode_rc   (pcs_mode_rc),
      .rx_trained    (rx_trained),
      .lt_frame_lock (frame_lock),
      .training      (training),
      .training_fail (training_fail),
      .training_error(training_error),
      .train_lock_err  (train_lock_err),
      .lcl_txi_update  ({rmt_mux_updh, rmt_mux_updl}),
      .lcl_tx_upd_new  (rmt_mux_new),
      .lcl_txi_status  ({lcl_rx_ready,  lcl_coef_sts}),
      .lcl_tx_stat_new (lcl_sts_new),
      .lp_rxi_update   ({lcl_coefh, lcl_coefl}),
      .lp_rx_upd_new   (lcl_upd_new_int),
      .lp_rxi_status   ({rmt_rx_ready, rmt_coef_sts}),
      .lp_rx_stat_new  (lcl_upd_new_int),
      .nolock_rxeq     (nolock_rxeq),
      .fail_ctle       (fail_ctle),
      .last_dfe_mode   (last_dfe_mode),
      .last_ctle_rc    (last_ctle_rc),
      .last_ctle_mode  (last_ctle_mode),
      .main_rc     (main_rc),
      .post_rc     (post_rc),
      .pre_rc      (pre_rc),
    // read/write control outputs
      .csr_lt_enable    (lt_enable),
      .dis_max_wait_tmr (dis_max_wait_tmr),
      .dis_init_pma     (dis_init_pma),
      .quick_mode       (quick_mode),
      .pass_one         (pass_one),
      .main_step_cnt    (main_step_cnt),
      .prpo_step_cnt    (prpo_step_cnt),
      .equal_cnt        (equal_cnt),
      .ovrd_lp_coef (ovrd_lp_coef),
      .ovrd_coef_rx (ovrd_coef_rx),
      .rx_ctle_mode  (rx_ctle_mode),
      .rx_dfe_mode   (rx_dfe_mode),
      .max_mode      (max_mode),
      .fixed_mode    (fixed_mode),
      .max_post_step (max_post_step),
      .ctle_depth    (ctle_depth),
      .dfe_extra     (dfe_extra),
      .only_inc_main (only_inc_main),
      .ctle_bias      (ctle_bias),
      .dec_post       (dec_post),
      .dec_post_more  (dec_post_more),
      .ctle_pass_ber  (ctle_pass_ber),
      .use_full_time  (use_full_time),
      .csr_reset_lt (csr_restart_lt),
      .ber_time     (sim_ber_t),
      .ber_k_time   (ber_time),
      .ber_m_time   (ber_ext),
      .lcl_txo_update (lp_txo_update),
      .lp_tx_upd_new  (lp_tx_upd_new),
      .lcl_rxo_update (lcl_rxo_update),
      .ovrd_rx_new    (ovrd_rx_new),
      .param_ovrd     (param_ovrd),
      .lt_tm_enable   (lt_tm_enable),
      .lt_tm_err_mode (lt_tm_err_mode),
      .lt_tm_err_trig (lt_tm_err_trig),
      .lt_tm_err_time (lt_tm_err_time),
      .lt_tm_err_cnt  (lt_tm_err_cnt)
    );

    // mux the remote TX update inputs for SW/CSR override
    assign rmt_mux_new  = ovrd_lp_coef ? lp_tx_upd_new      : rmt_upd_new;
    assign rmt_mux_updl = ovrd_lp_coef ? lp_txo_update[5:0] : rmt_coef_updl;
    assign rmt_mux_updh = ovrd_lp_coef ? lp_txo_update[7:6] : rmt_coef_updh;

    // mux the inputs to the local update for SW/CSR override
    assign lcl_coefl = ovrd_coef_rx ? lcl_rxo_update[5:0] : lcl_coefl_int;
    assign lcl_coefh = ovrd_coef_rx ? lcl_rxo_update[7:6] : lcl_coefh_int;
       // mask the local update for timout
    assign lcl_upd_new = ovrd_coef_rx ? ovrd_rx_new       :
                                            lcl_upd_new_int & ~training_fail;

      // instantiate the reset synchronizers for the LT module
      //  \p4\ip\altera_xcvr_generic\ctrl\alt_xcvr_resync.sv
    alt_xcvr_resync #(
        .SYNC_CHAIN_LENGTH(2),  // Number of flip-flops for retiming
        .WIDTH            (1),  // Number of bits to resync
        .INIT_VALUE       (1)
    ) txlt_resync_reset (
      .clk    (tx_clkout),
      .reset  (csr_reset_all),
      .d      (1'b0),
      .q      (tx_lt_reset)
    );
  
    alt_xcvr_resync #(
        .SYNC_CHAIN_LENGTH(2),  // Number of flip-flops for retiming
        .WIDTH            (1),  // Number of bits to resync
        .INIT_VALUE       (1)
    ) rxlt_resync_reset (
      .clk    (rx_clkout),
      .reset  (csr_reset_all),
      .d      (1'b0),
      .q      (rx_lt_reset)
    );

  end  // if synth_lt
  else begin: NO_LT_CHNL   // need to drive outputs if no LT module
    assign lt_enable        = 1'b0;
    assign dis_max_wait_tmr = 1'b0;
    assign rx_bitslip       = 1'b0;
    assign training         = 1'b0;
    assign frame_lock       = 1'b0;
    assign lt_data          = 32'd0;
    assign lt_mgmt_readdata = 32'd0;
    assign param_ovrd   = 1'b0;
    assign lcl_upd_new  = 1'b0;
    assign lcl_coefl    = 'd0;
    assign lcl_coefh    = 'd0;
    assign rmt_rx_ready = 1'b0;
    assign rmt_coef_sts = 'd0;
    assign csr_restart_lt  = 1'b0;
    assign training_fail   = 1'b0;
    assign training_reset  = 1'b0;
    assign ber_cnt   = 'd0;
    assign ber_max   = 'd0;
    assign bert_done = 'd0;
  end  // else synth_lt
endgenerate


//****************************************************************************
// Muxes/logic for the AN/LT data and status
// Selection is made by the Sequencer
// 00 = AN, 01 = LT, 1x = xgmii
//****************************************************************************
  wire rx_deskew_status = 1'b0;
  wire csr_rx_set_locktoref;      // to xcvr instance from csr
  wire csr_rx_set_locktodata;     // to xcvr instance from csr
  wire fnl_set_locktoref;         // override lock_to_ref for AN mode
  wire fnl_set_locktodata;        // override lock_to_data for LT mode
  wire rx_coreclkin;

  assign tx_parallel_ctrl = pcs_mode_rc[5] ? tx_10g_control_inter : // 10G FEC
                            pcs_mode_rc[2] ? tx_10g_control_inter : // 10G
                            pcs_mode_rc[1] ? 8'd0                 : // LT
                            {6'd0, an_data[65], an_data[64]};       // AN-default

  assign tx_parallel_data   = pcs_mode_rc[1]  ? {32'h0,lt_data} :  // LT
                              pcs_mode_rc[0]  ? an_data[63:0]   :  // AN
                              tx_parallel_data_native           ;  // 1G/10G data


  // keep pcs_link_sts masked for 1 ms- to account for toggles on LTD
  // LSB counter counts to 1000, and MSB counter max value is calculated in tcl
  // increment counter on high rx_is_lockedtodata, clear it moment rx_is_lockedtodata is low , freeze on highest count
  // with ability to clear bit below if needed
  reg [9:0] stage_one;  // stage one, count 1000 clocks
  reg  stage_one_max;   // stage one at max count
  reg [7:0] stage_two; // second stage, count till LTD_MSB
  reg stage_two_max;   // stage two at max count
  wire [9:0] stage_one_max_count ;
  wire [7:0] stage_two_max_count ;

`ifdef ALTERA_RESERVED_XCVR_FULL_KR_TIMERS
   assign stage_one_max_count = 1000 ;
   assign stage_two_max_count = LTD_MSB;
`else // not FULL_KR_TIMERS  
   assign stage_one_max_count = 10 ;
   assign stage_two_max_count = 2;
`endif // FULL_KR_TIMERS

  always_ff @(posedge mgmt_clk) begin
    if (~rx_is_lockedtodata) 
      stage_one     <= 10'd0;
    else if (clr_ltd_ok_1ms)
      stage_one     <= 10'd0;
    else if (stage_one==stage_one_max_count)
      stage_one     <= 10'd0;
    else if (stage_one!=stage_one_max_count) 
      stage_one <= stage_one + 1'b1;
  end //always

  always_ff @(posedge mgmt_clk) begin
    if (~rx_is_lockedtodata) 
      stage_two     <= 10'd0;
    else if (clr_ltd_ok_1ms)
      stage_two     <= 10'd0;
    else if ((stage_two!=stage_two_max_count) && (stage_one==stage_one_max_count) )
      stage_two <= stage_two + 1'b1;
  end //always
  
  always @ (posedge mgmt_clk)
    ltd_ok_1ms <= (stage_two==stage_two_max_count) ;	 

  // Mux the link status depending upon which datapath is active
  assign pcs_link_sts = 
           pcs_mode_rc[2] ? rx_data_ready & ltd_ok_1ms : // 10G status
           pcs_mode_rc[3] ? rx_syncstatus & rx_is_lockedtodata : // 1G status
           pcs_mode_rc[4] ? rx_deskew_status                   : // XAUI status
           pcs_mode_rc[5] ? rx_data_ready & ltd_ok_1ms : // FEC PCS stat
           1'b0;

  // override lock_to signals depending uppn datapath mode
  assign fnl_set_locktoref = pcs_mode_rc[0] ? 1'b1 : // AN mode - force LTR
                             pcs_mode_rc[1] ? 1'b0 : // LT mode - Auto LTD
                             csr_rx_set_locktoref;
  assign fnl_set_locktodata = pcs_mode_rc[0] ? 1'b0 : // AN mode - force LTR
                              pcs_mode_rc[1] ? 1'b0 : // LT mode - Auto LTD
                              csr_rx_set_locktodata;


//****************************************************************************
// Instantiate the RX clock mux
// can simplify to mux the pma_div_clkout onto the clkout, but the timing arcs
// inside the HSSI don't support and need to modify the reconfig_data files
//****************************************************************************
//
// MODE      | PCS_MODE_RC bit  |  RX_CORECLK_IN   |  SYNTH_1588
//...........|..................|..................|..............
// AN        |      0           |   rx_div33       |   rx_div33
// LT        |      1           |   rx_clkout      |   rx_clkout
// 10G BASER |      2           |   xgmii_rx_clk   |   rx_clkout
// 1G        |      3           |   rx_clkout      |   rx_clkout
// 10G_FEC   |      5           |   xgmii_rx_clk   |   rx_div40

generate
  if          ( SYNTH_AN_LT &&  SYNTH_1588) begin : RX_CLK_MUX_KR_1588
  // use glitch-free clock_mux with 1-hot enabling as LUTs may glitch
    gf_clock_mux  gf_rx_clk_mux_inst (
       .clk         ({rx_clkout         , rx_pma_div_clkout}),
       .clk_select  ({|pcs_mode_rc[3:1] , pcs_mode_rc[5] |pcs_mode_rc[0]}),
       .clk_out     (rx_coreclkin)
    );
  end else if (!SYNTH_AN_LT &&  SYNTH_1588 && !SYNTH_FEC) begin : RX_CLK_MUX_LS_1588
    assign rx_coreclkin  = rx_clkout ;
  end else if (!SYNTH_AN_LT &&  SYNTH_1588 &&  SYNTH_FEC) begin : RX_CLK_MUX_LS_FEC1588
    gf_clock_mux  gf_rx_clk_mux_inst (
       .clk         ({rx_clkout      , rx_pma_div_clkout}),
       .clk_select  ({pcs_mode_rc[3] , pcs_mode_rc[2]}),
       .clk_out     (rx_coreclkin)
    );
  end else if ( SYNTH_AN_LT && !SYNTH_1588) begin : RX_CLK_MUX_KR
    gf_clock_mux #(
       .num_clocks (3)
    ) gf_rx_clk_mux_inst (
       .clk         ({ rx_clkout                     , xgmii_rx_clk                , rx_pma_div_clkout}),
       .clk_select  ({pcs_mode_rc[3] | pcs_mode_rc[1], pcs_mode_rc[5] | pcs_mode_rc[2], pcs_mode_rc[0]}),
       .clk_out     (rx_coreclkin)
    );
  end else begin : RX_CLK_MUX_LS // !SYNTH_AN  !SYNTH_LT  !SYNTH_1588  !SYNTH_FEC
    gf_clock_mux  gf_rx_clk_mux_inst (
       .clk         ({rx_clkout      , xgmii_rx_clk      }), // use 10g-coreclkin from 1588 if-generate
       .clk_select  ({pcs_mode_rc[3] , pcs_mode_rc[2]    }),
       .clk_out     (rx_coreclkin)
    );
  end
endgenerate

//****************************************************************************
// Instantiate the TX clock mux 
// can simplify to mux the pma_div_clkout onto the clkout, but the timing arcs
// inside the HSSI don't support and need to modify the reconfig_data files
//****************************************************************************
//
// MODE      | PCS_MODE_RC bit  |  TX_CORECLK_IN   |  1588 mode
//...........|..................|..................|................
// AN        |      0           |   xgmii_tx_clk   |   xgmii_tx_clk
// LT        |      1           |   tx_clkout      |   tx_clkout
// 10G BASER |      2           |   xgmii_tx_clk   |   tx_clkout
// 1G        |      3           |   tx_clkout      |   tx_clkout
// 10G_FEC   |      5           |   xgmii_tx_clk   |   tx_div40

generate 
  if          ( SYNTH_1588 && !SYNTH_FEC &&  SYNTH_AN_LT) begin : TX_CLK_MUX_KR_1588
    gf_clock_mux gf_tx_clk_mux_inst (
       .clk         ({xgmii_tx_clk  ,    tx_clkout }),
       .clk_select  ({pcs_mode_rc[0], ~pcs_mode_rc[0]}),
       .clk_out     (tx_coreclkin)
    );
  end else if ( SYNTH_1588 && !SYNTH_FEC && !SYNTH_AN_LT) begin : TX_CLK_MUX_LS_1588
    assign tx_coreclkin = tx_clkout;
  end else if ( SYNTH_1588 &&  SYNTH_FEC &&  SYNTH_AN_LT) begin : TX_CLK_MUX_KR_FEC1588
    gf_clock_mux #(
       .num_clocks (3)
    ) gf_tx_clk_mux_inst (
       .clk         ({xgmii_tx_clk  ,   tx_clkout      ,tx_pma_div_clkout}),
       .clk_select  ({pcs_mode_rc[0], |pcs_mode_rc[3:1],   pcs_mode_rc[5]}),
       .clk_out     (tx_coreclkin)
    );
  end else if ( SYNTH_1588 &&  SYNTH_FEC && !SYNTH_AN_LT) begin : TX_CLK_MUX_LS_FEC1588
    gf_clock_mux gf_tx_clk_mux_inst (
       .clk         ({tx_clkout     , tx_pma_div_clkout}),
       .clk_select  ({pcs_mode_rc[3], pcs_mode_rc[2]}),
       .clk_out     (tx_coreclkin)
    );
  end else begin : TX_CLK_MUX_KR
    gf_clock_mux gf_tx_clk_mux_inst (
       .clk         ({xgmii_tx_clk                                    ,    tx_clkout }),
       .clk_select  ({pcs_mode_rc[5] | pcs_mode_rc[2] | pcs_mode_rc[0], pcs_mode_rc[3] | pcs_mode_rc[1]}),
       .clk_out     (tx_coreclkin)
    );
  end
endgenerate


//****************************************************************************
// Instantiate Native PHY
//****************************************************************************
  wire csr_phy_loopback_serial;     // to xcvr instance from csr
//  wire rx_is_lockedtoref;
  wire clr_errblk_cnt;
  wire clr_ber_cnt;
  wire rx_std_bitrev_ena;
  wire tx_std_elecidle;
  wire tx_std_polinv;
  wire rx_std_polinv;
  // Final reset signals
  wire tx_analogreset_fnl;
  wire tx_digitalreset_fnl;
  wire rx_analogreset_fnl;
  wire rx_digitalreset_fnl;
  wire csr_tx_digitalreset;       // to xcvr instance from csr
  wire csr_rx_analogreset;        // to xcvr instance from csr
  wire csr_rx_digitalreset;       // to xcvr instance from csr

// Not integrating the PHY reset controller. Have external controller inputs
  assign  tx_analogreset_fnl  = tx_analogreset;
  assign  tx_digitalreset_fnl = tx_digitalreset  | csr_tx_digitalreset;
  assign  rx_analogreset_fnl  = rx_analogreset   | csr_rx_analogreset;
  assign  rx_digitalreset_fnl = rx_digitalreset  | csr_rx_digitalreset;

// TX pipeline register
generate
  if (ENABLE_TX_PIPELINE == 1) begin : TX_PIPELN
     always @ (posedge tx_coreclkin) begin
     tx_parallel_data_to_pcs <= {64'h0,tx_parallel_data} ;
     tx_parallel_ctrl_to_pcs <= {fec_tx_err_ins_pulse,tx_parallel_ctrl};
     tx_10g_data_valid_to_pcs <= tx_10g_data_valid;
     end
  end
  else begin : NO_TX_PIPELN
    always_comb  begin
    tx_parallel_data_to_pcs  = {64'h0,tx_parallel_data} ;
    tx_parallel_ctrl_to_pcs  = {fec_tx_err_ins_pulse,tx_parallel_ctrl};
    tx_10g_data_valid_to_pcs = tx_10g_data_valid;
    end
  end
endgenerate

// RX pipeline register
generate
  if (!SYNTH_1588 && ENABLE_RX_PIPELINE) begin : RX_PIPELN
     always @ (posedge rx_coreclkin) begin
     rx_parallel_data_native <= rx_parallel_data_native_from_pcs[63:0];
     rx_10g_control_inter    <= rx_10g_control_inter_from_pcs[9:0];
     end
  end
  else if (SYNTH_1588 && ENABLE_RX_PIPELINE) begin : RX_1588_PIPELN
    // 1588 requires HSSI RX FIFO in register mode
    // HSSI RX register mode requires negative-edge register for timing
    reg [63:0] rx_parallel_negedge /* synthesis preserve */;
    reg [9:0]  rx_10g_ctrl_negedge /* synthesis preserve */;
    reg        rx_10g_dval_negedge /* synthesis preserve */;

     always @ (negedge rx_coreclkin) begin
     rx_parallel_negedge  <= rx_parallel_data_native_from_pcs[63:0];
     rx_10g_ctrl_negedge  <= rx_10g_control_inter_from_pcs[9:0];
     rx_10g_dval_negedge  <= rx_10g_data_valid_from_pcs;
     end

     always @ (posedge rx_coreclkin) begin
     rx_parallel_data_native <= rx_parallel_negedge;
     rx_10g_control_inter    <= rx_10g_ctrl_negedge;
     rx_10g_data_valid       <= rx_10g_dval_negedge;
     end
  end
  else if (!SYNTH_1588 && !ENABLE_RX_PIPELINE) begin : NO_RX_PIPELN
    always_comb  begin
    rx_parallel_data_native  = rx_parallel_data_native_from_pcs[63:0];
    rx_10g_control_inter     = rx_10g_control_inter_from_pcs[9:0];
    end
  end
  else if (SYNTH_1588 && !ENABLE_RX_PIPELINE) begin : NO_RX_1588_PIPELN
    always_comb  begin
    rx_parallel_data_native  = rx_parallel_data_native_from_pcs[63:0];
    rx_10g_control_inter     = rx_10g_control_inter_from_pcs[9:0];
    rx_10g_data_valid        = rx_10g_data_valid_from_pcs;
    end
  end
endgenerate

`define ALTERA_XCVR_KR_NATIVE_PORT_MAPPING  (                               \
                 .tx_analogreset            (tx_analogreset_fnl              ) ,\
                 .tx_digitalreset           (tx_digitalreset_fnl             ) ,\
                 .rx_analogreset            (rx_analogreset_fnl              ) ,\
                 .rx_digitalreset           (rx_digitalreset_fnl             ) ,\
                 .tx_analogreset_ack        (tx_analogreset_ack_hssi         ) ,\
                 .rx_analogreset_ack        (rx_analogreset_ack_hssi         ) ,\
                 .tx_cal_busy               (tx_cal_busy_hssi                ) ,\
                 .rx_cal_busy               (rx_cal_busy_hssi                ) ,\
                 .tx_serial_clk0            (tx_serial_clk_10g               ) ,\
                 .tx_serial_clk1            (tx_serial_clk_1g                ) ,\
                 .rx_cdr_refclk0            (rx_cdr_ref_clk_10g              ) ,\
                 .rx_cdr_refclk1            (rx_cdr_ref_clk_1g               ) ,\
                 .tx_serial_data            (tx_serial_data                  ) ,\
                 .rx_serial_data            (rx_serial_data                  ) ,\
                 .rx_pma_clkslip            (rx_clkslip                      ) ,\
                 .rx_seriallpbken           (csr_phy_loopback_serial         ) ,\
                 .rx_set_locktodata         (fnl_set_locktodata              ) ,\
                 .rx_set_locktoref          (fnl_set_locktoref               ) ,\
                 .rx_is_lockedtoref         (rx_is_lockedtoref_hssi          ) ,\
                 .rx_is_lockedtodata        (rx_is_lockedtodata_hssi         ) ,\
                 .tx_coreclkin              (tx_coreclkin                    ) ,\
                 .rx_coreclkin              (rx_coreclkin                    ) ,\
                 .tx_clkout                 (tx_clkout                       ) ,\
                 .rx_clkout                 (rx_clkout                       ) ,\
                 .tx_pma_clkout             (tx_pma_clkout                   ) ,\
                 .tx_pma_div_clkout         (tx_pma_div_clkout               ) ,\
                 .rx_pma_clkout             (rx_pma_clkout                   ) ,\
                 .rx_pma_div_clkout         (rx_pma_div_clkout               ) ,\
                 .tx_parallel_data          (tx_parallel_data_to_pcs         ) ,\
                 .rx_parallel_data          (rx_parallel_data_native_from_pcs) ,\
                 .tx_control                ({9'h0,tx_parallel_ctrl_to_pcs}  ) ,\
                 .rx_control                (rx_10g_control_inter_from_pcs   ) ,\
                 .rx_bitslip                (rx_bitslip                      ) ,\
                 .tx_std_pcfifo_full        (tx_std_pcfifo_full              ) ,\
                 .tx_std_pcfifo_empty       (tx_std_pcfifo_empty             ) ,\
                 .rx_std_pcfifo_full        (rx_std_pcfifo_full              ) ,\
                 .rx_std_pcfifo_empty       (rx_std_pcfifo_empty             ) ,\
                 .rx_std_bitrev_ena         (rx_std_bitrev_ena               ) ,\
                 .tx_polinv                 (tx_std_polinv                   ) ,\
                 .rx_polinv                 (rx_std_polinv                   ) ,\
                 .rx_std_bitslipboundarysel (rx_std_bitslipboundarysel       ) ,\
                 .tx_enh_data_valid         (tx_10g_data_valid_to_pcs        ) ,\
                 .tx_enh_fifo_full          (tx_10g_fifo_full_inter          ) ,\
                 .tx_enh_fifo_cnt           (tx_10g_fifo_cnt                 ) ,\
                 .rx_enh_data_valid         (rx_10g_data_valid_from_pcs      ) ,\
                 .rx_enh_fifo_full          (rx_10g_fifo_full_inter          ) ,\
                 .rx_enh_fifo_del           (rx_enh_fifo_del                 ) ,\
                 .rx_enh_fifo_insert        (rx_enh_fifo_insert              ) ,\
                 .rx_enh_fifo_cnt           (rx_10g_fifo_cnt                 ) ,\
                 .rx_enh_highber            (rx_hi_ber                       ) ,\
                 .rx_enh_highber_clr_cnt    (clr_ber_cnt                     ) ,\
                 .rx_enh_clr_errblk_count   (clr_errblk_cnt                  ) ,\
                 .rx_enh_blk_lock           (rx_block_lock                   ) ,\
                 .rx_prbs_err_clr           (rx_prbs_err_clr                 ) ,\
                 .rx_prbs_err               (rx_prbs_err                     ) ,\
                 .rx_prbs_done              (rx_prbs_done                    ) ,\
                 .reconfig_clk              (mgmt_clk                        ) ,\
                 .reconfig_reset            (mgmt_clk_reset                  ) ,\
                 .reconfig_write            (mgmt_write & addr_hard_reg      ) ,\
                 .reconfig_read             (mgmt_read  & addr_hard_reg      ) ,\
                 .reconfig_address          (mgmt_address[9:0]               ) ,\
                 .reconfig_writedata        (mgmt_writedata                  ) ,\
                 .reconfig_readdata         (reconfig_readdata               ) ,\
                 .reconfig_waitrequest      (reconfig_waitrequest            )  \
    );

// different varaints are combination of
//   1. REFCLK (644/322/312)  2. FEC - 1/0  3. 1588 - 1/ 0
//   Total 8 vairants .. only 6 are valid as 1588 and FEC is Engineering mode
//   and not supported by the Native PHY
//   Also, 1588 is for both 1G and 10G, can't have one without the other
generate
// 10G variants for when INI_DATAPATH=10G
 if (INI_DATAPATH=="10G") begin : DATAPATH_10G
     if ((!SYNTH_FEC)&&(REF_CLK==0)&&(!SYNTH_1588) && (!HARD_PRBS_ENABLE) && (!SYNTH_AN_LT))  begin : NATIVE_PHY_10G_322_LS
     native_10g_322_ls native_10g_322_ls_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((!SYNTH_FEC)&&(REF_CLK==0)&&(SYNTH_1588) && (!HARD_PRBS_ENABLE) && (!SYNTH_AN_LT))  begin : NATIVE_PHY_10G_1588_322_LS
     native_10g_1588_322_ls native_10g_1588_322_ls_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((!SYNTH_FEC)&&(REF_CLK==2)&&(SYNTH_1588) && (!HARD_PRBS_ENABLE) && (!SYNTH_AN_LT))  begin : NATIVE_PHY_10G_1588_312_LS
     native_10g_1588_312_ls native_10g_1588_312_ls_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((!SYNTH_FEC)&&(REF_CLK==1)&&(!SYNTH_1588) && (!HARD_PRBS_ENABLE) && (!SYNTH_AN_LT))  begin : NATIVE_PHY_10G_644_LS
     native_10g_644_ls  native_10g_644_ls_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((!SYNTH_FEC)&&(REF_CLK==1)&&(SYNTH_1588) && (!HARD_PRBS_ENABLE) && (!SYNTH_AN_LT))  begin : NATIVE_PHY_10G_1588_644_LS
     native_10g_1588_644_ls native_10g_1588_644_ls_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((SYNTH_FEC)&&(REF_CLK==0)&&(!SYNTH_1588) && (!HARD_PRBS_ENABLE) && (!SYNTH_AN_LT))  begin : NATIVE_PHY_10G_FEC_322_LS
     native_10g_fec_322_ls  native_10g_fec_322_ls_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((SYNTH_FEC)&&(REF_CLK==0)&&(SYNTH_1588) && (!HARD_PRBS_ENABLE) && (!SYNTH_AN_LT))  begin : NATIVE_PHY_10G_1588_FEC_LS
     native_10g_fec_1588_322_ls native_10g_fec_1588_322_ls_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((SYNTH_FEC)&&(REF_CLK==1)&&(!SYNTH_1588) && (!HARD_PRBS_ENABLE) && (!SYNTH_AN_LT))  begin : NATIVE_PHY_10G_FEC_644_LS
     native_10g_fec_644_ls native_10g_fec_644_ls_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((SYNTH_FEC)&&(REF_CLK==1)&&(SYNTH_1588) && (!HARD_PRBS_ENABLE) && (!SYNTH_AN_LT))  begin : NATIVE_PHY_10G_1588_644_FEC_LS
     native_10g_fec_1588_644_ls native_10g_fec_1588_644_ls_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((!SYNTH_FEC)&&(REF_CLK==0)&&(!SYNTH_1588) && (HARD_PRBS_ENABLE) && (!SYNTH_AN_LT))  begin : NATIVE_PHY_10GHP_322_LS
     native_10ghp_322_ls native_10ghp_322_ls_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((!SYNTH_FEC)&&(REF_CLK==0)&&(SYNTH_1588) && (HARD_PRBS_ENABLE) && (!SYNTH_AN_LT))  begin : NATIVE_PHY_10G_1588HP_322_LS
     native_10g_1588hp_322_ls native_10g_1588hp_322_ls_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((!SYNTH_FEC)&&(REF_CLK==2)&&(SYNTH_1588) && (HARD_PRBS_ENABLE) && (!SYNTH_AN_LT))  begin : NATIVE_PHY_10G_1588HP_312_LS
     native_10g_1588hp_312_ls native_10g_1588hp_312_ls_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((!SYNTH_FEC)&&(REF_CLK==1)&&(!SYNTH_1588) && (HARD_PRBS_ENABLE) && (!SYNTH_AN_LT))  begin : NATIVE_PHY_10GHP_644_LS
     native_10ghp_644_ls  native_10ghp_644_ls_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((!SYNTH_FEC)&&(REF_CLK==1)&&(SYNTH_1588) && (HARD_PRBS_ENABLE) && (!SYNTH_AN_LT))  begin : NATIVE_PHY_10G_1588HP_644_LS
     native_10g_1588hp_644_ls native_10g_1588hp_644_ls_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((SYNTH_FEC)&&(REF_CLK==0)&&(!SYNTH_1588) && (HARD_PRBS_ENABLE) && (!SYNTH_AN_LT))  begin : NATIVE_PHY_10G_FECHP_322_LS
     native_10g_fechp_322_ls  native_10g_fechp_322_ls_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((SYNTH_FEC)&&(REF_CLK==0)&&(SYNTH_1588) && (HARD_PRBS_ENABLE) && (!SYNTH_AN_LT))  begin : NATIVE_PHY_10G_1588HP_FEC_LS
     native_10g_fec_1588hp_322_ls native_10g_fec_1588hp_322_ls_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((SYNTH_FEC)&&(REF_CLK==1)&&(!SYNTH_1588) && (HARD_PRBS_ENABLE) && (!SYNTH_AN_LT))  begin : NATIVE_PHY_10G_FECHP_644_LS
     native_10g_fechp_644_ls native_10g_fechp_644_ls_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((SYNTH_FEC)&&(REF_CLK==1)&&(SYNTH_1588) && (HARD_PRBS_ENABLE) && (!SYNTH_AN_LT))  begin : NATIVE_PHY_10G_1588_644HP_FEC_LS
     native_10g_fec_1588hp_644_ls native_10g_fec_1588hp_644_ls_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((!SYNTH_FEC)&&(REF_CLK==0)&&(!SYNTH_1588) && (!HARD_PRBS_ENABLE) && (SYNTH_AN_LT))  begin : NATIVE_PHY_10G_322
     native_10g_322 native_10g_322_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((!SYNTH_FEC)&&(REF_CLK==0)&&(SYNTH_1588) && (!HARD_PRBS_ENABLE) && (SYNTH_AN_LT))  begin : NATIVE_PHY_10G_1588_322
     native_10g_1588_322 native_10g_1588_322_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((!SYNTH_FEC)&&(REF_CLK==2)&&(SYNTH_1588) && (!HARD_PRBS_ENABLE) && (SYNTH_AN_LT))  begin : NATIVE_PHY_10G_1588_312
     native_10g_1588_312 native_10g_1588_312_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((!SYNTH_FEC)&&(REF_CLK==1)&&(!SYNTH_1588) && (!HARD_PRBS_ENABLE) && (SYNTH_AN_LT))  begin : NATIVE_PHY_10G_644
     native_10g_644  native_10g_644_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((!SYNTH_FEC)&&(REF_CLK==1)&&(SYNTH_1588) && (!HARD_PRBS_ENABLE) && (SYNTH_AN_LT))  begin : NATIVE_PHY_10G_1588_644
     native_10g_1588_644 native_10g_1588_644_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((SYNTH_FEC)&&(REF_CLK==0)&&(!SYNTH_1588) && (!HARD_PRBS_ENABLE) && (SYNTH_AN_LT))  begin : NATIVE_PHY_10G_FEC_322
     native_10g_fec_322  native_10g_fec_322_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((SYNTH_FEC)&&(REF_CLK==0)&&(SYNTH_1588) && (!HARD_PRBS_ENABLE) && (SYNTH_AN_LT))  begin : NATIVE_PHY_10G_1588_FEC
     native_10g_fec_1588_322 native_10g_fec_1588_322_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((SYNTH_FEC)&&(REF_CLK==1)&&(!SYNTH_1588) && (!HARD_PRBS_ENABLE) && (SYNTH_AN_LT))  begin : NATIVE_PHY_10G_FEC_644
     native_10g_fec_644 native_10g_fec_644_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((SYNTH_FEC)&&(REF_CLK==1)&&(SYNTH_1588) && (!HARD_PRBS_ENABLE) && (SYNTH_AN_LT))  begin : NATIVE_PHY_10G_1588_644_FEC
     native_10g_fec_1588_644 native_10g_fec_1588_644_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((!SYNTH_FEC)&&(REF_CLK==0)&&(!SYNTH_1588) && (HARD_PRBS_ENABLE) && (SYNTH_AN_LT))  begin : NATIVE_PHY_10GHP_322
     native_10ghp_322 native_10ghp_322_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((!SYNTH_FEC)&&(REF_CLK==0)&&(SYNTH_1588) && (HARD_PRBS_ENABLE) && (SYNTH_AN_LT))  begin : NATIVE_PHY_10G_1588HP_322
     native_10g_1588hp_322 native_10g_1588hp_322_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((!SYNTH_FEC)&&(REF_CLK==2)&&(SYNTH_1588) && (HARD_PRBS_ENABLE) && (SYNTH_AN_LT))  begin : NATIVE_PHY_10G_1588HP_312
     native_10g_1588hp_312 native_10g_1588hp_312_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((!SYNTH_FEC)&&(REF_CLK==1)&&(!SYNTH_1588) && (HARD_PRBS_ENABLE) && (SYNTH_AN_LT))  begin : NATIVE_PHY_10GHP_644
     native_10ghp_644  native_10ghp_644_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((!SYNTH_FEC)&&(REF_CLK==1)&&(SYNTH_1588) && (HARD_PRBS_ENABLE) && (SYNTH_AN_LT))  begin : NATIVE_PHY_10G_1588HP_644
     native_10g_1588hp_644 native_10g_1588hp_644_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((SYNTH_FEC)&&(REF_CLK==0)&&(!SYNTH_1588) && (HARD_PRBS_ENABLE) && (SYNTH_AN_LT))  begin : NATIVE_PHY_10G_FECHP_322
     native_10g_fechp_322  native_10g_fechp_322_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((SYNTH_FEC)&&(REF_CLK==0)&&(SYNTH_1588) && (HARD_PRBS_ENABLE) && (SYNTH_AN_LT))  begin : NATIVE_PHY_10G_1588HP_FEC
     native_10g_fec_1588hp_322 native_10g_fec_1588hp_322_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((SYNTH_FEC)&&(REF_CLK==1)&&(!SYNTH_1588) && (HARD_PRBS_ENABLE) && (SYNTH_AN_LT))  begin : NATIVE_PHY_10G_FECHP_644
     native_10g_fechp_644 native_10g_fechp_644_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((SYNTH_FEC)&&(REF_CLK==1)&&(SYNTH_1588) && (HARD_PRBS_ENABLE) && (SYNTH_AN_LT))  begin : NATIVE_PHY_10G_1588_644HP_FEC
     native_10g_fec_1588hp_644 native_10g_fec_1588hp_644_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     
 end
 else begin : DATAPATH_1G
     if (SYNTH_1588) begin : NATIVE_PHY_1G_1588
     native_gige_1588 native_gige_1588_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else begin : NATIVE_PHY_1G
     native_gige native_gige_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
 end
endgenerate

  // sync signals from HSSI
    alt_xcvr_resync #(
      .WIDTH  (6)       // Number of bits to resync
    ) hssi_out_sync (
      .clk    (mgmt_clk),
      .reset  (mgmt_clk_reset),
      .d      ({rx_analogreset_ack_hssi,tx_analogreset_ack_hssi,rx_cal_busy_hssi, 
                tx_cal_busy_hssi, rx_is_lockedtodata_hssi, rx_is_lockedtoref_hssi}),
      .q      ({rx_analogreset_ack     ,tx_analogreset_ack     ,rx_cal_busy     , 
                tx_cal_busy     , rx_is_lockedtodata, rx_is_lockedtoref     })
    );


//****************************************************************************
// Instantiate 10G-KR FEC -- only when SYNTH_FEC==1
//****************************************************************************
generate
  if (SYNTH_FEC) begin : FEC_CSR
    wire        fec_tx_trans_err;
    wire        fec_tx_burst_err;
    wire [3:0]  fec_tx_burst_err_len;
    wire        fec_tx_enc_query;
    wire        fec_rx_signok_en;
    wire        fec_rx_fast_search_en;
    wire        fec_rx_blksync_cor_en;
    wire        fec_rx_dv_start;
    wire        clear_counters;
    wire        clr_corr_blks;
    wire        clr_uncr_blks;
    wire [9:0]  write_en;
    wire        tx_data_valid_in;
    wire        fec_tx_err_ins;
    wire        fec_tx_err_ins_sync;
    reg         fec_tx_err_ins_sync1;

    //********************** FEC CSR 0xB2-0xBF
    csr_krfec  csr_krfec_inst (
        // avalon-MM
      .clk                   (mgmt_clk              ),
      .reset                 (mgmt_clk_reset        ),
      .address               (mgmt_address[7:0]     ),
      .read                  (mgmt_read             ),
      .readdata              (fec_mgmt_readdata     ),
      .write                 (mgmt_write & addr_soft_csr),
      .writedata             (mgmt_writedata        ),
        // FEC status sync
      .write_en              (write_en),
      .write_en_ack          (10'b0),
        // FEC input/outputs
      .fec_tx_trans_err      (fec_tx_trans_err      ),
      .fec_tx_burst_err      (fec_tx_burst_err      ),
      .fec_tx_burst_err_len  (fec_tx_burst_err_len  ),
      .fec_tx_enc_query      (fec_tx_enc_query      ),
      .fec_tx_err_ins        (fec_tx_err_ins        ),
      .fec_rx_signok_en      (fec_rx_signok_en      ),
      .fec_rx_fast_search_en (fec_rx_fast_search_en ),
      .fec_rx_blksync_cor_en (fec_rx_blksync_cor_en ),
      .fec_rx_dv_start       (fec_rx_dv_start       ),
      .fec_corr_blks         (32'b0         ),
      .fec_uncr_blks         (32'b0         ),
        // read/write control outputs
      .clear_counters        (clear_counters        ),
      .clr_corr_blks         (clr_corr_blks         ),
      .clr_uncr_blks         (clr_uncr_blks         )
      );
   
    //***********FEC TX Error insert CSR logic
    alt_xcvr_resync #(
      .SYNC_CHAIN_LENGTH(2),  // Number of flip-flops for retiming
      .WIDTH            (1),  // Number of bits to resync
      .INIT_VALUE       (0)
    ) tx_err_ins_sync (
      .clk    (tx_coreclkin),
      .reset  (csr_reset_all),
      .d      (fec_tx_err_ins),
      .q      (fec_tx_err_ins_sync)
      );
    
    // create pulse  
    // In 1588 mode need to check data_valid before de-asserting pulse
    if (SYNTH_1588) assign tx_data_valid_in = tx_10g_data_valid;
    else            assign tx_data_valid_in = 1'b1;
   
    always @ (posedge tx_coreclkin or posedge csr_reset_all) begin
      if (csr_reset_all) begin 
        fec_tx_err_ins_sync1 <= 1'b0;
        fec_tx_err_ins_pulse <= 1'b0;
      end else begin
        fec_tx_err_ins_sync1 <= fec_tx_err_ins_sync ;
        if (fec_tx_err_ins_sync & ~fec_tx_err_ins_sync1 )
          fec_tx_err_ins_pulse <= 1'b1;
        else if (tx_data_valid_in)
          fec_tx_err_ins_pulse <= 1'b0;
        end
      end
    end // synth_fec
  else begin: NO_FEC_CSR  // need to drive outputs if no FEC_CSR module
    assign fec_tx_err_ins_pulse = 1'b0;
    assign fec_mgmt_readdata    = 32'b0;
  end  // else synth_fec
endgenerate


//****************************************************************************
// DATA ADAPTER FOR 1G
// also Registers and the GIGE PCS module
//****************************************************************************
  wire  [31:0] gige_pma_readdata;      // read data from the Gige PMA CSR
  wire  [15:0] gige_pcs_readdata;      // read data from the Gige PCS CSR

generate
 if (SYNTH_GIGE) begin : GIGE_ENABLE
 wire [8:0 ] tx_parallel_data_DA;
 wire rx_runningdisp;
 wire rx_datak;
 wire rx_disperr;
 wire rx_patterndetect;
 wire rx_rmfifodatainserted;
 wire rx_rmfifodatadeleted;
 wire tx_datak;
 wire rx_errdetect;
  // Internal wires for 1G status outputs which are masked
  wire  rx_syncstatus_int;
  wire [63:9] con_war;

   sv_xcvr_data_adapter #(
    .lanes             (1           ),  //Number of lanes chosen by user. legal value: 1+
    .channel_interface (0), //legal value: (0,1) 1-Enable channel reconfiguration
    .ser_base_factor   (8               ),  // (8,10)
    .ser_words         (1               ),  // (1,2,4)
    .skip_word         (1               )   // (1,2)
  ) sv_xcvr_data_adapter_inst(
    .tx_parallel_data     (tx_parallel_data_1g   ),
    .tx_datak             (tx_datak             ),
    .tx_forcedisp         (         ),
    .tx_dispval           (           ),
    .tx_datain_from_pld   ({con_war,tx_parallel_data_DA}),
    // outputs
    .rx_dataout_to_pld    (rx_parallel_data_native),
    .rx_parallel_data     (rx_parallel_data_1g  ),
    .rx_datak             (rx_datak             ),
    .rx_errdetect         (rx_errdetect         ),
    .rx_syncstatus        (rx_syncstatus_int    ),
    .rx_disperr           (rx_disperr           ),
    .rx_patterndetect     (rx_patterndetect     ),
    .rx_rmfifodatainserted(rx_rmfifodatainserted),
    .rx_rmfifodatadeleted (rx_rmfifodatadeleted ),
    .rx_runningdisp       (rx_runningdisp       ),
    .rx_a1a2sizeout       (       )
  );


  csr_krgige  csr_krgige_inst (
    .clk        (mgmt_clk          ),
    .reset      (mgmt_clk_reset    ),
    .address    (mgmt_address[7:0] ),
    .read       (mgmt_read         ),
    .readdata   (gige_pma_readdata),
    .write      (mgmt_write & addr_soft_csr),
    .writedata  (mgmt_writedata    ),
    //status inputs to this CSR
    .rx_sync_status     (rx_syncstatus_int),
    .rx_pattern_det     (rx_patterndetect),
    .rx_rlv             (1'b0  ),
    .rx_rmfifo_inserted (rx_rmfifodatainserted),
    .rx_rmfifo_deleted  (rx_rmfifodatadeleted),
    .rx_disperr         (rx_disperr),
    .rx_errdetect       (rx_errdetect),
    // read/write control outputs
    .tx_invpolarity  (tx_std_polinv),
    .rx_invpolarity  (rx_std_polinv),
    .rx_bitreversal  (rx_std_bitrev_ena),
    .rx_bytereversal (),
    .force_elec_idle (tx_std_elecidle)
  );

  assign tx_pcfifo_error_1g =  tx_std_pcfifo_full | tx_std_pcfifo_empty ;
  assign rx_pcfifo_error_1g =  rx_std_pcfifo_full | rx_std_pcfifo_empty ;
  // mux or combine if have Gige mode
  assign tx_parallel_data_native[63:9] = tx_parallel_data_1588[63:9];
  assign tx_parallel_data_native[8:0]  = pcs_mode_rc[3] ? tx_parallel_data_DA:
                                                          tx_parallel_data_1588[8:0];

  // mask the 1G status for only when in 1G mode
  assign rx_syncstatus = rx_syncstatus_int & pcs_mode_rc[3] & ~seq_start_rc & ~rc_busy;

//// instantiate GMII = GIGE PCS and related/internal CSRs here
   if (SYNTH_GMII) begin : GMII_PCS_ENABLED

       wire gige_pcs_write;
       wire set_10,set_100,set_1000;
       // Internal wires for 1G status outputs which are masked
       wire  led_an_int;
       wire  led_link_int;
       wire  led_panel_link_int;
       wire  led_char_err_int;
       wire  led_disp_err_int;

    // only enable gige_pcs for address in range = 0x90 to 0xA7
       assign gige_pcs_write = (mgmt_address >= 11'h490) &&
                               (mgmt_address <= 11'h4A7) & mgmt_write;
       assign gige_pcs_read =  (mgmt_address >= 11'h490) &&
                               (mgmt_address <= 11'h4A7) & mgmt_read;

      kr_gige_pcs_top # (
         .PHY_IDENTIFIER   (PHY_IDENTIFIER),  // PHY Identifier
         .DEV_VERSION      (DEV_VERSION   ),  // Customer Phy's Core Version
         .ENABLE_SGMII     (SYNTH_SGMII  ),   // Enable SGMII logic synthesis
         .SYNTH_CL37ANEG   (SYNTH_CL37ANEG),  // Enable GIGE AN (Clause 37)
         .ENABLE_PHASE_CALC(SYNTH_1588_1G),   // Enable 1588 Phase Calculation
         .TX_PCS_LATENCY   (TX_PCS_OFFSET_1G),// TX PCS latency for 1588
         .RX_PCS_LATENCY   (RX_PCS_OFFSET_1G) // RX PCS latency for 1588
          )  kr_gige_pcs_top (
         .tx_pcs_clk            (tx_clkout),   // TX clock from PHYIP
         .rx_pcs_clk            (rx_clkout),   // RX clock from PHYIP
         .reset_reg_clk         (mgmt_clk_reset),
         .reset_tx_clk          (tx_digitalreset_fnl),
         .reset_rx_clk          (rx_digitalreset_fnl),
         .tx_clk                (),       // TX clock to MAC--open as only for SMGII
         .rx_clk                (),       // RX clock to MAC--open as only for SMGII
         .tx_clkena             (mii_tx_clkena),
         .tx_clkena_half_rate   (mii_tx_clkena_half_rate),
         .rx_clkena             (mii_rx_clkena),
         .rx_clkena_half_rate   (mii_rx_clkena_half_rate),
         .led_an                (led_an_int            ),
         .led_char_err          (led_char_err_int      ),
         .led_col               (                      ),  // NA for this mode
         .led_crs               (                      ),
         .led_disp_err          (led_disp_err_int      ),
         .led_link              (led_link_int          ),
         .led_panel_link        (led_panel_link_int    ),
         .set_10                (set_10  ),
         .set_100               (set_100 ),
         .set_1000              (set_1000),
         .hd_ena                (), /// open
         .gmii_rx_d             (gmii_rx_d             ),
         .gmii_rx_dv            (gmii_rx_dv            ),
         .gmii_rx_err           (gmii_rx_err           ),
         .gmii_tx_d             (gmii_tx_d             ),
         .gmii_tx_en            (gmii_tx_en            ),
         .gmii_tx_err           (gmii_tx_err           ),
         .mii_tx_d              (mii_tx_d  ),
         .mii_tx_en             (mii_tx_en ),
         .mii_tx_err            (mii_tx_err),
         .mii_rx_d              (mii_rx_d  ),
         .mii_rx_dv             (mii_rx_dv ),
         .mii_rx_err            (mii_rx_err),
         .mii_col               (),  //MII SIGNALS OPEN
         .mii_crs               (),  //MII SIGNALS OPEN
         .reg_clk               (mgmt_clk        ),
         .calc_clk              (calc_clk_1g),
         .reg_address           ({~mgmt_address[4],mgmt_address[3:0]} ),  // this is equivalent of mgmt_address-8'h90 .. as long as we are looking at 5 LSBs of mgmt_address
         .reg_read              (gige_pcs_read       ),
         .reg_readdata          (gige_pcs_readdata),
         .reg_waitrequest       (gige_pcs_waitreq),
         .reg_write             (gige_pcs_write),
         .reg_writedata         (mgmt_writedata[15:0]),
         .tx_frame              (tx_parallel_data_1g   ),
         .tx_kchar              (tx_datak            ),
         .rx_frame              (rx_parallel_data_1g   ),
         .rx_kchar              (rx_datak            ),
         .rx_syncstatus         (rx_syncstatus_int),
         .rx_disp_err           (rx_disperr),
         .rx_char_err           (rx_errdetect),
         .rx_runlengthviolation (1'b0  ),
         .rx_patterndetect      (rx_patterndetect),
         .rx_runningdisp        (rx_runningdisp),
         .rx_rmfifodatadeleted  (rx_rmfifodatadeleted),
         .rx_rmfifodatainserted (rx_rmfifodatainserted),
         .rx_latency_adj        (rx_latency_adj_1g),
         .tx_latency_adj        (tx_latency_adj_1g),
         .wa_boundary           (rx_std_bitslipboundarysel)
      );

       // mask the 1G status for only when in 1G mode
       assign led_an        = led_an_int        & pcs_mode_rc[3] & ~seq_start_rc & ~rc_busy;
       assign led_link      = led_link_int      & pcs_mode_rc[3] & ~seq_start_rc & ~rc_busy;
       assign led_panel_link = led_panel_link_int & pcs_mode_rc[3] & ~seq_start_rc & ~rc_busy;
       assign led_char_err  = led_char_err_int  & pcs_mode_rc[3] & ~seq_start_rc & ~rc_busy;
       assign led_disp_err  = led_disp_err_int  & pcs_mode_rc[3] & ~seq_start_rc & ~rc_busy;
 
        always @ (pcs_mode_rc[3] or set_10 or set_100 or set_1000) begin
         case({pcs_mode_rc[3],set_10,set_100,set_1000})
           4'b1100 : mii_speed_sel = 2'b11;
           4'b1010 : mii_speed_sel = 2'b10;
           4'b1001 : mii_speed_sel = 2'b01;
           default : mii_speed_sel = 2'b00;
         endcase
        end
    end  // SYNTH GMII
      else begin  :  GMII_PCS_DISABLED
      assign gmii_rx_err = 0 ;
      assign gmii_rx_dv  = rx_datak ;
      assign gmii_rx_d = rx_parallel_data_1g ;
      assign tx_parallel_data_1g = gmii_tx_d ;
      assign tx_datak  = gmii_tx_en ;
      assign gige_pcs_readdata = 16'd0;
      assign led_an = 1'b0;
      assign led_char_err = 1'b0;
      assign led_disp_err = 1'b0;
      assign led_link = 1'b0;
      assign led_panel_link = 1'b0;
      assign gige_pcs_waitreq= 1'b0;
      assign gige_pcs_read = 1'b0 ;
      assign rx_latency_adj_1g = 22'b0;
      assign tx_latency_adj_1g = 22'b0;
      assign mii_tx_clkena = 1'b0;
      assign mii_rx_clkena = 1'b0;
      assign mii_rx_d      = 4'b0;
      assign mii_rx_dv     = 1'b0;
      assign mii_rx_err    = 1'b0;
      assign mii_speed_sel = 2'b0;
      end

  end  // SYNTH GIGE
    else begin : GIGE_DISABLED
    assign tx_parallel_data_native = tx_parallel_data_1588;
    assign tx_pcfifo_error_1g =  1'b0 ;
    assign rx_pcfifo_error_1g =  1'b0 ;
    assign gige_pcs_readdata = 16'd0;
    assign gige_pma_readdata = 32'd0;
    assign rx_syncstatus = 1'b0;
    assign gige_pcs_waitreq= 1'b0;
    assign gige_pcs_read = 1'b0 ;
    assign gmii_rx_d = 8'b0 ;
    assign gmii_rx_dv = 1'b0 ;
    assign gmii_rx_err = 1'b0 ;
    assign led_an = 1'b0;
    assign led_char_err = 1'b0;
    assign led_disp_err = 1'b0;
    assign led_link = 1'b0;
    assign led_panel_link = 1'b0;
    assign rx_latency_adj_1g = 22'b0;
    assign tx_latency_adj_1g = 22'b0;
    end
endgenerate


//****************************************************************************
// DATA ADAPTER FOR 10G
//****************************************************************************
generate
  genvar i;
  for (i=0; i<`TOTAL_XGMII_LANE; i=i+1)
  begin: bus_assign
    //tx input
    assign tx_parallel_data_10g[`TOTAL_DATA_PER_LANE*i+:`TOTAL_DATA_PER_LANE]      = xgmii_tx_dc[`TOTAL_SIGNAL_PER_LANE*i+:`TOTAL_DATA_PER_LANE];
    assign tx_10g_control[i]                                                = xgmii_tx_dc[(`TOTAL_SIGNAL_PER_LANE*i+`TOTAL_DATA_PER_LANE)+:`TOTAL_CONTROL_PER_LANE];
    //rx output
    assign xgmii_rx_dc[`TOTAL_SIGNAL_PER_LANE*i+:`TOTAL_SIGNAL_PER_LANE]= {rx_10g_control[i], rx_parallel_data_1588[`TOTAL_DATA_PER_LANE*i+:`TOTAL_DATA_PER_LANE]};
  end
  endgenerate


//****************************************************************************
// IEEE-1588 logic for the 10G data mode
//****************************************************************************
  localparam FAWIDTH  = 5;
  localparam TSWIDTH  = 16;

generate
  localparam GEN_TX_FIFO  = 1;
  localparam GEN_RX_FIFO  = 1;
  if (SYNTH_1588_10G) begin : soft10Gfifos

    // the 10G 1588 clock is from the div_clkout for FEC mode
    wire tx_10g_1588_clk, rx_10g_1588_clk;
    if (SYNTH_FEC) begin
      assign tx_10g_1588_clk = tx_pma_div_clkout;
      assign rx_10g_1588_clk = rx_pma_div_clkout;
    end else begin
      assign tx_10g_1588_clk = tx_clkout;
      assign rx_10g_1588_clk = rx_clkout;
    end

     // Adding the following register because their seems to be a inversion on 3 of every 8 bits of this bus.
     // This inversion is due to the default XGMII word being the reset state of the FIFO.
     // The inversion makes it difficult to meet timing on this bus, because it induces 600ps of difference
     // on the bits.

    // seperate TX, RX instances to match SDC hierarchy in 10G     
    // tx fifos below
    if (GEN_TX_FIFO) begin : softtxfifos 
     reg               tx_rd_rstn,tx_rd_rstn_m1;
     reg               tx_wr_rstn,tx_wr_rstn_m1;

         // Synchronize the reset of the FIFO
     always @(posedge tx_10g_1588_clk or posedge tx_digitalreset_fnl) begin
       if (tx_digitalreset_fnl == 1) begin
        tx_rd_rstn <= 0;
        tx_rd_rstn_m1 <= 0;
       end else begin
        tx_rd_rstn <= tx_rd_rstn_m1;
        tx_rd_rstn_m1 <= 1;
       end
     end

     always @(posedge xgmii_tx_clk or posedge tx_digitalreset_fnl) begin
       if (tx_digitalreset_fnl == 1) begin
        tx_wr_rstn <= 0;
        tx_wr_rstn_m1 <= 0;
       end else begin
        tx_wr_rstn <= tx_wr_rstn_m1;
        tx_wr_rstn_m1 <= 1;
       end
     end

     wire [ 64-1:0 ]   tx_datain_l;
     wire [  8-1:0 ]   tx_control_l;
     wire              tx_data_valid_l;

     reg [ 64-1:0 ]    tx_datain_r;
     reg [  8-1:0 ]    tx_control_r;
     reg               tx_data_valid_r;

     assign tx_parallel_data_1588 = tx_datain_r;

     assign tx_10g_control_inter = tx_control_r;
     assign tx_10g_data_valid = pcs_mode_rc[2] ? tx_data_valid_r : 1'b1;

     always @(posedge tx_10g_1588_clk or negedge tx_rd_rstn) begin
       if (tx_rd_rstn == 0) begin
        tx_datain_r <= 64'b0;
        tx_control_r <= 8'b0;
        tx_data_valid_r <= 1'b0;
       end else begin
        tx_datain_r <= tx_datain_l;
        tx_control_r <= tx_control_l;
        tx_data_valid_r <= tx_data_valid_l;
       end
     end

     altera_10gbaser_phy_clockcomp
       #(
         .FDWIDTH            (72),   // FIFO Data input width
         .FAWIDTH            (5),
         .CC_TX              (1),                    // FIFO used in TX path 1, else 0
         .IDWIDTH            (40),            // RX Gearbox Input Data Width
         .ISWIDTH            (7),                    // RX Gearbox Selector width
         .ODWIDTH            (66),          // RX Gearbox Output Data Width
         .TSWIDTH            (TSWIDTH),
         .PCS_OFFSET         (TX_PCS_OFFSET_10G)
         )
     tx_clockcomp
       (
        // Outputs
        .data_out                   ({tx_control_l,tx_datain_l}),
        .data_out_valid             (tx_data_valid_l),
        .fifo_full                  (tx_10g_fifo_full),
        .latency_adj                (tx_latency_adj_10g),
        // Inputs
        .bypass_cc                  (1'b0),
        .wr_rstn                    (tx_wr_rstn),
        .wr_clk                     (xgmii_tx_clk),
        .data_in                    ({tx_10g_control,tx_parallel_data_10g[63:0]}),
        .data_in_valid              (1'b1),
        .rd_rstn                    (tx_rd_rstn),
        .rd_clk                     (tx_10g_1588_clk)
        );
    end

    // RX fifos below
    if (GEN_RX_FIFO) begin : softrxfifos 
     reg [71:0] fifo_datain;
     reg        fifo_dvalid;
     reg rx_wr_rstn, rx_wr_rstn_m1;
     reg rx_rd_rstn, rx_rd_rstn_m1;


     // Synchronize the reset of the FIFO

     always @(posedge rx_10g_1588_clk or posedge rx_digitalreset_fnl)
       if (rx_digitalreset_fnl == 1) begin
          rx_wr_rstn <= 1'b0;
          rx_wr_rstn_m1 <= 1'b0;
       end else begin
          rx_wr_rstn <= rx_wr_rstn_m1;
          rx_wr_rstn_m1 <= 1'b1;
       end

     always @(posedge xgmii_rx_clk or posedge rx_digitalreset_fnl)
     if (rx_digitalreset_fnl == 1) begin
         rx_rd_rstn <= 1'b0;
         rx_rd_rstn_m1 <= 1'b0;
     end else begin
         rx_rd_rstn <= rx_rd_rstn_m1;
         rx_rd_rstn_m1 <= 1'b1;
     end

      always @(posedge rx_10g_1588_clk or negedge rx_wr_rstn)
       if (rx_wr_rstn == 0) begin
          fifo_datain <= 72'b0;
          fifo_dvalid <= 1'b0;
       end else begin
          fifo_datain <= {rx_10g_control_inter[7:0],rx_parallel_data_native};
          fifo_dvalid <= rx_10g_data_valid;
       end

     altera_10gbaser_phy_rx_fifo_wrap
       #(
         .FDWIDTH            (72),   // FIFO Data input width
         .FAWIDTH            (FAWIDTH),                    // FIFO Depth (address width)
         .FSYNCSTAGE         (4),
         .CC_TX              (0),                    // FIFO used in TX path 1, else 0
         .IDWIDTH            (40),            // RX Gearbox Input Data Width
         .ISWIDTH            (7),                    // RX Gearbox Selector width
         .ODWIDTH            (66),          // RX Gearbox Output Data Width
         .TSWIDTH            (TSWIDTH),
         .PCS_OFFSET         (RX_PCS_OFFSET_10G)
         )
     rx_clockcomp
       (
        .bypass_cc       (1'b0),                 // Bypass clock compensation
        .wr_rstn         (rx_wr_rstn),      // Write Domain Active low Reset
        .wr_clk          (rx_10g_1588_clk),     // Write Domain Clock
        .data_in         (fifo_datain),
        .data_in_valid   (fifo_dvalid),
        .rd_rstn         (rx_rd_rstn),      // Read Domain Active low Reset
        .rd_clk          (xgmii_rx_clk),         // Read Domain Clock
        .data_out        ({rx_10g_control[7:0],rx_parallel_data_1588}),  // Read Data Out (Contains CTRL+DATA)
        .data_out_valid  (),    // Read Data Out Valid
        .fifo_full       (rx_10g_fifo_full),           // FIFO Became FULL, Error Condition
        .latency_adj     (rx_latency_adj_10g)
        );
       assign rx_data_ready = rx_10g_control_inter[`CTL_BFL];
       assign rx_10g_control[9:8] = 2'b00;
    end
    end else begin : hard10gfifos
       assign tx_parallel_data_1588 = tx_parallel_data_10g;
       assign tx_10g_control_inter = tx_10g_control;
       assign tx_10g_data_valid = 1'b1;
       assign tx_latency_adj_10g = 12'd0;
       assign tx_10g_fifo_full = tx_10g_fifo_full_inter;
       assign rx_data_ready = rx_10g_control[`CTL_BFL];
       assign rx_10g_control = rx_10g_control_inter;
       assign rx_parallel_data_1588 = rx_parallel_data_native;
       assign rx_latency_adj_10g = 16'd0;
       assign rx_10g_fifo_full = rx_10g_fifo_full_inter;
    end
  endgenerate


//****************************************************************************
// Instantiate the CSR modules and the memory map logic
// no syncronizer on reset input
//****************************************************************************
  wire  csr_reset_tx_digital;// to reset controller from csr
  wire  csr_reset_rx_digital;// to reset controller from csr
  wire  [31:0] pcs_mgmt_readdata;      // read data from the BaseR CSR
  wire  [31:0] common_mgmt_readdata;   // read data from the common CSR
  wire  [31:0] top_mgmt_readdata;      // read data from the SEQ/TOP CSR

  // Common PMA registers 0x00 - 0x7F
  alt_xcvr_csr_common #(
    .lanes  (1),
    .plls   (1)
    ) csr_com (
    .clk                              (mgmt_clk),
    .reset                            (mgmt_clk_reset),
    .address                          (mgmt_address[7:0]),
    .read                             (mgmt_read),
    .readdata                         (common_mgmt_readdata),
    .write                            (mgmt_write & addr_soft_csr),
    .writedata                        (mgmt_writedata),
    // Transceiver status inputs to CSR
    .pll_locked                       (1'b0      ), // since PLL no longer reside within KP
    .rx_is_lockedtoref                (rx_is_lockedtoref),
    .rx_is_lockedtodata               (rx_is_lockedtodata),
    .rx_signaldetect                  (1'b0),
    // from reset controller  - not used now that no reset controller inside
    .reset_controller_tx_ready        (1'b0),
    .reset_controller_rx_ready        (1'b0),
    .reset_controller_pll_powerdown   (1'b0),
    .reset_controller_tx_digitalreset (1'b0),
    .reset_controller_rx_analogreset  (1'b0),
    .reset_controller_rx_digitalreset (1'b0),
    // Read/write control registers
    .csr_reset_tx_digital             (csr_reset_tx_digital),
    .csr_reset_rx_digital             (csr_reset_rx_digital),
    .csr_reset_all                    (csr_reset_all),
    .csr_pll_powerdown                (),
    .csr_tx_digitalreset              (csr_tx_digitalreset),
    .csr_rx_analogreset               (csr_rx_analogreset),
    .csr_rx_digitalreset              (csr_rx_digitalreset),
    .csr_phy_loopback_serial          (csr_phy_loopback_serial),
    .csr_rx_set_locktoref             (csr_rx_set_locktoref),
    .csr_rx_set_locktodata            (csr_rx_set_locktodata)
  );

  // Legacy 10GbaseR registers 0x80 - 0x8F
  csr_pcs10gbaser #(
    .lanes              (1)
  ) csr_10gpcs (
    .clk                (mgmt_clk          ),
    .reset              (mgmt_clk_reset    ),
    .address            (mgmt_address[7:0] ),
    .read               (mgmt_read         ),
    .readdata           (pcs_mgmt_readdata ),
    .write              (mgmt_write & addr_soft_csr),
    .writedata          (mgmt_writedata    ),
    .rx_clk             (xgmii_rx_clk      ),  // to synchronize rx control outputs
    .tx_clk             (xgmii_tx_clk      ),  // to synchronize tx control outputs
    .rx_pma_clk         (mgmt_clk ),           // HSSI has sync, no need to use other clock
    //transceiver status inputs to this CSR
    .pcs_status         (1'b0),              // not used with hard 10Gbase-R PHY??
    .hi_ber             (rx_hi_ber         ),
    .block_lock         (rx_block_lock     ),
    .rx_data_ready      (rx_data_ready     ),
    .tx_fifo_full       (tx_10g_fifo_full  ),
    .rx_fifo_full       (rx_10g_fifo_full  ),
    .rx_sync_head_error (1'b0              ),
    .rx_scrambler_error (1'b0              ),
    .ber_cnt            (6'd0),              // not in hard 10G PHY. Use DPRIO to access.
    .errored_block_cnt  (8'd0),              // not in hard 10G PHY. Use DPRIO to access.
    // read/write control outputs
    // PCS controls
    .csr_rclr_errblk_cnt(clr_errblk_cnt    ), // hanging for now-
    .csr_rclr_ber_cnt   (clr_ber_cnt       )
  );


  // KR SEQ and top-level registers 0xB0 - 0xB1
  csr_kra10top  # (
    .SYNTH_FEC  (SYNTH_FEC),
    .AN_FEC     (AN_FEC   ),
    .ERR_INDICATION (ERR_INDICATION)
    )    csr_kra10top_inst (
    .clk        (mgmt_clk          ),
    .reset      (mgmt_clk_reset    ),
    .address    (mgmt_address[7:0] ),
    .read       (mgmt_read         ),
    .readdata   (top_mgmt_readdata ),
    .write      (mgmt_write  & addr_soft_csr),
    .writedata  (mgmt_writedata    ),
  //status inputs to this CSR
    .seq_link_rdy    (link_ready),
    .seq_an_timeout  (seq_an_timeout),
    .seq_lt_timeout  (seq_lt_timeout),
    .pcs_mode_rc     (pcs_mode_rc),
  // read/write control outputs
    .csr_reset_seq  (csr_seq_restart),
    .dis_an_timer   (dis_an_timer),
    .dis_lf_timer   (dis_lf_timer),
    .force_mode     (force_mode),
    .fec_enable     (fec_enable),
    .fec_request    (fec_request),
    .fec_err_ind    (fec_err_ind),
    .fail_lt_if_ber (fail_lt_if_ber),
    .en_rcfg_cal    (en_rcfg_cal),
    .lt_fail_response(lt_fail_response)
  );

  // mux the register output (read) data for the different register blocks
  //
  assign mgmt_readdata =                      addr_hard_reg  ? reconfig_readdata :
      (mgmt_address >= 11'h480) && (mgmt_address <= 11'h48F) ? pcs_mgmt_readdata :
      (mgmt_address >= 11'h490) && (mgmt_address <= 11'h4A7) ? {16'b0,gige_pcs_readdata}:
      (mgmt_address >= 11'h4A8) && (mgmt_address <= 11'h4AF) ? gige_pma_readdata :
      (mgmt_address >= 11'h4B0) && (mgmt_address <= 11'h4B1) ? top_mgmt_readdata :
      (mgmt_address >= 11'h4B2) && (mgmt_address <= 11'h4BF) ? fec_mgmt_readdata :
      (mgmt_address >= 11'h4C0) && (mgmt_address <= 11'h4CF) ? an_mgmt_readdata  :
      (mgmt_address >= 11'h4D0) && (mgmt_address <= 11'h4DF) ? lt_mgmt_readdata  :
      (mgmt_address >= 11'h400) && (mgmt_address <= 11'h47F) ? common_mgmt_readdata :
      32'h0 ;

  // generate waitrequest for soft registers
  altera_wait_generate wait_gen (
    .rst            (mgmt_clk_reset),
    .clk            (mgmt_clk),
    .launch_signal  (mgmt_read & ~gige_pcs_read & addr_soft_csr),
    .wait_req       (waitrequest)
  );
  // Do not OR reconfig_waitrequest - instead look at address before sending it out
  // If ADME is enabled; reconfig_waitrequest would be high by default   
  assign mgmt_waitrequest =
    (mgmt_address >= 11'h490) && (mgmt_address <= 11'h4A7) ? gige_pcs_waitreq :
    addr_hard_reg ? reconfig_waitrequest : waitrequest ;


endmodule  //ultra_chnl
