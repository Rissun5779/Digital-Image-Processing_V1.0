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


`timescale 1 ps / 1 ps

module altera_emif_io_hmc_ecc #
    ( parameter
        CFG_LOCAL_CMD_WIDTH                    = 2,
        CFG_LOCAL_ADDR_WIDTH                   = 35,
        CFG_LOCAL_SIZE_WIDTH                   = 8,
        CFG_LOCAL_ID_WIDTH                     = 13,
        CFG_LOCAL_PRI_WIDTH                    = 1,
        CFG_LOCAL_AP_WIDTH                     = 1,
        CFG_LOCAL_MC_WIDTH                     = 1,
        CFG_CMD_DATA_WIDTH                     = 61,
        CFG_CMD_INFO_WIDTH                     = 3,
        CFG_LOCAL_DATA_WIDTH                   = 81*8,
        CFG_LOCAL_BE_WIDTH                     = 9*8,
        CFG_LOCAL_DATA_INFO_WIDTH              = 3,
        CFG_LOCAL_DATA_PTR_WIDTH               = 6*2,
        CFG_ECC_DATA_WIDTH                     = 81*8,
        CFG_ECC_BE_WIDTH                       = 9*8,
        CFG_ECC_CODE_WIDTH                     = 8,
        CFG_ECC_MULTIPLE_INSTANCE              = 8, 
        
        CFG_ADDR_ENCODE_ENABLED                = 0,
        CFG_REGISTER_RDATA_PATH                = 0,
        CFG_REGISTER_WDATA_PATH                = 0,
        CFG_REGISTER_WDATA_PATH_NUM            = 0,
        
        CFG_WRBUFFER_ADDR_WIDTH                = 5,
        CFG_PORT_WIDTH_DRAM_DATA_WIDTH         = 8,
        CFG_PORT_WIDTH_LOCAL_DATA_WIDTH        = 8,
        CFG_PORT_WIDTH_ADDR_WIDTH              = 6,
        CFG_PORT_WIDTH_DATA_RATE               = 4,
        CFG_PORT_WIDTH_ECC_IN_PROTOCOL         = 1,
        CFG_PORT_WIDTH_WRPATH_PIPELINE_EN      = 1,
        CFG_PORT_WIDTH_ENABLE_ECC              = 1,
        CFG_PORT_WIDTH_ENABLE_DM               = 1,
        CFG_PORT_WIDTH_ENABLE_RMW              = 1,
        CFG_PORT_WIDTH_ENABLE_AUTO_CORR        = 1,
        CFG_PORT_WIDTH_ECC_CODE_OVERWRITE      = 1,
        CFG_PORT_WIDTH_GEN_SBE                 = 1,
        CFG_PORT_WIDTH_GEN_DBE                 = 1,
        CFG_PORT_WIDTH_ENABLE_INTR             = 1,
        CFG_PORT_WIDTH_MASK_SBE_INTR           = 1,
        CFG_PORT_WIDTH_MASK_DBE_INTR           = 1,
        CFG_PORT_WIDTH_MASK_CORR_DROPPED_INTR  = 1,
        CFG_PORT_WIDTH_MASK_HMI_INTR           = 1,
        CFG_PORT_WIDTH_CLR_INTR                = 1,
        CFG_PORT_WIDTH_CLR_MR_RDATA            = 1,
        
        STS_PORT_WIDTH_ECC_INTR                = 1,
        STS_PORT_WIDTH_SBE_ERROR               = 1,
        STS_PORT_WIDTH_DBE_ERROR               = 1,
        STS_PORT_WIDTH_CORR_DROPPED            = 1,
        STS_PORT_WIDTH_SBE_COUNT               = 4,
        STS_PORT_WIDTH_DBE_COUNT               = 4,
        STS_PORT_WIDTH_CORR_DROPPED_COUNT      = 4,
        STS_PORT_WIDTH_ERR_ADDR                = 35,
        STS_PORT_WIDTH_CORR_DROPPED_ADDR       = 35,
        STS_PORT_WIDTH_MR_DATA                 = 81*8,
        STS_PORT_WIDTH_MR_DATA_VALID           = 1
    )
    (
        ctl_clk,
        ctl_reset_n,
        
        cfg_dram_data_width,
        cfg_local_data_width,
        cfg_addr_width,
        cfg_data_rate, 
        cfg_ecc_in_protocol,
        cfg_wrpath_pipeline_en,
        cfg_enable_ecc,
        cfg_enable_dm,
        cfg_enable_rmw,
        cfg_enable_auto_corr,
        cfg_ecc_code_overwrite,
        cfg_gen_sbe,
        cfg_gen_dbe,
        cfg_enable_intr,
        cfg_mask_sbe_intr,
        cfg_mask_dbe_intr,
        cfg_mask_corr_dropped_intr,
        cfg_mask_hmi_intr,
        cfg_clr_intr,
        cfg_clr_mr_rdata,
        
        sts_ecc_intr,
        sts_sbe_error,
        sts_dbe_error,
        sts_corr_dropped,
        sts_sbe_count,
        sts_dbe_count,
        sts_corr_dropped_count,
        sts_err_addr,
        sts_corr_dropped_addr,
        sts_mr_rdata_0,
        sts_mr_rdata_1,
        sts_mr_rdata_valid,
        
        sts_corr_dropped_valid,
        sts_current_addr,
        decoder_output_err_addr,
        decoder_output_data_valid,
        decoder_output_sbe,
        decoder_output_dbe,
        decoder_output_data_dbe,
        decoder_output_addrerr,
        
        slave_cmd_ready,
        slave_cmd_data,
        slave_cmd_valid,
        slave_wr_data_ready,
        slave_wr_data_byte_enable,
        slave_wr_data,
        slave_wr_data_id,
        slave_wr_data_valid,
        slave_rd_data_ready,
        slave_rd_data,
        slave_rd_data_id,
        slave_rd_data_valid,
        slave_rd_data_error,
        
        master_cmd_ready,
        master_cmd_data,
        master_cmd_valid,
        master_cmd_data_combi,
        master_cmd_valid_combi,
        master_cmd_info,
        master_wr_data_ready,
        master_wr_data_byte_enable,
        master_wr_data,
        master_wr_data_id,
        master_wr_data_info,
        master_wr_data_ptr_in,
        master_wr_data_ptr_out,
        master_wr_data_valid,
        master_rd_data_ready,
        master_rd_data,
        master_rd_data_id,
        master_rd_data_info,
        master_rd_data_valid,
        master_rd_data_type,
        
        user_interrupt,
        hmi_interrupt,
        idle,
        push_to_error_address_fifo
    );

localparam LOG2_CFG_ECC_MULTIPLE_INSTANCE       = log2(CFG_ECC_MULTIPLE_INSTANCE);

localparam CFG_LOCAL_DATA_PER_WORD_WIDTH        = CFG_LOCAL_DATA_WIDTH / CFG_ECC_MULTIPLE_INSTANCE;
localparam CFG_LOCAL_BE_PER_WORD_WIDTH          = CFG_LOCAL_BE_WIDTH   / CFG_ECC_MULTIPLE_INSTANCE;
localparam CFG_ECC_DATA_PER_WORD_WIDTH          = CFG_ECC_DATA_WIDTH   / CFG_ECC_MULTIPLE_INSTANCE;
localparam CFG_ECC_BE_PER_WORD_WIDTH            = CFG_ECC_BE_WIDTH     / CFG_ECC_MULTIPLE_INSTANCE;

localparam CFG_ENCODER_ADDR_WIDTH               = CFG_LOCAL_ADDR_WIDTH + LOG2_CFG_ECC_MULTIPLE_INSTANCE;
localparam CFG_DECODER_ADDR_WIDTH               = CFG_LOCAL_ADDR_WIDTH + LOG2_CFG_ECC_MULTIPLE_INSTANCE;

localparam CFG_ENCODER_DATA_WIDTH               = 81; 
localparam CFG_DECODER_DATA_WIDTH               = 81; 

localparam PARTIAL_FIFO_DATA_WIDTH              = CFG_LOCAL_DATA_WIDTH + CFG_LOCAL_BE_WIDTH;
localparam PARTIAL_FIFO_ADDR_WIDTH              = CFG_WRBUFFER_ADDR_WIDTH + 1; 
localparam PARTIAL_FIFO_REGISTERED_OUTPUT       = 1;
localparam PARTIAL_FIFO_SHOWAHEAD               = 1;

localparam WR_ADDR_FIFO_DATA_WIDTH              = CFG_LOCAL_ADDR_WIDTH;
localparam WR_ADDR_FIFO_ADDR_WIDTH              = CFG_WRBUFFER_ADDR_WIDTH + 1; 
localparam WR_ADDR_FIFO_REGISTERED_OUTPUT       = 1;
localparam WR_ADDR_FIFO_SHOWAHEAD               = 1;

localparam PTR_FIFO_DATA_WIDTH                  = CFG_LOCAL_DATA_PTR_WIDTH;
localparam PTR_FIFO_ADDR_WIDTH                  = CFG_WRBUFFER_ADDR_WIDTH + 1; 
localparam PTR_FIFO_REGISTERED_OUTPUT           = 1;
localparam PTR_FIFO_SHOWAHEAD                   = 1;

localparam CMD_INFO_FIFO_DATA_WIDTH             = CFG_CMD_INFO_WIDTH - 1;
localparam CMD_INFO_FIFO_ADDR_WIDTH             = CFG_WRBUFFER_ADDR_WIDTH; 
localparam CMD_INFO_FIFO_REGISTERED_OUTPUT      = 1;
localparam CMD_INFO_FIFO_SHOWAHEAD              = 1;

localparam READ_FIFO_DATA_WIDTH                 = CFG_LOCAL_ADDR_WIDTH + CFG_LOCAL_SIZE_WIDTH;
localparam READ_FIFO_ADDR_WIDTH                 = 6 + 1; 
localparam READ_FIFO_REGISTERED_OUTPUT          = 1;
localparam READ_FIFO_SHOWAHEAD                  = 1;

localparam ERROR_FIFO_DATA_WIDTH                = CFG_LOCAL_ADDR_WIDTH + CFG_LOCAL_SIZE_WIDTH;
localparam ERROR_FIFO_ADDR_WIDTH                = 6;
localparam ERROR_FIFO_REGISTERED_OUTPUT         = 1;
localparam ERROR_FIFO_SHOWAHEAD                 = 1;

localparam CFG_PENDING_WRITE_DATA_WIDTH         = CFG_LOCAL_SIZE_WIDTH + 2;
localparam CFG_PENDING_ERROR_WRITE_DATA_WIDTH   = CFG_LOCAL_SIZE_WIDTH;

localparam NORMAL_WRITE_DATA                    = 3'b000;
localparam NORMAL_DUMMY_WRITE_DATA              = 3'b010;
localparam NORMAL_FULL_WRITE_DATA               = 3'b001;
localparam NORMAL_PARTIAL_WRITE_DATA            = 3'b011;
localparam MERGED_WRITE_DATA                    = 3'b100;
localparam MERGED_DUMMY_WRITE_DATA              = 3'b110;
localparam MERGED_FULL_WRITE_DATA               = 3'b101;
localparam MERGED_PARTIAL_WRITE_DATA            = 3'b111;

localparam NORMAL_READ_DATA                     = 3'b000;
localparam NORMAL_DUMMY_READ_DATA               = 3'b010;
localparam NORMAL_FULL_READ_DATA                = 3'b001;
localparam NORMAL_PARTIAL_READ_DATA             = 3'b011;

localparam INFO_DUMMY_WRITE_DATA                = 2'b10;
localparam INFO_FULL_WRITE_DATA                 = 2'b01;
localparam INFO_PARTIAL_WRITE_DATA              = 2'b11;

localparam CFG_INPUT_AST                        = 1'b0;
localparam CFG_INPUT_AMM                        = 1'b1;

localparam CFG_PENDING_DATA_FIFO_WIDTH          = 1;
localparam CFG_PENDING_DATA_FIFO_DEPTH          = 2 ** CFG_PENDING_DATA_FIFO_WIDTH;


input                                            ctl_clk;
input                                            ctl_reset_n;

input  [CFG_PORT_WIDTH_DRAM_DATA_WIDTH        - 1 : 0] cfg_dram_data_width;
input  [CFG_PORT_WIDTH_LOCAL_DATA_WIDTH       - 1 : 0] cfg_local_data_width;
input  [CFG_PORT_WIDTH_ADDR_WIDTH             - 1 : 0] cfg_addr_width;
input  [CFG_PORT_WIDTH_DATA_RATE              - 1 : 0] cfg_data_rate;
input  [CFG_PORT_WIDTH_ECC_IN_PROTOCOL        - 1 : 0] cfg_ecc_in_protocol;
input  [CFG_PORT_WIDTH_WRPATH_PIPELINE_EN     - 1 : 0] cfg_wrpath_pipeline_en;
input  [CFG_PORT_WIDTH_ENABLE_ECC             - 1 : 0] cfg_enable_ecc;
input  [CFG_PORT_WIDTH_ENABLE_DM              - 1 : 0] cfg_enable_dm;
input  [CFG_PORT_WIDTH_ENABLE_RMW             - 1 : 0] cfg_enable_rmw;
input  [CFG_PORT_WIDTH_ENABLE_AUTO_CORR       - 1 : 0] cfg_enable_auto_corr;
input  [CFG_PORT_WIDTH_ECC_CODE_OVERWRITE     - 1 : 0] cfg_ecc_code_overwrite;
input  [CFG_PORT_WIDTH_GEN_SBE                - 1 : 0] cfg_gen_sbe;
input  [CFG_PORT_WIDTH_GEN_DBE                - 1 : 0] cfg_gen_dbe;
input  [CFG_PORT_WIDTH_ENABLE_INTR            - 1 : 0] cfg_enable_intr;
input  [CFG_PORT_WIDTH_MASK_SBE_INTR          - 1 : 0] cfg_mask_sbe_intr;
input  [CFG_PORT_WIDTH_MASK_DBE_INTR          - 1 : 0] cfg_mask_dbe_intr;
input  [CFG_PORT_WIDTH_MASK_CORR_DROPPED_INTR - 1 : 0] cfg_mask_corr_dropped_intr;
input  [CFG_PORT_WIDTH_MASK_HMI_INTR          - 1 : 0] cfg_mask_hmi_intr;
input  [CFG_PORT_WIDTH_CLR_INTR               - 1 : 0] cfg_clr_intr;
input  [CFG_PORT_WIDTH_CLR_MR_RDATA           - 1 : 0] cfg_clr_mr_rdata;

output [STS_PORT_WIDTH_ECC_INTR               - 1 : 0] sts_ecc_intr;
output [STS_PORT_WIDTH_SBE_ERROR              - 1 : 0] sts_sbe_error;
output [STS_PORT_WIDTH_DBE_ERROR              - 1 : 0] sts_dbe_error;
output [STS_PORT_WIDTH_CORR_DROPPED           - 1 : 0] sts_corr_dropped;
output [STS_PORT_WIDTH_SBE_COUNT              - 1 : 0] sts_sbe_count;
output [STS_PORT_WIDTH_DBE_COUNT              - 1 : 0] sts_dbe_count;
output [STS_PORT_WIDTH_CORR_DROPPED_COUNT     - 1 : 0] sts_corr_dropped_count;
output [STS_PORT_WIDTH_ERR_ADDR               - 1 : 0] sts_err_addr;
output [STS_PORT_WIDTH_CORR_DROPPED_ADDR      - 1 : 0] sts_corr_dropped_addr;
output [STS_PORT_WIDTH_MR_DATA                - 1 : 0] sts_mr_rdata_0;
output [STS_PORT_WIDTH_MR_DATA                - 1 : 0] sts_mr_rdata_1;
output [STS_PORT_WIDTH_MR_DATA_VALID          - 1 : 0] sts_mr_rdata_valid;

output                                                              sts_corr_dropped_valid;
output [CFG_LOCAL_ADDR_WIDTH                               - 1 : 0] sts_current_addr;
output [CFG_DECODER_ADDR_WIDTH * CFG_ECC_MULTIPLE_INSTANCE - 1 : 0] decoder_output_err_addr;
output [CFG_ECC_MULTIPLE_INSTANCE                          - 1 : 0] decoder_output_data_valid;
output [CFG_ECC_MULTIPLE_INSTANCE                          - 1 : 0] decoder_output_sbe;
output [CFG_ECC_MULTIPLE_INSTANCE                          - 1 : 0] decoder_output_dbe;
output [CFG_ECC_MULTIPLE_INSTANCE                          - 1 : 0] decoder_output_data_dbe;
output [CFG_ECC_MULTIPLE_INSTANCE                          - 1 : 0] decoder_output_addrerr;


output                                           slave_cmd_ready;
input  [CFG_CMD_DATA_WIDTH              - 1 : 0] slave_cmd_data;
input                                            slave_cmd_valid;
output                                           slave_wr_data_ready;
input  [CFG_LOCAL_BE_WIDTH              - 1 : 0] slave_wr_data_byte_enable;
input  [CFG_LOCAL_DATA_WIDTH            - 1 : 0] slave_wr_data;
input  [CFG_LOCAL_ID_WIDTH              - 1 : 0] slave_wr_data_id;
input                                            slave_wr_data_valid;
input                                            slave_rd_data_ready;
output [CFG_LOCAL_DATA_WIDTH            - 1 : 0] slave_rd_data;
output [CFG_LOCAL_ID_WIDTH              - 1 : 0] slave_rd_data_id;
output                                           slave_rd_data_valid;
output                                           slave_rd_data_error;

input                                            master_cmd_ready;
output [CFG_CMD_DATA_WIDTH              - 1 : 0] master_cmd_data;
output                                           master_cmd_valid;
output [CFG_CMD_DATA_WIDTH              - 1 : 0] master_cmd_data_combi;
output                                           master_cmd_valid_combi;
input  [CFG_CMD_INFO_WIDTH              - 1 : 0] master_cmd_info;
input                                            master_wr_data_ready;
output [CFG_ECC_BE_WIDTH                - 1 : 0] master_wr_data_byte_enable;
output [CFG_ECC_DATA_WIDTH              - 1 : 0] master_wr_data;
output [CFG_LOCAL_ID_WIDTH              - 1 : 0] master_wr_data_id;
output [CFG_LOCAL_DATA_INFO_WIDTH       - 1 : 0] master_wr_data_info;
input  [CFG_LOCAL_DATA_PTR_WIDTH        - 1 : 0] master_wr_data_ptr_in;
output [CFG_LOCAL_DATA_PTR_WIDTH        - 1 : 0] master_wr_data_ptr_out;
output                                           master_wr_data_valid;
output                                           master_rd_data_ready;
input  [CFG_ECC_DATA_WIDTH              - 1 : 0] master_rd_data;
input  [CFG_LOCAL_ID_WIDTH              - 1 : 0] master_rd_data_id;
input  [CFG_LOCAL_DATA_INFO_WIDTH       - 1 : 0] master_rd_data_info;
input                                            master_rd_data_valid;
input                                            master_rd_data_type;

output                                           user_interrupt;
input                                            hmi_interrupt;
output                                           idle;
output                                           push_to_error_address_fifo;



    reg                                                           slave_cmd_ready;
    reg                                                           slave_wr_data_ready;
    reg  [CFG_LOCAL_DATA_WIDTH                           - 1 : 0] slave_rd_data;
    reg  [CFG_LOCAL_ID_WIDTH                             - 1 : 0] slave_rd_data_id;
    reg                                                           slave_rd_data_valid;
    reg                                                           slave_rd_data_error;
    
    reg  [CFG_CMD_DATA_WIDTH                             - 1 : 0] master_cmd_data;
    reg                                                           master_cmd_valid;
    reg  [CFG_CMD_DATA_WIDTH                             - 1 : 0] master_cmd_data_combi;
    reg                                                           master_cmd_valid_combi;
    reg  [CFG_ECC_BE_WIDTH                               - 1 : 0] master_wr_data_byte_enable;
    reg  [CFG_ECC_BE_WIDTH                               - 1 : 0] master_wr_data_byte_enable_ori;
    reg  [CFG_ECC_DATA_WIDTH                             - 1 : 0] master_wr_data;
    reg  [CFG_LOCAL_ADDR_WIDTH                           - 1 : 0] master_wr_addr;
    reg  [CFG_LOCAL_ADDR_WIDTH                           - 1 : 0] master_wr_addr_r;
    reg  [CFG_LOCAL_ID_WIDTH                             - 1 : 0] master_wr_data_id;
    wire [CFG_LOCAL_DATA_INFO_WIDTH                      - 1 : 0] mux_master_wr_data_info;
    reg  [CFG_LOCAL_DATA_INFO_WIDTH                      - 1 : 0] master_wr_data_info;
    reg  [CFG_LOCAL_DATA_INFO_WIDTH                      - 1 : 0] master_wr_data_info_r1;
    reg  [CFG_LOCAL_DATA_INFO_WIDTH                      - 1 : 0] master_wr_data_info_r2;
    reg  [CFG_LOCAL_DATA_INFO_WIDTH                      - 1 : 0] master_wr_data_info_r3;
    reg  [CFG_LOCAL_DATA_INFO_WIDTH                      - 1 : 0] master_wr_data_info_r4;
    reg  [CFG_LOCAL_DATA_INFO_WIDTH                      - 1 : 0] master_wr_data_info_r5;
    reg  [CFG_LOCAL_DATA_INFO_WIDTH                      - 1 : 0] master_wr_data_info_r6;
    reg  [CFG_LOCAL_DATA_INFO_WIDTH                      - 1 : 0] master_wr_data_info_r7;
    reg  [CFG_LOCAL_DATA_INFO_WIDTH                      - 1 : 0] master_wr_data_info_r8;
    reg  [CFG_LOCAL_DATA_PTR_WIDTH                       - 1 : 0] master_wr_data_ptr_out;
    reg                                                           master_wr_data_valid;
    reg                                                           master_rd_data_ready;
    
    reg                                                           user_interrupt;
    wire                                                          idle;
    
    reg  [STS_PORT_WIDTH_ECC_INTR                        - 1 : 0] sts_ecc_intr;
    reg  [STS_PORT_WIDTH_SBE_ERROR                       - 1 : 0] sts_sbe_error;
    reg  [STS_PORT_WIDTH_DBE_ERROR                       - 1 : 0] sts_dbe_error;
    reg  [STS_PORT_WIDTH_CORR_DROPPED                    - 1 : 0] sts_corr_dropped;
    reg  [STS_PORT_WIDTH_SBE_COUNT                       - 1 : 0] sts_sbe_count;
    reg  [STS_PORT_WIDTH_DBE_COUNT                       - 1 : 0] sts_dbe_count;
    reg  [STS_PORT_WIDTH_CORR_DROPPED_COUNT              - 1 : 0] sts_corr_dropped_count;
    reg  [STS_PORT_WIDTH_ERR_ADDR                        - 1 : 0] sts_err_addr;
    reg  [STS_PORT_WIDTH_CORR_DROPPED_ADDR               - 1 : 0] sts_corr_dropped_addr;
    reg  [STS_PORT_WIDTH_MR_DATA                         - 1 : 0] sts_mr_rdata_0;
    reg  [STS_PORT_WIDTH_MR_DATA                         - 1 : 0] sts_mr_rdata_1;
    reg  [STS_PORT_WIDTH_MR_DATA_VALID                   - 1 : 0] sts_mr_rdata_valid;
    wire [CFG_LOCAL_ADDR_WIDTH                           - 1 : 0] sts_current_addr;
    
    reg                                                           internal_master_cmd_ready;
    
    wire                                                          int_master_cmd_ready;
    wire [CFG_CMD_INFO_WIDTH                             - 1 : 0] int_master_cmd_info;
    reg  [CFG_CMD_INFO_WIDTH                             - 1 : 0] int_master_cmd_info_r1;
    wire                                                          int_master_wr_data_ready;
    wire [CFG_LOCAL_DATA_PTR_WIDTH                       - 1 : 0] int_master_wr_data_ptr_in;
    wire [CFG_ECC_DATA_WIDTH                             - 1 : 0] int_master_rd_data;
    wire [CFG_LOCAL_ID_WIDTH                             - 1 : 0] int_master_rd_data_id;
    wire [CFG_LOCAL_DATA_INFO_WIDTH                      - 1 : 0] int_master_rd_data_info;
    wire                                                          int_master_rd_data_valid;
    reg                                                           int_master_rd_data_valid_r;
    
    wire                                                          internal_master_rd_data_ready;
    reg  [CFG_ECC_DATA_WIDTH                             - 1 : 0] internal_master_rd_data;
    reg  [CFG_LOCAL_ID_WIDTH                             - 1 : 0] internal_master_rd_data_id;
    reg  [CFG_LOCAL_DATA_INFO_WIDTH                      - 1 : 0] internal_master_rd_data_info;
    reg                                                           internal_master_rd_data_valid;
    reg                                                           internal_master_rd_data_type;
    
    wire [CFG_CMD_DATA_WIDTH                             - 1 : 0] int_slave_cmd_data;
    wire                                                          int_slave_cmd_valid;
    wire [CFG_LOCAL_BE_WIDTH                             - 1 : 0] int_slave_wr_data_byte_enable;
    wire [CFG_LOCAL_DATA_WIDTH                           - 1 : 0] int_slave_wr_data;
    wire [CFG_LOCAL_ID_WIDTH                             - 1 : 0] int_slave_wr_data_id;
    wire                                                          int_slave_wr_data_valid;
    wire                                                          int_slave_rd_data_ready;
    
    wire                                                          int_slave_cmd_wr;
    wire                                                          int_slave_cmd_rd;
    wire [CFG_LOCAL_ADDR_WIDTH                           - 1 : 0] int_slave_cmd_addr;
    wire [CFG_LOCAL_SIZE_WIDTH                           - 1 : 0] int_slave_cmd_size;
    wire [CFG_LOCAL_ID_WIDTH                             - 1 : 0] int_slave_cmd_id;
    wire                                                          int_slave_cmd_priority;
    wire                                                          int_slave_cmd_auto_precharge;
    wire                                                          int_slave_cmd_multicast;
    
    reg  [CFG_LOCAL_BE_WIDTH                             - 1 : 0] int_slave_wr_data_byte_enable_ones;
    reg  [CFG_LOCAL_BE_WIDTH                             - 1 : 0] int_slave_wr_data_byte_enable_zeros;
    
    wire [CFG_LOCAL_SIZE_WIDTH                           - 1 : 0] amm_cmd_size;
    wire                                                          amm_cmd_wr;
    wire                                                          amm_cmd_rd;
    wire                                                          ast_cmd_ready;
    wire                                                          ast_wr_data_ready;
    
    wire                                                          amm_ready;
    wire                                                          ast_cmd_valid;
    wire                                                          ast_wr_data_valid;
    
    reg                                                           int_partial_write_detected;
    reg                                                           int_partial_write_be_all_zeros;
    reg                                                           int_partial_write_be_all_ones;
    
    reg  [CFG_ECC_MULTIPLE_INSTANCE                      - 1 : 0] partial_write_detected;
    reg  [CFG_ECC_MULTIPLE_INSTANCE                      - 1 : 0] partial_write_be_all_zeros;
    reg  [CFG_ECC_MULTIPLE_INSTANCE                      - 1 : 0] partial_write_be_all_ones;
    reg  [CFG_LOCAL_DATA_WIDTH                           - 1 : 0] partial_write_data;
    reg  [CFG_LOCAL_BE_WIDTH                             - 1 : 0] partial_write_data_byte_enable;
    reg  [CFG_ECC_CODE_WIDTH * CFG_ECC_MULTIPLE_INSTANCE - 1 : 0] partial_write_ecc_code;
    reg  [CFG_ECC_MULTIPLE_INSTANCE                      - 1 : 0] partial_write_ecc_code_overwrite;
    
    reg  [CFG_LOCAL_ADDR_WIDTH                           - 1 : 0] partial_write_addr;
    
    reg                                                           partial_read_data_returned_combi_early;
    reg                                                           empty_read_data_returned_combi_early;
    reg                                                           normal_read_data_returned_combi_early;
    
    reg                                                           partial_read_data_returned_combi;
    reg                                                           empty_read_data_returned_combi;
    reg                                                           normal_read_data_returned_combi;
    
    reg                                                           partial_read_data_returned;
    reg                                                           empty_read_data_returned;
    reg                                                           normal_read_data_returned;
    
    reg                                                           prolong_write_back_data_fifo_empty_combi;
    
    reg  [CFG_LOCAL_DATA_WIDTH                           - 1 : 0] merge_write_data;
    
    reg  [CFG_LOCAL_DATA_WIDTH                           - 1 : 0] encoder_input_data;
    reg  [CFG_LOCAL_ADDR_WIDTH                           - 1 : 0] encoder_input_addr;
    reg  [CFG_ECC_CODE_WIDTH * CFG_ECC_MULTIPLE_INSTANCE - 1 : 0] encoder_input_ecc_code;
    reg  [CFG_ECC_MULTIPLE_INSTANCE                      - 1 : 0] encoder_input_ecc_code_overwrite;
    reg  [CFG_LOCAL_DATA_WIDTH                           - 1 : 0] encoder_input_data_r;
    reg  [CFG_LOCAL_ADDR_WIDTH                           - 1 : 0] encoder_input_addr_r;
    reg  [CFG_ECC_CODE_WIDTH * CFG_ECC_MULTIPLE_INSTANCE - 1 : 0] encoder_input_ecc_code_r;
    reg  [CFG_ECC_MULTIPLE_INSTANCE                      - 1 : 0] encoder_input_ecc_code_overwrite_r;
    reg  [CFG_ECC_DATA_WIDTH                             - 1 : 0] decoder_input_data;
    reg  [CFG_LOCAL_ADDR_WIDTH                           - 1 : 0] decoder_input_addr;
    reg                                                           decoder_input_data_valid;
    
    reg  [CFG_ECC_BE_WIDTH                               - 1 : 0] encoder_output_data_byte_enable_combi;
    reg  [CFG_LOCAL_ID_WIDTH                             - 1 : 0] encoder_output_data_id_combi;
    reg  [CFG_LOCAL_DATA_INFO_WIDTH                      - 1 : 0] encoder_output_data_info_combi;
    reg  [CFG_LOCAL_DATA_PTR_WIDTH                       - 1 : 0] encoder_output_data_ptr_combi;
    reg                                                           encoder_output_data_valid_combi;
    
    reg  [CFG_ECC_DATA_WIDTH                             - 1 : 0] encoder_output_data;
    reg  [CFG_LOCAL_ADDR_WIDTH                           - 1 : 0] encoder_output_addr;
    reg  [CFG_ECC_BE_WIDTH                               - 1 : 0] encoder_output_data_byte_enable;
    reg  [CFG_LOCAL_ID_WIDTH                             - 1 : 0] encoder_output_data_id;
    reg  [CFG_LOCAL_DATA_INFO_WIDTH                      - 1 : 0] encoder_output_data_info;
    reg  [CFG_LOCAL_DATA_PTR_WIDTH                       - 1 : 0] encoder_output_data_ptr;
    reg                                                           encoder_output_data_valid;
    
    reg                                                           pending_data_not_empty;
    reg  [CFG_PENDING_DATA_FIFO_DEPTH                    - 1 : 0] pending_data_valid_update;
    reg  [CFG_PENDING_DATA_FIFO_WIDTH                    - 1 : 0] pending_data_valid_wr_ptr_combi;
    reg  [CFG_PENDING_DATA_FIFO_WIDTH                    - 1 : 0] pending_data_valid_rd_ptr_combi;
    reg  [CFG_PENDING_DATA_FIFO_WIDTH                    - 1 : 0] pending_data_valid_wr_ptr;
    reg  [CFG_PENDING_DATA_FIFO_WIDTH                    - 1 : 0] pending_data_valid_rd_ptr;
    reg  [CFG_PENDING_DATA_FIFO_DEPTH                    - 1 : 0] pending_data_valid;
    reg  [CFG_ECC_DATA_WIDTH                             - 1 : 0] pending_data                 [CFG_PENDING_DATA_FIFO_DEPTH - 1 : 0];
    reg  [CFG_LOCAL_ADDR_WIDTH                           - 1 : 0] pending_addr                 [CFG_PENDING_DATA_FIFO_DEPTH - 1 : 0];
    reg  [CFG_ECC_BE_WIDTH                               - 1 : 0] pending_data_byte_enable     [CFG_PENDING_DATA_FIFO_DEPTH - 1 : 0];
    reg  [CFG_ECC_BE_WIDTH                               - 1 : 0] pending_data_byte_enable_ori [CFG_PENDING_DATA_FIFO_DEPTH - 1 : 0];
    reg  [CFG_LOCAL_ID_WIDTH                             - 1 : 0] pending_data_id              [CFG_PENDING_DATA_FIFO_DEPTH - 1 : 0];
    reg  [CFG_LOCAL_DATA_INFO_WIDTH                      - 1 : 0] pending_data_info            [CFG_PENDING_DATA_FIFO_DEPTH - 1 : 0];
    reg  [CFG_LOCAL_DATA_PTR_WIDTH                       - 1 : 0] pending_data_ptr             [CFG_PENDING_DATA_FIFO_DEPTH - 1 : 0];
    
    reg                                                           load_pending_data;
    
    reg  [CFG_LOCAL_DATA_INFO_WIDTH                      - 1 : 0] int_wr_data_info;
    reg  [CFG_LOCAL_DATA_INFO_WIDTH                      - 1 : 0] wr_data_info;
    reg  [CFG_LOCAL_DATA_INFO_WIDTH                      - 1 : 0] wr_data_info_r;
    
    reg  [CFG_LOCAL_DATA_PTR_WIDTH                       - 1 : 0] int_wr_data_ptr;
    reg  [CFG_LOCAL_DATA_PTR_WIDTH                       - 1 : 0] wr_data_ptr;
    
    wire [CFG_ENCODER_DATA_WIDTH                         - 1 : 0] int_encoder_input_data_combi               [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    wire [CFG_ENCODER_ADDR_WIDTH                         - 1 : 0] int_encoder_input_addr_combi               [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    wire [CFG_ECC_CODE_WIDTH                             - 1 : 0] int_encoder_input_ecc_code_combi           [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    wire                                                          int_encoder_input_ecc_code_overwrite_combi [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    reg  [CFG_ECC_BE_WIDTH                               - 1 : 0] int_encoder_output_data_byte_enable_combi;
    reg  [CFG_ENCODER_DATA_WIDTH                         - 1 : 0] int_encoder_input_data                     [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    reg  [CFG_ENCODER_ADDR_WIDTH                         - 1 : 0] int_encoder_input_addr                     [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    reg  [CFG_ECC_CODE_WIDTH                             - 1 : 0] int_encoder_input_ecc_code                 [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    reg                                                           int_encoder_input_ecc_code_overwrite       [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    wire [CFG_ENCODER_DATA_WIDTH                         - 1 : 0] int_encoder_output_data                    [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    reg  [CFG_ECC_BE_WIDTH                               - 1 : 0] int_encoder_output_data_byte_enable;
    
    wire [CFG_DECODER_DATA_WIDTH                         - 1 : 0] int_decoder_input_data                     [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    wire [CFG_DECODER_ADDR_WIDTH                         - 1 : 0] int_decoder_input_addr                     [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    wire                                                          int_decoder_input_data_valid               [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    wire [CFG_DECODER_DATA_WIDTH                         - 1 : 0] int_decoder_output_data                    [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    wire                                                          int_decoder_output_data_valid              [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    wire [CFG_ECC_CODE_WIDTH                             - 1 : 0] int_decoder_output_ecc_code                [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    wire                                                          int_decoder_output_err_corrected           [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    wire                                                          int_decoder_output_err_detected            [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    wire                                                          int_decoder_output_err_fatal               [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    wire                                                          int_decoder_output_err_sbe                 [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    wire                                                          int_decoder_output_err_addr_detected       [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    wire [CFG_DECODER_ADDR_WIDTH                         - 1 : 0] int_decoder_output_err_addr                [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    reg                                                           int_decoder_output_sbe                     [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    reg                                                           int_decoder_output_dbe                     [CFG_ECC_MULTIPLE_INSTANCE - 1 : 0];
    
    reg  [CFG_DECODER_ADDR_WIDTH *CFG_ECC_MULTIPLE_INSTANCE - 1 : 0] decoder_output_err_addr;
    
    wire [CFG_LOCAL_DATA_WIDTH                           - 1 : 0] decoder_output_data_combi;
    wire [CFG_ECC_MULTIPLE_INSTANCE                      - 1 : 0] decoder_output_data_valid_combi;
    wire [CFG_ECC_CODE_WIDTH * CFG_ECC_MULTIPLE_INSTANCE - 1 : 0] decoder_output_ecc_code_combi;
    reg  [CFG_LOCAL_ID_WIDTH                             - 1 : 0] decoder_output_data_id_combi;
    reg  [CFG_ECC_MULTIPLE_INSTANCE                      - 1 : 0] decoder_output_sbe_combi;
    reg  [CFG_ECC_MULTIPLE_INSTANCE                      - 1 : 0] decoder_output_dbe_combi;
    reg  [CFG_ECC_MULTIPLE_INSTANCE                      - 1 : 0] decoder_output_data_dbe_combi;
    reg  [CFG_ECC_MULTIPLE_INSTANCE                      - 1 : 0] decoder_output_data_dbe;
    reg  [CFG_ECC_MULTIPLE_INSTANCE                      - 1 : 0] decoder_output_addrerr_combi;
    reg  [CFG_ECC_MULTIPLE_INSTANCE                      - 1 : 0] decoder_output_addrerr; 

    reg  [CFG_ECC_MULTIPLE_INSTANCE                      - 1 : 0] decoder_output_data_valid_combi_r;
    reg  [CFG_ECC_MULTIPLE_INSTANCE                      - 1 : 0] decoder_output_sbe_combi_r;
    reg  [CFG_ECC_MULTIPLE_INSTANCE                      - 1 : 0] decoder_output_dbe_combi_r;
    
    reg  [CFG_LOCAL_DATA_WIDTH                           - 1 : 0] decoder_output_data;
    reg  [CFG_LOCAL_ADDR_WIDTH                           - 1 : 0] decoder_output_addr;
    reg  [CFG_ECC_MULTIPLE_INSTANCE                      - 1 : 0] decoder_output_data_valid;
    reg  [CFG_ECC_CODE_WIDTH * CFG_ECC_MULTIPLE_INSTANCE - 1 : 0] decoder_output_ecc_code;
    reg  [CFG_LOCAL_ID_WIDTH                             - 1 : 0] decoder_output_data_id;
    reg  [CFG_ECC_MULTIPLE_INSTANCE                      - 1 : 0] decoder_output_sbe;
    reg  [CFG_ECC_MULTIPLE_INSTANCE                      - 1 : 0] decoder_output_dbe;
    
    wire                                                          partial_wdata_fifo_wr;
    wire [PARTIAL_FIFO_DATA_WIDTH                        - 1 : 0] partial_wdata_fifo_wr_data;
    wire                                                          partial_wdata_fifo_rd;
    wire [PARTIAL_FIFO_DATA_WIDTH                        - 1 : 0] partial_wdata_fifo_rd_data;
    wire                                                          partial_wdata_fifo_rd_data_valid;
    wire                                                          partial_wdata_fifo_empty;
    wire                                                          partial_wdata_fifo_full;
    
    wire                                                          initial_wr_addr_fifo_wr;
    wire [WR_ADDR_FIFO_DATA_WIDTH                        - 1 : 0] initial_wr_addr_fifo_wr_data;
    wire                                                          initial_wr_addr_fifo_rd;
    wire [WR_ADDR_FIFO_DATA_WIDTH                        - 1 : 0] initial_wr_addr_fifo_rd_data;
    wire                                                          initial_wr_addr_fifo_rd_data_valid;
    wire                                                          initial_wr_addr_fifo_empty;
    wire                                                          initial_wr_addr_fifo_full;
    
    wire                                                          wr_addr_fifo_wr;
    wire [WR_ADDR_FIFO_DATA_WIDTH                        - 1 : 0] wr_addr_fifo_wr_data;
    wire                                                          wr_addr_fifo_rd;
    wire [WR_ADDR_FIFO_DATA_WIDTH                        - 1 : 0] wr_addr_fifo_rd_data;
    wire                                                          wr_addr_fifo_rd_data_valid;
    wire                                                          wr_addr_fifo_empty;
    wire                                                          wr_addr_fifo_full;
    
    wire                                                          initial_pointer_fifo_wr;
    wire [PTR_FIFO_DATA_WIDTH + 2                        - 1 : 0] initial_pointer_fifo_wr_data;
    wire                                                          initial_pointer_fifo_rd;
    wire [PTR_FIFO_DATA_WIDTH + 2                        - 1 : 0] initial_pointer_fifo_rd_data;
    wire                                                          initial_pointer_fifo_rd_data_valid;
    wire                                                          initial_pointer_fifo_empty;
    wire                                                          initial_pointer_fifo_full;
    
    wire                                                          mux_push_to_initial_pointer_fifo;
    reg                                                           push_to_initial_pointer_fifo;
    reg                                                           push_to_initial_pointer_fifo_r1;
    reg                                                           push_to_initial_pointer_fifo_r2;
    reg                                                           push_to_initial_pointer_fifo_r3;
    reg                                                           push_to_initial_pointer_fifo_r4;
    reg                                                           push_to_initial_pointer_fifo_r5;
    reg                                                           push_to_initial_pointer_fifo_r6;
    reg                                                           push_to_initial_pointer_fifo_r7;
    
    reg  [PTR_FIFO_DATA_WIDTH                            - 1 : 0] int_pointer_fifo_rd_data;
    reg  [WR_ADDR_FIFO_DATA_WIDTH                        - 1 : 0] int_wr_addr_fifo_rd_data;
    
    wire                                                          pointer_fifo_wr;
    wire [PTR_FIFO_DATA_WIDTH                            - 1 : 0] pointer_fifo_wr_data;
    wire                                                          pointer_fifo_rd;
    wire [PTR_FIFO_DATA_WIDTH                            - 1 : 0] pointer_fifo_rd_data;
    wire                                                          pointer_fifo_rd_data_valid;
    wire                                                          pointer_fifo_empty;
    wire                                                          pointer_fifo_full;
    
    wire                                                          cmd_info_fifo_wr;
    wire [CMD_INFO_FIFO_DATA_WIDTH                       - 1 : 0] cmd_info_fifo_wr_data;
    wire                                                          cmd_info_fifo_rd;
    wire [CMD_INFO_FIFO_DATA_WIDTH                       - 1 : 0] cmd_info_fifo_rd_data;
    wire                                                          cmd_info_fifo_rd_data_valid;
    wire                                                          cmd_info_fifo_empty;
    wire                                                          cmd_info_fifo_full;
    
    wire                                                          read_address_fifo_wr;
    wire [READ_FIFO_DATA_WIDTH                           - 1 : 0] read_address_fifo_wr_data;
    wire                                                          read_address_fifo_rd;
    wire [READ_FIFO_DATA_WIDTH                           - 1 : 0] read_address_fifo_rd_data;
    wire                                                          read_address_fifo_rd_data_valid;
    wire                                                          read_address_fifo_empty;
    wire                                                          read_address_fifo_full;
    
    wire                                                          error_address_fifo_wr;
    wire [READ_FIFO_DATA_WIDTH                           - 1 : 0] error_address_fifo_wr_data;
    wire                                                          error_address_fifo_rd;
    wire [READ_FIFO_DATA_WIDTH                           - 1 : 0] error_address_fifo_rd_data;
    wire                                                          error_address_fifo_rd_data_valid;
    wire                                                          error_address_fifo_empty;
    wire                                                          error_address_fifo_full;
    
    wire [CFG_LOCAL_ADDR_WIDTH                           - 1 : 0] read_address_fifo_addr;
    wire [CFG_LOCAL_SIZE_WIDTH                           - 1 : 0] read_address_fifo_size;
    
    wire [CFG_LOCAL_ADDR_WIDTH                           - 1 : 0] error_address_fifo_addr;
    wire [CFG_LOCAL_SIZE_WIDTH                           - 1 : 0] error_address_fifo_size;
    
    reg  [CFG_LOCAL_ADDR_WIDTH                           - 1 : 0] current_addr;
    reg  [CFG_LOCAL_ADDR_WIDTH                           - 1 : 0] int_current_addr;
    reg  [CFG_LOCAL_ADDR_WIDTH                           - 1 : 0] int_current_addr_overflow;
    
    reg  [CFG_LOCAL_ADDR_WIDTH                           - 1 : 0] error_cmd_addr;
    reg  [35                                             - 1 : 0] error_cmd_addr_padded;
    reg  [CFG_LOCAL_SIZE_WIDTH                           - 1 : 0] error_cmd_size;
    reg  [8                                              - 1 : 0] error_cmd_size_padded;
    reg  [CFG_LOCAL_SIZE_WIDTH                           - 1 : 0] error_cmd_size_decrement;
    reg                                                           error_cmd_valid;
    
    reg  [CFG_LOCAL_ADDR_WIDTH                           - 1 : 0] error_wr_addr;
    
    reg                                                           error_wr_data_valid;
    
    reg  [CFG_CMD_DATA_WIDTH                             - 1 : 0] int_cmd_data;
    reg                                                           int_cmd_valid;
    reg  [CFG_CMD_DATA_WIDTH                             - 1 : 0] prev_int_cmd_data;
    reg                                                           prev_int_cmd_valid;
    
    reg  [CFG_CMD_DATA_WIDTH                             - 1 : 0] int_master_cmd_data;
    reg                                                           int_master_cmd_valid;
    reg  [CFG_CMD_DATA_WIDTH                             - 1 : 0] int_master_cmd_data_combi;
    reg                                                           int_master_cmd_valid_combi;
    
    reg  [CFG_ECC_BE_WIDTH                               - 1 : 0] int_master_wr_data_byte_enable;
    reg  [CFG_ECC_BE_WIDTH                               - 1 : 0] int_master_wr_data_byte_enable_ori;
    reg  [CFG_ECC_DATA_WIDTH                             - 1 : 0] int_master_wr_data;
    reg  [CFG_LOCAL_ADDR_WIDTH                           - 1 : 0] int_master_wr_addr;
    reg  [CFG_LOCAL_ID_WIDTH                             - 1 : 0] int_master_wr_data_id;
    reg  [CFG_LOCAL_DATA_INFO_WIDTH                      - 1 : 0] int_master_wr_data_info;
    reg  [CFG_LOCAL_DATA_PTR_WIDTH                       - 1 : 0] int_master_wr_data_ptr_out;
    reg                                                           int_master_wr_data_valid;
    
    reg                                                           pop_from_read_address_fifo;
    reg                                                           last_read_data;
    reg  [CFG_LOCAL_SIZE_WIDTH                           - 1 : 0] read_size_counter;
    
    reg  [CFG_PENDING_WRITE_DATA_WIDTH                   - 1 : 0] pending_write_data_counter;
    reg                                                           pending_write_data_counter_underflow;
    reg                                                           data_before_write_command;
    reg                                                           push_to_error_address_fifo;
    reg                                                           pop_from_error_address_fifo;
    reg                                                           issuing_dummy_write_command;
    reg                                                           issuing_dummy_write_data;
    reg                                                           issuing_dummy_write_data_non_gated;
    
    reg                                                           load_rmw_write_data;
    reg                                                           load_rmw_busy;
    reg                                                           load_rmw_busy_non_gated;
    reg                                                           loading_rmw_data;
    
    reg                                                           int_load_rmw_write_data;
    reg                                                           int_load_rmw_write_data_r;
    reg                                                           int_load_rmw_busy;
    reg                                                           int_load_rmw_busy_non_gated;
    reg                                                           int_load_rmw_busy_r;
    
    reg  [1                                                  : 0] int_error_inject;
    
    wire                                                          is_ast;
    
    wire                                                          one  = 1'b1;
    wire                                                          zero = 1'b0;
    
    genvar i;
    genvar j;

    assign int_slave_cmd_rd             = int_slave_cmd_data[0];
    assign int_slave_cmd_wr             = int_slave_cmd_data[1];
    assign int_slave_cmd_addr           = int_slave_cmd_data[(2+CFG_LOCAL_ADDR_WIDTH-1):2];
    assign int_slave_cmd_size           = int_slave_cmd_data[(37+CFG_LOCAL_SIZE_WIDTH-1):37];
    assign int_slave_cmd_priority       = int_slave_cmd_data[45];
    assign int_slave_cmd_auto_precharge = int_slave_cmd_data[46];
    assign int_slave_cmd_multicast      = int_slave_cmd_data[47];
    assign int_slave_cmd_id             = int_slave_cmd_data[(48+CFG_LOCAL_ID_WIDTH-1):48];

    assign is_ast = (cfg_ecc_in_protocol == CFG_INPUT_AST)? 1'b1 : 1'b0;
    
    always @ (*)
    begin
        slave_cmd_ready              = int_master_cmd_ready;
        slave_wr_data_ready          = int_master_wr_data_ready & ~load_rmw_busy_non_gated & ~pending_data_not_empty;
        slave_rd_data                = decoder_output_data;
        slave_rd_data_id             = decoder_output_data_id;
        slave_rd_data_valid          = |decoder_output_data_valid;
        slave_rd_data_error          = (cfg_enable_ecc) ? |decoder_output_dbe : 1'b0;
    end
    
    always @ (*)
    begin
        master_cmd_data                = int_master_cmd_data;
        master_cmd_valid               = int_master_cmd_valid;
        master_cmd_data_combi          = int_master_cmd_data_combi;
        master_cmd_valid_combi         = int_master_cmd_valid_combi;
        master_wr_data_byte_enable     = int_master_wr_data_byte_enable;
        master_wr_data_byte_enable_ori = int_master_wr_data_byte_enable_ori;
        master_wr_data                 = int_master_wr_data;
        master_wr_addr                 = int_master_wr_addr;
        master_wr_data_id              = int_master_wr_data_id;
        master_wr_data_info            = int_master_wr_data_info;
        master_wr_data_ptr_out         = int_master_wr_data_ptr_out;
        master_wr_data_valid           = int_master_wr_data_valid & (int_master_wr_data_ready | int_master_wr_data_info[2]); 
        master_rd_data_ready           = internal_master_rd_data_ready;
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            master_wr_addr_r <= {CFG_LOCAL_ADDR_WIDTH{1'b0}};
        end
        else
        begin
            master_wr_addr_r <= master_wr_addr;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            loading_rmw_data <= 1'b0;
        end
        else
        begin
            loading_rmw_data <= ~load_rmw_busy | issuing_dummy_write_data;
        end
    end
    
    generate
        for (i = 0; i < CFG_PENDING_DATA_FIFO_DEPTH; i = i + 1)
        begin : pending_loop
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    pending_data_valid           [i] <= 1'b0;
                    pending_data_byte_enable     [i] <= {CFG_ECC_BE_WIDTH{1'b0}};
                    pending_data_byte_enable_ori [i] <= {CFG_ECC_BE_WIDTH{1'b0}};
                    pending_data                 [i] <= {CFG_ECC_DATA_WIDTH{1'b0}};
                    pending_addr                 [i] <= {CFG_LOCAL_ADDR_WIDTH{1'b0}};
                    pending_data_id              [i] <= {CFG_LOCAL_ID_WIDTH{1'b0}};
                    pending_data_info            [i] <= {CFG_LOCAL_DATA_INFO_WIDTH{1'b0}};
                    pending_data_ptr             [i] <= {CFG_LOCAL_DATA_PTR_WIDTH{1'b0}};
                end
                else
                begin
                    if (encoder_output_data_valid && pending_data_valid_wr_ptr == i && ~encoder_output_data_info[2]) 
                    begin
                        pending_data_valid           [i] <= 1'b1;
                        pending_data_byte_enable     [i] <= encoder_output_data_byte_enable;
                        pending_data_byte_enable_ori [i] <= int_encoder_output_data_byte_enable;
                        pending_data                 [i] <= encoder_output_data;
                        pending_addr                 [i] <= encoder_output_addr;
                        pending_data_id              [i] <= encoder_output_data_id;
                        pending_data_info            [i] <= encoder_output_data_info;
                        pending_data_ptr             [i] <= encoder_output_data_ptr;
                    end
                    else if (load_pending_data && pending_data_valid_rd_ptr == i) 
                    begin
                        pending_data_valid           [i] <= 1'b0;
                    end
                end
            end
            
            always @ (*)
            begin
                if (load_pending_data && pending_data_valid_rd_ptr == i)
                begin
                    pending_data_valid_update [i] = 1'b0;
                end
                else
                begin
                    pending_data_valid_update [i] = pending_data_valid [i];
                end
            end
        end
        
        always @ (*)
        begin
            pending_data_valid_wr_ptr_combi = pending_data_valid_wr_ptr;
            pending_data_valid_rd_ptr_combi = pending_data_valid_rd_ptr;
            
            if (encoder_output_data_valid && ~encoder_output_data_info[2])
            begin
                pending_data_valid_wr_ptr_combi = pending_data_valid_wr_ptr + 1'b1;
            end
            
            if (load_pending_data)
            begin
                pending_data_valid_rd_ptr_combi = pending_data_valid_rd_ptr + 1'b1;
            end
        end
        
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                pending_data_valid_wr_ptr <= 1'b0;
                pending_data_valid_rd_ptr <= 1'b0;
            end
            else
            begin
                pending_data_valid_wr_ptr <= pending_data_valid_wr_ptr_combi;
                pending_data_valid_rd_ptr <= pending_data_valid_rd_ptr_combi;
            end
        end
        
        always @ (*)
        begin
            pending_data_not_empty = |pending_data_valid_update;
        end
        
        always @ (*)
        begin
            load_pending_data = int_master_wr_data_ready && ~master_wr_data_info[2] && master_wr_data_valid && |pending_data_valid;
        end
        
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                int_master_wr_data_byte_enable     <= {CFG_ECC_BE_WIDTH{1'b0}};
                int_master_wr_data_byte_enable_ori <= {CFG_ECC_BE_WIDTH{1'b0}};
                int_master_wr_data                 <= {CFG_ECC_DATA_WIDTH{1'b0}};
                int_master_wr_addr                 <= {CFG_LOCAL_ADDR_WIDTH{1'b0}};
                int_master_wr_data_id              <= {CFG_LOCAL_ID_WIDTH{1'b0}};
                int_master_wr_data_info            <= {CFG_LOCAL_DATA_INFO_WIDTH{1'b0}};
                int_master_wr_data_ptr_out         <= {CFG_LOCAL_DATA_PTR_WIDTH{1'b0}};
                int_master_wr_data_valid           <= 1'b0;
            end
            else
            begin
                if ((int_master_wr_data_ready && loading_rmw_data && ~pending_data_not_empty) || encoder_output_data_info[2]) 
                begin
                    int_master_wr_data_byte_enable     <= encoder_output_data_byte_enable;
                    int_master_wr_data_byte_enable_ori <= int_encoder_output_data_byte_enable;
                    int_master_wr_data                 <= encoder_output_data;
                    int_master_wr_addr                 <= encoder_output_addr;
                    int_master_wr_data_id              <= encoder_output_data_id;
                    int_master_wr_data_info            <= encoder_output_data_info;
                    int_master_wr_data_ptr_out         <= encoder_output_data_ptr;
                    int_master_wr_data_valid           <= encoder_output_data_valid;
                end
                else if (!(int_master_wr_data_ready && loading_rmw_data && ~pending_data_not_empty))
                begin
                    int_master_wr_data_byte_enable     <= pending_data_byte_enable     [pending_data_valid_rd_ptr_combi];
                    int_master_wr_data_byte_enable_ori <= pending_data_byte_enable_ori [pending_data_valid_rd_ptr_combi];
                    int_master_wr_data                 <= pending_data                 [pending_data_valid_rd_ptr_combi];
                    int_master_wr_addr                 <= pending_addr                 [pending_data_valid_rd_ptr_combi];
                    int_master_wr_data_id              <= pending_data_id              [pending_data_valid_rd_ptr_combi];
                    int_master_wr_data_info            <= pending_data_info            [pending_data_valid_rd_ptr_combi];
                    int_master_wr_data_ptr_out         <= pending_data_ptr             [pending_data_valid_rd_ptr_combi];
                    int_master_wr_data_valid           <= pending_data_valid           [pending_data_valid_rd_ptr_combi];
                end
            end
        end
    endgenerate
    
    always @ (*)
    begin
        if (master_cmd_ready)
        begin
            int_master_cmd_data_combi  = (internal_master_cmd_ready) ? int_cmd_data  : prev_int_cmd_data;
            int_master_cmd_valid_combi = (internal_master_cmd_ready) ? int_cmd_valid : prev_int_cmd_valid;
        end
        else
        begin
            int_master_cmd_data_combi  = int_master_cmd_data;
            int_master_cmd_valid_combi = int_master_cmd_valid;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_master_cmd_data  <= {CFG_CMD_DATA_WIDTH{1'b0}};
            int_master_cmd_valid <= 1'b0;
            prev_int_cmd_data    <= {CFG_CMD_DATA_WIDTH{1'b0}};
            prev_int_cmd_valid   <= 1'b0;
        end
        else
        begin
                int_master_cmd_data  <= int_master_cmd_data_combi;
                int_master_cmd_valid <= int_master_cmd_valid_combi;
            
            if (internal_master_cmd_ready)
            begin
                prev_int_cmd_data    <= int_cmd_data;
                prev_int_cmd_valid   <= int_cmd_valid;
            end
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            internal_master_cmd_ready <= 1'b0;
        end
        else
        begin
            internal_master_cmd_ready <= master_cmd_ready;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            master_wr_data_info_r1 <= {CFG_LOCAL_DATA_INFO_WIDTH{1'b0}};
            master_wr_data_info_r2 <= {CFG_LOCAL_DATA_INFO_WIDTH{1'b0}};
            master_wr_data_info_r3 <= {CFG_LOCAL_DATA_INFO_WIDTH{1'b0}};
            master_wr_data_info_r4 <= {CFG_LOCAL_DATA_INFO_WIDTH{1'b0}};
            master_wr_data_info_r5 <= {CFG_LOCAL_DATA_INFO_WIDTH{1'b0}};
            master_wr_data_info_r6 <= {CFG_LOCAL_DATA_INFO_WIDTH{1'b0}};
            master_wr_data_info_r7 <= {CFG_LOCAL_DATA_INFO_WIDTH{1'b0}};
            master_wr_data_info_r8 <= {CFG_LOCAL_DATA_INFO_WIDTH{1'b0}};
        end
        else
        begin
            master_wr_data_info_r1 <= master_wr_data_info;
            master_wr_data_info_r2 <= master_wr_data_info_r1;
            master_wr_data_info_r3 <= master_wr_data_info_r2;
            master_wr_data_info_r4 <= master_wr_data_info_r3;
            master_wr_data_info_r5 <= master_wr_data_info_r4;
            master_wr_data_info_r6 <= master_wr_data_info_r5;
            master_wr_data_info_r7 <= master_wr_data_info_r6;
            master_wr_data_info_r8 <= master_wr_data_info_r7;
        end
    end
    
    assign internal_master_rd_data_ready = int_slave_rd_data_ready & ~(prolong_write_back_data_fifo_empty_combi);
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            internal_master_rd_data       <= {CFG_ECC_DATA_WIDTH{1'b0}};
            internal_master_rd_data_id    <= {CFG_LOCAL_ID_WIDTH{1'b0}};
            internal_master_rd_data_info  <= {CFG_LOCAL_DATA_INFO_WIDTH{1'b0}};
            internal_master_rd_data_type  <= 1'b0;
            internal_master_rd_data_valid <= 1'b0;
            int_pointer_fifo_rd_data      <= {PTR_FIFO_DATA_WIDTH{1'b0}};
            int_wr_addr_fifo_rd_data      <= {WR_ADDR_FIFO_DATA_WIDTH{1'b0}};
        end
        else
        begin
            if (master_rd_data_ready)
            begin
                internal_master_rd_data       <= master_rd_data;
                internal_master_rd_data_id    <= master_rd_data_id;
                internal_master_rd_data_info  <= master_rd_data_info;
                internal_master_rd_data_type  <= master_rd_data_type;
                internal_master_rd_data_valid <= master_rd_data_valid;
                int_pointer_fifo_rd_data      <= pointer_fifo_rd_data;
                int_wr_addr_fifo_rd_data      <= wr_addr_fifo_rd_data;
            end
            else if (int_slave_rd_data_ready) 
            begin
                internal_master_rd_data_valid <= 1'b0;
            end
        end
    end
    
    assign idle =   partial_wdata_fifo_empty &
                    initial_pointer_fifo_empty &
                    pointer_fifo_empty &
                    cmd_info_fifo_empty &
                    initial_wr_addr_fifo_empty &
                    wr_addr_fifo_empty &
                    read_address_fifo_empty &
                    (read_size_counter == {CFG_LOCAL_SIZE_WIDTH{1'b0}}) & 
                    error_address_fifo_empty;
    

    altera_emif_io_hmc_ecc_amm2ast #
    (
        .CFG_LOCAL_SIZE_WIDTH   (CFG_LOCAL_SIZE_WIDTH   )
    )
    amm_ast_converter
    (
        .clk                    (ctl_clk                ),
        .reset_n                (ctl_reset_n            ),
        .amm_ready              (amm_ready              ),
        .amm_cmd_size           (amm_cmd_size           ),
        .amm_cmd_wr             (amm_cmd_wr             ),
        .amm_cmd_rd             (amm_cmd_rd             ),
        .ast_cmd_ready          (ast_cmd_ready          ),
        .ast_cmd_valid          (ast_cmd_valid          ),
        .ast_wr_data_ready      (ast_wr_data_ready      ),
        .ast_wr_data_valid      (ast_wr_data_valid      )
    );
    
    assign amm_cmd_size                  = int_slave_cmd_size;
    assign amm_cmd_wr                    = int_slave_cmd_wr;
    assign amm_cmd_rd                    = int_slave_cmd_rd;
    assign ast_cmd_ready                 = internal_master_cmd_ready & ~(error_cmd_valid | pop_from_error_address_fifo); 
    assign ast_wr_data_ready             = slave_wr_data_ready; 
    
    assign int_slave_cmd_data            =            slave_cmd_data                                                                                    ;
    assign int_slave_cmd_valid           =  is_ast ?  slave_cmd_valid                             : (ast_cmd_valid & (~load_rmw_busy | amm_cmd_rd))     ; 
    assign int_slave_wr_data_byte_enable =            slave_wr_data_byte_enable                                                                         ;
    assign int_slave_wr_data             =            slave_wr_data                                                                                     ;
    assign int_slave_wr_data_id          =            slave_wr_data_id                                                                                  ;
    assign int_slave_wr_data_valid       =  is_ast ? (slave_wr_data_valid & slave_wr_data_ready)  : (ast_wr_data_valid & ~issuing_dummy_write_command)  ; 
    assign int_slave_rd_data_ready       =            slave_rd_data_ready                                                                               ;
    
    assign int_master_cmd_ready          =  is_ast ?  ast_cmd_ready                               : amm_ready                                           ;
    assign int_master_cmd_info           =            master_cmd_info                                                                                   ;
    assign int_master_wr_data_ready      =            master_wr_data_ready                                                                              ;
    assign int_master_wr_data_ptr_in     =            master_wr_data_ptr_in                                                                             ;
    assign int_master_rd_data            =            internal_master_rd_data                                                                           ;
    assign int_master_rd_data_id         =            internal_master_rd_data_id                                                                        ;
    assign int_master_rd_data_info       =            {internal_master_rd_data_type, internal_master_rd_data_info [CFG_LOCAL_DATA_INFO_WIDTH - 2 : 0]}  ;
    assign int_master_rd_data_valid      =            internal_master_rd_data_valid & internal_master_rd_data_ready                                     ; 
    

    assign partial_wdata_fifo_wr      = master_wr_data_valid & (master_wr_data_info == NORMAL_PARTIAL_WRITE_DATA);
    assign partial_wdata_fifo_rd      = partial_read_data_returned; 
    
    generate
        for (i = 0; i < CFG_ECC_MULTIPLE_INSTANCE; i = i + 1)
        begin : fifo_data_loop
            assign partial_wdata_fifo_wr_data [(i + 1) * CFG_LOCAL_BE_PER_WORD_WIDTH + CFG_LOCAL_DATA_WIDTH - 1 : i * CFG_LOCAL_BE_PER_WORD_WIDTH + CFG_LOCAL_DATA_WIDTH] = master_wr_data_byte_enable_ori [i * CFG_ECC_BE_PER_WORD_WIDTH   + CFG_LOCAL_BE_PER_WORD_WIDTH   - 1 : i * CFG_ECC_BE_PER_WORD_WIDTH  ];
            assign partial_wdata_fifo_wr_data [(i + 1) * CFG_LOCAL_DATA_PER_WORD_WIDTH                      - 1 : i * CFG_LOCAL_DATA_PER_WORD_WIDTH                     ] = master_wr_data                 [i * CFG_ECC_DATA_PER_WORD_WIDTH + CFG_LOCAL_DATA_PER_WORD_WIDTH - 1 : i * CFG_ECC_DATA_PER_WORD_WIDTH];
        end
    endgenerate
    
    altera_emif_io_hmc_fifo #
    (
        .CFG_ADDR_WIDTH         (PARTIAL_FIFO_ADDR_WIDTH            ),
        .CFG_DATA_WIDTH         (PARTIAL_FIFO_DATA_WIDTH            ),
        .CFG_REGISTERED_OUTPUT  (PARTIAL_FIFO_REGISTERED_OUTPUT     ),
        .CFG_SHOWAHEAD          (PARTIAL_FIFO_SHOWAHEAD             )
    )
    partial_write_data_fifo
    (
        .ctl_clk                (ctl_clk                            ),
        .ctl_reset_n            (ctl_reset_n                        ),
        .write_request          (partial_wdata_fifo_wr              ),
        .write_data             (partial_wdata_fifo_wr_data         ),
        .read_request           (partial_wdata_fifo_rd              ),
        .read_data              (partial_wdata_fifo_rd_data         ),
        .read_data_valid        (partial_wdata_fifo_rd_data_valid   ),
        .fifo_empty             (partial_wdata_fifo_empty           ),
        .fifo_full              (partial_wdata_fifo_full            )
    );
    generate
        for (i = 0;i < CFG_ECC_MULTIPLE_INSTANCE;i = i + 1)
        begin : ratio_loop
            for (j = 0; j < CFG_LOCAL_BE_PER_WORD_WIDTH; j = j + 1)
            begin : be_loop
                always @ (*)
                begin
                    if ((j < (cfg_local_data_width / 4'd8)) && (i < cfg_data_rate))
                    begin
                        int_slave_wr_data_byte_enable_ones  [(i * CFG_LOCAL_BE_PER_WORD_WIDTH) + j] = int_slave_wr_data_byte_enable [(i * CFG_LOCAL_BE_PER_WORD_WIDTH) + j];
                        int_slave_wr_data_byte_enable_zeros [(i * CFG_LOCAL_BE_PER_WORD_WIDTH) + j] = int_slave_wr_data_byte_enable [(i * CFG_LOCAL_BE_PER_WORD_WIDTH) + j];
                    end
                    else
                    begin
                        int_slave_wr_data_byte_enable_ones  [(i * CFG_LOCAL_BE_PER_WORD_WIDTH) + j] = 1'b1;
                        int_slave_wr_data_byte_enable_zeros [(i * CFG_LOCAL_BE_PER_WORD_WIDTH) + j] = 1'b0;
                    end
                end
            end
            
            always @ (*)
            begin
                if (cfg_enable_rmw)
                begin
                    if (
                            int_slave_wr_data_byte_enable_zeros [(i + 1) * CFG_LOCAL_BE_PER_WORD_WIDTH - 1 : i * CFG_LOCAL_BE_PER_WORD_WIDTH] != {CFG_LOCAL_BE_PER_WORD_WIDTH{1'b0}} &&
                            int_slave_wr_data_byte_enable_ones  [(i + 1) * CFG_LOCAL_BE_PER_WORD_WIDTH - 1 : i * CFG_LOCAL_BE_PER_WORD_WIDTH] != {CFG_LOCAL_BE_PER_WORD_WIDTH{1'b1}}
                       )
                    begin
                        partial_write_detected [i] = 1'b1;
                    end
                    else
                    begin
                        partial_write_detected [i] = 1'b0;
                    end
                    
                    if (cfg_enable_ecc && int_slave_wr_data_byte_enable_zeros [(i + 1) * CFG_LOCAL_BE_PER_WORD_WIDTH - 1 : i * CFG_LOCAL_BE_PER_WORD_WIDTH] == {CFG_LOCAL_BE_PER_WORD_WIDTH{1'b0}}) 
                    begin
                        partial_write_be_all_zeros [i] = 1'b1;
                    end
                    else
                    begin
                        partial_write_be_all_zeros [i] = 1'b0;
                    end
                    
                    if (int_slave_wr_data_byte_enable_ones [(i + 1) * CFG_LOCAL_BE_PER_WORD_WIDTH - 1 : i * CFG_LOCAL_BE_PER_WORD_WIDTH] == {CFG_LOCAL_BE_PER_WORD_WIDTH{1'b1}}) 
                    begin
                        partial_write_be_all_ones  [i] = 1'b1;
                    end
                    else
                    begin
                        partial_write_be_all_ones  [i] = 1'b0;
                    end
                end
                else
                begin
                    partial_write_detected     [i] = 1'b0;
                    partial_write_be_all_zeros [i] = 1'b0;
                    partial_write_be_all_ones  [i] = 1'b0;
                end
            end
        end
    endgenerate
    
    always @ (*)
    begin
        if (cfg_enable_rmw)
        begin
            if (cfg_enable_dm)
            begin
                int_partial_write_detected     =  |partial_write_detected;
                int_partial_write_be_all_zeros =  &partial_write_be_all_zeros;
                int_partial_write_be_all_ones  = ~|partial_write_detected & ~&partial_write_be_all_zeros; 
            end
            else
            begin
                int_partial_write_detected     = ~&partial_write_be_all_ones; 
                int_partial_write_be_all_zeros =  &partial_write_be_all_zeros;
                int_partial_write_be_all_ones  =  &partial_write_be_all_ones;
            end
        end
        else
        begin
            int_partial_write_detected     = 1'b0;
            int_partial_write_be_all_zeros = 1'b0;
            int_partial_write_be_all_ones  = 1'b0;
        end
    end
    
    always @ (*)
    begin
        int_wr_data_info = 3'b000;
        
        if (int_partial_write_detected)
        begin
            int_wr_data_info [1:0] = 2'b11;
        end
        else
        begin
            if (int_partial_write_be_all_zeros)
            begin
                int_wr_data_info [1:0] = 2'b10;
            end
            
            if (int_partial_write_be_all_ones)
            begin
                int_wr_data_info [1:0] = 2'b01;
            end
        end
    end
    
    always @ (*)
    begin
        if (partial_read_data_returned | empty_read_data_returned)
        begin
            wr_data_info = {1'b1, int_master_rd_data_info [1:0]};
        end
        else if (issuing_dummy_write_data)
        begin
            wr_data_info = NORMAL_DUMMY_WRITE_DATA;
        end
        else
        begin
            wr_data_info = int_wr_data_info;
        end
    end
    
    

    reg  pop_from_cmd_info_fifo;
    reg  pop_from_initial_pointer_fifo;
    reg  pop_from_pointer_fifo;
    reg  push_to_pointer_fifo;
    reg  doing_second_write_data_burst;
    reg  finish_write_data_burst;
    
    assign mux_push_to_initial_pointer_fifo = (CFG_REGISTER_WDATA_PATH_NUM == 0) ? push_to_initial_pointer_fifo_r1 :
                                              (CFG_REGISTER_WDATA_PATH_NUM == 1) ? push_to_initial_pointer_fifo_r2 :
                                              (CFG_REGISTER_WDATA_PATH_NUM == 2) ? push_to_initial_pointer_fifo_r3 :
                                              (CFG_REGISTER_WDATA_PATH_NUM == 3) ? push_to_initial_pointer_fifo_r4 :
                                              (CFG_REGISTER_WDATA_PATH_NUM == 4) ? push_to_initial_pointer_fifo_r5 :
                                              (CFG_REGISTER_WDATA_PATH_NUM == 5) ? push_to_initial_pointer_fifo_r6 :
                                              (CFG_REGISTER_WDATA_PATH_NUM == 6) ? push_to_initial_pointer_fifo_r7 : push_to_initial_pointer_fifo_r1;
    assign mux_master_wr_data_info          = (CFG_REGISTER_WDATA_PATH_NUM == 0) ? master_wr_data_info_r2 :
                                              (CFG_REGISTER_WDATA_PATH_NUM == 1) ? master_wr_data_info_r3 :
                                              (CFG_REGISTER_WDATA_PATH_NUM == 2) ? master_wr_data_info_r4 :
                                              (CFG_REGISTER_WDATA_PATH_NUM == 3) ? master_wr_data_info_r5 :
                                              (CFG_REGISTER_WDATA_PATH_NUM == 4) ? master_wr_data_info_r6 :
                                              (CFG_REGISTER_WDATA_PATH_NUM == 5) ? master_wr_data_info_r7 :
                                              (CFG_REGISTER_WDATA_PATH_NUM == 6) ? master_wr_data_info_r8 : master_wr_data_info_r2;
    
    assign initial_pointer_fifo_wr      = (cfg_wrpath_pipeline_en == 1'b1) ? mux_push_to_initial_pointer_fifo : push_to_initial_pointer_fifo_r1; 
    assign initial_pointer_fifo_wr_data = {((cfg_wrpath_pipeline_en == 1'b1) ? mux_master_wr_data_info [1 : 0] : master_wr_data_info_r2 [1 : 0]), int_master_wr_data_ptr_in}; 
    assign initial_pointer_fifo_rd      = pop_from_initial_pointer_fifo;
    
    assign pointer_fifo_wr              = push_to_pointer_fifo;
    assign pointer_fifo_wr_data         = initial_pointer_fifo_rd_data [PTR_FIFO_DATA_WIDTH - 1 : 0]; 
    assign pointer_fifo_rd              = pop_from_pointer_fifo;
    
    assign cmd_info_fifo_wr             = cfg_enable_rmw & ((cfg_wrpath_pipeline_en == 1'b1) ? int_master_cmd_info_r1[0] : int_master_cmd_info[0]);
    assign cmd_info_fifo_wr_data        = (cfg_wrpath_pipeline_en == 1'b1) ? int_master_cmd_info_r1[CFG_CMD_INFO_WIDTH - 1 : 1] : int_master_cmd_info[CFG_CMD_INFO_WIDTH - 1 : 1];
    assign cmd_info_fifo_rd             = pop_from_cmd_info_fifo;
    
    altera_emif_io_hmc_fifo #
    (
        .CFG_ADDR_WIDTH         (PTR_FIFO_ADDR_WIDTH                ),
        .CFG_DATA_WIDTH         (PTR_FIFO_DATA_WIDTH + 2            ),
        .CFG_REGISTERED_OUTPUT  (PTR_FIFO_REGISTERED_OUTPUT         ),
        .CFG_SHOWAHEAD          (PTR_FIFO_SHOWAHEAD                 )
    )
    initial_pointer_fifo
    (
        .ctl_clk                (ctl_clk                            ),
        .ctl_reset_n            (ctl_reset_n                        ),
        .write_request          (initial_pointer_fifo_wr            ),
        .write_data             (initial_pointer_fifo_wr_data       ),
        .read_request           (initial_pointer_fifo_rd            ),
        .read_data              (initial_pointer_fifo_rd_data       ),
        .read_data_valid        (initial_pointer_fifo_rd_data_valid ),
        .fifo_empty             (initial_pointer_fifo_empty         ),
        .fifo_full              (initial_pointer_fifo_full          )
    );
    
    altera_emif_io_hmc_fifo #
    (
        .CFG_ADDR_WIDTH         (PTR_FIFO_ADDR_WIDTH                ),
        .CFG_DATA_WIDTH         (PTR_FIFO_DATA_WIDTH                ),
        .CFG_REGISTERED_OUTPUT  (PTR_FIFO_REGISTERED_OUTPUT         ),
        .CFG_SHOWAHEAD          (PTR_FIFO_SHOWAHEAD                 )
    )
    pointer_fifo
    (
        .ctl_clk                (ctl_clk                            ),
        .ctl_reset_n            (ctl_reset_n                        ),
        .write_request          (pointer_fifo_wr                    ),
        .write_data             (pointer_fifo_wr_data               ),
        .read_request           (pointer_fifo_rd                    ),
        .read_data              (pointer_fifo_rd_data               ),
        .read_data_valid        (pointer_fifo_rd_data_valid         ),
        .fifo_empty             (pointer_fifo_empty                 ),
        .fifo_full              (pointer_fifo_full                  )
    );
    
    altera_emif_io_hmc_fifo #
    (
        .CFG_ADDR_WIDTH         (CMD_INFO_FIFO_ADDR_WIDTH           ),
        .CFG_DATA_WIDTH         (CMD_INFO_FIFO_DATA_WIDTH           ),
        .CFG_REGISTERED_OUTPUT  (CMD_INFO_FIFO_REGISTERED_OUTPUT    ),
        .CFG_SHOWAHEAD          (CMD_INFO_FIFO_SHOWAHEAD            )
    )
    cmd_info_fifo
    (
        .ctl_clk                (ctl_clk                            ),
        .ctl_reset_n            (ctl_reset_n                        ),
        .write_request          (cmd_info_fifo_wr                   ),
        .write_data             (cmd_info_fifo_wr_data              ),
        .read_request           (cmd_info_fifo_rd                   ),
        .read_data              (cmd_info_fifo_rd_data              ),
        .read_data_valid        (cmd_info_fifo_rd_data_valid        ),
        .fifo_empty             (cmd_info_fifo_empty                ),
        .fifo_full              (cmd_info_fifo_full                 )
    );
    
    generate
        if (CFG_ADDR_ENCODE_ENABLED)
        begin
            assign initial_wr_addr_fifo_wr      = push_to_initial_pointer_fifo;
            assign initial_wr_addr_fifo_wr_data = master_wr_addr_r;
            assign initial_wr_addr_fifo_rd      = pop_from_initial_pointer_fifo;
            
            assign wr_addr_fifo_wr              = push_to_pointer_fifo;
            assign wr_addr_fifo_wr_data         = initial_wr_addr_fifo_rd_data;
            assign wr_addr_fifo_rd              = pop_from_pointer_fifo;
            
            altera_emif_io_hmc_fifo #
            (
                .CFG_ADDR_WIDTH         (WR_ADDR_FIFO_ADDR_WIDTH            ),
                .CFG_DATA_WIDTH         (WR_ADDR_FIFO_DATA_WIDTH            ),
                .CFG_REGISTERED_OUTPUT  (WR_ADDR_FIFO_REGISTERED_OUTPUT     ),
                .CFG_SHOWAHEAD          (WR_ADDR_FIFO_SHOWAHEAD             )
            )
            initial_wr_addr_fifo
            (
                .ctl_clk                (ctl_clk                            ),
                .ctl_reset_n            (ctl_reset_n                        ),
                .write_request          (initial_wr_addr_fifo_wr            ),
                .write_data             (initial_wr_addr_fifo_wr_data       ),
                .read_request           (initial_wr_addr_fifo_rd            ),
                .read_data              (initial_wr_addr_fifo_rd_data       ),
                .read_data_valid        (initial_wr_addr_fifo_rd_data_valid ),
                .fifo_empty             (initial_wr_addr_fifo_empty         ),
                .fifo_full              (initial_wr_addr_fifo_full          )
            );
            
            altera_emif_io_hmc_fifo #
            (
                .CFG_ADDR_WIDTH         (WR_ADDR_FIFO_ADDR_WIDTH            ),
                .CFG_DATA_WIDTH         (WR_ADDR_FIFO_DATA_WIDTH            ),
                .CFG_REGISTERED_OUTPUT  (WR_ADDR_FIFO_REGISTERED_OUTPUT     ),
                .CFG_SHOWAHEAD          (WR_ADDR_FIFO_SHOWAHEAD             )
            )
            wr_addr_fifo
            (
                .ctl_clk                (ctl_clk                            ),
                .ctl_reset_n            (ctl_reset_n                        ),
                .write_request          (wr_addr_fifo_wr                    ),
                .write_data             (wr_addr_fifo_wr_data               ),
                .read_request           (wr_addr_fifo_rd                    ),
                .read_data              (wr_addr_fifo_rd_data               ),
                .read_data_valid        (wr_addr_fifo_rd_data_valid         ),
                .fifo_empty             (wr_addr_fifo_empty                 ),
                .fifo_full              (wr_addr_fifo_full                  )
            );
        end
        else
        begin
            assign initial_wr_addr_fifo_rd_data       = {WR_ADDR_FIFO_DATA_WIDTH{1'b0}};
            assign initial_wr_addr_fifo_rd_data_valid = initial_pointer_fifo_rd_data_valid;
            assign initial_wr_addr_fifo_empty         = 1'b1;
            
            assign wr_addr_fifo_rd_data               = {WR_ADDR_FIFO_DATA_WIDTH{1'b0}};
            assign wr_addr_fifo_rd_data_valid         = 1'b0;
            assign wr_addr_fifo_empty                 = 1'b1;
        end
    endgenerate
    
    always @ (*)
    begin
        if (cfg_enable_rmw && ((cmd_info_fifo_rd_data_valid && initial_pointer_fifo_rd_data_valid && initial_wr_addr_fifo_rd_data_valid) || doing_second_write_data_burst))
        begin
            pop_from_initial_pointer_fifo = 1'b1;
        end
        else
        begin
            pop_from_initial_pointer_fifo = 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            doing_second_write_data_burst <= 1'b0;
        end
        else
        begin
            if (pop_from_cmd_info_fifo)
            begin
                doing_second_write_data_burst <= 1'b0;
            end
            else if (cmd_info_fifo_rd_data_valid && cmd_info_fifo_rd_data[1] == 1'b1) 
            begin
                doing_second_write_data_burst <= 1'b1;
            end
            else
            begin
                doing_second_write_data_burst <= 1'b0;
            end
        end
    end
    
    always @ (*)
    begin
        if (((cmd_info_fifo_rd_data_valid && initial_pointer_fifo_rd_data_valid) && cmd_info_fifo_rd_data[1] == 1'b0) || doing_second_write_data_burst)
        begin
            pop_from_cmd_info_fifo = 1'b1;
        end
        else
        begin
            pop_from_cmd_info_fifo = 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            push_to_initial_pointer_fifo    <= 1'b0;
            push_to_initial_pointer_fifo_r1 <= 1'b0;
            push_to_initial_pointer_fifo_r2 <= 1'b0;
            push_to_initial_pointer_fifo_r3 <= 1'b0;
            push_to_initial_pointer_fifo_r4 <= 1'b0;
            push_to_initial_pointer_fifo_r5 <= 1'b0;
            push_to_initial_pointer_fifo_r6 <= 1'b0;
            push_to_initial_pointer_fifo_r7 <= 1'b0;
        end
        else
        begin
            push_to_initial_pointer_fifo    <= cfg_enable_rmw & master_wr_data_valid & int_master_wr_data_ready & ~master_wr_data_info[2];
            push_to_initial_pointer_fifo_r1 <= push_to_initial_pointer_fifo;
            push_to_initial_pointer_fifo_r2 <= push_to_initial_pointer_fifo_r1;
            push_to_initial_pointer_fifo_r3 <= push_to_initial_pointer_fifo_r2;
            push_to_initial_pointer_fifo_r4 <= push_to_initial_pointer_fifo_r3;
            push_to_initial_pointer_fifo_r5 <= push_to_initial_pointer_fifo_r4;
            push_to_initial_pointer_fifo_r6 <= push_to_initial_pointer_fifo_r5;
            push_to_initial_pointer_fifo_r7 <= push_to_initial_pointer_fifo_r6;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_master_cmd_info_r1 <= {CFG_CMD_INFO_WIDTH{1'b0}};
        end
        else
        begin
            int_master_cmd_info_r1 <= int_master_cmd_info;
        end
    end
    
    always @ (*)
    begin
        if (
                initial_pointer_fifo_rd && cmd_info_fifo_rd_data[0] == 1'b1 &&
                (
                    initial_pointer_fifo_rd_data [PTR_FIFO_DATA_WIDTH + 2 - 1 : PTR_FIFO_DATA_WIDTH] == INFO_DUMMY_WRITE_DATA   ||
                    initial_pointer_fifo_rd_data [PTR_FIFO_DATA_WIDTH + 2 - 1 : PTR_FIFO_DATA_WIDTH] == INFO_PARTIAL_WRITE_DATA
                )
           ) 
        begin
            push_to_pointer_fifo = 1'b1;
        end
        else
        begin
            push_to_pointer_fifo = 1'b0;
        end
    end
    
    always @ (*)
    begin
        pop_from_pointer_fifo = (empty_read_data_returned_combi_early | partial_read_data_returned_combi_early) & ~pointer_fifo_empty; 
    end
    
    always @ (*)
    begin
        int_wr_data_ptr = wr_data_ptr & {CFG_LOCAL_DATA_PTR_WIDTH {load_rmw_write_data}}; 
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            wr_data_ptr <= {CFG_LOCAL_DATA_PTR_WIDTH{1'b0}};
        end
        else
        begin
            wr_data_ptr <= int_pointer_fifo_rd_data; 
        end
    end
    
    always @ (*)
    begin
        partial_write_addr = int_wr_addr_fifo_rd_data;
    end
    

    always @ (*)
    begin
        partial_read_data_returned_combi_early = int_slave_rd_data_ready & master_rd_data_valid & ({master_rd_data_type, master_rd_data_info [CFG_LOCAL_DATA_INFO_WIDTH - 2 : 0]} == NORMAL_PARTIAL_READ_DATA);
        empty_read_data_returned_combi_early   = int_slave_rd_data_ready & master_rd_data_valid & ({master_rd_data_type, master_rd_data_info [CFG_LOCAL_DATA_INFO_WIDTH - 2 : 0]} == NORMAL_DUMMY_READ_DATA);
        normal_read_data_returned_combi_early  = int_slave_rd_data_ready & master_rd_data_valid & ({master_rd_data_type, master_rd_data_info [CFG_LOCAL_DATA_INFO_WIDTH - 2 : 0]} == NORMAL_READ_DATA);
    end
    
    always @ (*)
    begin
        partial_read_data_returned_combi = int_slave_rd_data_ready & internal_master_rd_data_valid & (int_master_rd_data_info == NORMAL_PARTIAL_READ_DATA);
        empty_read_data_returned_combi   = int_slave_rd_data_ready & internal_master_rd_data_valid & (int_master_rd_data_info == NORMAL_DUMMY_READ_DATA);
        normal_read_data_returned_combi  = int_slave_rd_data_ready & internal_master_rd_data_valid & (int_master_rd_data_info == NORMAL_READ_DATA);
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            partial_read_data_returned <= 1'b0;
            empty_read_data_returned   <= 1'b0;
            normal_read_data_returned  <= 1'b0;
        end
        else 
        begin
            partial_read_data_returned <= partial_read_data_returned_combi;
            empty_read_data_returned   <= empty_read_data_returned_combi;
            normal_read_data_returned  <= normal_read_data_returned_combi;
        end
    end
    
    always @ (*)
    begin
        int_load_rmw_write_data     = (partial_read_data_returned_combi | empty_read_data_returned_combi);
        int_load_rmw_busy_non_gated = (partial_read_data_returned | empty_read_data_returned | issuing_dummy_write_data_non_gated); 
        int_load_rmw_busy           = (partial_read_data_returned | empty_read_data_returned | issuing_dummy_write_data);
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_load_rmw_write_data_r <= 1'b0;
            int_load_rmw_busy_r       <= 1'b0;
        end
        else
        begin
            int_load_rmw_write_data_r <= int_load_rmw_write_data;
            int_load_rmw_busy_r       <= int_load_rmw_busy;
        end
    end
    
    always @ (*)
    begin
            load_rmw_write_data     = int_load_rmw_write_data_r;
            load_rmw_busy_non_gated = int_load_rmw_busy_non_gated | (int_load_rmw_busy_r & |pending_data_valid & ~load_pending_data); 
            load_rmw_busy           = int_load_rmw_busy           | (int_load_rmw_busy_r & |pending_data_valid & ~load_pending_data);
    end
    
    always @ (*)
    begin
        {partial_write_data_byte_enable, partial_write_data} = partial_wdata_fifo_rd_data;
    end
    
    always @ (*)
    begin
        prolong_write_back_data_fifo_empty_combi = (partial_read_data_returned_combi_early || empty_read_data_returned_combi_early) && pointer_fifo_empty;
    end
    
    
    always @ (*)
    begin
        partial_write_ecc_code           = decoder_output_ecc_code;
        partial_write_ecc_code_overwrite = {CFG_ECC_MULTIPLE_INSTANCE{cfg_ecc_code_overwrite}} & decoder_output_dbe & {CFG_ECC_MULTIPLE_INSTANCE{~partial_read_data_returned}}; 
    end
    
    generate
        for (i = 0;i < CFG_ECC_MULTIPLE_INSTANCE;i = i + 1)
        begin : instance_loop
            if (CFG_LOCAL_DATA_PER_WORD_WIDTH > (CFG_LOCAL_BE_PER_WORD_WIDTH * 8))
            begin
                always @ (*)
                begin
                    merge_write_data [((i + 1) * CFG_LOCAL_DATA_PER_WORD_WIDTH) - 1 : (i * CFG_LOCAL_DATA_PER_WORD_WIDTH) + (CFG_LOCAL_BE_PER_WORD_WIDTH * 8)] = {(((i + 1) * CFG_LOCAL_DATA_PER_WORD_WIDTH) - (CFG_LOCAL_BE_PER_WORD_WIDTH * 8)){zero}};
                end
            end
            
            for (j = 0;j < CFG_LOCAL_BE_PER_WORD_WIDTH;j = j + 1)
            begin : local_be_loop
                always @ (*)
                begin
                    if (partial_write_data_byte_enable [(i * CFG_LOCAL_BE_PER_WORD_WIDTH) + j])
                    begin
                        merge_write_data [(i * CFG_LOCAL_DATA_PER_WORD_WIDTH) + ((j + 1) * 8) - 1 : (i * CFG_LOCAL_DATA_PER_WORD_WIDTH) + (j * 8)] = partial_write_data  [(i * CFG_LOCAL_DATA_PER_WORD_WIDTH) + ((j + 1) * 8) - 1 : (i * CFG_LOCAL_DATA_PER_WORD_WIDTH) + (j * 8)];
                    end
                    else
                    begin
                        merge_write_data [(i * CFG_LOCAL_DATA_PER_WORD_WIDTH) + ((j + 1) * 8) - 1 : (i * CFG_LOCAL_DATA_PER_WORD_WIDTH) + (j * 8)] = decoder_output_data [(i * CFG_LOCAL_DATA_PER_WORD_WIDTH) + ((j + 1) * 8) - 1 : (i * CFG_LOCAL_DATA_PER_WORD_WIDTH) + (j * 8)];
                    end
                end
            end
        end
    endgenerate

    reg  [CFG_LOCAL_ADDR_WIDTH - 1 : 0] current_write_address;
    reg  [CFG_LOCAL_ADDR_WIDTH - 1 : 0] current_write_address_incr;
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            current_write_address_incr <= {CFG_LOCAL_ADDR_WIDTH{1'b0}};
        end
        else
        begin
            if (int_slave_cmd_wr && int_slave_cmd_valid)
            begin
                current_write_address_incr <= int_slave_cmd_addr + 1'b1;
            end
            else if (int_slave_wr_data_valid)
            begin
                current_write_address_incr <= current_write_address_incr + 1'b1;
            end
        end
    end
    
    always @ (*)
    begin
        if (int_slave_cmd_wr && int_slave_cmd_valid)
        begin
            current_write_address = int_slave_cmd_addr;
        end
        else
        begin
            current_write_address = current_write_address_incr;
        end
    end

    always @ (*)
    begin
        encoder_input_data               = int_slave_wr_data;
        encoder_input_addr               = current_write_address;
        encoder_input_ecc_code           = {(CFG_ECC_CODE_WIDTH * CFG_ECC_MULTIPLE_INSTANCE){1'b0}};
        encoder_input_ecc_code_overwrite = {CFG_ECC_MULTIPLE_INSTANCE{1'b0}};
        
        if (partial_read_data_returned)
        begin
            encoder_input_data               = merge_write_data;
            encoder_input_addr               = decoder_output_addr;
            encoder_input_ecc_code           = partial_write_ecc_code;
            encoder_input_ecc_code_overwrite = partial_write_ecc_code_overwrite;
        end
        else if (empty_read_data_returned)
        begin
            encoder_input_data               = decoder_output_data;
            encoder_input_addr               = decoder_output_addr;
            encoder_input_ecc_code           = partial_write_ecc_code;
            encoder_input_ecc_code_overwrite = partial_write_ecc_code_overwrite;
        end
        else if (issuing_dummy_write_data)
        begin
            encoder_input_data               = {CFG_LOCAL_DATA_WIDTH{1'b0}};
            encoder_input_addr               = error_wr_addr;
            encoder_input_ecc_code           = {(CFG_ECC_CODE_WIDTH * CFG_ECC_MULTIPLE_INSTANCE){1'b0}};
            encoder_input_ecc_code_overwrite = {CFG_ECC_MULTIPLE_INSTANCE{1'b0}};
        end
    end
    
    
    always @ (*)
    begin
        encoder_output_data_id_combi          = int_slave_wr_data_id;
        encoder_output_data_info_combi        = wr_data_info;
        encoder_output_data_ptr_combi         = int_wr_data_ptr; 
        encoder_output_data_valid_combi       = int_slave_wr_data_valid | load_rmw_write_data | issuing_dummy_write_data;
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            encoder_output_data_id    <= {CFG_LOCAL_ID_WIDTH{1'b0}};
            encoder_output_data_info  <= {CFG_LOCAL_DATA_INFO_WIDTH{1'b0}};
            encoder_output_data_ptr   <= {CFG_LOCAL_DATA_PTR_WIDTH{1'b0}};
            encoder_output_data_valid <= 1'b0;
        end
        else
        begin
            encoder_output_data_id    <= encoder_output_data_id_combi;
            encoder_output_data_info  <= encoder_output_data_info_combi;
            encoder_output_data_ptr   <= encoder_output_data_ptr_combi;
            encoder_output_data_valid <= encoder_output_data_valid_combi;
        end
    end
    
    generate
        for (i = 0; i < CFG_ECC_MULTIPLE_INSTANCE; i = i + 1)
        begin : byte_enable_loop
            always @ (*)
            begin
                if (CFG_ECC_BE_PER_WORD_WIDTH > CFG_LOCAL_BE_PER_WORD_WIDTH)
                begin
                    int_encoder_output_data_byte_enable_combi [(i + 1) * CFG_ECC_BE_PER_WORD_WIDTH - 1 : i * CFG_ECC_BE_PER_WORD_WIDTH] = {{(CFG_ECC_BE_PER_WORD_WIDTH - CFG_LOCAL_BE_PER_WORD_WIDTH){1'b0}}, int_slave_wr_data_byte_enable[(i + 1) * CFG_LOCAL_BE_PER_WORD_WIDTH - 1 : i * CFG_LOCAL_BE_PER_WORD_WIDTH]};
                end
                else
                begin
                    int_encoder_output_data_byte_enable_combi [(i + 1) * CFG_ECC_BE_PER_WORD_WIDTH - 1 : i * CFG_ECC_BE_PER_WORD_WIDTH] = int_slave_wr_data_byte_enable[(i + 1) * CFG_LOCAL_BE_PER_WORD_WIDTH - 1 : i * CFG_LOCAL_BE_PER_WORD_WIDTH];
                end
                
                if (partial_read_data_returned)
                begin
                    int_encoder_output_data_byte_enable_combi [(i + 1) * CFG_ECC_BE_PER_WORD_WIDTH - 1 : i * CFG_ECC_BE_PER_WORD_WIDTH]= {CFG_ECC_BE_PER_WORD_WIDTH{1'b1}};
                end
                else if (empty_read_data_returned)
                begin
                    int_encoder_output_data_byte_enable_combi [(i + 1) * CFG_ECC_BE_PER_WORD_WIDTH - 1 : i * CFG_ECC_BE_PER_WORD_WIDTH]= {CFG_ECC_BE_PER_WORD_WIDTH{1'b1}};
                end
                else if (issuing_dummy_write_data)
                begin
                    int_encoder_output_data_byte_enable_combi [(i + 1) * CFG_ECC_BE_PER_WORD_WIDTH - 1 : i * CFG_ECC_BE_PER_WORD_WIDTH]= {CFG_ECC_BE_PER_WORD_WIDTH{1'b0}};
                end
            end
        end
    endgenerate
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_encoder_output_data_byte_enable <= {CFG_ECC_BE_WIDTH{1'b0}};
        end
        else
        begin
            int_encoder_output_data_byte_enable <= int_encoder_output_data_byte_enable_combi;
        end
    end
    
    always @ (*)
    begin
        if (cfg_gen_sbe)
        begin
            int_error_inject = 2'b01;
        end
        else if (cfg_gen_dbe)
        begin
            int_error_inject = 2'b11;
        end
        else
        begin
            int_error_inject = 2'b00;
        end
    end
    
    generate
        for (i = 0;i < CFG_ECC_MULTIPLE_INSTANCE;i = i + 1)
        begin : encoder_instance_loop
            if (CFG_ENCODER_DATA_WIDTH > CFG_LOCAL_DATA_PER_WORD_WIDTH)
            begin
                assign int_encoder_input_data_combi           [i] = {{(CFG_ENCODER_DATA_WIDTH - CFG_ECC_CODE_WIDTH){1'b0}}, encoder_input_data [(i + 1) * CFG_LOCAL_DATA_PER_WORD_WIDTH - 1 : i * CFG_LOCAL_DATA_PER_WORD_WIDTH]};
            end
            else
            begin
                assign int_encoder_input_data_combi           [i] = encoder_input_data               [(i + 1) * CFG_LOCAL_DATA_PER_WORD_WIDTH - 1 : i * CFG_LOCAL_DATA_PER_WORD_WIDTH];
            end
            assign int_encoder_input_addr_combi               [i] = (CFG_ADDR_ENCODE_ENABLED == 1) ? {encoder_input_addr, i [LOG2_CFG_ECC_MULTIPLE_INSTANCE - 1 : 0]} : {CFG_ENCODER_ADDR_WIDTH{1'b0}}; 
            assign int_encoder_input_ecc_code_combi           [i] = encoder_input_ecc_code           [(i + 1) * CFG_ECC_CODE_WIDTH            - 1 : i * CFG_ECC_CODE_WIDTH           ] ;
            assign int_encoder_input_ecc_code_overwrite_combi [i] = encoder_input_ecc_code_overwrite [ i                                                                             ] ;
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    int_encoder_input_data               [i] <= {CFG_ENCODER_DATA_WIDTH{1'b0}};
                    int_encoder_input_addr               [i] <= {CFG_ENCODER_ADDR_WIDTH{1'b0}};
                    int_encoder_input_ecc_code           [i] <= {CFG_ECC_CODE_WIDTH{1'b0}};
                    int_encoder_input_ecc_code_overwrite [i] <= 1'b0;
                end
                else
                begin
                    int_encoder_input_data               [i] <= int_encoder_input_data_combi               [i];
                    int_encoder_input_addr               [i] <= int_encoder_input_addr_combi               [i];
                    int_encoder_input_ecc_code           [i] <= int_encoder_input_ecc_code_combi           [i];
                    int_encoder_input_ecc_code_overwrite [i] <= int_encoder_input_ecc_code_overwrite_combi [i];
                end
            end
            
            altera_emif_io_hmc_ecc_encoder #
            (
                .CFG_ECC_DATA_WIDTH                  (CFG_ENCODER_DATA_WIDTH                    ),
                .CFG_ECC_CODE_WIDTH                  (CFG_ECC_CODE_WIDTH                        ),
                .CFG_ADDR_WIDTH                      (CFG_ENCODER_ADDR_WIDTH                    ),
                .CFG_PORT_WIDTH_DRAM_DATA_WIDTH      (CFG_PORT_WIDTH_DRAM_DATA_WIDTH            ),
                .CFG_PORT_WIDTH_LOCAL_DATA_WIDTH     (CFG_PORT_WIDTH_LOCAL_DATA_WIDTH           ),
                .CFG_PORT_WIDTH_ENABLE_ECC           (CFG_PORT_WIDTH_ENABLE_ECC                 ),
                .CFG_ADDR_ENCODE_ENABLED             (CFG_ADDR_ENCODE_ENABLED                   )
            )
            ecc_encoder_inst
            (
                .ctl_clk                             (ctl_clk                                   ),
                .ctl_reset_n                         (ctl_reset_n                               ),
                .cfg_local_data_width                (cfg_local_data_width                      ),
                .cfg_dram_data_width                 (cfg_dram_data_width                       ),
                .cfg_enable_ecc                      (cfg_enable_ecc                            ),
                .input_data                          (int_encoder_input_data                 [i]),
                .input_addr                          (int_encoder_input_addr                 [i]),
                .input_ecc_code                      (int_encoder_input_ecc_code             [i]),
                .input_ecc_code_overwrite            (int_encoder_input_ecc_code_overwrite   [i]),
                .output_data                         (int_encoder_output_data                [i])
            );

            always @ (*)
            begin
                encoder_output_data [(i + 1) * CFG_ECC_DATA_PER_WORD_WIDTH - 1 : i * CFG_ECC_DATA_PER_WORD_WIDTH] = {int_encoder_output_data [i][CFG_ECC_DATA_PER_WORD_WIDTH - 1 : 2], (int_encoder_output_data [i][1 : 0] ^ int_error_inject [1 : 0])};
            end
            
            always @ (*)
            begin
                if (cfg_enable_rmw)
                begin
                    if (cfg_enable_dm)
                    begin
                        if (int_slave_wr_data_valid && slave_wr_data_ready) 
                        begin
                            if (partial_write_be_all_ones[i]) 
                            begin
                                encoder_output_data_byte_enable_combi [(i + 1) * CFG_ECC_BE_PER_WORD_WIDTH - 1 : i * CFG_ECC_BE_PER_WORD_WIDTH] = {CFG_ECC_BE_PER_WORD_WIDTH{1'b1}};
                            end
                            else
                            begin
                                encoder_output_data_byte_enable_combi [(i + 1) * CFG_ECC_BE_PER_WORD_WIDTH - 1 : i * CFG_ECC_BE_PER_WORD_WIDTH] = {CFG_ECC_BE_PER_WORD_WIDTH{1'b0}};
                            end
                        end
                        else
                        begin
                            encoder_output_data_byte_enable_combi [(i + 1) * CFG_ECC_BE_PER_WORD_WIDTH - 1 : i * CFG_ECC_BE_PER_WORD_WIDTH] = {CFG_ECC_BE_PER_WORD_WIDTH{1'b1}};
                        end
                    end
                    else
                    begin
                        encoder_output_data_byte_enable_combi [(i + 1) * CFG_ECC_BE_PER_WORD_WIDTH - 1 : i * CFG_ECC_BE_PER_WORD_WIDTH] = {CFG_ECC_BE_PER_WORD_WIDTH{1'b1}}; 
                    end
                end
                else
                begin
                    encoder_output_data_byte_enable_combi [(i + 1) * CFG_ECC_BE_PER_WORD_WIDTH - 1 : i * CFG_ECC_BE_PER_WORD_WIDTH] = int_encoder_output_data_byte_enable_combi [(i + 1) * CFG_ECC_BE_PER_WORD_WIDTH - 1 : i * CFG_ECC_BE_PER_WORD_WIDTH];
                end
            end
            
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                if (!ctl_reset_n)
                begin
                    encoder_output_data_byte_enable [(i + 1) * CFG_ECC_BE_PER_WORD_WIDTH - 1 : i * CFG_ECC_BE_PER_WORD_WIDTH] <= {CFG_ECC_BE_PER_WORD_WIDTH{1'b0}};
                end
                else
                begin
                    encoder_output_data_byte_enable [(i + 1) * CFG_ECC_BE_PER_WORD_WIDTH - 1 : i * CFG_ECC_BE_PER_WORD_WIDTH] <= encoder_output_data_byte_enable_combi [(i + 1) * CFG_ECC_BE_PER_WORD_WIDTH - 1 : i * CFG_ECC_BE_PER_WORD_WIDTH];
                end
            end
        end
    endgenerate
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            encoder_output_addr <= {CFG_LOCAL_ADDR_WIDTH{1'b0}};
        end
        else
        begin
            encoder_output_addr <= encoder_input_addr;
        end
    end
    always @ (*)
    begin
        decoder_input_data       = int_master_rd_data;
        decoder_input_data_valid = normal_read_data_returned_combi;
        
        if (partial_read_data_returned_combi || empty_read_data_returned_combi) 
        begin
            decoder_input_addr   = partial_write_addr;
        end
        else
        begin
            decoder_input_addr   = int_current_addr;
        end
    end
    
    always @ (*)
    begin
        decoder_output_data_id_combi = int_master_rd_data_id;
    end

    generate
        for (i = 0;i < CFG_ECC_MULTIPLE_INSTANCE;i = i + 1)
        begin : decoder_instance_loop
            if (CFG_DECODER_DATA_WIDTH > CFG_ECC_DATA_PER_WORD_WIDTH)
            begin
                assign int_decoder_input_data       [i] = {{(CFG_DECODER_DATA_WIDTH - CFG_ECC_DATA_PER_WORD_WIDTH){1'b0}}, decoder_input_data [(i + 1) * CFG_ECC_DATA_PER_WORD_WIDTH - 1 : i * CFG_ECC_DATA_PER_WORD_WIDTH]};
            end
            else
            begin
                assign int_decoder_input_data       [i] = decoder_input_data [(i + 1) * CFG_ECC_DATA_PER_WORD_WIDTH - 1 : i * CFG_ECC_DATA_PER_WORD_WIDTH];
            end
            
            assign int_decoder_input_addr       [i] = (CFG_ADDR_ENCODE_ENABLED == 1) ? {decoder_input_addr, i [LOG2_CFG_ECC_MULTIPLE_INSTANCE - 1 : 0]} : {CFG_DECODER_ADDR_WIDTH{1'b0}}; 
            assign int_decoder_input_data_valid [i] = decoder_input_data_valid;
            
            assign decoder_output_data_combi       [(i + 1) * CFG_LOCAL_DATA_PER_WORD_WIDTH - 1 : i * CFG_LOCAL_DATA_PER_WORD_WIDTH] = int_decoder_output_data       [i][CFG_LOCAL_DATA_PER_WORD_WIDTH - 1 : 0];
            assign decoder_output_data_valid_combi [ i                                                                             ] = int_decoder_output_data_valid [i];
            assign decoder_output_ecc_code_combi   [(i + 1) * CFG_ECC_CODE_WIDTH            - 1 : i * CFG_ECC_CODE_WIDTH           ] = int_decoder_output_ecc_code   [i];
            
            altera_emif_io_hmc_ecc_decoder #
            (
                .CFG_ECC_DATA_WIDTH                  (CFG_DECODER_DATA_WIDTH                  ),
                .CFG_ECC_CODE_WIDTH                  (CFG_ECC_CODE_WIDTH                      ),
                .CFG_ADDR_WIDTH                      (CFG_DECODER_ADDR_WIDTH                  ),
                .CFG_PORT_WIDTH_DRAM_DATA_WIDTH      (CFG_PORT_WIDTH_DRAM_DATA_WIDTH          ),
                .CFG_PORT_WIDTH_LOCAL_DATA_WIDTH     (CFG_PORT_WIDTH_LOCAL_DATA_WIDTH         ),
                .CFG_PORT_WIDTH_ENABLE_ECC           (CFG_PORT_WIDTH_ENABLE_ECC               ),
                .CFG_ADDR_ENCODE_ENABLED             (CFG_ADDR_ENCODE_ENABLED                 )
            )
            ecc_decoder_inst
            (
                .ctl_clk                             (ctl_clk                                 ),
                .ctl_reset_n                         (ctl_reset_n                             ),
                .cfg_local_data_width                (cfg_local_data_width                    ),
                .cfg_dram_data_width                 (cfg_dram_data_width                     ),
                .cfg_enable_ecc                      (cfg_enable_ecc                          ),
                .input_data                          (int_decoder_input_data               [i]),
                .input_addr                          (int_decoder_input_addr               [i]),
                .input_data_valid                    (int_decoder_input_data_valid         [i]),
                .output_data                         (int_decoder_output_data              [i]),
                .output_data_valid                   (int_decoder_output_data_valid        [i]),
                .output_ecc_code                     (int_decoder_output_ecc_code          [i]),
                .err_corrected                       (int_decoder_output_err_corrected     [i]),
                .err_detected                        (int_decoder_output_err_detected      [i]),
                .err_fatal                           (int_decoder_output_err_fatal         [i]),
                .err_sbe                             (int_decoder_output_err_sbe           [i]),
                .err_addr_detected                   (int_decoder_output_err_addr_detected [i]),
                .err_addr                            (int_decoder_output_err_addr          [i])
            );
           
            always @ (posedge ctl_clk or negedge ctl_reset_n)
            begin
                 if (!ctl_reset_n)
                 begin
                      decoder_output_err_addr [(i + 1) * CFG_DECODER_ADDR_WIDTH - 1 : i * CFG_DECODER_ADDR_WIDTH] <= {CFG_DECODER_ADDR_WIDTH{1'b0}};
                 end
                 else
                 begin
                      decoder_output_err_addr [(i + 1) * CFG_DECODER_ADDR_WIDTH - 1 : i * CFG_DECODER_ADDR_WIDTH] <= int_decoder_output_err_addr [i];
                 end
            end


 
            always @ (*)
            begin
                if (i < cfg_data_rate)
                begin
                    if (int_decoder_output_err_detected [i] | int_decoder_output_err_sbe [i] | int_decoder_output_err_addr_detected [i])
                    begin
                        if (int_decoder_output_err_addr_detected [i])
                        begin
                            decoder_output_sbe_combi      [i] = 1'b0;
                            decoder_output_dbe_combi      [i] = 1'b1;
                            decoder_output_addrerr_combi  [i] = 1'b1;
                            decoder_output_data_dbe_combi [i] = 1'b0;
                        end
                        else if (int_decoder_output_err_corrected [i] | int_decoder_output_err_sbe [i])
                        begin
                            decoder_output_sbe_combi      [i] = 1'b1;
                            decoder_output_dbe_combi      [i] = 1'b0;
                            decoder_output_addrerr_combi  [i] = 1'b0;
                            decoder_output_data_dbe_combi [i] = 1'b0;
                        end
                        else if (int_decoder_output_err_fatal [i])
                        begin
                            decoder_output_sbe_combi      [i] = 1'b0;
                            decoder_output_dbe_combi      [i] = 1'b1;
                            decoder_output_addrerr_combi  [i] = 1'b0;
                            decoder_output_data_dbe_combi [i] = 1'b1;
                        end
                        else
                        begin
                            decoder_output_sbe_combi      [i] = 1'b0;
                            decoder_output_dbe_combi      [i] = 1'b0;
                            decoder_output_addrerr_combi  [i] = 1'b0;
                            decoder_output_data_dbe_combi [i] = 1'b0;
                        end
                    end
                    else
                    begin
                        decoder_output_sbe_combi      [i] = 1'b0;
                        decoder_output_dbe_combi      [i] = 1'b0;
                        decoder_output_addrerr_combi  [i] = 1'b0;
                        decoder_output_data_dbe_combi [i] = 1'b0;
                    end
                end
                else
                begin
                    decoder_output_sbe_combi [i]       = 1'b0;
                    decoder_output_dbe_combi [i]       = 1'b0;
                    decoder_output_addrerr_combi [i]   = 1'b0;
                    decoder_output_data_dbe_combi [i]  = 1'b0;
                end
            end
        end
        
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                decoder_output_data_valid_combi_r <= {CFG_ECC_MULTIPLE_INSTANCE{1'b0}};
                decoder_output_sbe_combi_r        <= {CFG_ECC_MULTIPLE_INSTANCE{1'b0}};
                decoder_output_dbe_combi_r        <= {CFG_ECC_MULTIPLE_INSTANCE{1'b0}};
            end
            else
            begin
                decoder_output_data_valid_combi_r <= decoder_output_data_valid_combi;
                decoder_output_sbe_combi_r        <= decoder_output_sbe_combi;
                decoder_output_dbe_combi_r        <= decoder_output_dbe_combi;
            end
        end
        
        always @ (posedge ctl_clk or negedge ctl_reset_n)
        begin
            if (!ctl_reset_n)
            begin
                decoder_output_data       <= {CFG_LOCAL_DATA_WIDTH{1'b0}};
                decoder_output_addr       <= {CFG_LOCAL_ADDR_WIDTH{1'b0}};
                decoder_output_data_valid <= {CFG_ECC_MULTIPLE_INSTANCE{1'b0}};
                decoder_output_ecc_code   <= {(CFG_ECC_MULTIPLE_INSTANCE * CFG_ECC_CODE_WIDTH){1'b0}};
                decoder_output_data_id    <= {CFG_LOCAL_ID_WIDTH{1'b0}};
                decoder_output_sbe        <= {CFG_ECC_MULTIPLE_INSTANCE{1'b0}};
                decoder_output_dbe        <= {CFG_ECC_MULTIPLE_INSTANCE{1'b0}};
                decoder_output_data_dbe   <= {CFG_ECC_MULTIPLE_INSTANCE{1'b0}};
                decoder_output_addrerr    <= {CFG_ECC_MULTIPLE_INSTANCE{1'b0}};
            end
            else
            begin
                if (int_slave_rd_data_ready || partial_read_data_returned_combi || empty_read_data_returned_combi)
                begin
                    decoder_output_data       <= decoder_output_data_combi;
                    decoder_output_addr       <= decoder_input_addr;
                    decoder_output_data_valid <= decoder_output_data_valid_combi;   
                    decoder_output_ecc_code   <= decoder_output_ecc_code_combi;
                    decoder_output_data_id    <= decoder_output_data_id_combi;
                    decoder_output_sbe        <= decoder_output_sbe_combi;          
                    decoder_output_dbe        <= decoder_output_dbe_combi;          
                    decoder_output_data_dbe   <= decoder_output_data_dbe_combi;     
                    decoder_output_addrerr    <= decoder_output_addrerr_combi;      
                end
            end
        end


        assign sts_current_addr = current_addr;

        assign  sts_corr_dropped_valid         = cfg_enable_auto_corr && push_to_error_address_fifo && error_address_fifo_full;

    endgenerate

    assign read_address_fifo_wr      = slave_cmd_ready & int_slave_cmd_rd & int_slave_cmd_valid; 
    assign read_address_fifo_wr_data = {int_slave_cmd_size, int_slave_cmd_addr};
    assign read_address_fifo_rd      = pop_from_read_address_fifo;
    
    assign {read_address_fifo_size, read_address_fifo_addr} = read_address_fifo_rd_data;
    
    altera_emif_io_hmc_fifo #
    (
        .CFG_ADDR_WIDTH         (READ_FIFO_ADDR_WIDTH               ),
        .CFG_DATA_WIDTH         (READ_FIFO_DATA_WIDTH               ),
        .CFG_REGISTERED_OUTPUT  (READ_FIFO_REGISTERED_OUTPUT        ),
        .CFG_SHOWAHEAD          (READ_FIFO_SHOWAHEAD                )
    )
    read_address_fifo
    (
        .ctl_clk                (ctl_clk                            ),
        .ctl_reset_n            (ctl_reset_n                        ),
        .write_request          (read_address_fifo_wr               ),
        .write_data             (read_address_fifo_wr_data          ),
        .read_request           (read_address_fifo_rd               ),
        .read_data              (read_address_fifo_rd_data          ),
        .read_data_valid        (read_address_fifo_rd_data_valid    ),
        .fifo_empty             (read_address_fifo_empty            ),
        .fifo_full              (read_address_fifo_full             )
    );
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            read_size_counter <= {CFG_LOCAL_SIZE_WIDTH{1'b0}};
        end
        else
        begin
            if (pop_from_read_address_fifo) 
            begin
                read_size_counter <= read_address_fifo_size;
            end
            else if (normal_read_data_returned_combi)
            begin
                if (read_size_counter != {CFG_LOCAL_SIZE_WIDTH{1'b0}})
                begin
                    read_size_counter <= read_size_counter - 1'b1;
                end
            end
        end
    end
    
    always @ (*)
    begin
        if (!read_address_fifo_empty && ((read_size_counter == 0) || last_read_data == 1'b1))
        begin
            pop_from_read_address_fifo = 1'b1;
        end
        else
        begin
            pop_from_read_address_fifo = 1'b0;
        end
    end
    
    always @ (*)
    begin
        if (normal_read_data_returned_combi && read_size_counter == 1)
        begin
            last_read_data = 1'b1;
        end
        else
        begin
            last_read_data = 1'b0;
        end
    end
    
    generate
        for (i = 0; i < CFG_LOCAL_ADDR_WIDTH; i = i + 1)
        begin : addr_loop
            always @ (*)
            begin
                if (i == cfg_addr_width)
                begin
                    int_current_addr_overflow [i] = 1'b1;
                end
                else
                begin
                    int_current_addr_overflow [i] = 1'b0;
                end
            end
        end
    endgenerate
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_current_addr <= {CFG_LOCAL_ADDR_WIDTH{1'b0}};
        end
        else
        begin
            if (pop_from_read_address_fifo)
            begin
                int_current_addr <= read_address_fifo_addr;
            end
            else if (normal_read_data_returned_combi)
            begin
                if ((int_current_addr + 1'b1) == int_current_addr_overflow)
                begin
                    int_current_addr <= {CFG_LOCAL_ADDR_WIDTH{1'b0}};
                end
                else
                begin
                    int_current_addr <= int_current_addr + 1'b1; 
                end
            end
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            current_addr <= {CFG_LOCAL_ADDR_WIDTH{1'b0}};
        end
        else
        begin
                current_addr <= int_current_addr;
        end
    end
    

    assign error_address_fifo_wr      = cfg_enable_auto_corr & push_to_error_address_fifo & ~error_address_fifo_full; 
    assign error_address_fifo_wr_data = (cfg_enable_dm == 1'b1 || cfg_data_rate == 4'd8) ? {{{(CFG_LOCAL_SIZE_WIDTH - 1){1'b0}}, 1'b1}, current_addr} : {{{(CFG_LOCAL_SIZE_WIDTH - 2){1'b0}}, 2'd2}, {current_addr[CFG_LOCAL_ADDR_WIDTH - 1 : 1], 1'b0}}; 
    assign error_address_fifo_rd      = pop_from_error_address_fifo;
    
    assign {error_address_fifo_size, error_address_fifo_addr} = error_address_fifo_rd_data;
    
    altera_emif_io_hmc_fifo #
    (
        .CFG_ADDR_WIDTH         (ERROR_FIFO_ADDR_WIDTH              ),
        .CFG_DATA_WIDTH         (ERROR_FIFO_DATA_WIDTH              ),
        .CFG_REGISTERED_OUTPUT  (ERROR_FIFO_REGISTERED_OUTPUT       ),
        .CFG_SHOWAHEAD          (ERROR_FIFO_SHOWAHEAD               )
    )
    error_address_fifo
    (
        .ctl_clk                (ctl_clk                            ),
        .ctl_reset_n            (ctl_reset_n                        ),
        .write_request          (error_address_fifo_wr              ),
        .write_data             (error_address_fifo_wr_data         ),
        .read_request           (error_address_fifo_rd              ),
        .read_data              (error_address_fifo_rd_data         ),
        .read_data_valid        (error_address_fifo_rd_data_valid   ),
        .fifo_empty             (error_address_fifo_empty           ),
        .fifo_full              (error_address_fifo_full            )
    );

    always @ (*)
    begin
        if (|decoder_output_sbe && normal_read_data_returned) 
        begin
            push_to_error_address_fifo = 1'b1;
        end
        else
        begin
            push_to_error_address_fifo = 1'b0;
        end
    end
    
    always @ (*)
    begin
        if (
                !error_address_fifo_empty &&                                            
                !error_cmd_valid &&                                                     
                !error_wr_data_valid &&                                                 
                 pending_write_data_counter == {CFG_PENDING_WRITE_DATA_WIDTH{1'b0}} &&  
                !data_before_write_command                                              
           )
        begin
            pop_from_error_address_fifo = 1'b1;
        end
        else
        begin
            pop_from_error_address_fifo = 1'b0;
        end
    end
    

    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            pending_write_data_counter           <= {CFG_PENDING_WRITE_DATA_WIDTH{1'b0}};
            pending_write_data_counter_underflow <= 1'b0;
        end
        else
        begin
            if (slave_cmd_ready && int_slave_cmd_valid && int_slave_cmd_wr) 
            begin
                pending_write_data_counter_underflow <= 1'b0;
                
                if (slave_wr_data_ready && int_slave_wr_data_valid) 
                begin
                    pending_write_data_counter <= pending_write_data_counter + int_slave_cmd_size - 1'b1;
                end
                else
                begin
                    pending_write_data_counter <= pending_write_data_counter + int_slave_cmd_size;
                end
            end
            else if (slave_wr_data_ready && int_slave_wr_data_valid) 
            begin
                if (pending_write_data_counter == {CFG_PENDING_WRITE_DATA_WIDTH{1'b0}})
                begin
                    pending_write_data_counter_underflow <= 1'b1; 
                end
                else
                begin
                    pending_write_data_counter_underflow <= 1'b0;
                end
                
                pending_write_data_counter <= pending_write_data_counter - 1'b1; 
            end
        end
    end
    
    always @ (*)
    begin
        if (is_ast)
        begin
            if (pending_write_data_counter == {CFG_PENDING_WRITE_DATA_WIDTH{1'b0}} && slave_wr_data_ready && int_slave_wr_data_valid) 
            begin
                data_before_write_command = 1'b1;
            end
            else
            begin
                data_before_write_command = pending_write_data_counter_underflow;
            end
        end
        else
        begin
            data_before_write_command = 1'b0;
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            error_cmd_addr           <= {CFG_LOCAL_ADDR_WIDTH{1'b0}};
            error_cmd_size           <= {CFG_LOCAL_SIZE_WIDTH{1'b0}};
            error_cmd_size_decrement <= {CFG_LOCAL_SIZE_WIDTH{1'b0}};
            error_cmd_valid          <= 1'b0;
        end
        else
        begin
            if (pop_from_error_address_fifo) 
            begin
                error_cmd_addr           <= error_address_fifo_addr;
                error_cmd_size           <= error_address_fifo_size;
                error_cmd_size_decrement <= error_address_fifo_size;
                error_cmd_valid          <= 1'b1;
            end
            else
            begin
                if (internal_master_cmd_ready) 
                begin
                    error_cmd_addr  <= {CFG_LOCAL_ADDR_WIDTH{1'b0}};
                    error_cmd_size  <= {CFG_LOCAL_SIZE_WIDTH{1'b0}};
                    error_cmd_valid <= 1'b0;
                end
                
                if (issuing_dummy_write_data) 
                begin
                    error_cmd_size_decrement <= error_cmd_size_decrement - 1'b1;
                end
            end
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            error_wr_addr <= {CFG_LOCAL_ADDR_WIDTH{1'b0}};
        end
        else
        begin
            if (pop_from_error_address_fifo)
            begin
                error_wr_addr <= error_address_fifo_addr;
            end
            else if (issuing_dummy_write_data)
            begin
                error_wr_addr <= error_wr_addr + 1'b1;
            end
        end
    end
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            error_wr_data_valid <= 1'b0;
        end
        else
        begin
            if (pop_from_error_address_fifo)
            begin
                error_wr_data_valid <= 1'b1;
            end
            else if (int_master_wr_data_ready && !(partial_read_data_returned | empty_read_data_returned | (|pending_data_valid & ~load_pending_data)) && error_cmd_size_decrement == 1) 
            begin
                error_wr_data_valid <= 1'b0;
            end
        end
    end
    
    always @ (*)
    begin
        issuing_dummy_write_command        = error_cmd_valid & internal_master_cmd_ready; 
        issuing_dummy_write_data_non_gated = error_wr_data_valid & ~(partial_read_data_returned | empty_read_data_returned | (|pending_data_valid & ~load_pending_data)); 
        issuing_dummy_write_data           = issuing_dummy_write_data_non_gated & int_master_wr_data_ready; 
    end
    
    always @ (*)
    begin
        if (CFG_LOCAL_SIZE_WIDTH >= 8) begin
            error_cmd_size_padded = error_cmd_size;
        end else begin
            error_cmd_size_padded = {{(8 - CFG_LOCAL_SIZE_WIDTH){1'b0}}, error_cmd_size};
        end

        if (CFG_LOCAL_ADDR_WIDTH >= 35) begin
            error_cmd_addr_padded = error_cmd_addr;
        end else begin
            error_cmd_addr_padded = {{(35 - CFG_LOCAL_ADDR_WIDTH){1'b0}}, error_cmd_addr};
        end          
    
        if (error_cmd_valid)
        begin
            int_cmd_data  = {
                                {CFG_LOCAL_ID_WIDTH{1'b0}}, 
                                1'b0,                       
                                1'b1,                       
                                1'b0,                       
                                error_cmd_size_padded,      
                                error_cmd_addr_padded,      
                                1'b1,                       
                                1'b0                        
                            };
            int_cmd_valid = 1'b1;
        end
        else
        begin
            int_cmd_data  = int_slave_cmd_data;
            int_cmd_valid = int_slave_cmd_valid & ~pop_from_error_address_fifo; 
        end
    end

    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            sts_ecc_intr           <= {STS_PORT_WIDTH_ECC_INTR{1'b0}};
            sts_sbe_error          <= {STS_PORT_WIDTH_SBE_ERROR{1'b0}};
            sts_dbe_error          <= {STS_PORT_WIDTH_DBE_ERROR{1'b0}};
            sts_corr_dropped       <= {STS_PORT_WIDTH_CORR_DROPPED{1'b0}};
            sts_sbe_count          <= {STS_PORT_WIDTH_SBE_COUNT{1'b0}};
            sts_dbe_count          <= {STS_PORT_WIDTH_DBE_COUNT{1'b0}};
            sts_corr_dropped_count <= {STS_PORT_WIDTH_CORR_DROPPED_COUNT{1'b0}};
            sts_err_addr           <= {STS_PORT_WIDTH_ERR_ADDR{1'b0}};
            sts_corr_dropped_addr  <= {STS_PORT_WIDTH_CORR_DROPPED_ADDR{1'b0}};
            sts_mr_rdata_0         <= {STS_PORT_WIDTH_MR_DATA{1'b0}};
            sts_mr_rdata_1         <= {STS_PORT_WIDTH_MR_DATA{1'b0}};
            sts_mr_rdata_valid     <= 1'b0;
        end
        else
        begin
            if (cfg_enable_intr)
            begin
                if (cfg_clr_intr)
                begin
                    sts_ecc_intr           <= {STS_PORT_WIDTH_ECC_INTR{1'b0}};
                    sts_sbe_error          <= {STS_PORT_WIDTH_SBE_ERROR{1'b0}};
                    sts_dbe_error          <= {STS_PORT_WIDTH_DBE_ERROR{1'b0}};
                    sts_corr_dropped       <= {STS_PORT_WIDTH_CORR_DROPPED{1'b0}};
                    sts_sbe_count          <= {STS_PORT_WIDTH_SBE_COUNT{1'b0}};
                    sts_dbe_count          <= {STS_PORT_WIDTH_DBE_COUNT{1'b0}};
                    sts_corr_dropped_count <= {STS_PORT_WIDTH_CORR_DROPPED_COUNT{1'b0}};
                    sts_err_addr           <= {STS_PORT_WIDTH_ERR_ADDR{1'b0}};
                    sts_corr_dropped_addr  <= {STS_PORT_WIDTH_CORR_DROPPED_ADDR{1'b0}};
                end
                else
                begin
                    if (|decoder_output_sbe_combi_r && |decoder_output_data_valid_combi_r) 
                    begin
                        if (!cfg_mask_sbe_intr)
                        begin
                            sts_ecc_intr <= 1'b1;
                        end
                        
                        sts_sbe_error <= 1'b1;
                        sts_sbe_count <= sts_sbe_count + 1'b1;
                        sts_err_addr  <= current_addr;
                    end
                    
                    if (|decoder_output_dbe_combi_r && |decoder_output_data_valid_combi_r) 
                    begin
                        if (!cfg_mask_dbe_intr)
                        begin
                            sts_ecc_intr <= 1'b1;
                        end
                        
                        sts_dbe_error <= 1'b1;
                        sts_dbe_count <= sts_dbe_count + 1'b1;
                        sts_err_addr  <= current_addr;
                    end
                    
                    if (cfg_enable_auto_corr && push_to_error_address_fifo && error_address_fifo_full) 
                    begin
                        if (!cfg_mask_corr_dropped_intr)
                        begin
                            sts_ecc_intr <= 1'b1;
                        end
                        
                        sts_corr_dropped       <= 1'b1;
                        sts_corr_dropped_count <= sts_corr_dropped_count + 1'b1;
                        sts_corr_dropped_addr  <= current_addr;
                    end
                    
                    if (!cfg_mask_hmi_intr && hmi_interrupt) 
                    begin
                        sts_ecc_intr <= 1'b1;
                    end
                end
            end
            
            if (cfg_clr_mr_rdata)
            begin
                sts_mr_rdata_0     <= {STS_PORT_WIDTH_MR_DATA{1'b0}};
                sts_mr_rdata_1     <= {STS_PORT_WIDTH_MR_DATA{1'b0}};
                sts_mr_rdata_valid <= 1'b0;
            end
            else
            begin
                if (int_master_rd_data_valid && !int_master_rd_data_valid_r && int_master_rd_data_info [CFG_LOCAL_DATA_INFO_WIDTH - 1])
                begin
                    sts_mr_rdata_0 <= int_master_rd_data;
                end
                
                if (int_master_rd_data_valid &&  int_master_rd_data_valid_r && int_master_rd_data_info [CFG_LOCAL_DATA_INFO_WIDTH - 1] && cfg_data_rate == 4'd4) 
                begin
                    sts_mr_rdata_1 <= int_master_rd_data;
                end
                
                if (cfg_clr_mr_rdata)
                begin
                    sts_mr_rdata_valid <= 1'b0;
                end
                else if (cfg_data_rate == 4'd4 && int_master_rd_data_valid &&  int_master_rd_data_valid_r && int_master_rd_data_info [CFG_LOCAL_DATA_INFO_WIDTH - 1]) 
                begin
                    sts_mr_rdata_valid <= 1'b1;
                end
                else if (cfg_data_rate == 4'd8 && int_master_rd_data_valid && !int_master_rd_data_valid_r && int_master_rd_data_info [CFG_LOCAL_DATA_INFO_WIDTH - 1]) 
                begin
                    sts_mr_rdata_valid <= 1'b1;
                end
            end
        end
    end
    
    
    always @ (posedge ctl_clk or negedge ctl_reset_n)
    begin
        if (!ctl_reset_n)
        begin
            int_master_rd_data_valid_r <= 1'b0;
        end
        else
        begin
            int_master_rd_data_valid_r <= int_master_rd_data_valid;
        end
    end
    
    
    always @ (*)
    begin
        user_interrupt = sts_ecc_intr;
    end

function integer log2;
    input integer value;
    begin
        value = value - 'd1;
        for (log2 = 'd0; value > 0; log2 = log2 + 'd1)
            value = value >>  'd1;
    end
endfunction

endmodule
