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
`timescale 1 ns / 1 ps
// synopsys translate_on

module altpcieav_256_data_qwalign_bridge_hwtcl
#(
     //----------------------------------------------------
     //------------- TOP LEVEL PARAMETERS -----------------
     //----------------------------------------------------
     parameter DEVICE_FAMILY               = "Stratix 10",
     parameter DBUS_WIDTH                  = 256,
     parameter BE_WIDTH                    = 32,
     parameter BURST_COUNT_WIDTH           = 6,
     parameter PF_COUNT                    = 4,
     parameter VF_COUNT                    = 4,
     parameter PFCNT_WD                    = 2,
     parameter VFCNT_WD                    = 2,
     parameter SRIOV_EN                    = 0
)
(

/// System Clock and Reset
   input  logic                               Clk_i,
   input  logic                               Rstn_i,

//Rx port interface of PCI Exp HIP
   input  logic  [DBUS_WIDTH-1:0]             HipRxStData_i,
   input  logic  [2:0]                        HipRxStEmpty_i,
   input  logic                               HipRxStSop_i,
   input  logic                               HipRxStEop_i,
   input  logic                               HipRxStValid_i,
   input  logic  [2:0]                        HipRxStBarRange_i,
   input  logic  [2:0]                        HipRxStBar_range_i, //Used in SRIOV
   input  logic  [PFCNT_WD-1:0]               HipRxSt_pf_num_i,
   input  logic  [VFCNT_WD-1:0]               HipRxSt_vf_num_i,
   input  logic                               HipRxSt_vf_active_i,
   output  logic                              HipRxStReady_o,

//Rx Port Interface of the APP
   output  logic  [DBUS_WIDTH-1:0]            App_HipRxStData_o,
   output  logic  [1:0]                       App_HipRxStEmpty_o,
   output  logic                              App_HipRxStSop_o,
   output  logic                              App_HipRxStEop_o,
   output  logic                              App_HipRxStValid_o,
   output  logic  [7:0]                       App_HipRxStBarDec1_o,
   output  logic  [2:0]                       App_HipRxStBar_range_o,
   output  logic  [PFCNT_WD-1:0]              App_HipRxSt_pf_num_o,
   output  logic  [VFCNT_WD-1:0]              App_HipRxSt_vf_num_o,
   output  logic                              App_HipRxSt_vf_active_o,
   input  logic                               App_HipRxStReady_i,

//Tx Port Interface of the APP
   output   logic                             App_HipTxStReady_o  ,
   input  logic  [DBUS_WIDTH-1:0]             App_HipTxStData_i   ,
   input  logic                               App_HipTxStSop_i    ,
   input  logic                               App_HipTxStEop_i    ,
   input  logic                               App_HipTxStValid_i  ,
   input  logic                               App_HipTxStError_i  ,
   input  logic  [PFCNT_WD-1:0]               App_HipTxSt_pf_num_i,
   input  logic  [VFCNT_WD-1:0]               App_HipTxSt_vf_num_i,
   input  logic                               App_HipTxSt_vf_active_i,

//Tx port interface of PCI Exp HIP
   input   logic                              HipTxStReady_i  ,
   output  logic  [DBUS_WIDTH-1:0]            HipTxStData_o   ,
   output  logic                              HipTxStSop_o    ,
   output  logic                              HipTxStEop_o    ,
   output  logic                              HipTxStValid_o  ,
   output  logic                              HipTxStError_o  ,
   output  logic  [PFCNT_WD-1:0]              HipTxSt_pf_num_o,
   output  logic  [VFCNT_WD-1:0]              HipTxSt_vf_num_o,
   output  logic                              HipTxSt_vf_active_o


  );

//Rx Data Path
altpcieav_256_data_qwalign_bridge_rx #(

.DEVICE_FAMILY            ( DEVICE_FAMILY          ),
.DBUS_WIDTH               ( DBUS_WIDTH             ),
.BE_WIDTH                 ( BE_WIDTH               ),
.BURST_COUNT_WIDTH        ( BURST_COUNT_WIDTH      ),
.PF_COUNT                 ( PF_COUNT               ),
.VF_COUNT                 ( VF_COUNT               ),
.PFCNT_WD                 ( PFCNT_WD               ),
.VFCNT_WD                 ( VFCNT_WD               ),
.SRIOV_EN                 ( SRIOV_EN               )


) altpcieav_256_data_qwalign_bridge_rx_inst
(
.Clk_i                                          (Clk_i                          ),
.Rstn_i                                         (Rstn_i                         ),
.HipRxStData_i                                  (HipRxStData_i                  ),
.HipRxStEmpty_i                                 (HipRxStEmpty_i                 ),
.HipRxStSop_i                                   (HipRxStSop_i                   ),
.HipRxStEop_i                                   (HipRxStEop_i                   ),
.HipRxStValid_i                                 (HipRxStValid_i                 ),
.HipRxStBarRange_i                              (HipRxStBarRange_i              ),
.HipRxStBar_range_i                             (HipRxStBar_range_i             ),//Used in SRIOV
.HipRxSt_pf_num_i                               (HipRxSt_pf_num_i               ),
.HipRxSt_vf_num_i                               (HipRxSt_vf_num_i               ),
.HipRxSt_vf_active_i                            (HipRxSt_vf_active_i            ),
.HipRxStReady_o                                 (HipRxStReady_o                 ),
.App_HipRxStData_o                              (App_HipRxStData_o              ),
.App_HipRxStEmpty_o                             (App_HipRxStEmpty_o             ),
.App_HipRxStSop_o                               (App_HipRxStSop_o               ),
.App_HipRxStEop_o                               (App_HipRxStEop_o               ),
.App_HipRxStValid_o                             (App_HipRxStValid_o             ),
.App_HipRxStBarDec1_o                           (App_HipRxStBarDec1_o           ),
.App_HipRxStBar_range_o                         (App_HipRxStBar_range_o         ),
.App_HipRxSt_pf_num_o                           (App_HipRxSt_pf_num_o           ),
.App_HipRxSt_vf_num_o                           (App_HipRxSt_vf_num_o           ),
.App_HipRxSt_vf_active_o                        (App_HipRxSt_vf_active_o        ),
.App_HipRxStReady_i                             (App_HipRxStReady_i             )

  );


//Tx Data Path
altpcieav_256_data_qwalign_bridge_tx # (

.DEVICE_FAMILY            ( DEVICE_FAMILY          ),
.DBUS_WIDTH               ( DBUS_WIDTH             ),
.BE_WIDTH                 ( BE_WIDTH               ),
.BURST_COUNT_WIDTH        ( BURST_COUNT_WIDTH      ),
.PF_COUNT                 ( PF_COUNT               ),
.VF_COUNT                 ( VF_COUNT               ),
.PFCNT_WD                 ( PFCNT_WD               ),
.VFCNT_WD                 ( VFCNT_WD               ),
.SRIOV_EN                 ( SRIOV_EN               )



)altpcieav_256_data_qwalign_bridge_tx_inst
(
.Clk_i                                          (Clk_i                          )       ,
.Rstn_i                                         (Rstn_i                         )       ,
.App_HipTxStReady_o                             (App_HipTxStReady_o             )       ,
.App_HipTxStData_i                              (App_HipTxStData_i              )       ,
.App_HipTxStSop_i                               (App_HipTxStSop_i               )       ,
.App_HipTxStEop_i                               (App_HipTxStEop_i               )       ,
.App_HipTxStValid_i                             (App_HipTxStValid_i             )       ,
.App_HipTxStError_i                             (App_HipTxStError_i             )       ,
.App_HipTxSt_pf_num_i                           (App_HipTxSt_pf_num_i           )       ,
.App_HipTxSt_vf_num_i                           (App_HipTxSt_vf_num_i           )       ,
.App_HipTxSt_vf_active_i                        (App_HipTxSt_vf_active_i        )       ,
.HipTxStReady_i                                 (HipTxStReady_i                )       ,
.HipTxStData_o                                  (HipTxStData_o                 )       ,
.HipTxStSop_o                                   (HipTxStSop_o                  )       ,
.HipTxStEop_o                                   (HipTxStEop_o                  )       ,
.HipTxStValid_o                                 (HipTxStValid_o                )       ,
.HipTxStError_o                                 (HipTxStError_o                )       ,
.HipTxSt_pf_num_o                               (HipTxSt_pf_num_o              )       ,
.HipTxSt_vf_num_o                               (HipTxSt_vf_num_o              )       ,
.HipTxSt_vf_active_o                            (HipTxSt_vf_active_o           )
);


endmodule




