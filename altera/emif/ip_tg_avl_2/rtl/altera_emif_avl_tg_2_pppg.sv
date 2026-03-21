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


//-----------------------------------------------------------------------------
// Filename    : pppg.v
// Description : Pattern Generators for PRBS polynominals and deterministic
//                sequences. In deterministic mode, the per-bit
//                pattern generator produces a repeating bit pattern of length
//                corresponding to PATTERN_LENGTH parameter using series of
//                circular shift registers
//                The PRBS data is panellized such that in order to reproduce
//                the PRBS it must be serialized from MSB to LSB.
//                Deterministic data is stored and shifted to match.
//
//Illegal PRBS State: 1 in MSB, others => 0
//This additional illegal PRBS input is due to the fact that PRBS uses only n-1
//registers, while the deterministic patterns use n.
//
// Supported Patterns - PRBS-7, PRBS-15, PRBS-31, Deterministic
// Supported Output Data widths = 4, 8
//
// Copyright (c) Altera Corporation 1997-2014
// All rights reserved
//
//-----------------------------------------------------------------------------

//Each module synthesizes with a FF usage equal to the PATTERN_LENGTH + 2
//and a max LUT depth of 2


//Generates 8 bit parallel output using PRBS-7 or 8 bit deterministic sequence
module altera_emif_avl_tg_2_pppg8_8bit_parallel#(
   parameter DATA_WIDTH       = 8,
   parameter PATTERN_LENGTH   = 8,
   parameter DEFAULT_STATE    = 8'b00000001,
   parameter DEFAULT_MODE     = 1'b0
   )(
   input                       clk,
   input                       rst,
   //load enable signal to update load_data and load_mode
   input                       load,
   //PRBS seed or desired data sequence for deterministic mode
   input [PATTERN_LENGTH -1:0] load_data,
   //Data mode: 0 for prbs output, 1 for deterministic sequence based on load_data
   input                       load_mode,
   input                       load_inversion,
   input                       enable,
   output [DATA_WIDTH-1:0]     dout,
   //for configurations
   output [PATTERN_LENGTH+1:0] state_out  //unused
   );
   timeunit 1ns;
   timeprecision 1ps;

   reg                        mode;
   reg [PATTERN_LENGTH-1:0]   x;
   reg                        inversion;

   assign dout[DATA_WIDTH-1:0]    = inversion ? ~x[PATTERN_LENGTH-1:PATTERN_LENGTH-DATA_WIDTH] :
                                                x[PATTERN_LENGTH-1:PATTERN_LENGTH-DATA_WIDTH];
   assign state_out                    = {inversion,mode,x};

   always @ (posedge clk, posedge rst) begin
      if(rst) begin
         x           <= DEFAULT_STATE;
         mode        <= DEFAULT_MODE;
         inversion   <= 1'b0;
      end
      else if (load) begin
         x         <= load_data;
         mode      <= load_mode;
         inversion <= load_inversion;
      end
      else if (enable) begin
         if (mode) begin
            //deterministic mode
            //since PATTERN_LENGTH = DATA_WIDTH, just hold
            x <= x;
         end
         else begin  // prbs-7, 8 bit parallel

            x[0] <= x[4] ^ x[6];
            x[1] <= x[0] ^ x[5] ^ x[6];
            x[2] <= x[0] ^ x[1];
            x[3] <= x[1] ^ x[2];
            x[4] <= x[2] ^ x[3];
            x[5] <= x[3] ^ x[4];
            x[6] <= x[4] ^ x[5];
            x[7] <= x[5] ^ x[6];
         end
      end
   end
endmodule

//Generates 4 bit parallel output using PRBS-7 or 8 bit deterministic sequence
module altera_emif_avl_tg_2_pppg8_4bit_parallel#(
   parameter DATA_WIDTH        = 4,
   parameter PATTERN_LENGTH    = 8,
   parameter DEFAULT_STATE     = 8'b10,
   parameter DEFAULT_MODE      = 1'b0
   )(
   input                       clk,
   input                       rst,
   input                       load,
   //PRBS seed or desired data sequence for deterministic mode
   input [PATTERN_LENGTH-1:0]  load_data,
   //Data mode: 0 for prbs output, 1 for deterministic sequence based on load_data
   input                       load_mode,
   input                       load_inversion,
   input                       enable,
   output [DATA_WIDTH-1:0]     dout,
   output [PATTERN_LENGTH+1:0] state_out
   );
   timeunit 1ns;
   timeprecision 1ps;

   reg mode;
   reg [PATTERN_LENGTH-1:0]   x;
   reg inversion;

   //assign corresponding output bits
   assign dout[DATA_WIDTH-1:0]  = mode ? (inversion ? ~x[PATTERN_LENGTH-1:PATTERN_LENGTH-DATA_WIDTH] :
                                                         x[PATTERN_LENGTH-1:PATTERN_LENGTH-DATA_WIDTH]):
                                         ( inversion ? ~x[PATTERN_LENGTH-2:PATTERN_LENGTH-DATA_WIDTH-1] :
                                                         x[PATTERN_LENGTH-2:PATTERN_LENGTH-DATA_WIDTH-1]);
   assign state_out = {inversion,mode,x};

   always @ (posedge clk, posedge rst) begin
      if(rst) begin
         x           <= DEFAULT_STATE;
         mode        <= DEFAULT_MODE;
         inversion   <= 1'b0;
      end
      else if (load) begin
         x         <= load_data;
         mode      <= load_mode;
         inversion <= load_inversion;
      end
      else if (enable) begin
         if (mode) begin
            //deterministic mode
            //remapping of 8 bit sequential pattern to 4 bit parallel output for half-rate
            {x[4],x[0]} <= {x[0], x[4]};
            {x[5],x[1]} <= {x[1], x[5]};
            {x[6],x[2]} <= {x[2], x[6]};
            {x[7],x[3]} <= {x[3], x[7]};
         end
         else begin // prbs-7, 4 bit parallel

            x[0] <= x[2] ^ x[3];
            x[1] <= x[3] ^ x[4];
            x[2] <= x[4] ^ x[5];
            x[3] <= x[5] ^ x[6];
            x[4] <= x[0];
            x[5] <= x[1];
            x[6] <= x[2];
            //x[7] unused
         end
      end
   end
endmodule

//Generates 2 bit parallel output using PRBS-7 or 8 bit deterministic sequence
module altera_emif_avl_tg_2_pppg8_2bit_parallel#(
   parameter DATA_WIDTH        = 2,
   parameter PATTERN_LENGTH    = 8,
   parameter DEFAULT_STATE     = 8'b10,
   parameter DEFAULT_MODE      = 1'b0
   )(
   input                       clk,
   input                       rst,
   input                       load,
   //PRBS seed or desired data sequence for deterministic mode
   input [PATTERN_LENGTH-1:0]  load_data,
   //Data mode: 0 for prbs output, 1 for deterministic sequence based on load_data
   input                       load_mode,
   input                       load_inversion,
   input                       enable,
   output [DATA_WIDTH-1:0]     dout,
   output [PATTERN_LENGTH+1:0] state_out
   );
   timeunit 1ns;
   timeprecision 1ps;

   reg mode;
   reg [PATTERN_LENGTH-1:0]   x;
   reg inversion;

   //assign corresponding output bits
   assign dout[DATA_WIDTH-1:0]  = mode ? (inversion ? ~x[PATTERN_LENGTH-1:PATTERN_LENGTH-DATA_WIDTH] :
                                                         x[PATTERN_LENGTH-1:PATTERN_LENGTH-DATA_WIDTH]):
                                         ( inversion ? ~x[PATTERN_LENGTH-2:PATTERN_LENGTH-DATA_WIDTH-1] :
                                                         x[PATTERN_LENGTH-2:PATTERN_LENGTH-DATA_WIDTH-1]);
   assign state_out = {inversion,mode,x};

   always @ (posedge clk, posedge rst) begin
      if(rst) begin
         x           <= DEFAULT_STATE;
         mode        <= DEFAULT_MODE;
         inversion   <= 1'b0;
      end
      else if (load) begin
         x         <= load_data;
         mode      <= load_mode;
         inversion <= load_inversion;
      end
      else if (enable) begin
         if (mode) begin
            //deterministic mode
            //remapping of 8 bit sequential pattern to 2 bit parallel output for full-rate
            {x[6], x[4], x[2], x[0]} <= {x[4], x[2], x[0], x[6]};
            {x[7], x[5], x[3], x[1]} <= {x[5], x[3], x[1], x[7]};
         end
         else begin // prbs-7, 2 bit parallel

            x[0] <= x[4] ^ x[5];
            x[1] <= x[5] ^ x[6];
            x[2] <= x[0];
            x[3] <= x[1];
            x[4] <= x[2];
            x[5] <= x[3];
            x[6] <= x[4];
            //x[7] unused
         end
      end
   end
endmodule


//Generates 8 bit parallel output using PRBS-15 or 16 bit deterministic sequence
module altera_emif_avl_tg_2_pppg16_8bit_parallel#(
   parameter DATA_WIDTH        = 8,
   parameter PATTERN_LENGTH    = 16,
   parameter DEFAULT_STATE     = 16'b10,
   parameter DEFAULT_MODE      = 1'b0
   )(
   input                       clk,
   input                       rst,
   input                       load,
   //PRBS seed or desired data sequence for deterministic mode
   input [PATTERN_LENGTH-1:0]  load_data,
   //Data mode: 0 for prbs output, 1 for deterministic sequence based on load_data
   input                       load_mode,
   input                       load_inversion,
   input                       enable,
   output [DATA_WIDTH-1:0]     dout,
   output [PATTERN_LENGTH+1:0] state_out
   );
   timeunit 1ns;
   timeprecision 1ps;

   reg mode;
   reg [PATTERN_LENGTH-1:0]   x;
   reg inversion;

   //assign corresponding output bits
   assign dout[DATA_WIDTH-1:0]  = mode ? (inversion ? ~x[PATTERN_LENGTH-1:PATTERN_LENGTH-DATA_WIDTH] :
                                                         x[PATTERN_LENGTH-1:PATTERN_LENGTH-DATA_WIDTH]):
                                         ( inversion ? ~x[PATTERN_LENGTH-2:PATTERN_LENGTH-DATA_WIDTH-1] :
                                                         x[PATTERN_LENGTH-2:PATTERN_LENGTH-DATA_WIDTH-1]);
   assign state_out = {inversion,mode,x};

   always @ (posedge clk, posedge rst) begin
      if(rst) begin
         x         <= DEFAULT_STATE;
         mode      <= DEFAULT_MODE;
         inversion <= 1'b0;
      end
      else if (load) begin
         x         <= load_data;
         mode      <= load_mode;
         inversion <= load_inversion;
      end
      else if (enable) begin
         if (mode) begin
            //deterministic mode
            //remapping of 16 bit sequential pattern to 8 bit parallel output for quarter-rate
            {x[8],x[0]}  <= {x[0],x[8]};
            {x[9],x[1]}  <= {x[1],x[9]};
            {x[10],x[2]} <= {x[2],x[10]};
            {x[11],x[3]} <= {x[3],x[11]};
            {x[12],x[4]} <= {x[4],x[12]};
            {x[13],x[5]} <= {x[5],x[13]};
            {x[14],x[6]} <= {x[6],x[14]};
            {x[15],x[7]} <= {x[7],x[15]};
         end
         else begin // prbs-15, 8 bit parallel

            x[0]  <= x[6] ^ x[7];
            x[1]  <= x[7] ^ x[8];
            x[2]  <= x[8] ^ x[9];
            x[3]  <= x[9] ^ x[10];
            x[4]  <= x[10] ^ x[11];
            x[5]  <= x[11] ^ x[12];
            x[6]  <= x[12] ^ x[13];
            x[7]  <= x[13] ^ x[14];
            x[8]  <= x[0];
            x[9]  <= x[1];
            x[10] <= x[2];
            x[11] <= x[3];
            x[12] <= x[4];
            x[13] <= x[5];
            x[14] <= x[6];
         end
      end
   end
endmodule



//Generates 4 bit parallel output using PRBS-15 or 16 bit deterministic sequence
module altera_emif_avl_tg_2_pppg16_4bit_parallel#(
   parameter DATA_WIDTH        = 4,
   parameter PATTERN_LENGTH    = 16,
   parameter DEFAULT_STATE     = 16'b10,
   parameter DEFAULT_MODE      = 1'b0
   )(
   input                       clk,
   input                       rst,
   input                       load,
   //PRBS seed or desired data sequence for deterministic mode
   input [PATTERN_LENGTH-1:0]  load_data,
   //Data mode: 0 for prbs output, 1 for deterministic sequence based on load_data
   input                       load_mode,
   input                       load_inversion,
   input                       enable,
   output [DATA_WIDTH-1:0]     dout,
   output [PATTERN_LENGTH+1:0] state_out
   );
   timeunit 1ns;
   timeprecision 1ps;

   reg mode;
   reg [PATTERN_LENGTH-1:0]   x;
   reg inversion;
   //assign corresponding output bits
   assign dout[DATA_WIDTH-1:0]  = mode ? (inversion ? ~x[PATTERN_LENGTH-1:PATTERN_LENGTH-DATA_WIDTH] :
                                                         x[PATTERN_LENGTH-1:PATTERN_LENGTH-DATA_WIDTH]):
                                         ( inversion ? ~x[PATTERN_LENGTH-2:PATTERN_LENGTH-DATA_WIDTH-1] :
                                                         x[PATTERN_LENGTH-2:PATTERN_LENGTH-DATA_WIDTH-1]);
   assign state_out = {inversion,mode,x};

   always @ (posedge clk, posedge rst) begin
      if(rst) begin
         x         <= DEFAULT_STATE;
         mode      <= DEFAULT_MODE;
         inversion <= 1'b0;
      end
      else if (load) begin
         x         <= load_data;
         mode      <= load_mode;
         inversion <= load_inversion;
      end
      else if (enable) begin
         if (mode) begin
            //deterministic mode
            //remapping of 8 bit sequential pattern to 4 bit parallel output for half-rate
            {x[12],x[8],x[4],x[0]}  <= {x[8],x[4],x[0],x[12]};
            {x[13],x[9],x[5],x[1]}  <= {x[9],x[5],x[1],x[13]};
            {x[14],x[10],x[6],x[2]} <= {x[10],x[6],x[2],x[14]};
            {x[15],x[11],x[7],x[3]} <= {x[11],x[7],x[3],x[15]};

         end
         else begin // prbs-15, 4 bit parallel

            x[0]  <= x[10] ^ x[11];
            x[1]  <= x[11] ^ x[12];
            x[2]  <= x[12] ^ x[13];
            x[3]  <= x[13] ^ x[14];
            x[4]  <= x[0];
            x[5]  <= x[1];
            x[6]  <= x[2];
            x[7]  <= x[3];
            x[8]  <= x[4];
            x[9]  <= x[5];
            x[10] <= x[6];
            x[11] <= x[7];
            x[12] <= x[8];
            x[13] <= x[9];
            x[14] <= x[10];
         end
      end
   end
endmodule

//Generates 2 bit parallel output using PRBS-15 or 16 bit deterministic sequence
module altera_emif_avl_tg_2_pppg16_2bit_parallel#(
   parameter DATA_WIDTH        = 2,
   parameter PATTERN_LENGTH    = 16,
   parameter DEFAULT_STATE     = 16'b10,
   parameter DEFAULT_MODE      = 1'b0
   )(
   input                       clk,
   input                       rst,
   input                       load,
   //PRBS seed or desired data sequence for deterministic mode
   input [PATTERN_LENGTH-1:0]  load_data,
   //Data mode: 0 for prbs output, 1 for deterministic sequence based on load_data
   input                       load_mode,
   input                       load_inversion,
   input                       enable,
   output [DATA_WIDTH-1:0]     dout,
   output [PATTERN_LENGTH+1:0] state_out
   );
   timeunit 1ns;
   timeprecision 1ps;

   reg mode;
   reg [PATTERN_LENGTH-1:0]   x;
   reg inversion;
   //assign corresponding output bits
   assign dout[DATA_WIDTH-1:0]  = mode ? (inversion ? ~x[PATTERN_LENGTH-1:PATTERN_LENGTH-DATA_WIDTH] :
                                                         x[PATTERN_LENGTH-1:PATTERN_LENGTH-DATA_WIDTH]):
                                         ( inversion ? ~x[PATTERN_LENGTH-2:PATTERN_LENGTH-DATA_WIDTH-1] :
                                                         x[PATTERN_LENGTH-2:PATTERN_LENGTH-DATA_WIDTH-1]);
   assign state_out = {inversion,mode,x};

   always @ (posedge clk, posedge rst) begin
      if(rst) begin
         x         <= DEFAULT_STATE;
         mode      <= DEFAULT_MODE;
         inversion <= 1'b0;
      end
      else if (load) begin
         x         <= load_data;
         mode      <= load_mode;
         inversion <= load_inversion;
      end
      else if (enable) begin
         if (mode) begin
            //deterministic mode
            //remapping of 8 bit sequential pattern to 2 bit parallel output for full-rate
            {x[14],x[12],x[10],x[8],x[6],x[4],x[2],x[0]} <= {x[12],x[10],x[8],x[6],x[4],x[2],x[0],x[14]};
            {x[15],x[13],x[11],x[9],x[7],x[5],x[3],x[1]} <= {x[13],x[11],x[9],x[7],x[5],x[3],x[1],x[15]};
         end
         else begin // prbs-15, 2 bit parallel
            x[0]  <= x[12] ^ x[13];
            x[1]  <= x[13] ^ x[14];
            x[2]  <= x[0];
            x[3]  <= x[1];
            x[4]  <= x[2];
            x[5]  <= x[3];
            x[6]  <= x[4];
            x[7]  <= x[5];
            x[8]  <= x[6];
            x[9]  <= x[7];
            x[10] <= x[8];
            x[11] <= x[9];
            x[12] <= x[10];
            x[13] <= x[11];
            x[14] <= x[12];
         end
      end
   end
endmodule


//Generates 8 bit parallel output using PRBS-31 or 32 bit deterministic sequence
module altera_emif_avl_tg_2_pppg32_8bit_parallel#(
   parameter DATA_WIDTH        = 8,
   parameter PATTERN_LENGTH    = 32,
   parameter DEFAULT_STATE     = 32'b10,
   parameter DEFAULT_MODE      = 1'b0
   )(
   input                       clk,
   input                       rst,
   input                       load,
   //PRBS seed or desired data sequence for deterministic mode
   input [PATTERN_LENGTH-1:0]  load_data,
   //Data mode: 0 for prbs output, 1 for deterministic sequence based on load_data
   input                       load_mode,
   input                       load_inversion,
   input                       enable,
   output [DATA_WIDTH-1:0]     dout,
   output [PATTERN_LENGTH+1:0] state_out
   );
   timeunit 1ns;
   timeprecision 1ps;

   reg mode;
   reg [PATTERN_LENGTH-1:0]   x;
   reg inversion;
   //assign corresponding output bits
   assign dout[DATA_WIDTH-1:0]  = mode ? (inversion ? ~x[PATTERN_LENGTH-1:PATTERN_LENGTH-DATA_WIDTH] :
                                                         x[PATTERN_LENGTH-1:PATTERN_LENGTH-DATA_WIDTH]):
                                         ( inversion ? ~x[PATTERN_LENGTH-2:PATTERN_LENGTH-DATA_WIDTH-1] :
                                                         x[PATTERN_LENGTH-2:PATTERN_LENGTH-DATA_WIDTH-1]);
   assign state_out = {inversion,mode,x};

   always @ (posedge clk, posedge rst) begin
      if(rst) begin
         x         <= DEFAULT_STATE;
         mode      <= DEFAULT_MODE;
         inversion <= 1'b0;
      end
      else if (load) begin
         x         <= load_data;
         mode      <= load_mode;
         inversion <= load_inversion;
      end
      else if (enable) begin
         if (mode) begin
            //deterministic mode
            //remapping of 32 bit sequential pattern to 8 bit parallel output for quarter-rate
            {x[24],x[16],x[8],x[0]}  <= {x[16],x[8],x[0],x[24]};
            {x[25],x[17],x[9],x[1]}  <= {x[17],x[9],x[1],x[25]};
            {x[26],x[18],x[10],x[2]} <= {x[18],x[10],x[2],x[26]};
            {x[27],x[19],x[11],x[3]} <= {x[19],x[11],x[3],x[27]};
            {x[28],x[20],x[12],x[4]} <= {x[20],x[12],x[4],x[28]};
            {x[29],x[21],x[13],x[5]} <= {x[21],x[13],x[5],x[29]};
            {x[30],x[22],x[14],x[6]} <= {x[22],x[14],x[6],x[30]};
            {x[31],x[23],x[15],x[7]} <= {x[23],x[15],x[7],x[31]};

         end
         else begin // prbs-31, 8 bit parallel

            x[0]  <= x[20] ^ x[23];
            x[1]  <= x[21] ^ x[24];
            x[2]  <= x[22] ^ x[25];
            x[3]  <= x[23] ^ x[26];
            x[4]  <= x[24] ^ x[27];
            x[5]  <= x[25] ^ x[28];
            x[6]  <= x[26] ^ x[29];
            x[7]  <= x[27] ^ x[30];
            x[8]  <= x[0];
            x[9]  <= x[1];
            x[10] <= x[2];
            x[11] <= x[3];
            x[12] <= x[4];
            x[13] <= x[5];
            x[14] <= x[6];
            x[15] <= x[7];
            x[16] <= x[8];
            x[17] <= x[9];
            x[18] <= x[10];
            x[19] <= x[11];
            x[20] <= x[12];
            x[21] <= x[13];
            x[22] <= x[14];
            x[23] <= x[15];
            x[24] <= x[16];
            x[25] <= x[17];
            x[26] <= x[18];
            x[27] <= x[19];
            x[28] <= x[20];
            x[29] <= x[21];
            x[30] <= x[22];
         end
      end
   end
endmodule

//Generates 4 bit parallel output using PRBS-31 or 32 bit deterministic sequence
module altera_emif_avl_tg_2_pppg32_4bit_parallel#(
   parameter DATA_WIDTH        = 4,
   parameter PATTERN_LENGTH    = 32,
   parameter DEFAULT_STATE     = 32'b10,
   parameter DEFAULT_MODE      = 1'b0
   )(
   input                       clk,
   input                       rst,
   input                       load,
   //PRBS seed or desired data sequence for deterministic mode
   input [PATTERN_LENGTH-1:0]  load_data,
   //Data mode: 0 for prbs output, 1 for deterministic sequence based on load_data
   input                       load_mode,
   input                       load_inversion,
   input                       enable,
   output [DATA_WIDTH-1:0]     dout,
   output [PATTERN_LENGTH+1:0] state_out
   );
   timeunit 1ns;
   timeprecision 1ps;

   reg mode;
   reg [PATTERN_LENGTH-1:0]   x;
   reg inversion;
   //assign corresponding output bits
   assign dout[DATA_WIDTH-1:0]  = mode ? (inversion ? ~x[PATTERN_LENGTH-1:PATTERN_LENGTH-DATA_WIDTH] :
                                                         x[PATTERN_LENGTH-1:PATTERN_LENGTH-DATA_WIDTH]):
                                         ( inversion ? ~x[PATTERN_LENGTH-2:PATTERN_LENGTH-DATA_WIDTH-1] :
                                                         x[PATTERN_LENGTH-2:PATTERN_LENGTH-DATA_WIDTH-1]);
   assign state_out = {inversion,mode,x};

   always @ (posedge clk, posedge rst) begin
      if(rst) begin
         x         <= DEFAULT_STATE;
         mode      <= DEFAULT_MODE;
         inversion <= 1'b0;
      end
      else if (load) begin
         x         <= load_data;
         mode      <= load_mode;
         inversion <= load_inversion;
      end
      else if (enable) begin
         if (mode) begin
            //deterministic mode
            //remapping of 32 bit sequential pattern to 4 bit parallel output for half-rate
            {x[28],x[24],x[20],x[16],x[12],x[8],x[4],x[0]}  <= {x[24],x[20],x[16],x[12],x[8],x[4],x[0],x[28]} ;
            {x[29],x[25],x[21],x[17],x[13],x[9],x[5],x[1]}  <= {x[25],x[21],x[17],x[13],x[9],x[5],x[1],x[29]} ;
            {x[30],x[26],x[22],x[18],x[14],x[10],x[6],x[2]} <= {x[26],x[22],x[18],x[14],x[10],x[6],x[2],x[30]};
            {x[31],x[27],x[23],x[19],x[15],x[11],x[7],x[3]} <= {x[27],x[23],x[19],x[15],x[11],x[7],x[3],x[31]};


         end
         else begin // prbs-31, 4 bit parallel

            x[0]  <= x[24] ^ x[27];
            x[1]  <= x[25] ^ x[28];
            x[2]  <= x[26] ^ x[29];
            x[3]  <= x[27] ^ x[30];
            x[4]  <= x[0];
            x[5]  <= x[1];
            x[6]  <= x[2];
            x[7]  <= x[3];
            x[8]  <= x[4];
            x[9]  <= x[5];
            x[10] <= x[6];
            x[11] <= x[7];
            x[12] <= x[8];
            x[13] <= x[9];
            x[14] <= x[10];
            x[15] <= x[11];
            x[16] <= x[12];
            x[17] <= x[13];
            x[18] <= x[14];
            x[19] <= x[15];
            x[20] <= x[16];
            x[21] <= x[17];
            x[22] <= x[18];
            x[23] <= x[19];
            x[24] <= x[20];
            x[25] <= x[21];
            x[26] <= x[22];
            x[27] <= x[23];
            x[28] <= x[24];
            x[29] <= x[25];
            x[30] <= x[26];

         end
      end
   end
endmodule

//Generates 2 bit parallel output using PRBS-31 or 32 bit deterministic sequence
module altera_emif_avl_tg_2_pppg32_2bit_parallel#(
   parameter DATA_WIDTH        = 2,
   parameter PATTERN_LENGTH    = 32,
   parameter DEFAULT_STATE     = 32'b10,
   parameter DEFAULT_MODE      = 1'b0
   )(
   input                       clk,
   input                       rst,
   input                       load,
   //PRBS seed or desired data sequence for deterministic mode
   input [PATTERN_LENGTH-1:0]  load_data,
   //Data mode: 0 for prbs output, 1 for deterministic sequence based on load_data
   input                       load_mode,
   input                       load_inversion,
   input                       enable,
   output [DATA_WIDTH-1:0]     dout,
   output [PATTERN_LENGTH+1:0] state_out
   );
   timeunit 1ns;
   timeprecision 1ps;

   reg mode;
   reg [PATTERN_LENGTH-1:0]   x;
   reg inversion;
   //assign corresponding output bits
   assign dout[DATA_WIDTH-1:0]  = mode ? (inversion ? ~x[PATTERN_LENGTH-1:PATTERN_LENGTH-DATA_WIDTH] :
                                                         x[PATTERN_LENGTH-1:PATTERN_LENGTH-DATA_WIDTH]):
                                         ( inversion ? ~x[PATTERN_LENGTH-2:PATTERN_LENGTH-DATA_WIDTH-1] :
                                                         x[PATTERN_LENGTH-2:PATTERN_LENGTH-DATA_WIDTH-1]);
   assign state_out = {inversion,mode,x};

   always @ (posedge clk, posedge rst) begin
      if(rst) begin
         x         <= DEFAULT_STATE;
         mode      <= DEFAULT_MODE;
         inversion <= 1'b0;
      end
      else if (load) begin
         x         <= load_data;
         mode      <= load_mode;
         inversion <= load_inversion;
      end
      else if (enable) begin
         if (mode) begin
            //deterministic mode
            //remapping of 32 bit sequential pattern to 2 bit parallel output for full-rate
            {x[30],x[28],x[26],x[24],x[22],x[20],x[18],x[16],x[14],x[12],x[10],x[8],x[6],x[4],x[2],x[0]}  <= {x[28],x[26],x[24],x[22],x[20],x[18],x[16],x[14],x[12],x[10],x[8],x[6],x[4],x[2],x[0],x[30]} ;
            {x[31],x[29],x[27],x[25],x[23],x[21],x[19],x[17],x[15],x[13],x[11],x[9],x[7],x[5],x[3],x[1]}  <= {x[29],x[27],x[25],x[23],x[21],x[19],x[17],x[15],x[13],x[11],x[9],x[7],x[5],x[3],x[1],x[31]} ;
         end
         else begin // prbs-31, 2 bit parallel

            x[0]  <= x[26] ^ x[29];
            x[1]  <= x[27] ^ x[30];
            x[2]  <= x[0];
            x[3]  <= x[1];
            x[4]  <= x[2];
            x[5]  <= x[3];
            x[6]  <= x[4];
            x[7]  <= x[5];
            x[8]  <= x[6];
            x[9]  <= x[7];
            x[10] <= x[8];
            x[11] <= x[9];
            x[12] <= x[10];
            x[13] <= x[11];
            x[14] <= x[12];
            x[15] <= x[13];
            x[16] <= x[14];
            x[17] <= x[15];
            x[18] <= x[16];
            x[19] <= x[17];
            x[20] <= x[18];
            x[21] <= x[19];
            x[22] <= x[20];
            x[23] <= x[21];
            x[24] <= x[22];
            x[25] <= x[23];
            x[26] <= x[24];
            x[27] <= x[25];
            x[28] <= x[26];
            x[29] <= x[27];
            x[30] <= x[28];

         end
      end
   end
endmodule
