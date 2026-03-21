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



// Top level of 256-bit Target Memory

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module altera_pcie_sriov_target_mem # 
  (
   parameter port_width_data_hwtcl            = 256,
   parameter port_width_be_hwtcl              = 32,
   parameter multiple_packets_per_cycle_hwtcl = 0,
   parameter TOTAL_PF_COUNT                   = 2,    // Number of Physical Functions (1 or 2) 
   parameter TOTAL_VF_COUNT                   = 128
                                         )
   (
    // Clock and Reset
    input                                           clk_i,
    input                                           rstn_i,

    input [7:0]                                     bus_num_i, // Captured bus number for Function 0
    
    output reg                                      cpl_pending_pf_o,// Completion pending status from PF 0
    output reg [TOTAL_VF_COUNT-1:0]                       cpl_pending_vf_o,// Completion pending status from VFs


    // Request interface
    input [port_width_data_hwtcl-1:0]               rx_st_data_i,
    output                                          rx_st_ready_o,
    input [multiple_packets_per_cycle_hwtcl:0]      rx_st_sop_i,
    input [multiple_packets_per_cycle_hwtcl:0]      rx_st_valid_i,
    input [1:0]                                     rx_st_empty_i,
    input [multiple_packets_per_cycle_hwtcl:0]      rx_st_eop_i,
    input [multiple_packets_per_cycle_hwtcl:0]      rx_st_err_i,
    input [7:0]                                     rx_st_bar_hit_fn_i,
    input [7:0]                                     rx_st_req_bar_hit_tlp0_i,

    // Completion interface
    output reg [port_width_data_hwtcl-1 : 0]        tx_st_data_o,
    output reg [1:0]                                tx_st_empty_o,
    output reg [multiple_packets_per_cycle_hwtcl:0] tx_st_eop_o,
    output reg [multiple_packets_per_cycle_hwtcl:0] tx_st_err_o,
    output reg [multiple_packets_per_cycle_hwtcl:0] tx_st_sop_o,
    output reg [multiple_packets_per_cycle_hwtcl:0] tx_st_valid_o,
    input                                           tx_st_ready_i
    );

   reg [12:0]                   ram_address;
   reg [31:0]                   ram_wr_byte_enable;
   reg [255:0]                  ram_wr_data;
   wire [255:0]                 ram_rd_data;
   reg [255:0]                  ram_rd_data_reg;
   reg                          ram_wren;

   wire [7:0]                   header_byte0, header_byte1, header_byte2, header_byte3,
                                header_byte4, header_byte5, header_byte6, header_byte7,
                                header_byte8, header_byte9, header_byte10, header_byte11,
                                header_byte12, header_byte13, header_byte14, header_byte15;

   wire                         addr_64;
   wire [63:2]                  mem_addr;
   reg [6:2]                    mem_addr_reg;
   wire                         mem_addr_bit2;
   wire                         qw_aligned_addr;
   reg                          qw_aligned_addr_reg;
   reg                          addr_64_reg;

   wire                         mem_rd_32;
   wire                         mem_rd_64;
   wire                         mem_wr_32;
   wire                         mem_wr_64;

   wire                         mem_wr_tlp;
   wire                         mem_rd_tlp;
   wire [3:0]                   first_be;
   wire [3:0]                   last_be;
   wire [6:0]                   payload_size;
   wire                         zero_length_req;
   reg [3:0]                    first_be_reg;
   reg [3:0]                    last_be_reg;
   reg [6:0]                    low_addr_reg;
   reg [8:0]                    compl_byte_count;
   reg [8:0]                    compl_byte_count_adj;
   reg [2:0]                    write_dw_offset;

   reg [31:0]                   first_mem_word_be;
   reg                          mem_cycle_count_1;
   reg [6:0]                    dwords_to_write;
   reg [223:0]                  saved_wr_data;
   reg [2:0]                    saved_dword_count;

   reg [9:0]                    target_app_state;
   reg [9:0]                    next_state;
   reg [3:0]                    read_dw_sel0, read_dw_sel1, read_dw_sel2, read_dw_sel3,
                                read_dw_sel4, read_dw_sel5, read_dw_sel6, read_dw_sel7;
   reg [191:0]                  saved_read_data;
   reg [2:0]                    saved_dw_offset;
   wire [2:0]                   tc_field;
   wire [2:0]                   attr_field;
   wire [7:0]                   req_word_count;
   reg [7:0]                    req_function;
   reg                          zero_length_req_reg;
   wire [15:0]                  req_id;
   wire [7:0]                   req_tag;
   reg [6:0]                    dwords_to_read;
   reg [6:0]                    dwords_sent_this_cycle;
   reg [63:0]                   req_header;
   
   reg                          tx_st_ready_reg;

   assign                       header_byte0 = rx_st_data_i[31:24];
   assign                       header_byte1 = rx_st_data_i[23:16];
   assign                       header_byte2 = rx_st_data_i[15:8];
   assign                       header_byte3 = rx_st_data_i[7:0];
   assign                       header_byte4 = rx_st_data_i[63:56];
   assign                       header_byte5 = rx_st_data_i[55:48];
   assign                       header_byte6 = rx_st_data_i[47:40];
   assign                       header_byte7 = rx_st_data_i[39:32];
   assign                       header_byte8 = rx_st_data_i[95:88];
   assign                       header_byte9 = rx_st_data_i[87:80];
   assign                       header_byte10 = rx_st_data_i[79:72];
   assign                       header_byte11 = rx_st_data_i[71:64];
   assign                       header_byte12 = rx_st_data_i[127:120];
   assign                       header_byte13 = rx_st_data_i[119:112];
   assign                       header_byte14 = rx_st_data_i[111:104];
   assign                       header_byte15 = rx_st_data_i[103:96];

   assign                       addr_64 = header_byte0[5];
   assign                       mem_addr = addr_64? {header_byte8, header_byte9, header_byte10, header_byte11,
                                                     header_byte12, header_byte13, header_byte14, header_byte15[7:2]}:
                                {32'd0, header_byte8, header_byte9, header_byte10, header_byte11[7:2]};
   assign                       mem_addr_bit2 = addr_64? header_byte15[2] : header_byte11[2];
   assign                       qw_aligned_addr = ~mem_addr_bit2;

   assign                       mem_rd_32 = (header_byte0[6:0] == 7'h0);
   assign                       mem_rd_64 = (header_byte0[6:0] == 7'h20);
   assign                       mem_wr_32 = (header_byte0[6:0] == 7'h40);
   assign                       mem_wr_64 = (header_byte0[6:0] == 7'h60);

   assign                       mem_wr_tlp = rx_st_sop_i[0] & ~rx_st_err_i[0] & (mem_wr_32 | mem_wr_64);
   assign                       mem_rd_tlp = rx_st_sop_i[0] & ~rx_st_err_i[0] & (mem_rd_32 | mem_rd_64);
   assign                       first_be = header_byte7[3:0];
   assign                       last_be = header_byte7[7:4];
   assign                       payload_size = header_byte3[6:0]; // Assumes payload size <= 64 Dwords
   assign                       zero_length_req = (first_be == 4'd0);
   
   // Completion header fields
   assign                       tc_field = req_header[8+6:8+4];
   assign                       attr_field = {req_header[8+2], req_header[16+5:16+4]};
   assign                       req_word_count = req_header[31:24];
   assign                       req_id = {req_header[39:32], req_header[47:40]};
   assign                       req_tag = req_header[55:48];

   // State machine states

   localparam  IDLE             = 4'd0;
   localparam  WRITE_PAYLOAD_FIRST_CYCLE = 4'd1;
   localparam  WRITE_PAYLOAD    = 4'd2;
   localparam  WRITE_SPILL_WORD = 4'd3;
   localparam  START_READ       = 4'd4;
   localparam  MEM_READ_WAIT_FOR_DATA_1  = 4'd5;
   localparam  MEM_READ_WAIT_FOR_DATA_2  = 4'd6;
   localparam  SEND_COMPL_HDR   = 4'd7;
   localparam  SEND_COMPL_HDR_2 = 4'd8;
   localparam  SEND_READ_PAYLOAD = 4'd9;

   integer                      i;

   //==============================================================================
   // Total memory = 8K * 256bit => 2Mbit or 512KB of SRAM
   // Assuming each function can have upto 4 BARs. 
   // Then, for 130 functions, each BAR has max of 256B .
   //  => 512KB / (130Func * 4BARs/Func) = 1008B/BAR => select 256B/BAR
   // So the RAM address will be mapped as following
   //  ** Max number of sram address that represents 256B is 
   //     256Bytes/BAR * (1 addr / 32Bytes) = 8 addr/BAR 
   //
   // The ram_address will be partition as following:
   //   - [2:0]  => 256B for each BAR
   //   - [4:3]  => 2bit BAR hit for max of 4 BARs per each function
   //   - [12:5] => function number from 0 -130
   // The next 8 bit of address is mapped to function number
   // Each function can have upto 4 BARs. So that all 130 functions
   //==============================================================================
   // 8192 x 256 RAM
   altera_pcie_sriov_target_ram8192x256 altera_pcie_sriov_target_ram8192x256_inst
     (
      .clock                  (clk_i),
      .address                (ram_address),
      .data                   (ram_wr_data),
      .byteena                (ram_wr_byte_enable),
      .wren                   (ram_wren), 
      .q                      (ram_rd_data)
      );
   

   // Register data from RAM
   always @(posedge clk_i)
     ram_rd_data_reg <= ram_rd_data;

   // Compute byte enable for the first payload cycle of a Memory Write
   always @(*)
     begin
        case(mem_addr[4:2])
          3'd0:
            begin
               first_mem_word_be[3:0] = first_be[3:0];
               if (payload_size <= 7'd1)
                   first_mem_word_be[19:4] = 16'd0;
                 else if (payload_size == 7'd2)
                   first_mem_word_be[19:4] = {12'd0, last_be[3:0]};
                 else if (payload_size == 7'd3)
                   first_mem_word_be[19:4] = {8'd0, last_be[3:0], 4'hf};
                 else if (payload_size == 7'd4)
                   first_mem_word_be[19:4] = {4'd0, last_be[3:0], 8'hff};
                 else if (payload_size == 7'd5)
                   first_mem_word_be[19:4] = {last_be[3:0], 12'hfff};
               else 
                 first_mem_word_be[19:4] = 16'hffff;
               first_mem_word_be[31:20] = 12'd0;
              end // case: 3'd0
            
            3'd1:
              begin
                 first_mem_word_be[3:0] = 4'd0;
                 first_mem_word_be[7:4] = first_be[3:0];
                 if (payload_size <= 7'd1)
                   first_mem_word_be[31:8] = 24'd0;
                 else if (payload_size == 7'd2)
                   first_mem_word_be[31:8] = {20'd0, last_be[3:0]};
                 else if (payload_size == 7'd3)
                   first_mem_word_be[31:8] = {16'd0, last_be[3:0], 4'hf};
                 else if (payload_size == 7'd4)
                   first_mem_word_be[31:8] = {12'd0, last_be[3:0], 8'hff};
                 else if (payload_size == 7'd5)
                   first_mem_word_be[31:8] = {8'd0, last_be[3:0], 12'hfff};
                 else
                   first_mem_word_be[31:8] = 24'hffff;
              end // case: 3'd1

            3'd2:
              begin
                 first_mem_word_be[7:0] = 8'd0;
                 first_mem_word_be[11:8] = first_be[3:0];
                 if (payload_size <= 7'd1)
                   first_mem_word_be[31:12] = 20'd0;
                 else if (payload_size == 7'd2)
                   first_mem_word_be[31:12] = {16'd0, last_be[3:0]};
                 else if (payload_size == 7'd3)
                   first_mem_word_be[31:12] = {12'd0, last_be[3:0], 4'hf};
                 else if (payload_size == 7'd4)
                   first_mem_word_be[31:12] = {8'd0, last_be[3:0], 8'hff};
                 else
                   first_mem_word_be[31:12] = 20'hfff;
              end // case: 3'd2
            
            3'd3:
              begin
                 first_mem_word_be[11:0] = 12'd0;
                 first_mem_word_be[15:12] = first_be[3:0];
                 if (payload_size <= 7'd1)
                   first_mem_word_be[31:16] = 16'd0;
                 else if (payload_size == 7'd2)
                   first_mem_word_be[31:16] = {12'd0, last_be[3:0]};
                 else if (payload_size == 7'd3)
                   first_mem_word_be[31:16] = {8'd0, last_be[3:0], 4'hf};
                 else if (payload_size == 7'd4)
                   first_mem_word_be[31:16] = {4'd0, last_be[3:0], 8'hff};
                 else if (payload_size == 7'd5)
                   first_mem_word_be[31:16] = {last_be[3:0], 12'hfff};
                 else
                   first_mem_word_be[31:16] = 16'hffff;
              end // case: 3'd3
            
            3'd4:
              begin
                 first_mem_word_be[15:0] = 16'd0;
                 first_mem_word_be[19:16] = first_be[3:0];
                 if (payload_size <= 7'd1)
                   first_mem_word_be[31:20] = 12'd0;
                 else if (payload_size == 7'd2)
                   first_mem_word_be[31:20] = {8'd0, last_be[3:0]};
                 else if (payload_size == 7'd3)
                   first_mem_word_be[31:20] = {4'd0, last_be[3:0], 4'hf};
                 else if (payload_size == 7'd4)
                   first_mem_word_be[31:20] = {last_be[3:0], 8'hff};
                 else
                   first_mem_word_be[31:20] = 12'hfff;
              end // case: 3'd4

            3'd5:
              begin
                 first_mem_word_be[19:0] = 20'd0;
                 first_mem_word_be[23:20] = first_be[3:0];
                 if (payload_size <= 7'd1)
                   first_mem_word_be[31:24] = 8'd0;
                 else if (payload_size == 7'd2)
                   first_mem_word_be[31:24] = {4'd0, last_be[3:0]};
                 else if (payload_size == 7'd3)
                   first_mem_word_be[31:24] = {last_be[3:0], 4'hf};
                 else
                   first_mem_word_be[31:24] = 8'hff;
              end // case: 3'd5

            3'd6:
              begin
                 first_mem_word_be[23:0] = 24'd0;
                 first_mem_word_be[27:24] = first_be[3:0];
                 if (payload_size <= 7'd1)
                   first_mem_word_be[31:28] = 4'd0;
                 else if (payload_size == 7'd2)
                   first_mem_word_be[31:28] = last_be[3:0];
                 else
                   first_mem_word_be[31:28] = 4'hf;
              end // case: 3'd6

            default:
              begin
                 first_mem_word_be[27:0] = 28'd0;
                 first_mem_word_be[31:28] = first_be[3:0];
              end
          endcase // case(mem_addr[4:2])
     end // always @ (*)
   
   
   // Determine if the write payload extends to more than one cycle on the memory interface.
   always @(*)
     begin
        if (qw_aligned_addr) // MemWr with QW-aligned address
          // Payload starts in Dword 4
        case(mem_addr[4:2])
            3'd5: mem_cycle_count_1 = (payload_size <= 7'd3);
            3'd6: mem_cycle_count_1 = (payload_size <= 7'd2);
            3'd7: mem_cycle_count_1 = (payload_size <= 7'd1);
            default:  mem_cycle_count_1 = (payload_size <= 7'd4);
          endcase // case(mem_addr[4:2])
        else if (~addr_64) // 32-bit MemWr with unaligned address
          // Payload starts in Dword 3
          case(mem_addr[4:2])
            3'd4: mem_cycle_count_1 = (payload_size <= 7'd4);
            3'd5: mem_cycle_count_1 = (payload_size <= 7'd3);
            3'd6: mem_cycle_count_1 = (payload_size <= 7'd2);
            3'd7: mem_cycle_count_1 = (payload_size <= 7'd1);
            default:  mem_cycle_count_1 = (payload_size <= 7'd5);
          endcase // case(mem_addr[4:2])
        else // 32-bit MemWr with unaligned address
          // Payload starts in Dword 5
          case(mem_addr[4:2])
            3'd6: mem_cycle_count_1 = (payload_size <= 7'd2);
            3'd7: mem_cycle_count_1 = (payload_size <= 7'd1);
            default:  mem_cycle_count_1 = (payload_size <= 7'd3);
          endcase // case(mem_addr[4:2])
     end

   // Read-Write State Machine
   always @(posedge clk_i)
     if (~rstn_i) 
       begin
          req_header <= 64'd0;
          ram_address <= 13'd0;
          ram_wr_data <= 256'd0;
          ram_wr_byte_enable <= 32'd0;
          ram_wren <= 1'b0;
          
          dwords_to_write <= 7'd0;
          saved_wr_data <= 128'd0;
          saved_dword_count <= 3'd0;
          first_be_reg <= 4'd0;
          last_be_reg <= 4'd0;
          low_addr_reg <= 7'd0;
          write_dw_offset <= 3'd0;

          mem_addr_reg[6:2] <= 5'd0;
          qw_aligned_addr_reg <= 1'b0;
          addr_64_reg <= 1'b0;
          req_function <= 8'd0;
          zero_length_req_reg <= 1'b0;

          tx_st_data_o <= {port_width_data_hwtcl{1'b0}};
          tx_st_empty_o <= 2'b00;
          tx_st_sop_o <= {multiple_packets_per_cycle_hwtcl+1{1'b0}};
          tx_st_eop_o <= {multiple_packets_per_cycle_hwtcl+1{1'b0}};
          tx_st_err_o <= {multiple_packets_per_cycle_hwtcl+1{1'b0}};
          tx_st_valid_o <= {multiple_packets_per_cycle_hwtcl+1{1'b0}};
          dwords_to_read <= 7'd0;
          dwords_sent_this_cycle <= 7'd0;

          read_dw_sel0 <= 4'd0;
          read_dw_sel1 <= 4'd0;
          read_dw_sel2 <= 4'd0;
          read_dw_sel3 <= 4'd0;
          read_dw_sel4 <= 4'd0;
          read_dw_sel5 <= 4'd0;
          read_dw_sel6 <= 4'd0;
          read_dw_sel7 <= 4'd0;
          saved_read_data <= 192'd0;
          saved_dw_offset <= 3'd0;
       end
     else
       case(1'b1) // synthesis parallel_case
         target_app_state[IDLE]:
           begin
              tx_st_valid_o     <= {multiple_packets_per_cycle_hwtcl+1{1'b0}};

              req_header        <= {header_byte7, header_byte6, header_byte5, header_byte4,
                                    header_byte3, header_byte2, header_byte1, header_byte0};
              ram_address       <= {rx_st_bar_hit_fn_i, rx_st_req_bar_hit_tlp0_i[1:0], mem_addr[7:5]}; //mem_addr[17:5]
              first_be_reg      <= first_be;
              last_be_reg       <= last_be;
              mem_addr_reg[6:2] <= mem_addr[6:2];
              // Remember if the address is Qword-aligned
              qw_aligned_addr_reg <= qw_aligned_addr;
              addr_64_reg         <= addr_64;
              req_function        <= rx_st_bar_hit_fn_i;
              zero_length_req_reg <= zero_length_req;
              compl_byte_count    <= {payload_size, 2'b00};
              compl_byte_count_adj <= 9'd0;

              if (zero_length_req)
                dwords_to_read <= 7'd1;
              else
                dwords_to_read <= payload_size;

              // Set up write data
              if (qw_aligned_addr)
                // Payload starts in Dword 4
                case(mem_addr[4:2])
                  3'd0: ram_wr_data <= {128'd0, rx_st_data_i[255:128]};
                  3'd1: ram_wr_data <= {96'd0, rx_st_data_i[255:128], 32'd0};
                  3'd2: ram_wr_data <= {64'd0, rx_st_data_i[255:128], 64'd0};
                  3'd3: ram_wr_data <= {32'd0, rx_st_data_i[255:128], 96'd0};
                  3'd4: ram_wr_data <= {rx_st_data_i[255:128], 128'd0};
                  3'd5: ram_wr_data <= {rx_st_data_i[223:128], 160'd0};
                  3'd6: ram_wr_data <= {rx_st_data_i[191:128], 192'd0};
                  default: ram_wr_data <= {rx_st_data_i[159:128], 224'd0};
                endcase // case(mem_addr[4:2])
              else if (~addr_64)
                // Payload starts in Dword 3
                case(mem_addr[4:2])
                  3'd0: ram_wr_data <= {96'd0, rx_st_data_i[255:96]};
                  3'd1: ram_wr_data <= {64'd0, rx_st_data_i[255:96], 32'd0};
                  3'd2: ram_wr_data <= {32'd0, rx_st_data_i[255:96], 64'd0};
                  3'd3: ram_wr_data <= {rx_st_data_i[255:96], 96'd0};
                  3'd4: ram_wr_data <= {rx_st_data_i[223:96], 128'd0};
                  3'd5: ram_wr_data <= {rx_st_data_i[191:96], 160'd0};
                  3'd6: ram_wr_data <= {rx_st_data_i[159:96], 192'd0};
                  default: ram_wr_data <= {rx_st_data_i[127:96], 224'd0};
                endcase // case(mem_addr[4:2])
              else
                // Payload starts in Dword 5
                case(mem_addr[4:2])
                  3'd0: ram_wr_data <= {160'd0, rx_st_data_i[255:160]};
                  3'd1: ram_wr_data <= {128'd0, rx_st_data_i[255:160], 32'd0};
                  3'd2: ram_wr_data <= {96'd0, rx_st_data_i[255:160], 64'd0};
                  3'd3: ram_wr_data <= {64'd0, rx_st_data_i[255:160], 96'd0};
                  3'd4: ram_wr_data <= {32'd0, rx_st_data_i[255:160], 128'd0};
                  3'd5: ram_wr_data <= {rx_st_data_i[255:160], 160'd0};
                  3'd6: ram_wr_data <= {rx_st_data_i[223:160], 192'd0};
                  default: ram_wr_data <= {rx_st_data_i[191:160], 224'd0};
                endcase // case(mem_addr[4:2])
              
              // Set up write enable
              ram_wr_byte_enable <= first_mem_word_be;

              // Save any remaining data for the next cycle
              if (qw_aligned_addr)
                // Payload starts in Dword 4
                case (mem_addr[4:2])
                  3'd7: saved_wr_data[95:0] <= rx_st_data_i[255:160];
                  3'd6: saved_wr_data[63:0] <= rx_st_data_i[255:192];
                  default: saved_wr_data[31:0] <= rx_st_data_i[255:224];
                endcase // case (mem_addr[4:2])
              else if (~addr_64)
                // Payload starts in Dword 3
                case (mem_addr[4:2])
                  3'd7: saved_wr_data[127:0] <= rx_st_data_i[255:128];
                  3'd6: saved_wr_data[95:0] <= rx_st_data_i[255:160];
                  3'd5: saved_wr_data[63:0] <= rx_st_data_i[255:192];
                  default: saved_wr_data[31:0] <= rx_st_data_i[255:224];
                endcase // case (mem_addr[4:2])
              else
                // Payload starts in Dword 5
                case (mem_addr[4:2])
                  3'd7: saved_wr_data[63:0] <= rx_st_data_i[255:192];
                  default: saved_wr_data[31:0] <= rx_st_data_i[255:224];
                endcase // case (mem_addr[4:2])

              // Determine the number of Dwords saved for next cycle
              if (qw_aligned_addr)
                // Payload starts in Dword 4
                begin
                   case(mem_addr[4:2])
                     3'd7:
                       begin
                          if (payload_size <= 7'd1)
                            saved_dword_count <= 3'd0;
                          else if (payload_size == 7'd2)
                            saved_dword_count <= 3'd1;
                          else if (payload_size == 7'd3)
                            saved_dword_count <= 3'd2;
                          else
                            saved_dword_count <= 3'd3;
                       end

                     3'd6:
                       begin
                          if (payload_size <= 7'd2)
                            saved_dword_count <= 3'd0;
                          else if (payload_size == 7'd3)
                            saved_dword_count <= 3'd1;
                          else
                            saved_dword_count <= 3'd2;
                       end
                     3'd5:
                       begin
                          if (payload_size <= 7'd3)
                            saved_dword_count <= 3'd0;
                          else 
                            saved_dword_count <= 3'd1;
                       end
                     default:
                       begin
                          saved_dword_count <= 3'd0;
                       end
                   endcase // case(mem_addr[4:2])
                end // if (addr_64  |...
              else if (~addr_64)
                // Payload starts in Dword 3
                begin
                   case(mem_addr[4:2])
                     3'd7:                   
                       begin
                          if (payload_size <= 7'd1)
                            saved_dword_count <= 3'd0;
                          else if (payload_size == 7'd2)
                            saved_dword_count <= 3'd1;
                          else if (payload_size == 7'd3)
                            saved_dword_count <= 3'd2;
                          else if (payload_size == 7'd4)
                            saved_dword_count <= 3'd3;
                          else
                            saved_dword_count <= 3'd4;
                       end // case: 3'd7
                     3'd6:
                       begin
                          if (payload_size <= 7'd2)
                            saved_dword_count <= 3'd0;
                          else if (payload_size == 7'd3)
                            saved_dword_count <= 3'd1;
                          else if (payload_size == 7'd4)
                            saved_dword_count <= 3'd2;
                          else
                            saved_dword_count <= 3'd3;
                       end // case: 3'd6
                     3'd5:
                       begin
                          if (payload_size <= 7'd3)
                            saved_dword_count <= 3'd0;
                          else if (payload_size == 7'd4)
                            saved_dword_count <= 3'd1;
                          else
                            saved_dword_count <= 3'd2;
                       end // case: 3'd5
                     3'd4:
                       begin
                          if (payload_size <= 7'd4)
                            saved_dword_count <= 3'd0;
                          else
                            saved_dword_count <= 3'd1;
                       end
                     default: saved_dword_count <= 3'd0;
                   endcase // case(mem_addr[4:2])
                end // if (~addr_64)
              else
                // Payload starts in Dword 5
                begin
                   case(mem_addr[4:2])
                     3'd7:
                       begin
                          if (payload_size <= 7'd1)
                            saved_dword_count <= 3'd0;
                          else if (payload_size == 7'd2)
                            saved_dword_count <= 3'd1;
                          else
                            saved_dword_count <= 3'd2;
                       end

                     3'd6:
                       begin
                          if (payload_size <= 7'd2)
                            saved_dword_count <= 3'd0;
                          else
                            saved_dword_count <= 3'd1;
                       end
                     default:
                       begin
                          saved_dword_count <= 3'd0;
                       end
                   endcase // case(mem_addr[4:2])
                end // else: !if(~addr_64)

              // Determine number of Dwords remaining to bee written
              if (qw_aligned_addr)
                // Payload starts in Dword 4
                begin
                   case(mem_addr[4:2])
                     3'd5: dwords_to_write <= payload_size - 7'd3;
                     3'd6: dwords_to_write <= payload_size - 7'd2;
                     3'd7: dwords_to_write <= payload_size - 7'd1;
                     default: dwords_to_write <= payload_size - 7'd4;
                   endcase // case(mem_addr[4:2])
                end
              else if (~addr_64)
                // Payload starts in Dword 3
                begin
                   case(mem_addr[4:2])
                     3'd4: dwords_to_write <= payload_size - 7'd4;
                     3'd5: dwords_to_write <= payload_size - 7'd3;
                     3'd6: dwords_to_write <= payload_size - 7'd2;
                     3'd7: dwords_to_write <= payload_size - 7'd1;
                     default: dwords_to_write <= payload_size - 7'd5;
                   endcase // case(mem_addr[4:2])
                end // else: !if(addr_64  |...
              else
                // Payload starts in Dword 5
                begin
                   case(mem_addr[4:2])
                     3'd6: dwords_to_write <= payload_size - 7'd2;
                     3'd7: dwords_to_write <= payload_size - 7'd1;
                     default: dwords_to_write <= payload_size - 7'd3;
                   endcase // case (mem_addr[4:2])
                end // else: !if(~addr_64)

              // If we have more data to write into the first word of the RAM, determine the Dword offset
              // to start writing in the next cycle

              if (qw_aligned_addr)
                // Payload starts in Dword 4
                case(mem_addr[4:2])
                  3'd0: write_dw_offset <= 3'd4;
                  3'd1: write_dw_offset <= 3'd5;
                  3'd2: write_dw_offset <= 3'd6;
                  default: write_dw_offset <= 3'd7;
                endcase // case (mem_addr[4:2])
              else if (~addr_64)
                // Payload starts in Dword 3
                case(mem_addr[4:2])
                  3'd0: write_dw_offset <= 3'd5;
                  3'd1: write_dw_offset <= 3'd6;
                  default: write_dw_offset <= 3'd7;
                endcase // case (mem_addr[4:2])
              else
                // Payload starts in Dword 5
                case(mem_addr[4:2])
                  3'd0: write_dw_offset <= 3'd3;
                  3'd1: write_dw_offset <= 3'd4;
                  3'd2: write_dw_offset <= 3'd5;
                  3'd3: write_dw_offset <= 3'd6;
                  default: write_dw_offset <= 3'd7;
                endcase // case (mem_addr[4:2])
                   
              // Process Mem Wr
              if (rx_st_valid_i[0] & rx_st_sop_i[0] & ~rx_st_err_i[0] & mem_wr_tlp) 
                ram_wren <= 1'b1;
              else
                ram_wren <= 1'b0;
           end // case: target_app_state[IDLE]

         target_app_state[WRITE_PAYLOAD_FIRST_CYCLE]:
           // Extra cycle to complete write of first word
           begin
              // Set up write data
              case(write_dw_offset)
                3'd3: ram_wr_data[255:96] <= rx_st_data_i[159:0];
                3'd4: ram_wr_data[255:128] <= rx_st_data_i[127:0];
                3'd5: ram_wr_data[255:160] <= rx_st_data_i[95:0];
                3'd6: ram_wr_data[255:192] <= rx_st_data_i[63:0];
                default: ram_wr_data[255:224] <= rx_st_data_i[31:0];
              endcase // case (write_dw_offset)
              // Set up write enables
              
              // Set up byte enables
              case(write_dw_offset)
                3'd1: 
                  begin
                     if (dwords_to_write > 7'd7)
                       ram_wr_byte_enable <= 32'hffff_fff0;
                     else
                       case(dwords_to_write[2:0])
                         3'd7: ram_wr_byte_enable <= {last_be_reg, 28'hfff_fff0};
                         3'd6: ram_wr_byte_enable <= {4'd0, last_be_reg, 24'hff_fff0};
                         3'd5: ram_wr_byte_enable <= {8'd0, last_be_reg, 20'hf_fff0};
                         3'd4: ram_wr_byte_enable <= {12'd0, last_be_reg, 16'hfff0};
                         3'd3: ram_wr_byte_enable <= {16'd0, last_be_reg, 12'hff0};
                         3'd2: ram_wr_byte_enable <= {20'd0, last_be_reg, 8'hf0};
                         default: ram_wr_byte_enable <= {24'd0, last_be_reg, 4'h0};
                       endcase // case (dwords_to_write[2:0])
                  end // case: 3'd1
                3'd2:
                  begin
                     if (dwords_to_write > 7'd6)
                       ram_wr_byte_enable <= 32'hffff_ff00;
                     else
                       case(dwords_to_write[2:0])
                         3'd6: ram_wr_byte_enable <= {last_be_reg, 28'hfff_ff00};
                         3'd5: ram_wr_byte_enable <= {4'd0, last_be_reg, 24'hff_ff00};
                         3'd4: ram_wr_byte_enable <= {8'd0, last_be_reg, 20'hf_ff00};
                         3'd3: ram_wr_byte_enable <= {12'd0, last_be_reg, 16'hff00};
                         3'd2: ram_wr_byte_enable <= {16'd0, last_be_reg, 12'hf00};
                         default: ram_wr_byte_enable <= {20'd0, last_be_reg, 8'h00};
                       endcase // case (dwords_to_write[2:0])
                  end // case: 3'd2
                3'd3:
                  begin
                     if (dwords_to_write > 7'd5)
                       ram_wr_byte_enable <= 32'hffff_f000;
                     else
                       case(dwords_to_write[2:0])
                         3'd5: ram_wr_byte_enable <= {last_be_reg, 28'hfff_f000};
                         3'd4: ram_wr_byte_enable <= {4'd0, last_be_reg, 24'hff_f000};
                         3'd3: ram_wr_byte_enable <= {8'd0, last_be_reg, 20'hf_0000};
                         3'd2: ram_wr_byte_enable <= {12'd0, last_be_reg, 16'hf000};
                         default: ram_wr_byte_enable <= {16'd0, last_be_reg, 12'h000};
                       endcase // case (dwords_to_write[2:0])
                  end // case: 3'd3
                
                3'd4:
                  begin
                     if (dwords_to_write > 7'd4)
                       ram_wr_byte_enable <= 32'hffff_0000;
                     else
                       case(dwords_to_write[2:0])
                         3'd4: ram_wr_byte_enable <= {last_be_reg, 28'hfff_0000};
                         3'd3: ram_wr_byte_enable <= {4'd0, last_be_reg, 24'hff_0000};
                         3'd2: ram_wr_byte_enable <= {8'd0, last_be_reg, 20'hf_0000};
                         default: ram_wr_byte_enable <= {12'd0, last_be_reg, 16'h0000};
                       endcase // case (dwords_to_write[2:0])
                  end // case: 3'd4
                
                3'd5:
                  begin
                     if (dwords_to_write > 7'd3)
                       ram_wr_byte_enable <= 32'hfff0_0000;
                     else
                       case(dwords_to_write[2:0])
                         3'd3: ram_wr_byte_enable <= {last_be_reg, 28'hff0_0000};
                         3'd2: ram_wr_byte_enable <= {4'd0, last_be_reg, 24'hf0_0000};
                         default: ram_wr_byte_enable <= {8'd0, last_be_reg, 20'h0_0000};
                       endcase // case (dwords_to_write[2:0])
                  end // case: 3'd5
                
                3'd6:
                  begin
                     if (dwords_to_write > 7'd2)
                       ram_wr_byte_enable <= 32'hff00_0000;
                     else
                       case(dwords_to_write[2:0])
                         3'd2: ram_wr_byte_enable <= {last_be_reg, 28'hf00_0000};
                         default: ram_wr_byte_enable <= {4'd0, last_be_reg, 24'h00_0000};
                       endcase // case (dwords_to_write[2:0])
                  end

                default:
                  begin
                     if (dwords_to_write > 7'd1)
                       ram_wr_byte_enable <= 32'hf000_0000;
                     else
                       ram_wr_byte_enable <= {last_be_reg, 28'h0};
                  end
              endcase // case (write_dw_offset)
              
              // Save any remaining data for the next cycle
              if (qw_aligned_addr_reg) // MemWr with QW-aligned address
                // Payload starts in Dword 4
                begin
                   case(mem_addr_reg[4:2])
                     3'd0: saved_wr_data[127:0] <= rx_st_data_i[255:128];
                     3'd1: saved_wr_data[159:0] <= rx_st_data_i[255:96];
                     3'd2: saved_wr_data[191:0] <= rx_st_data_i[255:64];
                     default: saved_wr_data[223:0] <= rx_st_data_i[255:32];
                   endcase // case (mem_addr[4:2])
                end
              else if (~addr_64_reg)
                // Payload starts in Dword 3
                begin
                   case(mem_addr_reg[4:2])
                     3'd0: saved_wr_data[159:0] <= rx_st_data_i[255:96];
                     3'd1: saved_wr_data[191:0] <= rx_st_data_i[255:64];
                     default: saved_wr_data[223:0] <= rx_st_data_i[255:32];
                   endcase // case (mem_addr_reg[4:2])
                end
              else
                // Payload starts in Dword 5
                begin
                   case(mem_addr_reg[4:2])
                     3'd0: saved_wr_data[95:0] <= rx_st_data_i[255:160];
                     3'd1: saved_wr_data[127:0] <= rx_st_data_i[255:128];
                     3'd2: saved_wr_data[159:0] <= rx_st_data_i[255:96];
                     3'd3: saved_wr_data[191:0] <= rx_st_data_i[255:64];
                     default: saved_wr_data[223:0] <= rx_st_data_i[255:32];
                   endcase // case (mem_addr_reg[4:2])
                end // else: !if(aligned_addr_reg)

              saved_dword_count <= write_dw_offset;
              
              if (rx_st_valid_i[0])
                begin
                   case(write_dw_offset)
                     3'd1: dwords_to_write <= dwords_to_write - 7'd7;
                     3'd2: dwords_to_write <= dwords_to_write - 7'd6;
                     3'd3: dwords_to_write <= dwords_to_write - 7'd5;
                     3'd4: dwords_to_write <= dwords_to_write - 7'd4;
                     3'd5: dwords_to_write <= dwords_to_write - 7'd3;
                     3'd6: dwords_to_write <= dwords_to_write - 7'd2;
                     default: dwords_to_write <= dwords_to_write - 7'd1;
                   endcase // case (write_dw_offset)
                   ram_wren <= 1'b1;
                end
              else
                ram_wren <= 1'b0;
           end // case: target_app_state[WRITE_PAYLOAD_FIRST_CYCLE]

         target_app_state[WRITE_PAYLOAD]:
           begin
              // Set up write data
              case(saved_dword_count)
                3'd7: ram_wr_data <= {rx_st_data_i[31:0], saved_wr_data[223:0]};
                3'd6: ram_wr_data <= {rx_st_data_i[63:0], saved_wr_data[191:0]};
                3'd5: ram_wr_data <= {rx_st_data_i[95:0], saved_wr_data[159:0]};
                3'd4: ram_wr_data <= {rx_st_data_i[127:0], saved_wr_data[127:0]};
                3'd3: ram_wr_data <= {rx_st_data_i[159:0], saved_wr_data[95:0]};
                3'd2: ram_wr_data <= {rx_st_data_i[191:0], saved_wr_data[63:0]};
                3'd1: ram_wr_data <= {rx_st_data_i[223:0], saved_wr_data[31:0]};
                default: ram_wr_data <= rx_st_data_i[255:0];
              endcase // case(saved_dword_count)

              // Set up byte enables
              if (dwords_to_write > 7'd8)
                ram_wr_byte_enable <= 32'hffff_ffff;
              else if (dwords_to_write[3])
                ram_wr_byte_enable <= {last_be_reg, 28'hfff_ffff};
              else
                case(dwords_to_write[2:0])
                  3'd7: ram_wr_byte_enable <= {4'd0, last_be_reg, 24'hff_ffff};
                  3'd6: ram_wr_byte_enable <= {8'd0, last_be_reg, 20'hf_ffff};
                  3'd5: ram_wr_byte_enable <= {12'd0, last_be_reg, 16'hffff};
                  3'd4: ram_wr_byte_enable <= {16'd0, last_be_reg, 12'hfff};
                  3'd3: ram_wr_byte_enable <= {20'd0, last_be_reg, 8'hff};
                  3'd2: ram_wr_byte_enable <= {24'd0, last_be_reg, 4'hf};
                  default: ram_wr_byte_enable <= {28'd0, last_be_reg};
                endcase // case (dwords_to_write[2:0])
              
              // Save any remaining data for the next cycle
              if (rx_st_valid_i[0])
                case(saved_dword_count)
                  3'd7: saved_wr_data[223:0] <= rx_st_data_i[255:32];
                  3'd6: saved_wr_data[191:0] <= rx_st_data_i[255:64];
                  3'd5: saved_wr_data[159:0] <= rx_st_data_i[255:96];
                  3'd4: saved_wr_data[127:0] <= rx_st_data_i[255:128];
                  3'd3: saved_wr_data[95:0] <= rx_st_data_i[255:160];
                  3'd2: saved_wr_data[63:0] <= rx_st_data_i[255:192];
                  default: saved_wr_data[31:0] <= rx_st_data_i[255:224];
                endcase // case (saved_dword_count)

              if (rx_st_valid_i[0])
                begin
                   ram_address <= ram_address + 13'd1;
                   ram_wren <= 1'b1;
                   dwords_to_write <= dwords_to_write - 7'd8;
                end
              else
                ram_wren <= 1'b0;
           end // case: target_app_state[WRITE_PAYLOAD]

         target_app_state[WRITE_SPILL_WORD]: // Write remaining data into RAM
           begin
              // Set up write data
              ram_wr_data[223:0] <= saved_wr_data[223:0];
              ram_address <= ram_address + 13'd1;
              // Set up byte enables
              case(dwords_to_write[2:0])
                3'd7: ram_wr_byte_enable <= {4'd0, last_be_reg, 24'hff_ffff};
                3'd6: ram_wr_byte_enable <= {8'd0, last_be_reg, 20'hf_ffff};
                3'd5: ram_wr_byte_enable <= {12'd0, last_be_reg, 16'hffff};
                3'd4: ram_wr_byte_enable <= {16'd0, last_be_reg, 12'hfff};
                3'd3: ram_wr_byte_enable <= {20'd0, last_be_reg, 8'hff};
                3'd2: ram_wr_byte_enable <= {24'd0, last_be_reg, 4'hf};
                default: ram_wr_byte_enable <= {28'd0, last_be_reg};
              endcase // case (dwords_to_write[2:0])
              
              ram_wren <= 1'b1;
           end // case: target_app_state[WRITE_SPILL_WORD]

         target_app_state[START_READ]:
           // Start a memory read
           begin
              // Determine Dwords sent in first cycle
              case(mem_addr_reg[4:2])
                3'd0: dwords_sent_this_cycle <= 7'd4;
                3'd1: dwords_sent_this_cycle <= 7'd5;
                3'd2: dwords_sent_this_cycle <= 7'd4;
                3'd3: dwords_sent_this_cycle <= 7'd5;
                3'd4: dwords_sent_this_cycle <= 7'd4;
                3'd5: dwords_sent_this_cycle <= 7'd3;
                3'd6: dwords_sent_this_cycle <= 7'd2;
                3'd7: dwords_sent_this_cycle <= 7'd1;
              endcase // case (mem_addr_reg[4:2])

              // Determine byte count increment based on byte enables
              casex({last_be_reg, first_be_reg})
                8'b0001_xxx1: compl_byte_count_adj <= 9'd3;
                8'b0001_xx10: compl_byte_count_adj <= 9'd4;
                8'b0001_x100: compl_byte_count_adj <= 9'd5;
                8'b0001_1000: compl_byte_count_adj <= 9'd6;
                
                8'b001x_xxx1: compl_byte_count_adj <= 9'd2;
                8'b001x_xx10: compl_byte_count_adj <= 9'd3;
                8'b001x_x100: compl_byte_count_adj <= 9'd4;
                8'b001x_1000: compl_byte_count_adj <= 9'd5;

                8'b01xx_xxx1: compl_byte_count_adj <= 9'd1;
                8'b01xx_xx10: compl_byte_count_adj <= 9'd2;
                8'b01xx_x100: compl_byte_count_adj <= 9'd3;
                8'b01xx_1000: compl_byte_count_adj <= 9'd4;

                8'b1xxx_xxx1: compl_byte_count_adj <= 9'd0;
                8'b1xxx_xx10: compl_byte_count_adj <= 9'd1;
                8'b1xxx_x100: compl_byte_count_adj <= 9'd2;
                8'b1xxx_1000: compl_byte_count_adj <= 9'd3;

                default: compl_byte_count_adj <= 9'd0;
              endcase // casex ({last_be_reg, first_be_reg})
              ram_wr_byte_enable <= 32'd0;
              if (tx_st_ready_reg)
                ram_address <= ram_address + 13'd1;
           end // case: target_app_state[START_READ]
         
         target_app_state[MEM_READ_WAIT_FOR_DATA_1]:
           begin
              ram_address <= ram_address + 13'd1;
           end
         
         target_app_state[MEM_READ_WAIT_FOR_DATA_2]:
           begin
              ram_address <= ram_address + 13'd1;

              low_addr_reg[6:2] <= mem_addr_reg[6:2];
              casex(first_be_reg)
                4'b0000: low_addr_reg[1:0] <= 2'b00;
                4'bxxx1: low_addr_reg[1:0] <= 2'b00;
                4'bxx10: low_addr_reg[1:0] <= 2'b01;
                4'bx100: low_addr_reg[1:0] <= 2'b10;
                4'b1000: low_addr_reg[1:0] <= 2'b11;
              endcase // casex (first_be_reg)

              casex({last_be_reg, first_be_reg})
                8'b0000_000x: compl_byte_count <= 9'd1;
                8'b0000_0010: compl_byte_count <= 9'd1;
                8'b0000_0011: compl_byte_count <= 9'd2;
                8'b0000_0100: compl_byte_count <= 9'd1;
                8'b0000_01x1: compl_byte_count <= 9'd3;
                8'b0000_0110: compl_byte_count <= 9'd2;
                8'b0000_1000: compl_byte_count <= 9'd1;
                8'b0000_1xx1: compl_byte_count <= 9'd4;
                8'b0000_1x10: compl_byte_count <= 9'd3;
                8'b0000_1100: compl_byte_count <= 9'd2;
                default: compl_byte_count <= compl_byte_count - compl_byte_count_adj;
              endcase // casex ({last_be_reg, first_be_reg})

              if (~mem_addr_reg[2]) // QW-aligned address, start payload at Dword 4
                begin
                   read_dw_sel0 <= 4'd8; // Not used
                   read_dw_sel1 <= 4'd8; // Not used
                   read_dw_sel2 <= 4'd8; // Not used
                   read_dw_sel3 <= 4'd8; // Not used
                   case(mem_addr_reg[4:2])
                     3'd0:  
                       begin
                        read_dw_sel4 <= 4'd0;
                        read_dw_sel5 <= 4'd1;
                        read_dw_sel6 <= 4'd2;
                        read_dw_sel7 <= 4'd3;
                     end
                     3'd2:  
                       begin
                        read_dw_sel4 <= 4'd2;
                        read_dw_sel5 <= 4'd3;
                        read_dw_sel6 <= 4'd4;
                        read_dw_sel7 <= 4'd5;
                       end
                     3'd4:  
                       begin
                        read_dw_sel4 <= 4'd4;
                        read_dw_sel5 <= 4'd5;
                        read_dw_sel6 <= 4'd6;
                        read_dw_sel7 <= 4'd7;
                       end
                     3'd6:
                       begin
                        read_dw_sel4 <= 4'd6;
                        read_dw_sel5 <= 4'd7;
                        read_dw_sel6 <= 4'd8; // Not used
                        read_dw_sel7 <= 4'd8; // Not used
                       end
                     default:
                       begin
                        read_dw_sel4 <= 4'd8; // Not used
                        read_dw_sel5 <= 4'd8; // Not used
                        read_dw_sel6 <= 4'd8; // Not used
                        read_dw_sel7 <= 4'd8; // Not used
                       end
                   endcase // case (mem_addr_reg[5:3])
                end // if (~mem_addr_reg[2])
              else
                // Start payload at Dword 3
                begin
                   read_dw_sel0 <= 4'd8; // Not used
                   read_dw_sel1 <= 4'd8; // Not used
                   read_dw_sel2 <= 4'd8; // Not used
                   case(mem_addr_reg[4:2])
                     3'd1:  
                       begin
                        read_dw_sel3 <= 4'd1;
                        read_dw_sel4 <= 4'd2;
                        read_dw_sel5 <= 4'd3;
                        read_dw_sel6 <= 4'd4;
                        read_dw_sel7 <= 4'd5;
                     end
                     3'd3:  
                       begin
                        read_dw_sel3 <= 4'd3;
                        read_dw_sel4 <= 4'd4;
                        read_dw_sel5 <= 4'd5;
                        read_dw_sel6 <= 4'd6;
                        read_dw_sel7 <= 4'd7;
                     end
                     3'd5:  
                       begin
                        read_dw_sel3 <= 4'd5;
                        read_dw_sel4 <= 4'd6;
                        read_dw_sel5 <= 4'd7;
                          read_dw_sel6 <= 4'd8; // Not used
                          read_dw_sel7 <= 4'd8; // Not used
                       end
                     default:
                       begin
                          read_dw_sel3 <= 4'd7;
                          read_dw_sel4 <= 4'd8; // Not used
                          read_dw_sel5 <= 4'd8; // Not used
                          read_dw_sel6 <= 4'd8; // Not used
                          read_dw_sel7 <= 4'd8; // Not used
                       end
                   endcase // case (mem_addr_reg[5:3])
                end // else: !if(~mem_addr_reg[2])

              // Determine offset of data to be saved for next cycle
              case(mem_addr_reg[4:2])
                3'd0: 
                  saved_dw_offset <= 3'd4; // Save Dwords 4 - 7
                default:
                  saved_dw_offset <= 3'd6; // Save Dwords 6 - 7
              endcase // case (mem_addr_reg[4:2])
           end // case: target_app_state[MEM_READ_WAIT_FOR_DATA_2]

         target_app_state[SEND_COMPL_HDR]:
           begin
              // Send Read Completion Header
              tx_st_data_o[31:24] <= 8'h4a; // header byte 0
              tx_st_data_o[23:16] <= {1'b0, tc_field[2:0],
                                      1'b0, attr_field[2], 2'b0}; // header byte 1
              tx_st_data_o[15:0] <= {2'b0, attr_field[1:0], 4'b0}; // header byte 2
              tx_st_data_o[7:0] <= req_word_count[7:0]; // header byte 3
              // 
              tx_st_data_o[63:56] <= bus_num_i; // header byte 4
              tx_st_data_o[55:48] <= req_function; // header byte 5
              tx_st_data_o[47:40] <= zero_length_req_reg? 8'h0 :
                                     {7'h0, compl_byte_count[8]}; // header byte 6
              tx_st_data_o[39:32] <= zero_length_req_reg? 8'h1 :
                                     compl_byte_count[7:0]; // header byte 7
              // 
              tx_st_data_o[95:88] <= req_id[15:8]; // header byte 8
              tx_st_data_o[87:80] <= req_id[7:0]; // header byte 9
              tx_st_data_o[79:72] <= req_tag[7:0]; // header byte 10
              tx_st_data_o[71:64] <= {1'b0, low_addr_reg[6:0]}; // header byte 11

              // Set up payload
              if (read_dw_sel3[3]) // QW-aligned address, start payload at Dword 4
                tx_st_data_o[127:96] <= 32'd0;
              else
                case(read_dw_sel3[2:0])
                  3'd0: tx_st_data_o[127:96] <= ram_rd_data_reg[31:0];
                  3'd1: tx_st_data_o[127:96] <= ram_rd_data_reg[63:32];
                  3'd2: tx_st_data_o[127:96] <= ram_rd_data_reg[95:64];
                  3'd3: tx_st_data_o[127:96] <= ram_rd_data_reg[127:96];
                  3'd4: tx_st_data_o[127:96] <= ram_rd_data_reg[159:128];
                  3'd5: tx_st_data_o[127:96] <= ram_rd_data_reg[191:160];
                  3'd6: tx_st_data_o[127:96] <= ram_rd_data_reg[223:192];
                  default: tx_st_data_o[127:96] <= ram_rd_data_reg[255:224];
                endcase // case (read_dw_sel3[2:0])

              case(read_dw_sel4[2:0])
                3'd0: tx_st_data_o[159:128] <= ram_rd_data_reg[31:0];
                3'd1: tx_st_data_o[159:128] <= ram_rd_data_reg[63:32];
                3'd2: tx_st_data_o[159:128] <= ram_rd_data_reg[95:64];
                3'd3: tx_st_data_o[159:128] <= ram_rd_data_reg[127:96];
                3'd4: tx_st_data_o[159:128] <= ram_rd_data_reg[159:128];
                3'd5: tx_st_data_o[159:128] <= ram_rd_data_reg[191:160];
                3'd6: tx_st_data_o[159:128] <= ram_rd_data_reg[223:192];
                default: tx_st_data_o[159:128] <= ram_rd_data_reg[255:224];
              endcase // case (read_dw_sel4[2:0])

              case(read_dw_sel5[2:0])
                3'd0: tx_st_data_o[191:160] <= ram_rd_data_reg[31:0];
                3'd1: tx_st_data_o[191:160] <= ram_rd_data_reg[63:32];
                3'd2: tx_st_data_o[191:160] <= ram_rd_data_reg[95:64];
                3'd3: tx_st_data_o[191:160] <= ram_rd_data_reg[127:96];
                3'd4: tx_st_data_o[191:160] <= ram_rd_data_reg[159:128];
                3'd5: tx_st_data_o[191:160] <= ram_rd_data_reg[191:160];
                3'd6: tx_st_data_o[191:160] <= ram_rd_data_reg[223:192];
                default: tx_st_data_o[191:160] <= ram_rd_data_reg[255:224];
              endcase // case (read_dw_sel5[2:0])

              case(read_dw_sel6[2:0])
                3'd0: tx_st_data_o[223:192] <= ram_rd_data_reg[31:0];
                3'd1: tx_st_data_o[223:192] <= ram_rd_data_reg[63:32];
                3'd2: tx_st_data_o[223:192] <= ram_rd_data_reg[95:64];
                3'd3: tx_st_data_o[223:192] <= ram_rd_data_reg[127:96];
                3'd4: tx_st_data_o[223:192] <= ram_rd_data_reg[159:128];
                3'd5: tx_st_data_o[223:192] <= ram_rd_data_reg[191:160];
                3'd6: tx_st_data_o[223:192] <= ram_rd_data_reg[223:192];
                default: tx_st_data_o[223:192] <= ram_rd_data_reg[255:224];
              endcase // case (read_dw_sel6[2:0])

              case(read_dw_sel7[2:0])
                3'd0: tx_st_data_o[255:224] <= ram_rd_data_reg[31:0];
                3'd1: tx_st_data_o[255:224] <= ram_rd_data_reg[63:32];
                3'd2: tx_st_data_o[255:224] <= ram_rd_data_reg[95:64];
                3'd3: tx_st_data_o[255:224] <= ram_rd_data_reg[127:96];
                3'd4: tx_st_data_o[255:224] <= ram_rd_data_reg[159:128];
                3'd5: tx_st_data_o[255:224] <= ram_rd_data_reg[191:160];
                3'd6: tx_st_data_o[255:224] <= ram_rd_data_reg[223:192];
                default: tx_st_data_o[255:224] <= ram_rd_data_reg[255:224];
              endcase // case (read_dw_sel7[2:0])

              // Save data for next cycle when all the Dwords can't be sent in this cycle

              case (saved_dw_offset)
                3'd4: saved_read_data[127:0] <= ram_rd_data_reg[255:128];
                default: saved_read_data[63:0] <= ram_rd_data_reg[255:192];
              endcase // case (saved_dw_offset)


              // Send header and payload if we have enough data to fill the word.
              if (~mem_addr_reg[2]) // QW-aligned address, start payload at Dword 4
                begin
                   if (dwords_to_read >= 7'd4)
                     tx_st_valid_o[0] <= (mem_addr_reg[4:2] <= 3'd4);
                   else if (dwords_to_read[1:0] == 2'd3)
                     tx_st_valid_o[0] <= (mem_addr_reg[4:2] <= 3'd5);
                   else if (dwords_to_read[1:0] == 2'd2)
                     tx_st_valid_o[0] <= (mem_addr_reg[4:2] <= 3'd6);
                   else 
                     // 1 Dword to send
                     tx_st_valid_o[0] <= 1'b1;
                end // if (~mem_addr_reg[2])
              else
                // Start payload at Dword 3
                begin
                   if (dwords_to_read >= 3'd5)
                     tx_st_valid_o[0] <= (mem_addr_reg[4:2] <= 3'd3);
                   else if (dwords_to_read[2])
                     tx_st_valid_o[0] <= (mem_addr_reg[4:2] <= 3'd4);
                   else if (dwords_to_read[1:0] == 2'd3)
                     tx_st_valid_o[0] <= (mem_addr_reg[4:2] <= 3'd5);
                   else if (dwords_to_read[1:0] == 2'd2)
                     tx_st_valid_o[0] <= (mem_addr_reg[4:2] <= 3'd6);
                   else 
                     // 1 Dword to send
                     tx_st_valid_o[0] <= 1'b1;
                end // else: !if(~mem_addr_reg[2])

              // Update Dwords remaining to send
              dwords_to_read <= dwords_to_read - dwords_sent_this_cycle;

              // Determine the maximum number of Dwords to send in next cycle
              case (mem_addr_reg[4:2])
                3'd7: dwords_sent_this_cycle <= 7'd4;
                3'd6: dwords_sent_this_cycle <= 7'd2;
                3'd5: dwords_sent_this_cycle <= 7'd2;
                default: dwords_sent_this_cycle <= 7'd8;
              endcase

              tx_st_sop_o[0] <= 1'b1;
              tx_st_err_o[0] <= 1'b0;
              // Determine EOP
              if (~mem_addr_reg[2]) // QW-aligned address, start payload at Dword 4
                tx_st_eop_o[0] <= (dwords_to_read == 7'd1) ||
                                  ((dwords_to_read == 7'd2) && (mem_addr_reg[4:2] != 3'd7)) ||
                                  ((dwords_to_read == 7'd3) && (mem_addr_reg[4:2] <= 3'd5)) ||
                                  ((dwords_to_read == 7'd4) && (mem_addr_reg[4:2] <= 3'd4));
              else
                tx_st_eop_o[0] <= (dwords_to_read == 7'd1) ||
                                  ((dwords_to_read == 7'd2) && (mem_addr_reg[4:2] != 3'd7)) ||
                                  ((dwords_to_read == 7'd3) && (mem_addr_reg[4:2] <= 3'd5)) ||
                                  ((dwords_to_read == 7'd4) && (mem_addr_reg[4:2] <= 3'd4)) ||
                                  ((dwords_to_read == 7'd5) && (mem_addr_reg[4:2] <= 3'd3));
                   

              // Set Empty output
              if (mem_addr_reg[2] & (dwords_to_read == 7'd1)) // Total of 4 Dwords valid
                tx_st_empty_o <= 2'd2;
              else if ((mem_addr_reg[2] & (dwords_to_read <= 7'd3)) ||
                       (~mem_addr_reg[2] & (dwords_to_read <= 7'd2))) // Max 6 Dwords valid
                tx_st_empty_o <= 2'd1;
              else
                tx_st_empty_o <= 2'd0;

              // If the word is not full yet, do not send the header in this cycle.
              // Determine offset to complete filling it in next cycle.
              // If there is more data than we can send in this cycle, save the remainder of the word.
                   
              if (~mem_addr_reg[2]) // QW-aligned address, start payload at Dword 4
                begin
                   read_dw_sel4 <= 4'd7; // not used
                   case(mem_addr_reg[4:2])
                     3'd7: // Dwords 5, 6, 7 can't be filled in this cycle, do a second read
                       begin
                          read_dw_sel0 <= 4'd8; // Not used
                          read_dw_sel1 <= 4'd8; // Not used
                          read_dw_sel2 <= 4'd8; // Not used
                          read_dw_sel3 <= 4'd8; // Not used
                          read_dw_sel4 <= 4'd8; // Not used
                          read_dw_sel5 <= 4'd0;
                          read_dw_sel6 <= 4'd1;
                          read_dw_sel7 <= 4'd2;
                       end
                     3'd6: // Dwords 6, 7 can't be filled in this cycle, do a second read
                       begin
                          read_dw_sel0 <= 4'd8; // Not used
                          read_dw_sel1 <= 4'd8; // Not used
                          read_dw_sel2 <= 4'd8; // Not used
                          read_dw_sel3 <= 4'd8; // Not used
                          read_dw_sel4 <= 4'd8; // Not used
                          read_dw_sel5 <= 4'd8; // not used
                          read_dw_sel6 <= 4'd0;
                          read_dw_sel7 <= 4'd1;
                       end
                     3'd5: // Dwords 7 can't be filled in this cycle, do a second read
                       begin
                          read_dw_sel0 <= 4'd8; // Not used
                          read_dw_sel1 <= 4'd8; // Not used
                          read_dw_sel2 <= 4'd8; // Not used
                          read_dw_sel3 <= 4'd8; // Not used
                          read_dw_sel4 <= 4'd8; // Not used
                          read_dw_sel5 <= 4'd8; // not used
                          read_dw_sel6 <= 4'd8; // not used
                          read_dw_sel7 <= 4'd0;
                       end
                     3'd4: // The word is filled perfectly, start a new word next cycle
                       begin
                          read_dw_sel0 <= 4'd0;
                          read_dw_sel1 <= 4'd1;
                          read_dw_sel2 <= 4'd2;
                          read_dw_sel3 <= 4'd3;
                          read_dw_sel4 <= 4'd4;
                          read_dw_sel5 <= 4'd5;
                          read_dw_sel6 <= 4'd6;
                          read_dw_sel7 <= 4'd7;
                       end // case: 3'd4
                     3'd3: // One word to save for next cycle
                       begin
                          read_dw_sel0 <= 4'd8;  // send saved data
                          read_dw_sel1 <= 4'd0;
                          read_dw_sel2 <= 4'd1;
                          read_dw_sel3 <= 4'd2;
                          read_dw_sel4 <= 4'd3;
                          read_dw_sel5 <= 4'd4;
                          read_dw_sel6 <= 4'd5;
                          read_dw_sel7 <= 4'd6;
                       end // case: 3'd3
                     3'd2: // 2 words to save for next cycle
                       begin
                          read_dw_sel0 <= 4'd8;  // send saved data
                          read_dw_sel1 <= 4'd8;  // send saved data
                          read_dw_sel2 <= 4'd0;
                          read_dw_sel3 <= 4'd1;
                          read_dw_sel4 <= 4'd2;
                          read_dw_sel5 <= 4'd3;
                          read_dw_sel6 <= 4'd4;
                          read_dw_sel7 <= 4'd5;
                       end // case: 3'd2
                     3'd1: // 3 words to save for next cycle
                       begin
                          read_dw_sel0 <= 4'd8;  // send saved data
                          read_dw_sel1 <= 4'd8;  // send saved data
                          read_dw_sel2 <= 4'd8;  // send saved data
                          read_dw_sel3 <= 4'd0;
                          read_dw_sel4 <= 4'd1;
                          read_dw_sel5 <= 4'd2;
                          read_dw_sel6 <= 4'd3;
                          read_dw_sel7 <= 4'd4;
                       end // case: 3'd1
                     default:
                       begin
                          read_dw_sel0 <= 4'd8;  // send saved data
                          read_dw_sel1 <= 4'd8;  // send saved data
                          read_dw_sel2 <= 4'd8;  // send saved data
                          read_dw_sel3 <= 4'd8;  // send saved data
                          read_dw_sel4 <= 4'd0;
                          read_dw_sel5 <= 4'd1;
                          read_dw_sel6 <= 4'd2;
                          read_dw_sel7 <= 4'd3;
                       end // case: default
                   endcase // case (mem_addr_reg[4:2])
                end // if (~mem_addr_reg[2])
              else
                begin
                   case(mem_addr_reg[4:2])
                     3'd7: // Dwords 4, 5, 6, 7 can't be filled in this cycle, do a second read
                       begin
                          read_dw_sel0 <= 4'd8; // Not used
                          read_dw_sel1 <= 4'd8; // Not used
                          read_dw_sel2 <= 4'd8; // Not used
                          read_dw_sel3 <= 4'd8; // Not used
                          read_dw_sel4 <= 4'd0; 
                          read_dw_sel5 <= 4'd1;
                          read_dw_sel6 <= 4'd2;
                          read_dw_sel7 <= 4'd3;
                       end
                     3'd6: // Dwords 5, 6, 7 can't be filled in this cycle, do a second read
                       begin
                          read_dw_sel0 <= 4'd8; // Not used
                          read_dw_sel1 <= 4'd8; // Not used
                          read_dw_sel2 <= 4'd8; // Not used
                          read_dw_sel3 <= 4'd8; // Not used
                          read_dw_sel4 <= 4'd8; // Not used
                          read_dw_sel5 <= 4'd0;
                          read_dw_sel6 <= 4'd1;
                          read_dw_sel7 <= 4'd2;
                       end
                     3'd5: // Dwords 6, 7 can't be filled in this cycle, do a second read
                       begin
                          read_dw_sel0 <= 4'd8; // Not used
                          read_dw_sel1 <= 4'd8; // Not used
                          read_dw_sel2 <= 4'd8; // Not used
                          read_dw_sel3 <= 4'd8; // Not used
                          read_dw_sel4 <= 4'd8; // Not used
                          read_dw_sel5 <= 4'd8; // Not used
                          read_dw_sel6 <= 4'd0;
                          read_dw_sel7 <= 4'd1;
                       end
                     3'd4: // Dword 7 can't be filled in this cycle, do a second read
                       begin
                          read_dw_sel0 <= 4'd8; // Not used
                          read_dw_sel1 <= 4'd8; // Not used
                          read_dw_sel2 <= 4'd8; // Not used
                          read_dw_sel3 <= 4'd8; // Not used
                          read_dw_sel4 <= 4'd8; // Not used
                          read_dw_sel5 <= 4'd8; // Not used
                          read_dw_sel6 <= 4'd8; // Not used
                          read_dw_sel7 <= 4'd0;
                       end
                     3'd3: // The word is filled perfectly, start a new word next cycle
                       begin
                          read_dw_sel0 <= 4'd0;
                          read_dw_sel1 <= 4'd1;
                          read_dw_sel2 <= 4'd2;
                          read_dw_sel3 <= 4'd3;
                          read_dw_sel4 <= 4'd4;
                          read_dw_sel5 <= 4'd5;
                          read_dw_sel6 <= 4'd6;
                          read_dw_sel7 <= 4'd7;
                       end // case: 3'd4
                     3'd2: // One word to save for next cycle
                       begin
                          read_dw_sel0 <= 4'd8;  // send saved data
                          read_dw_sel1 <= 4'd0;
                          read_dw_sel2 <= 4'd1;
                          read_dw_sel3 <= 4'd2;
                          read_dw_sel4 <= 4'd3;
                          read_dw_sel5 <= 4'd4;
                          read_dw_sel6 <= 4'd5;
                          read_dw_sel7 <= 4'd6;
                       end // case: 3'd3
                     3'd1: // 2 words to save for next cycle
                       begin
                          read_dw_sel0 <= 4'd8;  // send saved data
                          read_dw_sel1 <= 4'd8;  // send saved data
                          read_dw_sel2 <= 4'd0;
                          read_dw_sel3 <= 4'd1;
                          read_dw_sel4 <= 4'd2;
                          read_dw_sel5 <= 4'd3;
                          read_dw_sel6 <= 4'd4;
                          read_dw_sel7 <= 4'd5;
                       end // case: 3'd2
                     default: // 3 words to save for next cycle
                       begin
                          read_dw_sel0 <= 4'd8;  // send saved data
                          read_dw_sel1 <= 4'd8;  // send saved data
                          read_dw_sel2 <= 4'd8;  // send saved data
                          read_dw_sel3 <= 4'd0;
                          read_dw_sel4 <= 4'd1;
                          read_dw_sel5 <= 4'd2;
                          read_dw_sel6 <= 4'd3;
                          read_dw_sel7 <= 4'd4;
                       end // case: 3'd1
                   endcase // case (mem_addr_reg[4:2])
                end // else: !if(~mem_addr_reg[2])
              
              // Determine offset of data to be saved for next cycle
              case(mem_addr_reg[4:2])
                3'd0: 
                  saved_dw_offset <= 3'd4; // Save Dwords 4 - 7
                default:
                  saved_dw_offset <= 3'd6; // Save Dwords 6 - 7
              endcase // case (mem_addr_reg[4:2])

              // Increment RAM read address
              ram_address <= ram_address + 13'd1;

           end // case: target_app_state[SEND_COMPL_HDR]
         
         target_app_state[SEND_COMPL_HDR_2]:
           // Complete a partially filled first word of the Completion
           begin
              if (~read_dw_sel4[3])
                tx_st_data_o[159:128] <= ram_rd_data_reg[31:0];

              if (~read_dw_sel5[3])
                case(read_dw_sel5[3:0])
                  4'd0: tx_st_data_o[191:160] <= ram_rd_data_reg[31:0];
                  4'd1: tx_st_data_o[191:160] <= ram_rd_data_reg[63:32];
                  default:
                    begin
                    end
                endcase // case (read_dw_sel5)
              
              if (~read_dw_sel6[3])
                case(read_dw_sel6[3:0])
                  4'd0: tx_st_data_o[223:192] <= ram_rd_data_reg[31:0];
                  4'd1: tx_st_data_o[223:192] <= ram_rd_data_reg[63:32];
                  4'd2: tx_st_data_o[223:192] <= ram_rd_data_reg[95:64];
                  default:
                    begin
                    end
                endcase // case (read_dw_sel6)

              if (~read_dw_sel7[3])
                case(read_dw_sel7[3:0])
                  4'd0: tx_st_data_o[255:224] <= ram_rd_data_reg[31:0];
                  4'd1: tx_st_data_o[255:224] <= ram_rd_data_reg[63:32];
                  4'd2: tx_st_data_o[255:224] <= ram_rd_data_reg[95:64];
                  4'd3: tx_st_data_o[255:224] <= ram_rd_data_reg[127:96];
                  default:
                    begin
                    end
                endcase // case (read_dw_sel7)
              
              // Save the remaining data from the read for next cycle
              case(mem_addr_reg[4:2])
                3'd7: 
                  begin
                     saved_read_data[127:0] <= ram_rd_data_reg[255:128];
                     saved_dw_offset <= 3'd4;
                  end
                default: 
                  begin
                     saved_read_data[191:0] <= ram_rd_data_reg[255:64];
                     saved_dw_offset <= 3'd2;
                  end
              endcase // case (mem_addr_reg[4:2])

              // Set valid
              tx_st_valid_o[0] <= 1'b1;

              // Update Dwords remaining to send
              dwords_to_read <= dwords_to_read - dwords_sent_this_cycle;
              dwords_sent_this_cycle <= 7'd8;

              // Set data selects for next cycle
              case(mem_addr_reg[4:2])
                3'd7: // 4 Dwords filled
                       begin
                          read_dw_sel0 <= 4'd8; // Not used
                          read_dw_sel1 <= 4'd8; // Not used
                          read_dw_sel2 <= 4'd8; // Not used
                          read_dw_sel3 <= 4'd8; // Not used
                          read_dw_sel4 <= 4'd0;
                          read_dw_sel5 <= 4'd1;
                          read_dw_sel6 <= 4'd2;
                          read_dw_sel7 <= 4'd3;
                       end
                default: // 2 Dwords filled
                       begin
                          read_dw_sel0 <= 4'd8; // Not used
                          read_dw_sel1 <= 4'd8; // Not used
                          read_dw_sel2 <= 4'd8; // Not used
                          read_dw_sel3 <= 4'd8; // Not used
                          read_dw_sel4 <= 4'd8; // Not used
                          read_dw_sel5 <= 4'd8; // Not used
                          read_dw_sel6 <= 4'd0;
                          read_dw_sel7 <= 4'd1;
                       end
              endcase // case (mem_addr_reg[4:2])
              tx_st_sop_o[0] <= 1'b1;
              tx_st_err_o[0] <= 1'b0;

              // Determine EOP
              // Set Empty output
              case(mem_addr_reg[4:2])
                3'd7: tx_st_eop_o[0] <= (dwords_to_read <= 7'd4);
                default: tx_st_eop_o[0] <= (dwords_to_read <= 7'd2);
              endcase

              // Set Empty output
              if (mem_addr_reg[4:2] == 3'd7)
                begin
                   // We have filled Dwords 0-3 in last cycle.
                   // If we have 2 or fewer Dwords to add in this cycle, set Empty to 1, otherwise to 0.
                   if (dwords_to_read <= 7'd2)
                     tx_st_empty_o <= 2'd1;
                   else
                     tx_st_empty_o <= 2'd0;
                end
              else
                // We have filled Dwords 0-5 in last cycle, and will add at least one more this cycle,
                // so set Empty to 0.
                tx_st_empty_o <= 2'd0;

              // Increment RAM read address
              ram_address <= ram_address + 13'd1;
           end // case: target_app_state[SEND_COMPL_HDR_2]


         target_app_state[SEND_READ_PAYLOAD]:
           // Completion payload cycles
           begin
              if (read_dw_sel0[3]) // send saved data
                tx_st_data_o[31:0] <= saved_read_data[31:0];
              else
                case(read_dw_sel0[2:0])
                  3'd0: tx_st_data_o[31:0] <= ram_rd_data_reg[31:0];
                  3'd1: tx_st_data_o[31:0] <= ram_rd_data_reg[63:32];
                  3'd2: tx_st_data_o[31:0] <= ram_rd_data_reg[95:64];
                  3'd3: tx_st_data_o[31:0] <= ram_rd_data_reg[127:96];
                  3'd4: tx_st_data_o[31:0] <= ram_rd_data_reg[159:128];
                  3'd5: tx_st_data_o[31:0] <= ram_rd_data_reg[191:160];
                  3'd6: tx_st_data_o[31:0] <= ram_rd_data_reg[223:192];
                  default: tx_st_data_o[31:0] <= ram_rd_data_reg[255:224];
                endcase // case (read_dw_sel0[2:0])
              
              if (read_dw_sel1[3]) // send saved data
                tx_st_data_o[63:32] <= saved_read_data[63:32];
              else
                case(read_dw_sel1[2:0])
                  3'd0: tx_st_data_o[63:32] <= ram_rd_data_reg[31:0];
                  3'd1: tx_st_data_o[63:32] <= ram_rd_data_reg[63:32];
                  3'd2: tx_st_data_o[63:32] <= ram_rd_data_reg[95:64];
                  3'd3: tx_st_data_o[63:32] <= ram_rd_data_reg[127:96];
                  3'd4: tx_st_data_o[63:32] <= ram_rd_data_reg[159:128];
                  3'd5: tx_st_data_o[63:32] <= ram_rd_data_reg[191:160];
                  3'd6: tx_st_data_o[63:32] <= ram_rd_data_reg[223:192];
                  default: tx_st_data_o[63:32] <= ram_rd_data_reg[255:224];
                endcase // case (read_dw_sel1[2:0])

              if (read_dw_sel2[3]) // send saved data
                tx_st_data_o[95:64] <= saved_read_data[95:64];
              else
                case(read_dw_sel2[2:0])
                  3'd0: tx_st_data_o[95:64] <= ram_rd_data_reg[31:0];
                  3'd1: tx_st_data_o[95:64] <= ram_rd_data_reg[63:32];
                  3'd2: tx_st_data_o[95:64] <= ram_rd_data_reg[95:64];
                  3'd3: tx_st_data_o[95:64] <= ram_rd_data_reg[127:96];
                  3'd4: tx_st_data_o[95:64] <= ram_rd_data_reg[159:128];
                  3'd5: tx_st_data_o[95:64] <= ram_rd_data_reg[191:160];
                  3'd6: tx_st_data_o[95:64] <= ram_rd_data_reg[223:192];
                  default: tx_st_data_o[95:64] <= ram_rd_data_reg[255:224];
                endcase // case (read_dw_sel2[2:0])

              if (read_dw_sel3[3]) // send saved data
                tx_st_data_o[127:96] <= saved_read_data[127:96];
              else
                case(read_dw_sel3[2:0])
                  3'd0: tx_st_data_o[127:96] <= ram_rd_data_reg[31:0];
                  3'd1: tx_st_data_o[127:96] <= ram_rd_data_reg[63:32];
                  3'd2: tx_st_data_o[127:96] <= ram_rd_data_reg[95:64];
                  3'd3: tx_st_data_o[127:96] <= ram_rd_data_reg[127:96];
                  3'd4: tx_st_data_o[127:96] <= ram_rd_data_reg[159:128];
                  3'd5: tx_st_data_o[127:96] <= ram_rd_data_reg[191:160];
                  3'd6: tx_st_data_o[127:96] <= ram_rd_data_reg[223:192];
                  default: tx_st_data_o[127:96] <= ram_rd_data_reg[255:224];
                endcase // case (read_dw_sel3[2:0])

              if (read_dw_sel4[3]) // send saved data
                tx_st_data_o[159:128] <= saved_read_data[159:128];
              else
                case(read_dw_sel4[2:0])
                  3'd0: tx_st_data_o[159:128] <= ram_rd_data_reg[31:0];
                  3'd1: tx_st_data_o[159:128] <= ram_rd_data_reg[63:32];
                  3'd2: tx_st_data_o[159:128] <= ram_rd_data_reg[95:64];
                  3'd3: tx_st_data_o[159:128] <= ram_rd_data_reg[127:96];
                  3'd4: tx_st_data_o[159:128] <= ram_rd_data_reg[159:128];
                  3'd5: tx_st_data_o[159:128] <= ram_rd_data_reg[191:160];
                  3'd6: tx_st_data_o[159:128] <= ram_rd_data_reg[223:192];
                  default: tx_st_data_o[159:128] <= ram_rd_data_reg[255:224];
                endcase // case (read_dw_sel4[2:0])

              if (read_dw_sel5[3]) // send saved data
                tx_st_data_o[191:160] <= saved_read_data[191:160];
              else
                case(read_dw_sel5[2:0])
                  3'd0: tx_st_data_o[191:160] <= ram_rd_data_reg[31:0];
                  3'd1: tx_st_data_o[191:160] <= ram_rd_data_reg[63:32];
                  3'd2: tx_st_data_o[191:160] <= ram_rd_data_reg[95:64];
                  3'd3: tx_st_data_o[191:160] <= ram_rd_data_reg[127:96];
                  3'd4: tx_st_data_o[191:160] <= ram_rd_data_reg[159:128];
                  3'd5: tx_st_data_o[191:160] <= ram_rd_data_reg[191:160];
                  3'd6: tx_st_data_o[191:160] <= ram_rd_data_reg[223:192];
                  default: tx_st_data_o[191:160] <= ram_rd_data_reg[255:224];
                endcase // case (read_dw_sel5[2:0])

                case(read_dw_sel6[2:0])
                  3'd0: tx_st_data_o[223:192] <= ram_rd_data_reg[31:0];
                  3'd1: tx_st_data_o[223:192] <= ram_rd_data_reg[63:32];
                  3'd2: tx_st_data_o[223:192] <= ram_rd_data_reg[95:64];
                  3'd3: tx_st_data_o[223:192] <= ram_rd_data_reg[127:96];
                  3'd4: tx_st_data_o[223:192] <= ram_rd_data_reg[159:128];
                  3'd5: tx_st_data_o[223:192] <= ram_rd_data_reg[191:160];
                  3'd6: tx_st_data_o[223:192] <= ram_rd_data_reg[223:192];
                  default: tx_st_data_o[223:192] <= ram_rd_data_reg[255:224];
                endcase // case (read_dw_sel6[2:0])

              case(read_dw_sel7[2:0])
                  3'd0: tx_st_data_o[255:224] <= ram_rd_data_reg[31:0];
                  3'd1: tx_st_data_o[255:224] <= ram_rd_data_reg[63:32];
                  3'd2: tx_st_data_o[255:224] <= ram_rd_data_reg[95:64];
                  3'd3: tx_st_data_o[255:224] <= ram_rd_data_reg[127:96];
                  3'd4: tx_st_data_o[255:224] <= ram_rd_data_reg[159:128];
                  3'd5: tx_st_data_o[255:224] <= ram_rd_data_reg[191:160];
                  3'd6: tx_st_data_o[255:224] <= ram_rd_data_reg[223:192];
                  default: tx_st_data_o[255:224] <= ram_rd_data_reg[255:224];
              endcase // case (read_dw_sel7[2:0])
              
              case(saved_dw_offset)
                3'd2: saved_read_data[191:0] <= ram_rd_data_reg[255:64];
                3'd4: saved_read_data[127:0] <= ram_rd_data_reg[255:128];
                // 3'd6:
                default: saved_read_data[63:0] <= ram_rd_data_reg[255:192];
              endcase

              // Set valid
              tx_st_valid_o[0] <= 1'b1;

              // Update Dwords remaining to send
              dwords_to_read <= dwords_to_read - dwords_sent_this_cycle;

              tx_st_sop_o <= {multiple_packets_per_cycle_hwtcl+1{1'b0}};
              tx_st_err_o[0] <= 1'b0;

              // Determine EOP
              tx_st_eop_o[0] <= (dwords_to_read <= 7'd8);

              // Set Empty output
              if (dwords_to_read <= 7'd2)
                tx_st_empty_o <= 2'd3;
              else if (dwords_to_read <= 7'd4)
                tx_st_empty_o <= 2'd2;
              else if (dwords_to_read <= 7'd6)
                tx_st_empty_o <= 2'd1;
              else
                tx_st_empty_o <= 2'd0;

              // Increment RAM read address
              ram_address <= ram_address + 13'd1;
           end // case: target_app_state[SEND_READ_PAYLOAD]


         default:
           begin
              ram_wren <= 1'b0;
           end
       endcase // case (1'b1)

   // Determine next state

   always @(*)
   begin
      next_state = 10'd0;
      case(1'b1) // synthesis parallel_case
        target_app_state[IDLE]:
          begin
             if (rx_st_valid_i[0] & rx_st_sop_i[0] & ~rx_st_err_i[0] & mem_wr_tlp & ~mem_cycle_count_1)
               begin
                  // If we have more data to write into the first word of the RAM,
                  // use an extra cycle to write into the same location.
                  if (qw_aligned_addr)
                    // Payload starts in Dword 4
                    begin
                       if (mem_addr[4:2] <= 3'd3) // At least 5 Dwords to write in this RAM location
                         next_state[WRITE_PAYLOAD_FIRST_CYCLE] = 1'b1;
                       else if (rx_st_eop_i[0])
                         // All the Dwords to write have already been rcvd
                         next_state[WRITE_SPILL_WORD] = 1'b1;
                       else
                         next_state[WRITE_PAYLOAD] = 1'b1;
                    end // if (qw_aligned_addr)
                  else if (~addr_64)
                    // Payload starts in Dword 3
                    begin
                       if (mem_addr[4:2] <= 3'd2) // At least 6 Dwords in this cycle
                         next_state[WRITE_PAYLOAD_FIRST_CYCLE] = 1'b1;
                       else if (rx_st_eop_i[0])
                         // All the Dwords to write have already been rcvd
                         next_state[WRITE_SPILL_WORD] = 1'b1;
                       else
                         next_state[WRITE_PAYLOAD] = 1'b1;
                    end
                  else
                    // Payload starts in Dword 5
                    begin
                       if (mem_addr[4:2] <= 3'd4) // At least 4 Dwords in this cycle
                         next_state[WRITE_PAYLOAD_FIRST_CYCLE] = 1'b1;
                       else if (rx_st_eop_i[0])
                         // All the Dwords to write have already been rcvd
                         next_state[WRITE_SPILL_WORD] = 1'b1;
                       else
                         next_state[WRITE_PAYLOAD] = 1'b1;
                    end
               end // if (rx_st_valid_i[0] & rx_st_sop_i[0] & ~rx_st_err_i[0] & mem_wr_tlp & ~mem_cycle_count_1)
             else if (rx_st_valid_i[0] & rx_st_sop_i[0] & ~rx_st_err_i[0] & mem_rd_tlp)
               next_state[START_READ] = 1'b1;
             else
               next_state[IDLE] = 1'b1;
          end

        target_app_state[WRITE_PAYLOAD_FIRST_CYCLE]:
          begin
             if (rx_st_valid_i[0])
               begin
                  case(write_dw_offset)
                    3'd3: 
                      begin
                         if (dwords_to_write <= 7'd5)
                           next_state[IDLE] = 1'b1;
                         else if (rx_st_eop_i[0])
                           next_state[WRITE_SPILL_WORD] = 1'b1;
                         else
                           next_state[WRITE_PAYLOAD] = 1'b1;
                      end
                    3'd4: 
                      begin
                         if (dwords_to_write <= 7'd4)
                           next_state[IDLE] = 1'b1;
                         else if (rx_st_eop_i[0])
                           next_state[WRITE_SPILL_WORD] = 1'b1;
                         else
                           next_state[WRITE_PAYLOAD] = 1'b1;
                      end
                    3'd5: 
                      begin
                         if (dwords_to_write <= 7'd3)
                           next_state[IDLE] = 1'b1;
                         else if (rx_st_eop_i[0])
                           next_state[WRITE_SPILL_WORD] = 1'b1;
                         else
                           next_state[WRITE_PAYLOAD] = 1'b1;
                      end
                    3'd6: 
                      begin
                         if (dwords_to_write <= 7'd2)
                           next_state[IDLE] = 1'b1;
                         else if (rx_st_eop_i[0])
                           next_state[WRITE_SPILL_WORD] = 1'b1;
                         else
                           next_state[WRITE_PAYLOAD] = 1'b1;
                      end
                    default:
                      begin
                         if (dwords_to_write == 7'd1)
                           next_state[IDLE] = 1'b1;
                         else if (rx_st_eop_i[0])
                           next_state[WRITE_SPILL_WORD] = 1'b1;
                         else
                           next_state[WRITE_PAYLOAD] = 1'b1;
                      end
                  endcase // case (write_dw_offset)
               end // if (rx_st_valid_i[0])
             else
               next_state[WRITE_PAYLOAD_FIRST_CYCLE] = 1'b1;
          end

        target_app_state[WRITE_PAYLOAD]:
          begin
             if (rx_st_valid_i[0])
               begin
                  if (~rx_st_eop_i)
                    next_state[WRITE_PAYLOAD] = 1'b1;
                  else
                    begin
                       if (dwords_to_write <= 7'd8)
                         next_state[IDLE] = 1'b1;
                       else
                         next_state[WRITE_SPILL_WORD] = 1'b1;
                    end
               end // if (rx_st_valid_i[0])
             else
               next_state[WRITE_PAYLOAD] = 1'b1;
          end
        
        target_app_state[WRITE_SPILL_WORD]:
          begin
             next_state[IDLE] = 1'b1;
          end

         target_app_state[START_READ]:
           begin
              // stay in this state if ready from downstream FIFO de-asserts
              if (~tx_st_ready_reg)
                next_state[START_READ] = 1'b1;
              else
                next_state[MEM_READ_WAIT_FOR_DATA_1] = 1'b1;
           end
         
         target_app_state[MEM_READ_WAIT_FOR_DATA_1]:
           begin
              next_state[MEM_READ_WAIT_FOR_DATA_2] = 1'b1;
           end
         
         target_app_state[MEM_READ_WAIT_FOR_DATA_2]:
           begin
              next_state[SEND_COMPL_HDR] = 1'b1;
           end

         target_app_state[SEND_COMPL_HDR]:
           begin
              // Check if the payload is complete. Move to IDLE if the entire payload fits in the first word.
              if ((dwords_to_read == 7'd1) ||
                  ((dwords_to_read == 7'd2) && (mem_addr_reg[4:2] != 3'd7)) ||
                  ((dwords_to_read == 7'd3) && (mem_addr_reg[4:2] <= 3'd5)) ||
                  ((dwords_to_read == 7'd4) && (mem_addr_reg[4:2] <= 3'd4)) ||
                  (mem_addr_reg[2] &&
                   (dwords_to_read == 7'd5) && (mem_addr_reg[4:2] <= 3'd3)))
                next_state[IDLE] = 1'b1;
              // Check if we need a second read to fill the word
              else if (((dwords_to_read == 7'd2) && (mem_addr_reg[4:2] == 3'd7)) ||
                       ((dwords_to_read == 7'd3) && (mem_addr_reg[4:2] >= 3'd6)) ||
                       ((dwords_to_read >= 7'd4) && (mem_addr_reg[4:2] >= 3'd5)) ||
                       (mem_addr_reg[2] &&
                        (dwords_to_read >= 7'd5) && (mem_addr_reg[4:2] >= 3'd4)))
                next_state[SEND_COMPL_HDR_2] = 1'b1;
              else
                next_state[SEND_READ_PAYLOAD] = 1'b1;
           end // case: target_app_state[SEND_COMPL_HDR]
        
         target_app_state[SEND_COMPL_HDR_2]:
           begin
              if (dwords_to_read <= dwords_sent_this_cycle)
                next_state[IDLE] = 1'b1;
              else
                next_state[SEND_READ_PAYLOAD] = 1'b1;
           end

        target_app_state[SEND_READ_PAYLOAD]:
          begin
             if (dwords_to_read <= 7'd8)
               next_state[IDLE] = 1'b1;
             else
               next_state[SEND_READ_PAYLOAD] = 1'b1;
          end
        
        default:
          next_state[IDLE] = 1'b1;
      endcase // case (1'b1)
   end
      
   always @(posedge clk_i)
     if (~rstn_i) 
       target_app_state <= 10'd1;
     else
       target_app_state <= next_state;
   
   // Generate upstream ready
   assign     rx_st_ready_o = target_app_state[IDLE] | target_app_state[WRITE_PAYLOAD] |
                               target_app_state[WRITE_PAYLOAD_FIRST_CYCLE];
 
   // Provide transaction pending status for memory reads
   always @(posedge clk_i)
     if (~rstn_i) 
       begin
          cpl_pending_pf_o <= 1'b0;
          cpl_pending_vf_o <= {TOTAL_VF_COUNT{1'b0}};
       end
     else
       case(1'b1)
         target_app_state[IDLE]:
           begin
              cpl_pending_pf_o <= 1'b0;
              cpl_pending_vf_o <= {TOTAL_VF_COUNT{1'b0}};
           end
         target_app_state[START_READ]:
           begin
              for (i=0; i<TOTAL_PF_COUNT; i=i+1)
                cpl_pending_pf_o <= (req_function[7:1] == 7'h0) && (req_function[0] == i);

              for (i=0; i<TOTAL_VF_COUNT; i=i+1)
                cpl_pending_vf_o <= (req_function[7] == 1'b1) && (req_function[6:0] == i);
           end
       default:
         begin
         end
       endcase // case (1'b1)

   // Register ready from HIP
   always @(posedge clk_i)
     if (~rstn_i) 
       tx_st_ready_reg <= 1'b0;
     else
       tx_st_ready_reg <= tx_st_ready_i;

endmodule // altera_pcie_sriov_target_mem











                   

   
   
