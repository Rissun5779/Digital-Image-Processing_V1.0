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


package provide altera_emif::ip_top::board::ddr4 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::math
package require altera_emif::util::enums
package require altera_emif::util::device_family
package require altera_emif::util::channel_uncertainty
package require altera_emif::ip_top::util

namespace eval ::altera_emif::ip_top::board::ddr4:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_emif::ip_top::util::*

   
   variable m_param_prefix "BOARD_DDR4"
}


proc ::altera_emif::ip_top::board::ddr4::create_parameters {is_top_level_component} {
   variable m_param_prefix
   
   set ck_slew_rate_default    4.0
   set ac_slew_rate_default    2.0
   set rclk_slew_rate_default  8.0
   set wclk_slew_rate_default  4.0
   set rdata_slew_rate_default 4.0
   set wdata_slew_rate_default 2.0
   
   set ac_isi_ns_default    0.000
   set rclk_isi_ns_default  0.000
   set wclk_isi_ns_default  0.000
   set rdata_isi_ns_default 0.000
   set wdata_isi_ns_default 0.000

   add_user_param     "${m_param_prefix}_USE_DEFAULT_SLEW_RATES"        boolean   true                       ""               ""              ""             ""             ""
   add_user_param     "${m_param_prefix}_USE_DEFAULT_ISI_VALUES"        boolean   true                       ""               ""              ""             ""             ""
      
   add_user_param     "${m_param_prefix}_USER_CK_SLEW_RATE"             float     $ck_slew_rate_default      {0.1:10.0}       ""              "V/ns"         ""             ""
   add_user_param     "${m_param_prefix}_USER_AC_SLEW_RATE"             float     $ac_slew_rate_default      {0.1:10.0}       ""              "V/ns"         ""             ""
   add_user_param     "${m_param_prefix}_USER_RCLK_SLEW_RATE"           float     $rclk_slew_rate_default    {0.1:10.0}       ""              "V/ns"         ""             ""
   add_user_param     "${m_param_prefix}_USER_WCLK_SLEW_RATE"           float     $wclk_slew_rate_default    {0.1:10.0}       ""              "V/ns"         ""             ""
   add_user_param     "${m_param_prefix}_USER_RDATA_SLEW_RATE"          float     $rdata_slew_rate_default   {0.1:10.0}       ""              "V/ns"         ""             ""
   add_user_param     "${m_param_prefix}_USER_WDATA_SLEW_RATE"          float     $wdata_slew_rate_default   {0.1:10.0}       ""              "V/ns"         ""             ""

   add_user_param     "${m_param_prefix}_USER_AC_ISI_NS"                float     $ac_isi_ns_default         {0:10.0}         "nanoseconds"   ""             ""             ""
   add_user_param     "${m_param_prefix}_USER_RCLK_ISI_NS"              float     $rclk_isi_ns_default       {0:10.0}         "nanoseconds"   ""             ""             ""
   add_user_param     "${m_param_prefix}_USER_WCLK_ISI_NS"              float     $wclk_isi_ns_default       {0:10.0}         "nanoseconds"   ""             ""             ""
   add_user_param     "${m_param_prefix}_USER_RDATA_ISI_NS"             float     $rdata_isi_ns_default      {0:10.0}         "nanoseconds"   ""             ""             ""
   add_user_param     "${m_param_prefix}_USER_WDATA_ISI_NS"             float     $wdata_isi_ns_default      {0:10.0}         "nanoseconds"   ""             ""             ""

   add_user_param     "${m_param_prefix}_IS_SKEW_WITHIN_DQS_DESKEWED"   boolean   true                      ""               ""              ""             ""              ""
   add_user_param     "${m_param_prefix}_BRD_SKEW_WITHIN_DQS_NS"        float     0.020                      {0:10.0}         "nanoseconds"   ""             ""             ""
   add_user_param     "${m_param_prefix}_PKG_BRD_SKEW_WITHIN_DQS_NS"    float     0.020                      {0:10.0}         "nanoseconds"   ""             ""             ""
   add_user_param     "${m_param_prefix}_IS_SKEW_WITHIN_AC_DESKEWED"    boolean   false                      ""               ""              ""             ""             ""
   add_user_param     "${m_param_prefix}_BRD_SKEW_WITHIN_AC_NS"         float     0.020                      {0:10.0}         "nanoseconds"   ""             ""             ""
   add_user_param     "${m_param_prefix}_PKG_BRD_SKEW_WITHIN_AC_NS"     float     0.020                      {0:10.0}         "nanoseconds"   ""             ""             ""
   add_user_param     "${m_param_prefix}_DQS_TO_CK_SKEW_NS"             float     0.020                      ""               "nanoseconds"   ""             ""             ""
   add_user_param     "${m_param_prefix}_SKEW_BETWEEN_DIMMS_NS"         float     0.05                       {0:10.0}         "nanoseconds"   ""             ""             ""
   add_user_param     "${m_param_prefix}_SKEW_BETWEEN_DQS_NS"           float     0.020                      {0:10.0}         "nanoseconds"   ""             ""             ""
   add_user_param     "${m_param_prefix}_AC_TO_CK_SKEW_NS"              float     0.0                        ""               "nanoseconds"   ""             ""             ""
   add_user_param     "${m_param_prefix}_MAX_CK_DELAY_NS"               float     0.6                        {0:10.0}         "nanoseconds"   ""             ""             ""
   add_user_param     "${m_param_prefix}_MAX_DQS_DELAY_NS"              float     0.6                        {0:10.0}         "nanoseconds"   ""             ""             ""
   

   add_derived_param  "${m_param_prefix}_TIS_DERATING_PS"               integer   0                          false        ""            ""            ""            ""
   add_derived_param  "${m_param_prefix}_TIH_DERATING_PS"               integer   0                          false        ""            ""            ""            ""

   add_derived_param  "${m_param_prefix}_CK_SLEW_RATE"                  float     $ck_slew_rate_default      true         ""            "V/ns"        ""            "${m_param_prefix}_USER_CK_SLEW_RATE"    
   add_derived_param  "${m_param_prefix}_AC_SLEW_RATE"                  float     $ac_slew_rate_default      true         ""            "V/ns"        ""            "${m_param_prefix}_USER_AC_SLEW_RATE"    
   add_derived_param  "${m_param_prefix}_RCLK_SLEW_RATE"                float     $rclk_slew_rate_default    true         ""            "V/ns"        ""            "${m_param_prefix}_USER_RCLK_SLEW_RATE"     
   add_derived_param  "${m_param_prefix}_WCLK_SLEW_RATE"                float     $wclk_slew_rate_default    true         ""            "V/ns"        ""            "${m_param_prefix}_USER_WCLK_SLEW_RATE"     
   add_derived_param  "${m_param_prefix}_RDATA_SLEW_RATE"               float     $rdata_slew_rate_default   true         ""            "V/ns"        ""            "${m_param_prefix}_USER_RDATA_SLEW_RATE"    
   add_derived_param  "${m_param_prefix}_WDATA_SLEW_RATE"               float     $wdata_slew_rate_default   true         ""            "V/ns"        ""            "${m_param_prefix}_USER_WDATA_SLEW_RATE"    

   add_derived_param  "${m_param_prefix}_AC_ISI_NS"                     float     $ac_isi_ns_default         true         "nanoseconds" ""            ""            "${m_param_prefix}_USER_AC_ISI_NS"       
   add_derived_param  "${m_param_prefix}_RCLK_ISI_NS"                   float     $rclk_isi_ns_default       true         "nanoseconds" ""            ""            "${m_param_prefix}_USER_RCLK_ISI_NS"  
   add_derived_param  "${m_param_prefix}_WCLK_ISI_NS"                   float     $wclk_isi_ns_default       true         "nanoseconds" ""            ""            "${m_param_prefix}_USER_WCLK_ISI_NS"     
   add_derived_param  "${m_param_prefix}_RDATA_ISI_NS"                  float     $rdata_isi_ns_default      true         "nanoseconds" ""            ""            "${m_param_prefix}_USER_RDATA_ISI_NS"    
   add_derived_param  "${m_param_prefix}_WDATA_ISI_NS"                  float     $wdata_isi_ns_default      true         "nanoseconds" ""            ""            "${m_param_prefix}_USER_WDATA_ISI_NS"    

   add_derived_param  "${m_param_prefix}_SKEW_WITHIN_DQS_NS"            float     0                          false        ""            ""            ""            ""    
   add_derived_param  "${m_param_prefix}_SKEW_WITHIN_AC_NS"             float     0                          false        ""            ""            ""            "" 
 
   set_parameter_update_callback "PHY_DDR4_MEM_CLK_FREQ_MHZ"       ::altera_emif::ip_top::board::ddr4::_update_slew_rates
   set_parameter_update_callback "${m_param_prefix}_USE_DEFAULT_SLEW_RATES" ::altera_emif::ip_top::board::ddr4::_update_slew_rates

   set_parameter_update_callback "MEM_DDR4_NUM_OF_PHYSICAL_RANKS"           ::altera_emif::ip_top::board::ddr4::_update_isi_values
   set_parameter_update_callback "${m_param_prefix}_USE_DEFAULT_ISI_VALUES" ::altera_emif::ip_top::board::ddr4::_update_isi_values
   
   set_parameter_update_callback "MEM_DDR4_NUM_OF_PHYSICAL_RANKS"           ::altera_emif::ip_top::board::ddr4::_grey_out_board_values

   return 1
}

proc ::altera_emif::ip_top::board::ddr4::set_family_specific_defaults {family_enum base_family_enum is_hps} {
   variable m_param_prefix
   
   return 1
}

proc ::altera_emif::ip_top::board::ddr4::add_display_items {tabs} {
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
   add_param_to_gui $skews_grp "${m_param_prefix}_IS_SKEW_WITHIN_DQS_DESKEWED"   
   add_param_to_gui $skews_grp "${m_param_prefix}_BRD_SKEW_WITHIN_DQS_NS"   
   add_param_to_gui $skews_grp "${m_param_prefix}_PKG_BRD_SKEW_WITHIN_DQS_NS"   
   add_param_to_gui $skews_grp "${m_param_prefix}_IS_SKEW_WITHIN_AC_DESKEWED"   
   add_param_to_gui $skews_grp "${m_param_prefix}_BRD_SKEW_WITHIN_AC_NS"           
   add_param_to_gui $skews_grp "${m_param_prefix}_PKG_BRD_SKEW_WITHIN_AC_NS"         
   
   add_text_to_gui  $skews_grp "${m_param_prefix}_INTRABUS_SKEWS_TXT_1" "<html><br><b>Interbus skews (skew among buses):</b><br>" 
   add_param_to_gui $skews_grp "${m_param_prefix}_DQS_TO_CK_SKEW_NS"    
   add_param_to_gui $skews_grp "${m_param_prefix}_SKEW_BETWEEN_DIMMS_NS"
   add_param_to_gui $skews_grp "${m_param_prefix}_SKEW_BETWEEN_DQS_NS"  
   add_param_to_gui $skews_grp "${m_param_prefix}_AC_TO_CK_SKEW_NS"     
   
   add_text_to_gui  $skews_grp "${m_param_prefix}_INTRABUS_SKEWS_TXT_2" "<html><br><b>Signal delays:</b><br>" 
   add_param_to_gui $skews_grp "${m_param_prefix}_MAX_CK_DELAY_NS"      
   add_param_to_gui $skews_grp "${m_param_prefix}_MAX_DQS_DELAY_NS"     
   
   return 1
}

proc ::altera_emif::ip_top::board::ddr4::validate {} {
   variable m_param_prefix
   
   set speedbin_enum      [get_parameter_value "MEM_DDR4_SPEEDBIN_ENUM"]
   set speedbin           [enum_data $speedbin_enum VALUE]
   
   set io_voltage         [get_parameter_value PHY_DDR4_IO_VOLTAGE]
   set tis_ac_mv          [get_parameter_value MEM_DDR4_TIS_AC_MV]
   set tih_dc_mv          [get_parameter_value MEM_DDR4_TIH_DC_MV]

   set ck_slew_rate       [get_parameter_value "${m_param_prefix}_CK_SLEW_RATE"]
   set ac_slew_rate       [get_parameter_value "${m_param_prefix}_AC_SLEW_RATE"]
   set dqs_slew_rate      [get_parameter_value "${m_param_prefix}_WCLK_SLEW_RATE"]
   set dq_slew_rate       [get_parameter_value "${m_param_prefix}_USER_WDATA_SLEW_RATE"]
   
   set ck_slew_rates      [_table_ck_slew_rates  $speedbin]
   set ac_slew_rates      [_table_ac_slew_rates  $speedbin]
   set dqs_slew_rates     [_table_dqs_slew_rates $speedbin]
   set dq_slew_rates      [_table_dq_slew_rates  $speedbin]
   
   set table_delta_tIS    [_table_delta_tIS $speedbin $io_voltage $tis_ac_mv]
   set table_delta_tIH    [_table_delta_tIH $speedbin $io_voltage $tih_dc_mv]
   
   set delta_tIS_ps       [derating_table_lookup $ac_slew_rates $ck_slew_rates  $table_delta_tIS $ac_slew_rate $ck_slew_rate  MEM_DDR4_TIS_AC_MV]
   set delta_tIH_ps       [derating_table_lookup $ac_slew_rates $ck_slew_rates  $table_delta_tIH $ac_slew_rate $ck_slew_rate  MEM_DDR4_TIH_DC_MV]

   set delta_tIS_ps [expr {round($delta_tIS_ps)}]  
   set delta_tIH_ps [expr {round($delta_tIH_ps)}]  
   

   set_parameter_value "${m_param_prefix}_TIS_DERATING_PS" $delta_tIS_ps
   set_parameter_value "${m_param_prefix}_TIH_DERATING_PS" $delta_tIH_ps
   
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
   
  
   set pkg_DQS_deskewed    [get_parameter_value "${m_param_prefix}_IS_SKEW_WITHIN_DQS_DESKEWED"]
   set pkg_AC_deskewed     [get_parameter_value "${m_param_prefix}_IS_SKEW_WITHIN_AC_DESKEWED"]
   set_parameter_property  "${m_param_prefix}_BRD_SKEW_WITHIN_DQS_NS"         VISIBLE         [expr {!$pkg_DQS_deskewed}]
   set_parameter_property  "${m_param_prefix}_PKG_BRD_SKEW_WITHIN_DQS_NS"     VISIBLE         [expr {$pkg_DQS_deskewed}]
   set_parameter_property  "${m_param_prefix}_BRD_SKEW_WITHIN_AC_NS"          VISIBLE         [expr {!$pkg_AC_deskewed}]
   set_parameter_property  "${m_param_prefix}_PKG_BRD_SKEW_WITHIN_AC_NS"      VISIBLE         [expr {$pkg_AC_deskewed}]
   
   if { $pkg_DQS_deskewed } {
      set_parameter_value      "${m_param_prefix}_SKEW_WITHIN_DQS_NS"             [get_parameter_value "${m_param_prefix}_PKG_BRD_SKEW_WITHIN_DQS_NS"]
   } else {
	  set dq_per_dqs       [get_parameter_value MEM_DDR4_DQ_PER_DQS]
      set_parameter_value      "${m_param_prefix}_SKEW_WITHIN_DQS_NS"             [expr {[get_parameter_value "${m_param_prefix}_BRD_SKEW_WITHIN_DQS_NS"] + [enum_data  "PINS_${dq_per_dqs}" PKG_SKEW]}]
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


proc ::altera_emif::ip_top::board::ddr4::_table_ac_slew_rates {speedbin} {
   return {2.0 1.5 1.0 0.9 0.8 0.7 0.6 0.5 0.4}
}

proc ::altera_emif::ip_top::board::ddr4::_table_ck_slew_rates {speedbin} {
   return {4.0 3.0 2.0 1.8 1.6 1.4 1.2 1.0}
}

proc ::altera_emif::ip_top::board::ddr4::_table_dq_slew_rates {speedbin} {
   if {$speedbin < 1866} {
      return {2.0 1.5 1.0 0.9 0.8 0.7 0.6 0.5 0.4}
   } else {
      return {4.0 3.5 3.0 2.5 2.0 1.5 1.0 0.9 0.8 0.7 0.6 0.5 0.4}
   }
}

proc ::altera_emif::ip_top::board::ddr4::_table_dqs_slew_rates {speedbin} {
   if {$speedbin < 1866} {
      return {4.0 3.0 2.0 1.8 1.6 1.4 1.2 1.0}
   } else {
      return {8.0 7.0 6.0 5.0 4.0 3.0 2.0 1.8 1.6 1.4 1.2 1.0}
   }
}

proc ::altera_emif::ip_top::board::ddr4::_table_delta_tIS {speedbin io_voltage tis_ac_mv} {
   if {$io_voltage == 1.2} {
      switch $tis_ac_mv {
         100 {
            return {{  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0}}
         }
         default {
            return [list]
         }
      }
   } else {
      return [list]
   }
}

proc ::altera_emif::ip_top::board::ddr4::_table_delta_tIH {speedbin io_voltage tih_dc_mv} {
   if {$io_voltage == 1.2} {
      switch $tih_dc_mv {
         75 {
            return {{  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0}}
         }
         default {
            return [list]
         }
      }
   } else {
      return [list]
   }
}

proc ::altera_emif::ip_top::board::ddr4::_table_delta_tDS {speedbin io_voltage tds_ac_mv} {
   if {$io_voltage == 1.2} {
      switch $tds_ac_mv {
         100 {
            return {{  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0}}
         }
         default {
            return [list]
         }
      }
   } else {
      return [list]
   }
}

proc ::altera_emif::ip_top::board::ddr4::_table_delta_tDH {speedbin io_voltage tdh_dc_mv} {
   
   if {$io_voltage == 1.2} {
      switch $tdh_dc_mv {
         75 {
            return {{  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0} \
                    {  0   0   0   0   0   0   0   0}}
         }
         default {
            return [list]
         }
      }
   } else {
      return [list]
   }
}

proc ::altera_emif::ip_top::board::ddr4::_check_derating_table_integrity {tbl} {

   set rows [llength $tbl]
   emif_assert {$rows > 0}
   
   set cols [llength [lindex $tbl 0]]
   emif_assert {$cols > 0}
   
   for {set r 0} {$r < $rows} {incr r} {
      set row [lindex $tbl $r]
      set tmp [llength $row]
      emif_assert {$cols == $tmp}
      
      for {set c 0} {$c < $cols} {incr c} {
         set val [lindex $row $c]
         emif_assert {$val >= -999}
         emif_assert {$val <= 999}
      }
   }
}

proc ::altera_emif::ip_top::board::ddr4::_update_slew_rates {arg} {
   variable m_param_prefix

   set gui_triggered [expr {$arg != ""}]
   
   set use_default [get_parameter_value "${m_param_prefix}_USE_DEFAULT_SLEW_RATES"]

   if {$use_default || $gui_triggered} {
      set mem_freq     [get_parameter_value "PHY_DDR4_MEM_CLK_FREQ_MHZ"]
      set ping_pong_en [get_parameter_value "PHY_DDR4_PING_PONG_EN"]

      if {$mem_freq >= 1333} {
         set rdata_slew 4
      } else {
         set rdata_slew 4
      }

      if {$mem_freq >= 1600} {
         set wdata_slew 4
      } else {
         set wdata_slew 2
      }
      
      if {$mem_freq >= 1600} {
         set ck_slew_rate_default   8.0
         set ac_slew_rate_default   4.0
      } else {
         set ck_slew_rate_default   4.0
         set ac_slew_rate_default   2.0
      }

      if {$ping_pong_en} {
         set ck_slew_rate_default  [expr {$ck_slew_rate_default/2}]
      }

      set rclk_slew_rate_default  8.0
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


proc ::altera_emif::ip_top::board::ddr4::_update_isi_values {arg} {
   variable m_param_prefix
   
   set gui_triggered [expr {$arg != ""}]
   
   set use_default [get_parameter_value "${m_param_prefix}_USE_DEFAULT_ISI_VALUES"]
   
   if {$use_default || $gui_triggered} {

      set num_total_ranks     [get_parameter_value "MEM_DDR4_NUM_OF_PHYSICAL_RANKS"]
      set num_slots           [get_parameter_value "MEM_DDR4_NUM_OF_DIMMS"]
      set format_enum         [get_parameter_value "MEM_DDR4_FORMAT_ENUM"]

      if {$format_enum == "MEM_FORMAT_DISCRETE"} {
         set format_string "Device"
         set rank_string $num_total_ranks 
      } else {      
         if {$format_enum == "MEM_FORMAT_RDIMM"} {
           set format_string "RDIMM"
         } elseif {$format_enum == "MEM_FORMAT_LRDIMM"} {
           set format_string "LRDIMM"
         } elseif {$format_enum == "MEM_FORMAT_UDIMM"} {
            set format_string "UDIMM"
         } elseif {$format_enum == "MEM_FORMAT_SODIMM"} {
            set format_string "UDIMM"
         } else {
            emif_ie "Unsupported format $format_enum"
         }
         set rank_string "${num_total_ranks}_rank_${num_slots}_slot"
      }

      set family_enum [get_device_family_enum]
      set base_family_enum [enum_data $family_enum BASE_FAMILY_ENUM]

      set wdata_isi_ns [altera_emif::util::channel_uncertainty::get_global_channel_uncertainty_value $base_family_enum "DDR4" $format_string "tCE_DQ_DQS_WT_RANK" $rank_string]
      set rdata_isi_ns [altera_emif::util::channel_uncertainty::get_global_channel_uncertainty_value $base_family_enum "DDR4" $format_string "tCE_DQ_DQS_RD_RANK" $rank_string]
      set wclk_isi_ns  [altera_emif::util::channel_uncertainty::get_global_channel_uncertainty_value $base_family_enum "DDR4" $format_string "tCE_DQS_CK_RANK" $rank_string]
      set ac_isi_ns    [altera_emif::util::channel_uncertainty::get_global_channel_uncertainty_value $base_family_enum "DDR4" $format_string "tCE_CA_CK_RANK" $rank_string]
      set rclk_isi_ns  [altera_emif::util::channel_uncertainty::get_global_channel_uncertainty_value $base_family_enum "DDR4" $format_string "tCE_DQS_RANK" $rank_string]

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

proc ::altera_emif::ip_top::board::ddr4::_grey_out_board_values {arg} {
   variable m_param_prefix
   
   set num_total_ranks     [get_parameter_value "MEM_DDR4_NUM_OF_PHYSICAL_RANKS"]
      
   if {$num_total_ranks > 1} {
      set_parameter_property  "${m_param_prefix}_SKEW_BETWEEN_DIMMS_NS"              ENABLED         true
   } else {
      set_parameter_property  "${m_param_prefix}_SKEW_BETWEEN_DIMMS_NS"              ENABLED         false
   }

   return 1
}


proc ::altera_emif::ip_top::board::ddr4::_init {} {

   if {[emif_utest_enabled]} {   
   
      emif_utest_start "::altera_emif::ip_top::board::ddr4"
   
      
      foreach speedbin_enum [enums_of_type DDR4_SPEEDBIN] {
         set speedbin    [enum_data $speedbin_enum VALUE]
         
         foreach io_voltage [enum_data $speedbin_enum ALLOWED_VOLTAGES] {
            set DDR4_acdc_enum "DDR4_ACDC_DDR4_$speedbin"
      
            foreach allowed_val [enum_data $DDR4_acdc_enum ALLOWED_TIS_AC] {
               set tbl [_table_delta_tIS $speedbin $io_voltage $allowed_val]
               
               emif_assert { [llength $tbl] != 0 } \
                  "Missing derating table for tIS for speedbin $speedbin at ${io_voltage}V and AC level of $allowed_val mV"
               
               _check_derating_table_integrity $tbl
            }
            
            foreach allowed_val [enum_data $DDR4_acdc_enum ALLOWED_TIH_DC] {
               set tbl [_table_delta_tIH $speedbin $io_voltage $allowed_val]
               
               emif_assert { [llength $tbl] != 0 } \
                  "Missing derating table for tIH for speedbin $speedbin at ${io_voltage}V and DC level of $allowed_val mV"
                  
               _check_derating_table_integrity $tbl
            }
         }
      }
      
      emif_utest_pass 
   }   
}

::altera_emif::ip_top::board::ddr4::_init
