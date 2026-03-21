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


set old_mode [set_project_mode -get_mode_value always_show_entity_name] 
set_project_mode -always_show_entity_name on

# Clock crosser constraint
set inst [get_registers -nowarn *alt_e2550_ptp_clock_crosser*]
set inst_num [llength [query_collection -report -all $inst]]
if {$inst_num > 0} {
    # -----------------------------------------------------------------------------
    # Intel FPGA timing constraints for Avalon clock domain crossing (CDC) paths.
    # The purpose of these constraints is to remove the false paths and replace with timing bounded 
    # requirements for compilation.
    #
    # ***Important note *** 
    #
    # The clocks involved in this transfer must be kept synchronous and no false path
    # should be set on these paths for these constraints to apply correctly.
    # -----------------------------------------------------------------------------

    set temp_inst "alt_e2550_ptp_clock_crosser:"
    set_net_delay -from [get_registers *${temp_inst}*|in_data_buffer* ] -to [get_registers *${temp_inst}*|out_data_buffer* ] -max 2
    set_max_delay -from [get_registers *${temp_inst}*|in_data_buffer* ] -to [get_registers *${temp_inst}*|out_data_buffer* ] 100
    set_min_delay -from [get_registers *${temp_inst}*|in_data_buffer* ] -to [get_registers *${temp_inst}*|out_data_buffer* ] -100

    set_net_delay -from [get_registers *${temp_inst}*|ff_launch* ] -to [get_registers *${temp_inst}*|ff_meta* ] -max 2
    set_max_delay -from [get_registers *${temp_inst}*|ff_launch* ] -to [get_registers *${temp_inst}*|ff_meta* ] 100
    set_min_delay -from [get_registers *${temp_inst}*|ff_launch* ] -to [get_registers *${temp_inst}*|ff_meta* ] -100    
}


# Function to constraint pointers
proc altera_10gbaser_phy_constraint_ptr {from_path from_reg to_path to_reg max_skew max_net_delay} {
    
    if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
        # Check for instances
        set inst [get_registers -nowarn *${from_path}|${from_reg}*]
        
        # Check number of instances
        set inst_num [llength [query_collection -report -all $inst]]
        if {$inst_num > 0} {
            # Uncomment line below for debug purpose
            #puts "${inst_num} ${from_path}|${from_reg} instance(s) found"
        } else {
            # Uncomment line below for debug purpose
            #puts "No ${from_path}|${from_reg} instance found"
        }
        
        set inst_list [query_collection -list -all $inst]
        foreach each_inst $inst_list {
            # Get the path to instance
            regexp "(.*${from_path})(.*|)(${from_reg})" $each_inst reg_path inst_path inst_name reg_name
            
            set_max_skew -from [get_registers ${inst_path}${inst_name}${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] $max_skew
            
            set_max_delay -from [get_registers ${inst_path}${inst_name}${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] 100ns
            set_min_delay -from [get_registers ${inst_path}${inst_name}${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] -100ns
        }
        
    } else {
        set_net_delay -from [get_pins -compatibility_mode *${from_path}|${from_reg}*|q] -to [get_registers *${to_path}|${to_reg}*] -max $max_net_delay
        
        # Relax the fitter effort
        set_max_delay -from [get_registers *${from_path}|${from_reg}*] -to [get_registers *${to_path}|${to_reg}*] 100ns
        set_min_delay -from [get_registers *${from_path}|${from_reg}*] -to [get_registers *${to_path}|${to_reg}*] -100ns
        
    }
    
}

# DCFIFO pointer constraint
set inst [get_registers -nowarn *alt_e2550_ptp_async_fifo*dcfifo_componenet*]
set inst_num [llength [query_collection -report -all $inst]]
if {$inst_num > 0} {

    # DCFIFO async reset constraint
    set_false_path -to [get_pins -compatibility_mode *alt_e2550_ptp_async_fifo*dffpipe*rdaclr*|clrn]
    set_false_path -to [get_pins -compatibility_mode *alt_e2550_ptp_async_fifo*dffpipe*wraclr*|clrn]
    
    #TX
    altera_10gbaser_phy_constraint_ptr  alt_e2550_ptp_fifo_top:ptp_top.ptp_fifo|alt_e2550_ptp_tx_fifo:tx_fifo|alt_e2550_ptp_async_fifo:fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated  delayed_wrptr_g  alt_e2550_ptp_fifo_top:ptp_top.ptp_fifo|alt_e2550_ptp_tx_fifo:tx_fifo|alt_e2550_ptp_async_fifo:fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated|alt_synch_pipe_*:rs_dgwp*|*  *dffe*  2ns  2ns
    altera_10gbaser_phy_constraint_ptr  alt_e2550_ptp_fifo_top:ptp_top.ptp_fifo|alt_e2550_ptp_tx_fifo:tx_fifo|alt_e2550_ptp_async_fifo:fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated  rdptr_g          alt_e2550_ptp_fifo_top:ptp_top.ptp_fifo|alt_e2550_ptp_tx_fifo:tx_fifo|alt_e2550_ptp_async_fifo:fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated|alt_synch_pipe_*:ws_dgrp*|*  *dffe*  2ns  2ns
    #RX
    altera_10gbaser_phy_constraint_ptr  alt_e2550_ptp_fifo_top:ptp_top.ptp_fifo|alt_e2550_ptp_rx_fifo:rx_fifo|alt_e2550_ptp_async_fifo:fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated  delayed_wrptr_g  alt_e2550_ptp_fifo_top:ptp_top.ptp_fifo|alt_e2550_ptp_rx_fifo:rx_fifo|alt_e2550_ptp_async_fifo:fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated|alt_synch_pipe_*:rs_dgwp*|*  *dffe*  2ns  2ns
    altera_10gbaser_phy_constraint_ptr  alt_e2550_ptp_fifo_top:ptp_top.ptp_fifo|alt_e2550_ptp_rx_fifo:rx_fifo|alt_e2550_ptp_async_fifo:fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated  rdptr_g          alt_e2550_ptp_fifo_top:ptp_top.ptp_fifo|alt_e2550_ptp_rx_fifo:rx_fifo|alt_e2550_ptp_async_fifo:fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated|alt_synch_pipe_*:ws_dgrp*|*  *dffe*  2ns  2ns

}

set_project_mode -always_show_entity_name $old_mode
