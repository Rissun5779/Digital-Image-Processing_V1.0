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


// altera mlab single port
module altera_mlab_sp (
   input             clk,
   input             we,
   input       [3:0] addr,
   input      [15:0] wdata,
   output reg [15:0] rdata
   );

   (* ramstyle = "MLAB, no_rw_check" *) reg  [15:0] mem [15:0];

   always @ (posedge clk) begin
      if (we) mem[addr] <= wdata;
      rdata <= mem[addr];
   end
endmodule



