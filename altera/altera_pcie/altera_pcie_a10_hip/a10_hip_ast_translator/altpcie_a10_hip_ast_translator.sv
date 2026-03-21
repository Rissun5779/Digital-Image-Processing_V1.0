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

module altpcie_a10_hip_ast_translator
#(
   //----------------------------------------------------
   //------------- TOP LEVEL PARAMETERS -----------------
   //----------------------------------------------------
   parameter DEVICE_FAMILY               = "Arria 10",
   parameter DMA_WIDTH                   = 256,
   parameter ENABLE_HPRXM                = 0,
   parameter DMA_BE_WIDTH                = 32,
   parameter DMA_BRST_CNT_W              = 6,
   parameter RDDMA_AVL_ADDR_WIDTH        = 64,
   parameter WRDMA_AVL_ADDR_WIDTH        = 64,
   parameter TX_S_ADDR_WIDTH             = 31,
   parameter enable_rxm_burst_hwtcl      = 0,
   parameter enable_cra_hwtcl            = 1,
   parameter dma_use_scfifo_ext          = 0,

   parameter BAR0_SIZE_MASK              = 10,
   parameter BAR1_SIZE_MASK              = 1,
   parameter BAR2_SIZE_MASK              = 1,
   parameter BAR3_SIZE_MASK              = 1,
   parameter BAR4_SIZE_MASK              = 1,
   parameter BAR5_SIZE_MASK              = 1,
   parameter BAR0_TYPE                   = 64,
   parameter BAR1_TYPE                   = 1,
   parameter BAR2_TYPE                   = 32,
   parameter BAR3_TYPE                   = 32,
   parameter BAR4_TYPE                   = 32,
   parameter BAR5_TYPE                   = 32,
   parameter NUM_TAG                     = 16,

   // Translator Parameters
   parameter NUM_DESC                    = 16,
   parameter TXDATA_WIDTH                = 256,
   parameter TXDESC_WIDTH                = 256,
   parameter TXSTATUS_WIDTH              = 256,
   parameter RXDATA_WIDTH                = 256,
   parameter RXDESC_WIDTH                = 256,
   parameter TXMTY_WIDTH                 = 4,
   parameter RXMTY_WIDTH                 = 4,

   // SRIOV
   parameter SRIOV_EN                    = 0,
   parameter ARI_EN                      = 0,
   parameter PHASE1                      = 0,  // Indicate phase1 of SR-IOV
   parameter ACTIVE_VFS                  = 1,  // prepresent the total number of active VFs: 0 = No VF, 1=2VFs, 2=4VFs, 3=8VFs, 4=16VFs..
   parameter VF_COUNT                    = 32, // Number of Virtual Functions
   parameter PF_BAR0_PRESENT             = 1,  // 0 = not present, 1 = present
   parameter PF_BAR1_PRESENT             = 0,  // 0 = not present, 1 = present
   parameter PF_BAR2_PRESENT             = 0,  // 0 = not present, 1 = present
   parameter PF_BAR3_PRESENT             = 0,  // 0 = not present, 1 = present
   parameter PF_BAR4_PRESENT             = 0,  // 0 = not present, 1 = present
   parameter PF_BAR5_PRESENT             = 0,  // 0 = not present, 1 = present
   parameter VF_BAR0_PRESENT             = 0,  // 0 = not present, 1 = present
   parameter VF_BAR1_PRESENT             = 0,  // 0 = not present, 1 = present
   parameter VF_BAR2_PRESENT             = 0,  // 0 = not present, 1 = present
   parameter VF_BAR3_PRESENT             = 0,  // 0 = not present, 1 = present
   parameter VF_BAR4_PRESENT             = 0,  // 0 = not present, 1 = present
   parameter VF_BAR5_PRESENT             = 0,  // 0 = not present, 1 = present
   parameter VF_BAR0_TYPE                = 64,
   parameter VF_BAR1_TYPE                = 1,
   parameter VF_BAR2_TYPE                = 32,
   parameter VF_BAR3_TYPE                = 32,
   parameter VF_BAR4_TYPE                = 32,
   parameter VF_BAR5_TYPE                = 32,
   parameter VF_BAR0_SIZE                = 12, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 31 = 2G
   parameter VF_BAR1_SIZE                = 12, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 31 = 2G
   parameter VF_BAR2_SIZE                = 12, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 31 = 2G
   parameter VF_BAR3_SIZE                = 12, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 31 = 2G
   parameter VF_BAR4_SIZE                = 12, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 31 = 2G
   parameter VF_BAR5_SIZE                = 12,  // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 31 = 2G
   parameter RXFIFO_DATA_WIDTH           = (SRIOV_EN == 1) ? 274 : 266
)


(

/// System Clock and Reset
   input  logic                               Clk_i,
   input  logic    [9:0]                      Rstn_i,

// HIP Interface
   // Rx port interface to PCI Exp HIP
   output logic                               HipRxStReady_o,
   output logic                               HipRxStMask_o,
   input  logic  [DMA_WIDTH-1:0]              HipRxStData_i,
   input  logic  [DMA_BE_WIDTH-1:0]           HipRxStBe_i,
   input  logic  [1:0]                        HipRxStEmpty_i,
   input  logic                               HipRxStErr_i,
   input  logic                               HipRxStSop_i,
   input  logic                               HipRxStEop_i,
   input  logic                               HipRxStValid_i,
   input  logic  [7:0]                        HipRxStBarDec1_i,
   // Tx application interface
   input   logic                              HipTxStReady_i  ,
   output  logic  [DMA_WIDTH-1:0]             HipTxStData_o   ,
   output  logic                              HipTxStSop_o    ,
   output  logic                              HipTxStEop_o    ,
   output  logic  [1:0]                       HipTxStEmpty_o  ,
   output  logic                              HipTxStValid_o  ,
   output  logic                              HipCplPending_o,

   //==========================
   // SR-IOV Cfg_Status Interface
   //==========================
   input  logic  [7:0]                        rx_st_bar_hit_fn_tlp0_i, // SR-IOV=> Target Function for first TLP associated with HipRxStBarDec1_i bar
   input  logic [7:0]                         bus_num_f0_i,       // Captured bus number for PF0
   input  logic [4:0]                         device_num_f0_i,    // Captured device number for PF0
   input  logic                               mem_space_en_pf_i,  // Memory Space Enable for PF0
   input  logic                               bus_master_en_pf_i, // Bus Master Enable for PF 0
   input  logic                               mem_space_en_vf_i,  // Memory Space Enable for VFs (common for all VFs)
   input  logic [VF_COUNT-1:0]                bus_master_en_vf_i, // Bus Master Enable for VFs
   input  logic [7:0]                         num_vfs_i,          // Number of enabled VFs
   input  logic [2:0]                         max_payload_size_i, // Max payload size from Device Control Register of PF 0
   input  logic [2:0]                         rd_req_size_i,      // Read Request Size from Device Control Register of PF 0

 // RXM Master Port, one for each BAR
      // Avalon Rx Master interface 0
  output logic                                 AvRxmWrite_0_o,
  output logic [BAR0_TYPE-1:0]                 AvRxmAddress_0_o,
  output logic [31:0]                          AvRxmWriteData_0_o,
  output logic [3:0]                           AvRxmByteEnable_0_o,
  input  logic                                 AvRxmWaitRequest_0_i,
  output logic                                 AvRxmRead_0_o,
  input  logic [31:0]                          AvRxmReadData_0_i,
  input  logic                                 AvRxmReadDataValid_0_i,

  // Avallogic on Rx Master interface 1
  output logic                                 AvRxmWrite_1_o,
  output logic [BAR1_TYPE-1:0]                 AvRxmAddress_1_o,
  output logic [31:0]                          AvRxmWriteData_1_o,
  output logic [3:0]                           AvRxmByteEnable_1_o,
  input  logic                                 AvRxmWaitRequest_1_i,
  output logic                                 AvRxmRead_1_o,
  input  logic [31:0]                          AvRxmReadData_1_i,
  input  logic                                 AvRxmReadDataValid_1_i,

  // Aval on Rx Master interface 2
  output logic                                 AvRxmWrite_2_o,
  output logic [BAR2_TYPE-1:0]                 AvRxmAddress_2_o,
  output logic [31:0]                          AvRxmWriteData_2_o,
  output logic [3:0]                           AvRxmByteEnable_2_o,
  input  logic                                 AvRxmWaitRequest_2_i,
  output logic                                 AvRxmRead_2_o,
  input  logic [31:0]                          AvRxmReadData_2_i,
  input  logic                                 AvRxmReadDataValid_2_i,

  // Aval on Rx Master interface 3
  output logic                                 AvRxmWrite_3_o,
  output logic [BAR3_TYPE-1:0]                 AvRxmAddress_3_o,
  output logic [31:0]                          AvRxmWriteData_3_o,
  output logic [3:0]                           AvRxmByteEnable_3_o,
  input  logic                                 AvRxmWaitRequest_3_i,
  output logic                                 AvRxmRead_3_o,
  input  logic [31:0]                          AvRxmReadData_3_i,
  input  logic                                 AvRxmReadDataValid_3_i,

  // Avallogic on Rx Master interface 4
  output logic                                 AvRxmWrite_4_o,
  output logic [BAR4_TYPE-1:0]                 AvRxmAddress_4_o,
  output logic [31:0]                          AvRxmWriteData_4_o,
  output logic [3:0]                           AvRxmByteEnable_4_o,
  input  logic                                 AvRxmWaitRequest_4_i,
  output logic                                 AvRxmRead_4_o,
  input  logic [31:0]                          AvRxmReadData_4_i,
  input  logic                                 AvRxmReadDataValid_4_i,

  // Aval on Rx Master interface 5
  output logic                                 AvRxmWrite_5_o,
  output logic [BAR5_TYPE-1:0]                 AvRxmAddress_5_o,
  output logic [31:0]                          AvRxmWriteData_5_o,
  output logic [3:0]                           AvRxmByteEnable_5_o,
  input  logic                                 AvRxmWaitRequest_5_i,
  output logic                                 AvRxmRead_5_o,
  input  logic [31:0]                          AvRxmReadData_5_i,
  input  logic                                 AvRxmReadDataValid_5_i,


//==============================================
// PF0 VF RXM Master Port, one for each BAR
      // Avalon Rx Master interface 0
  output logic                                 pf0_vf_RxmWrite_0_o,
  output logic [VF_BAR0_TYPE-1:0]              pf0_vf_RxmAddress_0_o,
  output logic [31:0]                          pf0_vf_RxmWriteData_0_o,
  output logic [3:0]                           pf0_vf_RxmByteEnable_0_o,
  input  logic                                 pf0_vf_RxmWaitRequest_0_i,
  output logic                                 pf0_vf_RxmRead_0_o,
  input  logic [31:0]                          pf0_vf_RxmReadData_0_i,
  input  logic                                 pf0_vf_RxmReadDataValid_0_i,

  // Avallogic on Rx Master interface 1
  output logic                                 pf0_vf_RxmWrite_1_o,
  output logic [VF_BAR1_TYPE-1:0]              pf0_vf_RxmAddress_1_o,
  output logic [31:0]                          pf0_vf_RxmWriteData_1_o,
  output logic [3:0]                           pf0_vf_RxmByteEnable_1_o,
  input  logic                                 pf0_vf_RxmWaitRequest_1_i,
  output logic                                 pf0_vf_RxmRead_1_o,
  input  logic [31:0]                          pf0_vf_RxmReadData_1_i,
  input  logic                                 pf0_vf_RxmReadDataValid_1_i,

  // Aval on Rx Master interface 2
  output logic                                 pf0_vf_RxmWrite_2_o,
  output logic [VF_BAR2_TYPE-1:0]              pf0_vf_RxmAddress_2_o,
  output logic [31:0]                          pf0_vf_RxmWriteData_2_o,
  output logic [3:0]                           pf0_vf_RxmByteEnable_2_o,
  input  logic                                 pf0_vf_RxmWaitRequest_2_i,
  output logic                                 pf0_vf_RxmRead_2_o,
  input  logic [31:0]                          pf0_vf_RxmReadData_2_i,
  input  logic                                 pf0_vf_RxmReadDataValid_2_i,

  // Aval on Rx Master interface 3
  output logic                                 pf0_vf_RxmWrite_3_o,
  output logic [VF_BAR3_TYPE-1:0]              pf0_vf_RxmAddress_3_o,
  output logic [31:0]                          pf0_vf_RxmWriteData_3_o,
  output logic [3:0]                           pf0_vf_RxmByteEnable_3_o,
  input  logic                                 pf0_vf_RxmWaitRequest_3_i,
  output logic                                 pf0_vf_RxmRead_3_o,
  input  logic [31:0]                          pf0_vf_RxmReadData_3_i,
  input  logic                                 pf0_vf_RxmReadDataValid_3_i,

  // Avallogic on Rx Master interface 4
  output logic                                 pf0_vf_RxmWrite_4_o,
  output logic [VF_BAR4_TYPE-1:0]              pf0_vf_RxmAddress_4_o,
  output logic [31:0]                          pf0_vf_RxmWriteData_4_o,
  output logic [3:0]                           pf0_vf_RxmByteEnable_4_o,
  input  logic                                 pf0_vf_RxmWaitRequest_4_i,
  output logic                                 pf0_vf_RxmRead_4_o,
  input  logic [31:0]                          pf0_vf_RxmReadData_4_i,
  input  logic                                 pf0_vf_RxmReadDataValid_4_i,

  // Aval on Rx Master interface 5
  output logic                                 pf0_vf_RxmWrite_5_o,
  output logic [VF_BAR5_TYPE-1:0]              pf0_vf_RxmAddress_5_o,
  output logic [31:0]                          pf0_vf_RxmWriteData_5_o,
  output logic [3:0]                           pf0_vf_RxmByteEnable_5_o,
  input  logic                                 pf0_vf_RxmWaitRequest_5_i,
  output logic                                 pf0_vf_RxmRead_5_o,
  input  logic [31:0]                          pf0_vf_RxmReadData_5_i,
  input  logic                                 pf0_vf_RxmReadDataValid_5_i,

//=================
// TXS Slave Port
  input   logic                                AvTxsChipSelect_i,
  input   logic                                AvTxsWrite_i,
  input   logic  [TX_S_ADDR_WIDTH+8-1:0]       AvTxsAddress_i,  // {func_no, address}
  input   logic  [31:0]                        AvTxsWriteData_i,
  input   logic  [3:0]                         AvTxsByteEnable_i,
  output  logic                                AvTxsWaitRequest_o,
  input   logic                                AvTxsRead_i,
  output  logic  [31:0]                        AvTxsReadData_o,
  output  logic                                AvTxsReadDataValid_o,


// CRA Slave Port
 input   logic                                 AvCraChipSelect_i,
 input   logic                                 AvCraRead_i,
 input   logic                                 AvCraWrite_i,
 input   logic  [31:0]                         AvCraWriteData_i,
 input   logic  [9:0]                          AvCraAddress_i,
 input   logic  [3:0]                          AvCraByteEnable_i,
 output  logic  [31:0]                         AvCraReadData_o,
 output  logic                                 AvCraWaitRequest_o,

output  logic  [81:0]                          AvMsiIntfc_o,
output  logic  [15:0]                          AvMsixIntfc_o,
input   logic                                  IntxReq_i,
output  logic                                  IntxAck_o,
input   logic  [3:0]                           HipCfgAddr_i,
input   logic  [31:0]                          HipCfgCtl_i,

output logic                                TxData_rdy_o  , // Begin User Streaming Interface
input  wire                                 TxData_val_i  ,
input  wire                                 TxData_sop_i  ,
input  wire                                 TxData_eop_i  ,
input  wire                                 TxData_err_i  ,
input  wire              [TXDATA_WIDTH-1:0] TxData_dat_i  ,
input  wire               [TXMTY_WIDTH-1:0] TxData_sty_i  ,
input  wire               [TXMTY_WIDTH-1:0] TxData_mty_i  ,
input  wire              [TXDESC_WIDTH-1:0] TxData_dsc_i  ,
output logic                                TxStatus_val_o,
output logic           [TXSTATUS_WIDTH-1:0] TxStatus_dat_o,
input  wire                                 RxData_rdy_i  ,
output logic                                RxData_val_o  ,
output logic                                RxData_sop_o  ,
output logic                                RxData_eop_o  ,
output logic                                RxData_err_o  ,
output logic             [RXDATA_WIDTH-1:0] RxData_dat_o  ,
output logic              [RXMTY_WIDTH-1:0] RxData_sty_o  ,
output logic              [RXMTY_WIDTH-1:0] RxData_mty_o  ,
output logic             [RXDESC_WIDTH-1:0] RxData_dsc_o  ,//End  User Streaming Interface



input   logic  [15:0]                          TLCfgSts_i,

input  logic  [4:0]                            Ltssm_i,
input  logic  [1:0]                            CurrentSpeed_i,
input  logic  [3:0]                            LaneAct_i,

/// rx completion space
input  logic [7:0]                             ko_cpl_spc_header,
input  logic [11:0]                            ko_cpl_spc_data
);


localparam HPRXM_BAR_TYPE                    = (enable_rxm_burst_hwtcl== 1)? BAR2_TYPE : 1;
localparam RXM_BAR2_TYPE                     = (enable_rxm_burst_hwtcl== 1)?  1 : BAR2_TYPE;
localparam RXM_BAR3_TYPE                     = (enable_rxm_burst_hwtcl== 1)?  1 : BAR3_TYPE;

//define the clogb2 constant function
function integer clogb2;
   input [31:0] depth;
   begin
      depth = depth - 1 ;
      for (clogb2 = 0; depth > 0; clogb2 = clogb2 + 1)
        depth = depth >> 1 ;
   end
endfunction // clogb2

localparam NUM_TAG_WIDTH = clogb2(NUM_TAG) ;

logic                                          rx_fifo_rdreq;
logic  [RXFIFO_DATA_WIDTH-1:0]                 rx_fifo_dataq;
logic  [3:0]                                   rx_fifo_count;
logic                                          tx_fifo_wrreq;
logic                                          tx_fifo_wrreq_from_rxm;
logic                                          tx_fifo_wrreq_from_txs;
logic  [259:0]                                 tx_fifo_data;
logic  [259:0]                                 tx_fifo_data_from_rxm;
logic  [259:0]                                 tx_fifo_data_from_txs;
logic  [3:0]                                   tx_fifo_count;
logic                                          rxm_req;
logic                                          txs_req;
logic                                          rxm_granted;
logic                                          txs_granted;
logic  [12:0]                                  cfg_bus_dev;
logic  [31:0]                                  cfg_dev_csr;
logic                                          rx_fifo_rdreq_from_rxm;
logic                                          rx_fifo_rdreq_from_txs;
logic                                          rx_fifo_rdreq_from_rd_dma  ;
logic                                          tx_fifo_wrreq_from_rd_dma  ;
logic   [259:0]                                tx_fifo_data_from_rd_dma   ;
logic                                          rx_fifo_rdreq_from_wr_dma  ;
logic                                          tx_fifo_wrreq_from_wr_dma  ;
logic   [259:0]                                tx_fifo_data_from_wr_dma   ;
logic                                          rd_cntrl_ld  ;
logic   [31:0]                                 wr_cntrl_data;
logic                                          wr_cntrl_ld  ;
logic   [31:0]                                 rd_cntrl_data;
logic   [31:0]                                 rd_dma_status_to_cra;
logic   [31:0]                                 wr_dma_status_to_cra;
logic                                          rd_dma_req;
logic                                          lp_wr_dma_req;
logic                                          hp_wr_dma_req;
logic                                          rd_dma_granted;
logic                                          wr_dma_granted;
logic                                          cra_rd_cntrl_clear;
logic  [31:0]                                  msi_data_cntrl;
logic  [31:0]                                  pci_cmd_reg;
logic                                          predecode_tag_rd_req;
logic  [7:0]                                   predecode_tag;
logic  [NUM_TAG_WIDTH-1:0]                     predecode_tag_count;

// Side Fifo
logic                                          tx_side_fifo_wrreq;
logic                                          tx_side_fifo_wrreq_r;
logic                                          tx_side_fifo_rdreq;
logic  [259:0]                                 tx_side_fifo_input_r;
logic  [259:0]                                 tx_side_fifo_input;
logic  [259:0]                                 tx_side_fifo_output;
logic  [3:0]                                   tx_side_fifo_count;
logic  [4:0]                                   wr_idle_cntr;
logic                                          tx_side_fifo_empty;
logic                                          insert_side_tlp;
logic                                          rx_fifo_rdreq_from_hprxm;
logic                                          tx_fifo_wrreq_from_hprxm;
logic  [259:0]                                 tx_fifo_data_from_hprxm;
logic                                          hprxm_req;
logic                                          hprxm_granted;
logic  [3:0]                                   HipCfgAddr_i_r;
logic  [31:0]                                  HipCfgCtl_i_r;


//BEGIN TODO REMOVE HPRXM DMA Wires /////////////////////////////////////////////////////////////////
// Upstream PCIe Read DMA master port                                                              //
// Upstream PCIe Write DMA master port                                                             //
logic                                 AvWrDmaRead_o;                                               //
logic  [63:0]                         AvWrDmaAddress_o;                                            //
logic  [DMA_BRST_CNT_W-1:0]           AvWrDmaBurstCount_o;                                         //
logic                                 AvWrDmaWaitRequest_i;                                        //
logic                                 AvWrDmaReadDataValid_i;                                      //
logic [DMA_WIDTH-1:0]                 AvWrDmaReadData_i;                                           //
logic                                 AvRdDmaWrite_o;                                              //
logic  [63:0]                         AvRdDmaAddress_o;                                            //
logic  [DMA_WIDTH-1:0]                AvRdDmaWriteData_o;                                          //
logic  [DMA_BRST_CNT_W-1:0]           AvRdDmaBurstCount_o;                                         //
logic  [DMA_BE_WIDTH-1:0]             AvRdDmaWriteEnable_o;                                        //
logic                                 AvRdDmaWaitRequest_i;                                        //
// // Read DMA AST Rx port                                                                         //
logic  [RXDATA_WIDTH-1:0]             AvRdDmaRxData_i;                                             //
logic                                 AvRdDmaRxValid_i;                                            //
logic                                 AvRdDmaRxReady_o;                                            //
// Read DMA AST Tx port                                                                            //
logic  [31:0]                         AvRdDmaTxData_o;                                             //
logic                                 AvRdDmaTxValid_o;                                            //
// Write DMA AST Rx port                                                                           //
logic  [RXDATA_WIDTH-1:0]             AvWrDmaRxData_i;                                             //
logic                                 AvWrDmaRxValid_i;                                            //
logic                                 AvWrDmaRxReady_o;                                            //
// Write DMA AST Tx port                                                                           //
logic  [31:0]                         AvWrDmaTxData_o;                                             //
logic                                 AvWrDmaTxValid_o;                                            //
// Avalon HP Rx Master interface                                                                   //
logic                                 AvHPRxmWrite_o;                                              //
logic [BAR2_TYPE-1:0]                 AvHPRxmAddress_o;                                            //
logic [DMA_WIDTH-1:0]                 AvHPRxmWriteData_o;                                          //
logic [(DMA_WIDTH/8)-1:0]             AvHPRxmByteEnable_o;                                         //
logic [DMA_BRST_CNT_W-1:0]            AvHPRxmBurstCount_o;                                         //
logic                                 AvHPRxmWaitRequest_i;                                        //
logic                                 AvHPRxmRead_o;                                               //
logic [DMA_WIDTH-1:0]                 AvHPRxmReadData_i;                                           //
logic                                 AvHPRxmReadDataValid_i;                                      //
/// HP Rxm Interface grounded                                                                      //
assign AvHPRxmWrite_o              = 1'b0;                                                         //
assign AvHPRxmRead_o               = 1'b0;                                                         //
assign AvHPRxmAddress_o            = {(BAR2_TYPE){1'b0}};                                          //
assign AvHPRxmWriteData_o          = {(DMA_WIDTH){1'b0}};                                          //
assign AvHPRxmByteEnable_o         = {(DMA_WIDTH/8){1'b0}};                                        //
assign AvHPRxmBurstCount_o         = {(DMA_BRST_CNT_W){1'b0}};                                     //
assign rx_fifo_rdreq_from_hprxm    = 1'b0;                                                         //
assign tx_fifo_wrreq_from_hprxm    = 1'b0;                                                         //
assign tx_fifo_data_from_hprxm     =  260'h0;                                                      //
assign hprxm_req                   = 1'b0;                                                         //
/// DMA read/write data mover grounded                                                             //
assign AvRdDmaWrite_o             = 1'b0;                   //RdDmaWrite_o                         //
assign AvRdDmaAddress_o           = 64'h0;                  //RdDmaAddress_o                       //
assign AvRdDmaWriteData_o         = {DMA_WIDTH{1'b0}};      //RdDmaWriteData_o                     //
assign AvRdDmaBurstCount_o        = {DMA_BRST_CNT_W{1'b0}}; //RdDmaBurstCount_o                    //
assign AvRdDmaWriteEnable_o       = {DMA_BE_WIDTH{1'b0}};   //RdDmaWriteEnable_o                   //
assign AvRdDmaRxReady_o           = 1'b0;                   //RdDmaRxReady_o                       //
assign AvRdDmaTxData_o            = 32'h0;                  //RdDmaTxData_o                        //
assign AvRdDmaTxValid_o           = 1'b0;                   //RdDmaTxValid_o                       //
assign rx_fifo_rdreq_from_rd_dma  = 1'b0;                   //RxFifoRdReq_o                        //
assign predecode_tag_rd_req       = 1'b0;                   //PreDecodeTagRdReq_o                  //
assign tx_fifo_wrreq_from_rd_dma  = 1'b0;                   //TxFifoWrReq_o                        //
assign tx_fifo_data_from_rd_dma   = 260'h0;                 //TxFifoData_o                         //
assign rd_dma_status_to_cra       = 32'h0;                  //RdDMAStatus_o                        //
assign rd_dma_req                 = 1'b0;                   //RdDMmaArbReq_o                       //
assign  AvWrDmaRead_o              = 1'b0;                   //WrDmaRead_o                         //
assign  AvWrDmaAddress_o           = 64'h0;                  //WrDmaAddress_o                      //
assign  AvWrDmaBurstCount_o        = {DMA_BRST_CNT_W{1'b0}}; //WrDmaBurstCount_o                   //
assign  AvWrDmaRxReady_o           = 1'b0;                   //WrDmaRxReady_o                      //
assign  AvWrDmaTxData_o            = 32'h0;                  //WrDmaTxData_o                       //
assign  AvWrDmaTxValid_o           = 1'b0;                   //WrDmaTxValid_o                      //
assign  rx_fifo_rdreq_from_wr_dma  = 1'b0;                   //RxFifoRdReq_o                       //
assign  tx_fifo_wrreq_from_wr_dma  = 1'b0;                   //TxFifoWrReq_o                       //
assign  tx_fifo_data_from_wr_dma   = 260'h0;                 //TxFifoData_o                        //
assign  wr_dma_status_to_cra       = 32'h0;                  //WrDMAStatus_o                       //
assign  lp_wr_dma_req              = 1'b0;                   //WrDmaArbReq_o                       //
assign  hp_wr_dma_req              = 1'b0;                   //WrDmaArbReq_o                       //
//END TODO REMOVE HPRXM DMA Wires ///////////////////////////////////////////////////////////////////










always @ (posedge Clk_i) begin :p_cfg
   if (~Rstn_i[1]) begin
      HipCfgAddr_i_r <= 4'h0;
      HipCfgCtl_i_r <= 32'h0;
   end
   else begin
      HipCfgAddr_i_r <= HipCfgAddr_i;
      HipCfgCtl_i_r  <= HipCfgCtl_i;
   end
end

// BEGIN RX MASTER SINGLE DWORD ///////////////////////////////////////////////////////////////////////////
// RX master single DWORD
// MemRd or MemWr From PCIe --> HIP --> AVMM
// One Master Per HIP.BAR
// RXM module instantiation

altpcieav_dma_rxm           #(
      .SRIOV_EN              (SRIOV_EN),
      .ARI_EN                (ARI_EN),
      .PHASE1                (PHASE1),
      .BAR0_SIZE_MASK        (BAR0_SIZE_MASK),
      .BAR1_SIZE_MASK        (BAR1_SIZE_MASK),
      .BAR2_SIZE_MASK        (BAR2_SIZE_MASK),
      .BAR3_SIZE_MASK        (BAR3_SIZE_MASK),
      .BAR4_SIZE_MASK        (BAR4_SIZE_MASK),
      .BAR5_SIZE_MASK        (BAR5_SIZE_MASK),
      .BAR0_TYPE             (BAR0_TYPE),
      .BAR1_TYPE             (BAR1_TYPE),
      .BAR2_TYPE             (RXM_BAR2_TYPE),
      .BAR3_TYPE             (RXM_BAR3_TYPE),
      .BAR4_TYPE             (BAR4_TYPE),
      .BAR5_TYPE             (BAR5_TYPE),
      .DMA_WIDTH             (DMA_WIDTH),
      .PF_BAR0_PRESENT       (PF_BAR0_PRESENT ),
      .PF_BAR1_PRESENT       (PF_BAR1_PRESENT ),
      .PF_BAR2_PRESENT       (PF_BAR2_PRESENT ),
      .PF_BAR3_PRESENT       (PF_BAR3_PRESENT ),
      .PF_BAR4_PRESENT       (PF_BAR4_PRESENT ),
      .PF_BAR5_PRESENT       (PF_BAR5_PRESENT ),
      .VF_BAR0_PRESENT       (VF_BAR0_PRESENT ),
      .VF_BAR1_PRESENT       (VF_BAR1_PRESENT ),
      .VF_BAR2_PRESENT       (VF_BAR2_PRESENT ),
      .VF_BAR3_PRESENT       (VF_BAR3_PRESENT ),
      .VF_BAR4_PRESENT       (VF_BAR4_PRESENT ),
      .VF_BAR5_PRESENT       (VF_BAR5_PRESENT ),
      .VF_BAR0_TYPE          (VF_BAR0_TYPE    ),
      .VF_BAR1_TYPE          (VF_BAR1_TYPE    ),
      .VF_BAR2_TYPE          (VF_BAR2_TYPE    ),
      .VF_BAR3_TYPE          (VF_BAR3_TYPE    ),
      .VF_BAR4_TYPE          (VF_BAR4_TYPE    ),
      .VF_BAR5_TYPE          (VF_BAR5_TYPE    ),
      .VF_BAR0_SIZE          (VF_BAR0_SIZE    ),
      .VF_BAR1_SIZE          (VF_BAR1_SIZE    ),
      .VF_BAR2_SIZE          (VF_BAR2_SIZE    ),
      .VF_BAR3_SIZE          (VF_BAR3_SIZE    ),
      .VF_BAR4_SIZE          (VF_BAR4_SIZE    ),
      .VF_BAR5_SIZE          (VF_BAR5_SIZE    ),
      .ACTIVE_VFS            (ACTIVE_VFS      ),
      .enable_rxm_burst_hwtcl(enable_rxm_burst_hwtcl)
   ) rxm_master (
      .Clk_i                  (Clk_i  ),
      .Rstn_i                 (Rstn_i[2]  ),
      .RxFifoRdReq_o          (rx_fifo_rdreq_from_rxm ),
      .RxFifoDataq_i          (rx_fifo_dataq),
      .RxFifoCount_i          (rx_fifo_count),
      .TxFifoWrReq_o          (tx_fifo_wrreq_from_rxm),
      .TxFifoData_o           (tx_fifo_data_from_rxm),
      .TxFifoCount_i          (tx_side_fifo_count),
      .CfgBusDev_i            (cfg_bus_dev),
      .RxmArbCplReq_o         (rxm_req),
      .RxmArbGranted_i        (rxm_granted  ),
      .RxmWrite_0_o           (AvRxmWrite_0_o  ),
      .RxmAddress_0_o         (AvRxmAddress_0_o  ),
      .RxmWriteData_0_o       (AvRxmWriteData_0_o  ),
      .RxmByteEnable_0_o      (AvRxmByteEnable_0_o  ),
      .RxmWaitRequest_0_i     (AvRxmWaitRequest_0_i ),
      .RxmRead_0_o            (AvRxmRead_0_o  ),
      .RxmReadData_0_i        (AvRxmReadData_0_i  ),
      .RxmReadDataValid_0_i   (AvRxmReadDataValid_0_i ),
      .RxmWrite_1_o           (AvRxmWrite_1_o  ),
      .RxmAddress_1_o         (AvRxmAddress_1_o  ),
      .RxmWriteData_1_o       (AvRxmWriteData_1_o  ),
      .RxmByteEnable_1_o      (AvRxmByteEnable_1_o  ),
      .RxmWaitRequest_1_i     (AvRxmWaitRequest_1_i  ),
      .RxmRead_1_o            (AvRxmRead_1_o  ),
      .RxmReadData_1_i        (AvRxmReadData_1_i  ),
      .RxmReadDataValid_1_i   (AvRxmReadDataValid_1_i  ),
      .RxmWrite_2_o           (AvRxmWrite_2_o  ),
      .RxmAddress_2_o         (AvRxmAddress_2_o  ),
      .RxmWriteData_2_o       (AvRxmWriteData_2_o  ),
      .RxmByteEnable_2_o      (AvRxmByteEnable_2_o  ),
      .RxmWaitRequest_2_i     (AvRxmWaitRequest_2_i  ),
      .RxmRead_2_o            (AvRxmRead_2_o  ),
      .RxmReadData_2_i        (AvRxmReadData_2_i  ),
      .RxmReadDataValid_2_i   (AvRxmReadDataValid_2_i  ),
      .RxmWrite_3_o           (AvRxmWrite_3_o  ),
      .RxmAddress_3_o         (AvRxmAddress_3_o  ),
      .RxmWriteData_3_o       (AvRxmWriteData_3_o  ),
      .RxmByteEnable_3_o      (AvRxmByteEnable_3_o  ),
      .RxmWaitRequest_3_i     (AvRxmWaitRequest_3_i  ),
      .RxmRead_3_o            (AvRxmRead_3_o  ),
      .RxmReadData_3_i        (AvRxmReadData_3_i  ),
      .RxmReadDataValid_3_i   (AvRxmReadDataValid_3_i  ),
      .RxmWrite_4_o           (AvRxmWrite_4_o  ),
      .RxmAddress_4_o         (AvRxmAddress_4_o  ),
      .RxmWriteData_4_o       (AvRxmWriteData_4_o  ),
      .RxmByteEnable_4_o      (AvRxmByteEnable_4_o  ),
      .RxmWaitRequest_4_i     (AvRxmWaitRequest_4_i  ),
      .RxmRead_4_o            (AvRxmRead_4_o  ),
      .RxmReadData_4_i        (AvRxmReadData_4_i  ),
      .RxmReadDataValid_4_i   (AvRxmReadDataValid_4_i  ),
      .RxmWrite_5_o           (AvRxmWrite_5_o  ),
      .RxmAddress_5_o         (AvRxmAddress_5_o  ),
      .RxmWriteData_5_o       (AvRxmWriteData_5_o  ),
      .RxmByteEnable_5_o      (AvRxmByteEnable_5_o  ),
      .RxmWaitRequest_5_i     (AvRxmWaitRequest_5_i  ),
      .RxmRead_5_o            (AvRxmRead_5_o ),
      .RxmReadData_5_i        (AvRxmReadData_5_i ),
      .RxmReadDataValid_5_i   (AvRxmReadDataValid_5_i ),
// SRIOV ports for VF
      .pf0_vf_RxmWrite_0_o           (pf0_vf_RxmWrite_0_o  ),
      .pf0_vf_RxmAddress_0_o         (pf0_vf_RxmAddress_0_o  ),
      .pf0_vf_RxmWriteData_0_o       (pf0_vf_RxmWriteData_0_o  ),
      .pf0_vf_RxmByteEnable_0_o      (pf0_vf_RxmByteEnable_0_o  ),
      .pf0_vf_RxmWaitRequest_0_i     (pf0_vf_RxmWaitRequest_0_i ),
      .pf0_vf_RxmRead_0_o            (pf0_vf_RxmRead_0_o  ),
      .pf0_vf_RxmReadData_0_i        (pf0_vf_RxmReadData_0_i  ),
      .pf0_vf_RxmReadDataValid_0_i   (pf0_vf_RxmReadDataValid_0_i ),
      .pf0_vf_RxmWrite_1_o           (pf0_vf_RxmWrite_1_o  ),
      .pf0_vf_RxmAddress_1_o         (pf0_vf_RxmAddress_1_o  ),
      .pf0_vf_RxmWriteData_1_o       (pf0_vf_RxmWriteData_1_o  ),
      .pf0_vf_RxmByteEnable_1_o      (pf0_vf_RxmByteEnable_1_o  ),
      .pf0_vf_RxmWaitRequest_1_i     (pf0_vf_RxmWaitRequest_1_i  ),
      .pf0_vf_RxmRead_1_o            (pf0_vf_RxmRead_1_o  ),
      .pf0_vf_RxmReadData_1_i        (pf0_vf_RxmReadData_1_i  ),
      .pf0_vf_RxmReadDataValid_1_i   (pf0_vf_RxmReadDataValid_1_i  ),
      .pf0_vf_RxmWrite_2_o           (pf0_vf_RxmWrite_2_o  ),
      .pf0_vf_RxmAddress_2_o         (pf0_vf_RxmAddress_2_o  ),
      .pf0_vf_RxmWriteData_2_o       (pf0_vf_RxmWriteData_2_o  ),
      .pf0_vf_RxmByteEnable_2_o      (pf0_vf_RxmByteEnable_2_o  ),
      .pf0_vf_RxmWaitRequest_2_i     (pf0_vf_RxmWaitRequest_2_i  ),
      .pf0_vf_RxmRead_2_o            (pf0_vf_RxmRead_2_o  ),
      .pf0_vf_RxmReadData_2_i        (pf0_vf_RxmReadData_2_i  ),
      .pf0_vf_RxmReadDataValid_2_i   (pf0_vf_RxmReadDataValid_2_i  ),
      .pf0_vf_RxmWrite_3_o           (pf0_vf_RxmWrite_3_o  ),
      .pf0_vf_RxmAddress_3_o         (pf0_vf_RxmAddress_3_o  ),
      .pf0_vf_RxmWriteData_3_o       (pf0_vf_RxmWriteData_3_o  ),
      .pf0_vf_RxmByteEnable_3_o      (pf0_vf_RxmByteEnable_3_o  ),
      .pf0_vf_RxmWaitRequest_3_i     (pf0_vf_RxmWaitRequest_3_i  ),
      .pf0_vf_RxmRead_3_o            (pf0_vf_RxmRead_3_o  ),
      .pf0_vf_RxmReadData_3_i        (pf0_vf_RxmReadData_3_i  ),
      .pf0_vf_RxmReadDataValid_3_i   (pf0_vf_RxmReadDataValid_3_i  ),
      .pf0_vf_RxmWrite_4_o           (pf0_vf_RxmWrite_4_o  ),
      .pf0_vf_RxmAddress_4_o         (pf0_vf_RxmAddress_4_o  ),
      .pf0_vf_RxmWriteData_4_o       (pf0_vf_RxmWriteData_4_o  ),
      .pf0_vf_RxmByteEnable_4_o      (pf0_vf_RxmByteEnable_4_o  ),
      .pf0_vf_RxmWaitRequest_4_i     (pf0_vf_RxmWaitRequest_4_i  ),
      .pf0_vf_RxmRead_4_o            (pf0_vf_RxmRead_4_o  ),
      .pf0_vf_RxmReadData_4_i        (pf0_vf_RxmReadData_4_i  ),
      .pf0_vf_RxmReadDataValid_4_i   (pf0_vf_RxmReadDataValid_4_i  ),
      .pf0_vf_RxmWrite_5_o           (pf0_vf_RxmWrite_5_o  ),
      .pf0_vf_RxmAddress_5_o         (pf0_vf_RxmAddress_5_o  ),
      .pf0_vf_RxmWriteData_5_o       (pf0_vf_RxmWriteData_5_o  ),
      .pf0_vf_RxmByteEnable_5_o      (pf0_vf_RxmByteEnable_5_o  ),
      .pf0_vf_RxmWaitRequest_5_i     (pf0_vf_RxmWaitRequest_5_i  ),
      .pf0_vf_RxmRead_5_o            (pf0_vf_RxmRead_5_o ),
      .pf0_vf_RxmReadData_5_i        (pf0_vf_RxmReadData_5_i ),
      .pf0_vf_RxmReadDataValid_5_i   (pf0_vf_RxmReadDataValid_5_i )
 );
// END RX MASTER SINGLE DWORD /////////////////////////////////////////////////////////////////////////////////

// BEGIN TX Slave SINGLE DWORD ////////////////////////////////////////////////////////////////////////////////
// TX Slave single DWORD On PF0 Only
// MemRd or MemWr From AVMM to --> HIP --> PCIe HOST
// TXS module instantiation
altpcieav_dma_txs           #(
     .SRIOV_EN               (SRIOV_EN),
     .ARI_EN                 (ARI_EN),
     .TX_S_ADDR_WIDTH        (TX_S_ADDR_WIDTH),
     .DMA_WIDTH              (DMA_WIDTH)
  ) txs_slave                (
    .Clk_i                   (Clk_i                   ),
    .Rstn_i                  (Rstn_i[4]                  ),
    .TxsChipSelect_i         (AvTxsChipSelect_i       ),
    .TxsWrite_i              (AvTxsWrite_i            ),
    .TxsAddress_i            (AvTxsAddress_i          ),
    .TxsWriteData_i          (AvTxsWriteData_i        ),
    .TxsByteEnable_i         (AvTxsByteEnable_i       ),
    .TxsWaitRequest_o        (AvTxsWaitRequest_o      ),
    .TxsRead_i               (AvTxsRead_i             ),
    .TxsReadData_o           (AvTxsReadData_o         ),
    .TxsReadDataValid_o      (AvTxsReadDataValid_o    ),
    .RxFifoRdReq_o           (rx_fifo_rdreq_from_txs  ),
    .RxFifoDataq_i           (rx_fifo_dataq           ),
    .RxFifoCount_i           (rx_fifo_count           ),
    .TxFifoWrReq_o           (tx_fifo_wrreq_from_txs  ),
    .TxFifoData_o            (tx_fifo_data_from_txs   ),
    .TxFifoCount_i           (tx_side_fifo_count      ),
    .TxsArbReq_o             (txs_req                 ),
    .TxsArbGranted_i         (txs_granted             ),
    .MasterEnable_i          ( pci_cmd_reg[2]         ),
    .BusDev_i                (cfg_bus_dev             )
);
// END TX Slave SINGLE DWORD ////////////////////////////////////////////////////////////////////////////////


// HIP interface module
altpcieav_hip_interface # (
    .dma_use_scfifo_ext   (dma_use_scfifo_ext),
    .DEVICE_FAMILY        (DEVICE_FAMILY),
    .SRIOV_EN             (SRIOV_EN),
    .VF_COUNT             (VF_COUNT),
    .DMA_WIDTH            (DMA_WIDTH),
    .DMA_BE_WIDTH         (DMA_BE_WIDTH)
) hip_inf                 (
    .Clk_i                (Clk_i ),
    .Rstn_i               (Rstn_i[5] ),
    .RxStReady_o          (HipRxStReady_o  ),   // HIP.RX.AST
    .RxStData_i           (HipRxStData_i  ),
    .RxStEmpty_i          (HipRxStEmpty_i  ),
    .RxStSop_i            (HipRxStSop_i ),
    .RxStEop_i            (HipRxStEop_i ),
    .RxStValid_i          (HipRxStValid_i  ),
    .RxStBarDec1_i        (HipRxStBarDec1_i ),
    .RxStFunc_i           (rx_st_bar_hit_fn_tlp0_i), // SR-IOV RX function number
    .TxStReady_i          (HipTxStReady_i ),    // HIP.TX.AST
    .TxStData_o           (HipTxStData_o ),
    .TxStSop_o            (HipTxStSop_o ),
    .TxStEop_o            (HipTxStEop_o ),
    .TxStEmpty_o          (HipTxStEmpty_o ),
    .TxStValid_o          (HipTxStValid_o ),
    .RxFifoRdReq_i        (RxFifoRdReq_o      ),// RX FIFO Read.AST
    .RxFifoDataq_o        (RxFifoDataq_i      ),
    .RxFifoCount_o        (RxFifoCount_i      ),
    .PreDecodeTagRdReq_i  (PreDecodeTagRdReq_o),
    .PreDecodeTag_o       (PreDecodeTag_i     ),
    .PreDecodeTagCount_o  (PreDecodeTagCount_i),
    .TxFifoWrReq_i        (TxFifoWrReq_o      ),
    .TxFifoData_i         (TxFifoData_o       ),
    .TxFifoCount_o        (TxFifoCount_i      ),
    .MsiIntfc_o           (AvMsiIntfc_o),
    .MsixIntfc_o          (AvMsixIntfc_o),
    .CfgAddr_i            (HipCfgAddr_i_r),
    .CfgCtl_i             (HipCfgCtl_i_r),
    .CfgBusDev_o          (cfg_bus_dev),
    .DevCsr_o             (cfg_dev_csr),
    .PciCmd_o             (pci_cmd_reg),
    .MsiDataCrl_o         (msi_data_cntrl),
    .bus_num_f0_i         (bus_num_f0_i      ),
    .device_num_f0_i      (device_num_f0_i   ),
    .max_payload_size_i   (max_payload_size_i),
    .rd_req_size_i        (rd_req_size_i     ),
    .bus_master_en_pf_i   (bus_master_en_pf_i),
    .bus_master_en_vf_i   (bus_master_en_vf_i)
);


/// arbiter
altpcieav_arbiter arbiter_inst (
   .Clk_i                      (Clk_i),
   .Rstn_i                     (Rstn_i[8]),
   .TxsArbReq_i                (txs_req),
   .RxmArbReq_i                (rxm_req),
   .HPRxmArbReq_i              (1'b0),
   .DMAWrArbReq_i              (1'b0),
   .DMARdArbReq_i              (1'b0),
   .TxsArbGrant_o              (txs_granted),
   .RxmArbGrant_o              (rxm_granted),
   .HPRxmArbGrant_o            (hprxm_granted),
   .DMAWrArbGrant_o            (wr_dma_granted),
   .DMARdArbGrant_o            (rd_dma_granted)
);

// CRA module

generate if(enable_cra_hwtcl == 1) begin : cra
   altpcieav_cra altpcieav_cra_inst (
      .Clk_i                        (Clk_i ),
      .Rstn_i                       (Rstn_i[8] ),
      .CraChipSelect_i              (AvCraChipSelect_i ),
      .CraRead_i                    (AvCraRead_i ),
      .CraWrite_i                   (AvCraWrite_i ),
      .CraAddress_i                 (AvCraAddress_i ),
      .CraWriteData_i               (AvCraWriteData_i ),
      .CraByteEnable_i              (AvCraByteEnable_i ),
      .CraWaitRequest_o             (AvCraWaitRequest_o ),
      .CraReadData_o                (AvCraReadData_o ),
      .CfgAddr_i                    (HipCfgAddr_i_r ),
      .CfgCtl_i                     (HipCfgCtl_i_r),
      .Ltssm_i                      (Ltssm_i),
      .CurrentSpeed_i               (CurrentSpeed_i),
      .LaneAct_i                    (LaneAct_i)
   );
   end
   else begin : no_cra
      assign AvCraWaitRequest_o = 1'b1;
      assign AvCraReadData_o    = 32'h0;
   end
endgenerate


assign HipCplPending_o   = 1'b0;
assign rx_fifo_rdreq     = rx_fifo_rdreq_from_rxm | rx_fifo_rdreq_from_txs | rx_fifo_rdreq_from_rd_dma | rx_fifo_rdreq_from_hprxm;
assign tx_fifo_wrreq = tx_fifo_wrreq_from_wr_dma | tx_fifo_wrreq_from_hprxm | insert_side_tlp;
assign tx_fifo_data = insert_side_tlp ? tx_side_fifo_output : hprxm_granted? tx_fifo_data_from_hprxm : tx_fifo_data_from_wr_dma;

/// Tx side buffer to hold TXS and Read TLP for simultaneous operation
/// Leting the write have exclusive right the TX output buffer
/// The side buffer will be emptied into the Tx output buffer when the Write DMA is in idle cycle

generate begin : g_tx_side_fifo
   if (dma_use_scfifo_ext>0) begin
      wire [4:0] tx_side_fifo_count_ext;
      if (dma_use_scfifo_ext==1) begin // Family=A10
         altpcie_scfifo_a10   #(
               .WIDTH          (260), // typical 20,40,60,80
               .NUM_FIFO32     (0)    // Number of 32 DEEP FIFO; Valid Range 1,2,3,4, when 0 only 16 deep
         )   tx_side_fifo      (
               .clk            (Clk_i),
               .sclr           (~Rstn_i[2]),
               .wdata          (tx_side_fifo_input_r),
               .wreq           (tx_side_fifo_wrreq_r),
               .full           (),
               .rdata          (tx_side_fifo_output),
               .rreq           (tx_side_fifo_rdreq),
               .empty          (),
               .used           (tx_side_fifo_count_ext)
         );
      end
      else if (dma_use_scfifo_ext==2) begin // Family=SV
         altpcie_scfifo   #(
               .WIDTH          (260), // typical 20,40,60,80
               .NUM_FIFO32     (0)    // Number of 32 DEEP FIFO; Valid Range 1,2,3,4, when 0 only 16 deep
         )   tx_side_fifo      (
               .clk            (Clk_i),
               .sclr           (Rstn_i[2]),
               .wdata          (tx_side_fifo_input_r),
               .wreq           (tx_side_fifo_wrreq_r),
               .full           (),
               .rdata          (tx_side_fifo_output),
               .rreq           (tx_side_fifo_rdreq),
               .empty          (),
               .used           (tx_side_fifo_count_ext)
         );
      end
      assign tx_side_fifo_count[3:0] = tx_side_fifo_count_ext[3:0];
   end
   else begin
      altpcie_fifo #(
          .FIFO_DEPTH      ( 16),
          .DATA_WIDTH      ( 260)
          ) tx_side_fifo   (
            .clk           ( Clk_i),
            .rstn          ( Rstn_i[2]),
            .srst          ( 1'b0),
            .wrreq         ( tx_side_fifo_wrreq_r),
            .rdreq         ( tx_side_fifo_rdreq),
            .data          ( tx_side_fifo_input_r),
            .q             ( tx_side_fifo_output),
            .fifo_count    ( tx_side_fifo_count)
      );
   end
end
endgenerate


always_ff @ (posedge Clk_i) begin
  if(~Rstn_i[8])
   begin
      tx_side_fifo_wrreq_r <= 1'h0;
      tx_side_fifo_input_r <= 260'h0;
   end
   else begin
        tx_side_fifo_wrreq_r <= tx_side_fifo_wrreq;
        tx_side_fifo_input_r <= tx_side_fifo_input;
   end
end

assign tx_side_fifo_wrreq =  tx_fifo_wrreq_from_rxm | tx_fifo_wrreq_from_txs | tx_fifo_wrreq_from_rd_dma;
assign tx_side_fifo_input =  txs_granted? tx_fifo_data_from_txs :  rxm_granted? tx_fifo_data_from_rxm : tx_fifo_data_from_rd_dma;

/// handle the Txs/Rxm/Rd insertion into the Tx output fifo when Write is idle
/// when Write Request is low, there are at least two idle clock that can be used to insert pending TLP from the side fifo

always_ff @ (posedge Clk_i) begin
   if(~Rstn_i[8]) begin
       wr_idle_cntr[4:0] <= 5'h0;
   end
   else if(~lp_wr_dma_req) begin
       wr_idle_cntr[4:0] <= 5'h0;
   end
   else if(lp_wr_dma_req & (wr_idle_cntr[4:0]< 5'h3)) begin
       wr_idle_cntr[4:0] <= wr_idle_cntr[4:0] + 5'h1;
   end
end

/// insert TLP when the idle counter is 0 or 1
// In the case of 128 bit ifc there can be a 2 cycle Txs transaction. Read out only when the entire transaction can be accomodated in 2 cycles
assign insert_side_tlp = (((wr_idle_cntr[4:0] == 5'h0) & (tx_fifo_count < 4'hD)) |
                         (((DMA_WIDTH == 256) ? (wr_idle_cntr[4:0] == 5'h1) : ((wr_idle_cntr[4:0] == 5'h1) & tx_side_fifo_output[129])) & (tx_fifo_count < 4'hE))) &
                         ~tx_side_fifo_empty & ~tx_fifo_wrreq_from_wr_dma;
assign tx_side_fifo_rdreq = insert_side_tlp;
assign tx_side_fifo_empty = (tx_side_fifo_count == 0);


//==========================
// Unused outputs
assign HipRxStMask_o = 1'b0;


altpcie_ast_translator # (
   .DEVICE_FAMILY        (DEVICE_FAMILY),
   .dma_use_scfifo_ext   (dma_use_scfifo_ext),
   .SRIOV_EN             (SRIOV_EN),
   .ARI_EN               (ARI_EN),
   .PHASE1               (PHASE1),
   .VF_COUNT             (VF_COUNT),
   .DMA_WIDTH            (DMA_WIDTH),
   .TX_FIFO_WIDTH        ((DMA_WIDTH == 256) ? 260 : 131),
   .NUM_TAG              (NUM_TAG),
   .NUM_TAG_WIDTH        (NUM_TAG_WIDTH),
   .RXFIFO_DATA_WIDTH    ((SRIOV_EN == 1) ? 274 : 266 ),
   .NUM_DESC             (NUM_DESC),
   .NUM_DESC_WIDTH       (clogb2(NUM_DESC) ),
   .TXDATA_WIDTH         (TXDATA_WIDTH  ),
   .TXDESC_WIDTH         (TXDESC_WIDTH  ),
   .TXSTATUS_WIDTH       (TXSTATUS_WIDTH),
   .RXDATA_WIDTH         (RXDATA_WIDTH  ),
   .RXDESC_WIDTH         (RXDESC_WIDTH  ),
   .TXMTY_WIDTH          (clogb2(TXDATA_WIDTH)),
   .RXMTY_WIDTH          (clogb2(RXDATA_WIDTH))
)altpcie_ast_translator (
   .Clk_i              (Clk_i              ),//  input wire                                  Clk_i
   .Rstn_i             (Rstn_i[1]          ),// ,input wire                                  Rstn_i

   .TxData_rdy_o       (TxData_rdy_o       ),// ,output logic                                TxData_rdy_o // Begin User Streaming Interface
   .TxData_val_i       (TxData_val_i       ),// ,input  wire                                 TxData_val_i
   .TxData_sop_i       (TxData_sop_i       ),// ,input  wire                                 TxData_sop_i
   .TxData_eop_i       (TxData_eop_i       ),// ,input  wire                                 TxData_eop_i
   .TxData_err_i       (TxData_err_i       ),// ,input  wire                                 TxData_err_i
   .TxData_dat_i       (TxData_dat_i       ),// ,input  wire              [TXDATA_WIDTH-1:0] TxData_dat_i
   .TxData_sty_i       (TxData_sty_i       ),// ,input  wire               [TXMTY_WIDTH-1:0] TxData_sty_i
   .TxData_mty_i       (TxData_mty_i       ),// ,input  wire               [TXMTY_WIDTH-1:0] TxData_mty_i
   .TxData_dsc_i       (TxData_dsc_i       ),// ,input  wire              [TXDESC_WIDTH-1:0] TxData_dsc_i
   .TxStatus_val_o     (TxStatus_val_o     ),// ,output logic                                TxStatus_val_o
   .TxStatus_dat_o     (TxStatus_dat_o     ),// ,output logic           [TXSTATUS_WIDTH-1:0] TxStatus_dat_o

   .RxData_rdy_i       (RxData_rdy_i       ),// ,input  wire                                 RxData_rdy_i
   .RxData_val_o       (RxData_val_o       ),// ,output logic                                RxData_val_o
   .RxData_sop_o       (RxData_sop_o       ),// ,output logic                                RxData_sop_o
   .RxData_eop_o       (RxData_eop_o       ),// ,output logic                                RxData_eop_o
   .RxData_err_o       (RxData_err_o       ),// ,output logic                                RxData_err_o
   .RxData_dat_o       (RxData_dat_o       ),// ,output logic             [RXDATA_WIDTH-1:0] RxData_dat_o
   .RxData_sty_o       (RxData_sty_o       ),// ,output logic              [RXMTY_WIDTH-1:0] RxData_sty_o
   .RxData_mty_o       (RxData_mty_o       ),// ,output logic              [RXMTY_WIDTH-1:0] RxData_mty_o
   .RxData_dsc_o       (RxData_dsc_o       ),// ,output logic             [RXDESC_WIDTH-1:0] RxData_dsc_o  ///End  User Streaming Interface

   .RxFifoRdReq_o      (RxFifoRdReq_o      ),// ,output logic                                RxFifoRdReq_o
   .RxFifoDataq_i      (RxFifoDataq_i      ),// ,input  wire        [RXFIFO_DATA_WIDTH-1:0]  RxFifoDataq_i
   .RxFifoCount_i      (RxFifoCount_i      ),// ,input  wire                          [3:0]  RxFifoCount_i
   .PreDecodeTagRdReq_o(PreDecodeTagRdReq_o),// ,output logic                                PreDecodeTagRdReq_o
   .PreDecodeTag_i     (PreDecodeTag_i     ),// ,input  wire                           [7:0] PreDecodeTag_i
   .PreDecodeTagCount_i(PreDecodeTagCount_i),// ,input  wire             [NUM_TAG_WIDTH-1:0] PreDecodeTagCount_i
   .TxFifoWrReq_o      (TxFifoWrReq_o      ),// ,output logic                                TxFifoWrReq_o
   .TxFifoData_o       (TxFifoData_o       ),// ,output logic            [TX_FIFO_WIDTH-1:0] TxFifoData_o
   .TxFifoCount_i      (TxFifoCount_i      ),// ,input  wire                           [3:0] TxFifoCount_i

   .RdDMACntrlLoad_i   (1'b0               ),// ,input  wire                                 RdDMACntrlLoad_i   //// UNUSED
   .RdDMACntrlData_i   (32'h0              ),// ,input  wire                          [31:0] RdDMACntrlData_i   //// UNUSED
   .RdDMAStatus_o      (                   ),// ,output logic                         [31:0] RdDMAStatus_o      //// UNUSED
   .WrDMACntrlLoad_i   (1'b0               ),// ,input  wire                                 WrDMACntrlLoad_i   //// UNUSED      //I doubt we need 2 of these
   .WrDMACntrlData_i   (32'h0              ),// ,input  wire                          [31:0] WrDMACntrlData_i   //// UNUSED
   .WrDMAStatus_o      (                   ),// ,output logic                         [31:0] WrDMAStatus_o      //// UNUSED
   .RdDMmaArbReq_o     (                   ),// ,output logic                                RdDMmaArbReq_o
   .RdDMmaArbGranted_i (RdDMmaArbGranted_i ),// ,input  wire                                 RdDMmaArbGranted_i
   .WrDmaLPArbReq_o    (WrDmaLPArbReq_o    ),// ,output logic                                WrDmaLPArbReq_o
   .WrDmaHPArbReq_o    (WrDmaHPArbReq_o    ),// ,output logic                                WrDmaHPArbReq_o
   .WrDmaLPArbReq_i    (WrDmaLPArbReq_i    ),// ,input  wire                                 WrDmaLPArbReq_i
   .WrDmaHPArbReq_i    (WrDmaHPArbReq_i    ),// ,input  wire                                 WrDmaHPArbReq_i
   .WrDmaArbGranted_i  (WrDmaArbGranted_i  ),// ,input  wire                                 WrDmaArbGranted_i

   .BusDev_i           (BusDev_i           ),// ,input  wire                          [15:0] BusDev_i           //was rd:[12:0], wr:[15:0]
   .DevCsr_i           (DevCsr_i           ),// ,input  wire                          [31:0] DevCsr_i
   .MasterEnable       (MasterEnable       ),// ,input  wire                                 MasterEnable
   .MasterEnable_i     (MasterEnable_i     ),// ,input  wire                                 MasterEnable_i     // PF Master Enable
   .vf_MasterEnable_i  (vf_MasterEnable_i  ),// ,input  wire                  [VF_COUNT-1:0] vf_MasterEnable_i  // SR-IOV VF Master Enable
   .ko_cpl_spc_header  (ko_cpl_spc_header  ),// ,input  wire                           [7:0] ko_cpl_spc_header
   .ko_cpl_spc_data    (ko_cpl_spc_data    )// ,input  wire                          [11:0] ko_cpl_spc_data
);

endmodule

