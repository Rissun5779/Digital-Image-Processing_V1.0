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


#-----------------------------------------------------------------------------
#
# Description: SDC file for alt_xaui 
#
# Authors:     bauyeung 
#
#              Copyright (c) Altera Corporation 1997 - 2010
#              All rights reserved.
#
#
#-----------------------------------------------------------------------------

#set_time_format -unit ns -decimal_places 3
#derive_pll_clocks
#derive_clock_uncertainty

#
# input clocks
#
#create_clock -name {xgmii_tx_clk} \
#    -period 6.400 -waveform {0.000 3.2} \
#    [ get_ports {xgmii_tx_clk} ]
#create_clock -name {phy_mgmt_clk} \
#    -period 20.000 -waveform {0.000 10.0} \
#    [ get_ports {phy_mgmt_clk} ]
#create_clock -name {refclk} \
#    -period 6.400 -waveform {0.000 3.2} \
#    [ get_ports {pll_ref_clk} ]


proc alt_xcvr_xaui_constraint_ptrs {from_node_list to_node_list} {
    set_net_delay -from $from_node_list -to $to_node_list -max 6ns
    set_max_delay -from $from_node_list -to $to_node_list 100
    set_min_delay -from $from_node_list -to $to_node_list -100
}

set TQ2 [get_global_assignment -name TIMEQUEST2]

if {$TQ2=="ON"} {

    # Cut path
    set_false_path -from [get_registers {*a10_xcvr_xaui*hxaui_csr*hxaui_csr_reset0q[1]}] -to  [get_registers *sxaui_0*alt_soft_xaui_pcs*tx_reset*]
    set_false_path -from [get_registers {*a10_xcvr_xaui*hxaui_csr*hxaui_csr_reset0q[1]}] -to  [get_registers *sxaui_0*alt_soft_xaui_pcs*rx_reset*]
    set_false_path -from [get_registers {*a10_xcvr_xaui*hxaui_csr*hxaui_csr_simulation_flag0q}] -to  [get_registers *sxaui_0*alt_soft_xaui_pcs*pcs_reset*simulation_flag_f]

    set_false_path -from  [get_registers *alt_soft_xaui_pcs|tx_reset_n] -to [get_registers *xaui_tx|reset_tx_clk_n]     
    set_false_path -from  [get_registers *alt_soft_xaui_pcs|tx_reset_n] -to [get_registers *xaui_tx|reset_tx_clk_n_meta] 

    set_false_path -from [get_registers *sxaui_0*alt_soft_xaui_pcs*rx_reset_n] -to  [get_registers *sxaui_0*alt_soft_xaui_pcs*xaui_rx*reset_channel_n_meta]
    set_false_path -from [get_registers *sxaui_0*alt_soft_xaui_pcs*rx_reset_n] -to  [get_registers *sxaui_0*alt_soft_xaui_pcs*xaui_rx*reset_channel_n]
    set_false_path -from [get_registers *sxaui_0*alt_soft_xaui_pcs*rx_reset_n] -to  [get_registers *sxaui_0*alt_soft_xaui_pcs*xaui_rx*reset_sysclk_n_meta]
    set_false_path -from [get_registers *sxaui_0*alt_soft_xaui_pcs*rx_reset_n] -to  [get_registers *sxaui_0*alt_soft_xaui_pcs*xaui_rx*reset_sysclk_n]


    # Check for instances
    set from_path pcs_rate_match
    set from_reg flag_rd
    set inst [get_registers -nowarn *$from_path*$from_reg]

    set inst_list [query_collection -list -all $inst]
    foreach each_inst $inst_list {
        # Get the path to instance
        regexp "(.*${from_path}.*|)(${from_reg})" $each_inst reg_path inst_path reg_name

        # Set delay
        alt_xcvr_xaui_constraint_ptrs [get_registers "${inst_path}*flag_rd"] [get_registers "${inst_path}*sync_flag_rd_wr*din_s1"]  
        alt_xcvr_xaui_constraint_ptrs [get_registers "${inst_path}*flag_wr"] [get_registers "${inst_path}*sync_flag_wr_rd*din_s1"] 

        alt_xcvr_xaui_constraint_ptrs [get_registers "${inst_path}*wr_ptr_latched_del[*]"] [get_registers "${inst_path}*wr_ptr_rd[*]"] 
        alt_xcvr_xaui_constraint_ptrs [get_registers "${inst_path}*rd_ptr_latched_del[*]"] [get_registers "${inst_path}*rd_ptr_wr[*]"] 

        # Set skew
        set_max_skew -from [get_registers "${inst_path}flag_rd ${inst_path}rd_ptr_latched_del[*]"] -to [get_registers "${inst_path}*sync_flag_rd_wr*din_s1 ${inst_path}rd_ptr_wr[*]"] 6.4ns
        set_max_skew -from [get_registers "${inst_path}flag_wr ${inst_path}wr_ptr_latched_del[*]"] -to [get_registers "${inst_path}*sync_flag_wr_rd*din_s1 ${inst_path}wr_ptr_rd[*]"] 6.4ns

   } 


}






