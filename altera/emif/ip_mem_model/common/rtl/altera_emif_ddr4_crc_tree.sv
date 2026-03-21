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



module altera_emif_ddr4_crc_tree (
        d,
        newcrc 

);
timeunit 1ps;
timeprecision 1ps;

input [71:0] d;
output [7:0] newcrc;

assign newcrc[0] = d[69] ^ d[68] ^ d[67] ^ d[66] ^ d[64] ^ d[63] ^ d[60] ^
                   d[56] ^ d[54] ^ d[53] ^ d[52] ^ d[50] ^ d[49] ^ d[48] ^
                   d[45] ^ d[43] ^ d[40] ^ d[39] ^ d[35] ^ d[34] ^ d[31] ^
                   d[30] ^ d[28] ^ d[23] ^ d[21] ^ d[19] ^ d[18] ^ d[16] ^
                   d[14] ^ d[12] ^ d[8] ^ d[7] ^ d[6] ^ d[0] ;
assign newcrc[1] = d[70] ^ d[66] ^ d[65] ^ d[63] ^ d[61] ^ d[60] ^ d[57] ^
                   d[56] ^ d[55] ^ d[52] ^ d[51] ^ d[48] ^ d[46] ^ d[45] ^
                   d[44] ^ d[43] ^ d[41] ^ d[39] ^ d[36] ^ d[34] ^ d[32] ^
                   d[30] ^ d[29] ^ d[28] ^ d[24] ^ d[23] ^ d[22] ^ d[21] ^
                   d[20] ^ d[18] ^ d[17] ^ d[16] ^ d[15] ^ d[14] ^ d[13] ^
                   d[12] ^ d[9] ^ d[6] ^ d[1] ^ d[0];
assign newcrc[2] = d[71] ^ d[69] ^ d[68] ^ d[63] ^ d[62] ^ d[61] ^ d[60] ^
                   d[58] ^ d[57] ^ d[54] ^ d[50] ^ d[48] ^ d[47] ^ d[46] ^
                   d[44] ^ d[43] ^ d[42] ^ d[39] ^ d[37] ^ d[34] ^ d[33] ^
                   d[29] ^ d[28] ^ d[25] ^ d[24] ^ d[22] ^ d[17] ^ d[15] ^
                   d[13] ^ d[12] ^ d[10] ^ d[8] ^ d[6] ^ d[2] ^ d[1] ^ d[0];
assign newcrc[3] = d[70] ^ d[69] ^ d[64] ^ d[63] ^ d[62] ^ d[61] ^ d[59] ^
                   d[58] ^ d[55] ^ d[51] ^ d[49] ^ d[48] ^ d[47] ^ d[45] ^
                   d[44] ^ d[43] ^ d[40] ^ d[38] ^ d[35] ^ d[34] ^ d[30] ^
                   d[29] ^ d[26] ^ d[25] ^ d[23] ^ d[18] ^ d[16] ^ d[14] ^
                   d[13] ^ d[11] ^ d[9] ^ d[7] ^ d[3] ^ d[2] ^ d[1];
assign newcrc[4] = d[71] ^ d[70] ^ d[65] ^ d[64] ^ d[63] ^ d[62] ^ d[60] ^
                   d[59] ^ d[56] ^ d[52] ^ d[50] ^ d[49] ^ d[48] ^ d[46] ^
                   d[45] ^ d[44] ^ d[41] ^ d[39] ^ d[36] ^ d[35] ^ d[31] ^
                   d[30] ^ d[27] ^ d[26] ^ d[24] ^ d[19] ^ d[17] ^ d[15] ^
                   d[14] ^ d[12] ^ d[10] ^ d[8] ^ d[4] ^ d[3] ^ d[2];
assign newcrc[5] = d[71] ^ d[66] ^ d[65] ^ d[64] ^ d[63] ^ d[61] ^ d[60] ^
                   d[57] ^ d[53] ^ d[51] ^ d[50] ^ d[49] ^ d[47] ^ d[46] ^
                   d[45] ^ d[42] ^ d[40] ^ d[37] ^ d[36] ^ d[32] ^ d[31] ^
                   d[28] ^ d[27] ^ d[25] ^ d[20] ^ d[18] ^ d[16] ^ d[15] ^
                   d[13] ^ d[11] ^ d[9] ^ d[5] ^ d[4] ^ d[3];
assign newcrc[6] = d[67] ^ d[66] ^ d[65] ^ d[64] ^ d[62] ^ d[61] ^ d[58] ^
                   d[54] ^ d[52] ^ d[51] ^ d[50] ^ d[48] ^ d[47] ^ d[46] ^
                   d[43] ^ d[41] ^ d[38] ^ d[37] ^ d[33] ^ d[32] ^ d[29] ^
                   d[28] ^ d[26] ^ d[21] ^ d[19] ^ d[17] ^ d[16] ^ d[14] ^
                   d[12] ^ d[10] ^ d[6] ^ d[5] ^ d[4];
assign newcrc[7] = d[68] ^ d[67] ^ d[66] ^ d[65] ^ d[63] ^ d[62] ^ d[59] ^
                   d[55] ^ d[53] ^ d[52] ^ d[51] ^ d[49] ^ d[48] ^ d[47] ^
                   d[44] ^ d[42] ^ d[39] ^ d[38] ^ d[34] ^ d[33] ^ d[30] ^
                   d[29] ^ d[27] ^ d[22] ^ d[20] ^ d[18] ^ d[17] ^ d[15] ^
                   d[13] ^ d[11] ^ d[7] ^ d[6] ^ d[5];



endmodule 


