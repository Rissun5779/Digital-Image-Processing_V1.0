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



// baeckler - 6-15-2011
// Juzhang  - 6-01-2012

`timescale 1 ps / 1 ps

// import altera_xcvr_functions::*;

module ilk_core #(
   // Default PCS settings (12L10G)
   // Can be "Stratix V" , "Arria V GZ"; or "Arria 10";
   parameter FAMILY              = "Stratix V",   
   parameter USE_ATX             = 1,
   parameter DATA_RATE           = "12500.0 Mbps",
   parameter PLL_OUT_FREQ        = "6250.0 MHz",           // CAREFUL!! : this is MHz, not MBPS, typically 1/2 data rate
   parameter PLL_REFCLK_FREQ     = "312.5 MHz",
   parameter INT_TX_CLK_DIV      = 1,                       // CGB TX clock divider, typically 1
   parameter LANE_PROFILE        = 24'b000000_000000_111111_111111,
   parameter NUM_LANES           = 12,                      // !!!no override without other edits
   parameter NUM_SIXPACKS        = 2,
   parameter RX_PKTMOD_ONLY      = 0,                       // If set to 1, receiver expect traffic from transmit is packet based with burstmin/burstshort 32 byte up.
                                                            // If set to 0, receiver expect traffic from transmit is interleaved or packet mode with burstmin nx64.
   parameter TX_PKTMOD_ONLY      = 1,                       // If set to 1, itx_sob/itx_eob will be ignored and use internal enhance scheduling for insert control word.
                                                            // If set to 0, user is responsible to provide itx_sob/itx_eob for instructing Interlaken core where to insert control word.
   parameter TX_ONLY_MODE        = 1'b0,                    // If set to 1, don't wait for RX lanes to align before enabling TX path
   parameter RX_DUAL_SEG         = 1,
   parameter ECC_ENABLE          = 0,  
   parameter TX_DUAL_SEG         = 1,
   parameter RXFIFO_ADDR_WIDTH   = 12,                      // 12 is 32K byte deep FIFO
   parameter CALENDAR_PAGES      = 16,
   parameter LOG_CALENDAR_PAGES  = 4,
   parameter INCLUDE_TEMP_SENSE  = 1'b0,
   parameter METALEN             = 64,                      // Set low for fast simulation time. 2048 for hardware test.
   parameter SCRAM_CONST         = 58'hdeadbeef123,         // if user instantiate more than one interlaken, this number need to be different to reduce cross talk.
   parameter INTERNAL_WORDS      = 8,
   parameter RT_BUFFER_SIZE      = 15000,                   // Byte counts of Retransmission buffer size.
   // Reconfiguration bundles
   parameter W_BUNDLE_TO_XCVR    = 70,
   parameter W_BUNDLE_FROM_XCVR  = 46,
   parameter MM_CLK_KHZ          = 20'd100000,              // management clock range is restricted to 100 to 125 MHz by hard logic
   parameter MM_CLK_MHZ          = 28'd100000000,           // If mm_clk set to 125, both value need to change
   parameter ERR_HANDLER_ON      = 1,                       //Turn on Error handler block.
   parameter INBAND_FLW_ON       = 1,
   parameter DIAG_ON             = 0,
   parameter RECONF_ADDR         = (NUM_LANES == 24) ? 5 :(NUM_LANES == 12) ? 4 : (NUM_LANES == 8) ? 3 : 0
)(
   input                               tx_usr_clk,          // 300Mhz user clock
   input                               rx_usr_clk,          // 300Mhz user clock.
   input                               reset_n,
   input                               pll_ref_clk,         // Check with release document for proper value
   input               [NUM_LANES-1:0] rx_pin,
   output              [NUM_LANES-1:0] tx_pin,
   output              [NUM_LANES-1:0] sync_locked,         // Generated with rx_usr_clk
   output              [NUM_LANES-1:0] word_locked,         // Generated with rx_usr_clk
   output                              rx_lanes_aligned,    // Generated with rx_usr_clk.
   output                              tx_lanes_aligned,    // Generated with tx_usr_clk.
   input       [64*INTERNAL_WORDS-1:0] itx_din_words,       // The following signals sync with tx_usr_clk
   input                         [7:0] itx_num_valid,       // [7:4] aligned with MSB. [3:0] aligned with middle.
   input                         [7:0] itx_chan,            // Channel number. Only need to be valid during SOP/SOB cycle.
   input                         [1:0] itx_sop,             // itx_sop[1] Start of the packet. MSB aligned. itx_sop[0] for dual segment.
   input                         [3:0] itx_eopbits,         // Number of valid byte in the last word. 4'b1000 is 8 byte,1001,1010 one/two byte
   input                         [1:0] itx_sob,             // itx_sob[0] is for dual segment.
   input                               itx_eob,
   input       [CALENDAR_PAGES*16-1:0] itx_calendar,        // Tie to all 1. zero is XOFF, 1 is XON
                                                            // If you want to disable this feature, tie all high!!!!!
   input                         [3:0] burst_max_in,        // Static input. In multiple of 64 byte. 2: 128 byte, 4: 256 byte.
   input                         [3:0] burst_short_in,      // Static input. In multiple of 32 byte. 1: 32  byte, 2: 64 byte.
   input                         [3:0] burst_min_in,        // Static input. In multiple of 32 byte. 1: 32  byte, 2: 64 byte.
   output reg                          itx_ready,           // Sync with tx_usr_clk up to 4 cycle grace period.
   output                              itx_hungry,          // Sync with tx_usr_clk
   output                              itx_overflow,        // Sync with tx_usr_clk
   output                              itx_underflow,       // Sync with tx_usr_clk
   output                              itx_ifc_err,         // Sync with tx_usr_clk    illegal traffic pattern at tx interface.
   output wire                         crc24_err,           // Generated with rx_usr_clk
   output wire         [NUM_LANES-1:0] crc32_err,           // Generated with rx_usr_clk
   output wire                         clk_tx_common,       // Tx lane clock.
   output wire                         srst_tx_common,      // When this is low, it indicates tx PCS is out of reset.
   output wire                         clk_rx_common,       // Rx lane clock. 257.8 Mhz. It clocked tx pcs/mac.
   output wire                         srst_rx_common,      // When this is low, it indicates RX PCS logic is out of reset.
   output                              tx_mac_srst,         // When this is low, it indicates TX Mac logic is out of reset.
   output                              rx_mac_srst,         // When this is low, it indicates RX Mac logic is out of reset.
   output                              tx_usr_srst,         // When this is low, it indicates TX user logic is out of reset.
   output                              rx_usr_srst,         // When this is low, it indicates RX user logic is out of reset.

   output      [64*INTERNAL_WORDS-1:0] irx_dout_words,      // The following is generated with rx_usr_clock
   output                        [7:0] irx_num_valid,       // [7:4] aligned with MSB. [3:0] aligned with middle
   output                        [1:0] irx_sop,             // irx_sop[0] is for Dual SOB mode
   output                        [1:0] irx_sob,             // irx_sob[0] is for Dual SOB mode. Start of the burst.
   output                              irx_eob,             // end of the burst
   output                        [7:0] irx_chan,            // Channel number. Only valid during SOP or SOB cycles.
   output                        [3:0] irx_eopbits,         // Number of the valid bytes.
   output                              irx_err,             // error inidication from the interlaken core

   output      [CALENDAR_PAGES*16-1:0] irx_calendar,        // Calendar bits passed from transmit side. high is XON, low is XOFF.
   output                              irx_overflow,        // Receiver cross domain buffer overflow.
   output                              rdc_overflow,        // Smooth domain fifo overflow
   output                              rg_overflow,         // Receiver buffer overflow.
   output      [RXFIFO_ADDR_WIDTH-1:0] rxfifo_fill_level,   // The fill level of receiver buffer in word.

   // Signals to do PCS control/status
   input                               mm_clk,              // 100 ~125 MHz
   input                               mm_read,
   input                               mm_write,
   input                        [15:0] mm_addr,
   output reg                   [31:0] mm_rdata,
   output reg                          mm_rdata_valid,
   input                        [31:0] mm_wdata,

   // Signals to increment debug counters, indicate errors
   output reg                          sop_cntr_inc,
   output reg                          eop_cntr_inc,
   // For Arria 10
   output                              tx_pll_powerdown,
   input                               tx_pll_locked,
   input       [NUM_LANES-1:0]         tx_serial_clk,

   input                               reconfig_clk,
   input                               reconfig_reset,
   input                               reconfig_write,
   input                               reconfig_read,
   input       [RECONF_ADDR+9:0]       reconfig_address,
   input       [31: 0]                 reconfig_writedata,
   output      [31: 0]                 reconfig_readdata,
   output                              reconfig_waitrequest
 
);

  //ilk_dcore outputs
    wire     [NUM_LANES-1:0]          local_serial_loopback; 
    wire                              rx_set_locktodata;    
    wire                              rx_set_locktoref;    
    wire                              soft_rst_rx;        
    wire     [NUM_LANES*128-1:0]      tx_din_np;         
    wire                              tx_common;        
    wire                              rx_common;       
    wire     [NUM_LANES*18-1:0]       tx_control_np;     
    wire                              tx_valid;     
    wire                              tx_force_fill;     
    wire                              fake_tx_fifo_write;  
    wire                              rx_cadence;         
    wire                              rx_fifo_clr;       
    wire                              tx_from_fifo;     
    wire                              rx_prbs_err_clr; 
    wire                              system_reset;   
    wire                              soft_rst_txrx;  
    wire     [NUM_LANES-1:0]          rx_is_lockedtodata;     
  //phy outputs
    wire      [NUM_LANES-1:0]          tx_cal_busy;       
    wire      [NUM_LANES-1:0]          rx_cal_busy;       
    wire      [NUM_LANES*128-1:0]      rx_dout_np;       
    wire      [NUM_LANES-1:0]          tx_clkout;       
    wire      [NUM_LANES-1:0]          rx_clkout;      
    wire      [NUM_LANES*20-1:0]       rx_control_np; 
    wire      [NUM_LANES-1:0]          tx_full;      
    wire      [NUM_LANES-1:0]          tx_pfull;    
    wire      [NUM_LANES-1:0]          tx_empty;   
    wire      [NUM_LANES-1:0]          tx_pempty;        
    wire      [NUM_LANES-1:0]          rx_valid_np;     
    wire      [NUM_LANES-1:0]          rx_full;        
    wire      [NUM_LANES-1:0]          rx_pfull;      
    wire      [NUM_LANES-1:0]          rx_empty;     
    wire      [NUM_LANES-1:0]          rx_pempty;   
    wire      [NUM_LANES-1:0]          rx_wordlock;
    wire      [NUM_LANES-1:0]          rx_metalock;     
    wire      [NUM_LANES-1:0]          rx_crc32err;    
    wire      [NUM_LANES-1:0]          tx_frame;     
    wire      [NUM_LANES-1:0]          rx_prbs_err;   
    wire      [NUM_LANES-1:0]          rx_prbs_done;
  //reset contrl outputs
    wire      [NUM_LANES-1:0]          tx_analogreset;   
    wire      [NUM_LANES-1:0]          tx_digitalreset; 
    wire      [NUM_LANES-1:0]          rx_analogreset;   
    wire      [NUM_LANES-1:0]          rx_digitalreset; 
  
//////////////////////////////////////////////
// ilk digital core 
//////////////////////////////////////////////
  ilk_dcore #(
    .FAMILY             ("Arria 10"),
    .DATA_RATE          (DATA_RATE),
    .RX_PKTMOD_ONLY     (RX_PKTMOD_ONLY),    
    .TX_PKTMOD_ONLY     (TX_PKTMOD_ONLY),   
    .RXFIFO_ADDR_WIDTH  (RXFIFO_ADDR_WIDTH),  
    .NUM_LANES          (NUM_LANES),         
    .CALENDAR_PAGES     (CALENDAR_PAGES),       
    .LOG_CALENDAR_PAGES (LOG_CALENDAR_PAGES),  
    .INCLUDE_TEMP_SENSE (INCLUDE_TEMP_SENSE),
    .RX_DUAL_SEG        (RX_DUAL_SEG),	
    .TX_DUAL_SEG        (TX_DUAL_SEG),	
    .METALEN            (METALEN),           
    .ECC_ENABLE         (ECC_ENABLE),       
    .SCRAM_CONST        (SCRAM_CONST),     
    .MM_CLK_KHZ         (MM_CLK_KHZ),     
    .MM_CLK_MHZ         (MM_CLK_MHZ),    
    .INTERNAL_WORDS     (INTERNAL_WORDS),  
    .INBAND_FLW_ON      (INBAND_FLW_ON),
    .ERR_HANDLER_ON     (ERR_HANDLER_ON),
    .DIAG_ON            (DIAG_ON),
    .RT_BUFFER_SIZE     (RT_BUFFER_SIZE)  
  ) ilk_dcore_inst (
    .tx_usr_clk          (tx_usr_clk),             //  input
    .rx_usr_clk          (rx_usr_clk),             //  input
    .pll_ref_clk         (pll_ref_clk),             //  input
    .tx_pll_locked       (tx_pll_locked),          //  input
    .reset_n             (reset_n),                //  input
    .sync_locked         (sync_locked),            //  output [NUM_LANES-1:0]
    .word_locked         (word_locked),            //  output [NUM_LANES-1:0]
    .rx_lanes_aligned    (rx_lanes_aligned),       //  output
    .tx_lanes_aligned    (tx_lanes_aligned),       //  output
    .itx_din_words       (itx_din_words),          //  input  [64*INTERNAL_WORDS-1:0]
    .itx_num_valid       (itx_num_valid),          //  input  [7:0]
    .itx_chan            (itx_chan),               //  input  [7:0]
    .itx_sop             (itx_sop),                //  input  [1:0]
    .itx_eopbits         (itx_eopbits),            //  input  [3:0]
    .itx_sob             (itx_sob),                //  input  [1:0]
    .itx_eob             (itx_eob),                //  input
    .itx_calendar        (itx_calendar),           //  input  [CALENDAR_PAGES*16-1:0]
    .burst_max_in        (burst_max_in),           //  input  [3:0]
    .burst_short_in      (burst_short_in),         //  input  [3:0]
    .burst_min_in        (burst_min_in),           //  input  [3:0]
    .itx_ready           (itx_ready),              //  output
    .itx_hungry          (itx_hungry),             //  output
    .itx_overflow        (itx_overflow),           //  output
    .itx_underflow       (itx_underflow),          //  output
    .itx_ifc_err         (itx_ifc_err),            //  output
    .crc24_err           (crc24_err),              //  output
    .crc32_err           (crc32_err),              //  output [NUM_LANES-1:0]
    .clk_tx_common       (clk_tx_common),          //  output
    .srst_tx_common      (srst_tx_common),         //  output
    .clk_rx_common       (clk_rx_common),          //  output
    .srst_rx_common      (srst_rx_common),         //  output
    .tx_mac_srst         (tx_mac_srst),            //  output
    .rx_mac_srst         (rx_mac_srst),            //  output
    .tx_usr_srst         (tx_usr_srst),            //  output
    .rx_usr_srst         (rx_usr_srst),            //  output
    .irx_dout_words      (irx_dout_words),         //  output [64*INTERNAL_WORDS-1:0]
    .irx_num_valid       (irx_num_valid),          //  output [7:0]
    .irx_sop             (irx_sop),                //  output [1:0]
    .irx_sob             (irx_sob),                //  output [1:0]
    .irx_eob             (irx_eob),                //  output
    .irx_chan            (irx_chan),               //  output [7:0]
    .irx_eopbits         (irx_eopbits),            //  output [3:0]
    .irx_err             (irx_err),                //  output
    .irx_calendar        (irx_calendar),           //  output [CALENDAR_PAGES*16-1:0]
    .irx_overflow        (irx_overflow),           //  output
    .rdc_overflow        (rdc_overflow),           //  output
    .rg_overflow         (rg_overflow),            //  output
    .rxfifo_fill_level   (rxfifo_fill_level),      //  output [RXFIFO_ADDR_WIDTH-1:0]
    .mm_clk              (mm_clk),                 //  input
    .mm_read             (mm_read),                //  input
    .mm_write            (mm_write),               //  input
    .mm_addr             (mm_addr),                //  input  [15:0]
    .mm_rdata            (mm_rdata),               //  output [31:0]
    .mm_rdata_valid      (mm_rdata_valid),         //  output
    .mm_wdata            (mm_wdata),               //  input  [31:0]
    .sop_cntr_inc        (sop_cntr_inc),           //  output
    .eop_cntr_inc        (eop_cntr_inc),           //  output
     //Native PHY interface
     .local_serial_loopback (local_serial_loopback),
     .rx_set_locktodata     (rx_set_locktodata),
     .rx_set_locktoref      (rx_set_locktoref),
     .soft_rst_rx           (soft_rst_rx),
     .rx_is_lockedtodata    (rx_is_lockedtodata),
     .rx_dout_np            (rx_dout_np),
     .tx_valid              (tx_valid),
     .tx_din_np             (tx_din_np),
     .tx_common             (tx_common),
     .rx_common             (rx_common),
     .tx_clkout             (tx_clkout),
     .rx_clkout             (rx_clkout),
     .tx_control_np         (tx_control_np),
     .rx_control_np         (rx_control_np),
     .tx_force_fill         (tx_force_fill),
     .fake_tx_fifo_write    (fake_tx_fifo_write),
     .tx_full               (tx_full),
     .tx_pfull              (tx_pfull),
     .tx_empty              (tx_empty),
     .tx_pempty             (tx_pempty),
     .rx_cadence            (rx_cadence),
     .rx_valid_np           (rx_valid_np),
     .rx_full               (rx_full),
     .rx_pfull              (rx_pfull),
     .rx_empty              (rx_empty),
     .rx_pempty             (rx_pempty),
     .rx_fifo_clr           (rx_fifo_clr),
     .word_locked_pcsclk    (rx_wordlock),
     .sync_locked_pcsclk    (rx_metalock),
     .crc32_err_pcsclk      (rx_crc32err),
     .tx_frame              (tx_frame),
     .tx_from_fifo          (tx_from_fifo),
     .rx_prbs_err_clr       (rx_prbs_err_clr),
     .rx_prbs_err           (rx_prbs_err),
     .rx_prbs_done          (rx_prbs_done),
     //Reset Controller interface
     .system_reset          (system_reset),
     .soft_rst_txrx         (soft_rst_txrx),
     .tx_digitalreset_0     (|tx_digitalreset),
     .rx_digitalreset_0     (|rx_digitalreset)
  ); //ilk_dcore

//////////////////////////////////////////////
// altera_native_phy IP 
//////////////////////////////////////////////

   np np_inst (
      // xcvr_reset_cntl interface ports
      .tx_analogreset            (tx_analogreset),  
      .tx_digitalreset           (tx_digitalreset),
      .rx_analogreset            (rx_analogreset), 
      .rx_digitalreset           (rx_digitalreset),
      .tx_cal_busy               (tx_cal_busy),          
      .rx_cal_busy               (rx_cal_busy),         

      //clk signals  
      .rx_cdr_refclk0            (pll_ref_clk), 
      .tx_serial_clk0            (tx_serial_clk),    

      // TX and RX serial ports
      .tx_serial_data            (tx_pin),    
      .rx_serial_data            (rx_pin),

      // control ports
      .rx_seriallpbken           (local_serial_loopback),
      .rx_set_locktodata         ({ NUM_LANES{ rx_set_locktodata }}), 
      .rx_set_locktoref          ({ NUM_LANES{ rx_set_locktoref }}), 

      //status output
      .rx_is_lockedtoref         (),  //no use    
      .rx_is_lockedtodata        (rx_is_lockedtodata), 

      //parallel data ports
      .tx_parallel_data          (tx_din_np),
      .rx_parallel_data          (rx_dout_np), 

      //clock ports
      .tx_coreclkin              ({NUM_LANES{tx_common}}),   
      .rx_coreclkin              ({NUM_LANES{rx_common}}),  
      .tx_clkout                 (tx_clkout),  
      .rx_clkout                 (rx_clkout), 

      // data control
      .tx_control                ({tx_control_np}),  
      .rx_control                (rx_control_np), 

      // TxFIFO/RxFIFO
      .tx_enh_data_valid         ({NUM_LANES{tx_valid | tx_force_fill | fake_tx_fifo_write}}),  
      .tx_enh_frame_diag_status  ({NUM_LANES{2'b11}}),  
      .tx_enh_fifo_full          (tx_full), 
      .tx_enh_fifo_pfull         (tx_pfull),  
      .tx_enh_fifo_empty         (tx_empty),  
      .tx_enh_fifo_pempty        (tx_pempty),    
      .tx_enh_fifo_cnt           (),            // no use 

      .rx_enh_fifo_rd_en         ({NUM_LANES{rx_cadence}}),
      .rx_enh_data_valid         (rx_valid_np),   
      .rx_enh_fifo_full          (rx_full),  
      .rx_enh_fifo_pfull         (rx_pfull),
      .rx_enh_fifo_empty         (rx_empty), 
      .rx_enh_fifo_pempty        (rx_pempty), 
      .rx_enh_fifo_align_val     (),           //no use 
      .rx_enh_fifo_align_clr     ({NUM_LANES{rx_fifo_clr}}),  

      .rx_enh_blk_lock           (rx_wordlock),  
      .rx_enh_frame_lock         (rx_metalock),    
      .rx_enh_crc32_err          (rx_crc32err),   

      // Frame generator
      .tx_enh_frame              (tx_frame),    
      .tx_enh_frame_burst_en     ({NUM_LANES{tx_from_fifo}}),    
    
      // PRBS
      .rx_prbs_err_clr           ({NUM_LANES{rx_prbs_err_clr}}),
      .rx_prbs_err               (rx_prbs_err),
      .rx_prbs_done              (rx_prbs_done),
           
      // Reconfig interface ports
      .reconfig_clk              (reconfig_clk),
      .reconfig_reset            (reconfig_reset),
      .reconfig_write            (reconfig_write),
      .reconfig_read             (reconfig_read),
      .reconfig_address          (reconfig_address),
      .reconfig_writedata        (reconfig_writedata),
      .reconfig_readdata         (reconfig_readdata),
      .reconfig_waitrequest      (reconfig_waitrequest)
   ); // native phy

//////////////////////////////////////////////
// altera_xcvr_reset_control IP 
//////////////////////////////////////////////

   reset_control_a10 altera_xcvr_reset_control_inst  (
      .clock              ( mm_clk ),
      .reset              ( system_reset | soft_rst_txrx ),

      //Reset signal output 
      .pll_powerdown      ( tx_pll_powerdown ),
      .tx_analogreset     ( tx_analogreset ),
      .tx_digitalreset    ( tx_digitalreset ),
      .rx_analogreset     ( rx_analogreset ),
      .rx_digitalreset    ( rx_digitalreset ),

      //Status output
      .tx_ready           ( ),   // no use
      .rx_ready           ( ),   // no use

      //TX control inputs
      // begin reset after pll_locked deasserted
      .pll_locked         ( tx_pll_locked ),   //fix me
      .pll_select         ( 1'b0 ),
      .tx_cal_busy        ( tx_cal_busy ),

      //RX control inputs
      // begin reset after rx_is_lockedtodata is deasserted
      .rx_is_lockedtodata ( rx_is_lockedtodata & { NUM_LANES{~soft_rst_rx }} ),
      .rx_cal_busy        ( rx_cal_busy )

   ); //altera_xcvr_reset_control

endmodule
