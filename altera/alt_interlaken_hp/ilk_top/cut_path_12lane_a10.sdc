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


# Set Cross-Clock False Paths

#tx_clkout -> tx_usr_clk
set_false_path -from [get_clocks {*pcs_assembly_a10_gen*np_inst*g_xcvr_native_insts[*]*twentynm_xcvr_native_inst*inst_twentynm_hssi_pma_tx_ser*wys*clk_divtx}] -to [get_clocks {tx_usr_clk}]

set_false_path -from [get_clocks {*pcs_assembly_a10_gen*np_inst*g_xcvr_native_insts[*]*twentynm_xcvr_native_inst*inst_twentynm_hssi_pma_tx_ser*wys*clk_divtx}] -to [get_clocks {mm_clk}]

#rx_clkout

set_false_path -from  [get_clocks {mm_clk}] -to [get_clocks { *pcs_assembly_a10_gen*hah*np*g_xcvr_native_insts[*]*twentynm_xcvr_native_inst*inst_twentynm_pcs*ch[*].inst_twentynm_pcs_ch*inst_twentynm_hssi_rx_pcs_pma_interface*wys~HSSI_CLOCK_pma_rx_pma_clk}]

#rx_usr_clk -> rx_coreclkin 
set_false_path -from [get_clocks {rx_usr_clk}] -to [get_clocks {*pcs_assembly_a10_gen*hah*np*g_xcvr_native_insts[*]*twentynm_xcvr_native_inst*inst_twentynm_pma*ch[*]*inst_twentynm_hssi_pma_rx_deser*clkdiv}]

#rx_clkout -> rx_usr_clk
set_false_path -from [get_clocks {*pcs_assembly_a10_gen*hah*np*g_xcvr_native_insts[*]*inst_twentynm_pma*inst_twentynm_pma_ch*inst_twentynm_hssi_pma_rx_deser*clkdiv}] -to [get_clocks {rx_usr_clk}]

#set_false_path -from {*ilk_iw8_retrans_ptr_fifo:rtptr_fifo|stable_wrptr[*]} -to {*ilk_iw8_retrans_ptr_fifo:rtptr_fifo|stable_wrptr_rdclk[*]}
#set_false_path -from {*ilk_iw8_retrans_ptr_fifo:txctl_fifo|stable_wrptr[*]} -to {*ilk_iw8_retrans_ptr_fifo:txctl_fifo|stable_wrptr_rdclk[*]}

##### tx_empty_r #####
#set_false_path -to *ilk_hard_pcs_assembly_a10*tx_empty_r*

##### tx_pempty_r #####
#set_false_path -to *ilk_hard_pcs_assembly_a10*tx_pempty_r*

##### rx_full_full ########added by hui 10ps setup violation
# set_false_path -to *ilk_hard_pcs_assembly_a10*ilk_tx_align_inst*tx_full_r[*]
##### tx_from_fifo ##### 

##### rx_full_full ########added by hui hold time violation
set_false_path -to *ilk_hard_pcs_assembly_a10*ilk_rx_aligner_inst*rx_none_pempty
set_false_path -to *ilk_hard_pcs_assembly_a10*ilk_rx_aligner_inst*rx_control_i[*]
set_false_path -to *ilk_hard_pcs_assembly_a10*ilk_rx_aligner_inst*rx_dout_i[*]
set_false_path -to *ilk_hard_pcs_assembly_a10*ilk_rx_aligner_inst*rx_valid_i[*]
set_false_path -to *ilk_hard_pcs_assembly_a10*ilk_rx_aligner_inst*rx_pempty_r[*]
set_false_path -to *ilk_hard_pcs_assembly_a10*np_inst*g_xcvr_native_insts[*].twentynm_xcvr_native_inst*inst_twentynm_pcs*ch[*]*inst_twentynm_pcs_ch*wys~HSSI_CLOCK_ch*_pld_tx_clk
##### tx_from_fifo ##### 

##### rx_any_pfull #####
set_false_path -to *ilk_hard_pcs_assembly_a10*rx_any_pfull*
##### tx_from_fifo ##### 

##### db_iport_pcs10grxcrc32err	#####
#if {$::TimeQuestInfo(nameofexecutable) eq "quartus_fit"} {
#} else {
#set_false_path -from [get_pins -compatibility_mode {*pcs_assembly_a10_gen*np*xcvr_native_insts*twentynm_xcvr_native_inst*inst_twentynm_pcs*ch[*]*gen_twentynm_hssi_rx_pld_pcs_interface*pld_10g_rx_crc32_err*}] -to {*ilk_hard_pcs_assembly_a10*hah*ecnt[*]*local_cnt[*]}
#set_false_path -from [get_pins -compatibility_mode {*pcs_assembly_a10_gen*np*xcvr_native_insts*twentynm_xcvr_native_inst*inst_twentynm_pcs*ch[*]*gen_twentynm_hssi_rx_pld_pcs_interface*pld_10g_rx_crc32_err*}] -to {*ilk_core*ilk_pulse_stretch_sync*ss_crc32_err*din_toggle[*]}
#set_false_path -from [get_pins -compatibility_mode {*pcs_assembly_a10_gen*np*xcvr_native_insts*twentynm_xcvr_native_inst*inst_twentynm_pcs*ch[*]*gen_twentynm_hssi_rx_pld_pcs_interface*pld_10g_rx_crc32_err*}] -to {*ilk_core*ilk_pulse_stretch_sync*ss_crc32_err*din_r[*]}
#}
set_false_path -through [get_pins -compatibility_mode {*pld_10g_rx_crc32_err*} ] -to [get_registers {*din_toggle*}]
set_false_path -through [get_pins -compatibility_mode {*pld_10g_rx_crc32_err*} ] -to [get_registers {*din_r*}]

