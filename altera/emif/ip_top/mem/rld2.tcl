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


package provide altera_emif::ip_top::mem::rld2 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::math
package require altera_emif::util::enums
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_top::mem::rld2:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::math::*
   
   
   variable m_param_prefix "MEM_RLD2"
}


proc ::altera_emif::ip_top::mem::rld2::create_parameters {is_top_level_component} {
   variable m_param_prefix

   add_user_param     "${m_param_prefix}_WIDTH_EXPANDED"          boolean   false                                       ""
   add_user_param     "${m_param_prefix}_DQ_PER_DEVICE"           integer   9                                           [list  9 18 36]
   add_user_param     "${m_param_prefix}_ADDR_WIDTH"              integer   21                                          [list 17 18 19 20 21]
   add_user_param     "${m_param_prefix}_BANK_ADDR_WIDTH"         integer   3                                           [list 3]
   add_user_param     "${m_param_prefix}_DM_EN"                   boolean   true                                        ""
   add_user_param     "${m_param_prefix}_BL"                      integer   4                                           [list 2 4 8]
   add_user_param     "${m_param_prefix}_CONFIG_ENUM"             string    RLD2_CONFIG_TRC_8_TRL_8_TWL_9               [enum_dropdown_entries RLD2_CONFIG]
   add_user_param     "${m_param_prefix}_DRIVE_IMPEDENCE_ENUM"    string    RLD2_DRIVE_IMPEDENCE_INTERNAL_50            [enum_dropdown_entries RLD2_DRIVE_IMPEDENCE]
   add_user_param     "${m_param_prefix}_ODT_MODE_ENUM"           string    RLD2_ODT_ON                                 [enum_dropdown_entries RLD2_ODT] 
   

   add_derived_param  "${m_param_prefix}_FORMAT_ENUM"      string     MEM_FORMAT_DISCRETE  false
   add_derived_param  "${m_param_prefix}_DEVICE_WIDTH"     integer    1                    false
   add_derived_param  "${m_param_prefix}_DEVICE_DEPTH"     integer    1                    false
   add_derived_param  "${m_param_prefix}_DQ_WIDTH"         integer    9                    true
   add_derived_param  "${m_param_prefix}_DQ_PER_RD_GROUP"  integer    9                    false
   add_derived_param  "${m_param_prefix}_DQ_PER_WR_GROUP"  integer    9                    false
   add_derived_param  "${m_param_prefix}_QK_WIDTH"         integer    1                    true
   add_derived_param  "${m_param_prefix}_DK_WIDTH"         integer    1                    true
   add_derived_param  "${m_param_prefix}_DM_WIDTH"         integer    1                    false
   add_derived_param  "${m_param_prefix}_CS_WIDTH"         integer    1                    false

   add_derived_param  "${m_param_prefix}_TRC"              integer    8                    false
   add_derived_param  "${m_param_prefix}_TRL"              integer    8                    false
   add_derived_param  "${m_param_prefix}_TWL"              integer    9                    false
   
   add_derived_param  "${m_param_prefix}_MR"                      integer    0         false

   add_user_param     "${m_param_prefix}_SPEEDBIN_ENUM"                        string    RLD2_SPEEDBIN_18    [enum_dropdown_entries RLD2_SPEEDBIN]    ""
   add_user_param     "${m_param_prefix}_REFRESH_INTERVAL_US"                  float     0.24                ""                                       "microseconds"
   add_user_param     "${m_param_prefix}_TCKH_CYC"                             float     0.45                ""                                       "Cycles"   
   add_user_param     "${m_param_prefix}_TQKH_HCYC"                            float     0.9                 ""                                       "Cycles"
   add_user_param     "${m_param_prefix}_TAS_NS"                               float     0.3                 ""                                       "nanoseconds"   
   add_user_param     "${m_param_prefix}_TAH_NS"                               float     0.3                 ""                                       "nanoseconds"
   add_user_param     "${m_param_prefix}_TDS_NS"                               float     0.17                ""                                       "nanoseconds"
   add_user_param     "${m_param_prefix}_TDH_NS"                               float     0.17                ""                                       "nanoseconds"
   add_user_param     "${m_param_prefix}_TQKQ_MAX_NS"                          float     0.12                ""                                       "nanoseconds"
   add_user_param     "${m_param_prefix}_TQKQ_MIN_NS"                          float    -0.12                ""                                       "nanoseconds"
   add_user_param     "${m_param_prefix}_TCKDK_MAX_NS"                         float     0.3                 ""                                       "nanoseconds"
   add_user_param     "${m_param_prefix}_TCKDK_MIN_NS"                         float    -0.3                 ""                                       "nanoseconds"
   add_user_param     "${m_param_prefix}_TCKQK_MAX_NS"                         float     0.2                 ""                                       "nanoseconds"      

   return 1
}

proc ::altera_emif::ip_top::mem::rld2::set_family_specific_defaults {family_enum base_family_enum is_hps} {
   variable m_param_prefix
   
   return 1
}

proc ::altera_emif::ip_top::mem::rld2::add_display_items {tabs} {
   variable m_param_prefix
   
   set mem_params_tab [lindex $tabs 0]
   set mem_io_tab     [lindex $tabs 1]
   set mem_timing_tab [lindex $tabs 2]
   
   set topology_grp [get_string GRP_MEM_TOPOLOGY_NAME]
   set mrs_grp      [get_string GRP_MEM_MRS_NAME]
   
   add_param_to_gui $topology_grp "${m_param_prefix}_DQ_PER_DEVICE" 
   add_param_to_gui $topology_grp "${m_param_prefix}_DQ_WIDTH" 
   add_param_to_gui $topology_grp "${m_param_prefix}_QK_WIDTH" 
   add_param_to_gui $topology_grp "${m_param_prefix}_DK_WIDTH" 
   add_param_to_gui $topology_grp "${m_param_prefix}_CS_WIDTH"
   add_param_to_gui $topology_grp "${m_param_prefix}_DM_EN" 
   add_param_to_gui $topology_grp "${m_param_prefix}_WIDTH_EXPANDED" 
   add_param_to_gui $topology_grp "${m_param_prefix}_ADDR_WIDTH" 
   add_param_to_gui $topology_grp "${m_param_prefix}_BANK_ADDR_WIDTH" 
   
   add_text_to_gui  $mrs_grp "${m_param_prefix}_MR_TXT" "<html><b>Mode Register</b><br>"
   add_param_to_gui $mrs_grp "${m_param_prefix}_BL"
   add_param_to_gui $mrs_grp "${m_param_prefix}_CONFIG_ENUM"
   add_param_to_gui $mrs_grp "${m_param_prefix}_DRIVE_IMPEDENCE_ENUM"
   add_param_to_gui $mrs_grp "${m_param_prefix}_ODT_MODE_ENUM"

   add_text_to_gui  $mem_timing_tab "${m_param_prefix}_id1" "<html>Timing parameters as found in the data sheet of the memory device."
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_SPEEDBIN_ENUM" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_REFRESH_INTERVAL_US" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TCKH_CYC" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TQKH_HCYC" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TAS_NS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TAH_NS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TDS_NS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TDH_NS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TQKQ_MAX_NS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TQKQ_MIN_NS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TCKDK_MAX_NS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TCKDK_MIN_NS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TCKQK_MAX_NS" 
      
   return 1
}

proc ::altera_emif::ip_top::mem::rld2::validate {} {

   set odt_grp [get_string GRP_MEM_ODT_NAME]
   set_display_item_property $odt_grp VISIBLE false

   _validate_memory_parameters 

   _validate_memory_timing_parameters 
   
   _derive_protocol_agnostic_parameters
   
   _derive_mode_register_parameters
   
   return 1
}


proc ::altera_emif::ip_top::mem::rld2::_derive_protocol_agnostic_parameters {} {
   variable m_param_prefix

   set_parameter_value MEM_FORMAT_ENUM             [get_parameter_value "${m_param_prefix}_FORMAT_ENUM"]
   set_parameter_value MEM_DATA_MASK_EN            [get_parameter_value "${m_param_prefix}_DM_EN"]
   set_parameter_value MEM_READ_LATENCY            [get_parameter_value "${m_param_prefix}_TRL"]
   set_parameter_value MEM_WRITE_LATENCY           [get_parameter_value "${m_param_prefix}_TWL"]
   set_parameter_value MEM_BURST_LENGTH            [get_parameter_value "${m_param_prefix}_BL"]
   set_parameter_value MEM_TTL_DATA_WIDTH          [get_parameter_value "${m_param_prefix}_DQ_WIDTH"]
   set_parameter_value MEM_TTL_NUM_OF_READ_GROUPS  [get_parameter_value "${m_param_prefix}_QK_WIDTH"]
   set_parameter_value MEM_TTL_NUM_OF_WRITE_GROUPS [get_parameter_value "${m_param_prefix}_DK_WIDTH"]
   set_parameter_value MEM_NUM_OF_LOGICAL_RANKS    [get_parameter_value "${m_param_prefix}_DEVICE_DEPTH"]

   return 1
}

proc ::altera_emif::ip_top::mem::rld2::_validate_memory_parameters {} {

   variable m_param_prefix
   
   set dm_en              [get_parameter_value "${m_param_prefix}_DM_EN"]
   set width_expanded     [get_parameter_value "${m_param_prefix}_WIDTH_EXPANDED"]
   set dq_width_per_dev   [get_parameter_value "${m_param_prefix}_DQ_PER_DEVICE"]
   set bl                 [get_parameter_value "${m_param_prefix}_BL"]
   set rate_enum          [get_parameter_value "PHY_RLD2_RATE_ENUM"]
   set width              [expr {$width_expanded ? 2 : 1}]
   set depth              1

   if {$bl == 2 && [enum_same $rate_enum RATE_HALF]} {
      post_ipgen_e_msg MSG_RLD2_BL_NOT_SUPPORTED_FOR_RATE [list $bl [enum_data $rate_enum UI_NAME]]
   }

   set dl_enum [get_parameter_value "${m_param_prefix}_CONFIG_ENUM"]
   set wl      [enum_data $dl_enum TWL]
   set rl      [enum_data $dl_enum TRL]
   set rc      [enum_data $dl_enum TRC]
   
   if {$dq_width_per_dev == 9} {
      set dq_per_rd_group 9
      set dq_per_wr_group 9
   } elseif {$dq_width_per_dev == 18} {
      set dq_per_rd_group 9
      set dq_per_wr_group 18
   } else {
      set dq_per_rd_group 18
      set dq_per_wr_group 18
   }
   
   set dq_width [expr {$dq_width_per_dev * $width}]
   set qk_width [expr {$dq_width / $dq_per_rd_group }]
   set dk_width [expr {$dq_width / $dq_per_wr_group }]
   set dm_width [expr {$dm_en ? $width : 0}]
   
   set_parameter_value "${m_param_prefix}_DEVICE_WIDTH" $width
   set_parameter_value "${m_param_prefix}_DEVICE_DEPTH" $depth
   set_parameter_value "${m_param_prefix}_CS_WIDTH" $depth
   set_parameter_value "${m_param_prefix}_DQ_WIDTH" $dq_width
   set_parameter_value "${m_param_prefix}_QK_WIDTH" $qk_width
   set_parameter_value "${m_param_prefix}_DK_WIDTH" $dk_width
   set_parameter_value "${m_param_prefix}_DM_WIDTH" $dm_width
   set_parameter_value "${m_param_prefix}_DQ_PER_RD_GROUP" $dq_per_rd_group
   set_parameter_value "${m_param_prefix}_DQ_PER_WR_GROUP" $dq_per_wr_group
   set_parameter_value "${m_param_prefix}_TWL" $wl
   set_parameter_value "${m_param_prefix}_TRL" $rl
   set_parameter_value "${m_param_prefix}_TRC" $rc

   set_display_item_property [get_string DDR3_RDIMM_TXT_NAME]         VISIBLE false
   set_display_item_property [get_string DDR3_LRDIMM_TXT_NAME]        VISIBLE false
   set_display_item_property [get_string DDR4_RDIMM_TXT_NAME]         VISIBLE false
   set_display_item_property [get_string DDR4_LRDIMM_TXT_NAME]        VISIBLE false

   return 1
}


proc ::altera_emif::ip_top::mem::rld2::_validate_memory_timing_parameters {} {
   
   variable m_param_prefix
   
   set mem_clk_freq       [get_parameter_value PHY_RLD2_MEM_CLK_FREQ_MHZ]
   set speedbin_enum      [get_parameter_value "${m_param_prefix}_SPEEDBIN_ENUM"]
   set speedbin_ui_name   [enum_data $speedbin_enum UI_NAME]
   set mem_fmax           [enum_data $speedbin_enum FMAX_MHZ]
   set mem_fmin           [enum_data $speedbin_enum FMIN_MHZ]

   if {$mem_clk_freq < $mem_fmin || $mem_clk_freq > $mem_fmax} {
      post_ipgen_e_msg MSG_RLD2_FREQ_OUT_OF_RANGE [list $mem_fmin $mem_fmax $speedbin_ui_name]
   }
   
   return 1
}


proc ::altera_emif::ip_top::mem::rld2::_derive_mode_register_parameters {} {

   variable m_param_prefix
   
   set bl                        [get_parameter_value "${m_param_prefix}_BL"]
   set mrs_configuration_enum    [get_parameter_value "${m_param_prefix}_CONFIG_ENUM"]
   set drive_impedence_enum      [get_parameter_value  "${m_param_prefix}_DRIVE_IMPEDENCE_ENUM"]
   set odt_mode_enum             [get_parameter_value "${m_param_prefix}_ODT_MODE_ENUM"]
       
   set mr 0
   set mr [set_bits $mr 0  3   [enum_data $mrs_configuration_enum MRS]]                       
   set mr [set_bits $mr 3  2   [expr {int([log2 $bl]) - 1}]]                                  
   set mr [set_bits $mr 5  1   0]                                                             
   set mr [set_bits $mr 7  1   1]                                                             
   set mr [set_bits $mr 8  1   [enum_data $drive_impedence_enum MRS]]                         
   set mr [set_bits $mr 9  1   [enum_data $odt_mode_enum MRS]]                                

   set_parameter_value "${m_param_prefix}_MR" $mr
}

proc ::altera_emif::ip_top::mem::rld2::_init {} {
}

::altera_emif::ip_top::mem::rld2::_init
