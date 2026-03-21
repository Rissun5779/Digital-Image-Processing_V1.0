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
// | Nadder SDM FPGA2SDM AXI bridge wrapper
// +-----------------------------------------------------------
`timescale 1 ns/ 1 ns

module altera_sdm_axi_fpga2sdm
   (
    // +--------------------------------------------------
    // | Clock and reset
    // | Note reset will be synchronous
    // +--------------------------------------------------
    input           clk,
    input           reset,
    
    // +--------------------------------------------------
    // | AXI4 slave signals
    // +--------------------------------------------------
    // AXI write address channel
    input [3 : 0]   aw_id,
    input [31 : 0]  aw_addr,
    input [7:0]     aw_len, 
    input [2:0]     aw_size,
    input [1:0]     aw_burst,
    input           aw_lock,
    input [3:0]     aw_cache,
    input [2:0]     aw_prot,
    input [3:0]     aw_qos,
    input           aw_valid,
    input [4 : 0]   aw_user,
    output          aw_ready,

    // AXI read address channel
    input [3 : 0]   ar_id,
    input [31 : 0]  ar_addr,
    input [7 : 0]   ar_len,
    input [2:0]     ar_size,
    input [1:0]     ar_burst,
    input           ar_lock,
    input [3:0]     ar_cache,
    input [2:0]     ar_prot,
    input [3:0]     ar_qos,
    input           ar_valid,
    input [4 : 0]   ar_user,
    output          ar_ready,
    
    // AXI write data channel
    input [31 : 0]  w_data,
    input [3 : 0]   w_strb,
    input           w_last,
    input           w_valid,
    output          w_ready,
    // AXI write response channel
    output [3:0]    b_id,
    output [1:0]    b_resp,
    output          b_valid,
    input           b_ready,

    // AXI read response channel
    output [3 : 0]  r_id,
    output [31 : 0] r_data,
    output [1:0]    r_resp,
    output          r_last,
    output          r_valid,
    input           r_ready
    );

    // +--------------------------------------------------
    // | SDM Atom
    // +--------------------------------------------------
    fourteennm_sdm_axi_fpga2sdm sdm_fpga2sdm
       (
        .clk                  (clk),
        .aw_clk               (clk),
        .w_clk                (clk),
        .b_clk                (clk),
        .r_clk                (clk),
        .ar_clk               (clk),
        .port_size_config_1   (1'b0),
        
        .aw_addr              (aw_addr),
        .aw_burst             (aw_burst),
        .aw_cache             (aw_cache),
        .aw_id                (aw_id),
        .aw_len               (aw_len),
        .aw_lock              (aw_lock),
        .aw_prot              (aw_prot),
        .aw_qos               (aw_qos),
        .aw_ready             (aw_ready),
        .aw_size              (aw_size),
        .aw_user              (aw_user),
        .aw_valid             (aw_valid),
        
        .w_data               (w_data),
        .w_last               (w_last),
        .w_ready              (w_ready),
        .w_strb               (w_strb),
        .w_valid              (w_valid),
        
        .b_id                 (b_id),
        .b_ready              (b_ready),
        .b_resp               (b_resp),
        .b_valid              (b_valid),
        
        .ar_addr              (ar_addr),
        .ar_burst             (ar_burst),
        .ar_cache             (ar_cache),
        .ar_id                (ar_id),
        .ar_len               (ar_len),
        .ar_lock              (ar_lock),
        .ar_prot              (ar_prot),
        .ar_qos               (ar_qos),
        .ar_ready             (ar_ready),
        .ar_size              (ar_size),
        .ar_user              (ar_user),
        .ar_valid             (ar_valid),
        
        .r_data               (r_data),
        .r_id                 (r_id),
        .r_last               (r_last),
        .r_ready              (r_ready),
        .r_resp               (r_resp),
        .r_valid              (r_valid)
    );


    
endmodule
