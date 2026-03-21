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


package provide altera_emif::ip_top::ctrl 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::device_family
package require altera_emif::ip_top::protocol_expert

namespace eval ::altera_emif::ip_top::ctrl:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*

}


proc ::altera_emif::ip_top::ctrl::create_parameters {is_top_level_component} {
   
   add_derived_param  "CTRL_ECC_EN"             boolean    false    false
   add_derived_param  "CTRL_MMR_EN"             boolean    false    false
   add_derived_param  "CTRL_AUTO_PRECHARGE_EN"  boolean    false    false
   add_derived_param  "CTRL_USER_PRIORITY_EN"   boolean    false    false
   add_derived_param  "CTRL_REORDER_EN"         boolean    false    false

   ::altera_emif::ip_top::protocol_expert::create_parameters FUNC_CTRL $is_top_level_component

   return 1
}

proc ::altera_emif::ip_top::ctrl::set_family_specific_defaults {family_enum base_family_enum is_hps} {

   
   
   ::altera_emif::ip_top::protocol_expert::set_family_specific_defaults FUNC_CTRL $family_enum $base_family_enum $is_hps
   
   return 1
}

proc ::altera_emif::ip_top::ctrl::add_display_items {tabs} {

   set ctrl_tab [lindex $tabs 0]

   
   
   ::altera_emif::ip_top::protocol_expert::add_display_items FUNC_CTRL $tabs
   
   return 1
}

proc ::altera_emif::ip_top::ctrl::validate {} {
   
   ::altera_emif::ip_top::protocol_expert::validate FUNC_CTRL
   
   set param_prefix [_get_protocol_specific_param_prefix]
   
   set protocol_enum [get_parameter_value "PROTOCOL_ENUM"]
    
   set config_enum [get_parameter_value "PHY_CONFIG_ENUM"]
   if {$config_enum == "CONFIG_PHY_AND_HARD_CTRL"} {
      set range [::altera_emif::ip_top::util::get_dropdown_entries FEATURE_HMC_AVL_PROTOCOL $protocol_enum]
      set_parameter_property "${param_prefix}_AVL_PROTOCOL_ENUM" ALLOWED_RANGES $range
      
   } elseif {$config_enum == "CONFIG_PHY_AND_SOFT_CTRL"} {
      set range [::altera_emif::ip_top::util::get_dropdown_entries FEATURE_SMC_AVL_PROTOCOL $protocol_enum]
      set_parameter_property "${param_prefix}_AVL_PROTOCOL_ENUM" ALLOWED_RANGES $range
   }

   return 1
}


proc ::altera_emif::ip_top::ctrl::_get_protocol_specific_param_prefix {} {
   set protocol_enum  [get_parameter_value "PROTOCOL_ENUM"]
   set module_name    [string toupper [enum_data $protocol_enum MODULE_NAME]]
   return "CTRL_${module_name}"
}

proc ::altera_emif::ip_top::ctrl::_init {} {
}

::altera_emif::ip_top::ctrl::_init
