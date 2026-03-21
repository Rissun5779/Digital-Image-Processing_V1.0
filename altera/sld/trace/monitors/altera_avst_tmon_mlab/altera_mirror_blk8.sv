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


//this is just a trial version, with 4 adders and 4 counters
module altera_mirror_blk8 (
   input            clk,
   input            reset,
   input      [3:0] add,
   input      [3:0] inc,
   input      [7:0] addend0,
   input      [7:0] addend1,
   input      [7:0] addend2,
   input      [7:0] addend3,
   input            xfr,
   input      [2:0] cntr_select,
   output reg [7:0] xfr_count
   );

   reg  [7:0] selxfr;
   wire [7:0] count0, count1, count2, count3;
   wire [7:0] count4, count5, count6, count7;

   always @ (*) begin
      if (!xfr) selxfr <= 8'h0;
      else begin
         case (cntr_select)
         3'h0: selxfr <= 8'h01;
         3'h1: selxfr <= 8'h02;
         3'h2: selxfr <= 8'h04;
         3'h3: selxfr <= 8'h08;
         3'h4: selxfr <= 8'h10;
         3'h5: selxfr <= 8'h20;
         3'h6: selxfr <= 8'h40;
         3'h7: selxfr <= 8'h80;
         endcase
      end
   end

   //xfr_count will have valid data on cycle after xfr is active
   always @ (posedge clk or posedge reset) begin
      if (reset) xfr_count <= 8'h0;
      else if (xfr) begin
         case (cntr_select)
            3'h0: xfr_count <= count0;
            3'h1: xfr_count <= count1;
            3'h2: xfr_count <= count2;
            3'h3: xfr_count <= count3;
            3'h4: xfr_count <= count4;
            3'h5: xfr_count <= count5;
            3'h6: xfr_count <= count6;
            3'h7: xfr_count <= count7;
         endcase
      end
   end


   altera_mirror_count mcount0 (
      .clk          (clk),
      .reset        (reset),
      .inc          (inc[0]),
      .xfr          (selxfr[0]),
      .count        (count0)
      );

   altera_mirror_count mcount1 (
      .clk          (clk),
      .reset        (reset),
      .inc          (inc[1]),
      .xfr          (selxfr[1]),
      .count        (count1)
      );
   altera_mirror_count mcount2 (
      .clk          (clk),
      .reset        (reset),
      .inc          (inc[2]),
      .xfr          (selxfr[2]),
      .count        (count2)
      );
    altera_mirror_count mcount3 (
      .clk          (clk),
      .reset        (reset),
      .inc          (inc[3]),
      .xfr          (selxfr[3]),
      .count        (count3)
      );

    altera_mirror_add madd4 (
      .clk          (clk),
      .reset        (reset),
      .add          (add[0]),
      .addend       (addend0),
      .xfr          (selxfr[4]),
      .count        (count4)
      );
    altera_mirror_add madd5 (
      .clk          (clk),
      .reset        (reset),
      .add          (add[1]),
      .addend       (addend1),
      .xfr          (selxfr[5]),
      .count        (count5)
      );
    altera_mirror_add madd6 (
      .clk          (clk),
      .reset        (reset),
      .add          (add[2]),
      .addend       (addend2),
      .xfr          (selxfr[6]),
      .count        (count6)
      );
    altera_mirror_add madd7 (
      .clk          (clk),
      .reset        (reset),
      .add          (add[3]),
      .addend       (addend3),
      .xfr          (selxfr[7]),
      .count        (count7)
      );
endmodule

