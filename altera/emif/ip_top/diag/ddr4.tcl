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


package provide altera_emif::ip_top::diag::ddr4 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::math
package require altera_emif::util::enums
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_top::diag::ddr4:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*

   
   variable m_param_prefix "DIAG_DDR4"
}


proc ::altera_emif::ip_top::diag::ddr4::create_parameters {is_top_level_component} {
   variable m_param_prefix
   
   altera_emif::ip_top::diag::create_protocol_specifc_common_parameters $m_param_prefix
   
   add_user_param     "${m_param_prefix}_SKIP_CA_LEVEL"           boolean   false      ""               ""    
   add_user_param     "${m_param_prefix}_SKIP_CA_DESKEW"          boolean   false      ""               ""    
   add_user_param     "${m_param_prefix}_SKIP_VREF_CAL"           boolean   false      ""               ""    

   add_user_param     "${m_param_prefix}_CAL_ADDR0"               integer   0          ""               ""  
   add_user_param     "${m_param_prefix}_CAL_ADDR1"               integer   8          ""               ""  
   add_user_param     "${m_param_prefix}_CAL_ENABLE_NON_DES"      boolean   false      ""               ""  
   add_user_param     "${m_param_prefix}_CAL_FULL_CAL_ON_RESET"   boolean   true      ""               ""  



   if {![ini_is_on "emif_enable_non_des_cal"]} {
      set_parameter_property "${m_param_prefix}_CAL_ENABLE_NON_DES" VISIBLE false
      set_parameter_property "${m_param_prefix}_CAL_ADDR0" VISIBLE false
      set_parameter_property "${m_param_prefix}_CAL_ADDR1" VISIBLE false
      set_parameter_property "${m_param_prefix}_CAL_FULL_CAL_ON_RESET" VISIBLE false
   }


   return 1
}

proc ::altera_emif::ip_top::diag::ddr4::set_family_specific_defaults {family_enum base_family_enum is_hps} {
   variable m_param_prefix

   if {$base_family_enum == "FAMILY_STRATIX10"} {   
      set_parameter_property "${m_param_prefix}_EX_DESIGN_ISSP_EN" DEFAULT_VALUE false
   }
   
   return 1
}

proc ::altera_emif::ip_top::diag::ddr4::add_display_items {tabs} {
   variable m_param_prefix
   
   altera_emif::ip_top::diag::add_display_items_for_protocol_specific_common_parameters $tabs $m_param_prefix
      
   set diag_tab [lindex $tabs 0]
      
   set sim_grp [get_string GRP_DIAGNOSTICS_SIM_NAME]
   set cal_debug_grp [get_string GRP_DIAGNOSTICS_CAL_DEBUG_NAME]
   set ex_design_grp [get_string GRP_DIAGNOSTICS_EX_DESIGN_NAME]
   set internal_grp [get_string GRP_DIAGNOSTICS_INTERNAL_NAME]

   add_param_to_gui $cal_debug_grp "${m_param_prefix}_SKIP_CA_LEVEL"
   add_param_to_gui $cal_debug_grp "${m_param_prefix}_SKIP_CA_DESKEW"
   add_param_to_gui $cal_debug_grp "${m_param_prefix}_SKIP_VREF_CAL"

   add_param_to_gui $cal_debug_grp  "${m_param_prefix}_CAL_ENABLE_NON_DES"
   add_param_to_gui $cal_debug_grp  "${m_param_prefix}_CAL_ADDR0"
   add_param_to_gui $cal_debug_grp  "${m_param_prefix}_CAL_ADDR1"
   add_param_to_gui $cal_debug_grp  "${m_param_prefix}_CAL_FULL_CAL_ON_RESET"


   return 1
}

proc ::altera_emif::ip_top::diag::ddr4::validate {} {
   variable m_param_prefix
   
   set sim_cal_mode_enum      [get_parameter_value DIAG_DDR4_SIM_CAL_MODE_ENUM]
   set format_enum            [get_parameter_value MEM_DDR4_FORMAT_ENUM]
   set is_lrdimm              [expr {$format_enum == "MEM_FORMAT_LRDIMM"}]

   if {$is_lrdimm && $sim_cal_mode_enum != "SIM_CAL_MODE_SKIP"} {
      post_ipgen_e_msg MSG_DDR4_LRDIMM_FULL_CAL_SIM_UNSUPPORTED
   }

   return 1
}


proc ::altera_emif::ip_top::diag::ddr4::_init {} {
}

::altera_emif::ip_top::diag::ddr4::_init
