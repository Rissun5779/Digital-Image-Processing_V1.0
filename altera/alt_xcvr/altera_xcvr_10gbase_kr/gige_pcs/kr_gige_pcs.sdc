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
proc kr_gige_pcs_constraint_net_delay {from_reg to_reg max_net_delay {check_exist 0}} {
    
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
proc kr_gige_pcs_constraint_std_sync {} {
   
    kr_gige_pcs_constraint_net_delay  *  *kr_gige_pcs*|kr_gige_pcs_std_synchronizer:*|altera_std_synchronizer_nocut:*|din_s1  6ns 
   
}

# Function to constraint pointers
proc kr_gige_pcs_constraint_ptr {from_path from_reg to_path to_reg max_skew max_net_delay} {
    
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
proc kr_gige_pcs_constraint_clock_crosser {} {
    set module_name kr_gige_pcs_clock_crosser
    
    set from_reg1 in_data_toggle
    set to_reg1 kr_gige_pcs_std_synchronizer:in_to_out_synchronizer|altera_std_synchronizer_nocut:std_sync_no_cut|din_s1

    set from_reg2 in_data_buffer
    set to_reg2 out_data_buffer
    
    set from_reg3 out_data_toggle_flopped
    set to_reg3 kr_gige_pcs_std_synchronizer:out_to_in_synchronizer|altera_std_synchronizer_nocut:std_sync_no_cut|din_s1
    
    set max_skew 7.5ns
    
    set max_delay1 6ns
    set max_delay2 4ns
    set max_delay3 6ns
    
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

# Standard Synchronizer
kr_gige_pcs_constraint_std_sync

# FIFO
kr_gige_pcs_constraint_ptr  kr_gige_pcs_a_fifo_24:*|kr_gige_pcs_gray_cnt:U_RD  g_out  kr_gige_pcs_a_fifo_24:*kr_gige_pcs_std_synchronizer*  din_s1  7.5ns  6ns
kr_gige_pcs_constraint_ptr  kr_gige_pcs_a_fifo_24:*|kr_gige_pcs_gray_cnt:U_WRT  g_out  kr_gige_pcs_a_fifo_24:*kr_gige_pcs_std_synchronizer*  din_s1  7.5ns  6ns

# Clock Crosser
kr_gige_pcs_constraint_clock_crosser

# PCS Internal
kr_gige_pcs_constraint_net_delay  *kr_gige_pcs_mdio_reg:*|dev_ability*  *kr_gige_pcs_top_autoneg:*|*  6ns 1
kr_gige_pcs_constraint_net_delay  *kr_gige_pcs_mdio_reg:*|link_timer_reg*  *kr_gige_pcs_top_autoneg:*|*  6ns 1
kr_gige_pcs_constraint_net_delay  *kr_gige_pcs_rx_encapsulation_strx_gx:*|gmii_dv*  *kr_gige_pcs_rx_fifo_rd:*|pcs_dv_macclk*  6ns 

# GIGE PCS Internal - mdio related
set_false_path -from [get_registers *|kr_gige_pcs_top:*|kr_gige_pcs_mdio_reg:U_REG|partner_ability\[*\]*] -to [get_registers *|kr_gige_pcs_top:*|kr_gige_pcs_mdio_reg:U_REG|sgmii_speed\[*\]*]
set_false_path -from [get_registers *|kr_gige_pcs_top:*|kr_gige_pcs_mdio_reg:U_REG|sgmii_speed\[*\]*] -to [get_registers *|kr_gige_pcs_top:*|kr_gige_pcs_top_tx_converter:U_TXCV|kr_gige_pcs_tx_converter:U_TXCV|eth_speed_reg1\[*\]*]
 
set_false_path -to [get_registers *|kr_gige_pcs_top:*|kr_gige_pcs_mdio_reg:U_REG|link_status_reg1]
# AN-CL37 related false paths
set regs [get_registers -nowarn *|kr_gige_pcs_top:*|kr_gige_pcs_top_pcs_strx_gx:U_PCS|kr_gige_pcs_top_autoneg:U_AUTONEG*]
if {[llength [query_collection -report -all $regs]] > 0} {
  set_false_path -to [get_registers *|kr_gige_pcs_top:*|kr_gige_pcs_mdio_reg:U_REG|an_done_reg1]
  set_false_path -to [get_registers *|kr_gige_pcs_top:*|kr_gige_pcs_mdio_reg:U_REG|an_ack_reg1]
  set_false_path -to [get_registers *|kr_gige_pcs_top:*|kr_gige_pcs_mdio_reg:U_REG|page_rcv_l_reg1]
  set_false_path -to [get_registers *|kr_gige_pcs_top:*|kr_gige_pcs_mdio_reg:U_REG|an_restart_rst_reg1]
  set_false_path -from [get_registers *|kr_gige_pcs_top:*|kr_gige_pcs_mdio_reg:U_REG|if_mode\[*\]*] -to [get_registers *|kr_gige_pcs_top:*|kr_gige_pcs_top_pcs_strx_gx:U_PCS|kr_gige_pcs_top_autoneg:U_AUTONEG|an_ability_out\[*\]*]
}
 
kr_gige_pcs_constraint_net_delay *|kr_gige_pcs_top:*|kr_gige_pcs_mdio_reg:U_REG|page_rcv_l_reg2 *|kr_gige_pcs_top:*|kr_gige_pcs_mdio_reg:U_REG|page_rcv_rxck_reg1 6ns 1


set regs [get_registers -nowarn *kr_gige_pcs_ph_calculator*sync_wr_ptr[2]*]
if {[llength [query_collection -report -all $regs]] > 0} {
  kr_gige_pcs_constraint_ptr  kr_gige_pcs_ph_calculator:phase_calculator.ph_cal_inst  wr_ptr_sample  kr_gige_pcs_ph_calculator:phase_calculator.ph_cal_inst*kr_gige_pcs_std_synchronizer*  din_s1  4.5ns  3ns
}

set regs [get_registers -nowarn *kr_gige_pcs_ph_calculator*sync_rd_ptr[2]*]
if {[llength [query_collection -report -all $regs]] > 0} {
  kr_gige_pcs_constraint_ptr  kr_gige_pcs_ph_calculator:phase_calculator.ph_cal_inst  rd_ptr_sample  kr_gige_pcs_ph_calculator:phase_calculator.ph_cal_inst*kr_gige_pcs_std_synchronizer*  din_s1  4.5ns  3ns
}

set_project_mode -always_show_entity_name $old_mode
