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

module skew_insertion # (
    parameter                    LANES                 = 4,
    parameter                    ENABLE                = 1,
    parameter                    max_skew              = 107
  )
  (
    input      [LANES-1:0]       rx_serial_data,
    output     [LANES-1:0]       tx_serial_data
  );

  reg [LANES-1:0]     skewed_tx_serial_data;
  reg [8:0]           lane_skew[LANES];

  assign tx_serial_data = (ENABLE) ? skewed_tx_serial_data : rx_serial_data;
  // Per Lane Logic

  genvar lane;
  generate

  for (lane = 0; lane < LANES; lane = lane+1)begin: lane_skew_inst
    reg    [8:0]      lanen_skew;
    real              lane_skew_val;

    initial begin
      lanen_skew = lane_skew[lane];
      lane_skew_val = lanen_skew;
    end

    always @ (rx_serial_data[lane]) begin
      skewed_tx_serial_data[lane] <= #(lane_skew_val)rx_serial_data[lane];
    end
  end

  endgenerate

endmodule

