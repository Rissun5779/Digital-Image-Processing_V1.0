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


package provide altera_emif::ip_arch_nd::qdr4 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::math
package require altera_emif::util::enums
package require altera_emif::util::device_family

package require altera_emif::arch_common::util

package require altera_emif::ip_arch_nd::enum_defs_ac_pin_mapping
package require altera_emif::ip_arch_nd::util
package require altera_emif::ip_arch_nd::qdrx

namespace eval ::altera_emif::ip_arch_nd::qdr4:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::ip_arch_nd::util::*

   
}


proc ::altera_emif::ip_arch_nd::qdr4::get_dqs_bus_mode {} {
   set dq_per_rd_group   [get_parameter_value MEM_QDR4_DQ_PER_RD_GROUP]
   
   if {$dq_per_rd_group == 9} {
      return DQS_BUS_MODE_X8_X9
   } else {
      return DQS_BUS_MODE_X16_X18
   }
}

proc ::altera_emif::ip_arch_nd::qdr4::get_interface_ports {if_enum} {
   switch $if_enum {
      IF_MEM {
         return [_get_mem_ports]
      }
      IF_AFI {
         return [_get_afi_ports]
      }
      default {
         emif_ie "Unknown interface type $if_enum in [info level 0]"
      }
   }
}

proc ::altera_emif::ip_arch_nd::qdr4::is_ctrl_sideband_interface_enabled {if_enum} {
   return 0
}

proc ::altera_emif::ip_arch_nd::qdr4::get_interface_properties {if_enum} {
   emif_ie "Interface type $if_enum not supported by [info level 0]"
   return 0
}

proc ::altera_emif::ip_arch_nd::qdr4::get_ac_pin_map_scheme {} {
   set retval [dict create]
   
   set use_addr_parity   [get_parameter_value MEM_QDR4_USE_ADDR_PARITY]
   set addr_width        [get_parameter_value MEM_QDR4_ADDR_WIDTH]
   
   if {$use_addr_parity || $addr_width > 22} {
      dict set retval ENUM "QDR4_AC_PM_0_1_2_3"
   } else {
      dict set retval ENUM "QDR4_AC_PM_0_1_2"
   }
   
   dict set retval HMC_DIMM_TYPE_STR "dimm_type_component"
   
   return $retval
}

proc ::altera_emif::ip_arch_nd::qdr4::get_resource_consumption {} {
   
   set num_devices     [get_parameter_value MEM_QDR4_DEVICE_WIDTH]
   set ac_pm_scheme    [get_ac_pin_map_scheme]
   set ac_pm_enum      [dict get $ac_pm_scheme ENUM]
   
   set num_ac_tile     1
   set num_ac_lanes    [enum_data $ac_pm_enum LANES_USED]
   set num_data_lanes  [expr {$num_devices * 8}]
   set num_data_tiles  [expr {$num_devices * 2}]
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

proc ::altera_emif::ip_arch_nd::qdr4::alloc_mem_pins {mem_ports_name} {

   upvar 1 $mem_ports_name mem_ports
   set tiles [dict create]

   set lanes_per_tile    [::altera_emif::util::device_family::get_family_trait FAMILY_TRAIT_LANES_PER_TILE]
   set pins_per_lane     [::altera_emif::util::device_family::get_family_trait FAMILY_TRAIT_PINS_PER_LANE]
   set pins_per_tile     [expr {$lanes_per_tile * $pins_per_lane}]
   
   set dq_per_rd_group   [get_parameter_value MEM_QDR4_DQ_PER_RD_GROUP]
   set dq_per_port_width [get_parameter_value MEM_QDR4_DQ_PER_PORT_WIDTH]
   
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
         PORT_MEM_CFG_N -
         PORT_MEM_RESET_N -
         PORT_MEM_LBK0_N -
         PORT_MEM_LBK1_N -
         PORT_MEM_LDA_N -
         PORT_MEM_LDB_N -
         PORT_MEM_RWA_N -
         PORT_MEM_RWB_N -
         PORT_MEM_CK -
         PORT_MEM_CK_N -
         PORT_MEM_AINV -
         PORT_MEM_A -
         PORT_MEM_AP -
         PORT_MEM_PE_N {
            set abs_pin_i [get_ac_pin_index $ac_pm_enum $type_enum $bus_i]
            set tile_i    $ac_tile_i
            set lane_i    [expr {int($abs_pin_i / $pins_per_lane)}]
            set pin_i     [expr {$abs_pin_i % $pins_per_lane}]
         }
         PORT_MEM_DQA -
         PORT_MEM_DQB -
         PORT_MEM_DINVA -
         PORT_MEM_DINVB -
         PORT_MEM_QKA -
         PORT_MEM_QKA_N -
         PORT_MEM_QKB -
         PORT_MEM_QKB_N {
         
            if {$type_enum == "PORT_MEM_DQB"} {
               set bus_i [expr { $bus_i + $dq_per_port_width }]
            } elseif {$type_enum == "PORT_MEM_QKB" || $type_enum == "PORT_MEM_QKB_N" \
                        || $type_enum == "PORT_MEM_DINVB"} {
               set rd_groups [expr { $dq_per_port_width / $dq_per_rd_group }]
               set bus_i [expr { $bus_i + $rd_groups }]
            }
         
            if {$type_enum == "PORT_MEM_DQA" || $type_enum == "PORT_MEM_DQB"} {
               set qk_i [expr {int($bus_i / $dq_per_rd_group)}]
            } else {
               set qk_i $bus_i
            }

            set tile_i [expr {int($qk_i / 2)}]
            set lane_i [expr {($qk_i % 2) * 2 + 1}]
            
            if {$tile_i >= $ac_tile_i} {
               set tile_i [expr { $tile_i + 1 }]
            }
            
            if {$type_enum == "PORT_MEM_DQA" || $type_enum == "PORT_MEM_DQB"} {
               set pin_i [expr {$bus_i % $dq_per_rd_group}]
               
               if {$pin_i >= 9} {
                  set pin_i [expr {$pin_i - 9}]
                  set lane_i [expr {$lane_i - 1}]
               }
               
               if { ($dq_per_rd_group == 18) || ($pin_i >= 4) } {
                  set pin_i [expr {$pin_i + 2}]
               }
            } elseif {$type_enum == "PORT_MEM_QKA" || $type_enum == "PORT_MEM_QKB"} {
               set pin_i [expr { ($dq_per_rd_group == 9) ? 4 : 0 }]
            } elseif {$type_enum == "PORT_MEM_QKA_N" || $type_enum == "PORT_MEM_QKB_N"} {
               set pin_i [expr { ($dq_per_rd_group == 9) ? 5 : 1 }]
            } else {
               set pin_i 11
            }
         }
         PORT_MEM_DKA -
         PORT_MEM_DKA_N -
         PORT_MEM_DKB -
         PORT_MEM_DKB_N {
            
            if {$type_enum == "PORT_MEM_DKB" || $type_enum == "PORT_MEM_DKB_N"} {
               set rd_groups [expr { $dq_per_port_width / $dq_per_rd_group }]
               set bus_i [expr { $bus_i + $rd_groups }]
            }
            
            set dk_i       $bus_i
            
            set tile_i [expr {int($dk_i / 2)}]
            set lane_i [expr {($dk_i % 2) * 2}]
            
            if {$tile_i >= $ac_tile_i} {
               set tile_i [expr { $tile_i + 1 }]
            }            
            
            if {$type_enum == "PORT_MEM_DKA" || $type_enum == "PORT_MEM_DKB"} {
               set pin_i [expr { ($dq_per_rd_group == 9) ? 4 : 0 }]
            } else {
               set pin_i [expr { ($dq_per_rd_group == 9) ? 5 : 1 }]
            }
         }
         default {
            emif_ie "Unknown port type $type_enum in [info level 0]"
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

proc ::altera_emif::ip_arch_nd::qdr4::assign_io_settings {ports_name} {
   upvar 1 $ports_name ports

   set io_voltage          [get_parameter_value PHY_QDR4_IO_VOLTAGE]
   set ac_io_std_enum      [get_parameter_value PHY_QDR4_AC_IO_STD_ENUM]
   set ac_mode_enum        [get_parameter_value PHY_QDR4_AC_MODE_ENUM]
   set ac_slew_rate_enum   [get_parameter_value PHY_QDR4_AC_SLEW_RATE_ENUM]
   set ck_io_std_enum      [get_parameter_value PHY_QDR4_CK_IO_STD_ENUM]
   set ck_mode_enum        [get_parameter_value PHY_QDR4_CK_MODE_ENUM]
   set ck_slew_rate_enum   [get_parameter_value PHY_QDR4_CK_SLEW_RATE_ENUM]
   set data_io_std_enum    [get_parameter_value PHY_QDR4_DATA_IO_STD_ENUM]
   set data_in_mode_enum   [get_parameter_value PHY_QDR4_DATA_IN_MODE_ENUM]
   set data_out_mode_enum  [get_parameter_value PHY_QDR4_DATA_OUT_MODE_ENUM]
   set ref_clk_io_std_enum [get_parameter_value PHY_QDR4_PLL_REF_CLK_IO_STD_ENUM]
   set rzq_io_std_enum     [get_parameter_value PHY_QDR4_RZQ_IO_STD_ENUM]

   set ac_cal_oct          [get_parameter_value PHY_AC_CALIBRATED_OCT]
   set ck_cal_oct          [get_parameter_value PHY_CK_CALIBRATED_OCT] 
   set data_cal_oct        [get_parameter_value PHY_DATA_CALIBRATED_OCT]    
   set dqs_pkg_deskew      [get_parameter_value BOARD_QDR4_IS_SKEW_WITHIN_QK_DESKEWED]
   set ac_pkg_deskew       [get_parameter_value BOARD_QDR4_IS_SKEW_WITHIN_AC_DESKEWED]
   
   set vrefin_pct          [get_parameter_value PHY_QDR4_STARTING_VREFIN]
   set vrefin_settings     [get_starting_vrefin_settings $vrefin_pct]
   set vrefin_cal_range    [dict get $vrefin_settings RANGE_ENUM]      
   
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
      set vref_mode_enum   VREF_MODE_INVALID

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
         PORT_MEM_CFG_N -
         PORT_MEM_LBK0_N -
         PORT_MEM_LBK1_N -
         PORT_MEM_LDA_N -
         PORT_MEM_LDB_N -
         PORT_MEM_RWA_N -
         PORT_MEM_RWB_N -
         PORT_MEM_AINV -
         PORT_MEM_A -
         PORT_MEM_AP {
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
         PORT_MEM_PE_N {
            set cal_oct $data_cal_oct
            set io_std_enum $data_io_std_enum
            set in_oct_enum $data_in_mode_enum
            set pkg_deskew $dqs_pkg_deskew
         }
         PORT_MEM_RESET_N {
            set cal_oct 0
            set io_std_enum IO_STD_CMOS_12
            set out_oct_enum OUT_OCT_0
            set slew_rate_enum $ac_slew_rate_enum
            set pkg_deskew $ac_pkg_deskew
         }
         PORT_MEM_DQA -
         PORT_MEM_DQB -
         PORT_MEM_DINVA -
         PORT_MEM_DINVB {
            set cal_oct $data_cal_oct
            set io_std_enum $data_io_std_enum
            set in_oct_enum $data_in_mode_enum
            if {[enum_type $data_out_mode_enum] == "OUT_OCT"} {
               set out_oct_enum $data_out_mode_enum
            } else {
               set current_st_enum $data_out_mode_enum
            }
            set pkg_deskew $dqs_pkg_deskew
            set vref_mode_enum $vrefin_cal_range
         }
         PORT_MEM_QKA -
         PORT_MEM_QKA_N -
         PORT_MEM_QKB -
         PORT_MEM_QKB_N {
            set cal_oct $data_cal_oct
            set io_std_enum [enum_data $data_io_std_enum DF_IO_STD]
            set in_oct_enum $data_in_mode_enum
            set pkg_deskew $dqs_pkg_deskew
            set vref_mode_enum $vrefin_cal_range
         }
         PORT_MEM_DKA -
         PORT_MEM_DKA_N -
         PORT_MEM_DKB -
         PORT_MEM_DKB_N {
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
            emif_ie "Unknown port type $type_enum in [info level 0]"
         }
      }
      
      dict set port CAL_OCT    $cal_oct
      dict set port IO_STD     $io_std_enum
      dict set port OUT_OCT    $out_oct_enum
      dict set port IN_OCT     $in_oct_enum
      dict set port CURRENT_ST $current_st_enum
      dict set port SLEW_RATE  $slew_rate_enum
      dict set port PKG_DESKEW $pkg_deskew
      dict set port VREF_MODE  $vref_mode_enum
      lset ports $i $port
   }
   return 1
}

proc ::altera_emif::ip_arch_nd::qdr4::get_clk_ratios {} {

   set rate_enum      [get_parameter_value PHY_QDR4_RATE_ENUM]
   set user_clk_ratio [enum_data $rate_enum RATIO]
   
   set ratios [dict create]
   
   dict set ratios PHY_HMC $user_clk_ratio
   dict set ratios C2P_P2C $user_clk_ratio
   dict set ratios USER $user_clk_ratio   
   
   return $ratios
}

proc ::altera_emif::ip_arch_nd::qdr4::get_num_and_type_of_hmc_ports {} {
   set hmc_ifs [dict create]
   dict set hmc_ifs NUM_OF_PORTS 0
   dict set hmc_ifs CTRL_AVL_PROTOCOL_ENUM CTRL_AVL_PROTOCOL_INVALID
   dict set hmc_ifs READY_LATENCY 0
   return $hmc_ifs
}

proc ::altera_emif::ip_arch_nd::qdr4::get_hmc_cfgs {hmc_inst} {
   set retval [dict create]
   
   foreach hmc_cfg_enum [enums_of_type HMC_CFG] {
      set val [enum_data $hmc_cfg_enum DEFAULT]
      dict set retval $hmc_cfg_enum $val
   }
   return $retval
}

proc ::altera_emif::ip_arch_nd::qdr4::get_lane_cfgs {} {
   set retval [dict create]
   
   set dq_per_rd_group   [get_parameter_value MEM_QDR4_DQ_PER_RD_GROUP]
   dict set retval "PREAMBLE_MODE" "preamble_one_cycle"
   dict set retval "DBI_WR_ENABLE" "false"
   dict set retval "DBI_RD_ENABLE" "false"
   dict set retval "SWAP_DQS_A_B"  "false"
   dict set retval "DQS_PACK_MODE" "not_packed"
   dict set retval "OCT_SIZE"      3

   if {$dq_per_rd_group == 9} {
      dict set retval "DQSA_LGC_MODE"         "dqsa_diff_in_1"
   } elseif {$dq_per_rd_group == 18} {
      dict set retval "DQSA_LGC_MODE"         "dqsa_diff_in_2"
   } else {
      dict set retval "DQSA_LGC_MODE"         "dqsa_diff_in_3"
   }
   dict set retval "DQSB_LGC_MODE"            "dqsb_constant"
   
   dict set retval "DBC_WB_RESERVED_ENTRY" 4  
   
   return $retval
}

proc ::altera_emif::ip_arch_nd::qdr4::derive_seq_param_tbl {seq_pt_enums} {
   
   set retval [dict create]
   
   foreach seq_pt_enum $seq_pt_enums {
      switch $seq_pt_enum {
         SEQ_PT_READ_LATENCY {
            set val     [get_parameter_value MEM_QDR4_TRL_CYC]
         }
         SEQ_PT_WRITE_LATENCY {
            set val     [get_parameter_value MEM_QDR4_TWL_CYC]
         }      
         SEQ_PT_NUM_RANKS {
            set val [get_parameter_value MEM_QDR4_DEVICE_DEPTH]
         }
         SEQ_PT_NUM_DIMMS {
            set val [get_parameter_value MEM_QDR4_DEVICE_DEPTH]
         }
         SEQ_PT_NUM_DQS_WR {
            set val [get_parameter_value MEM_QDR4_DK_WIDTH]
         }
         SEQ_PT_NUM_DQS_RD {
            set val [get_parameter_value MEM_QDR4_QK_WIDTH]
         }
         SEQ_PT_NUM_DQ {
            set val [get_parameter_value MEM_QDR4_DQ_WIDTH]
         }
         SEQ_PT_NUM_DM {
            set val [get_parameter_value MEM_QDR4_DINV_WIDTH]
         }
         SEQ_PT_CK_WIDTH {
            set val 1
         }         
         SEQ_PT_ADDR_WIDTH {
            set val [get_parameter_value MEM_QDR4_ADDR_WIDTH]
         }
         SEQ_PT_BANK_WIDTH -
         SEQ_PT_CS_WIDTH -
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
            set mr0 [get_parameter_value MEM_QDR4_CR0]
            set mr1 [get_parameter_value MEM_QDR4_CR1]
            set mr2 [get_parameter_value MEM_QDR4_CR2]

            set mrs [list \
               [dict create DBG_NAME "MR0" DBG_VALUE [num2bin $mr0 11] VALUE $mr0] \
               [dict create DBG_NAME "MR1" DBG_VALUE [num2bin $mr1 11] VALUE $mr1] \
               [dict create DBG_NAME "MR2" DBG_VALUE [num2bin $mr2 11] VALUE $mr2] \
               ]
            
            set val [dict create]
            dict set val PTR                0
            dict set val CONTENT            $mrs
            dict set val ITEM_BYTE_SIZE     4
            dict set val BYTE_SIZE          [expr {4 * [llength $mrs]}]

            dict set retval SEQ_PT_NUM_MR [llength $mrs]
         }
         SEQ_PT_DBG_SKIP_STEPS {
            set skip_vref_cal  [expr {[get_parameter_value "DIAG_QDR4_SKIP_VREF_CAL"] ? [expr {[enum_data SEQ_CONST_CALIB_SKIP_VREFIN_CAL] | [enum_data SEQ_CONST_CALIB_SKIP_VREFOUT_CAL]}] : 0}]
            set val            $skip_vref_cal
         }
         SEQ_PT_CAL_DATA_PTR {            
            set val [::altera_emif::ip_arch_nd::seq_param_tbl::get_cal_data_common_section]

            set vrefin_pct [get_parameter_value PHY_QDR4_STARTING_VREFIN]
            set vrefin_settings [get_starting_vrefin_settings $vrefin_pct]
            set vrefin_encoded [dict get $vrefin_settings VAL]
            dict lappend val CONTENT   [dict create DBG_NAME "STARTING_VREFIN" DBG_VALUE $vrefin_encoded VALUE $vrefin_encoded]

            set byte_size              [expr {[dict get $val ITEM_BYTE_SIZE] * [llength [dict get $val CONTENT]]}]
            dict set val BYTE_SIZE     $byte_size

            dict set retval SEQ_PT_CAL_DATA_SIZE $byte_size
         }
         SEQ_PT_CAL_DATA_SIZE {
            continue
         }	
         default {
            emif_ie "Unknown sequencer parameter table field $seq_pt_enum in [info level 0]"
         }
      }
      dict set retval $seq_pt_enum $val
   }
   return $retval
}


proc ::altera_emif::ip_arch_nd::qdr4::get_timing_params {} {

   set retval [dict create]

   set tck_ns [expr {1000.0 / [get_parameter_value PHY_QDR4_MEM_CLK_FREQ_MHZ]}]

   foreach tparam_enum [enums_of_type TPARAM] {

      set val 0

      switch $tparam_enum {
         TPARAM_PROTOCOL {
            set val "QDRIV"
         }
         TPARAM_NUM_RANKS {
            set val 1
         }		 
         TPARAM_SLEW_RATE_DRAM {
            set val [get_parameter_value BOARD_QDR4_RDATA_SLEW_RATE]
         }
         TPARAM_SLEW_RATE_DRAM_CLOCK {
            set val [get_parameter_value BOARD_QDR4_RCLK_SLEW_RATE]
         }
         TPARAM_VIN_MS {
            set val 0.15
         }
         TPARAM_VIN_MH {
            set val 0.08
         }
         TPARAM_SLEW_RATE_PHY {
            set val [get_parameter_value BOARD_QDR4_WDATA_SLEW_RATE]
         }
         TPARAM_SLEW_RATE_PHY_CLOCK {
            set val [get_parameter_value BOARD_QDR4_WCLK_SLEW_RATE]
         }
         TPARAM_SLEW_RATE_CA {
            set val [get_parameter_value BOARD_QDR4_AC_SLEW_RATE]
         }
         TPARAM_SLEW_RATE_CLOCK {
            set val [get_parameter_value BOARD_QDR4_CK_SLEW_RATE]
         }
         TPARAM_UI {
            set val [round_num $tck_ns 3]
         }
         TPARAM_TCK {
            set speedbin_enum      [get_parameter_value "MEM_QDR4_SPEEDBIN_ENUM"]
            set mem_fmax           [enum_data $speedbin_enum FMAX_MHZ]
            set val                [round_num [expr {1.0 / $mem_fmax * 1000.0}] 3]
         }
         TPARAM_TDQSQ {
            set val [expr {[get_parameter_value MEM_QDR4_TQKQ_MAX_PS] / 1000.0}]
         }
         TPARAM_TQH {
            set val [get_parameter_value MEM_QDR4_TQH_CYC]
         }
         TPARAM_TDS {
            set val [expr {[get_parameter_value MEM_QDR4_TISH_PS] / 2000.0}]
         }
         TPARAM_TDH {
            set val [expr {[get_parameter_value MEM_QDR4_TISH_PS] / 2000.0}]
         }
         TPARAM_TIS {
            set val [expr {[min [list [get_parameter_value MEM_QDR4_TASH_PS] [get_parameter_value MEM_QDR4_TCSH_PS]]] / 2000.0}]
         }
         TPARAM_TIH {
            set val [expr {[min [list [get_parameter_value MEM_QDR4_TASH_PS] [get_parameter_value MEM_QDR4_TCSH_PS]]] / 2000.0}]
         }
         TPARAM_TDQSCK {
            set val [expr {[get_parameter_value MEM_QDR4_TCKQK_MAX_PS] / 1000.0}]
         }
         TPARAM_TDQSS {
            set mem_freq_mhz [get_parameter_value PHY_QDR4_MEM_CLK_FREQ_MHZ]
            set tckdk_max_ps [get_parameter_value MEM_QDR4_TCKDK_MAX_PS]
            set val [expr {$tckdk_max_ps / (1.0 / $mem_freq_mhz * 1000000)}]
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
            set val [get_parameter_value BOARD_QDR4_SKEW_WITHIN_QK_NS]
         }
         TPARAM_CA_BD_PKG_SKEW {
            set val [get_parameter_value BOARD_QDR4_SKEW_WITHIN_AC_NS]
         }
         TPARAM_CA_TO_CK_BD_PKG_SKEW {
            set val [get_parameter_value BOARD_QDR4_AC_TO_CK_SKEW_NS]
         }
         TPARAM_RD_ISI {
            set val [get_parameter_value BOARD_QDR4_RDATA_ISI_NS]
         }
         TPARAM_WR_ISI {
            set val [get_parameter_value BOARD_QDR4_WDATA_ISI_NS]
         }
         TPARAM_CA_ISI {
            set val [get_parameter_value BOARD_QDR4_AC_ISI_NS]
         }
         TPARAM_DQSG_ISI {
            set val [get_parameter_value BOARD_QDR4_RCLK_ISI_NS]
         }
         TPARAM_WL_ISI {
            set val [get_parameter_value BOARD_QDR4_WCLK_ISI_NS]
         }
         TPARAM_DQS_BOARD_SKEW {
            set val [get_parameter_value BOARD_QDR4_SKEW_BETWEEN_DK_NS]
         }
         TPARAM_DQS_TO_CK_BOARD_SKEW {
            set val [get_parameter_value BOARD_QDR4_DK_TO_CK_SKEW_NS]
         }
         TPARAM_X4 {
            set val 0
         }
         TPARAM_IS_DLL_ON {
            set val [expr {[get_parameter_value DLL_MODE] == "ctl_dynamic" ? 1 : 0}]
         }
         TPARAM_OCT_RECAL {
           set val 0

         }
         TPARAM_RDBI {
            if {[get_parameter_value MEM_QDR4_DATA_INV_ENA]} {
               set val 1
            } else {
               set val 0
            }
         }
         TPARAM_WDBI {
            if {[get_parameter_value MEM_QDR4_DATA_INV_ENA]} {
               set val 1
            } else {
               set val 0
            }
         }         
         default {
            emif_ie "Unrecognized timing param $tparam_enum. [info level 0]"
         }
      }
      dict set retval $tparam_enum $val
   }
   return $retval
}

proc ::altera_emif::ip_arch_nd::qdr4::is_phy_tracking_enabled {} {
   return [::altera_emif::ip_arch_nd::qdrx::is_phy_tracking_enabled]
}

proc ::altera_emif::ip_arch_nd::qdr4::is_phy_shadow_register_disabled {} {
   return 0
}


proc ::altera_emif::ip_arch_nd::qdr4::_get_mem_ports {} {
   set ports [list]
   
   set addr_width          [get_parameter_value MEM_QDR4_ADDR_WIDTH]
   set dq_per_port_width   [get_parameter_value MEM_QDR4_DQ_PER_PORT_WIDTH]
   set dk_per_port_width   [get_parameter_value MEM_QDR4_DK_PER_PORT_WIDTH]
   set qk_per_port_width   [get_parameter_value MEM_QDR4_QK_PER_PORT_WIDTH]
   set dinv_per_port_width [get_parameter_value MEM_QDR4_DINV_PER_PORT_WIDTH]
   set config_enum         [get_parameter_value PHY_QDR4_CONFIG_ENUM]
   set ap_ena              [get_parameter_value MEM_QDR4_USE_ADDR_PARITY]
   set ainv_ena            [get_parameter_value MEM_QDR4_ADDR_INV_ENA]
   set dinv_ena            [get_parameter_value MEM_QDR4_DATA_INV_ENA]

   lappend ports {*}[create_port  true        PORT_MEM_CK         1                     [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_CK     ]]
   lappend ports {*}[create_port  true        PORT_MEM_CK_N       1                     [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_CK_N   ]]
   lappend ports {*}[create_port  true        PORT_MEM_A          $addr_width           [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  true        PORT_MEM_RESET_N    1                     [get_db_configs  PIN_RATE_SDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  $ap_ena     PORT_MEM_AP         1                     [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  $ap_ena     PORT_MEM_PE_N       1                     [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  $ainv_ena   PORT_MEM_AINV       1                     [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  true        PORT_MEM_LDA_N      1                     [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  true        PORT_MEM_LDB_N      1                     [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  true        PORT_MEM_RWA_N      1                     [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  true        PORT_MEM_RWB_N      1                     [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  true        PORT_MEM_CFG_N      1                     [get_db_configs  PIN_RATE_SDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  true        PORT_MEM_LBK0_N     1                     [get_db_configs  PIN_RATE_SDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  true        PORT_MEM_LBK1_N     1                     [get_db_configs  PIN_RATE_SDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  true        PORT_MEM_DKA        $dk_per_port_width    [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_WCLK   ]]
   lappend ports {*}[create_port  true        PORT_MEM_DKA_N      $dk_per_port_width    [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_WCLK_N ]]
   lappend ports {*}[create_port  true        PORT_MEM_DKB        $dk_per_port_width    [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_WCLK   ]]
   lappend ports {*}[create_port  true        PORT_MEM_DKB_N      $dk_per_port_width    [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_WCLK_N ]]
   lappend ports {*}[create_port  true        PORT_MEM_QKA        $qk_per_port_width    [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_RCLK   ]]
   lappend ports {*}[create_port  true        PORT_MEM_QKA_N      $qk_per_port_width    [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_RCLK_N ]]
   lappend ports {*}[create_port  true        PORT_MEM_QKB        $qk_per_port_width    [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_RCLK   ]]
   lappend ports {*}[create_port  true        PORT_MEM_QKB_N      $qk_per_port_width    [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_RCLK_N ]]
   lappend ports {*}[create_port  true        PORT_MEM_DQA        $dq_per_port_width    [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_DQ     ]]
   lappend ports {*}[create_port  true        PORT_MEM_DQB        $dq_per_port_width    [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_DQ     ]]
   lappend ports {*}[create_port  $dinv_ena   PORT_MEM_DINVA      $dinv_per_port_width  [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_DQ     ]]
   lappend ports {*}[create_port  $dinv_ena   PORT_MEM_DINVB      $dinv_per_port_width  [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_DQ     ]]

   return $ports
}

proc ::altera_emif::ip_arch_nd::qdr4::_get_afi_ports {} {
   set ports [altera_emif::ip_arch_nd::util::get_common_afi_ports]
   
   set clk_ratios      [get_clk_ratios]
   set sdr_ratio       [dict get $clk_ratios C2P_P2C]
   set ddr_ratio       [expr {$sdr_ratio * 2}]
   
   set ddr_x2_ratio    [expr {$ddr_ratio * 2}]

   set sdr_x2_ratio    [expr {$sdr_ratio * 2}]
   
   set addr_width      [expr {[get_parameter_value MEM_QDR4_ADDR_WIDTH]      * $ddr_ratio}]
   set data_width      [expr {[get_parameter_value MEM_QDR4_DQ_WIDTH]        * $ddr_ratio}]
   set dinv_width      [expr {[get_parameter_value MEM_QDR4_DINV_WIDTH]      * $ddr_ratio}]
   
   set ap_ena          [get_parameter_value MEM_QDR4_USE_ADDR_PARITY]
   set ainv_ena        [get_parameter_value MEM_QDR4_ADDR_INV_ENA]
   set dinv_ena        [get_parameter_value MEM_QDR4_DATA_INV_ENA]
   
   set rank_en           [expr {[get_parameter_value MEM_QDR4_DEVICE_DEPTH] > 1 ? 1 : 0}]
   set rank_width        [expr {[get_parameter_value MEM_QDR4_DEVICE_DEPTH] * $sdr_ratio}]
   
   lappend ports {*}[create_port  true        PORT_AFI_ADDR                     $addr_width          ]
   lappend ports {*}[create_port  $ap_ena     PORT_AFI_AP                       $ddr_ratio           ]
   lappend ports {*}[create_port  $ap_ena     PORT_AFI_PE_N                     $ddr_ratio           ]
   lappend ports {*}[create_port  $ainv_ena   PORT_AFI_AINV                     $ddr_ratio           ]
   lappend ports {*}[create_port  true        PORT_AFI_LD_N                     $ddr_x2_ratio        ]
   lappend ports {*}[create_port  true        PORT_AFI_RW_N                     $ddr_x2_ratio        ]
   lappend ports {*}[create_port  true        PORT_AFI_CFG_N                    $sdr_ratio           ]
   lappend ports {*}[create_port  true        PORT_AFI_LBK0_N                   $sdr_ratio           ]
   lappend ports {*}[create_port  true        PORT_AFI_LBK1_N                   $sdr_ratio           ]
   lappend ports {*}[create_port  true        PORT_AFI_RST_N                    $sdr_ratio           ]
   lappend ports {*}[create_port  true        PORT_AFI_WDATA_VALID              $sdr_x2_ratio        ]
   lappend ports {*}[create_port  true        PORT_AFI_WDATA                    $data_width          ]
   lappend ports {*}[create_port  true        PORT_AFI_RDATA_EN_FULL            $sdr_x2_ratio        ]
   lappend ports {*}[create_port  true        PORT_AFI_RDATA                    $data_width          ]
   lappend ports {*}[create_port  true        PORT_AFI_RDATA_VALID              $sdr_x2_ratio        ]
   lappend ports {*}[create_port  $dinv_ena   PORT_AFI_RDATA_DINV               $dinv_width          ]
   lappend ports {*}[create_port  $dinv_ena   PORT_AFI_WDATA_DINV               $dinv_width          ]
   lappend ports {*}[create_port  $rank_en    PORT_AFI_RRANK                    $rank_width          ]
   lappend ports {*}[create_port  $rank_en    PORT_AFI_WRANK                    $rank_width          ]

   return $ports
}

::altera_emif::ip_arch_nd::qdr4::_init
