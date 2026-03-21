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


package provide altera_emif::ip_top::ctrl::rld2 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_top::ctrl::rld2:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*

   
   variable m_param_prefix "CTRL_RLD2"
}


proc ::altera_emif::ip_top::ctrl::rld2::create_parameters {is_top_level_component} {
   variable m_param_prefix
   
   add_user_param     "${m_param_prefix}_AVL_PROTOCOL_ENUM"         string    CTRL_AVL_PROTOCOL_MM           [enum_dropdown_entries CTRL_AVL_PROTOCOL]
        

   return 1
}

proc ::altera_emif::ip_top::ctrl::rld2::set_family_specific_defaults {family_enum base_family_enum is_hps} {
   variable m_param_prefix
   
   return 1
}

proc ::altera_emif::ip_top::ctrl::rld2::add_display_items {tabs} {
   variable m_param_prefix
   
   set ctrl_params_tab [lindex $tabs 0]

   add_param_to_gui $ctrl_params_tab "${m_param_prefix}_AVL_PROTOCOL_ENUM"

   return 1
}

proc ::altera_emif::ip_top::ctrl::rld2::validate {} {
   _validate_controller_parameters
   return 1
}

proc ::altera_emif::ip_top::ctrl::rld2::_validate_controller_parameters {} {
   variable m_param_prefix
   
   if {![has_pending_ipgen_e_msg]} {
   
      _derive_protocol_agnostic_parameters
   }
}


proc ::altera_emif::ip_top::ctrl::rld2::_derive_protocol_agnostic_parameters {} {
   variable m_param_prefix

   set_parameter_value CTRL_ECC_EN false
   set_parameter_value CTRL_MMR_EN false
   set_parameter_value CTRL_AUTO_PRECHARGE_EN false
   set_parameter_value CTRL_USER_PRIORITY_EN false
   set_parameter_value CTRL_REORDER_EN false

   return 1
}

proc ::altera_emif::ip_top::ctrl::rld2::_init {} {
}

::altera_emif::ip_top::ctrl::rld2::_init
