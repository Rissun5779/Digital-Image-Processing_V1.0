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



// ________________________________________________________________________________
// ________________________________________________________________________________
`timescale 1ps / 1ps

module alt_aeu_40_eth_2 #(
    parameter SYNOPT_PTP = 0,
                parameter SYNOPT_TOD_FMT = 0,
    parameter PTP_LATENCY = 62,
                parameter PTP_FP_WIDTH = 16, // width of fingerprint, ptp parameter
                parameter PTP_TS_WIDTH = 96, 
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
    parameter SYNOPT_FULL_SKEW = 0, 
    parameter SYNOPT_STRICT_SOP = 0, 
    parameter RXERRWIDTH = 6,
    parameter RXSTATUSWIDTH = 3,                          
    parameter VIRT_PCS = 0,
    parameter REVID = 32'h04142014,
    parameter BASE_PHY = 1,
    parameter BASE_TXMAC = 4,
    parameter BASE_RXMAC = 5,
    parameter BASE_TXSTAT = 6,
    parameter BASE_RXSTAT = 7,
    parameter ERRORBITWIDTH  = 11,  
    parameter STATSBITWIDTH  = 32,  // includes errors
     
    parameter PCS_ADDR_PAGE = 1,    // to be removed (replaced by BASE_PHY)
    parameter RST_CNTR = 16,        // nominal 16/20  or 6 for fast sim of reset seq
    parameter SIM_FAKE_JTAG = 1'b0,
    parameter AM_CNT_BITS = 14,     // 6 Ok for sim
    parameter WORDS = 2,            // no override
    parameter CREATE_TX_SKEW = 1'b1, // debug skew the TX lanes
        parameter TIMING_MODE = 1'b0,
        parameter EXT_TX_PLL = 1'b0, // whether to use external fpll for TX core clocks
    //  KR4 parameters
    parameter ENA_KR4       = 0,
    parameter ES_DEVICE     = 1,            // select ES or PROD device, 1 is ES-DEVICE, 0 is device
    parameter KR_ADDR_PAGE  = 0,
    parameter SYNTH_AN      = 1,            // Synthesize/include the AN logic
    parameter SYNTH_LT      = 1,            // Synthesize/include the LT logic
    parameter SYNTH_SEQ     = 1,            // Synthesize/include Sequencer logic
    parameter SYNTH_FEC     = 1,            // Synthesize/include the FEC logic
    // Sequencer parameters not used in the AN block
    parameter LINK_TIMER_KR = 504,          // Link Fail Timer for BASE-R PCS in ms
    // LT parameters
    parameter BERWIDTH      = 10,          // Width (>4) of the Bit Error counter
    parameter TRNWTWIDTH    = 7,           // Width (7,8) of Training Wait counter
    parameter MAINTAPWIDTH  = 5,           // Width of the Main Tap control
    parameter POSTTAPWIDTH  = 6,           // Width of the Post Tap control
    parameter PRETAPWIDTH   = 5,           // Width of the Pre Tap control
    parameter VMAXRULE      = 5'd30,       // VOD+Post+Pre <= Device Vmax 1200mv
    parameter VMINRULE      = 5'd6,        // VOD-Post-Pre >= Device VMin 165mv
    parameter VODMINRULE    = 5'd14,       // VOD >= IEEE VOD Vmin of 440mV
    parameter VPOSTRULE     = 6'd25,       // Post_tap <= VPOST
    parameter VPRERULE      = 5'd16,       // Pre_tap <= VPRE
    parameter PREMAINVAL    = 5'd30,       // Preset Main tap value
    parameter PREPOSTVAL    = 6'd0,        // Preset Post tap value
    parameter PREPREVAL     = 5'd0,        // Preset Pre tap value
    parameter INITMAINVAL   = 5'd25,       // Initialize Main tap value
    parameter INITPOSTVAL   = 6'd22,       // Initialize Post tap value
    parameter INITPREVAL    = 5'd3,        // Initialize Pre tap value
    parameter USE_DEBUG_CPU = 0,           // Use the Debug version of the CPU
    // AN parameters
    parameter AN_CHAN       = 4'b0001,      // "master" channel to run AN on (one-hot)
    parameter AN_PAUSE      = 3'b011,       // Initial setting for Pause ability, depends upon MAC  
    parameter AN_TECH       = 6'b00_1000,   // Tech ability, only 40G-KR4 valid
                                            // bit-0 = GigE, bit-1 = XAUI
                                            // bit-2 = 10G , bit-3 = 40G BP
                                            // bit 4 = 40G-CR4, bit 5 = 100G-CR10
    parameter AN_SELECTOR   = 5'b0_0001,    // AN selector field 802.3 = 5'd1
    parameter CAPABLE_FEC      = 0,    // FEC ability on power on
    parameter ENABLE_FEC       = 0,    // FEC request on power on
    parameter ERR_INDICATION   = 0,    // Turn error indication on/off
    // PHY parameters
    parameter REF_CLK_FREQ_10G  = "644.53125 MHz", // speed for clk_ref
    parameter STATUS_CLK_KHZ    = 100000       // clk_status rate in Mhz
   )(
    input  wire clk_ref_r,
    input  wire[3:0] erx_pin,
    output wire[3:0] etx_pin,
        
    input RX_CORE_CLK,
    input TX_CORE_CLK,
  
    //Sync-E
    output wire clk_rx_recover,
     
    input wire  avmm_clk,  // 100 MHz
    input wire  avmm_reset,   // global reset, async      
    input 	reset_status_async,	// reset status synced to status clock domain

    output wire e40_slave_dout, 
    input wire  pcs_slave_din,
    output wire[STATSBITWIDTH-1:0] out_tx_stats,
    output wire[STATSBITWIDTH-1:0] out_rx_stats,
    output wire[15:0] tx_inc_octetsOK,
    output wire       tx_inc_octetsOK_valid,
    output wire[15:0] rx_inc_octetsOK,
    output wire       rx_inc_octetsOK_valid,

                 // ptp tx realted csr

   input [19:0]         txmclk_period,
        input [18:0] tx_asym_delay,
        input [31:0] tx_pma_delay,
         input cust_mode,
      // ptp related inouts - begin
//     input ptp_v2,
//     input ptp_s2,
     input [31:0] ext_lat,
     input         din_ptp_dbg_adp,
     input din_sop_adp,
     input din_ptp_adp,
     input [1:0] din_overwrite_adp,
     input [15:0] din_offset_adp,
         input din_zero_tcp_adp,
         input din_ptp_asm_adp,
         input [15:0] din_zero_offset_adp,
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
    output wire pcs_din_am,
    output wire[WORDS*8-1:0]  pcs_din_c,
    output wire[WORDS*64-1:0] pcs_din_d,
    output wire [35:0] wpos,

    input wire clk_txmac_in, // used with EXT_TX_PLL, 312.5MHz derived from clk_ref
    output wire clk_tx_main,
    output wire srst_tx_main,
    output wire tx_lanes_stable,
    input wire [WORDS-1:0] din_sop,        // word contains first data (on leftmost byte)
    input wire [WORDS-1:0] din_eop,        // byte position of last data
    input wire [WORDS-1:0] din_error,   
    input wire [WORDS-1:0] din_idle,       // bytes between EOP and SOP
    input wire [3*WORDS-1:0] din_eop_empty,// byte position of last data
    input wire [WORDS*64-1:0] din,         // data, read left to right
    output wire din_req,
    output wire din_bus_error,
    output wire [WORDS-1:0] tx_mii_start,

    output wire clk_rx_main,
    output wire srst_rx_main,
    output wire rx_data_out_valid,
    output wire [WORDS*64-1:0] rx_data_out,  // read bytes left to right
    output wire [WORDS*8-1:0]  rx_ctl_out,   // read bits left to right
    output wire [WORDS-1:0]    rx_first_data,// word contains the first non-preamble data of a frame
    output wire [WORDS*8-1:0]  rx_last_data, // byte contains the last data before FCS
    output wire [RXERRWIDTH-1:0] rx_error,  
    output wire [RXSTATUSWIDTH-1:0] rx_status, 
    output wire rx_fcs_error,  
    output wire rx_fcs_valid,
    output wire rx_pcs_fully_aligned,
    output wire unidirectional_en,
    output wire link_fault_gen_en,
    output wire remote_fault_status,
    output wire local_fault_status,
    output wire [WORDS-1:0] rx_mii_start,
    

//    input [95:0]          tod_txmac_in,
  input [95:0] tod_96b_txmac_in,
  input [63:0] tod_64b_txmac_in,
    output wire dout_valid,
    output wire [WORDS*64-1:0] dout_d,
    output wire [WORDS*8-1:0] dout_c,
    output wire [WORDS-1:0] dout_sop,
    output wire [WORDS-1:0] dout_eop,
    output wire [WORDS*3-1:0] dout_eop_empty,
    output wire [WORDS-1:0] dout_idle,
         input [95:0] tod_cust_in,
         output [95:0] tod_exit_cust,
         output [95:0] ts_out_cust,
 
        
        output [PTP_FP_WIDTH-1:0] fp_out,
                 
        input  wire [0:0]   reconfig_clk,            //            reconfig_clk.clk
        input  wire [0:0]   reconfig_reset,          //          reconfig_reset.reset
        input  wire [0:0]   reconfig_write,          //           reconfig_avmm.write
        input  wire [0:0]   reconfig_read,           //                        .read
        input  wire [11:0]  reconfig_address,        //                        .address
        input  wire [31:0]  reconfig_writedata,      //                        .writedata
        output wire [31:0]  reconfig_readdata,       //                        .readdata
        output wire [0:0]   reconfig_waitrequest,    //                        .waitrequest
        input [3:0]         tx_serial_clk,
        input               tx_pll_locked,
        input  wire [559:0] reconfig_to_xcvr,        //        reconfig_to_xcvr.reconfig_to_xcvr
        output wire [367:0] reconfig_from_xcvr,      //      reconfig_from_xcvr.reconfig_from_xcvr
        input  wire reconfig_busy
  );

 wire rst_async;   //global reset from Pin
 assign rst_async = avmm_reset;
   
 wire pcs_dout_am;
 wire [WORDS*64-1:0] pcs_dout_d; wire [WORDS*8-1:0] pcs_dout_c;         
 wire tx_crc_ins_en; wire pre_pcs_din_am; // leading indicator

 wire epa_csr_dout, serif_rxmac_dout, serif_txmac_dout;
 assign e40_slave_dout = epa_csr_dout & serif_rxmac_dout & serif_txmac_dout;

wire rst_sync_sts;
assign rst_sync_sts=reset_status_async;

generate
if (VIRT_PCS) begin: virt_pcs
        
        reg clk_tx_main_reg = 0;
        reg clk_rx_main_reg = 0;

        assign etx_pin = 4'b0000;
        assign epa_csr_dout = 1'b1;
        assign srst_tx_main = rst_async;
        assign tx_lanes_stable = !rst_async;
        assign pcs_din_am = 1'b0;
        assign pre_pcs_din_am = 1'b0;
        assign srst_rx_main = rst_async;
        assign rx_pcs_fully_aligned = 1'b1;
        assign pcs_dout_d = pcs_din_d;
   assign wpos = 36'd0;
        assign pcs_dout_c = pcs_din_c;
        assign pcs_dout_am = 1'b0;
        assign clk_tx_main = clk_tx_main_reg;
        assign clk_rx_main = clk_rx_main_reg;
        
        always begin
                clk_tx_main_reg = ~clk_tx_main_reg;
                clk_rx_main_reg = ~clk_rx_main_reg;
                #1600;
        end
        
end else begin: phy
   
 alt_aeu_40_pcs_assembly #(
       .ADDR_PAGE       (BASE_PHY),
       .REVID           (REVID),
       .PHY_REFCLK      (PHY_REFCLK),
       .SYNOPT_PTP(SYNOPT_PTP),
           .PTP_LATENCY(PTP_LATENCY),
       .TIMING_MODE        (TIMING_MODE),
       .EXT_TX_PLL         (EXT_TX_PLL)
   ) phy_inst           (
        .pll_ref        (clk_ref_r),
        .etx_pin        (etx_pin),
        .erx_pin        (erx_pin),

        .RX_CORE_CLK(RX_CORE_CLK),
        .TX_CORE_CLK(TX_CORE_CLK),
        
        //Sync-E
        .clk_rx_recover (clk_rx_recover),                
                         
        // status port
        .clk100         (avmm_clk),
        .rst100         (rst_async),           // global reset, async
	.rst_sync_sts 	(rst_sync_sts),		//async reset in 100M after synchronizer
        .slave_din      (pcs_slave_din),
        .slave_dout     (epa_csr_dout),

        // mii tx port
        .clk_txmac_in   (clk_txmac_in),
        .clk_tx_main    (clk_tx_main),
        .srst_tx_main   (srst_tx_main),
        .tx_lanes_stable(tx_lanes_stable),
        .din_d          (pcs_din_d), 
        .din_c          (pcs_din_c), 
        .din_am         (pcs_din_am),           // this din will be replaced with align marks
        .pre_din_am     (pre_pcs_din_am),       // leading indicator
        .tx_crc_ins_en  (tx_crc_ins_en),
        .tx_mii_start   (tx_mii_start),         
                
        // mii rx port
        .clk_rx_main    (clk_rx_main),
        .srst_rx_main   (srst_rx_main),
        .dout_d         (pcs_dout_d),
        .dout_c         (pcs_dout_c),
        .wpos(wpos),
        .dout_am        (pcs_dout_am),
        .rx_pcs_fully_aligned(rx_pcs_fully_aligned),
                
        .reconfig_clk(reconfig_clk),            //            input  wire [0:0]   
        .reconfig_reset(reconfig_reset),          //          input  wire [0:0]   
        .reconfig_write(reconfig_write),          //          input  wire [0:0]   
        .reconfig_read(reconfig_read),           //          input  wire [0:0]   
        .reconfig_address(reconfig_address),        //          input  wire [11:0]  
        .reconfig_writedata(reconfig_writedata),      //          input  wire [31:0]  
        .reconfig_readdata(reconfig_readdata),       //          output wire [31:0]  
        .reconfig_waitrequest(reconfig_waitrequest),    //          output wire [0:0]   
        .tx_serial_clk(tx_serial_clk),
        .tx_pll_locked(tx_pll_locked),
        .reconfig_to_xcvr(reconfig_to_xcvr),
        .reconfig_from_xcvr(reconfig_from_xcvr),
        .reconfig_busy(reconfig_busy)
   );
   defparam phy_inst .TARGET_CHIP = TARGET_CHIP;
   defparam phy_inst .SYNOPT_FULL_SKEW = SYNOPT_FULL_SKEW;
   defparam phy_inst .EN_LINK_FAULT = SYNOPT_LINK_FAULT;
   defparam phy_inst .SIM_FAKE_JTAG = SIM_FAKE_JTAG;
   defparam phy_inst .AM_CNT_BITS = AM_CNT_BITS;  // 14 nom, 6 Ok for sim
   defparam phy_inst .RST_CNTR = RST_CNTR;   // nominal 16/20 or 6 for fast sim of reset seq
   defparam phy_inst .CREATE_TX_SKEW = CREATE_TX_SKEW;
   defparam phy_inst.ENA_KR4       = ENA_KR4;
   defparam phy_inst.ES_DEVICE     = ES_DEVICE;
   defparam phy_inst.KR_ADDR_PAGE  = KR_ADDR_PAGE;
   defparam phy_inst.SYNTH_AN      = SYNTH_AN;
   defparam phy_inst.SYNTH_LT      = SYNTH_LT;
   defparam phy_inst.SYNTH_SEQ     = SYNTH_SEQ;
   defparam phy_inst.SYNTH_FEC     = SYNTH_FEC;
   defparam phy_inst.LINK_TIMER_KR = LINK_TIMER_KR;
   defparam phy_inst.BERWIDTH      = BERWIDTH;
   defparam phy_inst.TRNWTWIDTH    = TRNWTWIDTH;
   defparam phy_inst.MAINTAPWIDTH  = MAINTAPWIDTH;
   defparam phy_inst.POSTTAPWIDTH  = POSTTAPWIDTH;
   defparam phy_inst.PRETAPWIDTH   = PRETAPWIDTH;
   defparam phy_inst.VMAXRULE      = VMAXRULE;
   defparam phy_inst.VMINRULE      = VMINRULE;
   defparam phy_inst.VODMINRULE    = VODMINRULE;
   defparam phy_inst.VPOSTRULE     = VPOSTRULE;
   defparam phy_inst.VPRERULE      = VPRERULE;
   defparam phy_inst.PREMAINVAL    = PREMAINVAL;
   defparam phy_inst.PREPOSTVAL    = PREPOSTVAL;
   defparam phy_inst.PREPREVAL     = PREPREVAL;
   defparam phy_inst.INITMAINVAL   = INITMAINVAL;
   defparam phy_inst.INITPOSTVAL   = INITPOSTVAL;
   defparam phy_inst.INITPREVAL    = INITPREVAL;
   defparam phy_inst.USE_DEBUG_CPU = USE_DEBUG_CPU;
   defparam phy_inst.AN_CHAN       = AN_CHAN;
   defparam phy_inst.AN_PAUSE      = AN_PAUSE;
   defparam phy_inst.AN_TECH       = AN_TECH;
   defparam phy_inst.AN_SELECTOR   = AN_SELECTOR;
   defparam phy_inst.CAPABLE_FEC   = CAPABLE_FEC;
   defparam phy_inst.ENABLE_FEC    = ENABLE_FEC;
   defparam phy_inst.ERR_INDICATION = ERR_INDICATION;
   defparam phy_inst.STATUS_CLK_KHZ = STATUS_CLK_KHZ;
   defparam phy_inst.REF_CLK_FREQ_10G = REF_CLK_FREQ_10G;
   
end 
endgenerate
 

// switch from PCS  (read bytes right to left) to MAC  (read left to right)
   wire [WORDS*64-1:0] pcs_dout_d_rev; wire [WORDS*8-1:0] pcs_dout_c_rev;       
   reverse_bytes rb0 (.din(pcs_dout_d),.dout(pcs_dout_d_rev)); defparam rb0 .NUM_BYTES = WORDS*8;
   reverse_bits  rb1 (.din(pcs_dout_c),.dout(pcs_dout_c_rev)); defparam rb1 .WIDTH = WORDS*8;

   alt_aeu_40_mac_rx_2 #(
         .BASE_RXMAC            ( BASE_RXMAC) 
        ,.REVID                 ( REVID)
        ,.BASE_RXSTAT           ( BASE_RXSTAT) 
        ,.SYNOPT_RXSTATS        ( SYNOPT_MAC_RXSTATS) 
        ,.ERRORBITWIDTH         ( ERRORBITWIDTH)
        ,.RXERRWIDTH            ( RXERRWIDTH)
        ,.RXSTATUSWIDTH         ( RXSTATUSWIDTH)                  
        ,.STATSBITWIDTH         ( STATSBITWIDTH)
        ,.SYNOPT_PREAMBLE_PASS  ( SYNOPT_PREAMBLE_PASS)
        ,.TARGET_CHIP           ( TARGET_CHIP)
        ,.EN_LINK_FAULT         ( SYNOPT_LINK_FAULT)
        ,.SYNOPT_ALIGN_FCSEOP   ( SYNOPT_ALIGN_FCSEOP)
        ,.SYNOPT_STRICT_SOP     ( SYNOPT_STRICT_SOP)                     
    ) rxmac_inst                (
        .clk                    (clk_rx_main    ),
        .reset_rx               (srst_rx_main   ),
        .reset_csr              (rst_async    ),    // global reset, async
	.rst_sync_sts 		(rst_sync_sts),		//async reset in 100M after synchronizer
        .clk_csr                (avmm_clk       ),
        .serif_slave_din        (pcs_slave_din  ),
        .serif_slave_dout       (serif_rxmac_dout),

        // XXGMII stream in
        .mii_in_valid           (!pcs_dout_am   ),
        .mii_data_in            (pcs_dout_d_rev ),  // read bytes left to right
        .mii_ctl_in             (pcs_dout_c_rev ),  // read bits left to right
        .rx_pcs_fully_aligned   (rx_pcs_fully_aligned),

        // annotated output
        .out_valid              (rx_data_out_valid),
        .data_out               (rx_data_out    ),   // read bytes left to right
        .ctl_out                (rx_ctl_out     ),   // read bits left to right
        .first_data             (rx_first_data  ),   // word contains the first non-preamble data of a frame
        .last_data              (rx_last_data   ),   // byte contains the last data before FCS
    
        // lagged               (N) cycles from the non-zero last_data output
        .rx_error               (rx_error       ),   //
        .rx_status              (rx_status      ),   
        .rx_fcs_error           (rx_fcs_error   ),   // referring to the non-zero last_data
        .rx_fcs_valid           (rx_fcs_valid   ),
        .dout_valid             (dout_valid     ),
        .dout_d                 (dout_d         ),
        .dout_c                 (dout_c         ),
        .dout_sop               (dout_sop       ),
        .dout_eop               (dout_eop       ),
        .dout_eop_empty         (dout_eop_empty ),
        .dout_idle              (dout_idle      ),
        .rx_mii_start           (rx_mii_start   ),
        .out_rx_stats           (out_rx_stats   ),
        .rx_inc_octetsOK          (rx_inc_octetsOK  ),
        .rx_inc_octetsOK_valid    (rx_inc_octetsOK_valid    ),
        .remote_fault_status    (remote_fault_status),
        .local_fault_status     (local_fault_status)
        );
    

 //switch from MAC  (read left to right) to PCS (read bytes right to left)
   wire [WORDS*64-1:0] pcs_din_d_rev; wire [WORDS*8-1:0] pcs_din_c_rev;         
   reverse_bytes rb2 (.din(pcs_din_d_rev),.dout(pcs_din_d)); defparam rb2 .NUM_BYTES = WORDS*8;
   reverse_bits rb3 (.din(pcs_din_c_rev),.dout(pcs_din_c)); defparam rb3 .WIDTH = WORDS*8;

   alt_aeu_40_mac_tx_2 #(
         .BASE_TXMAC            ( BASE_TXMAC) 
        ,.REVID                 ( REVID)
        ,.BASE_TXSTAT           ( BASE_TXSTAT) 
        ,.SYNOPT_AVG_IPG        ( SYNOPT_AVG_IPG) 
        ,.SYNOPT_TXSTATS        ( SYNOPT_MAC_TXSTATS)
        ,.SYNOPT_PTP    ( SYNOPT_PTP)
            ,.PTP_LATENCY(PTP_LATENCY)
        ,.TARGET_CHIP           ( TARGET_CHIP)
        ,.EN_DIC                ( SYNOPT_MAC_DIC)
        ,.EN_LINK_FAULT         ( SYNOPT_LINK_FAULT)
        ,.EN_TX_CRC_INS         ( SYNOPT_TXCRC_INS)
        ,.EN_PREAMBLE_PASS_THROUGH( SYNOPT_PREAMBLE_PASS)

       ) txmac_inst             (
        .sclr                   (srst_tx_main   ),
        .clk                    (clk_tx_main    ),
        .reset_csr              (rst_async     ),               // global reset, async 
	.rst_sync_sts 		(rst_sync_sts),		//async reset in 100M after synchronizer
        .clk_csr                (avmm_clk       ),
        .serif_slave_din        (pcs_slave_din  ),
        .serif_slave_dout       (serif_txmac_dout),
        .din_sop                (din_sop        ),              // word contains first data (on leftmost byte)
        .din_eop                (din_eop        ),              // byte position of last data
        .din_error              (din_error      ),
        .din_idle               (din_idle       ),              // bytes between EOP and SOP
        .din_eop_empty          (din_eop_empty  ),              // byte position of last data
        .din                    (din            ),              // data, read left to right
        .req                    (din_req        ),
        .pre_din_am             (pre_pcs_din_am ),
        .tx_crc_ins_en          (tx_crc_ins_en  ),
         .tod_96b_txmac_in(tod_96b_txmac_in),
         .tod_64b_txmac_in(tod_64b_txmac_in),
                   .txmclk_period(txmclk_period),
                   .tx_asym_delay(tx_asym_delay),
                   .tx_pma_delay(tx_pma_delay),
                   .cust_mode(cust_mode),
//        .ptp_v2(ptp_v2),
//        .ptp_s2(ptp_s2),
        .ext_lat(ext_lat),
        .din_ptp_dbg_adp(din_ptp_dbg_adp),
        .din_sop_adp(din_sop_adp),
//        .din_ptp_adp(din_ptp_adp),
//           .din_overwrite_adp(din_overwrite_adp),
//           .din_offset_adp(din_offset_adp),
//         .din_zero_tcp_adp(din_zero_tcp_adp),
         .din_ptp_asm_adp(din_ptp_asm_adp),
//         .din_zero_offset_adp(din_zero_offset_adp),
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
                    
        .tx_mii_d               (pcs_din_d_rev  ),
        .tx_mii_c               (pcs_din_c_rev  ),
        .tx_mii_valid           (               ),              // adubey 09.04.2013 warning clean-up
        .o_bus_error            (din_bus_error  ),
        .tod_txmclk             (),
        .cfg_unidirectional_en  (unidirectional_en),
        .cfg_en_link_fault_gen  (link_fault_gen_en),
        .remote_fault_status    (remote_fault_status),
        .local_fault_status     (local_fault_status),
        .out_tx_stats           (out_tx_stats),
        .tx_inc_octetsOK                (tx_inc_octetsOK),
        .tx_inc_octetsOK_valid  (tx_inc_octetsOK_valid)
        );

     defparam txmac_inst.PTP_FP_WIDTH = PTP_FP_WIDTH;
     defparam txmac_inst.PTP_TS_WIDTH = PTP_TS_WIDTH;
     defparam txmac_inst.SYNOPT_TOD_FMT = SYNOPT_TOD_FMT;
endmodule 

