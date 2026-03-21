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


module sdi_ii_ed_loopback
(
  rx_rst,
  rx_clk,
  rx_data,
  rx_data_b,
  rx_std,
  rx_trs,
  rx_trs_locked,
  rx_frame_locked,
  rx_ln,
  rx_ln_b,
  rx_data_valid,
  rx_data_valid_b,
  rx_vpid_byte1,
  rx_vpid_byte2,
  rx_vpid_byte3,
  rx_vpid_byte4,
  rx_vpid_byte1_b,
  rx_vpid_byte2_b,
  rx_vpid_byte3_b,
  rx_vpid_byte4_b,
  rx_line_f0,
  rx_line_f1,
  // tx_rst,
  tx_clk,
  tx_data,
  tx_data_b,
  tx_data_valid,
  tx_data_valid_b,
  tx_std,
  tx_trs,
  tx_trs_b,
  tx_ln,
  tx_ln_b,
  tx_data_valid_out,
  tx_data_valid_out_b,
  // tx_enable_vpid_c,
  tx_vpid_overwrite,
  tx_vpid_byte1,
  tx_vpid_byte2,
  tx_vpid_byte3,
  tx_vpid_byte4,
  tx_vpid_byte1_b,
  tx_vpid_byte2_b,
  tx_vpid_byte3_b,
  tx_vpid_byte4_b,
  tx_enable_crc,
  tx_enable_ln,
  tx_line_f0,
  tx_line_f1
);

  parameter FAMILY = "Stratix IV";   
  parameter RX_EN_A2B_CONV = 0; 
  parameter RX_EN_B2A_CONV = 0;
  parameter VIDEO_STANDARD = "tr";

  localparam a2b = RX_EN_A2B_CONV;
  localparam b2a = RX_EN_B2A_CONV;
  localparam NUM_STREAMS = (VIDEO_STANDARD == "mr") ? 4 : 1;

  input                         rx_rst;
  input                         rx_clk;        
  input [20*NUM_STREAMS-1:0]    rx_data;
  input [19:0]                  rx_data_b;
  input [2:0]                   rx_std;
  input [1*NUM_STREAMS-1:0]     rx_trs; 
  input [1*NUM_STREAMS-1:0]     rx_trs_locked;
  input                         rx_frame_locked; 
  input [11*NUM_STREAMS-1:0]    rx_ln;
  input [11*NUM_STREAMS-1:0]    rx_ln_b;
  input                         rx_data_valid;
  input                         rx_data_valid_b;
  input [8*NUM_STREAMS-1:0]     rx_vpid_byte1;
  input [8*NUM_STREAMS-1:0]     rx_vpid_byte2;
  input [8*NUM_STREAMS-1:0]     rx_vpid_byte3;
  input [8*NUM_STREAMS-1:0]     rx_vpid_byte4;
  input [8*NUM_STREAMS-1:0]     rx_vpid_byte1_b;
  input [8*NUM_STREAMS-1:0]     rx_vpid_byte2_b;
  input [8*NUM_STREAMS-1:0]     rx_vpid_byte3_b;
  input [8*NUM_STREAMS-1:0]     rx_vpid_byte4_b;
  input [11*NUM_STREAMS-1:0]    rx_line_f0;
  input [11*NUM_STREAMS-1:0]    rx_line_f1;
  // input                         tx_rst; 
  input                         tx_clk;
  input                         tx_data_valid;
  input                         tx_data_valid_b;  
  output [20*NUM_STREAMS-1:0]   tx_data;
  output [19:0]                 tx_data_b;
  output                        tx_data_valid_out;
  output                        tx_data_valid_out_b;
  output [2:0]                  tx_std;
  output                        tx_trs;
  output                        tx_trs_b;
  output [11*NUM_STREAMS-1:0]   tx_ln;
  output [11*NUM_STREAMS-1:0]   tx_ln_b;
  // output        tx_enable_vpid_c;
  output                        tx_vpid_overwrite;
  output [8*NUM_STREAMS-1:0]    tx_vpid_byte1;
  output [8*NUM_STREAMS-1:0]    tx_vpid_byte2;
  output [8*NUM_STREAMS-1:0]    tx_vpid_byte3;
  output [8*NUM_STREAMS-1:0]    tx_vpid_byte4;
  output [8*NUM_STREAMS-1:0]    tx_vpid_byte1_b;
  output [8*NUM_STREAMS-1:0]    tx_vpid_byte2_b;
  output [8*NUM_STREAMS-1:0]    tx_vpid_byte3_b;
  output [8*NUM_STREAMS-1:0]    tx_vpid_byte4_b;

  output                        tx_enable_crc;
  output                        tx_enable_ln;
  output [11*NUM_STREAMS-1:0]   tx_line_f0;
  output [11*NUM_STREAMS-1:0]   tx_line_f1;
  
  wire [20*NUM_STREAMS:0] int_tx_data_a;
  wire [19:0] int_tx_data_b;
  wire        fifo_reset_sync_out;

  generate if (!a2b & !b2a)
    begin : fifo_rst_sync  
      wire fifo_reset = rx_rst | ~(|rx_trs_locked) | ~rx_frame_locked;

      reset_sync #(
        .NUM_RESET_INPUTS          (1),
        .RESET_REQ_WAIT_TIME       (1),
        .MIN_RST_ASSERTION_TIME    (3),
        .SYNC_DEPTH                (3),
        .RESET_REQ_EARLY_DSRT_TIME (1)
      ) u_fifo_reset_sync (
        .reset_in0      (fifo_reset),
        .clk            (tx_clk),
        .reset_out      (fifo_reset_sync_out)
      );
    end
  endgenerate
    
  generate if (!a2b & !b2a)
     begin : u_fifo_a
                
        wire [ 8:0] rdusedw_a;
        reg         rdreq_a;

        always @ (posedge tx_clk or posedge fifo_reset_sync_out)
        begin
           if (fifo_reset_sync_out) begin
              rdreq_a <= 1'b0;
           end else begin
              if (rdusedw_a[8]) begin
                 rdreq_a <= 1'b1;
              end
           end 
        end
   
        dcfifo u_fifo_a 
        (
           .aclr     (fifo_reset_sync_out), 
           .wrclk    (rx_clk),
           .wrreq    (rx_data_valid),
           .data     ({rx_trs[0], rx_data}),
           .rdclk    (tx_clk), 
           .rdreq    (tx_data_valid & rdreq_a),
           .q        (int_tx_data_a),
           .rdusedw  (rdusedw_a),
           .rdempty  ()
        );
        //synopsys read_comments_as_HDL on   
        //defparam u_fifo_a.lpm_hint = "DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT=TRUE";
        //synopsys read_comments_as_HDL off
        defparam u_fifo_a.intended_device_family = FAMILY;
        defparam u_fifo_a.lpm_numwords = 512; 
        defparam u_fifo_a.lpm_showahead = "OFF";
        defparam u_fifo_a.lpm_type = "dcfifo";
        defparam u_fifo_a.lpm_width = (20*NUM_STREAMS + 1);
        defparam u_fifo_a.lpm_widthu = 9;
        defparam u_fifo_a.overflow_checking = "ON";
        defparam u_fifo_a.rdsync_delaypipe = 5;
        defparam u_fifo_a.read_aclr_synch = "ON";
        defparam u_fifo_a.underflow_checking = "ON";
        defparam u_fifo_a.use_eab = "ON";
        defparam u_fifo_a.write_aclr_synch = "ON";
        defparam u_fifo_a.wrsync_delaypipe = 5;
                                  
     end else begin
        assign int_tx_data_a = {(20*NUM_STREAMS + 1){1'b0}};
     end
  endgenerate

  generate if (!a2b & !b2a & VIDEO_STANDARD=="dl")
     begin : u_fifo_b
                  
        wire [ 8:0] rdusedw_b;
        reg         rdreq_b;

        always @ (posedge tx_clk or posedge fifo_reset_sync_out)
        begin
           if (fifo_reset_sync_out) begin
              rdreq_b <= 1'b0;
           end else begin
              if (rdusedw_b[8]) begin
                 rdreq_b <= 1'b1;
              end
           end 
        end
   
        dcfifo u_fifo_b
        (
           .aclr     (fifo_reset_sync_out), 
           .wrclk    (rx_clk),
           .wrreq    (rx_data_valid_b),
           .data     (rx_data_b),
           .rdclk    (tx_clk), 
           .rdreq    (tx_data_valid_b & rdreq_b),
           .q        (int_tx_data_b),
           .rdusedw  (rdusedw_b),
           .rdempty  ()
        );
        //synopsys read_comments_as_HDL on   
        //defparam u_fifo_b.lpm_hint = "DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT=TRUE";
        //synopsys read_comments_as_HDL off
        defparam u_fifo_b.intended_device_family = FAMILY;
        defparam u_fifo_b.lpm_numwords = 512;
        defparam u_fifo_b.lpm_showahead = "OFF";
        defparam u_fifo_b.lpm_type = "dcfifo";
        defparam u_fifo_b.lpm_width = 20;
        defparam u_fifo_b.lpm_widthu = 9;
        defparam u_fifo_b.overflow_checking = "ON";
        defparam u_fifo_b.rdsync_delaypipe = 5;
        defparam u_fifo_b.read_aclr_synch = "ON";
        defparam u_fifo_b.underflow_checking = "ON";
        defparam u_fifo_b.use_eab = "ON";
        defparam u_fifo_b.write_aclr_synch = "ON";
        defparam u_fifo_b.wrsync_delaypipe = 5;
                
     end else begin

        assign int_tx_data_b = 20'd0;

     end
  endgenerate

  localparam SYNC_DEPTH = 3;
  wire [2:0] rx_std_sync;

  generate if (!a2b & !b2a & (VIDEO_STANDARD == "tr" | VIDEO_STANDARD == "ds" | VIDEO_STANDARD == "threeg" | VIDEO_STANDARD == "mr" ))
     begin: rx_to_tx_sync_gen
        altera_std_synchronizer_bundle #(
            .width(3),
            .depth(SYNC_DEPTH)
        ) u_rx_std_syn (
            .clk(tx_clk),
            .reset_n(1'b1),
            .din(rx_std),
            .dout(rx_std_sync)
        );
     end else begin
        assign rx_std_sync = 3'b000;
     end
  endgenerate

  //Drive all vpid related pins to 0 since rx should have all the data inserted earlier
  assign tx_vpid_byte1       = a2b ? {NUM_STREAMS{8'h8A}} : (b2a ? {NUM_STREAMS{8'h87}} : {NUM_STREAMS{8'd0}});
  assign tx_vpid_byte2       = (a2b | b2a) ? rx_vpid_byte2 : {NUM_STREAMS{8'd0}};
  assign tx_vpid_byte3       = (a2b | b2a) ? rx_vpid_byte3 : {NUM_STREAMS{8'd0}};
  assign tx_vpid_byte4       = (a2b | b2a) ? rx_vpid_byte4 : {NUM_STREAMS{8'd0}};
  assign tx_vpid_byte1_b     = a2b ? {NUM_STREAMS{8'h8A}} : (b2a ? {NUM_STREAMS{8'h87}} : {NUM_STREAMS{8'd0}});
  assign tx_vpid_byte2_b     = (a2b | b2a) ? rx_vpid_byte2_b : {NUM_STREAMS{8'd0}};
  assign tx_vpid_byte3_b     = (a2b | b2a) ? rx_vpid_byte3_b : {NUM_STREAMS{8'd0}};
  assign tx_vpid_byte4_b     = (a2b | b2a) ? rx_vpid_byte4_b : {NUM_STREAMS{8'd0}};
  assign tx_std              = a2b ? 3'b010 : (b2a ? 3'b001 : rx_std_sync);
  // assign tx_enable_vpid_c    = b2a ? 1'b1 : 1'b0;
  assign tx_vpid_overwrite   = (b2a | a2b) ? 1'b1 : 1'b0;
  assign tx_ln               = (!a2b & !b2a) ? {NUM_STREAMS{11'd0}} : rx_ln;
  assign tx_ln_b             = (!a2b & !b2a) ? {NUM_STREAMS{11'd0}} : rx_ln_b;
  assign tx_trs              = (!a2b & !b2a) ? int_tx_data_a[20*NUM_STREAMS] : rx_trs[0];
  assign tx_trs_b            = b2a ? rx_trs[0] : 1'b0;
  assign tx_data             = (!a2b & !b2a) ? int_tx_data_a[20*NUM_STREAMS-1:0] : rx_data;
  assign tx_data_b           = (!a2b & !b2a) ? int_tx_data_b : rx_data_b;
  assign tx_data_valid_out   = tx_data_valid;
  assign tx_data_valid_out_b = tx_data_valid_b;
  // Drive unnecessary enable_crc and enable_ln ports to GND
  assign tx_enable_crc       = 1'b0;
  assign tx_enable_ln        = 1'b0;
  assign tx_line_f0          = (a2b | b2a) ? rx_line_f0 : {NUM_STREAMS{11'd0}};
  assign tx_line_f1          = (a2b | b2a) ? rx_line_f1 : {NUM_STREAMS{11'd0}};
    
endmodule
