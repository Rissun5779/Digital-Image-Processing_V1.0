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


module pio_fifo #(
  parameter          DATA_WIDTH = 32,
  parameter          FAMILY = "Arria 10",
  parameter          DEPTH = 10 //////////keep it 10

) (
  input                        clk_i,   
  input                        reset_i,
  input     [DATA_WIDTH-1:0]   data_in_i,
  output    [DATA_WIDTH-1:0]   data_out_o,   
  output                       empty_o,
  output                       almost_full_o,
  output                       full_o,
  input                        put_i,            
  input                        get_i            
);

  logic [DATA_WIDTH-1 : 0]     fifo [0:9];
  logic [3:0]                  rd_ptr_reg;
  logic [3:0]                  wr_ptr_reg;
  logic [3:0]                  fill_count;
  
  logic [3:0]                  rd_ptr,wr_ptr;
  
  assign full_o        = (fill_count == 4'hA)? 1'b1 : 1'b0;
  assign empty_o       = (fill_count == 0)? 1'b1 : 1'b0;
  assign almost_full_o = fill_count[3];
  assign data_out_o    = fifo[rd_ptr_reg];
  

  always @(*) begin
    if (put_i == 1'b1 )
      wr_ptr = wr_ptr_reg + 1'b1;
    else     
      wr_ptr = wr_ptr_reg;
   end
  
  always @(*) begin
    if (get_i == 1'b1 )
      rd_ptr = rd_ptr_reg + 1'b1;
    else     
      rd_ptr = rd_ptr_reg;      
  end
  
  always_ff @(posedge clk_i) begin
    if (reset_i) begin
      rd_ptr_reg <= 0;
      wr_ptr_reg <= 0;
    end
    else begin
      wr_ptr_reg <= wr_ptr;
      if (wr_ptr == 4'hA) begin
        wr_ptr_reg <= '0;
      end
      rd_ptr_reg <= rd_ptr; 
      if (rd_ptr == 4'hA) begin
        rd_ptr_reg <= '0;
      end      
    end  
  end
    
  always_ff @(posedge clk_i) begin
    if (reset_i) begin
      fill_count <= 0;
    end
    else if (put_i  && !get_i && !full_o) begin
        fill_count <= fill_count + 1'b1;
    end
    else if (!put_i  && get_i && fill_count != (0)) begin
        fill_count <= fill_count - 1'b1;   
    end  
  end
  
  always_ff @(posedge clk_i) begin
    if (put_i && !full_o) begin
        fifo[wr_ptr_reg] <= data_in_i;
    end
  end
endmodule