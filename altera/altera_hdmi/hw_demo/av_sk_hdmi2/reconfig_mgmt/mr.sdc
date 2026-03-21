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


#
# Cut the unnecessary timing paths in the DCFIFO 
#
set_false_path -to [get_pins -nocase -compatibility_mode *|dcfifo*wraclr|dff*|clrn]
set_false_path -to [get_pins -nocase -compatibility_mode *|dcfifo*rdaclr|dff*|clrn]

#
# Cut the reset path to all the reset synchronizers at the top level
#
set tx_clk0_rst_sync_collection [get_pins -nowarn -nocase -compatibility_mode *tx_clk0_rst_sync*|clrn]
foreach_in_collection pin $tx_clk0_rst_sync_collection {
   set_false_path -to [get_pins -nocase -compatibility_mode *tx_clk0_rst_sync*|clrn]
}

set rx_clk_rst_sync_collection [get_pins -nowarn -nocase -compatibility_mode *rx_clk_rst_sync*|clrn]
foreach_in_collection pin $rx_clk_rst_sync_collection {
   set_false_path -to [get_pins -nocase -compatibility_mode *rx_clk_rst_sync*|clrn]
}

set ls_clk_rst_sync_collection [get_pins -nowarn -nocase -compatibility_mode *ls_clk_rst_sync*|clrn]
foreach_in_collection pin $ls_clk_rst_sync_collection {
   set_false_path -to [get_pins -nocase -compatibility_mode *ls_clk_rst_sync*|clrn]
}

#
# Cut the pseudostatic control/status signals
#
set_false_path -from [get_keepers {*mr_reconfig_mgmt*set_locktoref*}]
# bitec rx locked signal
# set_false_path -from [get_keepers {*bitec_hdmi_clock_crossing*data_out_sync1*}] 
set_false_path -from [get_keepers {*mr_reconfig_fsm*enable}]
set_false_path -from [get_keepers {*mr_rate_detect*count_refclock[*]}] -to [get_keepers {*mr_rate_detect*refclock_measure_min2[*]}]
set_false_path -from [get_keepers {*mr_rate_detect*gate}] -to [get_keepers {*mr_rate_detect*gate_min2}]
set_false_path -from [get_keepers {*mr_rate_detect*capture}] -to [get_keepers {*mr_rate_detect*capture_d}]
set_false_path -from [get_keepers {*mr_rate_detect*sig_o_reg}] -to [get_keepers {*mr_rate_detect*sig_o_d}]


## *********************************************************************
## Constrain all used DCFIFO at top level, instance by instance
## *********************************************************************
# constraints for DCFIFO sdc
#
# top-level sdc
# convention for module sdc apply_sdc_<module_name>
#
proc apply_sdc_dcfifo {hier_path} {
# gray_rdptr
apply_sdc_dcfifo_rdptr $hier_path
# gray_wrptr
apply_sdc_dcfifo_wrptr $hier_path
}
#
# common constraint setting proc
#
proc apply_sdc_dcfifo_for_ptrs {from_node_list to_node_list} {
# control skew for bits
set_max_skew -from $from_node_list -to $to_node_list -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.8
# path delay (exception for net delay)
if { ![string equal "quartus_syn" $::TimeQuestInfo(nameofexecutable)] } {
set_net_delay -from $from_node_list -to $to_node_list -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8
}
#relax setup and hold calculation
set_max_delay -from $from_node_list -to $to_node_list 100
set_min_delay -from $from_node_list -to $to_node_list -100
}
#
# mstable propgation delay
#
proc apply_sdc_dcfifo_mstable_delay {from_node_list to_node_list} {
# mstable delay
if { ![string equal "quartus_syn" $::TimeQuestInfo(nameofexecutable)] } {
set_net_delay -from $from_node_list -to $to_node_list -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8
}
}
#
# rdptr constraints
#
proc apply_sdc_dcfifo_rdptr {hier_path} {
# get from and to list
set from_node_list [get_keepers $hier_path|auto_generated|*rdptr_g*]
set to_node_list [get_keepers $hier_path|auto_generated|ws_dgrp|dffpipe*|dffe*]
apply_sdc_dcfifo_for_ptrs $from_node_list $to_node_list
# mstable
set from_node_mstable_list [get_keepers $hier_path|auto_generated|ws_dgrp|dffpipe*|dffe*]
set to_node_mstable_list [get_keepers $hier_path|auto_generated|ws_dgrp|dffpipe*|dffe*]
apply_sdc_dcfifo_mstable_delay $from_node_mstable_list $to_node_mstable_list
}
#
# wrptr constraints
#
proc apply_sdc_dcfifo_wrptr {hier_path} {
# control skew for bits
set from_node_list [get_keepers $hier_path|auto_generated|delayed_wrptr_g*]
set to_node_list [get_keepers $hier_path|auto_generated|rs_dgwp|dffpipe*|dffe*]
apply_sdc_dcfifo_for_ptrs $from_node_list $to_node_list
# mstable
set from_node_mstable_list [get_keepers $hier_path|auto_generated|rs_dgwp|dffpipe*|dffe*]
set to_node_mstable_list [get_keepers $hier_path|auto_generated|rs_dgwp|dffpipe*|dffe*]
apply_sdc_dcfifo_mstable_delay $from_node_mstable_list $to_node_mstable_list
}

proc apply_sdc_pre_dcfifo {entity_name top_level} {

set inst_list [get_entity_instances $entity_name]

foreach each_inst $inst_list {
  
      #puts "-- each_inst = $each_inst"
      regexp ".*${top_level}.*dcfifo_inst" "$each_inst" inst_path
      if { [info exists inst_path]  } {        
        #puts "-- inst_path = $inst_path"
        apply_sdc_dcfifo ${inst_path} 
        unset inst_path
      }
      
    }
}

apply_sdc_pre_dcfifo dcfifo u_rx_clock_sync
apply_sdc_pre_dcfifo dcfifo u_tx_clock_sync

