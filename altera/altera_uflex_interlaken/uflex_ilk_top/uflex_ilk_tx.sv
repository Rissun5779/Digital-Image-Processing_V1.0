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
module uflex_ilk_tx #(
  parameter DEVICE_FAMILY        = "Arria 10",   // Stratix V or Arria 10
  parameter SIM_MODE             = 0,            // If set to 1, METALEN shall be overriden to 128 in simulation
  parameter METALEN              = 2048,         // 
  parameter PMA_WIDTH            = 32,           // 32 or 40
  parameter TXFIFO_PEMPTY        = 1,            // partial empty threshold for TX PCS FIFO
  parameter ILA_MODE             = 0,            // 1: ILA mode 0: ILK mode
  parameter STRIPER              = 1,            // 0: non-striper mode (# of lane : # of segment == 1:1) 1:striper mode
  parameter NUM_LANES            = 4,            // number of lanes
  parameter INTERNAL_WORDS       = 4,            // number of segment (words) in the user interface
  parameter TX_CREDIT_LATENCY    = 4,            // latency between tx_credit and tx_valid
  parameter CALENDAR_PAGES       = 1,            // number of inband flow control 16-bit calendar pages
  parameter LOG_CALENDAR_PAGES   = 1,            // the width of the internal counter htat tracks the current calendar page
  parameter SWAP_TX_LANES        = 1,            // 1 = data is striped from lane 0 to lane M. 0 = data is striped from lane M to lane 0
  parameter INBAND_FLW_ON = 1,
  parameter TX_ERR_INJ_EN        = 0
)(
  // Clock and reset
  input                                tx_clk,
  input                                tx_srst,
  input                                pcs_clk,
  input                                pcs_srst,

  input  [NUM_LANES-1:0]               tx_ready,       //S10
  input  [NUM_LANES-1:0]               tx_dll_lock,    //S10

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

  // CSR interface
  input  [NUM_LANES-1:0]               tx_err_inj,
  output [2:0]                         txa_sm,   
  output                               tx_lanes_aligned,  

  // Miscellaneous signals
  output                               tx_overflow,
  output                               tx_underflow 
);

  // tx barebone interface signal
  wire                                 tx_bb_data_val;
  wire   [INTERNAL_WORDS*64-1:0]       tx_bb_data;
  wire   [INTERNAL_WORDS-1:0]          tx_bb_data_ctrl;

  // tx CRC interface signal
  wire                                 tx_crc_data_val;
  wire   [INTERNAL_WORDS*64-1:0]       tx_crc_data;
  wire   [INTERNAL_WORDS-1:0]          tx_crc_data_ctrl;

  // tx stripper interface signal
  wire   [NUM_LANES-1:0]               tx_striper_data_val;
  wire   [NUM_LANES*64-1:0]            tx_striper_data;
  wire   [NUM_LANES-1:0]               tx_striper_data_ctrl;
  wire   [INTERNAL_WORDS*17-1:0]       tx_bb_page_out_lr;  

  localparam                           NUM_PIPE_USR2PCS = ILA_MODE ? 18 : (STRIPER ? 18 : 18);

  generate
  if (ILA_MODE) begin

    assign tx_bb_page_out_lr = {INTERNAL_WORDS*17{1'b0}};

    uflex_ilk_tx_ila #(
      .DEVICE_FAMILY                   (DEVICE_FAMILY        ),
      .CALENDAR_PAGES                  (CALENDAR_PAGES),
      .INTERNAL_WORDS                  (INTERNAL_WORDS)
    ) inst_tx_ila (
      .clk                             (tx_clk                          ), // input                              
      .srst                            (tx_srst                         ), // input                              

      .tx_valid                        (tx_valid                        ), // input                              
      .tx_idle                         (tx_idle                         ), // input      [INTERNAL_WORDS-1:0]    
      .tx_sop                          (tx_sop                          ), // input      [INTERNAL_WORDS-1:0]    
      .tx_eopbits                      (tx_eopbits                      ), // input      [INTERNAL_WORDS*4-1:0]  
      .tx_chan                         (tx_chan                         ), // input      [INTERNAL_WORDS*8-1:0]  
      .tx_ctrl                         (tx_ctrl                         ), // input      [INTERNAL_WORDS*29-1:0] 
      .tx_data                         (tx_data                         ), // input      [INTERNAL_WORDS*64-1:0] 
      .tx_calendar                     (tx_calendar                     ), // input      [CALENDAR_PAGES*16-1:0] 

      .tx_ila_data                     (tx_bb_data                      ), // output reg [INTERNAL_WORDS*64-1:0] 
      .tx_ila_data_ctrl                (tx_bb_data_ctrl                 ), // output reg [INTERNAL_WORDS-1:0]    
      .tx_ila_valid                    (tx_bb_data_val                  )  // output reg                         
    );

  end else begin

    uflex_ilk_tx_ibfc #(
      .DEVICE_FAMILY                   (DEVICE_FAMILY  ),
      .INTERNAL_WORDS                  (INTERNAL_WORDS ),
      .INBAND_FLW_ON    (INBAND_FLW_ON    ),
      .CALENDAR_PAGES                  (CALENDAR_PAGES ),
      .LOG_CALENDAR_PAGES              (LOG_CALENDAR_PAGES)
    ) inst_tx_ibfc (
      .clk                             (tx_clk                          ), // input                              
      .srst                            (tx_srst                         ), // input                              
      

      .tx_valid                        (tx_valid                        ), // input                              
      .tx_idle                         (tx_idle                         ), // input      [INTERNAL_WORDS-1:0]    
      .tx_sob                          (tx_sob                          ), // input      [INTERNAL_WORDS-1:0]    
      .tx_sop                          (tx_sop                          ), // input      [INTERNAL_WORDS-1:0]    
      .tx_eopbits                      (tx_eopbits                      ), // input      [INTERNAL_WORDS*4-1:0]  
      .tx_chan                         (tx_chan                         ), // input      [INTERNAL_WORDS*8-1:0]  
      .tx_data                         (tx_data                         ), // input      [INTERNAL_WORDS*64-1:0] 
      .tx_calendar                     (tx_calendar                     ), // input      [CALENDAR_PAGES*16-1:0] 

      .tx_ibfc_data                    (tx_bb_data                      ), // output reg [INTERNAL_WORDS*64-1:0] 
      .tx_ibfc_data_ctrl               (tx_bb_data_ctrl                 ), // output reg [INTERNAL_WORDS-1:0]    
      .tx_ibfc_valid                   (tx_bb_data_val                  ),  // output reg        
      .tx_page_out                     (tx_bb_page_out_lr                  )	  
    );

  end
  endgenerate

  uflex_ilk_tx_crc24 #(
    .DEVICE_FAMILY                     (DEVICE_FAMILY ),
    .STRIPER                           (STRIPER       ),
    .ILA_MODE                          (ILA_MODE      ),
    .INBAND_FLW_ON                     (INBAND_FLW_ON),
    .INTERNAL_WORDS                    (INTERNAL_WORDS)
  ) inst_tx_crc (
    .clk                               (tx_clk                          ), // input                              
    .srst                              (tx_srst                         ), // input                              

    .din_val                           (tx_bb_data_val                  ), // input 
    .din                               (tx_bb_data                      ), // input      [INTERNAL_WORDS*64-1:0] 
    .din_ctrl                          (tx_bb_data_ctrl                 ), // input      [INTERNAL_WORDS-1:0]   
    .din_page_out                      (tx_bb_page_out_lr               ),
	

    .dout_val                          (tx_crc_data_val                 ), //
    .dout                              (tx_crc_data                     ), // output     [INTERNAL_WORDS*64-1:0] 
    .dout_ctrl                         (tx_crc_data_ctrl                )  // output     [INTERNAL_WORDS-1:0]    
  );

  uflex_ilk_tx_striper #(
    .DEVICE_FAMILY                     (DEVICE_FAMILY        ),
    .STRIPER                           (STRIPER),
    .NUM_LANES                         (NUM_LANES),
    .SWAP_TX_LANES                     (SWAP_TX_LANES),
    .INTERNAL_WORDS                    (INTERNAL_WORDS)
  ) inst_tx_striper (
    .clk                               (tx_clk                          ), // input                              
    .srst                              (tx_srst                         ), // input                              

    .din_val                           (tx_crc_data_val                 ), // input                              
    .din_ctrl                          (tx_crc_data_ctrl                ), // input  [INTERNAL_WORDS-1:0]        
    .din                               (tx_crc_data                     ), // input  [INTERNAL_WORDS*64-1:0]     

    .overflow                          (tx_overflow                     ), // output
    .underflow                         (tx_underflow                    ), // output
    .dout_val                          (tx_striper_data_val             ), // output [INTERNAL_WORDS-1:0]        
    .dout_ctrl                         (tx_striper_data_ctrl            ), // output [INTERNAL_WORDS-1:0]        
    .dout                              (tx_striper_data                 )  // output [INTERNAL_WORDS*64-1:0]     
  );

  uflex_ilk_tx_pcsif #(
    .DEVICE_FAMILY                     (DEVICE_FAMILY    ),  
    .TX_CREDIT_LATENCY                 (TX_CREDIT_LATENCY),   
    .NUM_PIPE_USR2PCS                  (NUM_PIPE_USR2PCS),   
    .METALEN                           (METALEN),           
    .TXFIFO_PEMPTY                     (TXFIFO_PEMPTY),
    .INTERNAL_WORDS                    (INTERNAL_WORDS),  
    .PMA_WIDTH                         (PMA_WIDTH),        
    .NUM_LANES                         (NUM_LANES),
    .TX_ERR_INJ_EN                     (TX_ERR_INJ_EN)
  ) inst_tx_pcsif (
    // Clock and reset
    .tx_clk                            (tx_clk                         ), // input                                
    .tx_srst                           (tx_srst                        ), // input                                
    .pcs_clk                           (pcs_clk                        ), // input                                
    .pcs_srst                          (pcs_srst                       ), // input                                

    .tx_ready                          (tx_ready                       ), // input S10
    .tx_dll_lock                       (tx_dll_lock                    ), // input S10

    // TX striper interface
    .din                               (tx_striper_data                ), // input  [INTERNAL_WORDS*64-1:0]       
    .din_valid                         (tx_striper_data_val            ), // input  [INTERNAL_WORDS-1:0]          
    .din_ctrl                          (tx_striper_data_ctrl           ), // input  [INTERNAL_WORDS-1:0]          

    // TX PCS FIFO Interface
    .tx_parallel_data                  (tx_parallel_data               ), // output [NUM_LANES*64-1:0]            
    .tx_control                        (tx_control                     ), // output [NUM_LANES-1:0]               
    .tx_enh_data_valid                 (tx_enh_data_valid              ), // output [NUM_LANES-1:0]               
    .tx_enh_fifo_full                  (tx_enh_fifo_full               ), // input  [NUM_LANES-1:0]               
    .tx_enh_fifo_pfull                 (tx_enh_fifo_pfull              ), // input  [NUM_LANES-1:0]
    .tx_enh_fifo_empty                 (tx_enh_fifo_empty              ), // input  [NUM_LANES-1:0]               
    .tx_enh_fifo_pempty                (tx_enh_fifo_pempty             ), // input  [NUM_LANES-1:0]               
    .tx_enh_frame                      (tx_enh_frame                   ), // input  [NUM_LANES-1:0]               
    .tx_enh_frame_burst_en             (tx_enh_frame_burst_en          ), // output [NUM_LANES-1:0]               

     // Miscellaneous signals
    .tx_credit                         (tx_credit                      ), // output 

     // CSR interface
    .tx_err_inj                        (tx_err_inj                     ), // input  [NUM_LANES-1:0]
    .txa_sm                            (txa_sm                         ), // output [NUM_LANES-1:0]               
    .tx_lanes_aligned                  (tx_lanes_aligned               )  // output                               
  ); 

endmodule
