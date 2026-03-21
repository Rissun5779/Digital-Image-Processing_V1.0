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


package provide altera_emif::ip_arch_nd::util 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::device_family
package require altera_emif::util::math
package require altera_emif::ip_arch_nd::enum_defs_seq_param_tbl

namespace eval ::altera_emif::ip_arch_nd::util:: {

   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::device_family::*

   namespace export get_ac_pin_index
   namespace export get_ac_tile_index
   namespace export get_db_configs
   namespace export get_sim_cal_code_hex_filename
   namespace export get_sim_cal_code_hex_src_filename
   namespace export get_synth_cal_code_hex_filename
   namespace export get_synth_cal_code_hex_src_filename
   namespace export get_sim_cal_code_fw_filename
   namespace export get_sim_cal_code_fw_src_filename
   namespace export get_synth_cal_code_fw_filename
   namespace export get_synth_cal_code_fw_src_filename
   namespace export get_sim_params_hex_filename
   namespace export get_synth_params_hex_filename
   namespace export get_emif_export_src_filename
   namespace export get_hps_handoff_xml_filename
   namespace export get_wysiwyg_silicon_rev_string
   namespace export get_die_string
   namespace export get_starting_vrefin_settings
}


proc ::altera_emif::ip_arch_nd::util::get_ac_pin_index {ac_pm_enum port_mem_enum bus_index} {
   set pmr_enum_type [enum_data $ac_pm_enum RULES_ENUM_TYPE]
   set pmr_enum      "${pmr_enum_type}_[string range $port_mem_enum 9 end]_${bus_index}"
   return [enum_data $pmr_enum PIN_INDEX]
}

proc ::altera_emif::ip_arch_nd::util::get_ac_tile_index {mem_ports} {
   foreach port $mem_ports {
      set enabled [dict get $port ENABLED]
      if {$enabled} {
         set type_enum [dict get $port TYPE_ENUM]

         if {$type_enum == "PORT_MEM_A"} {
            return [dict get $port TILE_INDEX]
         }
      }
   }
   emif_ie "Unable to find an address/command pins"
   return -1
}

proc ::altera_emif::ip_arch_nd::util::get_center_tid {tile_i} {
   return [expr {($tile_i << 3) | [enum_data SEQ_CONST_TILE_ID_IO_CENTER VALUE]}]
}

proc ::altera_emif::ip_arch_nd::util::get_hmc_tid {tile_i} {
   return [expr {($tile_i << 3) | [enum_data SEQ_CONST_TILE_ID_IO_HMC VALUE]}]
}

proc ::altera_emif::ip_arch_nd::util::get_lane_tid {tile_i lane_i} {
   return [expr {($tile_i << 3) | $lane_i}]
}

proc ::altera_emif::ip_arch_nd::util::get_common_afi_ports {} {
   set ports [list]

   lappend ports {*}[create_port  true        PORT_AFI_CAL_SUCCESS  "default"        ]
   lappend ports {*}[create_port  true        PORT_AFI_CAL_FAIL     "default"        ]
   lappend ports {*}[create_port  true        PORT_AFI_CAL_REQ      "default"        ]
   lappend ports {*}[create_port  true        PORT_AFI_WLAT         "default"        ]
   lappend ports {*}[create_port  true        PORT_AFI_RLAT         "default"        ]

   return $ports
}

proc ::altera_emif::ip_arch_nd::util::get_db_configs {rate_enum config_enum db_pin_type_enum} {
   set retval [dict create]

   dict set retval RATE_ENUM $rate_enum
   
   if {$config_enum == "CONFIG_PHY_AND_HARD_CTRL"} {
      if {$db_pin_type_enum == "DB_PIN_TYPE_AC" || $db_pin_type_enum == "DB_PIN_TYPE_ALERT_N"} {
         dict set retval C2L_DRIVEN                 false
         dict set retval DB_PROC_ENUM               "DB_PIN_PROC_MODE_WDB_AC"
         dict set retval DATA_IN_MODE               "PIN_DATA_IN_MODE_SSTL_IN"

         if {$db_pin_type_enum == "DB_PIN_TYPE_ALERT_N"} {
            dict set retval DB_PROC_ENUM            "DB_PIN_PROC_MODE_GPIO"
         }

      } elseif {$db_pin_type_enum == "DB_PIN_TYPE_DQ" || $db_pin_type_enum == "DB_PIN_TYPE_DQ_WITH_DBI_CRC"} {
         dict set retval C2L_DRIVEN                 true
         dict set retval DATA_IN_MODE               "PIN_DATA_IN_MODE_SSTL_IN"
		   dict set retval DB_PROC_ENUM               "DB_PIN_PROC_MODE_WDB_DQ"
		 
      } elseif {$db_pin_type_enum == "DB_PIN_TYPE_DM"} {
         dict set retval C2L_DRIVEN                 true
         dict set retval DATA_IN_MODE               "PIN_DATA_IN_MODE_SSTL_IN"
		   dict set retval DB_PROC_ENUM               "DB_PIN_PROC_MODE_WDB_DM"
		 
      } elseif {$db_pin_type_enum == "DB_PIN_TYPE_CK" || $db_pin_type_enum == "DB_PIN_TYPE_CK_N"} {
         dict set retval C2L_DRIVEN                 false
         dict set retval DATA_IN_MODE               "PIN_DATA_IN_MODE_DIFF_IN_AVL_X12_OUT"
		   dict set retval DB_PROC_ENUM               "DB_PIN_PROC_MODE_WDB_CLK"

      } elseif {$db_pin_type_enum == "DB_PIN_TYPE_DQS" || $db_pin_type_enum == "DB_PIN_TYPE_DDR4_DQS"} {
         dict set retval C2L_DRIVEN                 false
         dict set retval DATA_IN_MODE               "PIN_DATA_IN_MODE_DIFF_IN_AVL_X12_OUT"
		   dict set retval DB_PROC_ENUM               "DB_PIN_PROC_MODE_WDB_DQS"

      } elseif {$db_pin_type_enum == "DB_PIN_TYPE_DQS_N" || $db_pin_type_enum == "DB_PIN_TYPE_DDR4_DQS_N"} {
         dict set retval C2L_DRIVEN                 false
         dict set retval DATA_IN_MODE               "PIN_DATA_IN_MODE_DIFF_IN_AVL_X12_OUT"
		   dict set retval DB_PROC_ENUM               "DB_PIN_PROC_MODE_WDB_DQSB"

      } elseif {$db_pin_type_enum == "DB_PIN_TYPE_WCLK"} {
         dict set retval C2L_DRIVEN                 false
         dict set retval DATA_IN_MODE               "PIN_DATA_IN_MODE_DIFF_IN_AVL_X12_OUT"
		   dict set retval DB_PROC_ENUM               "DB_PIN_PROC_MODE_WDB_CLK"
		 
      } elseif {$db_pin_type_enum == "DB_PIN_TYPE_WCLK_N"} {
         dict set retval C2L_DRIVEN                 false
         dict set retval DATA_IN_MODE               "PIN_DATA_IN_MODE_DIFF_IN_AVL_X12_OUT"
		   dict set retval DB_PROC_ENUM               "DB_PIN_PROC_MODE_WDB_CLKB"

      } elseif {$db_pin_type_enum == "DB_PIN_TYPE_RCLK" || $db_pin_type_enum == "DB_PIN_TYPE_RCLK_N"} {
         dict set retval C2L_DRIVEN                 false
         dict set retval DATA_IN_MODE               "PIN_DATA_IN_MODE_DIFF_IN_AVL_X12_OUT"
		   dict set retval DB_PROC_ENUM               "DB_PIN_PROC_MODE_WDB_DQS"
		 
      } else {
         emif_ie "Unsupported db_pin_type_enum $db_pin_type_enum for HMC"
      }

   } else {
      if {$db_pin_type_enum == "DB_PIN_TYPE_AC" || $db_pin_type_enum == "DB_PIN_TYPE_ALERT_N"} {
         dict set retval C2L_DRIVEN                 true
         dict set retval DATA_IN_MODE               "PIN_DATA_IN_MODE_SSTL_IN"	
		   dict set retval DB_PROC_ENUM               "DB_PIN_PROC_MODE_AC_CORE"

         if {$db_pin_type_enum == "DB_PIN_TYPE_ALERT_N"} {
            dict set retval DB_PROC_ENUM            "DB_PIN_PROC_MODE_GPIO"
         }

      } elseif {$db_pin_type_enum == "DB_PIN_TYPE_DM"} {
         dict set retval C2L_DRIVEN                 true
         dict set retval DATA_IN_MODE               "PIN_DATA_IN_MODE_SSTL_IN"
		   dict set retval DB_PROC_ENUM               "DB_PIN_PROC_MODE_DM"
		 
      } elseif {$db_pin_type_enum == "DB_PIN_TYPE_DQ"  || $db_pin_type_enum == "DB_PIN_TYPE_Q"} {
         dict set retval C2L_DRIVEN                 true
         dict set retval DATA_IN_MODE               "PIN_DATA_IN_MODE_SSTL_IN"
		   dict set retval DB_PROC_ENUM               "DB_PIN_PROC_MODE_DQ"
		 
         if {$db_pin_type_enum == "DB_PIN_TYPE_Q"} {
            dict set retval DB_PROC_ENUM            "DB_PIN_PROC_MODE_RDQ"
         }

      } elseif {$db_pin_type_enum == "DB_PIN_TYPE_DQ_WITH_DBI_CRC"} {
         dict set retval C2L_DRIVEN                 true
         dict set retval DATA_IN_MODE               "PIN_DATA_IN_MODE_SSTL_IN"
		   dict set retval DB_PROC_ENUM               "DB_PIN_PROC_MODE_DBI"

      } elseif {$db_pin_type_enum == "DB_PIN_TYPE_DQS"} {
         dict set retval C2L_DRIVEN                 true
         dict set retval DATA_IN_MODE               "PIN_DATA_IN_MODE_DIFF_IN_AVL_X12_OUT"
		   dict set retval DB_PROC_ENUM               "DB_PIN_PROC_MODE_DQS"

      } elseif {$db_pin_type_enum == "DB_PIN_TYPE_DQS_N"} {
         dict set retval C2L_DRIVEN                 true
         dict set retval DATA_IN_MODE               "PIN_DATA_IN_MODE_DIFF_IN_AVL_X12_OUT"
		   dict set retval DB_PROC_ENUM               "DB_PIN_PROC_MODE_DQSB"

      } elseif {$db_pin_type_enum == "DB_PIN_TYPE_DDR4_DQS"} {
         dict set retval C2L_DRIVEN                 true
         dict set retval DATA_IN_MODE               "PIN_DATA_IN_MODE_DIFF_IN_AVL_X12_OUT"
		   dict set retval DB_PROC_ENUM               "DB_PIN_PROC_MODE_DQS_DDR4"

      } elseif {$db_pin_type_enum == "DB_PIN_TYPE_DDR4_DQS_N"} {
         dict set retval C2L_DRIVEN                 true
         dict set retval DATA_IN_MODE               "PIN_DATA_IN_MODE_DIFF_IN_AVL_X12_OUT"
		   dict set retval DB_PROC_ENUM               "DB_PIN_PROC_MODE_DQSB_DDR4"

      } elseif {$db_pin_type_enum == "DB_PIN_TYPE_CK_N" || $db_pin_type_enum == "DB_PIN_TYPE_WCLK"} {
         dict set retval C2L_DRIVEN                 true
         dict set retval DATA_IN_MODE               "PIN_DATA_IN_MODE_DIFF_IN_AVL_X12_OUT"
		   dict set retval DB_PROC_ENUM               "DB_PIN_PROC_MODE_CLKB"

      } elseif {$db_pin_type_enum == "DB_PIN_TYPE_CK" || $db_pin_type_enum == "DB_PIN_TYPE_WCLK_N"} {
         dict set retval C2L_DRIVEN                 true
         dict set retval DATA_IN_MODE               "PIN_DATA_IN_MODE_DIFF_IN_AVL_X12_OUT"
		   dict set retval DB_PROC_ENUM               "DB_PIN_PROC_MODE_CLK"

      } elseif {$db_pin_type_enum == "DB_PIN_TYPE_RCLK" || $db_pin_type_enum == "DB_PIN_TYPE_RCLK_N"} {
         dict set retval C2L_DRIVEN                 false
         dict set retval DATA_IN_MODE               "PIN_DATA_IN_MODE_DIFF_IN_AVL_X12_OUT"
		   dict set retval DB_PROC_ENUM               "DB_PIN_PROC_MODE_RDQS"

      } else {
         emif_ie "Unsupported db_pin_type_enum $db_pin_type_enum for SMC"
      }
   }

   return $retval
}

proc ::altera_emif::ip_arch_nd::util::get_sim_params_hex_filename {top_level} {
   return "${top_level}_[enum_data SEQ_FILE_PARAMS_SIM_HEX FILENAME]"
}

proc ::altera_emif::ip_arch_nd::util::get_synth_params_hex_filename {top_level} {
   return "${top_level}_[enum_data SEQ_FILE_PARAMS_SYNTH_HEX FILENAME]"
}

proc ::altera_emif::ip_arch_nd::util::get_sim_cal_code_hex_filename {top_level} {
   return "${top_level}_[enum_data SEQ_FILE_CODE_HARD_RAM_SIM_HEX FILENAME]"
}


proc ::altera_emif::ip_arch_nd::util::get_synth_cal_code_hex_filename {top_level} {
   if {[get_parameter_value "DIAG_ENABLE_JTAG_UART_HEX"]} {
      set retval "${top_level}_[enum_data SEQ_FILE_CODE_HARD_RAM_UART_SYNTH_HEX FILENAME]"
   } else {
      set retval "${top_level}_[enum_data SEQ_FILE_CODE_HARD_RAM_SYNTH_HEX FILENAME]"
   }
   return $retval
}

proc ::altera_emif::ip_arch_nd::util::get_sim_cal_code_fw_filename {top_level} {
   return "${top_level}_[enum_data SEQ_FILE_CODE_HARD_RAM_SIM_FW FILENAME]"
}


proc ::altera_emif::ip_arch_nd::util::get_synth_cal_code_fw_filename {top_level} {
   if {[get_parameter_value "DIAG_ENABLE_JTAG_UART_HEX"]} {
      set retval "${top_level}_[enum_data SEQ_FILE_CODE_HARD_RAM_UART_SYNTH_FW FILENAME]"
   } else {
      set retval "${top_level}_[enum_data SEQ_FILE_CODE_HARD_RAM_SYNTH_FW FILENAME]"
   }
   return $retval
}

proc ::altera_emif::ip_arch_nd::util::get_sim_cal_code_hex_src_filename {force_firmware} {
   if {$force_firmware != ""} {
      set retval "src/${force_firmware}.hex"
   } else {
      set retval "src/iossm.hex"
   }
   return $retval
}

proc ::altera_emif::ip_arch_nd::util::get_synth_cal_code_hex_src_filename {force_firmware} {
   if {$force_firmware != ""} {
      set retval "src/${force_firmware}.hex"
   } else {
      if {[get_parameter_value "DIAG_ENABLE_JTAG_UART_HEX"]} {
         set retval "src/iossm_uart.hex"
      } else {
         set retval "src/iossm.hex"
      }
   }
   return $retval
}

proc ::altera_emif::ip_arch_nd::util::get_sim_cal_code_fw_src_filename {force_firmware} {
   if {$force_firmware != ""} {
      set retval "src/${force_firmware}.fw"
   } else {
      set retval "src/iossm.fw"
   }
   return $retval
}

proc ::altera_emif::ip_arch_nd::util::get_synth_cal_code_fw_src_filename {force_firmware} {
   if {$force_firmware != ""} {
      set retval "src/${force_firmware}.fw"
   } else {
      if {[get_parameter_value "DIAG_ENABLE_JTAG_UART_HEX"]} {
         set retval "src/iossm_uart.fw"
      } else {
         set retval "src/iossm.fw"
      }
   }
   return $retval
}

proc ::altera_emif::ip_arch_nd::util::get_emif_export_src_filename {} {
   set retval "src/[enum_data SEQ_EXPORT_FILE_EMIF_EXPORT FILENAME].c"

   return $retval
}

proc ::altera_emif::ip_arch_nd::util::get_die_string {} {
   set device [get_device]
   
   set retval "14nm5"
   
   return $retval
}

proc ::altera_emif::ip_arch_nd::util::get_wysiwyg_silicon_rev_string {} {
   set die [get_die_string]

   if {[get_is_es]} {
      set retval "${die}es"
   } elseif {[get_is_es2]} {
      set retval "${die}es2"
   } else {
      set retval $die
   }
   return $retval
}

proc ::altera_emif::ip_arch_nd::util::get_cal_config_silicon_rev {} {
   set retval [enum_data SEQ_SILICON_REV_ND5_R4_5 VALUE]
   return $retval
}

proc ::altera_emif::ip_arch_nd::util::get_starting_vrefin_settings {vref_pct} {
   set range_1_left  [expr {abs($vref_pct - 60.0)}]
   set range_1_right [expr {abs(92.5 - $vref_pct)}]
   set range_1_max   [expr {max($range_1_left, $range_1_right)}]
   
   set range_2_left  [expr {abs($vref_pct - 45.0)}]
   set range_2_right [expr {abs(77.5 - $vref_pct)}]
   set range_2_max   [expr {max($range_2_left, $range_2_right)}]
   
   if {$range_1_max < $range_2_max} {
      set vref_range "VREF_MODE_CALIBRATED"
      set vref_val [expr {int(($vref_pct - 60.0) / 0.65)}]
   } else {
      set vref_range "VREF_MODE_CALIBRATED_RANGE_2"
      set vref_val [expr {int(($vref_pct - 45.0) / 0.65)}]
   }
   
   return [dict create RANGE_ENUM $vref_range VAL $vref_val]
}

proc ::altera_emif::ip_arch_nd::util::_init {} {
}

::altera_emif::ip_arch_nd::util::_init
