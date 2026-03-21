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


# (C) 2001-2015 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.

#**************************************************************
# Create input reference Clocks
#**************************************************************

create_clock -period "125 MHz" -name {refclk_1g2p5g} [get_ports refclk_1g2p5g]
create_clock -period "644.53125 MHz" -name {refclk_10g} [get_ports refclk_10g]

derive_pll_clocks -create_base_clocks
derive_clock_uncertainty

# If design use different clocking scheme, or different PLL type, this file must be updated accordingly

# 1G/2.5G PLL serial clock name
# For 1G path and 2.5G path, the hard PCS configuration is same, we only need to ensure the design could meet timing at fastest speed, which is 2.5G
if  {[info exists serclk_1g2p5g]} { 
    post_message -type info "Variable serclk_1g2p5g already exists."
} else {
    post_message -type info "Creating variable serclk_1g2p5g" 
    set serclk_1g2p5g "DUT|u_xcvr_atx_pll_2p5g|xcvr_atx_pll_a10_0|mcgb_serial_clk"
}

# Set the channel prefix & instance for the design to generate the 1G/2.5G clocks
# This would be edited if extra channels are added to the design
if  {[info exists ch_prefix]} { 
    post_message -type info "Variable ch_prefix already exists."
} else {
    post_message -type info "Creating variable ch_prefix" 
    set ch_prefix [list "DUT|CHANNEL_GEN[0].u_channel|" \
                        "DUT|CHANNEL_GEN[1].u_channel|" \
    ]
}

# Hierarchical path definition
set native_ls_inst  "alt_mge_xcvr_native|"

set rx_pld_clk_10g_source       "g_xcvr_native_insts[0].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_rx_pcs_pma_interface.inst_twentynm_hssi_rx_pcs_pma_interface|pma_rx_pma_clk"
set rx_pld_clk_10g_target       "g_xcvr_native_insts[0].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_rx_pld_pcs_interface.inst_twentynm_hssi_rx_pld_pcs_interface|pld_pcs_rx_clk_out"

set tx_pld_clk_10g_source       "g_xcvr_native_insts[0].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_tx_pcs_pma_interface.inst_twentynm_hssi_tx_pcs_pma_interface|pma_tx_pma_clk"
set tx_pld_clk_10g_target       "g_xcvr_native_insts[0].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_tx_pld_pcs_interface.inst_twentynm_hssi_tx_pld_pcs_interface|pld_pcs_tx_clk_out"

set rx_pma_clk_1g2p5g_target    "g_xcvr_native_insts[0].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pma|gen_twentynm_hssi_pma_rx_deser.inst_twentynm_hssi_pma_rx_deser|clkdiv"
set rx_pcs_clk_1g2p5g_source    "g_xcvr_native_insts[0].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs|byte_deserializer_pcs_clk_div_by_2_reg"
set rx_pcs_clk_1g2p5g_target    "g_xcvr_native_insts[0].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs|sta_rx_clk2_by2_2"
set rx_pld_clk_1g2p5g_source    "g_xcvr_native_insts[0].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs|byte_deserializer_pld_clk_div_by_2_reg"
set rx_pld_clk_1g2p5g_target    "g_xcvr_native_insts[0].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs|sta_rx_clk2_by2_2_out"

set tx_pma_clk_1g2p5g_target    "g_xcvr_native_insts[0].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pma|gen_twentynm_hssi_pma_tx_cgb.inst_twentynm_hssi_pma_tx_cgb|cpulse_out_bus[0]"
set tx_pcs_clk_1g2p5g_source    "g_xcvr_native_insts[0].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_tx_pcs.inst_twentynm_hssi_8g_tx_pcs|byte_serializer_pcs_clk_div_by_2_reg"
set tx_pcs_clk_1g2p5g_target    "g_xcvr_native_insts[0].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_tx_pcs.inst_twentynm_hssi_8g_tx_pcs|sta_tx_clk2_by2_1"
set tx_pld_clk_1g2p5g_source    "g_xcvr_native_insts[0].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_tx_pcs.inst_twentynm_hssi_8g_tx_pcs|byte_serializer_pld_clk_div_by_2_reg"
set tx_pld_clk_1g2p5g_target    "g_xcvr_native_insts[0].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_tx_pcs.inst_twentynm_hssi_8g_tx_pcs|sta_tx_clk2_by2_1_out"

# Nodes in Native PHY 10G PCS
set hssi_10g_pcs_if "*|twentynm_xcvr_native:*|twentynm_pcs*:*|gen_twentynm_hssi_tx_pld_pcs_interface.inst_twentynm_hssi_tx_pld_pcs_interface~pld_10g_tx_data_valid_2ff_delay4_fastreg.reg \
                     *|twentynm_xcvr_native:*|twentynm_pcs*:*|gen_twentynm_hssi_tx_pld_pcs_interface.inst_twentynm_hssi_tx_pld_pcs_interface~pld_tx_control_lo_10g_2ff_delay4_fastreg.reg \
                     *|twentynm_xcvr_native:*|twentynm_pcs*:*|gen_twentynm_hssi_tx_pld_pcs_interface.inst_twentynm_hssi_tx_pld_pcs_interface~pld_tx_data_lo_10g_2ff_delay4_fastreg.reg \
                     *|twentynm_xcvr_native:*|twentynm_pcs*:*|gen_twentynm_hssi_10g_rx_pcs.inst_twentynm_hssi_10g_rx_pcs~pld_10g_rx_data_valid_10g_reg.reg \
                     *|twentynm_xcvr_native:*|twentynm_pcs*:*|gen_twentynm_hssi_10g_rx_pcs.inst_twentynm_hssi_10g_rx_pcs~pld_rx_control_10g_reg.reg \
                     *|twentynm_xcvr_native:*|twentynm_pcs*:*|gen_twentynm_hssi_10g_rx_pcs.inst_twentynm_hssi_10g_rx_pcs~pld_rx_data_10g_reg.reg \
                     *|alt_mgbaset_phy:*|alt_mge16_phy_xcvr_term:*|tx_enh_data_valid_out \
                     *|alt_mgbaset_phy:*|alt_mge16_phy_xcvr_term:*|tx_control_a10\[*\] \
                     *|alt_mgbaset_phy:*|alt_mge16_phy_xcvr_term:*|rx_enh_data_valid_in_reg2 \
                     *|alt_mgbaset_phy:*|alt_mge16_phy_xcvr_term:*|rx_control_a10_reg2\[*\]"

for {set i 0} {$i < 64} {incr i} {
    if {($i >=  9) && ($i <= 21)} {append hssi_10g_pcs_if " *|alt_mgbaset_phy:*|alt_mge16_phy_xcvr_term:*|tx_parallel_data_a10\[$i\]"}
    if {($i >= 31) && ($i <= 63)} {append hssi_10g_pcs_if " *|alt_mgbaset_phy:*|alt_mge16_phy_xcvr_term:*|tx_parallel_data_a10\[$i\]"}
    if {($i >= 13) && ($i <= 14)} {append hssi_10g_pcs_if " *|alt_mgbaset_phy:*|alt_mge16_phy_xcvr_term:*|rx_parallel_data_a10_reg2\[$i\]"}
    if {($i >= 16) && ($i <= 31)} {append hssi_10g_pcs_if " *|alt_mgbaset_phy:*|alt_mge16_phy_xcvr_term:*|rx_parallel_data_a10_reg2\[$i\]"}
    if {($i >= 45) && ($i <= 46)} {append hssi_10g_pcs_if " *|alt_mgbaset_phy:*|alt_mge16_phy_xcvr_term:*|rx_parallel_data_a10_reg2\[$i\]"}
    if {($i >= 48) && ($i <= 63)} {append hssi_10g_pcs_if " *|alt_mgbaset_phy:*|alt_mge16_phy_xcvr_term:*|rx_parallel_data_a10_reg2\[$i\]"}
}

# Nodes in Native PHY 8G PCS
set hssi_8g_pcs_if  "*twentynm_xcvr_native:*|twentynm_pcs*:*|gen_twentynm_hssi_8g_tx_pcs.inst_twentynm_hssi_8g_tx_pcs~tx_clk2_by2_1.reg \
                     *twentynm_xcvr_native:*|twentynm_pcs*:*|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs~rx_clk2_by2_2.reg \
                     *twentynm_xcvr_native:*|twentynm_pcs*:*|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs~byte_deserializer_pcs_clk_div_by_2_reg.reg"

post_message -type info "Creating generated clocks for 1G/2.5G mode"

foreach ch $ch_prefix {
    
    set ch_phy "${ch}phy|alt_mge_phy_0|"
    
    # Create the 1G/2.5G RX clock
    set rx_pma_clk_1g2p5g_name  "${ch_phy}rx_pma_clk_1g2p5g"
    set clock_node              "${ch_phy}$native_ls_inst$rx_pma_clk_1g2p5g_target"
    create_generated_clock -name $rx_pma_clk_1g2p5g_name -source [get_clock_info -targets refclk_1g2p5g] -divide_by 2 -multiply_by 5 [get_pins $clock_node] -add
    
    set rx_clk_1g2p5g_name      "${ch_phy}rx_clk_1g2p5g"
    set clock_source            "${ch_phy}$native_ls_inst$rx_pcs_clk_1g2p5g_source"
    set clock_node              "${ch_phy}$native_ls_inst$rx_pcs_clk_1g2p5g_target"
    create_generated_clock -name $rx_clk_1g2p5g_name -source [get_pins $clock_source] -master_clock $rx_pma_clk_1g2p5g_name -divide_by 2 -multiply_by 1 [get_pins $clock_node] -add
    
    set rx_clkout_1g2p5g_name   "${ch_phy}rx_clkout_1g2p5g"
    set clock_source            "${ch_phy}$native_ls_inst$rx_pld_clk_1g2p5g_source"
    set clock_node              "${ch_phy}$native_ls_inst$rx_pld_clk_10g_target"
    create_generated_clock -name $rx_clkout_1g2p5g_name -source [get_pins $clock_source] -master_clock $rx_pma_clk_1g2p5g_name -divide_by 2 -multiply_by 1 [get_pins $clock_node] -add
    
    # Create the 1G/2.5G TX clock
    set tx_pma_clk_1g2p5g_name  "${ch_phy}tx_pma_clk_1g2p5g"
    set clock_node              "${ch_phy}$native_ls_inst$tx_pma_clk_1g2p5g_target"
    create_generated_clock -name $tx_pma_clk_1g2p5g_name -source [get_clock_info -targets $serclk_1g2p5g] -divide_by 5 -multiply_by 1 [get_pins $clock_node] -add
    
    set tx_clk_1g2p5g_name      "${ch_phy}tx_clk_1g2p5g"
    set clock_source            "${ch_phy}$native_ls_inst$tx_pcs_clk_1g2p5g_source"
    set clock_node              "${ch_phy}$native_ls_inst$tx_pcs_clk_1g2p5g_target"
    create_generated_clock -name $tx_clk_1g2p5g_name -source [get_pins $clock_source] -master_clock $tx_pma_clk_1g2p5g_name -divide_by 2 -multiply_by 1 [get_pins $clock_node] -add
    
    set tx_clkout_1g2p5g_name   "${ch_phy}tx_clkout_1g2p5g"
    set clock_source            "${ch_phy}$native_ls_inst$tx_pld_clk_1g2p5g_source"
    set clock_node              "${ch_phy}$native_ls_inst$tx_pld_clk_10g_target"
    create_generated_clock -name $tx_clkout_1g2p5g_name -source [get_pins $clock_source] -master_clock $tx_pma_clk_1g2p5g_name -divide_by 2 -multiply_by 1 [get_pins $clock_node] -add
    
    # Create the 10G (default) clocks which were not created by the IPSTA due to 1G/2.5G clocks just created above
    set rx_clkout_10g_name  "${ch_phy}rx_clkout"
    set master_src          "${ch_phy}rx_pma_clk"
    set clock_source        "${ch_phy}$native_ls_inst$rx_pld_clk_10g_source"
    set clock_node          "${ch_phy}$native_ls_inst$rx_pld_clk_10g_target"
    create_generated_clock -name $rx_clkout_10g_name -source [get_pins $clock_source] -master_clock $master_src [get_pins $clock_node] -add
    
    set tx_clkout_10g_name  "${ch_phy}tx_clkout"
    set master_src          "${ch_phy}tx_pma_clk"
    set clock_source        "${ch_phy}$native_ls_inst$tx_pld_clk_10g_source"
    set clock_node          "${ch_phy}$native_ls_inst$tx_pld_clk_10g_target"
    create_generated_clock -name $tx_clkout_10g_name -source [get_pins $clock_source] -master_clock $master_src [get_pins $clock_node] -add
    
    # PMA clock name for setting false path
    set rx_pma_clk_10g_name  "${ch_phy}rx_pma_clk"
    set tx_pma_clk_10g_name  "${ch_phy}tx_pma_clk"
    
    # False path between 10G clocks and 1G/2.5G clocks
    set_clock_groups -exclusive -group [get_clocks "$rx_pma_clk_1g2p5g_name $rx_clk_1g2p5g_name $rx_clkout_1g2p5g_name"] -group [get_clocks "$rx_pma_clk_10g_name $rx_clkout_10g_name"]
    set_clock_groups -exclusive -group [get_clocks "$tx_pma_clk_1g2p5g_name $tx_clk_1g2p5g_name $tx_clkout_1g2p5g_name"] -group [get_clocks "$tx_pma_clk_10g_name $tx_clkout_10g_name"]
    
    # False path from 10G clock to 1G/2.5G PHY logic
    set_false_path -from [get_clocks "$rx_pma_clk_10g_name $rx_clkout_10g_name $tx_pma_clk_10g_name $tx_clkout_10g_name"] -to [get_registers "*|alt_mge16_pcs_pma:*|* $hssi_8g_pcs_if"]
    set_false_path -from [get_registers "*|alt_mge16_pcs_pma:*|* $hssi_8g_pcs_if"] -to [get_clocks "$rx_pma_clk_10g_name $rx_clkout_10g_name $tx_pma_clk_10g_name $tx_clkout_10g_name"]
    
    # False path from 1G/2.5G clock to 10G PHY logic
    set_false_path -from [get_clocks "$rx_pma_clk_1g2p5g_name $rx_clk_1g2p5g_name $rx_clkout_1g2p5g_name $tx_pma_clk_1g2p5g_name $tx_clk_1g2p5g_name $tx_clkout_1g2p5g_name"] -to [get_registers "*|alt_mge_phy_xgmii_pcs:*|* $hssi_10g_pcs_if"]
    set_false_path -from [get_registers "*|alt_mge_phy_xgmii_pcs:*|* $hssi_10g_pcs_if"] -to [get_clocks "$rx_pma_clk_1g2p5g_name $rx_clk_1g2p5g_name $rx_clkout_1g2p5g_name $tx_pma_clk_1g2p5g_name $tx_clk_1g2p5g_name $tx_clkout_1g2p5g_name"]
    
    # False path from 10G clock to Low Latency 10G MAC (MAC is not using 322 MHz clock)
    set_false_path -from [get_clocks "$rx_pma_clk_10g_name $rx_clkout_10g_name $tx_pma_clk_10g_name $tx_clkout_10g_name"] -to [get_registers *|alt_em10g32:*|*]
    set_false_path -from [get_registers *|alt_em10g32:*|*] -to [get_clocks "$rx_pma_clk_10g_name $rx_clkout_10g_name $tx_pma_clk_10g_name $tx_clkout_10g_name"]
}

#**************************************************************
# Set False Path for alt_mge_reset_synchronizer
#**************************************************************
set reset_sync_aclr_counter 0
set reset_sync_clrn_counter 0
set reset_sync_aclr_collection [get_pins -compatibility_mode -nocase -nowarn *alt_mge_reset_synchronizer:*|alt_mge_reset_synchronizer_int_chain*|aclr]
set reset_sync_clrn_collection [get_pins -compatibility_mode -nocase -nowarn *alt_mge_reset_synchronizer:*|alt_mge_reset_synchronizer_int_chain*|clrn]

foreach_in_collection reset_sync_aclr_pin $reset_sync_aclr_collection {
    set reset_sync_aclr_counter [expr $reset_sync_aclr_counter + 1]
}

foreach_in_collection reset_sync_clrn_pin $reset_sync_clrn_collection {
    set reset_sync_clrn_counter [expr $reset_sync_clrn_counter + 1]
}

if {$reset_sync_aclr_counter > 0} {
    set_false_path -to [get_pins -compatibility_mode -nocase *alt_mge_reset_synchronizer:*|alt_mge_reset_synchronizer_int_chain*|aclr]
}

if {$reset_sync_clrn_counter > 0} {
    set_false_path -to [get_pins -compatibility_mode -nocase *alt_mge_reset_synchronizer:*|alt_mge_reset_synchronizer_int_chain*|clrn]
}

## Workaround for not meeting setup time
#if {![string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
#    set_max_delay -from [get_keepers *|alt_mge16_phy_xcvr_term:*|tx_parallel_data_a10*] -to [get_keepers *|twentynm_pcs*:*|gen_twentynm_hssi_8g_tx_pcs.inst_twentynm_hssi_8g_tx_pcs~tx_clk2_by2_1.reg] 6.2ns
#    set_min_delay -from [get_keepers *|alt_mge16_phy_xcvr_term:*|tx_parallel_data_a10*] -to [get_keepers *|twentynm_pcs*:*|gen_twentynm_hssi_8g_tx_pcs.inst_twentynm_hssi_8g_tx_pcs~tx_clk2_by2_1.reg] -0.2ns
#}
