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


module pipe_scrambler #(
  parameter words_pld_if = 4,
  parameter pld_if_dw    = 32
) (
  input                     pclk,
  input                     reset,
  input                     reset_scrambler,
  input                     advance_scrambler,
  input [2:0]               lane_number,
  input [words_pld_if-1:0]  scramble_data_en,
  input [pld_if_dw-1:0]     data_in,
  output [pld_if_dw-1:0]    data_out
);

integer i;
genvar b;
reg  [22:0]               scrambler_curr;
reg  [22:0]               next_seed;
reg  [31:0]               scramble_bits;
reg  [31:0]               scramble_invert;
wire [22:0]               scrambler_seed;
wire [31:0]               scrambled_data;


assign scrambler_seed = (lane_number == 3'b000) ? 23'h1DBFBC :
                        (lane_number == 3'b001) ? 23'h0607BB :
                        (lane_number == 3'b010) ? 23'h1EC760 :
                        (lane_number == 3'b011) ? 23'h18C0DB :
                        (lane_number == 3'b100) ? 23'h010F12 :
                        (lane_number == 3'b101) ? 23'h19CFC9 :
                        (lane_number == 3'b110) ? 23'h0277CE :
                        (lane_number == 3'b111) ? 23'h1BB807 : 23'h1DBFBC;
assign scrambled_data = scramble_bits[pld_if_dw-1:0] ^ data_in;

always@(*) begin
  //extrapolate the entire 32-bits of scrambled data
  for(i=0; i<pld_if_dw; i=i+1) begin
    if(i<=1) begin
      scramble_bits[i] = scrambler_curr[22-i];
    end else if(i<=6) begin
      scramble_bits[i] = scrambler_curr[22-i]^scramble_bits[i-2];
    end else if(i<=14) begin
      scramble_bits[i] = scrambler_curr[22-i]^scramble_bits[i-7]^scramble_bits[i-2];
    end else if(i<=17) begin
      scramble_bits[i] = scrambler_curr[22-i]^scramble_bits[i-15]^scramble_bits[i-7]^scramble_bits[i-2];
    end else if(i<=20) begin
      scramble_bits[i] = scrambler_curr[22-i]^scramble_bits[i-18]^scramble_bits[i-15]^scramble_bits[i-7]^scramble_bits[i-2];
    end else if(i<=22) begin
      scramble_bits[i] = scrambler_curr[22-i]^scramble_bits[i-21]^scramble_bits[i-18]^scramble_bits[i-15]^scramble_bits[i-7]^scramble_bits[i-2];
    end else begin
      scramble_bits[i] = scramble_bits[i-23]^scramble_bits[i-21]^scramble_bits[i-18]^scramble_bits[i-15]^scramble_bits[i-7]^scramble_bits[i-2];
    end 
  end

  //Invert the order of the bits
  for(i=0; i<pld_if_dw; i=i+1) begin
    scramble_invert[i] = scramble_bits[pld_if_dw-i-1];
  end

  //Determine the value in the LFSR-based scrambler
  for(i=0; i<23; i=i+1) begin
     if(i<=1) begin
      next_seed[22-i] = scramble_invert[22-i]^scramble_invert[20-i]^scramble_invert[17-i]^scramble_invert[14-i]^scramble_invert[6-i]^scramble_invert[1-i];
    end else if(i<=6) begin
      next_seed[22-i] = scramble_invert[22-i]^scramble_invert[20-i]^scramble_invert[17-i]^scramble_invert[14-i]^scramble_invert[6-i];
    end else if(i<=14) begin
      next_seed[22-i] = scramble_invert[22-i]^scramble_invert[20-i]^scramble_invert[17-i]^scramble_invert[14-i];
    end else if(i<=17) begin
      next_seed[22-i] = scramble_invert[22-i]^scramble_invert[20-i]^scramble_invert[17-i];
    end else if(i<=20) begin
      next_seed[22-i] = scramble_invert[22-i]^scramble_invert[20-i];
    end else begin
      next_seed[22-i] = scramble_invert[22-i];
    end
  end
end
    
always@(posedge pclk or posedge reset) begin
  if(reset == 1'b1) begin
    scrambler_curr      <= scrambler_seed;
  end else if(reset_scrambler) begin
    scrambler_curr      <= scrambler_seed;
  end else if(advance_scrambler) begin
    scrambler_curr      <= next_seed[22:0];
  end else begin
    scrambler_curr      <= scrambler_curr;
  end
end

generate
for(b=0;b<words_pld_if;b=b+1) begin: scramble_by_symbol
  assign data_out[b*8+:8] = (scramble_data_en[b] == 1'b1) ? scrambled_data[b*8+:8] : data_in[b*8+:8];
end
endgenerate

endmodule
