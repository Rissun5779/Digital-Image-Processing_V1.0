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


package provide altera_emif::ip_top::mem::qdr2 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::math
package require altera_emif::util::enums
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_top::mem::qdr2:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::math::*
   
   
   variable m_param_prefix "MEM_QDR2"
}


proc ::altera_emif::ip_top::mem::qdr2::create_parameters {is_top_level_component} {
   variable m_param_prefix

   add_user_param     "${m_param_prefix}_WIDTH_EXPANDED"       boolean   false                  ""
   add_user_param     "${m_param_prefix}_DATA_PER_DEVICE"      integer   36                     [list 9 18 36]
   add_user_param     "${m_param_prefix}_ADDR_WIDTH"           integer   19                     [list 16 17 18 19 20 21 22 23]
   add_user_param     "${m_param_prefix}_BWS_EN"               boolean   true                   ""
   add_user_param     "${m_param_prefix}_BL"                   integer   4                      [list 2 4]

   add_derived_param  "${m_param_prefix}_FORMAT_ENUM"          string     MEM_FORMAT_DISCRETE   false
   add_derived_param  "${m_param_prefix}_DEVICE_WIDTH"         integer    1                     false
   add_derived_param  "${m_param_prefix}_DATA_WIDTH"           integer    36                    true
   add_derived_param  "${m_param_prefix}_BWS_N_WIDTH"          integer    4                     true 
   add_derived_param  "${m_param_prefix}_BWS_N_PER_DEVICE"     integer    4                     false
   add_derived_param  "${m_param_prefix}_CQ_WIDTH"             integer    1                     true  
   add_derived_param  "${m_param_prefix}_K_WIDTH"              integer    1                     true
   add_derived_param  "${m_param_prefix}_TWL_CYC"              integer    1                     true       "Cycles"

   add_user_param     "${m_param_prefix}_SPEEDBIN_ENUM"        string    QDR2_SPEEDBIN_633      [enum_dropdown_entries QDR2_SPEEDBIN]    ""
   add_user_param     "${m_param_prefix}_TRL_CYC"              float     2.5                    [list 1.5 2 2.5]                         "Cycles"
   add_user_param     "${m_param_prefix}_TSA_NS"               float     0.230                  {0:5.000}                                "nanoseconds"      
   add_user_param     "${m_param_prefix}_THA_NS"               float     0.180                  {0:5.000}                                "nanoseconds"      
   add_user_param     "${m_param_prefix}_TSD_NS"               float     0.230                  {0:5.000}                                "nanoseconds"      
   add_user_param     "${m_param_prefix}_THD_NS"               float     0.180                  {0:5.000}                                "nanoseconds"      
   add_user_param     "${m_param_prefix}_TCQD_NS"              float     0.090                  {0:5.000}                                "nanoseconds"      
   add_user_param     "${m_param_prefix}_TCQDOH_NS"            float     -0.090                 {-5.000:5.000}                           "nanoseconds"      
   add_user_param     "${m_param_prefix}_INTERNAL_JITTER_NS"   float     0.080                  {0:5.000}                                "nanoseconds"      
   add_user_param     "${m_param_prefix}_TCQH_NS"              float     0.710                  {0:5.000}                                "nanoseconds"
   add_user_param     "${m_param_prefix}_TCCQO_NS"             float     0.45                   {0:5.000}                                "nanoseconds"  

   return 1
}

proc ::altera_emif::ip_top::mem::qdr2::set_family_specific_defaults {family_enum base_family_enum is_hps} {
   variable m_param_prefix
   
   return 1
}

proc ::altera_emif::ip_top::mem::qdr2::add_display_items {tabs} {
   variable m_param_prefix
   
   set mem_params_tab [lindex $tabs 0]
   set mem_io_tab     [lindex $tabs 1]
   set mem_timing_tab [lindex $tabs 2]
   
   set topology_grp [get_string GRP_MEM_TOPOLOGY_NAME]
   
   add_param_to_gui $topology_grp "${m_param_prefix}_DATA_PER_DEVICE" 
   add_param_to_gui $topology_grp "${m_param_prefix}_DATA_WIDTH" 
   add_param_to_gui $topology_grp "${m_param_prefix}_BWS_N_WIDTH" 
   add_param_to_gui $topology_grp "${m_param_prefix}_CQ_WIDTH"    
   add_param_to_gui $topology_grp "${m_param_prefix}_K_WIDTH" 
   add_param_to_gui $topology_grp "${m_param_prefix}_BWS_EN" 
   add_param_to_gui $topology_grp "${m_param_prefix}_WIDTH_EXPANDED" 
   add_param_to_gui $topology_grp "${m_param_prefix}_ADDR_WIDTH" 
   add_param_to_gui $topology_grp "${m_param_prefix}_BL" 

   add_text_to_gui  $mem_timing_tab "${m_param_prefix}_id1" "<html>Timing parameters as found in the data sheet of the memory device."
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_SPEEDBIN_ENUM" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TWL_CYC" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TRL_CYC" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TSA_NS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_THA_NS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TSD_NS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_THD_NS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TCQD_NS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TCQDOH_NS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_INTERNAL_JITTER_NS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TCQH_NS" 
   add_param_to_gui $mem_timing_tab "${m_param_prefix}_TCCQO_NS" 
      
   return 1
}

proc ::altera_emif::ip_top::mem::qdr2::validate {} {
   
   set odt_grp [get_string GRP_MEM_ODT_NAME]
   set_display_item_property $odt_grp VISIBLE false
 
   _validate_memory_parameters 

   _validate_memory_timing_parameters 
   
   if {![has_pending_ipgen_e_msg]} {
      _derive_protocol_agnostic_parameters
   }

   return 1
}


proc ::altera_emif::ip_top::mem::qdr2::_derive_protocol_agnostic_parameters {} {
   variable m_param_prefix

   set_parameter_value MEM_FORMAT_ENUM             [get_parameter_value "${m_param_prefix}_FORMAT_ENUM"]
   set_parameter_value MEM_DATA_MASK_EN            [get_parameter_value "${m_param_prefix}_BWS_EN"]
   set_parameter_value MEM_READ_LATENCY            [get_parameter_value "${m_param_prefix}_TRL_CYC"]
   set_parameter_value MEM_WRITE_LATENCY           [get_parameter_value "${m_param_prefix}_TWL_CYC"]
   set_parameter_value MEM_BURST_LENGTH            [get_parameter_value "${m_param_prefix}_BL"]
   set_parameter_value MEM_TTL_DATA_WIDTH          [get_parameter_value "${m_param_prefix}_DATA_WIDTH"]
   set_parameter_value MEM_TTL_NUM_OF_READ_GROUPS  [get_parameter_value "${m_param_prefix}_CQ_WIDTH"]
   set_parameter_value MEM_TTL_NUM_OF_WRITE_GROUPS [get_parameter_value "${m_param_prefix}_K_WIDTH"]
   set_parameter_value MEM_NUM_OF_LOGICAL_RANKS    1
   
   return 1
}

proc ::altera_emif::ip_top::mem::qdr2::_validate_memory_parameters {} {

   variable m_param_prefix
   
   set width_expanded            [get_parameter_value "${m_param_prefix}_WIDTH_EXPANDED"]
   set data_per_device           [get_parameter_value "${m_param_prefix}_DATA_PER_DEVICE"]
   set bl                        [get_parameter_value "${m_param_prefix}_BL"]
   set rl                        [get_parameter_value "${m_param_prefix}_TRL_CYC"]
   set bws_en                    [get_parameter_value "${m_param_prefix}_BWS_EN"]
   set speedbin_enum             [get_parameter_value "${m_param_prefix}_SPEEDBIN_ENUM"]
   set speedbin_ui_name          [enum_data $speedbin_enum UI_NAME]
   set mem_fmax                  [enum_data $speedbin_enum FMAX_MHZ]
   set mem_fmin                  [enum_data $speedbin_enum FMIN_MHZ]
   set allowed_voltages          [enum_data $speedbin_enum ALLOWED_VOLTAGES]
   set io_voltage                [get_parameter_value "PHY_QDR2_IO_VOLTAGE"]
   set enable_power_of_two_bus   [get_parameter_value "CTRL_QDR2_AVL_ENABLE_POWER_OF_TWO_BUS"]
   set clk_freq_mhz              [get_parameter_value "PHY_QDR2_MEM_CLK_FREQ_MHZ"]
   set rate_enum                 [get_parameter_value "PHY_QDR2_RATE_ENUM"]
   set width                     [expr {$width_expanded ? 2 : 1}]
   set symbol_width              [expr {$enable_power_of_two_bus ? 8 : 9}]
   set data_width                [expr {$data_per_device * $width}]
   set k_width                   $width
   set cq_width                  $width
   set bws_n_per_device          [expr {$bws_en ? $data_per_device / $symbol_width : 0}]
   set bws_n_width               [expr {$bws_n_per_device * $width}]
   
   
   if {$clk_freq_mhz < $mem_fmin || $clk_freq_mhz > $mem_fmax} {
      post_ipgen_e_msg MSG_QDR2_FREQ_OUT_OF_RANGE [list $mem_fmin $mem_fmax $speedbin_ui_name]
      return 0
   }
   
   if {[lsearch -exact -real $allowed_voltages $io_voltage] == -1} {
      post_ipgen_e_msg MSG_QDR2_UNSUPPORTED_SPEEDBIN [list $speedbin_ui_name]
      return 0
   }
   
   if {$bl == 2 && [enum_same $rate_enum RATE_HALF]} {
      post_ipgen_e_msg MSG_QDR2_BL_NOT_SUPPORTED_FOR_RATE [list $bl [enum_data $rate_enum UI_NAME]]
      return 0
   }

   switch $bl {
      2 {         
         set_parameter_value "${m_param_prefix}_TWL_CYC" 0
      }
      4 {         
         set_parameter_value "${m_param_prefix}_TWL_CYC" 1
      }
      default {
         emif_ie "Unrecognized burst length $bl"
      }
   }
 
   set_parameter_value "${m_param_prefix}_DEVICE_WIDTH"        $width
   set_parameter_value "${m_param_prefix}_DATA_WIDTH"          $data_width
   set_parameter_value "${m_param_prefix}_BWS_N_WIDTH"         $bws_n_width
   set_parameter_value "${m_param_prefix}_BWS_N_PER_DEVICE"    $bws_n_per_device
   set_parameter_value "${m_param_prefix}_K_WIDTH"             $k_width
   set_parameter_value "${m_param_prefix}_CQ_WIDTH"            $cq_width

   set_display_item_property [get_string DDR3_RDIMM_TXT_NAME]         VISIBLE false
   set_display_item_property [get_string DDR3_LRDIMM_TXT_NAME]        VISIBLE false
   set_display_item_property [get_string DDR4_RDIMM_TXT_NAME]         VISIBLE false
   set_display_item_property [get_string DDR4_LRDIMM_TXT_NAME]        VISIBLE false

   return 1
}

proc ::altera_emif::ip_top::mem::qdr2::_validate_memory_timing_parameters {} {
   
   variable m_param_prefix
   
   return 1
}

proc ::altera_emif::ip_top::mem::qdr2::_init {} {
}

::altera_emif::ip_top::mem::qdr2::_init
