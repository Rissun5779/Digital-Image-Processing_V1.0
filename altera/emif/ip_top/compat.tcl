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


package provide altera_emif::ip_top::compat 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_top::compat:: {

   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*

}


proc ::altera_emif::ip_top::compat::upgrade_callback {kind version param_map} {

   if {$version == 13.1} {
      _upgrade_from_13_1 $kind $version $param_map
   } elseif {$version < 15.1} {
      _upgrade_from_pre_15_1 $kind $version $param_map
   } elseif {$version < 16.0} {
      _upgrade_from_pre_16_0 $kind $version $param_map
   } elseif {$version < 16.1} {
      _upgrade_from_pre_16_1 $kind $version $param_map
   } else {
      set all_params [get_parameters]
      foreach {param_name param_val} $param_map {
         if {[lsearch -exact $all_params $param_name] != -1} {
            set_parameter_value $param_name $param_val
         } else {
            post_ipgen_w_msg MSG_COMPAT_IP_NO_UPGRADE_IGNORED_PARAM [list $param_name $param_val]
         }
      }
   }
}


proc ::altera_emif::ip_top::compat::_upgrade_from_13_1 {kind version param_map} {

   set issue_new_io_scheme_warning 0

   send_message INFO "Upgrading $kind from $version"

   foreach {param_name param_val} $param_map {
      set param_name [string map {PKG+BRD PKG_BRD} $param_name]

      if {$param_name == "PHY_DDR3_IO_STD_ENUM"} {
         if {$param_val == "IO_STD_SSTL_135"} {
            set_parameter_value "PHY_DDR3_IO_VOLTAGE" 1.35
         } elseif {$param_val != "IO_STD_SSTL_15"} {
            set issue_new_io_scheme_warning 1
         }

      } elseif {$param_name == "PHY_DDR4_IO_STD_ENUM" || $param_name == "PHY_DDR4_DQ_IO_STD_ENUM"} {

      } elseif {$param_name == "PHY_DDR4_DEFAULT_OCT" || $param_name == "PHY_DDR3_DEFAULT_OCT"} {
         if {!$param_val} {
            set issue_new_io_scheme_warning 1
         }
      } elseif {$param_name == "PHY_DDR4_USER_IN_OCT" || $param_name == "PHY_DDR4_USER_OUT_OCT" || \
                $param_name == "PHY_DDR3_USER_IN_OCT" || $param_name == "PHY_DDR3_USER_OUT_OCT"} {

      } elseif {$param_name == "BOARD_DDR3_SKEW_CKDQS_MIN_NS" || $param_name == "BOARD_DDR3_SKEW_CKDQS_MAX_NS"} {
         post_ipgen_w_msg MSG_COMPAT_PARAM_REPLACED_PARAMATER [list $param_name "BOARD_DDR3_DQS_TO_CK_SKEW_N"]

      } elseif {$param_name == "BOARD_DDR4_SKEW_CKDQS_MIN_NS" || $param_name == "BOARD_DDR4_SKEW_CKDQS_MAX_NS"} {
         post_ipgen_w_msg MSG_COMPAT_PARAM_REPLACED_PARAMATER [list $param_name "BOARD_DDR4_DQS_TO_CK_SKEW_N"]

      } else {
         set_parameter_value $param_name $param_val
      }
   }

   if {$issue_new_io_scheme_warning} {
      post_ipgen_w_msg MSG_COMPAT_FROM_13_1_NEW_IO_SCHEME
   }
}

proc ::altera_emif::ip_top::compat::_upgrade_from_pre_15_1 {kind version param_map} {

   send_message INFO "Upgrading $kind from $version"
   set all_params [get_parameters]

   foreach {param_name param_val} $param_map {
      set param_name [string map {PKG+BRD PKG_BRD} $param_name]

      if {$param_name == "MEM_DDR4_TDIVW_DJ_CYC"} {
         post_ipgen_w_msg MSG_COMPAT_PARAM_REPLACED_PARAMATER [list "MEM_DDR4_TDIVW_DJ_CYC" "MEM_DDR4_TDIVW_TOTAL_UI"]
      } elseif {$param_name == "MEM_DDR4_TQH_CYC"} {
         post_ipgen_w_msg MSG_COMPAT_PARAM_REPLACED_PARAMATER [list "MEM_DDR4_TQH_CYC" "MEM_DDR4_TQH_UI"]
      } elseif {$param_name == "MEM_DDR4_TDQSQ_PS"} {
         post_ipgen_w_msg MSG_COMPAT_PARAM_REPLACED_PARAMATER [list "MEM_DDR4_TDQSQ_PS" "MEM_DDR4_TDQSQ_UI"]
      } else {
         if {[lsearch -exact $all_params $param_name] != -1} {
            set_parameter_value $param_name $param_val
         } else {
            post_ipgen_w_msg MSG_COMPAT_IP_NO_UPGRADE_IGNORED_PARAM [list $param_name $param_val]
         }
      }
   }

   if {[dict exists $param_map "DIAG_ENABLE_JTAG_UART"] && [dict get $param_map "DIAG_ENABLE_JTAG_UART"] == "true"} {
      set_parameter_value "DIAG_ENABLE_JTAG_UART" false
      post_ipgen_w_msg MSG_COMPAT_HPS_JTAG_UART_NOT_SUPPORTED
   }

}

proc ::altera_emif::ip_top::compat::_upgrade_from_pre_16_0 {kind version param_map} {

   send_message INFO "Upgrading $kind from $version"
   set all_params [get_parameters]

   foreach {param_name param_val} $param_map {
      if {$param_name == "DIAG_TG_AVL_2_NUM_CFG_INTERFACES"} {
         post_ipgen_w_msg MSG_COMPAT_PARAM_REPLACED_PARAMATER [list "DIAG_TG_AVL_2_NUM_CFG_INTERFACES" "DIAG_TG_AVL_2_EXPORT_CFG_INTERFACE"]
         set_parameter_value "DIAG_TG_AVL_2_EXPORT_CFG_INTERFACE" $param_val
      } else {
         if {[lsearch -exact $all_params $param_name] != -1} {
            set_parameter_value $param_name $param_val
         } else {
            post_ipgen_w_msg MSG_COMPAT_IP_NO_UPGRADE_IGNORED_PARAM [list $param_name $param_val]
         }
      }
   }
}

proc ::altera_emif::ip_top::compat::_upgrade_from_pre_16_1 {kind version param_map} {

   send_message INFO "Upgrading $kind from $version"
   set all_params [get_parameters]

   foreach {param_name param_val} $param_map {
      if {$param_name == "MEM_DDR4_RDIMM_CONFIG"} {
         if {![regexp -lineanchor {^0+$} $param_val]} {
            post_ipgen_w_msg MSG_DDR4_RDIMM_CONFIG_DEPRECATED
         }
      } elseif {$param_name == "MEM_DDR4_LRDIMM_EXTENDED_CONFIG"} {
         if {![regexp -lineanchor {^0+$} $param_val]} {
            post_ipgen_w_msg MSG_DDR4_LRDIMM_EXTENDED_CONFIG_DEPRECATED
         }
      } else {
         if {[lsearch -exact $all_params $param_name] != -1} {
            set_parameter_value $param_name $param_val
         } else {
            post_ipgen_w_msg MSG_COMPAT_IP_NO_UPGRADE_IGNORED_PARAM [list $param_name $param_val]
         }
      }
   }
}

proc ::altera_emif::ip_top::compat::_init {} {
}

::altera_emif::ip_top::compat::_init
