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


module example_chk #(
  parameter NUM_LANES            = 12,            // number of lanes
  parameter INTERNAL_WORDS       = 4,             // number of segment (words) in the user interface
  parameter CALENDAR_PAGES       = 1              // number of inband flow control 16-bit calendar pages
)(
  // RX User Interface
  input [3:0]                         rx_valid,
  input                               rx_sop,
  input [4-1:0]                       rx_eopbits,
  input [8-1:0]                       rx_chan,
  input [INTERNAL_WORDS-1:0][64-1:0]  rx_data,
  input [16-1:0]                      rx_calendar,

  // Miscellaneous signals
  input                               rx_crc24_err,
  input [NUM_LANES-1:0]               rx_crc32_err,

  output  reg                         test_failed_n,      
  output  reg                         test_success_n,      
  output  reg                         test_done_n,      

  input                               rx_clk,          //user clock domain
  input                               rx_srst        
);

  localparam [2:0]    IDLE    = 3'h0;
  localparam [2:0]    SOP     = 3'h1;
  localparam [2:0]    PAYLOAD = 3'h2;
  localparam [2:0]    EOP     = 3'h3;
  localparam [2:0]    DONE    = 3'h4;

  reg [2:0]                      nxt_state;
  reg [2:0]                      state;
  reg [3:0]                      rcvd_valid;
  reg                            sop_nxt; 
  reg                            sop; 
  reg                            rcvd_sop; 
  reg [4-1:0]                    eopbits_nxt;
  reg [4-1:0]                    eopbits;
  reg [4-1:0]                    rcvd_eopbits;
  reg [INTERNAL_WORDS-1:0][63:0] data; 
  reg [INTERNAL_WORDS-1:0][63:0] rcvd_data; 
  reg [16-1:0]                   calendar;
  reg [16-1:0]                   rcvd_calendar;
  reg [7:0]                      rcvd_chan;
  reg                            crc24_err;
  reg                            crc32_err;

  reg [5:0] pkt_payload_content; 
  reg [5:0] pkt_payload_cnt; 
  reg [6:0] pkt_cnt; 

  always @(posedge rx_clk) begin
    if (rx_srst) begin
      pkt_payload_content <= 6'h0;
    end else if (rx_valid[3]) begin
      if (nxt_state == SOP | nxt_state == PAYLOAD | nxt_state == EOP) begin 
        pkt_payload_content <= pkt_payload_content + 1'b1;
      end
    end
  end

  always @(posedge rx_clk) begin
    if (rx_srst) begin
      pkt_payload_cnt <= 6'h0;
      pkt_cnt         <= 7'h0;
    end else if (rx_valid[3]) begin
      if (nxt_state == SOP) begin 
        pkt_cnt         <= pkt_cnt + 1'b1;
        pkt_payload_cnt <= 6'h0;
      end else if (nxt_state == PAYLOAD) begin
        pkt_payload_cnt <= pkt_payload_cnt + 1'b1;
      end 
    end
  end

  always @(posedge rx_clk) begin
    if (rx_srst) begin
      state          <= IDLE;
    end else begin
      state          <= nxt_state;
    end
  end

  reg stop_payload;
  assign stop_payload = (INTERNAL_WORDS == 8) ? (pkt_payload_cnt == 2 ) : (pkt_payload_cnt == 6 );

  always @* begin
    nxt_state      = state;
    sop_nxt        = sop; 
    eopbits_nxt    = {4{1'b0}}; 
    case (state)
        IDLE : begin
          if (rx_valid[3]) begin
            if (rx_sop) begin                        //we need rx_sop to bring state machine into 
                                                     //sop state the very first time
              nxt_state      = SOP;
              sop_nxt        = 1'b1;
            end
          end 
        end
        SOP : begin
          if (rx_valid[3]) begin
            nxt_state      = PAYLOAD;
            sop_nxt        = 1'b0;
          end 
        end
        PAYLOAD : begin
          if (rx_valid[3]) begin
            if (stop_payload) begin
              nxt_state      = EOP;
              eopbits_nxt    = 4'b1000; 
            end
          end 
        end
        EOP : begin
          nxt_state = DONE;
          if (rx_valid[3]) begin
            if (stop_payload) begin
              if (pkt_cnt != 7'd100) begin
                nxt_state      = SOP;
                sop_nxt        = 1'b1;
              end 
            end
          end 
        end
        default: begin
          nxt_state      = state;
          sop_nxt        = sop; 
          eopbits_nxt    = {4{1'b0}}; 
        end
    endcase
  end
  
  always @(posedge rx_clk) begin
    if (rx_srst) begin
      sop       <= 1'b0;
      eopbits   <= {4{1'b0}};
      calendar  <= {16{1'b0}};
      crc24_err <= 1'b0;
      crc32_err <= 1'b0;
    end else begin
      sop       <= sop_nxt;
      eopbits   <= eopbits_nxt;
      calendar  <= {CALENDAR_PAGES*16{1'b1}};
      crc24_err <= rx_crc24_err;
      crc32_err <= |rx_crc32_err;
    end
  end

genvar i;
generate
for(i=0;i<INTERNAL_WORDS;i=i+1) begin : data_gen
  assign data[i] = {8{2'b0, pkt_payload_content}};
end
endgenerate

  always @(posedge rx_clk) begin
    if (rx_srst) begin
      rcvd_valid    <= 4'b0;
      rcvd_sop      <= 1'b0;
      rcvd_eopbits  <= {4{1'b0}};
      rcvd_chan     <= {8{1'b0}};
      rcvd_data     <= {INTERNAL_WORDS*64{1'b0}};
      rcvd_calendar <= {16{1'b0}};
    end else begin
      rcvd_valid    <= rx_valid;
      rcvd_sop      <= rx_sop;
      rcvd_eopbits  <= rx_eopbits;
      rcvd_chan     <= rx_chan;
      rcvd_data     <= rx_data;
      rcvd_calendar <= rx_calendar;
    end
  end

  reg sop_err; 
  reg eopbits_err; 
  reg chan_err; 
  reg data_err; 
  reg data_err_nxt; 
  reg valid_err; 
  
  always @(posedge rx_clk) begin
    if (rx_srst) begin
      chan_err      <= 1'b0; 
      sop_err       <= 1'b0; 
      eopbits_err   <= 1'b0; 
      chan_err      <= 1'b0; 
      data_err      <= 1'b0; 
      valid_err     <= 1'b0; 
    end else begin
      data_err      <= data_err_nxt ? 1'b1 : data_err; 
      if (rcvd_valid[3]) begin            // stiky flag
        sop_err       <= (rcvd_sop != sop)           ? 1'b1 : sop_err; 
        eopbits_err   <= (rcvd_eopbits != eopbits)   ? 1'b1 : eopbits_err; 
        if (rcvd_sop) begin
          chan_err      <= (rcvd_chan != {1'b0,pkt_cnt[6:0]}) ? 1'b1 : chan_err; 
        end
      end
      if (|rcvd_valid) begin            // stiky flag
        valid_err <= (rcvd_valid != 4'b1000);
      end
    end
  end

  always @(posedge rx_clk) begin
    if (rx_srst) begin
      test_done_n    <= 1'b1;
      test_failed_n  <= 1'b1;
      test_success_n <= 1'b1;
    end else if (state == DONE) begin
      test_done_n    <= 1'b0;
      test_failed_n  <= ~(data_err | sop_err | eopbits_err | chan_err | crc24_err | crc32_err | valid_err);
      test_success_n <=  (data_err | sop_err | eopbits_err | chan_err | crc24_err | crc32_err | valid_err);
    end
  end

  always @* begin
    data_err_nxt = rcvd_valid[3] ? (rcvd_data != data) : 1'b0;
  end 
 
endmodule
