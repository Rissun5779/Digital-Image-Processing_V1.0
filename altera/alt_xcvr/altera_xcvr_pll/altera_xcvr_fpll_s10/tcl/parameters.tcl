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


## \file parameters.tcl
# lists all the parameters used in ND FPLL IP GUI & HDL WRAPPER, as well as associated validation callbacks

package provide altera_xcvr_fpll_s10::parameters 18.1

package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::gui::messages
package require alt_xcvr::utils::device
package require alt_xcvr::utils::common
package require altera_xcvr_cmu_fpll_s10::pll_calculations
package require mcgb_package_s10::mcgb
package require alt_xcvr::utils::reconfiguration_stratix10
package require ct1_cmu_fpll::parameters 

# Create FPLL parameter list
namespace eval ::altera_xcvr_fpll_s10::parameters:: {
  namespace import ::alt_xcvr::ip_tcl::ip_module::*
  namespace import ::alt_xcvr::ip_tcl::messages::*
  namespace import ::altera_xcvr_cmu_fpll_s10::pll_calculations::* 

  namespace export \
    declare_parameters \
    validate \

  variable package_name
  variable display_items_pll
  variable generation_display_items
  variable parameters
  variable atom_parameters
  variable atom_parameters_default
  variable atom_parameters_warnings_off
  variable logical_parameters
  variable static_hdl_parameters
  set package_name "ct1_cmu_fpll::parameters"
  
  set display_items_pll {\
     {NAME                         GROUP                      ENABLED             VISIBLE                TYPE   ARGS  }\
     {"PLL"                        ""                         NOVAL               NOVAL                  GROUP  tab   }\
     {"General"                    "PLL"                      NOVAL               NOVAL                  GROUP  noval }\
     {"Common PMA Options"         "PLL"                      NOVAL               NOVAL                  GROUP  noval }\
     {"Phase aligned core outputs" "PLL"                      NOVAL               "set_primary_use == 0" GROUP  noval }\
     {"Ports"                      "PLL"                      NOVAL               NOVAL                  GROUP  noval }\
     {"Output Frequency"           "PLL"                      NOVAL               NOVAL                  GROUP  noval }\
     {display_power_mode_msg       "General"                  NOVAL               "set_primary_use != 0" TEXT   {"Not validated"} }\

  }

  set generation_display_items {\
     {NAME                         GROUP                      ENABLED             VISIBLE   TYPE   ARGS  }\
     {"Generation Options"         ""                         NOVAL               false     GROUP  tab   }\
  }

    set set_parameters {\
        {NAME                                       M_CONTEXT  M_USED_FOR_RCFG  M_SAME_FOR_RCFG  VALIDATION_CALLBACK                                                            DERIVED HDL_PARAMETER   TYPE        DEFAULT_VALUE                   ALLOWED_RANGES                                              ENABLED                    VISIBLE                                                      DISPLAY_HINT    DISPLAY_UNITS   DISPLAY_ITEM                        DISPLAY_NAME                                                DESCRIPTION }\
        {enable_advanced_options                    NOVAL      0                0                NOVAL                                                                          true    false           INTEGER     0                               { 0 1 }                                                     true                       false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {enable_hip_options                         NOVAL      0                0                NOVAL                                                                          true    false           INTEGER     0                               { 0 1 }                                                     true                       false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {enable_manual_configuration                NOVAL      0                0                NOVAL                                                                          false   false           INTEGER     1                               { 0 1 }                                                     true                       false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {enable_debug_options                       NOVAL      0                0                NOVAL                                                                          true    false           INTEGER     0                               { 0 1 }                                                     true                       false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {generate_docs                              NOVAL      0                0                NOVAL                                                                          false   false           INTEGER     1                               NOVAL                                                       true                       true                                                         BOOLEAN         NOVAL           "Generation Options"                "Generate parameter documentation file"                     "When enabled, generation will produce a .CSV file with descriptions of the IP parameters."}\
        {generate_add_hdl_instance_example          NOVAL      0                0                NOVAL                                                                          false   false           INTEGER     0                               NOVAL                                                       enable_advanced_options    enable_advanced_options                                      BOOLEAN         NOVAL           "Generation Options"                "Generate '_hw.tcl' 'add_hdl_instance' example file"        "When enabled, generation will produce a file containing an example of how to use the '_hw.tcl' 'add_hdl_instance' API. The example will be correct for the current configuration of the IP."}\
        {device_family                              NOVAL      0                0                NOVAL                                                                          false   false           STRING      "Stratix 10"                    NOVAL                                                       true                       false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {device                                     NOVAL      0                0                NOVAL                                                                          false   false           STRING      "Unknown"                       NOVAL                                                       true                       false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {base_device                                NOVAL      0                0                NOVAL                                                                          false   false           STRING      "Unknown"                       NOVAL                                                       true                       false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {set_x1_core_clock                          NOVAL      0                0                NOVAL                                                                          false   false           BOOLEAN     true                            NOVAL                                                       false                      "set_primary_use == 0"                                       NOVAL           NOVAL           "Phase aligned core outputs"        "Enable /1 output clock"                                    "The divide by 1 clock output is always enabled in core mode"} \
        {set_x2_core_clock                          NOVAL      0                0                NOVAL                                                                          false   false           BOOLEAN     false                           NOVAL                                                       true                       "set_primary_use == 0"                                       NOVAL           NOVAL           "Phase aligned core outputs"        "Enable /2 output clock"                                    "Enable the divide by 2 clock in core mode."} \
        {set_x4_core_clock                          NOVAL      0                0                NOVAL                                                                          false   false           BOOLEAN     false                           NOVAL                                                       true                       "set_primary_use == 0"                                       NOVAL           NOVAL           "Phase aligned core outputs"        "Enable /4 output clock"                                    "Enable the divide by 4 clock in core mode."} \
        {enable_clk_divider                         NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::update_enable_clk_divider                  true    true            INTEGER     0                               { 0 1 }                                                     true                       false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL }\
        {set_primary_use                            NOVAL      0                0                NOVAL                                                                          false   false           STRING      2                               {"0:Core" "1:Cascade Source" "2:Transceiver"}               true                       true                                                         NOVAL           NOVAL           "General"                           "FPLL Mode"                                                 "Selects the primary operation mode of the FPLL (Core/Transceiver/Cascade source."} \
        \
        {test_mode                                  NOVAL      0                0                NOVAL                                                                          false   true            STRING     "false"                          { "false" "true"}                                           enable_advanced_options    enable_advanced_options                                      BOOLEAN         NOVAL           "General"                           "Enable Test Mode"                                          "Selects the test mode option to bypass VCO primarily."}\
        \
        {enable_pld_fpll_cal_busy_port              NOVAL      1                1                NOVAL                                                                          false   false           INTEGER     1                               { 0 1 }                                                     false                      false                                                        BOOLEAN         NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {usr_enable_vco_bypass                      NOVAL      0                0                NOVAL                                                                          false   false           BOOLEAN     false                           NOVAL                                                       enable_advanced_options    enable_advanced_options                                      NOVAL           NOVAL           "General"                           "Enable FPLL VCO Bypass"                                              "Selects the support mode (user or engineering). Engineering mode options are not officially supported by Altera or Quartus Prime."}\
        \
        {enable_debug_ports_parameters              NOVAL      0                0                NOVAL                                                                          false   false           INTEGER     0                               NOVAL                                                       enable_advanced_options    enable_advanced_options                                      BOOLEAN         NOVAL           "General"                           "Enable debug ports && parameters"                          NOVAL}\
        {support_mode                               NOVAL      1                0                ::altera_xcvr_fpll_s10::parameters::validate_support_mode                      false   false           STRING      "user_mode"                     {"user_mode" "engineering_mode"}                            enable_advanced_options    enable_advanced_options                                      NOVAL           NOVAL           "General"                           "Support mode"                                              "Selects the support mode (user or engineering). Engineering mode options are not officially supported by Altera or Quartus Prime."}\
        {message_level                              NOVAL      0                0                NOVAL                                                                          false   false           STRING      "error"                         {error warning}                                             true                       true                                                         NOVAL           NOVAL           "General"                           "Message level for rule violations"                         "Specifies the messaging level to use for parameter rule violations. Selecting \"error\" will cause all rule violations to prevent IP generation. Selecting \"warning\" will display all rule violations as warnings and will allow IP generation in spite of violations."}\
        {pma_speedgrade                             NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::validate_pma_speedgrade                    true    false           STRING      "e2"                            NOVAL                                                       true                       false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {device_revision                            NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::validate_device_revision                   true    false           STRING      "14nm5"                         {"14nm5"}                                                   true                       false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {set_prot_mode                              NOVAL      1                0                NOVAL                                                                          false   false           STRING      0                               {"0:Basic" "1:PCIe G1" "2:PCIe G2" "3:PCIe G3"}             true                       "set_primary_use == 2"                                       NOVAL           NOVAL           "General"                           "Protocol mode"                                             "The parameter is used to govern the rules for internal settings of the VCO. This parameter is not a \"preset\". You must still correctly set all other parameters for your protocol and application."}\
        {prot_mode_fnl                              NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::convert_prot_mode                          true    false           STRING      "basic_tx"                      NOVAL                                                       true                       false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {set_bw_sel                                 NOVAL      1                0                NOVAL                                                                          false   false           STRING      "medium"                        {"low" "medium" "high"}                                     true                       true                                                         NOVAL           NOVAL           "General"                           "Bandwidth"                                                 "Specifies the VCO bandwidth."}\
        {set_refclk_cnt                             NOVAL      1                1                ::altera_xcvr_fpll_s10::parameters::update_set_refclk_cnt                      false   false           INTEGER     1                               { 1 2 3 4 5 }                                               true                       "set_primary_use != 1"                                       NOVAL           NOVAL           "General"                           "Number of PLL reference clocks"                            "Specifies the number of input reference clocks for the FPLL."}\
        {set_refclk_index                           NOVAL      1                0                ::altera_xcvr_fpll_s10::parameters::update_refclk_index                        false   false           INTEGER     0                               NOVAL                                                       true                       "set_primary_use != 1"                                       NOVAL           NOVAL           "General"                           "Selected reference clock source"                           "Specifies the initially selected reference clock input to the FPLL."}\
        {silicon_rev                                NOVAL      0                0                NOVAL                                                                          false   false           BOOLEAN     false                           NOVAL                                                       true                       false                                                        NOVAL           NOVAL           "General"                           "Silicon revision ES"                                       NOVAL}\
        \
        {set_fb_select                              NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::convert_fb_select                          true    false           STRING      "normal"                        { "normal:direct" "iqtxrxclk:Feedback Compensation" }       true                       false                                                        NOVAL           NOVAL           "Feedback"                          "Operation mode"                                            "Specifies the operation mode for FPLL."} \
        {compensation_mode_derived                  NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::update_compensation_mode                   true    false           STRING      "direct"                        { "direct" "fpll_bonding"}                                  true                       false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {set_enable_hclk_out                        NOVAL      1                1                NOVAL                                                                          false   false           INTEGER     0                               NOVAL                                                       true                       "set_primary_use == 2 && set_prot_mode != 0"                 BOOLEAN         NOVAL           "Ports"                             "Enable PCIe clock output port"                             "This is the 1 GHz fixed PCIe clock output port and is intended for PIPE mode. The port should be connected to \"pipe hclk input port\"."}\
        {enable_hip_cal_done_port                   NOVAL      1                1                NOVAL                                                                          false   false           INTEGER     0                               NOVAL                                                       enable_hip_options         enable_hip_options                                           BOOLEAN         NOVAL           "Ports"                             "Enable calibration status ports for HIP"                   "Enables calibration status port from PLL and Master CGB(if enabled) for HIP"}\
        {enable_mcgb_hip_cal_done_port              NOVAL      1                1                NOVAL                                                                          false   false           INTEGER     0                               NOVAL                                                       enable_hip_options         enable_hip_options                                           BOOLEAN         NOVAL           "Ports"                             "Enable MCGB calibration status ports for HIP"              "Enables calibration status port from PLL and Master CGB(if enabled) for HIP"}\
        {set_hip_cal_en                             NOVAL      1                0                NOVAL                                                                          false   false           INTEGER     0                               NOVAL                                                       enable_hip_options         enable_hip_options                                           BOOLEAN         NOVAL           "Ports"                             "Enable PCIe hard IP calibration"                           "INTERNAL USE ONLY. Enabling this parameter prioritizes the calibration for PCIe hard IP channels."}\
        {hip_cal_en                                 NOVAL      0                0                NOVAL                                                                          true    true            STRING      "disable"                       { "enable" "disable" }                                      enable_hip_options         false                                                        NOVAL           NOVAL           "Ports"                             NOVAL                                                       "INTERNAL USE ONLY. Enabling this parameter prioritizes the calibration for PCIe hard IP channels."}\
        \
        {set_output_clock_frequency                 NOVAL      1                0                ::altera_xcvr_fpll_s10::parameters::validate_set_output_clock_frequency        false   false           FLOAT       2500.0                          NOVAL                                                       true                       "!select_manual_config"                                      NOVAL           MHz             "Output Frequency"                  "PLL output frequency"                                      "Specifies the target output frequency for the PLL."}\
        {output_datarate                            advanced   1                0                ::altera_xcvr_fpll_s10::parameters::update_output_datarate                     true    false           FLOAT       5000.0                          NOVAL                                                       true                       true                                                         NOVAL           Mbps            "Output Frequency"                  "PLL output datarate"                                       "Specifies the target datarate for which the PLL will be used."}\
        {output_clock_frequency                     advanced   0                0                ::altera_xcvr_fpll_s10::parameters::update_output_clock_frequency              true    false           FLOAT       2500.0                          NOVAL                                                       true                       false                                                        NOVAL           MHz             "Output Frequency"                  "PLL output frequency"                                      "Specifies the target output frequency for the PLL."}\
        {set_manual_output_clock_frequency          NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::validate_set_output_clock_frequency        false   false           FLOAT       2500.0                          NOVAL                                                       true                       "select_manual_config"                                       NOVAL           MHz             "Output Frequency"                  "PLL output frequency"                                      "Specifies the target output frequency for the PLL in manual mode."}\
        {vco_freq_derived                           advanced   0                0                ::altera_xcvr_fpll_s10::parameters::update_vco_freq                            true    false           FLOAT       1250.0                          NOVAL                                                       true                       false                                                        NOVAL           MHz             NOVAL                               "VCO frequency"                                             NOVAL}\
        {pfd_freq_derived                           advanced   0                0                ::altera_xcvr_fpll_s10::parameters::update_pfd_freq                            true    false           FLOAT       1250.0                          NOVAL                                                       true                       false                                                        NOVAL           MHz             NOVAL                               "PFD frequency"                                             NOVAL}\
        \
        {set_enable_fractional                      NOVAL      0                0                NOVAL                                                                          false   false           INTEGER     0                               NOVAL                                                       true                       true                                                         BOOLEAN         NOVAL           "General"                           "Enable fractional mode"                                    "Enables the fractional frequency synthesis mode. This enables the PLL to output frequencies which are not integral multiples of the input reference clock."} \
        {set_atx_fpll_cascade_option                NOVAL      0                0                NOVAL                                                                          false   false           INTEGER     0                               NOVAL                                                       true                       "set_primary_use == 2"                                       BOOLEAN         NOVAL           "General"                           "Enable ATX to fPLL cascade clock input port"               "Enables fPLL to listen to ATX PLL cascade source"}\
        {set_auto_reference_clock_frequency         NOVAL      1                0                ::altera_xcvr_fpll_s10::parameters::update_refclk_auto                         false   false           FLOAT       100.000000                      NOVAL                                                       true                       "!select_manual_config && !set_enable_fractional"            NOVAL           MHz             "Output Frequency"                  "PLL integer reference clock frequency"                     "Selects the input reference clock frequency for the PLL."}\
        {set_manual_reference_clock_frequency       NOVAL      1                0                NOVAL                                                                          false   false           FLOAT       100.000000                      NOVAL                                                       true                       "select_manual_config"                                       NOVAL           MHz             "Output Frequency"                  "PLL reference clock frequency"                             "Specify the PLL reference clock frequency."}\
        {reference_clock_frequency_fnl              NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::update_reflk_freq                          true    false           FLOAT       100.000000                      NOVAL                                                       true                       false                                                        NOVAL           MHz             NOVAL                               NOVAL                                                       NOVAL}\
        {set_fref_clock_frequency                   NOVAL      1                0                NOVAL                                                                          false   false           FLOAT       100.000000                      NOVAL                                                       true                       "set_enable_fractional && !select_manual_config"             NOVAL           MHz             "Output Frequency"                  "PLL fractional reference clock frequency"                  "Selects the fractional reference clock frequency for the PLL."}\
        {set_initial_phase_shift_units              NOVAL      1                0                NOVAL                                                                          false   false           STRING      "degrees"                       {"ps" "degrees"}                                            true                       "set_primary_use == 0"                                       NOVAL           NOVAL           "Output Frequency"                  "PLL phase shift units"                                     "Specifies the initial phase shift units."}\
        {set_initial_phase_shift                    NOVAL      1                0                ::altera_xcvr_fpll_s10::parameters::update_phase_shift                         false   false           FLOAT       0.000000                        NOVAL                                                       true                       "set_primary_use == 0"                                       NOVAL           ps/degrees      "Output Frequency"                  "PLL initial phase shift"                                   "Specifies the initial phase shift w.r.t the output clock frequency."}\
        \
        {set_enable_dps                             NOVAL      0                0                NOVAL                                                                          false   false           INTEGER     0                               NOVAL                                                       true                       false                                                        BOOLEAN         NOVAL           "General"                           "Enable dynamic phase shift"                                "Enables dynamic phase shift via core ports."}\
        \
        {pll_c0                                     NOVAL      0                0                NOVAL                                                                          true    false           INTEGER     1                               NOVAL                                                       false                      false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {pll_c1                                     NOVAL      0                0                NOVAL                                                                          true    false           INTEGER     1                               NOVAL                                                       false                      false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {pll_c2                                     NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::update_core_counters                       true    false           INTEGER     1                               NOVAL                                                       false                      false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {pll_c3                                     NOVAL      0                0                NOVAL                                                                          true    false           INTEGER     1                               NOVAL                                                       false                      false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {pll_c0_enable                              NOVAL      0                0                NOVAL                                                                          true    false           STRING      "pllcout_disable"               { "pllcout_disable" "pllcout_enable" }                      false                      false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {pll_c1_enable                              NOVAL      0                0                NOVAL                                                                          true    false           STRING      "pllcout_disable"               { "pllcout_disable" "pllcout_enable" }                      false                      false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {pll_c2_enable                              NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::update_core_counters                       true    false           STRING      "pllcout_disable"               { "pllcout_disable" "pllcout_enable" }                      false                      false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {pll_c3_enable                              NOVAL      0                0                NOVAL                                                                          true    false           STRING      "pllcout_disable"               { "pllcout_disable" "pllcout_enable" }                      false                      false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {pll_c0_ph_mux_prst                         NOVAL      0                0                NOVAL                                                                          true    false           INTEGER     0                               NOVAL                                                       false                      false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {pll_c1_ph_mux_prst                         NOVAL      0                0                NOVAL                                                                          true    false           INTEGER     0                               NOVAL                                                       false                      false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {pll_c2_ph_mux_prst                         advanced   0                0                ::altera_xcvr_fpll_s10::parameters::update_phase_shift                         true    false           INTEGER     1                               NOVAL                                                       false                      false                                                        NOVAL           NOVAL           "Output Frequency"                  "Phase shift(incr of 90 deg)"                               "Phase shift in increments of 90 deg"}\
        {pll_c3_ph_mux_prst                         NOVAL      0                0                NOVAL                                                                          true    false           INTEGER     0                               NOVAL                                                       false                      false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {pll_c0_prst                                NOVAL      0                0                NOVAL                                                                          true    false           INTEGER     1                               NOVAL                                                       false                      false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {pll_c1_prst                                NOVAL      0                0                NOVAL                                                                          true    false           INTEGER     0                               NOVAL                                                       false                      false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {pll_c2_prst                                advanced   0                0                ::altera_xcvr_fpll_s10::parameters::update_phase_shift                         true    false           INTEGER     1                               NOVAL                                                       false                      false                                                        NOVAL           NOVAL           "Output Frequency"                  "Phase shift preset counter"                                "Phase shift preset counter"}\
        {pll_c3_prst                                NOVAL      0                0                NOVAL                                                                          true    false           INTEGER     0                               NOVAL                                                       false                      false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {core_phase_shift_0                         NOVAL      0                0                NOVAL                                                                          true    false           FLOAT       0.0                             NOVAL                                                       true                       false                                                        NOVAL           ps              "Output Frequency"                  "Actual phase shift C0"                                     "Specifies actual value for phase shift of C0"}\
        {core_phase_shift_1                         NOVAL      0                0                NOVAL                                                                          true    false           FLOAT       0.0                             NOVAL                                                       true                       false                                                        NOVAL           ps              "Output Frequency"                  "Actual phase shift C1"                                     "Specifies actual value for phase shift of C1"}\
        {core_phase_shift_2                         advanced   0                0                ::altera_xcvr_fpll_s10::parameters::update_phase_shift                         true    false           FLOAT       0.0                             NOVAL                                                       true                       "set_primary_use == 0"                                       NOVAL           ps              "Output Frequency"                  "Actual phase shift"                                        "Specifies actual value for phase shift"}\
        {core_phase_shift_3                         NOVAL      0                0                NOVAL                                                                          true    false           FLOAT       0.0                             NOVAL                                                       true                       false                                                        NOVAL           ps              "Output Frequency"                  "Actual phase shift C3"                                     "Specifies actual value for phase shift of C3"}\
        {f_out_c0                                   advanced   0                0                ::altera_xcvr_fpll_s10::parameters::update_c0_counter_frequency                true    false           STRING      "0"                             NOVAL                                                       true                       false                                                        NOVAL           ps              "C Counter Output Frequency"        "C Counter Output Frequency"                                "Specifies actual value for output frequency of C counter"}\
        {f_out_c0_hz                                advanced   0                0                ::altera_xcvr_fpll_s10::parameters::update_c0_counter_frequency_in_hz          true    false           STRING      "0"                             NOVAL                                                       true                       false                                                        NOVAL           ps              "C Counter Output Frequency in Hz"  "C Counter Output Frequency in Hz"                          "Specifies actual value for output frequency of C counter in Hz"}\
        {f_out_c1                                   advanced   0                0                ::altera_xcvr_fpll_s10::parameters::update_c1_counter_frequency                true    false           STRING      "0"                             NOVAL                                                       true                       false                                                        NOVAL           ps              "C Counter Output Frequency"        "C Counter Output Frequency"                                "Specifies actual value for output frequency of C counter"}\
        {f_out_c1_hz                                advanced   0                0                ::altera_xcvr_fpll_s10::parameters::update_c1_counter_frequency_in_hz          true    false           STRING      "0"                             NOVAL                                                       true                       false                                                        NOVAL           ps              "C Counter Output Frequency in Hz"  "C Counter Output Frequency in Hz"                          "Specifies actual value for output frequency of C counter in Hz"}\
        {f_out_c2                                   advanced   0                0                ::altera_xcvr_fpll_s10::parameters::update_c2_counter_frequency                true    false           STRING      "0"                             NOVAL                                                       true                       false                                                        NOVAL           ps              "C Counter Output Frequency"        "C Counter Output Frequency"                                "Specifies actual value for output frequency of C counter"}\
        {f_out_c2_hz                                advanced   0                0                ::altera_xcvr_fpll_s10::parameters::update_c2_counter_frequency_in_hz          true    false           STRING      "0"                             NOVAL                                                       true                       false                                                        NOVAL           ps              "C Counter Output Frequency in Hz"  "C Counter Output Frequency in Hz"                          "Specifies actual value for output frequency of C counter in Hz"}\
        {set_coarse_dly                             NOVAL      0                0                NOVAL                                                                          true    false           STRING      "pll_coarse_dly_setting0"       NOVAL                                                       false                      false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {set_fine_dly                               NOVAL      0                0                NOVAL                                                                          true    false           STRING      "pll_fine_dly_setting0"         NOVAL                                                       false                      false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {set_ref_buf_dly                            NOVAL      0                0                NOVAL                                                                          true    false           STRING      "pll_ref_buf_dly_setting0"      NOVAL                                                       false                      false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        \
        {enable_fb_comp_bonding_fnl                 NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::convert_fb_comp_bonding                    true    false           INTEGER     0                               {0 1}                                                       true                       false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {set_dsm_mode                               NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::update_dsm_mode                            true    false           STRING      "dsm_mode_integer"              NOVAL                                                       true                       false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL} \
        {feedback_clock_frequency_fnl               NOVAL      0                0                NOVAL                                                                          true    false           FLOAT       156.250000                      NOVAL                                                       true                       false                                                        NOVAL           MHz             "Output Frequency"                  "External feedback frequency"                               "In feedback compensation bonding mode. The feedback frequency is determined based on \"Master CGB division factor\", \"Master CGB pma width\" and \"PLL output frequency\""}\
        {select_manual_config                       NOVAL      1                0                ::altera_xcvr_fpll_s10::parameters::update_manual_config                       false   false           BOOLEAN     false                           NOVAL                                                       true                       true                                                         BOOLEAN         NOVAL           "Output Frequency"                  "Configure counters manually"                               "Enables manual control of PLL counters."}\
        {set_m_counter                              NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::update_m_counter                           true    false           INTEGER     NOVAL                           NOVAL                                                       true                       "!select_manual_config"                                      NOVAL           NOVAL           "Output Frequency"                  "Multiply factor (M-Counter)"                               "M counter value"}\
        {set_manual_m_counter                       NOVAL      1                0                NOVAL                                                                          false   false           INTEGER     50                              ::altera_xcvr_fpll_s10::parameters::update_manual_config    true                       "select_manual_config"                                       NOVAL           NOVAL           "Output Frequency"                  "Multiply factor (M-Counter)"                               "M counter value in manual mode"}\
        {set_ref_clk_div                            NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::update_n_counter                           true    false           INTEGER     NOVAL                           NOVAL                                                       true                       "!select_manual_config"                                      NOVAL           NOVAL           "Output Frequency"                  "Divide factor (N-Counter)"                                 "N counter value"}\
        {set_manual_ref_clk_div                     NOVAL      1                0                NOVAL                                                                          false   false           INTEGER     1                               ::altera_xcvr_fpll_s10::parameters::update_manual_config    true                       "select_manual_config"                                       NOVAL           NOVAL           "Output Frequency"                  "Divide factor (N-Counter)"                                 "N counter value in manual mode"}\
        {set_l_counter                              NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::update_l_counter                           true    false           INTEGER     1                               NOVAL                                                       true                       "set_primary_use == 2 && !select_manual_config"              NOVAL           NOVAL           "Output Frequency"                  "Divide factor (L-Counter)"                                 "L counter value"}\
        {set_manual_l_counter                       NOVAL      1                0                NOVAL                                                                          false   false           INTEGER     2                               ::altera_xcvr_fpll_s10::parameters::update_manual_config    true                       "set_primary_use == 2 && select_manual_config"               NOVAL           NOVAL           "Output Frequency"                  "Divide factor (L-Counter)"                                 "L counter value in manual mode"}\
        {set_c_counter                              NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::update_c_counter                           true    false           INTEGER     NOVAL                           NOVAL                                                       true                       "set_primary_use != 2 && !select_manual_config"              NOVAL           NOVAL           "Output Frequency"                  "Divide factor (C-Counter)"                                 "C counter value"}\
        {set_manual_c_counter                       NOVAL      1                0                NOVAL                                                                          false   false           INTEGER     4                               ::altera_xcvr_fpll_s10::parameters::update_manual_config    true                       "set_primary_use != 2 && select_manual_config"               NOVAL           NOVAL           "Output Frequency"                  "Divide factor (C-Counter)"                                 "C counter value in manual mode"}\
        {set_k_counter                              NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::update_k_counter                           true    false           LONG        NOVAL                           NOVAL                                                       true                       "set_enable_fractional&&!select_manual_config"               NOVAL           NOVAL           "Output Frequency"                  "Fractional multiply factor (K)"                            "K counter value"}\
        {set_manual_k_counter                       NOVAL      1                0                NOVAL                                                                          false   false           LONG        1                               NOVAL                                                       true                       "set_enable_fractional&&select_manual_config"                NOVAL           NOVAL           "Output Frequency"                  "Fractional multiply factor (K)"                            "K counter value in manual mode"}\
        \
        {auto_list                                  NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::calculate_pll_auto                         true    false           STRING      NOVAL                           NOVAL                                                       true                       false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {manual_list                                NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::calculate_pll_manual                       true    false           STRING      NOVAL                           NOVAL                                                       true                       false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {pll_setting                                NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::update_pll_setting                         true    false           STRING      NOVAL                           NOVAL                                                       true                       false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        \
        {iqclk_mux_sel                              NOVAL      0                0                NOVAL                                                                          true    false           STRING      "iqtxrxclk0"                    NOVAL                                                       true                       false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {set_altera_xcvr_fpll_s10_calibration_en    NOVAL      0                0                NOVAL                                                                          false   false           INTEGER     1                               NOVAL                                                       enable_advanced_options    enable_advanced_options                                      BOOLEAN         NOVAL           "General"                           "Enable calibration"                                        "Enable transceiver calibration algorithms."}\
        {calibration_en                             NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::validate_enable_calibration                true    true            STRING      "enable"                        { "enable" "disable" }                                      enable_advanced_options    false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        \
        {outclk_en                                  NOVAL      0                0                NOVAL                                                                          false   false           BOOLEAN     false                           NOVAL                                                       true                       false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       NOVAL}\
        {enable_pcie_hip_connectivity               NOVAL      0              	0           	 NOVAL                                                                       	false  	true         	INTEGER	    0                          	    {0 1}                                                       true                       false                                                        NOVAL       	NOVAL        	NOVAL                       	    NOVAL                                                       NOVAL}\
        {set_power_mode                             NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::update_vccrt_range                         false   false           STRING      "1_0V"                          NOVAL                                                       true                       true                                                         NOVAL           NOVAL           "General"                           "VCCR_GXB and VCCT_GXB supply voltage for the Transceiver:" "Sets the voltage compatibility with the associated Native Phy IP"} \
        {enable_analog_resets                       NOVAL      0                0                NOVAL                                                                          false   false           BOOLEAN     false                           NOVAL                                                       enable_advanced_options    enable_advanced_options                                      NOVAL           NOVAL           "General"                           "Enable pll_powerdown and mcgb_rst ports"                   "Enable pll_powerdown port"}\
        {in_pcie_hip_mode                           NOVAL      0                0                ::altera_xcvr_fpll_s10::parameters::update_in_pcie_hip_mode                    true    false           BOOLEAN     false                           NOVAL                                                       true                       false                                                        NOVAL           NOVAL           NOVAL                               NOVAL                                                       "indicates prot_mode is PCIe"}\
        \
   }

    set atom_parameters {\
        {NAME                                                                       M_CONTEXT M_AUTOSET  DISPLAY_NAME   DERIVED  HDL_PARAMETER   M_MAPS_FROM                             M_MAP_VALUES                                                                                                                                                       VALIDATION_CALLBACK                                                            }\
        {cmu_fpll_silicon_rev                                                       NOVAL     false      NOVAL           true     true           device_revision                         NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_feedback                                                          NOVAL     false      NOVAL           true     true           set_fb_select                           NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_iqfb_mux_iqclk_sel                                                NOVAL     false      NOVAL           true     true           iqclk_mux_sel                           NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_enable_hclk                                                       NOVAL     false      NOVAL           true     true           set_enable_hclk_out                     {"0:false" "1:true"}                                                                                                                                               NOVAL                                                                         }\
        {cmu_fpll_hclk_out_enable                                                   NOVAL     false      NOVAL           true     true           set_enable_hclk_out                     {"0:fpll_hclk_out_disable" "1:fpll_hclk_out_enable"}                                                                                                               ::ct1_cmu_fpll::parameters::validate_cmu_fpll_hclk_out_enable                 }\
        {cmu_fpll_iqtxrxclk_out_enable                                              NOVAL     false      NOVAL           true     true           set_primary_use                         {"0:fpll_iqtxrxclk_out_disable" "1:fpll_iqtxrxclk_out_enable" "2:fpll_iqtxrxclk_out_disable"}                                                                      ::ct1_cmu_fpll::parameters::validate_cmu_fpll_iqtxrxclk_out_enable            }\
        {cmu_fpll_cas_out_enable                                                    NOVAL     false      NOVAL           true     true           set_primary_use                         {"0:fpll_cas_out_disable" "1:fpll_cas_out_disable" "2:fpll_cas_out_disable"}                                                                                       ::ct1_cmu_fpll::parameters::validate_cmu_fpll_cas_out_enable                  }\
        {cmu_fpll_pll_l_counter                                                     NOVAL     false      NOVAL           true     true           set_l_counter                           NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_l_counter                                                         advanced  false      "L-Counter"     true     true           set_l_counter                           NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_m_counter                                                         advanced  false      "M-Counter"     true     true           set_m_counter                           NOVAL                                                                                                                                                              ::ct1_cmu_fpll::parameters::validate_cmu_fpll_m_counter                       }\
        {cmu_fpll_mcnt_cnt_div                                                      NOVAL     false      NOVAL           true     true           set_m_counter                           NOVAL                                                                                                                                                              ::ct1_cmu_fpll::parameters::validate_cmu_fpll_m_counter                       }\
        {cmu_fpll_n_counter                                                         advanced  false      "N-Counter"     true     true           set_ref_clk_div                         NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_ncnt_ncnt_divide                                                  NOVAL     false      NOVAL           true     true           set_ref_clk_div                         NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_ncnt_coarse_dly                                                   NOVAL     false      NOVAL           true     true           set_coarse_dly                          NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_ncnt_fine_dly                                                     NOVAL     false      NOVAL           true     true           set_fine_dly                            NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_ref_ref_buf_dly                                                   NOVAL     false      NOVAL           true     true           set_ref_buf_dly                         NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_out_freq                                                          NOVAL     false      "Output Freq"   true     true           output_clock_frequency                  NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::mega_to_base                              }\
        {cmu_fpll_out_freq_hz                                                       NOVAL     false      NOVAL           true     true           output_clock_frequency                  NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::mega_to_base                              }\
        {cmu_fpll_primary_use                                                       NOVAL     false      NOVAL           true     true           set_primary_use                         NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::update_primary_use                        }\
        {cmu_fpll_refclk_source                                                     NOVAL     false      NOVAL           true     true           set_atx_fpll_cascade_option             {"0:normal_refclk" "1:lc_dedicated_refclk"}                                                                                                                        ::ct1_cmu_fpll::parameters::validate_cmu_fpll_refclk_source                   }\
        {cmu_fpll_prot_mode                                                         NOVAL     false      NOVAL           true     true           prot_mode_fnl                           NOVAL                                                                                                                                                              ::ct1_cmu_fpll::parameters::validate_cmu_fpll_prot_mode                       }\
        {cmu_fpll_vco_frequency                                                     NOVAL     false      NOVAL           true     true           vco_freq_derived                        NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::mega_to_base                              }\
        {cmu_fpll_vco_freq                                                          NOVAL     false      NOVAL           true     true           vco_freq_derived                        NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::mega_to_base                              }\
        {cmu_fpll_vco_freq_hz                                                       NOVAL     false      NOVAL           true     true           vco_freq_derived                        NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::mega_to_base                              }\
        {cmu_fpll_pfd_freq                                                          NOVAL     false      NOVAL           true     true           pfd_freq_derived                        NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::mega_to_base                              }\
        {cmu_fpll_datarate_bps                                                      NOVAL     false      NOVAL           true     true           output_datarate                         NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::mega_to_base                              }\
        {cmu_fpll_sup_mode                                                          NOVAL     false      NOVAL           true     true           support_mode                            NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_c0_pllcout_enable                                                 NOVAL     false      NOVAL           true     true           pll_c0_enable                           NOVAL                                                                                                                                                              ::ct1_cmu_fpll::parameters::validate_cmu_fpll_c0_pllcout_enable               }\
        {cmu_fpll_c1_pllcout_enable                                                 NOVAL     false      NOVAL           true     true           pll_c1_enable                           NOVAL                                                                                                                                                              ::ct1_cmu_fpll::parameters::validate_cmu_fpll_c1_pllcout_enable               }\
        {cmu_fpll_c2_pllcout_enable                                                 NOVAL     false      NOVAL           true     true           pll_c2_enable                           NOVAL                                                                                                                                                              ::ct1_cmu_fpll::parameters::validate_cmu_fpll_c2_pllcout_enable               }\
        {cmu_fpll_c3_pllcout_enable                                                 NOVAL     false      NOVAL           true     true           pll_c3_enable                           NOVAL                                                                                                                                                              ::ct1_cmu_fpll::parameters::validate_cmu_fpll_c3_pllcout_enable               }\
        {cmu_fpll_c0_cnt_div                                                        NOVAL     false      NOVAL           true     true           pll_c0                                  NOVAL                                                                                                                                                              ::ct1_cmu_fpll::parameters::validate_cmu_fpll_c0_cnt_div                      }\
        {cmu_fpll_c1_cnt_div                                                        NOVAL     false      NOVAL           true     true           pll_c1                                  NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_c2_cnt_div                                                        advanced  false      "C-Counter"     true     true           pll_c2                                  NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_c3_cnt_div                                                        NOVAL     false      NOVAL           true     true           pll_c3                                  NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_f_out_c0                                                          NOVAL     false      NOVAL           true     true           f_out_c0                                NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::update_c0_counter_frequency               }\
        {cmu_fpll_f_out_c0_hz                                                       NOVAL     false      NOVAL           true     true           f_out_c0_hz                             NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::update_c0_counter_frequency_in_hz         }\
        {cmu_fpll_f_out_c1                                                          NOVAL     false      NOVAL           true     true           f_out_c1                                NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_f_out_c1_hz                                                       NOVAL     false      NOVAL           true     true           f_out_c1_hz                             NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_f_out_c2                                                          NOVAL     false      NOVAL           true     true           f_out_c2                                NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_f_out_c2_hz                                                       NOVAL     false      NOVAL           true     true           f_out_c2_hz                             NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_pll_fractional_division                                           advanced  false      "K-Counter"     true     true           set_k_counter                           NOVAL                                                                                                                                                              ::ct1_cmu_fpll::parameters::validate_cmu_fpll_pll_fractional_division         }\
        {cmu_fpll_bw_mode                                                           NOVAL     false      NOVAL           true     true           set_bw_sel                              {"low:low_bw" "high:hi_bw" "medium:mid_bw"}                                                                                                                        NOVAL                                                                         }\
        {cmu_fpll_compensation_mode                                                 NOVAL     false      NOVAL           true     true           compensation_mode_derived               NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_hssi_output_clock_frequency                                       NOVAL     false      NOVAL           true     true           output_clock_frequency                  NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::mega_to_base                              }\
        {cmu_fpll_output_clock_frequency_0                                          NOVAL     false      NOVAL           true     true           output_clock_frequency                  NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::mega_to_base                              }\
        {cmu_fpll_output_clock_frequency_1                                          NOVAL     false      NOVAL           true     true           output_clock_frequency                  NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::mega_to_base                              }\
        {cmu_fpll_output_clock_frequency_2                                          NOVAL     false      NOVAL           true     true           output_clock_frequency                  NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::mega_to_base                              }\
        {cmu_fpll_output_clock_frequency_3                                          NOVAL     false      NOVAL           true     true           output_clock_frequency                  NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::mega_to_base                              }\
        {cmu_fpll_phase_shift_c0                                                    NOVAL     false      NOVAL           true     true           core_phase_shift_0                      NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_phase_shift_c1                                                    NOVAL     false      NOVAL           true     true           core_phase_shift_1                      NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_phase_shift_c2                                                    NOVAL     false      NOVAL           true     true           core_phase_shift_2                      NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_phase_shift_c3                                                    NOVAL     false      NOVAL           true     true           core_phase_shift_3                      NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_reference_clock_frequency                                         NOVAL     false      NOVAL           true     true           reference_clock_frequency_fnl           NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::mega_to_base                              }\
        {cmu_fpll_cgb_div                                                           NOVAL     false      NOVAL           true     true           mcgb_div_fnl                            NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_pma_width                                                         NOVAL     false      NOVAL           true     true           NOVAL                                   NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::convert_pma_width                         }\
        {cmu_fpll_refclk_select_mux_refclk_select0                                  NOVAL     false      NOVAL           true     true           set_refclk_index                        {"0:ref_iqclk0" "1:ref_iqclk1" "2:ref_iqclk2" "3:ref_iqclk3" "4:ref_iqclk4"}                                                                                       NOVAL                                                                         }\
        {cmu_fpll_refclk_select_mux_mux0_inclk1_logical_to_physical_mapping         NOVAL     false      NOVAL           true     true           set_refclk_cnt                          {"1:power_down" "2:ref_iqclk0" "3:ref_iqclk0" "4:ref_iqclk0" "5:ref_iqclk0"}                                                                                       NOVAL                                                                         }\
        {cmu_fpll_refclk_select_mux_mux0_inclk2_logical_to_physical_mapping         NOVAL     false      NOVAL           true     true           set_refclk_cnt                          {"1:power_down" "2:power_down" "3:ref_iqclk1" "4:ref_iqclk1" "5:ref_iqclk1"}                                                                                       NOVAL                                                                         }\
        {cmu_fpll_refclk_select_mux_mux0_inclk3_logical_to_physical_mapping         NOVAL     false      NOVAL           true     true           set_refclk_cnt                          {"1:power_down" "2:power_down" "3:power_down" "4:ref_iqclk2" "5:ref_iqclk2"}                                                                                       NOVAL                                                                         }\
        {cmu_fpll_refclk_select_mux_mux0_inclk4_logical_to_physical_mapping         NOVAL     false      NOVAL           true     true           set_refclk_cnt                          {"1:power_down" "2:power_down" "3:power_down" "4:power_down" "5:ref_iqclk3"}                                                                                       NOVAL                                                                         }\
        {cmu_fpll_refclk_select_mux_mux1_inclk0_logical_to_physical_mapping         NOVAL     false      NOVAL           true     true           set_refclk_cnt                          {"1:lvpecl"     "2:lvpecl"     "3:lvpecl"     "4:lvpecl"     "5:lvpecl"    }                                                                                       NOVAL                                                                         }\
        {cmu_fpll_refclk_select_mux_mux1_inclk1_logical_to_physical_mapping         NOVAL     false      NOVAL           true     true           set_refclk_cnt                          {"1:power_down" "2:ref_iqclk0" "3:ref_iqclk0" "4:ref_iqclk0" "5:ref_iqclk0"}                                                                                       NOVAL                                                                         }\
        {cmu_fpll_refclk_select_mux_mux1_inclk2_logical_to_physical_mapping         NOVAL     false      NOVAL           true     true           set_refclk_cnt                          {"1:power_down" "2:power_down" "3:ref_iqclk1" "4:ref_iqclk1" "5:ref_iqclk1"}                                                                                       NOVAL                                                                         }\
        {cmu_fpll_refclk_select_mux_mux1_inclk3_logical_to_physical_mapping         NOVAL     false      NOVAL           true     true           set_refclk_cnt                          {"1:power_down" "2:power_down" "3:power_down" "4:ref_iqclk2" "5:ref_iqclk2"}                                                                                       NOVAL                                                                         }\
        {cmu_fpll_refclk_select_mux_mux1_inclk4_logical_to_physical_mapping         NOVAL     false      NOVAL           true     true           set_refclk_cnt                          {"1:power_down" "2:power_down" "3:power_down" "4:power_down" "5:ref_iqclk3"}                                                                                       NOVAL                                                                         }\
        {cmu_fpll_power_mode                                                        NOVAL     false      NOVAL           true     true           NOVAL                                   NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::update_power_mode                         }\
        {cmu_fpll_lcnt_l_cnt_bypass                                                 NOVAL     false      NOVAL           true     true           NOVAL                                   NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::update_lcnt_l_cnt_bypass                  }\
        {cmu_fpll_testmux_tclk_mux_en                                               NOVAL     false      NOVAL           true     true           NOVAL                                   NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::update_cmu_fpll_testmux_tclk_mux_en       }\
        {cmu_fpll_testmux_tclk_sel                                                  NOVAL     false      NOVAL           true     true           NOVAL                                   NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::update_cmu_fpll_testmux_tclk_sel          }\
        {cmu_fpll_refclk                                                            NOVAL     false      NOVAL           true     true           set_auto_reference_clock_frequency      NOVAL                                                                                                                                                              ::altera_xcvr_fpll_s10::parameters::mega_to_base                              }\
        {cmu_fpll_dsm_mode                                                          NOVAL     false      NOVAL           true     true           set_dsm_mode                            NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_c2_m_cnt_ph_mux_prst                                              NOVAL     false      NOVAL           true     true           pll_c2_ph_mux_prst                      NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {cmu_fpll_c2_m_cnt_prst                                                     NOVAL     false      NOVAL           true     true           pll_c2_prst                             NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {hssi_avmm2_if_silicon_rev                                                  NOVAL     false      NOVAL           true     true           device_revision                         NOVAL                                                                                                                                                              NOVAL                                                                         }\
        {hssi_avmm2_if_pcs_calibration_feature_en                                   NOVAL     false      NOVAL           true     true           calibration_en                          {"disable:avmm2_pcs_calibration_dis" "enable:avmm2_pcs_calibration_en"}                                                                                            NOVAL                                                                         }\
        {hssi_avmm2_if_pcs_hip_cal_en                                               NOVAL     false      NOVAL           true     true           hip_cal_en                              NOVAL                                                                                                                                                              NOVAL                                                                         }\

   } 
    
    set atom_parameters_default {\
        {NAME                                                                          M_AUTOSET            DEFAULT_VALUE                    }\
        {cmu_fpll_ctrl_slf_rst                                                         false                "pll_slf_rst_off"                }\
        {cmu_fpll_mcnt_coarse_dly                                                      false                "pll_coarse_dly_setting0"        }\
        {cmu_fpll_mcnt_fine_dly                                                        false                "pll_fine_dly_setting0"          }\
        {cmu_fpll_fb_cmp_buf_dly                                                       false                "pll_cmp_buf_dly_setting0"       }\
        {cmu_fpll_refclk_select_mux_clk_sel_override                                   false                "normal"                         }\
        {cmu_fpll_refclk_select_mux_clk_sel_override_value                             false                "select_clk0"                    }\
        {cmu_fpll_refclk_select_mux_xpm_clkin_fpll_xpm_pll_so_pll_auto_clk_sw_en       false                "pll_auto_clk_sw_disabled"       }\
        {cmu_fpll_refclk_select_mux_xpm_clkin_fpll_xpm_pll_so_pll_clk_loss_edge        false                "pll_clk_loss_rising_edge"       }\
        {cmu_fpll_refclk_select_mux_xpm_clkin_fpll_xpm_pll_so_pll_clk_loss_sw_en       false                "pll_clk_loss_sw_byps"           }\
        {cmu_fpll_refclk_select_mux_xpm_clkin_fpll_xpm_pll_so_pll_clk_sw_dly           false                0                                }\
        {cmu_fpll_refclk_select_mux_xpm_clkin_fpll_xpm_pll_so_pll_manu_clk_sw_en       false                "pll_manu_clk_sw_disabled"       }\
   }

    set atom_parameters_warnings_off {\
        {NAME                                                                           M_AUTOWARN  }\
        {cmu_fpll_chgpmp_current_setting                                                false       }\
        {cmu_fpll_lf_resistance                                                         false       }\
        {cmu_fpll_pll_vco_freq_band_0_dyn_high_bits                                     false       }\
        {cmu_fpll_pll_vco_freq_band_0_dyn_low_bits                                      false       }\
        {cmu_fpll_pll_vco_freq_band_0_fix                                               false       }\
        {cmu_fpll_pll_vco_freq_band_0_fix_high                                          false       }\
        {cmu_fpll_pll_vco_freq_band_1_dyn_high_bits                                     false       }\
        {cmu_fpll_pll_vco_freq_band_1_dyn_low_bits                                      false       }\
        {cmu_fpll_pll_vco_freq_band_1_fix                                               false       }\
        {cmu_fpll_pll_vco_freq_band_1_fix_high                                          false       }\
        {cmu_fpll_lf_3rd_pole_freq                                                      false       }\
        {cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_pll_clkin_0_scratch0_src           false       }\
        {cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_pll_clkin_0_scratch1_src           false       }\
        {cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_pll_clkin_0_scratch2_src           false       }\
        {cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_pll_clkin_0_scratch3_src           false       }\
        {cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_pll_clkin_0_scratch4_src           false       }\
        {cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_pll_clkin_1_scratch0_src           false       }\
        {cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_pll_clkin_1_scratch1_src           false       }\
        {cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_pll_clkin_1_scratch2_src           false       }\
        {cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_pll_clkin_1_scratch3_src           false       }\
        {cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_pll_clkin_1_scratch4_src           false       }\
        {cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_fpll_iq0_scratch0_src              false       }\
        {cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_fpll_iq0_scratch1_src              false       }\
        {cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_fpll_iq0_scratch2_src              false       }\
        {cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_fpll_iq0_scratch3_src              false       }\
        {cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_fpll_iq0_scratch4_src              false       }\
        {cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_fpll_iq1_scratch0_src              false       }\
        {cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_fpll_iq1_scratch1_src              false       }\
        {cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_fpll_iq1_scratch2_src              false       }\
        {cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_fpll_iq1_scratch3_src              false       }\
        {cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_fpll_iq1_scratch4_src              false       }\
        {cmu_fpll_refclk_select_mux_xpm_iqref_mux0_iqclk_sel                            false       }\
        {cmu_fpll_refclk_select_mux_xpm_iqref_mux1_iqclk_sel                            false       }\
    }

    set logical_parameters {\
        { NAME                    M_RCFG_REPORT   TYPE       DERIVED   M_MAPS_FROM                     HDL_PARAMETER   ENABLED   VISIBLE   M_MAP_VALUES }\
        { lc_refclk_select        1               INTEGER    true      set_refclk_index                false           false     false     NOVAL }\
    }

    set static_hdl_parameters {\
        { NAME                                                                   M_AUTOSET       M_IS_STATIC_HDL_PARAMETER   M_RCFG_REPORT   TYPE       DERIVED   HDL_PARAMETER   ENABLED   VISIBLE   DEFAULT_VALUE                    VALIDATION_CALLBACK}\
        { cmu_fpll_initial_settings                                              false           true                        1               STRING     true      true            false     false     "true"                           NOVAL }\
        { cmu_fpll_refclk_select_mux_mux0_inclk1_logical_to_physical_mapping     false           true                        0               STRING     true      false           false     false     "power_down"                     NOVAL }\
        { cmu_fpll_refclk_select_mux_mux0_inclk2_logical_to_physical_mapping     false           true                        0               STRING     true      false           false     false     "power_down"                     NOVAL }\
        { cmu_fpll_refclk_select_mux_mux0_inclk3_logical_to_physical_mapping     false           true                        0               STRING     true      false           false     false     "power_down"                     NOVAL }\
        { cmu_fpll_refclk_select_mux_mux0_inclk4_logical_to_physical_mapping     false           true                        0               STRING     true      false           false     false     "power_down"                     NOVAL }\
        { cmu_fpll_refclk_select_mux_mux1_inclk1_logical_to_physical_mapping     false           true                        0               STRING     true      false           false     false     "power_down"                     NOVAL }\
        { cmu_fpll_refclk_select_mux_mux1_inclk2_logical_to_physical_mapping     false           true                        0               STRING     true      false           false     false     "power_down"                     NOVAL }\
        { cmu_fpll_refclk_select_mux_mux1_inclk3_logical_to_physical_mapping     false           true                        0               STRING     true      false           false     false     "power_down"                     NOVAL }\
        { cmu_fpll_refclk_select_mux_mux1_inclk4_logical_to_physical_mapping     false           true                        0               STRING     true      false           false     false     "power_down"                     NOVAL }\
        { cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_pll_clkin_0_scratch0_src   false           true                        0               STRING     true      true            false     false     "pll_clkin_0_scratch0_src_vss"   NOVAL }\
        { cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_pll_clkin_0_scratch1_src   false           true                        0               STRING     true      true            false     false     "pll_clkin_0_scratch1_src_vss"   NOVAL }\
        { cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_pll_clkin_0_scratch2_src   false           true                        0               STRING     true      true            false     false     "pll_clkin_0_scratch2_src_vss"   NOVAL }\
        { cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_pll_clkin_0_scratch3_src   false           true                        0               STRING     true      true            false     false     "pll_clkin_0_scratch3_src_vss"   NOVAL }\
        { cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_pll_clkin_0_scratch4_src   false           true                        0               STRING     true      true            false     false     "pll_clkin_0_scratch4_src_vss"   NOVAL }\
        { cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_pll_clkin_1_scratch0_src   false           true                        0               STRING     true      true            false     false     "pll_clkin_1_scratch0_src_vss"   NOVAL }\
        { cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_pll_clkin_1_scratch1_src   false           true                        0               STRING     true      true            false     false     "pll_clkin_1_scratch1_src_vss"   NOVAL }\
        { cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_pll_clkin_1_scratch2_src   false           true                        0               STRING     true      true            false     false     "pll_clkin_1_scratch2_src_vss"   NOVAL }\
        { cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_pll_clkin_1_scratch3_src   false           true                        0               STRING     true      true            false     false     "pll_clkin_1_scratch3_src_vss"   NOVAL }\
        { cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_pll_clkin_1_scratch4_src   false           true                        0               STRING     true      true            false     false     "pll_clkin_1_scratch4_src_vss"   NOVAL }\
        { cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_fpll_iq0_scratch0_src      false           true                        0               STRING     true      true            false     false     "iq0_scratch0_power_down"        NOVAL }\
        { cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_fpll_iq0_scratch1_src      false           true                        0               STRING     true      true            false     false     "iq0_scratch1_power_down"        NOVAL }\
        { cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_fpll_iq0_scratch2_src      false           true                        0               STRING     true      true            false     false     "iq0_scratch2_power_down"        NOVAL }\
        { cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_fpll_iq0_scratch3_src      false           true                        0               STRING     true      true            false     false     "iq0_scratch3_power_down"        NOVAL }\
        { cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_fpll_iq0_scratch4_src      false           true                        0               STRING     true      true            false     false     "iq0_scratch4_power_down"        NOVAL }\
        { cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_fpll_iq1_scratch0_src      false           true                        0               STRING     true      true            false     false     "iq1_scratch0_power_down"        NOVAL }\
        { cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_fpll_iq1_scratch1_src      false           true                        0               STRING     true      true            false     false     "iq1_scratch1_power_down"        NOVAL }\
        { cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_fpll_iq1_scratch2_src      false           true                        0               STRING     true      true            false     false     "iq1_scratch2_power_down"        NOVAL }\
        { cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_fpll_iq1_scratch3_src      false           true                        0               STRING     true      true            false     false     "iq1_scratch3_power_down"        NOVAL }\
        { cmu_fpll_refclk_select_mux_pm_cmu_fpll_atom_fpll_iq1_scratch4_src      false           true                        0               STRING     true      true            false     false     "iq1_scratch4_power_down"        NOVAL }\
        { cmu_fpll_refclk_select_mux_xpm_clkin_fpll_pll_clkin_0_src              false           true                        0               STRING     true      true            false     false     "pll_clkin_0_src_ref_clk"        NOVAL }\
        { cmu_fpll_refclk_select_mux_xpm_clkin_fpll_pll_clkin_1_src              false           true                        0               STRING     true      true            false     false     "pll_clkin_1_src_ref_clk"        NOVAL }\
        { cmu_fpll_refclk_select_mux_xpm_clkin_fpll_xpm_pll_so_pll_sw_refclk_src false           true                        0               STRING     true      true            false     false     "pll_sw_refclk_src_clk_0"        NOVAL }\
  
    }

  set set_parameter_list [list]
  set set_parameter_values [list]
  set set_display_units [list] 
}

# declare parameters 
# This function is called by declare_module 
proc ::altera_xcvr_fpll_s10::parameters::declare_parameters { {device_family "Stratix 10"} } {
   variable display_items_pll
   variable generation_display_items
   variable set_parameters
   variable atom_parameters
   variable atom_parameters_default
   variable atom_parameters_warnings_off
   variable logical_parameters
   variable static_hdl_parameters

   variable set_parameter_list
   variable set_parameter_values
   variable set_display_units

   # Which parameters are included in reconfig reports is parameter dependent
   ip_add_user_property_type M_RCFG_REPORT integer

   ::alt_xcvr::utils::reconfiguration_stratix10::declare_parameters 1
   ip_set "parameter.rcfg_file_prefix.DEFAULT_VALUE" "altera_xcvr_fpll_s10"
   ip_declare_parameters [::ct1_cmu_fpll::parameters::get_parameters]
   
   # Mark HDL parameters
   set ct1_cmu_fpll_parameters [ip_get_matching_parameters [dict set criteria M_IP_CORE ct1_cmu_fpll]]
   foreach param $ct1_cmu_fpll_parameters {
     if {[ip_get "parameter.${param}.M_IS_STATIC_HDL_PARAMETER"] == "false"} {
       ip_set "parameter.${param}.HDL_PARAMETER" 1
       ip_set "parameter.${param}.M_RCFG_REPORT" 1
       
     }
    
      ip_set "parameter.${param}.M_AUTOSET" "true"
    ip_set "parameter.${param}.M_AUTOWARN" "true"
   }

   # use ip_declare_parameters for all the other tables/list of lists 
   ip_declare_parameters $set_parameters
   ip_declare_parameters $atom_parameters
   ip_declare_parameters $atom_parameters_default
   ip_declare_parameters $atom_parameters_warnings_off
   ip_declare_parameters $logical_parameters
   ip_declare_parameters $static_hdl_parameters

   # declare mcgb parameters along with helper procedures 
   ::mcgb_package_s10::mcgb::set_hip_cal_done_enable_maps_from enable_hip_cal_done_port
   ::mcgb_package_s10::mcgb::set_output_clock_frequency_maps_from output_clock_frequency
   ::mcgb_package_s10::mcgb::set_protocol_mode_maps_from prot_mode_fnl
   ::mcgb_package_s10::mcgb::set_silicon_rev_maps_from device_revision
   ::mcgb_package_s10::mcgb::declare_mcgb_parameters

   # use ip_declare_display_items for display_items_pll and generation_display_items 
   ip_declare_display_items $display_items_pll
   
   # declare mcgb_display_items 
   ::mcgb_package_s10::mcgb::set_mcgb_display_item_properties "" tab
   ::mcgb_package_s10::mcgb::declare_mcgb_display_items

   # declare reconfiguration tab
   ::alt_xcvr::utils::reconfiguration_stratix10::declare_display_items "" tab 1

   ip_declare_display_items $generation_display_items
   
   # Initializations 

   # Initialize device information (to allow sharing of this function across device families)
   ip_set "parameter.device_family.SYSTEM_INFO" DEVICE_FAMILY
   ip_set "parameter.device_family.DEFAULT_VALUE" $device_family

   # Initialize part number & revision
   ip_set "parameter.device.SYSTEM_INFO" DEVICE
   
   ip_set "parameter.base_device.SYSTEM_INFO_TYPE" PART_TRAIT
   ip_set "parameter.base_device.SYSTEM_INFO_ARG" BASE_DEVICE
   #TODO: remove nightfuryes
   #ip_set "parameter.base_device.DEFAULT_VALUE" "nightfury5es";#temporary hack once BASE_DEVICE is properly supported by qsys remove this line

   # To have a parameter displayed in the "Advanced Parameters" tab, set the M_CONTEXT property
   # of that parameter to "advanced" and set its DISPLAY_NAME property to a valid string.
   add_display_item "" "Advanced Parameters" GROUP tab   

   add_parameter set_parameter_list STRING_LIST
   set_parameter_property set_parameter_list DISPLAY_NAME "Parameter Names"
   set_parameter_property set_parameter_list DERIVED true
   set_parameter_property set_parameter_list DESCRIPTION "Shows the list of advanced PLL parameters"

   add_parameter set_parameter_values STRING_LIST
   set_parameter_property set_parameter_values DISPLAY_NAME "Parameter Values"
   set_parameter_property set_parameter_values DERIVED true
   set_parameter_property set_parameter_values DESCRIPTION "Shows the list of values for the advanced PLL parameters"

   add_parameter set_display_units STRING_LIST
   set_parameter_property set_display_units DISPLAY_NAME "Parameter Units"
   set_parameter_property set_display_units DERIVED true
   set_parameter_property set_display_units DESCRIPTION "Shows the units for parameters"

   add_display_item "Advanced Parameters" "parameterTable" GROUP TABLE 
   set_display_item_property "parameterTable" DISPLAY_HINT { table fixed_size rows:48 } 
   add_display_item "parameterTable" set_parameter_list parameter
   add_display_item "parameterTable" set_parameter_values parameter
   add_display_item "parameterTable" set_display_units parameter

  # Grab Quartus INI's
  ip_set "parameter.enable_advanced_options.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_fpll_s10_advanced ENABLED]
  ip_set "parameter.enable_hip_options.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_fpll_atx_pll_10_hip_options ENABLED]
  ip_set "parameter.outclk_en.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_fpll_s10_outclk_en ENABLED]
  ip_set "parameter.enable_debug_options.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_fpll_s10_debug ENABLED]
}

# validation call backs 
proc ::altera_xcvr_fpll_s10::parameters::validate {} {
  ::alt_xcvr::ip_tcl::messages::set_auto_message_level [ip_get "parameter.message_level.value"]

  variable set_parameter_list
  variable set_parameter_values
  variable set_display_units

  set advanced_params [ip_get_matching_parameters [dict set criteria M_CONTEXT advanced]]
  foreach param $advanced_params {
      set name [ip_get "parameter.${param}.DISPLAY_NAME"]
      if { $name != "NOVAL" } {
          lappend parameter_list $name
          lappend parameter_values_list [ip_get "parameter.${param}.value"]
          lappend parameter_display_units [ip_get "parameter.${param}.DISPLAY_UNITS"]
      }
  }
  
  set_parameter_value set_parameter_list $parameter_list
  set_parameter_value set_parameter_values $parameter_values_list
  set_parameter_value set_display_units $parameter_display_units
  
  ip_validate_parameters
  ip_validate_display_items
  
  # validate the display tabs based on core or XCVR mode
  ::altera_xcvr_fpll_s10::parameters::validate_tabs [ip_get "parameter.set_primary_use.value"]
}

#----------------------------------------------------------------------------------------------
# Validation callbacks 
# ---------------------------------------------------------------------------------------------
# If the fPLL is configured in core mode, enable the clock divider block
# The outclk_div1 output is always enabled in core mode
proc ::altera_xcvr_fpll_s10::parameters::update_enable_clk_divider { set_primary_use } {
  if { $set_primary_use == 0 } {
    ip_set "parameter.enable_clk_divider.value" 1
  } else {
    ip_set "parameter.enable_clk_divider.value" 0
  }
}

proc ::altera_xcvr_fpll_s10::parameters::validate_tabs { set_mode } {
  switch $set_mode {
   0 {set_display_item_property "Master Clock Generation Block" VISIBLE false}
   1 {set_display_item_property "Master Clock Generation Block" VISIBLE false}
   2 {set_display_item_property "Master Clock Generation Block" VISIBLE true}
   default {set_display_item_property "Master Clock Generation Block" VISIBLE true}
  }
}
 
#convert units in mega (10^6) to base (10^0)
proc ::altera_xcvr_fpll_s10::parameters::mega_to_base { PROP_NAME PROP_VALUE } { 
    #replace anything not a number or DOT character (to account for doubles)
    regsub -nocase -all {\m(\D)} $PROP_VALUE "" temp
    set temp [expr {wide(double($temp) * 1000000)}]
    ip_set "parameter.${PROP_NAME}.value" $temp
}

proc ::altera_xcvr_fpll_s10::parameters::validate_device_revision { base_device } {
    set temp_device_revision [ct1_cmu_fpll::parameters::get_base_device_user_string $base_device]
    if {$temp_device_revision != "NOVAL"} {
          ip_set "parameter.device_revision.value" $temp_device_revision
    } else {
        set device [ip_get parameter.DEVICE.value]
          ip_message error "The current selected device \"$device\" is invalid, please select a valid device to generate the IP."
    }
}

proc ::altera_xcvr_fpll_s10::parameters::update_primary_use { set_primary_use } {

  switch $set_primary_use {
    "0" {ip_set "parameter.cmu_fpll_primary_use.value" "core"}
    "1" {ip_set "parameter.cmu_fpll_primary_use.value" "iqtxrx"}
    "2" {ip_set "parameter.cmu_fpll_primary_use.value" "tx"}
    default {error "Unknown primary use case"}
  }

}

# This function maps the compensation mode based on feedback type selected 
proc ::altera_xcvr_fpll_s10::parameters::update_compensation_mode { set_fb_select } { 
    switch $set_fb_select {
        "normal"    {ip_set "parameter.compensation_mode_derived.value" "direct"}
        "iqtxrxclk" {ip_set "parameter.compensation_mode_derived.value" "fpll_bonding"}
        default     {error "Unknown compensation mode."}
    }
}

proc ::altera_xcvr_fpll_s10::parameters::update_l_counter { set_primary_use cmu_fpll_f_min_vco cmu_fpll_f_max_vco manual_list set_manual_l_counter pll_setting message_level } {
  if { $set_primary_use == 2 } {
    set pll_setting_size [dict size $pll_setting]
    if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting l_cnt] } {
        ip_message $message_level "l_counter cannot find the entry"
      } else {
        ip_set "parameter.set_l_counter.value" [dict get $pll_setting l_cnt]
      }
    }
  }
}

proc ::altera_xcvr_fpll_s10::parameters::update_c_counter { set_primary_use cmu_fpll_f_min_vco cmu_fpll_f_max_vco manual_list set_manual_c_counter pll_setting message_level } {
    set pll_setting_size [dict size $pll_setting]
    if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting c_cnt] } {
        ip_message $message_level "c_counter cannot find the entry"
      } else {
        ip_set "parameter.set_c_counter.value" [dict get $pll_setting c_cnt]
      }
    }
}

proc ::altera_xcvr_fpll_s10::parameters::update_m_counter { cmu_fpll_f_min_vco cmu_fpll_f_max_vco manual_list set_manual_m_counter pll_setting message_level } {
  set pll_setting_size [dict size $pll_setting]
  if { $pll_setting_size!=0 } {
    if { ![dict exists $pll_setting m_cnt] } {
      ip_message $message_level "m_counter cannot find the entry"
    } else {
      ip_set "parameter.set_m_counter.value" [dict get $pll_setting m_cnt]
    }
  }
}

proc ::altera_xcvr_fpll_s10::parameters::update_n_counter { set_primary_use cmu_fpll_f_min_pfd cmu_fpll_f_max_pfd manual_list set_manual_ref_clk_div pll_setting message_level } {
  set pll_setting_size [dict size $pll_setting]
  if { $pll_setting_size!=0 } {
    if { ![dict exists $pll_setting n_cnt] } {
      ip_message $message_level "n_counter cannot find the entry"
    } else {
      ip_set "parameter.set_ref_clk_div.value" [dict get $pll_setting n_cnt]
    }
  }
}

proc ::altera_xcvr_fpll_s10::parameters::update_k_counter { set_primary_use set_enable_fractional manual_list pll_setting message_level } {
  if { $set_enable_fractional } {
    set pll_setting_size [dict size $pll_setting]
    if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting k_cnt] } {
        ip_message $message_level "k_counter cannot find the entry"
      } else {
        ip_set "parameter.set_k_counter.value" [dict get $pll_setting k_cnt]
      }
    }
  }
}

proc ::altera_xcvr_fpll_s10::parameters::update_c0_counter_frequency { set_output_clock_frequency set_primary_use set_prot_mode } {
  if { $set_primary_use == 2 } {; #cascade mode 
    if { $set_prot_mode == 1 || $set_prot_mode == 2 || $set_prot_mode == 3 } {; # pcie mode
      ip_set "parameter.f_out_c0.value" "000000011101110011010110010100000000"
    }
  }
}

proc ::altera_xcvr_fpll_s10::parameters::update_c0_counter_frequency_in_hz { set_output_clock_frequency set_primary_use set_prot_mode } {
  if { $set_primary_use == 2 } {; #cascade mode 
    if { $set_prot_mode == 1 || $set_prot_mode == 2 || $set_prot_mode == 3 } {; # pcie mode
      ip_set "parameter.f_out_c0_hz.value" "500000000"
    }
  }
}

proc ::altera_xcvr_fpll_s10::parameters::update_c1_counter_frequency { set_output_clock_frequency set_primary_use } {
  if { $set_primary_use == 1 } {; #cascade mode 
     ip_set "parameter.f_out_c1.value" $set_output_clock_frequency
  }
}

proc ::altera_xcvr_fpll_s10::parameters::update_c1_counter_frequency_in_hz { set_output_clock_frequency set_primary_use } {
  if { $set_primary_use == 1 } {; #cascade mode 
     ip_set "parameter.f_out_c1_hz.value" $set_output_clock_frequency
  }
}

proc ::altera_xcvr_fpll_s10::parameters::update_c2_counter_frequency { set_output_clock_frequency set_primary_use } {
  if { $set_primary_use == 0 } {; #core mode 
     ip_set "parameter.f_out_c2.value" [format "%.0f" [expr $set_output_clock_frequency*1000000]]

  }
}

proc ::altera_xcvr_fpll_s10::parameters::update_c2_counter_frequency_in_hz { set_output_clock_frequency set_primary_use } {
  if { $set_primary_use == 0 } {; #core mode 
     ip_set "parameter.f_out_c2_hz.value" [format "%.0f" [expr $set_output_clock_frequency*1000000]]


  }
}

proc ::altera_xcvr_fpll_s10::parameters::update_output_clock_frequency { set_output_clock_frequency } {
 ip_set "parameter.output_clock_frequency.value" $set_output_clock_frequency
}

proc ::altera_xcvr_fpll_s10::parameters::update_vco_freq { pll_setting message_level } {
  set pll_setting_size [dict size $pll_setting]
  if { $pll_setting_size!=0 } {
    if { ![dict exists $pll_setting vco_freq] } {
      ip_message $message_level "vco_freq cannot find the entry"
    } else {
      ip_set "parameter.vco_freq_derived.value" [dict get $pll_setting vco_freq]


    }
  }
}

proc ::altera_xcvr_fpll_s10::parameters::update_pfd_freq { pll_setting message_level } {
  set pll_setting_size [dict size $pll_setting]
  if { $pll_setting_size!=0 } {
    if { ![dict exists $pll_setting pfd_freq] } {
      ip_message $message_level "pfd_freq cannot find the entry"
    } else {
      ip_set "parameter.pfd_freq_derived.value" [dict get $pll_setting pfd_freq]
    }
  }
}

proc ::altera_xcvr_fpll_s10::parameters::update_output_datarate { select_manual_config pll_setting set_output_clock_frequency message_level set_primary_use } {
  if { !$select_manual_config } {
    if { $set_primary_use == 0 } {; #core mode 
      ip_set "parameter.output_datarate.value" 0
    } else {; #not core mode
      ip_set "parameter.output_datarate.value" [ expr ($set_output_clock_frequency*2) ]
    }
  } else {
    if { [dict exists $pll_setting outclk] } {
      if { [dict get $pll_setting outclk] != "NOVAL" } {
          ip_set "parameter.output_datarate.value" [expr [dict get $pll_setting outclk] * 2] 
      }
    }
  }
}

proc ::altera_xcvr_fpll_s10::parameters::validate_support_mode { PROP_NAME PROP_VALUE message_level } {
    if {$PROP_VALUE == "engineering_mode"} {
        ip_message warning "Engineering support mode has been selected. Engineering mode is for internal use only. Altera does not officially support or guarantee IP configurations for this mode."
    }
}

proc ::altera_xcvr_fpll_s10::parameters::update_core_counters { set_primary_use set_prot_mode set_c_counter } {

  if { $set_primary_use == 0 } {; #core mode 
    # enable only C2 
    ip_set "parameter.pll_c2_enable.value" "pllcout_enable"
    # configure C2 
    ip_set "parameter.pll_c2.value" $set_c_counter

  } elseif { $set_primary_use == 1 } {; #cascade mode 
    # enable only C1 
    ip_set "parameter.pll_c1_enable.value" "pllcout_enable"
    # configure C1 
    ip_set "parameter.pll_c1.value" $set_c_counter

  } else {; # XCVR mode 
    # enable C0 only if it is PCIe mode 
    # 0- basic, 1- pcie_gen1, 2 - pcie_gen2, 3 - pcie_gen3  
    if { $set_prot_mode == 1 || $set_prot_mode == 2 || $set_prot_mode == 3 } {
      # enable only C0
      ip_set "parameter.pll_c0_enable.value" "pllcout_enable"
      # configure C0
      ip_set "parameter.pll_c0.value" $set_c_counter

    } else {
      # disable all counters
      ip_set "parameter.pll_c0_enable.value" "pllcout_disable"
      # disable 
      ip_set "parameter.pll_c0.value" 1

    }
  }
}

proc ::altera_xcvr_fpll_s10::parameters::update_dsm_mode { set_enable_fractional } {
    set temp_dsm_mode "dsm_mode_integer"
    
    switch $set_enable_fractional {
        "1"   {set temp_dsm_mode "dsm_mode_phase"}
        "0"   {set temp_dsm_mode "dsm_mode_integer"}
        default  {set temp_dsm_mode "dsm_mode_integer"}
    }
    ip_set "parameter.set_dsm_mode.value" $temp_dsm_mode    
}

proc ::altera_xcvr_fpll_s10::parameters::update_power_mode { set_power_mode } {
    switch $set_power_mode {
        "0_9V"  { ip_set "parameter.cmu_fpll_power_mode.value" "low_power" }
        "1_0V"  { ip_set "parameter.cmu_fpll_power_mode.value" "mid_power" }
        "1_1V"  { ip_set "parameter.cmu_fpll_power_mode.value" "high_perf" }
        default { ip_message error "Invalid VCCR_GXB / VCCT_GXB voltage setting" }
    }

    set message "<html><font color=\"blue\">Note - </font>All PLLs and Native PHY instances in a given tile must be configured with the same supply voltage </html>"
    ip_set "display_item.display_power_mode_msg.text" $message 
    
}   


proc ::altera_xcvr_fpll_s10::parameters::update_refclk_auto { select_manual_config set_enable_fractional auto_list set_auto_reference_clock_frequency } {  
    if {$set_enable_fractional} {
    # prevent the set_auto_reference_clock_frequency (integer mode) from throwing an illegal range error
    # keep set_auto_reference_clock_frequency's allowed values to the current legal value
    set all_freqs [dict keys $auto_list]
    ip_set "parameter.set_auto_reference_clock_frequency.allowed_ranges" $set_auto_reference_clock_frequency      
  } elseif { !$select_manual_config } {
    #get all frequencies
    set all_freqs [dict keys $auto_list]
    #update set_auto_reference_clock_frequency range
    ip_set "parameter.set_auto_reference_clock_frequency.allowed_ranges" $all_freqs 
  } else {
    #setting allowed range to anything will prevent user getting meaningless range errors while working in manual mode
    ip_set "parameter.set_auto_reference_clock_frequency.allowed_ranges" ""
  }
}

proc ::altera_xcvr_fpll_s10::parameters::update_reflk_freq { set_enable_fractional set_fref_clock_frequency pll_setting message_level } {
  
  set pll_setting_size [dict size $pll_setting]
  if { $pll_setting_size!=0 } {      
    if { ![dict exists $pll_setting refclk] } {
      ip_message $message_level "No valid reference clock"
    } else {
      if {[dict get $pll_setting refclk] != "NOVAL" } {
        ip_set "parameter.reference_clock_frequency_fnl.value" [dict get $pll_setting refclk]
      }
    }
  }
}

proc ::altera_xcvr_fpll_s10::parameters::update_phase_shift { set_primary_use pll_setting set_output_clock_frequency set_initial_phase_shift set_initial_phase_shift_units message_level } {
  if { $set_primary_use != 2 } {;# only core and cascade 
    set pll_setting_size [dict size $pll_setting]
    if { $pll_setting_size!=0 } {
      if { ![dict exists $pll_setting vco_freq] } {
        ip_message $message_level "::altera_xcvr_fpll_s10::parameters::update_phase_shift cannot find the entry"
      } else { 
        set temp_vco_freq [dict get $pll_setting vco_freq]
        set phase_dict [::altera_xcvr_cmu_fpll_s10::pll_calculations::compute_phase_shift $set_output_clock_frequency $set_initial_phase_shift $set_initial_phase_shift_units $temp_vco_freq]
        
        # extract the ph_mux_prst and prst values from the dictionary 
        set prst [dict get $phase_dict prst]
        set ph_mux_prst [dict get $phase_dict ph_mux_prst]
        set actual_phase_ps [dict get $phase_dict actual_phase_ps] 
        
        ip_set "parameter.pll_c2_prst.value" $prst
        ip_set "parameter.pll_c2_ph_mux_prst.value" $ph_mux_prst 
        ip_set "parameter.core_phase_shift_2.value" $actual_phase_ps
      }
    }
  }  else {; #not in core or cascade mode

        ip_set "parameter.pll_c2_prst.value" 1
        ip_set "parameter.pll_c2_ph_mux_prst.value" 0 
        ip_set "parameter.core_phase_shift_2.value" 0



  }

}

##
# check enable_mcgb before propagating pma_width selection to atom parameter
proc ::altera_xcvr_fpll_s10::parameters::convert_pma_width {PROP_NAME enable_mcgb pma_width} {
   set temp $pma_width
   if {!$enable_mcgb} {
      # do not propogate user selection if cgb not enabled
      set temp [ip_get "parameter.pma_width.DEFAULT_VALUE"]
   }

   ip_set "parameter.${PROP_NAME}.value" $temp
}  

proc ::altera_xcvr_fpll_s10::parameters::validate_enable_calibration { set_altera_xcvr_fpll_s10_calibration_en enable_advanced_options } {
  set value [expr { $enable_advanced_options ? $set_altera_xcvr_fpll_s10_calibration_en:1}]
  if { $value } {
    ip_set "parameter.calibration_en.value" "enable"
  } else {
    ip_set "parameter.calibration_en.value" "disable"
  }
}
##
# NOTE: this is a dummy function, for parameters that will eventually be set through a validation_callback (but the functions are not ready yet).
# The parameters are listed in the IP anyways. This is to make sure that they will be part of reconfiguration files.
# However if enumerations for those values changes due to atom map changes, existing IP variant files need to be manually edited.
# This function will enable us to prevent that
proc ::altera_xcvr_fpll_s10::parameters::set_to_default { PROP_NAME } {
   set value [ip_get "parameter.${PROP_NAME}.DEFAULT_VALUE"]
   ip_set "parameter.${PROP_NAME}.value" $value
}

##################################################################################################################################################
# functions: converting user parameters to their final form (appropriate for the hdl) 
##################################################################################################################################################

## \TODO some of these functions needs to be implemented as mapped parameters

proc ::altera_xcvr_fpll_s10::parameters::validate_pma_speedgrade { device_family device } {
  set operating_temperature [::alt_xcvr::utils::device::get_operating_temperature $device_family $device]
  set temp_pma_speed_grade [::alt_xcvr::utils::device::get_pma_speedgrade $device_family $device]
  ip_message info "For the selected device($device), PLL speed grade is $temp_pma_speed_grade."

  set temp_pma_speed_grade "${operating_temperature}${temp_pma_speed_grade}"
  ip_set "parameter.pma_speedgrade.value" $temp_pma_speed_grade
}

proc  ::altera_xcvr_fpll_s10::parameters::convert_fb_select { hssi_pma_cgb_master_cgb_enable_iqtxrxclk} {
   if { [string compare -nocase $hssi_pma_cgb_master_cgb_enable_iqtxrxclk enable_iqtxrxclk]==0 } {         
      ip_set "parameter.set_fb_select.value" "iqtxrxclk"
   } elseif {  [string compare -nocase $hssi_pma_cgb_master_cgb_enable_iqtxrxclk disable_iqtxrxclk]==0} {
      ip_set "parameter.set_fb_select.value" "normal"
   } else {
      ip_set "parameter.set_fb_select.value" "normal"
      ip_message warning "Unexpected feedback mode selecting direct_fb"
   }
}

proc ::altera_xcvr_fpll_s10::parameters::convert_prot_mode { set_prot_mode } {
  switch $set_prot_mode {
    0 {ip_set "parameter.prot_mode_fnl.value" "basic_tx"}
    1 {ip_set "parameter.prot_mode_fnl.value" "pcie_gen1_tx"} 
    2 {ip_set "parameter.prot_mode_fnl.value" "pcie_gen2_tx"} 
    3 {ip_set "parameter.prot_mode_fnl.value" "pcie_gen3_tx"}
    default {error "Unexpected Protocol Mode"}
  }
}    



# +------------------------------------------------------------------------
# | This function sets the new allowed ranges set_refclk_cnt
# |
proc ::altera_xcvr_fpll_s10::parameters::update_set_refclk_cnt { set_refclk_cnt } { 
    # update set_refclk_cnt range
    ip_set "parameter.set_refclk_cnt.ALLOWED_RANGES" {1 2 3 4 5}
}

# +-----------------------------------
# | This function sets the new allowed ranges based on given refclk_cnt
# |
proc ::altera_xcvr_fpll_s10::parameters::update_refclk_index { set_primary_use set_refclk_cnt } { 
      # no harm in setting this even if the feature is disabled

    # update set_refclk_index allowed range from 0 to set_refclk_cnt-1
    set new_range 0
    for {set index 1} {$index < $set_refclk_cnt} {incr index} {
        lappend new_range $index
    }
    ip_set "parameter.set_refclk_index.ALLOWED_RANGES" $new_range
}

##
# check enable_mcgb and enable_bonding_clks before propagating enable_fb_comp_bonding selection to atom parameter
proc ::altera_xcvr_fpll_s10::parameters::convert_fb_comp_bonding {PROP_NAME enable_mcgb enable_bonding_clks enable_fb_comp_bonding} {
   if {$enable_mcgb && $enable_bonding_clks && $enable_fb_comp_bonding} {
      # do propogate user selection 
      ip_set "parameter.${PROP_NAME}.value" 1
   } else {
      ip_set "parameter.${PROP_NAME}.value" 0
   }
}

proc ::altera_xcvr_fpll_s10::parameters::validate_hip_cal_en { set_hip_cal_en calibration_en } {
  set value [expr { $set_hip_cal_en && $calibration_en == "enable" ? "enable" : "disable"}]
  ip_set "parameter.hip_cal_en.value" $value
}

# VCO bypass update l counter bypass
proc ::altera_xcvr_fpll_s10::parameters::update_lcnt_l_cnt_bypass { usr_enable_vco_bypass } {
  if {$usr_enable_vco_bypass} {
      ip_set "parameter.cmu_fpll_lcnt_l_cnt_bypass.value" "lcnt_bypass"
  } else {
      ip_set "parameter.cmu_fpll_lcnt_l_cnt_bypass.value" "lcnt_normal"
  }
}

# VCO bypass update for cmu_fpll_testmux_tclk_mux_en
proc ::altera_xcvr_fpll_s10::parameters::update_cmu_fpll_testmux_tclk_mux_en { usr_enable_vco_bypass } {
  if {$usr_enable_vco_bypass} {
      ip_set "parameter.cmu_fpll_testmux_tclk_mux_en.value" "pll_tclk_mux_enabled"
  } else {
      ip_set "parameter.cmu_fpll_testmux_tclk_mux_en.value" "pll_tclk_mux_disabled"
  }
}

# VCO bypass update for cmu_fpll_testmux_tclk_sel 
proc ::altera_xcvr_fpll_s10::parameters::update_cmu_fpll_testmux_tclk_sel { usr_enable_vco_bypass } {
  if {$usr_enable_vco_bypass} {
      ip_set "parameter.cmu_fpll_testmux_tclk_sel.value" "pll_tclk_n_src"
  } else {
      ip_set "parameter.cmu_fpll_testmux_tclk_sel.value" "pll_tclk_m_src"
  }
}

proc ::altera_xcvr_fpll_s10::parameters::update_in_pcie_hip_mode { enable_pcie_hip_connectivity } {
  if {$enable_pcie_hip_connectivity==1} {
     ip_set "parameter.in_pcie_hip_mode.value" 1
  } else {
     ip_set "parameter.in_pcie_hip_mode.value" 0
  }
}

##################################################################################################################################################
# functions: manual checks
##################################################################################################################################################

##
# check the users setting for output clock frequency vs the primary buffer
proc ::altera_xcvr_fpll_s10::parameters::validate_set_output_clock_frequency { set_output_clock_frequency set_primary_use } {
  
  # check for transceiver mode
  set fmin 500 
  if {$set_primary_use == 2 && $set_output_clock_frequency <= $fmin} {
    ip_message error "Illegal desired frequency for transceiver output clock frequency" 
  }

}

## If in auto-configuration mode, the procedure makes RBC call. 
# result is copied into parameter.auto_list   
proc ::altera_xcvr_fpll_s10::parameters::calculate_pll_auto { select_manual_config \
                                                              device_revision \
                                                              set_primary_use \
                                                              set_enable_fractional \
                                                              cmu_fpll_f_max_pfd \
                                                              cmu_fpll_f_min_pfd \
                                                              cmu_fpll_f_max_vco \
                                                              cmu_fpll_f_min_vco \
                                                              set_output_clock_frequency \
                                                              set_fref_clock_frequency \
                                                              cmu_fpll_prot_mode \
                                                              cmu_fpll_dsm_mode \
                                      set_prot_mode } {
  
  if { !$select_manual_config } { 
    set legality_return "" 
    
    set m_counter_list [::altera_xcvr_fpll_s10::parameters::obtain_m_counter_values $cmu_fpll_prot_mode $cmu_fpll_dsm_mode]
    set n_counter_list [::altera_xcvr_fpll_s10::parameters::obtain_n_counter_values $cmu_fpll_prot_mode]
    
    # differentiate whether it is XCVR mode or core mode
    if {$set_primary_use != 2} { ;# core and cascade mode  
      set l_counter_list 1
      set c_counter_list [::altera_xcvr_fpll_s10::parameters::obtain_c_counter_values $cmu_fpll_prot_mode] 
    } else {;# XCVR mode 
      set l_counter_list [::altera_xcvr_fpll_s10::parameters::obtain_l_counter_values $cmu_fpll_prot_mode]
      set c_counter_list 1 
    }

    ip_set "parameter.auto_list.value" "" 
 
    # TODO: Need to convert into RBC (case:356420) 
    # We just limit the range of refclks 
    set cmu_fpll_f_max_ref [obtain_f_ref_limits "max"]
    set cmu_fpll_f_min_ref [obtain_f_ref_limits "min"] 
    
    # TODO: Enhance RBC to have checks in place for PFDmin (case:356425) 
    # For HSSI, PFDmin is 50MHz and for core and cascade, PFDmin is 29MHz 
    set cmu_fpll_f_min_pfd_temp [obtain_f_min_pfd_limit $set_primary_use]
    
    #set frquency and list constants for PLL calculations 
    set_calc_constants $cmu_fpll_f_max_pfd \
                       $cmu_fpll_f_min_pfd_temp \
                       $cmu_fpll_f_max_vco \
                       $cmu_fpll_f_min_vco \
                       $cmu_fpll_f_max_ref \
                       $cmu_fpll_f_min_ref \
                               $m_counter_list \
                               $n_counter_list \
                               $l_counter_list \
                       $c_counter_list 
      
    set temp_out_freq [expr $set_output_clock_frequency*1000000]; #convert from MHz to Hz
    
    if { $set_enable_fractional } {;#fractional mode 
      #TODO: bug in fractional mode computation. Try integer mode, note down counter values. Next change output freq and then come back to same output freq as integer mode. The counters are not the same
      set temp_ref_freq [expr $set_fref_clock_frequency*1000000]; #convert from MHz to Hz 
      set legality_return [::altera_xcvr_cmu_fpll_s10::pll_calculations::legality_check_fract $temp_out_freq $temp_ref_freq $set_primary_use $device_revision]
    } else {;# integer mode 
      set legality_return [::altera_xcvr_cmu_fpll_s10::pll_calculations::legality_check_auto $temp_out_freq 1 $set_primary_use $device_revision $set_prot_mode]
    }
    # remove the first element - status 
    set legality_return [dict remove $legality_return status]
    set legality_return [dictsort $legality_return]  
    ip_set "parameter.auto_list.value" $legality_return
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

proc ::altera_xcvr_fpll_s10::parameters::update_manual_config { select_manual_config cmu_fpll_prot_mode cmu_fpll_dsm_mode } {  
  if { $select_manual_config } {
    # set allowable range for counters
    ip_set "parameter.set_manual_m_counter.ALLOWED_RANGES" [::altera_xcvr_fpll_s10::parameters::obtain_m_counter_values $cmu_fpll_prot_mode $cmu_fpll_dsm_mode]
    ip_set "parameter.set_manual_l_counter.ALLOWED_RANGES" [::altera_xcvr_fpll_s10::parameters::obtain_l_counter_values $cmu_fpll_prot_mode ]
    ip_set "parameter.set_manual_ref_clk_div.ALLOWED_RANGES" [::altera_xcvr_fpll_s10::parameters::obtain_n_counter_values $cmu_fpll_prot_mode ]
    ip_set "parameter.set_manual_c_counter.ALLOWED_RANGES" [::altera_xcvr_fpll_s10::parameters::obtain_c_counter_values $cmu_fpll_prot_mode ]
  }
}

#stam
proc ::altera_xcvr_fpll_s10::parameters::update_vccrt_range { PROP_VALUE enable_advanced_options } {
   if { $enable_advanced_options || $PROP_VALUE == "0_9V" } {
     ip_set "parameter.set_power_mode.ALLOWED_RANGES" { "1_1V" "1_0V" "0_9V" }
   } else {
     ip_set "parameter.set_power_mode.ALLOWED_RANGES" { "1_1V" "1_0V" }
   }

}


proc ::altera_xcvr_fpll_s10::parameters::calculate_pll_manual {  select_manual_config \
                                                                 set_enable_fractional \
                                                                 set_primary_use \
                                                                 cmu_fpll_prot_mode \
                                                                 cmu_fpll_f_min_vco \
                                                                 cmu_fpll_f_max_vco \
                                                                 cmu_fpll_f_min_pfd \
                                                                 cmu_fpll_f_max_pfd \
                                                                 cmu_fpll_dsm_mode \
                                                                 set_manual_output_clock_frequency \
                                                                 set_manual_reference_clock_frequency \
                                                                 set_manual_m_counter \
                                                                 set_manual_l_counter \
                                                                 set_manual_ref_clk_div \
                                                                 set_manual_c_counter \
                                                                 set_manual_k_counter} {
  if { $select_manual_config } { 
    
    set manual_list [dict create] 
    set cmu_fpll_f_min_pfd_temp [obtain_f_min_pfd_limit $set_primary_use]
    # check for L and C w.r.t VCO
    if { $set_primary_use == "2" } {
      set f_vco_from_l [expr $set_manual_output_clock_frequency * 2 * $set_manual_l_counter * 1000000]; # in Hz 

      # check 1: L 
      if { $f_vco_from_l < $cmu_fpll_f_min_vco || $f_vco_from_l > $cmu_fpll_f_max_vco } {
        ip_message error "VCO limits are violated. VCO is [expr $f_vco_from_l/1000000] MHz. VCO max is [expr $cmu_fpll_f_max_vco/1000000] MHz and VCO min is [expr $cmu_fpll_f_min_vco/1000000] MHz. Try setting different L counter."
        dict set manual_list l "NOVAL"        
        dict set manual_list c "NOVAL"        
        dict set manual_list vco "NOVAL"
      } else {
        #ip_set "parameter.set_l_counter.value" $set_manual_l_counter
        #ip_set "parameter.vco_freq_derived.value" [expr $f_vco_from_l/1000000]
        dict set manual_list vco [expr $f_vco_from_l/1000000]
        dict set manual_list l $set_manual_l_counter
        dict set manual_list c "NOVAL"
      }

    } else {;# core and cascade mode 
      set f_vco_from_c [expr $set_manual_output_clock_frequency * 4 * $set_manual_c_counter * 1000000]; # in Hz 
      
      # check 1a: C 
      if { $f_vco_from_c < $cmu_fpll_f_min_vco || $f_vco_from_c > $cmu_fpll_f_max_vco } {
        ip_message error "VCO limits are violated. VCO is [expr $f_vco_from_c/1000000] MHz. VCO max is [expr $cmu_fpll_f_max_vco/1000000] MHz and VCO min is [expr $cmu_fpll_f_min_vco/1000000] MHz. Try setting different C counter." 
        dict set manual_list l "NOVAL"        
        dict set manual_list c "NOVAL"        
        dict set manual_list vco "NOVAL"
      } else {
        #ip_set "parameter.set_c_counter.value" $set_manual_c_counter
        #ip_set "parameter.vco_freq_derived.value" [expr $f_vco_from_c/1000000]
        dict set manual_list vco [expr $f_vco_from_c/1000000]
        dict set manual_list c $set_manual_c_counter
        dict set manual_list l "NOVAL"
      }

    }

    set f_pfd_from_n [expr $set_manual_reference_clock_frequency * 1000000 / $set_manual_ref_clk_div];#in Hz
    
    # check 2 
    if { $f_pfd_from_n < $cmu_fpll_f_min_pfd_temp || $f_pfd_from_n > $cmu_fpll_f_max_pfd } {
      ip_message error "PFD limits are violated. PFD is [expr $f_pfd_from_n/1000000] MHz. PFD max is [expr $cmu_fpll_f_max_pfd/1000000] MHz and PFD min is [expr $cmu_fpll_f_min_pfd_temp/1000000] MHz. Try setting different N counter." 
      dict set manual_list n "NOVAL"        
      dict set manual_list pfd "NOVAL"
    } else {
      #ip_set "parameter.set_ref_clk_div.value" $set_manual_ref_clk_div
      #ip_set "parameter.pfd_freq_derived.value" [expr $f_pfd_from_n/1000000]
      dict set manual_list pfd [expr $f_pfd_from_n/1000000]
      dict set manual_list n $set_manual_ref_clk_div
    }

    set f_vco_from_m [expr $f_pfd_from_n * $set_manual_m_counter * 2];#in Hz (f_pfd_from_n is already in Hz) 
    
    # check 3 
    if { $f_vco_from_m < $cmu_fpll_f_min_vco || $f_vco_from_m > $cmu_fpll_f_max_vco } {
      ip_message error "VCO limits are violated. VCO is [expr $f_vco_from_m/1000000] MHz. VCO max is [expr $cmu_fpll_f_max_vco/1000000] MHz and VCO min is [expr $cmu_fpll_f_min_vco/1000000] MHz. Try setting different M counter." 
      dict set manual_list m "NOVAL"        
      dict set manual_list vco "NOVAL"        
    } else {
      #ip_set "parameter.set_m_counter.value" $set_manual_m_counter
      #ip_set "parameter.vco_freq_derived.value" [expr $f_vco_from_m/1000000]
      dict set manual_list vco [expr $f_vco_from_m/1000000]
      dict set manual_list m $set_manual_m_counter

    }
    
    # check 4. check if K is within 1-99% of allowable range 
    # TODO: relax the rule only for SDI direct 
    # create a new tcl parameter and check if SDI direct is enabled in the GUI 
    if { $set_enable_fractional } {
      # get the limits from get_k_counter_limits in pll_calculations 
      #set min_k [expr round(0.01 * 4294967296)]
      #set max_k [expr round(0.99 * 4294967296)]
      set min_k [::altera_xcvr_cmu_fpll_s10::pll_calculations::get_k_counter_limits "min"]
      set max_k [::altera_xcvr_cmu_fpll_s10::pll_calculations::get_k_counter_limits "max"] 

      if { $set_manual_k_counter < $min_k || $set_manual_k_counter > $max_k } {
        ip_message error "Illegal K value. Min K is $min_k and Max K is $max_k"
        dict set manual_list k "NOVAL"        
      } else {
        #ip_set "parameter.set_k_counter.value" $set_manual_k_counter
        dict set manual_list k $set_manual_k_counter
      }
    } else {
      dict set manual_list k "NOVAL"
    }
    
    # check 5. Make sure output clock frequency can be achieved 
    if { !$set_enable_fractional } {
      if { $set_primary_use != "2" } {; # core and cascade 
        set f_out_int [expr ($set_manual_reference_clock_frequency * 2 * $set_manual_m_counter)/($set_manual_ref_clk_div * 4 * $set_manual_c_counter) ] 
      } else {; # XCVR mode
        set f_out_int [expr ($set_manual_reference_clock_frequency * 2 * $set_manual_m_counter)/($set_manual_ref_clk_div * 2 * $set_manual_l_counter) ]
      }
      
      if { $f_out_int != $set_manual_output_clock_frequency } {
        ip_message error "Output frequency cannot be synthesized. The calculated output frequency is $f_out_int"
        dict set manual_list refclk "NOVAL"
        dict set manual_list outclk "NOVAL"
      } else {
        #ip_set "parameter.reference_clock_frequency_fnl.value" $set_manual_reference_clock_frequency
        #ip_set "parameter.output_clock_frequency.value" $f_out_int
        dict set manual_list refclk $set_manual_reference_clock_frequency
        dict set manual_list outclk $f_out_int

      } 
    } else {; # fractional 
      if { $set_primary_use != "2" } {; # core and cascade 
        set f_out_frac [expr ($set_manual_reference_clock_frequency * 2 * ($set_manual_m_counter + $set_manual_k_counter/4294967296)) / ($set_manual_ref_clk_div * 4 * $set_manual_c_counter) ] 
      } else {; # XCVR mode
        set f_out_frac [expr ($set_manual_reference_clock_frequency * 2 * ($set_manual_m_counter + $set_manual_k_counter/4294967296)) / ($set_manual_ref_clk_div * 2 * $set_manual_l_counter) ]
      }
      
      if { $f_out_frac != $set_manual_output_clock_frequency } {
        ip_message error "Output frequency cannot be synthesized. The calculated output frequency is $f_out_frac"
        dict set manual_list refclk "NOVAL"
        dict set manual_list outclk "NOVAL"
      } else {
        #ip_set "parameter.reference_clock_frequency_fnl.value" $set_manual_reference_clock_frequency
        #ip_set "parameter.output_clock_frequency.value" $f_out_frac
        dict set manual_list refclk $set_manual_reference_clock_frequency
        dict set manual_list outclk $f_out_frac
      } 
    }
    ip_set "parameter.manual_list.value" $manual_list
  }
}

#omit units (Hz) and return the integer converted value
proc ::altera_xcvr_fpll_s10::parameters::omit_units { freq } { 
  regsub -nocase -all {\D} $freq "" temp
  return [expr (wide($temp))]
}

#convert range lists to standard TCL lists
proc ::altera_xcvr_fpll_s10::parameters::scrub_list_values { my_list } {
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
## Whether in manual-configuration or auto-configuration mode, the procedure creates one common pll_setting to be copied into hdl parameters. 
# depending on the configuration mode the logic pupulating pll_setting changes
proc ::altera_xcvr_fpll_s10::parameters::update_pll_setting { set_primary_use select_manual_config message_level auto_list manual_list set_enable_fractional set_auto_reference_clock_frequency set_fref_clock_frequency set_output_clock_frequency } {
  # starting with an empty list  
  ip_set "parameter.pll_setting.value" ""
  
  if { !$select_manual_config } {
    
    set auto_list_size [dict size $auto_list]
    # debug 
    #ip_message warning "Dict Size of auto_list is $auto_list_size"

    if { $auto_list_size==0 } {
      # no need to print this has already been detected
      #ip_message $message_level "::altera_xcvr_atx_pll_vi::parameters::update_pll_setting::  argument size 0"
    } else {
      if { $set_enable_fractional } {
        set refclk $set_fref_clock_frequency
      } else {
        set refclk $set_auto_reference_clock_frequency
      }
      # format the refclk before checking the dict. Note that dict has refclk in %.6f format
      set refclk [format "%.6f" $refclk]
      #debug 
      #ip_message warning "set_auto_reference_clock_frequency formatted is $ref_clk_freq_formatted" 
      if { ![dict exists $auto_list $refclk] } {
        ip_message $message_level "Selected reference clock frequency ($refclk MHz) is not valid."
      } else {
          # get the line in dictionary with selected frequency  
        set selected_item [dict get $auto_list $refclk]
        
        # populate temp with info from calculation result 
        dict set temp refclk $refclk
        dict set temp m_cnt  [dict get $selected_item m]
        dict set temp n_cnt  [dict get $selected_item n]
        dict set temp l_cnt  [dict get $selected_item l]
        dict set temp c_cnt  [dict get $selected_item c]
        dict set temp k_cnt  [dict get $selected_item k]
             
        #debug 
        #ip_message warning "temp counters: $temp"
        # populate temp with output frequency using user input 
        # if we are in this point user input is already validated
        # with Mhz appended
        dict set temp vco_freq [dict get $selected_item vco]
        dict set temp pfd_freq [dict get $selected_item pfd]
        ip_set "parameter.pll_setting.value" $temp
      }
    }
  } else {;#manual config mode
    #TODO:
    set manual_list_size [dict size $manual_list]
    if { $manual_list_size==0 } {
      # no need to print this has already been detected
      #ip_message $message_level "::altera_xcvr_fpll_s10::parameters::update_pll_setting::  argument size 0"
    } else {
      
      if {[dict get $manual_list refclk] != "NOVAL"} {
        dict set temp refclk [format "%.6f" [dict get $manual_list refclk]]
      }
      if {[dict get $manual_list outclk] != "NOVAL"} {
        dict set temp outclk [format "%.6f" [dict get $manual_list outclk]]
      }
      
      if {[dict get $manual_list m] != "NOVAL"} {
        dict set temp m_cnt [dict get $manual_list m] 
      }
     
      if {[dict get $manual_list n] != "NOVAL"} {
        dict set temp n_cnt [dict get $manual_list n] 
      }
      
      if {[dict get $manual_list l] != "NOVAL"} {
        dict set temp l_cnt [dict get $manual_list l] 
      }
      
      if {[dict get $manual_list c] != "NOVAL"} {
        dict set temp c_cnt [dict get $manual_list c] 
      }
      
      if {[dict get $manual_list k] != "NOVAL"} {
        dict set temp k_cnt [dict get $manual_list k]
      }
      
      if {[dict get $manual_list vco] != "NOVAL"} {
        dict set temp vco_freq [dict get $manual_list vco]
      }
      
      if {[dict get $manual_list pfd] != "NOVAL"} {
        dict set temp pfd_freq [dict get $manual_list pfd]
      }

      ip_set "parameter.pll_setting.value" $temp
    }
  }
}

# case:356430
#TODO: create a RBC rule for these 
proc ::altera_xcvr_fpll_s10::parameters::obtain_m_counter_values { cmu_fpll_prot_mode cmu_fpll_dsm_mode } {
  if [expr { ($cmu_fpll_prot_mode=="unused") }] {
    set legal_values [list 10]
  } else {
    # Integer mode
    if { $cmu_fpll_dsm_mode=="dsm_mode_integer" } { 
      set legal_values [list 8:127]
    } else {
      set legal_values [list 11:123]
    }
  }
  return [lsort -integer -increasing [scrub_list_values $legal_values]]
} 

#TODO: create a RBC rule for these 
proc ::altera_xcvr_fpll_s10::parameters::obtain_n_counter_values { cmu_fpll_prot_mode } { 

  if [expr { ((($cmu_fpll_prot_mode=="unused")||((($cmu_fpll_prot_mode=="pcie_gen1_tx")||($cmu_fpll_prot_mode=="pcie_gen2_tx"))||($cmu_fpll_prot_mode=="pcie_gen3_tx")))||($cmu_fpll_prot_mode=="iqtxrxclk_fb")) }] {
    set legal_values [list 1]
  } else {
    set legal_values [list 1:31] 
  }
 
  return [lsort -integer -increasing [scrub_list_values $legal_values]]
}

#TODO: create a RBC rule for these 
proc ::altera_xcvr_fpll_s10::parameters::obtain_l_counter_values { cmu_fpll_prot_mode } {
  if [expr { ($cmu_fpll_prot_mode=="unused") }] {
    set legal_values [list 2]
  } else {
    set legal_values [list 1 2 4 8]
  }

  return [lsort -integer -increasing [scrub_list_values $legal_values]]
}

#TODO: create a RBC rule for these 
proc ::altera_xcvr_fpll_s10::parameters::obtain_c_counter_values { cmu_fpll_prot_mode } {
  if [expr { ($cmu_fpll_prot_mode=="unused") }] {
    set legal_values [list 2]
  } else {
    set legal_values [list 1:512]
  }

  return [lsort -integer -increasing [scrub_list_values $legal_values]]
}

#TODO: create a RBC rule 
proc ::altera_xcvr_fpll_s10::parameters::obtain_f_ref_limits { limit_type } {
  if { $limit_type == "min" } {
    set limit_value "61440000"
  } elseif { $limit_type == "max" } {
    set limit_value "800000000"
  } else {
    ip_message error "call to obtain_f_ref_limits did not specify limit type. Valid values are min and max."
  } 
  return $limit_value
}

#TODO: create a RBC rule 
proc ::altera_xcvr_fpll_s10::parameters::obtain_f_min_pfd_limit { mode } {
  if { $mode == 0 } { ;# core 
    set limit_value "29000000"
  } elseif { $mode == 1 || $mode == 2 } { ;#cascade and XCVR mode 
    set limit_value "50000000"
  } else {
    ip_message error "call to obtain_f_min_pfd_limit did not specify the mode. Valid values are 0,1 and 2."
  }
  return $limit_value 
}


######################################## 
#  misc functions 
########################################


