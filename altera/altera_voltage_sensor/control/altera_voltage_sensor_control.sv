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



// $Id: //acds/rel/18.1std/ip/altera_voltage_sensor/control/altera_voltage_sensor_control.sv#1 $
// $Revision: #1 $
// $Date: 2018/07/18 $
// $Author: psgswbuild $

// +----------------------------------------------------------------------
// | Altera Voltage Sensor Controller: 
// | This is a controller that allows users to interact with the 
// | voltage sensor block via Avalon interface
// +----------------------------------------------------------------------
`timescale 1 ps / 1 ps

module altera_voltage_sensor_control 
   (
    // Clock and reset
    input             clk,
    input             reset,

    // CSR interface: Avalon MM
    input             addr,
    input             read,
    input             write,
    input [31:0]      writedata,
    output reg [31:0] readdata,

    // Response interface: Avalon ST
    output reg        rsp_valid,
    output reg [2:0]  rsp_channel,
    output reg [5:0]  rsp_data,
    output reg        rsp_sop,
    output reg        rsp_eop
);

    //+---------------------------------------------------------
    //| Internal signals
    //+---------------------------------------------------------
    // Signals to the voltage sensor block
    wire              vs_corectl_wire;
    wire              vs_reset_wire;
    wire              vs_coreconfig_wire;
    wire              vs_confin_wire;
    wire              vs_eoc_wire;
    wire              vs_eos_wire;
    wire [3:0]        vs_muxsel_wire;
    wire [3:0]        vs_chsel_wire;
    wire [11:0]       vs_dataout_wire;


    voltage_sensor_avalon_control vs_controller
        (
         .clk              (clk),
         .reset            (reset),

         .addr             (addr),
         .read             (read),
         .write            (write),
         .writedata        (writedata),
         .readdata         (readdata),

         .rsp_valid        (rsp_valid),
         .rsp_channel      (rsp_channel),
         .rsp_data         (rsp_data),
         .rsp_sop          (rsp_sop),
         .rsp_eop          (rsp_eop),

         .vs_corectl       (vs_corectl_wire),
         .vs_reset         (vs_reset_wire),
         .vs_coreconfig    (vs_coreconfig_wire),
         .vs_confin        (vs_confin_wire),
         .vs_chsel         (vs_chsel_wire),
         .vs_eoc           (vs_eoc_wire),
         .vs_eos           (vs_eos_wire),
         .vs_muxsel        (vs_muxsel_wire),
         .vs_dataout       (vs_dataout_wire)
         );
	 
    voltage_sensor_wrapper  voltage_block
        (
         .vs_clk               (clk),
	     .vs_coreconfig        (vs_coreconfig_wire),
	     .vs_confin            (vs_confin_wire),
	     .vs_corectl           (vs_corectl_wire),
	     .vs_reset             (vs_reset_wire),
	     .vs_chsel             (vs_chsel_wire),
	     .vs_eoc               (vs_eoc_wire),
	     .vs_eos               (vs_eos_wire),
	     .vs_dataout           (vs_dataout_wire),
	     .vs_muxsel            (vs_muxsel_wire)
         );
  
  
endmodule
