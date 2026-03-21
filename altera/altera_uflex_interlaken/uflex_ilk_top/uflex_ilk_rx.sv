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
module uflex_ilk_rx #(
  parameter DEVICE_FAMILY        = "Arria 10",   // Stratix V or Arria 10
  parameter PMA_WIDTH            = 32,           // 32 or 40
  parameter ILA_MODE             = 0,            // 1: ILA mode 0: ILK mode
  parameter STRIPER              = 1,            // 0: non-striper mode (# of lane : # of segment == 1:1) 1:striper mode
  parameter NUM_LANES            = 4,            // number of lanes
  parameter INTERNAL_WORDS       = 4,            // number of segment (words) in the user interface
  parameter CALENDAR_PAGES       = 1,            // number of inband flow control 16-bit calendar pages
  parameter LOG_CALENDAR_PAGES   = 1,            // the width of the internal counter htat tracks the current calendar page
  parameter SWAP_RX_LANES        = 1,            // 1 = data is striped from lane 0 to lane M. 0 = data is striped from lane M to lane 0 
  parameter INBAND_FLW_ON = 1,
  parameter IBFC_ERR		 = 1	         // Instantiates the Ibfc err handler module.	
)(
  // Clock and reset
  input                                rx_clk,
  input                                rx_srst,

  // RX User Interface
  output                               rx_valid,
  output [INTERNAL_WORDS-1:0]          rx_idle,
  output [INTERNAL_WORDS-1:0]          rx_sob,
  output [INTERNAL_WORDS-1:0]          rx_sop,
  output [INTERNAL_WORDS*4-1:0]        rx_eopbits,
  output [ILA_MODE ? INTERNAL_WORDS-1 : INTERNAL_WORDS*8-1:0] rx_chan,
  output [INTERNAL_WORDS*29-1:0]       rx_ctrl,
  output [INTERNAL_WORDS*64-1:0]       rx_data,
  output [INTERNAL_WORDS-1:0]          rx_crc24_err,
  output [CALENDAR_PAGES*16-1:0]       rx_calendar,

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
  input  [NUM_LANES-1:0]               rx_enh_blk_lock,

  // CSR interface
  output [4:0]                         rxa_timer,
  output [1:0]                         rxa_sm,
  output                               rx_lanes_aligned,
 
  // Miscellaneous signals
  output [NUM_LANES-1:0]               rx_wordlock,
  output [NUM_LANES-1:0]               rx_metalock,
  output [NUM_LANES-1:0]               rx_crc32_err,
  output                               rx_overflow,
  
  //Raw signals
  output [INTERNAL_WORDS*64-1:0]       rx_raw_data,
  output                               rx_raw_data_val,
  output [INTERNAL_WORDS-1:0]          rx_raw_data_ctrl,
  output [INTERNAL_WORDS-1:0]          rx_raw_crc24_err
);
  // rx stripper interface signal
  wire                                 rx_striper_data_val;
  wire   [INTERNAL_WORDS*64-1:0]       rx_striper_data;
  wire   [INTERNAL_WORDS-1:0]          rx_striper_data_ctrl;
  wire   [INTERNAL_WORDS-1:0]          rx_crc24_err_in;
	
  // pcsif interface signal
  wire   [NUM_LANES-1:0]               rx_pcs_data_valid;      
  wire   [NUM_LANES-1:0]               rx_pcs_control;        
  wire   [NUM_LANES*64-1:0]            rx_pcs_data; 
  wire   [INTERNAL_WORDS-1:0]          rx_eob;         

  assign rx_raw_data = rx_striper_data;
  assign rx_raw_data_ctrl  = rx_striper_data_ctrl;
  assign rx_raw_data_val   = rx_striper_data_val;
  assign rx_raw_crc24_err  = rx_crc24_err_in;
  
  generate
  if (ILA_MODE) begin
    uflex_ilk_rx_ila #(
      .DEVICE_FAMILY                   (DEVICE_FAMILY         ),
      .CALENDAR_PAGES                  (CALENDAR_PAGES),
      .INTERNAL_WORDS                  (INTERNAL_WORDS),
      .STRIPER                         (STRIPER)
    ) inst_rx_ila (
      .clk                             (rx_clk                          ), // input                              
      .srst                            (rx_srst                         ), // input                              

      .rx_ila_data                     (rx_striper_data                 ), // input      [INTERNAL_WORDS*64-1:0] 
      .rx_ila_data_ctrl                (rx_striper_data_ctrl            ), // input      [INTERNAL_WORDS-1:0]    
      .rx_ila_valid                    (rx_striper_data_val             ), // input 
      .rx_crc24_err                    (rx_crc24_err_in                 ),// input                              

      .rx_valid                        (rx_valid                        ), // output                             
      .rx_idle                         (rx_idle                         ), // output     [INTERNAL_WORDS-1:0]    
      .rx_sop                          (rx_sop                          ), // output     [INTERNAL_WORDS-1:0]    
      .rx_eopbits                      (rx_eopbits                      ), // Clock and reset
      .rx_chan                         (rx_chan                         ), // output     [INTERNAL_WORDS*8-1:0]  
      .rx_crc24_err_out                (rx_crc24_err                    ),
      .rx_ctrl                         (rx_ctrl                         ), // output     [INTERNAL_WORDS*29-1:0] 
      .rx_data                         (rx_data                         ), // output     [INTERNAL_WORDS*64-1:0] 
      .rx_calendar                     (rx_calendar                     )  // output     [CALENDAR_PAGES*16-1:0] 
    );

    assign rx_sob   = {(INTERNAL_WORDS){1'b0}};
  end else begin
    uflex_ilk_rx_ibfc #(
      .DEVICE_FAMILY                   (DEVICE_FAMILY        ),
      .STRIPER                         (STRIPER),
      .INTERNAL_WORDS                  (INTERNAL_WORDS),
      .CALENDAR_PAGES                  (CALENDAR_PAGES),
      .LOG_CALENDAR_PAGES              (LOG_CALENDAR_PAGES),
      .INBAND_FLW_ON                     (INBAND_FLW_ON),
      .IBFC_ERR                        (IBFC_ERR)
    ) inst_rx_ibfc (
      .clk                             (rx_clk                          ), // input                              
      .srst                            (rx_srst                         ), // input                              

      .rx_ibfc_data                    (rx_striper_data                 ), // input  [INTERNAL_WORDS*64-1:0]     
      .rx_ibfc_data_ctrl               (rx_striper_data_ctrl            ), // input  [INTERNAL_WORDS-1:0]        
      .rx_ibfc_valid                   (rx_striper_data_val             ), // input                              
      .rx_crc24_err                    (rx_crc24_err_in                 ),// input	
      .rx_lanes_aligned                (rx_lanes_aligned                ),// input
      
      .rx_valid                        (rx_valid                        ), // output reg                         
      .rx_idle                         (rx_idle                         ), // output reg [INTERNAL_WORDS-1:0]    
      .rx_sob                          (rx_sob                          ), // output reg [INTERNAL_WORDS-1:0]    
      .rx_sop                          (rx_sop                          ), // output reg [INTERNAL_WORDS-1:0]    
      .rx_eopbits                      (rx_eopbits                      ), // output reg [INTERNAL_WORDS*4-1:0]  
      .rx_eob                          (rx_eob                          ), // output reg [INTERNAL_WORDS-1:0]    
      .rx_chan                         (rx_chan                         ), // output reg [INTERNAL_WORDS*8-1:0]  
      .rx_data                         (rx_data                         ), // output reg [INTERNAL_WORDS*64-1:0] 
      .rx_calendar                     (rx_calendar                     ),  // output     [CALENDAR_PAGES*16-1:0] 
      .rx_crc24_err_out                (rx_crc24_err                    )
    );

    assign  rx_ctrl                    = 29'h0;
  end
  endgenerate

  uflex_ilk_rx_crc24 #(
    .DEVICE_FAMILY                     (DEVICE_FAMILY        ),
    .STRIPER                           (STRIPER),
    .INTERNAL_WORDS                    (INTERNAL_WORDS)
  ) inst_rx_crc (
    .clk                               (rx_clk                          ), // input                              
    .srst                              (rx_srst                         ), // input                              

    .din_val                           (rx_striper_data_val             ), // input                              
    .din                               (rx_striper_data                 ), // input      [INTERNAL_WORDS*64-1:0] 
    .din_ctrl                          (rx_striper_data_ctrl            ), // input      [INTERNAL_WORDS-1:0]    

    .crc24_err                         (rx_crc24_err_in             )  // output     [INTERNAL_WORDS-1:0]    
  );

  uflex_ilk_rx_striper #(
    .DEVICE_FAMILY                     (DEVICE_FAMILY        ),
    .STRIPER                           (STRIPER),
    .NUM_LANES                         (NUM_LANES),
    .INTERNAL_WORDS                    (INTERNAL_WORDS),
    .SWAP_RX_LANES                     (SWAP_RX_LANES)  
  ) inst_rx_striper (
    .clk                               (rx_clk                          ), // input                              
    .srst                              (rx_srst                         ), // input                              

    .din_val                           (rx_pcs_data_valid               ), // input  [INTERNAL_WORDS-1:0]        
    .din_ctrl                          (rx_pcs_control                  ), // input  [INTERNAL_WORDS-1:0]        
    .din                               (rx_pcs_data                     ), // input  [INTERNAL_WORDS*64-1:0]     

    .overflow                          (rx_overflow                     ), // output
    .dout_val                          (rx_striper_data_val             ), // output                             
    .dout_ctrl                         (rx_striper_data_ctrl            ), // output [INTERNAL_WORDS-1:0]        
    .dout                              (rx_striper_data                 )  // output [INTERNAL_WORDS*64-1:0]     
  );

  uflex_ilk_rx_pcsif #(
    .DEVICE_FAMILY                     (DEVICE_FAMILY        ),  
    .INTERNAL_WORDS                    (INTERNAL_WORDS),
    .NUM_LANES                         (NUM_LANES) 
  ) inst_rx_pcsif (
    // Clock and reset
    .rx_clk                            (rx_clk                          ), //  input                                
    .rx_srst                           (rx_srst                         ), //  input                                

    // RX PCS FIFO Interface
    .rx_parallel_data                  (rx_parallel_data                ), //  input   [NUM_LANES*64-1:0]          
    .rx_enh_control                    (rx_control                      ), //  input   [NUM_LANES-1:0]             
    .rx_enh_data_valid                 (rx_enh_data_valid               ), //  input   [NUM_LANES-1:0]             
    .rx_enh_fifo_full                  (rx_enh_fifo_full                ), //  input    [NUM_LANES-1:0] 
    .rx_enh_fifo_pfull                 (rx_enh_fifo_pfull               ), //  input    [NUM_LANES-1:0] 
    .rx_enh_fifo_empty                 (rx_enh_fifo_empty               ), //  input    [NUM_LANES-1:0] 
    .rx_enh_fifo_pempty                (rx_enh_fifo_pempty              ), //  input    [NUM_LANES-1:0]             
    .rx_enh_fifo_rd_en                 (rx_enh_fifo_rd_en               ), //  output   [NUM_LANES-1:0]             

    .rx_enh_fifo_align_clr             (rx_enh_fifo_align_clr           ), //  output   [NUM_LANES-1:0]             
    .rx_enh_frame_lock                 (rx_enh_frame_lock               ), //  input    [NUM_LANES-1:0]             
    .rx_enh_crc32_err                  (rx_enh_crc32_err                ), //  input    [NUM_LANES-1:0]             
    .rx_enh_blk_lock                   (rx_enh_blk_lock                 ), //  input    [NUM_LANES-1:0]             
 
    // Miscellaneous signals
    .rx_wordlock                       (rx_wordlock                     ), //  output   [NUM_LANES-1:0]  
    .rx_metalock                       (rx_metalock                     ), //  output   [NUM_LANES-1:0] 
    .rx_crc32_err                      (rx_crc32_err                    ), //  output   [NUM_LANES-1:0]          

    // RX striper interface
    .rx_valid                          (rx_pcs_data_valid               ), //  output reg  [NUM_LANES-1:0]          
    .rx_dout                           (rx_pcs_data                     ), //  output reg  [NUM_LANES*64-1:0]       
    .rx_control                        (rx_pcs_control                  ), //  output reg  [NUM_LANES-1:0]          
  
    // CSR interface
    .rxa_timer                         (rxa_timer                       ), //  output [4:0]                         
    .rxa_sm                            (rxa_sm                          ), //  output [1:0]                         
    .rx_lanes_aligned                  (rx_lanes_aligned                )  //  output                               
  );

endmodule
