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
proc alt_mge_phy_xgmii_pcs_constraint_net_delay {from_reg to_reg max_net_delay {check_exist 0}} {
    
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
proc alt_mge_phy_xgmii_pcs_constraint_std_sync {} {
   
    alt_mge_phy_xgmii_pcs_constraint_net_delay  *  *alt_mge_phy_xgmii_pcs:*|alt_mge16_pcs_std_synchronizer:*|altera_std_synchronizer_nocut:*|din_s1  2.2ns
   
}

# Function to constraint pointers
proc alt_mge_phy_xgmii_pcs_constraint_ptr {from_path from_reg to_path to_reg max_skew max_net_delay} {
    
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

# Standard Synchronizer
alt_mge_phy_xgmii_pcs_constraint_std_sync

# DCFIFO
alt_mge_phy_xgmii_pcs_constraint_ptr  alt_mge_phy_xgmii_soft_fifo:*|alt_mge_phy_xgmii_clockcomp:tx_phasecomp|alt_mge_phy_async_fifo_fpga:async_fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated  delayed_wrptr_g  alt_mge_phy_xgmii_soft_fifo:*|alt_mge_phy_xgmii_clockcomp:tx_phasecomp|alt_mge_phy_async_fifo_fpga:async_fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated|alt_synch_pipe_*:*|*  *dffe*  5.4ns  5ns
alt_mge_phy_xgmii_pcs_constraint_ptr  alt_mge_phy_xgmii_soft_fifo:*|alt_mge_phy_xgmii_clockcomp:tx_phasecomp|alt_mge_phy_async_fifo_fpga:async_fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated  rdptr_g          alt_mge_phy_xgmii_soft_fifo:*|alt_mge_phy_xgmii_clockcomp:tx_phasecomp|alt_mge_phy_async_fifo_fpga:async_fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated|alt_synch_pipe_*:*|*  *dffe*  2.5ns  2.1ns
alt_mge_phy_xgmii_pcs_constraint_ptr  alt_mge_phy_xgmii_soft_fifo:*|alt_mge_phy_xgmii_rx_fifo:rx_clockcomp|alt_mge_phy_async_fifo_fpga:async_fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated  delayed_wrptr_g    alt_mge_phy_xgmii_soft_fifo:*|alt_mge_phy_xgmii_rx_fifo:rx_clockcomp|alt_mge_phy_async_fifo_fpga:async_fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated|alt_synch_pipe_*:*|*  *dffe*  2.5ns  2.1ns
alt_mge_phy_xgmii_pcs_constraint_ptr  alt_mge_phy_xgmii_soft_fifo:*|alt_mge_phy_xgmii_rx_fifo:rx_clockcomp|alt_mge_phy_async_fifo_fpga:async_fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated  rdptr_g            alt_mge_phy_xgmii_soft_fifo:*|alt_mge_phy_xgmii_rx_fifo:rx_clockcomp|alt_mge_phy_async_fifo_fpga:async_fifo|dcfifo:dcfifo_componenet|dcfifo_*:auto_generated|alt_synch_pipe_*:*|*  *dffe*  5.4ns  5ns

# Reset
set_false_path -from [get_registers -nowarn *alt_mge_phy_pcs:*|alt_mge16_pcs_reset_synchronizer:*|alt_mge16_pcs_reset_synchronizer_chain_out] -to [get_pins -compatibility_mode -nocase *alt_mge_phy_xgmii_soft_fifo:*|alt_mge_phy_xgmii_clockcomp:*|alt_mge_phy_async_fifo_fpga:*|dcfifo:dcfifo_componenet|*rdaclr*|clrn]
set_false_path -from [get_registers -nowarn *alt_mge_phy_pcs:*|alt_mge16_pcs_reset_synchronizer:*|alt_mge16_pcs_reset_synchronizer_chain_out] -to [get_pins -compatibility_mode -nocase *alt_mge_phy_xgmii_soft_fifo:*|alt_mge_phy_xgmii_clockcomp:*|alt_mge_phy_async_fifo_fpga:*|dcfifo:dcfifo_componenet|*wraclr*|clrn]
set_false_path -from [get_registers -nowarn *alt_mge_phy_pcs:*|alt_mge16_pcs_reset_synchronizer:*|alt_mge16_pcs_reset_synchronizer_chain_out] -to [get_pins -compatibility_mode -nocase *alt_mge_phy_xgmii_soft_fifo:*|alt_mge_phy_xgmii_rx_fifo:*|alt_mge_phy_async_fifo_fpga:*|dcfifo:dcfifo_componenet|*rdaclr*|clrn]
set_false_path -from [get_registers -nowarn *alt_mge_phy_pcs:*|alt_mge16_pcs_reset_synchronizer:*|alt_mge16_pcs_reset_synchronizer_chain_out] -to [get_pins -compatibility_mode -nocase *alt_mge_phy_xgmii_soft_fifo:*|alt_mge_phy_xgmii_rx_fifo:*|alt_mge_phy_async_fifo_fpga:*|dcfifo:dcfifo_componenet|*wraclr*|clrn]
set_false_path -from [get_registers -nowarn *alt_mge_phy_xgmii_soft_fifo:*|alt_mge_phy_xgmii_rx_fifo:rx_clockcomp|cur_data_in[73]] -to [get_pins -compatibility_mode -nocase *alt_mge_phy_xgmii_soft_fifo:*|alt_mge_phy_xgmii_rx_fifo:*|alt_mge_phy_async_fifo_fpga:*|dcfifo:dcfifo_componenet|*rdaclr*|clrn]
set_false_path -from [get_registers -nowarn *alt_mge_phy_xgmii_soft_fifo:*|alt_mge_phy_xgmii_rx_fifo:rx_clockcomp|alt_mge16_pcs_std_synchronizer:bitsync_block_lock|altera_std_synchronizer_nocut:*|dreg[0]] -to [get_pins -compatibility_mode -nocase *alt_mge_phy_xgmii_soft_fifo:*|alt_mge_phy_xgmii_rx_fifo:*|alt_mge_phy_async_fifo_fpga:*|dcfifo:dcfifo_componenet|*wraclr*|clrn]

# Data Path Selection
set_false_path -to [get_registers -nowarn *alt_mge16_phy_xcvr_term:*|baser_path_ena]
set_false_path -from [get_registers -nowarn *alt_mge16_phy_xcvr_term:*|baser_path_ena]

set_project_mode -always_show_entity_name $old_mode
