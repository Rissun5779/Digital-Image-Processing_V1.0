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


package provide altera_emif::util::ctrl_expert 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs

namespace eval ::altera_emif::util::ctrl_expert:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*

   
}


proc ::altera_emif::util::ctrl_expert::get_ctrl_component_qsys_name {} {

   set config_enum [get_parameter_value PHY_CONFIG_ENUM]
   if {$config_enum != "CONFIG_PHY_AND_SOFT_CTRL"} {
      emif_ie "Soft controller module must not be used in non-soft-controller flow"
   }

   set protocol_enum  [get_parameter_value PROTOCOL_ENUM]
   set module_name    [enum_data $protocol_enum MODULE_NAME]
   return "altera_emif_ctrl_${module_name}"
}

proc ::altera_emif::util::ctrl_expert::get_num_of_interfaces_used {if_enum} {
   set enable_ecc     [get_parameter_value "CTRL_ECC_EN"]
   set ping_pong_en                 [get_parameter_value "PHY_PING_PONG_EN"]
   if { $enable_ecc } {
      switch $if_enum {
         IF_CTRL_AMM {
            if { $ping_pong_en } {
            return 2
            } else {
            return 1
            }
         }
         IF_CTRL_AST_CMD -
         IF_CTRL_AST_WR -
         IF_CTRL_AST_RD {
            return 0
         }
         default {
            set func_name [_get_func_name "get_num_of_interfaces_used"]
            return [$func_name $if_enum]
         }
	  }
   } else {
	  set func_name [_get_func_name "get_num_of_interfaces_used"]
	  return [$func_name $if_enum]
   }
}

proc ::altera_emif::util::ctrl_expert::get_interface_ports {if_enum} {
   set func_name [_get_func_name "get_interface_ports"]
   return [$func_name $if_enum]
}

proc ::altera_emif::util::ctrl_expert::get_interface_properties {if_enum} {
   set func_name [_get_func_name "get_interface_properties"]
   return [$func_name $if_enum]
}


proc ::altera_emif::util::ctrl_expert::_get_func_name {base_name} {

   set config_enum [get_parameter_value PHY_CONFIG_ENUM]
   
   if {$config_enum == "CONFIG_PHY_AND_SOFT_CTRL"} {
      set protocol_enum  [get_parameter_value PROTOCOL_ENUM]
      set module_name    [enum_data $protocol_enum MODULE_NAME]
      set full_module "altera_emif::ip_ctrl::ip_${module_name}::ctrl_expert_exports"
   } else {
      set full_module "altera_emif::util::arch_expert"
   }

   package require $full_module

   set func_name "::${full_module}::${base_name}"
   if {[llength [info proc $func_name]] != 1} {
      emif_ie "Function $func_name is expected to be implemented but is not!"
   }
   return $func_name      
}

proc ::altera_emif::util::ctrl_expert::_init {} {
}

::altera_emif::util::ctrl_expert::_init
