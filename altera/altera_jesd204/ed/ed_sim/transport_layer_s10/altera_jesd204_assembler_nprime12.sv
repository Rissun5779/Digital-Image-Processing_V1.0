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


//****************************************
//   Filename       : altera_jesd204_assembler_nprime12.sv
//
//   Description    : This module takes the samples form the converter and maps them into different lanes.
//
//   Limitation     : This module supports only LMF ={112, 222, 442, 114, 224, 444}, N={12, 13, 14, 15, 16}, N' = 16, S = {1, 2}.
//
//   Note           : Optional 
//***************************************

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

//only support LMFS=8885
//N=12, CS=0, N'=12
// for 1 frame clock
//	               AV-ST interface to TL			                      1st link clock 								                               2nd link clock 							
//	                        Bit position			     [31:24]		[23:16]		            [15:8]		[7:0]		            [31:24]		[23:16]		      [15:8]		[7:0]	
//Lane 0	jesd204_rx_link_data    [31:0]			C0S0 [11:0] + C0S1[11:8]				C0S1 [7:0] + C0S2[11:4]				C0S2 [3:0] + C0S3[11:0]				C0S4 [11:0] + TTTT			
//Lane 1	jesd204_rx_link_data   [63:32]			C1S0 [11:0] + C1S1[11:8]				C1S1 [7:0] + C1S2[11:4]				C1S2 [3:0] + C1S3[11:0]				C1S4 [11:0] + TTTT			
//Lane 2	jesd204_rx_link_data   [95:64]			C2S0 [11:0] + C2S1[11:8]				C2S1 [7:0] + C2S2[11:4]				C2S2 [3:0] + C2S3[11:0]				C2S4 [11:0] + TTTT			
//Lane 3	jesd204_rx_link_data  [127:96]			C3S0 [11:0] + C3S1[11:8]				C3S1 [7:0] + C3S2[11:4]				C3S2 [3:0] + C3S3[11:0]				C3S4 [11:0] + TTTT			
//Lane 4	jesd204_rx_link_data [159:128]			C4S0 [11:0] + C4S1[11:8]				C4S1 [7:0] + C4S2[11:4]				C4S2 [3:0] + C4S3[11:0]				C4S4 [11:0] + TTTT			
//Lane 5	jesd204_rx_link_data [191:160]			C5S0 [11:0] + C5S1[11:8]				C5S1 [7:0] + C5S2[11:4]				C5S2 [3:0] + C5S3[11:0]				C5S4 [11:0] + TTTT			
//Lane 6	jesd204_rx_link_data [223:192]			C6S0 [11:0] + C6S1[11:8]				C6S1 [7:0] + C6S2[11:4]				C6S2 [3:0] + C6S3[11:0]				C6S4 [11:0] + TTTT			
//Lane 7	jesd204_rx_link_data [255:224]			C7S0 [11:0] + C7S1[11:8]				C7S1 [7:0] + C7S2[11:4]				C7S2 [3:0] + C7S3[11:0]				C7S4 [11:0] + TTTT			

module altera_jesd204_assembler_nprime12 
#(
    parameter L                 = 8,  // Supported range: 8
    parameter F                 = 8,  // Supported value: 8
    parameter N                 = 12, // Supported value: 12
    parameter N_PRIME           = 12, // Supported value: 12
    parameter CS                = 0,  // Supported value: 0
    parameter F1_FRAMECLK_DIV   = 4,  //dummy. F=1 not supported
    parameter F2_FRAMECLK_DIV   = 2,  //dummy. F=2 not supported
    parameter RECONFIG_EN       = 0,  //not supported
   
    parameter DATA_BUS_WIDTH    = 480,  //N'=12 only support LMFS=8885,N=12. bus_width=M*S*N=8*5*12=480
    parameter CONTROL_BUS_WIDTH = 1     //dummy - no control bit support for N'=12
) 
(
    input    wire   txlink_clk,
    input    wire   txframe_clk,
    input    wire   txframe_rst_n,
    input    wire   txlink_rst_n,
    input    wire   jesd_tx_data_valid,
    input    wire   link_tprt_early_txdata_ready,
    input    wire   [4:0]  csr_l,
    input    wire   [4:0]  csr_n,
    input    wire   [7:0]  csr_f,
    input    wire   [(DATA_BUS_WIDTH-1):0] jesd_tx_datain, //{M7S4...M7S0,...,M1S4...M1S0,M0S4...M0S0} with M0S0 at LSB
    input    wire   [CONTROL_BUS_WIDTH-1:0] tprt_avalon_tx_control,
    
    output   wire   jesd_tx_data_ready,
    output   reg    tprt_link_txdata_error,
    output   reg    tprt_link_txdata_valid,
    output   reg    [(L * 32)-1:0]  tprt_link_txdata
);

   localparam MAX_ASSEMBLED_WIDTH              = 8*F*L;


reg jesd_tx_data_valid_d1;
reg link_tprt_early_txdata_ready_d1;
reg link_tprt_early_txdata_ready_d2;
reg    [(L * 32)-1:0]  tprt_link_txdata_d1;
   
reg  [MAX_ASSEMBLED_WIDTH-1:0] txdata_tp;
wire [(L*32)-1:0]txdata_final;

reg int_txdata_error_1st_flop;

wire [(L*8)-1:0]  f8_tsp_txlink_datain_F0;
wire [(L*8)-1:0]  f8_tsp_txlink_datain_F1;
wire [(L*8)-1:0]  f8_tsp_txlink_datain_F2;
wire [(L*8)-1:0]  f8_tsp_txlink_datain_F3;
wire [(L*8)-1:0]  f8_tsp_txlink_datain_F4;
wire [(L*8)-1:0]  f8_tsp_txlink_datain_F5;
wire [(L*8)-1:0]  f8_tsp_txlink_datain_F6;
wire [(L*8)-1:0]  f8_tsp_txlink_datain_F7;
wire [(L*32)-1:0]  f8_tsp_txlink_datain_link0;
wire [(L*32)-1:0]  f8_tsp_txlink_datain_link1;
wire [(L*32)-1:0]  f8_tx_data_n;
reg  [(L*32)-1:0]  f8_tx_data;

wire f8_txdata_error;
wire n_txdata_error;
reg f8_toggle, odd_evenn, dummy_frame, early_ready_d1;
wire link_tprt_early_ready_rise;

genvar i, j;

   ///////////////////////////////////////////////////////////////////////////////////////
   //      F=8
   ///////////////////////////////////////////////////////////////////////////////////////
   generate
   if (L==8 && F==8 /*&& M==8 && S==5*/)
   begin
      reg f8_cnt;

      for (i=0;i<L;i=i+1)
      begin : F8

         //Tailbits padding
         //N=12, CS=0
         //jesd_tx_datain data arrangement from upstream: 
         //{M7S4...M7S0,...,M1S4...M1S0,M0S4...M0S0} with M0S0 at LSB
         //framing
         assign f8_tsp_txlink_datain_F0[i*8 +: 8] = jesd_tx_datain[(i*60+4)  +: 8];
         assign f8_tsp_txlink_datain_F1[i*8 +: 8] = {jesd_tx_datain[(i*60) +: 4],    jesd_tx_datain[(i*60+20) +: 4]};
         assign f8_tsp_txlink_datain_F2[i*8 +: 8] = jesd_tx_datain[(i*60+12) +: 8];
         assign f8_tsp_txlink_datain_F3[i*8 +: 8] = jesd_tx_datain[(i*60+28) +: 8];
         assign f8_tsp_txlink_datain_F4[i*8 +: 8] = {jesd_tx_datain[(i*60+24) +: 4], jesd_tx_datain[(i*60+44) +: 4]};
         assign f8_tsp_txlink_datain_F5[i*8 +: 8] = jesd_tx_datain[(i*60+36)  +: 8];
         assign f8_tsp_txlink_datain_F6[i*8 +: 8] = jesd_tx_datain[(i*60+52)  +: 8];
         assign f8_tsp_txlink_datain_F7[i*8 +: 8] = {jesd_tx_datain[(i*60+48) +: 4], 4'd0};

         assign f8_tsp_txlink_datain_link0[i*32 +: 32] = {f8_tsp_txlink_datain_F0[i*8 +: 8], f8_tsp_txlink_datain_F1[i*8 +: 8], f8_tsp_txlink_datain_F2[i*8 +: 8], f8_tsp_txlink_datain_F3[i*8 +: 8]};
         assign f8_tsp_txlink_datain_link1[i*32 +: 32] = {f8_tsp_txlink_datain_F4[i*8 +: 8], f8_tsp_txlink_datain_F5[i*8 +: 8], f8_tsp_txlink_datain_F6[i*8 +: 8], f8_tsp_txlink_datain_F7[i*8 +: 8]};
      end 
      
      always @ (posedge txlink_clk)
      begin
         if (!txlink_rst_n)
         begin
            f8_toggle       <= 1'b0; 
            odd_evenn       <= 1'b0;
            f8_cnt          <= 1'b0;
            f8_tx_data      <= {32*L*{1'b0}};
            early_ready_d1  <= 1'b0;
         end
         else
            f8_toggle       <= (!dummy_frame) ? 1'b0 : ~f8_toggle; 
            odd_evenn       <= (!link_tprt_early_txdata_ready) ? 1'b0 : (link_tprt_early_ready_rise && f8_toggle) || odd_evenn;
            f8_cnt          <= (!link_tprt_early_txdata_ready_d1) ? 1'b0 : !f8_cnt;
            f8_tx_data      <= f8_tx_data_n;
            early_ready_d1  <= link_tprt_early_txdata_ready;
      end
      
      assign link_tprt_early_ready_rise = link_tprt_early_txdata_ready & ~early_ready_d1;
      assign f8_tx_data_n = (!jesd_tx_data_ready) ? {32*L*{1'b0}} : f8_cnt ? f8_tsp_txlink_datain_link1 : f8_tsp_txlink_datain_link0;
      assign txdata_final = f8_tx_data;

   end  
   endgenerate
	
   // **************************************************************************************
   //   tprt_link_txdata_error implementation. 
   // ***************************************************************************************
   assign n_txdata_error = jesd_tx_data_ready && (!jesd_tx_data_valid);

   always @ (posedge txframe_clk)
   begin
      if (!txframe_rst_n)
      begin
         int_txdata_error_1st_flop <= 1'b0;                   
      end
      else
      begin
         int_txdata_error_1st_flop <= n_txdata_error;          
      end
   end

   assign f8_txdata_error = int_txdata_error_1st_flop; 
   assign jesd_tx_data_ready = link_tprt_early_txdata_ready_d2;
	
   always @ (posedge txframe_clk)
   begin
      if (!txframe_rst_n)
      begin
         dummy_frame                     <= 1'b0;
         link_tprt_early_txdata_ready_d1 <= 1'b0;
         link_tprt_early_txdata_ready_d2 <= 1'b0;
      end else begin
         dummy_frame                     <= 1'b1;
         link_tprt_early_txdata_ready_d1 <= link_tprt_early_txdata_ready;
         link_tprt_early_txdata_ready_d2 <= link_tprt_early_txdata_ready_d1;
      end
   end
   
   always @ (posedge txlink_clk )
   begin
      if (!txlink_rst_n)
      begin
         tprt_link_txdata       <= {L*32{1'b0}};
         tprt_link_txdata_d1    <= {L*32{1'b0}};
         jesd_tx_data_valid_d1  <= 1'b0;
         tprt_link_txdata_valid <= 1'b0;
         tprt_link_txdata_error <= 1'b0;
      end
      else
      begin
         tprt_link_txdata       <= odd_evenn? tprt_link_txdata_d1 : txdata_final;
         tprt_link_txdata_d1    <= txdata_final;
         jesd_tx_data_valid_d1  <= jesd_tx_data_valid;
         tprt_link_txdata_valid <= jesd_tx_data_valid_d1;
         tprt_link_txdata_error <= f8_txdata_error;
      end
   end
	
endmodule