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


# \file parameters.tcl
# lists all the parameters used in NF ATX PLL IP GUI & HDL WRAPPER, as well as associated validation callbacks

package provide altera_xcvr_atx_pll_vi::parameters 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::gui::messages
package require alt_xcvr::utils::device
package require alt_xcvr::utils::common
package require altera_xcvr_atx_pll_vi::pll_calculations
package require mcgb_package_vi::mcgb
package require alt_xcvr::utils::reconfiguration_arria10
package require nf_atx_pll::parameters

namespace eval ::altera_xcvr_atx_pll_vi::parameters:: {
   namespace import ::alt_xcvr::ip_tcl::ip_module::*
   namespace import ::alt_xcvr::ip_tcl::messages::*
   namespace import ::altera_xcvr_atx_pll_vi::pll_calculations::*

   namespace export \
      declare_parameters \
      validate \

  variable package_name
   variable display_items_pll
   variable generation_display_items
   variable parameters
   variable mapped_parameters
   variable parameters_allowed_range
   variable atom_parameters
   variable logical_parameters
   variable static_hdl_parameters
   set package_name "nf_atx_pll::parameters"

   set display_items_pll {\
      {NAME                         GROUP                      ENABLED             VISIBLE   TYPE   ARGS  }\
      {"PLL"                        ""                         NOVAL               NOVAL     GROUP  tab   }\
      {"General"                    "PLL"                      NOVAL               NOVAL     GROUP  noval }\
      {"Feedback"                   "PLL"                      NOVAL               NOVAL     GROUP  noval }\
      {"Ports"                      "PLL"                      NOVAL               NOVAL     GROUP  noval }\
      {"Output Frequency"           "PLL"                      NOVAL               NOVAL     GROUP  noval }\
   }

   ## \todo move to file_utils package ??
   set generation_display_items {\
      {NAME                         GROUP                      ENABLED             VISIBLE   TYPE   ARGS  }\
      {"Generation Options"         ""                         NOVAL               NOVAL     GROUP  tab   }\
   }

   # \OPEN how to use and display hclk_divide? [CM: ]
   # \OPEN bonding_mode needs to be reviewed
   # \OPEN enable_bonding_reset needs to be reviewed (reverse logic as well)
   ## \todo insert a reference for FD which includes dependency graph for the parameters
   ## \todo make fb_select, bonding_reset_enable reconfigurable --> convert to 2 parameters 
   ## \todo direct reference to enable_fb_comp_bonding in cgb BAD!!!! 
   set parameters {\
      {NAME                                   M_CONTEXT  M_USED_FOR_RCFG  M_SAME_FOR_RCFG  VALIDATION_CALLBACK                                                 DERIVED HDL_PARAMETER   TYPE         DEFAULT_VALUE            ALLOWED_RANGES                                        ENABLED                  VISIBLE                      DISPLAY_HINT  DISPLAY_UNITS DISPLAY_ITEM                   DISPLAY_NAME                                            DESCRIPTION }\
      {enable_advanced_options                    NOVAL  0                0                NOVAL                                                               true    false           INTEGER      0                        { 0 1 }                                               true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      {enable_hip_options                         NOVAL  0                0                NOVAL                                                               true    false           INTEGER      0                        { 0 1 }                                               true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      {enable_manual_configuration                NOVAL  0                0                NOVAL                                                               false   false           INTEGER      1                        { 0 1 }                                               false                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      {generate_docs                              NOVAL  0                0                NOVAL                                                               false   false           INTEGER      0                        NOVAL                                                 true                     true                         BOOLEAN       NOVAL         "Generation Options"           "Generate parameter documentation file"                 "When enabled, generation will produce a .CSV file with descriptions of the IP parameters."}\
      {generate_add_hdl_instance_example          NOVAL  0                0                NOVAL                                                               false   false           INTEGER      0                        NOVAL                                                 enable_advanced_options  enable_advanced_options      BOOLEAN       NOVAL         "Generation Options"           "Generate '_hw.tcl' 'add_hdl_instance' example file"    "When enabled, generation will produce a file containing an example of how to use the '_hw.tcl' 'add_hdl_instance' API. The example will be correct for the current configuration of the IP."}\
      {device_family                              NOVAL  0                0                NOVAL                                                               false   false           STRING       "Arria VI"               NOVAL                                                 true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      {device                                     NOVAL  0                0                NOVAL                                                               false   false           STRING       "Unknown"                NOVAL                                                 true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      {base_device                                NOVAL  0                0                NOVAL                                                               false   false           STRING       "Unknown"                NOVAL                                                 true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      \
      {test_mode                                  NOVAL  0                0                NOVAL                                                               false   false           INTEGER      0                        NOVAL                                                 true                     false                        BOOLEAN       NOVAL         "PLL"                          "Enable Test Mode"                                      NOVAL}\
      \
      {enable_pld_atx_cal_busy_port               NOVAL  1                1                NOVAL                                                               false   false           INTEGER      1                        { 0 1 }                                               false                    false                        BOOLEAN       NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      \
      {enable_debug_ports_parameters              NOVAL  0                0                NOVAL                                                               false   false           INTEGER      0                        NOVAL                                                 enable_advanced_options  enable_advanced_options      BOOLEAN       NOVAL         "General"                      "Enable debug ports & parameters"                       NOVAL}\
      {support_mode                               NOVAL  1                0                ::altera_xcvr_atx_pll_vi::parameters::validate_support_mode         false   false           STRING       "user_mode"              {"user_mode" "engineering_mode"}                      enable_advanced_options  enable_advanced_options      NOVAL         NOVAL         "General"                      "Support mode"                                          "Selects the support mode (user or engineering). Engineering mode options are not officially supported by Intel or Quartus Prime."}\
      {message_level                              NOVAL  0                0                NOVAL                                                               false   false           STRING       "error"                  {error warning}                                       true                     true                         NOVAL         NOVAL         "General"                      "Message level for rule violations"                     "Specifies the messaging level to use for parameter rule violations. Selecting \"error\" will cause all rule violations to prevent IP generation. Selecting \"warning\" will display all rule violations as warnings and will allow IP generation in spite of violations."}\
      {pma_speedgrade                             NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::validate_pma_speedgrade       true    false           STRING       "e2"                     NOVAL                                                 true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      {device_revision                            NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::validate_device_revision      true    false           STRING       "20nm5es"                { "20nm5es" "20nm5es2" "20nm4es" "20nm4es2" "20nm5" "20nm4" "20nm3" "20nm2" "20nm1"}                                                 true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      {prot_mode                                  NOVAL  1                0                ::altera_xcvr_atx_pll_vi::parameters::validate_prot_mode            false   false           STRING       "Basic"                  { "Basic" "PCIe Gen 1" "PCIe Gen 2" "PCIe Gen 3" "SDI_cascade" "OTN_cascade" "UPI TX" "SAS TX"}  true                         true          NOVAL         NOVAL                          "General"                                               "Protocol mode"                                         "The parameter is used to govern the rules for internal settings of the VCO. This parameter is not a \"preset\". You must still correctly set all other parameters for your protocol and application. SDI_cascade and OTN_cascade are supported cascade mode configurations and enables \"ATX to FPLL cascade output port\", \"manual configuration of counters\" and \"fractional mode\". Protocol mode SDI_cascade enables SDI cascade tule checks and OTN_cascade enables OTN cascade rule checks."}\
      {prot_mode_fnl                              NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::convert_prot_mode             true    false           STRING       "basic_tx"               NOVAL                                                 true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      {primary_use                                NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::determine_primary_use         true    false           STRING       "hssi_x1"                {"hssi_x1" "hssi_hf" "hssi_cascade"}                  true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      {bw_sel                                     NOVAL  1                0                NOVAL                                                               false   false           STRING       "medium"                 {"low" "medium" "high"}                               "!enable_atx_to_fpll_cascade_out"  true                         NOVAL         NOVAL         "General"                      "Bandwidth"                                             "Specifies the VCO bandwidth."}\
      {refclk_cnt                                 NOVAL  1                1                NOVAL                                                               false   false           INTEGER      1                        { 1 2 3 4 5 }                                         true                     true                         NOVAL         NOVAL         "General"                      "Number of PLL reference clocks"                        "Specifies the number of input reference clocks for the ATX PLL."}\
      {refclk_index                               NOVAL  1                0                ::altera_xcvr_atx_pll_vi::parameters::update_refclk_index           false   false           INTEGER      0                        NOVAL                                                 true                     true                         NOVAL         NOVAL         "General"                      "Selected reference clock source"                       "Specifies the initially selected reference clock input to the ATX PLL."}\
      {silicon_rev                                NOVAL  0                0                NOVAL                                                               false   false           BOOLEAN      false                    NOVAL                                                 true                     false                        NOVAL         NOVAL         "General"                      "Silicon revision ES"                                   NOVAL}\
      \
      {fb_select_fnl                              NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::convert_fb_select             true    false           STRING       "direct_fb"              { "direct_fb" "iqtxrxclk_fb" }                        true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      {primary_pll_buffer                         NOVAL  1                0                ::altera_xcvr_atx_pll_vi::parameters::validate_primary_pll_buffer   false   false           STRING       "GX clock output buffer" { "GX clock output buffer" "GT clock output buffer"} "!enable_atx_to_fpll_cascade_out" true NOVAL       NOVAL         "Ports"                        "Primary PLL clock output buffer"                       "Specifies initially which PLL output is active. If GX is selected \"Enable PLL GX clock output port\" should be enabled as well, if GT is selected \"Enable PLL GT clock output port\" should be enabled as well."}\
      {enable_8G_buffer_fnl                       NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::update_enable_8G_buffer_fnl   true    false           STRING       "true"                   { "true" "false" }                                    true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      {enable_16G_buffer_fnl                      NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::update_enable_16G_buffer_fnl  true    false           STRING       "false"                  { "true" "false" }                                    true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      {enable_8G_path                             NOVAL  1                1                NOVAL                                                               false   false           INTEGER      1                        NOVAL                                                 "!enable_atx_to_fpll_cascade_out" true                BOOLEAN       NOVAL         "Ports"                        "Enable PLL GX clock output port"                       "GX output port feeds x1 clock lines. Must be selected for PLL output frequency smaller than 8.7GHz. If GX is selected in \"Primary PLL clock output buffer\", the port should be enabled as well."}\
      {enable_16G_path                            NOVAL  1                1                NOVAL                                                               false   false           INTEGER      0                        NOVAL                                                 "!enable_atx_to_fpll_cascade_out" true                BOOLEAN       NOVAL         "Ports"                        "Enable PLL GT clock output port"                       "GT output port feeds dedicated high speed clock lines. Must be selected for PLL output frequency greater than 8.7GHz. If GT is selected in \"Primary PLL clock output buffer\", the port should be enabled as well."}\
      {enable_pcie_clk                            NOVAL  1                1                NOVAL                                                               false   false           INTEGER      0                        NOVAL                                                 "!enable_atx_to_fpll_cascade_out" true                BOOLEAN       NOVAL         "Ports"                        "Enable PCIe clock output port"                         "This is the 500 MHz fixed PCIe clock output port and is intended for PIPE mode. The port should be connected to \"pipe hclk input port\"."}\
      {enable_cascade_out                         NOVAL  1                1                NOVAL                                                               false   false           INTEGER      0                        NOVAL                                                 enable_advanced_options  enable_advanced_options      BOOLEAN       NOVAL         "Ports"                        "Enable cascade clock output port"                      NOVAL}\
      {enable_atx_to_fpll_cascade_out             NOVAL  1                1                ::altera_xcvr_atx_pll_vi::parameters::update_enable_atx_to_fpll_cascade_out	true   false  INTEGER      0                        NOVAL                                                 true                     true                         BOOLEAN       NOVAL         "Ports"                        "Enable ATX to FPLL cascade clock output port"          "Enables the ATX to FPLL cascade clock output port. This option selects Frcational mode and  \"Configure counters manually\" option. OTN_cascade protocol mode enables OTN rule checks and SDI_cascade mode enables SDI rule checks"}\
      {enable_hip_cal_done_port                   NOVAL  1                1                NOVAL                                                               false   false           INTEGER      0                        NOVAL                                                 enable_hip_options       enable_hip_options           BOOLEAN       NOVAL         "Ports"                        "Enable calibration status ports for HIP"               "Enables calibration status port from PLL and Master CGB(if enabled) for HIP"}\
      {set_hip_cal_en                             NOVAL  1                0                NOVAL                                                               false   false           INTEGER      0                        NOVAL                                                 enable_hip_options       enable_hip_options           BOOLEAN       NOVAL         "Ports"                        "Enable PCIe hard IP calibration"                       "INTERNAL USE ONLY. Enabling this parameter prioritizes the calibration for PCIe hard IP channels."}\
      {hip_cal_en                                 NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::validate_hip_cal_en           true    true            STRING       "disable"                { "enable" "disable" }                                enable_hip_options       false                        NOVAL         NOVAL         "Ports"                        NOVAL                                                   "INTERNAL USE ONLY. Enabling this parameter prioritizes the calibration for PCIe hard IP channels."}\
      \
      {dsm_mode                                   NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::convert_dsm_mode              true    false           STRING       "dsm_mode_integer"       { "dsm_mode_integer" "dsm_mode_phase" }               true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      \
      {set_output_clock_frequency                 NOVAL  1                0         ::altera_xcvr_atx_pll_vi::parameters::validate_set_output_clock_frequency  false   false           FLOAT        625.0                   NOVAL                                                 true                     "!select_manual_config"      NOVAL         MHz           "Output Frequency"             "PLL output frequency"                                  "Specifies the target output frequency for the PLL."}\
      {output_clock_datarate                      NOVAL  1                0                ::altera_xcvr_atx_pll_vi::parameters::update_output_clock_datarate  true    false           FLOAT        5000.0                   NOVAL                                                 true                     "!select_manual_config"      NOVAL         Mbps           "Output Frequency"             "PLL output datarate"                                   "Specifies the target datarate for which the PLL will be used."}\
      {output_clock_frequency                  advanced  0                0                ::altera_xcvr_atx_pll_vi::parameters::update_output_clock_frequency true    false           STRING       "625 MHz"               NOVAL                                                 true                     select_manual_config         NOVAL         NOVAL         "Output Frequency"             "PLL output frequency"                                  NOVAL}\
      {vco_freq                                advanced  0                0                ::altera_xcvr_atx_pll_vi::parameters::update_vco_freq               true    false           STRING       "0 MHz"                  NOVAL                                                 true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      {datarate                                advanced  1                0                ::altera_xcvr_atx_pll_vi::parameters::update_datarate               true    false           STRING       "0 Mbps"                 NOVAL                                                 true                     false                        NOVAL         Mbps          NOVAL                          NOVAL                                                   "Specifies the target datarate for which the PLL will be used."}\
      \
      {enable_fractional                          NOVAL  0                0                NOVAL                                                               true   false           INTEGER      0                        NOVAL                                                 true                     false                         NOVAL        NOVAL          NOVAL                          NOVAL                                                   NOVAL}\
      {set_auto_reference_clock_frequency         NOVAL  1                0                ::altera_xcvr_atx_pll_vi::parameters::update_refclk_auto            false   false           FLOAT        156.250000               NOVAL                                                 true      "!select_manual_config&!enable_fractional"  NOVAL         MHz           "Output Frequency"             "PLL integer reference clock frequency"                 "Selects the input reference clock frequency for the PLL."}\
      {set_manual_reference_clock_frequency       NOVAL  1                0                NOVAL                                                               false   false           FLOAT        200.000000               NOVAL                                                 true                     select_manual_config         NOVAL         MHz           "Output Frequency"             "PLL fractional reference clock frequency"                         NOVAL}\
      {reference_clock_frequency_fnl              NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::update_reflk_freq             true    false           STRING       "156.250000 MHz"         NOVAL                                                 true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      {set_fref_clock_frequency                   NOVAL  1                0                NOVAL                                                               false   false           FLOAT        156.250000               NOVAL                                                 true      "enable_fractional&!select_manual_config"   NOVAL         MHz           "Output Frequency"             "PLL fractional reference clock frequency"              "Selects the fractional reference clock frequency for the PLL."}\
      \
      {feedback_clock_frequency_fnl               NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::update_fbclk_freq             true    false           FLOAT        156.250000               NOVAL                                                 true                     false                        NOVAL         MHz           "Output Frequency"             "External feedback frequency"                           "In feedback compensation bonding mode. The feedback frequency is determined based on \"Master CGB division factor\", \"Master CGB pma width\" and \"PLL output frequency\""}\
      \
      {select_manual_config                       NOVAL  1                0                ::altera_xcvr_atx_pll_vi::parameters::update_manual_config          true   false           BOOLEAN      false                    NOVAL                                                 true                     "enable_manual_configuration"  BOOLEAN       NOVAL         "Output Frequency"             "Configure counters manually"                           "Enables manual control of PLL counters.Available only in ATX to FPLL cascade configuration"}\
      {m_counter                                  NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::update_m_counter              true    false           INTEGER      NOVAL                    NOVAL                                                 true          "(!select_manual_config)&&(!enable_fb_comp_bonding_fnl)"    NOVAL         NOVAL         "Output Frequency"             "Multiply factor (M-Counter)"                           "Specifies the M-counter."}\
      {effective_m_counter                        NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::update_effective_m_counter    true    false           INTEGER      1                        NOVAL                                                 true           "(!select_manual_config)&&(enable_fb_comp_bonding_fnl)"    NOVAL         NOVAL         "Output Frequency"             "Effective M-Counter"                                   "In feedback compensation bonding modes, ratio of output clock to feedback clock." }\
      {set_m_counter                              NOVAL  1                0                ::altera_xcvr_atx_pll_vi::parameters::update_manual_config           false   false          INTEGER      24                       NOVAL                                                 true                     select_manual_config         NOVAL         NOVAL         "Output Frequency"             "Multiply factor (M-Counter)"                           "Specifies the M-counter.See the Transceivers User Manual for detailed description."}\
      {ref_clk_div                                NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::update_n_counter              true    false           INTEGER      NOVAL                    NOVAL                                                 true                     "!select_manual_config"      NOVAL         NOVAL         "Output Frequency"             "Divide factor (N-Counter)"                             "Specifies the N-counter. See the Transceivers User Manual for detailed description."}\
      {set_ref_clk_div                            NOVAL  1                0                ::altera_xcvr_atx_pll_vi::parameters::update_manual_config          false   false           INTEGER      1                        { 1 2 4 8 }                                           true                     select_manual_config         NOVAL         NOVAL         "Output Frequency"             "Divide factor (N-Counter)"                             "Specifies the N-counter. See the Transceivers User Manual for detailed description."}\
      {l_counter                                  NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::update_l_counter              true    false           INTEGER      NOVAL                    NOVAL                                                 true                     "!enable_atx_to_fpll_cascade_out&&!select_manual_config"      NOVAL         NOVAL         "Output Frequency"             "Divide factor (L-Counter)"                             "Specifies the L Counter. See the Transceivers User Manual for detailed description."}\
      {set_l_counter                              NOVAL  1                0                ::altera_xcvr_atx_pll_vi::parameters::update_manual_config          false   false           INTEGER      16                       { 1 2 4 8 16 }                                        true                     "!enable_atx_to_fpll_cascade_out&&select_manual_config"         NOVAL         NOVAL         "Output Frequency"             "Divide factor (L-Counter)"                             "Specifies the L-counter and is intended for non-cascade mode. See the Transceivers User Manual for detailed description."}\
      {l_cascade_counter                          NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::update_l_cascade_counter      true    false           INTEGER      NOVAL                    NOVAL                                                 true                     "enable_atx_to_fpll_cascade_out&&!select_manual_config"      NOVAL         NOVAL         "Output Frequency"             "Divide factor (L-Cascade-Counter)"                             "Specifies the L-Cascade counter and is intended for cascade mode. See the Transceivers User Manual for detailed description."}\
      {set_l_cascade_counter                      NOVAL  1                0                ::altera_xcvr_atx_pll_vi::parameters::update_manual_config          false   false           INTEGER      15                       { 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 }                                     true                     "enable_atx_to_fpll_cascade_out&&select_manual_config"         NOVAL         NOVAL         "Output Frequency"             "Divide factor (L-Cascade Counter)"                             "Specifies the L-Cascade counter and is intended for cascade mode. See the Transceivers User Manual for detailed description."}\
      {l_cascade_predivider                       NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::update_l_cascade_predivider   true    false           INTEGER      NOVAL                    NOVAL                                                 true                     "enable_atx_to_fpll_cascade_out&&!select_manual_config"      NOVAL         NOVAL         "Output Frequency"             "Divide factor (L-Cascade-Predivider)"                             "Specifies the L-Cascade predivider value and is intended for cascade mode. 1 when vco frequency is less than or equal to 10G, 2 when vco frequency is greater than 10G. See the Transceivers User Manual for detailed description."}\
      {set_l_cascade_predivider                   NOVAL  1                0                NOVAL                                                               false   false           INTEGER      1                        { 1 2 }                                               true                     "enable_atx_to_fpll_cascade_out&&select_manual_config"         NOVAL         NOVAL         "Output Frequency"             "predivide factor (L-Cascade Predivider)"                             "Specifies the L-Cascade predivider value and is intended for cascade mode. 1 when vco frequency is less than or equal to 10G and 2 when vco frequency is greater than 10G. See the Transceivers User Manual for detailed description."}\
      {k_counter                                  NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::update_k_counter              true    false           LONG         NOVAL                    NOVAL                                                 true       "enable_fractional&&!select_manual_config" NOVAL         NOVAL         "Output Frequency"             "Fractional multiply factor (K)"                        "Specifies the K counter. See the Transceivers User Manual for detailed description."}\
      {set_k_counter                              NOVAL  1                0                ::altera_xcvr_atx_pll_vi::parameters::validate_k_counter            false   false           LONG         2000000000               NOVAL                                                 true       "enable_fractional&&select_manual_config"  NOVAL         NOVAL         "Output Frequency"             "Fractional multiply factor (K)"                        "Specifies the K counter. See the Transceivers User Manual for detailed description."}\
       \
      {auto_list                                  NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::calculate_pll_auto            true    false           STRING       NOVAL                    NOVAL                                                 true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      {manual_list                                NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::calculate_pll_manual          true    false           STRING       NOVAL                    NOVAL                                                 true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      {pll_setting                                NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::update_pll_setting            true    false           STRING       NOVAL                    NOVAL                                                 true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      \
      {enable_fb_comp_bonding_fnl                 NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::convert_fb_comp_bonding       true    false           INTEGER      0                        {0 1}                                                 true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      \
      {check_output_ports_pll                     NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::validate_check_output_ports_pll  true    false        INTEGER      0                        {0 1}                                                 false                    false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      {iqclk_mux_sel                              NOVAL  0                0                NOVAL                                                               true    false           STRING       "iqtxrxclk0"             NOVAL                                                 true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      \
      {set_altera_xcvr_atx_pll_a10_calibration_en NOVAL  0                0                NOVAL                                                               false   false           INTEGER      1                        NOVAL                                                 enable_advanced_options  enable_advanced_options      BOOLEAN       NOVAL         "General"                      "Enable calibration"                                    "Enable transceiver calibration algorithms."}\
      {calibration_en                             NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::validate_enable_calibration   true    true            STRING       "enable"           { "enable" "disable" }                                      enable_advanced_options  false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
      {enable_analog_resets                       NOVAL  0                0                NOVAL                                                               false   true            INTEGER      0                  NOVAL                                                       enable_advanced_options  enable_advanced_options      BOOLEAN       NOVAL         "General"                      "Enable pll_powerdown and mcgb_rst connections"         "INTERNAL USE ONLY. When selected, the pll_powerdown and mcgb_rst input ports will be connected internally in the IP. Otherwise and by default these ports are made present but have no affect when asserted."}\
      {enable_ext_lockdetect_ports                NOVAL  0                0                NOVAL                                                               false   false           INTEGER      0                  NOVAL                                                 true                    true                          BOOLEAN       NOVAL         "Ports"             "Enable clklow and fref ports"                  "Enables fref and clklow clock ports for external lock detector."}\
		       
   }

#{dsm_out_sel                                NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::update_dsm_out_sel            true    false           STRING       NOVAL                    NOVAL                                                 true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
#{fractional_value_ready               0                0                ::altera_xcvr_atx_pll_vi::parameters::update_fractional_value_ready true    false           STRING       NOVAL                    NOVAL                                                 true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
#{frac_list                            0                0                ::altera_xcvr_atx_pll_vi::parameters::calculate_pll_auto_fract      true    false           STRING       NOVAL                    NOVAL                                                 true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
#      {tank_sel                                   NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::update_tank_sel               true    false           STRING       NOVAL                    NOVAL                                                 true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\
#      {tank_band                                  NOVAL  0                0                ::altera_xcvr_atx_pll_vi::parameters::update_tank_band              true    false           STRING       NOVAL                    NOVAL                                                 true                     false                        NOVAL         NOVAL         NOVAL                          NOVAL                                                   NOVAL}\

set parameters_allowed_range {\
      {NAME           ALLOWED_RANGES }\
      {prot_mode_fnl  { "unused" "basic_tx" "basic_kr_tx" "pcie_gen1_tx" "pcie_gen2_tx" "pcie_gen3_tx" "pcie_gen4_tx" "cei_tx" "qpi_tx" "cpri_tx" "fc_tx" "srio_tx" "gpon_tx" "sdi_tx" "sata_tx" "xaui_tx" "obsai_tx" "gige_tx" "higig_tx" "sonet_tx" "sfp_tx" "xfp_tx" "sfi_tx" "upi_tx" "sas_tx" } }\
      {bw_sel         { "low" "medium" "high" } }\
      {set_m_counter  { 100 80 64 60 50 48 40 36 32 30 25 24 20 18 16 15 12 10  9  8  6  5   4   3   2   1 } }\
   }

set mapped_parameters {\
      { NAME                               M_AUTOSET   M_AUTOWARN   M_MAPS_FROM                      VALIDATION_CALLBACK                                             M_MAP_VALUES }\
      { select_manual_config               false       true         enable_atx_to_fpll_cascade_out	::altera_xcvr_atx_pll_vi::parameters::update_manual_config   {"1:true" "0:false"}  }\
      { enable_fractional                  false       true         enable_atx_to_fpll_cascade_out	NOVAL                                                        NOVAL }\
      { enable_atx_to_fpll_cascade_out     false       true         prot_mode                     	NOVAL                                                        {"SDI_cascade:1" "OTN_cascade:1" "Basic:0" "PCIe Gen 1:0" "PCIe Gen 2:0" "PCIe Gen 3:0" "UPI TX:0" "SAS TX:0"}}\
}


## \todo atx_pll_cgb_div maps from another package -- fix that
## \todo atx_pll_bonding_mode maps from another package -- fix that
## \note atx_pll_bonding_mode default is cpri -- but it is ok, fitter will ignore it if overall feedback mode is internal
set atom_parameters {\
      { NAME                                          M_AUTOSET  TYPE       DERIVED   M_MAPS_FROM                     HDL_PARAMETER   ENABLED   VISIBLE   VALIDATION_CALLBACK                                   M_CONTEXT DISPLAY_NAME  M_MAP_VALUES }\
      { atx_pll_primary_use                           false      STRING     true      primary_use                     true            false     false     NOVAL                                                     NOVAL   NOVAL       NOVAL }\
      { atx_pll_bonding_mode                          false      STRING     true      enable_fb_comp_bonding_fnl      true            false     false     NOVAL                                                     NOVAL   NOVAL       {"0:cpri_bonding" "1:pll_bonding"} }\
      { atx_pll_cgb_div                               false      INTEGER    true      mcgb_div_fnl                    true            false     false     NOVAL                                                     NOVAL   NOVAL       NOVAL }\
      { atx_pll_pma_width                             false      INTEGER    true      NOVAL                           true            false     false     ::altera_xcvr_atx_pll_vi::parameters::convert_pma_width   NOVAL   NOVAL       NOVAL }\
      { atx_pll_pm_speed_grade                        false      STRING     true      pma_speedgrade                  false           false     false     NOVAL                                                     NOVAL   NOVAL       NOVAL }\
      { atx_pll_prot_mode                             false      STRING     true      prot_mode_fnl                   true            false     false     NOVAL                                                     NOVAL   NOVAL       NOVAL }\
      { atx_pll_bw_sel                                false      STRING     true      bw_sel                          true            false     false     NOVAL                                                     NOVAL   NOVAL       NOVAL }\
      { atx_pll_silicon_rev                           false      STRING     true      device_revision                 true            false     false     NOVAL                                                     NOVAL   NOVAL       NOVAL }\
      { atx_pll_fb_select                             false      STRING     true      fb_select_fnl                   true            false     false     NOVAL                                                     NOVAL   NOVAL       NOVAL }\
      { atx_pll_l_counter_enable                      false      STRING     true      enable_8G_buffer_fnl            true            false     false     NOVAL                                                     NOVAL   NOVAL       NOVAL }\
      { atx_pll_dsm_mode                              false      STRING     true      dsm_mode                        true            false     false     NOVAL                                                     NOVAL   NOVAL       NOVAL }\
      { atx_pll_output_clock_frequency                false      STRING     true      output_clock_frequency          true            false     false     ::altera_xcvr_atx_pll_vi::parameters::convert_mhz_to_hz   NOVAL   NOVAL       NOVAL }\
      { atx_pll_reference_clock_frequency             false      STRING     true      reference_clock_frequency_fnl   true            false     false     ::altera_xcvr_atx_pll_vi::parameters::convert_mhz_to_hz   NOVAL   NOVAL       NOVAL }\
      { atx_pll_m_counter                             false      INTEGER    true      m_counter                       true            false     false     NOVAL                                                     advanced "M counter"       NOVAL }\
      { atx_pll_ref_clk_div                           false      INTEGER    true      ref_clk_div                     true            false     false     NOVAL                                                     advanced "N counter"       NOVAL }\
      { atx_pll_l_counter                             false      INTEGER    true      l_counter                       true            false     false     NOVAL                                                     advanced "L counter (valid in non-cascade mode)"       NOVAL }\
      { atx_pll_lc_to_fpll_l_counter_scratch	      true       INTEGER    true      l_cascade_counter               true            false     false     NOVAL                                                     advanced "L cascade counter (valid in cascade mode)"       NOVAL }\
      { atx_pll_fpll_refclk_selection		      false      STRING     true      NOVAL            true            false     false     ::altera_xcvr_atx_pll_vi::parameters::validate_atx_pll_fpll_refclk_selection  advanced "L cascade predivider/VCO divider(valid in cascade mode) "      NOVAL }\
      { atx_pll_dsm_fractional_division               false      STRING     true      k_counter                       true            false     false     NOVAL                                                     advanced "K counter (valid in fractional mode)"   NOVAL       NOVAL }\
      { hssi_pma_lc_refclk_select_mux_silicon_rev     false      STRING     true      device_revision                 true            false     false     NOVAL                                                     NOVAL   NOVAL       NOVAL }\
      { hssi_pma_lc_refclk_select_mux_refclk_select   false      STRING     true      refclk_index                    true            false     false     NOVAL                                                     NOVAL   NOVAL       {"0:ref_iqclk0" "1:ref_iqclk1" "2:ref_iqclk2" "3:ref_iqclk3" "4:ref_iqclk4"} }\
      { hssi_refclk_divider_silicon_rev               false      STRING     true      device_revision                 true            false     false     NOVAL                                                     NOVAL   NOVAL       NOVAL }\
      { atx_pll_vco_freq                              false      STRING     true      vco_freq                        true            false     false     ::altera_xcvr_atx_pll_vi::parameters::convert_mhz_to_hz   NOVAL "VCO Frequency"    NOVAL }\
      { atx_pll_datarate                              false      STRING     true      datarate                        true            false     false     ::altera_xcvr_atx_pll_vi::parameters::convert_mbps_to_bps NOVAL "Datarate"         NOVAL }\
      { atx_pll_iqclk_mux_sel                         false      STRING     true      iqclk_mux_sel                   true            false     false     NOVAL                                                     NOVAL   NOVAL       NOVAL }\
      { hssi_pma_lc_refclk_select_mux_inclk0_logical_to_physical_mapping false STRING     true      refclk_cnt                      true            false     false     NOVAL                                                     NOVAL   NOVAL       {"1:ref_iqclk0" "2:ref_iqclk0" "3:ref_iqclk0" "4:ref_iqclk0" "5:ref_iqclk0"} }\
      { hssi_pma_lc_refclk_select_mux_inclk1_logical_to_physical_mapping false STRING     true      refclk_cnt                      true            false     false     NOVAL                                                     NOVAL   NOVAL       {"1:power_down" "2:ref_iqclk1" "3:ref_iqclk1" "4:ref_iqclk1" "5:ref_iqclk1"} }\
      { hssi_pma_lc_refclk_select_mux_inclk2_logical_to_physical_mapping false STRING     true      refclk_cnt                      true            false     false     NOVAL                                                     NOVAL   NOVAL       {"1:power_down" "2:power_down" "3:ref_iqclk2" "4:ref_iqclk2" "5:ref_iqclk2"} }\
      { hssi_pma_lc_refclk_select_mux_inclk3_logical_to_physical_mapping false STRING     true      refclk_cnt                      true            false     false     NOVAL                                                     NOVAL   NOVAL       {"1:power_down" "2:power_down" "3:power_down" "4:ref_iqclk3" "5:ref_iqclk3"} }\
      { hssi_pma_lc_refclk_select_mux_inclk4_logical_to_physical_mapping false STRING     true      refclk_cnt                      true            false     false     NOVAL                                                     NOVAL   NOVAL       {"1:power_down" "2:power_down" "3:power_down" "4:power_down" "5:ref_iqclk4"} }\
      { atx_pll_sup_mode                              false      STRING     true      support_mode                    true            false     false     NOVAL                                                     NOVAL   NOVAL       NOVAL }\
      { atx_pll_is_sdi	                              FALSE	 STRING	    TRUE          NOVAL	      TRUE	      FALSE	FALSE	  ::altera_xcvr_atx_pll_vi::parameters::validate_enable_sdi_rule_checks	NOVAL	NOVAL	NOVAL}\
      { atx_pll_is_otn	                              FALSE	 STRING	    TRUE          NOVAL	      TRUE	      FALSE	FALSE	  ::altera_xcvr_atx_pll_vi::parameters::validate_enable_otn_rule_checks	NOVAL	NOVAL	NOVAL}\
   }

#{ atx_pll_dsm_out_sel                           false      STRING     true      dsm_out_sel                     true            false     false     NOVAL                                                     NOVAL   NOVAL       NOVAL }\
#{ atx_pll_dsm_fractional_value_ready            false      1               STRING     true      fractional_value_ready          true            false     false     NOVAL                                                       NOVAL }\
#{ atx_pll_hclk_divide                           1               INTEGER    true      hclk_divide                     true            false     false     NOVAL                                                       NOVAL }
#      { atx_pll_tank_sel                              false      STRING     true      tank_sel                        true            false     false     NOVAL                                                     advanced "Tank selection"  NOVAL }\
#      { atx_pll_tank_band                             false      STRING     true      tank_band                       true            false     false     NOVAL                                                     NOVAL   NOVAL       NOVAL }\

set logical_parameters {\
      { NAME                    TYPE       DERIVED   M_MAPS_FROM                     HDL_PARAMETER   ENABLED   VISIBLE   M_MAP_VALUES }\
      { lc_refclk_select        INTEGER    true      refclk_index                    false           false     false     NOVAL }\
   }

set static_hdl_parameters {\
      { NAME                                                               M_AUTOSET       TYPE       DERIVED   HDL_PARAMETER   ENABLED   VISIBLE   DEFAULT_VALUE             VALIDATION_CALLBACK}\
      { atx_pll_initial_settings                                                false           STRING     true      true            false     false     "true"                    NOVAL }\
   }

set gui_parameter_list [list]
set gui_parameter_values [list]
}

##################################################################################################################################################
#
##################################################################################################################################################
proc ::altera_xcvr_atx_pll_vi::parameters::declare_parameters { {device_family "Arria VI"} } {
   variable display_items_pll
   variable generation_display_items
   variable parameters
   variable parameters_allowed_range
   variable atom_parameters
   variable mapped_parameters
   variable logical_parameters
   variable static_hdl_parameters

   variable gui_parameter_list
   variable gui_parameter_values

   # Which parameters are included in reconfig reports is parameter dependent
   ip_add_user_property_type M_RCFG_REPORT integer

   ::alt_xcvr::utils::reconfiguration_arria10::declare_parameters 1
   ip_set "parameter.rcfg_file_prefix.DEFAULT_VALUE" "altera_xcvr_atx_pll_a10"
   ip_declare_parameters [::nf_atx_pll::parameters::get_parameters]
   
   # Mark HDL parameters
   set nf_atx_pll_parameters [ip_get_matching_parameters [dict set criteria M_IP_CORE nf_atx_pll]]
   foreach param $nf_atx_pll_parameters {
     if {[ip_get "parameter.${param}.M_IS_STATIC_HDL_PARAMETER"] == "false"} {
       ip_set "parameter.${param}.HDL_PARAMETER" 1
       ip_set "parameter.${param}.M_RCFG_REPORT" 1
     }
     
	 ip_set "parameter.${param}.M_AUTOSET" "true"
     ip_set "parameter.${param}.M_AUTOWARN" "true"
   }

   ip_declare_parameters $parameters
   ip_declare_parameters $parameters_allowed_range
   ip_declare_parameters $mapped_parameters
   ip_declare_parameters $atom_parameters
   ip_declare_parameters $logical_parameters
   ip_declare_parameters $static_hdl_parameters

   ::mcgb_package_vi::mcgb::set_hip_cal_done_enable_maps_from enable_hip_cal_done_port
   ::mcgb_package_vi::mcgb::set_output_clock_frequency_maps_from output_clock_frequency
   ::mcgb_package_vi::mcgb::set_primary_pll_buffer_maps_from primary_pll_buffer
   ::mcgb_package_vi::mcgb::set_protocol_mode_maps_from prot_mode_fnl
   ::mcgb_package_vi::mcgb::set_silicon_rev_maps_from device_revision
   ::mcgb_package_vi::mcgb::declare_mcgb_parameters

   ip_declare_display_items $display_items_pll

   ::mcgb_package_vi::mcgb::set_mcgb_display_item_properties "" tab
   ::mcgb_package_vi::mcgb::declare_mcgb_display_items

   ::alt_xcvr::utils::reconfiguration_arria10::declare_display_items "" tab 1

   ip_declare_display_items $generation_display_items

   # Initialize device information (to allow sharing of this function across device families)
   ip_set "parameter.device_family.SYSTEM_INFO" DEVICE_FAMILY
   ip_set "parameter.device_family.DEFAULT_VALUE" $device_family

   # Initialize part number & revision
   ip_set "parameter.device.SYSTEM_INFO" DEVICE
   
   ip_set "parameter.base_device.SYSTEM_INFO_TYPE" PART_TRAIT
   ip_set "parameter.base_device.SYSTEM_INFO_ARG" BASE_DEVICE
   ip_set "parameter.base_device.DEFAULT_VALUE" "nightfury5es";#temporary hack once BASE_DEVICE is properly supported by qsys remove this line

    # To have a parameter displayed in the "Advanced Parameters" tab, set the M_CONTEXT property
    # of that parameter to "advanced" and set its DISPLAY_NAME property to a valid string.
   add_display_item "" "Advanced Parameters" GROUP tab   

   add_parameter gui_parameter_list STRING_LIST
   set_parameter_property gui_parameter_list DISPLAY_NAME "Parameter Names"
   set_parameter_property gui_parameter_list DERIVED true
   set_parameter_property gui_parameter_list DESCRIPTION "Shows the list of advanced PLL parameters"

   add_parameter gui_parameter_values STRING_LIST
   set_parameter_property gui_parameter_values DISPLAY_NAME "Parameter Values"
   set_parameter_property gui_parameter_values DERIVED true
   set_parameter_property gui_parameter_values DESCRIPTION "Shows the list of values for the advanced PLL parameters"

   add_display_item "Advanced Parameters" "parameterTable" GROUP TABLE 
   set_display_item_property "parameterTable" DISPLAY_HINT { table fixed_size rows:24 } 
   add_display_item "parameterTable" gui_parameter_list parameter
   add_display_item "parameterTable" gui_parameter_values parameter

  # Grab Quartus INI's
  ip_set "parameter.enable_advanced_options.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_atx_pll_10_advanced ENABLED]
  ip_set "parameter.enable_hip_options.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_fpll_atx_pll_10_hip_options ENABLED]
}

proc ::altera_xcvr_atx_pll_vi::parameters::validate {} {
   ::alt_xcvr::ip_tcl::messages::set_auto_message_level [ip_get "parameter.message_level.value"]

    variable gui_parameter_list
    variable gui_parameter_values

    set parameter_list [list]
    set parameter_values_list [list]

    set advanced_params [ip_get_matching_parameters [dict set criteria M_CONTEXT advanced]]
    foreach param $advanced_params {
        set name [ip_get "parameter.${param}.DISPLAY_NAME"]
        if { $name != "NOVAL" } {
            lappend parameter_list $name
            lappend parameter_values_list [ip_get "parameter.${param}.value"]
        }
    }

    set_parameter_value gui_parameter_list $parameter_list
    set_parameter_value gui_parameter_values $parameter_values_list
   ip_validate_parameters
   ip_validate_display_items
}

proc ::altera_xcvr_atx_pll_vi::parameters::validate_support_mode { PROP_NAME PROP_VALUE message_level } {
  if {$PROP_VALUE == "engineering_mode"} {
    ip_message $message_level "Engineering support mode has been selected. Engineering mode is for internal use only. Intel does not officially support or guarantee IP configurations for this mode."
  }
}


##
# NOTE: this is a dummy function, for parameters that will eventually be set through a validation_callback (but the functions are not ready yet).
# The parameters are listed in the IP anyways. This is to make sure that they will be part of reconfiguration files.
# However if enumerations for those values changes due to atom map changes, existing IP variant files need to be manually edited.
# This function will enable us to prevent that
proc ::altera_xcvr_atx_pll_vi::parameters::set_to_default { PROP_NAME } {
   set value [ip_get "parameter.${PROP_NAME}.DEFAULT_VALUE"]
   ip_set "parameter.${PROP_NAME}.value" $value
}

##################################################################################################################################################
# functions: converting user parameters to their final form (appropriate for the hdl) 
##################################################################################################################################################

## \TODO some of these functions needs to be implemented as mapped parameters

proc ::altera_xcvr_atx_pll_vi::parameters::validate_pma_speedgrade { device } {
  set operating_temperature [::alt_xcvr::utils::device::get_a10_operating_temperature $device]
  set temp_pma_speed_grade [::alt_xcvr::utils::device::get_a10_pma_speedgrade $device]
  ip_message info "For the selected device($device), PLL speed grade is $temp_pma_speed_grade."

  set temp_pma_speed_grade "${operating_temperature}${temp_pma_speed_grade}"
  ip_set "parameter.pma_speedgrade.value" $temp_pma_speed_grade
}

proc ::altera_xcvr_atx_pll_vi::parameters::validate_device_revision { base_device } { 
  set temp_device_revision [nf_atx_pll::parameters::get_base_device_user_string $base_device]
  if {$temp_device_revision != "NOVAL"} {
	  ip_set "parameter.device_revision.value" $temp_device_revision
  } else {
	set device [ip_get parameter.DEVICE.value]
	ip_message error "The current selected device \"$device\" is invalid, please select a valid device to generate the IP."
  }
}

proc ::altera_xcvr_atx_pll_vi::parameters::convert_dsm_mode { enable_fractional } {
   set temp_dsm_mode "dsm_mode_integer"
   
   switch $enable_fractional {
      1   {set temp_dsm_mode "dsm_mode_phase"}
      0   {set temp_dsm_mode "dsm_mode_integer"}
      default  {set temp_dsm_mode "dsm_mode_integer"}
   }
   ip_set "parameter.dsm_mode.value" $temp_dsm_mode    
}

proc ::altera_xcvr_atx_pll_vi::parameters::update_enable_8G_buffer_fnl { primary_pll_buffer enable_atx_to_fpll_cascade_out } {
   if {       [string compare -nocase $primary_pll_buffer "GX clock output buffer"]==0 } {
      if { $enable_atx_to_fpll_cascade_out } {
         ip_set "parameter.enable_8G_buffer_fnl.value" "false"
      } else {
         ip_set "parameter.enable_8G_buffer_fnl.value" "true"
      }
   } elseif { [string compare -nocase $primary_pll_buffer "GT clock output buffer"]==0 } { 
      ip_set "parameter.enable_8G_buffer_fnl.value" "false"
   } else {
      ip_set "parameter.enable_8G_buffer_fnl.value" "true"
      ip_message warning "Unexpected primary_pll_buffer($primary_pll_buffer), enabling 8G buffer"              
   }
}

proc ::altera_xcvr_atx_pll_vi::parameters::update_enable_16G_buffer_fnl { primary_pll_buffer } {
   if {       [string compare -nocase $primary_pll_buffer "GX clock output buffer"]==0 } {
      ip_set "parameter.enable_16G_buffer_fnl.value" "false"
   } elseif { [string compare -nocase $primary_pll_buffer "GT clock output buffer"]==0 } { 
      ip_set "parameter.enable_16G_buffer_fnl.value" "true"    
   } else {
      ip_set "parameter.enable_16G_buffer_fnl.value" "false"    
      ip_message warning "Unexpected primary_pll_buffer($primary_pll_buffer), disabling 16G buffer"              
   }
}


proc  ::altera_xcvr_atx_pll_vi::parameters::convert_fb_select { hssi_pma_cgb_master_cgb_enable_iqtxrxclk} {
   if { [string compare -nocase $hssi_pma_cgb_master_cgb_enable_iqtxrxclk enable_iqtxrxclk]==0 } {         
      ip_set "parameter.fb_select_fnl.value" "iqtxrxclk_fb"
   } elseif {  [string compare -nocase $hssi_pma_cgb_master_cgb_enable_iqtxrxclk disable_iqtxrxclk]==0} {
      ip_set "parameter.fb_select_fnl.value" "direct_fb"
   } else {
      ip_set "parameter.fb_select_fnl.value" "direct_fb"
      ip_message warning "Unexpected feedback mode selecting direct_fb"
   }
}  

proc ::altera_xcvr_atx_pll_vi::parameters::validate_prot_mode { PROP_NAME PROP_VALUE prot_mode device_revision device } {
    set device_supports_cascade [::altera_xcvr_atx_pll_vi::parameters::does_this_device_support_cascade $device_revision ]
    set legal_values [list "Basic" "PCIe Gen 1"  "PCIe Gen 2"  "PCIe Gen 3" "UPI TX" "SAS TX"]
    if { [string compare -nocase $prot_mode "SDI_cascade"]==0 } {
	if { !$device_supports_cascade} {
	    auto_invalid_value_message error $PROP_NAME $PROP_VALUE $legal_values { device }
	} else {
	    ip_message warning "There are no user selectable bandwidth settings when in cascade mode.Appropriate bandwidth setting will be set by IP"
	}
    } elseif { [string compare -nocase $prot_mode "OTN_cascade"]==0 } {
	if { !$device_supports_cascade} {
	    auto_invalid_value_message error $PROP_NAME $PROP_VALUE $legal_values { device }
	} else {
	    ip_message warning "There are no user selectable bandwidth settings when in cascade mode.Appropriate bandwidth setting will be set by IP"
	}
    }
}


proc ::altera_xcvr_atx_pll_vi::parameters::convert_prot_mode { PROP_NAME PROP_VALUE prot_mode device_revision device } {
   if {       [string compare -nocase $prot_mode Basic]==0 } {
      ip_set "parameter.prot_mode_fnl.value" "basic_tx"
   } elseif { [string compare -nocase $prot_mode "PCIe Gen 1"]==0 } {
      ip_set "parameter.prot_mode_fnl.value" "pcie_gen1_tx"
   } elseif { [string compare -nocase $prot_mode "PCIe Gen 2"]==0 } {
      ip_set "parameter.prot_mode_fnl.value" "pcie_gen2_tx"
   } elseif { [string compare -nocase $prot_mode "PCIe Gen 3"]==0 } {
      ip_set "parameter.prot_mode_fnl.value" "pcie_gen3_tx"
   } elseif { [string compare -nocase $prot_mode "SDI_cascade"]==0 } {
       ip_set "parameter.prot_mode_fnl.value" "basic_tx"
   } elseif { [string compare -nocase $prot_mode "OTN_cascade"]==0 } {
      ip_set "parameter.prot_mode_fnl.value" "basic_tx"
   } elseif { [string compare -nocase $prot_mode "UPI TX"]==0 } {
      ip_set "parameter.prot_mode_fnl.value" "upi_tx"
   } elseif { [string compare -nocase $prot_mode "SAS TX"]==0 } {
      ip_set "parameter.prot_mode_fnl.value" "sas_tx"
   } else {
      ip_set "parameter.prot_mode_fnl.value" "basic_tx"
      ip_message warning "Unexpected prot_mode($prot_mode), selecting basic_tx"
   }       
}    







proc ::altera_xcvr_atx_pll_vi::parameters::update_refclk_index { refclk_cnt } { 
   # update refclk_index allowed range from 0 to refclk_cnt-1
   set new_range 0
   for {set N 1} {$N < $refclk_cnt} {incr N} {
      lappend new_range $N
   }
   ip_set "parameter.refclk_index.ALLOWED_RANGES" $new_range
}

proc ::altera_xcvr_atx_pll_vi::parameters::update_refclk_auto { select_manual_config enable_fractional auto_list set_auto_reference_clock_frequency } {
    
	if {$enable_fractional} {
      # prevent the set_auto_reference_clock_frequency (integer mode) from throwing an illegal range error
      # keep set_auto_reference_clock_frequency's allowed values to the current legal value
      set all_freqs [dict keys $auto_list]
      ip_set "parameter.set_auto_reference_clock_frequency.allowed_ranges" $set_auto_reference_clock_frequency      
    } elseif {!$select_manual_config} {#auto-config
            #get all frequencies
            set all_freqs [dict keys $auto_list]
            #update set_auto_reference_clock_frequency range
            ip_set "parameter.set_auto_reference_clock_frequency.allowed_ranges" $all_freqs 
        } else {#manual-config
            #setting allowed range to anything will prevent user getting meaningless range errors while working in manual mode
            ip_set "parameter.set_auto_reference_clock_frequency.allowed_ranges" ""
        }
}

##
# feedback_clock_frequency_fnl is the parameter used in calculations
# \todo enable_fb_comp_bonding is directly referenced BAD !!!
proc ::altera_xcvr_atx_pll_vi::parameters::update_fbclk_freq { PROP_NAME select_manual_config enable_fb_comp_bonding_fnl atx_pll_cgb_div atx_pll_pma_width set_output_clock_frequency } {
   if {$enable_fb_comp_bonding_fnl} {
      if { !$select_manual_config } {
         # this is feedback comp bonding mode, in auto configuration --> user cannot set feedback frequency it is calculated
         set temp [expr ($set_output_clock_frequency*2)/($atx_pll_cgb_div*$atx_pll_pma_width)]
         ip_set "parameter.${PROP_NAME}.value" $temp
      } else {
         # manual configuration does not implemented external feecback mode (as well as feedback compensation mode)
         #catched else where do not message
         #ip_message error "::altera_xcvr_atx_pll_vi::parameters::update_fbclk_freq:: (external feedback)/(feedback compensation bonding) not supported in manual configuration mode"
         # set to default anyways
         set value [ip_get "parameter.${PROP_NAME}.DEFAULT_VALUE"]
         ip_set "parameter.${PROP_NAME}.value" $value
      }
   } else {
      # irrelevant hence set to default anyways
      # neither set nor fnl feedback clock frequencies are shown to the user in non external feedback modes and the value itself is irrelevant to the pll calculations
      set value [ip_get "parameter.${PROP_NAME}.DEFAULT_VALUE"]
      ip_set "parameter.${PROP_NAME}.value" $value
   }
}

##
# check enable_mcgb before propagating pma_width selection to atom parameter
proc ::altera_xcvr_atx_pll_vi::parameters::convert_pma_width {PROP_NAME enable_mcgb pma_width} {
   set temp $pma_width
   if {!$enable_mcgb} {
      # do not propogate user selection if cgb not enabled
      set temp [ip_get "parameter.pma_width.DEFAULT_VALUE"]
   }

   ip_set "parameter.${PROP_NAME}.value" $temp
}


##
# check enable_mcgb and enable_bonding_clks before propagating enable_fb_comp_bonding selection to atom parameter
proc ::altera_xcvr_atx_pll_vi::parameters::convert_fb_comp_bonding {PROP_NAME enable_mcgb enable_bonding_clks enable_fb_comp_bonding} {
   if {$enable_mcgb && $enable_bonding_clks && $enable_fb_comp_bonding} {
      # do propogate user selection 
      ip_set "parameter.${PROP_NAME}.value" 1
   } else {
      ip_set "parameter.${PROP_NAME}.value" 0
   }
}

proc ::altera_xcvr_atx_pll_vi::parameters::validate_hip_cal_en { set_hip_cal_en } {
  set value [expr { $set_hip_cal_en ? "enable" : "disable"}]
  ip_set "parameter.hip_cal_en.value" $value
}

##################################################################################################################################################
# functions: manual checks
##################################################################################################################################################

##
# checks the output port usage 
# while mcgb is not there and having no output ports in PLL would not make sense
# if both PLL outputs are selected inform user that one will be active only
proc ::altera_xcvr_atx_pll_vi::parameters::validate_check_output_ports_pll {enable_8G_path enable_16G_path enable_mcgb primary_pll_buffer message_level} {
   if {!$enable_mcgb && !$enable_8G_path && !$enable_16G_path } {
      set port_name1  [ip_get "parameter.enable_8G_path.display_name"]
      set port_name2  [ip_get "parameter.enable_16G_path.display_name"]
      ip_message $message_level "Enable at least one output port for PLL using checkbox \"$port_name1\" and/or \"$port_name2\" when Master CGB is not enabled."
   }

   if {$enable_8G_path && $enable_16G_path } {
      set port_name1  [ip_get "parameter.enable_8G_path.display_name"]
      set port_name2  [ip_get "parameter.enable_16G_path.display_name"]
      set buffer_name  [ip_get "parameter.primary_pll_buffer.display_name"]
      ip_message info "Enabling both outputs (\"$port_name1\" and \"$port_name2\") is intended for reconfiguration purposes only. GX and GT outputs are mutually exclusive. Either GX or GT output port will be driven at a time depending on \"$buffer_name\" selection."
   }
}

##
# check the primary pll buffer usage
proc ::altera_xcvr_atx_pll_vi::parameters::validate_primary_pll_buffer {PROP_NAME PROP_VALUE enable_8G_path enable_16G_path prot_mode } {
   # if user enables 8G port but selects the primary buffer as GT this is problematic  - how is this ever be useful for a customer?
   # if user enables 16G port but selects the primary buffer as GX this is problematic - how is this ever be useful for a customer?
   set legal_values [expr { $enable_8G_path && !$enable_16G_path ? { "GX clock output buffer" }
                         :  !$enable_8G_path && $enable_16G_path ? { "GT clock output buffer" }
                         :                                         { "GX clock output buffer" "GT clock output buffer" } }]

   auto_invalid_value_message warning $PROP_NAME $PROP_VALUE $legal_values { enable_8G_path enable_16G_path }
}

##
# check the users setting for output clock frequency vs the primary buffer
proc ::altera_xcvr_atx_pll_vi::parameters::validate_set_output_clock_frequency { set_output_clock_frequency primary_pll_buffer atx_pll_f_min_vco atx_pll_f_max_vco atx_pll_f_max_x1 primary_use select_manual_config} {
set f_max_in_lc_to_fpll_l_counter "700000000"
#$atx_pll_f_max_x1
   #32 is the max L cascade counter
   ## Check in Auto mode the pll output clock frequency is within a range, differenr rules for cascade and non-cascade mode
    if {!$select_manual_config} {
	if {$primary_use == "hssi_cascade"} {
	    set legal_values [list [format "%0.6f" [expr ([omit_units $atx_pll_f_min_vco]/(31*1000000.0))]]:[expr ([omit_units $f_max_in_lc_to_fpll_l_counter]/1000000.0)]]
	} else {
### Now Channel minimum restriction of 1G - Channel runs at 1000 Mhz (1G) min so need to add restriction on the ATX PLL output clock frequency to be >=500 Mhz
#	    set legal_values [expr { $primary_pll_buffer == "GX clock output buffer"   ? [list [expr ([omit_units $atx_pll_f_min_vco]/(16*1000000.0))]:[expr ([omit_units $atx_pll_f_max_x1]/1000000.0)]]
#				     :                                                     [list [expr ([omit_units $atx_pll_f_max_x1]/1000000.0)]:[expr ([omit_units $atx_pll_f_max_vco]/1000000.0)]]}]
	    set legal_values [expr { $primary_pll_buffer == "GX clock output buffer"   ? [list [expr 500.0]:[expr ([omit_units $atx_pll_f_max_x1]/1000000.0)]]
				     :                                                     [list [expr ([omit_units $atx_pll_f_max_x1]/1000000.0)]:[expr ([omit_units $atx_pll_f_max_vco]/1000000.0)]]}]
	}
	auto_value_out_of_range_message error set_output_clock_frequency $set_output_clock_frequency $legal_values { primary_pll_buffer }
    }
}


##################################################################################################################################################
# functions: making pll calculations
################################################################################################################################################## 

#omit units (Hz) and return the integer converted value
proc ::altera_xcvr_atx_pll_vi::parameters::omit_units { freq } { 
  regsub -nocase -all {\D} $freq "" temp
  return [expr (wide($temp))]
}

#convert range lists to standard TCL lists
proc ::altera_xcvr_atx_pll_vi::parameters::scrub_list_values { my_list } {
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
## If in auto-configuration mode, the procedure makes RBC call. 
# result is copied into parameter.auto_list   
proc ::altera_xcvr_atx_pll_vi::parameters::calculate_pll_auto { select_manual_config test_mode \
                                                                \
                                                                pma_speedgrade enable_8G_buffer_fnl enable_16G_buffer_fnl enable_fb_comp_bonding_fnl prot_mode_fnl device_revision bw_sel \
                                                                \
                                                                enable_fractional set_fref_clock_frequency set_output_clock_frequency  feedback_clock_frequency_fnl atx_pll_cgb_div atx_pll_pma_width \
								\
                                   				atx_pll_f_max_pfd atx_pll_f_min_pfd atx_pll_f_max_vco atx_pll_f_min_vco atx_pll_f_max_ref atx_pll_f_min_ref \
								\
								prot_mode dsm_mode mcgb_div_fnl fb_select_fnl \
								\
								atx_pll_f_max_x1 atx_pll_f_max_tank_0 atx_pll_f_min_tank_0 atx_pll_f_max_tank_1 atx_pll_f_min_tank_1 atx_pll_f_max_tank_2 atx_pll_f_min_tank_2\
                                \ enable_atx_to_fpll_cascade_out primary_use\
                                message_level } {

   #ip_message warning "Enable fractional in auto is $enable_fractional ref clock is $set_fref_clock_frequency";																	
   #start with empty lists
   set legality_return ""
   ip_set "parameter.auto_list.value" ""
  
   #prepare counter lists 

   set n_counter_list [::altera_xcvr_atx_pll_vi::parameters::obtain_n_counter_values $device_revision $fb_select_fnl $prot_mode_fnl $primary_use]
   set l_counter_list [::altera_xcvr_atx_pll_vi::parameters::obtain_l_counter_values $device_revision $prot_mode_fnl]

   set allow_cascade_path [::altera_xcvr_atx_pll_vi::parameters::determine_if_cascade_path_legal $device_revision $enable_atx_to_fpll_cascade_out]

   if { $allow_cascade_path } {
      set l_cascade_counter_list [::altera_xcvr_atx_pll_vi::parameters::obtain_l_cascade_counter_values $device_revision $prot_mode_fnl]
   } else {
      set l_cascade_counter_list 0
   }
   set temp_l_counter [lindex $l_counter_list 0 ]
   set m_counter_list [::altera_xcvr_atx_pll_vi::parameters::obtain_m_counter_values $device_revision $mcgb_div_fnl $dsm_mode $fb_select_fnl $temp_l_counter $atx_pll_pma_width $prot_mode_fnl $primary_use]

   #set frquency and list constants for PLL calculations 
   set_calc_constants [omit_units $atx_pll_f_max_pfd] \
                      [omit_units $atx_pll_f_min_pfd] \
                      [omit_units $atx_pll_f_max_vco] \
                      [omit_units $atx_pll_f_min_vco] \
                      [omit_units $atx_pll_f_max_ref] \
                      [omit_units $atx_pll_f_min_ref] \
                      [omit_units $atx_pll_f_max_x1] \
                      [omit_units $atx_pll_f_min_tank_0] \
                      [omit_units $atx_pll_f_max_tank_0] \
                      [omit_units $atx_pll_f_min_tank_1] \
                      [omit_units $atx_pll_f_max_tank_1] \
                      [omit_units $atx_pll_f_min_tank_2] \
                      [omit_units $atx_pll_f_max_tank_2] \
					  $m_counter_list \
					  $n_counter_list \
					  $l_counter_list \
					  $l_cascade_counter_list

   if {$select_manual_config} {#manual-config
      ip_set "parameter.auto_list.value" ""
   } elseif {$enable_fractional} {
       if { $enable_fb_comp_bonding_fnl } {
          ip_message $message_level "Feedback compensation bonding is not available in fractional PLL mode. To use feedback compensation bonding, please uncheck \"Enable fractional mode\" under the PLL tab." 
       }

       set temp_out_freq [expr $set_output_clock_frequency*1000000]; #convert from MHz to Hz
       set temp_ref_freq [expr $set_fref_clock_frequency*1000000]; #convert from MHz to Hz
       ########### Calling fractional computation here ################
       #
       set legality_return [legality_check_fract $temp_out_freq $temp_ref_freq $allow_cascade_path $device_revision]
       #
       ################################################################
       set temp_size [dict size $legality_return]

	   set is_freq_found_intmode [ expr 0]
	   set is_freq_found_fractmode [ expr 0]
       #ip_message info "legality returned here $legality_return"

      if { $temp_size==0 } {
         #ip_message error "::altera_xcvr_atx_pll_vi::parameters::calculate_pll_auto:: No valid setting found for the specified output frequency."
		 set is_freq_found_fractmode 0
      } else {
         set status_reported [dict get $legality_return status]
		 #what if output freq not obtained using fractional mode ?
         if { $status_reported != "good" } { 
             #ip_message error "No valid setting found for the specified output frequency ($set_output_clock_frequency MHz)."
		     set is_freq_found_fractmode 0
			 
			 #check if the frequency is available through integer mode
       ########### Calling integer computation here ################
             set legality_return [legality_check_auto $temp_out_freq $enable_8G_buffer_fnl $allow_cascade_path $device_revision 1 $temp_ref_freq]
       #
       ################################################################
             set temp_size [dict size $legality_return]
             if { $temp_size==0 } {
                 #ip_message error "::altera_xcvr_atx_pll_vi::parameters::calculate_pll_auto:: No valid setting found for the specified output frequency in int mode"
				 set is_freq_found_intmode 0
             } else {
                 set status_reported [dict get $legality_return status]
                 if { $status_reported != "good" } {
                       #ip_message warning "::altera_xcvr_atx_pll_vi::parameters::calculate_pll_auto:: A valid setting found for the specified output frequency in int mode"
				       set is_freq_found_intmode 0
                 } else {
                       #ip_message warning "::altera_xcvr_atx_pll_vi::parameters::calculate_pll_auto:: A valid setting found for the specified output frequency in int mode"
				       set is_freq_found_intmode 1
			     }
            }
         } else {
		      set is_freq_found_fractmode 1

            set legality_return [dict remove $legality_return status]
            #update auto-list              
            #sort by reference clock frequencies
            set legality_return [dictsort $legality_return]
            ip_set "parameter.auto_list.value" $legality_return
			#puts "legality return is $legality_return"
		 } 
      }

	  if { $is_freq_found_fractmode==1 } {
             ip_message info "A valid setting for the specified output frequency ($set_output_clock_frequency MHz) is available in fractional mode."
	  } elseif { $is_freq_found_intmode==1 } {
             ip_message $message_level "The specified output frequency ($set_output_clock_frequency MHz) is available only in integer mode"
      } else {
             ip_message $message_level "No valid setting found for the specified output frequency ($set_output_clock_frequency MHz) is available"
	  }
	  return
   } else {#auto-config
      #ip_message info "::altera_xcvr_atx_pll_vi::parameters::calculate_pll_auto"
      if {!$test_mode} {
         if { !$enable_fb_comp_bonding_fnl  } {
            ## \todo how about all these parameters
            #set legality_check_argument "$pma_speedgrade   $enable_16G_buffer_fnl  $prot_mode_fnl  $device_revision $bw_sel \
            #                             $enable_fractional $set_output_clock_frequency MHz"
            #set legality_return [::altera_xcvr_atx_pll_vi::pll_calculations::legality_check_auto $set_output_clock_frequency 0]
            set temp_out_freq [expr $set_output_clock_frequency*1000000]; #convert from MHz to Hz
            set legality_return [legality_check_auto $temp_out_freq $enable_8G_buffer_fnl $allow_cascade_path $device_revision 0 0]; #$enable_8G_buffer_fnl will determine whether calculations made for GX or GT
         } else {
            set temp_out_freq [expr $set_output_clock_frequency*1000000]; #convert from MHz to Hz
            set temp_fb_freq [expr $feedback_clock_frequency_fnl*1000000]; #convert from MHz to Hz
            #TODO Can user set the L cascade counter in feedback compensation mode? Until we make that decision, set 'set_l_cascade_counter' to 1
            set set_l_cascade_counter 1
            set legality_return [legality_check_feedback_auto $temp_out_freq $temp_fb_freq $enable_fb_comp_bonding_fnl $l_counter_list $l_cascade_counter_list $set_l_cascade_counter $allow_cascade_path $device_revision]
         }
      } else {
         if {!$enable_fb_comp_bonding_fnl} {
            set legality_check_argument "$pma_speedgrade   $enable_8G_buffer_fnl $enable_16G_buffer_fnl  $ext_fb  $enable_fb_comp_bonding_fnl  $prot_mode_fnl  $device_revision $bw_sel \
                                         $enable_fractional $set_output_clock_frequency MHz"
            set legality_return [legality_check_auto_mockup $legality_check_argument]
         } else {
            ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::calculate_pll_auto:: Test mode does not implement pll computations for feedback compensation bonding."
         }
      }
   
      set temp_size [dict size $legality_return]
      if { $temp_size==0 } {
         ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::calculate_pll_auto:: No valid setting found for the specified output frequency."
      } else {
         set status_reported [dict get $legality_return status]
         if { $status_reported != "good" } {
            if {!$enable_fb_comp_bonding_fnl} {
               ip_message $message_level "No valid setting found for the specified output frequency ($set_output_clock_frequency MHz)."
            } else {
               if {$bw_sel == "low" || $bw_sel == "medium"} {
                   ip_message $message_level "No valid setting found for the specified output frequency ($set_output_clock_frequency MHz), pma width($atx_pll_pma_width) and Master CGB division factor($atx_pll_cgb_div).  Your selection of Bandwidth setting may also contribute to this issue."
               } else {
                   ip_message $message_level "No valid setting found for the specified output frequency ($set_output_clock_frequency MHz), pma width($atx_pll_pma_width) and Master CGB division factor($atx_pll_cgb_div)"
               }
            }
         } else {
            #remove first element - status
            set legality_return [dict remove $legality_return status]
            #sort by reference clock frequencies
            set legality_return [dictsort $legality_return]
            ip_set "parameter.auto_list.value" $legality_return
         }
      }
   }
}

#sort a dictionary by keys
proc dictsort {dict args} {
    set list [lsort -real -increasing [dict keys $dict]]
    set res {}
    foreach key $list {
        dict set res $key [dict get $dict $key] 
    }
    set res
    return $res
}

## If in manual-configuration mode, the procedure makes RBC call. 
# result is copied into parameter.manual_list
proc ::altera_xcvr_atx_pll_vi::parameters::calculate_pll_manual { select_manual_config test_mode enable_fractional\
                                                                  \
                                                                  pma_speedgrade enable_8G_buffer_fnl enable_16G_buffer_fnl enable_fb_comp_bonding_fnl prot_mode_fnl device_revision bw_sel \
                                                                  \
                                                                  set_manual_reference_clock_frequency set_m_counter set_ref_clk_div set_l_counter set_k_counter feedback_clock_frequency_fnl\
                                                                  \
                                                                  message_level\
                                                                  \
                                                                  atx_pll_f_max_pfd atx_pll_f_min_pfd atx_pll_f_max_vco atx_pll_f_min_vco atx_pll_f_max_ref atx_pll_f_min_ref atx_pll_f_max_x1 atx_pll_f_min_tank_0 atx_pll_f_min_tank_1 atx_pll_f_min_tank_2 atx_pll_f_max_tank_0 atx_pll_f_max_tank_1 atx_pll_f_max_tank_2\
                                                                  \
                                                                  fb_select_fnl mcgb_div_fnl dsm_mode atx_pll_pma_width \
																  set_l_cascade_counter set_l_cascade_predivider \
																  enable_atx_to_fpll_cascade_out primary_use\
														  } {
   set n_counter_list [::altera_xcvr_atx_pll_vi::parameters::obtain_n_counter_values $device_revision $fb_select_fnl $prot_mode_fnl $primary_use]
   set l_counter_list [::altera_xcvr_atx_pll_vi::parameters::obtain_l_counter_values $device_revision $prot_mode_fnl]

   set allow_cascade_path [::altera_xcvr_atx_pll_vi::parameters::determine_if_cascade_path_legal $device_revision $enable_atx_to_fpll_cascade_out]

   if { $allow_cascade_path } {
      set l_cascade_counter_list [::altera_xcvr_atx_pll_vi::parameters::obtain_l_cascade_counter_values $device_revision $prot_mode_fnl]
   } else {
      set l_cascade_counter_list 0
   }
   set temp_l_counter [lindex $l_counter_list 0 ]
   set m_counter_list [::altera_xcvr_atx_pll_vi::parameters::obtain_m_counter_values $device_revision $mcgb_div_fnl $dsm_mode $fb_select_fnl $temp_l_counter $atx_pll_pma_width $prot_mode_fnl $primary_use]
   
   set_calc_constants [omit_units $atx_pll_f_max_pfd] \
                      [omit_units $atx_pll_f_min_pfd] \
                      [omit_units $atx_pll_f_max_vco] \
                      [omit_units $atx_pll_f_min_vco] \
                      [omit_units $atx_pll_f_max_ref] \
                      [omit_units $atx_pll_f_min_ref] \
                      [omit_units $atx_pll_f_max_x1] \
                      [omit_units $atx_pll_f_min_tank_0] \
                      [omit_units $atx_pll_f_max_tank_0] \
                      [omit_units $atx_pll_f_min_tank_1] \
                      [omit_units $atx_pll_f_max_tank_1] \
                      [omit_units $atx_pll_f_min_tank_2] \
                      [omit_units $atx_pll_f_max_tank_2] \
					  $m_counter_list \
					  $n_counter_list \
					  $l_counter_list \
					  $l_cascade_counter_list                                                                      
   #start with empty lists
   set legality_return ""
   ip_set "parameter.manual_list.value" ""
   if {!$select_manual_config} {#auto-config
      ip_set "parameter.manual_list.value" ""
   } else {#manual-config
      ip_message info "::altera_xcvr_atx_pll_vi::parameters::calculate_pll_manual"
      if {!$test_mode} {
         if      { !$enable_fb_comp_bonding_fnl  } {
            ## \todo how about all other related parameters
            set temp_ref_freq [expr $set_manual_reference_clock_frequency*1000000]; #convert from MHz to Hz         
            set legality_return [legality_check_manual $enable_fractional $temp_ref_freq $set_l_counter $set_m_counter $set_ref_clk_div $set_k_counter $set_l_cascade_counter $set_l_cascade_predivider $allow_cascade_path $device_revision]
         } else {
            #set temp_ref_freq [expr $set_manual_reference_clock_frequency*1000000]; #convert from MHz to Hz      
            #set temp_fb_freq [expr $feedback_clock_frequency_fnl*1000000]; #convert from MHz to Hz   
            # n is inferred, m does not matter (only allow '1')
            #set legality_return [legality_check_feedback_manual $temp_ref_freq $temp_fb_freq $set_l_counter $enable_fb_comp_bonding_fnl]
            ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::calculate_pll_manual:: feedback compensation bonding not supported in manual configuration mode"
         }
      } else {
         if {!$enable_fb_comp_bonding_fnl} {
            set legality_check_argument "$pma_speedgrade                           $enable_8G_buffer_fnl  $enable_16G_buffer_fnl  $ext_fb         $enable_fb_comp_bonding_fnl        $prot_mode_fnl  $device_revision $bw_sel \
                                         $set_manual_reference_clock_frequency MHz  $set_m_counter         $set_ref_clk_div        $set_l_counter  $set_k_counter $set_l_cascade_counter"
            set legality_return [legality_check_manual_mockup $legality_check_argument]
         } else {
            ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::calculate_pll_manual:: test mode does not implement pll computations for feedback compensation bonding"
         }
      }
   
      set temp_size [dict size $legality_return]
      if { $temp_size==0 } {
         ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::calculate_pll_manual:: argument size 0"
      } else {
         set status_reported [dict get $legality_return status]
         if { $status_reported != "good" } {
		 set return_message [dict get $legality_return status_message]
#            ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::calculate_pll_manual:: invalid calculation result  $status_reported"
	     ip_message $message_level "$return_message"
#	     puts "RETURN_VALUE = $legality_return"
         } else {
            #remove first element - status
            set legality_return [dict remove $legality_return status]
            #update manual-list
            ip_set "parameter.manual_list.value" $legality_return
         }
      }
   }
}

## Whether in manual-configuration or auto-configuration mode, the procedure creates one common pll_setting to be copied into hdl parameters. 
# depending on the configuration mode the logic pupulating pll_setting changes
proc ::altera_xcvr_atx_pll_vi::parameters::update_pll_setting { select_manual_config auto_list manual_list set_auto_reference_clock_frequency \
                                                                \
                                                                set_manual_reference_clock_frequency set_m_counter set_ref_clk_div set_l_counter set_k_counter \
                                                                \
                                                                enable_fractional set_fref_clock_frequency set_output_clock_frequency \
                                                                \
                                                                message_level \
																set_l_cascade_counter \
																set_l_cascade_predivider \
														        } {
   # starting with an empty list	
   ip_set "parameter.pll_setting.value" ""
   
   # eventually temp will be copied into parameter.pll_setting
   set temp ""
  
   if {$select_manual_config} {#manual-config
      set manual_list_size [dict size $manual_list]
      if { $manual_list_size==0 } {
         ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::update_pll_setting::  argument size 0"
      } else {
         # populate temp from user input
         # if we are in this point user input is already validated
         dict set temp refclk "$set_manual_reference_clock_frequency MHz"
         dict set temp m_cnt  $set_m_counter
         dict set temp n_cnt  $set_ref_clk_div
         dict set temp l_cnt  $set_l_counter
         dict set temp k_cnt  $set_k_counter
         dict set temp l_cascade $set_l_cascade_counter
         dict set temp l_cascade_predivider $set_l_cascade_predivider
         
         # populate temp with output frequency information from calculation result 
         # with Mhz appended
         set valid_config [dict get $manual_list config]                     
         dict set temp outclk [dict get $valid_config out_freq]
         
         # populate other related calculation results
#         dict set temp tank_sel [dict get $valid_config tank_sel]
#         dict set temp tank_band [dict get $valid_config tank_band]
		 #dict set temp fractional_value_ready "pll_k_not_ready"
		 #dict set temp dsm_out_sel "pll_dsm_disable"
            
      }
   } elseif {$enable_fractional} {

      set auto_list_size [dict size $auto_list]
      if { $auto_list_size==0 } {
         # no need to print this has already been detected
         #ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::update_pll_setting::  argument size 0"
      } else {
         set ref_clk_freq_formatted [format "%.6f" $set_fref_clock_frequency]
         if { ![dict exists $auto_list $ref_clk_freq_formatted] } {
            ip_message $message_level "Selected reference clock frequency ($set_auto_reference_clock_frequency MHz) is not valid."
         } else {
	        
	        # get the line in dictionary with slected frequency  
            set selected_item [dict get $auto_list $ref_clk_freq_formatted]
            
            # populate temp with info from calculation result 
            dict set temp refclk     "$ref_clk_freq_formatted MHz"
            dict set temp m_cnt      [dict get $selected_item m]
            dict set temp n_cnt      [dict get $selected_item n]
            dict set temp l_cnt      [dict get $selected_item l]
            dict set temp k_cnt      [dict get $selected_item k]
            dict set temp l_cascade  [dict get $selected_item l_cascade]
            dict set temp l_cascade_predivider  [dict get $selected_item l_cascade_predivider]

#            dict set temp tank_sel [dict get $selected_item tank_sel]
#            dict set temp tank_band [dict get $selected_item tank_band]
			#dict set temp fractional_value_ready "pll_k_ready"
			#dict set temp dsm_out_sel "pll_dsm_3rd_order"
            
            # populate temp with output frequency using user input 
            # if we are in this point user input is already validated
            # with Mhz appended
            set user_out_freq $set_output_clock_frequency
            dict set temp outclk "$user_out_freq MHz"
         }
      }

  } else {#auto-config
      set auto_list_size [dict size $auto_list]
      if { $auto_list_size==0 } {
         # no need to print this has already been detected
         #ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::update_pll_setting::  argument size 0"
      } else {
         set ref_clk_freq_formatted [format "%.6f" $set_auto_reference_clock_frequency]
         if { ![dict exists $auto_list $ref_clk_freq_formatted] } {
            ip_message $message_level "Selected reference clock frequency ($set_auto_reference_clock_frequency MHz) is not valid."
         } else {
	        
	        # get the line in dictionary with slected frequency  
            set selected_item [dict get $auto_list $ref_clk_freq_formatted]
            
            # populate temp with info from calculation result 
            dict set temp refclk "$ref_clk_freq_formatted MHz"
            dict set temp m_cnt  [dict get $selected_item m]
            dict set temp n_cnt  [dict get $selected_item n]
            dict set temp l_cnt  [dict get $selected_item l]
            dict set temp k_cnt  [dict get $selected_item k]
            dict set temp l_cascade  [dict get $selected_item l_cascade]
            dict set temp l_cascade_predivider  [dict get $selected_item l_cascade_predivider]
#            dict set temp tank_sel [dict get $selected_item tank_sel]
#            dict set temp tank_band [dict get $selected_item tank_band]
			#dict set temp fractional_value_ready "pll_k_not_ready"
			#dict set temp dsm_out_sel "pll_dsm_disable"
            
            # populate temp with output frequency using user input 
            # if we are in this point user input is already validated
            # with Mhz appended
            set user_out_freq $set_output_clock_frequency
            dict set temp outclk "$user_out_freq MHz"
         }
      }
   }
   
   ip_set "parameter.pll_setting.value" $temp
}

## copy effective m from pll computation 
proc ::altera_xcvr_atx_pll_vi::parameters::update_effective_m_counter { PROP_NAME enable_fb_comp_bonding_fnl select_manual_config auto_list set_auto_reference_clock_frequency} {
   # set the value to default at the beginning, to prevent any unexpected outside the range errors 
   set value [ip_get "parameter.${PROP_NAME}.DEFAULT_VALUE"]
   ip_set "parameter.${PROP_NAME}.value" $value

   if {$enable_fb_comp_bonding_fnl} {#this is the only case we want this function to be executed, in other cases effective m does not matter
      if {$select_manual_config} {#manual-config
         #catched elsewhere
         #ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::update_effective_m_counter:: (external feedback)/(feedback compensation bonding) not supported in manual configuration mode""
      } else {#auto-config
         set auto_list_size [dict size $auto_list]
         if { $auto_list_size==0 } {
            # no need to print this has already been detected
            #ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::update_effective_m_counter::  argument size 0"
         } else {
            set ref_clk_freq_formatted [format "%.6f" $set_auto_reference_clock_frequency]
            if { ![dict exists $auto_list $ref_clk_freq_formatted] } {
               # no need to print this has already been detected
               # ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::update_effective_m_counter:: no entry can be found in dictionary"
            } else {
               # get the line in dictionary with selected frequency  
               set selected_item [dict get $auto_list $ref_clk_freq_formatted]
               ip_set "parameter.${PROP_NAME}.value" [dict get $selected_item effective_m]
            }
         }
      }
   }
}

#proc ::altera_xcvr_atx_pll_vi::parameters::validate_hclk_divide { m_counter } {
#   set hclk_divide_factor [get_hclk_divide $m_counter]
#   # \todo fix this mapping
#   set hclk_divide_factor 1
#   ip_set "parameter.hclk_divide.value" $hclk_divide_factor
#}
##################################################################################################################################################
# functions: copying calculated pll settings to corresponding hdl parameters 
################################################################################################################################################## 

proc ::altera_xcvr_atx_pll_vi::parameters::update_reflk_freq { pll_setting message_level } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {      
      if { ![dict exists $pll_setting refclk] } {
         ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::update_reflk_freq cannot find the entry"
      } else {
         ip_set "parameter.reference_clock_frequency_fnl.value" [dict get $pll_setting refclk]
      }
   }
}
                

proc ::altera_xcvr_atx_pll_vi::parameters::update_output_clock_frequency { pll_setting primary_pll_buffer atx_pll_f_min_vco atx_pll_f_max_vco atx_pll_f_max_x1 primary_use select_manual_config } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting outclk] } {
         ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::update_output_clock_frequency cannot find the entry"
      } else {
	  set output_clock_frequency_val [dict get $pll_setting outclk]
	  regsub -nocase -all {\D} $output_clock_frequency_val "" output_clock_frequency_val 
	  set temp_out_freq [expr $output_clock_frequency_val/1000000]; #convert from Hz to MHz
	  ip_set "parameter.output_clock_frequency.value" [dict get $pll_setting outclk]
          ## Check in manual mode the pll output clock frequency is within a range, differenr rules for cascade and non-cascade mode
	  set f_max_in_lc_to_fpll_l_counter "700000000"
	  #$atx_pll_f_max_x1
	  #32 is the max L cascade counter
	  if {$select_manual_config} {
	      if {$primary_use == "hssi_cascade"} {
		  set legal_values [list [format "%0.6f" [expr ([omit_units $atx_pll_f_min_vco]/(31*1000000.0))]]:[expr ([omit_units $f_max_in_lc_to_fpll_l_counter]/1000000.0)]]
	      } else {
### Now Channel minimum restriction of 1G - Channel runs at 1000 Mhz (1G) min so need to add restriction on the ATX PLL output clock frequency to be >=500 Mhz
#		  set legal_values [expr { $primary_pll_buffer == "GX clock output buffer"   ? [list [expr ([omit_units $atx_pll_f_min_vco]/(16*1000000.0))]:[expr ([omit_units $atx_pll_f_max_x1]/1000000.0)]]
#					   :                                                     [list [expr ([omit_units $atx_pll_f_max_x1]/1000000.0)]:[expr ([omit_units $atx_pll_f_max_vco]/1000000.0)]]}]
		  set legal_values [expr { $primary_pll_buffer == "GX clock output buffer"   ? [list [expr 500.0]:[expr ([omit_units $atx_pll_f_max_x1]/1000000.0)]]
					   :                                                     [list [expr ([omit_units $atx_pll_f_max_x1]/1000000.0)]:[expr ([omit_units $atx_pll_f_max_vco]/1000000.0)]]}]

	      }
	      manual_value_out_of_range_message error output_clock_frequency $temp_out_freq $legal_values
	  }

      }
   }
}


proc ::altera_xcvr_atx_pll_vi::parameters::update_vco_freq { l_counter l_cascade_counter l_cascade_predivider set_output_clock_frequency output_clock_frequency enable_8G_buffer_fnl enable_atx_to_fpll_cascade_out} {
    if { $enable_atx_to_fpll_cascade_out } {
           regsub -nocase -all {\m(\D)} $output_clock_frequency "" output_clock_frequency
           set temp [expr ($output_clock_frequency * $l_cascade_counter * $l_cascade_predivider) ]
           ip_set "parameter.vco_freq.value" "$temp MHz"
	} else {
       if { $enable_8G_buffer_fnl=="false" } {
           set temp $set_output_clock_frequency
           ip_set "parameter.vco_freq.value" "$temp MHz"
   	} else {
           set temp [expr ($set_output_clock_frequency * $l_counter) ]
           ip_set "parameter.vco_freq.value" "$temp MHz"
   	}
	}
}

proc ::altera_xcvr_atx_pll_vi::parameters::update_datarate { set_output_clock_frequency} {
    set temp [ expr ($set_output_clock_frequency*2) ] 
	ip_set "parameter.datarate.value" "$temp Mbps"
}


proc ::altera_xcvr_atx_pll_vi::parameters::update_output_clock_datarate { pll_setting set_output_clock_frequency message_level} {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting outclk] } {
         ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::update_output_clock_datarate cannot find the entry"
      } else {
         ip_set "parameter.output_clock_datarate.value" [ expr ($set_output_clock_frequency*2) ]
      }
   }
}


proc ::altera_xcvr_atx_pll_vi::parameters::update_m_counter { pll_setting message_level } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting m_cnt] } {
         ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::update_m_counter cannot find the entry"
      } else {
         ip_set "parameter.m_counter.value" [dict get $pll_setting m_cnt]
      }
   }
}

proc ::altera_xcvr_atx_pll_vi::parameters::update_n_counter { pll_setting message_level } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting n_cnt] } {
         ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::update_n_counter cannot find the entry"
      } else {
         ip_set "parameter.ref_clk_div.value" [dict get $pll_setting n_cnt]
      }
   }
}

proc ::altera_xcvr_atx_pll_vi::parameters::update_l_cascade_counter { pll_setting message_level } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting l_cascade ] } {
         ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::update_l_cascade_counter cannot find the entry"
      } else {
         ip_set "parameter.l_cascade_counter.value" [dict get $pll_setting l_cascade]
      }
   }
}

proc ::altera_xcvr_atx_pll_vi::parameters::update_l_cascade_predivider { pll_setting message_level } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting l_cascade_predivider ] } {
         ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::update_l_cascade_predivider cannot find the entry"
      } else {
         ip_set "parameter.l_cascade_predivider.value" [dict get $pll_setting l_cascade_predivider]
      }
   }
}

proc ::altera_xcvr_atx_pll_vi::parameters::update_l_counter { pll_setting message_level primary_use } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting l_cnt] } {
         ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::update_l_counter cannot find the entry"
      } else {
# We are forcing the value of the l_counter to be 1 to match RBC default when in cascade mode.  l_counter is not being used in this configuration 
# so it is only important to match the RBC default.  Doing this because when we start in non-cascade mode and switch over to cascade the L counter
# is hidden ... but the value that was set prior to hiding is retained when configuring in manual mode.  If this value is not set to '1' prior to
# being hidden then the value set is used and can cause an issue if it does not match the default specified in the RBC rules.
# This is a hack.  I would prefer to make a call to '::altera_xcvr_atx_pll_vi::parameters::obtain_l_counter_values' but for some reason this 
# does not have the dependency on primary_use .. it should ... so we need to determine why this is not happening.
         if {$primary_use == "hssi_cascade"} {
            ip_set "parameter.l_counter.value" 1
         } else {
            ip_set "parameter.l_counter.value" [dict get $pll_setting l_cnt]
         }
      }
   }
}

proc ::altera_xcvr_atx_pll_vi::parameters::update_k_counter { pll_setting message_level } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting k_cnt] } {
         ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::update_k_counter cannot find the entry"
      } else {
		 set value_k [dict get $pll_setting k_cnt]
         ip_set "parameter.k_counter.value" [dict get $pll_setting k_cnt]
      }
   }
}

proc ::altera_xcvr_atx_pll_vi::parameters::update_tank_sel { pll_setting message_level} {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting tank_sel] } {
         ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::update_tank_sel cannot find the entry"
      } else {
         ip_set "parameter.tank_sel.value" [dict get $pll_setting tank_sel]
      }
   }
}

proc ::altera_xcvr_atx_pll_vi::parameters::update_fractional_value_ready { pll_setting message_level } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting fractional_value_ready] } {
         ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::update_fractional_value cannot find the entry"
      } else {
         ip_set "parameter.fractional_value_ready.value" [dict get $pll_setting fractional_value_ready]
      }
   }
}


proc ::altera_xcvr_atx_pll_vi::parameters::update_dsm_out_sel { pll_setting message_level } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting dsm_out_sel] } {
         ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::update_dsm_out_sel cannot find the entry"
      } else {
         ip_set "parameter.dsm_out_sel.value" [dict get $pll_setting dsm_out_sel]
      }
   }
}

proc ::altera_xcvr_atx_pll_vi::parameters::update_tank_band { pll_setting message_level } {
   set pll_setting_size [dict size $pll_setting]
   if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting tank_band] } {
         ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::update_tank_band cannot find the entry"
      } else {
         ip_set "parameter.tank_band.value" [dict get $pll_setting tank_band]
      }
   }
}

##################################################################################################################################################
# functions: mocking rbc calls - these functions are temporary 
##################################################################################################################################################
proc ::altera_xcvr_atx_pll_vi::parameters::legality_check_auto_mockup { temp } {
   
   # example dictionary structure:	
   #      set ret { { status    good} \
   #                { "1" { {m 2} {n 3} {l 4} {k 6} {lf_resistance lf_setting0} }... }\
   #                { "2" { {m 1} {n 3} {l 4} {k 6} {lf_resistance lf_setting0} }... }\
   #              }
   
   set test_mode_lcl 1
   if { $test_mode_lcl==1 } {
      dict set ret status good
      
      set temp_set_output_clock_frequency    [ip_get "parameter.set_output_clock_frequency.value"]
      
      set refclk1 [expr  $temp_set_output_clock_frequency/10]
      set refclk1 [format "%.6f" $refclk1]
      set m_1 [expr int($refclk1/10)]
      set refclk1_str "$refclk1"
      dict set ret $refclk1_str m $m_1
      dict set ret $refclk1_str n [expr 2*$m_1]
      dict set ret $refclk1_str l [expr 3*$m_1]
      dict set ret $refclk1_str k [expr 4*$m_1]
      dict set ret $refclk1_str tank_sel "lctank0"
      dict set ret $refclk1_str tank_band "lc_band0"
      
      set refclk2 [expr  $temp_set_output_clock_frequency/5]
      set refclk2 [format "%.6f" $refclk2]
      set m_2 [expr int($refclk2/10)]
      set refclk2_str "$refclk2"
      dict set ret $refclk2_str m $m_2
      dict set ret $refclk2_str n [expr 2*$m_2]
      dict set ret $refclk2_str l [expr 3*$m_2]
      dict set ret $refclk2_str k [expr 4*$m_2]
      dict set ret $refclk2_str tank_sel "lctank1"
      dict set ret $refclk2_str tank_band "lc_band1"
   } else {
      dict set ret status bad
   }
   return $ret     
}
    
proc ::altera_xcvr_atx_pll_vi::parameters::legality_check_manual_mockup { temp } {
	
   # example dictionary structure:
   #      set ret { { status    good} \
   #                { config   { {out_freq 2520.0 MHz} {lf_resistance lf_setting0}... } } \
   #              }
	
   #   dict set ret status error

   set test_mode_lcl 1
   if { $test_mode_lcl==1 } {
              
      dict set ret status good
      
      set temp_reference_clock_frequency [ip_get "parameter.set_manual_reference_clock_frequency.value"]  
      set temp_set_m_counter             [ip_get "parameter.set_m_counter.value"]            
      set temp_set_ref_clk_div           [ip_get "parameter.set_ref_clk_div.value"]          
      set temp_set_l_counter             [ip_get "parameter.set_l_counter.value"]            
      set temp_set_k_counter             [ip_get "parameter.set_k_counter.value"]
      set temp_set_l_cascade_counter     [ip_get "parameter.set_l_cascade_counter.value"]
      
      set k_factor "1.$temp_set_k_counter" 
      
	  if { $temp_set_cascade_counter != 0 } {
	     set out_freq [expr (($k_factor)*($temp_reference_clock_frequency)*($temp_set_m_counter))/(($temp_set_ref_clk_div)*($temp_set_l_cascade_counter))]
	  } else {
      set out_freq [expr (($k_factor)*($temp_reference_clock_frequency)*($temp_set_m_counter))/(($temp_set_ref_clk_div)*($temp_set_l_counter))]
	  }
      
      dict set ret config out_freq "$out_freq MHz"
      dict set ret config tank_sel "lctank0"
      dict set ret config tank_band "lc_band0"
   } else {
      dict set ret status bad
   }
   return $ret     
} 

#convert units in mega (10^6) to base (10^0)
proc ::altera_xcvr_atx_pll_vi::parameters::mega_to_base { val } { 
  #replace anything not a number or DOT character (to account for doubles)
  regsub -nocase -all {\m(\D)} $val "" temp
  set temp [expr {wide(double($temp) * 1000000)}]
  return $temp
}

proc ::altera_xcvr_atx_pll_vi::parameters::convert_mhz_to_hz { PROP_NAME PROP_VALUE } {
  set temp [mega_to_base $PROP_VALUE]
  ip_set "parameter.${PROP_NAME}.value" "$temp Hz"
}

proc ::altera_xcvr_atx_pll_vi::parameters::convert_mbps_to_bps { PROP_NAME PROP_VALUE } {
  set temp [mega_to_base $PROP_VALUE]
  ip_set "parameter.${PROP_NAME}.value" "$temp bps"
}

proc ::altera_xcvr_atx_pll_vi::parameters::validate_enable_calibration { set_altera_xcvr_atx_pll_a10_calibration_en enable_advanced_options } {
  set value [expr { $enable_advanced_options ? $set_altera_xcvr_atx_pll_a10_calibration_en:1}]
  if { $value } {
    ip_set "parameter.calibration_en.value" "enable"
  } else {
    ip_set "parameter.calibration_en.value" "disable"
  }
}

proc ::altera_xcvr_atx_pll_vi::parameters::update_manual_config { PROP_NAME PROP_VALUE select_manual_config enable_fractional device_revision fb_select_fnl prot_mode_fnl mcgb_div_fnl dsm_mode fb_select_fnl atx_pll_pma_width prot_mode_fnl primary_use enable_atx_to_fpll_cascade_out} {
  # TODO Do these RBC calls return automatic counter ranges appropriate for fractional and integer modes ?
  if { $select_manual_config } {
      set n_counter_list [::altera_xcvr_atx_pll_vi::parameters::obtain_n_counter_values $device_revision $fb_select_fnl $prot_mode_fnl $primary_use]
      set l_counter_list [::altera_xcvr_atx_pll_vi::parameters::obtain_l_counter_values $device_revision $prot_mode_fnl]
      set l_cascade_counter_list [::altera_xcvr_atx_pll_vi::parameters::obtain_l_cascade_counter_values $device_revision $prot_mode_fnl]
      set temp_l_counter [lindex $l_counter_list 0 ]
      set m_counter_list [::altera_xcvr_atx_pll_vi::parameters::obtain_m_counter_values $device_revision $mcgb_div_fnl $dsm_mode $fb_select_fnl $temp_l_counter $atx_pll_pma_width $prot_mode_fnl $primary_use]
      ip_set "parameter.set_m_counter.ALLOWED_RANGES" $m_counter_list
      ip_set "parameter.set_ref_clk_div.ALLOWED_RANGES" $n_counter_list
      ip_set "parameter.set_l_counter.ALLOWED_RANGES" $l_counter_list
      ip_set "parameter.set_l_cascade_counter.ALLOWED_RANGES" $l_cascade_counter_list
      ip_set "parameter.enable_fractional.value" "1"
  }
  
}

proc ::altera_xcvr_atx_pll_vi::parameters::determine_if_cascade_path_legal { device_revision enable_atx_to_fpll_cascade_out } {
   set device_supports_cascade [::altera_xcvr_atx_pll_vi::parameters::does_this_device_support_cascade $device_revision ]
   if { $device_supports_cascade && $enable_atx_to_fpll_cascade_out } {
      return "true"
   } else {
      return "false"
   }
}

proc ::altera_xcvr_atx_pll_vi::parameters::does_this_device_support_cascade { device_revision } {
### ES and ES2 devices don't have cascade support, device_revision for ES is 20nmES and for ES2 20nm5ES2
#    puts "DEVICE=$device_revision\n"
    set es_device [regexp -nocase {^[a-zA-Z0-9]+ES} $device_revision']    
    if { $es_device} {
      return "false"
   } else {
      return "true"
   }
}



 proc ::altera_xcvr_atx_pll_vi::parameters::update_enable_atx_to_fpll_cascade_out { PROP_NAME PROP_VALUE device_revision enable_atx_to_fpll_cascade_out device prot_mode} {
    set device_supports_cascade [::altera_xcvr_atx_pll_vi::parameters::does_this_device_support_cascade $device_revision ]
     if { !$device_supports_cascade} {
	 auto_invalid_value_message error $PROP_NAME $PROP_VALUE 0 { device }
     }
     if { [string compare -nocase $prot_mode "OTN_cascade"] ==0  || [string compare -nocase $prot_mode "SDI_cascade"] ==0 } {
     	ip_message info "In OTN_cascade or SDI_cascade mode the pll_locked port is not available.  The user can create external lock detect using clklow and fref clock ports"
     } else {
        auto_invalid_value_message error $PROP_NAME $PROP_VALUE 0 { prot_mode }
     }
 }


proc ::altera_xcvr_atx_pll_vi::parameters::determine_primary_use { device_revision enable_atx_to_fpll_cascade_out primary_pll_buffer } {
   set allow_cascade_path [::altera_xcvr_atx_pll_vi::parameters::determine_if_cascade_path_legal $device_revision $enable_atx_to_fpll_cascade_out]
   if { $allow_cascade_path } {
      ip_set "parameter.primary_use.value" "hssi_cascade"
   } else {
      if { [string compare -nocase $primary_pll_buffer "GX clock output buffer"]==0 } {
         ip_set "parameter.primary_use.value" "hssi_x1"
      } else {
         ip_set "parameter.primary_use.value" "hssi_hf"
      }
   }
}

proc ::altera_xcvr_atx_pll_vi::parameters::obtain_n_counter_values { device_revision fb_select_fnl prot_mode_fnl primary_use } {
   return [lsort -integer -increasing [scrub_list_values [::nf_atx_pll::parameters::validate_atx_pll_n_counter_scratch 1 1 $device_revision $fb_select_fnl $primary_use $prot_mode_fnl]]]
}

proc ::altera_xcvr_atx_pll_vi::parameters::obtain_m_counter_values { device_revision mcgb_div_fnl dsm_mode fb_select_fnl temp_l_counter atx_pll_pma_width prot_mode_fnl primary_use} {
   return [lsort -integer -increasing [scrub_list_values [::nf_atx_pll::parameters::validate_atx_pll_m_counter 1 1 $device_revision $mcgb_div_fnl $dsm_mode $fb_select_fnl $temp_l_counter $atx_pll_pma_width $primary_use $prot_mode_fnl]]]
}

proc ::altera_xcvr_atx_pll_vi::parameters::obtain_l_counter_values { device_revision prot_mode_fnl } {
   return [lsort -integer -increasing [scrub_list_values [::nf_atx_pll::parameters::validate_atx_pll_l_counter_scratch 1 1 $device_revision $prot_mode_fnl]]]
}

proc ::altera_xcvr_atx_pll_vi::parameters::obtain_l_cascade_counter_values { device_revision prot_mode_fnl } {
      return [lsort -integer -increasing [scrub_list_values [::nf_atx_pll::parameters::validate_atx_pll_lc_to_fpll_l_counter_scratch 1 1 $device_revision "hssi_cascade" $prot_mode_fnl "user_mode"]]]
}

### Max K value supported is < 2^32 so validate that for manual mode
 proc ::altera_xcvr_atx_pll_vi::parameters::validate_k_counter { enable_fractional select_manual_config set_k_counter } {
     ## for 2^32 expression following can be used [expr 2**32-1] But it desn't work with some of the TCL interpreters so hardcoding 2^32 value
     set max_k_counter "4294967295"
     if { $enable_fractional} {
	 if {$select_manual_config} {
	     if {$set_k_counter > $max_k_counter} {
		 ip_message error "k counter is $set_k_counter, legal range is 0:$max_k_counter"
	     }
	 }
     }
 }

##################################################################################################################################################
# Following Functions are added to support GUI parameter l_cascade_predivider.
# l_cascade_predivider is the GUI parameter added for MUX selection between "select_vco_output" and "select_div_by_2", mux selection is based
# on the attribute "atx_pll_fpll_erfclk_selection"
# 
################################################################################################################################################## 

proc ::altera_xcvr_atx_pll_vi::parameters::validate_atx_pll_fpll_refclk_selection { set_l_cascade_predivider } {
   if {$set_l_cascade_predivider == 1} {
      set val "select_vco_output"
   } else {
      set val "select_div_by_2"
   }
   ip_set "parameter.atx_pll_fpll_refclk_selection.value" $val
}

###
proc ::altera_xcvr_atx_pll_vi::parameters::manual_value_out_of_range_message { message_level param_name param_value param_legal_values } {
    # See if the value is within the specified range
    foreach range $param_legal_values {
 	set min_max [split $range ":"]
 	set min [lindex $min_max 0]
 	set max $min
 	if {[llength $min_max] == 2} {
 	    set max [lindex $min_max 1]
 	}
 	if {$param_value <= $max && $param_value >= $min} {
 	    # The value is legal. Return
 	    return
 	} else {
 	    ip_message $message_level "$param_name is $param_value, legal range is $param_legal_values"
	    
 	}
	
     }
}

proc ::altera_xcvr_atx_pll_vi::parameters::validate_enable_sdi_rule_checks { prot_mode enable_atx_to_fpll_cascade_out} {
    if { $enable_atx_to_fpll_cascade_out } {
	if { [string compare -nocase $prot_mode "SDI_cascade"]==0 } {
	    ip_set "parameter.atx_pll_is_sdi.value" "true"	    
	} else {
	    ip_set "parameter.atx_pll_is_sdi.value" "false"
	}
    } else {
	ip_set "parameter.atx_pll_is_sdi.value" "false"
    }
}   

proc ::altera_xcvr_atx_pll_vi::parameters::validate_enable_otn_rule_checks { prot_mode enable_atx_to_fpll_cascade_out} {
    if { $enable_atx_to_fpll_cascade_out } {
	if { [string compare -nocase $prot_mode "OTN_cascade"] == 0 } {
	    ip_set "parameter.atx_pll_is_otn.value" "true"  
	} else {
	    ip_set "parameter.atx_pll_is_otn.value" "false"
	}
    } else {   
	ip_set "parameter.atx_pll_is_otn.value" "false"
    }
}   


