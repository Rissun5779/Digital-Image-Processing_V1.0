// *****************************************************************************
//
// Copyright 2007-2016 Mentor Graphics Corporation
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//
// *****************************************************************************

module top ();
  reg reset_reset_n = 0;
  reg clk_clk      ;
   
  master_test_program #(
        .AXI4_ADDRESS_WIDTH (32),
        .AXI4_RDATA_WIDTH   (32),
        .AXI4_WDATA_WIDTH   (32)) u_master  (dut.mgc_axi4lite_master_0.axi4_master_bfm_inst);

  slave_test_program #(
        .AXI4_ADDRESS_WIDTH (32),
        .AXI4_RDATA_WIDTH   (32),
        .AXI4_WDATA_WIDTH   (32)) u_slave   (dut.mgc_axi4lite_slave_0.axi4_slave_bfm_inst);

  monitor_test_program #(
        .AXI4_ADDRESS_WIDTH (32),
        .AXI4_RDATA_WIDTH   (32),
        .AXI4_WDATA_WIDTH   (32)) u_monitor (
    dut.mgc_axi4lite_inline_monitor_0.axi4_inline_monitor_bfm_inst.mgc_axi4_monitor_0);

  ex1_back_to_back_sv           dut       (.reset_reset_n(reset_reset_n), .clk_clk(clk_clk));

  always begin
    clk_clk = 0;
    #100;
    clk_clk = 1;
    #100;
  end

  initial begin
    reset_reset_n = 0;
    #1000 reset_reset_n = 1;
  end

endmodule
