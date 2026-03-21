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


set clk_check    [get_clocks -nowarn *X_CORE_CLK]
set length       [get_collection_size $clk_check]
if {$length!=0} { 
 remove_clock {RX_CORE_CLK  TX_CORE_CLK }
}


derive_pll_clocks -create_base_clocks
derive_clock_uncertainty

set RX_CORE_CLK [get_clocks *|*xcvr_native_insts[2]|rx_pma_div_clk]

# TX PLL changes depending upon the RS-FEC
set fec_check    [get_keepers -nowarn *alt_aeu_100_rs_rx*]
set length       [get_collection_size $fec_check]
if {$length==0} { 
  set TX_CORE_CLK [get_clocks *|phy*|*txp|caui4_tx_pll*tx_core_clk]
   set SYNTH_RSFEC 0
} else {
  set TX_CORE_CLK  [get_clocks *|phy*|*txp|caui4_txrs_pll*outclk0]
  set SYNTH_RSFEC 1
} 

if {$::TimeQuestInfo(nameofexecutable) eq "quartus_fit"} {
                # fitter
				set_clock_uncertainty 0.424ns -add -from $RX_CORE_CLK -to $RX_CORE_CLK -setup
				set_clock_uncertainty 0.424ns -add -from $TX_CORE_CLK -to $TX_CORE_CLK -setup
                                set_clock_uncertainty -hold -enable_same_physical_edge -add 0.2 -from [get_clocks {*|g_xcvr_native_insts[*]|tx_clkout}] -to [get_clocks {*|g_xcvr_native_insts[*]|tx_pma_clk}]
} else {
                # everywhere else
}


create_clock -name {clk_status} -period 10.0    -waveform { 0.000 5.000 } [get_ports {clk_status}]
create_clock -name {reconfig_clk} -period 10.0  -waveform { 0.000 5.000 } [get_ports {reconfig_clk}]

set_clock_groups -exclusive -group $TX_CORE_CLK -group $RX_CORE_CLK -group clk_status -group reconfig_clk

if {$SYNTH_RSFEC} {
  set_false_path -from  [get_registers *|caui4_e100_pcs_assembly:phy.epa|sync_regs:rsfec.rs_reset_inst|sync_sr[0]]    -to  [get_registers *|alt_aeu_100_rs_rx:rsfec.rx_rsfec|alt_aeu_100_rst:rstt|csr_f1]
  set_false_path -from  [get_registers *|caui4_e100_pcs_assembly:phy.epa|caui4_e100_pma:iof|sync_regs:sr0|sync_sr[0]] -to  [get_registers *|caui4_e100_pcs_assembly:phy.epa|rsfec.rdtx_d1[*]]
  set_false_path -from  [get_registers *|caui4_e100_pcs_assembly:phy.epa|caui4_e100_pma:iof|sync_regs:sr0|sync_sr[0]] -to  [get_registers *|caui4_e100_pcs_assembly:phy.epa|alt_aeu_100_rs_tx:rsfec.tx_rsfec|alt_aeu_100_rst:rstt|pma_f1]
  set_false_path -from  [get_registers *|caui4_e100_pcs_assembly:phy.epa|caui4_e100_pma:iof|sync_regs:sr0|sync_sr[0]] -to  [get_registers *|caui4_e100_pcs_assembly:phy.epa|alt_aeu_100_rs_tx:rsfec.tx_rsfec|alt_aeu_100_rst:rstt|rs_f1]
  set_false_path -from  [get_registers *|caui4_e100_pcs_assembly:phy.epa|caui4_e100_pma:iof|sync_regs:sr1|sync_sr[0]] -to  [get_registers *|caui4_e100_pcs_assembly:phy.epa|alt_aeu_100_rs_rx:rsfec.rx_rsfec|alt_aeu_100_rst:rstt|rs_f1]
  set_false_path -from  [get_registers *|caui4_e100_pcs_assembly:phy.epa|caui4_e100_pma:iof|sync_regs:sr1|sync_sr[0]] -to  [get_registers *|caui4_e100_pcs_assembly:phy.epa|alt_aeu_100_rs_rx:rsfec.rx_rsfec|alt_aeu_100_rst:rstt|pma_f1]
  set_false_path -from  [get_registers *|caui4_e100_pcs_assembly:phy.epa|sync_regs:sr3|sync_sr[0]]                    -to  [get_registers *|caui4_e100_pcs_assembly:phy.epa|alt_aeu_100_rs_rx:rsfec.rx_rsfec|alt_aeu_100_rst:rstt|rs_f1]
  set_false_path -from  [get_registers *|caui4_e100_pcs_assembly:phy.epa|sync_regs:sr3|sync_sr[0]]                    -to  [get_registers *|caui4_e100_pcs_assembly:phy.epa|alt_aeu_100_rs_rx:rsfec.rx_rsfec|alt_aeu_100_rst:rstt|pma_f1]
  set_false_path -from  [get_registers *|caui4_e100_pcs_assembly:phy.epa|sync_regs:rsfec.rs_reset_inst|sync_sr[0]]    -to  [get_registers *|caui4_e100_pcs_assembly:phy.epa|alt_aeu_100_rs_rx:rsfec.rx_rsfec|alt_aeu_100_rst:rstt|rs_f1]
  set_false_path -from  [get_registers *|caui4_e100_pcs_assembly:phy.epa|sync_regs:rsfec.rs_reset_inst|sync_sr[0]]    -to  [get_registers *|caui4_e100_pcs_assembly:phy.epa|alt_aeu_100_rs_rx:rsfec.rx_rsfec|alt_aeu_100_rst:rstt|mac_f1]
}

#set_false_path -from [get_clocks -nowarn {ex_100g_caui4_inst|ex_100g_caui4_inst|g_xcvr_native_insts[*]|tx_clkout}] -to [get_clocks -nowarn {ex_100g_caui4_inst|ex_100g_caui4_inst|g_xcvr_native_insts[*]|tx_pma_clk}]
