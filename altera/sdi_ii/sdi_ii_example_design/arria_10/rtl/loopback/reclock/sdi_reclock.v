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


module sdi_reclock #(
   parameter   VIDEO_STANDARD = "tr"
) (
   input        reset,
   input        sysclk,
   input        rx_clkout,
   input        tx_clkout,
   input        rx_rst_proto,
   input        rx_trs_locked,
   input        rx_frame_locked,
   input        rx_h,
   input [2:0]  rx_std,
   input [3:0]  rx_format,
   input        rx_clkout_is_ntsc_paln,
   input [31:0] coeff_sd,
   input [31:0] coeff_hd,
   input [31:0] coeff_3g,
   input        pll_locked,
   input        waitrequest_signal,
   output [9:0] address_signal,
   output[31:0] write_data,
   output       write_signal,
   output       read_signal,
   input [31:0] read_data
);

wire tx_clkout_reset_sync_out;
reset_sync #(
    .NUM_RESET_INPUTS          (1),
    .RESET_REQ_WAIT_TIME       (1),
    .MIN_RST_ASSERTION_TIME    (3),
    .RESET_REQ_EARLY_DSRT_TIME (1)
) tx_clkout_rst_sync_inst (
// Clock and reset
    .reset_in0      (reset),
    .clk            (tx_clkout),
// Outputs
    .reset_out      (tx_clkout_reset_sync_out)
);

wire up;
wire down;
wire clear;
pfd #(
   .VIDEO_STANDARD          (VIDEO_STANDARD)
) pfd_inst (
   .enable          (rx_trs_locked & rx_frame_locked),  // Enable
   .rst             (tx_clkout_reset_sync_out),         // Reset
   .rx_rst_proto    (rx_rst_proto),                     // Reset
   .rx_std          (rx_std),                           // Received video standard
   .rx_format       (rx_format),                        // Received video format
   .rx_clkout       (rx_clkout),                        // Rx recovered clock
   .refclk          (rx_h),                             // Extracted H sync pulse from the incoming video
   .vcoclk          (tx_clkout),                        // Tx clkout, mirror of fPLL output clock (148.5MHz or 148.35MHz)
   .up              (up),                               // Up signal is asserted when refclk is faster than vcoclk
   .down            (down),                             // Down signal is asserted when refclk is slower than vcoclk
   .clear           (clear)                             // Clear signal is asserted when both rising edge of refclk and vcoclk are found
);

//---------------------------------------------------------------------------
// Synchronizer required for pid_controller
//---------------------------------------------------------------------------
wire rx_frame_locked_sync;
altera_std_synchronizer #(
    .depth(3)
) u_rx_frame_locked_sync (
    .clk(sysclk),
    .reset_n(1'b1),
    .din(rx_frame_locked),
    .dout(rx_frame_locked_sync)
);

wire rx_trs_locked_sync;
altera_std_synchronizer #(
    .depth(3)
) u_rx_trs_locked_sync (
    .clk(sysclk),
    .reset_n(1'b1),
    .din(rx_trs_locked),
    .dout(rx_trs_locked_sync)
);

wire rx_clkout_is_ntsc_paln_sync;
altera_std_synchronizer #(
    .depth(3)
) u_rx_clkout_is_ntsc_paln_sync (
    .clk(sysclk),
    .reset_n(1'b1),
    .din(rx_clkout_is_ntsc_paln),
    .dout(rx_clkout_is_ntsc_paln_sync)
);

wire frame_locked_deassert;
edge_detector #(
    .EDGE_DETECT ("NEGEDGE")
) u_frame_locked_negedge_det (
    .clk (sysclk),
    .rst (reset),
    .d (rx_frame_locked_sync),
    .q (frame_locked_deassert)
);

wire reconfig_reset_sync_out;
//---------------------------------------------------------------------------
// Reset sync instance is generated along with SDI Rx. If you need to use 
// this instance, make sure that SDI Rx is added into your project as well.
//---------------------------------------------------------------------------
reset_sync #(
    .NUM_RESET_INPUTS          (1),
    .RESET_REQ_WAIT_TIME       (1),
    .MIN_RST_ASSERTION_TIME    (3),
    .RESET_REQ_EARLY_DSRT_TIME (1)
) sysclk_rst_sync_inst (
// Clock and reset
    .reset_in0      (reset),
    .clk            (sysclk),
// Outputs
    .reset_out      (reconfig_reset_sync_out)
);

// ----------------------------------------------------
// PFD + PI control algorithm (error accumulation logic)
// ----------------------------------------------------  
// Synchronize divider value to Vco clk domain
wire [2:0] rx_std_sync;
clock_crossing  #(
    .W (3)
) u_rx_std_sync (
// Divide the calculated divider value by 2 for the 50-50 clock duty cycle
// For HD std, since tx_clkout is 2x faster than rx_clkout, leave the divider value as it is
    .in         (rx_std), 
    .in_clk     (rx_clkout),
    .in_reset   (rx_rst_proto), 
    .out        (rx_std_sync), 
    .out_clk    (sysclk), 
    .out_reset  (reconfig_reset_sync_out | frame_locked_deassert)
);

pid_controller u_pi_control (
// Clock and reset
    .sys_clk (sysclk),
    .sys_clk_rst (reconfig_reset_sync_out | frame_locked_deassert),
// Inputs
    .refclk (rx_h),
    .rx_locked (rx_trs_locked_sync & rx_frame_locked_sync),
    .pll_locked (pll_locked),
    .gain_proportional ((rx_std_sync[2] || rx_std_sync[1]) ? coeff_3g : (rx_std_sync[0] ? coeff_hd : coeff_sd)), 
    .rx_rate (rx_clkout_is_ntsc_paln_sync & rx_trs_locked_sync),
    .up (up),
    .down (~down),
    .clear (clear),
// Outputs
    .waitrequest (waitrequest_signal),
    .write (write_signal),
    .address (address_signal),
    .writedata (write_data),
    .read (read_signal),
    .readdata (read_data)
);

endmodule
