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


package provide altera_emif::ip_board_delay_model::main 0.1

package require altera_emif::util::messaging
package require altera_emif::util::math
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_emif::util::arch_expert
package require altera_emif::util::device_family
package require altera_emif::ip_top::exports
package require altera_emif::ip_board_delay_model::util

namespace eval ::altera_emif::ip_board_delay_model::main:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_emif::ip_board_delay_model::util::*

   variable m_rtl_prefix_dir "./rtl/"
   variable m_board_delay_config_file "board_delay_config.hex"

}


proc ::altera_emif::ip_board_delay_model::main::create_parameters {} {
     
   ::altera_emif::ip_top::exports::inherit_top_level_parameter_defs
   
   set_parameter_property MEM_FORMAT_ENUM               HDL_PARAMETER true

   foreach port_enum [enums_of_type PORT_MEM] {
      add_derived_hdl_param "${port_enum}_WIDTH" integer 1
   }


   return 1
}

proc ::altera_emif::ip_board_delay_model::main::elaboration_callback {} {

   if {[get_parameter_value SYS_INFO_DEVICE_FAMILY] == ""} {
      return 0
   }

   ::altera_emif::util::device_family::load_data
   
   set ports [altera_emif::util::arch_expert::get_interface_ports IF_MEM]
   ::altera_emif::util::hwtcl_utils::add_unused_interface_ports IF_MEM ports

   set if_name [::altera_emif::util::hwtcl_utils::add_qsys_interface "true" "IF_MEM" 0 "REVERSE_DIR" $ports]

   set if_name [::altera_emif::util::hwtcl_utils::add_qsys_interface "true" "IF_MEM" 1 "NORMAL_DIR" $ports]

   _derive_port_width_parameters $ports

   set_parameter_property PROTOCOL_ENUM HDL_PARAMETER true
 
   issue_pending_ipgen_e_msg_and_terminate
   
   return 1
}

proc ::altera_emif::ip_board_delay_model::main::sim_vhdl_fileset_callback {top_level} {

   variable m_rtl_prefix_dir

   set rtl_only 1
   set encrypted 1   
   
   set non_encryp_simulators [::altera_emif::util::hwtcl_utils::get_simulator_attributes 1]

   foreach file_path [_generate_verilog_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]

      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name] PATH [file join $m_rtl_prefix_dir $file_path] $non_encryp_simulators

      add_fileset_file [file join mentor $file_name] [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH [file join $m_rtl_prefix_dir mentor $file_path] {MENTOR_SPECIFIC}
   }     
   
   set rtl_only 0
   set file_path [_generate_board_delay_config_file [get_parameter_value DIAG_BOARD_DELAY_CONFIG_STR]]
   set tmp [file split $file_path]
   set file_name [lindex $tmp end]
   add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH [file join $m_rtl_prefix_dir $file_path]


}

proc ::altera_emif::ip_board_delay_model::main::sim_verilog_fileset_callback {top_level} {

   variable m_rtl_prefix_dir
   
   set rtl_only 1
   set encrypted 0   
   
   foreach file_path [_generate_verilog_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH [file join $m_rtl_prefix_dir $file_path]
   }   

   set rtl_only 0
   set file_path [_generate_board_delay_config_file [get_parameter_value DIAG_BOARD_DELAY_CONFIG_STR]]
   set tmp [file split $file_path]
   set file_name [lindex $tmp end]
   add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH [file join $m_rtl_prefix_dir $file_path]

}

proc ::altera_emif::ip_board_delay_model::main::quartus_synth_fileset_callback {top_level} {

   variable m_rtl_prefix_dir
   
   set rtl_only 0
   set encrypted 0
   
   foreach file_path [_generate_verilog_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH [file join $m_rtl_prefix_dir $file_path]
   }  
   
   foreach file_path [_generate_common_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }  
}


proc ::altera_emif::ip_board_delay_model::main::_generate_common_fileset {} {
   set file_list [list]
   return $file_list   
}

proc ::altera_emif::ip_board_delay_model::main::_generate_verilog_fileset {} {
   set file_list [list \
      altera_emif_board_delay_model.sv \
      altera_board_delay_util.sv \
      unidir_delay.sv \
      bidir_delay.sv
   ]
 
   return $file_list
}

proc ::altera_emif::ip_board_delay_model::main::_derive_port_width_parameters {ports} {
   ::altera_emif::util::hwtcl_utils::derive_port_width_parameters $ports
}

proc ::altera_emif::ip_board_delay_model::main::_generate_board_delay_config_file {config_str} {

   variable m_board_delay_config_file

   set file [create_temp_file $m_board_delay_config_file]
   set fh   [open $file "w"]

   set kv_pairs [split $config_str ","]
   
   foreach pair $kv_pairs {
      if {[regexp -nocase {([\w\.]+)=(\d+\.?\d*)(ck|ps)} $pair match key value unit]} {
         if {[regexp {(\w+)\.(\d+)} $key match name index]} {
            set key "$name \[$index\]"
         }
         if {$unit == "ps"} {
            set delay [expr {int($value)}]
            puts $fh "$key $delay"
         } else {
            set delay [expr {int($value * 1000000 / [get_parameter_value PHY_MEM_CLK_FREQ_MHZ])}]
            puts $fh "$key $delay"
         }
      } else {
         emif_ie "Malformed key-value pair: $pair"
      }
   }

   close $fh
   return $file
}

proc ::altera_emif::ip_board_delay_model::main::_init {} {
}

::altera_emif::ip_board_delay_model::main::_init
