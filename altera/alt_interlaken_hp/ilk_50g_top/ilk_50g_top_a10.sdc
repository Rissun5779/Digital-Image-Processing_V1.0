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

set_false_path -hold -from *np* -to *pcs_assembly*mm_rdata[*]
set_max_delay 6.6 -from *np* -to *pcs_assembly*mm_rdata[*]
set_false_path -from {*ilk_hard_pcs_assembly_a10_50g*pld_10g_tx_pfull_fifo.reg*} -to {*ilk_hard_pcs_assembly_a10_50g*ilk_hard_pcs_csr_a10*mm_rdata[*]}
set_false_path -from {*ilk_hard_pcs_assembly_a10_50g*pld_10g_tx_full_fifo.reg*} -to  {*ilk_hard_pcs_assembly_a10_50g*ilk_hard_pcs_csr_a10*mm_rdata[*]}

# DCFIFO clr is cut to read side

set from_regs [get_registers -nowarn *tx_buffer_fifo_ram_loose*arst*]
set to_regs [get_registers -nowarn *rdptr_*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}


set from_regs [get_registers -nowarn *tx_buffer_fifo_ram*local_aclr]
set to_regs [get_registers -nowarn *rs_dgwp*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}


set to_regs [get_registers -nowarn *rdemp_eq_comp*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *portb_address_*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *PORT_B_ADDRESS_*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *dcfifo*alt_synch_pipe*dffe16a[*]]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}
set to_regs [get_registers -nowarn *ram_block*register_clock*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}
set to_regs [get_registers -nowarn *altsyncram*ram_block11a*~reg*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set from_regs [get_registers -nowarn *ilk_hard_pcs_assembly_a10_50g*reset_control*reset_counter*r_reset*]
set to_regs [get_registers -nowarn *ilk_hard_pcs_assembly_a10_50g*pempty_gen_a10*|pempty_np[*]]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}


# DCFIFO clr is cut to read side
# set_false_path -from *smoothed_domain*arst_n[2] -to *rdptr_*
# set_false_path -from *smoothed_domain*arst_n[2] -to *rs_dgwp*
# set_false_path -from *smoothed_domain*arst_n[2] -to *rdemp_eq_comp*
# set_false_path -from *smoothed_domain*arst_n[2] -to *portb_address_*
# set_false_path -from *smoothed_domain*arst_n[2] -to *PORT_B_ADDRESS_*
# set_false_path -from *smoothed_domain*arst_n[2] -to *fifo_ram*q_b[*]
# set_false_path -from *smoothed_domain*arst_n[2] -to *rs_brp*
# set_false_path -from *smoothed_domain*arst_n[2] -to *rs_bwp*


# DCFIFO clr is cut to read side
set from_regs [get_registers -nowarn *rst_ctrl|tx_arst_filter[2]] 
set to_regs [get_registers -nowarn *dcfifo*rdemp_eq_comp*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

 
set to_regs [get_registers -nowarn *trs*rdptr_*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}

set to_regs [get_registers -nowarn *trs*rs_dgwp*]
if {[llength [query_collection -report -all $from_regs]] > 0 && [llength [query_collection -report -all $to_regs]] > 0} {set_false_path -from $from_regs -to $to_regs}


#set_false_path -from *rst_ctrl|tx_arst_filter[2] -to *trs*portb_address_*
#set_false_path -from *rst_ctrl|tx_arst_filter[2] -to *trs*PORT_B_ADDRESS_*
#set_false_path -from *rst_ctrl|tx_arst_filter[2] -to *trs*fifo_ram*q_b[*]


# DCFIFO clr is cut to read side
# set_false_path -from *ilk_rst_ctrl*cntr[19] -to *rg0|rx_regroup*rdptr_*
# set_false_path -from *ilk_rst_ctrl*cntr[19] -to *rg0|rx_regroup*rs_dgwp*
# set_false_path -from *ilk_rst_ctrl*cntr[19] -to *rg0|rx_regroup*rdemp_eq_comp*
# set_false_path -from *ilk_rst_ctrl*cntr[19] -to *rg0|rx_regroup*portb_address_*
# set_false_path -from *ilk_rst_ctrl*cntr[19] -to *rg0|rx_regroup*PORT_B_ADDRESS_*
# set_false_path -from *ilk_rst_ctrl*cntr[19] -to *rg0|rx_regroup*fifo_ram*q_b[*]


#  this should be routed as tight as possible, but no hard requirement
if {$::TimeQuestInfo(nameofexecutable) eq "quartus_sta"} {
  set_false_path -from *rx_fifo_clr -to *pcs*
}
# Set Cross-Clock False Paths
# Set False Path

#read_sdc "cut_path.sdc"

# Set Cross-Clock False Paths
# Set Cross-Clock False Paths

#tx_clkout -> tx_usr_clk
# set_false_path -from [get_clocks {*pcs_assembly_a10_gen*np_inst*g_xcvr_native_insts[*]*twentynm_xcvr_native_inst*inst_twentynm_hssi_pma_tx_ser*wys*clk_divtx}] -to [get_clocks {tx_usr_clk}]

#set_false_path -from [get_clocks {*np*g_xcvr_native_insts[*]*twentynm_xcvr_native_inst*inst_twentynm_pma*inst_twentynm_pma_ch*inst_twentynm_hssi_pma_tx_ser*wys*clk_divtx}] -to [get_clocks {tx_usr_clk}]

#set_false_path -from [get_clocks {*np*g_xcvr_native_insts[*]*twentynm_xcvr_native_inst*inst_twentynm_pma*inst_twentynm_pma_ch*inst_twentynm_hssi_pma_tx_ser*wys*clk_divtx}] -to [get_clocks {mm_clk}]

#rx_clkout

#set_false_path -from  [get_clocks {mm_clk}] -to [get_clocks { *pcs_assembly_a10_gen*hah*np*g_xcvr_native_insts[*]*twentynm_xcvr_native_inst*inst_twentynm_pcs*ch[*].inst_twentynm_pcs_ch*inst_twentynm_hssi_rx_pcs_pma_interface*wys~HSSI_CLOCK_pma_rx_pma_clk}]

#rx_usr_clk -> rx_coreclkin 
#set_false_path -from [get_clocks {rx_usr_clk}] -to [get_clocks {*pcs_assembly_a10_gen*hah*np*g_xcvr_native_insts[*]*twentynm_xcvr_native_inst*inst_twentynm_pma*ch[*]*inst_twentynm_hssi_pma_rx_deser*rx_pma_clk}]

set_false_path -from [get_clocks {rx_usr_clk}] -to [get_clocks {*g_xcvr_native_insts*rx_pma_clk}]

#rx_clkout -> rx_usr_clk
set_false_path -from [get_clocks {*g_xcvr_native_insts*rx_pma_clk}] -to [get_clocks {rx_usr_clk}]

#set_false_path -from {*ilk_iw8_retrans_ptr_fifo:rtptr_fifo|stable_wrptr[*]} -to {*ilk_iw8_retrans_ptr_fifo:rtptr_fifo|stable_wrptr_rdclk[*]}
#set_false_path -from {*ilk_iw8_retrans_ptr_fifo:txctl_fifo|stable_wrptr[*]} -to {*ilk_iw8_retrans_ptr_fifo:txctl_fifo|stable_wrptr_rdclk[*]}

##### tx_empty_r #####
#set_false_path -to *ilk_hard_pcs_assembly_a10*tx_empty_r*

##### tx_pempty_r #####
#set_false_path -to *ilk_hard_pcs_assembly_a10*tx_pempty_r*

##### rx_full_full ########added by hui 10ps setup violation
set_false_path -to *ilk_hard_pcs_assembly_a10*ilk_tx_align_inst*tx_full_r[*]
##### tx_from_fifo ##### 

##### rx_full_full ########added by hui hold time violation
set_false_path -to *ilk_hard_pcs_assembly_a10*ilk_rx_aligner_inst*rx_none_pempty
set_false_path -to *ilk_hard_pcs_assembly_a10*ilk_rx_aligner_inst*rx_control_i[*]
set_false_path -to *ilk_hard_pcs_assembly_a10*ilk_rx_aligner_inst*rx_dout_i[*]
set_false_path -to *ilk_hard_pcs_assembly_a10*ilk_rx_aligner_inst*rx_valid_i[*]
set_false_path -to *ilk_hard_pcs_assembly_a10*ilk_rx_aligner_inst*rx_pempty_r[*]
#set_false_path -to *ilk_hard_pcs_assembly_a10*np_inst*g_xcvr_native_insts[*].twentynm_xcvr_native_inst*inst_twentynm_pcs*ch[*]*inst_twentynm_pcs_ch*wys~HSSI_CLOCK_ch*_pld_tx_clk
##### tx_from_fifo ##### 

##### rx_any_pfull #####
# set_false_path -to *ilk_hard_pcs_assembly_a10*rx_any_pfull*
##### tx_from_fifo ##### 

##### db_iport_pcs10grxcrc32err	#####
#if {$::TimeQuestInfo(nameofexecutable) eq "quartus_fit"} {
#} else {
#set_false_path -from [get_pins -compatibility_mode {*pcs_assembly_a10_gen*np*xcvr_native_insts*twentynm_xcvr_native_inst*inst_twentynm_pcs*ch[*]*gen_twentynm_hssi_rx_pld_pcs_interface*pld_10g_rx_crc32_err*}] -to {*ilk_hard_pcs_assembly_a10*hah*ecnt[*]*local_cnt[*]}
#set_false_path -from [get_pins -compatibility_mode {*pcs_assembly_a10_gen*np*xcvr_native_insts*twentynm_xcvr_native_inst*inst_twentynm_pcs*ch[*]*gen_twentynm_hssi_rx_pld_pcs_interface*pld_10g_rx_crc32_err*}] -to {*ilk_core*ilk_pulse_stretch_sync*ss_crc32_err*din_toggle[*]}
#set_false_path -from [get_pins -compatibility_mode {*pcs_assembly_a10_gen*np*xcvr_native_insts*twentynm_xcvr_native_inst*inst_twentynm_pcs*ch[*]*gen_twentynm_hssi_rx_pld_pcs_interface*pld_10g_rx_crc32_err*}] -to {*ilk_core*ilk_pulse_stretch_sync*ss_crc32_err*din_r[*]}
#}
#set_false_path -through [get_pins -compatibility_mode {*pld_10g_rx_crc32_err*} ] -to [get_registers {*din_toggle*}]
set_false_path -through [get_pins -compatibility_mode {*pld_10g_rx_crc32_err*} ] -to [get_registers {*din_r*}]

# set_false_path -from [get_clocks {*inst_sv_pcs*inst_sv_pcs_ch*hssi_10g_tx_pcs*txclkout}] -to [get_clocks {tx_usr_clk}]
set_false_path -from [get_clocks {*g_xcvr_native_insts*tx_pma_clk}] -to [get_clocks {tx_usr_clk}]
set_false_path -from [get_clocks {tx_usr_clk}] -to [get_clocks {*g_xcvr_native_insts*tx_pma_clk}]
# set_false_path -from [get_clocks {*inst_sv_pcs*inst_sv_pcs_ch*hssi_10g_tx_pcs*txclkout}] -to [get_clocks {mm_clk}]
set_false_path -from [get_clocks {*g_xcvr_native_insts*rx_pma_clk}] -to [get_clocks {mm_clk}]
set_false_path -from [get_clocks {*g_xcvr_native_insts*tx_pma_clk}] -to [get_clocks {mm_clk}]
set_false_path -from [get_clocks {mm_clk}] -to  [get_clocks {*g_xcvr_native_insts*tx_pma_clk}] 
set_false_path -from [get_clocks {*g_xcvr_native_insts*rx_pma_clk}] -to [get_clocks {rx_usr_clk}]
#set_false_path -from [get_clocks{ rx_usr_clk }] -to [get_clocks{ mm_clk }] -to {core:core_dummy|ilk_core_50g:core_inst|ilk_hard_pcs_assembly_a10_50g:pcs_assembly_a10_gen.hah|ilk_hard_pcs_csr_a10:ilk_hard_pcs_csr_inst|mm_rdata[4]} 
#set_false_path -from [get_clocks {rx_usr_clk}] -to [get_clocks {mm_clk}] -to {core:core_dummy|ilk_core_50g:core_inst|ilk_hard_pcs_assembly_a10_50g:pcs_assembly_a10_gen.hah|ilk_hard_pcs_csr_a10:ilk_hard_pcs_csr_inst|mm_rdata[4]}
#set_false_path -through {*ilk_hard_pcs_assembly_a10_50g*ilk_hard_pcs_csr_a10*mm_rdata*}  -from [get_clocks {rx_usr_clk}] -to [get_clocks {mm_clk}] 
set_false_path -from [get_clocks {rx_usr_clk}] -to [get_clocks {mm_clk}] 
set_false_path -from [get_clocks {mm_clk}] -to [get_clocks {rx_usr_clk}] 
set_false_path -from [get_clocks {tx_usr_clk}] -to [get_clocks {mm_clk}] 
set_false_path -from [get_clocks {mm_clk}] -to [get_clocks {tx_usr_clk}] 
set regs [get_registers -nowarn *frequency_monitor*scaled_toggle]
if {[llength [query_collection -report -all $regs]] > 0} {set_false_path -from $regs}

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

if {$::TimeQuestInfo(nameofexecutable) eq "quartus_fit"} {
} else {
set_false_path -from {*ilk_hard_pcs_assembly_a10_50g*np*twentynm_xcvr_native*pld_10g_tx_empty_reg*} -to {*ilk_hard_pcs_assembly_a10_50g*ilk_tx_aligner*ilk_status_sync*sync_0[*]}
}

if {$::TimeQuestInfo(nameofexecutable) eq "quartus_fit"} {
} else {
set_false_path -to [get_registers {*ilk_status_sync*sync_0[*]}]}

