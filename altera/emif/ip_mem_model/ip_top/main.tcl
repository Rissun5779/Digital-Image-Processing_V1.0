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


package provide altera_emif::ip_mem_model::ip_top::main 0.1

package require altera_emif::util::messaging
package require altera_emif::util::math
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_mem_model::ip_top::main:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*

}


proc ::altera_emif::ip_mem_model::ip_top::main::composition_callback {} {
   
   if {[get_parameter_value SYS_INFO_DEVICE_FAMILY] == ""} {
      return 0
   }

   _validate

   issue_pending_ipgen_e_msg_and_terminate
   
   _compose
   
   issue_pending_ipgen_e_msg_and_terminate
}


proc ::altera_emif::ip_mem_model::ip_top::main::_validate {} {

   if {[get_parameter_value SYS_INFO_DEVICE_FAMILY] == ""} {
      return 0
   }

   ::altera_emif::util::device_family::load_data
      
   return [expr {![has_pending_ipgen_e_msg]}]
}

proc ::altera_emif::ip_mem_model::ip_top::main::_compose {} {

   set protocol_enum [get_parameter_value PROTOCOL_ENUM]
   set module_name   [enum_data $protocol_enum MODULE_NAME]

   set core_component "altera_emif_mem_model_core_${module_name}"
   set core_name "core"
   
   add_instance $core_name $core_component
   
   foreach param_name [get_parameters] {
      set param_val [get_parameter_value $param_name]
      set_instance_parameter_value $core_name $param_name $param_val
   }
   
   altera_emif::util::hwtcl_utils::export_all_interfaces_of_sub_component $core_name
   
   return 1
}

proc ::altera_emif::ip_mem_model::ip_top::main::_init {} {
}

::altera_emif::ip_mem_model::ip_top::main::_init
