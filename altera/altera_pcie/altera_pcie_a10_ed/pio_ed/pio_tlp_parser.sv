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


//////// A Parser for the TLP on Avalon ST interface
// This design only suppoerts 1DW read and write.



module pio_tlp_parser #(
  parameter         WIDTH =       64

)(

// RX side
input                         pld_clk_i,
input                         clr_st_i,
input     [WIDTH-1:0]         rx_st_data_i,
input                         rx_st_sop_i,
input                         rx_st_eop_i,  
input     [7:0]               rx_st_bar_i,    
input                         rx_st_valid_i,

// Config side
input    [3:0]                tl_cfg_add_i,
input    [31:0]               tl_cfg_ctl_i,
// TX side
input                         tx_st_ready_i,
output reg                    tx_st_valid_o,  
output reg                    tx_st_sop_o,   
output reg                    tx_st_eop_o,   
output reg                    tx_st_empty_o,
output reg  [WIDTH-1:0]       tx_st_data_o, 

// Decoded signals
output  reg  [15:0]           cfg_busdev_r_o,
output  reg                   write_pkt_o,
output  reg                   read_pkt_o,
output  reg                   dw3_o,
output  reg                   dw4_o,
output  reg                   mem_type_o,
output  reg                   rx_st_bar_hit_o,
output  reg [3:0]             be_first_r_o,
output  reg [13:0]            address_r_o,
output  reg                   qword_alignment_o,
output  reg                   qword_alignmentdw3_o,
output  reg                   qword_alignmentdw4_o,
output  reg [7:0]             tag_o,
output  reg [15:0]            requester_id_o,
output  reg [1:0]             be_first_count_o,
output  reg [2:0]             be_count_o,
output  reg [2:0]             tc_o,
output  reg [1:0]             attr_o,


output  [WIDTH-1:0]           mem_data_o,
output                        mem_sop_o,  
output                        mem_valid_o,
output                        mem_eop_o,


// packet fifo interface////
output reg                               get_data,
output reg                               get_header,
input [(WIDTH == 64) ? (WIDTH): 96 : 0]  fifo_st_header_i,
input [31 : 0]                           fifo_mem_data_i,
input                                    header_fifo_empty,
input                                    data_fifo_empty

);

logic  [2:0]                  encode_bar;
reg  [4:0]                    tlp_type;
reg  [31:0]                   tl_cfg_ctl_r;
reg  [3:0]                    tl_cfg_add_r;

logic  [5:0]                  rx_st_bar_i_reg;
logic                         compltion_qword_align_out;
logic                         compltion_qword_align_out_r;
logic                         rx_st_sop_r;
logic                         rx_st_valid_r; 
logic                         rx_st_eop_r; 
logic                         rx_sop_reg;
logic                         tx_st_ready_i_r;
logic [WIDTH-1:0]             rx_st_data_r;

localparam HEAD1 = 3'b001;
localparam HEAD2 = 3'b010;
localparam DATA1 = 3'b100;

logic  [2:0] state_64, next_state_64;

localparam HEAD = 2'b01;
localparam DATA = 2'b10;
logic  [1:0]  state_128, next_state_128;


assign mem_data_o   = rx_st_data_r;
assign mem_sop_o    = rx_st_sop_r;
assign mem_valid_o  = rx_st_valid_r;
assign mem_eop_o    = rx_st_eop_r;


///////////////////// Get the Completer_id//////////////////////////////
always_ff @(posedge pld_clk_i) begin
  if (clr_st_i) begin
    cfg_busdev_r_o <= '0;
    tl_cfg_add_r   <= '0;
    tl_cfg_ctl_r   <= '0;
  end
  else begin
    tl_cfg_add_r <= tl_cfg_add_i;
    tl_cfg_ctl_r <= tl_cfg_ctl_i;
    if (tl_cfg_add_r == 4'hF) begin
      cfg_busdev_r_o <= {tl_cfg_ctl_r[12:0],3'b000};
    end
  end
end
/////////////////////////////////////////////////////////////////////////

//////////////////// Encode all bars.////////////////////////////////////
// All 5 bars are supported at once. The top address mask is not decoded
// The software or root port has to make sure that same address is not 
// accessed for different bars. Each bar gets access to 8KB memory.

generate
  always_comb begin
    if (WIDTH == 64)begin  
      case (rx_st_bar_i_reg) 
        6'h01    : encode_bar = 3'b001; 
        6'h02    : encode_bar = 3'b010; 
        6'h04    : encode_bar = 3'b011; 
        6'h08    : encode_bar = 3'b100;
        6'h10    : encode_bar = 3'b101; 
        6'h20    : encode_bar = 3'b110;
        default  : encode_bar = 3'b000;
      endcase
    end
    if (WIDTH == 128) begin
      case (rx_st_bar_i) 
        6'h01    : encode_bar = 3'b001; 
        6'h02    : encode_bar = 3'b010; 
        6'h04    : encode_bar = 3'b011; 
        6'h08    : encode_bar = 3'b100;
        6'h10    : encode_bar = 3'b101; 
        6'h20    : encode_bar = 3'b110;
        default  : encode_bar = 3'b000;
      endcase
    end
  end
endgenerate

always_ff @(posedge pld_clk_i) begin
  if (clr_st_i) begin
    rx_st_sop_r   <= '0; 
    rx_st_valid_r <= '0; 
    rx_st_eop_r   <= '0;
    rx_st_data_r  <= '0;
  end
  else begin
    rx_st_data_r  <= rx_st_data_i;
    rx_st_sop_r   <= rx_st_sop_i; 
    rx_st_valid_r <= rx_st_valid_i; 
    rx_st_eop_r   <= rx_st_eop_i;
  end
end


generate

  if (WIDTH == 64) begin

///////// Generic Packet decode signals/////////
  
    always_ff @(posedge pld_clk_i) begin
      if (clr_st_i) begin
        write_pkt_o            <= 1'b0;
        read_pkt_o             <= 1'b0;
        dw3_o                  <= 1'b0;
        dw4_o                  <= 1'b0;
        qword_alignment_o      <= 1'b0;
        address_r_o            <= '0;
        be_first_r_o           <= '0;
        tlp_type               <= '0;
        rx_sop_reg             <= '0;
        mem_type_o             <= 1'b0;
        rx_st_bar_hit_o        <= 1'b0;
        qword_alignmentdw3_o   <= 1'b0;
        qword_alignmentdw4_o   <= 1'b0;
        tag_o                  <= '0;
        requester_id_o         <= '0;
        be_first_count_o[1:0]  <= '0;
        be_count_o [2:0]       <= '0;
        tc_o                   <= '0;
        attr_o                 <= '0;
        rx_st_bar_i_reg        <= '0;
      end
      else begin
        qword_alignmentdw3_o <= 1'b0; // not used
        qword_alignmentdw4_o <= 1'b0; // not used
        
        if (rx_st_valid_i) begin
          rx_sop_reg <= rx_st_sop_i;
        end
        
        
        if (rx_st_eop_i && rx_st_valid_i) begin
          write_pkt_o <= '0;
          read_pkt_o  <= '0;          
        end
        
        if (rx_st_sop_i && rx_st_valid_i) begin
          write_pkt_o            <= rx_st_data_i[30];
          rx_st_bar_i_reg        <= rx_st_bar_i[5:0];
          read_pkt_o             <= !rx_st_data_i[30];
          dw3_o                  <= !rx_st_data_i[29];
          dw4_o                  <= rx_st_data_i[29];
          tlp_type               <= rx_st_data_i[28:24];
          be_first_r_o           <= rx_st_data_i[35:32];
          tag_o                  <= rx_st_data_i[47:40];
          requester_id_o         <= rx_st_data_i[63:48];
          be_first_count_o[1:0]  <= !rx_st_data_i[32] + !rx_st_data_i[33] + !rx_st_data_i[34]; // designed for 1dw read and write only
          be_count_o [2:0]       <= rx_st_data_i[32] + rx_st_data_i[33] + rx_st_data_i[34]  + rx_st_data_i[35]; // designed for 1dw read and write only
          rx_st_bar_hit_o        <= |rx_st_bar_i[5:0];
          tc_o                   <= rx_st_data_i[22:20];
          attr_o                 <= rx_st_data_i[13:12];
          if (rx_st_data_i[28:24] == 5'h00) begin
            mem_type_o <= 1'b1;
          end
          else begin
            mem_type_o <= 1'b0;
          end        
        end
        
        if (rx_sop_reg && rx_st_valid_i) begin
          if (dw3_o) begin
            qword_alignment_o <= !rx_st_data_i[2]; 
          end
          else begin
            qword_alignment_o <= !rx_st_data_i[34];       
          end
        end
        
        address_r_o[13:11] <= encode_bar;
        
        if (dw3_o && rx_sop_reg && rx_st_valid_i) begin
          address_r_o[10:0] <= rx_st_data_i[12:2];
        end     
        if (dw4_o && rx_sop_reg && rx_st_valid_i) begin
          address_r_o[10:0] <= rx_st_data_i[44:34];
        end        
      end
    end
  end
  
  if (WIDTH == 128) begin
    always_ff @(posedge pld_clk_i) begin
      if (clr_st_i) begin
        write_pkt_o            <= '0;
        read_pkt_o             <= '0;
        dw3_o                  <= 1'b0;
        dw4_o                  <= 1'b0;
        qword_alignmentdw3_o   <= 1'b0;
        qword_alignmentdw4_o   <= 1'b0;
        be_first_r_o           <= '0;
        tlp_type               <= '0;
        qword_alignment_o      <= 1'b0; 
        be_first_count_o[1:0]  <= '0;
        be_count_o [2:0]       <= '0;
        tc_o                   <= '0;
        attr_o                 <= '0;
        address_r_o            <= '0;
        requester_id_o         <= '0;
        tag_o                  <= '0;
        rx_st_bar_hit_o        <= '0;
        mem_type_o             <= 1'b0;
      end
      else begin
        
        qword_alignment_o   <= 1'b0;  // not used
        
        if (rx_st_sop_i && rx_st_valid_i) begin
          write_pkt_o            <= rx_st_data_i[30];
          read_pkt_o             <= !rx_st_data_i[30];
          dw3_o                  <= !rx_st_data_i[29];
          dw4_o                  <= rx_st_data_i[29];
          tlp_type               <= rx_st_data_i[28:24];
          qword_alignmentdw3_o   <= !rx_st_data_i[66]; 
          qword_alignmentdw4_o   <= !rx_st_data_i[98]; 
          be_first_r_o           <= rx_st_data_i[35:32];
          tag_o                  <= rx_st_data_i[47:40];
          requester_id_o         <= rx_st_data_i[63:48];
          be_first_count_o[1:0]  <= !rx_st_data_i[32] + !rx_st_data_i[33] + !rx_st_data_i[34]; // designed for 1dw read and write only
          be_count_o [2:0]       <= rx_st_data_i[32] + rx_st_data_i[33] + rx_st_data_i[34]  + rx_st_data_i[35]; // designed for 1dw read and write only
          rx_st_bar_hit_o        <= |rx_st_bar_i[5:0];
          tc_o                   <= rx_st_data_i[22:20];
          attr_o                 <= rx_st_data_i[13:12];
        
          if (rx_st_data_i[28:24] == 5'h00) begin
            mem_type_o <= 1'b1;
          end
          else begin
            mem_type_o <= 1'b0;
          end
        end
        address_r_o[13:11]  <= encode_bar;       
        
        if (!rx_st_data_i[29] && rx_st_sop_i && rx_st_valid_i) begin
           address_r_o[10:0] <= rx_st_data_i[76:66];
        end     
        if (rx_st_data_i[29] && rx_st_sop_i && rx_st_valid_i) begin
           address_r_o[10:0] <=  rx_st_data_i[108:98];
        end        
      end
    end
  end
endgenerate    


///////////////////////// send packet on tx interface/////////////////////////


generate
  if (WIDTH == 64) begin
    assign tx_st_data_o[63:32] = state_64[1] ? fifo_mem_data_i : fifo_st_header_i [63:32];
    assign tx_st_data_o[31:0]  = state_64[2] ? fifo_mem_data_i : fifo_st_header_i [31:0];
  end
  else begin
    assign tx_st_data_o[127:96] = state_128[0] ? fifo_mem_data_i: '0;
    assign tx_st_data_o[95:32]  = fifo_st_header_i [95:32];
    assign tx_st_data_o[31:0]   = state_128[0] ? fifo_st_header_i [31:0] : fifo_mem_data_i;
  end  
endgenerate

assign compltion_qword_align_out = fifo_st_header_i[(WIDTH == 64) ? (WIDTH): 96];

always_ff @(posedge pld_clk_i) begin
  if (clr_st_i) begin
    tx_st_ready_i_r <= '0;
  end
  else begin
    tx_st_ready_i_r <= tx_st_ready_i;
  end
end

always_ff @(posedge pld_clk_i) begin
  if (clr_st_i) begin
    state_128 <=  2'b01;
    state_64  <=  3'b001;
  end
  else begin
      state_128 <= next_state_128;
      state_64  <= next_state_64;
  end
end

generate

  if (WIDTH == 64) begin
    always_comb begin
      case (state_64)        
        HEAD1 : begin
          tx_st_empty_o  = 1'b0;
          tx_st_eop_o  = 1'b0;
          get_data = 1'b0;   
          if (tx_st_ready_i_r && !header_fifo_empty) begin
             get_header = 1'b1;      
             tx_st_sop_o  = 1'b1;
             tx_st_valid_o = 1'b1;
             next_state_64 = HEAD2;
          end        
          else begin
             get_header = 1'b0;      
             tx_st_sop_o  = 1'b0;
             tx_st_valid_o = 1'b0;
             next_state_64 = HEAD1;
          end    
        end
        
        HEAD2 : begin
          tx_st_empty_o  = 1'b0;        
          tx_st_sop_o  = 1'b0;        
          if (tx_st_ready_i_r && !header_fifo_empty && !data_fifo_empty) begin        
            if (!compltion_qword_align_out_r) begin
              next_state_64 = HEAD1;
              get_header = 1'b1;
              get_data = 1'b1;
              tx_st_valid_o = 1'b1;      
              tx_st_eop_o  = 1'b1;
            end
            else begin
              next_state_64 = DATA1;            
              get_header = 1'b1;
              tx_st_valid_o = 1'b1;
              get_data = 1'b0;     
              tx_st_eop_o  = 1'b0;
            end
          end          
          else begin
            next_state_64 = HEAD2;
            get_header = 1'b0;
            get_data = 1'b0;
            tx_st_valid_o = 1'b0;
            tx_st_eop_o  = 1'b0;
          end
        end
        
        DATA1 : begin
          tx_st_empty_o  = 1'b0;
          get_header = 1'b0;
          tx_st_sop_o  = 1'b0; 
          if (tx_st_ready_i_r && !data_fifo_empty) begin
            next_state_64 = HEAD1;
            tx_st_eop_o  = 1'b1;
            get_data = 1'b1;
            tx_st_valid_o = 1'b1;        
          end
          else begin
            next_state_64 = DATA1;
            tx_st_eop_o  = 1'b0;
            get_data = 1'b0;
            tx_st_valid_o = 1'b0;  
          end
        end 
        
        default: begin
          next_state_64 = HEAD1;
          tx_st_eop_o  = 1'b0;
          get_data = 1'b0;
          get_header = 1'b0;
          tx_st_valid_o = 1'b0;        
          tx_st_sop_o  = 1'b0;
          tx_st_empty_o  = 1'b0;
        end 
      endcase
    end
  end
    
  if (WIDTH == 128) begin
    always_comb begin
      case (state_128)      
        HEAD : begin 
          tx_st_empty_o  = 1'b0;
          if (tx_st_ready_i_r && !header_fifo_empty && !data_fifo_empty) begin        
            tx_st_sop_o  = 1'b1;
            if (!compltion_qword_align_out) begin
              next_state_128 = HEAD;
              get_header = 1'b1;
              get_data = 1'b1;
              tx_st_valid_o = 1'b1;      
              tx_st_eop_o  = 1'b1;
            end
            else begin
              next_state_128 = DATA;            
              get_header = 1'b1;
              tx_st_valid_o = 1'b1;
              get_data = 1'b0;     
              tx_st_eop_o  = 1'b0;
            end
          end          
          else begin     
            tx_st_sop_o  = 1'b0;
            next_state_128 = HEAD;
            get_header = 1'b0;
            get_data = 1'b0;
            tx_st_valid_o = 1'b0;
            tx_st_eop_o  = 1'b0;
          end      
        end
        
        DATA : begin
          get_header = 1'b0;               
          tx_st_sop_o  = 1'b0;
          if (tx_st_ready_i_r && !data_fifo_empty) begin
            next_state_128 = HEAD;
            tx_st_eop_o  = 1'b1;
            get_data = 1'b1;
            tx_st_valid_o = 1'b1;
            tx_st_empty_o  = 1'b1;          
          end
          else begin
            next_state_128 = DATA;
            tx_st_eop_o  = 1'b0;
            get_data = 1'b0;
            tx_st_valid_o = 1'b0;  
            tx_st_empty_o  = 1'b0;
          end
        end 
        
        default: begin
          next_state_128 = HEAD;     
          tx_st_sop_o  = 1'b0;
          tx_st_empty_o  = 1'b0;
          tx_st_eop_o  = 1'b0;
          get_data = 1'b0;
          get_header = 1'b0;
          tx_st_valid_o = 1'b0;  
        end 
      endcase
    end
  end
endgenerate

always_ff @(posedge pld_clk_i) begin
  if (clr_st_i) begin
    compltion_qword_align_out_r <= '0;
  end
  else begin
    if (state_128[0]) begin
      compltion_qword_align_out_r <= compltion_qword_align_out;
    end    
    if (state_64[0]) begin
      compltion_qword_align_out_r <= compltion_qword_align_out;
    end
  end
end



endmodule