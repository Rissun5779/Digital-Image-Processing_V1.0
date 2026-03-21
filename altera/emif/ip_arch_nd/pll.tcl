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


package provide altera_emif::ip_arch_nd::pll 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::device_family
package require altera_emif::ip_arch_nd::util
package require altera_emif::ip_arch_nd::protocol_expert
package require altera_iopll_common::iopll

package require ::altera::pll_legality

namespace eval ::altera_emif::ip_arch_nd::pll:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_emif::ip_arch_nd::util::*
   namespace import ::altera_emif::ip_arch_nd::protocol_expert::*
   namespace import ::altera_iopll_common::iopll::*

}


proc ::altera_emif::ip_arch_nd::pll::add_pll_parameters {} {

   add_derived_hdl_param PLL_VCO_FREQ_MHZ_INT             integer          0
   add_derived_hdl_param PLL_VCO_TO_MEM_CLK_FREQ_RATIO    integer          1
   add_derived_hdl_param PLL_PHY_CLK_VCO_PHASE            integer          0
   
   add_derived_hdl_param PLL_VCO_FREQ_PS_STR              string           ""
   add_derived_hdl_param PLL_REF_CLK_FREQ_PS_STR          string           ""

   add_derived_hdl_param PLL_SIM_VCO_FREQ_PS              integer          0
   add_derived_hdl_param PLL_SIM_PHYCLK_0_FREQ_PS         integer          0
   add_derived_hdl_param PLL_SIM_PHYCLK_1_FREQ_PS         integer          0
   add_derived_hdl_param PLL_SIM_PHYCLK_FB_FREQ_PS        integer          0
   add_derived_hdl_param PLL_SIM_PHY_CLK_VCO_PHASE_PS     integer          0
   add_derived_hdl_param PLL_SIM_CAL_SLAVE_CLK_FREQ_PS    integer          0
   add_derived_hdl_param PLL_SIM_CAL_MASTER_CLK_FREQ_PS   integer          0
}

proc ::altera_emif::ip_arch_nd::pll::get_legal_pll_ref_clk_freqs_mhz {max_entries} {

   set retval [list]
   
   set pfd_fmax_mhz              [get_family_trait FAMILY_TRAIT_PLL_PFD_FMAX_MHZ]
   set pfd_fmin_mhz              [get_family_trait FAMILY_TRAIT_PLL_PFD_FMIN_MHZ]
   set min_vco_div               [get_family_trait FAMILY_TRAIT_PLL_MIN_VCO_DIV]
   set mem_clk_freq_mhz          [get_parameter_value PHY_MEM_CLK_FREQ_MHZ]
   set vco_to_mem_clk_freq_ratio [get_pll_vco_to_mem_clk_freq_ratio]
   set clk_ratios                [altera_emif::ip_arch_nd::protocol_expert::get_clk_ratios]   
   
   return [_get_legal_pll_ref_clk_freqs_mhz \
      $max_entries \
      $pfd_fmax_mhz \
      $pfd_fmin_mhz \
      $min_vco_div \
      $mem_clk_freq_mhz \
      $clk_ratios \
      $vco_to_mem_clk_freq_ratio]
}

proc ::altera_emif::ip_arch_nd::pll::get_legal_mem_clk_freqs_mhz {} {

   set retval [list]
   
   set ref_clk_freq_mhz          [get_parameter_value PHY_REF_CLK_FREQ_MHZ]
   set vco_to_mem_clk_freq_ratio [get_pll_vco_to_mem_clk_freq_ratio]
   set clk_ratios                [altera_emif::ip_arch_nd::protocol_expert::get_clk_ratios]
   set min_vco_div               [get_family_trait FAMILY_TRAIT_PLL_MIN_VCO_DIV]
   
   return [_get_legal_mem_clk_freqs_mhz \
      $ref_clk_freq_mhz \
      $clk_ratios \
      $vco_to_mem_clk_freq_ratio \
      $min_vco_div]
}

proc ::altera_emif::ip_arch_nd::pll::get_pll_vco_to_mem_clk_freq_ratio {} {

   set extra_configs_str [get_parameter_value "DIAG_EXTRA_CONFIGS"]
   set extra_configs [parse_extra_configs $extra_configs_str]
   
   if {[dict exists $extra_configs "FORCE_VCO_TO_MEM_CLK_FREQ_RATIO"]} {
      set ratio [dict get $extra_configs "FORCE_VCO_TO_MEM_CLK_FREQ_RATIO"]

   } else {
      set family             [enum_data [get_device_family_enum] MEGAFUNC_NAME]
      set speedgrade         [get_parameter_value PLL_SPEEDGRADE]
      set compensation_mode  direct
      set type               IOPLL
      set is_fractional      0
      
      set pll_api_params [list \
            -family $family \
            -type $type \
            -speedgrade $speedgrade \
            -is_fractional $is_fractional \
            -compensation_mode $compensation_mode]

      if {[catch {::quartus::pll::legality::get_legal_vco_range $pll_api_params} pll_api_result]} {
         emif_ie "Error executing PLL legality API to determine legal VCO range"
      }
      
      array set pll_afi_result_array $pll_api_result
      set vco_min $pll_afi_result_array(vco_min)
      set vco_max $pll_afi_result_array(vco_max)

      set mem_clk_freq_mhz [get_parameter_value "PHY_MEM_CLK_FREQ_MHZ"]

      if {$mem_clk_freq_mhz >= $vco_min} {
         set ratio 1
      } elseif {[expr {$mem_clk_freq_mhz * 2}] >= $vco_min} {
         set ratio 2
      } elseif {[expr {$mem_clk_freq_mhz * 4}] >= $vco_min} {
         set ratio 4
      } elseif {[expr {$mem_clk_freq_mhz * 8}] >= $vco_min} {
         set ratio 8
      } else {
         emif_ie "Memory clock frequency $mem_clk_freq_mhz is too low to be supported"
      }
      
      emif_assert {[expr {$mem_clk_freq_mhz * $ratio}] <= $vco_max}
   }
   
   return $ratio
}

proc ::altera_emif::ip_arch_nd::pll::get_pll_phy_clk_phase_setting {vco_freq_mhz} {

   set extra_configs_str [get_parameter_value "DIAG_EXTRA_CONFIGS"]
   set extra_configs [parse_extra_configs $extra_configs_str]
   
   if {[dict exists $extra_configs "FORCE_PHY_CLK_PHASE_SETTING"]} {
      set retval [dict get $extra_configs "FORCE_PHY_CLK_PHASE_SETTING"]
   } else {
      if {$vco_freq_mhz > 933} {
         set retval 1
      } else {
         set retval 0
      }
   }
   return $retval
}

proc ::altera_emif::ip_arch_nd::pll::derive_pll_parameters {} {

   set has_error 0
   
   set settings [get_pll_settings]   
   
   set param_names [list \
      PLL_VCO_FREQ_MHZ_INT \
      PLL_VCO_TO_MEM_CLK_FREQ_RATIO \
      PLL_VCO_FREQ_PS_STR \
      PLL_PHY_CLK_VCO_PHASE \
      PLL_REF_CLK_FREQ_PS_STR \
      PLL_SIM_VCO_FREQ_PS \
      PLL_SIM_PHYCLK_0_FREQ_PS \
      PLL_SIM_PHYCLK_1_FREQ_PS \
      PLL_SIM_PHYCLK_FB_FREQ_PS \
      PLL_SIM_PHY_CLK_VCO_PHASE_PS \
      PLL_SIM_CAL_SLAVE_CLK_FREQ_PS \
      PLL_SIM_CAL_MASTER_CLK_FREQ_PS]

   foreach param_name $param_names {
      set param_val [dict get $settings $param_name]
      set_parameter_value $param_name $param_val      
   }
}

proc ::altera_emif::ip_arch_nd::pll::get_pll_settings {} {

   set mem_clk_freq_mhz          [get_parameter_value PHY_MEM_CLK_FREQ_MHZ]
   set ref_clk_freq_mhz          [get_parameter_value PHY_REF_CLK_FREQ_MHZ]
   set clk_ratios                [altera_emif::ip_arch_nd::protocol_expert::get_clk_ratios]
   set vco_to_mem_clk_freq_ratio [get_pll_vco_to_mem_clk_freq_ratio]
   set vco_freq_mhz              [expr {$mem_clk_freq_mhz * $vco_to_mem_clk_freq_ratio}]
   set phy_clk_phase_setting     [get_pll_phy_clk_phase_setting $vco_freq_mhz]   
   
   set retval [_get_pll_settings \
      $mem_clk_freq_mhz \
      $ref_clk_freq_mhz \
      $clk_ratios \
      $vco_to_mem_clk_freq_ratio \
      $phy_clk_phase_setting]
   
   return $retval
}


proc ::altera_emif::ip_arch_nd::pll::_get_pll_settings {\
   mem_clk_freq_mhz \
   ref_clk_freq_mhz \
   clk_ratios \
   vco_to_mem_clk_freq_ratio \
   phy_clk_phase_setting
} {

   set retval [dict create]
   
   set vco_freq_mhz              [expr {$mem_clk_freq_mhz * $vco_to_mem_clk_freq_ratio}]
   set user_clk_ratio            [dict get $clk_ratios USER]
   set c2p_p2c_clk_ratio         [dict get $clk_ratios C2P_P2C]
   set phy_hmc_clk_ratio         [dict get $clk_ratios PHY_HMC]
   set slowest_clk_ratio         [_get_mem_clk_to_slowest_phy_clk_freq_ratio $clk_ratios]

   set n_counter         1
   set m_counter         [expr { int(round($vco_freq_mhz / $ref_clk_freq_mhz)) }]
   
   set vco_to_slowest_clk_ratio [expr {$vco_to_mem_clk_freq_ratio * $slowest_clk_ratio}]
   emif_assert { [expr {$m_counter % $vco_to_slowest_clk_ratio}] == 0 }   
      
   set vco_freq_ps  [expr {int(1000000.0 / $vco_freq_mhz)}]
   if {[expr {$vco_freq_ps % 2}] != 0} {
      incr vco_freq_ps
   }
   set mem_clk_freq_ps [expr {$vco_freq_ps * $vco_to_mem_clk_freq_ratio}]
   set ref_clk_freq_ps [expr {$vco_freq_ps * $m_counter}]
   
   dict set retval PLL_REF_CLK_FREQ_PS              $ref_clk_freq_ps
   dict set retval PLL_REF_CLK_FREQ_PS_STR          "$ref_clk_freq_ps ps"
   dict set retval PLL_VCO_FREQ_MHZ                 $vco_freq_mhz
   dict set retval PLL_VCO_FREQ_PS                  $vco_freq_ps
   dict set retval PLL_VCO_FREQ_PS_STR              "$vco_freq_ps ps"
   dict set retval PLL_VCO_FREQ_MHZ_INT             [expr {round($vco_freq_mhz)}]
   dict set retval PLL_VCO_TO_MEM_CLK_FREQ_RATIO    $vco_to_mem_clk_freq_ratio
   dict set retval PLL_MEM_CLK_FREQ_PS              $mem_clk_freq_ps
   
   set fast_sim_vco_freq_ps_factor 8
   set fast_sim_vco_freq_ps_error  [expr {$vco_freq_ps % $fast_sim_vco_freq_ps_factor}]
   if {$fast_sim_vco_freq_ps_error != 0} {
      set fast_sim_vco_freq_ps [expr {$vco_freq_ps + ($fast_sim_vco_freq_ps_factor - $fast_sim_vco_freq_ps_error)}]
   } else {
      set fast_sim_vco_freq_ps $vco_freq_ps
   }
   dict set retval PLL_SIM_VCO_FREQ_PS $fast_sim_vco_freq_ps
   
   set phy_clk_vco_phase_ps          [expr {int(round($vco_freq_ps          * 1.0 * $phy_clk_phase_setting / 8))}]
   set fast_sim_phy_clk_vco_phase_ps [expr {int(round($fast_sim_vco_freq_ps * 1.0 * $phy_clk_phase_setting / 8))}]
   
   dict set retval PLL_PHY_CLK_VCO_PHASE         $phy_clk_phase_setting
   dict set retval PLL_PHY_CLK_VCO_PHASE_PS      $phy_clk_vco_phase_ps
   dict set retval PLL_SIM_PHY_CLK_VCO_PHASE_PS  $fast_sim_phy_clk_vco_phase_ps
   
   set phyclk_fb_counter           [expr {$vco_to_mem_clk_freq_ratio * $slowest_clk_ratio}]
   set phyclk_fb_freq_mhz          [expr {$vco_freq_mhz / $phyclk_fb_counter}]
   set phyclk_fb_freq_ps           [expr {$vco_freq_ps  * $phyclk_fb_counter}]
   set fast_sim_phyclk_fb_freq_ps  [expr {$fast_sim_vco_freq_ps * $phyclk_fb_counter}]
   
   dict set retval PLL_PHYCLK_FB_FREQ_PS            $phyclk_fb_freq_ps
   dict set retval PLL_SIM_PHYCLK_FB_FREQ_PS        $fast_sim_phyclk_fb_freq_ps
      
   set phyclk_0_counter            [expr {$vco_to_mem_clk_freq_ratio * $phy_hmc_clk_ratio}]
   set phyclk_0_freq_mhz           [expr {$vco_freq_mhz / $phyclk_0_counter}]
   set phyclk_0_freq_ps            [expr {$vco_freq_ps  * $phyclk_0_counter}]
   set fast_sim_phyclk_0_freq_ps   [expr {$fast_sim_vco_freq_ps * $phyclk_0_counter}]
   
   dict set retval PLL_PHYCLK_0_FREQ_PS             $phyclk_0_freq_ps
   dict set retval PLL_SIM_PHYCLK_0_FREQ_PS         $fast_sim_phyclk_0_freq_ps
      
   set phyclk_1_counter            [expr {$vco_to_mem_clk_freq_ratio * $c2p_p2c_clk_ratio}]
   set phyclk_1_freq_mhz           [expr {$vco_freq_mhz / $phyclk_1_counter}]
   set phyclk_1_freq_ps            [expr {$vco_freq_ps  * $phyclk_1_counter}]
   set fast_sim_phyclk_1_freq_ps   [expr {$fast_sim_vco_freq_ps * $phyclk_1_counter}]

   dict set retval PLL_PHYCLK_1_FREQ_PS             $phyclk_1_freq_ps
   dict set retval PLL_SIM_PHYCLK_1_FREQ_PS         $fast_sim_phyclk_1_freq_ps
   
   set cal_slave_clk_counter           [expr {$vco_freq_mhz / 166.6667}]
   
   set cal_slave_clk_counter           [expr {int(ceil(round($cal_slave_clk_counter * 100.0) / 100.0))}]
   set cal_slave_clk_freq_mhz          [expr {$vco_freq_mhz / $cal_slave_clk_counter}]
   set cal_slave_clk_freq_ps           [expr {$vco_freq_ps  * $cal_slave_clk_counter}]
   set fast_sim_cal_slave_clk_freq_ps  [expr {$fast_sim_vco_freq_ps * $cal_slave_clk_counter}]
   
   dict set retval PLL_CAL_SLAVE_CLK_FREQ_PS      $cal_slave_clk_freq_ps
   dict set retval PLL_SIM_CAL_SLAVE_CLK_FREQ_PS  $fast_sim_cal_slave_clk_freq_ps
   
   set cal_master_clk_counter           [expr {$vco_freq_mhz / 166.6667}]
   
   set cal_master_clk_counter           [expr {int(ceil(round($cal_master_clk_counter * 100.0) / 100.0))}]
   set cal_master_clk_freq_mhz          [expr {$vco_freq_mhz / $cal_master_clk_counter}]
   set cal_master_clk_freq_ps           [expr {$vco_freq_ps  * $cal_master_clk_counter}]
   set fast_sim_cal_master_clk_freq_ps  [expr {$fast_sim_vco_freq_ps * $cal_master_clk_counter}]
   
   dict set retval PLL_CAL_MASTER_CLK_FREQ_PS      $cal_master_clk_freq_ps
   dict set retval PLL_SIM_CAL_MASTER_CLK_FREQ_PS  $fast_sim_cal_master_clk_freq_ps

   
   
   dict set retval PLL_COMPENSATION_MODE "direct"
   
   set speedgrade [get_speedgrade]
   if {$speedgrade == ""} {
      set speedgrade 1
   } else {
      set speedgrade [string range $speedgrade 1 1]
   }
   dict set retval PLL_SPEEDGRADE $speedgrade
   
   set clks_list [list]
   
   lappend clks_list $phyclk_1_freq_mhz
   lappend clks_list $phy_clk_vco_phase_ps
   lappend clks_list 50
   
   lappend clks_list $phyclk_0_freq_mhz
   lappend clks_list $phy_clk_vco_phase_ps
   lappend clks_list 50
   					
   lappend clks_list $phyclk_fb_freq_mhz
   lappend clks_list $phy_clk_vco_phase_ps
   lappend clks_list 50
   
   lappend clks_list $cal_slave_clk_freq_mhz
   lappend clks_list 0
   lappend clks_list 50
   
   lappend clks_list $cal_master_clk_freq_mhz
   lappend clks_list 0
   lappend clks_list 50

   dict set retval PLL_CLKS_LIST $clks_list
   
   return $retval
}

proc ::altera_emif::ip_arch_nd::pll::_is_pll_m_counter_valid {
   pll_m \
   min_vco_div
} {
   if {$pll_m < $min_vco_div} {
      return 0
   } elseif {$pll_m > 160} {
      return 0
   } else {
      return 1
   }
}

proc ::altera_emif::ip_arch_nd::pll::_get_legal_pll_ref_clk_freqs_mhz {
   max_entries \
   pfd_fmax_mhz \
   pfd_fmin_mhz \
   min_vco_div \
   mem_clk_freq_mhz \
   clk_ratios \
   vco_to_mem_clk_freq_ratio
} {
   set retval [list]
   
   
   set vco_freq_mhz [expr {$mem_clk_freq_mhz * $vco_to_mem_clk_freq_ratio}]
      
   set slowest_clk_ratio [_get_mem_clk_to_slowest_phy_clk_freq_ratio $clk_ratios]
   
   for {set i 1} {[llength $retval] < $max_entries} {incr i} {
      set divisor          [expr {$vco_to_mem_clk_freq_ratio * $slowest_clk_ratio * $i}]
      set ref_clk_freq_mhz [expr {$vco_freq_mhz / $divisor}]
      
      set divisor_is_valid [_is_pll_m_counter_valid $divisor $min_vco_div]
      
      if {$divisor > 160} {
         break
      } elseif {$ref_clk_freq_mhz <= $pfd_fmin_mhz} {
         break
      } elseif {$ref_clk_freq_mhz >= $pfd_fmax_mhz} {
      } elseif {!$divisor_is_valid} {
      } else {
         set ref_clk_freq_mhz [expr {round($ref_clk_freq_mhz * 1000.0) / 1000.0}]
         lappend retval $ref_clk_freq_mhz
      }
   }
   
   return $retval
}

proc ::altera_emif::ip_arch_nd::pll::_get_legal_mem_clk_freqs_mhz {
   ref_clk_freq_mhz \
   clk_ratios \
   vco_to_mem_clk_freq_ratio \
   min_vco_div
} {
   set retval [list]
   
   set slowest_clk_ratio [_get_mem_clk_to_slowest_phy_clk_freq_ratio $clk_ratios]
   set protocol_enum     [get_parameter_value PROTOCOL_ENUM]
   set rate_enum         [get_parameter_value PHY_RATE_ENUM]
   set mem_clk_fmax_mhz  [get_feature_support_level FEATURE_FMAX_MHZ $protocol_enum $rate_enum]
   set mem_clk_fmin_mhz  [get_feature_support_level FEATURE_FMIN_MHZ $protocol_enum $rate_enum]
   
   for {set i 1} {$i < 50} {incr i} {
      set slowest_clk_freq_mhz [expr {$ref_clk_freq_mhz * $i}]
      set mem_clk_freq_mhz     [expr {$slowest_clk_freq_mhz * $slowest_clk_ratio}]
      set vco_freq_mhz         [expr {$mem_clk_freq_mhz * $vco_to_mem_clk_freq_ratio}]
      set pll_m                [expr {$vco_to_mem_clk_freq_ratio * $slowest_clk_ratio * $i}]
      
      if {[_is_pll_m_counter_valid $pll_m $min_vco_div]} {
         if {$mem_clk_freq_mhz < $mem_clk_fmin_mhz} {
         } elseif {$mem_clk_freq_mhz > $mem_clk_fmax_mhz} {
            break
         } else {
            set rounded_mem_clk_freq_mhz [expr {round($mem_clk_freq_mhz * 100.0) / 100.0}]
            lappend retval $rounded_mem_clk_freq_mhz
         }
      }
   }
   return $retval
}

proc ::altera_emif::ip_arch_nd::pll::_get_mem_clk_to_slowest_phy_clk_freq_ratio {clk_ratios} {
   return [dict get $clk_ratios C2P_P2C]
}

proc ::altera_emif::ip_arch_nd::pll::_init {} {

   if {[emif_utest_enabled]} {   
   
   
      
      set mem_clk_freq_mhz             300.0
      set vco_to_mem_clk_freq_ratio    4
      set clk_ratios                   [dict create PHY_HMC 1 C2P_P2C 1 USER 1]
      set ref_clk_freqs_mhz            [_get_legal_pll_ref_clk_freqs_mhz 5 325 10 4 $mem_clk_freq_mhz $clk_ratios $vco_to_mem_clk_freq_ratio]
      set ref_clk_freq_mhz             [lindex $ref_clk_freqs_mhz 0]
      
      set settings [_get_pll_settings \
         $mem_clk_freq_mhz \
         $ref_clk_freq_mhz \
         $clk_ratios \
         $vco_to_mem_clk_freq_ratio \
         0]
         
      emif_assert {[dict get $settings PLL_REF_CLK_FREQ_PS]           == 3336     }
      emif_assert {[dict get $settings PLL_VCO_FREQ_MHZ]              == 1200     }
      emif_assert {[dict get $settings PLL_VCO_FREQ_PS]               == 834      }
      emif_assert {[dict get $settings PLL_VCO_FREQ_MHZ_INT]          == 1200     }
      emif_assert {[dict get $settings PLL_VCO_TO_MEM_CLK_FREQ_RATIO] == 4        }
      emif_assert {[dict get $settings PLL_MEM_CLK_FREQ_PS]           == 3336     }
      emif_assert {[dict get $settings PLL_PHYCLK_FB_FREQ_PS]         == 3336     }
      emif_assert {[dict get $settings PLL_PHYCLK_0_FREQ_PS]          == 3336     }
      emif_assert {[dict get $settings PLL_PHYCLK_1_FREQ_PS]          == 3336     }
      
      set mem_clk_freq_mhz             300.0
      set vco_to_mem_clk_freq_ratio    4
      set clk_ratios                   [dict create PHY_HMC 1 C2P_P2C 1 USER 1]
      set ref_clk_freqs_mhz            [_get_legal_pll_ref_clk_freqs_mhz 5 325 10 4 $mem_clk_freq_mhz $clk_ratios $vco_to_mem_clk_freq_ratio]
      set ref_clk_freq_mhz             [lindex $ref_clk_freqs_mhz 1]
         
      set settings [_get_pll_settings \
         $mem_clk_freq_mhz \
         $ref_clk_freq_mhz \
         $clk_ratios \
         $vco_to_mem_clk_freq_ratio \
         0]
         
      emif_assert {[dict get $settings PLL_REF_CLK_FREQ_PS]           == 6672     }
      emif_assert {[dict get $settings PLL_VCO_FREQ_MHZ]              == 1200     }
      emif_assert {[dict get $settings PLL_VCO_FREQ_PS]               == 834      }
      emif_assert {[dict get $settings PLL_VCO_FREQ_MHZ_INT]          == 1200     }
      emif_assert {[dict get $settings PLL_VCO_TO_MEM_CLK_FREQ_RATIO] == 4        }
      emif_assert {[dict get $settings PLL_MEM_CLK_FREQ_PS]           == 3336     }
      emif_assert {[dict get $settings PLL_PHYCLK_FB_FREQ_PS]         == 3336     }
      emif_assert {[dict get $settings PLL_PHYCLK_0_FREQ_PS]          == 3336     }
      emif_assert {[dict get $settings PLL_PHYCLK_1_FREQ_PS]          == 3336     }
      
      set mem_clk_freq_mhz             533.0
      set vco_to_mem_clk_freq_ratio    2
      set clk_ratios                   [dict create PHY_HMC 2 C2P_P2C 2 USER 2]
      set ref_clk_freqs_mhz            [_get_legal_pll_ref_clk_freqs_mhz 5 325 10 4 $mem_clk_freq_mhz $clk_ratios $vco_to_mem_clk_freq_ratio]
      set ref_clk_freq_mhz             [lindex $ref_clk_freqs_mhz 2]
         
      set settings [_get_pll_settings \
         $mem_clk_freq_mhz \
         $ref_clk_freq_mhz \
         $clk_ratios \
         $vco_to_mem_clk_freq_ratio \
         0]
         
      emif_assert {[dict get $settings PLL_REF_CLK_FREQ_PS]           == 11256    }
      emif_assert {[dict get $settings PLL_VCO_FREQ_MHZ]              == 1066     }
      emif_assert {[dict get $settings PLL_VCO_FREQ_PS]               == 938      }
      emif_assert {[dict get $settings PLL_VCO_FREQ_MHZ_INT]          == 1066     }
      emif_assert {[dict get $settings PLL_VCO_TO_MEM_CLK_FREQ_RATIO] == 2        }
      emif_assert {[dict get $settings PLL_MEM_CLK_FREQ_PS]           == 1876     }
      emif_assert {[dict get $settings PLL_PHYCLK_FB_FREQ_PS]         == 3752     }
      emif_assert {[dict get $settings PLL_PHYCLK_0_FREQ_PS]          == 3752     }
      emif_assert {[dict get $settings PLL_PHYCLK_1_FREQ_PS]          == 3752     }
      
      set mem_clk_freq_mhz             800.0
      set vco_to_mem_clk_freq_ratio    1
      set clk_ratios                   [dict create PHY_HMC 4 C2P_P2C 4 USER 4]
      set ref_clk_freqs_mhz            [_get_legal_pll_ref_clk_freqs_mhz 5 325 10 4 $mem_clk_freq_mhz $clk_ratios $vco_to_mem_clk_freq_ratio]
      set ref_clk_freq_mhz             [lindex $ref_clk_freqs_mhz 0]
      
      set settings [_get_pll_settings \
         $mem_clk_freq_mhz \
         $ref_clk_freq_mhz \
         $clk_ratios \
         $vco_to_mem_clk_freq_ratio \
         0]

      emif_assert {[dict get $settings PLL_REF_CLK_FREQ_PS]           == 5000     }
      emif_assert {[dict get $settings PLL_VCO_FREQ_MHZ]              == 800      }
      emif_assert {[dict get $settings PLL_VCO_FREQ_PS]               == 1250     }
      emif_assert {[dict get $settings PLL_VCO_FREQ_MHZ_INT]          == 800      }
      emif_assert {[dict get $settings PLL_VCO_TO_MEM_CLK_FREQ_RATIO] == 1        }
      emif_assert {[dict get $settings PLL_MEM_CLK_FREQ_PS]           == 1250     }
      emif_assert {[dict get $settings PLL_PHYCLK_FB_FREQ_PS]         == 5000     }
      emif_assert {[dict get $settings PLL_PHYCLK_0_FREQ_PS]          == 5000     }
      emif_assert {[dict get $settings PLL_PHYCLK_1_FREQ_PS]          == 5000     }
      
      set mem_clk_freq_mhz             800.0
      set vco_to_mem_clk_freq_ratio    1
      set clk_ratios                   [dict create PHY_HMC 2 C2P_P2C 4 USER 4]
      set ref_clk_freqs_mhz            [_get_legal_pll_ref_clk_freqs_mhz 5 325 10 4 $mem_clk_freq_mhz $clk_ratios $vco_to_mem_clk_freq_ratio]
      set ref_clk_freq_mhz             [lindex $ref_clk_freqs_mhz 0]
      
      set settings [_get_pll_settings \
         $mem_clk_freq_mhz \
         $ref_clk_freq_mhz \
         $clk_ratios \
         $vco_to_mem_clk_freq_ratio \
         0]

      emif_assert {[dict get $settings PLL_REF_CLK_FREQ_PS]           == 5000     }
      emif_assert {[dict get $settings PLL_VCO_FREQ_MHZ]              == 800      }
      emif_assert {[dict get $settings PLL_VCO_FREQ_PS]               == 1250     }
      emif_assert {[dict get $settings PLL_VCO_FREQ_MHZ_INT]          == 800      }
      emif_assert {[dict get $settings PLL_VCO_TO_MEM_CLK_FREQ_RATIO] == 1        }
      emif_assert {[dict get $settings PLL_MEM_CLK_FREQ_PS]           == 1250     }
      emif_assert {[dict get $settings PLL_PHYCLK_FB_FREQ_PS]         == 5000     }
      emif_assert {[dict get $settings PLL_PHYCLK_0_FREQ_PS]          == 2500     }
      emif_assert {[dict get $settings PLL_PHYCLK_1_FREQ_PS]          == 5000     }

      set mem_clk_freq_mhz             1200.0
      set vco_to_mem_clk_freq_ratio    1
      set clk_ratios                   [dict create PHY_HMC 4 C2P_P2C 4 USER 8]
      set ref_clk_freqs_mhz            [_get_legal_pll_ref_clk_freqs_mhz 5 325 10 4 $mem_clk_freq_mhz $clk_ratios $vco_to_mem_clk_freq_ratio]
      set ref_clk_freq_mhz             [lindex $ref_clk_freqs_mhz 0]
         
      set settings [_get_pll_settings \
         $mem_clk_freq_mhz \
         $ref_clk_freq_mhz \
         $clk_ratios \
         $vco_to_mem_clk_freq_ratio \
         0]
         
      emif_assert {[dict get $settings PLL_REF_CLK_FREQ_PS]           == 3336     }
      emif_assert {[dict get $settings PLL_VCO_FREQ_MHZ]              == 1200     }
      emif_assert {[dict get $settings PLL_VCO_FREQ_PS]               == 834      }
      emif_assert {[dict get $settings PLL_VCO_FREQ_MHZ_INT]          == 1200     }
      emif_assert {[dict get $settings PLL_VCO_TO_MEM_CLK_FREQ_RATIO] == 1        }
      emif_assert {[dict get $settings PLL_MEM_CLK_FREQ_PS]           == 834      }
      emif_assert {[dict get $settings PLL_PHYCLK_FB_FREQ_PS]         == 3336     }
      emif_assert {[dict get $settings PLL_PHYCLK_0_FREQ_PS]          == 3336     }
      emif_assert {[dict get $settings PLL_PHYCLK_1_FREQ_PS]          == 3336     }

      set mem_clk_freq_mhz             1200.0
      set vco_to_mem_clk_freq_ratio    1
      set clk_ratios                   [dict create PHY_HMC 2 C2P_P2C 4 USER 8]
      set ref_clk_freqs_mhz            [_get_legal_pll_ref_clk_freqs_mhz 5 325 10 4 $mem_clk_freq_mhz $clk_ratios $vco_to_mem_clk_freq_ratio]
      set ref_clk_freq_mhz             [lindex $ref_clk_freqs_mhz 0]
      
      set settings [_get_pll_settings \
         $mem_clk_freq_mhz \
         $ref_clk_freq_mhz \
         $clk_ratios \
         $vco_to_mem_clk_freq_ratio \
         0]
         
      emif_assert {[dict get $settings PLL_REF_CLK_FREQ_PS]           == 3336     }
      emif_assert {[dict get $settings PLL_VCO_FREQ_MHZ]              == 1200     }
      emif_assert {[dict get $settings PLL_VCO_FREQ_PS]               == 834      }
      emif_assert {[dict get $settings PLL_VCO_FREQ_MHZ_INT]          == 1200     }
      emif_assert {[dict get $settings PLL_VCO_TO_MEM_CLK_FREQ_RATIO] == 1        }
      emif_assert {[dict get $settings PLL_MEM_CLK_FREQ_PS]           == 834      }
      emif_assert {[dict get $settings PLL_PHYCLK_FB_FREQ_PS]         == 3336     }
      emif_assert {[dict get $settings PLL_PHYCLK_0_FREQ_PS]          == 1668     }
      emif_assert {[dict get $settings PLL_PHYCLK_1_FREQ_PS]          == 3336     }
      
   }
}

::altera_emif::ip_arch_nd::pll::_init
