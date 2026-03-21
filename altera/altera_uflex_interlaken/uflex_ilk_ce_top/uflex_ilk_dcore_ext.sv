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


// (C) 2001-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.

//This core is the uflex_ilk_core with regroup (4 word, 8 word and 16 word.)
//Transmit side is allowed to have multiple segment. Receiver side the sop aligned
//Juzhang 06-12-2015

`timescale 1 ns / 1 ps
module uflex_ilk_dcore_ext #(
  parameter DEVICE_FAMILY      = "Arria 10",    // Stratix V or Arria 10
  parameter SIM_MODE           = 0,             // If set to 1, METALEN shall be overriden to 128 in simulation
  parameter METALEN            = 2048,          // 
  parameter PMA_WIDTH          = 32,            // 32 or 40
  parameter TXFIFO_PEMPTY      = 2,             // partial empty threshold for TX PCS FIFO
  parameter MM_CLK_KHZ         = 20'd100000,    // management clock range is restricted to 100 to 125 MHz by hard logic
  parameter MM_CLK_MHZ         = 28'd100000000, // Not Use. If mm_clk set to 125, both value need to change
  parameter ILA_MODE           = 0,             // 1: ILA mode 0: ILK mode
  parameter STRIPER            = 1,             // 0: non-striper mode (# of lane : # of segment == 1:1) 1:striper mode
  parameter NUM_LANES          = 4,             // number of lanes
  parameter INTERNAL_WORDS     = 12,            // number of segment (words) in the raw interface 4/8/12
  parameter CALENDAR_PAGES     = 1,             // number of inband flow control 16-bit calendar pages
  parameter LOG_CALENDAR_PAGES = 0,             // the width of the internal counter htat tracks the current calendar page
  parameter ERR_HANDLER_ON     = 1,             // If this is 1, CRC24 error will be aligned with EOB at user interface
  parameter TX_ERR_INJ_EN      = 0,             // inject MAC level error at uflex_ilk_tx.
  parameter INBAND_FLW_ON       = 1,
  parameter IBFC_ERR           = 1,             // Instantiates the Ibfc err handler module at uflex_ilk_rx.

  // paramters for componet extension
  parameter RX_DUAL_SEG        = 0,             // 
  parameter TX_DUAL_SEG        = 0,             // 
  parameter TX_PKTMOD_ONLY     = 0,             // 
  parameter EXTERNAL_WORDS     = 16,            // number of segment (words) in the user interface
  parameter LOG_EXTERNAL_WORDS = (EXTERNAL_WORDS == 4 ) ? 3 :
                                 (EXTERNAL_WORDS == 8 ) ? 4 : 5,
  parameter DUAL               = 1,
  parameter RXFIFO_ADDR_WIDTH  = (EXTERNAL_WORDS == 4 ) ? 11 :
                                 (EXTERNAL_WORDS == 8 ) ? 12 : 13,
  parameter ECC_ENABLE         = 0,
  parameter WRAM_NUM_DUP       = 1,
  parameter MLAB_ADDR_WIDTH    = 5,               //default is 32 entries
  parameter FULL_THRESHOLD     = 0,               //0:8 1:16 entries left
  parameter IDLE_THRESHOLD     = (EXTERNAL_WORDS == 4) ? 0 : 1, //0:low 4 high 8;1:low 8 high;2:low 16 high 24
  parameter M20K_ADDR_WIDTH    = (EXTERNAL_WORDS == 4) ? 5 : 6, //default is 64 entries
  parameter TX_CREDIT_LATENCY  = (EXTERNAL_WORDS == 16) ? 12+ECC_ENABLE : 11+ECC_ENABLE //latency between tx_credit and tx_valid
)(
  // Clock and reset
  input                                pll_ref_clk,
  input                                reset_n,
  input                                tx_pll_locked,

  input                                tx_clk,
  output                               tx_srst,
  output                               clk_tx_common,
  input                                rx_clk,
  output                               rx_srst,
  output                               clk_rx_common,

  // Burst config
  input  [3:0]                         burst_max_in,  // Static input. In multiple of 64 byte. 2: 128 byte, 4: 256 byte.
  input  [3:0]                         burst_min_in,  // Static input. In multiple of 32 byte. 1: 32  byte, 2: 64 byte.
  input  [3:0]                         burst_short_in, // Static input. In multiple of 32 byte. 1: 32  byte, 2: 64 byte.

  // TX User interface
  input  [EXTERNAL_WORDS*64-1:0]       tx_data,      // The following is generated with tx_usr_clock
  input  [LOG_EXTERNAL_WORDS*DUAL-1:0] tx_num_valid, // [7:4] aligned with MSB. [3:0] aligned with middle
  input  [DUAL-1:0]                    tx_sop,       // tx_sop[0] is for Dual SOB mode
  input  [DUAL-1:0]                    tx_sob,       // tx_sob[0] is for Dual SOB mode. Start of the burst.
  input                                tx_eob,       // end of the burst
  input  [7:0]                         tx_chan,      // Channel number. Only valid during SOP or SOB cycles.
  input  [3:0]                         tx_eopbits,   // Number of the valid bytes.
  output                               tx_ready,
  input  [CALENDAR_PAGES*16-1:0]       tx_calendar,

  // RX User Interface
  output [EXTERNAL_WORDS*64-1:0]       rx_data,      // The following is generated with rx_usr_clock
  output [LOG_EXTERNAL_WORDS*DUAL-1:0] rx_num_valid, // [7:4] aligned with MSB. [3:0] aligned with middle
  output [DUAL-1:0]                    rx_sop,       // irx_sop[0] is for Dual SOB mode
  output [DUAL-1:0]                    rx_sob,       // irx_sob[0] is for Dual SOB mode. Start of the burst.
  output                               rx_eob,       // end of the burst
  output [7:0]                         rx_chan,      // Channel number. Only valid during SOP or SOB cycles.
  output [3:0]                         rx_eopbits,   // Number of the valid bytes.
  output                               rx_crc24_err, // error inidication from the interlaken core
  output [CALENDAR_PAGES*16-1:0]       rx_calendar,

  // Miscellaneous signals
  output                               tx_lanes_aligned,
  output                               rx_lanes_aligned,
  output [NUM_LANES-1:0]               word_locked,
  output [NUM_LANES-1:0]               sync_locked,
  output [NUM_LANES-1:0]               rx_crc32_err,
  output                               tx_overflow,
  output                               tx_underflow,
  output [RXFIFO_ADDR_WIDTH-1:0]       rxfifo_fill_level, // The fill level of receiver buffer in word
  output                               rg_overflow,       //Regroup buffer overflow
  output [1:0]                         irx_eccstatus,     //ECC status ORed from all the M20K when ECC mode is enabled
  output [1:0]                         itx_eccstatus,     //ECC status ORed from all the M20K when ECC mode is enabled

  // Avalon-MM interface for Uflex Interlaken core CSR
  input                                mm_clk,
  input                                mm_read,
  input                                mm_write,
  input  [15:0]                        mm_address,
  output [31:0]                        mm_readdata,
  output                               mm_readdatavalid,
  input  [31:0]                        mm_writedata,

  // XCVR clk and reset interface
  input  [NUM_LANES-1:0]               tx_clkout,
  input  [NUM_LANES-1:0]               rx_clkout,
  input  [NUM_LANES-1:0]               tx_digitalreset,
  input  [NUM_LANES-1:0]               rx_digitalreset,
  input  [NUM_LANES-1:0]               rx_is_lockedtodata,
  input  [NUM_LANES-1:0]               tx_ready_reset,    //S10
  input  [NUM_LANES-1:0]               tx_dll_lock, //S10

  // TX PCS FIFO Interface
  output [NUM_LANES*64-1:0]            tx_parallel_data,
  output [NUM_LANES-1:0]               tx_control,
  output [NUM_LANES-1:0]               tx_enh_data_valid,
  input  [NUM_LANES-1:0]               tx_enh_fifo_full,
  input  [NUM_LANES-1:0]               tx_enh_fifo_pfull,
  input  [NUM_LANES-1:0]               tx_enh_fifo_empty,
  input  [NUM_LANES-1:0]               tx_enh_fifo_pempty,
  input  [NUM_LANES-1:0]               tx_enh_frame,
  output [NUM_LANES-1:0]               tx_enh_frame_burst_en,

  // RX PCS FIFO Interface
  input  [NUM_LANES*64-1:0]            rx_parallel_data,
  input  [NUM_LANES-1:0]               rx_control,
  input  [NUM_LANES-1:0]               rx_enh_data_valid,
  input  [NUM_LANES-1:0]               rx_enh_fifo_full,
  input  [NUM_LANES-1:0]               rx_enh_fifo_pfull,
  input  [NUM_LANES-1:0]               rx_enh_fifo_empty,
  input  [NUM_LANES-1:0]               rx_enh_fifo_pempty,
  output [NUM_LANES-1:0]               rx_enh_fifo_rd_en,
  output [NUM_LANES-1:0]               rx_enh_fifo_align_clr,
  input  [NUM_LANES-1:0]               rx_enh_frame_lock,
  input  [NUM_LANES-1:0]               rx_enh_crc32_err,
  input  [NUM_LANES-1:0]               rx_enh_sh_err,
  input  [NUM_LANES-1:0]               rx_enh_blk_lock,

  // Misc PCS interface
  input  [NUM_LANES-1:0]               tx_crc32err_inject,
  output [NUM_LANES-1:0]               rx_seriallpbken,
  output [NUM_LANES-1:0]               rx_set_locktodata,
  output [NUM_LANES-1:0]               rx_set_locktoref,
  output [NUM_LANES-1:0]               rx_prbs_err_clr,
  input  [NUM_LANES-1:0]               rx_prbs_err,
  input  [NUM_LANES-1:0]               rx_prbs_done,
  
    //Raw signals
  output [INTERNAL_WORDS*64-1:0]       rx_raw_data,
  output [INTERNAL_WORDS-1:0]          rx_raw_data_ctrl,
  output [INTERNAL_WORDS-1:0]          rx_raw_crc24_err
);

  // interface signals between ilk_tx_ext and ilk_tx
  wire                            tx_valid_ext;
  wire   [INTERNAL_WORDS*64-1:0]  tx_data_ext;
  wire   [INTERNAL_WORDS-1:0]     tx_idle_ext;
  wire   [INTERNAL_WORDS-1:0]     tx_sob_ext;
  wire   [INTERNAL_WORDS-1:0]     tx_sop_ext;
  wire   [INTERNAL_WORDS*4-1:0]   tx_eopbits_ext;
  wire   [INTERNAL_WORDS*8-1:0]   tx_chan_ext;
  wire   [INTERNAL_WORDS*8-1:0]   tx_muse_ext;
  wire                            tx_credit;

  // clock, reset and miscellaneous signals
  wire                            srst_tx_common;
  wire                            srst_rx_common;
  wire                            mm_reset;

  wire                            tx_srst_n;
  wire                            rx_srst_n;
  wire                            srst_tx_common_n;
  wire                            srst_rx_common_n;
  wire                            mm_reset_n;

  wire                            rx_set_locktodata_csr;
  wire                            rx_set_locktoref_csr;
  wire                            rx_prbs_err_clr_csr;
  wire [INTERNAL_WORDS*65-1:0]    strip_din, strip_din_dly; 
  wire                            rx_raw_data_val, strip_din_valid_dly;

  // RX PCSIF interface
  wire [4:0]                      rxa_timer;
  wire [1:0]                      rxa_sm;

  // TX PCSIF interface
  wire [NUM_LANES-1:0]            tx_err_inj;
  wire [2:0]                      txa_sm;
  wire                            tx_lanes_aligned_s;
  wire                            rx_lanes_aligned_s;
  wire                            tx_ready_ext;
  reg                             tx_ready_r = 1'b0;
  assign                          tx_ready   = tx_ready_r;

  assign clk_tx_common = tx_clkout[NUM_LANES>>1];
  assign clk_rx_common = rx_clkout[NUM_LANES>>1];

  uflex_std_synchronizer_nocut #(.depth(8)) tx_srst_sync     (.clk(tx_clk),        .reset_n(~tx_digitalreset[NUM_LANES>>1]), .din(1'b1), .dout(tx_srst_n));
  uflex_std_synchronizer_nocut #(.depth(8)) rx_srst_sync     (.clk(rx_clk),        .reset_n(~rx_digitalreset[NUM_LANES>>1]), .din(1'b1), .dout(rx_srst_n));
  uflex_std_synchronizer_nocut #(.depth(8)) tx_cmn_srst_sync (.clk(clk_tx_common), .reset_n(~tx_digitalreset[NUM_LANES>>1]), .din(1'b1), .dout(srst_tx_common_n));
  uflex_std_synchronizer_nocut #(.depth(8)) rx_cmn_srst_sync (.clk(clk_rx_common), .reset_n(~rx_digitalreset[NUM_LANES>>1]), .din(1'b1), .dout(srst_rx_common_n));
  uflex_std_synchronizer_nocut #(.depth(8)) mm_reset_sync    (.clk(mm_clk),        .reset_n(reset_n),                        .din(1'b1), .dout(mm_reset_n));

  //build rx_rst tree 
  wire tx_srst_int;
  wire rx_srst_int;
  uflex_ilk_delay_regs #(.DEVICE_FAMILY(DEVICE_FAMILY),.WIDTH(2),.LATENCY(1)) 
           tx_srst_tree (.clk(tx_clk), .din({2{~tx_srst_n}}), .dout({tx_srst_int,tx_srst}));
  uflex_ilk_delay_regs #(.DEVICE_FAMILY(DEVICE_FAMILY),.WIDTH(2),.LATENCY(1)) 
           rx_srst_tree (.clk(rx_clk), .din({2{~rx_srst_n}}), .dout({rx_srst_int,rx_srst}));
  assign srst_tx_common = ~srst_tx_common_n;
  assign srst_rx_common = ~srst_rx_common_n;
  assign mm_reset       = ~mm_reset_n;

  assign rx_set_locktodata = {(NUM_LANES){rx_set_locktodata_csr}};
  assign rx_set_locktoref  = {(NUM_LANES){rx_set_locktoref_csr}};
  assign rx_prbs_err_clr   = {(NUM_LANES){rx_prbs_err_clr_csr}};

  `ifdef ALTERA_RESERVED_QIS
    localparam    METALEN_CORE = METALEN;
  `else
    localparam    METALEN_CORE = SIM_MODE ? 128 : METALEN;
  `endif
/*
  uflex_ilk_status_sync #(.WIDTH(2))als (.clk (tx_clk),
                                         .din ({tx_lanes_aligned,   rx_lanes_aligned}),
                                         .dout({tx_lanes_aligned_s, rx_lanes_aligned_s}));
*/
 uflex_std_synchronizer_nocut #(.depth(2)) rx_sync_to_mm (.clk( tx_clk ),.reset_n(1'b1),.din(rx_lanes_aligned),.dout(rx_lanes_aligned_s));
 uflex_std_synchronizer_nocut #(.depth(2)) tx_sync_to_mm (.clk( tx_clk ),.reset_n(1'b1),.din(tx_lanes_aligned),.dout(tx_lanes_aligned_s));

  always @(posedge tx_clk) tx_ready_r <= tx_ready_ext & tx_lanes_aligned_s & rx_lanes_aligned_s; 

  uflex_ilk_tx_ext #(
    .DEVICE_FAMILY   (DEVICE_FAMILY     ), // Stratix V, Arria 10
    .IWORDS          (EXTERNAL_WORDS    ),
    .LOG_IWORDS      (LOG_EXTERNAL_WORDS),
    .DUAL            (DUAL              ),
    .TX_DUAL_SEG     (TX_DUAL_SEG       ), // default is non dual mode
    .TX_PKTMOD_ONLY  (TX_PKTMOD_ONLY    ),
    .ECC_ENABLE      (ECC_ENABLE        ),
    .WRAM_NUM_DUP    (WRAM_NUM_DUP      ),
    .MLAB_ADDR_WIDTH (MLAB_ADDR_WIDTH   ), // default is 32 entries
    .FULL_THRESHOLD  (FULL_THRESHOLD    ), // 0:4 1:8 entries left
    .IDLE_THRESHOLD  (IDLE_THRESHOLD    ), // 0:low 4 high 8;1:low 8 high 16;2:low 16 high 24
    .M20K_ADDR_WIDTH (M20K_ADDR_WIDTH   )  // 
  ) u_tx_ext (
    .clk            (tx_clk        ), // input
    .srst           (tx_srst_int   ), // input
    .tx_num_valid   (tx_num_valid  ), // input
    .tx_data        (tx_data       ), // input
    .tx_chan        (tx_chan       ), // input
    .tx_muse        (8'b0          ), // input
    .tx_sop         (tx_sop        ), // input
    .tx_sob         (tx_sob        ), // input
    .tx_eob         (tx_eob        ), // input
    .tx_eopbits     (tx_eopbits    ), // input
    .tx_ready       (tx_ready_ext  ), // output
    .tx_credit      (tx_credit     ), // input                               
  
    .burst_max_in   (burst_max_in  ), // input
    .burst_min_in   (burst_min_in  ), // input
    .burst_short_in (burst_short_in), // input
  
    .tx_valid_out   (tx_valid_ext  ), // output
    .tx_data_out    (tx_data_ext   ), // output
    .tx_sop_out     (tx_sop_ext    ), // output
    .tx_sob_out     (tx_sob_ext    ), // output
    .tx_idle_out    (tx_idle_ext   ), // output
    .tx_chan_out    (tx_chan_ext   ), // output
    .tx_eopbits_out (tx_eopbits_ext), // output
    .tx_muse_out    (tx_muse_ext   ), // output
    .tx_eccstatus   (itx_eccstatus )  // output
  );

  uflex_ilk_tx #(
    .DEVICE_FAMILY      (DEVICE_FAMILY     ),
    .SIM_MODE           (SIM_MODE          ),
    .METALEN            (METALEN_CORE      ),
    .PMA_WIDTH          (PMA_WIDTH         ),
    .TXFIFO_PEMPTY      (TXFIFO_PEMPTY     ),
    .ILA_MODE           (ILA_MODE          ),
    .STRIPER            (STRIPER           ),
    .NUM_LANES          (NUM_LANES         ),
    .INTERNAL_WORDS     (INTERNAL_WORDS    ),
    .TX_CREDIT_LATENCY  (TX_CREDIT_LATENCY ),
    .CALENDAR_PAGES     (CALENDAR_PAGES    ),
    .LOG_CALENDAR_PAGES (LOG_CALENDAR_PAGES),
    .INBAND_FLW_ON      (INBAND_FLW_ON     ),    
    .TX_ERR_INJ_EN      (TX_ERR_INJ_EN     )
  ) inst_tx (
    // Clock and reset
    .tx_clk                (tx_clk                   ), // input                                
    .tx_srst               (tx_srst_int              ), // input                                
    .pcs_clk               (clk_tx_common            ), // input                                
    .pcs_srst              (srst_tx_common           ), // input                                
    .tx_ready              (tx_ready_reset           ), // input S10
    .tx_dll_lock           (tx_dll_lock              ), // input S10


    // TX User interface
    .tx_valid              (tx_valid_ext             ), // input                                
    .tx_idle               (tx_idle_ext              ), // input  [INTERNAL_WORDS-1:0]          
    .tx_sob                (tx_sob_ext               ), // input  [INTERNAL_WORDS-1:0]          
    .tx_sop                (tx_sop_ext               ), // input  [INTERNAL_WORDS-1:0]          
    .tx_eopbits            (tx_eopbits_ext           ), // input  [INTERNAL_WORDS*4-1:0]        
    .tx_chan               (tx_chan_ext              ), // input  [INTERNAL_WORDS*8-1:0]        
    .tx_ctrl               ({INTERNAL_WORDS*29{1'b0}}), // input  [INTERNAL_WORDS*29-1:0]       
    .tx_data               (tx_data_ext              ), // input  [INTERNAL_WORDS*64-1:0]       
    .tx_credit             (tx_credit                ), // output                               
    .tx_calendar           (tx_calendar              ), // input  [CALENDAR_PAGES*16-1:0]       

    // TX PCS FIFO Interface
    .tx_parallel_data      (tx_parallel_data         ), // output [NUM_LANES*64-1:0]            
    .tx_control            (tx_control               ), // output [NUM_LANES-1:0]             
    .tx_enh_data_valid     (tx_enh_data_valid        ), // output [NUM_LANES-1:0]               
    .tx_enh_fifo_full      (tx_enh_fifo_full         ), // input  [NUM_LANES-1:0]               
    .tx_enh_fifo_pfull     (tx_enh_fifo_pfull        ), // input  [NUM_LANES-1:0]               
    .tx_enh_fifo_empty     (tx_enh_fifo_empty        ), // input  [NUM_LANES-1:0]               
    .tx_enh_fifo_pempty    (tx_enh_fifo_pempty       ), // input  [NUM_LANES-1:0]               
    .tx_enh_frame          (tx_enh_frame             ), // input  [NUM_LANES-1:0]               
    .tx_enh_frame_burst_en (tx_enh_frame_burst_en    ), // output [NUM_LANES-1:0]               

    // CSR interface
    .tx_err_inj            (tx_err_inj               ), // input  [NUM_LANES-1:0]
    .txa_sm                (txa_sm                   ), // output [2:0]                         
    .tx_lanes_aligned      (tx_lanes_aligned         ), // output                               

    // Miscellaneous signals
    .tx_overflow           (tx_overflow              ), // output                               
    .tx_underflow          (tx_underflow             )  // output                               
  ); //uflex_ilk_tx 

  uflex_ilk_rx #(
    .DEVICE_FAMILY      (DEVICE_FAMILY     ),
    .PMA_WIDTH          (PMA_WIDTH         ),
    .ILA_MODE           (ILA_MODE          ),
    .STRIPER            (STRIPER           ),
    .NUM_LANES          (NUM_LANES         ),
    .INTERNAL_WORDS     (INTERNAL_WORDS    ),
    .CALENDAR_PAGES     (CALENDAR_PAGES    ),
    .LOG_CALENDAR_PAGES (LOG_CALENDAR_PAGES),
    .INBAND_FLW_ON      (INBAND_FLW_ON     ),
    .IBFC_ERR           (IBFC_ERR          )
  ) inst_rx (
    // Clock and reset
    .rx_clk                (rx_clk               ), // input                                
    .rx_srst               (rx_srst_int          ), // input                                

    // RX User Interface
    .rx_valid              (                     ), // output                               
    .rx_idle               (                     ), // output [INTERNAL_WORDS-1:0]          
    .rx_sob                (                     ), // output [INTERNAL_WORDS-1:0]          
    .rx_sop                (                     ), // output [INTERNAL_WORDS-1:0]          
    .rx_eopbits            (                     ), // output [INTERNAL_WORDS*4-1:0]        
    .rx_chan               (                     ), // output [INTERNAL_WORDS*8-1:0]        
    .rx_ctrl               (                     ), // output [INTERNAL_WORDS*29-1:0]       
    .rx_data               (                     ), // output [INTERNAL_WORDS*64-1:0]
    .rx_crc24_err          (                     ), // output [INTERNAL_WORDS-1:0]      
    .rx_calendar           (rx_calendar          ), // output [CALENDAR_PAGES*16-1:0]          

    // RX PCS FIFO Interface
    .rx_parallel_data      (rx_parallel_data     ), // input  [NUM_LANES*64-1:0]            
    .rx_control            (rx_control           ), // input  [NUM_LANES-1:0]            
    .rx_enh_data_valid     (rx_enh_data_valid    ), // input  [NUM_LANES-1:0]               
    .rx_enh_fifo_full      (rx_enh_fifo_full     ), // input  [NUM_LANES-1:0]               
    .rx_enh_fifo_pfull     (rx_enh_fifo_pfull    ), // input  [NUM_LANES-1:0]               
    .rx_enh_fifo_empty     (rx_enh_fifo_empty    ), // input  [NUM_LANES-1:0]               
    .rx_enh_fifo_pempty    (rx_enh_fifo_pempty   ), // input  [NUM_LANES-1:0]               
    .rx_enh_fifo_rd_en     (rx_enh_fifo_rd_en    ), // output [NUM_LANES-1:0]               
    .rx_enh_fifo_align_clr (rx_enh_fifo_align_clr), // output [NUM_LANES-1:0]               
    .rx_enh_frame_lock     (rx_enh_frame_lock    ), // input  [NUM_LANES-1:0]               
    .rx_enh_crc32_err      (rx_enh_crc32_err     ), // input  [NUM_LANES-1:0]               
    .rx_enh_blk_lock       (rx_enh_blk_lock      ), // input  [NUM_LANES-1:0]               

    // CSR interface
    .rxa_timer             (rxa_timer            ), // output [4:0]                         
    .rxa_sm                (rxa_sm               ), // output [1:0]                         
    .rx_lanes_aligned      (rx_lanes_aligned     ), // output                               

    // Miscellaneous signals
    .rx_wordlock           (word_locked          ), // output [NUM_LANES-1:0]               
    .rx_metalock           (sync_locked          ), // output [NUM_LANES-1:0]                       
    .rx_crc32_err          (rx_crc32_err         ), // output [NUM_LANES-1:0]               
    .rx_overflow           (rx_overflow          ), // output 
    
    //Raw Signals
    .rx_raw_data           (rx_raw_data          ), // output
    .rx_raw_data_val       (rx_raw_data_val      ), // output
    .rx_raw_data_ctrl      (rx_raw_data_ctrl     ), // output
    .rx_raw_crc24_err      (rx_raw_crc24_err     )  // output
  ); //uflex_ilk_rx 

  //If ERR_HANDLER_ON is on, data path needs to be aligned with crc checker result
  localparam CRC24_ALIGN_ON = ERR_HANDLER_ON;
  //localparam CRC_LATENCY    =(INTERNAL_WORDS == 4) ? 12 : 15;
  localparam CRC_LATENCY    = (DEVICE_FAMILY == "Arria 10") ? ((INTERNAL_WORDS == 4) ? 12 : 15) : ((INTERNAL_WORDS == 4) ? 13 : 16);

  genvar j;
  generate
    for (j=0; j<INTERNAL_WORDS; j=j+1) begin : strip_in
      assign strip_din[(j+1)*65-1:j*65] = {rx_raw_data_ctrl[j], rx_raw_data[(j+1)*64-1 : j*64]};
    end
  endgenerate

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //It takes 5 cycle to process CRC24 validation, data and valid needs to delay the same amount to match.
  /////////////////////////////////////////////////////////////////////////////////////////////////////
  wire [65*INTERNAL_WORDS-1:0] din_words_r5;
  wire                         din_words_valid_r5;
  generate
   if (CRC24_ALIGN_ON) begin
     wire [65*INTERNAL_WORDS-1:0] rx_raw_din_dly;
     wire rx_raw_val_dly;

     uflex_ilk_delay_mlab #(
       .WIDTH (INTERNAL_WORDS*65+1),
       .LATENCY (CRC_LATENCY-1), //
       .DEVICE_FAMILY (DEVICE_FAMILY),
       .FRACTURE (1)
       )crc_match (
       .clk                (rx_clk),
       .din                ({rx_raw_data_val, strip_din}), //
       .dout               ({rx_raw_val_dly, rx_raw_din_dly})
     );
   reg [65*INTERNAL_WORDS-1:0] rx_raw_din_dly_r;
   reg rx_raw_val_dly_r;

   always @(posedge rx_clk) begin
      rx_raw_val_dly_r <= rx_raw_val_dly;
      rx_raw_din_dly_r <= rx_raw_din_dly; 
   end
      
   assign strip_din_dly = rx_raw_din_dly_r;
   assign strip_din_valid_dly = rx_raw_val_dly_r;

    end else begin
      assign strip_din_dly = strip_din;
      assign strip_din_valid_dly = rx_raw_data_val;
    end
  endgenerate


  wire [15:0] rx_chan_ext;
  assign rx_chan = rx_chan_ext[15:8];

  wire [LOG_EXTERNAL_WORDS-1:0] rx_num_valid_rg;
  wire                          rx_sop_rg;
  wire                          rx_sob_rg;

  generate
    if ((EXTERNAL_WORDS == 8) | (EXTERNAL_WORDS == 16)) begin
      assign rx_num_valid = {rx_num_valid_rg, {LOG_EXTERNAL_WORDS{1'b0}}};
      assign rx_sop       = {rx_sop_rg, 1'b0};
      assign rx_sob       = {rx_sob_rg, 1'b0};
    end else if (EXTERNAL_WORDS == 4) begin
      assign rx_num_valid = rx_num_valid_rg;
      assign rx_sop       = rx_sop_rg;
      assign rx_sob       = rx_sob_rg;
    end
  endgenerate

  uflex_ilk_rx_regroup_n #(
    .DEVICE_FAMILY     (DEVICE_FAMILY    ),
    .INTERNAL_WORDS    (INTERNAL_WORDS   ),
    .EXTERNAL_WORDS    (EXTERNAL_WORDS   ),
    .ECC_ENABLE        (ECC_ENABLE       ),
    .WRAM_NUM_DUP      (WRAM_NUM_DUP     ),
    .RXFIFO_ADDR_WIDTH (RXFIFO_ADDR_WIDTH)
  ) rg0 (
    // Clock and reset
    .iclk             (rx_clk             ), //rx_clk  Need to discuss usr clock or common clock
    .iclr             (rx_srst_int        ),
    .eclk             (rx_clk             ), //rx_clk  Need to discuss usr clock or common clock
    .eclr             (rx_srst_int        ),

    // Burst config
    .burst_max_in     (burst_max_in       ),
    .burst_min_in     (burst_min_in       ),
    .burst_short_in   (burst_short_in     ),

    // internal interface
    .strip_din        (strip_din_dly      ),
    .strip_din_valid  (strip_din_valid_dly),
    .chk_crc24_err_in (rx_raw_crc24_err   ),
  
    // external user interface
    .dout_num_valid   (rx_num_valid_rg    ),
    .dout             (rx_data            ),
    .dout_sop         (rx_sop_rg          ),
    .dout_sob         (rx_sob_rg          ),
    .dout_eob         (rx_eob             ),
    .dout_eopbits     (rx_eopbits         ),
    .dout_chan        (rx_chan_ext        ),
    .dout_crc_err     (rx_crc24_err       ),
    .dout_err_status  (dout_err_status    ),
    .rxfifo_fill_level(rxfifo_fill_level  ),
    .rg_overflow      (rg_overflow        ),
    .eccstatus        (irx_eccstatus      )
  );

  uflex_ilk_csr #(
    .DIAG_ON            (1'b1      ),
    .NUM_LANES          (NUM_LANES ),
    .INCLUDE_TEMP_SENSE (1'b0      ),
    .MM_CLK_KHZ         (MM_CLK_KHZ)
  ) inst_uflex_ilk_csr (
    .mm_clk                   (mm_clk               ), //  input                          
    .mm_reset                 (mm_reset             ), //  input                          
    .mm_read                  (mm_read              ), //  input                          
    .mm_write                 (mm_write             ), //  input                          
    .mm_addr                  (mm_address           ), //  input  [15:0] 
    .mm_rdata                 (mm_readdata          ), //  output [31:0] 
    .mm_rdata_valid           (mm_readdatavalid     ), //  output                         
    .mm_wdata                 (mm_writedata         ), //  input  [31:0] 

    // clocks and reset
    .pll_ref_clk              (pll_ref_clk          ), //  input                          
    .clk_tx_common            (clk_tx_common        ), //  input                          
    .clk_rx_common            (clk_rx_common        ), //  input                          
    .srst_rx_common           (srst_rx_common       ), //  input                          
    .tx_pll_locked            (tx_pll_locked        ), //  input 

    // TX PCS FIFO Interface
    .tx_fifo_empty            (tx_enh_fifo_empty    ), //  input [NUM_LANES-1:0]          
    .tx_fifo_pempty           (tx_enh_fifo_pempty   ), //  input [NUM_LANES-1:0]          
    .tx_fifo_full             (tx_enh_fifo_full     ), //  input [NUM_LANES-1:0]          
    .tx_fifo_pfull            (tx_enh_fifo_pfull    ), //  input [NUM_LANES-1:0]          
    .txa_sm                   (txa_sm               ), //  input [2:0]                    
    .tx_lanes_aligned         (tx_lanes_aligned     ), //  input                          

    // RX PCS FIFO Interface
    .rx_fifo_empty            (rx_enh_fifo_empty    ), //  input [NUM_LANES-1:0]          
    .rx_fifo_pempty           (rx_enh_fifo_pempty   ), //  input [NUM_LANES-1:0]          
    .rx_fifo_full             (rx_enh_fifo_full     ), //  input [NUM_LANES-1:0]          
    .rx_fifo_pfull            (rx_enh_fifo_pfull    ), //  input [NUM_LANES-1:0]          
    .rx_is_lockedtodata       (rx_is_lockedtodata   ), //  input [NUM_LANES-1:0]          
    .rxa_timer                (rxa_timer            ), //  input [4:0]                    
    .rxa_sm                   (rxa_sm               ), //  input [1:0]                    
    .rx_lanes_aligned         (rx_lanes_aligned     ), //  input                          
    .rx_wordlock              (rx_enh_blk_lock      ), //  input [NUM_LANES-1:0]          
    .rx_metalock              (rx_enh_frame_lock    ), //  input [NUM_LANES-1:0]          
    .rx_crc32err              (rx_enh_crc32_err     ), //  input [NUM_LANES-1:0]          
    .rx_sh_err                (rx_enh_sh_err        ), //  input [NUM_LANES-1:0]          

    // control outputs
    .rx_seriallpbken          (rx_seriallpbken      ), //  output reg [NUM_LANES-1:0]     
    .rx_set_locktodata        (rx_set_locktodata_csr), //  output reg                     
    .rx_set_locktoref         (rx_set_locktoref_csr ), //  output reg                     
    .tx_crc32err_inject_s_txc (tx_crc32err_inject   ), //  output [NUM_LANES-1:0]         
    .tx_err_inj               (tx_err_inj           ), //  output reg [NUM_LANES-1:0]
    .rx_prbs_err_clr          (rx_prbs_err_clr_csr  ), //  output reg                     
    .rx_prbs_err              (rx_prbs_err          ), //  input  [NUM_LANES-1:0]         
    .rx_prbs_done             (rx_prbs_done         )  //  input  [NUM_LANES-1:0]         
  ); //inst_uflex_ilk_csr

endmodule
