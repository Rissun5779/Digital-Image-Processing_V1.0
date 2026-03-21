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
// Title: mgc_axi4lite_master
//
// This is a wrapper around mgc_axi4_master interface (axi4 master BFM) and
// provides the sub-set of full axi4 interface (configured to work as axi4lite
// inteface) signals which are intended for axi4lite, to connect to the axi4lite
// DUT signals. It ties the axi4 signals which are not specific to axi4lite
// interface to their default value accordingly.
//

import mgc_axi4_pkg::*;

module mgc_axi4lite_master #(int AXI4_ADDRESS_WIDTH = 32,
                             int AXI4_RDATA_WIDTH = 32,
                             int AXI4_WDATA_WIDTH = 32,
                             int index = 0,
                             int READ_ISSUING_CAPABILITY = 16,
                             int WRITE_ISSUING_CAPABILITY = 16,
                             int COMBINED_ISSUING_CAPABILITY = 16
                            )
 (
    output bit AWVALID,
		output bit [2:0] AWPROT,
		input  bit AWREADY,
		output bit ARVALID,
		output bit [2:0] ARPROT,
		input  bit ARREADY,
		input  bit RVALID,
		input  bit [1:0] RRESP,
		output bit RREADY,
		output bit WVALID,
		input  bit WREADY,
		input  bit BVALID,
		input  bit [1:0] BRESP,
		output bit BREADY,
		output bit [(AXI4_ADDRESS_WIDTH - 1):0] AWADDR,
		output bit [(AXI4_ADDRESS_WIDTH - 1):0] ARADDR,
		input  bit [(AXI4_RDATA_WIDTH - 1):0] RDATA,
		output bit [(AXI4_WDATA_WIDTH - 1):0] WDATA,
		output bit [((AXI4_WDATA_WIDTH / 8) - 1):0] WSTRB,
		input bit ACLK,
		input bit ARESETn
 );

 // Instantiation and port connection of mgc_axi4_master
 mgc_axi4_master #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
                   .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),
                   .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),
                   .index(index),
                   .READ_ISSUING_CAPABILITY(READ_ISSUING_CAPABILITY),
                   .WRITE_ISSUING_CAPABILITY(WRITE_ISSUING_CAPABILITY),
                   .COMBINED_ISSUING_CAPABILITY(COMBINED_ISSUING_CAPABILITY)
                   )
         axi4_master_bfm_inst (
                                .ACLK (ACLK),
                                .ARESETn (ARESETn),
                                .AWVALID (AWVALID),
                                .AWADDR (AWADDR),
                                .AWPROT (AWPROT),
                                .AWREGION (),
                                .AWLEN (),
                                .AWSIZE (),
                                .AWBURST (),
                                .AWLOCK (),
                                .AWCACHE (),
                                .AWQOS (),
                                .AWID (),
                                .AWUSER (),
                                .AWREADY (AWREADY),
                                .ARVALID (ARVALID),
                                .ARADDR (ARADDR),
                                .ARPROT (ARPROT),
                                .ARREGION (),
                                .ARLEN (),
                                .ARSIZE (),
                                .ARBURST (),
                                .ARLOCK (),
                                .ARCACHE (),
                                .ARQOS (),
                                .ARID (),
                                .ARUSER (),
                                .ARREADY (ARREADY),
                                .RVALID (RVALID),
                                .RDATA (RDATA),
                                .RRESP (RRESP),
                                .RLAST (1'b1),
                                .RID (18'b0),
                                .RUSER (8'b0),
                                .RREADY (RREADY),
                                .WVALID (WVALID),
                                .WDATA (WDATA),
                                .WSTRB (WSTRB),
                                .WLAST (),
                                .WUSER (),
                                .WREADY (WREADY),
                                .BVALID (BVALID),
                                .BRESP (BRESP),
                                .BID (18'b0),
                                .BUSER (8'b0),
                                .BREADY (BREADY)
                               );

  initial
  begin
    // Configuration of axi4 master BFM to work as axi4lite master BFM
    axi4_master_bfm_inst.set_config(AXI4_CONFIG_AXI4LITE_axi4,1);
  end

endmodule                                 
