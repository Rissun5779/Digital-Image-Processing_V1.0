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



proc ::nf_hip::parameters::validate_acknack_base { PROP_M_AUTOSET PROP_M_AUTOWARN acknack_base sup_mode } {

   set legal_values [list 0:8191]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.acknack_base.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message acknack_base $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message acknack_base $legal_values
      }
   } else {
      auto_value_out_of_range_message auto acknack_base $acknack_base $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_acknack_set { PROP_M_AUTOSET PROP_M_AUTOWARN acknack_set sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.acknack_set.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message acknack_set $legal_values
      }
   } else {
      auto_invalid_value_message auto acknack_set $acknack_set $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_advance_error_reporting { PROP_M_AUTOSET PROP_M_AUTOWARN advance_error_reporting func_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable" "enable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.advance_error_reporting.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message advance_error_reporting $legal_values
      }
   } else {
      auto_invalid_value_message auto advance_error_reporting $advance_error_reporting $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_app_interface_width { PROP_M_AUTOSET PROP_M_AUTOWARN app_interface_width func_mode lane_rate link_width } {

   set legal_values [list "avst_128bit" "avst_256bit" "avst_64bit"]

   if [expr { ($func_mode=="enable") }] {
      if [expr { ($link_width=="x1") }] {
         set legal_values [intersect $legal_values [list "avst_64bit"]]
      }
      if [expr { (($link_width=="x2")&&($lane_rate=="gen1")) }] {
         set legal_values [intersect $legal_values [list "avst_64bit"]]
      }
      if [expr { (($link_width=="x2")&&($lane_rate=="gen2")) }] {
         set legal_values [intersect $legal_values [list "avst_64bit"]]
      }
      if [expr { (($link_width=="x2")&&($lane_rate=="gen3")) }] {
         set legal_values [intersect $legal_values [list "avst_64bit" "avst_128bit"]]
      }
      if [expr { (($link_width=="x4")&&($lane_rate=="gen1")) }] {
         set legal_values [intersect $legal_values [list "avst_64bit"]]
      }
      if [expr { (($link_width=="x4")&&($lane_rate=="gen2")) }] {
         set legal_values [intersect $legal_values [list "avst_64bit" "avst_128bit"]]
      }
      if [expr { (($link_width=="x4")&&($lane_rate=="gen3")) }] {
         set legal_values [intersect $legal_values [list "avst_128bit" "avst_256bit"]]
      }
      if [expr { (($link_width=="x8")&&($lane_rate=="gen1")) }] {
         set legal_values [intersect $legal_values [list "avst_64bit" "avst_128bit"]]
      }
      if [expr { (($link_width=="x8")&&($lane_rate=="gen2")) }] {
         set legal_values [intersect $legal_values [list "avst_128bit" "avst_256bit"]]
      }
      if [expr { (($link_width=="x8")&&($lane_rate=="gen3")) }] {
         set legal_values [intersect $legal_values [list "avst_256bit"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "avst_64bit"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.app_interface_width.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message app_interface_width $legal_values
      }
   } else {
      auto_invalid_value_message auto app_interface_width $app_interface_width $legal_values { func_mode lane_rate link_width }
   }
}

proc ::nf_hip::parameters::validate_arb_upfc_30us_counter { PROP_M_AUTOSET PROP_M_AUTOWARN arb_upfc_30us_counter sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.arb_upfc_30us_counter.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message arb_upfc_30us_counter $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message arb_upfc_30us_counter $legal_values
      }
   } else {
      auto_value_out_of_range_message auto arb_upfc_30us_counter $arb_upfc_30us_counter $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_arb_upfc_30us_en { PROP_M_AUTOSET PROP_M_AUTOWARN arb_upfc_30us_en sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.arb_upfc_30us_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message arb_upfc_30us_en $legal_values
      }
   } else {
      auto_invalid_value_message auto arb_upfc_30us_en $arb_upfc_30us_en $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_aspm_config_management { PROP_M_AUTOSET PROP_M_AUTOWARN aspm_config_management sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "true"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.aspm_config_management.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message aspm_config_management $legal_values
      }
   } else {
      auto_invalid_value_message auto aspm_config_management $aspm_config_management $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_aspm_patch_disable { PROP_M_AUTOSET PROP_M_AUTOWARN aspm_patch_disable sup_mode } {

   set legal_values [list "disable_both" "disable_low_pwr" "disable_pex_quiet" "enable_both"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "enable_both"]]
   } else {
      set legal_values [intersect $legal_values [list "enable_both" "disable_low_pwr" "disable_pex_quiet" "disable_both"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.aspm_patch_disable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message aspm_patch_disable $legal_values
      }
   } else {
      auto_invalid_value_message auto aspm_patch_disable $aspm_patch_disable $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_ast_width_rx { PROP_M_AUTOSET PROP_M_AUTOWARN ast_width_rx app_interface_width } {

   set legal_values [list "reserved" "rx_128" "rx_256" "rx_64"]

   if [expr { ($app_interface_width=="avst_64bit") }] {
      set legal_values [intersect $legal_values [list "rx_64"]]
   }
   if [expr { ($app_interface_width=="avst_128bit") }] {
      set legal_values [intersect $legal_values [list "rx_128"]]
   }
   if [expr { ($app_interface_width=="avst_256bit") }] {
      set legal_values [intersect $legal_values [list "rx_256"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.ast_width_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message ast_width_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto ast_width_rx $ast_width_rx $legal_values { app_interface_width }
   }
}

proc ::nf_hip::parameters::validate_ast_width_tx { PROP_M_AUTOSET PROP_M_AUTOWARN ast_width_tx app_interface_width } {

   set legal_values [list "tx_128" "tx_256" "tx_64"]

   if [expr { ($app_interface_width=="avst_64bit") }] {
      set legal_values [intersect $legal_values [list "tx_64"]]
   }
   if [expr { ($app_interface_width=="avst_128bit") }] {
      set legal_values [intersect $legal_values [list "tx_128"]]
   }
   if [expr { ($app_interface_width=="avst_256bit") }] {
      set legal_values [intersect $legal_values [list "tx_256"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.ast_width_tx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message ast_width_tx $legal_values
      }
   } else {
      auto_invalid_value_message auto ast_width_tx $ast_width_tx $legal_values { app_interface_width }
   }
}

proc ::nf_hip::parameters::validate_atomic_malformed { PROP_M_AUTOSET PROP_M_AUTOWARN atomic_malformed sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atomic_malformed.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atomic_malformed $legal_values
      }
   } else {
      auto_invalid_value_message auto atomic_malformed $atomic_malformed $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_atomic_op_completer_32bit { PROP_M_AUTOSET PROP_M_AUTOWARN atomic_op_completer_32bit sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atomic_op_completer_32bit.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atomic_op_completer_32bit $legal_values
      }
   } else {
      auto_invalid_value_message auto atomic_op_completer_32bit $atomic_op_completer_32bit $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_atomic_op_completer_64bit { PROP_M_AUTOSET PROP_M_AUTOWARN atomic_op_completer_64bit sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atomic_op_completer_64bit.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atomic_op_completer_64bit $legal_values
      }
   } else {
      auto_invalid_value_message auto atomic_op_completer_64bit $atomic_op_completer_64bit $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_atomic_op_routing { PROP_M_AUTOSET PROP_M_AUTOWARN atomic_op_routing sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atomic_op_routing.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atomic_op_routing $legal_values
      }
   } else {
      auto_invalid_value_message auto atomic_op_routing $atomic_op_routing $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_auto_msg_drop_enable { PROP_M_AUTOSET PROP_M_AUTOWARN auto_msg_drop_enable sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.auto_msg_drop_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message auto_msg_drop_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto auto_msg_drop_enable $auto_msg_drop_enable $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_avmm_cvp_inter_sel_csr_ctrl { PROP_M_AUTOSET PROP_M_AUTOWARN avmm_cvp_inter_sel_csr_ctrl sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.avmm_cvp_inter_sel_csr_ctrl.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message avmm_cvp_inter_sel_csr_ctrl $legal_values
      }
   } else {
      auto_invalid_value_message auto avmm_cvp_inter_sel_csr_ctrl $avmm_cvp_inter_sel_csr_ctrl $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_avmm_dprio_broadcast_en_csr_ctrl { PROP_M_AUTOSET PROP_M_AUTOWARN avmm_dprio_broadcast_en_csr_ctrl sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.avmm_dprio_broadcast_en_csr_ctrl.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message avmm_dprio_broadcast_en_csr_ctrl $legal_values
      }
   } else {
      auto_invalid_value_message auto avmm_dprio_broadcast_en_csr_ctrl $avmm_dprio_broadcast_en_csr_ctrl $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_avmm_force_inter_sel_csr_ctrl { PROP_M_AUTOSET PROP_M_AUTOWARN avmm_force_inter_sel_csr_ctrl sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.avmm_force_inter_sel_csr_ctrl.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message avmm_force_inter_sel_csr_ctrl $legal_values
      }
   } else {
      auto_invalid_value_message auto avmm_force_inter_sel_csr_ctrl $avmm_force_inter_sel_csr_ctrl $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_avmm_power_iso_en_csr_ctrl { PROP_M_AUTOSET PROP_M_AUTOWARN avmm_power_iso_en_csr_ctrl sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.avmm_power_iso_en_csr_ctrl.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message avmm_power_iso_en_csr_ctrl $legal_values
      }
   } else {
      auto_invalid_value_message auto avmm_power_iso_en_csr_ctrl $avmm_power_iso_en_csr_ctrl $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_bar0_size_mask { PROP_M_AUTOSET PROP_M_AUTOWARN bar0_size_mask func_mode } {

   set legal_values [list 0:268435455]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.bar0_size_mask.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message bar0_size_mask $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message bar0_size_mask $legal_values
      }
   } else {
      auto_value_out_of_range_message auto bar0_size_mask $bar0_size_mask $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_bar0_type { PROP_M_AUTOSET PROP_M_AUTOWARN bar0_type func_mode port_type } {

   set legal_values [list "bar0_32bit_non_prefetch_mem" "bar0_32bit_prefetch_mem" "bar0_64bit_prefetch_mem" "bar0_disable" "bar0_io_addr_space"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "bar0_disable"]]
   }
   if [expr { ($port_type=="native_ep") }] {
      set legal_values [exclude $legal_values [list "bar0_32bit_prefetch_mem"]]
      set legal_values [exclude $legal_values [list "bar0_io_addr_space"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.bar0_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message bar0_type $legal_values
      }
   } else {
      auto_invalid_value_message auto bar0_type $bar0_type $legal_values { func_mode port_type }
   }
}

proc ::nf_hip::parameters::validate_bar1_size_mask { PROP_M_AUTOSET PROP_M_AUTOWARN bar1_size_mask func_mode } {

   set legal_values [list 0:268435455]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.bar1_size_mask.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message bar1_size_mask $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message bar1_size_mask $legal_values
      }
   } else {
      auto_value_out_of_range_message auto bar1_size_mask $bar1_size_mask $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_bar1_type { PROP_M_AUTOSET PROP_M_AUTOWARN bar1_type bar0_type func_mode port_type } {

   set legal_values [list "bar1_32bit_non_prefetch_mem" "bar1_32bit_prefetch_mem" "bar1_64_1_one" "bar1_64_2_one" "bar1_64_3_one" "bar1_64_all_one" "bar1_disable" "bar1_io_addr_space"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "bar1_disable"]]
   }
   if [expr { ((($port_type=="native_ep")||($port_type=="legacy_ep"))&&($bar0_type=="bar0_64bit_prefetch_mem")) }] {
      set legal_values [intersect $legal_values [list "bar1_disable" "bar1_64_1_one" "bar1_64_2_one" "bar1_64_3_one" "bar1_64_all_one"]]
   }
   if [expr { ($port_type=="native_ep") }] {
      set legal_values [exclude $legal_values [list "bar1_32bit_prefetch_mem"]]
      set legal_values [exclude $legal_values [list "bar1_io_addr_space"]]
   }
   if [expr { ($port_type=="root_port") }] {
      if [expr { ($bar0_type=="bar0_64bit_prefetch_mem") }] {
         set legal_values [intersect $legal_values [list "bar1_disable" "bar1_64_1_one" "bar1_64_2_one" "bar1_64_3_one" "bar1_64_all_one"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.bar1_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message bar1_type $legal_values
      }
   } else {
      auto_invalid_value_message auto bar1_type $bar1_type $legal_values { bar0_type func_mode port_type }
   }
}

proc ::nf_hip::parameters::validate_bar2_size_mask { PROP_M_AUTOSET PROP_M_AUTOWARN bar2_size_mask func_mode } {

   set legal_values [list 0:268435455]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.bar2_size_mask.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message bar2_size_mask $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message bar2_size_mask $legal_values
      }
   } else {
      auto_value_out_of_range_message auto bar2_size_mask $bar2_size_mask $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_bar2_type { PROP_M_AUTOSET PROP_M_AUTOWARN bar2_type func_mode port_type } {

   set legal_values [list "bar2_32bit_non_prefetch_mem" "bar2_32bit_prefetch_mem" "bar2_64bit_prefetch_mem" "bar2_disable" "bar2_io_addr_space"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "bar2_disable"]]
   }
   if [expr { ($port_type=="native_ep") }] {
      set legal_values [exclude $legal_values [list "bar2_32bit_prefetch_mem"]]
      set legal_values [exclude $legal_values [list "bar2_io_addr_space"]]
   }
   if [expr { ($port_type=="root_port") }] {
      set legal_values [intersect $legal_values [list "bar2_disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.bar2_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message bar2_type $legal_values
      }
   } else {
      auto_invalid_value_message auto bar2_type $bar2_type $legal_values { func_mode port_type }
   }
}

proc ::nf_hip::parameters::validate_bar3_size_mask { PROP_M_AUTOSET PROP_M_AUTOWARN bar3_size_mask func_mode } {

   set legal_values [list 0:268435455]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.bar3_size_mask.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message bar3_size_mask $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message bar3_size_mask $legal_values
      }
   } else {
      auto_value_out_of_range_message auto bar3_size_mask $bar3_size_mask $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_bar3_type { PROP_M_AUTOSET PROP_M_AUTOWARN bar3_type bar2_type func_mode port_type } {

   set legal_values [list "bar3_32bit_non_prefetch_mem" "bar3_32bit_prefetch_mem" "bar3_64_1_one" "bar3_64_2_one" "bar3_64_3_one" "bar3_64_all_one" "bar3_disable" "bar3_io_addr_space"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "bar3_disable"]]
   }
   if [expr { ((($port_type=="native_ep")||($port_type=="legacy_ep"))&&($bar2_type=="bar2_64bit_prefetch_mem")) }] {
      set legal_values [intersect $legal_values [list "bar3_disable" "bar3_64_1_one" "bar3_64_2_one" "bar3_64_3_one" "bar3_64_all_one"]]
   }
   if [expr { ($port_type=="native_ep") }] {
      set legal_values [exclude $legal_values [list "bar3_32bit_prefetch_mem"]]
      set legal_values [exclude $legal_values [list "bar3_io_addr_space"]]
   }
   if [expr { ($port_type=="root_port") }] {
      set legal_values [intersect $legal_values [list "bar3_disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.bar3_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message bar3_type $legal_values
      }
   } else {
      auto_invalid_value_message auto bar3_type $bar3_type $legal_values { bar2_type func_mode port_type }
   }
}

proc ::nf_hip::parameters::validate_bar4_size_mask { PROP_M_AUTOSET PROP_M_AUTOWARN bar4_size_mask func_mode } {

   set legal_values [list 0:268435455]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.bar4_size_mask.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message bar4_size_mask $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message bar4_size_mask $legal_values
      }
   } else {
      auto_value_out_of_range_message auto bar4_size_mask $bar4_size_mask $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_bar4_type { PROP_M_AUTOSET PROP_M_AUTOWARN bar4_type func_mode port_type } {

   set legal_values [list "bar4_32bit_non_prefetch_mem" "bar4_32bit_prefetch_mem" "bar4_64bit_prefetch_mem" "bar4_disable" "bar4_io_addr_space"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "bar4_disable"]]
   }
   if [expr { ($port_type=="native_ep") }] {
      set legal_values [exclude $legal_values [list "bar4_32bit_prefetch_mem"]]
      set legal_values [exclude $legal_values [list "bar4_io_addr_space"]]
   }
   if [expr { ($port_type=="root_port") }] {
      set legal_values [intersect $legal_values [list "bar4_disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.bar4_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message bar4_type $legal_values
      }
   } else {
      auto_invalid_value_message auto bar4_type $bar4_type $legal_values { func_mode port_type }
   }
}

proc ::nf_hip::parameters::validate_bar5_size_mask { PROP_M_AUTOSET PROP_M_AUTOWARN bar5_size_mask func_mode } {

   set legal_values [list 0:268435455]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.bar5_size_mask.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message bar5_size_mask $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message bar5_size_mask $legal_values
      }
   } else {
      auto_value_out_of_range_message auto bar5_size_mask $bar5_size_mask $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_bar5_type { PROP_M_AUTOSET PROP_M_AUTOWARN bar5_type bar4_type func_mode port_type } {

   set legal_values [list "bar5_32bit_non_prefetch_mem" "bar5_32bit_prefetch_mem" "bar5_64_1_one" "bar5_64_2_one" "bar5_64_3_one" "bar5_64_all_one" "bar5_disable" "bar5_io_addr_space"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "bar5_disable"]]
   }
   if [expr { ((($port_type=="native_ep")||($port_type=="legacy_ep"))&&($bar4_type=="bar4_64bit_prefetch_mem")) }] {
      set legal_values [intersect $legal_values [list "bar5_disable" "bar5_64_1_one" "bar5_64_2_one" "bar5_64_3_one" "bar5_64_all_one"]]
   }
   if [expr { ($port_type=="native_ep") }] {
      set legal_values [exclude $legal_values [list "bar5_32bit_prefetch_mem"]]
      set legal_values [exclude $legal_values [list "bar5_io_addr_space"]]
   }
   if [expr { ($port_type=="root_port") }] {
      set legal_values [intersect $legal_values [list "bar5_disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.bar5_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message bar5_type $legal_values
      }
   } else {
      auto_invalid_value_message auto bar5_type $bar5_type $legal_values { bar4_type func_mode port_type }
   }
}

proc ::nf_hip::parameters::validate_base_counter_sel { PROP_M_AUTOSET PROP_M_AUTOWARN base_counter_sel func_mode sup_mode } {

   set legal_values [list "count_clk_31p25" "count_clk_62p5"]

   if [expr { ($func_mode=="enable") }] {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "count_clk_62p5"]]
      } else {
         set legal_values [intersect $legal_values [list "count_clk_62p5" "count_clk_31p25"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "count_clk_62p5"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.base_counter_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message base_counter_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto base_counter_sel $base_counter_sel $legal_values { func_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_bist_memory_settings { PROP_M_AUTOSET PROP_M_AUTOWARN bist_memory_settings sup_mode } {

   set legal_values [list 0:19342813113834066795298815]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 2417851639246850506078208]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.bist_memory_settings.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message bist_memory_settings $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message bist_memory_settings $legal_values
      }
   } else {
      auto_value_out_of_range_message auto bist_memory_settings $bist_memory_settings $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_bridge_port_ssid_support { PROP_M_AUTOSET PROP_M_AUTOWARN bridge_port_ssid_support sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.bridge_port_ssid_support.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message bridge_port_ssid_support $legal_values
      }
   } else {
      auto_invalid_value_message auto bridge_port_ssid_support $bridge_port_ssid_support $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_bridge_port_vga_enable { PROP_M_AUTOSET PROP_M_AUTOWARN bridge_port_vga_enable sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.bridge_port_vga_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message bridge_port_vga_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto bridge_port_vga_enable $bridge_port_vga_enable $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_bypass_cdc { PROP_M_AUTOSET PROP_M_AUTOWARN bypass_cdc } {

   set legal_values [list "false" "true"]

   set legal_values [intersect $legal_values [list "false"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.bypass_cdc.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message bypass_cdc $legal_values
      }
   } else {
      auto_invalid_value_message auto bypass_cdc $bypass_cdc $legal_values { }
   }
}

proc ::nf_hip::parameters::validate_bypass_clk_switch { PROP_M_AUTOSET PROP_M_AUTOWARN bypass_clk_switch cvp_enable func_mode sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($func_mode=="enable") }] {
      if [expr { ($sup_mode=="user_mode") }] {
         if [expr { ($cvp_enable=="cvp_en") }] {
            set legal_values [intersect $legal_values [list "false"]]
         } else {
            if [expr { ($cvp_enable=="cvp_dis") }] {
               set legal_values [intersect $legal_values [list "true" "false"]]
            }
         }
      } else {
         if [expr { ($cvp_enable=="cvp_en") }] {
            set legal_values [intersect $legal_values [list "false"]]
         } else {
            if [expr { ($cvp_enable=="cvp_dis") }] {
               set legal_values [intersect $legal_values [list "true" "false"]]
            }
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "true"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.bypass_clk_switch.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message bypass_clk_switch $legal_values
      }
   } else {
      auto_invalid_value_message auto bypass_clk_switch $bypass_clk_switch $legal_values { cvp_enable func_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_bypass_tl { PROP_M_AUTOSET PROP_M_AUTOWARN bypass_tl } {

   set legal_values [list "false" "true"]

   set legal_values [intersect $legal_values [list "false"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.bypass_tl.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message bypass_tl $legal_values
      }
   } else {
      auto_invalid_value_message auto bypass_tl $bypass_tl $legal_values { }
   }
}

proc ::nf_hip::parameters::validate_capab_rate_rxcfg_en { PROP_M_AUTOSET PROP_M_AUTOWARN capab_rate_rxcfg_en sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.capab_rate_rxcfg_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message capab_rate_rxcfg_en $legal_values
      }
   } else {
      auto_invalid_value_message auto capab_rate_rxcfg_en $capab_rate_rxcfg_en $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_cas_completer_128bit { PROP_M_AUTOSET PROP_M_AUTOWARN cas_completer_128bit sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.cas_completer_128bit.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message cas_completer_128bit $legal_values
      }
   } else {
      auto_invalid_value_message auto cas_completer_128bit $cas_completer_128bit $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_cdc_clk_relation { PROP_M_AUTOSET PROP_M_AUTOWARN cdc_clk_relation sup_mode } {

   set legal_values [list "mesochronous" "plesiochronous"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "plesiochronous"]]
   } else {
      set legal_values [intersect $legal_values [list "mesochronous" "plesiochronous"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.cdc_clk_relation.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message cdc_clk_relation $legal_values
      }
   } else {
      auto_invalid_value_message auto cdc_clk_relation $cdc_clk_relation $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_cdc_dummy_insert_limit { PROP_M_AUTOSET PROP_M_AUTOWARN cdc_dummy_insert_limit sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 11]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.cdc_dummy_insert_limit.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message cdc_dummy_insert_limit $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message cdc_dummy_insert_limit $legal_values
      }
   } else {
      auto_value_out_of_range_message auto cdc_dummy_insert_limit $cdc_dummy_insert_limit $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_cfg_parchk_ena { PROP_M_AUTOSET PROP_M_AUTOWARN cfg_parchk_ena sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable" "enable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.cfg_parchk_ena.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message cfg_parchk_ena $legal_values
      }
   } else {
      auto_invalid_value_message auto cfg_parchk_ena $cfg_parchk_ena $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_cfgbp_req_recov_disable { PROP_M_AUTOSET PROP_M_AUTOWARN cfgbp_req_recov_disable sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.cfgbp_req_recov_disable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message cfgbp_req_recov_disable $legal_values
      }
   } else {
      auto_invalid_value_message auto cfgbp_req_recov_disable $cfgbp_req_recov_disable $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_class_code { PROP_M_AUTOSET PROP_M_AUTOWARN class_code func_mode } {

   set legal_values [list 0:16777215]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 16711680]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.class_code.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message class_code $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message class_code $legal_values
      }
   } else {
      auto_value_out_of_range_message auto class_code $class_code $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_clock_pwr_management { PROP_M_AUTOSET PROP_M_AUTOWARN clock_pwr_management sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.clock_pwr_management.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message clock_pwr_management $legal_values
      }
   } else {
      auto_invalid_value_message auto clock_pwr_management $clock_pwr_management $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_completion_timeout { PROP_M_AUTOSET PROP_M_AUTOWARN completion_timeout func_mode } {

   set legal_values [list "a" "ab" "abc" "abcd" "b" "bc" "bcd" "none_compl_timeout"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "abcd"]]
   } else {
      set legal_values [intersect $legal_values [list "none_compl_timeout" "a" "b" "ab" "bc" "abc" "bcd" "abcd"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.completion_timeout.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message completion_timeout $legal_values
      }
   } else {
      auto_invalid_value_message auto completion_timeout $completion_timeout $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_core_clk_divider { PROP_M_AUTOSET PROP_M_AUTOWARN core_clk_divider core_clk_freq_mhz func_mode lane_rate sup_mode } {

   set legal_values [list "div_1" "div_2" "div_4" "div_8"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "div_4"]]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         if [expr { (($core_clk_freq_mhz=="core_clk_62p5mhz")&&($lane_rate=="gen1")) }] {
            set legal_values [intersect $legal_values [list "div_2"]]
         }
         if [expr { (($core_clk_freq_mhz=="core_clk_62p5mhz")&&($lane_rate=="gen2")) }] {
            set legal_values [intersect $legal_values [list "div_2"]]
         }
         if [expr { (($core_clk_freq_mhz=="core_clk_125mhz")&&($lane_rate=="gen1")) }] {
            set legal_values [intersect $legal_values [list "div_2"]]
         }
         if [expr { (($core_clk_freq_mhz=="core_clk_250mhz")&&($lane_rate=="gen1")) }] {
            set legal_values [intersect $legal_values [list "div_2"]]
         }
         if [expr { (($core_clk_freq_mhz=="core_clk_125mhz")&&(($lane_rate=="gen2")||($lane_rate=="gen3"))) }] {
            set legal_values [intersect $legal_values [list "div_2"]]
         }
         if [expr { (($core_clk_freq_mhz=="core_clk_250mhz")&&(($lane_rate=="gen2")||($lane_rate=="gen3"))) }] {
            set legal_values [intersect $legal_values [list "div_2"]]
         }
      } else {
         set legal_values [intersect $legal_values [list "div_1" "div_2" "div_4" "div_8"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.core_clk_divider.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message core_clk_divider $legal_values
      }
   } else {
      auto_invalid_value_message auto core_clk_divider $core_clk_divider $legal_values { core_clk_freq_mhz func_mode lane_rate sup_mode }
   }
}

proc ::nf_hip::parameters::validate_core_clk_freq_mhz { PROP_M_AUTOSET PROP_M_AUTOWARN core_clk_freq_mhz app_interface_width func_mode lane_rate link_width } {

   set legal_values [list "core_clk_125mhz" "core_clk_250mhz" "core_clk_62p5mhz"]

   if [expr { ($func_mode=="enable") }] {
      if [expr { (($link_width=="x1")&&($lane_rate=="gen1")) }] {
         set legal_values [intersect $legal_values [list "core_clk_62p5mhz" "core_clk_125mhz"]]
      }
      if [expr { (($link_width=="x1")&&($lane_rate=="gen2")) }] {
         set legal_values [intersect $legal_values [list "core_clk_62p5mhz" "core_clk_125mhz"]]
      }
      if [expr { (($link_width=="x1")&&($lane_rate=="gen3")) }] {
         set legal_values [intersect $legal_values [list "core_clk_125mhz"]]
      }
      if [expr { (($link_width=="x2")&&($lane_rate=="gen1")) }] {
         set legal_values [intersect $legal_values [list "core_clk_62p5mhz" "core_clk_125mhz"]]
      }
      if [expr { (($link_width=="x2")&&($lane_rate=="gen2")) }] {
         set legal_values [intersect $legal_values [list "core_clk_125mhz"]]
      }
      if [expr { (($link_width=="x2")&&($lane_rate=="gen3")) }] {
         if [expr { ($app_interface_width=="avst_64bit") }] {
            set legal_values [intersect $legal_values [list "core_clk_250mhz"]]
         } else {
            if [expr { ($app_interface_width=="avst_128bit") }] {
               set legal_values [intersect $legal_values [list "core_clk_125mhz"]]
            }
         }
      }
      if [expr { (($link_width=="x4")&&($lane_rate=="gen1")) }] {
         set legal_values [intersect $legal_values [list "core_clk_125mhz"]]
      }
      if [expr { (($link_width=="x4")&&($lane_rate=="gen2")) }] {
         if [expr { ($app_interface_width=="avst_64bit") }] {
            set legal_values [intersect $legal_values [list "core_clk_250mhz"]]
         } else {
            if [expr { ($app_interface_width=="avst_128bit") }] {
               set legal_values [intersect $legal_values [list "core_clk_125mhz"]]
            }
         }
      }
      if [expr { (($link_width=="x4")&&($lane_rate=="gen3")) }] {
         if [expr { ($app_interface_width=="avst_128bit") }] {
            set legal_values [intersect $legal_values [list "core_clk_250mhz"]]
         } else {
            if [expr { ($app_interface_width=="avst_256bit") }] {
               set legal_values [intersect $legal_values [list "core_clk_125mhz"]]
            }
         }
      }
      if [expr { (($link_width=="x8")&&($lane_rate=="gen1")) }] {
         if [expr { ($app_interface_width=="avst_64bit") }] {
            set legal_values [intersect $legal_values [list "core_clk_250mhz"]]
         } else {
            if [expr { ($app_interface_width=="avst_128bit") }] {
               set legal_values [intersect $legal_values [list "core_clk_125mhz"]]
            }
         }
      }
      if [expr { (($link_width=="x8")&&($lane_rate=="gen2")) }] {
         if [expr { ($app_interface_width=="avst_128bit") }] {
            set legal_values [intersect $legal_values [list "core_clk_250mhz"]]
         } else {
            if [expr { ($app_interface_width=="avst_256bit") }] {
               set legal_values [intersect $legal_values [list "core_clk_125mhz"]]
            }
         }
      }
      if [expr { (($link_width=="x8")&&($lane_rate=="gen3")) }] {
         set legal_values [intersect $legal_values [list "core_clk_250mhz"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "core_clk_62p5mhz"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.core_clk_freq_mhz.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message core_clk_freq_mhz $legal_values
      }
   } else {
      auto_invalid_value_message auto core_clk_freq_mhz $core_clk_freq_mhz $legal_values { app_interface_width func_mode lane_rate link_width }
   }
}

proc ::nf_hip::parameters::validate_core_clk_out_sel { PROP_M_AUTOSET PROP_M_AUTOWARN core_clk_out_sel core_clk_freq_mhz lane_rate sup_mode } {

   set legal_values [list "core_clk_out_div_1" "core_clk_out_div_2" "core_clk_out_div_4" "core_clk_out_div_8"]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { (($core_clk_freq_mhz=="core_clk_62p5mhz")&&($lane_rate=="gen1")) }] {
         set legal_values [intersect $legal_values [list "core_clk_out_div_4"]]
      }
      if [expr { (($core_clk_freq_mhz=="core_clk_62p5mhz")&&($lane_rate=="gen2")) }] {
         set legal_values [intersect $legal_values [list "core_clk_out_div_4"]]
      }
      if [expr { (($core_clk_freq_mhz=="core_clk_125mhz")&&($lane_rate=="gen1")) }] {
         set legal_values [intersect $legal_values [list "core_clk_out_div_2"]]
      }
      if [expr { (($core_clk_freq_mhz=="core_clk_250mhz")&&($lane_rate=="gen1")) }] {
         set legal_values [intersect $legal_values [list "core_clk_out_div_1"]]
      }
      if [expr { (($core_clk_freq_mhz=="core_clk_125mhz")&&(($lane_rate=="gen2")||($lane_rate=="gen3"))) }] {
         set legal_values [intersect $legal_values [list "core_clk_out_div_2"]]
      }
      if [expr { (($core_clk_freq_mhz=="core_clk_250mhz")&&(($lane_rate=="gen2")||($lane_rate=="gen3"))) }] {
         set legal_values [intersect $legal_values [list "core_clk_out_div_1"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "core_clk_out_div_1" "core_clk_out_div_2" "core_clk_out_div_4" "core_clk_out_div_8"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.core_clk_out_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message core_clk_out_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto core_clk_out_sel $core_clk_out_sel $legal_values { core_clk_freq_mhz lane_rate sup_mode }
   }
}

proc ::nf_hip::parameters::validate_core_clk_sel { PROP_M_AUTOSET PROP_M_AUTOWARN core_clk_sel bypass_clk_switch func_mode sup_mode } {

   set legal_values [list "core_clk_250" "pld_clk"]

   if [expr { ($func_mode=="enable") }] {
      if [expr { ($bypass_clk_switch=="true") }] {
         if [expr { ($sup_mode=="user_mode") }] {
            set legal_values [intersect $legal_values [list "pld_clk"]]
         } else {
            set legal_values [intersect $legal_values [list "pld_clk" "core_clk_250"]]
         }
      } else {
         set legal_values [intersect $legal_values [list "pld_clk"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "pld_clk"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.core_clk_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message core_clk_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto core_clk_sel $core_clk_sel $legal_values { bypass_clk_switch func_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_core_clk_source { PROP_M_AUTOSET PROP_M_AUTOWARN core_clk_source func_mode sup_mode } {

   set legal_values [list "core_clk_in" "pclk_out" "pll_fixed_clk"]

   if [expr { ($func_mode=="enable") }] {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "pll_fixed_clk"]]
      } else {
         set legal_values [intersect $legal_values [list "pll_fixed_clk" "core_clk_in"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "pll_fixed_clk"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.core_clk_source.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message core_clk_source $legal_values
      }
   } else {
      auto_invalid_value_message auto core_clk_source $core_clk_source $legal_values { func_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_cseb_bar_match_checking { PROP_M_AUTOSET PROP_M_AUTOWARN cseb_bar_match_checking cseb_config_bypass sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($cseb_config_bypass=="enable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "enable"]]
      } else {
         set legal_values [intersect $legal_values [list "enable" "disable"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.cseb_bar_match_checking.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message cseb_bar_match_checking $legal_values
      }
   } else {
      auto_invalid_value_message auto cseb_bar_match_checking $cseb_bar_match_checking $legal_values { cseb_config_bypass sup_mode }
   }
}

proc ::nf_hip::parameters::validate_cseb_config_bypass { PROP_M_AUTOSET PROP_M_AUTOWARN cseb_config_bypass func_mode sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "enable" "disable"]]
      } else {
         set legal_values [intersect $legal_values [list "enable" "disable"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.cseb_config_bypass.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message cseb_config_bypass $legal_values
      }
   } else {
      auto_invalid_value_message auto cseb_config_bypass $cseb_config_bypass $legal_values { func_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_cseb_cpl_status_during_cvp { PROP_M_AUTOSET PROP_M_AUTOWARN cseb_cpl_status_during_cvp cvp_enable func_mode } {

   set legal_values [list "completer_abort" "config_retry_status" "success_data_0000" "success_data_ffff" "success_next_cap_ptr_0" "unsupported_request"]

   if [expr { (($func_mode=="enable")&&($cvp_enable=="cvp_en")) }] {
      set legal_values [intersect $legal_values [list "success_data_ffff" "unsupported_request" "config_retry_status" "completer_abort" "success_data_0000" "success_next_cap_ptr_0"]]
   } else {
      set legal_values [intersect $legal_values [list "config_retry_status"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.cseb_cpl_status_during_cvp.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message cseb_cpl_status_during_cvp $legal_values
      }
   } else {
      auto_invalid_value_message auto cseb_cpl_status_during_cvp $cseb_cpl_status_during_cvp $legal_values { cvp_enable func_mode }
   }
}

proc ::nf_hip::parameters::validate_cseb_cpl_tag_checking { PROP_M_AUTOSET PROP_M_AUTOWARN cseb_cpl_tag_checking cseb_config_bypass func_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      if [expr { ($cseb_config_bypass=="enable") }] {
         set legal_values [intersect $legal_values [list "disable"]]
      } else {
         set legal_values [intersect $legal_values [list "enable" "disable"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.cseb_cpl_tag_checking.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message cseb_cpl_tag_checking $legal_values
      }
   } else {
      auto_invalid_value_message auto cseb_cpl_tag_checking $cseb_cpl_tag_checking $legal_values { cseb_config_bypass func_mode }
   }
}

proc ::nf_hip::parameters::validate_cseb_disable_auto_crs { PROP_M_AUTOSET PROP_M_AUTOWARN cseb_disable_auto_crs sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.cseb_disable_auto_crs.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message cseb_disable_auto_crs $legal_values
      }
   } else {
      auto_invalid_value_message auto cseb_disable_auto_crs $cseb_disable_auto_crs $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_cseb_extend_pci { PROP_M_AUTOSET PROP_M_AUTOWARN cseb_extend_pci func_mode port_type sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         if [expr { ($port_type=="root_port") }] {
            set legal_values [intersect $legal_values [list "false"]]
         } else {
            set legal_values [intersect $legal_values [list "true" "false"]]
         }
      } else {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.cseb_extend_pci.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message cseb_extend_pci $legal_values
      }
   } else {
      auto_invalid_value_message auto cseb_extend_pci $cseb_extend_pci $legal_values { func_mode port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_cseb_extend_pcie { PROP_M_AUTOSET PROP_M_AUTOWARN cseb_extend_pcie func_mode port_type sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         if [expr { ($port_type=="root_port") }] {
            set legal_values [intersect $legal_values [list "false"]]
         } else {
            set legal_values [intersect $legal_values [list "true" "false"]]
         }
      } else {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.cseb_extend_pcie.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message cseb_extend_pcie $legal_values
      }
   } else {
      auto_invalid_value_message auto cseb_extend_pcie $cseb_extend_pcie $legal_values { func_mode port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_cseb_min_error_checking { PROP_M_AUTOSET PROP_M_AUTOWARN cseb_min_error_checking sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.cseb_min_error_checking.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message cseb_min_error_checking $legal_values
      }
   } else {
      auto_invalid_value_message auto cseb_min_error_checking $cseb_min_error_checking $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_cseb_route_to_avl_rx_st { PROP_M_AUTOSET PROP_M_AUTOWARN cseb_route_to_avl_rx_st cseb_config_bypass sup_mode } {

   set legal_values [list "avst" "cseb"]

   if [expr { ($cseb_config_bypass=="enable") }] {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "cseb" "avst"]]
      } else {
         set legal_values [intersect $legal_values [list "cseb" "avst"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "cseb"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.cseb_route_to_avl_rx_st.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message cseb_route_to_avl_rx_st $legal_values
      }
   } else {
      auto_invalid_value_message auto cseb_route_to_avl_rx_st $cseb_route_to_avl_rx_st $legal_values { cseb_config_bypass sup_mode }
   }
}

proc ::nf_hip::parameters::validate_cseb_temp_busy_crs { PROP_M_AUTOSET PROP_M_AUTOWARN cseb_temp_busy_crs func_mode sup_mode } {

   set legal_values [list "completer_abort_tmp_busy" "config_retry_status_tmp_busy"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "config_retry_status_tmp_busy"]]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "config_retry_status_tmp_busy" "completer_abort_tmp_busy"]]
      } else {
         set legal_values [intersect $legal_values [list "config_retry_status_tmp_busy" "completer_abort_tmp_busy"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.cseb_temp_busy_crs.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message cseb_temp_busy_crs $legal_values
      }
   } else {
      auto_invalid_value_message auto cseb_temp_busy_crs $cseb_temp_busy_crs $legal_values { func_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_cvp_clk_reset { PROP_M_AUTOSET PROP_M_AUTOWARN cvp_clk_reset cvp_enable sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($cvp_enable=="cvp_en") }] {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.cvp_clk_reset.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message cvp_clk_reset $legal_values
      }
   } else {
      auto_invalid_value_message auto cvp_clk_reset $cvp_clk_reset $legal_values { cvp_enable sup_mode }
   }
}

proc ::nf_hip::parameters::validate_cvp_data_compressed { PROP_M_AUTOSET PROP_M_AUTOWARN cvp_data_compressed cvp_enable sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($cvp_enable=="cvp_en") }] {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.cvp_data_compressed.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message cvp_data_compressed $legal_values
      }
   } else {
      auto_invalid_value_message auto cvp_data_compressed $cvp_data_compressed $legal_values { cvp_enable sup_mode }
   }
}

proc ::nf_hip::parameters::validate_cvp_data_encrypted { PROP_M_AUTOSET PROP_M_AUTOWARN cvp_data_encrypted cvp_enable sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($cvp_enable=="cvp_en") }] {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.cvp_data_encrypted.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message cvp_data_encrypted $legal_values
      }
   } else {
      auto_invalid_value_message auto cvp_data_encrypted $cvp_data_encrypted $legal_values { cvp_enable sup_mode }
   }
}

proc ::nf_hip::parameters::validate_cvp_enable { PROP_M_AUTOSET PROP_M_AUTOWARN cvp_enable func_mode } {

   set legal_values [list "cvp_dis" "cvp_en"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "cvp_dis"]]
   } else {
      set legal_values [intersect $legal_values [list "cvp_dis" "cvp_en"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.cvp_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message cvp_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto cvp_enable $cvp_enable $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_cvp_mode_reset { PROP_M_AUTOSET PROP_M_AUTOWARN cvp_mode_reset cvp_enable sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($cvp_enable=="cvp_en") }] {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.cvp_mode_reset.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message cvp_mode_reset $legal_values
      }
   } else {
      auto_invalid_value_message auto cvp_mode_reset $cvp_mode_reset $legal_values { cvp_enable sup_mode }
   }
}

proc ::nf_hip::parameters::validate_cvp_rate_sel { PROP_M_AUTOSET PROP_M_AUTOWARN cvp_rate_sel cvp_enable sup_mode } {

   set legal_values [list "full_rate" "half_rate"]

   if [expr { ($cvp_enable=="cvp_en") }] {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "half_rate"]]
      } else {
         set legal_values [intersect $legal_values [list "half_rate" "full_rate"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "full_rate"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.cvp_rate_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message cvp_rate_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto cvp_rate_sel $cvp_rate_sel $legal_values { cvp_enable sup_mode }
   }
}

proc ::nf_hip::parameters::validate_d0_pme { PROP_M_AUTOSET PROP_M_AUTOWARN d0_pme port_type sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($port_type=="root_port") }] {
         set legal_values [intersect $legal_values [list "true"]]
      } else {
         set legal_values [intersect $legal_values [list "false"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.d0_pme.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message d0_pme $legal_values
      }
   } else {
      auto_invalid_value_message auto d0_pme $d0_pme $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_d1_pme { PROP_M_AUTOSET PROP_M_AUTOWARN d1_pme sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.d1_pme.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message d1_pme $legal_values
      }
   } else {
      auto_invalid_value_message auto d1_pme $d1_pme $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_d1_support { PROP_M_AUTOSET PROP_M_AUTOWARN d1_support sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.d1_support.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message d1_support $legal_values
      }
   } else {
      auto_invalid_value_message auto d1_support $d1_support $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_d2_pme { PROP_M_AUTOSET PROP_M_AUTOWARN d2_pme sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.d2_pme.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message d2_pme $legal_values
      }
   } else {
      auto_invalid_value_message auto d2_pme $d2_pme $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_d2_support { PROP_M_AUTOSET PROP_M_AUTOWARN d2_support sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.d2_support.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message d2_support $legal_values
      }
   } else {
      auto_invalid_value_message auto d2_support $d2_support $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_d3_cold_pme { PROP_M_AUTOSET PROP_M_AUTOWARN d3_cold_pme port_type sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($port_type=="root_port") }] {
         set legal_values [intersect $legal_values [list "true"]]
      } else {
         set legal_values [intersect $legal_values [list "false"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.d3_cold_pme.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message d3_cold_pme $legal_values
      }
   } else {
      auto_invalid_value_message auto d3_cold_pme $d3_cold_pme $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_d3_hot_pme { PROP_M_AUTOSET PROP_M_AUTOWARN d3_hot_pme port_type sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($port_type=="root_port") }] {
         set legal_values [intersect $legal_values [list "true"]]
      } else {
         set legal_values [intersect $legal_values [list "false"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.d3_hot_pme.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message d3_hot_pme $legal_values
      }
   } else {
      auto_invalid_value_message auto d3_hot_pme $d3_hot_pme $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_data_pack_rx { PROP_M_AUTOSET PROP_M_AUTOWARN data_pack_rx sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.data_pack_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message data_pack_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto data_pack_rx $data_pack_rx $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_deemphasis_enable { PROP_M_AUTOSET PROP_M_AUTOWARN deemphasis_enable func_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.deemphasis_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message deemphasis_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto deemphasis_enable $deemphasis_enable $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_deskew_comma { PROP_M_AUTOSET PROP_M_AUTOWARN deskew_comma sim_mode sup_mode } {

   set legal_values [list "com_deskw" "skp_eieos_deskw"]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($sim_mode=="enable") }] {
         set legal_values [intersect $legal_values [list "com_deskw"]]
      } else {
         set legal_values [intersect $legal_values [list "skp_eieos_deskw"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "com_deskw" "skp_eieos_deskw"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.deskew_comma.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message deskew_comma $legal_values
      }
   } else {
      auto_invalid_value_message auto deskew_comma $deskew_comma $legal_values { sim_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_device_id { PROP_M_AUTOSET PROP_M_AUTOWARN device_id func_mode } {

   set legal_values [list 0:65535]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 57345]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.device_id.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message device_id $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message device_id $legal_values
      }
   } else {
      auto_value_out_of_range_message auto device_id $device_id $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_device_number { PROP_M_AUTOSET PROP_M_AUTOWARN device_number port_type sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
         set legal_values [compare_eq $legal_values 0]
      }
      if [expr { ($port_type=="root_port") }] {
         set legal_values [compare_ge $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.device_number.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message device_number $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message device_number $legal_values
      }
   } else {
      auto_value_out_of_range_message auto device_number $device_number $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_device_specific_init { PROP_M_AUTOSET PROP_M_AUTOWARN device_specific_init sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.device_specific_init.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message device_specific_init $legal_values
      }
   } else {
      auto_invalid_value_message auto device_specific_init $device_specific_init $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_dft_clock_obsrv_en { PROP_M_AUTOSET PROP_M_AUTOWARN dft_clock_obsrv_en sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.dft_clock_obsrv_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message dft_clock_obsrv_en $legal_values
      }
   } else {
      auto_invalid_value_message auto dft_clock_obsrv_en $dft_clock_obsrv_en $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_dft_clock_obsrv_sel { PROP_M_AUTOSET PROP_M_AUTOWARN dft_clock_obsrv_sel sup_mode } {

   set legal_values [list "dft_core_clk_lt" "dft_pclk" "dft_pld_clk" "dft_pll_fixed_clk"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "dft_pclk"]]
   } else {
      set legal_values [intersect $legal_values [list "dft_pclk" "dft_pll_fixed_clk" "dft_pld_clk" "dft_core_clk_lt"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.dft_clock_obsrv_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message dft_clock_obsrv_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto dft_clock_obsrv_sel $dft_clock_obsrv_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_diffclock_nfts_count { PROP_M_AUTOSET PROP_M_AUTOWARN diffclock_nfts_count sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 128]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.diffclock_nfts_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message diffclock_nfts_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message diffclock_nfts_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto diffclock_nfts_count $diffclock_nfts_count $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_dis_cplovf { PROP_M_AUTOSET PROP_M_AUTOWARN dis_cplovf sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable" "enable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.dis_cplovf.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message dis_cplovf $legal_values
      }
   } else {
      auto_invalid_value_message auto dis_cplovf $dis_cplovf $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_dis_paritychk { PROP_M_AUTOSET PROP_M_AUTOWARN dis_paritychk func_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.dis_paritychk.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message dis_paritychk $legal_values
      }
   } else {
      auto_invalid_value_message auto dis_paritychk $dis_paritychk $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_disable_link_x2_support { PROP_M_AUTOSET PROP_M_AUTOWARN disable_link_x2_support sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.disable_link_x2_support.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message disable_link_x2_support $legal_values
      }
   } else {
      auto_invalid_value_message auto disable_link_x2_support $disable_link_x2_support $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_disable_snoop_packet { PROP_M_AUTOSET PROP_M_AUTOWARN disable_snoop_packet sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.disable_snoop_packet.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message disable_snoop_packet $legal_values
      }
   } else {
      auto_invalid_value_message auto disable_snoop_packet $disable_snoop_packet $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_dl_tx_check_parity_edb { PROP_M_AUTOSET PROP_M_AUTOWARN dl_tx_check_parity_edb sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.dl_tx_check_parity_edb.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message dl_tx_check_parity_edb $legal_values
      }
   } else {
      auto_invalid_value_message auto dl_tx_check_parity_edb $dl_tx_check_parity_edb $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_dll_active_report_support { PROP_M_AUTOSET PROP_M_AUTOWARN dll_active_report_support port_type sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
         set legal_values [intersect $legal_values [list "false"]]
      }
      if [expr { ($port_type=="root_port") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.dll_active_report_support.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message dll_active_report_support $legal_values
      }
   } else {
      auto_invalid_value_message auto dll_active_report_support $dll_active_report_support $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_early_dl_up { PROP_M_AUTOSET PROP_M_AUTOWARN early_dl_up sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.early_dl_up.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message early_dl_up $legal_values
      }
   } else {
      auto_invalid_value_message auto early_dl_up $early_dl_up $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_ecrc_check_capable { PROP_M_AUTOSET PROP_M_AUTOWARN ecrc_check_capable advance_error_reporting sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($advance_error_reporting=="disable") }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.ecrc_check_capable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message ecrc_check_capable $legal_values
      }
   } else {
      auto_invalid_value_message auto ecrc_check_capable $ecrc_check_capable $legal_values { advance_error_reporting sup_mode }
   }
}

proc ::nf_hip::parameters::validate_ecrc_gen_capable { PROP_M_AUTOSET PROP_M_AUTOWARN ecrc_gen_capable advance_error_reporting sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($advance_error_reporting=="disable") }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.ecrc_gen_capable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message ecrc_gen_capable $legal_values
      }
   } else {
      auto_invalid_value_message auto ecrc_gen_capable $ecrc_gen_capable $legal_values { advance_error_reporting sup_mode }
   }
}

proc ::nf_hip::parameters::validate_egress_block_err_report_ena { PROP_M_AUTOSET PROP_M_AUTOWARN egress_block_err_report_ena sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.egress_block_err_report_ena.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message egress_block_err_report_ena $legal_values
      }
   } else {
      auto_invalid_value_message auto egress_block_err_report_ena $egress_block_err_report_ena $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_ei_delay_powerdown_count { PROP_M_AUTOSET PROP_M_AUTOWARN ei_delay_powerdown_count sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 10]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.ei_delay_powerdown_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message ei_delay_powerdown_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message ei_delay_powerdown_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto ei_delay_powerdown_count $ei_delay_powerdown_count $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_eie_before_nfts_count { PROP_M_AUTOSET PROP_M_AUTOWARN eie_before_nfts_count sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 4]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.eie_before_nfts_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message eie_before_nfts_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message eie_before_nfts_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto eie_before_nfts_count $eie_before_nfts_count $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_electromech_interlock { PROP_M_AUTOSET PROP_M_AUTOWARN electromech_interlock enable_slot_register func_mode sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         if [expr { ($enable_slot_register=="false") }] {
            set legal_values [intersect $legal_values [list "false"]]
         }
      } else {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.electromech_interlock.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message electromech_interlock $legal_values
      }
   } else {
      auto_invalid_value_message auto electromech_interlock $electromech_interlock $legal_values { enable_slot_register func_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_en_ieiupdatefc { PROP_M_AUTOSET PROP_M_AUTOWARN en_ieiupdatefc sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.en_ieiupdatefc.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message en_ieiupdatefc $legal_values
      }
   } else {
      auto_invalid_value_message auto en_ieiupdatefc $en_ieiupdatefc $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_en_lane_errchk { PROP_M_AUTOSET PROP_M_AUTOWARN en_lane_errchk sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.en_lane_errchk.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message en_lane_errchk $legal_values
      }
   } else {
      auto_invalid_value_message auto en_lane_errchk $en_lane_errchk $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_en_phystatus_dly { PROP_M_AUTOSET PROP_M_AUTOWARN en_phystatus_dly sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.en_phystatus_dly.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message en_phystatus_dly $legal_values
      }
   } else {
      auto_invalid_value_message auto en_phystatus_dly $en_phystatus_dly $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_ena_ido_cpl { PROP_M_AUTOSET PROP_M_AUTOWARN ena_ido_cpl sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.ena_ido_cpl.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message ena_ido_cpl $legal_values
      }
   } else {
      auto_invalid_value_message auto ena_ido_cpl $ena_ido_cpl $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_ena_ido_req { PROP_M_AUTOSET PROP_M_AUTOWARN ena_ido_req sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.ena_ido_req.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message ena_ido_req $legal_values
      }
   } else {
      auto_invalid_value_message auto ena_ido_req $ena_ido_req $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_enable_adapter_half_rate_mode { PROP_M_AUTOSET PROP_M_AUTOWARN enable_adapter_half_rate_mode sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.enable_adapter_half_rate_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message enable_adapter_half_rate_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto enable_adapter_half_rate_mode $enable_adapter_half_rate_mode $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_enable_ch01_pclk_out { PROP_M_AUTOSET PROP_M_AUTOWARN enable_ch01_pclk_out func_mode link_width } {

   set legal_values [list "pclk_ch0" "pclk_ch1"]

   if [expr { ($func_mode=="enable") }] {
      if [expr { ($link_width=="x1") }] {
         set legal_values [intersect $legal_values [list "pclk_ch0"]]
      } else {
         if [expr { ($link_width=="x2") }] {
            set legal_values [intersect $legal_values [list "pclk_ch0"]]
         } else {
            if [expr { ($link_width=="x4") }] {
               set legal_values [intersect $legal_values [list "pclk_ch0"]]
            } else {
               set legal_values [intersect $legal_values [list "pclk_ch0"]]
            }
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "pclk_ch0"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.enable_ch01_pclk_out.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message enable_ch01_pclk_out $legal_values
      }
   } else {
      auto_invalid_value_message auto enable_ch01_pclk_out $enable_ch01_pclk_out $legal_values { func_mode link_width }
   }
}

proc ::nf_hip::parameters::validate_enable_ch0_pclk_out { PROP_M_AUTOSET PROP_M_AUTOWARN enable_ch0_pclk_out func_mode link_width } {

   set legal_values [list "pclk_central" "pclk_ch01"]

   if [expr { ($func_mode=="enable") }] {
      if [expr { ($link_width=="x1") }] {
         set legal_values [intersect $legal_values [list "pclk_ch01"]]
      } else {
         if [expr { ($link_width=="x2") }] {
            set legal_values [intersect $legal_values [list "pclk_ch01"]]
         } else {
            if [expr { ($link_width=="x4") }] {
               set legal_values [intersect $legal_values [list "pclk_central"]]
            } else {
               set legal_values [intersect $legal_values [list "pclk_central"]]
            }
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "pclk_ch01"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.enable_ch0_pclk_out.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message enable_ch0_pclk_out $legal_values
      }
   } else {
      auto_invalid_value_message auto enable_ch0_pclk_out $enable_ch0_pclk_out $legal_values { func_mode link_width }
   }
}

proc ::nf_hip::parameters::validate_enable_completion_timeout_disable { PROP_M_AUTOSET PROP_M_AUTOWARN enable_completion_timeout_disable func_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "true"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.enable_completion_timeout_disable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message enable_completion_timeout_disable $legal_values
      }
   } else {
      auto_invalid_value_message auto enable_completion_timeout_disable $enable_completion_timeout_disable $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_enable_directed_spd_chng { PROP_M_AUTOSET PROP_M_AUTOWARN enable_directed_spd_chng sim_mode sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($sim_mode=="enable") }] {
         set legal_values [intersect $legal_values [list "true"]]
      } else {
         set legal_values [intersect $legal_values [list "false"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.enable_directed_spd_chng.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message enable_directed_spd_chng $legal_values
      }
   } else {
      auto_invalid_value_message auto enable_directed_spd_chng $enable_directed_spd_chng $legal_values { sim_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_enable_function_msix_support { PROP_M_AUTOSET PROP_M_AUTOWARN enable_function_msix_support func_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.enable_function_msix_support.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message enable_function_msix_support $legal_values
      }
   } else {
      auto_invalid_value_message auto enable_function_msix_support $enable_function_msix_support $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_enable_l0s_aspm { PROP_M_AUTOSET PROP_M_AUTOWARN enable_l0s_aspm sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.enable_l0s_aspm.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message enable_l0s_aspm $legal_values
      }
   } else {
      auto_invalid_value_message auto enable_l0s_aspm $enable_l0s_aspm $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_enable_l1_aspm { PROP_M_AUTOSET PROP_M_AUTOWARN enable_l1_aspm sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.enable_l1_aspm.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message enable_l1_aspm $legal_values
      }
   } else {
      auto_invalid_value_message auto enable_l1_aspm $enable_l1_aspm $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_enable_rx_buffer_checking { PROP_M_AUTOSET PROP_M_AUTOWARN enable_rx_buffer_checking sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.enable_rx_buffer_checking.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message enable_rx_buffer_checking $legal_values
      }
   } else {
      auto_invalid_value_message auto enable_rx_buffer_checking $enable_rx_buffer_checking $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_enable_rx_reordering { PROP_M_AUTOSET PROP_M_AUTOWARN enable_rx_reordering sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "true"]]
   } else {
      set legal_values [intersect $legal_values [list "false" "true"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.enable_rx_reordering.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message enable_rx_reordering $legal_values
      }
   } else {
      auto_invalid_value_message auto enable_rx_reordering $enable_rx_reordering $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_enable_slot_register { PROP_M_AUTOSET PROP_M_AUTOWARN enable_slot_register port_type sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($port_type=="root_port") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      } else {
         set legal_values [intersect $legal_values [list "false"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.enable_slot_register.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message enable_slot_register $legal_values
      }
   } else {
      auto_invalid_value_message auto enable_slot_register $enable_slot_register $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_endpoint_l0_latency { PROP_M_AUTOSET PROP_M_AUTOWARN endpoint_l0_latency func_mode } {

   set legal_values [list 0:7]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.endpoint_l0_latency.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message endpoint_l0_latency $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message endpoint_l0_latency $legal_values
      }
   } else {
      auto_value_out_of_range_message auto endpoint_l0_latency $endpoint_l0_latency $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_endpoint_l1_latency { PROP_M_AUTOSET PROP_M_AUTOWARN endpoint_l1_latency func_mode } {

   set legal_values [list 0:7]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.endpoint_l1_latency.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message endpoint_l1_latency $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message endpoint_l1_latency $legal_values
      }
   } else {
      auto_value_out_of_range_message auto endpoint_l1_latency $endpoint_l1_latency $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_eql_rq_int_en_number { PROP_M_AUTOSET PROP_M_AUTOWARN eql_rq_int_en_number func_mode } {

   set legal_values [list 0:63]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.eql_rq_int_en_number.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message eql_rq_int_en_number $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message eql_rq_int_en_number $legal_values
      }
   } else {
      auto_value_out_of_range_message auto eql_rq_int_en_number $eql_rq_int_en_number $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_errmgt_fcpe_patch_dis { PROP_M_AUTOSET PROP_M_AUTOWARN errmgt_fcpe_patch_dis sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.errmgt_fcpe_patch_dis.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message errmgt_fcpe_patch_dis $legal_values
      }
   } else {
      auto_invalid_value_message auto errmgt_fcpe_patch_dis $errmgt_fcpe_patch_dis $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_errmgt_fep_patch_dis { PROP_M_AUTOSET PROP_M_AUTOWARN errmgt_fep_patch_dis sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.errmgt_fep_patch_dis.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message errmgt_fep_patch_dis $legal_values
      }
   } else {
      auto_invalid_value_message auto errmgt_fep_patch_dis $errmgt_fep_patch_dis $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_expansion_base_address_register { PROP_M_AUTOSET PROP_M_AUTOWARN expansion_base_address_register func_mode } {

   set legal_values [list 0:4294967295]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.expansion_base_address_register.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message expansion_base_address_register $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message expansion_base_address_register $legal_values
      }
   } else {
      auto_value_out_of_range_message auto expansion_base_address_register $expansion_base_address_register $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_extend_tag_field { PROP_M_AUTOSET PROP_M_AUTOWARN extend_tag_field func_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.extend_tag_field.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message extend_tag_field $legal_values
      }
   } else {
      auto_invalid_value_message auto extend_tag_field $extend_tag_field $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_extended_format_field { PROP_M_AUTOSET PROP_M_AUTOWARN extended_format_field } {

   set legal_values [list "false" "true"]

   set legal_values [intersect $legal_values [list "true"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.extended_format_field.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message extended_format_field $legal_values
      }
   } else {
      auto_invalid_value_message auto extended_format_field $extended_format_field $legal_values { }
   }
}

proc ::nf_hip::parameters::validate_extended_tag_reset { PROP_M_AUTOSET PROP_M_AUTOWARN extended_tag_reset sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.extended_tag_reset.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message extended_tag_reset $legal_values
      }
   } else {
      auto_invalid_value_message auto extended_tag_reset $extended_tag_reset $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_fc_init_timer { PROP_M_AUTOSET PROP_M_AUTOWARN fc_init_timer sup_mode } {

   set legal_values [list 0:2047]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 1024]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.fc_init_timer.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message fc_init_timer $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message fc_init_timer $legal_values
      }
   } else {
      auto_value_out_of_range_message auto fc_init_timer $fc_init_timer $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_flow_control_timeout_count { PROP_M_AUTOSET PROP_M_AUTOWARN flow_control_timeout_count sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 200]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.flow_control_timeout_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message flow_control_timeout_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message flow_control_timeout_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto flow_control_timeout_count $flow_control_timeout_count $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_flow_control_update_count { PROP_M_AUTOSET PROP_M_AUTOWARN flow_control_update_count sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 30]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.flow_control_update_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message flow_control_update_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message flow_control_update_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto flow_control_update_count $flow_control_update_count $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_flr_capability { PROP_M_AUTOSET PROP_M_AUTOWARN flr_capability sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.flr_capability.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message flr_capability $legal_values
      }
   } else {
      auto_invalid_value_message auto flr_capability $flr_capability $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_force_dis_to_det { PROP_M_AUTOSET PROP_M_AUTOWARN force_dis_to_det sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.force_dis_to_det.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message force_dis_to_det $legal_values
      }
   } else {
      auto_invalid_value_message auto force_dis_to_det $force_dis_to_det $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_force_gen1_dis { PROP_M_AUTOSET PROP_M_AUTOWARN force_gen1_dis sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.force_gen1_dis.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message force_gen1_dis $legal_values
      }
   } else {
      auto_invalid_value_message auto force_gen1_dis $force_gen1_dis $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_force_tx_coeff_preset_lpbk { PROP_M_AUTOSET PROP_M_AUTOWARN force_tx_coeff_preset_lpbk sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.force_tx_coeff_preset_lpbk.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message force_tx_coeff_preset_lpbk $legal_values
      }
   } else {
      auto_invalid_value_message auto force_tx_coeff_preset_lpbk $force_tx_coeff_preset_lpbk $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_frame_err_patch_dis { PROP_M_AUTOSET PROP_M_AUTOWARN frame_err_patch_dis sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.frame_err_patch_dis.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message frame_err_patch_dis $legal_values
      }
   } else {
      auto_invalid_value_message auto frame_err_patch_dis $frame_err_patch_dis $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_func_mode { PROP_M_AUTOSET PROP_M_AUTOWARN func_mode powerdown_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.func_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message func_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto func_mode $func_mode $legal_values { powerdown_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_bypass_equlz { PROP_M_AUTOSET PROP_M_AUTOWARN g3_bypass_equlz sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.g3_bypass_equlz.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message g3_bypass_equlz $legal_values
      }
   } else {
      auto_invalid_value_message auto g3_bypass_equlz $g3_bypass_equlz $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_coeff_done_tmout { PROP_M_AUTOSET PROP_M_AUTOWARN g3_coeff_done_tmout sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.g3_coeff_done_tmout.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message g3_coeff_done_tmout $legal_values
      }
   } else {
      auto_invalid_value_message auto g3_coeff_done_tmout $g3_coeff_done_tmout $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_deskew_char { PROP_M_AUTOSET PROP_M_AUTOWARN g3_deskew_char sup_mode } {

   set legal_values [list "default_sdsos" "eieos" "sdsos" "skpos"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "default_sdsos"]]
   } else {
      set legal_values [intersect $legal_values [list "default_sdsos" "skpos" "eieos" "sdsos"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.g3_deskew_char.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message g3_deskew_char $legal_values
      }
   } else {
      auto_invalid_value_message auto g3_deskew_char $g3_deskew_char $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_dis_be_frm_err { PROP_M_AUTOSET PROP_M_AUTOWARN g3_dis_be_frm_err sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.g3_dis_be_frm_err.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message g3_dis_be_frm_err $legal_values
      }
   } else {
      auto_invalid_value_message auto g3_dis_be_frm_err $g3_dis_be_frm_err $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_dn_rx_hint_eqlz_0 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_dn_rx_hint_eqlz_0 port_type sup_mode } {

   set legal_values [list 0:7]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_dn_rx_hint_eqlz_0.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_dn_rx_hint_eqlz_0 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_dn_rx_hint_eqlz_0 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_dn_rx_hint_eqlz_0 $g3_dn_rx_hint_eqlz_0 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_dn_rx_hint_eqlz_1 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_dn_rx_hint_eqlz_1 port_type sup_mode } {

   set legal_values [list 0:7]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_dn_rx_hint_eqlz_1.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_dn_rx_hint_eqlz_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_dn_rx_hint_eqlz_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_dn_rx_hint_eqlz_1 $g3_dn_rx_hint_eqlz_1 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_dn_rx_hint_eqlz_2 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_dn_rx_hint_eqlz_2 port_type sup_mode } {

   set legal_values [list 0:7]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_dn_rx_hint_eqlz_2.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_dn_rx_hint_eqlz_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_dn_rx_hint_eqlz_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_dn_rx_hint_eqlz_2 $g3_dn_rx_hint_eqlz_2 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_dn_rx_hint_eqlz_3 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_dn_rx_hint_eqlz_3 port_type sup_mode } {

   set legal_values [list 0:7]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_dn_rx_hint_eqlz_3.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_dn_rx_hint_eqlz_3 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_dn_rx_hint_eqlz_3 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_dn_rx_hint_eqlz_3 $g3_dn_rx_hint_eqlz_3 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_dn_rx_hint_eqlz_4 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_dn_rx_hint_eqlz_4 port_type sup_mode } {

   set legal_values [list 0:7]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_dn_rx_hint_eqlz_4.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_dn_rx_hint_eqlz_4 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_dn_rx_hint_eqlz_4 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_dn_rx_hint_eqlz_4 $g3_dn_rx_hint_eqlz_4 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_dn_rx_hint_eqlz_5 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_dn_rx_hint_eqlz_5 port_type sup_mode } {

   set legal_values [list 0:7]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_dn_rx_hint_eqlz_5.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_dn_rx_hint_eqlz_5 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_dn_rx_hint_eqlz_5 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_dn_rx_hint_eqlz_5 $g3_dn_rx_hint_eqlz_5 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_dn_rx_hint_eqlz_6 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_dn_rx_hint_eqlz_6 port_type sup_mode } {

   set legal_values [list 0:7]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_dn_rx_hint_eqlz_6.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_dn_rx_hint_eqlz_6 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_dn_rx_hint_eqlz_6 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_dn_rx_hint_eqlz_6 $g3_dn_rx_hint_eqlz_6 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_dn_rx_hint_eqlz_7 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_dn_rx_hint_eqlz_7 port_type sup_mode } {

   set legal_values [list 0:7]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_dn_rx_hint_eqlz_7.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_dn_rx_hint_eqlz_7 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_dn_rx_hint_eqlz_7 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_dn_rx_hint_eqlz_7 $g3_dn_rx_hint_eqlz_7 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_dn_tx_preset_eqlz_0 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_dn_tx_preset_eqlz_0 port_type sup_mode } {

   set legal_values [list 0:15]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_dn_tx_preset_eqlz_0.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_dn_tx_preset_eqlz_0 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_dn_tx_preset_eqlz_0 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_dn_tx_preset_eqlz_0 $g3_dn_tx_preset_eqlz_0 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_dn_tx_preset_eqlz_1 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_dn_tx_preset_eqlz_1 port_type sup_mode } {

   set legal_values [list 0:15]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_dn_tx_preset_eqlz_1.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_dn_tx_preset_eqlz_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_dn_tx_preset_eqlz_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_dn_tx_preset_eqlz_1 $g3_dn_tx_preset_eqlz_1 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_dn_tx_preset_eqlz_2 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_dn_tx_preset_eqlz_2 port_type sup_mode } {

   set legal_values [list 0:15]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_dn_tx_preset_eqlz_2.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_dn_tx_preset_eqlz_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_dn_tx_preset_eqlz_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_dn_tx_preset_eqlz_2 $g3_dn_tx_preset_eqlz_2 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_dn_tx_preset_eqlz_3 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_dn_tx_preset_eqlz_3 port_type sup_mode } {

   set legal_values [list 0:15]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_dn_tx_preset_eqlz_3.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_dn_tx_preset_eqlz_3 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_dn_tx_preset_eqlz_3 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_dn_tx_preset_eqlz_3 $g3_dn_tx_preset_eqlz_3 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_dn_tx_preset_eqlz_4 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_dn_tx_preset_eqlz_4 port_type sup_mode } {

   set legal_values [list 0:15]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_dn_tx_preset_eqlz_4.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_dn_tx_preset_eqlz_4 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_dn_tx_preset_eqlz_4 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_dn_tx_preset_eqlz_4 $g3_dn_tx_preset_eqlz_4 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_dn_tx_preset_eqlz_5 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_dn_tx_preset_eqlz_5 port_type sup_mode } {

   set legal_values [list 0:15]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_dn_tx_preset_eqlz_5.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_dn_tx_preset_eqlz_5 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_dn_tx_preset_eqlz_5 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_dn_tx_preset_eqlz_5 $g3_dn_tx_preset_eqlz_5 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_dn_tx_preset_eqlz_6 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_dn_tx_preset_eqlz_6 port_type sup_mode } {

   set legal_values [list 0:15]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_dn_tx_preset_eqlz_6.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_dn_tx_preset_eqlz_6 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_dn_tx_preset_eqlz_6 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_dn_tx_preset_eqlz_6 $g3_dn_tx_preset_eqlz_6 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_dn_tx_preset_eqlz_7 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_dn_tx_preset_eqlz_7 port_type sup_mode } {

   set legal_values [list 0:15]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_dn_tx_preset_eqlz_7.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_dn_tx_preset_eqlz_7 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_dn_tx_preset_eqlz_7 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_dn_tx_preset_eqlz_7 $g3_dn_tx_preset_eqlz_7 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_force_ber_max { PROP_M_AUTOSET PROP_M_AUTOWARN g3_force_ber_max sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.g3_force_ber_max.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message g3_force_ber_max $legal_values
      }
   } else {
      auto_invalid_value_message auto g3_force_ber_max $g3_force_ber_max $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_force_ber_min { PROP_M_AUTOSET PROP_M_AUTOWARN g3_force_ber_min sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "true"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.g3_force_ber_min.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message g3_force_ber_min $legal_values
      }
   } else {
      auto_invalid_value_message auto g3_force_ber_min $g3_force_ber_min $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_lnk_trn_rx_ts { PROP_M_AUTOSET PROP_M_AUTOWARN g3_lnk_trn_rx_ts sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.g3_lnk_trn_rx_ts.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message g3_lnk_trn_rx_ts $legal_values
      }
   } else {
      auto_invalid_value_message auto g3_lnk_trn_rx_ts $g3_lnk_trn_rx_ts $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_ltssm_eq_dbg { PROP_M_AUTOSET PROP_M_AUTOWARN g3_ltssm_eq_dbg sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.g3_ltssm_eq_dbg.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message g3_ltssm_eq_dbg $legal_values
      }
   } else {
      auto_invalid_value_message auto g3_ltssm_eq_dbg $g3_ltssm_eq_dbg $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_ltssm_rec_dbg { PROP_M_AUTOSET PROP_M_AUTOWARN g3_ltssm_rec_dbg sim_mode sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($sim_mode=="enable") }] {
         set legal_values [intersect $legal_values [list "true"]]
      } else {
         set legal_values [intersect $legal_values [list "true"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.g3_ltssm_rec_dbg.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message g3_ltssm_rec_dbg $legal_values
      }
   } else {
      auto_invalid_value_message auto g3_ltssm_rec_dbg $g3_ltssm_rec_dbg $legal_values { sim_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_pause_ltssm_rec_en { PROP_M_AUTOSET PROP_M_AUTOWARN g3_pause_ltssm_rec_en sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.g3_pause_ltssm_rec_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message g3_pause_ltssm_rec_en $legal_values
      }
   } else {
      auto_invalid_value_message auto g3_pause_ltssm_rec_en $g3_pause_ltssm_rec_en $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_quiesce_guarant { PROP_M_AUTOSET PROP_M_AUTOWARN g3_quiesce_guarant sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.g3_quiesce_guarant.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message g3_quiesce_guarant $legal_values
      }
   } else {
      auto_invalid_value_message auto g3_quiesce_guarant $g3_quiesce_guarant $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_redo_equlz_dis { PROP_M_AUTOSET PROP_M_AUTOWARN g3_redo_equlz_dis sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.g3_redo_equlz_dis.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message g3_redo_equlz_dis $legal_values
      }
   } else {
      auto_invalid_value_message auto g3_redo_equlz_dis $g3_redo_equlz_dis $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_redo_equlz_en { PROP_M_AUTOSET PROP_M_AUTOWARN g3_redo_equlz_en sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.g3_redo_equlz_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message g3_redo_equlz_en $legal_values
      }
   } else {
      auto_invalid_value_message auto g3_redo_equlz_en $g3_redo_equlz_en $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_up_rx_hint_eqlz_0 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_up_rx_hint_eqlz_0 port_type sup_mode } {

   set legal_values [list 0:7]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_up_rx_hint_eqlz_0.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_up_rx_hint_eqlz_0 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_up_rx_hint_eqlz_0 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_up_rx_hint_eqlz_0 $g3_up_rx_hint_eqlz_0 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_up_rx_hint_eqlz_1 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_up_rx_hint_eqlz_1 port_type sup_mode } {

   set legal_values [list 0:7]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_up_rx_hint_eqlz_1.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_up_rx_hint_eqlz_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_up_rx_hint_eqlz_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_up_rx_hint_eqlz_1 $g3_up_rx_hint_eqlz_1 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_up_rx_hint_eqlz_2 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_up_rx_hint_eqlz_2 port_type sup_mode } {

   set legal_values [list 0:7]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_up_rx_hint_eqlz_2.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_up_rx_hint_eqlz_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_up_rx_hint_eqlz_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_up_rx_hint_eqlz_2 $g3_up_rx_hint_eqlz_2 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_up_rx_hint_eqlz_3 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_up_rx_hint_eqlz_3 port_type sup_mode } {

   set legal_values [list 0:7]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_up_rx_hint_eqlz_3.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_up_rx_hint_eqlz_3 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_up_rx_hint_eqlz_3 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_up_rx_hint_eqlz_3 $g3_up_rx_hint_eqlz_3 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_up_rx_hint_eqlz_4 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_up_rx_hint_eqlz_4 port_type sup_mode } {

   set legal_values [list 0:7]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_up_rx_hint_eqlz_4.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_up_rx_hint_eqlz_4 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_up_rx_hint_eqlz_4 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_up_rx_hint_eqlz_4 $g3_up_rx_hint_eqlz_4 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_up_rx_hint_eqlz_5 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_up_rx_hint_eqlz_5 port_type sup_mode } {

   set legal_values [list 0:7]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_up_rx_hint_eqlz_5.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_up_rx_hint_eqlz_5 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_up_rx_hint_eqlz_5 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_up_rx_hint_eqlz_5 $g3_up_rx_hint_eqlz_5 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_up_rx_hint_eqlz_6 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_up_rx_hint_eqlz_6 port_type sup_mode } {

   set legal_values [list 0:7]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_up_rx_hint_eqlz_6.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_up_rx_hint_eqlz_6 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_up_rx_hint_eqlz_6 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_up_rx_hint_eqlz_6 $g3_up_rx_hint_eqlz_6 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_up_rx_hint_eqlz_7 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_up_rx_hint_eqlz_7 port_type sup_mode } {

   set legal_values [list 0:7]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_up_rx_hint_eqlz_7.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_up_rx_hint_eqlz_7 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_up_rx_hint_eqlz_7 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_up_rx_hint_eqlz_7 $g3_up_rx_hint_eqlz_7 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_up_tx_preset_eqlz_0 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_up_tx_preset_eqlz_0 port_type sup_mode } {

   set legal_values [list 0:15]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_up_tx_preset_eqlz_0.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_up_tx_preset_eqlz_0 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_up_tx_preset_eqlz_0 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_up_tx_preset_eqlz_0 $g3_up_tx_preset_eqlz_0 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_up_tx_preset_eqlz_1 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_up_tx_preset_eqlz_1 port_type sup_mode } {

   set legal_values [list 0:15]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_up_tx_preset_eqlz_1.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_up_tx_preset_eqlz_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_up_tx_preset_eqlz_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_up_tx_preset_eqlz_1 $g3_up_tx_preset_eqlz_1 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_up_tx_preset_eqlz_2 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_up_tx_preset_eqlz_2 port_type sup_mode } {

   set legal_values [list 0:15]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_up_tx_preset_eqlz_2.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_up_tx_preset_eqlz_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_up_tx_preset_eqlz_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_up_tx_preset_eqlz_2 $g3_up_tx_preset_eqlz_2 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_up_tx_preset_eqlz_3 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_up_tx_preset_eqlz_3 port_type sup_mode } {

   set legal_values [list 0:15]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_up_tx_preset_eqlz_3.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_up_tx_preset_eqlz_3 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_up_tx_preset_eqlz_3 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_up_tx_preset_eqlz_3 $g3_up_tx_preset_eqlz_3 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_up_tx_preset_eqlz_4 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_up_tx_preset_eqlz_4 port_type sup_mode } {

   set legal_values [list 0:15]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_up_tx_preset_eqlz_4.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_up_tx_preset_eqlz_4 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_up_tx_preset_eqlz_4 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_up_tx_preset_eqlz_4 $g3_up_tx_preset_eqlz_4 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_up_tx_preset_eqlz_5 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_up_tx_preset_eqlz_5 port_type sup_mode } {

   set legal_values [list 0:15]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_up_tx_preset_eqlz_5.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_up_tx_preset_eqlz_5 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_up_tx_preset_eqlz_5 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_up_tx_preset_eqlz_5 $g3_up_tx_preset_eqlz_5 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_up_tx_preset_eqlz_6 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_up_tx_preset_eqlz_6 port_type sup_mode } {

   set legal_values [list 0:15]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_up_tx_preset_eqlz_6.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_up_tx_preset_eqlz_6 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_up_tx_preset_eqlz_6 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_up_tx_preset_eqlz_6 $g3_up_tx_preset_eqlz_6 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_g3_up_tx_preset_eqlz_7 { PROP_M_AUTOSET PROP_M_AUTOWARN g3_up_tx_preset_eqlz_7 port_type sup_mode } {

   set legal_values [list 0:15]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.g3_up_tx_preset_eqlz_7.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message g3_up_tx_preset_eqlz_7 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message g3_up_tx_preset_eqlz_7 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto g3_up_tx_preset_eqlz_7 $g3_up_tx_preset_eqlz_7 $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen123_lane_rate_mode { PROP_M_AUTOSET PROP_M_AUTOWARN gen123_lane_rate_mode lane_rate } {

   set legal_values [list "gen1_gen2" "gen1_gen2_gen3" "gen1_rate"]

   if [expr { ($lane_rate=="gen1") }] {
      set legal_values [intersect $legal_values [list "gen1_rate"]]
   }
   if [expr { ($lane_rate=="gen2") }] {
      set legal_values [intersect $legal_values [list "gen1_gen2"]]
   }
   if [expr { ($lane_rate=="gen3") }] {
      set legal_values [intersect $legal_values [list "gen1_gen2_gen3"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen123_lane_rate_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen123_lane_rate_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto gen123_lane_rate_mode $gen123_lane_rate_mode $legal_values { lane_rate }
   }
}

proc ::nf_hip::parameters::validate_gen2_diffclock_nfts_count { PROP_M_AUTOSET PROP_M_AUTOWARN gen2_diffclock_nfts_count sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 255]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen2_diffclock_nfts_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen2_diffclock_nfts_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen2_diffclock_nfts_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen2_diffclock_nfts_count $gen2_diffclock_nfts_count $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen2_pma_pll_usage { PROP_M_AUTOSET PROP_M_AUTOWARN gen2_pma_pll_usage hrdrstctrl_en lane_rate } {

   set legal_values [list "not_applicaple" "use_ffpll" "use_lcpll"]

   if [expr { (($hrdrstctrl_en=="hrdrstctrl_en")&&(($lane_rate=="gen2")||($lane_rate=="gen1"))) }] {
      set legal_values [intersect $legal_values [list "use_ffpll" "use_lcpll"]]
   } else {
      set legal_values [intersect $legal_values [list "not_applicaple"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen2_pma_pll_usage.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen2_pma_pll_usage $legal_values
      }
   } else {
      auto_invalid_value_message auto gen2_pma_pll_usage $gen2_pma_pll_usage $legal_values { hrdrstctrl_en lane_rate }
   }
}

proc ::nf_hip::parameters::validate_gen2_sameclock_nfts_count { PROP_M_AUTOSET PROP_M_AUTOWARN gen2_sameclock_nfts_count sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 255]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen2_sameclock_nfts_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen2_sameclock_nfts_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen2_sameclock_nfts_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen2_sameclock_nfts_count $gen2_sameclock_nfts_count $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_1 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_1 func_mode } {

   set legal_values [list 0:262143]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 7]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_1.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_1 $gen3_coeff_1 $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_10 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_10 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_10.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_10 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_10 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_10 $gen3_coeff_10 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_10_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_10_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_10_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_10_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_10_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_10_ber_meas $gen3_coeff_10_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_10_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_10_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_10_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_10_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_10_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_10_nxtber_less $gen3_coeff_10_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_10_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_10_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_10_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_10_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_10_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_10_nxtber_more $gen3_coeff_10_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_10_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_10_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_10_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_10_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_10_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_10_preset_hint $gen3_coeff_10_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_10_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_10_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_10_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_10_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_10_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_10_reqber $gen3_coeff_10_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_10_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_10_sel sup_mode } {

   set legal_values [list "coeff_10" "preset_10"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_10"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_10" "coeff_10"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_10_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_10_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_10_sel $gen3_coeff_10_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_11 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_11 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_11.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_11 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_11 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_11 $gen3_coeff_11 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_11_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_11_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_11_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_11_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_11_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_11_ber_meas $gen3_coeff_11_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_11_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_11_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_11_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_11_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_11_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_11_nxtber_less $gen3_coeff_11_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_11_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_11_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_11_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_11_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_11_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_11_nxtber_more $gen3_coeff_11_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_11_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_11_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_11_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_11_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_11_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_11_preset_hint $gen3_coeff_11_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_11_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_11_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_11_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_11_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_11_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_11_reqber $gen3_coeff_11_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_11_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_11_sel sup_mode } {

   set legal_values [list "coeff_11" "preset_11"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_11"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_11" "coeff_11"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_11_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_11_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_11_sel $gen3_coeff_11_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_12 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_12 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_12.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_12 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_12 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_12 $gen3_coeff_12 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_12_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_12_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_12_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_12_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_12_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_12_ber_meas $gen3_coeff_12_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_12_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_12_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_12_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_12_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_12_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_12_nxtber_less $gen3_coeff_12_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_12_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_12_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_12_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_12_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_12_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_12_nxtber_more $gen3_coeff_12_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_12_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_12_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_12_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_12_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_12_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_12_preset_hint $gen3_coeff_12_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_12_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_12_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_12_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_12_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_12_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_12_reqber $gen3_coeff_12_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_12_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_12_sel sup_mode } {

   set legal_values [list "coeff_12" "preset_12"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_12"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_12" "coeff_12"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_12_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_12_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_12_sel $gen3_coeff_12_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_13 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_13 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_13.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_13 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_13 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_13 $gen3_coeff_13 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_13_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_13_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_13_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_13_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_13_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_13_ber_meas $gen3_coeff_13_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_13_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_13_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_13_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_13_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_13_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_13_nxtber_less $gen3_coeff_13_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_13_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_13_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_13_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_13_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_13_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_13_nxtber_more $gen3_coeff_13_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_13_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_13_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_13_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_13_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_13_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_13_preset_hint $gen3_coeff_13_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_13_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_13_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_13_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_13_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_13_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_13_reqber $gen3_coeff_13_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_13_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_13_sel sup_mode } {

   set legal_values [list "coeff_13" "preset_13"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_13"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_13" "coeff_13"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_13_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_13_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_13_sel $gen3_coeff_13_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_14 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_14 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_14.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_14 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_14 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_14 $gen3_coeff_14 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_14_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_14_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_14_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_14_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_14_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_14_ber_meas $gen3_coeff_14_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_14_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_14_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_14_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_14_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_14_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_14_nxtber_less $gen3_coeff_14_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_14_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_14_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_14_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_14_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_14_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_14_nxtber_more $gen3_coeff_14_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_14_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_14_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_14_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_14_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_14_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_14_preset_hint $gen3_coeff_14_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_14_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_14_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_14_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_14_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_14_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_14_reqber $gen3_coeff_14_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_14_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_14_sel sup_mode } {

   set legal_values [list "coeff_14" "preset_14"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_14"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_14" "coeff_14"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_14_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_14_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_14_sel $gen3_coeff_14_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_15 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_15 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_15.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_15 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_15 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_15 $gen3_coeff_15 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_15_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_15_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_15_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_15_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_15_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_15_ber_meas $gen3_coeff_15_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_15_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_15_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_15_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_15_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_15_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_15_nxtber_less $gen3_coeff_15_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_15_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_15_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_15_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_15_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_15_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_15_nxtber_more $gen3_coeff_15_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_15_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_15_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_15_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_15_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_15_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_15_preset_hint $gen3_coeff_15_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_15_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_15_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_15_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_15_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_15_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_15_reqber $gen3_coeff_15_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_15_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_15_sel sup_mode } {

   set legal_values [list "coeff_15" "preset_15"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_15"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_15" "coeff_15"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_15_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_15_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_15_sel $gen3_coeff_15_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_16 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_16 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_16.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_16 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_16 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_16 $gen3_coeff_16 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_16_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_16_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_16_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_16_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_16_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_16_ber_meas $gen3_coeff_16_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_16_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_16_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_16_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_16_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_16_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_16_nxtber_less $gen3_coeff_16_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_16_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_16_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_16_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_16_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_16_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_16_nxtber_more $gen3_coeff_16_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_16_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_16_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_16_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_16_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_16_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_16_preset_hint $gen3_coeff_16_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_16_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_16_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_16_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_16_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_16_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_16_reqber $gen3_coeff_16_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_16_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_16_sel sup_mode } {

   set legal_values [list "coeff_16" "preset_16"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_16"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_16" "coeff_16"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_16_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_16_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_16_sel $gen3_coeff_16_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_17 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_17 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 196608]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_17.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_17 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_17 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_17 $gen3_coeff_17 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_17_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_17_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_17_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_17_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_17_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_17_ber_meas $gen3_coeff_17_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_17_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_17_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_17_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_17_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_17_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_17_nxtber_less $gen3_coeff_17_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_17_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_17_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_17_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_17_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_17_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_17_nxtber_more $gen3_coeff_17_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_17_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_17_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_17_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_17_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_17_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_17_preset_hint $gen3_coeff_17_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_17_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_17_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_17_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_17_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_17_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_17_reqber $gen3_coeff_17_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_17_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_17_sel sup_mode } {

   set legal_values [list "coeff_17" "preset_17"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_17"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_17" "coeff_17"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_17_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_17_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_17_sel $gen3_coeff_17_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_18 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_18 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 196609]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_18.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_18 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_18 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_18 $gen3_coeff_18 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_18_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_18_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_18_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_18_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_18_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_18_ber_meas $gen3_coeff_18_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_18_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_18_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_18_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_18_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_18_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_18_nxtber_less $gen3_coeff_18_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_18_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_18_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_18_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_18_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_18_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_18_nxtber_more $gen3_coeff_18_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_18_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_18_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_18_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_18_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_18_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_18_preset_hint $gen3_coeff_18_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_18_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_18_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_18_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_18_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_18_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_18_reqber $gen3_coeff_18_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_18_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_18_sel sup_mode } {

   set legal_values [list "coeff_18" "preset_18"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_18"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_18" "coeff_18"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_18_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_18_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_18_sel $gen3_coeff_18_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_19 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_19 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 196609]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_19.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_19 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_19 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_19 $gen3_coeff_19 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_19_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_19_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_19_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_19_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_19_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_19_ber_meas $gen3_coeff_19_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_19_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_19_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_19_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_19_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_19_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_19_nxtber_less $gen3_coeff_19_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_19_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_19_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_19_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_19_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_19_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_19_nxtber_more $gen3_coeff_19_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_19_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_19_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_19_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_19_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_19_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_19_preset_hint $gen3_coeff_19_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_19_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_19_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_19_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_19_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_19_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_19_reqber $gen3_coeff_19_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_19_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_19_sel sup_mode } {

   set legal_values [list "coeff_19" "preset_19"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_19"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_19" "coeff_19"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_19_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_19_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_19_sel $gen3_coeff_19_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_1_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_1_ber_meas func_mode sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 4]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 4]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_1_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_1_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_1_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_1_ber_meas $gen3_coeff_1_ber_meas $legal_values { func_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_1_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_1_nxtber_less func_mode sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 2]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 1]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_1_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_1_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_1_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_1_nxtber_less $gen3_coeff_1_nxtber_less $legal_values { func_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_1_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_1_nxtber_more func_mode sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 1]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 1]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_1_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_1_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_1_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_1_nxtber_more $gen3_coeff_1_nxtber_more $legal_values { func_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_1_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_1_preset_hint func_mode sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_1_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_1_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_1_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_1_preset_hint $gen3_coeff_1_preset_hint $legal_values { func_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_1_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_1_reqber func_mode sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_1_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_1_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_1_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_1_reqber $gen3_coeff_1_reqber $legal_values { func_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_1_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_1_sel sup_mode } {

   set legal_values [list "coeff_1" "preset_1"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_1"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_1" "coeff_1"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_1_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_1_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_1_sel $gen3_coeff_1_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_2 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_2 gen3_coeff_1 } {

   set legal_values [list 0:262143]

   if [expr { ($gen3_coeff_1==0) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($gen3_coeff_1==1) }] {
         set legal_values [compare_eq $legal_values 1]
      } else {
         if [expr { ($gen3_coeff_1==2) }] {
            set legal_values [compare_eq $legal_values 2]
         } else {
            if [expr { ($gen3_coeff_1==3) }] {
               set legal_values [compare_eq $legal_values 3]
            } else {
               if [expr { ($gen3_coeff_1==4) }] {
                  set legal_values [compare_eq $legal_values 4]
               } else {
                  if [expr { ($gen3_coeff_1==5) }] {
                     set legal_values [compare_eq $legal_values 5]
                  } else {
                     if [expr { ($gen3_coeff_1==6) }] {
                        set legal_values [compare_eq $legal_values 6]
                     } else {
                        if [expr { ($gen3_coeff_1==7) }] {
                           set legal_values [compare_eq $legal_values 7]
                        } else {
                           if [expr { ($gen3_coeff_1==8) }] {
                              set legal_values [compare_eq $legal_values 8]
                           } else {
                              if [expr { ($gen3_coeff_1==9) }] {
                                 set legal_values [compare_eq $legal_values 9]
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_2.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_2 $gen3_coeff_2 $legal_values { gen3_coeff_1 }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_20 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_20 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 196609]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_20.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_20 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_20 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_20 $gen3_coeff_20 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_20_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_20_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_20_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_20_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_20_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_20_ber_meas $gen3_coeff_20_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_20_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_20_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_20_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_20_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_20_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_20_nxtber_less $gen3_coeff_20_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_20_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_20_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_20_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_20_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_20_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_20_nxtber_more $gen3_coeff_20_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_20_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_20_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_20_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_20_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_20_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_20_preset_hint $gen3_coeff_20_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_20_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_20_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_20_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_20_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_20_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_20_reqber $gen3_coeff_20_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_20_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_20_sel sup_mode } {

   set legal_values [list "coeff_20" "preset_20"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_20"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_20" "coeff_20"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_20_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_20_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_20_sel $gen3_coeff_20_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_21 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_21 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 196609]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_21.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_21 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_21 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_21 $gen3_coeff_21 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_21_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_21_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_21_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_21_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_21_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_21_ber_meas $gen3_coeff_21_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_21_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_21_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_21_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_21_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_21_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_21_nxtber_less $gen3_coeff_21_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_21_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_21_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_21_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_21_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_21_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_21_nxtber_more $gen3_coeff_21_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_21_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_21_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_21_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_21_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_21_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_21_preset_hint $gen3_coeff_21_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_21_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_21_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_21_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_21_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_21_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_21_reqber $gen3_coeff_21_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_21_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_21_sel sup_mode } {

   set legal_values [list "coeff_21" "preset_21"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_21"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_21" "coeff_21"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_21_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_21_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_21_sel $gen3_coeff_21_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_22 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_22 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 196609]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_22.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_22 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_22 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_22 $gen3_coeff_22 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_22_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_22_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_22_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_22_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_22_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_22_ber_meas $gen3_coeff_22_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_22_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_22_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 7]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_22_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_22_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_22_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_22_nxtber_less $gen3_coeff_22_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_22_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_22_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_22_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_22_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_22_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_22_nxtber_more $gen3_coeff_22_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_22_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_22_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_22_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_22_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_22_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_22_preset_hint $gen3_coeff_22_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_22_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_22_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_22_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_22_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_22_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_22_reqber $gen3_coeff_22_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_22_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_22_sel sup_mode } {

   set legal_values [list "coeff_22" "preset_22"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_22"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_22" "coeff_22"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_22_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_22_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_22_sel $gen3_coeff_22_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_23 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_23 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 196609]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_23.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_23 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_23 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_23 $gen3_coeff_23 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_23_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_23_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_23_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_23_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_23_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_23_ber_meas $gen3_coeff_23_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_23_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_23_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_23_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_23_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_23_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_23_nxtber_less $gen3_coeff_23_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_23_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_23_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_23_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_23_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_23_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_23_nxtber_more $gen3_coeff_23_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_23_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_23_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_23_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_23_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_23_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_23_preset_hint $gen3_coeff_23_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_23_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_23_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_23_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_23_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_23_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_23_reqber $gen3_coeff_23_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_23_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_23_sel sup_mode } {

   set legal_values [list "coeff_23" "preset_23"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_23"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_23" "coeff_23"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_23_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_23_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_23_sel $gen3_coeff_23_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_24 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_24 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 196609]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_24.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_24 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_24 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_24 $gen3_coeff_24 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_24_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_24_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_24_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_24_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_24_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_24_ber_meas $gen3_coeff_24_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_24_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_24_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_24_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_24_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_24_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_24_nxtber_less $gen3_coeff_24_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_24_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_24_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_24_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_24_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_24_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_24_nxtber_more $gen3_coeff_24_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_24_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_24_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 7]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_24_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_24_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_24_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_24_preset_hint $gen3_coeff_24_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_24_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_24_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_24_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_24_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_24_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_24_reqber $gen3_coeff_24_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_24_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_24_sel sup_mode } {

   set legal_values [list "coeff_24" "preset_24"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_24"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_24" "coeff_24"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_24_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_24_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_24_sel $gen3_coeff_24_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_2_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_2_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 4]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_2_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_2_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_2_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_2_ber_meas $gen3_coeff_2_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_2_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_2_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 2]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_2_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_2_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_2_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_2_nxtber_less $gen3_coeff_2_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_2_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_2_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 2]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_2_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_2_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_2_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_2_nxtber_more $gen3_coeff_2_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_2_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_2_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 7]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_2_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_2_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_2_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_2_preset_hint $gen3_coeff_2_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_2_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_2_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_2_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_2_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_2_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_2_reqber $gen3_coeff_2_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_2_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_2_sel sup_mode } {

   set legal_values [list "coeff_2" "preset_2"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_2"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_2" "coeff_2"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_2_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_2_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_2_sel $gen3_coeff_2_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_3 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_3 gen3_coeff_1 } {

   set legal_values [list 0:262143]

   if [expr { ($gen3_coeff_1==0) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($gen3_coeff_1==1) }] {
         set legal_values [compare_eq $legal_values 1]
      } else {
         if [expr { ($gen3_coeff_1==2) }] {
            set legal_values [compare_eq $legal_values 2]
         } else {
            if [expr { ($gen3_coeff_1==3) }] {
               set legal_values [compare_eq $legal_values 3]
            } else {
               if [expr { ($gen3_coeff_1==4) }] {
                  set legal_values [compare_eq $legal_values 4]
               } else {
                  if [expr { ($gen3_coeff_1==5) }] {
                     set legal_values [compare_eq $legal_values 5]
                  } else {
                     if [expr { ($gen3_coeff_1==6) }] {
                        set legal_values [compare_eq $legal_values 6]
                     } else {
                        if [expr { ($gen3_coeff_1==7) }] {
                           set legal_values [compare_eq $legal_values 7]
                        } else {
                           if [expr { ($gen3_coeff_1==8) }] {
                              set legal_values [compare_eq $legal_values 8]
                           } else {
                              if [expr { ($gen3_coeff_1==9) }] {
                                 set legal_values [compare_eq $legal_values 9]
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_3.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_3 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_3 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_3 $gen3_coeff_3 $legal_values { gen3_coeff_1 }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_3_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_3_ber_meas sim_mode sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 4]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_3_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_3_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_3_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_3_ber_meas $gen3_coeff_3_ber_meas $legal_values { sim_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_3_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_3_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 4]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_3_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_3_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_3_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_3_nxtber_less $gen3_coeff_3_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_3_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_3_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 4]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_3_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_3_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_3_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_3_nxtber_more $gen3_coeff_3_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_3_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_3_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 7]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_3_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_3_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_3_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_3_preset_hint $gen3_coeff_3_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_3_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_3_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 31]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_3_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_3_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_3_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_3_reqber $gen3_coeff_3_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_3_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_3_sel sup_mode } {

   set legal_values [list "coeff_3" "preset_3"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_3"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_3" "coeff_3"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_3_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_3_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_3_sel $gen3_coeff_3_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_4 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_4 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 8]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_4.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_4 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_4 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_4 $gen3_coeff_4 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_4_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_4_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 4]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_4_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_4_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_4_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_4_ber_meas $gen3_coeff_4_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_4_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_4_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 4]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_4_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_4_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_4_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_4_nxtber_less $gen3_coeff_4_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_4_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_4_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 4]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_4_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_4_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_4_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_4_nxtber_more $gen3_coeff_4_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_4_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_4_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 7]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_4_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_4_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_4_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_4_preset_hint $gen3_coeff_4_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_4_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_4_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 31]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_4_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_4_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_4_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_4_reqber $gen3_coeff_4_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_4_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_4_sel sup_mode } {

   set legal_values [list "coeff_4" "preset_4"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_4"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_4" "coeff_4"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_4_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_4_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_4_sel $gen3_coeff_4_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_5 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_5 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_5.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_5 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_5 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_5 $gen3_coeff_5 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_5_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_5_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_5_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_5_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_5_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_5_ber_meas $gen3_coeff_5_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_5_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_5_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_5_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_5_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_5_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_5_nxtber_less $gen3_coeff_5_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_5_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_5_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_5_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_5_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_5_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_5_nxtber_more $gen3_coeff_5_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_5_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_5_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 7]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_5_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_5_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_5_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_5_preset_hint $gen3_coeff_5_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_5_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_5_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_5_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_5_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_5_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_5_reqber $gen3_coeff_5_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_5_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_5_sel sup_mode } {

   set legal_values [list "coeff_5" "preset_5"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_5"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_5" "coeff_5"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_5_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_5_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_5_sel $gen3_coeff_5_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_6 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_6 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_6.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_6 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_6 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_6 $gen3_coeff_6 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_6_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_6_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_6_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_6_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_6_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_6_ber_meas $gen3_coeff_6_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_6_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_6_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_6_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_6_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_6_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_6_nxtber_less $gen3_coeff_6_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_6_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_6_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_6_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_6_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_6_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_6_nxtber_more $gen3_coeff_6_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_6_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_6_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_6_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_6_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_6_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_6_preset_hint $gen3_coeff_6_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_6_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_6_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_6_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_6_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_6_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_6_reqber $gen3_coeff_6_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_6_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_6_sel sup_mode } {

   set legal_values [list "coeff_6" "preset_6"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_6"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_6" "coeff_6"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_6_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_6_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_6_sel $gen3_coeff_6_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_7 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_7 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_7.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_7 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_7 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_7 $gen3_coeff_7 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_7_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_7_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_7_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_7_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_7_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_7_ber_meas $gen3_coeff_7_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_7_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_7_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_7_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_7_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_7_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_7_nxtber_less $gen3_coeff_7_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_7_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_7_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_7_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_7_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_7_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_7_nxtber_more $gen3_coeff_7_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_7_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_7_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_7_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_7_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_7_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_7_preset_hint $gen3_coeff_7_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_7_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_7_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_7_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_7_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_7_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_7_reqber $gen3_coeff_7_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_7_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_7_sel sup_mode } {

   set legal_values [list "coeff_7" "preset_7"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_7"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_7" "coeff_7"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_7_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_7_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_7_sel $gen3_coeff_7_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_8 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_8 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_8.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_8 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_8 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_8 $gen3_coeff_8 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_8_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_8_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_8_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_8_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_8_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_8_ber_meas $gen3_coeff_8_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_8_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_8_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_8_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_8_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_8_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_8_nxtber_less $gen3_coeff_8_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_8_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_8_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_8_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_8_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_8_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_8_nxtber_more $gen3_coeff_8_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_8_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_8_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_8_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_8_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_8_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_8_preset_hint $gen3_coeff_8_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_8_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_8_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_8_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_8_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_8_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_8_reqber $gen3_coeff_8_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_8_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_8_sel sup_mode } {

   set legal_values [list "coeff_8" "preset_8"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_8"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_8" "coeff_8"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_8_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_8_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_8_sel $gen3_coeff_8_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_9 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_9 sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_9.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_9 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_9 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_9 $gen3_coeff_9 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_9_ber_meas { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_9_ber_meas sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_9_ber_meas.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_9_ber_meas $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_9_ber_meas $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_9_ber_meas $gen3_coeff_9_ber_meas $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_9_nxtber_less { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_9_nxtber_less sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_9_nxtber_less.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_9_nxtber_less $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_9_nxtber_less $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_9_nxtber_less $gen3_coeff_9_nxtber_less $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_9_nxtber_more { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_9_nxtber_more sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_9_nxtber_more.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_9_nxtber_more $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_9_nxtber_more $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_9_nxtber_more $gen3_coeff_9_nxtber_more $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_9_preset_hint { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_9_preset_hint sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_9_preset_hint.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_9_preset_hint $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_9_preset_hint $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_9_preset_hint $gen3_coeff_9_preset_hint $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_9_reqber { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_9_reqber sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_9_reqber.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_9_reqber $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_9_reqber $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_9_reqber $gen3_coeff_9_reqber $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_9_sel { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_9_sel sup_mode } {

   set legal_values [list "coeff_9" "preset_9"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "preset_9"]]
   } else {
      set legal_values [intersect $legal_values [list "preset_9" "coeff_9"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_9_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_9_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_9_sel $gen3_coeff_9_sel $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_delay_count { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_delay_count sup_mode } {

   set legal_values [list 0:127]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 125]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_coeff_delay_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_coeff_delay_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_coeff_delay_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_coeff_delay_count $gen3_coeff_delay_count $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_coeff_errchk { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_coeff_errchk lane_rate sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($lane_rate=="gen3") }] {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "enable"]]
      } else {
         set legal_values [intersect $legal_values [list "disable" "enable"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_coeff_errchk.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_coeff_errchk $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_coeff_errchk $gen3_coeff_errchk $legal_values { lane_rate sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_dcbal_en { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_dcbal_en sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "true"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_dcbal_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_dcbal_en $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_dcbal_en $gen3_dcbal_en $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_diffclock_nfts_count { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_diffclock_nfts_count sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 128]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_diffclock_nfts_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_diffclock_nfts_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_diffclock_nfts_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_diffclock_nfts_count $gen3_diffclock_nfts_count $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_force_local_coeff { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_force_local_coeff lane_rate sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($lane_rate=="gen3") }] {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_force_local_coeff.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_force_local_coeff $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_force_local_coeff $gen3_force_local_coeff $legal_values { lane_rate sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_full_swing { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_full_swing gen3_half_swing sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 60]
   } else {
      if [expr { ($gen3_half_swing=="false") }] {
         set legal_values [compare_le $legal_values 63]
         set legal_values [compare_ge $legal_values 24]
      } else {
         set legal_values [compare_le $legal_values 63]
         set legal_values [compare_ge $legal_values 12]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_full_swing.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_full_swing $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_full_swing $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_full_swing $gen3_full_swing $legal_values { gen3_half_swing sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_half_swing { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_half_swing lane_rate sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($lane_rate=="gen3") }] {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_half_swing.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_half_swing $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_half_swing $gen3_half_swing $legal_values { lane_rate sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_low_freq { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_low_freq gen3_full_swing sup_mode } {

   set legal_values [list 0:63]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($gen3_full_swing==20) }] {
         set legal_values [compare_eq $legal_values 10]
      }
      if [expr { ($gen3_full_swing==21) }] {
         set legal_values [compare_eq $legal_values 11]
      }
      if [expr { ($gen3_full_swing==22) }] {
         set legal_values [compare_eq $legal_values 11]
      }
      if [expr { ($gen3_full_swing==23) }] {
         set legal_values [compare_eq $legal_values 11]
      }
      if [expr { ($gen3_full_swing==24) }] {
         set legal_values [compare_eq $legal_values 11]
      }
      if [expr { ($gen3_full_swing==25) }] {
         set legal_values [compare_eq $legal_values 11]
      }
      if [expr { ($gen3_full_swing==26) }] {
         set legal_values [compare_eq $legal_values 11]
      }
      if [expr { ($gen3_full_swing==27) }] {
         set legal_values [compare_eq $legal_values 11]
      }
      if [expr { ($gen3_full_swing==28) }] {
         set legal_values [compare_eq $legal_values 14]
      }
      if [expr { ($gen3_full_swing==29) }] {
         set legal_values [compare_eq $legal_values 12]
      }
      if [expr { ($gen3_full_swing==30) }] {
         set legal_values [compare_eq $legal_values 12]
      }
      if [expr { ($gen3_full_swing==31) }] {
         set legal_values [compare_eq $legal_values 12]
      }
      if [expr { ($gen3_full_swing==32) }] {
         set legal_values [compare_eq $legal_values 12]
      }
      if [expr { ($gen3_full_swing==33) }] {
         set legal_values [compare_eq $legal_values 12]
      }
      if [expr { ($gen3_full_swing==34) }] {
         set legal_values [compare_eq $legal_values 12]
      }
      if [expr { ($gen3_full_swing==35) }] {
         set legal_values [compare_eq $legal_values 12]
      }
      if [expr { ($gen3_full_swing==36) }] {
         set legal_values [compare_eq $legal_values 12]
      }
      if [expr { ($gen3_full_swing==37) }] {
         set legal_values [compare_eq $legal_values 13]
      }
      if [expr { ($gen3_full_swing==38) }] {
         set legal_values [compare_eq $legal_values 13]
      }
      if [expr { ($gen3_full_swing==39) }] {
         set legal_values [compare_eq $legal_values 13]
      }
      if [expr { ($gen3_full_swing==40) }] {
         set legal_values [compare_eq $legal_values 13]
      }
      if [expr { ($gen3_full_swing==41) }] {
         set legal_values [compare_eq $legal_values 13]
      }
      if [expr { ($gen3_full_swing==42) }] {
         set legal_values [compare_eq $legal_values 13]
      }
      if [expr { ($gen3_full_swing==43) }] {
         set legal_values [compare_eq $legal_values 13]
      }
      if [expr { ($gen3_full_swing==44) }] {
         set legal_values [compare_eq $legal_values 13]
      }
      if [expr { ($gen3_full_swing==45) }] {
         set legal_values [compare_eq $legal_values 14]
      }
      if [expr { ($gen3_full_swing==46) }] {
         set legal_values [compare_eq $legal_values 14]
      }
      if [expr { ($gen3_full_swing==47) }] {
         set legal_values [compare_eq $legal_values 14]
      }
      if [expr { ($gen3_full_swing==48) }] {
         set legal_values [compare_eq $legal_values 14]
      }
      if [expr { ($gen3_full_swing==49) }] {
         set legal_values [compare_eq $legal_values 14]
      }
      if [expr { ($gen3_full_swing==50) }] {
         set legal_values [compare_eq $legal_values 14]
      }
      if [expr { ($gen3_full_swing==51) }] {
         set legal_values [compare_eq $legal_values 14]
      }
      if [expr { ($gen3_full_swing==52) }] {
         set legal_values [compare_eq $legal_values 14]
      }
      if [expr { ($gen3_full_swing==53) }] {
         set legal_values [compare_eq $legal_values 15]
      }
      if [expr { ($gen3_full_swing==54) }] {
         set legal_values [compare_eq $legal_values 15]
      }
      if [expr { ($gen3_full_swing==55) }] {
         set legal_values [compare_eq $legal_values 15]
      }
      if [expr { ($gen3_full_swing==56) }] {
         set legal_values [compare_eq $legal_values 15]
      }
      if [expr { ($gen3_full_swing==57) }] {
         set legal_values [compare_eq $legal_values 15]
      }
      if [expr { ($gen3_full_swing==58) }] {
         set legal_values [compare_eq $legal_values 15]
      }
      if [expr { ($gen3_full_swing==59) }] {
         set legal_values [compare_eq $legal_values 15]
      }
      if [expr { ($gen3_full_swing==60) }] {
         set legal_values [compare_eq $legal_values 20]
      }
      if [expr { ($gen3_full_swing==61) }] {
         set legal_values [compare_eq $legal_values 16]
      }
      if [expr { ($gen3_full_swing==62) }] {
         set legal_values [compare_eq $legal_values 16]
      }
      if [expr { ($gen3_full_swing==63) }] {
         set legal_values [compare_eq $legal_values 16]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_low_freq.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_low_freq $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_low_freq $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_low_freq $gen3_low_freq $legal_values { gen3_full_swing sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_paritychk { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_paritychk lane_rate sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($lane_rate=="gen3") }] {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "enable"]]
      } else {
         set legal_values [intersect $legal_values [list "disable" "enable"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_paritychk.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_paritychk $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_paritychk $gen3_paritychk $legal_values { lane_rate sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_pl_framing_err_dis { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_pl_framing_err_dis sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_pl_framing_err_dis.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_pl_framing_err_dis $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_pl_framing_err_dis $gen3_pl_framing_err_dis $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_preset_coeff_1 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_preset_coeff_1 gen3_full_swing sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($gen3_full_swing==20) }] {
         set legal_values [compare_eq $legal_values 21440]
      }
      if [expr { ($gen3_full_swing==21) }] {
         set legal_values [compare_eq $legal_values 25536]
      }
      if [expr { ($gen3_full_swing==22) }] {
         set legal_values [compare_eq $legal_values 25600]
      }
      if [expr { ($gen3_full_swing==23) }] {
         set legal_values [compare_eq $legal_values 25664]
      }
      if [expr { ($gen3_full_swing==24) }] {
         set legal_values [compare_eq $legal_values 25728]
      }
      if [expr { ($gen3_full_swing==25) }] {
         set legal_values [compare_eq $legal_values 29824]
      }
      if [expr { ($gen3_full_swing==26) }] {
         set legal_values [compare_eq $legal_values 29888]
      }
      if [expr { ($gen3_full_swing==27) }] {
         set legal_values [compare_eq $legal_values 29952]
      }
      if [expr { ($gen3_full_swing==28) }] {
         set legal_values [compare_eq $legal_values 30016]
      }
      if [expr { ($gen3_full_swing==29) }] {
         set legal_values [compare_eq $legal_values 34112]
      }
      if [expr { ($gen3_full_swing==30) }] {
         set legal_values [compare_eq $legal_values 34176]
      }
      if [expr { ($gen3_full_swing==31) }] {
         set legal_values [compare_eq $legal_values 34240]
      }
      if [expr { ($gen3_full_swing==32) }] {
         set legal_values [compare_eq $legal_values 34304]
      }
      if [expr { ($gen3_full_swing==33) }] {
         set legal_values [compare_eq $legal_values 38400]
      }
      if [expr { ($gen3_full_swing==34) }] {
         set legal_values [compare_eq $legal_values 38464]
      }
      if [expr { ($gen3_full_swing==35) }] {
         set legal_values [compare_eq $legal_values 38528]
      }
      if [expr { ($gen3_full_swing==36) }] {
         set legal_values [compare_eq $legal_values 38592]
      }
      if [expr { ($gen3_full_swing==37) }] {
         set legal_values [compare_eq $legal_values 42688]
      }
      if [expr { ($gen3_full_swing==38) }] {
         set legal_values [compare_eq $legal_values 42752]
      }
      if [expr { ($gen3_full_swing==39) }] {
         set legal_values [compare_eq $legal_values 42816]
      }
      if [expr { ($gen3_full_swing==40) }] {
         set legal_values [compare_eq $legal_values 42880]
      }
      if [expr { ($gen3_full_swing==41) }] {
         set legal_values [compare_eq $legal_values 46976]
      }
      if [expr { ($gen3_full_swing==42) }] {
         set legal_values [compare_eq $legal_values 47040]
      }
      if [expr { ($gen3_full_swing==43) }] {
         set legal_values [compare_eq $legal_values 47104]
      }
      if [expr { ($gen3_full_swing==44) }] {
         set legal_values [compare_eq $legal_values 47168]
      }
      if [expr { ($gen3_full_swing==45) }] {
         set legal_values [compare_eq $legal_values 51264]
      }
      if [expr { ($gen3_full_swing==46) }] {
         set legal_values [compare_eq $legal_values 51328]
      }
      if [expr { ($gen3_full_swing==47) }] {
         set legal_values [compare_eq $legal_values 51392]
      }
      if [expr { ($gen3_full_swing==48) }] {
         set legal_values [compare_eq $legal_values 51456]
      }
      if [expr { ($gen3_full_swing==49) }] {
         set legal_values [compare_eq $legal_values 55552]
      }
      if [expr { ($gen3_full_swing==50) }] {
         set legal_values [compare_eq $legal_values 55616]
      }
      if [expr { ($gen3_full_swing==51) }] {
         set legal_values [compare_eq $legal_values 55680]
      }
      if [expr { ($gen3_full_swing==52) }] {
         set legal_values [compare_eq $legal_values 55744]
      }
      if [expr { ($gen3_full_swing==53) }] {
         set legal_values [compare_eq $legal_values 59840]
      }
      if [expr { ($gen3_full_swing==54) }] {
         set legal_values [compare_eq $legal_values 59904]
      }
      if [expr { ($gen3_full_swing==55) }] {
         set legal_values [compare_eq $legal_values 59968]
      }
      if [expr { ($gen3_full_swing==56) }] {
         set legal_values [compare_eq $legal_values 60032]
      }
      if [expr { ($gen3_full_swing==57) }] {
         set legal_values [compare_eq $legal_values 64128]
      }
      if [expr { ($gen3_full_swing==58) }] {
         set legal_values [compare_eq $legal_values 64192]
      }
      if [expr { ($gen3_full_swing==59) }] {
         set legal_values [compare_eq $legal_values 64256]
      }
      if [expr { ($gen3_full_swing==60) }] {
         set legal_values [compare_eq $legal_values 64320]
      }
      if [expr { ($gen3_full_swing==61) }] {
         set legal_values [compare_eq $legal_values 68416]
      }
      if [expr { ($gen3_full_swing==62) }] {
         set legal_values [compare_eq $legal_values 68480]
      }
      if [expr { ($gen3_full_swing==63) }] {
         set legal_values [compare_eq $legal_values 68544]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_preset_coeff_1.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_preset_coeff_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_preset_coeff_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_preset_coeff_1 $gen3_preset_coeff_1 $legal_values { gen3_full_swing sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_preset_coeff_10 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_preset_coeff_10 gen3_full_swing sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($gen3_full_swing==20) }] {
         set legal_values [compare_eq $legal_values 1028]
      }
      if [expr { ($gen3_full_swing==21) }] {
         set legal_values [compare_eq $legal_values 1092]
      }
      if [expr { ($gen3_full_swing==22) }] {
         set legal_values [compare_eq $legal_values 1156]
      }
      if [expr { ($gen3_full_swing==23) }] {
         set legal_values [compare_eq $legal_values 1220]
      }
      if [expr { ($gen3_full_swing==24) }] {
         set legal_values [compare_eq $legal_values 1284]
      }
      if [expr { ($gen3_full_swing==25) }] {
         set legal_values [compare_eq $legal_values 1285]
      }
      if [expr { ($gen3_full_swing==26) }] {
         set legal_values [compare_eq $legal_values 1349]
      }
      if [expr { ($gen3_full_swing==27) }] {
         set legal_values [compare_eq $legal_values 1413]
      }
      if [expr { ($gen3_full_swing==28) }] {
         set legal_values [compare_eq $legal_values 1477]
      }
      if [expr { ($gen3_full_swing==29) }] {
         set legal_values [compare_eq $legal_values 1541]
      }
      if [expr { ($gen3_full_swing==30) }] {
         set legal_values [compare_eq $legal_values 1605]
      }
      if [expr { ($gen3_full_swing==31) }] {
         set legal_values [compare_eq $legal_values 1606]
      }
      if [expr { ($gen3_full_swing==32) }] {
         set legal_values [compare_eq $legal_values 1670]
      }
      if [expr { ($gen3_full_swing==33) }] {
         set legal_values [compare_eq $legal_values 1734]
      }
      if [expr { ($gen3_full_swing==34) }] {
         set legal_values [compare_eq $legal_values 1798]
      }
      if [expr { ($gen3_full_swing==35) }] {
         set legal_values [compare_eq $legal_values 1862]
      }
      if [expr { ($gen3_full_swing==36) }] {
         set legal_values [compare_eq $legal_values 1926]
      }
      if [expr { ($gen3_full_swing==37) }] {
         set legal_values [compare_eq $legal_values 1927]
      }
      if [expr { ($gen3_full_swing==38) }] {
         set legal_values [compare_eq $legal_values 1991]
      }
      if [expr { ($gen3_full_swing==39) }] {
         set legal_values [compare_eq $legal_values 2055]
      }
      if [expr { ($gen3_full_swing==40) }] {
         set legal_values [compare_eq $legal_values 2119]
      }
      if [expr { ($gen3_full_swing==41) }] {
         set legal_values [compare_eq $legal_values 2183]
      }
      if [expr { ($gen3_full_swing==42) }] {
         set legal_values [compare_eq $legal_values 2247]
      }
      if [expr { ($gen3_full_swing==43) }] {
         set legal_values [compare_eq $legal_values 2248]
      }
      if [expr { ($gen3_full_swing==44) }] {
         set legal_values [compare_eq $legal_values 2312]
      }
      if [expr { ($gen3_full_swing==45) }] {
         set legal_values [compare_eq $legal_values 2376]
      }
      if [expr { ($gen3_full_swing==46) }] {
         set legal_values [compare_eq $legal_values 2440]
      }
      if [expr { ($gen3_full_swing==47) }] {
         set legal_values [compare_eq $legal_values 2504]
      }
      if [expr { ($gen3_full_swing==48) }] {
         set legal_values [compare_eq $legal_values 2568]
      }
      if [expr { ($gen3_full_swing==49) }] {
         set legal_values [compare_eq $legal_values 2569]
      }
      if [expr { ($gen3_full_swing==50) }] {
         set legal_values [compare_eq $legal_values 2633]
      }
      if [expr { ($gen3_full_swing==51) }] {
         set legal_values [compare_eq $legal_values 2697]
      }
      if [expr { ($gen3_full_swing==52) }] {
         set legal_values [compare_eq $legal_values 2761]
      }
      if [expr { ($gen3_full_swing==53) }] {
         set legal_values [compare_eq $legal_values 2825]
      }
      if [expr { ($gen3_full_swing==54) }] {
         set legal_values [compare_eq $legal_values 2889]
      }
      if [expr { ($gen3_full_swing==55) }] {
         set legal_values [compare_eq $legal_values 2890]
      }
      if [expr { ($gen3_full_swing==56) }] {
         set legal_values [compare_eq $legal_values 2954]
      }
      if [expr { ($gen3_full_swing==57) }] {
         set legal_values [compare_eq $legal_values 3018]
      }
      if [expr { ($gen3_full_swing==58) }] {
         set legal_values [compare_eq $legal_values 3082]
      }
      if [expr { ($gen3_full_swing==59) }] {
         set legal_values [compare_eq $legal_values 3146]
      }
      if [expr { ($gen3_full_swing==60) }] {
         set legal_values [compare_eq $legal_values 3210]
      }
      if [expr { ($gen3_full_swing==61) }] {
         set legal_values [compare_eq $legal_values 3211]
      }
      if [expr { ($gen3_full_swing==62) }] {
         set legal_values [compare_eq $legal_values 3275]
      }
      if [expr { ($gen3_full_swing==63) }] {
         set legal_values [compare_eq $legal_values 3339]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_preset_coeff_10.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_preset_coeff_10 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_preset_coeff_10 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_preset_coeff_10 $gen3_preset_coeff_10 $legal_values { gen3_full_swing sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_preset_coeff_11 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_preset_coeff_11 gen3_full_swing sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($gen3_full_swing==20) }] {
         set legal_values [compare_eq $legal_values 21440]
      }
      if [expr { ($gen3_full_swing==21) }] {
         set legal_values [compare_eq $legal_values 21504]
      }
      if [expr { ($gen3_full_swing==22) }] {
         set legal_values [compare_eq $legal_values 21568]
      }
      if [expr { ($gen3_full_swing==23) }] {
         set legal_values [compare_eq $legal_values 25664]
      }
      if [expr { ($gen3_full_swing==24) }] {
         set legal_values [compare_eq $legal_values 25728]
      }
      if [expr { ($gen3_full_swing==25) }] {
         set legal_values [compare_eq $legal_values 29824]
      }
      if [expr { ($gen3_full_swing==26) }] {
         set legal_values [compare_eq $legal_values 29888]
      }
      if [expr { ($gen3_full_swing==27) }] {
         set legal_values [compare_eq $legal_values 33984]
      }
      if [expr { ($gen3_full_swing==28) }] {
         set legal_values [compare_eq $legal_values 34048]
      }
      if [expr { ($gen3_full_swing==29) }] {
         set legal_values [compare_eq $legal_values 34112]
      }
      if [expr { ($gen3_full_swing==30) }] {
         set legal_values [compare_eq $legal_values 38208]
      }
      if [expr { ($gen3_full_swing==31) }] {
         set legal_values [compare_eq $legal_values 38272]
      }
      if [expr { ($gen3_full_swing==32) }] {
         set legal_values [compare_eq $legal_values 42368]
      }
      if [expr { ($gen3_full_swing==33) }] {
         set legal_values [compare_eq $legal_values 42432]
      }
      if [expr { ($gen3_full_swing==34) }] {
         set legal_values [compare_eq $legal_values 46528]
      }
      if [expr { ($gen3_full_swing==35) }] {
         set legal_values [compare_eq $legal_values 46592]
      }
      if [expr { ($gen3_full_swing==36) }] {
         set legal_values [compare_eq $legal_values 50688]
      }
      if [expr { ($gen3_full_swing==37) }] {
         set legal_values [compare_eq $legal_values 50752]
      }
      if [expr { ($gen3_full_swing==38) }] {
         set legal_values [compare_eq $legal_values 50816]
      }
      if [expr { ($gen3_full_swing==39) }] {
         set legal_values [compare_eq $legal_values 54912]
      }
      if [expr { ($gen3_full_swing==40) }] {
         set legal_values [compare_eq $legal_values 54976]
      }
      if [expr { ($gen3_full_swing==41) }] {
         set legal_values [compare_eq $legal_values 59072]
      }
      if [expr { ($gen3_full_swing==42) }] {
         set legal_values [compare_eq $legal_values 59136]
      }
      if [expr { ($gen3_full_swing==43) }] {
         set legal_values [compare_eq $legal_values 63232]
      }
      if [expr { ($gen3_full_swing==44) }] {
         set legal_values [compare_eq $legal_values 63296]
      }
      if [expr { ($gen3_full_swing==45) }] {
         set legal_values [compare_eq $legal_values 63360]
      }
      if [expr { ($gen3_full_swing==46) }] {
         set legal_values [compare_eq $legal_values 67456]
      }
      if [expr { ($gen3_full_swing==47) }] {
         set legal_values [compare_eq $legal_values 67520]
      }
      if [expr { ($gen3_full_swing==48) }] {
         set legal_values [compare_eq $legal_values 71616]
      }
      if [expr { ($gen3_full_swing==49) }] {
         set legal_values [compare_eq $legal_values 71680]
      }
      if [expr { ($gen3_full_swing==50) }] {
         set legal_values [compare_eq $legal_values 75776]
      }
      if [expr { ($gen3_full_swing==51) }] {
         set legal_values [compare_eq $legal_values 75840]
      }
      if [expr { ($gen3_full_swing==52) }] {
         set legal_values [compare_eq $legal_values 79936]
      }
      if [expr { ($gen3_full_swing==53) }] {
         set legal_values [compare_eq $legal_values 80000]
      }
      if [expr { ($gen3_full_swing==54) }] {
         set legal_values [compare_eq $legal_values 80064]
      }
      if [expr { ($gen3_full_swing==55) }] {
         set legal_values [compare_eq $legal_values 84160]
      }
      if [expr { ($gen3_full_swing==56) }] {
         set legal_values [compare_eq $legal_values 84224]
      }
      if [expr { ($gen3_full_swing==57) }] {
         set legal_values [compare_eq $legal_values 88320]
      }
      if [expr { ($gen3_full_swing==58) }] {
         set legal_values [compare_eq $legal_values 88384]
      }
      if [expr { ($gen3_full_swing==59) }] {
         set legal_values [compare_eq $legal_values 92480]
      }
      if [expr { ($gen3_full_swing==60) }] {
         set legal_values [compare_eq $legal_values 84480]
      }
      if [expr { ($gen3_full_swing==61) }] {
         set legal_values [compare_eq $legal_values 92608]
      }
      if [expr { ($gen3_full_swing==62) }] {
         set legal_values [compare_eq $legal_values 96704]
      }
      if [expr { ($gen3_full_swing==63) }] {
         set legal_values [compare_eq $legal_values 96768]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_preset_coeff_11.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_preset_coeff_11 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_preset_coeff_11 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_preset_coeff_11 $gen3_preset_coeff_11 $legal_values { gen3_full_swing sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_preset_coeff_2 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_preset_coeff_2 gen3_full_swing sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($gen3_full_swing==20) }] {
         set legal_values [compare_eq $legal_values 17408]
      }
      if [expr { ($gen3_full_swing==21) }] {
         set legal_values [compare_eq $legal_values 17472]
      }
      if [expr { ($gen3_full_swing==22) }] {
         set legal_values [compare_eq $legal_values 17536]
      }
      if [expr { ($gen3_full_swing==23) }] {
         set legal_values [compare_eq $legal_values 17600]
      }
      if [expr { ($gen3_full_swing==24) }] {
         set legal_values [compare_eq $legal_values 17664]
      }
      if [expr { ($gen3_full_swing==25) }] {
         set legal_values [compare_eq $legal_values 21760]
      }
      if [expr { ($gen3_full_swing==26) }] {
         set legal_values [compare_eq $legal_values 21824]
      }
      if [expr { ($gen3_full_swing==27) }] {
         set legal_values [compare_eq $legal_values 21888]
      }
      if [expr { ($gen3_full_swing==28) }] {
         set legal_values [compare_eq $legal_values 21952]
      }
      if [expr { ($gen3_full_swing==29) }] {
         set legal_values [compare_eq $legal_values 22016]
      }
      if [expr { ($gen3_full_swing==30) }] {
         set legal_values [compare_eq $legal_values 22080]
      }
      if [expr { ($gen3_full_swing==31) }] {
         set legal_values [compare_eq $legal_values 26176]
      }
      if [expr { ($gen3_full_swing==32) }] {
         set legal_values [compare_eq $legal_values 26240]
      }
      if [expr { ($gen3_full_swing==33) }] {
         set legal_values [compare_eq $legal_values 26304]
      }
      if [expr { ($gen3_full_swing==34) }] {
         set legal_values [compare_eq $legal_values 26368]
      }
      if [expr { ($gen3_full_swing==35) }] {
         set legal_values [compare_eq $legal_values 26432]
      }
      if [expr { ($gen3_full_swing==36) }] {
         set legal_values [compare_eq $legal_values 26496]
      }
      if [expr { ($gen3_full_swing==37) }] {
         set legal_values [compare_eq $legal_values 30592]
      }
      if [expr { ($gen3_full_swing==38) }] {
         set legal_values [compare_eq $legal_values 30656]
      }
      if [expr { ($gen3_full_swing==39) }] {
         set legal_values [compare_eq $legal_values 30720]
      }
      if [expr { ($gen3_full_swing==40) }] {
         set legal_values [compare_eq $legal_values 30784]
      }
      if [expr { ($gen3_full_swing==41) }] {
         set legal_values [compare_eq $legal_values 30848]
      }
      if [expr { ($gen3_full_swing==42) }] {
         set legal_values [compare_eq $legal_values 30912]
      }
      if [expr { ($gen3_full_swing==43) }] {
         set legal_values [compare_eq $legal_values 35008]
      }
      if [expr { ($gen3_full_swing==44) }] {
         set legal_values [compare_eq $legal_values 35072]
      }
      if [expr { ($gen3_full_swing==45) }] {
         set legal_values [compare_eq $legal_values 35136]
      }
      if [expr { ($gen3_full_swing==46) }] {
         set legal_values [compare_eq $legal_values 35200]
      }
      if [expr { ($gen3_full_swing==47) }] {
         set legal_values [compare_eq $legal_values 35264]
      }
      if [expr { ($gen3_full_swing==48) }] {
         set legal_values [compare_eq $legal_values 35328]
      }
      if [expr { ($gen3_full_swing==49) }] {
         set legal_values [compare_eq $legal_values 39424]
      }
      if [expr { ($gen3_full_swing==50) }] {
         set legal_values [compare_eq $legal_values 39488]
      }
      if [expr { ($gen3_full_swing==51) }] {
         set legal_values [compare_eq $legal_values 39552]
      }
      if [expr { ($gen3_full_swing==52) }] {
         set legal_values [compare_eq $legal_values 39616]
      }
      if [expr { ($gen3_full_swing==53) }] {
         set legal_values [compare_eq $legal_values 39680]
      }
      if [expr { ($gen3_full_swing==54) }] {
         set legal_values [compare_eq $legal_values 39744]
      }
      if [expr { ($gen3_full_swing==55) }] {
         set legal_values [compare_eq $legal_values 43840]
      }
      if [expr { ($gen3_full_swing==56) }] {
         set legal_values [compare_eq $legal_values 43904]
      }
      if [expr { ($gen3_full_swing==57) }] {
         set legal_values [compare_eq $legal_values 43968]
      }
      if [expr { ($gen3_full_swing==58) }] {
         set legal_values [compare_eq $legal_values 44032]
      }
      if [expr { ($gen3_full_swing==59) }] {
         set legal_values [compare_eq $legal_values 44096]
      }
      if [expr { ($gen3_full_swing==60) }] {
         set legal_values [compare_eq $legal_values 44160]
      }
      if [expr { ($gen3_full_swing==61) }] {
         set legal_values [compare_eq $legal_values 48256]
      }
      if [expr { ($gen3_full_swing==62) }] {
         set legal_values [compare_eq $legal_values 48320]
      }
      if [expr { ($gen3_full_swing==63) }] {
         set legal_values [compare_eq $legal_values 48384]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_preset_coeff_2.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_preset_coeff_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_preset_coeff_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_preset_coeff_2 $gen3_preset_coeff_2 $legal_values { gen3_full_swing sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_preset_coeff_3 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_preset_coeff_3 gen3_full_swing sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($gen3_full_swing==20) }] {
         set legal_values [compare_eq $legal_values 17408]
      }
      if [expr { ($gen3_full_swing==21) }] {
         set legal_values [compare_eq $legal_values 21504]
      }
      if [expr { ($gen3_full_swing==22) }] {
         set legal_values [compare_eq $legal_values 21568]
      }
      if [expr { ($gen3_full_swing==23) }] {
         set legal_values [compare_eq $legal_values 21632]
      }
      if [expr { ($gen3_full_swing==24) }] {
         set legal_values [compare_eq $legal_values 21696]
      }
      if [expr { ($gen3_full_swing==25) }] {
         set legal_values [compare_eq $legal_values 21760]
      }
      if [expr { ($gen3_full_swing==26) }] {
         set legal_values [compare_eq $legal_values 25856]
      }
      if [expr { ($gen3_full_swing==27) }] {
         set legal_values [compare_eq $legal_values 25920]
      }
      if [expr { ($gen3_full_swing==28) }] {
         set legal_values [compare_eq $legal_values 25984]
      }
      if [expr { ($gen3_full_swing==29) }] {
         set legal_values [compare_eq $legal_values 26048]
      }
      if [expr { ($gen3_full_swing==30) }] {
         set legal_values [compare_eq $legal_values 26112]
      }
      if [expr { ($gen3_full_swing==31) }] {
         set legal_values [compare_eq $legal_values 30208]
      }
      if [expr { ($gen3_full_swing==32) }] {
         set legal_values [compare_eq $legal_values 30272]
      }
      if [expr { ($gen3_full_swing==33) }] {
         set legal_values [compare_eq $legal_values 30336]
      }
      if [expr { ($gen3_full_swing==34) }] {
         set legal_values [compare_eq $legal_values 30400]
      }
      if [expr { ($gen3_full_swing==35) }] {
         set legal_values [compare_eq $legal_values 30464]
      }
      if [expr { ($gen3_full_swing==36) }] {
         set legal_values [compare_eq $legal_values 34560]
      }
      if [expr { ($gen3_full_swing==37) }] {
         set legal_values [compare_eq $legal_values 34624]
      }
      if [expr { ($gen3_full_swing==38) }] {
         set legal_values [compare_eq $legal_values 34688]
      }
      if [expr { ($gen3_full_swing==39) }] {
         set legal_values [compare_eq $legal_values 34752]
      }
      if [expr { ($gen3_full_swing==40) }] {
         set legal_values [compare_eq $legal_values 34816]
      }
      if [expr { ($gen3_full_swing==41) }] {
         set legal_values [compare_eq $legal_values 38912]
      }
      if [expr { ($gen3_full_swing==42) }] {
         set legal_values [compare_eq $legal_values 38976]
      }
      if [expr { ($gen3_full_swing==43) }] {
         set legal_values [compare_eq $legal_values 39040]
      }
      if [expr { ($gen3_full_swing==44) }] {
         set legal_values [compare_eq $legal_values 39104]
      }
      if [expr { ($gen3_full_swing==45) }] {
         set legal_values [compare_eq $legal_values 39168]
      }
      if [expr { ($gen3_full_swing==46) }] {
         set legal_values [compare_eq $legal_values 43264]
      }
      if [expr { ($gen3_full_swing==47) }] {
         set legal_values [compare_eq $legal_values 43328]
      }
      if [expr { ($gen3_full_swing==48) }] {
         set legal_values [compare_eq $legal_values 43392]
      }
      if [expr { ($gen3_full_swing==49) }] {
         set legal_values [compare_eq $legal_values 43456]
      }
      if [expr { ($gen3_full_swing==50) }] {
         set legal_values [compare_eq $legal_values 43520]
      }
      if [expr { ($gen3_full_swing==51) }] {
         set legal_values [compare_eq $legal_values 47616]
      }
      if [expr { ($gen3_full_swing==52) }] {
         set legal_values [compare_eq $legal_values 47680]
      }
      if [expr { ($gen3_full_swing==53) }] {
         set legal_values [compare_eq $legal_values 47744]
      }
      if [expr { ($gen3_full_swing==54) }] {
         set legal_values [compare_eq $legal_values 47808]
      }
      if [expr { ($gen3_full_swing==55) }] {
         set legal_values [compare_eq $legal_values 47872]
      }
      if [expr { ($gen3_full_swing==56) }] {
         set legal_values [compare_eq $legal_values 51968]
      }
      if [expr { ($gen3_full_swing==57) }] {
         set legal_values [compare_eq $legal_values 52032]
      }
      if [expr { ($gen3_full_swing==58) }] {
         set legal_values [compare_eq $legal_values 52096]
      }
      if [expr { ($gen3_full_swing==59) }] {
         set legal_values [compare_eq $legal_values 52160]
      }
      if [expr { ($gen3_full_swing==60) }] {
         set legal_values [compare_eq $legal_values 52224]
      }
      if [expr { ($gen3_full_swing==61) }] {
         set legal_values [compare_eq $legal_values 56320]
      }
      if [expr { ($gen3_full_swing==62) }] {
         set legal_values [compare_eq $legal_values 56384]
      }
      if [expr { ($gen3_full_swing==63) }] {
         set legal_values [compare_eq $legal_values 56448]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_preset_coeff_3.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_preset_coeff_3 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_preset_coeff_3 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_preset_coeff_3 $gen3_preset_coeff_3 $legal_values { gen3_full_swing sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_preset_coeff_4 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_preset_coeff_4 gen3_full_swing sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($gen3_full_swing==20) }] {
         set legal_values [compare_eq $legal_values 13376]
      }
      if [expr { ($gen3_full_swing==21) }] {
         set legal_values [compare_eq $legal_values 13440]
      }
      if [expr { ($gen3_full_swing==22) }] {
         set legal_values [compare_eq $legal_values 13504]
      }
      if [expr { ($gen3_full_swing==23) }] {
         set legal_values [compare_eq $legal_values 13568]
      }
      if [expr { ($gen3_full_swing==24) }] {
         set legal_values [compare_eq $legal_values 13632]
      }
      if [expr { ($gen3_full_swing==25) }] {
         set legal_values [compare_eq $legal_values 17728]
      }
      if [expr { ($gen3_full_swing==26) }] {
         set legal_values [compare_eq $legal_values 17792]
      }
      if [expr { ($gen3_full_swing==27) }] {
         set legal_values [compare_eq $legal_values 17856]
      }
      if [expr { ($gen3_full_swing==28) }] {
         set legal_values [compare_eq $legal_values 17920]
      }
      if [expr { ($gen3_full_swing==29) }] {
         set legal_values [compare_eq $legal_values 17984]
      }
      if [expr { ($gen3_full_swing==30) }] {
         set legal_values [compare_eq $legal_values 18048]
      }
      if [expr { ($gen3_full_swing==31) }] {
         set legal_values [compare_eq $legal_values 18112]
      }
      if [expr { ($gen3_full_swing==32) }] {
         set legal_values [compare_eq $legal_values 18176]
      }
      if [expr { ($gen3_full_swing==33) }] {
         set legal_values [compare_eq $legal_values 22272]
      }
      if [expr { ($gen3_full_swing==34) }] {
         set legal_values [compare_eq $legal_values 22336]
      }
      if [expr { ($gen3_full_swing==35) }] {
         set legal_values [compare_eq $legal_values 22400]
      }
      if [expr { ($gen3_full_swing==36) }] {
         set legal_values [compare_eq $legal_values 22464]
      }
      if [expr { ($gen3_full_swing==37) }] {
         set legal_values [compare_eq $legal_values 22528]
      }
      if [expr { ($gen3_full_swing==38) }] {
         set legal_values [compare_eq $legal_values 22592]
      }
      if [expr { ($gen3_full_swing==39) }] {
         set legal_values [compare_eq $legal_values 22656]
      }
      if [expr { ($gen3_full_swing==40) }] {
         set legal_values [compare_eq $legal_values 22720]
      }
      if [expr { ($gen3_full_swing==41) }] {
         set legal_values [compare_eq $legal_values 26816]
      }
      if [expr { ($gen3_full_swing==42) }] {
         set legal_values [compare_eq $legal_values 26880]
      }
      if [expr { ($gen3_full_swing==43) }] {
         set legal_values [compare_eq $legal_values 26944]
      }
      if [expr { ($gen3_full_swing==44) }] {
         set legal_values [compare_eq $legal_values 27008]
      }
      if [expr { ($gen3_full_swing==45) }] {
         set legal_values [compare_eq $legal_values 27072]
      }
      if [expr { ($gen3_full_swing==46) }] {
         set legal_values [compare_eq $legal_values 27136]
      }
      if [expr { ($gen3_full_swing==47) }] {
         set legal_values [compare_eq $legal_values 27200]
      }
      if [expr { ($gen3_full_swing==48) }] {
         set legal_values [compare_eq $legal_values 27264]
      }
      if [expr { ($gen3_full_swing==49) }] {
         set legal_values [compare_eq $legal_values 31360]
      }
      if [expr { ($gen3_full_swing==50) }] {
         set legal_values [compare_eq $legal_values 31424]
      }
      if [expr { ($gen3_full_swing==51) }] {
         set legal_values [compare_eq $legal_values 31488]
      }
      if [expr { ($gen3_full_swing==52) }] {
         set legal_values [compare_eq $legal_values 31552]
      }
      if [expr { ($gen3_full_swing==53) }] {
         set legal_values [compare_eq $legal_values 31616]
      }
      if [expr { ($gen3_full_swing==54) }] {
         set legal_values [compare_eq $legal_values 31680]
      }
      if [expr { ($gen3_full_swing==55) }] {
         set legal_values [compare_eq $legal_values 31744]
      }
      if [expr { ($gen3_full_swing==56) }] {
         set legal_values [compare_eq $legal_values 31808]
      }
      if [expr { ($gen3_full_swing==57) }] {
         set legal_values [compare_eq $legal_values 35904]
      }
      if [expr { ($gen3_full_swing==58) }] {
         set legal_values [compare_eq $legal_values 35968]
      }
      if [expr { ($gen3_full_swing==59) }] {
         set legal_values [compare_eq $legal_values 36032]
      }
      if [expr { ($gen3_full_swing==60) }] {
         set legal_values [compare_eq $legal_values 36096]
      }
      if [expr { ($gen3_full_swing==61) }] {
         set legal_values [compare_eq $legal_values 36160]
      }
      if [expr { ($gen3_full_swing==62) }] {
         set legal_values [compare_eq $legal_values 36224]
      }
      if [expr { ($gen3_full_swing==63) }] {
         set legal_values [compare_eq $legal_values 36288]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_preset_coeff_4.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_preset_coeff_4 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_preset_coeff_4 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_preset_coeff_4 $gen3_preset_coeff_4 $legal_values { gen3_full_swing sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_preset_coeff_5 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_preset_coeff_5 gen3_full_swing sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($gen3_full_swing==20) }] {
         set legal_values [compare_eq $legal_values 1280]
      }
      if [expr { ($gen3_full_swing==21) }] {
         set legal_values [compare_eq $legal_values 1344]
      }
      if [expr { ($gen3_full_swing==22) }] {
         set legal_values [compare_eq $legal_values 1408]
      }
      if [expr { ($gen3_full_swing==23) }] {
         set legal_values [compare_eq $legal_values 1472]
      }
      if [expr { ($gen3_full_swing==24) }] {
         set legal_values [compare_eq $legal_values 1536]
      }
      if [expr { ($gen3_full_swing==25) }] {
         set legal_values [compare_eq $legal_values 1600]
      }
      if [expr { ($gen3_full_swing==26) }] {
         set legal_values [compare_eq $legal_values 1664]
      }
      if [expr { ($gen3_full_swing==27) }] {
         set legal_values [compare_eq $legal_values 1728]
      }
      if [expr { ($gen3_full_swing==28) }] {
         set legal_values [compare_eq $legal_values 1792]
      }
      if [expr { ($gen3_full_swing==29) }] {
         set legal_values [compare_eq $legal_values 1856]
      }
      if [expr { ($gen3_full_swing==30) }] {
         set legal_values [compare_eq $legal_values 1920]
      }
      if [expr { ($gen3_full_swing==31) }] {
         set legal_values [compare_eq $legal_values 1984]
      }
      if [expr { ($gen3_full_swing==32) }] {
         set legal_values [compare_eq $legal_values 2048]
      }
      if [expr { ($gen3_full_swing==33) }] {
         set legal_values [compare_eq $legal_values 2112]
      }
      if [expr { ($gen3_full_swing==34) }] {
         set legal_values [compare_eq $legal_values 2176]
      }
      if [expr { ($gen3_full_swing==35) }] {
         set legal_values [compare_eq $legal_values 2240]
      }
      if [expr { ($gen3_full_swing==36) }] {
         set legal_values [compare_eq $legal_values 2304]
      }
      if [expr { ($gen3_full_swing==37) }] {
         set legal_values [compare_eq $legal_values 2368]
      }
      if [expr { ($gen3_full_swing==38) }] {
         set legal_values [compare_eq $legal_values 2432]
      }
      if [expr { ($gen3_full_swing==39) }] {
         set legal_values [compare_eq $legal_values 2496]
      }
      if [expr { ($gen3_full_swing==40) }] {
         set legal_values [compare_eq $legal_values 2560]
      }
      if [expr { ($gen3_full_swing==41) }] {
         set legal_values [compare_eq $legal_values 2624]
      }
      if [expr { ($gen3_full_swing==42) }] {
         set legal_values [compare_eq $legal_values 2688]
      }
      if [expr { ($gen3_full_swing==43) }] {
         set legal_values [compare_eq $legal_values 2752]
      }
      if [expr { ($gen3_full_swing==44) }] {
         set legal_values [compare_eq $legal_values 2816]
      }
      if [expr { ($gen3_full_swing==45) }] {
         set legal_values [compare_eq $legal_values 2880]
      }
      if [expr { ($gen3_full_swing==46) }] {
         set legal_values [compare_eq $legal_values 2944]
      }
      if [expr { ($gen3_full_swing==47) }] {
         set legal_values [compare_eq $legal_values 3008]
      }
      if [expr { ($gen3_full_swing==48) }] {
         set legal_values [compare_eq $legal_values 3072]
      }
      if [expr { ($gen3_full_swing==49) }] {
         set legal_values [compare_eq $legal_values 3136]
      }
      if [expr { ($gen3_full_swing==50) }] {
         set legal_values [compare_eq $legal_values 3200]
      }
      if [expr { ($gen3_full_swing==51) }] {
         set legal_values [compare_eq $legal_values 3264]
      }
      if [expr { ($gen3_full_swing==52) }] {
         set legal_values [compare_eq $legal_values 3328]
      }
      if [expr { ($gen3_full_swing==53) }] {
         set legal_values [compare_eq $legal_values 3392]
      }
      if [expr { ($gen3_full_swing==54) }] {
         set legal_values [compare_eq $legal_values 3456]
      }
      if [expr { ($gen3_full_swing==55) }] {
         set legal_values [compare_eq $legal_values 3520]
      }
      if [expr { ($gen3_full_swing==56) }] {
         set legal_values [compare_eq $legal_values 3584]
      }
      if [expr { ($gen3_full_swing==57) }] {
         set legal_values [compare_eq $legal_values 3648]
      }
      if [expr { ($gen3_full_swing==58) }] {
         set legal_values [compare_eq $legal_values 3712]
      }
      if [expr { ($gen3_full_swing==59) }] {
         set legal_values [compare_eq $legal_values 3776]
      }
      if [expr { ($gen3_full_swing==60) }] {
         set legal_values [compare_eq $legal_values 3840]
      }
      if [expr { ($gen3_full_swing==61) }] {
         set legal_values [compare_eq $legal_values 3904]
      }
      if [expr { ($gen3_full_swing==62) }] {
         set legal_values [compare_eq $legal_values 3968]
      }
      if [expr { ($gen3_full_swing==63) }] {
         set legal_values [compare_eq $legal_values 4032]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_preset_coeff_5.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_preset_coeff_5 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_preset_coeff_5 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_preset_coeff_5 $gen3_preset_coeff_5 $legal_values { gen3_full_swing sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_preset_coeff_6 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_preset_coeff_6 gen3_full_swing sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($gen3_full_swing==20) }] {
         set legal_values [compare_eq $legal_values 1154]
      }
      if [expr { ($gen3_full_swing==21) }] {
         set legal_values [compare_eq $legal_values 1155]
      }
      if [expr { ($gen3_full_swing==22) }] {
         set legal_values [compare_eq $legal_values 1219]
      }
      if [expr { ($gen3_full_swing==23) }] {
         set legal_values [compare_eq $legal_values 1283]
      }
      if [expr { ($gen3_full_swing==24) }] {
         set legal_values [compare_eq $legal_values 1347]
      }
      if [expr { ($gen3_full_swing==25) }] {
         set legal_values [compare_eq $legal_values 1411]
      }
      if [expr { ($gen3_full_swing==26) }] {
         set legal_values [compare_eq $legal_values 1475]
      }
      if [expr { ($gen3_full_swing==27) }] {
         set legal_values [compare_eq $legal_values 1539]
      }
      if [expr { ($gen3_full_swing==28) }] {
         set legal_values [compare_eq $legal_values 1603]
      }
      if [expr { ($gen3_full_swing==29) }] {
         set legal_values [compare_eq $legal_values 1667]
      }
      if [expr { ($gen3_full_swing==30) }] {
         set legal_values [compare_eq $legal_values 1731]
      }
      if [expr { ($gen3_full_swing==31) }] {
         set legal_values [compare_eq $legal_values 1732]
      }
      if [expr { ($gen3_full_swing==32) }] {
         set legal_values [compare_eq $legal_values 1796]
      }
      if [expr { ($gen3_full_swing==33) }] {
         set legal_values [compare_eq $legal_values 1860]
      }
      if [expr { ($gen3_full_swing==34) }] {
         set legal_values [compare_eq $legal_values 1924]
      }
      if [expr { ($gen3_full_swing==35) }] {
         set legal_values [compare_eq $legal_values 1988]
      }
      if [expr { ($gen3_full_swing==36) }] {
         set legal_values [compare_eq $legal_values 2052]
      }
      if [expr { ($gen3_full_swing==37) }] {
         set legal_values [compare_eq $legal_values 2116]
      }
      if [expr { ($gen3_full_swing==38) }] {
         set legal_values [compare_eq $legal_values 2180]
      }
      if [expr { ($gen3_full_swing==39) }] {
         set legal_values [compare_eq $legal_values 2244]
      }
      if [expr { ($gen3_full_swing==40) }] {
         set legal_values [compare_eq $legal_values 2308]
      }
      if [expr { ($gen3_full_swing==41) }] {
         set legal_values [compare_eq $legal_values 2309]
      }
      if [expr { ($gen3_full_swing==42) }] {
         set legal_values [compare_eq $legal_values 2373]
      }
      if [expr { ($gen3_full_swing==43) }] {
         set legal_values [compare_eq $legal_values 2437]
      }
      if [expr { ($gen3_full_swing==44) }] {
         set legal_values [compare_eq $legal_values 2501]
      }
      if [expr { ($gen3_full_swing==45) }] {
         set legal_values [compare_eq $legal_values 2565]
      }
      if [expr { ($gen3_full_swing==46) }] {
         set legal_values [compare_eq $legal_values 2629]
      }
      if [expr { ($gen3_full_swing==47) }] {
         set legal_values [compare_eq $legal_values 2693]
      }
      if [expr { ($gen3_full_swing==48) }] {
         set legal_values [compare_eq $legal_values 2757]
      }
      if [expr { ($gen3_full_swing==49) }] {
         set legal_values [compare_eq $legal_values 2821]
      }
      if [expr { ($gen3_full_swing==50) }] {
         set legal_values [compare_eq $legal_values 2885]
      }
      if [expr { ($gen3_full_swing==51) }] {
         set legal_values [compare_eq $legal_values 2886]
      }
      if [expr { ($gen3_full_swing==52) }] {
         set legal_values [compare_eq $legal_values 2950]
      }
      if [expr { ($gen3_full_swing==53) }] {
         set legal_values [compare_eq $legal_values 3014]
      }
      if [expr { ($gen3_full_swing==54) }] {
         set legal_values [compare_eq $legal_values 3078]
      }
      if [expr { ($gen3_full_swing==55) }] {
         set legal_values [compare_eq $legal_values 3142]
      }
      if [expr { ($gen3_full_swing==56) }] {
         set legal_values [compare_eq $legal_values 3206]
      }
      if [expr { ($gen3_full_swing==57) }] {
         set legal_values [compare_eq $legal_values 3270]
      }
      if [expr { ($gen3_full_swing==58) }] {
         set legal_values [compare_eq $legal_values 3334]
      }
      if [expr { ($gen3_full_swing==59) }] {
         set legal_values [compare_eq $legal_values 3398]
      }
      if [expr { ($gen3_full_swing==60) }] {
         set legal_values [compare_eq $legal_values 3462]
      }
      if [expr { ($gen3_full_swing==61) }] {
         set legal_values [compare_eq $legal_values 3463]
      }
      if [expr { ($gen3_full_swing==62) }] {
         set legal_values [compare_eq $legal_values 3527]
      }
      if [expr { ($gen3_full_swing==63) }] {
         set legal_values [compare_eq $legal_values 3591]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_preset_coeff_6.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_preset_coeff_6 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_preset_coeff_6 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_preset_coeff_6 $gen3_preset_coeff_6 $legal_values { gen3_full_swing sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_preset_coeff_7 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_preset_coeff_7 gen3_full_swing sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($gen3_full_swing==20) }] {
         set legal_values [compare_eq $legal_values 1091]
      }
      if [expr { ($gen3_full_swing==21) }] {
         set legal_values [compare_eq $legal_values 1155]
      }
      if [expr { ($gen3_full_swing==22) }] {
         set legal_values [compare_eq $legal_values 1219]
      }
      if [expr { ($gen3_full_swing==23) }] {
         set legal_values [compare_eq $legal_values 1283]
      }
      if [expr { ($gen3_full_swing==24) }] {
         set legal_values [compare_eq $legal_values 1347]
      }
      if [expr { ($gen3_full_swing==25) }] {
         set legal_values [compare_eq $legal_values 1348]
      }
      if [expr { ($gen3_full_swing==26) }] {
         set legal_values [compare_eq $legal_values 1412]
      }
      if [expr { ($gen3_full_swing==27) }] {
         set legal_values [compare_eq $legal_values 1476]
      }
      if [expr { ($gen3_full_swing==28) }] {
         set legal_values [compare_eq $legal_values 1540]
      }
      if [expr { ($gen3_full_swing==29) }] {
         set legal_values [compare_eq $legal_values 1604]
      }
      if [expr { ($gen3_full_swing==30) }] {
         set legal_values [compare_eq $legal_values 1668]
      }
      if [expr { ($gen3_full_swing==31) }] {
         set legal_values [compare_eq $legal_values 1732]
      }
      if [expr { ($gen3_full_swing==32) }] {
         set legal_values [compare_eq $legal_values 1796]
      }
      if [expr { ($gen3_full_swing==33) }] {
         set legal_values [compare_eq $legal_values 1797]
      }
      if [expr { ($gen3_full_swing==34) }] {
         set legal_values [compare_eq $legal_values 1861]
      }
      if [expr { ($gen3_full_swing==35) }] {
         set legal_values [compare_eq $legal_values 1925]
      }
      if [expr { ($gen3_full_swing==36) }] {
         set legal_values [compare_eq $legal_values 1989]
      }
      if [expr { ($gen3_full_swing==37) }] {
         set legal_values [compare_eq $legal_values 2053]
      }
      if [expr { ($gen3_full_swing==38) }] {
         set legal_values [compare_eq $legal_values 2117]
      }
      if [expr { ($gen3_full_swing==39) }] {
         set legal_values [compare_eq $legal_values 2181]
      }
      if [expr { ($gen3_full_swing==40) }] {
         set legal_values [compare_eq $legal_values 2245]
      }
      if [expr { ($gen3_full_swing==41) }] {
         set legal_values [compare_eq $legal_values 2246]
      }
      if [expr { ($gen3_full_swing==42) }] {
         set legal_values [compare_eq $legal_values 2310]
      }
      if [expr { ($gen3_full_swing==43) }] {
         set legal_values [compare_eq $legal_values 2374]
      }
      if [expr { ($gen3_full_swing==44) }] {
         set legal_values [compare_eq $legal_values 2438]
      }
      if [expr { ($gen3_full_swing==45) }] {
         set legal_values [compare_eq $legal_values 2502]
      }
      if [expr { ($gen3_full_swing==46) }] {
         set legal_values [compare_eq $legal_values 2566]
      }
      if [expr { ($gen3_full_swing==47) }] {
         set legal_values [compare_eq $legal_values 2630]
      }
      if [expr { ($gen3_full_swing==48) }] {
         set legal_values [compare_eq $legal_values 2694]
      }
      if [expr { ($gen3_full_swing==49) }] {
         set legal_values [compare_eq $legal_values 2695]
      }
      if [expr { ($gen3_full_swing==50) }] {
         set legal_values [compare_eq $legal_values 2759]
      }
      if [expr { ($gen3_full_swing==51) }] {
         set legal_values [compare_eq $legal_values 2823]
      }
      if [expr { ($gen3_full_swing==52) }] {
         set legal_values [compare_eq $legal_values 2887]
      }
      if [expr { ($gen3_full_swing==53) }] {
         set legal_values [compare_eq $legal_values 2951]
      }
      if [expr { ($gen3_full_swing==54) }] {
         set legal_values [compare_eq $legal_values 3015]
      }
      if [expr { ($gen3_full_swing==55) }] {
         set legal_values [compare_eq $legal_values 3079]
      }
      if [expr { ($gen3_full_swing==56) }] {
         set legal_values [compare_eq $legal_values 3143]
      }
      if [expr { ($gen3_full_swing==57) }] {
         set legal_values [compare_eq $legal_values 3144]
      }
      if [expr { ($gen3_full_swing==58) }] {
         set legal_values [compare_eq $legal_values 3208]
      }
      if [expr { ($gen3_full_swing==59) }] {
         set legal_values [compare_eq $legal_values 3272]
      }
      if [expr { ($gen3_full_swing==60) }] {
         set legal_values [compare_eq $legal_values 3336]
      }
      if [expr { ($gen3_full_swing==61) }] {
         set legal_values [compare_eq $legal_values 3400]
      }
      if [expr { ($gen3_full_swing==62) }] {
         set legal_values [compare_eq $legal_values 3464]
      }
      if [expr { ($gen3_full_swing==63) }] {
         set legal_values [compare_eq $legal_values 3528]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_preset_coeff_7.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_preset_coeff_7 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_preset_coeff_7 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_preset_coeff_7 $gen3_preset_coeff_7 $legal_values { gen3_full_swing sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_preset_coeff_8 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_preset_coeff_8 gen3_full_swing sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($gen3_full_swing==20) }] {
         set legal_values [compare_eq $legal_values 17282]
      }
      if [expr { ($gen3_full_swing==21) }] {
         set legal_values [compare_eq $legal_values 21315]
      }
      if [expr { ($gen3_full_swing==22) }] {
         set legal_values [compare_eq $legal_values 21379]
      }
      if [expr { ($gen3_full_swing==23) }] {
         set legal_values [compare_eq $legal_values 21443]
      }
      if [expr { ($gen3_full_swing==24) }] {
         set legal_values [compare_eq $legal_values 21507]
      }
      if [expr { ($gen3_full_swing==25) }] {
         set legal_values [compare_eq $legal_values 21571]
      }
      if [expr { ($gen3_full_swing==26) }] {
         set legal_values [compare_eq $legal_values 25667]
      }
      if [expr { ($gen3_full_swing==27) }] {
         set legal_values [compare_eq $legal_values 25731]
      }
      if [expr { ($gen3_full_swing==28) }] {
         set legal_values [compare_eq $legal_values 25795]
      }
      if [expr { ($gen3_full_swing==29) }] {
         set legal_values [compare_eq $legal_values 25859]
      }
      if [expr { ($gen3_full_swing==30) }] {
         set legal_values [compare_eq $legal_values 25923]
      }
      if [expr { ($gen3_full_swing==31) }] {
         set legal_values [compare_eq $legal_values 29956]
      }
      if [expr { ($gen3_full_swing==32) }] {
         set legal_values [compare_eq $legal_values 30020]
      }
      if [expr { ($gen3_full_swing==33) }] {
         set legal_values [compare_eq $legal_values 30084]
      }
      if [expr { ($gen3_full_swing==34) }] {
         set legal_values [compare_eq $legal_values 30148]
      }
      if [expr { ($gen3_full_swing==35) }] {
         set legal_values [compare_eq $legal_values 30212]
      }
      if [expr { ($gen3_full_swing==36) }] {
         set legal_values [compare_eq $legal_values 34308]
      }
      if [expr { ($gen3_full_swing==37) }] {
         set legal_values [compare_eq $legal_values 34372]
      }
      if [expr { ($gen3_full_swing==38) }] {
         set legal_values [compare_eq $legal_values 34436]
      }
      if [expr { ($gen3_full_swing==39) }] {
         set legal_values [compare_eq $legal_values 34500]
      }
      if [expr { ($gen3_full_swing==40) }] {
         set legal_values [compare_eq $legal_values 34564]
      }
      if [expr { ($gen3_full_swing==41) }] {
         set legal_values [compare_eq $legal_values 38597]
      }
      if [expr { ($gen3_full_swing==42) }] {
         set legal_values [compare_eq $legal_values 38661]
      }
      if [expr { ($gen3_full_swing==43) }] {
         set legal_values [compare_eq $legal_values 38725]
      }
      if [expr { ($gen3_full_swing==44) }] {
         set legal_values [compare_eq $legal_values 38789]
      }
      if [expr { ($gen3_full_swing==45) }] {
         set legal_values [compare_eq $legal_values 38853]
      }
      if [expr { ($gen3_full_swing==46) }] {
         set legal_values [compare_eq $legal_values 42949]
      }
      if [expr { ($gen3_full_swing==47) }] {
         set legal_values [compare_eq $legal_values 43013]
      }
      if [expr { ($gen3_full_swing==48) }] {
         set legal_values [compare_eq $legal_values 43077]
      }
      if [expr { ($gen3_full_swing==49) }] {
         set legal_values [compare_eq $legal_values 43141]
      }
      if [expr { ($gen3_full_swing==50) }] {
         set legal_values [compare_eq $legal_values 43205]
      }
      if [expr { ($gen3_full_swing==51) }] {
         set legal_values [compare_eq $legal_values 47238]
      }
      if [expr { ($gen3_full_swing==52) }] {
         set legal_values [compare_eq $legal_values 47302]
      }
      if [expr { ($gen3_full_swing==53) }] {
         set legal_values [compare_eq $legal_values 47366]
      }
      if [expr { ($gen3_full_swing==54) }] {
         set legal_values [compare_eq $legal_values 47430]
      }
      if [expr { ($gen3_full_swing==55) }] {
         set legal_values [compare_eq $legal_values 47494]
      }
      if [expr { ($gen3_full_swing==56) }] {
         set legal_values [compare_eq $legal_values 51590]
      }
      if [expr { ($gen3_full_swing==57) }] {
         set legal_values [compare_eq $legal_values 51654]
      }
      if [expr { ($gen3_full_swing==58) }] {
         set legal_values [compare_eq $legal_values 51718]
      }
      if [expr { ($gen3_full_swing==59) }] {
         set legal_values [compare_eq $legal_values 51782]
      }
      if [expr { ($gen3_full_swing==60) }] {
         set legal_values [compare_eq $legal_values 51846]
      }
      if [expr { ($gen3_full_swing==61) }] {
         set legal_values [compare_eq $legal_values 55879]
      }
      if [expr { ($gen3_full_swing==62) }] {
         set legal_values [compare_eq $legal_values 55943]
      }
      if [expr { ($gen3_full_swing==63) }] {
         set legal_values [compare_eq $legal_values 56007]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_preset_coeff_8.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_preset_coeff_8 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_preset_coeff_8 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_preset_coeff_8 $gen3_preset_coeff_8 $legal_values { gen3_full_swing sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_preset_coeff_9 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_preset_coeff_9 gen3_full_swing sup_mode } {

   set legal_values [list 0:262143]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($gen3_full_swing==20) }] {
         set legal_values [compare_eq $legal_values 13187]
      }
      if [expr { ($gen3_full_swing==21) }] {
         set legal_values [compare_eq $legal_values 13251]
      }
      if [expr { ($gen3_full_swing==22) }] {
         set legal_values [compare_eq $legal_values 13315]
      }
      if [expr { ($gen3_full_swing==23) }] {
         set legal_values [compare_eq $legal_values 13379]
      }
      if [expr { ($gen3_full_swing==24) }] {
         set legal_values [compare_eq $legal_values 13443]
      }
      if [expr { ($gen3_full_swing==25) }] {
         set legal_values [compare_eq $legal_values 17476]
      }
      if [expr { ($gen3_full_swing==26) }] {
         set legal_values [compare_eq $legal_values 17540]
      }
      if [expr { ($gen3_full_swing==27) }] {
         set legal_values [compare_eq $legal_values 17604]
      }
      if [expr { ($gen3_full_swing==28) }] {
         set legal_values [compare_eq $legal_values 17668]
      }
      if [expr { ($gen3_full_swing==29) }] {
         set legal_values [compare_eq $legal_values 17732]
      }
      if [expr { ($gen3_full_swing==30) }] {
         set legal_values [compare_eq $legal_values 17796]
      }
      if [expr { ($gen3_full_swing==31) }] {
         set legal_values [compare_eq $legal_values 17860]
      }
      if [expr { ($gen3_full_swing==32) }] {
         set legal_values [compare_eq $legal_values 17924]
      }
      if [expr { ($gen3_full_swing==33) }] {
         set legal_values [compare_eq $legal_values 21957]
      }
      if [expr { ($gen3_full_swing==34) }] {
         set legal_values [compare_eq $legal_values 22021]
      }
      if [expr { ($gen3_full_swing==35) }] {
         set legal_values [compare_eq $legal_values 22085]
      }
      if [expr { ($gen3_full_swing==36) }] {
         set legal_values [compare_eq $legal_values 22149]
      }
      if [expr { ($gen3_full_swing==37) }] {
         set legal_values [compare_eq $legal_values 22213]
      }
      if [expr { ($gen3_full_swing==38) }] {
         set legal_values [compare_eq $legal_values 22277]
      }
      if [expr { ($gen3_full_swing==39) }] {
         set legal_values [compare_eq $legal_values 22341]
      }
      if [expr { ($gen3_full_swing==40) }] {
         set legal_values [compare_eq $legal_values 22405]
      }
      if [expr { ($gen3_full_swing==41) }] {
         set legal_values [compare_eq $legal_values 26438]
      }
      if [expr { ($gen3_full_swing==42) }] {
         set legal_values [compare_eq $legal_values 26502]
      }
      if [expr { ($gen3_full_swing==43) }] {
         set legal_values [compare_eq $legal_values 26566]
      }
      if [expr { ($gen3_full_swing==44) }] {
         set legal_values [compare_eq $legal_values 26630]
      }
      if [expr { ($gen3_full_swing==45) }] {
         set legal_values [compare_eq $legal_values 26694]
      }
      if [expr { ($gen3_full_swing==46) }] {
         set legal_values [compare_eq $legal_values 26758]
      }
      if [expr { ($gen3_full_swing==47) }] {
         set legal_values [compare_eq $legal_values 26822]
      }
      if [expr { ($gen3_full_swing==48) }] {
         set legal_values [compare_eq $legal_values 26886]
      }
      if [expr { ($gen3_full_swing==49) }] {
         set legal_values [compare_eq $legal_values 30919]
      }
      if [expr { ($gen3_full_swing==50) }] {
         set legal_values [compare_eq $legal_values 30983]
      }
      if [expr { ($gen3_full_swing==51) }] {
         set legal_values [compare_eq $legal_values 31047]
      }
      if [expr { ($gen3_full_swing==52) }] {
         set legal_values [compare_eq $legal_values 31111]
      }
      if [expr { ($gen3_full_swing==53) }] {
         set legal_values [compare_eq $legal_values 31175]
      }
      if [expr { ($gen3_full_swing==54) }] {
         set legal_values [compare_eq $legal_values 31239]
      }
      if [expr { ($gen3_full_swing==55) }] {
         set legal_values [compare_eq $legal_values 31303]
      }
      if [expr { ($gen3_full_swing==56) }] {
         set legal_values [compare_eq $legal_values 31367]
      }
      if [expr { ($gen3_full_swing==57) }] {
         set legal_values [compare_eq $legal_values 35400]
      }
      if [expr { ($gen3_full_swing==58) }] {
         set legal_values [compare_eq $legal_values 35464]
      }
      if [expr { ($gen3_full_swing==59) }] {
         set legal_values [compare_eq $legal_values 35528]
      }
      if [expr { ($gen3_full_swing==60) }] {
         set legal_values [compare_eq $legal_values 35592]
      }
      if [expr { ($gen3_full_swing==61) }] {
         set legal_values [compare_eq $legal_values 35656]
      }
      if [expr { ($gen3_full_swing==62) }] {
         set legal_values [compare_eq $legal_values 35720]
      }
      if [expr { ($gen3_full_swing==63) }] {
         set legal_values [compare_eq $legal_values 35784]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_preset_coeff_9.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_preset_coeff_9 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_preset_coeff_9 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_preset_coeff_9 $gen3_preset_coeff_9 $legal_values { gen3_full_swing sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_reset_eieos_cnt_bit { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_reset_eieos_cnt_bit lane_rate sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($lane_rate=="gen3") }] {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_reset_eieos_cnt_bit.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_reset_eieos_cnt_bit $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_reset_eieos_cnt_bit $gen3_reset_eieos_cnt_bit $legal_values { lane_rate sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_rxfreqlock_counter { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_rxfreqlock_counter ltssm_freqlocked_check sup_mode } {

   set legal_values [list 0:1048575]

   if [expr { ($ltssm_freqlocked_check=="enable") }] {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_rxfreqlock_counter.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_rxfreqlock_counter $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_rxfreqlock_counter $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_rxfreqlock_counter $gen3_rxfreqlock_counter $legal_values { ltssm_freqlocked_check sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_sameclock_nfts_count { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_sameclock_nfts_count sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 128]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.gen3_sameclock_nfts_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message gen3_sameclock_nfts_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message gen3_sameclock_nfts_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto gen3_sameclock_nfts_count $gen3_sameclock_nfts_count $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_scrdscr_bypass { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_scrdscr_bypass lane_rate sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($lane_rate=="gen3") }] {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "true"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_scrdscr_bypass.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_scrdscr_bypass $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_scrdscr_bypass $gen3_scrdscr_bypass $legal_values { lane_rate sup_mode }
   }
}

proc ::nf_hip::parameters::validate_gen3_skip_ph2_ph3 { PROP_M_AUTOSET PROP_M_AUTOWARN gen3_skip_ph2_ph3 sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.gen3_skip_ph2_ph3.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message gen3_skip_ph2_ph3 $legal_values
      }
   } else {
      auto_invalid_value_message auto gen3_skip_ph2_ph3 $gen3_skip_ph2_ph3 $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_hard_reset_bypass { PROP_M_AUTOSET PROP_M_AUTOWARN hard_reset_bypass hrdrstctrl_en } {

   set legal_values [list "false" "true"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "true"]]
   } else {
      set legal_values [intersect $legal_values [list "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hard_reset_bypass.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hard_reset_bypass $legal_values
      }
   } else {
      auto_invalid_value_message auto hard_reset_bypass $hard_reset_bypass $legal_values { hrdrstctrl_en }
   }
}

proc ::nf_hip::parameters::validate_hard_rst_sig_chnl_en { PROP_M_AUTOSET PROP_M_AUTOWARN hard_rst_sig_chnl_en hrdrstctrl_en link_width } {

   set legal_values [list "disable_hrc_sig" "enable_hrc_sig_x1" "enable_hrc_sig_x2" "enable_hrc_sig_x4" "enable_hrc_sig_x8"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "disable_hrc_sig"]]
   } else {
      if [expr { ($link_width=="x1") }] {
         set legal_values [intersect $legal_values [list "enable_hrc_sig_x1"]]
      } else {
         if [expr { ($link_width=="x2") }] {
            set legal_values [intersect $legal_values [list "enable_hrc_sig_x2"]]
         } else {
            if [expr { ($link_width=="x4") }] {
               set legal_values [intersect $legal_values [list "enable_hrc_sig_x4"]]
            } else {
               if [expr { ($link_width=="x8") }] {
                  set legal_values [intersect $legal_values [list "enable_hrc_sig_x8"]]
               } else {
                  set legal_values [intersect $legal_values [list "enable_hrc_sig_x1"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hard_rst_sig_chnl_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hard_rst_sig_chnl_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hard_rst_sig_chnl_en $hard_rst_sig_chnl_en $legal_values { hrdrstctrl_en link_width }
   }
}

proc ::nf_hip::parameters::validate_hard_rst_tx_pll_rst_chnl_en { PROP_M_AUTOSET PROP_M_AUTOWARN hard_rst_tx_pll_rst_chnl_en gen2_pma_pll_usage hrdrstctrl_en lane_rate link_width } {

   set legal_values [list "disable_hrc_txpll_rst" "enable_hrc_txpll_rst_ch0" "enable_hrc_txpll_rst_ch01" "enable_hrc_txpll_rst_ch1" "enable_hrc_txpll_rst_ch3" "enable_hrc_txpll_rst_ch34" "enable_hrc_txpll_rst_ch4"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "disable_hrc_txpll_rst"]]
   } else {
      if [expr { (($link_width=="x1")||($link_width=="x2")) }] {
         if [expr { ($lane_rate=="gen3") }] {
            set legal_values [intersect $legal_values [list "enable_hrc_txpll_rst_ch01"]]
         } else {
            if [expr { ($gen2_pma_pll_usage=="use_lcpll") }] {
               set legal_values [intersect $legal_values [list "enable_hrc_txpll_rst_ch0"]]
            } else {
               set legal_values [intersect $legal_values [list "enable_hrc_txpll_rst_ch1"]]
            }
         }
      } else {
         if [expr { (($link_width=="x4")||($link_width=="x8")) }] {
            if [expr { ($lane_rate=="gen3") }] {
               set legal_values [intersect $legal_values [list "enable_hrc_txpll_rst_ch34"]]
            } else {
               if [expr { ($gen2_pma_pll_usage=="use_lcpll") }] {
                  set legal_values [intersect $legal_values [list "enable_hrc_txpll_rst_ch3"]]
               } else {
                  set legal_values [intersect $legal_values [list "enable_hrc_txpll_rst_ch4"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hard_rst_tx_pll_rst_chnl_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hard_rst_tx_pll_rst_chnl_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hard_rst_tx_pll_rst_chnl_en $hard_rst_tx_pll_rst_chnl_en $legal_values { gen2_pma_pll_usage hrdrstctrl_en lane_rate link_width }
   }
}

proc ::nf_hip::parameters::validate_hip_ac_pwr_clk_freq_in_hz { PROP_M_AUTOSET PROP_M_AUTOWARN hip_ac_pwr_clk_freq_in_hz func_mode lane_rate } {

   set legal_values [list 0:1073741823]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 250000000]
   } else {
      if [expr { ($lane_rate=="gen3") }] {
         set legal_values [compare_eq $legal_values 250000000]
      } else {
         if [expr { ($lane_rate=="gen2") }] {
            set legal_values [compare_eq $legal_values 125000000]
         } else {
            if [expr { ($lane_rate=="gen1") }] {
               set legal_values [compare_eq $legal_values 62500000]
            } else {
               set legal_values [compare_eq $legal_values 125000000]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hip_ac_pwr_clk_freq_in_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hip_ac_pwr_clk_freq_in_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hip_ac_pwr_clk_freq_in_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hip_ac_pwr_clk_freq_in_hz $hip_ac_pwr_clk_freq_in_hz $legal_values { func_mode lane_rate }
   }
}

proc ::nf_hip::parameters::validate_hip_ac_pwr_uw_per_mhz { PROP_M_AUTOSET PROP_M_AUTOWARN hip_ac_pwr_uw_per_mhz func_mode lane_rate operating_voltage } {

   set legal_values [list 0:1073741823]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($lane_rate=="gen3") }] {
         if [expr { ($operating_voltage=="standard") }] {
            set legal_values [compare_eq $legal_values 828]
         } else {
            if [expr { ($operating_voltage=="vidint") }] {
               set legal_values [compare_eq $legal_values 756]
            } else {
               if [expr { ($operating_voltage=="vidmin") }] {
                  set legal_values [compare_eq $legal_values 687]
               }
            }
         }
      } else {
         if [expr { ($lane_rate=="gen2") }] {
            if [expr { ($operating_voltage=="standard") }] {
               set legal_values [compare_eq $legal_values 1120]
            } else {
               if [expr { ($operating_voltage=="vidint") }] {
                  set legal_values [compare_eq $legal_values 1022]
               } else {
                  if [expr { ($operating_voltage=="vidmin") }] {
                     set legal_values [compare_eq $legal_values 928]
                  }
               }
            }
         } else {
            if [expr { ($lane_rate=="gen1") }] {
               if [expr { ($operating_voltage=="standard") }] {
                  set legal_values [compare_eq $legal_values 1900]
               } else {
                  if [expr { ($operating_voltage=="vidint") }] {
                     set legal_values [compare_eq $legal_values 1736]
                  } else {
                     if [expr { ($operating_voltage=="vidmin") }] {
                        set legal_values [compare_eq $legal_values 1577]
                     }
                  }
               }
            } else {
               set legal_values [compare_eq $legal_values 1120]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hip_ac_pwr_uw_per_mhz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hip_ac_pwr_uw_per_mhz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hip_ac_pwr_uw_per_mhz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hip_ac_pwr_uw_per_mhz $hip_ac_pwr_uw_per_mhz $legal_values { func_mode lane_rate operating_voltage }
   }
}

proc ::nf_hip::parameters::validate_hip_base_address { PROP_M_AUTOSET PROP_M_AUTOWARN hip_base_address sup_mode } {

   set legal_values [list 0:1023]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hip_base_address.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hip_base_address $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hip_base_address $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hip_base_address $hip_base_address $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_hip_clock_dis { PROP_M_AUTOSET PROP_M_AUTOWARN hip_clock_dis func_mode } {

   set legal_values [list "disable_hip_clk" "enable_hip_clk"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "disable_hip_clk"]]
   } else {
      set legal_values [intersect $legal_values [list "enable_hip_clk"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hip_clock_dis.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hip_clock_dis $legal_values
      }
   } else {
      auto_invalid_value_message auto hip_clock_dis $hip_clock_dis $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_hip_hard_reset { PROP_M_AUTOSET PROP_M_AUTOWARN hip_hard_reset hrdrstctrl_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_en") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hip_hard_reset.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hip_hard_reset $legal_values
      }
   } else {
      auto_invalid_value_message auto hip_hard_reset $hip_hard_reset $legal_values { hrdrstctrl_en }
   }
}

proc ::nf_hip::parameters::validate_hip_pcs_sig_chnl_en { PROP_M_AUTOSET PROP_M_AUTOWARN hip_pcs_sig_chnl_en func_mode link_width } {

   set legal_values [list "disable_hip_pcs_sig" "enable_hip_pcs_sig_x1" "enable_hip_pcs_sig_x2" "enable_hip_pcs_sig_x4" "enable_hip_pcs_sig_x8"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "disable_hip_pcs_sig"]]
   } else {
      if [expr { ($link_width=="x1") }] {
         set legal_values [intersect $legal_values [list "enable_hip_pcs_sig_x1"]]
      } else {
         if [expr { ($link_width=="x2") }] {
            set legal_values [intersect $legal_values [list "enable_hip_pcs_sig_x2"]]
         } else {
            if [expr { ($link_width=="x4") }] {
               set legal_values [intersect $legal_values [list "enable_hip_pcs_sig_x4"]]
            } else {
               if [expr { ($link_width=="x8") }] {
                  set legal_values [intersect $legal_values [list "enable_hip_pcs_sig_x8"]]
               } else {
                  set legal_values [intersect $legal_values [list "enable_hip_pcs_sig_x1"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hip_pcs_sig_chnl_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hip_pcs_sig_chnl_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hip_pcs_sig_chnl_en $hip_pcs_sig_chnl_en $legal_values { func_mode link_width }
   }
}

proc ::nf_hip::parameters::validate_hot_plug_support { PROP_M_AUTOSET PROP_M_AUTOWARN hot_plug_support enable_slot_register func_mode sup_mode } {

   set legal_values [list 0:127]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         if [expr { ($enable_slot_register=="false") }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hot_plug_support.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hot_plug_support $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hot_plug_support $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hot_plug_support $hot_plug_support $legal_values { enable_slot_register func_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_hrc_chnl_txpll_master_cgb_rst_select { PROP_M_AUTOSET PROP_M_AUTOWARN hrc_chnl_txpll_master_cgb_rst_select gen2_pma_pll_usage hrdrstctrl_en lane_rate link_width } {

   set legal_values [list "ch0_master_cgb_sel" "ch1_master_cgb_sel" "ch2_master_cgb_sel" "ch3_master_cgb_sel" "ch4_master_cgb_sel" "ch5_master_cgb_sel" "ch6_master_cgb_sel" "ch7_master_cgb_sel" "disable_master_cgb_sel"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "disable_master_cgb_sel"]]
   } else {
      if [expr { (($link_width=="x1")||($link_width=="x2")) }] {
         if [expr { ($lane_rate=="gen3") }] {
            set legal_values [intersect $legal_values [list "ch0_master_cgb_sel"]]
         } else {
            if [expr { ($gen2_pma_pll_usage=="use_lcpll") }] {
               set legal_values [intersect $legal_values [list "ch0_master_cgb_sel"]]
            } else {
               set legal_values [intersect $legal_values [list "ch0_master_cgb_sel"]]
            }
         }
      } else {
         if [expr { (($link_width=="x4")||($link_width=="x8")) }] {
            if [expr { ($lane_rate=="gen3") }] {
               set legal_values [intersect $legal_values [list "ch3_master_cgb_sel"]]
            } else {
               if [expr { ($gen2_pma_pll_usage=="use_lcpll") }] {
                  set legal_values [intersect $legal_values [list "ch3_master_cgb_sel"]]
               } else {
                  set legal_values [intersect $legal_values [list "ch3_master_cgb_sel"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hrc_chnl_txpll_master_cgb_rst_select.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hrc_chnl_txpll_master_cgb_rst_select $legal_values
      }
   } else {
      auto_invalid_value_message auto hrc_chnl_txpll_master_cgb_rst_select $hrc_chnl_txpll_master_cgb_rst_select $legal_values { gen2_pma_pll_usage hrdrstctrl_en lane_rate link_width }
   }
}

proc ::nf_hip::parameters::validate_hrdrstctrl_en { PROP_M_AUTOSET PROP_M_AUTOWARN hrdrstctrl_en cvp_enable func_mode } {

   set legal_values [list "hrdrstctrl_dis" "hrdrstctrl_en"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "hrdrstctrl_dis"]]
   } else {
      if [expr { ($cvp_enable=="cvp_en") }] {
         set legal_values [intersect $legal_values [list "hrdrstctrl_en"]]
      } else {
         set legal_values [intersect $legal_values [list "hrdrstctrl_dis" "hrdrstctrl_en"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hrdrstctrl_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hrdrstctrl_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hrdrstctrl_en $hrdrstctrl_en $legal_values { cvp_enable func_mode }
   }
}

proc ::nf_hip::parameters::validate_iei_enable_settings { PROP_M_AUTOSET PROP_M_AUTOWARN iei_enable_settings sup_mode } {

   set legal_values [list "disable_iei_logic" "gen3gen2gen1_sd_only" "gen3gen2_infei_gen1_infei" "gen3gen2_infei_gen1_infei_sd" "gen3gen2_infei_infsd_gen1_infei_infsd" "gen3gen2_infei_infsd_gen1_infei_sd" "gen3_infei_infsd_gen2_infsd_gen1_infsd_sd" "gen3_infei_infsd_gen2_infsd_sd_gen1_infsd_sd"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "gen3_infei_infsd_gen2_infsd_gen1_infsd_sd"]]
   } else {
      set legal_values [intersect $legal_values [list "disable_iei_logic" "gen3gen2gen1_sd_only" "gen3gen2_infei_infsd_gen1_infei_infsd" "gen3gen2_infei_gen1_infei" "gen3gen2_infei_gen1_infei" "gen3gen2_infei_infsd_gen1_infei_sd" "gen3_infei_infsd_gen2_infsd_gen1_infsd_sd" "gen3_infei_infsd_gen2_infsd_sd_gen1_infsd_sd"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.iei_enable_settings.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message iei_enable_settings $legal_values
      }
   } else {
      auto_invalid_value_message auto iei_enable_settings $iei_enable_settings $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_indicator { PROP_M_AUTOSET PROP_M_AUTOWARN indicator func_mode port_type } {

   set legal_values [list 0:7]

   if [expr { (($func_mode=="disable")||($port_type!="root_port")) }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.indicator.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message indicator $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message indicator $legal_values
      }
   } else {
      auto_value_out_of_range_message auto indicator $indicator $legal_values { func_mode port_type }
   }
}

proc ::nf_hip::parameters::validate_intel_id_access { PROP_M_AUTOSET PROP_M_AUTOWARN intel_id_access sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.intel_id_access.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message intel_id_access $legal_values
      }
   } else {
      auto_invalid_value_message auto intel_id_access $intel_id_access $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_interrupt_pin { PROP_M_AUTOSET PROP_M_AUTOWARN interrupt_pin sup_mode } {

   set legal_values [list "inta" "intb" "intc" "intd" "none_int_pin"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "inta"]]
   } else {
      set legal_values [intersect $legal_values [list "none_int_pin" "inta" "intb" "intc" "intd"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.interrupt_pin.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message interrupt_pin $legal_values
      }
   } else {
      auto_invalid_value_message auto interrupt_pin $interrupt_pin $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_io_window_addr_width { PROP_M_AUTOSET PROP_M_AUTOWARN io_window_addr_width func_mode } {

   set legal_values [list "none" "window_16_bit" "window_32_bit"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "none"]]
   } else {
      set legal_values [intersect $legal_values [list "none" "window_16_bit" "window_32_bit"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.io_window_addr_width.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message io_window_addr_width $legal_values
      }
   } else {
      auto_invalid_value_message auto io_window_addr_width $io_window_addr_width $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_jtag_id { PROP_M_AUTOSET PROP_M_AUTOWARN jtag_id func_mode } {

   set legal_values [list 0:340282366920938463463374607431768211455]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.jtag_id.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message jtag_id $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message jtag_id $legal_values
      }
   } else {
      auto_value_out_of_range_message auto jtag_id $jtag_id $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_ko_compl_data { PROP_M_AUTOSET PROP_M_AUTOWARN ko_compl_data atomic_malformed func_mode max_payload_size rx_buffer_credit_alloc use_crc_forwarding } {

   set legal_values [list 0:4095]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($atomic_malformed=="true") }] {
         if [expr { ($use_crc_forwarding=="false") }] {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 801]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 795]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 782]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 756]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 705]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 765]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 765]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 752]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 727]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 676]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 440]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 440]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 440]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 440]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 440]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 64]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 128]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 64]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 128]
            }
         } else {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 795]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 789]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 776]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 750]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 699]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 767]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 749]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 736]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 711]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 660]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 412]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 412]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 412]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 412]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 412]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 64]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 128]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 64]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 128]
            }
         }
      } else {
         if [expr { ($use_crc_forwarding=="false") }] {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 801]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 795]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 782]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 756]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 705]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 773]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 773]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 760]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 743]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 684]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 440]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 440]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 440]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 440]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 440]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 64]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 128]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 64]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 128]
            }
         } else {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 791]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 785]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 772]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 746]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 695]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 757]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 757]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 744]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 719]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 668]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 412]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 412]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 412]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 412]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 412]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 64]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 128]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 64]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 128]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.ko_compl_data.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message ko_compl_data $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message ko_compl_data $legal_values
      }
   } else {
      auto_value_out_of_range_message auto ko_compl_data $ko_compl_data $legal_values { atomic_malformed func_mode max_payload_size rx_buffer_credit_alloc use_crc_forwarding }
   }
}

proc ::nf_hip::parameters::validate_ko_compl_header { PROP_M_AUTOSET PROP_M_AUTOWARN ko_compl_header atomic_malformed func_mode max_payload_size rx_buffer_credit_alloc use_crc_forwarding } {

   set legal_values [list 0:4095]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($atomic_malformed=="true") }] {
         if [expr { ($use_crc_forwarding=="false") }] {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 202]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 200]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 197]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 191]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 178]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 195]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 195]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 192]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 185]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 172]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
         } else {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 202]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 200]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 197]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 191]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 178]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 195]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 195]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 192]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 185]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 172]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
         }
      } else {
         if [expr { ($use_crc_forwarding=="false") }] {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 202]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 200]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 197]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 191]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 178]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 195]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 195]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 192]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 185]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 172]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
         } else {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 202]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 200]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 197]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 191]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 178]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 195]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 195]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 192]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 185]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 172]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.ko_compl_header.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message ko_compl_header $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message ko_compl_header $legal_values
      }
   } else {
      auto_value_out_of_range_message auto ko_compl_header $ko_compl_header $legal_values { atomic_malformed func_mode max_payload_size rx_buffer_credit_alloc use_crc_forwarding }
   }
}

proc ::nf_hip::parameters::validate_l01_entry_latency { PROP_M_AUTOSET PROP_M_AUTOWARN l01_entry_latency sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 31]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.l01_entry_latency.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message l01_entry_latency $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message l01_entry_latency $legal_values
      }
   } else {
      auto_value_out_of_range_message auto l01_entry_latency $l01_entry_latency $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_l0_exit_latency_diffclock { PROP_M_AUTOSET PROP_M_AUTOWARN l0_exit_latency_diffclock sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 6]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.l0_exit_latency_diffclock.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message l0_exit_latency_diffclock $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message l0_exit_latency_diffclock $legal_values
      }
   } else {
      auto_value_out_of_range_message auto l0_exit_latency_diffclock $l0_exit_latency_diffclock $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_l0_exit_latency_sameclock { PROP_M_AUTOSET PROP_M_AUTOWARN l0_exit_latency_sameclock sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 6]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.l0_exit_latency_sameclock.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message l0_exit_latency_sameclock $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message l0_exit_latency_sameclock $legal_values
      }
   } else {
      auto_value_out_of_range_message auto l0_exit_latency_sameclock $l0_exit_latency_sameclock $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_l0s_adj_rply_timer_dis { PROP_M_AUTOSET PROP_M_AUTOWARN l0s_adj_rply_timer_dis sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.l0s_adj_rply_timer_dis.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message l0s_adj_rply_timer_dis $legal_values
      }
   } else {
      auto_invalid_value_message auto l0s_adj_rply_timer_dis $l0s_adj_rply_timer_dis $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_l1_exit_latency_diffclock { PROP_M_AUTOSET PROP_M_AUTOWARN l1_exit_latency_diffclock func_mode } {

   set legal_values [list 0:7]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.l1_exit_latency_diffclock.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message l1_exit_latency_diffclock $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message l1_exit_latency_diffclock $legal_values
      }
   } else {
      auto_value_out_of_range_message auto l1_exit_latency_diffclock $l1_exit_latency_diffclock $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_l1_exit_latency_sameclock { PROP_M_AUTOSET PROP_M_AUTOWARN l1_exit_latency_sameclock func_mode } {

   set legal_values [list 0:7]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.l1_exit_latency_sameclock.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message l1_exit_latency_sameclock $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message l1_exit_latency_sameclock $legal_values
      }
   } else {
      auto_value_out_of_range_message auto l1_exit_latency_sameclock $l1_exit_latency_sameclock $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_l2_async_logic { PROP_M_AUTOSET PROP_M_AUTOWARN l2_async_logic sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.l2_async_logic.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message l2_async_logic $legal_values
      }
   } else {
      auto_invalid_value_message auto l2_async_logic $l2_async_logic $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_lane_mask { PROP_M_AUTOSET PROP_M_AUTOWARN lane_mask link_width } {

   set legal_values [list "ln_mask_x1" "ln_mask_x2" "ln_mask_x4" "ln_mask_x8"]

   if [expr { ($link_width=="x1") }] {
      set legal_values [intersect $legal_values [list "ln_mask_x1"]]
   } else {
      if [expr { ($link_width=="x2") }] {
         set legal_values [intersect $legal_values [list "ln_mask_x2"]]
      } else {
         if [expr { ($link_width=="x4") }] {
            set legal_values [intersect $legal_values [list "ln_mask_x4"]]
         } else {
            if [expr { ($link_width=="x8") }] {
               set legal_values [intersect $legal_values [list "ln_mask_x8"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.lane_mask.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message lane_mask $legal_values
      }
   } else {
      auto_invalid_value_message auto lane_mask $lane_mask $legal_values { link_width }
   }
}

proc ::nf_hip::parameters::validate_lane_rate { PROP_M_AUTOSET PROP_M_AUTOWARN lane_rate func_mode } {

   set legal_values [list "gen1" "gen2" "gen3"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "gen1"]]
   } else {
      set legal_values [intersect $legal_values [list "gen1" "gen2" "gen3"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.lane_rate.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message lane_rate $legal_values
      }
   } else {
      auto_invalid_value_message auto lane_rate $lane_rate $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_link_width { PROP_M_AUTOSET PROP_M_AUTOWARN link_width func_mode } {

   set legal_values [list "x1" "x2" "x4" "x8"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "x1"]]
   } else {
      set legal_values [intersect $legal_values [list "x8" "x4" "x2" "x1"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.link_width.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message link_width $legal_values
      }
   } else {
      auto_invalid_value_message auto link_width $link_width $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_lmi_hold_off_cfg_timer_en { PROP_M_AUTOSET PROP_M_AUTOWARN lmi_hold_off_cfg_timer_en sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.lmi_hold_off_cfg_timer_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message lmi_hold_off_cfg_timer_en $legal_values
      }
   } else {
      auto_invalid_value_message auto lmi_hold_off_cfg_timer_en $lmi_hold_off_cfg_timer_en $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_low_priority_vc { PROP_M_AUTOSET PROP_M_AUTOWARN low_priority_vc } {

   set legal_values [list "single_vc_low_pr"]

   set legal_values [intersect $legal_values [list "single_vc_low_pr"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.low_priority_vc.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message low_priority_vc $legal_values
      }
   } else {
      auto_invalid_value_message auto low_priority_vc $low_priority_vc $legal_values { }
   }
}

proc ::nf_hip::parameters::validate_ltr_mechanism { PROP_M_AUTOSET PROP_M_AUTOWARN ltr_mechanism sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.ltr_mechanism.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message ltr_mechanism $legal_values
      }
   } else {
      auto_invalid_value_message auto ltr_mechanism $ltr_mechanism $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_ltssm_1ms_timeout { PROP_M_AUTOSET PROP_M_AUTOWARN ltssm_1ms_timeout sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.ltssm_1ms_timeout.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message ltssm_1ms_timeout $legal_values
      }
   } else {
      auto_invalid_value_message auto ltssm_1ms_timeout $ltssm_1ms_timeout $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_ltssm_freqlocked_check { PROP_M_AUTOSET PROP_M_AUTOWARN ltssm_freqlocked_check sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.ltssm_freqlocked_check.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message ltssm_freqlocked_check $legal_values
      }
   } else {
      auto_invalid_value_message auto ltssm_freqlocked_check $ltssm_freqlocked_check $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_malformed_tlp_truncate_en { PROP_M_AUTOSET PROP_M_AUTOWARN malformed_tlp_truncate_en sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.malformed_tlp_truncate_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message malformed_tlp_truncate_en $legal_values
      }
   } else {
      auto_invalid_value_message auto malformed_tlp_truncate_en $malformed_tlp_truncate_en $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_max_link_width { PROP_M_AUTOSET PROP_M_AUTOWARN max_link_width link_width } {

   set legal_values [list "x1_link_width" "x2_link_width" "x4_link_width" "x8_link_width"]

   if [expr { ($link_width=="x1") }] {
      set legal_values [intersect $legal_values [list "x1_link_width"]]
   } else {
      if [expr { ($link_width=="x2") }] {
         set legal_values [intersect $legal_values [list "x2_link_width"]]
      } else {
         if [expr { ($link_width=="x4") }] {
            set legal_values [intersect $legal_values [list "x4_link_width"]]
         } else {
            if [expr { ($link_width=="x8") }] {
               set legal_values [intersect $legal_values [list "x8_link_width"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.max_link_width.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message max_link_width $legal_values
      }
   } else {
      auto_invalid_value_message auto max_link_width $max_link_width $legal_values { link_width }
   }
}

proc ::nf_hip::parameters::validate_max_payload_size { PROP_M_AUTOSET PROP_M_AUTOWARN max_payload_size func_mode } {

   set legal_values [list "payload_1024" "payload_128" "payload_2048" "payload_256" "payload_4096" "payload_512"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "payload_256"]]
   } else {
      set legal_values [intersect $legal_values [list "payload_128" "payload_256" "payload_512" "payload_1024" "payload_2048"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.max_payload_size.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message max_payload_size $legal_values
      }
   } else {
      auto_invalid_value_message auto max_payload_size $max_payload_size $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_maximum_current { PROP_M_AUTOSET PROP_M_AUTOWARN maximum_current func_mode } {

   set legal_values [list 0:7]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.maximum_current.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message maximum_current $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message maximum_current $legal_values
      }
   } else {
      auto_value_out_of_range_message auto maximum_current $maximum_current $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_millisecond_cycle_count { PROP_M_AUTOSET PROP_M_AUTOWARN millisecond_cycle_count core_clk_freq_mhz sim_mode sup_mode } {

   set legal_values [list 0:1048575]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($sim_mode=="enable") }] {
         if [expr { ($core_clk_freq_mhz=="core_clk_250mhz") }] {
            set legal_values [compare_eq $legal_values 400]
         }
         if [expr { ($core_clk_freq_mhz=="core_clk_125mhz") }] {
            set legal_values [compare_eq $legal_values 200]
         }
         if [expr { ($core_clk_freq_mhz=="core_clk_62p5mhz") }] {
            set legal_values [compare_eq $legal_values 100]
         }
      } else {
         if [expr { ($core_clk_freq_mhz=="core_clk_250mhz") }] {
            set legal_values [compare_eq $legal_values 248496]
         }
         if [expr { ($core_clk_freq_mhz=="core_clk_125mhz") }] {
            set legal_values [compare_eq $legal_values 124248]
         }
         if [expr { ($core_clk_freq_mhz=="core_clk_62p5mhz") }] {
            set legal_values [compare_eq $legal_values 62124]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.millisecond_cycle_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message millisecond_cycle_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message millisecond_cycle_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto millisecond_cycle_count $millisecond_cycle_count $legal_values { core_clk_freq_mhz sim_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_msi_64bit_addressing_capable { PROP_M_AUTOSET PROP_M_AUTOWARN msi_64bit_addressing_capable sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "true"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.msi_64bit_addressing_capable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message msi_64bit_addressing_capable $legal_values
      }
   } else {
      auto_invalid_value_message auto msi_64bit_addressing_capable $msi_64bit_addressing_capable $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_msi_masking_capable { PROP_M_AUTOSET PROP_M_AUTOWARN msi_masking_capable sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.msi_masking_capable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message msi_masking_capable $legal_values
      }
   } else {
      auto_invalid_value_message auto msi_masking_capable $msi_masking_capable $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_msi_multi_message_capable { PROP_M_AUTOSET PROP_M_AUTOWARN msi_multi_message_capable func_mode } {

   set legal_values [list "count_1" "count_16" "count_2" "count_32" "count_4" "count_8"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "count_4"]]
   } else {
      set legal_values [intersect $legal_values [list "count_1" "count_2" "count_4" "count_8" "count_16" "count_32"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.msi_multi_message_capable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message msi_multi_message_capable $legal_values
      }
   } else {
      auto_invalid_value_message auto msi_multi_message_capable $msi_multi_message_capable $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_msi_support { PROP_M_AUTOSET PROP_M_AUTOWARN msi_support sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "true"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.msi_support.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message msi_support $legal_values
      }
   } else {
      auto_invalid_value_message auto msi_support $msi_support $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_msix_pba_bir { PROP_M_AUTOSET PROP_M_AUTOWARN msix_pba_bir func_mode } {

   set legal_values [list 0:7]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.msix_pba_bir.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message msix_pba_bir $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message msix_pba_bir $legal_values
      }
   } else {
      auto_value_out_of_range_message auto msix_pba_bir $msix_pba_bir $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_msix_pba_offset { PROP_M_AUTOSET PROP_M_AUTOWARN msix_pba_offset func_mode } {

   set legal_values [list 0:536870911]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.msix_pba_offset.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message msix_pba_offset $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message msix_pba_offset $legal_values
      }
   } else {
      auto_value_out_of_range_message auto msix_pba_offset $msix_pba_offset $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_msix_table_bir { PROP_M_AUTOSET PROP_M_AUTOWARN msix_table_bir func_mode } {

   set legal_values [list 0:7]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.msix_table_bir.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message msix_table_bir $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message msix_table_bir $legal_values
      }
   } else {
      auto_value_out_of_range_message auto msix_table_bir $msix_table_bir $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_msix_table_offset { PROP_M_AUTOSET PROP_M_AUTOWARN msix_table_offset func_mode } {

   set legal_values [list 0:536870911]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.msix_table_offset.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message msix_table_offset $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message msix_table_offset $legal_values
      }
   } else {
      auto_value_out_of_range_message auto msix_table_offset $msix_table_offset $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_msix_table_size { PROP_M_AUTOSET PROP_M_AUTOWARN msix_table_size func_mode } {

   set legal_values [list 0:2047]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.msix_table_size.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message msix_table_size $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message msix_table_size $legal_values
      }
   } else {
      auto_value_out_of_range_message auto msix_table_size $msix_table_size $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_national_inst_thru_enhance { PROP_M_AUTOSET PROP_M_AUTOWARN national_inst_thru_enhance sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.national_inst_thru_enhance.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message national_inst_thru_enhance $legal_values
      }
   } else {
      auto_invalid_value_message auto national_inst_thru_enhance $national_inst_thru_enhance $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_no_command_completed { PROP_M_AUTOSET PROP_M_AUTOWARN no_command_completed enable_slot_register func_mode sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         if [expr { ($enable_slot_register=="false") }] {
            set legal_values [intersect $legal_values [list "false"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.no_command_completed.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message no_command_completed $legal_values
      }
   } else {
      auto_invalid_value_message auto no_command_completed $no_command_completed $legal_values { enable_slot_register func_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_no_soft_reset { PROP_M_AUTOSET PROP_M_AUTOWARN no_soft_reset sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.no_soft_reset.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message no_soft_reset $legal_values
      }
   } else {
      auto_invalid_value_message auto no_soft_reset $no_soft_reset $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_not_use_k_gbl_bits { PROP_M_AUTOSET PROP_M_AUTOWARN not_use_k_gbl_bits } {

   set legal_values [list "not_used_k_gbl"]

   set legal_values [intersect $legal_values [list "not_used_k_gbl"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.not_use_k_gbl_bits.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message not_use_k_gbl_bits $legal_values
      }
   } else {
      auto_invalid_value_message auto not_use_k_gbl_bits $not_use_k_gbl_bits $legal_values { }
   }
}

proc ::nf_hip::parameters::validate_operating_voltage { PROP_M_AUTOSET PROP_M_AUTOWARN operating_voltage sup_mode } {

   set legal_values [list "standard" "vidint" "vidmin"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "standard"]]
   } else {
      set legal_values [intersect $legal_values [list "standard" "vidint" "vidmin"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.operating_voltage.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message operating_voltage $legal_values
      }
   } else {
      auto_invalid_value_message auto operating_voltage $operating_voltage $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_pcie_base_spec { PROP_M_AUTOSET PROP_M_AUTOWARN pcie_base_spec } {

   set legal_values [list "pcie_2p1" "pcie_3p0"]

   set legal_values [intersect $legal_values [list "pcie_3p0"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pcie_base_spec.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pcie_base_spec $legal_values
      }
   } else {
      auto_invalid_value_message auto pcie_base_spec $pcie_base_spec $legal_values { }
   }
}

proc ::nf_hip::parameters::validate_pcie_mode { PROP_M_AUTOSET PROP_M_AUTOWARN pcie_mode port_type } {

   set legal_values [list "bridge" "ep_legacy" "ep_native" "rp" "shared_mode" "switch_mode" "sw_dn" "sw_up"]

   if [expr { ($port_type=="native_ep") }] {
      set legal_values [intersect $legal_values [list "ep_native"]]
   }
   if [expr { ($port_type=="legacy_ep") }] {
      set legal_values [intersect $legal_values [list "ep_legacy"]]
   }
   if [expr { ($port_type=="root_port") }] {
      set legal_values [intersect $legal_values [list "rp"]]
   }
   if [expr { ($port_type=="others") }] {
      set legal_values [intersect $legal_values [list "shared_mode" "bridge" "sw_up" "sw_dn" "switch_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pcie_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pcie_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto pcie_mode $pcie_mode $legal_values { port_type }
   }
}

proc ::nf_hip::parameters::validate_pcie_spec_1p0_compliance { PROP_M_AUTOSET PROP_M_AUTOWARN pcie_spec_1p0_compliance } {

   set legal_values [list "spec_1p0a" "spec_1p1"]

   set legal_values [intersect $legal_values [list "spec_1p1"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pcie_spec_1p0_compliance.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pcie_spec_1p0_compliance $legal_values
      }
   } else {
      auto_invalid_value_message auto pcie_spec_1p0_compliance $pcie_spec_1p0_compliance $legal_values { }
   }
}

proc ::nf_hip::parameters::validate_pcie_spec_version { PROP_M_AUTOSET PROP_M_AUTOWARN pcie_spec_version pcie_base_spec } {

   set legal_values [list "v1" "v2" "v3"]

   if [expr { ($pcie_base_spec=="pcie_2p1") }] {
      set legal_values [intersect $legal_values [list "v2"]]
   } else {
      if [expr { ($pcie_base_spec=="pcie_3p0") }] {
         set legal_values [intersect $legal_values [list "v3"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pcie_spec_version.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pcie_spec_version $legal_values
      }
   } else {
      auto_invalid_value_message auto pcie_spec_version $pcie_spec_version $legal_values { pcie_base_spec }
   }
}

proc ::nf_hip::parameters::validate_pclk_out_sel { PROP_M_AUTOSET PROP_M_AUTOWARN pclk_out_sel func_mode sup_mode } {

   set legal_values [list "core_clk_in_p" "pclk"]

   if [expr { ($func_mode=="enable") }] {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "pclk"]]
      } else {
         set legal_values [intersect $legal_values [list "pclk" "core_clk_in_p"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "pclk"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pclk_out_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pclk_out_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto pclk_out_sel $pclk_out_sel $legal_values { func_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_pld_in_use_reg { PROP_M_AUTOSET PROP_M_AUTOWARN pld_in_use_reg sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pld_in_use_reg.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pld_in_use_reg $legal_values
      }
   } else {
      auto_invalid_value_message auto pld_in_use_reg $pld_in_use_reg $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_pm_latency_patch_dis { PROP_M_AUTOSET PROP_M_AUTOWARN pm_latency_patch_dis sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pm_latency_patch_dis.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pm_latency_patch_dis $legal_values
      }
   } else {
      auto_invalid_value_message auto pm_latency_patch_dis $pm_latency_patch_dis $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_pm_txdl_patch_dis { PROP_M_AUTOSET PROP_M_AUTOWARN pm_txdl_patch_dis sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pm_txdl_patch_dis.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pm_txdl_patch_dis $legal_values
      }
   } else {
      auto_invalid_value_message auto pm_txdl_patch_dis $pm_txdl_patch_dis $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_pme_clock { PROP_M_AUTOSET PROP_M_AUTOWARN pme_clock sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pme_clock.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pme_clock $legal_values
      }
   } else {
      auto_invalid_value_message auto pme_clock $pme_clock $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_port_link_number { PROP_M_AUTOSET PROP_M_AUTOWARN port_link_number port_type sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
         set legal_values [compare_eq $legal_values 1]
      }
      if [expr { ($port_type=="root_port") }] {
         set legal_values [compare_ge $legal_values 0]
         set legal_values [compare_le $legal_values 31]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.port_link_number.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message port_link_number $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message port_link_number $legal_values
      }
   } else {
      auto_value_out_of_range_message auto port_link_number $port_link_number $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_port_type { PROP_M_AUTOSET PROP_M_AUTOWARN port_type func_mode } {

   set legal_values [list "legacy_ep" "native_ep" "others" "root_port"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "native_ep"]]
   } else {
      set legal_values [intersect $legal_values [list "native_ep" "legacy_ep" "root_port" "others"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.port_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message port_type $legal_values
      }
   } else {
      auto_invalid_value_message auto port_type $port_type $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_prefetchable_mem_window_addr_width { PROP_M_AUTOSET PROP_M_AUTOWARN prefetchable_mem_window_addr_width func_mode port_type } {

   set legal_values [list "prefetch_0" "prefetch_32" "prefetch_64"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "prefetch_0"]]
   } else {
      if [expr { ($port_type=="root_port") }] {
         set legal_values [intersect $legal_values [list "prefetch_0" "prefetch_64"]]
      } else {
         set legal_values [intersect $legal_values [list "prefetch_0"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.prefetchable_mem_window_addr_width.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message prefetchable_mem_window_addr_width $legal_values
      }
   } else {
      auto_invalid_value_message auto prefetchable_mem_window_addr_width $prefetchable_mem_window_addr_width $legal_values { func_mode port_type }
   }
}

proc ::nf_hip::parameters::validate_r2c_mask_easy { PROP_M_AUTOSET PROP_M_AUTOWARN r2c_mask_easy r2c_mask_enable sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($r2c_mask_enable=="true") }] {
      if [expr { ($sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.r2c_mask_easy.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message r2c_mask_easy $legal_values
      }
   } else {
      auto_invalid_value_message auto r2c_mask_easy $r2c_mask_easy $legal_values { r2c_mask_enable sup_mode }
   }
}

proc ::nf_hip::parameters::validate_r2c_mask_enable { PROP_M_AUTOSET PROP_M_AUTOWARN r2c_mask_enable sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.r2c_mask_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message r2c_mask_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto r2c_mask_enable $r2c_mask_enable $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rec_frqlk_mon_en { PROP_M_AUTOSET PROP_M_AUTOWARN rec_frqlk_mon_en sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rec_frqlk_mon_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rec_frqlk_mon_en $legal_values
      }
   } else {
      auto_invalid_value_message auto rec_frqlk_mon_en $rec_frqlk_mon_en $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_register_pipe_signals { PROP_M_AUTOSET PROP_M_AUTOWARN register_pipe_signals sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "true"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.register_pipe_signals.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message register_pipe_signals $legal_values
      }
   } else {
      auto_invalid_value_message auto register_pipe_signals $register_pipe_signals $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_retry_buffer_last_active_address { PROP_M_AUTOSET PROP_M_AUTOWARN retry_buffer_last_active_address sup_mode } {

   set legal_values [list 0:1023]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 1023]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.retry_buffer_last_active_address.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message retry_buffer_last_active_address $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message retry_buffer_last_active_address $legal_values
      }
   } else {
      auto_value_out_of_range_message auto retry_buffer_last_active_address $retry_buffer_last_active_address $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_retry_buffer_memory_settings { PROP_M_AUTOSET PROP_M_AUTOWARN retry_buffer_memory_settings sup_mode } {

   set legal_values [list 0:68719476735]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 12885005388]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.retry_buffer_memory_settings.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message retry_buffer_memory_settings $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message retry_buffer_memory_settings $legal_values
      }
   } else {
      auto_value_out_of_range_message auto retry_buffer_memory_settings $retry_buffer_memory_settings $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_retry_ecc_corr_mask_dis { PROP_M_AUTOSET PROP_M_AUTOWARN retry_ecc_corr_mask_dis sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.retry_ecc_corr_mask_dis.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message retry_ecc_corr_mask_dis $legal_values
      }
   } else {
      auto_invalid_value_message auto retry_ecc_corr_mask_dis $retry_ecc_corr_mask_dis $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_revision_id { PROP_M_AUTOSET PROP_M_AUTOWARN revision_id func_mode } {

   set legal_values [list 0:255]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 1]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.revision_id.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message revision_id $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message revision_id $legal_values
      }
   } else {
      auto_value_out_of_range_message auto revision_id $revision_id $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_role_based_error_reporting { PROP_M_AUTOSET PROP_M_AUTOWARN role_based_error_reporting sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "true"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.role_based_error_reporting.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message role_based_error_reporting $legal_values
      }
   } else {
      auto_invalid_value_message auto role_based_error_reporting $role_based_error_reporting $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rp_bug_fix_pri_sec_stat_reg { PROP_M_AUTOSET PROP_M_AUTOWARN rp_bug_fix_pri_sec_stat_reg sup_mode } {

   set legal_values [list 0:127]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 127]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rp_bug_fix_pri_sec_stat_reg.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rp_bug_fix_pri_sec_stat_reg $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rp_bug_fix_pri_sec_stat_reg $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rp_bug_fix_pri_sec_stat_reg $rp_bug_fix_pri_sec_stat_reg $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rpltim_base { PROP_M_AUTOSET PROP_M_AUTOWARN rpltim_base sup_mode } {

   set legal_values [list 0:16383]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 16]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rpltim_base.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rpltim_base $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rpltim_base $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rpltim_base $rpltim_base $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rpltim_set { PROP_M_AUTOSET PROP_M_AUTOWARN rpltim_set sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "true"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rpltim_set.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rpltim_set $legal_values
      }
   } else {
      auto_invalid_value_message auto rpltim_set $rpltim_set $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctl_ltssm_dis { PROP_M_AUTOSET PROP_M_AUTOWARN rstctl_ltssm_dis sim_mode sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($sim_mode=="enable") }] {
         set legal_values [intersect $legal_values [list "true"]]
      } else {
         set legal_values [intersect $legal_values [list "false"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctl_ltssm_dis.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctl_ltssm_dis $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctl_ltssm_dis $rstctl_ltssm_dis $legal_values { sim_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_1ms_count_fref_clk { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_1ms_count_fref_clk sup_mode } {

   set legal_values [list 0:1048575]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 100000]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rstctrl_1ms_count_fref_clk.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rstctrl_1ms_count_fref_clk $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rstctrl_1ms_count_fref_clk $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rstctrl_1ms_count_fref_clk $rstctrl_1ms_count_fref_clk $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_1us_count_fref_clk { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_1us_count_fref_clk sup_mode } {

   set legal_values [list 0:1048575]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 100]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rstctrl_1us_count_fref_clk.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rstctrl_1us_count_fref_clk $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rstctrl_1us_count_fref_clk $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rstctrl_1us_count_fref_clk $rstctrl_1us_count_fref_clk $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_altpe3_crst_n_inv { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_altpe3_crst_n_inv sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_altpe3_crst_n_inv.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_altpe3_crst_n_inv $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_altpe3_crst_n_inv $rstctrl_altpe3_crst_n_inv $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_altpe3_rst_n_inv { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_altpe3_rst_n_inv sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_altpe3_rst_n_inv.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_altpe3_rst_n_inv $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_altpe3_rst_n_inv $rstctrl_altpe3_rst_n_inv $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_altpe3_srst_n_inv { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_altpe3_srst_n_inv sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_altpe3_srst_n_inv.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_altpe3_srst_n_inv $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_altpe3_srst_n_inv $rstctrl_altpe3_srst_n_inv $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_chnl_cal_done_select { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_chnl_cal_done_select link_width uc_calibration_en } {

   set legal_values [list "ch01234567_out_chnl_cal_done" "ch0123_out_chnl_cal_done" "ch01_out_chnl_cal_done" "ch0_out_chnl_cal_done" "not_active_chnl_cal_done"]

   if [expr { ($uc_calibration_en=="uc_calibration_dis") }] {
      set legal_values [intersect $legal_values [list "not_active_chnl_cal_done"]]
   } else {
      if [expr { ($link_width=="x1") }] {
         set legal_values [intersect $legal_values [list "ch0_out_chnl_cal_done"]]
      } else {
         if [expr { ($link_width=="x2") }] {
            set legal_values [intersect $legal_values [list "ch01_out_chnl_cal_done"]]
         } else {
            if [expr { ($link_width=="x4") }] {
               set legal_values [intersect $legal_values [list "ch0123_out_chnl_cal_done"]]
            } else {
               if [expr { ($link_width=="x8") }] {
                  set legal_values [intersect $legal_values [list "ch01234567_out_chnl_cal_done"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_chnl_cal_done_select.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_chnl_cal_done_select $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_chnl_cal_done_select $rstctrl_chnl_cal_done_select $legal_values { link_width uc_calibration_en }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_debug_en { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_debug_en sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_debug_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_debug_en $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_debug_en $rstctrl_debug_en $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_force_inactive_rst { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_force_inactive_rst hrdrstctrl_en } {

   set legal_values [list "false" "true"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_force_inactive_rst.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_force_inactive_rst $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_force_inactive_rst $rstctrl_force_inactive_rst $legal_values { hrdrstctrl_en }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_fref_clk_select { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_fref_clk_select hrdrstctrl_en } {

   set legal_values [list "ch0_sel" "ch1_sel" "ch2_sel" "ch3_sel" "ch4_sel" "ch5_sel" "ch6_sel" "ch7_sel"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "ch0_sel"]]
   } else {
      set legal_values [intersect $legal_values [list "ch0_sel"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_fref_clk_select.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_fref_clk_select $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_fref_clk_select $rstctrl_fref_clk_select $legal_values { hrdrstctrl_en }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_hard_block_enable { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_hard_block_enable hrdrstctrl_en } {

   set legal_values [list "hard_rst_ctl" "pld_rst_ctl"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "pld_rst_ctl"]]
   } else {
      set legal_values [intersect $legal_values [list "hard_rst_ctl"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_hard_block_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_hard_block_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_hard_block_enable $rstctrl_hard_block_enable $legal_values { hrdrstctrl_en }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_hip_ep { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_hip_ep port_type } {

   set legal_values [list "hip_ep" "hip_not_ep"]

   if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
      set legal_values [intersect $legal_values [list "hip_ep"]]
   } else {
      set legal_values [intersect $legal_values [list "hip_not_ep"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_hip_ep.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_hip_ep $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_hip_ep $rstctrl_hip_ep $legal_values { port_type }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_mask_tx_pll_lock_select { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_mask_tx_pll_lock_select hrdrstctrl_en link_width } {

   set legal_values [list "ch0_sel_mask_tx_pll_lock" "ch1_sel_mask_tx_pll_lock" "ch3_sel_mask_tx_pll_lock" "not_active_mask_tx_pll_lock"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "not_active_mask_tx_pll_lock"]]
   } else {
      if [expr { ($link_width=="x1") }] {
         set legal_values [intersect $legal_values [list "ch0_sel_mask_tx_pll_lock"]]
      } else {
         if [expr { ($link_width=="x2") }] {
            set legal_values [intersect $legal_values [list "ch0_sel_mask_tx_pll_lock"]]
         } else {
            if [expr { ($link_width=="x4") }] {
               set legal_values [intersect $legal_values [list "ch3_sel_mask_tx_pll_lock"]]
            } else {
               if [expr { ($link_width=="x8") }] {
                  set legal_values [intersect $legal_values [list "ch3_sel_mask_tx_pll_lock"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_mask_tx_pll_lock_select.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_mask_tx_pll_lock_select $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_mask_tx_pll_lock_select $rstctrl_mask_tx_pll_lock_select $legal_values { hrdrstctrl_en link_width }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_perst_enable { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_perst_enable sup_mode } {

   set legal_values [list "level" "neg_edge" "not_used"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "level"]]
   } else {
      set legal_values [intersect $legal_values [list "level" "neg_edge" "not_used"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_perst_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_perst_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_perst_enable $rstctrl_perst_enable $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_perstn_select { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_perstn_select hrdrstctrl_en } {

   set legal_values [list "perstn_pin" "perstn_pld"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "perstn_pin"]]
   } else {
      set legal_values [intersect $legal_values [list "perstn_pin"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_perstn_select.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_perstn_select $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_perstn_select $rstctrl_perstn_select $legal_values { hrdrstctrl_en }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_pld_clr { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_pld_clr hrdrstctrl_en } {

   set legal_values [list "false" "true"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_pld_clr.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_pld_clr $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_pld_clr $rstctrl_pld_clr $legal_values { hrdrstctrl_en }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_pll_cal_done_select { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_pll_cal_done_select gen2_pma_pll_usage lane_rate link_width uc_calibration_en } {

   set legal_values [list "ch01_sel_pll_cal_done" "ch0_sel_pll_cal_done" "ch1_sel_pll_cal_done" "ch34_sel_pll_cal_done" "ch3_sel_pll_cal_done" "ch4_sel_pll_cal_done" "not_active_pll_cal_done"]

   if [expr { ($uc_calibration_en=="uc_calibration_dis") }] {
      set legal_values [intersect $legal_values [list "not_active_pll_cal_done"]]
   } else {
      if [expr { (($link_width=="x1")||($link_width=="x2")) }] {
         if [expr { ($lane_rate=="gen3") }] {
            set legal_values [intersect $legal_values [list "ch01_sel_pll_cal_done"]]
         } else {
            if [expr { ($gen2_pma_pll_usage=="use_lcpll") }] {
               set legal_values [intersect $legal_values [list "ch0_sel_pll_cal_done"]]
            } else {
               set legal_values [intersect $legal_values [list "ch1_sel_pll_cal_done"]]
            }
         }
      } else {
         if [expr { (($link_width=="x4")||($link_width=="x8")) }] {
            if [expr { ($lane_rate=="gen3") }] {
               set legal_values [intersect $legal_values [list "ch34_sel_pll_cal_done"]]
            } else {
               if [expr { ($gen2_pma_pll_usage=="use_lcpll") }] {
                  set legal_values [intersect $legal_values [list "ch3_sel_pll_cal_done"]]
               } else {
                  set legal_values [intersect $legal_values [list "ch4_sel_pll_cal_done"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_pll_cal_done_select.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_pll_cal_done_select $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_pll_cal_done_select $rstctrl_pll_cal_done_select $legal_values { gen2_pma_pll_usage lane_rate link_width uc_calibration_en }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_rx_pcs_rst_n_inv { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_rx_pcs_rst_n_inv sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_rx_pcs_rst_n_inv.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_rx_pcs_rst_n_inv $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_rx_pcs_rst_n_inv $rstctrl_rx_pcs_rst_n_inv $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_rx_pcs_rst_n_select { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_rx_pcs_rst_n_select hrdrstctrl_en link_width } {

   set legal_values [list "ch01234567_out_rx_pcs_rst" "ch0123_out_rx_pcs_rst" "ch01_out_rx_pcs_rst" "ch0_out_rx_pcs_rst" "not_active_rx_pcs_rst"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "not_active_rx_pcs_rst"]]
   } else {
      if [expr { ($link_width=="x1") }] {
         set legal_values [intersect $legal_values [list "ch0_out_rx_pcs_rst"]]
      } else {
         if [expr { ($link_width=="x2") }] {
            set legal_values [intersect $legal_values [list "ch01_out_rx_pcs_rst"]]
         } else {
            if [expr { ($link_width=="x4") }] {
               set legal_values [intersect $legal_values [list "ch0123_out_rx_pcs_rst"]]
            } else {
               if [expr { ($link_width=="x8") }] {
                  set legal_values [intersect $legal_values [list "ch01234567_out_rx_pcs_rst"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_rx_pcs_rst_n_select.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_rx_pcs_rst_n_select $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_rx_pcs_rst_n_select $rstctrl_rx_pcs_rst_n_select $legal_values { hrdrstctrl_en link_width }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_rx_pll_freq_lock_select { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_rx_pll_freq_lock_select hrdrstctrl_en link_width } {

   set legal_values [list "ch01234567_phs_sel_rx_pll_f_lock" "ch01234567_sel_rx_pll_f_lock" "ch0123_phs_sel_rx_pll_f_lock" "ch0123_sel_rx_pll_f_lock" "ch01_phs_sel_rx_pll_f_lock" "ch01_sel_rx_pll_f_lock" "ch0_phs_sel_rx_pll_f_lock" "ch0_sel_rx_pll_f_lock" "not_active_rx_pll_f_lock"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "not_active_rx_pll_f_lock"]]
   } else {
      if [expr { ($link_width=="x1") }] {
         set legal_values [intersect $legal_values [list "not_active_rx_pll_f_lock"]]
      } else {
         if [expr { ($link_width=="x2") }] {
            set legal_values [intersect $legal_values [list "not_active_rx_pll_f_lock"]]
         } else {
            if [expr { ($link_width=="x4") }] {
               set legal_values [intersect $legal_values [list "not_active_rx_pll_f_lock"]]
            } else {
               if [expr { ($link_width=="x8") }] {
                  set legal_values [intersect $legal_values [list "not_active_rx_pll_f_lock"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_rx_pll_freq_lock_select.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_rx_pll_freq_lock_select $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_rx_pll_freq_lock_select $rstctrl_rx_pll_freq_lock_select $legal_values { hrdrstctrl_en link_width }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_rx_pll_lock_select { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_rx_pll_lock_select hrdrstctrl_en link_width } {

   set legal_values [list "ch01234567_sel_rx_pll_lock" "ch0123_sel_rx_pll_lock" "ch01_sel_rx_pll_lock" "ch0_sel_rx_pll_lock" "not_active_rx_pll_lock"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "not_active_rx_pll_lock"]]
   } else {
      if [expr { ($link_width=="x1") }] {
         set legal_values [intersect $legal_values [list "ch0_sel_rx_pll_lock"]]
      } else {
         if [expr { ($link_width=="x2") }] {
            set legal_values [intersect $legal_values [list "ch01_sel_rx_pll_lock"]]
         } else {
            if [expr { ($link_width=="x4") }] {
               set legal_values [intersect $legal_values [list "ch0123_sel_rx_pll_lock"]]
            } else {
               if [expr { ($link_width=="x8") }] {
                  set legal_values [intersect $legal_values [list "ch01234567_sel_rx_pll_lock"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_rx_pll_lock_select.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_rx_pll_lock_select $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_rx_pll_lock_select $rstctrl_rx_pll_lock_select $legal_values { hrdrstctrl_en link_width }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_rx_pma_rstb_inv { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_rx_pma_rstb_inv sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_rx_pma_rstb_inv.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_rx_pma_rstb_inv $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_rx_pma_rstb_inv $rstctrl_rx_pma_rstb_inv $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_rx_pma_rstb_select { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_rx_pma_rstb_select hrdrstctrl_en link_width } {

   set legal_values [list "ch01234567_out_rx_pma_rstb" "ch0123_out_rx_pma_rstb" "ch01_out_rx_pma_rstb" "ch0_out_rx_pma_rstb" "not_active_rx_pma_rstb"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "not_active_rx_pma_rstb"]]
   } else {
      if [expr { ($link_width=="x1") }] {
         set legal_values [intersect $legal_values [list "ch0_out_rx_pma_rstb"]]
      } else {
         if [expr { ($link_width=="x2") }] {
            set legal_values [intersect $legal_values [list "ch01_out_rx_pma_rstb"]]
         } else {
            if [expr { ($link_width=="x4") }] {
               set legal_values [intersect $legal_values [list "ch0123_out_rx_pma_rstb"]]
            } else {
               if [expr { ($link_width=="x8") }] {
                  set legal_values [intersect $legal_values [list "ch01234567_out_rx_pma_rstb"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_rx_pma_rstb_select.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_rx_pma_rstb_select $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_rx_pma_rstb_select $rstctrl_rx_pma_rstb_select $legal_values { hrdrstctrl_en link_width }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_timer_a { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_timer_a sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 10]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rstctrl_timer_a.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rstctrl_timer_a $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rstctrl_timer_a $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rstctrl_timer_a $rstctrl_timer_a $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_timer_a_type { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_timer_a_type hrdrstctrl_en } {

   set legal_values [list "a_timer_fref_cycles" "a_timer_micro_secs" "a_timer_milli_secs" "a_timer_not_enabled"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "a_timer_not_enabled"]]
   } else {
      set legal_values [intersect $legal_values [list "a_timer_fref_cycles"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_timer_a_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_timer_a_type $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_timer_a_type $rstctrl_timer_a_type $legal_values { hrdrstctrl_en }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_timer_b { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_timer_b sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 10]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rstctrl_timer_b.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rstctrl_timer_b $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rstctrl_timer_b $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rstctrl_timer_b $rstctrl_timer_b $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_timer_b_type { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_timer_b_type hrdrstctrl_en } {

   set legal_values [list "b_timer_fref_cycles" "b_timer_micro_secs" "b_timer_milli_secs" "b_timer_not_enabled"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "b_timer_not_enabled"]]
   } else {
      set legal_values [intersect $legal_values [list "b_timer_fref_cycles"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_timer_b_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_timer_b_type $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_timer_b_type $rstctrl_timer_b_type $legal_values { hrdrstctrl_en }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_timer_c { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_timer_c sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 10]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rstctrl_timer_c.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rstctrl_timer_c $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rstctrl_timer_c $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rstctrl_timer_c $rstctrl_timer_c $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_timer_c_type { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_timer_c_type hrdrstctrl_en } {

   set legal_values [list "c_timer_fref_cycles" "c_timer_micro_secs" "c_timer_milli_secs" "c_timer_not_enabled"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "c_timer_not_enabled"]]
   } else {
      set legal_values [intersect $legal_values [list "c_timer_fref_cycles"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_timer_c_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_timer_c_type $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_timer_c_type $rstctrl_timer_c_type $legal_values { hrdrstctrl_en }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_timer_d { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_timer_d sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 20]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rstctrl_timer_d.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rstctrl_timer_d $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rstctrl_timer_d $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rstctrl_timer_d $rstctrl_timer_d $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_timer_d_type { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_timer_d_type hrdrstctrl_en } {

   set legal_values [list "d_timer_fref_cycles" "d_timer_micro_secs" "d_timer_milli_secs" "d_timer_not_enabled"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "d_timer_not_enabled"]]
   } else {
      set legal_values [intersect $legal_values [list "d_timer_fref_cycles"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_timer_d_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_timer_d_type $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_timer_d_type $rstctrl_timer_d_type $legal_values { hrdrstctrl_en }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_timer_e { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_timer_e sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 1]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rstctrl_timer_e.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rstctrl_timer_e $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rstctrl_timer_e $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rstctrl_timer_e $rstctrl_timer_e $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_timer_e_type { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_timer_e_type hrdrstctrl_en } {

   set legal_values [list "e_timer_fref_cycles" "e_timer_micro_secs" "e_timer_milli_secs" "e_timer_not_enabled"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "e_timer_not_enabled"]]
   } else {
      set legal_values [intersect $legal_values [list "e_timer_fref_cycles"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_timer_e_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_timer_e_type $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_timer_e_type $rstctrl_timer_e_type $legal_values { hrdrstctrl_en }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_timer_f { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_timer_f sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 10]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rstctrl_timer_f.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rstctrl_timer_f $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rstctrl_timer_f $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rstctrl_timer_f $rstctrl_timer_f $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_timer_f_type { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_timer_f_type hrdrstctrl_en } {

   set legal_values [list "f_timer_fref_cycles" "f_timer_micro_secs" "f_timer_milli_secs" "f_timer_not_enabled"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "f_timer_not_enabled"]]
   } else {
      set legal_values [intersect $legal_values [list "f_timer_fref_cycles"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_timer_f_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_timer_f_type $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_timer_f_type $rstctrl_timer_f_type $legal_values { hrdrstctrl_en }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_timer_g { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_timer_g sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 10]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rstctrl_timer_g.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rstctrl_timer_g $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rstctrl_timer_g $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rstctrl_timer_g $rstctrl_timer_g $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_timer_g_type { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_timer_g_type hrdrstctrl_en } {

   set legal_values [list "g_timer_fref_cycles" "g_timer_micro_secs" "g_timer_milli_secs" "g_timer_not_enabled"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "g_timer_not_enabled"]]
   } else {
      set legal_values [intersect $legal_values [list "g_timer_fref_cycles"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_timer_g_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_timer_g_type $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_timer_g_type $rstctrl_timer_g_type $legal_values { hrdrstctrl_en }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_timer_h { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_timer_h sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 4]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rstctrl_timer_h.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rstctrl_timer_h $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rstctrl_timer_h $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rstctrl_timer_h $rstctrl_timer_h $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_timer_h_type { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_timer_h_type hrdrstctrl_en } {

   set legal_values [list "h_timer_fref_cycles" "h_timer_micro_secs" "h_timer_milli_secs" "h_timer_not_enabled"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "h_timer_not_enabled"]]
   } else {
      set legal_values [intersect $legal_values [list "h_timer_micro_secs"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_timer_h_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_timer_h_type $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_timer_h_type $rstctrl_timer_h_type $legal_values { hrdrstctrl_en }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_timer_i { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_timer_i sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 20]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rstctrl_timer_i.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rstctrl_timer_i $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rstctrl_timer_i $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rstctrl_timer_i $rstctrl_timer_i $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_timer_i_type { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_timer_i_type hrdrstctrl_en } {

   set legal_values [list "i_timer_fref_cycles" "i_timer_micro_secs" "i_timer_milli_secs" "i_timer_not_enabled"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "i_timer_not_enabled"]]
   } else {
      set legal_values [intersect $legal_values [list "i_timer_fref_cycles"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_timer_i_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_timer_i_type $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_timer_i_type $rstctrl_timer_i_type $legal_values { hrdrstctrl_en }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_timer_j { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_timer_j sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 20]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rstctrl_timer_j.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rstctrl_timer_j $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rstctrl_timer_j $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rstctrl_timer_j $rstctrl_timer_j $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_timer_j_type { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_timer_j_type hrdrstctrl_en } {

   set legal_values [list "j_timer_fref_cycles" "j_timer_micro_secs" "j_timer_milli_secs" "j_timer_not_enabled"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "j_timer_not_enabled"]]
   } else {
      set legal_values [intersect $legal_values [list "j_timer_fref_cycles"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_timer_j_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_timer_j_type $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_timer_j_type $rstctrl_timer_j_type $legal_values { hrdrstctrl_en }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_tx_lcff_pll_lock_select { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_tx_lcff_pll_lock_select gen2_pma_pll_usage hrdrstctrl_en lane_rate link_width } {

   set legal_values [list "ch01_sel_lcff_pll_lock" "ch0_sel_lcff_pll_lock" "ch1_sel_lcff_pll_lock" "ch34_sel_lcff_pll_lock" "ch3_sel_lcff_pll_lock" "ch4_sel_lcff_pll_lock" "not_active_lcff_pll_lock"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "not_active_lcff_pll_lock"]]
   } else {
      if [expr { (($link_width=="x1")||($link_width=="x2")) }] {
         if [expr { ($lane_rate=="gen3") }] {
            set legal_values [intersect $legal_values [list "ch01_sel_lcff_pll_lock"]]
         } else {
            if [expr { ($gen2_pma_pll_usage=="use_lcpll") }] {
               set legal_values [intersect $legal_values [list "ch0_sel_lcff_pll_lock"]]
            } else {
               set legal_values [intersect $legal_values [list "ch1_sel_lcff_pll_lock"]]
            }
         }
      } else {
         if [expr { (($link_width=="x4")||($link_width=="x8")) }] {
            if [expr { ($lane_rate=="gen3") }] {
               set legal_values [intersect $legal_values [list "ch34_sel_lcff_pll_lock"]]
            } else {
               if [expr { ($gen2_pma_pll_usage=="use_lcpll") }] {
                  set legal_values [intersect $legal_values [list "ch3_sel_lcff_pll_lock"]]
               } else {
                  set legal_values [intersect $legal_values [list "ch4_sel_lcff_pll_lock"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_tx_lcff_pll_lock_select.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_tx_lcff_pll_lock_select $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_tx_lcff_pll_lock_select $rstctrl_tx_lcff_pll_lock_select $legal_values { gen2_pma_pll_usage hrdrstctrl_en lane_rate link_width }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_tx_lcff_pll_rstb_select { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_tx_lcff_pll_rstb_select gen2_pma_pll_usage hrdrstctrl_en lane_rate link_width } {

   set legal_values [list "ch01_out_lcff_pll_rstb" "ch0_out_lcff_pll_rstb" "ch1_out_lcff_pll_rstb" "ch34_out_lcff_pll_rstb" "ch3_out_lcff_pll_rstb" "ch4_out_lcff_pll_rstb" "not_active_lcff_pll_rstb"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "not_active_lcff_pll_rstb"]]
   } else {
      if [expr { (($link_width=="x1")||($link_width=="x2")) }] {
         if [expr { ($lane_rate=="gen3") }] {
            set legal_values [intersect $legal_values [list "ch01_out_lcff_pll_rstb"]]
         } else {
            if [expr { ($gen2_pma_pll_usage=="use_lcpll") }] {
               set legal_values [intersect $legal_values [list "ch0_out_lcff_pll_rstb"]]
            } else {
               set legal_values [intersect $legal_values [list "ch1_out_lcff_pll_rstb"]]
            }
         }
      } else {
         if [expr { (($link_width=="x4")||($link_width=="x8")) }] {
            if [expr { ($lane_rate=="gen3") }] {
               set legal_values [intersect $legal_values [list "ch34_out_lcff_pll_rstb"]]
            } else {
               if [expr { ($gen2_pma_pll_usage=="use_lcpll") }] {
                  set legal_values [intersect $legal_values [list "ch3_out_lcff_pll_rstb"]]
               } else {
                  set legal_values [intersect $legal_values [list "ch4_out_lcff_pll_rstb"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_tx_lcff_pll_rstb_select.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_tx_lcff_pll_rstb_select $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_tx_lcff_pll_rstb_select $rstctrl_tx_lcff_pll_rstb_select $legal_values { gen2_pma_pll_usage hrdrstctrl_en lane_rate link_width }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_tx_pcs_rst_n_inv { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_tx_pcs_rst_n_inv sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_tx_pcs_rst_n_inv.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_tx_pcs_rst_n_inv $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_tx_pcs_rst_n_inv $rstctrl_tx_pcs_rst_n_inv $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_tx_pcs_rst_n_select { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_tx_pcs_rst_n_select hrdrstctrl_en link_width } {

   set legal_values [list "ch01234567_out_tx_pcs_rst" "ch0123_out_tx_pcs_rst" "ch01_out_tx_pcs_rst" "ch0_out_tx_pcs_rst" "not_active_tx_pcs_rst"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "not_active_tx_pcs_rst"]]
   } else {
      if [expr { ($link_width=="x1") }] {
         set legal_values [intersect $legal_values [list "ch0_out_tx_pcs_rst"]]
      } else {
         if [expr { ($link_width=="x2") }] {
            set legal_values [intersect $legal_values [list "ch01_out_tx_pcs_rst"]]
         } else {
            if [expr { ($link_width=="x4") }] {
               set legal_values [intersect $legal_values [list "ch0123_out_tx_pcs_rst"]]
            } else {
               if [expr { ($link_width=="x8") }] {
                  set legal_values [intersect $legal_values [list "ch01234567_out_tx_pcs_rst"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_tx_pcs_rst_n_select.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_tx_pcs_rst_n_select $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_tx_pcs_rst_n_select $rstctrl_tx_pcs_rst_n_select $legal_values { hrdrstctrl_en link_width }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_tx_pma_rstb_inv { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_tx_pma_rstb_inv sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_tx_pma_rstb_inv.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_tx_pma_rstb_inv $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_tx_pma_rstb_inv $rstctrl_tx_pma_rstb_inv $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_tx_pma_syncp_inv { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_tx_pma_syncp_inv sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_tx_pma_syncp_inv.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_tx_pma_syncp_inv $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_tx_pma_syncp_inv $rstctrl_tx_pma_syncp_inv $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rstctrl_tx_pma_syncp_select { PROP_M_AUTOSET PROP_M_AUTOWARN rstctrl_tx_pma_syncp_select hrdrstctrl_en link_width } {

   set legal_values [list "ch0_out_tx_pma_syncp" "ch1_out_tx_pma_syncp" "ch3_out_tx_pma_syncp" "not_active_tx_pma_syncp"]

   if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
      set legal_values [intersect $legal_values [list "not_active_tx_pma_syncp"]]
   } else {
      if [expr { ($link_width=="x1") }] {
         set legal_values [intersect $legal_values [list "ch0_out_tx_pma_syncp"]]
      } else {
         if [expr { ($link_width=="x2") }] {
            set legal_values [intersect $legal_values [list "ch0_out_tx_pma_syncp"]]
         } else {
            if [expr { ($link_width=="x4") }] {
               set legal_values [intersect $legal_values [list "ch3_out_tx_pma_syncp"]]
            } else {
               if [expr { ($link_width=="x8") }] {
                  set legal_values [intersect $legal_values [list "ch3_out_tx_pma_syncp"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rstctrl_tx_pma_syncp_select.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rstctrl_tx_pma_syncp_select $legal_values
      }
   } else {
      auto_invalid_value_message auto rstctrl_tx_pma_syncp_select $rstctrl_tx_pma_syncp_select $legal_values { hrdrstctrl_en link_width }
   }
}

proc ::nf_hip::parameters::validate_rx_ast_parity { PROP_M_AUTOSET PROP_M_AUTOWARN rx_ast_parity func_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rx_ast_parity.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rx_ast_parity $legal_values
      }
   } else {
      auto_invalid_value_message auto rx_ast_parity $rx_ast_parity $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_rx_buffer_credit_alloc { PROP_M_AUTOSET PROP_M_AUTOWARN rx_buffer_credit_alloc func_mode } {

   set legal_values [list "balance" "high" "low" "maximum" "minimum"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "minimum"]]
   } else {
      set legal_values [intersect $legal_values [list "minimum" "low" "balance" "high" "maximum"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rx_buffer_credit_alloc.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rx_buffer_credit_alloc $legal_values
      }
   } else {
      auto_invalid_value_message auto rx_buffer_credit_alloc $rx_buffer_credit_alloc $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_rx_buffer_fc_protect { PROP_M_AUTOSET PROP_M_AUTOWARN rx_buffer_fc_protect sup_mode } {

   set legal_values [list 0:1048575]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 68]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rx_buffer_fc_protect.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rx_buffer_fc_protect $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rx_buffer_fc_protect $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rx_buffer_fc_protect $rx_buffer_fc_protect $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rx_buffer_protect { PROP_M_AUTOSET PROP_M_AUTOWARN rx_buffer_protect sup_mode } {

   set legal_values [list 0:2047]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 68]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rx_buffer_protect.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rx_buffer_protect $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rx_buffer_protect $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rx_buffer_protect $rx_buffer_protect $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rx_cdc_almost_empty { PROP_M_AUTOSET PROP_M_AUTOWARN rx_cdc_almost_empty sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 3]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rx_cdc_almost_empty.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rx_cdc_almost_empty $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rx_cdc_almost_empty $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rx_cdc_almost_empty $rx_cdc_almost_empty $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rx_cdc_almost_full { PROP_M_AUTOSET PROP_M_AUTOWARN rx_cdc_almost_full sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 12]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rx_cdc_almost_full.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rx_cdc_almost_full $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rx_cdc_almost_full $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rx_cdc_almost_full $rx_cdc_almost_full $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rx_cred_ctl_param { PROP_M_AUTOSET PROP_M_AUTOWARN rx_cred_ctl_param sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rx_cred_ctl_param.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rx_cred_ctl_param $legal_values
      }
   } else {
      auto_invalid_value_message auto rx_cred_ctl_param $rx_cred_ctl_param $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rx_ei_l0s { PROP_M_AUTOSET PROP_M_AUTOWARN rx_ei_l0s sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rx_ei_l0s.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rx_ei_l0s $legal_values
      }
   } else {
      auto_invalid_value_message auto rx_ei_l0s $rx_ei_l0s $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rx_l0s_count_idl { PROP_M_AUTOSET PROP_M_AUTOWARN rx_l0s_count_idl sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rx_l0s_count_idl.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rx_l0s_count_idl $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rx_l0s_count_idl $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rx_l0s_count_idl $rx_l0s_count_idl $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rx_ptr0_nonposted_dpram_max { PROP_M_AUTOSET PROP_M_AUTOWARN rx_ptr0_nonposted_dpram_max } {

   set legal_values [list 0:2047]

   set legal_values [compare_eq $legal_values 2047]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rx_ptr0_nonposted_dpram_max.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rx_ptr0_nonposted_dpram_max $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rx_ptr0_nonposted_dpram_max $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rx_ptr0_nonposted_dpram_max $rx_ptr0_nonposted_dpram_max $legal_values { }
   }
}

proc ::nf_hip::parameters::validate_rx_ptr0_nonposted_dpram_min { PROP_M_AUTOSET PROP_M_AUTOWARN rx_ptr0_nonposted_dpram_min atomic_malformed func_mode max_payload_size rx_buffer_credit_alloc use_crc_forwarding } {

   set legal_values [list 0:2047]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($atomic_malformed=="true") }] {
         if [expr { ($use_crc_forwarding=="false") }] {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2036]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2036]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2036]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2036]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2036]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2008]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2008]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2008]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2008]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2008]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1928]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1928]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1928]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1928]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1928]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 1846]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 1936]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 1984]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 2008]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 2008]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1864]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1936]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1984]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 2008]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 2008]
            }
         } else {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2036]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2036]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2036]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2036]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2036]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2024]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2024]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2024]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2024]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2024]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1984]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1984]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1984]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1984]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1984]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 1952]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 1992]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 2016]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 2024]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 2024]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1952]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1992]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 2016]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 2024]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 2024]
            }
         }
      } else {
         if [expr { ($use_crc_forwarding=="false") }] {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2032]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2032]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2032]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2032]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2032]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2008]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2008]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2008]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2008]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2008]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1928]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1928]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1928]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1928]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1928]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 1856]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 1936]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 1984]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 2008]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 2008]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1864]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1936]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1984]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 2008]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 2008]
            }
         } else {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2032]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2032]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2032]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2032]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2032]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2024]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2024]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2024]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2024]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2024]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1984]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1984]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1984]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1984]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1984]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 1952]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 1992]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 2016]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 2024]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 2024]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1952]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1992]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 2016]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 2024]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 2024]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rx_ptr0_nonposted_dpram_min.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rx_ptr0_nonposted_dpram_min $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rx_ptr0_nonposted_dpram_min $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rx_ptr0_nonposted_dpram_min $rx_ptr0_nonposted_dpram_min $legal_values { atomic_malformed func_mode max_payload_size rx_buffer_credit_alloc use_crc_forwarding }
   }
}

proc ::nf_hip::parameters::validate_rx_ptr0_posted_dpram_max { PROP_M_AUTOSET PROP_M_AUTOWARN rx_ptr0_posted_dpram_max atomic_malformed func_mode max_payload_size rx_buffer_credit_alloc use_crc_forwarding } {

   set legal_values [list 0:2047]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($atomic_malformed=="true") }] {
         if [expr { ($use_crc_forwarding=="false") }] {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2035]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2035]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2035]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2035]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2035]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2007]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2007]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2007]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2007]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2007]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1927]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1927]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1927]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1927]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1927]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 1855]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 1935]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 1983]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 2007]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 2007]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1863]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1935]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1983]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 2007]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 2007]
            }
         } else {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2035]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2035]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2035]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2035]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2035]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2023]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2023]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2023]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2023]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2023]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1983]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1983]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1983]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1983]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1983]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 1951]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 1991]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 2015]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 2023]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 2023]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1951]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1991]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 2015]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 2023]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 2023]
            }
         }
      } else {
         if [expr { ($use_crc_forwarding=="false") }] {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2031]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2031]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2031]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2031]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2031]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2007]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2007]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2007]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2007]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2007]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1927]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1927]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1927]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1927]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1927]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 1855]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 1935]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 1983]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 2007]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 2007]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1863]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1935]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1983]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 2007]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 2007]
            }
         } else {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2031]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2031]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2031]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2031]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2031]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2023]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2023]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2023]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2023]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 2023]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1983]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1983]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1983]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1983]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 1983]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 1951]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 1991]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 2015]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 2023]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 2023]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1951]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 1991]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 2015]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 2023]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 2023]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rx_ptr0_posted_dpram_max.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rx_ptr0_posted_dpram_max $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rx_ptr0_posted_dpram_max $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rx_ptr0_posted_dpram_max $rx_ptr0_posted_dpram_max $legal_values { atomic_malformed func_mode max_payload_size rx_buffer_credit_alloc use_crc_forwarding }
   }
}

proc ::nf_hip::parameters::validate_rx_ptr0_posted_dpram_min { PROP_M_AUTOSET PROP_M_AUTOWARN rx_ptr0_posted_dpram_min } {

   set legal_values [list 0:2047]

   set legal_values [compare_eq $legal_values 0]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.rx_ptr0_posted_dpram_min.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message rx_ptr0_posted_dpram_min $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message rx_ptr0_posted_dpram_min $legal_values
      }
   } else {
      auto_value_out_of_range_message auto rx_ptr0_posted_dpram_min $rx_ptr0_posted_dpram_min $legal_values { }
   }
}

proc ::nf_hip::parameters::validate_rx_runt_patch_dis { PROP_M_AUTOSET PROP_M_AUTOWARN rx_runt_patch_dis sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rx_runt_patch_dis.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rx_runt_patch_dis $legal_values
      }
   } else {
      auto_invalid_value_message auto rx_runt_patch_dis $rx_runt_patch_dis $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rx_sop_ctrl { PROP_M_AUTOSET PROP_M_AUTOWARN rx_sop_ctrl ast_width_rx func_mode } {

   set legal_values [list "rx_sop_boundary_128" "rx_sop_boundary_256" "rx_sop_boundary_64"]

   if [expr { ($func_mode=="enable") }] {
      if [expr { ($ast_width_rx=="rx_64") }] {
         set legal_values [intersect $legal_values [list "rx_sop_boundary_64"]]
      } else {
         if [expr { ($ast_width_rx=="rx_128") }] {
            set legal_values [intersect $legal_values [list "rx_sop_boundary_128"]]
         } else {
            set legal_values [intersect $legal_values [list "rx_sop_boundary_64" "rx_sop_boundary_128" "rx_sop_boundary_256"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "rx_sop_boundary_64"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rx_sop_ctrl.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rx_sop_ctrl $legal_values
      }
   } else {
      auto_invalid_value_message auto rx_sop_ctrl $rx_sop_ctrl $legal_values { ast_width_rx func_mode }
   }
}

proc ::nf_hip::parameters::validate_rx_trunc_patch_dis { PROP_M_AUTOSET PROP_M_AUTOWARN rx_trunc_patch_dis sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rx_trunc_patch_dis.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rx_trunc_patch_dis $legal_values
      }
   } else {
      auto_invalid_value_message auto rx_trunc_patch_dis $rx_trunc_patch_dis $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rx_use_prst { PROP_M_AUTOSET PROP_M_AUTOWARN rx_use_prst sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "true"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rx_use_prst.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rx_use_prst $legal_values
      }
   } else {
      auto_invalid_value_message auto rx_use_prst $rx_use_prst $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rx_use_prst_ep { PROP_M_AUTOSET PROP_M_AUTOWARN rx_use_prst_ep func_mode port_type sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($func_mode=="enable") }] {
      if [expr { ($sup_mode=="user_mode") }] {
         if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
            set legal_values [intersect $legal_values [list "true"]]
         } else {
            set legal_values [intersect $legal_values [list "false"]]
         }
      } else {
         set legal_values [intersect $legal_values [list "false"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rx_use_prst_ep.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rx_use_prst_ep $legal_values
      }
   } else {
      auto_invalid_value_message auto rx_use_prst_ep $rx_use_prst_ep $legal_values { func_mode port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rxbuf_ecc_corr_mask_dis { PROP_M_AUTOSET PROP_M_AUTOWARN rxbuf_ecc_corr_mask_dis sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rxbuf_ecc_corr_mask_dis.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rxbuf_ecc_corr_mask_dis $legal_values
      }
   } else {
      auto_invalid_value_message auto rxbuf_ecc_corr_mask_dis $rxbuf_ecc_corr_mask_dis $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rxdl_bad_sop_eop_filter_dis { PROP_M_AUTOSET PROP_M_AUTOWARN rxdl_bad_sop_eop_filter_dis sup_mode } {

   set legal_values [list "rxdlbug1_disable_both" "rxdlbug1_enable0" "rxdlbug1_enable1" "rxdlbug1_enable_both"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "rxdlbug1_enable_both"]]
   } else {
      set legal_values [intersect $legal_values [list "rxdlbug1_enable_both" "rxdlbug1_enable0" "rxdlbug1_enable1" "rxdlbug1_disable_both"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rxdl_bad_sop_eop_filter_dis.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rxdl_bad_sop_eop_filter_dis $legal_values
      }
   } else {
      auto_invalid_value_message auto rxdl_bad_sop_eop_filter_dis $rxdl_bad_sop_eop_filter_dis $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rxdl_bad_tlp_patch_dis { PROP_M_AUTOSET PROP_M_AUTOWARN rxdl_bad_tlp_patch_dis sup_mode } {

   set legal_values [list "rxdlbug2_disable_both" "rxdlbug2_enable0" "rxdlbug2_enable1" "rxdlbug2_enable_both"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "rxdlbug2_enable_both"]]
   } else {
      set legal_values [intersect $legal_values [list "rxdlbug2_enable_both" "rxdlbug2_enable0" "rxdlbug2_enable1" "rxdlbug2_disable_both"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rxdl_bad_tlp_patch_dis.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rxdl_bad_tlp_patch_dis $legal_values
      }
   } else {
      auto_invalid_value_message auto rxdl_bad_tlp_patch_dis $rxdl_bad_tlp_patch_dis $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_rxdl_lcrc_patch_dis { PROP_M_AUTOSET PROP_M_AUTOWARN rxdl_lcrc_patch_dis sup_mode } {

   set legal_values [list "rxdlbug3_disable_both" "rxdlbug3_enable0" "rxdlbug3_enable1" "rxdlbug3_enable_both"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "rxdlbug3_enable_both"]]
   } else {
      set legal_values [intersect $legal_values [list "rxdlbug3_enable_both" "rxdlbug3_enable0" "rxdlbug3_enable1" "rxdlbug3_disable_both"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.rxdl_lcrc_patch_dis.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message rxdl_lcrc_patch_dis $legal_values
      }
   } else {
      auto_invalid_value_message auto rxdl_lcrc_patch_dis $rxdl_lcrc_patch_dis $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_sameclock_nfts_count { PROP_M_AUTOSET PROP_M_AUTOWARN sameclock_nfts_count sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 128]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.sameclock_nfts_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message sameclock_nfts_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message sameclock_nfts_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto sameclock_nfts_count $sameclock_nfts_count $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_sel_enable_pcs_rx_fifo_err { PROP_M_AUTOSET PROP_M_AUTOWARN sel_enable_pcs_rx_fifo_err sup_mode } {

   set legal_values [list "disable_sel" "enable_x1" "enable_x2" "enable_x4" "enable_x8"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable_sel"]]
   } else {
      set legal_values [intersect $legal_values [list "disable_sel" "enable_x1" "enable_x2" "enable_x4" "enable_x8"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.sel_enable_pcs_rx_fifo_err.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message sel_enable_pcs_rx_fifo_err $legal_values
      }
   } else {
      auto_invalid_value_message auto sel_enable_pcs_rx_fifo_err $sel_enable_pcs_rx_fifo_err $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_sim_mode { PROP_M_AUTOSET PROP_M_AUTOWARN sim_mode func_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable" "enable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.sim_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message sim_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto sim_mode $sim_mode $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_simple_ro_fifo_control_en { PROP_M_AUTOSET PROP_M_AUTOWARN simple_ro_fifo_control_en sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.simple_ro_fifo_control_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message simple_ro_fifo_control_en $legal_values
      }
   } else {
      auto_invalid_value_message auto simple_ro_fifo_control_en $simple_ro_fifo_control_en $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_single_rx_detect { PROP_M_AUTOSET PROP_M_AUTOWARN single_rx_detect link_width sup_mode } {

   set legal_values [list "detect_all_lanes" "detect_lane0_3" "detect_lane0_only" "detect_lane0_or_3" "detect_lane1_only" "detect_lane2_and_3" "detect_lane3_only" "detect_lane4_7" "detect_lane6_and_7" "detect_lane7_only"]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($link_width=="x1") }] {
         set legal_values [intersect $legal_values [list "detect_lane0_only"]]
      } else {
         if [expr { ($link_width=="x2") }] {
            set legal_values [intersect $legal_values [list "detect_lane0_or_3"]]
         } else {
            if [expr { ($link_width=="x4") }] {
               set legal_values [intersect $legal_values [list "detect_lane0_3"]]
            } else {
               set legal_values [intersect $legal_values [list "detect_all_lanes"]]
            }
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "detect_lane0_3" "detect_lane0_or_3" "detect_lane0_only" "detect_lane4_7" "detect_lane6_and_7" "detect_lane7_only" "detect_lane2_and_3" "detect_lane3_only" "detect_lane1_only" "detect_all_lanes"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.single_rx_detect.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message single_rx_detect $legal_values
      }
   } else {
      auto_invalid_value_message auto single_rx_detect $single_rx_detect $legal_values { link_width sup_mode }
   }
}

proc ::nf_hip::parameters::validate_skp_os_gen3_count { PROP_M_AUTOSET PROP_M_AUTOWARN skp_os_gen3_count sup_mode } {

   set legal_values [list 0:2047]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      set legal_values [compare_ge $legal_values 1480]
      set legal_values [compare_le $legal_values 1500]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.skp_os_gen3_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message skp_os_gen3_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message skp_os_gen3_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto skp_os_gen3_count $skp_os_gen3_count $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_skp_os_schedule_count { PROP_M_AUTOSET PROP_M_AUTOWARN skp_os_schedule_count sup_mode } {

   set legal_values [list 0:2047]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      set legal_values [compare_ge $legal_values 295]
      set legal_values [compare_le $legal_values 382]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.skp_os_schedule_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message skp_os_schedule_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message skp_os_schedule_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto skp_os_schedule_count $skp_os_schedule_count $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_slot_number { PROP_M_AUTOSET PROP_M_AUTOWARN slot_number enable_slot_register sup_mode } {

   set legal_values [list 0:8191]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { ($enable_slot_register=="true") }] {
         set legal_values [compare_ne $legal_values 0]
      } else {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.slot_number.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message slot_number $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message slot_number $legal_values
      }
   } else {
      auto_value_out_of_range_message auto slot_number $slot_number $legal_values { enable_slot_register sup_mode }
   }
}

proc ::nf_hip::parameters::validate_slot_power_limit { PROP_M_AUTOSET PROP_M_AUTOWARN slot_power_limit enable_slot_register func_mode sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         if [expr { ($enable_slot_register=="false") }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.slot_power_limit.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message slot_power_limit $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message slot_power_limit $legal_values
      }
   } else {
      auto_value_out_of_range_message auto slot_power_limit $slot_power_limit $legal_values { enable_slot_register func_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_slot_power_scale { PROP_M_AUTOSET PROP_M_AUTOWARN slot_power_scale enable_slot_register func_mode sup_mode } {

   set legal_values [list 0:3]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($sup_mode=="user_mode") }] {
         if [expr { ($enable_slot_register=="false") }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.slot_power_scale.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message slot_power_scale $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message slot_power_scale $legal_values
      }
   } else {
      auto_value_out_of_range_message auto slot_power_scale $slot_power_scale $legal_values { enable_slot_register func_mode sup_mode }
   }
}

proc ::nf_hip::parameters::validate_slotclk_cfg { PROP_M_AUTOSET PROP_M_AUTOWARN slotclk_cfg func_mode } {

   set legal_values [list "dynamic_slotclkcfg" "static_slotclkcfgoff" "static_slotclkcfgon"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "static_slotclkcfgon"]]
   } else {
      set legal_values [intersect $legal_values [list "static_slotclkcfgon" "static_slotclkcfgoff" "dynamic_slotclkcfg"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.slotclk_cfg.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message slotclk_cfg $legal_values
      }
   } else {
      auto_invalid_value_message auto slotclk_cfg $slotclk_cfg $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_ssid { PROP_M_AUTOSET PROP_M_AUTOWARN ssid sup_mode } {

   set legal_values [list 0:65535]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.ssid.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message ssid $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message ssid $legal_values
      }
   } else {
      auto_value_out_of_range_message auto ssid $ssid $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_ssvid { PROP_M_AUTOSET PROP_M_AUTOWARN ssvid sup_mode } {

   set legal_values [list 0:65535]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.ssvid.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message ssvid $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message ssvid $legal_values
      }
   } else {
      auto_value_out_of_range_message auto ssvid $ssvid $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_subsystem_device_id { PROP_M_AUTOSET PROP_M_AUTOWARN subsystem_device_id func_mode } {

   set legal_values [list 0:65535]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 57345]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.subsystem_device_id.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message subsystem_device_id $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message subsystem_device_id $legal_values
      }
   } else {
      auto_value_out_of_range_message auto subsystem_device_id $subsystem_device_id $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_subsystem_vendor_id { PROP_M_AUTOSET PROP_M_AUTOWARN subsystem_vendor_id func_mode } {

   set legal_values [list 0:65535]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 4466]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.subsystem_vendor_id.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message subsystem_vendor_id $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message subsystem_vendor_id $legal_values
      }
   } else {
      auto_value_out_of_range_message auto subsystem_vendor_id $subsystem_vendor_id $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN sup_mode func_mode powerdown_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   } else {
      set legal_values [intersect $legal_values [list "user_mode" "engineering_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto sup_mode $sup_mode $legal_values { func_mode powerdown_mode }
   }
}

proc ::nf_hip::parameters::validate_surprise_down_error_support { PROP_M_AUTOSET PROP_M_AUTOWARN surprise_down_error_support port_type sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      if [expr { (($port_type=="native_ep")||($port_type=="legacy_ep")) }] {
         set legal_values [intersect $legal_values [list "false"]]
      }
      if [expr { ($port_type=="root_port") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.surprise_down_error_support.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message surprise_down_error_support $legal_values
      }
   } else {
      auto_invalid_value_message auto surprise_down_error_support $surprise_down_error_support $legal_values { port_type sup_mode }
   }
}

proc ::nf_hip::parameters::validate_tl_cfg_div { PROP_M_AUTOSET PROP_M_AUTOWARN tl_cfg_div sup_mode } {

   set legal_values [list "cfg_clk_div_0" "cfg_clk_div_1" "cfg_clk_div_2" "cfg_clk_div_3" "cfg_clk_div_4" "cfg_clk_div_5" "cfg_clk_div_6" "cfg_clk_div_7"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "cfg_clk_div_7"]]
   } else {
      set legal_values [intersect $legal_values [list "cfg_clk_div_0" "cfg_clk_div_1" "cfg_clk_div_2" "cfg_clk_div_3" "cfg_clk_div_4" "cfg_clk_div_5" "cfg_clk_div_6" "cfg_clk_div_7"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.tl_cfg_div.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message tl_cfg_div $legal_values
      }
   } else {
      auto_invalid_value_message auto tl_cfg_div $tl_cfg_div $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_tl_tx_check_parity_msg { PROP_M_AUTOSET PROP_M_AUTOWARN tl_tx_check_parity_msg sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.tl_tx_check_parity_msg.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message tl_tx_check_parity_msg $legal_values
      }
   } else {
      auto_invalid_value_message auto tl_tx_check_parity_msg $tl_tx_check_parity_msg $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_tph_completer { PROP_M_AUTOSET PROP_M_AUTOWARN tph_completer sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "false"]]
   } else {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.tph_completer.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message tph_completer $legal_values
      }
   } else {
      auto_invalid_value_message auto tph_completer $tph_completer $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_tx_ast_parity { PROP_M_AUTOSET PROP_M_AUTOWARN tx_ast_parity func_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.tx_ast_parity.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message tx_ast_parity $legal_values
      }
   } else {
      auto_invalid_value_message auto tx_ast_parity $tx_ast_parity $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_tx_cdc_almost_empty { PROP_M_AUTOSET PROP_M_AUTOWARN tx_cdc_almost_empty sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 5]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.tx_cdc_almost_empty.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message tx_cdc_almost_empty $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message tx_cdc_almost_empty $legal_values
      }
   } else {
      auto_value_out_of_range_message auto tx_cdc_almost_empty $tx_cdc_almost_empty $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_tx_cdc_almost_full { PROP_M_AUTOSET PROP_M_AUTOWARN tx_cdc_almost_full sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 11]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.tx_cdc_almost_full.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message tx_cdc_almost_full $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message tx_cdc_almost_full $legal_values
      }
   } else {
      auto_value_out_of_range_message auto tx_cdc_almost_full $tx_cdc_almost_full $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_tx_sop_ctrl { PROP_M_AUTOSET PROP_M_AUTOWARN tx_sop_ctrl ast_width_tx func_mode } {

   set legal_values [list "boundary_128" "boundary_256" "boundary_64"]

   if [expr { ($func_mode=="enable") }] {
      if [expr { ($ast_width_tx=="tx_64") }] {
         set legal_values [intersect $legal_values [list "boundary_64"]]
      } else {
         if [expr { ($ast_width_tx=="tx_128") }] {
            set legal_values [intersect $legal_values [list "boundary_128"]]
         } else {
            set legal_values [intersect $legal_values [list "boundary_64" "boundary_128" "boundary_256"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "boundary_64"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.tx_sop_ctrl.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message tx_sop_ctrl $legal_values
      }
   } else {
      auto_invalid_value_message auto tx_sop_ctrl $tx_sop_ctrl $legal_values { ast_width_tx func_mode }
   }
}

proc ::nf_hip::parameters::validate_tx_swing { PROP_M_AUTOSET PROP_M_AUTOWARN tx_swing sup_mode } {

   set legal_values [list 0:255]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.tx_swing.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message tx_swing $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message tx_swing $legal_values
      }
   } else {
      auto_value_out_of_range_message auto tx_swing $tx_swing $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_txdl_fair_arbiter_counter { PROP_M_AUTOSET PROP_M_AUTOWARN txdl_fair_arbiter_counter sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.txdl_fair_arbiter_counter.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message txdl_fair_arbiter_counter $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message txdl_fair_arbiter_counter $legal_values
      }
   } else {
      auto_value_out_of_range_message auto txdl_fair_arbiter_counter $txdl_fair_arbiter_counter $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_txdl_fair_arbiter_en { PROP_M_AUTOSET PROP_M_AUTOWARN txdl_fair_arbiter_en sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.txdl_fair_arbiter_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message txdl_fair_arbiter_en $legal_values
      }
   } else {
      auto_invalid_value_message auto txdl_fair_arbiter_en $txdl_fair_arbiter_en $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_txrate_adv { PROP_M_AUTOSET PROP_M_AUTOWARN txrate_adv sup_mode } {

   set legal_values [list "capability" "target_link_speed"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "capability"]]
   } else {
      set legal_values [intersect $legal_values [list "capability" "target_link_speed"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.txrate_adv.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message txrate_adv $legal_values
      }
   } else {
      auto_invalid_value_message auto txrate_adv $txrate_adv $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_uc_calibration_en { PROP_M_AUTOSET PROP_M_AUTOWARN uc_calibration_en func_mode hrdrstctrl_en } {

   set legal_values [list "uc_calibration_dis" "uc_calibration_en"]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "uc_calibration_dis"]]
   } else {
      if [expr { ($hrdrstctrl_en=="hrdrstctrl_dis") }] {
         set legal_values [intersect $legal_values [list "uc_calibration_dis"]]
      } else {
         set legal_values [intersect $legal_values [list "uc_calibration_dis" "uc_calibration_en"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.uc_calibration_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message uc_calibration_en $legal_values
      }
   } else {
      auto_invalid_value_message auto uc_calibration_en $uc_calibration_en $legal_values { func_mode hrdrstctrl_en }
   }
}

proc ::nf_hip::parameters::validate_use_aer { PROP_M_AUTOSET PROP_M_AUTOWARN use_aer advance_error_reporting } {

   set legal_values [list "false" "true"]

   if [expr { ($advance_error_reporting=="enable") }] {
      set legal_values [intersect $legal_values [list "true"]]
   } else {
      set legal_values [intersect $legal_values [list "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.use_aer.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message use_aer $legal_values
      }
   } else {
      auto_invalid_value_message auto use_aer $use_aer $legal_values { advance_error_reporting }
   }
}

proc ::nf_hip::parameters::validate_use_crc_forwarding { PROP_M_AUTOSET PROP_M_AUTOWARN use_crc_forwarding advance_error_reporting func_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($func_mode=="enable") }] {
      if [expr { ($advance_error_reporting=="disable") }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         set legal_values [intersect $legal_values [list "false" "true"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.use_crc_forwarding.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message use_crc_forwarding $legal_values
      }
   } else {
      auto_invalid_value_message auto use_crc_forwarding $use_crc_forwarding $legal_values { advance_error_reporting func_mode }
   }
}

proc ::nf_hip::parameters::validate_user_id { PROP_M_AUTOSET PROP_M_AUTOWARN user_id func_mode } {

   set legal_values [list 0:65535]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.user_id.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message user_id $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message user_id $legal_values
      }
   } else {
      auto_value_out_of_range_message auto user_id $user_id $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_vc0_clk_enable { PROP_M_AUTOSET PROP_M_AUTOWARN vc0_clk_enable } {

   set legal_values [list "false" "true"]

   set legal_values [intersect $legal_values [list "true"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.vc0_clk_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message vc0_clk_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto vc0_clk_enable $vc0_clk_enable $legal_values { }
   }
}

proc ::nf_hip::parameters::validate_vc0_rx_buffer_memory_settings { PROP_M_AUTOSET PROP_M_AUTOWARN vc0_rx_buffer_memory_settings sup_mode } {

   set legal_values [list 0:68719476735]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 12885005388]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.vc0_rx_buffer_memory_settings.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message vc0_rx_buffer_memory_settings $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message vc0_rx_buffer_memory_settings $legal_values
      }
   } else {
      auto_value_out_of_range_message auto vc0_rx_buffer_memory_settings $vc0_rx_buffer_memory_settings $legal_values { sup_mode }
   }
}

proc ::nf_hip::parameters::validate_vc0_rx_flow_ctrl_compl_data { PROP_M_AUTOSET PROP_M_AUTOWARN vc0_rx_flow_ctrl_compl_data atomic_malformed func_mode max_payload_size rx_buffer_credit_alloc use_crc_forwarding } {

   set legal_values [list 0:4095]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($atomic_malformed=="true") }] {
         if [expr { ($use_crc_forwarding=="false") }] {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      } else {
         if [expr { ($use_crc_forwarding=="false") }] {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.vc0_rx_flow_ctrl_compl_data.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message vc0_rx_flow_ctrl_compl_data $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message vc0_rx_flow_ctrl_compl_data $legal_values
      }
   } else {
      auto_value_out_of_range_message auto vc0_rx_flow_ctrl_compl_data $vc0_rx_flow_ctrl_compl_data $legal_values { atomic_malformed func_mode max_payload_size rx_buffer_credit_alloc use_crc_forwarding }
   }
}

proc ::nf_hip::parameters::validate_vc0_rx_flow_ctrl_compl_header { PROP_M_AUTOSET PROP_M_AUTOWARN vc0_rx_flow_ctrl_compl_header atomic_malformed func_mode max_payload_size rx_buffer_credit_alloc use_crc_forwarding } {

   set legal_values [list 0:255]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($atomic_malformed=="true") }] {
         if [expr { ($use_crc_forwarding=="false") }] {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      } else {
         if [expr { ($use_crc_forwarding=="false") }] {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.vc0_rx_flow_ctrl_compl_header.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message vc0_rx_flow_ctrl_compl_header $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message vc0_rx_flow_ctrl_compl_header $legal_values
      }
   } else {
      auto_value_out_of_range_message auto vc0_rx_flow_ctrl_compl_header $vc0_rx_flow_ctrl_compl_header $legal_values { atomic_malformed func_mode max_payload_size rx_buffer_credit_alloc use_crc_forwarding }
   }
}

proc ::nf_hip::parameters::validate_vc0_rx_flow_ctrl_nonposted_data { PROP_M_AUTOSET PROP_M_AUTOWARN vc0_rx_flow_ctrl_nonposted_data atomic_malformed func_mode max_payload_size rx_buffer_credit_alloc use_crc_forwarding } {

   set legal_values [list 0:255]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($atomic_malformed=="true") }] {
         if [expr { ($use_crc_forwarding=="false") }] {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
         } else {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
         }
      } else {
         if [expr { ($use_crc_forwarding=="false") }] {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.vc0_rx_flow_ctrl_nonposted_data.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message vc0_rx_flow_ctrl_nonposted_data $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message vc0_rx_flow_ctrl_nonposted_data $legal_values
      }
   } else {
      auto_value_out_of_range_message auto vc0_rx_flow_ctrl_nonposted_data $vc0_rx_flow_ctrl_nonposted_data $legal_values { atomic_malformed func_mode max_payload_size rx_buffer_credit_alloc use_crc_forwarding }
   }
}

proc ::nf_hip::parameters::validate_vc0_rx_flow_ctrl_nonposted_header { PROP_M_AUTOSET PROP_M_AUTOWARN vc0_rx_flow_ctrl_nonposted_header atomic_malformed func_mode max_payload_size rx_buffer_credit_alloc use_crc_forwarding } {

   set legal_values [list 0:255]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($atomic_malformed=="true") }] {
         if [expr { ($use_crc_forwarding=="false") }] {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 56]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 56]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 56]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 56]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 56]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 92]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 52]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 28]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 88]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 52]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 28]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
         } else {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 4]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 4]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 4]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 4]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 4]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 56]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 56]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 56]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 56]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 56]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 88]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 48]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 24]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 88]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 48]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 24]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
         }
      } else {
         if [expr { ($use_crc_forwarding=="false") }] {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 4]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 4]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 4]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 4]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 4]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 56]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 56]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 56]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 56]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 56]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 92]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 52]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 28]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 88]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 52]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 28]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
         } else {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 56]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 56]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 56]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 56]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 56]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 88]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 48]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 24]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 88]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 48]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 24]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.vc0_rx_flow_ctrl_nonposted_header.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message vc0_rx_flow_ctrl_nonposted_header $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message vc0_rx_flow_ctrl_nonposted_header $legal_values
      }
   } else {
      auto_value_out_of_range_message auto vc0_rx_flow_ctrl_nonposted_header $vc0_rx_flow_ctrl_nonposted_header $legal_values { atomic_malformed func_mode max_payload_size rx_buffer_credit_alloc use_crc_forwarding }
   }
}

proc ::nf_hip::parameters::validate_vc0_rx_flow_ctrl_posted_data { PROP_M_AUTOSET PROP_M_AUTOWARN vc0_rx_flow_ctrl_posted_data atomic_malformed func_mode max_payload_size rx_buffer_credit_alloc use_crc_forwarding } {

   set legal_values [list 0:4095]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($atomic_malformed=="true") }] {
         if [expr { ($use_crc_forwarding=="false") }] {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 64]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 128]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 64]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 128]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 358]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 358]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 358]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 358]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 358]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 776]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 858]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 894]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 888]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 808]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 775]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 857]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 893]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 887]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 823]
            }
         } else {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 64]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 128]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 64]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 128]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 333]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 333]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 333]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 333]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 333]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 686]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 809]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 871]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 872]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 792]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 675]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 808]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 870]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 871]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 807]
            }
         }
      } else {
         if [expr { ($use_crc_forwarding=="false") }] {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 64]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 128]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 64]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 128]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 358]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 358]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 358]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 358]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 358]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 792]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 874]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 910]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 904]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 824]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 807]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 889]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 933]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 919]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 855]
            }
         } else {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 8]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 64]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 128]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 32]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 64]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 128]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 333]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 333]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 333]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 333]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 333]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 702]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 825]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 887]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 888]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 808]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 707]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 840]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 902]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 903]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 839]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.vc0_rx_flow_ctrl_posted_data.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message vc0_rx_flow_ctrl_posted_data $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message vc0_rx_flow_ctrl_posted_data $legal_values
      }
   } else {
      auto_value_out_of_range_message auto vc0_rx_flow_ctrl_posted_data $vc0_rx_flow_ctrl_posted_data $legal_values { atomic_malformed func_mode max_payload_size rx_buffer_credit_alloc use_crc_forwarding }
   }
}

proc ::nf_hip::parameters::validate_vc0_rx_flow_ctrl_posted_header { PROP_M_AUTOSET PROP_M_AUTOWARN vc0_rx_flow_ctrl_posted_header atomic_malformed func_mode max_payload_size rx_buffer_credit_alloc use_crc_forwarding } {

   set legal_values [list 0:255]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($atomic_malformed=="true") }] {
         if [expr { ($use_crc_forwarding=="false") }] {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 50]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 50]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 50]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 50]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 50]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 100]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 58]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 30]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 58]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 30]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
         } else {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 50]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 50]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 50]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 50]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 50]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 100]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 58]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 30]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 58]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 30]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
         }
      } else {
         if [expr { ($use_crc_forwarding=="false") }] {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 1]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 50]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 50]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 50]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 50]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 50]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 100]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 58]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 30]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 58]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 30]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
         } else {
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="minimum")) }] {
               set legal_values [compare_eq $legal_values 2]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="low")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 50]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 50]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 50]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 50]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="balance")) }] {
               set legal_values [compare_eq $legal_values 50]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 100]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 58]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 30]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="high")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_128")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 112]
            }
            if [expr { (($max_payload_size=="payload_256")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 58]
            }
            if [expr { (($max_payload_size=="payload_512")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 30]
            }
            if [expr { (($max_payload_size=="payload_1024")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
            if [expr { (($max_payload_size=="payload_2048")&&($rx_buffer_credit_alloc=="maximum")) }] {
               set legal_values [compare_eq $legal_values 16]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.vc0_rx_flow_ctrl_posted_header.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message vc0_rx_flow_ctrl_posted_header $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message vc0_rx_flow_ctrl_posted_header $legal_values
      }
   } else {
      auto_value_out_of_range_message auto vc0_rx_flow_ctrl_posted_header $vc0_rx_flow_ctrl_posted_header $legal_values { atomic_malformed func_mode max_payload_size rx_buffer_credit_alloc use_crc_forwarding }
   }
}

proc ::nf_hip::parameters::validate_vc1_clk_enable { PROP_M_AUTOSET PROP_M_AUTOWARN vc1_clk_enable } {

   set legal_values [list "false" "true"]

   set legal_values [intersect $legal_values [list "false"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.vc1_clk_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message vc1_clk_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto vc1_clk_enable $vc1_clk_enable $legal_values { }
   }
}

proc ::nf_hip::parameters::validate_vc_arbitration { PROP_M_AUTOSET PROP_M_AUTOWARN vc_arbitration } {

   set legal_values [list "single_vc_arb"]

   set legal_values [intersect $legal_values [list "single_vc_arb"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.vc_arbitration.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message vc_arbitration $legal_values
      }
   } else {
      auto_invalid_value_message auto vc_arbitration $vc_arbitration $legal_values { }
   }
}

proc ::nf_hip::parameters::validate_vc_enable { PROP_M_AUTOSET PROP_M_AUTOWARN vc_enable } {

   set legal_values [list "single_vc"]

   set legal_values [intersect $legal_values [list "single_vc"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.vc_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message vc_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto vc_enable $vc_enable $legal_values { }
   }
}

proc ::nf_hip::parameters::validate_vendor_id { PROP_M_AUTOSET PROP_M_AUTOWARN vendor_id func_mode } {

   set legal_values [list 0:65535]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 4466]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.vendor_id.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message vendor_id $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message vendor_id $legal_values
      }
   } else {
      auto_value_out_of_range_message auto vendor_id $vendor_id $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_vsec_cap { PROP_M_AUTOSET PROP_M_AUTOWARN vsec_cap func_mode } {

   set legal_values [list 0:15]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.vsec_cap.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message vsec_cap $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message vsec_cap $legal_values
      }
   } else {
      auto_value_out_of_range_message auto vsec_cap $vsec_cap $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_vsec_id { PROP_M_AUTOSET PROP_M_AUTOWARN vsec_id func_mode } {

   set legal_values [list 0:65535]

   if [expr { ($func_mode=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.vsec_id.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message vsec_id $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message vsec_id $legal_values
      }
   } else {
      auto_value_out_of_range_message auto vsec_id $vsec_id $legal_values { func_mode }
   }
}

proc ::nf_hip::parameters::validate_wrong_device_id { PROP_M_AUTOSET PROP_M_AUTOWARN wrong_device_id sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.wrong_device_id.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message wrong_device_id $legal_values
      }
   } else {
      auto_invalid_value_message auto wrong_device_id $wrong_device_id $legal_values { sup_mode }
   }
}


