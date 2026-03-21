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


module pio_mm_to_avst #(
  parameter         WIDTH =       64

)(

input                                 pld_clk_i,
input                                 reset_i,

input        [15:0]                   completer_id,
input                                 read_pkt_i,
input                                 dw3_i,
input                                 dw4_i,
input                                 mem_type_i,
input                                 rx_st_bar_hit_i,
input    [13:0]                       address_r_i,
input                                 qword_alignment_i,
input                                 qword_alignmentdw3_i,
input                                 qword_alignmentdw4_i,
input    [3:0]                        be_first_i,
input    [7:0]                        tag_i,
input    [15:0]                       requester_id_i,
input    [2:0]                        tc_i,
input    [1:0]                        attr_i,
input    [1:0]                        be_first_count_i,
input    [2:0]                        be_count_i,

input                                 mem_sop_i,  
input                                 mem_valid_i,
input                                 mem_eop_i,

output reg  [13:0]                    raddress_o,          // memory Interface
output [(WIDTH == 64)?(WIDTH):96:0]   header_fifo_in,
output                                fifo_put_data,
output                                fifo_put_header

);


logic [1:0]                                     put_data;
logic                                           put_header;
logic [(WIDTH == 64) ? (WIDTH -1): 95 : 0]      header_data;
logic [63 : 0]                                  header_data1;
logic [(WIDTH == 64) ? (WIDTH -1): 31 : 0]      header_data2;
logic                                           sel_h1;
logic                                           compltion_qword_align_in;
logic                                           compltion_qword_align;
logic                                           dw3;
logic                                           dw4;
logic                                           mem_sop_i_reg;
logic                                           read_pkt;
logic                                           qword_alignment_i_r;
logic                                           qword_alignmentdw3_i_r;
logic                                           qword_alignmentdw4_i_r;
logic                                           dw3_i_r;
logic                                           mem_sop_reg;


assign header_data               = (WIDTH == 64)  ? (sel_h1 ? header_data1: header_data2) : {header_data2,header_data1};
assign compltion_qword_align_in  = (WIDTH == 64)  ? qword_alignment_i_r : dw3_i_r ? qword_alignmentdw3_i_r : qword_alignmentdw4_i_r;
assign header_fifo_in            = {compltion_qword_align_in,header_data};


assign fifo_put_data    = put_data[1];
assign fifo_put_header  = put_header;

//assign header_fifo_out = {compltion_qword_align_out,header_data};

//assign be_first_count_wire[1:0] = !rx_st_data_i[32] + !rx_st_data_i[33] + !rx_st_data_i[34]; 
//assign be_count_wire [2:0]      =  rx_st_data_i[32] + rx_st_data_i[33] + rx_st_data_i[34]  + rx_st_data_i[35];
//assign raddress_o               = (WIDTH == 64) ? ((rx_st_sop_reg && rx_st_valid_i && dw3) ? {encode_bar,rx_st_data_i[12:2]} : {encode_bar,rx_st_data_i[44:34]}) :((!rx_st_data_i[29] && rx_st_sop_i && rx_st_valid_i) ? {encode_bar,rx_st_data_i[76:66]}: {encode_bar,rx_st_data_i[108:98]}) ; 


/////////////////////PUT THE PACKET IN HEADER AND DATA FIFO ////////////////////////

always_ff @(posedge pld_clk_i) begin
  if (reset_i) begin
    raddress_o             <= '0;
    qword_alignment_i_r    <= '0;
    qword_alignmentdw3_i_r <= '0;
    dw3_i_r                <= '0;
    qword_alignmentdw4_i_r <= '0;
  end
  else begin
    if (mem_valid_i) begin
      raddress_o             <= address_r_i;
      qword_alignment_i_r    <= qword_alignment_i;
      qword_alignmentdw3_i_r <= qword_alignmentdw3_i;
      dw3_i_r                <= dw3_i;
      qword_alignmentdw4_i_r <= qword_alignmentdw4_i;
    end
  end
end
generate

  if ((WIDTH == 64)) begin
    always_ff @(posedge pld_clk_i) begin
      if (reset_i) begin
        read_pkt       <= '0;
        put_data       <= '0;
        put_header     <= '0;
        sel_h1         <= 1'b0;
        header_data2   <= '0;
        header_data1   <= '0;
      end
      else begin
        put_header  <= '0;
        put_data[0] <= 1'b0;  
        put_data[1] <= put_data[0];      
        sel_h1      <= 1'b0;
        
        if (mem_valid_i) begin
          mem_sop_i_reg <= mem_sop_i;
        end
        
        if (mem_sop_i && mem_valid_i) begin
          read_pkt     <= (read_pkt_i & rx_st_bar_hit_i & mem_type_i);
          put_header   <= (read_pkt_i & rx_st_bar_hit_i & mem_type_i);          
          sel_h1       <= 1'b1;
          header_data1 <= {completer_id,3'b000,1'b0,{9'h000,be_count_i},1'b0,2'b10,5'b01010,1'b0,tc_i,4'h0,2'b00,attr_i,2'b00,10'h001};
                       // completer_id,com_stat,BCM, Byte_count,            R,   FMT,    Type,   R,  TC,  R,  TDEP, Attr,     R,   Length
        end
       
        if(mem_sop_i_reg && mem_valid_i)begin
          put_data[0]  <=  read_pkt;
          put_header   <=  read_pkt;
          header_data2 <= {32'h00000000,requester_id_i,tag_i,1'b0,{address_r_i[4:0],be_first_count_i}}; 
        end 
        
/*         if (rx_st_sop_i && |rx_st_data_i[7:1]  && rx_st_valid_i) begin
          header_data1 <= {16'h0000, 3'b001,  1'b0,  12'h000,1'b0,2'b00,5'b01010,1'b0,rx_st_data_i[22:20],4'h0,2'b00,rx_st_data_i[13:12],2'b00,10'h000};
                           // completer_id,com_stat,BCM,Byte_count,R,FMT,Type,         R,      TC,                    R,  TDEP,  Attr,                    R,Length
                          // This is an error packet.
        end
        else  */
      end
    end   
  end
  
  
  if ((WIDTH == 128)) begin
    always_ff @(posedge pld_clk_i) begin
      if (reset_i) begin
        put_data      <= '0;
        put_header    <= '0;
        header_data1  <= '0;
        header_data2  <= '0;
      end
      else begin
        put_header  <= '0;
        put_data[0] <= 1'b0;  
        put_data[1] <= put_data[0];      
        
        if (mem_sop_i && mem_valid_i) begin
          put_header  <= (read_pkt_i & rx_st_bar_hit_i & mem_type_i);  // bar true and read true
          put_data[0] <= (read_pkt_i & rx_st_bar_hit_i & mem_type_i);  // bar true and read true
        end
        
   /*      if (rx_st_sop_i && |rx_st_data_i[7:1]  && rx_st_valid_i) begin
          header_data2 <= {rx_st_data_i[63:48],rx_st_data_i[47:40],1'b0,5'h00,be_first_count_wire};
          header_data1 <= {16'h0000, 3'b001,  1'b0,  12'h000,1'b0,2'b00,5'b01010,1'b0,rx_st_data_i[22:20],4'h0,2'b00,rx_st_data_i[13:12],2'b00,10'h000};
                           // completer_id,com_stat,BCM,Byte_count,R,FMT,Type,         R,      TC,                    R,  TDEP,  Attr,                    R,Length
                          // This is an error packet.
        end
        else */ if (mem_sop_i && mem_valid_i) begin
          header_data2 <= {requester_id_i,tag_i,1'b0,address_r_i[4:0],be_first_count_i};
          header_data1 <= {completer_id,3'b000,1'b0,{9'h000,be_count_i},1'b0,2'b10,5'b01010,1'b0,tc_i,4'h0,2'b00,attr_i,2'b00,10'h001};
                      // completer_id,com_stat,BCM,Byte_count,              R,   FMT,   Type,   R,  TC,   R,  TDEP,  Attr,  R,   Length
        end
      end
    end   
  end

endgenerate
endmodule