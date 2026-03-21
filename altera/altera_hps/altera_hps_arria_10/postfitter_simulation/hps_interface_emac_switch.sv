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


module twentynm_hps_interface_emac_switch (
  ap_clk,
  ari_ack_i,
  ari_frameflush_i,
  ati_ack_i,
  ati_discrc_i,
  ati_dispad_i,
  ati_ena_timestamp_i,
  ati_eof_i,
  ati_sof_i,
  ati_val_i,
  ari_pbl_i,
  ati_be_i,
  ati_chksum_ctrl_i,
  ati_data_i,
  ati_pbl_i,
  ari_eof_o,
  ari_rx_watermark_o,
  ari_rxstatus_val_o,
  ari_sof_o,
  ari_timestamp_val_o,
  ari_val_o,
  ati_rdy_o,
  ati_tx_watermark_o,
  ati_txstatus_val,
  ari_be_o,
  ari_data_o,
  ati_timestamp_o,
  ati_txstatus_o);

  input         ap_clk;
  input         ari_ack_i;
  input         ari_frameflush_i;
  input         ati_ack_i;
  input         ati_discrc_i;
  input         ati_dispad_i;
  input         ati_ena_timestamp_i;
  input         ati_eof_i;
  input         ati_sof_i;
  input         ati_val_i;
  input   [8:0] ari_pbl_i;
  input   [1:0] ati_be_i;
  input   [1:0] ati_chksum_ctrl_i;
  input  [31:0] ati_data_i;
  input   [8:0] ati_pbl_i;

  output        ari_eof_o;
  output        ari_rx_watermark_o;
  output        ari_rxstatus_val_o;
  output        ari_sof_o;
  output        ari_timestamp_val_o;
  output        ari_val_o;
  output        ati_rdy_o;
  output        ati_tx_watermark_o;
  output        ati_txstatus_val;
  output  [1:0] ari_be_o;
  output [31:0] ari_data_o;
  output [63:0] ati_timestamp_o;
  output [17:0] ati_txstatus_o;


  // synthesis translate_off
  import verbosity_pkg::*;

  typedef logic        ROLE_ap_clk_t;
  typedef logic        ROLE_ari_ack_i_t;
  typedef logic        ROLE_ari_frameflush_i_t;
  typedef logic        ROLE_ati_ack_i_t;
  typedef logic        ROLE_ati_discrc_i_t;
  typedef logic        ROLE_ati_dispad_i_t;
  typedef logic        ROLE_ati_ena_timestamp_i_t;
  typedef logic        ROLE_ati_eof_i_t;
  typedef logic        ROLE_ati_sof_i_t;
  typedef logic        ROLE_ati_val_i_t;
  typedef logic  [8:0] ROLE_ari_pbl_i_t;
  typedef logic  [1:0] ROLE_ati_be_i_t;
  typedef logic  [1:0] ROLE_ati_chksum_ctrl_i_t;
  typedef logic [31:0] ROLE_ati_data_i_t;
  typedef logic  [8:0] ROLE_ati_pbl_i_t;

  typedef logic        ROLE_ari_eof_o_t;
  typedef logic        ROLE_ari_rx_watermark_o_t;
  typedef logic        ROLE_ari_rxstatus_val_o_t;
  typedef logic        ROLE_ari_sof_o_t;
  typedef logic        ROLE_ari_timestamp_val_o_t;
  typedef logic        ROLE_ari_val_o_t;
  typedef logic        ROLE_ati_rdy_o_t;
  typedef logic        ROLE_ati_tx_watermark_o_t;
  typedef logic        ROLE_ati_txstatus_val_t;
  typedef logic  [1:0] ROLE_ari_be_o_t;
  typedef logic [31:0] ROLE_ari_data_o_t;
  typedef logic [63:0] ROLE_ati_timestamp_o_t;
  typedef logic [17:0] ROLE_ati_txstatus_o_t;

  logic        ap_clk_input;
  logic        ari_ack_i_input;
  logic        ari_frameflush_i_input;
  logic        ati_ack_i_input;
  logic        ati_discrc_i_input;
  logic        ati_dispad_i_input;
  logic        ati_ena_timestamp_i_input;
  logic        ati_eof_i_input;
  logic        ati_sof_i_input;
  logic        ati_val_i_input;
  logic  [8:0] ari_pbl_i_input;
  logic  [1:0] ati_be_i_input;
  logic  [1:0] ati_chksum_ctrl_i_input;
  logic [31:0] ati_data_i_input;
  logic  [8:0] ati_pbl_i_input;

  logic        ap_clk_local;
  logic        ari_ack_i_local;
  logic        ari_frameflush_i_local;
  logic        ati_ack_i_local;
  logic        ati_discrc_i_local;
  logic        ati_dispad_i_local;
  logic        ati_ena_timestamp_i_local;
  logic        ati_eof_i_local;
  logic        ati_sof_i_local;
  logic        ati_val_i_local;
  logic  [8:0] ari_pbl_i_local;
  logic  [1:0] ati_be_i_local;
  logic  [1:0] ati_chksum_ctrl_i_local;
  logic [31:0] ati_data_i_local;
  logic  [8:0] ati_pbl_i_local;

  event signal_input_ap_clk_change;
  event signal_input_ari_ack_i_change;
  event signal_input_ari_frameflush_i_change;
  event signal_input_ati_ack_i_change;
  event signal_input_ati_discrc_i_change;
  event signal_input_ati_dispad_i_change;
  event signal_input_ati_ena_timestamp_i_change;
  event signal_input_ati_eof_i_change;
  event signal_input_ati_sof_i_change;
  event signal_input_ati_val_i_change;
  event signal_input_ari_pbl_i_change;
  event signal_input_ati_be_i_change;
  event signal_input_ati_chksum_ctrl_i_change;
  event signal_input_ati_data_i_change;
  event signal_input_ati_pbl_i_change;

  reg        ari_eof_o_temp;
  reg        ari_rx_watermark_o_temp;
  reg        ari_rxstatus_val_o_temp;
  reg        ari_sof_o_temp;
  reg        ari_timestamp_val_o_temp;
  reg        ari_val_o_temp;
  reg        ati_rdy_o_temp;
  reg        ati_tx_watermark_o_temp;
  reg        ati_txstatus_val_temp;
  reg  [1:0] ari_be_o_temp;
  reg [31:0] ari_data_o_temp;
  reg [63:0] ati_timestamp_o_temp;
  reg [17:0] ati_txstatus_o_temp;


  // Return BFM version string. For example, version 9.1 sp1 is "9.1sp1" 
  function automatic string get_version();  // public
     string ret_version = "12.1";
     return ret_version;
  endfunction


  // Gets the ap_clk input value.
  function automatic ROLE_ap_clk_t get_ap_clk();
    $sformat(message, "%m: called get_ap_clk");
    print(VERBOSITY_DEBUG, message);
    return ap_clk_input;
  endfunction

  // Gets the ari_ack_i input value.
  function automatic ROLE_ari_ack_i_t get_ari_ack_i();
    $sformat(message, "%m: called get_ari_ack_i");
    print(VERBOSITY_DEBUG, message);
    return ari_ack_i_input;
  endfunction

  // Gets the ari_frameflush_i input value.
  function automatic ROLE_ari_frameflush_i_t get_ari_frameflush_i();
    $sformat(message, "%m: called get_ari_frameflush_i");
    print(VERBOSITY_DEBUG, message);
    return ari_frameflush_i_input;
  endfunction

  // Gets the ati_ack_i input value.
  function automatic ROLE_ati_ack_i_t get_ati_ack_i();
    $sformat(message, "%m: called get_ati_ack_i");
    print(VERBOSITY_DEBUG, message);
    return ati_ack_i_input;
  endfunction

  // Gets the ati_discrc_i input value.
  function automatic ROLE_ati_discrc_i_t get_ati_discrc_i();
    $sformat(message, "%m: called get_ati_discrc_i");
    print(VERBOSITY_DEBUG, message);
    return ati_discrc_i_input;
  endfunction

  // Gets the ati_dispad_i input value.
  function automatic ROLE_ati_dispad_i_t get_ati_dispad_i();
    $sformat(message, "%m: called get_ati_dispad_i");
    print(VERBOSITY_DEBUG, message);
    return ati_dispad_i_input;
  endfunction

  // Gets the ati_ena_timestamp_i input value.
  function automatic ROLE_ati_ena_timestamp_i_t get_ati_ena_timestamp_i();
    $sformat(message, "%m: called get_ati_ena_timestamp_i");
    print(VERBOSITY_DEBUG, message);
    return ati_ena_timestamp_i_input;
  endfunction

  // Gets the ati_eof_i input value.
  function automatic ROLE_ati_eof_i_t get_ati_eof_i();
    $sformat(message, "%m: called get_ati_eof_i");
    print(VERBOSITY_DEBUG, message);
    return ati_eof_i_input;
  endfunction

  // Gets the ati_sof_i input value.
  function automatic ROLE_ati_sof_i_t get_ati_sof_i();
    $sformat(message, "%m: called get_ati_sof_i");
    print(VERBOSITY_DEBUG, message);
    return ati_sof_i_input;
  endfunction

  // Gets the ati_val_i input value.
  function automatic ROLE_ati_val_i_t get_ati_val_i();
    $sformat(message, "%m: called get_ati_val_i");
    print(VERBOSITY_DEBUG, message);
    return ati_val_i_input;
  endfunction

  // Gets the ari_pbl_i input value.
  function automatic ROLE_ari_pbl_i_t get_ari_pbl_i();
    $sformat(message, "%m: called get_ari_pbl_i");
    print(VERBOSITY_DEBUG, message);
    return ari_pbl_i_input;
  endfunction

  // Gets the ati_be_i input value.
  function automatic ROLE_ati_be_i_t get_ati_be_i();
    $sformat(message, "%m: called get_ati_be_i");
    print(VERBOSITY_DEBUG, message);
    return ati_be_i_input;
  endfunction

  // Gets the ati_chksum_ctrl_i input value.
  function automatic ROLE_ati_chksum_ctrl_i_t get_ati_chksum_ctrl_i();
    $sformat(message, "%m: called get_ati_chksum_ctrl_i");
    print(VERBOSITY_DEBUG, message);
    return ati_chksum_ctrl_i_input;
  endfunction

  // Gets the ati_data_i input value.
  function automatic ROLE_ati_data_i_t get_ati_data_i();
    $sformat(message, "%m: called get_ati_data_i");
    print(VERBOSITY_DEBUG, message);
    return ati_data_i_input;
  endfunction

  // Gets the ati_pbl_i input value.
  function automatic ROLE_ati_pbl_i_t get_ati_pbl_i();
    $sformat(message, "%m: called get_ati_pbl_i");
    print(VERBOSITY_DEBUG, message);
    return ati_pbl_i_input;
  endfunction


  // Drive the new value to ari_eof_o.
  function automatic void set_ari_eof_o(ROLE_ari_eof_o_t new_value);
     $sformat(message, "%m: method called arg0 %0d", new_value); 
     print(VERBOSITY_DEBUG, message);
     ari_eof_o_temp = new_value;
  endfunction

  // Drive the new value to ari_rx_watermark_o.
  function automatic void set_ari_rx_watermark_o(ROLE_ari_rx_watermark_o_t new_value);
     $sformat(message, "%m: method called arg0 %0d", new_value); 
     print(VERBOSITY_DEBUG, message);
     ari_rx_watermark_o_temp = new_value;
  endfunction

  // Drive the new value to ari_rxstatus_val_o.
  function automatic void set_ari_rxstatus_val_o(ROLE_ari_rxstatus_val_o_t new_value);
     $sformat(message, "%m: method called arg0 %0d", new_value); 
     print(VERBOSITY_DEBUG, message);
     ari_rxstatus_val_o_temp = new_value;
  endfunction

  // Drive the new value to ari_sof_o.
  function automatic void set_ari_sof_o(ROLE_ari_sof_o_t new_value);
     $sformat(message, "%m: method called arg0 %0d", new_value); 
     print(VERBOSITY_DEBUG, message);
     ari_sof_o_temp = new_value;
  endfunction

  // Drive the new value to ari_timestamp_val_o.
  function automatic void set_ari_timestamp_val_o(ROLE_ari_timestamp_val_o_t new_value);
     $sformat(message, "%m: method called arg0 %0d", new_value); 
     print(VERBOSITY_DEBUG, message);
     ari_timestamp_val_o_temp = new_value;
  endfunction

  // Drive the new value to ari_val_o.
  function automatic void set_ari_val_o(ROLE_ari_val_o_t new_value);
     $sformat(message, "%m: method called arg0 %0d", new_value); 
     print(VERBOSITY_DEBUG, message);
     ari_val_o_temp = new_value;
  endfunction

  // Drive the new value to ati_rdy_o.
  function automatic void set_ati_rdy_o(ROLE_ati_rdy_o_t new_value);
     $sformat(message, "%m: method called arg0 %0d", new_value); 
     print(VERBOSITY_DEBUG, message);
     ati_rdy_o_temp = new_value;
  endfunction

  // Drive the new value to ati_tx_watermark_o.
  function automatic void set_ati_tx_watermark_o(ROLE_ati_tx_watermark_o_t new_value);
     $sformat(message, "%m: method called arg0 %0d", new_value); 
     print(VERBOSITY_DEBUG, message);
     ati_tx_watermark_o_temp = new_value;
  endfunction

  // Drive the new value to ati_txstatus_val.
  function automatic void set_ati_txstatus_val(ROLE_ati_txstatus_val_t new_value);
     $sformat(message, "%m: method called arg0 %0d", new_value); 
     print(VERBOSITY_DEBUG, message);
     ati_txstatus_val_temp = new_value;
  endfunction

  // Drive the new value to ari_be_o.
  function automatic void set_ari_be_o(ROLE_ari_be_o_t new_value);
     $sformat(message, "%m: method called arg0 %0d", new_value); 
     print(VERBOSITY_DEBUG, message);
     ari_be_o_temp = new_value;
  endfunction

  // Drive the new value to ari_data_o.
  function automatic void set_ari_data_o(ROLE_ari_data_o_t new_value);
     $sformat(message, "%m: method called arg0 %0d", new_value); 
     print(VERBOSITY_DEBUG, message);
     ari_data_o_temp = new_value;
  endfunction

  // Drive the new value to ati_timestamp_o.
  function automatic void set_ati_timestamp_o(ROLE_ati_timestamp_o_t new_value);
     $sformat(message, "%m: method called arg0 %0d", new_value); 
     print(VERBOSITY_DEBUG, message);
     ati_timestamp_o_temp = new_value;
  endfunction

  // Drive the new value to ati_txstatus_o.
  function automatic void set_ati_txstatus_o(ROLE_ati_txstatus_o_t new_value);
     $sformat(message, "%m: method called arg0 %0d", new_value); 
     print(VERBOSITY_DEBUG, message);
     ati_txstatus_o_temp = new_value;
  endfunction


  assign ap_clk_input = ap_clk;
  assign ari_ack_i_input = ari_ack_i;
  assign ari_frameflush_i_input = ari_frameflush_i;
  assign ati_ack_i_input = ati_ack_i;
  assign ati_discrc_i_input = ati_discrc_i;
  assign ati_dispad_i_input = ati_dispad_i;
  assign ati_ena_timestamp_i_input = ati_ena_timestamp_i;
  assign ati_eof_i_input = ati_eof_i;
  assign ati_sof_i_input = ati_sof_i;
  assign ati_val_i_input = ati_val_i;
  assign ari_pbl_i_input = ari_pbl_i;
  assign ati_be_i_input = ati_be_i;
  assign ati_chksum_ctrl_i_input = ati_chksum_ctrl_i;
  assign ati_data_i_input = ati_data_i;
  assign ati_pbl_i_input = ati_pbl_i;

  assign ari_eof_o = ari_eof_o_temp;
  assign ari_rx_watermark_o = ari_rx_watermark_o_temp;
  assign ari_rxstatus_val_o = ari_rxstatus_val_o_temp;
  assign ari_sof_o = ari_sof_o_temp;
  assign ari_timestamp_val_o = ari_timestamp_val_o_temp;
  assign ari_val_o = ari_val_o_temp;
  assign ati_rdy_o = ati_rdy_o_temp;
  assign ati_tx_watermark_o = ati_tx_watermark_o_temp;
  assign ati_txstatus_val = ati_txstatus_val_temp;
  assign ari_be_o = ari_be_o_temp;
  assign ari_data_o = ari_data_o_temp;
  assign ati_timestamp_o = ati_timestamp_o_temp;
  assign ati_txstatus_o = ati_txstatus_o_temp;


  always @(ap_clk_input) begin
    if (ap_clk_local!=ap_clk_input)
      -> signal_input_ap_clk_change;
    ap_clk_local = ap_clk_input;
  end

  always @(ari_ack_i_input) begin
    if (ari_ack_i_local!=ari_ack_i_input)
      -> signal_input_ari_ack_i_change;
    ari_ack_i_local = ari_ack_i_input;
  end

  always @(ari_frameflush_i_input) begin
    if (ari_frameflush_i_local!=ari_frameflush_i_input)
      -> signal_input_ari_frameflush_i_change;
    ari_frameflush_i_local = ari_frameflush_i_input;
  end

  always @(ati_ack_i_input) begin
    if (ati_ack_i_local!=ati_ack_i_input)
      -> signal_input_ati_ack_i_change;
    ati_ack_i_local = ati_ack_i_input;
  end

  always @(ati_discrc_i_input) begin
    if (ati_discrc_i_local!=ati_discrc_i_input)
      -> signal_input_ati_discrc_i_change;
    ati_discrc_i_local = ati_discrc_i_input;
  end

  always @(ati_dispad_i_input) begin
    if (ati_dispad_i_local!=ati_dispad_i_input)
      -> signal_input_ati_dispad_i_change;
    ati_dispad_i_local = ati_dispad_i_input;
  end

  always @(ati_ena_timestamp_i_input) begin
    if (ati_ena_timestamp_i_local!=ati_ena_timestamp_i_input)
      -> signal_input_ati_ena_timestamp_i_change;
    ati_ena_timestamp_i_local = ati_ena_timestamp_i_input;
  end

  always @(ati_eof_i_input) begin
    if (ati_eof_i_local!=ati_eof_i_input)
      -> signal_input_ati_eof_i_change;
    ati_eof_i_local = ati_eof_i_input;
  end

  always @(ati_sof_i_input) begin
    if (ati_sof_i_local!=ati_sof_i_input)
      -> signal_input_ati_sof_i_change;
    ati_sof_i_local = ati_sof_i_input;
  end

  always @(ati_val_i_input) begin
    if (ati_val_i_local!=ati_val_i_input)
      -> signal_input_ati_val_i_change;
    ati_val_i_local = ati_val_i_input;
  end

  always @(ari_pbl_i_input) begin
    if (ari_pbl_i_local!=ari_pbl_i_input)
      -> signal_input_ari_pbl_i_change;
    ari_pbl_i_local = ari_pbl_i_input;
  end

  always @(ati_be_i_input) begin
    if (ati_be_i_local!=ati_be_i_input)
      -> signal_input_ati_be_i_change;
    ati_be_i_local = ati_be_i_input;
  end

  always @(ati_chksum_ctrl_i_input) begin
    if (ati_chksum_ctrl_i_local!=ati_chksum_ctrl_i_input)
      -> signal_input_ati_chksum_ctrl_i_change;
    ati_chksum_ctrl_i_local = ati_chksum_ctrl_i_input;
  end

  always @(ati_data_i_input) begin
    if (ati_data_i_local!=ati_data_i_input)
      -> signal_input_ati_data_i_change;
    ati_data_i_local = ati_data_i_input;
  end

  always @(ati_pbl_i_input) begin
    if (ati_pbl_i_local!=ati_pbl_i_input)
      -> signal_input_ati_pbl_i_change;
    ati_pbl_i_local = ati_pbl_i_input;
  end

// synthesis translate_on
endmodule
