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



//  Inbound Request FIFO for PCIe Target App

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module altera_pcie_sriov_target_req_fifo # 
  (
   parameter port_width_data_hwtcl            = 256,
   parameter port_width_be_hwtcl              = 32,
   parameter multiple_packets_per_cycle_hwtcl = 0
					 )
   (
    // Clock and Reset
    input 					clk_i,
    input 					rstn_i,

    // Data from HIP
    input [port_width_data_hwtcl-1:0] 		      hip_st_data_i,
    output reg 					                        hip_st_ready_o, 
    input [multiple_packets_per_cycle_hwtcl:0] 	hip_st_sop_i,
    input [multiple_packets_per_cycle_hwtcl:0] 	hip_st_valid_i,
    input [1:0] 				                        hip_st_empty_i,
    input [multiple_packets_per_cycle_hwtcl:0] 	hip_st_eop_i,
    input [multiple_packets_per_cycle_hwtcl:0] 	hip_st_err_i,
    input [7:0] 				                        hip_st_bar_hit_fn_i,
    input [7:0]                                 hip_st_bar_hit_tlp0_i, // BAR hit information for first TLP in this cycle


    // Data to APP
    output [port_width_data_hwtcl-1:0] 		      app_st_data_o,
    input 					                            app_st_ready_i,
    output [multiple_packets_per_cycle_hwtcl:0] app_st_sop_o,
    output reg [multiple_packets_per_cycle_hwtcl:0] app_st_valid_o,
    output [1:0] 				                        app_st_empty_o,
    output [multiple_packets_per_cycle_hwtcl:0] app_st_eop_o,
    output [multiple_packets_per_cycle_hwtcl:0] app_st_err_o,
    output [7:0] 				                        app_st_bar_hit_fn_o,
    output [7:0] 				                        app_st_bar_hit_tlp0_o
    );

   localparam FIFO_WIDTH = port_width_data_hwtcl + // Data 
			   1 + multiple_packets_per_cycle_hwtcl + // SOP
			   1 + multiple_packets_per_cycle_hwtcl + // EOP
			   1 + multiple_packets_per_cycle_hwtcl + // Error
			   2 + // Empty
			   8 + // BAR hit Function number
         8;  // BAR hit of this function in first TLP 
   localparam FIFO_DEPTH = 4;
   
   // FIFO RAM array
   reg [FIFO_WIDTH-1:0]   ram[FIFO_DEPTH-1:0];
   reg [1:0] 					    read_ptr, write_ptr;
   wire [FIFO_WIDTH-1:0] 	data_in;

   wire 		              write_enable;
   wire 		              fifo_full;
   reg 			              fifo_empty;
   wire 		              read_enable;
   reg 			              read_enable_reg;
   reg 			              ram_read_data_valid;
   reg 			              read_in_progress;
   reg [2:0] 		          fifo_word_count;

   reg [FIFO_WIDTH-1:0]   data_in_reg;
   reg 			              data_in_valid_reg;

   // RAM input registers
   reg [1:0] 		          ram_write_addr_reg;
   reg [FIFO_WIDTH-1:0]   ram_write_data_reg;
   reg 			              ram_write_en_reg;
   reg [1:0] 		          ram_read_addr_reg;
   reg [FIFO_WIDTH-1:0]   ram_read_data_reg;
   reg 			              ram_read_en_reg;

   wire [FIFO_WIDTH-1:0]  mux_out_data;
   wire 		              mux_data_valid;

   reg [FIFO_WIDTH-1:0]   out_data_reg;
   reg 			              out_data_valid;


   assign data_in = { hip_st_bar_hit_tlp0_i,
                      hip_st_bar_hit_fn_i,
						 					hip_st_empty_i,
                      hip_st_err_i,
						 					hip_st_eop_i,
						 					hip_st_sop_i,
						 					hip_st_data_i
						 					};
   
   assign fifo_full = (fifo_word_count == 3'd4);

   // Register input data and valid
   always @(posedge clk_i)
     if (~rstn_i)
       data_in_reg <= {FIFO_WIDTH{1'b0}};
     else
       data_in_reg <= data_in;
     
   // Register valid
   always @(posedge clk_i)
     if (~rstn_i)
	      data_in_valid_reg <= 1'b0;
     else
	      data_in_valid_reg <= hip_st_valid_i[0];

   //----------------------------------------------------------------------
   // Write side of FIFO
   //----------------------------------------------------------------------
      // Write pointer for FIFO
   always @(posedge clk_i)
     if (~rstn_i)
       write_ptr <= 2'd0;
     else if (write_enable)
       write_ptr <= write_ptr + 2'd1;

   // Write the incoming data into RAM when the downstream pipeline stage is not ready to accept the data 
   assign write_enable =  data_in_valid_reg & ~fifo_full &
			                  ((app_st_valid_o[0] & ~app_st_ready_i) |
			                    read_enable | read_in_progress);
			 
   // Registers for RAM write address, data and write enable
   always @(posedge clk_i)
     begin
	      ram_write_addr_reg <= write_ptr;
	      ram_write_data_reg <= data_in_reg;
	      ram_write_en_reg <= write_enable;
     end

   // RAM write
   always @(posedge clk_i)
     if (ram_write_en_reg)
       ram[ram_write_addr_reg] <= ram_write_data_reg;

   // Keep track of num of words in FIFO
   always @(posedge clk_i)
      if (~rstn_i)
	      begin
	        fifo_word_count <= 3'd0;
	        fifo_empty <= 1'b1;
	      end
      else if (write_enable & ~ram_read_data_valid)
	      begin
	        fifo_word_count <= fifo_word_count + 3'd1;
	        fifo_empty <= 1'b0;
	      end
      else if (~write_enable & ram_read_data_valid)
	      begin
	        fifo_word_count <= fifo_word_count - 3'd1;
	        fifo_empty <= (fifo_word_count == 3'd1);
	      end

   //----------------------------------------------------------------------
   // Read side of FIFO
   //----------------------------------------------------------------------

   // Read pointer for FIFO
   always @(posedge clk_i)
    if (~rstn_i)
      read_ptr <= 2'd0;
     else if (read_enable)
       read_ptr <= read_ptr + 2'd1;
   
   // Registers for RAM read address and read enable
   always @(posedge clk_i)
     begin
	      ram_read_addr_reg <= read_ptr;
	      ram_read_en_reg <= read_enable;
     end

   // RAM read
   always @(posedge clk_i)
     if  (ram_read_en_reg)
       ram_read_data_reg <= ram[ ram_read_addr_reg];
   
   // Keep track of a read in progress (read pipeline is 2 cycles long)
   always @(posedge clk_i)
      if (~rstn_i)
	      begin
	        read_enable_reg <= 1'b0;
	        read_in_progress <= 1'b0;
	      end
      else
	      begin
	        read_enable_reg <= read_enable;
	        read_in_progress <= read_enable | read_enable_reg;
	      end

   // Generate data valid for read.
   // Data is valid 2 cycles after initiating a read. 
   always @(posedge clk_i)
      if (~rstn_i)
	      ram_read_data_valid <= 1'b0;
      else
	      ram_read_data_valid <= read_enable_reg;

   // Generate read enable

   assign read_enable = ~fifo_empty & ~read_in_progress &
			(~app_st_valid_o[0] | app_st_ready_i);
   //----------------------------------------------------------------------

   // Mux the incoming data and the data from the RAM
   assign mux_out_data    =  fifo_empty? data_in_reg       : ram_read_data_reg;
   assign mux_data_valid  =  fifo_empty? data_in_valid_reg : ram_read_data_valid;
   
   // Generate ready to HIP
   always @(posedge clk_i)
     if (~rstn_i)
       hip_st_ready_o <= 1'b1;
     else
       // Assert ready when (i) FIFO is empty, AND 
       //  (ii) either the output register is empty or the downstream ready is high.
       hip_st_ready_o <= fifo_empty & ~read_in_progress &
			                   (~app_st_valid_o[0] | app_st_ready_i);
   
   // Output register
   always @(posedge clk_i)
     if (~rstn_i)
       out_data_reg <= {FIFO_WIDTH{1'b0}};
     else if (mux_data_valid & 
	           (~app_st_valid_o[0] | app_st_ready_i))
       out_data_reg <= mux_out_data;
   
   always @(posedge clk_i)
     if (~rstn_i)
       app_st_valid_o <= {multiple_packets_per_cycle_hwtcl+1{1'b0}};
     else
       if (~app_st_valid_o[0] | app_st_ready_i)
	     app_st_valid_o[0] <= mux_data_valid;
   
     assign app_st_data_o       = out_data_reg[port_width_data_hwtcl-1:0];
     assign app_st_sop_o        = out_data_reg[port_width_data_hwtcl];
     assign app_st_eop_o        = out_data_reg[port_width_data_hwtcl+1];
     assign app_st_err_o        = out_data_reg[port_width_data_hwtcl+2];
     assign app_st_empty_o      = out_data_reg[port_width_data_hwtcl+4: 
                                               port_width_data_hwtcl+3];
     assign app_st_bar_hit_fn_o = out_data_reg[port_width_data_hwtcl+12:
					                                     port_width_data_hwtcl+5];
     assign app_st_bar_hit_tlp0_o = out_data_reg[port_width_data_hwtcl+20:
					                                     port_width_data_hwtcl+13];

  endmodule // altera_pcie_sriov_target_req_fifo


