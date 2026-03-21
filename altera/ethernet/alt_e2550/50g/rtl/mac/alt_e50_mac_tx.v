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


`timescale 1ps/1ps

module alt_e50_mac_tx #(
        parameter SIM_SHORT_AM = 1'b0,
        parameter SIM_EMULATE = 1'b0,
        parameter SYNOPT_PREAMBLE_PASS = 1'b0,                  
        parameter SYNOPT_TXCRC_PASS = 1'b0,                  
        parameter SYNOPT_FLOW_CONTROL = 1'b0,                  
        parameter SYNOPT_LINK_FAULT    = 1'b0  
  )(
    input               sclr,
    input               clk,
    input               fc_sel,
    input               tx_crc_pt,
    input [7:0]         num_idle_rm,
    input [1:0]         din_sop, 
    input [1:0]         din_eop, 
    input [1:0]         din_error,      
    input [1:0]         din_idle,    
    input [5:0]         din_eop_empty,
    input [127:0]       din,
    input [63:0]        din_preamble,
    output              req,
    
    //Link Fault 
    input               tx_mac_lf_cfg_linkfault_rpt_en ,
    input               tx_mac_lf_cfg_unidir_en        ,
    input               tx_mac_lf_cfg_disable_rf       ,
    input               tx_mac_lf_cfg_force_rf         ,
    input               remote_fault_status            ,
    input               local_fault_status             ,

    output wire [127:0] tx_mii_d,
    output wire [15:0]  tx_mii_c,
    output wire         dout_am,

    input       [15:0]  cfg_max_frm_length,
    input               cfg_vlandet_disable,
    output wire [39:0]  tx_stats,
    output              tx_stats_valid,
    output wire [2:0]   tx_frm_error
  );

wire [1:0]   din_eeop;
wire [5:0]   din_mty;
wire [127:0] fdout;
wire [1:0]   fdout_sop;
wire [1:0]   fdout_eop;
wire [1:0]   fdout_eeop;
wire [5:0]   fdout_mty;
wire         fdout_valid;
wire         data_req;

//Link Fault
wire [127:0] tx_mii_d_mactx;
wire [15:0]  tx_mii_c_mactx;
wire         dout_am_mactx;
wire [127:0] tx_mii_d_lf; 
wire [15:0]  tx_mii_c_lf;
wire         tx_mii_valid_lf;   

   
assign din_eeop = din_error;
assign din_mty  = din_eop_empty;

alt_e50mt_frame_gen #(
    .SYNOPT_PREAMBLE_PASS (SYNOPT_PREAMBLE_PASS)
) fgen(
    .sclr           (sclr),
    .clk            (clk),
    .tx_crc_pt      (tx_crc_pt),
    .num_idle_rm    (num_idle_rm),
    .din_idle       (din_idle),
    .din_sop        (din_sop),
    .din_eop        (din_eop),
    .din_eeop       (din_eeop),      
    .din_mty        (din_mty),
    .din            (din),    
    .din_preamble   (din_preamble),    
    .req            (req),
    .data_req       (data_req),

    .dout           (fdout),
    .dout_sop       (fdout_sop),
    .dout_eop       (fdout_eop),
    .dout_eeop      (fdout_eeop),
    .dout_mty       (fdout_mty),
    .dout_valid     (fdout_valid)
  
  );

alt_e50_emac_t #(
    .SYNOPT_TXCRC_PASS(SYNOPT_TXCRC_PASS),
    .SYNOPT_FLOW_CONTROL(SYNOPT_FLOW_CONTROL),
    .SIM_SHORT_AM(SIM_SHORT_AM),
    .SIM_EMULATE (SIM_EMULATE)
) txf(
    .clk       (clk),
    .sclr      (sclr),

    .fc_sel    (fc_sel),
    .din_valid (fdout_valid),
    .din       (fdout),
    .din_sop   (fdout_sop), 
    .din_eop   (fdout_eop), 
    .din_eeop  (fdout_eeop),
    .din_mty   (fdout_mty),

    .din_req   (data_req),
    .dout_d    (tx_mii_d_mactx),
    .dout_c    (tx_mii_c_mactx),
    .dout_am   (dout_am_mactx),

    .cfg_max_frm_length     (cfg_max_frm_length),
    .cfg_vlandet_disable    (cfg_vlandet_disable),
    .tx_stats               (tx_stats),
    .tx_stats_valid         (tx_stats_valid),
    .tx_frm_error           (tx_frm_error)
);



 // _________________________________________________________________
 //     Link Fault Generator Module 
 // _________________________________________________________________
 //
    
   generate if (SYNOPT_LINK_FAULT) 
        begin
                alt_e50_mac_link_fault_gen  mac_link_fault_gen
                (
                .clk                       (clk),
                .reset                     (sclr),  //this input has not logic connect to it
                 
                .cfg_unidirectional_en     (tx_mac_lf_cfg_unidir_en        ),  
                .cfg_en_link_fault_gen     (tx_mac_lf_cfg_linkfault_rpt_en ),
                .cfg_unidir_en_disable_rf  (tx_mac_lf_cfg_disable_rf       ),
                .cfg_force_rf              (tx_mac_lf_cfg_force_rf         ),
              
                .remote_fault_status       (remote_fault_status),
                .local_fault_status        (local_fault_status),
                .mii_c_in                  (tx_mii_c_mactx),
                .mii_d_in                  (tx_mii_d_mactx),
                .mii_valid_in              (~dout_am_mactx), 
                .mii_c_out                 (tx_mii_c_lf),
                .mii_d_out                 (tx_mii_d_lf),
                .mii_valid_out             (tx_mii_valid_lf) 
                );

                assign tx_mii_c = tx_mii_c_lf;
                assign tx_mii_d = tx_mii_d_lf;
                assign dout_am  = ~ tx_mii_valid_lf; 
           
        end
   else begin
                assign tx_mii_c = tx_mii_c_mactx;
                assign tx_mii_d = tx_mii_d_mactx;
                assign dout_am  = dout_am_mactx; 
        end
endgenerate

   
endmodule
