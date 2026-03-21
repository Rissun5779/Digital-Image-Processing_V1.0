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


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module altpcie_256_sriov_dma_avmm_hwtcl # (
    // System parameters for HWTCL
      parameter INTENDED_DEVICE_FAMILY              = "Stratix V",
      parameter lane_mask_hwtcl                  = "x8",
      parameter gen123_lane_rate_mode_hwtcl      = "Gen1 (2.5 Gbps)",
      parameter port_type_hwtcl                  = "Native endpoint",
      parameter set_pld_clk_x1_625MHz_hwtcl      = 0,
      parameter use_atx_pll_hwtcl                = 0, // Use to derive coreclkout frequency
      parameter multiple_packets_per_cycle_hwtcl = 0,

      // Avalon-MM DMA parameters
      parameter wr_dma_size_mask_hwtcl           = 8,
      parameter rd_dma_size_mask_hwtcl           = 8,

    // Avalon-ST
      parameter port_width_data_hwtcl            = 256,
      parameter port_width_be_hwtcl              = 32,

     // SR-IOV
      parameter SR_IOV_SUPPORT         = 1,
      parameter ARI_SUPPORT            = 1,
      parameter ACTIVE_VFS             = 1,   // 0 = No VF, 1=2VFs, 2=4VFs, 3=8VFs, 4=16VFs.. => Number of active VFs being used
      parameter TOTAL_PF_COUNT         = 2,   // Number of Physical Functions (1 or 2)
      parameter TOTAL_VF_COUNT         = 128, // 0 - 7 when ARI is not supported.
                                              // 4 - 128 in steps of 4 when ARI is supported.
      parameter PF0_VF_COUNT            = 64, // Qsys derived value: Number of VFs attached to PF 0
      parameter PF1_VF_COUNT            = 64, // Qsys derived value: Number of VFs attached to PF 0
      parameter PF0_BAR0_TYPE           = 64, // 32 = 32-bit addressing,  64 = 64-bit addressing
      parameter PF0_BAR1_TYPE           = 1,  // 32 = 32-bit addressing
      parameter PF0_BAR2_TYPE           = 32, // 32 = 32-bit addressing,  64 = 64-bit addressing
      parameter PF0_BAR3_TYPE           = 32, // 32 = 32-bit addressing
      parameter PF0_BAR4_TYPE           = 32, // 32 = 32-bit addressing,  64 = 64-bit addressing
      parameter PF0_BAR5_TYPE           = 32, // 32 = 32-bit addressing
      parameter PF0_BAR0_PRESENT        = 1,  // 0 = not present, 1 = present
      parameter PF0_BAR1_PRESENT        = 0,  // 0 = not present, 1 = present
      parameter PF0_BAR2_PRESENT        = 0,  // 0 = not present, 1 = present
      parameter PF0_BAR3_PRESENT        = 0,  // 0 = not present, 1 = present
      parameter PF0_BAR4_PRESENT        = 0,  // 0 = not present, 1 = present
      parameter PF0_BAR5_PRESENT        = 0,  // 0 = not present, 1 = present
      parameter PF0_BAR0_SIZE           = 12, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 31 = 2G
      parameter PF0_BAR1_SIZE           = 12, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 31 = 2G
      parameter PF0_BAR2_SIZE           = 12, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 31 = 2G
      parameter PF0_BAR3_SIZE           = 12, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 31 = 2G
      parameter PF0_BAR4_SIZE           = 12, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 31 = 2G
      parameter PF0_BAR5_SIZE           = 12, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 31 = 2G
      parameter PF0_VF_BAR0_PRESENT        = 1,  // 0 = not present, 1 = present
      parameter PF0_VF_BAR1_PRESENT        = 0,  // 0 = not present, 1 = present
      parameter PF0_VF_BAR2_PRESENT        = 0,  // 0 = not present, 1 = present
      parameter PF0_VF_BAR3_PRESENT        = 0,  // 0 = not present, 1 = present
      parameter PF0_VF_BAR4_PRESENT        = 0,  // 0 = not present, 1 = present
      parameter PF0_VF_BAR5_PRESENT        = 0,  // 0 = not present, 1 = present
      parameter PF0_VF_BAR0_TYPE           = 64,
      parameter PF0_VF_BAR1_TYPE           = 1,
      parameter PF0_VF_BAR2_TYPE           = 32,
      parameter PF0_VF_BAR3_TYPE           = 32,
      parameter PF0_VF_BAR4_TYPE           = 32,
      parameter PF0_VF_BAR5_TYPE           = 32,
      parameter PF0_VF_BAR0_SIZE           = 12, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 31 = 2G
      parameter PF0_VF_BAR1_SIZE           = 12, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 31 = 2G
      parameter PF0_VF_BAR2_SIZE           = 12, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 31 = 2G
      parameter PF0_VF_BAR3_SIZE           = 12, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 31 = 2G
      parameter PF0_VF_BAR4_SIZE           = 12, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 31 = 2G
      parameter PF0_VF_BAR5_SIZE           = 12, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 31 = 2G
      /// DMA AVMM Bridge Parameters
      parameter avmm_width_hwtcl           = 256,
      //parameter avmm_burst_width_hwtcl = 7,
      parameter DMA_BRST_CNT_W             = 6,
      parameter DMA_WIDTH                  = port_width_data_hwtcl,
      parameter DMA_BE_WIDTH               = port_width_be_hwtcl,
      parameter TX_S_ADDR_WIDTH            = 32,
      parameter COMPLETER_ONLY_HWTCL       = 0,
      parameter enable_rxm_burst_hwtcl     = 0,
      parameter enable_cra_hwtcl           = 0,

      // New parameters that are not defined in pcie_256_avmm_parameter.tcl
      parameter ENABLE_HPRXM               = 0, // redundant
      parameter NUM_TAG                    = 16,
      parameter RXDATA_WIDTH               = 168 ,
      parameter RXFIFO_DATA_WIDTH          = 274


) (

      // Reset signals

      input             reset_status,
      input             serdes_pll_locked,
      input             pld_clk_inuse,
      output            pld_core_ready,
      input             testin_zero,

      // Clock
      input             coreclkout_hip,
      output            pld_clk_hip, //pld_clk_hip,
      output            app_rstn_o,   // reset to fabric

      //###################################################################################
      // Legacy and MSI interrupt signals
      //###################################################################################
      output                  app_int_sts_a,
      output                  app_int_sts_b,
      output                  app_int_sts_c,
      output                  app_int_sts_d,
      output                  app_int_sts_fn, // Function Num associated with the Legacy interrupt request
      input                   app_int_ack,

      output                  app_msi_req,
      input [1:0]             app_msi_status, // Execution status of MSI interrupt request, common for all Functions
                             // 00 = MSI message sent, 01 = Pending bit set and no message sent, 10 = error
      input                   app_msi_ack,
      output   [7 : 0]        app_msi_req_fn,
      output   [4 : 0]        app_msi_num,
      output   [2 : 0]        app_msi_tc,

      output                  app_msix_req, // MSIX interrupt request, common for all Functions
      input                   app_msix_ack, // Ack to MSIX interrupt request, common for all Functions
      input                   app_msix_err, // Error status for MSIX interrupt request, common for all Functions
      output [63:0]           app_msix_addr,  // Address to be sent in MSIX interrupt message
      output [31:0]           app_msix_data,  // Data to be sent in MSIX interrupt message
      output  [1:0]           app_int_pend_status,  // Interrupt pending stats from Function
      output                  app_msi_pending_bit_write_en, // Write enable for bit in the MSI Pending Bit Register
      output                  app_msi_pending_bit_write_data, // Write data for bit in the MSI Pending Bit Register

      input [TOTAL_PF_COUNT-1:0]    app_intx_disable,           // INTX Disable from PCI Command Register of PFs
   //========================================================================
   // PF MSI Capability Register Outputs
   //========================================================================
      input [TOTAL_PF_COUNT*64-1:0] app_msi_addr_pf,// MSI Address Register setting of PFs
      input [TOTAL_PF_COUNT*16-1:0] app_msi_data_pf,// MSI Data Register setting of PFs
      input [TOTAL_PF_COUNT*32-1:0] app_msi_mask_pf,// MSI Mask Register setting of PFs
      input [TOTAL_PF_COUNT*32-1:0] app_msi_pending_pf,// MSI Pending Bit Register setting of PFs
      input [TOTAL_PF_COUNT-1:0]    app_msi_enable_pf,          // MSI Enable setting of PFs
      input [TOTAL_PF_COUNT*3-1:0]  app_msi_multi_msg_enable_pf,// MSI Multiple Msg field setting of PFs
   //========================================================================
   // MSIX Capability Register Outputs
   //========================================================================
      input [TOTAL_PF_COUNT-1:0]    app_msix_en_pf,             // MSIX Enable bit from MSIX Control Reg of PFs
      input [TOTAL_PF_COUNT-1:0]    app_msix_fn_mask_pf,        // MSIX Function Mask bit from MSIX Control Reg of PFs
      input [TOTAL_VF_COUNT-1:0]    app_msix_en_vf,             // MSIX Enable bits from MSIX Control Reg of VFs
      input [TOTAL_VF_COUNT-1:0]    app_msix_fn_mask_vf,        // MSIX Function Mask bits from MSIX Control Reg of VFs

      //###################################################################################
      // LMI
      //###################################################################################

      output   [11 : 0]   lmi_addr,
      output   [ 8 : 0]   lmi_func,  // [7:0] =  Function Number,
                                     // [ 8] = 0 => access to Hard IP register
                                     // [ 8] = 1 => access to SR-IOV bridge config space
      output   [31 : 0]   lmi_din,
      output              lmi_rden,
      output              lmi_wren,

      input               lmi_ack,
      input    [31 : 0]   lmi_dout,

      //##############################################
      // Avalon-ST RX
      input   [port_width_be_hwtcl-1  :0]              rx_st_parity,
      input   [port_width_data_hwtcl-1:0]              rx_st_data,
      output                                           rx_st_ready,
      input   [multiple_packets_per_cycle_hwtcl:0]     rx_st_sop,
      input   [multiple_packets_per_cycle_hwtcl:0]     rx_st_valid,
      input   [1:0]                                    rx_st_empty,
      input   [multiple_packets_per_cycle_hwtcl:0]     rx_st_eop,
      input   [multiple_packets_per_cycle_hwtcl:0]     rx_st_err,
      output                                           rx_st_mask,


      //##############################################
      // Avalon-ST TX
      output   [port_width_data_hwtcl-1  : 0]          tx_st_data,
      output   [1:0]                                   tx_st_empty,
      output   [multiple_packets_per_cycle_hwtcl:0]    tx_st_eop,
      output   [multiple_packets_per_cycle_hwtcl:0]    tx_st_err,
      output   [multiple_packets_per_cycle_hwtcl:0]    tx_st_sop,
      output   [multiple_packets_per_cycle_hwtcl:0]    tx_st_valid,
      output   [port_width_be_hwtcl-1:0]               tx_st_parity,
      input                                            tx_st_ready,
      input                                            tx_fifo_empty,


      // hip_sriov_completion
      output   [6 :0]         cpl_err,
      output   [7 :0]         cpl_err_fn,
      output   [TOTAL_PF_COUNT-1:0]  cpl_pending_pf, // Completion pending status from PF 0
      output   [TOTAL_VF_COUNT-1:0]  cpl_pending_vf, // Completion pending status from VFs
      output   [127:0]        log_hdr,
   //==========================
   // SR-IOV Cfg_Status Interface
   //==========================
      // BAR hit signals
   input   [7:0]              rx_st_bar_hit_tlp0_i,     // BAR hit information for first TLP in this cycle
   input   [7:0]              rx_st_bar_hit_tlp1_i,     // BAR hit information for second TLP in this cycle => Not used for Phase1
   input   [7:0]              rx_st_bar_hit_fn_tlp0_i, // SR-IOV=> Target Function for first TLP associated with HipRxStBarDec1_i bar
   input   [7:0]              rx_st_bar_hit_fn_tlp1_i, // Target Function for second TLP in this cycle => Not used for Phase1

   //=========================================
   // Configuration Status Interface signals
   //=========================================
   input   [7:0]              bus_num_f0_i,       // Captured bus number for PF0
   input   [7:0]              bus_num_f1_i,       // Captured bus number for Function 1
   input   [4:0]              device_num_f0_i,    // Captured device number for PF0
   input [4:0]                device_num_f1_i,    // Captured device number for Function 1 (set to 0 for an ARI device)
   input [TOTAL_PF_COUNT-1:0] mem_space_en_pf_i,  // Memory Space Enable for PFs
   input [TOTAL_PF_COUNT-1:0] bus_master_en_pf_i, // Bus Master Enable for PFs
   input [TOTAL_PF_COUNT-1:0] mem_space_en_vf_i,  // Memory Space Enable for VFs
                                                  // (common for all VFs attached to the same PF)
   input [TOTAL_VF_COUNT-1:0] bus_master_en_vf_i, // Bus Master Enable for VFs
   input [7:0]                pf0_num_vfs_i,      // Number of enabled VFs for PF 0
   input [7:0]                pf1_num_vfs_i,      // Number of enabled VFs for PF 1
   input   [2:0]              max_payload_size_i, // Max payload size from Device Control Register of PF 0
   input   [2:0]              rd_req_size_i,      // Read Request Size from Device Control Register of PF 0


   //###################################################################################
   // FLR Interface
   //###################################################################################
    input   [TOTAL_PF_COUNT-1:0]  flr_active_pf,    // FLR status for PF 0
    input   [TOTAL_VF_COUNT-1:0]  flr_active_vf, // FLR status for VFs
    output  [TOTAL_PF_COUNT-1:0]  flr_completed_pf, // Indication from user to re-enable PF 0 after FLR
    output  [TOTAL_VF_COUNT-1:0]  flr_completed_vf, // Indication from user to re-enable VFs after FLR

   //###################################################################################
      // input   HIP Status signals
      input                  derr_cor_ext_rcv,
      input                  derr_cor_ext_rpl,
      input                  derr_rpl,
      input                  rx_par_err ,
      input   [1:0]          tx_par_err ,
      input                  cfg_par_err,
      input                  dlup,
      input                  dlup_exit,
      input                  ev128ns,
      input                  ev1us,
      input                  hotrst_exit,
      input   [3 : 0]        int_status,
      input                  l2_exit,
      input   [3:0]          lane_act,
      input   [4 : 0]        ltssmstate,
      input   [7:0]          ko_cpl_spc_header,
      input   [11:0]         ko_cpl_spc_data,
      input                  rxfc_cplbuf_ovf,


      // output  HIP status signals
      output                 derr_cor_ext_rcv_drv,
      output                 derr_cor_ext_rpl_drv,
      output                 derr_rpl_drv,
      output                 dlup_drv,
      output                 dlup_exit_drv,
      output                 ev128ns_drv,
      output                 ev1us_drv,
      output                 hotrst_exit_drv,
      output  [3 : 0]        int_status_drv,
      output                 l2_exit_drv,
      output  [3:0]          lane_act_drv,
      output  [4 : 0]        ltssmstate_drv,
      output                 rx_par_err_drv,
      output  [1:0]          tx_par_err_drv,
      output                 cfg_par_err_drv,
      output  [7:0]          ko_cpl_spc_header_drv,
      output  [11:0]         ko_cpl_spc_data_drv,

      input                   sim_pipe_pclk_out, // Unused

      // HIP control signals
      output   [4 : 0]        hpg_ctrler,

      //==========================
      // tx credits
      //==========================
      // Stratix V ports
      input   [11 : 0]       tx_cred_datafccp,
      input   [11 : 0]       tx_cred_datafcnp,
      input   [11 : 0]       tx_cred_datafcp,
      input   [5 : 0]        tx_cred_fchipcons,
      input   [5 : 0]        tx_cred_fcinfinite,
      input   [7 : 0]        tx_cred_hdrfccp,
      input   [7 : 0]        tx_cred_hdrfcnp,
      input   [7 : 0]        tx_cred_hdrfcp,

      // Arria 10 ports
      input   [11 : 0]       tx_cred_data_fc,
      input   [7 : 0]        tx_cred_hdr_fc,
      output  [1 : 0]        tx_cred_fc_sel,
      output                 tx_cons_cred_sel,

//=============================================================
// AVMM: DMA-Write fetching data from application
      output                             WrDmaRead_o,
      output     [63:0]                  WrDmaAddress_o,
      output     [DMA_BRST_CNT_W-1:0]    WrDmaBurstCount_o,
      input                              WrDmaWaitRequest_i,
      input                              WrDmaReadDataValid_i,
      input      [DMA_WIDTH-1:0]         WrDmaReadData_i,


// AVMM: DMA-Read master transfer read data to application
      output                             RdDmaWrite_o,
      output     [63:0]                  RdDmaAddress_o,
      output     [DMA_WIDTH-1:0]         RdDmaWriteData_o,
      output     [DMA_BRST_CNT_W-1:0]    RdDmaBurstCount_o,
      output     [DMA_BE_WIDTH-1:0]      RdDmaWriteEnable_o,
      input                              RdDmaWaitRequest_i,

      //================================================================
      // The following interfaces are to/from Descriptor Controller
      //================================================================

      // Descriptor Controller send descriptor to DMA-RD via AST Rx port
      output                             RdDmaRxReady_o,
      input       [RXDATA_WIDTH-1:0]     RdDmaRxData_i,
      input                              RdDmaRxValid_i,

      // DMA_Read Status to Descriptor controller via AST Tx port
      output      [31:0]                 RdDmaTxData_o,
      output                             RdDmaTxValid_o,

      // Descriptor Controller send descriptor to DMA-Write via AST Rx port
      output                             WrDmaRxReady_o,
      input       [RXDATA_WIDTH-1:0]     WrDmaRxData_i,
      input                              WrDmaRxValid_i,

      // DMA-Write status to Descriptor Controller via AST Tx port
      output      [31:0]                 WrDmaTxData_o,
      output                             WrDmaTxValid_o,

      //=======================================================================================
      // Avalon Tx Slave interface: allow application  to send upstream RD/WR TLP to host
      input                                   TxsChipSelect_i,
      input                                   TxsRead_i,
      input                                   TxsWrite_i,
      input    [31:0]                         TxsWriteData_i,
      input    [TX_S_ADDR_WIDTH+8-1:0]        TxsAddress_i,
      input    [3:0]                          TxsByteEnable_i,
      output                                  TxsReadDataValid_o,
      output   [31:0]                         TxsReadData_o,
      output                                  TxsWaitRequest_o,

      //=========================================================================
      // Avalon RX Master: allow host to read/write to application memory
      //=========================================================================
      // Avalon Rx Master interface 0: PF0 BAR0
      output                                  RxmWrite_0_o,
      output  [PF0_BAR0_TYPE-1:0]             RxmAddress_0_o,
      output  [31:0]                          RxmWriteData_0_o,
      output  [ 3:0]                          RxmByteEnable_0_o,
      input                                   RxmWaitRequest_0_i,
      output                                  RxmRead_0_o,
      input    [31:0]                         RxmReadData_0_i,
      input                                   RxmReadDataValid_0_i,

      // Avalon Rx Master interface 1: PF0 BAR1
      output                                  RxmWrite_1_o,
      output  [PF0_BAR1_TYPE-1:0]             RxmAddress_1_o,
      output  [31:0]                          RxmWriteData_1_o,
      output  [ 3:0]                          RxmByteEnable_1_o,
      input                                   RxmWaitRequest_1_i,
      output                                  RxmRead_1_o,
      input    [31:0]                         RxmReadData_1_i,
      input                                   RxmReadDataValid_1_i,

      // Avalon Rx Master interface 2: PF0 BAR2
      output                                  RxmWrite_2_o,
      output  [PF0_BAR2_TYPE-1:0]             RxmAddress_2_o,
      output  [31:0]                          RxmWriteData_2_o,
      output  [ 3:0]                          RxmByteEnable_2_o,
      input                                   RxmWaitRequest_2_i,
      output                                  RxmRead_2_o,
      input    [31:0]                         RxmReadData_2_i,
      input                                   RxmReadDataValid_2_i,

      // Avalon Rx Master interface 3: PF0 BAR3
      output                                  RxmWrite_3_o,
      output  [PF0_BAR3_TYPE-1:0]             RxmAddress_3_o,
      output  [31:0]                          RxmWriteData_3_o,
      output  [ 3:0]                          RxmByteEnable_3_o,
      input                                   RxmWaitRequest_3_i,
      output                                  RxmRead_3_o,
      input    [31:0]                         RxmReadData_3_i,
      input                                   RxmReadDataValid_3_i,

      // Avalon Rx Master interface 4: PF0 BAR4
      output                                  RxmWrite_4_o,
      output  [PF0_BAR4_TYPE-1:0]             RxmAddress_4_o,
      output  [31:0]                          RxmWriteData_4_o,
      output  [ 3:0]                          RxmByteEnable_4_o,
      input                                   RxmWaitRequest_4_i,
      output                                  RxmRead_4_o,
      input    [31:0]                         RxmReadData_4_i,
      input                                   RxmReadDataValid_4_i,

      // Avalon Rx Master interface 5: PF0 BAR5
      output                                  RxmWrite_5_o,
      output  [PF0_BAR5_TYPE-1:0]             RxmAddress_5_o,
      output  [31:0]                          RxmWriteData_5_o,
      output  [ 3:0]                          RxmByteEnable_5_o,
      input                                   RxmWaitRequest_5_i,
      output                                  RxmRead_5_o,
      input    [31:0]                         RxmReadData_5_i,
      input                                   RxmReadDataValid_5_i,

      //==============================================
      // PF0 VF RXM Master Port, one for each BAR
      // Avalon Rx Master interface 0
      output                                  pf0_vf_RxmWrite_0_o,
      output  [PF0_VF_BAR0_TYPE-1:0]          pf0_vf_RxmAddress_0_o,
      output  [31:0]                          pf0_vf_RxmWriteData_0_o,
      output  [3:0]                           pf0_vf_RxmByteEnable_0_o,
      input                                   pf0_vf_RxmWaitRequest_0_i,
      output                                  pf0_vf_RxmRead_0_o,
      input   [31:0]                          pf0_vf_RxmReadData_0_i,
      input                                   pf0_vf_RxmReadDataValid_0_i,

      // Aval on Rx Master interface 1
      output                                  pf0_vf_RxmWrite_1_o,
      output  [PF0_VF_BAR1_TYPE-1:0]          pf0_vf_RxmAddress_1_o,
      output  [31:0]                          pf0_vf_RxmWriteData_1_o,
      output  [3:0]                           pf0_vf_RxmByteEnable_1_o,
      input                                   pf0_vf_RxmWaitRequest_1_i,
      output                                  pf0_vf_RxmRead_1_o,
      input   [31:0]                          pf0_vf_RxmReadData_1_i,
      input                                   pf0_vf_RxmReadDataValid_1_i,

      // Aval on Rx Master interface 2
      output                                  pf0_vf_RxmWrite_2_o,
      output  [PF0_VF_BAR2_TYPE-1:0]          pf0_vf_RxmAddress_2_o,
      output  [31:0]                          pf0_vf_RxmWriteData_2_o,
      output  [3:0]                           pf0_vf_RxmByteEnable_2_o,
      input                                   pf0_vf_RxmWaitRequest_2_i,
      output                                  pf0_vf_RxmRead_2_o,
      input   [31:0]                          pf0_vf_RxmReadData_2_i,
      input                                   pf0_vf_RxmReadDataValid_2_i,

      // Aval on Rx Master interface 3
      output                                  pf0_vf_RxmWrite_3_o,
      output  [PF0_VF_BAR3_TYPE-1:0]          pf0_vf_RxmAddress_3_o,
      output  [31:0]                          pf0_vf_RxmWriteData_3_o,
      output  [3:0]                           pf0_vf_RxmByteEnable_3_o,
      input                                   pf0_vf_RxmWaitRequest_3_i,
      output                                  pf0_vf_RxmRead_3_o,
      input   [31:0]                          pf0_vf_RxmReadData_3_i,
      input                                   pf0_vf_RxmReadDataValid_3_i,

      // Aval on Rx Master interface 4
      output                                  pf0_vf_RxmWrite_4_o,
      output  [PF0_VF_BAR4_TYPE-1:0]          pf0_vf_RxmAddress_4_o,
      output  [31:0]                          pf0_vf_RxmWriteData_4_o,
      output  [3:0]                           pf0_vf_RxmByteEnable_4_o,
      input                                   pf0_vf_RxmWaitRequest_4_i,
      output                                  pf0_vf_RxmRead_4_o,
      input   [31:0]                          pf0_vf_RxmReadData_4_i,
      input                                   pf0_vf_RxmReadDataValid_4_i,

      // Aval on Rx Master interface 5
      output                                  pf0_vf_RxmWrite_5_o,
      output  [PF0_VF_BAR5_TYPE-1:0]              pf0_vf_RxmAddress_5_o,
      output  [31:0]                          pf0_vf_RxmWriteData_5_o,
      output  [3:0]                           pf0_vf_RxmByteEnable_5_o,
      input                                   pf0_vf_RxmWaitRequest_5_i,
      output                                  pf0_vf_RxmRead_5_o,
      input   [31:0]                          pf0_vf_RxmReadData_5_i,
      input                                   pf0_vf_RxmReadDataValid_5_i,

      //=========================================================================
      // Avalon Control Register Access (CRA)lave (This is 32-bit interface)
      input                                   CraChipSelect_i,
      input                                   CraRead_i,
      input                                   CraWrite_i,
      input    [31:0]                         CraWriteData_i,
      input    [9:0]                          CraAddress_i,
      input    [3:0]                          CraByteEnable_i,
      output  [31:0]                          CraReadData_o,      // This comes from Rx Completion to be returned to Avalon master
      output                                  CraWaitRequest_o,
      output                                  CraIrq_o


);


  wire       reset_status_sync_pldclk;
  wire       [9:0] app_rstn_9w;
  wire       pld_clk;
  wire       npor_int;

//// instantiate the Avalon-MM bridge logic

altpcieav_256_app
  # (
    .DEVICE_FAMILY                  (INTENDED_DEVICE_FAMILY),
    .DMA_WIDTH                      (DMA_WIDTH             ),
    .ENABLE_HPRXM                   (ENABLE_HPRXM          ),
    .DMA_BE_WIDTH                   (DMA_BE_WIDTH          ),
    .DMA_BRST_CNT_W                 (DMA_BRST_CNT_W        ),
    .RDDMA_AVL_ADDR_WIDTH           (rd_dma_size_mask_hwtcl), //derive in HWTCL
    .WRDMA_AVL_ADDR_WIDTH           (wr_dma_size_mask_hwtcl), //derive in HWTCL
    .TX_S_ADDR_WIDTH                (TX_S_ADDR_WIDTH),
    .COMPLETER_ONLY_HWTCL           (COMPLETER_ONLY_HWTCL  ),
    .enable_rxm_burst_hwtcl         (enable_rxm_burst_hwtcl),
    .enable_cra_hwtcl               (enable_cra_hwtcl      ),
    .BAR0_SIZE_MASK                 (PF0_BAR0_SIZE),
    .BAR1_SIZE_MASK                 (PF0_BAR1_SIZE),
    .BAR2_SIZE_MASK                 (PF0_BAR2_SIZE),
    .BAR3_SIZE_MASK                 (PF0_BAR3_SIZE),
    .BAR4_SIZE_MASK                 (PF0_BAR4_SIZE),
    .BAR5_SIZE_MASK                 (PF0_BAR5_SIZE),
    .BAR0_TYPE                      (PF0_BAR0_TYPE ), // derive in HWTCL
    .BAR1_TYPE                      (PF0_BAR1_TYPE ),
    .BAR2_TYPE                      (PF0_BAR2_TYPE ),
    .BAR3_TYPE                      (PF0_BAR3_TYPE ),
    .BAR4_TYPE                      (PF0_BAR4_TYPE ),
    .BAR5_TYPE                      (PF0_BAR5_TYPE ),
    .SRIOV_EN                       (SR_IOV_SUPPORT ),
    .ARI_EN                         (ARI_SUPPORT),
    .PHASE1                         (1'b0),
	.WRDMA_VERSION_2                (1'b0),
    .ACTIVE_VFS                     (ACTIVE_VFS       ),
    .VF_COUNT                       (PF0_VF_COUNT     ),
    .PF_BAR0_PRESENT                (PF0_BAR0_PRESENT ),
    .PF_BAR1_PRESENT                (PF0_BAR1_PRESENT ),
    .PF_BAR2_PRESENT                (PF0_BAR2_PRESENT ),
    .PF_BAR3_PRESENT                (PF0_BAR3_PRESENT ),
    .PF_BAR4_PRESENT                (PF0_BAR4_PRESENT ),
    .PF_BAR5_PRESENT                (PF0_BAR5_PRESENT ),
    .VF_BAR0_PRESENT                (PF0_VF_BAR0_PRESENT ),
    .VF_BAR1_PRESENT                (PF0_VF_BAR1_PRESENT ),
    .VF_BAR2_PRESENT                (PF0_VF_BAR2_PRESENT ),
    .VF_BAR3_PRESENT                (PF0_VF_BAR3_PRESENT ),
    .VF_BAR4_PRESENT                (PF0_VF_BAR4_PRESENT ),
    .VF_BAR5_PRESENT                (PF0_VF_BAR5_PRESENT ),
    .VF_BAR0_TYPE                   (PF0_VF_BAR0_TYPE    ),
    .VF_BAR1_TYPE                   (PF0_VF_BAR1_TYPE    ),
    .VF_BAR2_TYPE                   (PF0_VF_BAR2_TYPE    ),
    .VF_BAR3_TYPE                   (PF0_VF_BAR3_TYPE    ),
    .VF_BAR4_TYPE                   (PF0_VF_BAR4_TYPE    ),
    .VF_BAR5_TYPE                   (PF0_VF_BAR5_TYPE    ),
    .VF_BAR0_SIZE                   (PF0_VF_BAR0_SIZE    ),
    .VF_BAR1_SIZE                   (PF0_VF_BAR1_SIZE    ),
    .VF_BAR2_SIZE                   (PF0_VF_BAR2_SIZE    ),
    .VF_BAR3_SIZE                   (PF0_VF_BAR3_SIZE    ),
    .VF_BAR4_SIZE                   (PF0_VF_BAR4_SIZE    ),
    .VF_BAR5_SIZE                   (PF0_VF_BAR5_SIZE    ),
    .RXDATA_WIDTH                   (RXDATA_WIDTH        ),
    .RXFIFO_DATA_WIDTH              (RXFIFO_DATA_WIDTH   )
    )
 altpcieav_256_app
  (
    .Clk_i                          (pld_clk),
    .Rstn_i                         ( app_rstn_9w           ),
    .HipRxStReady_o                 ( rx_st_ready           ),
    .HipRxStMask_o                  ( rx_st_mask            ),
    .HipRxStData_i                  ( rx_st_data            ),
    .HipRxStBe_i                    ( 0                     ),
    .HipRxStEmpty_i                 ( rx_st_empty           ),
    .HipRxStErr_i                   ( rx_st_err             ),
    .HipRxStSop_i                   ( rx_st_sop             ),
    .HipRxStEop_i                   ( rx_st_eop             ),
    .HipRxStValid_i                 ( rx_st_valid           ),
    .HipRxStBarDec1_i               ( rx_st_bar_hit_tlp0_i  ),
    .HipTxStReady_i                 ( tx_st_ready           ),
    .HipTxStData_o                  ( tx_st_data            ),
    .HipTxStSop_o                   ( tx_st_sop             ),
    .HipTxStEop_o                   ( tx_st_eop             ),
    .HipTxStEmpty_o                 ( tx_st_empty           ),
    .HipTxStValid_o                 ( tx_st_valid           ),
    .HipCplPending_o                ( ), //cpl_pending
    .rx_st_bar_hit_fn_tlp0_i        ( rx_st_bar_hit_fn_tlp0_i),
    .bus_num_f0_i                   ( bus_num_f0_i           ),
    .device_num_f0_i                ( device_num_f0_i        ),
    .mem_space_en_pf_i              ( mem_space_en_pf_i[0]   ),
    .bus_master_en_pf_i             ( bus_master_en_pf_i[0]  ),
    .mem_space_en_vf_i              ( mem_space_en_vf_i[0]   ),
    .bus_master_en_vf_i             ( bus_master_en_vf_i     ),
    .num_vfs_i                      ( pf0_num_vfs_i          ),
    .max_payload_size_i             ( max_payload_size_i     ),
    .rd_req_size_i                  ( rd_req_size_i          ),


    .AvWrDmaRead_o                  ( WrDmaRead_o           ),
    .AvWrDmaAddress_o               ( WrDmaAddress_o        ),
    .AvWrDmaBurstCount_o            ( WrDmaBurstCount_o     ),
    .AvWrDmaWaitRequest_i           ( WrDmaWaitRequest_i    ),
    .AvWrDmaReadDataValid_i         ( WrDmaReadDataValid_i  ),
    .AvWrDmaReadData_i              ( WrDmaReadData_i       ),
    .AvRdDmaWrite_o                 ( RdDmaWrite_o          ),
    .AvRdDmaAddress_o               ( RdDmaAddress_o        ),
    .AvRdDmaWriteData_o             ( RdDmaWriteData_o      ),
    .AvRdDmaBurstCount_o            ( RdDmaBurstCount_o     ),
    .AvRdDmaWriteEnable_o           ( RdDmaWriteEnable_o    ),
    .AvRdDmaWaitRequest_i           ( RdDmaWaitRequest_i    ),
    .AvRxmWrite_0_o                 ( RxmWrite_0_o          ),
    .AvRxmAddress_0_o               ( RxmAddress_0_o        ),
    .AvRxmWriteData_0_o             ( RxmWriteData_0_o      ),
    .AvRxmByteEnable_0_o            ( RxmByteEnable_0_o     ),
    .AvRxmWaitRequest_0_i           ( RxmWaitRequest_0_i    ),
    .AvRxmRead_0_o                  ( RxmRead_0_o           ),
    .AvRxmReadData_0_i              ( RxmReadData_0_i       ),
    .AvRxmReadDataValid_0_i         ( RxmReadDataValid_0_i  ),
    .AvRxmWrite_1_o                 ( RxmWrite_1_o          ),
    .AvRxmAddress_1_o               ( RxmAddress_1_o        ),
    .AvRxmWriteData_1_o             ( RxmWriteData_1_o      ),
    .AvRxmByteEnable_1_o            ( RxmByteEnable_1_o     ),
    .AvRxmWaitRequest_1_i           ( RxmWaitRequest_1_i    ),
    .AvRxmRead_1_o                  ( RxmRead_1_o           ),
    .AvRxmReadData_1_i              ( RxmReadData_1_i       ),
    .AvRxmReadDataValid_1_i         ( RxmReadDataValid_1_i  ),
    .AvRxmWrite_2_o                 ( RxmWrite_2_o          ),
    .AvRxmAddress_2_o               ( RxmAddress_2_o        ),
    .AvRxmWriteData_2_o             ( RxmWriteData_2_o      ),
    .AvRxmByteEnable_2_o            ( RxmByteEnable_2_o     ),
    .AvRxmWaitRequest_2_i           ( RxmWaitRequest_2_i    ),
    .AvRxmRead_2_o                  ( RxmRead_2_o           ),
    .AvRxmReadData_2_i              ( RxmReadData_2_i       ),
    .AvRxmReadDataValid_2_i         ( RxmReadDataValid_2_i  ),
    .AvRxmWrite_3_o                 ( RxmWrite_3_o          ),
    .AvRxmAddress_3_o               ( RxmAddress_3_o        ),
    .AvRxmWriteData_3_o             ( RxmWriteData_3_o      ),
    .AvRxmByteEnable_3_o            ( RxmByteEnable_3_o     ),
    .AvRxmWaitRequest_3_i           ( RxmWaitRequest_3_i    ),
    .AvRxmRead_3_o                  ( RxmRead_3_o           ),
    .AvRxmReadData_3_i              ( RxmReadData_3_i       ),
    .AvRxmReadDataValid_3_i         ( RxmReadDataValid_3_i  ),
    .AvRxmWrite_4_o                 ( RxmWrite_4_o          ),
    .AvRxmAddress_4_o               ( RxmAddress_4_o        ),
    .AvRxmWriteData_4_o             ( RxmWriteData_4_o      ),
    .AvRxmByteEnable_4_o            ( RxmByteEnable_4_o     ),
    .AvRxmWaitRequest_4_i           ( RxmWaitRequest_4_i    ),
    .AvRxmRead_4_o                  ( RxmRead_4_o           ),
    .AvRxmReadData_4_i              ( RxmReadData_4_i       ),
    .AvRxmReadDataValid_4_i         ( RxmReadDataValid_4_i  ),
    .AvRxmWrite_5_o                 ( RxmWrite_5_o          ),
    .AvRxmAddress_5_o               ( RxmAddress_5_o        ),
    .AvRxmWriteData_5_o             ( RxmWriteData_5_o      ),
    .AvRxmByteEnable_5_o            ( RxmByteEnable_5_o     ),
    .AvRxmWaitRequest_5_i           ( RxmWaitRequest_5_i    ),
    .AvRxmRead_5_o                  ( RxmRead_5_o           ),
    .AvRxmReadData_5_i              ( RxmReadData_5_i       ),
    .AvRxmReadDataValid_5_i         ( RxmReadDataValid_5_i  ),

    // Disable HPRxm Interface
    .AvHPRxmWrite_o                 (  ),
    .AvHPRxmAddress_o               (  ),
    .AvHPRxmWriteData_o             (  ),
    .AvHPRxmByteEnable_o            (  ),
    .AvHPRxmBurstCount_o            (  ),
    .AvHPRxmWaitRequest_i           ( 1'b0 ),
    .AvHPRxmRead_o                  (  ),
    .AvHPRxmReadData_i              ({DMA_WIDTH{1'b0}}),
    .AvHPRxmReadDataValid_i         ( 1'b0 ),

    .pf0_vf_RxmWrite_0_o            ( pf0_vf_RxmWrite_0_o          ),
    .pf0_vf_RxmAddress_0_o          ( pf0_vf_RxmAddress_0_o        ),
    .pf0_vf_RxmWriteData_0_o        ( pf0_vf_RxmWriteData_0_o      ),
    .pf0_vf_RxmByteEnable_0_o       ( pf0_vf_RxmByteEnable_0_o     ),
    .pf0_vf_RxmWaitRequest_0_i      ( pf0_vf_RxmWaitRequest_0_i    ),
    .pf0_vf_RxmRead_0_o             ( pf0_vf_RxmRead_0_o           ),
    .pf0_vf_RxmReadData_0_i         ( pf0_vf_RxmReadData_0_i       ),
    .pf0_vf_RxmReadDataValid_0_i    ( pf0_vf_RxmReadDataValid_0_i  ),
    .pf0_vf_RxmWrite_1_o            ( pf0_vf_RxmWrite_1_o          ),
    .pf0_vf_RxmAddress_1_o          ( pf0_vf_RxmAddress_1_o        ),
    .pf0_vf_RxmWriteData_1_o        ( pf0_vf_RxmWriteData_1_o      ),
    .pf0_vf_RxmByteEnable_1_o       ( pf0_vf_RxmByteEnable_1_o     ),
    .pf0_vf_RxmWaitRequest_1_i      ( pf0_vf_RxmWaitRequest_1_i    ),
    .pf0_vf_RxmRead_1_o             ( pf0_vf_RxmRead_1_o           ),
    .pf0_vf_RxmReadData_1_i         ( pf0_vf_RxmReadData_1_i       ),
    .pf0_vf_RxmReadDataValid_1_i    ( pf0_vf_RxmReadDataValid_1_i  ),
    .pf0_vf_RxmWrite_2_o            ( pf0_vf_RxmWrite_2_o          ),
    .pf0_vf_RxmAddress_2_o          ( pf0_vf_RxmAddress_2_o        ),
    .pf0_vf_RxmWriteData_2_o        ( pf0_vf_RxmWriteData_2_o      ),
    .pf0_vf_RxmByteEnable_2_o       ( pf0_vf_RxmByteEnable_2_o     ),
    .pf0_vf_RxmWaitRequest_2_i      ( pf0_vf_RxmWaitRequest_2_i    ),
    .pf0_vf_RxmRead_2_o             ( pf0_vf_RxmRead_2_o           ),
    .pf0_vf_RxmReadData_2_i         ( pf0_vf_RxmReadData_2_i       ),
    .pf0_vf_RxmReadDataValid_2_i    ( pf0_vf_RxmReadDataValid_2_i  ),
    .pf0_vf_RxmWrite_3_o            ( pf0_vf_RxmWrite_3_o          ),
    .pf0_vf_RxmAddress_3_o          ( pf0_vf_RxmAddress_3_o        ),
    .pf0_vf_RxmWriteData_3_o        ( pf0_vf_RxmWriteData_3_o      ),
    .pf0_vf_RxmByteEnable_3_o       ( pf0_vf_RxmByteEnable_3_o     ),
    .pf0_vf_RxmWaitRequest_3_i      ( pf0_vf_RxmWaitRequest_3_i    ),
    .pf0_vf_RxmRead_3_o             ( pf0_vf_RxmRead_3_o           ),
    .pf0_vf_RxmReadData_3_i         ( pf0_vf_RxmReadData_3_i       ),
    .pf0_vf_RxmReadDataValid_3_i    ( pf0_vf_RxmReadDataValid_3_i  ),
    .pf0_vf_RxmWrite_4_o            ( pf0_vf_RxmWrite_4_o          ),
    .pf0_vf_RxmAddress_4_o          ( pf0_vf_RxmAddress_4_o        ),
    .pf0_vf_RxmWriteData_4_o        ( pf0_vf_RxmWriteData_4_o      ),
    .pf0_vf_RxmByteEnable_4_o       ( pf0_vf_RxmByteEnable_4_o     ),
    .pf0_vf_RxmWaitRequest_4_i      ( pf0_vf_RxmWaitRequest_4_i    ),
    .pf0_vf_RxmRead_4_o             ( pf0_vf_RxmRead_4_o           ),
    .pf0_vf_RxmReadData_4_i         ( pf0_vf_RxmReadData_4_i       ),
    .pf0_vf_RxmReadDataValid_4_i    ( pf0_vf_RxmReadDataValid_4_i  ),
    .pf0_vf_RxmWrite_5_o            ( pf0_vf_RxmWrite_5_o          ),
    .pf0_vf_RxmAddress_5_o          ( pf0_vf_RxmAddress_5_o        ),
    .pf0_vf_RxmWriteData_5_o        ( pf0_vf_RxmWriteData_5_o      ),
    .pf0_vf_RxmByteEnable_5_o       ( pf0_vf_RxmByteEnable_5_o     ),
    .pf0_vf_RxmWaitRequest_5_i      ( pf0_vf_RxmWaitRequest_5_i    ),
    .pf0_vf_RxmRead_5_o             ( pf0_vf_RxmRead_5_o           ),
    .pf0_vf_RxmReadData_5_i         ( pf0_vf_RxmReadData_5_i       ),
    .pf0_vf_RxmReadDataValid_5_i    ( pf0_vf_RxmReadDataValid_5_i  ),

    .AvTxsWrite_i                     ( TxsWrite_i            ),
    .AvTxsAddress_i                   ( TxsAddress_i          ),
    .AvTxsWriteData_i                 ( TxsWriteData_i        ),
    .AvTxsByteEnable_i                ( TxsByteEnable_i       ),
    .AvTxsWaitRequest_o               ( TxsWaitRequest_o      ),
    .AvTxsRead_i                      ( TxsRead_i             ),
    .AvTxsReadData_o                  ( TxsReadData_o         ),
    .AvTxsReadDataValid_o             ( TxsReadDataValid_o    ),
    .AvTxsChipSelect_i                ( TxsChipSelect_i       ),
    .AvCraChipSelect_i                ( CraChipSelect_i       ),
    .AvCraRead_i                      ( CraRead_i             ),
    .AvCraWrite_i                   ( CraWrite_i            ),
    .AvCraWriteData_i               ( CraWriteData_i        ),
    .AvCraAddress_i                 ( CraAddress_i          ),
    .AvCraByteEnable_i              ( CraByteEnable_i       ),
    .AvCraReadData_o                ( CraReadData_o         ),
    .AvCraWaitRequest_o             ( CraWaitRequest_o      ),
    .AvRdDmaRxReady_o               ( RdDmaRxReady_o       ),
    .AvRdDmaRxData_i                ( RdDmaRxData_i        ),
    .AvRdDmaRxValid_i               ( RdDmaRxValid_i       ),
    .AvRdDmaTxData_o                ( RdDmaTxData_o        ),
    .AvRdDmaTxValid_o               ( RdDmaTxValid_o       ),
    .AvWrDmaRxReady_o               ( WrDmaRxReady_o       ),
    .AvWrDmaRxData_i                ( WrDmaRxData_i        ),
    .AvWrDmaRxValid_i               ( WrDmaRxValid_i       ),
    .AvWrDmaTxData_o                ( WrDmaTxData_o        ),
    .AvWrDmaTxValid_o               ( WrDmaTxValid_o       ),
    .AvMsiIntfc_o                   ( ),
    .AvMsixIntfc_o                  ( ),
    .IntxReq_i                      ( 1'b0  ),
    .IntxAck_o                      ( ),
    .HipCfgAddr_i                   ( 4'h0  ),
    .HipCfgCtl_i                    ( 32'h0 ),
    .TLCfgSts_i                     ( 16'h0 ),
    .Ltssm_i                        ( 5'h0  ),
    .CurrentSpeed_i                 ( 2'h0  ),
    .LaneAct_i                      ( 4'h0  )
  );

//=================================
// Feedback clock and reset
//=================================
assign pld_core_ready =  serdes_pll_locked;

   assign pld_clk = coreclkout_hip;
   assign pld_clk_hip = coreclkout_hip;

   assign npor_int         = ~reset_status_sync_pldclk;

   // Reset synchronizer
   altpcie_reset_delay_sync #(
      .ACTIVE_RESET           (1),
      .WIDTH_RST              (1),
      .NODENAME               ("reset_status_altpcie_reset_delay_sync_altera_pcie_sriov_dma_hwtcl"),
      .LOCK_TIME_CNT_WIDTH    (1)
   ) reset_status_altpcie_reset_delay_sync_altera_pcie_sriov_dma_hwtcl(
      .clk         (pld_clk),
      .async_rst   (reset_status),
      .sync_rst    (reset_status_sync_pldclk)
   );
   assign nreset_status_hip = ~reset_status_sync_pldclk;
   altpcie_reset_delay_sync #(
      .ACTIVE_RESET           (0),
      .WIDTH_RST              (11),
      .NODENAME               ("app_rstn_altpcie_reset_delay_sync_altera_pcie_sriov_dma_hwtcl"),
      .LOCK_TIME_CNT_WIDTH    (1)
   ) app_rstn_altpcie_reset_delay_sync_altera_pcie_sriov_dma_hwtcl(
      .clk         (pld_clk),
      .async_rst   (npor_int & pld_clk_inuse),
      .sync_rst    ({app_rstn_o, app_rstn_9w[9:0]})
   );




//=================================
// Unused outputs default values
//=================================
  // MSI Interrupts
      assign    app_int_sts_a  = 1'b0;
      assign    app_int_sts_b  = 1'b0;
      assign    app_int_sts_c  = 1'b0;
      assign    app_int_sts_d  = 1'b0;
      assign    app_int_sts_fn = 1'b0;
      assign    app_msi_req    = 1'b0;
      assign    app_msi_req_fn = 8'h0;
      assign    app_msi_num    = 5'h0;
      assign    app_msi_tc     = 3'h0;
      assign    app_int_pend_status = 1'b0;

 // Tie off MSI-X requests
      assign    app_msix_req               = 1'b0;
      assign    app_msix_addr              = 64'h0;
      assign    app_msix_data              = 32'h0;
      assign    app_int_pend_status        = 2'h0;
      assign    app_msi_pending_bit_write_en   = 1'b0;
      assign    app_msi_pending_bit_write_data = 1'b0;

  // Hot plug
  assign hpg_ctrler = 5'h0;

  assign flr_completed_pf = {TOTAL_PF_COUNT{1'b1}};   // Indication from user to re-enable PF 0 after FLR
  assign flr_completed_vf = {TOTAL_VF_COUNT{1'b1}};  // Indication from user to re-enable VFs after FLR

  // Avalon-ST interface
  assign tx_st_err        = 0;

  // LMI Interface
  assign lmi_addr         = 12'h0;
  assign lmi_func         = 9'h0;
  assign lmi_din          = 32'h0;
  assign lmi_rden         = 1'b0;
  assign lmi_wren         = 1'b0;

  // hip_sriov_completion
  assign cpl_err          = 7'h0;
  assign cpl_err_fn       = 8'h0;
  assign cpl_pending_pf   = {TOTAL_PF_COUNT{1'b0}};
  assign cpl_pending_vf   = {PF0_VF_COUNT{1'b0}};
  assign log_hdr          = 128'h0;

  assign tx_cred_fc_sel   = 2'h0;
  assign tx_cons_cred_sel = 1'b0;

  assign derr_cor_ext_rcv_drv  =  derr_cor_ext_rcv;
  assign derr_cor_ext_rpl_drv  =  derr_cor_ext_rpl;
  assign derr_rpl_drv          =  derr_rpl;
  assign dlup_drv              =  dlup;
  assign dlup_exit_drv         =  dlup_exit;
  assign ev128ns_drv           =  ev128ns;
  assign ev1us_drv             =  ev1us;
  assign hotrst_exit_drv       =  hotrst_exit;
  assign int_status_drv        =  int_status;
  assign l2_exit_drv           =  l2_exit;
  assign lane_act_drv          =  lane_act;
  assign ltssmstate_drv        =  ltssmstate;
  assign rx_par_err_drv        =  rx_par_err;
  assign tx_par_err_drv        =  tx_par_err;
  assign cfg_par_err_drv       =  cfg_par_err;
  assign ko_cpl_spc_header_drv =  ko_cpl_spc_header;
  assign ko_cpl_spc_data_drv   =  ko_cpl_spc_data;

endmodule
