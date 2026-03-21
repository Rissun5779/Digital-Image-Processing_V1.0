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


module parallel_match #(
	parameter DATA_WIDTH = 32,
	parameter ADDR_1HOT = 16,
	parameter ADDR_WIDTH = 4
	)(
	input clk,
	input rst,
	input [ADDR_WIDTH-1:0] waddr,
	input [DATA_WIDTH-1:0] wdata,
	input [DATA_WIDTH-1:0] wcare,
	input wena,
	input [DATA_WIDTH-1:0] lookup_data,
	input lookup_data_valid,
	input lookup_ena,
	output reg match,
	output reg [ADDR_WIDTH-1:0] match_addr
	);
 

wire [ADDR_1HOT-1:0] match_lines;
wire [ADDR_1HOT-1:0] word_wena;
reg  [ADDR_1HOT-1:0] waddr_dec;

always @(*) begin
    waddr_dec = 0;
    waddr_dec[waddr] = 1'b1;
end

assign word_wena = waddr_dec & {ADDR_1HOT{wena}};

// writing "all don't care" disables the word.
wire wused = |wcare /*synthesis keep*/;

// storage and match cells
genvar i;
generate 
  for (i=0; i<ADDR_1HOT; i=i+1)
  begin : cw
    reg_cam_cell c (
		.clk(clk),
		.rst(rst),
		.wdata(wdata),
		.wcare(wcare),
		.wused(wused),
		.wena(word_wena[i]),
		.lookup_data(lookup_data),
		.lookup_ena(lookup_ena),
		.match(match_lines[i])
    );
    defparam c.DATA_WIDTH = DATA_WIDTH; 
  end
endgenerate

wire [ADDR_WIDTH-1:0] onehot;
reg lookup_data_valid_r0 = 1'b0;

always @(posedge clk) if (lookup_ena) lookup_data_valid_r0 <= lookup_data_valid;
always @(posedge clk) if (lookup_ena) match      <= |match_lines & lookup_data_valid_r0;
always @(posedge clk) if (lookup_ena) match_addr <=  onehot;

genvar k,j;
generate
	for (j=0; j<ADDR_WIDTH; j=j+1)
	begin : jl
		wire [ADDR_1HOT-1:0] tmp_mask;
		for (k=0; k<ADDR_1HOT; k=k+1)
		begin : il
			assign tmp_mask[k] = k[j];
		end	
		assign onehot[j] = |(tmp_mask & match_lines);
	end
endgenerate



// match encoder


endmodule


module reg_cam_cell (
	clk,rst,
	wdata,wcare,wused,wena,
	lookup_data,lookup_ena,match
);

parameter DATA_WIDTH = 32;

input clk,rst;
input [DATA_WIDTH-1:0] wdata, wcare;
input wused,wena;

input [DATA_WIDTH-1:0] lookup_data;
input lookup_ena;
output match;
reg match;

reg cell_used;

// Storage cells
reg [DATA_WIDTH - 1 : 0] data;
reg [DATA_WIDTH - 1 : 0] care;
always @(posedge clk) begin
  if (rst) begin
	cell_used <= 1'b0;
	data <= {DATA_WIDTH{1'b0}};
	care <= {DATA_WIDTH{1'b0}};
  end else begin
	if (wena) begin
	   cell_used <= wused;
	   data <= wdata;
       care <= wcare;
	end
  end
end

// Ternary match
wire [DATA_WIDTH-1:0] bit_match;
genvar i;
generate 
  for (i=0; i<DATA_WIDTH; i=i+1)
  begin : bmt
    assign bit_match[i] = !care[i] | !(data[i] ^ lookup_data[i]);
  end
endgenerate

always @(posedge clk) begin
  if (rst) match <= 1'b0;
  else if (lookup_ena) match <= (& bit_match) & cell_used;
end

endmodule

