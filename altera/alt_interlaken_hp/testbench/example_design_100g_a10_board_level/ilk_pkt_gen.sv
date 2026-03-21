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


// Interlaken Packets Generator

`timescale 1ps/1ps

module ilk_pkt_gen #(
   parameter INTERNAL_WORDS = 8,
   parameter TX_PKTMOD_ONLY = 1,
   parameter LOG_INTE_WORDS = (INTERNAL_WORDS == 8) ? 4 : 3,
   parameter CALENDAR_PAGES = 4
)(
   input                              clk,
   input                              rx_lanes_aligned,
   input                              itx_ready,
   input                              send_data,
   input                              reconfig_done,
   input                              tx_usr_srst,
   
   output  reg [INTERNAL_WORDS-1:0][63:0]   tx_data,
   output  reg [3:0]                        tx_valid,
   output  reg [7:0]                        tx_chan,
   output  reg                              tx_sop,
   output  reg [3:0]                        tx_eopbits,
   output  reg                              tx_sob,
   output  reg                              tx_eob, 
   output  reg [31:0]                       tx_sop_cnt,
   output  reg [31:0]                       tx_eop_cnt
);

   generate
     if (TX_PKTMOD_ONLY) begin
        assign tx_sob = 2'b00;
        assign tx_eob = 1'b0;
     end else begin
        assign tx_sob = tx_sop;
        assign tx_eob = |tx_eopbits;
     end
   endgenerate
   
  localparam [2:0]    GEN_IDLE    = 3'h0;
  localparam [2:0]    GEN_SOP     = 3'h1;
  localparam [2:0]    GEN_PAYLOAD = 3'h2;
  localparam [2:0]    GEN_EOP     = 3'h3;
  localparam [2:0]    GEN_DONE    = 3'h4;

  wire tx_ready; 
  assign tx_ready  = itx_ready && rx_lanes_aligned && send_data && reconfig_done; 
  
  reg [2:0] nxt_state;
  reg [2:0] state;
  reg       tx_sop_nxt; 
  reg [3:0] tx_eopbits_nxt;

  reg [5:0] pkt_payload_content; 
  reg [5:0] pkt_payload_cnt; 
  reg [6:0] pkt_cnt; 

  always @(posedge clk) begin
    if (tx_usr_srst) begin
      pkt_payload_content <= 6'h0;
    end else if (tx_ready) begin
      if (nxt_state == GEN_SOP | nxt_state == GEN_PAYLOAD | nxt_state == GEN_EOP) begin 
        pkt_payload_content <= pkt_payload_content + 1'b1;
      end
    end
  end

  always @(posedge clk) begin
    if (tx_usr_srst) begin
      pkt_payload_cnt <= 6'h0;
      pkt_cnt         <= 7'h0;
    end else if (tx_ready) begin
      if (nxt_state == GEN_SOP) begin 
        pkt_cnt         <= pkt_cnt + 1'b1;
        pkt_payload_cnt <= 6'h0;
      end else if (nxt_state == GEN_PAYLOAD) begin
        pkt_payload_cnt <= pkt_payload_cnt + 1'b1;
      end 
    end
  end

  always @(posedge clk) begin
    if (tx_usr_srst) begin
      state          <= GEN_IDLE;
    end else begin
      state          <= nxt_state;
    end
  end

  wire stop_payload;
  assign stop_payload = (INTERNAL_WORDS == 8) ? (pkt_payload_cnt == 2 ) : (pkt_payload_cnt == 6 );
 
  reg [3:0] tx_valid_nxt;

  always @* begin
    nxt_state         = state;
    tx_sop_nxt        = tx_sop; 
    tx_eopbits_nxt    = {4{1'b0}}; 
    tx_valid_nxt      = 4'b0;
    case (state)
        GEN_IDLE : begin
          if (tx_ready) begin
            nxt_state         = GEN_SOP;
            tx_sop_nxt        = 1'b1;
            tx_valid_nxt      = 4'b1000;
          end 
        end
        GEN_SOP : begin
          if (tx_ready) begin
            nxt_state         = GEN_PAYLOAD;
            tx_sop_nxt        = {1'b0};
            tx_valid_nxt      = 4'b1000;
          end 
        end
        GEN_PAYLOAD : begin
          if (tx_ready) begin
            if (stop_payload) begin
              nxt_state         = GEN_EOP;
              tx_eopbits_nxt    = 4'b1000; 
            end
            tx_valid_nxt      = 4'b1000;
          end 
        end
        GEN_EOP : begin
          if (tx_ready) begin
            if (stop_payload) begin
              if (pkt_cnt != 7'd100) begin
                nxt_state         = GEN_SOP;
                tx_sop_nxt        = 1'b1;
                tx_valid_nxt      = 4'b1000;
              end else begin
                nxt_state         = GEN_DONE;
              end
            end
          end 
        end
        default: begin
          nxt_state         = state;
          tx_sop_nxt        = tx_sop; 
        end
    endcase
  end
 
  always @(posedge clk) begin
    if (tx_usr_srst) begin
      tx_valid  <= 4'b0;
    end begin
      tx_valid  <= tx_valid_nxt;
    end
  end

  assign tx_chan = {1'b0,pkt_cnt[6:0]};

  always @(posedge clk) begin
    if (tx_usr_srst) begin
      tx_sop      <= {1'b0};
      tx_eopbits  <= {4{1'b0}};
    end else begin
      tx_sop      <= tx_sop_nxt;
      tx_eopbits  <= tx_eopbits_nxt;
    end
  end

  wire [7:0] payload_byte = {2'b0, pkt_payload_content};
  wire [63:0] payload_word = {8{payload_byte}};
  assign tx_data = {INTERNAL_WORDS{payload_word}};

   localparam MAX_NUM_VALID = (INTERNAL_WORDS == 8) ? 4'h8 : 3'h4;

   // Counters
   always @(posedge clk or posedge tx_usr_srst) begin
      if (tx_usr_srst) begin
         tx_sop_cnt <= 32'h0;
         tx_eop_cnt <= 32'h0;
      end
      else begin
        if (tx_sop && |tx_valid) begin
            tx_sop_cnt <= tx_sop_cnt + 1'b1;
         end

         if (tx_eopbits[3] && |tx_valid) begin
            tx_eop_cnt <= tx_eop_cnt + 1'b1;
         end
      end
   end

endmodule
