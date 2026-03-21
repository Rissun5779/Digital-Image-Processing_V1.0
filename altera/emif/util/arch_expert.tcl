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


package provide altera_emif::util::arch_expert 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs

namespace eval ::altera_emif::util::arch_expert:: {

   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*


}


proc ::altera_emif::util::arch_expert::get_arch_component_qsys_name {} {

   set family_enum [::altera_emif::util::device_family::get_device_family_enum]

   if {$family_enum == "" || $family_enum == "FAMILY_INVALID"} {
      emif_ie "No device family info available. ::altera_emif::util::arch_expert can only be used during IP validation, composition, or fileset generation"
   }
   return [enum_data $family_enum ARCH_COMPONENT]
}

proc ::altera_emif::util::arch_expert::get_legal_pll_ref_clk_freqs_mhz {max_entries} {
   set func_name [_get_func_name "get_legal_pll_ref_clk_freqs_mhz"]
   return [$func_name $max_entries]
}

proc ::altera_emif::util::arch_expert::is_emif_realizable {} {
   set func_name [_get_func_name "is_emif_realizable"]
   return [$func_name]
}

proc ::altera_emif::util::arch_expert::get_num_of_interfaces_used {if_enum} {
   set func_name [_get_func_name "get_num_of_interfaces_used"]
   return [$func_name $if_enum]
}

proc ::altera_emif::util::arch_expert::get_interface_ports {if_enum} {
   set func_name [_get_func_name "get_interface_ports"]
   return [$func_name $if_enum]
}

proc ::altera_emif::util::arch_expert::get_interface_properties {if_enum} {
   set func_name [_get_func_name "get_interface_properties"]
   return [$func_name $if_enum]
}

proc ::altera_emif::util::arch_expert::get_clk_ratios {} {
   set func_name [_get_func_name "get_clk_ratios"]
   return [$func_name]
}

proc ::altera_emif::util::arch_expert::get_pll_settings {} {
   set func_name [_get_func_name "get_pll_settings"]
   return [$func_name]
}

proc ::altera_emif::util::arch_expert::get_cal_code_soft_m20k_hex_file_name {} {
   set func_name [_get_func_name "get_cal_code_soft_m20k_hex_file_name"]
   return [$func_name]
}


proc ::altera_emif::util::arch_expert::_get_func_name {base_name} {

   set arch_component [get_arch_component_qsys_name]
   if {[regexp -lineanchor "^altera_emif_(.+)\$" $arch_component matched tcl_package]} {

      set full_module "altera_emif::ip_${tcl_package}::arch_expert_exports"

      package require $full_module

      set func_name "::${full_module}::${base_name}"
      if {[llength [info proc $func_name]] != 1} {
         emif_ie "Function $func_name is expected to be implemented but is not!"
      }
      return $func_name
   } else {
      emif_ie "Unable to parse tcl package name from IP component name $arch_component"
   }
}

proc ::altera_emif::util::arch_expert::_init {} {
}

::altera_emif::util::arch_expert::_init
