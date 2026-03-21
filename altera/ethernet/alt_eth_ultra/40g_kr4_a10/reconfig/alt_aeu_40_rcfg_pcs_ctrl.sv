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

module alt_aeu_40_rcfg_pcs_ctrl
   (
  input  wire        clk,
  input  wire        reset,
     // PCS reconfig requests
  input  wire           seq_start_rc,   // start the PCS reconfig
  input  wire [5:0]     pcs_mode_rc,    // PCS mode for reconfig - 1 hot
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
  input  wire       rx_cdr_locked,
  output reg        analog_reset,
  output wire       analog_reset_tx,
  output wire       digital_reset,
  output wire       digital_reset_tx,
  input  wire       tx_analogreset_ack,
  input  wire       rx_analogreset_ack,
    // HSSI Reconfig data
  input  wire       last_data,
  output reg [5:0]  pcs_data_addr,
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

  reg        analogreset_ctr;

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
  reg [5:0]  pcs_mdreg     = 6'b0;   // register for easier fitting
  
  // synchronize the cal_busy input
  alt_xcvr_resync #(
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

// keep track of which pcs_mode you are coming from
  reg [5:0]  pcs_mdreg_old = 2'b0;   // register for easier fitting
  always @(posedge clk) begin
     if (pcs_mdreg != pcs_mode_rc)
      pcs_mdreg_old <= pcs_mdreg ;	     
  end

// we need updated reset, and skip cal only if we are going from AN/LT to 10G/FEC  
  reg short_rst_nocal;	
  always @ (posedge clk)
    short_rst_nocal <= (|pcs_mdreg_old[1:0]) & (pcs_mdreg[2] | pcs_mdreg[5]) ;

  reg        digital_reset_tx_d, digital_reset_tx_long;
  assign analog_reset_tx  =  short_rst_nocal ? 1'b0 : analog_reset ;
  assign digital_reset_tx =  short_rst_nocal ? digital_reset_tx_d : digital_reset_tx_long ; 
  assign digital_reset    =  digital_reset_tx_long ; 

  wire skip_cal1;
  assign skip_cal1 = skip_cal | short_rst_nocal ;
//============================================================================
//  Control State Machine
//============================================================================
  localparam [4:0] IDLE      = 5'd0;    // wait for rc_start
  localparam [4:0] REQ_AVMM  = 5'd1;    // Request access to AVMM
  localparam [4:0] RC_1G     = 5'd2;    // Reconfig into 1G mode
  localparam [4:0] REF_1G    = 5'd3;    // change refclk for 1G mode
  localparam [4:0] CGB_1G    = 5'd4;    // change clock block for 1G mdoe
  localparam [4:0] RC_10G    = 5'd5;    // Reconfig into one of the 10G modes
  localparam [4:0] REF_10G   = 5'd6;    // change refclk for 10G mode
  localparam [4:0] CGB_10G   = 5'd7;    // change clock block for 10G mode
  localparam [4:0] CAL_REQ   = 5'd8;    // Request Calibration
  localparam [4:0] CAL_GIVE  = 5'd9;    // Give control of HSSI bus to NIOS
  localparam [4:0] WAIT_RST  = 5'd10;   // cal busy done to clear analog rst
  localparam [4:0] RST_ANA   = 5'd11;   // Wait for clear analog reset
  localparam [4:0] WAIT_CDR  = 5'd12;   // rx_locked to clear digital rst
  localparam [4:0] RST_DIG   = 5'd13;   // Wait for clear digital reset
  localparam [4:0] DONE      = 5'd14;   // Handshake for rc_start
  localparam [4:0] REQ_RST   = 5'd15;   // wait for _ack signal before proceeding for reset
  localparam [4:0] DEAST_RST = 5'd16;   // wait for _ack signal before proceeding for reset

  reg [4:0]  pcs_state;
  reg [4:0]  pcs_next_state;
  reg [2:0]  rst_ana_cntr;              // hold analog reset after cal
  reg [9:0]  rst_dig_cntr;              // hold digital reset after analog
  reg        set_reset_active;          // reset both analog and digital
  reg        set_reset_active_tx_d;     // reset tx digital
  reg        clr_reset_tx_d;            // clear digitial reset 

    // state register
  always_ff @(posedge clk or posedge reset) begin
   if (reset)
     pcs_state <= IDLE;
   else
     pcs_state <= pcs_next_state;
  end

    // next state logic
  always_comb begin
    set_reset_active = 1'b0;
    set_reset_active_tx_d = 1'b0;
    clr_reset_tx_d = 1'b0;
    case(pcs_state)
      IDLE: begin
           if     (start_edge)
            pcs_next_state  = REQ_RST;
          else
            pcs_next_state = IDLE;
          end
      REQ_RST: begin
            set_reset_active = 1'b1;
           //if (tx_analogreset_ack & rx_analogreset_ack) 
           if (analogreset_ctr) 
            pcs_next_state   = REQ_AVMM;
           else
            pcs_next_state   = REQ_RST;
          end
      REQ_AVMM: begin
            set_reset_active_tx_d = 1'b1;
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
           if (busy_edge & last_data)
            pcs_next_state = REF_1G;
          else
            pcs_next_state = RC_1G;
          end
      REF_1G: begin
           if (busy_edge)
            pcs_next_state = CGB_1G;
          else
            pcs_next_state = REF_1G;
          end
      CGB_1G: begin
           if (busy_edge & skip_cal1)
            pcs_next_state = CAL_GIVE;
           else if (busy_edge)
             pcs_next_state = CAL_REQ;
          else
            pcs_next_state = CGB_1G;
          end
      RC_10G: begin
           if (busy_edge & last_data)
            pcs_next_state = REF_10G;
          else
            pcs_next_state = RC_10G;
          end
      REF_10G: begin
           if (busy_edge)
            pcs_next_state = CGB_10G;
          else
            pcs_next_state = REF_10G;
          end
      CGB_10G: begin
           if (busy_edge & skip_cal1)
            pcs_next_state = CAL_GIVE;
           else if (busy_edge)
             pcs_next_state = CAL_REQ;
          else
            pcs_next_state = CGB_10G;
          end
      CAL_REQ: begin
           if (busy_edge)
            pcs_next_state = CAL_GIVE;
          else
            pcs_next_state = CAL_REQ;
          end
      CAL_GIVE: begin
           if (busy_edge)
            pcs_next_state = WAIT_RST;
          else
            pcs_next_state = CAL_GIVE;
          end
      WAIT_RST: begin
           if (cal_busy_edge | skip_cal1)
            pcs_next_state  = RST_ANA;
          else
            pcs_next_state = WAIT_RST;
          end
      RST_ANA: begin
           clr_reset_tx_d = 1'b1;
           if (&rst_ana_cntr)
            pcs_next_state = DEAST_RST;
          else
            pcs_next_state = RST_ANA; 
          end
      DEAST_RST: begin
           //if (tx_analogreset_ack | rx_analogreset_ack) 
           if (~analogreset_ctr) 
            pcs_next_state = DEAST_RST;
          else
            pcs_next_state = WAIT_CDR; 
          end
      WAIT_CDR: begin
           if (rx_cdr_locked)
            pcs_next_state = RST_DIG;
          else
            pcs_next_state = WAIT_CDR;
          end
      RST_DIG: begin
           if (&rst_dig_cntr)
            pcs_next_state = DONE;
          else
            pcs_next_state = RST_DIG;
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
        set_reset_active_tx_d= 1'b0;
        clr_reset_tx_d = 1'b0;
        end
    endcase
  end

//============================================================================
//  reconfig data address
//============================================================================
  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      pcs_data_addr <= 6'b0;
    else if ((pcs_state == IDLE) || (pcs_state == REQ_AVMM))
      pcs_data_addr <= 6'b0;
    else if (~ctrl_busy & busy_dly & ~last_data)
      pcs_data_addr <= pcs_data_addr + 1'b1;
  end

//============================================================================
//  reset counters to hold resets active
//============================================================================
  always_ff @(posedge clk or posedge reset) begin
    if (reset)                     rst_dig_cntr <= 'd0;
    else if (pcs_state != RST_DIG) rst_dig_cntr <= 'd0;
    else                           rst_dig_cntr <= rst_dig_cntr + 1'b1;
  end

  always_ff @(posedge clk or posedge reset) begin
    if (reset)                     rst_ana_cntr <= 'd0;
    else if (pcs_state != RST_ANA) rst_ana_cntr <= 'd0;
    else                           rst_ana_cntr <= rst_ana_cntr + 1'b1;
  end

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      analog_reset  <=0;
      digital_reset_tx_long <=0;
      digital_reset_tx_d <=0;
    end else begin
      analog_reset  <= set_reset_active | (analog_reset  & ~&rst_ana_cntr);
      digital_reset_tx_long <= set_reset_active | (digital_reset_tx_long & ~&rst_dig_cntr);
      digital_reset_tx_d <= set_reset_active_tx_d | (digital_reset_tx_d & ~clr_reset_tx_d);
    end
  end

  reg [12:0] cntr_reset_64us; // count 8191 cycles of 125MZ- i.e ~64us
// start counter only after detecting _ack
// detect _ack high for assertion; _ack low for de-assertion
`ifdef ALTERA_RESERVED_XCVR_FULL_KR_TIMERS
   localparam CNT_64us = 13'h1FFF;
`else // not FULL_KR_TIMERS  
   localparam CNT_64us = 13'h001F;
`endif // FULL_KR_TIMERS

  always_ff @ (posedge clk)
    if ((pcs_state!=REQ_RST) && (pcs_state!=DEAST_RST))
     cntr_reset_64us <= 13'b0;
    else if (((pcs_state==REQ_RST) & rx_analogreset_ack) || ((pcs_state==DEAST_RST) & ~rx_analogreset_ack))
     cntr_reset_64us <= cntr_reset_64us + 1'b1;
  
     
  always_ff @ (posedge clk)
    if (cntr_reset_64us== CNT_64us )  
    analogreset_ctr <= 1'b1;     
    else     
    analogreset_ctr <= 1'b0;     

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

  assign en_next    = ((pcs_state == IDLE) && (pcs_next_state != IDLE)) ||
                (busy_edge &&
                  ((pcs_next_state == RC_1G) || (pcs_next_state == RC_10G)));

endmodule // alt_aeu_40_rcfg_pcs_ctrl
