// (C) 2001-2025 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


`timescale 1 ns / 1 ns

module NiosV_intel_niosv_g_0_hart 
   import niosv_opcode_def::*;
# (
   parameter DBG_EXPN_VECTOR          = 32'h80000000,
   parameter RESET_VECTOR             = 32'h00000000,
   parameter CORE_EXTN                = 26'h0000100, // RV32I
   parameter HARTID                   = 32'h00000000,
   parameter DISABLE_FSQRT_FDIV       = 1'b0,
   parameter DEBUG_ENABLED            = 1'b0,
   parameter DEVICE_FAMILY            = "Stratix 10",
   parameter DBG_PARK_LOOP_OFFSET     = 32'd24,
   parameter USE_RESET_REQ            = 1'b0,
   parameter DBG_DATA_S_BASE          = 32'h000A0000,
   parameter TIMER_MSIP_DATA_S_BASE   = 32'h000B0000,
   parameter DATA_CACHE_SIZE          = 4096,
   parameter INST_CACHE_SIZE          = 4096,
   parameter ITCM1_SIZE               = 0,
   parameter ITCM1_BASE               = 32'h0,
   parameter ITCM1_INIT_FILE          = "UNUSED",
   parameter ITCM2_SIZE               = 0,
   parameter ITCM2_BASE               = 32'h0,
   parameter ITCM2_INIT_FILE          = "UNUSED",
   parameter PERIPHERAL_REGION_A_SIZE = 0,
   parameter PERIPHERAL_REGION_A_BASE = 32'h0,
   parameter PERIPHERAL_REGION_B_SIZE = 0,
   parameter PERIPHERAL_REGION_B_BASE = 32'h0,
   parameter DTCM1_SIZE               = 0,
   parameter DTCM1_BASE               = 32'h0,
   parameter DTCM1_INIT_FILE          = "UNUSED",
   parameter DTCM2_SIZE               = 0,
   parameter DTCM2_BASE               = 32'h0,
   parameter DTCM2_INIT_FILE          = "UNUSED",
   parameter ECC_EN                   = 1'b0,
   parameter ECC_FULL                 = 1'b0,
   parameter BRANCHPREDICTION_EN      = 1'b1,
   parameter ITCS1_ADDR_WIDTH         = 4'd10,
   parameter ITCS2_ADDR_WIDTH         = 4'd10,
   parameter DTCS1_ADDR_WIDTH         = 4'd10,
   parameter DTCS2_ADDR_WIDTH         = 4'd10,
   parameter NUM_PLATFORM_INTERRUPTS  = 16,
   parameter NUM_SRF_BANKS            = 2,
   parameter CLIC_EN                  = 0,
   parameter CLIC_NUM_LEVELS          = 1,
   parameter CLIC_NUM_PRIORITIES      = 8,
   parameter CLIC_NUM_DEBUG_TRIGGERS  = 0,
   parameter CLIC_TRIGGER_POLARITY_EN = 0,
   parameter CLIC_EDGE_TRIGGER_EN     = 0,
   parameter CLIC_VT_ALIGN            = 8,
   parameter CLIC_SHV_EN              = 0,
   parameter BLIND_WINDOW_PERIOD      = 1000,
   parameter DEFAULT_TIMEOUT_PERIOD   = 255,
   parameter REMOVE_TIME_DIVERSITY    = 0,   
   parameter DCLS_EXTRST_IF_ACTIVE    = 0,
   // this would be a localparam if Quartus Standard supported the necessary syntax
   parameter PLAT_IRQ_VEC_W = (NUM_PLATFORM_INTERRUPTS < 1) ? 1 : NUM_PLATFORM_INTERRUPTS
) (

   input  wire                       clk,
   input  wire                       reset,
   input  wire                       reset_req,
   output wire                       reset_req_ack,

   // write command
   //    address
   output wire [31:0]                instr_awaddr,
   output wire [2:0]                 instr_awprot,
   output wire                       instr_awvalid,
   output wire [2:0]                 instr_awsize,
   output wire [7:0]                 instr_awlen,
   output wire [1:0]                 instr_awburst,
   input                             instr_awready,
   //  data
   output wire                       instr_wvalid,
   output wire [31:0]                instr_wdata,
   output wire [3:0]                 instr_wstrb,
   output wire                       instr_wlast,
   input                             instr_wready,

   //write response
   input                             instr_bvalid,
   input [1:0]                       instr_bresp,
   output wire                       instr_bready,

   //read command
   output wire [31:0]                instr_araddr,
   output wire [2:0]                 instr_arprot,
   output wire                       instr_arvalid,
   output wire [2:0]                 instr_arsize,
   output wire [7:0]                 instr_arlen,
   output wire [1:0]                 instr_arburst,
   input                             instr_arready,

   //read response
   input [31:0]                      instr_rdata,
   input                             instr_rvalid,
   input [1:0]                       instr_rresp,
   input                             instr_rlast,
   output wire                       instr_rready,

   // write command
   //    address
   output wire [ADDR_W-1:0]          data_awaddr,
   output wire [2:0]                 data_awprot,
   output wire                       data_awvalid,
   output wire [2:0]                 data_awsize,
   output wire [7:0]                 data_awlen,
   input                             data_awready,
   //  data
   output wire                       data_wvalid,
   output wire [DATA_W-1:0]          data_wdata,
   output wire [3:0]                 data_wstrb,
   output wire                       data_wlast,
   input                             data_wready,

   //write response
   input                             data_bvalid,
   input [1:0]                       data_bresp,
   output wire                       data_bready,

   //read command
   output wire [ADDR_W-1:0]          data_araddr,
   output wire [2:0]                 data_arprot,
   output wire                       data_arvalid,
   output wire [2:0]                 data_arsize,
   output wire [7:0]                 data_arlen,
   input                             data_arready,

   //read response
   input [DATA_W-1:0]                data_rdata,
   input                             data_rvalid,
   input [1:0]                       data_rresp,
   input                             data_rlast,
   output wire                       data_rready,

   input wire                        irq_timer,
   input wire                        irq_sw,
   input wire [PLAT_IRQ_VEC_W-1:0]   irq_plat_vec,
   input wire                        irq_ext,

   input wire                        irq_debug,

   output wire [1:0]                 core_ecc_status,
   output wire [3:0]                 core_ecc_src,

   // axi4-lite interface to access ITCM1
   // write command
   //    address
   input wire [ITCS1_ADDR_WIDTH-1:0] itcs1_awaddr,
   input wire [2:0]                  itcs1_awprot,
   input wire                        itcs1_awvalid,
   output                            itcs1_awready,
   //  data
   input wire                        itcs1_wvalid,
   input wire [31:0]                 itcs1_wdata,
   input wire [3:0]                  itcs1_wstrb,
   output                            itcs1_wready,
 
   //write response
   output                            itcs1_bvalid,
   output [1:0]                      itcs1_bresp,
   input wire                        itcs1_bready,
 
   //read command
   input wire [ITCS1_ADDR_WIDTH-1:0] itcs1_araddr,
   input wire [2:0]                  itcs1_arprot,
   input wire                        itcs1_arvalid,
   output                            itcs1_arready,
 
   //read response
   output [31:0]                     itcs1_rdata,
   output                            itcs1_rvalid,
   output [1:0]                      itcs1_rresp,
   input wire                        itcs1_rready,

   // axi4-lite interface to access ITCM2
   // write command
   //    address
   input wire [ITCS2_ADDR_WIDTH-1:0] itcs2_awaddr,
   input wire [2:0]                  itcs2_awprot,
   input wire                        itcs2_awvalid,
   output                            itcs2_awready,
   //  data
   input wire                        itcs2_wvalid,
   input wire [31:0]                 itcs2_wdata,
   input wire [3:0]                  itcs2_wstrb,
   output                            itcs2_wready,
 
   //write response
   output                            itcs2_bvalid,
   output [1:0]                      itcs2_bresp,
   input wire                        itcs2_bready,
 
   //read command
   input wire [ITCS2_ADDR_WIDTH-1:0] itcs2_araddr,
   input wire [2:0]                  itcs2_arprot,
   input wire                        itcs2_arvalid,
   output                            itcs2_arready,
 
   //read response
   output [31:0]                     itcs2_rdata,
   output                            itcs2_rvalid,
   output [1:0]                      itcs2_rresp,
   input wire                        itcs2_rready,


   // axi4-lite interface to access DTCM1
   // write command
   //    address
   input wire [DTCS1_ADDR_WIDTH-1:0] dtcs1_awaddr,
   input wire [2:0]                  dtcs1_awprot,
   input wire                        dtcs1_awvalid,
   output                            dtcs1_awready,
   //  data
   input wire                        dtcs1_wvalid,
   input wire [31:0]                 dtcs1_wdata,
   input wire [3:0]                  dtcs1_wstrb,
   output                            dtcs1_wready,
 
   //write response
   output                            dtcs1_bvalid,
   output [1:0]                      dtcs1_bresp,
   input wire                        dtcs1_bready,
 
   //read command
   input wire [DTCS1_ADDR_WIDTH-1:0] dtcs1_araddr,
   input wire [2:0]                  dtcs1_arprot,
   input wire                        dtcs1_arvalid,
   output                            dtcs1_arready,
 
   //read response
   output [31:0]                     dtcs1_rdata,
   output                            dtcs1_rvalid,
   output [1:0]                      dtcs1_rresp,
   input wire                        dtcs1_rready,

   // axi4-lite interface to access DTCM2
   // write command
   //    address
   input wire [DTCS2_ADDR_WIDTH-1:0] dtcs2_awaddr,
   input wire [2:0]                  dtcs2_awprot,
   input wire                        dtcs2_awvalid,
   output                            dtcs2_awready,
   //  data
   input wire                        dtcs2_wvalid,
   input wire [31:0]                 dtcs2_wdata,
   input wire [3:0]                  dtcs2_wstrb,
   output                            dtcs2_wready,
 
   //write response
   output                            dtcs2_bvalid,
   output [1:0]                      dtcs2_bresp,
   input wire                        dtcs2_bready,
 
   //read command
   input wire [DTCS2_ADDR_WIDTH-1:0] dtcs2_araddr,
   input wire [2:0]                  dtcs2_arprot,
   input wire                        dtcs2_arvalid,
   output                            dtcs2_arready,
 
   //read response
   output [31:0]                     dtcs2_rdata,
   output                            dtcs2_rvalid,
   output [1:0]                      dtcs2_rresp,
   input wire                        dtcs2_rready

   //====================DCLS Interface =====================      
   // to virtual jtag module instantiation
   ,input wire [3:0]        silentmode,        // input to activate frsmartcomp_niosv silent mode  

   // configuration interface
   input wire [13:0]       address,           // for agents this is a word address 64kb are used from this interface, therefore the width is 14 (bits).
   input wire [3:0]        byteenable,
   input wire              read,
   input wire              write,
   input wire [31:0]       writedata,


   // -------------------------------------------------------------------------------
   // outputs section
   // -------------------------------------------------------------------------------
   // to interrupt controller
   output                  intreq,          // frsmartcomp_niosv interrupt request - type pulse

   // configuration interface
   output [31:0]           readdata,
   output                  readdatavalid,
   output                  waitrequest,     // useful as for bridging to ahb wait states are likely necessary.

   // ---- alarms ----
   output [1:0]            fs_oknok,         // at each clk cycle, it delivers a summary of the frsmartcomp_niosv status (anti-valent coding).
   output [1:0]            fn_alarm_error,   // error-type output  (anti-valent coding)
   output [1:0]            fn_alarm_warning, // warning-type output  (anti-valent coding)
   output [1:0]            fn_alarm_info     // info-type output  (anti-valent coding)

);

   wire [31:0] core_ci_data0;
   wire [31:0] core_ci_data1;
   wire [31:0] core_ci_alu_result;
   wire [31:0] core_ci_ctrl;
   wire        core_ci_enable;
   wire [3:0]  core_ci_op;
   reg  [31:0] core_ci_result_int;
   wire [31:0] core_ci_result;
   wire        core_ci_done;

   wire [F7_FIELD_W-1:0] core_ci_f7 = core_ci_ctrl[F7_FIELD_H:F7_FIELD_L]; 

   // IRQ signal rename (main CPU instance uses wildcard signal binding)
   wire        timer_irq                  = irq_timer;
   wire        sw_irq                     = irq_sw;
   wire [PLAT_IRQ_VEC_W-1:0] plat_irq_vec = irq_plat_vec;
   wire        ext_irq                    = irq_ext;
   wire        debug_irq                  = irq_debug;

 // ================== Instantiation of Dual Core Lockstep System
 // ================== Internal signals for Right CPU Instance

 wire                        reset_req_ack_FOR_R;
 // ================== Instruction Interface ==================
 // write address
 wire [31:0]                 instr_awaddr_FOR_R;
 wire [2:0]                  instr_awprot_FOR_R;
 wire                        instr_awvalid_FOR_R;
 wire [2:0]                  instr_awsize_FOR_R;
 wire [7:0]                  instr_awlen_FOR_R;
 wire [1:0]                  instr_awburst_FOR_R;
 wire                        instr_awready_FOR_R;

 // write data
 wire                        instr_wvalid_FOR_R;
 wire [31:0]                 instr_wdata_FOR_R;
 wire [3:0]                  instr_wstrb_FOR_R;
 wire                        instr_wlast_FOR_R;
 wire                        instr_wready_FOR_R;

 // write response
 wire                        instr_bvalid_FOR_R;
 wire [1:0]                  instr_bresp_FOR_R;
 wire                        instr_bready_FOR_R;

 // read address
 wire [31:0]                 instr_araddr_FOR_R;
 wire [2:0]                  instr_arprot_FOR_R;
 wire                        instr_arvalid_FOR_R;
 wire [2:0]                  instr_arsize_FOR_R;
 wire [7:0]                  instr_arlen_FOR_R;
 wire [1:0]                  instr_arburst_FOR_R;
 wire                        instr_arready_FOR_R;

 // read response
 wire [31:0]                 instr_rdata_FOR_R;
 wire                        instr_rvalid_FOR_R;
 wire [1:0]                  instr_rresp_FOR_R;
 wire                        instr_rlast_FOR_R;
 wire                        instr_rready_FOR_R;

 // ===================== Data Interface ======================
 // write address
 wire [ADDR_W-1:0]           data_awaddr_FOR_R;
 wire [2:0]                  data_awprot_FOR_R;
 wire                        data_awvalid_FOR_R;
 wire [2:0]                  data_awsize_FOR_R;
 wire [7:0]                  data_awlen_FOR_R;
 wire                        data_awready_FOR_R;

 // write data
 wire                        data_wvalid_FOR_R;
 wire [DATA_W-1:0]           data_wdata_FOR_R;
 wire [3:0]                  data_wstrb_FOR_R;
 wire                        data_wlast_FOR_R;
 wire                        data_wready_FOR_R;

 // write response
 wire                        data_bvalid_FOR_R;
 wire [1:0]                  data_bresp_FOR_R;
 wire                        data_bready_FOR_R;

 // read address
 wire [ADDR_W-1:0]           data_araddr_FOR_R;
 wire [2:0]                  data_arprot_FOR_R;
 wire                        data_arvalid_FOR_R;
 wire [2:0]                  data_arsize_FOR_R;
 wire [7:0]                  data_arlen_FOR_R;
 wire                        data_arready_FOR_R;

 // read response
 wire [DATA_W-1:0]           data_rdata_FOR_R;
 wire                        data_rvalid_FOR_R;
 wire [1:0]                  data_rresp_FOR_R;
 wire                        data_rlast_FOR_R;
 wire                        data_rready_FOR_R;

 // Interrupts
 wire                        irq_timer_FOR_R;
 wire                        irq_sw_FOR_R;
 wire [PLAT_IRQ_VEC_W-1:0]   irq_plat_vec_FOR_R;
 wire                        irq_ext_FOR_R;
 wire                        irq_debug_FOR_R;

 // Custom Instructions
 wire [31:0]                 core_ci_data0_FOR_R;
 wire [31:0]                 core_ci_data1_FOR_R;
 wire [31:0]                 core_ci_alu_result_FOR_R;
 wire [31:0]                 core_ci_ctrl_FOR_R;
 wire                        core_ci_enable_FOR_R;
 wire [3:0]                  core_ci_op_FOR_R;
 wire                        core_ci_done_FOR_R;
 wire [31:0]                 core_ci_result_FOR_R;

 // ECC
 wire [3:0]                  core_ecc_src_FOR_R;
 wire [1:0]                  core_ecc_status_FOR_R;

 // ===================== ITCM1 Interface =====================
 // write address
 wire [ITCS1_ADDR_WIDTH-1:0] itcs1_awaddr_FOR_R;
 wire [2:0]                  itcs1_awprot_FOR_R;
 wire                        itcs1_awvalid_FOR_R;
 wire                        itcs1_awready_FOR_R;

 // write data
 wire                        itcs1_wvalid_FOR_R;
 wire [31:0]                 itcs1_wdata_FOR_R;
 wire [3:0]                  itcs1_wstrb_FOR_R;
 wire                        itcs1_wready_FOR_R;

 // write response
 wire                        itcs1_bvalid_FOR_R;
 wire [1:0]                  itcs1_bresp_FOR_R;
 wire                        itcs1_bready_FOR_R;

 // read address
 wire [ITCS1_ADDR_WIDTH-1:0] itcs1_araddr_FOR_R;
 wire [2:0]                  itcs1_arprot_FOR_R;
 wire                        itcs1_arvalid_FOR_R;
 wire                        itcs1_arready_FOR_R;

 // read response
 wire [31:0]                 itcs1_rdata_FOR_R;
 wire                        itcs1_rvalid_FOR_R;
 wire [1:0]                  itcs1_rresp_FOR_R;
 wire                        itcs1_rready_FOR_R;

 // ===================== ITCM2 Interface =====================
 // write address
 wire [ITCS2_ADDR_WIDTH-1:0] itcs2_awaddr_FOR_R;
 wire [2:0]                  itcs2_awprot_FOR_R;
 wire                        itcs2_awvalid_FOR_R;
 wire                        itcs2_awready_FOR_R;
 // write data
 wire                        itcs2_wvalid_FOR_R;
 wire [31:0]                 itcs2_wdata_FOR_R;
 wire [3:0]                  itcs2_wstrb_FOR_R;
 wire                        itcs2_wready_FOR_R;

 // write response
 wire                        itcs2_bvalid_FOR_R;
 wire [1:0]                  itcs2_bresp_FOR_R;
 wire                        itcs2_bready_FOR_R;

 // read address
 wire [ITCS2_ADDR_WIDTH-1:0] itcs2_araddr_FOR_R;
 wire [2:0]                  itcs2_arprot_FOR_R;
 wire                        itcs2_arvalid_FOR_R;
 wire                        itcs2_arready_FOR_R;

 // read response
 wire [31:0]                 itcs2_rdata_FOR_R;
 wire                        itcs2_rvalid_FOR_R;
 wire [1:0]                  itcs2_rresp_FOR_R;
 wire                        itcs2_rready_FOR_R;

 // ===================== DTCM1 Interface =====================
 // write address
 wire [DTCS1_ADDR_WIDTH-1:0] dtcs1_awaddr_FOR_R;
 wire [2:0]                  dtcs1_awprot_FOR_R;
 wire                        dtcs1_awvalid_FOR_R;
 wire                        dtcs1_awready_FOR_R;

 // write data
 wire                        dtcs1_wvalid_FOR_R;
 wire [31:0]                 dtcs1_wdata_FOR_R;
 wire [3:0]                  dtcs1_wstrb_FOR_R;
 wire                        dtcs1_wready_FOR_R;

 // write response
 wire                        dtcs1_bvalid_FOR_R;
 wire [1:0]                  dtcs1_bresp_FOR_R;
 wire                        dtcs1_bready_FOR_R;

 // read address
 wire [DTCS1_ADDR_WIDTH-1:0] dtcs1_araddr_FOR_R;
 wire [2:0]                  dtcs1_arprot_FOR_R;
 wire                        dtcs1_arvalid_FOR_R;
 wire                        dtcs1_arready_FOR_R;

 // read response
 wire [31:0]                 dtcs1_rdata_FOR_R;
 wire                        dtcs1_rvalid_FOR_R;
 wire [1:0]                  dtcs1_rresp_FOR_R;
 wire                        dtcs1_rready_FOR_R;

 // ===================== DTCM2 Interface =====================
 // write address
 wire [DTCS2_ADDR_WIDTH-1:0] dtcs2_awaddr_FOR_R;
 wire [2:0]                  dtcs2_awprot_FOR_R;
 wire                        dtcs2_awvalid_FOR_R;
 wire                        dtcs2_awready_FOR_R;

 // write data
 wire                        dtcs2_wvalid_FOR_R;
 wire [31:0]                 dtcs2_wdata_FOR_R;
 wire [3:0]                  dtcs2_wstrb_FOR_R;
 wire                        dtcs2_wready_FOR_R;

 // write response
 wire                        dtcs2_bvalid_FOR_R;
 wire [1:0]                  dtcs2_bresp_FOR_R;
 wire                        dtcs2_bready_FOR_R;

 // read address
 wire [DTCS2_ADDR_WIDTH-1:0] dtcs2_araddr_FOR_R;
 wire [2:0]                  dtcs2_arprot_FOR_R;
 wire                        dtcs2_arvalid_FOR_R;
 wire                        dtcs2_arready_FOR_R;

 // read response
 wire [31:0]                 dtcs2_rdata_FOR_R;
 wire                        dtcs2_rvalid_FOR_R;
 wire [1:0]                  dtcs2_rresp_FOR_R;
 wire                        dtcs2_rready_FOR_R;

  //================== Internal signals for fRSmartComp_niosv
  // outputs - kept open //
 wire [31:0]                 itcm1_rd_data_a;
 wire [1:0]                  itcm1_eccstatus;  			   			   
 wire [31:0]                 dtcm1_rd_data_a;
 wire [1:0]                  dtcm1_eccstatus; 		   			   
 wire [31:0]                 itcm2_rd_data_a;
 wire [1:0]                  itcm2_eccstatus; 		   			   
 wire [31:0]                 dtcm2_rd_data_a;
 wire [1:0]                  dtcm2_eccstatus;
 // Asynchronous Reset Outputs
 wire                        reset_n_FOR_R;   // Asynchronous reset for Right CPU (active low)                                    
 wire                        reset_req_FOR_R; // CPU Right reset_req generated by fRSmartComp_niosv

 wire [31:0]                itcs1_rdata_w;
 wire [31:0]                itcs2_rdata_w;
 wire [31:0]                dtcs1_rdata_w;
 wire [31:0]                dtcs2_rdata_w;
 wire [31:0]                itcs1_rdata_FOR_R_w;
 wire [31:0]                itcs2_rdata_FOR_R_w;
 wire [31:0]                dtcs1_rdata_FOR_R_w;
 wire [31:0]                dtcs2_rdata_FOR_R_w;

 localparam DTCM1_DATA_WIDTH = 32;
 localparam DTCM2_DATA_WIDTH = 32;
 localparam DTCM1_BYTEEN_WIDTH = DTCM1_DATA_WIDTH/8;
 localparam DTCM1_NUM_WORDS  = (DTCM1_SIZE == 0) ? 1 : (DTCM1_SIZE)/4 ;
 localparam DTCM1_ADDR_WIDTH = (DTCM1_SIZE == 0) ? 1 : $clog2(DTCM1_NUM_WORDS);
 localparam DTCM2_NUM_WORDS  = (DTCM2_SIZE == 0) ? 1 : (DTCM2_SIZE)/4 ;
 localparam DTCM2_ADDR_WIDTH = (DTCM2_SIZE == 0) ? 1 : $clog2(DTCM2_NUM_WORDS);

 //Basic vs Extended Reset Control
 // Supports extra fail safe availability by allowing the user to manually control resets to left and right CPUs
 logic dcls_rreql_int, dcls_rreqr_int, dcls_rackl_int, dcls_rackr_int, dcls_ARSTn_int,
       dcls_reset_r_int, dcls_reset_req_r_int;
 //In Basic Reset mode, we use the main reset and reset_req
 // inputs to create reset signals for the right CPU.
 //leave these signals disconnected in Basic Reset mode; only drive them in Extended Reset mode
 //assign dcls_rreql =           //explicitly leave disconnected in Basic Reset mode
 //assign dcls_rreqr =           //explicitly leave disconnected in Basic Reset mode
 //assign dcls_reset_req_ack_R = //explicitly leave disconnected in Basic Reset mode
 assign dcls_rackl_int = '0;
 assign dcls_rackr_int = '0;
 assign dcls_ARSTn_int = ~reset;
 assign dcls_reset_r_int = !reset_n_FOR_R;
 assign dcls_reset_req_r_int = reset_req_FOR_R;    

 //==================RIGHT CPU INSTANCE ================
   niosv_g_core_NiosV_intel_niosv_g_0_hart # (
      .DBG_EXPN_VECTOR          (DBG_EXPN_VECTOR          ), 
      .RESET_VECTOR             (RESET_VECTOR             ),
      .USE_RESET_REQ            (USE_RESET_REQ            ), 
      .CORE_EXTN                (CORE_EXTN                ),
      .HARTID                   (HARTID                   ),
      .DISABLE_FSQRT_FDIV       (DISABLE_FSQRT_FDIV       ),
      .DEBUG_ENABLED            (DEBUG_ENABLED            ),
      .DEVICE_FAMILY            (DEVICE_FAMILY            ),
      .DBG_PARK_LOOP_OFFSET     (DBG_PARK_LOOP_OFFSET     ),
      .DBG_DATA_S_BASE          (DBG_DATA_S_BASE          ),
      .TIMER_MSIP_DATA_S_BASE   (TIMER_MSIP_DATA_S_BASE   ),
      .DATA_CACHE_SIZE          (DATA_CACHE_SIZE          ),
      .INST_CACHE_SIZE          (INST_CACHE_SIZE          ),
      .ITCM1_SIZE               (ITCM1_SIZE               ),
      .ITCM1_BASE               (ITCM1_BASE               ),
      .ITCM1_INIT_FILE          (ITCM1_INIT_FILE          ),
      .ITCM2_SIZE               (ITCM2_SIZE               ),
      .ITCM2_BASE               (ITCM2_BASE               ),
      .ITCM2_INIT_FILE          (ITCM2_INIT_FILE          ),      
      .PERIPHERAL_REGION_A_SIZE (PERIPHERAL_REGION_A_SIZE ),
      .PERIPHERAL_REGION_A_BASE (PERIPHERAL_REGION_A_BASE ),
      .PERIPHERAL_REGION_B_SIZE (PERIPHERAL_REGION_B_SIZE ),
      .PERIPHERAL_REGION_B_BASE (PERIPHERAL_REGION_B_BASE ),
      .DTCM1_SIZE               (DTCM1_SIZE               ),
      .DTCM1_BASE               (DTCM1_BASE               ),
      .DTCM1_INIT_FILE          (DTCM1_INIT_FILE          ),
      .DTCM2_SIZE               (DTCM2_SIZE               ),
      .DTCM2_BASE               (DTCM2_BASE               ),
      .DTCM2_INIT_FILE          (DTCM2_INIT_FILE          ),
      .ECC_EN                   (ECC_EN                   ),
      .ECC_FULL                 (ECC_FULL                 ),
      .BRANCHPREDICTION_EN      (BRANCHPREDICTION_EN      ),
      .ITCS1_ADDR_WIDTH         (ITCS1_ADDR_WIDTH         ),
      .ITCS2_ADDR_WIDTH         (ITCS2_ADDR_WIDTH         ),
      .DTCS1_ADDR_WIDTH         (DTCS1_ADDR_WIDTH         ),
      .DTCS2_ADDR_WIDTH         (DTCS2_ADDR_WIDTH         ),
      .NUM_PLATFORM_INTERRUPTS  (NUM_PLATFORM_INTERRUPTS  ),
      .NUM_SRF_BANKS            (NUM_SRF_BANKS            ),
      .CLIC_EN                  (CLIC_EN                  ),
      .CLIC_NUM_LEVELS          (CLIC_NUM_LEVELS          ),
      .CLIC_NUM_PRIORITIES      (CLIC_NUM_PRIORITIES      ),
      .CLIC_NUM_DEBUG_TRIGGERS  (CLIC_NUM_DEBUG_TRIGGERS  ),
      .CLIC_TRIGGER_POLARITY_EN (CLIC_TRIGGER_POLARITY_EN ),
      .CLIC_EDGE_TRIGGER_EN     (CLIC_EDGE_TRIGGER_EN     ),
      .CLIC_VT_ALIGN            (CLIC_VT_ALIGN            ),
      .CLIC_SHV_EN              (CLIC_SHV_EN              )
   ) RIGHT_CPU_inst (
      .clk                      (clk),
      .reset                    (dcls_reset_r_int),
      .reset_req                (dcls_reset_req_r_int),
      .reset_req_ack            (reset_req_ack_FOR_R),

   // AXI4-Lite Interfaces

   // ================== Instruction Interface ==================
   // write address
      .instr_awaddr            (instr_awaddr_FOR_R),
      .instr_awprot            (instr_awprot_FOR_R),
      .instr_awvalid           (instr_awvalid_FOR_R),
      .instr_awsize            (instr_awsize_FOR_R),
      .instr_awlen             (instr_awlen_FOR_R),
      .instr_awburst           (instr_awburst_FOR_R),
      .instr_awready           (instr_awready_FOR_R),

   // write data
      .instr_wvalid            (instr_wvalid_FOR_R),
      .instr_wdata             (instr_wdata_FOR_R),
      .instr_wstrb             (instr_wstrb_FOR_R),
      .instr_wlast             (instr_wlast_FOR_R),
      .instr_wready            (instr_wready_FOR_R),

   // write response
      .instr_bvalid            (instr_bvalid_FOR_R),
      .instr_bresp             (instr_bresp_FOR_R),
      .instr_bready            (instr_bready_FOR_R),

   // read address
      .instr_araddr            (instr_araddr_FOR_R),
      .instr_arprot            (instr_arprot_FOR_R),
      .instr_arvalid           (instr_arvalid_FOR_R),
      .instr_arsize            (instr_arsize_FOR_R),
      .instr_arlen             (instr_arlen_FOR_R),
      .instr_arburst           (instr_arburst_FOR_R),
      .instr_arready           (instr_arready_FOR_R),

   // read response
      .instr_rdata             (instr_rdata_FOR_R),
      .instr_rvalid            (instr_rvalid_FOR_R),
      .instr_rresp             (instr_rresp_FOR_R),
      .instr_rlast             (instr_rlast_FOR_R),
      .instr_rready            (instr_rready_FOR_R),

   // ===================== Data Interface ======================
   // write address
      .data_awaddr             (data_awaddr_FOR_R),
      .data_awprot             (data_awprot_FOR_R),
      .data_awvalid            (data_awvalid_FOR_R),
      .data_awsize             (data_awsize_FOR_R),
      .data_awlen              (data_awlen_FOR_R),
      .data_awready            (data_awready_FOR_R),

   // write data
      .data_wvalid             (data_wvalid_FOR_R),
      .data_wdata              (data_wdata_FOR_R),
      .data_wstrb              (data_wstrb_FOR_R),
      .data_wlast              (data_wlast_FOR_R),
      .data_wready             (data_wready_FOR_R),

   // write response
      .data_bvalid             (data_bvalid_FOR_R),
      .data_bresp              (data_bresp_FOR_R),
      .data_bready             (data_bready_FOR_R),

   // read address
      .data_araddr             (data_araddr_FOR_R),
      .data_arprot             (data_arprot_FOR_R),
      .data_arvalid            (data_arvalid_FOR_R),
      .data_arsize             (data_arsize_FOR_R),
      .data_arlen              (data_arlen_FOR_R),
      .data_arready            (data_arready_FOR_R),

   // read response
      .data_rdata              (data_rdata_FOR_R),
      .data_rvalid             (data_rvalid_FOR_R),
      .data_rresp              (data_rresp_FOR_R),
      .data_rlast              (data_rlast_FOR_R),
      .data_rready             (data_rready_FOR_R),

   // Interrupts
      .timer_irq               (irq_timer_FOR_R),
      .sw_irq                  (irq_sw_FOR_R),
      .plat_irq_vec            (irq_plat_vec_FOR_R),
      .ext_irq                 (irq_ext_FOR_R),
      .debug_irq               (irq_debug_FOR_R),

   // Custom Instructions
      .core_ci_data0           (core_ci_data0_FOR_R),
      .core_ci_data1           (core_ci_data1_FOR_R),
      .core_ci_alu_result      (core_ci_alu_result_FOR_R),
      .core_ci_ctrl            (core_ci_ctrl_FOR_R),
      .core_ci_enable          (core_ci_enable_FOR_R),
      .core_ci_op              (core_ci_op_FOR_R),
      .core_ci_done            (core_ci_done_FOR_R),
      .core_ci_result          (core_ci_result_FOR_R),

   // ECC
      .core_ecc_src            (core_ecc_src_FOR_R),
      .core_ecc_status         (core_ecc_status_FOR_R),

   // ===================== ITCM1 Interface =====================
   // write address
      .itcs1_awaddr            (itcs1_awaddr_FOR_R),
      .itcs1_awprot            (itcs1_awprot_FOR_R),
      .itcs1_awvalid           (itcs1_awvalid_FOR_R),
      .itcs1_awready           (itcs1_awready_FOR_R),

   // write data
      .itcs1_wvalid            (itcs1_wvalid_FOR_R),
      .itcs1_wdata             (itcs1_wdata_FOR_R),
      .itcs1_wstrb             (itcs1_wstrb_FOR_R),
      .itcs1_wready            (itcs1_wready_FOR_R),

   // write response
      .itcs1_bvalid            (itcs1_bvalid_FOR_R),
      .itcs1_bresp             (itcs1_bresp_FOR_R),
      .itcs1_bready            (itcs1_bready_FOR_R),

   // read address
      .itcs1_araddr            (itcs1_araddr_FOR_R),
      .itcs1_arprot            (itcs1_arprot_FOR_R),
      .itcs1_arvalid           (itcs1_arvalid_FOR_R),
      .itcs1_arready           (itcs1_arready_FOR_R),

   // read response
      .itcs1_rdata             (itcs1_rdata_FOR_R),
      .itcs1_rvalid            (itcs1_rvalid_FOR_R),
      .itcs1_rresp             (itcs1_rresp_FOR_R),
      .itcs1_rready            (itcs1_rready_FOR_R),

   // ===================== ITCM2 Interface =====================
   // write address
      .itcs2_awaddr            (itcs2_awaddr_FOR_R),
      .itcs2_awprot            (itcs2_awprot_FOR_R),
      .itcs2_awvalid           (itcs2_awvalid_FOR_R),
      .itcs2_awready           (itcs2_awready_FOR_R),
   // write data
      .itcs2_wvalid            (itcs2_wvalid_FOR_R),
      .itcs2_wdata             (itcs2_wdata_FOR_R),
      .itcs2_wstrb             (itcs2_wstrb_FOR_R),
      .itcs2_wready            (itcs2_wready_FOR_R),

   // write response
      .itcs2_bvalid            (itcs2_bvalid_FOR_R),
      .itcs2_bresp             (itcs2_bresp_FOR_R),
      .itcs2_bready            (itcs2_bready_FOR_R),

   // read address
      .itcs2_araddr            (itcs2_araddr_FOR_R),
      .itcs2_arprot            (itcs2_arprot_FOR_R),
      .itcs2_arvalid           (itcs2_arvalid_FOR_R),
      .itcs2_arready           (itcs2_arready_FOR_R),

   // read response
      .itcs2_rdata             (itcs2_rdata_FOR_R),
      .itcs2_rvalid            (itcs2_rvalid_FOR_R),
      .itcs2_rresp             (itcs2_rresp_FOR_R),
      .itcs2_rready            (itcs2_rready_FOR_R),

   // ===================== DTCM1 Interface =====================
   // write address
      .dtcs1_awaddr            (dtcs1_awaddr_FOR_R),
      .dtcs1_awprot            (dtcs1_awprot_FOR_R),
      .dtcs1_awvalid           (dtcs1_awvalid_FOR_R),
      .dtcs1_awready           (dtcs1_awready_FOR_R),

   // write data
      .dtcs1_wvalid            (dtcs1_wvalid_FOR_R),
      .dtcs1_wdata             (dtcs1_wdata_FOR_R),
      .dtcs1_wstrb             (dtcs1_wstrb_FOR_R),
      .dtcs1_wready            (dtcs1_wready_FOR_R),

   // write response
      .dtcs1_bvalid            (dtcs1_bvalid_FOR_R),
      .dtcs1_bresp             (dtcs1_bresp_FOR_R),
      .dtcs1_bready            (dtcs1_bready_FOR_R),

   // read address
      .dtcs1_araddr            (dtcs1_araddr_FOR_R),
      .dtcs1_arprot            (dtcs1_arprot_FOR_R),
      .dtcs1_arvalid           (dtcs1_arvalid_FOR_R),
      .dtcs1_arready           (dtcs1_arready_FOR_R),

   // read response
      .dtcs1_rdata             (dtcs1_rdata_FOR_R),
      .dtcs1_rvalid            (dtcs1_rvalid_FOR_R),
      .dtcs1_rresp             (dtcs1_rresp_FOR_R),
      .dtcs1_rready            (dtcs1_rready_FOR_R),

   // ===================== DTCM2 Interface =====================
   // write address
      .dtcs2_awaddr            (dtcs2_awaddr_FOR_R),
      .dtcs2_awprot            (dtcs2_awprot_FOR_R),
      .dtcs2_awvalid           (dtcs2_awvalid_FOR_R),
      .dtcs2_awready           (dtcs2_awready_FOR_R),

   // write data
      .dtcs2_wvalid            (dtcs2_wvalid_FOR_R),
      .dtcs2_wdata             (dtcs2_wdata_FOR_R),
      .dtcs2_wstrb             (dtcs2_wstrb_FOR_R),
      .dtcs2_wready            (dtcs2_wready_FOR_R),

   // write response
      .dtcs2_bvalid            (dtcs2_bvalid_FOR_R),
      .dtcs2_bresp             (dtcs2_bresp_FOR_R),
      .dtcs2_bready            (dtcs2_bready_FOR_R),

   // read address
      .dtcs2_araddr            (dtcs2_araddr_FOR_R),
      .dtcs2_arprot            (dtcs2_arprot_FOR_R),
      .dtcs2_arvalid           (dtcs2_arvalid_FOR_R),
      .dtcs2_arready           (dtcs2_arready_FOR_R),

   // read response
      .dtcs2_rdata             (dtcs2_rdata_FOR_R),
      .dtcs2_rvalid            (dtcs2_rvalid_FOR_R),
      .dtcs2_rresp             (dtcs2_rresp_FOR_R),
      .dtcs2_rready            (dtcs2_rready_FOR_R)
   );

 //==================SMART COMPARATOR INSTANCE ================
   niosv_frsmartcomp #( 
   .DTCM1_SIZE                 (DTCM1_SIZE),    
   .DTCM2_SIZE                 (DTCM2_SIZE),
   .ITCS1_ADDR_WIDTH           (ITCS1_ADDR_WIDTH),
   .ITCS2_ADDR_WIDTH           (ITCS2_ADDR_WIDTH),
   .DTCS1_ADDR_WIDTH           (DTCS1_ADDR_WIDTH),
   .DTCS2_ADDR_WIDTH           (DTCS2_ADDR_WIDTH),
   .DTCM1_DATA_WIDTH           (DTCM1_DATA_WIDTH),
   .DTCM2_DATA_WIDTH           (DTCM2_DATA_WIDTH),
   .PLAT_IRQ_VEC_W             (PLAT_IRQ_VEC_W),
   .Blind_Window_Period_p      (BLIND_WINDOW_PERIOD),     // Number of clock cycles for which the comparator events are automatically masked by the HW after CPU reset  
   .Default_Timeout_Period_p   (DEFAULT_TIMEOUT_PERIOD),  // Default value of Programmable Timeout on reset exit
   .Remove_Time_Diversity_p    (REMOVE_TIME_DIVERSITY)     // 0 = Time diversity of 2 clock cycles is included in the design. 1 = Time diversity of 2 clocks cycles is NOT included.
   ) frsmartcomp_inst (  
   // SYSTEM INTERFACE
   .CLK                        (clk),             // fRSmartComp_niosv clock
   .ARSTn                      (dcls_ARSTn_int),  // Hard asynchronous reset
   // To reset controller
   .RACKL                      (dcls_rackl_int),            // CPU Left reset acknowledgment
   .RACKR                      (dcls_rackr_int),            // CPU Right reset acknowledgment
   // To Virtual JTAG module instantiation
   .SILENTMODE                 (silentmode),        // Input to activate fRSmartComp_niosv SILENT mode
   // Asynchronous Reset Inputs
   .LEFT_RESET_N               (~reset),        // Asynchronous reset of Left CPU (active low)
   .LEFT_RESET_REQ             (reset_req),     // CPU Left reset_req
   .TD_ARSTn                   (~reset),        // Asynchronous reset for Time Diversity Flip Flops for the Right CPU

   // CONFIGURATION INTERFACE
   .ADDRESS                    (address),            // For agents this is a word address 64KB are used from this interface(), therefore the width is 14 (bits).
   .BYTEENABLE                 (byteenable),
   .READ                       (read),
   .WRITE                      (write),
   .WRITEDATA                  (writedata),

   // -------------------------------------------------------------------------------
   // Outputs section
   // -------------------------------------------------------------------------------
   // To reset controller
   .RREQL                      (dcls_rreql_int), // Reset request (active high) for the Left CPU.
   .RREQR                      (dcls_rreqr_int), // Reset request (active high) for the Right CPU.

   // To interrupt controller
   .INTREQ                     (intreq),          // fRSmartComp_niosv interrupt request - type pulse

   // Asynchronous Reset Outputs
   .RIGHT_RESET_N              (reset_n_FOR_R),   // Asynchronous reset for Right CPU (active low) In line with presence of time diversity
   .RIGHT_RESET_REQ            (reset_req_FOR_R), // CPU Right reset_req generated by fRSmartComp_niosv
   
   // CONFIGURATION INTERFACE
   .READDATA                   (readdata),
   .READDATAVALID              (readdatavalid),
   .WAITREQUEST                (waitrequest),     // Useful as for bridging to AHB wait states are likely necessary.

   // fRNET INTERFACE
   // ---- ALARMS ----
   .FS_OKNOK                   (fs_oknok),         // At each CLK cycle() it delivers a summary of the fRSmartComp_niosv status (anti-valent coding).
   .FN_ALARM_ERROR             (fn_alarm_error),   // Error-type output  (anti-valent coding)
   .FN_ALARM_WARNING           (fn_alarm_warning), // Warning-type output  (anti-valent coding)
   .FN_ALARM_INFO              (fn_alarm_info),    // Info-type output  (anti-valent coding)
   // ---- end ALARMS ----

   //********************************************************************
   // NIOSV INTERFACES  (Inputs from main Nios-V interface are connected, 
   // outputs were left floating)
   // ----- Main NIOSV Interface ----- connection to interconnect
   // Instruction Interface
   .reset_req                  (reset_req),
   .reset_req_ack              ( ),
   
   .instr_awaddr               ( ),
   .instr_awprot               ( ),
   .instr_awvalid              ( ),
   .instr_awsize               ( ),
   .instr_awlen                ( ),
   .instr_awburst              ( ),
   .instr_awready              (instr_awready),
   //  data
   .instr_wvalid               ( ),
   .instr_wdata                ( ),
   .instr_wstrb                ( ),
   .instr_wlast                ( ),
   .instr_wready               (instr_wready),

   //write response
   .instr_bvalid               (instr_bvalid),
   .instr_bresp                (instr_bresp),
   .instr_bready               ( ),

   //read command
   .instr_araddr               ( ),
   .instr_arprot               ( ),
   .instr_arvalid              ( ),
   .instr_arsize               ( ),
   .instr_arlen                ( ),
   .instr_arburst              ( ),
   .instr_arready              (instr_arready),

   //read response
   .instr_rdata                (instr_rdata),
   .instr_rvalid               (instr_rvalid),
   .instr_rresp                (instr_rresp),
   .instr_rlast                (instr_rlast),
   .instr_rready               ( ),

   // Data interface
   //    address
   .data_awaddr                ( ),
   .data_awprot                ( ),
   .data_awvalid               ( ),
   .data_awsize                ( ),
   .data_awlen                 ( ),
   .data_awready               (data_awready),
   //  data
   .data_wvalid                ( ),
   .data_wdata                 ( ),
   .data_wstrb                 ( ),
   .data_wlast                 ( ),
   .data_wready                (data_wready),

   //write response
   .data_bvalid                (data_bvalid),
   .data_bresp                 (data_bresp),
   .data_bready                ( ),

   //read command
   .data_araddr                ( ),
   .data_arprot                ( ),
   .data_arvalid               ( ),
   .data_arsize                ( ),
   .data_arlen                 ( ),
   .data_arready               (data_arready),

   //read response
   .data_rdata                 (data_rdata),
   .data_rvalid                (data_rvalid),
   .data_rresp                 (data_rresp),
   .data_rlast                 (data_rlast),
   .data_rready                ( ),

   .irq_timer                  (irq_timer),
   .irq_sw                     (irq_sw),
   .irq_plat_vec               (irq_plat_vec),
   .irq_ext                    (irq_ext),

   .irq_debug                  (irq_debug),

   .core_ci_data0              ( ),
   .core_ci_data1              ( ),
   .core_ci_alu_result         ( ),
   .core_ci_ctrl               ( ),
   .core_ci_enable             ( ),
   .core_ci_op                 ( ),
   .core_ci_done               ( ),
   .core_ci_result             ( ),

   .core_ecc_src               ( ),
   .core_ecc_status            ( ),
   
   // axi4-lite interface to access ITCM1
   //    address
   .itcs1_awaddr               (itcs1_awaddr),
   .itcs1_awprot               (itcs1_awprot),
   .itcs1_awvalid              (itcs1_awvalid),
   .itcs1_awready              ( ),

   //  data
   .itcs1_wvalid               (itcs1_wvalid),
   .itcs1_wdata                (itcs1_wdata),
   .itcs1_wstrb                (itcs1_wstrb),
   .itcs1_wready               ( ),

   //write response
   .itcs1_bvalid               ( ),
   .itcs1_bresp                ( ),
   .itcs1_bready               (itcs1_bready),

   //read command
   .itcs1_araddr               (itcs1_araddr),
   .itcs1_arprot               (itcs1_arprot),
   .itcs1_arvalid              (itcs1_arvalid),
   .itcs1_arready              ( ),

   //read response
   .itcs1_rdata                ( ),
   .itcs1_rvalid               ( ),
   .itcs1_rresp                ( ),
   .itcs1_rready               (itcs1_rready),

   // axi4-lite interface to access ITCM2
   //    address
   .itcs2_awaddr               (itcs2_awaddr),
   .itcs2_awprot               (itcs2_awprot),
   .itcs2_awvalid              (itcs2_awvalid),
   .itcs2_awready              ( ),
   //  data
   .itcs2_wvalid               (itcs2_wvalid),
   .itcs2_wdata                (itcs2_wdata),
   .itcs2_wstrb                (itcs2_wstrb),
   .itcs2_wready               ( ),

   //write response
   .itcs2_bvalid               ( ),
   .itcs2_bresp                ( ),
   .itcs2_bready               (itcs2_bready),

   //read command
   .itcs2_araddr               (itcs2_araddr),
   .itcs2_arprot               (itcs2_arprot),
   .itcs2_arvalid              (itcs2_arvalid),
   .itcs2_arready              ( ),

   //read response
   .itcs2_rdata                ( ),
   .itcs2_rvalid               ( ),
   .itcs2_rresp                ( ),
   .itcs2_rready               (itcs2_rready),

   // axi4-lite interface to access DTCM1
   //    address
   .dtcs1_awaddr               (dtcs1_awaddr),
   .dtcs1_awprot               (dtcs1_awprot),
   .dtcs1_awvalid              (dtcs1_awvalid),
   .dtcs1_awready              ( ),

   //  data
   .dtcs1_wvalid               (dtcs1_wvalid),
   .dtcs1_wdata                (dtcs1_wdata),
   .dtcs1_wstrb                (dtcs1_wstrb),
   .dtcs1_wready               ( ),

   //write response
   .dtcs1_bvalid               ( ),
   .dtcs1_bresp                ( ),
   .dtcs1_bready               (dtcs1_bready),

   //read command
   .dtcs1_araddr               (dtcs1_araddr),
   .dtcs1_arprot               (dtcs1_arprot),
   .dtcs1_arvalid              (dtcs1_arvalid),
   .dtcs1_arready              ( ),

   //read response
   .dtcs1_rdata                ( ),
   .dtcs1_rvalid               ( ),
   .dtcs1_rresp                ( ),
   .dtcs1_rready               (dtcs1_rready),

   // axi4-lite interface to access DTCM2
   //    address
   .dtcs2_awaddr               (dtcs2_awaddr),
   .dtcs2_awprot               (dtcs2_awprot),
   .dtcs2_awvalid              (dtcs2_awvalid),
   .dtcs2_awready              ( ),

   //  data
   .dtcs2_wvalid               (dtcs2_wvalid),
   .dtcs2_wdata                (dtcs2_wdata),
   .dtcs2_wstrb                (dtcs2_wstrb),
   .dtcs2_wready               ( ),

   //write response
   .dtcs2_bvalid               ( ),
   .dtcs2_bresp                ( ),
   .dtcs2_bready               (dtcs2_bready),

   //read command
   .dtcs2_araddr               (dtcs2_araddr),
   .dtcs2_arprot               (dtcs2_arprot),
   .dtcs2_arvalid              (dtcs2_arvalid),
   .dtcs2_arready              ( ),

   //read response
   .dtcs2_rdata                ( ),
   .dtcs2_rvalid               ( ),
   .dtcs2_rresp                ( ),
   .dtcs2_rready               (dtcs2_rready),

   // Dummy output not connected to external module////  
   // TCM MEMORY AND CPU INTERFACE   
   // TCM1 INSTRUCTION
   .itcm1_rd_data_a            (itcm1_rd_data_a),
   .itcm1_eccstatus            (itcm1_eccstatus),

   // TCM1 DATA
   .dtcm1_rd_data_a            (dtcm1_rd_data_a),
   .dtcm1_eccstatus            (dtcm1_eccstatus),

   // TCM2 INSTRUCTION
   .itcm2_rd_data_a            (itcm2_rd_data_a),
   .itcm2_eccstatus            (itcm2_eccstatus),
   // TCM2 DATA 
   .dtcm2_rd_data_a            (dtcm2_rd_data_a),
   .dtcm2_eccstatus            (dtcm2_eccstatus),

   //********************************************************************
   // Interface to Left CPU (Outputs from left CPU "Master/Host" are 
   // connected for comparison, Inputs from left CPU "Master/Host" were 
   // left floating)
   .reset_req_FOR_L            (),
   .reset_req_ack_FOR_L        (reset_req_ack),

   // Instruction Interface
   //    address
   .instr_awaddr_FOR_L         (instr_awaddr),
   .instr_awprot_FOR_L         (instr_awprot),
   .instr_awvalid_FOR_L        (instr_awvalid),
   .instr_awsize_FOR_L         (instr_awsize),
   .instr_awlen_FOR_L          (instr_awlen),
   .instr_awburst_FOR_L        (instr_awburst),
   .instr_awready_FOR_L        ( ),
   //  data
   .instr_wvalid_FOR_L         (instr_wvalid),
   .instr_wdata_FOR_L          (instr_wdata),
   .instr_wstrb_FOR_L          (instr_wstrb),
   .instr_wlast_FOR_L          (instr_wlast),
   .instr_wready_FOR_L         ( ),

   //write response
   .instr_bvalid_FOR_L         ( ),
   .instr_bresp_FOR_L          ( ),
   .instr_bready_FOR_L         (instr_bready),

   //read command
   .instr_araddr_FOR_L         (instr_araddr),
   .instr_arprot_FOR_L         (instr_arprot),
   .instr_arvalid_FOR_L        (instr_arvalid),
   .instr_arsize_FOR_L         (instr_arsize),
   .instr_arlen_FOR_L          (instr_arlen),
   .instr_arburst_FOR_L        (instr_arburst),
   .instr_arready_FOR_L        ( ),

   //read response
   .instr_rdata_FOR_L          ( ),
   .instr_rvalid_FOR_L         ( ),
   .instr_rresp_FOR_L          ( ),
   .instr_rlast_FOR_L          ( ),
   .instr_rready_FOR_L         (instr_rready),
   // Data interface
   //    address
   .data_awaddr_FOR_L          (data_awaddr),
   .data_awprot_FOR_L          (data_awprot),
   .data_awvalid_FOR_L         (data_awvalid),
   .data_awsize_FOR_L          (data_awsize),
   .data_awlen_FOR_L           (data_awlen),
   .data_awready_FOR_L         ( ),
   //  data
   .data_wvalid_FOR_L          (data_wvalid),
   .data_wdata_FOR_L           (data_wdata),
   .data_wstrb_FOR_L           (data_wstrb),
   .data_wlast_FOR_L           (data_wlast),
   .data_wready_FOR_L          ( ),

   //write response
   .data_bvalid_FOR_L          ( ),
   .data_bresp_FOR_L           ( ),
   .data_bready_FOR_L          (data_bready),

   //read command
   .data_araddr_FOR_L          (data_araddr),
   .data_arprot_FOR_L          (data_arprot),
   .data_arvalid_FOR_L         (data_arvalid),
   .data_arsize_FOR_L          (data_arsize),
   .data_arlen_FOR_L           (data_arlen),
   .data_arready_FOR_L         ( ),

   //read response
   .data_rdata_FOR_L           ( ),
   .data_rvalid_FOR_L          ( ),
   .data_rresp_FOR_L           ( ),
   .data_rlast_FOR_L           ( ),
   .data_rready_FOR_L          (data_rready),

   .irq_timer_FOR_L            ( ),
   .irq_sw_FOR_L               ( ),
   .irq_plat_vec_FOR_L         ( ),
   .irq_ext_FOR_L              ( ),
   .irq_debug_FOR_L            ( ),

   .core_ci_data0_FOR_L        (core_ci_data0),
   .core_ci_data1_FOR_L        (core_ci_data1),
   .core_ci_alu_result_FOR_L   (core_ci_alu_result),
   .core_ci_ctrl_FOR_L         (core_ci_ctrl),
   .core_ci_enable_FOR_L       (core_ci_enable),
   .core_ci_op_FOR_L           (core_ci_op),
   .core_ci_done_FOR_L         (/*core_ci_done*/),
   .core_ci_result_FOR_L       (/*core_ci_result*/),

   .core_ecc_src_FOR_L         (core_ecc_src),
   .core_ecc_status_FOR_L      (core_ecc_status),
   
   
   // axi4-lite interface to access ITCM1
   //    address
   .itcs1_awaddr_FOR_L         ( ),
   .itcs1_awprot_FOR_L         ( ),
   .itcs1_awvalid_FOR_L        ( ),
   .itcs1_awready_FOR_L        (itcs1_awready),

   //  data
   .itcs1_wvalid_FOR_L         ( ),
   .itcs1_wdata_FOR_L          ( ),
   .itcs1_wstrb_FOR_L          ( ),
   .itcs1_wready_FOR_L         (itcs1_wready),

   //write response
   .itcs1_bvalid_FOR_L         (itcs1_bvalid),
   .itcs1_bresp_FOR_L          (itcs1_bresp),
   .itcs1_bready_FOR_L         ( ),

   //read command
   .itcs1_araddr_FOR_L         ( ),
   .itcs1_arprot_FOR_L         ( ),
   .itcs1_arvalid_FOR_L        ( ),
   .itcs1_arready_FOR_L        (itcs1_arready),

   //read response
   .itcs1_rdata_FOR_L          (itcs1_rdata_w),
   .itcs1_rvalid_FOR_L         (itcs1_rvalid),
   .itcs1_rresp_FOR_L          (itcs1_rresp),
   .itcs1_rready_FOR_L         ( ),

   // axi4-lite interface to access ITCM2
    //    address
   .itcs2_awaddr_FOR_L         ( ),
   .itcs2_awprot_FOR_L         ( ),
   .itcs2_awvalid_FOR_L        ( ),
   .itcs2_awready_FOR_L        (itcs2_awready),
   //  data
   .itcs2_wvalid_FOR_L         ( ),
   .itcs2_wdata_FOR_L          ( ),
   .itcs2_wstrb_FOR_L          ( ),
   .itcs2_wready_FOR_L         (itcs2_wready),

   //write response
   .itcs2_bvalid_FOR_L         (itcs2_bvalid),
   .itcs2_bresp_FOR_L          (itcs2_bresp),
   .itcs2_bready_FOR_L         ( ),

   //read command
   .itcs2_araddr_FOR_L         ( ),
   .itcs2_arprot_FOR_L         ( ),
   .itcs2_arvalid_FOR_L        ( ),
   .itcs2_arready_FOR_L        (itcs2_arready),

   //read response
   .itcs2_rdata_FOR_L          (itcs2_rdata_w),
   .itcs2_rvalid_FOR_L         (itcs2_rvalid),
   .itcs2_rresp_FOR_L          (itcs2_rresp),
   .itcs2_rready_FOR_L         ( ),

   // axi4-lite interface to access DTCM1
   //    address
   .dtcs1_awaddr_FOR_L         ( ),
   .dtcs1_awprot_FOR_L         ( ),
   .dtcs1_awvalid_FOR_L        ( ),
   .dtcs1_awready_FOR_L        (dtcs1_awready),

   //  data
   .dtcs1_wvalid_FOR_L         ( ),
   .dtcs1_wdata_FOR_L          ( ),
   .dtcs1_wstrb_FOR_L          ( ),
   .dtcs1_wready_FOR_L         (dtcs1_wready),

   //write response
   .dtcs1_bvalid_FOR_L         (dtcs1_bvalid),
   .dtcs1_bresp_FOR_L          (dtcs1_bresp),
   .dtcs1_bready_FOR_L         ( ),

   //read command
   .dtcs1_araddr_FOR_L         ( ),
   .dtcs1_arprot_FOR_L         ( ),
   .dtcs1_arvalid_FOR_L        ( ),
   .dtcs1_arready_FOR_L        (dtcs1_arready),

   //read response
   .dtcs1_rdata_FOR_L          (dtcs1_rdata_w),
   .dtcs1_rvalid_FOR_L         (dtcs1_rvalid),
   .dtcs1_rresp_FOR_L          (dtcs1_rresp),
   .dtcs1_rready_FOR_L         ( ),

   // axi4-lite interface to access DTCM2
   //    address
   .dtcs2_awaddr_FOR_L         ( ),
   .dtcs2_awprot_FOR_L         ( ),
   .dtcs2_awvalid_FOR_L        ( ),
   .dtcs2_awready_FOR_L        (dtcs2_awready),

   //  data
   .dtcs2_wvalid_FOR_L         ( ),
   .dtcs2_wdata_FOR_L          ( ),
   .dtcs2_wstrb_FOR_L          ( ),
   .dtcs2_wready_FOR_L         (dtcs2_wready),

   //write response
   .dtcs2_bvalid_FOR_L         (dtcs2_bvalid),
   .dtcs2_bresp_FOR_L          (dtcs2_bresp),
   .dtcs2_bready_FOR_L         ( ),

   //read command
   .dtcs2_araddr_FOR_L         ( ),
   .dtcs2_arprot_FOR_L         ( ),
   .dtcs2_arvalid_FOR_L        ( ),
   .dtcs2_arready_FOR_L        (dtcs2_arready),

   //read response
   .dtcs2_rdata_FOR_L          (dtcs2_rdata_w),
   .dtcs2_rvalid_FOR_L         (dtcs2_rvalid),
   .dtcs2_rresp_FOR_L          (dtcs2_rresp),
   .dtcs2_rready_FOR_L         ( ),     
   
   // TCM MEMORY AND CPU INTERFACE   
   // TCM1 INSTRUCTION
   .itcm1_rd_data_a_FOR_L      ('0),
   .itcm1_eccstatus_FOR_L      ('0),
  // TCM1 DATA
   .dtcm1_rd_data_a_FOR_L      ('0),
   .dtcm1_eccstatus_FOR_L      ('0),
  // TCM2 INSTRUCTION
   .itcm2_rd_data_a_FOR_L      ('0),
   .itcm2_eccstatus_FOR_L      ('0),
   // TCM2 DATA 
   .dtcm2_rd_data_a_FOR_L      ('0),
   .dtcm2_eccstatus_FOR_L      ('0),  

   // Interface to Right CPU 
   //.reset_req_FOR_R            (reset_req_FOR_R),
   .reset_req_ack_FOR_R        (reset_req_ack_FOR_R),
  
   // Instruction Interface
   //    address
   .instr_awaddr_FOR_R         (instr_awaddr_FOR_R),
   .instr_awprot_FOR_R         (instr_awprot_FOR_R),
   .instr_awvalid_FOR_R        (instr_awvalid_FOR_R),
   .instr_awsize_FOR_R         (instr_awsize_FOR_R),
   .instr_awlen_FOR_R          (instr_awlen_FOR_R),
   .instr_awburst_FOR_R        (instr_awburst_FOR_R),
   .instr_awready_FOR_R        (instr_awready_FOR_R),
   //  data
   .instr_wvalid_FOR_R         (instr_wvalid_FOR_R),
   .instr_wdata_FOR_R          (instr_wdata_FOR_R),
   .instr_wstrb_FOR_R          (instr_wstrb_FOR_R),
   .instr_wlast_FOR_R          (instr_wlast_FOR_R),
   .instr_wready_FOR_R         (instr_wready_FOR_R),

   //write response
   .instr_bvalid_FOR_R         (instr_bvalid_FOR_R),
   .instr_bresp_FOR_R          (instr_bresp_FOR_R),
   .instr_bready_FOR_R         (instr_bready_FOR_R),

   //read command
   .instr_araddr_FOR_R         (instr_araddr_FOR_R),
   .instr_arprot_FOR_R         (instr_arprot_FOR_R),
   .instr_arvalid_FOR_R        (instr_arvalid_FOR_R),
   .instr_arsize_FOR_R         (instr_arsize_FOR_R),
   .instr_arlen_FOR_R          (instr_arlen_FOR_R),
   .instr_arburst_FOR_R        (instr_arburst_FOR_R),
   .instr_arready_FOR_R        (instr_arready_FOR_R),

   //read response
   .instr_rdata_FOR_R          (instr_rdata_FOR_R),
   .instr_rvalid_FOR_R         (instr_rvalid_FOR_R),
   .instr_rresp_FOR_R          (instr_rresp_FOR_R),
   .instr_rlast_FOR_R          (instr_rlast_FOR_R),
   .instr_rready_FOR_R         (instr_rready_FOR_R),
   // Data interface
   // write command
   //    address
   .data_awaddr_FOR_R          (data_awaddr_FOR_R),
   .data_awprot_FOR_R          (data_awprot_FOR_R),
   .data_awvalid_FOR_R         (data_awvalid_FOR_R),
   .data_awsize_FOR_R          (data_awsize_FOR_R),
   .data_awlen_FOR_R           (data_awlen_FOR_R),
   .data_awready_FOR_R         (data_awready_FOR_R),
   //  data
   .data_wvalid_FOR_R          (data_wvalid_FOR_R),
   .data_wdata_FOR_R           (data_wdata_FOR_R),
   .data_wstrb_FOR_R           (data_wstrb_FOR_R),
   .data_wlast_FOR_R           (data_wlast_FOR_R),
   .data_wready_FOR_R          (data_wready_FOR_R),

   //write response
   .data_bvalid_FOR_R          (data_bvalid_FOR_R),
   .data_bresp_FOR_R           (data_bresp_FOR_R),
   .data_bready_FOR_R          (data_bready_FOR_R),

   //read command
   .data_araddr_FOR_R          (data_araddr_FOR_R),
   .data_arprot_FOR_R          (data_arprot_FOR_R),
   .data_arvalid_FOR_R         (data_arvalid_FOR_R),
   .data_arsize_FOR_R          (data_arsize_FOR_R),
   .data_arlen_FOR_R           (data_arlen_FOR_R),
   .data_arready_FOR_R         (data_arready_FOR_R),

   //read response
   .data_rdata_FOR_R           (data_rdata_FOR_R),
   .data_rvalid_FOR_R          (data_rvalid_FOR_R),
   .data_rresp_FOR_R           (data_rresp_FOR_R),
   .data_rlast_FOR_R           (data_rlast_FOR_R),
   .data_rready_FOR_R          (data_rready_FOR_R),

   .irq_timer_FOR_R            (irq_timer_FOR_R),
   .irq_sw_FOR_R               (irq_sw_FOR_R),
   .irq_plat_vec_FOR_R         (irq_plat_vec_FOR_R),
   .irq_ext_FOR_R              (irq_ext_FOR_R),
   .irq_debug_FOR_R            (irq_debug_FOR_R),

   .core_ci_data0_FOR_R        (core_ci_data0_FOR_R),
   .core_ci_data1_FOR_R        (core_ci_data1_FOR_R),
   .core_ci_alu_result_FOR_R   (core_ci_alu_result_FOR_R),
   .core_ci_ctrl_FOR_R         (core_ci_ctrl_FOR_R),
   .core_ci_enable_FOR_R       (core_ci_enable_FOR_R),
   .core_ci_op_FOR_R           (core_ci_op_FOR_R),
   .core_ci_done_FOR_R         (core_ci_done_FOR_R),
   .core_ci_result_FOR_R       (core_ci_result_FOR_R),

   .core_ecc_src_FOR_R         (core_ecc_src_FOR_R),
   .core_ecc_status_FOR_R      (core_ecc_status_FOR_R),
  
   // axi4-lite interface to access ITCM1
   //    address
   .itcs1_awaddr_FOR_R         (itcs1_awaddr_FOR_R),
   .itcs1_awprot_FOR_R         (itcs1_awprot_FOR_R),
   .itcs1_awvalid_FOR_R        (itcs1_awvalid_FOR_R),
   .itcs1_awready_FOR_R        (itcs1_awready_FOR_R),
   //  data
   .itcs1_wvalid_FOR_R         (itcs1_wvalid_FOR_R),
   .itcs1_wdata_FOR_R          (itcs1_wdata_FOR_R),
   .itcs1_wstrb_FOR_R          (itcs1_wstrb_FOR_R),
   .itcs1_wready_FOR_R         (itcs1_wready_FOR_R),
   //write response
   .itcs1_bvalid_FOR_R         (itcs1_bvalid_FOR_R),
   .itcs1_bresp_FOR_R          (itcs1_bresp_FOR_R),
   .itcs1_bready_FOR_R         (itcs1_bready_FOR_R),
   //read command
   .itcs1_araddr_FOR_R         (itcs1_araddr_FOR_R),
   .itcs1_arprot_FOR_R         (itcs1_arprot_FOR_R),
   .itcs1_arvalid_FOR_R        (itcs1_arvalid_FOR_R),
   .itcs1_arready_FOR_R        (itcs1_arready_FOR_R),
   //read response
   .itcs1_rdata_FOR_R          (itcs1_rdata_FOR_R_w),
   .itcs1_rvalid_FOR_R         (itcs1_rvalid_FOR_R),
   .itcs1_rresp_FOR_R          (itcs1_rresp_FOR_R),
   .itcs1_rready_FOR_R         (itcs1_rready_FOR_R),
   // axi4-lite interface to access ITCM2
   //    address
   .itcs2_awaddr_FOR_R         (itcs2_awaddr_FOR_R),
   .itcs2_awprot_FOR_R         (itcs2_awprot_FOR_R),
   .itcs2_awvalid_FOR_R        (itcs2_awvalid_FOR_R),
   .itcs2_awready_FOR_R        (itcs2_awready_FOR_R),
   //  data
   .itcs2_wvalid_FOR_R         (itcs2_wvalid_FOR_R),
   .itcs2_wdata_FOR_R          (itcs2_wdata_FOR_R),
   .itcs2_wstrb_FOR_R          (itcs2_wstrb_FOR_R),
   .itcs2_wready_FOR_R         (itcs2_wready_FOR_R),
   //write response
   .itcs2_bvalid_FOR_R         (itcs2_bvalid_FOR_R),
   .itcs2_bresp_FOR_R          (itcs2_bresp_FOR_R),
   .itcs2_bready_FOR_R         (itcs2_bready_FOR_R),  
   //read command
   .itcs2_araddr_FOR_R         (itcs2_araddr_FOR_R),
   .itcs2_arprot_FOR_R         (itcs2_arprot_FOR_R),
   .itcs2_arvalid_FOR_R        (itcs2_arvalid_FOR_R),
   .itcs2_arready_FOR_R        (itcs2_arready_FOR_R),  
   //read response
   .itcs2_rdata_FOR_R          (itcs2_rdata_FOR_R_w),
   .itcs2_rvalid_FOR_R         (itcs2_rvalid_FOR_R),
   .itcs2_rresp_FOR_R          (itcs2_rresp_FOR_R),
   .itcs2_rready_FOR_R         (itcs2_rready_FOR_R),
   // axi4-lite interface to access DTCM1
   //    address
   .dtcs1_awaddr_FOR_R         (dtcs1_awaddr_FOR_R),
   .dtcs1_awprot_FOR_R         (dtcs1_awprot_FOR_R),
   .dtcs1_awvalid_FOR_R        (dtcs1_awvalid_FOR_R),
   .dtcs1_awready_FOR_R        (dtcs1_awready_FOR_R),  
   //  data
   .dtcs1_wvalid_FOR_R         (dtcs1_wvalid_FOR_R),
   .dtcs1_wdata_FOR_R          (dtcs1_wdata_FOR_R),
   .dtcs1_wstrb_FOR_R          (dtcs1_wstrb_FOR_R),
   .dtcs1_wready_FOR_R         (dtcs1_wready_FOR_R),  
   //write response
   .dtcs1_bvalid_FOR_R         (dtcs1_bvalid_FOR_R),
   .dtcs1_bresp_FOR_R          (dtcs1_bresp_FOR_R),
   .dtcs1_bready_FOR_R         (dtcs1_bready_FOR_R),  
   //read command
   .dtcs1_araddr_FOR_R         (dtcs1_araddr_FOR_R),
   .dtcs1_arprot_FOR_R         (dtcs1_arprot_FOR_R),
   .dtcs1_arvalid_FOR_R        (dtcs1_arvalid_FOR_R),
   .dtcs1_arready_FOR_R        (dtcs1_arready_FOR_R),  
   //read response
   .dtcs1_rdata_FOR_R          (dtcs1_rdata_FOR_R_w),
   .dtcs1_rvalid_FOR_R         (dtcs1_rvalid_FOR_R),
   .dtcs1_rresp_FOR_R          (dtcs1_rresp_FOR_R),
   .dtcs1_rready_FOR_R         (dtcs1_rready_FOR_R),
   // axi4-lite interface to access DTCM2
   //    address
   .dtcs2_awaddr_FOR_R         (dtcs2_awaddr_FOR_R),
   .dtcs2_awprot_FOR_R         (dtcs2_awprot_FOR_R),
   .dtcs2_awvalid_FOR_R        (dtcs2_awvalid_FOR_R),
   .dtcs2_awready_FOR_R        (dtcs2_awready_FOR_R),
   //  data
   .dtcs2_wvalid_FOR_R         (dtcs2_wvalid_FOR_R),
   .dtcs2_wdata_FOR_R          (dtcs2_wdata_FOR_R),
   .dtcs2_wstrb_FOR_R          (dtcs2_wstrb_FOR_R),
   .dtcs2_wready_FOR_R         (dtcs2_wready_FOR_R),
   //write response
   .dtcs2_bvalid_FOR_R         (dtcs2_bvalid_FOR_R),
   .dtcs2_bresp_FOR_R          (dtcs2_bresp_FOR_R),
   .dtcs2_bready_FOR_R         (dtcs2_bready_FOR_R), 
   //read command
   .dtcs2_araddr_FOR_R         (dtcs2_araddr_FOR_R),
   .dtcs2_arprot_FOR_R         (dtcs2_arprot_FOR_R),
   .dtcs2_arvalid_FOR_R        (dtcs2_arvalid_FOR_R),
   .dtcs2_arready_FOR_R        (dtcs2_arready_FOR_R),
   //read response
   .dtcs2_rdata_FOR_R          (dtcs2_rdata_FOR_R_w),
   .dtcs2_rvalid_FOR_R         (dtcs2_rvalid_FOR_R),
   .dtcs2_rresp_FOR_R          (dtcs2_rresp_FOR_R),
   .dtcs2_rready_FOR_R         (dtcs2_rready_FOR_R),

   // TCM MEMORY AND CPU INTERFACE  
   // Interface to Right CPU
   .itcm1_rd_data_a_FOR_R      ('0),
   .itcm1_eccstatus_FOR_R      ('0), 
   .dtcm1_rd_data_a_FOR_R      ('0),
   .dtcm1_eccstatus_FOR_R      ('0),
   .itcm2_rd_data_a_FOR_R      ('0),
   .itcm2_eccstatus_FOR_R      ('0),
   .dtcm2_rd_data_a_FOR_R      ('0),
   .dtcm2_eccstatus_FOR_R      ('0),
   // DTCM 1-2 signals from LSU
   .dtcm1_addr_FOR_L           ('0),
   .dtcm1_wr_en_FOR_L          ('0),
   .dtcm_wr_data_FOR_L         ('0),
   .dtcm_wr_byteen_FOR_L       ('0),
   .dtcm2_addr_FOR_L           ('0),
   .dtcm2_wr_en_FOR_L          ('0),
   .dtcm1_addr_FOR_R           ('0),
   .dtcm1_wr_en_FOR_R          ('0),
   .dtcm_wr_data_FOR_R         ('0),
   .dtcm_wr_byteen_FOR_R       ('0),
   .dtcm2_addr_FOR_R           ('0),
   .dtcm2_wr_en_FOR_R          ('0)
   );


   niosv_g_core_NiosV_intel_niosv_g_0_hart # (
      .DBG_EXPN_VECTOR          (DBG_EXPN_VECTOR          ), 
      .RESET_VECTOR             (RESET_VECTOR             ),
      .USE_RESET_REQ            (USE_RESET_REQ            ), 
      .CORE_EXTN                (CORE_EXTN                ),
      .HARTID                   (HARTID                   ),
      .DISABLE_FSQRT_FDIV       (DISABLE_FSQRT_FDIV       ),
      .DEBUG_ENABLED            (DEBUG_ENABLED            ),
      .DEVICE_FAMILY            (DEVICE_FAMILY            ),
      .DBG_PARK_LOOP_OFFSET     (DBG_PARK_LOOP_OFFSET     ),
      .DBG_DATA_S_BASE          (DBG_DATA_S_BASE          ),
      .TIMER_MSIP_DATA_S_BASE   (TIMER_MSIP_DATA_S_BASE   ),
      .DATA_CACHE_SIZE          (DATA_CACHE_SIZE          ),
      .INST_CACHE_SIZE          (INST_CACHE_SIZE          ),
      .ITCM1_SIZE               (ITCM1_SIZE               ),
      .ITCM1_BASE               (ITCM1_BASE               ),
      .ITCM1_INIT_FILE          (ITCM1_INIT_FILE          ),
      .ITCM2_SIZE               (ITCM2_SIZE               ),
      .ITCM2_BASE               (ITCM2_BASE               ),
      .ITCM2_INIT_FILE          (ITCM2_INIT_FILE          ),      
      .PERIPHERAL_REGION_A_SIZE (PERIPHERAL_REGION_A_SIZE ),
      .PERIPHERAL_REGION_A_BASE (PERIPHERAL_REGION_A_BASE ),
      .PERIPHERAL_REGION_B_SIZE (PERIPHERAL_REGION_B_SIZE ),
      .PERIPHERAL_REGION_B_BASE (PERIPHERAL_REGION_B_BASE ),
      .DTCM1_SIZE               (DTCM1_SIZE               ),
      .DTCM1_BASE               (DTCM1_BASE               ),
      .DTCM1_INIT_FILE          (DTCM1_INIT_FILE          ),
      .DTCM2_SIZE               (DTCM2_SIZE               ),
      .DTCM2_BASE               (DTCM2_BASE               ),
      .DTCM2_INIT_FILE          (DTCM2_INIT_FILE          ),
      .ECC_EN                   (ECC_EN                   ),
      .ECC_FULL                 (ECC_FULL                 ),
      .BRANCHPREDICTION_EN      (BRANCHPREDICTION_EN      ),
      .ITCS1_ADDR_WIDTH         (ITCS1_ADDR_WIDTH         ),
      .ITCS2_ADDR_WIDTH         (ITCS2_ADDR_WIDTH         ),
      .DTCS1_ADDR_WIDTH         (DTCS1_ADDR_WIDTH         ),
      .DTCS2_ADDR_WIDTH         (DTCS2_ADDR_WIDTH         ),
      .NUM_PLATFORM_INTERRUPTS  (NUM_PLATFORM_INTERRUPTS  ),
      .NUM_SRF_BANKS            (NUM_SRF_BANKS            ),
      .CLIC_EN                  (CLIC_EN                  ),
      .CLIC_NUM_LEVELS          (CLIC_NUM_LEVELS          ),
      .CLIC_NUM_PRIORITIES      (CLIC_NUM_PRIORITIES      ),
      .CLIC_NUM_DEBUG_TRIGGERS  (CLIC_NUM_DEBUG_TRIGGERS  ),
      .CLIC_TRIGGER_POLARITY_EN (CLIC_TRIGGER_POLARITY_EN ),
      .CLIC_EDGE_TRIGGER_EN     (CLIC_EDGE_TRIGGER_EN     ),
      .CLIC_VT_ALIGN            (CLIC_VT_ALIGN            ),
      .CLIC_SHV_EN              (CLIC_SHV_EN              )
   ) core_inst (
      .* 
   );
   assign core_ci_done = 1'b0;
   assign core_ci_result = 32'b0;




endmodule

