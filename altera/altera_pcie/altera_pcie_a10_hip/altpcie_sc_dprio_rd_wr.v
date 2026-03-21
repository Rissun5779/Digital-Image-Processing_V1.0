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



// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on
module altpcie_sc_dprio_rd_wr
(
input   wire            reconfig_clk,
input   wire            reconfig_reset_n,
input   wire            app_dprio_start,
input   wire     [9:0]  app_dprio_address,
input   wire     [15:0] app_dprio_wdata, // if set, set the intended bit and zero out the other bits. If clear, zero out the intended bit and set the other bits


output  wire            hip_reconfig_clk/*synthesis noprune*/,
output  wire            hip_reconfig_reset_n/*synthesis noprune*/,
output  reg             hip_reconfig_write/*synthesis noprune*/,
output  reg     [15:0]  hip_reconfig_writedata/*synthesis noprune*/,
output  wire    [1:0]   hip_reconfig_byteen/*synthesis noprune*/,
output  reg     [9:0]   hip_reconfig_address/*synthesis noprune*/,
output  reg             hip_reconfig_read/*synthesis noprune*/,
output  reg             hip_dprio_done,
output  wire            hip_dprio_rdvalid
);

// DPRIO intended operation
localparam CLEAR_BIT = 1'b0;
localparam SET_BIT   = 1'b1;

//DPRIO R/W states
localparam IDLE         = 3'h1;
localparam READ_DPRIO   = 3'h2;
localparam WRITE_DPRIO  = 3'h4;

reg [2:0]       dprio_st;
wire            read_dprio_st;

//READ DATA VALID - 4 cycle latency from read
wire            readdata_valid;
reg [2:0]       rd_dly_cnt;

//###############################################
//RECONFIG outputs
assign hip_reconfig_byteen  = 2'b11;    //always enable both bytes
assign hip_reconfig_clk     = reconfig_clk;
assign hip_reconfig_reset_n = reconfig_reset_n;



//DPRIO Read modified Write
always@( posedge reconfig_clk or negedge reconfig_reset_n ) begin
   if( ~reconfig_reset_n ) begin
      dprio_st                <= IDLE;
      hip_dprio_done          <= 1'b0;
      hip_reconfig_write      <= 1'b0;
      hip_reconfig_read       <= 1'b0;
   end else begin
      hip_reconfig_write      <= 1'b0;
      hip_reconfig_read       <= 1'b0;
      hip_dprio_done          <= 1'b0;
      hip_reconfig_writedata  <= hip_reconfig_writedata;

      case( dprio_st )
         IDLE:    begin
            hip_reconfig_address       <= app_dprio_address;

            if (app_dprio_start) begin
               dprio_st                <= READ_DPRIO;
               hip_reconfig_read       <= 1'b1;
            end
         end

         READ_DPRIO:    begin
            if( readdata_valid ) begin
               hip_reconfig_read       <= 1'b0;
               dprio_st                <= WRITE_DPRIO;
            end
         end

         WRITE_DPRIO:   begin
            hip_reconfig_write         <= 1'b1;
            hip_dprio_done             <= 1'b1;
            hip_reconfig_writedata     <= app_dprio_wdata;
            dprio_st                   <= IDLE;
         end

         default: dprio_st <= IDLE;
      endcase
   end
end

assign read_dprio_st = dprio_st[1];

//READ DATA VALID - 4 cycle latency from read
assign readdata_valid          = (rd_dly_cnt == 3'h4);
assign hip_dprio_rdvalid       = readdata_valid;

always@( posedge reconfig_clk or negedge reconfig_reset_n ) begin
   if( ~reconfig_reset_n )
      rd_dly_cnt <= 3'h0;
   else if (readdata_valid)
      rd_dly_cnt <= 3'h0;
   else if (read_dprio_st)
      rd_dly_cnt <= rd_dly_cnt + 3'h1;
end

endmodule

