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


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module altera_pcie_s10_dma_controller_hwtcl #(
      parameter                                    DMA_WIDTH          = 256
  ) (
      input logic                                  Clk_i,
      input logic                                  Rstn_i,

      input logic   [81:0]                         MsiInterface_i,

//// DMA Read Interface
      // AVMM Register Slave Port (Write only)
      input  logic                                  RdDCSChipSelect_i,
      input  logic                                  RdDCSWrite_i,
      input  logic                                  RdDCSRead_i,
      input  logic  [7:0]                           RdDCSAddress_i,
      input  logic  [31:0]                          RdDCSWriteData_i,
      output  logic [31:0]                          RdDCSReadData_o,
      input  logic  [3:0]                           RdDCSByteEnable_i,
      output logic                                  RdDCSWaitRequest_o,


            // AVMM Register Master Port (Write only)

      output   logic [63:0]                         RdDCMAddress_o,
      output                                        RdDCMWrite_o,
      output   logic [31:0]                         RdDCMWriteData_o,
      output                                        RdDCMRead_o,
      output   logic [3:0]                          RdDCMByteEnable_o,
      input    logic                                RdDCMWaitRequest_i,
      input    logic [31:0]                         RdDCMReadData_i,
      input    logic                                RdDCMReadDataValid_i,

      /// DT 256-bit slave interface (Write only)

      input  logic                                  RdDTSChipSelect_i,
      input  logic                                  RdDTSWrite_i,
      input  logic  [4:0]                           RdDTSBurstCount_i,
      input  logic  [7:0]                           RdDTSAddress_i,
      input  logic  [255:0]                         RdDTSWriteData_i,
      output logic                                  RdDTSWaitRequest_o,

      /// DMA programming interface
      output   logic  [159:0]                       RdDmaTxData_o,
      output   logic                                RdDmaTxValid_o,
      input    logic                                RdDmaTxReady_i,

     // DMA Status Interface
      input   logic  [31:0]                         RdDmaRxData_i,
      input   logic                                 RdDmaRxValid_i,

////                DMA Write Interface              ///////////////////////////
 //////////      // AVMM Register Slave Port (Write only)   /////////////////////
      input  logic                                  WrDCSChipSelect_i,
      input  logic                                  WrDCSWrite_i,
      input  logic                                  WrDCSRead_i,
      input  logic  [7:0]                           WrDCSAddress_i,
      input  logic  [31:0]                          WrDCSWriteData_i,
      output logic  [31:0]                          WrDCSReadData_o,
      input  logic  [3:0]                           WrDCSByteEnable_i,
      output logic                                  WrDCSWaitRequest_o,


            // AVMM Register Master Port (Write only)

      output   logic [63:0]                         WrDCMAddress_o,
      output                                        WrDCMWrite_o,
      output   logic [31:0]                         WrDCMWriteData_o,
      output                                        WrDCMRead_o,
      output   logic [3:0]                          WrDCMByteEnable_o,
      input    logic                                WrDCMWaitRequest_i,
      input    logic [31:0]                         WrDCMReadData_i,
      input    logic                                WrDCMReadDataValid_i,

      /// DT 256-bit slave interface (Write only)

      input  logic                                  WrDTSChipSelect_i,
      input  logic                                  WrDTSWrite_i,
      input  logic  [4:0]                           WrDTSBurstCount_i,
      input  logic  [7:0]                           WrDTSAddress_i,
      input  logic  [255:0]                         WrDTSWriteData_i,
      output logic                                  WrDTSWaitRequest_o,

      /// DMA programming interface
      output   logic  [159:0]                       WrDmaTxData_o,
      output   logic                                WrDmaTxValid_o,
      input    logic                                WrDmaTxReady_i,

     // DMA Status Interface
      input   logic  [31:0]                         WrDmaRxData_i,
      input   logic                                 WrDmaRxValid_i
);

//// Instantiate Top Level

altera_pcie_s10_dma_controller #(
      .DMA_WIDTH         ( DMA_WIDTH )
  ) 
  DMACONT_TOP(
               .Clk_i                          (Clk_i                     ),
               .Rstn_i                         (Rstn_i                    ),
               .MsiInterface_i                 (MsiInterface_i            ),
               .RdDCSChipSelect_i              (RdDCSChipSelect_i         ),
               .RdDCSWrite_i                   (RdDCSWrite_i              ),
               .RdDCSRead_i                    (RdDCSRead_i               ),
               .RdDCSAddress_i                 (RdDCSAddress_i            ),
               .RdDCSWriteData_i               (RdDCSWriteData_i          ),
               .RdDCSReadData_o                (RdDCSReadData_o           ),
               .RdDCSByteEnable_i              (RdDCSByteEnable_i         ),
               .RdDCSWaitRequest_o             (RdDCSWaitRequest_o        ),
               .RdDCMAddress_o                 (RdDCMAddress_o            ),
               .RdDCMWrite_o                   (RdDCMWrite_o              ),
               .RdDCMWriteData_o               (RdDCMWriteData_o          ),
               .RdDCMRead_o                    (RdDCMRead_o               ),
               .RdDCMByteEnable_o              (RdDCMByteEnable_o         ),
               .RdDCMWaitRequest_i             (RdDCMWaitRequest_i        ),
               .RdDCMReadData_i                (RdDCMReadData_i           ),
               .RdDCMReadDataValid_i           (RdDCMReadDataValid_i      ),
               .RdDTSChipSelect_i              (RdDTSChipSelect_i         ),
               .RdDTSWrite_i                   (RdDTSWrite_i              ),
               .RdDTSBurstCount_i              (RdDTSBurstCount_i         ),
               .RdDTSAddress_i                 (RdDTSAddress_i            ),
               .RdDTSWriteData_i               (RdDTSWriteData_i          ),
               .RdDTSWaitRequest_o             (RdDTSWaitRequest_o        ),
               .RdDmaTxData_o                  (RdDmaTxData_o             ),
               .RdDmaTxValid_o                 (RdDmaTxValid_o            ),
               .RdDmaTxReady_i                 (RdDmaTxReady_i            ),
               .RdDmaRxData_i                  (RdDmaRxData_i             ),
               .RdDmaRxValid_i                 (RdDmaRxValid_i            ),
               .WrDCSChipSelect_i              (WrDCSChipSelect_i         ),
               .WrDCSWrite_i                   (WrDCSWrite_i              ),
               .WrDCSRead_i                    (WrDCSRead_i               ),
               .WrDCSAddress_i                 (WrDCSAddress_i            ),
               .WrDCSWriteData_i               (WrDCSWriteData_i          ),
               .WrDCSReadData_o                (WrDCSReadData_o           ),
               .WrDCSByteEnable_i              (WrDCSByteEnable_i         ),
               .WrDCSWaitRequest_o             (WrDCSWaitRequest_o        ),
               .WrDCMAddress_o                 (WrDCMAddress_o            ),
               .WrDCMWrite_o                   (WrDCMWrite_o              ),
               .WrDCMWriteData_o               (WrDCMWriteData_o          ),
               .WrDCMRead_o                    (WrDCMRead_o               ),
               .WrDCMByteEnable_o              (WrDCMByteEnable_o         ),
               .WrDCMWaitRequest_i             (WrDCMWaitRequest_i        ),
               .WrDCMReadData_i                (WrDCMReadData_i           ),
               .WrDCMReadDataValid_i           (WrDCMReadDataValid_i      ),
               .WrDTSChipSelect_i              (WrDTSChipSelect_i         ),
               .WrDTSWrite_i                   (WrDTSWrite_i              ),
               .WrDTSBurstCount_i              (WrDTSBurstCount_i         ),
               .WrDTSAddress_i                 (WrDTSAddress_i            ),
               .WrDTSWriteData_i               (WrDTSWriteData_i          ),
               .WrDTSWaitRequest_o             (WrDTSWaitRequest_o        ),
               .WrDmaTxData_o                  (WrDmaTxData_o             ),
               .WrDmaTxValid_o                 (WrDmaTxValid_o            ),
               .WrDmaTxReady_i                 (WrDmaTxReady_i            ),
               .WrDmaRxData_i                  (WrDmaRxData_i             ),
               .WrDmaRxValid_i                 (WrDmaRxValid_i            )
      
);


endmodule


