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


package provide altera_emif::util::device_family 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_emif::util::enum_defs_family_traits_and_features

namespace eval ::altera_emif::util::device_family:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*

   namespace export get_feature_support_level
   namespace export get_device_family_enum
   namespace export get_base_device_family_enum
   namespace export get_is_hps
   namespace export get_device
   namespace export get_speedgrade
   namespace export get_is_es
   namespace export get_is_es2
   namespace export get_is_es3
   namespace export get_is_production
   namespace export get_family_trait
      
   
   variable m_family_enum
   variable m_base_family_enum
   variable m_speedgrade
   variable m_is_es
   variable m_is_es2
   variable m_is_es3
   variable m_is_production
   variable m_family_traits
   variable m_feature_support_levels
}


proc ::altera_emif::util::device_family::get_qsys_supported_families {} {
   set retval [list]
   foreach enum [enums_of_type FAMILY] {
      foreach qsys_name [enum_data $enum QSYS_NAMES] {
         lappend retval $qsys_name
      }
   }
   return $retval
}

proc ::altera_emif::util::device_family::get_device_family_enum {} {
   variable m_family_enum
   emif_assert {[string compare $m_family_enum "FAMILY_INVALID"] != 0}
   return $m_family_enum
}

proc ::altera_emif::util::device_family::get_base_device_family_enum {} {
   variable m_base_family_enum
   emif_assert {[string compare $m_base_family_enum "FAMILY_INVALID"] != 0}
   return $m_base_family_enum
}

proc ::altera_emif::util::device_family::get_device {} {
   set device [string toupper [string trim [get_parameter_value SYS_INFO_DEVICE]]]
   if {$device == "UNKNOWN"} {
      set device ""
   }
   return $device
}

proc ::altera_emif::util::device_family::get_speedgrade {} {
   variable m_speedgrade
   return $m_speedgrade
}

proc ::altera_emif::util::device_family::get_is_es {} {
   variable m_is_es
   return $m_is_es
}

proc ::altera_emif::util::device_family::get_is_es2 {} {
   variable m_is_es2
   return $m_is_es2
}

proc ::altera_emif::util::device_family::get_is_es3 {} {
   variable m_is_es3
   return $m_is_es3
}

proc ::altera_emif::util::device_family::get_is_production {} {
   variable m_is_production
   return $m_is_production
}

proc ::altera_emif::util::device_family::get_is_hps {} {
   set family_enum [get_device_family_enum]
   return [enum_data $family_enum IS_HPS]
}

proc ::altera_emif::util::device_family::create_parameters {} {
   
   ::altera_emif::util::hwtcl_utils::_add_parameter SYS_INFO_DEVICE_FAMILY string ""
   set_parameter_property SYS_INFO_DEVICE_FAMILY SYSTEM_INFO DEVICE_FAMILY
   set_parameter_property SYS_INFO_DEVICE_FAMILY VISIBLE false
   
   ::altera_emif::util::hwtcl_utils::_add_parameter SYS_INFO_DEVICE string ""
   set_parameter_property SYS_INFO_DEVICE SYSTEM_INFO DEVICE
   set_parameter_property SYS_INFO_DEVICE VISIBLE false
   
   ::altera_emif::util::hwtcl_utils::_add_parameter SYS_INFO_DEVICE_SPEEDGRADE string ""
   set_parameter_property SYS_INFO_DEVICE_SPEEDGRADE SYSTEM_INFO DEVICE_SPEEDGRADE
   set_parameter_property SYS_INFO_DEVICE_SPEEDGRADE VISIBLE false
   
   ::altera_emif::util::hwtcl_utils::_add_parameter FAMILY_ENUM string "FAMILY_INVALID"
   set_parameter_property FAMILY_ENUM DERIVED true
   set_parameter_property FAMILY_ENUM VISIBLE false
   
   ::altera_emif::util::hwtcl_utils::_add_parameter TRAIT_SUPPORTS_VID string "0"
   set_parameter_property TRAIT_SUPPORTS_VID SYSTEM_INFO_TYPE PART_TRAIT
   set_parameter_property TRAIT_SUPPORTS_VID SYSTEM_INFO_ARG SUPPORTS_VID
   set_parameter_property TRAIT_SUPPORTS_VID VISIBLE false
}

proc ::altera_emif::util::device_family::get_feature_support_level {feature_enum protocol_enum {rate_enum RATE_INVALID}} {   
   variable m_feature_support_levels
   
   set family_enum [get_device_family_enum]
   set base_family_enum [get_base_device_family_enum]
   
   set base_family_key "$base_family_enum,$protocol_enum,$rate_enum,$feature_enum"
   set family_key "$family_enum,$protocol_enum,$rate_enum,$feature_enum"
   
   if {[info exists m_feature_support_levels($family_key)]} {
      return $m_feature_support_levels($family_key)
   } elseif {[info exists m_feature_support_levels($base_family_key)]} {
      return $m_feature_support_levels($base_family_key)
   } else {
      emif_ie "Undefined feature support level for family: $base_family_enum, $family_enum $protocol_enum $rate_enum $feature_enum"
   }
}

proc ::altera_emif::util::device_family::get_family_trait {trait_enum} {
   variable m_family_traits

   set family_enum [get_device_family_enum]
   set base_family_enum [get_base_device_family_enum]
   
   set base_family_key "$base_family_enum,$trait_enum"
   set family_key "$family_enum,$trait_enum"
   
   if {[info exists m_family_traits($family_key)]} {
      return $m_family_traits($family_key)
   } elseif {[info exists m_family_traits($base_family_key)]} {
      return $m_family_traits($base_family_key)
   } else {
      emif_ie "Undefined feature support level for family: $base_family_enum, $family_enum, $trait_enum"
   }
}

proc ::altera_emif::util::device_family::load_data {{is_top_level_component false}} {

   _derive_device_family $is_top_level_component
   _derive_device_speedgrade 
   
   return 1
}


proc ::altera_emif::util::device_family::_derive_device_family {is_top_level_component} {

   variable m_family_enum
   variable m_base_family_enum
   
   if {[get_parameter_value FAMILY_ENUM] != $m_family_enum} {
   
      if {$is_top_level_component} {
         set_parameter_value FAMILY_ENUM $m_family_enum
      } else {
         set m_family_enum [get_parameter_value FAMILY_ENUM]
      }
   }
      
   if {$m_family_enum != "FAMILY_INVALID"} {
      set m_base_family_enum [enum_data $m_family_enum BASE_FAMILY_ENUM]
   } else {
      set m_family_enum FAMILY_ARRIA10
      set m_base_family_enum FAMILY_ARRIA10
   }
}

proc ::altera_emif::util::device_family::_derive_device_speedgrade {} {   
   
   variable m_family_enum
   variable m_base_family_enum
   variable m_speedgrade
   variable m_is_es
   variable m_is_es2
   variable m_is_es3
   variable m_is_production
   
   set m_speedgrade ""
   set m_is_es false
   set m_is_es2 false
   set m_is_es3 false
   set m_is_production true

   set device [get_device]
   if {$device != ""} {
      if {$m_base_family_enum == "FAMILY_ARRIA10"} {
         set speedgrade [string range $device 12 13]
         
         set legal_speedgrades [get_family_trait FAMILY_TRAIT_SPEEDGRADES]
         foreach legal_speedgrade $legal_speedgrades {
            if {$legal_speedgrade == $speedgrade} {
               set m_speedgrade $speedgrade
               break
            }
         }
         
         if {[regexp -lineanchor -nocase {ES$} $device]} {
            set m_is_es true
            set m_is_es2 false
            set m_is_es3 false
            set m_is_production false
         } elseif {[regexp -lineanchor -nocase {E2$} $device]} {
            set m_is_es false
            set m_is_es2 true
            set m_is_es3 false
            set m_is_production false
         } elseif {[regexp -lineanchor -nocase {E3$} $device]} {
            set m_is_es false
            set m_is_es2 false
            set m_is_es3 true
            set m_is_production false
         }
      } elseif {$m_base_family_enum == "FAMILY_STRATIX10"} {
         set speedgrade [string range $device 12 13]
         
         set legal_speedgrades [get_family_trait FAMILY_TRAIT_SPEEDGRADES]
         foreach legal_speedgrade $legal_speedgrades {
            if {$legal_speedgrade == $speedgrade} {
               set m_speedgrade $speedgrade
               break
            }
         }

         if {[regexp -lineanchor -nocase {S1$} $device]} {
            set m_is_es true
            set m_is_es2 false
            set m_is_es3 false
            set m_is_production false
         } elseif {[regexp -lineanchor -nocase {S2$} $device]} {
            set m_is_es false
            set m_is_es2 true
            set m_is_es3 false
            set m_is_production false
         } elseif {[regexp -lineanchor -nocase {S3$} $device]} {
            set m_is_es false
            set m_is_es2 false
            set m_is_es3 true
            set m_is_production false
         }
      } else {
         emif_ie "Unsupported family: $m_base_family_enum"
      }
   }
}

proc ::altera_emif::util::device_family::_gen_family_traits_hash {} {   

   variable m_family_traits
   
   array unset m_family_traits

   set num_of_traits 0
   foreach enum [enums_of_type FAMILY_TRAIT_SPEC] {
      set base_family_enum  [enum_data $enum BASE_FAMILY_ENUM]
      set family_trait_enum [enum_data $enum FAMILY_TRAIT_ENUM]
      set value             [enum_data $enum VALUE]
      
      set key "$base_family_enum,$family_trait_enum"
      set m_family_traits($key) $value
   }
   
   return 1
}

proc ::altera_emif::util::device_family::_gen_derive_feature_support_levels_hash {} {   

   variable m_feature_support_levels
   
   array unset m_feature_support_levels

   foreach enum [enums_of_type FEATURE_SUPPORT_SPEC] {
      set family_enum       [enum_data $enum FAMILY_ENUM]
      set protocol_enum     [enum_data $enum PROTOCOL_ENUM]
      set rate_enum         [enum_data $enum RATE_ENUM]
      set feature_enum      [enum_data $enum FEATURE_ENUM]
      set value             [enum_data $enum VALUE]
      
      set key "$family_enum,$protocol_enum,$rate_enum,$feature_enum"
      set m_feature_support_levels($key) $value
   }
   
   return 1
}

proc ::altera_emif::util::device_family::_init {} {
   
   variable m_family_enum
   variable m_base_family_enum
   variable m_speedgrade
   variable m_is_es
   variable m_is_es2
   variable m_is_es3
   variable m_is_production
   
   set m_family_enum FAMILY_INVALID
   set m_base_family_enum FAMILY_INVALID
   set m_speedgrade ""
   set m_is_es false
   set m_is_es2 false
   set m_is_es3 false
   set m_is_production true
   
   _gen_family_traits_hash
   _gen_derive_feature_support_levels_hash
}

::altera_emif::util::device_family::_init
