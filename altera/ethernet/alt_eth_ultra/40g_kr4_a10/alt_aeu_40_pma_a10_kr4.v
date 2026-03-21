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


 `timescale 1 ps / 1 ps

// force clocks for timing closure, cut paths between unrelated clocks
(* ALTERA_ATTRIBUTE = "disable_da_rule=\"d101,d103\"; -name MESSAGE_DISABLE 332056; -name SDC_STATEMENT \"foreach_in_collection pin [get_pins -compatibility_mode {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts*inst_twentynm_hssi_pma_rx_deser|clkdiv_user}] {create_clock -period {156.25 MHz} $pin}\"; -name SDC_STATEMENT \"foreach_in_collection pin [get_pins -compatibility_mode {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts*inst_twentynm_hssi_pma_tx_ser|clk_divtx_user}] {create_clock -period {156.25 MHz} $pin}\"; -name SDC_STATEMENT \"foreach_in_collection pin [get_pins -compatibility_mode {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts*inst_twentynm_hssi_rx_pld_pcs_interface|pld_pcs_rx_clk_out}] {create_clock -period {322.26562 MHz} $pin}\"; -name SDC_STATEMENT \"foreach_in_collection pin [get_pins -compatibility_mode {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts*inst_twentynm_hssi_tx_pld_pcs_interface|pld_pcs_tx_clk_out}] {create_clock -period {322.26562 MHz} $pin}\"; -name SDC_STATEMENT \"set_clock_groups -exclusive -group {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts[0]*inst_twentynm_hssi_pma_tx_ser|clk_divtx_user} -group {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts[1]*inst_twentynm_hssi_pma_tx_ser|clk_divtx_user} -group {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts[2]*inst_twentynm_hssi_pma_tx_ser|clk_divtx_user} -group {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts[3]*inst_twentynm_hssi_pma_tx_ser|clk_divtx_user} -group {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts*inst_twentynm_hssi_tx_pld_pcs_interface|pld_pcs_tx_clk_out}\"; -name SDC_STATEMENT \"set_clock_groups -exclusive -group {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts[0]*inst_twentynm_hssi_pma_rx_deser|clkdiv_user} -group {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts[1]*inst_twentynm_hssi_pma_rx_deser|clkdiv_user} -group {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts[2]*inst_twentynm_hssi_pma_rx_deser|clkdiv_user} -group {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts[3]*inst_twentynm_hssi_pma_rx_deser|clkdiv_user} -group {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts*inst_twentynm_hssi_rx_pld_pcs_interface|pld_pcs_rx_clk_out}\"; -name SDC_STATEMENT \"set_clock_groups -asynchronous -group {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts*inst_twentynm_hssi_pma_rx_deser|clkdiv_user} -group {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts*inst_twentynm_hssi_pma_tx_ser|clk_divtx_user} -group {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts*inst_twentynm_hssi_rx_pld_pcs_interface|pld_pcs_rx_clk_out} -group {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts*inst_twentynm_hssi_tx_pld_pcs_interface|pld_pcs_tx_clk_out}\"; -name SDC_STATEMENT \"set_clock_groups -asynchronous -group {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts*inst_twentynm_hssi_pma_rx_deser|clkdiv_user *|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts*inst_twentynm_hssi_pma_tx_ser|clk_divtx_user *|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts*inst_twentynm_hssi_rx_pld_pcs_interface|pld_pcs_rx_clk_out *|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts*inst_twentynm_hssi_tx_pld_pcs_interface|pld_pcs_tx_clk_out}\"; -name SDC_STATEMENT \"set_false_path -from [get_clocks {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts*inst_twentynm_hssi_rx_pld_pcs_interface|pld_pcs_rx_clk_out}] -to [get_registers {*|e40_inst|phy.phy_inst|iof|rxd_wires_2*}]\"; -name SDC_STATEMENT \"set_false_path -from [get_clocks {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts*inst_twentynm_hssi_tx_pld_pcs_interface|pld_pcs_tx_clk_out}] -to [get_registers {*|e40_inst|phy.phy_inst|iof|tx_*launch_2*}]\"; -name SDC_STATEMENT \"set_false_path -from [get_clocks {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts*inst_twentynm_hssi_tx_pld_pcs_interface|pld_pcs_tx_clk_out}] -to [get_registers {*|e40_inst|phy.phy_inst|iof|tx_*_data_valid_2*}]\"" *)
module alt_aeu_40_pma_a10_kr4 #(
    parameter ES_DEVICE     = 1,            // select ES or PROD device, 1 is ES-DEVICE, 0 is device
    parameter FAKE_TX_SKEW  = 1'b0,          // skew the TX data for simulation
    parameter SYNTH_AN      = 1,            // Synthesize/include the AN logic
    parameter SYNTH_LT      = 1,            // Synthesize/include the LT logic
    parameter SYNTH_SEQ     = 1,            // Synthesize/include Sequencer logic
    parameter SYNTH_FEC     = 1,            // Synthesize/include the FEC logic
    // Sequencer parameters not used in the AN block
    parameter LINK_TIMER_KR = 504,          // Link Fail Timer for BASE-R PCS in ms
    // LT parameters
    parameter BERWIDTH      = 10,          // Width (>4) of the Bit Error counter
    parameter TRNWTWIDTH    = 7,           // Width (7,8) of Training Wait counter
    parameter MAINTAPWIDTH  = 5,           // Width of the Main Tap control
    parameter POSTTAPWIDTH  = 6,           // Width of the Post Tap control
    parameter PRETAPWIDTH   = 5,           // Width of the Pre Tap control
    parameter VMAXRULE      = 5'd30,       // VOD+Post+Pre <= Device Vmax 1200mv
    parameter VMINRULE      = 5'd6,        // VOD-Post-Pre >= Device VMin 165mv
    parameter VODMINRULE    = 5'd14,       // VOD >= IEEE VOD Vmin of 440mV
    parameter VPOSTRULE     = 6'd25,       // Post_tap <= VPOST
    parameter VPRERULE      = 5'd16,       // Pre_tap <= VPRE
    parameter PREMAINVAL    = 5'd30,       // Preset Main tap value
    parameter PREPOSTVAL    = 6'd0,        // Preset Post tap value
    parameter PREPREVAL     = 5'd0,        // Preset Pre tap value
    parameter INITMAINVAL   = 5'd25,       // Initialize Main tap value
    parameter INITPOSTVAL   = 6'd22,       // Initialize Post tap value
    parameter INITPREVAL    = 5'd3,        // Initialize Pre tap value
    parameter USE_DEBUG_CPU = 0,           // Use the Debug version of the CPU

    // AN parameters
    parameter AN_CHAN       = 4'b0001,      // "master" channel to run AN on (one-hot)
    parameter AN_PAUSE      = 3'b011,       // Initial setting for Pause ability, depends upon MAC  
    parameter AN_TECH       = 6'b00_1000,   // Tech ability, only 40G-KR4 valid
                                            // bit-0 = GigE, bit-1 = XAUI
                                            // bit-2 = 10G , bit-3 = 40G BP
                                            // bit 4 = 40G-CR4, bit 5 = 100G-CR10
//    parameter AN_FEC        = 2'b11,        // Initial setting for FEC, bit1=request, bit0=ability 
    parameter AN_SELECTOR   = 5'b0_0001,    // AN selector field 802.3 = 5'd1
    parameter CAPABLE_FEC      = 0,    // FEC ability on power on
    parameter ENABLE_FEC       = 0,    // FEC request on power on
    parameter ERR_INDICATION   = 0,    // Turn error indication on/off
    // PHY parameters
    parameter REF_CLK_FREQ_10G  = "644.53125 MHz", // speed for clk_ref
    parameter MGMT_CLK_IN_KHZ    = 100000,     // clk_status rate in Mhz
    parameter LANES             = 4        // for convenience; don't change
)(
    input pma_arst,   // asynchronous reset for native PHY reset controllers & CSRs
    input usr_an_lt_reset,
    input usr_seq_reset,
    input clk_status, // management/csr clock (for status_ bus)
    input [3:0] tx_serial_clk_10g,   // high speed serial clock0
    input rx_cdr_ref_clk_10g,   // cdr_ref_clk
    
    
    // to high speed IO pins
    input  [LANES-1:0] rx_serial,
    output [LANES-1:0] tx_serial,

    // 66 bit data words on clk_tx
    input               clk_tx,      // tx parallel data clock
    output              tx_ready,    // tx clocks stable (sync to clk_status)
    input               tx_pll_lock, // plls locked (async signal)
    input  [40*LANES-1:0] tx_datain,
    input  [66*LANES-1:0] tx_fec_datain,
    
    // 66 bit data words on clk_rx
    input               clk_rx,      // rx parallel data clock
    output              rx_ready,    // rx clocks stable (sync to clk_status)
    output [LANES-1:0]  rx_cdr_lock, // cdr locked (async signal)
    output [40*LANES-1:0] rx_dataout,
    input               lanes_deskewed, // indicates RX lock in 40G data mode
    
    // raw hssi out
    output [LANES-1:0]   rx_10g_clk33out,
    output [LANES-1:0]   tx_10g_clk33out,
    
    output [LANES-1:0]   tx_10g_coreclkin,
    output [LANES-1:0]   rx_10g_coreclkin,
    
    // fpll lock signals (sync to clk_status)
    input clk_rx_ready,
    input clk_tx_ready,
    
    // ultra access to hssi
    input [3:0] tx_valid,
    input [3:0] tx_fec_valid,
    input [3:0] rx_rd_en,
    input [3:0] rx_fifo_aclr,
    input  [3:0] rx_seriallpbken,
                
    output [3:0] tx_full,
    output [3:0] tx_pfull,
    output [3:0] tx_empty,
    output [3:0] tx_pempty,
    output [3:0] rx_full,
    output [3:0] rx_pfull,
    output [3:0] rx_empty,
    output [3:0] rx_pempty,
    
    input set_lock_data,
    input set_lock_ref,
    
    output tx_analogreset,
    output mgmt_rc_busy,
    
    // avalon_mm for standard csrs (on clk_status)
    input         status_read,
    input         status_write,
    input  [7:0]  status_addr,
    output [31:0] status_readdata,
    input  [31:0] status_writedata,
    output reg    status_readdata_valid,
    
    // hssi reconfig access
    input      reconfig_reset,
    input      reconfig_write,
    input      reconfig_read,
    input  wire [11:0]  reconfig_address,
    input  wire [31:0]  reconfig_writedata,
    output wire [31:0]  reconfig_readdata,
    output     reconfig_waitrequest

);

    localparam  SYNC_LTRX_CONSTRAINT = {"-name SDC_STATEMENT \"set_false_path -from [get_registers {*LINK_TRAIN|*lt32_rx_data:RX_DATAPATH|lcl_coef*}] -to [get_registers {*LCL_COEF|*}]\""};

    //****************************************************************************
    // Define Parameters 
    //****************************************************************************
    
    // FEC bits for AN, bit1=request, bit0=ability- only when FEC
    localparam AN_FEC = (SYNTH_FEC)? {ENABLE_FEC[0],CAPABLE_FEC[0]} : 2'b00 ;

    // Pipleline register for Native interface
    localparam  ENABLE_TX_PIPELINE = 1 ;
    localparam  ENABLE_RX_PIPELINE = 1 ; // note, need to adjust rpcs EARLY_REQ if turning off pipeline

    // calc LFT delay (not done in hw.tcl for 40g)
    localparam LFT_CALC = (LINK_TIMER_KR*MGMT_CLK_IN_KHZ)/1000;
    localparam LFT_R_MSB     = LFT_CALC/1000;              // Link Fail Timer MSB for BASE-R PCS
    localparam LFT_R_LSB     = LFT_CALC - LFT_R_MSB*1000;  // Link Fail Timer lsb for BASE-R PCS

    // Combine parameters for easier reading
    localparam  SYNTH_AN_LT = SYNTH_AN || SYNTH_LT ;
    localparam  REF_CLK_644  = (REF_CLK_FREQ_10G == "322.265625 MHz") ? 0 : 1 ;
        
    //****************************************************************************
    // Define Wires and Variables
    //****************************************************************************
    // for SEQ
    wire         seq_restart_an;        // sequencer reset of the AN
    wire         seq_restart_lt;        // sequencer reset of the LT
    wire [65:0]  an_data;               // raw data from AN.  bit-0 first
    reg  [32*LANES-1:0]  lt_data = 0;   // raw data from LT.  bit-0 first
    wire [LANES-1:0]   rx_10g_bitslip;  // sig the PMA to slip the datastream
    wire [2:0]   par_det;
    wire         load_pdet;
    wire [1:0]   data_mux_sel;          // select data input to native PHY
                                        // 00 = AN, 01 = LT, 10 = data
    wire         fec_enable;
    wire         fec_request;
    wire         csr_seq_restart;   // re-start the sequencer
    wire [3:0]   force_mode;        // Force the Hard PHY into a mode
                                    // 0000 = no force,  001 = GigE mode
                                    // 0010 = XAUI mode, 100 = 10G-R mode
                                    // 0101 = kr, 40G, 100G
                                    // 1100 = 40G KR FEC mode
    wire         dis_lf_timer;      // disable the link_fail_inhibit_timer
    wire         dis_an_timer;      // disable AN timeout.  can get stuck
                                    // stuck in ABILITY_DETECT - if rmt not AN
                                    // stuck in ACKNOWLEDGE_DETECT - if loopback
    wire         dis_max_wait_tmr;  // disable the LT max_wait_timer
    wire [LANES-1:0] training;      // Link Training in progress
    wire         link_ready;        // link is ready
    wire         seq_an_timeout;    // AN timed-out in Sequencer SM
    wire         seq_lt_timeout;    // LT timed-out in Sequencer SM
    wire         lt_enable;         // Enable LT
    wire         en_usr_np;         // Enable user next pages
    wire         lt_fail_response;  // go to data-mode if LT-fails if this bit is 1
    wire         pcs_link_sts;      // PCS link status from Hard PHY
    wire         lanes_deskew_sync; // lanes_deskewed synched to clk_status domain
    wire         fail_lt_if_ber;    // if last LT measurement is non-zero, treat as a failed run
    wire [LANES-1:0] sync_trn_fail; // synchronized Training timed-out
    // for LT
    wire [(LANES*2)-1:0] last_dfe_mode;  // Last dfe_mode setting sent to reconfig bundle in SV
    wire [(LANES*4)-1:0] last_ctle_rc;   // Last ctle_rc setting sent to reconfig bundle in SV
    wire [(LANES*2)-1:0] last_ctle_mode; // Last ctle_mode setting sent to reconfig bundle in SV
    wire [LANES-1:0] lt_start_rc;      // start the TX EQ reconfig
    wire [(LANES*3)-1:0] tap_to_upd;       // specific TX EQ tap to update
                                    // bit-2 = main, bit-1 = post, ...
    wire [(LANES*MAINTAPWIDTH)-1:0] main_rc; // main tap value for reconfig
    wire [(LANES*POSTTAPWIDTH)-1:0] post_rc; // post tap value for reconfig
    wire [(LANES*PRETAPWIDTH)-1:0]  pre_rc;  // pre tap value for reconfig
    wire [LANES-1:0] seq_start_rc;   // start the PCS reconfig
    wire [5:0]       pcs_mode_rc;    // PCS mode for reconfig - 1 hot
                                    // bit 0 = AN mode = low_lat, PLL LTR
                                    // bit 1 = LT mode = low_lat, PLL LTD
                                    // bit 2 = 40G data mode = 40GBASE-KR4
                                    // bit 3 = GigE data mode = 8G PCS
                                    // bit 4 = XAUI data mode = future?
                                    // bit 5 = 40G-FEC 
                                    
    // for AVMM to/from channel
    wire         chnl_rcfg_read;
    wire [11:0]  chnl_rcfg_address;
    wire         chnl_rcfg_write;
    wire [31:0]  chnl_rcfg_wrdata;
    wire         chnl_rcfg_waitrequest;

    // for AVMM from CPU
    wire         cpu_avmm_read;
    wire [12:0]  cpu_avmm_addr;
    wire         cpu_avmm_write;
    wire [31:0]  cpu_avmm_wrdata;
    wire         cpu_avmm_active;
    assign cpu_avmm_active = cpu_avmm_read | cpu_avmm_write;
                                    
    // for PHY
    wire [LANES-1:0]   rx_set_locktodata;
    wire [LANES-1:0]   rx_set_locktoref;
    wire [LANES-1:0]   rx_is_lockedtoref;
    wire [LANES-1:0]   rx_is_lockedtodata;
    wire [(LANES*128)-1:0] tx_parallel_data;
    wire [(LANES*128)-1:0] rx_parallel_data;
    wire [LANES-1:0]   tx_10g_clkout;
    wire [LANES-1:0]   rx_10g_clkout;
    wire [(LANES*18)-1:0]  tx_10g_control;
    wire [(LANES*20)-1:0]  rx_10g_control;
    wire [LANES-1:0]   tx_cal_busy;
    wire [LANES-1:0]   rx_cal_busy;
    wire [LANES-1:0]   tx_enh_data_valid;
    reg  [LANES-1:0]   tx_enh_data_valid_to_pcs;
    reg  [LANES-1:0]   rx_pempty_r;
    reg  [LANES-1:0]   rx_pempty_r_neg_coreclk /* synthesis keep */;
    
    
    // for AN
    wire [LANES-1:0] an_chan_sel;    // AN channel selection 0-3 (one-hot)
    wire         link_good;          // AN completed
    wire         an_rx_idle;         // RX SM in idle state - from RX_CLK
    wire         enable_fec;         // Enable FEC for the channel
    wire         in_ability_det;     // ARB SM in the ABILITY_DETECT state
    wire         an_enable;          // enable AN
    wire [24:0]  lp_tech;            // LP Technology ability = D45:21
    wire [1:0]   lp_fec;             // LP FEC ability = D47:46  output reg
    wire [31:0]  top_mgmt_readdata;  // read data from the SEQ/TOP CSR
    wire [31:0]  an_mgmt_readdata;   // read data from the AN CSR module
    wire [31:0]  lt_mgmt_readdata;   // read data from the LT CSR module
    wire [(LANES*32)-1:0] fec_mgmt_readdata; // read data from FEC CSR modules
    wire [5:0]   fnl_an_tech;        // final AN_TECH parameter
    wire [1:0]   fnl_an_fec;         // final the AN_FEC parameter
    wire [2:0]   fnl_an_pause;       // final the AN_PAUSE parameter
        
    wire [(LANES*66)-1:0] tx_parallel_data_66, tx_parallel_data_66_r, rx_parallel_data_66_prenav;
    reg  [(LANES*66)-1:0] tx_parallel_data_66_postnav, rx_parallel_data_66;
    
    wire seq_rc_busy;
    wire [LANES-1:0] rc_busy;

    // HSSI signals sync'ed on mgmt-clk
    wire [LANES-1:0]    rx_analogreset_ack_hssi;
    wire [LANES-1:0]    tx_analogreset_ack_hssi;
    wire [LANES-1:0]    rx_cal_busy_hssi;
    wire [LANES-1:0]    tx_cal_busy_hssi;
    wire [LANES-1:0]    rx_is_lockedtodata_hssi;
    wire [LANES-1:0]    rx_is_lockedtoref_hssi;
    // LT signals sync'ed on mgmt-clk
    wire [LANES-1:0]    frame_lock_lt_clk;
    wire [6*LANES-1:0]  rmt_coef_sts_lt_clk;

    genvar i;

    //****************************************************************************
    // Instantiate the Sequencer module
    //****************************************************************************
    generate
        if (SYNTH_SEQ) begin: SEQ_GEN
            wire seq_reset;
            wire seq_start_rc_i;

            
            alt_aeu_40_seqa10_sm  #(
                .LFT_R_MSB    (LFT_R_MSB),
                .LFT_R_LSB    (LFT_R_LSB)
            ) SEQUENCER (
                .rstn       (~seq_reset),
                .clk        (clk_status),
                .restart    (csr_seq_restart),
                .an_enable  (an_enable),
                .lt_enable  (lt_enable),
                .frce_mode  (force_mode[2:0]),
                .dis_max_wait_tmr (dis_max_wait_tmr),
                .dis_lf_timer  (dis_lf_timer),
                .dis_an_timer  (dis_an_timer),
                .en_usr_np     (en_usr_np), 
                .pcs_link_sts  (pcs_link_sts),
                .ber_zero      (1'b0),
                .lt_fail_response(lt_fail_response),
                .training_fail (|sync_trn_fail),
                .fail_lt_if_ber(fail_lt_if_ber),
                .link_ready    (link_ready),
                .seq_an_timeout(seq_an_timeout),
                .seq_lt_timeout(seq_lt_timeout),
                .enable_fec    (enable_fec),
                .data_mux_sel  (data_mux_sel),
                // to/from Auto-Negotiation
                .lcl_tech       ({fnl_an_tech[5],(fnl_an_tech[4:3] | {2{force_mode[3]}}),fnl_an_tech[2:0]}),
                .lcl_fec        (({fnl_an_fec[1],fnl_an_fec[0]} | {2{force_mode[3]}})),
                .link_good      (link_good),
                .in_ability_det (in_ability_det),
                .an_rx_idle     (an_rx_idle),
                .lp_tech     ({lp_tech[5],(lp_tech[4:3] | {2{force_mode[3]}}),lp_tech[2:0]}),
                .lp_fec      (lp_fec | {2{force_mode[3]}}),
                .load_pdet   (load_pdet),
                .par_det     (par_det),
                .restart_an  (seq_restart_an),
                // to/from Link Training
                .training    (|training),
                .restart_lt  (seq_restart_lt),
                // to/from reconfig
                .rc_busy     (seq_rc_busy),
                .start_rc    (seq_start_rc_i),
                .pcs_mode_rc (pcs_mode_rc)
            );
            
            // distribute sequencer reco requests across n lanes
            alt_aeu_40_seq_reco_n #(
                .LANES(LANES)
            ) seq_reco_n (
                .clk(clk_status),
                .rst(seq_reset),
                // SEQ interface
                .seq_start_rc(seq_start_rc_i),
                .seq_rc_busy(seq_rc_busy), 
                // reco interface
                .reco_start_rc(seq_start_rc),
                .reco_rc_busy(rc_busy)
            );
            
            alt_xcvr_resync #(
                .SYNC_CHAIN_LENGTH(2),  // Number of flip-flops for retiming
                .WIDTH            (1),  // Number of bits to resync
                .INIT_VALUE       (1)
            ) seq_resync_reset (
                .clk    (clk_status),
                .reset  (usr_seq_reset),
                .d      (1'b0),
                .q      (seq_reset)
            );
        end  // if synth_seq
        else begin: NO_SEQ_GEN  // need to drive outputs if no SEQ module
            assign pcs_mode_rc   = SYNTH_AN ? 6'b000001 : // AN mode
                                   SYNTH_LT ? 6'b000010 : // LT mode
                                   enable_fec ? 6'b100000 : // 40G FEC mode
                                   6'b000100; // 40G data mode
            assign seq_start_rc  = 4'b0;
            assign seq_restart_lt = 1'b0;
            assign seq_restart_an = 1'b0;
            assign data_mux_sel   = SYNTH_AN ? 2'b00 : // AN mode
                                    SYNTH_LT ? 2'b01 : // LT mode
                                    2'b10;  // data mode
            assign enable_fec     = &fnl_an_fec;
            assign seq_an_timeout = 1'b0;
            assign seq_lt_timeout = 1'b0;
            assign link_ready     = lanes_deskew_sync;
            assign seq_rc_busy    = 1'b0;
        end // else synth_seq
    endgenerate
    
    alt_aeu_40_status_sync #(
        .WIDTH(1)
    ) sync_deskew (
        .clk(clk_status),
        .din(lanes_deskewed),
        .dout(lanes_deskew_sync)
    );
    
    wire  [LANES-1:0] reset_controller_tx_ready;
    wire  [LANES-1:0] reset_controller_rx_ready;

    //****************************************************************************
    // Instantiate the AN module
    // also have the AN CSRs and test logic
    //****************************************************************************
    generate
        if (SYNTH_AN) begin: AN_GEN
            wire tx_an_reset, rx_an_reset;
            wire tx_an_clk, rx_an_clk;
            wire [65:0] rx_parallel_data_an;
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
            wire         an_chan_ovrd;
            wire [LANES-1:0] an_chan_ovrd_sel;

            alt_aeu_40_an_top #(
                .PCNTWIDTH    (4),
                .AN_SELECTOR  (AN_SELECTOR)
            ) AUTO_NEG (
                .AN_PAUSE     (fnl_an_pause),
                .AN_TECH      (fnl_an_tech),
                .AN_FEC       (fnl_an_fec),
                .tx_rstn      (~tx_an_reset), 
                .tx_clk       (tx_an_clk), 
                .rx_rstn      (~rx_an_reset), 
                .rx_clk       (rx_an_clk), 
                .an_enable    (an_enable), 
                .an_restart   (an_restart | seq_restart_an),
                .restart_txsm (restart_txsm),
                .lcl_rf       (csr_lcl_rf),
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
                .lp_tech         (lp_tech),
                .lp_fec          (lp_fec),
                .an_pg_received  (an_pg_received),
                .lp_base_pg      (lp_base_pg),
                .lp_next_pg      (lp_next_pg),
                .usr_np_sent     (usr_np_sent), // unused
                .load_pdet       (load_pdet), 
                .par_det         (par_det),
                 // data
                .dme_in       (rx_parallel_data_an),
                .inj_err      (an_inj_err), 
                .dme_out      (an_data)
            );

            // instantiate the AN registers at address 0xC0 - 0xCF
            alt_aeu_40_csr_kran  csr_kran_inst (
                .clk        (clk_status        ),
                .reset      (pma_arst          ),
                .address    (status_addr     ),
                .read       (status_read     ),
                .readdata   (an_mgmt_readdata  ),
                .write      (status_write    ),
                .writedata  (status_writedata),
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
                .an_link_ready    ({1'd0,{2{(pcs_mode_rc[5]|pcs_mode_rc[2])&link_ready}} 
                                         & {AN_TECH[4],~AN_TECH[4]},3'b0}),
                .lp_base_pg   (lp_base_pg),
                .lp_next_pg   (lp_next_pg),
                .lp_tech      (lp_tech),
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
                .an_tm_enable     (an_tm_enable),   // unused
                .an_tm_err_mode   (an_tm_err_mode), // unused
                .an_tm_err_trig   (an_tm_err_trig), // unused
                .an_tm_err_time   (an_tm_err_time), // unused
                .an_tm_err_cnt    (an_tm_err_cnt),  // unused
                .an_chan_ovrd     (an_chan_ovrd),
                .an_chan_ovrd_sel (an_chan_ovrd_sel)
            );

               // Override the AN Parameters
            assign fnl_an_tech  = en_an_param_ovrd ? ovrd_an_tech  : AN_TECH[5:0];
            assign fnl_an_fec   = en_an_param_ovrd ? ovrd_an_fec   : {fec_request, fec_enable};
            assign fnl_an_pause = en_an_param_ovrd ? ovrd_an_pause : AN_PAUSE[2:0];

               // instantiate the AN Test mode logic here
            //assign tm_out_trigger[3:2] = 2'd0;
            assign an_inj_err          = 4'd0;

            alt_xcvr_resync #(
                .SYNC_CHAIN_LENGTH(2),  // Number of flip-flops for retiming
                .WIDTH            (1),  // Number of bits to resync
                .INIT_VALUE       (1)
            ) tx_ansync_reset (
                .clk    (tx_an_clk),
                .reset  (usr_an_lt_reset |
                         an_chan_sel[0] & !(reset_controller_tx_ready[0] & pcs_mode_rc[0]) |
                         an_chan_sel[1] & !(reset_controller_tx_ready[1] & pcs_mode_rc[0]) |
                         an_chan_sel[2] & !(reset_controller_tx_ready[2] & pcs_mode_rc[0]) |
                         an_chan_sel[3] & !(reset_controller_tx_ready[3] & pcs_mode_rc[0]) ),
                .d      (1'b0),
                .q      (tx_an_reset)
            );
            
            alt_xcvr_resync #(
                .SYNC_CHAIN_LENGTH(2),  // Number of flip-flops for retiming
                .WIDTH            (1),  // Number of bits to resync
                .INIT_VALUE       (1)
            ) rx_ansync_reset (
                .clk    (rx_an_clk),
                .reset  (usr_an_lt_reset |
                         an_chan_sel[0] & !(reset_controller_rx_ready[0] & pcs_mode_rc[0]) |
                         an_chan_sel[1] & !(reset_controller_rx_ready[1] & pcs_mode_rc[0]) |
                         an_chan_sel[2] & !(reset_controller_rx_ready[2] & pcs_mode_rc[0]) |
                         an_chan_sel[3] & !(reset_controller_rx_ready[3] & pcs_mode_rc[0]) ),
                .d      (1'b0),
                .q      (rx_an_reset)
            );
           
           // disable clock-Mux and use CH2 clock-out
	    assign tx_an_clk   = tx_10g_clk33out[2];
	    assign rx_an_clk   = rx_10g_clk33out[2];

            assign rx_parallel_data_an = (an_chan_sel[3] ? rx_parallel_data_66[66*3 +: 66] : 66'b0) |
                                         (an_chan_sel[2] ? rx_parallel_data_66[66*2 +: 66] : 66'b0) |
                                         (an_chan_sel[1] ? rx_parallel_data_66[66*1 +: 66] : 66'b0) |
                                         (an_chan_sel[0] ? rx_parallel_data_66[66*0 +: 66] : 66'b0);

            assign an_chan_sel    = an_chan_ovrd ? an_chan_ovrd_sel : AN_CHAN[3:0];

        end  // if synth_an
        else begin: NO_AN_GEN  // need to drive outputs if no AN module
            assign an_chan_sel    = AN_CHAN[3:0];
            assign link_good      = 1'b0;
            assign in_ability_det = 1'b0;
            assign an_rx_idle     = 1'b1;
            assign an_enable      = 1'b0;
            assign en_usr_np      = 1'b0;
            assign load_pdet      = 1'b0;
            //assign tm_out_trigger[3:2] = 2'd0;
            assign par_det = 3'd0;
            assign lp_tech = AN_TECH[5:0];
            assign lp_fec  = fnl_an_fec;
            assign an_data = 66'd0;
            assign an_mgmt_readdata = 32'd0;
            assign fnl_an_tech  = AN_TECH[5:0];
            assign fnl_an_fec   = {fec_request, fec_enable};
            assign fnl_an_pause = AN_PAUSE[2:0];
        end  // else synth_an
    endgenerate
    
    wire [LANES-1:0] dis_tx_data;
    wire [LANES-1:0] rmt_upd_new;
    wire [5:0] rmt_coef_updl; // shared between all lanes, rmt_upd_new specifies update
    wire [1:0] rmt_coef_updh;
    wire [6*LANES-1:0] rmt_coef_sts;
    wire [BERWIDTH*LANES-1:0] ber_cnt;
    wire [LANES-1:0] bert_done;
    wire [LANES-1:0] ber_max;
    wire [LANES-1:0] clear_ber;
    
    
    reg [LANES-1:0] frame_lock_filt;
    wire [LANES-1:0] frame_lock;
    wire [LANES-1:0] lcl_upd_new;
    wire [LANES-1:0] lcl_upd_new_int;
    
    //****************************************************************************
    // Instantiate the LT module
    // also have the LT CSRs and test logic
    //****************************************************************************
    
       // signals between LT and CSRs
    wire [LANES-1:0] csr_restart_lt;    // re-start the LT process
    wire [(LANES*10)-1:0] sim_ber_t;// Time(frames) to cnt when ber_time=0
    wire [(LANES*10)-1:0] ber_time; // Time(K-frames) to count BER Errors
    wire [(LANES*10)-1:0] ber_ext;  // Extend(M-frames) Time to count BER
    wire [LANES-1:0] training_fail; // Training timed-out
    wire [LANES-1:0] training_error; // Training timed-out
    wire [LANES-1:0] train_lock_err; // Training timed-out
    wire [LANES-1:0] nolock_rxeq; // Training timed-out
    wire [LANES-1:0] fail_ctle; // Training timed-out
    wire [LANES-1:0] rx_trained;// rx_trained status to CSR
    wire [(LANES*8)-1:0] lcl_txi_update;// Local coef update bits to TX
    wire [LANES-1:0] lcl_tx_upd_new;    // Local coef update new
    wire [(LANES*7)-1:0] lcl_txi_status;// Local status bits to transmit
    wire [LANES-1:0] lcl_sts_new;   // Local coef status new
    wire [(LANES*8)-1:0] lp_rxi_update; // Override coef update bits to CSR
    wire         ovrd_lp_coef;      // Override LP TX update enable
    wire [(LANES*8)-1:0] lp_txo_update; // Override LP TX update bits  
    wire [LANES-1:0] lp_tx_upd_new; // Override LP TX update new   
    wire [(LANES*7)-1:0] lp_rxi_status;
    wire         ovrd_coef_rx;      // Override lcl coef update enable
    wire [(LANES*8)-1:0] lcl_rxo_update;// Override lcl coef update bits from CSR
    wire [LANES-1:0] ovrd_rx_new;   // Override lcl coef update new
    wire [4*(2*MAINTAPWIDTH+POSTTAPWIDTH+PRETAPWIDTH+4)-1:0]  param_ovrd;
    wire         dis_init_pma;      // disable initialize PMA on timeout
    wire         lt_tm_enable;      // LT test mode enable
    wire [3:0]   lt_inj_err;        // inject errors into the LT TX data
    wire [3:0]   lt_tm_err_mode;
    wire [3:0]   lt_tm_err_trig;
    wire [7:0]   lt_tm_err_time;
    wire [7:0]   lt_tm_err_cnt;
    wire         use_full_time;    
    
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
    wire [11:0]  lt_d1;
    // wire [1:0]   dfe_extra;
    wire         only_inc_main;
    //wire [2:0]   ctle_bias;
    //wire         dec_post;
    //wire         dec_post_more;
    //wire         ctle_pass_ber;
    wire [LANES-1:0] clr_ltd_ok_1ms;
    reg  [LANES-1:0] ltd_ok_1ms;
//****************************************************************************
// Instantiate the LT Receive remote TX EQ Optimization SM
// Implemented in a CPU for 14.0
//****************************************************************************
    generate
        if (SYNTH_LT) begin: LT_GEN_CPU
            wire [14-BERWIDTH:0] ber_extnd = 'd0;  // 0 extend the ber_cnt to 15 bits
            wire [LANES-1:0] sync_dis_data;        // synchronized dis_tx_data
            wire cpu_burstcount;          // un-used output
            wire cpu_debugaccess;         // un-used output
            wire [3:0] cpu_byteenable;    // un-used output
            reg wait_req_dly = 0;         // to create read data vailid
            wire cpu_readdatavalid;       // read data valid input to cpu
            
            wire [(LANES*3-1):0]  cpu_enable;
            wire [(LANES*16-1):0] cpu_ber_in;
            wire [(LANES*5-1):0]  cpu_training_sts;
            wire [(LANES*9-1):0]  cpu_rxeq_sts;
            
            wire [LANES-1:0] en_frame_lock_filt;
            
            always @(posedge clk_status) begin
                frame_lock_filt <= frame_lock | (frame_lock_filt & en_frame_lock_filt);
            end
            
            // distribute signals for lanes
            for (i=0; i<LANES; i=i+1) 
            begin : lane_gen
                assign cpu_enable[i*3 +: 3] = { frame_lock[i],
                                                csr_restart_lt[i] | seq_restart_lt,
                                                lt_enable & ~sync_dis_data[i] & ~sync_trn_fail[i] };
                assign cpu_ber_in[i*16 +: 16] = { ber_max[i],
                                                  ber_extnd,
                                                  ber_cnt[i*BERWIDTH +: BERWIDTH] };
                         
                assign { nolock_rxeq[i],
                         train_lock_err[i],
                         training_error[i],
                         rx_trained[i],
                         en_frame_lock_filt[i] } = cpu_training_sts[i*5 +: 5];
                         
                assign { fail_ctle[i],
                         last_dfe_mode[i*2 +: 2],
                         last_ctle_rc[i*4 +: 4],
                         last_ctle_mode[i*2 +: 2] } = cpu_rxeq_sts[i*9 +: 9];
            
            end
            
            wire [31:0]  cpu_readdata;
            reg [31:0] fake_d0;
            reg [31:0] fake_d1;

            reg cpu_reset;
            // Do not reset CPU on in seq_start_rc -- CPU needs time to boot up 
            // since sim timeouts are shorter, retarting CPU on seq_start_rc will cause timeout   
            `ifdef ALTERA_RESERVED_QIS
              always @ (posedge clk_status )
                cpu_reset <= ~(pma_arst | usr_an_lt_reset | (|seq_start_rc && pcs_mode_rc[1]) );
            `else
              always @ (posedge clk_status )
                cpu_reset <= ~(pma_arst | usr_an_lt_reset);
            `endif

       // define for the CPU connections
`define ALTERA_XCVR_KR_CPU_PORT_MAPPING  (         \
                .clk_clk             ( clk_status          ),  \
                .reset_reset_n       (cpu_reset),  \
                /* PIO Inputs */                           \
                .enable_export       (cpu_enable),  \
                .rmt_sts_new_export  (lcl_upd_new        ),  \
                .rmt_sts_export      (rmt_coef_sts       ),  \
                .bert_done_export    (bert_done          ),  \
                .ber_in_0_export     (cpu_ber_in[15:0]),  \
                .ber_in_1_export     (cpu_ber_in[31:16]),  \
                .ber_in_2_export     (cpu_ber_in[47:32]),  \
                .ber_in_3_export     (cpu_ber_in[63:48]),  \
                /* PIO Outputs */                          \
                .clear_ber_export    (clear_ber          ),  \
                .rmt_cmd_new_export  (rmt_upd_new        ),  \
                .rmt_cmd_export      ({ rmt_coef_updh,       \
                                        rmt_coef_updl}   ),  \
                .training_sts_export (cpu_training_sts),  \
                .rxeq_sts_0_export   (cpu_rxeq_sts[8:0]),  \
                .rxeq_sts_1_export   (cpu_rxeq_sts[17:9]),  \
                .rxeq_sts_2_export   (cpu_rxeq_sts[26:18]),  \
                .rxeq_sts_3_export   (cpu_rxeq_sts[35:27]),  \
                .ber_zero_export     (clr_ltd_ok_1ms),  \
                /* AVMM Master */                          \
                .avmm_waitrequest    (|rc_busy | chnl_rcfg_waitrequest | \
                                     (~cpu_avmm_active & |lt_start_rc)), \
                .avmm_readdata       (cpu_readdata),        \
                .avmm_readdatavalid  (cpu_readdatavalid),    \
                .avmm_burstcount     (cpu_burstcount),       \
                .avmm_writedata      (cpu_avmm_wrdata),      \
                .avmm_address        (cpu_avmm_addr),        \
                .avmm_write          (cpu_avmm_write),       \
                .avmm_read           (cpu_avmm_read),        \
                .avmm_byteenable     (cpu_byteenable),       \
                .avmm_debugaccess    (cpu_debugaccess)       \
            );
            
            // fake reading from lt settings register when at 0x1000
            assign cpu_readdata = cpu_avmm_addr[12] ? 
                                  (cpu_avmm_addr[0] ? fake_d1 : fake_d0) : reconfig_readdata;
            
            always @(*) begin
                fake_d0 = 0;
                
                fake_d0[0]     =  lt_enable       ;
                fake_d0[1]     =  dis_max_wait_tmr;
                fake_d0[2]     =  quick_mode      ;
                fake_d0[3]     =  pass_one        ;
                fake_d0[7:4]   =  main_step_cnt   ;
                fake_d0[11:8]  =  prpo_step_cnt   ;
                fake_d0[14:12] =  equal_cnt       ;
                fake_d0[15]    =  dis_init_pma    ;
                fake_d0[16]    =  ovrd_lp_coef    ;
                fake_d0[17]    =  ovrd_coef_rx    ;
                fake_d0[19:18] =  ctle_depth      ;
                fake_d0[22:20] =  rx_ctle_mode    ;
                fake_d0[23]    =  only_inc_main   ;
                fake_d0[26:24] =  rx_dfe_mode     ;
                fake_d0[27]    =  fixed_mode      ;
                fake_d0[28]    =  max_mode        ;
                fake_d0[31:29] =  max_post_step   ;
                
                fake_d1 = 0;
                fake_d1[3:0]   = ltd_ok_1ms        ;
                fake_d1[23:12] = lt_d1             ;
                fake_d1[24]    = use_full_time     ;
            end

            // CPU variants
            if (USE_DEBUG_CPU) begin : DEBUG_CPU
                kr4a10_debug_cpu   kr4a10_debug_cpu_inst
                `ALTERA_XCVR_KR_CPU_PORT_MAPPING
            end else begin : LT_CPU
                kr4a10_cpu   kr4a10_cpu_inst
                `ALTERA_XCVR_KR_CPU_PORT_MAPPING
            end

            // instantiate the reset synchronizers for the CPU module
            //  \p4\ip\altera_xcvr_generic\ctrl\alt_xcvr_resync.sv
            alt_xcvr_resync #(
                .WIDTH  (2*LANES)       // Number of bits to resync
            ) mgmt_resync_reset (
                .clk    (clk_status),
                .reset  (pma_arst),
                .d      ({dis_tx_data,   training_fail}),
                .q      ({sync_dis_data, sync_trn_fail})
            );

            wire fake_waitrequest = cpu_avmm_read & cpu_avmm_addr[12] & ~wait_req_dly;
            wire eff_waitrequest = cpu_avmm_addr[12] ? fake_waitrequest : chnl_rcfg_waitrequest & ~|rc_busy;

            // Generate the CPU read data valid from falling edge of wait request
            always @(posedge clk_status) begin
                wait_req_dly <= eff_waitrequest & cpu_avmm_read;
            end
            assign cpu_readdatavalid = wait_req_dly & ~eff_waitrequest;
        end  // if synth_lt
        else begin: NO_LT_GEN_CPU   // need to drive outputs if no LT module
            assign training_error   = 4'b0;
            assign train_lock_err   = 4'b0;
            assign last_dfe_mode    = 0;
            assign last_ctle_rc     = 0;
            assign last_ctle_mode   = 0;
            assign rmt_upd_new      = 4'b0;
            assign rmt_coef_updl    = 0;
            assign rmt_coef_updh    = 0;
            assign nolock_rxeq      = 4'b0;
            assign fail_ctle        = 4'b0;
            assign clr_ltd_ok_1ms   = 4'b0;
            assign cpu_avmm_read   = 1'b0;
            assign cpu_avmm_write  = 1'b0;
            assign cpu_avmm_addr   = 'd0;
            assign cpu_avmm_wrdata = 'd0;
            assign sync_trn_fail = 4'b0;
        end  // else synth_lt
    endgenerate
      
    generate
        if (SYNTH_LT) begin: LT_GEN_CSR
        
            // instantiate the LT registers at address 0xD0 - 0xDF
            alt_aeu_40_csr_kra10lt #(
                .ES_DEVICE    (ES_DEVICE),
                .MAINTAPWIDTH (MAINTAPWIDTH),
                .POSTTAPWIDTH (POSTTAPWIDTH),
                .PRETAPWIDTH  (PRETAPWIDTH)
            ) csr_krlt_inst (
                .clk        (clk_status        ),
                .reset      (pma_arst          ),
                .address    (status_addr     ),
                .read       (status_read     ),
                .readdata   (lt_mgmt_readdata  ),
                .write      (status_write    ),
                .writedata  (status_writedata),
                //status inputs to this CSR
                .pcs_mode_rc    (pcs_mode_rc),
                .rx_trained    (rx_trained),
                .lt_frame_lock (frame_lock),
                .training      (training), 
                .training_fail (training_fail), 
                .training_error(training_error),
                .train_lock_err  (train_lock_err),
                .lcl_txi_update  (lcl_txi_update),
                .lcl_tx_upd_new  (lcl_tx_upd_new),
                .lcl_txi_status  (lcl_txi_status),
                .lcl_tx_stat_new (lcl_sts_new),
                .lp_rxi_update   (lp_rxi_update),
                .lp_rx_upd_new   (lcl_upd_new_int),
                .lp_rxi_status   (lp_rxi_status),
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
                .lt_d1         (lt_d1),
                .only_inc_main (only_inc_main),
                .use_full_time (use_full_time),
                .csr_reset_lt (csr_restart_lt),
                .ber_time     (sim_ber_t), 
                .ber_k_time   (ber_time),
                .ber_m_time   (ber_ext),
                .lcl_txo_update (lp_txo_update),
                .lp_tx_upd_new  (lp_tx_upd_new),
                .lcl_rxo_update (lcl_rxo_update),
                .ovrd_rx_new    (ovrd_rx_new),
                .param_ovrd     (param_ovrd),
                .lt_tm_enable   (lt_tm_enable),   // unused
                .lt_tm_err_mode (lt_tm_err_mode), // unused
                .lt_tm_err_trig (lt_tm_err_trig), // unused
                .lt_tm_err_time (lt_tm_err_time), // unused
                .lt_tm_err_cnt  (lt_tm_err_cnt)   // unused
            );

            // instantiate the LT Test mode logic here
            //assign tm_out_trigger[1:0] = 2'd0;
            assign lt_inj_err          = 4'd0;

        end  // if synth_lt
        else begin: NO_LT_GEN_CSR   // need to drive outputs if no LT module
            assign lt_enable        = 1'b0;
            assign dis_max_wait_tmr = 1'b0;
            assign dis_init_pma     = 1'b0;
            assign ovrd_lp_coef     = 1'b0;
            assign ovrd_coef_rx     = 1'b0;
            assign use_full_time    = 1'b0;
            assign csr_restart_lt       = 3'b0;
            assign sim_ber_t        = 40'b0;
            assign ber_time         = 40'b0;
            assign ber_ext          = 40'b0;
            assign lp_txo_update    = 32'b0;
            assign lp_tx_upd_new    = 4'b0;
            assign lcl_rxo_update   = 32'b0;
            assign ovrd_rx_new      = 4'b0;
            assign param_ovrd       = 0;
            assign lt_tm_enable     = 1'b0;
            assign lt_tm_err_mode   = 4'b0;
            assign lt_tm_err_trig   = 4'b0;
            assign lt_tm_err_time   = 8'b0;
            assign lt_tm_err_cnt    = 8'b0;
            //assign tm_out_trigger[1:0] = 2'd0;
            assign lt_inj_err       = 4'd0;
            assign lt_mgmt_readdata = 32'd0;
            assign quick_mode = 0;  
            assign pass_one = 0;  
            assign main_step_cnt = 0;  
            assign prpo_step_cnt = 0;  
            assign equal_cnt = 0;  
            assign rx_ctle_mode = 0;  
            assign rx_dfe_mode = 0;  
            assign max_mode = 0;  
            assign fixed_mode = 0;  
            assign max_post_step = 0;  
            assign ctle_depth = 0;
            assign lt_d1 = 0;
            assign only_inc_main = 0;  
        end  // else synth_lt
    endgenerate

                              
    //****************************************************************************
    // Instantiate KR4 Lanes (data/LT)
    //****************************************************************************
    
    wire [LANES-1:0] clr_errblk_cnt;
    reg [LANES-1:0] fec_tx_err_ins_pulse = 0;
    reg [LANES-1:0] fec_tx_err_ins_pulse_r = 0;
    
    generate
        for (i=0; i<LANES; i=i+1) 
        begin : lane_gen
            if (SYNTH_LT) begin: LT_GEN
            
                wire [31:0] lt_data_n;
                reg [31:0] lt_data_n1 /* synthesis keep */;
                reg [31:0] rx_lt_data_n, rx_lt_data_n1 /* synthesis keep */;
                //Added LCELL Buffer delay(by using synthesis keep) to reduce Hold wire added by fitter

                wire [31:0] lt_data_n_delay1, lt_data_n_delay2, lt_data_n_delay /* synthesis keep */;

                assign lt_data_n_delay1 = lt_data_n1;
                assign lt_data_n_delay2 = lt_data_n_delay1;
                assign lt_data_n_delay = lt_data_n_delay2;                
                // for timing closure/clock skew

                always @(posedge tx_10g_clkout[i]) begin
                    lt_data_n1 <= lt_data_n;
                end
                
                always @(posedge tx_10g_coreclkin[i]) begin
                    lt_data[i*32 +: 32] <= lt_data_n_delay;
                end
                
                always @(posedge rx_10g_clkout[i]) begin
                    rx_lt_data_n <= rx_lt_data_n1;
                end
                
                always @(posedge rx_10g_coreclkin[i]) begin
                    rx_lt_data_n1 <= rx_parallel_data_66[i*66 +: 32];
                end
                
                //****************************************************************************
                // Instantiate the LT Local Coefficient Update module
                //****************************************************************************
            
                wire tx_lt_reset;
                wire rx_lt_reset;
                
                wire    training_reset;
                wire    train_reset_sync;
                wire    rmt_rx_ready;
                wire           lt_rc_active;
                wire           rmt_mux_new;
                wire [5:0]     rmt_mux_updl;
                wire [13:12]   rmt_mux_updh;
                wire [5:0]     lcl_coefl_int;
                wire [13:12]   lcl_coefh_int;
                wire [5:0]     lcl_coefl;
                wire [13:12]   lcl_coefh;
                wire [5:0]     lcl_coef_sts;
                wire           lcl_rx_ready;
                
                alt_xcvr_resync #(
                    .WIDTH  (1)       // Number of bits to resync
                ) train_sync_reset (
                    .clk    (clk_status),
                    .reset  (pma_arst),
                    .d      (training_reset),
                    .q      (train_reset_sync)
                );
                
                // Apply embedded false path timing constraints for LT
               `ifdef ALTERA_RESERVED_QIS
                 (* altera_attribute = SYNC_LTRX_CONSTRAINT *)
               `endif
                alt_aeu_40_lta10_lcl_coef #(
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
                    .rstn        (~(pma_arst | usr_an_lt_reset)),
                    .clk         (clk_status),
                    .lt_enable   (lt_enable & (data_mux_sel == 2'b01)),
                    .lt_restart  (csr_restart_lt[i] | seq_restart_lt | train_reset_sync),
                    .lcl_upd_new (lcl_upd_new[i]),
                    .lcl_coefl   (lcl_coefl),
                    .lcl_coefh   (lcl_coefh),
                    .param_ovrd(param_ovrd[(2*MAINTAPWIDTH+POSTTAPWIDTH+PRETAPWIDTH+4)*i
                                        +:2*MAINTAPWIDTH+POSTTAPWIDTH+PRETAPWIDTH+4]),
                    // for the reconfig Interface
                    .rc_busy     (rc_busy[i]),
                    .start_rc    (lt_start_rc[i]),
                    .main_rc(main_rc[i*MAINTAPWIDTH +: MAINTAPWIDTH]),
                    .post_rc(post_rc[i*POSTTAPWIDTH +: POSTTAPWIDTH]),
                    .pre_rc(pre_rc[i*PRETAPWIDTH +: PRETAPWIDTH]),
                    .tap_to_upd(tap_to_upd[i*3 +: 3]),
                     // outputs
                    .lt_rc_active (lt_rc_active),
                    .dis_tx_data  (dis_tx_data[i]),
                    .lcl_sts_new  (lcl_sts_new[i]),
                    .lcl_coef_sts (lcl_coef_sts)
                );
                
                //****************************************************************************
                // Instantiate the LT module
                //****************************************************************************
                
                alt_aeu_40_lta10_ultra_top #(
                    .BERWIDTH   (BERWIDTH),
                    .TRNWTWIDTH (TRNWTWIDTH),
                    .PRBS_SEED (1<<i)
                ) LINK_TRAIN (
                    .tx_rstn      (~tx_lt_reset),
                    .tx_clk       (tx_10g_clkout[i]), //322.3MHz clock
                    .rx_rstn      (~rx_lt_reset),
                    .rx_clk       (rx_10g_clkout[i]), //322.3MHz clock
                    .lt_enable    (lt_enable & (data_mux_sel == 2'b01)),
                    .lt_restart   (csr_restart_lt[i] | seq_restart_lt),
                    // data ports
                    .rx_data_in  (rx_lt_data_n),
                    .tx_data_out (lt_data_n),
                    .rx_bitslip  (rx_10g_bitslip[i]),
                    // outputs to CSR for status
                    .training(training[i]),
                    .training_fail(training_fail[i]),
                    .rx_trained      (rx_trained[i]),
                    // register bits for setting of operating mode
                    .sim_ber_t(sim_ber_t[i*10 +: 10]),
                    .ber_time       (ber_time[i*10 +: 10]),
                    .ber_ext        (ber_ext[i*10 +: 10]),
                    .dis_max_wait_tmr(dis_max_wait_tmr),
                    .dis_init_pma(dis_init_pma),
                    .inj_err        (lt_inj_err),
                    .use_full_time  (use_full_time),
                    .rxeq_done(1'b1),    // Should connect to CPU at some point
                     // for the re-partition
                    .training_reset   (training_reset),
                    .dis_tx_data      (dis_tx_data[i]),
                    .lt_rc_active     (lt_rc_active),
                    .rmt_upd_new    (rmt_mux_new),
                    .rmt_coef_updl  (rmt_mux_updl),
                    .rmt_coef_updh  (rmt_mux_updh),
                    .lcl_sts_new    (lcl_sts_new[i]),
                    .lcl_coef_sts   (lcl_coef_sts),
                    .lcl_upd_new    (lcl_upd_new_int[i]),  // mask for timeout
                    .lcl_coefl      (lcl_coefl_int),
                    .lcl_coefh      (lcl_coefh_int),
                    .rmt_rx_ready   (rmt_rx_ready),
                    .rmt_coef_sts   (rmt_coef_sts_lt_clk[i*6 +: 6]),
                    .lcl_rx_ready   (lcl_rx_ready),
                    .ber_cnt   (ber_cnt[i*BERWIDTH +: BERWIDTH]),
                    .ber_max   (ber_max[i]),
                    .bert_done (bert_done[i]),
                    .clear_ber       (clear_ber[i]),
                    .frame_lock_filt (frame_lock_filt[i]),
                    .frame_lock      (frame_lock_lt_clk[i])
                );
                
                // mux the remote TX update inputs for SW/CSR override
                assign rmt_mux_new  = ovrd_lp_coef ? lp_tx_upd_new[i]   : rmt_upd_new[i];
                assign rmt_mux_updl = ovrd_lp_coef ? lp_txo_update[i*8+0 +: 6] : rmt_coef_updl;
                assign rmt_mux_updh = ovrd_lp_coef ? lp_txo_update[i*8+6 +: 2] : rmt_coef_updh;

                // mux the inputs to the local update for SW/CSR override
                assign lcl_coefl = ovrd_coef_rx ? lcl_rxo_update[i*8+0 +: 6] : lcl_coefl_int;
                assign lcl_coefh = ovrd_coef_rx ? lcl_rxo_update[i*8+6 +: 2] : lcl_coefh_int;
                   // mask the local update for timout
                assign lcl_upd_new[i] = ovrd_coef_rx ? ovrd_rx_new[i]       :
                                                        lcl_upd_new_int[i] & ~training_fail[i];
               
                alt_xcvr_resync #(
                    .SYNC_CHAIN_LENGTH(2),  // Number of flip-flops for retiming
                    .WIDTH            (1),  // Number of bits to resync
                    .INIT_VALUE       (1)
                ) tx_resync_reset (
                    .clk    (tx_10g_clkout[i]),
                    .reset  (usr_an_lt_reset | 
                             !(reset_controller_tx_ready[i] & pcs_mode_rc[1]) ),
                    .d      (1'b0),
                    .q      (tx_lt_reset)
                );

                alt_xcvr_resync #(
                    .SYNC_CHAIN_LENGTH(2),  // Number of flip-flops for retiming
                    .WIDTH            (1),  // Number of bits to resync
                    .INIT_VALUE       (1)
                ) rx_resync_reset (
                    .clk    (rx_10g_clkout[i]),
                    .reset  (usr_an_lt_reset | 
                             !(reset_controller_rx_ready[i] & pcs_mode_rc[1]) ),
                    .d      (1'b0),
                    .q      (rx_lt_reset)
                );

                // sync frame_lock signal to mgmt-clk -- goes to CPU, CSR
                // sync signals from HSSI
                alt_xcvr_resync #(
                    .WIDTH  (7)       // Number of bits to resync
                ) frame_lck_sync (
                    .clk    (clk_status),
                    .reset  (pma_arst),
                    .d      ({rmt_coef_sts_lt_clk[i*6 +: 6],frame_lock_lt_clk[i]}),
                    .q      ({rmt_coef_sts[i*6 +: 6]       ,frame_lock[i]})
                );

                assign lcl_txi_update[i*8 +: 8]   = {rmt_mux_updh, rmt_mux_updl};
                assign lcl_tx_upd_new[i]   = rmt_mux_new;
                assign lcl_txi_status[i*7 +: 7]   = {lcl_rx_ready,  lcl_coef_sts};
                assign lp_rxi_update[i*8 +: 8]    = {lcl_coefh, lcl_coefl};
                assign lp_rxi_status[i*7 +: 7]    = {rmt_rx_ready, rmt_coef_sts[i*6 +: 6]};
                               
            end  // if synth_lt
            else begin: NO_LT_GEN   // need to drive outputs if no LT module   
                assign rx_10g_bitslip[i]   = 1'b0;
                assign training[i]         = 1'b0;
                assign training_fail[i]    = 1'b0;
                assign rx_trained[i]   = 1'b0;
                assign lcl_txi_update[i*8 +: 8]   = 8'd0;
                assign lcl_tx_upd_new[i]   = 1'b0;
                assign lcl_txi_status[i*7 +: 7]   = 7'd0;
                assign lp_rxi_update[i*8 +: 8]    = 8'd0;
                assign lp_rxi_status[i*7 +: 7]    = 7'd0;
                assign lt_start_rc[i]      = 1'b0;
                assign main_rc[i*MAINTAPWIDTH +: MAINTAPWIDTH]          = {MAINTAPWIDTH{1'b0}};
                assign post_rc[i*POSTTAPWIDTH +: POSTTAPWIDTH]          = {POSTTAPWIDTH{1'b0}};
                assign pre_rc[i*PRETAPWIDTH +: PRETAPWIDTH]           = {PRETAPWIDTH{1'b0}};
                assign tap_to_upd[i*3 +: 3]       = 3'd0;
                assign frame_lock[i]       = 1'b0;
                assign lcl_sts_new[i]      =1'b0;
                assign lcl_upd_new[i]  = 1'b0;
                assign rmt_coef_sts[i*6 +: 6]     = 'd0;
                assign ber_cnt[i*BERWIDTH +: BERWIDTH]   = {BERWIDTH{1'd0}};
                assign ber_max[i]   = 1'd0;
                assign bert_done[i] = 1'd0;
            end  // else synth_lt
            
        //****************************************************************************
        // Instantiate 10G-KR FEC -- only when SYNTH_FEC==1
        //****************************************************************************
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
            wire        fec_tx_err_ins;
            wire        fec_tx_err_ins_sync;
            reg         fec_tx_err_ins_sync1;

            //********************** FEC CSR 0xB2-0xBF
            alt_aeu_40_csr_krfec #( .REG_OFFS(i*3) ) csr_krfec_inst (
                // avalon-MM
              .clk                   (clk_status            ),
              .reset                 (pma_arst              ),
              .address               (status_addr           ),
              .read                  (status_read           ),
              .readdata              (fec_mgmt_readdata[i*32 +: 32]),
              .write                 (status_write          ),
              .writedata             (status_writedata      ),
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
              .clk    (tx_10g_coreclkin[i]),
              .reset  (pma_arst),
              .d      (fec_tx_err_ins),
              .q      (fec_tx_err_ins_sync)
              );
              
            alt_xcvr_resync #(
              .SYNC_CHAIN_LENGTH(2),  // Number of flip-flops for retiming
              .WIDTH            (1),  // Number of bits to resync
              .INIT_VALUE       (0)
            ) rx_clr_errblk_sync (
              .clk    (rx_10g_coreclkin[i]),
              .reset  (pma_arst),
              .d      (clear_counters),
              .q      (clr_errblk_cnt[i])
              );
            
            // create pulse, don't deassert until tx_fec_valid
            always @ (posedge tx_10g_coreclkin[i] or posedge pma_arst) begin
              if (pma_arst) begin 
                fec_tx_err_ins_sync1 <= 1'b0;
                fec_tx_err_ins_pulse[i] <= 1'b0;
              end else begin
                fec_tx_err_ins_sync1 <= fec_tx_err_ins_sync ;
                if (fec_tx_err_ins_sync & ~fec_tx_err_ins_sync1 )
                  fec_tx_err_ins_pulse[i] <= 1'b1;
                else if (tx_fec_valid[i])
                  fec_tx_err_ins_pulse[i] <= 1'b0;
                end
              end
            end // synth_fec
          else begin: NO_FEC_CSR  // need to drive outputs if no FEC_CSR module
            assign fec_mgmt_readdata[i*32 +: 32] = 32'b0;
            assign clr_errblk_cnt[i] = 1'b0;
          end  // else synth_fec

        end
    endgenerate
    
  
    //****************************************************************************
    // Instantiate the Reconfig module
    // Requests come from the Sequencer and LT modules
    // Commands via AVMM to the native PHY
    //****************************************************************************
    
    wire mgmt_lt_start_rc;
    wire mgmt_seq_start_rc;
    wire [1:0] rcfg_chan_select;
    
    alt_aeu_40_arbiter #(
        .CHANNELS (LANES),
        .PRI_RR   (1)
    ) arbiter_inst  (
        .clk               (clk_status         ),             
        .reset             (pma_arst           ),
        .lt_start_rc       (lt_start_rc        ),
        .seq_start_rc      (seq_start_rc       ), 
        .seq_pcs_mode      ({LANES{pcs_mode_rc}}), 
        .hdsk_rc_busy      (rc_busy            ), 
        .rcfg_busy         (mgmt_rc_busy       ), // reconfig_busy from reconfig_master  or user_reconfig_access
        .rcfg_lt_start_rc  (mgmt_lt_start_rc   ),   // pma reconfig request to reconfig_master
        .rcfg_seq_start_rc (mgmt_seq_start_rc  ),  // pcs reconfig request to reconfig_master
        .rcfg_chan_select  (rcfg_chan_select   )   // current selected channel
    );

    
    wire en_rcfg_cal;
    wire calibration_busy;
    assign calibration_busy = |tx_cal_busy | |rx_cal_busy;

    // "OR" this with the reset input on the channel instance
    wire rcfg_analog_reset, rcfg_analog_reset_tx, rcfg_digital_reset, rcfg_digital_reset_tx;
    wire [LANES-1:0] tx_analogreset_ack,rx_analogreset_ack;

    wire       rcfg_write;
    wire       rcfg_read;
    wire [9:0] rcfg_address;
    wire [7:0] rcfg_wrdata;

    alt_aeu_40_rcfg_top  #(
        .LTD_MSB     (MGMT_CLK_IN_KHZ/1000),
        .SYNTH_LT    (SYNTH_LT),
        .SYNTH_AN_LT (1), // always use backplane mode
        .SYNTH_FEC   (SYNTH_FEC),
        .SYNTH_1588  (0),
        .SYNTH_GIGE  (0),
        .REF_CLK_644 (REF_CLK_644)
    ) RECONFIG (
        .mgmt_clk_reset (pma_arst),
        .mgmt_clk       (clk_status),
        .seq_start_rc   (mgmt_seq_start_rc),
        .pcs_mode_rc    (pcs_mode_rc),
        .rc_busy        (mgmt_rc_busy),
        .skip_cal       (~en_rcfg_cal),   // native may not work, may need to skip
        .lt_start_rc    (~cpu_avmm_active & mgmt_lt_start_rc),
        .main_rc        (main_rc[rcfg_chan_select*MAINTAPWIDTH+:MAINTAPWIDTH]),
        .post_rc        (post_rc[rcfg_chan_select*POSTTAPWIDTH+:POSTTAPWIDTH]),
        .pre_rc         (pre_rc[rcfg_chan_select*PRETAPWIDTH+:PRETAPWIDTH]),
        .tap_to_upd     (tap_to_upd[rcfg_chan_select*3+:3]),
        .calibration_busy  (calibration_busy),
        .rx_is_lockedtodata (pcs_mode_rc[1] | rx_is_lockedtodata[rcfg_chan_select]), // mask LT to avoid lockup
        .rx_is_lockedtoref  (rx_is_lockedtoref[rcfg_chan_select]),
        .analog_reset      (rcfg_analog_reset),
        .analog_reset_tx   (rcfg_analog_reset_tx),
        .digital_reset     (rcfg_digital_reset),
        .digital_reset_tx  (rcfg_digital_reset_tx),
        .tx_analogreset_ack (&tx_analogreset_ack),
        .rx_analogreset_ack (&rx_analogreset_ack),
        .xcvr_rcfg_write        (rcfg_write),
        .xcvr_rcfg_read         (rcfg_read),
        .xcvr_rcfg_address      (rcfg_address),
        .xcvr_rcfg_wrdata       (rcfg_wrdata),
        .xcvr_rcfg_rddata       (reconfig_readdata[7:0]),
        .xcvr_rcfg_wtrqst       (chnl_rcfg_waitrequest)
    );

    // need to drive AVMM for Reconfig at start and until busy done
    wire sel_avmm_rcfg;
    assign sel_avmm_rcfg = mgmt_rc_busy | |seq_start_rc;
    wire debug_cpu_avmm_active ;
	
	generate
    if (USE_DEBUG_CPU) begin : Allow_LT_AVMMM
       assign debug_cpu_avmm_active = cpu_avmm_active ;
    end 
    else begin :  No_LT_AVMMM 
       assign debug_cpu_avmm_active = 1'b1 ;
    end 
	endgenerate

    // Mux for reconfig AVMM to Channel
    // Update  AVMM bus to CPU only when it needs
    assign chnl_rcfg_write   = sel_avmm_rcfg  ? rcfg_write     :
                           (pcs_mode_rc[1] & debug_cpu_avmm_active) ? cpu_avmm_write & ~cpu_avmm_addr[12] :
                           reconfig_write;
    assign chnl_rcfg_read    = sel_avmm_rcfg  ? rcfg_read      :
                           (pcs_mode_rc[1] & debug_cpu_avmm_active) ? cpu_avmm_read & ~cpu_avmm_addr[12] : 
                           reconfig_read;
    assign chnl_rcfg_address = sel_avmm_rcfg  ? {rcfg_chan_select,rcfg_address}  :
                           (pcs_mode_rc[1] & debug_cpu_avmm_active) ? cpu_avmm_addr[11:0]  : 
                           reconfig_address[11:0];
    assign chnl_rcfg_wrdata  = sel_avmm_rcfg  ? {24'b0,rcfg_wrdata}  :
                           (pcs_mode_rc[1] & debug_cpu_avmm_active) ? cpu_avmm_wrdata      :
                           reconfig_writedata;
    assign reconfig_waitrequest  = |rc_busy | |seq_start_rc | (pcs_mode_rc[1] & debug_cpu_avmm_active) | chnl_rcfg_waitrequest;

    
    //****************************************************************************
    // Instantiate Native PHY, Reset controller, fPLL
    //****************************************************************************

    //////////////////////////////////
    //reset controller outputs
    //////////////////////////////////
    wire              reset_controller_pll_powerdown;
    wire  [LANES-1:0] reset_controller_tx_digitalreset;
    wire  [LANES-1:0] reset_controller_rx_analogreset;
    wire  [LANES-1:0] reset_controller_rx_digitalreset;

    // Final reset signals
    wire  pll_powerdown_fnl;
    wire  [LANES-1:0] tx_analogreset_fnl;
    wire  [LANES-1:0] tx_digitalreset_fnl;
    wire  [LANES-1:0] rx_analogreset_fnl;
    wire  [LANES-1:0] rx_digitalreset_fnl;
    
    wire tx_pma_ready, rx_pma_ready;

    assign  pll_powerdown_fnl   = reset_controller_pll_powerdown;
    assign  tx_analogreset_fnl  = {LANES{reset_controller_pll_powerdown}};
    assign  tx_digitalreset_fnl = reset_controller_tx_digitalreset;
    assign  rx_analogreset_fnl  = reset_controller_rx_analogreset;
    assign  rx_digitalreset_fnl = reset_controller_rx_digitalreset;
    
    assign tx_analogreset = |tx_analogreset_fnl;
   
    wire  [LANES-1:0]   rx_manual_mode;

    // Put reset controller into manual mode when we are in AN/LT or not in auto lock mode
    assign  rx_manual_mode = {LANES{|pcs_mode_rc[1:0]}} | (rx_set_locktoref | rx_set_locktodata);
    // We have a single tx_ready, rx_ready output per IP instance
    assign  tx_pma_ready  = &reset_controller_tx_ready & ~seq_rc_busy;
    assign  rx_pma_ready  = &reset_controller_rx_ready & ~seq_rc_busy;

    assign rx_cdr_lock = rx_is_lockedtodata;   

    altera_xcvr_reset_control #( 
        .CHANNELS(LANES),
        .PLLS(1),
        .SYNCHRONIZE_RESET(1),
        .SYNCHRONIZE_PLL_RESET(1),
        .T_TX_ANALOGRESET(70000),
        .T_TX_DIGITALRESET(70000),
        .T_RX_ANALOGRESET(70000),
        .TX_PLL_ENABLE(1),
        .TX_ENABLE(1),
        .RX_ENABLE(1),
        .RX_PER_CHANNEL(1),
        .SYS_CLK_IN_MHZ(MGMT_CLK_IN_KHZ/1000)
    ) reset_controller (
        .clock               (clk_status),
        .reset               (pma_arst),
        // outputs
        .pll_powerdown       (reset_controller_pll_powerdown),
        .tx_analogreset      (/*unused*/),
        .tx_digitalreset     (reset_controller_tx_digitalreset),
        .rx_analogreset      (reset_controller_rx_analogreset),
        .rx_digitalreset     (reset_controller_rx_digitalreset),
        .tx_ready            (reset_controller_tx_ready),
        .rx_ready            (reset_controller_rx_ready),
        // inputs
        .tx_digitalreset_or  ({LANES{data_mux_sel != 2'b01 && !clk_tx_ready}}),  // reset request for tx_digitalreset
        .rx_digitalreset_or  ({LANES{data_mux_sel[1] && !clk_rx_ready}}),  // reset request for rx_digitalreset
        .pll_locked          (tx_pll_lock),
        .pll_select          (1'b0),
        .tx_cal_busy         (tx_cal_busy_hssi),
        .rx_cal_busy         (rx_cal_busy_hssi),
        .rx_is_lockedtodata  (rx_is_lockedtodata_hssi),
        .rx_manual       (rx_manual_mode), // 0 = Automatically restart rx_digitalreset
                                  // when rx_is_lockedtodata deasserts
                                  // 1 = Do nothing on rx_is_lockedtodata deassert
        .tx_manual       ({LANES{1'b1}})   // 0 = Automatically restart tx_digitalreset
                                  // when pll_locked deasserts.
                                  // 1 = Do nothing when pll_locked deasserts
    );
      
    //****************************************************************************
    // Gearboxes for FEC mode
    //****************************************************************************
    
    wire [(LANES*66)-1:0] tx_data_fec;
    wire [(LANES*40)-1:0] rx_data_fec;
    
    wire [3:0] rx_rd_en_i;
    wire [3:0] rx_rd_en_ii;
    
    generate
      if(SYNTH_FEC) begin
        for (i=0; i<LANES; i=i+1) 
        begin : fecgb
    
            // re-arrange sync bits for fec
            // basic par data: 65      64      63..0
            //           hssi: ctrl[1] ctrl[0] data[63..0]
            //   fec par data: 0       1       65..2
            assign tx_data_fec[(66*i) +: 66] = {tx_fec_datain[(66*i) + 0], tx_fec_datain[(66*i) + 1],
                                                tx_fec_datain[(66*i+2) +: 64]};
                                                
            wire [65:0] rx_parallel_data_fec = {rx_parallel_data_66[(66*i) +: 64],
                                                rx_parallel_data_66[(66*i) + 64],
                                                rx_parallel_data_66[(66*i) + 65]};
            reg [65:0] rx_parallel_data_fec_reg ; // pipelined data before sending to GB- need to be stalled by rd_en/pempty
            always @ (posedge clk_rx)
               if (rx_rd_en_ii[i] )
               rx_parallel_data_fec_reg <=  rx_parallel_data_fec ;
    
            (* altera_attribute  = "-name SDC_STATEMENT \"set_false_path -from  {*e40_inst|phy.phy_inst|iof|pma|rx_pempty_r*} -to  {*|e40_inst|phy.phy_inst|iof|pma|NATIVE_PHY_40G_*|native_40g_*|g_xcvr_native_insts*inst_twentynm_hssi_rx_pld_pcs_interface|pld_pcs_rx_clk_out}\"" *)

            alt_aeu_40_gearbox_66_40 fecgb_rx (
                .clk(clk_rx),
                .sclr(rx_fifo_aclr[i]),
                .ena(rx_rd_en[i]),
                .din(rx_parallel_data_fec_reg[65:0]),
                .din_rd_en(rx_rd_en_i[i]),
                .dout(rx_data_fec[i*40 +: 40])
            );
           
            // mask read enable output with input enable to ensure no double-reading
            assign rx_rd_en_ii[i] = rx_rd_en_i[i] & rx_rd_en[i];


        end
      end else begin
        assign rx_data_fec = 0;
        assign tx_data_fec = 0;
        assign rx_rd_en_i = 4'b0;
        assign rx_rd_en_ii = 4'b0;
      end
    endgenerate
   
    assign tx_enh_data_valid = data_mux_sel[1] ? (enable_fec ? tx_fec_valid[3:0]
                                                             : tx_valid[3:0]) 
                                               : {LANES{1'b1}};
   
    //****************************************************************************
    // Muxes/logic for the AN data and status
    // Selection is made by the Sequencer
    // 00 = AN, 01 = LT, 1x = data
    //****************************************************************************
    
    wire [LANES-1:0] rx_data_ready_fec;
    
    generate
        for (i=0; i<LANES; i=i+1) 
        begin : tx_ansel
            assign tx_parallel_data_66[66*i +: 66] = 
                data_mux_sel[1] && enable_fec ? tx_data_fec[i*66 +: 66] :
                data_mux_sel[1] ? {26'b0, tx_datain[i*40 +: 40]} :
                data_mux_sel[0] ? {34'b0, lt_data[i*32 +: 32]} : 
                an_chan_sel[i] ? an_data : 66'b0;
        end

        for (i=0; i<LANES; i=i+1) 
        begin : tx_pardat
            assign tx_10g_control[18*i+0] = tx_parallel_data_66_r[66*i+64];
            assign tx_10g_control[18*i+1] = tx_parallel_data_66_r[66*i+65];
            assign tx_10g_control[(18*i+2) +: 16] = {9'b0, fec_tx_err_ins_pulse_r[i], 6'b0};
            assign tx_parallel_data[(128*i) +: 128] = {64'b0, tx_parallel_data_66_r[(66*i) +: 64]};
            
            // TX pipeline register
            if (ENABLE_TX_PIPELINE == 1) begin : TX_PIPELN
                always @ (posedge tx_10g_coreclkin[i]) begin
                    tx_parallel_data_66_postnav[(66*i) +: 66] <= tx_parallel_data_66[(66*i) +: 66];
                    tx_enh_data_valid_to_pcs[i] <= tx_enh_data_valid[i];
                    fec_tx_err_ins_pulse_r[i] <= fec_tx_err_ins_pulse[i];
                end
            end else begin : NO_TX_PIPELN
                always @(*) begin
                    tx_parallel_data_66_postnav[(66*i) +: 66] = tx_parallel_data_66[(66*i) +: 66];
                    tx_enh_data_valid_to_pcs[i] = tx_enh_data_valid[i];
                    fec_tx_err_ins_pulse_r[i] = fec_tx_err_ins_pulse[i];
                end
        end
        end
        for (i=0; i<LANES; i=i+1) 
        begin : rx_pardat
            assign rx_parallel_data_66_prenav[66*i+64] = rx_10g_control[20*i+0];
            assign rx_parallel_data_66_prenav[66*i+65] = rx_10g_control[20*i+1];
            assign rx_parallel_data_66_prenav[(66*i) +: 64] = rx_parallel_data[(128*i) +: 64];
            assign rx_dataout[i*40 +: 40] = enable_fec ? rx_data_fec[i*40 +: 40] : rx_parallel_data_66[i*66 +: 40];
            assign rx_data_ready_fec[i] = rx_10g_control[20*i+9];
            
            // RX pipeline register
            if (ENABLE_RX_PIPELINE == 1) begin : RX_PIPELN
                always @ (posedge rx_10g_coreclkin[i]) begin
                    if(!enable_fec || !data_mux_sel[1] || (rx_rd_en_ii[i] )) // feg GB needs to stall the pipeline
                        rx_parallel_data_66[(66*i) +: 66] <= rx_parallel_data_66_prenav[(66*i) +: 66];
                end
            end else begin : NO_RX_PIPELN
                always @(*) begin
                    rx_parallel_data_66[(66*i) +: 66] = rx_parallel_data_66_prenav[(66*i) +: 66];
                end
            end

	    always @(posedge rx_10g_coreclkin[i]) begin
                rx_pempty_r[i] <= rx_pempty[i];
                rx_pempty_r_neg_coreclk[i] <= ~rx_pempty_r[i];
            end

        end

        for (i=0; i<LANES; i=i+1)
        begin : ltd_ctr
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
             assign stage_two_max_count = MGMT_CLK_IN_KHZ/1000;
          `else // not FULL_KR_TIMERS
             assign stage_one_max_count = 10 ;
             assign stage_two_max_count = 2;
          `endif // FULL_KR_TIMERS
          
            always @(posedge clk_status) begin
              if (~rx_is_lockedtodata[i])
                stage_one     <= 10'd0;
              else if (clr_ltd_ok_1ms[i])
                stage_one     <= 10'd0;
              else if (stage_one==stage_one_max_count)
                stage_one     <= 10'd0;
              else if (stage_one!=stage_one_max_count)
                stage_one <= stage_one + 1'b1;
            end //always
          
            always @(posedge clk_status) begin
              if (~rx_is_lockedtodata[i])
                stage_two     <= 10'd0;
              else if (clr_ltd_ok_1ms[i])
                stage_two     <= 10'd0;
              else if ((stage_two!=stage_two_max_count) && (stage_one==stage_one_max_count) )
                stage_two <= stage_two + 1'b1;
            end //always
            
            always @ (posedge clk_status)
              ltd_ok_1ms[i] <= (stage_two==stage_two_max_count) ;
        end

    endgenerate

    // Mux the link status depending upon which datapath is active
    assign pcs_link_sts = (pcs_mode_rc[5] || pcs_mode_rc[2]) ? lanes_deskew_sync // 40G data mode (with or without FEC)
                        : 1'b0;
                        
    assign tx_ready = tx_pma_ready & (pcs_mode_rc[5] | pcs_mode_rc[2]);
    assign rx_ready = rx_pma_ready & ((pcs_mode_rc[5] & &rx_data_ready_fec)| pcs_mode_rc[2]);
    
    // override lock_to signals depending uppn datapath mode
    assign rx_set_locktoref = pcs_mode_rc[0] ? 4'hF : // AN mode - force LTR
                             pcs_mode_rc[1] ? 4'h0 : // LT mode - Auto LTD
                             {4{set_lock_ref}};
    assign rx_set_locktodata = pcs_mode_rc[0] ? 4'h0 : // AN mode - force LTR
                              pcs_mode_rc[1] ? 4'h0 : // LT mode - Auto LTD
                              {4{set_lock_data}};

    // clock muxing / distribution
    generate 
            for (i=0; i<LANES; i=i+1) 
            begin : clock_mux
                // use glitch-free clock_mux with 1-hot enabling as LUTs may glitch
                alt_aeu_40_gf_clock_mux #(
                   .num_clocks(3)
                ) rx_clk_mux (
                   .clk         ({clk_rx, rx_10g_clkout[i], rx_10g_clk33out[2]}),
                   .clk_select  ({data_mux_sel[1],  // data
                                 ~data_mux_sel[1] & data_mux_sel[0], // lt
                                 ~data_mux_sel[1] & ~data_mux_sel[0]}), // an
                   .clk_out     (rx_10g_coreclkin[i])
                );
                
                // use glitch-free clock_mux with 1-hot enabling as LUTs may glitch
                alt_aeu_40_gf_clock_mux #(
                   .num_clocks(3)
                ) tx_clk_mux (
                   .clk         ({clk_tx, tx_10g_clkout[i], tx_10g_clk33out[2]}),
                   .clk_select  ({data_mux_sel[1],  // data
                                 ~data_mux_sel[1] & data_mux_sel[0], // lt
                                 ~data_mux_sel[1] & ~data_mux_sel[0]}), // an
                   .clk_out     (tx_10g_coreclkin[i])
                );
            end
    endgenerate    
    
    //****************************************************************************
    // Instantiate the CSR modules and the memory map logic
    // no syncronizer on reset input
    //****************************************************************************
    
    wire [LANES-1:0] rx_enh_blk_lock;
    wire [LANES-1:0] rx_enh_blk_lock_sync;
    
    alt_xcvr_resync #(
        .WIDTH            (LANES)
    ) blk_lock_resync_reset (
        .clk    (clk_status),
        .reset  (pma_arst),
        .d      (rx_enh_blk_lock),
        .q      (rx_enh_blk_lock_sync)
    );
    
    // KR SEQ and top-level registers 0xB0 - 0xBF
    alt_aeu_40_csr_kra10top #(
        .SYNTH_FEC  (SYNTH_FEC),
        .AN_FEC     (AN_FEC   ),
        .ERR_INDICATION (0)
    ) csr_krtop_inst (
        .clk        (clk_status        ),
        .reset      (pma_arst          ),
        .address    (status_addr     ),
        .read       (status_read     ),
        .readdata   (top_mgmt_readdata ),
        .write      (status_write    ),
        .writedata  (status_writedata),
        //status inputs to this CSR
        .seq_link_rdy    (link_ready),
        .seq_an_timeout  (seq_an_timeout),
        .seq_lt_timeout  (seq_lt_timeout),
        .pcs_mode_rc     (pcs_mode_rc),
        .fec_block_lock  (rx_enh_blk_lock_sync),
        // read/write control outputs
        .csr_reset_seq  (csr_seq_restart),
        .dis_an_timer   (dis_an_timer),
        .dis_lf_timer   (dis_lf_timer),
        .force_mode     (force_mode),
        .fec_enable     (fec_enable),
        .fec_request    (fec_request),
        .fec_err_ind    (),
        .fail_lt_if_ber (fail_lt_if_ber),
        .en_rcfg_cal    (en_rcfg_cal),
        .lt_fail_response(lt_fail_response)
    );

    always @(posedge clk_status) begin
        status_readdata_valid <= status_read;
    end
    
    // mux CSR reads together, create readdata_valid signals (again, slightly out of spec, see above)   
    assign status_readdata = 
      (status_addr >= 8'hB0) && (status_addr <= 8'hB1) ? top_mgmt_readdata :
      (status_addr >= 8'hB2) && (status_addr <= 8'hBF) ? 32'b0 :
      (status_addr >= 8'hC0) && (status_addr <= 8'hCF) ? an_mgmt_readdata  :
      (status_addr >= 8'hD0) && (status_addr <= 8'hEB) ? lt_mgmt_readdata  : 32'b0;

    
    //****************************************************************************
    // Instantiate Native PHY
    //****************************************************************************
    
    `define ALTERA_XCVR_KR_NATIVE_PORT_MAPPING  (                               \
                 .tx_analogreset            (tx_analogreset_fnl | {LANES{rcfg_analog_reset_tx}}) ,\
                 .tx_digitalreset           (tx_digitalreset_fnl | {LANES{rcfg_digital_reset_tx}}) ,\
                 .rx_analogreset            (rx_analogreset_fnl | {LANES{rcfg_analog_reset}}) ,\
                 .rx_digitalreset           (rx_digitalreset_fnl | {LANES{rcfg_digital_reset}}) ,\
                 .tx_analogreset_ack        (tx_analogreset_ack_hssi         ) ,\
                 .rx_analogreset_ack        (rx_analogreset_ack_hssi         ) ,\
                 .tx_cal_busy               (tx_cal_busy_hssi                ) ,\
                 .rx_cal_busy               (rx_cal_busy_hssi                ) ,\
                 .tx_serial_clk0            (tx_serial_clk_10g               ) ,\
                 .rx_cdr_refclk0            (rx_cdr_ref_clk_10g              ) ,\
                 .tx_serial_data            (tx_serial                       ) ,\
                 .rx_serial_data            (rx_serial                       ) ,\
                 .rx_seriallpbken           (rx_seriallpbken                 ) ,\
                 .rx_set_locktodata         (rx_set_locktodata               ) ,\
                 .rx_set_locktoref          (rx_set_locktoref                ) ,\
                 .rx_is_lockedtoref         (rx_is_lockedtoref_hssi          ) ,\
                 .rx_is_lockedtodata        (rx_is_lockedtodata_hssi         ) ,\
                 .tx_coreclkin              (tx_10g_coreclkin                ) ,\
                 .rx_coreclkin              (rx_10g_coreclkin                ) ,\
                 .tx_clkout                 (tx_10g_clkout                   ) ,\
                 .rx_clkout                 (rx_10g_clkout                   ) ,\
                 .tx_pma_div_clkout         (tx_10g_clk33out                 ) ,\
                 .rx_pma_div_clkout         (rx_10g_clk33out                 ) ,\
                 .tx_parallel_data          (tx_parallel_data                ) ,\
                 .rx_parallel_data          (rx_parallel_data                ) ,\
                 .tx_control                (tx_10g_control                  ) ,\
                 .rx_control                (rx_10g_control                  ) ,\
                 .rx_bitslip                ((data_mux_sel == 2'b01) ? rx_10g_bitslip : {LANES{1'b0}}) ,\
                 .tx_enh_data_valid         (tx_enh_data_valid_to_pcs) ,\
                 .tx_enh_fifo_full          (tx_full[3:0]) ,\
                 .tx_enh_fifo_pfull         (tx_pfull[3:0]) ,\
                 .tx_enh_fifo_empty         (tx_empty[3:0]) ,\
                 .tx_enh_fifo_pempty        (tx_pempty[3:0]) ,\
                 .rx_enh_fifo_rd_en         (data_mux_sel[1] ? (enable_fec ? rx_rd_en_ii[3:0] & rx_pempty_r_neg_coreclk[3:0]\
                                                                           : rx_rd_en[3:0]) : 4'b0) ,\
                 .rx_enh_data_valid         () ,\
                 .rx_enh_fifo_full          (rx_full[3:0]) ,\
                 .rx_enh_fifo_pfull         (rx_pfull[3:0]) ,\
                 .rx_enh_fifo_empty         (rx_empty[3:0]) ,\
                 .rx_enh_fifo_pempty        (rx_pempty[3:0]) ,\
                 .rx_enh_fifo_align_clr     (data_mux_sel[1] ? rx_fifo_aclr[3:0] : 4'b0) ,\
                 .rx_enh_clr_errblk_count   (clr_errblk_cnt                  ) ,\
                 .rx_enh_blk_lock           (rx_enh_blk_lock                  ) ,\
                 .reconfig_clk              (clk_status                      ) ,\
                 .reconfig_reset            (pma_arst                        ) ,\
                 .reconfig_write            (chnl_rcfg_write                 ) ,\
                 .reconfig_read             (chnl_rcfg_read                  ) ,\
                 .reconfig_address          (chnl_rcfg_address[11:0]         ) ,\
                 .reconfig_writedata        (chnl_rcfg_wrdata                ) ,\
                 .reconfig_readdata         (reconfig_readdata               ) ,\
                 .reconfig_waitrequest      (chnl_rcfg_waitrequest           ) \
                 \
        );

    generate
     if ((!SYNTH_FEC)&&(!REF_CLK_644)) begin : NATIVE_PHY_40G_322
     native_40g_322 native_40g_322_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((!SYNTH_FEC)&&(REF_CLK_644)) begin : NATIVE_PHY_40G_644
     native_40g_644  native_40g_644_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((SYNTH_FEC)&&(!REF_CLK_644)) begin : NATIVE_PHY_40G_FEC_322
     native_40g_fec_322  native_40g_fec_322_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
     else if ((SYNTH_FEC)&&(REF_CLK_644)) begin : NATIVE_PHY_40G_FEC_644
     native_40g_fec_644 native_40g_fec_644_inst
     `ALTERA_XCVR_KR_NATIVE_PORT_MAPPING
     end
    endgenerate
    
    // sync signals from HSSI
    alt_xcvr_resync #(
        .WIDTH  (LANES*6)       // Number of bits to resync
    ) hssi_out_sync (
        .clk    (clk_status),
        .reset  (pma_arst),
        .d      ({rx_analogreset_ack_hssi,tx_analogreset_ack_hssi,rx_cal_busy_hssi,
                  tx_cal_busy_hssi, rx_is_lockedtodata_hssi, rx_is_lockedtoref_hssi}),
        .q      ({rx_analogreset_ack     ,tx_analogreset_ack     ,rx_cal_busy     ,
                  tx_cal_busy     , rx_is_lockedtodata     ,rx_is_lockedtoref})
    );

    localparam SKEW = 59; // bits to skew the TX's per lane pair
    generate
        if (FAKE_TX_SKEW) begin
            // synthesis translate off
            for (i=0; i<LANES; i=i+1) begin : foo
                wire [65:0] tmp_in = tx_parallel_data_66_postnav[(i+1)*66-1:i*66];
                reg [65+LANES*SKEW:0] history = 0;
                always @(posedge tx_10g_coreclkin[i]) begin
                    history <= (pcs_mode_rc[5]||pcs_mode_rc[2]) ? (history >> 64) : (history >> 66);
                    if(pcs_mode_rc[5]||pcs_mode_rc[2]) begin
                        history[65+LANES*SKEW:2+LANES*SKEW] <= tmp_in[65:2];
                    end else begin
                        history[65+LANES*SKEW:LANES*SKEW] <= tmp_in;
                    end
                end
                wire [65:0] tmp_out = history[SKEW*i+65:SKEW*i];
                assign tx_parallel_data_66_r[(i+1)*66-1:i*66] = tmp_out;    
            end
            // synthesis translate on
        end
        else begin
            assign tx_parallel_data_66_r = tx_parallel_data_66_postnav;
        end
    endgenerate


endmodule  //alt_aeu_40_pma_sv_kr4


//****************************************************************************
//****************************************************************************
// Glitch-Free Clock Mux module
// from Chapter 11 of Recommended HDL Coding Styles document
//  http://www.altera.com/literature/hb/qts/qts_qii51007.pdf
// See Figure 11-3 for circuit diagram
// code taken directly from Example 11-48
//****************************************************************************

  // Apply embedded false path timing constraint to first flop
  (* altera_attribute  = "disable_da_rule=\"c101\"; -name SDC_STATEMENT \"set_false_path -to [get_registers {*gf_clock_mux*ena_r0*}]\"" *)
module alt_aeu_40_gf_clock_mux (clk, clk_select, clk_out);
  parameter num_clocks = 2;

  input [num_clocks-1:0] clk;
  input [num_clocks-1:0] clk_select; // one hot
  (* altera_attribute  = "disable_da_rule=c101" *)
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
endmodule  // alt_aeu_40_gf_clock_mux
