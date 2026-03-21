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


// $Id: //acds/main/ip/pgm/altera_nd_mailbox_avst_adap/altera_nd_mailbox_avst_adap.sv#2 $
// $Revision: #2 $
// $Date: 2015/10/19 $
// $Author: tgngo $


`timescale 1 ns / 1 ns
module altera_config_debug_agent_bridge #(
		parameter USE_AVST_EP       = 1,
		parameter USE_CONFIG_STR_EP = 1,
		parameter MFR_CODE          = 0,
		parameter TYPE_CODE         = 0,
		parameter PREFER_HOST       = "JTAG",
		parameter USE_STREAM        = 0,
		parameter USE_OFFLOAD       = 0,
		parameter DATA_WIDTH        = 8,
		parameter CHANNEL_WIDTH     = 0,
		parameter EMPTY_WIDTH       = 0
	) (
		input          						clk,                   
		input          						reset,

		output logic        				h2t_ready,             
		input          						h2t_valid,             
		input [DATA_WIDTH-1 : 0] 			h2t_data,              
		input          						h2t_startofpacket,     
		input          						h2t_endofpacket,       
		input [CHANNEL_WIDTH-1 : 0]    		h2t_channel,
		input [EMPTY_WIDTH-1 : 0]         	h2t_empty,

		input          						t2h_ready,             
		output logic        				t2h_valid,             
		output logic [DATA_WIDTH-1 : 0] 	t2h_data,              
		output logic        				t2h_startofpacket,     
		output logic        				t2h_endofpacket,       
		output logic [CHANNEL_WIDTH-1 : 0]  t2h_channel,
		output logic [EMPTY_WIDTH-1 : 0]    t2h_empty,

		input          						command_ready,         
		output logic        				command_valid,         
		output logic [31 : 0] 				command_data,          
		output logic        				command_startofpacket, 
		output logic        				command_endofpacket,   

		output logic        				response_ready,        
		input          						response_valid,        
		input [31 : 0] 						response_data,         
		input          						response_startofpacket,
		input          						response_endofpacket
	);

	logic						response_ready_int;        
	logic   					response_valid_int;        
	logic [31 : 0]				response_data_int;
	logic [CHANNEL_WIDTH-1 : 0] response_channel_int;
	logic          				response_startofpacket_int;
	logic          				response_endofpacket_int;

	// The demux: route h2t in correct channel
	// 0: command and response
	// 1: stream active status 
	// 2: stream packet
	// 3: offload
	demultiplexer demux_ins (
		.clk                (clk),               
		.reset              (reset),             
		.sink_ready         (h2t_ready),         
		.sink_channel       (h2t_channel),       
		.sink_data          (h2t_data),          
		.sink_startofpacket (h2t_startofpacket), 
		.sink_endofpacket   (h2t_endofpacket),   
		.sink_valid         (h2t_valid),        
		.src0_ready         (command_ready),        
		.src0_valid         (command_valid),        
		.src0_data          (command_data),         
		.src0_channel       (),      
		.src0_startofpacket (command_startofpacket),
		.src0_endofpacket   (command_endofpacket),  
		.src1_ready         (1'b0),        
		.src1_valid         (),        
		.src1_data          (),         
		.src1_channel       (),      
		.src1_startofpacket (),
		.src1_endofpacket   (),  
		.src2_ready         (1'b0),        
		.src2_valid         (),        
		.src2_data          (),         
		.src2_channel       (),      
		.src2_startofpacket (),
		.src2_endofpacket   (),  
		.src3_ready         (1'b0),        
		.src3_valid         (),        
		.src3_data          (),         
		.src3_channel       (),      
		.src3_startofpacket (),
		.src3_endofpacket   ()   
	);

	// The mux: route different responses to t2h interface
	multiplexer mux_ins (
		.clk                 (clk),                 
		.reset               (reset),               
		.src_ready           (t2h_ready),           
		.src_valid           (t2h_valid),           
		.src_data            (t2h_data),            
		.src_channel         (t2h_channel),         
		.src_startofpacket   (t2h_startofpacket),   
		.src_endofpacket     (t2h_endofpacket),     
		.sink0_ready         (response_ready_int),         
		.sink0_valid         (response_valid_int),         
		.sink0_channel       (response_channel_int),       
		.sink0_data          (response_data_int),          
		.sink0_startofpacket (response_startofpacket_int),
		.sink0_endofpacket   (response_endofpacket_int),
		.sink1_ready         (),         
		.sink1_valid         (1'b0),         
		.sink1_channel       (),       
		.sink1_data          (),          
		.sink1_startofpacket (), 
		.sink1_endofpacket   (),   
		.sink2_ready         (),         
		.sink2_valid         (1'b0),         
		.sink2_channel       (),       
		.sink2_data          (),          
		.sink2_startofpacket (), 
		.sink2_endofpacket   (),   
		.sink3_ready         (),         
		.sink3_valid         (1'b0),
		.sink3_channel       (),       
		.sink3_data          (),          
		.sink3_startofpacket (), 
		.sink3_endofpacket   ()    
	);
	// it should be not assert empty but put here to fullfill requirement of avalon st debug agent
	assign t2h_empty = '0;

	avst_adap #(
		.APPEND_STR_INFO      (0),
		.HAS_STREAM           (1),
		.STR_MUX_SELECT       (16'b0000000000000000),
		.NUM_STR_ENDPOINTS    (1),
		.CHANNEL_WIDTH        (4),
		.DATA_WIDTH           (32),
		.OUT_DATA_WIDTH       (32),
		.CHANNEL_VALUE_DEC    (1),
		.CHANNEL_VALUE_ONEHOT (16'b0000000000000001),
		.IN_USE_PACKET        (1),
		.OUT_USE_PACKET       (1),
		.IN_USE_CHANNEL       (0),
		.OUT_USE_CHANNEL      (1)
	) avst_adapator_ins (
		.in_ready    (response_ready),    
		.in_valid    (response_valid),    
		.in_sop      (response_startofpacket),      
		.in_eop      (response_endofpacket),      
		.in_data     (response_data),     
		.clk         (clk),         
		.reset       (reset),       
		.out_ready   (response_ready_int),   
		.out_valid   (response_valid_int),   
		.out_channel (response_channel_int), 
		.out_sop     (response_startofpacket_int),     
		.out_eop     (response_endofpacket_int),     
		.out_data    (response_data_int)     
	);

endmodule
