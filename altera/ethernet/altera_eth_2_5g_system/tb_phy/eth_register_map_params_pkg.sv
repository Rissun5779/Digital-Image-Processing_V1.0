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


`ifndef ETH_REGISTER_MAP_PARAMS_PKG__SV
`define ETH_REGISTER_MAP_PARAMS_PKG__SV

// Package defines address of registers
package eth_register_map_params_pkg;

    // ******************************************************************************************
    // Register Address
    // ******************************************************************************************
    
    // Control register for source address insertion on TX path
    parameter PHY_STATUS_ADDR                    = 32'h004;
 
    
endpackage

`endif
