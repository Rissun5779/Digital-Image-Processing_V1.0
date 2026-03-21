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

module ast2avmm_bridge_256_hwtcl
#(
     //----------------------------------------------------
     //------------- TOP LEVEL PARAMETERS -----------------
     //----------------------------------------------------
     parameter RXM_ADDR_WIDTH              = 32,
     parameter DBUS_WIDTH                  = 256,
     parameter BE_WIDTH                    = 32,
     parameter BURST_COUNT_WIDTH           = 6,
     parameter TX_S_ADDR_WIDTH             = 32,
     parameter ENABLE_CRA                  = 1,
     parameter ENABLE_TXS                  = 1,
     parameter PORT_TYPE                   = "Root Port",
     parameter BAR_NUMBER                  = 0,
     parameter BAR_SIZE_MASK               = 10,
     parameter SRIOV_EN                    = 0,
     parameter PF_COUNT                    = 4,
     parameter VF_COUNT                    = 4,
     parameter PFCNT_WD                    = 2,
     parameter VFCNT_WD                    = 2
)

(

   // System Clock and Reset
   input  logic                               Clk_i,
   input  logic                               avmm_rst,

   // HIP Interface
   // Rx port interface to PCI Exp HIP
   output logic                               HipRxStReady_o,
   input  logic  [DBUS_WIDTH-1:0]             HipRxStData_i,
   input  logic  [2:0]                        HipRxStEmpty_i,
   input  logic                               HipRxStSop_i,
   input  logic                               HipRxStEop_i,
   input  logic                               HipRxStValid_i,
   input  logic  [2:0]                        HipRxStBarRange_i,
   // Tx application interface
   input   logic                              HipTxStReady_i  ,
   output  logic  [DBUS_WIDTH-1:0]            HipTxStData_o   ,
   output  logic                              HipTxStSop_o    ,
   output  logic                              HipTxStEop_o    ,
   output  logic                              HipTxStValid_o  ,
   output  logic                              HipTxStError_o  ,

   //Unused SRIOV Bridge AVST Signals
   input  logic  [2:0]                        HipRxStBar_range_i,
   input  logic  [PFCNT_WD-1:0]               HipRxSt_pf_num_i,
   input  logic  [VFCNT_WD-1:0]               HipRxSt_vf_num_i,
   input  logic                               HipRxSt_vf_active_i,

   output  logic  [PFCNT_WD-1:0]              HipTxSt_pf_num_o,
   output  logic  [VFCNT_WD-1:0]              HipTxSt_vf_num_o,
   output  logic                              HipTxSt_vf_active_o,

   // RXM Master Port, one for each BAR
   // Avalon Rx Master interface 0
   output logic                                 AvRxmWrite_0_o,
   output logic [RXM_ADDR_WIDTH-1:0]            AvRxmAddress_0_o,
   output logic [DBUS_WIDTH-1:0]                AvRxmWriteData_0_o,
   output logic [BE_WIDTH-1:0]                  AvRxmByteEnable_0_o,
   output logic [BURST_COUNT_WIDTH-1:0]         AvRxmBurstCount_0_o,
   input  logic                                 AvRxmWaitRequest_0_i,
   output logic                                 AvRxmRead_0_o,
   input  logic [DBUS_WIDTH-1:0]                AvRxmReadData_0_i,
   input  logic                                 AvRxmReadDataValid_0_i,
   input  logic                                 AvRxmIrq_i,

   // TXS Slave Port
   input   logic                                AvTxsChipSelect_i,
   input   logic                                AvTxsWrite_i,
   input   logic  [TX_S_ADDR_WIDTH-1:0]         AvTxsAddress_i,  // {func_no, address}
   input   logic  [31:0]                        AvTxsWriteData_i,
   input   logic  [3:0]                         AvTxsByteEnable_i,
   output  logic                                AvTxsWaitRequest_o,
   input   logic                                AvTxsRead_i,
   output  logic  [31:0]                        AvTxsReadData_o,
   output  logic                                AvTxsReadDataValid_o,


   //CRA Slave Port
   input   logic                                 AvCraChipSelect_i,
   input   logic                                 AvCraRead_i,
   input   logic                                 AvCraWrite_i,
   input   logic  [31:0]                         AvCraWriteData_i,
   input   logic  [13:0]                         AvCraAddress_i,
   input   logic  [3:0]                          AvCraByteEnable_i,
   output  logic  [31:0]                         AvCraReadData_o,
   output  logic                                 AvCraWaitRequest_o,
   output  logic                                 AvCraIrq_o,


   input   logic  [4:0]                           HipCfgAddr_i,
   input   logic  [1:0]                           HipCfgFunc_i,
   input   logic  [31:0]                          HipCfgCtl_i,


   input  logic  [5:0]                            Ltssm_i,
   input  logic  [1:0]                            CurrentSpeed_i,
   input  logic  [4:0]                            LaneAct_i,

   //###################################################################################
   //These ports are not used in design, they are part of some interface signals used above
   //###################################################################################
   //hip_status
   input  logic                                   derr_cor_ext_rcv ,
   input  logic                                   derr_cor_ext_rpl ,
   input  logic                                   derr_rpl         ,
   input  logic                                   derr_uncor_ext_rcv,
   input  logic                                   rx_par_err       ,
   input  logic                                   tx_par_err       ,
   input  logic                                   link_up          ,
   input  logic  [10:0]                           int_status       ,
   input  logic  [2:0]                            int_status_common,
   //config_tl
   output logic  [11:0]                           app_err_info     ,
   output logic                                   app_err_valid    ,
   output logic  [31:0]                           app_err_hdr      ,
   //hip_rst
   input  logic                                   pld_clk_inuse    ,
   output logic                                   pld_core_ready   ,
   input  logic                                   reset_status     ,
   input  logic                                   serdes_pll_locked,
   input  logic                                   testin_zero      ,
   //tx_cred
   input  logic     [1:0]                          tx_cdts_type                                      ,
   input  logic                                    tx_data_cdts_consumed                             ,
   input  logic                                    tx_hdr_cdts_consumed                              ,
   input  logic     [1:0]                          tx_cdts_data_value                                ,
   input  logic     [11:0]                         tx_pd_cdts                                        ,
   input  logic     [11:0]                         tx_npd_cdts                                       ,
   input  logic     [7:0]                          tx_cplh_cdts                                      ,
   input  logic     [7:0]                          tx_ph_cdts                                        ,
   input  logic     [11:0]                         tx_cpld_cdts                                      ,
   input  logic     [7:0]                          tx_nph_cdts                                       ,

    //power_mgmt
   input  logic                                    pm_linkst_in_l1                                   ,
   input  logic                                    pm_linkst_in_l0s                                  ,
   input  logic     [2:0]                          pm_state                                          ,
   input  logic     [2:0]                          pm_dstate                                         ,
   output logic                                    apps_pm_xmt_pme                                   ,
   output logic                                    apps_ready_entr_l23                               ,
   output logic                                    apps_pm_xmt_turnoff                               ,
   output logic                                    app_init_rst                                      ,
   output logic                                    app_xfer_pending                                  ,

   //int_msi - Interrupt Interface
   output logic                                   app_msi_req, // MSI interrupt request
   input logic                                    app_msi_ack, // Ack to MSI interrupt request
   output logic [2:0]                             app_msi_tc,  // Traffic Class corresponding to MSI interrupt request
   output logic [4:0]                             app_msi_num, // MSI interrupt number corresponding to MSI interrupt request
   output logic                                   app_int_sts, // Legacy interrupt status from PFs

   //###################################################################################
   //All Interfaces below are SRIOV Bridge Signals - Not used in this design
   //###################################################################################
   //Interrupt Interface
   output logic [PF_COUNT-1:0]                    app_int_pf_sts, // Legacy interrupt status from PFs to SRIOV Bridge
   input logic [PF_COUNT-1:0]                     app_intx_disable, // INTX Disable from PCI Command Register of PFs
   output logic [PFCNT_WD-1:0]                    app_msi_req_fn, // Function number corresponding to MSI interrupt request
   input logic [1:0]                              app_msi_status, // Execution status of MSI interrupt request,
                                                                      // 00 = MSI message sent,
                                                                      // 01 = Pending bit set and no message sent,
                                                                      // 10 = error
   output logic                                   app_msix_req, // MSIX interrupt request, common for all Functions
   output logic [63:0]                            app_msix_addr,  // Address to be sent in MSIX interrupt message
   output logic [31:0]                            app_msix_data,  // Data to be sent in MSIX interrupt message
   output logic [PFCNT_WD-1:0]                    app_msix_pf_num, // PF number of Function originating MSIX interrupt
   output logic [VFCNT_WD-1:0]                    app_msix_vf_num, // VF number offset of Function originating MSIX interrupt
   output logic                                   app_msix_vf_active, // Indicates that the Function originating MSIX interrupt is a VF
   input logic                                    app_msix_ack, // Ack to MSIX interrupt request
   input logic                                    app_msix_err, // Error status for MSIX interrupt request, common for all Functions
   output logic                                   app_msi_pending_bit_write_en, // Write enable for bit in the MSI Pending Bit Register
   output logic                                   app_msi_pending_bit_write_data, // Write data for bit in the MSI Pending Bit Register
   // PF MSI Capability Register Outputs
   input logic [PF_COUNT*64-1:0]                  app_msi_addr_pf,// MSI Address Register setting of PFs
   input logic [PF_COUNT*16-1:0]                  app_msi_data_pf,// MSI Data Register setting of PFs
   input logic [PF_COUNT*32-1:0]                  app_msi_mask_pf,// MSI Mask Register setting of PFs
   input logic [PF_COUNT*32-1:0]                  app_msi_pending_pf,// MSI Pending Bit Register setting of PFs
   input logic [PF_COUNT-1:0]                     app_msi_enable_pf,// MSI Enable setting of PFs
   input logic [PF_COUNT*3-1:0]                   app_msi_multi_msg_enable_pf,// MSI Multiple Msg field setting of PFs
   // MSIX Capability Register Outputs
   input logic [PF_COUNT-1:0]                     app_msix_en_pf, // MSIX Enable bit from MSIX Control Reg of PFs
   input logic [PF_COUNT-1:0]                     app_msix_fn_mask_pf, // MSIX Function Mask bit from
                                                                     // MSIX Control Reg of PFs
   // Configuration Status Interface of PFs
   input logic [7:0]                            bus_num_f0, // Captured bus number for PF 0
   input logic [7:0]                            bus_num_f1, // Captured bus number for PF 1
   input logic [7:0]                            bus_num_f2, // Captured bus number for PF 2
   input logic [7:0]                            bus_num_f3, // Captured bus number for PF 3
   input logic [4:0]                            device_num_f0, // Captured device number for PF 0
   input logic [4:0]                            device_num_f1, // Captured device number for PF 1
   input logic [4:0]                            device_num_f2, // Captured device number for PF 2
   input logic [4:0]                            device_num_f3, // Captured device number for PF 3
   input logic [PF_COUNT-1:0]             mem_space_en_pf, // Memory Space Enable for PFs
   input logic [PF_COUNT-1:0]             bus_master_en_pf, // Bus Master Enable for PFs
   input logic [PF_COUNT-1:0]             mem_space_en_vf, // Memory Space Enable for VFs
                                                 // (common for all VFs attached to the same PF)
   input logic [15:0]                           pf0_num_vfs, // Number of enabled VFs for PF 0
   input logic [15:0]                           pf1_num_vfs, // Number of enabled VFs for PF 1
   input logic [15:0]                           pf2_num_vfs, // Number of enabled VFs for PF 2
   input logic [15:0]                           pf3_num_vfs, // Number of enabled VFs for PF 3
   input logic [2:0]                            max_payload_size, // Max payload size from
                                                                 // Device Control Register
   input logic [2:0]                            rd_req_size, // Read Request Size from
                                                               //Device Control Register
   input logic [PF_COUNT-1:0]             compl_timeout_disable_pf, // Completion Timeout Disable for PFs
                                                               // Bit 4 of Device Control 2 Reg
   input logic [PF_COUNT-1:0]             atomic_op_requester_en_pf, // AtomicOp Requester Enable for PFs
                                                               // Bit 6 of Device Control 2 Reg
   input logic [PF_COUNT-1:0]             extended_tag_en_pf, // Extended Tag Enable for PFs
                                                               // Bit 8 of Device Control Reg
   input logic [PF_COUNT*2-1:0]           tph_st_mode_pf, // TPH ST Mode Select for PFs
                                                               // Bits [1:0] of TPH Requester Control Reg
   input logic [PF_COUNT-1:0]             tph_requester_en_pf, // TPH Requester Enable for PFs
                                                               // Bit 8 of TPH Requester Control Reg
   input logic [PF_COUNT*5-1:0]           ats_stu_pf, // Smallest Translation Unit field of
                                                             // ATS Control Register (bits 4:0)
   input logic [PF_COUNT-1:0]             ats_en_pf,  // ATS Enable for PFs
                                                             // Bit 15 of ATS Control Reg
   // Control Shadow Interface of VFs
   input logic                                  ctl_shdw_update, // Indicates presence of valid data
                                                              // on ctl_shdw_* outputs
   input logic [PFCNT_WD-1:0]       ctl_shdw_pf_num, // PF number of config register
                                                               // whose data is on ctl_shdw_cfg
   input logic [VFCNT_WD-1:0]       ctl_shdw_vf_num, // VF number offset of config register
                                                               // whose data is on ctl_shdw_cfg
   input logic                                  ctl_shdw_vf_active, // Indicates that the Function whose
                                                               // data is on ctl_shdw_cfg is a VF.
   input logic [6:0]                           ctl_shdw_cfg, // Config Register outputs
                                                // Bit 0 = Bus Master Enable
                                                // Bit 1 = MSIX Function Mask
                                                // Bit 2 = MSIX Enable
                                                // Bit 4:3 = TPH ST Mode Sel
                                                // Bit 5 = TPH Requester Enable
                                                // Bit 6 = ATS Enable
   output logic                                   ctl_shdw_req_all, // Scan request from user
   // Completion Status Signals to SRIOV Bridge
   output logic [6:0]                 cpl_err,    // Error indications from user application
                                      // [0] = Completion timeout with recovery
                                      // [1] = Completion timeout without recovery
                                      // [2] = Completer Abort sent
                                      // [3] = Unexpected Completion received
                                      // [4] = Posted request received and flagged as UR
                                      // [5] = Non-Posted request received and flagged as UR
                                      // [6] = Header Logging enable (header supplied on log_hdr output)
   output logic [PFCNT_WD-1:0]        cpl_err_pf_num, // PF number of reporting Function
   output logic [VFCNT_WD-1:0]        cpl_err_vf_num, // VF number offset of reporting Function
   output logic                       cpl_err_vf_active, // Indicates that the reporting Function
                                                                   // is a VF.
   output logic [PF_COUNT-1:0]        cpl_pending_pf,// Completion pending status from PFs
   output logic [127:0]               log_hdr,    // TLP header for logging
   output logic                       vf_compl_status_update, //Completion Pending status update from VF
   output logic                       vf_compl_status, // current Completion Pending status of VF
   output logic [PFCNT_WD-1:0]        vf_compl_status_pf_num, // PF number of Function reporting
                                                                        // Completion Pending status.
   output logic [VFCNT_WD-1:0]        vf_compl_status_vf_num, // VF number offset of Function reporting
                                                                        // Completion Pending status.
   input  logic                       vf_compl_status_update_ack, // Ack from SR-IOV Bridge indicating
                                                                        // Completion Pending status change has been
                                                                        // processed.
   // FLR Interface
   input logic [PF_COUNT-1:0]       flr_active_pf, // FLR status for PFs
   input logic                      flr_rcvd_vf, // One-cycle pulse indicates that
                                                             // an FLR was received from host targeting a VF.
   input logic [PFCNT_WD-1:0]       flr_rcvd_pf_num, // Parent PF number of VF undergoing FLR
   input logic [VFCNT_WD-1:0]       flr_rcvd_vf_num, // VF number offset of VF undergoing FLR

   output logic [PF_COUNT-1:0]      flr_completed_pf, // Indication from user to re-enable PFs after FLR
   output logic                     flr_completed_vf, // One-cycle pulse from user to re-enable VF
   output logic [PFCNT_WD-1:0]      flr_completed_pf_num, // Parent PF number of VF to re-enable
   output logic [VFCNT_WD-1:0]      flr_completed_vf_num // VF number offset of VF to re-enable
);


localparam  DEVICE_FAMILY  = "Stratix 10";
localparam ZEROS = 512'h0;
localparam TX_S_ADDR_WIDTH_CAP=(TX_S_ADDR_WIDTH<32)?32:TX_S_ADDR_WIDTH;

logic [BE_WIDTH-1:0] HipRxStBe_i ;
wire [63:0] Address_int;

generate begin : g_addr
   if (TX_S_ADDR_WIDTH<32) begin
      assign Address_int[63:0] = {ZEROS[63:TX_S_ADDR_WIDTH],AvTxsAddress_i[TX_S_ADDR_WIDTH-1:0]};
   end
   else begin
      assign Address_int [TX_S_ADDR_WIDTH-1:0]= AvTxsAddress_i[TX_S_ADDR_WIDTH-1:0];
   end
end
endgenerate

assign  app_err_info                     = 1'b0       ;
assign  app_err_valid                    = 1'b0       ;
assign  app_err_hdr                      = 1'b0       ;
assign  pld_core_ready                   = serdes_pll_locked  ;
assign  apps_pm_xmt_pme                  = 1'b0       ;
assign  apps_ready_entr_l23              = 1'b0       ;
assign  apps_pm_xmt_turnoff              = 1'b0       ;
assign  app_init_rst                     = 1'b0       ;
assign  app_xfer_pending                 = 1'b0       ;
assign  app_msi_req                      = 1'b0       ;
assign  app_msi_tc                       = 1'b0       ;
assign  app_msi_num                      = 1'b0       ;
assign  app_int_sts                      = 1'b0       ;


//######## SRIOV BRIDGE UNUSED SIGNALS
assign    app_int_pf_sts                 = {PF_COUNT{1'b0}};
assign    app_msi_req_fn                 = {PFCNT_WD{1'b0}};
assign    app_msix_req                   = 1'b0;
assign    app_msix_addr                  = {64{1'b0}};
assign    app_msix_data                  = {32{1'b0}};
assign    app_msix_pf_num                = {PFCNT_WD{1'b0}};
assign    app_msix_vf_num                = {VFCNT_WD{1'b0}};
assign    app_msix_vf_active             = 1'b0;
assign    app_msi_pending_bit_write_en   = 1'b0;
assign    app_msi_pending_bit_write_data = 1'b0;
assign    ctl_shdw_req_all               = 1'b0;

assign    lmi_addr_app                   = {12{1'b0}};
assign    lmi_dest_app                   = 1'b0;
assign    lmi_pf_num_app                 = {PFCNT_WD{1'b0}};
assign    lmi_vf_num_app                 = {VFCNT_WD{1'b0}};
assign    lmi_din_app                    = {32{1'b0}};
assign    lmi_rden_app                   = 1'b0;
assign    lmi_wren_app                   = 1'b0;

assign    cpl_err                        = {7{1'b0}} ;
assign    cpl_err_pf_num                 = {PFCNT_WD{1'b0}} ;
assign    cpl_err_vf_num                 = {VFCNT_WD{1'b0}} ;
assign    cpl_err_vf_active              = 1'b0 ;
assign    cpl_pending_pf                 = {PF_COUNT{1'b0}} ;
assign    log_hdr                        = {128{1'b0}} ;
assign    vf_compl_status_update         = 1'b0 ;
assign    vf_compl_status                = 1'b0 ;
assign    vf_compl_status_pf_num         = {PFCNT_WD{1'b0}} ;
assign    vf_compl_status_vf_num         = {VFCNT_WD{1'b0}} ;

assign    flr_completed_pf               = flr_active_pf;
assign    flr_completed_vf               = flr_rcvd_vf;
assign    flr_completed_pf_num           = flr_rcvd_pf_num;
assign    flr_completed_vf_num           = flr_rcvd_vf_num;




//QW Align Bridge APP Interface Signals
//Rx Port Interface of the APP
    logic  [DBUS_WIDTH-1:0]             App_HipRxStData_o;
    logic  [1:0]                        App_HipRxStEmpty_o;
    logic                               App_HipRxStSop_o;
    logic                               App_HipRxStEop_o;
    logic                               App_HipRxStValid_o;
    logic  [7:0]                        App_HipRxStBarDec1_o;
    logic  [2:0]                        App_HipRxStBar_range_o;
    logic  [PFCNT_WD-1:0]               App_HipRxSt_pf_num_o;
    logic  [VFCNT_WD-1:0]               App_HipRxSt_vf_num_o;
    logic                               App_HipRxSt_vf_active_o;
    logic                               App_HipRxStReady_i;

//Tx Port Interface of the APP
   logic                              App_HipTxStReady_o  ;
   logic  [DBUS_WIDTH -1:0]            App_HipTxStData_i   ;
   logic                              App_HipTxStSop_i    ;
   logic                              App_HipTxStEop_i    ;
   logic                              App_HipTxStValid_i  ;
   logic                              App_HipTxStError_i  ;
   logic  [PFCNT_WD-1:0]              App_HipTxSt_pf_num_i;
   logic  [VFCNT_WD-1:0]              App_HipTxSt_vf_num_i;
   logic                              App_HipTxSt_vf_active_i;


assign   App_HipTxStError_i            =1'b0;




//256 Bit AVST Bridge to Convert A10 AST Signals to S10 AST Signals

altpcieav_256_data_qwalign_bridge_hwtcl
#(
     //----------------------------------------------------
     //------------- TOP LEVEL PARAMETERS -----------------
     //----------------------------------------------------
        .DEVICE_FAMILY                   (DEVICE_FAMILY),
      .DBUS_WIDTH                        (DBUS_WIDTH),
      .BE_WIDTH                          (BE_WIDTH),
      .BURST_COUNT_WIDTH                 (BURST_COUNT_WIDTH),
      .SRIOV_EN                          (SRIOV_EN),
      .PF_COUNT                          (PF_COUNT),
      .VF_COUNT                          (VF_COUNT),
      .PFCNT_WD                          (PFCNT_WD),
      .VFCNT_WD                          (VFCNT_WD)
)
altpcieav_256_data_qwalign_bridge_hwtcl_inst
(
   // System Clock and Reset
      .Clk_i                             (Clk_i                           ),
      .Rstn_i                            (~avmm_rst                       ),
   //Rx port interface of PCI Exp HIP
      .HipRxStData_i                     (HipRxStData_i                   ),
      .HipRxStEmpty_i                    (HipRxStEmpty_i                  ),
      .HipRxStSop_i                      (HipRxStSop_i                    ),
      .HipRxStEop_i                      (HipRxStEop_i                    ),
      .HipRxStValid_i                    (HipRxStValid_i                  ),
      .HipRxStBarRange_i                 (HipRxStBarRange_i               ),
      .HipRxStBar_range_i                (HipRxStBar_range_i              ),//SRIOV Signal
      .HipRxSt_pf_num_i                  (HipRxSt_pf_num_i                ),//SRIOV Signal
      .HipRxSt_vf_num_i                  (HipRxSt_vf_num_i                ),//SRIOV Signal
      .HipRxSt_vf_active_i               (HipRxSt_vf_active_i             ),//SRIOV Signal
      .HipRxStReady_o                    (HipRxStReady_o                  ),
   //Rx Port Interface to the APP
      .App_HipRxStData_o                 (App_HipRxStData_o               ),
      .App_HipRxStEmpty_o                (App_HipRxStEmpty_o              ),
      .App_HipRxStSop_o                  (App_HipRxStSop_o                ),
      .App_HipRxStEop_o                  (App_HipRxStEop_o                ),
      .App_HipRxStValid_o                (App_HipRxStValid_o              ),
      .App_HipRxStBarDec1_o              (App_HipRxStBarDec1_o            ),
      .App_HipRxStBar_range_o            (App_HipRxStBar_range_o          ),
      .App_HipRxSt_pf_num_o              (App_HipRxSt_pf_num_o            ),
      .App_HipRxSt_vf_num_o              (App_HipRxSt_vf_num_o            ),
      .App_HipRxSt_vf_active_o           (App_HipRxSt_vf_active_o         ),
      .App_HipRxStReady_i                (App_HipRxStReady_i              ),
   //Tx Port Interface of the APP
      .App_HipTxStReady_o                (App_HipTxStReady_o              ),
      .App_HipTxStData_i                 (App_HipTxStData_i               ),
      .App_HipTxStSop_i                  (App_HipTxStSop_i                ),
      .App_HipTxStEop_i                  (App_HipTxStEop_i                ),
      .App_HipTxStValid_i                (App_HipTxStValid_i              ),
      .App_HipTxStError_i                (App_HipTxStError_i              ),
      .App_HipTxSt_pf_num_i              (App_HipTxSt_pf_num_i            ),
      .App_HipTxSt_vf_num_i              (App_HipTxSt_vf_num_i            ),
      .App_HipTxSt_vf_active_i           (App_HipTxSt_vf_active_i         ),
   //Tx port interface to PCI Exp HIP
      .HipTxStReady_i                    (HipTxStReady_i                  ),
      .HipTxStData_o                     (HipTxStData_o                   ),
      .HipTxStSop_o                      (HipTxStSop_o                    ),
      .HipTxStEop_o                      (HipTxStEop_o                    ),
      .HipTxStValid_o                    (HipTxStValid_o                  ),
      .HipTxStError_o                    (HipTxStError_o                  ),
      .HipTxSt_pf_num_o                  (HipTxSt_pf_num_o                ),//SRIOV Signal
      .HipTxSt_vf_num_o                  (HipTxSt_vf_num_o                ),//SRIOV Signal
      .HipTxSt_vf_active_o               (HipTxSt_vf_active_o             ) //SRIOV Signal
);




altpcieav_256_rp_app
#(
     //----------------------------------------------------
     //------------- TOP LEVEL PARAMETERS -----------------
     //----------------------------------------------------
      .DEVICE_FAMILY               (DEVICE_FAMILY),
      .DMA_WIDTH                   (DBUS_WIDTH),
      .DMA_BE_WIDTH                (BE_WIDTH),
      .DMA_BRST_CNT_W              (BURST_COUNT_WIDTH),
      .TX_S_ADDR_WIDTH             (TX_S_ADDR_WIDTH_CAP),
      .enable_cra_hwtcl            (ENABLE_CRA),
      .enable_tx_slave             (ENABLE_TXS),
      .port_type_hwtcl             (PORT_TYPE),
      .BAR_NUMBER                  (BAR_NUMBER),
      .BAR0_SIZE_MASK              (BAR_SIZE_MASK),
      .BAR0_TYPE                   (RXM_ADDR_WIDTH),
      .SRIOV_EN                    (SRIOV_EN),
      .PF_COUNT                    (PF_COUNT),
      .VF_COUNT                    (VF_COUNT),
      .PFCNT_WD                    (PFCNT_WD),
      .VFCNT_WD                    (VFCNT_WD)
)
altpcieav_256_rp_app_inst
(

   // System Clock and Reset
      .Clk_i                      (Clk_i           ),
      .Rstn_i                     ({10{~avmm_rst}}    ),
   // Rx port interface to PCI Exp HIP
      .HipRxStReady_o             (App_HipRxStReady_i      ),
      .HipRxStData_i              (App_HipRxStData_o       ),
      .HipRxStEmpty_i             (App_HipRxStEmpty_o      ),
      .HipRxStSop_i               (App_HipRxStSop_o        ),
      .HipRxStEop_i               (App_HipRxStEop_o        ),
      .HipRxStValid_i             (App_HipRxStValid_o      ),
      .HipRxStBarDec1_i           (App_HipRxStBarDec1_o    ),
      .HipRxStBar_range_i         (App_HipRxStBar_range_o  ),
      .HipRxSt_pf_num_i           (App_HipRxSt_pf_num_o    ),
      .HipRxSt_vf_num_i           (App_HipRxSt_vf_num_o    ),
      .HipRxSt_vf_active_i        (App_HipRxSt_vf_active_o ),
      .HipRxStErr_i               (1'b0                    ),
      .HipRxStBe_i                (1'b0                    ),
      .HipRxStMask_o              (                        ),

      // Tx application interface
      .HipTxStReady_i             (App_HipTxStReady_o      ),
      .HipTxStData_o              (App_HipTxStData_i       ),
      .HipTxStSop_o               (App_HipTxStSop_i        ),
      .HipTxStEop_o               (App_HipTxStEop_i        ),
      .HipTxStValid_o             (App_HipTxStValid_i      ),
      .HipTxSt_pf_num_o           (App_HipTxSt_pf_num_i    ),
      .HipTxSt_vf_num_o           (App_HipTxSt_vf_num_i    ),
      .HipTxSt_vf_active_o        (App_HipTxSt_vf_active_i ),
      .HipTxStEmpty_o             (                        ),
      .HipCplPending_o            (                        ),

      // Avalon Rx Master interface 0
      .AvRxmWrite_0_o             (AvRxmWrite_0_o         ),
      .AvRxmAddress_0_o           (AvRxmAddress_0_o       ),
      .AvRxmWriteData_0_o         (AvRxmWriteData_0_o     ),
      .AvRxmByteEnable_0_o        (AvRxmByteEnable_0_o    ),
      .AvRxmBurstCount_0_o        (AvRxmBurstCount_0_o    ),
      .AvRxmWaitRequest_0_i       (AvRxmWaitRequest_0_i   ),
      .AvRxmRead_0_o              (AvRxmRead_0_o          ),
      .AvRxmReadData_0_i          (AvRxmReadData_0_i      ),
      .AvRxmReadDataValid_0_i     (AvRxmReadDataValid_0_i ),
      .AvRxmIrq_i                 (AvRxmIrq_i             ),
   // TXS Slave Port
      .AvTxsChipSelect_i          (AvTxsChipSelect_i      ),
      .AvTxsWrite_i               (AvTxsWrite_i           ),
      .AvTxsAddress_i             (Address_int[TX_S_ADDR_WIDTH_CAP-1:0]),
      .AvTxsWriteData_i           (AvTxsWriteData_i       ),
      .AvTxsByteEnable_i          (AvTxsByteEnable_i      ),
      .AvTxsWaitRequest_o         (AvTxsWaitRequest_o     ),
      .AvTxsRead_i                (AvTxsRead_i            ),
      .AvTxsReadData_o            (AvTxsReadData_o        ),
      .AvTxsReadDataValid_o       (AvTxsReadDataValid_o   ),
   // CRA Slave Port
      .AvCraChipSelect_i          (AvCraChipSelect_i      ),
      .AvCraRead_i                (AvCraRead_i            ),
      .AvCraWrite_i               (AvCraWrite_i           ),
      .AvCraWriteData_i           (AvCraWriteData_i       ),
      .AvCraAddress_i             (AvCraAddress_i         ),
      .AvCraByteEnable_i          (AvCraByteEnable_i      ),
      .AvCraReadData_o            (AvCraReadData_o        ),
      .AvCraWaitRequest_o         (AvCraWaitRequest_o     ),
      .AvCraIrq_o                 (AvCraIrq_o             ),

      .AvMsiIntfc_o               (                       ),
      .AvMsixIntfc_o              (                       ),
      .IntxReq_i                  (1'b0                   ),
      .IntxAck_o                  (                       ),

      .HipCfgAddr_i               (HipCfgAddr_i           ),
      .HipCfgCtl_i                (HipCfgCtl_i            ),
      .HipCfgFunc_i               (HipCfgFunc_i           ),

      .Ltssm_i                    (Ltssm_i                ),
      .CurrentSpeed_i             (CurrentSpeed_i         ),
      .LaneAct_i                  (LaneAct_i              )
);



endmodule

