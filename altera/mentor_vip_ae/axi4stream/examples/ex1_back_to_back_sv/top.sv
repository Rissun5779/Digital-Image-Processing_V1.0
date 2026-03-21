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

    parameter AXI4STREAM_ID_WIDTH   = 8;
    parameter AXI4STREAM_USER_WIDTH = 4;
    parameter AXI4STREAM_DEST_WIDTH = 4;
    parameter AXI4STREAM_DATA_WIDTH = 32;

    reg ACLK = 0;
    reg ARESETn = 0;
    
    wire                                   TVALID ;
    wire                                   TREADY ;
    wire [(AXI4STREAM_DATA_WIDTH-1):0]     TDATA  ;
    wire [((AXI4STREAM_DATA_WIDTH/8)-1):0] TSTRB  ;
    wire [((AXI4STREAM_DATA_WIDTH/8)-1):0] TKEEP  ;
    wire                                   TLAST  ;
    wire [(AXI4STREAM_ID_WIDTH-1):0]       TID    ;
    wire [(AXI4STREAM_DEST_WIDTH-1):0]     TDEST  ;
    wire [(AXI4STREAM_USER_WIDTH-1):0]     TUSER  ;


    mgc_axi4stream_master #(AXI4STREAM_ID_WIDTH, AXI4STREAM_USER_WIDTH, AXI4STREAM_DEST_WIDTH, AXI4STREAM_DATA_WIDTH) bfm_master
    (
        .ACLK(ACLK), .ARESETn(ARESETn), 
        .TVALID(TVALID), .TREADY(TREADY),
        .TDATA(TDATA), .TSTRB(TSTRB), .TKEEP(TKEEP), .TLAST(TLAST), .TID(TID), .TDEST(TDEST), .TUSER(TUSER)
    );
                                                                                                                      
    mgc_axi4stream_slave #(AXI4STREAM_ID_WIDTH, AXI4STREAM_USER_WIDTH, AXI4STREAM_DEST_WIDTH, AXI4STREAM_DATA_WIDTH) bfm_slave
    (
        .ACLK(ACLK), .ARESETn(ARESETn), 
        .TVALID(TVALID), .TREADY(TREADY),
        .TDATA(TDATA), .TSTRB(TSTRB), .TKEEP(TKEEP), .TLAST(TLAST), .TID(TID), .TDEST(TDEST), .TUSER(TUSER)
    );
                                                                                                                     
    mgc_axi4stream_monitor #(AXI4STREAM_ID_WIDTH, AXI4STREAM_USER_WIDTH, AXI4STREAM_DEST_WIDTH, AXI4STREAM_DATA_WIDTH) bfm_monitor
    (
        .ACLK(ACLK), .ARESETn(ARESETn), 
        .TVALID(TVALID), .TREADY(TREADY),
        .TDATA(TDATA), .TSTRB(TSTRB), .TKEEP(TKEEP), .TLAST(TLAST), .TID(TID), .TDEST(TDEST), .TUSER(TUSER)
    );
                                                                                                                     

    master_test_program #(AXI4STREAM_ID_WIDTH, AXI4STREAM_USER_WIDTH, AXI4STREAM_DEST_WIDTH, AXI4STREAM_DATA_WIDTH) u_master ( bfm_master );
    slave_test_program  #(AXI4STREAM_ID_WIDTH, AXI4STREAM_USER_WIDTH, AXI4STREAM_DEST_WIDTH, AXI4STREAM_DATA_WIDTH) u_slave  ( bfm_slave );
    monitor_test_program  #(AXI4STREAM_ID_WIDTH, AXI4STREAM_USER_WIDTH, AXI4STREAM_DEST_WIDTH, AXI4STREAM_DATA_WIDTH) u_monitor  ( bfm_monitor );
 
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
