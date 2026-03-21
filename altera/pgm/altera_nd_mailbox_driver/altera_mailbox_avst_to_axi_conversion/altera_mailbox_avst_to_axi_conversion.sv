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
// | Nadder SDM mailbox avalon ST to AXI
// |  - Input: Avalon ST 32 bits
// |  - Output: AXI4 64 bits
// +-----------------------------------------------------------
`timescale 1 ns/ 1 ns

module altera_mailbox_avst_to_axi_conversion
#(
  parameter IN_ST_DATA_W        = 75,
  parameter COMMAND_WIDTH       = 32,
  parameter RSP_ST_W            = 32,
  parameter REQ_WIDTH           = 38,
  parameter WAITING_TIME        = 10,
  parameter ADDR_W              = 32,
  parameter DATA_W              = 32,
  parameter ID_W                = 4, 
  parameter USER_W              = 5, 
  parameter WSTRB_W             = DATA_W / 8,
  parameter OUT_COMMAND_WIDTH   = COMMAND_WIDTH + 32
  )    
   (
    // +--------------------------------------------------
    // | Clock and reset
    // | Note reset will be synchronous
    // +--------------------------------------------------
    input                        clk,
    input                        reset,
    
    // +--------------------------------------------------
    // | AXI4 master signals
    // +--------------------------------------------------
    // AXI write address channel
    output reg [ID_W-1 : 0]      aw_id,
    output [ADDR_W-1 : 0]        aw_addr,
    output reg [7:0]             aw_len, 
    output [2:0]                 aw_size,
    output [1:0]                 aw_burst,
    output                       aw_lock,
    output [3:0]                 aw_cache,
    output [2:0]                 aw_prot,
    output [3:0]                 aw_qos,
    output                       aw_valid,
    output [USER_W-1 : 0]        aw_user,
    input                        aw_ready,

    // AXI read address channel
    output reg [ID_W-1 : 0]      ar_id,
    output reg [ADDR_W-1 : 0]    ar_addr,
    output reg [7 : 0]           ar_len,
    output reg [2:0]             ar_size,
    output reg [1:0]             ar_burst,
    output reg                   ar_lock,
    output reg [3:0]             ar_cache,
    output reg [2:0]             ar_prot,
    output reg [3:0]             ar_qos,
    output reg                   ar_valid,
    output reg [USER_W : 0]      ar_user,
    input                        ar_ready,
    
    // AXI write data channel
    output [DATA_W-1 : 0]        w_data,
    output [WSTRB_W-1 : 0]       w_strb,
    output                       w_last,
    output                       w_valid,
    input                        w_ready,
    // AXI write response channel
    input [ID_W-1:0]             b_id,
    input [1:0]                  b_resp,
    input                        b_valid,
    output                       b_ready,

    // AXI read response channel
    input [ID_W-1 : 0]           r_id,
    input [DATA_W-1 : 0]         r_data,
    input [1:0]                  r_resp,
    input                        r_last,
    input                        r_valid,
    output reg                   r_ready,
           
    // +--------------------------------------------------
    // | Avl ST output packet signals
    // +--------------------------------------------------
    // check output of Avalon ST
    input [IN_ST_DATA_W - 1 : 0] in_data,
    input                        in_valid,
    input                        in_startofpacket,
    input                        in_endofpacket,
    output                       in_ready

    );

    axi_slave_network_interface#(
        .PKT_BYTE_CNT_H              (74),
        .PKT_BYTE_CNT_L              (68),
        .PKT_ADDR_H                  (63),
        .PKT_ADDR_L                  (32),
        .PKT_DATA_H                  (31),
        .PKT_DATA_L                  (0),
        .PKT_BYTEEN_H                (67),
        .PKT_BYTEEN_L                (64),
        .USER_W                      (5),
        .ST_DATA_W                   (75),
        .ADDR_WIDTH                  (32),
        .RDATA_WIDTH                 (32),
        .WDATA_WIDTH                 (32),
        .AXI_SLAVE_ID_W              (4)
    ) axi_conversion (
        .clk                    (clk),                                                             
        .reset                  (reset),                 
        .write_cp_ready         (in_ready),         
        .write_cp_valid         (in_valid),         
        .write_cp_data          (in_data),          
        .write_cp_startofpacket (in_startofpacket), 
        .write_cp_endofpacket   (in_endofpacket),   
        // just take the response
        .write_rp_ready         (1'b1),                   
        .write_rp_valid         (),                   
        .write_rp_data          (),                    
        .write_rp_startofpacket (),           
        .write_rp_endofpacket   (),             
        .awid                   (aw_id),           
        .awaddr                 (aw_addr),         
        .awlen                  (aw_len),          
        .awsize                 (aw_size),         
        .awburst                (aw_burst),        
        .awlock                 (aw_lock),         
        .awcache                (aw_cache),        
        .awprot                 (aw_prot),         
        .awuser                 (aw_user),         
        .awvalid                (aw_valid),        
        .awready                (aw_ready),        
        .wdata                  (w_data),          
        .wstrb                  (w_strb),          
        .wlast                  (w_last),          
        .wvalid                 (w_valid),         
        .wready                 (w_ready),         
        .bid                    (b_id),            
        .bresp                  (b_resp),          
        .bvalid                 (b_valid),         
        .bready                 (b_ready),         
        .awqos                  (aw_qos)
    );

    // This component only use write channel, set default value to output of read to avoid warning
    // the reason put these port here so that it qsys compliance
    always_comb begin
        r_ready    = '0;
        ar_id      = '0;
        ar_addr    = '0;
        ar_len     = '0; 
        ar_size    = '0;
        ar_burst   = '0;
        ar_lock    = '0;
        ar_cache   = '0;
        ar_prot    = '0;
        ar_qos     = '0;
        ar_valid   = '0;
        ar_user    = '0;
    end
    
    
endmodule
