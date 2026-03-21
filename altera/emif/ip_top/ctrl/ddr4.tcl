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


package provide altera_emif::ip_top::ctrl::ddr4 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_top::ctrl::ddr4:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*

   
   variable m_param_prefix "CTRL_DDR4"
}


proc ::altera_emif::ip_top::ctrl::ddr4::create_parameters {is_top_level_component} {
   variable m_param_prefix
   
   add_user_param     "${m_param_prefix}_AVL_PROTOCOL_ENUM"              string    CTRL_AVL_PROTOCOL_MM               [enum_dropdown_entries CTRL_AVL_PROTOCOL]     ""    ""           ""             CTRL_DDRX_AVL_PROTOCOL_ENUM
   add_user_param     "${m_param_prefix}_SELF_REFRESH_EN"                boolean   false                              ""                                            ""    ""           ""             CTRL_DDRX_SELF_REFRESH_EN
   add_user_param     "${m_param_prefix}_AUTO_POWER_DOWN_EN"             boolean   false                              ""                                            ""    ""           ""             CTRL_DDRX_AUTO_POWER_DOWN_EN
   add_user_param     "${m_param_prefix}_AUTO_POWER_DOWN_CYCS"           integer   32                                 {1:65535}                                     ""    "Cycles"     ""             CTRL_DDRX_AUTO_POWER_DOWN_CYCS
   add_user_param     "${m_param_prefix}_USER_REFRESH_EN"                boolean   false                              ""                                            ""    ""           ""             CTRL_DDRX_USER_REFRESH_EN
   add_user_param     "${m_param_prefix}_USER_PRIORITY_EN"               boolean   false                              ""                                            ""    ""           ""             CTRL_DDRX_USER_PRIORITY_EN
   add_user_param     "${m_param_prefix}_AUTO_PRECHARGE_EN"              boolean   false                              ""                                            ""    ""           ""             CTRL_DDRX_AUTO_PRECHARGE_EN
   add_user_param     "${m_param_prefix}_ADDR_ORDER_ENUM"                string    DDR4_CTRL_ADDR_ORDER_CS_R_B_C_BG   [enum_dropdown_entries DDR4_CTRL_ADDR_ORDER]  ""    ""           ""             CTRL_DDRX_ADDR_ORDER_ENUM
   add_user_param     "${m_param_prefix}_ECC_EN"                         boolean   false                              ""                                            ""    ""           ""             CTRL_DDRX_ECC_EN
   add_user_param     "${m_param_prefix}_ECC_AUTO_CORRECTION_EN"         boolean   false                              ""                                            ""    ""           ""             CTRL_DDRX_ECC_AUTO_CORRECTION_EN
   add_user_param     "${m_param_prefix}_REORDER_EN"                     boolean   true                               ""                                            ""    ""           ""             CTRL_DDRX_REORDER_EN
   add_user_param     "${m_param_prefix}_STARVE_LIMIT"                   integer   10                                 {1:63}                                        ""    ""           ""             CTRL_DDRX_STARVE_LIMIT
   add_user_param     "${m_param_prefix}_MMR_EN"                         boolean   false                              ""                                            ""    ""           ""             CTRL_DDRX_MMR_EN
   add_user_param     "${m_param_prefix}_RD_TO_WR_SAME_CHIP_DELTA_CYCS"  integer   0                                  {0 1 2 3 4 5 6 7 8}                           ""    "Cycles"     ""             CTRL_DDRX_RD_TO_WR_SAME_CHIP_DELTA_CYCS
   add_user_param     "${m_param_prefix}_WR_TO_RD_SAME_CHIP_DELTA_CYCS"  integer   0                                  {0 1 2 3 4 5 6 7 8}                           ""    "Cycles"     ""             CTRL_DDRX_WR_TO_RD_SAME_CHIP_DELTA_CYCS
   add_user_param     "${m_param_prefix}_RD_TO_RD_DIFF_CHIP_DELTA_CYCS"  integer   0                                  {0 1 2 3 4 5 6 7 8}                           ""    "Cycles"     ""             CTRL_DDRX_RD_TO_RD_DIFF_CHIP_DELTA_CYCS
   add_user_param     "${m_param_prefix}_RD_TO_WR_DIFF_CHIP_DELTA_CYCS"  integer   0                                  {0 1 2 3 4 5 6 7 8}                           ""    "Cycles"     ""             CTRL_DDRX_RD_TO_WR_DIFF_CHIP_DELTA_CYCS
   add_user_param     "${m_param_prefix}_WR_TO_WR_DIFF_CHIP_DELTA_CYCS"  integer   0                                  {0 1 2 3 4 5 6 7 8}                           ""    "Cycles"     ""             CTRL_DDRX_WR_TO_WR_DIFF_CHIP_DELTA_CYCS
   add_user_param     "${m_param_prefix}_WR_TO_RD_DIFF_CHIP_DELTA_CYCS"  integer   0                                  {0 1 2 3 4 5 6 7 8}                           ""    "Cycles"     ""             CTRL_DDRX_WR_TO_RD_DIFF_CHIP_DELTA_CYCS
   

   
   set_parameter_property "${m_param_prefix}_SELF_REFRESH_EN" VISIBLE false
   
   set_parameter_property "${m_param_prefix}_AVL_PROTOCOL_ENUM" VISIBLE false
   
   return 1
}

proc ::altera_emif::ip_top::ctrl::ddr4::set_family_specific_defaults {family_enum base_family_enum is_hps} {
   variable m_param_prefix
   
   if {$base_family_enum == "FAMILY_ARRIA10" || $base_family_enum == "FAMILY_STRATIX10"} {
      if {$is_hps} {
         set_param_default "${m_param_prefix}_AVL_PROTOCOL_ENUM" CTRL_AVL_PROTOCOL_ST
      }
   }
   
   return 1
}

proc ::altera_emif::ip_top::ctrl::ddr4::add_display_items {tabs} {
   variable m_param_prefix
   
   set ctrl_params_tab [lindex $tabs 0]

   set avalon_grp [get_string GRP_CTRL_AVALON_NAME]
   add_display_item $ctrl_params_tab $avalon_grp GROUP   
   add_param_to_gui $avalon_grp "${m_param_prefix}_AVL_PROTOCOL_ENUM"
   
   set low_power_grp [get_string GRP_CTRL_LOW_POWER_NAME]
   add_display_item $ctrl_params_tab $low_power_grp GROUP   
   add_param_to_gui $low_power_grp "${m_param_prefix}_SELF_REFRESH_EN"
   add_param_to_gui $low_power_grp "${m_param_prefix}_AUTO_POWER_DOWN_EN"
   add_param_to_gui $low_power_grp "${m_param_prefix}_AUTO_POWER_DOWN_CYCS"
   
   set efficiency_grp [get_string GRP_CTRL_EFFICIENCY_NAME]
   add_display_item $ctrl_params_tab $efficiency_grp GROUP
   add_param_to_gui $efficiency_grp "${m_param_prefix}_USER_REFRESH_EN"
   add_param_to_gui $efficiency_grp "${m_param_prefix}_AUTO_PRECHARGE_EN"
   add_param_to_gui $efficiency_grp "${m_param_prefix}_ADDR_ORDER_ENUM"
   add_param_to_gui $efficiency_grp "${m_param_prefix}_REORDER_EN"
   add_param_to_gui $efficiency_grp "${m_param_prefix}_STARVE_LIMIT"
   add_param_to_gui $efficiency_grp "${m_param_prefix}_USER_PRIORITY_EN"

   set error_handling_grp [get_string GRP_CTRL_ERROR_HANDLING_NAME]
   add_display_item $ctrl_params_tab $error_handling_grp GROUP   
   add_param_to_gui $error_handling_grp "${m_param_prefix}_MMR_EN"
   add_param_to_gui $error_handling_grp "${m_param_prefix}_ECC_EN"
   add_param_to_gui $error_handling_grp "${m_param_prefix}_ECC_AUTO_CORRECTION_EN"
   
   set bus_turnaround_grp [get_string GRP_CTRL_BUS_TURNAROUND_NAME]
   add_display_item $ctrl_params_tab $bus_turnaround_grp GROUP
   add_param_to_gui $bus_turnaround_grp "${m_param_prefix}_RD_TO_WR_SAME_CHIP_DELTA_CYCS"
   add_param_to_gui $bus_turnaround_grp "${m_param_prefix}_WR_TO_RD_SAME_CHIP_DELTA_CYCS"   
   add_param_to_gui $bus_turnaround_grp "${m_param_prefix}_RD_TO_RD_DIFF_CHIP_DELTA_CYCS"   
   add_param_to_gui $bus_turnaround_grp "${m_param_prefix}_RD_TO_WR_DIFF_CHIP_DELTA_CYCS"   
   add_param_to_gui $bus_turnaround_grp "${m_param_prefix}_WR_TO_WR_DIFF_CHIP_DELTA_CYCS"   
   add_param_to_gui $bus_turnaround_grp "${m_param_prefix}_WR_TO_RD_DIFF_CHIP_DELTA_CYCS"   
   
   return 1
}

proc ::altera_emif::ip_top::ctrl::ddr4::validate {} {
   variable m_param_prefix
   
   set auto_power_down_en [get_parameter_value "${m_param_prefix}_AUTO_POWER_DOWN_EN"]
   set_parameter_property "${m_param_prefix}_AUTO_POWER_DOWN_CYCS" ENABLED $auto_power_down_en
   
   set reorder_en [get_parameter_value "${m_param_prefix}_REORDER_EN"]
   set_parameter_property "${m_param_prefix}_STARVE_LIMIT" ENABLED $reorder_en

   set ecc_en [get_parameter_value "${m_param_prefix}_ECC_EN"]
   set_parameter_property "${m_param_prefix}_ECC_AUTO_CORRECTION_EN" ENABLED $ecc_en

   set dq_width [get_parameter_value "MEM_DDR4_DQ_WIDTH"]
   if {[expr {$dq_width % 16}] != 0 && [expr {$dq_width % 24}] != 0 && [expr {$dq_width % 40}] != 0 && [expr {$dq_width % 72}] != 0} {
      if { $ecc_en } {
         post_ipgen_e_msg MSG_ECC_ILLEGAL_INTERFACE_WIDTH
      }
   } 

   set addr_order [get_parameter_value "${m_param_prefix}_ADDR_ORDER_ENUM"]
   set addr_order_range [enum_dropdown_valid_entries DDR4_CTRL_ADDR_ORDER]
   if {[enum_data $addr_order VALID] == 0} {
      post_ipgen_w_msg MSG_MIGRATING_INVALID_PARAM_VALUE [list $addr_order [enum_data $addr_order MIGRATION_VALUE]]
      lappend addr_order_range [enum_dropdown_entry $addr_order 1]
   } 
   set_parameter_property "${m_param_prefix}_ADDR_ORDER_ENUM" ALLOWED_RANGES $addr_order_range
   
   set user_refresh_en [get_parameter_value "${m_param_prefix}_USER_REFRESH_EN"]
   if {$user_refresh_en} {
      set mmr_en [get_parameter_value "${m_param_prefix}_MMR_EN"]
      if {!$mmr_en} {
         post_ipgen_e_msg MSG_FEATURE_REQUIRES_MMR [list "User Refresh Control"]
      }
   }
   
   set dm_en [get_parameter_value "MEM_DDR4_DM_EN"]
   if {$ecc_en && $dm_en} {
      post_ipgen_i_msg MSG_ECC_DM_WARN_EFFICIENCY
   }

   if {![has_pending_ipgen_e_msg]} {
   
      _derive_protocol_agnostic_parameters
   }
   
   return 1
}


proc ::altera_emif::ip_top::ctrl::ddr4::_init {} {
}

proc ::altera_emif::ip_top::ctrl::ddr4::_derive_protocol_agnostic_parameters {} {
   variable m_param_prefix

   if {[get_parameter_value "PHY_DDR4_CONFIG_ENUM"] == "CONFIG_PHY_AND_HARD_CTRL"} { 
      set_parameter_value CTRL_ECC_EN [get_parameter_value "${m_param_prefix}_ECC_EN"]
      set_parameter_value CTRL_MMR_EN [get_parameter_value "${m_param_prefix}_MMR_EN"]
      set_parameter_value CTRL_AUTO_PRECHARGE_EN [get_parameter_value "${m_param_prefix}_AUTO_PRECHARGE_EN"]
      set_parameter_value CTRL_USER_PRIORITY_EN [get_parameter_value "${m_param_prefix}_USER_PRIORITY_EN"]
      set_parameter_value CTRL_REORDER_EN [get_parameter_value "${m_param_prefix}_REORDER_EN"]
   } else {
      set_parameter_value CTRL_ECC_EN false
      set_parameter_value CTRL_MMR_EN false
      set_parameter_value CTRL_AUTO_PRECHARGE_EN false
      set_parameter_value CTRL_USER_PRIORITY_EN false
      set_parameter_value CTRL_REORDER_EN false
   }

   return 1
}

::altera_emif::ip_top::ctrl::ddr4::_init
