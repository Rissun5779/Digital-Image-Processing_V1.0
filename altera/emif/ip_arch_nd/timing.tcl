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


package provide altera_emif::ip_arch_nd::timing 0.1

package require altera_emif::util::messaging
package require altera_emif::util::math
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_emif::util::enum_defs_interfaces
package require altera_emif::util::enum_defs_family_traits_and_features
package require altera_emif::util::device_family

package require altera_emif::arch_common::timing

package require altera_emif::ip_arch_nd::enum_defs
package require altera_emif::ip_arch_nd::enum_defs_timing_params
package require altera_emif::ip_arch_nd::protocol_expert
package require altera_emif::ip_arch_nd::util


namespace eval ::altera_emif::ip_arch_nd::timing:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_emif::ip_arch_nd::util::*


}


proc ::altera_emif::ip_arch_nd::timing::generate_files {top_level if_ports} {

   set module $top_level
   set ofile_prefix $top_level
   
   set tparams [::altera_emif::ip_arch_nd::protocol_expert::get_timing_params]
   
   set file_list [list \
      [altera_emif::arch_common::timing::generate_ip_params_tcl $module timing/memphy_ip_parameters.tcl $ofile_prefix $if_ports $tparams] \
      [altera_emif::arch_common::timing::generate_from_template $module ../arch_common/timing/memphy_utils.tcl $ofile_prefix] \
      [altera_emif::arch_common::timing::generate_from_template $module timing/memphy_parameters.tcl $ofile_prefix] \
      [altera_emif::arch_common::timing::generate_from_template $module timing/memphy_pin_map.tcl $ofile_prefix] \
      [altera_emif::arch_common::timing::generate_from_template $module timing/memphy_report_io_timing.tcl $ofile_prefix] \
      [altera_emif::arch_common::timing::generate_from_template $module timing/memphy_report_timing.tcl $ofile_prefix] \
      [altera_emif::arch_common::timing::generate_from_template $module timing/memphy_report_timing_core.tcl $ofile_prefix] \
      [altera_emif::arch_common::timing::generate_from_template $module timing/memphy.sdc $ofile_prefix]]

   return $file_list
}


proc ::altera_emif::ip_arch_nd::timing::_init {} {
}

::altera_emif::ip_arch_nd::timing::_init
