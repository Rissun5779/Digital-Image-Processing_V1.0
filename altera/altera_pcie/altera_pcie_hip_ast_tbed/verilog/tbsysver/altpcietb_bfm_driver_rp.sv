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
//-----------------------------------------------------------------------------
// Title         : PCI Express BFM Root Port Driver for the chained DMA
//                 design example
// Project       : PCI Express MegaCore function
//-----------------------------------------------------------------------------
// File          : altpcietb_bfm_driver.v
// Author        : Altera Corporation
//-----------------------------------------------------------------------------
// Description : This module is driver for the Root Port BFM for the chained DMA
//               design example.
//     The main process (begin : main) operates in two stages:
//        - EP configuration using the task ebfm_cfg_rp_ep
//        - Run a chained DMA transfer with the task chained_dma_test
//
//    Chained DMA operation:
//       The chained DMA consist of a DMA Write and a DMA Read sub-module
//       Each DMA use a separate descriptor table mapped in the share memeory
//       The descriptor table contains a header with 3 DWORDs (DW0, DW1, DW2)
//
//       |31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16|15 .................0
//   ----|---------------------------------------------------------------------
//       | R|        |         |              |  | E|M| D |
//   DW0 | E| MSI    |         |              |  | P|S| I |
//       | S|TRAFFIC |         |              |  | L|I| R |
//       | E|CLASS   | RESERVED|  MSI         |1 | A| | E |      SIZE:Number
//       | R|        |         |  NUMBER      |  | S| | C |   of DMA descriptor
//       | V|        |         |              |  | T| | T |
//       | E|        |         |              |  |  | | I |
//       | D|        |         |              |  |  | | O |
//       |  |        |         |              |  |  | | N |
//   ----|---------------------------------------------------------------------
//   DW1 |                                       BDT_MSB
//   ----|---------------------------------------------------------------------
//   DW2 |                                       BDT_LSB
//   ----|---------------------------------------------------------------------
//
// RC memory map Overview - Descriptor section
//
//   RC memory  : 2Mbyte 0h -> 200000h
//   BRC+00000h : Descriptor table write
//   BRC+00100h : Descriptor table read
//   BRC+01000h : Data for write
//   BRC+05000h : Data for read
//
//-----------------------------------------------------------------------------
//
// Abreviation:
//     EP      : End Point
//     RC      : Root complex
//     DT      : Descriptor Table
//     MWr     : Memory write
//     MRd     : Memory read
//     CPLD    : Completion with data
//     MSI     : PCIe Message Signaled Interrupt
//     BDT     : Base address of the descriptor header table in RC memory
//     BDT_LSB : Base address of the descriptor header table in RC memory
//     BDT_MSB : Base address of the descriptor header table in RC memory
//     BRC     : [BDT_MSB:BDT_LSB]
//     DW0     : First DWORD of the descriptor table header
//     DW1     : Second DWORD of the descriptor table header
//     DW2     : Third DWORD of the descriptor table header
//     RCLAST  : RC MWr RCLAST in EP memeory to reflects the number
//               of DMA transfers ready to start
//     EPLAST  : EP MWr EPLAST in shared memeory to reflects the number
//               of completed DMA transfers
//
//-----------------------------------------------------------------------------
`define STR_SEP "---------"

module altpcietb_bfm_driver_rp (input clk_in,
                             input INTA,
                             input INTB,
                             input INTC,
                             input INTD,
                             input rstn,
                             output dummy_out);

   // TEST_LEVEL is a parameter passed in from the top level test bench that
   // could control the amount of testing done. It is not currently used.

   // Global parameter
   parameter  TEST_LEVEL            = 1;
   parameter  TL_BFM_MODE           = 1'b0;
   parameter  TL_BFM_RP_CAP_REG     = 32'h42;    // In TL BFM mode, pass PCIE Capabilities reg thru parameter (- there is no RP config space).
                                                 // {specify:  port type, cap version}
   parameter  TL_BFM_RP_DEV_CAP_REG = 32'h05;    // In TL BFM mode, pass Device Capabilities reg thru parameter (- there is no RP config space)..
                                                 // {specify:  maxpayld size}

   parameter RUN_TGT_MEM_TST = 1;
   parameter RUN_DMA_MEM_TST = 1;
   parameter AVALON_MM_LITE = 0;
   parameter DMA_BASE   = 32'h0000_4000;
   parameter CRA_BASE   = 32'h0000_0000;
   parameter MEM_OFFSET = 32'h0020_0000;


   parameter  APPS_TYPE_HWTCL       = 2;
   localparam DISPLAY_ALL           = 0;
   localparam NUMBER_OF_DESCRIPTORS = 4;
   localparam SCR_MEM               = 4096;// Share memory base address used by DMA
   localparam SCR_MEMSLAVE          = 64;// Share memory base address used by RC Slave module
   localparam TIMEOUT_POLLING       = 1024;// number of clock' for timout
   localparam USE_CDMA              = 1;   // When set enable EP upstream MRd/MWr
                                           // using the chaining DMA module
   localparam RCSLAVE_MAXLEN = 10;  // maximum number of read/write
   localparam SCR_MEM_DOWNSTREAM_WR = SCR_MEMSLAVE;
   localparam SCR_MEM_DOWNSTREAM_RD = SCR_MEMSLAVE+2048;


   // Descriptor Table Parameters
   localparam DT_EPLAST = 4'hc;
   localparam MEM_DESCR_LENGTH_INC = 2;
   localparam DMA_CONTINOUS_LOOP = 0;

   // Write DMA DESCRIPTOR TABLE Content
   localparam integer WR_DIRECTION        = 1;
   localparam integer WR_DESCRIPTOR_DEPTH = 4; // 4 DWORDS
   localparam integer WR_BDT_LSB          = SCR_MEM;
   localparam integer WR_BDT_MSB          = 0;
   localparam integer WR_FIRST_DESCRIPTOR = WR_BDT_LSB+WR_BDT_MSB+16;

   localparam integer WR_DESC0_LENGTH     = 82;
   localparam integer WR_DESC0_EPADDR     = 12;
   localparam integer WR_DESC0_RCADDR_MSB = 0;
   localparam integer WR_DESC0_RCADDR_LSB = WR_BDT_LSB+4096;
   localparam integer WR_DESC0_INIT_BFM_MEM = 64'h0000_0000_1515_0001;

   localparam integer WR_DESC1_LENGTH     = 1024;
   localparam integer WR_DESC1_EPADDR     = 0;
   localparam integer WR_DESC1_RCADDR_MSB = 0;
   localparam integer WR_DESC1_RCADDR_LSB = WR_BDT_LSB+8192;
   localparam integer WR_DESC1_INIT_BFM_MEM = 64'h0000_0000_2525_0001;

   localparam integer WR_DESC2_LENGTH     = 644;
   localparam integer WR_DESC2_EPADDR     = 0;
   localparam integer WR_DESC2_RCADDR_MSB = 0;
   localparam integer WR_DESC2_RCADDR_LSB = WR_BDT_LSB+20384;
   localparam integer WR_DESC2_INIT_BFM_MEM = 64'h0000_0000_3535_0001;

   // READ DMA DESCRIPTOR TABLE Content
   localparam integer RD_DIRECTION        = 0;
   localparam integer RD_DESCRIPTOR_DEPTH = 4;
   localparam integer RD_BDT_LSB          = SCR_MEM+512;
   localparam integer RD_BDT_MSB          = 0;
   localparam integer RD_FIRST_DESCRIPTOR = RD_BDT_LSB+RD_BDT_MSB+16;

   localparam integer RD_DESC0_LENGTH     = 82;
   localparam integer RD_DESC0_EPADDR     = 12;
   localparam integer RD_DESC0_RCADDR_MSB = 0;
   localparam integer RD_DESC0_RCADDR_LSB = RD_BDT_LSB+34032;
   localparam integer RD_DESC0_INIT_BFM_MEM = 64'h0000_0000_AAAA_0001;

   localparam integer RD_DESC1_LENGTH     = 1024;
   localparam integer RD_DESC1_EPADDR     = 0;
   localparam integer RD_DESC1_RCADDR_MSB = 0;
   localparam integer RD_DESC1_RCADDR_LSB = RD_BDT_LSB+65536;
   localparam integer RD_DESC1_INIT_BFM_MEM = 64'h0000_0000_BBBB_0001;

   localparam integer RD_DESC2_LENGTH     = 644;
   localparam integer RD_DESC2_EPADDR     = 0;
   localparam integer RD_DESC2_RCADDR_MSB = 0;
   localparam integer RD_DESC2_RCADDR_LSB = RD_BDT_LSB+132592;
   localparam integer RD_DESC2_INIT_BFM_MEM = 64'h0000_0000_CCCC_0001;

   localparam DEBUG_PRG = 0;

   `include "altpcietb_g3bfm_constants.v"
   `include "altpcietb_g3bfm_log.v"
   `include "altpcietb_g3bfm_shmem.v"
   `include "altpcietb_g3bfm_rdwr.v"
   `include "altpcietb_g3bfm_configure.v"




   // The clk_in and rstn signals are provided for possible use in controlling
   // the transactions issued, they are not currently used.

// ebfm_display_verb
// overload ebfm_display by turning on/off verbose when DISPLAY_ALL>0
function ebfm_display_verb(
   input integer msg_type,
   input [EBFM_MSG_MAX_LEN*8:1] message);
   reg unused_result ;
   begin
      if (DISPLAY_ALL==1)
         unused_result = ebfm_display(msg_type, message);
      ebfm_display_verb = 1'b0 ;
   end
endfunction

/////////////////////////////////////////////////////////////////////////
//
// TASK:dma_set_msi:
//
// Setup native PCIe MSI for DMA read and DMA write.
// Retrieve MSI capabilities of EP, program EP MSI cfg register
// with msi_address and msi_data
//
// input argument:
//        bar_table    : Pointer to the BAR sizing and
//        setup_bar    : BAR to be used for setting up
//        bus_num      : default 1
//        dev_num      : default 0
//        fnc_num      : default 0
//        dt_direction : Read or write
//        msi_address  : RC Mem MSI address
//        msi_data     : MSI cgf data
//
// returns:
//       msi_number (default : 1 for write , 0 for read)
//       msi_traffic_class MSI traffic class (default 0)
//       msi_expected Expected data written by MSI to RC Host memory
//
task dma_set_msi (
   input integer bar_table    ,
   input integer setup_bar    ,
   input integer bus_num      ,
   input integer dev_num      ,
   input integer fnc_num      ,
   input integer dt_direction ,
   input integer msi_address  ,
   input integer msi_data     ,

   output reg [4:0] msi_number       ,
   output reg [2:0] msi_traffic_class,
   output reg [2:0] multi_message_enable,
   output integer msi_expected
   );

   localparam msi_capabilities  = 32'h50;
   // The Root Complex BFM has 2MB of address space
   localparam msi_upper_address = 32'h0000_0000;

   reg [15:0] msi_control_register;
   reg        msi_64b_capable;
   reg [2:0]  multi_message_capable;
   reg        msi_enable;
   reg [2:0]  compl_status;
   reg unused_result ;

   begin

      // MSI
      unused_result = ebfm_display_verb(EBFM_MSG_INFO, `STR_SEP);
      if (dt_direction==RD_DIRECTION)
         unused_result = ebfm_display_verb(EBFM_MSG_INFO, "TASK:dma_set_msi READ");
      else
         unused_result = ebfm_display_verb(EBFM_MSG_INFO, "TASK:dma_set_msi WRITE");

      unused_result = ebfm_display_verb(EBFM_MSG_INFO,
                        " Message Signaled Interrupt Configuration");
      // Read the contents of the MSI Control register
      msi_traffic_class = 0; //TODO make it an input argument

      unused_result = ebfm_display(EBFM_MSG_INFO, {"  msi_address (RC memory)= 0x",
                                                    himage4(msi_address)});

      // RC Reading MSI capabilities of the EP
      // to get msi_control_register
      ebfm_cfgrd_wait(bus_num, dev_num, fnc_num,
                      msi_capabilities, 4,
                      msi_address,
                      compl_status);
      msi_control_register  = shmem_read(msi_address+2, 2);

      unused_result = ebfm_display_verb(EBFM_MSG_INFO, {"  msi_control_register = 0x",
                                             himage4(msi_control_register)});

      // Program the MSI Message Control register for testing
      msi_64b_capable       = msi_control_register[7];
      // Enable the MSI with Maximum Number of Supported Messages
      multi_message_capable = msi_control_register[3:1];
      multi_message_enable  = multi_message_capable;
      msi_enable            = 1'b1;
      ebfm_cfgwr_imm_wait(bus_num, dev_num, fnc_num,
                          msi_capabilities, 4,
                          {8'h00, msi_64b_capable,
                          multi_message_enable,
                          multi_message_capable,
                          msi_enable, 16'h0000},
                          compl_status);

      msi_number[4:0]= (1==dt_direction)?5'h1:5'h0;

      // Retrieve msi_expected
      if (multi_message_enable==3'b000)
         begin
            unused_result = ebfm_display(EBFM_MSG_WARNING,
                "The chained DMA example design required at least 2 MSI ");
            unused_result = ebfm_log_stop_sim(1);
         end
      else
         begin
            case (multi_message_enable)
               3'b000:  msi_expected =  msi_data[15:0];
               3'b001:  msi_expected = {msi_data[15:1], msi_number[0]  };
               3'b010:  msi_expected = {msi_data[15:2], msi_number[1:0]};
               3'b011:  msi_expected = {msi_data[15:3], msi_number[2:0]};
               3'b100:  msi_expected = {msi_data[15:4], msi_number[3:0]};
               3'b101:  msi_expected = {msi_data[15:5], msi_number[4:0]};
               default: unused_result = ebfm_display(EBFM_MSG_ERROR_FATAL,
             "Illegal multi_message_enable value detected. MSI test fails.");
            endcase
         end

      // Write the rest of the MSI Capabilities Structure:
      //            Address and Data Fields
     if (msi_64b_capable) // 64-bit Addressing
         begin
            // Specify the RC lower Address where the MSI need to be written
            // when EP issues MSI (msi_address= dt_bdt_lsb-16)
            // 4 DWORD bellow the descriptor table
            ebfm_cfgwr_imm_wait(bus_num, dev_num, fnc_num,
                                msi_capabilities + 4'h4, 4,
                                msi_address,
                                compl_status);
            // Specify the RC Upper Address where the MSI need to be written
            // when EP issues MSI
            ebfm_cfgwr_imm_wait(bus_num, dev_num, fnc_num,
                                msi_capabilities + 4'h8, 4,
                                msi_upper_address,
                                compl_status);
            // Specify the data to be written in the RC Memeoryr MSI location
            // when EP issues MSI
            // (msi_data = 16'hb0fe)
            ebfm_cfgwr_imm_wait(bus_num, dev_num, fnc_num,
                                msi_capabilities + 4'hC, 4,
                                msi_data,
                                compl_status);
         end
      else // 32-bit Addressing
         begin
            // Specify the RC lower Address where the MSI need to be written
            // when EP issues MSI (msi_address= dt_bdt_lsb-16)
            // 4 DWORD bellow the descriptor table
            ebfm_cfgwr_imm_wait(bus_num, dev_num, fnc_num,
                                msi_capabilities + 4'h4, 4,
                                msi_address, compl_status);
            // Specify the data to be written in the RC Memeoryr MSI location
            // when EP issues MSI
            // (msi_data = 16'hb0fe)
            ebfm_cfgwr_imm_wait(bus_num, dev_num, fnc_num,
                                msi_capabilities + 4'h8, 4,
                                msi_data, compl_status);
         end

   // Clear RC memory MSI Location
   shmem_write(msi_address,  32'h1111_FADE,4);

   unused_result = ebfm_display_verb(EBFM_MSG_INFO, {"  msi_expected = 0x",
                                          himage4(msi_expected)});

   unused_result = ebfm_display_verb(EBFM_MSG_INFO, {"  msi_capabilities address = 0x",
                                          himage4(msi_capabilities)});

   unused_result = ebfm_display_verb(EBFM_MSG_INFO, {"  multi_message_enable = 0x",
                                          himage4(multi_message_enable)});

   unused_result = ebfm_display_verb(EBFM_MSG_INFO, {"  msi_number = ",
                                          dimage4(msi_number)});

   unused_result = ebfm_display_verb(EBFM_MSG_INFO, {"  msi_traffic_class = ",
                                          dimage4(msi_traffic_class)});

end


endtask

/////////////////////////////////////////////////////////////////////////
//
// TASK:dma_set_header :
//
// RC issues MWr to write Descriptor table header DW0, DW1, DW2
// RC initializaed RC shared memory with MSI_DATA, DW0, DW1, DW2
//
// Descriptor header table in EP shared memory :
//
//  |----------------------------------------------
//  | DMA Write
//  |----------------------------------------------
//  | 0h     | DW0
//  |--------|-------------------------------------
//  | 04h    | DW1
//  |--------|-------------------------------------
//  | 08h    | DW2
//  |--------|-------------------------------------
//  | 0ch    | RCLast
//  |        | RC MWr RCLast : Available DMA number
//  |----------------------------------------------
//  | DMA Read
//  |----------------------------------------------
//  |10h     | DW0
//  |--------|-------------------------------------
//  |14h     | DW1
//  |--------|-------------------------------------
//  |18h     | DW2
//  |--------|-------------------------------------
//  |1ch     | RCLast
//  |        | RC MWr RCLast : Available DMA number
//  |----------------------------------------------
//
// Descriptor header table in RC shared memory :
//
//  |--------|----------------------------------------------
//  | -10h   | MSI_DATA
//  |        | EP MWr MSI at the end of DMA transfer
//  |--------|----------------------------------------------
//  |BDT LSB | DW0
//  |--------|----------------------------------------------
//  |+04h    | DW1
//  |--------|----------------------------------------------
//  |+08h    | DW2
//  |--------|----------------------------------------------
//  |+0ch    | EPLAST
//  |        | EP MWr EPLAST to reflects DMA transfer number
//  |-------------------------------------------------------
//
task dma_set_header (
   input integer bar_table    , // Pointer to the BAR sizing and
   input integer setup_bar    , // BAR to be used for setting up
   input integer dt_size      , // number of descriptor in the descriptor
   input integer dt_direction , // Read or write
   input integer dt_msi       , // status bit for DMA MSI
   input integer dt_eplast    , // status bit to write back ep_counter info
   input integer dt_bdt_msb   , // RC upper 32 bits base address of the dt
   input integer dt_bdt_lsb   ,  // RC lower 32 bits base address of the dt

   input [4:0] msi_number       ,   // MSI
   input [2:0] msi_traffic_class,   // MSI
   input [2:0] multi_message_enable, // MSI
   input stop_dma_loop
   );

   reg [31:0] dt_dw0;
   integer dt_dw1,dt_dw2 ;
   integer ep_offset ;
   reg unused_result ;

   begin

      // Constructing header dsecriptor table DWORDS DW0
      dt_dw0[15:0]  = dt_size;
      dt_dw0[16]    = (dt_direction==RD_DIRECTION)?1'b0:1'b1;
      dt_dw0[17]    = (dt_msi      ==0)?1'b0:1'b1;
      dt_dw0[18]    = (dt_eplast   ==0)?1'b0:1'b1;
      dt_dw0[19]    = ((multi_message_enable==3'b000)&& (dt_msi==1))?1'b1:1'b0;
      dt_dw0[24:20] = (dt_msi==1)?msi_number[4:0]:0;
      dt_dw0[27:25] = 3'b000;
      dt_dw0[30:28] = (dt_msi==1)?msi_traffic_class:0;
      dt_dw0[31]    = ((DMA_CONTINOUS_LOOP>0)&&(stop_dma_loop==1'b0))?1'b1:1'b0;

      // Constructing header dsecriptor table DWORDS DW1
      dt_dw1 = dt_bdt_msb;

      // Constructing header dsecriptor table DWORDS DW2
      dt_dw2 = dt_bdt_lsb;

      // DMA Write ep_offset /BAR = 0;
      // DMA Read ep_offset  /BAR = 16 (4 DWORDs);
      ep_offset = (WR_DIRECTION==dt_direction)?0:16;

      // display section
      unused_result = ebfm_display_verb(EBFM_MSG_INFO, `STR_SEP);
      if (dt_direction==RD_DIRECTION)
         unused_result = ebfm_display_verb(EBFM_MSG_INFO, "TASK:dma_set_header READ");
      else
         unused_result = ebfm_display_verb(EBFM_MSG_INFO, "TASK:dma_set_header WRITE");

      unused_result = ebfm_display_verb(EBFM_MSG_INFO, "Writing Descriptor header");

      // RC writes EP DMA register (for module altpcie_dma_prg_reg)
      if (DEBUG_PRG==0) begin
         ebfm_barwr_imm(bar_table, setup_bar, 0+ep_offset, dt_dw0, 4, 0);
         ebfm_barwr_imm(bar_table, setup_bar, 4+ep_offset, dt_dw1, 4, 0);
         ebfm_barwr_imm(bar_table, setup_bar, 8+ep_offset, dt_dw2, 4, 0);
      end
      else begin
         ebfm_barwr_imm(bar_table, setup_bar, 0+ep_offset, 32'hC1FE_FADE, 4, 0);
         ebfm_barwr_imm(bar_table, setup_bar, 4+ep_offset, 32'hC2FE_FADE, 4, 0);
         ebfm_barwr_imm(bar_table, setup_bar, 8+ep_offset, 32'hC3FE_FADE, 4, 0);
      end
      // RC writes RC Memory
      shmem_write(dt_bdt_lsb  , dt_dw0,4);
      shmem_write(dt_bdt_lsb+4, dt_dw1,4);
      shmem_write(dt_bdt_lsb+8, dt_dw2,4);
      shmem_write(dt_bdt_lsb+12, 32'hCAFE_FADE,4);

      shmem_fill(dt_bdt_lsb+12,SHMEM_FILL_DWORD_INC,4,32'hCAFE_FADE);

      unused_result = ebfm_display_verb(EBFM_MSG_INFO, "data content of the DT header");
      if (DISPLAY_ALL==1)
         unused_result =shmem_display(dt_bdt_lsb,4*4,4,dt_bdt_lsb+(4*4),EBFM_MSG_INFO);
   end

endtask

/////////////////////////////////////////////////////////////////////////
//
// TASK:dma_set_rclast :
//    RC issues MWr RCLast to EP at address C on the EP site
//    RCLast is a WORD which represent the number of the DMA descriptor
//    ready for transfer.
//    Writing RCLast to EP trigger the start of the DMA transfer
//
// input argument
//    bar_table    : Pointer to the BAR sizing and
//    setup_bar    : BAR to be used for setting up
//    dt_direction : Read (0) or Write (1)
//    dt_rclast    : status bit to write back ep_counter info
//
task dma_set_rclast (
   input integer bar_table    ,
   input integer setup_bar    ,
   input integer dt_direction ,
   input integer dt_rclast
   );

   reg [31:0] dt_dw4 ;
   integer ep_offset ;
   reg unused_result ;

   begin

      // DMA Write ep_offset /BAR = 0;
      // DMA Read ep_offset  /BAR = 16 (4 DWORDs);
      ep_offset = (WR_DIRECTION==dt_direction)?0:16;
      dt_dw4[15:0]    = dt_rclast;
      dt_dw4[31:16]   = 1;

      // display section
      unused_result = ebfm_display_verb(EBFM_MSG_INFO, `STR_SEP);
      unused_result = ebfm_display_verb(EBFM_MSG_INFO, "TASK:dma_set_rclast");

      if (dt_direction==RD_DIRECTION)
         unused_result = ebfm_display_verb(EBFM_MSG_INFO,
                      {"   Start READ DMA : RC issues MWr (RCLast=",
                      dimage4(dt_rclast), ")"});
      else
         unused_result = ebfm_display_verb(EBFM_MSG_INFO,
                      {"   Start WRITE DMA : RC issues MWr (RCLast=",
                      dimage4(dt_rclast), ")"});

      // RC writes EP DMA register
      ebfm_barwr_imm(bar_table, setup_bar, 12+ep_offset, dt_dw4, 4, 0);
   end
endtask

/////////////////////////////////////////////////////////////////////////
//
// TASK: dma_set_wr_desc_data :
//
//  write 'write descriptor table in the RC Memory
//
/////////////////////////////////////////////////////
//           |-------------------------------------
//           | header write
//           |-------------------------------------
// BRC+0h    | DW0: number of descriptor
// BRC+4h    | DW1: BDT MSB
// BRC+8h    | DW2: BDT LSB
// BRC+ch    | DW3: EP Last
//           |-------------------------------------
//           | desc0 write
//           |-------------------------------------
// BRC+10h   | DW0: length        : 256 DWORDS
// BRC+14h   | DW1: EP ADDR       : 0h
// BRC+18h   | DW2: RC ADDR MSB   : BDT_MSB
// BRC+1ch   | DW3: RC ADDR LSB   : BRC+01000h
//           |-------------------------------------
//           | desc1 write
//           |-------------------------------------
// BRC+20h   | DW0: length        : 512 DWORDS
// BRC+24h   | DW1: EP ADDR       : 0h
// BRC+28h   | DW2: RC ADDR MSB   : BDT_MSB
// BRC+2ch   | DW3: RC ADDR LSB   : BRC+02000h
//           |-------------------------------------
//           | desc2 write
//           |-------------------------------------
// BRC+30h   | DW0: length        : 1024 DWORDS
// BRC+34h   | DW1: EP ADDR       : 0h
// BRC+38h   | DW2: RC ADDR MSB   : BDT_MSB
// BRC+3ch   | DW3: RC ADDR LSB   : BRC+03000h
//           |-------------------------------------
//
// input arguments
//   bar_table : Pointer to the BAR sizing and
//   setup_bar : BAR to be used for setting up
//
task dma_set_wr_desc_data (
   input integer bar_table    ,
   input integer setup_bar
   );

   reg unused_result ;
   integer descriptor_addr,i;

   integer loop_DW0;
   integer loop_DW1;
   integer loop_DW2;
   integer loop_DW3;

   begin

      //program BFM share memeory
      unused_result = ebfm_display_verb(EBFM_MSG_INFO, `STR_SEP);
      unused_result = ebfm_display_verb(EBFM_MSG_INFO, "TASK:dma_set_wr_desc_data");
      // First Descriptor
      descriptor_addr = WR_FIRST_DESCRIPTOR;
      shmem_write(descriptor_addr  ,  WR_DESC0_LENGTH     ,4);
      shmem_write(descriptor_addr+4,  WR_DESC0_EPADDR     ,4);
      shmem_write(descriptor_addr+8,  WR_DESC0_RCADDR_MSB ,4);
      shmem_write(descriptor_addr+12, WR_DESC0_RCADDR_LSB ,4);
      shmem_fill(WR_DESC0_RCADDR_LSB,SHMEM_FILL_DWORD_INC,
                 WR_DESC0_LENGTH*4,WR_DESC0_INIT_BFM_MEM);
      // Display descriptor table of DMA Write
      if (NUMBER_OF_DESCRIPTORS>3)
      begin
         for (i=1;i<NUMBER_OF_DESCRIPTORS-1;i=i+1)
         begin
            descriptor_addr = WR_FIRST_DESCRIPTOR + 16*i;
            loop_DW0        = WR_DESC1_LENGTH + i*MEM_DESCR_LENGTH_INC;
            loop_DW1        = WR_DESC1_EPADDR ;
            loop_DW2        = WR_DESC1_RCADDR_MSB;
            loop_DW3        = WR_DESC1_RCADDR_LSB;
            shmem_write(descriptor_addr  ,  loop_DW0 ,4);
            shmem_write(descriptor_addr+4,  loop_DW1 ,4);
            shmem_write(descriptor_addr+8,  loop_DW2 ,4);
            shmem_write(descriptor_addr+12, loop_DW3 ,4);
            if (i==1)
               shmem_fill(WR_DESC1_RCADDR_LSB,SHMEM_FILL_DWORD_INC, loop_DW0*4,
                       WR_DESC1_INIT_BFM_MEM);
         end
         i = NUMBER_OF_DESCRIPTORS-2;
      end
      else
      begin
         i = 1;
         // Descriptor 1
         descriptor_addr = WR_FIRST_DESCRIPTOR+16;
         shmem_write(descriptor_addr  ,  WR_DESC1_LENGTH     ,4);
         shmem_write(descriptor_addr+4,  WR_DESC1_EPADDR     ,4);
         shmem_write(descriptor_addr+8,  WR_DESC1_RCADDR_MSB ,4);
         shmem_write(descriptor_addr+12, WR_DESC1_RCADDR_LSB ,4);
         shmem_fill(WR_DESC1_RCADDR_LSB,SHMEM_FILL_DWORD_INC,
                 WR_DESC1_LENGTH*4,WR_DESC1_INIT_BFM_MEM);
      end

      // Last Descriptor
      descriptor_addr = WR_FIRST_DESCRIPTOR+16*(i+1);
      shmem_write(descriptor_addr  ,  WR_DESC2_LENGTH     ,4);
      shmem_write(descriptor_addr+4,  WR_DESC2_EPADDR     ,4);
      shmem_write(descriptor_addr+8,  WR_DESC2_RCADDR_MSB ,4);
      shmem_write(descriptor_addr+12, WR_DESC2_RCADDR_LSB ,4);
      shmem_fill(WR_DESC2_RCADDR_LSB,SHMEM_FILL_DWORD_INC,
                 WR_DESC2_LENGTH*4,WR_DESC2_INIT_BFM_MEM);
   end
endtask


/////////////////////////////////////////////////////////////////////////
//
// TASK:dma_set_rd_desc_data : write 'read descriptor table in the RC Memory
//
//           |-------------------------------------
//           | header read
//           |-------------------------------------
// BRC+100h  | DW0: number of descriptor
// BRC+104h  | DW1: BDT MSB
// BRC+108h  | DW2: BDT LSB
// BRC+10ch  | DW3: EP Last
//           |-------------------------------------
//           | desc0 read
//           |-------------------------------------
// BRC+110h  | DW0: length
// BRC+114h  | DW1: EP ADDR       : 0h
// BRC+118h  | DW2: RC ADDR MSB   : BDT_MSB
// BRC+11ch  | DW3: RC ADDR LSB   : BRC+05000h
//           |-------------------------------------
//           | desc1 read
//           |-------------------------------------
// BRC+120h  | DW0: length
// BRC+124h  | DW1: EP ADDR       : 0h
// BRC+128h  | DW2: RC ADDR MSB   : BDT_MSB
// BRC+12ch  | DW3: RC ADDR LSB   :
//           |-------------------------------------
//           | desc2 read
//           |-------------------------------------
// BRC+130h  | DW0: length
// BRC+134h  | DW1: EP ADDR       : 0h
// BRC+138h  | DW2: RC ADDR MSB   : BDT_MSB
// BRC+13ch  | DW3: RC ADDR LSB   :
//           |-------------------------------------
//
// input arguments
//   bar_table : Pointer to the BAR sizing and
//   setup_bar : BAR to be used for setting up
//
task dma_set_rd_desc_data
   (
   input integer bar_table,
   input integer setup_bar
   );
   // HEADER PARAMETERS

   reg unused_result ;
   integer descriptor_addr,i;

   integer loop_DW0;
   integer loop_DW1;
   integer loop_DW2;
   integer loop_DW3;

   begin

      unused_result = ebfm_display_verb(EBFM_MSG_INFO, `STR_SEP);
      unused_result = ebfm_display_verb(EBFM_MSG_INFO, "TASK:dma_set_rd_desc_data");

      //program BFM share memory :

      // First Descriptor
      descriptor_addr = RD_FIRST_DESCRIPTOR;
      shmem_write(descriptor_addr  ,  RD_DESC0_LENGTH     ,4);
      shmem_write(descriptor_addr+4,  RD_DESC0_EPADDR     ,4);
      shmem_write(descriptor_addr+8,  RD_DESC0_RCADDR_MSB ,4);
      shmem_write(descriptor_addr+12, RD_DESC0_RCADDR_LSB ,4);
      shmem_fill(RD_DESC0_RCADDR_LSB,SHMEM_FILL_DWORD_INC,RD_DESC0_LENGTH*4,
                 RD_DESC0_INIT_BFM_MEM);

      if (NUMBER_OF_DESCRIPTORS>3)
      begin
         for (i=1;i<NUMBER_OF_DESCRIPTORS-1;i=i+1)
         begin
            descriptor_addr = RD_FIRST_DESCRIPTOR + 16*i;
            loop_DW0        = RD_DESC1_LENGTH + i*MEM_DESCR_LENGTH_INC;
            loop_DW1        = RD_DESC1_EPADDR ;
            loop_DW2        = RD_DESC1_RCADDR_MSB;
            loop_DW3        = RD_DESC1_RCADDR_LSB;
            shmem_write(descriptor_addr  ,  loop_DW0 ,4);
            shmem_write(descriptor_addr+4,  loop_DW1 ,4);
            shmem_write(descriptor_addr+8,  loop_DW2 ,4);
            shmem_write(descriptor_addr+12, loop_DW3 ,4);
            if (i==1)
               shmem_fill(RD_DESC1_RCADDR_LSB,SHMEM_FILL_DWORD_INC, loop_DW0*4,
                              RD_DESC1_INIT_BFM_MEM);
         end
         i = NUMBER_OF_DESCRIPTORS-2;
      end
      else
      begin
         // Descriptor 1
         i = 1;
         descriptor_addr = RD_FIRST_DESCRIPTOR+16;
         shmem_write(descriptor_addr  ,  RD_DESC1_LENGTH     ,4);
         shmem_write(descriptor_addr+4,  RD_DESC1_EPADDR     ,4);
         shmem_write(descriptor_addr+8,  RD_DESC1_RCADDR_MSB ,4);
         shmem_write(descriptor_addr+12, RD_DESC1_RCADDR_LSB ,4);
         shmem_fill(RD_DESC1_RCADDR_LSB, SHMEM_FILL_DWORD_INC,
                 RD_DESC1_LENGTH*4,RD_DESC1_INIT_BFM_MEM);
      end

      // Last Descriptor
      descriptor_addr = RD_FIRST_DESCRIPTOR+16*(i+1);
      shmem_write(descriptor_addr  ,  RD_DESC2_LENGTH     ,4);
      shmem_write(descriptor_addr+4,  RD_DESC2_EPADDR     ,4);
      shmem_write(descriptor_addr+8,  RD_DESC2_RCADDR_MSB ,4);
      shmem_write(descriptor_addr+12, RD_DESC2_RCADDR_LSB ,4);
      shmem_fill(RD_DESC2_RCADDR_LSB,SHMEM_FILL_DWORD_INC,
                 RD_DESC2_LENGTH*4,RD_DESC2_INIT_BFM_MEM);
   end
endtask


/////////////////////////////////////////////////////////////////////////
//
// TASK:msi_poll
//   Polling process to track in shared memeory received MSI from EP
//
// input argument
//    max_number_of_msi  : Total Number of MSI to track
//    msi_address        : MSI Address in shared memeory
//    msi_expected_dmawr : Expected MSI when dma_write is set
//    msi_expected_dmard : Expected MSI when dma_read is set
//    dma_write          : Set dma_write
//    dma_read           : set dma_read
task msi_poll(
   input integer max_number_of_msi,
   input integer msi_address,
   input integer msi_expected_dmawr,
   input integer msi_expected_dmard,
   input integer dma_write,
   input integer dma_read
   );

   reg unused_result ;
   integer msi_received;
   integer msi_count;
   reg pol_ip;

   begin
      unused_result = ebfm_display_verb(EBFM_MSG_INFO, `STR_SEP);
      unused_result = ebfm_display_verb(EBFM_MSG_INFO, "TASK: msi_poll");
      for (msi_count=0; msi_count < max_number_of_msi;msi_count=msi_count+1)
      begin
         pol_ip=0;
         fork
         // Set timeout failure if expected MSI is not received
         begin:timeout_msi
            repeat (100000) @(posedge clk_in);
            unused_result = ebfm_display(EBFM_MSG_ERROR_FATAL,
                     "MSI timeout occured, MSI never received, Test Fails");
            disable wait_for_msi;
         end
         // Polling memory for expected MSI data value
         // at the assigned MSI address location
         begin:wait_for_msi
            forever
               begin
                  repeat (50) @(posedge clk_in);
                  msi_received = shmem_read (msi_address, 2);
                  if (pol_ip==0)
                     unused_result = ebfm_display(EBFM_MSG_INFO,{
                                       "   Polling MSI Address:",
                                       himage4(msi_address),
                                       "---> Data:",
                                       himage4(msi_received),
                                       "......"});

                  pol_ip=1;
                  if ((msi_received == msi_expected_dmawr) && (dma_write==1))
                     begin
                        unused_result = ebfm_display(EBFM_MSG_INFO,
                                    {"    Received Expected DMA Write MSI(",
                                   dimage4(msi_count),
                                   ") : ",
                                   himage4(msi_received)});
                        shmem_write( msi_address , 32'h1111_FADE, 4);
                        disable timeout_msi;
                        disable wait_for_msi;

                     end

                  if ((msi_received == msi_expected_dmard) && (dma_read==1))
                     begin
                        unused_result = ebfm_display(EBFM_MSG_INFO,
                                    {"    Received Expected DMA Read MSI(",
                                   dimage4(msi_count),
                                   ") : ",
                                   himage4(msi_received)});
                        shmem_write( msi_address , 32'h1111_FADE, 4);

                        if (DISPLAY_ALL==1)
                        unused_result = shmem_display(SCR_MEM+256,
                                             4*4,
                                             4,
                                             SCR_MEM+256+(4*4),
                                             EBFM_MSG_INFO);

                        disable timeout_msi;
                        disable wait_for_msi;
                     end
               end
         end
         join
      end
   end
endtask

/////////////////////////////////////////////////////////////////////////
//
// rcmem_poll
//
// Polling routine waiting for rc_data at location rc_addr
//
task rcmem_poll(
   input integer rc_addr,
   input integer rc_data,
   input integer rc_data_mask);

   reg unused_result ;
   integer rc_current;
   integer rc_last;
   reg [31:0] timout_limit;
   reg pol_ip;

   begin

      unused_result = ebfm_display_verb(EBFM_MSG_INFO, `STR_SEP);
      unused_result = ebfm_display_verb(EBFM_MSG_INFO, "TASK:rcmem_poll");
      pol_ip=0;
      timout_limit[31:0]=0;

      fork

      begin:wait_for_rcmem
         forever
            begin
               repeat (50) @(posedge clk_in);
               rc_current = (shmem_read (rc_addr, 4) & (rc_data_mask));
               if (pol_ip==0) begin
                  `ifdef IPD_DEBUG
                     ebfm_display(EBFM_MSG_INFO, "-->CHECKPOINT20031");
                  `endif
                  timout_limit[31:0]=0;
                  rc_last    = rc_current;
                  unused_result = ebfm_display_verb(EBFM_MSG_INFO,
                        {"   Polling RC Address:"   ,himage8(rc_addr),
                         "   current data (" ,himage8(rc_current),
                         ")  expected data (",himage8(rc_data),")"});
               end
               if (rc_current != rc_last ) begin
                  `ifdef IPD_DEBUG
                     ebfm_display(EBFM_MSG_INFO, "-->CHECKPOINT20032");
                  `endif
                  unused_result = ebfm_display(EBFM_MSG_INFO,
                        {"   Polling RC Address:"   ,himage8(rc_addr),
                         "   current data (" ,himage8(rc_current),
                         ")  expected data (",himage8(rc_data),")"});
                  timout_limit[31:0]=0;
               end
               else
                  timout_limit[31:0]=timout_limit[31:0]+1;

               rc_last    = rc_current;
               pol_ip=1;

               if (timout_limit[31:0]>TIMEOUT_POLLING) begin
                  unused_result = ebfm_display(EBFM_MSG_INFO,
                            "   ---> TASK:rcmem_poll timeout occured");
                  unused_result = ebfm_display(EBFM_MSG_ERROR_FATAL,
                           {"   ---> Test Fails: RC Address:",
                           himage8(rc_addr)," contains ", himage8(rc_current)});
                  disable wait_for_rcmem;
               end
               if (rc_current == rc_data)
                  begin
                     unused_result = ebfm_display(EBFM_MSG_INFO,
                     {"   ---> Received Expected Data (",himage8(rc_current),")"});
                     disable wait_for_rcmem;
                  end
            end
      end
      join
   end
endtask

/////////////////////////////////////////////////////////////////////////
//
// TASK:dma_rd_test
//
// Run the chained DMA read
//
// Input argument
//     bar_table :  Pointer to the BAR sizing and
//     setup_bar :  BAR to be used for setting up
//                  4 Write then Read
//     use_msi   :  When set, use msi
//     use_eplast:  When set, poll for ep last
//
task dma_rd_test(
   input integer bar_table,
   input integer setup_bar,
   input integer use_msi,
   input integer use_eplast);

   localparam integer MSI_ADDRESS     = SCR_MEM-16;
   localparam integer MSI_DATA        = 16'hb0fe;

   reg unused_result ;
   integer RCLast;

   reg [4:0] msi_number          ;
   reg [2:0] msi_traffic_class   ;
   reg [2:0] multi_message_enable;
   integer   msi_address         ;

   integer   msi_expected_dmawr ;
   integer   msi_expected_dmard ;

   integer msi_received ;
   integer msi_count    ;
   integer max_count    ;
   integer i;
   reg [31:0] track_rclast_loop;

   begin

      unused_result = ebfm_display_verb(EBFM_MSG_INFO, `STR_SEP);
      unused_result = ebfm_display_verb(EBFM_MSG_INFO, "TASK:dma_rd_test");

      // Read descriptor table in the RC Memory
      dma_set_rd_desc_data(bar_table, setup_bar);

      `ifdef IPD_DEBUG
      ebfm_display(EBFM_MSG_INFO, "-->CHECKPOINT2001");
      `endif


      // Set MSI for DMA Read
      if (use_msi==1)
         dma_set_msi(bar_table,  // Pointer to the BAR sizing and
                        setup_bar,  // BAR to be used for setting up
                        1,          // bus_num
                        0,          // dev_num
                        0,          // fnc_num
                        RD_DIRECTION,          // Direction
                        MSI_ADDRESS,// MSI RC memeory address
                        MSI_DATA,   // MSI Cfg data value
                        msi_number,        // msi_number
                        msi_traffic_class, //msi traffic class
                        multi_message_enable,// number of msi
                        msi_expected_dmard // expexted MSI data value
                     );

         `ifdef IPD_DEBUG
      ebfm_display(EBFM_MSG_INFO, "-->CHECKPOINT2002");
      `endif

      // Read Descriptor header in EP memory PRG
      dma_set_header( bar_table,       // Pointer to the BAR sizing and
                     setup_bar,       // BAR to be used for setting up
                     NUMBER_OF_DESCRIPTORS, // number of descriptor
                     RD_DIRECTION,            // Direction read
                     use_msi   ,   // status bit for DMA MSI
                     use_eplast,   // status bit to write back ep_last
                     RD_BDT_MSB,      // RC upper 32 bits of bdt
                     RD_BDT_LSB,      // RC lower 32 bits of bdt
                     msi_number,
                     msi_traffic_class,
                     multi_message_enable,
                     0);

      `ifdef IPD_DEBUG
      ebfm_display(EBFM_MSG_INFO, "-->CHECKPOINT20021");
      `endif


      //Program RP RCLast
      RCLast = NUMBER_OF_DESCRIPTORS-1; // 3 descriptor, written 0,1,2

      // Start read DMA
      dma_set_rclast(bar_table, setup_bar, RD_DIRECTION, RCLast);

      // Polling EP Last
      if (use_eplast==1) begin
         if (DMA_CONTINOUS_LOOP==0) begin
            `ifdef IPD_DEBUG
               ebfm_display(EBFM_MSG_INFO, "-->CHECKPOINT2003");
            `endif
            rcmem_poll(RD_BDT_LSB+DT_EPLAST, RCLast,32'h0000FFFF);
            `ifdef IPD_DEBUG
               ebfm_display(EBFM_MSG_INFO, "-->CHECKPOINT2004");
            `endif
         end
         else begin
            for (i=0;i<DMA_CONTINOUS_LOOP;i=i+1) begin
               unused_result = ebfm_display(EBFM_MSG_INFO, { "   Running DMA loop ", dimage4(i), " : "});
               shmem_write(RD_BDT_LSB+DT_EPLAST, 32'hCAFE_FADE,4);
               rcmem_poll(RD_BDT_LSB+DT_EPLAST, RCLast,32'h0000FFFF);
            end
            shmem_write(RD_BDT_LSB+DT_EPLAST, 32'hCAFE_FADE,4);
            dma_set_header( bar_table,       // Pointer to the BAR sizing and
                     setup_bar,       // BAR to be used for setting up
                     NUMBER_OF_DESCRIPTORS, // number of descriptor
                     RD_DIRECTION,            // Direction read
                     use_msi   ,   // status bit for DMA MSI
                     use_eplast,   // status bit to write back ep_last
                     RD_BDT_MSB,      // RC upper 32 bits of bdt
                     RD_BDT_LSB,      // RC lower 32 bits of bdt
                     msi_number,
                     msi_traffic_class,
                     multi_message_enable,
                     1); // stop_loop
             track_rclast_loop[15:0] = RCLast;
             track_rclast_loop[31:16] = 1 ;
             unused_result = ebfm_display(EBFM_MSG_INFO, "   Flushing DMA loop");
             rcmem_poll(RD_BDT_LSB+DT_EPLAST, track_rclast_loop,32'h0001ffff);
         end
      end

     // Monitor MSI - Polling MSI
      if (use_msi==1)
         msi_poll(RCLast+1,MSI_ADDRESS,0, msi_expected_dmard,0,1);

      ebfm_barwr_imm(bar_table, setup_bar, 16, 32'h0000_FFFF, 4, 0);

      unused_result = ebfm_display_verb(EBFM_MSG_INFO, `STR_SEP);
      unused_result = ebfm_display_verb(EBFM_MSG_INFO, "Completed DMA Read");


   end

endtask

/////////////////////////////////////////////////////////////////////////
//
// TASK:dma_wr_test
//
// Run the chained DMA write
//
// Input argument
//     bar_table :  Pointer to the BAR sizing and
//     setup_bar :  BAR to be used for setting up
//                  4 Write then Read
//     use_msi   :  When set, use msi
//     use_eplast:  When set, poll for ep last
//
task dma_wr_test(
   input integer bar_table,
   input integer setup_bar,
   input integer use_msi,
   input integer use_eplast);

   localparam integer MSI_ADDRESS = SCR_MEM-16;
   localparam integer MSI_DATA    = 16'hb0fe;

   reg unused_result ;
   integer RCLast;

   reg [4:0] msi_number          ;
   reg [2:0] msi_traffic_class   ;
   reg [2:0] multi_message_enable;
   integer   msi_address         ;

   integer   msi_expected_dmawr ;
   integer   msi_expected_dmard ;

   integer msi_received ;
   integer msi_count    ;
   integer max_count    ;
   integer i    ;
   reg [31:0] track_rclast_loop;
   begin

      unused_result = ebfm_display_verb(EBFM_MSG_INFO, `STR_SEP);
      unused_result = ebfm_display_verb(EBFM_MSG_INFO, "TASK:dma_wr_test");
      unused_result = ebfm_display_verb(EBFM_MSG_INFO,"   DMA: Write");

      // write 'write descriptor table in the RC Memory
      dma_set_wr_desc_data(bar_table, setup_bar);

      // Set MSI for DMA Writew
      if (use_msi==1)
         dma_set_msi( bar_table,  // Pointer to the BAR sizing and
                             setup_bar,  // BAR to be used for setting up
                             1,          // bus_num
                             0,          // dev_num
                             0,          // fnc_num
                             WR_DIRECTION,          // Direction
                             MSI_ADDRESS,// MSI RC memeory address
                             MSI_DATA,   // MSI Cfg data value
                             msi_number, // msi_number
                             msi_traffic_class, //msi traffic class
                             multi_message_enable,// number of msi
                             msi_expected_dmawr // expexted MSI data value
                             );

      // Write Descriptor header in EP memory PRG
      dma_set_header( bar_table,      // Pointer to the BAR sizing and
                     setup_bar,       // BAR to be used for setting up
                     NUMBER_OF_DESCRIPTORS, // number of descriptor
                     WR_DIRECTION,    // Direction = Write
                     use_msi,         // status bit for DMA MSI
                     use_eplast,      // status bit to write back ep_last
                     WR_BDT_MSB,      // RC upper 32 bits of bdt
                     WR_BDT_LSB,      // RC lower 32 bits of bdt
                     msi_number,
                     msi_traffic_class,
                     multi_message_enable,
                     0);

      //Program RP RCLast
      RCLast = NUMBER_OF_DESCRIPTORS-1; // 3 descriptor, written 0,1,2

      // Start write DMA
      dma_set_rclast(bar_table, setup_bar, WR_DIRECTION, RCLast);

      if (use_eplast==1) begin
         if (DMA_CONTINOUS_LOOP==0)
            rcmem_poll(WR_BDT_LSB+DT_EPLAST, RCLast,32'h0000ffff);
         else begin
            for (i=0;i<DMA_CONTINOUS_LOOP;i=i+1) begin
               unused_result = ebfm_display(EBFM_MSG_INFO, { "   Running DMA loop ", dimage4(i), " : "});
               shmem_write(WR_BDT_LSB+DT_EPLAST, 32'hCAFE_FADE,4);
               rcmem_poll(WR_BDT_LSB+DT_EPLAST, RCLast,32'h0000ffff);
            end
            shmem_write(WR_BDT_LSB+DT_EPLAST, 32'hCAFE_FADE,4);
            dma_set_header( bar_table,      // Pointer to the BAR sizing and
                     setup_bar,       // BAR to be used for setting up
                     NUMBER_OF_DESCRIPTORS, // number of descriptor
                     WR_DIRECTION,    // Direction = Write
                     use_msi,         // status bit for DMA MSI
                     use_eplast,      // status bit to write back ep_last
                     WR_BDT_MSB,      // RC upper 32 bits of bdt
                     WR_BDT_LSB,      // RC lower 32 bits of bdt
                     msi_number,
                     msi_traffic_class,
                     multi_message_enable,
                     1);
             track_rclast_loop[15:0] = RCLast;
             track_rclast_loop[31:16] = 1 ;
             unused_result = ebfm_display(EBFM_MSG_INFO, "   Flushing DMA loop");
             rcmem_poll(WR_BDT_LSB+DT_EPLAST, track_rclast_loop,32'h0001ffff);
         end
      end
     // Monitor MSI - Polling MSI
      if (use_msi==1)
         msi_poll( RCLast+1, MSI_ADDRESS, msi_expected_dmawr,0,1,0);

      ebfm_barwr_imm(bar_table, setup_bar, 0, 32'h0000_FFFF, 4, 0);

      unused_result = ebfm_display_verb(EBFM_MSG_INFO, `STR_SEP);
      unused_result = ebfm_display_verb(EBFM_MSG_INFO, "Completed DMA Write");

  end

endtask

/////////////////////////////////////////////////////////////////////////
//
// TASK:chained_dma_test
//
//    Main task to run the chained DMA read/Write
//
// Input argument
//     bar_table :  Pointer to the BAR sizing and
//     setup_bar :  BAR to be used for setting up
//     direction :  0 read,
//                  1 write,
//                  2 read and write simulataneous
//                  3 Read then Write
//                  4 Write then Read
//
task chained_dma_test(
    input integer bar_table ,
    input integer setup_bar ,
    input integer direction ,
    input integer use_msi   ,
    input integer use_eplast
   );

   reg unused_result ;

   begin

      unused_result = ebfm_display(EBFM_MSG_INFO, `STR_SEP);
      unused_result = ebfm_display(EBFM_MSG_INFO, "TASK:chained_dma_test");
      case (direction)
         0: begin
               unused_result = ebfm_display(EBFM_MSG_INFO,"   DMA: Read");
               dma_rd_test(bar_table, setup_bar, use_msi, use_eplast);
            end
         1: begin
               unused_result = ebfm_display(EBFM_MSG_INFO,"   DMA: Write");
               dma_wr_test(bar_table, setup_bar, use_msi, use_eplast);
            end
          default: unused_result = ebfm_display(EBFM_MSG_INFO,"   Incorrect direction");

      endcase
  end
endtask


// purpose: Examine the DUT's BAR setup and pick a reasonable BAR to use
task find_mem_bar;
   input bar_table;
   integer bar_table;
   input[5:0] allowed_bars;
   input min_log2_size;
   integer min_log2_size;
   output sel_bar;
   integer sel_bar;

   integer cur_bar;
   reg[31:0] bar32;
   integer log2_size;
   reg is_mem;
   reg is_pref;
   reg is_64b;

   begin
      // find_mem_bar
      cur_bar = 0;
      begin : sel_bar_loop
         while (cur_bar < 6)
         begin
            ebfm_cfg_decode_bar(bar_table, cur_bar,
                                log2_size, is_mem, is_pref, is_64b);
            if ((is_mem == 1'b1) &
                (log2_size >= min_log2_size) &
                ((allowed_bars[cur_bar]) == 1'b1))
            begin
               sel_bar = cur_bar;
               disable sel_bar_loop ;
            end
            if (is_64b == 1'b1)
            begin
               cur_bar = cur_bar + 2;
            end
            else
            begin
               cur_bar = cur_bar + 1;
            end
         end
         sel_bar = 7 ; // Invalid BAR if we get this far...
      end
   end
endtask

task scr_memory_compare(
   input integer byte_length,     // downstream wr/rd length in byte
   input integer scr_memorya,     //
   input integer scr_memoryb);     //
   integer i;
   reg [7:0] bytea;
   reg [7:0] byteb;
   reg [31:0] addra;
   reg [31:0] addrb;
   reg unused_result ;

   begin

      //unused_result = ebfm_display_verb(EBFM_MSG_INFO, "TASK:scr_memory_compare");
      addra = scr_memorya;
      addrb = scr_memoryb;

      for (i=0;i<byte_length;i=i+1) begin
         bytea=shmem_read(addra,1);
         byteb=shmem_read(addrb,1);
         addra=addra+1;
         addrb=addrb+1;
         if (bytea!=byteb) begin

            unused_result = ebfm_display_verb(EBFM_MSG_INFO, "Content of the RC memory A");
            unused_result =shmem_display(scr_memorya,byte_length,4,scr_memorya+byte_length,EBFM_MSG_INFO);
            unused_result = ebfm_display_verb(EBFM_MSG_INFO, "Content of the RC memory B");
            unused_result =shmem_display(scr_memoryb,byte_length,4,scr_memoryb+byte_length,EBFM_MSG_INFO);

            unused_result = ebfm_display(EBFM_MSG_INFO,
                              {" A: 0x", himage8(addra), ": ",himage8(bytea)});
            unused_result = ebfm_display(EBFM_MSG_INFO,
                              {" B: 0x", himage8(addrb), ": ",himage8(byteb)});
            unused_result = ebfm_display(EBFM_MSG_ERROR_FATAL, {"Different memory content for ",
                                                dimage4(byte_length), " bytes test"});
         end
     end
//    unused_result = ebfm_display_verb(EBFM_MSG_INFO, "Content of the RC memory A");
//    unused_result =shmem_display(scr_memorya,byte_length,4,scr_memorya+byte_length,EBFM_MSG_INFO);
//    unused_result = ebfm_display_verb(EBFM_MSG_INFO, "Content of the RC memory B");
//    unused_result =shmem_display(scr_memoryb,byte_length,4,scr_memoryb+byte_length,EBFM_MSG_INFO);
//
//
//   //  unused_result = ebfm_display_verb(EBFM_MSG_INFO, {"Passed: ",dimage4(byte_length),
//                 //           " same bytes in BFM mem addr 0x", himage8(scr_memorya),
//                 //           " and 0x", himage8(scr_memoryb)});
         unused_result = ebfm_display(EBFM_MSG_INFO, {"Passed: ",dimage6(byte_length),
                                     " same bytes in BFM mem addr 0x", himage8(scr_memorya),
                                     " and 0x", himage8(scr_memoryb)});



   end
endtask
/////////////////////////////////////////////////////////////////////////
//
// TASK:downstream_write
// Prior to run DMA test, this task clears the performance counters
//
task downstream_write(
   input integer bar_table,          // Pointer to the BAR sizing and
   input integer setup_bar,          // Pointer to the BAR sizing and
   input integer address,            // Downstream EP memeory address in byte
   input [63:0] data,
   input integer byte_length);      // BAR to be used for setting up
   reg unused_result;
   reg ret_nill;

   begin
      // Write a data
      shmem_fill(SCR_MEM_DOWNSTREAM_WR,SHMEM_FILL_QWORD_INC,byte_length,data);
      ebfm_barwr(bar_table,setup_bar,address,SCR_MEM_DOWNSTREAM_WR,byte_length,0);
   end

endtask

/////////////////////////////////////////////////////////////////////////
//
// TASK:downstream_read
// Prior to run DMA test, this task clears the performance counters
//
task downstream_read(
   input integer bar_table,          // Pointer to the BAR sizing and
   input integer setup_bar,          // Pointer to the BAR sizing and
   input integer address,            // Downstream EP memeory address in byte
   input integer byte_length);      // BAR to be used for setting up
   reg unused_result;
   reg ret_nill;
   begin
      // read a data
      shmem_fill(SCR_MEM_DOWNSTREAM_RD,SHMEM_FILL_QWORD_INC,byte_length,64'hFADE_FADE_FADE_FADE);
      ebfm_barrd_wait(bar_table,setup_bar,address,SCR_MEM_DOWNSTREAM_RD,byte_length,0);
   end
endtask


task downstream_loop(
   input integer bar_table,       // Pointer to the BAR sizing and
   input integer setup_bar,       // Pointer to the BAR sizing and
   input  integer loop,           // Number of Write/read iteration
   input integer byte_length,     // downstream wr/rd length in byte
   input integer epmem_address,   // Downstream EP memory address in byte
   input  [63:0] start_val);      // Starting write data value

   reg ret_nill;
   reg [63:0] Istart_val;
   reg [31:0] Iepmem_address;
   integer i;
   reg [31:0] Ibyte_length;

   reg [31:0] cfg_reg ;
   reg [31:0] cfg_maxpload_byte ;
   reg [7:0] avalon_waddr ;
   reg [31:0] avalon_waddr_qw_max;
   reg [31:0] avalon_waddr_qw_min;
   reg [31:0] cfg_dw1 ;
   reg unused_result;


   begin

      unused_result = ebfm_display(EBFM_MSG_INFO, `STR_SEP);

      unused_result = ebfm_display(EBFM_MSG_INFO, "TASK:downstream_loop ");

      cfg_maxpload_byte = 0;
      // Retrieve Device cfg from RC Slave
      // Set EP MWr mode

      cfg_reg = 32'h0;

      case (cfg_reg[7:5])
         3'b000 :cfg_maxpload_byte[12:7 ] = 6'b000001;// 128B
         3'b001 :cfg_maxpload_byte[12:7 ] = 6'b000010;// 256B
         3'b010 :cfg_maxpload_byte[12:7 ] = 6'b000100;// 512B
         3'b011 :cfg_maxpload_byte[12:7 ] = 6'b001000;// 1024B
         3'b100 :cfg_maxpload_byte[12:7 ] = 6'b010000;// 2048B
         default:cfg_maxpload_byte[12:7 ] = 6'b100000;// 4096B
      endcase

      Ibyte_length = ((byte_length>cfg_maxpload_byte)||
                                     (byte_length<4))?4:byte_length;
      Istart_val   = start_val;

      for (i=0;i<loop;i=i+1) begin
         //TODO extend to more than 1 DW
         //
         Ibyte_length=4;
         downstream_write( bar_table,
                           setup_bar,
                           epmem_address,
                           Istart_val,
                           Ibyte_length);
         downstream_read ( bar_table,
                           setup_bar,
                           epmem_address,
                           Ibyte_length);
         scr_memory_compare(Ibyte_length,
                            SCR_MEM_DOWNSTREAM_WR,
                            SCR_MEM_DOWNSTREAM_RD);
         Istart_val   = Istart_val+cfg_maxpload_byte;
         Ibyte_length = ((Ibyte_length>cfg_maxpload_byte-4)||
                                     (Ibyte_length<4))?4:Ibyte_length+4;
      end
   end
endtask

task target_mem_test_lite;
      input bar_table;      // Pointer to the BAR sizing and
      integer bar_table;    // address information set up by
                            // the configuration routine
      input tgt_bar;        // BAR to use to access the target
      integer tgt_bar;      // memory
      input start_offset;   // Starting offset in the target
      integer start_offset; // memory to use
      input tgt_data_len;   // Length of data to test
      integer tgt_data_len;

      parameter TGT_WR_DATA_ADDR = 1 * (2 ** 16);
      integer tgt_rd_data_addr;
      integer err_addr;

      reg unused_result ;

      begin  // target_mem_test_lite (single DW)
         unused_result = ebfm_display(EBFM_MSG_INFO, "Starting Target Write/Read Test.");
         unused_result = ebfm_display(EBFM_MSG_INFO, {"  Target BAR = ", dimage1(tgt_bar)});
         unused_result = ebfm_display(EBFM_MSG_INFO, {"  Length = ", dimage6(tgt_data_len), ", Start Offset = ", dimage6(start_offset)});
         // Setup some data to write to the Target
         shmem_fill(TGT_WR_DATA_ADDR, SHMEM_FILL_DWORD_INC, 32, {64{1'b0}});  /// 32 bytes
         // Setup an address for the data to read back from the Target
         tgt_rd_data_addr = TGT_WR_DATA_ADDR + (2 * 32);              // 32-bytes
         // Clear the target data area
         shmem_fill(tgt_rd_data_addr, SHMEM_FILL_ZERO, 32, {64{1'b0}});
         //
         // Now write the data to the target with this BFM call
         //
         ebfm_barwr(bar_table, tgt_bar, start_offset, TGT_WR_DATA_ADDR, 4, 0);
         //
         // Read the data back from the target in one burst, wait for the read to
         // be complete
         //
         ebfm_barrd_wait(bar_table, tgt_bar, start_offset, tgt_rd_data_addr, 4, 0);
         // Check the data
         if (shmem_chk_ok(tgt_rd_data_addr, SHMEM_FILL_DWORD_INC, 4, {64{1'b0}}, 1'b1))
         begin
            unused_result = ebfm_display(EBFM_MSG_INFO, "  Target Write and Read compared okay!");
         end
         else
         begin
            unused_result = ebfm_display(EBFM_MSG_ERROR_FATAL, "  Stopping simulation due to miscompare");
         end
      end
endtask

// purpose: Use Reads and Writes to test the target memory
   //          The starting offset in the target memory and the
   //          length can be specified
   task target_mem_test;
      input bar_table;      // Pointer to the BAR sizing and
      integer bar_table;    // address information set up by
                            // the configuration routine
      input tgt_bar;        // BAR to use to access the target
      integer tgt_bar;      // memory
      input start_offset;   // Starting offset in the target
      integer start_offset; // memory to use
      input tgt_data_len;   // Length of data to test
      integer tgt_data_len;

      parameter TGT_WR_DATA_ADDR = 1 * (2 ** 16);
      integer tgt_rd_data_addr;
      integer err_addr;

      reg unused_result ;

      begin  // target_mem_test
         unused_result = ebfm_display(EBFM_MSG_INFO, "Starting Target Write/Read Test.");
         unused_result = ebfm_display(EBFM_MSG_INFO, {"  Target BAR = ", dimage1(tgt_bar)});
         unused_result = ebfm_display(EBFM_MSG_INFO, {"  Length = ", dimage6(tgt_data_len), ", Start Offset = ", dimage6(start_offset)});
         // Setup some data to write to the Target
         shmem_fill(TGT_WR_DATA_ADDR, SHMEM_FILL_DWORD_INC, tgt_data_len, {64{1'b0}});
         // Setup an address for the data to read back from the Target
         tgt_rd_data_addr = TGT_WR_DATA_ADDR + (2 * tgt_data_len);
         // Clear the target data area
         shmem_fill(tgt_rd_data_addr, SHMEM_FILL_ZERO, tgt_data_len, {64{1'b0}});
         //
         // Now write the data to the target with this BFM call
         //
         ebfm_barwr(bar_table, tgt_bar, start_offset, TGT_WR_DATA_ADDR, tgt_data_len, 0);
         //
         // Read the data back from the target in one burst, wait for the read to
         // be complete
         //
         ebfm_barrd_wait(bar_table, tgt_bar, start_offset, tgt_rd_data_addr, tgt_data_len, 0);
         // Check the data
         if (shmem_chk_ok(tgt_rd_data_addr, SHMEM_FILL_DWORD_INC, tgt_data_len, {64{1'b0}}, 1'b1))
         begin
            unused_result = ebfm_display(EBFM_MSG_INFO, "  Target Write and Read compared okay!");
         end
         else
         begin
            unused_result = ebfm_display(EBFM_MSG_ERROR_FATAL, "  Stopping simulation due to miscompare");
         end
      end
   endtask

// purpose: Use the reference design's DMA engine to move data from the BFM's
   // shared memory to the reference design's master memory and then back
    task dma_mem_test;
      input bar_table;      // Pointer to the BAR sizing and
      integer bar_table;    // address information set up by
                            // the configuration routine
      input setup_bar;      // BAR to be used for setting up
      integer setup_bar;    // the DMA operation and checking
                            // the status
      input start_offset;   // Starting offset in the master
      integer start_offset; // memory
      input dma_data_len;   // Length of DMA operations
      integer dma_data_len;

      parameter SCR_MEM = (2 ** 17) - 4;
      integer dma_rd_data_addr;
      integer dma_wr_data_addr;
      integer err_addr;
      reg [2:0] compl_status;
      reg [2:0]  multi_message_enable;
      reg        msi_enable;
      reg [31:0] msi_capabilities ;
      reg [15:0] msi_data;
      reg [31:0] msi_address;
integer passthru_msk;

      reg dummy ;

      begin
      dummy = ebfm_display(EBFM_MSG_INFO, "Starting DMA Read/Write Test.");
         dummy = ebfm_display(EBFM_MSG_INFO, {"  Setup BAR = ", dimage1(setup_bar)});
         dummy = ebfm_display(EBFM_MSG_INFO, {"  Length = ", dimage6(dma_data_len),
                                      ", Start Offset = ", dimage6(start_offset)});
         dma_rd_data_addr = SCR_MEM + 4 + start_offset;
         // Setup some data for the DMA to read
         shmem_fill(dma_rd_data_addr, SHMEM_FILL_DWORD_INC, dma_data_len, {64{1'b0}});


         // MSI capabilities
          msi_capabilities = 32'h50;
          msi_address = SCR_MEM;
          msi_data = 16'habcd;
          msi_enable = 1'b0;
          multi_message_enable = 3'b000;

         // Program the DMA to Read Data from Shared Memory

      // check the # of passthru bits
         ebfm_barwr_imm(bar_table, setup_bar, CRA_BASE+16'h1000,  32'hffffffff, 4, 0);
         ebfm_barrd_wait(bar_table, setup_bar,CRA_BASE+16'h1000, SCR_MEM, 4, 0); /// read the status reg
       passthru_msk = shmem_read(SCR_MEM,4) & 32'hffff_fffc;

      // Set PCI Express Interrupt enable (bit 0) in the PCIe-Avalon-MM bridge at address Avalon_Base_Address + 0x50
         ebfm_barwr_imm(bar_table, setup_bar, CRA_BASE+16'h0050,  32'h00000001, 4, 0);


      // To program DMA and translation, take the portion of the DMA address that
      // is below passthru bits and program them to DMA. The remaining portion goes
      // to address translation table

      // program address translation table
         ebfm_barwr_imm(bar_table, setup_bar, CRA_BASE+16'h1000,  dma_rd_data_addr & passthru_msk, 4, 0);
         ebfm_barwr_imm(bar_table, setup_bar, CRA_BASE+16'h1004,  32'h00000000, 4, 0);

         ebfm_barwr_imm(bar_table, setup_bar, DMA_BASE+16'h0004,  dma_rd_data_addr & ~passthru_msk, 4, 0);  // reg 1 (read address)
         ebfm_barwr_imm(bar_table, setup_bar, DMA_BASE+16'h0008, MEM_OFFSET, 4, 0);  // reg 2 (write address)
         ebfm_barwr_imm(bar_table, setup_bar, DMA_BASE+16'h000C, dma_data_len, 4, 0);  // reg 3 (dma length)

         if (APPS_TYPE_HWTCL==4) begin    // avmm-64bit
             ebfm_barwr_imm(bar_table, setup_bar, DMA_BASE+16'h0018, 32'h00000498, 4, 0); //  reg 6 (control)
         end
         else begin   // avmm-128bit
             ebfm_barwr_imm(bar_table, setup_bar, DMA_BASE+16'h0018, 32'h00000898, 4, 0); //  reg 6 (control)
         end

          #10
         wait(INTA);
         // check for INTA deassertion

         dummy = ebfm_display(EBFM_MSG_INFO, "Clear Interrupt INTA ");
         ebfm_barwr_imm(bar_table, setup_bar, DMA_BASE+16'h0000,  32'h00000000, 4, 0);  // clear done bit in status reg

         #10
         wait(!INTA);

         //enable MSI enable
         msi_enable = 1'b1;
         ebfm_cfgwr_imm_wait(1, 0, 0, msi_capabilities, 4, {8'h00, 1'b0, multi_message_enable, 3'b000, msi_enable, 16'h0000}, compl_status);
         ebfm_cfgwr_imm_wait(1, 0, 0, msi_capabilities + 4'h4, 4, msi_address, compl_status);
         ebfm_cfgwr_imm_wait(1, 0, 0, msi_capabilities + 4'hC, 4, msi_data,    compl_status);

         // Setup an area for DMA to write back to
         // Currently DMA Engine Uses lower address bits for it's MRAM and PCIE
         // Addresses. So use the same address we started with
         dma_wr_data_addr = dma_rd_data_addr;
         shmem_fill(dma_wr_data_addr, SHMEM_FILL_ZERO, dma_data_len, {64{1'b0}});

         // Program the DMA to Write Data Back to Shared Memory
         ebfm_barwr_imm(bar_table, setup_bar, DMA_BASE+16'h0004, MEM_OFFSET , 4, 0);  // reg 1 (read address)
         ebfm_barwr_imm(bar_table, setup_bar, DMA_BASE+16'h0008, dma_wr_data_addr & ~passthru_msk, 4, 0);  // reg 2 (write address)
         ebfm_barwr_imm(bar_table, setup_bar, DMA_BASE+16'h000c, dma_data_len, 4, 0);  // reg 3 (dma length)

         if (APPS_TYPE_HWTCL==4) begin    // avmm-64bit
             ebfm_barwr_imm(bar_table, setup_bar, DMA_BASE+16'h0018, 32'h00000498, 4, 0); //  reg 6 (control)
         end
         else begin   // avmm-128bit
             ebfm_barwr_imm(bar_table, setup_bar, DMA_BASE+16'h0018, 32'h00000898, 4, 0); //  reg 6 (control)
         end

          // Wait Until the DMA is done via MSI
         dma_wait_done(bar_table, setup_bar, SCR_MEM);

         // Check the data
         if (shmem_chk_ok(dma_rd_data_addr, SHMEM_FILL_DWORD_INC, dma_data_len, {64{1'b0}}, 1'b1))
         begin
            dummy = ebfm_display(EBFM_MSG_INFO, "  DMA Read and Write compared okay!");
         end
         else
         begin
            dummy = ebfm_display(EBFM_MSG_ERROR_FATAL, "  Stopping simulation due to miscompare");
         end

      end
endtask

 // purpose: This procedure polls the DMA engine until it is done
  task dma_wait_done;
      input bar_table;
      integer bar_table;
      input setup_bar;
      integer setup_bar;
      input msi_mem;
      integer msi_mem;


      reg [31:0] dma_sts ;
      reg unused_result;
      begin
         // dma_wait_done
         shmem_fill(msi_mem, SHMEM_FILL_ZERO, 4, {64{1'b0}});
         dma_sts = 32'h00000000 ;
         while (dma_sts != 32'h0000abcd)
         begin
            #10
            dma_sts = shmem_read(msi_mem,4) ;
         end

         unused_result = ebfm_display(EBFM_MSG_INFO, "MSI recieved!");
      end

   endtask

`include "avmmdma_rdwr_test.sv"


///////////////////////////////////////////////////////////////////////////////
//
//
// Main Program
//
// Start of the test bench driver altpcietb_bfm_driver
//
   reg activity_toggle;
   reg timer_toggle ;
   time time_stamp ;
   localparam TIMEOUT = 2000000000;

   initial
     begin
        time_stamp = $time ;
        activity_toggle = 1'b0;
        timer_toggle    = 1'b0;
   end

   // behavioral
   always
   begin : main
   // If you want to relocate the bar_table, modify the BAR_TABLE_POINTER in altpcietb_bfm_shmem.
      // Directly modifying the bar_table at this location may disable overwrite protection for the bar_table
      // If the bar_table is overwritten incorrectly, this will break the testbench functionality.
      parameter bar_table = BAR_TABLE_POINTER; // Default BAR_TABLE_SIZE is 64 bytes
      integer tgt_bar;
      integer dma_bar, rc_slave_bar;
      reg     addr_map_4GB_limit;
      reg     unused_result ;
      reg [15:0] msi_control_register;
      integer i;


      // This constant defines where we save the sizes and programmed addresses
      // of the Endpoint Device Under Test BARs
      // tgt_bar indicates which bar to use for testing the target memory of the
      // reference design.

      // Setup the Root Port and Endpoint Configuration Spaces
      addr_map_4GB_limit = 1'b0;
`ifdef IPD_DEBUG
      ebfm_display(EBFM_MSG_INFO, "-->CHECKPOINT1");
`endif
      unused_result = ebfm_display_verb(EBFM_MSG_WARNING,
           "----> Starting ebfm_cfg_rp_ep_rootport task 0");
`ifdef IPD_DEBUG
      ebfm_display(EBFM_MSG_INFO, "-->CHECKPOINT2");
`endif

      ebfm_cfg_rp_ep_rootport(
                              bar_table,         // BAR Size/Address info for Endpoint
                              1,                 // Bus Number for Endpoint Under Test
                              1,                 // Device Number for Endpoint Under Test
                              0,                 // This argument doesn't matter...
                              1,                 // Display EP Config Space after setup
                              0,                 // Display RP Config Space after setup
                              addr_map_4GB_limit // Limit the BAR assignments to 4GB address map
                              );

`ifdef IPD_DEBUG
         ebfm_display(EBFM_MSG_INFO, "-->CHECKPOINT200");
`endif


         activity_toggle <= ~activity_toggle ;

         if ( (APPS_TYPE_HWTCL==3) && (SKIP_LINK==0) ) begin

            //Downstream
            find_mem_bar(bar_table, 6'b111111, 8, rc_slave_bar);

            downstream_loop(
                            bar_table,               // Pointer to the BAR sizing and
                            rc_slave_bar,            // Pointer to the BAR sizing and
                            RCSLAVE_MAXLEN,          // Number of Write/read iteration
                            4,                       // downstream wr/rd length in byte
                            0,                       // Downstream EP memory address in byte
                            // (need to be qword aligned)
                            64'hBABA_0000_BEBE_0000);// Starting write data value

            unused_result = ebfm_log_stop_sim(1);

            forever #100000;
         end

         else if ( ((APPS_TYPE_HWTCL==4) || (APPS_TYPE_HWTCL==5))  && (SKIP_LINK==0) )  begin
            // Avalon-MM Driver

            // Find a memory BAR to use to test the target memory
            // The reference design implements the target memory on BARs 0,1, 4 or 5
            // We need one at least 4 KB big
            if(AVALON_MM_LITE == 0)
              find_mem_bar(bar_table, 6'b110011, 12, tgt_bar);
            else
              find_mem_bar(bar_table, 6'b110011, 4, tgt_bar);
            // Test the reference design's target memory

            if(AVALON_MM_LITE == 0)
              begin
                 if (RUN_TGT_MEM_TST == 0)
                   begin
                      unused_result = ebfm_display(EBFM_MSG_WARNING, "Skipping target test.");
                   end
                 else if (tgt_bar < 6)
                   begin

                      target_mem_test(
                                      bar_table, // BAR Size/Address info for Endpoint
                                      tgt_bar,   // BAR to access target memory with
                                      32'h0000,         // Starting offset from BAR
                                      512       // Length of memory to test
                                      );
                   end
                 else
                   begin
                      unused_result = ebfm_display(EBFM_MSG_WARNING, "Unable to find a 4 KB BAR to test Target Memory, skipping target test.");
                   end
              end

            else  // is avalon lite
              begin
                 if (RUN_TGT_MEM_TST == 0)
                   begin
                      unused_result = ebfm_display(EBFM_MSG_WARNING, "Skipping target test.");
                   end
                 else
                   begin
                      for(i=0; i < 4 ; i=i+1)
                        begin
                           target_mem_test_lite(
                                                bar_table, // BAR Size/Address info for Endpoint
                                                tgt_bar,   // BAR to access target memory with
                                                i*4,         // Starting offset from BAR
                                                4       // Length of memory to test
                                                );
                        end
                   end
              end

            activity_toggle <= ~activity_toggle ;
            // Find a memory BAR to use to setup the DMA channel
            // The reference design implements the DMA channel registers on BAR 2 or 3
            // We need one at least 0x7FFF (CRA 0x4000 + DMA 0x8)
            find_mem_bar(bar_table, 6'b001100, 15, dma_bar);
            // Test the reference design's DMA channel and master memory
            if (RUN_DMA_MEM_TST == 0)
              begin
                 unused_result = ebfm_display(EBFM_MSG_WARNING, "Skipping DMA test.");
              end
            else if (dma_bar < 6)
              begin
                 dma_mem_test(
                              bar_table, // BAR Size/Address info for Endpoint
                              dma_bar,   // BAR to access DMA control registers
                              0,         // Starting offset of DMA memory
                              512       // Length of memory to test
                              );

              end
            else
              begin
                 unused_result = ebfm_display(EBFM_MSG_WARNING, "Unable to find a 128B BAR to test setup DMA channel, skipping DMA test.");
              end

            // Stop the simulator and indicate successful completion
            unused_result = ebfm_log_stop_sim(1);
            forever #100000;
         end
         else if (APPS_TYPE_HWTCL==6)  begin

            avmmdma_rdwr_test(bar_table);

            unused_result = ebfm_log_stop_sim(1);
            forever #100000;
         end
         else if (SKIP_LINK==0) begin

            //Chaining DMA
            // Find a memory BAR to use to setup the DMA channel
            // The reference design implements the DMA channel registers on BAR 2 or 3
            // We need one at least 128 B big
            find_mem_bar(bar_table, 6'b001100, 8, dma_bar);

            // Test the chained DMA example design
            if ((dma_bar < 6) && (USE_CDMA>0)) begin
               chained_dma_test(bar_table, dma_bar,0,0,1);  // Read  DMA EPLAST
               time_stamp = $time ;
               chained_dma_test(bar_table, dma_bar,1,0,1);  // Write DMA EPLAST
               time_stamp = $time ;
               chained_dma_test(bar_table, dma_bar,0,1,0);  // Read  DMA EPLAST
               time_stamp = $time ;
               chained_dma_test(bar_table, dma_bar,1,1,0);  // Write DMA EPLAST
            end
            else if (USE_CDMA>0)
              unused_result = ebfm_display_verb(EBFM_MSG_WARNING,
                                                "Unable to find a 256B BAR to setup the chaining DMA DUT; skipping test.");
            // Stop the simulator and indicate successful completion


            unused_result = ebfm_log_stop_sim(1);
            forever #100000;
         end

   end

   always
     begin
        #(TIMEOUT)
          timer_toggle <= ! timer_toggle ;
     end

   // purpose: this is a watchdog timer, if it sees no activity on the activity
   // toggle signal for 200 us it ends the simulation
   always @(activity_toggle or timer_toggle)
     begin : watchdog
        reg unused_result ;

        if ( ($time - time_stamp) >= TIMEOUT)
          begin
             unused_result = ebfm_display(EBFM_MSG_ERROR_FATAL, "Simulation stopped due to inactivity!");
          end
        time_stamp <= $time ;
     end

endmodule
