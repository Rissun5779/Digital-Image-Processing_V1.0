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


module pipe_data_checker #(
  parameter lanes         = 1,
  parameter pld_if_dw     = 16,
  parameter pattern       = "prbs",
  parameter fast_sim      = "true",
  parameter max_rate      = "gen2",
  parameter words_pld_if  = 2
) (
  input                           pclk,
  input                           reset,
  input [1:0]                     rate,
  input [2:0]                     state,
  input [lanes-1:0]               rx_syncstatus,
  input [lanes-1:0]               rx_valid,
  input [lanes-1:0]               rx_data_valid,
  input [lanes-1:0]               rx_blk_start,
  input [lanes*pld_if_dw-1:0]     rx_data,
  input [lanes*words_pld_if-1:0]  rx_datak,
  input [lanes*2-1:0]             rx_sync_hdr,
  output                          rx_iei,
  output [1:0]                    ts_done,
  output reg [lanes-1:0]          polarity,
  output [lanes-1:0]              errors
);

//local wires and regs as well as integers for generates
//reg [lanes*words_pld_if-1:0]  channel_aligned;
//reg [lanes-1:0]               gen3_rx_data_aligned;
//ire [lanes-1:0]              gen12_word_to_channel_align;
//wire [lanes-1:0]              words_to_channel_align;
//wire [lanes-1:0]              words_to_channel_align;
integer i;

//localprams
localparam [2:0] SM_IDLE     = 3'd0,
                 SM_XMT_TS   = 3'd1,
                 SM_XMT_DATA = 3'd4;
localparam [7:0] k_com       = 8'hbc;
localparam [7:0] g3_ts1_sym  = 8'h1E;
localparam [7:0] g3_ts2_sym  = 8'h2D;
localparam [7:0] ts1_d_sym   = 8'h4A;
localparam [7:0] ts2_d_sym   = 8'h45;

reg  [8*lanes-1:0]               sixth_sym;
reg  [4*lanes-1:0]               count_consecutive;
reg  [4*lanes-1:0]               rx_blk_start_buf;
reg  [8*lanes-1:0]               rx_sync_hdr_buf;
reg  [15*lanes-1:0]              iei_count;
reg  [16*lanes-1:0]              ts_shift_reg;
reg  [16*lanes-1:0]              rx_valid_buffer;
reg  [16*lanes-1:0]              rx_datak_buffer;
reg  [128*lanes-1:0]             rx_data_buffer;
reg  [pld_if_dw*lanes-1:0]       data_input;
reg  [pld_if_dw*lanes-1:0]       rx_data_pre_descramble;
reg  [words_pld_if*lanes-1:0]    rx_valid_scram_sync;

reg  [lanes-1:0]                 ts_one;
reg  [lanes-1:0]                 ts_two;
reg  [lanes-1:0]                 ts_one_prev;
reg  [lanes-1:0]                 ts_two_prev;
reg  [lanes-1:0]                 elec_idle_infer_reset;
reg  [lanes-1:0]                 descram_reset;
reg  [lanes-1:0]                 descram_advance;
reg  [lanes-1:0]                 rx_data_valid_sync;
reg  [lanes-1:0]                 rx_blk_start_sync;
reg  [lanes*2-1:0]               rx_sync_hdr_sync;
reg  [lanes*2-1:0]               block_align;
reg  [lanes*2-1:0]               lcl_rx_sync_hdr;
reg  [lanes*3-1:0]               block_decode;
reg  [lanes*4-1:0]               descram_en;
wire [lanes-1:0]                 channel_data_enable;
wire [lanes-1:0]                 channel_consecutive;
wire [lanes-1:0]                 inferred_elec_idle;
wire [15*lanes-1:0]              iei_timeout;
wire [16*lanes-1:0]              rx_datak_wire;
wire [16*lanes-1:0]              rx_valid_wire;
wire [128*lanes-1:0]             rx_data_wire;
wire [pld_if_dw*lanes-1:0]       rx_data_post_descramble;

assign ts_done = {(&channel_consecutive && &ts_two), (&channel_consecutive && &ts_one)};
assign rx_iei  = ((&inferred_elec_idle) && ~(|rx_valid));
//The time EIE timeout based upon the various pclk frequencies
assign iei_timeout = (fast_sim == "true") ? ((max_rate == "gen2" && rate == 2'b00 || max_rate == "gen3" && rate == 2'b01 || pld_if_dw == 16 && max_rate == "gen1") ?   23'd160 :
                                            ((max_rate == "gen3" && rate == 2'b00) ? 23'd80 : 23'd320)) :
                                            ((max_rate == "gen2" && rate == 2'b00 || max_rate == "gen3" && rate == 2'b01 || pld_if_dw == 16 && max_rate == "gen1") ?   23'd16000 :
                                            ((max_rate == "gen3" && rate == 2'b00) ? 23'd8000 : 23'd32000));




always@(posedge pclk or posedge reset) begin
  if(reset == 1'b1) begin
    rx_data_buffer    <= {128*lanes{1'b0}};
    rx_datak_buffer   <= {16*lanes{1'b0}};
    rx_valid_buffer   <= {16*lanes{1'b0}};
    ts_shift_reg      <= {16*lanes{1'b0}};
    rx_blk_start_buf  <= {4*lanes{1'b0}};
    rx_sync_hdr_buf   <= {8*lanes{1'b0}};
    sixth_sym         <= {lanes*8{1'b0}};
    count_consecutive <= {lanes*4{1'b0}};
    polarity          <= {lanes{1'b0}};
    ts_one            <= {lanes{1'b0}};
    ts_two            <= {lanes{1'b0}};
    ts_one_prev       <= {lanes{1'b0}};
    ts_two_prev       <= {lanes{1'b0}};
    lcl_rx_sync_hdr   <= {lanes{2'b0}};
    rx_data_valid_sync<= {lanes{1'b0}};
    data_input        <= {pld_if_dw*lanes{1'b0}};
    elec_idle_infer_reset <= {lanes{1'b0}};
  end else begin
    for(i=0;i<lanes;i=i+1) begin
      elec_idle_infer_reset[i]               <= 1'b0;
      rx_data_valid_sync[i]                  <= rx_data_valid[i];
      if(rx_valid[i] || (|rx_valid_buffer[16*i+:16] && inferred_elec_idle[i] == 1'b1 && rx_valid[i] == 1'b0)) begin
        //if we are in gen 1/2
        if(rate != 2'b10) begin
          rx_valid_buffer[16*i+:16]        <= {{words_pld_if{rx_valid[i]}}, rx_valid_buffer[(16*i+words_pld_if)+:(16-words_pld_if)]};
          rx_data_buffer[128*i+:128]       <= {rx_data[pld_if_dw*i+:pld_if_dw], rx_data_buffer[(128*i+pld_if_dw)+:(128-pld_if_dw)]};
          rx_datak_buffer[16*i+:16]        <= {rx_datak[words_pld_if*i+:words_pld_if], rx_datak_buffer[(16*i+words_pld_if)+:(16-words_pld_if)]};

          //check to seeeee if datak is high, meaning a control character
          if(rx_datak_wire[16*i] == 1'b1) begin
            if(rx_data_wire[128*i+:8] == k_com || rx_data_wire[128*i+:8] == ~k_com) begin
              //Can place a check on the second word to see what type of control sequence it is.
              //but for now, we assume it is a TS
              //handle the skip ordered set
              if(rx_data_wire[(128*i+8)+:24] == 24'h1C1C1C) begin
                ts_shift_reg[16*i+:16]      <= 16'h0008;
                elec_idle_infer_reset[i]    <= 1'b1;
              //Decode the EIEOS
              end else if(rx_data_wire[(128*i+8)+:24] == 24'hFCFCFC) begin
             //   ts_shift_reg[16*i+:16]      <= 16'h8000;
             //   elec_idle_infer_reset[i]    <= 1'b1;
              end else if(rx_data_wire[(128*i+8)+:16] == 16'h7C7C) begin
                ts_shift_reg[16*i+:16]      <= 16'h0008;
              end else begin
                ts_shift_reg[16*i+:16]      <= 16'h8000;
                sixth_sym[8*i+:8]           <= rx_data_wire[(128*i+48)+:8];
                ts_one_prev[i]              <= ts_one[i];
                ts_two_prev[i]              <= ts_two[i];
                if(sixth_sym[8*i+:8] == rx_data_wire[(128*i+48)+:8] && (ts_one_prev[i]== ts_one[i] || ts_two_prev[i] == ts_two[i])) begin 
                  count_consecutive[4*i+:4] <= (channel_consecutive[i]) ?  count_consecutive[4*i+:4] : count_consecutive[4*i+:4] + 1'b1;
                  ts_one[i]                 <= (rx_data_wire[(128*i+80)+:32] == {4{ts1_d_sym}} || rx_data_wire[(128*i+80)+:32] == ~{4{ts1_d_sym}});
                  ts_two[i]                 <= (rx_data_wire[(128*i+56)+:56] == {7{ts2_d_sym}} || rx_data_wire[(128*i+56)+:56] == ~{7{ts2_d_sym}});
                end else begin
                  count_consecutive[4*i+:4] <= 3'b0;
                  ts_one[i]                 <= 1'b0;
                  ts_two[i]                 <= 1'b0;
                end
                if(rx_data_wire[(128*i+80)+:32] == {4{ts1_d_sym}} || rx_data_wire[(128*i+56)+:56] == {7{ts2_d_sym}}) begin
                  polarity[i]               <= 1'b0;
                end else if(rx_data_wire[(128*i+80)+:32] == ~{4{ts1_d_sym}} || rx_data_wire[(128*i+56)+:56] == ~{7{ts2_d_sym}}) begin
                  polarity[i]               <= 1'b1;
                end
              end
            end else begin//in an else state meant, we can decode the various words of the TS or other sequences.  As of now, don't do anything
              ts_shift_reg[16*i+:16]        <= {{words_pld_if{1'b0}}, ts_shift_reg[(words_pld_if+16*i)+:(16-words_pld_if)]};
            end
          //if it is not high, then it is a data character, and we will go through data validation
          //maybe set a timeout to clear the buffer after receiving a TS1
          end else begin
            count_consecutive[4*i+:4]           <= (|ts_shift_reg[16*i+:16]) ? count_consecutive[4*i+:4] : 3'b0;
            ts_shift_reg[16*i+:16]              <= {{words_pld_if{1'b0}}, ts_shift_reg[(words_pld_if+16*i)+:(16-words_pld_if)]};
            data_input[i*pld_if_dw+:pld_if_dw]  <= rx_data_wire[128*i+:pld_if_dw];
          end
        //if we are in gen 3
        end else if(rx_data_valid_sync[i] == 0) begin
          //do nothing, recycle the values
          rx_valid_buffer[16*i+:16]       <= {rx_valid_scram_sync[i*words_pld_if+:words_pld_if], rx_valid_buffer[(16*i+words_pld_if)+:(16-words_pld_if)]};
        end else begin
          rx_valid_buffer[16*i+:16]       <= {rx_valid_scram_sync[i*words_pld_if+:words_pld_if], rx_valid_buffer[(16*i+words_pld_if)+:(16-words_pld_if)]};
          rx_data_buffer[128*i+:128]      <= {rx_data_post_descramble[pld_if_dw*i+:pld_if_dw], rx_data_buffer[(128*i+pld_if_dw)+:(128-pld_if_dw)]};
          rx_sync_hdr_buf[8*i+:8]         <= {rx_sync_hdr_sync[2*i+:2], rx_sync_hdr_buf[(8*i+2)+:6]};
          rx_blk_start_buf[4*i+:4]        <= {rx_blk_start_sync[i], rx_blk_start_buf[(4*i+1)+:3]};

          //check to see if we are receiving a control block
          //If this condition occurs, indicate an error
          if((rx_sync_hdr_buf[8*i+:2] == 2'b00 || rx_sync_hdr_buf[8*i+:2] == 2'b11) && rx_blk_start_buf[4*i] == 1'b1) begin
            lcl_rx_sync_hdr[2*i+:2]       <= 2'b11;
          end else if((rx_sync_hdr_buf[8*i+:2] == 2'b01 && rx_blk_start_buf[4*i] == 1'b1)) begin
            //for the rest of the packet, label it as part of the ordered set sync hdr
            lcl_rx_sync_hdr[2*i+:2]       <= 2'b01;

            //check to see if this packet is a training sequence
            if(rx_data_wire[128*i+:8] == ~g3_ts1_sym || rx_data_wire[128*i+:8] == ~g3_ts2_sym || rx_data_wire[128*i+:8] == g3_ts1_sym || rx_data_wire[128*i+:8] == g3_ts2_sym) begin
              sixth_sym[8*i+:8]           <= rx_data_wire[(128*i+48)+:8];
              ts_one_prev[i]              <= ts_one[i];
              ts_two_prev[i]              <= ts_two[i];
              if(sixth_sym[8*i+:8] == rx_data_wire[(128*i+48)+:8] && (ts_one_prev[i] == ts_one[i] || ts_two_prev[i] == ts_two[i])) begin
                count_consecutive[4*i+:4] <= (channel_consecutive[i]) ? count_consecutive[4*i+:4] : count_consecutive[4*i+:4] + 1'b1;
                ts_one[i]                 <= (rx_data_wire[(128*i+80)+:32] == {4{ts1_d_sym}} || rx_data_wire[(128*i+80)+:32] == ~{4{ts1_d_sym}});
                ts_two[i]                 <= (rx_data_wire[(128*i+56)+:56] == {7{ts2_d_sym}} || rx_data_wire[(128*i+56)+:56] == ~{7{ts2_d_sym}});
              end else begin
                count_consecutive[4*i+:4] <= 3'b0;
                ts_one[i]                 <= 1'b0;
                ts_two[i]                 <= 1'b0;
              end
            //  if(rx_data_wire[(128*i+80)+:32] == {4{ts1_d_sym}} || rx_data_wire[(128*i+56)+:56] == {7{ts2_d_sym}}) begin
            //    polarity[i]               <= 1'b0;
            //  end else if(rx_data_wire[(128*i+80)+:32] == ~{4{ts1_d_sym}} || rx_data_wire[(128*i+56)+:56] == ~{7{ts2_d_sym}}) begin
            //    polarity[i]               <= 1'b1;
            //  end else begin
            //    polarity[i]               <= polarity[i];
            //  end

            //Decode skip-ordered sets to reset the Electical Idle Inference Block
            end else if(rx_data_wire[128*i+:32] == 32'hAAAAAAAA && rx_data_wire[(128*(i+1)-32)+:32] == 32'hFF00FFE1) begin
              elec_idle_infer_reset[i]      <= 1'b1;
            //Decode Elec-idle Exit Ordered Sets
            end else if(rx_data_wire[128*i+:32] == 32'hFF00FF00 && rx_data_wire[(128*(i+1)-32)+:32] == 32'hFF00FF00) begin
           //   elec_idle_infer_reset[i]      <= 1'b1;
            end //in an else statement, we can decode the various control sequences.  As of now, don't do anything

          //If sync hdr is not 2'b01 at block start or we are already in a data block, then process the packet as part data
          end else if((rx_sync_hdr_buf[8*i+:2] == 2'b10 && rx_blk_start_buf[4*i] == 1'b1) || lcl_rx_sync_hdr[2*i+:2] == 2'b10) begin
            //do data decode
            //check the sync_hdr when you check the blk_start for a valid sync hdr
            count_consecutive[4*i+:4]         <= 4'b0;
            lcl_rx_sync_hdr[2*i+:2]           <= 2'b10;
            data_input[i*pld_if_dw+:pld_if_dw]<= rx_data_wire[128*i+:pld_if_dw];
          end
        end
      end else begin
        rx_data_buffer[i*128+:128]  <= rx_data_buffer[i*128+:128];
        rx_datak_buffer[i*16+:16]   <= rx_datak_buffer[i*16+:16];
        rx_valid_buffer[i*16+:16]   <= rx_valid_buffer[i*16+:16];
        data_input                  <= data_input;
        rx_data_valid_sync[i]       <= 1'b0;
        elec_idle_infer_reset[i]    <= 1'b0;
        ts_shift_reg[i*16+:16]      <= 16'b0;
        rx_blk_start_buf[i*4+:4]    <= 1'b0;
        rx_sync_hdr_buf[i*8+:8]     <= 1'b0;
        sixth_sym[i*8+:8]           <= 1'b0;
        count_consecutive[4*i+:4]   <= 1'b0;
        polarity[i]                 <= 1'b0;
        ts_one[i]                   <= 1'b0;
        ts_two[i]                   <= 1'b0;
        ts_one_prev[i]              <= 1'b0;
        ts_two_prev[i]              <= 1'b0;
        lcl_rx_sync_hdr[2*i+:2]     <= 2'b0;
      end
    end
  end
end


genvar b;
generate
  for(b=0; b<lanes;b=b+1) begin: generate_data_alignment
    assign channel_consecutive[b] = (count_consecutive[b*4+:4] == 4'd8) ? 1'b1 : 1'b0;
    
    if(words_pld_if == 4) begin: gen_32_pld_if_mux
     assign rx_data_wire[b*128+:128]   = (block_align[2*b+:2] == 2'b11) ? {rx_data[pld_if_dw*b+:24], rx_data_buffer[(128*b+24)+:104]} :
                                         (block_align[2*b+:2] == 2'b10) ? {rx_data[pld_if_dw*b+:16], rx_data_buffer[(128*b+16)+:112]} :
                                         (block_align[2*b+:2] == 2'b01) ? {rx_data[pld_if_dw*b+:8], rx_data_buffer[(128*b+8)+:120]} : rx_data_buffer[b*128+:128];
     assign rx_datak_wire[b*16+:16]    = (block_align[2*b+:2] == 2'b11) ? {rx_datak[words_pld_if*b+:3], rx_datak_buffer[(16*b+3)+:13]} :
                                         (block_align[2*b+:2] == 2'b10) ? {rx_datak[words_pld_if*b+:2], rx_datak_buffer[(16*b+2)+:14]} :
                                         (block_align[2*b+:2] == 2'b01) ? {rx_datak[words_pld_if*b], rx_datak_buffer[(16*b+1)+:15]} : rx_datak_buffer[b*16+:16];
     assign rx_valid_wire[b*16+:16]    = (block_align[2*b+:2] == 2'b11) ? {{3{rx_valid[b]}}, rx_valid_buffer[(16*b+3)+:13]} :
                                         (block_align[2*b+:2] == 2'b10) ? {{2{rx_valid[b]}}, rx_valid_buffer[(16*b+2)+:14]} :
                                         (block_align[2*b+:2] == 2'b01) ? {rx_valid[b], rx_valid_buffer[(16*b+1)+:15]} : rx_valid_buffer[b*16+:16];

      always@(posedge pclk or posedge reset) begin
        if(reset == 1'b1) begin
          block_align[2*b+:2]   <= 2'b00;
        end else if(rate == 2'b10) begin
          block_align[2*b+:2]   <= 2'b00;
        end else if((rx_data_buffer[(b*128)+:8] == k_com || rx_data_buffer[(b*128)+:8] == ~k_com) && rx_datak_buffer[16*b] == 1'b1) begin
          block_align[2*b+:2]   <= 2'b00;
        end else if((rx_data_buffer[(b*128+8)+:8] == k_com || rx_data_buffer[(b*128+8)+:8] == ~k_com) && rx_datak_buffer[16*b+1] == 1'b1) begin
          block_align[2*b+:2]   <= 2'b01;
        end else if((rx_data_buffer[(b*128+16)+:8] == k_com || rx_data_buffer[(b*128+16)+:8] == ~k_com) && rx_datak_buffer[16*b+2] == 1'b1) begin
          block_align[2*b+:2]   <= 2'b10;
        end else if((rx_data_buffer[(b*128+24)+:8] == k_com || rx_data_buffer[(b*128+24)+:8] == ~k_com) && rx_datak_buffer[16*b+3] == 1'b1) begin
          block_align[2*b+:2]   <= 2'b11;
        end else begin
          block_align[2*b+:2]   <= block_align[2*b+:2];
        end
      end
    end else if(words_pld_if == 2) begin: gen_16_pld_if_mux
      assign rx_data_wire[b*128+:128]   = (block_align[2*b+:2] == 2'b01) ? {rx_data[pld_if_dw*b+:8], rx_data_buffer[(128*b+8)+:120]} : rx_data_buffer[b*128+:128];
      assign rx_datak_wire[b*16+:16]    = (block_align[2*b+:2] == 2'b01) ? {rx_datak[words_pld_if*b], rx_datak_buffer[(16*b+1)+:15]} : rx_datak_buffer[b*16+:16];
      assign rx_valid_wire[b*16+:16]    = (block_align[2*b+:2] == 2'b01) ? {rx_valid, rx_valid_buffer[(16*b+1)+:15]} : rx_valid_buffer[b*16+:16];

      always@(posedge pclk or posedge reset) begin
        if(reset == 1'b1) begin
          block_align[2*b+:2]   <= 2'b00;
        end else if(rate == 2'b10) begin
          block_align[2*b+:2]   <= 2'b00;
        end else if((rx_data_buffer[(b*128)+:8] == k_com || rx_data_buffer[(b*128)+:8] == ~k_com) && rx_datak_buffer[16*b] == 1'b1)begin
          block_align[2*b+:2]   <= 2'b00;
        end else if((rx_data_buffer[(b*128+8)+:8] == k_com || rx_data_buffer[(b*128+8)+:8] == ~k_com) && rx_datak_buffer[16*b+1] == 1'b1)begin
          block_align[2*b+:2]   <= 2'b01;
        end else begin
          block_align[2*b+:2]   <= block_align[2*b+:2];
        end
      end
    end else begin: gen_no_pld_if_mux
      assign rx_data_wire[b*128+:128]   = rx_data_buffer[b*128+:128];
      assign rx_datak_wire[b*16+:16]    = rx_datak_buffer[b*16+:16];
      assign rx_valid_wire[b*16+:16]    = rx_valid_buffer[b*16+:16];
    end //end generating the various muxes for block alignment
    
    assign inferred_elec_idle[b] = (iei_count >= iei_timeout);
    always@(posedge pclk or posedge reset) begin
      if(reset == 1'b1) begin
        iei_count[15*b+:15]     <= 15'b0;
      end else if(elec_idle_infer_reset[b] == 1'b1) begin
        iei_count[15*b+:15]     <= 15'b0;
      end else if(inferred_elec_idle[b] == 1'b1) begin
        iei_count[15*b+:15]     <= 15'h7FFF; 
      end else begin
        iei_count[15*b+:15]     <= iei_count[15*b+:15] + 1'b1;
      end
    end

    always@(posedge pclk or posedge reset) begin
      if(reset == 1'b1) begin
        block_decode[3*b+:3]      <= 3'b001; //EIEOS
        descram_reset[b]          <= 1'b1;
        descram_advance[b]        <= 1'b0;  
        descram_en[b*4+:4]        <= 4'b0;
        rx_blk_start_sync[b]      <= 1'b0;
        rx_sync_hdr_sync[b*2+:2]  <= 2'b00;
        rx_data_pre_descramble[pld_if_dw*b+:pld_if_dw]    <= {pld_if_dw{1'b0}};
        rx_valid_scram_sync[words_pld_if*b+:words_pld_if] <= {words_pld_if{1'b0}};
      end else if(rx_data_valid[b] == 1'b0 || rx_valid[b] == 1'b0) begin
        descram_advance[b]        <= 1'b0;  
        rx_valid_scram_sync[words_pld_if*b+:words_pld_if] <= {words_pld_if{rx_valid[b]}};
      end else begin
        rx_blk_start_sync[b]      <= rx_blk_start[b];
        rx_sync_hdr_sync[b*2+:2]  <= rx_sync_hdr[b*2+:2];
        rx_data_pre_descramble[pld_if_dw*b+:pld_if_dw]    <= rx_data[b*pld_if_dw+:pld_if_dw];
        rx_valid_scram_sync[words_pld_if*b+:words_pld_if] <= {words_pld_if{rx_valid[b]}};
        if(rx_blk_start[b] == 1'b1) begin
          if(rx_sync_hdr[2*b+:2] == 2'b01) begin
            if(rx_data[pld_if_dw*b+:pld_if_dw] == 32'hFF00FF00) begin
              block_decode[3*b+:3]<= 3'b001; //EIEOS
              descram_reset[b]    <= 1'b1;
              descram_advance[b]  <= 1'b0;  
              descram_en[b*4+:4]  <= 4'b0;
            end else if(rx_data[pld_if_dw*b+:pld_if_dw] == 32'hAAAAAAAA) begin
              block_decode[3*b+:3]<= 3'b010; //SKP
              descram_reset[b]    <= 1'b0;
              descram_advance[b]  <= 1'b0;  
              descram_en[b*4+:4]  <= 4'b0;
            end else if(rx_data[pld_if_dw*b+:pld_if_dw] == 32'h66666666) begin
              block_decode[3*b+:3]<= 3'b011; //EIOS
              descram_reset[b]    <= 1'b0;
              descram_advance[b]  <= 1'h1;  
              descram_en[b*4+:4]  <= 4'b0;
            end else if(rx_data[pld_if_dw*b+:pld_if_dw] == 32'h555555E1) begin
              block_decode[3*b+:3]        <= 3'b100; //SDS
              descram_reset[b]    <= 1'b0;
              descram_advance[b]  <= 1'h1;  
              descram_en[b*4+:4]  <= 4'b0;
            end else if(rx_data[pld_if_dw*b+:8] == 8'h1E) begin
              block_decode[3*b+:3]<= 3'b101; //TS1
              descram_reset[b]    <= 1'b0;
              descram_advance[b]  <= 1'h1;  
              descram_en[b*4+:4]  <= 4'hE;
            end else if(rx_data[pld_if_dw*b+:8] == 8'h2D) begin
              block_decode[3*b+:3]<= 3'b110; //TS2
              descram_reset[b]    <= 1'b0;
              descram_advance[b]  <= 1'h1;  
              descram_en[b*4+:4]  <= 4'hE;
            end else begin
              block_decode[3*b+:3]<= 3'b000; //Data
              descram_reset[b]    <= 1'b0;
              descram_advance[b]  <= 1'h0;  
              descram_en[b*4+:4]  <= 4'hF;
            end
          end else begin
            block_decode[3*b+:3]  <= 3'b000; //Data
            descram_reset[b]      <= 1'b0;
            descram_advance[b]    <= 1'h1;  
            descram_en[b*4+:4]    <= 4'hF;
          end
        end else begin
          case(block_decode[3*b+:3])
            3'b000: begin
              descram_reset[b]      <= 1'b0;
              descram_advance[b]    <= 1'h1;  
              descram_en[b*4+:4]    <= 4'hF;
            end

            3'b001: begin
              descram_reset[b]      <= 1'b0;
              descram_advance[b]    <= 1'h0;  
              descram_en[b*4+:4]    <= 4'h0;
            end

            3'b010: begin
              descram_reset[b]      <= 1'b0;
              descram_advance[b]    <= 1'h0;  
              descram_en[b*4+:4]    <= 4'h0;
            end

            3'b011: begin
              descram_reset[b]      <= 1'b0;
              descram_advance[b]    <= 1'h1;  
              descram_en[b*4+:4]    <= 4'h0;
            end

            3'b100: begin
              descram_reset[b]      <= 1'b0;
              descram_advance[b]    <= 1'h1;  
              descram_en[b*4+:4]    <= 4'h0;
            end

            3'b101: begin
              descram_reset[b]      <= 1'b0;
              descram_advance[b]    <= 1'h1;  
              descram_en[b*4+:4]    <= 4'hF;
            end

            3'b110: begin
              descram_reset[b]      <= 1'b0;
              descram_advance[b]    <= 1'h1;  
              descram_en[b*4+:4]    <= 4'hF;
            end

            default: begin
              descram_reset[b]      <= 1'b0;
              descram_advance[b]    <= 1'h1;  
              descram_en[b*4+:4]    <= 4'hF;
            end
          endcase
        end
      end
    end

    //descrambler
    pipe_scrambler #(
      .words_pld_if            (words_pld_if),
      .pld_if_dw               (pld_if_dw)
    ) descrambler (
      .pclk                    (pclk),
      .reset                   (reset),
      .reset_scrambler         (descram_reset[b]),
      .advance_scrambler       (descram_advance[b]),
      .lane_number             (3'b0),
      .scramble_data_en        (descram_en[b*4+:4]),
      .data_in                 (rx_data_pre_descramble[pld_if_dw*b+:pld_if_dw]),
      .data_out                (rx_data_post_descramble[pld_if_dw*b+:pld_if_dw])
    );


//    assign channel_data_enable[b] = (rate == 2'b10) ? (rx_valid[b] == 1'b1 && rx_data_valid[b] == 1'b1 && lcl_rx_sync_hdr[2*b+:2] == 2'b10) : (rx_syncstatus[b] == 1'b1  && rx_valid[b] == 1'b1 && (|(ts_shift_reg[16*b+:16])) == 1'b0);
    assign channel_data_enable[b] = (rate == 2'b10) ? ((rx_valid[b] == 1'b1 && (&rx_valid_wire[16*b+:words_pld_if]) == 1'b1 && rx_data_valid_sync[b] == 1'b1 && lcl_rx_sync_hdr[2*b+:2] == 2'b10) || ((&rx_valid_wire[16*b+:words_pld_if]) == 1'b1 && rx_valid[b] == 1'b0 && inferred_elec_idle[b] == 1'b1 && lcl_rx_sync_hdr[2*b+:2] == 2'b10)) : 
                                                      ((rx_valid[b] == 1'b1 && (&rx_valid_wire[16*b+:words_pld_if]) == 1'b1 && (|(ts_shift_reg[16*b+:16])) == 1'b0 && (ts_one[b] || ts_two[b])) || ((|rx_valid_wire[16*b+:words_pld_if]) == 1'b1 && rx_valid[b] == 1'b0 && inferred_elec_idle[b] == 1'b1 && (|ts_shift_reg[16*b+:16]) == 1'b0));

    pattern_ver pattern_checker (
      .clk                     (pclk),
      .reset                   (reset),
      .start                   (channel_data_enable[b]),
      .data_in                 (data_input[b*pld_if_dw+:pld_if_dw]),
      .lock                    (),
      .error_flag              (errors[b])
    );

  end
endgenerate

endmodule 
