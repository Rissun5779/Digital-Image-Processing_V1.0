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


package provide altera_emif::ip_top::board::qdr4 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::math
package require altera_emif::util::enums
package require altera_emif::util::device_family
package require altera_emif::util::channel_uncertainty
package require altera_emif::ip_top::util

namespace eval ::altera_emif::ip_top::board::qdr4:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_emif::ip_top::util::*

   
   variable m_param_prefix "BOARD_QDR4"
}


proc ::altera_emif::ip_top::board::qdr4::create_parameters {is_top_level_component} {
   variable m_param_prefix
   
   set ck_slew_rate_default    4.0
   set ac_slew_rate_default    2.0
   set rclk_slew_rate_default  5.0
   set wclk_slew_rate_default  4.0
   set rdata_slew_rate_default 2.5
   set wdata_slew_rate_default 2.0
   
   set ac_isi_ns_default    0.000
   set rclk_isi_ns_default  0.000
   set wclk_isi_ns_default  0.000
   set rdata_isi_ns_default 0.000
   set wdata_isi_ns_default 0.000

   add_user_param     "${m_param_prefix}_USE_DEFAULT_SLEW_RATES"        boolean   true                       ""               ""              ""             ""            ""
   add_user_param     "${m_param_prefix}_USE_DEFAULT_ISI_VALUES"        boolean   true                       ""               ""              ""             ""            ""

   add_user_param     "${m_param_prefix}_USER_CK_SLEW_RATE"             float     $ck_slew_rate_default      {0.1:10.0}       ""              "V/ns"         ""            ""
   add_user_param     "${m_param_prefix}_USER_AC_SLEW_RATE"             float     $ac_slew_rate_default      {0.1:10.0}       ""              "V/ns"         ""            ""
   add_user_param     "${m_param_prefix}_USER_RCLK_SLEW_RATE"           float     $rclk_slew_rate_default    {0.1:10.0}       ""              "V/ns"         ""            ""
   add_user_param     "${m_param_prefix}_USER_WCLK_SLEW_RATE"           float     $wclk_slew_rate_default    {0.1:10.0}       ""              "V/ns"         ""            ""
   add_user_param     "${m_param_prefix}_USER_RDATA_SLEW_RATE"          float     $rdata_slew_rate_default   {0.1:10.0}       ""              "V/ns"         ""            ""
   add_user_param     "${m_param_prefix}_USER_WDATA_SLEW_RATE"          float     $wdata_slew_rate_default   {0.1:10.0}       ""              "V/ns"         ""            ""

   add_user_param     "${m_param_prefix}_USER_AC_ISI_NS"                float     $ac_isi_ns_default         {0:10.0}         "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_USER_RCLK_ISI_NS"              float     $rclk_isi_ns_default       {0:10.0}         "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_USER_WCLK_ISI_NS"              float     $wclk_isi_ns_default       {0:10.0}         "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_USER_RDATA_ISI_NS"             float     $rdata_isi_ns_default      {0:10.0}         "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_USER_WDATA_ISI_NS"             float     $wdata_isi_ns_default      {0:10.0}         "nanoseconds"   ""             ""            ""

   add_user_param     "${m_param_prefix}_IS_SKEW_WITHIN_QK_DESKEWED"    boolean   true                       ""               ""              ""             ""            ""
   add_user_param     "${m_param_prefix}_BRD_SKEW_WITHIN_QK_NS"         float     0.020                      {0:10.0}         "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_PKG_BRD_SKEW_WITHIN_QK_NS"     float     0.020                      {0:10.0}         "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_IS_SKEW_WITHIN_AC_DESKEWED"    boolean   true                       ""               ""              ""             ""            ""
   add_user_param     "${m_param_prefix}_BRD_SKEW_WITHIN_AC_NS"         float     0.020                      {0:10.0}         "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_PKG_BRD_SKEW_WITHIN_AC_NS"     float     0.020                      {0:10.0}         "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_DK_TO_CK_SKEW_NS"              float     -0.020                      ""              "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_SKEW_BETWEEN_DIMMS_NS"         float     0.05                       {0:10.0}         "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_SKEW_BETWEEN_DK_NS"            float     0.020                      {0:10.0}         "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_AC_TO_CK_SKEW_NS"              float     0.0                        ""               "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_MAX_CK_DELAY_NS"               float     0.6                        {0:10.0}         "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_MAX_DK_DELAY_NS"               float     0.6                        {0:10.0}         "nanoseconds"   ""             ""            ""
   

   add_derived_param  "${m_param_prefix}_CK_SLEW_RATE"                  float     $ck_slew_rate_default      true       ""            "V/ns"        ""            "${m_param_prefix}_USER_CK_SLEW_RATE"       
   add_derived_param  "${m_param_prefix}_AC_SLEW_RATE"                  float     $ac_slew_rate_default      true       ""            "V/ns"        ""            "${m_param_prefix}_USER_AC_SLEW_RATE"       
   add_derived_param  "${m_param_prefix}_RCLK_SLEW_RATE"                float     $rclk_slew_rate_default    true       ""            "V/ns"        ""            "${m_param_prefix}_USER_RCLK_SLEW_RATE"     
   add_derived_param  "${m_param_prefix}_WCLK_SLEW_RATE"                float     $wclk_slew_rate_default    true       ""            "V/ns"        ""            "${m_param_prefix}_USER_WCLK_SLEW_RATE"     
   add_derived_param  "${m_param_prefix}_RDATA_SLEW_RATE"               float     $rdata_slew_rate_default   true       ""            "V/ns"        ""            "${m_param_prefix}_USER_RDATA_SLEW_RATE"    
   add_derived_param  "${m_param_prefix}_WDATA_SLEW_RATE"               float     $wdata_slew_rate_default   true       ""            "V/ns"        ""            "${m_param_prefix}_USER_WDATA_SLEW_RATE"    

   add_derived_param  "${m_param_prefix}_AC_ISI_NS"                     float     $ac_isi_ns_default         true       "nanoseconds" ""            ""            "${m_param_prefix}_USER_AC_ISI_NS"       
   add_derived_param  "${m_param_prefix}_RCLK_ISI_NS"                   float     $rclk_isi_ns_default       true       "nanoseconds" ""            ""            "${m_param_prefix}_USER_RCLK_ISI_NS"     
   add_derived_param  "${m_param_prefix}_WCLK_ISI_NS"                   float     $wclk_isi_ns_default       true       "nanoseconds" ""            ""            "${m_param_prefix}_USER_WCLK_ISI_NS"     
   add_derived_param  "${m_param_prefix}_RDATA_ISI_NS"                  float     $rdata_isi_ns_default      true       "nanoseconds" ""            ""            "${m_param_prefix}_USER_RDATA_ISI_NS"    
   add_derived_param  "${m_param_prefix}_WDATA_ISI_NS"                  float     $wdata_isi_ns_default      true       "nanoseconds" ""            ""            "${m_param_prefix}_USER_WDATA_ISI_NS"    
   
   add_derived_param  "${m_param_prefix}_SKEW_WITHIN_QK_NS"             float     0                          false      ""            ""            ""            ""    
   add_derived_param  "${m_param_prefix}_SKEW_WITHIN_AC_NS"             float     0                          false      ""            ""            ""            ""    
   
   set_parameter_update_callback "PHY_QDR4_MEM_CLK_FREQ_MHZ"       ::altera_emif::ip_top::board::qdr4::_update_slew_rates
   set_parameter_update_callback "${m_param_prefix}_USE_DEFAULT_SLEW_RATES" ::altera_emif::ip_top::board::qdr4::_update_slew_rates

   set_parameter_update_callback "MEM_QDR4_DEVICE_DEPTH"           ::altera_emif::ip_top::board::qdr4::_update_isi_values
   set_parameter_update_callback "${m_param_prefix}_USE_DEFAULT_ISI_VALUES" ::altera_emif::ip_top::board::qdr4::_update_isi_values
   
   set_parameter_update_callback "MEM_QDR4_DEVICE_DEPTH"           ::altera_emif::ip_top::board::qdr4::_grey_out_board_values

   return 1
}

proc ::altera_emif::ip_top::board::qdr4::set_family_specific_defaults {family_enum base_family_enum is_hps} {
   variable m_param_prefix
   
   return 1
}

proc ::altera_emif::ip_top::board::qdr4::add_display_items {tabs} {
   variable m_param_prefix
   
   set board_params_tab [lindex $tabs 0]
   
   add_text_to_gui  $board_params_tab "${m_param_prefix}_TOP_TXT" "<html>Use the Board Settings to model the board-level effects in the timing analysis.<br>You should use HyperLynx or similar simulators to obtain values that are representative of your board."
   

   
   set isi_grp [get_string GRP_BOARD_ISI_NAME]
   add_display_item $board_params_tab $isi_grp GROUP
   
   add_text_to_gui  $isi_grp "${m_param_prefix}_ISI_TXT" "<html>Intersymbol interference and crosstalk can cause signal distortion leading to reduction of timing margins.<br>"
   add_param_to_gui $isi_grp "${m_param_prefix}_USE_DEFAULT_ISI_VALUES"
   add_param_to_gui $isi_grp "${m_param_prefix}_USER_AC_ISI_NS"   
   add_param_to_gui $isi_grp "${m_param_prefix}_AC_ISI_NS"   
   add_param_to_gui $isi_grp "${m_param_prefix}_USER_RCLK_ISI_NS"    
   add_param_to_gui $isi_grp "${m_param_prefix}_RCLK_ISI_NS" 
   add_param_to_gui $isi_grp "${m_param_prefix}_USER_RDATA_ISI_NS"   
   add_param_to_gui $isi_grp "${m_param_prefix}_RDATA_ISI_NS"
   add_param_to_gui $isi_grp "${m_param_prefix}_USER_WCLK_ISI_NS"    
   add_param_to_gui $isi_grp "${m_param_prefix}_WCLK_ISI_NS" 
   add_param_to_gui $isi_grp "${m_param_prefix}_USER_WDATA_ISI_NS"   
   add_param_to_gui $isi_grp "${m_param_prefix}_WDATA_ISI_NS"
   
   set skews_grp [get_string GRP_BOARD_SKEWS_NAME]
   add_display_item $board_params_tab $skews_grp GROUP
   
   add_text_to_gui  $skews_grp "${m_param_prefix}_SKEWS_TXT" "<html>PCB traces and device packages can introduce skews between signals, reducing timing margins.<br>"   
   add_text_to_gui  $skews_grp "${m_param_prefix}_INTRABUS_SKEWS_TXT_0" "<html><b>Intrabus skews (skew among pins in the same bus):</b><br>"  
   add_param_to_gui $skews_grp "${m_param_prefix}_IS_SKEW_WITHIN_QK_DESKEWED"   
   add_param_to_gui $skews_grp "${m_param_prefix}_BRD_SKEW_WITHIN_QK_NS"   
   add_param_to_gui $skews_grp "${m_param_prefix}_PKG_BRD_SKEW_WITHIN_QK_NS"   
   add_param_to_gui $skews_grp "${m_param_prefix}_IS_SKEW_WITHIN_AC_DESKEWED"   
   add_param_to_gui $skews_grp "${m_param_prefix}_BRD_SKEW_WITHIN_AC_NS"           
   add_param_to_gui $skews_grp "${m_param_prefix}_PKG_BRD_SKEW_WITHIN_AC_NS"         
   
   add_text_to_gui  $skews_grp "${m_param_prefix}_INTRABUS_SKEWS_TXT_1" "<html><br><b>Interbus skews (skew among buses):</b><br>" 
   add_param_to_gui $skews_grp "${m_param_prefix}_DK_TO_CK_SKEW_NS"    
   add_param_to_gui $skews_grp "${m_param_prefix}_SKEW_BETWEEN_DIMMS_NS"
   add_param_to_gui $skews_grp "${m_param_prefix}_SKEW_BETWEEN_DK_NS"  
   add_param_to_gui $skews_grp "${m_param_prefix}_AC_TO_CK_SKEW_NS"     
   
   add_text_to_gui  $skews_grp "${m_param_prefix}_INTRABUS_SKEWS_TXT_2" "<html><br><b>Signal delays:</b><br>" 
   add_param_to_gui $skews_grp "${m_param_prefix}_MAX_CK_DELAY_NS"      
   add_param_to_gui $skews_grp "${m_param_prefix}_MAX_DK_DELAY_NS"     
   
   return 1
}

proc ::altera_emif::ip_top::board::qdr4::validate {} {
   variable m_param_prefix

   set dqs_group_size [get_parameter_value MEM_QDR4_DQ_PER_RD_GROUP]
   
   set default_sr      [get_parameter_value "${m_param_prefix}_USE_DEFAULT_SLEW_RATES"]
   set default_sr false
   set_parameter_property  "${m_param_prefix}_USE_DEFAULT_SLEW_RATES"         VISIBLE         $default_sr   
   set_parameter_property  "${m_param_prefix}_USER_CK_SLEW_RATE"              VISIBLE         $default_sr
   set_parameter_property  "${m_param_prefix}_USER_AC_SLEW_RATE"              VISIBLE         $default_sr
   set_parameter_property  "${m_param_prefix}_USER_RCLK_SLEW_RATE"            VISIBLE         $default_sr
   set_parameter_property  "${m_param_prefix}_USER_WCLK_SLEW_RATE"            VISIBLE         $default_sr
   set_parameter_property  "${m_param_prefix}_USER_RDATA_SLEW_RATE"           VISIBLE         $default_sr
   set_parameter_property  "${m_param_prefix}_USER_WDATA_SLEW_RATE"           VISIBLE         $default_sr
   set_parameter_property  "${m_param_prefix}_CK_SLEW_RATE"                   VISIBLE         $default_sr
   set_parameter_property  "${m_param_prefix}_AC_SLEW_RATE"                   VISIBLE         $default_sr
   set_parameter_property  "${m_param_prefix}_RCLK_SLEW_RATE"                 VISIBLE         $default_sr
   set_parameter_property  "${m_param_prefix}_WCLK_SLEW_RATE"                 VISIBLE         $default_sr
   set_parameter_property  "${m_param_prefix}_RDATA_SLEW_RATE"                VISIBLE         $default_sr
   set_parameter_property  "${m_param_prefix}_WDATA_SLEW_RATE"                VISIBLE         $default_sr
   
   set default_isi      [get_parameter_value "${m_param_prefix}_USE_DEFAULT_ISI_VALUES"]
   set_parameter_property  "${m_param_prefix}_USER_AC_ISI_NS"                      VISIBLE         [expr {!$default_isi}]
   set_parameter_property  "${m_param_prefix}_USER_RCLK_ISI_NS"                    VISIBLE         [expr {!$default_isi}]
   set_parameter_property  "${m_param_prefix}_USER_WCLK_ISI_NS"                    VISIBLE         [expr {!$default_isi}]
   set_parameter_property  "${m_param_prefix}_USER_RDATA_ISI_NS"                   VISIBLE         [expr {!$default_isi}]
   set_parameter_property  "${m_param_prefix}_USER_WDATA_ISI_NS"                   VISIBLE         [expr {!$default_isi}]
   set_parameter_property  "${m_param_prefix}_AC_ISI_NS"                           VISIBLE         $default_isi
   set_parameter_property  "${m_param_prefix}_RCLK_ISI_NS"                         VISIBLE         $default_isi
   set_parameter_property  "${m_param_prefix}_WCLK_ISI_NS"                         VISIBLE         $default_isi
   set_parameter_property  "${m_param_prefix}_RDATA_ISI_NS"                        VISIBLE         $default_isi
   set_parameter_property  "${m_param_prefix}_WDATA_ISI_NS"                        VISIBLE         $default_isi
   
  
   set pkg_QK_deskewed    [get_parameter_value "${m_param_prefix}_IS_SKEW_WITHIN_QK_DESKEWED"]
   set pkg_AC_deskewed     [get_parameter_value "${m_param_prefix}_IS_SKEW_WITHIN_AC_DESKEWED"]
   set_parameter_property  "${m_param_prefix}_BRD_SKEW_WITHIN_QK_NS"         VISIBLE         [expr {!$pkg_QK_deskewed}]
   set_parameter_property  "${m_param_prefix}_PKG_BRD_SKEW_WITHIN_QK_NS"     VISIBLE         [expr {$pkg_QK_deskewed}]
   set_parameter_property  "${m_param_prefix}_BRD_SKEW_WITHIN_AC_NS"          VISIBLE         [expr {!$pkg_AC_deskewed}]
   set_parameter_property  "${m_param_prefix}_PKG_BRD_SKEW_WITHIN_AC_NS"      VISIBLE         [expr {$pkg_AC_deskewed}]
   
   if { $pkg_QK_deskewed } {
      set_parameter_value      "${m_param_prefix}_SKEW_WITHIN_QK_NS"             [get_parameter_value "${m_param_prefix}_PKG_BRD_SKEW_WITHIN_QK_NS"]
   } else {
      if { $dqs_group_size == 9 } {
         set_parameter_value      "${m_param_prefix}_SKEW_WITHIN_QK_NS"             [expr {[get_parameter_value "${m_param_prefix}_BRD_SKEW_WITHIN_QK_NS"] + [enum_data  "PINS_9" PKG_SKEW]}]
      } else {
         set_parameter_value      "${m_param_prefix}_SKEW_WITHIN_QK_NS"             [expr {[get_parameter_value "${m_param_prefix}_BRD_SKEW_WITHIN_QK_NS"] + [enum_data  "PINS_18" PKG_SKEW]}]
      }
   }
   if { $pkg_AC_deskewed } {
      set_parameter_value      "${m_param_prefix}_SKEW_WITHIN_AC_NS"              [get_parameter_value "${m_param_prefix}_PKG_BRD_SKEW_WITHIN_AC_NS" ]
   } else {
      set_parameter_value      "${m_param_prefix}_SKEW_WITHIN_AC_NS"              [expr {[get_parameter_value "${m_param_prefix}_BRD_SKEW_WITHIN_AC_NS" ] + [enum_data  "PINS_32"             PKG_SKEW]}]
   }
   
   _update_slew_rates ""
   _update_isi_values ""
   _grey_out_board_values ""

   return 1
}


proc ::altera_emif::ip_top::board::qdr4::_update_slew_rates {arg} {
   variable m_param_prefix
   
   set gui_triggered [expr {$arg != ""}]
   
   set use_default [get_parameter_value "${m_param_prefix}_USE_DEFAULT_SLEW_RATES"]
   
   if {$use_default || $gui_triggered} {
      set mem_freq  [get_parameter_value "PHY_QDR4_MEM_CLK_FREQ_MHZ"]

      set rdata_slew              2.5
      set wdata_slew              2
      set ck_slew_rate_default    4.0
      set ac_slew_rate_default    2.0
      set rclk_slew_rate_default  5.0
      set wclk_slew_rate_default  4.0

      if {$use_default} {
         set_parameter_value "${m_param_prefix}_RDATA_SLEW_RATE"       $rdata_slew
         set_parameter_value "${m_param_prefix}_WDATA_SLEW_RATE"       $wdata_slew
         set_parameter_value "${m_param_prefix}_CK_SLEW_RATE"          $ck_slew_rate_default  
         set_parameter_value "${m_param_prefix}_AC_SLEW_RATE"          $ac_slew_rate_default  
         set_parameter_value "${m_param_prefix}_RCLK_SLEW_RATE"        $rclk_slew_rate_default
         set_parameter_value "${m_param_prefix}_WCLK_SLEW_RATE"        $wclk_slew_rate_default
      } else {
         set_parameter_value "${m_param_prefix}_USER_RDATA_SLEW_RATE"  $rdata_slew
         set_parameter_value "${m_param_prefix}_USER_WDATA_SLEW_RATE"  $wdata_slew
         set_parameter_value "${m_param_prefix}_USER_CK_SLEW_RATE"     $ck_slew_rate_default  
         set_parameter_value "${m_param_prefix}_USER_AC_SLEW_RATE"     $ac_slew_rate_default  
         set_parameter_value "${m_param_prefix}_USER_RCLK_SLEW_RATE"   $rclk_slew_rate_default
         set_parameter_value "${m_param_prefix}_USER_WCLK_SLEW_RATE"   $wclk_slew_rate_default
      }
   } else {
      set_parameter_value "${m_param_prefix}_RDATA_SLEW_RATE"  [get_parameter_value "${m_param_prefix}_USER_RDATA_SLEW_RATE"]
      set_parameter_value "${m_param_prefix}_WDATA_SLEW_RATE"  [get_parameter_value "${m_param_prefix}_USER_WDATA_SLEW_RATE"]
      set_parameter_value "${m_param_prefix}_CK_SLEW_RATE"     [get_parameter_value "${m_param_prefix}_USER_CK_SLEW_RATE"]
      set_parameter_value "${m_param_prefix}_AC_SLEW_RATE"     [get_parameter_value "${m_param_prefix}_USER_AC_SLEW_RATE"]
      set_parameter_value "${m_param_prefix}_RCLK_SLEW_RATE"   [get_parameter_value "${m_param_prefix}_USER_RCLK_SLEW_RATE"]
      set_parameter_value "${m_param_prefix}_WCLK_SLEW_RATE"   [get_parameter_value "${m_param_prefix}_USER_WCLK_SLEW_RATE"]
   }

   return 1
}


proc ::altera_emif::ip_top::board::qdr4::_update_isi_values {arg} {
   variable m_param_prefix
   
   set gui_triggered [expr {$arg != ""}]
   
   set use_default [get_parameter_value "${m_param_prefix}_USE_DEFAULT_ISI_VALUES"]
  
   if {$use_default || $gui_triggered} {

      set num_total_ranks     [get_parameter_value "MEM_QDR4_DEVICE_DEPTH"]
	  set num_devices         [get_parameter_value MEM_QDR4_DEVICE_WIDTH]

      set format_string "Device"

      set family_enum [get_device_family_enum]
      set base_family_enum [enum_data $family_enum BASE_FAMILY_ENUM]

      set wdata_isi_ns [altera_emif::util::channel_uncertainty::get_global_channel_uncertainty_value $base_family_enum "QDR_IV" $format_string "tCE_DQ_DQS_WT_RANK" $num_total_ranks]
      set rdata_isi_ns [altera_emif::util::channel_uncertainty::get_global_channel_uncertainty_value $base_family_enum "QDR_IV" $format_string "tCE_DQ_DQS_RD_RANK" $num_total_ranks]
      set wclk_isi_ns  [altera_emif::util::channel_uncertainty::get_global_channel_uncertainty_value $base_family_enum "QDR_IV" $format_string "tCE_DQS_CK_RANK" $num_total_ranks]
      set ac_isi_ns    [altera_emif::util::channel_uncertainty::get_global_channel_uncertainty_value $base_family_enum "QDR_IV" $format_string "tCE_CA_CK_RANK" $num_devices]
      set rclk_isi_ns  [altera_emif::util::channel_uncertainty::get_global_channel_uncertainty_value $base_family_enum "QDR_IV" $format_string "tCE_DQS_RANK" $num_total_ranks]

      if {$use_default} {
         set_parameter_value "${m_param_prefix}_AC_ISI_NS"          $ac_isi_ns
         set_parameter_value "${m_param_prefix}_RCLK_ISI_NS"        $rclk_isi_ns
         set_parameter_value "${m_param_prefix}_WCLK_ISI_NS"        $wclk_isi_ns
         set_parameter_value "${m_param_prefix}_RDATA_ISI_NS"       $rdata_isi_ns
         set_parameter_value "${m_param_prefix}_WDATA_ISI_NS"       $wdata_isi_ns
      } else {
         set_parameter_value "${m_param_prefix}_USER_AC_ISI_NS"     $ac_isi_ns
         set_parameter_value "${m_param_prefix}_USER_RCLK_ISI_NS"   $rclk_isi_ns
         set_parameter_value "${m_param_prefix}_USER_WCLK_ISI_NS"   $wclk_isi_ns
         set_parameter_value "${m_param_prefix}_USER_RDATA_ISI_NS"  $rdata_isi_ns
         set_parameter_value "${m_param_prefix}_USER_WDATA_ISI_NS"  $wdata_isi_ns
      }
   } else {
      set_parameter_value "${m_param_prefix}_AC_ISI_NS"     [get_parameter_value "${m_param_prefix}_USER_AC_ISI_NS"]
      set_parameter_value "${m_param_prefix}_RCLK_ISI_NS"   [get_parameter_value "${m_param_prefix}_USER_RCLK_ISI_NS"]
      set_parameter_value "${m_param_prefix}_WCLK_ISI_NS"   [get_parameter_value "${m_param_prefix}_USER_WCLK_ISI_NS"]
      set_parameter_value "${m_param_prefix}_RDATA_ISI_NS"  [get_parameter_value "${m_param_prefix}_USER_RDATA_ISI_NS"]
      set_parameter_value "${m_param_prefix}_WDATA_ISI_NS"  [get_parameter_value "${m_param_prefix}_USER_WDATA_ISI_NS"]
   }

   return 1
}

proc ::altera_emif::ip_top::board::qdr4::_grey_out_board_values {arg} {
   variable m_param_prefix
   
   set num_total_ranks     [get_parameter_value "MEM_QDR4_DEVICE_DEPTH"]
      
   if {$num_total_ranks > 1} {
      set_parameter_property  "${m_param_prefix}_SKEW_BETWEEN_DIMMS_NS"              ENABLED         true
   } else {
      set_parameter_property  "${m_param_prefix}_SKEW_BETWEEN_DIMMS_NS"              ENABLED         false
   }

   return 1
}


proc ::altera_emif::ip_top::board::qdr4::_init {} {

   if {[emif_utest_enabled]} {   
   
      emif_utest_start "::altera_emif::ip_top::board::qdr4"

      emif_utest_pass 
   }   
}

::altera_emif::ip_top::board::qdr4::_init
