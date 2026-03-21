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


package provide altera_emif::util::enums 0.1

package require altera_emif::util::messaging

namespace eval ::altera_emif::util::enums:: {
   namespace import ::altera_emif::util::messaging::*

   namespace export enum_type
   namespace export enum_data
   namespace export enum_same
   namespace export enums_of_type
   namespace export enum_exists
   namespace export enum_type_exists
   namespace export enum_dropdown_entry
   namespace export enum_dropdown_entries
   namespace export enum_dropdown_valid_entries
   namespace export enum_find_by_field
   
   namespace export def_enum
   namespace export def_enum_type

   
   variable m_enums
   
   variable m_type_to_enums
   
   variable m_type_to_fields
}


proc ::altera_emif::util::enums::enum_type {enum} {
   variable m_enums

   if {[info exists m_enums($enum)]} {
      return [lindex $m_enums($enum) 0]
   } else {
      emif_ie "Undefined enum $enum"
   }
}

proc ::altera_emif::util::enums::enum_data {enum {field ""}} {
   variable m_enums
   variable m_type_to_fields

   if {[info exists m_enums($enum)]} {
      if {$field == "" } {
         set field_index 0
      } else {
         set enum_type   [lindex $m_enums($enum) 0]
         set fields      $m_type_to_fields($enum_type)
         set field_index [lsearch -exact $fields $field]
         emif_assert {$field_index != -1}
      }
      return [lindex [lindex $m_enums($enum) 1] $field_index]
   } else {
      emif_ie "Undefined enum $enum"
   }
}

proc ::altera_emif::util::enums::enum_same {enum1 enum2} {
   variable m_enums
   emif_assert [info exists m_enums($enum1)]
   emif_assert [info exists m_enums($enum2)]
   return [expr {$enum1 == $enum2 ? 1 : 0}]
}


proc ::altera_emif::util::enums::enum_exists {enum} {
   variable m_enums
   return [info exists m_enums($enum)]
}

proc ::altera_emif::util::enums::enum_type_exists {type} {
   variable m_type_to_enums
   return [info exists m_type_to_enums($type)]
}

proc ::altera_emif::util::enums::enum_dropdown_entry {enum {invalid_entry 0}} {
   variable m_enums

   if {[info exists m_enums($enum)]} {
      if {$invalid_entry} {
         return "$enum:[lindex [lindex $m_enums($enum) 1] 0] (Invalid)"
      } else {
         return "$enum:[lindex [lindex $m_enums($enum) 1] 0]"
      }
   } else {
      emif_ie "Undefined enum $enum"
   }
}

proc ::altera_emif::util::enums::enum_dropdown_entries {type} {
   variable m_enums
      
   set retval [list]
   foreach enum [enums_of_type $type] {
      set ui_string [lindex [lindex $m_enums($enum) 1] 0]
      if {$ui_string != ""} {
         lappend retval "$enum:$ui_string"
      }
   }
   return $retval
}

proc ::altera_emif::util::enums::enum_dropdown_valid_entries {type} {
   variable m_enums
      
   set retval [list]
   foreach enum [enums_of_type $type] {
      set ui_string [lindex [lindex $m_enums($enum) 1] 0]
      if {$ui_string != "" && [enum_data $enum VALID] == 1} {
         lappend retval "$enum:$ui_string"
      }
   }
   return $retval
}

proc ::altera_emif::util::enums::enums_of_type {type} {
   variable m_type_to_enums

   if {[info exists m_type_to_enums($type)]} {
      return $m_type_to_enums($type)
   } else {
      emif_ie "Undefined enum type $type"
   }
}

proc ::altera_emif::util::enums::enum_find_by_field {type field val} {
   set retval ""
   foreach curr_enum [enums_of_type $type] {
      if {[enum_data $curr_enum $field] == $val} {
         set retval $curr_enum
         break
      }
   }
   return $retval
}

proc ::altera_emif::util::enums::def_enum {type enum metadata} {
   variable m_enums
   variable m_type_to_enums
   variable m_type_to_fields

   emif_assert {[info exists m_type_to_enums($type)]}
   emif_assert {[info exists m_type_to_fields($type)]}
   emif_assert {[llength $m_type_to_fields($type)] == [llength $metadata]} "Enum $enum metadata field is inconsistent with original definition"
   
   if {[string compare -nocase $enum "_AUTO_GEN_"] == 0} {
      set num_of_enums [llength $m_type_to_enums($type)]
      set enum "${type}_AUTO_GEN_${num_of_enums}"
   }
      
   emif_assert {![info exists m_enums($enum)]} "Enum $enum is redefined!"
   set m_enums($enum) [list $type $metadata]
   lappend m_type_to_enums($type) $enum
      
   return $enum
}

proc ::altera_emif::util::enums::def_enum_type {type metadata_fields} {
   variable m_type_to_enums
   variable m_type_to_fields
   
   set m_type_to_fields($type) $metadata_fields
   set m_type_to_enums($type) [list]
}



proc ::altera_emif::util::enums::_init {} {
}

::altera_emif::util::enums::_init


