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

module atx_pll_recal
#(
  parameter          CHANNELS = 16
) (
   input             clk,
   input             rst_n,
   input  reg        clock_gen_set,
   
   output reg        pll_reconfig_write,
   output reg        pll_reconfig_read,
   output reg [9:0]  pll_reconfig_address,
   output reg [31:0] pll_reconfig_writedata,
   input      [31:0] pll_reconfig_readdata,
   input             pll_reconfig_waitrequest,

   output reg        xcvr_reconfig_write,
   output reg        xcvr_reconfig_read,
   output reg [13:0] xcvr_reconfig_address,
   output reg [31:0] xcvr_reconfig_writedata,
   input      [31:0] xcvr_reconfig_readdata,
   input             xcvr_reconfig_waitrequest,
   
   output reg pll_recal_done
);

   reg [3:0] init_state;
   reg [3:0] channel;

   always_ff @( posedge clk or negedge rst_n ) begin
      if( !rst_n ) begin
         init_state <= 4'h0;
         channel <= 4'b0;
         
         pll_reconfig_write      <= 1'b0;
         pll_reconfig_read       <= 1'b0;
         pll_reconfig_address    <= 10'h0;
         pll_reconfig_writedata  <= 32'h0;
                                 
         xcvr_reconfig_write     <= 1'b0;
         xcvr_reconfig_read      <= 1'b0;
         xcvr_reconfig_address   <= 10'h0;
         xcvr_reconfig_writedata <= 32'h0;
         
         pll_recal_done <= 1'b0;
      end else begin
         case ( init_state )
            4'h0: begin //IDLE
               pll_reconfig_write     <= 1'b0;
               pll_reconfig_read      <= 1'b0;
               pll_reconfig_address   <= 10'h0;
               pll_reconfig_writedata <= 32'h0;

               if (clock_gen_set == 1'b1) begin
                  init_state <= 4'h1;
               end
               
               pll_recal_done <= 1'b0;
            end

            4'h1: begin //Request access
               pll_reconfig_write     <= 1'b1;
               pll_reconfig_read      <= 1'b0;
               pll_reconfig_address   <= 10'h0;
               pll_reconfig_writedata <= 32'h2;

               if ( !pll_reconfig_waitrequest ) begin
                  init_state <= 4'h2;
               end
            end

            4'h2: begin //Delay
               pll_reconfig_write     <= 1'b0;
               pll_reconfig_read      <= 1'b0;
               pll_reconfig_address   <= 10'h0;
               pll_reconfig_writedata <= 32'h0;

               if ( !pll_reconfig_waitrequest) begin
                  init_state <= 4'h3;
               end
            end

            4'h3: begin //Recalibrate ATX PLL
               pll_reconfig_write     <= 1'b1;
               pll_reconfig_read      <= 1'b0;
               pll_reconfig_address   <= 10'h100;
               pll_reconfig_writedata <= 32'h1;
               
               if ( !pll_reconfig_waitrequest) begin
                  init_state <= 4'h4;
               end
            end

            4'h4: begin //Return access
               pll_reconfig_write     <= 1'b1;
               pll_reconfig_read      <= 1'b0;
               pll_reconfig_address   <= 10'h0;
               pll_reconfig_writedata <= 32'h3;
               
               if ( !pll_reconfig_waitrequest) begin
                  init_state <= 4'h5;
               end
            end

            /*  XCVR RECAL  */

            4'h5: begin //Request access
               pll_reconfig_write      <= 1'b0;
               pll_reconfig_read       <= 1'b0;
               pll_reconfig_address    <= 10'h0;
               pll_reconfig_writedata  <= 32'h0;

               pll_recal_done <= 1'b1;
               
               xcvr_reconfig_write     <= 1'b1;
               xcvr_reconfig_read      <= 1'b0;
               xcvr_reconfig_address   <= 10'h0 + ( 13'h400 * channel );
               xcvr_reconfig_writedata <= 32'h2;

               if ( !xcvr_reconfig_waitrequest) begin
                  init_state <= 4'h6;
               end
            end

            4'h6: begin //Recalibrate XCVR CDR
               xcvr_reconfig_write     <= 1'b1;
               xcvr_reconfig_read      <= 1'b0;
               xcvr_reconfig_address   <= 10'h100 + ( 13'h400 * channel );
               xcvr_reconfig_writedata <= 32'h2;
               
               if ( !xcvr_reconfig_waitrequest) begin
                  init_state <= 4'h7;
               end
            end

            4'h7: begin //Return access
               xcvr_reconfig_write     <= 1'b1;
               xcvr_reconfig_read      <= 1'b0;
               xcvr_reconfig_address   <= 10'h0 + ( 13'h400 * channel );
               xcvr_reconfig_writedata <= 32'h3;
               
					//Increment to next channel
               channel <= channel + 1'b1;
               
               if ( !xcvr_reconfig_waitrequest) begin
                  if ( channel == CHANNELS-1 ) begin
                     init_state <= 4'h8;
                  end else begin
                     init_state <= 4'h5;
                  end
               end
            end

            default: begin
               pll_reconfig_write      <= 1'b0;
               pll_reconfig_read       <= 1'b0;
               pll_reconfig_address    <= 10'h0;
               pll_reconfig_writedata  <= 32'h0;
               
               xcvr_reconfig_write     <= 1'b0;
               xcvr_reconfig_read      <= 1'b0;
               xcvr_reconfig_address   <= 10'h0;
               xcvr_reconfig_writedata <= 32'h0;
               
               init_state <= init_state;
            end
         endcase
      end
   end
endmodule