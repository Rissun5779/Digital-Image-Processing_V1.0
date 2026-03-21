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





`timescale 1ps/1ps
`define    TEST_AGENT top_tb.example_design_inst.test_env.test_agent
module test_host #(
   parameter NUM_LANES          = 12,
   parameter TX_PKTMOD_ONLY     = 1,
   parameter SIM_FAKE_JTAG      = 1'b0   // emulate PC host a little bit
)(
   input         clk,
   input         rst,
   input         usr_pb_reset_n,
   output [31:0] jtag_mm_address,
   output        jtag_mm_write,
   output [31:0] jtag_mm_writedata,
   input         jtag_mm_waitrequest,
   output        jtag_mm_read,
   input  [31:0] jtag_mm_readdata,
   input         jtag_mm_readdatavalid
);

   generate
      if (SIM_FAKE_JTAG) begin
         reg [31:0] jtag_mm_address_task;
         reg        jtag_mm_write_task;
         reg [31:0] jtag_mm_writedata_task;
         reg        jtag_mm_read_task;
         reg [31:0] read_data_reg;

         initial begin
           jtag_mm_address_task   = 32'h0;
           jtag_mm_write_task     = 1'h0;
           jtag_mm_writedata_task = 32'h0;
           jtag_mm_read_task      = 1'h0;
         end

         assign jtag_mm_address   = jtag_mm_address_task;
         assign jtag_mm_write     = jtag_mm_write_task;
         assign jtag_mm_writedata = jtag_mm_writedata_task;
         assign jtag_mm_read      = jtag_mm_read_task;

         // synthesis translate_off
         task write_mm_task;
            input [15:0] address;
            input [31:0] write_data;
            begin
               @(posedge clk);
               #5;
               jtag_mm_address_task = {14'h0, address, 2'b00};
               jtag_mm_writedata_task = write_data;
               jtag_mm_write_task = 1'b1;
               @(posedge clk);
               // $display("WRITE_MM: address %x gets %x", address, write_data);
               @(posedge clk);
               jtag_mm_write_task = 1'b0;
            end
         endtask

         task read_mm_task;
            input  [15:0] address;
            output [31:0] read_data;
            begin
               @(posedge clk);
               #5;
               jtag_mm_address_task = {14'h0, address, 2'b00};
               jtag_mm_read_task = 1'b1;
               @(posedge clk);
               @(posedge jtag_mm_readdatavalid);
               read_data = jtag_mm_readdata;
               // $display("READ_MM: address %x =  %x", address, read_data);
               @(posedge clk);
               jtag_mm_read_task = 1'b0;
               @(negedge jtag_mm_readdatavalid);
            end
         endtask

         reg fail = 0;
         integer startup_errors_crc24 = 0, startup_errors_crc32 = 0;
         wire all_word_lock = &`TEST_AGENT.word_locked;

         integer j, k, l;

         always @(posedge all_word_lock) begin
            $display("\t\t Word lock acquired at time %d",$time);
         end

         wire all_sync_lock = &`TEST_AGENT.sync_locked;

         always @(posedge all_sync_lock) begin
            $display("\t\t Meta lock acquired at time %d",$time);
            $display("\t\t CRC24 error count %d", `TEST_AGENT.crc24_err_cnt);
            $display("\t\t CRC32 error count %d", `TEST_AGENT.crc32_err_cnt);
         end

         always @(negedge all_word_lock) begin
            if ($time > 100) $display("\t\t Word lock lost at time %d",$time);
         end

         always @(negedge all_sync_lock) begin
            if ($time > 100) $display("\t\t Meta lock lost at time %d",$time);
         end

         always @(posedge `TEST_AGENT.itx_underflow) begin
            if (all_sync_lock)
               $display("%m: at time %t: UNDERFLOW", $time);
         end

         always @(`TEST_AGENT.crc24_err_cnt) begin
             if (`TEST_AGENT.crc24_err_cnt > startup_errors_crc24)
               fail = 1'b1;
             $display("time: %d CRC24 error count %d", $time, `TEST_AGENT.crc24_err_cnt);
         end
		 
		 always @(`TEST_AGENT.checker_errors) begin
             if (`TEST_AGENT.err_cnt > 0)
               fail = 1'b1;
             $display("time: %d checker error count %d", $time, `TEST_AGENT.err_cnt);
         end

         // Testcase example
         initial begin
            @(posedge `TEST_AGENT.reconfig_done_d);
            #200000
		    $display("\n\n\n");
            $display("__________________________________________________________");
            $display("\t INFO: Enabling serial loopback");
			$display("__________________________________________________________\n\n");
            write_mm_task(16'h1012, 32'hffff_ffff);     //enable lookback
            read_mm_task(16'h1012, read_data_reg);
			
			$display("__________________________________________________________");
            $display("\t INFO: Waiting for individual lanes to be locked");
            @(posedge &all_sync_lock);
            $display("\t       All individual lanes are locked");
			$display("__________________________________________________________\n\n");

            #1000
            startup_errors_crc24 = `TEST_AGENT.crc24_err_cnt;
            startup_errors_crc32 = `TEST_AGENT.crc32_err_cnt;
			
			$display("__________________________________________________________");
            $display("\t INFO: Waiting for lanes to be aligned");
            @(posedge `TEST_AGENT.rx_lanes_aligned)
            $display("\t       All of the receiver lanes are aligned and are ready");
            $display("\t       to receive traffic.");
			$display("__________________________________________________________\n\n");
            #200000

            // Read PCS registers
            read_mm_task(16'h1022, read_data_reg);
            // Read local testbench registers
            // $display("Local testbench register reads...");
            read_mm_task(16'h2000, read_data_reg);
            read_mm_task(16'h2002, read_data_reg);
			
			
			$display("__________________________________________________________");
            $display("\t INFO: Start transmitting packets");
			$display("__________________________________________________________\n\n");
			
            write_mm_task(16'h200f, 1'b1);


            #3000000
			$display("__________________________________________________________");
            $display("\t INFO: Stop transmitting packets");
			$display("__________________________________________________________\n\n");

            write_mm_task(16'h200f, 1'b0);
			
			$display("__________________________________________________________");
            $display("\t INFO: Checking packets statistics");
			$display("__________________________________________________________\n\n");
			
            read_mm_task (16'h2010, read_data_reg);  // read HW test detected errors
            $display("\t\t CRC24 errors reported: %10d", `TEST_AGENT.crc24_err_cnt-startup_errors_crc24);
            $display("\t\t SOPs transmitted:  %10d", `TEST_AGENT.tx_sop_cnt);
            $display("\t\t EOPs transmitted:  %10d", `TEST_AGENT.tx_eop_cnt);
            $display("\t\t SOPs received:     %10d", `TEST_AGENT.sop_cntr_s);
            $display("\t\t EOPs received:     %10d", `TEST_AGENT.eop_cntr_s);

            // #450000;


            // $display("Assert System Reset");
            // write_mm_task(16'h2003, 32'h1);
            // write_mm_task(16'h2002, 32'h1);
            // @(negedge `TEST_AGENT.tx_usr_srst);
            // write_mm_task(16'h2002, 32'h0);
            // $display("Program serialloopback reg");
            // write_mm_task(16'h1012, 12'hfff);     //enable lookback
            // read_mm_task(16'h1012, read_data_reg);
			
            #1
            if (`TEST_AGENT.sop_cntr_s == 0 && `TEST_AGENT.eop_cntr_s==0 ) begin
			   fail = 1'b1;
			   $display("__________________________________________________________");
               $display("\t INFO: No SOP and EOP received \n");
			   $display("__________________________________________________________");
			end

            #1
            if (fail) begin
			   $display("__________________________________________________________");
               $display("\t INFO: Test FAILED \n");
			   $display("__________________________________________________________");
               $display("FAIL");
			   end
            else begin
               $display("__________________________________________________________");
               $display("\t INFO: Test PASSED \n");
			   $display("__________________________________________________________");
			   $display("PASS");
            end
            $finish;
         end
      // synthesis translate_on
      end else begin
         jtag_master jtag_master_inst (
            .clk_clk              (clk),
            //.clk_0_clk_in_reset_reset_n    (~rst),
            .clk_reset_reset      (~usr_pb_reset_n),
            .master_address       (jtag_mm_address),
            .master_readdata      (jtag_mm_readdata),
            .master_read          (jtag_mm_read),
            .master_write         (jtag_mm_write),
            .master_writedata     (jtag_mm_writedata),
            .master_waitrequest   (jtag_mm_waitrequest),
            .master_readdatavalid (jtag_mm_readdatavalid),
            .master_byteenable    (),
            .master_reset_reset   ()
         );
      end
   endgenerate
/*
      // synthesis translate_off
   initial begin      //shooten sim time TODO
     #100000000;
     $finish;
   end
      // synthesis translate_on
*/     
endmodule
