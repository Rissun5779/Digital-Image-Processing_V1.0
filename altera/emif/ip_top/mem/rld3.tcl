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


package provide altera_emif::ip_top::mem::rld3 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::math
package require altera_emif::util::enums
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_top::mem::rld3:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::math::*
   
   
   variable m_param_prefix "MEM_RLD3"
}


proc ::altera_emif::ip_top::mem::rld3::create_parameters {is_top_level_component} {
   variable m_param_prefix

   add_user_param     "${m_param_prefix}_WIDTH_EXPANDED"          boolean   false                ""
   add_user_param     "${m_param_prefix}_DEPTH_EXPANDED"          boolean   false                ""
   add_user_param     "${m_param_prefix}_DQ_PER_DEVICE"           integer   36                   [list 18 36]
   add_user_param     "${m_param_prefix}_ADDR_WIDTH"              integer   20                   [list 18 19 20 21]
   add_user_param     "${m_param_prefix}_BANK_ADDR_WIDTH"         integer   4                    [list 4]
   add_user_param     "${m_param_prefix}_DM_EN"                   boolean   true                 ""
   add_user_param     "${m_param_prefix}_BL"                      integer   2                    [list 2 4 8]
   add_user_param     "${m_param_prefix}_DATA_LATENCY_MODE_ENUM"  string    RLD3_DL_RL16_WL17    [enum_dropdown_entries RLD3_DL]
   add_user_param     "${m_param_prefix}_T_RC_MODE_ENUM"          string    RLD3_TRC_9           [enum_dropdown_entries RLD3_TRC]
   add_user_param     "${m_param_prefix}_OUTPUT_DRIVE_MODE_ENUM"  string    RLD3_OUTPUT_DRIVE_40 [enum_dropdown_entries RLD3_OUTPUT_DRIVE]
   add_user_param     "${m_param_prefix}_ODT_MODE_ENUM"           string    RLD3_ODT_40          [enum_dropdown_entries RLD3_ODT]
   add_user_param     "${m_param_prefix}_AREF_PROTOCOL_ENUM"      string    RLD3_AREF_BAC        [enum_dropdown_entries RLD3_AREF]
   add_user_param     "${m_param_prefix}_WRITE_PROTOCOL_ENUM"     string    RLD3_WRITE_1BANK     [enum_dropdown_entries RLD3_WRITE]

   add_derived_param  "${m_param_prefix}_FORMAT_ENUM"      string     MEM_FORMAT_DISCRETE  false
   add_derived_param  "${m_param_prefix}_DEVICE_WIDTH"     integer    1                    false
   add_derived_param  "${m_param_prefix}_DEVICE_DEPTH"     integer    1                    false
   add_derived_param  "${m_param_prefix}_DQ_WIDTH"         integer    36                   true
   add_derived_param  "${m_param_prefix}_DQ_PER_RD_GROUP"  integer    9                    false
   add_derived_param  "${m_param_prefix}_DQ_PER_WR_GROUP"  integer    18                   false
   add_derived_param  "${m_param_prefix}_QK_WIDTH"         integer    4                    true
   add_derived_param  "${m_param_prefix}_DK_WIDTH"         integer    2                    true
   add_derived_param  "${m_param_prefix}_DM_WIDTH"         integer    2                    false
   add_derived_param  "${m_param_prefix}_CS_WIDTH"         integer    1                    true
   
   add_derived_param  "${m_param_prefix}_MR0"                     integer    0         false
   add_derived_param  "${m_param_prefix}_MR1"                     integer    0         false
   add_derived_param  "${m_param_prefix}_MR2"                     integer    0         false

   add_user_param     "${m_param_prefix}_SPEEDBIN_ENUM"                        string    RLD3_SPEEDBIN_093E  [enum_dropdown_entries RLD3_SPEEDBIN]    ""				""
   add_user_param     "${m_param_prefix}_TDS_PS"                               integer   -30                 {-100:5000}                              "picoseconds"		""
   add_user_param     "${m_param_prefix}_TDS_AC_MV"        					   integer   150                 {150 120}                                ""				"mV"
   add_user_param     "${m_param_prefix}_TDH_PS"                               integer   5                   {0:5000}                                 "picoseconds"		""
   add_user_param     "${m_param_prefix}_TDH_DC_MV"        					   integer   100                 {100}                                    ""				"mV"   
   add_user_param     "${m_param_prefix}_TQKQ_MAX_PS"                          integer   75                  {-5000:5000}                             "picoseconds" 	""     
   add_user_param     "${m_param_prefix}_TQH_CYC"                              float     0.38                {-1:1}                                   "Cycles" 			""     
   add_user_param     "${m_param_prefix}_TCKDK_MAX_CYC"                        float     0.27                {-1:1}                                   "Cycles"			""
   add_user_param     "${m_param_prefix}_TCKDK_MIN_CYC"                        float    -0.27                {-1:1}                                   "Cycles"			""
   add_user_param     "${m_param_prefix}_TCKQK_MAX_PS"                         integer   135                 {-5000:5000}                             "picoseconds"		""      
   add_user_param     "${m_param_prefix}_TIS_PS"                               integer   85                  {0:5000}                                 "picoseconds"		""   
   add_user_param     "${m_param_prefix}_TIS_AC_MV"        					   integer   150                 {150 120}                                ""  				"mV" 
   add_user_param     "${m_param_prefix}_TIH_PS"                               integer   65                  {0:5000}                                 "picoseconds" 	""        
   add_user_param     "${m_param_prefix}_TIH_DC_MV"        					   integer   100                 {100}                                    "" 				"mV"  

   return 1
}

proc ::altera_emif::ip_top::mem::rld3::set_family_specific_defaults {family_enum base_family_enum is_hps} {
   variable m_param_prefix
   
   return 1
}

proc ::altera_emif::ip_top::mem::rld3::add_display_items {tabs} {
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
   add_param_to_gui $topology_grp "${m_param_prefix}_DEPTH_EXPANDED" 
   add_param_to_gui $topology_grp "${m_param_prefix}_ADDR_WIDTH" 
   add_param_to_gui $topology_grp "${m_param_prefix}_BANK_ADDR_WIDTH" 
   
   add_text_to_gui  $mrs_grp "${m_param_prefix}_MR0_TXT" "<html><b>Mode Register 0</b><br>"
   add_param_to_gui $mrs_grp "${m_param_prefix}_T_RC_MODE_ENUM" 
   add_param_to_gui $mrs_grp "${m_param_prefix}_DATA_LATENCY_MODE_ENUM"
   add_text_to_gui  $mrs_grp "${m_param_prefix}_MR1_TXT" "<html><b>Mode Register 1</b><br>"
   add_param_to_gui $mrs_grp "${m_param_prefix}_OUTPUT_DRIVE_MODE_ENUM" 
   add_param_to_gui $mrs_grp "${m_param_prefix}_ODT_MODE_ENUM" 
   add_param_to_gui $mrs_grp "${m_param_prefix}_AREF_PROTOCOL_ENUM" 
   add_param_to_gui $mrs_grp "${m_param_prefix}_BL" 
   add_text_to_gui  $mrs_grp "${m_param_prefix}_MR2_TXT" "<html><b>Mode Register 2</b><br>"
   add_param_to_gui $mrs_grp "${m_param_prefix}_WRITE_PROTOCOL_ENUM" 

   add_text_to_gui  $mem_timing_tab "${m_param_prefix}_id1" "<html>Timing parameters as found in the data sheet of the memory device."
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_SPEEDBIN_ENUM" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TDS_PS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TDS_AC_MV" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TDH_PS"  
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TDH_DC_MV"  
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TQKQ_MAX_PS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TQH_CYC" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TCKDK_MAX_CYC" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TCKDK_MIN_CYC" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TCKQK_MAX_PS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TIS_PS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TIS_AC_MV" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TIH_PS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TIH_DC_MV" 
      
   return 1
}

proc ::altera_emif::ip_top::mem::rld3::validate {} {

   set odt_grp [get_string GRP_MEM_ODT_NAME]
   set_display_item_property $odt_grp VISIBLE false

   _validate_memory_parameters 

   _validate_memory_timing_parameters 
   
   _derive_protocol_agnostic_parameters
   
   _derive_mode_register_parameters
   
   return 1
}


proc ::altera_emif::ip_top::mem::rld3::_derive_protocol_agnostic_parameters {} {
   variable m_param_prefix
   
   set dl_enum [get_parameter_value "${m_param_prefix}_DATA_LATENCY_MODE_ENUM"]
   set wl      [enum_data $dl_enum WL]
   set rl      [enum_data $dl_enum RL]

   set_parameter_value MEM_FORMAT_ENUM              [get_parameter_value "${m_param_prefix}_FORMAT_ENUM"]
   set_parameter_value MEM_DATA_MASK_EN             [get_parameter_value "${m_param_prefix}_DM_EN"]
   set_parameter_value MEM_TTL_DATA_WIDTH           [get_parameter_value "${m_param_prefix}_DQ_WIDTH"]
   set_parameter_value MEM_TTL_NUM_OF_READ_GROUPS   [get_parameter_value "${m_param_prefix}_QK_WIDTH"]
   set_parameter_value MEM_TTL_NUM_OF_WRITE_GROUPS  [get_parameter_value "${m_param_prefix}_DK_WIDTH"]
   set_parameter_value MEM_READ_LATENCY             $rl
   set_parameter_value MEM_WRITE_LATENCY            $wl
   set_parameter_value MEM_BURST_LENGTH             [get_parameter_value "${m_param_prefix}_BL"]
   set_parameter_value MEM_NUM_OF_LOGICAL_RANKS     [get_parameter_value "${m_param_prefix}_DEVICE_DEPTH"]

   return 1
}

proc ::altera_emif::ip_top::mem::rld3::_validate_memory_parameters {} {

   variable m_param_prefix
   
   set dm_en              [get_parameter_value "${m_param_prefix}_DM_EN"]
   set width_expanded     [get_parameter_value "${m_param_prefix}_WIDTH_EXPANDED"]
   set depth_expanded     [get_parameter_value "${m_param_prefix}_DEPTH_EXPANDED"]
   set dq_width_per_dev   [get_parameter_value "${m_param_prefix}_DQ_PER_DEVICE"]
   set width              [expr {$width_expanded ? 2 : 1}]
   set depth              [expr {$depth_expanded ? 2 : 1}]
   
   if {$dq_width_per_dev == 18} {
      set dq_per_rd_group 9
      set dq_per_wr_group 9
   } else {
      set dq_per_rd_group 9
      set dq_per_wr_group 18
   }
   
   set dq_width [expr {$dq_width_per_dev * $width}]
   set qk_width [expr {$dq_width / $dq_per_rd_group }]
   set dk_width [expr {$dq_width / $dq_per_wr_group }]
   set dm_width [expr {$dm_en ? $dk_width : 0}]
   
   set_parameter_value "${m_param_prefix}_DEVICE_WIDTH" $width
   set_parameter_value "${m_param_prefix}_DEVICE_DEPTH" $depth
   set_parameter_value "${m_param_prefix}_CS_WIDTH" $depth
   set_parameter_value "${m_param_prefix}_DQ_WIDTH" $dq_width
   set_parameter_value "${m_param_prefix}_QK_WIDTH" $qk_width
   set_parameter_value "${m_param_prefix}_DK_WIDTH" $dk_width
   set_parameter_value "${m_param_prefix}_DM_WIDTH" $dm_width
   set_parameter_value "${m_param_prefix}_DQ_PER_RD_GROUP" $dq_per_rd_group
   set_parameter_value "${m_param_prefix}_DQ_PER_WR_GROUP" $dq_per_wr_group

   set_display_item_property [get_string DDR3_RDIMM_TXT_NAME]         VISIBLE false
   set_display_item_property [get_string DDR3_LRDIMM_TXT_NAME]        VISIBLE false
   set_display_item_property [get_string DDR4_RDIMM_TXT_NAME]         VISIBLE false
   set_display_item_property [get_string DDR4_LRDIMM_TXT_NAME]        VISIBLE false

   return 1
}


proc ::altera_emif::ip_top::mem::rld3::_validate_memory_timing_parameters {} {
   
   variable m_param_prefix
   
   return 1
}


proc ::altera_emif::ip_top::mem::rld3::_derive_mode_register_parameters {} {

   variable m_param_prefix
      
   set dq_width_per_dev   [get_parameter_value "${m_param_prefix}_DQ_PER_DEVICE"]
   if {$dq_width_per_dev == 36} {
      set_parameter_property "${m_param_prefix}_BL"          ALLOWED_RANGES [list 2 4]
   } else {
      set_parameter_property "${m_param_prefix}_BL"          ALLOWED_RANGES [list 2 4 8]
   }
   
   set bl                        [get_parameter_value "${m_param_prefix}_BL"]
   set dl_mode_enum              [get_parameter_value "${m_param_prefix}_DATA_LATENCY_MODE_ENUM"]
   set trc_mode_enum             [get_parameter_value "${m_param_prefix}_T_RC_MODE_ENUM"]
   set output_drive_mode_enum    [get_parameter_value "${m_param_prefix}_OUTPUT_DRIVE_MODE_ENUM"]
   set odt_mode_enum             [get_parameter_value "${m_param_prefix}_ODT_MODE_ENUM"]
   set aref_protocol_enum        [get_parameter_value "${m_param_prefix}_AREF_PROTOCOL_ENUM"]
   set write_protocol_enum       [get_parameter_value "${m_param_prefix}_WRITE_PROTOCOL_ENUM"]

   set mr0 0
   set mr0 [set_bits $mr0 0  4   [enum_data $trc_mode_enum MRS]]                       
   set mr0 [set_bits $mr0 4  4   [enum_data $dl_mode_enum MRS]]                        
   set mr0 [set_bits $mr0 8  1   0]                                                    
   set mr0 [set_bits $mr0 9  1   0]                                                    

   set mr1 0                 
   set mr1 [set_bits $mr1 0  2   [enum_data $output_drive_mode_enum MRS]]              
   set mr1 [set_bits $mr1 2  3   [enum_data $odt_mode_enum MRS]]                       
   set mr1 [set_bits $mr1 5  1   0]                                                    
   set mr1 [set_bits $mr1 6  1   0]                                                    
   set mr1 [set_bits $mr1 7  1   0]                                                    
   set mr1 [set_bits $mr1 8  1   [enum_data $aref_protocol_enum MRS]]                  
   set mr1 [set_bits $mr1 9  2   [expr {int([log2 $bl]) - 1}]]                         
   set mr1 [set_bits $mr1 18 2   1]                                                    

   set mr2 0
   set mr2 [set_bits $mr2 3  2   [enum_data $write_protocol_enum MRS]]                 
   set mr2 [set_bits $mr2 18 2   2]                                                    
   
   set_parameter_value "${m_param_prefix}_MR0" $mr0
   set_parameter_value "${m_param_prefix}_MR1" $mr1
   set_parameter_value "${m_param_prefix}_MR2" $mr2
}

proc ::altera_emif::ip_top::mem::rld3::_init {} {
}

::altera_emif::ip_top::mem::rld3::_init
