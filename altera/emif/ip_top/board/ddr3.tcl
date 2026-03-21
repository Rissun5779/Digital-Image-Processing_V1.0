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


package provide altera_emif::ip_top::board::ddr3 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::math
package require altera_emif::util::enums
package require altera_emif::util::device_family
package require altera_emif::util::channel_uncertainty
package require altera_emif::ip_top::util

namespace eval ::altera_emif::ip_top::board::ddr3:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_emif::ip_top::util::*

   
   variable m_param_prefix "BOARD_DDR3"
}


proc ::altera_emif::ip_top::board::ddr3::create_parameters {is_top_level_component} {
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

   add_user_param     "${m_param_prefix}_IS_SKEW_WITHIN_DQS_DESKEWED"   boolean   false                      ""               ""              ""             ""            ""
   add_user_param     "${m_param_prefix}_BRD_SKEW_WITHIN_DQS_NS"        float     0.020                      {0:10.0}         "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_PKG_BRD_SKEW_WITHIN_DQS_NS"    float     0.020                      {0:10.0}         "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_IS_SKEW_WITHIN_AC_DESKEWED"    boolean   true                       ""               ""              ""             ""            ""
   add_user_param     "${m_param_prefix}_BRD_SKEW_WITHIN_AC_NS"         float     0.020                      {0:10.0}         "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_PKG_BRD_SKEW_WITHIN_AC_NS"     float     0.020                      {0:10.0}         "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_DQS_TO_CK_SKEW_NS"             float     0.020                      ""               "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_SKEW_BETWEEN_DIMMS_NS"         float     0.05                       {0:10.0}         "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_SKEW_BETWEEN_DQS_NS"           float     0.020                      {0:10.0}         "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_AC_TO_CK_SKEW_NS"              float     0.0                        ""               "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_MAX_CK_DELAY_NS"               float     0.6                        {0:10.0}         "nanoseconds"   ""             ""            ""
   add_user_param     "${m_param_prefix}_MAX_DQS_DELAY_NS"              float     0.6                        {0:10.0}         "nanoseconds"   ""             ""            ""
   

   add_derived_param  "${m_param_prefix}_TIS_DERATING_PS"               integer   0                          false      ""            ""            ""            ""
   add_derived_param  "${m_param_prefix}_TIH_DERATING_PS"               integer   0                          false      ""            ""            ""            ""
   add_derived_param  "${m_param_prefix}_TDS_DERATING_PS"               integer   0                          false      ""            ""            ""            ""
   add_derived_param  "${m_param_prefix}_TDH_DERATING_PS"               integer   0                          false      ""            ""            ""            ""

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
   
   add_derived_param  "${m_param_prefix}_SKEW_WITHIN_DQS_NS"            float     0                          false      ""            ""            ""            ""    
   add_derived_param  "${m_param_prefix}_SKEW_WITHIN_AC_NS"             float     0                          false      ""            ""            ""            ""    
   
   set_parameter_update_callback "PHY_DDR3_MEM_CLK_FREQ_MHZ"       ::altera_emif::ip_top::board::ddr3::_update_slew_rates
   set_parameter_update_callback "${m_param_prefix}_USE_DEFAULT_SLEW_RATES" ::altera_emif::ip_top::board::ddr3::_update_slew_rates

   set_parameter_update_callback "MEM_DDR3_NUM_OF_PHYSICAL_RANKS"           ::altera_emif::ip_top::board::ddr3::_update_isi_values
   set_parameter_update_callback "${m_param_prefix}_USE_DEFAULT_ISI_VALUES" ::altera_emif::ip_top::board::ddr3::_update_isi_values
   
   set_parameter_update_callback "MEM_DDR3_NUM_OF_PHYSICAL_RANKS"           ::altera_emif::ip_top::board::ddr3::_grey_out_board_values

   return 1
}

proc ::altera_emif::ip_top::board::ddr3::set_family_specific_defaults {family_enum base_family_enum is_hps} {
   variable m_param_prefix
   
   return 1
}

proc ::altera_emif::ip_top::board::ddr3::add_display_items {tabs} {
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

proc ::altera_emif::ip_top::board::ddr3::validate {} {
   variable m_param_prefix
   
   set speedbin_enum      [get_parameter_value "MEM_DDR3_SPEEDBIN_ENUM"]
   set speedbin           [enum_data $speedbin_enum VALUE]
   
   set io_voltage         [get_parameter_value PHY_DDR3_IO_VOLTAGE]
   set tis_ac_mv          [get_parameter_value MEM_DDR3_TIS_AC_MV]
   set tih_dc_mv          [get_parameter_value MEM_DDR3_TIH_DC_MV]
   set tds_ac_mv          [get_parameter_value MEM_DDR3_TDS_AC_MV]
   set tdh_dc_mv          [get_parameter_value MEM_DDR3_TDH_DC_MV]

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
   set table_delta_tDS    [_table_delta_tDS $speedbin $io_voltage $tds_ac_mv]
   set table_delta_tDH    [_table_delta_tDH $speedbin $io_voltage $tdh_dc_mv]
   
   set delta_tIS_ps       [derating_table_lookup $ac_slew_rates $ck_slew_rates  $table_delta_tIS $ac_slew_rate $ck_slew_rate  MEM_DDR3_TIS_AC_MV]
   set delta_tIH_ps       [derating_table_lookup $ac_slew_rates $ck_slew_rates  $table_delta_tIH $ac_slew_rate $ck_slew_rate  MEM_DDR3_TIH_DC_MV]
   set delta_tDS_ps       [derating_table_lookup $dq_slew_rates $dqs_slew_rates $table_delta_tDS $dq_slew_rate $dqs_slew_rate MEM_DDR3_TDS_AC_MV]
   set delta_tDH_ps       [derating_table_lookup $dq_slew_rates $dqs_slew_rates $table_delta_tDH $dq_slew_rate $dqs_slew_rate MEM_DDR3_TDH_DC_MV]

   set delta_tIS_ps [expr {round($delta_tIS_ps)}]  
   set delta_tIH_ps [expr {round($delta_tIH_ps)}]  
   set delta_tDS_ps [expr {round($delta_tDS_ps)}]  
   set delta_tDH_ps [expr {round($delta_tDH_ps)}]  
   

   set_parameter_value "${m_param_prefix}_TIS_DERATING_PS" 0
   set_parameter_value "${m_param_prefix}_TIH_DERATING_PS" 0
   set_parameter_value "${m_param_prefix}_TDS_DERATING_PS" 0
   set_parameter_value "${m_param_prefix}_TDH_DERATING_PS" 0

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
	  set dq_per_dqs       [get_parameter_value MEM_DDR3_DQ_PER_DQS]
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


proc ::altera_emif::ip_top::board::ddr3::_table_ac_slew_rates {speedbin} {
   return {2.0 1.5 1.0 0.9 0.8 0.7 0.6 0.5 0.4}
}

proc ::altera_emif::ip_top::board::ddr3::_table_ck_slew_rates {speedbin} {
   return {4.0 3.0 2.0 1.8 1.6 1.4 1.2 1.0}
}

proc ::altera_emif::ip_top::board::ddr3::_table_dq_slew_rates {speedbin} {
   if {$speedbin < 1866} {
      return {2.0 1.5 1.0 0.9 0.8 0.7 0.6 0.5 0.4}
   } else {
      return {4.0 3.5 3.0 2.5 2.0 1.5 1.0 0.9 0.8 0.7 0.6 0.5 0.4}
   }
}

proc ::altera_emif::ip_top::board::ddr3::_table_dqs_slew_rates {speedbin} {
   if {$speedbin < 1866} {
      return {4.0 3.0 2.0 1.8 1.6 1.4 1.2 1.0}
   } else {
      return {8.0 7.0 6.0 5.0 4.0 3.0 2.0 1.8 1.6 1.4 1.2 1.0}
   }
}

proc ::altera_emif::ip_top::board::ddr3::_table_delta_tIS {speedbin io_voltage tis_ac_mv} {
   if {$io_voltage == 1.5} {
      switch $tis_ac_mv {
         175 {
            return {{ 88  88  88  96 104 112 120 128} \
                    { 59  59  59  67  75  83  91  99} \
                    {  0   0   0   8  16  24  32  40} \
                    { -2  -2  -2   6  14  22  30  38} \
                    { -6  -6  -6   2  10  18  26  34} \
                    {-11 -11 -11  -3   5  13  21  29} \
                    {-17 -17 -17  -9  -1   7  15  23} \
                    {-35 -35 -35 -27 -19 -11  -2   5} \
                    {-62 -62 -62 -54 -46 -38 -30 -22}}
         }
         150 {
            return {{ 75  75  75  83  91  99 107 115} \
                    { 50  50  50  58  66  74  82  90} \
                    {  0   0   0   8  16  24  32  40} \
                    {  0   0   0   8  16  24  32  40} \
                    {  0   0   0   8  16  24  32  40} \
                    {  0   0   0   8  16  24  32  40} \
                    { -1  -1  -1   7  15  23  31  39} \
                    {-10 -10 -10  -2   6  14  22  30} \
                    {-25 -25 -25 -17  -9  -1   7  15}}
         }
         135 {
            return {{ 68  68  68  76  84  92 100 100} \
                    { 45  45  45  53  61  69  77  85} \
                    {  0   0   0   8  16  24  32  40} \
                    {  2   2   2  10  18  26  34  42} \
                    {  3   3   3  11  19  27  35  43} \
                    {  6   6   6  14  22  30  38  46} \
                    {  9   9   9  17  25  33  41  49} \
                    {  5   5   5  13  21  29  37  45} \
                    { -3  -3  -3   6  14  22  30  38}}
         }
         125 {
            return {{ 63  63  63  71  79  87  95  103} \
                    { 42  42  42  50  58  66  74   82} \
                    {  0   0   0   8  16  24  32   40} \
                    {  4   4   4  12  20  28  36   44} \
                    {  6   6   6  14  22  30  38   46} \
                    { 11  11  11  19  27  35  43   51} \
                    { 16  16  16  24  32  40  48   56} \
                    { 15  15  15  23  31  39  47   55} \
                    { 13  13  13  21  29  37  45   53}}
         }
         default {
            return [list]
         }
      }
   } elseif {$io_voltage == 1.35} {
      switch $tis_ac_mv {
         160 {
            return {{ 80  80  80  88  96 104 112 120} \
                    { 53  53  53  61  69  77  85  93} \
                    {  0   0   0   8  16  24  32  40} \
                    { -1  -1  -1   7  15  23  31  39} \
                    { -3  -3  -3   5  13  21  29  37} \
                    { -5  -5  -5   3  11  19  27  35} \
                    { -8  -8  -8   0   8  16  24  32} \
                    {-20 -20 -20 -12  -4   4  12  20} \
                    {-40 -40 -40 -32 -24 -16  -8   0}}         
         }
         135 {
            return {{ 68  68  45  76  84  92 100 108} \
                    { 45  45  30  53  61  69  77  85} \
                    {  0   0   0   8  16  24  32  40} \
                    {  2   2   2  10  18  26  34  42} \
                    {  3   3   3  11  19  27  35  43} \
                    {  6   6   6  14  22  30  38  46} \
                    {  9   9   9  17  25  33  41  49} \
                    {  5   5   5  13  21  29  37  45} \
                    { -3  -3  -3   6  14  22  30  38}}         
         }
         125 {
            return {{ 63  63  63  71  79  87  95 103} \
                    { 42  42  42  50  58  66  74  82} \
                    {  0   0   0   8  16  24  32  40} \
                    {  3   3   3  11  19  27  35  43} \
                    {  6   6   6  14  22  30  38  46} \
                    { 10  10  10  18  26  34  42  50} \
                    { 16  16  16  24  32  40  48  56} \
                    { 15  15  15  23  31  39  47  55} \
                    { 13  13  13  21  29  37  45  53}}
         }
         default {
            return [list]
         }
      }
   } elseif {$io_voltage == 1.25} {
      switch $tis_ac_mv {
         150 {
            return {{  75  75  75  81  87  93  99 105} \
                    {  50  50  50  59  65  71  77  83} \
                    {   0   0   0   8  16  22  28  34} \
                    {   0   0   0   8  16  24  30  36} \
                    {  -1  -1  -1   8  16  24  32  38} \
                    {   0   0   0   8  16  24  32  40} \
                    {  -1  -1  -1   7  15  23  31  39} \
                    { -10 -10 -10  -2   6  14  22  30} \
                    { -25 -25 -25 -12  -9  -1   7  15}}
         }
         130 {
            return {{ 65  65  65  71  77  83  89  95} \
                    { 44  44  44  53  59  65  71  76} \
                    {  0   0   0   8  16  22  28  34} \
                    {  3   3   3  11  19  27  33  39} \
                    {  5   5   5  13  21  29  37  43} \
                    {  8   8   8  16  24  32  40  48} \
                    { 12  12  12  20  28  36  44  52} \
                    { 10  10  10  18  26  34  42  50} \
                    {  5   5   5  13  21  29  37  45}}            
         }
         default {
            return [list]
         }
      }
   } else {
      return [list]
   }
}

proc ::altera_emif::ip_top::board::ddr3::_table_delta_tIH {speedbin io_voltage tih_dc_mv} {
   if {$io_voltage == 1.5} {
      switch $tih_dc_mv {
         100 {
            return {{ 50  50  50  58  66  74  84 100} \
                    { 34  34  34  42  50  58  68  84} \
                    {  0   0   0   8  16  24  34  50} \
                    { -4  -4  -4   4  12  20  30  46} \
                    {-10 -10 -10  -2   6  14  24  40} \
                    {-16 -16 -16  -8   0   8  18  34} \
                    {-26 -26 -26 -18 -10  -2   8  24} \
                    {-40 -40 -40 -32 -24 -16  -6  10} \
                    {-60 -60 -60 -52 -44 -36 -26 -10}}
         }
         default {
            return [list]
         }
      }
   } elseif {$io_voltage == 1.35} {
      switch $tih_dc_mv {
         90 {
            return {{ 45  45  45  53  61  69  79  95} \
                    { 30  30  30  38  46  54  64  80} \
                    {  0   0   0   8  16  24  34  50} \
                    { -3  -3  -3   5  13  21  31  47} \
                    { -8  -8  -8   1   9  17  27  43} \
                    {-13 -13 -13  -5   3  11  21  37} \
                    {-20 -20 -20 -12  -4   4  14  30} \
                    {-30 -30 -30 -22 -14  -6   4  20} \
                    {-45 -45 -45 -37 -29 -21 -11   5}}     
         }
         default {
            return [list]
         }
      }
   } elseif {$io_voltage == 1.25} {
      switch $tih_dc_mv {
         90 {
            return {{  45   45   45   53   61   69   79  95 } \
                    {  30   30   30   38   46   54   64  80 } \
                    {   0    0    0    8   16   24   34  50 } \
                    {  -3   -3   -3    5   13   21   31  47 } \
                    {  -8   -8   -8    1    9   17   27  43 } \
                    { -13  -13  -13   -5    3   11   21  37 } \
                    { -20  -20  -20  -12   -4    4   14  30 } \
                    { -30  -30  -30  -22  -14   -6    4  20 } \
                    { -45  -45  -45  -37  -29  -21  -11   5 }}
         }
         default {
            return [list]
         }
      }
   } else {
      return [list]
   }
}

proc ::altera_emif::ip_top::board::ddr3::_table_delta_tDS {speedbin io_voltage tds_ac_mv} {
   if {$io_voltage == 1.5} {
      switch $tds_ac_mv {
         175 {
            return {{   88    88    88   999   999   999   999   999} \
                    {   59    59    59    67   999   999   999   999} \
                    {    0     0     0     8    16   999   999   999} \
                    { -999    -2    -2     6    14    22   999   999} \
                    { -999  -999    -6     2    10    18    26   999} \
                    { -999  -999  -999    -3     5    13    21    29} \
                    { -999  -999  -999  -999    -1     7    15    23} \
                    { -999  -999  -999  -999  -999   -11    -2     5} \
                    { -999  -999  -999  -999  -999  -999   -30   -22}}         
         }
         150 {
            return {{   75    75    75   999   999   999   999   999} \
                    {   50    50    50    58   999   999   999   999} \
                    {    0     0     0     8    16   999   999   999} \
                    { -999     0     0     8    16    24   999   999} \
                    { -999  -999     0     8    16    24    32   999} \
                    { -999  -999  -999     8    16    24    32    40} \
                    { -999  -999  -999  -999    15    23    31    39} \
                    { -999  -999  -999  -999  -999    14    22    30} \
                    { -999  -999  -999  -999  -999  -999     7    15}}         
         }
         135 {
            if {$speedbin < 1866} {
               return {{   68    68    68   999   999   999   999   999} \
                       {   45    45    45    53   999   999   999   999} \
                       {    0     0     0     8    16   999   999   999} \
                       { -999     2     2    10    18    26   999   999} \
                       { -999  -999     3    11    19    27    35   999} \
                       { -999  -999  -999    14    22    30    38    46} \
                       { -999  -999  -999  -999    25    33    41    49} \
                       { -999  -999  -999  -999  -999    29    37    45} \
                       { -999  -999  -999  -999  -999  -999    30    38}}            
            } else {
               return {{   34    34    34   999   999  999  999  999  999  999  999  999 } \
                       {   29    29    29    29   999  999  999  999  999  999  999  999 } \
                       {   23    23    23    23    23  999  999  999  999  999  999  999 } \
                       { -999    14    14    14    14   14  999  999  999  999  999  999 } \
                       { -999  -999     0     0     0    0    0  999  999  999  999  999 } \
                       { -999  -999  -999   -23   -23  -23  -23  -15  999  999  999  999 } \
                       { -999  -999  -999  -999   -68  -68  -68  -60  -52  999  999  999 } \
                       { -999  -999  -999  -999  -999  -66  -66  -58  -50  -42  999  999 } \
                       { -999  -999  -999  -999  -999 -999  -64  -56  -48  -40  -32  999 } \
                       { -999  -999  -999  -999  -999 -999 -999  -53  -45  -37  -29  -21 } \
                       { -999  -999  -999  -999  -999 -999 -999 -999  -43  -35  -27  -19 } \
                       { -999  -999  -999  -999  -999 -999 -999 -999 -999  -39  -31  -23 } \
                       { -999  -999  -999  -999  -999 -999 -999 -999 -999 -999  -38  -30 }}            
            }
         }
         default {
            return [list]
         }
      }
   } elseif {$io_voltage == 1.35} {
      switch $tds_ac_mv {
         160 {
            return {{  80   80   80  999  999  999  999  999} \
                    {  53   53   53   61  999  999  999  999} \
                    {   0    0    0    8   16  999  999  999} \
                    {-999   -1   -1    7   15   23  999  999} \
                    {-999 -999   -3    5   13   21   29  999} \
                    {-999 -999 -999   -3   11   19   27   35} \
                    {-999 -999 -999 -999    8   16   24   32} \
                    {-999 -999 -999 -999 -999    4   12   20} \
                    {-999 -999 -999 -999 -999 -999   -8    0}}         
         }
         135 {
            return {{  68   68   68  999  999  999  999  999} \
                    {  45   45   45   53  999  999  999  999} \
                    {   0    0    0    8   16  999  999  999} \
                    {-999    2    2   10   18   26  999  999} \
                    {-999 -999    3   11   19   27   35  999} \
                    {-999 -999 -999   14   22   30   38   46} \
                    {-999 -999 -999 -999   25   33   41   49} \
                    {-999 -999 -999 -999 -999   39   37   45} \
                    {-999 -999 -999 -999 -999 -999   30   38}}
         }
         130 {
            return {{  33    33    33   999   999   999   999   999   999   999  999  999} \
                    {  28    28    28    28   999   999   999   999   999   999  999  999} \
                    {  22    22    22    22    22   999   999   999   999   999  999  999} \
                    {-999    13    13    13    13    13   999   999   999   999  999  999} \
                    {-999  -999     0     0     0     0     0   999   999   999  999  999} \
                    {-999  -999  -999   -22   -22   -22   -22   -14   999   999  999  999} \
                    {-999  -999  -999  -999   -65   -65   -65   -57   -49   999  999  999} \
                    {-999  -999  -999  -999  -999   -62   -62   -54   -46   -38  999  999} \
                    {-999  -999  -999  -999  -999  -999   -61   -53   -45   -37  -29  999} \
                    {-999  -999  -999  -999  -999  -999  -999   -49   -41   -33  -25  -17} \
                    {-999  -999  -999  -999  -999  -999  -999  -999   -37   -29  -21  -13} \
                    {-999  -999  -999  -999  -999  -999  -999  -999  -999   -31  -23  -15} \
                    {-999  -999  -999  -999  -999  -999  -999  -999  -999  -999  -28  -20}}
         }
         default {
            return [list]
         }
      }
   } elseif {$io_voltage == 1.25} {
      switch $tds_ac_mv {
         150 {
            return {{   75    75    75   999  999    999  999  999} \
                    {   50    50    50    59  999    999  999  999} \
                    {    0     0     0     8   16    999  999  999} \
                    { -999     0     0     8   16     24  999  999} \
                    { -999  -999    -1     8   16     24   32  999} \
                    { -999  -999  -999     8   16     24   32   40} \
                    { -999  -999  -999  -999   15     23   31   39} \
                    { -999  -999  -999  -999  -999    14   22   30} \
                    { -999  -999  -999  -999  -999  -999    7   15}}
         }
         130 {
            return {{   65    65    65   999   999   999  999  999} \
                    {   44    44    44    53   999   999  999  999} \
                    {    0     0     0     8    16   999  999  999} \
                    { -999     3     3    11    19    27  999  999} \
                    { -999  -999     5    13    21    29   37  999} \
                    { -999  -999  -999    16    24    32   40   48} \
                    { -999  -999  -999  -999    28    36   44   52} \
                    { -999  -999  -999  -999  -999    34   42   50} \
                    { -999  -999  -999  -999  -999  -999   37   45}}
         }
         default {
            return [list]
         }
      }
   } else {
      return [list]
   }
}

proc ::altera_emif::ip_top::board::ddr3::_table_delta_tDH {speedbin io_voltage tdh_dc_mv} {
   
   if {$io_voltage == 1.5} {
      switch $tdh_dc_mv {
         100 {
            if {$speedbin < 1866} {
               return {{  50   50   50  999  999  999  999  999} \
                       {  34   34   34   42  999  999  999  999} \
                       {   0    0    0    8   16  999  999  999} \
                       {-999   -4   -4    4   12   20  999  999} \
                       {-999 -999  -10   -2    6   14   24  999} \
                       {-999 -999 -999   -8    0    8   18   34} \
                       {-999 -999 -999 -999  -10   -2    8   24} \
                       {-999 -999 -999 -999 -999  -16   -6   10} \
                       {-999 -999 -999 -999 -999 -999  -26  -10}}         
            } else {
               return {{  25   25    25  999  999  999  999  999  999  999  999  999} \
                       {  21   21    21   21  999  999  999  999  999  999  999  999} \
                       {  17   17    17   17   17  999  999  999  999  999  999  999} \
                       {-999   10    10   10   10   10  999  999  999  999  999  999} \
                       {-999 -999     0    0    0    0    0  999  999  999  999  999} \
                       {-999 -999  -999  -17  -17  -17  -17   -9  999  999  999  999} \
                       {-999 -999  -999 -999  -50  -50  -50  -42  -34  999  999  999} \
                       {-999 -999  -999 -999 -999  -54  -54  -46  -38  -30  999  999} \
                       {-999 -999  -999 -999 -999 -999  -60  -52  -44  -36  -26  999} \
                       {-999 -999  -999 -999 -999 -999 -999  -59  -51  -43  -33  -17} \
                       {-999 -999  -999 -999 -999 -999 -999 -999  -61  -53  -43  -27} \
                       {-999 -999  -999 -999 -999 -999 -999 -999 -999  -66  -56  -40} \
                       {-999 -999  -999 -999 -999 -999 -999 -999 -999 -999  -76  -60}}        
            }         
         }
         default {
            return [list]
         }
      }
   } elseif {$io_voltage == 1.35} {
      switch $tdh_dc_mv {
         90 {
            if {$speedbin < 1866} {
               return {{   45    45    45   999   999   999   999   999} \
                       {   30    30    30    38   999   999   999   999} \
                       {    0     0     0     8    16   999   999   999} \
                       { -999    -3    -3     5    13    21   999   999} \
                       { -999  -999    -8     1     9    17    27   999} \
                       { -999  -999  -999    -5     3    11    21    37} \
                       { -999  -999  -999  -999    -4     4    14    30} \
                       { -999  -999  -999  -999  -999    -6     4    20} \
                       { -999  -999  -999  -999  -999  -999   -11     5}}
            } else {
               return {{  23    23    23   999   999   999   999   999   999   999  999  999} \
                       {  19    19    19    19   999   999   999   999   999   999  999  999} \
                       {  15    15    15    15    15   999   999   999   999   999  999  999} \
                       {-999     9     9     9     9     9   999   999   999   999  999  999} \
                       {-999  -999     0     0     0     0     0   999   999   999  999  999} \
                       {-999  -999  -999   -15   -15   -15   -15    -7   999   999  999  999} \
                       {-999  -999  -999  -999   -45   -45   -45   -37   -29   999  999  999} \
                       {-999  -999  -999  -999  -999   -48   -48   -40   -32   -24  999  999} \
                       {-999  -999  -999  -999  -999  -999   -53   -45   -37   -29  -19  999} \
                       {-999  -999  -999  -999  -999  -999  -999   -50   -42   -34  -24   -8} \
                       {-999  -999  -999  -999  -999  -999  -999  -999   -49   -41  -31  -15} \
                       {-999  -999  -999  -999  -999  -999  -999  -999  -999   -51  -41  -25} \
                       {-999  -999  -999  -999  -999  -999  -999  -999  -999  -999  -56  -40}}
            }
         }
         default {
            return [list]
         }
      }
   } elseif {$io_voltage == 1.25} {
      switch $tdh_dc_mv {
         90 {
            return {{   45    45    45   999   999   999  999  999} \
                    {   30    30    30    38   999   999  999  999} \
                    {    0     0     0     8    16   999  999  999} \
                    { -999    -3    -3     5    13    21  999  999} \
                    { -999  -999    -8     1     9    17   27  999} \
                    { -999  -999  -999    -5     3    11   21   37} \
                    { -999  -999  -999  -999    -4     4   14   30} \
                    { -999  -999  -999  -999  -999    -6    4   20} \
                    { -999  -999  -999  -999  -999  -999  -11   -5}}
         }
         default {
            return [list]
         }
      }
   } else {
      return [list]
   }
}

proc ::altera_emif::ip_top::board::ddr3::_check_derating_table_integrity {tbl} {

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

proc ::altera_emif::ip_top::board::ddr3::_update_slew_rates {arg} {
   variable m_param_prefix
   
   set gui_triggered [expr {$arg != ""}]
   
   set use_default [get_parameter_value "${m_param_prefix}_USE_DEFAULT_SLEW_RATES"]

   if {$use_default || $gui_triggered} {
      set mem_freq  [get_parameter_value "PHY_DDR3_MEM_CLK_FREQ_MHZ"]
      set ping_pong_en [get_parameter_value "PHY_DDR3_PING_PONG_EN"]

      if {$mem_freq >= 933} {
         set rdata_slew 2.5
      } else {
         set rdata_slew 2.5
      }

      set wdata_slew 2
	  
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


proc ::altera_emif::ip_top::board::ddr3::_update_isi_values {arg} {
   variable m_param_prefix
   
   set gui_triggered [expr {$arg != ""}]
   
   set use_default [get_parameter_value "${m_param_prefix}_USE_DEFAULT_ISI_VALUES"]

   if {$use_default || $gui_triggered} {

      set num_total_ranks     [get_parameter_value "MEM_DDR3_NUM_OF_PHYSICAL_RANKS"]
      set num_slots           [get_parameter_value "MEM_DDR3_NUM_OF_DIMMS"]
      set format_enum         [get_parameter_value "MEM_DDR3_FORMAT_ENUM"]

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

      set wdata_isi_ns [altera_emif::util::channel_uncertainty::get_global_channel_uncertainty_value $base_family_enum "DDR3" $format_string "tCE_DQ_DQS_WT_RANK" $rank_string]
      set rdata_isi_ns [altera_emif::util::channel_uncertainty::get_global_channel_uncertainty_value $base_family_enum "DDR3" $format_string "tCE_DQ_DQS_RD_RANK" $rank_string]
      set wclk_isi_ns  [altera_emif::util::channel_uncertainty::get_global_channel_uncertainty_value $base_family_enum "DDR3" $format_string "tCE_DQS_CK_RANK" $rank_string]
      set ac_isi_ns    [altera_emif::util::channel_uncertainty::get_global_channel_uncertainty_value $base_family_enum "DDR3" $format_string "tCE_CA_CK_RANK" $rank_string]
      set rclk_isi_ns  [altera_emif::util::channel_uncertainty::get_global_channel_uncertainty_value $base_family_enum "DDR3" $format_string "tCE_DQS_RANK" $rank_string]

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

proc ::altera_emif::ip_top::board::ddr3::_grey_out_board_values {arg} {
   variable m_param_prefix
   
   set num_total_ranks     [get_parameter_value "MEM_DDR3_NUM_OF_PHYSICAL_RANKS"]
      
   if {$num_total_ranks > 1} {
      set_parameter_property  "${m_param_prefix}_SKEW_BETWEEN_DIMMS_NS"              ENABLED         true
   } else {
      set_parameter_property  "${m_param_prefix}_SKEW_BETWEEN_DIMMS_NS"              ENABLED         false
   }

   return 1
}


proc ::altera_emif::ip_top::board::ddr3::_init {} {

   if {[emif_utest_enabled]} {   
   
      emif_utest_start "::altera_emif::ip_top::board::ddr3"
   
      
      foreach speedbin_enum [enums_of_type DDR3_SPEEDBIN] {
         set speedbin    [enum_data $speedbin_enum VALUE]
         
         foreach io_voltage [enum_data $speedbin_enum ALLOWED_VOLTAGES] {
            if {$io_voltage == 1.5} {
               set ddr3_acdc_enum "DDR3_ACDC_DDR3_$speedbin"
            } elseif {$io_voltage == 1.35} {
               set ddr3_acdc_enum "DDR3_ACDC_DDR3L_$speedbin"
            } else {
               set ddr3_acdc_enum "DDR3_ACDC_DDR3U_$speedbin"
            }
      
            foreach allowed_val [enum_data $ddr3_acdc_enum ALLOWED_TIS_AC] {
               set tbl [_table_delta_tIS $speedbin $io_voltage $allowed_val]
               
               emif_assert { [llength $tbl] != 0 } \
                  "Missing derating table for tIS for speedbin $speedbin at ${io_voltage}V and AC level of $allowed_val mV"
               
               _check_derating_table_integrity $tbl
            }
            
            foreach allowed_val [enum_data $ddr3_acdc_enum ALLOWED_TIH_DC] {
               set tbl [_table_delta_tIH $speedbin $io_voltage $allowed_val]
               
               emif_assert { [llength $tbl] != 0 } \
                  "Missing derating table for tIH for speedbin $speedbin at ${io_voltage}V and DC level of $allowed_val mV"
                  
               _check_derating_table_integrity $tbl
            }
            
            foreach allowed_val [enum_data $ddr3_acdc_enum ALLOWED_TDS_AC] {
               set tbl [_table_delta_tDS $speedbin $io_voltage $allowed_val]
               
               emif_assert { [llength $tbl] != 0 } \
                  "Missing derating table for tDS for speedbin $speedbin at ${io_voltage}V and AC level of $allowed_val mV"
                  
               _check_derating_table_integrity $tbl
            }
            
            foreach allowed_val [enum_data $ddr3_acdc_enum ALLOWED_TDH_DC] {
               set tbl [_table_delta_tDH $speedbin $io_voltage $allowed_val]
               
               emif_assert { [llength $tbl] != 0 } \
                  "Missing derating table for tDH for speedbin $speedbin at ${io_voltage}V and DC level of $allowed_val mV"
                  
               _check_derating_table_integrity $tbl
            }
         }
      }
      
      emif_utest_pass 
   }   
}

::altera_emif::ip_top::board::ddr3::_init
