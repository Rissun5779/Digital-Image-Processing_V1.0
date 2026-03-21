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


`timescale 100 fs / 100 fs
`define tdisplay(MYSTRING) $display("%t:%s \n", $time,  MYSTRING)

module tb_serial_delay
(
    //--------------------------------------------------------------------------
    // port list
    //--------------------------------------------------------------------------
    sdi_serial,
    sdi_serial_b,
    update_dly_cycle,
    serial_delayed,
    serial_delayed_b
);

    input sdi_serial;
    input sdi_serial_b;
    input update_dly_cycle;
    output reg serial_delayed;
    output reg serial_delayed_b;

    parameter DL_SYNCTEST = 1'b0;
    parameter SERIAL_DLYTEST = 1'b0;

    integer i;
    integer j;

    always @ (sdi_serial)
    begin
      serial_delayed <= #i sdi_serial; 
    end

    always @ (sdi_serial_b)
    begin
      serial_delayed_b <= #j sdi_serial_b; 
    end

    initial begin
      if (SERIAL_DLYTEST) begin
         i = 50000;
         j = 50000;
      end else if (DL_SYNCTEST) begin
         i = 7900000;
         j = 7900000;
      end else begin
         i = $urandom_range(100000,50000);
         j = $urandom_range(100000,50000);
      end
      $display("Simulation will use TX with serial delay of :%d",i);
      @(posedge update_dly_cycle);
      i = $urandom_range(7900000,0);
      j = $urandom_range(7900000,0);
      $display("Random delay of link A:%d",i);
      $display("Random delay of link B :%d",j);
      @(posedge update_dly_cycle);
      i = 9000000;
      j = 9000000;
    end

endmodule
 


