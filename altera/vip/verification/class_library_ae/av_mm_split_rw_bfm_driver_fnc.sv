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







// debug info
localparam INFO_WRITE = 1;
localparam INFO_READ = 1;

// MM-interface
localparam MEM_SYMBOLWIDTH = 8;
localparam MEM_NUMSYMBOLS = 16;
localparam BURST_TARGET = 16;
localparam MEM_DATA_WIDTH = MEM_SYMBOLWIDTH * MEM_NUMSYMBOLS;
localparam INTERNAL_MEM_DWIDTH = MEM_DATA_WIDTH * BURST_TARGET;

localparam MEM_WORD_ADDRESSING = 10;
localparam MEM_BURST_WIDTH = 6;
localparam MEM_BYTEENABLE_WIDTH = MEM_DATA_WIDTH / MEM_SYMBOLWIDTH;
localparam MM_RESPONSE_QUEUE_SIZE = 16;
localparam MEM_ADDR_WIDTH = 32;
localparam READ_LATENCY_CYCLES = 4;
localparam WRITE_MAX_WAIT_TIME_INC = 2;
localparam READ_MAX_WAIT_TIME = 8;
localparam MEM_SIZE = 32'h10000000;





// required pre-defined variable:
// MM_SINK
// MM_DRV_NAME
// MEM_ADDR_WIDTH, MEM_DATA_WIDTH, INTERNAL_MEM_DWIDTH, MEM_WORD_ADDRESSING, MEM_BURST_WIDTH, MEM_BYTEENABLE_WIDTH, BURST_TARGET
// READ_LATENCY_CYCLES, READ_LATENCY_CYCLES, READ_MAX_WAIT_TIME, MM_RESPONSE_QUEUE_SIZE
// INFO_WRITE, INFO_READ, VERBOSITY


`define create_name(__prefix, __suffix) __prefix``__suffix

`define WRITE_FUNC      `create_name(`MM_DRV_NAME, _write_internal_mem)
`define READ_FUNC       `create_name(`MM_DRV_NAME, _read_internal_mem)
`define POP_GET_WR_CMD_FUNC     `create_name(`MM_DRV_NAME, wr__av_mm_slave_pop_and_get_command)
`define POP_GET_RD_CMD_FUNC     `create_name(`MM_DRV_NAME, rd__av_mm_slave_pop_and_get_command)
`define ACCEPT_READ_CMD_FUNC `create_name(`MM_DRV_NAME, _av_mm_slave_accept_read_command)
`define ACCEPT_WRITE_CMD_FUNC `create_name(`MM_DRV_NAME, _av_mm_slave_accept_wrtie_command)

`define INTERNAL_MEM    `create_name(`MM_DRV_NAME, _internal_mem)
`define SEQ_CTR         `create_name(`MM_DRV_NAME, set_wait_req_counter)

initial
  $display ("\nAV_MM_SPLIT_RW_BFM_DRIVER_FNC : WARNING - Altera Edition simulator cannot instance sufficient RAM for artefact-free operation.");

reg [INTERNAL_MEM_DWIDTH-1:0] internal_mem [0:80000]; // 256 bytes = 1 32beat burst


// ===========================================================
// server for sink BFM models

//this task pops the master request from queue and extract the request information from the WRITE BFM
task `POP_GET_WR_CMD_FUNC;
   output Request_t request;
   output [MEM_ADDR_WIDTH-1:0] address;
   output [INTERNAL_MEM_DWIDTH-1:0] data;
   output [MEM_BURST_WIDTH-1:0] burst;
   output [MEM_BYTEENABLE_WIDTH*BURST_TARGET-1:0] byteenable;
begin
   `MM_SINK_WR.pop_command();
   request = `MM_SINK_WR.get_command_request();
   address = `MM_SINK_WR.get_command_address();
   burst = `MM_SINK_WR.get_command_burst_count();
   byteenable = 0;

   if (request==REQ_WRITE) begin
      for (int i=0; i<burst; i++)
      begin
         byteenable[i*MEM_BYTEENABLE_WIDTH +: MEM_BYTEENABLE_WIDTH] = `MM_SINK_WR.get_command_byte_enable(i);
         data[i*MEM_DATA_WIDTH +: MEM_DATA_WIDTH] = `MM_SINK_WR.get_command_data(i);
      end
   end

end

endtask

//this task pops the master request from queue and extract the request information from the READ BFM
task `POP_GET_RD_CMD_FUNC;
   output Request_t request;
   output [MEM_ADDR_WIDTH-1:0] address;
   output [INTERNAL_MEM_DWIDTH-1:0] data;
   output [MEM_BURST_WIDTH-1:0] burst;
   output [MEM_BYTEENABLE_WIDTH*BURST_TARGET-1:0] byteenable;
begin
   `MM_SINK_RD.pop_command();
   request = `MM_SINK_RD.get_command_request();
   address = `MM_SINK_RD.get_command_address();
   burst = `MM_SINK_RD.get_command_burst_count();


   if (request==REQ_WRITE) begin
      for (int i=0; i<burst; i++)
      begin
         byteenable[i*MEM_BYTEENABLE_WIDTH +: MEM_BYTEENABLE_WIDTH] = `MM_SINK_RD.get_command_byte_enable(i);
         data[i*MEM_DATA_WIDTH +: MEM_DATA_WIDTH] = `MM_SINK_RD.get_command_data(i);
      end
   end

end

endtask



//this task sets a response as a result of master read request and push it back to the master
task `ACCEPT_READ_CMD_FUNC;
   input [MEM_BURST_WIDTH-1:0] burst;
   input [MEM_ADDR_WIDTH-1:0] address;

   int i,j;
   string message_display;
   logic [MEM_DATA_WIDTH-1:0] data;
   logic [INTERNAL_MEM_DWIDTH*2-1:0] data_merged;
   logic [MEM_ADDR_WIDTH-1:0] word_addr;
   logic [MEM_WORD_ADDRESSING-1:0] mem_word_offset;
   logic [8192-1:0] entire_1kbyte_page_data;
   integer offset;

   int waitlen;
begin


   for (i=0; i<burst; i++) // eg. 16 or 32 beats
       `MM_SINK_RD.set_response_data(internal_mem[address][i*MEM_DATA_WIDTH +: MEM_DATA_WIDTH], i);   // put out the bits of one beat


   `MM_SINK_RD.set_response_latency(READ_LATENCY_CYCLES, 0); //index zero
   `MM_SINK_RD.set_response_burst_size(burst);
   `MM_SINK_RD.push_response();

   `MM_SINK_RD.set_interface_wait_time(3,0);

   // avoid scheduling clashes between back-to-back accesses
   repeat (waitlen+burst) @ (posedge (av_mm_clk));

end

endtask


int `SEQ_CTR = 0;

//this task sets a response as a result of master write request and update the internal mem
task `ACCEPT_WRITE_CMD_FUNC;
   input logic [MEM_ADDR_WIDTH-1:0] address;
   input logic [INTERNAL_MEM_DWIDTH-1:0] data;
   input logic [MEM_BURST_WIDTH-1:0] burst;
   input logic [MEM_BYTEENABLE_WIDTH*BURST_TARGET-1:0] byteenable;

   integer z, i;
   integer resp_time;
   string message_display;
   logic [MEM_ADDR_WIDTH-1:0] mem_addr;
   logic [MEM_WORD_ADDRESSING-1:0] mem_word_offset;
   integer offset;
begin

  internal_mem[address] = data;


   // set wait time
   `SEQ_CTR = `SEQ_CTR + 1;
   resp_time = 1;

   if ((`SEQ_CTR % 3) == 0) begin
      for (z=0;z<burst;z++) begin
         `MM_SINK_WR.set_interface_wait_time(3,z);
      end
   end else begin
      for (z=0;z<burst;z++) begin
         `MM_SINK_WR.set_interface_wait_time(resp_time,z);
      end
   end


end // sink_packet_writer_avalon_mm_writes
endtask



// Avalon-MM BFM driver :
always @(posedge av_mm_clk)
begin : av_mm_bfm_driver

   Request_t request;
   logic [MEM_ADDR_WIDTH-1:0] address;
   logic [INTERNAL_MEM_DWIDTH-1:0] data;
   logic [MEM_BURST_WIDTH-1:0] burst;
   logic [MEM_BYTEENABLE_WIDTH*BURST_TARGET-1:0] byteenable;
   reg   arbitrate_rd_wrn;

   string message_display;
   static int response_queue_size = MM_RESPONSE_QUEUE_SIZE;

   //mm_snk_queue_size = `MM_SINK.get_command_queue_size();

   if ((address + burst*MEM_DATA_WIDTH) >= MEM_SIZE) begin
       $error("%t AV-MM Master access at address %h is past the end of the memory model" , $time, address);
   end

   if (av_mm_rst == 1) begin
       arbitrate_rd_wrn <= 0;
   end else if (av_mm_rst == 0 && (response_queue_size == 0) && `MM_SINK_WR.get_command_queue_size() > 0 &&
                (arbitrate_rd_wrn == 0 || `MM_SINK_RD.get_command_queue_size() == 0))
   begin
       arbitrate_rd_wrn <= 1;
       `POP_GET_WR_CMD_FUNC(request, address, data, burst, byteenable);
       if (INFO_WRITE) begin
         //  $sformat(message_display, "AV-MM Master request a write to address %h , burst length %d" , address, burst);
         //  print(VERBOSITY_INFO, message_display);
       end

       `ACCEPT_WRITE_CMD_FUNC(address, data, burst, byteenable);

       response_queue_size = MM_RESPONSE_QUEUE_SIZE;

   end else if (av_mm_rst == 0 && (response_queue_size == 0) && `MM_SINK_RD.get_command_queue_size() > 0 &&
                (arbitrate_rd_wrn == 1 || `MM_SINK_WR.get_command_queue_size() == 0))
   begin
       arbitrate_rd_wrn <= 0;
       `POP_GET_RD_CMD_FUNC(request, address, data, burst, byteenable);
       if (INFO_READ) begin
         //  $sformat(message_display, "AV-MM Master request a read from address %h , burst length %d", address, burst);
        //   print(VERBOSITY_INFO, message_display);
       end

       `ACCEPT_READ_CMD_FUNC(burst, address);

       response_queue_size = MM_RESPONSE_QUEUE_SIZE;

   end else begin
       if (response_queue_size > 0)
       response_queue_size = response_queue_size - 1;
   end

end

