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


`timescale 1ps / 1ps
module alt_aeu_100_eth_4 #(
    parameter SYNOPT_FULL_SKEW = 0,
    parameter SYNOPT_PTP = 0,
    parameter SYNOPT_TOD_FMT = 0,
    parameter PTP_LATENCY = 52,
    parameter PTP_FP_WIDTH = 16, // width of fingerprint, ptp parameter
    parameter PHY_REFCLK = 1,
    parameter SYNOPT_CAUI4 = 0,
    parameter SYNOPT_C4_RSFEC = 0,
    parameter SYNOPT_AVG_IPG = 12,
    parameter SYNOPT_LINK_FAULT = 0,
    parameter SYNOPT_TXCRC_INS = 1,
    parameter SYNOPT_MAC_DIC = 1,
    parameter SYNOPT_PREAMBLE_PASS = 1,
    parameter SYNOPT_ALIGN_FCSEOP = 0,
    parameter TARGET_CHIP = 2,
    parameter SYNOPT_MAC_RXSTATS = 1,
    parameter SYNOPT_MAC_TXSTATS = 1,
    parameter SYNOPT_STRICT_SOP  = 0, // UNH SFD compliance feature                                

    parameter VIRT_PCS = 0,
    parameter REVID = 32'h04142014,
    parameter BASE_PHY = 1,
    parameter BASE_TXMAC = 4,
    parameter BASE_RXMAC = 5,
    parameter BASE_TXSTAT = 6,
    parameter BASE_RXSTAT = 7,
    parameter BASE_TXFEC = 12,
    parameter BASE_RXFEC = 13,
    parameter ERRORBITWIDTH  = 11,
    parameter STATSBITWIDTH  = 32,  // includes errors
    parameter RXERRWIDTH  = 6,
    parameter RXSTATUSWIDTH = 3,

    parameter PCS_ADDR_PAGE = 1,    // to be removed (replaced by BASE_PHY)
    parameter RST_CNTR = 16,        // nominal 16/20  or 6 for fast sim of reset seq
    parameter SIM_FAKE_JTAG = 1'b0,
    parameter AM_CNT_BITS = 14,     // 6 Ok for sim
    parameter WORDS = 4,            // no override
    parameter CREATE_TX_SKEW = 1'b0, // debug skew the TX lanes
    parameter TIMING_MODE = 1'b0,
    parameter EXT_TX_PLL = 1'b0 // whether to use external fpll for TX core clocks
    )(
    // 100G IO for the Ethernet
    input                 clk_ref_r,
    input [9:0]           erx_pin,
    output [9:0]          etx_pin,

    input TX_CORE_CLK,
    input RX_CORE_CLK,

    //Sync-E
    output wire           clk_rx_recover,

    // CSR access
    input                 avmm_clk,             // 100 MHz
    input                 avmm_reset,           // global reset, async
    input 		reset_status_async,	// reset status synced to status clock domain
    output wire           e100_slave_dout,      // TBD: need to rename this since it ins not only pcs regs
    input                 pcs_slave_din,
    output wire[STATSBITWIDTH-1:0] out_tx_stats,
    output wire[STATSBITWIDTH-1:0] out_rx_stats,
    output wire[15:0]     tx_inc_octetsOK,
    output wire           tx_inc_octetsOK_valid,
    output wire[15:0]     rx_inc_octetsOK,
    output wire           rx_inc_octetsOK_valid,

    // ptp tx realted csr
    input [19:0]         txmclk_period,
    input [18:0] tx_asym_delay,
    input [31:0] tx_pma_delay,
    input cust_mode,
    // ptp related inouts - begin
    input [31:0] ext_lat,
    input din_ptp_dbg_adp,
    input din_sop_adp,
    input din_ptp_asm_adp,
    output ts_out_cust_asm,

    input ts_out_req_adp,
    input [PTP_FP_WIDTH-1:0] fp_out_req_adp,
    input ins_ts_adp,
    input ins_ts_format_adp,
    input tx_asym_adp,
    input upd_corr_adp,
    input [95:0] ing_ts_96_adp,
    input [63:0] ing_ts_64_adp,
    input corr_format_adp,
    input chk_sum_zero_adp,
    input chk_sum_upd_adp,
    input [15:0] ts_offset_adp,
    input [15:0] corr_offset_adp,
    input [15:0] chk_sum_zero_offset_adp,
    input [15:0] chk_sum_upd_offset_adp,

    output [160-1:0] ts_exit,
    output ts_exit_valid,

    // ptp related inouts -end
    output                pcs_din_am,
    output [WORDS*8-1:0]  pcs_din_c,
    output [WORDS*64-1:0] pcs_din_d,

    // TX
    input                 clk_txmac_in,   // used with EXT_TX_PLL, 390.625MHz derived from clk_ref
    output                clk_tx_main,
    output                srst_tx_main,
    output                tx_lanes_stable,
    input [WORDS-1:0]     din_sop,        // word contains first data (on leftmost byte)
    input [WORDS-1:0]     din_eop,        // byte position of last data
    input [WORDS-1:0]     din_idle,       // bytes between EOP and SOP
    input [3*WORDS-1:0]   din_eop_empty,  // byte position of last data
    input [WORDS*64-1:0]  din,            // data, read left to right
    input [WORDS-1:0]     tx_error,
    output                din_req,
    output                din_bus_error,
    output [WORDS-1:0]    tx_mii_start,

    // RX
    output                clk_rx_main,
    output                srst_rx_main,
    output                rx_data_out_valid,
    output [WORDS*64-1:0] rx_data_out,  // read bytes left to right
    output [WORDS*8-1:0]  rx_ctl_out,   // read bits left to right
    output [WORDS-1:0]    rx_first_data,// word contains the first non-preamble data of a frame
    output [WORDS*8-1:0]  rx_last_data, // byte contains the last data before FCS
    output                rx_fcs_error,
    output                rx_fcs_valid,
    output                rx_pcs_fully_aligned,
    output                unidirectional_en,
    output                link_fault_gen_en,
    output                remote_fault_status,
    output                local_fault_status,
    output [WORDS-1:0]    rx_mii_start,
    output wire [199:0]   dsk_depths,

    input [95:0] tod_96b_txmac_in,
    input [63:0] tod_64b_txmac_in,
    output                dout_valid,
    output [WORDS*64-1:0] dout_d,
    output [WORDS*8-1:0]  dout_c,
    output [WORDS-1:0]    dout_sop,
    output [WORDS-1:0]    dout_eop,
    output [WORDS*3-1:0]  dout_eop_empty,
    output [WORDS-1:0]    dout_idle,
    output [RXERRWIDTH-1:0] rx_error,
    output [RXSTATUSWIDTH-1:0] rx_status,

    input [95:0] tod_cust_in,
    output [95:0] tod_exit_cust,
    output [95:0] ts_out_cust,

    output [PTP_FP_WIDTH-1:0] fp_out,

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

wire rst_async;   //global reset from Pin
assign rst_async = avmm_reset;

wire tx_crc_ins_en;

// mii tx port
wire pre_pcs_din_am; // leading indicator

// mii rx port
wire [WORDS*64-1:0] pcs_dout_d;
wire [WORDS*8-1:0] pcs_dout_c;
wire pcs_dout_am;
wire epa_csr_dout, serif_rxmac_dout, serif_txmac_dout;
assign e100_slave_dout = epa_csr_dout & serif_rxmac_dout & serif_txmac_dout;

wire rst_sync_sts;
assign rst_sync_sts=reset_status_async;

generate
    if (VIRT_PCS) begin : virt_phy
        reg clk_tx_main_reg = 0;
        reg clk_rx_main_reg = 0;
        assign etx_pin = 10'b0;
        assign epa_csr_dout = 1'b1;
        assign clk_tx_main = clk_tx_main_reg;
        assign clk_rx_main = clk_rx_main_reg;
        assign srst_tx_main = rst_async;
        assign tx_lanes_stable = !rst_async;
        assign srst_rx_main = rst_async;
        assign rx_pcs_fully_aligned = 1'b1;
        assign pcs_din_am = 1'b0;
        assign pre_pcs_din_am = 1'b0;
        assign pcs_dout_d = pcs_din_d;
        assign pcs_dout_c = pcs_din_c;
        assign pcs_dout_am = 1'b0;
        assign dsk_depths = 200'b0;
        assign tx_mii_start = 4'b0;

        always begin
            clk_rx_main_reg = ~clk_rx_main_reg;
            clk_tx_main_reg = ~clk_tx_main_reg;
            #1280;
        end
    end else if (SYNOPT_CAUI4) begin: phy
        assign reconfig_from_xcvr = 920'd0;

        caui4_e100_pcs_assembly #(
            .PHY_REFCLK       (PHY_REFCLK),
            .ADDR_PAGE        (BASE_PHY),
            .REVID            (REVID),
            .SYNOPT_C4_RSFEC  (SYNOPT_C4_RSFEC),
            .BASE_TXFEC       (BASE_TXFEC),
            .BASE_RXFEC       (BASE_RXFEC),
            .SYNOPT_FULL_SKEW (SYNOPT_FULL_SKEW),
            .TIMING_MODE      (TIMING_MODE),
            .EXT_TX_PLL       (EXT_TX_PLL)
        ) epa (
            .pll_ref(clk_ref_r),
            .etx_pin(etx_pin[3:0]),
            .erx_pin(erx_pin[3:0]),

            .TX_CORE_CLK(TX_CORE_CLK),
            .RX_CORE_CLK(RX_CORE_CLK),

            //Sync-E
            .clk_rx_recover_syncE (clk_rx_recover),

            // status port
            .clk100(avmm_clk),
            .rst100(rst_async),         // global reset, async
		.reset_status_async(reset_status_async),         // reset_async and reset_status synced to clk_status 
            .slave_din(pcs_slave_din),
            .slave_dout(epa_csr_dout),

            // mii tx port
            .clk_txmac_in(clk_txmac_in),
            .clk_tx_main(clk_tx_main),
            .srst_tx_main(srst_tx_main),
            .tx_lanes_stable(tx_lanes_stable),
            .din_d(pcs_din_d),
            .din_c(pcs_din_c),
            .din_am(pcs_din_am),          // this din will be replaced with align marks
            .pre_din_am(pre_pcs_din_am),  // leading indicator
            .tx_crc_ins_en(tx_crc_ins_en),
            .tx_mii_start(tx_mii_start),

            // mii rx port
            .clk_rx_main(clk_rx_main),
            .srst_rx_main(srst_rx_main),
            .rx_pcs_fully_aligned(rx_pcs_fully_aligned),
            .dout_d(pcs_dout_d),
            .dout_c(pcs_dout_c),
            .dsk_depths(dsk_depths),
            .dout_am(pcs_dout_am),

            .reconfig_clk(reconfig_clk),                    // input  wire [0:0]
            .reconfig_reset(reconfig_reset),                // input  wire [0:0]
            .reconfig_write(reconfig_write),                // input  wire [0:0]
            .reconfig_read(reconfig_read),                  // input  wire [0:0]
            .reconfig_address(reconfig_address[11:0]),      // input  wire [11:0]
            .reconfig_writedata(reconfig_writedata),        // input  wire [31:0]
            .reconfig_readdata(reconfig_readdata),          // output wire [31:0]
            .reconfig_waitrequest(reconfig_waitrequest),    // output wire [0:0]
            .tx_serial_clk(tx_serial_clk[3:0]),
            .tx_pll_locked(tx_pll_locked)
        );
        defparam epa .TARGET_CHIP = TARGET_CHIP;
        defparam epa .EN_LINK_FAULT = SYNOPT_LINK_FAULT;
        defparam epa .SIM_FAKE_JTAG = SIM_FAKE_JTAG;
        defparam epa .AM_CNT_BITS = AM_CNT_BITS;  // 14 nom, 6 Ok for sim
        defparam epa .RST_CNTR = RST_CNTR;        // nominal 16/20 or 6 for fast sim of reset seq
        defparam epa .CREATE_TX_SKEW = CREATE_TX_SKEW;
        defparam epa .SYNOPT_PTP = SYNOPT_PTP;
        defparam epa .PTP_LATENCY = PTP_LATENCY;
        assign etx_pin[9:4] = 6'b0;
    end else begin: phy
        alt_aeu_100_pcs_assembly #(
            .PHY_REFCLK     (PHY_REFCLK),
            .ADDR_PAGE      (BASE_PHY),
            .REVID          (REVID),
            .SYNOPT_FULL_SKEW(SYNOPT_FULL_SKEW),
            .TIMING_MODE    (TIMING_MODE),
            .EXT_TX_PLL    (EXT_TX_PLL)
        ) epa (
            .pll_ref(clk_ref_r),
            .etx_pin(etx_pin),
            .erx_pin(erx_pin),

            .TX_CORE_CLK(TX_CORE_CLK),
            .RX_CORE_CLK(RX_CORE_CLK),

            //Sync-E
            .clk_rx_recover (clk_rx_recover),

            // status port
            .clk100(avmm_clk),
            .rst100(rst_async), // global reset, async
	    .reset_status_async(reset_status_async),         // reset_async and reset_status synced to clk_status 
            .slave_din(pcs_slave_din),
            .slave_dout(epa_csr_dout),

            // mii tx port
            .clk_txmac_in(clk_txmac_in),
            .clk_tx_main(clk_tx_main),
            .srst_tx_main(srst_tx_main),
            .tx_lanes_stable(tx_lanes_stable),
            .din_d(pcs_din_d),
            .din_c(pcs_din_c),
            .din_am(pcs_din_am),            // this din will be replaced with align marks
            .pre_din_am(pre_pcs_din_am),    // leading indicator
            .tx_crc_ins_en(tx_crc_ins_en),
            .tx_mii_start(tx_mii_start),

            // mii rx port
            .clk_rx_main(clk_rx_main),
            .srst_rx_main(srst_rx_main),
            .rx_pcs_fully_aligned(rx_pcs_fully_aligned),
            .dout_d(pcs_dout_d),
            .dout_c(pcs_dout_c),
            .dsk_depths(dsk_depths),
            .dout_am(pcs_dout_am),
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
            .reconfig_busy(reconfig_busy)
        );
        defparam epa .TARGET_CHIP = TARGET_CHIP;
        defparam epa .EN_LINK_FAULT = SYNOPT_LINK_FAULT;
        defparam epa .SIM_FAKE_JTAG = SIM_FAKE_JTAG;
        defparam epa .AM_CNT_BITS = AM_CNT_BITS;  // 14 nom, 6 Ok for sim
        defparam epa .RST_CNTR = RST_CNTR;        // nominal 16/20 or 6 for fast sim of reset seq
        defparam epa .CREATE_TX_SKEW = CREATE_TX_SKEW;
        defparam epa .SYNOPT_PTP = SYNOPT_PTP;
        defparam epa .PTP_LATENCY = PTP_LATENCY;
    end
endgenerate

// switch from PCS  (read bytes right to left) to MAC  (read left to right)
wire [WORDS*64-1:0] pcs_dout_d_rev;
wire [WORDS*8-1:0] pcs_dout_c_rev;

reverse_bytes rb0 (.din(pcs_dout_d),.dout(pcs_dout_d_rev));
defparam rb0 .NUM_BYTES = WORDS*8;

reverse_bits rb1 (.din(pcs_dout_c),.dout(pcs_dout_c_rev));
defparam rb1 .WIDTH = WORDS*8;

wire [5:0] l8_rx_empty;
wire [511:0] l8_rx_data;

alt_aeu_100_mac_rx_4 #(
    .BASE_RXMAC            (BASE_RXMAC),
    .BASE_RXSTAT           (BASE_RXSTAT),
    .REVID                 (REVID),
    .SYNOPT_RXSTATS        (SYNOPT_MAC_RXSTATS),
    .ERRORBITWIDTH         (ERRORBITWIDTH),
    .STATSBITWIDTH         (STATSBITWIDTH),
    .RXERRWIDTH            (RXERRWIDTH),
    .RXSTATUSWIDTH         (RXSTATUSWIDTH),
    .SYNOPT_PREAMBLE_PASS  (SYNOPT_PREAMBLE_PASS),
    .SYNOPT_STRICT_SOP     (SYNOPT_STRICT_SOP)
) erx (
    .clk(clk_rx_main),
    .reset_rx(srst_rx_main),
    .reset_csr(rst_async), // global reset, async
    .rst_sync_sts 		(rst_sync_sts),		//async reset in 100M after synchronizer
    .clk_csr(avmm_clk),
    .serif_slave_din(pcs_slave_din),
    .serif_slave_dout(serif_rxmac_dout),

    // raw CGMII stream in
    .mii_in_valid(!pcs_dout_am),
    .mii_data_in(pcs_dout_d_rev), // read bytes left to right
    .mii_ctl_in(pcs_dout_c_rev),  // read bits left to right
    .rx_pcs_fully_aligned(rx_pcs_fully_aligned),

    // annotated output
    .out_valid(rx_data_out_valid),
    .data_out(rx_data_out),       // read bytes left to right
    .ctl_out(rx_ctl_out),         // read bits left to right
    .first_data(rx_first_data),   // word contains the first non-preamble data of a frame
    .last_data(rx_last_data),     // byte contains the last data before FCS

    // lagged (N) cycles from the non-zero last_data output
    .rx_fcs_error(rx_fcs_error),     // referring to the non-zero last_data
    .rx_fcs_valid(rx_fcs_valid),
    .remote_fault_status(remote_fault_status),
    .local_fault_status(local_fault_status),
    .dout_valid(dout_valid),
    .dout_d(dout_d),
    .dout_c(dout_c),
    .dout_sop(dout_sop),
    .dout_eop(dout_eop),
    .dout_eop_empty(dout_eop_empty),
    .dout_idle(dout_idle),
    .rx_mii_start(rx_mii_start),
    .out_rx_stats   (out_rx_stats),
    .rx_inc_octetsOK      (rx_inc_octetsOK),
    .rx_inc_octetsOK_valid(rx_inc_octetsOK_valid),
    .rx_error(rx_error),
    .rx_status(rx_status)
);
defparam erx .TARGET_CHIP = TARGET_CHIP;
defparam erx .EN_LINK_FAULT = SYNOPT_LINK_FAULT;
defparam erx .SYNOPT_ALIGN_FCSEOP = SYNOPT_ALIGN_FCSEOP;


// switch from MAC  (read left to right) to PCS (read bytes right to left)
wire [WORDS*64-1:0] pcs_din_d_rev;
wire [WORDS*8-1:0] pcs_din_c_rev;

reverse_bytes rb2 (.din(pcs_din_d_rev),.dout(pcs_din_d));
defparam rb2 .NUM_BYTES = WORDS*8;

reverse_bits rb3 (.din(pcs_din_c_rev),.dout(pcs_din_c));
defparam rb3 .WIDTH = WORDS*8;

alt_aeu_100_mac_tx_4 #(
    .SYNOPT_TXSTATS        (SYNOPT_MAC_TXSTATS),
    .BASE_TXMAC            (BASE_TXMAC),
    .REVID                 (REVID),
    .BASE_TXSTAT           (BASE_TXSTAT),
    .SYNOPT_AVG_IPG        (SYNOPT_AVG_IPG)
) txm (
    .sclr(srst_tx_main),
    .clk(clk_tx_main),
    .reset_csr(rst_async),        // global reset, async
	.rst_sync_sts 		(rst_sync_sts),		//async reset in 100M after synchronizer
    .clk_csr(avmm_clk),
    .serif_slave_din(pcs_slave_din),
    .serif_slave_dout(serif_txmac_dout),
    .din_sop(din_sop),             // word contains first data (on leftmost byte)
    .din_eop(din_eop),                 // byte position of last data
    .din_idle(din_idle),           // bytes between EOP and SOP
    .din_eop_empty(din_eop_empty), // byte position of last data
    .din(din),                     // data, read left to right
    .tx_error(tx_error),
    .req(din_req),
    .pre_din_am(pre_pcs_din_am),
    .tx_crc_ins_en(tx_crc_ins_en),
    .tod_96b_txmac_in(tod_96b_txmac_in),
    .tod_64b_txmac_in(tod_64b_txmac_in),
    .txmclk_period(txmclk_period),
    .tx_asym_delay(tx_asym_delay),
    .tx_pma_delay(tx_pma_delay),
    .cust_mode(cust_mode),
    .ext_lat(ext_lat),
    .din_ptp_dbg_adp(din_ptp_dbg_adp),
    .din_sop_adp(din_sop_adp),
    .din_ptp_asm_adp(din_ptp_asm_adp),
    .ts_out_cust_asm(ts_out_cust_asm),
    .tod_cust_in(tod_cust_in),
    .tod_exit_cust(tod_exit_cust),
    .ts_out_cust(ts_out_cust),

    .fp_out_req_adp(fp_out_req_adp),
    .ts_out_req_adp(ts_out_req_adp),
    .ing_ts_96_adp(ing_ts_96_adp),
    .ing_ts_64_adp(ing_ts_64_adp),
    .ins_ts_adp(ins_ts_adp),
    .ins_ts_format_adp(ins_ts_format_adp),
    .tx_asym_adp(tx_asym_adp),
    .upd_corr_adp(upd_corr_adp),
    .chk_sum_zero_adp(chk_sum_zero_adp),
    .chk_sum_upd_adp(chk_sum_upd_adp),
    .corr_format_adp(corr_format_adp),
    .ts_offset_adp(ts_offset_adp),
    .corr_offset_adp(corr_offset_adp),
    .chk_sum_zero_offset_adp(chk_sum_zero_offset_adp),
    .chk_sum_upd_offset_adp(chk_sum_upd_offset_adp),
    .ts_exit(ts_exit),
    .ts_exit_valid(ts_exit_valid),
    .fp_out(fp_out),

    .tx_mii_d(pcs_din_d_rev),
    .tx_mii_c(pcs_din_c_rev),
    .tx_mii_valid   (),     // adubey 09.04.2013 warning clean-up
    .o_bus_error(din_bus_error),
    .cfg_unidirectional_en(unidirectional_en),
    .cfg_en_link_fault_gen(link_fault_gen_en),
    .remote_fault_status(remote_fault_status),
    .local_fault_status(local_fault_status),
    .out_tx_stats(out_tx_stats),
    .tx_inc_octetsOK      (tx_inc_octetsOK),
    .tx_inc_octetsOK_valid(tx_inc_octetsOK_valid)
);
defparam txm .TARGET_CHIP = TARGET_CHIP;
defparam txm .EN_PREAMBLE_PASS_THROUGH = SYNOPT_PREAMBLE_PASS;
defparam txm .EN_LINK_FAULT = SYNOPT_LINK_FAULT;
defparam txm .EN_TX_CRC_INS = SYNOPT_TXCRC_INS;
defparam txm .EN_DIC = SYNOPT_MAC_DIC;
defparam txm .SYNOPT_PTP = SYNOPT_PTP;
defparam txm .SYNOPT_TOD_FMT = SYNOPT_TOD_FMT;
defparam txm .PTP_LATENCY = PTP_LATENCY;
defparam txm.PTP_FP_WIDTH = PTP_FP_WIDTH;

endmodule

