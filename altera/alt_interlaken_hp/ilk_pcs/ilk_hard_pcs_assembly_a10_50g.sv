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


/////////////////////////////////////////////////////////////////////////////
// juzhang - 02/03/2014 modify the pcs width from 40 bit to 32 bit to short latency.
//                      Added BYPASS_RDC and BYPASS_LOOSEFIFO

`timescale 1 ps / 1 ps

module ilk_hard_pcs_assembly_a10_50g #(
    parameter           NUM_LANES          = 8,
    parameter           NUM_PLLS           = 1,
    parameter           BITS_PER_LANE      = 64,
    parameter           INCLUDE_TEMP_SENSE = 1'b0,
    parameter           MM_CLK_KHZ         = 20'd100_000,           // 75_000 to 125_000
    parameter           MM_CLK_MHZ         = ( MM_CLK_KHZ / 1_000 ), // 75 to 125
    parameter           RECONF_ADDR        = (NUM_LANES == 24) ? 5 :(NUM_LANES == 12) ? 4 : (NUM_LANES == 8) ? 3 : 0,
    parameter           DIAG_ON            = 1,
    parameter           BYPASS_RDC         = 0,
    parameter           BYPASS_LOOSEFIFO   = 0
)(
    input                               pll_ref_clk,
    input                               rx_usr_clk,           //300Mhz user interface clock
    input                               tx_usr_clk,           //300Mhz user interface clock
    // config and status port
    input                               mm_clk,         // 75-125 MHz
    input                               mm_clk_locked,  // used as reset
    input                               mm_read,
    input                               mm_write,
    input       [15:0]                  mm_addr,
    output      [31:0]                  mm_rdata,
    output                              mm_rdata_valid,
    input       [31:0]                  mm_wdata,

    // chip HSIO pins
    input       [NUM_LANES-1:0]         rx_pin,
    output      [NUM_LANES-1:0]         tx_pin,

    // data streams, msb first on the wire
    output wire                         clk_tx_common,
    output                              srst_tx_common,
    input       [NUM_LANES*64-1:0]      tx_din,
    input       [NUM_LANES-1:0]         tx_control,
    input                               tx_valid,
    output wire                         tx_cadence,

    output wire                         clk_rx_common,
    output                              srst_rx_common,
    output                              tx_lanes_aligned,
    output                              tx_pcsfifo_pfull,
    output                              tx_pcsfifo_pempty,
    output                              rx_lanes_aligned,
    output reg  [NUM_LANES*64-1:0]      rx_dout,
    output      [NUM_LANES-1:0]         rx_control,
    output wire [NUM_LANES-1:0]         rx_wordlock,
    output wire [NUM_LANES-1:0]         rx_metalock,
    output wire [NUM_LANES-1:0]         rx_crc32err,
    output reg  [NUM_LANES-1:0]         rx_valid,        // these should all be the same when operating normally

    // a10 new IO signals
    output      [NUM_PLLS-1:0]          pll_powerdown,
    input       [NUM_PLLS-1:0]          tx_pll_locked,
    input       [NUM_LANES-1:0]         tx_serial_clk,
    
    input                               reconfig_clk,
    input                               reconfig_reset,
    input                               reconfig_write,
    input                               reconfig_read,
    input      [RECONF_ADDR+9:0]        reconfig_address,
    input      [31: 0]                  reconfig_writedata,
    output     [31: 0]                  reconfig_readdata,
    output                              reconfig_waitrequest,

    output                              striper_wd_req,
    input                               pre_crc_words_valid

);

// reset sync with mm_clk
wire system_reset;
ilk_rst_sync mm_reset_sync (
        .async_rst              ( !mm_clk_locked),
        .clk                    ( mm_clk ),
        .srst                   ( system_reset )
    );

// xcvr_reset_control 
wire    [NUM_LANES-1:0]         tx_analogreset;
wire    [NUM_LANES-1:0]         tx_digitalreset;
wire    [NUM_LANES-1:0]         rx_analogreset;
wire    [NUM_LANES-1:0]         rx_digitalreset;

// xcvr_reset_control to lane alignment
wire    [NUM_LANES-1:0]         tx_ready;    //useless
wire    [NUM_LANES-1:0]         rx_ready;    //useless

wire    [log2(NUM_PLLS-1)-1:0]  tx_pll_select = 0;

wire                            all_tx_pll_locked;

// xcvr_phy to xcvr_reset_control
wire    [NUM_LANES-1:0]         tx_cal_busy;
wire    [NUM_LANES-1:0]         rx_is_lockedtodata;
wire                            all_rx_is_lockedtodata;
wire    [NUM_LANES-1:0]         rx_cal_busy;

// tx aligner
wire                            tx_from_fifo;  // used to control the reading of data from the 
                                               // tx fifo by the frame gen
wire                            tx_force_fill; 

// rx aligner
wire                            rx_cadence;
wire                            rx_fifo_clr;

// native phy
wire [NUM_LANES*128-1:0] rx_dout_np;   // different from sv:64     
wire [NUM_LANES-1:0]    tx_clkout;        
wire [NUM_LANES-1:0]    rx_clkout;       
wire [NUM_LANES*20-1:0] rx_control_np; // different from sv:10    
wire [NUM_LANES-1:0]    tx_full;  
wire [NUM_LANES-1:0]    tx_pfull;   
wire [NUM_LANES-1:0]    tx_empty;   
wire [NUM_LANES-1:0]    tx_pempty_np;   
wire [NUM_LANES-1:0]    tx_pempty_gen;   //temp   
wire [NUM_LANES-1:0]    tx_pempty = (BYPASS_LOOSEFIFO == 1) ? tx_pempty_np : tx_pempty_gen;  
wire [NUM_LANES-1:0]    tx_pempty_s;
wire [NUM_LANES-1:0]    rx_valid_np;     
wire [NUM_LANES-1:0]    rx_full;     
wire [NUM_LANES-1:0]    rx_pfull;   
wire [NUM_LANES-1:0]    rx_empty;     
wire [NUM_LANES-1:0]    rx_pempty;    
wire [NUM_LANES-1:0]    tx_frame;           
wire [NUM_LANES-1:0]    rx_prbs_err;           
wire [NUM_LANES-1:0]    rx_prbs_done; 

wire [4*NUM_LANES-1:0]  fifo_cnt_np;  // TX FIFO data number used to gen pempty              
                                      // TX FIFO depth is 16

// lane alignment to status registers
wire                            any_tx_frame;
wire                            all_tx_full;
wire                            any_tx_full;
wire                            any_tx_empty;
wire    [2:0]                   txa_sm;

wire                            any_loss_of_meta;
wire                            any_control;     // any framing control word
wire                            all_control;     // all framing control word
wire    [4:0]                   rxa_timer;
wire    [1:0]                   rxa_sm;

// control registers
wire    [NUM_LANES-1:0]         local_serial_loopback;
wire                            rx_set_locktodata;
wire                            rx_set_locktoref;
wire                            ignore_rx_analog;
wire                            ignore_rx_digital;
wire                            soft_rst_txrx;
wire                            soft_rst_rx;
wire  [NUM_LANES-1:0]           tx_crc32err_inject_s_txc;
wire                            rx_prbs_err_clr; 

assign all_rx_is_lockedtodata = &rx_is_lockedtodata;
assign all_tx_pll_locked      = &tx_pll_locked;

///////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////
// reset sequence
//////////////////////////////////////////////


reset_control_a10 altera_xcvr_reset_control_inst  (
        .clock              ( mm_clk ),
        .reset              ( system_reset | soft_rst_txrx ),

        //Reset signal output 
        .pll_powerdown      ( pll_powerdown ),
        .tx_analogreset     ( tx_analogreset ),
        .tx_digitalreset    ( tx_digitalreset ),
        .rx_analogreset     ( rx_analogreset ),
        .rx_digitalreset    ( rx_digitalreset ),

        //Status output
        .tx_ready           ( tx_ready ),
        .rx_ready           ( rx_ready ),

        //TX control inputs
        .pll_locked         ( { NUM_PLLS{ all_tx_pll_locked }} ),   //fix me
        .pll_select         ( tx_pll_select ),
        .tx_cal_busy        ( tx_cal_busy ),
        // .tx_manual          ( { NUM_LANES{ 1'b0 }} ), // begin reset after pll_locked deasserted

        //RX control inputs
        .rx_is_lockedtodata ( { NUM_LANES{ all_rx_is_lockedtodata & ~soft_rst_rx }} ),
        .rx_cal_busy        ( rx_cal_busy )
        // .rx_manual          ( { NUM_LANES{ 1'b0 }} ), // begin reset after rx_is_lockedtodata is deasserted

        //Digital reset override inputs
        // .tx_digitalreset_or ( { NUM_LANES{ 1'b0 }} ),
        // .rx_digitalreset_or ( { NUM_LANES{ 1'b0 }} )
    ); //altera_xcvr_reset_control

ilk_rst_sync srst_tx_common_sync (
        .async_rst              ( tx_digitalreset[0] ),
        .clk                    ( clk_tx_common ),
        .srst                   ( srst_tx_common )
    );

ilk_rst_sync srst_rx_common_sync (
        .async_rst              ( rx_digitalreset[0] & ~ignore_rx_digital ),
        .clk                    ( clk_rx_common ),
        .srst                   ( srst_rx_common )
    );

//////////////////////////////////////////////
// Tx Alignment and Rx Deskew
//////////////////////////////////////////////

assign tx_pcsfifo_pfull  = |tx_pfull;
assign tx_pcsfifo_pempty = |tx_pempty_s;

ilk_tx_aligner #(
        .NUM_LANES              ( NUM_LANES )
    ) ilk_tx_align_inst (

        //outputs
        .txa_sm                 ( txa_sm),
        .tx_from_fifo           ( tx_from_fifo),
        .tx_lanes_aligned       ( tx_lanes_aligned ),
        .tx_force_fill          ( tx_force_fill),
        .all_tx_full            ( all_tx_full),
        .any_tx_empty           ( any_tx_empty),
        .any_tx_frame           ( any_tx_frame),
        .any_tx_full            ( any_tx_full),
        .tx_cadence             ( tx_cadence ),
        .tx_pempty_s            ( tx_pempty_s),

        //inputs
        .tx_frame               ( tx_frame ),
        .tx_empty               ( tx_empty ),
        .tx_full                ( tx_full ),
        .tx_pempty              ( tx_pempty ),

        .clk_tx_common          ( clk_tx_common ),
        .srst_tx_common         ( srst_tx_common )

    ); // ilk_tx_aligner

//due to the difference sv and a10
wire [64*NUM_LANES-1:0]  rx_dout_rxa;       // input to ilk_rx_aligner 
wire [10*NUM_LANES-1:0]  rx_control_rxa;    // input to ilk_rx_aligner 
wire [18*NUM_LANES-1:0]  tx_control_np;     // input to native phy
wire [128*NUM_LANES-1:0] tx_din_np;         // input to native phy
genvar k;
generate
   for (k=0;k<NUM_LANES;k=k+1) begin : np_bus_convert
     assign rx_dout_rxa[64*(k+1)-1 : 64*k]    = rx_dout_np[64*(2*k+1)-1 :64*2*k];
     assign rx_control_rxa[10*(k+1)-1 : 10*k] = rx_control_np[10*(2*k+1)-1 :10*2*k];
     assign tx_control_np[18*(k+1)-1:18*k]    = {9'b0,tx_crc32err_inject_s_txc[k],6'b0,tx_control[k],~tx_control[k]};
     assign tx_din_np[128*(k+1)-1:128*k]      = {64'b0,tx_din[64*(k+1)-1:64*k]};
   end
endgenerate

ilk_rx_aligner #(
        .BYPASS_RDC             (BYPASS_RDC),
        .NUM_LANES              ( NUM_LANES ),
        .BITS_PER_LANE          ( BITS_PER_LANE )
    ) ilk_rx_aligner_inst (
        //outputs
        .rx_lanes_aligned       ( rx_lanes_aligned),
        .rxa_sm                 ( rxa_sm ),
        .rx_cadence             ( rx_cadence ),
        .rx_valid               ( rx_valid ),
        .rx_control             ( rx_control ),
        .rx_dout                ( rx_dout ),
        .rx_fifo_clr            ( rx_fifo_clr ),
        .any_loss_of_meta       ( any_loss_of_meta ),
        .any_control            ( any_control ),
        .all_control            ( all_control ),
        .rxa_timer              ( rxa_timer ),
      

        //inputs
        .rx_pempty              ( rx_pempty ),
        .rx_pfull               ( rx_pfull),
        .rx_metalock            ( rx_metalock ),
        .rx_valid_np            ( rx_valid_np ),
        .rx_dout_np             ( rx_dout_rxa ),
        .rx_control_np          ( rx_control_rxa ),
        .clk_rx_common          ( clk_rx_common ),
        .srst_rx_common         ( srst_rx_common )
    ); //ilk_rx_aligner 

// we want these to go through an LCELL to become internal
// global clock lines.
//wire tx_common_ena = 1'b1 /* synthesis keep */;
//wire rx_common_ena = 1'b1 /* synthesis keep */;
//wire tx_common     = tx_clkout [NUM_LANES >> 1'b1] & tx_common_ena /* synthesis keep */;
//wire rx_common     = rx_clkout [NUM_LANES >> 1'b1] & rx_common_ena /* synthesis keep */;
wire tx_common;
wire rx_common;

   generate
      if (BYPASS_RDC) begin
        assign rx_common     = rx_usr_clk;
      end
      else  begin
        assign rx_common     = rx_clkout [NUM_LANES >> 1'b1];
      end
   endgenerate

   generate
      if (BYPASS_LOOSEFIFO) begin
        assign tx_common = tx_usr_clk;
      end
      else begin
        assign tx_common = tx_clkout [NUM_LANES >> 1'b1];
      end
   endgenerate


assign clk_tx_common = tx_common;
assign clk_rx_common = rx_common;

wire fake_tx_fifo_write;

wire tx_valid_phy = BYPASS_LOOSEFIFO ? (tx_lanes_aligned & tx_valid & tx_pcsfifo_pempty) : tx_valid;

np np_inst (
		.tx_analogreset            (tx_analogreset),  
		.tx_digitalreset           (tx_digitalreset),
		.rx_analogreset            (rx_analogreset), 
		.rx_digitalreset           (rx_digitalreset),

                 // Reconfig interface ports
		.tx_cal_busy               (tx_cal_busy),          
		.rx_cal_busy               (rx_cal_busy),         

                //clk signals  
		.rx_cdr_refclk0             (pll_ref_clk), 
		.tx_serial_clk0             (tx_serial_clk),    

                // TX and RX serial ports
		.tx_serial_data            (tx_pin),    
		.rx_serial_data            (rx_pin),

                // control ports
		.rx_seriallpbken           (local_serial_loopback),
		.rx_set_locktodata         ({ NUM_LANES{ rx_set_locktodata }}), 
		.rx_set_locktoref          ({ NUM_LANES{ rx_set_locktoref }}), 

                //status output
		.rx_is_lockedtoref         (),    
		.rx_is_lockedtodata        (rx_is_lockedtodata), 

                //parallel data ports
		.tx_parallel_data          ( tx_din_np ),
		.rx_parallel_data          ( rx_dout_np ), 

                //-------------------------
                // 10G PCS ports
                //-------------------------
                //clock ports
		.tx_coreclkin          ({NUM_LANES{tx_common}}),   
		.rx_coreclkin          ({NUM_LANES{rx_common}}),  
		.tx_clkout             (tx_clkout),  
		.rx_clkout             (rx_clkout), 

                // data path/control
		.tx_control            ({tx_control_np}),  
		.rx_control            (rx_control_np), 

                // TxFIFO/RxFIFO
		.tx_enh_data_valid         ({NUM_LANES{tx_valid_phy | tx_force_fill | fake_tx_fifo_write}}),  
		.tx_enh_frame_diag_status  ({NUM_LANES{2'b11}}),  
		.tx_enh_fifo_full          (tx_full), 
		.tx_enh_fifo_pfull         (tx_pfull),  
		.tx_enh_fifo_empty         (tx_empty),  
		.tx_enh_fifo_pempty        (tx_pempty_np),    
		.tx_enh_fifo_cnt           (fifo_cnt_np),    // for Night Furry 

		.rx_enh_fifo_rd_en         ({NUM_LANES{rx_cadence}}),
		.rx_enh_data_valid         (rx_valid_np),   
		.rx_enh_fifo_full          (rx_full),  
		.rx_enh_fifo_pfull         (rx_pfull),
		.rx_enh_fifo_empty         (rx_empty), 
		.rx_enh_fifo_pempty        (rx_pempty), 
		.rx_enh_fifo_align_val     (),         
		.rx_enh_fifo_align_clr     ({NUM_LANES{rx_fifo_clr}}),  

                // Block sync
		.rx_enh_blk_lock           (rx_wordlock),  

                // Frame generator/sync
		.tx_enh_frame              (tx_frame),    
		.tx_enh_frame_burst_en     ({NUM_LANES{tx_from_fifo}}),    
		.rx_enh_frame_lock         (rx_metalock),    
    
                // CRC chk
		.rx_enh_crc32_err          (rx_crc32err),   

                // PRBS
                .rx_prbs_err_clr           ({NUM_LANES{rx_prbs_err_clr}}),
                .rx_prbs_err               (rx_prbs_err),
                .rx_prbs_done              (rx_prbs_done),
           
                // Reconfiguration 
                .reconfig_clk              (reconfig_clk),
                .reconfig_reset            (reconfig_reset ),
                .reconfig_write            (reconfig_write ),
                .reconfig_read             (reconfig_read ),
                .reconfig_address          (reconfig_address ),
                .reconfig_writedata        (reconfig_writedata ),
                .reconfig_readdata         (reconfig_readdata ),
                .reconfig_waitrequest      (reconfig_waitrequest )
    ); //altera_xcvr_native_sv


ilk_hard_pcs_csr_a10 #(
        .NUM_LANES               ( NUM_LANES ),
        .NUM_PLLS                ( NUM_PLLS ),
        .INCLUDE_TEMP_SENSE      ( INCLUDE_TEMP_SENSE ),
        .DIAG_ON                 ( DIAG_ON),
        .MM_CLK_KHZ              ( MM_CLK_KHZ )
    ) ilk_hard_pcs_csr_inst (
        .mm_clk                  ( mm_clk ),
        .mm_clk_locked           ( !system_reset),
        .mm_read                 ( mm_read ),
        .mm_write                ( mm_write ),
        .mm_addr                 ( mm_addr ),
        .mm_rdata                ( mm_rdata ),
        .mm_rdata_valid          ( mm_rdata_valid ),
        .mm_wdata                ( mm_wdata ),

        // clocks to monitor
        .pll_ref_clk             ( pll_ref_clk ),
        .clk_rx_common           ( clk_rx_common ),
        .srst_rx_common          ( srst_rx_common ),
        .clk_tx_common           ( clk_tx_common ),

        // status inputs
        .tx_pll_locked           ( tx_pll_locked ),
        .tx_align_empty          ( tx_empty ),
        .tx_align_pempty         ( tx_pempty ),
        .tx_align_full           ( tx_full ),
        .tx_align_pfull          ( tx_pfull ),
        .any_tx_frame            ( any_tx_frame ),
        .all_tx_full             ( all_tx_full ),
        .any_tx_full             ( any_tx_full ),
        .any_tx_empty            ( any_tx_empty ),
        .txa_sm                  ( txa_sm ),
        .tx_lanes_aligned        ( tx_lanes_aligned ),

        .rx_deskew_empty         ( rx_empty ),
        .rx_deskew_pempty        ( rx_pempty ),
        .rx_deskew_full          ( rx_full ),
        .rx_deskew_pfull         ( rx_pfull ),
        .rx_is_lockedtodata      ( rx_is_lockedtodata ),
        .any_loss_of_meta        ( any_loss_of_meta ),
        .any_control             ( any_control ),
        .all_control             ( all_control ),
        .rxa_timer               ( rxa_timer ),
        .rxa_sm                  ( rxa_sm ),
        .rx_lanes_aligned        ( rx_lanes_aligned ),
        .rx_wordlock             ( rx_wordlock ),
        .rx_metalock             ( rx_metalock ),
        .rx_crc32err             ( rx_crc32err ),
        .rx_sh_err               ( {NUM_LANES{1'b0}} ),   // for A10
        .rx_prbs_err             ( rx_prbs_err ),
        .rx_prbs_done            ( rx_prbs_done ), 

        // control outputs
        .local_serial_loopback   ( local_serial_loopback ),
        .rx_set_locktodata       ( rx_set_locktodata ),
        .rx_set_locktoref        ( rx_set_locktoref ),
        .ignore_rx_analog        ( ignore_rx_analog ),
        .ignore_rx_digital       ( ignore_rx_digital ),
        .soft_rst_txrx           ( soft_rst_txrx ),
        .soft_rst_rx             ( soft_rst_rx ),
        .rx_prbs_err_clr         ( rx_prbs_err_clr ),
        .tx_crc32err_inject_s_txc( tx_crc32err_inject_s_txc )


    ); // ilk_hard_pcs_csr 

// NOTE: this is not a rigorous mathematical definition of LOG2(v).
// This function computes the number of bits required to represent "v".
// So log2(256) will be  9 rather than 8 (256 = 9'b1_0000_0000).

function integer log2;
   input integer val;
begin
   if (val == 0) begin
      log2 = 1;
   end
   else begin
      log2 = 0;
      while (val > 0) begin
         val  = val >> 1;
         log2 = log2 + 1;
      end
   end
end
endfunction

//generate fake write to tx fifo for low latency design
generate 
   if(BYPASS_LOOSEFIFO == 1) begin
      tx_fifo_write tx_fifo_write_inst (
          //output
          .tx_fifo_write(fake_tx_fifo_write),

          //input
          .tx_cadence (tx_cadence),
          .tx_lanes_aligned(tx_lanes_aligned),
          .tx_valid(tx_valid),
          .clk_tx_common(clk_tx_common),
          .srst_tx_common(srst_tx_common)
      );
   end
   else begin
      assign fake_tx_fifo_write = 1'b0; 
       pempty_gen_a10 #(
       .NUM_LANES               (NUM_LANES),
       .PEMPTY                  (8)
   ) pempty_gen_a10_inst (
     .pempty_np               (tx_pempty_gen),

     .fifo_cnt_np             (fifo_cnt_np),
     .tx_digitalreset         (tx_digitalreset),
     .tx_clkout               (tx_clkout)
  );
   end 
endgenerate

generate 
   if(BYPASS_LOOSEFIFO == 1) begin
      striper_wd_req #(
       .INTERNAL_WORDS          (4),
       .NUM_LANES               (NUM_LANES),
       .PCS_WIDTH               (7'd67),
       .PMA_WIDTH               (7'd40)
   )  striper_wd_req_inst (
       .clk                       (clk_tx_common),          //tx clk
       .srst                      (srst_tx_common),
       .pcs_clk                   (tx_clkout[NUM_LANES >> 1'b1]),      //tx common clk
       .pcs_srst                  (tx_digitalreset[0]),
       .tx_lanes_aligned          (tx_lanes_aligned),
       .tx_frame                  (tx_frame[NUM_LANES >> 1'b1]),
       .tx_valid                  (tx_valid),
       .striper_wd_req            (striper_wd_req),
       .pre_crc_words_valid       (pre_crc_words_valid)
   );
   end else begin
     assign striper_wd_req = 1'b0;
   end
endgenerate
endmodule

