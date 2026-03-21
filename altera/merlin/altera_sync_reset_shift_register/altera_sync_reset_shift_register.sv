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


`default_nettype none
module altera_sync_reset_shift_register
#(
  parameter DELAY = 8
) 
(
  input wire clk,
  input wire reset_in,
  output wire reset_out
);

  reg [DELAY - 1 : 0] d_reset = '0;

  assign reset_out = d_reset[DELAY - 1];

  always @(posedge clk) begin
    d_reset <= {d_reset[DELAY - 2 : 0], reset_in};
  end

endmodule
`default_nettype wire
