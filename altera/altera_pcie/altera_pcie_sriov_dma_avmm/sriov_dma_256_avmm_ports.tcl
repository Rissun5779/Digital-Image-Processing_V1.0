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
# Power on reset
#
proc add_pcie_hip_port_clk_rst {} {
   add_interface coreclkout_hip clock end
   add_interface_port coreclkout_hip coreclkout_hip clk Input 1

   add_interface pld_clk_hip clock start
   add_interface_port pld_clk_hip pld_clk_hip clk Output 1
  # clockRate for pld_clk_hip is defined in pcie_256_avmm_parameters.tcl

   add_interface hip_rst conduit end
   add_interface_port hip_rst reset_status   reset_status  Input 1
   add_interface_port hip_rst serdes_pll_locked   serdes_pll_locked  Input 1
   add_interface_port hip_rst pld_clk_inuse  pld_clk_inuse Input 1
   add_interface_port hip_rst pld_core_ready pld_core_ready     Output 1
   add_interface_port hip_rst testin_zero    testin_zero   Input 1

   add_interface app_rstn reset start pld_clk_hip
   add_interface_port app_rstn app_rstn_o reset_n Output 1
   set_interface_property app_rstn synchronousEdges both
}


####################################################################################################
#
# Avalon-ST RX
#
proc add_ed_sriov_port_ast_rx {} {

   send_message debug "proc:add_ed_sriov_port_ast_rx"
   set ast_width_hwtcl  [ get_parameter_value port_width_data_hwtcl]
   set dev_family [get_parameter_value INTENDED_DEVICE_FAMILY ]
   set multiple_packets_per_cycle_hwtcl   [ get_parameter_value multiple_packets_per_cycle_hwtcl]


   # Design example does not support parity yet
   set ast_parity   0
   set dataWidth        [ expr [ regexp 256 $ast_width_hwtcl  ] ? 256 : [ regexp 128 $ast_width_hwtcl ] ? 128 : 64 ]
   set dataByteWidth    [ expr [ regexp 256 $ast_width_hwtcl  ] ? 32  : [ regexp 128 $ast_width_hwtcl ] ? 16 : 8 ]

   # Avalon-stream RX HIP
   add_interface rx_st avalon_streaming end
   if { $multiple_packets_per_cycle_hwtcl == 1 } {
      set_interface_property rx_st beatsPerCycle 2
      set_interface_property rx_st dataBitsPerSymbol 128
   } else {
      set_interface_property rx_st beatsPerCycle 1
      set_interface_property rx_st dataBitsPerSymbol $dataWidth
   }
   set_interface_property rx_st maxChannel 0
   set_interface_property rx_st readyLatency 3
   set_interface_property rx_st symbolsPerBeat 1
   set_interface_property rx_st ENABLED true
   set_interface_property rx_st associatedClock pld_clk_hip
   set_interface_property rx_st associatedReset app_rstn

   if { $multiple_packets_per_cycle_hwtcl == 1 } {
      add_interface_port rx_st rx_st_sop startofpacket Input 2
      add_interface_port rx_st rx_st_eop endofpacket Input 2
      add_interface_port rx_st rx_st_err error Input 2
      add_interface_port rx_st rx_st_valid valid Input 2
   } else {
      add_interface_port rx_st rx_st_sop startofpacket Input 1
      add_interface_port rx_st rx_st_eop endofpacket Input 1
      add_interface_port rx_st rx_st_err error Input 1
      add_interface_port rx_st rx_st_valid valid Input 1
   }
   set_port_property rx_st_sop VHDL_TYPE std_logic_vector
   set_port_property rx_st_eop VHDL_TYPE std_logic_vector
   set_port_property rx_st_err VHDL_TYPE std_logic_vector
   set_port_property rx_st_valid VHDL_TYPE std_logic_vector
   if { $dataWidth > 64 } {
         add_interface_port rx_st rx_st_empty empty Input 2
         set_port_property  rx_st_empty VHDL_TYPE std_logic_vector
   } else {
         add_to_no_connect rx_st_empty 1 In
         set_port_property  rx_st_empty VHDL_TYPE std_logic_vector
   }
   add_interface_port rx_st rx_st_ready ready Output 1
   add_interface_port rx_st rx_st_data data Input $dataWidth
   # Parity
   if { $ast_parity == 0 } {
      add_to_no_connect rx_st_parity $dataByteWidth Input
   } else {
      add_interface_port rx_st rx_st_parity parity Input $dataByteWidth
   }


   #===================================
   # rx_bar_hit I/O
   #===================================
   add_interface rx_bar_hit conduit end
   # Rx st mask
   add_interface_port rx_bar_hit rx_st_mask              rx_st_mask             Output 1
   add_interface_port rx_bar_hit rx_st_bar_hit_tlp0_i    rx_st_bar_hit_tlp0     Input 8
   add_interface_port rx_bar_hit rx_st_bar_hit_fn_tlp0_i rx_st_bar_hit_fn_tlp0  Input 8
   add_interface_port rx_bar_hit rx_st_bar_hit_tlp1_i    rx_st_bar_hit_tlp1     Input 8
   add_interface_port rx_bar_hit rx_st_bar_hit_fn_tlp1_i rx_st_bar_hit_fn_tlp1  Input 8

}

####################################################################################################
#
# Avalon-ST TX
#
proc add_ed_sriov_port_ast_tx {} {

   send_message debug "proc:add_ed_sriov_port_ast_tx"
   set dev_family [get_parameter_value INTENDED_DEVICE_FAMILY ]
   set use_tx_cons_cred_sel_hwtcl [get_parameter_value use_tx_cons_cred_sel_hwtcl]

   set ast_width_hwtcl  [ get_parameter_value port_width_data_hwtcl]
   set multiple_packets_per_cycle_hwtcl   [ get_parameter_value multiple_packets_per_cycle_hwtcl]

   # Design example does not support parity yet
   set ast_parity   0
   set dataWidth        [ expr [ regexp 256 $ast_width_hwtcl  ] ? 256 : [ regexp 128 $ast_width_hwtcl ] ? 128 : 64 ]
   set dataByteWidth    [ expr [ regexp 256 $ast_width_hwtcl  ] ? 32  : [ regexp 128 $ast_width_hwtcl ] ? 16 : 8 ]

   # Avalon-stream RX HIP
   # indicates that AST symbols ordering is little endian instead of Big endian
   # set_interface_property rx_st highOrderSymbolAtMSB false
   add_interface tx_st avalon_streaming start
   if { $multiple_packets_per_cycle_hwtcl == 1 } {
      set_interface_property tx_st beatsPerCycle 2
      set_interface_property tx_st dataBitsPerSymbol 128
   } else {
      set_interface_property tx_st beatsPerCycle 1
      set_interface_property tx_st dataBitsPerSymbol $dataWidth
   }
   set_interface_property tx_st maxChannel 0
   set_interface_property tx_st readyLatency 3
   set_interface_property tx_st symbolsPerBeat 1
   set_interface_property tx_st ENABLED true
   set_interface_property tx_st associatedClock pld_clk_hip
   set_interface_property tx_st associatedReset app_rstn

   if { $multiple_packets_per_cycle_hwtcl == 1 } {
      add_interface_port tx_st tx_st_sop startofpacket Output 2
      add_interface_port tx_st tx_st_eop endofpacket Output 2
      add_interface_port tx_st tx_st_err error Output 2
      add_interface_port tx_st tx_st_valid valid Output 2
   } else {
      add_interface_port tx_st tx_st_sop startofpacket Output 1
      add_interface_port tx_st tx_st_eop endofpacket Output 1
      add_interface_port tx_st tx_st_err error Output 1
      add_interface_port tx_st tx_st_valid valid Output 1
   }
   set_port_property tx_st_sop VHDL_TYPE std_logic_vector
   set_port_property tx_st_eop VHDL_TYPE std_logic_vector
   set_port_property tx_st_err VHDL_TYPE std_logic_vector
   set_port_property tx_st_valid VHDL_TYPE std_logic_vector
   if { $dataWidth > 64 } {
      if { $dev_family == "Arria V GZ" } {
          add_interface_port tx_st tx_st_empty empty Output 1
          set_port_property  tx_st_empty VHDL_TYPE std_logic_vector
      } else {
         add_interface_port tx_st tx_st_empty empty Output 2
         set_port_property  tx_st_empty VHDL_TYPE std_logic_vector
      }
   }
   add_interface_port tx_st tx_st_ready ready Input 1
   add_interface_port tx_st tx_st_data data Output $dataWidth

   # Parity
   if { $ast_parity == 0 } {
      add_to_no_connect tx_st_parity $dataByteWidth Output
   } else {
      add_interface_port tx_st tx_st_parity parity Output $dataByteWidth
   }

   #Tx Fifo Information
   if { $dev_family == "Arria V GZ" } {
      add_interface tx_fifo conduit end
      add_interface_port tx_fifo tx_fifo_empty fifo_empty Input 1
   } else {
      add_interface_port no_connect tx_fifo_empty fifo_empty Input 1
      set_port_property             tx_fifo_empty TERMINATION true
      set_port_property             tx_fifo_empty TERMINATION_VALUE 1
   }

   # Credit Information
   add_interface tx_cred conduit end

   if { $dev_family == "Stratix V" } {
      add_interface_port tx_cred tx_cred_fchipcons   tx_cred_fchipcons   Input 6
      add_interface_port tx_cred tx_cred_fcinfinite  tx_cred_fcinfinite  Input 6
      add_interface_port tx_cred tx_cred_datafccp    tx_cred_datafccp    Input 12
      add_interface_port tx_cred tx_cred_datafcnp    tx_cred_datafcnp    Input 12
      add_interface_port tx_cred tx_cred_datafcp     tx_cred_datafcp     Input 12
      add_interface_port tx_cred tx_cred_hdrfcp      tx_cred_hdrfcp      Input 8
      add_interface_port tx_cred tx_cred_hdrfcnp     tx_cred_hdrfcnp     Input 8
      add_interface_port tx_cred tx_cred_hdrfccp     tx_cred_hdrfccp     Input 8
   } else  {
         add_interface_port tx_cred tx_cred_fchipcons   tx_cred_fc_hip_cons Input 6
         add_interface_port tx_cred tx_cred_fcinfinite  tx_cred_fc_infinite Input 6
         add_interface_port tx_cred tx_cred_data_fc     tx_cred_data_fc     Input 12
         add_interface_port tx_cred tx_cred_hdr_fc      tx_cred_hdr_fc      Input 8
         add_interface_port tx_cred tx_cred_fc_sel      tx_cred_fc_sel      output 2
         if { $use_tx_cons_cred_sel_hwtcl == 1 } {
            add_interface_port tx_cred tx_cons_cred_sel tx_cons_cred_sel    output 1
         }
   }   

}

################################################################################################
#
# Completion Status Signals from user application
#
proc add_ed_sriov_port_completion {} {
   set dev_family [get_parameter_value INTENDED_DEVICE_FAMILY ]

   send_message debug "proc: add_ed_sriov_port_completion"
   set TOTAL_VF_COUNT [ get_parameter_value TOTAL_VF_COUNT]
   set TOTAL_PF_COUNT [ get_parameter_value TOTAL_PF_COUNT]

   add_interface      hip_completion conduit end
   add_interface_port hip_completion cpl_err         cpl_err        Output 7
   add_interface_port hip_completion cpl_err_fn      cpl_err_fn     Output 8
   add_interface_port hip_completion cpl_pending_pf  cpl_pending_pf Output $TOTAL_PF_COUNT
   add_interface_port hip_completion cpl_pending_vf  cpl_pending_vf Output $TOTAL_VF_COUNT
   add_interface_port hip_completion log_hdr         log_hdr        Output 128

  #set_interface_assignment hip_completion "ui.blockdiagram.direction" "output"

}

####################################################################################################
#
# Config-Status interface conduit 
#
proc add_ed_sriov_port_cfgstatus {} {

   send_message debug "proc:add_ed_sriov_port_cfgstatus"
   set TOTAL_VF_COUNT [ get_parameter_value TOTAL_VF_COUNT]
   set TOTAL_PF_COUNT [ get_parameter_value TOTAL_PF_COUNT]


   add_interface cfg_status conduit end

   add_interface_port cfg_status  bus_num_f0_i        bus_num_f0         Input  8
   add_interface_port cfg_status  bus_num_f1_i        bus_num_f1         Input  8
   add_interface_port cfg_status  device_num_f0_i     device_num_f0      Input  5
   add_interface_port cfg_status  device_num_f1_i     device_num_f1      Input  5
   add_interface_port cfg_status  mem_space_en_pf_i   mem_space_en_pf    Input  $TOTAL_PF_COUNT
   add_interface_port cfg_status  bus_master_en_pf_i  bus_master_en_pf   Input  $TOTAL_PF_COUNT
   add_interface_port cfg_status  mem_space_en_vf_i   mem_space_en_vf    Input  $TOTAL_PF_COUNT
   add_interface_port cfg_status  bus_master_en_vf_i  bus_master_en_vf   Input  $TOTAL_VF_COUNT
   add_interface_port cfg_status  pf0_num_vfs_i       pf0_num_vfs        Input  8
   add_interface_port cfg_status  pf1_num_vfs_i       pf1_num_vfs        Input  8
   add_interface_port cfg_status  max_payload_size_i  max_payload_size   Input  3
   add_interface_port cfg_status  rd_req_size_i       rd_req_size        Input  3
}


##############################################################################################
#
# Functional_level reset
#
proc add_ed_sriov_port_flr {} {
   send_message debug "proc: add_pcie_sriov_port_flr"
   set TOTAL_VF_COUNT [ get_parameter_value TOTAL_VF_COUNT]
   set TOTAL_PF_COUNT [ get_parameter_value TOTAL_PF_COUNT]

   add_interface flr conduit end
   add_interface_port flr  flr_active_pf     flr_active_pf     Input   $TOTAL_PF_COUNT
   add_interface_port flr  flr_active_vf     flr_active_vf     Input   $TOTAL_VF_COUNT
   add_interface_port flr  flr_completed_pf  flr_completed_pf  Output  $TOTAL_PF_COUNT
   add_interface_port flr  flr_completed_vf  flr_completed_vf  Output  $TOTAL_VF_COUNT
}


####################################################################################################
#
# Design Example Status conduit
#
proc add_ed_sriov_port_status {} {

   send_message debug "proc:add_ed_sriov_port_status"
   set dev_family [get_parameter_value INTENDED_DEVICE_FAMILY ]
 #  set track_rxfc_cplbuf_ovf_hwtcl [get_parameter_value track_rxfc_cplbuf_ovf_hwtcl]

   add_interface hip_status conduit end
   add_interface_port hip_status derr_cor_ext_rcv   derr_cor_ext_rcv   Input 1
   add_interface_port hip_status derr_cor_ext_rpl   derr_cor_ext_rpl   Input 1
   add_interface_port hip_status derr_rpl           derr_rpl           Input 1
   add_interface_port hip_status dlup_exit          dlup_exit          Input 1
   add_interface_port hip_status ev128ns            ev128ns            Input 1
   add_interface_port hip_status ev1us              ev1us              Input 1
   add_interface_port hip_status hotrst_exit        hotrst_exit        Input 1
   add_interface_port hip_status int_status         int_status         Input 4
   add_interface_port hip_status l2_exit            l2_exit            Input 1
   add_interface_port hip_status lane_act           lane_act           Input 4
   add_interface_port hip_status ltssmstate         ltssmstate         Input 5
   
   if { $dev_family == "Stratix V" || $dev_family == "Arria V" } {
      add_interface hip_status_drv conduit end
      add_interface_port hip_status_drv derr_cor_ext_rcv_drv   derr_cor_ext_rcv   Output 1
      add_interface_port hip_status_drv derr_cor_ext_rpl_drv   derr_cor_ext_rpl   Output 1
      add_interface_port hip_status_drv derr_rpl_drv           derr_rpl           Output 1
      add_interface_port hip_status_drv dlup_exit_drv          dlup_exit          Output 1
      add_interface_port hip_status_drv ev128ns_drv            ev128ns            Output 1
      add_interface_port hip_status_drv ev1us_drv              ev1us              Output 1
      add_interface_port hip_status_drv hotrst_exit_drv        hotrst_exit        Output 1
      add_interface_port hip_status_drv int_status_drv         int_status         Output 4
      add_interface_port hip_status_drv l2_exit_drv            l2_exit            Output 1
      add_interface_port hip_status_drv lane_act_drv           lane_act           Output 4
      add_interface_port hip_status_drv ltssmstate_drv         ltssmstate         Output 5
   }

   if { $dev_family == "Arria V GZ" } {
      add_to_no_connect  dlup 1 In
      add_to_no_connect  rx_par_err  1 In
      add_to_no_connect  tx_par_err  2 In
      add_to_no_connect  cfg_par_err 1 In
   } else {
      add_interface_port hip_status     dlup               dlup               Input 1
      # Parity error
      add_interface_port hip_status     rx_par_err         rx_par_err         Input 1
      add_interface_port hip_status	tx_par_err         tx_par_err         Input 2
      add_interface_port hip_status	cfg_par_err        cfg_par_err        Input 1
      

      if { $dev_family == "Stratix V" } {
         add_interface_port hip_status_drv dlup_drv           dlup               Output 1
         # Parity error
         add_interface_port hip_status_drv rx_par_err_drv     rx_par_err         Output 1
         add_interface_port hip_status_drv tx_par_err_drv     tx_par_err         Output 2
         add_interface_port hip_status_drv cfg_par_err_drv    cfg_par_err        Output 1
      }   
   }

   # Completion space information
   add_interface_port hip_status     ko_cpl_spc_header	   ko_cpl_spc_header Input 8
   add_interface_port hip_status     ko_cpl_spc_data	     ko_cpl_spc_data   Input 12
   if { $dev_family == "Stratix V" || $dev_family == "Arria V GZ" } {
      add_interface_port hip_status_drv ko_cpl_spc_header_drv ko_cpl_spc_header Output 8
      add_interface_port hip_status_drv ko_cpl_spc_data_drv   ko_cpl_spc_data   Output 12
   }

 #  if { $track_rxfc_cplbuf_ovf_hwtcl == 1 } {
 #     add_interface_port  hip_status rxfc_cplbuf_ovf rxfc_cplbuf_ovf Input 1
 #  } else {
 #     add_to_no_connect rxfc_cplbuf_ovf     1     In
 #  }

}

####################################################################################################
#
# Interrupt interface conduit
#
proc add_ed_sriov_port_interrupt {} {

   set TOTAL_VF_COUNT [ get_parameter_value TOTAL_VF_COUNT]
   set TOTAL_PF_COUNT [ get_parameter_value TOTAL_PF_COUNT]
   set enable_int_hwtcl [ get_parameter_value enable_int_hwtcl]

   if { $enable_int_hwtcl== 1} {
      send_message debug "proc:add_ed_sriov_port_interrupt"
      add_interface int_msi conduit end

      add_interface_port int_msi app_msi_req    app_msi_req    Output  1
      add_interface_port int_msi app_msi_status app_msi_status Input 2
      add_interface_port int_msi app_msi_ack    app_msi_ack    Input 1
      add_interface_port int_msi app_msi_req_fn app_msi_req_fn Output  8
      add_interface_port int_msi app_msi_num    app_msi_num    Output  5
      add_interface_port int_msi app_msi_tc     app_msi_tc     Output  3

      #MSIX Request (new for phase2)
      add_interface_port int_msi app_msix_req    app_msix_req    Output  1
      add_interface_port int_msi app_msix_ack    app_msix_ack    Input 1
      add_interface_port int_msi app_msix_err    app_msix_err    Input 1
      add_interface_port int_msi app_msix_addr   app_msix_addr   Output  64 
      add_interface_port int_msi app_msix_data   app_msix_data   Output  32 

      add_interface_port int_msi app_msi_addr_pf                 app_msi_addr_pf               Input $TOTAL_PF_COUNT*64
      add_interface_port int_msi app_msi_data_pf                 app_msi_data_pf               Input $TOTAL_PF_COUNT*16
      add_interface_port int_msi app_msi_mask_pf                 app_msi_mask_pf               Input $TOTAL_PF_COUNT*32
      add_interface_port int_msi app_msi_pending_pf              app_msi_pending_pf            Input $TOTAL_PF_COUNT*32
      add_interface_port int_msi app_msi_enable_pf               app_msi_enable_pf             input $TOTAL_PF_COUNT
      add_interface_port int_msi app_msi_multi_msg_enable_pf     app_msi_multi_msg_enable_pf   input $TOTAL_PF_COUNT*3

      add_interface_port int_msi app_msix_en_pf                  app_msix_en_pf                Input $TOTAL_PF_COUNT
      add_interface_port int_msi app_msix_fn_mask_pf             app_msix_fn_mask_pf           Input $TOTAL_PF_COUNT
      add_interface_port int_msi app_msix_en_vf                  app_msix_en_vf                Input $TOTAL_VF_COUNT
      add_interface_port int_msi app_msix_fn_mask_vf             app_msix_fn_mask_vf           Input $TOTAL_VF_COUNT

      add_interface_port int_msi app_int_ack    app_int_ack        Input   1
      add_interface_port int_msi app_int_sts_a  app_int_sts_a      Output  1
      add_interface_port int_msi app_int_sts_b  app_int_sts_b      Output  1
      add_interface_port int_msi app_int_sts_c  app_int_sts_c      Output  1
      add_interface_port int_msi app_int_sts_d  app_int_sts_d      Output  1
      add_interface_port int_msi app_int_sts_fn app_int_sts_fn     Output  1

      add_interface_port int_msi app_int_pend_status app_int_pend_status Output 2
      add_interface_port int_msi app_intx_disable app_intx_disable       Input $TOTAL_PF_COUNT
      
      add_interface_port int_msi app_msi_pending_bit_write_en    app_msi_pending_bit_write_en    Output  1
      add_interface_port int_msi app_msi_pending_bit_write_data  app_msi_pending_bit_write_data  Output  1
   } 

}


####################################################################################################
#
# LMI interface conduit 
#
proc add_ed_sriov_port_lmi {} {
   set dev_family [get_parameter_value INTENDED_DEVICE_FAMILY ]
   set enable_lmi_hwtcl [ get_parameter_value enable_lmi_hwtcl]

   if { $enable_lmi_hwtcl== 1} {
      send_message debug "proc:add_ed_sriov_port_lmi"

      add_interface lmi conduit end

      add_interface_port lmi lmi_addr lmi_addr  Output  12
      add_interface_port lmi lmi_func lmi_func  Output  9
      add_interface_port lmi lmi_rden lmi_rden  Output  1
      add_interface_port lmi lmi_wren lmi_wren  Output  1
      add_interface_port lmi lmi_ack  lmi_ack   Input 1

      add_interface_port lmi lmi_din  lmi_din   Output  32
      add_interface_port lmi lmi_dout lmi_dout  Input   32
   }
}

#####################################################################################################
#
# HIP control
#
proc add_ed_sriov_port_hip_misc {} {

   set dev_family [get_parameter_value INTENDED_DEVICE_FAMILY ]

   if { $dev_family == "Stratix V" } {
      send_message debug "proc:add_ed_sriov_port_hip_misc"
      add_interface      hip_misc conduit end
      add_interface_port hip_misc hpg_ctrler     hpg_ctrler      Output  5
   }   
}


####################################################################################################
#
# Avalon-MM RX
#
proc add_pcie_hip_port_avmm_pf0_rxmaster {} {

   set  PF0_BAR_PRESENT(0) [ get_parameter_value PF0_BAR0_PRESENT]
   set  PF0_BAR_PRESENT(1) [ get_parameter_value PF0_BAR1_PRESENT]
   set  PF0_BAR_PRESENT(2) [ get_parameter_value PF0_BAR2_PRESENT]
   set  PF0_BAR_PRESENT(3) [ get_parameter_value PF0_BAR3_PRESENT]
   set  PF0_BAR_PRESENT(4) [ get_parameter_value PF0_BAR4_PRESENT]
   set  PF0_BAR_PRESENT(5) [ get_parameter_value PF0_BAR5_PRESENT]

   set  PF0_BAR_TYPE(0) [ get_parameter_value PF0_BAR0_TYPE]
   set  PF0_BAR_TYPE(1) [ get_parameter_value PF0_BAR1_TYPE]
   set  PF0_BAR_TYPE(2) [ get_parameter_value PF0_BAR2_TYPE]
   set  PF0_BAR_TYPE(3) [ get_parameter_value PF0_BAR3_TYPE]
   set  PF0_BAR_TYPE(4) [ get_parameter_value PF0_BAR4_TYPE]
   set  PF0_BAR_TYPE(5) [ get_parameter_value PF0_BAR5_TYPE]

   set rxm_data_width 32

   # Previous BAR was 64-bit Bar64_prev
   set Bar64_prev 0
   set BarUsed 0

   # Keep track of whether we added Interupt Receiver yet
   set rxm_irq_bar 99

   for { set i 0 } { $i < 6 } { incr i 1 } {
      if { ($PF0_BAR_PRESENT($i) ==1) && ($PF0_BAR_TYPE($i) == 64) } {
          set BarUsed      1
          set bar_type     64
          set Bar64_prev   1
      } elseif { ($PF0_BAR_PRESENT($i) == 1) && ( $Bar64_prev==0 ) } {
          set BarUsed      1
          set bar_type     32
          set Bar64_prev   0
      } else {
          set BarUsed      0
          set bar_type     1
          set Bar64_prev   0
      }  

      if { $BarUsed == 1 } {
         add_interface          "pf0_Rxm_BAR${i}" "avalon" "master" "pld_clk_hip"
         set_interface_property "pf0_Rxm_BAR${i}" "interleaveBursts" "false"
         set_interface_property "pf0_Rxm_BAR${i}" "doStreamReads" "false"
         set_interface_property "pf0_Rxm_BAR${i}" "doStreamWrites" "false"
         set_interface_property "pf0_Rxm_BAR${i}" "maxAddressWidth"  $bar_type
         set_interface_property "pf0_Rxm_BAR${i}" "addressGroup" ${i}

         # Ports in interface $master_name
        # send_message info " BAR $i size mask is $PF0_BAR_PRESENT($i)"  
        # add_interface_port     "pf0_Rxm_BAR${i}"  "RxmAddress_${i}_o" "address" "output" $PF0_BAR_PRESENT($i)   
         add_interface_port     "pf0_Rxm_BAR${i}"  "RxmAddress_${i}_o" "address" "output"  $bar_type
         add_interface_port     "pf0_Rxm_BAR${i}"  "RxmRead_${i}_o" "read" "output" 1
         add_interface_port     "pf0_Rxm_BAR${i}"  "RxmWaitRequest_${i}_i" "waitrequest" "input" 1
         add_interface_port     "pf0_Rxm_BAR${i}"  "RxmWrite_${i}_o" "write" "output" 1
         add_interface_port     "pf0_Rxm_BAR${i}"  "RxmReadDataValid_${i}_i" "readdatavalid" "input" 1
         add_interface_port     "pf0_Rxm_BAR${i}"  "RxmReadData_${i}_i" "readdata" "input" $rxm_data_width
         add_interface_port     "pf0_Rxm_BAR${i}"  "RxmWriteData_${i}_o" "writedata" "output" $rxm_data_width
         add_interface_port     "pf0_Rxm_BAR${i}"  "RxmByteEnable_${i}_o" "byteenable" "output" [ expr $rxm_data_width/8 ]

      }
   }
}

####################################################################################################
#
# Avalon-MM RX
#
proc add_pcie_hip_port_avmm_pf0_vf_rxmaster {} {

   set  VF_BAR_PRESENT(0) [ get_parameter_value PF0_VF_BAR0_PRESENT]
   set  VF_BAR_PRESENT(1) [ get_parameter_value PF0_VF_BAR1_PRESENT]
   set  VF_BAR_PRESENT(2) [ get_parameter_value PF0_VF_BAR2_PRESENT]
   set  VF_BAR_PRESENT(3) [ get_parameter_value PF0_VF_BAR3_PRESENT]
   set  VF_BAR_PRESENT(4) [ get_parameter_value PF0_VF_BAR4_PRESENT]
   set  VF_BAR_PRESENT(5) [ get_parameter_value PF0_VF_BAR5_PRESENT]

   set  VF_BAR_TYPE(0) [ get_parameter_value PF0_VF_BAR0_TYPE]
   set  VF_BAR_TYPE(1) [ get_parameter_value PF0_VF_BAR1_TYPE]
   set  VF_BAR_TYPE(2) [ get_parameter_value PF0_VF_BAR2_TYPE]
   set  VF_BAR_TYPE(3) [ get_parameter_value PF0_VF_BAR3_TYPE]
   set  VF_BAR_TYPE(4) [ get_parameter_value PF0_VF_BAR4_TYPE]
   set  VF_BAR_TYPE(5) [ get_parameter_value PF0_VF_BAR5_TYPE]

   set rxm_data_width 32

   # AddressGroup must be unique per RXM ports
   # Since PF0_RXM uses [5:0], PF0_VF_RXM uses[11:6] 
   set pf0_vf_rxm_start_offset 6

   # Previous BAR was 64-bit Bar64_prev
   set Bar64_prev 0
   set BarUsed 0

   # Keep track of whether we added Interupt Receiver yet
   set rxm_irq_bar 99

   for { set i 0 } { $i < 6 } { incr i 1 } {
      if { ($VF_BAR_PRESENT($i) ==1) && ($VF_BAR_TYPE($i) == 64) } {
          set BarUsed      1
          set bar_type     64
          set Bar64_prev   1
      } elseif { ($VF_BAR_PRESENT($i) == 1) && ( $Bar64_prev==0 ) } {
          set BarUsed      1
          set bar_type     32
          set Bar64_prev   0
      } else {
          set BarUsed      0
          set bar_type     1
          set Bar64_prev   0
      }  

      set pf0_vf_rxm_addressGroup_offset  [ expr {$i + $pf0_vf_rxm_start_offset} ]

      if { $BarUsed == 1 } {
         add_interface          "pf0_vf_Rxm_BAR${i}" "avalon" "master" "pld_clk_hip"
         set_interface_property "pf0_vf_Rxm_BAR${i}" "interleaveBursts" "false"
         set_interface_property "pf0_vf_Rxm_BAR${i}" "doStreamReads" "false"
         set_interface_property "pf0_vf_Rxm_BAR${i}" "doStreamWrites" "false"
         set_interface_property "pf0_vf_Rxm_BAR${i}" "maxAddressWidth"  $bar_type
         set_interface_property "pf0_vf_Rxm_BAR${i}" "addressGroup" $pf0_vf_rxm_addressGroup_offset 

         # Ports in interface $master_name
        # add_interface_port     "pf0_vf_Rxm_BAR${i}"  "pf0_vf_RxmAddress_${i}_o" "address" "output" $VF_BAR_PRESENT($i)   
         add_interface_port     "pf0_vf_Rxm_BAR${i}"  "pf0_vf_RxmAddress_${i}_o" "address" "output"  $bar_type
         add_interface_port     "pf0_vf_Rxm_BAR${i}"  "pf0_vf_RxmRead_${i}_o" "read" "output" 1
         add_interface_port     "pf0_vf_Rxm_BAR${i}"  "pf0_vf_RxmWaitRequest_${i}_i" "waitrequest" "input" 1
         add_interface_port     "pf0_vf_Rxm_BAR${i}"  "pf0_vf_RxmWrite_${i}_o" "write" "output" 1
         add_interface_port     "pf0_vf_Rxm_BAR${i}"  "pf0_vf_RxmReadDataValid_${i}_i" "readdatavalid" "input" 1
         add_interface_port     "pf0_vf_Rxm_BAR${i}"  "pf0_vf_RxmReadData_${i}_i" "readdata" "input" $rxm_data_width
         add_interface_port     "pf0_vf_Rxm_BAR${i}"  "pf0_vf_RxmWriteData_${i}_o" "writedata" "output" $rxm_data_width
         add_interface_port     "pf0_vf_Rxm_BAR${i}"  "pf0_vf_RxmByteEnable_${i}_o" "byteenable" "output" [ expr $rxm_data_width/8 ]

      }
   }
}

#############################################
# TXS Slave
proc add_pcie_hip_port_avmm_txslave {} {

   set COMPLETER_ONLY_HWTCL [ get_parameter_value COMPLETER_ONLY_HWTCL]
   # +-----------------------------------
   # | connection point Txs Slave
   # |
   # Interface Txs Slave
   
   set TX_S_ADDR_WIDTH     [ get_parameter_value TX_S_ADDR_WIDTH ]

   add_interface          Txs "avalon" "slave" "pld_clk_hip"
   set_interface_property Txs "addressAlignment" "DYNAMIC"
   set_interface_property Txs "interleaveBursts" "false"
   set_interface_property Txs "readLatency" "0"
   set_interface_property Txs "writeWaitTime" "1"
   set_interface_property Txs "readWaitTime" "1"
   set_interface_property Txs "addressUnits" "SYMBOLS"
   set_interface_property Txs "maximumPendingReadTransactions" 8

   add_interface_port     Txs "TxsAddress_i" "address" "input" $TX_S_ADDR_WIDTH+8
   add_interface_port     Txs "TxsChipSelect_i" "chipselect" "input" 1
   add_interface_port     Txs "TxsByteEnable_i" "byteenable" "input" 4
   add_interface_port     Txs "TxsReadData_o" "readdata" "output" 32
   add_interface_port     Txs "TxsWriteData_i" "writedata" "input" 32
   add_interface_port     Txs "TxsRead_i" "read" "input" 1
   add_interface_port     Txs "TxsWrite_i" "write" "input" 1
   add_interface_port     Txs "TxsReadDataValid_o" "readdatavalid" "output" 1
   add_interface_port     Txs "TxsWaitRequest_o" "waitrequest" "output" 1

   if { $COMPLETER_ONLY_HWTCL == 0 } {
      set_interface_property Txs ENABLED true
   } else {
      set_interface_property Txs ENABLED false
   }  
}



####################################################################################################
#
# Avalon-MM DMA Read Master
#

proc add_pcie_hip_port_avmm_rd_master {} {

         set  rd_size_mask_hwtcl [ get_parameter_value rd_dma_size_mask_hwtcl ]
         set rd_data_width 256
         set COMPLETER_ONLY_HWTCL [ get_parameter_value COMPLETER_ONLY_HWTCL]

         add_interface          "dmard_WrToFPGA" "avalon" "master" "pld_clk_hip"
         set_interface_property "dmard_WrToFPGA" "interleaveBursts" "false"
         set_interface_property "dmard_WrToFPGA" "doStreamReads" "false"
         set_interface_property "dmard_WrToFPGA" "doStreamWrites" "false"
         set_interface_property "dmard_WrToFPGA" "maxAddressWidth" 64
         set_interface_property "dmard_WrToFPGA" "addressGroup" 0

         # Ports in interface $master_name
         add_interface_port     "dmard_WrToFPGA" "RdDmaAddress_o" "address" "output" 64
         add_interface_port     "dmard_WrToFPGA" "RdDmaWrite_o" "write" "output" 1
         add_interface_port     "dmard_WrToFPGA" "RdDmaWriteData_o" "writedata" "output" $rd_data_width
         add_interface_port     "dmard_WrToFPGA" "RdDmaWaitRequest_i" "waitrequest" "input" 1
         add_interface_port     "dmard_WrToFPGA" "RdDmaBurstCount_o" "burstcount" "output" 5
         add_interface_port     "dmard_WrToFPGA" "RdDmaWriteEnable_o" "byteenable" "output" [ expr $rd_data_width/8 ]

         if { $COMPLETER_ONLY_HWTCL == 0 } {
            set_interface_property dmard_WrToFPGA ENABLED true
         } else {
            set_interface_property dmard_WrToFPGA ENABLED false
         }
}


####################################################################################################
#
# Avalon-MM DMA Write Master
#

proc add_pcie_hip_port_avmm_wr_master {} {

         set wr_size_mask_hwtcl [ get_parameter_value wr_dma_size_mask_hwtcl ]
         set wr_data_width 256
         set COMPLETER_ONLY_HWTCL [ get_parameter_value COMPLETER_ONLY_HWTCL]

         add_interface          "dmawr_RdFromFPGA" "avalon" "master" "pld_clk_hip"
         set_interface_property "dmawr_RdFromFPGA" "interleaveBursts" "false"
         set_interface_property "dmawr_RdFromFPGA" "doStreamReads" "false"
         set_interface_property "dmawr_RdFromFPGA" "doStreamWrites" "false"
         set_interface_property "dmawr_RdFromFPGA" "maxAddressWidth" 64
         set_interface_property "dmawr_RdFromFPGA" "addressGroup" 0

         # Ports in interface $master_name
         add_interface_port     "dmawr_RdFromFPGA" "WrDmaAddress_o" "address" "output" 64 
         add_interface_port     "dmawr_RdFromFPGA" "WrDmaRead_o" "read" "output" 1
         add_interface_port     "dmawr_RdFromFPGA" "WrDmaWaitRequest_i" "waitrequest" "input" 1
         add_interface_port     "dmawr_RdFromFPGA" "WrDmaBurstCount_o" "burstcount" "output" 5   
         add_interface_port     "dmawr_RdFromFPGA" "WrDmaReadDataValid_i" "readdatavalid" "input" 1 
         add_interface_port     "dmawr_RdFromFPGA" "WrDmaReadData_i" "readdata" "input"  $wr_data_width

         if { $COMPLETER_ONLY_HWTCL == 0 } {
            set_interface_property dmawr_RdFromFPGA ENABLED true
         } else {
            set_interface_property dmawr_RdFromFPGA ENABLED false
         }
}

## Local AST Ports
proc add_pcie_hip_port_rd_ast {} {
  set COMPLETER_ONLY_HWTCL [ get_parameter_value COMPLETER_ONLY_HWTCL]

## AST_RX: DMA Read Descriptor
         add_interface dc2dmard_instruc avalon_streaming end
         set_interface_property dc2dmard_instruc associatedClock pld_clk_hip
         set_interface_property dc2dmard_instruc associatedReset app_rstn
         set_interface_property dc2dmard_instruc dataBitsPerSymbol 8
         set_interface_property dc2dmard_instruc errorDescriptor ""
         set_interface_property dc2dmard_instruc firstSymbolInHighOrderBits true
         set_interface_property dc2dmard_instruc maxChannel 0
         set_interface_property dc2dmard_instruc readyLatency 0
         if { $COMPLETER_ONLY_HWTCL == 0 } {
            set_interface_property dc2dmard_instruc ENABLED true
         } else {
            set_interface_property dc2dmard_instruc ENABLED false
         }  
         set_interface_property dc2dmard_instruc EXPORT_OF ""
         set_interface_property dc2dmard_instruc PORT_NAME_MAP ""
         set_interface_property dc2dmard_instruc SVD_ADDRESS_GROUP ""
         add_interface_port dc2dmard_instruc RdDmaRxValid_i valid Input 1
         add_interface_port dc2dmard_instruc RdDmaRxData_i data Input 168
         add_interface_port dc2dmard_instruc RdDmaRxReady_o ready Output 1
          
##AST_TX: DMA Read Status

         add_interface dmard2dc_status avalon_streaming start
         set_interface_property dmard2dc_status associatedClock pld_clk_hip
         set_interface_property dmard2dc_status associatedReset app_rstn
         set_interface_property dmard2dc_status dataBitsPerSymbol 32
         set_interface_property dmard2dc_status errorDescriptor ""
         set_interface_property dmard2dc_status firstSymbolInHighOrderBits true
         set_interface_property dmard2dc_status maxChannel 0
         set_interface_property dmard2dc_status readyLatency 0
         if { $COMPLETER_ONLY_HWTCL == 0 } {
            set_interface_property dmard2dc_status ENABLED true
         } else {
            set_interface_property dmard2dc_status ENABLED false
         }  
         set_interface_property dmard2dc_status EXPORT_OF ""
         set_interface_property dmard2dc_status PORT_NAME_MAP ""
         set_interface_property dmard2dc_status SVD_ADDRESS_GROUP ""
          
         add_interface_port dmard2dc_status RdDmaTxData_o data Output 32
         add_interface_port dmard2dc_status RdDmaTxValid_o valid Output 1
}


proc add_pcie_hip_port_wr_ast {} {
  set COMPLETER_ONLY_HWTCL [ get_parameter_value COMPLETER_ONLY_HWTCL]

         ## AST_RX; DMA Write Descriptor
         add_interface dc2dmawr_instruc avalon_streaming end
         set_interface_property dc2dmawr_instruc associatedClock pld_clk_hip
         set_interface_property dc2dmawr_instruc associatedReset app_rstn
         set_interface_property dc2dmawr_instruc dataBitsPerSymbol 8
         set_interface_property dc2dmawr_instruc errorDescriptor ""
         set_interface_property dc2dmawr_instruc firstSymbolInHighOrderBits true
         set_interface_property dc2dmawr_instruc maxChannel 0
         set_interface_property dc2dmawr_instruc readyLatency 0
         if { $COMPLETER_ONLY_HWTCL == 0 } {
            set_interface_property dc2dmawr_instruc ENABLED true
         } else {
            set_interface_property dc2dmawr_instruc ENABLED false
         }  
         set_interface_property dc2dmawr_instruc EXPORT_OF ""
         set_interface_property dc2dmawr_instruc PORT_NAME_MAP ""
         set_interface_property dc2dmawr_instruc SVD_ADDRESS_GROUP ""
         add_interface_port dc2dmawr_instruc WrDmaRxValid_i valid Input 1
         add_interface_port dc2dmawr_instruc WrDmaRxData_i data Input 168
         add_interface_port dc2dmawr_instruc WrDmaRxReady_o ready Output 1

##AST_TX: DMA-Write Status

         add_interface dmawr2dc_status avalon_streaming start
         set_interface_property dmawr2dc_status associatedClock pld_clk_hip
         set_interface_property dmawr2dc_status associatedReset app_rstn
         set_interface_property dmawr2dc_status dataBitsPerSymbol 32
         set_interface_property dmawr2dc_status errorDescriptor ""
         set_interface_property dmawr2dc_status firstSymbolInHighOrderBits true
         set_interface_property dmawr2dc_status maxChannel 0
         set_interface_property dmawr2dc_status readyLatency 0
         if { $COMPLETER_ONLY_HWTCL == 0 } {
            set_interface_property dmawr2dc_status ENABLED true
         } else {
            set_interface_property dmawr2dc_status ENABLED false
         }  
         set_interface_property dmawr2dc_status EXPORT_OF ""
         set_interface_property dmawr2dc_status PORT_NAME_MAP ""
         set_interface_property dmawr2dc_status SVD_ADDRESS_GROUP ""
          
         add_interface_port dmawr2dc_status WrDmaTxData_o data Output 32
         add_interface_port dmawr2dc_status WrDmaTxValid_o valid Output 1    
          

}


proc add_pcie_hip_port_avmm_cra {} {
   set enable_cra_hwtcl [ get_parameter_value enable_cra_hwtcl ]

 if { $enable_cra_hwtcl == 1 } {
   add_interface          Cra "avalon" "slave" "pld_clk_hip"
   set_interface_property Cra "readLatency" "0"
   set_interface_property Cra "addressAlignment" "DYNAMIC"
   set_interface_property Cra "addressUnits" "SYMBOLS"
   set_interface_property Cra "writeWaitTime" "1"
   set_interface_property Cra "readWaitTime" "1"
   # Ports in interface Cra
   add_interface_port     Cra "CraChipSelect_i" "chipselect" "input" 1
   add_interface_port     Cra "CraAddress_i" "address" "input" 10
   add_interface_port     Cra "CraByteEnable_i" "byteenable" "input" 4
   add_interface_port     Cra "CraRead_i" "read" "input" 1
   add_interface_port     Cra "CraReadData_o" "readdata" "output" 32
   add_interface_port     Cra "CraWrite_i" "write" "input" 1
   add_interface_port     Cra "CraWriteData_i" "writedata" "input" 32
   add_interface_port     Cra "CraWaitRequest_o" "waitrequest" "output" 1
 } 
}


####################################################################################################
#
# add_to_no_connect signal_name:string signal_width:int direction:string
#  tied internal signal to
#     - open (when output of the instance)
#     - GND (input of the instance)
#
proc add_to_no_connect { signal_name signal_width direction } {
#send_message debug "proc add_to_no_connect $signal_name $signal_width $direction"
   if { [ regexp In $direction ] } {
      add_interface_port no_connect $signal_name $signal_name Input $signal_width
      set_port_property $signal_name TERMINATION true
      set_port_property $signal_name TERMINATION_VALUE 0
   } else {
      add_interface_port no_connect $signal_name $signal_name Output $signal_width
      set_port_property  $signal_name TERMINATION true
   }
}
