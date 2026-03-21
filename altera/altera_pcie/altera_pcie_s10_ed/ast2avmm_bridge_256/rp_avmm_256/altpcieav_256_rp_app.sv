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

module altpcieav_256_rp_app
#(
     //----------------------------------------------------
     //------------- TOP LEVEL PARAMETERS -----------------
     //----------------------------------------------------
     parameter DEVICE_FAMILY               = "Stratix 10",
     parameter DMA_WIDTH                   = 256,
     parameter DMA_BE_WIDTH                = 32,
     parameter DMA_BRST_CNT_W              = 6,
     parameter TX_S_ADDR_WIDTH             = 31,
     parameter enable_cra_hwtcl            = 1,
     parameter enable_tx_slave             = 1,
     parameter port_type_hwtcl             = "Native endpoint",
     parameter dma_use_scfifo_ext          = 0,
     parameter BAR_NUMBER                  = 0,
     parameter BAR0_SIZE_MASK              = 10,
     parameter BAR0_TYPE                   = 64,
     parameter SRIOV_EN                    = 0,
     parameter PF_COUNT                    = 4,
     parameter VF_COUNT                    = 4,
     parameter PFCNT_WD                    = 2,
     parameter VFCNT_WD                    = 2

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
   input  logic  [2:0]                        HipRxStBar_range_i,
   input  logic  [PFCNT_WD-1:0]               HipRxSt_pf_num_i,
   input  logic  [VFCNT_WD-1:0]               HipRxSt_vf_num_i,
   input  logic                               HipRxSt_vf_active_i,
   // Tx application interface
   input   logic                              HipTxStReady_i  ,
   output  logic  [DMA_WIDTH-1:0]             HipTxStData_o   ,
   output  logic                              HipTxStSop_o    ,
   output  logic                              HipTxStEop_o    ,
   output  logic  [1:0]                       HipTxStEmpty_o  ,
   output  logic                              HipTxStValid_o  ,
   output  logic                              HipCplPending_o,
   output  logic  [PFCNT_WD-1:0]              HipTxSt_pf_num_o,
   output  logic  [VFCNT_WD-1:0]              HipTxSt_vf_num_o,
   output  logic                              HipTxSt_vf_active_o,

 // RXM Master Port, one for each BAR
      // Avalon Rx Master interface 0
  output logic                                 AvRxmWrite_0_o,
  output logic [BAR0_TYPE-1:0]                 AvRxmAddress_0_o,
  output logic [DMA_WIDTH-1:0]                 AvRxmWriteData_0_o,
  output logic [(DMA_WIDTH/8)-1:0]             AvRxmByteEnable_0_o,
  output logic [DMA_BRST_CNT_W-1:0]            AvRxmBurstCount_0_o,
  input  logic                                 AvRxmWaitRequest_0_i,
  output logic                                 AvRxmRead_0_o,
  input  logic [DMA_WIDTH-1:0]                 AvRxmReadData_0_i,
  input  logic                                 AvRxmReadDataValid_0_i,
  input  logic                                 AvRxmIrq_i,

//=================
// TXS Slave Port
  input   logic                                AvTxsChipSelect_i,
  input   logic                                AvTxsWrite_i,
  input   logic  [TX_S_ADDR_WIDTH-1:0]         AvTxsAddress_i,
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
 input   logic  [13:0]                         AvCraAddress_i,
 input   logic  [3:0]                          AvCraByteEnable_i,
 output  logic  [31:0]                         AvCraReadData_o,
 output  logic                                 AvCraWaitRequest_o,
 output  logic                                 AvCraIrq_o,


output  logic  [81:0]                          AvMsiIntfc_o,
output  logic  [15:0]                          AvMsixIntfc_o,
input   logic                                  IntxReq_i,
output  logic                                  IntxAck_o,

input   logic  [4:0]                           HipCfgAddr_i,
input   logic  [1:0]                           HipCfgFunc_i,
input   logic  [31:0]                          HipCfgCtl_i,


input  logic  [5:0]                            Ltssm_i,
input  logic  [1:0]                            CurrentSpeed_i,
input  logic  [4:0]                            LaneAct_i




);
    //define the clogb2 constant function
   function integer clogb2;
      input [31:0] depth;
      begin
        if (depth) begin
         depth = depth - 1 ;
         for (clogb2 = 0; depth > 0; clogb2 = clogb2 + 1)
           depth = depth >> 1 ;
        end else
          clogb2 = 0 ;
      end
   endfunction // clogb2

localparam MFN_AWD              = clogb2(PF_COUNT+VF_COUNT);
localparam RXFIFO_DATA_WIDTH    =  SRIOV_EN ? 266+3+1+PFCNT_WD+VFCNT_WD : 266; //SRIOV-3-Bit Bar Number,1-Bit VF Active
localparam TXFIFO_DATA_WIDTH    =  SRIOV_EN ? 260+1+PFCNT_WD+VFCNT_WD : 260;

localparam ARI_EN                            = 0;
localparam NUM_TAG                           = 16;
localparam NUM_TAG_WIDTH                     = clogb2(NUM_TAG) ;
localparam ROOT_PORT                         = (port_type_hwtcl == "Native endpoint" ) ? 0 : 1;

logic                                          rx_fifo_rdreq;
logic  [RXFIFO_DATA_WIDTH-1:0]                 rx_fifo_dataq;
logic  [3:0]                                   rx_fifo_count;
logic                                          tx_fifo_wrreq;
logic                                          tx_fifo_wrreq_from_txs;
logic  [TXFIFO_DATA_WIDTH-1:0]                 tx_fifo_data;
logic  [259:0]                                 tx_fifo_data_from_txs;
logic  [3:0]                                   tx_fifo_count;
logic                                          txs_req;
logic                                          txs_granted;
logic  [12:0]                                  cfg_bus_dev;
logic  [31:0]                                  cfg_dev_csr;
logic                                          rx_fifo_rdreq_from_txs;

logic  [31:0]                                  msi_data_cntrl;
logic  [31:0]                                  pci_cmd_reg;
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
logic                                          tx_side_fifo_empty;
logic                                          insert_side_tlp;
logic                                          rx_fifo_rdreq_from_hprxm;
logic                                          tx_fifo_wrreq_from_hprxm;
logic  [TXFIFO_DATA_WIDTH-1:0]                 tx_fifo_data_from_hprxm;
logic                                          hprxm_req;
logic                                          hprxm_granted;
logic  [4:0]                                   HipCfgAddr_i_r;
logic  [1:0]                                   HipCfgFunc_i_r;
logic  [31:0]                                  HipCfgCtl_i_r;

//CRA
logic                                          rp_tx_tlp_rdreq;
logic                                          rp_tx_tlp_ready;
logic                                          rp_rx_tlp_rdreq;
logic                                          rx_fifo_rdreq_from_cra;
logic  [259:0]                                 tx_fifo_data_from_cra;
logic                                          tx_fifo_wrreq_from_cra;
logic                                          txs_arb_req;




always @ (posedge Clk_i or negedge Rstn_i[1])
  begin
     if (~Rstn_i[1])
       begin
       HipCfgAddr_i_r <= 5'h00;
       HipCfgFunc_i_r <= 2'h0;
       HipCfgCtl_i_r <= 32'h0;
       end
     else
       begin
        HipCfgAddr_i_r <= HipCfgAddr_i;
        HipCfgFunc_i_r <= HipCfgFunc_i;
        HipCfgCtl_i_r  <= HipCfgCtl_i;
       end
end


 /// HP Rxm Interface

    altpcieav_256_rp_rxm        #(
           .dma_use_scfifo_ext (dma_use_scfifo_ext),
           .AVMM_WIDTH         (DMA_WIDTH),
           .TXF_DWIDTH         (TXFIFO_DATA_WIDTH),
           .BAR_NUMBER         (BAR_NUMBER),
           .HPRXM_BAR_TYPE     (BAR0_TYPE),
           .BAR2_SIZE_MASK     (BAR0_SIZE_MASK),
           .RXF_DWIDTH         (RXFIFO_DATA_WIDTH),
           .SRIOV_EN           (SRIOV_EN),
           .ROOT_PORT          (ROOT_PORT),
           .MFN_AWD            (MFN_AWD),
           .PFCNT_WD           (PFCNT_WD),
           .VFCNT_WD           (VFCNT_WD),
           .PFCNT              (PF_COUNT)

    ) hprxm_master              (
          .Clk_i               (Clk_i ),
          .Rstn_i              (Rstn_i[3] ),
          .HPRxmWrite_o        (AvRxmWrite_0_o        ),
          .HPRxmAddress_o      (AvRxmAddress_0_o      ),
          .HPRxmWriteData_o    (AvRxmWriteData_0_o    ),
          .HPRxmByteEnable_o   (AvRxmByteEnable_0_o   ),
          .HPRxmBurstCount_o   (AvRxmBurstCount_0_o   ),
          .HPRxmWaitRequest_i  (AvRxmWaitRequest_0_i  ),
          .HPRxmRead_o         (AvRxmRead_0_o         ),
          .HPRxmReadData_i     (AvRxmReadData_0_i     ),
          .HPRxmReadDataValid_i(AvRxmReadDataValid_0_i),
          .RxFifoRdReq_o       (rx_fifo_rdreq_from_hprxm),
          .RxFifoDataq_i       (rx_fifo_dataq ),
          .RxFifoCount_i       (rx_fifo_count ),
          .TxFifoWrReq_o       (tx_fifo_wrreq_from_hprxm ),
          .TxFifoData_o        (tx_fifo_data_from_hprxm ),
          .TxFifoCount_i       (tx_fifo_count),
          .HPRxmArbReq_o       (hprxm_req ),
          .HPRxmArbGranted_i   (hprxm_granted ),
          .BusDev_i            (cfg_bus_dev),
          .DevCsr_i            (cfg_dev_csr)
    );


// Txs instantiation
generate begin:TXS_GEN
  if(enable_tx_slave == 1) begin
      altpcieav_256_rp_txs           #(
           .SRIOV_EN               (0),
           .ARI_EN                 (ARI_EN),
           .TX_S_ADDR_WIDTH        (TX_S_ADDR_WIDTH),
           .DMA_WIDTH              (DMA_WIDTH)
        ) txs_slave                (
          .Clk_i                   (Clk_i                   ),
          .Rstn_i                  (Rstn_i[4]               ),
          .TxsChipSelect_i         (AvTxsChipSelect_i       ),
          .TxsWrite_i              (AvTxsWrite_i            ),
          .TxsAddress_i            ({8'h00,AvTxsAddress_i}  ),
          .TxsWriteData_i          (AvTxsWriteData_i        ),
          .TxsByteEnable_i         (AvTxsByteEnable_i       ),
          .TxsWaitRequest_o        (AvTxsWaitRequest_o      ),
          .TxsRead_i               (AvTxsRead_i             ),
          .TxsReadData_o           (AvTxsReadData_o         ),
          .TxsReadDataValid_o      (AvTxsReadDataValid_o    ),
          .RxFifoRdReq_o           (rx_fifo_rdreq_from_txs  ),
          .RxFifoDataq_i           (rx_fifo_dataq[259:0]    ),
          .RxFifoCount_i           (rx_fifo_count           ),
          .TxFifoWrReq_o           (tx_fifo_wrreq_from_txs  ),
          .TxFifoData_o            (tx_fifo_data_from_txs   ),
          .TxFifoCount_i           (tx_side_fifo_count      ),
          .TxsArbReq_o             (txs_req                 ),
          .TxsArbGranted_i         (txs_granted             ),
          .MasterEnable_i          ( pci_cmd_reg[2]         ),
          .BusDev_i                (cfg_bus_dev             )
      );
   end
   else begin
      assign AvTxsWaitRequest_o      = 1'b1 ;
      assign AvTxsReadData_o         = {31{1'b0}};
      assign AvTxsReadDataValid_o    = 1'b0;
      assign rx_fifo_rdreq_from_txs  = 1'b0;
      assign tx_fifo_wrreq_from_txs  = 1'b0;
      assign tx_fifo_data_from_txs   = {260{1'b0}};
      assign txs_req                 = 1'b0;

   end
 end
endgenerate





// HIP interface module

   altpcieav_256_rp_hip_interface # (
       .dma_use_scfifo_ext   (dma_use_scfifo_ext),
       .DEVICE_FAMILY        (DEVICE_FAMILY),
       .SRIOV_EN             (SRIOV_EN),
       .RXFIFO_DATA_WIDTH    (RXFIFO_DATA_WIDTH),
       .DMA_WIDTH            (DMA_WIDTH),
       .DMA_BE_WIDTH         (DMA_BE_WIDTH),
       .TX_FIFO_WIDTH        (TXFIFO_DATA_WIDTH),
       .PFCNT_WD             (PFCNT_WD),
       .VFCNT_WD             (VFCNT_WD)
   ) hip_inf                 (
       .Clk_i                (Clk_i ),
       .Rstn_i               (Rstn_i[5] ),
       .RxStReady_o          (HipRxStReady_o  ),
       .RxStData_i           (HipRxStData_i  ),
       .RxStEmpty_i          (HipRxStEmpty_i  ),
       .RxStSop_i            (HipRxStSop_i ),
       .RxStEop_i            (HipRxStEop_i ),
       .RxStValid_i          (HipRxStValid_i  ),
       .RxStBarDec1_i        (HipRxStBarDec1_i ),
       .RxStBar_range_i      (HipRxStBar_range_i),
       .RxSt_pf_num_i        (HipRxSt_pf_num_i),
       .RxSt_vf_num_i        (HipRxSt_vf_num_i),
       .RxSt_vf_active_i     (HipRxSt_vf_active_i),
       .TxStReady_i          (HipTxStReady_i ),
       .TxStData_o           (HipTxStData_o ),
       .TxStSop_o            (HipTxStSop_o ),
       .TxStEop_o            (HipTxStEop_o ),
       .TxStEmpty_o          (HipTxStEmpty_o ),
       .TxStValid_o          (HipTxStValid_o ),
       .TxSt_pf_num_o        (HipTxSt_pf_num_o   ),
       .TxSt_vf_num_o        (HipTxSt_vf_num_o   ),
       .TxSt_vf_active_o     (HipTxSt_vf_active_o),
       .RxFifoRdReq_i        (rx_fifo_rdreq ),
       .RxFifoDataq_o        (rx_fifo_dataq ),
       .RxFifoCount_o        (rx_fifo_count ),
       .PreDecodeTagRdReq_i  (1'b0),
       .PreDecodeTag_o       (predecode_tag),
       .PreDecodeTagCount_o  (predecode_tag_count),
       .TxFifoWrReq_i        (tx_fifo_wrreq ),
       .TxFifoData_i         (tx_fifo_data ),
       .TxFifoCount_o        (tx_fifo_count),
       .MsiIntfc_o           (AvMsiIntfc_o),
       .MsixIntfc_o          (AvMsixIntfc_o),
       .CfgAddr_i            (HipCfgAddr_i_r),
       .CfgFunc_i            (HipCfgFunc_i_r),
       .CfgCtl_i             (HipCfgCtl_i_r),
       .CfgBusDev_o          (cfg_bus_dev),
       .DevCsr_o             (cfg_dev_csr),
       .PciCmd_o             (pci_cmd_reg),
       .MsiDataCrl_o         (msi_data_cntrl),
       .bus_num_f0_i         ({8{1'b0}}      ),
       .device_num_f0_i      ({5{1'b0}}   ),
       .max_payload_size_i   ({3{1'b0}}),
       .rd_req_size_i        ({3{1'b0}}     ),
       .bus_master_en_pf_i   ({1{1'b0}}),
       .bus_master_en_vf_i   ({32{1'b0}})
   );



/// arbiter

   altpcieav_256_rp_arbiter arbiter_inst (
      .Clk_i                      (Clk_i),
      .Rstn_i                     (Rstn_i[8]),
      .TxsArbReq_i                (txs_arb_req),
      .RxmArbReq_i                (1'b0),
      .HPRxmArbReq_i              (hprxm_req),
      .DMAWrArbReq_i              (1'b0), // Write DMA does not obey arbiter
      .DMARdArbReq_i              (1'b0),
      .TxsArbGrant_o              (txs_granted),
      .RxmArbGrant_o              (),
      .HPRxmArbGrant_o            (hprxm_granted),
      .DMAWrArbGrant_o            (),
      .DMARdArbGrant_o            ()
   );

// CRA module

generate begin:CRA_GEN
  if(enable_cra_hwtcl == 1) begin
    altpcie_256_control_register
      #(
            .INTENDED_DEVICE_FAMILY     (DEVICE_FAMILY),
            .CG_NUM_A2P_MAILBOX         (8),
            .CG_NUM_P2A_MAILBOX         (8),
            .CG_ENABLE_A2P_INTERRUPT    (0),
            .port_type_hwtcl            (port_type_hwtcl)
        )
    cntrl_reg
       (
   // Avalon Interface signals (all synchronous to CraClk_i)
        .CraClk_i               (Clk_i ),
        .CraRstn_i              (Rstn_i[8] ),
        .CraChipSelect_i        (AvCraChipSelect_i ),
        .CraAddress_i           (AvCraAddress_i[13:2] ),
        .CraByteEnable_i        (AvCraByteEnable_i ),
        .CraRead_i              (AvCraRead_i ),
        .CraReadData_o          (AvCraReadData_o  ),
        .CraWrite_i             (AvCraWrite_i  ),
        .CraWriteData_i         (AvCraWriteData_i  ),
        .CraWaitRequest_o       (AvCraWaitRequest_o ),
   // PCI Bus, Status, Control and Error Signals
   // Most synchronous to PciClk_i (execpt async Rstn and Intan)
   // Currently this interface is not used
        .PciClk_i               (Clk_i ),
        .PciRstn_i              (Rstn_i[8] ),
        .PciIntan_i             (1'b1),
        .PciComp_Stat_Reg_i     ({6{1'b0}}),
        .PciComp_lirqn_o        (),
        .MsiReq_o               (),
        .MsiAck_i               (1'b0),
        .MsiTc_o                (),
        .MsiNum_o               (),
        .PciNonpDataDiscardErr_i(1'b0),
        .PciMstrWriteFail_i     (1'b0),
        .PciMstrReadFail_i      (1'b0),
        .PciMstrWritePndg_i     (1'b0),
        .PciComp_MstrEnb_i      (1'b1),
   // Avalon Interrupt Signals
   // All synchronous to CraClk_i
        .CraIrq_o               (AvCraIrq_o),
        .RxmIrq_i               (AvRxmIrq_i),
        .RxmIrqNum_i            (),
   // Modified Avalon signals to the Address Translation logic
   // All synchronous to CraClk_i
   // Currently this interface is not used
        .AdTrWriteReqVld_o      (),
        .AdTrReadReqVld_o       (),
        .AdTrAddress_o          (),
        .AdTrWriteData_o        (),
        .AdTrByteEnable_o       (),
        .AdTrReadData_i         ({32{1'b0}}),
        .AdTrReadDataVld_i      (1'b0),
   // Signalized parameters used for basic configuration
   // Treated as static signals
   // Currently this interface is not used
        .cg_common_clock_mode_i (1'b1),
        .PciRuptEnable_o        (),
        .A2PMbWriteReq_o        (),
        .A2PMbWriteAddr_o       (),

    // Rp mode interface
        .TxRpFifoRdReq_i         (rp_tx_tlp_rdreq),
        .TxRpFifoData_o          (tx_fifo_data_from_cra ),
        .RpTLPReady_o            (rp_tx_tlp_ready),
        .RxRpFifoWrReq_i         (rx_fifo_rdreq_from_cra),
        .RxRpFifoWrData_i        (rx_fifo_dataq[259:0] ),

        .AvalonIrqReq_i          ({rx_fifo_rdreq_from_cra,4'h0}),
        .TxBufferEmpty_i         (1'b0),

        .CfgAddr_i               (HipCfgAddr_i_r ),
        .CfgFunc_i               (HipCfgFunc_i_r ),
        .CfgCtl_i                (HipCfgCtl_i_r),
        .CurrentSpeed_i          (CurrentSpeed_i),
        .LaneAct_i               (LaneAct_i),
        .Ltssm_i                 (Ltssm_i)

   ) ;


   //Create tx_fifo_wrreq_from_cra
   //send rd_request when rp_tx_tlp_ready and ~txs_granted
   //rp_tx_tlp_ready ready de-asserts one clock after seeing rd_request
   //Next read request creation should be gated for one clock
   assign rp_tx_tlp_rdreq = (rp_tx_tlp_ready & ~txs_granted) & (~tx_fifo_wrreq_from_cra);
   always_ff @ (posedge Clk_i) begin
     if(~Rstn_i[8])
       tx_fifo_wrreq_from_cra  <= 1'b0;
     else
       tx_fifo_wrreq_from_cra  <= rp_tx_tlp_rdreq;
   end
   //gate TXS request reaching to arbiter if CRA write is in process
   assign txs_arb_req = txs_req & (~tx_fifo_wrreq_from_cra) ;
   //Create rp_rx_tlp_rdreq
   //send rd_request when rx fifo is not empty and TLP  tag is between 16-31
   assign rp_rx_tlp_rdreq = ((rx_fifo_count != 0) & (rx_fifo_dataq[77:76] == 2'b01)) & (~rx_fifo_rdreq_from_cra);

   always_ff @ (posedge Clk_i) begin
     if(~Rstn_i[8])
       rx_fifo_rdreq_from_cra  <= 1'b0;
     else
       rx_fifo_rdreq_from_cra  <= rp_rx_tlp_rdreq;
   end

  end
   else begin
      assign txs_arb_req = txs_req ;
      assign AvCraWaitRequest_o = 1'b1;
      assign AvCraReadData_o    = 32'h0;
      assign AvCraIrq_o         = 1'b0;
      assign rx_fifo_rdreq_from_cra = 1'b0;
      assign tx_fifo_wrreq_from_cra = 1'b0;
      assign tx_fifo_data_from_cra = {260{1'b0}};
   end
 end
endgenerate


assign HipCplPending_o   = 1'b0;
assign rx_fifo_rdreq     = rx_fifo_rdreq_from_txs | rx_fifo_rdreq_from_hprxm | rx_fifo_rdreq_from_cra;
//assign tx_fifo_wrreq     = tx_fifo_wrreq_from_rxm | tx_fifo_wrreq_from_txs | tx_fifo_wrreq_from_rd_dma | tx_fifo_wrreq_from_wr_dma;
//assign tx_fifo_data      = txs_granted? tx_fifo_data_from_txs :  rxm_granted? tx_fifo_data_from_rxm : rd_dma_granted? tx_fifo_data_from_rd_dma : tx_fifo_data_from_wr_dma;
assign tx_fifo_wrreq =  tx_fifo_wrreq_from_hprxm | insert_side_tlp;
generate begin : g_sriov
  if (SRIOV_EN)
    assign tx_fifo_data = insert_side_tlp ? {{1+PFCNT_WD+VFCNT_WD{1'b0}},tx_side_fifo_output} : tx_fifo_data_from_hprxm ;
  else
   assign tx_fifo_data = insert_side_tlp ? tx_side_fifo_output : tx_fifo_data_from_hprxm ;
end
endgenerate


/// Tx side buffer to hold TXS and Read TLP for simultaneous operation
/// Leting the write have exclusive right the TX output buffer
/// The side buffer will be emptied into the Tx output buffer when the Write DMA is in idle cycle

generate begin : g_tx_side_fifo
   if (dma_use_scfifo_ext>0) begin
      wire [4:0] tx_side_fifo_count_ext;
      reg [2:0] Rst_i_sync;
      always_ff @ (posedge Clk_i or negedge Rstn_i[2]) begin
         if(~Rstn_i[2]) begin
            Rst_i_sync<=3'h7;
         end
         else begin
            Rst_i_sync[2]<=Rst_i_sync[1];
            Rst_i_sync[1]<=Rst_i_sync[0];
            Rst_i_sync[0]<=1'b0;
         end
      end
      if (dma_use_scfifo_ext==1) begin // Family=A10
         altpcie_scfifo_s10   #(
               .WIDTH          (260), // typical 20,40,60,80
               .NUM_FIFO32     (0)    // Number of 32 DEEP FIFO; Valid Range 1,2,3,4, when 0 only 16 deep
         )   tx_side_fifo      (
               .clk            (Clk_i),
               .sclr           (Rst_i_sync[2]),
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
               .sclr           (Rst_i_sync[2]),
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
      altpcie_256_rp_fifo #(
          .FIFO_DEPTH      ( 16),
          .DATA_WIDTH      ( 260)
          ) tx_side_fifo   (
            .clk           ( Clk_i),
            .rstn          ( Rstn_i[9]),
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


 always_ff @ (posedge Clk_i or negedge Rstn_i[8])
     begin
       if(~Rstn_i[8])
     begin
         tx_side_fifo_wrreq_r <= 1'h0;
         tx_side_fifo_input_r <= 260'h0;
     end
       else
     begin
         tx_side_fifo_wrreq_r <= tx_side_fifo_wrreq;
         tx_side_fifo_input_r <= tx_side_fifo_input;
      end
     end

assign tx_side_fifo_wrreq =  txs_granted? tx_fifo_wrreq_from_txs : tx_fifo_wrreq_from_cra ;
assign tx_side_fifo_input =  txs_granted? tx_fifo_data_from_txs : tx_fifo_data_from_cra;



/// insert TLP when the idle counter is 0 or 1
// In the case of 128 bit ifc there can be a 2 cycle Txs transaction. Read out only when the entire transaction can be accomodated in 2 cycles
assign insert_side_tlp = (tx_fifo_count < 4'hD)  & (~tx_side_fifo_empty );
assign tx_side_fifo_rdreq = insert_side_tlp;
assign tx_side_fifo_empty = (tx_side_fifo_count == 0);


//==========================
// Unused outputs
assign HipRxStMask_o = 1'b0;
assign IntxAck_o     = 1'b0;


endmodule

