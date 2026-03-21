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

#SDC false path for altera_eth_1588_tod_synchronizer

# Function to constraint pointers
proc altera_tod_sync_constraint_ptr {from_path from_reg to_path to_reg max_skew max_net_delay} {
   
   set_net_delay -from [get_registers *${from_path}*${from_reg}*] -to [get_registers *${to_path}*${to_reg}*] -max $max_net_delay
   
   if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
      # Check for instances
      set inst [get_registers -nowarn *${from_path}*${from_reg}*]

      # Constraint one instance at a time to avoid set_max_skew apply to all instances
      foreach_in_collection each_inst_tmp $inst {
         set each_inst [get_node_info -name $each_inst_tmp] 
         # Get the path to instance
         regexp "(.*${from_path})(.*)(${from_reg})" $each_inst reg_path inst_path inst_name reg_name
         set_max_skew -from [get_registers ${inst_path}${inst_name}${from_reg}[*]] -to [get_registers *${to_path}*${to_reg}*] $max_skew
         
         set_max_delay -from [get_registers ${inst_path}${inst_name}${from_reg}[*]] -to [get_registers *${to_path}*${to_reg}*] 100ns
         set_min_delay -from [get_registers ${inst_path}${inst_name}${from_reg}[*]] -to [get_registers *${to_path}*${to_reg}*] -100ns
      }
      
   } else {
      # Relax the fitter effort
      set_max_delay -from [get_registers *${from_path}*${from_reg}*] -to [get_registers *${to_path}*${to_reg}*] 100ns
      set_min_delay -from [get_registers *${from_path}*${from_reg}*] -to [get_registers *${to_path}*${to_reg}*] -100ns
   }
   
}

set sampling_clk_aclr_counter 0
set sampling_clk_clrn_counter 0
set sampling_clk_0_aclr_counter 0
set sampling_clk_0_clrn_counter 0
set tod_master_valid_0_d_counter 0
set tod_master_valid_0_asdata_counter 0
set reset_master_0_d_counter 0
set reset_master_0_asdata_counter 0
set sampling_clk_aclr_collection [get_pins -compatibility_mode -nowarn *altera_eth_1588_tod_synchronizer*reset_sampling_clk*|aclr]
set sampling_clk_clrn_collection [get_pins -compatibility_mode -nowarn *altera_eth_1588_tod_synchronizer*reset_sampling_clk*|clrn]
set sampling_clk_0_aclr_collection [get_pins -compatibility_mode -nowarn *altera_eth_1588_tod_synchronizer*reset_sampling_clk_0*|aclr]
set sampling_clk_0_clrn_collection [get_pins -compatibility_mode -nowarn *altera_eth_1588_tod_synchronizer*reset_sampling_clk_0*|clrn]
set tod_master_valid_0_d_collection [get_pins -compatibility_mode -nowarn *altera_eth_1588_tod_synchronizer*tod_master_valid_synchronizer*din_s1*|d]
set tod_master_valid_0_asdata_collection [get_pins -compatibility_mode -nowarn *altera_eth_1588_tod_synchronizer*tod_master_valid_synchronizer*din_s1*|asdata]
set reset_master_0_d_collection [get_pins -compatibility_mode -nowarn *altera_eth_1588_tod_synchronizer*reset_master_synchronizer*din_s1*|d]
set reset_master_0_asdata_collection [get_pins -compatibility_mode -nowarn *altera_eth_1588_tod_synchronizer*reset_master_synchronizer*din_s1*|asdata]

foreach_in_collection sampling_clk_aclr_pin $sampling_clk_aclr_collection {
    set sampling_clk_aclr_counter [expr $sampling_clk_aclr_counter + 1]
}
foreach_in_collection sampling_clk_clrn_pin $sampling_clk_clrn_collection {
    set sampling_clk_clrn_counter [expr $sampling_clk_clrn_counter + 1]
}
foreach_in_collection sampling_clk_0_aclr_pin $sampling_clk_0_aclr_collection {
    set sampling_clk_0_aclr_counter [expr $sampling_clk_0_aclr_counter + 1]
}
foreach_in_collection sampling_clk_0_clrn_pin $sampling_clk_0_clrn_collection {
    set sampling_clk_0_clrn_counter [expr $sampling_clk_0_clrn_counter + 1]
}
foreach_in_collection tod_master_valid_0_d_pin $tod_master_valid_0_d_collection {
    set tod_master_valid_0_d_counter [expr $tod_master_valid_0_d_counter + 1]
}
foreach_in_collection tod_master_valid_0_asdata_pin $tod_master_valid_0_asdata_collection {
    set tod_master_valid_0_asdata_counter [expr $tod_master_valid_0_asdata_counter + 1]
}
foreach_in_collection reset_master_0_d_pin $reset_master_0_d_collection {
    set reset_master_0_d_counter [expr $reset_master_0_d_counter + 1]
}
foreach_in_collection reset_master_0_asdata_pin $reset_master_0_asdata_collection {
    set reset_master_0_asdata_counter [expr $reset_master_0_asdata_counter + 1]
}

if {$sampling_clk_aclr_counter > 0} {set_false_path -to [get_pins -compatibility_mode -nowarn *altera_eth_1588_tod_synchronizer*reset_sampling_clk*|aclr]}
if {$sampling_clk_clrn_counter > 0} {set_false_path -to [get_pins -compatibility_mode -nowarn *altera_eth_1588_tod_synchronizer*reset_sampling_clk*|clrn]}
if {$sampling_clk_0_aclr_counter > 0} {set_false_path -to [get_pins -compatibility_mode -nowarn *altera_eth_1588_tod_synchronizer*reset_sampling_clk_0*|aclr]}
if {$sampling_clk_0_clrn_counter > 0} {set_false_path -to [get_pins -compatibility_mode -nowarn *altera_eth_1588_tod_synchronizer*reset_sampling_clk_0*|clrn]}
set_false_path -from [get_registers *altera_eth_1588_tod_synchronizer*write_en*] -to [get_registers *altera_eth_1588_tod_synchronizer*write_en_1_synchronizer*din_s1*]
set_false_path -from [get_registers *altera_eth_1588_tod_synchronizer*write_en*] -to [get_registers *altera_eth_1588_tod_synchronizer*write_en_synchronizer*din_s1*]
set_false_path -from [get_registers *altera_eth_1588_tod_synchronizer*read_en*] -to [get_registers *altera_eth_1588_tod_synchronizer*read_en_synchronizer*din_s1*]
if {$tod_master_valid_0_d_counter > 0} {set_false_path -to [get_pins -compatibility_mode -nowarn *altera_eth_1588_tod_synchronizer*tod_master_valid_synchronizer*din_s1*|d]}
if {$tod_master_valid_0_asdata_counter > 0} {set_false_path -to [get_pins -compatibility_mode -nowarn *altera_eth_1588_tod_synchronizer*tod_master_valid_synchronizer*din_s1*|asdata]}
if {$reset_master_0_d_counter > 0} {set_false_path -to [get_pins -compatibility_mode -nowarn *altera_eth_1588_tod_synchronizer*reset_master_synchronizer*din_s1*|d]}
if {$reset_master_0_asdata_counter > 0} {set_false_path -to [get_pins -compatibility_mode -nowarn *altera_eth_1588_tod_synchronizer*reset_master_synchronizer*din_s1*|asdata]}
set_false_path -from [get_registers *altera_eth_1588_tod_synchronizer*init_done_master*] -to [get_registers *altera_eth_1588_tod_synchronizer*init_done_master_synchronizer*din_s1*]
set_false_path -from [get_registers *altera_eth_1588_tod_synchronizer*start_count*] -to [get_registers *altera_eth_1588_tod_synchronizer*start_count_synchronizer*din_s1*] 
set_false_path -from [get_registers *altera_eth_1588_tod_synchronizer*stop_count*] -to [get_registers *altera_eth_1588_tod_synchronizer*stop_count_synchronizer*din_s1*]
set_false_path -from [get_registers *altera_eth_1588_tod_synchronizer*init_count*] -to [get_registers *altera_eth_1588_tod_synchronizer*init_count_synchronizer*din_s1*]
  
#SDC false path for altera_eth_1588_tod_synchronizer_clock_crosser
#set_false_path -from [get_registers *altera_eth_1588_tod_synchronizer_clock_crosser:*|in_data_buffer*] -to [get_registers *altera_eth_1588_tod_synchronizer_clock_crosser:*|out_data_buffer*] 
set_false_path -from [get_registers *altera_eth_1588_tod_synchronizer_clock_crosser*in_data_toggle*] -to [get_registers *altera_eth_1588_tod_synchronizer_clock_crosser*in_to_out_synchronizer*din_s1*]
set_false_path -from [get_registers *altera_eth_1588_tod_synchronizer_clock_crosser*out_data_toggle_flopped*] -to [get_registers *altera_eth_1588_tod_synchronizer_clock_crosser*out_to_in_synchronizer*din_s1*]
set_max_delay -from [get_registers *altera_eth_1588_tod_synchronizer_clock_crosser:*|in_data_buffer*] -to [get_registers *altera_eth_1588_tod_synchronizer_clock_crosser:*|out_data_buffer*] 100ns
set_min_delay -from [get_registers *altera_eth_1588_tod_synchronizer_clock_crosser:*|in_data_buffer*] -to [get_registers *altera_eth_1588_tod_synchronizer_clock_crosser:*|out_data_buffer*] -100ns
set_net_delay -from [get_registers *altera_eth_1588_tod_synchronizer_clock_crosser:*|in_data_buffer*] -to [get_registers *altera_eth_1588_tod_synchronizer_clock_crosser:*|out_data_buffer*] -max 5ns

#SDC false path for DC FIFO 
#set_false_path -from [get_registers *altera_eth_1588_tod_synchronizer*g_out*] -to [get_registers *altera_eth_1588_tod_synchronizer*sample_wr_g_ptr_0*]
#set_false_path -from [get_registers *altera_eth_1588_tod_synchronizer*g_out*] -to [get_registers *altera_eth_1588_tod_synchronizer*sample_rd_g_ptr_0*]
#set_false_path -from [get_registers *altera_eth_1588_tod_synchronizer*g_out*] -to [get_registers *altera_eth_1588_tod_synchronizer*rd_g_wptr*] 
#set_false_path -from [get_registers *altera_eth_1588_tod_synchronizer*g_out*] -to [get_registers *altera_eth_1588_tod_synchronizer*wr_g_rptr*]
altera_tod_sync_constraint_ptr  altera_eth_1588_tod_synchronizer_gray_cnt:U_WRT  g_out  sample_wr_g_ptr_synchronizer  din_s1  2.5ns  2.5ns
altera_tod_sync_constraint_ptr  altera_eth_1588_tod_synchronizer_gray_cnt:U_RD  g_out  sample_rd_g_ptr_synchronizer  din_s1  2.5ns  2.5ns
altera_tod_sync_constraint_ptr  altera_eth_1588_tod_synchronizer_gray_cnt:U_RD  g_out  g_ptr_rd_to_wr_synchronizer  din_s1  2.5ns  2.5ns
altera_tod_sync_constraint_ptr  altera_eth_1588_tod_synchronizer_gray_cnt:U_WRT  g_out  g_ptr_wr_to_rd_synchronizer  din_s1  2.5ns  2.5ns

set_project_mode -always_show_entity_name $old_mode
