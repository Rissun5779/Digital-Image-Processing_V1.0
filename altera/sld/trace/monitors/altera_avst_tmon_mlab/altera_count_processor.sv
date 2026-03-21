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


// This module does the real monitoring.  It outputs  increment pulses
// to the counter block altera_mirror_blk8.sv. That block holds the counters,
// and the logic to transfer the count values out to be added to MLAB entries.

module altera_count_processor #(
   parameter 
   BC_W            = 5
   ) (
   input             if_clock,
   input             if_reset,
   input             if_read,
   input             if_write,
   input  [BC_W-1:0] if_burstcount,
   input             if_waitrequest,
   input             if_readdatavalid,
   output      [3:0] inc_out,
   output      [3:0] add_out
);

reg  [11:0] readcount; //has to be bigger than burstcount,
                       //because multiple bursts could be pending
reg         write_in_progress;

wire read_xfrs_inc    = if_readdatavalid;
wire read_cycles_inc  = if_read || (readcount > 12'h0);
wire write_xfrs_inc   = if_write && !if_waitrequest;
wire write_cycles_inc = write_in_progress;

assign inc_out = {write_cycles_inc, write_xfrs_inc, 
                  read_cycles_inc,  read_xfrs_inc};
assign add_out = 4'h0; //unused so far...

//readcount indicates how many readdatavalid cycles are yet to come
//if readcount>0, then current cycle counts as a read cycle
always @(posedge if_clock or posedge if_reset) begin
   if (if_reset) readcount <= 12'h0; 
   else if (if_read && ~if_waitrequest) begin //the cycle when read is accepted
      if (if_readdatavalid) readcount <= readcount + if_burstcount - 1'b1;
      else                  readcount <= readcount + if_burstcount;
   end
   else if (if_readdatavalid) readcount <= readcount - 1'b1;
end

//write burst state tracker
parameter  WIDLE = 1'b0,
           WIP   = 1'b1;
reg        wstate, nx_wstate;
reg [10:0] wburstcnt;
reg        load, decr;

always @(posedge if_clock or posedge if_reset) begin
   if (if_reset) begin
      wstate <= WIDLE;
      wburstcnt <= 11'h0;
   end
   else begin
      wstate <= nx_wstate;
      if (load) begin
         if (~if_waitrequest) wburstcnt <= if_burstcount - 1'b1;
         else                 wburstcnt <= if_burstcount;
      end
      else if (decr)          wburstcnt <= wburstcnt - 1'b1;
   end
end

wire newburst = (wburstcnt == 11'h0);

always @ (*) begin
   nx_wstate = wstate;
   decr      = 1'b0;
   load      = 1'b0;
   case (wstate)
   WIDLE: begin
      write_in_progress = 1'b0;
      if (if_write && newburst) begin
         load              = 1'b1;
         write_in_progress = 1'b1;
         if (if_waitrequest || (if_burstcount > {{BC_W-1{1'b0}}, 1'b1})) nx_wstate = WIP;
      end
   end
   WIP: begin //write in progress
      write_in_progress = 1'b1;
      if (if_write && ~if_waitrequest) begin //valid write cycle
         decr = 1'b1;
         if (wburstcnt == 11'h1) nx_wstate = WIDLE;
      end
   end
   endcase
end

endmodule

