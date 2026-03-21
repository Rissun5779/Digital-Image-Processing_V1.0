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


package provide altera_emif::ip_top::phy 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::device_family
package require altera_emif::util::arch_expert
package require altera_emif::ip_top::protocol_expert
package require altera_emif::ip_top::vg_autogen
package require altera_iopll_common::iopll

namespace eval ::altera_emif::ip_top::phy:: {

   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_iopll_common::iopll::*


}


proc ::altera_emif::ip_top::phy::create_parameters {is_top_level_component} {

   add_derived_param  PHY_FPGA_SPEEDGRADE_GUI                 string     ""         true      ""           ""            ""            ""
   add_derived_param  PHY_TARGET_SPEEDGRADE                   string     ""         false     ""           ""            ""            ""
   add_derived_param  PHY_TARGET_IS_ES                        boolean    false      false     ""           ""            ""            ""
   add_derived_param  PHY_TARGET_IS_ES2                       boolean    false      false     ""           ""            ""            ""
   add_derived_param  PHY_TARGET_IS_ES3                       boolean    false      false     ""           ""            ""            ""
   add_derived_param  PHY_TARGET_IS_PRODUCTION                boolean    true       false     ""           ""            ""            ""
   add_derived_param  PHY_CONFIG_ENUM                         string     ""         false     ""           ""            ""            ""
   add_derived_param  PHY_PING_PONG_EN                        boolean    false      false     ""           ""            ""            ""
   add_derived_param  PHY_RATE_ENUM                           string     ""         false     ""           ""            ""            ""
   add_derived_param  PHY_MEM_CLK_FREQ_MHZ                    float      -1         false     "MEGAHERTZ"  ""            ""            ""
   add_derived_param  PHY_REF_CLK_FREQ_MHZ                    float      -1         false     "MEGAHERTZ"  ""            ""            ""
   add_derived_param  PHY_REF_CLK_JITTER_PS                   float      -1         false     "Picoseconds" ""           ""            ""
   add_derived_param  PHY_CORE_CLKS_SHARING_ENUM              string     ""         false     ""           ""            ""            ""
   add_derived_param  PHY_CALIBRATED_OCT                      boolean    false      false     ""           ""            ""            ""
   add_derived_param  PHY_AC_CALIBRATED_OCT                   boolean    false      false     ""           ""            ""            ""
   add_derived_param  PHY_CK_CALIBRATED_OCT                   boolean    false      false     ""           ""            ""            ""
   add_derived_param  PHY_DATA_CALIBRATED_OCT                 boolean    false      false     ""           ""            ""            ""
   add_derived_param  PHY_RZQ                                 integer    0          true      ""           "Ohm"         ""            ""
   add_derived_param  PHY_HPS_ENABLE_EARLY_RELEASE            boolean    false      false     ""           ""            ""            ""
   add_derived_param  PHY_USER_PERIODIC_OCT_RECAL_ENUM        string     ""         false     ""           ""            ""            ""

   add_derived_param  PLL_VCO_CLK_FREQ_MHZ                    string     "0 ps"     false     ""           ""            ""            ""
   add_derived_param  PLL_SPEEDGRADE                          string     "1"        false     ""           ""            ""            ""
   add_derived_param  PLL_DISALLOW_EXTRA_CLKS                 string     "false"    false     ""           ""            ""            ""
   add_derived_param  PLL_NUM_OF_EXTRA_CLKS                   integer    0          false     ""           ""            ""            ""


   ::altera_iopll_common::iopll::set_sys_info_device_family     SYS_INFO_DEVICE_FAMILY
   ::altera_iopll_common::iopll::set_sys_info_device            SYS_INFO_DEVICE
   ::altera_iopll_common::iopll::set_sys_info_device_speedgrade PLL_SPEEDGRADE
   ::altera_iopll_common::iopll::set_reference_clock_frequency  PHY_REF_CLK_FREQ_MHZ
   ::altera_iopll_common::iopll::set_vco_frequency              PLL_VCO_CLK_FREQ_MHZ
   ::altera_iopll_common::iopll::set_external_pll_mode          PLL_DISALLOW_EXTRA_CLKS
   ::altera_iopll_common::iopll::declare_pll_parameters

   set_parameter_property PLL_ADD_EXTRA_CLKS         DISPLAY_NAME [get_string PARAM_PLL_ADD_EXTRA_CLKS_NAME]
   set_parameter_property PLL_ADD_EXTRA_CLKS         DESCRIPTION  [get_string PARAM_PLL_ADD_EXTRA_CLKS_DESC]
   set_parameter_property PLL_USER_NUM_OF_EXTRA_CLKS DISPLAY_NAME [get_string PARAM_PLL_USER_NUM_OF_EXTRA_CLKS_NAME]
   set_parameter_property PLL_USER_NUM_OF_EXTRA_CLKS DESCRIPTION  [get_string PARAM_PLL_USER_NUM_OF_EXTRA_CLKS_DESC]

   ::altera_emif::ip_top::protocol_expert::create_parameters FUNC_PHY $is_top_level_component

   return 1
}

proc ::altera_emif::ip_top::phy::create_io_parameters {param_prefix} {

   add_user_param     "${param_prefix}_USER_AC_IO_STD_ENUM"           string    "unset"                      {"unset"}                                  ""           ""             ""             PHY_AC_IO_STD_ENUM
   add_user_param     "${param_prefix}_USER_AC_MODE_ENUM"             string    "unset"                      {"unset"}                                  ""           ""             ""             PHY_AC_MODE_ENUM
   add_user_param     "${param_prefix}_USER_AC_SLEW_RATE_ENUM"        string    SLEW_RATE_FAST               [enum_dropdown_entries SLEW_RATE]          ""           ""             ""             PHY_AC_SLEW_RATE_ENUM
   add_user_param     "${param_prefix}_USER_CK_IO_STD_ENUM"           string    "unset"                      {"unset"}                                  ""           ""             ""             PHY_CK_IO_STD_ENUM
   add_user_param     "${param_prefix}_USER_CK_MODE_ENUM"             string    "unset"                      {"unset"}                                  ""           ""             ""             PHY_CK_MODE_ENUM
   add_user_param     "${param_prefix}_USER_CK_SLEW_RATE_ENUM"        string    SLEW_RATE_FAST               [enum_dropdown_entries SLEW_RATE]          ""           ""             ""             PHY_CK_SLEW_RATE_ENUM
   add_user_param     "${param_prefix}_USER_DATA_IO_STD_ENUM"         string    "unset"                      {"unset"}                                  ""           ""             ""             PHY_DATA_IO_STD_ENUM
   add_user_param     "${param_prefix}_USER_DATA_OUT_MODE_ENUM"       string    "unset"                      {"unset"}                                  ""           ""             ""             PHY_DATA_OUT_MODE_ENUM
   add_user_param     "${param_prefix}_USER_DATA_IN_MODE_ENUM"        string    "unset"                      {"unset"}                                  ""           ""             ""             PHY_DATA_IN_MODE_ENUM
   add_user_param     "${param_prefix}_USER_AUTO_STARTING_VREFIN_EN"  boolean   true                         ""                                         ""           ""             ""             PHY_AUTO_STARTING_VREFIN_EN
   add_user_param     "${param_prefix}_USER_STARTING_VREFIN"          float     70                           ""                                         ""           "%"            ""             PHY_STARTING_VREFIN
   add_user_param     "${param_prefix}_USER_PLL_REF_CLK_IO_STD_ENUM"  string    "unset"                      {"unset"}                                  ""           ""             ""             PHY_PLL_REF_CLK_IO_STD_ENUM
   add_user_param     "${param_prefix}_USER_RZQ_IO_STD_ENUM"          string    "unset"                      {"unset"}                                  ""           ""             ""             PHY_RZQ_IO_STD_ENUM

   add_derived_param  "${param_prefix}_AC_IO_STD_ENUM"                string    "unset"          true        ""           ""           ""             PHY_AC_IO_STD_ENUM
   add_derived_param  "${param_prefix}_AC_MODE_ENUM"                  string    "unset"          true        ""           ""           ""             PHY_AC_MODE_ENUM
   add_derived_param  "${param_prefix}_AC_SLEW_RATE_ENUM"             string    SLEW_RATE_FAST   true        ""           ""           ""             PHY_AC_SLEW_RATE_ENUM
   add_derived_param  "${param_prefix}_CK_IO_STD_ENUM"                string    "unset"          true        ""           ""           ""             PHY_CK_IO_STD_ENUM
   add_derived_param  "${param_prefix}_CK_MODE_ENUM"                  string    "unset"          true        ""           ""           ""             PHY_CK_MODE_ENUM
   add_derived_param  "${param_prefix}_CK_SLEW_RATE_ENUM"             string    SLEW_RATE_FAST   true        ""           ""           ""             PHY_CK_SLEW_RATE_ENUM
   add_derived_param  "${param_prefix}_DATA_IO_STD_ENUM"              string    "unset"          true        ""           ""           ""             PHY_DATA_IO_STD_ENUM
   add_derived_param  "${param_prefix}_DATA_OUT_MODE_ENUM"            string    "unset"          true        ""           ""           ""             PHY_DATA_OUT_MODE_ENUM
   add_derived_param  "${param_prefix}_DATA_IN_MODE_ENUM"             string    "unset"          true        ""           ""           ""             PHY_DATA_IN_MODE_ENUM
   add_derived_param  "${param_prefix}_AUTO_STARTING_VREFIN_EN"       boolean   true             false       ""           ""           ""             PHY_AUTO_STARTING_VREFIN_EN
   add_derived_param  "${param_prefix}_STARTING_VREFIN"               float     70               true        ""           "%"          ""             PHY_STARTING_VREFIN
   add_derived_param  "${param_prefix}_PLL_REF_CLK_IO_STD_ENUM"       string    "unset"          true        ""           ""           ""             PHY_PLL_REF_CLK_IO_STD_ENUM
   add_derived_param  "${param_prefix}_RZQ_IO_STD_ENUM"               string    "unset"          true        ""           ""           ""             PHY_RZQ_IO_STD_ENUM

   set_parameter_property "${param_prefix}_AC_IO_STD_ENUM"            ALLOWED_RANGES {"unset"}
   set_parameter_property "${param_prefix}_AC_MODE_ENUM"              ALLOWED_RANGES {"unset"}
   set_parameter_property "${param_prefix}_AC_SLEW_RATE_ENUM"         ALLOWED_RANGES [enum_dropdown_entries SLEW_RATE]
   set_parameter_property "${param_prefix}_CK_IO_STD_ENUM"            ALLOWED_RANGES {"unset"}
   set_parameter_property "${param_prefix}_CK_MODE_ENUM"              ALLOWED_RANGES {"unset"}
   set_parameter_property "${param_prefix}_CK_SLEW_RATE_ENUM"         ALLOWED_RANGES [enum_dropdown_entries SLEW_RATE]
   set_parameter_property "${param_prefix}_DATA_IO_STD_ENUM"          ALLOWED_RANGES {"unset"}
   set_parameter_property "${param_prefix}_DATA_OUT_MODE_ENUM"        ALLOWED_RANGES {"unset"}
   set_parameter_property "${param_prefix}_DATA_IN_MODE_ENUM"         ALLOWED_RANGES {"unset"}
   set_parameter_property "${param_prefix}_PLL_REF_CLK_IO_STD_ENUM"   ALLOWED_RANGES {"unset"}
   set_parameter_property "${param_prefix}_RZQ_IO_STD_ENUM"           ALLOWED_RANGES {"unset"}
}

proc ::altera_emif::ip_top::phy::set_family_specific_defaults {family_enum base_family_enum is_hps} {



   ::altera_emif::ip_top::protocol_expert::set_family_specific_defaults FUNC_PHY $family_enum $base_family_enum $is_hps

   return 1
}

proc ::altera_emif::ip_top::phy::add_display_items {tabs} {

   set phy_tab [lindex $tabs 0]
   set io_tab [lindex $tabs 1]

   set fpga_grp            [get_string GRP_PHY_FPGA_NAME]
   set if_grp              [get_string GRP_PHY_IF_NAME]
   set clk_grp             [get_string GRP_PHY_CLKS_NAME]
   set hps_grp             [get_string GRP_PHY_HPS_NAME]
   set io_grp              [get_string GRP_PHY_IO_NAME]
   set ac_io_grp           [get_string GRP_PHY_AC_IO_NAME]
   set ck_io_grp           [get_string GRP_PHY_CK_IO_NAME]
   set data_io_grp         [get_string GRP_PHY_DATA_IO_NAME]
   set fpga_io_grp         [get_string GRP_PHY_FPGA_IO_NAME]

   add_display_item $phy_tab $fpga_grp GROUP
   add_param_to_gui $fpga_grp PHY_FPGA_SPEEDGRADE_GUI

   add_display_item $phy_tab $if_grp   GROUP
   add_display_item $phy_tab $clk_grp  GROUP
   add_display_item $phy_tab $hps_grp  GROUP

   add_text_to_gui  $io_tab "PHY_IO_TOP_TXT" [get_string TXT_IO_RECOMMENDATION]
   add_display_item $io_tab $io_grp GROUP

   foreach protocol_enum [enums_of_type PROTOCOL] {

      if {$protocol_enum == "PROTOCOL_INVALID"} {
         continue
      }

      set module_name    [string toupper [enum_data $protocol_enum MODULE_NAME]]
      set param_prefix   "PHY_${module_name}"

      add_param_to_gui $if_grp       "${param_prefix}_CONFIG_ENUM"
      add_param_to_gui $if_grp       "${param_prefix}_PING_PONG_EN"
      add_param_to_gui $if_grp       "${param_prefix}_USER_PING_PONG_EN"

      add_param_to_gui $clk_grp      "${param_prefix}_MEM_CLK_FREQ_MHZ"
      add_param_to_gui $clk_grp      "${param_prefix}_DEFAULT_REF_CLK_FREQ"
      add_param_to_gui $clk_grp      "${param_prefix}_REF_CLK_FREQ_MHZ"
      add_param_to_gui $clk_grp      "${param_prefix}_USER_REF_CLK_FREQ_MHZ"
      add_param_to_gui $clk_grp      "${param_prefix}_REF_CLK_JITTER_PS"
      add_param_to_gui $clk_grp      "${param_prefix}_RATE_ENUM"
      add_param_to_gui $clk_grp      "${param_prefix}_CORE_CLKS_SHARING_ENUM"

      add_param_to_gui $hps_grp      "${param_prefix}_HPS_ENABLE_EARLY_RELEASE"

      add_param_to_gui $io_grp       "${param_prefix}_IO_VOLTAGE"
      add_param_to_gui $io_grp       "${param_prefix}_USER_PERIODIC_OCT_RECAL_ENUM"
      add_param_to_gui $io_grp       "${param_prefix}_DEFAULT_IO"
   }

   add_display_item $io_grp  $ac_io_grp          GROUP
   add_display_item $io_grp  $ck_io_grp          GROUP
   add_display_item $io_grp  $data_io_grp        GROUP
   add_display_item $io_grp  $fpga_io_grp        GROUP

   foreach protocol_enum [enums_of_type PROTOCOL] {

      if {$protocol_enum == "PROTOCOL_INVALID"} {
         continue
      }

      set module_name    [string toupper [enum_data $protocol_enum MODULE_NAME]]
      set param_prefix   "PHY_${module_name}"

      add_param_to_gui $ac_io_grp          "${param_prefix}_USER_AC_IO_STD_ENUM"
      add_param_to_gui $ac_io_grp          "${param_prefix}_USER_AC_MODE_ENUM"
      add_param_to_gui $ac_io_grp          "${param_prefix}_USER_AC_SLEW_RATE_ENUM"
      add_param_to_gui $ck_io_grp          "${param_prefix}_USER_CK_IO_STD_ENUM"
      add_param_to_gui $ck_io_grp          "${param_prefix}_USER_CK_MODE_ENUM"
      add_param_to_gui $ck_io_grp          "${param_prefix}_USER_CK_SLEW_RATE_ENUM"
      add_param_to_gui $data_io_grp        "${param_prefix}_USER_DATA_IO_STD_ENUM"
      add_param_to_gui $data_io_grp        "${param_prefix}_USER_DATA_OUT_MODE_ENUM"
      add_param_to_gui $data_io_grp        "${param_prefix}_USER_DATA_IN_MODE_ENUM"
      add_param_to_gui $data_io_grp        "${param_prefix}_USER_AUTO_STARTING_VREFIN_EN"
      add_param_to_gui $data_io_grp        "${param_prefix}_USER_STARTING_VREFIN"
      add_param_to_gui $fpga_io_grp        "${param_prefix}_USER_PLL_REF_CLK_IO_STD_ENUM"
      add_param_to_gui $fpga_io_grp        "${param_prefix}_USER_RZQ_IO_STD_ENUM"

      add_param_to_gui $ac_io_grp          "${param_prefix}_AC_IO_STD_ENUM"
      add_param_to_gui $ac_io_grp          "${param_prefix}_AC_MODE_ENUM"
      add_param_to_gui $ac_io_grp          "${param_prefix}_AC_SLEW_RATE_ENUM"
      add_param_to_gui $ck_io_grp          "${param_prefix}_CK_IO_STD_ENUM"
      add_param_to_gui $ck_io_grp          "${param_prefix}_CK_MODE_ENUM"
      add_param_to_gui $ck_io_grp          "${param_prefix}_CK_SLEW_RATE_ENUM"
      add_param_to_gui $data_io_grp        "${param_prefix}_DATA_IO_STD_ENUM"
      add_param_to_gui $data_io_grp        "${param_prefix}_DATA_OUT_MODE_ENUM"
      add_param_to_gui $data_io_grp        "${param_prefix}_DATA_IN_MODE_ENUM"
      add_param_to_gui $data_io_grp        "${param_prefix}_AUTO_STARTING_VREFIN_EN"
      add_param_to_gui $data_io_grp        "${param_prefix}_STARTING_VREFIN"
      add_param_to_gui $fpga_io_grp        "${param_prefix}_PLL_REF_CLK_IO_STD_ENUM"
      add_param_to_gui $fpga_io_grp        "${param_prefix}_RZQ_IO_STD_ENUM"
   }

   add_param_to_gui $fpga_io_grp PHY_RZQ

   ::altera_emif::ip_top::protocol_expert::add_display_items FUNC_PHY $tabs

   ::altera_iopll_common::iopll::declare_pll_display_items $clk_grp

   return 1
}

proc ::altera_emif::ip_top::phy::validate {} {

   _reset_allowed_ranges_to_ensure_legality

   ::altera_emif::ip_top::protocol_expert::validate FUNC_PHY

   set param_prefix [_get_protocol_specific_param_prefix]

   set is_hps                    [get_is_hps]
   set protocol_enum             [get_parameter_value "PROTOCOL_ENUM"]
   set config_enum               [get_parameter_value "${param_prefix}_CONFIG_ENUM"]
   set rate_enum                 [get_parameter_value "${param_prefix}_RATE_ENUM"]
   set mem_clk_freq_mhz          [get_parameter_value "${param_prefix}_MEM_CLK_FREQ_MHZ"]
   set core_clks_sharing_enum    [get_parameter_value "${param_prefix}_CORE_CLKS_SHARING_ENUM"]
   set default_ref_clk_freq      [get_parameter_value "${param_prefix}_DEFAULT_REF_CLK_FREQ"]
   set hps_early_release         [get_parameter_value "${param_prefix}_HPS_ENABLE_EARLY_RELEASE"]
   set periodic_oct_recal_enum   [get_parameter_value "${param_prefix}_USER_PERIODIC_OCT_RECAL_ENUM"]

   _update_fpga_device_info

   set_parameter_property "${param_prefix}_REF_CLK_FREQ_MHZ"      VISIBLE [expr {$default_ref_clk_freq}]
   set_parameter_property "${param_prefix}_USER_REF_CLK_FREQ_MHZ" VISIBLE [expr {!$default_ref_clk_freq}]

   set show_ctrl_tab [expr {$config_enum == "CONFIG_PHY_ONLY" ? "false" : "true"}]
   set_display_item_property [get_string TAB_CONTROLLER_NAME] VISIBLE $show_ctrl_tab

   set range [::altera_emif::ip_top::util::get_dropdown_entries FEATURE_CONFIG $protocol_enum]
   set_parameter_property "${param_prefix}_CONFIG_ENUM" ALLOWED_RANGES $range

   _validate_ping_pong_en $param_prefix $protocol_enum $config_enum
   
   set_parameter_property "${param_prefix}_USER_PERIODIC_OCT_RECAL_ENUM" VISIBLE [get_feature_support_level FEATURE_PERIODIC_OCT_RECAL $protocol_enum RATE_INVALID]
   
   set range [::altera_emif::ip_top::util::get_dropdown_entries FEATURE_RATE $protocol_enum]
   set_parameter_property "${param_prefix}_RATE_ENUM" ALLOWED_RANGES $range

   set fmax_mhz [get_feature_support_level FEATURE_FMAX_MHZ $protocol_enum $rate_enum]
   set fmin_mhz [get_feature_support_level FEATURE_FMIN_MHZ $protocol_enum $rate_enum]

   if {![::altera_emif::util::qini::ini_is_on "emif_show_internal_settings"] && ![get_parameter_value "INTERNAL_TESTING_MODE"]} {
      if {$mem_clk_freq_mhz > $fmax_mhz} {
         post_ipgen_e_msg MSG_EXCEEDED_FMAX_OF_RATE [list $fmax_mhz [enum_data $rate_enum UI_NAME]]
      }
   }
   if {$mem_clk_freq_mhz < $fmin_mhz} {
      post_ipgen_e_msg MSG_BELOW_FMIN_OF_RATE [list $fmin_mhz [enum_data $rate_enum UI_NAME]]
   }

   set speedgrade  [get_speedgrade]
   set fmin_lookup [get_family_trait FAMILY_TRAIT_IF_FMIN_MHZ]
   set fmax_lookup [get_family_trait FAMILY_TRAIT_IF_FMAX_MHZ]

   set fmin_mhz [dict get $fmin_lookup $speedgrade]
   set fmax_mhz [dict get $fmax_lookup $speedgrade]

   if {$mem_clk_freq_mhz < $fmin_mhz} {
      post_ipgen_e_msg MSG_BELOW_ARCH_FMIN [list $fmin_mhz]
   } elseif {$mem_clk_freq_mhz > $fmax_mhz} {
      post_ipgen_e_msg MSG_ABOVE_ARCH_FMAX [list $fmax_mhz]
   } else {
      set_parameter_value  PHY_CONFIG_ENUM                   $config_enum
      set_parameter_value  PHY_RATE_ENUM                     $rate_enum
      set_parameter_value  PHY_MEM_CLK_FREQ_MHZ              $mem_clk_freq_mhz
      set_parameter_value  PHY_CORE_CLKS_SHARING_ENUM        $core_clks_sharing_enum
      set_parameter_value  PHY_USER_PERIODIC_OCT_RECAL_ENUM  $periodic_oct_recal_enum

      if {[_validate_ref_clk_freq $param_prefix]} {

         _validate_pll $param_prefix
      }
   }

   if {$is_hps} {
      set_parameter_property "${param_prefix}_CORE_CLKS_SHARING_ENUM" VISIBLE false
      emif_assert {[string compare $core_clks_sharing_enum "CORE_CLKS_SHARING_DISABLED"] == 0}
   } else {
      set_parameter_property "${param_prefix}_CORE_CLKS_SHARING_ENUM" VISIBLE true
   }

   if ${is_hps} {
      set_parameter_property "${param_prefix}_HPS_ENABLE_EARLY_RELEASE" VISIBLE true

      if {$hps_early_release && [get_is_es]} {
         post_ipgen_e_msg MSG_HPS_EARLY_RELEASE_PROD_ONLY
      }

      set_parameter_value PHY_HPS_ENABLE_EARLY_RELEASE $hps_early_release

   } else {
      set_parameter_property "${param_prefix}_HPS_ENABLE_EARLY_RELEASE" VISIBLE false
      emif_assert {!$hps_early_release}
      set_parameter_value PHY_HPS_ENABLE_EARLY_RELEASE false
   }
   
   _validate_io $param_prefix

   return 1
}

proc ::altera_emif::ip_top::phy::autogen_xml {} {

   _reset_allowed_ranges_to_ensure_legality

   ::altera_emif::ip_top::protocol_expert::validate FUNC_PHY

   set param_prefix [_get_protocol_specific_param_prefix]

   set is_hps                    [get_is_hps]
   set protocol_enum             [get_parameter_value "PROTOCOL_ENUM"]
   set config_enum               [get_parameter_value "${param_prefix}_CONFIG_ENUM"]
   set rate_enum                 [get_parameter_value "${param_prefix}_RATE_ENUM"]
   set mem_clk_freq_mhz          [get_parameter_value "${param_prefix}_MEM_CLK_FREQ_MHZ"]
   set core_clks_sharing_enum    [get_parameter_value "${param_prefix}_CORE_CLKS_SHARING_ENUM"]
   set default_ref_clk_freq      [get_parameter_value "${param_prefix}_DEFAULT_REF_CLK_FREQ"]

   _update_fpga_device_info

   set_parameter_property "${param_prefix}_REF_CLK_FREQ_MHZ"      VISIBLE [expr {$default_ref_clk_freq}]
   set_parameter_property "${param_prefix}_USER_REF_CLK_FREQ_MHZ" VISIBLE [expr {!$default_ref_clk_freq}]

   set show_ctrl_tab [expr {$config_enum == "CONFIG_PHY_ONLY" ? "false" : "true"}]
   set_display_item_property [get_string TAB_CONTROLLER_NAME] VISIBLE $show_ctrl_tab

   ::altera_emif::ip_top::vg_autogen::generate_xml

}


proc ::altera_emif::ip_top::phy::_get_protocol_specific_param_prefix {} {
   set protocol_enum  [get_parameter_value "PROTOCOL_ENUM"]
   set module_name    [string toupper [enum_data $protocol_enum MODULE_NAME]]
   return "PHY_${module_name}"
}

proc ::altera_emif::ip_top::phy::_update_fpga_device_info {} {
   if {[get_device] == ""} {
      set speedgrade "Unknown - specify device under 'View'->'Device Family'"

      set_parameter_value PHY_TARGET_SPEEDGRADE ""
      set_parameter_value PHY_TARGET_IS_ES false
      set_parameter_value PHY_TARGET_IS_ES2 false
      set_parameter_value PHY_TARGET_IS_ES3 false
      set_parameter_value PHY_TARGET_IS_PRODUCTION true

   } else {
      set speedgrade [get_speedgrade]
      set_parameter_value PHY_TARGET_SPEEDGRADE $speedgrade

      if {[get_is_es]} {
         set speedgrade "$speedgrade (ES)"
         set_parameter_value PHY_TARGET_IS_ES true
         set_parameter_value PHY_TARGET_IS_ES2 false
         set_parameter_value PHY_TARGET_IS_ES3 false
         set_parameter_value PHY_TARGET_IS_PRODUCTION false
      } elseif {[get_is_es2]} {
         set speedgrade "$speedgrade (ES2)"
         set_parameter_value PHY_TARGET_IS_ES false
         set_parameter_value PHY_TARGET_IS_ES2 true
         set_parameter_value PHY_TARGET_IS_ES3 false
         set_parameter_value PHY_TARGET_IS_PRODUCTION false
      } elseif {[get_is_es3]} {
         set speedgrade "$speedgrade (ES3)"
         set_parameter_value PHY_TARGET_IS_ES false
         set_parameter_value PHY_TARGET_IS_ES2 false
         set_parameter_value PHY_TARGET_IS_ES3 true
         set_parameter_value PHY_TARGET_IS_PRODUCTION false
      } else {
         set speedgrade "$speedgrade (Production)"
         set_parameter_value PHY_TARGET_IS_ES false
         set_parameter_value PHY_TARGET_IS_ES2 false
         set_parameter_value PHY_TARGET_IS_ES3 false
         set_parameter_value PHY_TARGET_IS_PRODUCTION true
      }

      set speedgrade "$speedgrade - change device under 'View'->'Device Family'"
   }
   set_parameter_value PHY_FPGA_SPEEDGRADE_GUI $speedgrade
}

proc ::altera_emif::ip_top::phy::_validate_ref_clk_freq {param_prefix} {

   set is_legal 1

   set default_ref_clk_freq [get_parameter_value "${param_prefix}_DEFAULT_REF_CLK_FREQ"]

   if {$default_ref_clk_freq} {
      set legal_ref_freqs [altera_emif::util::arch_expert::get_legal_pll_ref_clk_freqs_mhz 1]
      set ref_clk_freq_mhz [lindex $legal_ref_freqs 0]
   } else {
      set ref_clk_freq_mhz [get_parameter_value "${param_prefix}_USER_REF_CLK_FREQ_MHZ"]
      set legal_ref_freqs  [altera_emif::util::arch_expert::get_legal_pll_ref_clk_freqs_mhz 20]

      if {[lsearch -exact -real $legal_ref_freqs $ref_clk_freq_mhz] == -1} {
         set is_legal 0
         lappend legal_ref_freqs "${ref_clk_freq_mhz}:${ref_clk_freq_mhz} (Invalid)"
         post_ipgen_e_msg MSG_INVALID_PLL_REF_CLK_FREQ [list $ref_clk_freq_mhz]
      }
      set_parameter_property "${param_prefix}_USER_REF_CLK_FREQ_MHZ" ALLOWED_RANGES $legal_ref_freqs
   }

   set_parameter_value "${param_prefix}_REF_CLK_FREQ_MHZ" $ref_clk_freq_mhz
   set_parameter_value  PHY_REF_CLK_FREQ_MHZ $ref_clk_freq_mhz

   set_parameter_value PHY_REF_CLK_JITTER_PS [get_parameter_value "${param_prefix}_REF_CLK_JITTER_PS"]

   return $is_legal
}

proc ::altera_emif::ip_top::phy::_validate_ping_pong_en {param_prefix protocol_enum config_enum} {

   set support_ping_pong [get_feature_support_level FEATURE_PING_PONG $protocol_enum]

   if {$support_ping_pong} {
      if {$config_enum == "CONFIG_PHY_AND_HARD_CTRL"} {
         set_parameter_property "${param_prefix}_USER_PING_PONG_EN" VISIBLE true
         set_parameter_property "${param_prefix}_PING_PONG_EN"      VISIBLE false
         set ping_pong_en [get_parameter_value "${param_prefix}_USER_PING_PONG_EN"]
      } else {
         set_parameter_property "${param_prefix}_USER_PING_PONG_EN" VISIBLE false
         set_parameter_property "${param_prefix}_PING_PONG_EN"      VISIBLE true
         set ping_pong_en false
      }
   } else {
      set_parameter_property "${param_prefix}_USER_PING_PONG_EN" VISIBLE false
      set_parameter_property "${param_prefix}_PING_PONG_EN"      VISIBLE false
      set ping_pong_en false
   }

   set_parameter_value "${param_prefix}_PING_PONG_EN" $ping_pong_en

   set_parameter_value PHY_PING_PONG_EN $ping_pong_en
}

proc ::altera_emif::ip_top::phy::_validate_io {param_prefix} {

   set is_legal 1

   set setting_names [list "AC_IO_STD_ENUM" \
                           "AC_MODE_ENUM" \
                           "AC_SLEW_RATE_ENUM" \
                           "CK_IO_STD_ENUM" \
                           "CK_MODE_ENUM" \
                           "CK_SLEW_RATE_ENUM" \
                           "DATA_IO_STD_ENUM" \
                           "DATA_OUT_MODE_ENUM" \
                           "DATA_IN_MODE_ENUM" \
                           "AUTO_STARTING_VREFIN_EN" \
                           "STARTING_VREFIN" \
                           "PLL_REF_CLK_IO_STD_ENUM" \
                           "RZQ_IO_STD_ENUM"]

   set default_io    [get_parameter_value "${param_prefix}_DEFAULT_IO"]
   set protocol_enum [get_parameter_value "PROTOCOL_ENUM"]
   set voltage       [get_parameter_value "${param_prefix}_IO_VOLTAGE"]
   set vref_min      [get_family_trait "FAMILY_TRAIT_POD_VREF_MIN"]
   set vref_max      [get_family_trait "FAMILY_TRAIT_POD_VREF_MAX"]

   set default_settings [_get_default_io_settings $protocol_enum $voltage]

   if {$default_io} {
      set settings $default_settings
   } else {
      set settings [dict create]
      foreach setting_name $setting_names {
         set param "${param_prefix}_USER_${setting_name}"
         set val [get_parameter_value $param]

         if {$val == "unset"} {
            dict set settings $setting_name [dict get $default_settings $setting_name]
         } else {
            dict set settings $setting_name $val
         }
      }
   }
   
   set auto_starting_vrefin_en       [dict get $settings "AUTO_STARTING_VREFIN_EN"]
   set data_in_mode_enum             [dict get $settings "DATA_IN_MODE_ENUM"]
   set data_in_calibrated_oct        [enum_data $data_in_mode_enum CALIBRATED]
   set data_in_ohm                   [enum_data $data_in_mode_enum OHM]
   set data_io_std_enum              [dict get $settings "DATA_IO_STD_ENUM"]
   set data_out_mode_enum            [dict get $settings "DATA_OUT_MODE_ENUM"]
   set data_out_calibrated_oct       [enum_data $data_out_mode_enum CALIBRATED]
   set calibrated_vrefin             [expr {$data_io_std_enum == "IO_STD_POD_12" ? 1 : 0}]
   
   if {$calibrated_vrefin && $auto_starting_vrefin_en} {
      dict set settings STARTING_VREFIN [_get_ideal_pod_vrefin $voltage $data_in_ohm]
   }

   set core_clks_sharing_enum        [get_parameter_value "${param_prefix}_CORE_CLKS_SHARING_ENUM"]
   set has_ref_clk_pin               [expr {$core_clks_sharing_enum != "CORE_CLKS_SHARING_SLAVE" ? 1 : 0}]

   set ac_io_std_enum                [dict get $settings "AC_IO_STD_ENUM"]
   set ac_mode_enum                  [dict get $settings "AC_MODE_ENUM"]
   set ac_slew_rate_enum             [dict get $settings "AC_SLEW_RATE_ENUM"]
   set ac_calibrated_oct             [enum_data $ac_mode_enum CALIBRATED]
   set ac_use_oct                    [enum_data $ac_mode_enum IS_OCT]
   set ck_io_std_enum                [dict get $settings "CK_IO_STD_ENUM"]
   set ck_mode_enum                  [dict get $settings "CK_MODE_ENUM"]
   set ck_slew_rate_enum             [dict get $settings "CK_SLEW_RATE_ENUM"]
   set ck_calibrated_oct             [enum_data $ck_mode_enum CALIBRATED]
   set ck_use_oct                    [enum_data $ck_mode_enum IS_OCT]
   set calibrated_oct                [expr {$ac_calibrated_oct || $ck_calibrated_oct || $data_in_calibrated_oct || $data_out_calibrated_oct}]

   set ref_clk_io_std_enum           [dict get $settings "PLL_REF_CLK_IO_STD_ENUM"]
   set rzq_io_std_enum               [dict get $settings "RZQ_IO_STD_ENUM"]

   set legal_ac_io_std_enums         [_get_supported_ac_io_stds $protocol_enum $voltage]
   set legal_ac_io_std_enums_ui      [_get_legal_enums_ui $legal_ac_io_std_enums]
   set ac_oct_rzq                    [enum_data "OCT_${ac_io_std_enum}" RZQ]
   set legal_ac_oct                  [enum_data "OCT_${ac_io_std_enum}" RANGE_OUT_OCT]
   set legal_ac_oct_no_cal           [enum_data "OCT_${ac_io_std_enum}" RANGE_OUT_OCT_NO_CAL]
   set legal_ac_cs                   [enum_data "OCT_${ac_io_std_enum}" RANGE_CURRENT_ST]
   set legal_ac_mode_enums           [_get_legal_io_out_mode_enums $legal_ac_oct $legal_ac_oct_no_cal $legal_ac_cs]
   set legal_ac_mode_enums_ui        [_get_legal_enums_ui $legal_ac_mode_enums]

   set legal_ck_io_std_enums         [_get_supported_ck_io_stds $protocol_enum $voltage]
   set legal_ck_io_std_enums_ui      [_get_legal_enums_ui $legal_ck_io_std_enums]
   set ck_oct_rzq                    [enum_data "OCT_${ck_io_std_enum}" RZQ]
   set legal_ck_oct                  [enum_data "OCT_${ck_io_std_enum}" RANGE_OUT_OCT]
   set legal_ck_oct_no_cal           [enum_data "OCT_${ck_io_std_enum}" RANGE_OUT_OCT_NO_CAL]
   set legal_ck_cs                   [enum_data "OCT_${ck_io_std_enum}" RANGE_CURRENT_ST]
   set legal_ck_mode_enums           [_get_legal_io_out_mode_enums $legal_ck_oct $legal_ck_oct_no_cal $legal_ck_cs]
   set legal_ck_mode_enums_ui        [_get_legal_enums_ui $legal_ck_mode_enums]

   set legal_data_io_std_enums       [_get_supported_data_io_stds $protocol_enum $voltage]
   set legal_data_io_std_enums_ui    [_get_legal_enums_ui $legal_data_io_std_enums]
   set data_oct_rzq                  [enum_data "OCT_${data_io_std_enum}" RZQ]
   set legal_data_in_oct             [enum_data "OCT_${data_io_std_enum}" RANGE_IN_OCT]
   set legal_data_in_mode_enums      [_get_legal_io_in_mode_enums $legal_data_in_oct]
   set legal_data_in_mode_enums_ui   [_get_legal_enums_ui $legal_data_in_mode_enums]
   set legal_data_out_oct            [enum_data "OCT_${data_io_std_enum}" RANGE_OUT_OCT]
   set legal_data_out_oct_no_cal     [enum_data "OCT_${data_io_std_enum}" RANGE_OUT_OCT_NO_CAL]
   set legal_data_cs                 [enum_data "OCT_${data_io_std_enum}" RANGE_CURRENT_ST]
   set legal_data_out_mode_enums     [_get_legal_io_out_mode_enums $legal_data_out_oct $legal_data_out_oct_no_cal $legal_data_cs]
   set legal_data_out_mode_enums_ui  [_get_legal_enums_ui $legal_data_out_mode_enums]

   set legal_ref_clk_io_std_enums    [_get_supported_pll_ref_clk_io_stds $protocol_enum $voltage]
   set legal_ref_clk_io_std_enums_ui [_get_legal_enums_ui $legal_ref_clk_io_std_enums]

   set legal_rzq_io_std_enums        [_get_supported_rzq_io_stds $protocol_enum $voltage]
   set legal_rzq_io_std_enums_ui     [_get_legal_enums_ui $legal_rzq_io_std_enums]

   if {!$default_io} {
   
      if {$data_io_std_enum != "IO_STD_POD_12" && $data_in_ohm >= 0 } {      
         if { $data_in_ohm < 50} {
            set is_legal 0
            post_ipgen_e_msg MSG_INVALID_IO_TERMINATION_SETTING
         } elseif { $data_in_ohm == 120} {
            post_ipgen_i_msg MSG_VALID_IO_TERMINATION_SETTING
         } else {   
            post_ipgen_w_msg MSG_NON_OPTIMAL_IO_TERMINATION_SETTING
         }
      }    

      if {[lsearch -exact $legal_ac_io_std_enums $ac_io_std_enum] == -1} {
         set is_legal 0
         lappend legal_ac_io_std_enums_ui [enum_dropdown_entry $ac_io_std_enum 1]
         post_ipgen_e_msg MSG_INVALID_IO_SETTING [list "Address/command I/O standard" [enum_data $ac_io_std_enum]]
      }
      if {[lsearch -exact $legal_ac_mode_enums $ac_mode_enum] == -1} {
         set is_legal 0
         lappend legal_ac_mode_enums_ui [enum_dropdown_entry $ac_mode_enum 1]
         post_ipgen_e_msg MSG_INVALID_IO_SETTING [list "Address/command output mode" [enum_data $ac_mode_enum]]
      }
      if {[lsearch -exact $legal_ck_io_std_enums $ck_io_std_enum] == -1} {
         set is_legal 0
         lappend legal_ck_io_std_enums_ui [enum_dropdown_entry $ck_io_std_enum 1]
         post_ipgen_e_msg MSG_INVALID_IO_SETTING [list "Memory clock I/O standard" [enum_data $ck_io_std_enum]]
      }
      if {[lsearch -exact $legal_ck_mode_enums $ck_mode_enum] == -1} {
         set is_legal 0
         lappend legal_ck_mode_enums_ui [enum_dropdown_entry $ck_mode_enum 1]
         post_ipgen_e_msg MSG_INVALID_IO_SETTING [list "Memory clock output mode" [enum_data $ck_mode_enum]]
      }
      if {[lsearch -exact $legal_data_io_std_enums $data_io_std_enum] == -1} {
         set is_legal 0
         lappend legal_data_io_std_enums_ui [enum_dropdown_entry $data_io_std_enum 1]
         post_ipgen_e_msg MSG_INVALID_IO_SETTING [list "Data bus I/O standard" [enum_data $data_io_std_enum]]
      }
      if {[lsearch -exact $legal_data_out_mode_enums $data_out_mode_enum] == -1} {
         set is_legal 0
         lappend legal_data_out_mode_enums_ui [enum_dropdown_entry $data_out_mode_enum 1]
         post_ipgen_e_msg MSG_INVALID_IO_SETTING [list "Data bus output mode" [enum_data $data_out_mode_enum]]
      }
      if {[lsearch -exact $legal_data_in_mode_enums $data_in_mode_enum] == -1} {
         set is_legal 0
         lappend legal_data_in_mode_enums_ui [enum_dropdown_entry $data_in_mode_enum 1]
         post_ipgen_e_msg MSG_INVALID_IO_SETTING [list "Data bus input mode" [enum_data $data_in_mode_enum]]
      }

      if {[lsearch -exact $legal_ref_clk_io_std_enums $ref_clk_io_std_enum] == -1} {
         lappend legal_ref_clk_io_std_enums_ui [enum_dropdown_entry $ref_clk_io_std_enum 1]
         if {$has_ref_clk_pin} {
            set is_legal 0
            post_ipgen_e_msg MSG_INVALID_IO_SETTING [list "PLL reference clock I/O standard" [enum_data $ref_clk_io_std_enum]]
         }
      }
      if {[lsearch -exact $legal_rzq_io_std_enums $rzq_io_std_enum] == -1} {
         lappend legal_rzq_io_std_enums_ui [enum_dropdown_entry $rzq_io_std_enum 1]
         if {$calibrated_oct} {
            set is_legal 0
            post_ipgen_e_msg MSG_INVALID_IO_SETTING [list "RZQ I/O standard" [enum_data $rzq_io_std_enum]]
         }
      }

      if {$data_in_calibrated_oct && !$data_out_calibrated_oct} {
         set is_legal 0
         post_ipgen_e_msg MSG_DATA_IN_OUT_INCONSISTENT_CAL_OCT [list "input data bus" "output data bus"]
      }
      if {!$data_in_calibrated_oct && $data_out_calibrated_oct} {
         set is_legal 0
         post_ipgen_e_msg MSG_DATA_IN_OUT_INCONSISTENT_CAL_OCT [list "output data bus" "input data bus"]
      }

      if {$ac_calibrated_oct && $ck_calibrated_oct && $ac_oct_rzq != $ck_oct_rzq} {
         set is_legal 0
         post_ipgen_e_msg MSG_MISMATCHED_OCT [list "address/command output" "memory clock output"]
         post_ipgen_e_msg MSG_MISMATCHED_OCT_RZQ_VAL [list "address/command output" $ac_oct_rzq]
         post_ipgen_e_msg MSG_MISMATCHED_OCT_RZQ_VAL [list "memory clock output" $ck_oct_rzq]
      }
      if {$ac_calibrated_oct && ($data_in_calibrated_oct || $data_out_calibrated_oct) && $ac_oct_rzq != $data_oct_rzq} {
         set is_legal 0
         post_ipgen_e_msg MSG_MISMATCHED_OCT [list "address/command output" "data bus"]
         post_ipgen_e_msg MSG_MISMATCHED_OCT_RZQ_VAL [list "address/command output" $ac_oct_rzq]
         post_ipgen_e_msg MSG_MISMATCHED_OCT_RZQ_VAL [list "data bus output" $data_oct_rzq]
      }
      if {$ck_calibrated_oct && ($data_in_calibrated_oct || $data_out_calibrated_oct) && $ck_oct_rzq != $data_oct_rzq} {
         set is_legal 0
         post_ipgen_e_msg MSG_MISMATCHED_OCT [list "memory clock output" "data bus"]
         post_ipgen_e_msg MSG_MISMATCHED_OCT_RZQ_VAL [list "memory clock output" $ck_oct_rzq]
         post_ipgen_e_msg MSG_MISMATCHED_OCT_RZQ_VAL [list "data bus output" $data_oct_rzq]
      }

      if {$ac_slew_rate_enum == "SLEW_RATE_SLOW" && $ac_use_oct} {
         set is_legal 0
         post_ipgen_e_msg MSG_SLOW_SLEW_RATE_NOT_SUPPORTED_FOR_OCT [list "address/command bus"]
      }
      if {$ck_slew_rate_enum == "SLEW_RATE_SLOW" && $ck_use_oct} {
         set is_legal 0
         post_ipgen_e_msg MSG_SLOW_SLEW_RATE_NOT_SUPPORTED_FOR_OCT [list "memory clocks"]
      }
   }

   set oct_rzq 0
   if {$is_legal} {
      if {$ac_calibrated_oct} {
         set oct_rzq $ac_oct_rzq
      } elseif {$ck_calibrated_oct} {
         set oct_rzq $ck_oct_rzq
      } elseif {$data_in_calibrated_oct || $data_out_calibrated_oct} {
         set oct_rzq $data_oct_rzq
      }
   }

   set_parameter_property "${param_prefix}_AC_IO_STD_ENUM"          ALLOWED_RANGES [list [enum_dropdown_entry $ac_io_std_enum]]
   set_parameter_property "${param_prefix}_AC_MODE_ENUM"            ALLOWED_RANGES [list [enum_dropdown_entry $ac_mode_enum]]
   set_parameter_property "${param_prefix}_AC_SLEW_RATE_ENUM"       ALLOWED_RANGES [list [enum_dropdown_entry $ac_slew_rate_enum]]
   set_parameter_property "${param_prefix}_CK_IO_STD_ENUM"          ALLOWED_RANGES [list [enum_dropdown_entry $ck_io_std_enum]]
   set_parameter_property "${param_prefix}_CK_MODE_ENUM"            ALLOWED_RANGES [list [enum_dropdown_entry $ck_mode_enum]]
   set_parameter_property "${param_prefix}_CK_SLEW_RATE_ENUM"       ALLOWED_RANGES [list [enum_dropdown_entry $ck_slew_rate_enum]]
   set_parameter_property "${param_prefix}_DATA_IO_STD_ENUM"        ALLOWED_RANGES [list [enum_dropdown_entry $data_io_std_enum]]
   set_parameter_property "${param_prefix}_DATA_IN_MODE_ENUM"       ALLOWED_RANGES [list [enum_dropdown_entry $data_in_mode_enum]]
   set_parameter_property "${param_prefix}_DATA_OUT_MODE_ENUM"      ALLOWED_RANGES [list [enum_dropdown_entry $data_out_mode_enum]]
   set_parameter_property "${param_prefix}_PLL_REF_CLK_IO_STD_ENUM" ALLOWED_RANGES [list [enum_dropdown_entry $ref_clk_io_std_enum]]
   set_parameter_property "${param_prefix}_RZQ_IO_STD_ENUM"         ALLOWED_RANGES [list [enum_dropdown_entry $rzq_io_std_enum]]

   if {!$default_io} {
      set_parameter_property "${param_prefix}_USER_AC_IO_STD_ENUM"          ALLOWED_RANGES $legal_ac_io_std_enums_ui
      set_parameter_property "${param_prefix}_USER_AC_MODE_ENUM"            ALLOWED_RANGES $legal_ac_mode_enums_ui
      set_parameter_property "${param_prefix}_USER_AC_SLEW_RATE_ENUM"       ALLOWED_RANGES [enum_dropdown_entries SLEW_RATE]
      set_parameter_property "${param_prefix}_USER_CK_IO_STD_ENUM"          ALLOWED_RANGES $legal_ck_io_std_enums_ui
      set_parameter_property "${param_prefix}_USER_CK_MODE_ENUM"            ALLOWED_RANGES $legal_ck_mode_enums_ui
      set_parameter_property "${param_prefix}_USER_CK_SLEW_RATE_ENUM"       ALLOWED_RANGES [enum_dropdown_entries SLEW_RATE]
      set_parameter_property "${param_prefix}_USER_DATA_IO_STD_ENUM"        ALLOWED_RANGES $legal_data_io_std_enums_ui
      set_parameter_property "${param_prefix}_USER_DATA_IN_MODE_ENUM"       ALLOWED_RANGES $legal_data_in_mode_enums_ui
      set_parameter_property "${param_prefix}_USER_DATA_OUT_MODE_ENUM"      ALLOWED_RANGES $legal_data_out_mode_enums_ui
      set_parameter_property "${param_prefix}_USER_PLL_REF_CLK_IO_STD_ENUM" ALLOWED_RANGES $legal_ref_clk_io_std_enums_ui
      set_parameter_property "${param_prefix}_USER_RZQ_IO_STD_ENUM"         ALLOWED_RANGES $legal_rzq_io_std_enums_ui
      
      set_parameter_property "${param_prefix}_USER_STARTING_VREFIN"         ALLOWED_RANGES "{${vref_min}:${vref_max}}"
   }

   foreach setting_name [dict keys $settings] {
      if {$setting_name == "PLL_REF_CLK_IO_STD_ENUM"} {
         set_parameter_property "${param_prefix}_USER_${setting_name}"  VISIBLE [expr {!$default_io && $has_ref_clk_pin}]
         set_parameter_property "${param_prefix}_${setting_name}"       VISIBLE [expr {$default_io && $has_ref_clk_pin}]

      } elseif {$setting_name == "RZQ_IO_STD_ENUM"} {
         set_parameter_property "${param_prefix}_USER_${setting_name}"  VISIBLE [expr {!$default_io && $calibrated_oct}]
         set_parameter_property "${param_prefix}_${setting_name}"       VISIBLE [expr {$default_io && $calibrated_oct}]
      
      } elseif {$setting_name == "STARTING_VREFIN"} {
         set_parameter_property "${param_prefix}_USER_${setting_name}"  VISIBLE [expr {!($default_io || $auto_starting_vrefin_en) && $calibrated_vrefin}]
         set_parameter_property "${param_prefix}_${setting_name}"       VISIBLE [expr { ($default_io || $auto_starting_vrefin_en) && $calibrated_vrefin}]

      } elseif {$setting_name == "AUTO_STARTING_VREFIN_EN"} {
         set_parameter_property "${param_prefix}_USER_${setting_name}"  VISIBLE [expr {!$default_io && $calibrated_vrefin}]
         set_parameter_property "${param_prefix}_${setting_name}"       VISIBLE false
         
      } else {
         set_parameter_property "${param_prefix}_USER_${setting_name}"  VISIBLE [expr {!$default_io}]
         set_parameter_property "${param_prefix}_${setting_name}"       VISIBLE $default_io
      }
   }
   set_parameter_property "PHY_RZQ" VISIBLE $calibrated_oct

   foreach setting_name [dict keys $settings] {
      set param_name "${param_prefix}_${setting_name}"
      set val [dict get $settings $setting_name]
      set_parameter_value $param_name $val
   }
   set_parameter_value PHY_RZQ $oct_rzq
   set_parameter_value PHY_CALIBRATED_OCT $calibrated_oct
   set_parameter_value PHY_AC_CALIBRATED_OCT $ac_calibrated_oct
   set_parameter_value PHY_CK_CALIBRATED_OCT $ck_calibrated_oct
   set_parameter_value PHY_DATA_CALIBRATED_OCT [expr {$data_in_calibrated_oct || $data_out_calibrated_oct}]

   if {$is_legal} {
      if {!$data_in_calibrated_oct || !$data_out_calibrated_oct} {
         post_ipgen_w_msg MSG_NO_CAL_OCT
      }
   }
}

proc ::altera_emif::ip_top::phy::_validate_pll {param_prefix} {

   set pll_settings [::altera_emif::util::arch_expert::get_pll_settings]

   set pll_speedgrade          [dict get $pll_settings PLL_SPEEDGRADE]
   set pll_vco_freq_mhz        [dict get $pll_settings PLL_VCO_FREQ_MHZ]
   set pll_compensation_mode   [dict get $pll_settings PLL_COMPENSATION_MODE]
   set pll_clks_list           [dict get $pll_settings PLL_CLKS_LIST]

   set_parameter_value PLL_SPEEDGRADE       $pll_speedgrade
   set_parameter_value PLL_VCO_CLK_FREQ_MHZ $pll_vco_freq_mhz

   set is_hps                 [get_is_hps]
   set core_clks_sharing_enum [get_parameter_value "PHY_CORE_CLKS_SHARING_ENUM"]
   set is_clock_slave         [expr {$core_clks_sharing_enum == "CORE_CLKS_SHARING_SLAVE" ? 1 : 0}]

   set disallow_extra_clks [expr {($is_hps || $is_clock_slave) ? 1 : 0}]

   set_parameter_value PLL_DISALLOW_EXTRA_CLKS [expr {$disallow_extra_clks ? "true" : "false"}]

   if {!$disallow_extra_clks && [get_parameter_value PLL_ADD_EXTRA_CLKS]} {
      set_parameter_value PLL_NUM_OF_EXTRA_CLKS [get_parameter_value PLL_USER_NUM_OF_EXTRA_CLKS]
   } else {
      set_parameter_value PLL_NUM_OF_EXTRA_CLKS 0
   }

   ::altera_iopll_common::iopll::set_pll_output_clocks_info $pll_compensation_mode $pll_clks_list
   ::altera_iopll_common::iopll::validate

}

proc ::altera_emif::ip_top::phy::_set_user_ref_clk_freq_to_default {arg} {

   set param_prefix         [_get_protocol_specific_param_prefix]
   set default_ref_clk_freq [get_parameter_value "${param_prefix}_DEFAULT_REF_CLK_FREQ"]

   if {!$default_ref_clk_freq} {
      set legal_ref_freqs [altera_emif::util::arch_expert::get_legal_pll_ref_clk_freqs_mhz 1]
      set ref_clk_freq_mhz [lindex $legal_ref_freqs 0]
      set_parameter_value "${param_prefix}_USER_REF_CLK_FREQ_MHZ" $ref_clk_freq_mhz
   }
}

proc ::altera_emif::ip_top::phy::_set_io_settings_to_default {arg} {

   set param_prefix  [_get_protocol_specific_param_prefix]
   set default_io    [get_parameter_value "${param_prefix}_DEFAULT_IO"]

   if {!$default_io} {
      set protocol_enum [get_parameter_value "PROTOCOL_ENUM"]
      set voltage       [get_parameter_value "${param_prefix}_IO_VOLTAGE"]
      set defaults      [_get_default_io_settings $protocol_enum $voltage]

      foreach setting [dict keys $defaults] {
         set param "${param_prefix}_USER_${setting}"
         set default_val [dict get $defaults $setting]
         set_parameter_value $param $default_val
      }
   }
}

proc ::altera_emif::ip_top::phy::_get_supported_pll_ref_clk_io_stds {protocol_enum voltage} {
   set protocol_module [enum_data $protocol_enum MODULE_NAME]
   set full_module "::altera_emif::ip_top::phy::${protocol_module}"
   set func_name "${full_module}::get_supported_pll_ref_clk_io_stds"
   return [$func_name $voltage]
}

proc ::altera_emif::ip_top::phy::_get_supported_rzq_io_stds {protocol_enum voltage} {
   set protocol_module [enum_data $protocol_enum MODULE_NAME]
   set full_module "::altera_emif::ip_top::phy::${protocol_module}"
   set func_name "${full_module}::get_supported_rzq_io_stds"
   return [$func_name $voltage]
}

proc ::altera_emif::ip_top::phy::_get_supported_ac_io_stds {protocol_enum voltage} {
   set protocol_module [enum_data $protocol_enum MODULE_NAME]
   set full_module "::altera_emif::ip_top::phy::${protocol_module}"
   set func_name "${full_module}::get_supported_ac_io_stds"
   return [$func_name $voltage]
}

proc ::altera_emif::ip_top::phy::_get_supported_ck_io_stds {protocol_enum voltage} {
   set protocol_module [enum_data $protocol_enum MODULE_NAME]
   set full_module "::altera_emif::ip_top::phy::${protocol_module}"
   set func_name "${full_module}::get_supported_ck_io_stds"
   return [$func_name $voltage]
}

proc ::altera_emif::ip_top::phy::_get_supported_data_io_stds {protocol_enum voltage} {
   set protocol_module [enum_data $protocol_enum MODULE_NAME]
   set full_module "::altera_emif::ip_top::phy::${protocol_module}"
   set func_name "${full_module}::get_supported_data_io_stds"
   return [$func_name $voltage]
}

proc ::altera_emif::ip_top::phy::_get_default_io_settings {protocol_enum voltage} {
   set protocol_module [enum_data $protocol_enum MODULE_NAME]
   set full_module "::altera_emif::ip_top::phy::${protocol_module}"
   set func_name "${full_module}::get_default_io_settings"
   return [$func_name $voltage]
}

proc ::altera_emif::ip_top::phy::_get_legal_io_out_mode_enums {range_oct range_oct_no_cal range_cs} {
   set retval [list]
   foreach oct $range_oct {
      set enum_name "OUT_OCT_${oct}_CAL"
      lappend retval $enum_name
   }
   foreach oct $range_oct_no_cal {
      if {$oct == 0} {
         set enum_name "OUT_OCT_0"
      } else {
         set enum_name "OUT_OCT_${oct}_NO_CAL"
      }
      lappend retval $enum_name
   }
   foreach cs $range_cs {
      set enum_name "CURRENT_ST_${cs}"
      lappend retval $enum_name
   }
   return $retval
}

proc ::altera_emif::ip_top::phy::_get_legal_io_in_mode_enums {range_oct} {
   set retval [list]
   foreach oct $range_oct {
      if {$oct == 0} {
         set enum_name "IN_OCT_0"
      } else {
         set enum_name "IN_OCT_${oct}_CAL"
      }
      lappend retval $enum_name
   }
   return $retval
}

proc ::altera_emif::ip_top::phy::_get_legal_enums_ui {enum_names} {
   set retval [list]
   foreach enum_name $enum_names {
      lappend retval [enum_dropdown_entry $enum_name]
   }
   return $retval
}

proc ::altera_emif::ip_top::phy::_reset_allowed_ranges_to_ensure_legality {} {
   foreach protocol_enum [enums_of_type PROTOCOL] {

      if {$protocol_enum == "PROTOCOL_INVALID"} {
         continue
      }

      set module_name [string toupper [enum_data $protocol_enum MODULE_NAME]]

      foreach param_name [list USER_REF_CLK_FREQ_MHZ \
                               USER_AC_IO_STD_ENUM \
                               USER_AC_MODE_ENUM \
                               USER_AC_SLEW_RATE_ENUM \
                               USER_CK_IO_STD_ENUM \
                               USER_CK_MODE_ENUM \
                               USER_CK_SLEW_RATE_ENUM \
                               USER_DATA_IO_STD_ENUM \
                               USER_DATA_OUT_MODE_ENUM \
                               USER_DATA_IN_MODE_ENUM \
                               USER_PLL_REF_CLK_IO_STD_ENUM \
                               USER_RZQ_IO_STD_ENUM] {

         set param_name "PHY_${module_name}_$param_name"
         set val [get_parameter_value $param_name]
         set_parameter_property $param_name ALLOWED_RANGES [list $val]
      }
   }
}


proc ::altera_emif::ip_top::phy::_get_ideal_pod_vrefin {vcc oct_ohm} {
   
   set ron 34
   
   if {$oct_ohm < 0} {
      set vdc0 0
   } else {
      set vdc0 [expr {$vcc * $ron / ($ron + $oct_ohm)}]
   } 
   
   set vref [expr {($vcc + $vdc0) / 2.0}]
   
   set retval [expr {int($vref * 1000.0 / $vcc) / 10.0}]
   
   set vref_min [get_family_trait "FAMILY_TRAIT_POD_VREF_MIN"]
   set vref_max [get_family_trait "FAMILY_TRAIT_POD_VREF_MAX"]
   set retval [expr {($retval < $vref_min) ? $vref_min : $retval}]
   set retval [expr {($retval > $vref_max) ? $vref_max : $retval}]
   
   return $retval
}

proc ::altera_emif::ip_top::phy::_init {} {
}

::altera_emif::ip_top::phy::_init
