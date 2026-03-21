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


package provide altera_emif::ip_arch_nd::rld2 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::math
package require altera_emif::util::enums
package require altera_emif::util::device_family

package require altera_emif::arch_common::util

package require altera_emif::ip_arch_nd::enum_defs_ac_pin_mapping
package require altera_emif::ip_arch_nd::util
package require altera_emif::ip_arch_nd::rldx

namespace eval ::altera_emif::ip_arch_nd::rld2:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::ip_arch_nd::util::*

   
}


proc ::altera_emif::ip_arch_nd::rld2::get_dqs_bus_mode {} {
   set dq_per_device   [get_parameter_value MEM_RLD2_DQ_PER_DEVICE]
   if {$dq_per_device == 36} {
      return DQS_BUS_MODE_X16_X18
   } else {
      return DQS_BUS_MODE_X8_X9
   }
}

proc ::altera_emif::ip_arch_nd::rld2::get_interface_ports {if_enum} {
   switch $if_enum {
      IF_MEM {
         return [_get_mem_ports]
      }
      IF_AFI {
         return [_get_afi_ports]
      }
      default {
         emif_ie "Unknown interface type $if_enum"
      }
   }
}

proc ::altera_emif::ip_arch_nd::rld2::is_ctrl_sideband_interface_enabled {if_enum} {
   return 0
}

proc ::altera_emif::ip_arch_nd::rld2::get_interface_properties {if_enum} {
   emif_ie "Interface type $if_enum not supported"
}

proc ::altera_emif::ip_arch_nd::rld2::get_ac_pin_map_scheme {} {
   set retval [dict create]
   dict set retval ENUM              "RLD2_AC_PM_0_1_2"
   
   dict set retval HMC_DIMM_TYPE_STR "dimm_type_component"
   
   return $retval
}

proc ::altera_emif::ip_arch_nd::rld2::get_resource_consumption {} {
   
   set dq_width        [get_parameter_value MEM_RLD2_DQ_WIDTH]
   set dq_per_device   [get_parameter_value MEM_RLD2_DQ_PER_DEVICE]
   set qk_width        [get_parameter_value MEM_RLD2_QK_WIDTH]
   set dk_width        [get_parameter_value MEM_RLD2_DK_WIDTH]
   set ac_pm_scheme    [get_ac_pin_map_scheme]
   set ac_pm_enum      [dict get $ac_pm_scheme ENUM]
   
   set num_ac_tile     1
   set num_ac_lanes    [enum_data $ac_pm_enum LANES_USED]
   set num_devices     [expr {$dq_width / $dq_per_device}]
   if {$dq_per_device == 9} {
      set num_data_lanes [expr {$num_devices * 2}]
   } elseif {$dq_per_device == 18} {
      set num_data_lanes [expr {$num_devices * 3}]
   } elseif {$dq_per_device == 36} {
      set num_data_lanes [expr {$num_devices * 4}]
   }
   set num_data_tiles  [expr {$dq_per_device == 9 ? 1 : $num_devices}]
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

proc ::altera_emif::ip_arch_nd::rld2::alloc_mem_pins {mem_ports_name} {

   upvar 1 $mem_ports_name mem_ports
   set tiles [dict create]

   set lanes_per_tile  [::altera_emif::util::device_family::get_family_trait FAMILY_TRAIT_LANES_PER_TILE]
   set pins_per_lane   [::altera_emif::util::device_family::get_family_trait FAMILY_TRAIT_PINS_PER_LANE]
   set pins_per_tile   [expr {$lanes_per_tile * $pins_per_lane}]
   
   set dq_per_device   [get_parameter_value MEM_RLD2_DQ_PER_DEVICE]
   set dq_per_rd_group [get_parameter_value MEM_RLD2_DQ_PER_RD_GROUP]
   set dq_per_wr_group [get_parameter_value MEM_RLD2_DQ_PER_WR_GROUP] 

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
         PORT_MEM_WE_N {
            set abs_pin_i [get_ac_pin_index $ac_pm_enum $type_enum $bus_i]
            set tile_i    $ac_tile_i
            set lane_i    [expr {int($abs_pin_i / $pins_per_lane)}]
            set pin_i     [expr {$abs_pin_i % $pins_per_lane}]
         }
         PORT_MEM_DQ { 
            set rd_group [expr {int($bus_i / $dq_per_rd_group)}]

            if {$dq_per_device == 9} {
                set qk_p 4

                set tile_i 0  
                set lane_i [expr {2 * int($bus_i / 9)}]

                set pin_i [expr {$bus_i % 9}]
                if {($pin_i >= $qk_p)} {
                   set pin_i [expr {$pin_i + 2}] 
                }  
            } elseif {$dq_per_device == 18} {
                set qk_p 4
            
                set tile_i [expr {int($rd_group / 2)}]
                set lane_i [expr {$rd_group % 2}]
                
                set pin_i  [expr {$bus_i % 9}]
                if {($pin_i >= $qk_p)} {
                    set pin_i [expr {$pin_i + 2}]
                }

            } else {
                set tile_i [expr {int($rd_group / 2)}] 
                
                set abs_i [expr {$bus_i % 36}]
                if {$abs_i < 12} {
                   set lane_i 0
                } elseif {$abs_i >= 12 && $abs_i < 18} {
                   set lane_i 1
                } elseif {$abs_i >= 18 && $abs_i < 30} {
                   set lane_i 2
                } else {
                   set lane_i 3
                }

                set abs_i [expr {$bus_i % 18}]
                if {($abs_i < 12)} {
                  set pin_i [expr {$abs_i % 12}]
                } else {
                  set pin_i [expr {($abs_i % 12) + 2}]
                }
            }

            if {$tile_i >= $ac_tile_i} {
               set tile_i [expr {$tile_i + 1}]
            }

         }
         PORT_MEM_QK -
         PORT_MEM_QK_N {
            set rd_group $bus_i
            if {$dq_per_device == 9} {
               set tile_i 0
               set lane_i [expr {2 * $rd_group}]
               if {$type_enum == "PORT_MEM_QK"} {
                  set pin_i 4 
               } else {
                  set pin_i 5
               }
            } elseif {$dq_per_device == 18} {
                set tile_i [expr {int($rd_group / 2)}]
                set lane_i [expr {$bus_i % 2}]
                if {$type_enum == "PORT_MEM_QK"} {
                  set pin_i 4 
                } else {
                  set pin_i 5
                }
            } else {
                set tile_i [expr {int($rd_group / 2)}]
                set lane_i [expr {2 * ($bus_i % 2) + 1}]
                if {$type_enum == "PORT_MEM_QK"} {
                   set pin_i 0
                } else {
                   set pin_i 1
                }
            }

            if {$tile_i >= $ac_tile_i} {
               set tile_i [expr {$tile_i + 1}]
            }
         }
         PORT_MEM_DK -
         PORT_MEM_DK_N {
            set wr_group $bus_i
            if {$dq_per_device == 9} {
               set tile_i 0
               set lane_i [expr {(2 * $wr_group) + 1}]
            } elseif {$dq_per_device == 18} {
                set tile_i $wr_group
                set lane_i 2
            } else {
                set tile_i [expr {int($wr_group / 2)}]
                set lane_i [expr {2 * ($bus_i % 2) + 1}] 
            }

            if {$tile_i >= $ac_tile_i} {
               set tile_i [expr {$tile_i + 1}]
            }

            if {$type_enum == "PORT_MEM_DK"} {
               set pin_i 9
            } else {
               set pin_i 10
            }
         }
         PORT_MEM_DM {
            set wr_group $bus_i
            if {$dq_per_device == 9} {
               set tile_i 0
               set lane_i [expr {2 * ($bus_i % 2) + 1}]
            } elseif {$dq_per_device == 18} {
               set tile_i $wr_group
               set lane_i 2
            } else {
               set tile_i $wr_group
               set lane_i 3
            }
            
            if {$tile_i >= $ac_tile_i} {
               set tile_i [expr { $tile_i + 1 }]
            }            
            set pin_i 11
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

proc ::altera_emif::ip_arch_nd::rld2::assign_io_settings {ports_name} {
   upvar 1 $ports_name ports

   set io_voltage          [get_parameter_value PHY_RLD2_IO_VOLTAGE]
   set ac_io_std_enum      [get_parameter_value PHY_RLD2_AC_IO_STD_ENUM]
   set ac_mode_enum        [get_parameter_value PHY_RLD2_AC_MODE_ENUM]
   set ac_slew_rate_enum   [get_parameter_value PHY_RLD2_AC_SLEW_RATE_ENUM]
   set ck_io_std_enum      [get_parameter_value PHY_RLD2_CK_IO_STD_ENUM]
   set ck_mode_enum        [get_parameter_value PHY_RLD2_CK_MODE_ENUM]
   set ck_slew_rate_enum   [get_parameter_value PHY_RLD2_CK_SLEW_RATE_ENUM]
   set data_io_std_enum    [get_parameter_value PHY_RLD2_DATA_IO_STD_ENUM]
   set data_in_mode_enum   [get_parameter_value PHY_RLD2_DATA_IN_MODE_ENUM]
   set data_out_mode_enum  [get_parameter_value PHY_RLD2_DATA_OUT_MODE_ENUM]
   set ref_clk_io_std_enum [get_parameter_value PHY_RLD2_PLL_REF_CLK_IO_STD_ENUM]
   set rzq_io_std_enum     [get_parameter_value PHY_RLD2_RZQ_IO_STD_ENUM]

   set ac_cal_oct          [get_parameter_value PHY_AC_CALIBRATED_OCT]
   set ck_cal_oct          [get_parameter_value PHY_CK_CALIBRATED_OCT] 
   set data_cal_oct        [get_parameter_value PHY_DATA_CALIBRATED_OCT]    
   set dqs_pkg_deskew      false 
   set ac_pkg_deskew       false 
   
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

proc ::altera_emif::ip_arch_nd::rld2::get_clk_ratios {} {

   set rate_enum      [get_parameter_value PHY_RLD2_RATE_ENUM]
   set user_clk_ratio [enum_data $rate_enum RATIO]
   
   set ratios [dict create]
   dict set ratios PHY_HMC $user_clk_ratio
   dict set ratios C2P_P2C $user_clk_ratio
   dict set ratios USER $user_clk_ratio   
   
   return $ratios
}

proc ::altera_emif::ip_arch_nd::rld2::get_num_and_type_of_hmc_ports {} {
   set hmc_ifs [dict create]
   dict set hmc_ifs NUM_OF_PORTS 0
   dict set hmc_ifs CTRL_AVL_PROTOCOL_ENUM CTRL_AVL_PROTOCOL_INVALID
   dict set hmc_ifs READY_LATENCY 0
   return $hmc_ifs
}

proc ::altera_emif::ip_arch_nd::rld2::get_hmc_cfgs {hmc_inst} {
   set retval [dict create]
   
   foreach hmc_cfg_enum [enums_of_type HMC_CFG] {
      set val [enum_data $hmc_cfg_enum DEFAULT]
      dict set retval $hmc_cfg_enum $val
   }
   return $retval
}

proc ::altera_emif::ip_arch_nd::rld2::get_lane_cfgs {} {
   set retval [dict create]
   dict set retval "PREAMBLE_MODE"         "preamble_one_cycle"
   dict set retval "DBI_WR_ENABLE"         "false"
   dict set retval "DBI_RD_ENABLE"         "false"
   dict set retval "SWAP_DQS_A_B"          "false"
   dict set retval "DQS_PACK_MODE"         "not_packed"
   dict set retval "OCT_SIZE"              2
   dict set retval "DBC_WB_RESERVED_ENTRY" 4                      
   return $retval
}

proc ::altera_emif::ip_arch_nd::rld2::derive_seq_param_tbl {seq_pt_enums} {
   
   set retval [dict create]
   
   foreach seq_pt_enum $seq_pt_enums {
      switch $seq_pt_enum {
         SEQ_PT_READ_LATENCY {
            set dl_enum [get_parameter_value "MEM_RLD2_CONFIG_ENUM"]
            set val     [enum_data $dl_enum TRL]
         }
         SEQ_PT_WRITE_LATENCY {
            set dl_enum [get_parameter_value "MEM_RLD2_CONFIG_ENUM"]
            set val     [enum_data $dl_enum TWL]
         }      
         SEQ_PT_NUM_RANKS {
            set val [get_parameter_value MEM_RLD2_DEVICE_DEPTH]
         }
         SEQ_PT_NUM_DIMMS {
            set val [get_parameter_value MEM_RLD2_DEVICE_DEPTH]
         }
         SEQ_PT_NUM_DQS_WR {
            set val [get_parameter_value MEM_RLD2_DK_WIDTH]
         }
         SEQ_PT_NUM_DQS_RD {
            set val [get_parameter_value MEM_RLD2_QK_WIDTH]
         }
         SEQ_PT_NUM_DQ {
            set val [get_parameter_value MEM_RLD2_DQ_WIDTH]
         }
         SEQ_PT_NUM_DM {
            if {[get_parameter_value MEM_RLD2_DM_EN]} {
               set val [get_parameter_value MEM_RLD2_DM_WIDTH]
            } else {
               set val 0
            }
         }
         SEQ_PT_CK_WIDTH {
            set val 1
         }         
         SEQ_PT_ADDR_WIDTH {
            set val [get_parameter_value MEM_RLD2_ADDR_WIDTH]
         }
         SEQ_PT_BANK_WIDTH {
            set val [get_parameter_value MEM_RLD2_BANK_ADDR_WIDTH]
         }
         SEQ_PT_CS_WIDTH {
            set val [get_parameter_value MEM_RLD2_CS_WIDTH]
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
            set mr [get_parameter_value MEM_RLD2_MR]

            set mrs [list \
               [dict create DBG_NAME "MR" DBG_VALUE [num2bin $mr 22] VALUE $mr]] 
            
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
            set val [::altera_emif::ip_arch_nd::seq_param_tbl::get_cal_data_common_section]


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


proc ::altera_emif::ip_arch_nd::rld2::get_timing_params {} {

   set retval [dict create]

   set tck_ns [expr {1000.0 / [get_parameter_value PHY_RLD2_MEM_CLK_FREQ_MHZ]}]

   foreach tparam_enum [enums_of_type TPARAM] {

      set val 0

      switch $tparam_enum {
         TPARAM_PROTOCOL {
            set val "RLDRAMII"
         }
         TPARAM_NUM_RANKS {
            set val [get_parameter_value "MEM_RLD2_CS_WIDTH"]
         }		 
         TPARAM_SLEW_RATE_DRAM {
            set val 4.0
         }
         TPARAM_SLEW_RATE_DRAM_CLOCK {
            set val 4.0
         }
         TPARAM_VIN_MS {
            set val 0.136
         }
         TPARAM_VIN_MH {
            set val 0.068
         }
         TPARAM_SLEW_RATE_PHY {
            set val 2.0
         }
         TPARAM_SLEW_RATE_PHY_CLOCK {
            set val 2.0
         }
         TPARAM_SLEW_RATE_CA {
            set val 2.0
         }
         TPARAM_SLEW_RATE_CLOCK {
            set val 2.0
         }
         TPARAM_UI {
            set val [round_num $tck_ns 3]
         }
         TPARAM_TCK {
            set speedbin_enum      [get_parameter_value "MEM_RLD2_SPEEDBIN_ENUM"]
            set mem_fmax           [enum_data $speedbin_enum FMAX_MHZ]
            set val                [round_num [expr 1.0/$mem_fmax*1000.0] 3]
         }
         TPARAM_TDQSQ {
            set val [get_parameter_value MEM_RLD2_TQKQ_MAX_NS]
         }
         TPARAM_TQH {
            set val 0
         }
         TPARAM_TDS {
            set val [get_parameter_value MEM_RLD2_TDS_NS]
         }
         TPARAM_TDH {
            set val [get_parameter_value MEM_RLD2_TDH_NS]
         }
         TPARAM_TIS {
            set val 0
         }
         TPARAM_TIH {
            set val 0
         }
         TPARAM_TDQSCK {
            set val [get_parameter_value MEM_RLD2_TCKQK_MAX_NS]
         }
         TPARAM_TDQSS {
            set val 0
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
            set val 0.020
         }
         TPARAM_CA_BD_PKG_SKEW {
            set val 0.020
         }
         TPARAM_CA_TO_CK_BD_PKG_SKEW {
            set val 0.000
         }
         TPARAM_RD_ISI {
            set val 0.063
         }
         TPARAM_WR_ISI {
            set val 0.063
         }
         TPARAM_CA_ISI {
            set val 0.094
         }
         TPARAM_DQSG_ISI {
            set val 0.094
         }
         TPARAM_WL_ISI {
            set val 0.031
         }
         TPARAM_DQS_BOARD_SKEW {
            set val 0.020
         }
         TPARAM_DQS_TO_CK_BOARD_SKEW {
            set val 0.000
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
            set val 0
         }
         TPARAM_WDBI {
            set val 0
         }
         default {
            emif_ie "Unrecognized timing param $tparam_enum"
         }
      }
      dict set retval $tparam_enum $val
   }
   return $retval
}

proc ::altera_emif::ip_arch_nd::rld2::is_phy_tracking_enabled {} {
   return [::altera_emif::ip_arch_nd::rldx::is_phy_tracking_enabled]
}

proc ::altera_emif::ip_arch_nd::rld2::is_phy_shadow_register_disabled {} {
   return 0
}


proc ::altera_emif::ip_arch_nd::rld2::_get_mem_ports {} {
   set ports [list]
   
   set addr_width      [get_parameter_value MEM_RLD2_ADDR_WIDTH]
   set bank_addr_width [get_parameter_value MEM_RLD2_BANK_ADDR_WIDTH]
   set dq_width        [get_parameter_value MEM_RLD2_DQ_WIDTH]
   set dk_width        [get_parameter_value MEM_RLD2_DK_WIDTH]
   set dm_en           [get_parameter_value MEM_RLD2_DM_EN]
   set dm_width        [get_parameter_value MEM_RLD2_DM_WIDTH]
   set qk_width        [get_parameter_value MEM_RLD2_QK_WIDTH]
   set config_enum     [get_parameter_value PHY_RLD2_CONFIG_ENUM]

   lappend ports {*}[create_port  true      PORT_MEM_CK       1                  [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_CK     ]]
   lappend ports {*}[create_port  true      PORT_MEM_CK_N     1                  [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_CK_N   ]]
   lappend ports {*}[create_port  true      PORT_MEM_A        $addr_width        [get_db_configs  PIN_RATE_SDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  true      PORT_MEM_BA       $bank_addr_width   [get_db_configs  PIN_RATE_SDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  true      PORT_MEM_CS_N     1                  [get_db_configs  PIN_RATE_SDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  true      PORT_MEM_WE_N     1                  [get_db_configs  PIN_RATE_SDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  true      PORT_MEM_REF_N    1                  [get_db_configs  PIN_RATE_SDR  $config_enum  DB_PIN_TYPE_AC     ]]
   lappend ports {*}[create_port  true      PORT_MEM_DK       $dk_width          [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_WCLK   ]]
   lappend ports {*}[create_port  true      PORT_MEM_DK_N     $dk_width          [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_WCLK_N ]]
   lappend ports {*}[create_port  true      PORT_MEM_QK       $qk_width          [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_RCLK   ]]
   lappend ports {*}[create_port  true      PORT_MEM_QK_N     $qk_width          [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_RCLK_N ]]
   lappend ports {*}[create_port  true      PORT_MEM_DQ       $dq_width          [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_DQ     ]]
   lappend ports {*}[create_port  $dm_en    PORT_MEM_DM       $dm_width          [get_db_configs  PIN_RATE_DDR  $config_enum  DB_PIN_TYPE_DM     ]]

   return $ports
}

proc ::altera_emif::ip_arch_nd::rld2::_get_afi_ports {} {
   set ports [altera_emif::ip_arch_nd::util::get_common_afi_ports]
   
   set clk_ratios        [get_clk_ratios]
   set sdr_ratio         [dict get $clk_ratios C2P_P2C]
   set ddr_ratio         [expr {$sdr_ratio * 2}]
   set user_clk_ratio    [dict get $clk_ratios USER]  

   set addr_width        [expr {[get_parameter_value MEM_RLD2_ADDR_WIDTH]      * $sdr_ratio}]
   set bank_addr_width   [expr {[get_parameter_value MEM_RLD2_BANK_ADDR_WIDTH] * $sdr_ratio}]
   set cs_width          [expr {[get_parameter_value MEM_RLD2_CS_WIDTH]        * $sdr_ratio}]
   set data_width        [expr {[get_parameter_value MEM_RLD2_DQ_WIDTH]        * $ddr_ratio}]
   set dm_width          [expr {[get_parameter_value MEM_RLD2_DM_WIDTH]        * $ddr_ratio}]
   set dm_en             [get_parameter_value MEM_RLD2_DM_EN]
   
   set rank_en           [expr {[get_parameter_value MEM_RLD2_DEVICE_DEPTH] > 1 ? 1 : 0}]
   set rank_width        [expr {[get_parameter_value MEM_RLD2_DEVICE_DEPTH] * $sdr_ratio}]
   
   lappend ports {*}[create_port  true        PORT_AFI_ADDR                     $addr_width          ]
   lappend ports {*}[create_port  true        PORT_AFI_BA                       $bank_addr_width     ]
   lappend ports {*}[create_port  true        PORT_AFI_CS_N                     $cs_width            ]
   lappend ports {*}[create_port  true        PORT_AFI_WE_N                     $sdr_ratio           ]
   lappend ports {*}[create_port  true        PORT_AFI_REF_N                    $sdr_ratio           ]
   lappend ports {*}[create_port  true        PORT_AFI_RST_N                    $sdr_ratio           ]
   lappend ports {*}[create_port  $dm_en      PORT_AFI_DM                       $dm_width            ]
   lappend ports {*}[create_port  true        PORT_AFI_WDATA_VALID              $sdr_ratio           ]
   lappend ports {*}[create_port  true        PORT_AFI_WDATA                    $data_width          ]
   lappend ports {*}[create_port  true        PORT_AFI_RDATA_EN_FULL            $user_clk_ratio      ]
   lappend ports {*}[create_port  true        PORT_AFI_RDATA                    $data_width          ]
   lappend ports {*}[create_port  true        PORT_AFI_RDATA_VALID              $user_clk_ratio      ]
   lappend ports {*}[create_port  $rank_en    PORT_AFI_RRANK                    $rank_width          ]
   lappend ports {*}[create_port  $rank_en    PORT_AFI_WRANK                    $rank_width          ]

   return $ports
   
}

proc ::altera_emif::ip_arch_nd::rld2::_init {} {
}

:altera_emif::ip_arch_nd::rld2::_init
