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


module one_shot (
  input     clk,
  input     rst_n,
  input     din,
  output    dout
);

  reg  [1:0] q;
  reg  [1:0] sync;

  always @(posedge clk or posedge din or negedge rst_n) begin
    if (~rst_n) begin
      q      <= 2'b00;
    end else if (din) begin
      q      <= 2'b11;
    end else begin
      q[0]   <= 1'b0;
      q[1]   <= q[0];
    end
  end
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      sync   <= 2'h0;
    end else begin
      sync[0] <= q[1];
      sync[1] <= ~sync[0] & q[1];
    end
  end

  assign dout = sync[1];

endmodule
