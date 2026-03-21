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


package provide altera_emif::ip_arch_nf::arch_expert_exports 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::enums
package require altera_emif::util::device_family
package require altera_emif::ip_arch_nf::protocol_expert
package require altera_emif::ip_arch_nf::pll

namespace eval ::altera_emif::ip_arch_nf::arch_expert_exports:: {

   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*


}


proc ::altera_emif::ip_arch_nf::arch_expert_exports::get_legal_pll_ref_clk_freqs_mhz {max_entries} {
   return [altera_emif::ip_arch_nf::pll::get_legal_pll_ref_clk_freqs_mhz $max_entries]
}

proc ::altera_emif::ip_arch_nf::arch_expert_exports::is_emif_realizable {} {
   set max_tiles_per_if [::altera_emif::util::device_family::get_family_trait FAMILY_TRAIT_MAX_TILES_PER_IF]

   set resources  [altera_emif::ip_arch_nf::protocol_expert::get_resource_consumption]
   set num_tiles  [dict get $resources NUM_TILES]

   return [expr {$num_tiles <= $max_tiles_per_if}]
}

proc ::altera_emif::ip_arch_nf::arch_expert_exports::get_num_of_interfaces_used {if_enum} {
   return [altera_emif::ip_arch_nf::protocol_expert::get_num_of_interfaces_used $if_enum]
}

proc ::altera_emif::ip_arch_nf::arch_expert_exports::get_interface_ports {if_enum} {
   return [altera_emif::ip_arch_nf::protocol_expert::get_interface_ports $if_enum]
}

proc ::altera_emif::ip_arch_nf::arch_expert_exports::get_interface_properties {if_enum} {
   return [altera_emif::ip_arch_nf::protocol_expert::get_interface_properties $if_enum]
}

proc ::altera_emif::ip_arch_nf::arch_expert_exports::get_clk_ratios {} {
   return [altera_emif::ip_arch_nf::protocol_expert::get_clk_ratios]
}

proc ::altera_emif::ip_arch_nf::arch_expert_exports::get_hmc_cfgs {} {
   return [altera_emif::ip_arch_nf::protocol_expert::get_hmc_cfgs]
}

proc ::altera_emif::ip_arch_nf::arch_expert_exports::get_pll_settings {} {
   return [::altera_emif::ip_arch_nf::pll::get_pll_settings]
}

proc ::altera_emif::ip_arch_nf::arch_expert_exports::get_cal_code_soft_m20k_hex_file_name {} {
   return [file join "../../emif/ip_arch_nf" [::altera_emif::ip_arch_nf::util::get_cal_code_hex_src_filename 1]]
}


proc ::altera_emif::ip_arch_nf::arch_expert_exports::_init {} {
}

::altera_emif::ip_arch_nf::arch_expert_exports::_init
