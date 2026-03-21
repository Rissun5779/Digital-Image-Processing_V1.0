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




module pio_avmm_interface
(

input                       pld_clk_i,
input                       clr_st_i,
input                       avmm_read_i,                            
input      [13:0]           avmm_raddress_i,  
input      [3:0]            avmm_be_first_i, // byte enables for 1st Dword
input      [31:0]           avmm_data_out_i,
input                       avmm_write_i,
input      [13:0]           avmm_waddress_i,
input                       avmm_waitrequest_i,

output reg   [15:0]         avmm_address_o,
output reg   [31:0]         avmm_writedata_o,
output reg   [3:0]          avmm_byteenable_o,
output reg                  avmm_write_o,
output reg                  avmm_read_o,
output                      fifo_afull
);


logic [32+14+4+2-1:0]      fifo_in;
logic [32+14+4+2-1:0]      fifo_out;
logic                      fifo_empty;
logic [13:0]               avmm_address;
logic [31:0]               avmm_data;
logic [3:0]                avmm_byteenable;
logic                      avmm_read;
logic                      avmm_write;



assign fifo_in = avmm_write_i ? {avmm_data_out_i,avmm_waddress_i,avmm_be_first_i,avmm_write_i,1'b0} :{avmm_data_out_i,avmm_waddress_i,avmm_be_first_i,1'b0,avmm_read_i};

assign avmm_data       = fifo_out[51:20];
assign avmm_address    = fifo_out[19:6];
assign avmm_byteenable = fifo_out[5:2];
assign avmm_write      = fifo_out[1];
assign avmm_read       = fifo_out[0];



always_ff @(posedge pld_clk_i) begin
  if (clr_st_i) begin
    avmm_address_o    <= '0;
    avmm_writedata_o  <= '0;
    avmm_byteenable_o <= '0;
    avmm_write_o      <= '0;
    avmm_read_o       <= '0;
  end
  else begin
    if (!fifo_empty && !avmm_waitrequest_i) begin
      avmm_write_o      <= avmm_write;
      avmm_read_o       <= avmm_read;
      avmm_address_o    <= {avmm_address,2'b00};
      avmm_writedata_o  <= avmm_data;
      avmm_byteenable_o <= avmm_byteenable;
    end
    else if (!avmm_waitrequest_i) begin
      avmm_write_o <= '0;
      avmm_read_o  <= '0;
    end
  end
end



pio_avmm_interface_fifo #(
  .DATA_WIDTH (32+14+4+2)

) avmm_interface_fifo (
  .clk_i                                    (pld_clk_i),
  .reset_i                                  (clr_st_i),
  .data_in_i                                (fifo_in),
  .data_out_o                               (fifo_out),
  .empty_o                                  (fifo_empty),
  .almost_full_o                            (fifo_afull),
  .full_o                                   (),
  .put_i                                    (avmm_write_i | avmm_read_i),
  .get_i                                    ((!fifo_empty & !avmm_waitrequest_i))
);

endmodule