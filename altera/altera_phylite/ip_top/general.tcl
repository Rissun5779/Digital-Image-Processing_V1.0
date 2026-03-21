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


package provide altera_phylite::ip_top::general 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::device_family
package require altera_phylite::util::enum_defs
package require altera_phylite::util::arch_expert
package require altera_iopll_common::iopll

namespace eval ::altera_phylite::ip_top::general:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_phylite::util::enum_defs
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_iopll_common::iopll::*
   
   
   variable m_param_prefix "PHYLITE"
}


proc ::altera_phylite::ip_top::general::create_parameters {} {
   variable m_param_prefix

   set use_dft              [::altera_emif::util::qini::ini_is_on "ip_altera_phylite_enable_dft_interface"]
   set use_eng_clk_freq     [::altera_emif::util::qini::ini_is_on "ip_altera_phylite_enable_eng_clock_frequencies"]
   set enable_debug_design  [::altera_emif::util::qini::ini_is_on "ip_altera_phylite_enable_debug_design"]
   set max_freq 1200.00

   add_derived_param  "${m_param_prefix}_RATE_ENUM"                   string     ""       false
   add_derived_param  "${m_param_prefix}_MEM_CLK_FREQ_MHZ"            float      -1       false
   add_derived_param  "${m_param_prefix}_REF_CLK_FREQ_MHZ"            float      -1       true       "MEGAHERTZ"
   add_derived_param  "${m_param_prefix}_USE_DYNAMIC_RECONFIGURATION" boolean    false    false
   add_derived_param  "${m_param_prefix}_GENERATE_DEBUG_DESIGN"       boolean    true     false
   add_derived_param  "${m_param_prefix}_INTERFACE_ID"                integer    -1       false
   add_derived_param  "${m_param_prefix}_TARGET_IS_ES"                boolean    false    false      
   add_derived_param  "PLL_USE_CORE_REF_CLK"                          boolean    false    false

   add_user_param     "GUI_${m_param_prefix}_MEM_CLK_FREQ_MHZ"            float     533                       "{100:${max_freq}}"                     "MEGAHERTZ"
   add_user_param     "GUI_PLL_USE_CORE_REF_CLK"                          boolean   false                     ""
   add_user_param     "GUI_${m_param_prefix}_DEFAULT_REF_CLK_FREQ"        boolean   true                      ""                                      ""
   add_user_param     "GUI_${m_param_prefix}_USER_REF_CLK_FREQ_MHZ"       float     -1                        {-1}                                    "MEGAHERTZ"
   add_user_param     "GUI_${m_param_prefix}_RATE_ENUM"                   string    RATE_IN_QUARTER           [enum_dropdown_entries RATE_IN]         ""
   add_user_param     "GUI_${m_param_prefix}_USE_DYNAMIC_RECONFIGURATION" boolean   false                     ""
   add_user_param     "GUI_${m_param_prefix}_GENERATE_DEBUG_DESIGN"       boolean   true                      "" 
   add_user_param     "GUI_${m_param_prefix}_USE_PHYLITE_AVL_CONTROLLER"  boolean   true                      "" 
   add_user_param     "GUI_${m_param_prefix}_INTERFACE_ID"                integer   0                         {0:14}                                  ""
   add_user_param     "GUI_${m_param_prefix}_IO_STD_ENUM"                 string    PHYLITE_IO_STD_SSTL_15_C1 [enum_dropdown_entries PHYLITE_IO_STD]  ""

   add_user_param     "${m_param_prefix}_USE_CPA"                         boolean   true                      ""
   set_parameter_property "${m_param_prefix}_USE_CPA" VISIBLE false

   add_user_param     "${m_param_prefix}_ADDR_CMD"                         boolean   false                      ""
   set_parameter_property "${m_param_prefix}_ADDR_CMD" VISIBLE false

   add_user_param       GENERATE_SDC_FILE                boolean    true                  ""                           ""
   set_parameter_property GENERATE_SDC_FILE VISIBLE false

   add_derived_param      "${m_param_prefix}_VCO_CLK_FREQ_MHZ" string    "0 ps"                  false                           ""
   set_parameter_property "${m_param_prefix}_VCO_CLK_FREQ_MHZ" VISIBLE false
   add_derived_param      "${m_param_prefix}_VCO_CLK_FREQ_MHZ_DISPLAY" float    0                true                            "MEGAHERTZ"
   set_parameter_property "${m_param_prefix}_VCO_CLK_FREQ_MHZ_DISPLAY" VISIBLE true
   add_derived_param      "${m_param_prefix}_PLL_SPEED_GRADE" string     "1"                     false                           ""
   set_parameter_property "${m_param_prefix}_PLL_SPEED_GRADE" VISIBLE false
   
   set_parameter_update_callback "GUI_${m_param_prefix}_DEFAULT_REF_CLK_FREQ"  ::altera_phylite::ip_top::general::_set_user_ref_clk_freq_to_default

   ::altera_iopll_common::iopll::set_sys_info_device_family SYS_INFO_DEVICE_FAMILY
   ::altera_iopll_common::iopll::set_sys_info_device SYS_INFO_DEVICE
   ::altera_iopll_common::iopll::set_sys_info_device_speedgrade ${m_param_prefix}_PLL_SPEED_GRADE
   ::altera_iopll_common::iopll::set_reference_clock_frequency ${m_param_prefix}_REF_CLK_FREQ_MHZ
   ::altera_iopll_common::iopll::set_vco_frequency ${m_param_prefix}_VCO_CLK_FREQ_MHZ
   ::altera_iopll_common::iopll::declare_pll_parameters   
  
   if ($enable_debug_design) {
      set_parameter_property "GUI_${m_param_prefix}_GENERATE_DEBUG_DESIGN" VISIBLE true
   } else {
      set_parameter_property "GUI_${m_param_prefix}_GENERATE_DEBUG_DESIGN" VISIBLE false	
   }
   set_parameter_property "GUI_${m_param_prefix}_USE_PHYLITE_AVL_CONTROLLER" VISIBLE false
   
   return 1
}

proc ::altera_phylite::ip_top::general::add_display_items {tabs} {
   variable m_param_prefix

   set general_tab [lindex $tabs 0]
   
   set clk_grp [get_string GRP_PHY_CLKS_NAME]
   set dyn_reconfig_grp [get_string GRP_PHY_DYN_RECONFIG_NAME]
   set io_grp [get_string GRP_PHY_IO_NAME]
   
   add_display_item $general_tab $clk_grp GROUP   
   add_display_item $general_tab $dyn_reconfig_grp GROUP
   add_display_item $general_tab $io_grp GROUP
   
   add_param_to_gui $clk_grp          "GUI_${m_param_prefix}_MEM_CLK_FREQ_MHZ"
   add_param_to_gui $clk_grp          "GUI_PLL_USE_CORE_REF_CLK"   
   add_param_to_gui $clk_grp          "GUI_${m_param_prefix}_DEFAULT_REF_CLK_FREQ"
   add_param_to_gui $clk_grp          "${m_param_prefix}_REF_CLK_FREQ_MHZ"
   add_param_to_gui $clk_grp          "GUI_${m_param_prefix}_USER_REF_CLK_FREQ_MHZ"
   add_param_to_gui $clk_grp          "${m_param_prefix}_VCO_CLK_FREQ_MHZ_DISPLAY"
   add_param_to_gui $clk_grp          "GUI_${m_param_prefix}_RATE_ENUM"
   add_param_to_gui $dyn_reconfig_grp "GUI_${m_param_prefix}_USE_DYNAMIC_RECONFIGURATION"
   add_param_to_gui $dyn_reconfig_grp "GUI_${m_param_prefix}_GENERATE_DEBUG_DESIGN"
   add_param_to_gui $dyn_reconfig_grp "GUI_${m_param_prefix}_USE_PHYLITE_AVL_CONTROLLER"
   add_param_to_gui $dyn_reconfig_grp "GUI_${m_param_prefix}_INTERFACE_ID"
   add_param_to_gui $io_grp           "GUI_${m_param_prefix}_IO_STD_ENUM"

   ::altera_iopll_common::iopll::declare_pll_display_items $clk_grp
   
   return 1
}

proc ::altera_phylite::ip_top::general::validate {} {
   variable m_param_prefix

   set rate_enum            [get_parameter_value "GUI_${m_param_prefix}_RATE_ENUM"                  ]
   set mem_clk_freq_mhz     [get_parameter_value "GUI_${m_param_prefix}_MEM_CLK_FREQ_MHZ"           ]
   set use_dynamic_reconfig [get_parameter_value "GUI_${m_param_prefix}_USE_DYNAMIC_RECONFIGURATION"]
   set use_avl_ctrl         [get_parameter_value "GUI_${m_param_prefix}_USE_PHYLITE_AVL_CONTROLLER" ]
   set interface_id         [get_parameter_value "GUI_${m_param_prefix}_INTERFACE_ID"               ]
   set use_core_reflck      [get_parameter_value "GUI_PLL_USE_CORE_REF_CLK"]

   set_parameter_value "${m_param_prefix}_RATE_ENUM"                   $rate_enum           
   set_parameter_value "${m_param_prefix}_USE_DYNAMIC_RECONFIGURATION" $use_dynamic_reconfig
   set_parameter_value "PLL_USE_CORE_REF_CLK" $use_core_reflck

   if {[string compare -nocase $use_dynamic_reconfig "true"] == 0} {
      set_parameter_property "GUI_${m_param_prefix}_INTERFACE_ID" ENABLED true
      set_parameter_value "${m_param_prefix}_INTERFACE_ID" $interface_id

      set_parameter_property "GUI_${m_param_prefix}_GENERATE_DEBUG_DESIGN" ENABLED true
   } else {
      set_parameter_property "GUI_${m_param_prefix}_INTERFACE_ID" ENABLED false
      set_parameter_value "${m_param_prefix}_INTERFACE_ID" 0
      set_parameter_property "GUI_${m_param_prefix}_GENERATE_DEBUG_DESIGN" ENABLED false
   }
   
   set gen_debug_design     [get_parameter_value "GUI_${m_param_prefix}_GENERATE_DEBUG_DESIGN"      ]
   set_parameter_value "${m_param_prefix}_GENERATE_DEBUG_DESIGN"       $gen_debug_design
      set_parameter_property "GUI_${m_param_prefix}_USE_PHYLITE_AVL_CONTROLLER" VISIBLE false

   if {[get_device] == ""} {
      set speedgrade "Unknown - specify FPGA device under 'View'->'Device Family'"
      set_parameter_value ${m_param_prefix}_TARGET_IS_ES false
   } else {
      set_parameter_value ${m_param_prefix}_TARGET_IS_ES [get_is_es]
   }

   set fmin_mhz 100
   set fmax_mhz [get_family_trait FAMILY_TRAIT_IF_FMAX_MHZ]
   set min_calib_freq 800
   if {$mem_clk_freq_mhz < $fmin_mhz} {
      post_ipgen_e_msg MSG_BELOW_ARCH_FMIN [list $fmin_mhz]
   } elseif {$mem_clk_freq_mhz > $fmax_mhz} {
      post_ipgen_e_msg MSG_ABOVE_ARCH_FMAX [list $fmax_mhz]
   } else {
      set_parameter_value "${m_param_prefix}_MEM_CLK_FREQ_MHZ"            $mem_clk_freq_mhz    
      _validate_ref_clk_freq
      if {$mem_clk_freq_mhz >= $min_calib_freq && [string compare -nocase $use_dynamic_reconfig "false"] == 0} {
          post_ipgen_w_msg MSG_MIN_CALIB_FREQ [list $min_calib_freq]
      }
   ::altera_phylite::util::arch_expert::get_pll_output_clocks_info $mem_clk_freq_mhz   
   }

   _validate_PLL_SPEED_GRADE
      set rate_enum [get_parameter_value "GUI_${m_param_prefix}_RATE_ENUM"]
      set user_afi_ratio [enum_data $rate_enum AFI_RATIO]
      set clk_ratios [dict create]
      dict set clk_ratios PHY_HMC $user_afi_ratio
      dict set clk_ratios C2P_P2C $user_afi_ratio 
      dict set clk_ratios USER    $user_afi_ratio

      set family [get_parameter_value SYS_INFO_DEVICE_FAMILY]
      set ref_clk_freq_mhz [get_parameter_value "${m_param_prefix}_REF_CLK_FREQ_MHZ"]

      set en_pll_core_ref_ck   [::altera_emif::util::qini::ini_is_on "ip_altera_phylite_en_pll_core_ref_ck"]

      if { ($family == "Arria 10") } {
	      set pll_settings [::altera_phylite::ip_arch_nf::pll::get_pll_settings $mem_clk_freq_mhz $ref_clk_freq_mhz $clk_ratios]
          if ($en_pll_core_ref_ck) {
          } else {
	        set_parameter_property "GUI_PLL_USE_CORE_REF_CLK" ENABLED false
	        set_parameter_property "GUI_PLL_USE_CORE_REF_CLK" VISIBLE false
          }
      } else {
	      set pll_settings [::altera_phylite::ip_arch_nd::pll::get_pll_settings $mem_clk_freq_mhz $ref_clk_freq_mhz $clk_ratios]
	      set_parameter_property "GUI_PLL_USE_CORE_REF_CLK" ENABLED false
	      set_parameter_property "GUI_PLL_USE_CORE_REF_CLK" VISIBLE false
	      set_parameter_property "GUI_${m_param_prefix}_USE_DYNAMIC_RECONFIGURATION" ENABLED false
      }
      set pll_clks_list           [dict get $pll_settings PLL_CLKS_LIST]
      set bypass_workaround [::altera_emif::util::qini::ini_is_on "ip_altera_phylite_disable_low_vco"]
      if {$bypass_workaround} {
	     set pll_compensation_mode "direct"
      } else {
	     set pll_compensation_mode "emif"
      }
   ::altera_iopll_common::iopll::set_pll_output_clocks_info $pll_compensation_mode $pll_clks_list
   ::altera_iopll_common::iopll::validate
   
   return 1
}


proc ::altera_phylite::ip_top::general::_validate_ref_clk_freq {} {
   variable m_param_prefix

   set default_ref_clk_freq [get_parameter_value "GUI_${m_param_prefix}_DEFAULT_REF_CLK_FREQ"]

   set mem_clk_freq_mhz [get_parameter_value "GUI_${m_param_prefix}_MEM_CLK_FREQ_MHZ"]

   set rate_enum [get_parameter_value "GUI_${m_param_prefix}_RATE_ENUM"]
   set user_afi_ratio [enum_data $rate_enum AFI_RATIO]
   set clk_ratios [dict create]
   dict set clk_ratios PHY_HMC $user_afi_ratio
   dict set clk_ratios C2P_P2C $user_afi_ratio 
   dict set clk_ratios USER    $user_afi_ratio

   if {$default_ref_clk_freq} {
      set legal_ref_freqs [altera_phylite::util::arch_expert::get_legal_pll_ref_clk_freqs_mhz $mem_clk_freq_mhz $clk_ratios 1]
      set ref_clk_freq_mhz [lindex $legal_ref_freqs 0]
   } else {
      set ref_clk_freq_mhz [get_parameter_value "GUI_${m_param_prefix}_USER_REF_CLK_FREQ_MHZ"]
      set legal_ref_freqs  [altera_phylite::util::arch_expert::get_legal_pll_ref_clk_freqs_mhz $mem_clk_freq_mhz $clk_ratios 20]
      
      if {[lsearch -exact -real $legal_ref_freqs $ref_clk_freq_mhz] == -1} {
         lappend legal_ref_freqs $ref_clk_freq_mhz
         post_ipgen_e_msg MSG_INVALID_PLL_REF_CLK_FREQ [list $ref_clk_freq_mhz]
      }
      set_parameter_property "GUI_${m_param_prefix}_USER_REF_CLK_FREQ_MHZ" ALLOWED_RANGES $legal_ref_freqs
   }

   set_parameter_property "${m_param_prefix}_REF_CLK_FREQ_MHZ"          VISIBLE [expr {$default_ref_clk_freq}]
   set_parameter_property "GUI_${m_param_prefix}_USER_REF_CLK_FREQ_MHZ" VISIBLE [expr {!$default_ref_clk_freq}]   
   
   set_parameter_value "${m_param_prefix}_REF_CLK_FREQ_MHZ" $ref_clk_freq_mhz
   
   set vco_to_mem_clk_freq_ratio [::altera_phylite::util::arch_expert::get_pll_vco_to_mem_clk_freq_ratio $mem_clk_freq_mhz]
   set vco_freq_mhz [expr {$mem_clk_freq_mhz * $vco_to_mem_clk_freq_ratio}]
   set_parameter_value "${m_param_prefix}_VCO_CLK_FREQ_MHZ" $vco_freq_mhz
   set_parameter_value "${m_param_prefix}_VCO_CLK_FREQ_MHZ_DISPLAY" $vco_freq_mhz
}

proc ::altera_phylite::ip_top::general::_validate_PLL_SPEED_GRADE { } {
    variable m_param_prefix
    set speedgrade [get_parameter_value SYS_INFO_DEVICE_SPEEDGRADE]
    
    if {[expr {[string compare -nocase $speedgrade "Unknown"] == 0}] || $speedgrade == ""} {
        set_parameter_value ${m_param_prefix}_PLL_SPEED_GRADE 1
    } else {
        set_parameter_value ${m_param_prefix}_PLL_SPEED_GRADE $speedgrade
    }
}

proc ::altera_phylite::ip_top::general::_set_user_ref_clk_freq_to_default {arg} {
   variable m_param_prefix

   set default_ref_clk_freq [get_parameter_value "GUI_${m_param_prefix}_DEFAULT_REF_CLK_FREQ"]

   set mem_clk_freq_mhz [get_parameter_value "GUI_${m_param_prefix}_MEM_CLK_FREQ_MHZ"]

   set rate_enum [get_parameter_value "GUI_${m_param_prefix}_RATE_ENUM"]
   set user_afi_ratio [enum_data $rate_enum AFI_RATIO]
   set clk_ratios [dict create]
   dict set clk_ratios PHY_HMC $user_afi_ratio
   dict set clk_ratios C2P_P2C $user_afi_ratio 
   dict set clk_ratios USER    $user_afi_ratio
   
   if {!$default_ref_clk_freq} {
      set legal_ref_freqs [altera_phylite::util::arch_expert::get_legal_pll_ref_clk_freqs_mhz $mem_clk_freq_mhz $clk_ratios 1]
      set ref_clk_freq_mhz [lindex $legal_ref_freqs 0]
      set_parameter_value "GUI_${m_param_prefix}_USER_REF_CLK_FREQ_MHZ" $ref_clk_freq_mhz
   } else {
      set_parameter_value "GUI_${m_param_prefix}_USER_REF_CLK_FREQ_MHZ" -1
      set_parameter_property "GUI_${m_param_prefix}_USER_REF_CLK_FREQ_MHZ" ALLOWED_RANGES {-1}
   }
}

proc ::altera_phylite::ip_top::general::_init {} {
}

::altera_phylite::ip_top::general::_init
