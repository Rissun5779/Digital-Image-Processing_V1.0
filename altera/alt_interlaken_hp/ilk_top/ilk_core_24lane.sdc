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



derive_pll_clocks -create_base_clock
derive_clock_uncertainty
create_clock -name rx_usr_clk -period 3.3 [get_ports {rx_usr_clk}]
create_clock -name tx_usr_clk -period 3.3 [get_ports {tx_usr_clk}]
create_clock -name mm_clk -period 10.0 [get_ports mm_clk]


###############################################################
# The following is extracted from embedded SDC command
# temp sensor and frequency monitor could be turned off.
# constraints will be ignored if turned off
# No warning will be issued.
##############################################################
set regs [get_registers -nowarn *temp_sense*tsd_cntr[11]]
if {[llength [query_collection -report -all $regs]] > 0} {create_clock -name {temp_sense_clock} -period 40000 $regs}
if {[llength [query_collection -report -all $regs]] > 0} {set_false_path -from [get_clocks {temp_sense_clock}] -to [get_clocks {mm_clk}]}

set regs [get_registers -nowarn {*temp_sense*raw_c_meta[*]}]
if {[llength [query_collection -report -all $regs]] > 0} {set_false_path -to $regs} 

set regs [get_registers -nowarn *frequency_monitor*scaled_toggle]
if {[llength [query_collection -report -all $regs]] > 0} {set_false_path -from $regs}

set regs [get_registers -nowarn *cross_bus*din_gray_meta\[*\]]
if {[llength [query_collection -report -all $regs]] > 0} {set_false_path -hold -to $regs}
if {[llength [query_collection -report -all $regs]] > 0} {set_multicycle_path -to $regs 2}

set_false_path -to [get_registers {*ilk_status_sync*sync_0[*]}]
set_false_path -to [get_registers *pcs_assembly*sclr_rxerr_s]
set_false_path -to [get_registers *pcs_assembly*sclr_txerr_s]
set regs [get_registers -nowarn *pcs_assembly*pcs_testbus\[*\]]
if {[llength [query_collection -report -all $regs]] > 0} {set_false_path -to $regs}
set_false_path -from [get_fanins -async *pcs_assembly*srst_rx_shift_n\[*\]] -to [get_registers *pcs_assembly*srst_rx_shift_n\[*\]]
set_false_path -from [get_fanins -async *pcs_assembly*srst_tx_shift_n\[*\]] -to [get_registers *pcs_assembly*srst_tx_shift_n\[*\]]
set_false_path -from [get_fanins -async *reset_delay*rs\[*\]] -to [get_registers *reset_delay*rs\[*\]]
set_false_path -from [get_fanins -async *ilk_rst_ctrl*rx_arst_filter\[*\]] -to [get_registers *ilk_rst_ctrl*rx_arst_filter\[*\]]
set_false_path -from [get_fanins -async *ilk_rst_ctrl*rx_drst_sync_n\[*\]] -to [get_registers *ilk_rst_ctrl*rx_drst_sync_n\[*\]]
set_false_path -from [get_fanins -async *ilk_rst_ctrl*tx_arst_filter\[*\]] -to [get_registers *ilk_rst_ctrl*tx_arst_filter\[*\]]
set_false_path -from [get_fanins -async *ilk_rst_ctrl*tx_drst_sync_n\[*\]] -to [get_registers *ilk_rst_ctrl*tx_drst_sync_n\[*\]]
### for 24lane ###
set from_regs [get_registers -nowarn *ilk_core*ilk_iw8_tx_datapath*ilk_iw8_tx_buffer_fifo_ram_loose*local_aclr] 
set to_regs [get_registers -nowarn *ilk_core*ilk_iw8_tx_datapath*ilk_iw8_tx_buffer_fifo_ram_loose*dcfifo*dataout_reg[*]]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}
set to_regs [get_registers -nowarn *ilk_core*ilk_iw8_tx_datapath*ilk_iw8_tx_buffer_fifo_ram_loose*dcfifo*dffe11a[*]]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}
set to_regs [get_registers -nowarn *ilk_core*ilk_iw8_tx_datapath*ilk_iw8_tx_buffer_fifo_ram_loose*dcfifo*dffe12a[*]]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set regs [get_registers -nowarn *ilk_rst_sync*shift_n\[*\]]
if {[llength [query_collection -report -all $regs]] > 0} {set_false_path -from [get_fanins -async $regs] -to $regs}

set regs [get_registers -nowarn *ilk_smoothed_domain_change*arst_n\[*\]]
if {[llength [query_collection -report -all $regs]] > 0} {set_false_path -from [get_fanins -async $regs] -to $regs}

set regs [get_registers -nowarn *ilk_smoothed_domain_change*arst_rdclk_n\[*\]] 
if {[llength [query_collection -report -all $regs]] > 0} {set_false_path -from [get_fanins -async $regs] -to $regs}

set regs [get_registers -nowarn *fifo_ram_loose*uf_sync*[0]]
if {[llength [query_collection -report -all $regs]] > 0} {set_false_path -to $regs}

set regs [get_registers -nowarn *buffer_fifo_ram_loose*dcfifo_aclr_shift_n\[*\]]
if {[llength [query_collection -report -all $regs]] > 0} {set_false_path -from [get_fanins -async $regs] -to $regs}



set_false_path -from [get_fanins -async *cross*event_toggle_sync0\[*\]] -to [get_registers *cross*event_toggle_sync0\[*\]]
set_false_path -from [get_fanins -async *cross*event_toggle_sync1\[*\]] -to [get_registers *cross*event_toggle_sync1\[*\]]
set_false_path -from {*cross*event_toggle_sync1[2]} -to {*cross*event_toggle_sync0[0]}


##############################################################################################################
# The following is extracted from embedded SDC command from ilk_top
##############################################################################################################
set regs [get_registers -nowarn *tx_usr_rst_sync_n\[*\]]
if {[llength [query_collection -report -all $regs]] > 0} {set_false_path -from [get_fanins -async $regs] -to  $regs}
set regs [get_registers -nowarn *rx_usr_rst_sync_n\[*\]]
if {[llength [query_collection -report -all $regs]] > 0} {set_false_path -from [get_fanins -async $regs] -to  $regs}

###############################################################################################################
# DCFIFO clr is cut to read side If tx_buffer_fifo_ram s included. Otherwise, this constraint will be ignored.
###############################################################################################################
set from_regs [get_registers -nowarn *tx_buffer_fifo_ram_loose*aclr] 
set to_regs [get_registers -nowarn *dcfifo*rdptr_*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *dcfifo*rs_dgwp*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *dcfifo*rdemp_eq_comp*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *dcfifo*portb_address_*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *dcfifo*PORT_B_ADDRESS_*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *dcfifo*fifo_ram*q_b[*]]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

###############################################################################################################
# DCFIFO clr is cut to read side if ilk_smooth_domain_change is presented. Otherwise, this constraint will be ignored
###############################################################################################################
set from_regs [get_registers -nowarn *smoothed_domain*arst_n[2]]
set to_regs [get_registers -nowarn *dcfifo*rdptr_*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *dcfifo*rs_dgwp*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *dcfifo*rdemp_eq_comp*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *dcfifo*portb_address_*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *dcfifo*PORT_B_ADDRESS_*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *dcfifo*fifo_ram*q_b[*]]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}


###############################################################################################################
# DCFIFO clr is cut to read side
###############################################################################################################
##set_false_path -from *rst_ctrl|tx_arst_filter[2] -to *trs*rdptr*
##set_false_path -from *rst_ctrl|tx_arst_filter[2] -to *trs*rs_dgwp*
##set_false_path -from *rst_ctrl|tx_arst_filter[2] -to *trs*rdemp_eq_comp*
##set_false_path -from *rst_ctrl|tx_arst_filter[2] -to *trs*portb_address_*
##set_false_path -from *rst_ctrl|tx_arst_filter[2] -to *trs*PORT_B_ADDRESS_*
##set_false_path -from *rst_ctrl|tx_arst_filter[2] -to *trs*fifo_ram*q_b[*]


###############################################################################################################
# DCFIFO clr is cut to read side
###############################################################################################################
set from_regs [get_registers -nowarn *ilk_rst_ctrl*cntr[*]]
set to_regs [get_registers -nowarn *rg0|*ilk_regroup_8*rdptr_*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set from_regs [get_registers -nowarn *ilk_rst_ctrl*cntr[*]]
set to_regs [get_registers -nowarn *rg0|*ilk_regroup_8*rs_dgwp*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}
set from_regs [get_registers -nowarn *ilk_rst_ctrl*cntr[*]]
set to_regs [get_registers -nowarn *rg0|*ilk_regroup_8*rdemp_eq_comp*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}
set from_regs [get_registers -nowarn *ilk_rst_ctrl*cntr[*]]
set to_regs [get_registers -nowarn *rg0|*ilk_regroup_8*portb_address_*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}
set from_regs [get_registers -nowarn *ilk_rst_ctrl*cntr[*]]
set to_regs [get_registers -nowarn *rg0|*ilk_regroup_8*PORT_B_ADDRESS_*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}
set from_regs [get_registers -nowarn *ilk_rst_ctrl*cntr[*]]
set to_regs [get_registers -nowarn *rg0|*ilk_regroup_8*fifo_ram*q_b[*]]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

###############################################################################################################
# DCFIFO clr is cut to read side If OOB logic is included. Otherwise, this constraint will be ignored.
###############################################################################################################
set from_regs [get_registers -nowarn *alt_interlaken_hp_oob_flow_rx*srst_fc_shift_n[2]]
set to_regs [get_registers -nowarn dcfifo*rdptr_*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *dcfifo*rs_dgwp*] 
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *dcfifo*rdemp_eq_comp*] 
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *dcfifo*portb_address_*] 
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *dcfifo*PORT_B_ADDRESS_*] 
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *dcfifo*fifo_ram*q_b[*]]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}


#  this should be routed as tight as possible, but no hard requirement
if {$::TimeQuestInfo(nameofexecutable) eq "quartus_sta"} {
  set_false_path -from *pcs_assembly*rx_fifo_clr -to *ilk_pcs_assembly*pcs*SYNC_DATA_REG0
}
# Set Cross-Clock False Paths
# Set False Path

# read_sdc "cut_path.sdc"


set_false_path -from [get_clocks {*inst_sv_pcs*inst_sv_pcs_ch*hssi_10g_tx_pcs*txclkout}] -to [get_clocks {tx_usr_clk}]

set_false_path -from [get_clocks {*inst_sv_pcs*inst_sv_pcs_ch*hssi_10g_tx_pcs*txclkout}] -to [get_clocks {mm_clk}]

set_false_path -from  [get_clocks {mm_clk}] -to [get_clocks {*inst_sv_pcs*hssi_10g_rx_pcs*rxclkout}]

set_false_path -from [get_clocks {mm_clk}] -to [get_clocks {*inst_sv_pcs_ch*hssi_10g_tx_pcs*txclkout}]

set_false_path -from [get_clocks {rx_usr_clk}] -to [get_clocks {*inst_sv_pcs*inst_sv_pcs_ch*hssi_10g_rx_pcs*rxclkout}]
set_false_path -from [get_clocks {*inst_sv_pcs*inst_sv_pcs_ch*hssi_10g_rx_pcs*rxclkout}] -to [get_clocks {rx_usr_clk}]


##### rx_any_pfull #####
 set_false_path -to *ilk_pcs_assembly*rx_any_pfull*
##### tx_from_fifo ##### 
if {$::TimeQuestInfo(nameofexecutable) eq "quartus_fit"} {
} else {
set_false_path -from {*ilk_pcs_assembly*tx_from_fifo} -to {*ilk_pcs_assembly*sv_ilk_sixpack*gxlp[*]*sv_xcvr_native*sdlp[*]*sv_pcs_ch*hssi_10g_tx_pcs_rbc*wys~SYNC_DATA_REG*}
}
#####   db_iport_pcs10gtxframe	#####
if {$::TimeQuestInfo(nameofexecutable) eq "quartus_fit"} {
} else {
set_false_path -from {*ilk_pcs_assembly*sv_ilk_sixpack*sv_xcvr_native*sv_pcs*sv_pcs_ch*hssi_10g_tx_pcs_rbc*hssi_10g_tx_pcs*SYNC_DATA_REG*} -to {*ilk_pcs_assembly*any_tx_frame}
}
##### db_iport_pcs10grxcrc32err	#####
if {$::TimeQuestInfo(nameofexecutable) eq "quartus_fit"} {
} else {
set from_regs [get_registers -nowarn *ilk_pcs_assembly*sv_ilk_sixpack*sv_xcvr_native*sv_pcs*sv_pcs_ch*hssi_10g_rx_pcs_rbc*hssi_10g_rx_pcs*SYNC_DATA_REG*]
set to_regs [get_registers -nowarn *ilk_pcs_assembly*hah*ecnt[*]*local_cnt[*]]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *ilk_core*ilk_pulse_stretch_sync:ss_crc32_err|din_toggle[*]]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *ilk_core*ilk_pulse_stretch_sync:ss_crc32_err|din_r[*]]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}
}
##### db_iport_pcs10grxframelock #####
if {$::TimeQuestInfo(nameofexecutable) eq "quartus_fit"} {
} else {
set_false_path -from {*ilk_pcs_assembly*sv_ilk_sixpack*sv_xcvr_native*sv_pcs*sv_pcs_ch*hssi_10g_rx_pcs_rbc*hssi_10g_rx_pcs*SYNC_DATA_REG*} -to {*ilk_pcs_assembly*hah*any_loss_of_meta}
}
##### db_iport_pcs10grxsherr  #####
if {$::TimeQuestInfo(nameofexecutable) eq "quartus_fit"} {
} else {
set_false_path -from {*ilk_pcs_assembly*sv_ilk_sixpack*sv_xcvr_native*sv_pcs*sv_pcs_ch*hssi_10g_rx_pcs_rbc*hssi_10g_rx_pcs*SYNC_DATA_REG*} -to {*ilk_pcs_assembly*hah*sticky_sherr[*]}
}
###
