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

//****************************************************************************
// Top for A10 kr_10gphy IP
// Contains the Sequencer, reconfig, and channel modules.
//****************************************************************************

`timescale 1 ps / 1 ps

module altera_xcvr_10gkr_a10
  #(
  parameter DEVICE_FAMILY = "Stratix V",  // select native PHY device family
  parameter ES_DEVICE     = 1,            // select ES or PROD device, 1 is ES-DEVICE, 0 is device
  parameter REF_CLK_FREQ_10G = "322.265625",  // select native PHY device family
  parameter HARD_PRBS_ENABLE = 0,            // Synthesize Hard PRBS ge/chk logic in Native PHY
  parameter SYNTH_AN         = 1,            // Synthesize/include the AN logic
  parameter SYNTH_LT         = 1,            // Synthesize/include the LT logic
  parameter SYNTH_SEQ        = 1,            // Synthesize/include Sequencer logic
  parameter SYNTH_GIGE       = 0,            // Synthesize/include the GIGE logic
  parameter SYNTH_GMII       = 0,            // Synthesize/include the GMII PCS
  parameter SYNTH_FEC        = 0,            // Synthesize/include the FEC logic
  parameter XGMII_32BIT_MODE = 0,            // Synthesize/include the FEC logic
  parameter INI_DATAPATH     = "10G",        // intial/reset datapath
  parameter SYNTH_RCFG       = 1    ,        // intial/reset datapath
  parameter PHY_IDENTIFIER   = 32'h 00000000, // PHY Identifier
  parameter DEV_VERSION      = 16'h 0001 ,  //  Customer Phy's Core Version
  parameter SYNTH_SGMII      = 1,           // Enable SGMII logic for synthesis
  parameter SYNTH_CL37ANEG   = 0,           // Synth GIGE AN logic (Clause 37)
  parameter SYNTH_1588_1G    = 0,            // Synthesize/include 1588 1G logic
  parameter SYNTH_1588_10G   = 0,           // Synthesize/include 1588 10G logic
  // Sequencer parameters not used in the AN block
  parameter LFT_R_MSB        = 7'd78,       // Link Fail Timer MSB for BASE-R PCS
  parameter LFT_R_LSB        = 10'd750,     // Link Fail Timer lsb for BASE-R PCS
  parameter LFT_X_MSB        = 7'd7,        // Link Fail Timer MSB for BASE-X PCS
  parameter LFT_X_LSB        = 10'd0,       // Link Fail Timer lsb for BASE-X PCS
  parameter LTD_MSB          = 8'd100,       // Link Fail Timer lsb for BASE-X PCS
  // LT parameters
  parameter BERWIDTH         = 10,           // Width (4-12) of the Bit Error counter
  parameter TRNWTWIDTH       = 7,            // Width (7,8) of Training Wait counter
  parameter MAINTAPWIDTH     = 5,            // Width of the Main Tap control
  parameter POSTTAPWIDTH     = 6,            // Width of the Post Tap control
  parameter PRETAPWIDTH      = 5,            // Width of the Pre Tap control
  parameter VMAXRULE         = 5'd30,        // VOD+Post+Pre <= Device Vmax 1200mv
  parameter VMINRULE         = 5'd6,         // VOD-Post-Pre >= Device VMin 165mv
  parameter VODMINRULE       = 5'd14,        // VOD >= IEEE VOD Vmin of 440mV
  parameter VPOSTRULE        = 6'd25,        // Post_tap <= VPOST
  parameter VPRERULE         = 5'd16,        // Pre_tap <= VPRE
  parameter PREMAINVAL       = 5'd30,        // Preset Main tap value
  parameter PREPOSTVAL       = 6'd0,         // Preset Post tap value
  parameter PREPREVAL        = 5'd0,         // Preset Pre tap value
  parameter INITMAINVAL      = 5'd25,        // Initialize Main tap value
  parameter INITPOSTVAL      = 6'd22,        // Initialize Post tap value
  parameter INITPREVAL       = 5'd3,         // Initialize Pre tap value
  parameter USE_DEBUG_CPU    = 1,            // Use the Debug version of the CPU
  parameter USE_ECC_CPU      = 0,            // Use the ECC version of the CPU
  // AN parameters
  parameter AN_PAUSE         = 3'b000,       // Pause ability, depends upon MAC
  parameter AN_TECH          = 6'b00_0101,   // Tech ability, only 10G and GIGE valid
                                         // bit-0 = GigE, bit-1 = XAUI
                                         // bit-2 = 10G , bit-3 = 40G BP
                                         // bit 4 = 40G-CR4, bit 5 = 100G-CR10
//  parameter AN_FEC         = 2'b00,        // FEC, bit1=request, bit0=ability
  parameter AN_SELECTOR      = 5'b0_0001,    // AN selector field 802.3 = 5'd1
  parameter CAPABLE_FEC      = 0,    // FEC ability on power on
  parameter ENABLE_FEC       = 0,    // FEC request on power on
  parameter ERR_INDICATION   = 0,    // Turn error indication on/off
  parameter GOOD_PARITY      = 4,    // good parity threshold
  parameter INVALD_PARITY    = 8    // invalid parity threshold
  )(
     // clocks
  input  wire     tx_serial_clk_10g,   // high speed serial clock0
  input  wire     tx_serial_clk_1g,   // high speed serial clock1
  input  wire     rx_cdr_ref_clk_10g,   // cdr_ref_clk
  input  wire     rx_cdr_ref_clk_1g,    // cdr_ref_clk
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
  input   wire         usr_seq_reset,
     // Avalon I/F
  input  wire         mgmt_clk,         //
  input  wire         mgmt_clk_reset,   //
  input  wire [10:0]  mgmt_address,     //
  input  wire         mgmt_read,        //
  output wire [31:0]  mgmt_readdata,    //
  output wire         mgmt_waitrequest, //
  input  wire         mgmt_write,       //
  input  wire [31:0]  mgmt_writedata,   //
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
//  output wire                 rx_rlv,    // rlv removed from HSSI
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
  output wire         rx_is_lockedtodata,   // rx_is_lockedtodata.export
  output wire         rx_is_lockedtoref,   // rx_is_lockedtoref.export
  output wire         tx_cal_busy,
  output wire         rx_cal_busy,
  output wire         rx_data_ready,
  output wire         rx_block_lock,
  output wire         rx_hi_ber,
  output wire         tx_serial_data,       //     tx_serial_data.export
  input  wire         rx_serial_data,       //     rx_serial_data.export
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
  input wire             lcl_rf,         // local device Remote Fault = D13

     // for the reconfig Interface when no Sequencer
  output wire            rc_busy,       // reconfig is busy
  input  wire            mode_1g_10gbar,
  output wire [5:0]     pcs_mode_rc,    // PCS mode for reconfig - 1 hot
                                        // bit 0 = AN mode = low_lat, PLL LTR
                                        // bit 1 = LT mode = low_lat, PLL LTD
                                        // bit 2 = 10G data mode = 10GBASE-R
                                        // bit 3 = GigE data mode = 8G PCS
                                        // bit 4 = XAUI data mode = future?
                                        // bit 5 = 10G-FEC 
  input  wire            start_pcs_reconfig
  );

//****************************************************************************
// Define Parameters
//****************************************************************************
  // Apply embedded false path timing constraints
  // (* altera_attribute  = "-name SDC_STATEMENT \"set_false_path -from [get_registers {*|rx_lnk_cdwd[*]}] -to [get_registers {*an_arb_sm:ARB|*}]\"" *)
`ifdef ALTERA_RESERVED_QIS
  localparam  SYNC_AN_CONSTRAINT   = {"-name SDC_STATEMENT \"set_false_path -from [get_registers {*AUTO_NEG|an_rx_sm:RX_SM|rx_lnk_cdwd[*]}] -to [get_registers {*AUTO_NEG|an_arb_sm:ARB|*}]\""};
  localparam  SYNC_LTRX_CONSTRAINT = {"-name SDC_STATEMENT \"set_false_path -from [get_registers {*LINK_TRAIN|lt32_rx_data:RX_DATAPATH|lcl_coef*}] -to [get_registers {*LCL_COEF|*}]\""};
`endif

/*
  localparam SDC_GIGE_TO_10G = {"-name SDC_STATEMENT \"set_false_path -from [get_registers {*kr_gige_pcs_top:GIGE_ENABLE.GMII_PCS_ENABLED.kr_gige_pcs_top*}] -to  [get_registers {*SV_NATIVE.altera_xcvr_native_sv_inst|sv_xcvr_native:gen_native_inst.xcvr_native_insts[0].gen_bonded_group_native.xcvr_native_inst|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[0].inst_sv_pcs_ch|sv_hssi_10g_tx_pcs_rbc:inst_sv_hssi_10g_tx_pcs*}]\""};
  localparam SDC_10G_TO_GIGE = {"-name SDC_STATEMENT \"set_false_path -from  [get_registers {*SV_NATIVE.altera_xcvr_native_sv_inst|sv_xcvr_native:gen_native_inst.xcvr_native_insts[0].gen_bonded_group_native.xcvr_native_inst|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[0].inst_sv_pcs_ch|sv_hssi_10g_rx_pcs_rbc:inst_sv_hssi_10g_rx_pcs*}] -to  [get_registers {*kr_gige_pcs_top:GIGE_ENABLE.GMII_PCS_ENABLED.kr_gige_pcs_top*}]\""};
  localparam SDC_8G_TO_AN    = {"-name SDC_STATEMENT \"set_false_path -from  [get_registers {*SV_NATIVE.altera_xcvr_native_sv_inst|sv_xcvr_native:gen_native_inst.xcvr_native_insts[0].gen_bonded_group_native.xcvr_native_inst|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[0].inst_sv_pcs_ch|sv_hssi_8g_rx_pcs_rbc:inst_sv_hssi_8g_rx_pcs*}] -to  [get_registers -nowarn {*AN_GEN.an_top*}]\""};
  localparam SDC_8G_TO_LT    = {"-name SDC_STATEMENT \"set_false_path -from  [get_registers {*SV_NATIVE.altera_xcvr_native_sv_inst|sv_xcvr_native:gen_native_inst.xcvr_native_insts[0].gen_bonded_group_native.xcvr_native_inst|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[0].inst_sv_pcs_ch|sv_hssi_8g_rx_pcs_rbc:inst_sv_hssi_8g_rx_pcs*}] -to  [get_registers -nowarn {*LT_GEN.lt_top*}]\""};
  localparam SDC_AN_TO_8G    = {"-name SDC_STATEMENT \"set_false_path -from  [get_registers -nowarn {*AN_GEN.an_top*}] -to  [get_registers {*SV_NATIVE.altera_xcvr_native_sv_inst|sv_xcvr_native:gen_native_inst.xcvr_native_insts[0].gen_bonded_group_native.xcvr_native_inst|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[0].inst_sv_pcs_ch|sv_hssi_8g_rx_pcs_rbc:inst_sv_hssi_8g_rx_pcs*}]\""};
  localparam SDC_LT_TO_8G    = {"-name SDC_STATEMENT \"set_false_path -from  [get_registers -nowarn {*LT_GEN.lt_top*}] -to  [get_registers {*SV_NATIVE.altera_xcvr_native_sv_inst|sv_xcvr_native:gen_native_inst.xcvr_native_insts[0].gen_bonded_group_native.xcvr_native_inst|sv_pcs:inst_sv_pcs|sv_pcs_ch:ch[0].inst_sv_pcs_ch|sv_hssi_8g_rx_pcs_rbc:inst_sv_hssi_8g_rx_pcs*}]\""};
  localparam SDC_GIGE_PCS    = {SDC_GIGE_TO_10G,";",SDC_10G_TO_GIGE,";",SDC_8G_TO_AN,";",SDC_8G_TO_LT,";",SDC_AN_TO_8G,";",SDC_LT_TO_8G};
*/

`ifdef ALTERA_RESERVED_QIS
  localparam  SOFTFIFO_TX_WR_RSTN_CONSTRAINT    = {"-name SDC_STATEMENT \"set regs [get_registers -nowarn *soft10Gfifos.tx_wr_rstn*]; if {[llength [query_collection -report -all $regs]] > 0} {set_false_path -to $regs}\""};
  localparam  SOFTFIFO_TX_RD_RSTN_CONSTRAINT    = {"-name SDC_STATEMENT \"set regs [get_registers -nowarn *soft10Gfifos.tx_rd_rstn*]; if {[llength [query_collection -report -all $regs]] > 0} {set_false_path -to $regs}\""};
  localparam  SOFTFIFO_RX_WR_RSTN_CONSTRAINT    = {"-name SDC_STATEMENT \"set regs [get_registers -nowarn *soft10Gfifos.rx_wr_rstn*]; if {[llength [query_collection -report -all $regs]] > 0} {set_false_path -to $regs}\""};
  localparam  SOFTFIFO_RX_RD_RSTN_CONSTRAINT    = {"-name SDC_STATEMENT \"set regs [get_registers -nowarn *soft10Gfifos.rx_rd_rstn*]; if {[llength [query_collection -report -all $regs]] > 0} {set_false_path -to $regs}\""};
  localparam  DCFIFO_TX_WR_RSTN_CONSTRAINT    = {"-name SDC_STATEMENT \"set from_regs [get_registers -nowarn *soft10Gfifos.tx_wr_rstn*]; set to_regs [get_registers -nowarn *soft10Gfifos*dcfifo_componenet*]; if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}\""};
  localparam  DCFIFO_TX_RD_RSTN_CONSTRAINT    = {"-name SDC_STATEMENT \"set from_regs [get_registers -nowarn *soft10Gfifos.tx_rd_rstn*]; set to_regs [get_registers -nowarn *soft10Gfifos*dffpipe*wraclr*];    if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}\""};
  localparam  DCFIFO_RX_WR_RSTN_CONSTRAINT    = {"-name SDC_STATEMENT \"set from_regs [get_registers -nowarn *soft10Gfifos.rx_wr_rstn*]; set to_regs [get_registers -nowarn *soft10Gfifos*dcfifo_componenet*]; if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}\""};
  localparam  DCFIFO_RX_RD_RSTN_CONSTRAINT    = {"-name SDC_STATEMENT \"set from_regs [get_registers -nowarn *soft10Gfifos.rx_rd_rstn*]; set to_regs [get_registers -nowarn *soft10Gfifos*dffpipe*wraclr*];    if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}\""};
  localparam  SDC_1588_CONSTRAINTS = {SOFTFIFO_TX_WR_RSTN_CONSTRAINT,";",SOFTFIFO_TX_RD_RSTN_CONSTRAINT,";",DCFIFO_TX_WR_RSTN_CONSTRAINT,";",DCFIFO_TX_RD_RSTN_CONSTRAINT,";",SOFTFIFO_RX_WR_RSTN_CONSTRAINT,";",SOFTFIFO_RX_RD_RSTN_CONSTRAINT,";",DCFIFO_RX_WR_RSTN_CONSTRAINT,";",DCFIFO_RX_RD_RSTN_CONSTRAINT};
`endif

  // Combine parameters for easier reading
  localparam  SYNTH_1588  = SYNTH_1588_1G && SYNTH_1588_10G ;
  localparam  SYNTH_AN_LT = SYNTH_AN || SYNTH_LT ;
  // param REF_CLK --> 0 -> 322 MHz, 1->644 MHz, 2 ->312 MHz
  localparam  REF_CLK      = (REF_CLK_FREQ_10G == "322.265625") ? 0 : (REF_CLK_FREQ_10G == "312.50000") ? 2 : 1 ;

//****************************************************************************
// Define Wires and Variables
//****************************************************************************
  // for SEQ
  wire         seq_restart_an;        // sequencer reset of the AN
  wire         seq_restart_lt;        // sequencer reset of the LT
  wire [2:0]   par_det;
  wire         load_pdet;
  wire [1:0]   data_mux_sel;      // select data input to hard PHY
                                  // 00 = AN, 01 = LT, 10 = xgmii
  wire         csr_seq_restart;   // re-start the sequencer
  wire         csr_reset_all;
  wire [3:0]   force_mode;        // Force the Hard PHY into a mode
                                  // 0000 = no force,  001 = GigE mode
                                  // 0010 = XAUI mode, 100 = 10G-R mode
                                  // 0101 = kr, 40G, 100G
                                  // 1100 = 10G KR FEC mode
  wire         dis_lf_timer;      // disable the link_fail_inhibit_timer
  wire         dis_an_timer;      // disable AN timeout.  can get stuck
                                  // stuck in ABILITY_DETECT - if rmt not AN
                                  // stuck in ACKNOWLEDGE_DETECT - if loopback
  wire         dis_max_wait_tmr;  // disable the LT max_wait_timer
  wire         training;          // Link Training in progress
  wire         link_ready;        // link is ready
  wire         seq_an_timeout;    // AN timed-out in Sequencer SM
  wire         seq_lt_timeout;    // LT timed-out in Sequencer SM
  wire         lt_enable ;        // Enable LT
  wire         an_enable;         // enable AN
  wire         en_usr_np;         // Enable user next pages
  wire         pcs_link_sts;      // PCS link status from Hard PHY
  wire         lt_fail_response;  // go to data-mode if LT-fails if this bit is 1
  wire         ber_zero;       // LT reports ber_zero from last measurement 
  wire         fail_lt_if_ber; // if last LT measurement is non-zero, treat as a failed run 
  wire         enable_fec;        // Enable FEC for the channel
  wire [5:0]   fnl_an_tech;       // final AN_TECH parameter
  wire [1:0]   fnl_an_fec;        // final the AN_FEC parameter
  wire         link_good;          // AN completed
  wire         an_rx_idle;         // RX SM in idle state - from RX_CLK
  wire         in_ability_det;     // ARB SM in the ABILITY_DETECT state
  wire [5:0]   lp_tech;            // LP Technology ability = D45:21
  wire [1:0]   lp_fec;             // LP FEC ability = D47:46  output reg
    // for LT
  wire [1:0]   last_dfe_mode;  // Last dfe_mode setting sent to reconfig bundle in SV
  wire [3:0]   last_ctle_rc;   // Last ctle_rc setting sent to reconfig bundle in SV
  wire [1:0]   last_ctle_mode; // Last ctle_mode setting sent to reconfig bundle in SV
  wire         lt_start_rc;      // start the TX EQ reconfig
  wire [2:0]   tap_to_upd;       // specific TX EQ tap to update
                                 // bit-2 = main, bit-1 = post, ...
  wire [MAINTAPWIDTH-1:0] main_rc; // main tap value for reconfig
  wire [POSTTAPWIDTH-1:0] post_rc; // post tap value for reconfig
  wire [PRETAPWIDTH-1:0]  pre_rc;  // pre tap value for reconfig
  wire             seq_start_rc;   // start the PCS reconfig
  wire    csr_restart_lt;
  wire    training_reset;
  wire    train_reset_sync;
  wire    dis_tx_data;
  reg     frame_lock_filt;
  wire    frame_lock;
  wire    rmt_rx_ready;
  wire    sync_trn_fail;           // synchronized Training timed-out

  // for AVMM to/from channel
  wire         chnl_rcfg_read;
  wire [10:0]  chnl_rcfg_address;
  wire         chnl_rcfg_write;
  wire [31:0]  chnl_rcfg_wrdata;
  wire         chnl_rcfg_waitrequest;

  // for AVMM from CPU
  wire         cpu_avmm_read;
  wire [11:0]  cpu_avmm_addr;
  wire         cpu_avmm_write;
  wire [31:0]  cpu_avmm_wrdata;
  wire         cpu_avmm_active;
  assign cpu_avmm_active = cpu_avmm_read | cpu_avmm_write;

//****************************************************************************
// Instantiate the Sequencer module
//****************************************************************************
  // Apply embedded false path timing constraints for AN
`ifdef ALTERA_RESERVED_QIS
  (* altera_attribute = SYNC_AN_CONSTRAINT *)
`endif
generate
  if (SYNTH_SEQ) begin: SEQ_GEN
    wire         seq_reset;

    seqa10_sm  #(
      .RST_1G       (INI_DATAPATH=="1G"),
      .LFT_R_MSB    (LFT_R_MSB),
      .LFT_R_LSB    (LFT_R_LSB),
      .LFT_X_MSB    (LFT_X_MSB),
      .LFT_X_LSB    (LFT_X_LSB)
    ) SEQUENCER (
      .rstn       (~seq_reset),
      .clk        (mgmt_clk),
      .restart    (csr_seq_restart),
      .an_enable  (an_enable),
      .lt_enable  (lt_enable),
      .frce_mode  (force_mode[2:0]),
      .dis_max_wait_tmr (dis_max_wait_tmr),
      .dis_lf_timer  (dis_lf_timer),
      .dis_an_timer  (dis_an_timer),
      .en_usr_np     (en_usr_np),
      .pcs_link_sts  (pcs_link_sts),
      .lt_fail_response(lt_fail_response),
      .training_fail (sync_trn_fail),
      .ber_zero      (1'b0), // not used- so fix to 0
      .fail_lt_if_ber(fail_lt_if_ber),
      .link_ready    (link_ready),
      .seq_an_timeout(seq_an_timeout),
      .seq_lt_timeout(seq_lt_timeout),
      .enable_fec    (enable_fec),
      .data_mux_sel  (data_mux_sel),
     // to/from Auto-Negotiation
      .lcl_tech       ({fnl_an_tech[5:3],(fnl_an_tech[2] |force_mode[3]),fnl_an_tech[1:0]}),
      .lcl_fec        (({fnl_an_fec[1],fnl_an_fec[0]} | {2{force_mode[3]}})),
      .link_good      (link_good),
      .in_ability_det (in_ability_det),
      .an_rx_idle     (an_rx_idle),
      .lp_tech     ({lp_tech[5:3],(lp_tech[2] | force_mode[3]),lp_tech[1:0]}),
      .lp_fec      (lp_fec | {2{force_mode[3]}}),
      .load_pdet   (load_pdet),
      .par_det     (par_det),
      .restart_an  (seq_restart_an),
     // to/from Link Training
      .training    (training),
      .restart_lt  (seq_restart_lt),
     // to/from reconfig
      .rc_busy     (rc_busy),
      .start_rc    (seq_start_rc),
      .pcs_mode_rc (pcs_mode_rc)
   );

    // instantiate the reset synchronizers for the SEQ module
    //  \p4\ip\altera_xcvr_generic\ctrl\alt_xcvr_resync.sv
    alt_xcvr_resync #(
        .SYNC_CHAIN_LENGTH(2),  // Number of flip-flops for retiming
        .WIDTH            (1),  // Number of bits to resync
        .INIT_VALUE       (1)
    ) seq_resync_reset (
      .clk    (mgmt_clk),
      .reset  (usr_seq_reset | csr_reset_all),
      .d      (1'b0),
      .q      (seq_reset)
    );
  end  // if synth_seq
  else begin: NO_SEQ_GEN  // need to drive outputs if no SEQ module
    assign pcs_mode_rc   = {2'b0, mode_1g_10gbar, ~mode_1g_10gbar, 2'b0};
    assign seq_start_rc  = start_pcs_reconfig;
    assign seq_restart_lt = 1'b0;
    assign seq_restart_an = 1'b0;
    assign data_mux_sel   = 2'b10;  // xgmii only, may need to add logic if have AN/LT and no SEQ
    assign enable_fec     = fnl_an_fec[1] & fnl_an_fec[0];  // not qualified with link partner's fec ability and fec request
    assign seq_an_timeout = 1'b0;
    assign seq_lt_timeout = 1'b0;
    assign link_ready     = (mode_1g_10gbar & rx_syncstatus) |
                           (~mode_1g_10gbar & rx_data_ready);
  end  // else synth_seq
endgenerate


//****************************************************************************
// Instantiate the LT Local Coefficient Update module
//****************************************************************************
  wire [2*MAINTAPWIDTH+POSTTAPWIDTH+PRETAPWIDTH+3:0]  param_ovrd;
  wire           lt_rc_active;
  wire            training_error;  // Training Error (ber_max)
  wire            train_lock_err;  // Frame Lock Error
  wire           rmt_upd_new;
  wire [5:0]     rmt_coef_updl;
  wire [13:12]   rmt_coef_updh;
  wire           lcl_upd_new;
  wire [5:0]     lcl_coefl;
  wire [13:12]   lcl_coefh;
  wire           lcl_sts_new;
  wire [5:0]     lcl_coef_sts;
  wire [5:0]     rmt_coef_sts;
  wire [BERWIDTH-1:0] ber_cnt;        // BER counter value
  wire                ber_max;        // BER counter roll-over
  wire                bert_done;      // BER Timer at max count for SM
  wire                clear_ber;      // clear the BER counter
  wire         rx_trained;
  wire         training_fail;     // Training timed-out
  wire         nolock_rxeq;
  wire         fail_ctle;
  wire         ltd_ok_1ms; 
  wire         clr_ltd_ok_1ms ; 
  wire         sel_avmm_rcfg;

generate
  if (SYNTH_LT) begin: LT_GEN
    wire         rxeq_rc_busy;
    wire         dfe_start_rc;     // start the TX EQ reconfig
    wire         ctle_start_rc;    // start the TX EQ reconfig

  // Apply embedded false path timing constraints for LT
`ifdef ALTERA_RESERVED_QIS
  (* altera_attribute = SYNC_LTRX_CONSTRAINT *)
`endif
    lta10_lcl_coef #(
      .MAINTAPWIDTH (MAINTAPWIDTH),
      .POSTTAPWIDTH (POSTTAPWIDTH),
      .PRETAPWIDTH  (PRETAPWIDTH),
      .VMAXRULE (VMAXRULE),
      .VMINRULE (VMINRULE),
      .VODMINRULE (VODMINRULE),
      .VPOSTRULE (VPOSTRULE),
      .VPRERULE  (VPRERULE),
      .PREMAINVAL (PREMAINVAL),
      .PREPOSTVAL (PREPOSTVAL),
      .PREPREVAL  (PREPREVAL),
      .INITMAINVAL (INITMAINVAL),
      .INITPOSTVAL (INITPOSTVAL),
      .INITPREVAL  (INITPREVAL)
    ) LCL_COEF (
      .rstn        (~csr_reset_all),
      .clk         (mgmt_clk),
      .lt_enable   (lt_enable & (data_mux_sel == 2'b01)),
      .lt_restart  (csr_restart_lt | seq_restart_lt | train_reset_sync),
      .lcl_upd_new (lcl_upd_new),
      .lcl_coefl   (lcl_coefl),
      .lcl_coefh   (lcl_coefh),
      .param_ovrd  (param_ovrd),
        // for the reconfig Interface
      .rc_busy    (rc_busy),
      .start_rc   (lt_start_rc),
      .main_rc    (main_rc),
      .post_rc    (post_rc),
      .pre_rc     (pre_rc),
      .tap_to_upd (tap_to_upd),
       // outputs
      .lt_rc_active (lt_rc_active),
      .dis_tx_data  (dis_tx_data),
      .lcl_sts_new  (lcl_sts_new),
      .lcl_coef_sts (lcl_coef_sts)
    );


//****************************************************************************
// Instantiate the LT Receive remote TX EQ Optimization SM
// Implemented in a CPU for 14.0
//****************************************************************************
   wire [13-BERWIDTH:0] ber_ext = 'd0;  // 0 extend the ber_cnt to 14 bits
   wire sync_dis_data;                  // synchronized dis_tx_data
   wire cpu_burstcount;          // un-used output
   wire cpu_debugaccess;         // un-used output
   wire [3:0] cpu_byteenable;    // un-used output
   reg wait_req_dly = 0;         // to create read data vailid
   wire cpu_readdatavalid;       // read data valid input to cpu

   wire en_frame_lock_filt;
   reg  cpu_reset;
   // Do not reset CPU on in seq_start_rc -- CPU needs time to boot up 
   // since sim timeouts are shorter, retarting CPU on seq_start_rc will cause timeout   
  `ifdef ALTERA_RESERVED_QIS
    always @ (posedge mgmt_clk )
      cpu_reset <= ~(mgmt_clk_reset | csr_reset_all | csr_restart_lt | (seq_start_rc & pcs_mode_rc[1]) ) ;
  `else 
    always @ (posedge mgmt_clk )
      cpu_reset <= ~(mgmt_clk_reset | csr_reset_all | csr_restart_lt) ;
  `endif
   always @(posedge mgmt_clk) begin
       frame_lock_filt <= frame_lock | (frame_lock_filt & en_frame_lock_filt);
   end

   // define for the CPU connections
`define ALTERA_XCVR_KR_CPU_PORT_MAPPING  (         \
      .clk_clk           ( mgmt_clk          ),    \
      .reset_reset_n     (cpu_reset),  \
        /* PIO Inputs */                           \
      .enable_export     ({ frame_lock,            \
                            seq_restart_lt,        \
                            lt_enable & ~sync_dis_data & ~sync_trn_fail} ),  \
      .rmt_sts_new_export  (lcl_upd_new        ),  \
      .rmt_sts_export      (rmt_coef_sts       ),  \
      .bert_done_export    (bert_done          ),  \
      .ber_in_export       ({ ber_max,             \
                              ltd_ok_1ms,      \
                              ber_ext,             \
                              ber_cnt}         ),  \
        /* PIO Outputs */                          \
      .clear_ber_export    (clear_ber          ),  \
      .rmt_cmd_new_export  (rmt_upd_new        ),  \
      .rmt_cmd_export      ({ rmt_coef_updh,       \
                              rmt_coef_updl}   ),  \
      .training_sts_export ({ nolock_rxeq,         \
                              train_lock_err,      \
                              training_error,      \
                              rx_trained,          \
                              en_frame_lock_filt} ),  \
      .rxeq_sts_export     ({ fail_ctle,           \
                              last_dfe_mode,       \
                              last_ctle_rc,        \
                              last_ctle_mode}  ),  \
      .ber_zero_export     (clr_ltd_ok_1ms     ),  \
        /* AVMM Master */                          \
      .avmm_waitrequest    (rc_busy | chnl_rcfg_waitrequest |   \
                             (~cpu_avmm_active & lt_start_rc)), \
      .avmm_readdata       (mgmt_readdata),        \
      .avmm_readdatavalid  (cpu_readdatavalid),    \
      .avmm_burstcount     (cpu_burstcount),       \
      .avmm_writedata      (cpu_avmm_wrdata),      \
      .avmm_address        (cpu_avmm_addr),        \
      .avmm_write          (cpu_avmm_write),       \
      .avmm_read           (cpu_avmm_read),        \
      .avmm_byteenable     (cpu_byteenable),       \
      .avmm_debugaccess    (cpu_debugaccess)       \
    );

    // CPU variants
    if          ( USE_DEBUG_CPU && !USE_ECC_CPU) begin : DEBUG_CPU
      kra10_debug_cpu   kra10_debug_cpu_inst
      `ALTERA_XCVR_KR_CPU_PORT_MAPPING
    end else if ( USE_DEBUG_CPU &&  USE_ECC_CPU) begin : ECC_DBG_CPU
      kr_dbg_ecc_cpu   kr_dbg_ecc_cpu_inst
      `ALTERA_XCVR_KR_CPU_PORT_MAPPING
    end else if (!USE_DEBUG_CPU &&  USE_ECC_CPU) begin : ECC_CPU
      kr_ecc_cpu   kr_ecc_cpu_inst
      `ALTERA_XCVR_KR_CPU_PORT_MAPPING
    end else begin : LT_CPU
      kra10_cpu   kra10_cpu_inst
      `ALTERA_XCVR_KR_CPU_PORT_MAPPING
    end

    // instantiate the reset synchronizers for the CPU module
    //  \p4\ip\altera_xcvr_generic\ctrl\alt_xcvr_resync.sv
    alt_xcvr_resync #(
      .WIDTH  (3)       // Number of bits to resync
    ) mgmt_resync_reset (
      .clk    (mgmt_clk),
      .reset  (mgmt_clk_reset),
      .d      ({dis_tx_data,   training_fail, training_reset}),
      .q      ({sync_dis_data, sync_trn_fail, train_reset_sync})
    );

    // Generate the CPU read data valid from falling edge of wait request
    always @(posedge mgmt_clk)
      wait_req_dly <= chnl_rcfg_waitrequest & cpu_avmm_read;
     assign cpu_readdatavalid = wait_req_dly & ~chnl_rcfg_waitrequest & ~sel_avmm_rcfg;

  end  // if synth_lt
  else begin: NO_LT_GEN   // need to drive outputs if no LT module
    assign lt_start_rc      = 1'b0;
    assign main_rc          = 'd0;
    assign post_rc          = 'd0;
    assign pre_rc           = 'd0;
    assign tap_to_upd       = 3'd0;
    assign training_error   = 1'b0;
    assign train_lock_err   = 1'b0;
    assign last_dfe_mode    = 'd0;
    assign last_ctle_rc     = 'd0;
    assign last_ctle_mode   = 'd0;
    assign rmt_upd_new      =1'b0;
    assign rmt_coef_updl    = 'd0;
    assign rmt_coef_updh    = 'd0;
    assign lcl_sts_new      =1'b0;
    assign lcl_coef_sts     = 'd0;
    assign rmt_coef_sts     = 'd0;
    assign dis_tx_data      = 1'b1;
    assign nolock_rxeq      = 1'b0;
    assign fail_ctle        = 1'b0;
    assign ber_zero   = 1'b1;
    assign clr_ltd_ok_1ms   = 1'b0;
    assign cpu_avmm_read   = 1'b0;
    assign cpu_avmm_write  = 1'b0;
    assign cpu_avmm_addr   = 'd0;
    assign cpu_avmm_wrdata = 'd0;
    assign sync_trn_fail = 1'b0;
  end  // else synth_lt
endgenerate


//****************************************************************************
// Instantiate the Reconfig module
// Requests come from the Sequencer and LT modules
// Commands via AVMM to the native PHY
//****************************************************************************
  wire en_rcfg_cal;
  wire calibration_busy;
  assign calibration_busy = tx_cal_busy | rx_cal_busy;

  // "OR" this with the reset input on the channel instance
  wire rcfg_analog_reset, rcfg_analog_reset_tx, rcfg_digital_reset, rcfg_digital_reset_tx;
  wire tx_analogreset_ack,rx_analogreset_ack; 
  // Apply embedded false path timing constraints
`ifdef ALTERA_RESERVED_QIS
  (* altera_attribute = SDC_1588_CONSTRAINTS *)
`endif

generate
  if (SYNTH_RCFG) begin: RCFG_GEN
    wire       rcfg_write;
    wire       rcfg_read;
    wire [9:0] rcfg_address;
    wire [7:0] rcfg_wrdata;

    rcfg_top  #(
      .ES_DEVICE   (ES_DEVICE),
      .LTD_MSB     (LTD_MSB),
      .SYNTH_LT    (SYNTH_LT),
      .SYNTH_AN_LT (SYNTH_AN_LT),
      .SYNTH_GIGE  (SYNTH_GIGE),
      .SYNTH_FEC   (SYNTH_FEC),
      .SYNTH_1588  (SYNTH_1588),
      .REF_CLK     (REF_CLK    )
    ) RECONFIG (
      .mgmt_clk_reset (mgmt_clk_reset),
      .mgmt_clk       (mgmt_clk),
      .seq_start_rc   (seq_start_rc),
      .pcs_mode_rc    (pcs_mode_rc),
      .rc_busy        (rc_busy),
      .skip_cal       (~en_rcfg_cal),   // native may not work, may need to skip
      .lt_start_rc    (~cpu_avmm_active & lt_start_rc),
      .main_rc        (main_rc),
      .post_rc        (post_rc),
      .pre_rc         (pre_rc),
      .tap_to_upd     (tap_to_upd),
      .calibration_busy   (calibration_busy),
      .rx_is_lockedtodata (rx_is_lockedtodata),
      .rx_is_lockedtoref  (rx_is_lockedtoref ),
      .analog_reset       (rcfg_analog_reset),
      .analog_reset_tx    (rcfg_analog_reset_tx),
      .digital_reset      (rcfg_digital_reset),
      .digital_reset_tx   (rcfg_digital_reset_tx),
      .tx_analogreset_ack (tx_analogreset_ack),
      .rx_analogreset_ack (rx_analogreset_ack),
      .xcvr_rcfg_write        (rcfg_write),
      .xcvr_rcfg_read         (rcfg_read),
      .xcvr_rcfg_address      (rcfg_address),
      .xcvr_rcfg_wrdata       (rcfg_wrdata),
      .xcvr_rcfg_rddata       (mgmt_readdata[7:0]),
      .xcvr_rcfg_wtrqst       (chnl_rcfg_waitrequest)
     );

    // need to drive AVMM for Reconfig at start and until busy done
    assign sel_avmm_rcfg = rc_busy | seq_start_rc;
    wire debug_cpu_avmm_active ;
    if (USE_DEBUG_CPU) begin : Allow_LT_AVMMM
       assign debug_cpu_avmm_active = cpu_avmm_active ;
    end 
    else begin :  No_LT_AVMMM 
       assign debug_cpu_avmm_active = 1'b1 ;
    end 

    // Mux for reconfig AVMM to Channel
    // Update  AVMM bus to CPU only when it needs
    assign chnl_rcfg_write   = sel_avmm_rcfg  ? rcfg_write     :
                               (pcs_mode_rc[1] & debug_cpu_avmm_active) ? cpu_avmm_write :
                               mgmt_write;
    assign chnl_rcfg_read    = sel_avmm_rcfg  ? rcfg_read      :
                               (pcs_mode_rc[1] & debug_cpu_avmm_active) ? cpu_avmm_read  : 
                               mgmt_read;
    assign chnl_rcfg_address = sel_avmm_rcfg  ? {1'b0,rcfg_address}  :
                               (pcs_mode_rc[1] & debug_cpu_avmm_active) ? cpu_avmm_addr[10:0]  : 
                               mgmt_address[10:0];
    assign chnl_rcfg_wrdata  = sel_avmm_rcfg  ? {24'b0,rcfg_wrdata}  :
                               (pcs_mode_rc[1] & debug_cpu_avmm_active) ? cpu_avmm_wrdata      :
                               mgmt_writedata;
    assign mgmt_waitrequest  = rc_busy | seq_start_rc | (pcs_mode_rc[1] & debug_cpu_avmm_active) | chnl_rcfg_waitrequest;

  end else begin: NO_RCFG_GEN
    assign chnl_rcfg_write       =  mgmt_write;
    assign chnl_rcfg_read        =  mgmt_read;
    assign chnl_rcfg_address     =  mgmt_address[10:0];
    assign chnl_rcfg_wrdata      =  mgmt_writedata;
    assign mgmt_waitrequest      =  chnl_rcfg_waitrequest;
    assign rc_busy               =  1'b0;
    assign rcfg_analog_reset     =  1'b0;
    assign rcfg_analog_reset_tx  =  1'b0;
    assign rcfg_digital_reset    =  1'b0;
    assign rcfg_digital_reset_tx =  1'b0;
  end
endgenerate


//****************************************************************************
// Instantiate the Ultra Channel
//****************************************************************************
    // Apply embedded false path timing constraints
//    (* altera_attribute = SDC_GIGE_PCS *)
  ultra_chnl #(
    .ES_DEVICE   (ES_DEVICE),
    .REF_CLK_FREQ_10G  (REF_CLK_FREQ_10G),
    .HARD_PRBS_ENABLE  (HARD_PRBS_ENABLE),
    .SYNTH_AN     (SYNTH_AN),
    .SYNTH_LT     (SYNTH_LT),
    .SYNTH_GIGE   (SYNTH_GIGE),
    .SYNTH_GMII   (SYNTH_GMII),
    .SYNTH_FEC    (SYNTH_FEC),
    .LTD_MSB      (LTD_MSB),
    .INI_DATAPATH (INI_DATAPATH),
    .PHY_IDENTIFIER   (PHY_IDENTIFIER),  // PHY Identifier
    .DEV_VERSION      (DEV_VERSION   ),  // Customer Phy's Core Version
    .SYNTH_SGMII      (SYNTH_SGMII  ),   // Enable SGMII logic synthesis
    .SYNTH_CL37ANEG   (SYNTH_CL37ANEG),  // Enable GIGE AN (Clause 37)
    .SYNTH_1588_1G    (SYNTH_1588_1G),
    .SYNTH_1588_10G   (SYNTH_1588_10G),
    .BERWIDTH     (BERWIDTH),
    .TRNWTWIDTH   (TRNWTWIDTH),
    .MAINTAPWIDTH (MAINTAPWIDTH),
    .POSTTAPWIDTH (POSTTAPWIDTH),
    .PRETAPWIDTH  (PRETAPWIDTH),
    .AN_PAUSE     (AN_PAUSE),
    .AN_TECH      (AN_TECH),
    .AN_SELECTOR  (AN_SELECTOR),
    .CAPABLE_FEC  (CAPABLE_FEC),
    .ENABLE_FEC   (ENABLE_FEC),
    .ERR_INDICATION (ERR_INDICATION)
    ) CHANNEL (
    .tx_serial_clk_10g  (tx_serial_clk_10g),
    .tx_serial_clk_1g   (tx_serial_clk_1g),
    .rx_cdr_ref_clk_10g (rx_cdr_ref_clk_10g),
    .rx_cdr_ref_clk_1g  (rx_cdr_ref_clk_1g),
    .xgmii_tx_clk       (xgmii_tx_clk),
    .xgmii_rx_clk       (xgmii_rx_clk),
    .calc_clk_1g        (calc_clk_1g),
    .tx_clkout          (tx_clkout),
    .rx_clkout          (rx_clkout),
    .tx_pma_clkout      (tx_pma_clkout),
    .rx_pma_clkout      (rx_pma_clkout),
    .tx_pma_div_clkout  (tx_pma_div_clkout),
    .rx_pma_div_clkout  (rx_pma_div_clkout),
    .tx_analogreset    (tx_analogreset  | rcfg_analog_reset_tx),
    .tx_digitalreset   (tx_digitalreset | rcfg_digital_reset_tx),
    .rx_analogreset    (rx_analogreset  | rcfg_analog_reset),
    .rx_digitalreset   (rx_digitalreset | rcfg_digital_reset),
    .tx_analogreset_ack(tx_analogreset_ack),
    .rx_analogreset_ack(rx_analogreset_ack),
    .mgmt_clk          (mgmt_clk),
    .mgmt_clk_reset    (mgmt_clk_reset),
    .mgmt_address      (chnl_rcfg_address),
    .mgmt_read         (chnl_rcfg_read),
    .mgmt_readdata     (mgmt_readdata),
    .mgmt_write        (chnl_rcfg_write),
    .mgmt_writedata    (chnl_rcfg_wrdata),
    .mgmt_waitrequest  (chnl_rcfg_waitrequest),
    .gmii_tx_d   (gmii_tx_d),
    .gmii_rx_d   (gmii_rx_d),
    .gmii_tx_en  (gmii_tx_en),
    .gmii_tx_err (gmii_tx_err),
    .gmii_rx_err (gmii_rx_err),
    .gmii_rx_dv  (gmii_rx_dv),
    .led_an       (led_an),
    .led_char_err (led_char_err),
    .led_disp_err (led_disp_err),
    .led_link     (led_link),
    .led_panel_link     (led_panel_link),
    .tx_pcfifo_error_1g (tx_pcfifo_error_1g),
    .rx_pcfifo_error_1g (rx_pcfifo_error_1g),
    .rx_syncstatus (rx_syncstatus),
    .rx_clkslip    (rx_clkslip),
    .mii_tx_clkena (mii_tx_clkena),
    .mii_rx_clkena (mii_rx_clkena),
    .mii_tx_clkena_half_rate (mii_tx_clkena_half_rate),
    .mii_rx_clkena_half_rate (mii_rx_clkena_half_rate),
    .mii_tx_d       (mii_tx_d  ),
    .mii_tx_en      (mii_tx_en ),
    .mii_tx_err     (mii_tx_err),
    .mii_rx_d       (mii_rx_d  ),
    .mii_rx_dv      (mii_rx_dv ),
    .mii_rx_err     (mii_rx_err),
    .mii_speed_sel  (mii_speed_sel),
    .xgmii_tx_dc    (xgmii_tx_dc),
    .xgmii_rx_dc    (xgmii_rx_dc),
    .rx_is_lockedtodata (rx_is_lockedtodata),
    .rx_is_lockedtoref  (rx_is_lockedtoref),
    .tx_cal_busy    (tx_cal_busy),
    .rx_cal_busy    (rx_cal_busy),
    .rx_data_ready  (rx_data_ready),
    .rx_block_lock  (rx_block_lock),
    .rx_hi_ber      (rx_hi_ber),
    .tx_serial_data (tx_serial_data),
    .rx_serial_data (rx_serial_data),
    .rx_latency_adj_10g (rx_latency_adj_10g),
    .tx_latency_adj_10g (tx_latency_adj_10g),
    .rx_latency_adj_1g  (rx_latency_adj_1g),
    .tx_latency_adj_1g  (tx_latency_adj_1g),
    .rx_prbs_err_clr (rx_prbs_err_clr ),
    .rx_prbs_done    (rx_prbs_done    ),
    .rx_prbs_err     (rx_prbs_err     ),
    .lcl_rf         (lcl_rf),
    .rxeq_done      (1'b1),    // Should connect to CPU at some point
    .lt_rc_active   (lt_rc_active),
    .rc_busy        (rc_busy),
    .seq_start_rc   (seq_start_rc),
    .pcs_link_sts   (pcs_link_sts),
    .lt_fail_response(lt_fail_response),
    .pcs_mode_rc    (pcs_mode_rc),
    .data_mux_sel   (data_mux_sel),
    .seq_restart_an (seq_restart_an),
    .seq_restart_lt (seq_restart_lt),
    .training       (training),
    .dis_max_wait_tmr (dis_max_wait_tmr),
    .link_ready       (link_ready),
    .seq_an_timeout   (seq_an_timeout),
    .csr_reset_all    (csr_reset_all),
    .seq_lt_timeout   (seq_lt_timeout),
    .csr_seq_restart  (csr_seq_restart),
    .dis_an_timer     (dis_an_timer),
    .dis_lf_timer     (dis_lf_timer),
    .force_mode       (force_mode),
    .fail_lt_if_ber   (fail_lt_if_ber),
    .an_enable  (an_enable),
    .lt_enable  (lt_enable),
    .en_usr_np  (en_usr_np),
    .enable_fec (enable_fec),
      .load_pdet       (load_pdet),
      .par_det         (par_det),
    .fnl_an_tech(fnl_an_tech),
    .fnl_an_fec (fnl_an_fec),
    .link_good  (link_good),
    .an_rx_idle (an_rx_idle),
    .in_ability_det (in_ability_det),
    .lp_tech        (lp_tech),
    .lp_fec         (lp_fec),
    .ltd_ok_1ms     (ltd_ok_1ms    ), 
    .clr_ltd_ok_1ms (clr_ltd_ok_1ms),
    .rmt_upd_new    (rmt_upd_new),
    .rmt_coef_updl  (rmt_coef_updl),
    .rmt_coef_updh  (rmt_coef_updh),
      .lcl_sts_new  (lcl_sts_new),
      .lcl_coef_sts (lcl_coef_sts),
    .lcl_upd_new    (lcl_upd_new),
    .lcl_coefl      (lcl_coefl),
    .lcl_coefh      (lcl_coefh),
    .rmt_rx_ready   (rmt_rx_ready),
    .rmt_coef_sts   (rmt_coef_sts),
      .ber_cnt   (ber_cnt),
      .ber_max   (ber_max),
      .bert_done (bert_done),
      .clear_ber      (clear_ber),
      .rx_trained     (rx_trained),
      .training_error (training_error),
      .train_lock_err (train_lock_err),
      .main_rc        (main_rc),
      .post_rc        (post_rc),
      .pre_rc         (pre_rc),
      .csr_restart_lt   (csr_restart_lt),
      .training_fail    (training_fail),
      .training_reset   (training_reset),
      .dis_tx_data      (dis_tx_data),
      .frame_lock_filt  (frame_lock_filt),
      .frame_lock       (frame_lock),
      .nolock_rxeq      (nolock_rxeq),
      .fail_ctle        (fail_ctle),
      .last_dfe_mode (last_dfe_mode),
      .last_ctle_rc  (last_ctle_rc),
      .last_ctle_mode(last_ctle_mode),
   // LT register bits - some will change for NIOS
      .param_ovrd     (param_ovrd),
      .en_rcfg_cal    (en_rcfg_cal)
    );

endmodule  //altera_xcvr_10gkr_a10


//****************************************************************************
//****************************************************************************
// Glitch-Free Clock Mux module
// from Chapter 11 of Recommended HDL Coding Styles document
//  http://www.altera.com/literature/hb/qts/qts_qii51007.pdf
// See Figure 11-3 for circuit diagram
// code taken directly from Example 11-48
//****************************************************************************
module gf_clock_mux (clk, clk_select, clk_out);
  parameter num_clocks = 2;

  input [num_clocks-1:0] clk;
  input [num_clocks-1:0] clk_select; // one hot
  output clk_out;

  genvar i;
  reg  [num_clocks-1:0] ena_r0;
  reg  [num_clocks-1:0] ena_r1;
  reg  [num_clocks-1:0] ena_r2;
  wire [num_clocks-1:0] qualified_sel;

  // A look-up-table (LUT) can glitch when multiple inputs
  // change simultaneously. Use the keep attribute to
  // insert a hard logic cell buffer and prevent
  // the unrelated clocks from appearing on the same LUT.

  wire [num_clocks-1:0] gated_clks /* synthesis keep */;

`ifdef ALTERA_RESERVED_QIS
  // Apply embedded false path timing constraint to first flop
  (* altera_attribute  = "-name SDC_STATEMENT \"set_false_path -to [get_registers {*gf_clock_mux*ena_r0*}]\"" *)
`endif
initial begin
  ena_r0 = 0;
  ena_r1 = 0;
  ena_r2 = 0;
end

  generate
    for (i=0; i<num_clocks; i=i+1) begin : lp0
      wire [num_clocks-1:0] tmp_mask;

      //assign tmp_mask = {num_clocks{1'b1}} ^ (1 << i);
      assign tmp_mask = {num_clocks{1'b1}} ^ ({{(num_clocks-1){1'b0}},1'b1} << i);
      assign qualified_sel[i] = clk_select[i] & (~|(ena_r2 & tmp_mask));

      always @(posedge clk[i]) begin
        ena_r0[i] <= qualified_sel[i];
        ena_r1[i] <= ena_r0[i];
      end // always

      always @(negedge clk[i]) ena_r2[i] <= ena_r1[i];

      assign gated_clks[i] = clk[i] & ena_r2[i];
    end // for i=
  endgenerate

// These will not exhibit simultaneous toggle by construction
  assign clk_out = |gated_clks;
endmodule  // gf_clock_mux
