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


package provide altera_emif::ip_top::diag 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::device_family
package require altera_emif::ip_top::protocol_expert

namespace eval ::altera_emif::ip_top::diag:: {

   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*


   variable m_param_prefix "DIAG"
}


proc ::altera_emif::ip_top::diag::create_parameters {is_top_level_component} {


   add_user_param     "DIAG_SIM_REGTEST_MODE"              boolean   false     ""               ""
   add_user_param     "DIAG_TIMING_REGTEST_MODE"           boolean   false     ""               ""
   add_user_param     "DIAG_SYNTH_FOR_SIM"                 boolean   false     ""               ""
   add_user_param     "DIAG_FAST_SIM_OVERRIDE"             string    FAST_SIM_OVERRIDE_DEFAULT        [enum_dropdown_entries FAST_SIM_OVERRIDE] ""
   add_user_param     "DIAG_VERBOSE_IOAUX"                 boolean   false     ""               ""

   add_user_param     "DIAG_ECLIPSE_DEBUG"                 boolean   false     ""               ""
   add_user_param     "DIAG_EXPORT_VJI"                    boolean   false     ""               ""
   add_user_param     "DIAG_ENABLE_JTAG_UART"              boolean   false     ""               ""
   add_user_param     "DIAG_ENABLE_JTAG_UART_HEX"          boolean   false     ""               ""
   add_user_param     "DIAG_ENABLE_HPS_EMIF_DEBUG"         boolean   false     ""               ""

   add_user_param     "DIAG_SOFT_NIOS_MODE"                string    SOFT_NIOS_MODE_DISABLED    [enum_dropdown_entries SOFT_NIOS_MODE] ""
   add_user_param     "DIAG_SOFT_NIOS_CLOCK_FREQUENCY"     integer   100       ""               MegaHertz
   add_user_param     "DIAG_USE_RS232_UART"                boolean   false     ""               ""
   add_user_param     "DIAG_RS232_UART_BAUDRATE"           integer   57600     [list 9600 19200 38400 57600 115200]  BitsPerSecond

   add_user_param     "DIAG_EX_DESIGN_ADD_TEST_EMIFS"      string    ""         ""              ""
   add_user_param     "DIAG_EX_DESIGN_SEPARATE_RESETS"     boolean   false      ""

   add_user_param     "DIAG_EXPOSE_DFT_SIGNALS"            boolean   false      ""

   add_user_param     "DIAG_EXTRA_CONFIGS"                 string    ""         ""

   add_user_param     "DIAG_USE_BOARD_DELAY_MODEL"         boolean   false      ""               ""
   add_user_param     "DIAG_BOARD_DELAY_CONFIG_STR"        string    ""         ""               ""

   add_user_param     "DIAG_TG_AVL_2_EXPORT_CFG_INTERFACE" boolean   false      ""               ""
   add_user_param     "DIAG_TG_AVL_2_NUM_CFG_INTERFACES"   integer   0          [list 0 1]       ""
   set_parameter_property "DIAG_TG_AVL_2_NUM_CFG_INTERFACES" VISIBLE false

   add_user_param     "SHORT_QSYS_INTERFACE_NAMES"         boolean   true       ""               ""
   set_parameter_property "SHORT_QSYS_INTERFACE_NAMES" VISIBLE false

   add_user_param     "DIAG_EXT_DOCS"                      boolean   false      ""               ""
   set_parameter_property "DIAG_EXT_DOCS" VISIBLE false

   add_derived_param  "DIAG_SIM_CAL_MODE_ENUM"                string     ""       false     ""
   add_derived_param  "DIAG_EXPORT_SEQ_AVALON_SLAVE"          string     ""       false     ""
   add_derived_param  "DIAG_EXPORT_SEQ_AVALON_MASTER"         boolean    false    false     ""
   add_derived_param  "DIAG_EX_DESIGN_NUM_OF_SLAVES"          integer    1        false     ""
   add_derived_param  "DIAG_EX_DESIGN_SEPARATE_RZQS"          boolean    false    false     ""
   add_derived_param  "DIAG_EX_DESIGN_ISSP_EN"                boolean    true     false     ""
   add_derived_param  "DIAG_INTERFACE_ID"                     integer    0        false     ""
   add_derived_param  "DIAG_EFFICIENCY_MONITOR"               string     ""       false     ""

   add_derived_param  "DIAG_FAST_SIM"                         boolean   true      false     ""

   add_derived_param  "DIAG_USE_TG_AVL_2"                     boolean   false     false     ""
   add_derived_param  "DIAG_USE_ABSTRACT_PHY"                 boolean   false     false     ""
   add_derived_param  "DIAG_TG_DATA_PATTERN_LENGTH"           integer    32        false     ""
   add_derived_param  "DIAG_TG_BE_PATTERN_LENGTH"             integer    32        false     ""
   add_derived_param  "DIAG_BYPASS_DEFAULT_PATTERN"           boolean   false     false     ""
   add_derived_param  "DIAG_BYPASS_USER_STAGE"                boolean   true      false     ""
   add_derived_param  "DIAG_BYPASS_REPEAT_STAGE"              boolean   true      false     ""
   add_derived_param  "DIAG_BYPASS_STRESS_STAGE"              boolean   true      false     ""

   add_derived_param  "DIAG_ENABLE_SOFT_M20K"                 boolean   false     false     ""

   ::altera_emif::ip_top::protocol_expert::create_parameters FUNC_DIAG $is_top_level_component

   return 1
}

proc ::altera_emif::ip_top::diag::set_family_specific_defaults {family_enum base_family_enum is_hps} {

   if {$base_family_enum == "FAMILY_ARRIA10"} {
      set_parameter_property SHORT_QSYS_INTERFACE_NAMES DEFAULT_VALUE false
      set_parameter_property SHORT_QSYS_INTERFACE_NAMES NEW_INSTANCE_VALUE true
      set_parameter_property SHORT_QSYS_INTERFACE_NAMES VISIBLE true
   }

   ::altera_emif::ip_top::protocol_expert::set_family_specific_defaults FUNC_DIAG $family_enum $base_family_enum $is_hps

   return 1
}

proc ::altera_emif::ip_top::diag::create_protocol_specifc_common_parameters {param_prefix} {

   add_user_param     "${param_prefix}_SIM_CAL_MODE_ENUM"             string    SIM_CAL_MODE_SKIP         [enum_dropdown_entries SIM_CAL_MODE]   ""           ""             ""             DIAG_SIM_CAL_MODE_ENUM
   add_user_param     "${param_prefix}_EXPORT_SEQ_AVALON_SLAVE"       string    CAL_DEBUG_EXPORT_MODE_DISABLED [enum_dropdown_entries CAL_DEBUG_EXPORT_MODE] "" ""           ""             DIAG_EXPORT_SEQ_AVALON_SLAVE
   add_user_param     "${param_prefix}_EXPORT_SEQ_AVALON_MASTER"      boolean   false                     ""                                     ""           ""             ""             DIAG_EXPORT_SEQ_AVALON_MASTER
   add_user_param     "${param_prefix}_EX_DESIGN_NUM_OF_SLAVES"       integer   1                         [list 1 2 3 4 5 6 7 8]                 ""           ""             ""             DIAG_EX_DESIGN_NUM_OF_SLAVES
   add_user_param     "${param_prefix}_EX_DESIGN_SEPARATE_RZQS"       boolean   false                     ""                                     ""           ""             ""             DIAG_EX_DESIGN_SEPARATE_RZQS
   add_user_param     "${param_prefix}_EX_DESIGN_ISSP_EN"             boolean   true                      ""                                     ""           ""             ""             DIAG_EX_DESIGN_ISSP_EN
   add_user_param     "${param_prefix}_INTERFACE_ID"                  integer   0                         [list 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14]       ""  ""             ""             DIAG_INTERFACE_ID
   add_user_param     "${param_prefix}_EFFICIENCY_MONITOR"            string    EFFMON_MODE_DISABLED      [enum_dropdown_entries EFFMON_MODE]    ""           ""             ""             DIAG_EFFICIENCY_MONITOR
   add_user_param     "${param_prefix}_USE_TG_AVL_2"                  boolean   false                      ""                                    ""           ""             ""             DIAG_USE_TG_AVL_2
   add_user_param     "${param_prefix}_ABSTRACT_PHY"                  boolean   false                      ""                                    ""           ""             ""             DIAG_ABSTRACT_PHY
   add_user_param     "${param_prefix}_BYPASS_DEFAULT_PATTERN"        boolean   false                      ""                                    ""           ""             ""             DIAG_BYPASS_DEFAULT_PATTERN
   add_user_param     "${param_prefix}_BYPASS_USER_STAGE"             boolean   true                       ""                                    ""           ""             ""             DIAG_BYPASS_USER_STAGE
   add_user_param     "${param_prefix}_BYPASS_REPEAT_STAGE"           boolean   true                       ""                                    ""           ""             ""             DIAG_BYPASS_REPEAT_STAGE
   add_user_param     "${param_prefix}_BYPASS_STRESS_STAGE"           boolean   true                       ""                                    ""           ""             ""             DIAG_BYPASS_STRESS_STAGE
   add_user_param     "${param_prefix}_TG_DATA_PATTERN_LENGTH"        integer   8                          [list 8 16 32]                        ""           ""             ""             DIAG_TG_DATA_PATTERN_LENGTH
   add_user_param     "${param_prefix}_TG_BE_PATTERN_LENGTH"          integer   8                          [list 8 16 32]                        ""           ""             ""             DIAG_TG_BE_PATTERN_LENGTH
   add_user_param     "${param_prefix}_SEPARATE_READ_WRITE_ITFS"      boolean   false                      ""                                    ""           ""             ""             DIAG_SEPARATE_READ_WRITE_ITFS

}

proc ::altera_emif::ip_top::diag::add_display_items {tabs} {

   set diag_tab [lindex $tabs 0]

   set sim_grp [get_string GRP_DIAGNOSTICS_SIM_NAME]
   set cal_debug_grp [get_string GRP_DIAGNOSTICS_CAL_DEBUG_NAME]
   set ex_design_grp [get_string GRP_DIAGNOSTICS_EX_DESIGN_NAME]
   set traffic_gen_grp [get_string GRP_DIAGNOSTICS_TRAFFIC_GENERATOR_NAME]
   set performance_grp [get_string GRP_DIAGNOSTICS_PERFORMANCE_NAME]
   set misc_grp [get_string GRP_DIAGNOSTICS_MISC_NAME]
   set internal_grp [get_string GRP_DIAGNOSTICS_INTERNAL_NAME]

   add_display_item $diag_tab $sim_grp GROUP
   add_display_item $diag_tab $cal_debug_grp GROUP
   add_display_item $diag_tab $ex_design_grp GROUP
   add_display_item $diag_tab $traffic_gen_grp GROUP
   add_display_item $diag_tab $performance_grp GROUP
   add_display_item $diag_tab $misc_grp GROUP
   add_display_item $diag_tab $internal_grp GROUP

   set internal_params [list \
    DIAG_SIM_REGTEST_MODE \
    DIAG_TIMING_REGTEST_MODE \
    DIAG_SYNTH_FOR_SIM \
    DIAG_FAST_SIM_OVERRIDE \
    DIAG_VERBOSE_IOAUX \
    DIAG_USE_BOARD_DELAY_MODEL \
    DIAG_BOARD_DELAY_CONFIG_STR \
    DIAG_EXPOSE_DFT_SIGNALS \
    DIAG_ECLIPSE_DEBUG \
    DIAG_EXPORT_VJI \
    DIAG_ENABLE_JTAG_UART \
    DIAG_ENABLE_JTAG_UART_HEX \
    DIAG_ENABLE_HPS_EMIF_DEBUG \
    DIAG_SOFT_NIOS_CLOCK_FREQUENCY \
    DIAG_USE_RS232_UART \
    DIAG_RS232_UART_BAUDRATE \
    DIAG_ECLIPSE_DEBUG \
    DIAG_EXTRA_CONFIGS \
    DIAG_EX_DESIGN_ADD_TEST_EMIFS \
    DIAG_EX_DESIGN_SEPARATE_RESETS]

   foreach param $internal_params {
      add_param_to_gui $internal_grp $param
   }

   if {[::altera_emif::util::qini::ini_is_on "emif_show_internal_settings"]} {
      set_display_item_property $internal_grp               VISIBLE true
      foreach param $internal_params {
         set_parameter_property $param VISIBLE true
      }
   } else {
      set_display_item_property $internal_grp               VISIBLE false
      foreach param $internal_params {
         set_parameter_property $param VISIBLE false
      }
   }

   add_param_to_gui $misc_grp SHORT_QSYS_INTERFACE_NAMES

   ::altera_emif::ip_top::protocol_expert::add_display_items FUNC_DIAG $tabs

   return 1
}

proc ::altera_emif::ip_top::diag::add_display_items_for_protocol_specific_common_parameters {tabs param_prefix} {

   set diag_tab [lindex $tabs 0]

   set sim_grp [get_string GRP_DIAGNOSTICS_SIM_NAME]
   set cal_debug_grp [get_string GRP_DIAGNOSTICS_CAL_DEBUG_NAME]
   set ex_design_grp [get_string GRP_DIAGNOSTICS_EX_DESIGN_NAME]
   set traffic_gen_grp [get_string GRP_DIAGNOSTICS_TRAFFIC_GENERATOR_NAME]
   set performance_grp [get_string GRP_DIAGNOSTICS_PERFORMANCE_NAME]

   add_param_to_gui $sim_grp "${param_prefix}_SIM_CAL_MODE_ENUM"
   add_param_to_gui $sim_grp "${param_prefix}_ABSTRACT_PHY"
   add_param_to_gui $cal_debug_grp "${param_prefix}_EXPORT_SEQ_AVALON_SLAVE"
   add_param_to_gui $cal_debug_grp "DIAG_SOFT_NIOS_MODE"
   add_param_to_gui $cal_debug_grp "${param_prefix}_EXPORT_SEQ_AVALON_MASTER"
   add_param_to_gui $cal_debug_grp "${param_prefix}_INTERFACE_ID"
   add_param_to_gui $ex_design_grp "${param_prefix}_EX_DESIGN_NUM_OF_SLAVES"
   add_param_to_gui $ex_design_grp "${param_prefix}_EX_DESIGN_SEPARATE_RZQS"
   add_param_to_gui $ex_design_grp "${param_prefix}_EX_DESIGN_ISSP_EN"
   add_param_to_gui $performance_grp "${param_prefix}_EFFICIENCY_MONITOR"
   add_param_to_gui $traffic_gen_grp "${param_prefix}_USE_TG_AVL_2"
   add_param_to_gui $traffic_gen_grp "DIAG_TG_AVL_2_EXPORT_CFG_INTERFACE"
   add_param_to_gui $traffic_gen_grp "${param_prefix}_TG_DATA_PATTERN_LENGTH"
   add_param_to_gui $traffic_gen_grp "${param_prefix}_TG_BE_PATTERN_LENGTH"
   add_param_to_gui $traffic_gen_grp "${param_prefix}_BYPASS_DEFAULT_PATTERN"
   add_param_to_gui $traffic_gen_grp "${param_prefix}_BYPASS_USER_STAGE"
   add_param_to_gui $traffic_gen_grp "${param_prefix}_BYPASS_REPEAT_STAGE"
   add_param_to_gui $traffic_gen_grp "${param_prefix}_BYPASS_STRESS_STAGE"

   return 1
}

proc ::altera_emif::ip_top::diag::validate {} {

   ::altera_emif::ip_top::protocol_expert::validate FUNC_DIAG

   set diag_param_prefix [_get_protocol_specific_param_prefix "DIAG"]
   set phy_param_prefix [_get_protocol_specific_param_prefix "PHY"]

   set sim_cal_mode_enum [get_parameter_value "${diag_param_prefix}_SIM_CAL_MODE_ENUM"]
   set use_abstract_phy [get_parameter_value "${diag_param_prefix}_ABSTRACT_PHY"]
   set export_seq_avalon_slave [get_parameter_value "${diag_param_prefix}_EXPORT_SEQ_AVALON_SLAVE"]
   set export_seq_avalon_master [get_parameter_value "${diag_param_prefix}_EXPORT_SEQ_AVALON_MASTER"]
   set ex_design_num_of_slaves [get_parameter_value "${diag_param_prefix}_EX_DESIGN_NUM_OF_SLAVES"]
   set ex_design_separate_rzqs [get_parameter_value "${diag_param_prefix}_EX_DESIGN_SEPARATE_RZQS"]
   set ex_design_issp_en [get_parameter_value "${diag_param_prefix}_EX_DESIGN_ISSP_EN"]
   set efficiency_monitor [get_parameter_value "${diag_param_prefix}_EFFICIENCY_MONITOR"]
   set interface_id [get_parameter_value "${diag_param_prefix}_INTERFACE_ID"]
   set bypass_default_pattern [get_parameter_value "${diag_param_prefix}_BYPASS_DEFAULT_PATTERN"]
   set bypass_user_stage [get_parameter_value "${diag_param_prefix}_BYPASS_USER_STAGE"]
   set bypass_repeat_stage [get_parameter_value "${diag_param_prefix}_BYPASS_REPEAT_STAGE"]
   set bypass_stress_stage [get_parameter_value "${diag_param_prefix}_BYPASS_STRESS_STAGE"]
   set core_clks_sharing_enum [get_parameter_value "${phy_param_prefix}_CORE_CLKS_SHARING_ENUM"]
   set use_soft_nios [expr {[get_parameter_value "DIAG_SOFT_NIOS_MODE"] != "SOFT_NIOS_MODE_DISABLED"}]

   set protocol_enum  [get_parameter_value "PROTOCOL_ENUM"]
   set ping_pong_en [get_parameter_value "PHY_PING_PONG_EN"]

   set use_abstract_phy [get_parameter_value "${diag_param_prefix}_ABSTRACT_PHY"]
   set device_supports_abstract_phy [get_feature_support_level FEATURE_ABSTRACT_PHY $protocol_enum]


   set_parameter_property "${diag_param_prefix}_EX_DESIGN_NUM_OF_SLAVES" ENABLED [expr {$core_clks_sharing_enum != "CORE_CLKS_SHARING_DISABLED"}]
   set_parameter_property "${diag_param_prefix}_EX_DESIGN_SEPARATE_RZQS" ENABLED [expr {$core_clks_sharing_enum != "CORE_CLKS_SHARING_DISABLED"}]
   if {$export_seq_avalon_slave == "CAL_DEBUG_EXPORT_MODE_DISABLED"} {
      set_parameter_property "${diag_param_prefix}_EXPORT_SEQ_AVALON_MASTER" ENABLED false
      set export_seq_avalon_master 0
      set_parameter_property "${diag_param_prefix}_INTERFACE_ID" ENABLED false
   } else {
      set_parameter_property "${diag_param_prefix}_EXPORT_SEQ_AVALON_MASTER" ENABLED true
      set_parameter_property "${diag_param_prefix}_INTERFACE_ID" ENABLED true
   }

   set show_tg_avl_2 true
   set_parameter_property "${diag_param_prefix}_USE_TG_AVL_2" ENABLED [expr { \
      $protocol_enum == "PROTOCOL_DDR3" || $protocol_enum == "PROTOCOL_DDR4" || \
      $protocol_enum == "PROTOCOL_QDR2" || $protocol_enum == "PROTOCOL_QDR4" || \
      $protocol_enum == "PROTOCOL_LPDDR3"}]
   set use_tg_avl_2 [get_parameter_value "${diag_param_prefix}_USE_TG_AVL_2"]
   set_parameter_property "${diag_param_prefix}_TG_DATA_PATTERN_LENGTH" ENABLED $use_tg_avl_2
   set_parameter_property "${diag_param_prefix}_TG_BE_PATTERN_LENGTH" ENABLED $use_tg_avl_2
   set_parameter_property "${diag_param_prefix}_BYPASS_DEFAULT_PATTERN" ENABLED $use_tg_avl_2
   set_parameter_property "${diag_param_prefix}_BYPASS_USER_STAGE" ENABLED $use_tg_avl_2
   set_parameter_property "${diag_param_prefix}_BYPASS_REPEAT_STAGE" ENABLED $use_tg_avl_2
   set_parameter_property "${diag_param_prefix}_BYPASS_STRESS_STAGE" ENABLED $use_tg_avl_2
   set_parameter_property "DIAG_TG_AVL_2_EXPORT_CFG_INTERFACE" ENABLED $use_tg_avl_2

   set_parameter_property "${diag_param_prefix}_USE_TG_AVL_2" VISIBLE $show_tg_avl_2
   set_parameter_property "${diag_param_prefix}_TG_DATA_PATTERN_LENGTH" VISIBLE false
   set_parameter_property "${diag_param_prefix}_TG_BE_PATTERN_LENGTH" VISIBLE false
   set_parameter_property "${diag_param_prefix}_BYPASS_DEFAULT_PATTERN" VISIBLE $show_tg_avl_2
   set_parameter_property "${diag_param_prefix}_BYPASS_USER_STAGE" VISIBLE $show_tg_avl_2
   set_parameter_property "${diag_param_prefix}_BYPASS_REPEAT_STAGE" VISIBLE $show_tg_avl_2
   set_parameter_property "${diag_param_prefix}_BYPASS_STRESS_STAGE" VISIBLE $show_tg_avl_2

   if {[get_is_hps]} {
      post_ipgen_i_msg MSG_DEBUG_NOT_SUPPORTED_FOR_HPS
      set_parameter_property "${diag_param_prefix}_EXPORT_SEQ_AVALON_SLAVE" ENABLED false
      set_parameter_property "${diag_param_prefix}_EXPORT_SEQ_AVALON_MASTER" ENABLED false
      set_parameter_property "${diag_param_prefix}_INTERFACE_ID" ENABLED false
      set_parameter_property "DIAG_SOFT_NIOS_MODE" ENABLED false
   }

   set config_enum                  [get_parameter_value "PHY_CONFIG_ENUM"]
   if {$config_enum == "CONFIG_PHY_ONLY" && $efficiency_monitor != "EFFMON_MODE_DISABLED"} {
      post_ipgen_e_msg MSG_EFFICIENCY_MONITOR_NOT_SUPPORTED_FOR_PHY_ONLY
   }

   if {[get_parameter_value DIAG_BYPASS_DEFAULT_PATTERN] == "true" && [get_parameter_value DIAG_BYPASS_USER_STAGE] == "true" && [get_parameter_value DIAG_BYPASS_REPEAT_STAGE] == "true" && [get_parameter_value DIAG_BYPASS_STRESS_STAGE] == "true"} {
      post_ipgen_e_msg MSG_TG_AVL_2_CANNOT_BYPASS_ALL_STAGES
   }

   if {[get_parameter_value DIAG_ENABLE_JTAG_UART] == "false" && [get_parameter_value DIAG_ENABLE_JTAG_UART_HEX] == "true"} {
      post_ipgen_w_msg MSG_JTAG_UART_PARAMETER_MISMATCH
   }

   if {[get_parameter_value DIAG_ENABLE_JTAG_UART] == "true" && [get_parameter_value DIAG_ENABLE_HPS_EMIF_DEBUG] == "true"} {
      post_ipgen_e_msg MSG_HPS_ILLEGAL_DEBUG_CONFIGURATION
   }


   if {$use_soft_nios && $export_seq_avalon_slave == "CAL_DEBUG_EXPORT_MODE_DISABLED"} {
      post_ipgen_e_msg MSG_SOFT_NIOS_REQUIRES_ON_CHIP_DEBUG_PORT
   }

   set_parameter_value DIAG_SIM_CAL_MODE_ENUM $sim_cal_mode_enum
   set_parameter_value DIAG_EXPORT_SEQ_AVALON_SLAVE $export_seq_avalon_slave
   set_parameter_value DIAG_EXPORT_SEQ_AVALON_MASTER $export_seq_avalon_master
   set_parameter_value DIAG_EX_DESIGN_NUM_OF_SLAVES $ex_design_num_of_slaves
   set_parameter_value DIAG_EX_DESIGN_SEPARATE_RZQS $ex_design_separate_rzqs
   set_parameter_value DIAG_EX_DESIGN_ISSP_EN $ex_design_issp_en
   set_parameter_value DIAG_INTERFACE_ID $interface_id
   set_parameter_value DIAG_EFFICIENCY_MONITOR $efficiency_monitor
   set_parameter_value DIAG_USE_TG_AVL_2 $use_tg_avl_2
   set_parameter_value DIAG_BYPASS_DEFAULT_PATTERN $bypass_default_pattern
   set_parameter_value DIAG_BYPASS_USER_STAGE $bypass_user_stage
   set_parameter_value DIAG_BYPASS_REPEAT_STAGE $bypass_repeat_stage
   set_parameter_value DIAG_BYPASS_STRESS_STAGE $bypass_stress_stage
   set_parameter_value DIAG_TG_DATA_PATTERN_LENGTH [get_parameter_value "${diag_param_prefix}_TG_DATA_PATTERN_LENGTH"]
   set_parameter_value DIAG_TG_BE_PATTERN_LENGTH [get_parameter_value "${diag_param_prefix}_TG_BE_PATTERN_LENGTH"]

   set force_no_soft_m20k [::altera_emif::util::qini::ini_is_on "emif_force_no_soft_m20k"]
   set device_supports_soft_m20k [get_feature_support_level FEATURE_SEQ_SOFT_M20K PROTOCOL_INVALID]
   set_parameter_value DIAG_ENABLE_SOFT_M20K [expr {$device_supports_soft_m20k && !$force_no_soft_m20k}]

   if {[string compare -nocase [get_parameter_value DIAG_FAST_SIM_OVERRIDE] "FAST_SIM_OVERRIDE_ENABLED"] == 0} {
      set_parameter_value DIAG_FAST_SIM true
   } elseif {[string compare -nocase [get_parameter_value DIAG_FAST_SIM_OVERRIDE] "FAST_SIM_OVERRIDE_DISABLED"] == 0} {
      set_parameter_value DIAG_FAST_SIM false
   } else {

      if {[get_parameter_value PLL_NUM_OF_EXTRA_CLKS] > 0 } {

         set_parameter_value DIAG_FAST_SIM false
         post_ipgen_i_msg MSG_FAST_SIM_DISABLED_BY_EXTRA_CORE_CLKS

      } elseif {$sim_cal_mode_enum != "SIM_CAL_MODE_SKIP"} {

         set_parameter_value DIAG_FAST_SIM false
         post_ipgen_i_msg MSG_FAST_SIM_DISABLED_BY_NON_SKIP_CAL

      } else {
         set_parameter_value DIAG_FAST_SIM true
      }
   }

   if {!$device_supports_abstract_phy} {
      set_parameter_property "${diag_param_prefix}_ABSTRACT_PHY" VISIBLE false
   } else {
      set_parameter_property "${diag_param_prefix}_ABSTRACT_PHY" VISIBLE true
   }
   set_parameter_value DIAG_USE_ABSTRACT_PHY [expr {$use_abstract_phy && $device_supports_abstract_phy}]
   if {$use_abstract_phy} {
      if {$sim_cal_mode_enum != "SIM_CAL_MODE_SKIP"} {
         post_ipgen_e_msg MSG_ABSTRACT_PHY_SUPPORTED_ONLY_FOR_SKIP_CAL
      }
   }

   set_parameter_property "${diag_param_prefix}_SEPARATE_READ_WRITE_ITFS" VISIBLE false


   return 1

}


proc ::altera_emif::ip_top::diag::_get_protocol_specific_param_prefix {package_prefix} {
   set protocol_enum  [get_parameter_value "PROTOCOL_ENUM"]
   set module_name    [string toupper [enum_data $protocol_enum MODULE_NAME]]
   return "${package_prefix}_${module_name}"
}

proc ::altera_emif::ip_top::diag::_init {} {
}

::altera_emif::ip_top::diag::_init
