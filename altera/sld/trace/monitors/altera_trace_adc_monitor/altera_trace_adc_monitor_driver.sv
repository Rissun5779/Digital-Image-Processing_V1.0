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


// $Id: //acds/rel/18.1std/ip/sld/trace/monitors/altera_trace_adc_monitor/altera_trace_adc_monitor_driver.sv#1 $
// $Revision: #1 $
// $Date: 2018/07/18 $
// $Author: psgswbuild $
`default_nettype none
`timescale 1 ns / 1 ns

module altera_trace_adc_monitor_driver_packet_generator #(
    parameter 
      ST_CHANNEL_WIDTH = 5
  )
  (
    input wire valid,
    output reg startofpacket,
    output reg endofpacket,

    input wire clk,
    input wire reset
  );

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      startofpacket <= '1;
      endofpacket <= '1;
    end
    else begin
      startofpacket <= '1;
      endofpacket <= '1;
    end
  end
    
endmodule

module altera_trace_adc_monitor_driver_data_generator #(
    parameter 
      ST_DATA_WIDTH = 12
  )
  (
    input wire valid,
    output reg [ST_DATA_WIDTH - 1 : 0] data,

    input wire [7:0] pattern,

    input wire sync_reset,
    input wire clk,
    input wire reset
  );

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      data <= '0;
    end
    else begin
      if (sync_reset && (pattern == 8'h1)) begin
        data <= 8'hAF;
      end
      else if (valid) begin
        if (pattern == 8'h1)
          data <= 8'hAF;
        else
          data <= data + 1'b1;
      end
    end
  end
endmodule

module altera_trace_adc_monitor_driver_interval_timer #(
    parameter 
      PERIOD_COUNTER_WIDTH = 16
  )
  (
    output reg valid,

    input wire [PERIOD_COUNTER_WIDTH - 1 : 0] counter_reload_value,
    input wire run,

    input wire clk,
    input wire reset
  );

  reg [PERIOD_COUNTER_WIDTH - 1 : 0] counter;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      counter <= '0;
      valid <= '0;
    end
    else begin
      if (~run) begin
        counter <= counter_reload_value;
      end
      else begin
        if (counter == 1) begin
          counter <= counter_reload_value;
          valid <= '1;
        end
        else begin
          counter <= counter - 1'b1;
          valid <= '0;
        end
      end
    end
  end
endmodule

module altera_trace_adc_csr #(
    parameter
      ST_CHANNEL_WIDTH = 5,
      PERIOD_COUNTER_WIDTH = 16,
      PERIOD_CYCLES = 50
  )
  (
    input wire csr_write,
    input wire csr_read,
    input wire [31:0] csr_writedata,
    input wire csr_address,
    output reg [31:0] csr_readdata,

    output reg [PERIOD_COUNTER_WIDTH - 1 : 0] counter_reload_value,
    output reg run,
    output reg [7:0] pattern,
    output reg reset_data_generator,
    output reg [ST_CHANNEL_WIDTH - 1 : 0] channel,

    input wire clk,
    input wire reset
  );

  localparam 
    PERIOD_CYCLES_INT = PERIOD_CYCLES[PERIOD_COUNTER_WIDTH - 1 : 0];

  // address decode
  wire decode_reg0 = csr_address == 1'b0;
  wire decode_reg1 = csr_address == 1'b1;

  // "run" bit.
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      run <= '0;
      pattern <= '0;
      counter_reload_value <= PERIOD_CYCLES_INT;
      reset_data_generator <= '0;
      channel <= '0;
    end
    else begin
      reset_data_generator <= csr_write & decode_reg0;
      if (csr_write & decode_reg0) begin
        run <= csr_writedata[0];
        pattern <= csr_writedata[15:8];
        channel <= csr_writedata[16 +: ST_CHANNEL_WIDTH];
      end
      if (csr_write & decode_reg1)
        counter_reload_value <= csr_writedata[PERIOD_COUNTER_WIDTH - 1 : 0];
    end
  end

  // readdata mux
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      csr_readdata <= '0;
    end
    else begin
      csr_readdata <= decode_reg0 ? {11'b0, channel, pattern, 7'b0, run} :
        counter_reload_value;
    end
  end
endmodule


module altera_trace_adc_monitor_driver #(
    parameter
      PERIOD_COUNTER_WIDTH = 16,
      PERIOD_CYCLES = 50,

      ST_CHANNEL_WIDTH = 5,
      ST_DATA_WIDTH = 12
  )
  (
    // ST source 'adc'
    output wire adc_valid,
    output wire [ST_CHANNEL_WIDTH - 1 : 0] adc_channel,
    output wire [ST_DATA_WIDTH - 1 : 0] adc_data,
    output wire adc_startofpacket,
    output wire adc_endofpacket,

    // MM slave 'csr'
    input wire csr_write,
    input wire csr_read,
    input wire [31:0] csr_writedata,
    input wire csr_address,
    output wire [31:0] csr_readdata,

    input wire clk,
    input wire reset
  );

  wire run;
  wire [PERIOD_COUNTER_WIDTH - 1 : 0] counter_reload_value;

  wire [7:0] pattern;
  wire reset_data_generator;
  altera_trace_adc_csr #(
      .ST_CHANNEL_WIDTH (ST_CHANNEL_WIDTH),
      .PERIOD_COUNTER_WIDTH (PERIOD_COUNTER_WIDTH),
      .PERIOD_CYCLES (PERIOD_CYCLES)
  ) the_csr(
    .csr_write (csr_write),
    .csr_read (csr_read),
    .csr_writedata (csr_writedata),
    .csr_address (csr_address),
    .csr_readdata (csr_readdata),

    .reset_data_generator (reset_data_generator),

    .counter_reload_value (counter_reload_value),
    .run (run),
    .pattern (pattern),
    .channel (adc_channel),

    .clk (clk),
    .reset (reset)
  );

  altera_trace_adc_monitor_driver_interval_timer #(
    .PERIOD_COUNTER_WIDTH (PERIOD_COUNTER_WIDTH)
  ) the_timer (
    .valid (adc_valid),
    .counter_reload_value (counter_reload_value),
    .run (run),

    .clk (clk),
    .reset (reset)
  );

  altera_trace_adc_monitor_driver_data_generator #(
    .ST_DATA_WIDTH (ST_DATA_WIDTH)
  ) the_data_generator (
    .valid (adc_valid),
    .data (adc_data),
    .pattern (pattern),

    .sync_reset (reset_data_generator),
    .clk (clk),
    .reset (reset)
  );

  altera_trace_adc_monitor_driver_packet_generator #(
    .ST_CHANNEL_WIDTH (ST_CHANNEL_WIDTH)
  ) the_packet_generator (
    .valid (adc_valid),
    .startofpacket (adc_startofpacket),
    .endofpacket (adc_endofpacket),

    .clk (clk),
    .reset (reset)
  );

endmodule

`default_nettype wire

