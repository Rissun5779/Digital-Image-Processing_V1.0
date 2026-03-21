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

# Function to constraint non-std_synchronizer path
proc alt_mge_phy_usxg32_pcs_constraint_net_delay {from_reg to_reg max_net_delay {check_exist 0}} {
    
    # Check for instances
    set inst [get_registers -nowarn ${to_reg}]
    
    # Check number of instances
    set inst_num [llength [query_collection -report -all $inst]]
    if {$inst_num > 0} {
        # Uncomment line below for debug purpose
        #puts "${inst_num} ${to_reg} instance(s) found"
    } else {
        # Uncomment line below for debug purpose
        #puts "No ${to_reg} instance found"
    }
    
    if {($check_exist == 0) || ($inst_num > 0)} {
        if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
            set_max_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] 100ns
            set_min_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -100ns
        } else {
            set_net_delay -from [get_pins -compatibility_mode ${from_reg}|q] -to [get_registers ${to_reg}] -max $max_net_delay
            
            # Relax the fitter effort
            set_max_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] 100ns
            set_min_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -100ns
        }
    }
}

# Function to constraint std_synchronizer
proc alt_mge_phy_usxg32_pcs_constraint_std_sync {} {
   
    alt_mge_phy_usxg32_pcs_constraint_net_delay  *  *alt_mge_phy_usxg32_pcs:*|alt_mge16_pcs_std_synchronizer:*|altera_std_synchronizer_nocut:*|din_s1  2.2ns
   
}

# Function to constraint pointers
proc alt_mge_phy_usxg32_pcs_constraint_ptr {from_path from_reg to_path to_reg max_skew max_net_delay} {
    
    if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
        # Check for instances
        set inst [get_registers -nowarn *${from_path}|${from_reg}\[0\]]
        
        # Check number of instances
        set inst_num [llength [query_collection -report -all $inst]]
        if {$inst_num > 0} {
            # Uncomment line below for debug purpose
            #puts "${inst_num} ${from_path}|${from_reg} instance(s) found"
        } else {
            # Uncomment line below for debug purpose
            #puts "No ${from_path}|${from_reg} instance found"
        }
        
        # Constraint one instance at a time to avoid set_max_skew apply to all instances
        foreach_in_collection each_inst_tmp $inst {
            set each_inst [get_node_info -name $each_inst_tmp]
            
            # Get the path to instance
            regexp "(.*${from_path})(.*|)(${from_reg})" $each_inst reg_path inst_path inst_name reg_name
            
            set_max_skew -from [get_registers ${inst_path}${inst_name}${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] $max_skew
            
            set_max_delay -from [get_registers ${inst_path}${inst_name}${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] 100ns
            set_min_delay -from [get_registers ${inst_path}${inst_name}${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] -100ns
        }
        
    } else {
        set_net_delay -from [get_pins -compatibility_mode *${from_path}|${from_reg}[*]|q] -to [get_registers *${to_path}|${to_reg}*] -max $max_net_delay
        
        # Relax the fitter effort
        set_max_delay -from [get_registers *${from_path}|${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] 100ns
        set_min_delay -from [get_registers *${from_path}|${from_reg}[*]] -to [get_registers *${to_path}|${to_reg}*] -100ns
        
    }
    
}

# Function to constraint clock crosser
proc alt_mge_phy_usxg32_pcs_constraint_clock_crosser {} {
    set module_name alt_mge16_pcs_clock_crosser
    
    set from_reg1 in_data_toggle
    set to_reg1 alt_mge16_pcs_std_synchronizer:in_to_out_synchronizer|altera_std_synchronizer_nocut:*|din_s1
    
    set from_reg2 in_data_buffer
    set to_reg2 out_data_buffer
    
    set from_reg3 out_data_toggle_flopped
    set to_reg3 alt_mge16_pcs_std_synchronizer:out_to_in_synchronizer|altera_std_synchronizer_nocut:*|din_s1
    
    set max_skew 3ns
    
    set max_delay1 3ns
    set max_delay2 2ns
    set max_delay3 3ns
    
    if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
        # Check for instances
        set inst [get_registers -nowarn *${module_name}:*|${from_reg1}]
        
        # Check number of instances
        set inst_num [llength [query_collection -report -all $inst]]
        if {$inst_num > 0} {
            # Uncomment line below for debug purpose
            #puts "${inst_num} ${module_name} instance(s) found"
        } else {
            # Uncomment line below for debug purpose
            #puts "No ${module_name} instance found"
        }
        
        # Constraint one instance at a time to avoid set_max_skew apply to all instances
        foreach_in_collection each_inst_tmp $inst {
            set each_inst [get_node_info -name $each_inst_tmp]
            
            # Get the path to instance
            regexp "(.*${module_name})(:.*|)(${from_reg1})" $each_inst reg_path inst_path inst_name reg_name
            
            # Check if unused data buffer get synthesized away
            set reg2_collection [get_registers -nowarn ${inst_path}${inst_name}${to_reg2}[*]]
            set reg2_num [llength [query_collection -report -all $reg2_collection]]
            
            if {$reg2_num > 0} {
                set_max_skew -from [get_registers "${inst_path}${inst_name}${from_reg1} ${inst_path}${inst_name}${from_reg2}[*]"] -to [get_registers "${inst_path}${inst_name}${to_reg1} ${inst_path}${inst_name}${to_reg2}[*]"] $max_skew
                
                set_max_delay -from [get_registers ${inst_path}${inst_name}${from_reg2}[*]] -to [get_registers ${inst_path}${inst_name}${to_reg2}[*]] 100ns
                set_min_delay -from [get_registers ${inst_path}${inst_name}${from_reg2}[*]] -to [get_registers ${inst_path}${inst_name}${to_reg2}[*]] -100ns
            }
            
            set_max_delay -from [get_registers ${inst_path}${inst_name}${from_reg1}] -to [get_registers ${inst_path}${inst_name}${to_reg1}] 100ns
            set_min_delay -from [get_registers ${inst_path}${inst_name}${from_reg1}] -to [get_registers ${inst_path}${inst_name}${to_reg1}] -100ns
            
            set_max_delay -from [get_registers ${inst_path}${inst_name}${from_reg3}] -to [get_registers ${inst_path}${inst_name}${to_reg3}] 100ns
            set_min_delay -from [get_registers ${inst_path}${inst_name}${from_reg3}] -to [get_registers ${inst_path}${inst_name}${to_reg3}] -100ns
        }
        
    } else {
        set_net_delay -from [get_pins -compatibility_mode *${module_name}:*|${from_reg1}|q]    -to [get_registers *${module_name}:*|${to_reg1}] -max $max_delay1
        set_net_delay -from [get_pins -compatibility_mode *${module_name}:*|${from_reg2}[*]|q] -to [get_registers *${module_name}:*|${to_reg2}[*]] -max $max_delay2
        set_net_delay -from [get_pins -compatibility_mode *${module_name}:*|${from_reg3}|q]    -to [get_registers *${module_name}:*|${to_reg3}] -max $max_delay3
        
        # Relax the fitter effort
        set_max_delay -from [get_registers *${module_name}:*|${from_reg1}] -to [get_registers *${module_name}:*|${to_reg1}] 100ns
        set_min_delay -from [get_registers *${module_name}:*|${from_reg1}] -to [get_registers *${module_name}:*|${to_reg1}] -100ns
        
        set_max_delay -from [get_registers *${module_name}:*|${from_reg2}[*]] -to [get_registers *${module_name}:*|${to_reg2}[*]] 100ns
        set_min_delay -from [get_registers *${module_name}:*|${from_reg2}[*]] -to [get_registers *${module_name}:*|${to_reg2}[*]] -100ns
        
        set_max_delay -from [get_registers *${module_name}:*|${from_reg3}] -to [get_registers *${module_name}:*|${to_reg3}] 100ns
        set_min_delay -from [get_registers *${module_name}:*|${from_reg3}] -to [get_registers *${module_name}:*|${to_reg3}] -100ns
        
    }
    
}

# Function to constraint one way clock crosser
proc alt_mge_phy_usxg32_pcs_constraint_mbow_clock_crosser {} {
    set module_name alt_mge_phy_mbow_clock_crosser
    
    set from_reg1 in_transfer_valid
    set to_reg1 alt_mge16_pcs_std_synchronizer:sync_transfer_valid|altera_std_synchronizer_nocut:*|din_s1
    
    set from_reg2 in_data_buffer
    set to_reg2 out_data_buffer
    
    set max_skew 3ns
    
    set max_delay1 3ns
    set max_delay2 2ns
    
    if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
        # Check for instances
        set inst [get_registers -nowarn *${module_name}:*|${from_reg1}]
        
        # Check number of instances
        set inst_num [llength [query_collection -report -all $inst]]
        if {$inst_num > 0} {
            # Uncomment line below for debug purpose
            #puts "${inst_num} ${module_name} instance(s) found"
        } else {
            # Uncomment line below for debug purpose
            #puts "No ${module_name} instance found"
        }
        
        # Constraint one instance at a time to avoid set_max_skew apply to all instances
        foreach_in_collection each_inst_tmp $inst {
            set each_inst [get_node_info -name $each_inst_tmp]
            
            # Get the path to instance
            regexp "(.*${module_name})(:.*|)(${from_reg1})" $each_inst reg_path inst_path inst_name reg_name
            
            # Check if unused data buffer get synthesized away
            set reg2_collection [get_registers -nowarn ${inst_path}${inst_name}${to_reg2}[*]]
            set reg2_num [llength [query_collection -report -all $reg2_collection]]
            
            if {$reg2_num > 0} {
                set_max_skew -from [get_registers "${inst_path}${inst_name}${from_reg1} ${inst_path}${inst_name}${from_reg2}[*]"] -to [get_registers "${inst_path}${inst_name}${to_reg1} ${inst_path}${inst_name}${to_reg2}[*]"] $max_skew
                
                set_max_delay -from [get_registers ${inst_path}${inst_name}${from_reg2}[*]] -to [get_registers ${inst_path}${inst_name}${to_reg2}[*]] 100ns
                set_min_delay -from [get_registers ${inst_path}${inst_name}${from_reg2}[*]] -to [get_registers ${inst_path}${inst_name}${to_reg2}[*]] -100ns
            }
            
            set_max_delay -from [get_registers ${inst_path}${inst_name}${from_reg1}] -to [get_registers ${inst_path}${inst_name}${to_reg1}] 100ns
            set_min_delay -from [get_registers ${inst_path}${inst_name}${from_reg1}] -to [get_registers ${inst_path}${inst_name}${to_reg1}] -100ns
        }
        
    } else {
        set_net_delay -from [get_pins -compatibility_mode *${module_name}:*|${from_reg1}|q]    -to [get_registers *${module_name}:*|${to_reg1}] -max $max_delay1
        set_net_delay -from [get_pins -compatibility_mode *${module_name}:*|${from_reg2}[*]|q] -to [get_registers *${module_name}:*|${to_reg2}[*]] -max $max_delay2
        
        # Relax the fitter effort
        set_max_delay -from [get_registers *${module_name}:*|${from_reg1}] -to [get_registers *${module_name}:*|${to_reg1}] 100ns
        set_min_delay -from [get_registers *${module_name}:*|${from_reg1}] -to [get_registers *${module_name}:*|${to_reg1}] -100ns
        
        set_max_delay -from [get_registers *${module_name}:*|${from_reg2}[*]] -to [get_registers *${module_name}:*|${to_reg2}[*]] 100ns
        set_min_delay -from [get_registers *${module_name}:*|${from_reg2}[*]] -to [get_registers *${module_name}:*|${to_reg2}[*]] -100ns
        
    }
    
}

# Standard Synchronizer
alt_mge_phy_usxg32_pcs_constraint_std_sync

# Clock Crosser
alt_mge_phy_usxg32_pcs_constraint_clock_crosser

# One Way Clock Crosser
alt_mge_phy_usxg32_pcs_constraint_mbow_clock_crosser

# DC FIFO
alt_mge_phy_usxg32_pcs_constraint_ptr  alt_mge_phy_usxg32_pcs:*|alt_mge_phy_usxg32_tx_clockcomp_fifo:*|alt_mge_phy_async_fifo_fpga:async_fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated  delayed_wrptr_g  alt_mge_phy_usxg32_pcs:*|alt_mge_phy_usxg32_tx_clockcomp_fifo:*|alt_mge_phy_async_fifo_fpga:async_fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated|alt_synch_pipe_*:*|*  *dffe*  2.5ns  2.1ns
alt_mge_phy_usxg32_pcs_constraint_ptr  alt_mge_phy_usxg32_pcs:*|alt_mge_phy_usxg32_tx_clockcomp_fifo:*|alt_mge_phy_async_fifo_fpga:async_fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated  rdptr_g          alt_mge_phy_usxg32_pcs:*|alt_mge_phy_usxg32_tx_clockcomp_fifo:*|alt_mge_phy_async_fifo_fpga:async_fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated|alt_synch_pipe_*:*|*  *dffe*  2.5ns  2.1ns
alt_mge_phy_usxg32_pcs_constraint_ptr  alt_mge_phy_usxg32_pcs:*|alt_mge_phy_usxg32_rx_rm_fifo:*|alt_mge_phy_async_fifo_fpga:async_fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated  delayed_wrptr_g    alt_mge_phy_usxg32_pcs:*|alt_mge_phy_usxg32_rx_rm_fifo:*|alt_mge_phy_async_fifo_fpga:async_fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated|alt_synch_pipe_*:*|*  *dffe*  2.5ns  2.1ns
alt_mge_phy_usxg32_pcs_constraint_ptr  alt_mge_phy_usxg32_pcs:*|alt_mge_phy_usxg32_rx_rm_fifo:*|alt_mge_phy_async_fifo_fpga:async_fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated  rdptr_g            alt_mge_phy_usxg32_pcs:*|alt_mge_phy_usxg32_rx_rm_fifo:*|alt_mge_phy_async_fifo_fpga:async_fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated|alt_synch_pipe_*:*|*  *dffe*  2.5ns  2.1ns

# Reset
set_false_path -from [get_registers -nowarn *alt_mge_phy_pcs:*|alt_mge16_pcs_reset_synchronizer:*|alt_mge16_pcs_reset_synchronizer_chain_out] -to [get_pins -compatibility_mode -nocase *alt_mge_phy_usxg32_pcs:*|alt_mge_phy_usxg32_tx_clockcomp_fifo:*|alt_mge_phy_async_fifo_fpga:*|dcfifo:dcfifo_componenet|*rdaclr*|clrn]
set_false_path -from [get_registers -nowarn *alt_mge_phy_pcs:*|alt_mge16_pcs_reset_synchronizer:*|alt_mge16_pcs_reset_synchronizer_chain_out] -to [get_pins -compatibility_mode -nocase *alt_mge_phy_usxg32_pcs:*|alt_mge_phy_usxg32_tx_clockcomp_fifo:*|alt_mge_phy_async_fifo_fpga:*|dcfifo:dcfifo_componenet|*wraclr*|clrn]
set_false_path -from [get_registers -nowarn *alt_mge_phy_pcs:*|alt_mge16_pcs_reset_synchronizer:*|alt_mge16_pcs_reset_synchronizer_chain_out] -to [get_pins -compatibility_mode -nocase *alt_mge_phy_usxg32_pcs:*|alt_mge_phy_usxg32_rx_rm_fifo:*|alt_mge_phy_async_fifo_fpga:*|dcfifo:dcfifo_componenet|*rdaclr*|clrn]
set_false_path -from [get_registers -nowarn *alt_mge_phy_pcs:*|alt_mge16_pcs_reset_synchronizer:*|alt_mge16_pcs_reset_synchronizer_chain_out] -to [get_pins -compatibility_mode -nocase *alt_mge_phy_usxg32_pcs:*|alt_mge_phy_usxg32_rx_rm_fifo:*|alt_mge_phy_async_fifo_fpga:*|dcfifo:dcfifo_componenet|*wraclr*|clrn]
set_false_path -from [get_registers -nowarn *alt_mge_phy_pcs:*|alt_mge_phy_usxg32_rx_rm_fifo:*|cur_data_in[36]] -to [get_pins -compatibility_mode -nocase *alt_mge_phy_usxg32_pcs:*|alt_mge_phy_usxg32_rx_rm_fifo:*|alt_mge_phy_async_fifo_fpga:*|dcfifo:dcfifo_componenet|*wraclr*|clrn]
set_false_path -from [get_registers -nowarn *alt_mge_phy_pcs:*|alt_mge_phy_usxg32_rx_rm_fifo:*|cur_data_in[36]] -to [get_pins -compatibility_mode -nocase *alt_mge_phy_usxg32_pcs:*|alt_mge_phy_usxg32_rx_rm_fifo:*|alt_mge_phy_async_fifo_fpga:*|dcfifo:dcfifo_componenet|*rdaclr*|clrn]
set_false_path -from [get_registers -nowarn *alt_mge_phy_pcs:*|alt_mge_phy_usxg32_rx_rm_fifo:*|alt_mge16_pcs_std_synchronizer:bitsync_block_lock|altera_std_synchronizer_nocut:*|dreg[0]] -to [get_pins -compatibility_mode -nocase *alt_mge_phy_usxg32_pcs:*|alt_mge_phy_usxg32_rx_rm_fifo:*|alt_mge_phy_async_fifo_fpga:*|dcfifo:dcfifo_componenet|*wraclr*|clrn]
set_false_path -from [get_registers -nowarn *alt_mge_phy_pcs:*|alt_mge_phy_usxg32_rx_rm_fifo:*|alt_mge16_pcs_std_synchronizer:bitsync_block_lock|altera_std_synchronizer_nocut:*|dreg[0]] -to [get_pins -compatibility_mode -nocase *alt_mge_phy_usxg32_pcs:*|alt_mge_phy_usxg32_rx_rm_fifo:*|alt_mge_phy_async_fifo_fpga:*|dcfifo:dcfifo_componenet|*rdaclr*|clrn]

# Operating Speed
set_false_path -from [get_registers {*alt_mge_phy_usxg32_pcs:*|alt_mge_phy_usxg32_an_top:*|an_done}] -to [get_registers {*alt_mge_phy_usxg32_pcs:*|operating_speed*}]
set_false_path -from [get_registers {*alt_mge_phy_usxg32_pcs:*|alt_mge_phy_usxg32_an_top:*|lp_ability*}] -to [get_registers {*alt_mge_phy_usxg32_pcs:*|operating_speed*}]
set_false_path -from [get_registers {*alt_mge_phy_usxg32_pcs:*|operating_speed*}] -to [get_registers {*alt_mge_phy_usxg32_rx_top:*|*}]

#**************************************************************
# Set False Path for alt_mge16_pcs_reset_synchronizer
#**************************************************************
set reset_sync_aclr_counter 0
set reset_sync_clrn_counter 0
set reset_sync_aclr_collection [get_pins -compatibility_mode -nocase -nowarn *|alt_mge16_pcs_reset_synchronizer:*|alt_mge16_pcs_reset_synchronizer_chain*|aclr]
set reset_sync_clrn_collection [get_pins -compatibility_mode -nocase -nowarn *|alt_mge16_pcs_reset_synchronizer:*|alt_mge16_pcs_reset_synchronizer_chain*|clrn]

foreach_in_collection reset_sync_aclr_pin $reset_sync_aclr_collection {
    set reset_sync_aclr_counter [expr $reset_sync_aclr_counter + 1]
}

foreach_in_collection reset_sync_clrn_pin $reset_sync_clrn_collection {
    set reset_sync_clrn_counter [expr $reset_sync_clrn_counter + 1]
}

if {$reset_sync_aclr_counter > 0} {
    set_false_path -to [get_pins -compatibility_mode -nocase *|alt_mge16_pcs_reset_synchronizer:*|alt_mge16_pcs_reset_synchronizer_chain*|aclr]
}

if {$reset_sync_clrn_counter > 0} {
    set_false_path -to [get_pins -compatibility_mode -nocase *|alt_mge16_pcs_reset_synchronizer:*|alt_mge16_pcs_reset_synchronizer_chain*|clrn]
}

set_project_mode -always_show_entity_name $old_mode
