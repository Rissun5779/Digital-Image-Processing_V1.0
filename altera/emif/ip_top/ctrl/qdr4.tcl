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


package provide altera_emif::ip_top::ctrl::qdr4 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_top::ctrl::qdr4:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_emif::util::hwtcl_utils::*

   
   variable m_param_prefix "CTRL_QDR4"
}


proc ::altera_emif::ip_top::ctrl::qdr4::create_parameters {is_top_level_component} {
   variable m_param_prefix
   
   add_user_param     "${m_param_prefix}_AVL_PROTOCOL_ENUM"             string    CTRL_AVL_PROTOCOL_MM           [enum_dropdown_entries CTRL_AVL_PROTOCOL]
   add_user_param     "${m_param_prefix}_AVL_MAX_BURST_COUNT"           integer   4                              [list 1 2 4 8 16 32 64 128 256 512 1024]
   add_user_param     "${m_param_prefix}_AVL_ENABLE_POWER_OF_TWO_BUS"   boolean   false                          ""
   
   add_user_param     "${m_param_prefix}_ADD_RAW_TURNAROUND_DELAY_CYC"  integer   0                              ""
   add_user_param     "${m_param_prefix}_ADD_WAR_TURNAROUND_DELAY_CYC"  integer   0                              ""
   
   add_derived_param  "${m_param_prefix}_AVL_SYMBOL_WIDTH"              integer     9         false
   add_derived_param  "${m_param_prefix}_RAW_TURNAROUND_DELAY_CYC"      integer     4         false
   add_derived_param  "${m_param_prefix}_WAR_TURNAROUND_DELAY_CYC"      integer     11        false
   
   set_parameter_property "${m_param_prefix}_AVL_PROTOCOL_ENUM" VISIBLE false
   
   return 1
}

proc ::altera_emif::ip_top::ctrl::qdr4::set_family_specific_defaults {family_enum base_family_enum is_hps} {
   variable m_param_prefix
   return 1
}

proc ::altera_emif::ip_top::ctrl::qdr4::add_display_items {tabs} {
   variable m_param_prefix
   
   set ctrl_params_tab [lindex $tabs 0]

   add_param_to_gui $ctrl_params_tab "${m_param_prefix}_AVL_PROTOCOL_ENUM"
   add_param_to_gui $ctrl_params_tab "${m_param_prefix}_AVL_MAX_BURST_COUNT"
   add_param_to_gui $ctrl_params_tab "${m_param_prefix}_AVL_ENABLE_POWER_OF_TWO_BUS"
   
   add_param_to_gui $ctrl_params_tab "${m_param_prefix}_ADD_RAW_TURNAROUND_DELAY_CYC"
   add_param_to_gui $ctrl_params_tab "${m_param_prefix}_ADD_WAR_TURNAROUND_DELAY_CYC"

   return 1
}

proc ::altera_emif::ip_top::ctrl::qdr4::validate {} {

   _validate_controller_parameters 

   if {![has_pending_ipgen_e_msg]} {
   
      _derive_protocol_agnostic_parameters
   }

   return 1
}


proc ::altera_emif::ip_top::ctrl::qdr4::_validate_controller_parameters {} {
   variable m_param_prefix

   set enable_power_of_two_bus   [get_parameter_value "${m_param_prefix}_AVL_ENABLE_POWER_OF_TWO_BUS"]
   set symbol_width              [expr {$enable_power_of_two_bus ? 8 : 9}]
   set additional_raw_delay      [get_parameter_value "${m_param_prefix}_ADD_RAW_TURNAROUND_DELAY_CYC"]
   set additional_war_delay      [get_parameter_value "${m_param_prefix}_ADD_WAR_TURNAROUND_DELAY_CYC"]
   
   set_parameter_value "${m_param_prefix}_RAW_TURNAROUND_DELAY_CYC"  [expr {4 + $additional_raw_delay}]
   
   if {[get_is_es] && [_get_die_string] == "20nm5"} {
      set_parameter_value "${m_param_prefix}_WAR_TURNAROUND_DELAY_CYC"  [expr {13 + $additional_war_delay}]
   } else {
      set_parameter_value "${m_param_prefix}_WAR_TURNAROUND_DELAY_CYC"  [expr {11 + $additional_war_delay}]
   }

   set_parameter_value "${m_param_prefix}_AVL_SYMBOL_WIDTH"    $symbol_width
}

proc ::altera_emif::ip_top::ctrl::qdr4::_derive_protocol_agnostic_parameters {} {
   variable m_param_prefix

   set_parameter_value CTRL_ECC_EN false
   set_parameter_value CTRL_MMR_EN false
   set_parameter_value CTRL_AUTO_PRECHARGE_EN false
   set_parameter_value CTRL_USER_PRIORITY_EN false
   set_parameter_value CTRL_REORDER_EN false

   return 1
}

proc ::altera_emif::ip_top::ctrl::qdr4::_get_die_string {} {
   set device [get_device]

   if {[regexp -lineanchor -nocase {^10A[XST]016} $device] || [regexp -lineanchor -nocase {^10A[XST]022} $device]} {
	   set retval "20nm1"
   } elseif {[regexp -lineanchor -nocase {^10A[XST]027} $device] || [regexp -lineanchor -nocase {^10A[XST]032} $device]} {
	   set retval "20nm2"
   } elseif {[regexp -lineanchor -nocase {^10A[XST]048} $device]} {
	   set retval "20nm3"
   } elseif {[regexp -lineanchor -nocase {^10A[XST]057} $device] || [regexp -lineanchor -nocase {^10A[XST]066} $device]} {
	   set retval "20nm4"
   } else {
      set retval "20nm5"
   }

   return $retval
}

proc ::altera_emif::ip_top::ctrl::qdr4::_init {} {
}


::altera_emif::ip_top::ctrl::qdr4::_init
