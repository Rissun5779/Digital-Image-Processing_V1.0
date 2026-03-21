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


///////////////////////////////////////////////////////////////////////////////
// Top-level wrapper of EMIF Configurable Avalon Traffic Generator.
//
///////////////////////////////////////////////////////////////////////////////
module altera_emif_avl_tg_2_top # (
   parameter PROTOCOL_ENUM                           = "",
   parameter MEGAFUNC_DEVICE_FAMILY                  = "",
   parameter USE_SIMPLE_TG                           = 0,
   // SHORT -> Suitable for simulation only.
   // MEDIUM -> Generates more traffic for simple hardware testing in seconds.
   // INFINITE -> Generates traffic continuously and indefinitely.
   parameter TEST_DURATION                           = "SHORT",

   // Bypass the default traffic pattern
   parameter BYPASS_DEFAULT_PATTERN                  = 0,

   // Bypass the user test stage after a reset
   parameter BYPASS_USER_STAGE                       = 1,

   // Bypass the repeated writes/repeated reads test stage
   parameter BYPASS_REPEAT_STAGE                     = 1,

   // Bypass the stress pattern stage
   parameter BYPASS_STRESS_STAGE                     = 1,

   // Number of controller ports
   parameter NUM_OF_CTRL_PORTS                       = 1,

   // Is this in ping-pong configuration?
   parameter PHY_PING_PONG_EN                        = 0,

   // Indicates whether a separate interface exists for reads and writes.
   // Typically set to 1 for QDR-style interfaces where concurrent reads and
   // writes are possible. If set to true, interface 0 is the read-only
   // interface, interface 1 is the write-only interface.
   // This is a boolean parameter.
   parameter SEPARATE_READ_WRITE_IFS                 = 0,

   // Avalon protocol used by the controller
   parameter CTRL_AVL_PROTOCOL_ENUM                  = "",

   // Indicates whether Avalon byte-enable signal is used
   parameter USE_AVL_BYTEEN                          = 1,

   // Specifies alignment criteria for Avalon-MM word addresses and burst count
   parameter AMM_WORD_ADDRESS_DIVISIBLE_BY           = 1,
   parameter AMM_BURST_COUNT_DIVISIBLE_BY            = 1,

   // The traffic generator is an Avalon master, and therefore generates symbol-
   // addresses that are word-aligned when the protocol specified is Avalon-MM.
   // To generate word-aligned addresses it must know the word address width.
   parameter AMM_WORD_ADDRESS_WIDTH                  = 1,

   // Definition of port widths for "ctrl_amm" interface (auto-generated)
   parameter PORT_CTRL_AMM_RDATA_WIDTH               = 1,
   parameter PORT_CTRL_AMM_ADDRESS_WIDTH             = 1,
   parameter PORT_CTRL_AMM_WDATA_WIDTH               = 1,
   parameter PORT_CTRL_AMM_BCOUNT_WIDTH              = 1,
   parameter PORT_CTRL_AMM_BYTEEN_WIDTH              = 1,

   // Definition of port widths for "ctrl_user_refresh" interface
   parameter PORT_CTRL_USER_REFRESH_REQ_WIDTH        = 1,
   parameter PORT_CTRL_USER_REFRESH_BANK_WIDTH       = 1,

   // Definition of port widths for "ctrl_self_refresh" interface
   parameter PORT_CTRL_SELF_REFRESH_REQ_WIDTH        = 1,

   // Definition of port widths for "ctrl_mmr" interface
   parameter PORT_CTRL_MMR_MASTER_ADDRESS_WIDTH      = 1,
   parameter PORT_CTRL_MMR_MASTER_RDATA_WIDTH        = 1,
   parameter PORT_CTRL_MMR_MASTER_WDATA_WIDTH        = 1,
   parameter PORT_CTRL_MMR_MASTER_BCOUNT_WIDTH       = 1,

   // Definition of port widths for "tg_cfg" interface
   parameter PORT_TG_CFG_ADDRESS_WIDTH      = 1,
   parameter PORT_TG_CFG_RDATA_WIDTH        = 1,
   parameter PORT_TG_CFG_WDATA_WIDTH        = 1,

   parameter MEM_TTL_DATA_WIDTH = 1,
   parameter MEM_TTL_NUM_OF_WRITE_GROUPS = 1,
   parameter MEM_RANK_WIDTH = 1,
   parameter MEM_BANK_ADDR_WIDTH = 1,
   parameter MEM_ROW_ADDR_WIDTH = 1,
   parameter MEM_BANK_GROUP_WIDTH = 1,

   parameter ROW_ADDR_LSB   = 1,
   parameter BANK_ADDR_LSB  = 1,
   parameter COL_ADDR_LSB   = 1,
   parameter BANK_GROUP_LSB = 1,
   parameter RANK_LSB       = 1,

   parameter AVL_TO_DQ_WIDTH_RATIO = 1,

   parameter DIAG_TG_DATA_PATTERN_LENGTH = 1,
   parameter DIAG_TG_BE_PATTERN_LENGTH = 1
) (
   // User reset
   input  logic                                               emif_usr_reset_n,

   // User reset (for secondary interface of ping-pong)
   input  logic                                               emif_usr_reset_n_sec,

   // User clock
   input  logic                                               emif_usr_clk,

   // User clock (for secondary interface of ping-pong)
   input  logic                                               emif_usr_clk_sec,

   // Ports for "ctrl_amm" interfaces (auto-generated)
   output logic                                               amm_write_0,
   output logic                                               amm_read_0,
   input  logic                                               amm_ready_0,
   input  logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]               amm_readdata_0,
   output logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]             amm_address_0,
   output logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]               amm_writedata_0,
   output logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]              amm_burstcount_0,
   output logic [PORT_CTRL_AMM_BYTEEN_WIDTH-1:0]              amm_byteenable_0,
   output logic                                               amm_beginbursttransfer_0,
   input  logic                                               amm_readdatavalid_0,

   output logic                                               amm_write_1,
   output logic                                               amm_read_1,
   input  logic                                               amm_ready_1,
   input  logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]               amm_readdata_1,
   output logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]             amm_address_1,
   output logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]               amm_writedata_1,
   output logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]              amm_burstcount_1,
   output logic [PORT_CTRL_AMM_BYTEEN_WIDTH-1:0]              amm_byteenable_1,
   output logic                                               amm_beginbursttransfer_1,
   input  logic                                               amm_readdatavalid_1,

   output logic                                               amm_write_2,
   output logic                                               amm_read_2,
   input  logic                                               amm_ready_2,
   input  logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]               amm_readdata_2,
   output logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]             amm_address_2,
   output logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]               amm_writedata_2,
   output logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]              amm_burstcount_2,
   output logic [PORT_CTRL_AMM_BYTEEN_WIDTH-1:0]              amm_byteenable_2,
   output logic                                               amm_beginbursttransfer_2,
   input  logic                                               amm_readdatavalid_2,

   output logic                                               amm_write_3,
   output logic                                               amm_read_3,
   input  logic                                               amm_ready_3,
   input  logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]               amm_readdata_3,
   output logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]             amm_address_3,
   output logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]               amm_writedata_3,
   output logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]              amm_burstcount_3,
   output logic [PORT_CTRL_AMM_BYTEEN_WIDTH-1:0]              amm_byteenable_3,
   output logic                                               amm_beginbursttransfer_3,
   input  logic                                               amm_readdatavalid_3,

   output logic                                               amm_write_4,
   output logic                                               amm_read_4,
   input  logic                                               amm_ready_4,
   input  logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]               amm_readdata_4,
   output logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]             amm_address_4,
   output logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]               amm_writedata_4,
   output logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]              amm_burstcount_4,
   output logic [PORT_CTRL_AMM_BYTEEN_WIDTH-1:0]              amm_byteenable_4,
   output logic                                               amm_beginbursttransfer_4,
   input  logic                                               amm_readdatavalid_4,

   output logic                                               amm_write_5,
   output logic                                               amm_read_5,
   input  logic                                               amm_ready_5,
   input  logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]               amm_readdata_5,
   output logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]             amm_address_5,
   output logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]               amm_writedata_5,
   output logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]              amm_burstcount_5,
   output logic [PORT_CTRL_AMM_BYTEEN_WIDTH-1:0]              amm_byteenable_5,
   output logic                                               amm_beginbursttransfer_5,
   input  logic                                               amm_readdatavalid_5,

   output logic                                               amm_write_6,
   output logic                                               amm_read_6,
   input  logic                                               amm_ready_6,
   input  logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]               amm_readdata_6,
   output logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]             amm_address_6,
   output logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]               amm_writedata_6,
   output logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]              amm_burstcount_6,
   output logic [PORT_CTRL_AMM_BYTEEN_WIDTH-1:0]              amm_byteenable_6,
   output logic                                               amm_beginbursttransfer_6,
   input  logic                                               amm_readdatavalid_6,

   output logic                                               amm_write_7,
   output logic                                               amm_read_7,
   input  logic                                               amm_ready_7,
   input  logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]               amm_readdata_7,
   output logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]             amm_address_7,
   output logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]               amm_writedata_7,
   output logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]              amm_burstcount_7,
   output logic [PORT_CTRL_AMM_BYTEEN_WIDTH-1:0]              amm_byteenable_7,
   output logic                                               amm_beginbursttransfer_7,
   input  logic                                               amm_readdatavalid_7,

   //Ports for "ctrl_user_priority" interface
   output logic                                               ctrl_user_priority_hi_0,
   output logic                                               ctrl_user_priority_hi_1,

   //Ports for "ctrl_auto_precharge" interface
   output logic                                               ctrl_auto_precharge_req_0,
   output logic                                               ctrl_auto_precharge_req_1,

   //Ports for "ctrl_ecc_interrupt" interface
   input  logic                                               ctrl_ecc_user_interrupt_0,
   input  logic                                               ctrl_ecc_user_interrupt_1,

   //Ports for "ctrl_mmr" interface
   input  logic                                               mmr_master_waitrequest_0,
   output logic                                               mmr_master_read_0,
   output logic                                               mmr_master_write_0,
   output logic [PORT_CTRL_MMR_MASTER_ADDRESS_WIDTH-1:0]      mmr_master_address_0,
   input  logic [PORT_CTRL_MMR_MASTER_RDATA_WIDTH-1:0]        mmr_master_readdata_0,
   output logic [PORT_CTRL_MMR_MASTER_WDATA_WIDTH-1:0]        mmr_master_writedata_0,
   output logic [PORT_CTRL_MMR_MASTER_BCOUNT_WIDTH-1:0]       mmr_master_burstcount_0,
   output logic                                               mmr_master_beginbursttransfer_0,
   input  logic                                               mmr_master_readdatavalid_0,

   input  logic                                               mmr_master_waitrequest_1,
   output logic                                               mmr_master_read_1,
   output logic                                               mmr_master_write_1,
   output logic [PORT_CTRL_MMR_MASTER_ADDRESS_WIDTH-1:0]      mmr_master_address_1,
   input  logic [PORT_CTRL_MMR_MASTER_RDATA_WIDTH-1:0]        mmr_master_readdata_1,
   output logic [PORT_CTRL_MMR_MASTER_WDATA_WIDTH-1:0]        mmr_master_writedata_1,
   output logic [PORT_CTRL_MMR_MASTER_BCOUNT_WIDTH-1:0]       mmr_master_burstcount_1,
   output logic                                               mmr_master_beginbursttransfer_1,
   input  logic                                               mmr_master_readdatavalid_1,

   //Ports for "tg_cfg" interface
   output logic                                               tg_cfg_waitrequest_0,
   input  logic                                               tg_cfg_read_0,
   input  logic                                               tg_cfg_write_0,
   input  logic [PORT_TG_CFG_ADDRESS_WIDTH-1:0]               tg_cfg_address_0,
   output logic [PORT_TG_CFG_RDATA_WIDTH-1:0]                 tg_cfg_readdata_0,
   input  logic [PORT_TG_CFG_WDATA_WIDTH-1:0]                 tg_cfg_writedata_0,
   output logic                                               tg_cfg_readdatavalid_0,

   output logic                                               tg_cfg_waitrequest_1,
   input  logic                                               tg_cfg_read_1,
   input  logic                                               tg_cfg_write_1,
   input  logic [PORT_TG_CFG_ADDRESS_WIDTH-1:0]               tg_cfg_address_1,
   output logic [PORT_TG_CFG_RDATA_WIDTH-1:0]                 tg_cfg_readdata_1,
   input  logic [PORT_TG_CFG_WDATA_WIDTH-1:0]                 tg_cfg_writedata_1,
   output logic                                               tg_cfg_readdatavalid_1,

   output logic                                               tg_cfg_waitrequest_2,
   input  logic                                               tg_cfg_read_2,
   input  logic                                               tg_cfg_write_2,
   input  logic [PORT_TG_CFG_ADDRESS_WIDTH-1:0]               tg_cfg_address_2,
   output logic [PORT_TG_CFG_RDATA_WIDTH-1:0]                 tg_cfg_readdata_2,
   input  logic [PORT_TG_CFG_WDATA_WIDTH-1:0]                 tg_cfg_writedata_2,
   output logic                                               tg_cfg_readdatavalid_2,

   output logic                                               tg_cfg_waitrequest_3,
   input  logic                                               tg_cfg_read_3,
   input  logic                                               tg_cfg_write_3,
   input  logic [PORT_TG_CFG_ADDRESS_WIDTH-1:0]               tg_cfg_address_3,
   output logic [PORT_TG_CFG_RDATA_WIDTH-1:0]                 tg_cfg_readdata_3,
   input  logic [PORT_TG_CFG_WDATA_WIDTH-1:0]                 tg_cfg_writedata_3,
   output logic                                               tg_cfg_readdatavalid_3,

   output logic                                               tg_cfg_waitrequest_4,
   input  logic                                               tg_cfg_read_4,
   input  logic                                               tg_cfg_write_4,
   input  logic [PORT_TG_CFG_ADDRESS_WIDTH-1:0]               tg_cfg_address_4,
   output logic [PORT_TG_CFG_RDATA_WIDTH-1:0]                 tg_cfg_readdata_4,
   input  logic [PORT_TG_CFG_WDATA_WIDTH-1:0]                 tg_cfg_writedata_4,
   output logic                                               tg_cfg_readdatavalid_4,

   output logic                                               tg_cfg_waitrequest_5,
   input  logic                                               tg_cfg_read_5,
   input  logic                                               tg_cfg_write_5,
   input  logic [PORT_TG_CFG_ADDRESS_WIDTH-1:0]               tg_cfg_address_5,
   output logic [PORT_TG_CFG_RDATA_WIDTH-1:0]                 tg_cfg_readdata_5,
   input  logic [PORT_TG_CFG_WDATA_WIDTH-1:0]                 tg_cfg_writedata_5,
   output logic                                               tg_cfg_readdatavalid_5,

   output logic                                               tg_cfg_waitrequest_6,
   input  logic                                               tg_cfg_read_6,
   input  logic                                               tg_cfg_write_6,
   input  logic [PORT_TG_CFG_ADDRESS_WIDTH-1:0]               tg_cfg_address_6,
   output logic [PORT_TG_CFG_RDATA_WIDTH-1:0]                 tg_cfg_readdata_6,
   input  logic [PORT_TG_CFG_WDATA_WIDTH-1:0]                 tg_cfg_writedata_6,
   output logic                                               tg_cfg_readdatavalid_6,

   output logic                                               tg_cfg_waitrequest_7,
   input  logic                                               tg_cfg_read_7,
   input  logic                                               tg_cfg_write_7,
   input  logic [PORT_TG_CFG_ADDRESS_WIDTH-1:0]               tg_cfg_address_7,
   output logic [PORT_TG_CFG_RDATA_WIDTH-1:0]                 tg_cfg_readdata_7,
   input  logic [PORT_TG_CFG_WDATA_WIDTH-1:0]                 tg_cfg_writedata_7,
   output logic                                               tg_cfg_readdatavalid_7,

   //Ports for "tg_status" interfaces
   output logic                                               traffic_gen_pass_0,
   output logic                                               traffic_gen_fail_0,
   output logic                                               traffic_gen_timeout_0,

   output logic                                               traffic_gen_pass_1,
   output logic                                               traffic_gen_fail_1,
   output logic                                               traffic_gen_timeout_1,

   output logic                                               traffic_gen_pass_2,
   output logic                                               traffic_gen_fail_2,
   output logic                                               traffic_gen_timeout_2,

   output logic                                               traffic_gen_pass_3,
   output logic                                               traffic_gen_fail_3,
   output logic                                               traffic_gen_timeout_3,

   output logic                                               traffic_gen_pass_4,
   output logic                                               traffic_gen_fail_4,
   output logic                                               traffic_gen_timeout_4,

   output logic                                               traffic_gen_pass_5,
   output logic                                               traffic_gen_fail_5,
   output logic                                               traffic_gen_timeout_5,

   output logic                                               traffic_gen_pass_6,
   output logic                                               traffic_gen_fail_6,
   output logic                                               traffic_gen_timeout_6,

   output logic                                               traffic_gen_pass_7,
   output logic                                               traffic_gen_fail_7,
   output logic                                               traffic_gen_timeout_7
);
   timeunit 1ns;
   timeprecision 1ps;

   localparam MAX_CTRL_PORTS = 8;

   logic [MAX_CTRL_PORTS-1:0]                                   amm_write_all;
   logic [MAX_CTRL_PORTS-1:0]                                   amm_read_all;
   logic [MAX_CTRL_PORTS-1:0]                                   amm_ready_all;
   logic [MAX_CTRL_PORTS-1:0][PORT_CTRL_AMM_RDATA_WIDTH-1:0]    amm_readdata_all;
   logic [MAX_CTRL_PORTS-1:0][PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]  amm_address_all;
   logic [MAX_CTRL_PORTS-1:0][PORT_CTRL_AMM_WDATA_WIDTH-1:0]    amm_writedata_all;
   logic [MAX_CTRL_PORTS-1:0][PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]   amm_burstcount_all;
   logic [MAX_CTRL_PORTS-1:0][PORT_CTRL_AMM_BYTEEN_WIDTH-1:0]   amm_byteenable_all;
   logic [MAX_CTRL_PORTS-1:0]                                   amm_beginbursttransfer_all;
   logic [MAX_CTRL_PORTS-1:0]                                   amm_readdatavalid_all;

   logic [MAX_CTRL_PORTS-1:0][PORT_TG_CFG_ADDRESS_WIDTH-1:0]    tg_cfg_address_all;
   logic [MAX_CTRL_PORTS-1:0][PORT_TG_CFG_WDATA_WIDTH-1:0]      tg_cfg_writedata_all;
   logic [MAX_CTRL_PORTS-1:0][PORT_TG_CFG_RDATA_WIDTH-1:0]      tg_cfg_readdata_all;
   logic [MAX_CTRL_PORTS-1:0]                                   tg_cfg_readdatavalid_all;
   logic [MAX_CTRL_PORTS-1:0]                                   tg_cfg_write_all;
   logic [MAX_CTRL_PORTS-1:0]                                   tg_cfg_read_all;
   logic [MAX_CTRL_PORTS-1:0]                                   tg_cfg_waitrequest_all;

   logic [MAX_CTRL_PORTS-1:0]                                   traffic_gen_pass_all;
   logic [MAX_CTRL_PORTS-1:0]                                   traffic_gen_fail_all;
   logic [MAX_CTRL_PORTS-1:0]                                   traffic_gen_timeout_all;

   logic [MAX_CTRL_PORTS-1:0][PORT_CTRL_AMM_WDATA_WIDTH-1:0]    pnf_per_bit_persist;
   logic                                         issp_reset_n;
   logic                                         issp_worm_en;
   logic                                         reset_n_pre_sync;
   logic                                         reset_n_pre_sync_sec;
   logic                                         reset_n_int;
   logic                                         reset_n_int_sec;
   logic [2:0]                                   worm_en;
   logic [2:0]                                   worm_en_sec;


   //Output signals
   assign {amm_write_7,              amm_write_6,              amm_write_5,              amm_write_4,              amm_write_3,              amm_write_2,              amm_write_1,              amm_write_0             } = amm_write_all;
   assign {amm_read_7,               amm_read_6,               amm_read_5,               amm_read_4,               amm_read_3,               amm_read_2,               amm_read_1,               amm_read_0              } = amm_read_all;
   assign {amm_address_7,            amm_address_6,            amm_address_5,            amm_address_4,            amm_address_3,            amm_address_2,            amm_address_1,            amm_address_0           } = amm_address_all;
   assign {amm_writedata_7,          amm_writedata_6,          amm_writedata_5,          amm_writedata_4,          amm_writedata_3,          amm_writedata_2,          amm_writedata_1,          amm_writedata_0         } = amm_writedata_all;
   assign {amm_burstcount_7,         amm_burstcount_6,         amm_burstcount_5,         amm_burstcount_4,         amm_burstcount_3,         amm_burstcount_2,         amm_burstcount_1,         amm_burstcount_0        } = amm_burstcount_all;
   assign {amm_byteenable_7,         amm_byteenable_6,         amm_byteenable_5,         amm_byteenable_4,         amm_byteenable_3,         amm_byteenable_2,         amm_byteenable_1,         amm_byteenable_0        } = amm_byteenable_all;
   assign {amm_beginbursttransfer_7, amm_beginbursttransfer_6, amm_beginbursttransfer_5, amm_beginbursttransfer_4, amm_beginbursttransfer_3, amm_beginbursttransfer_2, amm_beginbursttransfer_1, amm_beginbursttransfer_0} = amm_beginbursttransfer_all;

   assign tg_cfg_write_all = {tg_cfg_write_7,          tg_cfg_write_6,            tg_cfg_write_5,           tg_cfg_write_4,           tg_cfg_write_3,           tg_cfg_write_2,           tg_cfg_write_1,           tg_cfg_write_0          };
   assign tg_cfg_read_all = {tg_cfg_read_7,           tg_cfg_read_6,             tg_cfg_read_5,            tg_cfg_read_4,            tg_cfg_read_3,            tg_cfg_read_2,            tg_cfg_read_1,            tg_cfg_read_0           };
   assign tg_cfg_address_all = {tg_cfg_address_7,        tg_cfg_address_6,          tg_cfg_address_5,         tg_cfg_address_4,         tg_cfg_address_3,         tg_cfg_address_2,         tg_cfg_address_1,         tg_cfg_address_0        };
   assign tg_cfg_writedata_all = {tg_cfg_writedata_7,      tg_cfg_writedata_6,        tg_cfg_writedata_5,       tg_cfg_writedata_4,       tg_cfg_writedata_3,       tg_cfg_writedata_2,       tg_cfg_writedata_1,       tg_cfg_writedata_0      };
   assign {tg_cfg_readdatavalid_7,  tg_cfg_readdatavalid_6,    tg_cfg_readdatavalid_5,   tg_cfg_readdatavalid_4,   tg_cfg_readdatavalid_3,   tg_cfg_readdatavalid_2,   tg_cfg_readdatavalid_1,   tg_cfg_readdatavalid_0  } = tg_cfg_readdatavalid_all;
   assign {tg_cfg_readdata_7,       tg_cfg_readdata_6,         tg_cfg_readdata_5,        tg_cfg_readdata_4,        tg_cfg_readdata_3,        tg_cfg_readdata_2,        tg_cfg_readdata_1,        tg_cfg_readdata_0       } = tg_cfg_readdata_all;
   assign {tg_cfg_waitrequest_7,    tg_cfg_waitrequest_6,      tg_cfg_waitrequest_5,     tg_cfg_waitrequest_4,     tg_cfg_waitrequest_3,     tg_cfg_waitrequest_2,     tg_cfg_waitrequest_1,     tg_cfg_waitrequest_0    } = tg_cfg_waitrequest_all;

   assign {traffic_gen_pass_7,       traffic_gen_pass_6,       traffic_gen_pass_5,       traffic_gen_pass_4,       traffic_gen_pass_3,       traffic_gen_pass_2,       traffic_gen_pass_1,       traffic_gen_pass_0      } = traffic_gen_pass_all;
   assign {traffic_gen_fail_7,       traffic_gen_fail_6,       traffic_gen_fail_5,       traffic_gen_fail_4,       traffic_gen_fail_3,       traffic_gen_fail_2,       traffic_gen_fail_1,       traffic_gen_fail_0      } = traffic_gen_fail_all;
   assign {traffic_gen_timeout_7,    traffic_gen_timeout_6,    traffic_gen_timeout_5,    traffic_gen_timeout_4,    traffic_gen_timeout_3,    traffic_gen_timeout_2,    traffic_gen_timeout_1,    traffic_gen_timeout_0   } = traffic_gen_timeout_all;

   assign amm_ready_all         = {amm_ready_7,         amm_ready_6,         amm_ready_5,         amm_ready_4,         amm_ready_3,         amm_ready_2,         amm_ready_1 /* & ~mmr_drive_amm_ready_sec */, amm_ready_0 /* & ~mmr_drive_amm_ready */       };
   assign amm_readdata_all      = {amm_readdata_7,      amm_readdata_6,      amm_readdata_5,      amm_readdata_4,      amm_readdata_3,      amm_readdata_2,      amm_readdata_1,       amm_readdata_0     };
   assign amm_readdatavalid_all = {amm_readdatavalid_7, amm_readdatavalid_6, amm_readdatavalid_5, amm_readdatavalid_4, amm_readdatavalid_3, amm_readdatavalid_2, amm_readdatavalid_1,  amm_readdatavalid_0};


   localparam NUMBER_OF_DATA_GENERATORS = PORT_CTRL_AMM_WDATA_WIDTH / AVL_TO_DQ_WIDTH_RATIO;
   localparam NUMBER_OF_BYTE_EN_GENERATORS = PORT_CTRL_AMM_BYTEEN_WIDTH / AVL_TO_DQ_WIDTH_RATIO;

   localparam AMM_CFG_ADDR_WIDTH       = 10;
   localparam RW_RPT_COUNT_WIDTH       = 16;
   localparam RW_OPERATION_COUNT_WIDTH = 12;
   localparam RW_LOOP_COUNT_WIDTH      = 12;
   localparam TOTAL_OP_COUNT_WIDTH     = RW_LOOP_COUNT_WIDTH + RW_OPERATION_COUNT_WIDTH + RW_RPT_COUNT_WIDTH;

   wire [MAX_CTRL_PORTS-1:0][PORT_TG_CFG_ADDRESS_WIDTH-1:0]  amm_cfg_address;
   wire [MAX_CTRL_PORTS-1:0][PORT_TG_CFG_WDATA_WIDTH-1:0] amm_cfg_writedata;
   wire [MAX_CTRL_PORTS-1:0][PORT_TG_CFG_RDATA_WIDTH-1:0] amm_cfg_readdata;
   wire [MAX_CTRL_PORTS-1:0]amm_cfg_readdatavalid;
   wire [MAX_CTRL_PORTS-1:0]amm_cfg_write;
   wire [MAX_CTRL_PORTS-1:0]amm_cfg_read;
   wire [MAX_CTRL_PORTS-1:0]amm_cfg_wait_req;

   wire [MAX_CTRL_PORTS-1:0][AMM_WORD_ADDRESS_WIDTH-1:0]       ast_exp_data_readaddr;
   wire [MAX_CTRL_PORTS-1:0][PORT_CTRL_AMM_WDATA_WIDTH-1:0]    ast_exp_data_writedata;
   wire [MAX_CTRL_PORTS-1:0][PORT_CTRL_AMM_BYTEEN_WIDTH-1:0]   ast_exp_data_byteenable;

   wire [MAX_CTRL_PORTS-1:0] ast_act_data_readdatavalid;
   wire [MAX_CTRL_PORTS-1:0][PORT_CTRL_AMM_WDATA_WIDTH-1:0] ast_act_data_readdata;

   //status signals
   wire [MAX_CTRL_PORTS-1:0]                                clear_first_fail;
   wire [MAX_CTRL_PORTS-1:0]                                byteenable_stage;

   wire [MAX_CTRL_PORTS-1:0][PORT_CTRL_AMM_RDATA_WIDTH-1:0] before_ff_expected_data;
   wire [MAX_CTRL_PORTS-1:0][PORT_CTRL_AMM_RDATA_WIDTH-1:0] before_ff_read_data;
   wire [MAX_CTRL_PORTS-1:0]                                before_ff_rdata_valid;
   wire [MAX_CTRL_PORTS-1:0][PORT_CTRL_AMM_RDATA_WIDTH-1:0] after_ff_expected_data;
   wire [MAX_CTRL_PORTS-1:0][PORT_CTRL_AMM_RDATA_WIDTH-1:0] after_ff_read_data;
   wire [MAX_CTRL_PORTS-1:0]                                after_ff_rdata_valid;

   wire [MAX_CTRL_PORTS-1:0][TOTAL_OP_COUNT_WIDTH-1:0]      failure_count;
   wire [MAX_CTRL_PORTS-1:0][PORT_CTRL_AMM_RDATA_WIDTH-1:0] first_fail_expected_data;
   wire [MAX_CTRL_PORTS-1:0][PORT_CTRL_AMM_RDATA_WIDTH-1:0] first_fail_read_data;
   wire [MAX_CTRL_PORTS-1:0][PORT_CTRL_AMM_RDATA_WIDTH-1:0] first_fail_pnf;
   wire [MAX_CTRL_PORTS-1:0]                                first_failure_occured;

   wire [MAX_CTRL_PORTS-1:0][PORT_CTRL_AMM_RDATA_WIDTH-1:0] last_read_data;
   wire [MAX_CTRL_PORTS-1:0][TOTAL_OP_COUNT_WIDTH-1:0]      total_read_count;

   //asserted when driver control block writes start to r/w gen
   wire [MAX_CTRL_PORTS-1:0]tg_restart;

   wire [MAX_CTRL_PORTS-1:0] all_tests_issued;
   wire [MAX_CTRL_PORTS-1:0] reads_in_prog;
   wire [MAX_CTRL_PORTS-1:0] restart_default_traffic;
   wire [MAX_CTRL_PORTS-1:0] test_stage_fail;
   wire [MAX_CTRL_PORTS-1:0][AMM_WORD_ADDRESS_WIDTH-1:0] first_fail_addr;
   wire [MAX_CTRL_PORTS-1:0] targetted_reads_stage;
   wire [MAX_CTRL_PORTS-1:0] target_first_failing_addr;
   genvar i;

   generate
   for (i = 0; i < MAX_CTRL_PORTS; ++i)
   begin: gen_avl_mm_driver
      if (i < NUM_OF_CTRL_PORTS && !(i > 0 && SEPARATE_READ_WRITE_IFS)) begin
         if (USE_SIMPLE_TG) begin
            if (SEPARATE_READ_WRITE_IFS) begin
               altera_emif_avl_tg_driver_simple # (
                  .DEVICE_FAMILY                          (MEGAFUNC_DEVICE_FAMILY),
                  .PROTOCOL_ENUM                          (PROTOCOL_ENUM),
                  .TG_AVL_ADDR_WIDTH                      (PORT_CTRL_AMM_ADDRESS_WIDTH),
                  .TG_AVL_WORD_ADDR_WIDTH                 (AMM_WORD_ADDRESS_WIDTH),
                  .TG_AVL_SIZE_WIDTH                      (PORT_CTRL_AMM_BCOUNT_WIDTH),
                  .TG_AVL_DATA_WIDTH                      (PORT_CTRL_AMM_WDATA_WIDTH),
                  .TG_AVL_BE_WIDTH                        (PORT_CTRL_AMM_BYTEEN_WIDTH),
                  .TG_SEPARATE_READ_WRITE_IFS             (SEPARATE_READ_WRITE_IFS),
                  .AMM_WORD_ADDRESS_DIVISIBLE_BY          (AMM_WORD_ADDRESS_DIVISIBLE_BY),
                  .AMM_BURST_COUNT_DIVISIBLE_BY           (AMM_WORD_ADDRESS_DIVISIBLE_BY)
               ) inst (
                  .clk                                    (emif_usr_clk),
                  .reset_n                                (reset_n_int),
                  .avl_ready                              (amm_ready_all[0]),
                  .avl_write_req                          (amm_write_all[1]),
                  .avl_read_req                           (amm_read_all[0]),
                  .avl_addr                               (amm_address_all[0]),
                  .avl_size                               (amm_burstcount_all[0]),
                  .avl_be                                 (amm_byteenable_all[1]),
                  .avl_wdata                              (amm_writedata_all[1]),
                  .avl_rdata_valid                        (amm_readdatavalid_all[0]),
                  .avl_rdata                              (amm_readdata_all[0]),
                  .avl_ready_w                            (amm_ready_all[1]),
                  .avl_addr_w                             (amm_address_all[1]),
                  .avl_size_w                             (amm_burstcount_all[1]),

                  .pass                                   (traffic_gen_pass_all[i]),
                  .fail                                   (traffic_gen_fail_all[i]),
                  .timeout                                (traffic_gen_timeout_all[i]),
                  .pnf_per_bit                            (),
                  .pnf_per_bit_persist                    (pnf_per_bit_persist[i])
               );

               assign amm_writedata_all[0] = '0;
               assign amm_write_all[0]     = '0;
               assign amm_byteenable_all[0]= '0;

            end else begin
               altera_emif_avl_tg_driver_simple # (
                  .DEVICE_FAMILY                          (MEGAFUNC_DEVICE_FAMILY),
                  .PROTOCOL_ENUM                          (PROTOCOL_ENUM),
                  .TG_AVL_ADDR_WIDTH                      (PORT_CTRL_AMM_ADDRESS_WIDTH),
                  .TG_AVL_WORD_ADDR_WIDTH                 (AMM_WORD_ADDRESS_WIDTH),
                  .TG_AVL_SIZE_WIDTH                      (PORT_CTRL_AMM_BCOUNT_WIDTH),
                  .TG_AVL_DATA_WIDTH                      (PORT_CTRL_AMM_WDATA_WIDTH),
                  .TG_AVL_BE_WIDTH                        (PORT_CTRL_AMM_BYTEEN_WIDTH),
                  .TG_SEPARATE_READ_WRITE_IFS             (SEPARATE_READ_WRITE_IFS),
                  .AMM_WORD_ADDRESS_DIVISIBLE_BY          (AMM_WORD_ADDRESS_DIVISIBLE_BY),
                  .AMM_BURST_COUNT_DIVISIBLE_BY           (AMM_WORD_ADDRESS_DIVISIBLE_BY)
               ) tg_simple_inst (
                  .clk                                    (emif_usr_clk),
                  .reset_n                                (reset_n_int),
                  .avl_ready                              (amm_ready_all[i]),
                  .avl_write_req                          (amm_write_all[i]),
                  .avl_read_req                           (amm_read_all[i]),
                  .avl_addr                               (amm_address_all[i]),
                  .avl_size                               (amm_burstcount_all[i]),
                  .avl_be                                 (amm_byteenable_all[i]),
                  .avl_wdata                              (amm_writedata_all[i]),
                  .avl_rdata_valid                        (amm_readdatavalid_all[i]),
                  .avl_rdata                              (amm_readdata_all[i]),
                  .avl_ready_w                            (1'b0), // unused
                  .avl_addr_w                             (),     // unused
                  .avl_size_w                             (),     // unused

                  .pass                                   (traffic_gen_pass_all[i]),
                  .fail                                   (traffic_gen_fail_all[i]),
                  .timeout                                (traffic_gen_timeout_all[i]),
                  .pnf_per_bit                            (),
                  .pnf_per_bit_persist                    (pnf_per_bit_persist[i])
               );
            end
         end else begin
            altera_emif_avl_tg_2_bringup_dcb #(
               .NUMBER_OF_DATA_GENERATORS    (NUMBER_OF_DATA_GENERATORS),
               .NUMBER_OF_BYTE_EN_GENERATORS (NUMBER_OF_BYTE_EN_GENERATORS),
               .DATA_PATTERN_LENGTH          (DIAG_TG_DATA_PATTERN_LENGTH),
               .BYTE_EN_PATTERN_LENGTH       (DIAG_TG_BE_PATTERN_LENGTH),
               .MEM_ADDR_WIDTH               (PORT_CTRL_AMM_ADDRESS_WIDTH),
               .BURSTCOUNT_WIDTH             (PORT_CTRL_AMM_BCOUNT_WIDTH),
               .TG_TEST_DURATION             (TEST_DURATION),
               .PORT_TG_CFG_ADDRESS_WIDTH    (PORT_TG_CFG_ADDRESS_WIDTH),
               .PORT_TG_CFG_RDATA_WIDTH      (PORT_TG_CFG_RDATA_WIDTH),
               .PORT_TG_CFG_WDATA_WIDTH      (PORT_TG_CFG_WDATA_WIDTH),
               .WRITE_GROUP_WIDTH            (MEM_TTL_DATA_WIDTH / MEM_TTL_NUM_OF_WRITE_GROUPS),
               .BYPASS_DEFAULT_PATTERN       (BYPASS_DEFAULT_PATTERN),
               .BYPASS_USER_STAGE            (BYPASS_USER_STAGE),
               .BYPASS_REPEAT_STAGE          (BYPASS_REPEAT_STAGE),
               .BYPASS_STRESS_STAGE          (BYPASS_STRESS_STAGE),
               .AMM_WORD_ADDRESS_WIDTH       (AMM_WORD_ADDRESS_WIDTH),
               .AMM_BURST_COUNT_DIVISIBLE_BY (AMM_BURST_COUNT_DIVISIBLE_BY)
            ) bu_dcb_inst (
               .clk                             ((PHY_PING_PONG_EN && (i == 1)) ? emif_usr_clk_sec : emif_usr_clk),
               .rst                             ((PHY_PING_PONG_EN && (i == 1)) ? ~reset_n_int_sec : ~reset_n_int),

               //trigger the driver control block when calibration has passed and ready is high
               .amm_ctrl_ready                  (amm_ready_all[i]),

               .amm_cfg_in_waitrequest       (tg_cfg_waitrequest_all[i]),
               .amm_cfg_in_address           (tg_cfg_address_all[i]),
               .amm_cfg_in_writedata         (tg_cfg_writedata_all[i]),
               .amm_cfg_in_write             (tg_cfg_write_all[i]),
               .amm_cfg_in_read              (tg_cfg_read_all[i]),
               .amm_cfg_in_readdata          (tg_cfg_readdata_all[i]),
               .amm_cfg_in_readdatavalid     (tg_cfg_readdatavalid_all[i]),

               //configuration interface to/from traffic generator
               .amm_cfg_out_waitrequest      (amm_cfg_wait_req[i]),
               .amm_cfg_out_address          (amm_cfg_address[i]),
               .amm_cfg_out_writedata        (amm_cfg_writedata[i]),
               .amm_cfg_out_write            (amm_cfg_write[i]),
               .amm_cfg_out_read             (amm_cfg_read[i]),
               .amm_cfg_out_readdata         (amm_cfg_readdata[i]),
               .amm_cfg_out_readdatavalid    (amm_cfg_readdatavalid[i]),

               .restart_default_traffic          (restart_default_traffic[i]),

               //status checker related signals for special tests
               .all_tests_issued             (all_tests_issued[i]),
               .stage_failure                (test_stage_fail[i]),
               .first_fail_addr              (first_fail_addr[i]),
               .failure_occured              (first_failure_occured[i]),

               .traffic_gen_fail             (traffic_gen_fail_all[i]),
               .target_first_failing_addr    (target_first_failing_addr[i]),
               .target_stage_enable          (targetted_reads_stage[i])
            );

            // For protocols with separate read and write interfaces (e.g. QDRII)
            if (SEPARATE_READ_WRITE_IFS) begin
               altera_emif_avl_tg_2_traffic_gen #(
                  .NUMBER_OF_DATA_GENERATORS      (NUMBER_OF_DATA_GENERATORS),
                  .NUMBER_OF_BYTE_EN_GENERATORS   (NUMBER_OF_BYTE_EN_GENERATORS),
                  .AMM_CFG_ADDR_WIDTH             (PORT_TG_CFG_ADDRESS_WIDTH),
                  .AMM_CFG_DATA_WIDTH             (PORT_TG_CFG_WDATA_WIDTH),
                  .DATA_RATE_WIDTH_RATIO          (AVL_TO_DQ_WIDTH_RATIO),
                  .DATA_PATTERN_LENGTH            (DIAG_TG_DATA_PATTERN_LENGTH),
                  .BYTE_EN_PATTERN_LENGTH         (DIAG_TG_BE_PATTERN_LENGTH),
                  .OP_COUNT_WIDTH                 (TOTAL_OP_COUNT_WIDTH),
                  .RW_RPT_COUNT_WIDTH             (RW_RPT_COUNT_WIDTH),
                  .RW_OPERATION_COUNT_WIDTH       (RW_OPERATION_COUNT_WIDTH),
                  .RW_LOOP_COUNT_WIDTH            (RW_LOOP_COUNT_WIDTH),
                  .MEM_ADDR_WIDTH                 (PORT_CTRL_AMM_ADDRESS_WIDTH), //memory address width
                  .ROW_ADDR_WIDTH                 (MEM_ROW_ADDR_WIDTH),
                  .ROW_ADDR_LSB                   (ROW_ADDR_LSB),
                  .RANK_ADDR_WIDTH                (MEM_RANK_WIDTH),
                  .RANK_ADDR_LSB                  (RANK_LSB),
                  .BANK_ADDR_WIDTH                (MEM_BANK_ADDR_WIDTH),
                  .BANK_ADDR_LSB                  (BANK_ADDR_LSB),
                  .BANK_GROUP_LSB                 (BANK_GROUP_LSB),
                  .BANK_GROUP_WIDTH               (MEM_BANK_GROUP_WIDTH),
                  .AMM_BURSTCOUNT_WIDTH           (PORT_CTRL_AMM_BCOUNT_WIDTH),
                  .MEM_DATA_WIDTH                 (PORT_CTRL_AMM_WDATA_WIDTH),
                  .MEM_RDATA_WIDTH                (PORT_CTRL_AMM_RDATA_WIDTH),
                  .MEM_BE_WIDTH                   (PORT_CTRL_AMM_BYTEEN_WIDTH),
                  .AMM_WORD_ADDRESS_WIDTH         (AMM_WORD_ADDRESS_WIDTH),
                  .USE_AVL_BYTEEN                 (USE_AVL_BYTEEN),
                  .AMM_WORD_ADDRESS_DIVISIBLE_BY  (AMM_WORD_ADDRESS_DIVISIBLE_BY),
                  .AMM_BURST_COUNT_DIVISIBLE_BY   (AMM_BURST_COUNT_DIVISIBLE_BY),
                  .SEPARATE_READ_WRITE_IFS        (SEPARATE_READ_WRITE_IFS)
               ) traffic_gen_srw_inst (
                  .clk                          ((PHY_PING_PONG_EN && (i == 1)) ? emif_usr_clk_sec : emif_usr_clk),
                  .rst                          ((PHY_PING_PONG_EN && (i == 1)) ? ~reset_n_int_sec : ~reset_n_int),
                  .tg_restart                   (tg_restart[i]),

                  .targetted_reads_stage        (targetted_reads_stage[i]),

                  //to avalon memory controller
                  .amm_ctrl_write               (amm_write_all[1]),
                  .amm_ctrl_read                (amm_read_all[0]),
                  .amm_ctrl_address             (amm_address_all[0]),
                  .amm_ctrl_writedata           (amm_writedata_all[1]),
                  .amm_ctrl_byteenable          (amm_byteenable_all[1]),
                  .amm_ctrl_ready               (amm_ready_all[0]),
                  .amm_ctrl_burstcount          (amm_burstcount_all[0]),
                  .amm_ctrl_readdatavalid       (amm_readdatavalid_all[0]),
                  .amm_ctrl_readdata            (amm_readdata_all[0]),

                  .amm_ctrl_address_w           (amm_address_all[1]),
                  .amm_ctrl_ready_w             (amm_ready_all[1]),
                  .amm_ctrl_burstcount_w        (amm_burstcount_all[1]),

                  //Expected data for comparison in status checker
                  .ast_exp_data_byteenable      (ast_exp_data_byteenable[i]),
                  .ast_exp_data_writedata       (ast_exp_data_writedata[i]),
                  .ast_exp_data_readaddr        (ast_exp_data_readaddr[i]),

                  //Actual data for comparison in status checker
                  .ast_act_data_readdatavalid   (ast_act_data_readdatavalid[i]),
                  .ast_act_data_readdata        (ast_act_data_readdata[i]),

                  //configuration interface to/from driver config block
                  .amm_cfg_address              (amm_cfg_address[i]),
                  .amm_cfg_writedata            (amm_cfg_writedata[i]),
                  .amm_cfg_readdata             (amm_cfg_readdata[i]),
                  .amm_cfg_readdatavalid        (amm_cfg_readdatavalid[i]),
                  .amm_cfg_write                (amm_cfg_write[i]),
                  .amm_cfg_read                 (amm_cfg_read[i]),
                  .amm_cfg_waitrequest          (amm_cfg_wait_req[i]),

                  //status report
                  .clear_first_fail             (clear_first_fail[i]),
                  .byteenable_stage             (byteenable_stage[i]),
                  .pnf_per_bit_persist          (pnf_per_bit_persist[i]),
                  .fail                         (test_stage_fail[i]),
                  .pass                         (traffic_gen_pass_all[i]),
                  .first_fail_addr              ({{(64-AMM_WORD_ADDRESS_WIDTH){1'b0}}, first_fail_addr[i]}),
                  .failure_count                ({{(64-TOTAL_OP_COUNT_WIDTH){1'b0}}, failure_count[i]}),
                  .total_read_count             ({{(64-TOTAL_OP_COUNT_WIDTH){1'b0}}, total_read_count[i]}),
                  .first_fail_expected_data     (first_fail_expected_data[i]),
                  .first_fail_read_data         (first_fail_read_data[i]),
                  .first_failure_occured        (first_failure_occured[i]),

                  //extra signals used by the status checker
                  .reads_in_prog                (reads_in_prog[i]),
                  .target_first_failing_addr    (target_first_failing_addr[i]),

                  .restart_default_traffic    (restart_default_traffic[i]),
                  .worm_en                    ((PHY_PING_PONG_EN && (i == 1)) ? worm_en_sec[2] : worm_en[2])
               );

               assign amm_writedata_all[0] = '0;
               assign amm_write_all[0]     = '0;
               assign amm_byteenable_all[0]= '0;

            end else begin
               altera_emif_avl_tg_2_traffic_gen #(
                  .NUMBER_OF_DATA_GENERATORS       (NUMBER_OF_DATA_GENERATORS),
                  .NUMBER_OF_BYTE_EN_GENERATORS    (NUMBER_OF_BYTE_EN_GENERATORS),
                  .AMM_CFG_ADDR_WIDTH              (PORT_TG_CFG_ADDRESS_WIDTH),
                  .AMM_CFG_DATA_WIDTH              (PORT_TG_CFG_WDATA_WIDTH),
                  .DATA_RATE_WIDTH_RATIO           (AVL_TO_DQ_WIDTH_RATIO),
                  .DATA_PATTERN_LENGTH             (DIAG_TG_DATA_PATTERN_LENGTH),
                  .BYTE_EN_PATTERN_LENGTH          (DIAG_TG_BE_PATTERN_LENGTH),
                  .OP_COUNT_WIDTH                  (TOTAL_OP_COUNT_WIDTH),
                  .RW_RPT_COUNT_WIDTH              (RW_RPT_COUNT_WIDTH),
                  .RW_OPERATION_COUNT_WIDTH        (RW_OPERATION_COUNT_WIDTH),
                  .RW_LOOP_COUNT_WIDTH             (RW_LOOP_COUNT_WIDTH),
                  .MEM_ADDR_WIDTH                  (PORT_CTRL_AMM_ADDRESS_WIDTH), //memory address width
                  .ROW_ADDR_WIDTH                  (MEM_ROW_ADDR_WIDTH),
                  .ROW_ADDR_LSB                    (ROW_ADDR_LSB),
                  .RANK_ADDR_WIDTH                 (MEM_RANK_WIDTH),
                  .RANK_ADDR_LSB                   (RANK_LSB),
                  .BANK_ADDR_WIDTH                 (MEM_BANK_ADDR_WIDTH),
                  .BANK_ADDR_LSB                   (BANK_ADDR_LSB),
                  .BANK_GROUP_LSB                  (BANK_GROUP_LSB),
                  .BANK_GROUP_WIDTH                (MEM_BANK_GROUP_WIDTH),
                  .AMM_BURSTCOUNT_WIDTH            (PORT_CTRL_AMM_BCOUNT_WIDTH),
                  .MEM_DATA_WIDTH                  (PORT_CTRL_AMM_WDATA_WIDTH),
                  .MEM_RDATA_WIDTH                 (PORT_CTRL_AMM_RDATA_WIDTH),
                  .MEM_BE_WIDTH                    (PORT_CTRL_AMM_BYTEEN_WIDTH),
                  .AMM_WORD_ADDRESS_WIDTH          (AMM_WORD_ADDRESS_WIDTH),
                  .USE_AVL_BYTEEN                  (USE_AVL_BYTEEN),
                  .AMM_WORD_ADDRESS_DIVISIBLE_BY   (AMM_WORD_ADDRESS_DIVISIBLE_BY),
                  .AMM_BURST_COUNT_DIVISIBLE_BY    (AMM_BURST_COUNT_DIVISIBLE_BY),
                  .TG_ENABLE_UNIX_ID               ((PROTOCOL_ENUM == "PROTOCOL_QDR4") ? 1 : 0),
                  .TG_USE_UNIX_ID                  (i)
               ) traffic_gen_inst (
                  .clk                          ((PHY_PING_PONG_EN && (i == 1)) ? emif_usr_clk_sec : emif_usr_clk),
                  .rst                          ((PHY_PING_PONG_EN && (i == 1)) ? ~reset_n_int_sec : ~reset_n_int),
                  .tg_restart                   (tg_restart[i]),

                  .targetted_reads_stage        (targetted_reads_stage[i]),

                  //to avalon memory controller
                  .amm_ctrl_write               (amm_write_all[i]),
                  .amm_ctrl_read                (amm_read_all[i]),
                  .amm_ctrl_address             (amm_address_all[i]),
                  .amm_ctrl_writedata           (amm_writedata_all[i]),
                  .amm_ctrl_byteenable          (amm_byteenable_all[i]),
                  .amm_ctrl_ready               (amm_ready_all[i]),
                  .amm_ctrl_burstcount          (amm_burstcount_all[i]),
                  .amm_ctrl_readdatavalid       (amm_readdatavalid_all[i]),
                  .amm_ctrl_readdata            (amm_readdata_all[i]),

                  .amm_ctrl_address_w           (),
                  .amm_ctrl_ready_w             (),
                  .amm_ctrl_burstcount_w        (),

                  //Expected data for comparison in status checker
                  .ast_exp_data_byteenable      (ast_exp_data_byteenable[i]),
                  .ast_exp_data_writedata       (ast_exp_data_writedata[i]),
                  .ast_exp_data_readaddr        (ast_exp_data_readaddr[i]),

                  //Actual data for comparison in status checker
                  .ast_act_data_readdatavalid   (ast_act_data_readdatavalid[i]),
                  .ast_act_data_readdata        (ast_act_data_readdata[i]),

                  //configuration interface to/from driver config block
                  .amm_cfg_address              (amm_cfg_address[i]),
                  .amm_cfg_writedata            (amm_cfg_writedata[i]),
                  .amm_cfg_readdata             (amm_cfg_readdata[i]),
                  .amm_cfg_readdatavalid        (amm_cfg_readdatavalid[i]),
                  .amm_cfg_write                (amm_cfg_write[i]),
                  .amm_cfg_read                 (amm_cfg_read[i]),
                  .amm_cfg_waitrequest          (amm_cfg_wait_req[i]),

                  //status report
                  .clear_first_fail             (clear_first_fail[i]),
                  .byteenable_stage             (byteenable_stage[i]),
                  .pnf_per_bit_persist          (pnf_per_bit_persist[i]),
                  .fail                         (test_stage_fail[i]),
                  .pass                         (traffic_gen_pass_all[i]),
                  .first_fail_addr              ({{(64-AMM_WORD_ADDRESS_WIDTH){1'b0}}, first_fail_addr[i]}),
                  .failure_count                ({{(64-TOTAL_OP_COUNT_WIDTH){1'b0}}, failure_count[i]}),
                  .total_read_count             ({{(64-TOTAL_OP_COUNT_WIDTH){1'b0}}, total_read_count[i]}),
                  .first_fail_expected_data     (first_fail_expected_data[i]),
                  .first_fail_read_data         (first_fail_read_data[i]),
                  .first_failure_occured        (first_failure_occured[i]),

                  //extra signals used by the status checker
                  .reads_in_prog                (reads_in_prog[i]),
                  .target_first_failing_addr    (target_first_failing_addr[i]),

                  .restart_default_traffic    (restart_default_traffic[i]),
                  .worm_en                    ((PHY_PING_PONG_EN && (i == 1)) ? worm_en_sec[2] : worm_en[2])
               );
            end

            altera_emif_avl_tg_2_status_checker # (
               .DATA_WIDTH                 (PORT_CTRL_AMM_RDATA_WIDTH),
               .BE_WIDTH                   (PORT_CTRL_AMM_BYTEEN_WIDTH),
               .ADDR_WIDTH                 (AMM_WORD_ADDRESS_WIDTH),
               .OP_COUNT_WIDTH             (TOTAL_OP_COUNT_WIDTH),
               .TEST_DURATION              (TEST_DURATION)
            ) status_checker_inst (
               .clk                        ((PHY_PING_PONG_EN && (i == 1)) ? emif_usr_clk_sec : emif_usr_clk),
               .rst                        ((PHY_PING_PONG_EN && (i == 1)) ? ~reset_n_int_sec : ~reset_n_int),
               .tg_restart                 (tg_restart[i]),
               .enable                     (1'b1),

               //Expected data for comparison in status checker
               .ast_exp_data_writedata     (ast_exp_data_writedata[i]),
               .ast_exp_data_byteenable    (ast_exp_data_byteenable[i]),
               .ast_exp_data_readaddr      (ast_exp_data_readaddr[i]),

               //Actual data for comparison
               .ast_act_data_readdatavalid (ast_act_data_readdatavalid[i]),
               .ast_act_data_readdata      (ast_act_data_readdata[i]),

               //status report
               .clear_first_fail          (clear_first_fail[i]),
               .pnf_per_bit_persist       (pnf_per_bit_persist[i]),
               .fail                      (test_stage_fail[i]),
               .pass                      (traffic_gen_pass_all[i]),
               .first_fail_addr           (first_fail_addr[i]),
               .failure_count             (failure_count[i]),
               .first_fail_expected_data  (first_fail_expected_data[i]),
               .first_fail_read_data      (first_fail_read_data[i]),
               .first_fail_pnf            (first_fail_pnf[i]),
               .first_failure_occured     (first_failure_occured[i]),
               .before_ff_expected_data   (before_ff_expected_data[i]),
               .before_ff_read_data       (before_ff_read_data[i]),
               .after_ff_expected_data    (after_ff_expected_data[i]),
               .after_ff_read_data        (after_ff_read_data[i]),

               .before_ff_rdata_valid     (before_ff_rdata_valid[i]),
               .after_ff_rdata_valid      (after_ff_rdata_valid[i]),

               .last_read_data            (last_read_data[i]),
               .total_read_count          (total_read_count[i]),

               //driver control block info
               .all_tests_issued          (all_tests_issued[i]),
               .byteenable_stage          (byteenable_stage[i]),

               .reads_in_prog             (reads_in_prog[i]),
               .timeout                   (traffic_gen_timeout_all[i])
            );
         end

      end else begin
         // unused avmm
         assign amm_read_all[i]                 = '0;
         if (!(SEPARATE_READ_WRITE_IFS && i == 1)) begin
            assign amm_write_all[i]                = '0;
            assign amm_address_all[i]              = '0;
            assign amm_writedata_all[i]            = '0;
            assign amm_burstcount_all[i]           = '0;
            assign amm_byteenable_all[i]           = '0;
         end

         assign tg_cfg_waitrequest_all[i]       = '0;
         assign tg_cfg_readdata_all[i]          = '0;
         assign tg_cfg_readdatavalid_all[i]     = '0;

         // unused status signals
         assign traffic_gen_fail_all[i]         = '0;
         assign traffic_gen_pass_all[i]         = '1;
         assign traffic_gen_timeout_all[i]      = '0;
         assign pnf_per_bit_persist[i]          = '0;
      end
   end
   endgenerate

   `ifdef ALTERA_EMIF_ENABLE_ISSP
      // acds/quartus/libraries/megafunctions/altsource_probe_body.vhd
      localparam MAX_PROBE_WIDTH = 511;
      localparam TTL_PNF_WIDTH = NUM_OF_CTRL_PORTS * PORT_CTRL_AMM_WDATA_WIDTH;

      // This source is out of reset by default (for users who don't want to use this)
      altsource_probe #(
         .sld_auto_instance_index ("YES"),
         .sld_instance_index      (0),
         .instance_id             ("TGR"),
         .probe_width             (0),
         .source_width            (1),
         .source_initial_value    ("1"),
         .enable_metastability    ("NO")
      ) tg_reset_n_issp (
         .source  (issp_reset_n)
      );

      altsource_probe #(
         .sld_auto_instance_index ("YES"),
         .sld_instance_index      (0),
         .instance_id             ("WORM"),
         .probe_width             (0),
         .source_width            (1),
         .source_initial_value    ("0"),
         .enable_metastability    ("NO")
      ) tg_worm_en_issp (
         .source (issp_worm_en)
      );

      altsource_probe #(
         .sld_auto_instance_index ("YES"),
         .sld_instance_index      (0),
         .instance_id             ("TGP"),
         .probe_width             (1),
         .source_width            (0),
         .source_initial_value    ("0"),
         .enable_metastability    ("NO")
      ) tg_pass (
         .probe  (&(traffic_gen_pass_all[NUM_OF_CTRL_PORTS-1:0]))
      );

      altsource_probe #(
         .sld_auto_instance_index ("YES"),
         .sld_instance_index      (0),
         .instance_id             ("TGF"),
         .probe_width             (1),
         .source_width            (0),
         .source_initial_value    ("0"),
         .enable_metastability    ("NO")
      ) tg_fail (
         .probe  (|(traffic_gen_fail_all[NUM_OF_CTRL_PORTS-1:0]))
      );

      altsource_probe #(
         .sld_auto_instance_index ("YES"),
         .sld_instance_index      (0),
         .instance_id             ("TGT"),
         .probe_width             (1),
         .source_width            (0),
         .source_initial_value    ("0"),
         .enable_metastability    ("NO")
      ) tg_timeout (
         .probe  (|(traffic_gen_timeout_all[NUM_OF_CTRL_PORTS-1:0]))
      );

      altsource_probe #(
         .sld_auto_instance_index ("YES"),
         .sld_instance_index      (0),
         .instance_id             ("RCNT"),
         .probe_width             (TOTAL_OP_COUNT_WIDTH),
         .source_width            (0),
         .source_initial_value    ("0"),
         .enable_metastability    ("NO")
      ) issp_pnf_count (
         .probe  (total_read_count[0][TOTAL_OP_COUNT_WIDTH-1:0])
      );

      altsource_probe #(
         .sld_auto_instance_index ("YES"),
         .sld_instance_index      (0),
         .instance_id             ("FCNT"),
         .probe_width             (TOTAL_OP_COUNT_WIDTH),
         .source_width            (0),
         .source_initial_value    ("0"),
         .enable_metastability    ("NO")
      ) issp_ttl_fail_pnf (
         .probe  (failure_count[0][TOTAL_OP_COUNT_WIDTH-1:0])
      );

      altsource_probe #(
         .sld_auto_instance_index ("YES"),
         .sld_instance_index      (0),
         .instance_id             ("FADR"),
         .probe_width             (AMM_WORD_ADDRESS_WIDTH),
         .source_width            (0),
         .source_initial_value    ("0"),
         .enable_metastability    ("NO")
      ) issp_first_fail_exact_addr (
         .probe  (first_fail_addr[0])
      );

      altsource_probe #(
         .sld_auto_instance_index ("YES"),
         .sld_instance_index      (0),
         .instance_id             ("RAVP"),
         .probe_width             (NUM_OF_CTRL_PORTS),
         .source_width            (0),
         .source_initial_value    ("0"),
         .enable_metastability    ("NO")
      ) issp_bff_rdata_valid      (
         .probe  (before_ff_rdata_valid[NUM_OF_CTRL_PORTS-1:0])
      );

      altsource_probe #(
         .sld_auto_instance_index ("YES"),
         .sld_instance_index      (0),
         .instance_id             ("RAVN"),
         .probe_width             (NUM_OF_CTRL_PORTS),
         .source_width            (0),
         .source_initial_value    ("0"),
         .enable_metastability    ("NO")
      ) issp_aff_rdata_valid      (
         .probe  (after_ff_rdata_valid[NUM_OF_CTRL_PORTS-1:0])
      );

   generate

      // Pack PNF from all traffic generators into one long bit array to ease processing
      wire [TTL_PNF_WIDTH-1:0] pnf_per_bit_persist_packed   = pnf_per_bit_persist[NUM_OF_CTRL_PORTS-1:0];
      wire [TTL_PNF_WIDTH-1:0] first_fail_pnf_packed        = first_fail_pnf[NUM_OF_CTRL_PORTS-1:0];
      wire [TTL_PNF_WIDTH-1:0] first_fail_exp_data_packed   = first_fail_expected_data[NUM_OF_CTRL_PORTS-1:0];
      wire [TTL_PNF_WIDTH-1:0] first_fail_read_data_packed  = first_fail_read_data[NUM_OF_CTRL_PORTS-1:0];
      wire [TTL_PNF_WIDTH-1:0] last_read_data_packed        = last_read_data[NUM_OF_CTRL_PORTS-1:0];
      wire [TTL_PNF_WIDTH-1:0] after_ff_exp_data_packed     = after_ff_expected_data[NUM_OF_CTRL_PORTS-1:0];
      wire [TTL_PNF_WIDTH-1:0] after_ff_read_data_packed    = after_ff_read_data[NUM_OF_CTRL_PORTS-1:0];
      wire [TTL_PNF_WIDTH-1:0] before_ff_exp_data_packed    = before_ff_expected_data[NUM_OF_CTRL_PORTS-1:0];
      wire [TTL_PNF_WIDTH-1:0] before_ff_read_data_packed   = before_ff_read_data[NUM_OF_CTRL_PORTS-1:0];

      for (i = 0; i < (TTL_PNF_WIDTH + MAX_PROBE_WIDTH - 1) / MAX_PROBE_WIDTH; i = i + 1)
      begin : gen_pnf
         altsource_probe #(
            .sld_auto_instance_index ("YES"),
            .sld_instance_index      (0),
            .instance_id             ("PNF0"),
            .probe_width             ((MAX_PROBE_WIDTH * (i+1)) > TTL_PNF_WIDTH ? TTL_PNF_WIDTH - (MAX_PROBE_WIDTH * i) : MAX_PROBE_WIDTH),
            .source_width            (0),
            .source_initial_value    ("0"),
            .enable_metastability    ("NO")
         ) tg_pnf_persist (
            .probe  (pnf_per_bit_persist_packed[((MAX_PROBE_WIDTH * (i+1) - 1) < TTL_PNF_WIDTH-1 ? (MAX_PROBE_WIDTH * (i+1) - 1) : TTL_PNF_WIDTH-1) : (MAX_PROBE_WIDTH * i)])
         );

         altsource_probe #(
            .sld_auto_instance_index ("YES"),
            .sld_instance_index      (0),
            .instance_id             ("FPNF"),
            .probe_width             ((MAX_PROBE_WIDTH * (i+1)) > TTL_PNF_WIDTH ? TTL_PNF_WIDTH - (MAX_PROBE_WIDTH * i) : MAX_PROBE_WIDTH),
            .source_width            (0),
            .source_initial_value    ("0"),
            .enable_metastability    ("NO")
         ) tg_first_fail_pnf (
            .probe  (first_fail_pnf_packed[((MAX_PROBE_WIDTH * (i+1) - 1) < TTL_PNF_WIDTH-1 ? (MAX_PROBE_WIDTH * (i+1) - 1) : TTL_PNF_WIDTH-1) : (MAX_PROBE_WIDTH * i)])
         );

         altsource_probe #(
            .sld_auto_instance_index ("YES"),
            .sld_instance_index      (0),
            .instance_id             ("FEXP"),
            .probe_width             ((MAX_PROBE_WIDTH * (i+1)) > TTL_PNF_WIDTH ? TTL_PNF_WIDTH - (MAX_PROBE_WIDTH * i) : MAX_PROBE_WIDTH),
            .source_width            (0),
            .source_initial_value    ("0"),
            .enable_metastability    ("NO")
         ) tg_wd1 (
            .probe  (first_fail_exp_data_packed[((MAX_PROBE_WIDTH * (i+1) - 1) < TTL_PNF_WIDTH-1 ? (MAX_PROBE_WIDTH * (i+1) - 1) : TTL_PNF_WIDTH-1) : (MAX_PROBE_WIDTH * i)])
         );

         altsource_probe #(
            .sld_auto_instance_index ("YES"),
            .sld_instance_index      (0),
            .instance_id             ("FEP"),
            .probe_width             ((MAX_PROBE_WIDTH * (i+1)) > TTL_PNF_WIDTH ? TTL_PNF_WIDTH - (MAX_PROBE_WIDTH * i) : MAX_PROBE_WIDTH),
            .source_width            (0),
            .source_initial_value    ("0"),
            .enable_metastability    ("NO")
         ) tg_wd2 (
            .probe  (before_ff_exp_data_packed[((MAX_PROBE_WIDTH * (i+1) - 1) < TTL_PNF_WIDTH-1 ? (MAX_PROBE_WIDTH * (i+1) - 1) : TTL_PNF_WIDTH-1) : (MAX_PROBE_WIDTH * i)])
         );

         altsource_probe #(
            .sld_auto_instance_index ("YES"),
            .sld_instance_index      (0),
            .instance_id             ("FEN"),
            .probe_width             ((MAX_PROBE_WIDTH * (i+1)) > TTL_PNF_WIDTH ? TTL_PNF_WIDTH - (MAX_PROBE_WIDTH * i) : MAX_PROBE_WIDTH),
            .source_width            (0),
            .source_initial_value    ("0"),
            .enable_metastability    ("NO")
         ) tg_wd3 (
            .probe  (after_ff_exp_data_packed[((MAX_PROBE_WIDTH * (i+1) - 1) < TTL_PNF_WIDTH-1 ? (MAX_PROBE_WIDTH * (i+1) - 1) : TTL_PNF_WIDTH-1) : (MAX_PROBE_WIDTH * i)])
         );

         altsource_probe #(
            .sld_auto_instance_index ("YES"),
            .sld_instance_index      (0),
            .instance_id             ("RACT"),
            .probe_width             ((MAX_PROBE_WIDTH * (i+1)) > TTL_PNF_WIDTH ? TTL_PNF_WIDTH - (MAX_PROBE_WIDTH * i) : MAX_PROBE_WIDTH),
            .source_width            (0),
            .source_initial_value    ("0"),
            .enable_metastability    ("NO")
         ) tg_rd1 (
            .probe  (first_fail_read_data_packed[((MAX_PROBE_WIDTH * (i+1) - 1) < TTL_PNF_WIDTH-1 ? (MAX_PROBE_WIDTH * (i+1) - 1) : TTL_PNF_WIDTH-1) : (MAX_PROBE_WIDTH * i)])
         );

         altsource_probe #(
            .sld_auto_instance_index ("YES"),
            .sld_instance_index      (0),
            .instance_id             ("RACP"),
            .probe_width             ((MAX_PROBE_WIDTH * (i+1)) > TTL_PNF_WIDTH ? TTL_PNF_WIDTH - (MAX_PROBE_WIDTH * i) : MAX_PROBE_WIDTH),
            .source_width            (0),
            .source_initial_value    ("0"),
            .enable_metastability    ("NO")
         ) tg_rd2 (
            .probe  (before_ff_read_data_packed[((MAX_PROBE_WIDTH * (i+1) - 1) < TTL_PNF_WIDTH-1 ? (MAX_PROBE_WIDTH * (i+1) - 1) : TTL_PNF_WIDTH-1) : (MAX_PROBE_WIDTH * i)])
         );

         altsource_probe #(
            .sld_auto_instance_index ("YES"),
            .sld_instance_index      (0),
            .instance_id             ("RACN"),
            .probe_width             ((MAX_PROBE_WIDTH * (i+1)) > TTL_PNF_WIDTH ? TTL_PNF_WIDTH - (MAX_PROBE_WIDTH * i) : MAX_PROBE_WIDTH),
            .source_width            (0),
            .source_initial_value    ("0"),
            .enable_metastability    ("NO")
         ) tg_rd3 (
            .probe  (after_ff_read_data_packed[((MAX_PROBE_WIDTH * (i+1) - 1) < TTL_PNF_WIDTH-1 ? (MAX_PROBE_WIDTH * (i+1) - 1) : TTL_PNF_WIDTH-1) : (MAX_PROBE_WIDTH * i)])
         );

         altsource_probe #(
            .sld_auto_instance_index ("YES"),
            .sld_instance_index      (0),
            .instance_id             ("LRD"),
            .probe_width             ((MAX_PROBE_WIDTH * (i+1)) > TTL_PNF_WIDTH ? TTL_PNF_WIDTH - (MAX_PROBE_WIDTH * i) : MAX_PROBE_WIDTH),
            .source_width            (0),
            .source_initial_value    ("0"),
            .enable_metastability    ("NO")
         ) tg_last_rdata (
            .probe  (last_read_data_packed[((MAX_PROBE_WIDTH * (i+1) - 1) < TTL_PNF_WIDTH-1 ? (MAX_PROBE_WIDTH * (i+1) - 1) : TTL_PNF_WIDTH-1) : (MAX_PROBE_WIDTH * i)])
         );

      end
   endgenerate
   `else
      assign issp_reset_n = 1'b1;

      assign issp_worm_en = 1'b0;
   `endif

   // Reset from the emif_usr_reset_n port or the in-system source
   assign reset_n_pre_sync = emif_usr_reset_n & issp_reset_n;
   assign reset_n_pre_sync_sec = emif_usr_reset_n_sec & issp_reset_n;

   always_ff @(posedge emif_usr_clk)
   begin
      worm_en[2:0] <= {worm_en[1:0], issp_worm_en};
   end
   always_ff @(posedge emif_usr_clk_sec)
   begin
      worm_en_sec[2:0] <= {worm_en_sec[1:0], issp_worm_en};
   end

   // Create synchronized versions of the resets
   altera_emif_avl_tg_2_reset_sync # (
      .NUM_RESET_OUTPUT (1)
   ) reset_sync_inst (
      .reset_n      (reset_n_pre_sync),
      .clk          (emif_usr_clk),
      .reset_n_sync (reset_n_int)
   );

   altera_emif_avl_tg_2_reset_sync # (
      .NUM_RESET_OUTPUT (1)
   ) reset_sync_sec_inst (
      .reset_n      (reset_n_pre_sync_sec),
      .clk          (emif_usr_clk_sec),
      .reset_n_sync (reset_n_int_sec)
   );

   //Tie off unused signals

   // not supported
   assign amm_beginbursttransfer_all = '0;

   //Tie off side-band signals
   //The example traffic generator doesn't exercise the side-band signals,
   //but we tie them off via core registers to ensure we get somewhat
   //realistic timing for these paths.
   (* altera_attribute = {"-name MAX_FANOUT 1; -name ADV_NETLIST_OPT_ALLOWED ALWAYS_ALLOW"}*) logic core_zero_tieoff_r /* synthesis dont_merge syn_preserve = 1*/;
   always_ff @(posedge emif_usr_clk or negedge reset_n_int)
   begin
      if (!reset_n_int) begin
         core_zero_tieoff_r <= 1'b0;
      end else begin
         core_zero_tieoff_r <= 1'b0;
      end
   end

   (* altera_attribute = {"-name MAX_FANOUT 1; -name ADV_NETLIST_OPT_ALLOWED ALWAYS_ALLOW"}*) logic core_zero_tieoff_r_sec /* synthesis dont_merge syn_preserve = 1*/;
   always_ff @(posedge emif_usr_clk_sec or negedge reset_n_int_sec)
   begin
      if (!reset_n_int_sec) begin
         core_zero_tieoff_r_sec <= 1'b0;
      end else begin
         core_zero_tieoff_r_sec <= 1'b0;
      end
   end

   assign ctrl_user_priority_hi_0         = core_zero_tieoff_r;
   assign ctrl_user_priority_hi_1         = core_zero_tieoff_r_sec;
   assign ctrl_auto_precharge_req_0       = core_zero_tieoff_r;
   assign ctrl_auto_precharge_req_1       = core_zero_tieoff_r_sec;
   assign mmr_master_read_0               = core_zero_tieoff_r;
   assign mmr_master_write_0              = core_zero_tieoff_r;
   assign mmr_master_address_0            = {PORT_CTRL_MMR_MASTER_ADDRESS_WIDTH{core_zero_tieoff_r}};
   assign mmr_master_writedata_0          = {PORT_CTRL_MMR_MASTER_WDATA_WIDTH{core_zero_tieoff_r}};
   assign mmr_master_burstcount_0         = {PORT_CTRL_MMR_MASTER_BCOUNT_WIDTH{core_zero_tieoff_r}};
   assign mmr_master_beginbursttransfer_0 = core_zero_tieoff_r;
   assign mmr_master_read_1               = core_zero_tieoff_r_sec;
   assign mmr_master_write_1              = core_zero_tieoff_r_sec;
   assign mmr_master_address_1            = {PORT_CTRL_MMR_MASTER_ADDRESS_WIDTH{core_zero_tieoff_r_sec}};
   assign mmr_master_writedata_1          = {PORT_CTRL_MMR_MASTER_WDATA_WIDTH{core_zero_tieoff_r_sec}};
   assign mmr_master_burstcount_1         = {PORT_CTRL_MMR_MASTER_BCOUNT_WIDTH{core_zero_tieoff_r_sec}};
   assign mmr_master_beginbursttransfer_1 = core_zero_tieoff_r_sec;



endmodule
