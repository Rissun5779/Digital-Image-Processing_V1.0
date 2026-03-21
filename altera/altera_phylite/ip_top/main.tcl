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


package provide altera_phylite::ip_top::main 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_phylite::util::enum_defs
package require altera_emif::util::device_family
package require altera_phylite::util::arch_expert
package require altera_phylite::ip_top::general
package require altera_phylite::ip_top::group

namespace eval ::altera_phylite::ip_top::main:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_phylite::util::enum_defs
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*

   variable max_num_groups 1
}


proc ::altera_phylite::ip_top::main::create_parameters {} {
   variable max_num_groups
	
   ::altera_iopll_common::iopll::init	

   altera_emif::util::device_family::create_parameters
   
   set max_num_groups 18

   add_user_param     PHYLITE_NUM_GROUPS                    integer   1                    "{1:${max_num_groups}}"

   add_user_param     "DIAG_SYNTH_FOR_SIM"                  boolean   false                ""
   
   set_parameter_property DIAG_SYNTH_FOR_SIM VISIBLE false
   set_parameter_update_callback "PHYLITE_NUM_GROUPS" ::altera_phylite::ip_top::main::_set_unused_to_default ${max_num_groups}

   
   ::altera_emif::util::hwtcl_utils::_add_parameter SYS_INFO_UNIQUE_ID string ""
   set_parameter_property SYS_INFO_UNIQUE_ID SYSTEM_INFO UNIQUE_ID
   set_parameter_property SYS_INFO_UNIQUE_ID VISIBLE false   
   
   

   
   ::altera_phylite::ip_top::general::create_parameters
   for { set i 0 } { $i < ${max_num_groups} } {incr i } {
      ::altera_phylite::ip_top::group::create_parameters $i
   }

   return 1
}

proc ::altera_phylite::ip_top::main::add_display_items {} {
   variable max_num_groups

   set general_tab [get_string TAB_GENERAL_NAME]

   set grp_tab_prefix [get_string TAB_GRP_NAME]
   set grp_tabs [list]
   for { set i 0 } { $i < ${max_num_groups} } {incr i } {
      lappend grp_tabs "${grp_tab_prefix}${i}"
   }

   add_display_item "" "Block Diagram" GROUP

   add_param_to_gui "" GUI_NUM_GROUPS

   add_display_item "" $general_tab GROUP tab
   for { set i 0 } { $i < ${max_num_groups} } {incr i } {
      add_display_item "" [lindex $grp_tabs $i] GROUP tab
   }
   
   ::altera_phylite::ip_top::general::add_display_items [list $general_tab]
   for { set i 0 } { $i < ${max_num_groups} } {incr i } {
       ::altera_phylite::ip_top::group::add_display_items [list [lindex $grp_tabs $i]] $i
   }

   return 1
}

proc ::altera_phylite::ip_top::main::composition_callback {} {

   ::altera_iopll_common::iopll::init

   _validate

   
   if {[has_pending_ipgen_e_msg]} {
      issue_pending_ipgen_e_msg_and_terminate
   } else {
      _compose
      
      issue_pending_ipgen_e_msg_and_terminate
   }
}

proc ::altera_phylite::ip_top::main::parameter_upgrade_callback {ip_core_type version old_parameters} {

    foreach param [get_parameters] {
        set params($param) 1
    }

    if { $version == 13.1 } {
        _upgrade_from_13_1 $old_parameters
    } else {
        foreach { name value } $old_parameters {
	    	set grp_num ""
		regexp {.*GROUP_([0-9]+).*} $name -> grp_num
		if { [string compare -nocase $name "GUI_GROUP_${grp_num}_PIN_TYPE_ENUM"] == 0 } {
			set_parameter_value GUI_GROUP_${grp_num}_PIN_TYPE $value
		} elseif { [string compare -nocase $name "GUI_GROUP_${grp_num}_DDR_SDR_MODE_ENUM"] == 0 } {
			set_parameter_value GUI_GROUP_${grp_num}_DDR_SDR_MODE $value
		} elseif { [string compare -nocase $name "GROUP_${grp_num}_IN_DH"] == 0 } {
			set_parameter_value GUI_GROUP_${grp_num}_IN_DH $value
		} elseif { [string compare -nocase $name "GROUP_${grp_num}_IN_DS"] == 0 } {
			set_parameter_value GUI_GROUP_${grp_num}_IN_DS $value
	        } elseif {[info exists params($name)] && ![get_parameter_property $name DERIVED]} {
			set_parameter_value $name $value
		}
        }
    }
}


proc ::altera_phylite::ip_top::main::_validate {} {
   variable max_num_groups

   ::altera_emif::util::device_family::load_data true
   
   _update_range_parameters

   set num_groups [get_parameter_value PHYLITE_NUM_GROUPS]

   set grp_tab_prefix [get_string TAB_GRP_NAME]
   for { set i 0 } { $i < ${max_num_groups} } {incr i } {
      if { $i < ${num_groups} } {
         set_display_item_property "${grp_tab_prefix}$i" VISIBLE true
      } else {
         set_display_item_property "${grp_tab_prefix}$i" VISIBLE false
      }
   }
   
   ::altera_phylite::ip_top::general::validate
   for { set i 0 } { $i < ${max_num_groups} } {incr i } {
      if { $i < ${num_groups} } {
         ::altera_phylite::ip_top::group::validate $i 1
      } else {
         ::altera_phylite::ip_top::group::validate $i 0
      }
   }
      
   return [expr {![has_pending_ipgen_e_msg]}]
}

proc ::altera_phylite::ip_top::main::_compose {} {

   set family [get_parameter_value SYS_INFO_DEVICE_FAMILY]
   emif_dbg 2 "DEVICE FAMILY: $family"
   if {[string equal $family "Arria 10"]} {
      set core_component altera_phylite_arch_nf
   } else {
      set core_component altera_phylite_arch_nd
   }
   set core_name "core"
   
   add_instance $core_name $core_component
   
   foreach param_name [get_parameters] {
      set param_val [get_parameter_value $param_name]
      set_instance_parameter_value $core_name $param_name $param_val
   }
   
   altera_emif::util::hwtcl_utils::export_all_interfaces_of_sub_component $core_name
   
   return 1
}

proc ::altera_phylite::ip_top::main::_update_range_parameters {} {
}

proc ::altera_phylite::ip_top::main::_get_protocol_list {} {
   set retval [list]
   
   foreach protocol_enum [enums_of_type PROTOCOL] {
      if { [get_feature_support_level FEATURE_EMIF $protocol_enum] != 0 } {
         lappend retval [enum_dropdown_entry $protocol_enum]
      }
   }
   return $retval
}

proc ::altera_phylite::ip_top::main::_upgrade_from_13_1 {old_parameters} {

  foreach { name value } $old_parameters {
     set grp_num ""
     regexp {.*GUI_GROUP_([0-9]+).*} $name -> grp_num
     if { [string compare -nocase $name "GUI_GROUP_${grp_num}_READ_LATENCY"] == 0 } {
        if { $value < 7 } {
           send_message WARNING "The valid range of read latencies has changed since 13.1a10. Setting the read latency to a valid value of 7 for GUI_GROUP_${grp_num}_READ_LATENCY"
           set_parameter_value $name 7
        }
     } elseif { [string compare -nocase $name "GUI_GROUP_${grp_num}_USE_DIFF_STROBE"] == 0 } {
        if { [string compare -nocase $value "true"] == 0 } {
           set_parameter_value "GUI_GROUP_${grp_num}_STROBE_CONFIG" "DIFFERENTIAL"
        } else {
           set_parameter_value "GUI_GROUP_${grp_num}_STROBE_CONFIG" "SINGLE_ENDED"
        }
     } elseif { [string compare -nocase $name "GUI_PHYLITE_MEM_CLK_FREQ_MHZ"] == 0 } {
        if { $value > 800 } {
	   send_message WARNING "The valid maximum interface clock frequency has changed since 13.1a10. Setting the frequency to a valid value of 800 MHz"
	   set_parameter_value $name 800
	} else {
	   set_parameter_value $name $value
        }
     } elseif { [string compare -nocase $name "GENERATE_SDC_FILE"] == 0 } {
     } else {
        set_parameter_value $name $value
     }
  }

  set_parameter_value "GUI_PHYLITE_IO_STD_ENUM" PHYLITE_IO_STD_NONE
}

proc ::altera_phylite::ip_top::main::_set_unused_to_default {max_num_groups} {
   set num_groups [get_parameter_value PHYLITE_NUM_GROUPS]

   for { set i ${num_groups} } { $i < ${max_num_groups} } { incr i } {
      ::altera_phylite::ip_top::group::restore_group_defaults $i "GUI"
      ::altera_phylite::ip_top::group::validate $i 0
   }

}

proc ::altera_phylite::ip_top::main::_init {} {
}

::altera_phylite::ip_top::main::_init
