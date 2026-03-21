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


package provide altera_emif::ip_tg_avl_2::main 0.1

package require altera_emif::util::messaging
package require altera_emif::util::math
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_emif::util::ctrl_expert
package require altera_emif::util::device_family
package require altera_emif::ip_top::exports
package require altera_emif::ip_tg_avl_2::util
package require altera_emif::ip_tg_avl_2::enum_defs

namespace eval ::altera_emif::ip_tg_avl_2::main:: {

   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_emif::ip_tg_avl_2::util::*

}


proc ::altera_emif::ip_tg_avl_2::main::create_parameters {} {

   ::altera_emif::ip_top::exports::inherit_top_level_parameter_defs

   set_parameter_property PROTOCOL_ENUM HDL_PARAMETER true
   set_parameter_property PHY_PING_PONG_EN HDL_PARAMETER true

   set_parameter_property MEM_TTL_DATA_WIDTH HDL_PARAMETER true
   set_parameter_property MEM_TTL_NUM_OF_WRITE_GROUPS HDL_PARAMETER true
   set_parameter_property DIAG_TG_DATA_PATTERN_LENGTH HDL_PARAMETER true
   set_parameter_property DIAG_TG_BE_PATTERN_LENGTH HDL_PARAMETER true

   add_derived_hdl_param MEGAFUNC_DEVICE_FAMILY          string           ""        
   add_derived_hdl_param NUM_OF_CTRL_PORTS               integer          1         
   add_derived_hdl_param SEPARATE_READ_WRITE_IFS         integer          0         
   add_derived_hdl_param CTRL_AVL_PROTOCOL_ENUM          string           ""        
   add_derived_hdl_param USE_AVL_BYTEEN                  integer          1         
   add_derived_hdl_param AMM_WORD_ADDRESS_WIDTH          integer          1         
   add_derived_hdl_param AMM_WORD_ADDRESS_DIVISIBLE_BY   integer          1         
   add_derived_hdl_param AMM_BURST_COUNT_DIVISIBLE_BY    integer          1         
   add_derived_hdl_param USE_SIMPLE_TG                   boolean          false     
   add_derived_hdl_param TEST_DURATION                   string           "SHORT"   
   add_derived_hdl_param BYPASS_DEFAULT_PATTERN          boolean          false     
   add_derived_hdl_param BYPASS_USER_STAGE               boolean          true      
   add_derived_hdl_param BYPASS_REPEAT_STAGE             boolean          true      
   add_derived_hdl_param BYPASS_STRESS_STAGE             boolean          true      

   add_derived_hdl_param MEM_RANK_WIDTH                  integer          1
   add_derived_hdl_param MEM_BANK_ADDR_WIDTH             integer          1
   add_derived_hdl_param MEM_ROW_ADDR_WIDTH              integer          1
   add_derived_hdl_param AVL_TO_DQ_WIDTH_RATIO           integer          1
   add_derived_hdl_param MEM_BANK_GROUP_WIDTH            integer          1
   add_derived_hdl_param ROW_ADDR_LSB                    integer          0
   add_derived_hdl_param BANK_ADDR_LSB                   integer          1
   add_derived_hdl_param COL_ADDR_LSB                    integer          1
   add_derived_hdl_param RANK_LSB                        integer          1
   add_derived_hdl_param BANK_GROUP_LSB                  integer          1


   foreach tg_avl_if_enum [enums_of_type TG_AVL_IF] {
      set if_enum [enum_data $tg_avl_if_enum IF_ENUM]
      set port_enum_type [enum_data $if_enum PORT_ENUM_TYPE]

      foreach port_enum [enums_of_type $port_enum_type] {
         set is_bus [enum_data $port_enum IS_BUS]
         if {$is_bus} {
            add_derived_hdl_param "${port_enum}_WIDTH" integer 1
         }
      }
   }

   return 1
}

proc ::altera_emif::ip_tg_avl_2::main::elaboration_callback {} {

   if {[get_parameter_value SYS_INFO_DEVICE_FAMILY] == ""} {
      return 0
   }

   ::altera_emif::util::device_family::load_data

   if {[get_parameter_value PROTOCOL_ENUM] == "PROTOCOL_QDR2"} {
      set separate_read_write_ifs 1
   } else {
      set separate_read_write_ifs 0
   }

   set if_ports [dict create]
   set if_names [dict create]

   set num_of_amm_ifs [::altera_emif::util::ctrl_expert::get_num_of_interfaces_used IF_CTRL_AMM]

   foreach tg_avl_if_enum [enums_of_type TG_AVL_IF] {
      set if_enum           [enum_data $tg_avl_if_enum IF_ENUM]
      set num_of_ifs_in_rtl [enum_data $tg_avl_if_enum NUM_IN_RTL]

      dict set if_names $if_enum [dict create]

      if {$if_enum == "IF_CTRL_AMM"} {
         set num_of_ifs_used $num_of_amm_ifs
         if {$num_of_ifs_used > 0} {
            set amm_if_props [::altera_emif::util::ctrl_expert::get_interface_properties IF_CTRL_AMM]
            set ports [_get_ctrl_amm_ports $amm_if_props]
         } else {
            set ports [::altera_emif::util::hwtcl_utils::get_default_ports $if_enum]
         }
         set if_dir REVERSE_DIR

      } elseif {$if_enum == "IF_TG_STATUS"} {
         set num_of_ifs_used $num_of_amm_ifs

         if {$separate_read_write_ifs} {
            emif_assert { [expr {$num_of_ifs_used % 2 == 0}] }
            set num_of_ifs_used [expr {$num_of_ifs_used / 2}]
         }

         set ports [::altera_emif::util::hwtcl_utils::get_default_ports $if_enum]
         set if_dir NORMAL_DIR

      } elseif {$if_enum == "IF_CTRL_MMR_MASTER"} {
         set num_of_ifs_used [expr {[get_parameter_value CTRL_MMR_EN] ? $num_of_amm_ifs : 0}]
         set ports [::altera_emif::util::hwtcl_utils::get_default_ports $if_enum]
         set if_dir NORMAL_DIR

      } elseif {$if_enum == "IF_CTRL_ECC_USER_INTERRUPT"} {
         set num_of_ifs_used [expr {[get_parameter_value CTRL_ECC_EN] ? $num_of_amm_ifs : 0}]
         set ports [::altera_emif::util::hwtcl_utils::get_default_ports $if_enum]
         set if_dir REVERSE_DIR

      } elseif {$if_enum == "IF_CTRL_USER_PRIORITY"} {
         set num_of_ifs_used [expr {[get_parameter_value CTRL_USER_PRIORITY_EN] ? $num_of_amm_ifs : 0}]
         set ports [::altera_emif::util::hwtcl_utils::get_default_ports $if_enum]
         set if_dir REVERSE_DIR

      } elseif {$if_enum == "IF_CTRL_AUTO_PRECHARGE"} {
         set num_of_ifs_used [expr {[get_parameter_value CTRL_AUTO_PRECHARGE_EN] ? $num_of_amm_ifs : 0}]
         set ports [::altera_emif::util::hwtcl_utils::get_default_ports $if_enum]
         set if_dir REVERSE_DIR

      } elseif {$if_enum == "IF_EMIF_USR_CLK_SEC" || $if_enum == "IF_EMIF_USR_RESET_SEC"} {
         if {[get_parameter_value PHY_PING_PONG_EN]} {
            set num_of_ifs_used 1
            set ports [::altera_emif::util::ctrl_expert::get_interface_ports $if_enum]
         } else {
            set num_of_ifs_used 0
            set ports [::altera_emif::util::hwtcl_utils::get_default_ports $if_enum]
         }
         set if_dir REVERSE_DIR

      } elseif {$if_enum == "IF_TG_CFG"} {
         set num_of_ifs_used $num_of_ifs_in_rtl
         set ports [::altera_emif::util::hwtcl_utils::get_default_ports $if_enum]
         set if_dir NORMAL_DIR
      } else {
         set num_of_ifs_used $num_of_ifs_in_rtl
         set ports [::altera_emif::util::ctrl_expert::get_interface_ports $if_enum]
         set if_dir REVERSE_DIR
      }

      dict set if_ports $if_enum $ports

      for {set i 0} {$i < $num_of_ifs_in_rtl} {incr i} {
         set if_index [expr {$num_of_ifs_in_rtl == 1} ? -1 : $i]

         if {$i < $num_of_ifs_used} {
            set if_enabled true
         } else {
            set if_enabled false
         }

         set if_name [::altera_emif::util::hwtcl_utils::add_qsys_interface $if_enabled $if_enum $if_index $if_dir $ports]

         dict set if_names $if_enum $i $if_name
      }
   }

   _set_interface_properties $if_names

   set family_enum [get_device_family_enum]
   set_parameter_value MEGAFUNC_DEVICE_FAMILY [enum_data $family_enum MEGAFUNC_NAME]

   set_parameter_value SEPARATE_READ_WRITE_IFS $separate_read_write_ifs

   emif_assert {$num_of_amm_ifs > 0 }
   set amm_if_props [::altera_emif::util::ctrl_expert::get_interface_properties IF_CTRL_AMM]
   set_parameter_value NUM_OF_CTRL_PORTS                    [expr {$separate_read_write_ifs ? $num_of_amm_ifs / 2 : $num_of_amm_ifs}]
   set_parameter_value CTRL_AVL_PROTOCOL_ENUM               CTRL_AVL_PROTOCOL_MM
   set_parameter_value USE_AVL_BYTEEN                       [expr {[dict get $amm_if_props USE_BYTE_ENABLE] ? 1 : 0}]
   set_parameter_value AMM_WORD_ADDRESS_WIDTH               [dict get $amm_if_props WORD_ADDRESS_WIDTH]
   set_parameter_value AMM_WORD_ADDRESS_DIVISIBLE_BY        [dict get $amm_if_props WORD_ADDRESS_DIVISIBLE_BY]
   set_parameter_value AMM_BURST_COUNT_DIVISIBLE_BY         [dict get $amm_if_props BURST_COUNT_DIVISIBLE_BY]

   _derive_port_width_parameters $if_ports

   set extra_configs_str [get_parameter_value "DIAG_EXTRA_CONFIGS"]
   set extra_configs [parse_extra_configs $extra_configs_str]
   if {[extra_config_is_explicit_on $extra_configs USE_SIMPLE_TG]} {
      set_parameter_value USE_SIMPLE_TG true
   } else {
      set_parameter_value USE_SIMPLE_TG false
   }

   if {[dict exists $extra_configs TG_TEST_DURATION]} {
      set_parameter_value TEST_DURATION [dict get $extra_configs TG_TEST_DURATION]
   } else {
      set_parameter_value TEST_DURATION "SHORT"
   }

   set_parameter_value BYPASS_DEFAULT_PATTERN [get_parameter_value "DIAG_BYPASS_DEFAULT_PATTERN"]
   set_parameter_value BYPASS_USER_STAGE      [get_parameter_value "DIAG_BYPASS_USER_STAGE"]
   set_parameter_value BYPASS_REPEAT_STAGE    [get_parameter_value "DIAG_BYPASS_REPEAT_STAGE"]
   set_parameter_value BYPASS_STRESS_STAGE    [get_parameter_value "DIAG_BYPASS_STRESS_STAGE"]

   _derive_ddrx_params

   _update_qip

   issue_pending_ipgen_e_msg_and_terminate

   return 1
}

proc ::altera_emif::ip_tg_avl_2::main::sim_vhdl_fileset_callback {top_level} {

   set rtl_only 1
   set encrypted 1

   set non_encryp_simulators [::altera_emif::util::hwtcl_utils::get_simulator_attributes 1]

   foreach file_path [_generate_verilog_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]

      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name] PATH $file_path $non_encryp_simulators

      add_fileset_file [file join mentor $file_name] [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH [file join mentor $file_path] {MENTOR_SPECIFIC}
   }
}

proc ::altera_emif::ip_tg_avl_2::main::sim_verilog_fileset_callback {top_level} {

   set rtl_only 1
   set encrypted 0

   set HDL_LIB_DIR "../../../../ip/altera/sopc_builder_ip/verification/lib"
   add_fileset_file verbosity_pkg.sv SYSTEM_VERILOG PATH "$HDL_LIB_DIR/verbosity_pkg.sv"
   add_fileset_file avalon_mm_pkg.sv SYSTEM_VERILOG PATH "$HDL_LIB_DIR/avalon_mm_pkg.sv"

   set_fileset_file_attribute verbosity_pkg.sv        COMMON_SYSTEMVERILOG_PACKAGE avalon_vip_verbosity_pkg
   set_fileset_file_attribute avalon_mm_pkg.sv        COMMON_SYSTEMVERILOG_PACKAGE avalon_vip_avalon_mm_pkg

   foreach file_path [_generate_sim_verilog_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }
}

proc ::altera_emif::ip_tg_avl_2::main::quartus_synth_fileset_callback {top_level} {

   set rtl_only 0
   set encrypted 0

   foreach file_path [_generate_verilog_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }

   foreach file_path [_generate_common_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }
}


proc ::altera_emif::ip_tg_avl_2::main::_set_interface_properties {if_names} {

   set ping_pong_en [get_parameter_value PHY_PING_PONG_EN]

   set emif_usr_clk_if_name [dict get $if_names IF_EMIF_USR_CLK 0]
   set emif_usr_reset_if_name [dict get $if_names IF_EMIF_USR_RESET 0]
   set_interface_property $emif_usr_reset_if_name synchronousEdges NONE

   set emif_usr_clk_sec_if_name [dict get $if_names IF_EMIF_USR_CLK_SEC 0]
   set emif_usr_reset_sec_if_name [dict get $if_names IF_EMIF_USR_RESET_SEC 0]
   set_interface_property $emif_usr_reset_sec_if_name synchronousEdges NONE

   foreach if_enum [list IF_CTRL_AMM IF_CTRL_MMR_MASTER IF_TG_CFG] {
      foreach if_index [dict keys [dict get $if_names $if_enum]] {
         set if_name [dict get $if_names $if_enum $if_index]
         if {$ping_pong_en && $if_index == 1} {
            set_interface_property $if_name associatedClock $emif_usr_clk_sec_if_name
            set_interface_property $if_name associatedReset $emif_usr_reset_sec_if_name
         } else {
            set_interface_property $if_name associatedClock $emif_usr_clk_if_name
            set_interface_property $if_name associatedReset $emif_usr_reset_if_name
         }
         if {$if_enum == "IF_TG_CFG"} {
            set_interface_property $if_name maximumPendingReadTransactions 1
         }
      }
   }

   set num_of_amm_ifs [::altera_emif::util::ctrl_expert::get_num_of_interfaces_used IF_CTRL_AMM]

   emif_assert {$num_of_amm_ifs > 0}
   set amm_if_props [::altera_emif::util::ctrl_expert::get_interface_properties IF_CTRL_AMM]
   foreach if_enum [list IF_CTRL_AMM] {
      foreach if_index [dict keys [dict get $if_names $if_enum]] {
         set if_name [dict get $if_names $if_enum $if_index]

         set_interface_property $if_name bitsPerSymbol [dict get $amm_if_props SYMBOL_WIDTH]

      }
   }

   foreach if_index [dict keys [dict get $if_names IF_CTRL_MMR_MASTER]] {
      set if_name [dict get $if_names IF_CTRL_MMR_MASTER $if_index]

      set_interface_property $if_name bitsPerSymbol 8

      set_interface_property $if_name addressUnits WORDS

   }
}

proc ::altera_emif::ip_tg_avl_2::main::_get_ctrl_amm_ports {amm_if_props} {

   set ports [list]

   set ctrl_ports   [::altera_emif::util::ctrl_expert::get_interface_ports IF_CTRL_AMM]

   foreach ctrl_port $ctrl_ports {
      set port_type_enum [dict get $ctrl_port TYPE_ENUM]

      switch $port_type_enum {
         PORT_CTRL_AMM_ADDRESS {
            set address_width [dict get $amm_if_props SYMBOL_ADDRESS_WIDTH]
            lappend ports {*}[create_port true PORT_CTRL_AMM_ADDRESS $address_width]
         }
         default {
            lappend ports $ctrl_port
         }
      }
   }

   return $ports
}

proc ::altera_emif::ip_tg_avl_2::main::_derive_port_width_parameters {if_ports} {
   foreach if_enum [dict keys $if_ports] {
      set ports [dict get $if_ports $if_enum]
      ::altera_emif::util::hwtcl_utils::derive_port_width_parameters $ports
   }
   return 1
}

proc ::altera_emif::ip_tg_avl_2::main::_update_qip {} {

   set qip_strings [list ]


   set_qip_strings $qip_strings
}

proc ::altera_emif::ip_tg_avl_2::main::_generate_common_fileset {} {
   set file_list [list]
   return $file_list
}

proc ::altera_emif::ip_tg_avl_2::main::_generate_sim_verilog_fileset {} {
   set file_list [_generate_verilog_fileset]
   lappend file_list "rtl/altera_emif_avl_tg_2_tb.sv"
   return $file_list
}

proc ::altera_emif::ip_tg_avl_2::main::_generate_verilog_fileset {} {
   set file_list [list \
      rtl/altera_emif_avl_tg_defs.sv \
      rtl/altera_emif_avl_tg_2_top.sv \
      rtl/altera_emif_avl_tg_2_rw_gen.sv \
      rtl/altera_emif_avl_tg_2_addr_gen.sv \
      rtl/altera_emif_avl_tg_2_lfsr.sv \
      rtl/altera_emif_avl_tg_2_bringup_dcb.sv \
      rtl/altera_emif_avl_tg_driver_simple.sv \
      rtl/altera_emif_avl_tg_2_byteenable_test_stage.sv \
      rtl/altera_emif_avl_tg_2_avl_interface.sv \
      rtl/altera_emif_avl_tg_2_one_hot_addr_gen.sv \
      rtl/altera_emif_avl_tg_2_per_pin_pattern_gen.sv \
      rtl/altera_emif_avl_tg_2_pppg.sv \
      rtl/altera_emif_avl_tg_2_rand_seq_addr_gen.sv \
      rtl/altera_emif_avl_tg_2_seq_addr_gen.sv \
      rtl/altera_emif_avl_tg_2_traffic_gen.sv \
      rtl/altera_emif_avl_tg_2_rw_stage.sv \
      rtl/altera_emif_avl_tg_2_rand_num_gen.sv \
      rtl/altera_emif_avl_tg_2_reset_sync.sv \
      rtl/altera_emif_avl_tg_2_compare_addr_gen.sv \
      rtl/altera_emif_avl_tg_2_status_checker.sv \
      rtl/altera_emif_avl_tg_2_config_error_module.sv \
      rtl/altera_emif_avl_tg_lfsr_wrapper.sv \
      rtl/altera_emif_avl_tg_lfsr.sv \
      rtl/altera_emif_avl_tg_amm_1x_bridge.sv \
      rtl/altera_emif_avl_tg_2_targetted_reads_test_stage.sv \
   ]
   return $file_list
}


proc ::altera_emif::ip_tg_avl_2::main::_get_protocol_specific_param_prefix {} {
   set protocol_enum  [get_parameter_value "PROTOCOL_ENUM"]
   set module_name    [string toupper [enum_data $protocol_enum MODULE_NAME]]
   return "${module_name}"
}


proc ::altera_emif::ip_tg_avl_2::main::_derive_ddrx_params {} {

   set protocol_prefix [_get_protocol_specific_param_prefix]

   if {$protocol_prefix eq "DDR3" || $protocol_prefix eq "DDR4"} {
      set num_of_physical_ranks [get_parameter_value MEM_${protocol_prefix}_NUM_OF_PHYSICAL_RANKS]
   } elseif {$protocol_prefix eq "LPDDR3"} {
      set num_of_physical_ranks [get_parameter_value MEM_${protocol_prefix}_DISCRETE_CS_WIDTH]
   } else {
      set num_of_physical_ranks 1
   }
   set rank_width [expr {int(ceil([log2 $num_of_physical_ranks]))}]
   set_parameter_value MEM_RANK_WIDTH $rank_width
   if {$protocol_prefix eq "DDR3" || $protocol_prefix eq "DDR4" || $protocol_prefix eq "LPDDR3"} {
      set bank_addr_width [get_parameter_value "MEM_${protocol_prefix}_BANK_ADDR_WIDTH"]
      set row_addr_width  [get_parameter_value "MEM_${protocol_prefix}_ROW_ADDR_WIDTH"]
      set col_addr_width [get_parameter_value "MEM_${protocol_prefix}_COL_ADDR_WIDTH"]
   } else {
      set bank_addr_width 0
      set row_addr_width [get_parameter_value "MEM_${protocol_prefix}_ADDR_WIDTH"]
      set col_addr_width 0
   }
   set_parameter_value MEM_BANK_ADDR_WIDTH $bank_addr_width
   set_parameter_value MEM_ROW_ADDR_WIDTH $row_addr_width

   if {$protocol_prefix eq "QDR4"} {
      set avl_to_dq_width_ratio 2
   } else {
      set rate_enum        [get_parameter_value "PHY_${protocol_prefix}_RATE_ENUM"]
      set c2p_p2c_clk_ratio     [enum_data $rate_enum RATIO]
      set avl_to_dq_width_ratio   [expr {2 * $c2p_p2c_clk_ratio}]
   }
   set_parameter_value AVL_TO_DQ_WIDTH_RATIO $avl_to_dq_width_ratio

   if {$protocol_prefix eq "DDR4"} {
      set bank_group_width [get_parameter_value "MEM_DDR4_BANK_GROUP_WIDTH"]
   } else {
      set bank_group_width 0
   }
   set_parameter_value MEM_BANK_GROUP_WIDTH $bank_group_width

   if {$protocol_prefix eq "DDR3" || $protocol_prefix eq "DDR4" || $protocol_prefix eq "LPDDR3"} {
      set addr_order [lreverse [lrange [split [get_parameter_value CTRL_${protocol_prefix}_ADDR_ORDER_ENUM] _] 4 end]]

      set lsb 0
      foreach tg_addr_sect $addr_order {
         set addr_section_name [enum_data $tg_addr_sect ADDR_SECT_NAME]
         set addr_section_name_uc [string toupper $addr_section_name]
         set_parameter_value ${addr_section_name_uc}_LSB $lsb
         set lsb [expr $lsb + [set ${addr_section_name}_width]]
      }
   }
}


proc ::altera_emif::ip_tg_avl_2::main::_init {} {
}

::altera_emif::ip_tg_avl_2::main::_init
