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


// $Id: e100_io_frame_32.v,v 1.2 2016/11/16 20:06:19 marmstro Exp marmstro $
// $Revision: 1.2 $
// $Date: 2016/11/16 20:06:19 $
// $Author: marmstro $
//-----------------------------------------------------------------------------
// baeckler - 08-28-2012

module e100_io_frame_32 #(
        parameter PHY_REFCLK = 1,
        parameter RST_CNTR = 16,   // nominal 16/20  or 6 for fast simulation of reset seq
        parameter TARGET_CHIP = 2,
        parameter NO_PMA = 0
)(
        input pll_refclk,
        output [9:0] tx_pin,
        input [9:0] rx_pin,

        // status and control
        input status_clk,
        input sys_rst,
        input [9:0] sloop,
        input [2:0] flag_sel,
        output reg [9:0] flag_mx,
        output [9:0] tx_pll_lock_status,
        output [9:0] freq_lock,
        input set_data_lock,
        input set_ref_lock,
        output txa_online,
                                
        // data stream to TX pins
        input din_clk,
        input din_clk_ready,
        input [16*20-1:0] din, // lsbit first serial streams
        input din_valid,
        output wire [2:0] tx_online,
        output clk_tx_io,
    
        // data stream from RX pins
        input dout_clk,          //clk_rx_main 
        input dout_clk_ready,
        output [16*20-1:0] dout, // lsbit first serial streams
        input [9:0] dout_req,
        output reg [9:0] rx_online,
        output wire rx_aclr_pcs_ready,
        output clk_rx_recovered,
        
        // Arria 10 40g phy signals to the top
        input  wire [0:0]   reconfig_clk,            // reconfig_clk.clk
        input  wire [0:0]   reconfig_reset,          // reconfig_reset.reset
        input  wire [0:0]   reconfig_write,          // reconfig_avmm.write
        input  wire [0:0]   reconfig_read,           // .read
        input  wire [13:0]  reconfig_address,        // .address
        input  wire [31:0]  reconfig_writedata,      // .writedata
        output wire [31:0]  reconfig_readdata,       // .readdata
        output wire [0:0]   reconfig_waitrequest,    // .waitrequest
        input [9:0]         tx_serial_clk,
        input               tx_pll_locked,
        
        input   [1399:0] reconfig_to_xcvr,
        output  [919:0]  reconfig_from_xcvr,

        input  wire rx_backup //in clk_rx_main domain, after a RX sclr backup the FIFOs a little bit
);

// FSM for Rx FIFO health moniter    
localparam [1:0]              
          ST_FIFO_DEAD          = 2'd0,
          ST_FIFO_PURGING       = 2'd1,
          ST_FIFO_GRACE_PERIOD  = 2'd2,
          ST_FIFO_HEALTHY       = 2'd3; 

reg [1:0]  state_r = 2'd0 /* synthesis preserve */;     
reg [1:0]  state_nx       /* synthesis preserve */;    
wire rx_fifo_bad          /* synthesis preserve */;
wire rx_full_1bit_s;
wire rx_empty_1bit_s;   

// status and resets
wire pll_powerdown;
wire tx_analogreset;
wire tx_digitalreset;
wire rx_analogreset;
wire rx_digitalreset;
wire cal_busy;   
wire tx_cal_busy;
wire rx_cal_busy;   
   
// data and clock
wire  [9:0]   tx_10g_data_valid;
wire  [9:0]   rx_10g_fifo_rd_en;
wire  [9:0]   rx_10g_fifo_align_clr = {10{1'b0}}; // this only works in some modes
wire  [9:0]   tx_10g_clkout;
wire  [9:0]   rx_10g_clkout;
wire  [9:0]   rx_10g_data_valid;
wire [16*20-1:0] rxd_wires;
reg [16*20-1:0] tx_launch,tx_launch_1  = 0 /* synthesis preserve */;

assign clk_tx_io = tx_10g_clkout[4];
assign clk_rx_recovered = rx_10g_clkout[4];

// fifo status
wire [9:0] tx_full,tx_empty,tx_pfull,tx_pempty;
wire [9:0] rx_full,rx_empty,rx_pfull,rx_pempty;

wire [1:0] txlock;

assign tx_pll_lock_status = {10{txlock[0]}};

genvar i;
generate
        if (NO_PMA) begin
        
        scfifo_mlab sfifo(
                .clk(din_clk),
                .sclr(1'b0),
                .wdata(tx_launch),
                .wreq(|tx_10g_data_valid),
                .full(),        // optional duplicates for loading
                .rdata(rxd_wires),
                .rreq(|rx_10g_fifo_rd_en),
                .empty(),       // optional duplicates for loading
                .used() 
        );
        
        defparam sfifo.WIDTH = 320;
        defparam sfifo.TARGET_CHIP = 2;
        
                assign freq_lock = {10{1'b1}};
                assign txlock[0] = 1'b1;
                assign tx_full = 1'b0;
                assign tx_pfull = 1'b0;
                assign tx_empty = 1'b0;
                assign tx_pempty = 1'b0;
                assign rx_full = 1'b0;
                assign rx_pfull = 1'b0;
                assign rx_empty = 1'b0;
                assign rx_pempty = 1'b0;
                assign reconfig_from_xcvr = 920'd0;
        end
        else if (TARGET_CHIP == 2) begin
                s5_32bit_tenpack #(
                        .PHY_REFCLK (PHY_REFCLK)
                        ) fp (
                        .pll_refclk(pll_refclk),
                        
                        .pll_pd(pll_powerdown),
                        .rst_txa(tx_analogreset),
                        .rst_txd(tx_digitalreset),
                        .rst_rxa(rx_analogreset),
                        .rst_rxd(rx_digitalreset),
                        .tx_pll_locked(txlock[0]),

                        .tx_clkout(tx_10g_clkout),
                        .rx_clkout(rx_10g_clkout),
                        .clk_tx_common(din_clk),
                        .clk_rx_common(dout_clk),
                                        
                        .tx_pin(tx_pin),
                        .rx_pin(rx_pin),

                        .tx_din(tx_launch),
                        .rx_dout(rxd_wires),
                        
                        .tx_valid(tx_10g_data_valid),
                        .rx_ready(rx_10g_fifo_rd_en),
                        .rx_fifo_aclr(rx_10g_fifo_align_clr),
                        .rx_bitslip(10'b0),
                        .rx_valid(),
                        .rx_datalocked(freq_lock),
                        .rx_seriallpbken(sloop),
                                                
                        .tx_full(tx_full),
                        .tx_pfull(tx_pfull),
                        .tx_empty(tx_empty),
                        .tx_pempty(tx_pempty),
                        .rx_full(rx_full),
                        .rx_pfull(rx_pfull),
                        .rx_empty(rx_empty),
                        .rx_pempty(rx_pempty),
                              
                        .tx_cal_busy(tx_cal_busy),
                        .rx_cal_busy(rx_cal_busy),

                        .set_lock_data(set_data_lock),
                        .set_lock_ref(set_ref_lock),
                        .reconfig_to_xcvr(reconfig_to_xcvr),
                        .reconfig_from_xcvr(reconfig_from_xcvr));
        end else if (TARGET_CHIP == 5) begin
                        a10_32bit_tenpack # (
                                .PHY_REFCLK     (PHY_REFCLK)
                        )fp (
                                .pll_refclk(pll_refclk),
                                
                                .pll_pd(pll_powerdown),
                                .rst_txa(tx_analogreset),
                                .rst_txd(tx_digitalreset),
                                .rst_rxa(rx_analogreset),
                                .rst_rxd(rx_digitalreset),


                                .tx_clkout(tx_10g_clkout),
                                .rx_clkout(rx_10g_clkout),
                                .clk_tx_common(din_clk),
                                .clk_rx_common(dout_clk),
                                                
                                .tx_pin(tx_pin),
                                .rx_pin(rx_pin),

                                .tx_din(tx_launch),
                                .rx_dout(rxd_wires),
                                
                                .tx_valid(tx_10g_data_valid),
                                .rx_ready(rx_10g_fifo_rd_en),
                                .rx_fifo_aclr(rx_10g_fifo_align_clr),
                                .rx_bitslip(10'b0),
                                .rx_valid(),
                                .rx_datalocked(freq_lock),
                                .rx_seriallpbken(sloop),
                                                        
                                .tx_full(tx_full),
                                .tx_pfull(tx_pfull),
                                .tx_empty(tx_empty),
                                .tx_pempty(tx_pempty),
                                .rx_full(rx_full),
                                .rx_pfull(rx_pfull),
                                .rx_empty(rx_empty),
                                .rx_pempty(rx_pempty),

                                .tx_cal_busy(tx_cal_busy),
                                .rx_cal_busy(rx_cal_busy),
                             
                                .reconfig_clk(reconfig_clk),                    // input  wire [0:0]   
                                .reconfig_reset(reconfig_reset),                // input  wire [0:0]   
                                .reconfig_write(reconfig_write),                // input  wire [0:0]   
                                .reconfig_read(reconfig_read),                  // input  wire [0:0]   
                                .reconfig_address(reconfig_address),            // input  wire [13:0]  
                                .reconfig_writedata(reconfig_writedata),        // input  wire [31:0]  
                                .reconfig_readdata(reconfig_readdata),          // output wire [31:0]  
                                .reconfig_waitrequest(reconfig_waitrequest),    // output wire [0:0]   
                                .tx_serial_clk(tx_serial_clk),

                                .set_lock_data(set_data_lock),
                                .set_lock_ref(set_ref_lock)
                        );      
                        assign txlock[0] = tx_pll_locked;
                        assign reconfig_from_xcvr = 920'd0;
        end
endgenerate

////////////////////////////////////////////
// data pipes
    
reg [9:0] tx_valid,tx_valid_1 = 0 /* synthesis preserve */;
always @(posedge din_clk) begin
        tx_launch_1 <= din;
        tx_launch   <= tx_launch_1;
        tx_valid_1  <= {10{din_valid}};
        tx_valid    <= tx_valid_1;
end
assign tx_10g_data_valid = tx_valid;

reg [16*20-1:0] rx_capture /* synthesis preserve */;
reg [9:0] rx_req /* synthesis preserve */;
always @(posedge dout_clk) begin
        rx_capture <= rxd_wires;
        rx_req <= dout_req;
end
assign rx_10g_fifo_rd_en = rx_req;
assign  dout = rx_capture;

////////////////////////////////////////////
// combine some of the flags

reg [9:0] flag_mx_meta = 0 /* synthesis preserve dont_replicate */
        /* synthesis ALTERA_ATTRIBUTE = "-name SDC_STATEMENT \"set_false_path -to [get_keepers *io_frame*flag_mx_meta\[*\]]\" " */;

always @(posedge status_clk) begin
        case (flag_sel)
                3'h0 : flag_mx_meta <= tx_full;
                3'h1 : flag_mx_meta <= tx_empty;
                3'h2 : flag_mx_meta <= tx_pfull;
                3'h3 : flag_mx_meta <= tx_pempty;
                3'h4 : flag_mx_meta <= rx_full;
                3'h5 : flag_mx_meta <= rx_empty;
                3'h6 : flag_mx_meta <= rx_pfull;
                3'h7 : flag_mx_meta <= rx_pempty;
        endcase
        flag_mx <= flag_mx_meta;
end

////////////////////////////////////////////
// reset control
assign cal_busy = tx_cal_busy | rx_cal_busy;
wire rd0_ready;
reset_delay rd0 (
        .clk(status_clk),
        .ready_in(!sys_rst & (!cal_busy)),
        .ready_out(rd0_ready)
);
defparam rd0 .CNTR_BITS = RST_CNTR;
assign pll_powerdown = !sys_rst && !rd0_ready & (!cal_busy);

wire rd1_ready;
reset_delay rd1 (
        .clk(status_clk),
        .ready_in(rd0_ready & (&tx_pll_lock_status)),
        .ready_out(rd1_ready)
);
defparam rd1 .CNTR_BITS = RST_CNTR;
assign tx_analogreset = !rd1_ready & (!cal_busy); //no analog reset when cal_busy
assign txa_online = !tx_analogreset;

wire rd2_ready;
reset_delay rd2 (
        .clk(status_clk),
        .ready_in(rd1_ready),
        .ready_out(rd2_ready)
);
defparam rd2 .CNTR_BITS = RST_CNTR;
assign rx_analogreset = (!rd2_ready) & (!cal_busy); //no analog reset when cal_busy

wire rd3_ready;
reset_delay rd3 (
        .clk(status_clk),
        .ready_in(rd2_ready & din_clk_ready), 
        .ready_out(rd3_ready)
);
defparam rd3 .CNTR_BITS = RST_CNTR;
assign tx_digitalreset = !rd3_ready;

reg rx_fifo_bad_r;
wire rd4_ready;
reset_delay rd4 (
        .clk(status_clk),
        .ready_in(rd3_ready & (&freq_lock) & dout_clk_ready & (~rx_fifo_bad_r)), 
        .ready_out(rd4_ready)
);
defparam rd4 .CNTR_BITS = RST_CNTR;
assign rx_digitalreset = !rd4_ready;

wire tx_online_sync;
wire rx_online_sync;
//reg [2:0] tx_online_r;

//assign rx_online = {10{rx_online_sync}};
assign tx_online = {3{tx_online_sync}};

always@(posedge dout_clk)begin
    rx_online <= {10{rx_online_sync}};
end
/*
always@(posedge din_clk)begin
//    tx_online <= {3{tx_online_sync}}; //only 1 clk delay will fail simulation
    tx_online_r <= {3{tx_online_sync}};
    tx_online <= tx_online_r;
end
*/

sync_regs sr0 (
        .clk(din_clk),
        .din({!tx_digitalreset}),
        .dout(tx_online_sync)
);
defparam sr0 .WIDTH = 1;

sync_regs sr1 (
        .clk(dout_clk),
        .din({!rx_digitalreset}),
        .dout(rx_online_sync)
);
defparam sr1 .WIDTH = 1;

aclr_filter f1(   // synchronizing deassertion
        .clk(dout_clk),
        .aclr(rx_digitalreset),
        .aclr_sync(rx_aclr_pcs_ready)
        );


sync_regs sr2 (
        .clk(dout_clk),
        .din ({|rx_full,       |rx_empty      }),
        .dout({rx_full_1bit_s, rx_empty_1bit_s})
);
defparam sr2 .WIDTH = 2;

//////////////////////////////////////////////
// FSM - Rx PCS FIFO Flush 
//       when overflow/underflow (full/empty) 
//////////////////////////////////////////////
always@(posedge dout_clk)begin
    state_r <= state_nx;
end

//state only
always@(*)begin
  state_nx = state_r;

  if (!rx_online[0]) state_nx = ST_FIFO_DEAD;
  else begin 
    case(state_r)
      ST_FIFO_DEAD:         if (rx_online[0])  state_nx = ST_FIFO_PURGING;
      ST_FIFO_PURGING:                      state_nx = ST_FIFO_GRACE_PERIOD;
      ST_FIFO_GRACE_PERIOD: if (!rx_backup) state_nx = ST_FIFO_HEALTHY;
      ST_FIFO_HEALTHY:      if(rx_full_1bit_s | rx_empty_1bit_s) state_nx = ST_FIFO_DEAD;     
    endcase // case (state_r)
  end   
end

//output
assign rx_fifo_bad = (state_r == ST_FIFO_HEALTHY) & (rx_full_1bit_s | rx_empty_1bit_s);    

//Fix for deskew not finish issue
always @(posedge dout_clk) rx_fifo_bad_r <= rx_fifo_bad;

endmodule
    
    
