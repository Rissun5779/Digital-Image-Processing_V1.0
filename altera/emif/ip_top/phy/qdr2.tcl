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


package provide altera_emif::ip_top::phy::qdr2 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::ip_top::util

namespace eval ::altera_emif::ip_top::phy::qdr2:: {
    
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::ip_top::util::*

   
   variable m_param_prefix "PHY_QDR2"
}


proc ::altera_emif::ip_top::phy::qdr2::create_parameters {is_top_level_component} {
   variable m_param_prefix
   
   add_user_param     "${m_param_prefix}_CONFIG_ENUM"                  string    CONFIG_PHY_AND_SOFT_CTRL     [enum_dropdown_entries CONFIG]             ""           ""             ""             PHY_CONFIG_ENUM
   add_user_param     "${m_param_prefix}_USER_PING_PONG_EN"            boolean   false                        ""                                         ""           ""             ""             PHY_PING_PONG_EN
   add_user_param     "${m_param_prefix}_MEM_CLK_FREQ_MHZ"             float     633.333                      ""                                         "MEGAHERTZ"  ""             ""             PHY_MEM_CLK_FREQ_MHZ
   add_user_param     "${m_param_prefix}_DEFAULT_REF_CLK_FREQ"         boolean   true                         ""                                         ""           ""             ""             PHY_DEFAULT_REF_CLK_FREQ
   add_user_param     "${m_param_prefix}_USER_REF_CLK_FREQ_MHZ"        float     -1                           {-1}                                       "MEGAHERTZ"  ""             ""             PHY_USER_REF_CLK_FREQ_MHZ
   add_user_param     "${m_param_prefix}_REF_CLK_JITTER_PS"            float     10                           ""                                         "Picoseconds" ""            ""             PHY_REF_CLK_JITTER_PS
   add_user_param     "${m_param_prefix}_RATE_ENUM"                    string    RATE_HALF                    [enum_dropdown_entries RATE]               ""           ""             ""             PHY_RATE_ENUM
   add_user_param     "${m_param_prefix}_CORE_CLKS_SHARING_ENUM"       string    CORE_CLKS_SHARING_DISABLED   [enum_dropdown_entries CORE_CLKS_SHARING]  ""           ""             ""             PHY_CORE_CLKS_SHARING_ENUM
   add_user_param     "${m_param_prefix}_IO_VOLTAGE"                   float     1.5                          {"1.5:1.5-V" "1.8:1.8-V"}                  ""           ""             ""             PHY_IO_VOLTAGE
   add_user_param     "${m_param_prefix}_DEFAULT_IO"                   boolean   true                         ""                                         ""           ""             ""             PHY_DEFAULT_IO
   add_user_param     "${m_param_prefix}_HPS_ENABLE_EARLY_RELEASE"     boolean   false                        ""                                         ""           ""             ""             PHY_HPS_ENABLE_EARLY_RELEASE
   add_user_param     "${m_param_prefix}_USER_PERIODIC_OCT_RECAL_ENUM" string    PERIODIC_OCT_RECAL_AUTO      [enum_dropdown_entries PERIODIC_OCT_RECAL] ""           ""             ""             PHY_USER_PERIODIC_OCT_RECAL_ENUM
   
   add_derived_param  "${m_param_prefix}_REF_CLK_FREQ_MHZ"             float     -1            true        "MEGAHERTZ"  ""            ""            PHY_REF_CLK_FREQ_MHZ
   add_derived_param  "${m_param_prefix}_PING_PONG_EN"                 boolean   false         true        ""           ""            ""            PHY_PING_PONG_EN

   altera_emif::ip_top::phy::create_io_parameters $m_param_prefix
   
   set_parameter_update_callback "${m_param_prefix}_DEFAULT_REF_CLK_FREQ"  ::altera_emif::ip_top::phy::_set_user_ref_clk_freq_to_default
   set_parameter_update_callback "${m_param_prefix}_DEFAULT_IO"            ::altera_emif::ip_top::phy::_set_io_settings_to_default
   
   return 1
}

proc ::altera_emif::ip_top::phy::qdr2::set_family_specific_defaults {family_enum base_family_enum is_hps} {
   variable m_param_prefix
   
   return 1
}

proc ::altera_emif::ip_top::phy::qdr2::add_display_items {tabs} {
   variable m_param_prefix
  
   return 1
}

proc ::altera_emif::ip_top::phy::qdr2::validate {} {
   variable m_param_prefix

   return 1
}

proc ::altera_emif::ip_top::phy::qdr2::get_default_io_settings {voltage} {   
   set retval [dict create]

   if {$voltage == 1.5} {
      if {[ini_is_on "emif_default_to_single_ended_pll_ref_clk"]} {   
         dict set retval PLL_REF_CLK_IO_STD_ENUM  "IO_STD_CMOS_15"
      } else {
         dict set retval PLL_REF_CLK_IO_STD_ENUM  "IO_STD_LVDS"
      }
      dict set retval RZQ_IO_STD_ENUM          "IO_STD_CMOS_15"
      dict set retval AC_IO_STD_ENUM           "IO_STD_HSTL_15_C1"
      dict set retval AC_MODE_ENUM             "CURRENT_ST_12"
      dict set retval AC_SLEW_RATE_ENUM        "SLEW_RATE_FAST"
      dict set retval CK_IO_STD_ENUM           "IO_STD_HSTL_15_C1"
      dict set retval CK_MODE_ENUM             "OUT_OCT_50_CAL"
      dict set retval CK_SLEW_RATE_ENUM        "SLEW_RATE_FAST"
      dict set retval DATA_IO_STD_ENUM         "IO_STD_HSTL_15_C1"
      dict set retval DATA_OUT_MODE_ENUM       "OUT_OCT_50_CAL"
      dict set retval DATA_IN_MODE_ENUM        "IN_OCT_50_CAL"
      dict set retval AUTO_STARTING_VREFIN_EN  true
      dict set retval STARTING_VREFIN          50   
   } elseif {$voltage == 1.8} {
      if {[ini_is_on "emif_default_to_single_ended_pll_ref_clk"]} {   
         dict set retval PLL_REF_CLK_IO_STD_ENUM  "IO_STD_CMOS_18"
      } else {
         dict set retval PLL_REF_CLK_IO_STD_ENUM  "IO_STD_LVDS"
      }
      dict set retval RZQ_IO_STD_ENUM          "IO_STD_CMOS_18"
      dict set retval AC_IO_STD_ENUM           "IO_STD_HSTL_18_C1"
      dict set retval AC_MODE_ENUM             "CURRENT_ST_12"
      dict set retval AC_SLEW_RATE_ENUM        "SLEW_RATE_FAST"
      dict set retval CK_IO_STD_ENUM           "IO_STD_HSTL_18_C1"
      dict set retval CK_MODE_ENUM             "OUT_OCT_50_CAL"
      dict set retval CK_SLEW_RATE_ENUM        "SLEW_RATE_FAST"
      dict set retval DATA_IO_STD_ENUM         "IO_STD_HSTL_18_C1"
      dict set retval DATA_OUT_MODE_ENUM       "OUT_OCT_50_CAL"
      dict set retval DATA_IN_MODE_ENUM        "IN_OCT_50_CAL"
      dict set retval AUTO_STARTING_VREFIN_EN  true
      dict set retval STARTING_VREFIN          50   
   } else {
      emif_ie "Unsupported voltage $voltage for QDR II/II+/II+ Xtreme"
   }
   return $retval
}

proc ::altera_emif::ip_top::phy::qdr2::get_supported_pll_ref_clk_io_stds {voltage} {
   if {$voltage == 1.5} {
      return [list IO_STD_LVDS IO_STD_LVDS_NO_OCT IO_STD_CMOS_15]
   } elseif {$voltage == 1.8} {
      return [list IO_STD_LVDS IO_STD_LVDS_NO_OCT IO_STD_CMOS_18]
   }
}

proc ::altera_emif::ip_top::phy::qdr2::get_supported_rzq_io_stds {voltage} {
   if {$voltage == 1.5} {
      return [list IO_STD_CMOS_15]
   } elseif {$voltage == 1.8} {
      return [list IO_STD_CMOS_18]
   }
}

proc ::altera_emif::ip_top::phy::qdr2::get_supported_ac_io_stds {voltage} {
   if {$voltage == 1.5} {
      return [list IO_STD_HSTL_15_C1 IO_STD_HSTL_15_C2]
   } elseif {$voltage == 1.8} {
      return [list IO_STD_HSTL_18_C1 IO_STD_HSTL_18_C2]
   }
}

proc ::altera_emif::ip_top::phy::qdr2::get_supported_ck_io_stds {voltage} {
   return [get_supported_ac_io_stds $voltage]
}

proc ::altera_emif::ip_top::phy::qdr2::get_supported_data_io_stds {voltage} {
   return [get_supported_ac_io_stds $voltage]
}



proc ::altera_emif::ip_top::phy::qdr2::_init {} {
}

::altera_emif::ip_top::phy::qdr2::_init
