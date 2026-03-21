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


package provide altera_emif::ip_sim_checker::main 0.1

package require altera_emif::util::messaging
package require altera_emif::util::math
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs

namespace eval ::altera_emif::ip_sim_checker::main:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*

}



proc ::altera_emif::ip_sim_checker::main::create_parameters {} {

   add_user_param     NUM_OF_TG_IFS                 integer    1          {1:16}            ""
   add_user_param     NUM_OF_EMIF_IFS               integer    1          {1:16}            ""
   add_user_param     SHORT_QSYS_INTERFACE_NAMES    boolean    true       ""                ""
   
   set_parameter_property NUM_OF_TG_IFS HDL_PARAMETER true
   set_parameter_property NUM_OF_EMIF_IFS HDL_PARAMETER true
}

proc ::altera_emif::ip_sim_checker::main::elaboration_callback {} {

   set num_of_tg_ifs [get_parameter_value NUM_OF_TG_IFS]
   set num_of_emif_ifs [get_parameter_value NUM_OF_EMIF_IFS]
   set enabled 1

   set if_types [list IF_TG_STATUS IF_STATUS]
   foreach if_type $if_types {
      set ports [::altera_emif::util::hwtcl_utils::get_default_ports $if_type]

      set num_ifs 0
      if {$if_type == "IF_TG_STATUS"} {
         set num_ifs $num_of_tg_ifs
      } elseif {$if_type == "IF_STATUS"} {
         set num_ifs $num_of_emif_ifs
      } else {
         emif_assert 0 "Illegal if_type"
      }
      for {set i 0} {$i < 16} {incr i} {
         if {$i < $num_ifs} {
            set terminated 0
         } else {
            set terminated 1
         }
         ::altera_emif::util::hwtcl_utils::add_qsys_interface $enabled $if_type $i "REVERSE_DIR" $ports $terminated
      }
      
      ::altera_emif::util::hwtcl_utils::add_qsys_interface 1 $if_type -1 "NORMAL_DIR" $ports
   }
   
   return 1
}

proc ::altera_emif::ip_sim_checker::main::sim_vhdl_fileset_callback {top_level} {
  
   set rtl_only 1
   set encrypted 1   
   
   set non_encryp_simulators [::altera_emif::util::hwtcl_utils::get_simulator_attributes 1]

   foreach file_path [_generate_verilog_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]

      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name] PATH $file_path $non_encryp_simulators

      add_fileset_file [file join mentor $file_name] [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH [file join mentor $file_path] {MENTOR_SPECIFIC}
   }   
}

proc ::altera_emif::ip_sim_checker::main::sim_verilog_fileset_callback {top_level} {
   
   set rtl_only 1
   set encrypted 0   
   
   foreach file_path [_generate_verilog_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }   
}

proc ::altera_emif::ip_sim_checker::main::quartus_synth_fileset_callback {top_level} {
   
   set rtl_only 0
   set encrypted 0
   
   foreach file_path [_generate_verilog_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }  
}



proc ::altera_emif::ip_sim_checker::main::_generate_verilog_fileset {} {

   set file_list [list \
      rtl/altera_emif_sim_checker.sv \
   ]
 
   return $file_list
}


proc ::altera_emif::ip_sim_checker::main::_init {} {
}

::altera_emif::ip_sim_checker::main::_init
