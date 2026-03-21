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


//////////////////////////////////////////////////////////////////////////////
// This package contains common typedefs and function definitions for the
// example driver.
//////////////////////////////////////////////////////////////////////////////

package avl_tg_defs;

   // Address generators definition
   typedef enum int unsigned {
      SEQ,
      RAND,
      RAND_SEQ,
      TEMPLATE_ADDR_GEN
   } addr_gen_select_t;


   // Returns the maximum of two numbers
   function automatic integer max;
      input integer a;
      input integer b;
      begin
         max = (a > b) ? a : b;
      end
   endfunction


   // Calculate the log_2 of the input value
   function automatic integer log2;
      input integer value;
      begin
         value = value >> 1;
         for (log2 = 0; value > 0; log2 = log2 + 1)
            value = value >> 1;
      end
   endfunction


   // Calculate the ceiling of log_2 of the input value
   function automatic integer ceil_log2;
      input integer value;
      begin
         value = value - 1;
         for (ceil_log2 = 0; value > 0; ceil_log2 = ceil_log2 + 1)
            value = value >> 1;
      end
   endfunction

   parameter TG_PATTERN_PRBS = 2'b00;
   parameter TG_PATTERN_FIXED = 2'b01;
   parameter TG_PATTERN_PRBS_INVERTED = 2'b10;
   parameter TG_PATTERN_FIXED_INVERTED = 2'b11;

   parameter TG_ADDR_RAND = 0;
   parameter TG_ADDR_SEQ = 1;
   parameter TG_ADDR_RAND_SEQ = 2;
   parameter TG_ADDR_ONE_HOT = 3;

   parameter TG_MASK_DISABLED = 2'b00;
   parameter TG_MASK_FIXED = 2'b01;
   parameter TG_MASK_FULL_CYCLING = 2'b10;
   parameter TG_MASK_PARTIAL_CYCLING = 2'b11;

   // Start
   parameter TG_START = 10'h0;
   // Loop count
   parameter TG_LOOP_COUNT = 10'h1;
   // Write count
   parameter TG_WRITE_COUNT = 10'h2;
   // Read count
   parameter TG_READ_COUNT = 10'h3;
   // Write repeat count
   parameter TG_WRITE_REPEAT_COUNT = 10'h4;
   // Read repeat count
   parameter TG_READ_REPEAT_COUNT = 10'h5;
   // Burst length
   parameter TG_BURST_LENGTH = 10'h6;
   // Clear first fail
   parameter TG_CLEAR_FIRST_FAIL = 10'h7;
   // Test byte enable
   parameter TG_TEST_BYTEEN = 10'h8;
   // Restart default traffic
   parameter TG_RESTART_DEFAULT_TRAFFIC = 10'h9;
   // Data generator mode
   parameter TG_DATA_MODE = 10'hA;
   // Byte enable generator mode
   parameter TG_BYTEEN_MODE = 10'hB;
   // Traffic Generator stops immediately after completing current transactions
   parameter TG_ACTIVATE_EMERGENCY_BRAKE = 10'hC;
   // Sequential start address (Write) (Lower 32 bits)
   parameter TG_SEQ_START_ADDR_WR_L = 10'h30;
   // Sequential start address (Write) (Upper 32 bits)
   parameter TG_SEQ_START_ADDR_WR_H = 10'h31;
   // Address mode
   parameter TG_ADDR_MODE_WR = 10'h32;
   // Random sequential number of addresses (Write)
   parameter TG_RAND_SEQ_ADDRS_WR = 10'h33;
   // Return to start address
   parameter TG_RETURN_TO_START_ADDR = 10'h34;
   // Rank mask enable
   parameter TG_RANK_MASK_EN = 10'h35;
   // Bank mask enable
   parameter TG_BANK_MASK_EN = 10'h36;
   // Row mask enable
   parameter TG_ROW_MASK_EN = 10'h37;
   // Bank group mask enable
   parameter TG_BG_MASK_EN = 10'h38;
   // Rank mask
   parameter TG_RANK_MASK = 10'h39;
   // Bank mask
   parameter TG_BANK_MASK = 10'h3A;
   // Row mask
   parameter TG_ROW_MASK = 10'h3B;
   // Bank group mask
   parameter TG_BG_MASK = 10'h3C;
   // Sequential address increment
   parameter TG_SEQ_ADDR_INCR = 10'h3D;
   // Sequential start address (Read) (Lower 32 bits)
   parameter TG_SEQ_START_ADDR_RD_L = 10'h3E;
   // Sequential start address (Read) (Upper 32 bits)
   parameter TG_SEQ_START_ADDR_RD_H = 10'h3F;
   // Address mode (Read)
   parameter TG_ADDR_MODE_RD = 10'h40;
   // Random sequential number of addresses (Read)
   parameter TG_RAND_SEQ_ADDRS_RD = 10'h41;
   // Pass
   parameter TG_PASS = 10'h70;
   // Fail
   parameter TG_FAIL = 10'h71;
   // Failure count (lower 32 bits)
   parameter TG_FAIL_COUNT_L = 10'h72;
   // Failure count (upper 32 bits)
   parameter TG_FAIL_COUNT_H = 10'h73;
   // First failure address (lower 32 bits)
   parameter TG_FIRST_FAIL_ADDR_L = 10'h74;
   // First failure address (upper 32 bits)
   parameter TG_FIRST_FAIL_ADDR_H = 10'h75;
   // Total read count (lower 32 bits)
   parameter TG_TOTAL_READ_COUNT_L = 10'h76;
   // Total read count (upper 32 bits)
   parameter TG_TOTAL_READ_COUNT_H = 10'h77;
   // Test complete status register
   parameter TG_TEST_COMPLETE = 10'h78;
   // Traffic generator version
   parameter TG_VERSION = 10'h80;
   // Number of data generators
   parameter TG_NUM_DATA_GEN = 10'h81;
   // Number of byte enable generators
   parameter TG_NUM_BYTEEN_GEN = 10'h82;
   // Rank address width
   parameter TG_RANK_ADDR_WIDTH = 10'h83;
   // Bank address width
   parameter TG_BANK_ADDR_WIDTH = 10'h84;
   // Row address width
   parameter TG_ROW_ADDR_WIDTH = 10'h85;
   // Bank group width
   parameter TG_BANK_GROUP_WIDTH = 10'h86;
   // Width of read data and PNF signals
   parameter TG_RDATA_WIDTH = 10'h87;
   // Length of data pattern
   parameter TG_DATA_PATTERN_LENGTH = 10'h88;
   // Length of byte enable pattern
   parameter TG_BYTEEN_PATTERN_LENGTH = 10'h89;
   // Minimum address incremement (address divisibility requirement)
   parameter TG_MIN_ADDR_INCR = 10'h8A;
   // Error reporting register for illegal configurations of the traffic generator
   parameter TG_ERROR_REPORT = 10'h8B;
   // Persistent PNF per bit (144*8 / 32 addresses needed)
   parameter TG_PNF = 10'h90;
   // First failure expected data
   parameter TG_FAIL_EXPECTED_DATA = 10'hB5;
   // First failure read data
   parameter TG_FAIL_READ_DATA = 10'hDA;
   // Data generator seed
   parameter TG_DATA_SEED = 10'h100;
   // Byte enable generator seed
   parameter TG_BYTEEN_SEED = 10'h1A0;
   // More read operations will be scheduled than write operations. Data mismatches may occur.
   parameter ERR_MORE_READS_THAN_WRITES = 32'h0;
   // The Avalon burst length exceeds the sequential address increment.  Data mismatches may occur.
   parameter ERR_BURSTLENGTH_GT_SEQ_ADDR_INCR = 32'h1;
   // The sequential address increment is smaller than the minimum required.  Data mismatches may occur.
   parameter ERR_ADDR_DIVISIBLE_BY_GT_SEQ_ADDR_INCR = 32'h2;
   // The sequential address increment is not divisible by the necessary step.  Data mismatches may occur.
   parameter ERR_SEQ_ADDR_INCR_NOT_DIVISIBLE = 32'h3;
   // The read and write start address during sequential address generation are different.  Data mismatches may occur.
   parameter ERR_READ_AND_WRITE_START_ADDRS_DIFFER = 32'h4;
   // Read and write settings for address generation mode are different.  Data mismatches may occur.
   parameter ERR_ADDR_MODES_DIFFERENT = 32'h5;
   // Read and write settings for number of random sequential address operations are unequal.  Data mismatches may occur.
   parameter ERR_NUMBER_OF_RAND_SEQ_ADDRS_DIFFERENT = 32'h6;
   // The number of read or write repeats is set to 0.
   parameter ERR_REPEATS_SET_TO_ZERO = 32'h7;
   // Avalon burst length is greater than 1 when read/write repeats is greater than 1.
   parameter ERR_BOTH_BURST_AND_REPEAT_MODE_ACTIVE = 32'h8;

endpackage

