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


// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.

// This fife was created for fixing issue (case 31176)
// gearbox_write -> metaframe_write -> striper_wd_write
`timescale 1 ps / 1 ps
module striper_wd_req # (
  parameter INTERNAL_WORDS        = 4,
  parameter NUM_LANES             = 8,
  parameter PCS_WIDTH             = 7'd67,
  parameter PMA_WIDTH             = 7'd40
) (
  input             clk,          //tx clk
  input             srst,
  input             pcs_clk,      //tx common clk
  input             pcs_srst,

  input             tx_lanes_aligned,
  input             tx_frame,
  input             tx_valid,
  input             pre_crc_words_valid,
  output reg        striper_wd_req
);

  reg    [ 7: 0] gearbox_bit_cnt;
  reg    [ 5: 0] striper_wd;

  //frame detect
  reg    tx_frame_q;
  reg    tx_valid_q;
  always @(posedge pcs_clk) begin
    if (pcs_srst) begin
      tx_frame_q <= 1'b0;
      tx_valid_q <= 1'b0;
    end else begin
      tx_frame_q <= tx_frame;
      if (tx_valid) tx_valid_q <= 1'b1;
    end
  end 

  wire frame_det = ~tx_frame_q & tx_frame;

  reg smooth_cnt_ena;
  always @(posedge pcs_clk) begin
    if (pcs_srst) begin
      smooth_cnt_ena <= 1'd0;
    end else  begin
      smooth_cnt_ena <= 1'd1;
    end 
  end
 
  reg [7:0] smooth_cnt;
  always @(posedge pcs_clk) begin
    if (pcs_srst) begin
      smooth_cnt <= 8'd0;
    end else if (frame_det) begin
      smooth_cnt <= 8'd0;
    end else if (smooth_cnt_ena) begin
      smooth_cnt <= (smooth_cnt == 8'd152) ? smooth_cnt: smooth_cnt + 1'b1;
    end
  end

  wire add_gas = (smooth_cnt == 8'd1) | (smooth_cnt == 8'd51) | (smooth_cnt == 8'd101) | (smooth_cnt == 8'd151);

  wire  tx_fifo_read  = (gearbox_bit_cnt < PMA_WIDTH) ? 1'b1 : 1'b0;
  always @(posedge pcs_clk) begin
    if (pcs_srst) begin
      gearbox_bit_cnt    <= 8'h0;
    end else begin
      case ({add_gas, tx_fifo_read})
        2'b00: gearbox_bit_cnt  <= gearbox_bit_cnt - PMA_WIDTH;
        2'b01: gearbox_bit_cnt  <= gearbox_bit_cnt - PMA_WIDTH + PCS_WIDTH;
        2'b10: gearbox_bit_cnt  <= gearbox_bit_cnt - PMA_WIDTH + PCS_WIDTH;
        2'b11: gearbox_bit_cnt  <= gearbox_bit_cnt - PMA_WIDTH + 2*PCS_WIDTH;
        default: gearbox_bit_cnt  <= gearbox_bit_cnt - PMA_WIDTH;
      endcase
    end
  end 

  reg [4:0]  wptr_gray_sync0;
  reg [4:0]  wptr_gray_sync1;
  reg [4:0]  wptr_gray;
  reg [4:0]  wptr;
  reg [4:0]  wptr_sync;
  reg [4:0]  rptr;
  assign               wptr_sync = (wptr_gray_sync1     ) ^ 
                                   (wptr_gray_sync1 >> 1) ^ 
                                   (wptr_gray_sync1 >> 2) ^ 
                                   (wptr_gray_sync1 >> 3) ^ 
                                   (wptr_gray_sync1 >> 4);

  always @(posedge pcs_clk) begin
    if (pcs_srst) begin
      wptr             <= 5'h0;
      wptr_gray        <= 5'h0;
    end else begin
      if (tx_fifo_read) begin
        wptr           <= wptr + 1'b1;
      end
      wptr_gray        <= wptr ^ (wptr >> 1);
    end
  end

  // trigger striper_wd_req whenever there is a difference between wptr and rptr
  reg       striper_req;
  reg [3:0] req_cnt;
  always @(posedge clk) begin
    if (srst) begin
      rptr             <= 5'h0;
      striper_req      <= 1'b0;
    end else begin
      if (rptr != wptr_sync) begin
        rptr           <= rptr + 1'b1;
        striper_req    <= 1'b1;
      end else begin
        rptr           <= rptr;
        striper_req    <= 1'b0;
      end
    end
  end

  wire read_cnt = tx_valid_q ? striper_wd_req & pre_crc_words_valid : (req_cnt != 4'b0) ;
  always @(posedge clk) begin
    if (srst) begin
      req_cnt        <= 4'b0;
    end else begin
      case ({striper_req, read_cnt})
        2'b00 : req_cnt <= req_cnt;
        2'b01 : req_cnt <= req_cnt - 4'd1;
        2'b10 : req_cnt <= req_cnt + 4'd2;
        2'b11 : req_cnt <= req_cnt + 4'd1;
        default : req_cnt <= req_cnt;
      endcase
    end
  end

  assign striper_wd_req = (req_cnt != 4'b0);

  always @(posedge clk) begin
    if (srst) begin
      wptr_gray_sync0  <= 5'h0;
      wptr_gray_sync1  <= 5'h0;
    end else begin
      wptr_gray_sync0  <= wptr_gray;
      wptr_gray_sync1  <= wptr_gray_sync0;
    end
  end

endmodule
