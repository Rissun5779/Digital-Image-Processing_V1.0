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


module pfd #(
   parameter   VIDEO_STANDARD = "tr"
) (
   input       enable,
   input       rst,
   input       rx_rst_proto,
   input [2:0] rx_std,
   input [3:0] rx_format,
   input       rx_clkout,
   input       refclk,
   input       vcoclk,
   output      up,
   output      down,
   output      clear
);

// To detect the assertion of H sync signal from Rx
wire rx_h_assert;
edge_detector #(
    .EDGE_DETECT ("POSEDGE")
) u_hsync_posedge_det (
    .clk (rx_clkout),
    .rst (rx_rst_proto),
    .d (refclk),
    .q (rx_h_assert)
);

// Synchronize divider value to Tx clk domain
reg [15:0]  rx_clk_div;
wire [15:0] vcoclk_divider;
// Divide the calculated divider value by 2 for the 50-50 clock duty cycle
// For HD std, since tx_clkout is 2x faster than rx_clkout, leave the divider value as it is
// For SD std, the CDR is locked to LTR mode, so the divider value is not constant. The divider value is hardcoded for SD std.
wire [15:0] vco_div_in = (rx_std == 3'b000 & rx_format == 4'd0)         ? 16'd4718 :
                         (rx_std == 3'b000 & rx_format == 4'd1)         ? 16'd4751 :
                         (rx_std == 3'b001 & VIDEO_STANDARD != "hd")    ? rx_clk_div : {1'b0,rx_clk_div[15:1]};
clock_crossing  #(
    .W (16)
) u_divider_txclk_sync (
    .in         (vco_div_in),
    .in_clk     (rx_clkout),
    .in_reset   (rx_rst_proto), 
    .out        (vcoclk_divider), 
    .out_clk    (vcoclk), 
    .out_reset  (rst)
);

wire enable_vcoclk_sync;
altera_std_synchronizer #(
    .depth(3)
) u_enable_sync (
    .clk(vcoclk),
    .reset_n(1'b1),
    .din(enable),
    .dout(enable_vcoclk_sync)
);

// Calculate total number of pixels in a line
reg [15:0] pixpln_count;
always @ (posedge rx_clkout or posedge rx_rst_proto)
begin
    if (rx_rst_proto) begin
        pixpln_count <= 16'd0;
        rx_clk_div <= 16'd0;
    end else begin
        if (rx_h_assert) begin
            rx_clk_div <= pixpln_count;
            pixpln_count <= 16'd0;
        end else begin
            pixpln_count <= pixpln_count + 1'b1;
        end
    end
end

reg [15:0] vcoclk_count;
reg vcoclk_div;
always @ (posedge vcoclk or posedge rst)
begin
   if (rst) begin
      vcoclk_count <= 16'd0;
      vcoclk_div <= 1'b0;
   end else if (enable_vcoclk_sync) begin 
      if (vcoclk_count == vcoclk_divider) begin
         vcoclk_count <= 16'd0;
         vcoclk_div <= ~vcoclk_div;
      end else begin
         vcoclk_count <= vcoclk_count + 1'b1;
      end
   end else begin
      vcoclk_count <= 16'd0;
      vcoclk_div <= 1'b0;
   end
end

//----------------------------------------------------------------------------------------------------
// Logics below are according to standard pfd design. Occational glitches is expected.
// Clear signal to the flop is an async signal as well, which is waived by false path sdc constraint.
//----------------------------------------------------------------------------------------------------
reg qref;
reg qvco;
// wire clear;
assign clear = (qref & qvco) || (~enable);
 
always @(posedge refclk or posedge clear)
begin
   if (clear) begin
      qref <= 1'b0;
   end else begin
      qref <= 1'b1;
   end
end

always @(posedge vcoclk_div or posedge clear)
begin 
   if (clear) begin
      qvco <= 1'b0;
   end else begin
      qvco <= 1'b1;
   end 
end

assign up = (qref & enable) ? 1'b1 : 1'b0;
assign down = (qvco & enable) ? 1'b0 : 1'b1;

// assign go_update = up || down;
endmodule
