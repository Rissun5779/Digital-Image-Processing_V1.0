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


`timescale 1 ps/1 ps

module alt_xcvr_native_embedded_debug #(
  parameter channels                    = 1,
  parameter channel_num                 = 1,
  parameter dbg_user_identifier         = 0,
  parameter duplex_mode                 = "duplex",
  parameter dbg_capability_reg_enable   = 0,
  parameter dbg_prbs_soft_logic_enable  = 0,
  parameter dbg_odi_soft_logic_enable   = 0,
  parameter dbg_stat_soft_logic_enable  = 0,
  parameter dbg_ctrl_soft_logic_enable  = 0,
  parameter rcfg_emb_strm_soft_logic_enable  = 0,
  parameter rcfg_emb_strm_cfg_sel_width = 2
) (
  // avmm signals
  input         avmm_clk,
  input         avmm_reset,
  input  [8:0]  avmm_address,
  input  [7:0]  avmm_writedata,
  input         avmm_write,
  input         avmm_read,
  output [7:0]  avmm_readdata,
  output        avmm_waitrequest,

  // input signals from the PHY for PRBS error accumulation
  input         prbs_err_signal,
  input         prbs_done_signal,

  // input rx_clkout
  input         in_rx_clkout,

  // input status signals
  input         in_rx_is_lockedtoref,
  input         in_rx_is_lockedtodata,
  input         in_tx_cal_busy,
  input         in_rx_cal_busy,

  // input control signals
  input         in_rx_prbs_err_clr,
  input         in_set_rx_locktoref,
  input         in_set_rx_locktodata,
  input         in_en_serial_lpbk,
  input         in_rx_analogreset,
  input         in_rx_digitalreset,
  input         in_tx_analogreset,
  input         in_tx_digitalreset,
  
  // embedded reconfig signals
  input         rcfg_emb_strm_busy,
  input         rcfg_emb_strm_chan_sel,
  output [rcfg_emb_strm_cfg_sel_width-1:0]  rcfg_emb_strm_cfg_sel,
  output        rcfg_emb_strm_bcast_en,
  output        rcfg_emb_strm_cfg_load,

  // output control signals to the phy
  output        out_prbs_err_clr,
  output        out_set_rx_locktoref,
  output        out_set_rx_locktodata,
  output        out_en_serial_lpbk,
  output        out_rx_analogreset,
  output        out_rx_digitalreset,
  output        out_tx_analogreset,
  output        out_tx_digitalreset
);

wire        prbs_done_sync;
wire        csr_prbs_snapshot;
wire        csr_prbs_count_en;
wire [49:0] prbs_err_count;
wire [49:0] prbs_bit_count;

alt_xcvr_native_avmm_csr #(
  .channels                        ( channels                        ),
  .channel_num                     ( channel_num                     ),
  .dbg_user_identifier             ( dbg_user_identifier             ),
  .duplex_mode                     ( duplex_mode                     ),
  .dbg_capability_reg_enable       ( dbg_capability_reg_enable       ),
  .dbg_prbs_soft_logic_enable      ( dbg_prbs_soft_logic_enable      ),
  .dbg_odi_soft_logic_enable       ( dbg_odi_soft_logic_enable       ),
  .dbg_stat_soft_logic_enable      ( dbg_stat_soft_logic_enable      ),
  .dbg_ctrl_soft_logic_enable      ( dbg_ctrl_soft_logic_enable      ),
  .rcfg_emb_strm_soft_logic_enable ( rcfg_emb_strm_soft_logic_enable ),
  .rcfg_emb_strm_cfg_sel_width     ( rcfg_emb_strm_cfg_sel_width     )
) embedded_debug_soft_csr (
  // avmm signals
  .avmm_clk                            (avmm_clk),
  .avmm_reset                          (avmm_reset),
  .avmm_address                        (avmm_address),
  .avmm_writedata                      (avmm_writedata),
  .avmm_write                          (avmm_write),
  .avmm_read                           (avmm_read),
  .avmm_readdata                       (avmm_readdata),
  .avmm_waitrequest                    (avmm_waitrequest),

  // prbs control signals
  .prbs_err                            (prbs_err_count),
  .prbs_bit                            (prbs_bit_count),
  .prbs_done                           (prbs_done_sync),
  .prbs_snap                           (csr_prbs_snapshot),
  .prbs_count_en                       (csr_prbs_count_en),
  .prbs_reset                          (out_prbs_err_clr),

  // input status signals from the channel
  .rx_is_lockedtodata                  (in_rx_is_lockedtodata),
  .rx_is_lockedtoref                   (in_rx_is_lockedtoref),
  .tx_cal_busy                         (in_tx_cal_busy),
  .rx_cal_busy                         (in_rx_cal_busy),

  // input control signals
  .rx_prbs_err_clr                     (in_rx_prbs_err_clr),
  .set_rx_locktoref                    (in_set_rx_locktoref),
  .set_rx_locktodata                   (in_set_rx_locktodata),
  .serial_loopback                     (in_en_serial_lpbk),
  .rx_analogreset                      (in_rx_analogreset),
  .rx_digitalreset                     (in_rx_digitalreset),
  .tx_analogreset                      (in_tx_analogreset),
  .tx_digitalreset                     (in_tx_digitalreset),
  
  // embedded reconfig signals
  .rcfg_emb_strm_busy                  (rcfg_emb_strm_busy),
  .rcfg_emb_strm_chan_sel              (rcfg_emb_strm_chan_sel),
  .rcfg_emb_strm_cfg_sel               (rcfg_emb_strm_cfg_sel),
  .rcfg_emb_strm_bcast_en              (rcfg_emb_strm_bcast_en),
  .rcfg_emb_strm_cfg_load              (rcfg_emb_strm_cfg_load),


  // output control signals to the channel
  .csr_set_lock_to_data                (out_set_rx_locktodata),
  .csr_set_lock_to_ref                 (out_set_rx_locktoref),
  .csr_en_loopback                     (out_en_serial_lpbk),
  .csr_rx_analogreset                  (out_rx_analogreset),
  .csr_rx_digitalreset                 (out_rx_digitalreset),
  .csr_tx_analogreset                  (out_tx_analogreset),
  .csr_tx_digitalreset                 (out_tx_digitalreset)
);

generate if(dbg_prbs_soft_logic_enable == 1) begin: en_prbs_accumulators
  alt_xcvr_native_prbs_accum prbs_soft_accumulators (
    .avmm_clk          (avmm_clk),
    .avmm_reset        (avmm_reset),

    // output to soft registers for reading
    .prbs_err_count    (prbs_err_count),
    .prbs_bit_count    (prbs_bit_count),

    // from soft csr
    .prbs_reset        (out_prbs_err_clr),
    .prbs_snapshot     (csr_prbs_snapshot),
    .prbs_counter_en   (csr_prbs_count_en),

    // to soft csr
    .prbs_done_sync    (prbs_done_sync),

    // from phy
    .rx_clkout         (in_rx_clkout),
    .prbs_err_signal   (prbs_err_signal),
    .prbs_done_signal  (prbs_done_signal)
  );
end else begin: dis_prbs_accum
  assign prbs_err_count = 50'b0;
  assign prbs_bit_count = 50'b0;
end
endgenerate

endmodule
