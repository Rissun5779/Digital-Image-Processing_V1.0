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

`include "dynamic_parameters.v"

module basic_avl_tb_top();

   reg ref_clk;
   
   reg clk100, rst100;
   wire clk_tx, clk_rx;
   
   wire[9:0] loopback;
   reg fully_locked;

   reg[255:0] l4_tx_data =0;
   reg l4_tx_startofpacket =0;   
   reg l4_tx_endofpacket =0;   
   reg l4_tx_valid =0;   
   wire l4_tx_ready;
   reg[4:0] l4_tx_empty =0;
   wire [255:0] l4_rx_data;
   wire [4:0] l4_rx_empty;
   wire l4_rx_startofpacket;
   wire l4_rx_endofpacket;
   wire l4_rx_error;
   wire l4_rx_valid;
   wire l4_rx_fcs_valid;
   wire l4_rx_fcs_error;   
   reg serial_clk;
   wire rx_pcs_ready;
   
   	reg [2-1:0]     din_sop = 0;        // word contains first data (on leftmost byte)
    reg [2-1:0]     din_eop = 0;        // byte position of last data
    reg [2-1:0]     din_idle = 2'b11;       // bytes between EOP and SOP
    reg [3*2-1:0]   din_eop_empty = 0;  // byte position of last data
    reg [2*64-1:0]  din = 0;            // data, read left to right
    wire                din_req;
	wire                dout_valid;
    wire [2*64-1:0] dout_d;
    wire [2*8-1:0]  dout_c;
    wire [2-1:0]    dout_sop;
    wire [2-1:0]    dout_eop;
    wire [2*3-1:0]  dout_eop_empty;
    wire [2-1:0]    dout_idle;
   
   reg [3:0] tx_serial_clk = 0;
   
   ENET_ENTITY_QMEGA_01312014 dut(
	   .reset_async(rst100),
	   .rx_serial			(loopback),
	   .tx_serial			(loopback),
	   .reset_status			(rst100),
	   .clk_status			(clk100),
	   .status_write			(1'b0),
	   .status_read			(1'b0),
	   .status_addr			(16'b0),
	   .status_writedata		(32'b0),
	   .status_readdata		(),
	   .status_readdata_valid	(),
	   .status_waitrequest(),

	   `ifdef AVALON_IF
	   .l4_tx_startofpacket		(l4_tx_startofpacket),
	   .l4_tx_endofpacket		(l4_tx_endofpacket),
	   .l4_tx_valid			(l4_tx_valid),
	   .l4_tx_ready			(l4_tx_ready),
	   .l4_tx_empty			(l4_tx_empty),
	   .l4_tx_data			(l4_tx_data),
	   .l4_rx_error			(l4_rx_error),
	   .l4_rx_valid			(l4_rx_valid),
	   .l4_rx_startofpacket		(l4_rx_startofpacket),
	   .l4_rx_endofpacket		(l4_rx_endofpacket),
	   .l4_rx_data			(l4_rx_data),
	   .l4_rx_empty			(l4_rx_empty),
	   .l4_rx_fcs_error		(),
	   .l4_rx_fcs_valid		(),
           .l4_tx_error(1'b0),
      `endif
	  
	  `ifdef CUSTOM_IF
                .tx_error(2'b00),
		.din_sop		(din_sop),        	
		.din_eop		(din_eop),	
		.din_idle		(din_idle),	
		.din_eop_empty		(din_eop_empty), 
		.din			(din),    		
		.din_req		(din_req),		
		.dout_valid	    	(dout_valid),
		.dout_d		    	(dout_d),
		.dout_c		    	(dout_c),
		.dout_sop		(dout_sop),
		.dout_eop		(dout_eop),
		.dout_eop_empty 	(dout_eop_empty),
		.dout_idle		(dout_idle),
		.rx_fcs_error		(),
		.rx_fcs_valid		(),
	  `endif
	  
`ifdef SYNOPT_PTP
    .tx_egress_timestamp_request_valid(1'b0),
    .tx_egress_timestamp_request_fingerprint('d0),
    .tx_etstamp_ins_ctrl_timestamp_insert(1'b0),
    .tx_etstamp_ins_ctrl_timestamp_format(1'b0),
    .tx_etstamp_ins_ctrl_residence_time_update(1'b0),
    .tx_etstamp_ins_ctrl_residence_time_calc_format(1'b0),
    .tx_etstamp_ins_ctrl_checksum_zero(1'b0),
    .tx_etstamp_ins_ctrl_checksum_correct(1'b0),
    .tx_etstamp_ins_ctrl_offset_timestamp(16'h0),
    .tx_etstamp_ins_ctrl_offset_correction_field(16'h0),
    .tx_etstamp_ins_ctrl_offset_checksum_field(16'h0),
    .tx_etstamp_ins_ctrl_offset_checksum_correction(16'h0),
    .tx_egress_asymmetry_update(1'b0),

    `ifdef SYNOPT_96B_PTP
        .rx_time_of_day_96b_data(96'd0),
        .tx_time_of_day_96b_data(96'd0),
        .tx_etstamp_ins_ctrl_ingress_timestamp_96b(96'd0),
    `endif

    `ifdef SYNOPT_64B_PTP
        .rx_time_of_day_64b_data(64'd0),
        .tx_time_of_day_64b_data(64'd0),
        .tx_etstamp_ins_ctrl_ingress_timestamp_64b(64'd0),
    `endif
`endif
      
	   .clk_txmac			(clk_tx),

       	`ifdef SYNOPT_PAUSE
	   .pause_insert_tx		(1'b0),
	   .pause_receive_rx             (),
		`endif
	   .clk_rxmac			(clk_rx),

       .rx_pcs_ready(rx_pcs_ready),
	   
	  `ifdef STRATIX_V
		.reconfig_busy(1'b0),
		.reconfig_to_xcvr(560'b0),
	  `endif
	  
	  `ifdef ARRIA_10 
		.reconfig_clk(clk100),
		.reconfig_reset(rst100),
		.reconfig_write(1'b0),
		.reconfig_read(1'b0),
		.reconfig_address(14'b0),
		.reconfig_writedata(32'b0),
	    .tx_serial_clk(tx_serial_clk),
	    .tx_pll_locked(1'b1),
	  `endif
	   .clk_ref (ref_clk)
	   );

   //These parameters are simulation settings:
   defparam dut.ENET_ENTITY_QMEGA_01312014_inst.SYNOPT_FULL_SKEW  = 0;
   defparam dut.ENET_ENTITY_QMEGA_01312014_inst.AM_CNT_BITS 			 = 6;
   defparam dut.ENET_ENTITY_QMEGA_01312014_inst.RST_CNTR 			 = 6;
   defparam dut.ENET_ENTITY_QMEGA_01312014_inst.CREATE_TX_SKEW 	      = 1'b0;
   // defparam dut.ENET_ENTITY_QMEGA_01312014_inst.FASTSIM 	      = 1;
   // defparam dut.ENET_ENTITY_QMEGA_01312014_inst.FORCE_RO_SELS 	  = 'he4e4e4e4e48d111a223444688e4e4e4e4e4;    
   // defparam dut.ENET_ENTITY_QMEGA_01312014_inst.FORCE_BPOS 	      = 'h249249;
   // defparam dut.ENET_ENTITY_QMEGA_01312014_inst.FORCE_WPOS 	      = 'h10842;
	
   `ifdef ARRIA_10 
   always begin
	tx_serial_clk <= {4{~tx_serial_clk[0]}};
	#97;
   end
   `endif

   
   initial begin
      
      ref_clk 	    = 0;
      clk100 	    = 0;
      rst100 	    = 0;
      fully_locked  = 0;
      serial_clk    = 0;
      
      @(posedge clk100);
      rst100  = 1'b1;
      
      repeat(20) @(posedge clk100);
      rst100  = 1'b0;    
      
      @(posedge rx_pcs_ready);
      repeat(100) @(posedge clk100);

      //Display the required force values
      $display("RO_SELS: %x",dut.ENET_ENTITY_QMEGA_01312014_inst.e40_inst.phy.phy_inst.rpcs.ro_sels);
      $display("BPOS: %x",dut.ENET_ENTITY_QMEGA_01312014_inst.e40_inst.phy.phy_inst.rpcs.bpos);  
      $display("WPOS: %x",dut.ENET_ENTITY_QMEGA_01312014_inst.e40_inst.phy.phy_inst.rpcs.wpos);      

	  `ifdef AVALON_IF
      send_packets_40g_avl(10);
	  `endif
	  
	  `ifdef CUSTOM_IF
	  send_packets_40g_cus(10);
	  `endif
      $display("**");
      $display("** Testbench complete.");
      $display("**");
      $display("*****************************************");
      #100000;     
      $finish();
      
   end
   always begin
      #97 serial_clk = ~serial_clk;
      
   end   
   always begin
	  `ifdef REFCLK_644 
      #776 ref_clk = ~ref_clk;
	  `endif
      `ifdef REFCLK_322 
      #1552 ref_clk = ~ref_clk;
	  `endif
   end

   always begin
      #5000 clk100 = ~clk100;
      
   end

   task send_packets_40g_avl;
      input  [31:0]  number_of_packets;
      integer i,j;
      begin
	 fork
	    for (i = 1; i <= number_of_packets; i = i +1) begin
	       @(posedge clk_tx);

	       wait_for_ready_avl;  
	       $display("** Sending Packet %d...",i);
	       
	       l4_tx_data          = 256'hFBE42339_F0001E42_339F0100_00000000_AAAAAAAA_AAAAAAAA_AAAAAAAA_AAAAAAAA;
	       l4_tx_startofpacket = 1'b1;
	       l4_tx_valid         = 1'b1;
	       wait_for_ready_avl;

	       l4_tx_startofpacket = 1'b0;
	       
	       l4_tx_data          = {8{i}};
	       wait_for_ready_avl;
	       
	       l4_tx_data          = {8{i}};
	       wait_for_ready_avl;      	  
	       
	       l4_tx_data          = {8{i}};
	       wait_for_ready_avl;
	       
	       
	       l4_tx_data          = {8{i}};
	       wait_for_ready_avl;	  

	       
	       l4_tx_data          = 256'hFFFFFFFF_FFFFFFFF_00000000_00000000_00000000_00000000_00000000_00000000;
	       l4_tx_endofpacket   = 1'b1;
	       l4_tx_empty         = 5'd24;
	       wait_for_ready_avl;		  
	       
	       l4_tx_data          = 0;
	       l4_tx_endofpacket   = 0;
	       l4_tx_startofpacket = 0;
	       l4_tx_valid         = 0;
	       l4_tx_empty         = 0;
	       
	    end
	    
	    for (j = 1; j <= number_of_packets; j = j+1) begin
  	       while (!(l4_rx_valid && !l4_rx_startofpacket && !l4_rx_endofpacket)) @(posedge clk_rx);
	       $display("** Received Packet %d...",l4_rx_data[31:0]);
	       @(posedge clk_rx);
	       
	       while (!l4_rx_startofpacket && (j != number_of_packets)) @(posedge clk_rx);
	       @(posedge clk_rx);
	    end
	    

	 join

      end
   endtask
   
   task wait_for_ready_avl;
      #1
	 
	if(!l4_tx_ready) begin
	   while(!l4_tx_ready) @(posedge clk_tx);
	   
	end
	else begin
	   @(posedge clk_tx);
	   
	end
      
   endtask // wait_for_ready_avl
   
   
   
	task wait_for_ack_cus;
      #1
      
      if(!din_req) begin
	 while(!din_req) @(posedge clk_tx);
	 
      end
      else begin
	 @(posedge clk_tx);
	 
    end
      
   endtask // wait_for_ack_cus  
   
   task send_packets_40g_cus;
  input  [31:0]  number_of_packets;
  integer i,j;
  begin
  fork
  for (i = 1; i <= number_of_packets; i = i +1) begin
      @(posedge clk_tx);
      

     wait_for_ack_cus;  
      $display("** Sending Packet %d...",i);
  
      din          = 128'h01E42339_F0001E42_339F0100_00000000;
      din_sop    = 2'b10;
	  din_idle   = 0;
     wait_for_ack_cus;    
  
     din          = {4{i}};
     din_sop = 2'b0;
     wait_for_ack_cus;
	 
	 din          = {4{i}};
     din_sop = 2'b0;
     wait_for_ack_cus;  	  
	 
	 din          = {4{i}};
     din_sop = 2'b0;
     wait_for_ack_cus;  	  
	 
	 din          = {4{i}};
     din_sop = 2'b0;
     wait_for_ack_cus;  	  

  
      din          = 128'hFFFFFFFF_FFFFFFFF_00000000_00000000;
      din_eop_empty   = 6'O0_0;
	  din_eop      = 2'b10;
	  din_idle   = 2'b01;
     wait_for_ack_cus;
  
      din = 0;
      din_sop = 0;
      din_eop = 0;
	  din_eop_empty   = 0;
	  din_idle   = 2'b11;
      
  end
  
  for (j = 1; j <= number_of_packets; j = j+1) begin
  	while (!(dout_valid && |dout_sop)) @(posedge clk_rx);
	@(posedge clk_rx);
	while (!dout_valid) @(posedge clk_rx);
	$display("** Received Packet %d...",dout_d[31:0]);	
  end
  

  join

  end
endtask
   
   
   
endmodule // basic_avl_tb_top

