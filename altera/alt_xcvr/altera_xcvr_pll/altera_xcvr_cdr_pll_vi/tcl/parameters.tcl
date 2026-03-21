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


package provide altera_xcvr_cdr_pll_vi::parameters 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::gui::messages
package require alt_xcvr::utils::device
package require alt_xcvr::utils::common
package require alt_xcvr::utils::reconfiguration_arria10
package require altera_xcvr_cdr_pll_vi::parameters
package require nf_xcvr_native::parameters
package require nf_cdr_pll::parameters

namespace eval ::altera_xcvr_cdr_pll_vi::parameters:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::ip_tcl::messages::*

    
  namespace export \
    declare_parameters \
    validate \
    compute_pll_settings
    
  variable package_name
  variable display_items
  variable generation_display_items
  variable parameters
  variable atom_parameters
  variable logical_parameters

  set package_name "nf_cdr_pll::parameters"
  
  set display_items {\
    {NAME                                     GROUP           ENABLED       VISIBLE     TYPE   ARGS  }\
    {"PLL"                                    ""              NOVAL         NOVAL       GROUP  tab }\
    {"General"                                "PLL"           NOVAL         NOVAL       GROUP  noval }\
    {"Output Frequency"                       "PLL"           NOVAL         NOVAL       GROUP  noval }\
  }
  
  set generation_display_items {\
    {NAME                                     GROUP           ENABLED       VISIBLE     TYPE   ARGS  }\
    {"Generation Options"                     ""              NOVAL         NOVAL       GROUP  tab   }\
  }
  
  set parameters {\
    {NAME                                     M_USED_FOR_RCFG  M_SAME_FOR_RCFG          DERIVED HDL_PARAMETER       TYPE            DEFAULT_VALUE               ALLOWED_RANGES                                  ENABLED                             VISIBLE                             DISPLAY_HINT  DISPLAY_UNITS                                                                                 DISPLAY_ITEM                    DISPLAY_NAME                                                                            VALIDATION_CALLBACK                                                                              DESCRIPTION }\
    {enable_advanced_options                            0               0                   true    false           INTEGER             0                       { 0 1 }                                         true                                false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       NOVAL                                                                                               NOVAL}\
    {generate_docs                                      0               0                   false   false           INTEGER             0                           NOVAL                                       true                                true                                boolean       NOVAL                                                                                         "Generation Options"            "Generate parameter documentation file"                                                     NOVAL                                                                                               "When enabled, generation will produce a .CSV file with descriptions of the IP parameters."}\
    {generate_add_hdl_instance_example                  0               0                   false   false           INTEGER             0                           NOVAL                                       enable_advanced_options             enable_advanced_options             boolean       NOVAL                                                                                         "Generation Options"            "Generate '_hw.tcl' 'add_hdl_instance' example file"                                        NOVAL                                                                                               "When enabled, generation will produce a file containing an example of how to use the '_hw.tcl' 'add_hdl_instance' API. The example will be correct for the current configuration of the IP."}\
    {enable_analog_resets                               0               0                   false   true            INTEGER             0                           NOVAL                                       enable_advanced_options             enable_advanced_options             boolean       NOVAL                                                                                         "Generation Options"            "Enable pll_powerdown connection"                                                           NOVAL                                                                                               "INTERNAL USE ONLY. When selected, the pll_powerdown input port will be connected internally in the IP. Otherwise and by default this port is present but has no affect when asserted."}\
    {device_family                                      0               0                   false   false           STRING          "Arria VI"                      NOVAL                                       true                                false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       NOVAL                                                                                               NOVAL}\
    {base_device                                        0               0                   false   false           STRING          "Unknown"                       NOVAL                                       true                                false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       NOVAL                                                                                               NOVAL}\
    {device                                             0               0                   false   false           STRING          "Unknown"                       NOVAL                                       true                                false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       NOVAL                                                                                               NOVAL}\
    {message_level                                      0               0                   false   false           STRING          "error"                     {error warning}                                 true                                true                                NOVAL         NOVAL                                                                                         "General"                       "Message level for rule violations"                                                         NOVAL                                                                                               "Specifies the messaging level to use for parameter rule violations. Selecting \"error\" will cause all rule violations to prevent IP generation. Selecting \"warning\" will display all rule violations as warnings and will allow IP generation in spite of violations."}\
    {speed_grade                                        0               0                   true    false           STRING            "e2"                          NOVAL                                       true                                false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       ::altera_xcvr_cdr_pll_vi::parameters::validate_speed_grade                                           NOVAL}\
    {bw_sel                                             1               1                   false   false           STRING          "Medium"                       {"Low" "Medium" "High"}                         true                                true                                NOVAL         NOVAL                                                                                         "General"                       "Bandwidth"                                                                                 NOVAL                                                                                               "PLL bandwidth specifies the ability of the PLL to track the input clock and jitter. PLL with a \"High\" bandwidth has a faster lock time but tracks more jitter. A \"Medium\" bandwidth offers a balance between lock time and jitter rejection "}\
    {refclk_cnt                                         1               0                   false   false           INTEGER             1                       { 1 2 3 4 5}                                    true                                true                                NOVAL         NOVAL                                                                                         "General"                       "Number of PLL reference clocks"                                                            NOVAL                                                                                               "Specifies the maximum number of reference clock sources for the PLL"}\
    {refclk_index                                       1               0                   false   false           INTEGER             0                           NOVAL                                       true                                true                                NOVAL         NOVAL                                                                                         "General"                       "Selected reference clock source"                                                           ::altera_xcvr_cdr_pll_vi::parameters::validate_refclk_index                                         "Indicates the selected reference clock source"}\
    {bw_sel_atom                                        0               0                   true    false           STRING          "medium"                           NOVAL                                       true                                false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       ::altera_xcvr_cdr_pll_vi::parameters::validate_bw_sel                                               NOVAL}\
    {device_revision                                    0               0                   true    false           STRING          "20nm5es"                       NOVAL                                       true                                false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       ::altera_xcvr_cdr_pll_vi::parameters::validate_device_revision                                      NOVAL}\
    {support_mode                                       1               0                   false   false           STRING          "user_mode"                 {"user_mode" "engineering_mode"}                enable_advanced_options             enable_advanced_options             NOVAL         NOVAL                                                                                         "General"                       "Support mode"                                                                              ::altera_xcvr_cdr_pll_vi::parameters::validate_support_mode                                         "Selects the support mode (user or engineering). Engineering mode options are not officially supported by Altera or Quartus Prime."}\
    {select_manual_config                               0               0                   false   false           BOOLEAN             0                           NOVAL                                       true                                false                               boolean       NOVAL                                                                                         "Output Frequency"              "Configure counters manually"                                                               NOVAL                                                                                               NOVAL}\
    {reference_clock_frequency                          1               0                   false   false           FLOAT           100.000000                      NOVAL                                       true                                true                                NOVAL         MHz                                                                                           "Output Frequency"              "PLL reference clock frequency"                                                             ::altera_xcvr_cdr_pll_vi::parameters::validate_reference_clock_frequency                            "List of reference clock frequencies (MHz) available for the PLL"}\
    {output_clock_frequency                             1               0                   false   false           STRING          "3000"                          NOVAL                                       true                                true                                NOVAL         MHz                                                                                           "Output Frequency"              "PLL output frequency"                                                                      ::altera_xcvr_cdr_pll_vi::parameters::validate_output_clock_frequency                               "Desired output frequency (MHz)"}\
    {cdr_pll_out_clock_frequency                        1               0                   true    false           STRING          "3000 MHz"                      NOVAL                                       true                                false                               NOVAL         MHz                                                                                           "Output Frequency"              "PLL output frequency"                                                                      NOVAL                                                                                               NOVAL}\
    {cdr_pll_ref_clock_frequency                        1               0                   true    false           STRING          "100.000000 MHz"                NOVAL                                       true                                false                               NOVAL         MHz                                                                                           "Output Frequency"              "PLL reference clock frequency"                                                             ::altera_xcvr_cdr_pll_vi::parameters::validate_cdr_pll_ref_clock_frequency                          NOVAL}\
    {cdr_pll_mcounter                                   1               0                   true    false           INTEGER             1                           NOVAL                                       true                                true                                NOVAL         NOVAL                                                                                         "Output Frequency"              "Multiply factor (M-Counter)"                                                               ::altera_xcvr_cdr_pll_vi::parameters::validate_m_counter                                            "Specifies the value for the feedback multiplier counter (M counter)"}\
    {cdr_pll_ncounter                                   1               0                   true    false           INTEGER             1                           NOVAL                                       true                                true                                NOVAL         NOVAL                                                                                         "Output Frequency"              "Divide factor (N-Counter)"                                                                 ::altera_xcvr_cdr_pll_vi::parameters::validate_n_counter                                            "Specifies the value for the pre-divider counter (N counter)"}\
    {cdr_pll_pfd_lcounter                               1               0                   true    false           INTEGER             1                           NOVAL                                       true                                true                                NOVAL         NOVAL                                                                                         "Output Frequency"              "Divide factor (L-Counter)"                                                                 ::altera_xcvr_cdr_pll_vi::parameters::validate_pfd_l_counter                                        "Specifies the value for the phase-frequency detector (PFD) circuit"}\
    {cdr_pll_pd_lcounter                                1               0                   true    false           INTEGER             1                           NOVAL                                       true                                false                               NOVAL         NOVAL                                                                                         "Output Frequency"              "Divide factor (L-Counter)"                                                                 ::altera_xcvr_cdr_pll_vi::parameters::validate_pd_l_counter                                         "Specifies the value for the phase-frequency detector (PD) circuit"}\
    {manual_counters                                    0               0                   false   false           STRING          NOVAL                           NOVAL                                       select_manual_config                false                               NOVAL         "N-Counter (Divide Factor)   Lpfd-Counter (Divide Factor)   M-Counter (Multiply Factor)"      "Output Frequency"              "Counter Values"                                                                            NOVAL                                                                                               NOVAL}\
    {auto_counters                                      0               0                   true    false           STRING          NOVAL                           NOVAL                                       true                                false                               NOVAL         NOVAL                                                                                         "Output Frequency"              "Auto Counter Values"                                                                       ::altera_xcvr_cdr_pll_vi::parameters::validate_auto_counters                                        NOVAL}\
    {cdr_pll_requires_gt_capable_channel                0               0                   true    false           STRING         "false"                      {false true}                                    true                                false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       ::altera_xcvr_cdr_pll_vi::parameters::validate_cdr_pll_requires_gt_capable_channel                  NOVAL}\
    {cdr_pll_initial_settings                           0               0                   false   true            STRING         "true"                           NOVAL                                       true                                false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       NOVAL                                                                                               NOVAL}\
    {cdr_pll_optimal                                    0               0                   false   true            STRING         "false"                          NOVAL                                       true                                false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       NOVAL                                                                                               NOVAL}\
    {cdr_pll_fb_select                                  0               0                   true    true            STRING         "direct_fb"                      NOVAL                                       true                                false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       NOVAL                                                                                               NOVAL}\
    {vco_freq                                           1               0                   true    false           STRING          "0 MHz"                         NOVAL                                       true                                false                               NOVAL         MHz                                                                                           NOVAL                           NOVAL                                                                                       ::altera_xcvr_cdr_pll_vi::parameters::validate_vco_freq                                             NOVAL}\
    {datarate                                           1               0                   true    false           STRING          "0 Mbps"                        NOVAL                                       true                                false                               NOVAL         Mbps                                                                                          NOVAL                           NOVAL                                                                                       ::altera_xcvr_cdr_pll_vi::parameters::validate_datarate                                             NOVAL}\
    {primary_use                                        0               0                   true    false           STRING          "cmu"                           NOVAL                                       true                                false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       NOVAL                                                                                               NOVAL}\
    {cdr_pll_cgb_div                                    0               0                   false   true            INTEGER             1                           NOVAL                                       true                                false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       NOVAL                                                                                               NOVAL}\
    {cdr_pll_is_cascaded_pll                            0               0                   false   true            STRING         "false"                          NOVAL                                       true                                false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       NOVAL                                                                                               NOVAL}\
    {gui_tx_pll_prot_mode                               1               0                   false   false           STRING          "Basic"                   {"Basic" "PCIE"}                                  true                                true                                NOVAL         NOVAL                                                                                         "General"                       "TX PLL Protocol mode"                                                                              NOVAL                                                                                               "Selects the protocol configuration rules the transceiver PLL. This parameter governs the rules for correct settings of protocol-specific parameters within the PLL. Certain features of the PLL are available only for specific protocol configuration rules. This parameter is not a \"preset\". You must still correctly set all other parameters for your specific protocol and application needs."}\
    {diag_loopback_enable                               1               0                   true    false           STRING         "false"                      {false true}                                    true                                false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       ::altera_xcvr_cdr_pll_vi::parameters::validate_diag_loopback_enable                                 NOVAL}\
    {loopback_mode                                      0               0                   true    false           STRING         "loopback_disabled"          {"loopback_disabled" "loopback_enabled"}        true                                false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       ::altera_xcvr_cdr_pll_vi::parameters::validate_loopback_mode                                        NOVAL}\
    {tx_pll_prot_mode                                   1               0                   true    false           STRING        "txpll_unused"                    NOVAL                                       true                                false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       ::altera_xcvr_cdr_pll_vi::parameters::validate_tx_pll_prot_mode                                     NOVAL}\
    {refclk_select_mux_powerdown_mode                   1               0                   false   false           STRING         "powerup"               {"powerup" "powerdown"}                              true                                false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       NOVAL                                                                                               NOVAL}\
    {dummy_embedded_debug_warning                       1               0                   true    false           INTEGER             0                          { 0 1 }                                      true                                false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       ::altera_xcvr_cdr_pll_vi::parameters::validate_cdr_embedded_debug                                   NOVAL}\
    {set_altera_xcvr_cdr_pll_a10_calibration_en         0               0                   false   false           INTEGER             1                           NOVAL                                       enable_advanced_options             enable_advanced_options             boolean       NOVAL                                                                                         "General"                       "Enable calibration"                                                                        NOVAL                                                                                               "Enable transceiver calibration algorithms."}\
    {calibration_en                                     0               0                   true    true            STRING         "enable"                {"enable" "disable"}                                 enable_advanced_options             false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       ::altera_xcvr_cdr_pll_vi::parameters::validate_enable_calibration                                   NOVAL}\
  }

    #{prot_mode                                         0               0                   true    false           STRING          "basic_rx"                  {"basic_rx"}                                    true                                false                               NOVAL         NOVAL                                                                                         NOVAL                           NOVAL                                                                                       NOVAL                                                                                               NOVAL}\
    #{prot_mode                                         1               0                   false   false           STRING          "Basic"      {"Basic" "PCIE Gen 1" "PCIE Gen 2" "PCIE Gen 3"}               true                                true                                NOVAL         NOVAL                                                                                         "General"                       "Protocol mode"                                                                             NOVAL                                                                                               "Selects the protocol configuration rules the transceiver PLL. This parameter governs the rules for correct settings of protocol-specific parameters within the PLL. Certain features of the PLL are available only for specific protocol configuration rules. This parameter is not a \"preset\". You must still correctly set all other parameters for your specific protocol and application needs."}\


  set atom_parameters {\
    { NAME                                          TYPE       DERIVED   M_AUTOSET     M_MAPS_FROM                          HDL_PARAMETER   ENABLED   VISIBLE   M_MAP_VALUES    VALIDATION_CALLBACK}\
    { cdr_pll_sup_mode                              STRING     true      false         support_mode                         true            false     false     NOVAL           NOVAL}\
    { cdr_pll_pm_speed_grade                        STRING     true      false         speed_grade                          true            false     false     NOVAL           NOVAL}\
    { cdr_pll_prot_mode                             STRING     true      false         NOVAL                                true            false     false     NOVAL           NOVAL }\
    { cdr_pll_bw_sel                                STRING     true      false         bw_sel_atom                          true            false     false     NOVAL           NOVAL}\
    { cdr_pll_output_clock_frequency                STRING     true      false         cdr_pll_out_clock_frequency          true            false     false     NOVAL           ::altera_xcvr_cdr_pll_vi::parameters::convert_mhz_to_hz}\
    { cdr_pll_reference_clock_frequency             STRING     true      false         cdr_pll_ref_clock_frequency          true            false     false     NOVAL           ::altera_xcvr_cdr_pll_vi::parameters::convert_mhz_to_hz}\
    { cdr_pll_m_counter                             INTEGER    true      false         cdr_pll_mcounter                     true            false     false     NOVAL           NOVAL}\
    { cdr_pll_n_counter                             INTEGER    true      false         cdr_pll_ncounter                     true            false     false     NOVAL           NOVAL}\
    { cdr_pll_n_counter_scratch                     INTEGER    true      false         cdr_pll_ncounter                     true            false     false     NOVAL           NOVAL}\
    { cdr_pll_pfd_l_counter                         INTEGER    true      false         cdr_pll_pfd_lcounter                 true            false     false     NOVAL           NOVAL}\
    { cdr_pll_pd_l_counter                          INTEGER    true      false         cdr_pll_pd_lcounter                  true            false     false     NOVAL           NOVAL}\
    { pma_cdr_refclk_select_mux_silicon_rev         STRING     true      false         device_revision                      true            false     false     NOVAL           NOVAL}\
    { pma_cdr_refclk_select_mux_refclk_select       STRING     true      false         refclk_index                         true            false     false     {"0:ref_iqclk0" "1:ref_iqclk1" "2:ref_iqclk2" "3:ref_iqclk3" "4:ref_iqclk4"} }\
    { cdr_pll_silicon_rev         STRING     true      false         device_revision                      true            false     false     NOVAL           NOVAL}\
    { cdr_pll_lpd_counter                           INTEGER    true      false         cdr_pll_pd_lcounter                  true            false     false     NOVAL           NOVAL}\
    { cdr_pll_lpfd_counter                          INTEGER    true      false         cdr_pll_pfd_lcounter                 true            false     false     NOVAL           NOVAL}\
    { cdr_pll_vco_freq                              STRING     true      false         vco_freq                             true            false     false     NOVAL           ::altera_xcvr_cdr_pll_vi::parameters::convert_mhz_to_hz}\
    { cdr_pll_primary_use                           STRING     true      false         primary_use                          true            false     false     NOVAL           NOVAL}\
    { cdr_pll_tx_pll_prot_mode                      STRING     true      false         tx_pll_prot_mode                     true            false     false     NOVAL           NOVAL}\
    { cdr_pll_pma_width                             INTEGER    true      false         NOVAL                                true            false     false     NOVAL           NOVAL}\
    { cdr_pll_datarate                              STRING     true      false         datarate                             true            false     false     NOVAL           ::altera_xcvr_cdr_pll_vi::parameters::convert_mbps_to_bps}\
    { pma_cdr_refclk_select_mux_powerdown_mode      STRING     true      false         refclk_select_mux_powerdown_mode     true            false     false     NOVAL           NOVAL}\
    { cdr_pll_diag_loopback_enable                  STRING     true      false         diag_loopback_enable                 false            false     false     NOVAL           ::altera_xcvr_cdr_pll_vi::parameters::validate_cdr_pll_diag_loopback_enable}\
    { cdr_pll_loopback_mode                         STRING     true      false         loopback_mode                        false           false     false     NOVAL           ::altera_xcvr_cdr_pll_vi::parameters::validate_cdr_pll_loopback_mode}\
    { cdr_pll_reverse_serial_loopback               STRING     true      false         NOVAL                                false           false     false     NOVAL           ::altera_xcvr_cdr_pll_vi::parameters::validate_cdr_pll_reverse_serial_loopback}\
    { pma_cdr_refclk_select_mux_inclk0_logical_to_physical_mapping STRING    true      false         refclk_cnt                           true            false     false     {"1:ref_iqclk0" "2:ref_iqclk0" "3:ref_iqclk0" "4:ref_iqclk0" "5:ref_iqclk0"} NOVAL }\
    { pma_cdr_refclk_select_mux_inclk1_logical_to_physical_mapping STRING    true      false         refclk_cnt                           true            false     false     {"1:power_down" "2:ref_iqclk1" "3:ref_iqclk1" "4:ref_iqclk1" "5:ref_iqclk1"} NOVAL }\
    { pma_cdr_refclk_select_mux_inclk2_logical_to_physical_mapping STRING    true      false         refclk_cnt                           true            false     false     {"1:power_down" "2:power_down" "3:ref_iqclk2" "4:ref_iqclk2" "5:ref_iqclk2"} NOVAL }\
    { pma_cdr_refclk_select_mux_inclk3_logical_to_physical_mapping STRING    true      false         refclk_cnt                           true            false     false     {"1:power_down" "2:power_down" "3:power_down" "4:ref_iqclk3" "5:ref_iqclk3"} NOVAL }\
    { pma_cdr_refclk_select_mux_inclk4_logical_to_physical_mapping STRING    true      false         refclk_cnt                           true            false     false     {"1:power_down" "2:power_down" "3:power_down" "4:power_down" "5:ref_iqclk4"} NOVAL }\
   }

  #{ cdr_pll_requires_gt_capable_channel           STRING     true      false         NOVAL                                true            false     false     NOVAL}
  #need to discuss the following with chris - temp disabling HDL parameter
  set logical_parameters {\
    { NAME                                          TYPE       DERIVED   M_MAPS_FROM                HDL_PARAMETER   ENABLED   VISIBLE   M_MAP_VALUES }\
    { cmu_refclk_select                             INTEGER    true      refclk_index               false           false     false     NOVAL }\
  }
}
  
proc ::altera_xcvr_cdr_pll_vi::parameters::declare_parameters { {device_family "Arria VI"} } {
  variable display_items
  variable generation_display_items
  variable parameters
  variable atom_parameters
  variable logical_parameters
  
  # Which parameters are included in reconfig reports is parameter dependent
  ip_add_user_property_type M_RCFG_REPORT integer

  ::alt_xcvr::utils::reconfiguration_arria10::declare_parameters
  ip_set "parameter.rcfg_file_prefix.DEFAULT_VALUE" "altera_xcvr_cdr_pll_a10"
   
  ip_declare_parameters [::nf_cdr_pll::parameters::get_parameters]
  
  # Mark HDL parameters
  set nf_cdr_pll_parameters [ip_get_matching_parameters [dict set criteria M_IP_CORE nf_cdr_pll]]
  set mif_exclude [dict create cdr_pll_uc_ro_cal 1 cdr_pll_ltd_ltr_micro_controller_select 1 cdr_pll_loopback_mode 1 cdr_pll_reverse_serial_loopback 1 cdr_pll_diag_loopback_enable 1]

  foreach param $nf_cdr_pll_parameters {
    if {[ip_get "parameter.${param}.M_IS_STATIC_HDL_PARAMETER"] == "false"} {
      ip_set "parameter.${param}.HDL_PARAMETER" 1
      if {[dict exist $mif_exclude $param] != 1} {
         ip_set "parameter.${param}.M_RCFG_REPORT" 1
      }
    }

      ip_set "parameter.${param}.M_AUTOSET" "true"
      ip_set "parameter.${param}.M_AUTOWARN" "true"
  }
  
  ip_declare_parameters $parameters
  ip_declare_parameters $atom_parameters
  ip_declare_parameters $logical_parameters
  
  ip_declare_display_items $display_items
  ::alt_xcvr::utils::reconfiguration_arria10::declare_display_items "" tab
  ip_declare_display_items $generation_display_items
  
  ip_set "parameter.device_family.SYSTEM_INFO" DEVICE_FAMILY
  ip_set "parameter.device_family.DEFAULT_VALUE" $device_family

  # Initialize revision
  ip_set "parameter.base_device.SYSTEM_INFO_TYPE" PART_TRAIT
  ip_set "parameter.base_device.SYSTEM_INFO_ARG" BASE_DEVICE  
  ip_set "parameter.base_device.DEFAULT_VALUE" "nightfury5es";#temporary hack once BASE_DEVICE is properly supported by qsys remove this line

  # Initialize part number
  ip_set "parameter.device.SYSTEM_INFO" DEVICE

   # Grab Quartus INI's
  ip_set "parameter.enable_advanced_options.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_cdr_pll_10_advanced ENABLED]
}

proc ::altera_xcvr_cdr_pll_vi::parameters::validate {} {
  ip_message info "Please note that the Arria 10 Transceiver CMU PLL does not support feedback compensation bonding or xN/x6 clock line usage (bonded or non-bonded modes)."
  ::alt_xcvr::ip_tcl::messages::set_auto_message_level [ip_get "parameter.message_level.value"]
  ip_validate_parameters 
  ip_validate_display_items
}

proc ::altera_xcvr_cdr_pll_vi::parameters::validate_support_mode { PROP_NAME PROP_VALUE message_level } {
  if {$PROP_VALUE == "engineering_mode"} {
    ip_message $message_level "Engineering support mode has been selected. Engineering mode is for internal use only. Altera does not officially support or guarantee IP configurations for this mode."
  }
}

proc ::altera_xcvr_cdr_pll_vi::parameters::validate_speed_grade { device } {
  set operating_temperature [::alt_xcvr::utils::device::get_a10_operating_temperature $device]
  set temp_pma_speed_grade [::alt_xcvr::utils::device::get_a10_pma_speedgrade $device]
  ip_message info "For the selected device($device), transceiver PLL speed grade is $temp_pma_speed_grade."

  set temp_pma_speed_grade "${operating_temperature}${temp_pma_speed_grade}" 
  ip_set "parameter.speed_grade.value" $temp_pma_speed_grade
}

#convert freq specified in hz to mhz and return the integer converted value
proc ::altera_xcvr_cdr_pll_vi::parameters::freq_hz_to_mhz { freq } { 
  regsub -nocase -all {\D} $freq "" temp
  set temp [expr {double($temp) / 1000000}]
  return $temp
}

proc ::altera_xcvr_cdr_pll_vi::parameters::get_f_max_pfd { cdr_pll_f_max_pfd } { 
  return [::altera_xcvr_cdr_pll_vi::parameters::freq_hz_to_mhz $cdr_pll_f_max_pfd]
}

proc ::altera_xcvr_cdr_pll_vi::parameters::get_f_min_pfd { cdr_pll_f_min_pfd } { 
  return [::altera_xcvr_cdr_pll_vi::parameters::freq_hz_to_mhz $cdr_pll_f_min_pfd]
}

proc ::altera_xcvr_cdr_pll_vi::parameters::get_f_max_vco { cdr_pll_f_max_vco tx_pll_prot_mode device_revision } { 
#  if {[string compare $tx_pll_prot_mode "txpll_unused" ] == 0 || [string compare $tx_pll_prot_mode "txpll_enable_pcie" ] == 0} { 
     return [::altera_xcvr_cdr_pll_vi::parameters::freq_hz_to_mhz $cdr_pll_f_max_vco]
#  } else {
#     return [::altera_xcvr_cdr_pll_vi::parameters::freq_hz_to_mhz [::nf_xcvr_native::parameters::validate_cdr_pll_f_min_gt_channel $device_revision]]
#  }
}

proc ::altera_xcvr_cdr_pll_vi::parameters::get_f_min_vco { cdr_pll_f_min_vco } { 
  return [::altera_xcvr_cdr_pll_vi::parameters::freq_hz_to_mhz $cdr_pll_f_min_vco]
}

proc ::altera_xcvr_cdr_pll_vi::parameters::get_f_max_ref { cdr_pll_f_max_ref } { 
  return [::altera_xcvr_cdr_pll_vi::parameters::freq_hz_to_mhz $cdr_pll_f_max_ref]
}

proc ::altera_xcvr_cdr_pll_vi::parameters::get_f_min_ref { cdr_pll_f_min_ref } { 
  return [::altera_xcvr_cdr_pll_vi::parameters::freq_hz_to_mhz $cdr_pll_f_min_ref]
}

#convert range lists to standard TCL lists
proc ::altera_xcvr_cdr_pll_vi::parameters::scrub_list_values { my_list } {
  set new_list {}
  set my_list_len [llength $my_list]
  for {set list_index 0} {$list_index < $my_list_len} { incr list_index } {
    set this_value [lindex $my_list $list_index]
    if [ regexp {:} $this_value ] then {
      regsub -all ":" $this_value " " temp_list
      set start_value [lindex $temp_list 0]
      set end_value [lindex $temp_list 1]
      for {set index $start_value} {$index <= $end_value} { incr index } {
        lappend new_list $index
      }
    } else {
      lappend new_list $this_value
    }
  }
  return $new_list
}

proc ::altera_xcvr_cdr_pll_vi::parameters::mega_to_base { val } { 
  #replace anything not a number or DOT character (to account for doubles)
  regsub -nocase -all {\m(\D)} $val "" temp
  set temp [expr {wide(double($temp) * 1000000)}]
  return $temp
}

proc ::altera_xcvr_cdr_pll_vi::parameters::compute_pll_settings {device_revision output_clock_frequency_Mhz pll_type pcie_mode cdr_pll_f_max_pfd cdr_pll_f_min_pfd cdr_pll_f_max_vco cdr_pll_f_min_vco cdr_pll_f_max_ref cdr_pll_f_min_ref} {
  #output clock freq is in MHz

  #if {[string compare $pll_type "CMU" ] == 0 } { 
  #  set pfd_l_counter [lsort -increasing -integer [scrub_list_values [ip_get "parameter.cdr_pll_pfd_l_counter.allowed_ranges"]]]
  #} else {
  #  # Arranging the lpfd in descending order enable the computation algo to produce on top of the returned stack that contain smallest m value. 
  #  set pfd_l_counter [lsort -decreasing -integer [scrub_list_values [ip_get "parameter.cdr_pll_pfd_l_counter.allowed_ranges"]]]
  #}
  
  ##make sure that the counter does not use the value "0" (if present) for calculations
  #set idx [lsearch $pfd_l_counter 0]
  #set pfd_l_counter [lreplace $pfd_l_counter $idx $idx]

  #set idx [lsearch $pfd_l_counter 100]
  #set pfd_l_counter [lreplace $pfd_l_counter $idx $idx]

  #make sure that the counter does not use the value "0" (if present) for calculations
  #set pd_l_counter [scrub_list_values [ip_get "parameter.cdr_pll_pd_l_counter.allowed_ranges"]]
  #set idx [lsearch $pd_l_counter 0]
  #set pd_l_counter [lreplace $pfd_l_counter $idx $idx]

  #set idx [lsearch $pd_l_counter 100]
  #set pd_l_counter [lreplace $pfd_l_counter $idx $idx]

#  set m_counter [scrub_list_values [ip_get "parameter.cdr_pll_m_counter.allowed_ranges"]]

  #set m_counter { 1 2 3 4 5 6 8 9 10 12 15 16 18 20 24 25 30 32 33 36 40 48 50 60 64 80 100 } 

  #TODO: Auto-select n counter values from RBC  
  #if {[string compare $pcie_mode "non_pcie" ] == 0 } { 
  #  set ref_clk_div [scrub_list_values [ip_get "parameter.cdr_pll_n_counter.allowed_ranges"]]
  #} else {
  #  set ref_clk_div { 1 }
  #}

  set index 0
  set ret [dict create]
 
  set output_clock_frequency_hz [::altera_xcvr_cdr_pll_vi::parameters::mega_to_base $output_clock_frequency_Mhz]

  if {[string compare $pll_type "CMU" ] == 0 } {   
   
      ip_set "parameter.primary_use.value" "cmu"
      ip_set "parameter.cdr_pll_prot_mode.value" "unused" 
      ip_set "parameter.cdr_pll_pma_width.value" 8 


	  set prot_mode [ip_get "parameter.cdr_pll_prot_mode.value"]
      if {[string compare $pcie_mode "non_pcie" ] == 0 } { 
		  set tx_pll_prot_mode "txpll_enable"
	  } else {
		  set tx_pll_prot_mode "txpll_enable_pcie"
	  }

      #Get counters for CMU mode
      set pd_l_counter [scrub_list_values [::nf_xcvr_native::parameters::getValue_cdr_pll_lpd_counter $device_revision "false" $output_clock_frequency_hz $prot_mode "user_mode" $tx_pll_prot_mode]]
      set pfd_l_counter [scrub_list_values [::nf_xcvr_native::parameters::getValue_cdr_pll_lpfd_counter $device_revision "false" 1 $output_clock_frequency_hz $prot_mode "user_mode" $tx_pll_prot_mode ]]
      set ref_clk_div   [scrub_list_values [::nf_xcvr_native::parameters::getValue_cdr_pll_n_counter_scratch $device_revision "false" $prot_mode $tx_pll_prot_mode]]
      set m_counter     [scrub_list_values [::nf_xcvr_native::parameters::getValue_cdr_pll_m_counter $device_revision "false" $prot_mode $tx_pll_prot_mode]]

      foreach lpfd $pfd_l_counter {

      set calc_fvco [expr {$output_clock_frequency_Mhz * $lpfd}] 

      if {$calc_fvco >= [get_f_min_vco $cdr_pll_f_min_vco] && $calc_fvco <= [get_f_max_vco $cdr_pll_f_max_vco $tx_pll_prot_mode $device_revision]} {
        foreach mcnt $m_counter {
          set calc_fbclk [expr {double($output_clock_frequency_Mhz) / $mcnt}]   
          if {$calc_fbclk >= [get_f_min_pfd $cdr_pll_f_min_pfd] && $calc_fbclk <= [get_f_max_pfd $cdr_pll_f_max_pfd]} {
            foreach ncnt $ref_clk_div {
              set calc_refclk [expr {$calc_fbclk * $ncnt}]
                        
              if { $calc_refclk >= [get_f_min_ref $cdr_pll_f_min_ref] && $calc_refclk <= [get_f_max_ref $cdr_pll_f_max_ref] } { 
                set refclk [format "%.6f" $calc_refclk];
                set refclk_str "$refclk"
                dict set ret $index refclk $refclk_str
                dict set ret $index m $mcnt
                dict set ret $index n $ncnt
                dict set ret $index lpfd $lpfd
                dict set ret $index fvco $calc_fvco
                dict set ret $index lpd $pd_l_counter
                incr index
                #ip_message info "::altera_xcvr_cdr_pll_vi::parameters::compute_pll_settings result: $ret " 
              }
            }
          }
        }                    
      }
    }
  } else {

    #ip_set "parameter.primary_use.value" "cdr"
    #TODO: set prot mode from native phy directly based on protocol mode selection in native phy
    #ip_set "parameter.cdr_pll_prot_mode.value" "basic_rx" 
    #TODO: set pma width value to the value from native phy
    #ip_set "parameter.cdr_pll_pma_width.value" 8 

      if {[string compare $pcie_mode "non_pcie" ] == 0 } { 
	      set prot_mode "basic_rx"
		  set tx_pll_prot_mode "txpll_unused"
	  } else {
	      set prot_mode $pcie_mode
		  set tx_pll_prot_mode "txpll_unused"
	  }

      #Get counters for CDR mode
      set pd_l_counter [scrub_list_values [::nf_xcvr_native::parameters::getValue_cdr_pll_lpd_counter $device_revision "false" $output_clock_frequency_hz $prot_mode "user_mode" $tx_pll_prot_mode]]
      set ref_clk_div   [scrub_list_values [::nf_xcvr_native::parameters::getValue_cdr_pll_n_counter_scratch $device_revision "false" $prot_mode $tx_pll_prot_mode]]
      set m_counter     [scrub_list_values [::nf_xcvr_native::parameters::getValue_cdr_pll_m_counter $device_revision "false" $prot_mode $tx_pll_prot_mode]]

    foreach lpd $pd_l_counter {
      set calc_fvco [expr {$output_clock_frequency_Mhz * $lpd}] 
      if {$calc_fvco >= [get_f_min_vco $cdr_pll_f_min_vco] && $calc_fvco <= [get_f_max_vco $cdr_pll_f_max_vco $tx_pll_prot_mode $device_revision]} {
          set pfd_l_counter [scrub_list_values [::nf_xcvr_native::parameters::getValue_cdr_pll_lpfd_counter $device_revision "false" $lpd $output_clock_frequency_hz $prot_mode "user_mode" $tx_pll_prot_mode ]]
          foreach lpfd $pfd_l_counter {
          set calc_outclk_pfd [expr {double($calc_fvco)/$lpfd}]
          foreach mcnt $m_counter {

            set calc_fbclk [expr {double($calc_outclk_pfd) / $mcnt}]    
            if {$calc_fbclk >= [get_f_min_pfd $cdr_pll_f_min_pfd] && $calc_fbclk <= [get_f_max_pfd $cdr_pll_f_max_pfd]} {
              foreach ncnt $ref_clk_div {

                set calc_refclk [expr {$calc_fbclk * $ncnt}]
                if { $calc_refclk >= [get_f_min_ref $cdr_pll_f_min_ref] && $calc_refclk <= [get_f_max_ref $cdr_pll_f_max_ref] } {   
                  set refclk [format "%.6f" $calc_refclk];
                  set refclk_str "$refclk"
                  dict set ret $index refclk $refclk_str
                  dict set ret $index m $mcnt
                  dict set ret $index n $ncnt
                  dict set ret $index lpfd $lpfd
                  dict set ret $index lpd $lpd
                  dict set ret $index fvco $calc_fvco
                  incr index
                }   
              }         
            }
          }
        }       
      }
    }   
  }
 
  return $ret   
}


proc ::altera_xcvr_cdr_pll_vi::parameters::validate_reference_clock_frequency { device_revision output_clock_frequency reference_clock_frequency cdr_pll_f_max_pfd cdr_pll_f_min_pfd cdr_pll_f_max_vco cdr_pll_f_min_vco cdr_pll_f_max_ref cdr_pll_f_min_ref} {
  set list_of_valid_refclk ""

  if {[string is double $output_clock_frequency]} {

    set result [compute_pll_settings $device_revision $output_clock_frequency "CMU" "non_pcie" $cdr_pll_f_max_pfd $cdr_pll_f_min_pfd $cdr_pll_f_max_vco $cdr_pll_f_min_vco $cdr_pll_f_max_ref $cdr_pll_f_min_ref]
    set ret_length [llength [dict keys $result] ]

    if {$ret_length!=0} {
      for {set x 0} {$x<$ret_length} {incr x} {
        set this_item [dict get $result $x]
        set refclk [dict get $this_item refclk]
    
        ########## get the last index of refclk , remove duplicates and sort ######################
        lappend valid_refclk "$refclk"
        set list_of_valid_refclk [lsort -real -unique -index 0 $valid_refclk] 
      }
    }  else {
      set list_of_valid_refclk ""
      ip_message error "Selected output clock frequency ($output_clock_frequency MHz) is not valid."
    }
  } else {
    set list_of_valid_refclk ""
    ip_message error "Selected output clock frequency ($output_clock_frequency MHz) is not valid."
  }

  ip_set "parameter.reference_clock_frequency.allowed_ranges" $list_of_valid_refclk
  #ip_message info "::altera_xcvr_cdr_pll_vi::parameters::validate_reference_clock_frequency list_of_valid_refclk: $list_of_valid_refclk"
  return $list_of_valid_refclk
}
    
proc ::altera_xcvr_cdr_pll_vi::parameters::validate_cdr_pll_ref_clock_frequency {reference_clock_frequency } {
  #convert to 6 digit precision for string comparisons
  set reference_clock_freq [format "%.6f" $reference_clock_frequency]

  set reference_clock_freq "$reference_clock_frequency MHz"
  ip_set "parameter.cdr_pll_ref_clock_frequency.value" $reference_clock_freq
    
  #ip_message info "::altera_xcvr_cdr_pll_vi::parameters::validate_cdr_pll_ref_clock_frequency cdr_pll_ref_clock_frequency: $reference_clock_freq"
  return $reference_clock_freq
}   

#omit units (Hz) and return the integer converted value
proc ::altera_xcvr_cdr_pll_vi::parameters::omit_units { freq } { 
  regsub -nocase -all {\D} $freq "" temp
  return [expr (wide($temp))]
}

proc ::altera_xcvr_cdr_pll_vi::parameters::validate_output_clock_frequency {output_clock_frequency cdr_pll_f_max_vco cdr_pll_f_min_vco} {
  set output_clock_freq "$output_clock_frequency MHz"
  #ip_message info "::altera_xcvr_cdr_pll_vi::parameters::validate_output_clock_frequency cdr_pll_out_clock_frequency: $output_clock_freq"

## CDR PLL output clock frequency is limited to 3000 MHz which is cdr_pll_f_min_vco/2 so adding new restriction in IP to give proper error
## message if pll output clock frequency is > 3000 MHz || if pll output clock frequency is > f_max_cmu_out_freq set in the CDR BCM file located
## here: quartus/icd_data/nightfury/nf5/pm_cdr/bcmrbc/pm_cdr.bcm.xml 

## NOTE: The value used as f_max out below must NOT be changed unless there is a corresponding change in the CDR BCM for f_max_cmu_out_freq

  set legal_values [expr { [list [expr ([omit_units $cdr_pll_f_min_vco]/(2*1000000.0))]:[expr (5200000000/1000000.0)]]}]

  auto_value_out_of_range_message error output_clock_frequency $output_clock_frequency $legal_values

  if {[string is double $output_clock_frequency]} {
    ip_set "parameter.cdr_pll_out_clock_frequency.value" $output_clock_freq
  }
  #return $output_clock_freq
}

proc ::altera_xcvr_cdr_pll_vi::parameters::validate_auto_counters {device_revision cdr_pll_ref_clock_frequency output_clock_frequency cdr_pll_f_max_pfd cdr_pll_f_min_pfd cdr_pll_f_max_vco cdr_pll_f_min_vco cdr_pll_f_max_ref cdr_pll_f_min_ref} {
  # starting with an empty list 
  ip_set "parameter.auto_counters.value" ""
   
  # eventually temp will be copied into parameter.auto_counters
  set temp ""
    
  if {[string is double $output_clock_frequency]} {
    set result [compute_pll_settings $device_revision $output_clock_frequency "CMU" "non_pcie" $cdr_pll_f_max_pfd $cdr_pll_f_min_pfd $cdr_pll_f_max_vco $cdr_pll_f_min_vco $cdr_pll_f_max_ref $cdr_pll_f_min_ref]
    set ret_length_pre [llength [dict keys $result] ]
    
    set ret_length [expr {$ret_length_pre - 1}] 
    
    set selected_refclk [lindex $cdr_pll_ref_clock_frequency 0]
    set cdr_pll_ref_clock_frequency_formatted [format "%.6f" $selected_refclk]

    
    for {set x $ret_length} {$x>0} {incr x -1} {

      set this_item           [dict get $result $x]
      dict set temp refclk    [dict get $this_item refclk]
      dict set temp m_cnt     [dict get $this_item m]
      dict set temp n_cnt     [dict get $this_item n]
      dict set temp lpfd_cnt  [dict get $this_item lpfd]
      dict set temp lpd_cnt   [dict get $this_item lpd]
      dict set temp fvco      [dict get $this_item fvco]
        
      #ip_message info "::altera_xcvr_cdr_pll_vi::parameters::validate_auto_counters cdr_pll_ref_clock_frequency_formatted: $cdr_pll_ref_clock_frequency_formatted" 
    
      set all_freq [dict get $temp refclk]
      if {[string compare $cdr_pll_ref_clock_frequency_formatted $all_freq] == 0} {
        ip_set "parameter.auto_counters.value" $temp
        #ip_message info "temp $temp"
      } 
    }
  } else {
    set temp ""
    #ip_message error "Selected output clock frequency ($output_clock_frequency MHz) is not valid." 
    # Error already displayed in ::altera_xcvr_cdr_pll_vi::parameters::validate_reference_clock_frequency
  }
  
  return $temp
}


    
# validate_manual_counters - Get valid counter values based on user input refclk #
# ## Not applicable for now
proc ::altera_xcvr_cdr_pll_vi::parameters::validate_manual_counters {device_revision cdr_pll_ref_clock_frequency output_clock_frequency select_manual_config cdr_pll_f_max_pfd cdr_pll_f_min_pfd cdr_pll_f_max_vco cdr_pll_f_min_vco cdr_pll_f_max_ref cdr_pll_f_min_ref} {
  set result [compute_pll_settings $device_revision $output_clock_frequency "CMU" "non_pcie" $cdr_pll_f_max_pfd $cdr_pll_f_min_pfd $cdr_pll_f_max_vco $cdr_pll_f_min_vco $cdr_pll_f_max_ref $cdr_pll_f_min_ref]
  set ret_length [llength [dict keys $result] ]
    
  set selected_refclk [lindex $cdr_pll_ref_clock_frequency 0]
  set cdr_pll_ref_clock_frequency_formatted [format "%.6f" $selected_refclk]
  #ip_message info "::altera_xcvr_cdr_pll_vi::parameters::validate_manual_counters selected_refclk: $selected_refclk"
  for {set x 0} {$x<$ret_length} {incr x} {
    set this_item [dict get $result $x]
    set refclk [dict get $this_item refclk]
    set m_cnt  [dict get $this_item m]
    set n_cnt  [dict get $this_item n]
    set lpfd_cnt  [dict get $this_item lpfd]
    set lpd_cnt  [dict get $this_item lpd]
    
    if {[string compare $cdr_pll_ref_clock_frequency_formatted $refclk] == 0} {
      lappend display_counters "n   $n_cnt     lpfd   $lpfd_cnt lpd $lpd_cnt   m   $m_cnt             " 
      #::alt_xcvr::utils::common::map_allowed_range manual_counters $display_counters
      if {$select_manual_config} {
        ip_set "parameter.manual_counters.allowed_ranges" $display_counters
      } else {
        ::alt_xcvr::utils::common::map_allowed_range manual_counters $display_counters
      }
    } 
  }
  
  return $display_counters
}

# Extract and map n_counter value
proc ::altera_xcvr_cdr_pll_vi::parameters::validate_n_counter {auto_counters } {
  set temp_size [dict size $auto_counters]
    
  if { $temp_size==0 } {
  } else {
    ip_set "parameter.cdr_pll_ncounter.value" [dict get $auto_counters n_cnt]
    #ip_message info "::altera_xcvr_cdr_pll_vi::parameters::validate_n_counter n_cnt: $n_cnt"
  }
}   

# Extract and map lpfd_counter value
proc ::altera_xcvr_cdr_pll_vi::parameters::validate_pfd_l_counter {auto_counters} {
  set temp_size [dict size $auto_counters]

  if { $temp_size==0 } {
  } else {
    ip_set "parameter.cdr_pll_pfd_lcounter.value" [dict get $auto_counters lpfd_cnt]
    #ip_message info "::altera_xcvr_cdr_pll_vi::parameters::validate_pfd_l_counter lpfd_cnt: $lpfd_cnt"
  }
}
# Extract and map lpd_counter value
proc ::altera_xcvr_cdr_pll_vi::parameters::validate_pd_l_counter {auto_counters} {
  set temp_size [dict size $auto_counters]

  if { $temp_size==0 } {
  } else {
    ip_set "parameter.cdr_pll_pd_lcounter.value" [dict get $auto_counters lpd_cnt]
    #ip_message info "::altera_xcvr_cdr_pll_vi::parameters::validate_pfd_l_counter lpfd_cnt: $lpfd_cnt"
  }
}
# Extract and map m_counter value
proc ::altera_xcvr_cdr_pll_vi::parameters::validate_m_counter {auto_counters cdr_pll_ref_clock_frequency} {
  set temp_size [dict size $auto_counters]
   
  if { $temp_size==0 } {
    ip_message error "Selected reference clock frequency ($cdr_pll_ref_clock_frequency) is not valid."
  } else {
    ip_set "parameter.cdr_pll_mcounter.value" [dict get $auto_counters m_cnt]
    #ip_message info "::altera_xcvr_cdr_pll_vi::parameters::validate_m_counter m_cnt: $m_cnt"
  }
}


proc ::altera_xcvr_cdr_pll_vi::parameters::validate_vco_freq {auto_counters} {
  set temp_size [dict size $auto_counters]
  
  if { $temp_size==0 } {
  } else {
    set freq [dict get $auto_counters fvco]    
    ip_set "parameter.vco_freq.value" "$freq MHz"
  }
}
proc ::altera_xcvr_cdr_pll_vi::parameters::validate_datarate { output_clock_frequency } {
  if {[string is double $output_clock_frequency]} {
    set datarate [expr {$output_clock_frequency * 2}] 
    ip_set "parameter.datarate.value" "$datarate Mbps" 
  }
}

proc ::altera_xcvr_cdr_pll_vi::parameters::validate_device_revision { base_device base_device } {
  set temp_device_revision [::nf_xcvr_native::parameters::get_base_device_user_string $base_device]
  if {$temp_device_revision != "NOVAL"} {
    ip_set "parameter.device_revision.value" $temp_device_revision
  } else {
	set device [ip_get parameter.DEVICE.value]
	ip_message error "The current selected device \"$device\" is invalid, please select a valid device to generate the IP."
  }
}


proc ::altera_xcvr_cdr_pll_vi::parameters::validate_bw_sel { bw_sel } {
    if { [string compare -nocase $bw_sel Low]==0 } {
        ip_message warning "A bandwidth selection of Low is no longer available.  The bandwidth selection will be mapped to Medium for IP generation"
        set temp "medium"
    } elseif { [string compare -nocase $bw_sel Medium]==0 } {
        set temp "medium"
    } elseif { [string compare -nocase $bw_sel High]==0 } {
        set temp "high"
    } else {
        set temp "medium"
    }
    ip_set "parameter.bw_sel_atom.value" $temp    
}   

proc ::::altera_xcvr_cdr_pll_vi::parameters::validate_refclk_index {refclk_cnt} {
  set index 0
  for {set N 1} {$N < $refclk_cnt} {incr N} {
    lappend index $N
  }
  ip_set "parameter.refclk_index.ALLOWED_RANGES" $index
}


proc ::altera_xcvr_cdr_pll_vi::parameters::validate_tx_pll_prot_mode { primary_use gui_tx_pll_prot_mode} {
  if { [string compare -nocase $primary_use "cmu"]==0 } {
    if { [string compare -nocase $gui_tx_pll_prot_mode "Basic"]==0 } {
      ip_set "parameter.tx_pll_prot_mode.value" "txpll_enable"
    } elseif { [string compare -nocase $gui_tx_pll_prot_mode "PCIE"]==0 } {
      ip_set "parameter.tx_pll_prot_mode.value" "txpll_enable_pcie"
    } else {
      ip_message error "::altera_xcvr_cdr_pll_vi::parameters::validate_tx_pll_prot_mode: Unknown protocol mode: $gui_tx_pll_prot_mode"
    }   
  } elseif { [string compare -nocase $primary_use "cdr"]==0 } {
    ip_set "parameter.tx_pll_prot_mode.value" "txpll_unused"
  } else {
    ip_message error "::altera_xcvr_cdr_pll_vi::parameters::validate_tx_pll_prot_mode: Unknown primary use value: $primary_use"
  }
}   

#dummy validation callback to suppress RBC auto resolution 
proc ::altera_xcvr_cdr_pll_vi::parameters::validate_diag_loopback_enable { diag_loopback_enable } {
    ip_set "parameter.diag_loopback_enable.value" "false"
}

proc ::altera_xcvr_cdr_pll_vi::parameters::validate_loopback_mode { loopback_mode } {
    ip_set "parameter.loopback_mode.value" "loopback_disabled"
}

proc ::altera_xcvr_cdr_pll_vi::parameters::validate_cdr_pll_reverse_serial_loopback { cdr_pll_reverse_serial_loopback } {
}

proc ::altera_xcvr_cdr_pll_vi::parameters::validate_cdr_pll_loopback_mode { cdr_pll_loopback_mode } {
}

proc ::altera_xcvr_cdr_pll_vi::parameters::validate_cdr_pll_diag_loopback_enable { cdr_pll_diag_loopback_enable} {
}

#dummy validation callback to suppress RBC auto resolution 
proc ::altera_xcvr_cdr_pll_vi::parameters::validate_cdr_pll_requires_gt_capable_channel { cdr_pll_requires_gt_capable_channel } {

}

#convert units in mega (10^6) to base (10^0)
proc ::altera_xcvr_cdr_pll_vi::parameters::mega_to_base { val } { 
  #replace anything not a number or DOT character (to account for doubles)
  regsub -nocase -all {\m(\D)} $val "" temp
  set temp [expr {wide(double($temp) * 1000000)}]
  return $temp
}

proc ::altera_xcvr_cdr_pll_vi::parameters::convert_mhz_to_hz { PROP_NAME PROP_VALUE } {
  set temp [mega_to_base $PROP_VALUE]
  ip_set "parameter.${PROP_NAME}.value" "$temp Hz"
#  ip_set "parameter.${PROP_NAME}.value" "$temp"
}

proc ::altera_xcvr_cdr_pll_vi::parameters::convert_mbps_to_bps { PROP_NAME PROP_VALUE } {
  set temp [mega_to_base $PROP_VALUE]
  ip_set "parameter.${PROP_NAME}.value" "$temp bps"
}

proc ::altera_xcvr_cdr_pll_vi::parameters::validate_enable_calibration { set_altera_xcvr_cdr_pll_a10_calibration_en enable_advanced_options } {
  set value [expr { $enable_advanced_options ? $set_altera_xcvr_cdr_pll_a10_calibration_en:1}]
  if { $value } {
    ip_set "parameter.calibration_en.value" "enable"
  } else {
    ip_set "parameter.calibration_en.value" "disable"
  }
}

proc ::altera_xcvr_cdr_pll_vi::parameters::validate_cdr_embedded_debug { enable_pll_reconfig set_capability_reg_enable set_csr_soft_logic_enable rcfg_jtag_enable } {
  set lcl_embedded_debug_enable [expr $set_capability_reg_enable || $set_csr_soft_logic_enable]
  if { $enable_pll_reconfig && ($lcl_embedded_debug_enable || $rcfg_jtag_enable)} {
    ip_message warning "Merging with a TX-only channel is not supported if any optional reconfiguration logic or ADME is enabled."
  }
}
