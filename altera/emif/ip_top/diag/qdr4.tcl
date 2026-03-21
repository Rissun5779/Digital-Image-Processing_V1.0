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


package provide altera_emif::ip_top::diag::qdr4 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::math
package require altera_emif::util::enums
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_top::diag::qdr4:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*

   
   variable m_param_prefix "DIAG_QDR4"
}


proc ::altera_emif::ip_top::diag::qdr4::create_parameters {is_top_level_component} {
   variable m_param_prefix
   
   altera_emif::ip_top::diag::create_protocol_specifc_common_parameters $m_param_prefix
   
   add_user_param     "${m_param_prefix}_SKIP_VREF_CAL"    boolean   false      ""               ""    
   
   return 1
}

proc ::altera_emif::ip_top::diag::qdr4::set_family_specific_defaults {family_enum base_family_enum is_hps} {
   variable m_param_prefix

   if {$base_family_enum == "FAMILY_STRATIX10"} {   
      set_parameter_property "${m_param_prefix}_EX_DESIGN_ISSP_EN" DEFAULT_VALUE false
   }
   
   return 1
}


proc ::altera_emif::ip_top::diag::qdr4::add_display_items {tabs} {
   variable m_param_prefix
   
   altera_emif::ip_top::diag::add_display_items_for_protocol_specific_common_parameters $tabs $m_param_prefix
   
   set cal_debug_grp [get_string GRP_DIAGNOSTICS_CAL_DEBUG_NAME]
   
   add_param_to_gui $cal_debug_grp "${m_param_prefix}_SKIP_VREF_CAL"
   
   return 1
}

proc ::altera_emif::ip_top::diag::qdr4::validate {} {
   variable m_param_prefix
   
   set ac_io_std_enum               [get_parameter_value "PHY_QDR4_AC_IO_STD_ENUM"]
   set ck_io_std_enum               [get_parameter_value "PHY_QDR4_CK_IO_STD_ENUM"]
   set data_io_std_enum             [get_parameter_value "PHY_QDR4_DATA_IO_STD_ENUM"]
   set skip_vref_cal                [get_parameter_value "${m_param_prefix}_SKIP_VREF_CAL"]
   
   set is_pod [expr { ($ac_io_std_enum eq "IO_STD_POD_12" && $ck_io_std_enum eq "IO_STD_POD_12" && $data_io_std_enum eq "IO_STD_POD_12") ? 1 : 0 }]
   
   if {!$is_pod && !$skip_vref_cal} {
      post_ipgen_e_msg MSG_QDR4_VREF_CAL_NOT_SUPPORTED
   }
   
   return 1
}


proc ::altera_emif::ip_top::diag::qdr4::_init {} {
}

::altera_emif::ip_top::diag::qdr4::_init
