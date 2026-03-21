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


module example_host #(
  parameter NUM_LANES            = 12            // number of lanes
)(
  input                                 mm_reset_n,          
  // Avalon-MM interface for Uflex Interlaken core CSR
  input                                 mm_clk,
  output                                mm_read,
  output reg                            mm_write,
  output  [15:0]                        mm_address,
  output  [31:0]                        mm_writedata,

  // Avalon-MM interface for native PHY reconfiguration 
  output                                reconfig_reset,
  output                                reconfig_read,
  output                                reconfig_write,
  output  [(9+clogb2(NUM_LANES-1)):0]   reconfig_address,
  output  [31:0]                        reconfig_writedata
);

  assign reconfig_reset = 1'b0;
  assign reconfig_read  = 1'b0;
  assign reconfig_write = 1'b0;
  assign reconfig_read  = 1'b0;
  assign reconfig_address = 'h0;
  assign reconfig_writedata = 32'b0;

  //set loop back mode
  assign mm_read    = 1'b0;
  assign mm_address = 16'h0012;
  assign mm_writedata = {32{1'b1}};

  reg mm_write1 = 1'b0;
  reg mm_write2 = 1'b0;
  reg mm_write3 = 1'b0;

  always @(posedge mm_clk) begin
    if (!mm_reset_n) begin     //mm_reset_n used as sync reset.
      mm_write1 <= 1'b0;
      mm_write2 <= 1'b0;
      mm_write3 <= 1'b0;
      mm_write  <= 1'b0;
    end else begin
      mm_write1 <= 1'b1;
      mm_write2 <= mm_write1;
      mm_write3 <= mm_write2;
      mm_write  <= mm_write1 & ~mm_write3;
    end
  end

  function integer clogb2;
    input integer input_num;
    begin
      for (clogb2=0; input_num>0; clogb2=clogb2+1)
        input_num = input_num >> 1;
      if(clogb2 == 0)
        clogb2 = 1;
    end
  endfunction

endmodule 
