# (C) 2001-2018 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


####################################################################################################
#
# Clock conduit
#
proc add_port_clk {} {

   send_message debug "proc:add_port_clk"

   add_interface pld_clk clock end
   add_interface_port pld_clk Clk_i clk Input 1

}


##################################################################################################
#
# Reset conduit
#
proc add_port_rst {} {

   send_message debug "proc:add_port_rst"
   add_interface clr_st reset end
   set_interface_property clr_st ASSOCIATED_CLOCK pld_clk
   add_interface_port clr_st clr_st reset Input 1

}

####################################################################################################
#
# Avalon receive Data Streaming Interface from HIP
#
proc add_pcie_ast_rx_hip {} {

   send_message debug "proc:add_pcie_ast_rx_hip"

   set ast_width_hwtcl                    [ get_parameter_value DBUS_WIDTH]
   set dataWidth                          [ expr [ regexp 64 $ast_width_hwtcl  ] ? 64 : 128 ]
   set emptyWidth                         [ expr [ regexp 64 $ast_width_hwtcl  ] ? 2   : 1 ]

   add_interface rx_st_hip avalon_streaming sink

   set_interface_property rx_st_hip beatsPerCycle 1
   set_interface_property rx_st_hip dataBitsPerSymbol $dataWidth
   set_interface_property rx_st_hip maxChannel 0
   set_interface_property rx_st_hip readyLatency 3
   set_interface_property rx_st_hip symbolsPerBeat 1
   set_interface_property rx_st_hip ENABLED true
   set_interface_property rx_st_hip ASSOCIATED_CLOCK pld_clk

   add_interface_port rx_st_hip HipRxStData_i data Input $dataWidth
   add_interface_port rx_st_hip HipRxStSop_i startofpacket Input 1
   add_interface_port rx_st_hip HipRxStEop_i endofpacket Input 1
   add_interface_port rx_st_hip HipRxStErr_i error Input 1
   add_interface_port rx_st_hip HipRxStValid_i valid Input 1
   add_interface_port rx_st_hip HipRxStEmpty_i empty Input $emptyWidth

   add_interface_port rx_st_hip HipRxStReady_o ready Output 1
}

####################################################################################################
#
# Avalon receive Data Streaming Interface BAR decode signals from HIP
#
proc add_pcie_ast_bar_hip {} {
   send_message debug "proc:add_pcie_ast_bar_hip"
   add_interface rx_bar conduit end
   add_interface_port rx_bar HipRxStBarDec1_i rx_st_bar Input 8
   add_interface_port rx_bar HipRxStMask_o rx_st_mask Output 1
}


###################################################################################
#
# Avalon Transmit Data Streaming Interface to HIP
#
proc add_pcie_ast_tx_hip {} {

   send_message debug "proc:add_pcie_ast_tx_hip"

   set ast_width_hwtcl                    [ get_parameter_value DBUS_WIDTH]
   set dataWidth                          [ expr [ regexp 64 $ast_width_hwtcl  ] ? 64 : 128 ]
   set emptyWidth                         [ expr [ regexp 64 $ast_width_hwtcl  ] ? 2   : 1 ]


   add_interface tx_st_hip avalon_streaming source
   set_interface_property tx_st_hip beatsPerCycle 1
   set_interface_property tx_st_hip dataBitsPerSymbol $dataWidth
   set_interface_property tx_st_hip maxChannel 0
   set_interface_property tx_st_hip readyLatency 3
   set_interface_property tx_st_hip symbolsPerBeat 1
   set_interface_property tx_st_hip ENABLED true
   set_interface_property tx_st_hip ASSOCIATED_CLOCK pld_clk

   add_interface_port tx_st_hip HipTxStData_o data Output $dataWidth
   add_interface_port tx_st_hip HipTxStSop_o startofpacket Output 1
   add_interface_port tx_st_hip HipTxStEop_o endofpacket Output 1
   add_interface_port tx_st_hip HipTxStError_o error Output 1
   add_interface_port tx_st_hip HipTxStValid_o valid Output 1
   add_interface_port tx_st_hip HipTxStEmpty_o empty Output $emptyWidth

   add_interface_port tx_st_hip HipTxStReady_i ready Input 1

}


###################################################################################
#
# Avalon MM RX Master Interface
#
proc add_pcie_avmm_rxm {} {

   send_message debug "proc:add_pcie_avmm_rxm"

   add_interface hprxm avalon master
   set_interface_property "hprxm" associatedClock pld_clk
   set_interface_property "hprxm" associatedReset clr_st
   set_interface_property "hprxm" interleaveBursts false
   set_interface_property "hprxm" doStreamReads false
   set_interface_property "hprxm" doStreamWrites false
   set_interface_property "hprxm" maxAddressWidth 16
   set_interface_property "hprxm" addressGroup 0

   add_interface_port hprxm AvRxmWrite_0_o write Output 1
   add_interface_port hprxm AvRxmAddress_0_o address Output 16
   add_interface_port hprxm AvRxmWriteData_0_o writedata Output 32
   add_interface_port hprxm AvRxmByteEnable_0_o byteenable Output 4
   add_interface_port hprxm AvRxmWaitRequest_0_i waitrequest Input 1
   add_interface_port hprxm AvRxmRead_0_o read Output 1
   add_interface_port hprxm AvRxmReadData_0_i readdata Input 32
   add_interface_port hprxm AvRxmReadDataValid_0_i readdatavalid Input 1
}

###################################################################################
#
#       // HIP TL Config Interface Conduit
#
proc add_port_hip_tlcfg {} {

   send_message debug "proc:add_port_hip_tlcfg"
   add_interface config_tl conduit end
   add_interface_port config_tl HipCfgAddr_i tl_cfg_add Input 4
   add_interface_port config_tl HipCfgCtl_i tl_cfg_ctl Input 32
   add_interface_port config_tl TLCfgSts_i tl_cfg_sts Input 53
   add_interface_port config_tl cpl_err_o cpl_err Output 7
   add_interface_port config_tl cpl_pending_o cpl_pending Output 1
   add_interface_port config_tl hpg_ctrler_o hpg_ctrler Output 5
}

##################################################################################################
#
#       // HIP Status Conduit
#
proc add_port_hip_status {} {
   send_message debug "proc:add_port_hip_status"
   add_interface hip_status conduit end
   add_interface_port hip_status Ltssm_i ltssmstate Input 5
   add_interface_port hip_status LaneAct_i lane_act Input 4
   add_interface_port hip_status derr_cor_ext_rcv   derr_cor_ext_rcv    Input 1
   add_interface_port hip_status derr_cor_ext_rpl   derr_cor_ext_rpl    Input 1
   add_interface_port hip_status derr_rpl           derr_rpl            Input 1
   add_interface_port hip_status dlup_exit          dlup_exit           Input 1
   add_interface_port hip_status ev128ns            ev128ns             Input 1
   add_interface_port hip_status ev1us              ev1us               Input 1
   add_interface_port hip_status hotrst_exit        hotrst_exit         Input 1
   add_interface_port hip_status int_status         int_status          Input 4
   add_interface_port hip_status l2_exit            l2_exit             Input 1
   add_interface_port hip_status dlup               dlup                Input 1
   add_interface_port hip_status rx_par_err         rx_par_err          Input 1
   add_interface_port hip_status tx_par_err         tx_par_err          Input 2
   add_interface_port hip_status cfg_par_err        cfg_par_err         Input 1
   add_interface_port hip_status ko_cpl_spc_header ko_cpl_spc_header    Input 8
   add_interface_port hip_status ko_cpl_spc_data   ko_cpl_spc_data      Input 12
}
##################################################################################################
#
#       // HIP CurrentSpeed Conduit
#
proc add_port_hip_currentspeed {} {

   send_message debug "proc:add_port_hip_currentspeed"
   add_interface currentspeed conduit end
   add_interface_port currentspeed CurrentSpeed_i currentspeed Input 2
}

##################################################################################################
#
# HIP Reset conduit
#
proc add_port_hip_rst {} {

   send_message debug "proc:add_port_hip_rst"


   add_interface hip_rst conduit end
   add_interface_port hip_rst pld_clk_inuse pld_clk_inuse Input 1
   add_interface_port hip_rst pld_core_ready pld_core_ready Output 1
   add_interface_port hip_rst reset_status reset_status Input 1
   add_interface_port hip_rst serdes_pll_locked serdes_pll_locked Input 1
   add_interface_port hip_rst testin_zero testin_zero Input 1
}


##################################################################################################
#
# HIP TX Credit conduit
#
proc add_port_hip_txcredit {} {

   send_message debug "proc:add_port_hip_txcredit"


   add_interface tx_cred conduit end
   add_interface_port tx_cred  tx_cred_data_fc       tx_cred_data_fc      input    12
   add_interface_port tx_cred  tx_cred_fc_hip_cons   tx_cred_fc_hip_cons  input    6
   add_interface_port tx_cred  tx_cred_fc_infinite   tx_cred_fc_infinite  input    6
   add_interface_port tx_cred  tx_cred_hdr_fc        tx_cred_hdr_fc       input    8
   add_interface_port tx_cred  tx_cred_fc_sel        tx_cred_fc_sel       output   2

}

##################################################################################################
#
# HIP Power Managemnet conduit
#
proc add_port_hip_power_mgnt {} {

   send_message debug "proc:add_port_hip_power_mgnt"

   add_interface power_mgnt conduit end
   add_interface_port power_mgnt pm_auxpwr  pm_auxpwr output 1
   add_interface_port power_mgnt pm_data    pm_data   output 10
   add_interface_port power_mgnt pme_to_cr  pme_to_cr output 1
   add_interface_port power_mgnt pm_event   pm_event  output 1
   add_interface_port power_mgnt pme_to_sr  pme_to_sr input  1
}


##################################################################################################
#
# HIP Npor conduit
# #
# proc add_port_hip_npor {} {


   # send_message debug "proc:add_port_hip_npor"

   # add_interface npor conduit end
   # add_interface_port npor npor npor output 1
   # add_interface_port npor pin_perst pin_perst output 1
# }




##################################################################################################
#
# HIP INT_MSI conduit
#
proc add_port_hip_int_msi {} {

   send_message debug "proc:add_port_hip_int_msi"

   add_interface int_msi conduit end
   
   add_interface_port int_msi app_int_ack app_int_ack input  1
   add_interface_port int_msi app_int_sts app_int_sts output 1
   add_interface_port int_msi app_msi_ack app_msi_ack input  1
   add_interface_port int_msi app_msi_num app_msi_num output 5
   add_interface_port int_msi app_msi_req app_msi_req output 1
   add_interface_port int_msi app_msi_tc  app_msi_tc  output 3
}

