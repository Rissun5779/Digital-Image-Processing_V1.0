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


`timescale 1 ps / 1 ps
// baeckler -04-07-2009
// Out of band calendar / status RX unit
// This will disregard information blocks that do not pass CRC4
// 9-30-2012 Juzhang. Modified FIFO interface Kune's suggestion to improve the robustness.
// Add the calendar length miss-match detection. If oob_tx and oob_rx CAL_BITS setting has
// mis-match, calendar_error will be asserted, no calendar_update, and cal msg will be discarded. 

module ilk_oob_flow_rx
      #(
      parameter CAL_BITS = 16,
      parameter NUM_LANES = 8
      )(
      // must be 2x or more faster than fc_clk
      input sys_clk, sys_arst,

      //    treated as async data
      input fc_clk,fc_data,fc_sync,

      //    status output
      output reg [NUM_LANES-1:0] lane_status, // lane 0 <=> bit 0
      output reg link_status,
      output reg [CAL_BITS-1:0] calendar,   // chan 0 <=> bit 0

      // update details
      output reg status_update,		// fresh link lane status
      output reg status_error,		// discarded bad status msg
      output reg calendar_update,	// fresh block of calendar bits
      output reg calendar_error		// discarded bad cal msg
      );

// Registers for capturing FCSYNC
   reg fc_sync_capture_h; // Posedge reg
   reg fc_sync_capture_l; // Negedge reg
   reg fc_sync_capture_l_r; // Negedge-to-posedge reg
	
// Registers for capturing FCDATA
   reg fc_data_capture_h; // Posedge reg
   reg fc_data_capture_l; // Negedge reg
   reg fc_data_capture_l_r; // Negedge-to-posedge reg
   reg fc_din0, fc_sync0, fc_din1, fc_sync1;  //Add one more flop stage for better timing.
   //Added reset synchronizer for fc_clk
   reg [2:0] srst_fc_shift_n  /* synthesis preserve */
        /* synthesis ALTERA_ATTRIBUTE = "-name SDC_STATEMENT \"set_false_path -to [get_keepers *srst_fc_shift_n\[?\]]\" " */;
   always @(posedge fc_clk or posedge sys_arst) begin 
        if (sys_arst) srst_fc_shift_n <= 3'b000;
        else srst_fc_shift_n <= {srst_fc_shift_n[1:0],1'b1};
   end
   wire srst_fc_clk = ~srst_fc_shift_n[2];

   reg rdreq;
   wire rdempty;
   wire fc_din0_q;  //Neg edge sampling that is ahead of Pos edge sampleing.
   wire fc_sync0_q;
   wire fc_din1_q;  //Pos edge sampleing.
   wire fc_sync1_q;
   wire wrfull;
   //sys_clk needs to be at least twice faster than fc_clk.
   dcfifo  rx_oob_fifo (
                                .wrclk (fc_clk),
                                .rdreq (rdreq),
                                .aclr (srst_fc_clk),
                                .rdclk (sys_clk),
                                .wrreq (1'b1),
                                .data ({fc_din0, fc_sync0, fc_din1, fc_sync1}),
                                .rdempty (rdempty),
                                .q ({fc_din0_q, fc_sync0_q, fc_din1_q, fc_sync1_q}),
                                .wrfull (wrfull),
                                .rdfull (),
                                .rdusedw (),
                                .wrempty (),
                                .wrusedw ()
                                );
        defparam
                rx_oob_fifo.intended_device_family = "Stratix V",
                rx_oob_fifo.lpm_numwords = 8,
                rx_oob_fifo.lpm_showahead = "OFF",
                rx_oob_fifo.lpm_type = "dcfifo",
                rx_oob_fifo.lpm_width = 4,
                rx_oob_fifo.lpm_widthu = 3,
                rx_oob_fifo.overflow_checking = "ON",
                rx_oob_fifo.rdsync_delaypipe = 4,
                rx_oob_fifo.underflow_checking = "ON",
                rx_oob_fifo.use_eab = "ON",
                rx_oob_fifo.write_aclr_synch = "OFF",
                rx_oob_fifo.wrsync_delaypipe = 4;

  
  always @ (posedge wrfull)
        $display ("%m: at time %t: ERROR: rx_oob_fifo  Full, ", $realtime);
   /////////////////////////////////////
  // capture good data from the inputs
   /////////////////////////////////////

   // pull out the bits during fc_clock transitions
   reg cap_fc_data,cap_fc_sync,cap_valid;

	////////////////////////////////////////
	// Perform DDR sampling of fc_sync
	////////////////////////////////////////
	always @(posedge fc_clk or posedge srst_fc_clk) begin
		if (srst_fc_clk) begin
			fc_sync_capture_h <= 1'b0;
			fc_sync_capture_l_r <= 1'b0;
		end
		else begin
			fc_sync_capture_h <= fc_sync;
			fc_sync_capture_l_r <= fc_sync_capture_l;
		end
	end
	always @(negedge fc_clk or posedge srst_fc_clk) begin
		if (srst_fc_clk) begin
			fc_sync_capture_l <= 1'b0;
		end
		else begin
			fc_sync_capture_l <= fc_sync;
		end
	end
	
	////////////////////////////////////////
	// Perform DDR sampling of fc_data
	////////////////////////////////////////
	always @(posedge fc_clk or posedge srst_fc_clk) begin
		if (srst_fc_clk) begin
			fc_data_capture_h <= 1'b0;
			fc_data_capture_l_r <= 1'b0;
		end
		else begin
			fc_data_capture_h <= fc_data;
			fc_data_capture_l_r <= fc_data_capture_l;
		end
	end
	always @(negedge fc_clk or posedge srst_fc_clk) begin
		if (srst_fc_clk) begin
			fc_data_capture_l <= 1'b0;
		end
		else begin
			fc_data_capture_l <= fc_data;
		end
	end

	///////////////////////////////////////////
	// Add one more pipeline for better timing
	///////////////////////////////////////////
	always @(posedge fc_clk or posedge srst_fc_clk) begin
		if (srst_fc_clk) 
                        {fc_din0, fc_sync0, fc_din1, fc_sync1} <= 4'h0;
		else 
                        {fc_din0, fc_sync0, fc_din1, fc_sync1} <= {fc_data_capture_l_r,fc_sync_capture_l_r,
                                                                  fc_data_capture_h,  fc_sync_capture_h};
	end
	
	/////////////////////////////////////
   // sort the inbound data samples
   //   into calendar and status
   /////////////////////////////////////
   reg last_cap_data, last_cap_sync, last_cap_sync_r;
   wire to_calendar 			     = (cap_valid & (!cap_fc_sync | !last_cap_sync));
   wire to_status 			     = (cap_valid & cap_fc_sync & last_cap_sync);
   reg  rdreq_r2, rdreq_r1;

   always @(posedge sys_clk or posedge sys_arst) begin
      if (sys_arst) begin
	 last_cap_data 			    <= 1'b0;
	 last_cap_sync 			    <= 1'b0;
	 last_cap_sync_r 		    <= 1'b0;

         {rdreq_r2, rdreq_r1, rdreq}        <= 3'b000; 

	 cap_fc_data 			    <= 1'b0;
	 cap_fc_sync 			    <= 1'b0;
	 cap_valid 			    <= 1'b0;

      end
      else begin
         last_cap_sync                      <= cap_fc_sync;
         last_cap_sync_r                    <= last_cap_sync;
         last_cap_data                      <= cap_fc_data;

         if (!rdempty & !rdreq)
              rdreq                         <= 1'b1;
         else rdreq                         <= 1'b0; 

         {rdreq_r2, rdreq_r1}               <= {rdreq_r1, rdreq};
         cap_valid                          <= rdreq_r2|rdreq_r1;

         if (rdreq_r1) begin 
              cap_fc_sync                   <= fc_sync0_q; 
              cap_fc_data                   <= fc_din0_q;
         end else if (rdreq_r2)  begin
              cap_fc_sync                   <= fc_sync1_q;
              cap_fc_data                   <= fc_din1_q;
         end
      end // else: !if(sys_arst)
   end // always @ (posedge sys_clk or posedge sys_arst)

   ////////////////////////////////////////////////////
   // CRC register
   ////////////////////////////////////////////////////

   reg [3:0] crc_reg;
   wire crc_evolve, crc_first;
   wire crc_din; // data bit to evolve with

   always @(posedge sys_clk or posedge sys_arst) begin
      if (sys_arst) begin
	 crc_reg <= 4'hf;
      end
      else begin
	 if (crc_evolve) begin
	    if (crc_first) begin
	       crc_reg[3] <= 1'b1;
	       crc_reg[2] <= 1'b1;
	       crc_reg[1] <= crc_din;
	       crc_reg[0] <= 1'b1 ^ crc_din;
	    end
	    else begin
	       crc_reg[3] <= crc_reg[2];
	       crc_reg[2] <= crc_reg[1];
	       crc_reg[1] <= crc_reg[0] ^ crc_reg[3] ^ crc_din;
	       crc_reg[0] <= crc_reg[3] ^ crc_din;
	    end
	 end
      end
   end

   ////////////////////////////////////////////////////
   // Validity check inbound messages
   ////////////////////////////////////////////////////

   reg [71:0] message_bits;
   reg [6:0] cal_held,stat_held;
   reg end_of_msg_cal, end_of_msg_stat;
   reg [1:0] cal_page; // which chunk of 64 bits is this?  Up to 256

   always @(posedge sys_clk or posedge sys_arst) begin
      if (sys_arst) begin
	 message_bits <= {72{1'b0}};
	 stat_held <= {7{1'b0}};
	 cal_held <= {7{1'b0}};
	 cal_page <= 2'b00;
	 end_of_msg_cal <= 1'b0;
	 end_of_msg_stat <= 1'b0;
      end
      else begin
	 if (to_calendar) begin
	    stat_held <= {7{1'b0}};
	    if (last_cap_sync) begin
	       cal_held <= 7'h1;
	       cal_page <= 2'b00;
	    end
	    else if (cal_held == (64+4)) begin
	       cal_held <= 7'h1;
	       cal_page <= cal_page + 1'b1;
	    end
	    else cal_held <= cal_held + 1'b1;
	 end
	 if (to_status) begin
	    stat_held <= stat_held + 1'b1;
	    cal_held <= 7'h0;
	 end

	 if (to_status | to_calendar) message_bits <= {message_bits [70:0],last_cap_data};

	 if (to_status | to_calendar) begin
	    end_of_msg_cal <= (last_cap_sync | (cal_held == (64+4)));
	    end_of_msg_stat <= to_calendar & (|stat_held);
	 end
      end
   end

   // show the CRC what to work on
   assign crc_first = (to_status & (stat_held == 8)) |
		      (to_calendar & (last_cap_sync | (cal_held == (64+4))));
   assign crc_evolve = cap_valid;
   assign crc_din = last_cap_data;

   // hold a few previous CRC values
   // for retroactive CRC pass check on msg buffer
   reg [3:0] last_crc, last2_crc, last3_crc, last4_crc;
   reg crc_pass;
   always @(posedge sys_clk or posedge sys_arst) begin
      if (sys_arst) begin
	 last_crc <= 4'h0;
	 last2_crc <= 4'h0;
	 last3_crc <= 4'h0;
	 last4_crc <= 4'h0;
         crc_pass  <= 1'b0;
      end
      else begin
	 if (cap_valid) begin
	    last_crc <= crc_reg;
	    last2_crc <= last_crc;
	    last3_crc <= last2_crc;
	    last4_crc <= last3_crc;
	    crc_pass <= &(last4_crc ^ message_bits[3:0]);
	 end
      end
   end

   reg last_end_of_msg_cal;

   always @(posedge sys_clk or posedge sys_arst) begin
      if (sys_arst) begin
	 last_end_of_msg_cal <= 1'b0;
      end
      else begin
	 if (cap_valid) begin
	    last_end_of_msg_cal <= end_of_msg_cal;
	 end
      end
   end

   reg [1:0] last_cal_page,last2_cal_page;
   always @(posedge sys_clk or posedge sys_arst) begin
      if (sys_arst) begin
	 last_cal_page <= 2'h0;
	 last2_cal_page <= 2'h0;
      end
      else begin
	 if (cap_valid) begin
	    last_cal_page <= cal_page;
	    last2_cal_page <= last_cal_page;
	 end
      end
   end

   ////////////////////////////////////////////////////
   // move valid messages into output calendar + status
   ////////////////////////////////////////////////////

   wire [71:0] rev_msg;
   genvar i;
   generate
      for (i=0; i<72; i=i+1) begin : rv
	 assign rev_msg[71-i] = message_bits[i];
      end
   endgenerate

   always @(posedge sys_clk or posedge sys_arst) begin
      if (sys_arst) begin
	 lane_status <= {NUM_LANES{1'b0}};
	 link_status <= 1'b0;
	 status_update <= 1'b0;
	 status_error <= 1'b0;
      end
      else begin
	 status_update <= 1'b0;
	 status_error <= 1'b0;
	 if (cap_valid) begin
	    if (end_of_msg_stat) begin
	       if (crc_pass) begin
		  {lane_status,link_status} <= rev_msg[71-5:71-4-(NUM_LANES+1)];
		  status_update <= 1'b1;
	       end
	       else begin
		  status_error <= 1'b1;
	       end
	    end
	 end
      end
   end

   wire [CAL_BITS-1:0] next_calendar;
   reg cal_len_mismatch;    //If oob tx calendar length setting and rx calendar setting is mis-matched,
                            //This bit will be asserted at the end. For CAL_BITS larger than 64, calendar
                            //will still get updated except the last.

   localparam [1:0] FINAL_PAGE = ((CAL_BITS-1) & 8'hc0) >> 6;
   localparam SHORT_FINAL = (|(CAL_BITS[5:0]));
   localparam [5:0] SHORT_OFS = 64-CAL_BITS[5:0];

   //The following parameter is generated for detecting calendar length mismatch.
   localparam EXPECT_CAL_LEN =  (CAL_BITS <= 64) ? (CAL_BITS+4) :
                                (CAL_BITS <=128) ? (CAL_BITS - 64  + 4) :
                                (CAL_BITS <=192) ? (CAL_BITS - 128 + 4) :
                                (CAL_BITS - 192 + 4);

   localparam [1:0] EXPECT_CAL_PAGE = (CAL_BITS <=64)  ? 2'b00 :
                               (CAL_BITS <=128) ? 2'b01 :
                               (CAL_BITS <=192) ? 2'b10 :
                               2'b11;


   generate
      for (i=0; i<CAL_BITS; i=i+1) begin : nc
	 if ((i[7:6] == FINAL_PAGE) && SHORT_FINAL) begin
	    // fiddle with the offset to deal with a calendar bit on
	    // a partial last page
	    assign next_calendar[i] =
	     (last2_cal_page != i[7:6]) ?
	     calendar [i] // not my page - hold
     : rev_msg[i[5:0] + SHORT_OFS+3];
	 end
	 else begin
	    // normal 64 bit page
	    assign next_calendar[i] =
				      (last2_cal_page != i[7:6]) ?
				      calendar [i] // not my page - hold
	   : rev_msg[i[5:0]+3];
	 end
      end
   endgenerate

   reg first_calendar_seen;  //Since the fifo is free running,Mask out the first partial or error calendar.  
   always @(posedge sys_clk or posedge sys_arst) begin
      if (sys_arst) begin
        calendar <= {CAL_BITS{1'b0}};
        calendar_update <= 1'b0;
        calendar_error <= 1'b0;
        cal_len_mismatch <= 1'b0;
        first_calendar_seen <= 1'b0;
      end
      else begin
	 calendar_update <= 1'b0;
	 calendar_error <= 1'b0;
         if (last_cap_sync & !last_cap_sync_r)
            cal_len_mismatch <= !((cal_held == EXPECT_CAL_LEN) && (cal_page == EXPECT_CAL_PAGE));
	 if (cap_valid) begin
	    if (end_of_msg_cal & !last_end_of_msg_cal) begin
               first_calendar_seen <= 1;
	       if (crc_pass & !cal_len_mismatch & first_calendar_seen) begin
		  calendar <= next_calendar;
		  calendar_update <= 1'b1;
	       end
	       else begin
		  calendar_error <= first_calendar_seen;
	       end
	    end
	 end
      end
   end

endmodule // oob_flow_rx
