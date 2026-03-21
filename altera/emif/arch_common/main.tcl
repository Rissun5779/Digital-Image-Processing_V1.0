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


package provide altera_emif::arch_common::main 0.1

package require altera_emif::util::messaging
package require altera_emif::util::math
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_emif::util::enum_defs_interfaces
package require altera_emif::util::enum_defs_family_traits_and_features
package require altera_emif::util::device_family
package require altera_emif::util::doc_gen

package require altera_iopll_common::iopll

package require altera_emif::arch_common::util

namespace eval ::altera_emif::arch_common::main:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_iopll_common::iopll::*
   namespace import ::altera_emif::arch_common::util::*


}


proc ::altera_emif::arch_common::main::derive_family_trait_parameters {} {
   foreach family_trait_enum [enums_of_type FAMILY_TRAIT] {
      if {$family_trait_enum == "FAMILY_TRAIT_INVALID"} {
         continue
      }
      if {[enum_data $family_trait_enum IS_HDL_PARAM]} {
         set param_val [::altera_emif::util::device_family::get_family_trait $family_trait_enum]
         set param_name [enum_data $family_trait_enum]
         set_parameter_value $param_name $param_val
      }
   }
   return 1
}

proc ::altera_emif::arch_common::main::derive_port_width_parameters {if_ports} {
   foreach if_enum [dict keys $if_ports] {
      set ports [dict get $if_ports $if_enum PORTS]
      ::altera_emif::util::hwtcl_utils::derive_port_width_parameters $ports
   }
   return 1
}


proc ::altera_emif::arch_common::main::derive_mem_ports_pinloc_parameters {mem_ports mem_pins_alloc} {

   set pinlocs [dict create]

   foreach port $mem_ports {
      set enabled [dict get $port ENABLED]
      
      if {$enabled} {
         set type_enum [dict get $port TYPE_ENUM]
         set bus_width [dict get $port BUS_WIDTH]
         set bus_index [dict get $port BUS_INDEX]
         set abs_pin_index [dict get $port ABS_PIN_INDEX]
         
         emif_assert {$bus_index >= 0}
         emif_assert {$abs_pin_index >= 0}
         
         if {![dict exists $pinlocs $type_enum]} {
            set pinloc [string repeat "0000000000" $bus_width]
            append pinloc [num2bin $bus_width 10]
         } else {
            set pinloc [dict get $pinlocs $type_enum]
         }
         
         set first [expr {($bus_width - $bus_index - 1) * 10}]
         set last  [expr {$first + 9}]
         set abs_pin_index_binstr [num2bin $abs_pin_index 10]
         set pinloc [string replace $pinloc $first $last $abs_pin_index_binstr]
         dict set pinlocs $type_enum $pinloc
      }
   }
   
   foreach type_enum [dict keys $pinlocs] {
      set pinloc [dict get $pinlocs $type_enum]
      set_long_bitvec_hdl_param_value "${type_enum}_PINLOC" $pinloc
   }
}

proc ::altera_emif::arch_common::main::derive_unused_pins_pinloc_parameters {mem_ports mem_pins_alloc} {

   set lanes_per_tile   [get_family_trait FAMILY_TRAIT_LANES_PER_TILE]
   set pins_per_lane    [get_family_trait FAMILY_TRAIT_PINS_PER_LANE]
   
   set num_of_rtl_tiles [dict size $mem_pins_alloc]
   set used_pins        [dict create]
   set used_dqs_buses   [dict create]

   foreach port $mem_ports {
      set enabled [dict get $port ENABLED]
      
      if {$enabled} {
         set type_enum     [dict get $port TYPE_ENUM]
         set abs_pin_index [dict get $port ABS_PIN_INDEX]
         
         emif_assert {$abs_pin_index >= 0}
         dict set used_pins $abs_pin_index 1
         
         if {[enum_data $type_enum IS_RCLK]} {
            set tile_index    [dict get $port TILE_INDEX]
            set lane_index    [dict get $port LANE_INDEX]
            dict set used_dqs_buses [expr {$tile_index * $lanes_per_tile + $lane_index}] 1
         }
      }
   }
   
   set unused_mem_pins_pinloc        ""
   set num_of_mem_pins_in_rtl_tiles  [expr {$num_of_rtl_tiles * $lanes_per_tile * $pins_per_lane}]
   set num_of_unused_mem_pins        [expr {$num_of_mem_pins_in_rtl_tiles - [dict size $used_pins]}]
   set first_usable_pin_i            0
   set last_usable_pin_i             [expr {$first_usable_pin_i + $num_of_mem_pins_in_rtl_tiles - 1}]
   
   for {set i $first_usable_pin_i} {$i <= $last_usable_pin_i} {incr i} {
      if {![dict exists $used_pins $i]} {
         append unused_mem_pins_pinloc [num2bin $i 10]
      }
   }
   append unused_mem_pins_pinloc [num2bin $num_of_unused_mem_pins 10]
   set_long_bitvec_hdl_param_value UNUSED_MEM_PINS_PINLOC $unused_mem_pins_pinloc
   
   set unused_dqs_buses_laneloc      ""
   set num_of_dqs_buses_in_rtl_lanes [expr {$num_of_rtl_tiles * $lanes_per_tile}]
   set num_of_unused_dqs_buses       [expr {$num_of_dqs_buses_in_rtl_lanes - [dict size $used_dqs_buses]}]
   set first_usable_dqs_bus_i        0
   set last_usable_dqs_bus_i         [expr {$first_usable_dqs_bus_i + $num_of_dqs_buses_in_rtl_lanes - 1}]

   for {set i $first_usable_dqs_bus_i} {$i <= $last_usable_dqs_bus_i} {incr i} {
      if {![dict exists $used_dqs_buses $i]} {
         append unused_dqs_buses_laneloc [num2bin $i 10]
      }
   }
   append unused_dqs_buses_laneloc [num2bin $num_of_unused_dqs_buses 10]
   set_long_bitvec_hdl_param_value UNUSED_DQS_BUSES_LANELOC $unused_dqs_buses_laneloc
}

proc ::altera_emif::arch_common::main::update_qip {if_ports} {
   
   set qip_strings [list ]
   
   set set_inst_asgmnt "set_instance_assignment -entity \"%entityName%\" -library \"%libraryName%\""

   foreach if_enum [dict keys $if_ports] {
      set ports [dict get $if_ports $if_enum PORTS]
      
      foreach port $ports {
         set bus_index [dict get $port BUS_INDEX]
         set enabled   [dict get $port ENABLED]
         set set_output_term 0
         
         if {$enabled} {
            
            set type_enum [dict get $port TYPE_ENUM]
            set port_name [enum_data $type_enum RTL_NAME]
            if {$bus_index != -1} {
               set port_name "${port_name}\[$bus_index\]"
            }
            
            if {[dict exists $port IO_STD]} {
               set io_std_enum [dict get $port IO_STD]
               set io_std_qsf [enum_data $io_std_enum QSF_NAME]
               lappend qip_strings "$set_inst_asgmnt -name IO_STANDARD \"$io_std_qsf\" -to \"${port_name}\""
            }
            
            if {[dict exists $port OUT_OCT]} {
               set out_oct_enum [dict get $port OUT_OCT]
               if {$out_oct_enum != "OUT_OCT_INVALID"} {
                  set set_output_term 1
                  set out_oct_qsf [enum_data $out_oct_enum QSF_NAME]
                  lappend qip_strings "$set_inst_asgmnt -name OUTPUT_TERMINATION \"$out_oct_qsf\" -to \"${port_name}\""
               }
            }
            
            if {[dict exists $port IN_OCT]} {
               set in_oct_enum [dict get $port IN_OCT]
               if {$in_oct_enum != "IN_OCT_INVALID"} {
                  set is_neg_leg [enum_data $type_enum IS_NEG_LEG]
                  set is_cp_rclk [enum_data $type_enum IS_CP_RCLK]
                  if {$is_neg_leg && !$is_cp_rclk} {
                  } else {
                     set in_oct_qsf [enum_data $in_oct_enum QSF_NAME]
                     lappend qip_strings "$set_inst_asgmnt -name INPUT_TERMINATION \"$in_oct_qsf\" -to \"${port_name}\""
                  }
               }
            }
            
            if {[dict exists $port CURRENT_ST]} {
               set current_st_enum [dict get $port CURRENT_ST]
               if {$current_st_enum != "CURRENT_ST_INVALID"} {
                  set current_st_qsf  [enum_data $current_st_enum QSF_NAME]
                  lappend qip_strings "$set_inst_asgmnt -name CURRENT_STRENGTH_NEW \"$current_st_qsf\" -to \"${port_name}\""
                  
                  emif_assert {!$set_output_term}
                  
                  lappend qip_strings "$set_inst_asgmnt -name OUTPUT_TERMINATION OFF -to \"${port_name}\""
               }
            }
    
            if {[dict exists $port SLEW_RATE]} {
               set slew_rate_enum  [dict get $port SLEW_RATE]
               if {$slew_rate_enum != "SLEW_RATE_INVALID"} {
                  set slew_rate_qsf [enum_data $slew_rate_enum QSF_NAME]
                  lappend qip_strings "$set_inst_asgmnt -name SLEW_RATE \"$slew_rate_qsf\" -to \"${port_name}\""
               }
            }
            
            if {[dict exists $port AIOT_SIM_OPEN]} {
               if {[dict get $port AIOT_SIM_OPEN]} {
                  lappend qip_strings "$set_inst_asgmnt -name BOARD_MODEL_FAR_PULLUP_R OPEN -to \"${port_name}\""
                  lappend qip_strings "$set_inst_asgmnt -name BOARD_MODEL_NEAR_PULLUP_R OPEN -to \"${port_name}\""
                  lappend qip_strings "$set_inst_asgmnt -name BOARD_MODEL_FAR_PULLDOWN_R OPEN -to \"${port_name}\""
                  lappend qip_strings "$set_inst_asgmnt -name BOARD_MODEL_NEAR_PULLDOWN_R OPEN -to \"${port_name}\""
               }
            }

            if {[dict exists $port PKG_DESKEW]} {
               if {[dict get $port PKG_DESKEW]} {
                  lappend qip_strings "$set_inst_asgmnt -name PACKAGE_SKEW_COMPENSATION ON -to \"${port_name}\""
               }
            }

            if {[dict exists $port VREF_MODE]} {
               set vref_mode_enum [dict get $port VREF_MODE]
               if {$vref_mode_enum != "VREF_MODE_INVALID"} {
                  set is_neg_leg [enum_data $type_enum IS_NEG_LEG]
                  set is_cp_rclk [enum_data $type_enum IS_CP_RCLK]
                  if {$is_neg_leg && !$is_cp_rclk} {
                  } else {
                     set vref_mode_qsf [enum_data $vref_mode_enum QSF_NAME]
                     lappend qip_strings "$set_inst_asgmnt -name VREF_MODE \"$vref_mode_qsf\" -to \"${port_name}\""
                  }
               }
            }
         }
      }
   }
   
   set_qip_strings $qip_strings
}


proc ::altera_emif::arch_common::main::derive_lanes_parameters {ac_tile_index ac_pm_scheme mem_ports mem_pins_alloc} {

   set num_of_rtl_tiles  [dict size $mem_pins_alloc]
   set lanes_per_tile    [get_family_trait FAMILY_TRAIT_LANES_PER_TILE]
   set lanes_in_if       [expr {$num_of_rtl_tiles * $lanes_per_tile}]
   set phy_config_enum   [get_parameter_value "PHY_CONFIG_ENUM"]
   set ping_pong_en      [get_parameter_value "PHY_PING_PONG_EN"]
   
   set num_of_rtl_tiles [dict size $mem_pins_alloc]
   set_parameter_value NUM_OF_RTL_TILES $num_of_rtl_tiles
 
   set ac_pm_enum        [dict get $ac_pm_scheme ENUM]
   set_parameter_value AC_PIN_MAP_SCHEME [enum_data $ac_pm_enum WYSIWYG_VAL]

   set bitstr_len         [string length [enum_data LANE_USAGE_UNUSED BITSTR]]
   set lanes_usage        [string repeat [enum_data LANE_USAGE_UNUSED BITSTR] $lanes_in_if]
   set num_of_ac_lanes    [enum_data $ac_pm_enum LANES_USED]
   set num_of_read_groups [get_parameter_value MEM_TTL_NUM_OF_READ_GROUPS]
   
   set pri_ac_tile_i      $ac_tile_index
   set pri_rdata_tile_i   -1
   set pri_rdata_lane_i   -1
   set pri_wdata_tile_i   -1
   set pri_wdata_lane_i   -1
   
   set sec_ac_tile_i      [expr {$ping_pong_en ? ($pri_ac_tile_i - 1) : $pri_ac_tile_i}]
   set sec_rdata_tile_i   -1
   set sec_rdata_lane_i   -1
   set sec_wdata_tile_i   -1
   set sec_wdata_lane_i   -1
      
   foreach tile_i [dict keys $mem_pins_alloc] {
      
      emif_assert {$tile_i >= 0 && $tile_i < $num_of_rtl_tiles}
   
      set tile [dict get $mem_pins_alloc $tile_i]
      
      foreach lane_i [dict keys $tile] {
         set abs_lane_index [expr {$tile_i * $lanes_per_tile + $lane_i}]

         if {$pri_ac_tile_i == $tile_i && $lane_i < $num_of_ac_lanes} {
            if {$phy_config_enum == "CONFIG_PHY_AND_HARD_CTRL"} {
               set bitstr [enum_data LANE_USAGE_AC_HMC BITSTR]
            } else {
               set bitstr [enum_data LANE_USAGE_AC_CORE BITSTR]
            }
         } else {
            set is_rd_lane 0
            set is_wr_lane 0
            set is_pp_sec_data_group 0
            
            set lane [dict get $tile $lane_i]
            foreach pin_i [dict keys $lane] {
               set port       [dict get $lane $pin_i]
               set port_enum  [dict get $port TYPE_ENUM]
                              
               if {[enum_data $port_enum IS_RCLK] || [enum_data $port_enum IS_RDATA] || [enum_data $port_enum IS_DBI]} {
                  set is_rd_lane 1
                  if {[dict get $port IS_PP_SEC_DATA_GROUP]} {
                     set is_pp_sec_data_group 1
                  }
               }
               if {[enum_data $port_enum IS_WCLK] || [enum_data $port_enum IS_WDATA] || [enum_data $port_enum IS_DM] || [enum_data $port_enum IS_DBI]} {
                  set is_wr_lane 1
                  if {[dict get $port IS_PP_SEC_DATA_GROUP]} {
                     set is_pp_sec_data_group 1
                  }
               }
               if {$is_rd_lane && $is_wr_lane} {
                  break
               }
            }
            
            if {$is_rd_lane && $is_wr_lane} {
               set bitstr [enum_data LANE_USAGE_WRDATA BITSTR]
            } elseif {$is_rd_lane} {
               set bitstr [enum_data LANE_USAGE_RDATA BITSTR]
            } else {
               emif_assert {$is_wr_lane}
               set bitstr [enum_data LANE_USAGE_WDATA BITSTR]
            }
            
            if {$pri_rdata_tile_i == -1 && !$is_pp_sec_data_group && $is_rd_lane} {
               set pri_rdata_tile_i $tile_i
               set pri_rdata_lane_i $lane_i
            }
            if {$pri_wdata_tile_i == -1 && !$is_pp_sec_data_group && $is_wr_lane} {
               set pri_wdata_tile_i $tile_i
               set pri_wdata_lane_i $lane_i
            }
            if {$sec_rdata_tile_i == -1 && $is_pp_sec_data_group && $is_rd_lane} {
               if {$tile_i == $sec_ac_tile_i} {
                  set sec_rdata_tile_i $tile_i
                  set sec_rdata_lane_i $lane_i
               }
            }
            if {$sec_wdata_tile_i == -1 && $is_pp_sec_data_group && $is_wr_lane} {
               if {$tile_i == $sec_ac_tile_i} {
                  set sec_wdata_tile_i $tile_i
                  set sec_wdata_lane_i $lane_i
               }
            }
         }
         
         set first [expr {($lanes_in_if - $abs_lane_index - 1) * $bitstr_len}]
         set last  [expr {$first + $bitstr_len - 1}]
         set lanes_usage [string replace $lanes_usage $first $last $bitstr]
      }
   }
   set_long_bitvec_hdl_param_value LANES_USAGE $lanes_usage

   if {$ping_pong_en} {
      emif_assert {$pri_rdata_tile_i >= $sec_ac_tile_i && $pri_rdata_tile_i < $num_of_rtl_tiles}
      emif_assert {$pri_wdata_tile_i >= $sec_ac_tile_i && $pri_wdata_tile_i < $num_of_rtl_tiles}
      emif_assert {$sec_rdata_tile_i >= 0 && $sec_rdata_tile_i <= $sec_ac_tile_i}
      emif_assert {$sec_wdata_tile_i >= 0 && $sec_wdata_tile_i <= $sec_ac_tile_i}
      
      emif_assert {$pri_rdata_lane_i >= 0 && $pri_rdata_lane_i < $lanes_per_tile}
      emif_assert {$pri_wdata_lane_i >= 0 && $pri_wdata_lane_i < $lanes_per_tile}
      emif_assert {$sec_rdata_lane_i >= 0 && $sec_rdata_lane_i < $lanes_per_tile}
      emif_assert {$sec_wdata_lane_i >= 0 && $sec_wdata_lane_i < $lanes_per_tile}
   } else {
      emif_assert {$pri_rdata_tile_i >= 0 && $pri_rdata_tile_i < $num_of_rtl_tiles}
      emif_assert {$pri_wdata_tile_i >= 0 && $pri_wdata_tile_i < $num_of_rtl_tiles}
      
      emif_assert {$pri_rdata_lane_i >= 0 && $pri_rdata_lane_i < $lanes_per_tile}
      emif_assert {$pri_wdata_lane_i >= 0 && $pri_wdata_lane_i < $lanes_per_tile}
      
      set sec_ac_tile_i     $pri_ac_tile_i
      set sec_rdata_tile_i  $pri_rdata_tile_i
      set sec_rdata_lane_i  $pri_rdata_lane_i
      set sec_wdata_tile_i  $pri_wdata_tile_i
      set sec_wdata_lane_i  $pri_wdata_lane_i
   }
   
   set_parameter_value PRI_RDATA_TILE_INDEX $pri_rdata_tile_i
   set_parameter_value PRI_RDATA_LANE_INDEX $pri_rdata_lane_i
   set_parameter_value PRI_WDATA_TILE_INDEX $pri_wdata_tile_i
   set_parameter_value PRI_WDATA_LANE_INDEX $pri_wdata_lane_i
   
   set_parameter_value SEC_RDATA_TILE_INDEX $sec_rdata_tile_i
   set_parameter_value SEC_RDATA_LANE_INDEX $sec_rdata_lane_i
   set_parameter_value SEC_WDATA_TILE_INDEX $sec_wdata_tile_i
   set_parameter_value SEC_WDATA_LANE_INDEX $sec_wdata_lane_i
   
   emif_assert {$pri_ac_tile_i >= 0 && $pri_ac_tile_i < $num_of_rtl_tiles}
   set_parameter_value PRI_AC_TILE_INDEX $pri_ac_tile_i
   set_parameter_value SEC_AC_TILE_INDEX $sec_ac_tile_i
}

proc ::altera_emif::arch_common::main::config_iopll {} {
   
   ::altera_iopll_common::iopll::set_physical_parameter_values
   ::altera_iopll_common::iopll::declare_pll_interfaces
   
   if {![get_parameter_value PLL_DISALLOW_EXTRA_CLKS] && [get_parameter_value PLL_ADD_EXTRA_CLKS]} {
      ::altera_iopll_common::iopll::enable_pll_locked_port
   } else {
      ::altera_iopll_common::iopll::disable_pll_locked_port
   }
   
   
}



proc ::altera_emif::arch_common::main::_init {} {
}

::altera_emif::arch_common::main::_init
