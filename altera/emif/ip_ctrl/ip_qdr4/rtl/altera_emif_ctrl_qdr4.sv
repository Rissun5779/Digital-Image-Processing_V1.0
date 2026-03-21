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


module altera_emif_ctrl_qdr4 # (
   parameter CTRL_DATA_INV_ENA                       = 0,
   parameter CTRL_ADDR_INV_ENA                       = 0,
   parameter CTRL_RAW_TURNAROUND_DELAY_CYC           = 3,
   parameter CTRL_WAR_TURNAROUND_DELAY_CYC           = 10,
   
   parameter PORT_AFI_WLAT_WIDTH                     = 1,
   parameter PORT_AFI_ADDR_WIDTH                     = 1,
   parameter PORT_AFI_RW_N_WIDTH                     = 1,
   parameter PORT_AFI_AP_WIDTH                       = 1,
   parameter PORT_AFI_AINV_WIDTH                     = 1,
   parameter PORT_AFI_RDATA_DINV_WIDTH               = 1,
   parameter PORT_AFI_WDATA_DINV_WIDTH               = 1,
   parameter PORT_AFI_WDATA_VALID_WIDTH              = 1,
   parameter PORT_AFI_WDATA_WIDTH                    = 1,
   parameter PORT_AFI_RDATA_EN_FULL_WIDTH            = 1,
   parameter PORT_AFI_RDATA_WIDTH                    = 1,
   parameter PORT_AFI_RDATA_VALID_WIDTH              = 1,
   parameter PORT_AFI_LD_N_WIDTH                     = 1,
   
   parameter PORT_CTRL_AMM_RDATA_WIDTH               = 1,
   parameter PORT_CTRL_AMM_ADDRESS_WIDTH             = 1,
   parameter PORT_CTRL_AMM_WDATA_WIDTH               = 1,
   parameter PORT_CTRL_AMM_BCOUNT_WIDTH              = 1,
   
   parameter NUM_OF_AVL_CHANNELS                     = 8
   
) (
   input  logic                                               afi_reset_n,
   
   input  logic                                               afi_clk,

   input  logic                                               afi_cal_success,
   input  logic                                               afi_cal_fail,
   input  logic [PORT_AFI_WLAT_WIDTH-1:0]                     afi_wlat,
   output logic [PORT_AFI_ADDR_WIDTH-1:0]                     afi_addr,
   output logic [PORT_AFI_LD_N_WIDTH-1:0]                     afi_ld_n,
   output logic [PORT_AFI_RW_N_WIDTH-1:0]                     afi_rw_n,
   output logic [PORT_AFI_AP_WIDTH-1:0]                       afi_ap,
   output logic [PORT_AFI_AINV_WIDTH-1:0]                     afi_ainv,
   input  logic [PORT_AFI_RDATA_DINV_WIDTH-1:0]               afi_rdata_dinv,
   output logic [PORT_AFI_WDATA_DINV_WIDTH-1:0]               afi_wdata_dinv,
   output logic [PORT_AFI_WDATA_VALID_WIDTH-1:0]              afi_wdata_valid,
   output logic [PORT_AFI_WDATA_WIDTH-1:0]                    afi_wdata,
   output logic [PORT_AFI_RDATA_EN_FULL_WIDTH-1:0]            afi_rdata_en_full,
   input  logic [PORT_AFI_RDATA_WIDTH-1:0]                    afi_rdata,
   input  logic [PORT_AFI_RDATA_VALID_WIDTH-1:0]              afi_rdata_valid,
   
   input  logic                                               amm_write_0,
   input  logic                                               amm_read_0,
   output logic                                               amm_ready_0,
   output logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]               amm_readdata_0,
   input  logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]             amm_address_0,
   input  logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]               amm_writedata_0,
   input  logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]              amm_burstcount_0,
   output logic                                               amm_readdatavalid_0,

   input  logic                                               amm_write_1,
   input  logic                                               amm_read_1,
   output logic                                               amm_ready_1,
   output logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]               amm_readdata_1,
   input  logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]             amm_address_1,
   input  logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]               amm_writedata_1,
   input  logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]              amm_burstcount_1,
   output logic                                               amm_readdatavalid_1,
   
   input  logic                                               amm_write_2,
   input  logic                                               amm_read_2,
   output logic                                               amm_ready_2,
   output logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]               amm_readdata_2,
   input  logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]             amm_address_2,
   input  logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]               amm_writedata_2,
   input  logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]              amm_burstcount_2,
   output logic                                               amm_readdatavalid_2,

   input  logic                                               amm_write_3,
   input  logic                                               amm_read_3,
   output logic                                               amm_ready_3,
   output logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]               amm_readdata_3,
   input  logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]             amm_address_3,
   input  logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]               amm_writedata_3,
   input  logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]              amm_burstcount_3,
   output logic                                               amm_readdatavalid_3,

   input  logic                                               amm_write_4,
   input  logic                                               amm_read_4,
   output logic                                               amm_ready_4,
   output logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]               amm_readdata_4,
   input  logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]             amm_address_4,
   input  logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]               amm_writedata_4,
   input  logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]              amm_burstcount_4,
   output logic                                               amm_readdatavalid_4,

   input  logic                                               amm_write_5,
   input  logic                                               amm_read_5,
   output logic                                               amm_ready_5,
   output logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]               amm_readdata_5,
   input  logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]             amm_address_5,
   input  logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]               amm_writedata_5,
   input  logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]              amm_burstcount_5,
   output logic                                               amm_readdatavalid_5,

   input  logic                                               amm_write_6,
   input  logic                                               amm_read_6,
   output logic                                               amm_ready_6,
   output logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]               amm_readdata_6,
   input  logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]             amm_address_6,
   input  logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]               amm_writedata_6,
   input  logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]              amm_burstcount_6,
   output logic                                               amm_readdatavalid_6,

   input  logic                                               amm_write_7,
   input  logic                                               amm_read_7,
   output logic                                               amm_ready_7,
   output logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]               amm_readdata_7,
   input  logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]             amm_address_7,
   input  logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]               amm_writedata_7,
   input  logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]              amm_burstcount_7,
   output logic                                               amm_readdatavalid_7 
); 
   timeunit 1ps;
   timeprecision 1ps;
   
   wire [PORT_AFI_ADDR_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_addr_fsm           [NUM_OF_AVL_CHANNELS-1:0];
   wire [PORT_AFI_LD_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_ld_n_fsm           [NUM_OF_AVL_CHANNELS-1:0];
   wire [PORT_AFI_RW_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_rw_n_fsm           [NUM_OF_AVL_CHANNELS-1:0];
   wire [PORT_AFI_WDATA_VALID_WIDTH/NUM_OF_AVL_CHANNELS-1:0]     afi_wdata_valid_fsm    [NUM_OF_AVL_CHANNELS-1:0];
   wire [PORT_AFI_WDATA_WIDTH/NUM_OF_AVL_CHANNELS-1:0]           afi_wdata_fsm          [NUM_OF_AVL_CHANNELS-1:0];
   wire [PORT_AFI_RDATA_EN_FULL_WIDTH/NUM_OF_AVL_CHANNELS-1:0]   afi_rdata_en_full_fsm  [NUM_OF_AVL_CHANNELS-1:0];
   
   wire [PORT_AFI_ADDR_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_addr_q             [NUM_OF_AVL_CHANNELS-1:0];
   wire [PORT_AFI_LD_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_ld_n_q             [NUM_OF_AVL_CHANNELS-1:0];
   wire [PORT_AFI_RW_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_rw_n_q             [NUM_OF_AVL_CHANNELS-1:0];
   wire [PORT_AFI_RDATA_EN_FULL_WIDTH/NUM_OF_AVL_CHANNELS-1:0]   afi_rdata_en_full_q    [NUM_OF_AVL_CHANNELS-1:0];
   
   wire                                                          queue_empty;
   wire                                                          queue_full;
   
   wire                                                          wdata_request          [NUM_OF_AVL_CHANNELS-1:0];
   
   wire                                                          dequeue;
   
   wire [PORT_AFI_RDATA_WIDTH-1:0]                               afi_rdata_after_dinv;
   wire [PORT_AFI_WDATA_WIDTH-1:0]                               afi_wdata_before_dinv;
   
   wire [PORT_AFI_ADDR_WIDTH-1:0]                                afi_addr_before_ainv;
   
   wire                                                          afi_channel_fifo_write;
   
   wire [NUM_OF_AVL_CHANNELS-1:0]                                next_dequeue_mask;
   
   wire [NUM_OF_AVL_CHANNELS-1:0]                                is_read_command;
   wire [NUM_OF_AVL_CHANNELS-1:0]                                is_write_command;
   
   wire [PORT_AFI_ADDR_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_addr_next_q        [NUM_OF_AVL_CHANNELS-1:0];
   wire [PORT_AFI_LD_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_ld_n_next_q        [NUM_OF_AVL_CHANNELS-1:0];
   wire [PORT_AFI_WDATA_DINV_WIDTH-1:0]                          invert_data;
   wire [PORT_AFI_AINV_WIDTH-1:0]                                invert_addr;
   
   logic [NUM_OF_AVL_CHANNELS-1:0]                               bank_violation;
   
   altera_emif_ctrl_qdr4_avl_fsm # (
      .PORT_CTRL_AMM_RDATA_WIDTH (PORT_CTRL_AMM_RDATA_WIDTH),
      .PORT_CTRL_AMM_ADDRESS_WIDTH (PORT_CTRL_AMM_ADDRESS_WIDTH),
      .PORT_CTRL_AMM_WDATA_WIDTH (PORT_CTRL_AMM_WDATA_WIDTH),
      .PORT_CTRL_AMM_BCOUNT_WIDTH (PORT_CTRL_AMM_BCOUNT_WIDTH),
      .PORT_AFI_WLAT_WIDTH (PORT_AFI_WLAT_WIDTH),
      .PORT_AFI_ADDR_WIDTH (PORT_AFI_ADDR_WIDTH),
      .PORT_AFI_LD_N_WIDTH (PORT_AFI_LD_N_WIDTH),
      .PORT_AFI_RW_N_WIDTH (PORT_AFI_RW_N_WIDTH),
      .PORT_AFI_WDATA_VALID_WIDTH (PORT_AFI_WDATA_VALID_WIDTH),
      .PORT_AFI_WDATA_WIDTH (PORT_AFI_WDATA_WIDTH),
      .PORT_AFI_RDATA_EN_FULL_WIDTH (PORT_AFI_RDATA_EN_FULL_WIDTH),
      .PORT_AFI_RDATA_WIDTH (PORT_AFI_RDATA_WIDTH),
      .PORT_AFI_RDATA_VALID_WIDTH (PORT_AFI_RDATA_VALID_WIDTH),
      .NUM_OF_AVL_CHANNELS(NUM_OF_AVL_CHANNELS),
      
      .AVL_CHANNEL_NUM(0)
   ) avl0_fsm (
      .afi_reset_n (afi_reset_n),
      .afi_clk (afi_clk),
      .amm_write (amm_write_0),
      .amm_read (amm_read_0),
      .amm_ready (amm_ready_0),
      .amm_readdata (amm_readdata_0),
      .amm_address (amm_address_0),
      .amm_writedata (amm_writedata_0),
      .amm_burstcount (amm_burstcount_0),
      .amm_readdatavalid (amm_readdatavalid_0),
      .afi_cal_success (afi_cal_success),
      .afi_cal_fail (afi_cal_fail),
      .afi_wlat (afi_wlat),
      .afi_addr (afi_addr_fsm[0]),
      .afi_ld_n (afi_ld_n_fsm[0]),
      .afi_rw_n (afi_rw_n_fsm[0]),
      .afi_wdata_valid (afi_wdata_valid_fsm[0]),
      .afi_wdata (afi_wdata_fsm[0]),
      .afi_rdata_en_full (afi_rdata_en_full_fsm[0]),
      .afi_rdata (afi_rdata_after_dinv),
      .afi_rdata_valid (afi_rdata_valid),
      .wdata_request (wdata_request[0]),
      .pause (queue_full)
   );
   
   altera_emif_ctrl_qdr4_avl_fsm # (
      .PORT_CTRL_AMM_RDATA_WIDTH (PORT_CTRL_AMM_RDATA_WIDTH),
      .PORT_CTRL_AMM_ADDRESS_WIDTH (PORT_CTRL_AMM_ADDRESS_WIDTH),
      .PORT_CTRL_AMM_WDATA_WIDTH (PORT_CTRL_AMM_WDATA_WIDTH),
      .PORT_CTRL_AMM_BCOUNT_WIDTH (PORT_CTRL_AMM_BCOUNT_WIDTH),
      .PORT_AFI_WLAT_WIDTH (PORT_AFI_WLAT_WIDTH),
      .PORT_AFI_ADDR_WIDTH (PORT_AFI_ADDR_WIDTH),
      .PORT_AFI_LD_N_WIDTH (PORT_AFI_LD_N_WIDTH),
      .PORT_AFI_RW_N_WIDTH (PORT_AFI_RW_N_WIDTH),
      .PORT_AFI_WDATA_VALID_WIDTH (PORT_AFI_WDATA_VALID_WIDTH),
      .PORT_AFI_WDATA_WIDTH (PORT_AFI_WDATA_WIDTH),
      .PORT_AFI_RDATA_EN_FULL_WIDTH (PORT_AFI_RDATA_EN_FULL_WIDTH),
      .PORT_AFI_RDATA_WIDTH (PORT_AFI_RDATA_WIDTH),
      .PORT_AFI_RDATA_VALID_WIDTH (PORT_AFI_RDATA_VALID_WIDTH),
      .NUM_OF_AVL_CHANNELS(NUM_OF_AVL_CHANNELS),
      
      .AVL_CHANNEL_NUM(1)
   ) avl1_fsm (
      .afi_reset_n (afi_reset_n),
      .afi_clk (afi_clk),
      .amm_write (amm_write_1),
      .amm_read (amm_read_1),
      .amm_ready (amm_ready_1),
      .amm_readdata (amm_readdata_1),
      .amm_address (amm_address_1),
      .amm_writedata (amm_writedata_1),
      .amm_burstcount (amm_burstcount_1),
      .amm_readdatavalid (amm_readdatavalid_1),
      .afi_cal_success (afi_cal_success),
      .afi_cal_fail (afi_cal_fail),
      .afi_wlat (afi_wlat),
      .afi_addr (afi_addr_fsm[1]),
      .afi_ld_n (afi_ld_n_fsm[1]),
      .afi_rw_n (afi_rw_n_fsm[1]),
      .afi_wdata_valid (afi_wdata_valid_fsm[1]),
      .afi_wdata (afi_wdata_fsm[1]),
      .afi_rdata_en_full (afi_rdata_en_full_fsm[1]),
      .afi_rdata (afi_rdata_after_dinv),
      .afi_rdata_valid (afi_rdata_valid),
      .wdata_request (wdata_request[1]),
      .pause (queue_full)
   );
   
   altera_emif_ctrl_qdr4_avl_fsm # (
      .PORT_CTRL_AMM_RDATA_WIDTH (PORT_CTRL_AMM_RDATA_WIDTH),
      .PORT_CTRL_AMM_ADDRESS_WIDTH (PORT_CTRL_AMM_ADDRESS_WIDTH),
      .PORT_CTRL_AMM_WDATA_WIDTH (PORT_CTRL_AMM_WDATA_WIDTH),
      .PORT_CTRL_AMM_BCOUNT_WIDTH (PORT_CTRL_AMM_BCOUNT_WIDTH),
      .PORT_AFI_WLAT_WIDTH (PORT_AFI_WLAT_WIDTH),
      .PORT_AFI_ADDR_WIDTH (PORT_AFI_ADDR_WIDTH),
      .PORT_AFI_LD_N_WIDTH (PORT_AFI_LD_N_WIDTH),
      .PORT_AFI_RW_N_WIDTH (PORT_AFI_RW_N_WIDTH),
      .PORT_AFI_WDATA_VALID_WIDTH (PORT_AFI_WDATA_VALID_WIDTH),
      .PORT_AFI_WDATA_WIDTH (PORT_AFI_WDATA_WIDTH),
      .PORT_AFI_RDATA_EN_FULL_WIDTH (PORT_AFI_RDATA_EN_FULL_WIDTH),
      .PORT_AFI_RDATA_WIDTH (PORT_AFI_RDATA_WIDTH),
      .PORT_AFI_RDATA_VALID_WIDTH (PORT_AFI_RDATA_VALID_WIDTH),
      .NUM_OF_AVL_CHANNELS(NUM_OF_AVL_CHANNELS),
      
      .AVL_CHANNEL_NUM(2)
   ) avl2_fsm (
      .afi_reset_n (afi_reset_n),
      .afi_clk (afi_clk),
      .amm_write (amm_write_2),
      .amm_read (amm_read_2),
      .amm_ready (amm_ready_2),
      .amm_readdata (amm_readdata_2),
      .amm_address (amm_address_2),
      .amm_writedata (amm_writedata_2),
      .amm_burstcount (amm_burstcount_2),
      .amm_readdatavalid (amm_readdatavalid_2),
      .afi_cal_success (afi_cal_success),
      .afi_cal_fail (afi_cal_fail),
      .afi_wlat (afi_wlat),
      .afi_addr (afi_addr_fsm[2]),
      .afi_ld_n (afi_ld_n_fsm[2]),
      .afi_rw_n (afi_rw_n_fsm[2]),
      .afi_wdata_valid (afi_wdata_valid_fsm[2]),
      .afi_wdata (afi_wdata_fsm[2]),
      .afi_rdata_en_full (afi_rdata_en_full_fsm[2]),
      .afi_rdata (afi_rdata_after_dinv),
      .afi_rdata_valid (afi_rdata_valid),
      .wdata_request (wdata_request[2]),
      .pause (queue_full)
   );
   
   altera_emif_ctrl_qdr4_avl_fsm # (
      .PORT_CTRL_AMM_RDATA_WIDTH (PORT_CTRL_AMM_RDATA_WIDTH),
      .PORT_CTRL_AMM_ADDRESS_WIDTH (PORT_CTRL_AMM_ADDRESS_WIDTH),
      .PORT_CTRL_AMM_WDATA_WIDTH (PORT_CTRL_AMM_WDATA_WIDTH),
      .PORT_CTRL_AMM_BCOUNT_WIDTH (PORT_CTRL_AMM_BCOUNT_WIDTH),
      .PORT_AFI_WLAT_WIDTH (PORT_AFI_WLAT_WIDTH),
      .PORT_AFI_ADDR_WIDTH (PORT_AFI_ADDR_WIDTH),
      .PORT_AFI_LD_N_WIDTH (PORT_AFI_LD_N_WIDTH),
      .PORT_AFI_RW_N_WIDTH (PORT_AFI_RW_N_WIDTH),
      .PORT_AFI_WDATA_VALID_WIDTH (PORT_AFI_WDATA_VALID_WIDTH),
      .PORT_AFI_WDATA_WIDTH (PORT_AFI_WDATA_WIDTH),
      .PORT_AFI_RDATA_EN_FULL_WIDTH (PORT_AFI_RDATA_EN_FULL_WIDTH),
      .PORT_AFI_RDATA_WIDTH (PORT_AFI_RDATA_WIDTH),
      .PORT_AFI_RDATA_VALID_WIDTH (PORT_AFI_RDATA_VALID_WIDTH),
      .NUM_OF_AVL_CHANNELS(NUM_OF_AVL_CHANNELS),
      
      .AVL_CHANNEL_NUM(3)
   ) avl3_fsm (
      .afi_reset_n (afi_reset_n),
      .afi_clk (afi_clk),
      .amm_write (amm_write_3),
      .amm_read (amm_read_3),
      .amm_ready (amm_ready_3),
      .amm_readdata (amm_readdata_3),
      .amm_address (amm_address_3),
      .amm_writedata (amm_writedata_3),
      .amm_burstcount (amm_burstcount_3),
      .amm_readdatavalid (amm_readdatavalid_3),
      .afi_cal_success (afi_cal_success),
      .afi_cal_fail (afi_cal_fail),
      .afi_wlat (afi_wlat),
      .afi_addr (afi_addr_fsm[3]),
      .afi_ld_n (afi_ld_n_fsm[3]),
      .afi_rw_n (afi_rw_n_fsm[3]),
      .afi_wdata_valid (afi_wdata_valid_fsm[3]),
      .afi_wdata (afi_wdata_fsm[3]),
      .afi_rdata_en_full (afi_rdata_en_full_fsm[3]),
      .afi_rdata (afi_rdata_after_dinv),
      .afi_rdata_valid (afi_rdata_valid),
      .wdata_request (wdata_request[3]),
      .pause (queue_full)
   );
   
   altera_emif_ctrl_qdr4_avl_fsm # (
      .PORT_CTRL_AMM_RDATA_WIDTH (PORT_CTRL_AMM_RDATA_WIDTH),
      .PORT_CTRL_AMM_ADDRESS_WIDTH (PORT_CTRL_AMM_ADDRESS_WIDTH),
      .PORT_CTRL_AMM_WDATA_WIDTH (PORT_CTRL_AMM_WDATA_WIDTH),
      .PORT_CTRL_AMM_BCOUNT_WIDTH (PORT_CTRL_AMM_BCOUNT_WIDTH),
      .PORT_AFI_WLAT_WIDTH (PORT_AFI_WLAT_WIDTH),
      .PORT_AFI_ADDR_WIDTH (PORT_AFI_ADDR_WIDTH),
      .PORT_AFI_LD_N_WIDTH (PORT_AFI_LD_N_WIDTH),
      .PORT_AFI_RW_N_WIDTH (PORT_AFI_RW_N_WIDTH),
      .PORT_AFI_WDATA_VALID_WIDTH (PORT_AFI_WDATA_VALID_WIDTH),
      .PORT_AFI_WDATA_WIDTH (PORT_AFI_WDATA_WIDTH),
      .PORT_AFI_RDATA_EN_FULL_WIDTH (PORT_AFI_RDATA_EN_FULL_WIDTH),
      .PORT_AFI_RDATA_WIDTH (PORT_AFI_RDATA_WIDTH),
      .PORT_AFI_RDATA_VALID_WIDTH (PORT_AFI_RDATA_VALID_WIDTH),
      .NUM_OF_AVL_CHANNELS(NUM_OF_AVL_CHANNELS),
      
      .AVL_CHANNEL_NUM(4)
   ) avl4_fsm (
      .afi_reset_n (afi_reset_n),
      .afi_clk (afi_clk),
      .amm_write (amm_write_4),
      .amm_read (amm_read_4),
      .amm_ready (amm_ready_4),
      .amm_readdata (amm_readdata_4),
      .amm_address (amm_address_4),
      .amm_writedata (amm_writedata_4),
      .amm_burstcount (amm_burstcount_4),
      .amm_readdatavalid (amm_readdatavalid_4),
      .afi_cal_success (afi_cal_success),
      .afi_cal_fail (afi_cal_fail),
      .afi_wlat (afi_wlat),
      .afi_addr (afi_addr_fsm[4]),
      .afi_ld_n (afi_ld_n_fsm[4]),
      .afi_rw_n (afi_rw_n_fsm[4]),
      .afi_wdata_valid (afi_wdata_valid_fsm[4]),
      .afi_wdata (afi_wdata_fsm[4]),
      .afi_rdata_en_full (afi_rdata_en_full_fsm[4]),
      .afi_rdata (afi_rdata_after_dinv),
      .afi_rdata_valid (afi_rdata_valid),
      .wdata_request (wdata_request[4]),
      .pause (queue_full)
   );
   
   altera_emif_ctrl_qdr4_avl_fsm # (
      .PORT_CTRL_AMM_RDATA_WIDTH (PORT_CTRL_AMM_RDATA_WIDTH),
      .PORT_CTRL_AMM_ADDRESS_WIDTH (PORT_CTRL_AMM_ADDRESS_WIDTH),
      .PORT_CTRL_AMM_WDATA_WIDTH (PORT_CTRL_AMM_WDATA_WIDTH),
      .PORT_CTRL_AMM_BCOUNT_WIDTH (PORT_CTRL_AMM_BCOUNT_WIDTH),
      .PORT_AFI_WLAT_WIDTH (PORT_AFI_WLAT_WIDTH),
      .PORT_AFI_ADDR_WIDTH (PORT_AFI_ADDR_WIDTH),
      .PORT_AFI_LD_N_WIDTH (PORT_AFI_LD_N_WIDTH),
      .PORT_AFI_RW_N_WIDTH (PORT_AFI_RW_N_WIDTH),
      .PORT_AFI_WDATA_VALID_WIDTH (PORT_AFI_WDATA_VALID_WIDTH),
      .PORT_AFI_WDATA_WIDTH (PORT_AFI_WDATA_WIDTH),
      .PORT_AFI_RDATA_EN_FULL_WIDTH (PORT_AFI_RDATA_EN_FULL_WIDTH),
      .PORT_AFI_RDATA_WIDTH (PORT_AFI_RDATA_WIDTH),
      .PORT_AFI_RDATA_VALID_WIDTH (PORT_AFI_RDATA_VALID_WIDTH),
      .NUM_OF_AVL_CHANNELS(NUM_OF_AVL_CHANNELS),
      
      .AVL_CHANNEL_NUM(5)
   ) avl5_fsm (
      .afi_reset_n (afi_reset_n),
      .afi_clk (afi_clk),
      .amm_write (amm_write_5),
      .amm_read (amm_read_5),
      .amm_ready (amm_ready_5),
      .amm_readdata (amm_readdata_5),
      .amm_address (amm_address_5),
      .amm_writedata (amm_writedata_5),
      .amm_burstcount (amm_burstcount_5),
      .amm_readdatavalid (amm_readdatavalid_5),
      .afi_cal_success (afi_cal_success),
      .afi_cal_fail (afi_cal_fail),
      .afi_wlat (afi_wlat),
      .afi_addr (afi_addr_fsm[5]),
      .afi_ld_n (afi_ld_n_fsm[5]),
      .afi_rw_n (afi_rw_n_fsm[5]),
      .afi_wdata_valid (afi_wdata_valid_fsm[5]),
      .afi_wdata (afi_wdata_fsm[5]),
      .afi_rdata_en_full (afi_rdata_en_full_fsm[5]),
      .afi_rdata (afi_rdata_after_dinv),
      .afi_rdata_valid (afi_rdata_valid),
      .wdata_request (wdata_request[5]),
      .pause (queue_full)
   );
   
   altera_emif_ctrl_qdr4_avl_fsm # (
      .PORT_CTRL_AMM_RDATA_WIDTH (PORT_CTRL_AMM_RDATA_WIDTH),
      .PORT_CTRL_AMM_ADDRESS_WIDTH (PORT_CTRL_AMM_ADDRESS_WIDTH),
      .PORT_CTRL_AMM_WDATA_WIDTH (PORT_CTRL_AMM_WDATA_WIDTH),
      .PORT_CTRL_AMM_BCOUNT_WIDTH (PORT_CTRL_AMM_BCOUNT_WIDTH),
      .PORT_AFI_WLAT_WIDTH (PORT_AFI_WLAT_WIDTH),
      .PORT_AFI_ADDR_WIDTH (PORT_AFI_ADDR_WIDTH),
      .PORT_AFI_LD_N_WIDTH (PORT_AFI_LD_N_WIDTH),
      .PORT_AFI_RW_N_WIDTH (PORT_AFI_RW_N_WIDTH),
      .PORT_AFI_WDATA_VALID_WIDTH (PORT_AFI_WDATA_VALID_WIDTH),
      .PORT_AFI_WDATA_WIDTH (PORT_AFI_WDATA_WIDTH),
      .PORT_AFI_RDATA_EN_FULL_WIDTH (PORT_AFI_RDATA_EN_FULL_WIDTH),
      .PORT_AFI_RDATA_WIDTH (PORT_AFI_RDATA_WIDTH),
      .PORT_AFI_RDATA_VALID_WIDTH (PORT_AFI_RDATA_VALID_WIDTH),
      .NUM_OF_AVL_CHANNELS(NUM_OF_AVL_CHANNELS),
      
      .AVL_CHANNEL_NUM(6)
   ) avl6_fsm (
      .afi_reset_n (afi_reset_n),
      .afi_clk (afi_clk),
      .amm_write (amm_write_6),
      .amm_read (amm_read_6),
      .amm_ready (amm_ready_6),
      .amm_readdata (amm_readdata_6),
      .amm_address (amm_address_6),
      .amm_writedata (amm_writedata_6),
      .amm_burstcount (amm_burstcount_6),
      .amm_readdatavalid (amm_readdatavalid_6),
      .afi_cal_success (afi_cal_success),
      .afi_cal_fail (afi_cal_fail),
      .afi_wlat (afi_wlat),
      .afi_addr (afi_addr_fsm[6]),
      .afi_ld_n (afi_ld_n_fsm[6]),
      .afi_rw_n (afi_rw_n_fsm[6]),
      .afi_wdata_valid (afi_wdata_valid_fsm[6]),
      .afi_wdata (afi_wdata_fsm[6]),
      .afi_rdata_en_full (afi_rdata_en_full_fsm[6]),
      .afi_rdata (afi_rdata_after_dinv),
      .afi_rdata_valid (afi_rdata_valid),
      .wdata_request (wdata_request[6]),
      .pause (queue_full)
   );
   
   altera_emif_ctrl_qdr4_avl_fsm # (
      .PORT_CTRL_AMM_RDATA_WIDTH (PORT_CTRL_AMM_RDATA_WIDTH),
      .PORT_CTRL_AMM_ADDRESS_WIDTH (PORT_CTRL_AMM_ADDRESS_WIDTH),
      .PORT_CTRL_AMM_WDATA_WIDTH (PORT_CTRL_AMM_WDATA_WIDTH),
      .PORT_CTRL_AMM_BCOUNT_WIDTH (PORT_CTRL_AMM_BCOUNT_WIDTH),
      .PORT_AFI_WLAT_WIDTH (PORT_AFI_WLAT_WIDTH),
      .PORT_AFI_ADDR_WIDTH (PORT_AFI_ADDR_WIDTH),
      .PORT_AFI_LD_N_WIDTH (PORT_AFI_LD_N_WIDTH),
      .PORT_AFI_RW_N_WIDTH (PORT_AFI_RW_N_WIDTH),
      .PORT_AFI_WDATA_VALID_WIDTH (PORT_AFI_WDATA_VALID_WIDTH),
      .PORT_AFI_WDATA_WIDTH (PORT_AFI_WDATA_WIDTH),
      .PORT_AFI_RDATA_EN_FULL_WIDTH (PORT_AFI_RDATA_EN_FULL_WIDTH),
      .PORT_AFI_RDATA_WIDTH (PORT_AFI_RDATA_WIDTH),
      .PORT_AFI_RDATA_VALID_WIDTH (PORT_AFI_RDATA_VALID_WIDTH),
      .NUM_OF_AVL_CHANNELS(NUM_OF_AVL_CHANNELS),
      
      .AVL_CHANNEL_NUM(7)
   ) avl7_fsm (
      .afi_reset_n (afi_reset_n),
      .afi_clk (afi_clk),
      .amm_write (amm_write_7),
      .amm_read (amm_read_7),
      .amm_ready (amm_ready_7),
      .amm_readdata (amm_readdata_7),
      .amm_address (amm_address_7),
      .amm_writedata (amm_writedata_7),
      .amm_burstcount (amm_burstcount_7),
      .amm_readdatavalid (amm_readdatavalid_7),
      .afi_cal_success (afi_cal_success),
      .afi_cal_fail (afi_cal_fail),
      .afi_wlat (afi_wlat),
      .afi_addr (afi_addr_fsm[7]),
      .afi_ld_n (afi_ld_n_fsm[7]),
      .afi_rw_n (afi_rw_n_fsm[7]),
      .afi_wdata_valid (afi_wdata_valid_fsm[7]),
      .afi_wdata (afi_wdata_fsm[7]),
      .afi_rdata_en_full (afi_rdata_en_full_fsm[7]),
      .afi_rdata (afi_rdata_after_dinv),
      .afi_rdata_valid (afi_rdata_valid),
      .wdata_request (wdata_request[7]),
      .pause (queue_full)
   );
   
   assign afi_channel_fifo_write = afi_ld_n_fsm[0] != '1 || afi_ld_n_fsm[1] != '1 || afi_ld_n_fsm[2] != '1 || afi_ld_n_fsm[3] != '1 || afi_ld_n_fsm[4] != '1 || afi_ld_n_fsm[5] != '1 || afi_ld_n_fsm[6] != '1 || afi_ld_n_fsm[7] != '1;
   
   generate
   genvar i;
      for (i = 0; i < NUM_OF_AVL_CHANNELS; i++)
      begin : afi_channel_fifo_gen
         if (i == 0) begin
            altera_emif_ctrl_qdr4_afi_channel_fifo #(
               .PORT_AFI_ADDR_WIDTH (PORT_AFI_ADDR_WIDTH),
               .PORT_AFI_LD_N_WIDTH (PORT_AFI_LD_N_WIDTH),
               .PORT_AFI_RW_N_WIDTH (PORT_AFI_RW_N_WIDTH),
               .PORT_AFI_WDATA_VALID_WIDTH (PORT_AFI_WDATA_VALID_WIDTH),
               .PORT_AFI_WDATA_WIDTH (PORT_AFI_WDATA_WIDTH),
               .PORT_AFI_RDATA_EN_FULL_WIDTH (PORT_AFI_RDATA_EN_FULL_WIDTH),
               .PORT_AFI_RDATA_WIDTH (PORT_AFI_RDATA_WIDTH),
               .PORT_AFI_RDATA_VALID_WIDTH (PORT_AFI_RDATA_VALID_WIDTH),
               .NUM_OF_AVL_CHANNELS(NUM_OF_AVL_CHANNELS),
               .DEPTH (4)
            ) afi_channel_fifo_inst (
               .clk(afi_clk),
               .reset_n(afi_reset_n),
               
               .empty(queue_empty),
               .full(queue_full),
               .dequeue(dequeue),
               .write(afi_channel_fifo_write),
               
               .afi_addr_in(afi_addr_fsm[i]),
               .afi_ld_n_in(afi_ld_n_fsm[i]),
               .afi_rw_n_in(afi_rw_n_fsm[i]),
               .afi_rdata_en_full_in(afi_rdata_en_full_fsm[i]),
               
               .afi_addr_out(afi_addr_q[i]),
               .afi_ld_n_out(afi_ld_n_q[i]),
               .afi_rw_n_out(afi_rw_n_q[i]),
               .afi_rdata_en_full_out(afi_rdata_en_full_q[i]),
               
               .afi_addr_next_out(afi_addr_next_q[i]),
               .afi_ld_n_next_out(afi_ld_n_next_q[i]),
               
               .next_dequeue_mask(next_dequeue_mask[i]),
               
               .is_read_command(is_read_command[i]),
               .is_write_command(is_write_command[i])
            );
         end else begin
            altera_emif_ctrl_qdr4_afi_channel_fifo #(
               .PORT_AFI_ADDR_WIDTH (PORT_AFI_ADDR_WIDTH),
               .PORT_AFI_LD_N_WIDTH (PORT_AFI_LD_N_WIDTH),
               .PORT_AFI_RW_N_WIDTH (PORT_AFI_RW_N_WIDTH),
               .PORT_AFI_WDATA_VALID_WIDTH (PORT_AFI_WDATA_VALID_WIDTH),
               .PORT_AFI_WDATA_WIDTH (PORT_AFI_WDATA_WIDTH),
               .PORT_AFI_RDATA_EN_FULL_WIDTH (PORT_AFI_RDATA_EN_FULL_WIDTH),
               .PORT_AFI_RDATA_WIDTH (PORT_AFI_RDATA_WIDTH),
               .PORT_AFI_RDATA_VALID_WIDTH (PORT_AFI_RDATA_VALID_WIDTH),
               .NUM_OF_AVL_CHANNELS(NUM_OF_AVL_CHANNELS),
               .DEPTH (4)
            ) afi_channel_fifo_inst (
               .clk(afi_clk),
               .reset_n(afi_reset_n),
               
               .empty(),
               .full(),
               .dequeue(dequeue),
               .write(afi_channel_fifo_write),
               
               .afi_addr_in(afi_addr_fsm[i]),
               .afi_ld_n_in(afi_ld_n_fsm[i]),
               .afi_rw_n_in(afi_rw_n_fsm[i]),
               .afi_rdata_en_full_in(afi_rdata_en_full_fsm[i]),
               
               .afi_addr_out(afi_addr_q[i]),
               .afi_ld_n_out(afi_ld_n_q[i]),
               .afi_rw_n_out(afi_rw_n_q[i]),
               .afi_rdata_en_full_out(afi_rdata_en_full_q[i]),
               
               .afi_addr_next_out(afi_addr_next_q[i]),
               .afi_ld_n_next_out(afi_ld_n_next_q[i]),
               
               .next_dequeue_mask(next_dequeue_mask[i]),
               
               .is_read_command(is_read_command[i]),
               .is_write_command(is_write_command[i])
            );
         end
      end
   endgenerate
   
   altera_emif_ctrl_qdr4_cmd_scheduler #(
      .CTRL_RAW_TURNAROUND_DELAY_CYC (CTRL_RAW_TURNAROUND_DELAY_CYC),
      .CTRL_WAR_TURNAROUND_DELAY_CYC (CTRL_WAR_TURNAROUND_DELAY_CYC),
      .PORT_AFI_ADDR_WIDTH (PORT_AFI_ADDR_WIDTH),
      .PORT_AFI_LD_N_WIDTH (PORT_AFI_LD_N_WIDTH),
      .PORT_AFI_RW_N_WIDTH (PORT_AFI_RW_N_WIDTH),
      .PORT_AFI_WDATA_VALID_WIDTH (PORT_AFI_WDATA_VALID_WIDTH),
      .PORT_AFI_WDATA_WIDTH (PORT_AFI_WDATA_WIDTH),
      .PORT_AFI_RDATA_EN_FULL_WIDTH (PORT_AFI_RDATA_EN_FULL_WIDTH),
      .PORT_AFI_RDATA_WIDTH (PORT_AFI_RDATA_WIDTH),
      .PORT_AFI_RDATA_VALID_WIDTH (PORT_AFI_RDATA_VALID_WIDTH),
      .PORT_AFI_WDATA_DINV_WIDTH (PORT_AFI_WDATA_DINV_WIDTH),
      .PORT_AFI_AINV_WIDTH (PORT_AFI_AINV_WIDTH),
      .NUM_OF_AVL_CHANNELS (NUM_OF_AVL_CHANNELS),
      .CTRL_DATA_INV_ENA (CTRL_DATA_INV_ENA),
      .CTRL_ADDR_INV_ENA (CTRL_ADDR_INV_ENA)
   ) cmd_scheduler_inst (
      .clk(afi_clk),
      .reset_n(afi_reset_n),
      
      .afi_addr_0(afi_addr_q[0]),
      .afi_ld_n_0(afi_ld_n_q[0]),
      .afi_rw_n_0(afi_rw_n_q[0]),
      .afi_wdata_valid_0(afi_wdata_valid_fsm[0]),
      .afi_wdata_0(afi_wdata_fsm[0]),
      .afi_rdata_en_full_0(afi_rdata_en_full_q[0]),
      
      .afi_addr_1(afi_addr_q[1]),
      .afi_ld_n_1(afi_ld_n_q[1]),
      .afi_rw_n_1(afi_rw_n_q[1]),
      .afi_wdata_valid_1(afi_wdata_valid_fsm[1]),
      .afi_wdata_1(afi_wdata_fsm[1]),
      .afi_rdata_en_full_1(afi_rdata_en_full_q[1]),
      
      .afi_addr_2(afi_addr_q[2]),
      .afi_ld_n_2(afi_ld_n_q[2]),
      .afi_rw_n_2(afi_rw_n_q[2]),
      .afi_wdata_valid_2(afi_wdata_valid_fsm[2]),
      .afi_wdata_2(afi_wdata_fsm[2]),
      .afi_rdata_en_full_2(afi_rdata_en_full_q[2]),
      
      .afi_addr_3(afi_addr_q[3]),
      .afi_ld_n_3(afi_ld_n_q[3]),
      .afi_rw_n_3(afi_rw_n_q[3]),
      .afi_wdata_valid_3(afi_wdata_valid_fsm[3]),
      .afi_wdata_3(afi_wdata_fsm[3]),
      .afi_rdata_en_full_3(afi_rdata_en_full_q[3]),
      
      .afi_addr_4(afi_addr_q[4]),
      .afi_ld_n_4(afi_ld_n_q[4]),
      .afi_rw_n_4(afi_rw_n_q[4]),
      .afi_wdata_valid_4(afi_wdata_valid_fsm[4]),
      .afi_wdata_4(afi_wdata_fsm[4]),
      .afi_rdata_en_full_4(afi_rdata_en_full_q[4]),
      
      .afi_addr_5(afi_addr_q[5]),
      .afi_ld_n_5(afi_ld_n_q[5]),
      .afi_rw_n_5(afi_rw_n_q[5]),
      .afi_wdata_valid_5(afi_wdata_valid_fsm[5]),
      .afi_wdata_5(afi_wdata_fsm[5]),
      .afi_rdata_en_full_5(afi_rdata_en_full_q[5]),
      
      .afi_addr_6(afi_addr_q[6]),
      .afi_ld_n_6(afi_ld_n_q[6]),
      .afi_rw_n_6(afi_rw_n_q[6]),
      .afi_wdata_valid_6(afi_wdata_valid_fsm[6]),
      .afi_wdata_6(afi_wdata_fsm[6]),
      .afi_rdata_en_full_6(afi_rdata_en_full_q[6]),
      
      .afi_addr_7(afi_addr_q[7]),
      .afi_ld_n_7(afi_ld_n_q[7]),
      .afi_rw_n_7(afi_rw_n_q[7]),
      .afi_wdata_valid_7(afi_wdata_valid_fsm[7]),
      .afi_wdata_7(afi_wdata_fsm[7]),
      .afi_rdata_en_full_7(afi_rdata_en_full_q[7]),
      
      .afi_addr(afi_addr_before_ainv),
      .afi_ld_n(afi_ld_n),
      .afi_rw_n(afi_rw_n),
      .afi_wdata_valid(afi_wdata_valid),
      .afi_wdata(afi_wdata_before_dinv),
      .afi_rdata_en_full(afi_rdata_en_full),
      
      .dequeue(dequeue),
      
      .queue_empty(queue_empty),
      
      .wdata_request_0(wdata_request[0]),
      .wdata_request_1(wdata_request[1]),
      .wdata_request_2(wdata_request[2]),
      .wdata_request_3(wdata_request[3]),
      .wdata_request_4(wdata_request[4]),
      .wdata_request_5(wdata_request[5]),
      .wdata_request_6(wdata_request[6]),
      .wdata_request_7(wdata_request[7]),
      
      .next_dequeue_mask(next_dequeue_mask),
      
      .afi_wdata_dinv(invert_data),
      .afi_ainv(invert_addr),
      .is_read_command(is_read_command),
      .is_write_command(is_write_command),
      .bank_violation(bank_violation)
   );
   
   // Pre-calculate whether the following cycle has any bank address violations.
   // This helps to achieve timing closure.
   // Banking violations occur when the lowest 3 bits of port B addresses equal
   // those of previously adjacent port A addresses).
   generate
      for (i = 0; i < NUM_OF_AVL_CHANNELS; i++)
      begin : bank_violation_gen
         always_ff @(posedge afi_clk or negedge afi_reset_n)
         begin
            if (!afi_reset_n)
               bank_violation[i] <= 1'b0;
            else begin
               if (i % 2 == 0)
                  bank_violation[i] <= 1'b0;
               else begin
                  if (dequeue)
                     bank_violation[i] <= (afi_addr_next_q[i][2:0] == afi_addr_next_q[i-1][2:0]) && (afi_ld_n_next_q[i-1] != '1);
                  else
                     bank_violation[i] <= (afi_addr_q[i][2:0] == afi_addr_q[i-1][2:0]) && !( (afi_ld_n_q[i-1] == '1) || !next_dequeue_mask[i-1]);
               end
            end
         end
      end
   endgenerate
   
   generate
      if (CTRL_DATA_INV_ENA) begin
         altera_emif_ctrl_qdr4_dinv_read_block #(
            .DATA_WIDTH (PORT_AFI_RDATA_WIDTH),
            .DINV_WIDTH (PORT_AFI_RDATA_DINV_WIDTH)
         ) dinv_read_block_inst (
            .data_in(afi_rdata),
            .data_out(afi_rdata_after_dinv),
            .dinv_in(afi_rdata_dinv)
         );
         
         altera_emif_ctrl_qdr4_dinv_write_block #(
            .DATA_WIDTH (PORT_AFI_WDATA_WIDTH),
            .DINV_WIDTH (PORT_AFI_WDATA_DINV_WIDTH)
         ) dinv_write_block_inst (
            .data_in(afi_wdata_before_dinv),
            .data_out(afi_wdata),
            .invert_data(invert_data),
            .dinv_out(afi_wdata_dinv)
         );
      end else begin
         assign afi_rdata_after_dinv = afi_rdata;
         assign afi_wdata = afi_wdata_before_dinv;
         assign afi_wdata_dinv = '0;
      end
   endgenerate
   
   generate
      if (CTRL_ADDR_INV_ENA) begin
         altera_emif_ctrl_qdr4_ainv_block #(
            .ADDR_WIDTH (PORT_AFI_ADDR_WIDTH),
            .AINV_WIDTH (PORT_AFI_AINV_WIDTH)
         ) ainv_block_inst (
            .addr_in(afi_addr_before_ainv),
            .ap_in('0),
            .invert_addr(invert_addr),
            .addr_out(afi_addr),
            .ap_out(afi_ap),
            .ainv_out(afi_ainv)
         );
      end else begin
         assign afi_addr = afi_addr_before_ainv;
         assign afi_ap = '0;
         assign afi_ainv = '0;
      end
   endgenerate
   
endmodule
