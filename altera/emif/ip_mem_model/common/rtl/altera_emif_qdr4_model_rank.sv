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


module altera_emif_qdr4_model_rank # (
   // Memory device specific parameters, they are set according to the memory spec.
   parameter PORT_MEM_A_WIDTH                = 1, 
   
   parameter PORT_MEM_DK_WIDTH               = 1, 
   parameter PORT_MEM_QK_WIDTH               = 1, 
   parameter PORT_MEM_DQ_WIDTH               = 1, 
   parameter PORT_MEM_DINV_WIDTH             = 1,
   
   parameter MEM_TRL_CYC                     = 8,
   parameter MEM_TWL_CYC                     = 5,
   
   parameter MEM_BL                          = 2,
   
   parameter MEM_DQS_TO_CLK_CAPTURE_DELAY    = 0,
   parameter MEM_CLK_TO_DQS_CAPTURE_DELAY    = 0,

   parameter MEM_GUARANTEED_WRITE_INIT       = 0,
   parameter MEM_DEPTH_IDX                   = -1,
   parameter MEM_WIDTH_IDX                   = -1,

   parameter MEM_VERBOSE                     = 1,
   parameter MEM_STOP_ON_AP_ERROR            = 1,
   
   parameter MEM_DATA_INV_ENA                = 1
) (
   input    logic                            mem_ck,        // Address/command input clock.
   input    logic                            mem_ck_n,      // Address/command input clock. Pseudo differential version of mem_ck.
   input    logic [PORT_MEM_A_WIDTH-1:0]     mem_a,         // Memory address.
   input    logic                            mem_ap,        // Address parity input.
   output   logic                            mem_pe_n,      // Address parity error flag.
   input    logic                            mem_ainv,      // Address bus invert.
   
   input    logic [PORT_MEM_DK_WIDTH-1:0]     mem_dka,         // Data input clock, port A.
   input    logic [PORT_MEM_DK_WIDTH-1:0]     mem_dka_n,       // Data input clock, port A. Pseudo differential version of mem_dka.
   input    logic [PORT_MEM_DK_WIDTH-1:0]     mem_dkb,         // Data input clock, port B.
   input    logic [PORT_MEM_DK_WIDTH-1:0]     mem_dkb_n,       // Data input clock, port B. Pseudo differential version of mem_dkb.
   
   output   logic [PORT_MEM_QK_WIDTH-1:0]     mem_qka,         // Data output clock, port A.
   output   logic [PORT_MEM_QK_WIDTH-1:0]     mem_qka_n,       // Data output clock, port A. Pseudo differential version of mem_qka.
   output   logic [PORT_MEM_QK_WIDTH-1:0]     mem_qkb,         // Data output clock, port B.
   output   logic [PORT_MEM_QK_WIDTH-1:0]     mem_qkb_n,       // Data output clock, port B. Pseudo differential version of mem_qkb.
   
   inout    tri   [PORT_MEM_DQ_WIDTH-1:0]     mem_dqa,         // Data, port A.
   inout    tri   [PORT_MEM_DQ_WIDTH-1:0]     mem_dqb,         // Data, port B.
   
   inout    tri   [PORT_MEM_DINV_WIDTH-1:0]   mem_dinva,       // Data bus invert, port A.
   inout    tri   [PORT_MEM_DINV_WIDTH-1:0]   mem_dinvb,       // Data bus invert, port B.
   
   input    logic                             mem_lda_n,       // Synchronous load input (command enable), port A.
   input    logic                             mem_ldb_n,       // Synchronous load input (command enable), port B.
   
   input    logic                             mem_rwa_n,       // Synchronous read/write input, port A.
   input    logic                             mem_rwb_n,       // Synchronous read/write input, port B.
   
   input    logic                             mem_cfg_n,       // Configuration bit.
   
   input    logic                             mem_reset_n,     // Asynchronous reset.
   
   input    logic                             mem_lbk0_n,       // Loopback mode bit 0.
   input    logic                             mem_lbk1_n       // Loopback mode bit 1.
);
   timeunit 1ps;
   timeprecision 1ps;
   
// ******************************************************************************************************************************** 
// BEGIN LOCALPARAMS SECTION

// The number of DQ pins per DK capture group.
localparam DQ_PER_DK = PORT_MEM_DQ_WIDTH / PORT_MEM_DK_WIDTH;

// The number of DQ pins per DINV pin.
localparam DQ_PER_DINV = PORT_MEM_DQ_WIDTH / PORT_MEM_DINV_WIDTH;

// The maximum latency possible for any configuration.
// This is used only to size command queues.
localparam MAX_LATENCY = 10;

// The maximum burst possible for any configuration.
// This is used to size burst counters.
localparam MAX_BURST = 2;

// The number of bits used for the bank address; assumed to be
// the LSB of the address bus.
localparam BANK_ADDR_WIDTH = 3;

// Ignore incoming commands for the first IGNORE_CMDS_INIT_CYCLES cycles.
// Set to 5 because initially the PHY's I/O registers may not be properly
// flushed and may be sending out bogus command. The PHY is expected to
// subsequently perform device initialization.
localparam IGNORE_CMDS_INIT_CYCLES = 0;

// Reset deasserted to first active command (number of cycles)
//FIXME: This should actually be 400000
localparam T_RSH = 40;

// The number of zeroes in a data group that causes the data bus to be
// inverted (if data bus inversion is enabled)
localparam INV_THRESHOLD_ZERO_COUNT = DQ_PER_DINV / 2 + 1;

// Loopback latency (cycles)
localparam T_LBL = 16;

// Loopback data width (i.e. number of signals that can be looped back
// per LBK setting)
localparam LOOPBACK_DATA_WIDTH = 13;

// Constants used to conveniently differentiate ports A and B;
// used for reporting.
string PORT_A = "Port A";
string PORT_B = "Port B";

// END LOCALPARAMS SECTION
// ********************************************************************************************************************************  

// synthesis translate_off

// Internal variables for memory parameters based on configuration
int tRL_cycles;
int tWL_cycles;
int tRW_delta_cycles;

// Clock cycle counter (global)
int clock_cycle;

// Clock cycle counter (cycles since last reset)
int t_rsh_clock_cycle;

// Indicates whether data bus inversion is enabled
int dbi_enabled;

// Indicates whether address bus inversion is enabled
int abi_enabled;

// Indicates whether address parity is enabled
int ap_enabled;

// Indicates whether write training is enabled
int wt_enabled;

// The actual memory. Modeled as an associative array.
logic [PORT_MEM_DQ_WIDTH-1:0] mem_data[*];

// The address of the memory array (mem_data). We make this
// a packed struct so that it can be used directly as the
// index to mem_data. 
typedef struct packed {
   bit [PORT_MEM_A_WIDTH-1:0] address;
   bit [MAX_BURST-1:0] burst_num;
} address_burst_type;

// Command struct of possible memory commands
typedef enum {
   NOP_COMMAND,
   READ_A_COMMAND,
   READ_B_COMMAND,
   WRITE_A_COMMAND,
   WRITE_B_COMMAND,
   CFG_WRITE_COMMAND
} command_type;

// Structure of memory operations. This includes the memory command
// and the address it operates on.
typedef struct {
   command_type command;
   int word_count;
   bit [PORT_MEM_A_WIDTH-1:0] address;
   bit addr_parity_error;
} command_struct;

// Create a variable for the current active command on each port
command_struct active_command_a;
command_struct active_command_b;

// Create a variable for the current active read command's read
// data (if applicable), which is read from the read_data_pipeline
// and ensures correct write-after-read behaviour.
logic [(PORT_MEM_DQ_WIDTH*MEM_BL)-1:0] active_command_read_data_a;
logic [(PORT_MEM_DQ_WIDTH*MEM_BL)-1:0] active_command_read_data_b;

// Create a variable for the new command being created
command_struct new_command;

// Create a variable for the last port A command issues;
// this is used to check for port B banking violations
command_struct last_port_a_command;

// This holds the value of the mem_pe_n signal, which indicates
// an address parity error; it is a latch, because once asserted,
// it stays asserted until cleared by a configuration write
reg mem_pe_n_latch;

// Command pipelines to ensure read/write latency is met
command_type command_pipeline[2*MAX_LATENCY-1:0];
int word_count_pipeline[2*MAX_LATENCY-1:0];
bit [PORT_MEM_A_WIDTH-1:0] address_pipeline[2*MAX_LATENCY-1:0];
bit [2*MAX_LATENCY-1:0] addr_parity_error_pipeline;

// Read data pipeline to ensure correct write-after-read
// behaviour due to read/write latency differences.
logic [(PORT_MEM_DQ_WIDTH*MEM_BL)-1:0] read_data_pipeline[2*MAX_LATENCY-1:0];

// Loopback pipeline, used to delay each looped back signal
// by the loopback latency (T_LBL).
logic [LOOPBACK_DATA_WIDTH-1:0] loopback_pipeline[2*T_LBL-1:0];

// Internal version of mem_qk;
wire mem_qka_int;
wire mem_qkb_int;

// Internal versions of mem_dq and mem_dinv
reg [PORT_MEM_DQ_WIDTH-1:0]   mem_dqa_int;
reg [PORT_MEM_DQ_WIDTH-1:0]   mem_dqb_int;
reg [PORT_MEM_DINV_WIDTH-1:0] mem_dinva_int;
reg [PORT_MEM_DINV_WIDTH-1:0] mem_dinvb_int;
bit mem_dqa_en;
bit mem_dqb_en;

// Registered versions of dq and dinv captured on dk clock
reg [PORT_MEM_DQ_WIDTH - 1:0]    mem_dqa_captured;
reg [PORT_MEM_DQ_WIDTH - 1:0]    mem_dqb_captured;
reg [PORT_MEM_DINV_WIDTH - 1:0]  mem_dinva_captured;
reg [PORT_MEM_DINV_WIDTH - 1:0]  mem_dinvb_captured;

// Versions of DQ after the data bus inversion feature (inverted if enabled)
reg [PORT_MEM_DQ_WIDTH-1:0]   mem_dqa_inv_out;
reg [PORT_MEM_DQ_WIDTH-1:0]   mem_dqb_inv_out;
reg [PORT_MEM_DQ_WIDTH-1:0]   mem_dqa_inv_in;
reg [PORT_MEM_DQ_WIDTH-1:0]   mem_dqb_inv_in;

// Versions of address and address parity after the address bus inversion feature (inverted if enabled)
reg [PORT_MEM_A_WIDTH-1:0]   mem_a_inv_in;
reg                          mem_ap_inv_in;

time mem_ck_time;
time mem_dka_time[PORT_MEM_DK_WIDTH];
time mem_dkb_time[PORT_MEM_DK_WIDTH];

// Internal version of mem_ck is based on a pseudo differential clock
logic mem_ck_int;
always @(posedge mem_ck)   mem_ck_int <= mem_ck;
always @(posedge mem_ck_n) mem_ck_int <= ~mem_ck_n;

// Internal versions of mem_dk are based on a pseudo differential clock
logic [PORT_MEM_DK_WIDTH-1:0] mem_dka_int;
logic [PORT_MEM_DK_WIDTH-1:0] mem_dkb_int;

// Temporary variables used to pre-load read data several cycles before
// a read command completes, to ensure correct write-after-read behaviour.
int burst_count;
logic [(PORT_MEM_DQ_WIDTH*MEM_BL)-1:0] read_data_reg;

generate
   genvar i;
   for (i = 0; i < PORT_MEM_DK_WIDTH; i++) begin
      always @(posedge mem_dka[i])   mem_dka_int[i] <= mem_dka[i];
      always @(posedge mem_dka_n[i]) mem_dka_int[i] <= ~mem_dka_n[i];
      
      always @(posedge mem_dkb[i])   mem_dkb_int[i] <= mem_dkb[i];
      always @(posedge mem_dkb_n[i]) mem_dkb_int[i] <= ~mem_dkb_n[i];
   end
endgenerate

// Capture dq and dinv on internal dk
generate
   for (i = 0; i < PORT_MEM_DK_WIDTH; i++) begin
      always @(posedge mem_dka[i] or posedge mem_dka_n[i])
      begin
         mem_dka_time[i] <= $time;
         if (dbi_enabled) begin
            mem_dinva_captured[i] <= mem_dinva[i];
         end   
      end
      
      always @(posedge mem_dkb[i] or posedge mem_dkb_n[i]) begin
         mem_dkb_time[i] <= $time;
         if (dbi_enabled) begin
            mem_dinvb_captured[i] <= mem_dinvb[i];
         end   
      end
   
      always @(posedge mem_dka[i] or posedge mem_dka_n[i]) begin
         mem_dqa_captured[(i+1) * DQ_PER_DK - 1 : i * DQ_PER_DK] = mem_dqa[(i+1) * DQ_PER_DK - 1 : i * DQ_PER_DK];
      end
      
      always @(posedge mem_dkb[i] or posedge mem_dkb_n[i]) begin
         mem_dqb_captured[(i+1) * DQ_PER_DK - 1 : i * DQ_PER_DK] = mem_dqb[(i+1) * DQ_PER_DK - 1 : i * DQ_PER_DK];
      end
   end
endgenerate

// Generate output buffer data, and invert it if data bus inversion is enabled
// and the number of 0's in a data group exceeds a threshold; do not invert in loopback mode
generate
   int ones_count_a[PORT_MEM_DINV_WIDTH-1:0];
   for (i = 0; i < PORT_MEM_DINV_WIDTH; i++) begin
      always @(*) begin
         count_ones_in_dinv_group(mem_dqa_int[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV], ones_count_a[i]);
         if (ones_count_a[i] <= (DQ_PER_DINV - INV_THRESHOLD_ZERO_COUNT) && dbi_enabled && !(mem_lbk0_n === 1'b0 || mem_lbk1_n === 1'b0)) begin
            mem_dqa_inv_out[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV] = ~mem_dqa_int[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV];
            mem_dinva_int[i] <= 1'b1;
         end else begin
            mem_dqa_inv_out[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV] = mem_dqa_int[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV];
            mem_dinva_int[i] <= 1'b0;
         end
      end
   end
   
   int ones_count_b[PORT_MEM_DINV_WIDTH-1:0];
   for (i = 0; i < PORT_MEM_DINV_WIDTH; i++) begin
      always @(*) begin
         count_ones_in_dinv_group(mem_dqb_int[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV], ones_count_b[i]);
         if (ones_count_b[i] <= (DQ_PER_DINV - INV_THRESHOLD_ZERO_COUNT) && dbi_enabled && !(mem_lbk0_n === 1'b0 || mem_lbk1_n === 1'b0)) begin
            mem_dqb_inv_out[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV] = ~mem_dqb_int[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV];
            mem_dinvb_int[i] <= 1'b1;
         end else begin
            mem_dqb_inv_out[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV] = mem_dqb_int[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV];
            mem_dinvb_int[i] <= 1'b0;
         end
      end
   end
endgenerate

// Generate input buffer data, and invert it if data bus inversion is enabled
// and the DINV signal is asserted; do not invert in loopback mode
generate
   for (i = 0; i < PORT_MEM_DINV_WIDTH; i++) begin
      always @(*) begin
         if (dbi_enabled && !(mem_lbk0_n === 1'b0 || mem_lbk1_n === 1'b0)) begin
            if (MEM_DQS_TO_CLK_CAPTURE_DELAY > 0)
               mem_dqa_inv_in[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV] = (mem_dinva_captured[i]) ? ~mem_dqa_captured[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV] : mem_dqa_captured[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV];
            else
               mem_dqa_inv_in[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV] = (mem_dinva[i]) ? ~mem_dqa[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV] : mem_dqa[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV];
         end else begin
            if (MEM_DQS_TO_CLK_CAPTURE_DELAY > 0)
               mem_dqa_inv_in[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV] = mem_dqa_captured[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV];
            else
               mem_dqa_inv_in[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV] = mem_dqa[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV];
         end
      end
   end
   
   for (i = 0; i < PORT_MEM_DINV_WIDTH; i++) begin
      always @(*) begin
         if (dbi_enabled && !(mem_lbk0_n === 1'b0 || mem_lbk1_n === 1'b0)) begin
            if (MEM_DQS_TO_CLK_CAPTURE_DELAY > 0)
               mem_dqb_inv_in[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV] = (mem_dinvb_captured[i]) ? ~mem_dqb_captured[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV] : mem_dqb_captured[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV];
            else
               mem_dqb_inv_in[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV] = (mem_dinvb[i]) ? ~mem_dqb[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV] : mem_dqb[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV];
         end else begin
            if (MEM_DQS_TO_CLK_CAPTURE_DELAY > 0)
               mem_dqb_inv_in[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV] = mem_dqb_captured[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV];
            else
               mem_dqb_inv_in[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV] = mem_dqb[(i+1) * DQ_PER_DINV - 1 : i * DQ_PER_DINV];
         end
      end
   end
endgenerate

// Generate input address, and invert it if address bus inversion is enabled
// and the AINV signal is asserted;
// Note: During reset and configuration commands, mem_a is used directly because
// inversion is ignored.
always @(*) begin
   if (abi_enabled) begin
      mem_a_inv_in = (mem_ainv) ? ~mem_a : mem_a;
      mem_ap_inv_in = (mem_ainv) ? ~mem_ap : mem_ap;
   end else begin
      mem_a_inv_in = mem_a;
      mem_ap_inv_in = mem_ap;
   end
end

// ******************************************************************************************************************************** 
// BEGIN TASKS AND FUNCTIONS SECTION

// Task: count_ones_in_dinv_group
// Parameters:
//      bits  : The dinv data group bit vector to check
//      count    : The number of 1's in the bit vector
// Description: Counts the number of 1's in the given data group bit vector
task count_ones_in_dinv_group(
   input [DQ_PER_DINV:0] bits,
   output int count);
   
   int i;
   int tmp_count;
   
   tmp_count = 0;
   for (i = 0; i < DQ_PER_DINV; i++) begin
      tmp_count = tmp_count + bits[i];
   end
   
   count = tmp_count;
endtask

// Task: init_model
// Description: Initializes all memory model pipelines and variables
//     to a clean state. Executed at the very beginning, and upon reset.
task automatic init_model;
   int i;
   
   // Reset configuration variables
   dbi_enabled = 0;
   abi_enabled = 0;
   ap_enabled = 0;
   wt_enabled = 0;
   
   // Deassert the address parity error signal
   mem_pe_n_latch = 1'b1;
   
   // Delete the memory
   mem_data.delete();
   

   // Make the active command a NOP
   active_command_a.command <= NOP_COMMAND;
   active_command_b.command <= NOP_COMMAND;
   
   // Initialize the active read command preloaded data
   active_command_read_data_a <= 'x;
   active_command_read_data_b <= 'x;
   
   // Clear the command pipelines
   for (i = 0; i < 2*MAX_LATENCY; i++) begin
      command_pipeline[i] = NOP_COMMAND;
      word_count_pipeline[i] = 0;
      address_pipeline[i] = 'x;
      read_data_pipeline[i] = {{PORT_MEM_DQ_WIDTH*MEM_BL}{1'bx}};
   end
   
   for (i = 0; i < 2*T_LBL; i++)
      loopback_pipeline[i] = {{LOOPBACK_DATA_WIDTH}{1'bz}};
   
endtask

// Task: set_cfg_reg_0
// Parameters:
//     cfg : The configuration bits for the Termination Control Register.
// Description: Sets the Termination Control Register settings (register 0).
task automatic set_cfg_reg_0 (input bit [7:0] cfg);
   $display("      Clock Input Group KU mode is set to %0h", cfg[2:0]);
   $display("      Address/Command Input Group IU mode is set to %0h", cfg[5:3]);
   
   if (cfg[6])
      $display("      ODT/ZQ Auto Update mode is set to ON");
   else
      $display("      ODT/ZQ Auto Update mode is set to OFF");
      
   if (cfg[7])
      $display("      ODT Global Enable mode is set to ON");
   else
      $display("      ODT Global Enable mode is set to OFF");
endtask

// Task: set_cfg_reg_1
// Parameters:
//     cfg : The configuration bits for the Impedance Control Register.
// Description: Sets the Impedance Control Register settings (register 1).
task automatic set_cfg_reg_1 (input bit [7:0] cfg);
   $display("      Data Input Group QU mode is set to %0h", cfg[2:0]);
   $display("      Pull Up Group PU mode is set to %0h", cfg[5:4]);
   $display("      Pull Down Group PD mode is set to %0h", cfg[7:6]);
endtask

// Task: set_cfg_reg_2
// Parameters:
//     cfg : The configuration bits for the Option Control Register.
//     is_reset : Set if invoked due to reset (and not a CFG command),
//       which causes errors to become warnings.
// Description: Sets the Option Control Register settings (register 2).
task automatic set_cfg_reg_2 (input bit [7:0] cfg, input bit is_reset);
   case (cfg[1:0])
      2'b11 : begin
         if (MEM_VERBOSE)
            $display("      Port Enable mode is set to Both Ports Enabled");
      end
      default : begin
         if (is_reset)
            $display("[%0t] [DW=%0d%0d]: WARNING: The only Port Enable mode supported by this model is 'Both Ports Enabled'!", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX);
         else begin
            $display("[%0t] [DW=%0d%0d]: ERROR: The only Port Enable mode supported by this model is 'Both Ports Enabled'!", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX);
            $finish(1);
         end
      end
   endcase
   
   if (cfg[3])
      $display("      Resetting PLL");
   
   if (cfg[2])
      $display("      I/O Type mode is set to POD");
   else
      $display("      I/O Type mode is set to HSTL / SSTL");
      
   if (cfg[4]) begin
      $display("      Address Parity Enable mode is set to ON");
      ap_enabled = 1;
   end else begin
      $display("      Address Parity Enable mode is set to OFF");
      ap_enabled = 0;
   end
      
   if (cfg[5]) begin
      $display("      Address Invert Enable mode is set to ON");
      abi_enabled = 1;
   end else begin
      $display("      Address Invert Enable mode is set to OFF");
      abi_enabled = 0;
   end
      
   if (cfg[6]) begin
      $display("      Data Invert Enable mode is set to ON");
      dbi_enabled = 1;
   end else begin
      $display("      Data Invert Enable mode is set to OFF");
      dbi_enabled = 0;
   end
      
   if (cfg[7]) begin
      $display("      Write Train Enable mode is set to ON");
      wt_enabled = 1;
   end else begin
      $display("      Write Train Enable mode is set to OFF");
      wt_enabled = 0;
   end
endtask

// Task: nop_command
// Description: Executes any model commands required when a NOP is received
task automatic nop_command;
endtask

// Task: read_command
// Description: Executes any model commands required when a read command is received.
//     This includes creating the new command and inserting it into the pipeline.
task automatic read_command(string port_id);
   if (MEM_VERBOSE) 
      $display("[%0t] [DW=%0d%0d]: READ Command to location %0h (%s)", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX, mem_a_inv_in, port_id);
   
   new_command.word_count = 0;
   
   // Make sure that no other previously-issued command in the pipeline will become
   // active at the same time as this command. Because this is a read command, this
   // shouldn't actually ever happen, so assert just in case.
   if (command_pipeline[2*tRL_cycles] != NOP_COMMAND) begin
      $display("[%0t] [DW=%0d%0d]: ERROR: (%s) read command will become active at the same time as an existing command!", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX, port_id);
      $finish(1);
   end
   
   // insert the new_command variable into the appropriate pipelines
   command_pipeline[2*tRL_cycles-1] <= new_command.command;
   word_count_pipeline[2*tRL_cycles-1] <= new_command.word_count;
   address_pipeline[2*tRL_cycles-1] <= new_command.address;
   
endtask

// Task: write_command
// Description: Executes any model commands required when a write command is received.
//     This includes creating the new command and inserting it into the pipeline.
task automatic write_command(string port_id);
   if (MEM_VERBOSE) 
      $display("[%0t] [DW=%0d%0d]: Write Command to location %0h (%s)", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX, mem_a_inv_in, port_id);
   
   new_command.word_count = 0;
   
   // Make sure that no other previously-issued command in the pipeline will become
   // active at the same time as this command. This can happen if the write command
   // is issued shortly after a read command, because of its lower latency.
   if (command_pipeline[2*tWL_cycles] != NOP_COMMAND) begin
      $display("[%0t] [DW=%0d%0d]: ERROR: (%s) write command will become active at the same time as an existing (read) command!", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX, port_id);
      $finish(1);
   end
   
   // insert the new_command variable into the appropriate pipelines
   command_pipeline[2*tWL_cycles-1] <= new_command.command;
   word_count_pipeline[2*tWL_cycles-1] <= new_command.word_count;
   address_pipeline[2*tWL_cycles-1] <= new_command.address;
endtask

// Task: cfg_write_command
// Description: Executes any model commands required when a configuration write command is received
task automatic cfg_write_command;
   if (MEM_VERBOSE) 
      $display("[%0t] [DW=%0d%0d]: CFG WRITE Command - CR [ %0d ] -> %0h", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX, mem_a[11:8], mem_a[7:0]);
      
   if (mem_a[12] !== 1'b0) begin
      $display("[%0t] [DW=%0d%0d]: ERROR: Address bit 12 must be 0 during a configuration command!", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX);
      $finish(1);
   end
   
   case(mem_a[11:8])
      4'b0000 : begin
         if (MEM_VERBOSE)
            $display("   CR - 0");
         
         // Set the data for Register 0
         set_cfg_reg_0(mem_a[7:0]);
      end

      4'b0001 : begin
         if (MEM_VERBOSE)
            $display("   CR - 1");
         
         // Set the data for Register 1
         set_cfg_reg_1(mem_a[7:0]);
      end
      
      4'b0010 : begin
         if (MEM_VERBOSE)
            $display("   CR - 2");
         
         // Set the data for Register 2
         set_cfg_reg_2(mem_a[7:0], 1'b0);
      end
      
      4'b0011 : begin
         if (MEM_VERBOSE)
            $display("   CR - 3");
            
         // Bit 0 clears the address parity error flag/info
         if (mem_a[0]) begin
            $display("      Clearing address parity error information");
            mem_pe_n_latch = 1'b1;
         end
      end
      
      default : begin
         if (mem_a[11:8] >= 4 && mem_a[11:8] <= 7)
            $display("Error: Register %0d is read-only and cannot be written to!", mem_a[11:8]);
         else
            $display("Error: Configuration write - invalid register address: %0d", mem_a[11:8]);
            
         $finish(1);
      end
   endcase
endtask

// Task: loopback_sample_signals
// Description: Samples the correct signals according to the loopback mode set using the LBK0/1 signals
//     and pushes them into the loopback pipeline.
task automatic loopback_sample_signals(string port_id);  
   case({mem_lbk0_n, mem_lbk1_n})
      4'b00 : begin
         if (port_id == "Port A")
            loopback_pipeline[2*T_LBL-1] <= mem_a[12:0];
         else
            loopback_pipeline[2*T_LBL-1] <= ~mem_a[12:0];
      end

      4'b01 : begin
         // Handle the case of having fewer than the maximum number of address pins
         if (port_id == "Port A")
            loopback_pipeline[2*T_LBL-1] <= {mem_ainv, {{2*LOOPBACK_DATA_WIDTH-PORT_MEM_A_WIDTH-1}{1'bz}}, mem_a[PORT_MEM_A_WIDTH-1:13]};
         else
            loopback_pipeline[2*T_LBL-1] <= {~mem_ainv, {{2*LOOPBACK_DATA_WIDTH-PORT_MEM_A_WIDTH-1}{1'bz}}, ~mem_a[PORT_MEM_A_WIDTH-1:13]};
      end
      
      4'b10 : begin
         if (port_id == "Port A")
            loopback_pipeline[2*T_LBL-1] <= {mem_ap, mem_rwb_n, mem_ldb_n, mem_dkb_n[1], mem_dkb[1], mem_dkb_n[0], mem_dkb[0], mem_rwa_n, mem_lda_n, mem_dka_n[1], mem_dka[1], mem_dka_n[0], mem_dka[0]};
         else
            loopback_pipeline[2*T_LBL-1] <= ~{mem_ap, mem_rwb_n, mem_ldb_n, mem_dkb_n[1], mem_dkb[1], mem_dkb_n[0], mem_dkb[0], mem_rwa_n, mem_lda_n, mem_dka_n[1], mem_dka[1], mem_dka_n[0], mem_dka[0]};
      end
      
      default : begin
         $display("Error: Bad LBK mode (task called when no LBK mode specified)!");
         $finish(1);
      end
   endcase
endtask

// Task: check_banking_violations
// Description: Checks to make sure no bank access has been violated by
//     the current new command.
task automatic check_banking_violations;
   bit [BANK_ADDR_WIDTH-1:0] cur_bank;
   bit [BANK_ADDR_WIDTH-1:0] port_a_bank;

   if (new_command.command == READ_B_COMMAND || new_command.command == WRITE_B_COMMAND) begin
      // Port B is not allowed to access the same bank as port A
      // within the same clock cycle
      if (last_port_a_command.command == READ_A_COMMAND || last_port_a_command.command == WRITE_A_COMMAND) begin
         cur_bank = new_command.address[BANK_ADDR_WIDTH-1:0];
         port_a_bank = last_port_a_command.address[BANK_ADDR_WIDTH-1:0];
         
         if (cur_bank == port_a_bank) begin
            $display("[%0t] [DW=%0d%0d]: ERROR: Port B command cannot access the same bank (%0d) as port A in the same cycle", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX, cur_bank);
            $finish(1);
         end
      end
   end
endtask

// Task: check_address_parity_violation
// Description: Checks to make sure that address parity has not been violated by
//     the current new command. If a violation is detected, push an error flag
//     into a pipeline.
task automatic check_address_parity_violation;
   bit xor_result;
   
   xor_result = ^{mem_ap_inv_in, mem_a_inv_in};
   
   if (xor_result !== 1'b0) begin
      addr_parity_error_pipeline[2*tRL_cycles-1] <= 1'b1;
      new_command.addr_parity_error = 1'b1;
      
      if (MEM_STOP_ON_AP_ERROR) begin
         $display("[%0t] [DW=%0d%0d]: ERROR: Address parity violation detected (address: %0h)!", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX, mem_a_inv_in);
         $finish(1);
      end
         
      if (MEM_VERBOSE)
         $display("[%0t] [DW=%0d%0d]: WARNING: Address parity violation detected (address: %0h)!", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX, mem_a_inv_in);
   end
endtask

// Task: write_memory
// Parameters:
//      mem_address  : The address to write to
//      burst_num    : The burst number of this write
//      write_data   : The data to write
// Description: Writes the given data to the memory array
task write_memory(
   input [PORT_MEM_A_WIDTH-1:0] mem_address, 
   input int burst_num,
   input [PORT_MEM_DQ_WIDTH-1:0] write_data,
   string port_id);
   
   address_burst_type address_burst;
   
   // Construct the actual address structure for the operation
   address_burst.address = mem_address;
   address_burst.burst_num = burst_num;
   
   if (MEM_VERBOSE) begin
      $display("[%0t] [DW=%0d%0d]: Writing data %h to address %0h burst %0d (%s)", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX, write_data, address_burst.address, burst_num, port_id);
      
      if (write_data === 'Z)
         $display("[%0t] [DW=%0d%0d]: WARNING: No write data provided on %s. Writing 'X.", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX, port_id);
   end
      
   mem_data[address_burst] = (write_data === 'Z) ? 'X : write_data;
endtask

// Task: read_memory
// Parameters:
//      mem_address  : The address to read from
//      burst_num    : The burst number of this write
// Description: Reads the memory array for the given address/burst
task read_memory(
   input [PORT_MEM_A_WIDTH-1:0] mem_address,
   int burst_num,
   string port_id,
   output [PORT_MEM_DQ_WIDTH-1:0] data_read);

   address_burst_type address_burst;
   
   // Construct the actual address structure for the operation
   address_burst.address = mem_address;
   address_burst.burst_num = burst_num;
   
   if (mem_data.exists(address_burst)) begin
      // Read from the memory array
      data_read = mem_data[address_burst];
      if (MEM_VERBOSE) 
         $display("[%0t] [DW=%0d%0d]: Pre-reading data %h from address %0h burst %0d (%s)", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX, data_read, mem_address, burst_num, port_id);
   end
   else begin
      // if the array location does not exist then output X
      if (MEM_VERBOSE) 
         $display("[%0t] [DW=%0d%0d]: WARNING: Attempting to read from uninitialized address %0h burst %0d (%s)", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX, mem_address, burst_num, port_id);
      data_read = 'X;
   end
endtask

// END TASKS AND FUNCTIONS SECTION
// ******************************************************************************************************************************** 

// Initialize the cycle counters based on the memory parameters
initial begin
   tRL_cycles = MEM_TRL_CYC;
   tWL_cycles = MEM_TWL_CYC;
   tRW_delta_cycles = MEM_TRL_CYC - MEM_TWL_CYC;
end

// Initialize variables and define a default configuration
initial begin

   $display("Altera Generic QDR-IV Memory Model");
   
   // Clear the global clock cycle counter
   clock_cycle = 0;
   
   init_model();
   
end

// Generate the mem_qk clocks from the mem_ck clocks;
assign mem_qka_int = mem_ck_int;
assign mem_qkb_int = mem_ck_int;

// Update the clock cycle counter
always @ (posedge mem_ck_int) begin
   clock_cycle <= clock_cycle+1;
   t_rsh_clock_cycle <= t_rsh_clock_cycle+1;
end

// Generate the mem_qk outputs. Assume 0 skew
always @ (mem_qka_int) begin
   mem_qka <= {PORT_MEM_QK_WIDTH{mem_qka_int}};
   mem_qka_n <= ~{PORT_MEM_QK_WIDTH{mem_qka_int}};
end

always @ (mem_qkb_int) begin
   mem_qkb <= {PORT_MEM_QK_WIDTH{mem_qkb_int}};
   mem_qkb_n <= ~{PORT_MEM_QK_WIDTH{mem_qkb_int}};
end

// When reset is asserted, re-initialize the model to
// a clean state (but do not touch the global clock cycle counter)
always @ (negedge mem_reset_n) begin
   init_model();
end

// When reset is de-asserted, load initial configuration
// values, some of which come from the address bus.
always @ (posedge mem_reset_n) begin
   // Clear the clock cycle counter (cycles since last reset)
   // to enforce T_rsh.
   t_rsh_clock_cycle = 0;

   // Set configuration register settings to reset values
   set_cfg_reg_0(mem_a[7:0]);
   set_cfg_reg_1({1'b1, 1'b0, 1'b1, 1'b0, 1'b0, mem_a[10:8]});
   set_cfg_reg_2({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, mem_a[13:11]}, 1'b1);
end

// Main function of memory model
always @ (mem_ck_int) begin
   int i;
   
   mem_ck_time = $time;
   
   mem_dqa_en <= 1'b0;
   mem_dqb_en <= 1'b0;
   
   // Shift the command pipelines
   
   addr_parity_error_pipeline <= {1'b0, addr_parity_error_pipeline[2*MAX_LATENCY-1:1]};
   
   // More complex shift registers require the following syntax
   // to avoid errors on some simulators
   word_count_pipeline[2*MAX_LATENCY-2:0] <= word_count_pipeline[2*MAX_LATENCY-1:1];
   word_count_pipeline[2*MAX_LATENCY-1] <= 0;
   
   for (i = 0; i <= 2*MAX_LATENCY-2; i++)
      command_pipeline[i] <= command_pipeline[i+1];
   command_pipeline[2*MAX_LATENCY-1] <= NOP_COMMAND;
   
   address_pipeline[2*MAX_LATENCY-2:0] <= address_pipeline[2*MAX_LATENCY-1:1];
   address_pipeline[2*MAX_LATENCY-1] <= 'x;
   
   read_data_pipeline[2*MAX_LATENCY-2:0] <= read_data_pipeline[2*MAX_LATENCY-1:1];
   read_data_pipeline[2*MAX_LATENCY-1] <= 'x;
   
   loopback_pipeline[2*T_LBL-2:0] <= loopback_pipeline[2*T_LBL-1:1];
   loopback_pipeline[2*T_LBL-1] <= 'z;
   
   // Process the new commands on the pins
   new_command.address = mem_a_inv_in;
   new_command.word_count = 0;
   new_command.addr_parity_error = 1'b0;
      
   // Assert the parity error (mem_pe_n) signal RL cycles after it occurs
   if (addr_parity_error_pipeline[0])
      mem_pe_n_latch = 1'b0;
   
   if (mem_ck_int) begin
      // Port A address/command sampled on the rising edge
      if (mem_lbk0_n === 1'b0 || mem_lbk1_n === 1'b0) begin
         new_command.command = NOP_COMMAND;
         loopback_sample_signals(PORT_A);
         mem_dqa_en <= 1'b1;
         mem_dqa_int <= { {{PORT_MEM_DQ_WIDTH-LOOPBACK_DATA_WIDTH}{1'bZ}}, loopback_pipeline[0] };
      end else if (mem_lda_n == 1'b1)
         new_command.command = NOP_COMMAND;         
      else if (mem_reset_n !== 1'b1)
         new_command.command = NOP_COMMAND;         
      else if (t_rsh_clock_cycle < T_RSH) begin
         $display("[%0t] [DW=%0d%0d]: Warning: Command issued earlier than the T_RSH requirement of %0d cycles after reset!", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX, T_RSH);
      end
      else if (clock_cycle < IGNORE_CMDS_INIT_CYCLES) begin
         new_command.command = NOP_COMMAND;
         $display("[%0t] : Ignoring incoming command for the first %0d cycles. Current cycle is %0d", $time, IGNORE_CMDS_INIT_CYCLES, clock_cycle);
      end
      else begin
         if (mem_cfg_n) begin
            // Check address parity, if enabled
            if (ap_enabled)
               check_address_parity_violation();
               
            if (mem_rwa_n) begin
               if (new_command.addr_parity_error)
                  $display("[%0t] [DW=%0d%0d]: WARNING: Read command will proceed normally despite the address parity error!", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX);
               new_command.command = READ_A_COMMAND;
            end else begin
               if (new_command.addr_parity_error) begin
                  $display("[%0t] [DW=%0d%0d]: WARNING: Write command will be IGNORED due to address parity error!", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX);
                  new_command.command = NOP_COMMAND;
               end else begin
                  new_command.command = WRITE_A_COMMAND;
               end
            end
         end else begin
            if (mem_rwa_n) begin
               $display("[%0t] [DW=%0d%0d]: ERROR: Configuration read is not supported by this model!", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX);
               $finish(1);
            end else begin
               new_command.command = CFG_WRITE_COMMAND;
            end
         end
      end
      
      if (new_command.command == CFG_WRITE_COMMAND && last_port_a_command.command == CFG_WRITE_COMMAND)
         // LDA_N should be asserted for more than one cycle in a configuration command,
         // so count just the first one in this simplified model, and ignore the rest
         new_command.command = NOP_COMMAND;
      else
         last_port_a_command = new_command;
         
   end else begin
      // Port B address/command sampled on the falling edge
      if (mem_lbk0_n === 1'b0 || mem_lbk1_n === 1'b0) begin
         new_command.command = NOP_COMMAND;
         loopback_sample_signals(PORT_B);
         mem_dqa_en <= 1'b1;
         mem_dqa_int <= { {{PORT_MEM_DQ_WIDTH-LOOPBACK_DATA_WIDTH}{1'bZ}}, loopback_pipeline[0] };
      end else if (mem_ldb_n == 1'b1)
         new_command.command = NOP_COMMAND;         
      else if (mem_reset_n !== 1'b1)
         new_command.command = NOP_COMMAND;         
      else if (t_rsh_clock_cycle < T_RSH) begin
         $display("[%0t] [DW=%0d%0d]: Warning: Command issued earlier than the T_RSH requirement of %0d cycles after reset!", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX, T_RSH);
      end
      else if (clock_cycle < IGNORE_CMDS_INIT_CYCLES) begin
         new_command.command = NOP_COMMAND;
         $display("[%0t] : Ignoring incoming command for the first %0d cycles. Current cycle is %0d", $time, IGNORE_CMDS_INIT_CYCLES, clock_cycle);
      end
      else begin
         // Check address parity, if enabled
         if (ap_enabled)
            check_address_parity_violation();
            
         if (mem_rwb_n) begin
            if (new_command.addr_parity_error)
               $display("[%0t] [DW=%0d%0d]: WARNING: Read command will proceed normally despite the address parity error!", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX);
            new_command.command = READ_B_COMMAND;
         end else begin
            if (new_command.addr_parity_error) begin
               $display("[%0t] [DW=%0d%0d]: WARNING: Write command will be IGNORED due to address parity error!", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX);
               new_command.command = NOP_COMMAND;
            end else begin
               new_command.command = WRITE_B_COMMAND;
            end
         end
            
         // Check for banking violations based on this command
         check_banking_violations();
      end
   end
      
   // Run the appropriate task based on the command
   case (new_command.command)
      NOP_COMMAND : nop_command();
      READ_A_COMMAND : read_command(PORT_A);
      READ_B_COMMAND : read_command(PORT_B);
      WRITE_A_COMMAND : write_command(PORT_A);
      WRITE_B_COMMAND : write_command(PORT_B);
      CFG_WRITE_COMMAND : cfg_write_command();
   endcase

   // Determine if any active command is finished. Some commands like read/write
   // take more than one clock cycle to complete.
   if (active_command_a.command != NOP_COMMAND)
      if (active_command_a.word_count == MEM_BL)
         // Mark the command as NOP_COMMAND to signal that the active command is complete
         active_command_a.command = NOP_COMMAND;
         
   if (active_command_b.command != NOP_COMMAND)
      if (active_command_b.word_count == MEM_BL)
         // Mark the command as NOP_COMMAND to signal that the active command is complete
         active_command_b.command = NOP_COMMAND;

   // Is there an active read/write on this cycle?
   // For a new command to be active, there must be no active command
   // and the command pipeline must have a valid command in position 0
   // indicating that the appropriate number of clock cycles have passed since
   // the command was issued.
   
   if (mem_ck_int) begin
      // Port A commands appear on the rising edge, assuming
      // integer latencies
      if (active_command_a.command == NOP_COMMAND) begin
         if (command_pipeline[0] != NOP_COMMAND) begin
            
            // Make sure that this is a port A command.
            if ( (command_pipeline[0] != READ_A_COMMAND) && (command_pipeline[0] != WRITE_A_COMMAND) ) begin
               $display("[%0t] [DW=%0d%0d]: Internal Error: Expecting a port A command on rising edge!", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX);
               $finish(1);
            end
         
            // Update the active_command variable to point to the next command in the
            // queue.
            active_command_a.command = command_pipeline[0];
            active_command_a.word_count = word_count_pipeline[0];
            active_command_a.address = address_pipeline[0];
            
            // Get read data from the read data pipeline, which ensures that data written
            // by commands issued after this read do not affect the returned result.
            if (active_command_a.command == READ_A_COMMAND) begin
               active_command_read_data_a = read_data_pipeline[0];
            end
            
         end
      end
      else begin
         // Make sure no other command is trying to be active. Otherwise assert.
         if (command_pipeline[0] != NOP_COMMAND) begin
            $display("[%0t] [DW=%0d%0d]: Internal Error: Active command (port A) but command pipeline also active!", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX);
            $finish(1);
         end
      end
      
      // Pre-load read data if there is a read command that is due to become
      // active within a window during which write commands issued after the
      // read may complete. This ensures that such write commands do not affect
      // the data returned by the read command. All burst words are preloaded
      // in a single operation.
      if (command_pipeline[tRW_delta_cycles*2] == READ_A_COMMAND) begin
         for (burst_count = 0; burst_count < MEM_BL; burst_count++) begin
            read_memory(address_pipeline[tRW_delta_cycles*2], burst_count, PORT_A, read_data_reg[burst_count*PORT_MEM_DQ_WIDTH +: PORT_MEM_DQ_WIDTH]);
         end
         read_data_pipeline[tRW_delta_cycles*2-1] <= read_data_reg;
      end
      
   end else begin
      // Port B commands appear on the falling edge, assuming
      // integer latencies
      if (active_command_b.command == NOP_COMMAND) begin
         if (command_pipeline[0] != NOP_COMMAND) begin

            // Make sure that this is a port B command.
            if ( (command_pipeline[0] != READ_B_COMMAND) && (command_pipeline[0] != WRITE_B_COMMAND) ) begin
               $display("[%0t] [DW=%0d%0d]: Internal Error: Expecting a port B command on falling edge!", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX);
               $finish(1);
            end
         
            // Update the active_command variable to point to the next command in the
            // queue.
            active_command_b.command = command_pipeline[0];
            active_command_b.word_count = word_count_pipeline[0];
            active_command_b.address = address_pipeline[0];
            
            // Get read data from the read data pipeline, which ensures that data written
            // by commands issued after this read do not affect the returned result.
            if (active_command_b.command == READ_B_COMMAND) begin
               active_command_read_data_b = read_data_pipeline[0];
            end
            
         end
      end
      else begin
         // Make sure no other command is trying to be active. Otherwise assert.
         if (command_pipeline[0] != NOP_COMMAND) begin
            $display("[%0t] [DW=%0d%0d]: Internal Error: Active command (port B) but command pipeline also active!", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX);
            $finish(1);
         end
      end
      
      // Pre-load read data if there is a read command that is due to become
      // active within a window during which write commands issued after the
      // read may complete. This ensures that such write commands do not affect
      // the data returned by the read command. All burst words are preloaded
      // in a single operation.
      if (command_pipeline[tRW_delta_cycles*2] == READ_B_COMMAND) begin
         for (burst_count = 0; burst_count < MEM_BL; burst_count++) begin
            read_memory(address_pipeline[tRW_delta_cycles*2], burst_count, PORT_B, read_data_reg[burst_count*PORT_MEM_DQ_WIDTH +: PORT_MEM_DQ_WIDTH]);
         end
         read_data_pipeline[tRW_delta_cycles*2-1] <= read_data_reg;
      end
      
   end

   // Process any active command
   
   if (active_command_a.command != NOP_COMMAND) begin
      if (active_command_a.command == WRITE_A_COMMAND) begin
         // The active command is a write, so write to the memory array

         // Check the ck/dk time delta to make sure it's valid
         integer mem_ck_dk_diff;
         integer i;
         integer error;

         error = 0;
         if (MEM_DQS_TO_CLK_CAPTURE_DELAY > 0) begin

            #(MEM_DQS_TO_CLK_CAPTURE_DELAY);

            for (i = 0; i < PORT_MEM_DK_WIDTH; i++) begin
               if (mem_ck_time > mem_dka_time[i]) begin
                  mem_ck_dk_diff = -(mem_ck_time - mem_dka_time[i]);
               end 
               else begin
                  mem_ck_dk_diff = mem_dka_time[i] - mem_ck_time;
               end
               if (mem_ck_dk_diff < -(MEM_CLK_TO_DQS_CAPTURE_DELAY)) begin
                  error = 1;
                  $display("[%0t] [DW=%0d%0d]: BAD Write: mem_ck=%0t mem_dka[%0d]=%0t delta=%0d min=%0d", 
                      $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX, 
                      mem_ck_time, i, mem_dka_time[i], mem_ck_dk_diff, -(MEM_CLK_TO_DQS_CAPTURE_DELAY));
               end else if (active_command_a.word_count == 0 && mem_dka[i] == 1'b0) begin
                  error = 1;
                  $display("[%0t] [DW=%0d%0d]: BAD Write: first write on dka=0: mem_ck=%0t mem_dka[%0d]=%0t delta=%0d min=%0d", 
                      $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX, 
                      mem_ck_time, i, mem_dka_time[i], mem_ck_dk_diff, -(MEM_CLK_TO_DQS_CAPTURE_DELAY));
               end
            end
            if (error) begin
               write_memory(active_command_a.address, active_command_a.word_count, 'x, PORT_A);
            end
            else begin
               if (wt_enabled && active_command_a.word_count == 1)
                  write_memory(active_command_a.address, active_command_a.word_count, ~mem_dqa_inv_in, PORT_A);
               else
                  write_memory(active_command_a.address, active_command_a.word_count, mem_dqa_inv_in, PORT_A);
            end
         end
         else begin
            if (wt_enabled && active_command_a.word_count == 1)
               write_memory(active_command_a.address, active_command_a.word_count, ~mem_dqa_inv_in, PORT_A);
            else
               write_memory(active_command_a.address, active_command_a.word_count, mem_dqa_inv_in, PORT_A);
         end
         // Update the word count for this command
         active_command_a.word_count = active_command_a.word_count+1;
      end
      if (active_command_a.command == READ_A_COMMAND) begin
         // The active command is a read so return data loaded from the read data pipeline
         mem_dqa_int <= active_command_read_data_a[active_command_a.word_count*PORT_MEM_DQ_WIDTH +: PORT_MEM_DQ_WIDTH];
         // Enable the mem_dq to output data
         mem_dqa_en <= 1'b1;
         // Update the word count for this command
         active_command_a.word_count = active_command_a.word_count+1;
      end
   end

   if (active_command_b.command != NOP_COMMAND) begin
      if (active_command_b.command == WRITE_B_COMMAND) begin
         // The active command is a write, so write to the memory array

         // Check the ck/dk time delta to make sure it's valid
         integer mem_ck_dk_diff;
         integer i;
         integer error;

         error = 0;
         if (MEM_DQS_TO_CLK_CAPTURE_DELAY > 0) begin

            #(MEM_DQS_TO_CLK_CAPTURE_DELAY);

            for (i = 0; i < PORT_MEM_DK_WIDTH; i++) begin
               if (mem_ck_time > mem_dkb_time[i]) begin
                  mem_ck_dk_diff = -(mem_ck_time - mem_dkb_time[i]);
               end 
               else begin
                  mem_ck_dk_diff = mem_dkb_time[i] - mem_ck_time;
               end
               if (mem_ck_dk_diff < -(MEM_CLK_TO_DQS_CAPTURE_DELAY)) begin
                  error = 1;
                  $display("[%0t] [DW=%0d%0d]: BAD Write: mem_ck=%0t mem_dkb[%0d]=%0t delta=%0d min=%0d", 
                      $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX, 
                      mem_ck_time, i, mem_dkb_time[i], mem_ck_dk_diff, -(MEM_CLK_TO_DQS_CAPTURE_DELAY));
               end else if (active_command_b.word_count == 0 && mem_dkb[i] == 1'b1) begin
                  error = 1;
                  $display("[%0t] [DW=%0d%0d]: BAD Write: first write on dkb=1: mem_ck=%0t mem_dkb[%0d]=%0t delta=%0d min=%0d", 
                      $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX, 
                      mem_ck_time, i, mem_dkb_time[i], mem_ck_dk_diff, -(MEM_CLK_TO_DQS_CAPTURE_DELAY));
               end
            end
            if (error) begin
               write_memory(active_command_b.address, active_command_b.word_count, 'x, PORT_B);
            end
            else begin
               if (wt_enabled && active_command_b.word_count == 1)
                  write_memory(active_command_b.address, active_command_b.word_count, ~mem_dqb_inv_in, PORT_B);
               else
                  write_memory(active_command_b.address, active_command_b.word_count, mem_dqb_inv_in, PORT_B);
            end
         end
         else begin
            if (wt_enabled && active_command_b.word_count == 1)
               write_memory(active_command_b.address, active_command_b.word_count, ~mem_dqb_inv_in, PORT_B);
            else
               write_memory(active_command_b.address, active_command_b.word_count, mem_dqb_inv_in, PORT_B);
         end
         // Update the word count for this command
         active_command_b.word_count = active_command_b.word_count+1;
      end
      if (active_command_b.command == READ_B_COMMAND) begin
         // The active command is a read so return data loaded from the read data pipeline
         mem_dqb_int <= active_command_read_data_b[active_command_b.word_count*PORT_MEM_DQ_WIDTH +: PORT_MEM_DQ_WIDTH];
         // Enable the mem_dq to output data
         mem_dqb_en <= 1'b1;
         // Update the word count for this command
         active_command_b.word_count = active_command_b.word_count+1;
      end
   end
end

// Output onto mem_dq if trying to write back.
assign mem_dqa = (mem_dqa_en) ? mem_dqa_inv_out : 'Z;
assign mem_dqb = (mem_dqb_en) ? mem_dqb_inv_out : 'Z;
assign mem_dinva = (mem_dqa_en) ? mem_dinva_int : 'Z;
assign mem_dinvb = (mem_dqb_en) ? mem_dinvb_int : 'Z;

// Assign the latched PE_N signal to the pin.
assign mem_pe_n = mem_pe_n_latch;

// synthesis translate_on
endmodule
