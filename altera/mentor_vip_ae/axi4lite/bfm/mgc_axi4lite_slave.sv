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
// Title: mgc_axi4lite_slave
//
// This is a wrapper around mgc_axi4_slave interface (axi4 slave BFM) and
// provides the sub-set of full axi4 interface (configured to work as axi4lite
// inteface) signals which are intended for axi4lite, to connect to the axi4lite
// DUT signals. It ties the axi4 signals which are not specific to axi4lite
// interface to their default value accordingly.
//

import mgc_axi4_pkg::*;

module mgc_axi4lite_slave #(int AXI4_ADDRESS_WIDTH = 32,
                            int AXI4_RDATA_WIDTH = 32,
                            int AXI4_WDATA_WIDTH = 32,
                            int index = 0,
                            int READ_ACCEPTANCE_CAPABILITY = 16,
                            int WRITE_ACCEPTANCE_CAPABILITY = 16,
                            int COMBINED_ACCEPTANCE_CAPABILITY = 16
                            )
 (
    input  bit AWVALID,
		input  bit [2:0] AWPROT,
		output  bit AWREADY,
		input bit ARVALID,
		input bit [2:0] ARPROT,
		output  bit ARREADY,
		output  bit RVALID,
		output  bit [1:0] RRESP,
		input bit RREADY,
		input bit WVALID,
		output  bit WREADY,
		output  bit BVALID,
		output  bit [1:0] BRESP,
		input bit BREADY,
		input bit [(AXI4_ADDRESS_WIDTH - 1):0] AWADDR,
		input bit [(AXI4_ADDRESS_WIDTH - 1):0] ARADDR,
		output  bit [(AXI4_RDATA_WIDTH - 1):0] RDATA,
		input bit [(AXI4_WDATA_WIDTH - 1):0] WDATA,
		input bit [((AXI4_WDATA_WIDTH / 8) - 1):0] WSTRB,
		input bit ACLK,
		input bit ARESETn
 );

 // Instantiation and port connection of mgc_axi4_slave
 mgc_axi4_slave #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
                  .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),
                  .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),
                  .index(index),
                  .READ_ACCEPTANCE_CAPABILITY(READ_ACCEPTANCE_CAPABILITY),
                  .WRITE_ACCEPTANCE_CAPABILITY(WRITE_ACCEPTANCE_CAPABILITY),
                  .COMBINED_ACCEPTANCE_CAPABILITY(COMBINED_ACCEPTANCE_CAPABILITY)
                  )
         axi4_slave_bfm_inst (
                               .ACLK (ACLK),
                               .ARESETn (ARESETn),
                               .AWVALID (AWVALID),
                               .AWADDR (AWADDR),
                               .AWPROT (AWPROT),
                               .AWREGION (4'h0),
                               .AWLEN (8'h00),
                               .AWSIZE (3'b000),
                               .AWBURST (2'b00),
                               .AWLOCK (1'b0),
                               .AWCACHE (4'h0),
                               .AWQOS (4'h0),
                               .AWID (18'b0),
                               .AWUSER (8'h00),
                               .AWREADY (AWREADY),
                               .ARVALID (ARVALID),
                               .ARADDR (ARADDR),
                               .ARPROT (ARPROT),
                               .ARREGION (4'h0),
                               .ARLEN (8'h00),
                               .ARSIZE (3'b000),
                               .ARBURST (2'b00),
                               .ARLOCK (1'b0),
                               .ARCACHE (4'h0),
                               .ARQOS (4'h0),
                               .ARID (18'b0),
                               .ARUSER (8'h00),
                               .ARREADY (ARREADY),
                               .RVALID (RVALID),
                               .RDATA (RDATA),
                               .RRESP (RRESP),
                               .RLAST (),
                               .RID (),
                               .RUSER (),
                               .RREADY (RREADY),
                               .WVALID (WVALID),
                               .WDATA (WDATA),
                               .WSTRB (WSTRB),
                               .WLAST (1'b1),
                               .WUSER (8'b0),
                               .WREADY (WREADY),
                               .BVALID (BVALID),
                               .BRESP (BRESP),
                               .BID (),
                               .BUSER (),
                               .BREADY (BREADY)
                             );

  initial
  begin
    // Configuration of axi4 slave BFM to work as axi4lite slave BFM
    axi4_slave_bfm_inst.set_config(AXI4_CONFIG_AXI4LITE_axi4,1);
  end

endmodule                                 
