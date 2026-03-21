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



// $Id: //acds/rel/18.1std/ip/altera_voltage_sensor/control/voltage_sensor_wrapper.sv#1 $
// $Revision: #1 $
// $Date: 2018/07/18 $
// $Author: psgswbuild $

// +----------------------------------------------------------------------
// | Altera Voltage Sensor Wrapper
// +----------------------------------------------------------------------
`timescale 1 ps / 1 ps

module voltage_sensor_wrapper
   (
    input           vs_clk,
    input           vs_confin,
    input           vs_coreconfig,
    input           vs_reset,
    input           vs_corectl,
    input [3:0]     vs_chsel,
    output          vs_eoc,
    output          vs_eos,
    output [3:0]    vs_muxsel, 
    output [11:0]   vs_dataout
);

    twentynm_vsblock vs_block
    (
     .clk               (vs_clk),
	 .coreconfig        (vs_coreconfig),
	 .confin            (vs_confin),
	 .corectl           (vs_corectl),
	 .reset             (vs_reset),
	 .chsel             (vs_chsel),
	 .eoc               (vs_eoc),
	 .eos               (vs_eos),
	 .dataout           (vs_dataout),
	 .muxsel            (vs_muxsel)
     );
    
endmodule
