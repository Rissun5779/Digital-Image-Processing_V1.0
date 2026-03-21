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


module twentynm_hps_interface_fpga2hps #(parameter data_width=32) (
   input  wire          port_size_config_0,
   input  wire          port_size_config_1,
   input  wire          port_size_config_2,
   input  wire          port_size_config_3,
   input  wire          clk,
   input  wire          aw_clk,
   input  wire [3:0]    aw_id,
   input  wire [31:0]   aw_addr,
   input  wire [3:0]    aw_len,
   input  wire [2:0]    aw_size,
   input  wire [1:0]    aw_burst,
   input  wire [1:0]    aw_lock,
   input  wire [3:0]    aw_cache,
   input  wire [2:0]    aw_prot,
   input  wire          aw_valid,
   output wire          aw_ready,
   input  wire [4:0]    aw_user,
   input  wire          w_clk,
   input  wire [3:0]    w_id,
   input  wire [127:0]  w_data,
   input  wire [15:0]   w_strb,
   input  wire          w_last,
   input  wire          w_valid,
   output wire          w_ready,
   input  wire          b_clk,
   output wire [3:0]    b_id,
   output wire [1:0]    b_resp,
   output wire          b_valid,
   input  wire          b_ready,
   input  wire          ar_clk,
   input  wire [3:0]    ar_id,
   input  wire [31:0]   ar_addr,
   input  wire [3:0]    ar_len,
   input  wire [2:0]    ar_size,
   input  wire [1:0]    ar_burst,
   input  wire [1:0]    ar_lock,
   input  wire [3:0]    ar_cache,
   input  wire [2:0]    ar_prot,
   input  wire          ar_valid,
   output wire          ar_ready,
   input  wire [4:0]    ar_user,
   input  wire          r_clk,
   output wire [3:0]    r_id,
   output wire [127:0]  r_data,
   output wire [1:0]    r_resp,
   output wire          r_last,
   output wire          r_valid,
   input  wire          r_ready);


   localparam AXI32 = 0;
   localparam AXI64 = 1;
   localparam AXI128 = 2;
   localparam AXI256 = 3;

   /* Down-size WDATA */
   wire [data_width-1:0] mgc_wdata = w_data[data_width-1:0];

   /* Down-size WSTRB */
   wire [(data_width/8)-1:0] mgc_wstrb = w_strb[(data_width/8)-1:0];

   /* Up-size RDATA */
   wire [data_width-1:0] mgc_rdata;
   assign r_data = {{(128-data_width){1'b0}},mgc_rdata};

   /* port_size_config[1:0] signal data width */
   wire size = {port_size_config_1,port_size_config_0};
   wire match =  (size==AXI128 && data_width==128)
              || (size==AXI64 && data_width==64)
              || (size==AXI32 && data_width==32);

   reg resetn;

   initial begin
      resetn = 1'b0;
      @(posedge clk); resetn = 1'b1;
      if (match!==1) begin
        $display("Warning: Initial port_size_config value does not match requested paramter.");
        $display("Parameter: %d bits. Port Size: 0x%x",data_width,size);
      end
   end

   function [3:0] get_port_size_config;
     get_port_size_config = {port_size_config_3,port_size_config_2,port_size_config_1,port_size_config_0};
   endfunction

   mgc_axi_slave #(
      .AXI_ADDRESS_WIDTH(32),
      .AXI_WDATA_WIDTH(data_width),
      .AXI_RDATA_WIDTH(data_width),
      .AXI_ID_WIDTH(4)
   ) axi_slave (
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
     .AWUSER({3'b0,aw_user}),
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
     .ARUSER({3'b0,ar_user}),
     .RVALID(r_valid),
     .RLAST(r_last),
     .RDATA(mgc_rdata),
     .RRESP(r_resp),
     .RID(r_id),
     .RREADY(r_ready),
     .WVALID(w_valid),
     .WLAST(w_last),
     .WDATA(mgc_wdata),
     .WSTRB(mgc_wstrb),
     .WID(w_id),
     .WREADY(w_ready),
     .BVALID(b_valid),
     .BRESP(b_resp),
     .BID(b_id),
     .BREADY(b_ready));

endmodule
