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


module altera_emif_ctrl_qdr4_cmd_scheduler #(
   parameter CTRL_RAW_TURNAROUND_DELAY_CYC = 3,
   parameter CTRL_WAR_TURNAROUND_DELAY_CYC = 10,
   parameter PORT_AFI_ADDR_WIDTH = 1,
   parameter PORT_AFI_LD_N_WIDTH = 1, 
   parameter PORT_AFI_RW_N_WIDTH = 1,
   parameter PORT_AFI_WDATA_VALID_WIDTH = 1,
   parameter PORT_AFI_WDATA_WIDTH = 1,
   parameter PORT_AFI_RDATA_EN_FULL_WIDTH = 1,
   parameter PORT_AFI_RDATA_WIDTH = 1,
   parameter PORT_AFI_RDATA_VALID_WIDTH = 1,
   parameter PORT_AFI_WDATA_DINV_WIDTH = 1,
   parameter PORT_AFI_AINV_WIDTH = 1,
   parameter NUM_OF_AVL_CHANNELS = 8,
   parameter CTRL_DATA_INV_ENA                       = 0,
   parameter CTRL_ADDR_INV_ENA                       = 0
) (
   input                                                                         clk,
   input                                                                         reset_n,
   
   input logic [PORT_AFI_ADDR_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_addr_0,
   input logic [PORT_AFI_LD_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_ld_n_0,
   input logic [PORT_AFI_RW_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_rw_n_0,
   input logic [PORT_AFI_WDATA_VALID_WIDTH/NUM_OF_AVL_CHANNELS-1:0]              afi_wdata_valid_0,
   input logic [PORT_AFI_WDATA_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                    afi_wdata_0,
   input logic [PORT_AFI_RDATA_EN_FULL_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_rdata_en_full_0,
   
   input logic [PORT_AFI_ADDR_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_addr_1,
   input logic [PORT_AFI_LD_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_ld_n_1,
   input logic [PORT_AFI_RW_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_rw_n_1,
   input logic [PORT_AFI_WDATA_VALID_WIDTH/NUM_OF_AVL_CHANNELS-1:0]              afi_wdata_valid_1,
   input logic [PORT_AFI_WDATA_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                    afi_wdata_1,
   input logic [PORT_AFI_RDATA_EN_FULL_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_rdata_en_full_1,
   
   input logic [PORT_AFI_ADDR_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_addr_2,
   input logic [PORT_AFI_LD_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_ld_n_2,
   input logic [PORT_AFI_RW_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_rw_n_2,
   input logic [PORT_AFI_WDATA_VALID_WIDTH/NUM_OF_AVL_CHANNELS-1:0]              afi_wdata_valid_2,
   input logic [PORT_AFI_WDATA_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                    afi_wdata_2,
   input logic [PORT_AFI_RDATA_EN_FULL_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_rdata_en_full_2,
   
   input logic [PORT_AFI_ADDR_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_addr_3,
   input logic [PORT_AFI_LD_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_ld_n_3,
   input logic [PORT_AFI_RW_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_rw_n_3,
   input logic [PORT_AFI_WDATA_VALID_WIDTH/NUM_OF_AVL_CHANNELS-1:0]              afi_wdata_valid_3,
   input logic [PORT_AFI_WDATA_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                    afi_wdata_3,
   input logic [PORT_AFI_RDATA_EN_FULL_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_rdata_en_full_3,
   
   input logic [PORT_AFI_ADDR_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_addr_4,
   input logic [PORT_AFI_LD_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_ld_n_4,
   input logic [PORT_AFI_RW_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_rw_n_4,
   input logic [PORT_AFI_WDATA_VALID_WIDTH/NUM_OF_AVL_CHANNELS-1:0]              afi_wdata_valid_4,
   input logic [PORT_AFI_WDATA_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                    afi_wdata_4,
   input logic [PORT_AFI_RDATA_EN_FULL_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_rdata_en_full_4,
   
   input logic [PORT_AFI_ADDR_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_addr_5,
   input logic [PORT_AFI_LD_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_ld_n_5,
   input logic [PORT_AFI_RW_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_rw_n_5,
   input logic [PORT_AFI_WDATA_VALID_WIDTH/NUM_OF_AVL_CHANNELS-1:0]              afi_wdata_valid_5,
   input logic [PORT_AFI_WDATA_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                    afi_wdata_5,
   input logic [PORT_AFI_RDATA_EN_FULL_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_rdata_en_full_5,
   
   input logic [PORT_AFI_ADDR_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_addr_6,
   input logic [PORT_AFI_LD_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_ld_n_6,
   input logic [PORT_AFI_RW_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_rw_n_6,
   input logic [PORT_AFI_WDATA_VALID_WIDTH/NUM_OF_AVL_CHANNELS-1:0]              afi_wdata_valid_6,
   input logic [PORT_AFI_WDATA_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                    afi_wdata_6,
   input logic [PORT_AFI_RDATA_EN_FULL_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_rdata_en_full_6,
   
   input logic [PORT_AFI_ADDR_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_addr_7,
   input logic [PORT_AFI_LD_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_ld_n_7,
   input logic [PORT_AFI_RW_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_rw_n_7,
   input logic [PORT_AFI_WDATA_VALID_WIDTH/NUM_OF_AVL_CHANNELS-1:0]              afi_wdata_valid_7,
   input logic [PORT_AFI_WDATA_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                    afi_wdata_7,
   input logic [PORT_AFI_RDATA_EN_FULL_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_rdata_en_full_7,
   
   output logic                                              wdata_request_0,
   output logic                                              wdata_request_1,
   output logic                                              wdata_request_2,
   output logic                                              wdata_request_3,
   output logic                                              wdata_request_4,
   output logic                                              wdata_request_5,
   output logic                                              wdata_request_6,
   output logic                                              wdata_request_7,
   
   output logic [PORT_AFI_ADDR_WIDTH-1:0]                     afi_addr,
   output logic [PORT_AFI_LD_N_WIDTH-1:0]                     afi_ld_n,
   output logic [PORT_AFI_RW_N_WIDTH-1:0]                     afi_rw_n,
   output logic [PORT_AFI_WDATA_VALID_WIDTH-1:0]              afi_wdata_valid,
   output logic [PORT_AFI_WDATA_WIDTH-1:0]                    afi_wdata,
   output logic [PORT_AFI_WDATA_DINV_WIDTH-1:0]               afi_wdata_dinv,
   output logic [PORT_AFI_AINV_WIDTH-1:0]                     afi_ainv,
   output logic [PORT_AFI_RDATA_EN_FULL_WIDTH-1:0]            afi_rdata_en_full,
   
   output logic                                               dequeue,
   
   input logic                                                queue_empty,
   
   output logic [NUM_OF_AVL_CHANNELS-1:0]                     next_dequeue_mask,
   
   input logic  [NUM_OF_AVL_CHANNELS-1:0]                     is_read_command,
   input logic  [NUM_OF_AVL_CHANNELS-1:0]                     is_write_command,
   input logic  [NUM_OF_AVL_CHANNELS-1:0]                     bank_violation
);
   timeunit 1ps;
   timeprecision 1ps;
   
   localparam WRITE_SHIFTER_WIDTH = (CTRL_RAW_TURNAROUND_DELAY_CYC >= 4) ? 4*(CTRL_RAW_TURNAROUND_DELAY_CYC/4+1) : NUM_OF_AVL_CHANNELS;
   localparam READ_SHIFTER_WIDTH = (CTRL_WAR_TURNAROUND_DELAY_CYC >= 4) ? 4*(CTRL_WAR_TURNAROUND_DELAY_CYC/4+1) : NUM_OF_AVL_CHANNELS;

   wire [PORT_AFI_ADDR_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                   afi_addr_in[NUM_OF_AVL_CHANNELS];
   wire [PORT_AFI_LD_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                   afi_ld_n_in[NUM_OF_AVL_CHANNELS];
   wire [PORT_AFI_RW_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                   afi_rw_n_in[NUM_OF_AVL_CHANNELS];
   wire [PORT_AFI_WDATA_VALID_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_wdata_valid_in[NUM_OF_AVL_CHANNELS];
   wire [PORT_AFI_WDATA_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                  afi_wdata_in[NUM_OF_AVL_CHANNELS];
   wire [PORT_AFI_RDATA_EN_FULL_WIDTH/NUM_OF_AVL_CHANNELS-1:0]          afi_rdata_en_full_in[NUM_OF_AVL_CHANNELS];
   wire [PORT_AFI_WDATA_DINV_WIDTH-1:0] invert_data;
   wire [PORT_AFI_AINV_WIDTH-1:0] invert_addr[NUM_OF_AVL_CHANNELS];
   
   wire [PORT_AFI_ADDR_WIDTH-1:0]                     afi_addr_wide[NUM_OF_AVL_CHANNELS];
   wire [PORT_AFI_LD_N_WIDTH-1:0]                     afi_ld_n_wide[NUM_OF_AVL_CHANNELS];
   wire [PORT_AFI_RW_N_WIDTH-1:0]                     afi_rw_n_wide[NUM_OF_AVL_CHANNELS];
   wire [PORT_AFI_WDATA_VALID_WIDTH-1:0]              afi_wdata_valid_wide[NUM_OF_AVL_CHANNELS];
   wire [PORT_AFI_WDATA_WIDTH-1:0]                    afi_wdata_wide[NUM_OF_AVL_CHANNELS];
   wire [PORT_AFI_WDATA_WIDTH-1:0]                    final_afi_wdata;
   wire [PORT_AFI_RDATA_EN_FULL_WIDTH-1:0]            afi_rdata_en_full_wide[NUM_OF_AVL_CHANNELS];
   
   logic [NUM_OF_AVL_CHANNELS-1:0] issue_cmd;
   
   logic [NUM_OF_AVL_CHANNELS-1:0] cur_nop_command;
   
   typedef enum int unsigned {
      IDLE,
      ISSUE_CMDS
   } cmd_state_t;
   
   cmd_state_t cmd_state;
   
   logic [WRITE_SHIFTER_WIDTH-1:0] prev_write_a;
   logic [WRITE_SHIFTER_WIDTH-1:0] prev_write_b;
   logic [READ_SHIFTER_WIDTH-1:0] prev_read_a;
   logic [READ_SHIFTER_WIDTH-1:0] prev_read_b;
   
   wire [3:0] cur_write_a;
   wire [3:0] cur_write_b;
   wire [3:0] cur_read_a;
   wire [3:0] cur_read_b;
   
   logic [CTRL_RAW_TURNAROUND_DELAY_CYC-1:0] write_history_vector[NUM_OF_AVL_CHANNELS-1:0];
   logic [CTRL_WAR_TURNAROUND_DELAY_CYC-1:0] read_history_vector[NUM_OF_AVL_CHANNELS-1:0];
   
   logic [NUM_OF_AVL_CHANNELS-1:0] turnaround_delay;
   
   logic [NUM_OF_AVL_CHANNELS-1:0] dequeue_mask;
   
   // This is done for convenience:
   // Assign all incoming per-channel AFI signals to two-dimensional vectors, so that
   // they can be used in generate statements throughout this block
   assign afi_addr_in[0] = afi_addr_0;
   assign afi_ld_n_in[0] = afi_ld_n_0;
   assign afi_rw_n_in[0] = afi_rw_n_0;
   assign afi_wdata_valid_in[0] = afi_wdata_valid_0;
   assign afi_wdata_in[0] = afi_wdata_0;
   assign afi_rdata_en_full_in[0] = afi_rdata_en_full_0;
   
   assign afi_addr_in[1] = afi_addr_1;
   assign afi_ld_n_in[1] = afi_ld_n_1;
   assign afi_rw_n_in[1] = afi_rw_n_1;
   assign afi_wdata_valid_in[1] = afi_wdata_valid_1;
   assign afi_wdata_in[1] = afi_wdata_1;
   assign afi_rdata_en_full_in[1] = afi_rdata_en_full_1;
   
   assign afi_addr_in[2] = afi_addr_2;
   assign afi_ld_n_in[2] = afi_ld_n_2;
   assign afi_rw_n_in[2] = afi_rw_n_2;
   assign afi_wdata_valid_in[2] = afi_wdata_valid_2;
   assign afi_wdata_in[2] = afi_wdata_2;
   assign afi_rdata_en_full_in[2] = afi_rdata_en_full_2;
   
   assign afi_addr_in[3] = afi_addr_3;
   assign afi_ld_n_in[3] = afi_ld_n_3;
   assign afi_rw_n_in[3] = afi_rw_n_3;
   assign afi_wdata_valid_in[3] = afi_wdata_valid_3;
   assign afi_wdata_in[3] = afi_wdata_3;
   assign afi_rdata_en_full_in[3] = afi_rdata_en_full_3;
   
   assign afi_addr_in[4] = afi_addr_4;
   assign afi_ld_n_in[4] = afi_ld_n_4;
   assign afi_rw_n_in[4] = afi_rw_n_4;
   assign afi_wdata_valid_in[4] = afi_wdata_valid_4;
   assign afi_wdata_in[4] = afi_wdata_4;
   assign afi_rdata_en_full_in[4] = afi_rdata_en_full_4;
   
   assign afi_addr_in[5] = afi_addr_5;
   assign afi_ld_n_in[5] = afi_ld_n_5;
   assign afi_rw_n_in[5] = afi_rw_n_5;
   assign afi_wdata_valid_in[5] = afi_wdata_valid_5;
   assign afi_wdata_in[5] = afi_wdata_5;
   assign afi_rdata_en_full_in[5] = afi_rdata_en_full_5;
   
   assign afi_addr_in[6] = afi_addr_6;
   assign afi_ld_n_in[6] = afi_ld_n_6;
   assign afi_rw_n_in[6] = afi_rw_n_6;
   assign afi_wdata_valid_in[6] = afi_wdata_valid_6;
   assign afi_wdata_in[6] = afi_wdata_6;
   assign afi_rdata_en_full_in[6] = afi_rdata_en_full_6;
   
   assign afi_addr_in[7] = afi_addr_7;
   assign afi_ld_n_in[7] = afi_ld_n_7;
   assign afi_rw_n_in[7] = afi_rw_n_7;
   assign afi_wdata_valid_in[7] = afi_wdata_valid_7;
   assign afi_wdata_in[7] = afi_wdata_7;
   assign afi_rdata_en_full_in[7] = afi_rdata_en_full_7;
   
   // Widen all per-channel output signals to full AFI widths before sending them
   // on the AFI bus
   generate
      genvar i;
      for (i = 0; i < NUM_OF_AVL_CHANNELS; i++)
      begin : afi_out_adjust_timeslot_gen
         altera_emif_ctrl_qdr4_afi_out_adjust_timeslot #(
            .PORT_AFI_ADDR_WIDTH (PORT_AFI_ADDR_WIDTH),
            .PORT_AFI_LD_N_WIDTH (PORT_AFI_LD_N_WIDTH),
            .PORT_AFI_RW_N_WIDTH (PORT_AFI_RW_N_WIDTH),
            .PORT_AFI_WDATA_VALID_WIDTH (PORT_AFI_WDATA_VALID_WIDTH),
            .PORT_AFI_WDATA_WIDTH (PORT_AFI_WDATA_WIDTH),
            .PORT_AFI_RDATA_EN_FULL_WIDTH (PORT_AFI_RDATA_EN_FULL_WIDTH),
            
            .NUM_OF_AVL_CHANNELS (NUM_OF_AVL_CHANNELS),
            .AVL_CHANNEL_NUM (i)
         ) afi_out_adjust_timeslot_inst (
            .afi_addr_in(afi_addr_in[i]),
            .afi_ld_n_in(afi_ld_n_in[i]),
            .afi_rw_n_in(afi_rw_n_in[i]),
            .afi_wdata_valid_in(afi_wdata_valid_in[i]),
            .afi_wdata_in(afi_wdata_in[i]),
            .afi_rdata_en_full_in(afi_rdata_en_full_in[i]),
            
            .afi_addr_out(afi_addr_wide[i]),
            .afi_ld_n_out(afi_ld_n_wide[i]),
            .afi_rw_n_out(afi_rw_n_wide[i]),
            .afi_wdata_valid_out(afi_wdata_valid_wide[i]),
            .afi_wdata_out(afi_wdata_wide[i]),
            .afi_rdata_en_full_out(afi_rdata_en_full_wide[i])
         );
      end
   endgenerate
   
   // Simple two-state FSM to control the issuing/dequeuing of commands
   always_ff @(posedge clk or negedge reset_n)
   begin
      if (!reset_n) begin
         cmd_state <= IDLE;
      end
      else
      begin
         case (cmd_state)
            IDLE:
            begin
               cmd_state <= (queue_empty) ? IDLE : ISSUE_CMDS;
            end
            
            ISSUE_CMDS:
            begin
               if (next_dequeue_mask == '0 && queue_empty)
                  cmd_state <= IDLE;
               else
                  cmd_state <= ISSUE_CMDS;
            end
         endcase
      end
   end
   
   // Classify the current pending commands. For convenience, split them into A/B channels,
   // since there is no turnaround delay requirement between channels.
   // Channels 0,2,4,6 correspond to cur_*_a[3:0]
   // Channels 1,3,5,7 correspond to cur_*_b[3:0]
   // The order of the bits is reversed to represent time correctly in the shift register
   generate
      for (i = 0; i < NUM_OF_AVL_CHANNELS; i++)
      begin : cur_cmd_type_gen
         if (i % 2 == 0) begin
            assign cur_write_a[ (NUM_OF_AVL_CHANNELS - i) / 2 - 1 ] = is_write_command[i];
            assign cur_read_a[ (NUM_OF_AVL_CHANNELS - i) / 2 - 1 ] = is_read_command[i];
         end else begin
            assign cur_write_b[ (NUM_OF_AVL_CHANNELS - i) / 2 ] = is_write_command[i];
            assign cur_read_b[ (NUM_OF_AVL_CHANNELS - i) / 2 ] = is_read_command[i];
         end
         
         assign cur_nop_command[i] = (afi_ld_n_in[i] == '1);
      end
   endgenerate
   
   // Keep track of all read and write commands issued within the turnaround window (which depends
   // on the specified WAR and RAW turnaround delays) by inserting the current commands into a
   // shift register
   always_ff @(posedge clk or negedge reset_n)
   begin
      if (!reset_n) begin
         prev_write_a <= '0;
         prev_write_b <= '0;
         prev_read_a <= '0;
         prev_read_b <= '0;
      end else begin
         prev_write_a <= {prev_write_a[WRITE_SHIFTER_WIDTH-5:0], cur_write_a[3] & issue_cmd[0], cur_write_a[2] & issue_cmd[2], cur_write_a[1] & issue_cmd[4], cur_write_a[0] & issue_cmd[6]};
         prev_write_b <= {prev_write_b[WRITE_SHIFTER_WIDTH-5:0], cur_write_b[3] & issue_cmd[1], cur_write_b[2] & issue_cmd[3], cur_write_b[1] & issue_cmd[5], cur_write_b[0] & issue_cmd[7]};
         prev_read_a <= {prev_read_a[READ_SHIFTER_WIDTH-5:0], cur_read_a[3] & issue_cmd[0], cur_read_a[2] & issue_cmd[2], cur_read_a[1] & issue_cmd[4], cur_read_a[0] & issue_cmd[6]};
         prev_read_b <= {prev_read_b[READ_SHIFTER_WIDTH-5:0], cur_read_b[3] & issue_cmd[1], cur_read_b[2] & issue_cmd[3], cur_read_b[1] & issue_cmd[5], cur_read_b[0] & issue_cmd[7]};
      end
   end
   
   // Turnaround delay:
   // Create the write and read history vectors, which allow the scheduler to look for
   // read/write commands issued in the past (for each channel) and determine whether
   // to delay the issuing of pending commands
   generate
      assign write_history_vector[0] = prev_write_a[CTRL_RAW_TURNAROUND_DELAY_CYC-1:0];
      assign write_history_vector[1] = prev_write_b[CTRL_RAW_TURNAROUND_DELAY_CYC-1:0];
      
      if (CTRL_RAW_TURNAROUND_DELAY_CYC > 1) begin
         assign write_history_vector[2] = {cur_write_a[3], prev_write_a[CTRL_RAW_TURNAROUND_DELAY_CYC-2:0]};
         assign write_history_vector[3] = {cur_write_b[3], prev_write_b[CTRL_RAW_TURNAROUND_DELAY_CYC-2:0]};
      end else begin
         assign write_history_vector[2] = cur_write_a[3];
         assign write_history_vector[3] = cur_write_b[3];
      end
      
      if (CTRL_RAW_TURNAROUND_DELAY_CYC > 2) begin
         assign write_history_vector[4] = {cur_write_a[3:2], prev_write_a[CTRL_RAW_TURNAROUND_DELAY_CYC-3:0]};
         assign write_history_vector[5] = {cur_write_b[3:2], prev_write_b[CTRL_RAW_TURNAROUND_DELAY_CYC-3:0]};
      end else if (CTRL_RAW_TURNAROUND_DELAY_CYC == 2) begin
         assign write_history_vector[4] = cur_write_a[3:2];
         assign write_history_vector[5] = cur_write_b[3:2];
      end else begin
         assign write_history_vector[4] = cur_write_a[2];
         assign write_history_vector[5] = cur_write_b[2];
      end
      
      if (CTRL_RAW_TURNAROUND_DELAY_CYC > 3) begin
         assign write_history_vector[6] = {cur_write_a[3:1], prev_write_a[CTRL_RAW_TURNAROUND_DELAY_CYC-4:0]};
         assign write_history_vector[7] = {cur_write_b[3:1], prev_write_b[CTRL_RAW_TURNAROUND_DELAY_CYC-4:0]};
      end else if (CTRL_RAW_TURNAROUND_DELAY_CYC == 3) begin
         assign write_history_vector[6] = cur_write_a[3:1];
         assign write_history_vector[7] = cur_write_b[3:1];
      end else if (CTRL_RAW_TURNAROUND_DELAY_CYC == 2) begin
         assign write_history_vector[6] = cur_write_a[2:1];
         assign write_history_vector[7] = cur_write_b[2:1];
      end else begin
         assign write_history_vector[6] = cur_write_a[1];
         assign write_history_vector[7] = cur_write_b[1];
      end
      
      assign read_history_vector[0] = prev_read_a[CTRL_WAR_TURNAROUND_DELAY_CYC-1:0];
      assign read_history_vector[1] = prev_read_b[CTRL_WAR_TURNAROUND_DELAY_CYC-1:0];
      
      if (CTRL_WAR_TURNAROUND_DELAY_CYC > 1) begin
         assign read_history_vector[2] = {cur_read_a[3], prev_read_a[CTRL_WAR_TURNAROUND_DELAY_CYC-2:0]};
         assign read_history_vector[3] = {cur_read_b[3], prev_read_b[CTRL_WAR_TURNAROUND_DELAY_CYC-2:0]};
      end else begin
         assign read_history_vector[2] = cur_read_a[3];
         assign read_history_vector[3] = cur_read_b[3];
      end
      
      if (CTRL_WAR_TURNAROUND_DELAY_CYC > 2) begin
         assign read_history_vector[4] = {cur_read_a[3:2], prev_read_a[CTRL_WAR_TURNAROUND_DELAY_CYC-3:0]};
         assign read_history_vector[5] = {cur_read_b[3:2], prev_read_b[CTRL_WAR_TURNAROUND_DELAY_CYC-3:0]};
      end else if (CTRL_WAR_TURNAROUND_DELAY_CYC == 2) begin
         assign read_history_vector[4] = cur_read_a[3:2];
         assign read_history_vector[5] = cur_read_b[3:2];
      end else begin
         assign read_history_vector[4] = cur_read_a[2];
         assign read_history_vector[5] = cur_read_b[2];
      end
      
      if (CTRL_WAR_TURNAROUND_DELAY_CYC > 3) begin
         assign read_history_vector[6] = {cur_read_a[3:1], prev_read_a[CTRL_WAR_TURNAROUND_DELAY_CYC-4:0]};
         assign read_history_vector[7] = {cur_read_b[3:1], prev_read_b[CTRL_WAR_TURNAROUND_DELAY_CYC-4:0]};
      end else if (CTRL_WAR_TURNAROUND_DELAY_CYC == 3) begin
         assign read_history_vector[6] = cur_read_a[3:1];
         assign read_history_vector[7] = cur_read_b[3:1];
      end else if (CTRL_WAR_TURNAROUND_DELAY_CYC == 2) begin
         assign read_history_vector[6] = cur_read_a[2:1];
         assign read_history_vector[7] = cur_read_b[2:1];
      end else begin
         assign read_history_vector[6] = cur_read_a[1];
         assign read_history_vector[7] = cur_read_b[1];
      end
   endgenerate
   
   // Turnaround delay:
   // Delay the issuing of a channel's command if a previous opposite command (e.g. write in case of read)
   // was issued in the turnaround window in the past (the size of the window is determined by the width
   // of the history vector, which depends on the specified turnaround delays)
   generate
      for (i = 0; i < NUM_OF_AVL_CHANNELS; i++)
      begin : turnaround_delay_gen
         assign turnaround_delay[i] = (
            ( is_read_command[i] && CTRL_RAW_TURNAROUND_DELAY_CYC > 0 && write_history_vector[i] != '0 ) ||
            ( is_write_command[i] && CTRL_WAR_TURNAROUND_DELAY_CYC > 0 && read_history_vector[i] != '0 )
         );
      end
   endgenerate
   
   // The dequeue mask ensures round-robin scheduling:
   // Commands that were already issued (or skipped if not valid, i.e. NOP) will be masked out in the
   // following AFI cycles, until the whole mask consists solely of 0's, in which case the next
   // command can be dequeued from the FIFO
   
   assign next_dequeue_mask = { ~(issue_cmd[7] | cur_nop_command[7]),
                                ~(issue_cmd[6] | cur_nop_command[6]),
                                ~(issue_cmd[5] | cur_nop_command[5]),
                                ~(issue_cmd[4] | cur_nop_command[4]),
                                ~(issue_cmd[3] | cur_nop_command[3]),
                                ~(issue_cmd[2] | cur_nop_command[2]),
                                ~(issue_cmd[1] | cur_nop_command[1]),
                                ~(issue_cmd[0] | cur_nop_command[0]) }
                              & dequeue_mask;

   always_ff @(posedge clk or negedge reset_n)
   begin
      if (!reset_n)
         dequeue_mask <= '1;
      else begin
         if (cmd_state != ISSUE_CMDS || dequeue) begin
            dequeue_mask <= '1;
         end else begin
            dequeue_mask <= next_dequeue_mask;
         end
      end
   end
   
   // Round-robin command scheduling:
   // Issue a command if it is a valid (non-NOP) command, does not cause turnaround or banking violations,
   // and is not masked out, ONLY IF all previous valid commands were either issued or masked out
   generate
      for (i = 0; i < NUM_OF_AVL_CHANNELS; i++)
      begin : issue_cmd_gen
         if (i == 0) begin
            assign issue_cmd[i] = (cmd_state == ISSUE_CMDS) &
                                  ~cur_nop_command[i] & ~turnaround_delay[i] & ~bank_violation[i] &
                                  dequeue_mask[i];
         end else begin
            assign issue_cmd[i] = (cmd_state == ISSUE_CMDS) &
                                  ~cur_nop_command[i] & ~turnaround_delay[i] & ~bank_violation[i] &
                                  dequeue_mask[i] &
                                  ( issue_cmd[i-1] | cur_nop_command[i-1] | ~dequeue_mask[i-1] );
         end
      end
   endgenerate
   
   assign final_afi_wdata = afi_wdata_wide[0] | afi_wdata_wide[1] | afi_wdata_wide[2] |
                      afi_wdata_wide[3] | afi_wdata_wide[4] | afi_wdata_wide[5] |
                      afi_wdata_wide[6] | afi_wdata_wide[7];
   
   generate
      if (CTRL_DATA_INV_ENA) begin        
         altera_emif_ctrl_qdr4_dinv_write_block_calc_if_inv #(
            .DATA_WIDTH (PORT_AFI_WDATA_WIDTH),
            .DINV_WIDTH (PORT_AFI_WDATA_DINV_WIDTH)
         ) dinv_write_block_inst (
            .data_in(final_afi_wdata),
            .invert_data(invert_data)
         );
      end else begin
         assign invert_data = '0;
      end
   endgenerate
   generate
      genvar j;
      for (j = 0; j < NUM_OF_AVL_CHANNELS; j++)
         begin : calc_addr_inv_per_channel
         if (CTRL_ADDR_INV_ENA) begin        
            altera_emif_ctrl_qdr4_ainv_block_calc_if_inv #(
               .ADDR_WIDTH (PORT_AFI_ADDR_WIDTH),
               .AINV_WIDTH (PORT_AFI_AINV_WIDTH)
            ) ainv_write_block_inst (
               .addr_in(afi_addr_wide[j]),
               .ap_in('b0),
               .invert_addr(invert_addr[j])
            );
         end else begin
            assign invert_addr[j] = '0;
         end
      end
   endgenerate
   // Issue commands in the next cycle (this improves C2P timing)
   always_ff @(posedge clk or negedge reset_n)
   begin
      if (!reset_n) begin
         afi_addr <= '0;
         afi_ld_n <= '1;
         afi_rw_n <= '1;
         afi_rdata_en_full <= '0;
         
         afi_wdata_valid <= '0;
         afi_wdata <= '0;
      end else begin
         afi_addr <= (~issue_cmd[0] ? {{PORT_AFI_ADDR_WIDTH}{1'b0}} : afi_addr_wide[0]) |
                     (~issue_cmd[1] ? {{PORT_AFI_ADDR_WIDTH}{1'b0}} : afi_addr_wide[1]) |
                     (~issue_cmd[2] ? {{PORT_AFI_ADDR_WIDTH}{1'b0}} : afi_addr_wide[2]) |
                     (~issue_cmd[3] ? {{PORT_AFI_ADDR_WIDTH}{1'b0}} : afi_addr_wide[3]) |
                     (~issue_cmd[4] ? {{PORT_AFI_ADDR_WIDTH}{1'b0}} : afi_addr_wide[4]) |
                     (~issue_cmd[5] ? {{PORT_AFI_ADDR_WIDTH}{1'b0}} : afi_addr_wide[5]) |
                     (~issue_cmd[6] ? {{PORT_AFI_ADDR_WIDTH}{1'b0}} : afi_addr_wide[6]) |
                     (~issue_cmd[7] ? {{PORT_AFI_ADDR_WIDTH}{1'b0}} : afi_addr_wide[7]);
                     
         afi_ld_n <= 16'b1111111111111111 &
                     (~issue_cmd[0] ? {{PORT_AFI_LD_N_WIDTH}{1'b1}} : afi_ld_n_wide[0]) &
                     (~issue_cmd[1] ? {{PORT_AFI_LD_N_WIDTH}{1'b1}} : afi_ld_n_wide[1]) &
                     (~issue_cmd[2] ? {{PORT_AFI_LD_N_WIDTH}{1'b1}} : afi_ld_n_wide[2]) &
                     (~issue_cmd[3] ? {{PORT_AFI_LD_N_WIDTH}{1'b1}} : afi_ld_n_wide[3]) &
                     (~issue_cmd[4] ? {{PORT_AFI_LD_N_WIDTH}{1'b1}} : afi_ld_n_wide[4]) &
                     (~issue_cmd[5] ? {{PORT_AFI_LD_N_WIDTH}{1'b1}} : afi_ld_n_wide[5]) &
                     (~issue_cmd[6] ? {{PORT_AFI_LD_N_WIDTH}{1'b1}} : afi_ld_n_wide[6]) &
                     (~issue_cmd[7] ? {{PORT_AFI_LD_N_WIDTH}{1'b1}} : afi_ld_n_wide[7]);
                     
         afi_rw_n <= 16'b1111111111111111 &
                     (~issue_cmd[0] ? {{PORT_AFI_RW_N_WIDTH}{1'b1}} : afi_rw_n_wide[0]) &
                     (~issue_cmd[1] ? {{PORT_AFI_RW_N_WIDTH}{1'b1}} : afi_rw_n_wide[1]) &
                     (~issue_cmd[2] ? {{PORT_AFI_RW_N_WIDTH}{1'b1}} : afi_rw_n_wide[2]) &
                     (~issue_cmd[3] ? {{PORT_AFI_RW_N_WIDTH}{1'b1}} : afi_rw_n_wide[3]) &
                     (~issue_cmd[4] ? {{PORT_AFI_RW_N_WIDTH}{1'b1}} : afi_rw_n_wide[4]) &
                     (~issue_cmd[5] ? {{PORT_AFI_RW_N_WIDTH}{1'b1}} : afi_rw_n_wide[5]) &
                     (~issue_cmd[6] ? {{PORT_AFI_RW_N_WIDTH}{1'b1}} : afi_rw_n_wide[6]) &
                     (~issue_cmd[7] ? {{PORT_AFI_RW_N_WIDTH}{1'b1}} : afi_rw_n_wide[7]);
                     
         afi_rdata_en_full <= (~issue_cmd[0] ? {{PORT_AFI_RDATA_EN_FULL_WIDTH}{1'b0}} : afi_rdata_en_full_wide[0]) |
                              (~issue_cmd[1] ? {{PORT_AFI_RDATA_EN_FULL_WIDTH}{1'b0}} : afi_rdata_en_full_wide[1]) |
                              (~issue_cmd[2] ? {{PORT_AFI_RDATA_EN_FULL_WIDTH}{1'b0}} : afi_rdata_en_full_wide[2]) |
                              (~issue_cmd[3] ? {{PORT_AFI_RDATA_EN_FULL_WIDTH}{1'b0}} : afi_rdata_en_full_wide[3]) |
                              (~issue_cmd[4] ? {{PORT_AFI_RDATA_EN_FULL_WIDTH}{1'b0}} : afi_rdata_en_full_wide[4]) |
                              (~issue_cmd[5] ? {{PORT_AFI_RDATA_EN_FULL_WIDTH}{1'b0}} : afi_rdata_en_full_wide[5]) |
                              (~issue_cmd[6] ? {{PORT_AFI_RDATA_EN_FULL_WIDTH}{1'b0}} : afi_rdata_en_full_wide[6]) |
                              (~issue_cmd[7] ? {{PORT_AFI_RDATA_EN_FULL_WIDTH}{1'b0}} : afi_rdata_en_full_wide[7]);
         
         // The following signals are used to output write data to the PHY;
         // They come directly from the Avalon FSM when write data is requested by
         // the command scheduler and after the correct AFI write latency has elapsed
         
         afi_wdata_valid <= afi_wdata_valid_wide[0] | afi_wdata_valid_wide[1] | afi_wdata_valid_wide[2] |
                            afi_wdata_valid_wide[3] | afi_wdata_valid_wide[4] | afi_wdata_valid_wide[5] |
                            afi_wdata_valid_wide[6] | afi_wdata_valid_wide[7];
                            
         afi_wdata <= final_afi_wdata;
         afi_wdata_dinv <= invert_data;
         afi_ainv <= 8'b11111111 &
                     (~issue_cmd[0] ? {{PORT_AFI_AINV_WIDTH}{1'b1}} : invert_addr[0]) &
                     (~issue_cmd[1] ? {{PORT_AFI_AINV_WIDTH}{1'b1}} : invert_addr[1]) &
                     (~issue_cmd[2] ? {{PORT_AFI_AINV_WIDTH}{1'b1}} : invert_addr[2]) &
                     (~issue_cmd[3] ? {{PORT_AFI_AINV_WIDTH}{1'b1}} : invert_addr[3]) &
                     (~issue_cmd[4] ? {{PORT_AFI_AINV_WIDTH}{1'b1}} : invert_addr[4]) &
                     (~issue_cmd[5] ? {{PORT_AFI_AINV_WIDTH}{1'b1}} : invert_addr[5]) &
                     (~issue_cmd[6] ? {{PORT_AFI_AINV_WIDTH}{1'b1}} : invert_addr[6]) &
                     (~issue_cmd[7] ? {{PORT_AFI_AINV_WIDTH}{1'b1}} : invert_addr[7]);
      end
   end
   
   assign dequeue = ( (cmd_state == IDLE) || (cmd_state == ISSUE_CMDS && next_dequeue_mask == '0) ) && !queue_empty;
   
   // Request the next write data from the Avalon FSM block, which
   // contains the write data FIFO and handles wlat (AFI write latency);
   // Note that these signals are asserted one cycle before the command is sent
   // on the AFI bus, since they are not registered
   assign wdata_request_0 = (issue_cmd[0] && afi_rw_n_in[0] != '1);
   assign wdata_request_1 = (issue_cmd[1] && afi_rw_n_in[1] != '1);
   assign wdata_request_2 = (issue_cmd[2] && afi_rw_n_in[2] != '1);
   assign wdata_request_3 = (issue_cmd[3] && afi_rw_n_in[3] != '1);
   assign wdata_request_4 = (issue_cmd[4] && afi_rw_n_in[4] != '1);
   assign wdata_request_5 = (issue_cmd[5] && afi_rw_n_in[5] != '1);
   assign wdata_request_6 = (issue_cmd[6] && afi_rw_n_in[6] != '1);
   assign wdata_request_7 = (issue_cmd[7] && afi_rw_n_in[7] != '1);
endmodule
