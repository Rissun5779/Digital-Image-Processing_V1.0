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


module altera_emif_ctrl_qdr4_fifo_lookahead #(
   parameter WIDTH = 1,
   parameter DEPTH = 1
) (
   input logic              clk,
   input logic              reset_n,
   input logic [WIDTH-1:0]  d,
   input logic              rdreq,
   input logic              wrreq,
   
   output logic [WIDTH-1:0]  q,
   output logic              empty,
   output logic              full
);
   timeunit 1ps;
   timeprecision 1ps;

   reg                   fifo_valid, middle_valid, dout_valid;
   reg [(WIDTH-1):0]     middle_dout;

   wire [(WIDTH-1):0]    fifo_dout;
   wire                  fifo_empty, fifo_rd_en;
   wire                  will_update_middle, will_update_dout;

    scfifo  orig_fifo (
                .clock (clk),
                .data (d),
                .rdreq (fifo_rd_en),
                .wrreq (wrreq),
                .empty (fifo_empty),
                .full (),
                .q (fifo_dout),
                .usedw (),
                .aclr (),
                .almost_empty (),
                .almost_full (full),
                .sclr ());
    defparam
        orig_fifo.add_ram_output_register  = "OFF",
        orig_fifo.intended_device_family  = "Arria 10",
        orig_fifo.lpm_numwords  = DEPTH,
        orig_fifo.lpm_showahead  = "OFF",
        orig_fifo.lpm_type  = "scfifo",
        orig_fifo.lpm_width  = WIDTH,
        orig_fifo.lpm_widthu  = ceil_log2(DEPTH),
        orig_fifo.almost_full_value = DEPTH-1,
        orig_fifo.overflow_checking  = "ON",
        orig_fifo.underflow_checking  = "ON",
        orig_fifo.use_eab  = "ON";

   assign will_update_middle = fifo_valid && (middle_valid == will_update_dout);
   assign will_update_dout = (middle_valid || fifo_valid) && (rdreq || !dout_valid);
   assign fifo_rd_en = (!fifo_empty) && !(middle_valid && dout_valid && fifo_valid);
   assign empty = !dout_valid;

   always @(posedge clk)
      if (!reset_n)
         begin
            fifo_valid <= 0;
            middle_valid <= 0;
            dout_valid <= 0;
            q <= 0;
            middle_dout <= 0;
         end
      else
         begin
            if (will_update_middle)
               middle_dout <= fifo_dout;
            
            if (will_update_dout)
               q <= middle_valid ? middle_dout : fifo_dout;
            
            if (fifo_rd_en)
               fifo_valid <= 1;
            else if (will_update_middle || will_update_dout)
               fifo_valid <= 0;
            
            if (will_update_middle)
               middle_valid <= 1;
            else if (will_update_dout)
               middle_valid <= 0;
            
            if (will_update_dout)
               dout_valid <= 1;
            else if (rdreq)
               dout_valid <= 0;
         end 
         
   // Calculate the ceiling of log_2 of the input value
   function integer ceil_log2;
      input integer value;
      begin
         value = value - 1;
         for (ceil_log2 = 0; value > 0; ceil_log2 = ceil_log2 + 1)
            value = value >> 1;
      end
   endfunction
endmodule
