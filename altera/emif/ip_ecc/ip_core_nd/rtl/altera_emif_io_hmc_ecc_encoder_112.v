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




`timescale 1 ps / 1 ps

module altera_emif_io_hmc_ecc_encoder_112 
#( parameter
   DI          = 98,
   DOUT        = 106
)

(
   data,
   q
);

localparam PARITY = 8;

input	   [DI-1:0]  data;
output	[DOUT-1:0]  q;

wire [111:0] data_e;
wire [111:0] data_i;
generate
   if(DI==112)
      assign data_e     = data;
   else
      assign data_e     = {{(112-DI){1'b0}},data};
endgenerate
assign data_i     = {data_e[111:PARITY],~data_e[PARITY-1],data_e[PARITY-2:1],~data_e[0]};

wire [PARITY-1:0] sb;

altera_emif_io_hmc_ecc_pcm_112 ecc_pcm (
   .di(data_i),
   .sb({PARITY{1'b0}}),
   .dout(sb)
);

assign q          = {sb,data[DI-1:0]};

endmodule
