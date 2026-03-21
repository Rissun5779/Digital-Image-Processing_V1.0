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


// Interlaken Packet Checker

`timescale 1ps/1ps

module ilk_pkt_checker #(
   parameter SIM_FAKE_JTAG      = 1'b0,
   parameter TX_PKTMOD_ONLY     = 1,
   parameter INTERNAL_WORDS     = 8,
   parameter LOG_INTERNAL_WORDS = (INTERNAL_WORDS == 8) ? 4 : 3,
   parameter DUAL               = (INTERNAL_WORDS == 4 ) ? 1 : 2,
   parameter NUM_LANES          = 24,
   parameter CALENDAR_PAGES     = 4
)(
   input                                 clk,
   input                                 clk_rx_common,
   input                                 clk_tx_common,
                                         
   input                                 srst_rx_common,
   input                                 srst_tx_common,
   input                                 tx_usr_srst,
   input                                 rx_usr_srst,
   input                                 error_clear,
                                         
   input                                 rx_lanes_aligned,
   input [64*INTERNAL_WORDS-1:0]         rx_data,
   input [LOG_INTERNAL_WORDS*DUAL-1:0]   rx_valid,
   input [DUAL-1:0]                      rx_sop,
   input [DUAL-1:0]                      rx_sob,
   input                   [7:0]         rx_chan,
   input                   [3:0]         rx_eopbits,
   input [CALENDAR_PAGES*16-1:0]         rx_calendar,
                                         
   input         [NUM_LANES-1:0]         rx_crc32_err,
   input                                 rx_crc24_err,
                                         
   input                                 sop_cntr_inc,
   input                                 eop_cntr_inc,
                                         
   input                                 itx_overflow,
   input                                 itx_underflow,
   input                                 irx_overflow,
   input                                 rdc_overflow,
                                         
   output reg             [31:0]         sop_cntr,
   output reg             [31:0]         eop_cntr,
   output reg  [NUM_LANES*8-1:0]         crc32_err_cnt,
   output reg             [15:0]         crc24_err_cnt,
   output reg              [3:0]         checker_errors,
   output reg             [31:0]         err_cnt,
   output reg                            itx_overflow_sticky,
   output reg                            itx_underflow_sticky,
   output reg                            irx_overflow_sticky,
   output reg                            rdc_overflow_sticky,
   input wire                            err_read
);
  localparam [2:0]    IDLE    = 3'h0;
  localparam [2:0]    SOP     = 3'h1;
  localparam [2:0]    PAYLOAD = 3'h2;
  localparam [2:0]    EOP     = 3'h3;
  localparam [2:0]    DONE    = 3'h4;
  
  localparam [2:0]    MSB     = (INTERNAL_WORDS == 4 ) ? 2 : 7;

  reg [2:0]                          nxt_state;
  reg [2:0]                          state;
  reg [LOG_INTERNAL_WORDS*DUAL-1:0]  rcvd_valid;
  reg                                sop_nxt; 
  reg                                sop; 
  reg                                rcvd_sop; 
  reg [4-1:0]                        eopbits_nxt;
  reg [4-1:0]                        eopbits;
  reg [4-1:0]                        rcvd_eopbits;
  reg [INTERNAL_WORDS-1:0][63:0]     data; 
  reg [INTERNAL_WORDS-1:0][63:0]     rcvd_data; 
  reg [16-1:0]                       calendar;
  reg [16-1:0]                       rcvd_calendar;
  reg [7:0]                          rcvd_chan;
  reg                                crc24_err;
  reg                                crc32_err;

  reg [5:0] pkt_payload_content; 
  reg [5:0] pkt_payload_cnt; 
  reg [6:0] pkt_cnt; 

  always @(posedge clk) begin
    if (rx_usr_srst) begin
      pkt_payload_content <= 6'h0;
    end else if (rx_valid[MSB]) begin
      if (nxt_state == SOP | nxt_state == PAYLOAD | nxt_state == EOP) begin 
        pkt_payload_content <= pkt_payload_content + 1'b1;
      end
    end
  end

  always @(posedge clk) begin
    if (rx_usr_srst) begin
      pkt_payload_cnt <= 6'h0;
      pkt_cnt         <= 7'h0;
    end else if (rx_valid[MSB]) begin
      if (nxt_state == SOP) begin 
        pkt_cnt         <= pkt_cnt + 1'b1;
        pkt_payload_cnt <= 6'h0;
      end else if (nxt_state == PAYLOAD) begin
        pkt_payload_cnt <= pkt_payload_cnt + 1'b1;
      end 
    end
  end

  always @(posedge clk) begin
    if (rx_usr_srst) begin
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
          if (rx_valid[MSB]) begin
            if (rx_sop) begin                        //we need rx_sop to bring state machine into 
                                                     //sop state the very first time
              nxt_state      = SOP;
              sop_nxt        = 1'b1;
            end
          end 
        end
        SOP : begin
          if (rx_valid[MSB]) begin
            nxt_state      = PAYLOAD;
            sop_nxt        = 1'b0;
          end 
        end
        PAYLOAD : begin
          if (rx_valid[MSB]) begin
            if (stop_payload) begin
              nxt_state      = EOP;
              eopbits_nxt    = 4'b1000; 
            end
          end 
        end

        EOP : begin
          if (pkt_cnt == 7'd100) begin
            nxt_state = DONE;
          end else if (rx_valid[MSB]) begin
            if (stop_payload) begin
              nxt_state      = SOP;
              sop_nxt        = 1'b1;
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
  
  always @(posedge clk) begin
    if (rx_usr_srst) begin
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

  always @(posedge clk) begin
    if (rx_usr_srst) begin
      rcvd_valid    <= {(LOG_INTERNAL_WORDS*DUAL){1'b0}};
      rcvd_sop      <= {DUAL{1'b0}};
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
  
  always @(posedge clk) begin
    if (rx_usr_srst) begin
      chan_err      <= 1'b0; 
      sop_err       <= 1'b0; 
      eopbits_err   <= 1'b0; 
      chan_err      <= 1'b0; 
      data_err      <= 1'b0; 
      valid_err     <= 1'b0;
      err_cnt        <= 32'h0;
      checker_errors <= 4'h0;	  
    end else begin
      data_err      <= data_err_nxt ? 1'b1 : data_err; 
      if (rcvd_valid[MSB]) begin            // stiky flag
        sop_err       <= (rcvd_sop != sop)           ? 1'b1 : sop_err; 
        eopbits_err   <= (rcvd_eopbits != eopbits)   ? 1'b1 : eopbits_err; 
        if (rcvd_sop) begin
          chan_err      <= (rcvd_chan != {1'b0,pkt_cnt[6:0]}) ? 1'b1 : chan_err; 
        end
      end
      if (|rcvd_valid) begin            // stiky flag
        valid_err <= (rcvd_valid != 4'b1000);
      end
	  ///// count errors ///////////////
	   if (sop_err || chan_err || data_err || eopbits_err) begin
         err_cnt <= err_cnt + 1'b1;
         // // synthesis translate_off
         // $display("TEST FAILED!");
         // #100000
         // $finish;
         // // synthesis translate_on
       end

       if (err_read) begin
          checker_errors <= 4'h0;
       end
       else if (sop_err || chan_err || data_err || eopbits_err) begin
          checker_errors <= {sop_err, chan_err, data_err, eopbits_err};
       end
	  ////////////////////////////////////
	  
	  
    end
  end

  // always @(posedge clk) begin
    // if (rx_usr_srst) begin
      // test_done_n    <= 1'b1;
      // test_failed_n  <= 1'b1;
      // test_success_n <= 1'b1;
    // end else if (state == DONE) begin
      // test_done_n    <= 1'b0;
      // test_failed_n  <= ~(data_err | sop_err | eopbits_err | chan_err | crc24_err | crc32_err | valid_err);
      // test_success_n <=  (data_err | sop_err | eopbits_err | chan_err | crc24_err | crc32_err | valid_err);
    // end
  // end

  always @* begin
    data_err_nxt = rcvd_valid[3] ? (rcvd_data != data) : 1'b0;
  end 

   // cursory check for sop, eop
   reg [31:0] sop_cntr_r;
   reg [31:0] eop_cntr_r;
   localparam MAX_NUM_VALID = (INTERNAL_WORDS == 8) ? 4'h8 : 3'h4;
   
      // Counters
   always @(posedge clk or posedge rx_usr_srst) begin
      if (rx_usr_srst) begin
         sop_cntr_r <= 32'h0;
         eop_cntr_r <= 32'h0;
      end else if (error_clear)begin
	     sop_cntr_r <= 32'h0;
         eop_cntr_r <= 32'h0;
	  end
      else begin
        if (rx_sop && |rx_valid && rx_lanes_aligned) begin
            sop_cntr_r <= sop_cntr_r + 1'b1;
         end

         if (rx_eopbits[3] && |rx_valid  && rx_lanes_aligned) begin
            eop_cntr_r <= eop_cntr_r + 1'b1;
         end
      end
   end

   always @(posedge clk) begin
      sop_cntr <= sop_cntr_r;
      eop_cntr <= eop_cntr_r;
   end

   // count CRC 32 errors to make them easier to watch
   generate
      for (i=0; i<NUM_LANES; i=i+1) begin : lrc
         always @(posedge clk) begin
            if (rx_usr_srst ) begin
               crc32_err_cnt[(i+1)*8-1:i*8] <= 8'h0;
            end else if (error_clear)begin
			   crc32_err_cnt[(i+1)*8-1:i*8] <= 8'h0;
            end else if (rx_crc32_err[i] && rx_lanes_aligned) begin
               crc32_err_cnt[(i+1)*8-1:i*8] <= crc32_err_cnt[(i+1)*8-1:i*8] + 1'b1;
            end
         end
      end
   endgenerate

   // count CRC 24 errors
   always @(posedge clk) begin
      if (rx_usr_srst) begin
         crc24_err_cnt <= 16'h0;
      end else if (error_clear)begin
	     crc24_err_cnt <= 16'h0;
      end else begin
         crc24_err_cnt <= crc24_err_cnt + (rx_crc24_err && rx_lanes_aligned);
      end
   end

   // sticky flag FIFO errors
   always @(posedge clk) begin
      if (tx_usr_srst) begin
         itx_overflow_sticky <= 1'b0;
      end
      else begin
         itx_overflow_sticky <= itx_overflow_sticky | itx_overflow;
      end
   end

   // sticky flag FIFO errors
   always @(posedge clk) begin
      if (tx_usr_srst) begin
         itx_underflow_sticky <= 1'b0;
      end
      else begin
         itx_underflow_sticky <= itx_underflow_sticky | itx_underflow;
      end
   end

   // sticky flag FIFO errors
   always @(posedge clk) begin
      if (rx_usr_srst)
         irx_overflow_sticky <= 1'b0;
      else
         irx_overflow_sticky <= irx_overflow_sticky | irx_overflow;
   end

   // sticky flag FIFO errors
   always @(posedge clk) begin
      if (rx_usr_srst) begin
         rdc_overflow_sticky <= 1'b0;
      end
      else begin
         rdc_overflow_sticky <= rdc_overflow_sticky | rdc_overflow;
      end
   end

endmodule
