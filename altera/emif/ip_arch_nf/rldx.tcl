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


package provide altera_emif::ip_arch_nf::rldx 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::device_family
package require altera_emif::ip_arch_nf::util

namespace eval ::altera_emif::ip_arch_nf::rldx:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::ip_arch_nf::util::*

   
}


proc ::altera_emif::ip_arch_nf::rldx::is_phy_tracking_enabled {} {
   if {[get_is_es] && ([get_die_string] == "20nm5")} {
   
      set mem_clk_freq_mhz [get_parameter_value PHY_MEM_CLK_FREQ_MHZ]
      set pll_vco_freq_mhz [get_parameter_value PLL_VCO_CLK_FREQ_MHZ]
      set out_rate [expr {round($pll_vco_freq_mhz / $mem_clk_freq_mhz)}]
   
      if {$out_rate == 1} {
         set retval 1
      } else {
         set retval 0
      }
   } else {
      set retval 1
   }
   return $retval
}


proc ::altera_emif::ip_arch_nf::rldx::_init {} {
}

::altera_emif::ip_arch_nf::rldx::_init
