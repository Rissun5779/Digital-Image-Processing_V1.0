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


module alt_xcvr_bit_slip_top #(
  parameter DATA_WIDTH=16,
  parameter CHANNELS=1
) (
 input [CHANNELS-1:0]  clk,
 input [CHANNELS-1:0]  reset,
 input [DATA_WIDTH*CHANNELS-1:0] ext_data_pattern,
 input [DATA_WIDTH*CHANNELS-1:0] rx_parallel_data,
 output [CHANNELS-1:0]           rx_bitslip
);

wire [DATA_WIDTH-1:0] rx_parallel_data_w[CHANNELS-1:0];
wire [DATA_WIDTH-1:0] ext_data_pattern_w[CHANNELS-1:0];

genvar i;
generate 
  for(i=0; i<CHANNELS; i=i+1) begin: slip_gen
	  alt_xcvr_bit_slip #(
            .DATA_WIDTH(DATA_WIDTH)
          ) bit_slip_inst (
		  .clk                    (clk[i]),          
      .reset                  (reset[i]),    
      .ext_data_pattern       (ext_data_pattern_w[i]),    
      .rx_parallel_data       (rx_parallel_data_w[i]),
		  .rx_bit_slip            (rx_bitslip[i])
	  );
    
    assign rx_parallel_data_w[i] = rx_parallel_data[DATA_WIDTH*(i+1)-1:DATA_WIDTH*i];
    assign ext_data_pattern_w[i] = ext_data_pattern[DATA_WIDTH*(i+1)-1:DATA_WIDTH*i];

  end

endgenerate

endmodule 
