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
// Reconfig PCS Data array
// For the FEC variant with a 644 MHz reference clock
//============================================================================

`timescale 1 ps / 1 ps

module alt_aeu_40_rcfg_data_fec_644
    #(
  parameter SYNTH_AN_LT      = 1        // Synthesize/include the AN or LT
    ) (
  input  wire [5:0]     pcs_data_addr,  // data array address
  input  wire [5:0]     pcs_mode_rc,    // PCS mode for reconfig - 1 hot
                                        // bit 0 = AN mode = low_lat, PLL LTR
                                        // bit 1 = LT mode = low_lat, PLL LTD
                                        // bit 2 = 10G data mode = 10GBASE-R
                                        // bit 3 = GigE data mode = 8G PCS
                                        // bit 4 = XAUI data mode = future?
                                        // bit 5 = 10G-FEC
  output wire [9:0]     rcfg_addr,      // HSSI DPRIO address/offset
  output wire [7:0]     rcfg_data,      // HSSI DPRIO data
  output wire [7:0]     rcfg_mask       // Mask for read-modify-write
  );

generate
  if (SYNTH_AN_LT) begin : backplane
    // Define Wires and Variables
   reg [25:0] an_data    [0:23];
   reg [25:0] fec_kr4_data [0:21];
   reg [25:0] gige_unused_data [0:21];
   reg [25:0] kr4_data   [0:21];
   reg [25:0] lt_data    [0:21];

    initial begin
        // address[9:0]_mask[7:0]_data[7:0]
     an_data [0]     = 26'h 0200800;
     an_data [1]     = 26'h 0240800;
     an_data [2]     = 26'h 070C1C0;
     an_data [3]     = 26'h 0717B12;
     an_data [4]     = 26'h 0853820;
     an_data [5]     = 26'h 0860200;
     an_data [6]     = 26'h 087E080;
     an_data [7]     = 26'h 0881F08;
     an_data [8]     = 26'h 0910200;
     an_data [9]     = 26'h 0962100;
     an_data [10]    = 26'h 0A01F08;
     an_data [11]    = 26'h 0A30302;
     an_data [12]    = 26'h 0A81F02;
     an_data [13]    = 26'h 0A98080;
     an_data [14]    = 26'h 0ACE000;
     an_data [15]    = 26'h 0B22000;
     an_data [16]    = 26'h 0B30703;
     an_data [17]    = 26'h 0C26000;
     an_data [18]    = 26'h 0C40101;
     an_data [19]    = 26'h 1100706;
     an_data [20]    = 26'h 13F0F07;
          // Set CTLE to manual mode- fix CTLE to 15
     an_data [21]    = 26'h 1673F1F;
     // Set DFE to manual mode ; assumption - DFE fix taps are 0 14F to 155
     an_data [22]    = 26'h 15B0101;
     an_data [23]    = 26'h 3FFFFFF;
        // address[9:0]_mask[7:0]_data[7:0]
     fec_kr4_data [0]  = 26'h 0200808;
     fec_kr4_data [1]  = 26'h 0240808;
     fec_kr4_data [2]  = 26'h 070C141;
     fec_kr4_data [3]  = 26'h 0717B2B;
     fec_kr4_data [4]  = 26'h 0853828;
     fec_kr4_data [5]  = 26'h 0860202;
     fec_kr4_data [6]  = 26'h 087E040;
     fec_kr4_data [7]  = 26'h 0881F10;
     fec_kr4_data [8]  = 26'h 0910202;
     fec_kr4_data [9]  = 26'h 0962101;
     fec_kr4_data [10]  = 26'h 0A01F10;
     fec_kr4_data [11]  = 26'h 0A30303;
     fec_kr4_data [12]  = 26'h 0A81F07;
     fec_kr4_data [13]  = 26'h 0A98000;
     fec_kr4_data [14]  = 26'h 0ACE0A0;
     fec_kr4_data [15]  = 26'h 0B22020;
     fec_kr4_data [16]  = 26'h 0B30702;
     fec_kr4_data [17]  = 26'h 0C26060;
     fec_kr4_data [18]  = 26'h 0C40100;
     fec_kr4_data [19]  = 26'h 1100703;
     fec_kr4_data [20]  = 26'h 13F0F0E;
     fec_kr4_data [21]  = 26'h 3FFFFFF;
        // address[9:0]_mask[7:0]_data[7:0]
     gige_unused_data [0]  = 26'h 0200808;
     gige_unused_data [1]  = 26'h 0240808;
     gige_unused_data [2]  = 26'h 070C141;
     gige_unused_data [3]  = 26'h 0717B2B;
     gige_unused_data [4]  = 26'h 0853828;
     gige_unused_data [5]  = 26'h 0860202;
     gige_unused_data [6]  = 26'h 087E040;
     gige_unused_data [7]  = 26'h 0881F10;
     gige_unused_data [8]  = 26'h 0910202;
     gige_unused_data [9]  = 26'h 0962101;
     gige_unused_data [10]  = 26'h 0A01F10;
     gige_unused_data [11]  = 26'h 0A30303;
     gige_unused_data [12]  = 26'h 0A81F07;
     gige_unused_data [13]  = 26'h 0A98000;
     gige_unused_data [14]  = 26'h 0ACE0A0;
     gige_unused_data [15]  = 26'h 0B22020;
     gige_unused_data [16]  = 26'h 0B30702;
     gige_unused_data [17]  = 26'h 0C26060;
     gige_unused_data [18]  = 26'h 0C40100;
     gige_unused_data [19]  = 26'h 1100703;
     gige_unused_data [20]  = 26'h 13F0F0E;
     gige_unused_data [21]  = 26'h 3FFFFFF;
        // address[9:0]_mask[7:0]_data[7:0]
     kr4_data [0]    = 26'h 0200800;
     kr4_data [1]    = 26'h 0240800;
     kr4_data [2]    = 26'h 070C140;
     kr4_data [3]    = 26'h 0717B2B;
     kr4_data [4]    = 26'h 0853828;
     kr4_data [5]    = 26'h 0860200;
     kr4_data [6]    = 26'h 087E040;
     kr4_data [7]    = 26'h 0881F0B;
     kr4_data [8]    = 26'h 0910202;
     kr4_data [9]    = 26'h 0962120;
     kr4_data [10]   = 26'h 0A01F0B;
     kr4_data [11]   = 26'h 0A30300;
     kr4_data [12]   = 26'h 0A81F07;
     kr4_data [13]   = 26'h 0A98080;
     kr4_data [14]   = 26'h 0ACE0A0;
     kr4_data [15]   = 26'h 0B22020;
     kr4_data [16]   = 26'h 0B30702;
     kr4_data [17]   = 26'h 0C26000;
     kr4_data [18]   = 26'h 0C40101;
     kr4_data [19]   = 26'h 1100706;
     kr4_data [20]   = 26'h 13F0F07;
     kr4_data [21]   = 26'h 3FFFFFF;
        // address[9:0]_mask[7:0]_data[7:0]
     lt_data [0]     = 26'h 0200800;
     lt_data [1]     = 26'h 0240800;
     lt_data [2]     = 26'h 070C1C0;
     lt_data [3]     = 26'h 0717B12;
     lt_data [4]     = 26'h 0853820;
     lt_data [5]     = 26'h 0860200;
     lt_data [6]     = 26'h 087E080;
     lt_data [7]     = 26'h 0881F04;
     lt_data [8]     = 26'h 0910200;
     lt_data [9]     = 26'h 0962120;
     lt_data [10]    = 26'h 0A01F04;
     lt_data [11]    = 26'h 0A30300;
     lt_data [12]    = 26'h 0A81F02;
     lt_data [13]    = 26'h 0A98080;
     lt_data [14]    = 26'h 0ACE000;
     lt_data [15]    = 26'h 0B22000;
     lt_data [16]    = 26'h 0B30703;
     lt_data [17]    = 26'h 0C26000;
     lt_data [18]    = 26'h 0C40101;
     lt_data [19]    = 26'h 1100702;
     lt_data [20]    = 26'h 13F0F06;
     lt_data [21]    = 26'h 3FFFFFF;
        // address[9:0]_mask[7:0]_data[7:0]
    end //initial

    // assign outputs
   wire [25:0] an_temp;
   wire [25:0] fec_kr4_temp;
   wire [25:0] gige_unused_temp;
   wire [25:0] kr4_temp;
   wire [25:0] lt_temp;

    // retreive the 26-bit word
   assign an_temp   = an_data    [pcs_data_addr];
   assign fec_kr4_temp= fec_kr4_data [pcs_data_addr];
   assign gige_unused_temp= gige_unused_data [pcs_data_addr];
   assign kr4_temp  = kr4_data   [pcs_data_addr];
   assign lt_temp   = lt_data    [pcs_data_addr];

    // mux the correct bits
    assign rcfg_addr = pcs_mode_rc[0] ? an_temp[25:16]   :
                       pcs_mode_rc[1] ? lt_temp[25:16]   :
                       pcs_mode_rc[2] ? kr4_temp[25:16]  :
                       pcs_mode_rc[3] ? gige_unused_temp[25:16] :
                       pcs_mode_rc[5] ? fec_kr4_temp[25:16] : 10'h0;

    assign rcfg_mask = pcs_mode_rc[0] ? an_temp[15:8]    :
                       pcs_mode_rc[1] ? lt_temp[15:8]    :
                       pcs_mode_rc[2] ? kr4_temp[15:8]   :
                       pcs_mode_rc[3] ? gige_unused_temp[15:8] :
                       pcs_mode_rc[5] ? fec_kr4_temp[15:8] : 8'h0;

    assign rcfg_data = pcs_mode_rc[0] ? an_temp[7:0]     :
                       pcs_mode_rc[1] ? lt_temp[7:0]     :
                       pcs_mode_rc[2] ? kr4_temp[7:0]    :
                       pcs_mode_rc[3] ? gige_unused_temp[7:0] :
                       pcs_mode_rc[5] ? fec_kr4_temp[7:0] : 8'h0;

  end  // backplane
//===========================================================================
//  Lineside mode
//===========================================================================
  else begin : lineside
    // Define Wires and Variables
   reg [25:0] fec_kr4_data [0:0];
   reg [25:0] gige_unused_data [0:0];

    initial begin
        // address[9:0]_mask[7:0]_data[7:0]
     fec_kr4_data [0]  = 26'h 3FFFFFF;
        // address[9:0]_mask[7:0]_data[7:0]
     gige_unused_data [0]  = 26'h 3FFFFFF;
        // address[9:0]_mask[7:0]_data[7:0]
    end //initial

    // assign outputs
   wire [25:0] fec_kr4_temp;
   wire [25:0] gige_unused_temp;

    // retreive the 26-bit word
   assign fec_kr4_temp= fec_kr4_data [pcs_data_addr];
   assign gige_unused_temp= gige_unused_data [pcs_data_addr];

    // mux the correct bits
    assign rcfg_addr = pcs_mode_rc[3] ? gige_unused_temp[25:16] :
                       pcs_mode_rc[2] ? fec_kr4_temp[25:16] : 10'h0;

    assign rcfg_mask = pcs_mode_rc[3] ? gige_unused_temp[15:8] :
                       pcs_mode_rc[2] ? fec_kr4_temp[15:8] : 8'h0;

    assign rcfg_data = pcs_mode_rc[3] ? gige_unused_temp[7:0] :
                       pcs_mode_rc[2] ? fec_kr4_temp[7:0] : 8'h0;


  end  // lineside
endgenerate

endmodule // alt_aeu_40_rcfg_data_fec_644
