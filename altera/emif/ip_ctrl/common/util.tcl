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


package provide altera_emif::ip_ctrl::util 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::device_family
package require altera_emif::util::math
package require altera_emif::util::ctrl_expert

namespace eval ::altera_emif::ip_ctrl::util:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::math::*

}


proc ::altera_emif::ip_ctrl::util::define_common_hdl_parameters {} {

   set_parameter_property PROTOCOL_ENUM     HDL_PARAMETER true

   add_derived_hdl_param USER_CLK_RATIO     integer       1
   
   set port_types_with_buses [list \
      PORT_AFI \
      PORT_CTRL_AMM \
      PORT_CTRL_AST_CMD \
      PORT_CTRL_AST_WR \
      PORT_CTRL_AST_RD]
   
   foreach port_type_enum $port_types_with_buses {
      foreach port_enum [enums_of_type $port_type_enum] {
         set is_bus [enum_data $port_enum IS_BUS]
         if {$is_bus} {
            add_derived_hdl_param "${port_enum}_WIDTH" integer 1
         }
      }
   }
}

proc ::altera_emif::ip_ctrl::util::derive_common_hdl_parameters {if_ports} {

   foreach if_enum [dict keys $if_ports] {
      set ports [dict get $if_ports $if_enum]
      ::altera_emif::util::hwtcl_utils::derive_port_width_parameters $ports      
   }
   
   set rate_enum [get_parameter_value PHY_RATE_ENUM]
   set_parameter_value USER_CLK_RATIO [enum_data $rate_enum RATIO]
}

proc ::altera_emif::ip_ctrl::util::register_ctrl_interfaces {if_enum_type} {

   set if_ports [dict create]
   set if_names [dict create]
   
   
   foreach ctrl_if_enum [enums_of_type $if_enum_type] {
      set if_enum           [enum_data $ctrl_if_enum IF_ENUM]
      set if_dir            [enum_data $ctrl_if_enum DIR]
      set num_of_ifs_in_rtl [enum_data $ctrl_if_enum NUM_IN_RTL]

      if {$num_of_ifs_in_rtl > 0} {
         dict set if_names $if_enum [dict create]
         
         set ports           [::altera_emif::util::ctrl_expert::get_interface_ports $if_enum]
         set num_of_ifs_used [::altera_emif::util::ctrl_expert::get_num_of_interfaces_used $if_enum]
            
         dict set if_ports $if_enum $ports

         for {set i 0} {$i < $num_of_ifs_in_rtl} {incr i} {
            set if_index [expr {$num_of_ifs_in_rtl == 1 ? -1 : $i}]
            set if_enabled [expr {$i < $num_of_ifs_used ? true : false}]
            
            set if_name [::altera_emif::util::hwtcl_utils::add_qsys_interface $if_enabled $if_enum $if_index $if_dir $ports]
            
            dict set if_names $if_enum $i $if_name
         }
      }
   }
   
   
   set emif_usr_clk_if_name [dict get $if_names IF_EMIF_USR_CLK 0]
   set emif_usr_reset_if_name [dict get $if_names IF_EMIF_USR_RESET 0]
   set_interface_property $emif_usr_reset_if_name synchronousEdges NONE
   set_interface_property $emif_usr_reset_if_name associatedResetSinks [list none]
   
   set afi_reset_if_name [dict get $if_names IF_AFI_RESET 0]
   set_interface_property $afi_reset_if_name synchronousEdges NONE

   foreach if_enum [list IF_CTRL_AMM] {
      foreach if_index [dict keys [dict get $if_names $if_enum]] {
         set if_name [dict get $if_names $if_enum $if_index] 
         set_interface_property $if_name associatedClock $emif_usr_clk_if_name
         set_interface_property $if_name associatedReset $emif_usr_reset_if_name
      }
   }
   
   altera_emif::util::hwtcl_utils::set_clock_sources_rate_properties $emif_usr_clk_if_name "" "" "" "" ""

   set amm_if_props [::altera_emif::util::ctrl_expert::get_interface_properties IF_CTRL_AMM]
   
   foreach if_enum [list IF_CTRL_AMM] {
      foreach if_index [dict keys [dict get $if_names $if_enum]] {
         set if_name [dict get $if_names $if_enum $if_index] 
         ::altera_emif::util::hwtcl_utils::set_ctrl_amm_if_properties $if_name $amm_if_props
      }
   }   
   
   set retval [dict create]
   dict set retval IF_PORTS $if_ports
   dict set retval IF_NAMES $if_names
   
   return $retval
}

proc ::altera_emif::ip_ctrl::util::sim_vhdl_fileset_callback {top_level filelist} {
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

proc ::altera_emif::ip_ctrl::util::sim_verilog_fileset_callback {top_level filelist} {
   
   set rtl_only 1
   set encrypted 0   
   
   foreach file_path $filelist {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }   
}

proc ::altera_emif::ip_ctrl::util::quartus_synth_fileset_callback {top_level filelist} {
   
   set rtl_only 0
   set encrypted 0
   
   foreach file_path $filelist {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }  
}

proc ::altera_emif::ip_ctrl::util::_init {} {
}

::altera_emif::ip_ctrl::util::_init
