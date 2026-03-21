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
module uflex_ilk_core #(
  parameter DEVICE_FAMILY               = "Arria 10",   // Stratix V or Arria 10
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
  output                               pll_powerdown,
  input                                tx_pll_locked,
  input                                tx_pll_cal_busy,
  input  [NUM_LANES-1:0]               tx_serial_clk,

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
  output [ILA_MODE ? INTERNAL_WORDS-1 : INTERNAL_WORDS*8-1:0] rx_chan,
  output [INTERNAL_WORDS*29-1:0]       rx_ctrl,
  output [INTERNAL_WORDS*64-1:0]       rx_data,
  output [CALENDAR_PAGES*16-1:0]       rx_calendar,

  // Serial interface signals
  output [NUM_LANES-1:0]               tx_pin,
  input  [NUM_LANES-1:0]               rx_pin,

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

  // Avalon-MM interface for native PHY reconfiguration 
  input                                reconfig_clk,
  input                                reconfig_reset,
  input                                reconfig_read,
  input                                reconfig_write,
  input  [(9+clogb2(NUM_LANES-1)):0]   reconfig_address,
  output [31:0]                        reconfig_readdata,
  input  [31:0]                        reconfig_writedata,
  output                               reconfig_waitrequest,

  // Reconfiguration inteface for StratixV
  input  [NUM_LANES*70-1:0]             reconfig_to_xcvr,
  output [NUM_LANES*46-1:0]             reconfig_from_xcvr
);

// synthesis translate_off
wire [INTERNAL_WORDS-1:0][64-1:0] txd_dbg   = tx_data;
wire [INTERNAL_WORDS-1:0][64-1:0]  rx_data_dbg  = rx_data;
// synthesis translate_on
  // clock, reset and miscellaneous signals
  wire   [NUM_LANES-1:0]               tx_clkout;
  wire   [NUM_LANES-1:0]               rx_clkout;
  wire   [NUM_LANES-1:0]               tx_analogreset;
  wire   [NUM_LANES-1:0]               tx_digitalreset;
  wire   [NUM_LANES-1:0]               tx_ready;
  wire   [NUM_LANES-1:0]               tx_dll_lock;
  wire   [NUM_LANES-1:0]               tx_cal_busy;
  wire   [NUM_LANES-1:0]               rx_analogreset;
  wire   [NUM_LANES-1:0]               rx_digitalreset;
  wire   [NUM_LANES-1:0]               rx_ready;
  wire   [NUM_LANES-1:0]               rx_is_lockedtoref;
  wire   [NUM_LANES-1:0]               rx_is_lockedtodata;
  wire   [NUM_LANES-1:0]               rx_cal_busy;

  // TX PCS FIFO Interface
  wire   [NUM_LANES*64-1:0]            tx_parallel_data;
  wire   [NUM_LANES-1:0]               tx_control;
  wire   [NUM_LANES-1:0]               tx_enh_data_valid;
  wire   [NUM_LANES-1:0]               tx_enh_fifo_full;
  wire   [NUM_LANES-1:0]               tx_enh_fifo_pfull;
  wire   [NUM_LANES-1:0]               tx_enh_fifo_empty;
  wire   [NUM_LANES-1:0]               tx_enh_fifo_pempty;
  wire   [NUM_LANES-1:0]               tx_enh_frame;
  wire   [NUM_LANES-1:0]               tx_enh_frame_burst_en;

  // RX PCS FIFO Interface
  wire   [NUM_LANES*64-1:0]            rx_parallel_data;
  wire   [NUM_LANES-1:0]               rx_control;
  wire   [NUM_LANES-1:0]               rx_enh_data_valid;
  wire   [NUM_LANES-1:0]               rx_enh_fifo_full;
  wire   [NUM_LANES-1:0]               rx_enh_fifo_pfull;
  wire   [NUM_LANES-1:0]               rx_enh_fifo_empty;
  wire   [NUM_LANES-1:0]               rx_enh_fifo_pempty;
  wire   [NUM_LANES-1:0]               rx_enh_fifo_rd_en;
  wire   [NUM_LANES-1:0]               rx_enh_fifo_align_clr;
  wire   [NUM_LANES-1:0]               rx_enh_frame_lock;
  wire   [NUM_LANES-1:0]               rx_enh_crc32_err;
  wire   [NUM_LANES-1:0]               rx_enh_sh_err;
  wire   [NUM_LANES-1:0]               rx_enh_blk_lock;

  wire   [NUM_LANES-1:0]               rx_seriallpbken;
  wire   [NUM_LANES-1:0]               rx_set_locktodata;
  wire   [NUM_LANES-1:0]               rx_set_locktoref;
  wire   [NUM_LANES-1:0]               tx_crc32err_inject;
  wire   [NUM_LANES-1:0]               rx_prbs_err_clr;
  wire   [NUM_LANES-1:0]               rx_prbs_err;
  wire   [NUM_LANES-1:0]               rx_prbs_done;
  wire [INTERNAL_WORDS*64-1:0]         rx_raw_data;
  wire [INTERNAL_WORDS-1:0]            rx_raw_data_ctrl;
  wire [INTERNAL_WORDS-1:0]            rx_raw_crc24_err;

  wire pll_ref_clk_2dcore;
  generate
    if (DEVICE_FAMILY == "Stratix 10") begin 
      assign pll_ref_clk_2dcore = 1'b0;
    end else begin
      assign pll_ref_clk_2dcore = pll_ref_clk;
    end
  endgenerate

  uflex_ilk_dcore #(
    .DEVICE_FAMILY        (DEVICE_FAMILY        ),
    .SIM_MODE             (SIM_MODE             ),
    .METALEN              (METALEN              ),
    .PMA_WIDTH            (PMA_WIDTH            ),
    .TXFIFO_PEMPTY        (TXFIFO_PEMPTY        ),
    .MM_CLK_KHZ           (MM_CLK_KHZ           ),
    .MM_CLK_MHZ           (MM_CLK_MHZ           ),
    .ILA_MODE             (ILA_MODE             ),
    .STRIPER              (STRIPER              ),
    .NUM_LANES            (NUM_LANES            ),
    .INTERNAL_WORDS       (INTERNAL_WORDS       ),
    .TX_CREDIT_LATENCY    (TX_CREDIT_LATENCY    ),
    .CALENDAR_PAGES       (CALENDAR_PAGES       ),
    .LOG_CALENDAR_PAGES   (LOG_CALENDAR_PAGES   ),
    .IBFC_ERR             (IBFC_ERR             ),
    .SWAP_TX_LANES        (SWAP_TX_LANES        ),
    .SWAP_RX_LANES        (SWAP_RX_LANES        ),
    .INBAND_FLW_ON     (INBAND_FLW_ON),
    .TX_ERR_INJ_EN        (TX_ERR_INJ_EN        )
  ) dcore (
    // Clock and reset
    .pll_ref_clk          (pll_ref_clk_2dcore   ), //  input                              
    .reset_n              (reset_n              ), //  input                              
    .tx_pll_locked        (tx_pll_locked        ), //  input                              

    .tx_ready             (tx_ready             ), // input S10
    .tx_dll_lock          (tx_dll_lock          ), // input S10

    .tx_clk               (tx_clk               ), //  input                              
    .tx_srst              (tx_srst              ), //  output                             
    .clk_tx_common        (clk_tx_common        ), //  output                             
    .rx_clk               (rx_clk               ), //  input                              
    .rx_srst              (rx_srst              ), //  output                             
    .clk_rx_common        (clk_rx_common        ), //  output                             

    // TX User interface
    .tx_valid             (tx_valid             ), //  input                              
    .tx_idle              (tx_idle              ), //  input  [INTERNAL_WORDS-1:0]        
    .tx_sob               (tx_sob               ), //  input  [INTERNAL_WORDS-1:0]        
    .tx_sop               (tx_sop               ), //  input  [INTERNAL_WORDS-1:0]        
    .tx_eopbits           (tx_eopbits           ), //  input  [INTERNAL_WORDS*4-1:0]      
    .tx_chan              (tx_chan              ), //  input  [INTERNAL_WORDS*8-1:0]      
    .tx_ctrl              (tx_ctrl              ), //  input  [INTERNAL_WORDS*29-1:0]     
    .tx_data              (tx_data              ), //  input  [INTERNAL_WORDS*64-1:0]     
    .tx_credit            (tx_credit            ), //  output                             
    .tx_calendar          (tx_calendar          ), //  input  [CALENDAR_PAGES*16-1:0]     

    // RX User Interface
    .rx_valid             (rx_valid             ), //  output                             
    .rx_idle              (rx_idle              ), //  output [INTERNAL_WORDS-1:0]        
    .rx_sob               (rx_sob               ), //  output [INTERNAL_WORDS-1:0]        
    .rx_sop               (rx_sop               ), //  output [INTERNAL_WORDS-1:0]        
    .rx_eopbits           (rx_eopbits           ), //  output [INTERNAL_WORDS*4-1:0]
    .rx_crc24_err         (rx_crc24_err         ), //  output [INTERNAL_WORDS-1:0]    
    .rx_chan              (rx_chan              ), //  output [INTERNAL_WORDS*8-1:0]      
    .rx_ctrl              (rx_ctrl              ), //  output [INTERNAL_WORDS*29-1:0]     
    .rx_data              (rx_data              ), //  output [INTERNAL_WORDS*64-1:0]     
    .rx_calendar          (rx_calendar          ), //  output [CALENDAR_PAGES*16-1:0]     

    // Miscellaneous signals
    .tx_lanes_aligned     (tx_lanes_aligned     ), //  output                             
    .rx_lanes_aligned     (rx_lanes_aligned     ), //  output                             
    .word_locked          (word_locked          ), //  output [NUM_LANES-1:0]             
    .sync_locked          (sync_locked          ), //  output [NUM_LANES-1:0]                  
    .rx_crc32_err         (rx_crc32_err         ), //  output [NUM_LANES-1:0]             
    .tx_overflow          (tx_overflow          ), //  output                             
    .tx_underflow         (tx_underflow         ), //  output                             
    .rx_overflow          (rx_overflow          ), //  output                             

    // Avalon-MM interface for Uflex Interlaken core CSR
    .mm_clk               (mm_clk               ), //  input                              
    .mm_read              (mm_read              ), //  input                              
    .mm_write             (mm_write             ), //  input                              
    .mm_address           (mm_address           ), //  input  [15:0]                      
    .mm_readdata          (mm_readdata          ), //  output [31:0]                      
    .mm_readdatavalid     (mm_readdatavalid     ), //  output                             
    .mm_writedata         (mm_writedata         ), //  input  [31:0]                      

    // XCVR clk and reset interface
    .tx_clkout            (tx_clkout            ), //  input  [NUM_LANES-1:0]             
    .rx_clkout            (rx_clkout            ), //  input  [NUM_LANES-1:0]             
    .tx_digitalreset      (tx_digitalreset      ), //  input  [NUM_LANES-1:0]             
    .rx_digitalreset      (rx_digitalreset      ), //  input  [NUM_LANES-1:0]             
    .rx_is_lockedtodata   (rx_is_lockedtodata   ), //  input  [NUM_LANES-1:0]             

    // TX PCS FIFO Interface
    .tx_parallel_data     (tx_parallel_data     ), //  output [NUM_LANES*64-1:0]          
    .tx_control           (tx_control           ), //  output [NUM_LANES-1:0]             
    .tx_enh_data_valid    (tx_enh_data_valid    ), //  output [NUM_LANES-1:0]             
    .tx_enh_fifo_full     (tx_enh_fifo_full     ), //  input  [NUM_LANES-1:0]             
    .tx_enh_fifo_pfull    (tx_enh_fifo_pfull    ), //  input  [NUM_LANES-1:0]             
    .tx_enh_fifo_empty    (tx_enh_fifo_empty    ), //  input  [NUM_LANES-1:0]             
    .tx_enh_fifo_pempty   (tx_enh_fifo_pempty   ), //  input  [NUM_LANES-1:0]             
    .tx_enh_frame         (tx_enh_frame         ), //  input  [NUM_LANES-1:0]             
    .tx_enh_frame_burst_en(tx_enh_frame_burst_en), //  output [NUM_LANES-1:0]             

    // RX PCS FIFO Interface
    .rx_parallel_data     (rx_parallel_data     ), //  input  [NUM_LANES*64-1:0]          
    .rx_control           (rx_control           ), //  input  [NUM_LANES-1:0]             
    .rx_enh_data_valid    (rx_enh_data_valid    ), //  input  [NUM_LANES-1:0]             
    .rx_enh_fifo_full     (rx_enh_fifo_full     ), //  input  [NUM_LANES-1:0]             
    .rx_enh_fifo_pfull    (rx_enh_fifo_pfull    ), //  input  [NUM_LANES-1:0]             
    .rx_enh_fifo_empty    (rx_enh_fifo_empty    ), //  input  [NUM_LANES-1:0]             
    .rx_enh_fifo_pempty   (rx_enh_fifo_pempty   ), //  input  [NUM_LANES-1:0]             
    .rx_enh_fifo_rd_en    (rx_enh_fifo_rd_en    ), //  output [NUM_LANES-1:0]             
    .rx_enh_fifo_align_clr(rx_enh_fifo_align_clr), //  output [NUM_LANES-1:0]             
    .rx_enh_frame_lock    (rx_enh_frame_lock    ), //  input  [NUM_LANES-1:0]             
    .rx_enh_crc32_err     (rx_enh_crc32_err     ), //  input  [NUM_LANES-1:0]             
    .rx_enh_sh_err        (rx_enh_sh_err        ), //  input  [NUM_LANES-1:0]             
    .rx_enh_blk_lock      (rx_enh_blk_lock      ), //  input  [NUM_LANES-1:0]             

    // Misc PCS interface
    .tx_crc32err_inject   (tx_crc32err_inject   ), //  input  [NUM_LANES-1:0]             
    .rx_seriallpbken      (rx_seriallpbken      ), //  output [NUM_LANES-1:0]             
    .rx_set_locktodata    (rx_set_locktodata    ), //  output [NUM_LANES-1:0]             
    .rx_set_locktoref     (rx_set_locktoref     ), //  output [NUM_LANES-1:0]             
    .rx_prbs_err_clr      (rx_prbs_err_clr      ), //  output [NUM_LAENS-1:0]             
    .rx_prbs_err          (rx_prbs_err          ), //  input  [NUM_LANES-1:0]             
    .rx_prbs_done         (rx_prbs_done         ),  //  input  [NUM_LANES-1:0] 
   
    //Raw Signals
    .rx_raw_data          (rx_raw_data          ),// output
    .rx_raw_data_ctrl     (rx_raw_data_ctrl     ),// output
    .rx_raw_crc24_err     (rx_raw_crc24_err     )// output
    
  );

  //localparam                           TARGET_CHIP = (DEVICE_FAMILY == "Arria 10") ? 5 : 2;
  
  wire [NUM_LANES-1:0] rx_analogreset_stat; 
  wire [NUM_LANES-1:0] rx_digitalreset_stat;
  wire [NUM_LANES-1:0] tx_analogreset_stat;
  wire [NUM_LANES-1:0] tx_digitalreset_stat; 

  genvar                               i;
  generate 
  if (DEVICE_FAMILY == "Stratix 10") begin 

    uflex_ilk_reset_control inst_reset_control (
      .clock                     (mm_clk                    ), //  input  wire                       clock.clk
      .reset                     (!reset_n                  ), //  input  wire                       reset.reset
      .tx_analogreset            (tx_analogreset            ), //  output wire [7:0]        tx_analogreset.tx_analogreset
      .tx_digitalreset           (tx_digitalreset           ), //  output wire [7:0]       tx_digitalreset.tx_digitalreset
      .tx_ready                  (tx_ready                  ), //  output wire [7:0]              tx_ready.tx_ready
      .pll_locked                (tx_pll_locked             ), //  input  wire [0:0]            pll_locked.pll_locked
      .pll_select                (1'b0                      ), //
      .tx_cal_busy               (tx_cal_busy               ),               //  input  wire [7:0]           tx_cal_busy.tx_cal_busy
      .pll_cal_busy              (tx_pll_cal_busy           ), //  input  wire [7:0]           tx_cal_busy.tx_cal_busy
      .rx_analogreset            (rx_analogreset            ), //  output wire [7:0]        rx_analogreset.rx_analogreset
      .rx_digitalreset           (rx_digitalreset           ), //  output wire [7:0]       rx_digitalreset.rx_digitalreset
      .rx_ready                  (rx_ready                  ), //  output wire [7:0]              rx_ready.rx_ready
      .rx_is_lockedtodata        (rx_is_lockedtodata        ), //  input  wire [7:0]    rx_is_lockedtodata.rx_is_lockedtodata
      .rx_cal_busy               (rx_cal_busy               ),  //  input  wire [7:0]           rx_cal_busy.rx_cal_busy
      .rx_analogreset_stat       (rx_analogreset_stat       ),
      .rx_digitalreset_stat      (rx_digitalreset_stat      ),
      .tx_analogreset_stat       (tx_analogreset_stat       ),
      .tx_digitalreset_stat      (tx_digitalreset_stat      )
    ); //uflex_ilk_reset_control 
     assign pll_powerdown = 1'b0;
  end else begin//A10 
    uflex_ilk_reset_control inst_reset_control (
      .clock                     (mm_clk                    ), //  input  wire                       clock.clk
      .reset                     (!reset_n                  ), //  input  wire                       reset.reset
      .pll_powerdown             (pll_powerdown             ), //  output wire [0:0]         pll_powerdown.pll_powerdown
      .tx_analogreset            (tx_analogreset            ), //  output wire [7:0]        tx_analogreset.tx_analogreset
      .tx_digitalreset           (tx_digitalreset           ), //  output wire [7:0]       tx_digitalreset.tx_digitalreset
      .tx_ready                  (tx_ready                  ), //  output wire [7:0]              tx_ready.tx_ready
      .pll_locked                (tx_pll_locked             ), //  input  wire [0:0]            pll_locked.pll_locked
      .pll_select                (1'b0                      ), //
      .tx_cal_busy               (tx_cal_busy | {NUM_LANES{tx_pll_cal_busy}}), //  input  wire [7:0]           tx_cal_busy.tx_cal_busy
      .rx_analogreset            (rx_analogreset            ), //  output wire [7:0]        rx_analogreset.rx_analogreset
      .rx_digitalreset           (rx_digitalreset           ), //  output wire [7:0]       rx_digitalreset.rx_digitalreset
      .rx_ready                  (rx_ready                  ), //  output wire [7:0]              rx_ready.rx_ready
      .rx_is_lockedtodata        (rx_is_lockedtodata        ), //  input  wire [7:0]    rx_is_lockedtodata.rx_is_lockedtodata
      .rx_cal_busy               (rx_cal_busy               )  //  input  wire [7:0]           rx_cal_busy.rx_cal_busy
    ); //uflex_ilk_reset_control 
  end
  endgenerate 

  generate 
  if (DEVICE_FAMILY == "Stratix 10") begin
    /* tx_data_in[63:0] -> [71:40],[31:0]
       tx_control[2:0]  -> [34:32]
       tx_err_ins       -> [76]
       tx_fifo_wr_en    -> [79]
       rx_data_out      -> [71:40],[31:0]
       rx_control[9:0]  -> [77:72],[35:32]
       rx_enh_data_valid-> [79]
    */ 
    wire   [NUM_LANES-1:0][80-1:0]  tx_enh_din_s10;     //80  bit 
    wire   [NUM_LANES-1:0][80-1:0]  rx_enh_dout_s10;        //128 bit

    for (i=0; i<NUM_LANES; i=i+1) begin: tx_enh_data_gen
                                                  //    [79]            [78:77] tx_err_ins [75:72]        [71:40]                        [39:35] 
      assign tx_enh_din_s10[i]                   = {tx_enh_data_valid[i],2'b0,   1'b0,       4'b0, tx_parallel_data[64*(i+1)-1:64*i+32], 5'b0,   
                                                  //[34:32]                                                           //[31:0]
                                                    tx_crc32err_inject[i], tx_control[i], ~tx_control[i], tx_parallel_data[64*(i+1)-1-32:64*i]};
      assign rx_parallel_data[64*(i+1)-1:64*i]   = {rx_enh_dout_s10[i][71:40],rx_enh_dout_s10[i][31:0]};  
      assign rx_control[i]                       =  rx_enh_dout_s10[i][33];    
      assign rx_enh_data_valid[i]                =  rx_enh_dout_s10[i][79];
    end


    wire [NUM_LANES-1:0] rx_fifo_align_clr;
    wire [NUM_LANES-1:0] rx_fifo_full;    
    wire [NUM_LANES-1:0] rx_fifo_empty;	 
    wire [NUM_LANES-1:0] rx_fifo_pempty;
    wire [NUM_LANES-1:0] rx_fifo_pfull;
    wire [NUM_LANES-1:0] rx_fifo_rd_en; 
    wire [NUM_LANES-1:0] tx_fifo_full;    
    wire [NUM_LANES-1:0] tx_fifo_empty;	 
    wire [NUM_LANES-1:0] tx_fifo_pempty;
    wire [NUM_LANES-1:0] tx_fifo_pfull;
    
    assign rx_enh_fifo_full      = rx_fifo_full;
    assign rx_enh_fifo_empty     = rx_fifo_empty;
    assign rx_enh_fifo_pempty    = rx_fifo_pempty;
    assign rx_enh_fifo_pfull     = rx_fifo_pfull;
    assign rx_fifo_rd_en         = rx_enh_fifo_rd_en;
    assign rx_fifo_align_clr     = rx_enh_fifo_align_clr;
    assign tx_enh_fifo_full      =tx_fifo_full;    
    assign tx_enh_fifo_empty     =tx_fifo_empty;	 
    assign tx_enh_fifo_pempty    =tx_fifo_pempty;
    assign tx_enh_fifo_pfull     =tx_fifo_pfull;

    uflex_ilk_xcvr xcvr_s10(
      .reconfig_write		(reconfig_write		),		//input  wire [0:0]  reconfig_write,           //            reconfig_avmm.write
      .reconfig_read		(reconfig_read		),		//input  wire [0:0]  reconfig_read,            //                         .read
      .reconfig_address  	(reconfig_address	),		//input  wire [10:0] reconfig_address,       //                         .address
      .reconfig_writedata	(reconfig_writedata	),		//input  wire [32:0] reconfig_writedata,     //                         .writedata
      .reconfig_readdata  	(reconfig_readdata	),		//output wire [32:0] reconfig_readdata,      //                         .readdata
      .reconfig_waitrequest	(reconfig_waitrequest	),		//output wire [0:0]  reconfig_waitrequest,   //                         .waitrequest
      .reconfig_clk		(reconfig_clk		),		//input  wire [0:0]  reconfig_clk,             //             reconfig_clk.clk
      .reconfig_reset		(reconfig_reset		),		//input  wire [0:0]  reconfig_reset,           //           reconfig_reset.reset
      .rx_analogreset		(rx_analogreset		),		//input  wire [11:0]  rx_analogreset,           //           rx_analogreset.rx_analogreset
      .rx_analogreset_stat	(rx_analogreset_stat	),		//output wire [11:0]  rx_analogreset_stat,    //      rx_analogreset_stat.rx_analogreset_stat
      .rx_cal_busy		(rx_cal_busy		),			//output wire [11:0]  rx_cal_busy,            //              rx_cal_busy.rx_cal_busy
      .rx_cdr_refclk0		(pll_ref_clk		), 		//input  wire         rx_cdr_refclk0,           //           rx_cdr_refclk0.clk
      .rx_clkout		(rx_clkout		),			//output wire [11:0]  rx_clkout,              //                rx_clkout.clk
      .rx_coreclkin		({(NUM_LANES){rx_clk}} 	), 		//input  wire [11:0]  rx_coreclkin,           //             rx_coreclkin.clk
      .rx_digitalreset  	(rx_digitalreset	),		//input  wire [11:0]  rx_digitalreset,        //          rx_digitalreset.rx_digitalreset
      .rx_digitalreset_stat	(rx_digitalreset_stat	),		//output wire [11:0]  rx_digitalreset_stat,   //     rx_digitalreset_stat.rx_digitalreset_stat
      .rx_enh_blk_lock  	(rx_enh_blk_lock	),		//output wire [11:0]  rx_enh_blk_lock,        //          rx_enh_blk_lock.rx_enh_blk_lock
      .rx_enh_crc32_err	        (rx_enh_crc32_err	),		//output wire [11:0]  rx_enh_crc32_err,       //          rx_enh_crc32err.rx_enh_crc32err
      .rx_enh_frame		(		),		        //output wire [11:0]  rx_enh_frame,             //             rx_enh_frame.rx_enh_frame
      .rx_enh_frame_diag_status(rx_enh_frame_diag_status),	//output wire [23:0]  rx_enh_frame_diag_status, // rx_enh_frame_diag_status.rx_enh_frame_diag_status
      .rx_enh_frame_lock	(rx_enh_frame_lock	),		//output wire [11:0]  rx_enh_frame_lock,        //        rx_enh_frame_lock.rx_enh_frame_lock
      .rx_fifo_align_clr	(rx_fifo_align_clr	),		//input  wire [11:0]  rx_fifo_align_clr,        //        rx_fifo_align_clr.rx_fifo_align_clr
      .rx_fifo_empty		(rx_fifo_empty		),		//output wire [11:0]  rx_fifo_empty,            //            rx_fifo_empty.rx_fifo_empty
      .rx_fifo_full		(rx_fifo_full		),			//output wire [11:0]  rx_fifo_full,             //             rx_fifo_full.rx_fifo_full
      .rx_fifo_pempty		(rx_fifo_pempty		),		//output wire [11:0]  rx_fifo_pempty,           //           rx_fifo_pempty.rx_fifo_pempty
      .rx_fifo_pfull		(rx_fifo_pfull		),		//output wire [11:0]  rx_fifo_pfull,            //            rx_fifo_pfull.rx_fifo_pfull
      .rx_fifo_rd_en		(rx_fifo_rd_en		),		//input  wire [11:0]  rx_fifo_rd_en,            //            rx_fifo_rd_en.rx_fifo_rd_en
      .rx_is_lockedtodata	(rx_is_lockedtodata	),		//output wire [11:0]  rx_is_lockedtodata,       //       rx_is_lockedtodata.rx_is_lockedtodata
      .rx_is_lockedtoref	(rx_is_lockedtoref	),		//output wire [11:0]  rx_is_lockedtoref,        //        rx_is_lockedtoref.rx_is_lockedtoref
      .rx_parallel_data		(rx_enh_dout_s10	),		//output wire [11:0[79:0] rx_parallel_data,         //         rx_parallel_data.rx_parallel_data
      .rx_prbs_done		(			),			//output wire [11:0]  rx_prbs_done,             //             rx_prbs_done.rx_prbs_done
      .rx_prbs_err		(			),			//output wire [11:0]  rx_prbs_err,              //              rx_prbs_err.rx_prbs_err
      .rx_prbs_err_clr		({NUM_LANES{1'b0}} 	),		//input  wire [11:0]  rx_prbs_err_clr,          //          rx_prbs_err_clr.rx_prbs_err_clr
      .rx_serial_data		(rx_pin			),			//input  wire [11:0]  rx_serial_data,           //           rx_serial_data.rx_serial_data
      .rx_seriallpbken		(rx_seriallpbken	),		//input  wire [11:0]  rx_seriallpbken,          //          rx_seriallpbken.rx_seriallpbken
      .rx_set_locktodata	(rx_set_locktodata	),		//input  wire [11:0]  rx_set_locktodata,        //        rx_set_locktodata.rx_set_locktodata
      .rx_set_locktoref		(rx_set_locktoref	),		//input  wire [11:0]  rx_set_locktoref,         //         rx_set_locktoref.rx_set_locktoref
      .tx_analogreset		(tx_analogreset		),		//input  wire [11:0]  tx_analogreset,           //           tx_analogreset.tx_analogreset
      .tx_analogreset_stat	(tx_analogreset_stat	),		//output wire [11:0]  tx_analogreset_stat,      //      tx_analogreset_stat.tx_analogreset_stat
      .tx_cal_busy		(tx_cal_busy		),			//output wire [11:0]  tx_cal_busy,              //              tx_cal_busy.tx_cal_busy
      .tx_clkout		(tx_clkout		),			//output wire [11:0]  tx_clkout,                //                tx_clkout.clk
      .tx_coreclkin		({(NUM_LANES){tx_clk}} 	),			//input  wire [11:0]  tx_coreclkin,             //             tx_coreclkin.clk
      .tx_dll_lock              (tx_dll_lock            ),     // output S10
      .tx_digitalreset		(tx_digitalreset	),		//input  wire [11:0]  tx_digitalreset,          //          tx_digitalreset.tx_digitalreset
      .tx_digitalreset_stat	(tx_digitalreset_stat	),		//output wire [11:0]  tx_digitalreset_stat,     //     tx_digitalreset_stat.tx_digitalreset_stat
      .tx_enh_frame_burst_en	(tx_enh_frame_burst_en	),	//input  wire [11:0]  tx_enh_frame_burst_en,    //          tx_enh_burst_en.tx_enh_frame_burst_en
      .tx_enh_frame		(tx_enh_frame		),	  	 	//output wire [11:0]  tx_enh_frame,             //             tx_enh_frame.tx_enh_frame
      .tx_enh_frame_diag_status({(NUM_LANES){2'b11}} 	),	//input  wire [23:0]  tx_enh_frame_diag_status, // tx_enh_frame_diag_status.tx_enh_frame_diag_status
      .tx_fifo_empty		(tx_fifo_empty		),		//output wire [11:0]  rx_fifo_empty,            //            rx_fifo_empty.rx_fifo_empty
      .tx_fifo_full		(tx_fifo_full		),			//output wire [11:0]  rx_fifo_full,             //             rx_fifo_full.rx_fifo_full
      .tx_fifo_pempty		(tx_fifo_pempty		),		//output wire [11:0]  rx_fifo_pempty,           //           rx_fifo_pempty.rx_fifo_pempty
      .tx_fifo_pfull		(tx_fifo_pfull		),		//output wire [11:0]  rx_fifo_pfull,            //            rx_fifo_pfull.rx_fifo_pfull
      .tx_parallel_data		(tx_enh_din_s10		),		//input  wire [11:0][[79:0] tx_parallel_data,         //         tx_parallel_data.tx_parallel_data
      .tx_serial_clk0		(tx_serial_clk		),		//input  wire [11:0]  tx_serial_clk0,           //           tx_serial_clk0.clk
      .tx_serial_data        	(tx_pin			)	  	 	//output wire [11:0]  tx_serial_data              //           tx_serial_data.tx_serial_data
     ); //S10:uflex_ilk_xcvr  
     assign rx_enh_sh_err             = {(NUM_LANES){1'b0}};
     assign rx_prbs_done              = {(NUM_LANES){1'b0}};
     assign rx_prbs_err               = {(NUM_LANES){1'b0}};
     assign reconfig_from_xcvr        = {(NUM_LANES*46){1'b0}};

    `ifndef ALTERA_RESERVED_QIS
      defparam xcvr_s10.xcvr_native_s10_0.hssi_10g_tx_pcs_frmgen_mfrm_length  = SIM_MODE ? 128 : METALEN;
      defparam xcvr_s10.xcvr_native_s10_0.hssi_10g_rx_pcs_frmsync_mfrm_length = SIM_MODE ? 128 : METALEN;
    `endif

  end else if (DEVICE_FAMILY == "Arria 10") begin 
    wire   [NUM_LANES-1:0][128-1:0]  tx_enh_din;         //128 bit 
    wire   [NUM_LANES-1:0][18-1 :0]  tx_enh_control;     //18  bit
    wire   [NUM_LANES-1:0][128-1:0]  rx_enh_dout;        //128 bit
    wire   [NUM_LANES-1:0][20-1 :0]  rx_enh_control;     //20  bit

    for (i=0; i<NUM_LANES; i=i+1) begin: tx_enh_data_gen
      assign tx_enh_din[i]                       = {64'b0, tx_parallel_data[64*(i+1)-1:64*i]};
      assign tx_enh_control[i]                   = {9'b0,tx_crc32err_inject[i],6'b0, tx_control[i], ~tx_control[i]};
      assign rx_parallel_data[64*(i+1)-1:64*i]   = rx_enh_dout[i][64-1:0];  
      assign rx_control[i]                       = rx_enh_control[i][1];
    end

    uflex_ilk_xcvr xcvr (
      .tx_analogreset            (tx_analogreset            ), //  input  wire [7:0]              tx_analogreset.tx_analogreset
      .tx_digitalreset           (tx_digitalreset           ), //  input  wire [7:0]             tx_digitalreset.tx_digitalreset
      .rx_analogreset            (rx_analogreset            ), //  input  wire [7:0]              rx_analogreset.rx_analogreset
      .rx_digitalreset           (rx_digitalreset           ), //  input  wire [7:0]             rx_digitalreset.rx_digitalreset
      .tx_cal_busy               (tx_cal_busy               ), //  output wire [7:0]                 tx_cal_busy.tx_cal_busy
      .rx_cal_busy               (rx_cal_busy               ), //  output wire [7:0]                 rx_cal_busy.rx_cal_busy
      .tx_serial_clk0            (tx_serial_clk             ), //  input  wire [7:0]              tx_serial_clk0.clk
      .rx_cdr_refclk0            (pll_ref_clk               ), //  input  wire                    rx_cdr_refclk0.clk
      .tx_serial_data            (tx_pin                    ), //  output wire [7:0]              tx_serial_data.tx_serial_data
      .rx_serial_data            (rx_pin                    ), //  input  wire [7:0]              rx_serial_data.rx_serial_data
      .rx_is_lockedtoref         (rx_is_lockedtoref         ), //  output wire [7:0]           rx_is_lockedtoref.rx_is_lockedtoref
      .rx_is_lockedtodata        (rx_is_lockedtodata        ), //  output wire [7:0]          rx_is_lockedtodata.rx_is_lockedtodata
      .tx_coreclkin              ({(NUM_LANES){tx_clk}}     ), //  input  wire [7:0]                tx_coreclkin.clk
      .rx_coreclkin              ({(NUM_LANES){rx_clk}}     ), //  input  wire [7:0]                rx_coreclkin.clk
      .tx_clkout                 (tx_clkout                 ), //  output wire [7:0]                   tx_clkout.clk
      .rx_clkout                 (rx_clkout                 ), //  output wire [7:0]                   rx_clkout.clk
      .tx_parallel_data          (tx_enh_din                ), //  input  wire [1023:0]         tx_parallel_data.tx_parallel_data
      .rx_parallel_data          (rx_enh_dout               ), //  output wire [1023:0]         rx_parallel_data.rx_parallel_data
      .tx_control                (tx_enh_control            ), //  input  wire [143:0]                tx_control.tx_control
      .rx_control                (rx_enh_control            ), //  output wire [159:0]                rx_control.rx_control
      .tx_enh_data_valid         (tx_enh_data_valid         ), //  input  wire [7:0]           tx_enh_data_valid.tx_enh_data_valid
      .reconfig_clk              (reconfig_clk              ), //  input  wire [0:0]                reconfig_clk.clk
      .reconfig_reset            (reconfig_reset            ), //  input  wire [0:0]              reconfig_reset.reset
      .reconfig_write            (reconfig_write            ), //  input  wire [0:0]               reconfig_avmm.write
      .reconfig_read             (reconfig_read             ), //  input  wire [0:0]                            .read
      .reconfig_address          (reconfig_address[(9+clogb2(NUM_LANES-1)):0]), //  input  wire [12:0]                           .address
      .reconfig_writedata        (reconfig_writedata        ), //  input  wire [31:0]                           .writedata
      .reconfig_readdata         (reconfig_readdata         ), //  output wire [31:0]                           .readdata
      .reconfig_waitrequest      (reconfig_waitrequest      ), //  output wire [0:0]                            .waitrequest
      .rx_set_locktodata         (rx_set_locktodata         ), //  input  wire [7:0]           rx_set_locktodata.rx_set_locktodata
      .rx_set_locktoref          (rx_set_locktoref          ), //  input  wire [7:0]            rx_set_locktoref.rx_set_locktoref
      .rx_seriallpbken           (rx_seriallpbken           ), //  input  wire [7:0]             rx_seriallpbken.rx_seriallpbken
      .rx_prbs_err_clr           ({NUM_LANES{1'b0}}         ), //  input  wire [7:0]             rx_prbs_err_clr.rx_prbs_err_clr
      .rx_prbs_done              (),                           //  keep floating for A10                          
      .rx_prbs_err               (),                           //  kepp floating for A10
      .tx_enh_fifo_full          (tx_enh_fifo_full          ), //  output wire [7:0]            tx_enh_fifo_full.tx_enh_fifo_full
      .tx_enh_fifo_pfull         (tx_enh_fifo_pfull         ), //  output wire [7:0]           tx_enh_fifo_pfull.tx_enh_fifo_pfull
      .tx_enh_fifo_empty         (tx_enh_fifo_empty         ), //  output wire [7:0]           tx_enh_fifo_empty.tx_enh_fifo_empty
      .tx_enh_fifo_pempty        (tx_enh_fifo_pempty        ), //  output wire [7:0]          tx_enh_fifo_pempty.tx_enh_fifo_pempty
      .tx_enh_fifo_cnt           (                          ), //  output wire [31:0]            tx_enh_fifo_cnt.tx_enh_fifo_cnt
      .rx_enh_data_valid         (rx_enh_data_valid         ), //  output wire [7:0]           rx_enh_data_valid.rx_enh_data_valid
      .rx_enh_fifo_full          (rx_enh_fifo_full          ), //  output wire [7:0]            rx_enh_fifo_full.rx_enh_fifo_full
      .rx_enh_fifo_pfull         (rx_enh_fifo_pfull         ), //  output wire [7:0]           rx_enh_fifo_pfull.rx_enh_fifo_pfull
      .rx_enh_fifo_empty         (rx_enh_fifo_empty         ), //  output wire [7:0]           rx_enh_fifo_empty.rx_enh_fifo_empty
      .rx_enh_fifo_pempty        (rx_enh_fifo_pempty        ), //  output wire [7:0]          rx_enh_fifo_pempty.rx_enh_fifo_pempty
      .rx_enh_fifo_rd_en         (rx_enh_fifo_rd_en         ), //  input  wire [7:0]           rx_enh_fifo_rd_en.rx_enh_fifo_rd_en
      .rx_enh_fifo_align_val     (                          ), //  output wire [7:0]       rx_enh_fifo_align_val.rx_enh_fifo_align_val
      .rx_enh_fifo_align_clr     (rx_enh_fifo_align_clr     ), //  input  wire [7:0]       rx_enh_fifo_align_clr.rx_enh_fifo_align_clr
      .tx_enh_frame              (tx_enh_frame              ), //  output wire [7:0]                tx_enh_frame.tx_enh_frame
      .tx_enh_frame_diag_status  ({(NUM_LANES){2'b11}}      ), //  input  wire [15:0]   tx_enh_frame_diag_status.tx_enh_frame_diag_status
      .tx_enh_frame_burst_en     (tx_enh_frame_burst_en     ), //  input  wire [7:0]             tx_enh_burst_en.tx_enh_frame_burst_en
      .rx_enh_frame              (                          ), //  output wire [7:0]                rx_enh_frame.rx_enh_frame
      .rx_enh_frame_lock         (rx_enh_frame_lock         ), //  output wire [7:0]           rx_enh_frame_lock.rx_enh_frame_lock
      .rx_enh_frame_diag_status  (                          ), //  output wire [15:0]   rx_enh_frame_diag_status.rx_enh_frame_diag_status
      .rx_enh_crc32_err          (rx_enh_crc32_err          ), //  output wire [7:0]             rx_enh_crc32err.rx_enh_crc32err
      .rx_enh_blk_lock           (rx_enh_blk_lock           )  //  output wire [7:0]             rx_enh_blk_lock.rx_enh_blk_lock
     ); //A10:uflex_ilk_xcvr  

     assign rx_enh_sh_err             = {(NUM_LANES){1'b0}};
     assign rx_prbs_done              = {(NUM_LANES){1'b0}};
     assign rx_prbs_err               = {(NUM_LANES){1'b0}};
     assign reconfig_from_xcvr        = {(NUM_LANES*46){1'b0}};
     assign tx_dll_lock               = {(NUM_LANES){1'b0}};
     assign rx_analogreset_stat       = {(NUM_LANES){1'b0}}; 
     assign rx_digitalreset_stat      = {(NUM_LANES){1'b0}};
     assign tx_analogreset_stat       = {(NUM_LANES){1'b0}};
     assign tx_digitalreset_stat      = {(NUM_LANES){1'b0}}; 
    
    `ifndef ALTERA_RESERVED_QIS
      defparam xcvr.uflex_ilk_xcvr.hssi_10g_tx_pcs_frmgen_mfrm_length  = SIM_MODE ? 128 : METALEN;
      defparam xcvr.uflex_ilk_xcvr.hssi_10g_rx_pcs_frmsync_mfrm_length = SIM_MODE ? 128 : METALEN;
    `endif

  end else begin 
    wire   [NUM_LANES-1:0][64-1:0]  tx_10g_din;         //64 bit
    wire   [NUM_LANES-1:0][9-1: 0]  tx_10g_control;     //9  bit
    wire   [NUM_LANES-1:0][64-1:0]  rx_10g_dout;        //64  bit
    wire   [NUM_LANES-1:0][10-1:0]  rx_10g_control;     //10  bit

    for (i=0; i<NUM_LANES; i=i+1) begin : tx_10g_data_gen
      assign tx_10g_din[i]                      = tx_parallel_data[64*(i+1)-1:64*i];
      assign tx_10g_control[i]                  = {tx_crc32err_inject[i],6'b0, tx_control[i], ~tx_control[i]};
      assign rx_parallel_data[64*(i+1)-1:64*i]   = rx_10g_dout[i];
      assign rx_control[i]                       = ~rx_10g_control[i][0];
    end

    uflex_ilk_xcvr xcvr (
      .pll_powerdown             ({(NUM_LANES){pll_powerdown}}),//       input  wire [7:0]               pll_powerdown.pll_powerdown
      .tx_analogreset            (tx_analogreset            ), //  input  wire [7:0]              tx_analogreset.tx_analogreset
      .tx_digitalreset           (tx_digitalreset           ), //  input  wire [7:0]             tx_digitalreset.tx_digitalreset
      .tx_serial_data            (tx_pin                    ), //  output wire [7:0]              tx_serial_data.tx_serial_data
      .ext_pll_clk               (tx_serial_clk             ), //  input  wire [7:0]                 ext_pll_clk.ext_pll_clk
      .rx_analogreset            (rx_analogreset            ), //  input  wire [7:0]              rx_analogreset.rx_analogreset
      .rx_digitalreset           (rx_digitalreset           ), //  input  wire [7:0]             rx_digitalreset.rx_digitalreset
      .rx_cdr_refclk             (pll_ref_clk               ), //  input  wire [0:0]               rx_cdr_refclk.rx_cdr_refclk
      .rx_serial_data            (rx_pin                    ), //  input  wire [7:0]              rx_serial_data.rx_serial_data
      .rx_set_locktodata         (rx_set_locktodata         ), //  input  wire [7:0]           rx_set_locktodata.rx_set_locktodata
      .rx_set_locktoref          (rx_set_locktoref          ), //  input  wire [7:0]            rx_set_locktoref.rx_set_locktoref
      .rx_is_lockedtoref         (rx_is_lockedtoref         ), //  output wire [7:0]           rx_is_lockedtoref.rx_is_lockedtoref
      .rx_is_lockedtodata        (rx_is_lockedtodata        ), //  output wire [7:0]          rx_is_lockedtodata.rx_is_lockedtodata
      .rx_seriallpbken           (rx_seriallpbken           ), //  input  wire [7:0]             rx_seriallpbken.rx_seriallpbken
      .tx_parallel_data          (tx_10g_din                ), //  input  wire [511:0]          tx_parallel_data.tx_parallel_data
      .rx_parallel_data          (rx_10g_dout               ), //  output wire [511:0]          rx_parallel_data.rx_parallel_data
      .tx_10g_coreclkin          ({(NUM_LANES){tx_clk}}     ), //  input  wire [7:0]            tx_10g_coreclkin.tx_10g_coreclkin
      .rx_10g_coreclkin          ({(NUM_LANES){rx_clk}}     ), //  input  wire [7:0]            rx_10g_coreclkin.rx_10g_coreclkin
      .tx_10g_clkout             (tx_clkout                 ), //  output wire [7:0]               tx_10g_clkout.tx_10g_clkout
      .rx_10g_clkout             (rx_clkout                 ), //  output wire [7:0]               rx_10g_clkout.rx_10g_clkout
      .rx_10g_prbs_err_clr       (rx_prbs_err_clr           ), //  input  wire [7:0]         rx_10g_prbs_err_clr.rx_10g_prbs_err_clr
      .rx_10g_prbs_done          (rx_prbs_done              ), //  output wire [7:0]            rx_10g_prbs_done.rx_10g_prbs_done
      .rx_10g_prbs_err           (rx_prbs_err               ), //  output wire [7:0]             rx_10g_prbs_err.rx_10g_prbs_err
      .tx_10g_control            (tx_10g_control            ), //  input  wire [71:0]             tx_10g_control.tx_10g_control
      .rx_10g_control            (rx_10g_control            ), //  output wire [79:0]             rx_10g_control.rx_10g_control
      .tx_10g_data_valid         (tx_enh_data_valid         ), //  input  wire [7:0]           tx_10g_data_valid.tx_10g_data_valid
      .tx_10g_fifo_full          (tx_enh_fifo_full          ), //  output wire [7:0]            tx_10g_fifo_full.tx_10g_fifo_full
      .tx_10g_fifo_pfull         (tx_enh_fifo_pfull         ), //  output wire [7:0]           tx_10g_fifo_pfull.tx_10g_fifo_pfull
      .tx_10g_fifo_empty         (tx_enh_fifo_empty         ), //  output wire [7:0]           tx_10g_fifo_empty.tx_10g_fifo_empty
      .tx_10g_fifo_pempty        (tx_enh_fifo_pempty        ), //  output wire [7:0]          tx_10g_fifo_pempty.tx_10g_fifo_pempty
      .rx_10g_fifo_rd_en         (rx_enh_fifo_rd_en         ), //  input  wire [7:0]           rx_10g_fifo_rd_en.rx_10g_fifo_rd_en
      .rx_10g_data_valid         (rx_enh_data_valid         ), //  output wire [7:0]           rx_10g_data_valid.rx_10g_data_valid
      .rx_10g_fifo_full          (rx_enh_fifo_full          ), //  output wire [7:0]            rx_10g_fifo_full.rx_10g_fifo_full
      .rx_10g_fifo_pfull         (rx_enh_fifo_pfull         ), //  output wire [7:0]           rx_10g_fifo_pfull.rx_10g_fifo_pfull
      .rx_10g_fifo_empty         (rx_enh_fifo_empty         ), //  output wire [7:0]           rx_10g_fifo_empty.rx_10g_fifo_empty
      .rx_10g_fifo_pempty        (rx_enh_fifo_pempty        ), //  output wire [7:0]          rx_10g_fifo_pempty.rx_10g_fifo_pempty
      .rx_10g_fifo_align_val     (                          ), //  output wire [7:0]       rx_10g_fifo_align_val.rx_10g_fifo_align_val
      .rx_10g_fifo_align_clr     (rx_enh_fifo_align_clr     ), //  input  wire [7:0]       rx_10g_fifo_align_clr.rx_10g_fifo_align_clr
      .rx_10g_fifo_align_en      ({(NUM_LANES){1'b1}}       ), //  input  wire [7:0]        rx_10g_fifo_align_en.rx_10g_fifo_align_en
      .tx_10g_frame              (tx_enh_frame              ), //  output wire [7:0]                tx_10g_frame.tx_10g_frame
      .tx_10g_frame_diag_status  ({(NUM_LANES){2'b11}}      ), //  input  wire [15:0]   tx_10g_frame_diag_status.tx_10g_frame_diag_status
      .tx_10g_frame_burst_en     (tx_enh_frame_burst_en     ), //  input  wire [7:0]             tx_10g_burst_en.tx_10g_frame_burst_en
      .rx_10g_frame              (                          ), //  output wire [7:0]                rx_10g_frame.rx_10g_frame
      .rx_10g_frame_lock         (rx_enh_frame_lock         ), //  output wire [7:0]           rx_10g_frame_lock.rx_10g_frame_lock
      .rx_10g_frame_mfrm_err     (                          ), //  output wire [7:0]       rx_10g_frame_mfrm_err.rx_10g_frame_mfrm_err
      .rx_10g_frame_diag_status  (                          ), //  output wire [15:0]   rx_10g_frame_diag_status.rx_10g_frame_diag_status
      .rx_10g_crc32_err          (rx_enh_crc32_err          ), //  output wire [7:0]             rx_10g_crc32err.rx_10g_crc32err
      .rx_10g_blk_lock           (rx_enh_blk_lock           ), //  output wire [7:0]             rx_10g_blk_lock.rx_10g_blk_lock
      .rx_10g_blk_sh_err         (rx_enh_sh_err             ), //  output wire [11:0]        rx_10g_blk_sh_err.rx_10g_blk_sh_err
      .tx_cal_busy               (tx_cal_busy               ), //  output wire [7:0]                 tx_cal_busy.tx_cal_busy
      .rx_cal_busy               (rx_cal_busy               ), //  output wire [7:0]                 rx_cal_busy.rx_cal_busy
      .reconfig_to_xcvr          (reconfig_to_xcvr          ), //  input  wire [559:0]          reconfig_to_xcvr.reconfig_to_xcvr
      .reconfig_from_xcvr        (reconfig_from_xcvr        )  //  output wire [367:0]        reconfig_from_xcvr.reconfig_from_xcvr
    ); //SV:uflex_ilk_xcvr 

    `ifndef ALTERA_RESERVED_QIS
      defparam xcvr.uflex_ilk_xcvr_inst .teng_tx_frmgen_user_length      = SIM_MODE ? 128 : METALEN;
      defparam xcvr.uflex_ilk_xcvr_inst .teng_rx_frmsync_user_length     = SIM_MODE ? 128 : METALEN;
    `endif

    assign reconfig_readdata         = 32'h0;
    assign reconfig_waitrequest      = 1'b0;
    assign rx_analogreset_stat      = {(NUM_LANES){1'b0}}; 
    assign rx_digitalreset_stat     = {(NUM_LANES){1'b0}};
    assign tx_analogreset_stat      = {(NUM_LANES){1'b0}};
    assign tx_digitalreset_stat     = {(NUM_LANES){1'b0}}; 

  end
  endgenerate
  
  function integer clogb2;
    input integer input_num;
    begin
      for (clogb2=0; input_num>0; clogb2=clogb2+1)
        input_num = input_num >> 1;
      if(clogb2 == 0)
        clogb2 = 1;
    end
  endfunction

// synthesis translate_off
wire [INTERNAL_WORDS-1:0][64-1:0] tx_dbg  = tx_data; 
wire [INTERNAL_WORDS-1:0][64-1:0] rx_dbg  = rx_data;
// synthesis translate_on
//
endmodule
