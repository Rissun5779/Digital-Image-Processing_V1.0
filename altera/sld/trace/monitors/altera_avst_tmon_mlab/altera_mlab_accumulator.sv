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


// There are N front-end counters counting events - these are located in the
// counter block altera_mirror_blk8, which for demo purposes has 8 counters.
// The counters are small, only 8 bits each.  The counters are extended to 
// 32 bits by using an MLAB memory to accumulate the counter values. This is
// done by scanning through the counters one after another, and adding the 
// count values to the RAM locations.  
// Details:
// When a given counter is transferred, its value is either zero'd, or - if
// the transfer happens just as the counter is getting incremented - set to
// the increment value.
// The MLAB RAM is 16 bits wide, so a 32-bit counter takes two locations. When
// a transfer to RAM occurs, the counter value is added to the lower RAM
// location.  If the addition generates a carry, then the higher RAM location
// is incremented. 
// One counter provides both the selection control for the counter block, and
// the read and write addresses for the MLAB.  The counter block uses
// xfr_select[3:1] to select a counter; the RAM uses xfr_select[3:0] to select
// a RAM location.  Even RAM locations are the "low" locations, which get
// counter values added.  Odd RAM locations are the "high" locations, which
// get incremented.
// It generally requires 25 clock cycles to scan through all 8 counters. If
// a high RAM location needs to be incremented, that takes an additional
// 3 cycles. Absolute worst case - where every high RAM location needs to be
// incremented on the same pass - would take 49 cycles.
//
//
//
//
module altera_mlab_accumulator (
   input             clk,
   input             reset,
   input       [3:0] add,
   input       [3:0] inc,
   input       [7:0] addend0,
   input       [7:0] addend1,
   input       [7:0] addend2,
   input       [7:0] addend3,
   input             as_rdreq_t,
   output reg        rdack_t,
   input       [2:0] as_raddr,
   output reg [31:0] rdata
);

reg   [3:0] state,      xstate;
reg         we,         xwe;
reg   [3:0] xfr_select, xselect;
reg   [1:0] rstate,     xrstate;//used to return to correct state after external read
wire [15:0] rdata_half; //halfword read data from RAM
wire  [7:0] xfr_count;  //from counter block
reg  [16:0] writedata;  //halfword data written to RAM
reg         xfr;        //gets xfr_count from counter block
wire        carry = writedata[16]; //if low add gives carry, increment hi word

//regs to support external read
reg  extadden,   tophalf;
reg  strb;
reg  [1:0] strb_bits;
wire strblo = strb_bits[0];
wire strbhi = strb_bits[1];
reg  xrdack_t;
wire rdreq_t;
wire rdreq = (rdack_t != rdreq_t);

altera_std_synchronizer #(
   .depth      (2)
   ) req_sync (
   .clk      (clk),
   .reset_n  (~reset),
   .din      (as_rdreq_t),
   .dout     (rdreq_t)
   );

localparam INIT  = 4'h0,
           IDLE  = 4'h1,
           RDLO  = 4'h2,
           ADDLO = 4'h3,
           WRLO  = 4'h4,
           RDHI  = 4'h5,
           ADDHI = 4'h6,
           WRHI  = 4'h7,
           EXRD  = 4'h8,
           EXLO  = 4'h9,
           EXHI  = 4'ha,
           EXRET = 4'hb;



always @(posedge clk or posedge reset) begin
   if (reset) begin
      state <= INIT;
      xfr_select <= 4'h0;
      we         <= 1'b1;
      rstate     <= 2'h1;
      rdack_t    <= 1'b0;
      strb_bits  <= 2'h0;
   end
   else begin
      state      <= xstate;
      xfr_select <= xselect;
      we         <= xwe;
      rstate     <= xrstate;
      rdack_t    <= xrdack_t;
      strb_bits  <= {strb_bits[0], strb};
   end
end

//xfr is 1 cycle - gets current value out of mirror blk counter and 
//reinitializes counter
//
always @ (*) begin
   xfr        = 1'b0;
   xwe        = 1'b0;
   xselect    = xfr_select;
   writedata  = rdata_half[15:0] + xfr_count[7:0];
   xstate     = state;
   xrstate    = 2'h1; //default is return to RDLO
   xrdack_t   = rdack_t;
   extadden   = 1'b0;
   tophalf    = 1'b0;
   strb       = 1'b0;
   case (state)
      INIT: begin //0:zero the RAM
         xwe = 1'b1;
         writedata = 16'h0;
//         writedata = 16'hffc0; //use for testing carry
         xselect = xfr_select + 1'b1;
         if (xfr_select==4'hf) begin
            xstate = IDLE;
            xwe = 1'b0;
         end
      end         
      IDLE: begin//1:
         xstate  = RDLO;
         xselect = 4'h0;
      end
      RDLO: begin //2: read low 16 bits of count, and 8 bit value from mirror block
         xstate    = ADDLO;
         xfr       = 1'b1;
      end
      ADDLO: begin //3: add mirror block value + RAM value
         xstate    = WRLO;
         xwe       = 1'b1;
      end 
      WRLO: begin //4: write sum back into low RAM location
         if (~carry) begin //if no carry
            if (xfr_select < 4'he) begin
               xselect = xfr_select + 2'h2;
               xrstate = 2'h1; //return to rdlo
               if (rdreq) xstate = EXRD;
               else       xstate = RDLO;
            end
            else begin
               if (rdreq) xstate = EXRD;
               else       xstate = IDLE;
               xrstate = 2'h0; //return to idle
            end
         end
         else begin //if carry
         //ignore rdreq in this case, 
         //32bit count is wrong until top half is incremented
            xselect = xfr_select + 1'b1;
            xstate  = RDHI;
         end
      end
      RDHI: begin //5: if there was a carry, increment hi RAM location
         xstate    = ADDHI;
         writedata = rdata_half[15:0] + 1'b1;
      end
      ADDHI: begin //6: if there was a carry, increment hi RAM location
         xstate    = WRHI;
         writedata = rdata_half[15:0] + 1'b1;
         xwe       = 1'b1;
      end
      WRHI: begin //7: repeat sequence until xselect = f, then back to IDLE
         writedata = rdata_half[15:0] + 1'b1;
         if (xfr_select < 4'hf) begin
            xselect = xfr_select + 1'b1;
            xrstate = 2'h1; //return to rdlo
            if (rdreq) xstate = EXRD;
            else       xstate  = RDLO;
         end
         else begin
            xselect = 4'h0;
            xrstate = 2'h0;
            if (rdreq) xstate = EXRD;
            else       xstate = IDLE;
         end
      end
      EXRD: begin //8: drive ext read address
         extadden = 1'b1;
         xrstate  = rstate;
         xstate   = EXLO;
         strb     = 1'b1;
      end
      EXLO: begin //9:
         extadden = 1'b1;
         xrstate  = rstate;
         xstate   = EXHI;
         tophalf  = 1'b1;;
      end
      EXHI: begin //a:
         extadden = 1'b1;
         xrstate  = rstate;
         xstate   = EXRET;
         tophalf  = 1'b1;
         xrdack_t = rdreq_t;
      end
      EXRET: begin //a:
         extadden = 1'b0;
         xstate   = (rstate == 2'h0) ? IDLE : (rstate == 2'h1) ? RDLO : RDHI;
         tophalf  = 1'b0;
      end
   endcase
end

altera_mirror_blk8 mblk8 (
   .clk          (clk),
   .reset        (reset),
   .add          (add), //4 bit
   .inc          (inc), //4 bit
   .addend0      (addend0),
   .addend1      (addend1),
   .addend2      (addend2),
   .addend3      (addend3),
   .xfr          (xfr),
   .cntr_select  (xfr_select[3:1]),
   .xfr_count    (xfr_count)
   );

wire [3:0] mlab_addr = (extadden) ? {as_raddr, tophalf} : xfr_select;

altera_mlab_sp mlab (
   .clk          (clk),
   .we           (we),
   .addr         (mlab_addr),
   .wdata        (writedata[15:0]),
   .rdata        (rdata_half)
   );

always @ (posedge clk or posedge reset) begin
  if (reset) rdata <= 32'h0;
  else if (strblo) rdata <= {rdata[31:16], rdata_half};
  else if (strbhi) rdata <= {rdata_half, rdata[15:0]};
end

endmodule

