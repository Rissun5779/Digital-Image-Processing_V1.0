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
    parameter READ_ISSUING_CAPABILITY        = 16;
    parameter WRITE_ISSUING_CAPABILITY       = 16;
    parameter COMBINED_ISSUING_CAPABILITY    = 16;
    parameter READ_ACCEPTANCE_CAPABILITY     = 2;
    parameter WRITE_ACCEPTANCE_CAPABILITY    = 2;
    parameter COMBINED_ACCEPTANCE_CAPABILITY = 4;

    reg ACLK = 0;
    reg ARESETn = 0;
    
    wire                                      AWVALID;
    wire  [((AXI4_ADDRESS_WIDTH) - 1):0]      AWADDR;
    wire  [2:0]                               AWPROT;
    wire                                      AWREADY;
    wire                                      ARVALID;
    wire  [((AXI4_ADDRESS_WIDTH) - 1):0]      ARADDR;
    wire  [2:0]                               ARPROT;
    wire                                      ARREADY;
    wire                                      RVALID;
    wire  [((AXI4_RDATA_WIDTH) - 1):0]        RDATA;
    wire  [1:0]                               RRESP;
    wire                                      RREADY;
    wire                                      WVALID;
    wire  [((AXI4_WDATA_WIDTH) - 1):0]        WDATA;
    wire  [(((AXI4_WDATA_WIDTH / 8)) - 1):0]  WSTRB;
    wire                                      WREADY;
    wire                                      BVALID;
    wire  [1:0]                               BRESP;
    wire                                      BREADY;


    mgc_axi4lite_master #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .READ_ISSUING_CAPABILITY(READ_ISSUING_CAPABILITY), .WRITE_ISSUING_CAPABILITY(WRITE_ISSUING_CAPABILITY), .COMBINED_ISSUING_CAPABILITY(COMBINED_ISSUING_CAPABILITY)) bfm_master
    (
        .ACLK(ACLK), .ARESETn(ARESETn), 
        .AWVALID(AWVALID), .AWADDR(AWADDR), .AWPROT(AWPROT), .AWREADY(AWREADY), .ARVALID(ARVALID), .ARADDR(ARADDR), .ARPROT(ARPROT), .ARREADY(ARREADY),
        .RVALID(RVALID), .RDATA(RDATA), .RRESP(RRESP), .RREADY(RREADY), .WVALID(WVALID), .WDATA(WDATA), .WSTRB(WSTRB), .WREADY(WREADY), .BVALID(BVALID), .BRESP(BRESP), .BREADY(BREADY)
    );
                                                                                                                     
    mgc_axi4lite_slave #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .READ_ACCEPTANCE_CAPABILITY(READ_ACCEPTANCE_CAPABILITY), .WRITE_ACCEPTANCE_CAPABILITY(WRITE_ACCEPTANCE_CAPABILITY), .COMBINED_ACCEPTANCE_CAPABILITY(COMBINED_ACCEPTANCE_CAPABILITY)) bfm_slave
    (
        .ACLK(ACLK), .ARESETn(ARESETn), 
        .AWVALID(AWVALID), .AWADDR(AWADDR), .AWPROT(AWPROT), .AWREADY(AWREADY), .ARVALID(ARVALID), .ARADDR(ARADDR), .ARPROT(ARPROT), .ARREADY(ARREADY),
        .RVALID(RVALID), .RDATA(RDATA), .RRESP(RRESP), .RREADY(RREADY), .WVALID(WVALID), .WDATA(WDATA), .WSTRB(WSTRB), .WREADY(WREADY), .BVALID(BVALID), .BRESP(BRESP), .BREADY(BREADY)
    );

    mgc_axi4lite_inline_monitor #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .READ_ACCEPTANCE_CAPABILITY(READ_ACCEPTANCE_CAPABILITY), .WRITE_ACCEPTANCE_CAPABILITY(WRITE_ACCEPTANCE_CAPABILITY), .COMBINED_ACCEPTANCE_CAPABILITY(COMBINED_ACCEPTANCE_CAPABILITY)) bfm_monitor
    (
        .ACLK(ACLK), .ARESETn(ARESETn), 
        .master_AWVALID(), .master_AWADDR(), .master_AWPROT(), .master_AWREADY(AWREADY),
        .master_ARVALID(), .master_ARADDR(), .master_ARPROT(), .master_ARREADY(ARREADY),
        .master_RVALID(RVALID), .master_RDATA(RDATA), .master_RRESP(RRESP), .master_RREADY(),
        .master_WVALID(), .master_WDATA(), .master_WSTRB(), .master_WREADY(WREADY),
        .master_BVALID(BVALID), .master_BRESP(BRESP), .master_BREADY(),
        .slave_AWVALID(AWVALID), .slave_AWADDR(AWADDR), .slave_AWPROT(AWPROT), .slave_AWREADY(),
        .slave_ARVALID(ARVALID), .slave_ARADDR(ARADDR), .slave_ARPROT(ARPROT), .slave_ARREADY(),
        .slave_RVALID(), .slave_RDATA(), .slave_RRESP(), .slave_RREADY(RREADY),
        .slave_WVALID(WVALID), .slave_WDATA(WDATA), .slave_WSTRB(WSTRB), .slave_WREADY(),
        .slave_BVALID(), .slave_BRESP(), .slave_BREADY(BREADY)
    );

    master_test_program  #(AXI4_ADDRESS_WIDTH, AXI4_RDATA_WIDTH, AXI4_WDATA_WIDTH) u_master  (bfm_master.axi4_master_bfm_inst);
    slave_test_program   #(AXI4_ADDRESS_WIDTH, AXI4_RDATA_WIDTH, AXI4_WDATA_WIDTH) u_slave   (bfm_slave.axi4_slave_bfm_inst);
    monitor_test_program #(AXI4_ADDRESS_WIDTH, AXI4_RDATA_WIDTH, AXI4_WDATA_WIDTH) u_monitor (bfm_monitor.axi4_inline_monitor_bfm_inst.mgc_axi4_monitor_0);
 
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
