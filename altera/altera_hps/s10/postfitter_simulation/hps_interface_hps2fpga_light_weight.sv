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


module twentynm_hps_interface_hps2fpga_light_weight (
   input  wire        port_size_config_0,
   input  wire        port_size_config_1,
   input  wire        clk,
   input  wire        aw_clk,
   output wire [3:0]  aw_id,
   output wire [31:0] aw_addr,
   output wire [3:0]  aw_len,
   output wire [2:0]  aw_size,
   output wire [1:0]  aw_burst,
   output wire [1:0]  aw_lock,
   output wire [3:0]  aw_cache,
   output wire [2:0]  aw_prot,
   output wire        aw_valid,
   input  wire        aw_ready,
   output wire [4:0]  aw_user,
   input  wire        w_clk,
   output wire [3:0]  w_id,
   output wire [31:0] w_data,
   output wire [3:0]  w_strb,
   output wire        w_last,
   output wire        w_valid,
   input  wire        w_ready,
   input  wire        b_clk,
   input  wire [3:0]  b_id,
   input  wire [1:0]  b_resp,
   input  wire        b_valid,
   output wire        b_ready,
   input  wire        ar_clk,
   output wire [3:0]  ar_id,
   output wire [31:0] ar_addr,
   output wire [3:0]  ar_len,
   output wire [2:0]  ar_size,
   output wire [1:0]  ar_burst,
   output wire [1:0]  ar_lock,
   output wire [3:0]  ar_cache,
   output wire [2:0]  ar_prot,
   output wire        ar_valid,
   input  wire        ar_ready,
   input  wire [4:0]  ar_user,
   input  wire        r_clk,
   input  wire [3:0]  r_id,
   input  wire [31:0] r_data,
   input  wire [1:0]  r_resp,
   input  wire        r_last,
   input  wire        r_valid,
   output wire        r_ready);

   wire [7:0] mgc_awuser;
   wire [7:0] mgc_aruser;

   assign aw_user = mgc_awuser[4:0];
   assign ar_user = mgc_aruser[4:0];

   reg resetn;

   initial begin
      resetn = 1'b0;
      @(posedge clk); resetn = 1'b1;
   end

   function [1:0] get_port_size_config;
     get_port_size_config = {port_size_config_1,port_size_config_0};
   endfunction

   mgc_axi_master #(
     .AXI_ADDRESS_WIDTH(32),
     .AXI_RDATA_WIDTH(32),
     .AXI_WDATA_WIDTH(32),
     .AXI_ID_WIDTH(4)
   ) axi_master (
     .ACLK(clk),
     .ARESETn(resetn),
     .AWVALID(aw_valid),
     .AWADDR(aw_addr),
     .AWLEN(aw_len),
     .AWSIZE(aw_size),
     .AWBURST(aw_burst),
     .AWLOCK(aw_lock),
     .AWCACHE(aw_cache),
     .AWPROT(aw_prot),
     .AWID(aw_id),
     .AWREADY(aw_ready),
     .AWUSER(mgc_awuser),
     .ARVALID(ar_valid),
     .ARADDR(ar_addr),
     .ARLEN(ar_len),
     .ARSIZE(ar_size),
     .ARBURST(ar_burst),
     .ARLOCK(ar_lock),
     .ARCACHE(ar_cache),
     .ARPROT(ar_prot),
     .ARID(ar_id),
     .ARREADY(ar_ready),
     .ARUSER(mgc_aruser),
     .RVALID(r_valid),
     .RLAST(r_last),
     .RDATA(r_data),
     .RRESP(r_resp),
     .RID(r_id),
     .RREADY(r_ready),
     .WVALID(w_valid),
     .WLAST(w_last),
     .WDATA(w_data),
     .WSTRB(w_strb),
     .WID(w_id),
     .WREADY(w_ready),
     .BVALID(b_valid),
     .BRESP(b_resp),
     .BID(b_id),
     .BREADY(b_ready));

endmodule
