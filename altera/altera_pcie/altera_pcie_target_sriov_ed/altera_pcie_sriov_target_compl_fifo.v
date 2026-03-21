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



//  Outbound Completion FIFO for PCIe Target App

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module altera_pcie_sriov_target_compl_fifo # 
  (
   parameter port_width_data_hwtcl            = 256,
   parameter port_width_be_hwtcl              = 32,
   parameter multiple_packets_per_cycle_hwtcl = 0
                                         )
   (
    // Clock and Reset
    input                                           clk_i,
    input                                           rstn_i,

    // Completions from APP
    input [port_width_data_hwtcl-1:0]               app_st_data_i,
    output reg                                      app_st_ready_o, 
    input [multiple_packets_per_cycle_hwtcl:0]      app_st_sop_i,
    input [multiple_packets_per_cycle_hwtcl:0]      app_st_valid_i,
    input [1:0]                                     app_st_empty_i,
    input [multiple_packets_per_cycle_hwtcl:0]      app_st_eop_i,
    input [multiple_packets_per_cycle_hwtcl:0]      app_st_err_i,

    // Completions to HIP
    output reg [port_width_data_hwtcl-1:0]          hip_st_data_o,
    input                                           hip_st_ready_i,
    output reg [multiple_packets_per_cycle_hwtcl:0] hip_st_sop_o,
    output reg [multiple_packets_per_cycle_hwtcl:0] hip_st_valid_o,
    output reg [1:0]                                hip_st_empty_o,
    output reg [multiple_packets_per_cycle_hwtcl:0] hip_st_eop_o,
    output reg [multiple_packets_per_cycle_hwtcl:0] hip_st_err_o
    );

   localparam FIFO_WIDTH = port_width_data_hwtcl + // Data 
                           1 + multiple_packets_per_cycle_hwtcl + // SOP
                           1 + multiple_packets_per_cycle_hwtcl + // EOP
                           1 + multiple_packets_per_cycle_hwtcl + // Error
                           2; // Empty
   localparam FIFO_DEPTH = 16;
   
   // FIFO RAM array
   reg [FIFO_WIDTH-1:0]                             ram[FIFO_DEPTH-1:0];
   reg [3:0]                                        read_ptr, write_ptr;
   wire [FIFO_WIDTH-1:0]                            data_in;

   wire                       write_enable;
   wire                       fifo_full;
   wire                       fifo_almost_full;
   reg                        fifo_empty;
   wire                       read_enable;
   reg                        read_enable_reg;
   reg [4:0]                  fifo_word_count;

   reg [FIFO_WIDTH-1:0]       data_in_reg;
   reg                        data_in_valid_reg;
   reg [FIFO_WIDTH-1:0]       read_data_reg,
                              read_data_reg2;
   wire [FIFO_WIDTH-1:0]      read_data;
   reg                        read_data_valid;
   wire [port_width_be_hwtcl-1:0] read_parity;
   wire [multiple_packets_per_cycle_hwtcl:0] read_sop;
   wire [multiple_packets_per_cycle_hwtcl:0] read_eop;
   wire [multiple_packets_per_cycle_hwtcl:0] read_err;
   wire [1:0]                     read_empty;

   reg                            reg_ready_hip;


   assign                     data_in = {app_st_empty_i,
                                         app_st_err_i,
                                         app_st_eop_i,
                                         app_st_sop_i,
                                         app_st_data_i
                                         };
   
   assign fifo_full = (fifo_word_count == 5'd16);
   assign fifo_almost_full = (fifo_word_count >= 5'd6);

   
   //----------------------------------------------------------------------
   // Write side of FIFO
   //----------------------------------------------------------------------
   // Register input data
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
       data_in_valid_reg <= app_st_valid_i;

   assign write_enable = data_in_valid_reg & ~fifo_full;

      // Write pointer for FIFO
   always @(posedge clk_i)
     if (~rstn_i)
       write_ptr <= 4'd0;
     else if (write_enable)
       write_ptr <= write_ptr + 4'd1;

                         
   // Registers for RAM write address, data and write enable
   always @(posedge clk_i)
     if (write_enable)
       ram[write_ptr] <= data_in_reg;

   // Keep track of num of words in FIFO
   always @(posedge clk_i)
      if (~rstn_i)
        begin
           fifo_word_count <= 5'd0;
           fifo_empty <= 1'b1;
        end
      else if (write_enable & ~read_enable)
        begin
           fifo_word_count <= fifo_word_count + 5'd1;
           fifo_empty <= 1'b0;
        end
      else if (~write_enable & read_enable)
        begin
           fifo_word_count <= fifo_word_count - 5'd1;
           fifo_empty <= (fifo_word_count == 5'd1);
        end

   // De-assert ready to APP when FIFO is almost full

   always @(posedge clk_i)
     if (~rstn_i)
       app_st_ready_o <= 1'b1;
     else
       app_st_ready_o <= ~fifo_almost_full;

   //----------------------------------------------------------------------
   // Read side of FIFO
   //----------------------------------------------------------------------

   // Read pointer for FIFO
   always @(posedge clk_i)
    if (~rstn_i)
      read_ptr <= 4'd0;
     else if (read_enable)
       read_ptr <= read_ptr + 4'd1;

   // Read from RAM
   always @(posedge clk_i)
     read_data_reg <= ram[read_ptr];

   // Register ready from HIP
   always @(posedge clk_i)
     if (~rstn_i)
       reg_ready_hip <= 1'b1;
     else
       reg_ready_hip <= hip_st_ready_i;

   assign read_enable = ~fifo_empty & (~read_data_valid | reg_ready_hip);

   // Save read data for later delivery if the downstream logic applies backpressure
   always @(posedge clk_i)
     if (~rstn_i)
       begin
          read_data_reg2 <= {FIFO_WIDTH{1'b0}};
          read_enable_reg <= 1'b0;
       end
     else
       begin
          read_enable_reg <= read_enable;
          if (read_enable_reg)
            read_data_reg2 <= read_data_reg;
       end // else: !if(~rstn_i)
   
   assign read_data = read_enable_reg? read_data_reg : read_data_reg2;

   // Generate valid for read data
   always @(posedge clk_i)
     if (~rstn_i)
       read_data_valid <= 1'b0;
     else if (read_enable)
       read_data_valid <= 1'b1;
     else if (reg_ready_hip)
       read_data_valid <= 1'b0;

   // Output registers
   always @(posedge clk_i)
     if (~rstn_i)
       begin
          hip_st_data_o <= {port_width_data_hwtcl{1'b0}};
          hip_st_sop_o <= {multiple_packets_per_cycle_hwtcl+1{1'b0}};
          hip_st_eop_o <= {multiple_packets_per_cycle_hwtcl+1{1'b0}};
          hip_st_err_o <= {multiple_packets_per_cycle_hwtcl+1{1'b0}};
          hip_st_empty_o <= 2'b00;
       end
     else if (read_data_valid & reg_ready_hip)   
       begin
          hip_st_data_o <= read_data[port_width_data_hwtcl-1:0];
          hip_st_sop_o <=  read_data[port_width_data_hwtcl];
          hip_st_eop_o <=  read_data[port_width_data_hwtcl+1];
          hip_st_err_o <=  read_data[port_width_data_hwtcl+2];
          hip_st_empty_o <=  read_data[port_width_data_hwtcl+4:port_width_data_hwtcl+3];
       end

   always @(posedge clk_i)
     if (~rstn_i)
       hip_st_valid_o <= {multiple_packets_per_cycle_hwtcl+1{1'b0}};
     else
       hip_st_valid_o <= read_data_valid & reg_ready_hip;

 endmodule // altera_pcie_sriov_target_compl_fifo

