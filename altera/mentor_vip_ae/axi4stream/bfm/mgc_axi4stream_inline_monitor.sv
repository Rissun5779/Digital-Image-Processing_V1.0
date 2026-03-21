// *****************************************************************************
//
// Copyright 2007-2016 Mentor Graphics Corporation
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//
// *****************************************************************************
//            Version: 20160107
// *****************************************************************************

// Title: axi4stream_inline_monitor
//

// import package for the axi4stream interface
import mgc_axi4stream_pkg::*;

interface mgc_axi4stream_inline_monitor #(int AXI4_ID_WIDTH = 8, int AXI4_USER_WIDTH = 8, int AXI4_DEST_WIDTH = 18, int AXI4_DATA_WIDTH = 1024, int index = 0)
(
    input  ACLK,
    input  ARESETn,
    output master_TVALID,
    output [((AXI4_DATA_WIDTH) - 1):0]  master_TDATA,
    output [(((AXI4_DATA_WIDTH / 8)) - 1):0]  master_TSTRB,
    output [(((AXI4_DATA_WIDTH / 8)) - 1):0]  master_TKEEP,
    output master_TLAST,
    output [((AXI4_ID_WIDTH) - 1):0]  master_TID,
    output [((AXI4_USER_WIDTH) - 1):0]  master_TUSER,
    output [((AXI4_DEST_WIDTH) - 1):0]  master_TDEST,
    input  master_TREADY,
    input  slave_TVALID,
    input  [((AXI4_DATA_WIDTH) - 1):0]  slave_TDATA,
    input  [(((AXI4_DATA_WIDTH / 8)) - 1):0]  slave_TSTRB,
    input  [(((AXI4_DATA_WIDTH / 8)) - 1):0]  slave_TKEEP,
    input  slave_TLAST,
    input  [((AXI4_ID_WIDTH) - 1):0]  slave_TID,
    input  [((AXI4_USER_WIDTH) - 1):0]  slave_TUSER,
    input  [((AXI4_DEST_WIDTH) - 1):0]  slave_TDEST,
    output slave_TREADY
);

`ifdef MODEL_TECH
  `ifdef _MGC_VIP_VHDL_INTERFACE
    `include "mgc_axi4stream_inline_monitor.mti.svp"
  `endif
`endif

    assign master_TVALID         = slave_TVALID;
    assign master_TDATA          = slave_TDATA;
    assign master_TSTRB          = slave_TSTRB;
    assign master_TKEEP          = slave_TKEEP;
    assign master_TLAST          = slave_TLAST;
    assign master_TID            = slave_TID;
    assign master_TUSER          = slave_TUSER;
    assign master_TDEST          = slave_TDEST;
    assign slave_TREADY          = master_TREADY;

    mgc_axi4stream_monitor #(AXI4_ID_WIDTH, AXI4_USER_WIDTH, AXI4_DEST_WIDTH, AXI4_DATA_WIDTH, index)  mgc_axi4stream_monitor_0
    (
        .ACLK      ( ACLK ),
        .ARESETn   ( ARESETn ),
        .TVALID    ( slave_TVALID ),
        .TDATA     ( slave_TDATA ),
        .TSTRB     ( slave_TSTRB ),
        .TKEEP     ( slave_TKEEP ),
        .TLAST     ( slave_TLAST ),
        .TID       ( slave_TID ),
        .TUSER     ( slave_TUSER ),
        .TDEST     ( slave_TDEST ),
        .TREADY    ( master_TREADY )
    );

endinterface
