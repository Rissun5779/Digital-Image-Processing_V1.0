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


// (C) 2001-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/main/ip/ethernet/alt_eth_ultra_100g/rtl/pcs/100_pcs_assembly.v#12 $
// $Revision: #12 $
// $Date: 2013/11/07 $
// $Author: rkane $
//-----------------------------------------------------------------------------

module alt_aeu_100_pcs_assembly #(
        parameter PHY_REFCLK = 1,
        parameter TARGET_CHIP = 2,
        parameter REVID = 32'h04012014,
        parameter SYNOPT_FULL_SKEW = 0,
        parameter SYNOPT_PTP = 0,
        parameter PTP_LATENCY = 52,
        parameter EN_LINK_FAULT = 0,
        parameter WORDS = 4,                    // no override
        parameter NUM_VLANE = 20,               // no override
        parameter ADDR_PAGE = 8'h1,
        parameter SIM_FAKE_JTAG = 1'b0,
        parameter AM_CNT_BITS = 14,             // nominal 14, 6 Ok for sim
        parameter RST_CNTR = 16,                // nominal 16/20  or 6 for fast simulation of reset seq
        parameter CREATE_TX_SKEW = 1'b0,        // debbug - insert TX side lane skew 
        parameter TIMING_MODE = 1'b0,
        parameter EXT_TX_PLL = 1'b0             // whether to use external fpll for TX core clocks
)(
        input pll_ref,
        output [9:0] etx_pin,
        input [9:0] erx_pin,
        
        input TX_CORE_CLK,
        input RX_CORE_CLK,
        
        //Sync-E
        output clk_rx_recover,
  
        // status port
        input clk100,
        input rst100,  //global reset; async, no domain
	input reset_status_async,  // reset_async and reset_status synced to clk_status
        input slave_din,
        output slave_dout,

        // mii tx port
        input clk_txmac_in,     // used with EXT_TX_PLL, 390.625MHz derived from clk_ref
        output clk_tx_main,
        output srst_tx_main,
        output tx_lanes_stable,
        input tx_crc_ins_en,
        input [WORDS*64-1:0] din_d, 
        input [WORDS*8-1:0] din_c, 
        output din_am,          // this din will be replaced with align marks
        output pre_din_am,      // leading indicator
                
        // mii rx port
        output clk_rx_main,
        output srst_rx_main,
        output reg rx_pcs_fully_aligned,
        output [WORDS*64-1:0] dout_d,
        output [WORDS*8-1:0] dout_c,
        output dout_am,                              // dout is an alignment mark position, discard
        output [199:0] dsk_depths,
        output [WORDS-1:0] tx_mii_start,
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
        input   [1399:0]    reconfig_to_xcvr,
        output  [919:0]     reconfig_from_xcvr,
        input               reconfig_busy
);
genvar i;

localparam NO_PMA = 0; 

//////////////////////////////////////
// 10x10G pin array
//////////////////////////////////////

reg eio_sys_rst = 1'b0;
reg [9:0] eio_sloop = 10'b0;
reg [2:0] eio_flag_sel = 3'b0;
wire [9:0] eio_flags;
wire [9:0] eio_tx_pll_locked;
wire [9:0] eio_freq_lock;
wire rxp_lock, txp_lock;
reg set_data_lock = 1'b0;
reg set_ref_lock = 1'b0;
    
wire [20*16-1:0] eio_din, eio_dout, eio_din_sep, eio_dout_sep;
wire eio_din_valid;
wire [3:0] eio_dout_req;
wire [2:0] eio_tx_online;
wire [9:0] eio_rx_online;
wire eio_rx_soft_purge;
wire [9:0] eio_rx_flush = (~eio_rx_online) | {10{eio_rx_soft_purge}};
wire [9:0] eio_rx_flush_b = (~eio_rx_online) | {10{eio_rx_soft_purge}};   

wire clk_tx_io;
wire txa_online;
wire rx_hi_ber_raw;
wire rx_pcs_fully_aligned_raw;
wire rx_aclr_pcs_ready;

// reset syncer
wire rst_sync_sts; 
assign rst_sync_sts = reset_status_async;
//syncer moved to top to be shared by Quan
/*
aclr_filter reset_syncer_sts(
        .aclr     (rst100), // global reset, async, no domain
        .clk      (clk100),     
        .aclr_sync(rst_sync_sts)
);
*/
   
// synthesis translate_off
always @(posedge eio_tx_online[0]) begin
        $display ("100G transmit IO now operating at time %d",$time);
end
always @(posedge eio_rx_online[0]) begin
        $display ("100G receive IO now operating at time %d",$time);
end
// synthesis translate_on

// after a RX sclr backup the FIFOs a little bit
wire rx_backup;
reg post_flush = 1'b0;
reg last_eio_rx_flush = 1'b0;
always @(posedge clk_rx_main) begin
        last_eio_rx_flush <= eio_rx_flush[0];
        post_flush <= (last_eio_rx_flush && !eio_rx_flush[0]);
end

grace_period_16 gp (
    .clk(clk_rx_main),
    .start_grace(post_flush),
    .grace(rx_backup)
);
defparam gp .TARGET_CHIP = TARGET_CHIP;

wire [9:0] dout_req /* synthesis keep */;

assign dout_req =  ( {10{eio_dout_req[0]}} | eio_rx_flush_b ) & {10{~rx_backup }} ;

e100_io_frame_32 iof (
        .pll_refclk (pll_ref),
        .tx_pin(etx_pin),
        .rx_pin(erx_pin),

        // status and control
        .status_clk(clk100),
        .sys_rst(eio_sys_rst | rst_sync_sts), 
        .sloop(eio_sloop),
        .flag_sel(eio_flag_sel),
        .flag_mx(eio_flags),
        .tx_pll_lock_status(eio_tx_pll_locked),
        .freq_lock(eio_freq_lock),
        .set_data_lock(set_data_lock),
        .set_ref_lock(set_ref_lock),
        .txa_online(txa_online),
                
        // data stream to TX pins
        .din_clk(clk_tx_main),
        .din_clk_ready(txp_lock),
        .din(eio_din), // lsbit first serial streams
        .din_valid(eio_din_valid & eio_tx_online[0]),
        .tx_online(eio_tx_online),
        .clk_tx_io(clk_tx_io),
        
        // data stream from RX pins
        .dout_clk(clk_rx_main),
        .dout_clk_ready(rxp_lock),
        .dout(eio_dout), // lsbit first serial streams
        .dout_req(dout_req),
        .rx_online(eio_rx_online),
        .rx_aclr_pcs_ready(rx_aclr_pcs_ready),
        .clk_rx_recovered(clk_rx_recover),
        
        .reconfig_clk(reconfig_clk),                    // input  wire [0:0]   
        .reconfig_reset(reconfig_reset),                // input  wire [0:0]   
        .reconfig_write(reconfig_write),                // input  wire [0:0]   
        .reconfig_read(reconfig_read),                  // input  wire [0:0]   
        .reconfig_address(reconfig_address),            // input  wire [13:0]  
        .reconfig_writedata(reconfig_writedata),        // input  wire [31:0]  
        .reconfig_readdata(reconfig_readdata),          // output wire [31:0]  
        .reconfig_waitrequest(reconfig_waitrequest),    // output wire [0:0]   
        .tx_serial_clk(tx_serial_clk),
        .tx_pll_locked(tx_pll_locked),
        
        .reconfig_to_xcvr(reconfig_to_xcvr),
        .reconfig_from_xcvr(reconfig_from_xcvr),
        .rx_backup(rx_backup)        
);
defparam iof .RST_CNTR = RST_CNTR;
defparam iof .TARGET_CHIP = TARGET_CHIP;
defparam iof .NO_PMA = NO_PMA;
defparam iof .PHY_REFCLK= PHY_REFCLK;

//////////////////////////////////////
// analog reconfig
//////////////////////////////////////

reg [6:0] reco_addr = 7'h0;
reg reco_read = 1'b0;
reg reco_write = 1'b0;
reg [31:0] reco_wdata;
wire [31:0] reco_rdata;
assign reco_rdata = 32'b0;

// generate
        // if (NO_PMA) begin
                // assign reconfig_busy = 1'b0;
        // end
        // else if (TARGET_CHIP == 2) begin
                // Reconfig controller now external
                // reco rc (
                        // .reconfig_busy(reconfig_busy),             //      reconfig_busy.reconfig_busy
                        // .mgmt_clk_clk(clk100),              //       mgmt_clk_clk.clk
                        // .mgmt_rst_reset(rst100),            //     mgmt_rst_reset.reset
                        // .reconfig_mgmt_address(reco_addr),     //      reconfig_mgmt.address
                        // .reconfig_mgmt_read(reco_read),        //                   .read
                        // .reconfig_mgmt_readdata(reco_rdata),    //                   .readdata
                        // .reconfig_mgmt_waitrequest(), //                   .waitrequest
                        // .reconfig_mgmt_write(reco_write),       //                   .write
                        // .reconfig_mgmt_writedata(reco_wdata),   //                   .writedata
                        // .reconfig_to_xcvr(eio_reconfig_to_xcvr),          //   reconfig_to_xcvr.reconfig_to_xcvr
                        // .reconfig_from_xcvr(eio_reconfig_from_xcvr)         // reconfig_from_xcvr.reconfig_from_xcvr
                // );
        // end
// endgenerate

//////////////////////////////////////
// MAC rate PLLs
//////////////////////////////////////

wire rxp_rst;
wire rxp_lock_i;
reg soft_rxp_rst = 1'b0;

reg rxp_ignore_freq = 1'b0;
wire rxp_rst_in = soft_rxp_rst || !((&eio_freq_lock) | rxp_ignore_freq);
wire rxp_rst_s;

sync_regs rxp_rst_sync(
        .clk(clk100),
        .din(rxp_rst_in),
        .dout(rxp_rst_s)      
);
defparam rxp_rst_sync .WIDTH = 1;

reg [3:0] rxp_rst_cnt = 4'b0;
wire rxp_rst_dly = &rxp_rst_cnt;

// delay pll reset to allow logic to be safely reset first
always @(posedge clk100) begin
    if(~rxp_rst_s) rxp_rst_cnt <= 4'b0;
    else if(~rxp_rst_dly) rxp_rst_cnt <= rxp_rst_cnt+1'b1;
end

wire rd4_ready;
reset_delay rd4 (
        .clk(clk100),
        .ready_in(~rxp_rst_dly),
        .ready_out(rd4_ready)
);
defparam rd4 .CNTR_BITS = RST_CNTR;
assign rxp_rst = !rd4_ready;



wire txp_rst;
reg soft_txp_rst = 1'b0;

wire rd5_ready;
reset_delay rd5 (
        .clk(clk100),
        .ready_in((~soft_txp_rst)),
        .ready_out(rd5_ready)
);
defparam rd5 .CNTR_BITS = RST_CNTR;
assign txp_rst = ~rd5_ready;

generate
if (TIMING_MODE) begin
assign rxp_lock = 1'b1;
assign txp_lock = 1'b1;
assign clk_rx_main = RX_CORE_CLK;
assign clk_tx_main = TX_CORE_CLK;
end
else if (NO_PMA) begin
        reg fake_clk = 0;
        always begin #1280; fake_clk = ~fake_clk; end
        assign clk_rx_main = fake_clk;
        assign clk_tx_main = fake_clk;
end
else begin

assign rxp_lock = rxp_lock_i && !rxp_rst_s;

e100_rx_pll rxp (
                .refclk(clk_rx_recover),  
                .rst(rxp_rst),     
                .outclk_0(clk_rx_main),
                .outclk_1(),   
                .locked(rxp_lock_i) 
);
if(EXT_TX_PLL) begin
 assign txp_lock = 1'b1;
 assign clk_tx_main = clk_txmac_in;
end else begin
  if (PHY_REFCLK== 1) begin : TX_PLL_644
     e100_tx_pll_644 txp (
                .refclk(pll_ref),  
                .rst(txp_rst),     
                .outclk_0(clk_tx_main),
                .outclk_1(),   
                .locked(txp_lock) 
     );
   end else begin : TX_PLL_322 
     e100_tx_pll_322 txp (
                .refclk(pll_ref),  
                .rst(txp_rst),     
                .outclk_0(clk_tx_main),
                .outclk_1(),   
                .locked(txp_lock) 
     );
  end 
end
end
endgenerate

//////////////////////////////////////////////
// clock monitor
//////////////////////////////////////////////

wire [19:0] khz_ref,khz_rx,khz_tx,khz_rx_rec,khz_tx_io;
frequency_monitor fm0 (
        .signal({pll_ref,clk_rx_main,clk_tx_main,clk_rx_recover,clk_tx_io}),
        .ref_clk(clk100),
        .khz_counters ({khz_ref,khz_rx,khz_tx,khz_rx_rec,khz_tx_io})
);
defparam fm0 .NUM_SIGNALS = 5;
defparam fm0 .REF_KHZ = 20'd100000;

//////////////////////////////////////
// PCS
//////////////////////////////////////

wire [NUM_VLANE-1:0] frm_err_out;
wire [NUM_VLANE-1:0] opp_ping_out;
wire sclr_frm_err_s;
wire rx_pcs_soft_rst;

alt_aeu_100_rx_pcs_4 rpcs (
    .clk(clk_rx_main),
    .sclr(!eio_rx_online[2] || rx_pcs_soft_rst),
    .rst_async (rst100),   // global reset, async, no domain
    .din(eio_dout_sep), // lsbit first serial streams
    .din_req(eio_dout_req), // 4 copies
    
    .sclr_frm_err(sclr_frm_err_s),
    .frm_err_out(frm_err_out),
    .opp_ping_out(opp_ping_out),
    .rx_pcs_fully_aligned(rx_pcs_fully_aligned_raw), 
    .hi_ber(rx_hi_ber_raw),
    
    .dout_d(dout_d),
    .dout_c(dout_c),
    .dsk_depths(dsk_depths),
    .dout_am(dout_am)
);
defparam rpcs .TARGET_CHIP = TARGET_CHIP;
defparam rpcs .EN_LINK_FAULT = EN_LINK_FAULT;
defparam rpcs .AM_CNT_BITS = AM_CNT_BITS;
defparam rpcs .SIM_FAKE_JTAG = SIM_FAKE_JTAG;
defparam rpcs .EARLY_REQ = 2;
defparam rpcs .SYNOPT_FULL_SKEW = SYNOPT_FULL_SKEW;

alt_aeu_100_tx_pcs_4 tpcs (
    .clk(clk_tx_main),
    .sclr(!eio_tx_online[1]),
    
    .din_d(din_d), 
    .din_c(din_c), 
    .din_am(din_am),  // this din_d/c will be replaced with align markers
        .pre_din_am(pre_din_am), // advance warning
    .tx_crc_ins_en(tx_crc_ins_en),
            
    .dout(eio_din_sep), // lsbit first serial streams
    .dout_valid(eio_din_valid),
    .tx_mii_start(tx_mii_start)
);
defparam tpcs .TARGET_CHIP = TARGET_CHIP;
   defparam tpcs .SYNOPT_PTP = SYNOPT_PTP;
   defparam tpcs .PTP_LATENCY = PTP_LATENCY;
defparam tpcs .EN_LINK_FAULT = EN_LINK_FAULT;
defparam tpcs .AM_CNT_BITS = AM_CNT_BITS;
defparam tpcs .CREATE_TX_SKEW = CREATE_TX_SKEW;

// deal with odd-even bit interleaving
generate
        for (i=0; i<10; i=i+1) begin : lp
                mix_odd_even moe (
                        .din(eio_din_sep[(i+1)*32-1:i*32]),
                        .dout(eio_din[(i+1)*32-1:i*32])
                );
                defparam moe .WIDTH = 32;
                
                sep_odd_even soe (
                        .din(eio_dout[(i+1)*32-1:i*32]),
                        .dout(eio_dout_sep[(i+1)*32-1:i*32])
                );
                defparam soe .WIDTH = 32;
                
        end
endgenerate

wire [NUM_VLANE-1:0] frm_err_out_s;
sync_regs sr1 (
        .clk (clk100),
        .din(frm_err_out & {NUM_VLANE{rxp_lock}}),
        .dout(frm_err_out_s)
);
defparam sr1 .WIDTH = NUM_VLANE;

reg sclr_frm_err = 1'b0;
sync_regs sr2 (
        .clk (clk_rx_main),
        .din(sclr_frm_err),
        .dout(sclr_frm_err_s)
);
defparam sr2 .WIDTH = 1;

reg rx_pcs_soft_rst_s = 1'b0;
reg eio_rx_soft_purge_s = 1'b0;

sync_regs sr3(
        .clk(clk_rx_main),
        .din({eio_rx_soft_purge_s,rx_pcs_soft_rst_s}),
        .dout({eio_rx_soft_purge,rx_pcs_soft_rst})      
);
defparam sr3 .WIDTH = 2;

wire rx_pcs_fully_aligned_s;
wire rx_hi_ber;
wire rx_hi_ber_s;

//assign rx_pcs_fully_aligned = rx_pcs_fully_aligned_raw && eio_rx_online;
initial rx_pcs_fully_aligned = 1'b0;
always @(posedge clk_rx_main or posedge rx_aclr_pcs_ready) begin
    if (rx_aclr_pcs_ready) rx_pcs_fully_aligned <= 1'b0;
    else                   rx_pcs_fully_aligned <= rx_pcs_fully_aligned_raw;
end



assign rx_hi_ber = rx_hi_ber_raw & eio_rx_online[0];

reg rx_hi_ber_r;

always @(posedge clk_rx_main) begin
        rx_hi_ber_r <= rx_hi_ber;
end
   
sync_regs sr4(
        .clk(clk100),
        .din( {rx_hi_ber_r,   rx_pcs_fully_aligned}),
        .dout({rx_hi_ber_s, rx_pcs_fully_aligned_s})    
);
defparam sr4 .WIDTH = 2;

//////////////////////////////////////////////
// status page - 100G IO pins
//////////////////////////////////////////////

wire ss1_wr, ss1_rd;
wire [7:0] ss1_addr;
wire [31:0] ss1_wdata;
reg [31:0] ss1_rdata = 32'h0;
reg ss1_rdata_valid = 1'b0;
wire ss1_dout;

serif_slave ss1 (
    .clk(clk100),
    .aclr_100( rst_sync_sts ), //acync reset in csr clock domain
    .din(slave_din),
    .dout(slave_dout),

    .wr(ss1_wr),
    .rd(ss1_rd),
    .addr(ss1_addr),
    .wdata(ss1_wdata),
    .rdata(ss1_rdata),
    .rdata_valid(ss1_rdata_valid)
);
defparam ss1 .ADDR_PAGE = ADDR_PAGE;


wire txa_online_100;
wire [9:0] eio_freq_lock_100;
wire eio_tx_pll_locked_100;

sync_regs txa_online_syncer (
        .clk(clk100),
        .din(txa_online),
        .dout(txa_online_100)
);
defparam txa_online_syncer .WIDTH = 1;

sync_regs eio_freq_lock_syncer (
        .clk(clk100),
        .din(eio_freq_lock),
        .dout(eio_freq_lock_100)
);
defparam eio_freq_lock_syncer .WIDTH = 10;

sync_regs eio_tx_pll_locked_syncer (
        .clk(clk100),
        .din(eio_tx_pll_locked[0]),
        .dout(eio_tx_pll_locked_100)
);
defparam eio_tx_pll_locked_syncer .WIDTH = 1;

reg [31:0] scratch1 = 32'h0;
wire [12*8-1:0] io_name = "100GE pcs   ";
always @(posedge clk100) begin
    ss1_rdata_valid <= 1'b0;
    if (ss1_rd) begin
        ss1_rdata_valid <= 1'b1;
        case (ss1_addr)
            8'h0 : ss1_rdata <= REVID;
            8'h1 : ss1_rdata <= 32'h0 | scratch1;
            8'h2 : ss1_rdata <= 32'h0 | io_name[8*12-1:8*8];
            8'h3 : ss1_rdata <= 32'h0 | io_name[8*8-1:8*4];
            8'h4 : ss1_rdata <= 32'h0 | io_name[8*4-1:0];
            
            8'h10 : ss1_rdata <= 32'h0 | {set_data_lock,set_ref_lock,rxp_ignore_freq,soft_rxp_rst,
                                                                                        soft_txp_rst,eio_sys_rst};
            8'h13 : ss1_rdata <= 32'h0 | eio_sloop;
            8'h14 : ss1_rdata <= 32'h0 | eio_flag_sel;
            8'h15 : ss1_rdata <= 32'h0 | eio_flags;
            
            8'h20 : ss1_rdata <= 32'h0 | {10{eio_tx_pll_locked_100}};
            8'h21 : ss1_rdata <= 32'h0 | eio_freq_lock_100;
            8'h22 : ss1_rdata <= 32'h0 | {rxp_lock,txp_lock,txa_online_100};
            8'h23 : ss1_rdata <= 32'h0 | frm_err_out_s;
            8'h24 : ss1_rdata <= 32'h0 | sclr_frm_err;
            8'h25 : ss1_rdata <= 32'h0 | {eio_rx_soft_purge_s,rx_pcs_soft_rst_s};
            8'h26 : ss1_rdata <= 32'h0 | {rx_hi_ber_s, rx_pcs_fully_aligned_s};
                        
            8'h40 : ss1_rdata <= 32'h0 | khz_ref;
            8'h41 : ss1_rdata <= 32'h0 | khz_rx;
            8'h42 : ss1_rdata <= 32'h0 | khz_tx;
            8'h43 : ss1_rdata <= 32'h0 | khz_rx_rec;
            8'h44 : ss1_rdata <= 32'h0 | khz_tx_io;

            8'h50 : ss1_rdata <= 32'h0 | reco_addr;
            8'h51 : ss1_rdata <= 32'h0 | {reco_write,reco_read};
            8'h52 : ss1_rdata <= 32'h0 | reco_wdata;
            8'h53 : ss1_rdata <= 32'h0 | reco_rdata;
            
            default : ss1_rdata <= 32'hdeadc0de;
        endcase
    end

    if (ss1_wr) begin
        case (ss1_addr)
            8'h1 : scratch1 <= ss1_wdata;
            8'h10 : {set_data_lock,set_ref_lock,rxp_ignore_freq,soft_rxp_rst,
                                                soft_txp_rst,eio_sys_rst} <= ss1_wdata[5:0];
        
            8'h13 : eio_sloop <= ss1_wdata[9:0];             
            8'h14 : eio_flag_sel <= ss1_wdata[2:0];             
            
            8'h24 : sclr_frm_err <= ss1_wdata[0];
            8'h25 : {eio_rx_soft_purge_s,rx_pcs_soft_rst_s} <= ss1_wdata[1:0];
                        
            8'h50 : reco_addr <= ss1_wdata[6:0];
            8'h51 : {reco_write,reco_read} <= ss1_wdata[1:0];
            8'h52 : reco_wdata <= ss1_wdata;
                                
        endcase
    end
end

//////////////////////////////////////////////
// resets
//////////////////////////////////////////////
reg tx_lanes_stable_r = 1'b0;
always @(posedge clk_tx_main) begin
        tx_lanes_stable_r <= eio_tx_online[2];
end
assign tx_lanes_stable = tx_lanes_stable_r && txp_lock;

reg srst_tx_main_r = 1'b0;
always @(posedge clk_tx_main) begin
        srst_tx_main_r <= !eio_tx_online[2];
end
assign srst_tx_main = srst_tx_main_r;

reg srst_rx_main_r = 1'b0;
always @(posedge clk_rx_main) begin
        srst_rx_main_r <= !eio_rx_online[3];
end
assign srst_rx_main = srst_rx_main_r;

/////////////////////////////////////////////////////////
// debug
/////////////////////////////////////////////////////////
/*              
// synthesis translate_off
reg [20*16-1:0] eio_dout_sep_r;
reg [3:0] eio_dout_req_r, eio_dout_req_r2;
always @(posedge clk_rx_main) eio_dout_req_r <= eio_dout_req;
always @(posedge clk_rx_main) eio_dout_req_r2 <= eio_dout_req_r;
always @(posedge clk_rx_main) if (eio_dout_req_r2[0]) eio_dout_sep_r <= eio_dout_sep;

always @(posedge clk_rx_main)
begin
    if (rx_pcs_fully_aligned && eio_dout_req_r2[0]) $display("TORXPCS  0 %h", eio_dout_sep[15:0]);
    if (rx_pcs_fully_aligned && eio_dout_req_r2[0]) $display("TORXPCS  1 %h", {eio_dout_sep[15:1], eio_dout_sep_r[15]});
    if (rx_pcs_fully_aligned && eio_dout_req_r2[0]) $display("TORXPCS  2 %h", {eio_dout_sep[15:2], eio_dout_sep_r[15:14]});
    if (rx_pcs_fully_aligned && eio_dout_req_r2[0]) $display("TORXPCS  3 %h", {eio_dout_sep[15:3], eio_dout_sep_r[15:13]});
    if (rx_pcs_fully_aligned && eio_dout_req_r2[0]) $display("TORXPCS  4 %h", {eio_dout_sep[15:4], eio_dout_sep_r[15:12]});
    if (rx_pcs_fully_aligned && eio_dout_req_r2[0]) $display("TORXPCS  5 %h", {eio_dout_sep[15:5], eio_dout_sep_r[15:11]});
    if (rx_pcs_fully_aligned && eio_dout_req_r2[0]) $display("TORXPCS  6 %h", {eio_dout_sep[15:6], eio_dout_sep_r[15:10]});
    if (rx_pcs_fully_aligned && eio_dout_req_r2[0]) $display("TORXPCS  7 %h", {eio_dout_sep[15:7], eio_dout_sep_r[15:9]});
    if (rx_pcs_fully_aligned && eio_dout_req_r2[0]) $display("TORXPCS  8 %h", {eio_dout_sep[15:8], eio_dout_sep_r[15:8]});
    if (rx_pcs_fully_aligned && eio_dout_req_r2[0]) $display("TORXPCS  9 %h", {eio_dout_sep[15:9], eio_dout_sep_r[15:7]});
    if (rx_pcs_fully_aligned && eio_dout_req_r2[0]) $display("TORXPCS  a %h", {eio_dout_sep[15:10], eio_dout_sep_r[15:6]});
    if (rx_pcs_fully_aligned && eio_dout_req_r2[0]) $display("TORXPCS  b %h", {eio_dout_sep[15:11], eio_dout_sep_r[15:5]});
    if (rx_pcs_fully_aligned && eio_dout_req_r2[0]) $display("TORXPCS  c %h", {eio_dout_sep[15:12], eio_dout_sep_r[15:4]});
    if (rx_pcs_fully_aligned && eio_dout_req_r2[0]) $display("TORXPCS  d %h", {eio_dout_sep[15:13], eio_dout_sep_r[15:3]});
    if (rx_pcs_fully_aligned && eio_dout_req_r2[0]) $display("TORXPCS  e %h", {eio_dout_sep[15:14], eio_dout_sep_r[15:2]});
    if (rx_pcs_fully_aligned && eio_dout_req_r2[0]) $display("TORXPCS  f %h", {eio_dout_sep[15], eio_dout_sep_r[15:1]});
end
// synthesis translate_on
*/
endmodule
