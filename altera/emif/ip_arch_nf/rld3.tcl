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


package provide altera_emif::ip_arch_nf::rld3 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::math
package require altera_emif::util::enums
package require altera_emif::util::device_family

package require altera_emif::arch_common::util

package require altera_emif::ip_arch_nf::enum_defs_ac_pin_mapping
package require altera_emif::ip_arch_nf::util
package require altera_emif::ip_arch_nf::rldx

namespace eval ::altera_emif::ip_arch_nf::rld3:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::ip_arch_nf::util::*

   
}


proc ::altera_emif::ip_arch_nf::rld3::get_dqs_bus_mode {} {
   return DQS_BUS_MODE_X8_X9
}

proc ::altera_emif::ip_arch_nf::rld3::get_interface_ports {if_enum} {
   switch $if_enum {
      IF_MEM {
         return [_get_mem_ports]
      }
      IF_AFI {
         return [_get_afi_ports]
      }
      IF_CTRL_AST_CMD {
         return [_get_ctrl_ast_cmd_ports]
      }
      IF_CTRL_AST_WR {
         return [_get_ctrl_ast_wr_ports]
      }
      IF_CTRL_AST_RD {
         return [_get_ctrl_ast_rd_ports]
      }
      IF_CTRL_AMM {      
         return [_get_ctrl_amm_ports]
      }
      default {
         emif_ie "Unknown interface type $if_enum"
      }
   }
}

proc ::altera_emif::ip_arch_nf::rld3::is_ctrl_sideband_interface_enabled {if_enum} {
   switch $if_enum {
      IF_CTRL_AUTO_PRECHARGE {
         return 0
      }
      IF_CTRL_USER_REFRESH {
         return 0
      }
      IF_CTRL_SELF_REFRESH {
         return 0
      }
      IF_CTRL_WILL_REFRESH {
         return 0
      }
      IF_CTRL_DEEP_POWER_DOWN {
         return 0
      }
      IF_CTRL_POWER_DOWN {
         return 0
      }
      IF_CTRL_ZQ_CAL {
         return 0
      }
      IF_CTRL_ECC {
         return 0
      }
      IF_CTRL_MMR_SLAVE {
         return 0
      }
      default {
         return 0
      }
   }
}

proc ::altera_emif::ip_arch_nf::rld3::get_interface_properties {if_enum} {
   switch $if_enum {
      IF_CTRL_AMM {     
         return [_get_ctrl_amm_properties]
      }
      IF_CTRL_AST_CMD {
         return [_get_ctrl_ast_cmd_properties]
      }
      IF_CTRL_AST_RD -
      IF_CTRL_AST_WR {     
         return [_get_ctrl_ast_properties]
      }
      default {
         emif_ie "Interface type $if_enum not supported"
      }
   }
}

proc ::altera_emif::ip_arch_nf::rld3::get_ac_pin_map_scheme {} {
   set retval [dict create]

   if {[::altera_emif::util::qini::ini_is_on "emif_use_swap_pinout_atso9"]} {
      dict set retval ENUM "RLD3_AC_PM_0_1_2_SWAP"
   } else {
      dict set retval ENUM "RLD3_AC_PM_0_1_2"
   }

   dict set retval HMC_DIMM_TYPE_STR "component"
   return $retval
}

proc ::altera_emif::ip_arch_nf::rld3::get_resource_consumption {} {
   
   set dq_width        [get_parameter_value MEM_RLD3_DQ_WIDTH]
   set dq_per_device   [get_parameter_value MEM_RLD3_DQ_PER_DEVICE]
   set ac_pm_scheme    [get_ac_pin_map_scheme]
   set ac_pm_enum      [dict get $ac_pm_scheme ENUM]
   
   set num_ac_tile     1
   set num_ac_lanes    [enum_data $ac_pm_enum LANES_USED]
   set num_devices     [expr {$dq_width / $dq_per_device}]
   set num_data_lanes  [expr {($dq_per_device == 18) ? ($num_devices * 4) : ($num_devices * 6)}]
   set num_data_tiles  [expr {($dq_per_device == 18) ? $num_devices : $num_devices * 2}]
   set num_lanes       [expr {$num_ac_lanes + $num_data_lanes}]
   set num_tiles       [expr {$num_ac_tile + $num_data_tiles}]
   
   set retval [dict create]
   dict set retval AC_PM_ENUM      $ac_pm_enum
   dict set retval NUM_AC_LANES    $num_ac_lanes
   dict set retval NUM_DATA_LANES  $num_data_lanes
   dict set retval NUM_LANES       $num_lanes
   dict set retval NUM_TILES       $num_tiles
   
   return $retval
}

proc ::altera_emif::ip_arch_nf::rld3::alloc_mem_pins {mem_ports_name} {

   upvar 1 $mem_ports_name mem_ports
   set tiles [dict create]

   set lanes_per_tile  [::altera_emif::util::device_family::get_family_trait FAMILY_TRAIT_LANES_PER_TILE]
   set pins_per_lane   [::altera_emif::util::device_family::get_family_trait FAMILY_TRAIT_PINS_PER_LANE]
   set pins_per_tile   [expr {$lanes_per_tile * $pins_per_lane}]
   
   set dq_per_device   [get_parameter_value MEM_RLD3_DQ_PER_DEVICE]
   set dq_per_rd_group [get_parameter_value MEM_RLD3_DQ_PER_RD_GROUP]
   set dq_per_wr_group [get_parameter_value MEM_RLD3_DQ_PER_WR_GROUP]   
   
   set resources       [get_resource_consumption]
   set ac_pm_enum      [dict get $resources AC_PM_ENUM]
   set num_tiles       [dict get $resources NUM_TILES]   
   
   set ac_tile_i       [expr {int(($num_tiles - 1) / 2)}]
   
   for {set i 0} {$i < [llength $mem_ports]} {incr i} {
      set port      [lindex $mem_ports $i]
      set enabled   [dict get $port ENABLED]
      set type_enum [dict get $port TYPE_ENUM]
      set bus_i     [dict get $port BUS_INDEX]
      
      if {!$enabled} {
         continue 
      }
      
      switch $type_enum {
         PORT_MEM_CK -
         PORT_MEM_CK_N -
         PORT_MEM_A -
         PORT_MEM_BA -
         PORT_MEM_CS_N - 
         PORT_MEM_REF_N -
         PORT_MEM_WE_N -
         PORT_MEM_RESET_N {
            set abs_pin_i [get_ac_pin_index $ac_pm_enum $type_enum $bus_i]
            set tile_i    $ac_tile_i
            set lane_i    [expr {int($abs_pin_i / $pins_per_lane)}]
            set pin_i     [expr {$abs_pin_i % $pins_per_lane}]
         }
         PORT_MEM_DQ -
         PORT_MEM_DM -
         PORT_MEM_QK -
         PORT_MEM_QK_N {
         
            if {$type_enum == "PORT_MEM_DQ"} {
               set qk_i [expr {int($bus_i / $dq_per_rd_group)}]
            } elseif {$type_enum == "PORT_MEM_DM" && $dq_per_device == 36} {
               set qk_i [expr {($bus_i * 2) - ($bus_i % 2)}]
            } else {
               set qk_i $bus_i
            }

            if {$dq_per_device == 18} {
               set tile_i [expr {int($qk_i / 2)}]
               set lane_i [expr {($qk_i % 2) * 2}]
            } else {
               set tile_i [expr {($qk_i % 2) + int($qk_i / 4) * 2}]
               set lane_i [expr {int(($qk_i % 4) / 2)}]
            }
            
            if {$tile_i >= $ac_tile_i} {
               set tile_i [expr { $tile_i + 1 }]
            }
            
            if {$type_enum == "PORT_MEM_DQ"} {
               set pin_loc [expr {($bus_i % $dq_per_rd_group)}]
               if {$pin_loc < 4} {
                  set pin_i $pin_loc
               } else {
                  set pin_i [expr {$pin_loc + 2}]
               }
            } elseif {$type_enum == "PORT_MEM_DM"} {
               set pin_i 11
            } elseif {$type_enum == "PORT_MEM_QK"} {
               set pin_i 4
            } else {
               set pin_i 5
            }
         }
         PORT_MEM_DK -
         PORT_MEM_DK_N {
            
            set dk_i       $bus_i
            
            if {$dq_per_device == 18} {
               set tile_i [expr {int($dk_i / 2)}]
               set lane_i [expr {($dk_i % 2) * 2 + 1}]
            } else {
               set tile_i $dk_i
               set lane_i 2
            }
            
            if {$tile_i >= $ac_tile_i} {
               set tile_i [expr { $tile_i + 1 }]
            }            
            
            if {$type_enum == "PORT_MEM_DK"} {
               set pin_i 4
            } else {
               set pin_i 5
            }
         }
         default {
            emif_ie "Unknown port type $type_enum"
         }
      }
      
      set abs_pin_i [expr {$tile_i * $pins_per_tile + $lane_i * $pins_per_lane + $pin_i}]
      dict set port ABS_PIN_INDEX $abs_pin_i
      dict set port TILE_INDEX $tile_i
      dict set port LANE_INDEX $lane_i
      dict set port PIN_INDEX $pin_i
      lset mem_ports $i $port
      ::altera_emif::arch_common::util::alloc_pin $port tiles $tile_i $lane_i $pin_i
   }
   return $tiles
}

proc ::altera_emif::ip_arch_nf::rld3::assign_io_settings {ports_name} {
   upvar 1 $ports_name ports

   set io_voltage          [get_parameter_value PHY_RLD3_IO_VOLTAGE]
   set ac_io_std_enum      [get_parameter_value PHY_RLD3_AC_IO_STD_ENUM]
   set ac_mode_enum        [get_parameter_value PHY_RLD3_AC_MODE_ENUM]
   set ac_slew_rate_enum   [get_parameter_value PHY_RLD3_AC_SLEW_RATE_ENUM]
   set ck_io_std_enum      [get_parameter_value PHY_RLD3_CK_IO_STD_ENUM]
   set ck_mode_enum        [get_parameter_value PHY_RLD3_CK_MODE_ENUM]
   set ck_slew_rate_enum   [get_parameter_value PHY_RLD3_CK_SLEW_RATE_ENUM]
   set data_io_std_enum    [get_parameter_value PHY_RLD3_DATA_IO_STD_ENUM]
   set data_in_mode_enum   [get_parameter_value PHY_RLD3_DATA_IN_MODE_ENUM]
   set data_out_mode_enum  [get_parameter_value PHY_RLD3_DATA_OUT_MODE_ENUM]
   set ref_clk_io_std_enum [get_parameter_value PHY_RLD3_PLL_REF_CLK_IO_STD_ENUM]
   set rzq_io_std_enum     [get_parameter_value PHY_RLD3_RZQ_IO_STD_ENUM]

   set ac_cal_oct          [get_parameter_value PHY_AC_CALIBRATED_OCT]
   set ck_cal_oct          [get_parameter_value PHY_CK_CALIBRATED_OCT] 
   set data_cal_oct        [get_parameter_value PHY_DATA_CALIBRATED_OCT]    
   set dqs_pkg_deskew      [get_parameter_value BOARD_RLD3_IS_SKEW_WITHIN_QK_DESKEWED]
   set ac_pkg_deskew       [get_parameter_value BOARD_RLD3_IS_SKEW_WITHIN_AC_DESKEWED]
   
   for {set i 0} {$i < [llength $ports]} {incr i} {
      set port      [lindex $ports $i]
      set enabled   [dict get $port ENABLED]
      set type_enum [dict get $port TYPE_ENUM]
      
      if {!$enabled} {
         continue 
      }
      
      set cal_oct          0
      set io_std_enum      IO_STD_INVALID
      set out_oct_enum     OUT_OCT_INVALID
      set in_oct_enum      IN_OCT_INVALID
      set current_st_enum  CURRENT_ST_INVALID
      set slew_rate_enum   SLEW_RATE_INVALID
      set pkg_deskew       false
      
      switch $type_enum {
         PORT_MEM_CK -
         PORT_MEM_CK_N {
            set cal_oct $ck_cal_oct
            set io_std_enum [enum_data $ck_io_std_enum DF_IO_STD]
            if {[enum_type $ck_mode_enum] == "OUT_OCT"} {
               set out_oct_enum $ck_mode_enum
            } else {
               set current_st_enum $ck_mode_enum
            }
            set slew_rate_enum $ck_slew_rate_enum
            set pkg_deskew $ac_pkg_deskew
         }
         PORT_MEM_A -
         PORT_MEM_BA -
         PORT_MEM_CS_N - 
         PORT_MEM_REF_N -
         PORT_MEM_WE_N {
            set cal_oct $ac_cal_oct
            set io_std_enum $ac_io_std_enum
            if {[enum_type $ac_mode_enum] == "OUT_OCT"} {
               set out_oct_enum $ac_mode_enum
            } else {
               set current_st_enum $ac_mode_enum
            }
            set slew_rate_enum $ac_slew_rate_enum
            set pkg_deskew $ac_pkg_deskew
         }
         PORT_MEM_RESET_N {
            set cal_oct 0
            set io_std_enum IO_STD_CMOS_12
            set out_oct_enum OUT_OCT_0
            set slew_rate_enum $ac_slew_rate_enum
            set pkg_deskew $ac_pkg_deskew
         }
         PORT_MEM_DQ {
            set cal_oct $data_cal_oct
            set io_std_enum $data_io_std_enum
            set in_oct_enum $data_in_mode_enum
            if {[enum_type $data_out_mode_enum] == "OUT_OCT"} {
               set out_oct_enum $data_out_mode_enum
            } else {
               set current_st_enum $data_out_mode_enum
            }
            set pkg_deskew $dqs_pkg_deskew
         }
         PORT_MEM_QK -
         PORT_MEM_QK_N {
            set cal_oct $data_cal_oct
            set io_std_enum [enum_data $data_io_std_enum DF_IO_STD]
            set in_oct_enum $data_in_mode_enum
            set pkg_deskew $dqs_pkg_deskew
         }
         PORT_MEM_DM {
            set cal_oct $data_cal_oct
            set io_std_enum $data_io_std_enum
            if {[enum_type $data_out_mode_enum] == "OUT_OCT"} {
               set out_oct_enum $data_out_mode_enum
            } else {
               set current_st_enum $data_out_mode_enum
            }
            set pkg_deskew $dqs_pkg_deskew	    
         }
         PORT_MEM_DK -
         PORT_MEM_DK_N {
            set cal_oct $data_cal_oct
            set io_std_enum [enum_data $data_io_std_enum DF_IO_STD]
            if {[enum_type $data_out_mode_enum] == "OUT_OCT"} {
               set out_oct_enum $data_out_mode_enum
            } else {
               set current_st_enum $data_out_mode_enum
            }
            set pkg_deskew $dqs_pkg_deskew
         }         
         PORT_OCT_RZQIN {
            set cal_oct 0
            set io_std_enum $rzq_io_std_enum
         }
         PORT_PLL_REF_CLK {
            set cal_oct 0
            set io_std_enum $ref_clk_io_std_enum
            set in_oct_enum [resolve_pll_ref_clk_in_oct_enum $ref_clk_io_std_enum]
         }
         default {
            emif_ie "Unknown port type $type_enum"
         }
      }
      
      dict set port CAL_OCT    $cal_oct
      dict set port IO_STD     $io_std_enum
      dict set port OUT_OCT    $out_oct_enum
      dict set port IN_OCT     $in_oct_enum
      dict set port CURRENT_ST $current_st_enum
      dict set port SLEW_RATE  $slew_rate_enum
      dict set port PKG_DESKEW $pkg_deskew
      lset ports $i $port
   }
   return 1
}

proc ::altera_emif::ip_arch_nf::rld3::get_clk_ratios {} {

   set bl             [get_parameter_value MEM_RLD3_BL]
   set rate_enum      [get_parameter_value PHY_RLD3_RATE_ENUM]
   set user_clk_ratio [enum_data $rate_enum RATIO]
   set config_enum             [get_parameter_value PHY_RLD3_CONFIG_ENUM]
   
   set ratios [dict create]
   
   if {$config_enum == "CONFIG_PHY_AND_HARD_CTRL"} { 
      if {$bl == 2 || $bl == 4} {
         if {$user_clk_ratio == 4} {
            dict set ratios PHY_HMC 2
         } elseif {$user_clk_ratio == 2} {
            dict set ratios PHY_HMC 2
         } else {
            emif_ie "Unsupported rate $rate_enum for RLD3 BL=$bl"
         }
      } elseif {$bl == 4} {
         if {$user_clk_ratio == 4} {
            dict set ratios PHY_HMC 2
         } elseif {$user_clk_ratio == 2} {
            dict set ratios PHY_HMC 2
         } else {
            emif_ie "Unsupported rate $rate_enum for RLD3 BL=$bl"
         }
      } elseif {$bl == 8} {
         dict set ratios PHY_HMC $user_clk_ratio
      } else {
         emif_ie "Unsupported BL=$bl for RLD3"
      }
   } else { 
      dict set ratios PHY_HMC $user_clk_ratio
   }
   dict set ratios C2P_P2C $user_clk_ratio
   dict set ratios USER $user_clk_ratio   
   
   return $ratios
}

proc ::altera_emif::ip_arch_nf::rld3::get_num_and_type_of_hmc_ports {} {

   set bl                      [get_parameter_value MEM_RLD3_BL]
   set rate_enum               [get_parameter_value PHY_RLD3_RATE_ENUM]
   set user_clk_ratio          [enum_data $rate_enum RATIO]
   set config_enum             [get_parameter_value PHY_RLD3_CONFIG_ENUM]
   set ctrl_avl_protocol_enum  [get_parameter_value CTRL_RLD3_AVL_PROTOCOL_ENUM]
   
   if {$config_enum == "CONFIG_PHY_AND_HARD_CTRL"} {
      if {$bl == 2 || $bl == 4} {
         if {$user_clk_ratio == 4} {
            set num_of_ports 2
         } elseif {$user_clk_ratio == 2} {
            set num_of_ports 1
         } else {
            emif_ie "Unsupported rate $rate_enum for RLD3 BL=$bl"
         }
      } elseif {$bl == 4} {
         if {$user_clk_ratio == 4} {
            set num_of_ports 2
         } elseif {$user_clk_ratio == 2} {
            set num_of_ports 1
         } else {
            emif_ie "Unsupported rate $rate_enum for RLD3 BL=$bl"
         }
      } elseif {$bl == 8} {
         set num_of_ports 1
      } else {
         emif_ie "Unsupported BL=$bl for RLD3"
      }
   } else {
      set num_of_ports 0
      set ctrl_avl_protocol_enum CTRL_AVL_PROTOCOL_INVALID
   }
   
   set hmc_ifs [dict create]
   dict set hmc_ifs NUM_OF_PORTS $num_of_ports
   dict set hmc_ifs CTRL_AVL_PROTOCOL_ENUM $ctrl_avl_protocol_enum
   return $hmc_ifs
}

proc ::altera_emif::ip_arch_nf::rld3::get_hmc_cfgs {hmc_inst} {
   set retval [dict create]
   
   foreach hmc_cfg_enum [enums_of_type HMC_CFG] {
   
      set val 0
  
      switch $hmc_cfg_enum {
         HMC_CFG_ADDR_ORDER {
            set addr_order_enum [get_parameter_value "CTRL_RLD3_ADDR_ORDER_ENUM"]
            
            set mapping [dict create RLD3_CTRL_ADDR_ORDER_CS_B_R_C   HMC_CFG_ADDR_ORDER_CS_B_R_C \
                                     RLD3_CTRL_ADDR_ORDER_CS_R_B_C   HMC_CFG_ADDR_ORDER_CS_R_B_C \
                                     RLD3_CTRL_ADDR_ORDER_R_CS_B_C   HMC_CFG_ADDR_ORDER_R_CS_B_C ]

            emif_assert {[dict exists $mapping $addr_order_enum]}
            set val [enum_data [dict get $mapping $addr_order_enum] WYSIWYG_NAME]
         }
         HMC_CFG_ACT_TO_RDWR {
            set val 4
         }
         HMC_CFG_ACT_TO_PCH {
            set val 14
         }
         HMC_CFG_ACT_TO_ACT {
            set val 18
         }
         HMC_CFG_ACT_TO_ACT_DIFF_BANK {
            set val 3
         }
         HMC_CFG_ACT_TO_ACT_DIFF_BG {
            set val 0
         }
         HMC_CFG_RD_TO_RD {
            set val 2
         }
         HMC_CFG_RD_TO_RD_DIFF_CHIP {
            set val 3
         }
         HMC_CFG_RD_TO_RD_DIFF_BG {
            set val 0
         }
         HMC_CFG_RD_TO_WR {
            set val 3
         }
         HMC_CFG_RD_TO_WR_DIFF_CHIP {
            set val 3
         }
         HMC_CFG_RD_TO_WR_DIFF_BG {
            set val 0
         }
         HMC_CFG_RD_TO_PCH {
            set val 4
         }
         HMC_CFG_RD_AP_TO_VALID {
            set val 8
         }
         HMC_CFG_WR_TO_WR {
            set val 2
         }
         HMC_CFG_WR_TO_WR_DIFF_CHIP {
            set val 3
         }
         HMC_CFG_WR_TO_WR_DIFF_BG {
            set val 0
         }
         HMC_CFG_WR_TO_RD {
            set val 9
         }
         HMC_CFG_WR_TO_RD_DIFF_CHIP {
            set val 7
         }
         HMC_CFG_WR_TO_RD_DIFF_BG {
            set val 0
         }
         HMC_CFG_WR_TO_PCH {
            set val 13
         }
         HMC_CFG_WR_AP_TO_VALID {
            set val 17
         }
         HMC_CFG_PCH_TO_VALID {
            set val 4
         }
         HMC_CFG_PCH_ALL_TO_VALID {
            set val 4
         }
         HMC_CFG_ARF_TO_VALID {
            set val 36
         }
         HMC_CFG_PDN_TO_VALID {
            set val 3
         }
         HMC_CFG_SRF_TO_VALID {
            set val 256
         }
         HMC_CFG_SRF_TO_ZQ_CAL {
            set val 128
         }
         HMC_CFG_ARF_PERIOD {
            set val 3120
         }
         HMC_CFG_PDN_PERIOD {
            set val 0
         }
         HMC_CFG_ZQCL_TO_VALID {
            set val 128
         }
         HMC_CFG_ZQCS_TO_VALID {
            set val 32
         }
         HMC_CFG_MRS_TO_VALID {
            set val 2
         }
         HMC_CFG_MPS_TO_VALID {
            set val 0
         }
         HMC_CFG_MRR_TO_VALID {
            set val 0
         }
         HMC_CFG_MPR_TO_VALID {
            set val 0
         }
         HMC_CFG_MPS_EXIT_CS_TO_CKE {
            set val 0
         }
         HMC_CFG_MPS_EXIT_CKE_TO_CS {
            set val 0
         }
         HMC_CFG_RLD3_MULTIBANK_REF_DELAY {
            set val 0
         }
         HMC_CFG_MMR_CMD_TO_VALID {
            set val 4
         }
         HMC_CFG_4_ACT_TO_ACT {
            set val 12
         }
         HMC_CFG_16_ACT_TO_ACT {
            set val 0
         }
         HMC_CFG_MEM_IF_COLADDR_WIDTH {
            set val "col_width_7"
         }
         HMC_CFG_MEM_IF_ROWADDR_WIDTH {
            set val "row_width_10"
         }
         HMC_CFG_MEM_IF_BANKADDR_WIDTH {
            set val "bank_width_3"
         }
         HMC_CFG_MEM_IF_BGADDR_WIDTH {
            set val "bg_width_0"
         }
         HMC_CFG_LOCAL_IF_CS_WIDTH {
            set cs_width [get_parameter_value MEM_RLD3_CS_WIDTH]
            set cs_addr_width [expr {int(ceil(log($cs_width)/log(2)))}]
            set val "cs_width_$cs_addr_width"
         }		 
		   HMC_CFG_SLOT_ROTATE_EN {
            set val 0
         }         
         HMC_CFG_SLOT_OFFSET {
            set val 0
         }		 
         HMC_CFG_COL_CMD_SLOT {
            set val [expr {[bin2num "0001"]}]
         }         
         HMC_CFG_ROW_CMD_SLOT {
            set val [expr {[bin2num "0001"]}]
         }
		 

         default {
            set val [enum_data $hmc_cfg_enum DEFAULT]
         }
      }
      dict set retval $hmc_cfg_enum $val
   }
   return $retval
}

proc ::altera_emif::ip_arch_nf::rld3::get_lane_cfgs {} {
   set retval [dict create]
   dict set retval "PREAMBLE_MODE"         "preamble_one_cycle"
   dict set retval "DBI_WR_ENABLE"         "false"
   dict set retval "DBI_RD_ENABLE"         "false"
   dict set retval "CRC_EN"                "crc_disable"
   dict set retval "SWAP_DQS_A_B"          "false"
   dict set retval "DQS_PACK_MODE"         "not_packed"
   dict set retval "OCT_SIZE"              2
   dict set retval "DBC_WB_RESERVED_ENTRY" 4                      
   return $retval
}

proc ::altera_emif::ip_arch_nf::rld3::derive_seq_param_tbl {seq_pt_enums} {
   
   set retval [dict create]
   
   foreach seq_pt_enum $seq_pt_enums {
      switch $seq_pt_enum {
         SEQ_PT_READ_LATENCY {
            set dl_enum [get_parameter_value "MEM_RLD3_DATA_LATENCY_MODE_ENUM"]
            set val     [enum_data $dl_enum RL]
         }
         SEQ_PT_WRITE_LATENCY {
            set dl_enum [get_parameter_value "MEM_RLD3_DATA_LATENCY_MODE_ENUM"]
            set val     [enum_data $dl_enum WL]
         }      
         SEQ_PT_NUM_RANKS {
            set val [get_parameter_value MEM_RLD3_DEVICE_DEPTH]
         }
         SEQ_PT_NUM_DIMMS {
            set val [get_parameter_value MEM_RLD3_DEVICE_DEPTH]
         }
         SEQ_PT_NUM_DQS_WR {
            set val [get_parameter_value MEM_RLD3_DK_WIDTH]
         }
         SEQ_PT_NUM_DQS_RD {
            set val [get_parameter_value MEM_RLD3_QK_WIDTH]
         }
         SEQ_PT_NUM_DQ {
            set val [get_parameter_value MEM_RLD3_DQ_WIDTH]
         }
         SEQ_PT_NUM_DM {
            if {[get_parameter_value MEM_RLD3_DM_EN]} {
               set val [get_parameter_value MEM_RLD3_DM_WIDTH]
            } else {
               set val 0
            }
         }
         SEQ_PT_CK_WIDTH {
            set val 1
         }         
         SEQ_PT_ADDR_WIDTH {
            set val [get_parameter_value MEM_RLD3_ADDR_WIDTH]
         }
         SEQ_PT_BANK_WIDTH {
            set val [get_parameter_value MEM_RLD3_BANK_ADDR_WIDTH]
         }
         SEQ_PT_CS_WIDTH {
            set val [get_parameter_value MEM_RLD3_CS_WIDTH]
         }
         SEQ_PT_NUM_LRDIMM_CFG -
         SEQ_PT_CKE_WIDTH -
         SEQ_PT_ODT_WIDTH -
         SEQ_PT_C_WIDTH - 
         SEQ_PT_BANK_GROUP_WIDTH - 
         SEQ_PT_ADDR_MIRROR -
         SEQ_PT_ODT_TABLE_LO -
         SEQ_PT_ODT_TABLE_HI {
            set val 0 
         }
         SEQ_PT_NUM_MR {
            continue
         }
         SEQ_PT_NUM_DIMM_MR {
            set val 0
         }
         SEQ_PT_MR_PTR {
            set mr0 [get_parameter_value MEM_RLD3_MR0]
            set mr1 [get_parameter_value MEM_RLD3_MR1]
            set mr2 [get_parameter_value MEM_RLD3_MR2]

            set mrs [list \
               [dict create DBG_NAME "MR0" DBG_VALUE [num2bin $mr0 22] VALUE $mr0] \
               [dict create DBG_NAME "MR1" DBG_VALUE [num2bin $mr1 22] VALUE $mr1] \
               [dict create DBG_NAME "MR2" DBG_VALUE [num2bin $mr2 22] VALUE $mr2] \
               ]
            
            set val [dict create]
            dict set val PTR                0
            dict set val CONTENT            $mrs
            dict set val ITEM_BYTE_SIZE     4
            dict set val BYTE_SIZE          [expr {4 * [llength $mrs]}]
            
            dict set retval SEQ_PT_NUM_MR [llength $mrs]
         }
         SEQ_PT_DBG_SKIP_STEPS {
            set val 0
         }
         SEQ_PT_CAL_DATA_PTR {            
            set val [::altera_emif::ip_arch_nf::seq_param_tbl::get_cal_data_common_section]


            set byte_size              [expr {[dict get $val ITEM_BYTE_SIZE] * [llength [dict get $val CONTENT]]}]
            dict set val BYTE_SIZE     $byte_size

            dict set retval SEQ_PT_CAL_DATA_SIZE $byte_size
         }
         SEQ_PT_CAL_DATA_SIZE {
            continue
         }
         default {
            emif_ie "Unknown sequencer parameter table field $seq_pt_enum"
         }
      }
      dict set retval $seq_pt_enum $val
   }
   return $retval
}


proc ::altera_emif::ip_arch_nf::rld3::get_timing_params {} {

   set retval [dict create]

   set tck_ns [expr {1000.0 / [get_parameter_value PHY_RLD3_MEM_CLK_FREQ_MHZ]}]

   foreach tparam_enum [enums_of_type TPARAM] {

      set val 0

      switch $tparam_enum {
         TPARAM_PROTOCOL {
            set val "RLDRAM3"
         }
         TPARAM_NUM_RANKS {
            set val [get_parameter_value "MEM_RLD3_CS_WIDTH"]
         }		 
         TPARAM_SLEW_RATE_DRAM {
            set val [get_parameter_value BOARD_RLD3_RDATA_SLEW_RATE]
         }
         TPARAM_SLEW_RATE_DRAM_CLOCK {
            set val [get_parameter_value BOARD_RLD3_RCLK_SLEW_RATE]
         }
         TPARAM_VIN_MS {
            set val 0.15
         }
         TPARAM_VIN_MH {
            set val 0.1
         }
         TPARAM_SLEW_RATE_PHY {
            set val [get_parameter_value BOARD_RLD3_WDATA_SLEW_RATE]
         }
         TPARAM_SLEW_RATE_PHY_CLOCK {
            set val [get_parameter_value BOARD_RLD3_WCLK_SLEW_RATE]
         }
         TPARAM_SLEW_RATE_CA {
            set val [get_parameter_value BOARD_RLD3_AC_SLEW_RATE]
         }
         TPARAM_SLEW_RATE_CLOCK {
            set val [get_parameter_value BOARD_RLD3_CK_SLEW_RATE]
         }
         TPARAM_UI {
            set val [round_num $tck_ns 3]
         }
         TPARAM_TCK {
            set speedbin_enum      [get_parameter_value "MEM_RLD3_SPEEDBIN_ENUM"]
            set mem_fmax           [enum_data $speedbin_enum FMAX_MHZ]
            set val                [round_num [expr 1.0/$mem_fmax*1000.0] 3]
         }
         TPARAM_TDQSQ {
            set val [expr {[get_parameter_value MEM_RLD3_TQKQ_MAX_PS] / 1000.0}]
         }
         TPARAM_TQH {
            set val [get_parameter_value MEM_RLD3_TQH_CYC]
         }
          TPARAM_TDS {
            set val [expr {([get_parameter_value BOARD_RLD3_TDS_DERATING_PS] + [get_parameter_value MEM_RLD3_TDS_PS]) / 1000.0}]
         }
         TPARAM_TDH {
            set val [expr {([get_parameter_value BOARD_RLD3_TDH_DERATING_PS] + [get_parameter_value MEM_RLD3_TDH_PS]) / 1000.0}]
         }
         TPARAM_TIS {
            set val [expr {([get_parameter_value BOARD_RLD3_TIS_DERATING_PS] + [get_parameter_value MEM_RLD3_TIS_PS]) / 1000.0}]
         }
         TPARAM_TIH {
            set val [expr {([get_parameter_value BOARD_RLD3_TIH_DERATING_PS] + [get_parameter_value MEM_RLD3_TIH_PS]) / 1000.0}]
         }
         TPARAM_TDQSCK {
            set val [expr {[get_parameter_value MEM_RLD3_TCKQK_MAX_PS] / 1000.0}]
         }
         TPARAM_TDQSS {
            set val [get_parameter_value MEM_RLD3_TCKDK_MAX_CYC]
         }
         TPARAM_TWLS {
            set val 0
         }
         TPARAM_TWLH {
            set val 0
         }
         TPARAM_TDSS {
            set val 0
         }
         TPARAM_TDSH {
            set val 0.0
         }
         TPARAM_BD_PKG_SKEW {
            set val [get_parameter_value BOARD_RLD3_SKEW_WITHIN_QK_NS]
         }
         TPARAM_CA_BD_PKG_SKEW {
            set val [get_parameter_value BOARD_RLD3_SKEW_WITHIN_AC_NS]
         }
         TPARAM_CA_TO_CK_BD_PKG_SKEW {
            set val [get_parameter_value BOARD_RLD3_AC_TO_CK_SKEW_NS]
         }
         TPARAM_RD_ISI {
            set val [get_parameter_value BOARD_RLD3_RDATA_ISI_NS]
         }
         TPARAM_WR_ISI {
            set val [get_parameter_value BOARD_RLD3_WDATA_ISI_NS]
         }
         TPARAM_CA_ISI {
            set val [get_parameter_value BOARD_RLD3_AC_ISI_NS]
         }
         TPARAM_DQSG_ISI {
            set val [get_parameter_value BOARD_RLD3_RCLK_ISI_NS]
         }
         TPARAM_WL_ISI {
            set val [get_parameter_value BOARD_RLD3_WCLK_ISI_NS]
         }
         TPARAM_DQS_BOARD_SKEW {
            set val [get_parameter_value BOARD_RLD3_SKEW_BETWEEN_DK_NS]
         }
         TPARAM_DQS_TO_CK_BOARD_SKEW {
            set val [get_parameter_value BOARD_RLD3_DK_TO_CK_SKEW_NS]
         }
         TPARAM_X4 {
            set val 0
         }
         TPARAM_IS_DLL_ON {
            set val [expr {[get_parameter_value DLL_MODE] == "ctl_dynamic" ? 1 : 0}]
         }
         TPARAM_OCT_RECAL {
            if {[get_parameter_value PHY_PERIODIC_OCT_RECAL]} {
               set val 1
            } else {
               set val 0
            }
         }
         TPARAM_RDBI {
            set val 0
         }
         TPARAM_WDBI {
            set val 0
         } 
         TPARAM_TERMINATION_LESS_THAN_120 {
            set data_in_ohm   [enum_data [get_parameter_value PHY_RLD3_DATA_IN_MODE_ENUM] OHM]
            set val [expr {$data_in_ohm < 120 ? 1 : 0}]
         }
         TPARAM_IS_COMPONENT {
            set val 1
         }       
         default {
            emif_ie "Unrecognized timing param $tparam_enum"
         }
      }
      dict set retval $tparam_enum $val
   }
   return $retval
}

proc ::altera_emif::ip_arch_nf::rld3::is_phy_tracking_enabled {} {
   return [::altera_emif::ip_arch_nf::rldx::is_phy_tracking_enabled]
}

proc ::altera_emif::ip_arch_nf::rld3::is_phy_shadow_register_disabled {} {
   return 0
}


proc ::altera_emif::ip_arch_nf::rld3::_get_mem_ports {} {
   set ports [list]
   
   set addr_width      [get_parameter_value MEM_RLD3_ADDR_WIDTH]
   set bank_addr_width [get_parameter_value MEM_RLD3_BANK_ADDR_WIDTH]
   set cs_width        [get_parameter_value MEM_RLD3_CS_WIDTH]
   set dq_width        [get_parameter_value MEM_RLD3_DQ_WIDTH]
   set dk_width        [get_parameter_value MEM_RLD3_DK_WIDTH]
   set dm_en           [get_parameter_value MEM_RLD3_DM_EN]
   set dm_width        [get_parameter_value MEM_RLD3_DM_WIDTH]
   set qk_width        [get_parameter_value MEM_RLD3_QK_WIDTH]
   set config_enum     [get_parameter_value PHY_RLD3_CONFIG_ENUM]

   lappend ports {*}[create_port  true        PORT_MEM_CK         1                   [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_CK     ]]
   lappend ports {*}[create_port  true        PORT_MEM_CK_N       1                   [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_CK_N   ]]
   lappend ports {*}[create_port  true        PORT_MEM_A          $addr_width         [get_db_configs  PIN_RATE_SDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  true        PORT_MEM_BA         $bank_addr_width    [get_db_configs  PIN_RATE_SDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  true        PORT_MEM_CS_N       $cs_width           [get_db_configs  PIN_RATE_SDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  true        PORT_MEM_RESET_N    1                   [get_db_configs  PIN_RATE_SDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  true        PORT_MEM_WE_N       1                   [get_db_configs  PIN_RATE_SDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  true        PORT_MEM_REF_N      1                   [get_db_configs  PIN_RATE_SDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  true        PORT_MEM_QK         $qk_width           [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_RCLK   ]]
   lappend ports {*}[create_port  true        PORT_MEM_QK_N       $qk_width           [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_RCLK_N ]]
   lappend ports {*}[create_port  true        PORT_MEM_DK         $dk_width           [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_WCLK   ]]
   lappend ports {*}[create_port  true        PORT_MEM_DK_N       $dk_width           [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_WCLK_N ]]
   lappend ports {*}[create_port  true        PORT_MEM_DQ         $dq_width           [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_DQ     ]]
   lappend ports {*}[create_port  $dm_en      PORT_MEM_DM         $dm_width           [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_DM     ]]

   return $ports
}

proc ::altera_emif::ip_arch_nf::rld3::_get_afi_ports {} {
   set ports [altera_emif::ip_arch_nf::util::get_common_afi_ports]
   
   set clk_ratios        [get_clk_ratios]
   set sdr_ratio         [dict get $clk_ratios C2P_P2C]
   set ddr_ratio         [expr {$sdr_ratio * 2}]
   
   set addr_width        [expr {[get_parameter_value MEM_RLD3_ADDR_WIDTH]      * $sdr_ratio}]
   set bank_addr_width   [expr {[get_parameter_value MEM_RLD3_BANK_ADDR_WIDTH] * $sdr_ratio}]
   set cs_width          [expr {[get_parameter_value MEM_RLD3_CS_WIDTH]        * $sdr_ratio}]
   set data_width        [expr {[get_parameter_value MEM_RLD3_DQ_WIDTH]        * $ddr_ratio}]
   set dm_width          [expr {[get_parameter_value MEM_RLD3_DM_WIDTH]        * $ddr_ratio}]
   set dm_en             [get_parameter_value MEM_RLD3_DM_EN]   
   
   set rank_en           [expr {[get_parameter_value MEM_RLD3_DEVICE_DEPTH] > 1 ? 1 : 0}]
   set rank_width        [expr {[get_parameter_value MEM_RLD3_DEVICE_DEPTH] * $sdr_ratio}]
   
   lappend ports {*}[create_port  true        PORT_AFI_ADDR                     $addr_width          ]
   lappend ports {*}[create_port  true        PORT_AFI_BA                       $bank_addr_width     ]
   lappend ports {*}[create_port  true        PORT_AFI_CS_N                     $cs_width            ]
   lappend ports {*}[create_port  true        PORT_AFI_WE_N                     $sdr_ratio           ]
   lappend ports {*}[create_port  true        PORT_AFI_REF_N                    $sdr_ratio           ]
   lappend ports {*}[create_port  true        PORT_AFI_RST_N                    $sdr_ratio           ]
   lappend ports {*}[create_port  $dm_en      PORT_AFI_DM                       $dm_width            ]
   lappend ports {*}[create_port  true        PORT_AFI_WDATA_VALID              $sdr_ratio           ]
   lappend ports {*}[create_port  true        PORT_AFI_WDATA                    $data_width          ]
   lappend ports {*}[create_port  true        PORT_AFI_RDATA_EN_FULL            $sdr_ratio           ]
   lappend ports {*}[create_port  true        PORT_AFI_RDATA                    $data_width          ]
   lappend ports {*}[create_port  true        PORT_AFI_RDATA_VALID              $sdr_ratio           ]
   lappend ports {*}[create_port  $rank_en    PORT_AFI_RRANK                    $rank_width          ]
   lappend ports {*}[create_port  $rank_en    PORT_AFI_WRANK                    $rank_width          ]

   return $ports
}

proc ::altera_emif::ip_arch_nf::rld3::_get_ctrl_ast_properties {} {
   set props [dict create]
   
   set clk_ratios         [get_clk_ratios]
   set c2p_p2c_clk_ratio  [dict get $clk_ratios C2P_P2C]
   set burst_length       [get_parameter_value MEM_BURST_LENGTH]
   set dq_per_wr_group    [get_parameter_value MEM_RLD3_DQ_PER_WR_GROUP]
   set dq_width           [get_parameter_value MEM_RLD3_DQ_WIDTH]
   set dm_en              [get_parameter_value MEM_RLD3_DM_EN]   
   set dm_width           [get_parameter_value MEM_RLD3_DM_WIDTH]   
   set addr_width         [get_parameter_value MEM_RLD3_ADDR_WIDTH]
   set bank_addr_width    [get_parameter_value MEM_RLD3_BANK_ADDR_WIDTH]   
   
   set ttl_data_bits_per_burst [expr {$dq_width * $burst_length}]
   set ttl_mask_bits_per_burst [expr {$dm_width * $burst_length}]
   
   set ttl_data_bits_per_cyc   [expr {$dq_width * 2 * $c2p_p2c_clk_ratio}]
   set ttl_mask_bits_per_cyc   [expr {$dm_width * 2 * $c2p_p2c_clk_ratio}]
   
   set data_width              [expr {$ttl_data_bits_per_burst < $ttl_data_bits_per_cyc ? $ttl_data_bits_per_burst : $ttl_data_bits_per_cyc}]
   set be_width                [expr {$ttl_mask_bits_per_burst < $ttl_mask_bits_per_cyc ? $ttl_mask_bits_per_burst : $ttl_mask_bits_per_cyc}]
   
   set symbols_per_word        [expr {$data_width / $dq_per_wr_group}]
   
   dict set props WORD_WIDTH            $data_width
   dict set props SYMBOL_WIDTH          $dq_per_wr_group
   dict set props SYMBOLS_PER_WORD      $symbols_per_word
   dict set props BYTE_ENABLE_WIDTH     $be_width
   dict set props USE_BYTE_ENABLE       $dm_en
   
   return $props
}

proc ::altera_emif::ip_arch_nf::rld3::_get_ctrl_ast_cmd_properties {} {
   set props [dict create]
   
   dict set props WORD_WIDTH            58
   dict set props SYMBOL_WIDTH          1
   dict set props SYMBOLS_PER_WORD      58
   dict set props BYTE_ENABLE_WIDTH     0
   dict set props USE_BYTE_ENABLE       false
   
   return $props
}

proc ::altera_emif::ip_arch_nf::rld3::_get_ctrl_ast_cmd_ports {} {
   set ports [list]

   set props             [_get_ctrl_ast_cmd_properties]
   set data_width        [dict get $props WORD_WIDTH]

   lappend ports {*}[create_port  true        PORT_CTRL_AST_CMD_VALID     1                 ]
   lappend ports {*}[create_port  true        PORT_CTRL_AST_CMD_READY     1                 ]
   lappend ports {*}[create_port  true        PORT_CTRL_AST_CMD_DATA      $data_width       ]

   return $ports
}

proc ::altera_emif::ip_arch_nf::rld3::_get_ctrl_ast_wr_ports {} {
   set ports [list]
   
   set data_width 32
   
   lappend ports {*}[create_port  true        PORT_CTRL_AST_WR_VALID      1                ]
   lappend ports {*}[create_port  true        PORT_CTRL_AST_WR_READY      1                ]
   lappend ports {*}[create_port  true        PORT_CTRL_AST_WR_DATA       $data_width      ]
      
   return $ports
}

proc ::altera_emif::ip_arch_nf::rld3::_get_ctrl_ast_rd_ports {} {
   set ports [list]
   
   set data_width 32

   lappend ports {*}[create_port  true        PORT_CTRL_AST_RD_VALID      1                ]
   lappend ports {*}[create_port  true        PORT_CTRL_AST_RD_READY      1                ]
   lappend ports {*}[create_port  true        PORT_CTRL_AST_RD_DATA       $data_width      ]

   return $ports
}

proc ::altera_emif::ip_arch_nf::rld3::_get_ctrl_amm_properties {} {
   set props [dict create]
   
   set clk_ratios         [get_clk_ratios]
   set c2p_p2c_clk_ratio  [dict get $clk_ratios C2P_P2C]
   set burst_length       [get_parameter_value MEM_BURST_LENGTH]
   set dq_per_wr_group    [get_parameter_value MEM_RLD3_DQ_PER_WR_GROUP]
   set dq_width           [get_parameter_value MEM_RLD3_DQ_WIDTH]
   set dm_en              [get_parameter_value MEM_RLD3_DM_EN]   
   set dm_width           [get_parameter_value MEM_RLD3_DM_WIDTH]   
   set addr_width         [get_parameter_value MEM_RLD3_ADDR_WIDTH]
   set bank_addr_width    [get_parameter_value MEM_RLD3_BANK_ADDR_WIDTH]   
   set cs_width           [get_parameter_value MEM_RLD3_CS_WIDTH]   
   
   set ttl_data_bits_per_burst [expr {$dq_width * $burst_length}]
   set ttl_mask_bits_per_burst [expr {$dm_width * $burst_length}]
   
   set ttl_data_bits_per_cyc   [expr {$dq_width * 2 * $c2p_p2c_clk_ratio}]
   set ttl_mask_bits_per_cyc   [expr {$dm_width * 2 * $c2p_p2c_clk_ratio}]
   
   set data_width              [expr {$ttl_data_bits_per_burst < $ttl_data_bits_per_cyc ? $ttl_data_bits_per_burst : $ttl_data_bits_per_cyc}]
   set be_width                [expr {$ttl_mask_bits_per_burst < $ttl_mask_bits_per_cyc ? $ttl_mask_bits_per_burst : $ttl_mask_bits_per_cyc}]
   
   set symbols_per_word        [expr {$data_width / $dq_per_wr_group}]
   set symbol_address_width    [expr {$addr_width + $bank_addr_width + int(ceil([log2 $cs_width]))}]
   set word_address_width      [expr {$symbol_address_width - int(ceil([log2 $symbols_per_word]))}]
   
   set burst_count_width       8
   
   if {$c2p_p2c_clk_ratio == 4} {
      set word_address_divisible_by 1
      set burst_count_divisible_by 1
      
   } elseif {$c2p_p2c_clk_ratio == 2} {
      if {$burst_length <= 4} {
         set word_address_divisible_by 1
         set burst_count_divisible_by 1
      } else {
         if {$dm_en} {
            set word_address_divisible_by 1
            set burst_count_divisible_by 1
         } else {
            set word_address_divisible_by 2
            set burst_count_divisible_by 2
         }
      }
   } else {
      emif_ie "Code path does not support c2p_p2c_clk_ratio == $c2p_p2c_clk_ratio"
   }
   
   dict set props WORD_WIDTH                     $data_width
   dict set props SYMBOL_WIDTH                   $dq_per_wr_group
   dict set props SYMBOLS_PER_WORD               $symbols_per_word
   dict set props BYTE_ENABLE_WIDTH              $be_width
   dict set props USE_BYTE_ENABLE                $dm_en
   dict set props WORD_ADDRESS_WIDTH             $word_address_width
   dict set props SYMBOL_ADDRESS_WIDTH           $symbol_address_width
   dict set props BURST_COUNT_WIDTH              $burst_count_width
   dict set props WORD_ADDRESS_DIVISIBLE_BY      $word_address_divisible_by
   dict set props BURST_COUNT_DIVISIBLE_BY       $burst_count_divisible_by
   
   return $props
}

proc ::altera_emif::ip_arch_nf::rld3::_get_ctrl_amm_ports {} {
   set ports [list]
   
   set props [_get_ctrl_amm_properties]
   
   set data_width    [dict get $props WORD_WIDTH]
   set be_width      [dict get $props BYTE_ENABLE_WIDTH]
   set use_be        [dict get $props USE_BYTE_ENABLE]
   set bcount_width  [dict get $props BURST_COUNT_WIDTH]
   
   set address_width [dict get $props WORD_ADDRESS_WIDTH]
      
   lappend ports {*}[create_port  true        PORT_CTRL_AMM_READY         1                ]
   lappend ports {*}[create_port  true        PORT_CTRL_AMM_READ          1                ]
   lappend ports {*}[create_port  true        PORT_CTRL_AMM_WRITE         1                ]
   lappend ports {*}[create_port  true        PORT_CTRL_AMM_ADDRESS       $address_width   ]
   lappend ports {*}[create_port  true        PORT_CTRL_AMM_RDATA         $data_width      ]
   lappend ports {*}[create_port  true        PORT_CTRL_AMM_WDATA         $data_width      ]
   lappend ports {*}[create_port  true        PORT_CTRL_AMM_BCOUNT        $bcount_width    ]
   lappend ports {*}[create_port  $use_be     PORT_CTRL_AMM_BYTEEN        $be_width        ]
   lappend ports {*}[create_port  false       PORT_CTRL_AMM_BEGINXFER     1                ]
   lappend ports {*}[create_port  true        PORT_CTRL_AMM_RDATA_VALID   1                ]
   
   return $ports
} 

proc ::altera_emif::ip_arch_nf::rld3::_init {} {
}

::altera_emif::ip_arch_nf::rld3::_init
