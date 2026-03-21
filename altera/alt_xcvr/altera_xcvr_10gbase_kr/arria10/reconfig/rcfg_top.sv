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




//============================================================================
// This confidential and proprietary software may be used only as authorized
// by a licensing agreement from ALTERA 
// copyright notice must be reproduced on all authorized copies.
//============================================================================

//============================================================================
// Reconfig Top
// Contains the reconfiguration logic for PCS and PMA reconfiguration
// for a single channel via an Avalon-MM interface
//============================================================================

`timescale 1 ps / 1 ps

module rcfg_top
    #(
  parameter ES_DEVICE        = 1,       // select ES or PROD device
  parameter LTD_MSB          = 8'd100,  // Link Fail Timer lsb for BASE-X PCS
  parameter SYNTH_LT         = 1,       // Synthesize/include the LT module
  parameter SYNTH_AN_LT      = 1,       // Synthesize/include the AN or LT
  parameter SYNTH_GIGE       = 1,       // Synthesize/include the GIGE logic
  parameter SYNTH_FEC        = 1,       // Synthesize/include the FEC logic
  parameter SYNTH_1588       = 1,       // Synthesize/include the 1588 mode
  parameter REF_CLK          = 1        // CDR Reference clock = 644, else 322
    ) (
  input  wire           mgmt_clk,       // managemnt/reconfig clock
  input  wire           mgmt_clk_reset, // managemnt/reconfig reset
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
     // PMA reconfig requests
  input  wire            lt_start_rc,   // start the TX EQ reconfig
  input  wire [4:0]      main_rc,       // main tap value for reconfig
  input  wire [5:0]      post_rc,       // post tap value for reconfig
  input  wire [4:0]      pre_rc,        // pre tap value for reconfig
  input  wire [2:0]      tap_to_upd,    // specific TX EQ tap to update
                                        // bit-2 = main, bit-1 = post, ...
     // HSSI control
  input  wire       calibration_busy,   // HSSI cal busy
  input  wire       rx_is_lockedtodata, // HSSI rx_is_lockedtodata
  input  wire       rx_is_lockedtoref , // HSSI rx_is_lockedtoref 
  output reg        analog_reset,       // HSSI reset
  output wire       analog_reset_tx,    // HSSI TX Reset
  output reg        digital_reset,      // HSSI rest
  output reg        digital_reset_tx,
  input  wire       tx_analogreset_ack,
  input  wire       rx_analogreset_ack,
     // HSSI Reconfig master
  output wire            xcvr_rcfg_write,   // AVMM write
  output wire            xcvr_rcfg_read,    // AVMM read
  output wire [9:0]      xcvr_rcfg_address, // AVMM address
  output wire [7:0]      xcvr_rcfg_wrdata,  // AVMM write data
  input  wire [7:0]      xcvr_rcfg_rddata,  // AVMM read data
  input  wire            xcvr_rcfg_wtrqst   // AVMM wait request
  );


//===========================================================================
// Define Wires and Variables
//===========================================================================
     //  PCS Controllers
  wire [9:0]      pcs_addr;
  wire [7:0]      pcs_writedata;
  wire [7:0]      pcs_datamask;
  wire            pcs_write;
  wire            refclk_req;
  wire            cgb_req;
  wire            refclk_sel;
  wire            cgb_sel;
  wire            pcs_rc_busy;
  wire            cal_req;
  wire            cal_sel;
  wire            avmm_req;
  wire            rx_cdr_is_locked;
  wire            rx_locked;
     //  Reconfig data
  wire            last_data;
  wire [5:0]      pcs_data_addr;
  wire            en_next;
     //  PMA Controller
  wire            pma_rc_busy;
  wire            pma_write;
  wire            pma_rmw;
  wire [9:0]      pma_addr;
  wire [7:0]      pma_writedata;
  wire [7:0]      pma_datamask;
     //  AVMM signals 
  wire [9:0]      ctrl_addr;
  wire [7:0]      ctrl_writedata;
  wire [7:0]      ctrl_datamask;
  wire            ctrl_write;
  wire            ctrl_rmw;
  wire            ctrl_busy;

//===========================================================================
// Combine the signals
//===========================================================================
  assign rc_busy    =                  pcs_rc_busy    | pma_rc_busy;
// Change RTL to mux between  pcs, and pma add/data/ctrl - in case pma bus retains previous
  assign ctrl_write = pcs_rc_busy ? pcs_write  : pma_write;
  assign ctrl_addr  = pcs_rc_busy ? pcs_addr   : pma_addr;
  assign ctrl_writedata =
                  pcs_rc_busy ? pcs_writedata : pma_writedata;
  assign ctrl_datamask = 
                   pcs_rc_busy ? pcs_datamask : pma_datamask;

  // synchronize async signals
  //  \p4\ip\altera_xcvr_generic\ctrl\alt_xcvr_resync.sv
  alt_xcvr_resync #(
    .WIDTH  (1)       // Number of bits to resync
  ) locked_resync (
    .clk    (mgmt_clk),
    .reset  (mgmt_clk_reset),
    .d      (rx_is_lockedtodata),
    .q      (rx_cdr_is_locked)
  );

 
  // logic to make sure LTR is table high for 500 us
  // LSB counter counts to 1000, and MSB counter max value is calculated in tcl
  // increment counter on high rx_is_lockedtoref, clear it moment rx_is_lockedtoref is low , freeze on highest count
  // reuse existing parameter LTD_MSB - just just stage_one_max_count to 500 to make it for 500us, instead of 1ms
  // may be eventually this can be improved to check LTR/LTD-depending upon mode
  reg [9:0] stage_one;  // stage one, count 1000 clocks
  reg  stage_one_max;   // stage one at max count
  reg [7:0] stage_two; // second stage, count till LTD_MSB
  reg stage_two_max;   // stage two at max count
  wire [8:0] stage_one_max_count ;
  wire [7:0] stage_two_max_count ;
  reg        ltr_ok_500us;

`ifdef ALTERA_RESERVED_XCVR_FULL_KR_TIMERS
   assign stage_one_max_count = 500 ;
   assign stage_two_max_count = LTD_MSB;
`else // not FULL_KR_TIMERS  
   assign stage_one_max_count = 10 ;
   assign stage_two_max_count = 2;
`endif // FULL_KR_TIMERS

  always_ff @(posedge mgmt_clk) begin
    if (~rx_is_lockedtoref) 
      stage_one     <= 10'd0;
    else if (stage_one==stage_one_max_count)
      stage_one     <= 10'd0;
    else if (stage_one!=stage_one_max_count) 
      stage_one <= stage_one + 1'b1;
  end //always

  always_ff @(posedge mgmt_clk) begin
    if (~rx_is_lockedtoref) 
      stage_two     <= 10'd0;
    else if ((stage_two!=stage_two_max_count) && (stage_one==stage_one_max_count) )
      stage_two <= stage_two + 1'b1;
  end //always
  
  always @ (posedge mgmt_clk)
    ltr_ok_500us <= (stage_two==stage_two_max_count) ;	 
 
  // condition rx_cdr_locked to hold digital_reset active until CDR is locked
  assign rx_locked = ( pcs_mode_rc[0] & ltr_ok_500us)  | rx_cdr_is_locked;

//===========================================================================
// Instantiate the PMA TX controllers
//===========================================================================
generate
  if (SYNTH_LT) begin: PMA_RC
    // TX Equalization
    rcfg_txeq_ctrl  rcfg_txeq_ctrl_inst (
      .clk            (mgmt_clk),
      .reset          (mgmt_clk_reset),
        // PCS reconfig requests
      .lt_start_rc   (lt_start_rc),
      .main_rc       (main_rc),
      .post_rc       (post_rc),
      .pre_rc        (pre_rc),
      .tap_to_upd    (tap_to_upd),
      .rc_busy       (pma_rc_busy),
        // AVMM master
      .ctrl_addr      (pma_addr),
      .ctrl_writedata (pma_writedata),
      .ctrl_datamask  (pma_datamask),
      .ctrl_write     (pma_write),
      .ctrl_rmw       (pma_rmw),
      .ctrl_busy      (ctrl_busy)
    );
  end // PMA_RC
  else begin: NO_PMA
    assign pma_rc_busy = 1'b0;
    assign pma_addr    = 10'b0;
    assign pma_write   = 1'b0;
    assign pma_rmw     = 1'b0;
    assign pma_writedata  = 8'b0;
    assign pma_datamask   = 8'b0;
  end
endgenerate

//===========================================================================
// Instantiate the PCS controller
//===========================================================================
rcfg_pcs_ctrl  rcfg_pcs_ctrl_inst (
  .clk            (mgmt_clk),
  .reset          (mgmt_clk_reset),
    // PCS reconfig requests
  .seq_start_rc   (seq_start_rc),
  .pcs_mode_rc    (pcs_mode_rc),
  .rc_busy        (pcs_rc_busy),
  .skip_cal       (skip_cal),
    // to the AVMM master
  .ctrl_busy      (ctrl_busy),
  .refclk_req     (refclk_req),
  .cgb_req        (cgb_req),
  .cal_req        (cal_req),
  .refclk_sel     (refclk_sel),
  .cgb_sel        (cgb_sel),
  .cal_sel        (cal_sel),
  .avmm_req       (avmm_req),
    // HSSI control
  .calibration_busy  (calibration_busy),
  .rx_cdr_locked     (rx_locked),
  .analog_reset      (analog_reset),
  .analog_reset_tx   (analog_reset_tx),
  .digital_reset     (digital_reset),
  .digital_reset_tx  (digital_reset_tx),
  .tx_analogreset_ack(tx_analogreset_ack),
  .rx_analogreset_ack(rx_analogreset_ack),
    // Reconfig Data
  .last_data      (last_data),
  .pcs_data_addr  (pcs_data_addr),
  .en_next        (en_next)
);

//===========================================================================
// Instantiate the Reconfig data
// have 8 different images depending upon the modes
// Some images have 3 sets of data, some have 4 depending upon FEC
// Images may have 2 copies of the data sets, one with AN/LT and one without
//===========================================================================
`define ALTERA_XCVR_KR_RCFG_DATA_PORTS                       \
        (                                                    \
       .pcs_data_addr    (pcs_data_addr),                    \
       .pcs_mode_rc      (pcs_mode_rc),                      \
       .rcfg_addr        (pcs_addr),                         \
       .rcfg_data        (pcs_writedata),                    \
       .rcfg_mask        (pcs_datamask)                      \
        );

generate
   if          (ES_DEVICE && !SYNTH_FEC &&  SYNTH_1588 &&  (REF_CLK==1)) begin : data_1588_644
     rcfg_data_1588_644 #(.SYNTH_AN_LT (SYNTH_AN_LT)) rcfg_data_1588_644_inst
     `ALTERA_XCVR_KR_RCFG_DATA_PORTS
   end else if (ES_DEVICE && !SYNTH_FEC &&  SYNTH_1588 && (REF_CLK==0)) begin : data_1588_322
     rcfg_data_1588_322 #(.SYNTH_AN_LT (SYNTH_AN_LT)) rcfg_data_1588_322_inst
     `ALTERA_XCVR_KR_RCFG_DATA_PORTS
   end else if (ES_DEVICE && !SYNTH_FEC && !SYNTH_1588 &&  (REF_CLK==1)) begin : data_644
     rcfg_data_644 #(.SYNTH_AN_LT (SYNTH_AN_LT)) rcfg_data_644_inst
     `ALTERA_XCVR_KR_RCFG_DATA_PORTS
   end else if (ES_DEVICE && !SYNTH_FEC &&  SYNTH_1588 && (REF_CLK==2)) begin : data_1588_312
     rcfg_data_1588_312 #(.SYNTH_AN_LT (SYNTH_AN_LT)) rcfg_data_1588_312_inst
     `ALTERA_XCVR_KR_RCFG_DATA_PORTS
   end else if (ES_DEVICE && !SYNTH_FEC && !SYNTH_1588 && (REF_CLK==0)) begin : data_322
     rcfg_data_322 #(.SYNTH_AN_LT (SYNTH_AN_LT)) rcfg_data_322_inst
     `ALTERA_XCVR_KR_RCFG_DATA_PORTS
   end else if (ES_DEVICE &&  SYNTH_FEC && !SYNTH_1588 &&  (REF_CLK==1)) begin : data_fec_644
     rcfg_data_fec_644 #(.SYNTH_AN_LT (SYNTH_AN_LT)) rcfg_data_fec_644_inst
     `ALTERA_XCVR_KR_RCFG_DATA_PORTS
   end else if (ES_DEVICE &&  SYNTH_FEC && !SYNTH_1588 && (REF_CLK==0)) begin : data_fec_322
     rcfg_data_fec_322 #(.SYNTH_AN_LT (SYNTH_AN_LT)) rcfg_data_fec_322_inst
     `ALTERA_XCVR_KR_RCFG_DATA_PORTS
   end else if (ES_DEVICE &&  SYNTH_FEC &&  SYNTH_1588 &&  (REF_CLK==1)) begin : data_fec1588_644
     rcfg_data_fec1588_644 #(.SYNTH_AN_LT (SYNTH_AN_LT)) rcfg_data_fec1588_644_inst
     `ALTERA_XCVR_KR_RCFG_DATA_PORTS
   end else if (ES_DEVICE &&  SYNTH_FEC &&  SYNTH_1588 && (REF_CLK==0)) begin : data_fec1588_322
     rcfg_data_fec1588_322 #(.SYNTH_AN_LT (SYNTH_AN_LT)) rcfg_data_fec1588_322_inst
     `ALTERA_XCVR_KR_RCFG_DATA_PORTS
   end else if (!ES_DEVICE && !SYNTH_FEC &&  SYNTH_1588 &&  (REF_CLK==1)) begin : revd_data_1588_644
     rcfg_revd_data_1588_644 #(.SYNTH_AN_LT (SYNTH_AN_LT)) rcfg_revd_data_1588_644_inst
     `ALTERA_XCVR_KR_RCFG_DATA_PORTS
   end else if (!ES_DEVICE && !SYNTH_FEC &&  SYNTH_1588 && (REF_CLK==0)) begin : revd_data_1588_322
     rcfg_revd_data_1588_322 #(.SYNTH_AN_LT (SYNTH_AN_LT)) rcfg_revd_data_1588_322_inst
     `ALTERA_XCVR_KR_RCFG_DATA_PORTS
   end else if (!ES_DEVICE && !SYNTH_FEC && !SYNTH_1588 &&  (REF_CLK==1)) begin : revd_data_644
     rcfg_revd_data_644 #(.SYNTH_AN_LT (SYNTH_AN_LT)) rcfg_revd_data_644_inst
     `ALTERA_XCVR_KR_RCFG_DATA_PORTS
   end else if (!ES_DEVICE && !SYNTH_FEC &&  SYNTH_1588 && (REF_CLK==2)) begin : revd_data_1588_312
     rcfg_revd_data_1588_312 #(.SYNTH_AN_LT (SYNTH_AN_LT)) rcfg_revd_data_1588_312_inst
     `ALTERA_XCVR_KR_RCFG_DATA_PORTS
   end else if (!ES_DEVICE && !SYNTH_FEC && !SYNTH_1588 && (REF_CLK==0)) begin : revd_data_322
     rcfg_revd_data_322 #(.SYNTH_AN_LT (SYNTH_AN_LT)) rcfg_revd_data_322_inst
     `ALTERA_XCVR_KR_RCFG_DATA_PORTS
   end else if (!ES_DEVICE &&  SYNTH_FEC && !SYNTH_1588 &&  (REF_CLK==1)) begin : revd_data_fec_644
     rcfg_revd_data_fec_644 #(.SYNTH_AN_LT (SYNTH_AN_LT)) rcfg_revd_data_fec_644_inst
     `ALTERA_XCVR_KR_RCFG_DATA_PORTS
   end else if (!ES_DEVICE &&  SYNTH_FEC && !SYNTH_1588 && (REF_CLK==0)) begin : revd_data_fec_322
     rcfg_revd_data_fec_322 #(.SYNTH_AN_LT (SYNTH_AN_LT)) rcfg_revd_data_fec_322_inst
     `ALTERA_XCVR_KR_RCFG_DATA_PORTS
   end else if (!ES_DEVICE &&  SYNTH_FEC &&  SYNTH_1588 &&  (REF_CLK==1)) begin : revd_data_fec1588_644
     rcfg_revd_data_fec1588_644 #(.SYNTH_AN_LT (SYNTH_AN_LT)) rcfg_revd_data_fec1588_644_inst
     `ALTERA_XCVR_KR_RCFG_DATA_PORTS
   end else if (!ES_DEVICE &&  SYNTH_FEC &&  SYNTH_1588 && (REF_CLK==0)) begin : revd_data_fec1588_322
     rcfg_revd_data_fec1588_322 #(.SYNTH_AN_LT (SYNTH_AN_LT)) rcfg_revd_data_fec1588_322_inst
     `ALTERA_XCVR_KR_RCFG_DATA_PORTS
   end else begin	   
     assign pcs_addr  = 10'h3ff;
     assign pcs_writedata  = 8'b0;
     assign ctrl_datamask  = 8'b0;
   end
endgenerate

  // need to condition the controls to the AVMM master
  assign last_data  = (pcs_addr == 10'h3ff);
  assign pcs_write  = en_next & ~last_data && (ctrl_datamask == 8'hFF);
  assign ctrl_rmw   = en_next & ~last_data && (ctrl_datamask != 8'hFF);

  // delay first rmw by 1 clock to align with address
  reg  dly_rmw;
  wire fnl_rmw;
  always_ff @(posedge mgmt_clk)
    dly_rmw <= ~pcs_rc_busy & ctrl_rmw;
  assign fnl_rmw = (pcs_rc_busy & ctrl_rmw) | dly_rmw | pma_rmw;

//===========================================================================
// Instantiate the AVMM master State Machine
//===========================================================================
rcfg_avmm_mstr  rcfg_avmm_mstr_inst (
  .clk            (mgmt_clk),
  .reset          (mgmt_clk_reset),
  .pcs_mode_rc    (pcs_mode_rc[1:0]),
    //  from the Controllers
  .ctrl_addr      (ctrl_addr),
  .ctrl_writedata (ctrl_writedata),
  .ctrl_datamask  (ctrl_datamask),
  .ctrl_write     (ctrl_write),
  .ctrl_rmw       (fnl_rmw),
  .ctrl_busy      (ctrl_busy),
  .refclk_req     (refclk_req),
  .cgb_req        (cgb_req),
  .cal_req        (cal_req),
  .refclk_sel     (refclk_sel),
  .cgb_sel        (cgb_sel),
  .cal_sel        (cal_sel),
  .avmm_req       (avmm_req),
    // HSSI Reconfig master
  .xcvr_rcfg_write    (xcvr_rcfg_write),
  .xcvr_rcfg_read     (xcvr_rcfg_read),
  .xcvr_rcfg_address  (xcvr_rcfg_address),
  .xcvr_rcfg_wrdata   (xcvr_rcfg_wrdata),
  .xcvr_rcfg_rddata   (xcvr_rcfg_rddata),
  .xcvr_rcfg_wtrqst   (xcvr_rcfg_wtrqst)
);

endmodule // rcfg_top
