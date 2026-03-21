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


package provide altera_emif::ip_top::protocol_expert 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs

foreach func_enum [::altera_emif::util::enums::enums_of_type FUNC] {
   set func_module [::altera_emif::util::enums::enum_data $func_enum MODULE_NAME]
   foreach protocol_enum [::altera_emif::util::enums::enums_of_type PROTOCOL] {
      if {$protocol_enum != "PROTOCOL_INVALID"} {
         set protocol_module [::altera_emif::util::enums::enum_data $protocol_enum MODULE_NAME]
         set package_name "altera_emif::ip_top::${func_module}::${protocol_module}"
         set rc [catch {set version [package require $package_name]} result options]
         if {$rc != 0} {
         }
      }
   }
}

namespace eval ::altera_emif::ip_top::protocol_expert:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*

   
   variable m_params_default_visibility_state
}


proc ::altera_emif::ip_top::protocol_expert::create_parameters {func_enum is_top_level_component} {

   foreach protocol_enum [enums_of_type PROTOCOL] {
      
      if {$protocol_enum == "PROTOCOL_INVALID"} {
         continue
      }
      
      set protocol_module [enum_data $protocol_enum MODULE_NAME]
      set func_module [enum_data $func_enum MODULE_NAME]
      set full_module "::altera_emif::ip_top::${func_module}::${protocol_module}"
      set func_name "${full_module}::create_parameters"
      
      if {[llength [info proc $func_name]] == 1} {
         $func_name $is_top_level_component
      }
   }
   
   return 1
}

proc ::altera_emif::ip_top::protocol_expert::set_family_specific_defaults {func_enum family_enum base_family_enum is_hps} {

   foreach protocol_enum [enums_of_type PROTOCOL] {
      
      if {$protocol_enum == "PROTOCOL_INVALID"} {
         continue
      }
      
      set protocol_module [enum_data $protocol_enum MODULE_NAME]
      set func_module [enum_data $func_enum MODULE_NAME]
      set full_module "::altera_emif::ip_top::${func_module}::${protocol_module}"
      set func_name "${full_module}::set_family_specific_defaults"
      
      if {[llength [info proc $func_name]] == 1} {
         $func_name $family_enum $base_family_enum $is_hps
      }
   }
   
   return 1
}


proc ::altera_emif::ip_top::protocol_expert::add_display_items {func_enum tabs} {

   foreach protocol_enum [enums_of_type PROTOCOL] {
      
      if {$protocol_enum == "PROTOCOL_INVALID"} {
         continue
      }
      
      set protocol_module [enum_data $protocol_enum MODULE_NAME]
      set func_module [enum_data $func_enum MODULE_NAME]
      set full_module "::altera_emif::ip_top::${func_module}::${protocol_module}"
      set func_name "${full_module}::add_display_items"
      
      if {[llength [info proc $func_name]] == 1} {
         $func_name $tabs
      }
   }

   return 1
}

proc ::altera_emif::ip_top::protocol_expert::update_gui_based_on_protocol {} {

   variable m_params_default_visibility_state

   set active_protocol_enum [get_parameter_value PROTOCOL_ENUM]
   
   foreach protocol_enum [enums_of_type PROTOCOL] {
      
      if {$protocol_enum == "PROTOCOL_INVALID"} {
         continue
      }
      
      foreach func_enum [enums_of_type FUNC] {
      
         set protocol_module [enum_data $protocol_enum MODULE_NAME]
         set func_module [enum_data $func_enum MODULE_NAME]
         set full_module "::altera_emif::ip_top::${func_module}::${protocol_module}"
         set func_name "${full_module}::validate"
         
         set param_prefix [string toupper "${func_module}_${protocol_module}"]
               
         if {[llength [info proc $func_name]] == 1} {
            if {$protocol_enum != $active_protocol_enum} {
            
               foreach param_name [get_parameters] {
                  if { [string first $param_prefix $param_name] != -1 } {
                     set_parameter_property $param_name VISIBLE false
                  }
               }
               ::altera_emif::util::hwtcl_utils::update_gui_texts_visibility $param_prefix false
               ::altera_emif::util::hwtcl_utils::update_gui_tables_visibility $param_prefix false
            } else {
            
               foreach param_name [get_parameters] {
                  if { [string first $param_prefix $param_name] != -1 } {
                     set_parameter_property $param_name VISIBLE $m_params_default_visibility_state($param_name)
                  }
               }            
               ::altera_emif::util::hwtcl_utils::update_gui_texts_visibility $param_prefix true
               ::altera_emif::util::hwtcl_utils::update_gui_tables_visibility $param_prefix true
            }
         }
      }
   }
}

proc ::altera_emif::ip_top::protocol_expert::validate {func_enum} {

   set protocol_enum [get_parameter_value PROTOCOL_ENUM]
   
   set protocol_module [enum_data $protocol_enum MODULE_NAME]
   set func_module [enum_data $func_enum MODULE_NAME]
   set full_module "::altera_emif::ip_top::${func_module}::${protocol_module}"
   set func_name "${full_module}::validate"
      
   if {[llength [info proc $func_name]] == 1} {
      $func_name
   }
   return 1
}

proc ::altera_emif::ip_top::protocol_expert::save_params_default_visibility_state {} {
   variable m_params_default_visibility_state
   foreach param_name [get_parameters] {
      set m_params_default_visibility_state($param_name) [get_parameter_property $param_name VISIBLE]
   }
}


proc ::altera_emif::ip_top::protocol_expert::_init {} {
   variable m_params_default_visibility_state
   array set m_params_default_visibility_state [list]
}

::altera_emif::ip_top::protocol_expert::_init
