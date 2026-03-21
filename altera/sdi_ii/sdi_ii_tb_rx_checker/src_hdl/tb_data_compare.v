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


`timescale 1 ps / 1 ps
`define tdisplay(MYSTRING) $display("%t:%s \n", $time,  MYSTRING)

module tb_data_compare #(
    parameter                       EN_SD_20BITS = 1'b0
)(
    // port list
    input wire                      tx_clk,
    input wire                      rx_clk,
    input wire                      rst,
    input wire                      rx_locked,
    input wire [79:0] txdata,
    input wire                      txdata_valid,
    input wire [79:0] rxdata,
    input wire                      rxdata_valid,
    input wire                      enable,
    input wire [2:0]                video_std,
    output reg                      data_error
);

    //--------------------------------------------------------------------------------------------------
    // Detect active picture (Tx)
    //--------------------------------------------------------------------------------------------------
    reg [479:0]   txdata_reg;
    reg                         tx_trs_detect;
    reg                         tx_ap;
    reg                         start_data_store;
 
    always @ (posedge tx_clk or posedge rst)
    begin
       if (rst) begin
          tx_trs_detect <= 1'b0;
          tx_ap <= 1'b0;
          txdata_reg <= {480{1'b0}};
          start_data_store <= 1'b0;
       end else if (txdata_valid) begin
          // Store txdata into a register
          if (rx_locked && enable) begin
             if (video_std[2:1] == 2'b11) begin
                txdata_reg <= {txdata_reg[399:0], txdata[79:0]};
             end else if (video_std[2:1] == 2'b10) begin
                txdata_reg <= {txdata_reg[199:0], txdata[39:0]};
             end else begin
                txdata_reg <= {txdata_reg[99:0], txdata[19:0]};
             end
          end

          // Assert trs_detect signal when trs is detected in transmitted data
          if (video_std == 3'b110) begin
             if (txdata_reg[479:0] == {{8{20'hfffff}}, {8{40'd0}}}) begin
                tx_trs_detect <= 1'b1;
             end else begin
                tx_trs_detect <= 1'b0;
             end
          end else if (video_std == 3'b100 | video_std == 3'b111) begin
             if (txdata_reg[239:0] == {{4{20'hfffff}}, {4{40'd0}}}) begin
                tx_trs_detect <= 1'b1;
             end else begin
                tx_trs_detect <= 1'b0;
             end
          end else if (video_std == 3'b010 | video_std == 3'b101) begin
             if (txdata_reg[119:0] == {{2{20'hfffff}}, {2{40'd0}}}) begin
                tx_trs_detect <= 1'b1;
             end else begin
                tx_trs_detect <= 1'b0;
             end
          end else if (EN_SD_20BITS & video_std == 3'b000) begin
             if (txdata_reg[39:20] == {10'h000, 10'h3ff} & txdata_reg[9:0] == 10'h000) begin
                tx_trs_detect <= 1'b1;
             end else begin
                tx_trs_detect <= 1'b0;
             end
          end else begin
             if (txdata_reg[59:0] == {20'hfffff, 40'd0}) begin
                tx_trs_detect <= 1'b1;
             end else begin
                tx_trs_detect <= 1'b0;
             end
          end

          // Determine whether current data is in active picture region
          if (tx_trs_detect) begin
             if (EN_SD_20BITS & video_std == 3'b000) begin
                if (~txdata_reg[37] & ~txdata_reg[36]) begin
                   tx_ap <= 1'b1;
                   start_data_store <= 1'b1;
                end else begin
                   tx_ap <= 1'b0;
                end
             end else if (~EN_SD_20BITS & video_std == 3'b000) begin
                if (~txdata_reg[7] & ~txdata_reg[6]) begin
                   tx_ap <= 1'b1;
                   start_data_store <= 1'b1;
                end else begin
                   tx_ap <= 1'b0;
                end
             end else begin
                if (~txdata_reg[17] & ~txdata_reg[16]) begin
                   tx_ap <= 1'b1;
                   start_data_store <= 1'b1;
                end else begin
                   tx_ap <= 1'b0;
                end
             end
          end
       end
    end

    //--------------------------------------------------------------------------------------------------
    // Detect active picture (Rx)
    //--------------------------------------------------------------------------------------------------
    reg [479:0] rxdata_reg;
    reg         rx_trs_detect;
    reg         read_fifo;

    always @ (posedge rx_clk or posedge rst)
    begin
       if (rst) begin
          rx_trs_detect <= 1'b0;
          read_fifo <= 1'b0;
          rxdata_reg <= 60'd0;
       end else if (rxdata_valid) begin
          // Store rxdata into a register
          if (rx_locked && enable) begin
             if (video_std[2:1] == 2'b11) begin
                rxdata_reg <= {rxdata_reg[399:0], rxdata[79:0]};
             end else if (video_std[2:1] == 2'b10) begin
                rxdata_reg <= {rxdata_reg[199:0], rxdata[39:0]};
             end else begin
                rxdata_reg <= {rxdata_reg[99:0], rxdata[19:0]};
             end
          end

          // Assert trs_detect signal when trs is detected
          if (video_std == 3'b110) begin
             if (rxdata_reg[479:0] == {{8{20'hfffff}}, {8{40'd0}}}) begin
                rx_trs_detect <= 1'b1;
             end else begin
                rx_trs_detect <= 1'b0;
             end
          end else if (video_std == 3'b100 | video_std == 3'b111) begin
             if (rxdata_reg[239:0] == {{4{20'hfffff}}, {4{40'd0}}}) begin
                rx_trs_detect <= 1'b1;
             end else begin
                rx_trs_detect <= 1'b0;
             end
          end else if (video_std == 3'b010 | video_std == 3'b101) begin
             if (rxdata_reg[119:0] == {{2{20'hfffff}}, {2{40'd0}}}) begin
                rx_trs_detect <= 1'b1;
             end else begin
                rx_trs_detect <= 1'b0;
             end
          end else if (EN_SD_20BITS & video_std == 3'b000) begin
             if (rxdata_reg[39:20] == {10'h000, 10'h3ff} & rxdata_reg[9:0] == 10'h000) begin
                rx_trs_detect <= 1'b1;
             end else begin
                rx_trs_detect <= 1'b0;
             end
          end else begin
             if (rxdata_reg[59:0] == {20'hfffff, 40'd0}) begin
                rx_trs_detect <= 1'b1;
             end else begin
                rx_trs_detect <= 1'b0;
             end
          end

          // Start reading fifo when rxdata is in active picture region
          if (rx_trs_detect & start_data_store) begin
             if (EN_SD_20BITS & video_std == 3'b000) begin
                if (~rxdata_reg[37] & ~rxdata_reg[36]) begin
                   read_fifo <= 1'b1;
                end else begin
                   read_fifo <= 1'b0;
                end
             end else if (~EN_SD_20BITS & video_std == 3'b000) begin
                if (~rxdata_reg[7] & ~rxdata_reg[6]) begin
                   read_fifo <= 1'b1;
                end else begin
                   read_fifo <= 1'b0;
                end
             end else begin
                if (~rxdata_reg[17] & ~rxdata_reg[16]) begin
                   read_fifo <= 1'b1;
                end else begin
                   read_fifo <= 1'b0;
                end
             end
          end
       end
    end

    //--------------------------------------------------------------------------------------------------
    // Fifo to store txdata
    //-------------------------------------------------------------------------------------------------- 
    wire [79:0] test_fifo_out;
    wire [79:0] test_fifo_in = video_std[2:1] == 2'b11 ?  txdata_reg[79:0] :
                                             video_std[2:1] == 2'b10 ?  txdata_reg[39:0] : txdata_reg[19:0];
                                             
    tb_fifo_line_test u_fifo (
     .aclr             (rst),
     .data             (test_fifo_in),
     .rdclk            (rx_clk),
     .rdreq            (read_fifo & rxdata_valid),
     .wrclk            (tx_clk),
     .wrreq            (tx_ap & txdata_valid),
     .q                (test_fifo_out),
     .rdusedw          ()
    );

    //--------------------------------------------------------------------------------------------------
    // Compare rxdata with dataout from fifo
    //--------------------------------------------------------------------------------------------------
    reg [79:0]  rxdata_dly_2;
    reg         read_fifo_dly;
    reg         data_error_seen;

    always @ (posedge rx_clk or posedge rst)
    begin
       if (rst) begin
          data_error <= 1'b1;
          data_error_seen <= 1'b0;
       end else if (rxdata_valid) begin
          if (video_std[2:1] == 2'b11) begin
             rxdata_dly_2 <= rxdata_reg[79:0];
          end else if (video_std[2:1] == 2'b10) begin
             rxdata_dly_2 <= rxdata_reg[39:0];
          end else begin
             rxdata_dly_2 <= rxdata_reg[19:0];
          end

          read_fifo_dly <= read_fifo;

          if (read_fifo_dly) begin
             if (video_std[2:1] == 2'b11) begin
                if (rxdata_dly_2 == test_fifo_out && ~data_error_seen) begin
                   data_error <= 1'b0;
                end else begin
                   data_error <= 1'b1;
                   data_error_seen <= 1'b1;
                end
             end else if (video_std[2:1] == 2'b10) begin
                if (rxdata_dly_2[39:0] == test_fifo_out[39:0] && ~data_error_seen) begin
                   data_error <= 1'b0;
                end else begin
                   data_error <= 1'b1;
                   data_error_seen <= 1'b1;
                end
             end else if (~EN_SD_20BITS & video_std == 3'b000) begin
                //SD mode - lower 10 bits
                if (rxdata_dly_2[9:0] == test_fifo_out[9:0] && ~data_error_seen) begin
                   data_error <= 1'b0;
                end else begin
                   data_error <= 1'b1;
                   data_error_seen <= 1'b1;
                end
             end else begin
                // All 20 bits
                if (rxdata_dly_2[19:0] == test_fifo_out[19:0] && ~data_error_seen) begin
                   data_error <= 1'b0;
                end else begin
                   data_error <= 1'b1;
                   data_error_seen <= 1'b1;
                end
             end
          end
       end
    end

    //--------------------------------------------------------------------------
    // [END] comment
    //--------------------------------------------------------------------------

 endmodule
