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


# The timing constraints file

# quartus_pro - preserve same hierarchy name as quartus standard
set old_mode [set_project_mode -get_mode_value always_show_entity_name] 
set_project_mode -always_show_entity_name on

#one way clock crosser
# delay is derived based on worst case period clk 390 MHz (period 2.5ns)*0.8 *N
# sync stage is 3+1, therefore N=2 clk cycles of delay is allowed
set net_delay 4ns
set max_delay 5ns
set max_skew 4ns
set module_name altera_eth_1588_tod_clock_crosser
set from_reg1 in_data_toggle
set to_reg1 altera_std_synchronizer_nocut:*|din_s1
set from_reg2 in_data_buffer[*]
set to_reg2 *out_data_buffer*
set from_reg3 out_data_toggle_flopped
set to_reg3 altera_std_synchronizer_nocut:*|din_s1

if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
        # Check for instances
        set inst [get_registers -nowarn *${module_name}:*|${from_reg1}]
        # Constraint one instance at a time to avoid set_max_skew apply to all instances
        foreach_in_collection each_inst_tmp $inst {
            set each_inst [get_node_info -name $each_inst_tmp] 
            # Get the path to instance
            regexp "(.*${module_name})(.*)(${from_reg1})" $each_inst reg_path inst_path inst_name reg_name
            set_max_skew -from [get_registers "${inst_path}${inst_name}${from_reg1} ${inst_path}${inst_name}${from_reg2}"] -to [get_registers "${inst_path}${inst_name}${to_reg1} ${inst_path}${inst_name}${to_reg2}"] $max_skew
        }
      
        set_max_delay -from [get_registers *${module_name}:*|${from_reg1}] -to [get_registers *${module_name}:*|${to_reg1}] 100ns
        set_min_delay -from [get_registers *${module_name}:*|${from_reg1}] -to [get_registers *${module_name}:*|${to_reg1}] -100ns
        set_max_delay -from [get_registers *${module_name}:*|${from_reg2}] -to [get_registers *${module_name}:*|${to_reg2}] 100ns
        set_min_delay -from [get_registers *${module_name}:*|${from_reg2}] -to [get_registers *${module_name}:*|${to_reg2}] -100ns
        set_max_delay -from [get_registers *${module_name}:*|${from_reg3}] -to [get_registers *${module_name}:*|${to_reg3}] 100ns
        set_min_delay -from [get_registers *${module_name}:*|${from_reg3}] -to [get_registers *${module_name}:*|${to_reg3}] -100ns
} else {
    set_net_delay -from [get_registers *${module_name}:*|${from_reg1}] -to [get_registers *${module_name}:*|${to_reg1}] -max ${net_delay}
    set_net_delay -from [get_registers *${module_name}:*|${from_reg2}] -to [get_registers *${module_name}:*|${to_reg2}] -max ${net_delay}
    set_net_delay -from [get_registers *${module_name}:*|${from_reg3}] -to [get_registers *${module_name}:*|${to_reg3}] -max ${net_delay}
    
   # Relax the fitter effort
    set_max_delay -from [get_registers *${module_name}:*|${from_reg1}] -to [get_registers *${module_name}:*|${to_reg1}] ${max_delay}
    set_min_delay -from [get_registers *${module_name}:*|${from_reg1}] -to [get_registers *${module_name}:*|${to_reg1}] -100ns
    set_max_delay -from [get_registers *${module_name}:*|${from_reg2}] -to [get_registers *${module_name}:*|${to_reg2}] ${max_delay}
    set_min_delay -from [get_registers *${module_name}:*|${from_reg2}] -to [get_registers *${module_name}:*|${to_reg2}] -100ns
    set_max_delay -from [get_registers *${module_name}:*|${from_reg3}] -to [get_registers *${module_name}:*|${to_reg3}] ${max_delay}
    set_min_delay -from [get_registers *${module_name}:*|${from_reg3}] -to [get_registers *${module_name}:*|${to_reg3}] -100ns
}

#synchronizer
set synchronizer_name ${module_name}:*|altera_std_synchronizer_nocut

if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
    set_max_delay -from [get_registers *] -to [get_registers *${synchronizer_name}:*|din_s1] 100ns
    set_min_delay -from [get_registers *] -to [get_registers *${synchronizer_name}:*|din_s1] -100ns
} else {
    set_net_delay -from [get_pins -compatibility_mode *|q] -to [get_registers *${synchronizer_name}:*|din_s1] -max ${net_delay}
    set_max_delay -from [get_registers *] -to [get_registers *${synchronizer_name}:*|din_s1] ${max_delay}
    set_min_delay -from [get_registers *] -to [get_registers *${synchronizer_name}:*|din_s1] -100ns
}

# quartus_pro - preserve same hierarchy name as quartus standard
set_project_mode -always_show_entity_name $old_mode