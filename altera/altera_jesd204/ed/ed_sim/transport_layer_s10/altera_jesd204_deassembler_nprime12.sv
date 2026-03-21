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
//   Filename       : altera_jesd204_deassembler_nprime12.sv
//
//   Description    : This module receives Rx data from lanes, and maps it to AV-ST Rx data bus. 
//
//   Limitation     : This module supports only F={1,2,4,8}, N={12,13,14,15,16}, N'=16, L={1,2,4,8}, CS={0,1,2,3}.
//
//   Note           : Optional 
//***************************************

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module altera_jesd204_deassembler_nprime12 
#(
    parameter L                 = 8,  // Supported range: 8
    parameter F                 = 8,  // Supported value: 8
    parameter N                 = 12, // Supported value: 12
    parameter N_PRIME           = 12, // Supported value: 12
    parameter CS                = 0,  // Supported value: 0
    parameter F1_FRAMECLK_DIV   = 4,  //dummy. F=1 not supported
    parameter F2_FRAMECLK_DIV   = 2,  //dummy. F=2 not supported
    parameter RECONFIG_EN       = 0,  //not supported
   
    parameter OUTPUT_BUS_WIDTH  = 480,  //N'=12 only support LMFS=8885,N=12. bus_width=M*S*N=8*5*12=480
    parameter CONTROL_BUS_WIDTH = 1     //dummy - no control bit support for N'=12
) 
(
   input    wire   rxlink_clk,
   input    wire   rxframe_clk,
   input    wire   rxframe_rst_n,
   input    wire   rxlink_rst_n,
   input    wire   [4:0]  csr_l,
   input    wire   [7:0]  csr_f,
   input    wire   [4:0]  csr_n,
   input    wire   link_tprt_rxdata_valid,
   input    wire   [(L * 32)-1:0]  link_tprt_rx_datain,
   input    wire   avalon_tprt_rx_ready,
   output   reg    [OUTPUT_BUS_WIDTH-1:0] tprt_avalon_rx_data=0,
   output   reg    [CONTROL_BUS_WIDTH-1:0] tprt_avalon_rx_control=0,
   output   reg    tprt_avalon_rx_data_valid=0,
   output   reg    tprt_link_rx_error=0,
   output   reg    tprt_link_rxdata_ready=0 //done
);

   wire  [L-1:0][31:0] f8_rx_datain_1L;
   reg   [L-1:0][31:0] f8_rxfifo_entry0;
   reg   [L-1:0][31:0] f8_rxfifo_entry1;
   reg   [L-1:0][31:0] f8_rxfifo_entry2;
   wire  [L-1:0][63:0] f8_rx_reg;
   wire   [(64*L)-1:0] f8_rx_data;
   wire  [OUTPUT_BUS_WIDTH-1:0] rxdata_td; 
   reg    f8_ptr;
   reg    odd_evenn;
   reg    rx_dll_valid_d1;
   wire   rx_dll_valid_rise;
   reg    [1:0] f8_read_ready;
   wire   f8_rx_ready;
   reg    dummy_frame;

   //tprt_link_rx_error
   wire   rxerror;
   wire   rxerror_2nd_muxed;

   ///////////////////////////////////////////////////////////////////////////////////////
   //      F=8
   ///////////////////////////////////////////////////////////////////////////////////////
   genvar i;
   generate
   if (L==8 && F==8 /*&& M==8 && S==5*/)
   begin
      for (i=0;i<L;i=i+1)
      begin : F8
         assign f8_rx_datain_1L[i] = link_tprt_rx_datain[i*32 +: 32]; 

      	 always @ (posedge rxlink_clk)
      	 begin
         	  if (!rxlink_rst_n)
      	    begin
               f8_rxfifo_entry0[i] <= 32'b0;
               f8_rxfifo_entry1[i] <= 32'b0;
               f8_rxfifo_entry2[i] <= 32'b0;
   	        end
   	        else
   	        begin
               f8_rxfifo_entry0[i] <= f8_rx_datain_1L[i];
               f8_rxfifo_entry1[i] <= f8_rxfifo_entry0[i];
               f8_rxfifo_entry2[i] <= f8_rxfifo_entry1[i];
   	        end
   	     end

         assign f8_rx_reg[i][31:0]  = (odd_evenn) ? f8_rxfifo_entry1[i] : f8_rxfifo_entry2[i];
         assign f8_rx_reg[i][63:32] = (odd_evenn) ? f8_rxfifo_entry0[i] : f8_rxfifo_entry1[i];
         assign f8_rx_data[i*64 +: 64] = f8_rx_reg[i];

         assign rxdata_td[(i*60+4)  +: 8]    = f8_rx_data[(i*64+24) +: 8];//F0
         assign {rxdata_td[(i*60) +: 4], rxdata_td[(i*60+20) +: 4]} = f8_rx_data[(i*64+16) +: 8];//F1
         assign rxdata_td[(i*60+12) +: 8]    = f8_rx_data[(i*64+8) +: 8];//F2
         assign rxdata_td[(i*60+28) +: 8]    = f8_rx_data[(i*64+0) +: 8];//F3
         assign {rxdata_td[(i*60+24) +: 4], rxdata_td[(i*60+44) +: 4]} = f8_rx_data[(i*64+56) +: 8];//F4
         assign rxdata_td[(i*60+36)  +: 8]   = f8_rx_data[(i*64+48) +: 8];//F5
         assign rxdata_td[(i*60+52)  +: 8]   = f8_rx_data[(i*64+40) +: 8];//F6
         assign rxdata_td[(i*60+48) +: 4]    = f8_rx_data[(i*64+36) +: 4];//F7 - skip the lowest 4 tailing bits

      end    

      always @ (posedge rxlink_clk)
   	     if (!rxlink_rst_n)
   	     begin
            f8_ptr          <= 1'b0;
            rx_dll_valid_d1 <= 1'b0;
            odd_evenn       <= 1'b0;
            f8_read_ready   <= 2'b0;
   	     end
   	     else
   	     begin
            f8_ptr          <= (!dummy_frame) ? 1'b0 : ~f8_ptr; 
            rx_dll_valid_d1 <= link_tprt_rxdata_valid;
            odd_evenn       <= (!link_tprt_rxdata_valid) ? 1'b0 : (rx_dll_valid_rise && f8_ptr) || odd_evenn;
            f8_read_ready   <= {(f8_read_ready[0]&&link_tprt_rxdata_valid), link_tprt_rxdata_valid};
   	     end

      assign rx_dll_valid_rise = link_tprt_rxdata_valid & ~rx_dll_valid_d1;
      assign f8_rx_ready = f8_read_ready[1];
   end
   else
   begin
      assign f8_rx_ready = 1'b0;
      assign rxdata_td   = {OUTPUT_BUS_WIDTH{1'b0}};
   end
   endgenerate


   //**************************************************************************************/
   // tprt_link_rx_error
   //**************************************************************************************/
   
   assign  rxerror = tprt_avalon_rx_data_valid && (~avalon_tprt_rx_ready);
   assign  rxerror_2nd_muxed = rxerror;

   always @ (posedge rxlink_clk)
   begin
      if (!rxlink_rst_n)
      begin
            tprt_link_rx_error <= 1'b0;
      end
      else
         begin
            tprt_link_rx_error <= rxerror_2nd_muxed;
      end
   end
   
   ///////////////////////////////////////////////////////////////////////////////////////
   //      Outputs on frame_clk domain
   ///////////////////////////////////////////////////////////////////////////////////////

   always @ (posedge rxframe_clk)
   begin
   	 if (!rxframe_rst_n)
   	 begin
     	  dummy_frame                <= 1'b0;
	 	    tprt_avalon_rx_data        <= {OUTPUT_BUS_WIDTH{1'b0}};
   	 	  tprt_avalon_rx_control     <= {CONTROL_BUS_WIDTH{1'b0}};
        tprt_link_rxdata_ready     <= 1'b0;
        tprt_avalon_rx_data_valid  <= 1'b0;
   	 end
	    else
	    begin
     	  dummy_frame                <= 1'b1;
   	 	  tprt_avalon_rx_data        <= rxdata_td;
   	 	  tprt_avalon_rx_control     <= 1'b0;
        tprt_link_rxdata_ready     <= 1'b1;
        tprt_avalon_rx_data_valid  <= f8_rx_ready;
	    end
   end   
   
endmodule