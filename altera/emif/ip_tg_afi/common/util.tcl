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


package provide altera_emif::ip_tg_afi::util 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::device_family
package require altera_emif::util::math
package require altera_emif::util::arch_expert
package require altera_emif::ip_tg_afi::util
package require altera_emif::ip_tg_afi::enum_defs

namespace eval ::altera_emif::ip_tg_afi::util:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::math::*

}


proc ::altera_emif::ip_tg_afi::util::define_common_hdl_parameters {} {

   set_parameter_property PROTOCOL_ENUM             HDL_PARAMETER true

   add_derived_hdl_param USER_CLK_RATIO     integer       1
   add_derived_hdl_param DENY_RECAL_REQUEST boolean       false
   
   set port_types_with_buses [list PORT_AFI]
   
   foreach port_type_enum $port_types_with_buses {
      foreach port_enum [enums_of_type $port_type_enum] {
         set is_bus [enum_data $port_enum IS_BUS]
         if {$is_bus} {
            add_derived_hdl_param "${port_enum}_WIDTH" integer 1
         }
      }
   }
}

proc ::altera_emif::ip_tg_afi::util::derive_common_hdl_parameters {if_ports} {

   foreach if_enum [dict keys $if_ports] {
      set ports [dict get $if_ports $if_enum]
      ::altera_emif::util::hwtcl_utils::derive_port_width_parameters $ports      
   }
   
   set rate_enum [get_parameter_value PHY_RATE_ENUM]
   set_parameter_value USER_CLK_RATIO [enum_data $rate_enum RATIO]
   set_parameter_value DENY_RECAL_REQUEST [get_parameter_value DIAG_USE_ABSTRACT_PHY]
}

proc ::altera_emif::ip_tg_afi::util::register_interfaces {} {

   set if_ports [dict create]
   set if_names [dict create]
   
   foreach tg_afi_if_enum [enums_of_type TG_AFI_IF] {
      set if_enum           [enum_data $tg_afi_if_enum IF_ENUM]
      set if_dir            [enum_data $tg_afi_if_enum DIR]
      set num_of_ifs_in_rtl [enum_data $tg_afi_if_enum NUM_IN_RTL]

      if {$num_of_ifs_in_rtl > 0} {
         dict set if_names $if_enum [dict create]
         
         set num_of_ifs_used 1
         
         switch $if_enum {
            IF_AFI {
               set ports [altera_emif::util::arch_expert::get_interface_ports IF_AFI]
               ::altera_emif::util::hwtcl_utils::add_unused_interface_ports IF_AFI ports
            }
            IF_AFI_RESET -
            IF_AFI_CLK -
            IF_AFI_HALF_CLK -
            IF_TG_STATUS {
               set ports [::altera_emif::util::hwtcl_utils::get_default_ports $if_enum]
            }
            default {
               emif_ie "Code path does not support if_enum $if_enum"
            }
         }
         
         dict set if_ports $if_enum $ports

         for {set i 0} {$i < $num_of_ifs_in_rtl} {incr i} {
            set if_index [expr {$num_of_ifs_in_rtl == 1 ? -1 : $i}]
            set if_enabled [expr {$i < $num_of_ifs_used ? true : false}]
            
            set if_name [::altera_emif::util::hwtcl_utils::add_qsys_interface $if_enabled $if_enum $if_index $if_dir $ports]
            
            dict set if_names $if_enum $i $if_name
         }
      }
   }
   
   set afi_reset_if_name [dict get $if_names IF_AFI_RESET 0]
   set_interface_property $afi_reset_if_name synchronousEdges NONE
      
   set retval [dict create]
   dict set retval IF_PORTS $if_ports
   dict set retval IF_NAMES $if_names
   
   return $retval
}

proc ::altera_emif::ip_tg_afi::util::sim_vhdl_fileset_callback {top_level filelist} {
   set rtl_only 1
   set encrypted 1   
   
   set non_encryp_simulators [::altera_emif::util::hwtcl_utils::get_simulator_attributes 1]

   foreach file_path $filelist {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]

      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name] PATH $file_path $non_encryp_simulators

      add_fileset_file [file join mentor $file_name] [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH [file join mentor $file_path] {MENTOR_SPECIFIC}
   }   
}

proc ::altera_emif::ip_tg_afi::util::sim_verilog_fileset_callback {top_level filelist} {
   
   set rtl_only 1
   set encrypted 0   
   
   foreach file_path $filelist {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }   
}

proc ::altera_emif::ip_tg_afi::util::quartus_synth_fileset_callback {top_level filelist} {
   
   set rtl_only 0
   set encrypted 0
   
   foreach file_path $filelist {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }  
}

proc ::altera_emif::ip_tg_afi::util::_init {} {
}

::altera_emif::ip_tg_afi::util::_init
