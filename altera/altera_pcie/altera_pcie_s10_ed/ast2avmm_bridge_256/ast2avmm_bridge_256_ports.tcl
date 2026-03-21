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
# AVMM 256 Clock conduit
#
proc add_port_clk {} {

   send_message debug "proc:add_port_clk"

   add_interface pld_clk clock end
   add_interface_port    pld_clk Clk_i    clk     Input  1

}


##################################################################################################
#
# AVMM 256 Reset conduit
#
proc add_port_rst {} {

   send_message debug "proc:add_port_rst"
   add_interface          clr_st   reset end
   set_interface_property clr_st   ASSOCIATED_CLOCK  pld_clk
   add_interface_port     clr_st   avmm_rst          reset     Input  1

}

####################################################################################################
#
# Avalon receive Data Streaming Interface from HIP
#
proc add_pcie_ast_rx_hip {} {

   send_message debug "proc:add_pcie_ast_rx_hip"


   add_interface rx_st_hip avalon_streaming sink

   set_interface_property rx_st_hip beatsPerCycle 1
   set_interface_property rx_st_hip dataBitsPerSymbol 256
   set_interface_property rx_st_hip maxChannel 0
   set_interface_property rx_st_hip readyLatency 3
   set_interface_property rx_st_hip symbolsPerBeat 1
   set_interface_property rx_st_hip ENABLED true
   set_interface_property rx_st_hip ASSOCIATED_CLOCK pld_clk

   add_interface_port rx_st_hip HipRxStData_i     data            Input 256
   add_interface_port rx_st_hip HipRxStSop_i      startofpacket   Input 1
   add_interface_port rx_st_hip HipRxStEop_i      endofpacket     Input 1
   add_interface_port rx_st_hip HipRxStValid_i    valid           Input 1
   add_interface_port rx_st_hip HipRxStEmpty_i    empty           Input 3

   add_interface_port rx_st_hip HipRxStReady_o    ready           Output 1
}

####################################################################################################
#
# Avalon receive Data Streaming Interface BAR decode signals from HIP
#
proc add_pcie_ast_bar_hip {} {
   set SRIOV_EN    [ get_parameter_value SRIOV_EN]
   send_message debug "proc:add_pcie_ast_bar_hip"
   add_interface rx_bar conduit end
   if { $SRIOV_EN == 0 } {
   add_interface_port rx_bar HipRxStBarRange_i rx_st_bar_range Input 3
   }
}


###################################################################################
#
# Avalon Transmit Data Streaming Interface to HIP
#
proc add_pcie_ast_tx_hip {} {

   send_message debug "proc:add_pcie_ast_tx_hip"

   set ast_width_hwtcl                    [ get_parameter_value DBUS_WIDTH]
   set dataWidth                          [ expr [ regexp 256 $ast_width_hwtcl  ] ? 256 : 128 ]
   set dataByteWidth                      [ expr [ regexp 256 $ast_width_hwtcl  ] ? 32   : 16 ]
   set emptyWidth                         [ expr $dataWidth/128 ]


   add_interface tx_st_hip avalon_streaming source
   set_interface_property tx_st_hip beatsPerCycle 1
   set_interface_property tx_st_hip dataBitsPerSymbol 256
   set_interface_property tx_st_hip maxChannel 0
   set_interface_property tx_st_hip readyLatency 3
   set_interface_property tx_st_hip symbolsPerBeat 1
   set_interface_property tx_st_hip ENABLED true
   set_interface_property tx_st_hip ASSOCIATED_CLOCK pld_clk

   add_interface_port tx_st_hip HipTxStData_o    data            Output  256
   add_interface_port tx_st_hip HipTxStSop_o     startofpacket   Output  1
   add_interface_port tx_st_hip HipTxStEop_o     endofpacket     Output  1
   add_interface_port tx_st_hip HipTxStError_o   error           Output  1
   add_interface_port tx_st_hip HipTxStValid_o   valid           Output  1

   add_interface_port tx_st_hip HipTxStReady_i   ready           Input   1

}

###################################################################################
#
# Avalon MM RX Master Interface
#
proc add_pcie_avmm_rxm {} {

   send_message debug "proc:add_pcie_avmm_rxm"

   set avmm_address_width                 [ get_parameter_value RXM_ADDR_WIDTH]
   set avmm_burst_cnt_width               [ get_parameter_value BURST_COUNT_WIDTH]
   set ast_width_hwtcl                    [ get_parameter_value DBUS_WIDTH]
   set dataWidth                          256
   set dataByteWidth                      32


   add_interface hprxm avalon master
   set_interface_property "hprxm" associatedClock pld_clk
   set_interface_property "hprxm" associatedReset clr_st
   set_interface_property "hprxm" interleaveBursts false
   set_interface_property "hprxm" doStreamReads false
   set_interface_property "hprxm" doStreamWrites false
   set_interface_property "hprxm" maxAddressWidth $avmm_address_width
   set_interface_property "hprxm" addressGroup 0

   add_interface_port hprxm AvRxmWrite_0_o             write          Output 1
   add_interface_port hprxm AvRxmAddress_0_o           address        Output $avmm_address_width
   add_interface_port hprxm AvRxmWriteData_0_o         writedata      Output 256
   add_interface_port hprxm AvRxmByteEnable_0_o        byteenable     Output 32
   add_interface_port hprxm AvRxmBurstCount_0_o        burstcount     Output $avmm_burst_cnt_width
   add_interface_port hprxm AvRxmWaitRequest_0_i       waitrequest    Input  1
   add_interface_port hprxm AvRxmRead_0_o              read           Output 1
   add_interface_port hprxm AvRxmReadData_0_i          readdata       Input  256
   add_interface_port hprxm AvRxmReadDataValid_0_i     readdatavalid  Input  1

   add_interface      rxm_irq interrupt receiver
   add_interface_port rxm_irq AvRxmIrq_i irq Input 1
}

###################################################################################
#
# Avalon MM TX Slave Interface
#
proc add_pcie_avmm_txs {} {

   send_message debug "proc:add_pcie_avmm_txs"

   set avmm_address_width                 [ get_parameter_value TX_S_ADDR_WIDTH]

   add_interface txs avalon slave
   set_interface_property txs associatedClock pld_clk
   set_interface_property txs associatedReset clr_st
   set_interface_property txs addressAlignment DYNAMIC
   set_interface_property txs interleaveBursts false
   set_interface_property txs readLatency 0
   set_interface_property txs writeWaitTime 1
   set_interface_property txs readWaitTime 1
   set_interface_property txs addressUnits SYMBOLS
   set_interface_property txs maximumPendingReadTransactions 8

   add_interface_port txs AvTxsChipSelect_i        chipselect     Input   1
   add_interface_port txs AvTxsWrite_i             write          Input   1
   add_interface_port txs AvTxsAddress_i           address        Input   $avmm_address_width
   add_interface_port txs AvTxsWriteData_i         writedata      Input   32
   add_interface_port txs AvTxsByteEnable_i        byteenable     Input   4
   add_interface_port txs AvTxsWaitRequest_o       waitrequest    Output  1
   add_interface_port txs AvTxsRead_i              read           Input   1
   add_interface_port txs AvTxsReadData_o          readdata       Output  32
   add_interface_port txs AvTxsReadDataValid_o     readdatavalid  Output  1

}

###################################################################################
#
# Avalon MM CRA Slave Interface
#
proc add_pcie_avmm_cra {} {

   send_message debug "proc:add_pcie_avmm_cra"

   add_interface cra avalon slave
   set_interface_property cra associatedClock pld_clk
   set_interface_property cra associatedReset clr_st
   set_interface_property cra addressAlignment DYNAMIC
   set_interface_property cra interleaveBursts false
   set_interface_property cra readLatency 0
   set_interface_property cra writeWaitTime 1
   set_interface_property cra readWaitTime 1
   set_interface_property cra addressUnits SYMBOLS

   add_interface_port cra AvCraChipSelect_i      chipselect      Input   1
   add_interface_port cra AvCraWrite_i           write           Input   1
   add_interface_port cra AvCraAddress_i         address         Input   14
   add_interface_port cra AvCraWriteData_i       writedata       Input   32
   add_interface_port cra AvCraByteEnable_i      byteenable      Input   4
   add_interface_port cra AvCraWaitRequest_o     waitrequest     Output  1
   add_interface_port cra AvCraRead_i            read            Input   1
   add_interface_port cra AvCraReadData_o        readdata        Output  32

   add_interface cra_irq interrupt sender
   add_interface_port cra_irq                    AvCraIrq_o irq  Output  1

}

##################################################################################################
#
#       // HIP TL Config Interface Conduit
#
proc add_port_hip_tlcfg {} {

   send_message debug "proc:add_port_hip_tlcfg"
   add_interface config_tl conduit end
   add_interface_port config_tl HipCfgAddr_i        tl_cfg_add         Input   5
   add_interface_port config_tl HipCfgCtl_i         tl_cfg_ctl         Input   32
   add_interface_port config_tl HipCfgFunc_i        tl_cfg_func        Input   2
   add_interface_port config_tl app_err_valid       app_err_valid      Output  1
   add_interface_port config_tl app_err_hdr         app_err_hdr        Output  32
   add_interface_port config_tl app_err_info        app_err_info       Output  11
}

##################################################################################################
#
#       // HIP Status Conduit
#
proc add_port_hip_status {} {
   send_message debug "proc:add_port_hip_status"
   add_interface hip_status conduit end
   add_interface_port hip_status Ltssm_i                ltssmstate          Input 6
   add_interface_port hip_status LaneAct_i              lane_act            Input 5
   add_interface_port hip_status derr_cor_ext_rcv       derr_cor_ext_rcv    Input 1
   add_interface_port hip_status derr_cor_ext_rpl       derr_cor_ext_rpl    Input 1
   add_interface_port hip_status derr_rpl               derr_rpl            Input 1
   add_interface_port hip_status derr_uncor_ext_rcv     derr_uncor_ext_rcv  Input 1
   add_interface_port hip_status link_up                link_up             Input 1
   add_interface_port hip_status int_status             int_status          Input 8
   add_interface_port hip_status int_status_common      int_status_common   Input 3
   add_interface_port hip_status rx_par_err             rx_par_err          Input 1
   add_interface_port hip_status tx_par_err             tx_par_err          Input 1

}
##################################################################################################
#
# HIP CurrentSpeed Conduit
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
   add_interface_port hip_rst pld_clk_inuse        pld_clk_inuse        Input   1
   add_interface_port hip_rst pld_core_ready       pld_core_ready       Output  1
   add_interface_port hip_rst reset_status         reset_status         Input   1
   add_interface_port hip_rst serdes_pll_locked    serdes_pll_locked    Input   1
   add_interface_port hip_rst testin_zero          testin_zero          Input   1
}


##################################################################################################
#
# HIP TX Credit conduit
#
proc add_port_hip_txcredit {} {

   send_message debug "proc:add_port_hip_txcredit"


   add_interface tx_cred conduit end
   add_interface_port tx_cred  tx_cdts_type                     tx_cdts_type                            input    2
   add_interface_port tx_cred  tx_data_cdts_consumed            tx_data_cdts_consumed                   input    1
   add_interface_port tx_cred  tx_hdr_cdts_consumed             tx_hdr_cdts_consumed                    input    1
   add_interface_port tx_cred  tx_cdts_data_value               tx_cdts_data_value                      input    2
   add_interface_port tx_cred  tx_pd_cdts                       tx_pd_cdts                              input    12
   add_interface_port tx_cred  tx_npd_cdts                      tx_npd_cdts                             input    12
   add_interface_port tx_cred  tx_cpld_cdts                     tx_cpld_cdts                            input    12
   add_interface_port tx_cred  tx_ph_cdts                       tx_ph_cdts                              input    8
   add_interface_port tx_cred  tx_nph_cdts                      tx_nph_cdts                             input    8
   add_interface_port tx_cred  tx_cplh_cdts                     tx_cplh_cdts                            input    8
}

##################################################################################################
#
# HIP Power Managemnet conduit
#
proc add_port_hip_power_mgnt {} {

   send_message debug "proc:add_port_hip_power_mgnt"

   add_interface power_mgnt conduit end

   add_interface_port power_mgnt   pm_linkst_in_l1              pm_linkst_in_l1                         input    1
   add_interface_port power_mgnt   pm_linkst_in_l0s             pm_linkst_in_l0s                        input    1
   add_interface_port power_mgnt   pm_state                     pm_state                                input    3
   add_interface_port power_mgnt   pm_dstate                    pm_dstate                               input    3
   add_interface_port power_mgnt   apps_pm_xmt_pme              apps_pm_xmt_pme                         output   1
   add_interface_port power_mgnt   apps_ready_entr_l23          apps_ready_entr_l23                     output   1
   add_interface_port power_mgnt   apps_pm_xmt_turnoff          apps_pm_xmt_turnoff                     output   1
   add_interface_port power_mgnt   app_init_rst                 app_init_rst                            output   1
   add_interface_port power_mgnt   app_xfer_pending             app_xfer_pending                        output   1
}

##################################################################################################
#
# HIP INT_MSI conduit
#
proc add_port_hip_int_msi {} {

   send_message debug "proc:add_port_hip_int_msi"
   set show_sriov    [ get_parameter_value SRIOV_EN]
   set pf_cnt_width  [ get_parameter_value PFCNT_WD]
   set vf_cnt_width   [ get_parameter_value VFCNT_WD ]
   set total_pf_cnt  [ get_parameter_value PF_COUNT]
   set port_type  [ get_parameter_value PORT_TYPE]

   add_interface int_msi conduit end
   if { [regexp endpoint $port_type ] } {
       if {$show_sriov == 0 } {
       add_interface_port int_msi app_int_sts app_int_sts output 1
       add_interface_port int_msi app_msi_ack app_msi_ack input  1
       add_interface_port int_msi app_msi_num app_msi_num output 5
       add_interface_port int_msi app_msi_req app_msi_req output 1
       add_interface_port int_msi app_msi_tc  app_msi_tc  output 3
       } else {
#SRIOV - Unused Interface
       add_interface_port int_msi app_msi_req_fn app_msi_req_fn output $pf_cnt_width
       add_interface_port int_msi app_msi_status app_msi_status input 2
       add_interface_port int_msi app_msi_pending_bit_write_en    app_msi_pending_bit_write_en    output  1
       add_interface_port int_msi app_msi_pending_bit_write_data  app_msi_pending_bit_write_data  output  1

       # PF MSI Capability Register Outputs
       add_interface_port int_msi app_msi_addr_pf                 app_msi_addr_pf               input $total_pf_cnt*64
       add_interface_port int_msi app_msi_data_pf                 app_msi_data_pf               input $total_pf_cnt*16
       add_interface_port int_msi app_msi_mask_pf                 app_msi_mask_pf               input $total_pf_cnt*32
       add_interface_port int_msi app_msi_pending_pf              app_msi_pending_pf            input $total_pf_cnt*32
       add_interface_port int_msi app_msi_enable_pf               app_msi_enable_pf             input $total_pf_cnt
       add_interface_port int_msi app_msi_multi_msg_enable_pf     app_msi_multi_msg_enable_pf   input $total_pf_cnt*3

       # Legacy interrupt status from PFs
       add_interface_port int_msi app_int_pf_sts  app_int_pf_sts output  $total_pf_cnt
       set_port_property  app_int_pf_sts VHDL_TYPE std_logic_vector

       add_interface_port int_msi app_intx_disable app_intx_disable input $total_pf_cnt
       set_port_property  app_intx_disable VHDL_TYPE std_logic_vector
       # MSIX Request
       add_interface_port int_msi app_msix_req        app_msix_req            output  1
       add_interface_port int_msi app_msix_addr       app_msix_addr           output  64
       add_interface_port int_msi app_msix_data       app_msix_data           output  32
       add_interface_port int_msi app_msix_pf_num     app_msix_pf_num         output  $pf_cnt_width
       set_port_property  app_msix_pf_num VHDL_TYPE   std_logic_vector
       add_interface_port int_msi app_msix_vf_num     app_msix_vf_num         output  $vf_cnt_width
       set_port_property  app_msix_vf_num VHDL_TYPE   std_logic_vector
       add_interface_port int_msi app_msix_vf_active  app_msix_vf_active      output  1
       add_interface_port int_msi app_msix_ack        app_msix_ack            input 1
       add_interface_port int_msi app_msix_err        app_msix_err            input 1

       #MSIX Capability Register Outputs
       add_interface_port int_msi app_msix_en_pf      app_msix_en_pf          input $total_pf_cnt
       add_interface_port int_msi app_msix_fn_mask_pf app_msix_fn_mask_pf     input $total_pf_cnt

       add_interface_port int_msi app_msi_ack app_msi_ack input  1
       add_interface_port int_msi app_msi_num app_msi_num output 5
       add_interface_port int_msi app_msi_req app_msi_req output 1
       add_interface_port int_msi app_msi_tc  app_msi_tc  output 3
       }
   }
}

###################################################################################
#All Interfaces below are SRIOV Bridge Signals - Unused in this design
###################################################################################
# Avalon receive Data Streaming Interface Sidebad Signals
proc add_pcie_ast_sideband_rx_app {} {

   send_message debug "proc:add_pcie_ast_sideband_rx_app"

   set total_pf_cnt_wd                       [ get_parameter_value PFCNT_WD]
   set total_vf_cnt_wd                       [ get_parameter_value VFCNT_WD]

   add_interface rx_st_sideband_app conduit end
   add_interface_port rx_st_sideband_app HipRxStBar_range_i    rx_st_bar_range    Input  3
   add_interface_port rx_st_sideband_app HipRxSt_pf_num_i      rx_st_pf_num       Input  $total_pf_cnt_wd
   add_interface_port rx_st_sideband_app HipRxSt_vf_num_i      rx_st_vf_num       Input  $total_vf_cnt_wd
   add_interface_port rx_st_sideband_app HipRxSt_vf_active_i   rx_st_vf_active    Input  1

}
# Avalon Transmit Data Streaming Interface Sidebad Signals from user application
proc add_pcie_ast_sideband_tx_app {} {

   send_message debug "proc:add_pcie_ast_sideband_tx_app"

   set total_pf_cnt_wd                       [ get_parameter_value PFCNT_WD]
   set total_vf_cnt_wd                       [ get_parameter_value VFCNT_WD]

   add_interface tx_st_sideband_app conduit end
   add_interface_port tx_st_sideband_app HipTxSt_pf_num_o     tx_st_pf_num     Output $total_pf_cnt_wd
   add_interface_port tx_st_sideband_app HipTxSt_vf_num_o     tx_st_vf_num     Output $total_vf_cnt_wd
   add_interface_port tx_st_sideband_app HipTxSt_vf_active_o  tx_st_vf_active  Output 1

}


# Config Status interface conduit
proc add_pcie_cfg_status {} {

   send_message debug "proc:add_pcie_cfg_status"

   set total_vf_cnt   [ get_parameter_value VF_COUNT ]
   set total_pf_cnt   [ get_parameter_value PF_COUNT ]
   set vf_cnt_width   [ get_parameter_value VFCNT_WD ]
   set pf_cnt_width   [ get_parameter_value PFCNT_WD ]

   add_interface cfg_status conduit end

   add_interface_port cfg_status  bus_num_f0        bus_num_f0         input  8
   add_interface_port cfg_status  bus_num_f1        bus_num_f1         input  8
   add_interface_port cfg_status  bus_num_f2        bus_num_f2         input  8
   add_interface_port cfg_status  bus_num_f3        bus_num_f3         input  8
   add_interface_port cfg_status  device_num_f0     device_num_f0      input  5
   add_interface_port cfg_status  device_num_f1     device_num_f1      input  5
   add_interface_port cfg_status  device_num_f2     device_num_f2      input  5
   add_interface_port cfg_status  device_num_f3     device_num_f3      input  5
   add_interface_port cfg_status  mem_space_en_pf   mem_space_en_pf    input  $total_pf_cnt
   add_interface_port cfg_status  bus_master_en_pf  bus_master_en_pf   input  $total_pf_cnt
   add_interface_port cfg_status  mem_space_en_vf   mem_space_en_vf    input  $total_pf_cnt
   add_interface_port cfg_status  pf0_num_vfs       pf0_num_vfs        input  16
   add_interface_port cfg_status  pf1_num_vfs       pf1_num_vfs        input  16
   add_interface_port cfg_status  pf2_num_vfs       pf2_num_vfs        input  16
   add_interface_port cfg_status  pf3_num_vfs       pf3_num_vfs        input  16
   add_interface_port cfg_status  max_payload_size  max_payload_size   input  3
   add_interface_port cfg_status  rd_req_size       rd_req_size        input  3
   add_interface_port cfg_status  compl_timeout_disable_pf   compl_timeout_disable_pf    input  $total_pf_cnt
   add_interface_port cfg_status  atomic_op_requester_en_pf   atomic_op_requester_en_pf    input  $total_pf_cnt
   add_interface_port cfg_status  tph_st_mode_pf   tph_st_mode_pf    input  $total_pf_cnt*2
   add_interface_port cfg_status  tph_requester_en_pf   tph_requester_en_pf    input  $total_pf_cnt
   add_interface_port cfg_status  ats_stu_pf   ats_stu_pf    input  $total_pf_cnt*5
   add_interface_port cfg_status  ats_en_pf   ats_en_pf    input  $total_pf_cnt
   add_interface_port cfg_status  extended_tag_en_pf   extended_tag_en_pf    input  $total_pf_cnt

   add_interface_port cfg_status  ctl_shdw_update        ctl_shdw_update         Input  1
   add_interface_port cfg_status  ctl_shdw_pf_num        ctl_shdw_pf_num         Input  $pf_cnt_width
   add_interface_port cfg_status  ctl_shdw_vf_num        ctl_shdw_vf_num         Input  $vf_cnt_width
   add_interface_port cfg_status  ctl_shdw_vf_active     ctl_shdw_vf_active      Input  1
   add_interface_port cfg_status  ctl_shdw_cfg           ctl_shdw_cfg            Input  7
   add_interface_port cfg_status  ctl_shdw_req_all       ctl_shdw_req_all        Output  1
}

# APP LMI Interface conduit
proc add_pcie_sriov_lmiapp {} {

   send_message debug "proc:add_pcie_sriov_lmiapp"

   set total_vf_cnt   [ get_parameter_value VF_COUNT ]
   set total_pf_cnt   [ get_parameter_value PF_COUNT ]
   set vf_cnt_width   [ get_parameter_value VFCNT_WD ]
   set pf_cnt_width   [ get_parameter_value PFCNT_WD ]
   set show_sriov    [ get_parameter_value SRIOV_EN]

   add_interface lmiapp conduit end

   add_interface_port lmiapp  lmi_addr_app         lmi_addr         Output  12
   if { $show_sriov == 0 } {
   add_interface_port lmiapp  lmi_dest_app         lmi_dest         Output  1
   }
   add_interface_port lmiapp  lmi_pf_num_app       lmi_pf_num       Output  $pf_cnt_width
   add_interface_port lmiapp  lmi_vf_num_app       lmi_vf_num       Output  $vf_cnt_width
   add_interface_port lmiapp  lmi_din_app          lmi_din          Output  32
   add_interface_port lmiapp  lmi_rden_app         lmi_rden         Output  1
   add_interface_port lmiapp  lmi_wren_app         lmi_wren         Output  1

   add_interface_port lmiapp  lmi_vf_active_app    lmi_vf_active    Input 1
   add_interface_port lmiapp  lmi_ack_app          lmi_ack          Input 1
   add_interface_port lmiapp  lmi_dout_app         lmi_dout         Input 32
}

# Completion Status Signals from user application
 proc add_pcie_config_tl {} {

    send_message debug "proc: add_pcie_config_tl"
   set total_vf_cnt   [ get_parameter_value VF_COUNT ]
   set total_pf_cnt   [ get_parameter_value PF_COUNT ]
   set vf_cnt_width   [ get_parameter_value VFCNT_WD ]
   set pf_cnt_width   [ get_parameter_value PFCNT_WD ]

    add_interface      config_tl conduit end
    add_interface_port config_tl cpl_err                         cpl_err                        Output 7
    add_interface_port config_tl cpl_err_pf_num                  cpl_err_pf_num                 Output $pf_cnt_width
    add_interface_port config_tl cpl_err_vf_num                  cpl_err_vf_num                 Output $vf_cnt_width
    add_interface_port config_tl cpl_err_vf_active               cpl_err_vf_active              Output 1
    add_interface_port config_tl cpl_pending_pf                  cpl_pending_pf                 Output $total_pf_cnt
    add_interface_port config_tl log_hdr                         log_hdr                        Output 128
    add_interface_port config_tl vf_compl_status_update          vf_compl_status_update         Output 1
    add_interface_port config_tl vf_compl_status                 vf_compl_status                Output 1
    add_interface_port config_tl vf_compl_status_pf_num          vf_compl_status_pf_num         Output $pf_cnt_width
    add_interface_port config_tl vf_compl_status_vf_num          vf_compl_status_vf_num         Output $vf_cnt_width
    add_interface_port config_tl vf_compl_status_update_ack      vf_compl_status_update_ack     Input 1
 }

# Functional_level reset
 proc add_pcie_sriov_flr {} {

    send_message debug "proc: add_pcie_sriov_flr"
   set total_vf_cnt   [ get_parameter_value VF_COUNT ]
   set total_pf_cnt   [ get_parameter_value PF_COUNT ]
   set vf_cnt_width   [ get_parameter_value VFCNT_WD ]
   set pf_cnt_width   [ get_parameter_value PFCNT_WD ]

    add_interface flr_app conduit end

    add_interface_port flr_app  flr_active_pf     flr_active_pf     Input   $total_pf_cnt
    add_interface_port flr_app  flr_rcvd_vf       flr_rcvd_vf       Input   1
    add_interface_port flr_app  flr_rcvd_pf_num   flr_rcvd_pf_num   Input   $pf_cnt_width
    add_interface_port flr_app  flr_rcvd_vf_num   flr_rcvd_vf_num   Input   $vf_cnt_width

    add_interface_port flr_app  flr_completed_pf  flr_completed_pf  Output    $total_pf_cnt
    add_interface_port flr_app  flr_completed_vf  flr_completed_vf  Output    1
    add_interface_port flr_app  flr_completed_pf_num  flr_completed_pf_num  Output    $pf_cnt_width
    add_interface_port flr_app  flr_completed_vf_num  flr_completed_vf_num  Output    $vf_cnt_width

 }






