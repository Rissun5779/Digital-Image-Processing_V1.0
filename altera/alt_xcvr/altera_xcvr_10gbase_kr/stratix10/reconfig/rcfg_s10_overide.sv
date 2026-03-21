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




//===========================================================================
// This confidential and proprietary software may be used only as authorized
// by a licensing agreement from ALTERA
// copyright notice must be reproduced on all authorized copies.
//============================================================================

//============================================================================
// Override data
//============================================================================

package altera_xcvr_10gkr_s10_override_data;

//=============FUNCTION FOR AN OVERRIDE DATA =================================
localparam an_ram_depth = 2;
function [26:0] get_an_ovrd_data;
  input integer index;
  automatic reg [0:an_ram_depth-1][26:0] ram_data = {
    // [26:16]-DPRIO address=; [15:8]-bit mask=; [7:0]- data
    27'h 1673F1F,// Set CTLE to manual mode- fix CTLE to 15
    27'h 15B0101 // Set DFE to manual mode ; assumption - DFE fix taps are 0 14F to 155
};

  begin
  get_an_ovrd_data = ram_data[index];
  end
endfunction
//=============FUNCTION FOR AN OVERRIDE DATA END==============================


//=============OTHER OVERRIDE DATA CAN BE ADDED HERE===========================

endpackage
