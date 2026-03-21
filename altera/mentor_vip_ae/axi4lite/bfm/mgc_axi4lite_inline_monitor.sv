// *****************************************************************************
//
// Copyright 2007-2016 Mentor Graphics Corporation
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
// PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
// LICENSE TERMS.
//
// *****************************************************************************
// dvc           
// *****************************************************************************
//
// Title: mgc_axi4lite_inline_monitor
//
// This is a wrapper around mgc_axi4_inline_monitor interface (axi4 monitor BFM)
// and provides the sub-set of full axi4 interface (configured to work as
// axi4lite inteface) signals which are intended for axi4lite, to connect to
// the axi4lite DUT signals. It ties the axi4 signals which are not specific to
// axi4lite interface to their default value accordingly.
//

import mgc_axi4_pkg::*;

module mgc_axi4lite_inline_monitor #(int AXI4_ADDRESS_WIDTH = 32,
                                     int AXI4_RDATA_WIDTH = 32,
                                     int AXI4_WDATA_WIDTH = 32,
                                     int index = 0,
                                     int READ_ACCEPTANCE_CAPABILITY = 16,
                                     int WRITE_ACCEPTANCE_CAPABILITY = 16,
                                     int COMBINED_ACCEPTANCE_CAPABILITY = 16
                                    )
 (
		input bit ACLK,
		input bit ARESETn,
    output bit master_AWVALID,
		output bit [2:0] master_AWPROT,
		input  bit master_AWREADY,
		output bit master_ARVALID,
		output bit [2:0] master_ARPROT,
		input  bit master_ARREADY,
		input  bit master_RVALID,
		input  bit [1:0] master_RRESP,
		output bit master_RREADY,
		output bit master_WVALID,
		input  bit master_WREADY,
		input  bit master_BVALID,
		input  bit [1:0] master_BRESP,
		output bit master_BREADY,
		output bit [(AXI4_ADDRESS_WIDTH - 1):0] master_AWADDR,
		output bit [(AXI4_ADDRESS_WIDTH - 1):0] master_ARADDR,
		input  bit [(AXI4_RDATA_WIDTH - 1):0] master_RDATA,
		output bit [(AXI4_WDATA_WIDTH - 1):0] master_WDATA,
		output bit [((AXI4_WDATA_WIDTH / 8) - 1):0] master_WSTRB,
    input  bit slave_AWVALID,
		input  bit [2:0] slave_AWPROT,
		output  bit slave_AWREADY,
		input bit slave_ARVALID,
		input bit [2:0] slave_ARPROT,
		output  bit slave_ARREADY,
		output  bit slave_RVALID,
		output  bit [1:0] slave_RRESP,
		input bit slave_RREADY,
		input bit slave_WVALID,
		output  bit slave_WREADY,
		output  bit slave_BVALID,
		output  bit [1:0] slave_BRESP,
		input bit slave_BREADY,
		input bit [(AXI4_ADDRESS_WIDTH - 1):0] slave_AWADDR,
		input bit [(AXI4_ADDRESS_WIDTH - 1):0] slave_ARADDR,
		output  bit [(AXI4_RDATA_WIDTH - 1):0] slave_RDATA,
		input   bit [(AXI4_WDATA_WIDTH - 1):0] slave_WDATA,
		input bit [((AXI4_WDATA_WIDTH / 8) - 1):0] slave_WSTRB
 );

 // Instantiation and port connection of mgc_axi4_inline_monitor
 mgc_axi4_inline_monitor #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
                           .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),
                           .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),
                           .index(index),
                           .READ_ACCEPTANCE_CAPABILITY(READ_ACCEPTANCE_CAPABILITY),
                           .WRITE_ACCEPTANCE_CAPABILITY(WRITE_ACCEPTANCE_CAPABILITY),
                           .COMBINED_ACCEPTANCE_CAPABILITY(COMBINED_ACCEPTANCE_CAPABILITY)
                           )
         axi4_inline_monitor_bfm_inst (
                                       .ACLK (ACLK),
                                       .ARESETn (ARESETn),
                                       .master_AWVALID (master_AWVALID),
                                       .master_AWADDR (master_AWADDR),
                                       .master_AWPROT (master_AWPROT),
                                       .master_AWREGION (),
                                       .master_AWLEN (),
                                       .master_AWSIZE (),
                                       .master_AWBURST (),
                                       .master_AWLOCK (),
                                       .master_AWCACHE (),
                                       .master_AWQOS (),
                                       .master_AWID (),
                                       .master_AWUSER (),
                                       .master_AWREADY (master_AWREADY),
                                       .master_ARVALID (master_ARVALID),
                                       .master_ARADDR (master_ARADDR),
                                       .master_ARPROT (master_ARPROT),
                                       .master_ARREGION (),
                                       .master_ARLEN (),
                                       .master_ARSIZE (),
                                       .master_ARBURST (),
                                       .master_ARLOCK (),
                                       .master_ARCACHE (),
                                       .master_ARQOS (),
                                       .master_ARID (),
                                       .master_ARUSER (),
                                       .master_ARREADY (master_ARREADY),
                                       .master_RVALID (master_RVALID),
                                       .master_RDATA (master_RDATA),
                                       .master_RRESP (master_RRESP),
                                       .master_RLAST (1'b1),
                                       .master_RID (18'b0),
                                       .master_RUSER (8'b0),
                                       .master_RREADY (master_RREADY),
                                       .master_WVALID (master_WVALID),
                                       .master_WDATA (master_WDATA),
                                       .master_WSTRB (master_WSTRB),
                                       .master_WLAST (),
                                       .master_WUSER (),
                                       .master_WREADY (master_WREADY),
                                       .master_BVALID (master_BVALID),
                                       .master_BRESP (master_BRESP),
                                       .master_BID (18'b0),
                                       .master_BUSER (8'b0),
                                       .master_BREADY (master_BREADY),
                                       .slave_AWVALID (slave_AWVALID),
                                       .slave_AWADDR (slave_AWADDR),
                                       .slave_AWPROT (slave_AWPROT),
                                       .slave_AWREGION (4'h0),
                                       .slave_AWLEN (8'h00),
                                       .slave_AWSIZE (3'b000),
                                       .slave_AWBURST (2'b00),
                                       .slave_AWLOCK (1'b0),
                                       .slave_AWCACHE (4'h0),
                                       .slave_AWQOS (4'h0),
                                       .slave_AWID (18'b0),
                                       .slave_AWUSER (8'h00),
                                       .slave_AWREADY (slave_AWREADY),
                                       .slave_ARVALID (slave_ARVALID),
                                       .slave_ARADDR (slave_ARADDR),
                                       .slave_ARPROT (slave_ARPROT),
                                       .slave_ARREGION (4'h0),
                                       .slave_ARLEN (8'h00),
                                       .slave_ARSIZE (3'b000),
                                       .slave_ARBURST (2'b00),
                                       .slave_ARLOCK (1'b0),
                                       .slave_ARCACHE (4'h0),
                                       .slave_ARQOS (4'h0),
                                       .slave_ARID (18'b0),
                                       .slave_ARUSER (8'h00),
                                       .slave_ARREADY (slave_ARREADY),
                                       .slave_RVALID (slave_RVALID),
                                       .slave_RDATA (slave_RDATA),
                                       .slave_RRESP (slave_RRESP),
                                       .slave_RLAST (),
                                       .slave_RID (),
                                       .slave_RUSER (),
                                       .slave_RREADY (slave_RREADY),
                                       .slave_WVALID (slave_WVALID),
                                       .slave_WDATA (slave_WDATA),
                                       .slave_WSTRB (slave_WSTRB),
                                       .slave_WLAST (1'b1),
                                       .slave_WUSER (8'b0),
                                       .slave_WREADY (slave_WREADY),
                                       .slave_BVALID (slave_BVALID),
                                       .slave_BRESP (slave_BRESP),
                                       .slave_BID (),
                                       .slave_BUSER (),
                                       .slave_BREADY (slave_BREADY)
                                      );

  initial
  begin
    // Configuration of axi4 monitor BFM to work as axi4lite monitor BFM
    axi4_inline_monitor_bfm_inst.mgc_axi4_monitor_0.set_config(AXI4_CONFIG_AXI4LITE_axi4,1);
  end

endmodule                                 
