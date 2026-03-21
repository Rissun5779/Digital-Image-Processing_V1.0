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


// (C) 2001-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions, and any output
// files any of the foregoing (including device programming or simulation
// files), and any associated documentation or information are expressly subject
// to the terms and conditions of the Altera Program License Subscription
// Agreement, Altera MegaCore Function License Agreement, or other applicable
// license agreement, including, without limitation, that your use is for the
// sole purpose of programming logic devices manufactured by Altera and sold by
// Altera or its authorized distributors.  Please refer to the applicable
// agreement for further details.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
`default_nettype none
//import tlp_converter_pkg::*;

module altpcie_ast_translator # (
   parameter DEVICE_FAMILY                                          = "Stratix V"      ,
   parameter                                   dma_use_scfifo_ext   = 0                                ,          //rd=0, wr=2                          //???
   parameter                                   SRIOV_EN             = 0                                ,
   parameter                                   ARI_EN               = 0                                ,
   parameter                                   PHASE1               = 1                                ,          // Indicate phase1 of SR-IOV          //obsolete
   parameter                                   VF_COUNT             = 32                               ,          // Max Number of Virtual Functions    //need PF/VF counts
   parameter                                   DMA_WIDTH            = 256                              ,                                                //???
   parameter                                   TX_FIFO_WIDTH        = (DMA_WIDTH == 256) ? 260 : 131   ,//Data+Sop+Eop+Empty  //???
   parameter                                   NUM_TAG              = 16                               ,        //256?
   parameter                                   NUM_TAG_WIDTH        = 4                                ,
   parameter                                   NUM_DESC             = 16                               ,        //256?
   parameter                                   NUM_DESC_WIDTH       = 4                                ,
   parameter                                   RXFIFO_DATA_WIDTH    = (SRIOV_EN == 1) ? 274 : 266      ,        //???
//
   parameter                                   TXDATA_WIDTH         = 256                              ,
   parameter                                   TXDESC_WIDTH         = 256                              ,
   parameter                                   TXSTATUS_WIDTH       = 32                               ,
   parameter                                   RXDATA_WIDTH         = 256                              ,
   parameter                                   RXDESC_WIDTH         = 256                              ,
   //derived parameters
   parameter                                   TXMTY_WIDTH          = 32                               ,
   parameter                                   RXMTY_WIDTH          = 32
)(
   input wire                                  Clk_i                ,
   input wire                                  Rstn_i               ,

   //User Streaming Interface
   // PCIe TxData Interface (WrRsp/RdReq)
   output logic                                TxData_rdy_o         ,
   input  wire                                 TxData_val_i         ,
   input  wire                                 TxData_sop_i         ,
   input  wire                                 TxData_eop_i         ,
   input  wire                                 TxData_err_i         ,
   input  wire              [TXDATA_WIDTH-1:0] TxData_dat_i         ,
   input  wire               [TXMTY_WIDTH-1:0] TxData_sty_i         ,
   input  wire               [TXMTY_WIDTH-1:0] TxData_mty_i         ,
   input  wire              [TXDESC_WIDTH-1:0] TxData_dsc_i         ,

   // PCIe TxStatus Interface (TxStatus)                            ,
   output logic                                TxStatus_val_o       ,
   output logic           [TXSTATUS_WIDTH-1:0] TxStatus_dat_o       ,

   // PCIe RxData Interface (RdRsp)                                 ,
   input  wire                                 RxData_rdy_i         ,
   output logic                                RxData_val_o         ,
   output logic                                RxData_sop_o         ,
   output logic                                RxData_eop_o         ,
   output logic                                RxData_err_o         ,
   output logic             [RXDATA_WIDTH-1:0] RxData_dat_o         ,
   output logic              [RXMTY_WIDTH-1:0] RxData_sty_o         ,
   output logic              [RXMTY_WIDTH-1:0] RxData_mty_o         ,
   output logic             [RXDESC_WIDTH-1:0] RxData_dsc_o         ,



   // Rx fifo Interface                                             ,
   output logic                                RxFifoRdReq_o        ,
   input  wire        [RXFIFO_DATA_WIDTH-1:0]  RxFifoDataq_i        ,
   input  wire                          [3:0]  RxFifoCount_i        ,

   // Tag predecode                                                 ,
   output logic                                PreDecodeTagRdReq_o  ,
   input  wire                           [7:0] PreDecodeTag_i       ,
   input  wire             [NUM_TAG_WIDTH-1:0] PreDecodeTagCount_i  ,

   // Tx fifo Interface                                             ,
   output logic                                TxFifoWrReq_o        ,
   output logic            [TX_FIFO_WIDTH-1:0] TxFifoData_o         ,
   input  wire                           [3:0] TxFifoCount_i        ,

   // General CRA interface                                         ,
   input  wire                                 RdDMACntrlLoad_i     ,
   input  wire                          [31:0] RdDMACntrlData_i     ,
   output logic                         [31:0] RdDMAStatus_o        ,

   input  wire                                 WrDMACntrlLoad_i     ,     //I doubt we need 2 of these
   input  wire                          [31:0] WrDMACntrlData_i     ,
   output logic                         [31:0] WrDMAStatus_o        ,

   // Arbiter Interface
   output logic                                RdDMmaArbReq_o      ,
   input  wire                                 RdDMmaArbGranted_i  ,

   output logic                                WrDmaLPArbReq_o     ,
   output logic                                WrDmaHPArbReq_o     ,
   input  wire                                 WrDmaLPArbReq_i     ,
   input  wire                                 WrDmaHPArbReq_i     ,
   input  wire                                 WrDmaArbGranted_i   ,

   //                                                              ,
   input  wire                          [15:0] BusDev_i            ,//was rd:[12:0], wr:[15:0]
   input  wire                          [31:0] DevCsr_i            ,
   input  wire                                 MasterEnable        ,
   input  wire                                 MasterEnable_i      ,// PF Master Enable
   input  wire                  [VF_COUNT-1:0] vf_MasterEnable_i   ,// SR-IOV VF Master Enable

   // rx completion space
   input  wire                           [7:0] ko_cpl_spc_header   ,
   input  wire                          [11:0] ko_cpl_spc_data
);

typedef struct packed {
    logic       [63:0] rsvd192;                 //[255:192]
    //
    logic       [15:0] rsvd176;                 //[191:176]
    logic        [7:0] steering_tag1;           //[175:168]
    logic        [7:0] steering_tag0;           //[167:160]

    logic        [2:0] fmt;                     //[159:157]
    logic        [4:0] tlp_type;                //[156:152]
    logic              rsvd151;                 //[151]
    logic        [2:0] tc;                      //[150:148]
    logic              rsvd147;                 //[147]
    logic              attr_2;                  //[146]
    logic              rsvd145;                 //[145]
    logic              th;                      //[144]               //tlp processing hint
    logic              td;                      //[143]               //tlp_digest
    logic              ep;                      //[142]               //tlp_poisoned
    logic        [1:0] attr_1_0;                //[141:140]
    logic        [1:0] at;                      //[139:138]           //address type
    logic        [7:0] rsvd130;                 //[137:130]
    logic        [1:0] ph;                      //[129:128]
    //
    logic       [63:0] pcie_addr;               //[127:64]
    //
    logic       [15:0] vf;                      //[63:48]             //rid ?  {bus,func}?
    logic        [3:0] pf;                      //[47:44]
    logic        [1:0] pf_vf_mode;              //[43:42]
    logic        [1:0] rsvd40;                  //[41:40]
    logic       [23:0] length;                  //[39:16]             //bytes
    logic        [7:0] tag;                     //[15:8]
    logic        [7:0] desc_type;               //[7:0]
} type_desc;


type_desc TxData_dsc;
type_desc RxData_dsc;
assign TxData_dsc   = type_desc'(TxData_dsc_i);
assign RxData_dsc_o = RxData_dsc;

endmodule
`default_nettype wire
