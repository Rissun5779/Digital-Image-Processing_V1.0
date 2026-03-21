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


module altera_emif_avl_tg_2_traffic_gen #(
   parameter NUMBER_OF_DATA_GENERATORS       = "",
   parameter NUMBER_OF_BYTE_EN_GENERATORS    = "",
   parameter AMM_CFG_ADDR_WIDTH              = "", //avalon cfg address width from driver control block
   parameter AMM_CFG_DATA_WIDTH              = "", //avalon cfg data width from driver control block
   //Corresponds to memory data rate, 8 for quarter-rate, 4 for half-rate
   parameter DATA_RATE_WIDTH_RATIO           = "",
   //Sequence length of the pattern to be written to DQ pins
   //Legal values: 8, 16, 32
   parameter DATA_PATTERN_LENGTH             = "",
   //Sequence length of the pattern for the byte enables
   parameter BYTE_EN_PATTERN_LENGTH          = "",
   //A total count of reads for the driver
   parameter OP_COUNT_WIDTH                  = "",
   //rw generator counter widths - will dictate maxima for configurable values
   parameter RW_RPT_COUNT_WIDTH              = "",
   parameter RW_OPERATION_COUNT_WIDTH        = "",
   parameter RW_LOOP_COUNT_WIDTH             = "",
   parameter RAND_SEQ_CNT_WIDTH              = 8,
   parameter SEQ_ADDR_INCR_WIDTH             = 8,
   //address generator params
   parameter MEM_ADDR_WIDTH                  = "", //memory address width
   //width of the row address bits
   parameter ROW_ADDR_WIDTH                  = "",
   //bit location of the LSB of the row address within the total address
   parameter ROW_ADDR_LSB                    = "",
   parameter RANK_ADDR_WIDTH                 = "",
   parameter RANK_ADDR_LSB                   = "",
   parameter BANK_ADDR_WIDTH                 = "",
   parameter BANK_ADDR_LSB                   = "",
   parameter BANK_GROUP_WIDTH                = "",
   parameter BANK_GROUP_LSB                  = "",
   parameter AMM_BURSTCOUNT_WIDTH            = "",
   parameter MEM_DATA_WIDTH                  = "",
   parameter MEM_RDATA_WIDTH                 = "",
   parameter MEM_BE_WIDTH                    = "",
   parameter AMM_WORD_ADDRESS_WIDTH          = "",
   parameter USE_AVL_BYTEEN                  = "",
   parameter NUM_OF_CTRL_PORTS               = "",
   parameter AMM_BURST_COUNT_DIVISIBLE_BY    = "",
   parameter AMM_WORD_ADDRESS_DIVISIBLE_BY   = "",
   parameter SEPARATE_READ_WRITE_IFS         = "",
   // Random seed for data generator
   parameter TG_LFSR_SEED                    = 36'b000000111110000011110000111000110010,

   // If set to true, the unix_id will be added to the MSB bit of
   // the generated address. This is usefull to avoid address
   // overlapping when more than one traffic generator being
   // connected to the same slave.
   parameter TG_ENABLE_UNIX_ID                      = 0,
   parameter TG_USE_UNIX_ID                         = 3'b000

   )(
   input    clk,
   input    rst,
   output   tg_restart,

   //Driver control block AMM interface signals
   input        [AMM_CFG_ADDR_WIDTH-1:0]  amm_cfg_address,
   input        [AMM_CFG_DATA_WIDTH-1:0]  amm_cfg_writedata,
   output reg   [AMM_CFG_DATA_WIDTH-1:0]  amm_cfg_readdata,
   input                                  amm_cfg_write,
   input                                  amm_cfg_read,
   output                                 amm_cfg_waitrequest,
   output reg                             amm_cfg_readdatavalid,

   //Memory controller AMM interface signals
   output                              amm_ctrl_write,
   output                              amm_ctrl_read,
   output [MEM_ADDR_WIDTH-1:0]         amm_ctrl_address,
   output [MEM_DATA_WIDTH-1:0]         amm_ctrl_writedata,
   output [MEM_BE_WIDTH-1:0]           amm_ctrl_byteenable,
   input                               amm_ctrl_ready,
   input                               amm_ctrl_readdatavalid,
   input  [MEM_DATA_WIDTH-1:0]         amm_ctrl_readdata,
   output [AMM_BURSTCOUNT_WIDTH-1:0]   amm_ctrl_burstcount,

   output [MEM_ADDR_WIDTH-1:0]         amm_ctrl_address_w,
   input                               amm_ctrl_ready_w,
   output [AMM_BURSTCOUNT_WIDTH-1:0]   amm_ctrl_burstcount_w,

   //Expected data for comparison in status checker
   output [MEM_BE_WIDTH-1:0]           ast_exp_data_byteenable,
   output [MEM_DATA_WIDTH-1:0]         ast_exp_data_writedata,
   output [AMM_WORD_ADDRESS_WIDTH-1:0] ast_exp_data_readaddr,

   //Actual data for comparison in status checker
   output                        ast_act_data_readdatavalid,
   output [MEM_DATA_WIDTH-1:0]   ast_act_data_readdata,

   //Status information from the status checker
   output reg                       clear_first_fail,
   output reg                       byteenable_stage,
   input    [MEM_RDATA_WIDTH-1:0]   pnf_per_bit_persist,
   input                            fail,
   input                            pass,
   input    [63:0]                  first_fail_addr,
   input    [63:0]                  failure_count,
   input    [MEM_RDATA_WIDTH-1:0]   first_fail_expected_data,
   input    [MEM_RDATA_WIDTH-1:0]   first_fail_read_data,
   input                            first_failure_occured,

   input    [63:0]                  total_read_count,

   input                            targetted_reads_stage,
   output                           target_first_failing_addr,

   output                           reads_in_prog,
   output logic                     restart_default_traffic,
   input                            worm_en
);
   timeunit 1ns;
   timeprecision 1ps;

   import avl_tg_defs::*;

   //make localparams since the params could have values of 0, which would break register widths
   localparam RANK_ADDR_WIDTH_LOCAL = RANK_ADDR_WIDTH > 0 ? RANK_ADDR_WIDTH : 1;
   localparam BANK_GROUP_WIDTH_LOCAL  = BANK_GROUP_WIDTH > 0 ? BANK_GROUP_WIDTH : 1;
   localparam ROW_ADDR_WIDTH_LOCAL = ROW_ADDR_WIDTH > 0 ? ROW_ADDR_WIDTH : 1;
   localparam BANK_ADDR_WIDTH_LOCAL  = BANK_ADDR_WIDTH > 0 ? BANK_ADDR_WIDTH : 1;
	localparam NUMBER_OF_BYTE_EN_GENERATORS_LOCAL = NUMBER_OF_BYTE_EN_GENERATORS > 0 ? NUMBER_OF_BYTE_EN_GENERATORS : 1;

   localparam DATA_TO_CFG_WIDTH_RATIO = MEM_RDATA_WIDTH / AMM_CFG_DATA_WIDTH;
   localparam MAX_DATA_TO_CFG_MUX_SIZE = 36;

   localparam FIRST_STAGE_DECODER_KEY_WIDTH     = 5;
   localparam SECOND_STAGE_DECODER_KEY_WIDTH    = 5;

   localparam CFG_READ_FIRST_STAGE_DECODER_KEY_WIDTH  = 6;
   localparam CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH = 4;

   localparam WORD_ADDR_SHIFT = ceil_log2(MEM_RDATA_WIDTH / NUMBER_OF_DATA_GENERATORS);

   wire [AMM_WORD_ADDRESS_WIDTH-1:0]  write_addr;
   wire [AMM_WORD_ADDRESS_WIDTH-1:0]  read_addr;

   wire status_check_in_prog;
   wire rw_gen_waitrequest;
   wire controller_ready;
   wire controller_ready_w;
   wire write_req;
   wire read_req;

   wire [MEM_DATA_WIDTH-1:0]     mem_write_data;
   wire [MEM_BE_WIDTH-1:0]       mem_write_be;

   //randomly generated write data
   reg [MEM_DATA_WIDTH-1:0]     lfsr_write_data;
   reg [MEM_BE_WIDTH-1:0]       lfsr_write_be;

   //expected read data
   reg [MEM_DATA_WIDTH-1:0]     lfsr_exp_write_data;
   reg [MEM_BE_WIDTH-1:0]       lfsr_exp_write_be;

   wire [MEM_DATA_WIDTH-1:0]     written_data;
   wire [MEM_BE_WIDTH-1:0]       written_be;

   //user-defined write data
   wire [MEM_DATA_WIDTH-1:0]     fixed_wdata;
   wire [MEM_BE_WIDTH-1:0]       fixed_wbe;

   wire [MEM_DATA_WIDTH-1:0]     fixed_exp_wdata;
   wire [MEM_BE_WIDTH-1:0]       fixed_exp_wbe;

   wire [DATA_RATE_WIDTH_RATIO-1:0] fixed_write_data   [0:NUMBER_OF_DATA_GENERATORS-1];
   wire [DATA_RATE_WIDTH_RATIO-1:0] fixed_write_be     [0:NUMBER_OF_BYTE_EN_GENERATORS_LOCAL-1];

   wire [DATA_RATE_WIDTH_RATIO-1:0] fixed_exp_write_data   [0:NUMBER_OF_DATA_GENERATORS-1];
   wire [DATA_RATE_WIDTH_RATIO-1:0] fixed_exp_write_be     [0:NUMBER_OF_BYTE_EN_GENERATORS_LOCAL-1];

   reg [1:0] data_gen_mode;
   reg [1:0] byte_en_gen_mode;

   //load for data generators
   reg [NUMBER_OF_DATA_GENERATORS-1:0] data_gen_load;

   //load for byte enable generators
   reg [NUMBER_OF_BYTE_EN_GENERATORS_LOCAL-1:0] byte_en_load;

   //enables from r/w generator to address generators
   wire next_addr_read;
   wire next_addr_write;
   wire next_data_read;
   wire next_data_write;

   wire [AMM_CFG_DATA_WIDTH-1:0] pnf_to_cfg_mux_signal [0:MAX_DATA_TO_CFG_MUX_SIZE-1];
   wire [AMM_CFG_DATA_WIDTH-1:0] exp_data_to_cfg_mux_signal [0:MAX_DATA_TO_CFG_MUX_SIZE-1];
   wire [AMM_CFG_DATA_WIDTH-1:0] read_data_to_cfg_mux_signal [0:MAX_DATA_TO_CFG_MUX_SIZE-1];

   //memory mapped registers
   reg [RW_LOOP_COUNT_WIDTH-1:0]      rw_gen_loop_cnt;
   reg [RW_OPERATION_COUNT_WIDTH-1:0] rw_gen_write_cnt;
   reg [RW_OPERATION_COUNT_WIDTH-1:0] rw_gen_read_cnt;
   reg [RW_RPT_COUNT_WIDTH-1:0]       rw_gen_write_rpt_cnt;
   reg [RW_RPT_COUNT_WIDTH-1:0]       rw_gen_read_rpt_cnt;
   reg rw_gen_start;
   reg [AMM_BURSTCOUNT_WIDTH-1:0]     burstlength;

   reg [63:0] addr_gen_write_start_addr;
   reg [1:0]                addr_gen_mode_writes;

   reg [63:0] addr_gen_read_start_addr;
   reg [1:0]                addr_gen_mode_reads;

   //2nd layer decoder enables
   reg                              rw_gen_cfg_write;
   reg                              addr_gen_cfg_write;

   reg                              tg_status_cfg_read;
   reg                              tg_cfg_info_cfg_read;

   reg                              tg_pnf_read;
   reg                              tg_fail_exp_data;
   reg                              tg_fail_read_data;

   //timing pipeline
   reg                              amm_cfg_waitrequest_r;
   reg                              amm_cfg_read_r;
   reg [AMM_CFG_ADDR_WIDTH-1:0]     amm_cfg_address_r;
   reg [AMM_CFG_DATA_WIDTH-1:0]     amm_cfg_writedata_r;

   reg [1:0]                        addr_gen_rank_mask_en;
   reg [1:0]                        addr_gen_bank_mask_en;
   reg [1:0]                        addr_gen_bankgroup_mask_en;
   reg [1:0]                        addr_gen_row_mask_en;
   reg [RANK_ADDR_WIDTH_LOCAL-1:0]  addr_gen_rank_mask;
   reg [BANK_ADDR_WIDTH-1:0]        addr_gen_bank_mask;
   reg [ROW_ADDR_WIDTH-1:0]         addr_gen_row_mask;
   reg [BANK_GROUP_WIDTH_LOCAL-1:0] addr_gen_bankgroup_mask;

   //return to start address between write/read blocks for sequential addressing
   reg addr_gen_seq_return_to_start_addr;
   //number of sequential addresses to produce between random addresses for random sequential addressing
   reg [RAND_SEQ_CNT_WIDTH-1:0] addr_gen_rseq_num_seq_addr_write;
   reg [RAND_SEQ_CNT_WIDTH-1:0] addr_gen_rseq_num_seq_addr_read;
   //increment size for sequential or random sequential addressing. This is the increment to the avalon address
   reg [SEQ_ADDR_INCR_WIDTH-1:0] addr_gen_seq_addr_incr;

   reg         emergency_brake_asserted;
   reg [31:0]  config_error_report_reg;

   assign target_first_failing_addr = worm_en;

   int j;
   generate
  //two-stage decoder for mapped registers
   always @ (posedge clk, posedge rst)
   begin
      if (rst) begin
         //default initial assignments
         addr_gen_seq_return_to_start_addr   <= '0;
         addr_gen_rank_mask_en               <= 1'b0;
         addr_gen_bank_mask_en               <= 1'b0;
         addr_gen_row_mask_en                <= 1'b0;
         addr_gen_bankgroup_mask_en          <= 1'b0;
         rw_gen_loop_cnt                     <= 1'b1;
         rw_gen_write_cnt                    <= '0;
         rw_gen_read_cnt                     <= '0;
         rw_gen_write_rpt_cnt                <= 1'b1;
         rw_gen_read_rpt_cnt                 <= 1'b1;
         addr_gen_rseq_num_seq_addr_write    <= 1'b1;
         addr_gen_rseq_num_seq_addr_read     <= 1'b1;
         burstlength                         <= 1'b1;
         addr_gen_seq_addr_incr              <= 1'b1;
         addr_gen_mode_writes                <= 2'h2;
         addr_gen_mode_reads                 <= 2'h2;
         amm_cfg_readdata                    <= '0;
         amm_cfg_readdatavalid               <= 1'b0;
         clear_first_fail                    <= 1'b0;
         byteenable_stage                    <= 1'b0;
         rw_gen_start                        <= 1'b0;
         restart_default_traffic             <= 1'b0;
         amm_cfg_read_r                      <= 1'b0;
         rw_gen_cfg_write                    <= 1'b0;
         addr_gen_cfg_write                  <= 1'b0;
         tg_status_cfg_read                  <= 1'b0;
         tg_cfg_info_cfg_read                <= 1'b0;
         tg_pnf_read                         <= 1'b0;
         tg_fail_exp_data                    <= 1'b0;
         tg_fail_read_data                   <= 1'b0;
         data_gen_mode                       <= 2'b0;
         byte_en_gen_mode                    <= 2'b0;
         data_gen_load                       <= '0;
         byte_en_load                        <= '0;
         amm_cfg_waitrequest_r               <= 1'b1;
         emergency_brake_asserted            <= 1'b0;
      end
      else begin

         amm_cfg_waitrequest_r               <= rw_gen_waitrequest | status_check_in_prog;

         //defaults applied each clock cycle
         rw_gen_start  <= 1'b0;
         restart_default_traffic  <= 1'b0;
         amm_cfg_readdata <= '0;
         amm_cfg_readdatavalid <= 1'b0;
         clear_first_fail <= 1'b0;

            amm_cfg_address_r    <= amm_cfg_address;

            amm_cfg_writedata_r  <= amm_cfg_writedata;

         if (amm_cfg_write && !amm_cfg_waitrequest) begin
            //Configuration of the data generator (seed)
            //The seed for data generator N can be found at address 100+N
            for (j = 0; j < NUMBER_OF_DATA_GENERATORS; j = j + 1) begin: write_seed
               if(amm_cfg_address == TG_DATA_SEED+j) begin
                  data_gen_load[j]           <= 1'b1;
               end else begin
                  data_gen_load[j]           <= 1'b0;
               end
            end

            //Configuration of the byte enable generator (seed)
            //The seed for byte enable generator N can be found at address 1A0+N
            for (j = 0; j < NUMBER_OF_BYTE_EN_GENERATORS_LOCAL; j = j + 1) begin: byte_en_seed
               if(amm_cfg_address == TG_BYTEEN_SEED+j) begin
                  byte_en_load[j]            <= 1'b1;
               end else begin
                  byte_en_load[j]            <= 1'b0;
               end
            end
         end

         if (amm_cfg_address[FIRST_STAGE_DECODER_KEY_WIDTH + SECOND_STAGE_DECODER_KEY_WIDTH - 1:SECOND_STAGE_DECODER_KEY_WIDTH] < TG_SEQ_START_ADDR_WR_L[FIRST_STAGE_DECODER_KEY_WIDTH + SECOND_STAGE_DECODER_KEY_WIDTH - 1:SECOND_STAGE_DECODER_KEY_WIDTH]) begin
            rw_gen_cfg_write      <= amm_cfg_write;
            addr_gen_cfg_write    <= 1'b0;
         end else if ((amm_cfg_address[FIRST_STAGE_DECODER_KEY_WIDTH + SECOND_STAGE_DECODER_KEY_WIDTH - 1:SECOND_STAGE_DECODER_KEY_WIDTH] >= TG_SEQ_START_ADDR_WR_L[FIRST_STAGE_DECODER_KEY_WIDTH + SECOND_STAGE_DECODER_KEY_WIDTH - 1:SECOND_STAGE_DECODER_KEY_WIDTH]) && (amm_cfg_address[FIRST_STAGE_DECODER_KEY_WIDTH + SECOND_STAGE_DECODER_KEY_WIDTH - 1:SECOND_STAGE_DECODER_KEY_WIDTH] < TG_PASS[FIRST_STAGE_DECODER_KEY_WIDTH + SECOND_STAGE_DECODER_KEY_WIDTH - 1:SECOND_STAGE_DECODER_KEY_WIDTH])) begin
            rw_gen_cfg_write      <= 1'b0;
            addr_gen_cfg_write    <= amm_cfg_write;
         end else begin
            rw_gen_cfg_write      <= 1'b0;
            addr_gen_cfg_write    <= 1'b0;
         end

         if (amm_cfg_address[CFG_READ_FIRST_STAGE_DECODER_KEY_WIDTH + CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH - 1:CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH] == TG_PASS[CFG_READ_FIRST_STAGE_DECODER_KEY_WIDTH + CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH - 1:CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH]) begin
            tg_status_cfg_read   <= amm_cfg_read;
            tg_cfg_info_cfg_read <= 1'b0;
            amm_cfg_read_r       <= 1'b0;
         end else if (amm_cfg_address[CFG_READ_FIRST_STAGE_DECODER_KEY_WIDTH + CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH - 1:CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH] == TG_VERSION[CFG_READ_FIRST_STAGE_DECODER_KEY_WIDTH + CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH - 1:CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH]) begin
            tg_status_cfg_read   <= 1'b0;
            tg_cfg_info_cfg_read <= amm_cfg_read;
            amm_cfg_read_r       <= 1'b0;
         end else begin
            tg_status_cfg_read   <= 1'b0;
            tg_cfg_info_cfg_read <= 1'b0;
            amm_cfg_read_r       <= amm_cfg_read;
         end

         if (rw_gen_cfg_write && !amm_cfg_waitrequest_r) begin
            //The following configuration descriptions can be found in the functional description of the traffic driver
            case(amm_cfg_address_r[SECOND_STAGE_DECODER_KEY_WIDTH-1:0])
               //Starts the R/W Generator
               TG_START[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:                     rw_gen_start               <= 1'b1;
               //Number of write and read blocks
               TG_LOOP_COUNT[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:                rw_gen_loop_cnt            <= amm_cfg_writedata_r [RW_LOOP_COUNT_WIDTH-1:0];
               //Number of block writes
               TG_WRITE_COUNT[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:               rw_gen_write_cnt           <= amm_cfg_writedata_r [RW_OPERATION_COUNT_WIDTH-1:0];
               //Number of block reads
               TG_READ_COUNT[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:                rw_gen_read_cnt            <= amm_cfg_writedata_r [RW_OPERATION_COUNT_WIDTH-1:0];
               //Number of write repeats
               TG_WRITE_REPEAT_COUNT[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:        rw_gen_write_rpt_cnt       <= amm_cfg_writedata_r [RW_RPT_COUNT_WIDTH-1:0];
               //Number of read repeats
               TG_READ_REPEAT_COUNT[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:         rw_gen_read_rpt_cnt        <= amm_cfg_writedata_r [RW_RPT_COUNT_WIDTH-1:0];
               //The burstlength size (also referred to as burstcount or burstsize)
               TG_BURST_LENGTH[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:              burstlength                <= amm_cfg_writedata_r [AMM_BURSTCOUNT_WIDTH-1:0];
               //clear first fail
               TG_CLEAR_FIRST_FAIL[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:          clear_first_fail           <= 1'b1;
               TG_TEST_BYTEEN[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:               byteenable_stage           <= amm_cfg_writedata_r [0];
               TG_RESTART_DEFAULT_TRAFFIC[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:   restart_default_traffic    <= 1'b1;
               TG_DATA_MODE[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:                 data_gen_mode              <= amm_cfg_writedata_r [1:0];
               TG_BYTEEN_MODE[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:               byte_en_gen_mode           <= amm_cfg_writedata_r [1:0];
               // synthesis translate_off
               default:
                  $display("Error: Invalid write address range in module:traffic_gen.v");
               // synthesis translate_on
            endcase
         end

         if( addr_gen_cfg_write && !amm_cfg_waitrequest_r) begin
            case(amm_cfg_address_r[SECOND_STAGE_DECODER_KEY_WIDTH-1:0])
               //write address generator
               //Start address for sequential mode
               TG_SEQ_START_ADDR_WR_L[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: addr_gen_write_start_addr [31:0]    <= amm_cfg_writedata_r;
               TG_SEQ_START_ADDR_WR_H[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: addr_gen_write_start_addr [63:32]   <= amm_cfg_writedata_r;
               //Mode of the address
               TG_ADDR_MODE_WR[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:                   addr_gen_mode_writes     <= amm_cfg_writedata_r [1:0];
               TG_RAND_SEQ_ADDRS_WR[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: addr_gen_rseq_num_seq_addr_write      <= amm_cfg_writedata_r [RAND_SEQ_CNT_WIDTH-1:0];
               TG_RETURN_TO_START_ADDR[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: addr_gen_seq_return_to_start_addr  <= amm_cfg_writedata_r [0];

               //disable masking when only 1 or 0 ranks or bank groups
               //Mask enables allow the user to cycle through certain address sections
               TG_RANK_MASK_EN[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:  addr_gen_rank_mask_en         <= amm_cfg_writedata_r [1:0];
               TG_BANK_MASK_EN[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:  addr_gen_bank_mask_en         <= amm_cfg_writedata_r [1:0];
               TG_ROW_MASK_EN[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:   addr_gen_row_mask_en          <= amm_cfg_writedata_r [1:0];
               TG_RANK_MASK[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:     addr_gen_rank_mask            <= amm_cfg_writedata_r [RANK_ADDR_WIDTH_LOCAL-1:0];
               TG_BANK_MASK[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:     addr_gen_bank_mask            <= amm_cfg_writedata_r [BANK_ADDR_WIDTH_LOCAL-1:0];
               TG_ROW_MASK[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:      addr_gen_row_mask             <= amm_cfg_writedata_r [ROW_ADDR_WIDTH_LOCAL-1:0];
               TG_BG_MASK[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:       addr_gen_bankgroup_mask       <= amm_cfg_writedata_r [BANK_GROUP_WIDTH_LOCAL-1:0];
               TG_BG_MASK_EN[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:    addr_gen_bankgroup_mask_en    <= amm_cfg_writedata_r [1:0];
               TG_SEQ_ADDR_INCR[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: addr_gen_seq_addr_incr        <= amm_cfg_writedata_r [SEQ_ADDR_INCR_WIDTH-1:0];

               //read address generator
               TG_SEQ_START_ADDR_RD_L[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: addr_gen_read_start_addr [31:0]     <= amm_cfg_writedata_r;
               TG_SEQ_START_ADDR_RD_H[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: addr_gen_read_start_addr [63:32]    <= amm_cfg_writedata_r;
               TG_ADDR_MODE_RD[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:                    addr_gen_mode_reads     <= amm_cfg_writedata_r [1:0];
               TG_RAND_SEQ_ADDRS_RD[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:   addr_gen_rseq_num_seq_addr_read     <= amm_cfg_writedata_r [RAND_SEQ_CNT_WIDTH-1:0];
               // synthesis translate_off
               default:
                  $display("Error: Invalid write address range in module:traffic_gen.v");
               // synthesis translate_on
            endcase
         end

         if (tg_status_cfg_read) begin
            case (amm_cfg_address_r[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0])
               TG_PASS[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: //pass status
                  amm_cfg_readdata[0] <= pass;
               TG_FAIL[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: //fail status
                  amm_cfg_readdata[0] <= fail;
               TG_FAIL_COUNT_L[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: //failure count 1/2
                  amm_cfg_readdata <= failure_count[31:0];
               TG_FAIL_COUNT_H[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: //failure count 2/2
                  amm_cfg_readdata <= failure_count[63:32];
               TG_FIRST_FAIL_ADDR_L[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: //first failure address 1/2
                  amm_cfg_readdata <= first_fail_addr[31:0];
               TG_FIRST_FAIL_ADDR_H[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: //first failure address 2/2
                  amm_cfg_readdata <= first_fail_addr[63:32];
               TG_TOTAL_READ_COUNT_L[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: //total read count 1/2
                  amm_cfg_readdata <= total_read_count[31:0];
               TG_TOTAL_READ_COUNT_H[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: //total read count 2/2
                  amm_cfg_readdata <= total_read_count[63:32];
               default: begin
                  // synthesis translate_off
                  $display("Error: Invalid read address range in module:traffic_gen.v:tg_status_cfg_read");
                  // synthesis translate_on
               end
            endcase
         end else if (tg_cfg_info_cfg_read) begin
            case (amm_cfg_address_r[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0])
               TG_VERSION[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: //Version number of the driver
                  amm_cfg_readdata <= 32'd160;
               TG_NUM_DATA_GEN[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: //number of data generators
                  amm_cfg_readdata    <= NUMBER_OF_DATA_GENERATORS;
               TG_NUM_BYTEEN_GEN[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: //number of byteen generators
                  amm_cfg_readdata    <= NUMBER_OF_BYTE_EN_GENERATORS;
               TG_RANK_ADDR_WIDTH[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: //rank addr width
                  amm_cfg_readdata <= RANK_ADDR_WIDTH;
               TG_BANK_ADDR_WIDTH[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: //BA width
                  amm_cfg_readdata <= BANK_ADDR_WIDTH;
               TG_BANK_GROUP_WIDTH[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: //BG width
                  amm_cfg_readdata <= BANK_GROUP_WIDTH;
               TG_ROW_ADDR_WIDTH[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: //Row width
                  amm_cfg_readdata <= ROW_ADDR_WIDTH;
               TG_DATA_PATTERN_LENGTH[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:
                  amm_cfg_readdata <= DATA_PATTERN_LENGTH;
               TG_BYTEEN_PATTERN_LENGTH[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:
                  amm_cfg_readdata <= BYTE_EN_PATTERN_LENGTH;
               TG_RDATA_WIDTH[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:
                  amm_cfg_readdata <= MEM_RDATA_WIDTH;
               TG_MIN_ADDR_INCR[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:
                  amm_cfg_readdata <= AMM_WORD_ADDRESS_DIVISIBLE_BY;
               TG_ERROR_REPORT[CFG_READ_SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:
                  amm_cfg_readdata <= config_error_report_reg;
               default: begin
                  // synthesis translate_off
                  $display("Error: Invalid read address range in module:traffic_gen.v:tg_cfg_info_cfg_read");
                  // synthesis translate_on
               end
            endcase
         end else if (tg_pnf_read) begin
            amm_cfg_readdata <= pnf_to_cfg_mux_signal[amm_cfg_address_r[5:0] - TG_PNF[5:0]]; // Isolate index by removing register address offset
         end else if (tg_fail_exp_data) begin
            amm_cfg_readdata <= exp_data_to_cfg_mux_signal[amm_cfg_address_r[5:0] - TG_FAIL_EXPECTED_DATA[5:0]]; // Isolate index by removing register address offset
         end else if (tg_fail_read_data) begin
            amm_cfg_readdata <= read_data_to_cfg_mux_signal[amm_cfg_address_r[5:0] - TG_FAIL_READ_DATA[5:0]]; // Isolate index by removing register address offset
         end else if (amm_cfg_read) begin
            // synthesis translate_off
            $display("Error: Invalid read address range in module:traffic_gen.v");
            // synthesis translate_on
            amm_cfg_readdata <= 32'h0;
         end

         if ((amm_cfg_address >= TG_PNF && amm_cfg_address <  TG_FAIL_EXPECTED_DATA)) begin
            tg_pnf_read       <= amm_cfg_read;
            tg_fail_exp_data  <= 1'b0;
            tg_fail_read_data <= 1'b0;
         end else if ((amm_cfg_address >=  TG_FAIL_EXPECTED_DATA) && (amm_cfg_address <  TG_FAIL_READ_DATA)) begin
            tg_pnf_read       <= 1'b0;
            tg_fail_exp_data  <= amm_cfg_read;
            tg_fail_read_data <= 1'b0;
         end else if ((amm_cfg_address >=  TG_FAIL_READ_DATA) && (amm_cfg_address <  TG_DATA_SEED-1)) begin
            tg_pnf_read       <= 1'b0;
            tg_fail_exp_data  <= 1'b0;
            tg_fail_read_data <= amm_cfg_read;
         end else begin
            tg_pnf_read       <= 1'b0;
            tg_fail_exp_data  <= 1'b0;
            tg_fail_read_data <= 1'b0;
         end

         amm_cfg_readdatavalid      <= amm_cfg_read_r | tg_pnf_read | tg_fail_exp_data | tg_fail_read_data | tg_cfg_info_cfg_read | tg_status_cfg_read;
         emergency_brake_asserted   <= first_failure_occured & ~targetted_reads_stage & target_first_failing_addr;

      end
   end
   endgenerate

   assign reads_in_prog = status_check_in_prog | rw_gen_start;
   assign amm_cfg_waitrequest = amm_cfg_waitrequest_r;
   assign tg_restart = rw_gen_start;

   genvar k;
   genvar l;
   generate
   for ( k = 0; k < MAX_DATA_TO_CFG_MUX_SIZE; k++ ) begin: multiplex_pnf_to_cfg
      if ( k == DATA_TO_CFG_WIDTH_RATIO && MEM_RDATA_WIDTH-1 >= k*AMM_CFG_DATA_WIDTH) begin
         assign pnf_to_cfg_mux_signal[k]           = pnf_per_bit_persist[MEM_RDATA_WIDTH-1 : k*AMM_CFG_DATA_WIDTH];
         assign exp_data_to_cfg_mux_signal[k]      = first_fail_expected_data[MEM_RDATA_WIDTH-1 : k*AMM_CFG_DATA_WIDTH];
         assign read_data_to_cfg_mux_signal[k]     = first_fail_read_data[MEM_RDATA_WIDTH-1 : k*AMM_CFG_DATA_WIDTH];
      end else if (k < DATA_TO_CFG_WIDTH_RATIO) begin
         assign pnf_to_cfg_mux_signal[k]           = pnf_per_bit_persist[(k+1)*AMM_CFG_DATA_WIDTH - 1 : k*AMM_CFG_DATA_WIDTH];
         assign exp_data_to_cfg_mux_signal[k]      = first_fail_expected_data[(k+1)*AMM_CFG_DATA_WIDTH - 1 : k*AMM_CFG_DATA_WIDTH];
         assign read_data_to_cfg_mux_signal[k]     = first_fail_read_data[(k+1)*AMM_CFG_DATA_WIDTH - 1 : k*AMM_CFG_DATA_WIDTH];
      end else begin
         assign pnf_to_cfg_mux_signal[k]           = '0;
         assign exp_data_to_cfg_mux_signal[k]      = '0;
         assign read_data_to_cfg_mux_signal[k]     = '0;
      end
   end

   for (l = 0; l < DATA_RATE_WIDTH_RATIO; l++) begin: fixed_wdata_mux_outer
      for ( k = 0; k < NUMBER_OF_DATA_GENERATORS; k++) begin: fixed_wdata_mux_inner
         assign fixed_wdata[l*NUMBER_OF_DATA_GENERATORS+k] = fixed_write_data[k][DATA_RATE_WIDTH_RATIO-l-1];
      end
   end
   for (l = 0; l < DATA_RATE_WIDTH_RATIO; l++) begin: fixed_exp_wdata_mux_outer
      for ( k = 0; k < NUMBER_OF_DATA_GENERATORS; k++) begin: fixed_exp_wdata_mux_inner
         assign fixed_exp_wdata[l*NUMBER_OF_DATA_GENERATORS+k] = fixed_exp_write_data[k][DATA_RATE_WIDTH_RATIO-l-1];
      end
   end

   if (USE_AVL_BYTEEN) begin
      for (l = 0; l < DATA_RATE_WIDTH_RATIO; l++) begin: fixed_wbe_mux_outer
         for ( k = 0; k < NUMBER_OF_BYTE_EN_GENERATORS_LOCAL; k++) begin: fixed_wbe_mux_inner
            assign fixed_wbe[l*NUMBER_OF_BYTE_EN_GENERATORS_LOCAL+k] = fixed_write_be[k][DATA_RATE_WIDTH_RATIO-l-1];
         end
      end
      for (l = 0; l < DATA_RATE_WIDTH_RATIO; l++) begin: fixed_exp_wbe_mux_outer
         for ( k = 0; k < NUMBER_OF_BYTE_EN_GENERATORS_LOCAL; k++) begin: fixed_exp_wbe_mux_inner
            assign fixed_exp_wbe[l*NUMBER_OF_BYTE_EN_GENERATORS_LOCAL+k] = fixed_exp_write_be[k][DATA_RATE_WIDTH_RATIO-l-1];
         end
      end
   end else begin
      assign fixed_wbe = {(MEM_BE_WIDTH){1'b1}};
      assign fixed_exp_wbe = {(MEM_BE_WIDTH){1'b1}};
   end
   endgenerate

   //Traffic generation modules

   wire compare_addr_gen_fifo_full;

   reg [31:0]  rw_read_rpt_cnt;
   reg [31:0]  rw_write_rpt_cnt;
   reg [31:0]  cmp_read_rpt_cnt;
   reg         rdata_valid_r;

	//read/write generator
   altera_emif_avl_tg_2_rw_gen #(
      .SEPARATE_READ_WRITE_IFS(SEPARATE_READ_WRITE_IFS),
      .OPERATION_COUNT_WIDTH (RW_OPERATION_COUNT_WIDTH),
      .LOOP_COUNT_WIDTH      (RW_LOOP_COUNT_WIDTH),
      .AMM_BURSTCOUNT_WIDTH  (AMM_BURSTCOUNT_WIDTH)
      )
      rw_gen_u0 (
      .clk                       (clk),
      .rst                       (rst),
      .valid                     (),
      .read_enable               (read_req),
      .write_enable              (write_req),
      .next_addr_read            (next_addr_read),
      .next_addr_write           (next_addr_write),
      .next_data_read            (next_data_read),
      .next_data_write           (next_data_write),
      .waitrequest               (rw_gen_waitrequest),
      .read_ready                (controller_ready & (rw_read_rpt_cnt == 32'h1)),
      .write_ready               (controller_ready_w & (rw_write_rpt_cnt == 32'h1)),
      .start                     (rw_gen_start),
      .num_reads                 (rw_gen_read_cnt),
      //writes are concerned with burst length, as write enable must be held high
      //for entire duration of burst
      .num_writes                (rw_gen_write_cnt),
      .num_loops                 (rw_gen_loop_cnt),
      .emergency_brake_asserted  (emergency_brake_asserted),
      .burstlength               (burstlength)

   );

   always @ (posedge clk/*, posedge rst*/) begin
         rdata_valid_r  <= ast_act_data_readdatavalid;
         if (rw_gen_start) begin 
            rw_read_rpt_cnt   <= rw_gen_read_rpt_cnt;
            rw_write_rpt_cnt  <= rw_gen_write_rpt_cnt;
            cmp_read_rpt_cnt  <= rw_gen_read_rpt_cnt;
         end else begin
            if (read_req) begin 
               if (controller_ready) begin
                  if (rw_read_rpt_cnt == 32'h1) rw_read_rpt_cnt   <= rw_gen_read_rpt_cnt;
                  else                          rw_read_rpt_cnt   <= rw_read_rpt_cnt - 32'h1;
               end
            end
            if (write_req) begin
               if (controller_ready_w) begin
                  if (rw_write_rpt_cnt == 32'h1)   rw_write_rpt_cnt  <= rw_gen_write_rpt_cnt;
                  else                             rw_write_rpt_cnt  <= rw_write_rpt_cnt - 32'h1;
               end
            end
            if (rdata_valid_r) begin
               if (cmp_read_rpt_cnt == 32'h1)   cmp_read_rpt_cnt  <= rw_gen_read_rpt_cnt;
               else                             cmp_read_rpt_cnt  <= cmp_read_rpt_cnt - 32'h1;
            end
         end
   end

	//address generators
   altera_emif_avl_tg_2_addr_gen #(
      .AMM_WORD_ADDRESS_WIDTH          (AMM_WORD_ADDRESS_WIDTH),
      .AMM_BURSTCOUNT_WIDTH            (AMM_BURSTCOUNT_WIDTH),
      .ROW_ADDR_WIDTH                  (ROW_ADDR_WIDTH),
      .ROW_ADDR_LSB                    ((ROW_ADDR_LSB < WORD_ADDR_SHIFT) ? ROW_ADDR_LSB : ROW_ADDR_LSB-WORD_ADDR_SHIFT),
      .SEQ_CNT_WIDTH                   (RW_OPERATION_COUNT_WIDTH),
      .RAND_SEQ_CNT_WIDTH              (RAND_SEQ_CNT_WIDTH),
      .SEQ_ADDR_INCR_WIDTH             (SEQ_ADDR_INCR_WIDTH),
      .RANK_ADDR_WIDTH_LOCAL           (RANK_ADDR_WIDTH_LOCAL),
      .RANK_ADDR_LSB                   ((RANK_ADDR_LSB < WORD_ADDR_SHIFT) ? RANK_ADDR_LSB : RANK_ADDR_LSB-WORD_ADDR_SHIFT),
      .BANK_ADDR_WIDTH                 (BANK_ADDR_WIDTH),
      .BANK_ADDR_LSB                   ((BANK_ADDR_LSB < WORD_ADDR_SHIFT) ? BANK_ADDR_LSB : BANK_ADDR_LSB-WORD_ADDR_SHIFT),
      .BANK_GROUP_WIDTH_LOCAL          (BANK_GROUP_WIDTH_LOCAL),
      .BANK_GROUP_LSB                  ((BANK_GROUP_LSB < WORD_ADDR_SHIFT) ? BANK_GROUP_LSB : BANK_GROUP_LSB-WORD_ADDR_SHIFT),
      .RANK_ADDR_WIDTH                 (RANK_ADDR_WIDTH),
      .BANK_GROUP_WIDTH                (BANK_GROUP_WIDTH),
      .AMM_WORD_ADDRESS_DIVISIBLE_BY   (AMM_WORD_ADDRESS_DIVISIBLE_BY),
      .AMM_BURST_COUNT_DIVISIBLE_BY    (AMM_BURST_COUNT_DIVISIBLE_BY),
      .ENABLE_UNIX_ID                  (TG_ENABLE_UNIX_ID),
      .USE_UNIX_ID                     (TG_USE_UNIX_ID)
      )
      write_address_gen (
      .clk                       (clk),
      .rst                       (rst),
      .enable                    (next_addr_write),
      .addr_out                  (write_addr),
      .start                     (rw_gen_start),
      .start_addr                (addr_gen_write_start_addr[AMM_WORD_ADDRESS_WIDTH-1:0]),
      .addr_gen_mode             (addr_gen_mode_writes),
      //for sequential mode
      .seq_return_to_start_addr  (addr_gen_seq_return_to_start_addr),
      .seq_addr_num              (rw_gen_write_cnt),
      //for random sequential
      .rand_seq_num_seq_addr     (addr_gen_rseq_num_seq_addr_write),
      .seq_addr_increment        (addr_gen_seq_addr_incr),

      .rank_mask_en              (addr_gen_rank_mask_en),
      .bank_mask_en              (addr_gen_bank_mask_en),
      .row_mask_en               (addr_gen_row_mask_en),
      .rank_mask                 (addr_gen_rank_mask),
      .bank_mask                 (addr_gen_bank_mask),
      .row_mask                  (addr_gen_row_mask),
      .bankgroup_mask_en         (addr_gen_bankgroup_mask_en),
      .bankgroup_mask            (addr_gen_bankgroup_mask),
      .burstcount                (burstlength)
   );

   altera_emif_avl_tg_2_addr_gen #(
      .AMM_WORD_ADDRESS_WIDTH          (AMM_WORD_ADDRESS_WIDTH),
      .AMM_BURSTCOUNT_WIDTH            (AMM_BURSTCOUNT_WIDTH),
      .ROW_ADDR_WIDTH                  (ROW_ADDR_WIDTH),
      .ROW_ADDR_LSB                    ((ROW_ADDR_LSB < WORD_ADDR_SHIFT) ? ROW_ADDR_LSB : ROW_ADDR_LSB-WORD_ADDR_SHIFT),
      .SEQ_CNT_WIDTH                   (RW_OPERATION_COUNT_WIDTH),
      .RAND_SEQ_CNT_WIDTH              (RAND_SEQ_CNT_WIDTH),
      .SEQ_ADDR_INCR_WIDTH             (SEQ_ADDR_INCR_WIDTH),
      .RANK_ADDR_WIDTH_LOCAL           (RANK_ADDR_WIDTH_LOCAL),
      .RANK_ADDR_LSB                   ((RANK_ADDR_LSB < WORD_ADDR_SHIFT) ? RANK_ADDR_LSB : RANK_ADDR_LSB-WORD_ADDR_SHIFT),
      .BANK_ADDR_WIDTH                 (BANK_ADDR_WIDTH),
      .BANK_ADDR_LSB                   ((BANK_ADDR_LSB < WORD_ADDR_SHIFT) ? BANK_ADDR_LSB : BANK_ADDR_LSB-WORD_ADDR_SHIFT),
      .BANK_GROUP_WIDTH_LOCAL          (BANK_GROUP_WIDTH_LOCAL),
      .BANK_GROUP_LSB                  ((BANK_GROUP_LSB < WORD_ADDR_SHIFT) ? BANK_GROUP_LSB : BANK_GROUP_LSB-WORD_ADDR_SHIFT),
      .RANK_ADDR_WIDTH                 (RANK_ADDR_WIDTH),
      .BANK_GROUP_WIDTH                (BANK_GROUP_WIDTH),
      .AMM_WORD_ADDRESS_DIVISIBLE_BY   (AMM_WORD_ADDRESS_DIVISIBLE_BY),
      .AMM_BURST_COUNT_DIVISIBLE_BY    (AMM_BURST_COUNT_DIVISIBLE_BY),
      .ENABLE_UNIX_ID                  (TG_ENABLE_UNIX_ID),
      .USE_UNIX_ID                     (TG_USE_UNIX_ID)
      )
      read_address_gen (
      .clk                       (clk),
      .rst                       (rst),
      //enable on start in order to generate the first address
      .enable                    ((next_addr_read)|rw_gen_start),
      .addr_out                  (read_addr),
      .start                     (rw_gen_start),
      .start_addr                (addr_gen_read_start_addr[AMM_WORD_ADDRESS_WIDTH-1:0]),
      .addr_gen_mode             (addr_gen_mode_reads),
      //for sequential mode
      .seq_return_to_start_addr  (addr_gen_seq_return_to_start_addr),
      .seq_addr_num              (rw_gen_read_cnt),
      //for random sequential
      .rand_seq_num_seq_addr     (addr_gen_rseq_num_seq_addr_read),
      .seq_addr_increment        (addr_gen_seq_addr_incr),

      .rank_mask_en              (addr_gen_rank_mask_en),
      .bank_mask_en              (addr_gen_bank_mask_en),
      .row_mask_en               (addr_gen_row_mask_en),
      .rank_mask                 (addr_gen_rank_mask),
      .bank_mask                 (addr_gen_bank_mask),
      .row_mask                  (addr_gen_row_mask),
      .bankgroup_mask_en         (addr_gen_bankgroup_mask_en),
      .bankgroup_mask            (addr_gen_bankgroup_mask),
      .burstcount                (burstlength)
   );
   wire next_read_data_en;

   genvar i;
   generate
      //The instantiation and linkage ordering is such that the first input configuration data will go to
      //instance 0, and the last input will go to instance number NUMBER_OF_DATA_GENERATORS-1
      for (i = 0; i < NUMBER_OF_DATA_GENERATORS; i = i + 1) begin: wr_data_pppg
            altera_emif_avl_tg_2_per_pin_pattern_gen #(
               .OUTPUT_WIDTH   (DATA_RATE_WIDTH_RATIO),
               .PATTERN_LENGTH (DATA_PATTERN_LENGTH),
                //default to prbs pattern mode
               .DEFAULT_MODE   (1'b0),
               .DEFAULT_STATE  ({{(DATA_PATTERN_LENGTH-1){1'b0}}, 1'b1})
               )
               per_pin_pattern_gen_data(
               .clk            (clk),
               .rst            (rst),
               .load           (data_gen_load[i]),
               .load_mode      (1'b1),
               .load_data      (amm_cfg_writedata_r[DATA_PATTERN_LENGTH-1:0]),
               .load_inversion (1'b0),
               .enable         (next_data_write),
               .dout           (fixed_write_data[i]),
               //unnecessary state_out
               .state_out      ()
            );
      end
   endgenerate

   generate
      for (i = 0; i < NUMBER_OF_BYTE_EN_GENERATORS_LOCAL; i = i + 1) begin: gen_wr_byte_en_pppg
         altera_emif_avl_tg_2_per_pin_pattern_gen #(
            .OUTPUT_WIDTH   (DATA_RATE_WIDTH_RATIO),
            .PATTERN_LENGTH (BYTE_EN_PATTERN_LENGTH),
            .DEFAULT_MODE   (1'b1),
            .DEFAULT_STATE  ({BYTE_EN_PATTERN_LENGTH{1'b1}})
         ) per_pin_pattern_gen_be(
            .clk            (clk),
            .rst            (rst),
            .load           (byte_en_load[i]),
            .load_mode      (1'b1),
            .load_data      (amm_cfg_writedata_r[BYTE_EN_PATTERN_LENGTH-1:0]),
            .load_inversion (1'b0),
            .enable         (next_data_write),
            .dout           (fixed_write_be[i]),
            .state_out      ()
            );
      end
   endgenerate

   generate
      //data for comparison to read data
      for (i = 0; i < NUMBER_OF_DATA_GENERATORS; i = i + 1) begin: exp_data_pppg
            altera_emif_avl_tg_2_per_pin_pattern_gen #(
               .OUTPUT_WIDTH   (DATA_RATE_WIDTH_RATIO),
               .PATTERN_LENGTH (DATA_PATTERN_LENGTH),
               //default to prbs pattern mode
               .DEFAULT_MODE   (1'b0),
               .DEFAULT_STATE  ({{(DATA_PATTERN_LENGTH-1){1'b0}}, 1'b1})
               )
               per_pin_pattern_gen_data(
               .clk            (clk),
               .rst            (rst),
               .load           (data_gen_load[i]),
               //takes same initial configuration as the write data generators
               .load_mode      (1'b1),
               .load_data      (amm_cfg_writedata_r[DATA_PATTERN_LENGTH-1:0]),
               .load_inversion (1'b0),
               .enable         (next_read_data_en),
               .dout           (fixed_exp_write_data[i]),
               //only used for passing out initial configuration data through
               //this is done by the write data generators
               //unnecessary state_out
               .state_out      ()
            );
      end
   endgenerate


   //byte enable generators
   //2 sets needed - 1 for writes, 1 for verification of read data

   generate
      for (i = 0; i < NUMBER_OF_BYTE_EN_GENERATORS_LOCAL; i = i + 1) begin: gen_exp_byte_en_pppg
            altera_emif_avl_tg_2_per_pin_pattern_gen #(
               .OUTPUT_WIDTH   (DATA_RATE_WIDTH_RATIO),
               .PATTERN_LENGTH (BYTE_EN_PATTERN_LENGTH),
               .DEFAULT_MODE   (1'b1),
               .DEFAULT_STATE  ({BYTE_EN_PATTERN_LENGTH{1'b1}})
               )
               per_pin_pattern_gen_be(
               .clk            (clk),
               .rst            (rst),
               .load           (byte_en_load[i]),
               .load_mode      (1'b1),
               .load_data      (amm_cfg_writedata_r[BYTE_EN_PATTERN_LENGTH-1:0]),
               .load_inversion (1'b0),
               .enable         (next_read_data_en),
               .dout           (fixed_exp_write_be[i]),
               .state_out      ()
            );
      end
   endgenerate

	//LFSR data generators
   //2 sets needed - 1 for writes, 1 for verification of read data
   // A separate data generator is used to re-generate the written data/mask for read comparison.
   // This saves us from the need of instantiating a FIFO to record the write data

   //Actual data signal generation

   //Actual write data generator
   altera_emif_avl_tg_lfsr_wrapper # (
      .DATA_WIDTH (MEM_DATA_WIDTH),
      .SEED       (TG_LFSR_SEED)
   ) act_data_gen_inst (
      .clk        (clk),
      .reset_n    (~rst),
      .enable     (next_data_write & (data_gen_mode[0] == 0)),
      .data       (lfsr_write_data)
   );

   //Actual byte enable generator
   generate
   if (USE_AVL_BYTEEN)
   begin : act_be_gen

      altera_emif_avl_tg_lfsr_wrapper # (
         .DATA_WIDTH (MEM_BE_WIDTH)
      ) act_be_gen_inst (
         .clk        (clk),
         .reset_n    (~rst),
         .enable     (next_data_write & (data_gen_mode[0] == 0)),
         .data       (lfsr_write_be)
      );

   end
   else
   begin
      assign lfsr_write_be = {(MEM_BE_WIDTH){1'b1}};
   end
   endgenerate

   //Expected data signal generation

   // Expected write data generator
   altera_emif_avl_tg_lfsr_wrapper # (
      .DATA_WIDTH (MEM_DATA_WIDTH),
      .SEED       (TG_LFSR_SEED)
   ) exp_data_gen_inst (
      .clk        (clk),
      .reset_n    (~rst),
      .enable     (next_read_data_en & (data_gen_mode[0] == 0)),
      .data       (lfsr_exp_write_data)
   );

   // Expected byte enable generator
   generate
   if (USE_AVL_BYTEEN)
   begin : exp_be_gen
      altera_emif_avl_tg_lfsr_wrapper # (
         .DATA_WIDTH (MEM_BE_WIDTH)
      ) exp_be_gen_inst (
         .clk        (clk),
         .reset_n    (~rst),
         .enable     (next_read_data_en & (data_gen_mode[0] == 0)),
         .data       (lfsr_exp_write_be)
      );
   end
   else
   begin
      assign lfsr_exp_write_be = {(MEM_BE_WIDTH){1'b1}};
   end
   endgenerate

   assign mem_write_data = data_gen_mode[0] ? fixed_wdata : lfsr_write_data;
   assign mem_write_be    = byte_en_gen_mode[0] ? fixed_wbe : lfsr_write_be;

   assign written_data = data_gen_mode[0] ? fixed_exp_wdata : lfsr_exp_write_data;
   assign written_be   = byte_en_gen_mode[0] ?  fixed_exp_wbe : lfsr_exp_write_be;

   wire [MEM_BE_WIDTH-1:0]    ast_exp_data_byteenable_pre;

   generate
   if (SEPARATE_READ_WRITE_IFS) begin
      //translates the commands issued by the traffic_gen into Avalon signals
      altera_emif_avl_tg_2_avl_if # (
         .BYTE_ADDR_WIDTH              (MEM_ADDR_WIDTH),
         .DATA_WIDTH                   (MEM_DATA_WIDTH),
         .BE_WIDTH                     (MEM_BE_WIDTH),
         .AMM_WORD_ADDRESS_WIDTH       (AMM_WORD_ADDRESS_WIDTH),
         .AMM_BURSTCOUNT_WIDTH         (AMM_BURSTCOUNT_WIDTH)
      ) avl_tg_if_inst (

         .clk                         (clk),

         // traffic generator side
         .write_req                    (write_req),
         .read_req                     (read_req),
         .mem_addr                     (read_addr),
         .mem_write_data               (mem_write_data),
         .mem_write_be                 (mem_write_be),
         .controller_ready             (controller_ready),
         .controller_ready_w           (controller_ready_w),
         .burstlength                  (burstlength),

         .amm_ctrl_write              (amm_ctrl_write),
         .amm_ctrl_read               (amm_ctrl_read),
         .amm_ctrl_address            (amm_ctrl_address),
         .amm_ctrl_writedata          (amm_ctrl_writedata),
         .amm_ctrl_byteenable         (amm_ctrl_byteenable),
         .amm_ctrl_ready              (amm_ctrl_ready),
         .amm_ctrl_burstcount         (amm_ctrl_burstcount),

         .mem_addr_w                  (write_addr),
         .amm_ctrl_address_w          (amm_ctrl_address_w),
         .amm_ctrl_ready_w            (amm_ctrl_ready_w),
         .amm_ctrl_burstcount_w       (amm_ctrl_burstcount_w),

         // from memory interface
         .amm_ctrl_readdatavalid      (amm_ctrl_readdatavalid),
         .amm_ctrl_readdata           (amm_ctrl_readdata),

         //data for comparison
         .written_be                  (written_be),
         .written_data                (written_data),

         // outputs
         .ast_exp_data_byteenable     (ast_exp_data_byteenable_pre),
         .ast_exp_data_writedata      (ast_exp_data_writedata),

         .ast_act_data_readdatavalid  (ast_act_data_readdatavalid),
         .ast_act_data_readdata       (ast_act_data_readdata),

         .read_addr_fifo_full         (compare_addr_gen_fifo_full)

      );

   end else begin
      //Logic to connect the avl interface to the 1x bridge

      logic                            avl_read_req;
      logic                            avl_write_req;
      logic                            avl_ready;
      logic [MEM_ADDR_WIDTH-1:0]       avl_mem_addr;
      logic [AMM_BURSTCOUNT_WIDTH-1:0] avl_burstlength;
      logic [MEM_BE_WIDTH-1:0]         avl_mem_write_be;
      logic [MEM_DATA_WIDTH-1:0]       avl_mem_write_data;
      logic [AMM_WORD_ADDRESS_WIDTH-1:0]       mem_addr;

      assign mem_addr = write_req ? write_addr : read_addr;

      // For timing closure we instantiate a bridge to decouple
      // master and slave. The bridge is essentially a 2-deep FIFO.

      altera_emif_avl_tg_amm_1x_bridge # (
         .AMM_WDATA_WIDTH          (MEM_DATA_WIDTH),
         .AMM_SYMBOL_ADDRESS_WIDTH (MEM_ADDR_WIDTH),
         .AMM_BCOUNT_WIDTH         (AMM_BURSTCOUNT_WIDTH),
         .AMM_BYTEEN_WIDTH         (MEM_BE_WIDTH)
      ) amm_1x_bridge (
         .reset_n                    (~rst),
         .clk                        (clk),

         // memory interface side
         .amm_slave_write            (amm_ctrl_write),
         .amm_slave_read             (amm_ctrl_read),
         .amm_slave_ready            (amm_ctrl_ready), 
         .amm_slave_address          (amm_ctrl_address),
         .amm_slave_writedata        (amm_ctrl_writedata),
         .amm_slave_burstcount       (amm_ctrl_burstcount),
         .amm_slave_byteenable       (amm_ctrl_byteenable),

         // avl interface side
         .amm_master_write           (avl_write_req),
         .amm_master_read            (avl_read_req),
         .amm_master_ready           (avl_ready), 
         .amm_master_address         (avl_mem_addr),
         .amm_master_writedata       (avl_mem_write_data),
         .amm_master_burstcount      (avl_burstlength),
         .amm_master_byteenable      (avl_mem_write_be)
      );

      //translates the commands issued by the traffic_gen into Avalon signals
      altera_emif_avl_tg_2_avl_if # (
         .BYTE_ADDR_WIDTH              (MEM_ADDR_WIDTH),
         .DATA_WIDTH                   (MEM_DATA_WIDTH),
         .BE_WIDTH                     (MEM_BE_WIDTH),
         .AMM_WORD_ADDRESS_WIDTH       (AMM_WORD_ADDRESS_WIDTH),
         .AMM_BURSTCOUNT_WIDTH         (AMM_BURSTCOUNT_WIDTH)
      ) avl_tg_if_inst (

         .clk                         (clk),

         // traffic generator side
         .write_req                    (write_req),
         .read_req                     (read_req),
         .mem_addr                     (mem_addr),
         .mem_write_data               (mem_write_data),
         .mem_write_be                 (mem_write_be),
         .controller_ready             (controller_ready),
         .controller_ready_w           (controller_ready_w),
         .burstlength                  (burstlength),

         // 1x bridge side
         .amm_ctrl_write              (avl_write_req),
         .amm_ctrl_read               (avl_read_req),
         .amm_ctrl_address            (avl_mem_addr),
         .amm_ctrl_writedata          (avl_mem_write_data),
         .amm_ctrl_byteenable         (avl_mem_write_be),
         .amm_ctrl_ready              (avl_ready),
         .amm_ctrl_burstcount         (avl_burstlength),

         .mem_addr_w                  (mem_addr),
         .amm_ctrl_address_w          (),
         .amm_ctrl_ready_w            (avl_ready),
         .amm_ctrl_burstcount_w       (),

         // from memory interface
         .amm_ctrl_readdatavalid      (amm_ctrl_readdatavalid),
         .amm_ctrl_readdata           (amm_ctrl_readdata),

         //data for comparison
         .written_be                  (written_be),
         .written_data                (written_data),

         // outputs
         .ast_exp_data_byteenable     (ast_exp_data_byteenable_pre),
         .ast_exp_data_writedata      (ast_exp_data_writedata),

         .ast_act_data_readdatavalid  (ast_act_data_readdatavalid),
         .ast_act_data_readdata       (ast_act_data_readdata),

         .read_addr_fifo_full          (compare_addr_gen_fifo_full)

      );

      assign amm_ctrl_address_w = '0;
      assign amm_ctrl_burstcount_w = '0;
   end
   endgenerate

   assign ast_exp_data_byteenable = NUMBER_OF_BYTE_EN_GENERATORS == 0 ? {MEM_BE_WIDTH{1'b1}} : ast_exp_data_byteenable_pre;

   //Generates the addresses of the read data needed by status checker
   altera_emif_avl_tg_2_compare_addr_gen # (
      .AMM_WORD_ADDRESS_WIDTH    (AMM_WORD_ADDRESS_WIDTH),
      .ADDR_FIFO_DEPTH           (16),
      .AMM_BURSTCOUNT_WIDTH      (AMM_BURSTCOUNT_WIDTH),
      .READ_RPT_COUNT_WIDTH      (RW_RPT_COUNT_WIDTH),
      .READ_COUNT_WIDTH          (RW_OPERATION_COUNT_WIDTH),
      .READ_LOOP_COUNT_WIDTH     (RW_LOOP_COUNT_WIDTH)
   ) compare_addr_gen_inst(
      .clk                       (clk),
      .rst                       (rst),
      .tg_restart                (tg_restart),

      //read counters needed by status checker
      .num_read_bursts           (rw_gen_read_cnt),
      .num_read_loops            (rw_gen_loop_cnt),
      .is_repeat_test            (rw_gen_read_rpt_cnt > 32'h1),
      .cmp_read_rpt_cnt          (cmp_read_rpt_cnt),
      .rdata_valid               (ast_act_data_readdatavalid),
      .emergency_brake_asserted  (emergency_brake_asserted),

      .read_addr                 (read_addr),
      .read_addr_valid           (controller_ready & read_req),

      .burst_length              (burstlength),
      .current_written_addr      (ast_exp_data_readaddr),
      .check_in_prog             (status_check_in_prog),
      .fifo_almost_full          (compare_addr_gen_fifo_full),
      .next_read_data_en         (next_read_data_en)
   );

   altera_emif_avl_tg_2_config_error_module # (
      .AMM_WORD_ADDRESS_DIVISIBLE_BY   (AMM_WORD_ADDRESS_DIVISIBLE_BY),
      .AMM_BURST_COUNT_DIVISIBLE_BY    (AMM_BURST_COUNT_DIVISIBLE_BY),
      .MEM_DATA_WIDTH                  (MEM_DATA_WIDTH),
      .MEM_BE_WIDTH                    (MEM_BE_WIDTH),
      .USE_AVL_BYTEEN                  (USE_AVL_BYTEEN),
      .NUMBER_OF_DATA_GENERATORS       (NUMBER_OF_DATA_GENERATORS),
      .NUMBER_OF_BYTE_EN_GENERATORS    (NUMBER_OF_BYTE_EN_GENERATORS_LOCAL),
      .DATA_PATTERN_LENGTH             (DATA_PATTERN_LENGTH),
      .BYTE_EN_PATTERN_LENGTH          (BYTE_EN_PATTERN_LENGTH),
      .DATA_RATE_WIDTH_RATIO           (DATA_RATE_WIDTH_RATIO),
      .RAND_SEQ_CNT_WIDTH              (RAND_SEQ_CNT_WIDTH),
      .AMM_WORD_ADDRESS_WIDTH          (AMM_WORD_ADDRESS_WIDTH),
      .AMM_BURSTCOUNT_WIDTH            (AMM_BURSTCOUNT_WIDTH),
      .RW_OPERATION_COUNT_WIDTH        (RW_OPERATION_COUNT_WIDTH),
      .RW_RPT_COUNT_WIDTH              (RW_RPT_COUNT_WIDTH),
      .SEQ_ADDR_INCR_WIDTH             (SEQ_ADDR_INCR_WIDTH)
   ) config_error_module_inst (
      .clk                             (clk),
      .reset                           (rst),
      .tg_restart                      (tg_restart),

      //config registers of interest
      .num_reads                       (rw_gen_read_cnt),
      .num_writes                      (rw_gen_write_cnt),
      .seq_addr_incr                   (addr_gen_seq_addr_incr),
      .burstlength                     (burstlength),
      .addr_write                      (addr_gen_write_start_addr[AMM_WORD_ADDRESS_WIDTH-1:0]),
      .addr_read                       (addr_gen_read_start_addr[AMM_WORD_ADDRESS_WIDTH-1:0]),
      .addr_mode_write                 (addr_gen_mode_writes),
      .addr_mode_read                  (addr_gen_mode_reads),
      .rand_seq_addrs_write            (addr_gen_rseq_num_seq_addr_write),
      .rand_seq_addrs_read             (addr_gen_rseq_num_seq_addr_read),
      .num_read_repeats                (rw_gen_read_rpt_cnt),
      .num_write_repeats               (rw_gen_write_rpt_cnt),

      //error report out
      .config_error_report             (config_error_report_reg)
   );

endmodule

