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


// (C) 2001-2015 Altera Corporation. All rights reserved.
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

module pio_ed
#(
     //----------------------------------------------------
     //------------- TOP LEVEL PARAMETERS -----------------
     //----------------------------------------------------

     parameter DBUS_WIDTH         = 64
)

(

/// System Clock and Reset
   input  logic                               Clk_i,
   input  logic                               clr_st,

// HIP Interface
  // Rx port interface to PCI Exp HIP
  output logic                               HipRxStReady_o,
  output logic                               HipRxStMask_o,
  input  logic  [DBUS_WIDTH-1:0]             HipRxStData_i,
  input  logic  [1:0]                        HipRxStEmpty_i,
  input  logic                               HipRxStErr_i,
  input  logic                               HipRxStSop_i,
  input  logic                               HipRxStEop_i,
  input  logic                               HipRxStValid_i,
  input  logic  [7:0]                        HipRxStBarDec1_i,
  // Tx application interface
  input   logic                              HipTxStReady_i,
  output  logic  [DBUS_WIDTH-1:0]            HipTxStData_o,
  output  logic                              HipTxStSop_o,
  output  logic                              HipTxStEop_o,
  output  logic  [(DBUS_WIDTH == 64 )?2:0:0] HipTxStEmpty_o,
  output  logic                              HipTxStValid_o,
  output  logic                              HipTxStError_o,

// RXM Master Port,
  // Avalon Rx Master interface
  output logic                               AvRxmWrite_0_o,
  output logic [15:0]                        AvRxmAddress_0_o,
  output logic [31:0]                        AvRxmWriteData_0_o,
  output logic [3:0]                         AvRxmByteEnable_0_o,
  input  logic                               AvRxmWaitRequest_0_i,
  output logic                               AvRxmRead_0_o,
  input  logic [31:0]                        AvRxmReadData_0_i,
  input  logic                               AvRxmReadDataValid_0_i,
  
  
  //current_speed
  input  logic  [1:0]                        CurrentSpeed_i,
  
  //hip_status
  input  logic  [4:0]                        Ltssm_i,
  input  logic  [3:0]                        LaneAct_i,
  input  logic                               derr_cor_ext_rcv ,
  input  logic                               derr_cor_ext_rpl ,
  input  logic                               derr_rpl         ,
  input  logic                               dlup_exit        ,
  input  logic                               ev128ns          ,
  input  logic                               ev1us            ,
  input  logic                               hotrst_exit      ,
  input  logic  [3:0]                        int_status       ,
  input  logic                               l2_exit          ,
  input  logic                               dlup             ,
  input  logic                               rx_par_err       ,
  input  logic  [1:0]                        tx_par_err       ,
  input  logic                               cfg_par_err      ,
  input  logic  [7:0]                        ko_cpl_spc_header,
  input  logic  [11:0]                       ko_cpl_spc_data  ,
  
  //Config_tl
  input  logic  [3:0]                        HipCfgAddr_i,
  input  logic  [31:0]                       HipCfgCtl_i,
  input  logic  [52:0]                       TLCfgSts_i,
  output logic  [6:0]                        cpl_err_o        ,
  output logic                               cpl_pending_o    ,
  output logic  [4:0]                        hpg_ctrler_o     ,
  
  //hip_rst
  input  logic                               pld_clk_inuse    ,
  output logic                               pld_core_ready   ,
  input  logic                               reset_status     ,
  input  logic                               serdes_pll_locked,
  input  logic                               testin_zero      ,
  
  //tx_cred
  input  logic  [11:0]                       tx_cred_data_fc    ,
  input  logic  [5:0]                        tx_cred_fc_hip_cons,
  input  logic  [5:0]                        tx_cred_fc_infinite,
  input  logic  [7:0]                        tx_cred_hdr_fc     ,
  output logic  [1:0]                        tx_cred_fc_sel     ,
  
  //power_mgnt
  output logic                               pm_auxpwr         ,
  output logic  [9:0]                        pm_data           ,
  output logic                               pme_to_cr         ,
  output logic                               pm_event          ,
  input  logic                               pme_to_sr         ,

//###################################################################################
// Interrupt interface int_msi
//###################################################################################
  input  logic                               app_int_ack       ,
  output logic                               app_int_sts, // Legacy interrupt status from PFs
  output logic                               app_msi_req, // MSI interrupt request
  output logic [4:0]                         app_msi_num, // MSI interrupt number corresponding to MSI interrupt request
  output logic [2:0]                         app_msi_tc,  // Traffic Class corresponding to MSI interrupt request
  input logic                                app_msi_ack // Ack to MSI interrupt request

);

localparam  DEVICE_FAMILY  = "Arria 10";
assign    HipTxStError_o                 = 1'b0;
assign    HipRxStMask_o                  = 1'b0;
assign    hpg_ctrler_o                   = {5{1'b0}};
assign    cpl_err_o                      = {7{1'b0}};
assign    cpl_pending_o                  = 1'b0;
assign    pld_core_ready                 = serdes_pll_locked;
assign    tx_cred_fc_sel                 = 2'b00;
assign    pm_auxpwr                      = 1'b0;
assign    pm_data                        = {10{1'b0}};
assign    pme_to_cr                      = 1'b0;
assign    pm_event                       = 1'b0;

//######## SRIOV BRIDGE UNUSED SIGNALS
assign    app_int_sts                    = 1'b0;
assign    app_msi_req                    = 1'b0;
assign    app_msi_num                    = {5{1'b0}};
assign    app_msi_tc                     = {3{1'b0}};


pio_top
#(
     //----------------------------------------------------
     //------------- TOP LEVEL PARAMETERS -----------------
     //----------------------------------------------------
      .FAMILY               (DEVICE_FAMILY),
      .WIDTH                (DBUS_WIDTH)
)
pio
(

   // System Clock and Reset
      .pld_clk                    (Clk_i           ),
      .clr_st                     (reset_status    ),

   // Rx port interface to PCI Exp HIP
      .rx_st_ready             (HipRxStReady_o  ),
      .rx_st_data              (HipRxStData_i   ),
      .rx_st_empty             (HipRxStEmpty_i  ),
      .rx_st_err               (HipRxStErr_i    ),
      .rx_st_sop               (HipRxStSop_i    ),
      .rx_st_eop               (HipRxStEop_i    ),
      .rx_st_valid             (HipRxStValid_i  ),
      .rx_st_bar               (HipRxStBarDec1_i),
    // Config interface  
      .tl_cfg_add               (HipCfgAddr_i),
      .tl_cfg_ctl               (HipCfgCtl_i),
   // Tx application interface
      .tx_st_ready             (HipTxStReady_i  ),
      .tx_st_data              (HipTxStData_o   ),
      .tx_st_sop               (HipTxStSop_o    ),
      .tx_st_eop               (HipTxStEop_o    ),
      .tx_st_empty             (HipTxStEmpty_o  ),
      .tx_st_valid             (HipTxStValid_o  ),

   // Avalon Rx Master interface 0
      .avmm_write              (AvRxmWrite_0_o         ),
      .avmm_address            (AvRxmAddress_0_o       ),
      .avmm_writedata          (AvRxmWriteData_0_o     ),
      .avmm_byteenable         (AvRxmByteEnable_0_o    ),
      .avmm_waitrequest        (AvRxmWaitRequest_0_i   ),     
      .avmm_read               (AvRxmRead_0_o          ),     
      .avmm_readdata           (AvRxmReadData_0_i      ),     
      .avmm_readdata_valid     (AvRxmReadDataValid_0_i )
 /*  // TXS Slave Port
      .AvTxsChipSelect_i          (AvTxsChipSelect_i      ),
      .AvTxsWrite_i               (AvTxsWrite_i           ),
      .AvTxsAddress_i             (AvTxsAddress_i         ),
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

      .TLCfgSts_i                 (TLCfgSts_i[46:31]      ),

      .Ltssm_i                    (Ltssm_i                ),
      .CurrentSpeed_i             (CurrentSpeed_i         ),
      .LaneAct_i                  (LaneAct_i              )
 */
);


endmodule

