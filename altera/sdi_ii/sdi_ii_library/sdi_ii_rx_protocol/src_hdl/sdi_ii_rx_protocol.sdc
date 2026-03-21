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


#**************************************************************
# Set False Path
#**************************************************************

#------------------------------------------------------------------------------------------------------
# FIFOs related constraints in hd_dual_link & 3gb demux blocks
#------------------------------------------------------------------------------------------------------
set fifo_wraclr_collection [get_pins -nowarn -nocase -compatibility_mode *sdi_ii_fifo_retime*wraclr|dff*|clrn] 
foreach_in_collection pins $fifo_wraclr_collection {
   set fifo_wraclr_name [get_object_info -name $pins]
   set_false_path -to [get_pins -nocase -compatibility_mode $fifo_wraclr_name] 
}

set fifo_rdaclr_collection [get_pins -nowarn -nocase -compatibility_mode *sdi_ii_fifo_retime*rdaclr|dff*|clrn]
foreach_in_collection pins $fifo_rdaclr_collection {
   set fifo_rdaclr_name [get_object_info -name $pins]
   set_false_path -to [get_pins -nocase -compatibility_mode $fifo_rdaclr_name]
}

# constraint one instance at a time to avoid set_max_skew apply to all instances
set dlfifo_rdptr_collection [query_collection -list -all [get_keepers -nowarn *u_dual_link_sync*dcfifo*|rdptr_g\[*\]]]
foreach pin $dlfifo_rdptr_collection {
   # get the path to instance
   regexp {.*u_dual_link_sync.*dcfifo_component} "$pin" inst_path
   set_max_delay -from [get_keepers ${inst_path}*rdptr_g\[*\]] -to [get_keepers ${inst_path}*wrfull_eq*] 100
   set_min_delay -from [get_keepers ${inst_path}*rdptr_g\[*\]] -to [get_keepers ${inst_path}*wrfull_eq*] -100
   if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
     # specify one read clock (launch clock) period
     set_max_skew -from [get_keepers ${inst_path}*rdptr_g\[*\]] -to [get_keepers ${inst_path}*wrfull_eq*] 6.734
   }
}

set dlfifo_delayed_wrptr_collection [query_collection -list -all [get_keepers -nowarn *u_dual_link_sync*dcfifo*|delayed_wrptr_g\[*\]]]
foreach pin $dlfifo_delayed_wrptr_collection {
   # get the path to instance
   regexp {.*u_dual_link_sync.*dcfifo_component} "$pin" inst_path
   set_max_delay -from [get_keepers ${inst_path}*delayed_wrptr_g\[*\]] -to [get_keepers ${inst_path}*rdemp_eq*] 100
   set_min_delay -from [get_keepers ${inst_path}*delayed_wrptr_g\[*\]] -to [get_keepers ${inst_path}*rdemp_eq*] -100
   if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
     # specify one write clock (launch clock) period
       set_max_skew -from [get_keepers ${inst_path}*delayed_wrptr_g\[*\]] -to [get_keepers ${inst_path}*rdemp_eq*] 6.734
   }
}

#-----------------------------------------------------------------------------------------------------------------------------
# Set false path for first stage of synchronizer
#------------------------------------------------------------------------------------------------------------------------------
set fifo_wrfull_sync_collection [get_keepers -nowarn *u_dual_link_sync*wrfull*clk_sync\[0\]]
foreach_in_collection kpr $fifo_wrfull_sync_collection {
    set fifo_wrfull_sync_name [get_object_info -name $kpr]
    set_false_path -to [get_keepers $fifo_wrfull_sync_name]
}

#-----------------------------------------------------------------------------------------------------------------------------
# Set false path for pseudo static signals to dual_link block is different when A to B conversion is enabled.
#------------------------------------------------------------------------------------------------------------------------------
if { [llength [query_collection -report -all [get_keepers -nowarn -nocase *u_dual_link_sync|vpid_fifo_a2b.vpid_line_f*_sync[*]]]] > 0} {
    set_false_path -to [get_keepers -no_case *u_dual_link_sync|vpid_fifo_a2b.vpid_line_f*_sync[*]]
    set_false_path -from [get_keepers -nocase {*u_receive|*u_format|trs_locked}] -to [get_keepers -nocase {*u_dual_link_sync|*}]
    set_false_path -from [get_keepers -nocase {*u_rx_prealign|*u_align|align_locked}] -to [get_keepers -nocase {*u_dual_link_sync|*}]
}

#**************************************************************
# constraints for DCFIFO sdc
#**************************************************************
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
    if { ![string equal "quartus_map" $::TimeQuestInfo(nameofexecutable)] } {
        # control skew for bits
        set_max_skew -from $from_node_list -to $to_node_list -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.8
        # path delay (exception for net delay)
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
    if { ![string equal "quartus_map" $::TimeQuestInfo(nameofexecutable)] } {
        set_net_delay -from $from_node_list -to $to_node_list -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8
    }
}

#
# rdptr constraints
#
proc apply_sdc_dcfifo_rdptr {hier_path} {
    # get from and to list
    set from_node_list [get_keepers $hier_path|dcfifo_component|auto_generated|*rdptr_g*]
    set to_node_list [get_keepers $hier_path|dcfifo_component|auto_generated|ws_dgrp|dffpipe*|dffe*]
    apply_sdc_dcfifo_for_ptrs $from_node_list $to_node_list
    # mstable
    set from_node_mstable_list [get_keepers $hier_path|dcfifo_component|auto_generated|ws_dgrp|dffpipe*|dffe*]
    set to_node_mstable_list [get_keepers $hier_path|dcfifo_component|auto_generated|ws_dgrp|dffpipe*|dffe*]
    apply_sdc_dcfifo_mstable_delay $from_node_mstable_list $to_node_mstable_list
}

#
# wrptr constraints
#
proc apply_sdc_dcfifo_wrptr {hier_path} {
    # control skew for bits
    set from_node_list [get_keepers $hier_path|dcfifo_component|auto_generated|delayed_wrptr_g*]
    set to_node_list [get_keepers $hier_path|dcfifo_component|auto_generated|rs_dgwp|dffpipe*|dffe*]
    apply_sdc_dcfifo_for_ptrs $from_node_list $to_node_list
    # mstable
    set from_node_mstable_list [get_keepers $hier_path|dcfifo_component|auto_generated|rs_dgwp|dffpipe*|dffe*]
    set to_node_mstable_list [get_keepers $hier_path|dcfifo_component|auto_generated|rs_dgwp|dffpipe*|dffe*]
    apply_sdc_dcfifo_mstable_delay $from_node_mstable_list $to_node_mstable_list
}

if { [llength [query_collection -report -all [get_keepers -nowarn -nocase *b2a_retime*u_fifo_a|*]]] > 0} {
    apply_sdc_dcfifo *b2a_retime*u_fifo_a
}

if { [llength [query_collection -report -all [get_keepers -nowarn -nocase *b2a_retime*u_fifo_b|*]]] > 0} {
    apply_sdc_dcfifo *b2a_retime*u_fifo_b
}
