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


//-----------------------------------------------------------------------------
//
// Description: xaui verilog for Arria 10
//
//
//              Copyright (c) Altera Corporation 1997 - 2012
//              All rights reserved.
//
//-----------------------------------------------------------------------------
`timescale 1 ps / 1 ps
module a10_xcvr_xaui #(
  parameter device_family       = "Arria 10",
  
  // A10 transceiver mode
  parameter protocol_hint       = "basic",   
  parameter operation_mode      = "Duplex",  // legal value: TX,RX,Duplex
  parameter interface_type      = "Soft XAUI",
  parameter xaui_pll_type       = "ATX",
  parameter use_control_and_status_ports = 0,
  parameter lanes               = 4,  //legal value: 1+
  parameter bonded_group_size   = 4,  //legal value: integer from 1 .. lanes
  parameter bonded_mode         = "xN", // (xN, fb_compensation)
  parameter pma_bonding_mode    = "xN", // ("x1", "xN")
  parameter pcs_pma_width       = 10, //legal value: 8, 10, 16, 20
  parameter ser_base_factor     = 10,  //legal value: 8,10
  parameter ser_words           = 2,  //legal value 1,2,4
  parameter data_rate           = "3125 Mbps",  //remove this later
  parameter base_data_rate      = "3125 Mbps", // (PLL data rate)

  parameter soft_pcs_legacy_new_n = 0,
  
  // tx bitslip
  parameter tx_bitslip_enable = "false",
  
  //optional coreclks
  parameter tx_use_coreclk = "false",
  parameter rx_use_coreclk = "true",
  parameter en_synce_support  = 0,   //expose CDR ref-clk in this mode
  
  // 8B10B
  parameter use_8b10b = "false",  //legal value: "false", "true"
  parameter use_8b10b_manual_control = "false",
  
  //Word Aligner
  parameter word_aligner_mode = "sync_state_machine", //legal value: bitslip, sync_state_machine, manual
  parameter word_aligner_state_machine_datacnt = 1, //legal value: 0-256
  parameter word_aligner_state_machine_errcnt = 1,  //legal value: 0-256
  parameter word_aligner_state_machine_patterncnt = 10,  //legal value: 0-256
  parameter word_aligner_pattern_length = 10,
  parameter word_align_pattern = "0101111100",
  parameter run_length_violation_checking = 40, //legal value: 0,1+
  
  //RM FIFO
  parameter use_rate_match_fifo = 0,  //legal value: 0,1
  parameter rate_match_pattern1 = "11010000111010000011",
  parameter rate_match_pattern2 = "00101111000101111100",
  
  //Byte Ordering Block
  parameter byte_order_mode = "none", //legal value: None, sync_state_machine, PLD control
  parameter byte_order_pattern = "000000000",
  parameter byte_order_pad_pattern = "111111011",
  
  //Hidden parameter to enable 0ppm legality bypass
  parameter coreclk_0ppm_enable = "false",
  
  //PLL
  parameter pll_refclk_cnt    = 1,          // Number of reference clocks
  parameter pll_refclk_freq   = "156.25 MHz",  // Frequency of each reference clock
  parameter pll_refclk_select = "0",        // Selects the initial reference clock for each TX PLL
  parameter cdr_refclk_select = 0,          // Selects the initial reference clock for all RX CDR PLLs
  parameter plls              = 1,          // (1+)
  parameter pll_type          = "CMU",     // PLL type for each PLL
  parameter pll_select        = 0,          // Selects the initial PLL
  parameter pll_reconfig      = 0,          // (0,1) 0-Disable PLL reconfig, 1-Enable PLL reconfig
  parameter pll_external_enable = 0,        // (0,1) 0-Disable external TX PLL, 1-Enable external TX PLL
  
  // initially found in siv_xcvr_custom_phy
  // Analog Parameters
  parameter gxb_analog_power = "AUTO",  //legal value: AUTO,2.5V,3.0V,3.3V,3.9V
  parameter pll_lock_speed = "AUTO",
  parameter tx_analog_power = "AUTO", //legal value: AUTO,1.4V,1.5V
  parameter tx_slew_rate = "OFF",
  parameter tx_termination = "OCT_100_OHMS",  //legal value: OCT_85_OHMS,OCT_100_OHMS,OCT_120_OHMS,OCT_150_OHMS
  parameter tx_use_external_termination = "false", //legal value: true, false
  parameter tx_preemp_pretap = 0,
  parameter tx_preemp_pretap_inv = "FALSE",
  parameter tx_preemp_tap_1 = 0,
  parameter tx_preemp_tap_2 = 0,
  parameter tx_preemp_tap_2_inv = "FALSE",
  parameter tx_vod_selection = 2,
  parameter tx_common_mode = "0.65V", //legal value: 0.65V
  parameter rx_pll_lock_speed = "AUTO",
  parameter rx_common_mode = "0.82V", //legal value: "0.65V"
  parameter rx_termination = "OCT_100_OHMS",  //legal value: OCT_85_OHMS,OCT_100_OHMS,OCT_120_OHMS,OCT_150_OHMS
  parameter rx_use_external_termination = "false", //legal value: true, false
  parameter rx_eq_dc_gain = 1,
  parameter rx_eq_ctrl = 16,
    
  //Param siv_xcvr_custom_phy.mgmt_clk_in_mhz has default '50', but module-level default is '150'
  parameter mgmt_clk_in_mhz = 250,  //needed for reset controller timed delays
  parameter embedded_reset = 1,  // (0,1) 1-Enable embedded reset controller
  parameter channel_interface = 0, //legal value: (0,1) 1-Enable channel reconfiguration
  parameter starting_channel_number = 0,  //legal value: 0+em
  parameter rx_ppmselect = 32,
  parameter rx_signal_detect_threshold = 2,
  parameter rx_use_cruclk = "FALSE",

  parameter en_dual_fifo = 0,
  parameter disable_embedded_sdc = 1

  
) (
  input  wire         pll_ref_clk,           //   refclk.clk
  input  wire         cdr_ref_clk,           // used only in SyncE mode
  input  wire         xgmii_tx_clk,          //   xgmii_tx_clk.clk
  output wire         xgmii_rx_clk,          //   xgmii_rx_clk.clk
  input  wire         xgmii_rx_inclk,
  input  wire         phy_mgmt_clk,          //   mgmt_clk.clk
  input  wire         phy_mgmt_clk_reset,    //   mgmt_clk_rst.reset_n
  input  wire  [7:0]  phy_mgmt_address,      //   phy_mgmt.address
  output wire         phy_mgmt_waitrequest,  //   .waitrequest
  input  wire         phy_mgmt_read,         //   .read
  output wire [31:0]  phy_mgmt_readdata,     //   .readdata
  input  wire         phy_mgmt_write,        //   .write
  input  wire [31:0]  phy_mgmt_writedata,    //   .writedata
  input  wire [71:0]  xgmii_tx_dc,           //   xgmii_tx_dc.data
  output wire [71:0]  xgmii_rx_dc,           //   xgmii_rx_dc.data
  output wire [3:0]   xaui_tx_serial_data,   //   xaui_tx_serial.export
  input  wire [3:0]   xaui_rx_serial_data,   //   xaui_rx_serial.export
  output wire         rx_ready,              //   rx_pma_ready.data
  output wire         tx_ready,              //   tx_pma_ready.data
  output wire [3:0]   rx_recovered_clk,      //   rx recovered clock from cdr

// optional control and status ports
  input  wire         rx_digitalreset,
  input  wire         tx_digitalreset,
  output wire         rx_channelaligned,
  output wire [7:0]   rx_disperr,
  output wire [7:0]   rx_errdetect,
  output wire [7:0]   rx_syncstatus,

  // PLL and bonding clocks
  input wire [5:0]    tx_bonding_clocks,
  output wire         pll_powerdown,
  input wire          pll_locked,
  input wire          pll_cal_busy,

  // Dynamic reconfiguration Av-MM Interface
  input  wire        reconfig_clk,            //            reconfig_clk.clk
  input  wire        reconfig_reset,          //          reconfig_reset.reset
  input  wire        reconfig_write,          //           reconfig_avmm.write
  input  wire        reconfig_read,           //                        .read
  input  wire [11:0] reconfig_address,        //                        .address
  input  wire [31:0] reconfig_writedata,      //                        .writedata
  output wire [31:0] reconfig_readdata,       //                        .readdata
  output wire        reconfig_waitrequest     //                        .waitrequest

);

import altera_xcvr_functions::*;


  localparam  TX_ENABLE = (operation_mode != "Rx" && operation_mode != "RX");
  localparam  RX_ENABLE = (operation_mode != "Tx" && operation_mode != "TX");

  wire        alt_pma_controller_0_cal_blk_pdn_data;
  wire        alt_pma_controller_0_pll_pdn0_data;
  wire  [7:0] rx_disperr_data;
  wire  [7:0] rx_errdetect_data;
  wire  [3:0] alt_pma_ch_controller_0_rx_analog_rst_data;
  wire  [3:0] alt_pma_ch_controller_0_tx_digital_rst_data;
  wire  [3:0] alt_pma_ch_controller_0_rx_digital_rst_data;
  wire        hxaui_csr_r_rx_digitalreset_data;
  wire        hxaui_csr_r_tx_digitalreset_data;
  wire        hxaui_csr_simulation_flag_data;
  wire        alt_pma_controller_0_pll_pdn;
  wire  [3:0] alt_pma_0_tx_out_clk_clk;
  wire  [3:0] alt_pma_0_tx_out_clk;
  wire  [3:0] alt_pma_0_rx_recovered_clk_clk;
  wire  [3:0] alt_pma_0_tx_clkout;
  wire [79:0] sxaui_0_tx_parallel_data_data;
  wire [79:0] alt_pma_0_rx_parallel_data_data;
  wire  [3:0] alt_pma_0_rx_is_lockedtodata_data;
  wire        rx_pma_ready;
  wire        sxaui_rst_done;

  wire [5:0]  sc_pma_ch_controller_address;
  wire        sc_pma_ch_controller_read;
  wire [31:0] sc_pma_ch_controller_readdata;
  wire        sc_pma_ch_controller_waitrequest;
  wire        sc_pma_ch_controller_write;

  wire [1:0]  sc_pma_controller_address;
  wire        sc_pma_controller_read;
  wire [31:0] sc_pma_controller_readdata;
  wire        sc_pma_controller_waitrequest;
  wire        sc_pma_controller_write;

  wire [4:0]  sc_csr_address;
  wire        sc_csr_read;
  wire [31:0] sc_csr_readdata;
  wire        sc_csr_write;

  wire [7:0] rx_patterndetect;
  wire       cdr_clock;

  wire  [lanes-1:0]     tx_cal_busy;
  wire  [lanes-1:0]     rx_cal_busy;
  wire  [lanes-1:0]     rst_tx_cal_busy;
  genvar i;

  // Control & status register map (CSR) outputs
  wire                csr_reset_tx_digital;         //to reset controller
  wire                csr_reset_rx_digital;         //to reset controller
  wire                csr_reset_all;                //to reset controller
  wire                csr_pll_powerdown;            //to xcvr instance
  wire [lanes-1:0]    csr_tx_digitalreset;          //to xcvr instance
  wire [lanes-1:0]    csr_rx_analogreset;           //to xcvr instance
  wire [lanes-1:0]    csr_rx_digitalreset;          //to xcvr instance
  wire [lanes-1:0]    csr_phy_loopback_serial;      //to xcvr instance
  wire [lanes-1:0]    csr_tx_invpolarity;           //to xcvr instance
  wire [lanes-1:0]    csr_rx_invpolarity;           //to xcvr instance
  wire [lanes-1:0]    csr_rx_set_locktoref;         //to xcvr instance
  wire [lanes-1:0]    csr_rx_set_locktodata;        //to xcvr instance
  wire [lanes-1:0]    csr_rx_enapatternalign;       //to xcvr instance
  wire [lanes-1:0]    csr_rx_bitreversalenable;     //to xcvr instance
  wire [lanes-1:0]    csr_rx_bytereversalenable;    //to xcvr instance
  wire [lanes-1:0]    csr_rx_a1a2size;              //to xcvr instance
  wire [lanes-1:0]    csr_rx_is_lockedtoref;

  // readdata output from both CSR blocks
  wire [31:0]     mgmt_readdata_common;
  
  //reset controller outputs
  wire              reset_controller_pll_powerdown;
  wire  [lanes-1:0] reset_controller_tx_digitalreset;
  wire  [lanes-1:0] reset_controller_tx_analogreset;
  wire  [lanes-1:0] reset_controller_rx_analogreset;
  wire  [lanes-1:0] reset_controller_rx_digitalreset;
  wire  [lanes-1:0] reset_controller_tx_ready;
  wire  [lanes-1:0] reset_controller_rx_ready;

  // Final reset signals
  wire  [lanes-1:0] tx_analogreset_fnl;
  wire  [lanes-1:0] tx_digitalreset_fnl;
  wire  [lanes-1:0] rx_analogreset_fnl;
  wire  [lanes-1:0] rx_digitalreset_fnl;

  //assign  pll_powerdown_fnl   = {plls {csr_pll_powerdown}} ;
  assign  tx_analogreset_fnl  = {lanes{csr_pll_powerdown}} ;
  assign  tx_digitalreset_fnl = csr_tx_digitalreset | {lanes{1'b0}} ;
  assign  rx_analogreset_fnl  = csr_rx_analogreset  | {lanes{1'b0}} ;
  assign  rx_digitalreset_fnl = csr_rx_digitalreset | {lanes{1'b0}} ;

  // assign output wires for status ports - whether or not they are used will be decided by the top level
  assign rx_disperr                = rx_disperr_data;
  assign rx_errdetect              = rx_errdetect_data; 
  assign rx_recovered_clk          = alt_pma_0_rx_recovered_clk_clk;
  assign alt_pma_0_tx_out_clk_clk  = alt_pma_0_tx_out_clk;

  ///////////////////////////////////////////////////////////////////////
  // SyncE support
  ///////////////////////////////////////////////////////////////////////
  generate
    // use cdr_ref_clk for syncE mode and pll_ref_clk otherwise
    if (en_synce_support) begin : SYNCE
        assign cdr_clock = cdr_ref_clk;	
    end else begin : NO_SYNCE
        assign cdr_clock = pll_ref_clk; 
    end
  endgenerate 

  ///////////////////////////////////////////////////////////////////////
  // Decoder for multiple slaves of pma_ch_control,pma_control,hxaui i/f
  ///////////////////////////////////////////////////////////////////////
  alt_xcvr_mgmt2dec_xaui mgmtdec_xaui (
    .mgmt_clk_reset                   (phy_mgmt_clk_reset),
    .mgmt_clk                         (phy_mgmt_clk),
    .mgmt_address                     (phy_mgmt_address),
    .mgmt_read                        (phy_mgmt_read),
    .mgmt_write                       (phy_mgmt_write),
    .mgmt_readdata                    (phy_mgmt_readdata),
    .mgmt_waitrequest                 (phy_mgmt_waitrequest),

    // internal interface to 'top' pma ch controller block
    .sc_pma_ch_controller_readdata    (sc_pma_ch_controller_readdata),
    .sc_pma_ch_controller_waitrequest (sc_pma_ch_controller_waitrequest),
    .sc_pma_ch_controller_address     (sc_pma_ch_controller_address),  //6 bit wide
    .sc_pma_ch_controller_read        (sc_pma_ch_controller_read),
    .sc_pma_ch_controller_write       (sc_pma_ch_controller_write),

    // internal interface to 'top' pma controller block
    .sc_pma_controller_readdata       (sc_pma_controller_readdata),
    .sc_pma_controller_waitrequest    (sc_pma_controller_waitrequest),
    .sc_pma_controller_address        (sc_pma_controller_address), //2 bit wide
    .sc_pma_controller_read           (sc_pma_controller_read),
    .sc_pma_controller_write          (sc_pma_controller_write),
  
    // internal interface to 'top' hxaui csr block
    .sc_csr_readdata                  (sc_csr_readdata),
    .sc_csr_waitrequest               (1'b0), // PCS CSR is always ready
    .sc_csr_address                   (sc_csr_address),    //5 bit wide
    .sc_csr_read                      (sc_csr_read),
    .sc_csr_write                     (sc_csr_write)
  );


  ///////////////////////////////////////////////////////////////////////
  // A10 Native PHY - ALT_PMA
  ///////////////////////////////////////////////////////////////////////
  generate 
    if (interface_type == "Soft XAUI") begin

        a10_xcvr_custom_native alt_pma (
            .tx_analogreset     (tx_analogreset_fnl),       //          tx_analogreset.tx_analogreset
            .tx_digitalreset    (tx_digitalreset_fnl),      //         tx_digitalreset.tx_digitalreset
            .rx_analogreset     (rx_analogreset_fnl),       //          rx_analogreset.rx_analogreset
            .rx_digitalreset    (rx_digitalreset_fnl),      //         rx_digitalreset.rx_digitalreset
            .tx_cal_busy        (tx_cal_busy),              //             tx_cal_busy.tx_cal_busy
            .rx_cal_busy        (rx_cal_busy),              //             rx_cal_busy.rx_cal_busy
            .tx_bonding_clocks  ({lanes{tx_bonding_clocks}}),//       tx_bonding_clocks.clk
            .rx_cdr_refclk0     (cdr_clock),                //          rx_cdr_refclk0.clk
            .tx_serial_data     (xaui_tx_serial_data),      //          tx_serial_data.tx_serial_data
            .rx_serial_data     (xaui_rx_serial_data),      //          rx_serial_data.rx_serial_data
            .rx_set_locktodata  (csr_rx_set_locktodata),
            .rx_set_locktoref   (csr_rx_set_locktoref),
            .rx_seriallpbken    (csr_phy_loopback_serial),
            .rx_is_lockedtoref  (csr_rx_is_lockedtoref),                                 //       rx_is_lockedtoref.rx_is_lockedtoref
            .rx_is_lockedtodata (alt_pma_0_rx_is_lockedtodata_data),//      rx_is_lockedtodata.rx_is_lockedtodata
            .tx_coreclkin       (en_dual_fifo? {4{xgmii_tx_clk}} : alt_pma_0_tx_out_clk),              //            tx_coreclkin.clk
            .rx_coreclkin       ({4{alt_pma_0_rx_recovered_clk_clk[2]}}),   //            rx_coreclkin.clk
            .tx_clkout          (alt_pma_0_tx_out_clk),              //               tx_clkout.clk
            .rx_clkout          (alt_pma_0_rx_recovered_clk_clk),   //               rx_clkout.clk
            .reconfig_clk       (reconfig_clk),            //            reconfig_clk.clk
            .reconfig_reset     (reconfig_reset),          //          reconfig_reset.reset
            .reconfig_write     (reconfig_write),          //           reconfig_avmm.write
            .reconfig_read      (reconfig_read),           //                        .read
            .reconfig_address   (reconfig_address),        //                        .address
            .reconfig_writedata (reconfig_writedata),      //                        .writedata
            .reconfig_readdata  (reconfig_readdata),       //                        .readdata
            .reconfig_waitrequest   (reconfig_waitrequest),         //                        .waitrequest
            .tx_parallel_data   (sxaui_0_tx_parallel_data_data),    //        tx_parallel_data.tx_parallel_data
            .unused_tx_parallel_data(432'h0),                       // unused_tx_parallel_data.unused_tx_parallel_data
            .rx_parallel_data   (alt_pma_0_rx_parallel_data_data),  //        rx_parallel_data.rx_parallel_data
            .rx_patterndetect   (rx_patterndetect),         //        rx_patterndetect.rx_patterndetect
            .rx_syncstatus      (rx_syncstatus),            //           rx_syncstatus.rx_syncstatus
            .unused_rx_parallel_data()                      // unused_rx_parallel_data.unused_rx_parallel_data
	    );
    end else begin
      assign rx_pma_ready = 1'b0;
      assign sxaui_rst_done = 1'b0; // no hard xaui support
    end
  endgenerate

  ///////////////////////////////////////////////////////////////////////
  // Logical OR between tx_cal_busy and pll_cal_busy 
  ///////////////////////////////////////////////////////////////////////
  generate
    for (i=0; i<lanes; i=i+1) begin : cal_busy
        assign rst_tx_cal_busy[i] = tx_cal_busy[i] | pll_cal_busy;
    end
  endgenerate

  ///////////////////////////////////////////////////////////////////////
  // Reset Controller 
  ///////////////////////////////////////////////////////////////////////
  generate if (embedded_reset) begin : gen_embedded_reset

    localparam  RX_PER_CHANNEL = (bonded_group_size == 1);
    wire  [lanes-1:0]   rx_manual_mode;

    // Put reset controller into manual mode when we are not in auto lock mode
    assign  rx_manual_mode = (csr_rx_set_locktoref | csr_rx_set_locktodata);

    // We have a single tx_ready, rx_ready output per IP instance
    assign  tx_ready  = &reset_controller_tx_ready;
    assign  rx_ready  = &reset_controller_rx_ready;

    altera_xcvr_reset_control#(
        .CHANNELS               (lanes          ),  // Number of CHANNELS
        .SYNCHRONIZE_RESET      (0              ),  // (0,1) Synchronize the reset input
        .SYNCHRONIZE_PLL_RESET  (0              ),  // (0,1) Use synchronized reset input for PLL powerdown
                                                    // !NOTE! Will prevent PLL merging across reset controllers
                                                    // !NOTE! Requires SYNCHRONIZE_RESET == 1
        // Reset timings
        .SYS_CLK_IN_MHZ         (mgmt_clk_in_mhz),  // Clock frequency in MHz. Required for reset timers
        .REDUCED_SIM_TIME       (1              ),  // (0,1) 1=Reduced reset timings for simulation
        // PLL options
        .TX_PLL_ENABLE          (TX_ENABLE      ),  // (0,1) Enable TX PLL reset
        .PLLS                   (1              ),  // Number of TX PLLs
        .T_PLL_POWERDOWN        (1000           ),  // pll_powerdown period in ns
        // TX options
        .TX_ENABLE              (TX_ENABLE      ),  // (0,1) Enable TX resets
        .TX_PER_CHANNEL         (0              ),  // (0,1) 1=separate TX reset per channel
        .T_TX_ANALOGRESET       (70000          ),  // tx_analogreset period
        .T_TX_DIGITALRESET      (70000          ),  // tx_digitalreset period (after pll_powerdown)
        .T_PLL_LOCK_HYST        (0              ),  // Amount of hysteresis to add to pll_locked status signal
        // RX options
        .RX_ENABLE              (RX_ENABLE      ),  // (0,1) Enable RX resets
        .RX_PER_CHANNEL         (RX_PER_CHANNEL ),  // (0,1) 1=separate RX reset per channel
        .T_RX_ANALOGRESET       (70000          ),  // rx_analogreset period
        .T_RX_DIGITALRESET      (4000           )   // rx_digitalreset period (after rx_is_lockedtodata)
    ) reset_controller (
      // User inputs and outputs
      .clock            (phy_mgmt_clk       ),  // System clock
      .reset            (phy_mgmt_clk_reset ),  // Asynchronous reset
      // Reset signals
      .pll_powerdown    (reset_controller_pll_powerdown   ),  // reset TX PLL
      .tx_analogreset   (reset_controller_tx_analogreset  ),  // reset TX PMA
      .tx_digitalreset  (reset_controller_tx_digitalreset ),  // reset TX PCS
      .rx_analogreset   (reset_controller_rx_analogreset  ),  // reset RX PMA
      .rx_digitalreset  (reset_controller_rx_digitalreset ),  // reset RX PCS
      // Status output
      .tx_ready         (reset_controller_tx_ready        ),  // TX is not in reset
      .rx_ready         (reset_controller_rx_ready        ),  // RX is not in reset
      // Digital reset override inputs (must by synchronous with clock)
      .tx_digitalreset_or({lanes{csr_reset_tx_digital}} ), // reset request for tx_digitalreset
      .rx_digitalreset_or({lanes{csr_reset_rx_digital}} ), // reset request for rx_digitalreset
      // TX control inputs
      .pll_locked         (pll_locked),                 // TX PLL is locked status
      .pll_select         (1'b0                   ),    // Select TX PLL locked signal 
      .tx_cal_busy        (rst_tx_cal_busy),    // TX channel calibration status
      .tx_manual          ({lanes{1'b1}}          ),    // 1=Manual TX reset mode
      // RX control inputs
      .rx_is_lockedtodata (alt_pma_0_rx_is_lockedtodata_data     ),    // RX CDR PLL is locked to data status
      .rx_cal_busy        (rx_cal_busy            ),    // RX channel calibration status
      .rx_manual          (rx_manual_mode         )     // 1=Manual RX reset mode
    );
  end else begin:gen_no_embedded_reset
    assign  reset_controller_pll_powerdown    = 1'b0;
    assign  reset_controller_tx_digitalreset  = {lanes{1'b0}};
    assign  reset_controller_rx_analogreset   = {lanes{1'b0}};
    assign  reset_controller_rx_digitalreset  = {lanes{1'b0}};
    assign  tx_ready = 1'b0;
    assign  rx_ready = 1'b0;
  end
  endgenerate

  assign pll_powerdown = reset_controller_pll_powerdown;

  ///////////////////////////////////////////////////////////////////////
  // PMA Controller
  ///////////////////////////////////////////////////////////////////////
    alt_pma_controller_tgx #(
      .number_of_plls         (1),
      .sync_depth             (2),
      .tx_pll_reset_hold_time (20)
    ) alt_pma_controller_0 (
      .clk                  (phy_mgmt_clk),                          
      .rst                  (phy_mgmt_clk_reset),                        
      .pma_mgmt_address     (sc_pma_controller_address),   
      .pma_mgmt_read        (sc_pma_controller_read),   
      .pma_mgmt_readdata    (sc_pma_controller_readdata),   
      .pma_mgmt_write       (sc_pma_controller_write),   
      .pma_mgmt_writedata   (phy_mgmt_writedata),     
      .pma_mgmt_waitrequest (sc_pma_controller_waitrequest),   
      .cal_blk_clk          (phy_mgmt_clk),                    
      .cal_blk_pdn          (alt_pma_controller_0_cal_blk_pdn_data),
      .tx_pll_ready         (),                                     
      .gx_pdn               (),     
      .pll_pdn              (alt_pma_controller_0_pll_pdn0_data),
      .pll_locked           (pll_locked)                  
    );


  ///////////////////////////////////////////////////////////////////////
  // PCS CSR 
  ///////////////////////////////////////////////////////////////////////
   // following for XAUI, SOFT XAUI needs this
   assign alt_pma_ch_controller_0_tx_digital_rst_data = csr_tx_digitalreset;
   assign alt_pma_ch_controller_0_rx_digital_rst_data = csr_rx_digitalreset;
   
  // Instantiate memory map logic for given number of lanes & PLL's
  // Includes all except PCS
  alt_xcvr_csr_common #(
    .lanes  (lanes),
    .plls   (plls ),
    .rpc    (1    )
  ) csr (
    .clk                              (phy_mgmt_clk                     ),
    .reset                            (phy_mgmt_clk_reset               ),
    .address                          (8'h40 | sc_pma_ch_controller_address),
    .read                             (sc_pma_ch_controller_read        ),
    .write                            (sc_pma_ch_controller_write       ),
    .writedata                        (phy_mgmt_writedata               ),
    .pll_locked                       (pll_locked                       ),
    .rx_is_lockedtoref                (csr_rx_is_lockedtoref            ),
    .rx_is_lockedtodata               (alt_pma_0_rx_is_lockedtodata_data),
    .rx_signaldetect                  ({lanes{1'b0}}                    ),
    .reset_controller_tx_ready        (tx_ready                         ),
    .reset_controller_rx_ready        (rx_ready                         ),
    .reset_controller_pll_powerdown   (reset_controller_pll_powerdown   ),
    .reset_controller_tx_digitalreset (reset_controller_tx_digitalreset ),
    .reset_controller_rx_analogreset  (reset_controller_rx_analogreset  ),
    .reset_controller_rx_digitalreset (reset_controller_rx_digitalreset ),
    .readdata                         (mgmt_readdata_common             ),
    .csr_reset_tx_digital             (csr_reset_tx_digital             ),
    .csr_reset_rx_digital             (csr_reset_rx_digital             ),
    .csr_reset_all                    (csr_reset_all                    ),
    .csr_pll_powerdown                (csr_pll_powerdown                ),
    .csr_tx_digitalreset              (csr_tx_digitalreset              ),
    .csr_rx_analogreset               (csr_rx_analogreset               ),
    .csr_rx_digitalreset              (csr_rx_digitalreset              ),
    .csr_phy_loopback_serial          (csr_phy_loopback_serial          ),
    .csr_rx_set_locktoref             (csr_rx_set_locktoref             ),
    .csr_rx_set_locktodata            (csr_rx_set_locktodata            )
  );

  // generate waitrequest for 'top' channel
  altera_wait_generate top_wait (
    .rst            (phy_mgmt_clk_reset   ),
    .clk            (phy_mgmt_clk         ),
    .launch_signal  (sc_pma_ch_controller_read        ),
    .wait_req       (sc_pma_ch_controller_waitrequest )
  );

  // combine readdata output from both CSR blocks
  // each decodes non-overlapping addresses, and outputs "11..111" for undecoded addresses,
  // so an AND is sufficient
  assign sc_pma_ch_controller_readdata = mgmt_readdata_common;


  ///////////////////////////////////////////////////////////////////////
  // HXAUI CSR
  ///////////////////////////////////////////////////////////////////////
  hxaui_csr hxaui_csr (
    .clk                      (phy_mgmt_clk),
    .reset                    (phy_mgmt_clk_reset),
    .address                  (sc_csr_address),
    .byteenable               (4'b1111),   // .byteenable (Tie byteenable to all 1s)
    .read                     (sc_csr_read),
    .readdata                 (sc_csr_readdata),
    .write                    (sc_csr_write),
    .writedata                (phy_mgmt_writedata),
    .rx_patterndetect         (8'b0), // not supported by soft PCS
    .rx_syncstatus            (rx_syncstatus),
    .rx_runningdisp           (8'b0), // not supported by soft PCS
    .rx_errdetect             (rx_errdetect_data),
    .rx_disperr               (rx_disperr_data),
    .rx_phase_comp_fifo_error (4'b0), // not supported by soft PCS
    .rx_rlv                   (4'b0), // not supported by soft PCS
    .rx_rmfifodatadeleted     (8'b0), // not supported by soft PCS
    .rx_rmfifodatainserted    (8'b0), // not supported by soft PCS
    .rx_rmfifoempty           (4'b0), // not supported by soft PCS
    .rx_rmfifofull            (4'b0), // not supported by soft PCS
    .tx_phase_comp_fifo_error (4'b0), // not supported by soft PCS
    .r_rx_invpolarity         (),     // not supported by soft PCS
    .r_tx_invpolarity         (),     // not supported by soft PCS
    .r_rx_digitalreset        (hxaui_csr_r_rx_digitalreset_data),
    .r_tx_digitalreset        (hxaui_csr_r_tx_digitalreset_data),
    .simulation_flag          (hxaui_csr_simulation_flag_data) // only for soft_xaui
  );


  ///////////////////////////////////////////////////////////////////////
  // SXAUI - Interface to soft PCS 
  ///////////////////////////////////////////////////////////////////////
  generate
    if (interface_type == "Soft XAUI") begin
      sxaui #(
        .starting_channel_number      (0),
        .xaui_pll_type                (xaui_pll_type),
        .use_control_and_status_ports (use_control_and_status_ports),
        .soft_pcs_legacy_new_n        (soft_pcs_legacy_new_n),
        .disable_embedded_sdc         (disable_embedded_sdc)
      ) sxaui_0 (
        .xgmii_tx_clk       (xgmii_tx_clk),                      // xgmii_tx_clk.clk
        .xgmii_tx_dc        (xgmii_tx_dc),                       // xgmii_tx_dc.data
        .xgmii_rx_clk       (xgmii_rx_clk),                      // xgmii_rx_clk.clk
        .xgmii_rx_dc        (xgmii_rx_dc),                       // xgmii_rx_dc.data
        .refclk             (pll_ref_clk),                       // refclk.clk
        .mgmt_clk           (phy_mgmt_clk),                      // mgmt_clk.clk
        .tx_out_clk         (en_dual_fifo? {4{xgmii_rx_inclk}} : alt_pma_0_tx_out_clk_clk),          // tx_out_clk.clk
        .rx_recovered_clk   ({4{alt_pma_0_rx_recovered_clk_clk[2]}}),    // rx_recovered_clk.clk
        .tx_parallel_data   (sxaui_0_tx_parallel_data_data),     // tx_parallel_data.data
        .rx_parallel_data   (alt_pma_0_rx_parallel_data_data),   // rx_parallel_data.data
        .rx_is_lockedtodata (alt_pma_0_rx_is_lockedtodata_data), // rx_is_lockedtodata.data
        .rx_digitalreset    (alt_pma_ch_controller_0_rx_digital_rst_data[0] ),                   // rx_digitalreset.from alt_pma
        .tx_digitalreset    (alt_pma_ch_controller_0_tx_digital_rst_data[0] ),                   // tx_digitalreset.from alt_pma
        .pll_locked         (pll_locked),                       // pll_locked.data
        .hard_pcs_rx_syncstatus (rx_syncstatus),                // rx_syncstatus.data
        .rx_channelaligned  (rx_channelaligned),                 // rx_channelaligned.data
        .rx_disperr         (rx_disperr_data),                   // rx_disperr.data
        .rx_errdetect       (rx_errdetect_data),                 // rx_errdetect.data
        .r_rx_digitalreset  (hxaui_csr_r_rx_digitalreset_data),  // r_rx_digitalreset.data
        .r_tx_digitalreset  (hxaui_csr_r_tx_digitalreset_data),  // r_tx_digitalreset.data
        .pma_stat_rst_done  (sxaui_rst_done),                    // soft reset done
        .simulation_flag    (hxaui_csr_simulation_flag_data)     // simulation_flag.data
      );
    end
  endgenerate

endmodule
