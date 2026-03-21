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


package provide altera_emif::ip_top::mem::qdr4 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::math
package require altera_emif::util::enums
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_top::mem::qdr4:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::math::*
   
   
   variable m_param_prefix "MEM_QDR4"
}


proc ::altera_emif::ip_top::mem::qdr4::create_parameters {is_top_level_component} {
   variable m_param_prefix

   add_user_param     "${m_param_prefix}_WIDTH_EXPANDED"                boolean   false                     ""
   add_user_param     "${m_param_prefix}_DQ_PER_PORT_PER_DEVICE"        integer   36                        [list 18 36]
   add_user_param     "${m_param_prefix}_ADDR_WIDTH"                    integer   21                        [list 21 22 23 24 25]
                                                                                                            
   add_user_param     "${m_param_prefix}_CK_ODT_MODE_ENUM"              string    QDR4_ODT_25_PCT           [enum_dropdown_entries QDR4_ODT] 
   add_user_param     "${m_param_prefix}_AC_ODT_MODE_ENUM"              string    QDR4_ODT_25_PCT           [enum_dropdown_entries QDR4_ODT] 
   add_user_param     "${m_param_prefix}_DATA_ODT_MODE_ENUM"            string    QDR4_ODT_25_PCT           [enum_dropdown_entries QDR4_ODT] 
   
   add_user_param     "${m_param_prefix}_PU_OUTPUT_DRIVE_MODE_ENUM"     string    QDR4_OUTPUT_DRIVE_25_PCT  [enum_dropdown_entries QDR4_OUTPUT_DRIVE]
   add_user_param     "${m_param_prefix}_PD_OUTPUT_DRIVE_MODE_ENUM"     string    QDR4_OUTPUT_DRIVE_25_PCT  [enum_dropdown_entries QDR4_OUTPUT_DRIVE]
   
   add_user_param     "${m_param_prefix}_DATA_INV_ENA"                  boolean   true                      ""
   add_user_param     "${m_param_prefix}_ADDR_INV_ENA"                  boolean   false                     ""

   add_derived_param  "${m_param_prefix}_FORMAT_ENUM"           string     MEM_FORMAT_DISCRETE  false
   add_derived_param  "${m_param_prefix}_DEVICE_WIDTH"          integer    1                    false
   add_derived_param  "${m_param_prefix}_DEVICE_DEPTH"          integer    1                    false
   add_derived_param  "${m_param_prefix}_DQ_PER_RD_GROUP"       integer    18                   false
   add_derived_param  "${m_param_prefix}_DQ_PER_WR_GROUP"       integer    18                   false
   add_derived_param  "${m_param_prefix}_DQ_WIDTH"              integer    72                   false
   add_derived_param  "${m_param_prefix}_QK_WIDTH"              integer    4                    false
   add_derived_param  "${m_param_prefix}_DK_WIDTH"              integer    4                    false
   add_derived_param  "${m_param_prefix}_DINV_WIDTH"            integer    4                    false
   add_derived_param  "${m_param_prefix}_USE_ADDR_PARITY"       boolean    false                false
   add_derived_param  "${m_param_prefix}_DQ_PER_PORT_WIDTH"     integer    36                   true
   add_derived_param  "${m_param_prefix}_QK_PER_PORT_WIDTH"     integer    2                    true
   add_derived_param  "${m_param_prefix}_DK_PER_PORT_WIDTH"     integer    2                    true
   add_derived_param  "${m_param_prefix}_DINV_PER_PORT_WIDTH"   integer    2                    true
   
   add_derived_param  "${m_param_prefix}_BL"               integer    2                    false
   add_derived_param  "${m_param_prefix}_TRL_CYC"          integer    8                    false
   add_derived_param  "${m_param_prefix}_TWL_CYC"          integer    5                    false
   
   add_derived_param  "${m_param_prefix}_CR0"                     integer    0         false
   add_derived_param  "${m_param_prefix}_CR1"                     integer    0         false
   add_derived_param  "${m_param_prefix}_CR2"                     integer    0         false

   add_user_param     "${m_param_prefix}_SPEEDBIN_ENUM"                        string    QDR4_SPEEDBIN_2133  [enum_dropdown_entries QDR4_SPEEDBIN]    ""
   add_user_param     "${m_param_prefix}_TISH_PS"                              integer   150                 {0:5000}                              "picoseconds"
   add_user_param     "${m_param_prefix}_TQKQ_MAX_PS"                          integer   75                  {-5000:5000}                             "picoseconds"      
   add_user_param     "${m_param_prefix}_TQH_CYC"                              float     0.40                {-1:1}                                   "Cycles"      
   add_user_param     "${m_param_prefix}_TCKDK_MAX_PS"                         integer   150                 {-5000:5000}                             "picoseconds"
   add_user_param     "${m_param_prefix}_TCKDK_MIN_PS"                         integer   -150                {-5000:5000}                             "picoseconds"
   add_user_param     "${m_param_prefix}_TCKQK_MAX_PS"                         integer   225                 {-5000:5000}                             "picoseconds"      
   add_user_param     "${m_param_prefix}_TASH_PS"                              integer   170                 {0:5000}                                 "picoseconds"      
   add_user_param     "${m_param_prefix}_TCSH_PS"                              integer   170                 {0:5000}                                 "picoseconds"      
   
   return 1
}

proc ::altera_emif::ip_top::mem::qdr4::set_family_specific_defaults {family_enum base_family_enum is_hps} {
   variable m_param_prefix
   
   return 1
}

proc ::altera_emif::ip_top::mem::qdr4::add_display_items {tabs} {
   variable m_param_prefix
   
   set mem_params_tab [lindex $tabs 0]
   set mem_io_tab     [lindex $tabs 1]
   set mem_timing_tab [lindex $tabs 2]
   
   set topology_grp [get_string GRP_MEM_TOPOLOGY_NAME]
   set crs_grp      [get_string GRP_MEM_CRS_NAME]
   
   add_param_to_gui $topology_grp "${m_param_prefix}_DQ_PER_PORT_PER_DEVICE" 
   add_param_to_gui $topology_grp "${m_param_prefix}_DQ_PER_PORT_WIDTH" 
   add_param_to_gui $topology_grp "${m_param_prefix}_QK_PER_PORT_WIDTH" 
   add_param_to_gui $topology_grp "${m_param_prefix}_DK_PER_PORT_WIDTH" 
   add_param_to_gui $topology_grp "${m_param_prefix}_DINV_PER_PORT_WIDTH" 
   add_param_to_gui $topology_grp "${m_param_prefix}_WIDTH_EXPANDED" 
   add_param_to_gui $topology_grp "${m_param_prefix}_ADDR_WIDTH" 
   
   add_text_to_gui  $crs_grp "${m_param_prefix}_OPT_CTRL_TXT" "<html><b>Option Control</b><br>"
   add_param_to_gui $crs_grp "${m_param_prefix}_ADDR_INV_ENA" 
   add_param_to_gui $crs_grp "${m_param_prefix}_DATA_INV_ENA" 
   
   add_text_to_gui  $crs_grp "${m_param_prefix}_TERM_CTRL_TXT" "<html><b>Termination Control</b><br>"
   add_param_to_gui $crs_grp "${m_param_prefix}_CK_ODT_MODE_ENUM" 
   add_param_to_gui $crs_grp "${m_param_prefix}_AC_ODT_MODE_ENUM" 
   add_param_to_gui $crs_grp "${m_param_prefix}_DATA_ODT_MODE_ENUM" 
   
   add_text_to_gui  $crs_grp "${m_param_prefix}_IMP_CTRL_TXT" "<html><b>Impedance Control</b><br>"
   add_param_to_gui $crs_grp "${m_param_prefix}_PU_OUTPUT_DRIVE_MODE_ENUM" 
   add_param_to_gui $crs_grp "${m_param_prefix}_PD_OUTPUT_DRIVE_MODE_ENUM" 

   add_text_to_gui  $mem_timing_tab "${m_param_prefix}_id1" "<html>Timing parameters as found in the data sheet of the memory device."
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_SPEEDBIN_ENUM"
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TISH_PS"
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TQKQ_MAX_PS"
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TQH_CYC"
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TCKDK_MAX_PS"
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TCKDK_MIN_PS"
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TCKQK_MAX_PS"
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TASH_PS"
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TCSH_PS"
      
   return 1
}

proc ::altera_emif::ip_top::mem::qdr4::validate {} {

   set odt_grp [get_string GRP_MEM_ODT_NAME]
   set_display_item_property $odt_grp VISIBLE false

   _validate_memory_parameters 

   _validate_memory_timing_parameters 
   
   _derive_protocol_agnostic_parameters
   
   _derive_config_register_parameters
   
   return 1
}


proc ::altera_emif::ip_top::mem::qdr4::_derive_protocol_agnostic_parameters {} {
   variable m_param_prefix

   set_parameter_value MEM_FORMAT_ENUM             [get_parameter_value "${m_param_prefix}_FORMAT_ENUM"]
   set_parameter_value MEM_DATA_MASK_EN            false
   set_parameter_value MEM_TTL_DATA_WIDTH          [get_parameter_value "${m_param_prefix}_DQ_WIDTH"]
   set_parameter_value MEM_TTL_NUM_OF_READ_GROUPS  [get_parameter_value "${m_param_prefix}_QK_WIDTH"]
   set_parameter_value MEM_TTL_NUM_OF_WRITE_GROUPS [get_parameter_value "${m_param_prefix}_DK_WIDTH"]
   set_parameter_value MEM_READ_LATENCY            [get_parameter_value "${m_param_prefix}_TRL_CYC"]
   set_parameter_value MEM_WRITE_LATENCY           [get_parameter_value "${m_param_prefix}_TWL_CYC"]
   set_parameter_value MEM_BURST_LENGTH            [get_parameter_value "${m_param_prefix}_BL"]
   set_parameter_value MEM_NUM_OF_LOGICAL_RANKS    [get_parameter_value "${m_param_prefix}_DEVICE_DEPTH"]

   return 1
}

proc ::altera_emif::ip_top::mem::qdr4::_validate_memory_parameters {} {

   variable m_param_prefix
   
   set dinv_ena               [get_parameter_value "${m_param_prefix}_DATA_INV_ENA"]
   set width_expanded         [get_parameter_value "${m_param_prefix}_WIDTH_EXPANDED"]
   set dq_per_port_per_device [get_parameter_value "${m_param_prefix}_DQ_PER_PORT_PER_DEVICE"]
   set width                  [expr {$width_expanded ? 2 : 1}]
   
   if {$dq_per_port_per_device == 18} {
      set dq_per_rd_group 9
      set dq_per_wr_group 9
   } elseif {$dq_per_port_per_device == 36} {
      set dq_per_rd_group 18
      set dq_per_wr_group 18
   } else {
      emif_ie "Unhandled dq_per_port_per_device value $dq_per_port_per_device"
   }
   
   set dq_per_port_width   [expr {$dq_per_port_per_device * $width}]
   set qk_per_port_width   [expr {$dq_per_port_width / $dq_per_rd_group}]
   set dk_per_port_width   [expr {$dq_per_port_width / $dq_per_wr_group}]
   set dinv_per_port_width [expr {$dinv_ena ? ($dq_per_port_width / $dq_per_wr_group) : 0}]
   
   set dq_width            [expr {$dq_per_port_width * 2}]
   set qk_width            [expr {$qk_per_port_width * 2}]
   set dk_width            [expr {$dk_per_port_width * 2}]
   set dinv_width          [expr {$dinv_per_port_width * 2}]
   
   set_parameter_value "${m_param_prefix}_DEVICE_WIDTH"         $width
   set_parameter_value "${m_param_prefix}_DQ_WIDTH"             $dq_width
   set_parameter_value "${m_param_prefix}_QK_WIDTH"             $qk_width
   set_parameter_value "${m_param_prefix}_DK_WIDTH"             $dk_width
   set_parameter_value "${m_param_prefix}_DINV_WIDTH"           $dinv_width
   set_parameter_value "${m_param_prefix}_DQ_PER_PORT_WIDTH"    $dq_per_port_width
   set_parameter_value "${m_param_prefix}_QK_PER_PORT_WIDTH"    $qk_per_port_width
   set_parameter_value "${m_param_prefix}_DK_PER_PORT_WIDTH"    $dk_per_port_width
   set_parameter_value "${m_param_prefix}_DINV_PER_PORT_WIDTH"  $dinv_per_port_width
   set_parameter_value "${m_param_prefix}_DQ_PER_RD_GROUP"      $dq_per_rd_group
   set_parameter_value "${m_param_prefix}_DQ_PER_WR_GROUP"      $dq_per_wr_group

   set_display_item_property [get_string DDR3_RDIMM_TXT_NAME]         VISIBLE false
   set_display_item_property [get_string DDR3_LRDIMM_TXT_NAME]        VISIBLE false
   set_display_item_property [get_string DDR4_RDIMM_TXT_NAME]         VISIBLE false
   set_display_item_property [get_string DDR4_LRDIMM_TXT_NAME]        VISIBLE false

   return 1
}


proc ::altera_emif::ip_top::mem::qdr4::_validate_memory_timing_parameters {} {
   
   variable m_param_prefix
   
   return 1
}


proc ::altera_emif::ip_top::mem::qdr4::_derive_config_register_parameters {} {

   variable m_param_prefix
   
   set ck_odt_mode_enum             [get_parameter_value "${m_param_prefix}_CK_ODT_MODE_ENUM"]
   set ac_odt_mode_enum             [get_parameter_value "${m_param_prefix}_AC_ODT_MODE_ENUM"]
   set data_odt_mode_enum           [get_parameter_value "${m_param_prefix}_DATA_ODT_MODE_ENUM"]
   set pu_output_drive_mode_enum    [get_parameter_value "${m_param_prefix}_PU_OUTPUT_DRIVE_MODE_ENUM"]
   set pd_output_drive_mode_enum    [get_parameter_value "${m_param_prefix}_PD_OUTPUT_DRIVE_MODE_ENUM"]
   
   set use_addr_parity              [get_parameter_value "${m_param_prefix}_USE_ADDR_PARITY"]
   set addr_inv_ena                 [get_parameter_value "${m_param_prefix}_ADDR_INV_ENA"]
   set data_inv_ena                 [get_parameter_value "${m_param_prefix}_DATA_INV_ENA"]
   
   set ac_io_std_enum               [get_parameter_value "PHY_QDR4_AC_IO_STD_ENUM"]
   
   set is_pod [expr { ($ac_io_std_enum eq "IO_STD_POD_12") ? 1 : 0 }]

   set cr0 0
   set cr0 [set_bits $cr0 0  3   [enum_data $ck_odt_mode_enum MRS]]                    
   set cr0 [set_bits $cr0 3  3   [enum_data $ac_odt_mode_enum MRS]]                    
   set cr0 [set_bits $cr0 6  1   1]                                                    
   set cr0 [set_bits $cr0 7  1   1]                                                    
   set cr0 [set_bits $cr0 8  3   0]                                                    

   set cr1 0                 
   set cr1 [set_bits $cr1 0  3   [enum_data $data_odt_mode_enum MRS]]                  
   set cr1 [set_bits $cr1 4  2   [enum_data $pu_output_drive_mode_enum MRS]]           
   set cr1 [set_bits $cr1 6  2   [enum_data $pd_output_drive_mode_enum MRS]]           
   set cr1 [set_bits $cr1 8  3   1]                                                    

   set cr2 0
   set cr2 [set_bits $cr2 0  2   3]                                                    
   set cr2 [set_bits $cr2 2  1   $is_pod]                                              
   set cr2 [set_bits $cr2 3  1   0]                                                    
   set cr2 [set_bits $cr2 4  1   [expr {$use_addr_parity ? 1 : 0}]]                    
   set cr2 [set_bits $cr2 5  1   [expr {$addr_inv_ena ? 1 : 0}]]                       
   set cr2 [set_bits $cr2 6  1   [expr {$data_inv_ena ? 1 : 0}]]                       
   set cr2 [set_bits $cr2 7  1   0]                                                    
   set cr2 [set_bits $cr2 8  3   2]                                                    
   
   set_parameter_value "${m_param_prefix}_CR0" $cr0
   set_parameter_value "${m_param_prefix}_CR1" $cr1
   set_parameter_value "${m_param_prefix}_CR2" $cr2
}

proc ::altera_emif::ip_top::mem::qdr4::_init {} {
}

::altera_emif::ip_top::mem::qdr4::_init
