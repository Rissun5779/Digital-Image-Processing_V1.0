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

`timescale 1 ns / 1 ps
module uflex_ilk_dcore #(
  parameter DEVICE_FAMILY        = "Arria 10",   // Stratix V or Arria 10
  parameter SIM_MODE             = 0,            // If set to 1, METALEN shall be overriden to 128 in simulation
  parameter METALEN              = 2048,         // 
  parameter PMA_WIDTH            = 32,           // 32 or 40
  parameter TXFIFO_PEMPTY        = 2,            // partial empty threshold for TX PCS FIFO
  parameter MM_CLK_KHZ           = 20'd100000,   // management clock range is restricted to 100 to 125 MHz by hard logic
  parameter MM_CLK_MHZ           = 28'd100000000,// If mm_clk set to 125, both value need to change
  parameter ILA_MODE             = 0,            // 1: ILA mode 0: ILK mode
  parameter STRIPER              = 1,            // 0: non-striper mode (# of lane : # of segment == 1:1) 1:striper mode
  parameter NUM_LANES            = 4,            // number of lanes
  parameter INTERNAL_WORDS       = 4,            // number of segment (words) in the user interface
  parameter TX_CREDIT_LATENCY    = 4,            // latency between tx_credit and tx_valid
  parameter CALENDAR_PAGES       = 1,            // number of inband flow control 16-bit calendar pages
  parameter LOG_CALENDAR_PAGES   = 0,            // the width of the internal counter htat tracks the current calendar page
  parameter IBFC_ERR             = 1,            // Instantiates the Ibfc err handler module.
  parameter SWAP_TX_LANES        = 1,            // 1 = data is striped from lane 0 to lane M. 0 = data is striped from lane M to lane 0 
  parameter SWAP_RX_LANES        = 1,            // 1 = data is striped from lane 0 to lane M. 0 = data is striped from lane M to lane 0 
  parameter INBAND_FLW_ON       = 1,
  parameter TX_ERR_INJ_EN        = 0             // inject MAC level error
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

  // TX User interface
  input                                tx_valid,
  input  [INTERNAL_WORDS-1:0]          tx_idle,
  input  [INTERNAL_WORDS-1:0]          tx_sob,
  input  [INTERNAL_WORDS-1:0]          tx_sop,
  input  [INTERNAL_WORDS*4-1:0]        tx_eopbits,
  input  [ILA_MODE ? INTERNAL_WORDS-1 : INTERNAL_WORDS*8-1:0] tx_chan,
  input  [INTERNAL_WORDS*29-1:0]       tx_ctrl,
  input  [INTERNAL_WORDS*64-1:0]       tx_data,
  output                               tx_credit,
  input  [CALENDAR_PAGES*16-1:0]       tx_calendar,

  // RX User Interface
  output                               rx_valid,
  output [INTERNAL_WORDS-1:0]          rx_idle,
  output [INTERNAL_WORDS-1:0]          rx_sob,
  output [INTERNAL_WORDS-1:0]          rx_sop,
  output [INTERNAL_WORDS*4-1:0]        rx_eopbits,
  output [INTERNAL_WORDS-1:0]          rx_crc24_err,
  output [INTERNAL_WORDS*8-1:0]        rx_chan,
  output [INTERNAL_WORDS*29-1:0]       rx_ctrl,
  output [INTERNAL_WORDS*64-1:0]       rx_data,
  output [CALENDAR_PAGES*16-1:0]       rx_calendar,

  // Miscellaneous signals
  output                               tx_lanes_aligned,
  output                               rx_lanes_aligned,
  output [NUM_LANES-1:0]               word_locked,
  output [NUM_LANES-1:0]               sync_locked,
  output [NUM_LANES-1:0]               rx_crc32_err,
  output                               tx_overflow,
  output                               tx_underflow,
  output                               rx_overflow,

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
  input  [NUM_LANES-1:0]               tx_ready,    //S10
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
  output  [NUM_LANES-1:0]               tx_crc32err_inject,
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

  // clock, reset and miscellaneous signals
  wire                                 srst_tx_common;
  wire                                 srst_rx_common;
  wire                                 mm_reset;

  wire                                 tx_srst_n;
  wire                                 rx_srst_n;
  wire                                 srst_tx_common_n;
  wire                                 srst_rx_common_n;
  wire                                 mm_reset_n;

  wire                                 rx_set_locktodata_csr;
  wire                                 rx_set_locktoref_csr;
  wire                                 rx_prbs_err_clr_csr;

  // RX PCSIF interface
  wire [4:0]                           rxa_timer;
  wire [1:0]                           rxa_sm;

  // TX PCSIF interface
  wire [NUM_LANES-1:0]                 tx_err_inj;
  wire [2:0]                           txa_sm;

  //localparam                           TARGET_CHIP = (DEVICE_FAMILY == "Arria 10") ? 5 : 2;

  assign clk_tx_common              = tx_clkout[NUM_LANES>>1];
  assign clk_rx_common              = rx_clkout[NUM_LANES>>1];

  uflex_std_synchronizer_nocut #(.depth(8)) tx_srst_sync     (.clk(tx_clk),        .reset_n(~tx_digitalreset[NUM_LANES>>1]), .din(1'b1), .dout(tx_srst_n));
  uflex_std_synchronizer_nocut #(.depth(8)) rx_srst_sync     (.clk(rx_clk),        .reset_n(~rx_digitalreset[NUM_LANES>>1]), .din(1'b1), .dout(rx_srst_n));
  uflex_std_synchronizer_nocut #(.depth(8)) tx_cmn_srst_sync (.clk(clk_tx_common), .reset_n(~tx_digitalreset[NUM_LANES>>1]), .din(1'b1), .dout(srst_tx_common_n));
  uflex_std_synchronizer_nocut #(.depth(8)) rx_cmn_srst_sync (.clk(clk_rx_common), .reset_n(~rx_digitalreset[NUM_LANES>>1]), .din(1'b1), .dout(srst_rx_common_n));
  uflex_std_synchronizer_nocut #(.depth(8)) mm_reset_sync    (.clk(mm_clk),        .reset_n(reset_n),                        .din(1'b1), .dout(mm_reset_n));

  assign tx_srst          = ~tx_srst_n;
  assign rx_srst          = ~rx_srst_n;
  assign srst_tx_common   = ~srst_tx_common_n;
  assign srst_rx_common   = ~srst_rx_common_n;
  assign mm_reset         = ~mm_reset_n;

  assign rx_set_locktodata = {(NUM_LANES){rx_set_locktodata_csr}};
  assign rx_set_locktoref  = {(NUM_LANES){rx_set_locktoref_csr}};
  assign rx_prbs_err_clr   = {(NUM_LANES){rx_prbs_err_clr_csr}};

  `ifdef ALTERA_RESERVED_QIS
    localparam    METALEN_CORE = METALEN;
  `else
    localparam    METALEN_CORE = SIM_MODE ? 128 : METALEN;
  `endif

  uflex_ilk_tx #(
    .DEVICE_FAMILY             (DEVICE_FAMILY             ),
    .SIM_MODE                  (SIM_MODE                  ),
    .METALEN                   (METALEN_CORE              ),
    .PMA_WIDTH                 (PMA_WIDTH                 ),
    .TXFIFO_PEMPTY             (TXFIFO_PEMPTY             ),
    .ILA_MODE                  (ILA_MODE                  ),
    .STRIPER                   (STRIPER                   ),
    .NUM_LANES                 (NUM_LANES                 ),
    .INTERNAL_WORDS            (INTERNAL_WORDS            ),
    .TX_CREDIT_LATENCY         (TX_CREDIT_LATENCY         ),
    .CALENDAR_PAGES            (CALENDAR_PAGES            ),
    .LOG_CALENDAR_PAGES        (LOG_CALENDAR_PAGES        ),
    .INBAND_FLW_ON    (INBAND_FLW_ON    ),    
    .SWAP_TX_LANES             (SWAP_TX_LANES             ),
    .TX_ERR_INJ_EN             (TX_ERR_INJ_EN             )
  ) inst_tx (
    // Clock and reset
    .tx_clk                    (tx_clk                    ), // input                                
    .tx_srst                   (tx_srst                   ), // input                                
    .pcs_clk                   (clk_tx_common             ), // input                                
    .pcs_srst                  (srst_tx_common            ), // input                                
    .tx_ready                  (tx_ready                  ), // input S10
    .tx_dll_lock               (tx_dll_lock               ), // input S10

    // TX User interface
    .tx_valid                  (tx_valid                  ), // input                                
    .tx_idle                   (tx_idle                   ), // input  [INTERNAL_WORDS-1:0]          
    .tx_sob                    (tx_sob                    ), // input  [INTERNAL_WORDS-1:0]          
    .tx_sop                    (tx_sop                    ), // input  [INTERNAL_WORDS-1:0]          
    .tx_eopbits                (tx_eopbits                ), // input  [INTERNAL_WORDS*4-1:0]        
    .tx_chan                   (tx_chan                   ), // input  [INTERNAL_WORDS*8-1:0]        
    .tx_ctrl                   (tx_ctrl                   ), // input  [INTERNAL_WORDS*29-1:0]       
    .tx_data                   (tx_data                   ), // input  [INTERNAL_WORDS*64-1:0]       
    .tx_credit                 (tx_credit                 ), // output                               
    .tx_calendar               (tx_calendar               ), // input  [CALENDAR_PAGES*16-1:0]       

    // TX PCS FIFO Interface
    .tx_parallel_data          (tx_parallel_data          ), // output [NUM_LANES*64-1:0]            
    .tx_control                (tx_control                ), // output [NUM_LANES-1:0]             
    .tx_enh_data_valid         (tx_enh_data_valid         ), // output [NUM_LANES-1:0]               
    .tx_enh_fifo_full          (tx_enh_fifo_full          ), // input  [NUM_LANES-1:0]               
    .tx_enh_fifo_pfull         (tx_enh_fifo_pfull         ), // input  [NUM_LANES-1:0]               
    .tx_enh_fifo_empty         (tx_enh_fifo_empty         ), // input  [NUM_LANES-1:0]               
    .tx_enh_fifo_pempty        (tx_enh_fifo_pempty        ), // input  [NUM_LANES-1:0]               
    .tx_enh_frame              (tx_enh_frame              ), // input  [NUM_LANES-1:0]               
    .tx_enh_frame_burst_en     (tx_enh_frame_burst_en     ), // output [NUM_LANES-1:0]               

    // CSR interface
    .tx_err_inj                (tx_err_inj                ), // input  [NUM_LANES-1:0]
    .txa_sm                    (txa_sm                    ), // output [2:0]                         
    .tx_lanes_aligned          (tx_lanes_aligned          ), // output                               

    // Miscellaneous signals
    .tx_overflow               (tx_overflow               ), // output                               
    .tx_underflow              (tx_underflow              )  // output                               

  ); //uflex_ilk_tx 

  uflex_ilk_rx #(
    .DEVICE_FAMILY             (DEVICE_FAMILY             ),
    .PMA_WIDTH                 (PMA_WIDTH                 ),
    .ILA_MODE                  (ILA_MODE                  ),
    .STRIPER                   (STRIPER                   ),
    .NUM_LANES                 (NUM_LANES                 ),
    .INTERNAL_WORDS            (INTERNAL_WORDS            ),
    .CALENDAR_PAGES            (CALENDAR_PAGES            ),
    .LOG_CALENDAR_PAGES        (LOG_CALENDAR_PAGES        ),
    .SWAP_RX_LANES             (SWAP_RX_LANES             ),
    .INBAND_FLW_ON    (INBAND_FLW_ON    ),
    .IBFC_ERR                  (IBFC_ERR                  )
  ) inst_rx (
    // Clock and reset
    .rx_clk                    (rx_clk                    ), // input                                
    .rx_srst                   (rx_srst                   ), // input                                

    // RX User Interface
    .rx_valid                  (rx_valid                  ), // output                               
    .rx_idle                   (rx_idle                   ), // output [INTERNAL_WORDS-1:0]          
    .rx_sob                    (rx_sob                    ), // output [INTERNAL_WORDS-1:0]          
    .rx_sop                    (rx_sop                    ), // output [INTERNAL_WORDS-1:0]          
    .rx_eopbits                (rx_eopbits                ), // output [INTERNAL_WORDS*4-1:0]        
    .rx_chan                   (rx_chan                   ), // output [INTERNAL_WORDS*8-1:0]        
    .rx_ctrl                   (rx_ctrl                   ), // output [INTERNAL_WORDS*29-1:0]       
    .rx_data                   (rx_data                   ), // output [INTERNAL_WORDS*64-1:0]
    .rx_crc24_err              (rx_crc24_err              ), // output [INTERNAL_WORDS-1:0]      
    .rx_calendar               (rx_calendar               ), // output [CALENDAR_PAGES*16-1:0]          

    // RX PCS FIFO Interface
    .rx_parallel_data          (rx_parallel_data          ), // input  [NUM_LANES*64-1:0]            
    .rx_control                (rx_control                ), // input  [NUM_LANES-1:0]            
    .rx_enh_data_valid         (rx_enh_data_valid         ), // input  [NUM_LANES-1:0]               
    .rx_enh_fifo_full          (rx_enh_fifo_full          ), // input  [NUM_LANES-1:0]               
    .rx_enh_fifo_pfull         (rx_enh_fifo_pfull         ), // input  [NUM_LANES-1:0]               
    .rx_enh_fifo_empty         (rx_enh_fifo_empty         ), // input  [NUM_LANES-1:0]               
    .rx_enh_fifo_pempty        (rx_enh_fifo_pempty        ), // input  [NUM_LANES-1:0]               
    .rx_enh_fifo_rd_en         (rx_enh_fifo_rd_en         ), // output [NUM_LANES-1:0]               
    .rx_enh_fifo_align_clr     (rx_enh_fifo_align_clr     ), // output [NUM_LANES-1:0]               
    .rx_enh_frame_lock         (rx_enh_frame_lock         ), // input  [NUM_LANES-1:0]               
    .rx_enh_crc32_err          (rx_enh_crc32_err          ), // input  [NUM_LANES-1:0]               
    .rx_enh_blk_lock           (rx_enh_blk_lock           ), // input  [NUM_LANES-1:0]               

    // CSR interface
    .rxa_timer                 (rxa_timer                 ), // output [4:0]                         
    .rxa_sm                    (rxa_sm                    ), // output [1:0]                         
    .rx_lanes_aligned          (rx_lanes_aligned          ), // output                               

    // Miscellaneous signals
    .rx_wordlock               (word_locked               ), // output [NUM_LANES-1:0]               
    .rx_metalock               (sync_locked               ), // output [NUM_LANES-1:0]                       
    .rx_crc32_err              (rx_crc32_err              ), // output [NUM_LANES-1:0]               
    .rx_overflow               (rx_overflow               ),  // output 
    
    //Raw Signals
    .rx_raw_data               (rx_raw_data               ),// output
    .rx_raw_data_ctrl          (rx_raw_data_ctrl          ),// output
    .rx_raw_crc24_err          (rx_raw_crc24_err          )// output
  ); //uflex_ilk_rx 


  uflex_ilk_csr #(
    .DEVICE_FAMILY             (DEVICE_FAMILY             ),
    .DIAG_ON                   (1'b1                      ),
    .NUM_LANES                 (NUM_LANES                 ),
    .INCLUDE_TEMP_SENSE        (1'b0                      ),
    .MM_CLK_KHZ                (MM_CLK_KHZ                )
  ) inst_uflex_ilk_csr (

    .mm_clk                    (mm_clk                    ), //  input                          
    .mm_reset                  (mm_reset                  ), //  input                          
    .mm_read                   (mm_read                   ), //  input                          
    .mm_write                  (mm_write                  ), //  input                          
    .mm_addr                   (mm_address                ), //  input                   [15:0] 
    .mm_rdata                  (mm_readdata               ), //  output                  [31:0] 
    .mm_rdata_valid            (mm_readdatavalid          ), //  output                         
    .mm_wdata                  (mm_writedata              ), //  input                   [31:0] 

    // clocks and reset
    .pll_ref_clk               (pll_ref_clk               ), //  input                          
    .clk_tx_common             (clk_tx_common             ), //  input                          
    .clk_rx_common             (clk_rx_common             ), //  input                          
    .srst_rx_common            (srst_rx_common            ), //  input                          
    .tx_pll_locked             (tx_pll_locked             ), //  input 

    // TX PCS FIFO Interface
    .tx_fifo_empty             (tx_enh_fifo_empty         ), //  input [NUM_LANES-1:0]          
    .tx_fifo_pempty            (tx_enh_fifo_pempty        ), //  input [NUM_LANES-1:0]          
    .tx_fifo_full              (tx_enh_fifo_full          ), //  input [NUM_LANES-1:0]          
    .tx_fifo_pfull             (tx_enh_fifo_pfull         ), //  input [NUM_LANES-1:0]          
    .txa_sm                    (txa_sm                    ), //  input [2:0]                    
    .tx_lanes_aligned          (tx_lanes_aligned          ), //  input                          

    // RX PCS FIFO Interface
    .rx_fifo_empty             (rx_enh_fifo_empty         ), //  input [NUM_LANES-1:0]          
    .rx_fifo_pempty            (rx_enh_fifo_pempty        ), //  input [NUM_LANES-1:0]          
    .rx_fifo_full              (rx_enh_fifo_full          ), //  input [NUM_LANES-1:0]          
    .rx_fifo_pfull             (rx_enh_fifo_pfull         ), //  input [NUM_LANES-1:0]          
    .rx_is_lockedtodata        (rx_is_lockedtodata        ), //  input [NUM_LANES-1:0]          
    .rxa_timer                 (rxa_timer                 ), //  input [4:0]                    
    .rxa_sm                    (rxa_sm                    ), //  input [1:0]                    
    .rx_lanes_aligned          (rx_lanes_aligned          ), //  input                          
    .rx_wordlock               (rx_enh_blk_lock           ), //  input [NUM_LANES-1:0]          
    .rx_metalock               (rx_enh_frame_lock         ), //  input [NUM_LANES-1:0]          
    .rx_crc32err               (rx_enh_crc32_err          ), //  input [NUM_LANES-1:0]          
    .rx_sh_err                 (rx_enh_sh_err             ), //  input [NUM_LANES-1:0]          

    // control outputs
    .rx_seriallpbken           (rx_seriallpbken           ), //  output reg [NUM_LANES-1:0]     
    .rx_set_locktodata         (rx_set_locktodata_csr     ), //  output reg                     
    .rx_set_locktoref          (rx_set_locktoref_csr      ), //  output reg                     
    .tx_crc32err_inject_s_txc  (tx_crc32err_inject        ), //  output [NUM_LANES-1:0]         
    .tx_err_inj                (tx_err_inj                ), //  output reg [NUM_LANES-1:0]
    .rx_prbs_err_clr           (rx_prbs_err_clr_csr       ), //  output reg                     
    .rx_prbs_err               (rx_prbs_err               ), //  input  [NUM_LANES-1:0]         
    .rx_prbs_done              (rx_prbs_done              )  //  input  [NUM_LANES-1:0]         
  ); //inst_uflex_ilk_csr

endmodule
