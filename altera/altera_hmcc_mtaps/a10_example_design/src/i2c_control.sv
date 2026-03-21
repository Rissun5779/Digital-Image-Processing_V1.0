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


`timescale 1ps/1ps

module i2c_control 
#(
  parameter DEVICE_FAMILY      = "Arria 10", 
  parameter SIMULATION_SPEEDUP = 0,
  parameter CHANNELS           = 16,
  parameter DATA_RATE          = "10000 Mbps"
) (
    input           clk,
    input           rst_n,
    output  reg     clock_gen_set,
    input           load_registers,
    output  reg     registers_loaded,
    inout           i2c_scl,
    inout           i2c_sda
);

  localparam    SET_CLK_DIV     = 4'h0,
                IDLE            = 4'h1,
                WR_DEVID        = 4'h2,
                WR_ADDR         = 4'h3,
                WR_DATA         = 4'h4,
                WR_CMD          = 4'h5,
                WAIT_START      = 4'h6,
                MID_TR_WAIT     = 4'h7,
                PREP_NEXT       = 4'h8,
                FETCH_READ_DATA = 4'h9,
                SAVE_READ_DATA  = 4'hA,
                WAIT_ERI        = 4'hB,
                WAIT_20_MS      = 4'hC,
                DONE            = 4'hD;

  localparam    MAX_TR_CNT      = 35;

  localparam    I2C32_CSR_ADDR        = 8'h00,
                I2C32_SLV_ADDR_ADDR   = 8'h01,
                I2C32_CLK_DIV_ADDR    = 8'h02,
                I2C32_SUB_ADDR_ADDR   = 8'h03,
                I2C32_XMIT_DATA       = 8'h04,
                I2C32_READ_DATA_ADDR  = 8'h05;


  // The 7-bit device addresses are padded with one zero LSb into 8-bit addresses 
  // and then padded to a 32-bit value for the I2C controller.
  // The LSb is overwritten by the R/W flag bit by the I2C controller.

  // PCA 9544 : 7'h70 << 1 = 8'hE0
  localparam    DEVICE_MUX  = 32'hE0;
  // SX1508 : 7'h20 << 1 = 8'h40
  localparam    DEVICE_GPIO = 32'h40;
  // HMC : { 4'b0010,CUB[2:0] } = 7'h10 << 1 = 8'h20
  localparam    DEVICE_HMC  = 32'h20;
  // IDT8T49N006I : 7'h6F << 1 = 8'hDE
  localparam    DEVICE_CLK1 = 32'hDE;
  // IDT8T49N004I : 7'h6E << 1 = 8'hDC
  localparam    DEVICE_CLK2 = 32'hDC;

  // SUBA_SIZE = 1, XFR_SIZE = 1, STOP, START, GO
  // Used for clock generators.
  localparam  WRITE_8  = 32'h1017;

  // SUBA_SIZE = 4, XFR_SIZE = 4, STOP, START, GO
  // Used for HMC.
  localparam  WRITE_32 = 32'h4047;

  // Used for HMC.
  // SUBA_SIZE = 4, XFR_SIZE = 0, START, GO 
  localparam  READ_32_S1 = 32'h4003;

  // SUBA_SIZE = 4, XFR_SIZE = 4, READ, STOP, START, GO
  localparam  READ_32_S2 = 32'h404F;


  generate
    if ( SIMULATION_SPEEDUP ) begin
      always_ff @( posedge clk or negedge rst_n ) begin
        if( !rst_n ) begin
          registers_loaded <= 1'b0;
          clock_gen_set <= 1'b0;
        end else begin
          registers_loaded <= load_registers;
          clock_gen_set <= 1'b1;
        end
      end
    end else begin
      reg [3:0]     init_state;
      reg [5:0]     i2c_tr_count;
      reg [3:0]     load_registers_sync;

      wire [34:0][31:0] i2c_cmd_array;  // I2C command
      wire [34:0][31:0] i2c_dev_array;  // Slave Device Address
      wire [34:0][31:0] i2c_addr_array; // Sub address
      wire [34:0][31:0] i2c_data_array; // Data

      reg  [ 7:0]   mm_address_init;
      reg           mm_write_init;
      reg           mm_read_init;
      reg  [31:0]   mm_writedata_init;
      wire [31:0]   mm_readdata;
      reg  [20:0]   wait_cnt;
      reg  [15:0]   firmware_vs;
      reg  [21:0]   eridata0_addr;
      reg  [21:0]   erireq_addr;

      wire  busy;
      wire  nack;

      /************************************************************************
      * Configure devices which are specific to Altera's Arria 10 PCIe        *
      * development kit + HMC daughter card.                                  *
      *                                                                       *
      ************************************************************************/

      // Configure PCA9544 I2C mux to select I2C bus 0 (LOCAL_SCL/SDA)
      // The device has a single register without a register address.
      // Setting the register address and transferring no data is sufficient.
      assign i2c_cmd_array [ 0] = 32'h1007;  // SUBA_SIZE = 1, XFR_SIZE = 0, STOP, START, GO.
      assign i2c_dev_array [ 0] = DEVICE_MUX;
      assign i2c_addr_array[ 0] = 32'h0000_0004;
      assign i2c_data_array[ 0] = 32'h0000_0004;

      // Configure IDT8T49N006I to generate six 125 MHz clocks to feed into HMC, IDT8T49N004I and the four FMCs.
      // fOUT = fREF * PS *  M /  N
      // 125  =   25 *  2 * 40 / 16
      // If unchanged from factory setting, with the DIP switch open,
      // configuration 2'b01 is used for 125 MHz clock.

      // Set feedback divider M to 40.
      assign i2c_cmd_array [ 1] = WRITE_8;
      assign i2c_dev_array [ 1] = DEVICE_CLK1;
      assign i2c_addr_array[ 1] = 32'h0000_0002;
      assign i2c_data_array[ 1] = 32'h0000_0014;  // 40 >> 1

      // Set output divider N to 16.
      assign i2c_cmd_array [ 2] = WRITE_8;
      assign i2c_dev_array [ 2] = DEVICE_CLK1;
      assign i2c_addr_array[ 2] = 32'h0000_0006;
      assign i2c_data_array[ 2] = 32'h0000_0010;

      // Don't bypass PLL. Set prescaler PS1=2'b10,  P is don't care. Set charge pump CP1=2'b00.
      assign i2c_cmd_array [ 3] = WRITE_8;
      assign i2c_dev_array [ 3] = DEVICE_CLK1;
      assign i2c_addr_array[ 3] = 32'h0000_000A;
      assign i2c_data_array[ 3] = 32'h0000_0020;  //{ 1'b0, BYPASS1, PS1[1:0], P1[1:0], CP1[1:0] }

      // Select LVDS for all outputs (bits 7-5, 3-1)
      assign i2c_cmd_array [ 4] = WRITE_8;
      assign i2c_dev_array [ 4] = DEVICE_CLK1;
      assign i2c_addr_array[ 4] = 32'h0000_000E;
      assign i2c_data_array[ 4] = 32'h0000_00EE;

      // Enable all outputs (bits 7-5, 3-1)
      assign i2c_cmd_array [ 5] = WRITE_8;
      assign i2c_dev_array [ 5] = DEVICE_CLK1;
      assign i2c_addr_array[ 5] = 32'h0000_0012;
      assign i2c_data_array[ 5] = 32'h0000_00EE;


      // Configure IDT8T49N004I to generate 125 MHz clock on Q0 to feed into the FPGA through the FMC0/FMCB connectors.
      // fOUT = fREF/P * PS *  M/N  
      //  125 =  125/2 * 1  * 32/16

      // Set feedback divider M0 to 32.
      assign i2c_cmd_array [ 6] = WRITE_8;
      assign i2c_dev_array [ 6] = DEVICE_CLK2;
      assign i2c_addr_array[ 6] = 32'h0000_0000;
      assign i2c_data_array[ 6] = 32'h0000_0010; // 32 >> 1

      // Set output divider N0 to 16.
      assign i2c_cmd_array [ 7] = WRITE_8;
      assign i2c_dev_array [ 7] = DEVICE_CLK2;
      assign i2c_addr_array[ 7] = 32'h0000_0004;
      assign i2c_data_array[ 7] = 32'h0000_0010;

      // Don't bypass PLL. PS0=2'b00, P0=2'b01, CP0=2'b00.
      assign i2c_cmd_array [ 8] = WRITE_8;
      assign i2c_dev_array [ 8] = DEVICE_CLK2;
      assign i2c_addr_array[ 8] = 32'h0000_0008;
      assign i2c_data_array[ 8] = 32'h0000_0004; //{ 1'b0, BYPASS0, PS0[1:0], P0[1:0], CP0[1:0] }

      // Select LVDS for all outputs:{LVDS_SEL0[Q3],LVDS_SEL0[Q2],LVDS_SEL0[Q1],LVDS_SEL0[Q0]}=4'b1111
      assign i2c_cmd_array [ 9] = WRITE_8;
      assign i2c_dev_array [ 9] = DEVICE_CLK2;
      assign i2c_addr_array[ 9] = 32'h0000_000C;
      assign i2c_data_array[ 9] = 32'h0000_0066;

      // Enable all outputs:{OE0_SEL0[Q3],OE0_SEL0[Q2],OE0_SEL0[Q1],OE0_SEL0[Q0]}=4'b1111
      assign i2c_cmd_array [10] = WRITE_8;
      assign i2c_dev_array [10] = DEVICE_CLK2;
      assign i2c_addr_array[10] = 32'h0000_0010;
      assign i2c_data_array[10] = 32'h0000_0066;

      // Configure SX1508 I2C IO expander and assert L0_RXPS
      // Enable Ln_TXPS input and disable Ln_RXPS input.
      assign i2c_cmd_array [11] = WRITE_8;
      assign i2c_dev_array [11] = DEVICE_GPIO;
      assign i2c_addr_array[11] = 32'h0000_0000 ;
      assign i2c_data_array[11] = 32'h0000_00AA; // input enable 0: enable 1: disable

      // Set Ln_TXPS as inputs and Ln_RXPS as outputs.
      assign i2c_cmd_array [12] = WRITE_8;
      assign i2c_dev_array [12] = DEVICE_GPIO;
      assign i2c_addr_array[12] = 32'h0000_0007 ;
      assign i2c_data_array[12] = 32'h0000_0055; // direction    0: output 1: input

      //Drive L0_RXPS high.
      assign i2c_cmd_array [13] = WRITE_8;
      assign i2c_dev_array [13] = DEVICE_GPIO;
      assign i2c_addr_array[13] = 32'h0000_0008;
      assign i2c_data_array[13] = 32'h0000_0002; // data         drive 1 to L0_RXPS

      /************************************************************************
      * Configure the actual HMC device with correct configurations.          *
      *                                                                       *
      ************************************************************************/

      // Configre the HMC to operate with FPGA on link 0.
      // Set link 0 config register with all defaults except for response open loop.
      assign i2c_cmd_array [14] = WRITE_32;
      assign i2c_dev_array [14] = DEVICE_HMC;
      assign i2c_addr_array[14] = {5'h00, 5'h0C, 22'h240000};   // Set bits 11:0
      assign i2c_data_array[14] = 32'h0000_0EFD;
      // Disable link 1.
      assign i2c_cmd_array [15] = WRITE_32;
      assign i2c_dev_array [15] = DEVICE_HMC;
      assign i2c_addr_array[15] = {5'h00, 5'h02, 22'h250000};   // Clear bits 1:0
      assign i2c_data_array[15] = 32'h0000_0000;
      // Disable link 2.
      assign i2c_cmd_array [16] = WRITE_32;
      assign i2c_dev_array [16] = DEVICE_HMC;
      assign i2c_addr_array[16] = {5'h00, 5'h02, 22'h260000};   // Clear bits 1:0
      assign i2c_data_array[16] = 32'h0000_0000;
      // Disable link 3.
      assign i2c_cmd_array [17] = WRITE_32;
      assign i2c_dev_array [17] = DEVICE_HMC;
      assign i2c_addr_array[17] = {5'h00, 5'h02, 22'h270000};   // Clear bits 1:0
      assign i2c_data_array[17] = 32'h0000_0000;

      // Set link 0 run length limit to 0 (no limit).
      assign i2c_cmd_array [18] = WRITE_32;
      assign i2c_dev_array [18] = DEVICE_HMC;
      assign i2c_addr_array[18] = {5'h10, 5'h08, 22'h240003};   // Set bits 23:16
      assign i2c_data_array[18] = 32'h0000_0000;

      // Set link 0 retry register to defaults except retry transmit number (8) and
      // retry receive number (4).
      assign i2c_cmd_array [19] = WRITE_32;
      assign i2c_dev_array [19] = DEVICE_HMC;
      assign i2c_addr_array[19] = {5'h00, 5'h16, 22'h0C0000};   // Set bits 21:0
      assign i2c_data_array[19] = 32'h0004_0856; // {10'h000, 6'h04, 2'h0, 6'h08, 1'b0, 3'h5, 3'h3, 1'b0}

      // Set link 0 token count to 219.
      assign i2c_cmd_array [20] = WRITE_32;
      assign i2c_dev_array [20] = DEVICE_HMC;
      assign i2c_addr_array[20] = {5'h00, 5'h08, 22'h040000};   // Set bits 7:0
      assign i2c_data_array[20] = 32'h0000_00DB;

      // Set addressing config to defaults.
      assign i2c_cmd_array [21] = WRITE_32;
      assign i2c_dev_array [21] = DEVICE_HMC;
      assign i2c_addr_array[21] = {5'h00, 5'h0E, 22'h2C0000};   // Set bits 13:0
      assign i2c_data_array[21] = 32'h0000_0002;



      // Read firmware version, stage 1
      assign i2c_cmd_array [22] = READ_32_S1;
      assign i2c_dev_array [22] = DEVICE_HMC;
      assign i2c_addr_array[22] = {5'h10, 5'h10, 22'h2C0003};   // Read bits 31:16
      assign i2c_data_array[22] = 32'h0000_0000;  // Reading, doesn't matter

      // Read firmware version, stage 2
      assign i2c_cmd_array [23] = READ_32_S2;
      assign i2c_dev_array [23] = DEVICE_HMC;
      assign i2c_addr_array[23] = {5'h10, 5'h10, 22'h2C0003};   // Doesn't matter during stage 2.
      assign i2c_data_array[23] = 32'h0000_0000;  // Reading, doesn't matter


      // Link configuration ERI
      assign i2c_cmd_array [24] = WRITE_32;
      assign i2c_dev_array [24] = DEVICE_HMC;
      assign i2c_addr_array[24] = {5'h00, 5'h00, eridata0_addr};   // Set bits 31:0
      assign i2c_data_array[24] = 32'h0 | (((CHANNELS == 8) ? 1 : 0) << 16) | ((DATA_RATE == "12500 Mbps") ? 1 : 0);
      // Send link ERI.
      assign i2c_cmd_array [25] = WRITE_32;
      assign i2c_dev_array [25] = DEVICE_HMC;
      assign i2c_addr_array[25] = {5'h00, 5'h00, erireq_addr};   // Set bits 31:0
      assign i2c_data_array[25] = 32'h8000_0005;
      // Wait ERI done. Stage 1.
      assign i2c_cmd_array [26] = READ_32_S1;
      assign i2c_dev_array [26] = DEVICE_HMC;
      assign i2c_addr_array[26] = {5'h00, 5'h00, erireq_addr};   // Read bits 31:0
      assign i2c_data_array[26] = 32'h8000_0000;  // Reading, doesn't matter
      // Wait ERI done. Stage 2.
      assign i2c_cmd_array [27] = READ_32_S2;
      assign i2c_dev_array [27] = DEVICE_HMC;
      assign i2c_addr_array[27] = {5'h00, 5'h00, erireq_addr};   // Doesn't matter during stage 2.
      assign i2c_data_array[27] = 32'h8000_0000;  // Reading, doesn't matter


      // PHY configuration ERI, only done if firmware version >= 0x50 (due to AC coupling).
      assign i2c_cmd_array [28] = WRITE_32;
      assign i2c_dev_array [28] = DEVICE_HMC;
      assign i2c_addr_array[28] = {5'h00, 5'h00, eridata0_addr};   // Set bits 31:0
      assign i2c_data_array[28] = 32'h4000_0000;
      // Send PHY ERI.
      assign i2c_cmd_array [29] = WRITE_32;
      assign i2c_dev_array [29] = DEVICE_HMC;
      assign i2c_addr_array[29] = {5'h00, 5'h00, erireq_addr};   // Set bits 31:0
      assign i2c_data_array[29] = 32'h8000_0006;
      // Wait ERI done. Stage 1.
      assign i2c_cmd_array [30] = READ_32_S1;
      assign i2c_dev_array [30] = DEVICE_HMC;
      assign i2c_addr_array[30] = {5'h00, 5'h00, erireq_addr};   // Read bits 31:0
      assign i2c_data_array[30] = 32'h8000_0000;  // Reading, doesn't matter
      // Wait ERI done. Stage 2.
      assign i2c_cmd_array [31] = READ_32_S2;
      assign i2c_dev_array [31] = DEVICE_HMC;
      assign i2c_addr_array[31] = {5'h00, 5'h00, erireq_addr};   // Doesn't matter during stage 2.
      assign i2c_data_array[31] = 32'h8000_0000;  // Reading, doesn't matter


      // Send INIT continue signal to inform HMC to begin internal initialization
      // and initiate training sequence.
      assign i2c_cmd_array [32] = WRITE_32;
      assign i2c_dev_array [32] = DEVICE_HMC;
      assign i2c_addr_array[32] = {5'h00, 5'h00, erireq_addr};   // Set bits 31:0
      assign i2c_data_array[32] = 32'h8000_003F;

      // Read ERIREQ register to see if ERI is complete. Stage 1.
      assign i2c_cmd_array [33] = READ_32_S1;
      assign i2c_dev_array [33] = DEVICE_HMC;
      assign i2c_addr_array[33] = {5'h00, 5'h00, erireq_addr};   // Read bits 31:0
      assign i2c_data_array[33] = 32'h0000_0000;  // Reading, doesn't matter

      // Read ERIREQ register to see if ERI is complete. Stage 2.
      assign i2c_cmd_array [34] = READ_32_S2;
      assign i2c_dev_array [34] = DEVICE_HMC;
      assign i2c_addr_array[34] = {5'h00, 5'h00, erireq_addr}; // Doesn't matter during stage 2.
      assign i2c_data_array[34] = 32'h0000_0000; // Reading, doesn't matter



      always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          init_state          <= SET_CLK_DIV;
          load_registers_sync <= 4'b0;
          i2c_tr_count        <= 6'b0;
          mm_address_init     <= 8'b0;
          mm_write_init       <= 1'b0;
          mm_read_init        <= 1'b0;
          mm_writedata_init   <= 32'b0;
          registers_loaded    <= 1'b0;
          clock_gen_set       <= 1'b0;
          wait_cnt            <= 21'b0;
          firmware_vs         <= 16'b0;
          eridata0_addr       <= 22'b0;
          erireq_addr         <= 22'b0;
        end else begin // if (!rst_n)
		  
          // Metastable harden load_registers.
          load_registers_sync <= {load_registers_sync[2:0], load_registers};

          mm_write_init       <= 1'b0; // Always only asserted for one cycle.
          mm_read_init        <= 1'b0; // Always only asserted for one cycle.

          // All registers keep their values by default.
          registers_loaded    <= registers_loaded;
          clock_gen_set       <= clock_gen_set;

          case (init_state) 
            SET_CLK_DIV: begin
              mm_address_init   <= I2C32_CLK_DIV_ADDR;
              mm_write_init     <= 1'b1;
              mm_writedata_init <= 62;  // 50 MHz / (62+1) / 2 ~ 400 kHz (a bit less)
              init_state        <= IDLE;
            end
            IDLE: begin
              if ( ~clock_gen_set | (~load_registers_sync[3] & load_registers_sync[2])) begin
                init_state        <= WR_DEVID;
              end else begin
                init_state        <= IDLE;
              end
            end
            WR_DEVID: begin
              if (i2c_tr_count < MAX_TR_CNT) begin
                init_state        <= WR_ADDR;
                mm_address_init   <= I2C32_SLV_ADDR_ADDR;
                mm_write_init     <= 1'b1;
                mm_writedata_init <= i2c_dev_array[i2c_tr_count];
              end else begin
                init_state        <= DONE;
              end
            end
            WR_ADDR: begin
              init_state        <= WR_DATA;
              mm_address_init   <= I2C32_SUB_ADDR_ADDR;
              mm_write_init     <= 1'b1;
              mm_writedata_init <= i2c_addr_array[i2c_tr_count];
            end
            WR_DATA: begin
              init_state        <= WR_CMD;
              mm_address_init   <= I2C32_XMIT_DATA;
              mm_write_init     <= 1'b1;
              mm_writedata_init <= i2c_data_array[i2c_tr_count];
            end
            WR_CMD: begin
              init_state        <= WAIT_START;
              mm_address_init   <= I2C32_CSR_ADDR;
              mm_write_init     <= 1'b1;
              mm_writedata_init <= i2c_cmd_array[i2c_tr_count];
            end
            WAIT_START: begin
              // There is a one cycle delay until I2C actually initiates
              init_state        <= MID_TR_WAIT;
            end
            MID_TR_WAIT: begin
              if (busy) begin
                init_state        <= MID_TR_WAIT;
              end else if (nack) begin
                if (mm_writedata_init[3]) begin
                  // If the nack occured during a read, need to restart the two-stage
                  // read again.
                  i2c_tr_count      <= i2c_tr_count - 1'b1;
                end
                init_state        <= WAIT_20_MS;  // Wait 20 ms and try again.
              end else begin
                init_state        <= PREP_NEXT;
              end
            end
            PREP_NEXT: begin
              // Assume we will be advancing to next instruction
              i2c_tr_count      <= i2c_tr_count + 1'b1;
              init_state        <= WR_DEVID;

              // Cover special cases
              if (mm_writedata_init[3]) begin
                // Read operation. Do not advance to next instruction yet.
                i2c_tr_count      <= i2c_tr_count;
                init_state        <= FETCH_READ_DATA;
                mm_address_init   <= I2C32_READ_DATA_ADDR;
                mm_read_init      <= 1'b1;
              end else if (i2c_tr_count == 10) begin
                // Done configuring on-board clock generators.
                // Must go back to IDLE and wait for load_registers signal from HMCC.
                clock_gen_set     <= 1'b1;
                init_state        <= IDLE;
              end else if ((i2c_tr_count == 27) && (firmware_vs < 16'h50)) begin
                // Older versions of HMC device do not require PHY configuration.
                i2c_tr_count      <= 6'd32;
              end
            end
            FETCH_READ_DATA: begin
              // There is a one cycle delay until data is returned
              if (i2c_tr_count == 23) begin
                // Reading firmware version.
                init_state        <= SAVE_READ_DATA;
              end else begin
                // All other read operations are for reading ERIREQ register during ERI.
                init_state        <= WAIT_ERI;
              end
            end
            SAVE_READ_DATA: begin
              firmware_vs       <= mm_readdata[15:0];
              i2c_tr_count      <= i2c_tr_count + 1'b1; // Advance to next.
              init_state        <= WR_DEVID;

              if (mm_readdata[15:0] < 16'h50) begin
                // Old versions of the HMC device have different addresses.
                eridata0_addr     <= 22'h2B01E0;
                erireq_addr       <= 22'h2B01E4;
              end else begin
                eridata0_addr     <= 22'h2B0000;
                erireq_addr       <= 22'h2B0004;
              end
            end
            WAIT_ERI: begin
              if (mm_readdata[31] == 1) begin
                // The top bit remains high until ERI is complete, so we poll this.
                // If the bit is high, we need to restart the two-stage read of ERIREQ.
                init_state        <= WAIT_20_MS;
                i2c_tr_count      <= i2c_tr_count - 1'b1;
              end else begin
                // Done waiting for ERI. Go to next.
                init_state        <= WR_DEVID;
                i2c_tr_count      <= i2c_tr_count + 1'b1;
              end
            end
            WAIT_20_MS: begin
              if (wait_cnt[20]) begin
                init_state        <= WR_DEVID;
                wait_cnt          <= 21'd0;
              end else begin
                init_state        <= WAIT_20_MS;
                wait_cnt          <= wait_cnt + 1'b1;
              end
            end
            DONE: begin
              init_state        <= IDLE;
              registers_loaded  <= 1'b1;
              i2c_tr_count      <= 6'h0;
            end
          endcase
          // Complete the four way handshake
          if( !load_registers_sync )begin
            registers_loaded  <= 1'b0;
          end
		 end // else: !if(!rst_n)        
      end // always @ (posedge clk or negedge rst_n)


      i2c_32sub #(
      .DEVICE_FAMILY ( DEVICE_FAMILY )
      )
      i2c_32sub
      (
        .address            ( mm_address_init   ),
        .write_data         ( mm_writedata_init ),
        .write              ( mm_write_init     ),
        .read               ( mm_read_init      ),
        .read_data          ( mm_readdata       ),
        .busy               ( busy              ),
        .nack               ( nack              ),
           
        .sda                ( i2c_sda           ),
        .scl                ( i2c_scl           ),

        .reset              ( ~rst_n            ),
        .clk                ( clk               )
      );     
    end // else: !if( SIMULATION_SPEEDUP )
  endgenerate


endmodule
