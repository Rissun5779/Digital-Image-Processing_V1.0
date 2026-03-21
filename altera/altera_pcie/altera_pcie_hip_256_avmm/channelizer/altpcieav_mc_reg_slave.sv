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


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module altpcieav_mc_reg_slave
    (
      input logic                                   Clk_i,
      input logic                                   Rstn_i,

      input  logic                                  MCSlaveChipSelect_i,
      input  logic                                  MCSlaveWrite_i,
      input  logic  [13:0]                          MCSlaveAddress_i,
      input  logic  [31:0]                          MCSlaveWriteData_i,
      output logic                                  MCSlaveWaitRequest_o,

      output logic                                  PurgeReq_o,
      output logic  [2:0]                           PurgeChannelID_o,
      output logic                                  PurgeID_o,

      input  logic                                  PriorQueuePurged_i,
      input  logic                                  FragQueuePurged_i,
      input  logic                                  PriorQueuePurgeErr_i,
      input  logic                                  FragQueuePurgeErr_i,
      input  logic                                  FragQueuePurgedActive_i,
      input  logic                                  PriorQueuePurgedActive_i,

      output logic                                  PurgeStatusReq_o,
      output logic [9:0]                            PurgeStatus_o,
      input  logic                                  PurgeStatusAck_i

      );


      logic                                         register_access_sreg;
      logic                                         purge_req_sreg;
      logic                                         register_access_rise;
      logic                                         register_access;
      logic                                         register_ready_reg;
      logic      [7:0]                              purge_id_reg;
      logic                                         register_access_reg;
      logic                                         purge_found_sreg;
      logic                                         purge_err_sreg;
      logic                                         purge_req_fall;
      logic                                         purge_req_sreg2;
      logic     [1:0]                               purge_status;
      logic                                         purge_stat_req_sreg;
      logic     [1:0]                               purge_channel_id_reg;



always_ff @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      register_access_sreg <= 1'b0;
    else if (register_ready_reg)
      register_access_sreg <= 1'b0;
     else if( ( MCSlaveWrite_i) & MCSlaveChipSelect_i & ~purge_req_sreg)
      register_access_sreg <= 1'b1;
  end

assign register_access = register_access_sreg;

always_ff @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      register_access_reg <= 1'b0;
    else
      register_access_reg <= register_access;
  end

assign register_access_rise = ~register_access_reg & register_access;

always_ff @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      register_ready_reg <= 1'b0;
    else
      register_ready_reg <= register_access_rise;
  end

assign MCSlaveWaitRequest_o = ~register_ready_reg;


/// purge ID register
always_ff @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
     begin
      purge_id_reg <= 8'h0;
      purge_channel_id_reg <= 3'h0;
     end
     else if( (MCSlaveWrite_i) & MCSlaveChipSelect_i)
     begin
      purge_id_reg <= MCSlaveWriteData_i[7:0];
      purge_channel_id_reg <= MCSlaveAddress_i[13:12];    /// the last 2 MSB of address used to identify requesting channel
     end
  end

 assign PurgeChannelID_o = purge_channel_id_reg;
/// request the purging logic to remove the descritor ID

always_ff @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      purge_req_sreg <= 1'h0;
    else if(register_ready_reg)
      purge_req_sreg <= 1'b1;
    else if(~FragQueuePurgedActive_i & ~PriorQueuePurgedActive_i )
      purge_req_sreg <= 1'b0;
  end

assign PurgeReq_o = purge_req_sreg;
assign PurgeID_o  = purge_id_reg;

/// Send Request to status queue to report status after purging is done
always_ff @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      purge_found_sreg <= 1'h0;
    else if(PriorQueuePurged_i | FragQueuePurged_i)
      purge_found_sreg <= 1'b1;
    else if(~FragQueuePurgedActive_i & ~PriorQueuePurgedActive_i )
      purge_found_sreg <= 1'b0;
  end

always_ff @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      purge_err_sreg <= 1'h0;
    else if(PriorQueuePurgeErr_i | FragQueuePurgeErr_i)
      purge_err_sreg <= 1'b1;
    else if(~FragQueuePurgedActive_i & ~PriorQueuePurgedActive_i )
      purge_err_sreg <= 1'b0;
  end

always_ff @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      purge_req_sreg2 <= 1'h0;
    else
      purge_req_sreg2 <= purge_req_sreg;
  end

assign purge_req_fall = purge_req_sreg2 & ~purge_req_sreg;

// latch the status code
always_ff @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      purge_status <= 2'h0;
    else if(purge_req_fall)
      purge_status[1:0] <= purge_found_sreg? 2'b10 : purge_err_sreg? 2'b11 : 2'b00;  // bit 8 and 9 of the status[31:0]
  end

 /// status request signal
  always_ff @(posedge Clk_i or negedge Rstn_i)
  begin
    if(~Rstn_i)
      purge_stat_req_sreg <= 1'h0;
    else if(purge_req_fall)
      purge_stat_req_sreg <= 1'b1;
    else if(PurgeStatusAck_i )
      purge_stat_req_sreg <= 1'b0;
  end

assign PurgeStatusReq_o = purge_stat_req_sreg;
assign PurgeStatus_o    = {purge_status[1:0], purge_id_reg[7:0]};


endmodule
