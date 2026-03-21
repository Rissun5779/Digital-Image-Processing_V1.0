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


// $Id: //acds/main/ip/altera_voltage_sensor/control/altera_voltage_sensor_control.sv#3 $
// $Revision: #3 $
// $Date: 2015/01/18 $
// $Author: tgngo $

// altera_nd_mailbox_top.v

`timescale 1 ns / 1 ns
module altera_nd_mailbox_driver 
  #(
    parameter HAS_URGENT    = 1,
    parameter HAS_STREAM    = 1,
    parameter GPI_WIDTH  	= 4,
	parameter ADDR_W     	= 32,
	parameter DATA_W     	= 32,
	parameter STREAM_WIDTH 	= 32,
	parameter ID_W       	= 4,
	parameter USER_W     	= 5
   )
   (
    // +-----------------------------------------------------
    // | CLock and Reset
    // +-----------------------------------------------------
    input wire         clk,
    input wire         reset,

    // +-----------------------------------------------------
    // | FPGA to SDM Bridge (used by command and response path)
    // +-----------------------------------------------------
    output wire [3:0]  axi_mstr_ar_id, 
	output wire [31:0] axi_mstr_ar_addr,
	output wire [7:0]  axi_mstr_ar_len, 
	output wire [2:0]  axi_mstr_ar_size,
	output wire [1:0]  axi_mstr_ar_burst,
	output wire        axi_mstr_ar_lock, 
	output wire [3:0]  axi_mstr_ar_cache,
	output wire [2:0]  axi_mstr_ar_prot, 
	output wire [3:0]  axi_mstr_ar_qos, 
	output wire        axi_mstr_ar_valid, 
	output wire [4:0]  axi_mstr_ar_user, 
	input wire [3:0]   axi_mstr_r_id, 
	input wire         axi_mstr_ar_ready, 
	input wire [31:0]  axi_mstr_r_data, 
	input wire [1:0]   axi_mstr_r_resp, 
	input wire         axi_mstr_r_last, 
	input wire         axi_mstr_r_valid, 
	output wire        axi_mstr_r_ready,
	output wire [3:0]  axi_mstr_aw_id, 
	output wire [31:0] axi_mstr_aw_addr, 
	output wire [7:0]  axi_mstr_aw_len, 
	output wire [2:0]  axi_mstr_aw_size, 
	output wire [1:0]  axi_mstr_aw_burst,
	output wire        axi_mstr_aw_lock, 
	output wire [3:0]  axi_mstr_aw_cache,
	output wire [2:0]  axi_mstr_aw_prot, 
	output wire [3:0]  axi_mstr_aw_qos, 
	output wire        axi_mstr_aw_valid, 
	output wire [4:0]  axi_mstr_aw_user, 
	input wire         axi_mstr_aw_ready, 
	output wire [31:0] axi_mstr_w_data, 
	output wire        axi_mstr_w_last, 
	input wire         axi_mstr_w_ready, 
	output wire        axi_mstr_w_valid, 
	output wire [3:0]  axi_mstr_w_strb, 
	input wire [3:0]   axi_mstr_b_id, 
	input wire [1:0]   axi_mstr_b_resp, 
	input wire         axi_mstr_b_valid, 
	output wire        axi_mstr_b_ready, 

	// +-----------------------------------------------------
    // | SDM to FPGA Bridge (used by streaming controller)
    // +-----------------------------------------------------
	input wire [3:0]   axi_slv_aw_id, 
	input wire [31:0]  axi_slv_aw_addr, 
	input wire [7:0]   axi_slv_aw_len, 
	input wire [2:0]   axi_slv_aw_size, 
	input wire [1:0]   axi_slv_aw_burst,
	input wire         axi_slv_aw_lock, 
	input wire [3:0]   axi_slv_aw_cache,
	input wire [2:0]   axi_slv_aw_prot, 
	input wire [3:0]   axi_slv_aw_qos, 
	input wire         axi_slv_aw_valid, 
	input wire [4:0]   axi_slv_aw_user, 
	output wire        axi_slv_aw_ready, 
	input wire [63:0]  axi_slv_w_data, 
	input wire         axi_slv_w_last, 
	output wire        axi_slv_w_ready, 
	input wire         axi_slv_w_valid, 
	input wire [7:0]   axi_slv_w_strb, 
	output wire [3:0]  axi_slv_b_id, 
	output wire [1:0]  axi_slv_b_resp, 
	output wire        axi_slv_b_valid, 
	input wire         axi_slv_b_ready, 
	output wire [63:0] axi_slv_r_data, 
	output wire [1:0]  axi_slv_r_resp, 
	output wire        axi_slv_r_last, 
	output wire        axi_slv_r_valid, 
	input wire         axi_slv_r_ready, 
	input wire [3:0]   axi_slv_ar_id, 
	input wire [31:0]  axi_slv_ar_addr, 
	input wire [7:0]   axi_slv_ar_len, 
	input wire [2:0]   axi_slv_ar_size, 
	input wire [1:0]   axi_slv_ar_burst, 
	input wire         axi_slv_ar_lock, 
	input wire [3:0]   axi_slv_ar_cache, 
	input wire [2:0]   axi_slv_ar_prot, 
	input wire [3:0]   axi_slv_ar_qos, 
	input wire         axi_slv_ar_valid, 
	input wire [4:0]   axi_slv_ar_user, 
	output wire        axi_slv_ar_ready, 
	output wire [3:0]  axi_slv_r_id,
    
    // +-----------------------------------------------------
    // | Command packet input from endpoint
    // +-----------------------------------------------------
    input wire         cmd_pck_valid, 
	input wire         cmd_pck_startofpacket, 
	input wire         cmd_pck_endofpacket, 
	output wire        cmd_pck_ready, 
	input wire [31:0]  cmd_pck_data, 
    
    // +-----------------------------------------------------
    // | Response packet output to endpoint
    // +-----------------------------------------------------
	input wire         rsp_pck_ready, 
	output wire        rsp_pck_startofpacket, 
	output wire        rsp_pck_valid, 
	output wire        rsp_pck_endofpacket, 
	output wire [31:0] rsp_pck_data, 

    // +-----------------------------------------------------
    // | Urgent packet from endpoint
    // +-----------------------------------------------------
	input wire         urg_pck_valid, 
	input wire         urg_pck_startofpacket, 
	input wire         urg_pck_endofpacket, 
	output wire        urg_pck_ready, 
	input wire [31:0]  urg_pck_data,

    // +-----------------------------------------------------
    // | Stream packet
    // +-----------------------------------------------------
    input wire         	str_valid, 
	input wire         str_startofpacket,
	input wire         str_endofpacket, 
	output wire        str_ready, 
	input wire [STREAM_WIDTH-1:0]  str_data,
    output wire [3:0]  str_select,
    output wire        str_active,

    // +-----------------------------------------------------
    // | GPIO signals: From/To SDM
    // +-----------------------------------------------------
    input [8:0]        gpo_from_sdm,
    // Driver sends gray code to SDM via gpi_to_sdm
    output [3:0]       gpi_to_sdm,
    // | This is GPI interrupt
	output wire        gpi_irq_str
    
	);

	wire         mailbox_cmd_controller_cmd_req_valid;  
	wire   [5:0] mailbox_cmd_controller_cmd_req_data;   
	wire         mailbox_cmd_controller_cmd_req_ready;  
	wire         mailbox_cmd_controller_out_cmd_valid;  
	wire  [63:0] mailbox_cmd_controller_out_cmd_data;   
	wire         mailbox_cmd_controller_out_cmd_ready;  
	wire         mailbox_cmd_controller_out_cmd_startofpacket; 
	wire         mailbox_cmd_controller_out_cmd_endofpacket;   
	wire         mailbox_urg_controller_out_data_valid;        
	wire  [31:0] mailbox_urg_controller_out_data_data;         
	wire         mailbox_urg_controller_out_data_ready;        
	wire         mailbox_urg_controller_out_data_startofpacket;
	wire         mailbox_urg_controller_out_data_endofpacket;  
	wire         mailbox_read_controller_rout_update_req_valid;
	wire   [5:0] mailbox_read_controller_rout_update_req_data; 
	wire         mailbox_read_controller_rout_update_req_ready;
	wire         mailbox_scheduler_src_valid;                  
	wire  [74:0] mailbox_scheduler_src_data;                   
	wire         mailbox_scheduler_src_ready;                  
	wire         mailbox_scheduler_src_startofpacket;          
	wire         mailbox_scheduler_src_endofpacket;            


	// +-----------------------------------------------------
    // | Address mapping: the mailbox driver must drive correct
    // | address offset to mailbox via shared NoC
    // | 32'hB4000000
    // +-----------------------------------------------------

	wire [31:0] axi_mstr_ar_addr_internal;
	wire [31:0] axi_mstr_aw_addr_internal; 

	assign axi_mstr_ar_addr = {8'hB4, axi_mstr_ar_addr_internal[23:0]};
	assign axi_mstr_aw_addr = {8'hB4, axi_mstr_aw_addr_internal[23:0]};

	// +-----------------------------------------------------
    // | Route GPO from SDM to each controller
    // | TODO: Clock crossing and synchonizer, use one and route to all
    // +-----------------------------------------------------
    wire  		sdm_gpo_write;
    wire [7:0] 	sdm_gpo_data;
	reg 		sdm_gpo_write_synced_dly;
    wire 		sdm_gpo_write_synced_pulse;
    assign   sdm_gpo_write = gpo_from_sdm[8];
    assign   sdm_gpo_data  = gpo_from_sdm[7:0];
	
	// +-----------------------------------------------------
    // | Bit 8 of the GPO is used as a write indication,
	// | synchronize this bit, then do edge detection 
	// | and use this as write signal to all components
    // +-----------------------------------------------------
	altera_std_synchronizer #(
		.depth(2)
	)
    u_sync (
		.clk(clk), 
		.reset_n(!reset), 
		.din(sdm_gpo_write), 
		.dout(sdm_gpo_write_synced)
	);

    always_ff @(posedge clk) begin
        if (reset)
			sdm_gpo_write_synced_dly <= 1'b0;
        else
			sdm_gpo_write_synced_dly <= sdm_gpo_write_synced;
    end
    assign sdm_gpo_write_synced_pulse = sdm_gpo_write_synced & !sdm_gpo_write_synced_dly; 
	
	// +-----------------------------------------------------
    // | ROUT update signal, indicate the command controller
    // | there is ROUT update within 100 cycles, it can decide
    // | to send maximum or halfway point
    // +-----------------------------------------------------
    wire         cmd_controller_rout_update;
    assign       cmd_controller_rout_update = mailbox_read_controller_rout_update_req_valid && mailbox_read_controller_rout_update_req_ready;
    // tesing, got rout update, halfway
    //assign       cmd_controller_rout_update = 1'b1;
    // +-----------------------------------------------------
    // | The AVST_to_AXI only use for Write channel
    // +-----------------------------------------------------
	altera_mailbox_avst_to_axi_conversion #(
		.IN_ST_DATA_W  (75),
		.COMMAND_WIDTH (32),
		.RSP_ST_W      (32),
		.REQ_WIDTH     (38),
		.WAITING_TIME  (10),
		.ADDR_W        (32),
		.DATA_W        (32),
		.ID_W          (4),
		.USER_W        (5)
	) mailbox_avst_to_axi_conversion (
		.clk              (clk),                      
		.reset            (reset),                
		.in_valid         (mailbox_scheduler_src_valid),         
		.in_startofpacket (mailbox_scheduler_src_startofpacket), 
		.in_endofpacket   (mailbox_scheduler_src_endofpacket),   
		.in_ready         (mailbox_scheduler_src_ready),         
		.in_data          (mailbox_scheduler_src_data),          
		.aw_id            (axi_mstr_aw_id),               
		.aw_addr          (axi_mstr_aw_addr_internal),             
		.aw_len           (axi_mstr_aw_len),              
		.aw_size          (axi_mstr_aw_size),             
		.aw_burst         (axi_mstr_aw_burst),            
		.aw_lock          (axi_mstr_aw_lock),             
		.aw_cache         (axi_mstr_aw_cache),            
		.aw_prot          (axi_mstr_aw_prot),             
		.aw_qos           (axi_mstr_aw_qos),              
		.aw_valid         (axi_mstr_aw_valid),            
		.aw_user          (axi_mstr_aw_user),             
		.aw_ready         (axi_mstr_aw_ready),            
		.w_data           (axi_mstr_w_data),              
		.w_last           (axi_mstr_w_last),              
		.w_ready          (axi_mstr_w_ready),             
		.w_valid          (axi_mstr_w_valid),             
		.w_strb           (axi_mstr_w_strb),              
		.b_id             (axi_mstr_b_id),                
		.b_resp           (axi_mstr_b_resp),              
		.b_valid          (axi_mstr_b_valid),             
		.b_ready          (axi_mstr_b_ready),             
		.r_data           (32'h0),              
		.r_resp           (2'h0),              
		.r_last           (1'h0),              
		.r_valid          (1'b0),             
		.r_ready          (),             
		.ar_id            (),               
		.ar_addr          (),             
		.ar_len           (),              
		.ar_size          (),             
		.ar_burst         (),            
		.ar_lock          (),             
		.ar_cache         (),            
		.ar_prot          (),             
		.ar_qos           (),              
		.ar_valid         (),            
		.ar_user          (),             
		.ar_ready         (1'b0),            
		.r_id             (4'h0)                 
	);

	altera_mailbox_cmd_controller #(
		.COMMAND_WIDTH     (32),
		.REQ_WIDTH         (6),
		.WAITING_TIME      (50),
		.OUT_COMMAND_WIDTH (64)
	) mailbox_cmd_controller (
		.clk               (clk),                              
		.reset             (reset),                        
		.in_valid          (cmd_pck_valid),                               
		.in_startofpacket  (cmd_pck_startofpacket),                       
		.in_endofpacket    (cmd_pck_endofpacket),                         
		.in_ready          (cmd_pck_ready),                               
		.in_data           (cmd_pck_data),                                
		.out_endofpacket   (mailbox_cmd_controller_out_cmd_endofpacket),  
		.out_valid         (mailbox_cmd_controller_out_cmd_valid),        
		.out_startofpacket (mailbox_cmd_controller_out_cmd_startofpacket),
		.out_ready         (mailbox_cmd_controller_out_cmd_ready),        
		.out_data          (mailbox_cmd_controller_out_cmd_data),         
		.req_valid         (mailbox_cmd_controller_cmd_req_valid),        
		.req_ready         (mailbox_cmd_controller_cmd_req_ready),        
		.req_data          (mailbox_cmd_controller_cmd_req_data),         
		.gpo_write         (sdm_gpo_write_synced_pulse),          
		.gpo_data          (sdm_gpo_data),            
		.rout_update       (cmd_controller_rout_update)       
	);
    // +----------------------------------------------------------------
    // | The read controller is used to read response from mailbox FIFO
    // | only read channel active
    // +----------------------------------------------------------------
	altera_mailbox_read_controller #(
		.RSP_ST_W          (32),
		.REQ_WIDTH         (6),
		.ADDR_W            (32),
		.DATA_W            (32),
		.ID_W              (4),
		.USER_W            (5),
		.WSTRB_W           (8),
		.OUT_COMMAND_WIDTH (64)
	) mailbox_read_controller (
		.clk               (clk),                              
		.reset             (reset),                        
		.gpo_write         (sdm_gpo_write_synced_pulse),               
		.gpo_data          (sdm_gpo_data),                
		.out_ready         (rsp_pck_ready),                               
		.out_startofpacket (rsp_pck_startofpacket),                       
		.out_valid         (rsp_pck_valid),                               
		.out_endofpacket   (rsp_pck_endofpacket),                          
		.out_data          (rsp_pck_data),                                 
		.req_valid         (mailbox_read_controller_rout_update_req_valid),
		.req_ready         (mailbox_read_controller_rout_update_req_ready),
		.req_data          (mailbox_read_controller_rout_update_req_data), 
		.aw_id             (),                         
		.aw_addr           (),                       
		.aw_len            (),                         
		.aw_size           (),                        
		.aw_burst          (),                       
		.aw_lock           (),                        
		.aw_cache          (),                       
		.aw_prot           (),                        
		.aw_qos            (),                         
		.aw_valid          (),                       
		.aw_user           (),                        
		.aw_ready          (1'b0),                       
		.w_data            (),                         
		.w_strb            (),                         
		.w_last            (),                         
		.w_valid           (),                        
		.w_ready           (1'b0),                        
		.b_id              (4'h0),                           
		.b_resp            (2'h0),                         
		.b_valid           (1'b0),                        
		.b_ready           (),                        
		.ar_id             (axi_mstr_ar_id),                          
		.ar_addr           (axi_mstr_ar_addr_internal),                        
		.ar_len            (axi_mstr_ar_len),                         
		.ar_size           (axi_mstr_ar_size),                        
		.ar_burst          (axi_mstr_ar_burst),                       
		.ar_lock           (axi_mstr_ar_lock),                        
		.ar_cache          (axi_mstr_ar_cache),                       
		.ar_prot           (axi_mstr_ar_prot),                        
		.ar_qos            (axi_mstr_ar_qos),                         
		.ar_valid          (axi_mstr_ar_valid),                       
		.ar_user           (axi_mstr_ar_user),                        
		.r_id              (axi_mstr_r_id),                           
		.ar_ready          (axi_mstr_ar_ready),                       
		.r_data            (axi_mstr_r_data),                         
		.r_resp            (axi_mstr_r_resp),                         
		.r_last            (axi_mstr_r_last),                         
		.r_valid           (axi_mstr_r_valid),                        
		.r_ready           (axi_mstr_r_ready)                         
	);

	altera_mailbox_scheduler #(
		.IN_CMD_DATA_W (64),
		.IN_REQ_DATA_W (6),
		.IN_RD_DATA_W  (6),
		.IN_URG_DATA_W (32),
		.OUT_DATA_W    (75)
	) mailbox_scheduler (
		.clk               (clk),                                
		.reset             (reset),                          
		.src_endofpacket   (mailbox_scheduler_src_endofpacket),             
		.src_valid         (mailbox_scheduler_src_valid),                   
		.src_startofpacket (mailbox_scheduler_src_startofpacket),           
		.src_ready         (mailbox_scheduler_src_ready),                   
		.src_data          (mailbox_scheduler_src_data),                    
		.gpo_write         (sdm_gpo_write_synced_pulse),                       
		.gpo_data          (sdm_gpo_data),                        
		.cmd_valid         (mailbox_cmd_controller_out_cmd_valid),          
		.cmd_startofpacket (mailbox_cmd_controller_out_cmd_startofpacket),  
		.cmd_endofpacket   (mailbox_cmd_controller_out_cmd_endofpacket),    
		.cmd_ready         (mailbox_cmd_controller_out_cmd_ready),          
		.cmd_data          (mailbox_cmd_controller_out_cmd_data),           
		.urg_valid         (mailbox_urg_controller_out_data_valid),         
		.urg_startofpacket (mailbox_urg_controller_out_data_startofpacket), 
		.urg_endofpacket   (mailbox_urg_controller_out_data_endofpacket),   
		.urg_ready         (mailbox_urg_controller_out_data_ready),         
		.urg_data          (mailbox_urg_controller_out_data_data),          
		.cmd_req_valid     (mailbox_cmd_controller_cmd_req_valid),          
		.cmd_req_ready     (mailbox_cmd_controller_cmd_req_ready),          
		.cmd_req_data      (mailbox_cmd_controller_cmd_req_data),           
		.rd_req_valid      (mailbox_read_controller_rout_update_req_valid), 
		.rd_req_ready      (mailbox_read_controller_rout_update_req_ready), 
		.rd_req_data       (mailbox_read_controller_rout_update_req_data)   
	);

    // +-----------------------------------------------------
    // | The Streaming controller use AXI slave interface
    // +-----------------------------------------------------
	altera_mailbox_streaming_controller #(
		.STR_PCK_WIDTH (STREAM_WIDTH),
		.NUMB_4K_BLOCK (4),
		.GPI_WIDTH     (4),
		.ADDR_W        (32),
		.DATA_W        (64),
		.ID_W          (4),
		.USER_W        (5)
	) mailbox_streaming_controller (
		.clk               (clk),                              
		.reset             (reset),                        
		.gpo_write         (sdm_gpo_write_synced_pulse),          
		.gpo_data          (sdm_gpo_data),           
		.in_valid          (str_valid),          
		.in_startofpacket  (str_startofpacket),  
		.in_endofpacket    (str_endofpacket),    
		.in_ready          (str_ready),          
		.in_data           (str_data),           
		.gpi_data          (gpi_to_sdm),           
		.gpi_interrupt     (gpi_irq_str),         
		.stream_select     (str_select),
		.stream_active     (str_active),
		.aw_id             (axi_slv_aw_id),         
		.aw_addr           (axi_slv_aw_addr),       
		.aw_len            (axi_slv_aw_len),        
		.aw_size           (axi_slv_aw_size),       
		.aw_burst          (axi_slv_aw_burst),      
		.aw_lock           (axi_slv_aw_lock),       
		.aw_cache          (axi_slv_aw_cache),      
		.aw_prot           (axi_slv_aw_prot),       
		.aw_qos            (axi_slv_aw_qos),        
		.aw_valid          (axi_slv_aw_valid),      
		.aw_user           (axi_slv_aw_user),       
		.aw_ready          (axi_slv_aw_ready),      
		.w_data            (axi_slv_w_data),        
		.w_last            (axi_slv_w_last),        
		.w_ready           (axi_slv_w_ready),       
		.w_valid           (axi_slv_w_valid),       
		.w_strb            (axi_slv_w_strb),        
		.b_id              (axi_slv_b_id),          
		.b_resp            (axi_slv_b_resp),        
		.b_valid           (axi_slv_b_valid),       
		.b_ready           (axi_slv_b_ready),       
		.r_data            (axi_slv_r_data),        
		.r_resp            (axi_slv_r_resp),        
		.r_last            (axi_slv_r_last),        
		.r_valid           (axi_slv_r_valid),       
		.r_ready           (axi_slv_r_ready),       
		.ar_id             (axi_slv_ar_id),         
		.ar_addr           (axi_slv_ar_addr),       
		.ar_len            (axi_slv_ar_len),        
		.ar_size           (axi_slv_ar_size),       
		.ar_burst          (axi_slv_ar_burst),      
		.ar_lock           (axi_slv_ar_lock),       
		.ar_cache          (axi_slv_ar_cache),      
		.ar_prot           (axi_slv_ar_prot),       
		.ar_qos            (axi_slv_ar_qos),        
		.ar_valid          (axi_slv_ar_valid),      
		.ar_user           (axi_slv_ar_user),       
		.ar_ready          (axi_slv_ar_ready),      
		.r_id              (axi_slv_r_id)           
	);

	altera_mailbox_urg_controller #(
		.URG_PCK_WIDTH     (32),
		.USE_MEMORY_BLOCKS (1)
	) mailbox_urg_controller (
		.clk               (clk),                                
		.reset             (reset),                          
		.gpo_write         (sdm_gpo_write_synced_pulse),                  
		.gpo_data          (sdm_gpo_data),                   
		.out_valid         (mailbox_urg_controller_out_data_valid),         
		.out_startofpacket (mailbox_urg_controller_out_data_startofpacket), 
		.out_ready         (mailbox_urg_controller_out_data_ready),         
		.out_endofpacket   (mailbox_urg_controller_out_data_endofpacket),   
		.out_data          (mailbox_urg_controller_out_data_data),          
		.in_valid          (urg_pck_valid),                                 
		.in_startofpacket  (urg_pck_startofpacket),                         
		.in_endofpacket    (urg_pck_endofpacket),                           
		.in_ready          (urg_pck_ready),                                 
		.in_data           (urg_pck_data)                                   
	);

endmodule
