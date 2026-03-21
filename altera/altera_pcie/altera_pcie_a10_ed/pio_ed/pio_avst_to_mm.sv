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



module pio_avst_to_mm #(
  parameter         WIDTH =       128,
  parameter  FAMILY = "Arria 10"

)(

input                        pld_clk_i,
input                        reset_i,

input                        write_pkt_i,
input                        dw3_i,
input                        dw4_i,
input                        mem_type_i,
input                        rx_st_bar_hit_i,
input    [WIDTH-1:0]         mem_data_i,
input                        mem_sop_i,  
input                        mem_valid_i,
input                        mem_eop_i,
input    [13:0]              address_r_i,
input                        qword_alignment_i,
input                        qword_alignmentdw3_i,
input                        qword_alignmentdw4_i,
input    [3:0]               be_first_i,



// Interface to avst_to_mm

output reg  [3:0]            be_first_o, // byte enables for 1st Dword
output      [31:0]           mm_data_out_o,
output                       mm_write_o,
output      [13:0]           waddress_o



);



reg                      mm_write_data_r;
reg                      mm_write_header_r; 
reg   [3:0]              be_first_i_r;
reg   [WIDTH-1:0]        mem_data_i_r;       
reg                      qword_alignment_i_r;
reg                      qword_alignmentdw3_i_r;
reg                      dw4_i_r,dw3_i_r;
reg                      qword_alignmentdw4_i_r;
reg                      write_pkt_r;


logic                    mm_write_header;
logic                    mm_write_data;
logic  [13:0]            waddress_r_o;

  
localparam HEAD1 = 3'b001;
localparam HEAD2 = 3'b010;
localparam DATA1 = 3'b100;

logic  [2:0] state_64, next_state_64;

localparam HEAD = 2'b01;
localparam DATA = 2'b10;
logic  [1:0]  state_128, next_state_128;

assign be_first_o    = be_first_i_r;
assign waddress_o    = waddress_r_o;
assign mm_write_o    = (WIDTH == 64) ? ((dw3_i_r && !qword_alignment_i_r) ? mm_write_header_r : mm_write_data_r) : ((dw3_i_r && !qword_alignmentdw3_i_r) ? mm_write_header_r : mm_write_data_r); 
assign mm_data_out_o = (WIDTH == 64) ? ((qword_alignment_i_r) ? mem_data_i_r[31:0] : mem_data_i_r[63:32]) : ((dw3_i_r && !qword_alignmentdw3_i_r) ? mem_data_i_r[127:96] : ((dw4_i_r && !qword_alignmentdw4_i_r) ? mem_data_i_r[63:32] : mem_data_i_r[31:0] ));
  
always_ff @(posedge pld_clk_i) begin
  if (reset_i) begin
    state_128   <=  2'b01;
    state_64    <=  3'b001;
    write_pkt_r <= '0;
  end
  else begin
    state_128   <= next_state_128;
    state_64    <= next_state_64;
    write_pkt_r <= write_pkt_i;
  end
end


generate

  always_comb begin
    if (WIDTH == 64) begin
      case (state_64)        
        HEAD1 : begin      
          mm_write_header = 1'b0;
          mm_write_data   = 1'b0; 
          if (write_pkt_i && mem_sop_i && mem_valid_i && rx_st_bar_hit_i) begin
            next_state_64 = HEAD2;
          end
          else begin
            next_state_64 = HEAD1;
          end    
        end
        
        HEAD2 : begin          
          mm_write_data = 1'b0; 
          if (mem_sop_i && mem_valid_i) begin
            next_state_64 = HEAD1;
          end
          else if (mem_valid_i) begin
            next_state_64 = DATA1;
          end
          else begin
            next_state_64 = HEAD2;
          end      
          if (write_pkt_r && mem_valid_i && mem_type_i)  begin
            mm_write_header = 1'b1;
          end     
          else begin
            mm_write_header = 1'b0;      
          end
        end
        
        DATA1 : begin
          mm_write_header = 1'b0;
          if (mem_valid_i) begin
            next_state_64 = HEAD1;
          end
          else begin
            next_state_64 = DATA1;
          end
          
          if (mem_valid_i && write_pkt_r && mem_type_i) begin
            mm_write_data = 1'b1;
          end
          else begin
            mm_write_data = 1'b0;      
          end  
        end 
        
        default: begin
          next_state_64   = HEAD1;
          mm_write_header = 1'b0;
          mm_write_data   = 1'b0; 
        end 
      endcase
    end
    
    if (WIDTH == 128) begin
       case (state_128)
        
        HEAD : begin
          mm_write_data = 1'b0;
          if (mem_sop_i && mem_valid_i && rx_st_bar_hit_i && !mem_eop_i) begin
            next_state_128 = DATA;
          end
          else begin
            next_state_128 = HEAD;
          end
          if (mem_sop_i && mem_valid_i && rx_st_bar_hit_i && mem_type_i) begin
            mm_write_header =1'b1;        
          end
          else begin
            mm_write_header =1'b0;
          end        
        end
        
        DATA : begin
          mm_write_header =1'b0;
          if (mem_valid_i) begin
            next_state_128 = HEAD;
          end
          else begin
            next_state_128 = DATA;
          end 
          
          if (write_pkt_i && mem_valid_i && mem_type_i) begin
            mm_write_data = 1'b1;
          end
          else begin
            mm_write_data = 1'b0;      
          end      
        end
        
        default: begin
          next_state_128  = HEAD;
          mm_write_header =1'b0;
          mm_write_data   =1'b0;
          end 
      endcase
    end
  end
endgenerate


always_ff @(posedge pld_clk_i) begin
  if (reset_i) begin
    mem_data_i_r           <= '0;
    waddress_r_o           <= '0;
    mm_write_data_r        <= '0;
    mm_write_header_r      <= '0;
    be_first_i_r           <= '0;
    qword_alignment_i_r    <= '0;
    qword_alignmentdw3_i_r <= '0;
    dw4_i_r                <= '0;
    qword_alignmentdw4_i_r <= '0;
    dw3_i_r                <= '0;
  end
  else begin
    mm_write_data_r        <= '0;
    mm_write_header_r      <= '0;
    if (mem_valid_i) begin
      mem_data_i_r           <= mem_data_i;
      waddress_r_o           <= address_r_i;
      mm_write_data_r        <= mm_write_data;
      mm_write_header_r      <= mm_write_header;
      be_first_i_r           <= be_first_i;
      qword_alignment_i_r    <= qword_alignment_i;
      qword_alignmentdw3_i_r <= qword_alignmentdw3_i;
      dw4_i_r                <= dw4_i;
      dw3_i_r                <= dw3_i;
      qword_alignmentdw4_i_r <= qword_alignmentdw4_i;
    end
  end
end 
endmodule
