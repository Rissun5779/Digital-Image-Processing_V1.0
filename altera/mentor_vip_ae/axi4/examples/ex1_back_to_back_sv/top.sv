// *****************************************************************************
//
// Copyright 2007-2016 Mentor Graphics Corporation
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//
// *****************************************************************************

`timescale 1ns/1ns

module top ();

    parameter AXI4_ADDRESS_WIDTH             = 32;
    parameter AXI4_RDATA_WIDTH               = 32;
    parameter AXI4_WDATA_WIDTH               = 32;
    parameter AXI4_ID_WIDTH                  = 18;
    parameter AXI4_USER_WIDTH                = 8;
    parameter AXI4_REGION_MAP_SIZE           = 16;
    parameter READ_ISSUING_CAPABILITY        = 16;
    parameter WRITE_ISSUING_CAPABILITY       = 16;
    parameter COMBINED_ISSUING_CAPABILITY    = 16;
    parameter READ_ACCEPTANCE_CAPABILITY     = 2;
    parameter WRITE_ACCEPTANCE_CAPABILITY    = 2;
    parameter COMBINED_ACCEPTANCE_CAPABILITY = 4;
    parameter READ_DATA_REORDERING_DEPTH     = 1;
    parameter USE_AWID = 1;
    parameter USE_AWREGION = 1;
    parameter USE_AWLEN = 1;
    parameter USE_AWSIZE = 1;
    parameter USE_AWBURST = 1;
    parameter USE_AWLOCK = 1;
    parameter USE_AWCACHE = 1;
    parameter USE_AWQOS = 1;
    parameter USE_WSTRB = 1;
    parameter USE_BID = 1;
    parameter USE_AWPROT = 1;
    parameter USE_WLAST = 1;
    parameter USE_BRESP = 1;
    parameter USE_ARID = 1;
    parameter USE_ARREGION = 1;
    parameter USE_ARLEN = 1;
    parameter USE_ARSIZE = 1;
    parameter USE_ARBURST = 1;
    parameter USE_ARLOCK = 1;
    parameter USE_ARCACHE = 1;
    parameter USE_ARQOS = 1;
    parameter USE_RID = 1;
    parameter USE_ARPROT = 1;
    parameter USE_RRESP = 1;
    parameter USE_RLAST = 1;
    parameter USE_AWUSER = 1;
    parameter USE_ARUSER = 1;
    parameter USE_WUSER = 1;
    parameter USE_RUSER = 1;
    parameter USE_BUSER = 1;

    reg ACLK = 0;
    reg ARESETn = 0;
    
    wire                                      AWVALID;
    wire  [((AXI4_ADDRESS_WIDTH) - 1):0]      AWADDR;
    wire  [2:0]                               AWPROT;
    wire  [3:0]                               AWREGION;
    wire  [7:0]                               AWLEN;
    wire  [2:0]                               AWSIZE;
    wire  [1:0]                               AWBURST;
    wire                                      AWLOCK;
    wire  [3:0]                               AWCACHE;
    wire  [3:0]                               AWQOS;
    wire  [((AXI4_ID_WIDTH) - 1):0]           AWID;
    wire [((AXI4_USER_WIDTH) - 1):0]          AWUSER;
    wire                                      AWREADY;
    wire                                      ARVALID;
    wire  [((AXI4_ADDRESS_WIDTH) - 1):0]      ARADDR;
    wire  [2:0]                               ARPROT;
    wire  [3:0]                               ARREGION;
    wire  [7:0]                               ARLEN;
    wire  [2:0]                               ARSIZE;
    wire  [1:0]                               ARBURST;
    wire                                      ARLOCK;
    wire  [3:0]                               ARCACHE;
    wire [3:0]                                ARQOS;
    wire  [((AXI4_ID_WIDTH) - 1):0]           ARID;
    wire [((AXI4_USER_WIDTH) - 1):0]          ARUSER;
    wire                                      ARREADY;
    wire                                      RVALID;
    wire  [((AXI4_RDATA_WIDTH) - 1):0]        RDATA;
    wire  [1:0]                               RRESP;
    wire                                      RLAST;
    wire  [((AXI4_ID_WIDTH) - 1):0]           RID;
    wire  [((AXI4_USER_WIDTH) - 1):0]         RUSER;
    wire                                      RREADY;
    wire                                      WVALID;
    wire  [((AXI4_WDATA_WIDTH) - 1):0]        WDATA;
    wire  [(((AXI4_WDATA_WIDTH / 8)) - 1):0]  WSTRB;
    wire                                      WLAST;
    wire  [((AXI4_USER_WIDTH) - 1):0]         WUSER;
    wire                                      WREADY;
    wire                                      BVALID;
    wire  [1:0]                               BRESP;
    wire  [((AXI4_ID_WIDTH) - 1):0]           BID;
    wire  [((AXI4_USER_WIDTH) - 1):0]         BUSER;
    wire                                      BREADY;


    mgc_axi4_master #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
                      .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),
                      .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),
                      .AXI4_ID_WIDTH(AXI4_ID_WIDTH),
                      .AXI4_USER_WIDTH(AXI4_USER_WIDTH),
                      .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE),
                      .READ_ISSUING_CAPABILITY(READ_ISSUING_CAPABILITY),
                      .WRITE_ISSUING_CAPABILITY(WRITE_ISSUING_CAPABILITY),
                      .COMBINED_ISSUING_CAPABILITY(COMBINED_ISSUING_CAPABILITY),
                      .USE_AWID(USE_AWID),
                      .USE_AWREGION(USE_AWREGION),
                      .USE_AWLEN(USE_AWLEN),
                      .USE_AWSIZE(USE_AWSIZE),
                      .USE_AWBURST(USE_AWBURST),
                      .USE_AWLOCK(USE_AWLOCK),
                      .USE_AWCACHE(USE_AWCACHE),
                      .USE_AWQOS(USE_AWQOS),
                      .USE_WSTRB(USE_WSTRB),
                      .USE_BID(USE_BID),
                      .USE_BRESP(USE_BRESP),
                      .USE_ARID(USE_ARID),
                      .USE_ARREGION(USE_ARREGION),
                      .USE_ARLEN(USE_ARLEN),
                      .USE_ARSIZE(USE_ARSIZE),
                      .USE_ARBURST(USE_ARBURST),
                      .USE_ARLOCK(USE_ARLOCK),
                      .USE_ARCACHE(USE_ARCACHE),
                      .USE_ARQOS(USE_ARQOS),
                      .USE_RID(USE_RID),
                      .USE_RRESP(USE_RRESP),
                      .USE_RLAST(USE_RLAST),
                      .USE_AWUSER(USE_AWUSER),
                      .USE_ARUSER(USE_ARUSER),
                      .USE_WUSER(USE_WUSER),
                      .USE_RUSER(USE_RUSER),
                      .USE_BUSER(USE_BUSER)
                       ) bfm_master
    (
        .ACLK(ACLK), .ARESETn(ARESETn), 
        .AWVALID(AWVALID), .AWADDR(AWADDR), .AWLEN(AWLEN), .AWSIZE(AWSIZE), .AWBURST(AWBURST), .AWLOCK(AWLOCK), .AWCACHE(AWCACHE), .AWPROT(AWPROT), .AWID(AWID), .AWREADY(AWREADY), .AWUSER(AWUSER), .AWREGION(AWREGION), .AWQOS(AWQOS),
        .ARVALID(ARVALID), .ARADDR(ARADDR), .ARLEN(ARLEN), .ARSIZE(ARSIZE), .ARBURST(ARBURST), .ARLOCK(ARLOCK), .ARCACHE(ARCACHE), .ARPROT(ARPROT), .ARID(ARID), .ARREADY(ARREADY), .ARUSER(ARUSER), .ARREGION(ARREGION), .ARQOS(ARQOS),
        .RVALID(RVALID), .RLAST(RLAST), .RDATA(RDATA), .RRESP(RRESP), .RID(RID), .RUSER(RUSER), .RREADY(RREADY),
        .WVALID(WVALID), .WLAST(WLAST), .WUSER(WUSER), .WDATA(WDATA), .WSTRB(WSTRB), .WREADY(WREADY),
        .BVALID(BVALID), .BRESP(BRESP), .BID(BID), .BUSER(BUSER), .BREADY(BREADY)
    );
                                                                                                                     
    mgc_axi4_slave #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
                     .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),
                     .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),
                     .AXI4_ID_WIDTH(AXI4_ID_WIDTH),
                     .AXI4_USER_WIDTH(AXI4_USER_WIDTH),
                     .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE),
                     .READ_ACCEPTANCE_CAPABILITY(READ_ACCEPTANCE_CAPABILITY),
                     .WRITE_ACCEPTANCE_CAPABILITY(WRITE_ACCEPTANCE_CAPABILITY),
                     .COMBINED_ACCEPTANCE_CAPABILITY(COMBINED_ACCEPTANCE_CAPABILITY),
                     .READ_DATA_REORDERING_DEPTH(READ_DATA_REORDERING_DEPTH),
                     .USE_AWREGION(USE_AWREGION),
                     .USE_AWLOCK(USE_AWLOCK),
                     .USE_AWCACHE(USE_AWCACHE),
                     .USE_AWQOS(USE_AWQOS),
                     .USE_AWPROT(USE_AWPROT),
                     .USE_WLAST(USE_WLAST),
                     .USE_BRESP(USE_BRESP),
                     .USE_ARREGION(USE_ARREGION),
                     .USE_ARLOCK(USE_ARLOCK),
                     .USE_ARCACHE(USE_ARCACHE),
                     .USE_ARQOS(USE_ARQOS),
                     .USE_ARPROT(USE_ARPROT),
                     .USE_RRESP(USE_RRESP),
                     .USE_AWUSER(USE_AWUSER),
                     .USE_ARUSER(USE_ARUSER),
                     .USE_WUSER(USE_WUSER),
                     .USE_RUSER(USE_RUSER),
                     .USE_BUSER(USE_BUSER)
                   ) bfm_slave
    (
        .ACLK(ACLK), .ARESETn(ARESETn), 
        .AWVALID(AWVALID), .AWADDR(AWADDR), .AWLEN(AWLEN), .AWSIZE(AWSIZE), .AWBURST(AWBURST), .AWLOCK(AWLOCK), .AWCACHE(AWCACHE), .AWPROT(AWPROT), .AWID(AWID), .AWREADY(AWREADY), .AWUSER(AWUSER), .AWREGION(AWREGION), .AWQOS(AWQOS),
        .ARVALID(ARVALID), .ARADDR(ARADDR), .ARLEN(ARLEN), .ARSIZE(ARSIZE), .ARBURST(ARBURST), .ARLOCK(ARLOCK), .ARCACHE(ARCACHE), .ARPROT(ARPROT), .ARID(ARID), .ARREADY(ARREADY), .ARUSER(ARUSER), .ARREGION(ARREGION), .ARQOS(ARQOS),
        .RVALID(RVALID), .RLAST(RLAST), .RDATA(RDATA), .RRESP(RRESP), .RID(RID), .RUSER(RUSER), .RREADY(RREADY),
        .WVALID(WVALID), .WLAST(WLAST), .WUSER(WUSER), .WDATA(WDATA), .WSTRB(WSTRB), .WREADY(WREADY),
        .BVALID(BVALID), .BRESP(BRESP), .BID(BID), .BUSER(BUSER), .BREADY(BREADY)
    );

    mgc_axi4_monitor #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
                       .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),
                       .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),
                       .AXI4_ID_WIDTH(AXI4_ID_WIDTH),
                       .AXI4_USER_WIDTH(AXI4_USER_WIDTH),
                       .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE),
                       .READ_ACCEPTANCE_CAPABILITY(READ_ACCEPTANCE_CAPABILITY),
                       .WRITE_ACCEPTANCE_CAPABILITY(WRITE_ACCEPTANCE_CAPABILITY),
                       .COMBINED_ACCEPTANCE_CAPABILITY(COMBINED_ACCEPTANCE_CAPABILITY),
                       .USE_AWID(USE_AWID),
                       .USE_AWREGION(USE_AWREGION),
                       .USE_AWLEN(USE_AWLEN),
                       .USE_AWSIZE(USE_AWSIZE),
                       .USE_AWBURST(USE_AWBURST),
                       .USE_AWLOCK(USE_AWLOCK),
                       .USE_AWCACHE(USE_AWCACHE),
                       .USE_AWQOS(USE_AWQOS),
                       .USE_WSTRB(USE_WSTRB),
                       .USE_BID(USE_BID),
                       .USE_AWPROT(USE_AWPROT),
                       .USE_WLAST(USE_WLAST),
                       .USE_BRESP(USE_BRESP),
                       .USE_ARID(USE_ARID),
                       .USE_ARREGION(USE_ARREGION),
                       .USE_ARLEN(USE_ARLEN),
                       .USE_ARSIZE(USE_ARSIZE),
                       .USE_ARBURST(USE_ARBURST),
                       .USE_ARLOCK(USE_ARLOCK),
                       .USE_ARCACHE(USE_ARCACHE),
                       .USE_ARQOS(USE_ARQOS),
                       .USE_RID(USE_RID),
                       .USE_ARPROT(USE_ARPROT),
                       .USE_RRESP(USE_RRESP),
                       .USE_RLAST(USE_RLAST),
                       .USE_AWUSER(USE_AWUSER),
                       .USE_ARUSER(USE_ARUSER),
                       .USE_WUSER(USE_WUSER),
                       .USE_RUSER(USE_RUSER),
                       .USE_BUSER(USE_BUSER)
                     ) bfm_monitor
    (
        .ACLK(ACLK), .ARESETn(ARESETn), 
        .AWVALID(AWVALID), .AWADDR(AWADDR), .AWLEN(AWLEN), .AWSIZE(AWSIZE), .AWBURST(AWBURST), .AWLOCK(AWLOCK), .AWCACHE(AWCACHE), .AWPROT(AWPROT), .AWID(AWID), .AWREADY(AWREADY), .AWUSER(AWUSER), .AWREGION(AWREGION), .AWQOS(AWQOS),
        .ARVALID(ARVALID), .ARADDR(ARADDR), .ARLEN(ARLEN), .ARSIZE(ARSIZE), .ARBURST(ARBURST), .ARLOCK(ARLOCK), .ARCACHE(ARCACHE), .ARPROT(ARPROT), .ARID(ARID), .ARREADY(ARREADY), .ARUSER(ARUSER), .ARREGION(ARREGION), .ARQOS(ARQOS),
        .RVALID(RVALID), .RLAST(RLAST), .RDATA(RDATA), .RRESP(RRESP), .RID(RID), .RUSER(RUSER), .RREADY(RREADY),
        .WVALID(WVALID), .WLAST(WLAST), .WUSER(WUSER), .WDATA(WDATA), .WSTRB(WSTRB), .WREADY(WREADY),
        .BVALID(BVALID), .BRESP(BRESP), .BID(BID), .BUSER(BUSER), .BREADY(BREADY)
    );

    master_test_program  #(AXI4_ADDRESS_WIDTH, AXI4_RDATA_WIDTH, AXI4_WDATA_WIDTH, AXI4_ID_WIDTH, AXI4_USER_WIDTH, AXI4_REGION_MAP_SIZE) u_master  (bfm_master);
    slave_test_program   #(AXI4_ADDRESS_WIDTH, AXI4_RDATA_WIDTH, AXI4_WDATA_WIDTH, AXI4_ID_WIDTH, AXI4_USER_WIDTH, AXI4_REGION_MAP_SIZE) u_slave   (bfm_slave);
    monitor_test_program #(AXI4_ADDRESS_WIDTH, AXI4_RDATA_WIDTH, AXI4_WDATA_WIDTH, AXI4_ID_WIDTH, AXI4_USER_WIDTH, AXI4_REGION_MAP_SIZE) u_monitor (bfm_monitor);
 
    initial
    begin
        ARESETn = 0;
        #100
        ARESETn = 1;
    end
    
    always
    begin
        #5

        ACLK = ~ACLK;
    end

endmodule
