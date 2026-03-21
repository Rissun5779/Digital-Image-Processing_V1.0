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




//===========================================================================
// This confidential and proprietary software may be used only as authorized
// by a licensing agreement from ALTERA
// copyright notice must be reproduced on all authorized copies.
//============================================================================

//============================================================================
// Reconfig PCS State Machine
// Generates data address and control signals to AVMM master SM
//============================================================================

`timescale 1 ps / 1 ps

module rcfg_s10_pcs_ctrl
  #(
  parameter ROM_ADDR_DEPTH   = 6       // Synthesize/include the AN or LT
  )  (
  input  wire        clk,
  input  wire        reset,
     // PCS reconfig requests
  input  wire           seq_start_rc,   // start the PCS reconfig
  input  wire [4:3]     pcs_mode_rc,    // PCS mode for reconfig - 1 hot
                                        // bit 0 = AN mode = low_lat, PLL LTR
                                        // bit 1 = LT mode = low_lat, PLL LTD
                                        // bit 2 = 10G data mode = 10GBASE-R
                                        // bit 3 = GigE data mode = 8G PCS
                                        // bit 4 = XAUI data mode = future?
                                        // bit 5 = 10G-FEC
  output reg            rc_busy,        // reconfig is busy
  input  wire           skip_cal,       // skip the calibration
    //  AVMM master State Machine
  input  wire       ctrl_busy,
  output wire       refclk_req,
  output wire       cgb_req,
  output wire       cal_req,             // calibration operation
  output wire       refclk_sel,          // 0 = clock 0 = 10G clock
  output wire       cgb_sel,             // 1 = clock 1 = 1G clock
  output wire       cal_sel,             // 1 = offset 0x100, 0 = offset 0x0
  output wire       avmm_req,            // 1 = release bus, 0 = request bus
    //  HSSI
  input  wire       calibration_busy,
  output reg        start_reset_ctrl,
  input  wire       tx_analogreset_ack,
  input  wire       rx_analogreset_ack,
  input  wire       tx_digitalreset_ack,
  input  wire       rx_digitalreset_ack,
    // HSSI Reconfig data
  input  wire       last_data,
  output reg [ROM_ADDR_DEPTH-1:0]  pcs_data_addr,
  output wire       en_next
  );

//============================================================================
//  input Handshaking
//============================================================================
  reg       start_dly;
  reg       start_edge;  // rising edge of start
  reg       busy_dly;
  reg       busy_edge;   // falling edge of busy
  reg       wtrqst_dly;


  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      start_dly  <= 1'b0;
      start_edge <= 1'b0;
      busy_dly   <= 1'b0;
      busy_edge  <= 1'b0;
      wtrqst_dly <= 1'b0;
      end
    else begin
      start_dly  <=  seq_start_rc;
      start_edge <=  seq_start_rc & ~start_dly;
      busy_dly   <=  ctrl_busy;
      busy_edge  <= ~ctrl_busy & busy_dly;
      end
  end

  wire       cal_busy;
  reg        cal_busy_dly  = 1'b0;
  reg        cal_busy_edge = 1'b0;   // falling edge of busy
  reg [4:3]  pcs_mdreg     = 2'b0;   // register for easier fitting
  
  // synchronize the cal_busy input
  alt_eth_resync_nocut  #(
      .WIDTH            (1)  // Number of bits to resync
  ) busy_sync (
    .clk    (clk),
    .reset  (reset),
    .d      (calibration_busy),
    .q      (cal_busy)
  );

  always @(posedge clk) begin
    cal_busy_dly  <=  cal_busy;
    cal_busy_edge <= ~cal_busy & cal_busy_dly;
    pcs_mdreg     <=  pcs_mode_rc;
  end

//============================================================================
//  Control State Machine
//============================================================================
  localparam [3:0] IDLE      = 4'd0;    // wait for rc_start
  localparam [3:0] REQ_AVMM  = 4'd1;    // Request access to AVMM
  localparam [3:0] RC_1G     = 4'd2;    // Reconfig into 1G mode
  localparam [3:0] REF_1G    = 4'd3;    // change refclk for 1G mode
  localparam [3:0] CGB_1G    = 4'd4;    // change clock block for 1G mdoe
  localparam [3:0] RC_10G    = 4'd5;    // Reconfig into one of the 10G modes
  localparam [3:0] REF_10G   = 4'd6;    // change refclk for 10G mode
  localparam [3:0] CGB_10G   = 4'd7;    // change clock block for 10G mode
  localparam [3:0] CAL_REQ   = 4'd8;    // Request Calibration
  localparam [3:0] CAL_GIVE  = 4'd9;    // Give control of HSSI bus to NIOS
  localparam [3:0] WAIT_RST  = 4'd10;   // cal busy done to clear analog rst
  localparam [3:0] RST_ANA   = 4'd11;   // Wait for clear analog reset
  localparam [3:0] WAIT_STAT = 4'd12;   // wait for all _stat to be low - before starting reset
  localparam [3:0] DONE      = 4'd13;   // Handshake for rc_start
  localparam [3:0] REQ_RST   = 4'd14;   // wait for _ack signal before proceeding for reset

  reg [3:0]  pcs_state;
  reg [3:0]  pcs_next_state;
  reg        set_reset_active;          // reset both analog and digital

    // state register
  always_ff @(posedge clk or posedge reset) begin
   if (reset)
     pcs_state <= IDLE;
   else
     pcs_state <= pcs_next_state;
  end

    // next state logic
// When not supporting 1G mode following state are not needed and hence skipped in next state logic
// 1G specific --> RC_1G, REF_1G, CGB_1G
// Clock/CGB swtch --> REF_10G,CGB_10G 
// jump to CAL_REQ/CAL_GIVE after RC_10G
  always_comb begin
    set_reset_active = 1'b0;
    case(pcs_state)
      IDLE: begin
           if     (start_edge)
            pcs_next_state  = WAIT_STAT;
          else
            pcs_next_state = IDLE;
          end
      WAIT_STAT : begin
           if     (tx_analogreset_ack | rx_analogreset_ack | tx_digitalreset_ack | rx_digitalreset_ack)
            pcs_next_state  = WAIT_STAT;
          else
            pcs_next_state = REQ_RST;
          end
      REQ_RST: begin
            set_reset_active = 1'b1;
           if (tx_analogreset_ack & rx_analogreset_ack) 
            pcs_next_state   = REQ_AVMM;
           else
            pcs_next_state   = REQ_RST;
          end
      REQ_AVMM: begin
            set_reset_active = 1'b1;
           if     (busy_edge & pcs_mdreg[3]) begin
            pcs_next_state   = RC_1G;
            end
          else if (busy_edge & ~pcs_mdreg[4]) begin
            pcs_next_state = RC_10G;
            end
          else
            pcs_next_state = REQ_AVMM;
          end
      RC_1G: begin
            set_reset_active = 1'b1;
           if (busy_edge & last_data)
            pcs_next_state = REF_1G;
          else
            pcs_next_state = RC_1G;
          end
      REF_1G: begin
            set_reset_active = 1'b1;
           if (busy_edge)
            pcs_next_state = CGB_1G;
          else
            pcs_next_state = REF_1G;
          end
      CGB_1G: begin
            set_reset_active = 1'b1;
           if (busy_edge & skip_cal)
            pcs_next_state = CAL_GIVE;
           else if (busy_edge)
             pcs_next_state = CAL_REQ;
          else
            pcs_next_state = CGB_1G;
          end
      RC_10G: begin
            set_reset_active = 1'b1;
           if (busy_edge & last_data & skip_cal)
            pcs_next_state = CAL_GIVE;
           else if (busy_edge & last_data)
             pcs_next_state = CAL_REQ;
          else
            pcs_next_state = RC_10G;
          end
      REF_10G: begin
            set_reset_active = 1'b1;
           if (busy_edge)
            pcs_next_state = CGB_10G;
          else
            pcs_next_state = REF_10G;
          end
      CGB_10G: begin
            set_reset_active = 1'b1;
           if (busy_edge & skip_cal)
            pcs_next_state = CAL_GIVE;
           else if (busy_edge)
             pcs_next_state = CAL_REQ;
          else
            pcs_next_state = CGB_10G;
          end
      CAL_REQ: begin
            set_reset_active = 1'b1;
           if (busy_edge)
            pcs_next_state = CAL_GIVE;
          else
            pcs_next_state = CAL_REQ;
          end
      CAL_GIVE: begin
            set_reset_active = 1'b1;
           if (busy_edge)
            pcs_next_state = WAIT_RST;
          else
            pcs_next_state = CAL_GIVE;
          end
      WAIT_RST: begin
            set_reset_active = 1'b1;
           if (cal_busy_edge | skip_cal)
            pcs_next_state  = RST_ANA;
          else
            pcs_next_state = WAIT_RST;
          end
      RST_ANA: begin
           set_reset_active = 1'b0;
          if (~tx_digitalreset_ack & ~rx_digitalreset_ack)
            pcs_next_state = DONE; // Skip rest state since we have reset controller
          else
            pcs_next_state = RST_ANA; 
          end
      DONE: begin
           if (~start_dly)
            pcs_next_state = IDLE;
          else
            pcs_next_state = DONE;
          end
      default : begin
        pcs_next_state = IDLE;
        set_reset_active = 1'b0;
        end
    endcase
  end

//============================================================================
//  reconfig data address
//============================================================================
  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      pcs_data_addr <= {ROM_ADDR_DEPTH{1'b0}};
    else if ((pcs_state == IDLE) || (pcs_state == REQ_AVMM))
      pcs_data_addr <= {ROM_ADDR_DEPTH{1'b0}};
    else if (~ctrl_busy & busy_dly & ~last_data)
      pcs_data_addr <= pcs_data_addr + 1'b1;
  end

//============================================================================
//  keep reset for reset controller asserted until MIF + CAL 
//============================================================================

  always_ff @(posedge clk)
  start_reset_ctrl <= set_reset_active ;	  

//============================================================================
//  outputs
//============================================================================
  always_ff @(posedge clk or posedge reset) begin
    if (reset) rc_busy <= 1'b0;
    else       rc_busy <= (pcs_next_state != IDLE);
  end

  assign refclk_req = ~busy_dly & ~busy_edge && 
                           ((pcs_state == REF_1G)  || (pcs_state == REF_10G));
  assign cgb_req    = ~busy_dly & ~busy_edge && 
                           ((pcs_state == CGB_1G)  || (pcs_state == CGB_10G));
  assign cal_req    = ~busy_dly & ~busy_edge && ( (pcs_state == REQ_AVMM) ||
                            (pcs_state == CAL_REQ) || (pcs_state == CAL_GIVE));
  assign refclk_sel = (pcs_state == REF_1G);
  assign cgb_sel    = (pcs_state == CGB_1G);
  assign cal_sel    = (pcs_state == CAL_REQ);
  assign avmm_req   = (pcs_state != REQ_AVMM);

  assign en_next    = 
                (busy_edge &&
                  ((pcs_next_state == RC_1G) || (pcs_next_state == RC_10G)));

endmodule // rcfg_s10_pcs_ctrl
