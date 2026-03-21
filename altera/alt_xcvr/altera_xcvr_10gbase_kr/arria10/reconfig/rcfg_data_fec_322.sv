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
// For the FEC variant with a 322 MHz reference clock
//============================================================================

`timescale 1 ps / 1 ps

module rcfg_data_fec_322
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
   reg [25:0] an_data    [0:44];
   reg [25:0] fec_teng_data [0:42];
   reg [25:0] gige_data  [0:44];
   reg [25:0] lt_data    [0:42];
   reg [25:0] teng_data  [0:42];

    initial begin
        // address[9:0]_mask[7:0]_data[7:0]
     an_data [0]     = 26'h 0060703;
     an_data [1]     = 26'h 00A0302;
     an_data [2]     = 26'h 0200800;
     an_data [3]     = 26'h 0220F05;
     an_data [4]     = 26'h 024CB41;
     an_data [5]     = 26'h 02E0101;
     an_data [6]     = 26'h 02F0100;
     an_data [7]     = 26'h 0302828;
     an_data [8]     = 26'h 0310400;
     an_data [9]     = 26'h 0330702;
     an_data [10]    = 26'h 038FF00;
     an_data [11]    = 26'h 04A1000;
     an_data [12]    = 26'h 04D0505;
     an_data [13]    = 26'h 051C0C0;
     an_data [14]    = 26'h 0700F0E;
     an_data [15]    = 26'h 0863301;
     an_data [16]    = 26'h 087E783;
     an_data [17]    = 26'h 0881F08;
     an_data [18]    = 26'h 08DC444;
     an_data [19]    = 26'h 0900202;
     an_data [20]    = 26'h 096EF4E;
     an_data [21]    = 26'h 0A01F08;
     an_data [22]    = 26'h 0A2BB03;
     an_data [23]    = 26'h 0A30B0A;
     an_data [24]    = 26'h 0A98080;
     an_data [25]    = 26'h 0ACE200;
     an_data [26]    = 26'h 0B00202;
     an_data [27]    = 26'h 0B10602;
     an_data [28]    = 26'h 0B22000;
     an_data [29]    = 26'h 0B30703;
     an_data [30]    = 26'h 0C22000;
     an_data [31]    = 26'h 0C40101;
     an_data [32]    = 26'h 0C50101;
     an_data [33]    = 26'h 0C70101;
     an_data [34]    = 26'h 1100706;
     an_data [35]    = 26'h 1350302;
     an_data [36]    = 26'h 1360F0E;
     an_data [37]    = 26'h 1377C40;
     an_data [38]    = 26'h 1390704;
     an_data [39]    = 26'h 13A3818;
     an_data [40]    = 26'h 13BFF10;
     an_data [41]    = 26'h 13F0F07;
     // Set CTLE to manual mode- fix CTLE to 15
     an_data [42]    = 26'h 1673F1F;
     // Set DFE to manual mode ; assumption - DFE fix taps are 0 14F to 155
     an_data [43]    = 26'h 15B0101;
     an_data [44]    = 26'h 3FFFFFF;
        // address[9:0]_mask[7:0]_data[7:0]
     fec_teng_data [0]  = 26'h 0060703;
     fec_teng_data [1]  = 26'h 00A0302;
     fec_teng_data [2]  = 26'h 0200808;
     fec_teng_data [3]  = 26'h 0220F05;
     fec_teng_data [4]  = 26'h 024CB49;
     fec_teng_data [5]  = 26'h 02E0101;
     fec_teng_data [6]  = 26'h 02F0100;
     fec_teng_data [7]  = 26'h 0302828;
     fec_teng_data [8]  = 26'h 0310400;
     fec_teng_data [9]  = 26'h 0330702;
     fec_teng_data [10]  = 26'h 038FF00;
     fec_teng_data [11]  = 26'h 04A1000;
     fec_teng_data [12]  = 26'h 04D0505;
     fec_teng_data [13]  = 26'h 051C0C0;
     fec_teng_data [14]  = 26'h 0700F01;
     fec_teng_data [15]  = 26'h 0863333;
     fec_teng_data [16]  = 26'h 087E783;
     fec_teng_data [17]  = 26'h 0881F10;
     fec_teng_data [18]  = 26'h 08DC440;
     fec_teng_data [19]  = 26'h 0900202;
     fec_teng_data [20]  = 26'h 096EF81;
     fec_teng_data [21]  = 26'h 0A01F10;
     fec_teng_data [22]  = 26'h 0A2BBBB;
     fec_teng_data [23]  = 26'h 0A30B0B;
     fec_teng_data [24]  = 26'h 0A98000;
     fec_teng_data [25]  = 26'h 0ACE240;
     fec_teng_data [26]  = 26'h 0B00202;
     fec_teng_data [27]  = 26'h 0B10602;
     fec_teng_data [28]  = 26'h 0B22020;
     fec_teng_data [29]  = 26'h 0B30702;
     fec_teng_data [30]  = 26'h 0C22020;
     fec_teng_data [31]  = 26'h 0C40100;
     fec_teng_data [32]  = 26'h 0C50101;
     fec_teng_data [33]  = 26'h 0C70101;
     fec_teng_data [34]  = 26'h 1100703;
     fec_teng_data [35]  = 26'h 1350302;
     fec_teng_data [36]  = 26'h 1360F0E;
     fec_teng_data [37]  = 26'h 1377C40;
     fec_teng_data [38]  = 26'h 1390704;
     fec_teng_data [39]  = 26'h 13A3818;
     fec_teng_data [40]  = 26'h 13BFF10;
     fec_teng_data [41]  = 26'h 13F0F0E;
     fec_teng_data [42]  = 26'h 3FFFFFF;
        // address[9:0]_mask[7:0]_data[7:0]
     gige_data [0]   = 26'h 0060702;
     gige_data [1]   = 26'h 00A0301;
     gige_data [2]   = 26'h 0200800;
     gige_data [3]   = 26'h 0220F00;
     gige_data [4]   = 26'h 024CB00;
     gige_data [5]   = 26'h 02E0100;
     gige_data [6]   = 26'h 02F0101;
     gige_data [7]   = 26'h 0302800;
     gige_data [8]   = 26'h 0310404;
     gige_data [9]   = 26'h 0330700;
     gige_data [10]  = 26'h 038FF7C;
     gige_data [11]  = 26'h 04A1010;
     gige_data [12]  = 26'h 04D0500;
     gige_data [13]  = 26'h 051C000;
     gige_data [14]  = 26'h 0700F0E;
     gige_data [15]  = 26'h 0863300;
     gige_data [16]  = 26'h 087E740;
     gige_data [17]  = 26'h 0881F15;
     gige_data [18]  = 26'h 08DC404;
     gige_data [19]  = 26'h 0900202;
     gige_data [20]  = 26'h 096EF4E;
     gige_data [21]  = 26'h 0A01F15;
     gige_data [22]  = 26'h 0A2BB00;
     gige_data [23]  = 26'h 0A30B00;
     gige_data [24]  = 26'h 0A98080;
     gige_data [25]  = 26'h 0ACE200;
     gige_data [26]  = 26'h 0B00202;
     gige_data [27]  = 26'h 0B10600;
     gige_data [28]  = 26'h 0B22020;
     gige_data [29]  = 26'h 0B30702;
     gige_data [30]  = 26'h 0C22000;
     gige_data [31]  = 26'h 0C40101;
     gige_data [32]  = 26'h 0C50100;
     gige_data [33]  = 26'h 0C70100;
     gige_data [34]  = 26'h 1100704;
     gige_data [35]  = 26'h 1350303;
     gige_data [36]  = 26'h 1360F05;
     gige_data [37]  = 26'h 1377C14;
     gige_data [38]  = 26'h 1390701;
     gige_data [39]  = 26'h 13A3828;
     gige_data [40]  = 26'h 13BFF14;
     gige_data [41]  = 26'h 13F0F01;
        // Set CTLE to manual mode 
     gige_data [42]  = 26'h 1670101;
     // Set DFE to manual mode ; assumption - DFE fix taps are 0 14F to 155
     gige_data [43]  = 26'h 15B0101;
     gige_data [44]  = 26'h 3FFFFFF;
        // address[9:0]_mask[7:0]_data[7:0]
     lt_data [0]     = 26'h 0060703;
     lt_data [1]     = 26'h 00A0302;
     lt_data [2]     = 26'h 0200800;
     lt_data [3]     = 26'h 0220F05;
     lt_data [4]     = 26'h 024CB41;
     lt_data [5]     = 26'h 02E0101;
     lt_data [6]     = 26'h 02F0100;
     lt_data [7]     = 26'h 0302828;
     lt_data [8]     = 26'h 0310400;
     lt_data [9]     = 26'h 0330702;
     lt_data [10]    = 26'h 038FF00;
     lt_data [11]    = 26'h 04A1000;
     lt_data [12]    = 26'h 04D0505;
     lt_data [13]    = 26'h 051C0C0;
     lt_data [14]    = 26'h 0700F0E;
     lt_data [15]    = 26'h 0863301;
     lt_data [16]    = 26'h 087E783;
     lt_data [17]    = 26'h 0881F04;
     lt_data [18]    = 26'h 08DC444;
     lt_data [19]    = 26'h 0900202;
     lt_data [20]    = 26'h 096EF6E;
     lt_data [21]    = 26'h 0A01F04;
     lt_data [22]    = 26'h 0A2BB03;
     lt_data [23]    = 26'h 0A30B08;
     lt_data [24]    = 26'h 0A98080;
     lt_data [25]    = 26'h 0ACE200;
     lt_data [26]    = 26'h 0B00202;
     lt_data [27]    = 26'h 0B10602;
     lt_data [28]    = 26'h 0B22000;
     lt_data [29]    = 26'h 0B30703;
     lt_data [30]    = 26'h 0C22000;
     lt_data [31]    = 26'h 0C40101;
     lt_data [32]    = 26'h 0C50101;
     lt_data [33]    = 26'h 0C70101;
     lt_data [34]    = 26'h 1100702;
     lt_data [35]    = 26'h 1350302;
     lt_data [36]    = 26'h 1360F0E;
     lt_data [37]    = 26'h 1377C40;
     lt_data [38]    = 26'h 1390704;
     lt_data [39]    = 26'h 13A3818;
     lt_data [40]    = 26'h 13BFF10;
     lt_data [41]    = 26'h 13F0F06;
     lt_data [42]    = 26'h 3FFFFFF;
        // address[9:0]_mask[7:0]_data[7:0]
     teng_data [0]   = 26'h 0060703;
     teng_data [1]   = 26'h 00A0302;
     teng_data [2]   = 26'h 0200800;
     teng_data [3]   = 26'h 0220F05;
     teng_data [4]   = 26'h 024CB41;
     teng_data [5]   = 26'h 02E0101;
     teng_data [6]   = 26'h 02F0100;
     teng_data [7]   = 26'h 0302828;
     teng_data [8]   = 26'h 0310400;
     teng_data [9]   = 26'h 0330702;
     teng_data [10]  = 26'h 038FF00;
     teng_data [11]  = 26'h 04A1000;
     teng_data [12]  = 26'h 04D0505;
     teng_data [13]  = 26'h 051C0C0;
     teng_data [14]  = 26'h 0700F00;
     teng_data [15]  = 26'h 0863331;
     teng_data [16]  = 26'h 087E787;
     teng_data [17]  = 26'h 0881F08;
     teng_data [18]  = 26'h 08DC440;
     teng_data [19]  = 26'h 0900200;
     teng_data [20]  = 26'h 096EF80;
     teng_data [21]  = 26'h 0A01F08;
     teng_data [22]  = 26'h 0A2BBBB;
     teng_data [23]  = 26'h 0A30B0A;
     teng_data [24]  = 26'h 0A98000;
     teng_data [25]  = 26'h 0ACE242;
     teng_data [26]  = 26'h 0B00200;
     teng_data [27]  = 26'h 0B10602;
     teng_data [28]  = 26'h 0B22020;
     teng_data [29]  = 26'h 0B30702;
     teng_data [30]  = 26'h 0C22000;
     teng_data [31]  = 26'h 0C40101;
     teng_data [32]  = 26'h 0C50101;
     teng_data [33]  = 26'h 0C70101;
     teng_data [34]  = 26'h 1100706;
     teng_data [35]  = 26'h 1350302;
     teng_data [36]  = 26'h 1360F0E;
     teng_data [37]  = 26'h 1377C40;
     teng_data [38]  = 26'h 1390704;
     teng_data [39]  = 26'h 13A3818;
     teng_data [40]  = 26'h 13BFF10;
     teng_data [41]  = 26'h 13F0F07;
     teng_data [42]  = 26'h 3FFFFFF;
        // address[9:0]_mask[7:0]_data[7:0]
    end //initial

    // assign outputs
   wire [25:0] an_temp;
   wire [25:0] fec_teng_temp;
   wire [25:0] gige_temp;
   wire [25:0] lt_temp;
   wire [25:0] teng_temp;

    // retreive the 26-bit word
   assign an_temp   = an_data    [pcs_data_addr];
   assign fec_teng_temp= fec_teng_data [pcs_data_addr];
   assign gige_temp = gige_data  [pcs_data_addr];
   assign lt_temp   = lt_data    [pcs_data_addr];
   assign teng_temp = teng_data  [pcs_data_addr];

    // mux the correct bits
    assign rcfg_addr = pcs_mode_rc[0] ? an_temp[25:16]   :
                       pcs_mode_rc[1] ? lt_temp[25:16]   :
                       pcs_mode_rc[2] ? teng_temp[25:16] :
                       pcs_mode_rc[3] ? gige_temp[25:16] :
                       pcs_mode_rc[5] ? fec_teng_temp[25:16] : 10'h0;

    assign rcfg_mask = pcs_mode_rc[0] ? an_temp[15:8]    :
                       pcs_mode_rc[1] ? lt_temp[15:8]    :
                       pcs_mode_rc[2] ? teng_temp[15:8]  :
                       pcs_mode_rc[3] ? gige_temp[15:8]  :
                       pcs_mode_rc[5] ? fec_teng_temp[15:8] : 8'h0;

    assign rcfg_data = pcs_mode_rc[0] ? an_temp[7:0]     :
                       pcs_mode_rc[1] ? lt_temp[7:0]     :
                       pcs_mode_rc[2] ? teng_temp[7:0]   :
                       pcs_mode_rc[3] ? gige_temp[7:0]   :
                       pcs_mode_rc[5] ? fec_teng_temp[7:0] : 8'h0;

  end  // backplane
//===========================================================================
//  Lineside mode
//===========================================================================
  else begin : lineside
    // Define Wires and Variables
   reg [25:0] fec_teng_data [0:38];
   reg [25:0] gige_data  [0:38];

    initial begin
        // address[9:0]_mask[7:0]_data[7:0]
     fec_teng_data [0]  = 26'h 0060703;
     fec_teng_data [1]  = 26'h 00A0302;
     fec_teng_data [2]  = 26'h 0200808;
     fec_teng_data [3]  = 26'h 0220F05;
     fec_teng_data [4]  = 26'h 024CB49;
     fec_teng_data [5]  = 26'h 02E0101;
     fec_teng_data [6]  = 26'h 02F0100;
     fec_teng_data [7]  = 26'h 0302828;
     fec_teng_data [8]  = 26'h 0310400;
     fec_teng_data [9]  = 26'h 0330702;
     fec_teng_data [10]  = 26'h 038FF00;
     fec_teng_data [11]  = 26'h 04A1000;
     fec_teng_data [12]  = 26'h 04D0505;
     fec_teng_data [13]  = 26'h 051C0C0;
     fec_teng_data [14]  = 26'h 0700F01;
     fec_teng_data [15]  = 26'h 0863333;
     fec_teng_data [16]  = 26'h 087E383;
     fec_teng_data [17]  = 26'h 0880700;
     fec_teng_data [18]  = 26'h 08DC440;
     fec_teng_data [19]  = 26'h 096CF81;
     fec_teng_data [20]  = 26'h 0A00700;
     fec_teng_data [21]  = 26'h 0A2BBBB;
     fec_teng_data [22]  = 26'h 0A30B0B;
     fec_teng_data [23]  = 26'h 0A98000;
     fec_teng_data [24]  = 26'h 0ACE040;
     fec_teng_data [25]  = 26'h 0B10602;
     fec_teng_data [26]  = 26'h 0C22020;
     fec_teng_data [27]  = 26'h 0C40100;
     fec_teng_data [28]  = 26'h 0C50101;
     fec_teng_data [29]  = 26'h 0C70101;
     fec_teng_data [30]  = 26'h 1100703;
     fec_teng_data [31]  = 26'h 1350302;
     fec_teng_data [32]  = 26'h 1360F0E;
     fec_teng_data [33]  = 26'h 1377C40;
     fec_teng_data [34]  = 26'h 1390704;
     fec_teng_data [35]  = 26'h 13A3818;
     fec_teng_data [36]  = 26'h 13BFF10;
     fec_teng_data [37]  = 26'h 13F0F0E;
     fec_teng_data [38]  = 26'h 3FFFFFF;
        // address[9:0]_mask[7:0]_data[7:0]
     gige_data [0]   = 26'h 0060702;
     gige_data [1]   = 26'h 00A0301;
     gige_data [2]   = 26'h 0200800;
     gige_data [3]   = 26'h 0220F00;
     gige_data [4]   = 26'h 024CB00;
     gige_data [5]   = 26'h 02E0100;
     gige_data [6]   = 26'h 02F0101;
     gige_data [7]   = 26'h 0302800;
     gige_data [8]   = 26'h 0310404;
     gige_data [9]   = 26'h 0330700;
     gige_data [10]  = 26'h 038FF7C;
     gige_data [11]  = 26'h 04A1010;
     gige_data [12]  = 26'h 04D0500;
     gige_data [13]  = 26'h 051C000;
     gige_data [14]  = 26'h 0700F0E;
     gige_data [15]  = 26'h 0863300;
     gige_data [16]  = 26'h 087E340;
     gige_data [17]  = 26'h 0880705;
     gige_data [18]  = 26'h 08DC404;
     gige_data [19]  = 26'h 096CF4E;
     gige_data [20]  = 26'h 0A00705;
     gige_data [21]  = 26'h 0A2BB00;
     gige_data [22]  = 26'h 0A30B00;
     gige_data [23]  = 26'h 0A98080;
     gige_data [24]  = 26'h 0ACE000;
     gige_data [25]  = 26'h 0B10600;
     gige_data [26]  = 26'h 0C22000;
     gige_data [27]  = 26'h 0C40101;
     gige_data [28]  = 26'h 0C50100;
     gige_data [29]  = 26'h 0C70100;
     gige_data [30]  = 26'h 1100704;
     gige_data [31]  = 26'h 1350303;
     gige_data [32]  = 26'h 1360F05;
     gige_data [33]  = 26'h 1377C14;
     gige_data [34]  = 26'h 1390701;
     gige_data [35]  = 26'h 13A3828;
     gige_data [36]  = 26'h 13BFF14;
     gige_data [37]  = 26'h 13F0F01;
     gige_data [38]  = 26'h 3FFFFFF;
        // address[9:0]_mask[7:0]_data[7:0]
    end //initial

    // assign outputs
   wire [25:0] fec_teng_temp;
   wire [25:0] gige_temp;

    // retreive the 26-bit word
   assign fec_teng_temp= fec_teng_data [pcs_data_addr];
   assign gige_temp = gige_data  [pcs_data_addr];

    // mux the correct bits
    assign rcfg_addr = pcs_mode_rc[3] ? gige_temp[25:16] :
                       pcs_mode_rc[2] ? fec_teng_temp[25:16] : 10'h0;

    assign rcfg_mask = pcs_mode_rc[3] ? gige_temp[15:8]  :
                       pcs_mode_rc[2] ? fec_teng_temp[15:8] : 8'h0;

    assign rcfg_data = pcs_mode_rc[3] ? gige_temp[7:0]   :
                       pcs_mode_rc[2] ? fec_teng_temp[7:0] : 8'h0;


  end  // lineside
endgenerate

endmodule // rcfg_data_fec_322
