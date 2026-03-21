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


package provide altera_emif::ip_mem_model::ip_core_rld3::main 0.1

package require altera_emif::util::messaging
package require altera_emif::util::math
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_emif::util::arch_expert
package require altera_emif::util::device_family
package require altera_emif::ip_top::exports
package require altera_emif::ip_mem_model::ip_core_rld3::util

namespace eval ::altera_emif::ip_mem_model::ip_core_rld3::main:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_emif::ip_mem_model::ip_core_rld3::util::*

}


proc ::altera_emif::ip_mem_model::ip_core_rld3::main::create_parameters {} {
     
   ::altera_emif::ip_top::exports::inherit_top_level_parameter_defs
   
   set_parameter_property MEM_FORMAT_ENUM               HDL_PARAMETER true

   foreach port_enum [enums_of_type PORT_MEM] {
      add_derived_hdl_param "${port_enum}_WIDTH" integer 1
   }

   add_derived_hdl_param      MEM_DEVICE_WIDTH                 integer            1
   add_derived_hdl_param      MEM_DM_EN                        boolean            false

   return 1
}

proc ::altera_emif::ip_mem_model::ip_core_rld3::main::elaboration_callback {} {

   if {[get_parameter_value SYS_INFO_DEVICE_FAMILY] == ""} {
      return 0
   }

   ::altera_emif::util::device_family::load_data
   
   set ports [altera_emif::util::arch_expert::get_interface_ports IF_MEM]
   ::altera_emif::util::hwtcl_utils::add_unused_interface_ports IF_MEM ports

   set if_name [::altera_emif::util::hwtcl_utils::add_qsys_interface "true" "IF_MEM" -1 "REVERSE_DIR" $ports]

   _derive_port_width_parameters $ports
   _derive_mem_model_parameters

   set_parameter_property PROTOCOL_ENUM HDL_PARAMETER true
 
   issue_pending_ipgen_e_msg_and_terminate
   
   return 1
}

proc ::altera_emif::ip_mem_model::ip_core_rld3::main::sim_vhdl_fileset_callback {top_level} {
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

proc ::altera_emif::ip_mem_model::ip_core_rld3::main::sim_verilog_fileset_callback {top_level} {
   
   set rtl_only 1
   set encrypted 0   
   
   foreach file_path [_generate_verilog_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }   
}

proc ::altera_emif::ip_mem_model::ip_core_rld3::main::quartus_synth_fileset_callback {top_level} {
   
   set rtl_only 0
   set encrypted 0
   
   foreach file_path [_generate_verilog_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }  
   
   foreach file_path [_generate_common_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }  
}


proc ::altera_emif::ip_mem_model::ip_core_rld3::main::_generate_common_fileset {} {
   set file_list [list]
   return $file_list   
}

proc ::altera_emif::ip_mem_model::ip_core_rld3::main::_generate_verilog_fileset {} {
   set qdir $::env(QUARTUS_ROOTDIR)
	set common_dir "${qdir}/../ip/altera/emif/ip_mem_model/common/rtl"
   set file_list [list \
      ${common_dir}/altera_emif_rld3_model.sv \
      ${common_dir}/altera_emif_rld3_model_per_device.sv \
      ${common_dir}/altera_emif_rld3_model_rank.sv 
   ]
 
   return $file_list
}

proc ::altera_emif::ip_mem_model::ip_core_rld3::main::_derive_port_width_parameters {ports} {
   ::altera_emif::util::hwtcl_utils::derive_port_width_parameters $ports
}

proc ::altera_emif::ip_mem_model::ip_core_rld3::main::_derive_mem_model_parameters {} {
   set mem_model_param_list [list \
					   DEVICE_WIDTH \
                       DM_EN 
                    ]

   foreach mem_model_param $mem_model_param_list {
      set_parameter_value "MEM_${mem_model_param}"  [get_parameter_value "MEM_RLD3_${mem_model_param}"]
   }
}

proc ::altera_emif::ip_mem_model::ip_core_rld3::main::_init {} {
}

::altera_emif::ip_mem_model::ip_core_rld3::main::_init
