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


// $Id: //acds/main/ip/altera_voltage_sensor/control/altera_voltage_sensor_control.sv#3 $
// $Revision: #3 $
// $Date: 2015/01/18 $
// $Author: tgngo $

// +-----------------------------------------------------------
// | Nadder SDM mailbox streaming controller 
// | 
// +-----------------------------------------------------------
`timescale 1 ns/ 1 ns

module altera_mailbox_streaming_controller
#(
  parameter STR_PCK_WIDTH      = 32,
  parameter NUMB_4K_BLOCK      = 4,
  parameter GPI_WIDTH          = 4,
  parameter ADDR_W             = 32,
  parameter DATA_W             = 64,
  parameter ID_W               = 4,  
  parameter USER_W             = 4, 
  parameter WSTRB_W            = DATA_W / 8
  )    
   (
    // +--------------------------------------------------
    // | Clock and reset
    // | Note reset will be synchronous
    // +--------------------------------------------------
    input                      clk,
    input                      reset,

    // +--------------------------------------------------
    // | AXI4 master signals
    // +--------------------------------------------------
    // AXI write address channel
    input [ID_W-1 : 0]         aw_id,
    input [ADDR_W-1 : 0]       aw_addr,
    input [7:0]                aw_len, 
    input [2:0]                aw_size,
    input [1:0]                aw_burst,
    input                      aw_lock,
    input [3:0]                aw_cache,
    input [2:0]                aw_prot,
    input [3:0]                aw_qos,
    input                      aw_valid,
    input [USER_W-1 : 0]       aw_user,
    output                     aw_ready,
    // AXI write data channel
    input [DATA_W-1 : 0]       w_data,
    input [WSTRB_W-1 : 0]      w_strb,
    input                      w_last,
    input                      w_valid,
    output                     w_ready,
    // AXI write response channel
    output [ID_W-1:0]          b_id,
    output [1:0]               b_resp,
    output                     b_valid,
    input                      b_ready,

    // AXI read address channel
    input [ID_W-1 : 0]         ar_id,
    input [ADDR_W-1 : 0]       ar_addr,
    input [7 : 0]              ar_len,
    input [2:0]                ar_size,
    input [1:0]                ar_burst,
    input                      ar_lock,
    input [3:0]                ar_cache,
    input [2:0]                ar_prot,
    input [3:0]                ar_qos,
    input                      ar_valid,
    input [USER_W-1 : 0]       ar_user,
    output                     ar_ready,

    // AXI read response channel
    output [ID_W-1 : 0]        r_id,
    output [DATA_W-1 : 0]      r_data,
    output [1:0]               r_resp,
    output                     r_last,
    output                     r_valid,
    input                      r_ready,
    
    // +--------------------------------------------------
    // | Stream signals
    // +--------------------------------------------------
    input [STR_PCK_WIDTH-1: 0] in_data,
    input                      in_valid,
    input                      in_startofpacket,
    input                      in_endofpacket,
    output                     in_ready,
    
    output [3:0]               stream_select,
    output                     stream_active,
    
    // +--------------------------------------------------
    // | GPIO signals
    // +--------------------------------------------------
    input                      gpo_write,
    input [7:0]                gpo_data,
    output [GPI_WIDTH-1 : 0]   gpi_data,

    // +--------------------------------------------------
    // | GPIO signals
    // +--------------------------------------------------
    output                     gpi_interrupt
    );

    
    wire [63 : 0]              st_out_data;
    wire                       st_out_valid;
    wire                       st_out_startofpacket;
    wire                       st_out_endofpacket;
    wire                       st_out_ready;

    altera_mailbox_str_controller 
    #(
      .STR_PCK_WIDTH  (64),
      .NUMB_4K_BLOCK  (NUMB_4K_BLOCK),
      .GPI_WIDTH      (GPI_WIDTH)
    )
    str_controller
    (
        .in_valid           (in_valid),
        .in_data            (in_data),
        .in_startofpacket   (in_startofpacket),        
        .in_endofpacket     (in_endofpacket),      
        .in_ready           (in_ready),
   
   
        .out_valid          (st_out_valid),
        .out_data           (st_out_data),
        .out_startofpacket  (st_out_startofpacket),      
        .out_endofpacket    (st_out_endofpacket),    
        .out_ready          (st_out_ready),

        .gpo_write          (gpo_write),
        .gpo_data           (gpo_data),

        .gpi_interrupt      (gpi_interrupt),
        .gpi_data           (gpi_data),

        .stream_select      (stream_select),
        .stream_active      (stream_active),

        .clk                (clk),
        .reset              (reset)
    );

    
    altera_mailbox_str_read_slave 
    #(
        .ADDR_W             (ADDR_W),
        .DATA_W             (DATA_W),
        .ID_W               (ID_W),  
        .USER_W             (USER_W) 
     ) 
     read_slave_axi
     (
       .clk                         (clk),
       .reset                       (reset),

      .aw_id                        (aw_id),
      .aw_addr                      (aw_addr),
      .aw_len                       (aw_len), 
      .aw_size                      (aw_size),
      .aw_burst                     (aw_burst),
      .aw_lock                      (aw_lock),
      .aw_cache                     (aw_cache),
      .aw_prot                      (aw_prot),
      .aw_qos                       (aw_qos),
      .aw_valid                     (aw_valid),
      .aw_user                      (aw_user),
      .aw_ready                     (aw_ready),
      
      .w_data                       (w_data),
      .w_strb                       (w_strb),
      .w_last                       (w_last),
      .w_valid                      (w_valid),
      .w_ready                      (w_ready),
    
      .b_id                         (b_id),
      .b_resp                       (b_resp),
      .b_valid                      (b_valid),
      .b_ready                      (b_ready),
      
      .ar_id                        (ar_id),
      .ar_addr                      (ar_addr),
      .ar_len                       (ar_len),
      .ar_size                      (ar_size),
      .ar_burst                     (ar_burst),
      .ar_lock                      (ar_lock),
      .ar_cache                     (ar_cache),
      .ar_prot                      (ar_prot),
      .ar_qos                       (ar_qos),
      .ar_valid                     (ar_valid),
      .ar_user                      (ar_user),
      .ar_ready                     (ar_ready),
    
      .r_id                         (r_id),
      .r_data                       (r_data),
      .r_resp                       (r_resp),
      .r_last                       (r_last),
      .r_valid                      (r_valid),
      .r_ready                      (r_ready),
       
      .in_st_data                   (st_out_data),
      .in_st_valid                  (st_out_valid),
      .in_st_startofpacket          (st_out_startofpacket),
      .in_st_endofpacket            (st_out_endofpacket),
      .in_st_ready                  (st_out_ready)
    );
                                 
endmodule
