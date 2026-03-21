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


`timescale 1 ps / 1 ps
`include "dynamic_parameters.v"

module eth_ex_40g_sv (
    input clk50,
    input cpu_resetn,
    
    // 10G IO
    input clk_ref_r,
    input [3:0] rx_serial_r,
    output [3:0] tx_serial_r,
    
    // CFP MDIO controls
    output cfp_mdc,
    inout  cfp_mdio,
    input  cfp_glb_alrm,
    //output [4:0] cfp_prtadr,	
    
    // CFP custom controls
    output cfp_mod_lopwr,
    output cfp_mod_rst,
    output cfp_tx_dis,
    input cfp_mod_abs,
    input cfp_rx_los,
    input [3:1] cfp_prg_alrm,
    output [3:1] cfp_prg_cntl
    
  );

 localparam DEVICE_FAMILY = "Stratix V";
 localparam WORDS = 4;

 localparam WIDTH = 64;
 localparam SOP_ON_LANE0 = 1'b1;

 localparam SIM_NO_TEMP_SENSE = 1'b0;

 localparam FEATURES = 32'h0000_0000
`ifdef ARRIA_10
                     | 32'h0000_0001 //A10
`endif
                     //| 32'h0000_0002 //100G
`ifdef REFCLK_644
                     | 32'h0000_0004 //644
`endif
                     //| 32'h0000_0008 //KR4
                     //| 32'h0000_0010 //CAUI4
`ifdef SYNOPT_PTP
                     | 32'h0000_0020 //PTP
`endif
`ifdef SYNOPT_PAUSE
                     | 32'h0000_0040 //Pause
`endif
`ifdef SYNOPT_LINK_FAULT
                     | 32'h0000_0080 //Link Fault
`endif
`ifdef EXT_TX_PLL
                     | 32'h0000_0100 //External PLL
`endif
`ifdef AVALON_IF
                     | 32'h0000_0200 //Avalon-ST
`endif
                     ;

/////////////////////////
// dev_clr sync-reset
/////////////////////////

wire user_mode_sync, arst;

alt_aeuex_user_mode_det dev_clr(
    .ref_clk(clk50),
    .user_mode_sync(user_mode_sync)
);

////////////////////////////////////////////

wire clk100;
wire sp100_locked;

alt_aeuex_sys_pll_sv_100 sp100(
	.rst(~user_mode_sync),
	.refclk(clk50),
	.outclk_0(clk100),
	.locked(sp100_locked)
);

assign arst = ~sp100_locked | ~cpu_resetn;

////////////////////////////////////////////
// 40G E 4x10 serial links
//////////////////////////////////////

wire [15:0] status_addr;
wire        status_read,status_write,status_readdata_valid_eth;
wire [31:0] status_readdata_eth, status_writedata;
wire        status_read_timeout;
wire        clk_status = clk100;
wire        clk_txmac;    // MAC + PCS clock - at least 312.5Mhz
wire        clk_rxmac;    // MAC + PCS clock - at least 312.5Mhz

// input domain (from user logic toward pins)
wire                   clk_din = clk_txmac;    //clk320;  // nominal 312
wire [WORDS*WIDTH-1:0] din;               // payload to send, left to right
wire       [WORDS-1:0] din_start;         // start pos, first of every 8 bytes
wire     [WORDS*8-1:0] din_end_pos;       // end position, any byte
wire                   din_ack;           // payload is accepted

// output domain (from pins toward user logic)
wire                   clk_dout = clk_rxmac;    //clk320; // nominal 312
wire    [WORDS*64-1:0] dout_d;            // 5 word out stream, left to right
wire       [WORDS-1:0] dout_first_data;
wire     [WORDS*8-1:0] dout_last_data;
wire                   dout_valid;

wire    [255:0] l4_tx_data;
wire      [4:0] l4_tx_empty;
wire            l4_tx_endofpacket;
wire            l4_tx_ready;
wire            l4_tx_startofpacket;
wire            l4_tx_valid;
wire    [255:0] l4_rx_data;
wire      [4:0] l4_rx_empty;
wire            l4_rx_endofpacket;
wire            l4_rx_error;
wire            l4_rx_startofpacket;
wire            l4_rx_valid;

//--- functions
`include "common/alt_aeuex_wide_l4if_functions.iv"

  assign l4_tx_data          = din;
  assign l4_tx_valid         = 1'b1;
  assign din_ack             = l4_tx_ready;
  assign l4_tx_empty         = alt_aeuex_wide_encode32to5(din_end_pos);
  assign l4_tx_endofpacket   = |din_end_pos;
  assign l4_tx_startofpacket = din_start[WORDS-1];
  assign dout_d              = l4_rx_data;
  assign dout_valid           = l4_rx_valid;
  assign dout_first_data     = {l4_rx_startofpacket, {WORDS-1{1'b0}}};
  assign dout_last_data      = l4_rx_endofpacket ?  alt_aeuex_wide_decode5to32(l4_rx_empty) : 32'h0;
  
  wire    [367:0] reconfig_from_xcvr;
  wire    [559:0] reconfig_to_xcvr;

    `ifdef SYNOPT_PTP
    
    wire [95:0] tod_txmac_in;
    wire [95:0] tod_rxmac_in;
    
    alt_aeu_clks_des 
      #(.TARGET_CHIP(2)) // Stratix V
    des
      (
       .rst_txmac(arst),
       .rst_rxmac(arst),
       .tod_txmclk(tod_txmac_in),
       .tod_rxmclk(tod_rxmac_in),
       .clk_txmac(clk_txmac), // mac tx clk
       .clk_rxmac(clk_rxmac)  // mac rx clk
       );

    `endif

  ENET_ENTITY_QMEGA_01312014 ENET_ENTITY_QMEGA_01312014_inst (
    .reset_async        (arst),
    .clk_txmac        (clk_txmac),    // MAC + PCS clock - at least 312.5Mhz
    .clk_rxmac        (clk_rxmac),    // MAC + PCS clock - at least 312.5Mhz
    .clk_ref        (clk_ref_r),
	.rx_pcs_ready(),

    .clk_status        (clk_status),
    .reset_status        (arst),
    .status_addr        (status_addr),
    .status_read        (status_read),
    .status_write        (status_write),
    .status_writedata    (status_writedata),
    .status_readdata    (status_readdata_eth),
    .status_read_timeout    (status_read_timeout),
    .status_readdata_valid    (status_readdata_valid_eth),
    
    .l4_tx_ready        (l4_tx_ready),
    .l4_tx_data        (l4_tx_data),
    .l4_tx_empty        (l4_tx_empty),
    .l4_tx_startofpacket    (l4_tx_startofpacket),
    .l4_tx_endofpacket    (l4_tx_endofpacket),
    .l4_tx_valid        (l4_tx_valid),
    .l4_tx_error        (l4_tx_error),
    
    .l4_rx_data        (l4_rx_data),
    .l4_rx_empty        (l4_rx_empty),
    .l4_rx_startofpacket    (l4_rx_startofpacket),
    .l4_rx_endofpacket    (l4_rx_endofpacket),
    .l4_rx_error        (l4_rx_error),
    .l4_rx_valid        (l4_rx_valid),
     
    `ifdef SYNOPT_PTP
        .tx_egress_timestamp_request_valid(1'b0),
        .tx_egress_timestamp_request_fingerprint('d0),
        .tx_etstamp_ins_ctrl_timestamp_insert(1'b0),
        .tx_etstamp_ins_ctrl_timestamp_format(1'b0),
        .tx_etstamp_ins_ctrl_residence_time_update(1'b0),
        .tx_etstamp_ins_ctrl_residence_time_calc_format(1'b0),
        .tx_etstamp_ins_ctrl_checksum_zero(1'b0),
        .tx_etstamp_ins_ctrl_checksum_correct(1'b0),
        .tx_etstamp_ins_ctrl_offset_timestamp(16'h0),
        .tx_etstamp_ins_ctrl_offset_correction_field(16'h0),
        .tx_etstamp_ins_ctrl_offset_checksum_field(16'h0),
        .tx_etstamp_ins_ctrl_offset_checksum_correction(16'h0),
        .tx_egress_asymmetry_update(1'b0),

        `ifdef SYNOPT_96B_PTP
            .rx_time_of_day_96b_data(96'd0),
            .tx_time_of_day_96b_data(96'd0),
            .tx_etstamp_ins_ctrl_ingress_timestamp_96b(96'd0),
        `endif

        `ifdef SYNOPT_64B_PTP
            .rx_time_of_day_64b_data(64'd0),
            .tx_time_of_day_64b_data(64'd0),
            .tx_etstamp_ins_ctrl_ingress_timestamp_64b(64'd0),
        `endif
    `endif

    .tx_serial        (tx_serial_r),
    .rx_serial        (rx_serial_r),
    
    .reconfig_from_xcvr  (reconfig_from_xcvr[367:0]),          // output [367:0]
    .reconfig_to_xcvr    (reconfig_to_xcvr[559:0])            // input [559:0]

  );
  
// map reconfig registers to 0x3000-0x307F

wire    reco_waitrequest;
wire    reco_readdata_valid;
wire [31:0] reco_readdata;

reg    status_read_r;
reg    status_write_r;
reg [31:0] status_writedata_r;
reg [15:0] status_addr_r;

always @(posedge clk_status) begin
    if (arst) begin
        status_read_r <= 0;
        status_write_r <= 0;
        status_writedata_r <= 32'b0;
        status_addr_r <= 32'b0;
    end
    else if( !reco_waitrequest ) begin
        status_read_r <= status_read;
        status_write_r <= status_write;
        status_writedata_r <= status_writedata;
        status_addr_r <= status_addr;
    end
end

wire    reco_read = status_read_r && (status_addr_r[15:7]==9'b0011_0000_0);
wire    reco_write = status_write_r && (status_addr_r[15:7]==9'b0011_0000_0);
wire [6:0] reco_addr = (reco_read || reco_write) ? status_addr_r[6:0] : 7'b0;

assign    reco_readdata_valid = reco_read && !reco_waitrequest;

e40_reco rc(
        .reconfig_busy             (),                         // output
        .mgmt_clk_clk              (clk_status),                   // input
        .mgmt_rst_reset            (arst),                     // input
        .reconfig_mgmt_address     (reco_addr),                    // input [6:0]
        .reconfig_mgmt_read        (reco_read),                    // input
        .reconfig_mgmt_readdata    (reco_readdata[31:0]),          // output [31:0]
        .reconfig_mgmt_waitrequest (reco_waitrequest),             // output
        .reconfig_mgmt_write       (reco_write),                   // input
        .reconfig_mgmt_writedata   (status_writedata_r[31:0]),     // input [31:0]
        .reconfig_to_xcvr          (reconfig_to_xcvr[559:0]),     // output [559:0]
        .reconfig_from_xcvr        (reconfig_from_xcvr[367:0])     // input [367:0]
);


 // _______________________________________
 // generate and check some simple data transfers
 // _____________________________________________________________

wire [31:0] status_readdata_pc;
wire status_readdata_valid_pc;

alt_aeuex_packet_client pc (
    .arst        (arst),
    
    // TX to Ethernet
    .clk_tx        (clk_din),
    .tx_ack        (din_ack),
    .tx_data    (din),
    .tx_start    (din_start),
    .tx_end_pos    (din_end_pos),
    
    // RX from Ethernet
    .clk_rx        (clk_dout),
    .rx_valid    (dout_valid),
    .rx_data    (dout_d),
    .rx_start    (dout_first_data),
    .rx_end_pos    (dout_last_data),
    
    // status register bus
    .clk_status        (clk_status),
    .status_addr        (status_addr),
    .status_read        (status_read),
    .status_write        (status_write),
    .status_writedata    (status_writedata),
    .status_readdata    (status_readdata_pc),
    .status_readdata_valid    (status_readdata_valid_pc)
  );
   defparam pc.WORDS = WORDS;
   defparam pc.WIDTH = WIDTH;
   defparam pc.SIM_NO_TEMP_SENSE= SIM_NO_TEMP_SENSE;
   defparam pc.DEVICE_FAMILY = DEVICE_FAMILY;
   defparam pc.SOP_ON_LANE0 = SOP_ON_LANE0;
   defparam pc.FEATURES = FEATURES;

//////////////////////////////////////
// CFP control
//////////////////////////////////////

wire [31:0] status_readdata_cfp;
wire status_readdata_valid_cfp;
wire cfp_mdio_out, cfp_mdio_oe;
assign cfp_mdio = cfp_mdio_oe ? cfp_mdio_out : 1'bz;

wire xfp_sda_out, xfp_sda_oe;
wire xfp_scl_out, xfp_scl_oe;
//assign xfp_scl = xfp_scl_oe ? xfp_scl_out : 1'bz;
//assign xfp_sda = xfp_sda_oe ? xfp_sda_out : 1'bz;
wire xfp_scl_in, xfp_sda_in;
assign xfp_scl_in = 1'b0; //xfp_scl;
assign xfp_sda_in = 1'b0; //xfp_sda;

alt_aeuex_optics_control cc (

	// status register bus
	.clk_status(clk_status),
	.status_addr(status_addr),
	.status_read(status_read),
	.status_write(status_write),
	.status_writedata(status_writedata),
	.status_readdata(status_readdata_cfp),
	.status_readdata_valid(status_readdata_valid_cfp),	
	
	// CFP MDIO controls
	.cfp_mdc(cfp_mdc),
	.cfp_mdio_in(cfp_mdio),
	.cfp_mdio_out(cfp_mdio_out),
	.cfp_mdio_oe(cfp_mdio_oe), // active high
	.cfp_glb_alrm(cfp_glb_alrm),
	.cfp_prtadr(),//cfp_prtadr),	
	
	// CFP custom controls
	.cfp_mod_lopwr(cfp_mod_lopwr),
	.cfp_mod_rst(cfp_mod_rst), // active low
	.cfp_tx_dis(cfp_tx_dis),
	.cfp_mod_abs(cfp_mod_abs),
	.cfp_rx_los(cfp_rx_los),
	.cfp_prg_alrm(cfp_prg_alrm),
	.cfp_prg_cntl(cfp_prg_cntl),
	
	// XFP I2C controls
	.xfp_sda_in(xfp_sda_in),
	.xfp_sda_out(xfp_sda_out),
	.xfp_sda_oe(xfp_sda_oe),	// active high
	.xfp_scl_in(xfp_scl_in),
	.xfp_scl_out(xfp_scl_out),
	.xfp_scl_oe(xfp_scl_oe)	// active high
);


 // _____________________________________________________________
 // merge status bus
 // _____________________________________________________________

 wire [31:0] status_readdata;
 wire status_readdata_valid, status_waitrequest;

  alt_aeuex_avalon_mm_read_combine #(
    .NUM_CLIENTS         (4)
  )arc (
    .clk            (clk_status),
    .host_read        (status_read),
    .host_readdata        (status_readdata),
    .host_readdata_valid    (status_readdata_valid),
    .host_waitrequest    (status_waitrequest),

    .client_readdata_valid    ({status_readdata_valid_cfp,
                                status_readdata_valid_eth|status_read_timeout, 
                                status_readdata_valid_pc, reco_readdata_valid}),
    .client_readdata    ({status_readdata_cfp, status_readdata_eth, status_readdata_pc, reco_readdata})   
 );

    // _______________________________________________________________________________________________________________ 
    // jtag_avalon 
    // _______________________________________________________________________________________________________________
    wire [31:0] av_addr;
    assign status_addr = av_addr[17:2];
    wire [3:0] byteenable;

    alt_aeuex_jtag_avalon jtag_master (
        .clk_clk                (clk_status),
        .clk_reset_reset        (arst),
        .master_reset_reset     (),
        .master_byteenable      (byteenable),
        .master_address         (av_addr),
        .master_read            (status_read),
        .master_readdata        (status_readdata),
        .master_readdatavalid   (status_readdata_valid),
        .master_waitrequest     (status_waitrequest),
        .master_write           (status_write),
        .master_writedata       (status_writedata)
    );
    // ___________________________________________________________
endmodule
