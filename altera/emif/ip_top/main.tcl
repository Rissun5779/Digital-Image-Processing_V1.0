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


package provide altera_emif::ip_top::main 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_emif::util::arch_expert
package require altera_emif::util::ctrl_expert
package require altera_emif::util::device_family
package require altera_emif::ip_top::phy
package require altera_emif::ip_top::mem
package require altera_emif::ip_top::board
package require altera_emif::ip_top::ctrl
package require altera_emif::ip_top::diag
package require altera_emif::ip_top::ex_design_gui
package require altera_emif::ip_top::protocol_expert
package require altera_emif::ip_top::vg_autogen

namespace eval ::altera_emif::ip_top::main:: {

   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*

}


proc ::altera_emif::ip_top::main::create_parameters {is_top_level_component} {

   ::altera_emif::util::hwtcl_utils::init_iopll_api_for_emif_usage

   altera_emif::util::device_family::create_parameters

   add_user_param     PROTOCOL_ENUM                         string    PROTOCOL_DDR3        [list [enum_dropdown_entry PROTOCOL_DDR3]]
   add_user_param     IS_ED_SLAVE                           boolean   false                ""
   add_user_param     INTERNAL_TESTING_MODE                 boolean   false                ""

   set_parameter_property IS_ED_SLAVE VISIBLE false

   set_parameter_property INTERNAL_TESTING_MODE VISIBLE false

   ::altera_emif::util::hwtcl_utils::_add_parameter CAL_DEBUG_CLOCK_FREQUENCY LONG 50000000
   set if_cal_debug_clk_sink [enum_data IF_CAL_DEBUG_CLK OLD_QSYS_NAME]
   set if_cal_debug_clk_sink "${if_cal_debug_clk_sink}_clock_sink"
   set_parameter_property CAL_DEBUG_CLOCK_FREQUENCY SYSTEM_INFO CLOCK_RATE
   set_parameter_property CAL_DEBUG_CLOCK_FREQUENCY SYSTEM_INFO_ARG $if_cal_debug_clk_sink
   set_parameter_property CAL_DEBUG_CLOCK_FREQUENCY VISIBLE false


   ::altera_emif::util::hwtcl_utils::_add_parameter SYS_INFO_UNIQUE_ID string ""
   set_parameter_property SYS_INFO_UNIQUE_ID SYSTEM_INFO UNIQUE_ID
   set_parameter_property SYS_INFO_UNIQUE_ID VISIBLE false

   ::altera_emif::util::hwtcl_utils::_add_parameter PREV_PROTOCOL_ENUM string ""
   set_parameter_property PREV_PROTOCOL_ENUM DERIVED true
   set_parameter_property PREV_PROTOCOL_ENUM VISIBLE false

   ::altera_emif::ip_top::phy::create_parameters $is_top_level_component
   ::altera_emif::ip_top::mem::create_parameters $is_top_level_component
   ::altera_emif::ip_top::board::create_parameters $is_top_level_component
   ::altera_emif::ip_top::ctrl::create_parameters $is_top_level_component
   ::altera_emif::ip_top::diag::create_parameters $is_top_level_component
   ::altera_emif::ip_top::ex_design_gui::create_parameters $is_top_level_component

   return 1
}

proc ::altera_emif::ip_top::main::set_family_specific_defaults {} {

   set family_enum [get_device_family_enum]
   set base_family_enum [enum_data $family_enum BASE_FAMILY_ENUM]
   set is_hps [enum_data $family_enum IS_HPS]

   ::altera_emif::ip_top::phy::set_family_specific_defaults $family_enum $base_family_enum $is_hps
   ::altera_emif::ip_top::mem::set_family_specific_defaults $family_enum $base_family_enum $is_hps
   ::altera_emif::ip_top::board::set_family_specific_defaults $family_enum $base_family_enum $is_hps
   ::altera_emif::ip_top::ctrl::set_family_specific_defaults $family_enum $base_family_enum $is_hps
   ::altera_emif::ip_top::diag::set_family_specific_defaults $family_enum $base_family_enum $is_hps
   ::altera_emif::ip_top::ex_design_gui::set_family_specific_defaults $family_enum $base_family_enum $is_hps

   return 1
}

proc ::altera_emif::ip_top::main::add_display_items {} {

   set protocol_grp [get_string GRP_PROTOCOL_NAME]
   set phy_tab [get_string TAB_PHY_NAME]
   set io_tab [get_string TAB_IO_NAME]
   set mem_params_tab [get_string TAB_MEM_PARAMS_NAME]
   set mem_io_tab [get_string TAB_MEM_IO_NAME]
   set mem_timing_tab [get_string TAB_MEM_TIMING_NAME]
   set board_tab [get_string TAB_BOARD_TIMING_NAME]
   set ctrl_tab [get_string TAB_CONTROLLER_NAME]
   set diag_tab [get_string TAB_DIAGNOSTICS_NAME]
   set ex_design_tab [get_string TAB_EXAMPLE_DESIGN_NAME]

   add_display_item "" $protocol_grp GROUP
   add_param_to_gui $protocol_grp PROTOCOL_ENUM

   add_display_item "" $phy_tab GROUP tab
   add_display_item "" $mem_params_tab GROUP tab
   add_display_item "" $mem_io_tab GROUP tab
   add_display_item "" $io_tab GROUP tab
   add_display_item "" $mem_timing_tab GROUP tab
   add_display_item "" $board_tab GROUP tab
   add_display_item "" $ctrl_tab GROUP tab
   add_display_item "" $diag_tab GROUP tab
   add_display_item "" $ex_design_tab GROUP tab

   ::altera_emif::ip_top::phy::add_display_items [list $phy_tab $io_tab]
   ::altera_emif::ip_top::mem::add_display_items [list $mem_params_tab $mem_io_tab $mem_timing_tab]
   ::altera_emif::ip_top::board::add_display_items [list $board_tab]
   ::altera_emif::ip_top::ctrl::add_display_items [list $ctrl_tab]
   ::altera_emif::ip_top::diag::add_display_items [list $diag_tab]
   ::altera_emif::ip_top::ex_design_gui::add_display_items [list $ex_design_tab]

   ::altera_emif::ip_top::protocol_expert::save_params_default_visibility_state

   return 1
}

proc ::altera_emif::ip_top::main::composition_callback {} {
   reset_error_messages

   ::altera_emif::util::hwtcl_utils::init_iopll_api_for_emif_usage

   if {[get_parameter_value SYS_INFO_DEVICE_FAMILY] == ""} {
      return 0
   }


   set protocol_enum [get_parameter_value PROTOCOL_ENUM]
   if {[get_parameter_value PREV_PROTOCOL_ENUM] != $protocol_enum ||
      ([get_parameter_property PHY_DDR3_CONFIG_ENUM VISIBLE] && [get_parameter_property PHY_DDR4_CONFIG_ENUM VISIBLE])} {
      set_parameter_value PREV_PROTOCOL_ENUM $protocol_enum
      ::altera_emif::ip_top::protocol_expert::update_gui_based_on_protocol
   }

   _validate

   if {[info exists ::env(AUTOGEN_VG_XML)]} {
      _autogen_xml
   }


   if {![has_pending_ipgen_e_msg]} {
      if {![::altera_emif::util::arch_expert::is_emif_realizable]}  {
         post_ipgen_e_msg MSG_EMIF_NOT_REALIZABLE [list]
      }
   }


   if {[has_pending_ipgen_e_msg]} {
      issue_pending_ipgen_e_msg_and_terminate
   } else {
      _compose

      issue_pending_ipgen_e_msg_and_terminate
   }
}


proc ::altera_emif::ip_top::main::_validate {} {
   ::altera_emif::util::device_family::load_data true

   set device [string trim [get_parameter_value SYS_INFO_DEVICE]]
   if {$device == "" || [string compare -nocase $device "unknown"] == 0} {
      post_ipgen_w_msg MSG_DEVICE_NOT_SPECIFIED
   }

   _update_range_parameters

   ::altera_emif::ip_top::phy::validate
   ::altera_emif::ip_top::mem::validate
   ::altera_emif::ip_top::board::validate
   ::altera_emif::ip_top::ctrl::validate
   ::altera_emif::ip_top::diag::validate
   ::altera_emif::ip_top::ex_design_gui::validate

   return [expr {![has_pending_ipgen_e_msg]}]
}

proc ::altera_emif::ip_top::main::_autogen_xml {} {
   ::altera_emif::util::device_family::load_data true

   set device [string trim [get_parameter_value SYS_INFO_DEVICE]]
   if {$device == "" || [string compare -nocase $device "unknown"] == 0} {
      post_ipgen_w_msg MSG_DEVICE_NOT_SPECIFIED
   }

   _update_range_parameters

   ::altera_emif::ip_top::phy::autogen_xml

}

proc ::altera_emif::ip_top::main::_compose {} {

   set family_enum                  [::altera_emif::util::device_family::get_device_family_enum]
   set is_hps                       [get_is_hps]
   set use_short_name               [get_parameter_value "SHORT_QSYS_INTERFACE_NAMES"]
   set config_enum                  [get_parameter_value "PHY_CONFIG_ENUM"]
   set ping_pong_en                 [get_parameter_value "PHY_PING_PONG_EN"]
   set ecc_en                       [get_parameter_value "CTRL_ECC_EN"]
   set mmr_en                       [get_parameter_value "CTRL_MMR_EN"]
   set export_seq_avalon_slave_enum [get_parameter_value "DIAG_EXPORT_SEQ_AVALON_SLAVE"]
   set jtag_uart_en                 [get_parameter_value "DIAG_ENABLE_JTAG_UART"]
   set soft_ram_en                  [get_parameter_value "DIAG_ENABLE_SOFT_M20K"]
   set hps_debug_en                 [get_parameter_value "DIAG_ENABLE_HPS_EMIF_DEBUG"]
   set effmon_mode                  [get_parameter_value "DIAG_EFFICIENCY_MONITOR"]
   set effmon_en                    [string compare -nocase $effmon_mode "EFFMON_MODE_DISABLED"]
   set use_onchip_nios              [expr {[get_parameter_value "DIAG_SOFT_NIOS_MODE"] == "SOFT_NIOS_MODE_ON_CHIP_DEBUG"}]

   set if_afi_reset_src              [generate_qsys_interface_name_ex $use_short_name IF_AFI_RESET             -1 NORMAL_DIR ]
   set if_afi_reset_sink             [generate_qsys_interface_name_ex $use_short_name IF_AFI_RESET             -1 REVERSE_DIR]
   set if_afi_clk_src                [generate_qsys_interface_name_ex $use_short_name IF_AFI_CLK               -1 NORMAL_DIR ]
   set if_afi_clk_sink               [generate_qsys_interface_name_ex $use_short_name IF_AFI_CLK               -1 REVERSE_DIR]
   set if_afi_half_clk_src           [generate_qsys_interface_name_ex $use_short_name IF_AFI_HALF_CLK          -1 NORMAL_DIR ]
   set if_afi_half_clk_sink          [generate_qsys_interface_name_ex $use_short_name IF_AFI_HALF_CLK          -1 REVERSE_DIR]
   set if_afi_end                    [generate_qsys_interface_name_ex $use_short_name IF_AFI                   -1 NORMAL_DIR ]
   set if_cal_master_reset_src       [generate_qsys_interface_name_ex $use_short_name IF_CAL_MASTER_RESET      -1 NORMAL_DIR ]
   set if_cal_master_clk_src         [generate_qsys_interface_name_ex $use_short_name IF_CAL_MASTER_CLK        -1 NORMAL_DIR ]
   set if_cal_slave_reset_src        [generate_qsys_interface_name_ex $use_short_name IF_CAL_SLAVE_RESET       -1 NORMAL_DIR ]
   set if_cal_slave_clk_src          [generate_qsys_interface_name_ex $use_short_name IF_CAL_SLAVE_CLK         -1 NORMAL_DIR ]
   set if_emif_usr_reset_pri_src     [generate_qsys_interface_name_ex $use_short_name IF_EMIF_USR_RESET        -1 NORMAL_DIR ]
   set if_emif_usr_clk_pri_src       [generate_qsys_interface_name_ex $use_short_name IF_EMIF_USR_CLK          -1 NORMAL_DIR ]
   set if_emif_usr_reset_pri_in_sink [generate_qsys_interface_name_ex $use_short_name IF_EMIF_USR_RESET_IN     -1 NORMAL_DIR ]
   set if_emif_usr_clk_pri_in_sink   [generate_qsys_interface_name_ex $use_short_name IF_EMIF_USR_CLK_IN       -1 NORMAL_DIR ]
   set if_emif_usr_reset_sec_src     [generate_qsys_interface_name_ex $use_short_name IF_EMIF_USR_RESET_SEC    -1 NORMAL_DIR ]
   set if_emif_usr_clk_sec_src       [generate_qsys_interface_name_ex $use_short_name IF_EMIF_USR_CLK_SEC      -1 NORMAL_DIR ]
   set if_emif_usr_reset_sec_in_sink [generate_qsys_interface_name_ex $use_short_name IF_EMIF_USR_RESET_SEC_IN -1 NORMAL_DIR ]
   set if_emif_usr_clk_sec_in_sink   [generate_qsys_interface_name_ex $use_short_name IF_EMIF_USR_CLK_SEC_IN   -1 NORMAL_DIR ]
   set if_status_end                 [generate_qsys_interface_name_ex $use_short_name IF_STATUS                -1 NORMAL_DIR ]
   set if_cal_debug_slave            [generate_qsys_interface_name_ex $use_short_name IF_CAL_DEBUG             -1 NORMAL_DIR ]
   set if_cal_debug_clk_sink         [generate_qsys_interface_name_ex $use_short_name IF_CAL_DEBUG_CLK         -1 NORMAL_DIR ]
   set if_cal_debug_reset_sink       [generate_qsys_interface_name_ex $use_short_name IF_CAL_DEBUG_RESET       -1 NORMAL_DIR ]
   set if_cal_master                 [generate_qsys_interface_name_ex $use_short_name IF_CAL_MASTER            -1 NORMAL_DIR ]
   set if_cal_slave_clk_in_sink      [generate_qsys_interface_name_ex $use_short_name IF_CAL_SLAVE_CLK_IN      -1 NORMAL_DIR ]
   set if_cal_slave_reset_in_sink    [generate_qsys_interface_name_ex $use_short_name IF_CAL_SLAVE_RESET_IN    -1 NORMAL_DIR ]
   set if_effmon_status_in_end       [generate_qsys_interface_name_ex $use_short_name IF_EFFMON_STATUS_IN      -1 NORMAL_DIR ]
   set if_effmon_amm_master          [generate_qsys_interface_name_ex $use_short_name IF_EFFMON_AMM_MASTER     -1 NORMAL_DIR ]
   set if_effmon_csr_slave           [generate_qsys_interface_name_ex $use_short_name IF_EFFMON_CSR            -1 NORMAL_DIR ]

   set arch_component [::altera_emif::util::arch_expert::get_arch_component_qsys_name]
   set arch_name "arch"

   add_instance $arch_name $arch_component

   foreach param_name [get_parameters] {
      set param_val [get_parameter_value $param_name]
      set_instance_parameter_value $arch_name $param_name $param_val
   }

   if {$is_hps} {
      if {$hps_debug_en} {
         set clk_bridge "clk_bridge"
         add_instance $clk_bridge altera_clock_bridge
         set_instance_parameter_value $clk_bridge NUM_CLOCK_OUTPUTS 1

         set rst_bridge "rst_bridge"
         add_instance $rst_bridge altera_reset_bridge
         set_instance_parameter_value $rst_bridge NUM_RESET_OUTPUTS 1
         set_instance_parameter_value $rst_bridge SYNCHRONOUS_EDGES none
         set_instance_parameter_value $rst_bridge ACTIVE_LOW_RESET true

         set rs232_uart "rs232_uart"
         add_instance $rs232_uart altera_avalon_uart
         set_instance_parameter_value $rs232_uart parity NONE
         set_instance_parameter_value $rs232_uart dataBits 8
         set_instance_parameter_value $rs232_uart stopBits 1
         set_instance_parameter_value $rs232_uart syncRegDepth 2
         set_instance_parameter_value $rs232_uart baud 115200
         set_instance_parameter_value $rs232_uart fixedBaud false

         add_connection "${arch_name}.${if_cal_master}" "${rs232_uart}.s1" avalon

         add_connection "${clk_bridge}.out_clk"   "${rs232_uart}.clk"
         add_connection "${clk_bridge}.out_clk"   "${arch_name}.${if_cal_slave_clk_in_sink}"
         add_connection "${clk_bridge}.out_clk"   "${arch_name}.${if_cal_debug_clk_sink}"

         add_connection "${rst_bridge}.out_reset" "${rs232_uart}.reset"
         add_connection "${rst_bridge}.out_reset" "${arch_name}.${if_cal_slave_reset_in_sink}"
         add_connection "${rst_bridge}.out_reset" "${arch_name}.${if_cal_debug_reset_sink}"

         add_interface $if_cal_debug_clk_sink     clock sink
         add_interface $if_cal_debug_reset_sink   reset sink

         set_interface_property  $if_cal_debug_clk_sink    EXPORT_OF "${clk_bridge}.in_clk"
         set_interface_property  $if_cal_debug_reset_sink  EXPORT_OF "${rst_bridge}.in_reset"

         add_interface emif_uart  conduit end

         set_interface_property emif_uart EXPORT_OF "${rs232_uart}.external_connection"

         set_connection_parameter_value "${arch_name}.${if_cal_master}/${rs232_uart}.s1" baseAddress {0x0000}
      }
   } else {
      if {$config_enum == "CONFIG_PHY_ONLY"} {
         add_interface $if_afi_reset_src     reset source
         add_interface $if_afi_clk_src       clock source
         add_interface $if_afi_half_clk_src  clock source
      } else {
         add_interface $if_emif_usr_reset_pri_src  reset source
         add_interface $if_emif_usr_clk_pri_src    clock source

         if {$ping_pong_en} {
            add_interface $if_emif_usr_reset_sec_src  reset source
            add_interface $if_emif_usr_clk_sec_src    clock source
         }
      }

      if {$config_enum == "CONFIG_PHY_AND_SOFT_CTRL"} {
         set ctrl_component [::altera_emif::util::ctrl_expert::get_ctrl_component_qsys_name]
         set ctrl_name "ctrl"

         add_instance $ctrl_name $ctrl_component

         foreach param_name [get_parameters] {
            set param_val [get_parameter_value $param_name]
            set_instance_parameter_value $ctrl_name $param_name $param_val
         }

         add_connection "${arch_name}.${if_afi_end}"          "${ctrl_name}.${if_afi_end}"
         add_connection "${arch_name}.${if_afi_reset_src}"    "${ctrl_name}.${if_afi_reset_sink}"
         add_connection "${arch_name}.${if_afi_clk_src}"      "${ctrl_name}.${if_afi_clk_sink}"
         add_connection "${arch_name}.${if_afi_half_clk_src}" "${ctrl_name}.${if_afi_half_clk_sink}"

         set_interface_property $if_emif_usr_reset_pri_src EXPORT_OF "${ctrl_name}.${if_emif_usr_reset_pri_src}"
         set_interface_property $if_emif_usr_clk_pri_src   EXPORT_OF "${ctrl_name}.${if_emif_usr_clk_pri_src}"


         altera_emif::util::hwtcl_utils::export_unconnected_interfaces_of_sub_component $ctrl_name

      } elseif {$config_enum == "CONFIG_PHY_ONLY"} {
         set_interface_property $if_afi_reset_src     EXPORT_OF "${arch_name}.${if_afi_reset_src}"
         set_interface_property $if_afi_clk_src       EXPORT_OF "${arch_name}.${if_afi_clk_src}"
         set_interface_property $if_afi_half_clk_src  EXPORT_OF "${arch_name}.${if_afi_half_clk_src}"

      } elseif {$config_enum == "CONFIG_PHY_AND_HARD_CTRL"} {

         set num_avl_ifs [expr {$ping_pong_en ? 2 : 1}]

         set components_to_export [list]
         set prev_comp      "${arch_name}"
         set prev_clk_pri   "${arch_name}.${if_emif_usr_clk_pri_src}"
         set prev_reset_pri "${arch_name}.${if_emif_usr_reset_pri_src}"
         set prev_clk_sec   "${arch_name}.${if_emif_usr_clk_sec_src}"
         set prev_reset_sec "${arch_name}.${if_emif_usr_reset_sec_src}"

         set ecc_name "ecc_core"
         if {$ecc_en} {
            set ecc_component "altera_emif_ecc"
            add_instance $ecc_name $ecc_component

            foreach param_name [get_parameters] {
               set param_val [get_parameter_value $param_name]
               set_instance_parameter_value $ecc_name $param_name $param_val
            }

            for {set ecc_i 0} {$ecc_i < $num_avl_ifs} {incr ecc_i} {

               if {$ecc_i == 0} {
                  add_connection $prev_clk_pri   "${ecc_name}.${if_emif_usr_clk_pri_in_sink}"
                  add_connection $prev_reset_pri "${ecc_name}.${if_emif_usr_reset_pri_in_sink}"
                  set prev_clk_pri               "${ecc_name}.${if_emif_usr_clk_pri_src}"
                  set prev_reset_pri             "${ecc_name}.${if_emif_usr_reset_pri_src}"
               } else {
                  add_connection $prev_clk_sec   "${ecc_name}.${if_emif_usr_clk_sec_in_sink}"
                  add_connection $prev_reset_sec "${ecc_name}.${if_emif_usr_reset_sec_in_sink}"
                  set prev_clk_sec               "${ecc_name}.${if_emif_usr_clk_sec_src}"
                  set prev_reset_sec             "${ecc_name}.${if_emif_usr_reset_sec_src}"
               }

               set if_ctrl_ecc_end       [generate_qsys_interface_name_ex $use_short_name IF_CTRL_ECC          $ecc_i NORMAL_DIR ]
               set if_ctrl_ast_cmd_src   [generate_qsys_interface_name_ex $use_short_name IF_CTRL_AST_CMD      $ecc_i REVERSE_DIR]
               set if_ctrl_ast_cmd_sink  [generate_qsys_interface_name_ex $use_short_name IF_CTRL_AST_CMD      $ecc_i NORMAL_DIR ]
               set if_ctrl_ast_wr_src    [generate_qsys_interface_name_ex $use_short_name IF_CTRL_AST_WR       $ecc_i REVERSE_DIR]
               set if_ctrl_ast_wr_sink   [generate_qsys_interface_name_ex $use_short_name IF_CTRL_AST_WR       $ecc_i NORMAL_DIR ]
               set if_ctrl_ast_rd_src    [generate_qsys_interface_name_ex $use_short_name IF_CTRL_AST_RD       $ecc_i NORMAL_DIR ]
               set if_ctrl_ast_rd_sink   [generate_qsys_interface_name_ex $use_short_name IF_CTRL_AST_RD       $ecc_i REVERSE_DIR]
               set if_ctrl_mmr_master    [generate_qsys_interface_name_ex $use_short_name IF_CTRL_MMR_MASTER   $ecc_i NORMAL_DIR ]
               set if_ctrl_mmr_slave     [generate_qsys_interface_name_ex $use_short_name IF_CTRL_MMR_SLAVE    $ecc_i NORMAL_DIR ]

               add_connection "${ecc_name}.${if_ctrl_ecc_end}"       "${arch_name}.${if_ctrl_ecc_end}"
               add_connection "${ecc_name}.${if_ctrl_ast_cmd_src}"   "${arch_name}.${if_ctrl_ast_cmd_sink}"
               add_connection "${ecc_name}.${if_ctrl_ast_wr_src}"    "${arch_name}.${if_ctrl_ast_wr_sink}"
               add_connection "${arch_name}.${if_ctrl_ast_rd_src}"   "${ecc_name}.${if_ctrl_ast_rd_sink}"

               if { $mmr_en } {
                  add_connection "${ecc_name}.${if_ctrl_mmr_master}" "${arch_name}.${if_ctrl_mmr_slave}"
               }
            }

            set prev_comp  "${ecc_name}"

            lappend components_to_export $ecc_name
         }

         if {$effmon_en} {
            set effmon_name      "effmon"
            _instantiate_effmon $effmon_name $num_avl_ifs

            add_connection $prev_clk_pri    "${effmon_name}.${if_emif_usr_clk_pri_in_sink}"
            add_connection $prev_reset_pri  "${effmon_name}.${if_emif_usr_reset_pri_in_sink}"
            if {$ping_pong_en} {
               add_connection $prev_clk_sec    "${effmon_name}.${if_emif_usr_clk_sec_in_sink}"
               add_connection $prev_reset_sec  "${effmon_name}.${if_emif_usr_reset_sec_in_sink}"
            }

            add_connection "${arch_name}.${if_status_end}" "${effmon_name}.${if_effmon_status_in_end}"

            for {set effmon_i 0} {$effmon_i < $num_avl_ifs} {incr effmon_i} {

               set if_ctrl_amm_slave [generate_qsys_interface_name_ex $use_short_name IF_CTRL_AMM $effmon_i NORMAL_DIR]

               add_connection "${effmon_name}.${if_effmon_amm_master}_${effmon_i}" "${prev_comp}.${if_ctrl_amm_slave}"

               if {![string compare -nocase $effmon_mode "EFFMON_MODE_JTAG"]} {
                  set CSR_MASTER "em_jtag_${effmon_i}"
                  add_instance $CSR_MASTER altera_jtag_avalon_master

                  set_instance_parameter $CSR_MASTER USE_PLI "0"
                  set_instance_parameter $CSR_MASTER PLI_PORT "50000"

                  add_connection "${CSR_MASTER}.master" "${effmon_name}.${if_effmon_csr_slave}_${effmon_i}"

                  if {$effmon_i == 0} {
                     add_connection "${prev_clk_pri}" "${CSR_MASTER}.clk"
                     add_connection "${prev_reset_pri}" " ${CSR_MASTER}.clk_reset"
                  } else {
                     add_connection "${prev_clk_sec}" "${CSR_MASTER}.clk"
                     add_connection "${prev_reset_sec}" " ${CSR_MASTER}.clk_reset"
                  }

                  set_connection_parameter_value "${CSR_MASTER}.master/${effmon_name}.${if_effmon_csr_slave}_${effmon_i}" arbitrationPriority "1"
                  set_connection_parameter_value "${CSR_MASTER}.master/${effmon_name}.${if_effmon_csr_slave}_${effmon_i}" baseAddress "0x0000"
               }
            }

            set prev_clk_pri   "${effmon_name}.${if_emif_usr_clk_pri_src}"
            set prev_reset_pri "${effmon_name}.${if_emif_usr_reset_pri_src}"
            if {$ping_pong_en} {
               set prev_clk_sec   "${effmon_name}.${if_emif_usr_clk_sec_src}"
               set prev_reset_sec "${effmon_name}.${if_emif_usr_reset_sec_src}"
            }

            lappend components_to_export $effmon_name

            set prev_comp  "${effmon_name}"
         }

         set_interface_property $if_emif_usr_reset_pri_src   EXPORT_OF  $prev_reset_pri
         set_interface_property $if_emif_usr_clk_pri_src     EXPORT_OF  $prev_clk_pri

         if {$ping_pong_en} {
            set_interface_property $if_emif_usr_reset_sec_src   EXPORT_OF  $prev_reset_sec
            set_interface_property $if_emif_usr_clk_sec_src     EXPORT_OF  $prev_clk_sec
         }

         foreach component $components_to_export {
            altera_emif::util::hwtcl_utils::export_unconnected_interfaces_of_sub_component $component
         }
      } else {
         emif_ie "Unsupported config enum $config_enum"
      }


      set cal_master_clk_source "${arch_name}.$if_cal_master_clk_src"
      set cal_master_rst_source "${arch_name}.$if_cal_master_reset_src"

      if {$use_onchip_nios} {
         set soft_nios "soft_nios"
         add_instance  $soft_nios altera_emif_soft_nios
         set_instance_parameter_value ${soft_nios} SOFT_NIOS_MODE            [get_parameter_value DIAG_SOFT_NIOS_MODE]
         set_instance_parameter_value ${soft_nios} SOFT_NIOS_CLOCK_FREQUENCY [get_parameter_value DIAG_SOFT_NIOS_CLOCK_FREQUENCY]
         set_instance_parameter_value ${soft_nios} ENABLE_RS232_UART         [get_parameter_value DIAG_USE_RS232_UART]
         set_instance_parameter_value ${soft_nios} RS232_UART_BAUDRATE       [get_parameter_value DIAG_RS232_UART_BAUDRATE]
         set_instance_parameter_value ${soft_nios} ENABLE_JTAG_UART          true
         set_instance_parameter_value ${soft_nios} ENABLE_EXPORT_SLAVE       false

         add_connection $cal_master_clk_source ${soft_nios}.dbg_clk clock
         add_connection $cal_master_rst_source ${soft_nios}.dbg_rst reset
         add_connection ${soft_nios}.dbg_to_ioaux "${arch_name}.${if_cal_debug_slave}"
         if {[get_parameter_value DIAG_USE_RS232_UART]} {
            add_interface dbg_rs232 conduit end
            set_interface_property dbg_rs232 export_of ${soft_nios}.dbg_rs232
         }
      }
      if {$export_seq_avalon_slave_enum == "CAL_DEBUG_EXPORT_MODE_JTAG"} {
         set jtag_component "altera_ip_col_if"
         set jtag_name "col_if"
         add_instance $jtag_name $jtag_component

         set_instance_parameter_value $jtag_name ENABLE_JTAG_AVALON_MASTER true
         set_instance_parameter_value $jtag_name NUM_AVALON_INTERFACES 0

         add_connection "${jtag_name}.to_ioaux" "${arch_name}.${if_cal_debug_slave}"

         add_connection $cal_master_clk_source "${jtag_name}.avl_clk_in" clock

         add_connection $cal_master_rst_source "${jtag_name}.avl_rst_in" reset
      }

      if {$use_onchip_nios || $export_seq_avalon_slave_enum == "CAL_DEBUG_EXPORT_MODE_JTAG"} {
         add_connection $cal_master_clk_source "${arch_name}.${if_cal_debug_clk_sink}" clock
         add_connection $cal_master_rst_source "${arch_name}.${if_cal_debug_reset_sink}" reset
      }


      set cal_slave_clk_source "${arch_name}.$if_cal_slave_clk_src"
      set cal_slave_rst_source "${arch_name}.$if_cal_slave_reset_src"

      set use_cal_slave_component [expr {$jtag_uart_en || $soft_ram_en}]
      if {$use_cal_slave_component} {

         set cal_slave_component "cal_slave_component"
         add_instance $cal_slave_component [enum_data $family_enum CAL_SLAVE_COMPONENT]
         set_instance_parameter_value $cal_slave_component ENABLE_JTAG_UART $jtag_uart_en
         set_instance_parameter_value $cal_slave_component ENABLE_SOFT_RAM  $soft_ram_en
         if {$soft_ram_en} {
            set soft_ram_hex [::altera_emif::util::arch_expert::get_cal_code_soft_m20k_hex_file_name]
         } else {
            set soft_ram_hex ""
         }
         set_instance_parameter_value $cal_slave_component SOFT_RAM_HEXFILE $soft_ram_hex

         add_connection "$cal_slave_clk_source" "${arch_name}.${if_cal_slave_clk_in_sink}"
         add_connection "$cal_slave_rst_source" "${arch_name}.${if_cal_slave_reset_in_sink}"

         add_connection "$cal_slave_clk_source/${cal_slave_component}.clk"
         add_connection "$cal_slave_rst_source/${cal_slave_component}.rst"

         add_connection "${arch_name}.${if_cal_master}/${cal_slave_component}.avl"
      }
   }

   altera_emif::util::hwtcl_utils::export_unconnected_interfaces_of_sub_component $arch_name

   return 1
}

proc ::altera_emif::ip_top::main::_update_range_parameters {} {
   set_parameter_property PROTOCOL_ENUM ALLOWED_RANGES [_get_protocol_list]
}

proc ::altera_emif::ip_top::main::_get_protocol_list {} {
   set retval [list]

   foreach protocol_enum [enums_of_type PROTOCOL] {
      if {$protocol_enum == "PROTOCOL_INVALID"} {
         continue
      }

      if { [get_feature_support_level FEATURE_EMIF $protocol_enum] != 0 } {
         lappend retval [enum_dropdown_entry $protocol_enum]
      }
   }
   return $retval
}

proc ::altera_emif::ip_top::main::_instantiate_effmon {effmon_name num_avl_ifs} {
   set effmon_component "altera_avalon_em_pc_core"
   add_instance $effmon_name $effmon_component

   set amm_if_props [::altera_emif::util::ctrl_expert::get_interface_properties IF_CTRL_AMM]
   set data_width                [dict get $amm_if_props WORD_WIDTH               ]
   set symbol_width              [dict get $amm_if_props SYMBOL_WIDTH             ]
   set symbols_per_word          [dict get $amm_if_props SYMBOLS_PER_WORD         ]
   set be_width                  [dict get $amm_if_props BYTE_ENABLE_WIDTH        ]
   set dm_en                     [dict get $amm_if_props USE_BYTE_ENABLE          ]
   set word_address_width        [dict get $amm_if_props WORD_ADDRESS_WIDTH       ]
   set symbol_address_width      [dict get $amm_if_props SYMBOL_ADDRESS_WIDTH     ]
   set burst_count_width         [dict get $amm_if_props BURST_COUNT_WIDTH        ]
   set word_address_divisible_by [dict get $amm_if_props WORD_ADDRESS_DIVISIBLE_BY]
   set burst_count_divisible_by  [dict get $amm_if_props BURST_COUNT_DIVISIBLE_BY ]

   set use_pow2_data_width 0

   set av_num_symbols [expr {$data_width / $symbol_width}]
   set av_pow2_num_symbols [expr {pow(2, int(ceil(log($av_num_symbols) / log(2))))}]
   set av_pow2_data_width [expr {$use_pow2_data_width ? ($symbol_width * $av_pow2_num_symbols) : $data_width}]

   set_instance_parameter_value $effmon_name EMPC_AV_BURSTCOUNT_WIDTH $burst_count_width
   set_instance_parameter_value $effmon_name EMPC_AV_DATA_WIDTH       $data_width
   set_instance_parameter_value $effmon_name EMPC_AV_POW2_DATA_WIDTH  $av_pow2_data_width
   set_instance_parameter_value $effmon_name EMPC_AVM_ADDRESS_WIDTH    $word_address_width
   set_instance_parameter_value $effmon_name EMPC_AV_SYMBOL_WIDTH     $symbol_width

   set av_slave_address_width  [expr { $word_address_width + int(ceil(log($symbols_per_word)/log(2))) }]
   set_instance_parameter_value $effmon_name EMPC_AVS_ADDRESS_WIDTH    $av_slave_address_width
   set_instance_parameter_value $effmon_name EMPC_AV_BE_WIDTH          $av_num_symbols
   set_instance_parameter_value $effmon_name EMPC_AV_POW2_BE_WIDTH     $av_num_symbols

   set_instance_parameter_value $effmon_name EMPC_LEGACY_VERSION false
   set_instance_parameter_value $effmon_name EMPC_NUM_AVL_IFS $num_avl_ifs
   set_instance_parameter_value $effmon_name EMPC_MAX_READ_TRANSACTIONS 1

   set_instance_parameter_value $effmon_name SHORT_QSYS_INTERFACE_NAMES [get_parameter_value SHORT_QSYS_INTERFACE_NAMES]
}


proc ::altera_emif::ip_top::main::_init {} {
}

::altera_emif::ip_top::main::_init
