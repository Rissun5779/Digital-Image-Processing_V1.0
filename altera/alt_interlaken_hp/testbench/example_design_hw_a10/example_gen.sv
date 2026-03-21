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


module example_gen #(
  parameter DEVICE_FAMILY        = "Arria 10",   // Stratix V or Arria 10 
  parameter TX_CREDIT_LATENCY    = 4,           // latency between tx_credit and tx_valid
  parameter INTERNAL_WORDS       = 8,           // number of segment (words) in the user interface
  parameter CALENDAR_PAGES       = 1            // number of inband flow control 16-bit calendar pages
)(
  output  reg [3:0]                        tx_valid,
  output  reg                              tx_sop,
  output  reg [3:0]                        tx_eopbits,
  output  reg [7:0]                        tx_chan,
  output  reg [INTERNAL_WORDS-1:0][63:0]   tx_data,
  output  reg [CALENDAR_PAGES*16-1:0]      tx_calendar,

  input                                    tx_ready,
  input                                    tx_clk,          //user clock domain
  input                                    tx_srst        
);

  localparam [2:0]    GEN_IDLE    = 3'h0;
  localparam [2:0]    GEN_SOP     = 3'h1;
  localparam [2:0]    GEN_PAYLOAD = 3'h2;
  localparam [2:0]    GEN_EOP     = 3'h3;
  localparam [2:0]    GEN_DONE    = 3'h4;

  reg [2:0] nxt_state;
  reg [2:0] state;
  reg       tx_sop_nxt; 
  reg [3:0] tx_eopbits_nxt;

  reg [5:0] pkt_payload_content; 
  reg [5:0] pkt_payload_cnt; 
  reg [6:0] pkt_cnt; 

  assign tx_calendar = {CALENDAR_PAGES*16{1'b0}};

  always @(posedge tx_clk) begin
    if (tx_srst) begin
      pkt_payload_content <= 6'h0;
    end else if (tx_ready) begin
      if (nxt_state == GEN_SOP | nxt_state == GEN_PAYLOAD | nxt_state == GEN_EOP) begin 
        pkt_payload_content <= pkt_payload_content + 1'b1;
      end
    end
  end

  always @(posedge tx_clk) begin
    if (tx_srst) begin
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

  always @(posedge tx_clk) begin
    if (tx_srst) begin
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
 
  always @(posedge tx_clk) begin
    if (tx_srst) begin
      tx_valid  <= 4'b0;
    end begin
      tx_valid  <= tx_valid_nxt;
    end
  end

  assign tx_chan = {1'b0,pkt_cnt[6:0]};

  always @(posedge tx_clk) begin
    if (tx_srst) begin
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

endmodule
